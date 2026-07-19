// Central place for clearing auth state so logout actually invalidates the
// session (VAPT: Direct URL Access / Browser Refresh Attack) instead of
// leaving hims_token et al. behind for the next Back-button press or a
// bookmarked deep link to reuse.

const STAFF_KEYS = [
  'hims_token', 'hims_csrf', 'user_id', 'branch_id', 'hospital_code',
  'role_level', 'role', 'district_id', 'user', 'password_change_required',
];
const DEVELOPER_KEYS = ['dev_token', 'dev_csrf'];
const PATIENT_KEYS = ['patient_token', 'patient_data'];

export const clearStaffSession = () => STAFF_KEYS.forEach(k => localStorage.removeItem(k));
export const clearDeveloperSession = () => DEVELOPER_KEYS.forEach(k => localStorage.removeItem(k));
export const clearPatientSession = () => PATIENT_KEYS.forEach(k => localStorage.removeItem(k));

export const hasStaffToken = () => !!localStorage.getItem('hims_token');
export const hasDeveloperToken = () => !!localStorage.getItem('dev_token');
export const hasPatientToken = () => !!localStorage.getItem('patient_token');
