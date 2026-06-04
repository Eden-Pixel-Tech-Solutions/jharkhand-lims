import db from '../config/db.js';

// Get all machines for a lab
export const getLabMachines = async (req, res) => {
  try {
    const { labId } = req.params;
    const [machines] = await db.query(
      'SELECT * FROM lab_machines WHERE lab_id = ? ORDER BY created_at DESC',
      [labId]
    );
    res.json({ success: true, machines });
  } catch (error) {
    console.error('Error fetching lab machines:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Get network machines for dashboard (grouped by branch)
export const getNetworkMachines = async (req, res) => {
  try {
    const query = `
      SELECT
        i.name AS branchName,
        lm.id AS db_id,
        lm.machine_id AS id,
        CONCAT(lm.manufacturer, ' ', lm.model) AS name,
        lm.model AS type,
        lm.status AS status,
        lm.serial_number,
        (
          SELECT COUNT(*) FROM lab_test_result ltr
          WHERE ltr.machine_no = lm.machine_id
          AND ltr.tested_at >= NOW() - INTERVAL 1 DAY
        ) AS testsDone
      FROM lab_machines lm
      LEFT JOIN infrastructure i ON lm.lab_id = i.id
      ORDER BY i.name ASC, lm.machine_id ASC
    `;
    const [rows] = await db.query(query);

    // Group by branchName
    const grouped = rows.reduce((acc, curr) => {
      let branch = acc.find(b => b.branchName === curr.branchName);
      if (!branch) {
        branch = { branchName: curr.branchName || 'Unassigned Lab', machines: [] };
        acc.push(branch);
      }
      branch.machines.push({
        id: curr.id || curr.serial_number,
        name: curr.name,
        type: curr.type || 'Unknown Analyzer',
        status: curr.status || 'Offline',
        testsDone: curr.testsDone || 0
      });
      return acc;
    }, []);

    res.json({ success: true, data: grouped });
  } catch (error) {
    console.error('Error fetching network machines:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Get machine by Serial Number
export const getMachineBySerial = async (req, res) => {
  try {
    const { serialNumber } = req.params;
    const [machines] = await db.query(
      'SELECT * FROM lab_machines WHERE serial_number = ? LIMIT 1',
      [serialNumber]
    );
    if (machines.length === 0) {
      return res.json({ success: false, message: 'Machine not found' });
    }
    res.json({ success: true, machine: machines[0] });
  } catch (error) {
    console.error('Error fetching machine by serial:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Add or Update machine (Cloud Sync)
export const syncLabMachine = async (req, res) => {
  try {
    const { 
      lab_id, machine_id, name, model, manufacturer, 
      serial_number, interface_type, port_ip, baud_rate 
    } = req.body;

    if (!serial_number) {
      return res.status(400).json({ success: false, message: 'Serial number is required for syncing' });
    }

    // Check if machine with this serial exists
    const [existing] = await db.query('SELECT id FROM lab_machines WHERE serial_number = ?', [serial_number]);

    if (existing.length > 0) {
      await db.query(
        `UPDATE lab_machines
         SET lab_id = ?, machine_id = ?, name = ?, model = ?, manufacturer = ?,
             interface_type = ?, port_ip = ?, baud_rate = ?, updated_at = NOW()
         WHERE serial_number = ?`,
        [lab_id, machine_id, name, model, manufacturer, interface_type, port_ip, baud_rate, serial_number]
      );
      // Auto-assign all tests for this analyzer to this lab
      if (model && lab_id) {
        await db.query(`UPDATE lab_tests SET lab_id = ? WHERE analyzer_name = ?`, [lab_id, model]);
      }
      res.json({ success: true, message: 'Machine synced (Updated)', id: existing[0].id });
    } else {
      const [result] = await db.query(
        `INSERT INTO lab_machines
         (lab_id, machine_id, name, model, manufacturer, serial_number, interface_type, port_ip, baud_rate)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [lab_id, machine_id, name, model, manufacturer, serial_number, interface_type, port_ip, baud_rate]
      );
      // Auto-assign all tests for this analyzer to this lab
      if (model && lab_id) {
        await db.query(`UPDATE lab_tests SET lab_id = ? WHERE analyzer_name = ?`, [lab_id, model]);
      }
      res.status(201).json({ success: true, message: 'Machine synced (Created)', id: result.insertId });
    }
  } catch (error) {
    console.error('Error syncing lab machine:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

export const addLabMachine = async (req, res) => {
  try {
    const { lab_id, machine_id, name, model, manufacturer } = req.body;
    const [result] = await db.query(
      'INSERT INTO lab_machines (lab_id, machine_id, name, model, manufacturer) VALUES (?, ?, ?, ?, ?)',
      [lab_id, machine_id, name, model || '', manufacturer || '']
    );
    // Auto-assign all tests for this analyzer to this lab
    if (model && lab_id) {
      await db.query(`UPDATE lab_tests SET lab_id = ? WHERE analyzer_name = ?`, [lab_id, model]);
    }
    res.status(201).json({ success: true, id: result.insertId });
  } catch (err) { res.status(500).json({ success: false }); }
};

export const updateLabMachine = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, model, manufacturer, status } = req.body;
    await db.query('UPDATE lab_machines SET name = ?, model = ?, manufacturer = ?, status = ? WHERE id = ?', [name, model, manufacturer, status, id]);
    res.json({ success: true });
  } catch (err) { res.status(500).json({ success: false }); }
};

export const deleteLabMachine = async (req, res) => {
  try {
    const { id } = req.params;
    // Get the machine before deleting so we can clear lab_tests
    const [[machine]] = await db.query('SELECT lab_id, model FROM lab_machines WHERE id = ?', [id]);
    await db.query('DELETE FROM lab_machines WHERE id = ?', [id]);
    // Clear lab assignment on tests for this analyzer if no other machine of same model remains in any lab
    if (machine?.model) {
      const [remaining] = await db.query(
        'SELECT id FROM lab_machines WHERE model = ? LIMIT 1', [machine.model]
      );
      if (remaining.length === 0) {
        await db.query(`UPDATE lab_tests SET lab_id = NULL WHERE analyzer_name = ?`, [machine.model]);
      }
    }
    res.json({ success: true });
  } catch (err) { res.status(500).json({ success: false }); }
};

// Log an analyzer ONLINE / OFFLINE event (called by LIS-Agent)
export const logAnalyzerEvent = async (req, res) => {
  try {
    const { machine_id, machine_name, model, lab_id, port, event, ip_address } = req.body;
    if (!machine_id || !event) {
      return res.status(400).json({ success: false, message: 'machine_id and event are required' });
    }
    if (!['ONLINE', 'OFFLINE'].includes(event)) {
      return res.status(400).json({ success: false, message: 'event must be ONLINE or OFFLINE' });
    }

    await db.query(
      `INSERT INTO analyzer_connection_logs
         (machine_id, machine_name, model, lab_id, port, event, ip_address)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [machine_id, machine_name || null, model || null, lab_id || null, port || null, event, ip_address || null]
    );

    // Keep lab_machines.status in sync
    if (machine_id) {
      await db.query(
        `UPDATE lab_machines SET status = ? WHERE machine_id = ?`,
        [event === 'ONLINE' ? 'Online' : 'Offline', machine_id]
      );
    }

    res.json({ success: true });
  } catch (err) {
    console.error('Error logging analyzer event:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Get analyzer connection/disconnection history
export const getAnalyzerLogs = async (req, res) => {
  try {
    const { lab_id, machine_id, event, limit = 200 } = req.query;

    let where = [];
    let params = [];

    if (lab_id) { where.push('acl.lab_id = ?'); params.push(lab_id); }
    if (machine_id) { where.push('acl.machine_id = ?'); params.push(machine_id); }
    if (event) { where.push('acl.event = ?'); params.push(event.toUpperCase()); }

    const whereClause = where.length ? `WHERE ${where.join(' AND ')}` : '';
    params.push(parseInt(limit, 10) || 200);

    const [logs] = await db.query(
      `SELECT
         acl.id,
         acl.machine_id,
         acl.machine_name,
         acl.model,
         acl.lab_id,
         i.name AS lab_name,
         acl.port,
         acl.event,
         acl.ip_address,
         acl.created_at
       FROM analyzer_connection_logs acl
       LEFT JOIN infrastructure i ON acl.lab_id = i.id
       ${whereClause}
       ORDER BY acl.created_at DESC
       LIMIT ?`,
      params
    );

    res.json({ success: true, logs });
  } catch (err) {
    console.error('Error fetching analyzer logs:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// Comprehensive stats for admin dashboard
export const getMachineStats = async (req, res) => {
  try {
    const { lab_id } = req.query;
    // Optional WHERE clause when scoping to a single lab
    const labWhere  = lab_id ? `WHERE lm.lab_id = ${db.escape(lab_id)}`      : '';
    const labFilter = lab_id ? `WHERE lab_id   = ${db.escape(lab_id)}`        : '';
    const labJoinWhere = lab_id ? `AND lm.lab_id = ${db.escape(lab_id)}`      : '';

    // Overall totals
    const [[totals]] = await db.query(`
      SELECT
        COUNT(*)                                                          AS total,
        SUM(CASE WHEN status = 'Online'  THEN 1 ELSE 0 END)             AS online,
        SUM(CASE WHEN status = 'Offline' THEN 1 ELSE 0 END)             AS offline,
        SUM(CASE WHEN status NOT IN ('Online','Offline') OR status IS NULL THEN 1 ELSE 0 END) AS unknown
      FROM lab_machines
      ${labFilter}
    `);

    // Tests done today (scoped to lab if provided)
    const testWhere = lab_id
      ? `WHERE ltr.tested_at >= CURDATE() AND ltr.machine_no IN (SELECT machine_id FROM lab_machines WHERE lab_id = ${db.escape(lab_id)})`
      : `WHERE tested_at >= CURDATE()`;
    const [[testStats]] = await db.query(
      `SELECT COUNT(*) AS tests_today FROM lab_test_result ltr ${testWhere}`
    );

    // Brand-wise
    const [brands] = await db.query(`
      SELECT
        COALESCE(manufacturer, 'Unknown')                                AS brand,
        COUNT(*)                                                          AS total,
        SUM(CASE WHEN status = 'Online'  THEN 1 ELSE 0 END)             AS online,
        SUM(CASE WHEN status = 'Offline' THEN 1 ELSE 0 END)             AS offline
      FROM lab_machines
      ${labFilter}
      GROUP BY manufacturer
      ORDER BY total DESC
    `);

    // Model-wise
    const [models] = await db.query(`
      SELECT
        COALESCE(model, 'Unknown')                                        AS model,
        COALESCE(manufacturer, 'Unknown')                                 AS brand,
        COUNT(*)                                                          AS total,
        SUM(CASE WHEN status = 'Online'  THEN 1 ELSE 0 END)             AS online,
        SUM(CASE WHEN status = 'Offline' THEN 1 ELSE 0 END)             AS offline
      FROM lab_machines
      ${labFilter}
      GROUP BY model, manufacturer
      ORDER BY total DESC
    `);

    // Lab / Hospital-wise (omit for single-lab view)
    let labs = [];
    if (!lab_id) {
      [labs] = await db.query(`
        SELECT
          COALESCE(i.name, 'Unassigned')                                 AS lab_name,
          lm.lab_id,
          COUNT(lm.id)                                                    AS total,
          SUM(CASE WHEN lm.status = 'Online'  THEN 1 ELSE 0 END)       AS online,
          SUM(CASE WHEN lm.status = 'Offline' THEN 1 ELSE 0 END)       AS offline
        FROM lab_machines lm
        LEFT JOIN infrastructure i ON lm.lab_id = i.id
        GROUP BY lm.lab_id, i.name
        ORDER BY total DESC
      `);
    }

    // Per-machine detail
    const [machines] = await db.query(`
      SELECT
        lm.id,
        lm.machine_id,
        lm.name         AS machine_name,
        lm.model,
        COALESCE(lm.manufacturer, 'Unknown')   AS brand,
        lm.serial_number,
        lm.interface_type,
        lm.port_ip,
        COALESCE(lm.status, 'Unknown')         AS status,
        lm.lab_id,
        COALESCE(i.name, 'Unassigned')         AS lab_name,
        (SELECT MAX(acl.created_at) FROM analyzer_connection_logs acl
           WHERE acl.machine_id = lm.machine_id AND acl.event = 'ONLINE')  AS last_online,
        (SELECT MAX(acl.created_at) FROM analyzer_connection_logs acl
           WHERE acl.machine_id = lm.machine_id AND acl.event = 'OFFLINE') AS last_offline,
        (SELECT COUNT(*) FROM lab_test_result ltr
           WHERE ltr.machine_no = lm.machine_id
             AND ltr.tested_at >= NOW() - INTERVAL 24 HOUR)               AS tests_today
      FROM lab_machines lm
      LEFT JOIN infrastructure i ON lm.lab_id = i.id
      ${labWhere}
      ORDER BY lm.lab_id, lm.machine_id
    `);

    res.json({
      success: true,
      totals: { ...totals, tests_today: testStats.tests_today },
      brands,
      models,
      labs,
      machines,
    });
  } catch (err) {
    console.error('Error fetching machine stats:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};
