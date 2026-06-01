import db from '../config/db.js';

export const bookAppointment = async (req, res) => {
  try {
    const { regNo, department, doctor, priority, apptDate, apptTime, reason, branch_id } = req.body;

    if (!regNo || !department || !apptDate) {
      return res.status(400).json({ success: false, message: 'RegNo, Department, and Date are required' });
    }

    const [result] = await db.query(
      `INSERT INTO appointments (reg_no, department, doctor, priority, appt_date, appt_time, reason, branch_id)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [regNo, department, doctor, priority || 'Routine', apptDate, apptTime, reason, branch_id || null]
    );

    res.status(201).json({
      success: true,
      message: 'Appointment booked successfully',
      appointmentId: result.insertId
    });

  } catch (error) {
    console.error('Error booking appointment:', error);
    res.status(500).json({ success: false, message: 'Server error booking appointment' });
  }
};

export const getAppointments = async (req, res) => {
  try {
    const { branch_id, date } = req.query;
    let query = 'SELECT * FROM appointments WHERE 1=1';
    const params = [];

    if (branch_id) {
      query += ' AND branch_id = ?';
      params.push(branch_id);
    }

    if (date) {
      query += ' AND appt_date = ?';
      params.push(date);
    }

    query += ' ORDER BY appt_date ASC, appt_time ASC';

    const [rows] = await db.query(query, params);
    res.json({ success: true, appointments: rows });
  } catch (error) {
    console.error('Error fetching appointments:', error);
    res.status(500).json({ success: false, message: 'Server error fetching appointments' });
  }
};
