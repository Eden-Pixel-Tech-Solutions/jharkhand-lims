import { useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';

const IDLE_LIMIT_MS = 30 * 60 * 1000; // VAPT #7: 30-minute max inactivity
const ACTIVITY_EVENTS = ['mousedown', 'keydown', 'scroll', 'touchstart'];

// Logs the user out (and clears their session) after 30 minutes of no
// mouse/keyboard/touch activity, regardless of whether the tab is open.
export function useIdleLogout(clearSession, redirectTo = '/') {
  const navigate = useNavigate();
  const timerRef = useRef(null);

  useEffect(() => {
    const logout = () => {
      clearSession();
      navigate(redirectTo, { replace: true });
    };

    const resetTimer = () => {
      if (timerRef.current) clearTimeout(timerRef.current);
      timerRef.current = setTimeout(logout, IDLE_LIMIT_MS);
    };

    ACTIVITY_EVENTS.forEach(evt => window.addEventListener(evt, resetTimer));
    resetTimer();

    return () => {
      ACTIVITY_EVENTS.forEach(evt => window.removeEventListener(evt, resetTimer));
      if (timerRef.current) clearTimeout(timerRef.current);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);
}
