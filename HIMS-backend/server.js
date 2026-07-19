import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import dotenv from 'dotenv';
import authRoutes from './routes/authRoutes.js';
import developerRoutes from './routes/developerRoutes.js';
import patientRoutes from './routes/patientRoutes.js';
import appointmentRoutes from './routes/appointmentRoutes.js';
import billingRoutes from './routes/billingRoutes.js';
import staffRoutes from './routes/staffRoutes.js';
import infraRoutes from './routes/infraRoutes.js';
import dutyRoutes from './routes/dutyRoutes.js';
import billingPackageRoutes from './routes/billingPackageRoutes.js';
import departmentRoutes from './routes/departmentRoutes.js';
import labRoutes from './routes/labRoutes.js';
import dashboardRoutes from './routes/dashboardRoutes.js';
import inventoryRoutes from './routes/inventoryRoutes.js';
import inventoryVendorRoutes from './routes/inventoryVendorRoutes.js';
import inventoryItemRoutes from './routes/inventoryItemRoutes.js';
import inventoryBatchRoutes from './routes/inventoryBatchRoutes.js';
import inventoryTransactionRoutes from './routes/inventoryTransactionRoutes.js';
import inventoryMappingRoutes from './routes/inventoryMappingRoutes.js';
import inventoryAnalyticsRoutes from './routes/inventoryAnalyticsRoutes.js';
import inventorySuggestionRoutes from './routes/inventorySuggestionRoutes.js';
import inventoryTransferRoutes from './routes/inventoryTransferRoutes.js';
import inventoryAccountsPayableRoutes from './routes/inventoryAccountsPayableRoutes.js';
import inventoryProcurementRoutes from './routes/inventoryProcurementRoutes.js';
import settingsRoutes from './routes/settingsRoutes.js';
import branchRoutes from './routes/branchRoutes.js';
import orgRoutes from './routes/orgRoutes.js';
import inventoryNetworkRoutes from './routes/inventoryNetworkRoutes.js';
import hl7Routes from './routes/hl7Routes.js';
import disasterRoutes from './routes/disasterRoutes.js';
import careRoutes from './routes/careRoutes.js';
import careAdminRoutes from './routes/careAdminRoutes.js';
import cdacRoutes from './routes/cdacRoutes.js';
import db from './config/db.js';
import barcodeRoutes from './routes/barcodeRoutes.js';
import prescriptionRoutes from './routes/prescriptionRoutes.js';
import consultationRoutes from './routes/consultationRoutes.js';
import { initCronJobs } from './jobs/cronJobs.js';

dotenv.config();

// Initialize scheduled tasks
initCronJobs();

const app = express();
const PORT = process.env.PORT || 5000;

const ALLOWED_ORIGINS = (process.env.ALLOWED_ORIGINS || 'https://lims.poxiatechnologies.com')
  .split(',')
  .map(o => o.trim());

// VAPT #11 (Host Header Injection): reject requests whose Host header
// doesn't match a known hostname before anything downstream trusts it for
// link/redirect generation. Derived from ALLOWED_ORIGINS by default so
// there's one list to maintain in prod; override with ALLOWED_HOSTS if the
// API's own hostname differs from the frontend origins.
const ALLOWED_HOSTS = (process.env.ALLOWED_HOSTS
  ? process.env.ALLOWED_HOSTS.split(',')
  : ALLOWED_ORIGINS.map(o => { try { return new URL(o).host; } catch { return null; } }).filter(Boolean)
).concat(['localhost', '127.0.0.1'])
  .map(h => h.trim().toLowerCase());

app.use((req, res, next) => {
  const host = (req.headers.host || '').toLowerCase().split(':')[0];
  if (ALLOWED_HOSTS.some(allowed => host === allowed || host === allowed.split(':')[0])) {
    return next();
  }
  return res.status(400).json({ success: false, message: 'Invalid Host header' });
});

