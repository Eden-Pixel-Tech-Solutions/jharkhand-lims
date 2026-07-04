import express from 'express';
import { register, login } from '../controllers/authController.js';

import { authenticateToken, authorizeRole } from '../middleware/auth.js';
import { loginLimiter } from '../middleware/rateLimiter.js';

const router = express.Router();

router.post('/register', authenticateToken, authorizeRole(['Admin', 'Lab Head', 'Doctor']), register);
router.post('/login', loginLimiter, login);

export default router;
