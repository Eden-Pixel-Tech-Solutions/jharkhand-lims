import express from 'express';
import { getStaffStats, getAllStaff, addStaff, getDoctors, updateStaff, deleteStaff } from '../controllers/staffController.js';
import { authenticateToken, authorizeRole } from '../middleware/auth.js';

const router = express.Router();

router.get('/stats',   authenticateToken, getStaffStats);
router.get('/list',    authenticateToken, getAllStaff);
router.get('/doctors', authenticateToken, getDoctors);
router.post('/add',    authenticateToken, authorizeRole(['Admin', 'Super Admin']), addStaff);
router.put('/:id',     authenticateToken, authorizeRole(['Admin', 'Super Admin']), updateStaff);
router.delete('/:id',  authenticateToken, authorizeRole(['Admin', 'Super Admin']), deleteStaff);

export default router;
