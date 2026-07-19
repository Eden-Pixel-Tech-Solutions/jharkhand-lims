import crypto from 'crypto';

// In-memory CSRF token store, single-instance server (same pattern as
// captchaStore.js / developerController.js's otpStore). Keyed by the JWT's
// `sid` claim (one per login, not per user — so two tabs/devices logged in
// simultaneously each get an independent token lifecycle instead of racing
// to invalidate each other).
//
// Sliding window of 2: both the current and the immediately-previous token
// are accepted. This still kills a captured/replayed request as soon as the
// legitimate client makes its next mutating call, without causing false
// 403s when two legitimate requests race from the same tab (parallel saves,
// bulk actions, React 18 StrictMode double-effects in dev).
const csrfStore = new Map(); // sid -> { current, previous, expiresAt }
const TTL_MS = 30 * 24 * 60 * 60 * 1000; // matches the longest-lived JWT (staff, 30d)

const purgeExpired = () => {
  const now = Date.now();
  for (const [sid, entry] of csrfStore) {
    if (entry.expiresAt < now) csrfStore.delete(sid);
  }
};

export const issueCsrfToken = (sid) => {
  purgeExpired();
  const token = crypto.randomBytes(32).toString('hex');
  csrfStore.set(sid, { current: token, previous: null, expiresAt: Date.now() + TTL_MS });
  return token;
};

export const verifyAndRotateCsrfToken = (sid, submittedToken) => {
  if (!sid || !submittedToken) return null;

  const entry = csrfStore.get(sid);
  if (!entry || Date.now() > entry.expiresAt) return null;

  if (submittedToken !== entry.current && submittedToken !== entry.previous) return null;

  const nextToken = crypto.randomBytes(32).toString('hex');
  csrfStore.set(sid, { current: nextToken, previous: entry.current, expiresAt: Date.now() + TTL_MS });
  return nextToken;
};
