import axios from 'axios';

// Transparently attaches the app's CSRF token to every mutating request and
// captures the server's rotated replacement from the response, without
// touching the ~50 individual pages that call fetch()/axios directly.
//
// The token is single-use with a sliding window of 2 on the server (see
// HIMS-backend/utils/csrfStore.js): each successful mutating request rotates
// the token, so this must run on every request/response pair to stay in
// sync, not just once at login.

const MUTATING_METHODS = new Set(['POST', 'PUT', 'PATCH', 'DELETE']);

// Longest, most specific prefix wins. Patient portal has no mutating
// endpoints today, so it has no CSRF key here — nothing to attach or store.
const CSRF_KEYS_BY_PREFIX = [
  ['/api/dev/', 'dev_csrf'],
  ['/api/', 'hims_csrf'],
];

const csrfKeyForPath = (pathname) => {
  const match = CSRF_KEYS_BY_PREFIX.find(([prefix]) => pathname.startsWith(prefix));
  return match ? match[1] : null;
};

const csrfKeyForUrl = (url) => {
  try {
    return csrfKeyForPath(new URL(url, window.location.origin).pathname);
  } catch {
    return null;
  }
};

// VAPT #9: the staff session now lives in an HttpOnly cookie instead of a
// header built from localStorage, so it only reaches the API if the request
// opts in to sending credentials cross-origin — true for every /api/ call
// this app makes, never for arbitrary third-party fetches, so gate on that
// rather than flipping it on globally.
const isOwnApiPath = (pathname) => pathname.startsWith('/api/');

const installFetchInterceptor = () => {
  const originalFetch = window.fetch.bind(window);

  window.fetch = async (input, init = {}) => {
    const url = typeof input === 'string' || input instanceof URL ? String(input) : input.url;
    const method = (init.method || (typeof input === 'object' && input.method) || 'GET').toUpperCase();
    const pathname = (() => { try { return new URL(url, window.location.origin).pathname; } catch { return ''; } })();
    const csrfKey = MUTATING_METHODS.has(method) ? csrfKeyForPath(pathname) : null;

    let finalInit = init;
    if (isOwnApiPath(pathname) && finalInit.credentials === undefined) {
      finalInit = { ...finalInit, credentials: 'include' };
    }
    if (csrfKey) {
      const token = localStorage.getItem(csrfKey);
      if (token) {
        finalInit = { ...finalInit, headers: { ...(finalInit.headers || {}), 'X-CSRF-Token': token } };
      }
    }

    const response = await originalFetch(input, finalInit);

    if (csrfKey) {
      const rotated = response.headers.get('X-CSRF-Token');
      if (rotated) localStorage.setItem(csrfKey, rotated);
    }

    return response;
  };
};

const installAxiosInterceptor = () => {
  axios.interceptors.request.use((config) => {
    const method = (config.method || 'get').toUpperCase();
    let pathname = '';
    try { pathname = new URL(axios.getUri(config), window.location.origin).pathname; } catch { /* relative/malformed URL, leave blank */ }
    if (isOwnApiPath(pathname) && config.withCredentials === undefined) {
      config.withCredentials = true;
    }
    if (MUTATING_METHODS.has(method)) {
      const csrfKey = csrfKeyForPath(pathname);
      const token = csrfKey && localStorage.getItem(csrfKey);
      if (token) config.headers['X-CSRF-Token'] = token;
    }
    return config;
  });

  axios.interceptors.response.use((response) => {
    const method = (response.config.method || 'get').toUpperCase();
    if (MUTATING_METHODS.has(method)) {
      const csrfKey = csrfKeyForUrl(axios.getUri(response.config));
      const rotated = response.headers['x-csrf-token'];
      if (csrfKey && rotated) localStorage.setItem(csrfKey, rotated);
    }
    return response;
  });
};

installFetchInterceptor();
installAxiosInterceptor();