// This is a JSON/file API, not an HTML-serving app, so the CSP/COEP defaults
// (meant for pages rendering markup) are irrelevant here and just add noise;
// crossOriginResourcePolicy is relaxed so the frontend (a different origin)
// can still load PDFs/QR images/barcodes served from these endpoints.
app.use(helmet({
  contentSecurityPolicy: false,
  crossOriginEmbedderPolicy: false,
  crossOriginResourcePolicy: { policy: 'cross-origin' },
}));
// VAPT #18: helmet sets X-XSS-Protection to "0" by default (the modern,
// correct advice — the old browser XSS auditor is deprecated and could
// itself be abused). The scanner's checklist still wants the legacy
// "1; mode=block" value, which is harmless noise on current browsers, so
// set it explicitly to close the finding without fighting helmet's default.
app.use((req, res, next) => {
  res.setHeader('X-XSS-Protection', '1; mode=block');
  next();
});
// VAPT #25: don't let clients fingerprint/diff exact response revisions.
app.set('etag', false);

app.use(cors({
  origin: (origin, callback) => {
    // No Origin header = server-to-server/curl/mobile clients — not subject to
    // browser CORS enforcement in the first place, so let them through.
    if (!origin || ALLOWED_ORIGINS.includes(origin)) {
      return callback(null, true);
    }
    callback(new Error('Not allowed by CORS'));
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-API-Key', 'X-CSRF-Token'],
  // Custom response headers aren't readable by client JS cross-origin unless
  // explicitly exposed — the CSRF middleware rotates the token via this header.
  exposedHeaders: ['X-CSRF-Token']
}));

// VAPT #14 (Improper Referer Check): defense-in-depth alongside the CSRF
// token in middleware/auth.js — a mutating request whose Referer/Origin
// points somewhere outside the allowlist is rejected even if it somehow
// carried a valid token (e.g. leaked via an XSS on an allowed origin, or a
// misconfigured proxy). Same no-header exemption as CORS above: browsers
// omit Referer on some cross-origin/privacy-mode requests, and
// server-to-server calls have neither header at all.
const MUTATING_METHODS = new Set(['POST', 'PUT', 'PATCH', 'DELETE']);
app.use((req, res, next) => {
  if (!MUTATING_METHODS.has(req.method)) return next();

  const source = req.headers.origin || req.headers.referer;
  if (!source) return next();

  let sourceOrigin;
  try {
    sourceOrigin = new URL(source).origin;
  } catch {
    return res.status(403).json({ success: false, message: 'Invalid Referer/Origin header' });
  }

  if (ALLOWED_ORIGINS.includes(sourceOrigin)) return next();
  return res.status(403).json({ success: false, message: 'Request source not allowed' });
});

app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ limit: '50mb', extended: true }));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/dev', developerRoutes);
app.use('/api/patients', patientRoutes);
app.use('/api/appointments', appointmentRoutes);
app.use('/api/billing', billingRoutes);
app.use('/api/staff', staffRoutes);
app.use('/api/infra', infraRoutes);
app.use('/api/duty', dutyRoutes);
app.use('/api/billing-packages', billingPackageRoutes);
app.use('/api/departments', departmentRoutes);
app.use('/api/lab', labRoutes);
app.use('/api/dashboard', dashboardRoutes);
app.use('/api/inventory', inventoryRoutes);
app.use('/api/v2/inventory/vendors', inventoryVendorRoutes);
app.use('/api/v2/inventory/items', inventoryItemRoutes);
app.use('/api/v2/inventory/batches', inventoryBatchRoutes);
app.use('/api/v2/inventory/transactions', inventoryTransactionRoutes);
app.use('/api/v2/inventory/mappings', inventoryMappingRoutes);
app.use('/api/v2/inventory/analytics', inventoryAnalyticsRoutes);
app.use('/api/v2/inventory/suggestions', inventorySuggestionRoutes);
app.use('/api/v2/inventory/transfers', inventoryTransferRoutes);
app.use('/api/v2/inventory/ap', inventoryAccountsPayableRoutes);
app.use('/api/v2/inventory/procurement', inventoryProcurementRoutes);
app.use('/api/settings', settingsRoutes);
app.use('/api/branches', branchRoutes);
app.use('/api/org', orgRoutes);
app.use('/api/inventory-network', inventoryNetworkRoutes);
app.use('/api/hl7', hl7Routes);
app.use('/api/disaster', disasterRoutes);
app.use('/api/barcodes', barcodeRoutes);
app.use('/api/prescriptions', prescriptionRoutes);
app.use('/api/consultations', consultationRoutes);
app.use('/', careRoutes);
app.use('/api/care', careAdminRoutes);
app.use('/api/cdac', cdacRoutes);
// Health check route
app.get('/', (req, res) => {
  res.send('HIMS Backend is running!');
});

