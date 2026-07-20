import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import crypto from 'crypto';
import db from '../config/db.js';
import { createCaptcha, verifyCaptcha } from '../utils/captchaStore.js';
import { issueCsrfToken } from '../utils/csrfStore.js';
import { getBlockedUntil, recordLoginFailure, recordLoginSuccess } from '../utils/bruteForceGuard.js';

// Every JWT gets its own random `sid` (one per login, not per user) so the
// CSRF token store — keyed by sid — gives each login/tab an independent
// token lifecycle instead of racing with other sessions for the same user.
const generateToken = (id, role, branch_id, role_level) => {
  const sid = crypto.randomUUID();
  const token = jwt.sign({ id, role, branch_id, role_level, sid }, process.env.JWT_SECRET, {
    expiresIn: '30d',
  });
  return { token, csrfToken: issueCsrfToken(sid) };
};

// VAPT #9 (Cookie Header Not Implemented): the session token lives only in
// an HttpOnly cookie now — never in a JS-readable response field or
// localStorage — so an XSS on any page can no longer read it out. Secure is
// forced in production (the only environment actually served over HTTPS);
// SameSite=None is required for it to survive the frontend/API being on
// different origins there. COOKIE_DOMAIN is optional — omitting Domain
// makes the cookie host-only, which is already the most restrictive scope,
// so it's only needed if the API and frontend share a parent domain and the
// cookie must be sent to both.
const isProd = process.env.NODE_ENV === 'production';
const AUTH_COOKIE_NAME = 'hims_token';
const authCookieOptions = () => ({
  httpOnly: true,
  secure: isProd,
  sameSite: isProd ? 'none' : 'lax',
  path: '/',
  maxAge: 30 * 24 * 60 * 60 * 1000, // matches the JWT's 30d expiry
  ...(process.env.COOKIE_DOMAIN ? { domain: process.env.COOKIE_DOMAIN } : {}),
});

export const register = async (req, res) => {
  const { firstName, lastName, email, phone, role, department, staffId, password, role_level = 'Branch', newBranchName, newHospitalCode, newDistrictId } = req.body;
  let { branch_id = 1 } = req.body;

  try {
    // Check if user exists
    const [existingUsers] = await db.query('SELECT id FROM users WHERE email = ?', [email]);
    if (existingUsers.length > 0) {
      return res.status(400).json({ message: 'User already exists' });
    }

    // Handle new branch creation
    if (branch_id === 'NEW' && newBranchName && newHospitalCode && newDistrictId) {
      try {
        const [branchResult] = await db.query(
          `INSERT INTO branches (district_id, branch_name, category, hospital_code, status, branch_level) VALUES (?, ?, 'General Hospital', UPPER(?), 'Active', 'Center')`,
          [newDistrictId, newBranchName, newHospitalCode]
        );
        branch_id = branchResult.insertId;
      } catch (branchErr) {
        if (branchErr.code === '23505') {
          return res.status(400).json({ message: 'Hospital Code already exists' });
        }
        throw branchErr;
      }
    }

      // Hash password
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(password, salt);

      // Create user query
      const query = `
        INSERT INTO users (first_name, last_name, email, phone, role, department, staff_id, password, branch_id, role_level) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `;
      const values = [firstName, lastName, email, phone || null, role, department, staffId || null, hashedPassword, branch_id, role_level];

    const [result] = await db.query(query, values);

    if (result.insertId) {
      // This endpoint requires an already-authenticated Admin/Lab Head/Doctor
      // (see authRoutes.js) creating another user's account — it must not
      // also log the caller in as that new user, so no token/cookie is
      // issued here. The new user gets their own session on their own login.
      res.status(201).json({
        id: result.insertId,
        firstName,
        lastName,
        email,
        role,
        branch_id,
        role_level,
      });
    } else {
      res.status(400).json({ message: 'Invalid user data' });
    }
  } catch (error) {
    console.error(error);
    
    // Check if table missing error (ER_NO_SUCH_TABLE)
    if (error.code === '42P01') {
      return res.status(500).json({ message: 'Database tables not created yet.' });
    }
    
    res.status(500).json({ message: 'Server error during registration' });
  }
};

export const getCaptcha = (req, res) => {
  const { captchaId, svg } = createCaptcha();
  res.json({ captchaId, svg });
};

