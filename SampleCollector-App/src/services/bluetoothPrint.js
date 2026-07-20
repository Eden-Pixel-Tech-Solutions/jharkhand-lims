/**
 * Sends a label print job to the laptop's Bluetooth print server
 * (laptop-server/server.js) over Bluetooth Classic RFCOMM.
 *
 * ► HOW TO FIND YOUR LAPTOP'S BLUETOOTH NAME:
 *   Windows : Settings → System → About → Device name
 *   macOS   : System Settings → General → About → Name
 *   Linux   : hostname  (in terminal)
 *
 * ► Set LAPTOP_BT_NAME below to that exact name, then rebuild the app.
 */
import RNBluetoothClassic from 'react-native-bluetooth-classic';

// ── Config ─────────────────────────────────────────────────────────────────
// Change this to your laptop's Bluetooth device name exactly as paired.
const LAPTOP_BT_NAME  = 'MERIL-LAPTOP';   // ← UPDATE THIS
const END_MARKER      = '\n---END---\n';
const ACK_TIMEOUT_MS  = 10_000;
// ───────────────────────────────────────────────────────────────────────────

/**
 * @param {object} data
 * @param {string} data.patient_name
 * @param {string} data.sample_id       full sample ID
 * @param {string} data.short_id        short barcode ID
 * @param {string} [data.test_name]
 * @param {string} [data.test_code]
 * @param {string} [data.barcode_base64] data:image/png;base64,…
 * @param {string} [data.qr_base64]      data:image/png;base64,…
 *
 * @throws {Error} with a user-friendly message on any failure
 */
export async function printLabelViaBluetooth(data) {
  // 1 – Bluetooth must be on
  const isEnabled = await RNBluetoothClassic.isBluetoothEnabled();
  if (!isEnabled) {
    throw new Error(
      'Bluetooth is turned off.\nPlease enable Bluetooth and try again.'
    );
  }

  // 2 – Find the laptop in the paired device list
  const paired = await RNBluetoothClassic.getBondedDevices();
  const device  = paired.find(d => d.name === LAPTOP_BT_NAME);

  if (!device) {
    const names = paired.map(d => d.name).join(', ') || 'none';
    throw new Error(
      `Laptop "${LAPTOP_BT_NAME}" not found in paired devices.\n\n` +
      `Paired devices: ${names}\n\n` +
      'Steps:\n' +
      '1. Start   laptop-server/server.js   on the laptop\n' +
      '2. Pair this phone with the laptop in Android Settings → Bluetooth\n' +
      `3. Update LAPTOP_BT_NAME in bluetoothPrint.js to match your laptop's name\n` +
      '4. Rebuild the app'
    );
  }

  // 3 – Connect
  const connected = await device.connect({ delimiter: '\n' });
  if (!connected) {
    throw new Error(
      `Connected to "${LAPTOP_BT_NAME}" but channel refused.\n` +
      'Make sure laptop-server/server.js is running.'
    );
  }

  try {
    // 4 – Send print job as JSON + end-marker
    await device.write(JSON.stringify(data) + END_MARKER);

    // 5 – Wait for {"ok":true} acknowledgement (with timeout)
    await Promise.race([
      device.read(),
      new Promise((_, reject) =>
        setTimeout(
          () => reject(new Error('Print server did not respond within 10 s.')),
          ACK_TIMEOUT_MS
        )
      ),
    ]);
  } finally {
    await device.disconnect().catch(() => {});
  }
}
