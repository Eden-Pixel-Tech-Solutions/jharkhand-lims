import mysql from 'mysql2/promise';
import dotenv from 'dotenv';
dotenv.config();

const pool = mysql.createPool({
  host:     process.env.DB_HOST     || 'localhost',
  user:     process.env.DB_USER     || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME     || 'meril-hims',
  port:     process.env.DB_PORT     || 8889,
  multipleStatements: true,
});

async function run() {
  const conn = await pool.getConnection();
  try {
    // ── 1. branch_hmis_config ────────────────────────────────────────────────
    const [branchCfgTbl] = await conn.query("SHOW TABLES LIKE 'branch_hmis_config'");
    if (branchCfgTbl.length === 0) {
      await conn.query(`
        CREATE TABLE branch_hmis_config (
          id                        INT AUTO_INCREMENT PRIMARY KEY,
          branch_id                 INT NOT NULL,
          integration_type          ENUM('CDAC','CARE','NONE') NOT NULL DEFAULT 'NONE',
          hmis_hosp_mapping_code    VARCHAR(50) DEFAULT NULL,
          api_access_key_override  VARCHAR(255) DEFAULT NULL,
          is_active                 TINYINT(1) NOT NULL DEFAULT 1,
          notes                     VARCHAR(255) DEFAULT NULL,
          created_at                TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at                TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
          UNIQUE KEY uq_branch_hmis_config_branch (branch_id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
      `);
      console.log('✅ branch_hmis_config table created');
    } else {
      console.log('⏩ branch_hmis_config table already exists');
    }

    // ── 2. cdac_lab_requisitions ─────────────────────────────────────────────
    const [reqTbl] = await conn.query("SHOW TABLES LIKE 'cdac_lab_requisitions'");
    if (reqTbl.length === 0) {
      await conn.query(`
        CREATE TABLE cdac_lab_requisitions (
          id                      INT AUTO_INCREMENT PRIMARY KEY,
          bill_item_id            INT NOT NULL,
          branch_id               INT NOT NULL,
          hmis_hosp_mapping_code  VARCHAR(50) NOT NULL,
          hmis_patCrNo            VARCHAR(50) NOT NULL,
          hmis_episode_code       VARCHAR(50) DEFAULT NULL,
          hmis_episode_visitno    VARCHAR(50) DEFAULT NULL,
          hmis_req_no             VARCHAR(50) NOT NULL,
          hmis_req_dno            VARCHAR(50) NOT NULL,
          hmis_lab_code           VARCHAR(50) DEFAULT NULL,
          hmis_test_code          VARCHAR(50) DEFAULT NULL,
          hmis_test_name          VARCHAR(200) DEFAULT NULL,
          hmis_sample_code        VARCHAR(50) DEFAULT NULL,
          hmis_sample_name        VARCHAR(200) DEFAULT NULL,
          req_type                VARCHAR(10) DEFAULT NULL,
          cdac_inv_status         VARCHAR(10) DEFAULT NULL,
          last_pushed_status      VARCHAR(30) DEFAULT NULL,
          last_pushed_at          TIMESTAMP NULL DEFAULT NULL,
          last_push_error         TEXT DEFAULT NULL,
          created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
          UNIQUE KEY uq_cdac_req_bill_item (bill_item_id),
          UNIQUE KEY uq_cdac_req_dno (hmis_req_dno),
          KEY idx_cdac_req_patcrno (hmis_patCrNo),
          KEY idx_cdac_req_branch (branch_id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
      `);
      console.log('✅ cdac_lab_requisitions table created');
    } else {
      console.log('⏩ cdac_lab_requisitions table already exists');
    }

    // ── 3. cdac_master_data_cache ────────────────────────────────────────────
    const [cacheTbl] = await conn.query("SHOW TABLES LIKE 'cdac_master_data_cache'");
    if (cacheTbl.length === 0) {
      await conn.query(`
        CREATE TABLE cdac_master_data_cache (
          id                      INT AUTO_INCREMENT PRIMARY KEY,
          hmis_hosp_mapping_code  VARCHAR(50) NOT NULL,
          category                ENUM('LAB','SAMPLE','TEST','UOM','SAMPLE_MAPPING','OTHER') NOT NULL,
          code                    VARCHAR(50) NOT NULL,
          name                    VARCHAR(255) DEFAULT NULL,
          raw_json                JSON DEFAULT NULL,
          synced_at               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
          UNIQUE KEY uq_cdac_master_data (hmis_hosp_mapping_code, category, code)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
      `);
      console.log('✅ cdac_master_data_cache table created');
    } else {
      console.log('⏩ cdac_master_data_cache table already exists');
    }

    // ── 4. cdac_test_code_map ────────────────────────────────────────────────
    const [testMapTbl] = await conn.query("SHOW TABLES LIKE 'cdac_test_code_map'");
    if (testMapTbl.length === 0) {
      await conn.query(`
        CREATE TABLE cdac_test_code_map (
          id                      INT AUTO_INCREMENT PRIMARY KEY,
          hmis_hosp_mapping_code  VARCHAR(50) NOT NULL,
          hmis_lab_code           VARCHAR(50) DEFAULT NULL,
          hmis_test_code          VARCHAR(50) NOT NULL,
          hmis_test_name          VARCHAR(200) DEFAULT NULL,
          hmis_sample_code        VARCHAR(50) DEFAULT NULL,
          lab_test_id             INT DEFAULT NULL,
          mapping_status          ENUM('Mapped','Placeholder','Unmapped') NOT NULL DEFAULT 'Unmapped',
          created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
          UNIQUE KEY uq_cdac_test_code (hmis_hosp_mapping_code, hmis_test_code)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
      `);
      console.log('✅ cdac_test_code_map table created');
    } else {
      console.log('⏩ cdac_test_code_map table already exists');
    }

    // ── 5. cdac_parameter_map ────────────────────────────────────────────────
    const [paramMapTbl] = await conn.query("SHOW TABLES LIKE 'cdac_parameter_map'");
    if (paramMapTbl.length === 0) {
      await conn.query(`
        CREATE TABLE cdac_parameter_map (
          id                          INT AUTO_INCREMENT PRIMARY KEY,
          hmis_hosp_mapping_code      VARCHAR(50) DEFAULT NULL,
          hmis_lab_code               VARCHAR(50) DEFAULT NULL,
          hmis_test_code              VARCHAR(50) DEFAULT NULL,
          hmis_sample_code            VARCHAR(50) DEFAULT NULL,
          hmis_parameter_code         VARCHAR(50) DEFAULT NULL,
          hmis_parent_parameter_code  VARCHAR(50) DEFAULT NULL,
          hmis_str_uom                VARCHAR(50) DEFAULT NULL,
          lab_test_parameter_id       INT DEFAULT NULL,
          mapping_status              ENUM('Mapped','Unmapped') NOT NULL DEFAULT 'Unmapped',
          notes                       VARCHAR(255) DEFAULT NULL,
          created_at                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
      `);
      console.log('✅ cdac_parameter_map table created');
    } else {
      console.log('⏩ cdac_parameter_map table already exists');
    }

    // ── 6. cdac_integration_logs ─────────────────────────────────────────────
    const [logsTbl] = await conn.query("SHOW TABLES LIKE 'cdac_integration_logs'");
    if (logsTbl.length === 0) {
      await conn.query(`
        CREATE TABLE cdac_integration_logs (
          id                INT AUTO_INCREMENT PRIMARY KEY,
          operation         VARCHAR(50) NOT NULL,
          hmis_request_type VARCHAR(10) DEFAULT NULL,
          bill_item_id      INT DEFAULT NULL,
          hmis_req_no       VARCHAR(50) DEFAULT NULL,
          hmis_req_dno      VARCHAR(50) DEFAULT NULL,
          hmis_patCrNo      VARCHAR(50) DEFAULT NULL,
          branch_id         INT DEFAULT NULL,
          request_payload   JSON DEFAULT NULL,
          response_payload  JSON DEFAULT NULL,
          http_status       INT DEFAULT NULL,
          success           TINYINT(1) NOT NULL DEFAULT 0,
          error_message     TEXT DEFAULT NULL,
          duration_ms       INT DEFAULT NULL,
          created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          KEY idx_cdac_logs_bill_item (bill_item_id),
          KEY idx_cdac_logs_operation (operation, created_at),
          KEY idx_cdac_logs_success (success)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
      `);
      console.log('✅ cdac_integration_logs table created');
    } else {
      console.log('⏩ cdac_integration_logs table already exists');
    }

    // ── 7. seed branch_hmis_config from the district rule ───────────────────
    const [seedResult] = await conn.query(`
      INSERT IGNORE INTO branch_hmis_config (branch_id, integration_type, is_active, notes)
      SELECT b.id,
             CASE WHEN d.name = 'Ramgarh' THEN 'CARE' ELSE 'CDAC' END,
             CASE WHEN d.name = 'Ramgarh' THEN 0 ELSE 1 END,
             CASE WHEN d.name = 'Ramgarh' THEN 'Care HIMS outbound not yet built' ELSE 'hmis_hosp_mapping_code pending from CDAC' END
      FROM branches b
      JOIN districts d ON b.district_id = d.id
    `);
    console.log(`✅ branch_hmis_config seeded (${seedResult.affectedRows} row(s) inserted, existing rows untouched)`);

    console.log('\n✅ CDAC integration migration complete.');
  } catch (err) {
    console.error('❌ Migration error:', err.message);
    process.exit(1);
  } finally {
    conn.release();
    await pool.end();
  }
}

run();