export const login = async (req, res) => {
  const { email, password, captchaId, captchaText } = req.body;
  const clientIp = req.ip;

  // Blocked IPs are rejected before touching the captcha at all — no point
  // burning a freshly-issued captcha on a request that can't succeed anyway.
  const blockedUntil = getBlockedUntil(clientIp);
  if (blockedUntil) {
    res.setHeader('Retry-After', Math.ceil((blockedUntil - Date.now()) / 1000));
    return res.status(429).json({
      message: 'Too many failed login attempts from this network. Try again in 24 hours.',
      blockedUntil: new Date(blockedUntil).toISOString(),
    });
  }

  // A wrong credential must never leave the previous CAPTCHA usable for a
  // retry, so every failure path below returns a freshly generated one.
  if (!verifyCaptcha(captchaId, captchaText)) {
    return res.status(400).json({ message: 'Invalid or expired captcha', captcha: createCaptcha() });
  }

  try {
    const [users] = await db.query(`
      SELECT u.*, b.hospital_code, b.district_id, b.branch_name
      FROM users u
      LEFT JOIN branches b ON u.branch_id = b.id
      WHERE u.email = ?
    `, [email]);

    if (users.length === 0) {
      recordLoginFailure(clientIp);
      return res.status(401).json({ message: 'Invalid email or password', captcha: createCaptcha() });
    }

    const user = users[0];

    // VAPT #6 (No Account Lock-Out): per-account lockout, layered on top of
    // the IP-based block above — an attacker who rotates source IPs against
    // one specific account is still stopped.
    if (user.locked_until && new Date(user.locked_until) > new Date()) {
      return res.status(423).json({
        message: 'Account temporarily locked due to repeated failed logins. Try again later.',
        lockedUntil: user.locked_until,
        captcha: createCaptcha(),
      });
    }

    // Check password
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      recordLoginFailure(clientIp);
      const attempts = (user.failed_login_attempts || 0) + 1;
      const lockedUntil = attempts >= 5 ? new Date(Date.now() + 15 * 60 * 1000) : null;
      await db.query(
        'UPDATE users SET failed_login_attempts = ?, locked_until = ? WHERE id = ?',
        [attempts, lockedUntil, user.id]
      );
      return res.status(401).json({ message: 'Invalid email or password', captcha: createCaptcha() });
    }

    recordLoginSuccess(clientIp);
    await db.query(
      'UPDATE users SET failed_login_attempts = 0, locked_until = NULL WHERE id = ?',
      [user.id]
    );
    const { token, csrfToken } = generateToken(user.id, user.role, user.branch_id, user.role_level);
    res.cookie(AUTH_COOKIE_NAME, token, authCookieOptions());
    res.json({
      id: user.id,
      firstName: user.first_name,
      lastName: user.last_name,
      email: user.email,
      role: user.role,
      branch_id: user.branch_id,
      role_level: user.role_level,
      hospital_code: user.hospital_code,
      district_id: user.district_id,
      branch_name: user.branch_name,
      passwordChangeRequired: !!user.password_change_required,
      csrfToken,
    });
  } catch (error) {
    console.error(error);

    // The CAPTCHA was already consumed by verifyCaptcha() above, so even on
    // a server error the client needs a new one to retry.
    if (error.code === '42P01') {
      return res.status(500).json({ message: 'Database tables not created yet.', captcha: createCaptcha() });
    }

    res.status(500).json({ message: 'Server error during login', captcha: createCaptcha() });
  }
};

// VAPT #16 (No Compulsory Change Password Functionality): lets an
// authenticated user change their own password, verifying the current one
// first. `password_change_required` is cleared on success so the frontend
// stops force-redirecting here after this call.
export const changePassword = async (req, res) => {
  const { currentPassword, newPassword } = req.body;

  if (!currentPassword || !newPassword || newPassword.length < 8) {
    return res.status(400).json({ message: 'New password must be at least 8 characters.' });
  }

  try {
    const [users] = await db.query('SELECT id, password FROM users WHERE id = ?', [req.user.id]);
    if (users.length === 0) {
      return res.status(404).json({ message: 'User not found' });
    }

    const isMatch = await bcrypt.compare(currentPassword, users[0].password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Current password is incorrect' });
    }

    const salt = await bcrypt.genSalt(10);
    const hashed = await bcrypt.hash(newPassword, salt);

    await db.query(
      'UPDATE users SET password = ?, password_change_required = 0 WHERE id = ?',
      [hashed, req.user.id]
    );

    res.json({ success: true, message: 'Password changed successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error during password change' });
  }
};

// VAPT #9/#5: logout must actually invalidate the session server-side, not
// just rely on the client discarding it — clearCookie's options (path/
// domain/sameSite/secure) have to match what the cookie was set with or the
// browser won't recognize it as the same cookie to remove. Always succeeds:
// a client with no/expired cookie still gets a clean 200.
export const logout = (req, res) => {
  // clearCookie sets its own past Expires to delete the cookie — passing our
  // maxAge alongside it would add a future Max-Age, which browsers prefer
  // over Expires when both are present, silently keeping the cookie alive.
  const { maxAge, ...clearOptions } = authCookieOptions();
  res.clearCookie(AUTH_COOKIE_NAME, clearOptions);
  res.json({ success: true, message: 'Logged out' });
};
