// Single source of truth for the HIMS-backend base URL used by the Electron main process.
// Override via the LIS_API_BASE_URL environment variable for non-local deployments.
const rawBase = process.env.LIS_API_BASE_URL || 'http://localhost:7005';

function resolve(url) {
  let parsed;
  try {
    parsed = new URL(url);
  } catch {
    console.error(`Invalid LIS_API_BASE_URL "${url}" — falling back to http://localhost:7005`);
    return 'http://localhost:7005';
  }

  const isLoopback = parsed.hostname === 'localhost' || parsed.hostname === '127.0.0.1' || parsed.hostname === '::1';
  if (parsed.protocol === 'http:' && !isLoopback) {
    console.error(`Refusing plaintext HTTP for non-loopback backend "${url}" — credentials and patient data must not travel unencrypted. Upgrading to https.`);
    parsed.protocol = 'https:';
    return parsed.toString().replace(/\/$/, '');
  }
  return url;
}

module.exports = { API_BASE: resolve(rawBase) };
