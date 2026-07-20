import jwt from 'jsonwebtoken';
import { verifyAndRotateCsrfToken } from '../utils/csrfStore.js';

// Maps legacy DB role slugs → canonical display names used in route guards
const ROLE_ALIASES = {
  'admin':        'Admin',
  'lab_tech':     'Lab Technician',
  'lab_doctor':   'Lab Head',
  'lab doctor':   'Lab Head',
  'receptionist': 'Receptionist',
  'phlebotomist': 'Phlebotomist',
};

export const normalizeRole = (role = '') =>
  ROLE_ALIASES[role.toLowerCase()] ?? role;

const MUTATING_METHODS = new Set(['POST', 'PUT', 'PATCH', 'DELETE']);

export const authenticateToken = (req, res, next) => {
  // VAPT #9 (Cookie Header Not Implemented): the staff session token now
  // lives in an HttpOnly cookie set by authController.login, not in
  // localStorage — a page that reads it into a JS variable could hand it to
  // any XSS. The cookie takes priority; the Authorization header stays as a
  // fallback for non-browser API clients (Postman/scripts) that can't rely
  // on a cookie jar.
  const authHeader = req.headers['authorization'];
  const headerToken = authHeader && authHeader.split(' ')[1];
  const token = req.cookies?.hims_token || headerToken;

  if (!token) {
    return res.status(401).json({ message: 'Access denied. No token provided.' });
  }

  let decoded;
  try {
    decoded = jwt.verify(token, process.env.JWT_SECRET, { algorithms: ['HS256'] });
  } catch (error) {
    return res.status(403).json({ message: 'Invalid or expired token' });
  }

  req.user = decoded;

  if (MUTATING_METHODS.has(req.method)) {
    const rotated = verifyAndRotateCsrfToken(decoded.sid, req.headers['x-csrf-token']);
    if (!rotated) {
      return res.status(403).json({ message: 'Invalid or missing CSRF token' });
    }
    res.setHeader('X-CSRF-Token', rotated);
  }

  next();
};

export const authorizeRole = (roles) => {
  return (req, res, next) => {
    const role = normalizeRole(req.user?.role);
    if (!req.user || !roles.includes(role)) {
      return res.status(403).json({ message: 'Access denied. Insufficient permissions.' });
    }
    next();
  };
};
