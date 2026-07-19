import express from 'express';
import { register, login, getCaptcha, changePassword } from '../controllers/authController.js';

import { authenticateToken, authorizeRole } from '../middleware/auth.js';
import { loginLimiter, captchaLimiter } from '../middleware/rateLimiter.js';

const router = express.Router();

router.get('/captcha', captchaLimiter, getCaptcha);
router.post('/register', authenticateToken, authorizeRole(['Admin', 'Lab Head', 'Doctor']), register);
router.post('/login', loginLimiter, login);
router.post('/change-password', authenticateToken, changePassword);

export default router;
