const sqlite3 = require("sqlite3").verbose();
const path = require("path");
const fs = require("fs");
const { app, safeStorage } = require("electron");

const dbPath = path.join(app.getPath("userData"), "lis_agent.db");
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) return console.error("Failed to open LIS Agent DB:", err.message);
  // Cached patient sample results shouldn't be world-readable on multi-user machines.
  fs.chmod(dbPath, 0o600, (chmodErr) => {
    if (chmodErr) console.warn("Could not restrict lis_agent.db permissions:", chmodErr.message);
  });
});

// Keys whose values get OS-keychain-encrypted (via safeStorage) before hitting
// disk, instead of being stored as plain SQLite text.
const ENCRYPTED_KEYS = new Set(["authToken"]);
const ENC_PREFIX = "enc:v1:";

function canEncrypt() {
  try {
    return safeStorage.isEncryptionAvailable();
  } catch {
    return false;
  }
}

function encryptValue(value) {
  if (!canEncrypt()) {
    console.warn("[db] OS-level encryption unavailable — storing setting as plaintext.");
    return value;
  }
  return ENC_PREFIX + safeStorage.encryptString(value).toString("base64");
}

function decryptValue(stored) {
  if (stored == null || !stored.startsWith(ENC_PREFIX)) return stored;
  if (!canEncrypt()) {
    console.warn("[db] OS-level encryption unavailable — cannot decrypt stored setting.");
    return null;
  }
  return safeStorage.decryptString(Buffer.from(stored.slice(ENC_PREFIX.length), "base64"));
}

db.serialize(() => {
  db.run(`
    CREATE TABLE IF NOT EXISTS analyzer_config (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      unique_id TEXT UNIQUE,
      analyzer_name TEXT,
      model TEXT,
      port TEXT,
      baud INTEGER,
      lab_id INTEGER,
      lab_name TEXT,
      manufacturer TEXT,
      port_type TEXT,
      serial_number TEXT
    )
  `);
  // Migrate existing databases that predate port_type / serial_number columns
  db.run(`ALTER TABLE analyzer_config ADD COLUMN port_type TEXT`, () => {});
  db.run(`ALTER TABLE analyzer_config ADD COLUMN serial_number TEXT`, () => {});
  db.run(`
    CREATE TABLE IF NOT EXISTS settings (
      key TEXT PRIMARY KEY,
      value TEXT
    )
  `);
});

function saveSetting(key, value) {
  const toStore = ENCRYPTED_KEYS.has(key) && value != null ? encryptValue(value) : value;
  return new Promise((resolve, reject) => {
    db.run(`INSERT OR REPLACE INTO settings (key, value) VALUES (?, ?)`, [key, toStore], (err) => {
      if (err) reject(err);
      else resolve(true);
    });
  });
}

function getSetting(key) {
  return new Promise((resolve, reject) => {
    db.get(`SELECT value FROM settings WHERE key = ?`, [key], (err, row) => {
      if (err) return reject(err);
      if (!row) return resolve(null);
      resolve(ENCRYPTED_KEYS.has(key) ? decryptValue(row.value) : row.value);
    });
  });
}

function saveConfig(config) {
  return new Promise((resolve, reject) => {
    const stmt = db.prepare(`
      INSERT OR REPLACE INTO analyzer_config (unique_id, analyzer_name, model, port, baud, lab_id, lab_name, manufacturer, port_type, serial_number)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `);

    stmt.run(
      config.uniqueId,
      config.name,
      config.model,
      config.port,
      config.baud,
      config.labId,
      config.labName,
      config.manufacturer,
      config.portType || null,
      config.serialNumber || null,
      function (err) {
        if (err) reject(err);
        else resolve(this.lastID);
      }
    );

    stmt.finalize();
  });
}

function getConfig() {
  return new Promise((resolve, reject) => {
    db.all(`SELECT * FROM analyzer_config ORDER BY id DESC`, (err, rows) => {
      if (err) reject(err);
      else resolve(rows); // Return all rows
    });
  });
}

function deleteConfig(id) {
  return new Promise((resolve, reject) => {
    db.run(`DELETE FROM analyzer_config WHERE id = ?`, [id], (err) => {
      if (err) reject(err);
      else resolve(true);
    });
  });
}

module.exports = { saveConfig, getConfig, deleteConfig, saveSetting, getSetting };