// Global error handler — must be last. Catches anything not already handled by
// a controller's own try/catch (malformed JSON bodies, the CORS rejection above,
// etc.) and never leaks a stack trace to the client outside of development.
app.use((err, req, res, next) => {
  console.error('Unhandled error:', err);

  if (err.message === 'Not allowed by CORS') {
    return res.status(403).json({ success: false, message: 'Not allowed by CORS' });
  }

  // Multer validation errors (file too large, wrong type) are user-actionable
  // input errors, not internal failures — safe to surface in production.
  if (err.name === 'MulterError' || /Only image uploads/.test(err.message || '')) {
    return res.status(400).json({ success: false, message: err.message });
  }

  const isProd = process.env.NODE_ENV === 'production';
  res.status(err.status || 500).json({
    success: false,
    message: isProd ? 'Internal server error' : err.message,
    ...(isProd ? {} : { stack: err.stack }),
  });
});

// Start server - bind to 0.0.0.0 to accept external connections
app.listen(PORT, '0.0.0.0', async () => {
  console.log(`Server running on http://0.0.0.0:${PORT}`);
  console.log(`Accessible via your IP address on port ${PORT}`);

  // Test DB connection on startup
  try {
    const connection = await db.getConnection();
    console.log('Database connected successfully!');
    connection.release();
  } catch (err) {
    console.error('Database connection failed:', err.message);
  }

  // Auto-migrate: create analyzer_connection_logs if it doesn't exist
  try {
    await db.query(`
      CREATE TABLE IF NOT EXISTS analyzer_connection_logs (
        id           INT AUTO_INCREMENT PRIMARY KEY,
        machine_id   VARCHAR(100)             NOT NULL,
        machine_name VARCHAR(200)             DEFAULT NULL,
        model        VARCHAR(200)             DEFAULT NULL,
        lab_id       INT                      DEFAULT NULL,
        port         VARCHAR(100)             DEFAULT NULL,
        event        ENUM('ONLINE','OFFLINE') NOT NULL,
        ip_address   VARCHAR(45)              DEFAULT NULL,
        created_at   TIMESTAMP                DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_machine_id (machine_id),
        INDEX idx_lab_id     (lab_id),
        INDEX idx_created_at (created_at)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    `);
    console.log('✅ analyzer_connection_logs table ready.');
  } catch (err) {
    console.error('Migration error (analyzer_connection_logs):', err.message);
  }

  // Auto-migrate: VAPT #6 (account lockout) / #16 (compulsory password
  // change) columns on `users`. Guarded per-column since MySQL has no
  // "ADD COLUMN IF NOT EXISTS" and re-running ADD COLUMN on an existing
  // column would error on every boot.
  try {
    const [cols] = await db.query(`SHOW COLUMNS FROM users`);
    const existing = new Set(cols.map(c => c.Field));
    const wanted = [
      ['failed_login_attempts', 'INT NOT NULL DEFAULT 0'],
      ['locked_until', 'DATETIME NULL DEFAULT NULL'],
      ['password_change_required', 'TINYINT(1) NOT NULL DEFAULT 0'],
    ];
    for (const [name, def] of wanted) {
      if (!existing.has(name)) {
        await db.query(`ALTER TABLE users ADD COLUMN ${name} ${def}`);
        console.log(`✅ users.${name} column added.`);
      }
    }
  } catch (err) {
    console.error('Migration error (users lockout/password columns):', err.message);
  }
});
