import rateLimit from 'express-rate-limit';

// Staff login (email + password) — generous enough for real typos, tight enough to block brute force.
export const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 10,
  standardHeaders: true,
  legacyHeaders: false,
  message: { success: false, message: 'Too many login attempts. Please try again in 15 minutes.' },
});

// Patient portal login (phone + DOB) — DOB has far fewer possibilities than a password, so this stays tighter.
export const patientLoginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 5,
  standardHeaders: true,
  legacyHeaders: false,
  message: { success: false, message: 'Too many login attempts. Please try again in 15 minutes.' },
});

// OTP request/verify — must be tight; OTPs are short-lived numeric codes.
export const otpLimiter = rateLimit({
  windowMs: 10 * 60 * 1000,
  limit: 5,
  standardHeaders: true,
  legacyHeaders: false,
  message: { success: false, message: 'Too many OTP requests. Please try again in 10 minutes.' },
});

// Public, unauthenticated lookup endpoints (e.g. lab report tracking by
// reference number) — slows down enumeration attempts regardless of how
// strong the underlying identifier is.
export const publicLookupLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 20,
  standardHeaders: true,
  legacyHeaders: false,
  message: { success: false, message: 'Too many requests. Please try again in 15 minutes.' },
});
