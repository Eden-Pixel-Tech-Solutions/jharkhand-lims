import jwt from 'jsonwebtoken';

// Maps legacy DB role slugs → canonical display names used in route guards
const ROLE_ALIASES = {
  'admin':        'Admin',
  'lab_tech':     'Lab Technician',
  'lab_doctor':   'Lab Head',
  'lab doctor':   'Lab Head',
  'receptionist': 'Receptionist',
  'phlebotomist': 'Phlebotomist',
};

const normalizeRole = (role = '') =>
  ROLE_ALIASES[role.toLowerCase()] ?? role;

export const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ message: 'Access denied. No token provided.' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET, { algorithms: ['HS256'] });
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(403).json({ message: 'Invalid or expired token' });
  }
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
