import db from '../config/db.js';

// Get all duty schedules with doctor and room info — scoped to branch
export const getDutySchedules = async (req, res) => {
  try {
    const { branch_id } = req.query;
    let query = `
      SELECT ds.*,
             u.first_name as doctor_first_name, u.last_name as doctor_last_name,
             i.name as room_name, i.block, i.floor
      FROM duty_schedules ds
      JOIN users u ON ds.doctor_id = u.id
      JOIN infrastructure i ON ds.room_id = i.id
      WHERE 1=1
    `;
    const params = [];

    if (branch_id) {
      query += ' AND ds.branch_id = ?';
      params.push(branch_id);
    }

    query += ' ORDER BY ds.duty_date DESC, ds.start_time ASC';

    const [rows] = await db.query(query, params);
    res.json({ success: true, schedules: rows });
  } catch (error) {
    console.error('Error fetching duty schedules:', error);
    res.status(500).json({ success: false, message: 'Server error fetching schedules' });
  }
};

// Add a new duty schedule
export const addDutySchedule = async (req, res) => {
  try {
    const { doctorId, roomId, dutyDate, startTime, endTime, price, notes, branch_id } = req.body;

    if (!doctorId || !roomId || !dutyDate || !startTime || !endTime) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields'
      });
    }

    const [result] = await db.query(
      `INSERT INTO duty_schedules (doctor_id, room_id, duty_date, start_time, end_time, price, notes, branch_id)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [doctorId, roomId, dutyDate, startTime, endTime, price || 0.00, notes, branch_id || null]
    );

    res.status(201).json({
      success: true,
      message: 'Duty schedule added successfully',
      id: result.insertId
    });
  } catch (error) {
    console.error('Error adding duty schedule:', error);
    res.status(500).json({ success: false, message: 'Server error adding schedule' });
  }
};

// Delete a duty schedule
export const deleteDutySchedule = async (req, res) => {
  try {
    const { id } = req.params;
    const [result] = await db.query('DELETE FROM duty_schedules WHERE id = ?', [id]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, message: 'Schedule not found' });
    }

    res.json({ success: true, message: 'Duty schedule deleted successfully' });
  } catch (error) {
    console.error('Error deleting duty schedule:', error);
    res.status(500).json({ success: false, message: 'Server error deleting schedule' });
  }
};

// Get doctors on duty for a specific date and time — scoped to branch
export const getAvailableDoctors = async (req, res) => {
  try {
    const { date, time, department, branch_id } = req.query;

    if (!date || !time) {
      return res.status(400).json({ success: false, message: 'Date and Time are required' });
    }

    let query = `
      SELECT DISTINCT u.id, u.first_name, u.last_name, u.department,
             i.name as room_name, i.block, i.floor, ds.price
      FROM duty_schedules ds
      JOIN users u ON ds.doctor_id = u.id
      JOIN infrastructure i ON ds.room_id = i.id
      WHERE ds.duty_date = ?
        AND ? >= ds.start_time
        AND ? <= ds.end_time
    `;
    const params = [date, time, time];

    if (branch_id) {
      query += ' AND ds.branch_id = ?';
      params.push(branch_id);
    }

    if (department) {
      query += ' AND u.department = ?';
      params.push(department);
    }

    query += ' ORDER BY u.department ASC, u.first_name ASC';

    const [rows] = await db.query(query, params);
    res.json({ success: true, doctors: rows });
  } catch (error) {
    console.error('Error fetching available doctors:', error);
    res.status(500).json({ success: false, message: 'Server error fetching availability' });
  }
};
