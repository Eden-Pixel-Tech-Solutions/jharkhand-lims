import db from '../config/db.js';
import bcrypt from 'bcryptjs';

// Branch scope helper — Branch-level users only see their own branch
const branchScope = (req) => {
  const { role_level, branch_id } = req.user;
  if (role_level === 'Central') return null; // no restriction
  return branch_id;
};

export const getStaffStats = async (req, res) => {
  try {
    const scope = branchScope(req);
    const where = scope ? 'WHERE branch_id = ?' : '';
    const params = scope ? [scope] : [];
    const [rows] = await db.query(
      `SELECT role, COUNT(*) AS count FROM users ${where} GROUP BY role`,
      params
    );
    const stats = rows.reduce((acc, row) => { acc[row.role] = row.count; return acc; }, {});
    res.json({ success: true, stats });
  } catch (e) {
    console.error(e);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

export const getDoctors = async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT first_name, last_name, department FROM users WHERE role = "Doctor" ORDER BY department, first_name'
    );
    res.json({ success: true, doctors: rows });
  } catch (e) {
    console.error(e);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

export const getAllStaff = async (req, res) => {
  try {
    const scope = branchScope(req);
    // Central admins can optionally filter by branch_id via query param
    const filterBranch = scope || req.query.branch_id || null;
    const params = [];
    let where = '';
    if (filterBranch) { where = 'WHERE u.branch_id = ?'; params.push(filterBranch); }

    const [rows] = await db.query(
      `SELECT u.id, u.first_name, u.last_name, u.email, u.phone,
              u.role, u.role_level, u.department, u.staff_id,
              u.branch_id, b.branch_name, u.created_at
         FROM users u
         LEFT JOIN branches b ON u.branch_id = b.id
         ${where}
         ORDER BY u.created_at DESC`,
      params
    );
    res.json({ success: true, staff: rows });
  } catch (e) {
    console.error(e);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

export const addStaff = async (req, res) => {
  try {
    const { firstName, lastName, email, phone, role, department, staffId, password, role_level } = req.body;
    if (!email || !password || !role) {
      return res.status(400).json({ success: false, message: 'email, password and role are required' });
    }

    // Determine branch: Branch-level admin can only create staff in their own branch
    const callerScope = branchScope(req);
    const branch_id = callerScope || req.body.branch_id || req.user.branch_id || null;

    // Only Central admins can set role_level; others default to Branch
    const assignedLevel = req.user.role_level === 'Central' ? (role_level || 'Branch') : 'Branch';

    const [existing] = await db.query('SELECT id FROM users WHERE email = ?', [email]);
    if (existing.length > 0) {
      return res.status(400).json({ success: false, message: 'Email already registered' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const [result] = await db.query(
      `INSERT INTO users (first_name, last_name, email, phone, role, department, staff_id, password, branch_id, role_level)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [firstName, lastName, email, phone || null, role, department || null, staffId || null, hashedPassword, branch_id, assignedLevel]
    );
    res.status(201).json({ success: true, message: 'Staff member added successfully', id: result.insertId });
  } catch (e) {
    console.error(e);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

export const updateStaff = async (req, res) => {
  try {
    const { id } = req.params;
    const { firstName, lastName, phone, role, department, role_level, branch_id } = req.body;

    // Branch-level callers can only update staff in their own branch
    const scope = branchScope(req);
    if (scope) {
      const [[member]] = await db.query('SELECT branch_id FROM users WHERE id = ?', [id]);
      if (!member || member.branch_id != scope) {
        return res.status(403).json({ success: false, message: 'Access denied' });
      }
    }

    const assignedLevel = req.user.role_level === 'Central' ? (role_level || 'Branch') : 'Branch';
    const assignedBranch = scope || branch_id || null;

    await db.query(
      `UPDATE users SET first_name=?, last_name=?, phone=?, role=?, department=?, role_level=?, branch_id=? WHERE id=?`,
      [firstName, lastName, phone || null, role, department || null, assignedLevel, assignedBranch, id]
    );
    res.json({ success: true });
  } catch (e) {
    console.error(e);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

export const deleteStaff = async (req, res) => {
  try {
    const { id } = req.params;
    // Prevent self-deletion
    if (id == req.user.id) {
      return res.status(400).json({ success: false, message: 'Cannot delete your own account' });
    }
    const scope = branchScope(req);
    if (scope) {
      const [[member]] = await db.query('SELECT branch_id FROM users WHERE id = ?', [id]);
      if (!member || member.branch_id != scope) {
        return res.status(403).json({ success: false, message: 'Access denied' });
      }
    }
    await db.query('DELETE FROM users WHERE id = ?', [id]);
    res.json({ success: true });
  } catch (e) {
    console.error(e);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};
