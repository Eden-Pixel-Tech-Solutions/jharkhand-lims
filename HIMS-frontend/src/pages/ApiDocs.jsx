import { useState, useMemo } from 'react';
import '../assets/CSS/ApiDocs.css';

// m: method, p: path (HTML — <span class="param"> highlights path params), a: auth kind (auth|public|key|dev),
// r: role restriction (optional), rl: rate limit note (optional), d: description (HTML), b: body/query fields (HTML, optional)
const API = [
{ id: "auth", title: "Authentication", desc: "Staff login/registration. Uses the standard JWT scheme (middleware/auth.js).", endpoints: [
  { m: "POST", p: "/api/auth/register", a: "auth", r: "Admin, Lab Head, Doctor", d: "Create a new staff account. Can also auto-create a brand-new branch/hospital via branch_id:'NEW'.", b: "firstName, lastName, email, phone?, role, department, staffId?, password, role_level?, branch_id? (or 'NEW' + newBranchName, newHospitalCode, newDistrictId)" },
  { m: "POST", p: "/api/auth/login", a: "public", rl: "10 / 15 min", d: "Staff login &rarr; JWT valid 30 days.", b: "email, password" },
]},
{ id: "patients", title: "Patients", desc: "Staff-facing patient CRUD/search plus a separate patient self-service portal (phone+DOB login, its own JWT type).", endpoints: [
  { m: "POST", p: "/api/patients/register", a: "auth", r: "Staff roles", d: "Register a new patient (full demographic form).", b: "regNo, regDate, title, firstName, middleName, lastName, dob, gender, aadharNumber, address fields, kin fields, payerType, insuranceProvider, policyNumber, branch_id&hellip;" },
  { m: "GET", p: "/api/patients/search", a: "auth", r: "Staff roles", d: "Search patients by telephone, email, Aadhaar, or a general fallback match. Branch-scoped unless caller is Central.", b: "?type=telephone|email_id|aadhar_number &amp; q=" },
  { m: "GET", p: "/api/patients/phone-lookup/<span class='param'>:phone</span>", a: "auth", r: "Staff roles", d: "Full demographics + recent consultations/bills/lab results for the quick-lookup panel." },
  { m: "GET", p: "/api/patients/check-duplicate", a: "auth", r: "Staff roles", d: "Find potential duplicates during registration. Deliberately network-wide, not branch-scoped &mdash; this is what catches the same patient re-registering at a different branch.", b: "?telephone= &amp; firstName= &amp; lastName= &amp; dob=" },
  { m: "POST", p: "/api/patients/merge", a: "auth", r: "Admin, Super Admin", d: "Merge one patient record into another; reassigns appointments/consultations/bills, deletes the secondary.", b: "primaryRegNo, secondaryRegNo" },
  { m: "GET", p: "/api/patients/<span class='param'>:regNo</span>/chart", a: "auth", r: "Doctor, Admin, Super Admin", d: "Full demographic chart by reg_no. Branch-scoped unless Central." },
  { m: "POST", p: "/api/patients/portal/login", a: "public", rl: "5 / 15 min", d: "Patient portal login &rarr; 7-day patient-type JWT.", b: "phone, dob" },
  { m: "GET", p: "/api/patients/portal/profile/<span class='param'>:phone</span>", a: "auth", r: "Patient JWT (phone must match token)", d: "Patient's own demographic profile." },
  { m: "GET", p: "/api/patients/portal/reports/<span class='param'>:phone</span>", a: "auth", r: "Patient JWT", d: "List the patient's approved lab reports." },
  { m: "GET", p: "/api/patients/portal/reports/<span class='param'>:phone</span>/<span class='param'>:sampleId</span>", a: "auth", r: "Patient JWT", d: "Full result detail for one approved sample." },
  { m: "GET", p: "/api/patients/portal/reports/<span class='param'>:phone</span>/<span class='param'>:sampleId</span>/pdf", a: "auth", r: "Patient JWT", d: "Streams a generated PDF of the report." },
]},
{ id: "appointments", title: "Appointments", desc: "Booking and daily listing.", endpoints: [
  { m: "POST", p: "/api/appointments/book", a: "auth", d: "Book an appointment. Branch enforced from JWT unless Central.", b: "regNo, department, doctor, doctor_id?, priority?, apptDate, apptTime, reason" },
  { m: "GET", p: "/api/appointments/", a: "auth", d: "List appointments, ordered by date/time.", b: "?date= &amp; branch_id= (branch_id only honored for Central)" },
]},
{ id: "consultations", title: "Consultations", desc: "Doctor-only clinical workflow: SOAP notes, vitals, prescriptions, lab orders, follow-ups, timelines.", endpoints: [
  { m: "GET", p: "/api/consultations/today", a: "auth", r: "Doctor, Admin, Super Admin", d: "Today's appointments + consultation status. Doctors are auto-scoped to their own list." },
  { m: "GET", p: "/api/consultations/followup-due", a: "auth", r: "Doctor, Admin, Super Admin", d: "Patients whose follow_up_date is today." },
  { m: "POST", p: "/api/consultations/", a: "auth", r: "Doctor, Admin, Super Admin", d: "Upsert a consultation with vitals, prescriptions, and lab orders in one transaction. Prescriptions/lab orders are fully replaced (delete+reinsert) on each save.", b: "appointmentId, doctorId, patientRegNo, chiefComplaints, diagnosis, notes, followUpDate, soapHistory, soapExam, icd10Codes[], vitals{}, prescriptions[], labOrders[]" },
  { m: "POST", p: "/api/consultations/auto-bill", a: "auth", r: "Doctor, Admin, Super Admin", d: "Generate a bill from a consultation's prescriptions/lab orders + a flat &#8377;300 consultation fee.", b: "consultationId, patientRegNo, doctorId, prescriptions[], labOrders[]" },
  { m: "POST", p: "/api/consultations/send-summary-sms", a: "auth", r: "Doctor, Admin, Super Admin", d: "Placeholder &mdash; always returns success, no SMS provider wired up yet." },
  { m: "GET", p: "/api/consultations/patient/<span class='param'>:regNo</span>/history", a: "auth", r: "Doctor, Admin, Super Admin", d: "Last 10 consultations with nested vitals/prescriptions/lab orders." },
  { m: "GET", p: "/api/consultations/patient/<span class='param'>:regNo</span>/lab-trends", a: "auth", r: "Doctor, Admin, Super Admin", d: "Last up-to-10 results per distinct lab test, grouped by test name." },
  { m: "GET", p: "/api/consultations/patient/<span class='param'>:regNo</span>/timeline", a: "auth", r: "Doctor, Admin, Super Admin", d: "Unified chronological timeline: consultations, lab orders, bills, vitals." },
  { m: "GET", p: "/api/consultations/templates/<span class='param'>:doctorId</span>", a: "auth", r: "Doctor, Admin, Super Admin", d: "List a doctor's saved prescription templates." },
  { m: "POST", p: "/api/consultations/templates", a: "auth", r: "Doctor, Admin, Super Admin", d: "Save a prescription template.", b: "doctorId, templateName, medicines[]" },
  { m: "DELETE", p: "/api/consultations/templates/<span class='param'>:id</span>", a: "auth", r: "Doctor, Admin, Super Admin", d: "Delete a prescription template." },
  { m: "GET", p: "/api/consultations/<span class='param'>:appointmentId</span>", a: "auth", r: "Doctor, Admin, Super Admin", d: "Full consultation detail for an appointment (registered last so it doesn't shadow the routes above)." },
]},
{ id: "prescriptions", title: "Prescriptions (AI Scan)", desc: "Photograph a paper prescription &rarr; AI extraction &rarr; verified billing. No dedicated controller, logic lives in the route file.", endpoints: [
  { m: "POST", p: "/api/prescriptions/process-ai", a: "auth", r: "Admin, Doctor, Lab Head, Lab Technician", d: "Upload a prescription image (multipart, field <code>image</code>, &le;10MB, JPEG/PNG/WebP/HEIC only). Sent to a local Ollama model to extract patient/tests/medicines, fuzzy-matched against the test catalog.", b: "multipart: image + barcodeId" },
  { m: "POST", p: "/api/prescriptions/finalize-billing", a: "auth", r: "Admin, Doctor, Lab Head, Lab Technician", d: "Finalize billing from AI-verified data: creates patient + bill + bill items in one transaction. Always creates a new patient (no dedup lookup).", b: "patientName, gender, tests[], totalAmount, barcodeId" },
]},
{ id: "staff", title: "Staff", desc: "Employee directory and account management.", endpoints: [
  { m: "GET", p: "/api/staff/stats", a: "auth", d: "Staff counts by role, branch-scoped unless Central." },
  { m: "GET", p: "/api/staff/list", a: "auth", d: "Full staff list with branch info.", b: "?branch_id= (Central only; others forced to own branch)" },
  { m: "GET", p: "/api/staff/doctors", a: "auth", d: "All users with role='Doctor' (name + department)." },
  { m: "POST", p: "/api/staff/add", a: "auth", r: "Admin, Super Admin", d: "Create a staff account. Only Central admins can set role_level; others forced to Branch/own branch.", b: "firstName, lastName, email, phone?, role, department?, staffId?, password, role_level?" },
  { m: "PUT", p: "/api/staff/<span class='param'>:id</span>", a: "auth", r: "Admin, Super Admin", d: "Update staff. Branch-scoped callers restricted to their own branch's staff.", b: "firstName, lastName, phone, role, department, role_level, branch_id" },
  { m: "DELETE", p: "/api/staff/<span class='param'>:id</span>", a: "auth", r: "Admin, Super Admin", d: "Delete a staff user (self-deletion blocked; branch-scoped access check)." },
]},
{ id: "duty", title: "Duty Roster", desc: "Doctor duty scheduling and appointment slot availability.", endpoints: [
  { m: "GET", p: "/api/duty/", a: "auth", d: "Duty schedules with doctor + room info.", b: "?branch_id=" },
  { m: "GET", p: "/api/duty/available", a: "auth", d: "Doctors on duty for a given date/time/department.", b: "?date= &amp; time= &amp; department= &amp; branch_id=" },
  { m: "GET", p: "/api/duty/slots", a: "auth", d: "15-min appointment slot grid with booking counts.", b: "?doctor_id= &amp; date=" },
  { m: "POST", p: "/api/duty/add", a: "auth", d: "Create a duty schedule.", b: "doctorId, roomId, dutyDate, startTime, endTime, price?, notes?, branch_id?" },
  { m: "DELETE", p: "/api/duty/<span class='param'>:id</span>", a: "auth", d: "Delete a duty schedule." },
]},
{ id: "departments", title: "Departments", desc: "Hospital department catalog.", endpoints: [
  { m: "GET", p: "/api/departments/", a: "auth", d: "List departments.", b: "?is_active=" },
  { m: "GET", p: "/api/departments/<span class='param'>:id</span>", a: "auth", d: "Get a single department." },
  { m: "POST", p: "/api/departments/", a: "auth", d: "Create a department.", b: "name, code?, description?, is_active?, branch_id?" },
  { m: "PUT", p: "/api/departments/<span class='param'>:id</span>", a: "auth", d: "Partial update.", b: "name, code, description, is_active" },
  { m: "DELETE", p: "/api/departments/<span class='param'>:id</span>", a: "auth", d: "Delete a department." },
]},
{ id: "branches", title: "Branches & Districts", desc: "Multi-branch network hierarchy: districts, branches/centers, facility categories. Scope enforced from JWT (Central sees all, Sub-Central its district, Branch itself).", endpoints: [
  { m: "GET", p: "/api/branches/", a: "auth", d: "List branches (+ districts + facility categories for dropdowns), scoped by caller's role_level." },
  { m: "POST", p: "/api/branches/district", a: "auth", d: "Create a district.", b: "name, state?, state_id?" },
  { m: "PUT", p: "/api/branches/district/<span class='param'>:id</span>", a: "auth", d: "Update a district.", b: "name, state_id" },
  { m: "DELETE", p: "/api/branches/district/<span class='param'>:id</span>", a: "auth", d: "Delete a district (blocked if branches are assigned)." },
  { m: "PATCH", p: "/api/branches/center/<span class='param'>:id</span>/block", a: "auth", d: "Assign/unassign a branch to a block.", b: "block_id" },
  { m: "POST", p: "/api/branches/center", a: "auth", d: "Create a branch/center.", b: "district_id, branch_name, category?, hospital_code, address, contact_number, branch_level?, parent_branch_id?" },
  { m: "PUT", p: "/api/branches/center/<span class='param'>:id</span>", a: "auth", d: "Update a branch/center.", b: "district_id, branch_name, category, hospital_code, address, contact_number, branch_level, parent_branch_id" },
  { m: "DELETE", p: "/api/branches/center/<span class='param'>:id</span>", a: "auth", d: "Delete a branch/center (blocked if staff/infra/patients reference it)." },
  { m: "POST", p: "/api/branches/categories", a: "auth", d: "Create a facility category.", b: "name" },
  { m: "PUT", p: "/api/branches/categories/<span class='param'>:id</span>", a: "auth", d: "Update a facility category.", b: "name" },
  { m: "DELETE", p: "/api/branches/categories/<span class='param'>:id</span>", a: "auth", d: "Delete a facility category." },
]},
{ id: "org", title: "Organization Setup", desc: "States, blocks, specialties, beds, working hours, and holidays.", endpoints: [
  { m: "GET", p: "/api/org/states", a: "auth", d: "List states." },
  { m: "POST", p: "/api/org/states", a: "auth", d: "Create a state.", b: "name, code" },
  { m: "PUT", p: "/api/org/states/<span class='param'>:id</span>", a: "auth", d: "Update a state.", b: "name, code, is_active" },
  { m: "DELETE", p: "/api/org/states/<span class='param'>:id</span>", a: "auth", d: "Delete a state (blocked if districts reference it)." },
  { m: "GET", p: "/api/org/blocks", a: "auth", d: "List blocks with district name.", b: "?district_id=" },
  { m: "POST", p: "/api/org/blocks", a: "auth", d: "Create a block.", b: "name, district_id" },
  { m: "PUT", p: "/api/org/blocks/<span class='param'>:id</span>", a: "auth", d: "Update a block.", b: "name, district_id, is_active" },
  { m: "DELETE", p: "/api/org/blocks/<span class='param'>:id</span>", a: "auth", d: "Delete a block (blocked if branches reference it)." },
  { m: "GET", p: "/api/org/specialties", a: "auth", d: "List specialties (global + branch-specific).", b: "?branch_id=" },
  { m: "POST", p: "/api/org/specialties", a: "auth", d: "Create a specialty.", b: "name, code?, description?, branch_id?" },
  { m: "PUT", p: "/api/org/specialties/<span class='param'>:id</span>", a: "auth", d: "Update a specialty.", b: "name, code, description, is_active" },
  { m: "DELETE", p: "/api/org/specialties/<span class='param'>:id</span>", a: "auth", d: "Delete a specialty." },
  { m: "GET", p: "/api/org/beds", a: "auth", d: "List beds with ward info + status summary.", b: "?branch_id= &amp; ward_id= &amp; status=" },
  { m: "POST", p: "/api/org/beds", a: "auth", d: "Create a single bed.", b: "bed_number, ward_id, branch_id, bed_type?, status?" },
  { m: "POST", p: "/api/org/beds/bulk", a: "auth", d: "Bulk-create up to 100 beds; skips duplicate bed numbers.", b: "ward_id, branch_id, bed_type?, prefix?, start_number?, count" },
  { m: "PUT", p: "/api/org/beds/<span class='param'>:id</span>", a: "auth", d: "Update a bed.", b: "bed_number, ward_id, bed_type, status, branch_id" },
  { m: "PATCH", p: "/api/org/beds/<span class='param'>:id</span>/status", a: "auth", d: "Update only a bed's status.", b: "status" },
  { m: "DELETE", p: "/api/org/beds/<span class='param'>:id</span>", a: "auth", d: "Delete a bed.", b: "?branch_id=" },
  { m: "GET", p: "/api/org/working-hours", a: "auth", d: "List working hours by branch.", b: "?branch_id=" },
  { m: "POST", p: "/api/org/working-hours", a: "auth", d: "Upsert a weekly schedule, one row per day.", b: "branch_id, department_id?, schedule:[{day_of_week, open_time, close_time, is_closed}]" },
  { m: "DELETE", p: "/api/org/working-hours/<span class='param'>:id</span>", a: "auth", d: "Delete a working-hours entry." },
  { m: "GET", p: "/api/org/holidays", a: "auth", d: "List holidays (global + branch-specific).", b: "?branch_id= &amp; upcoming=1" },
  { m: "POST", p: "/api/org/holidays", a: "auth", d: "Create a holiday.", b: "branch_id?, holiday_name, holiday_date, holiday_type?, is_recurring?" },
  { m: "PUT", p: "/api/org/holidays/<span class='param'>:id</span>", a: "auth", d: "Update a holiday.", b: "holiday_name, holiday_date, holiday_type, is_recurring" },
  { m: "DELETE", p: "/api/org/holidays/<span class='param'>:id</span>", a: "auth", d: "Delete a holiday." },
]},
{ id: "lab-catalog", title: "Lab — Catalog & Setup", desc: "Test categories, sample containers/types, the test catalog itself, and analyzer test-mapping templates.", endpoints: [
  { m: "GET", p: "/api/lab/categories", a: "auth", d: "List active lab test categories." },
  { m: "POST", p: "/api/lab/categories", a: "auth", d: "Add a category.", b: "name, description" },
  { m: "PUT", p: "/api/lab/categories/<span class='param'>:id</span>", a: "auth", d: "Update a category.", b: "name, description" },
  { m: "DELETE", p: "/api/lab/categories/<span class='param'>:id</span>", a: "auth", d: "Soft-delete a category (status &rarr; Inactive)." },
  { m: "GET", p: "/api/lab/containers", a: "auth", d: "List active sample containers." },
  { m: "POST", p: "/api/lab/containers", a: "auth", d: "Add a container.", b: "container_name, tube_color, volume_ml, additives, storage_temperature, special_instructions" },
  { m: "PUT", p: "/api/lab/containers/<span class='param'>:id</span>", a: "auth", d: "Update a container." },
  { m: "DELETE", p: "/api/lab/containers/<span class='param'>:id</span>", a: "auth", d: "Delete a container." },
  { m: "GET", p: "/api/lab/sample-types", a: "auth", d: "List sample types." },
  { m: "POST", p: "/api/lab/sample-types", a: "auth", d: "Add a sample type." },
  { m: "PUT", p: "/api/lab/sample-types/<span class='param'>:id</span>", a: "auth", d: "Update a sample type." },
  { m: "DELETE", p: "/api/lab/sample-types/<span class='param'>:id</span>", a: "auth", d: "Delete a sample type." },
  { m: "GET", p: "/api/lab/tests", a: "auth", d: "List lab tests." },
  { m: "GET", p: "/api/lab/tests/<span class='param'>:id</span>", a: "auth", d: "Get one test's detail." },
  { m: "POST", p: "/api/lab/tests", a: "auth", d: "Create a test + its parameters (transactional, checks duplicate test_code).", b: "test_code, test_name, category_id, lab_id, sample_type, tube_color, storage_conditions, methodology, price, analyzer_name, parameters[]" },
  { m: "PUT", p: "/api/lab/tests/<span class='param'>:id</span>", a: "auth", d: "Update a test." },
  { m: "DELETE", p: "/api/lab/tests/<span class='param'>:id</span>", a: "auth", d: "Delete a test." },
  { m: "POST", p: "/api/lab/map-analyzer-tests", a: "auth", d: "Auto-create predefined test templates/parameters for a known analyzer model.", b: "lab_id, analyzer_name" },
  { m: "POST", p: "/api/lab/generate-parameters", a: "auth", d: "AI-assisted generation of test parameters." },
  { m: "GET", p: "/api/lab/tests-general", a: "auth", d: "List general (non-specialized) tests." },
]},
{ id: "lab-worklist", title: "Lab — Worklist & Results", desc: "The day-to-day flow: sample IDs, worklist, result entry, verification/approval, reports, and patient-facing tracking/kiosk lookup.", endpoints: [
  { m: "GET", p: "/api/lab/worklist", a: "auth", d: "Pending/collected samples." },
  { m: "GET", p: "/api/lab/worklist-by-id/<span class='param'>:id</span>", a: "auth", d: "Get a single worklist item." },
  { m: "POST", p: "/api/lab/unsolicited-worklist", a: "auth", d: "Create a worklist entry for an analyzer-run test with no prior order (auto-creates a dummy patient/bill/bill item). This is what LIS-Agent's auto-creation setting gates client-side.", b: "sample_id, patient_name, test_name" },
  { m: "POST", p: "/api/lab/map-unmapped-test", a: "auth", d: "Re-map an unsolicited test's bill/result to a real patient found by reg_no.", b: "sample_id, patient_reg_no" },
  { m: "POST", p: "/api/lab/generate-sample-id", a: "auth", d: "Atomically generate a department-scoped sample ID (LAB-&lt;hospitalcode&gt;-&lt;date&gt;-&lt;seq&gt;).", b: "branch_id, department" },
  { m: "POST", p: "/api/lab/acknowledge-test", a: "auth", d: "Mark a bill item collected/acknowledged; also queues WhatsApp notifications to the next patients.", b: "bill_item_id, sample_id, short_id, status, collected_by" },
  { m: "POST", p: "/api/lab/update-test-status", a: "auth", d: "Update bill-item status (Pending/Collected/In Progress/Test Done/Completed).", b: "bill_item_id, status" },
  { m: "POST", p: "/api/lab/book-tests", a: "auth", d: "Create a bill + bill_items for booked lab tests.", b: "regNo, tests[], appointmentDate, appointmentTime, priority" },
  { m: "GET", p: "/api/lab/track/<span class='param'>:referenceNumber</span>", a: "auth", rl: "20 / 15 min", d: "Track status by bill number or lab barcode. Still behind authenticateToken despite the 'public tracking' framing in the frontend route." },
  { m: "POST", p: "/api/lab/save-test-results", a: "auth", d: "Save/merge analyzer results, move the bill item to 'Test Done', auto-deduct mapped reagent inventory.", b: "sample_id, machine_no, bill_item_id, test_id, test_name, results[], tested_by, patient_id, status" },
  { m: "GET", p: "/api/lab/test-results/<span class='param'>:sampleId</span>", a: "auth", d: "Get saved results for a sample." },
  { m: "GET", p: "/api/lab/pending-verifications", a: "auth", d: "Tests awaiting doctor verification." },
  { m: "POST", p: "/api/lab/verify-test", a: "auth", d: "Verify/approve results. On Approved, also completes the bill item and auto-sends a WhatsApp PDF report to the doctor.", b: "test_result_id, sample_id, verified_by, status ('Verified'|'Approved'), notes" },
  { m: "GET", p: "/api/lab/approved-reports", a: "auth", d: "List approved/completed reports." },
  { m: "GET", p: "/api/lab/report-details/<span class='param'>:sampleId</span>", a: "auth", d: "Full report detail for a sample." },
  { m: "GET", p: "/api/lab/generate-report-pdf/<span class='param'>:sampleId</span>", a: "auth", d: "Generate/stream the lab report PDF." },
  { m: "GET", p: "/api/lab/activity-logs", a: "auth", d: "Audit trail of lab activity.", b: "?branch_id= &amp; search= &amp; limit=" },
  { m: "POST", p: "/api/lab/whatsapp-send-report", a: "auth", d: "Fetch a generated PDF and send it via WhatsApp.", b: "sampleId, phone, patientName, testName" },
  { m: "GET", p: "/api/lab/kiosk-reports", a: "auth", d: "Kiosk lookup of reports by phone number (ABHA lookup removed — phone only)." },
]},
{ id: "lab-machines", title: "Lab — Machines & Analyzers", desc: "Analyzer inventory across the branch network, connection events (fed by LIS-Agent), and protocol lookups.", endpoints: [
  { m: "GET", p: "/api/lab/labs", a: "auth", d: "List labs (from the infrastructure table)." },
  { m: "GET", p: "/api/lab/suggested-lab", a: "auth", d: "Suggest a lab (routing logic)." },
  { m: "GET", p: "/api/lab/network-machines", a: "auth", d: "All analyzers across branches, grouped by branch (dashboard)." },
  { m: "GET", p: "/api/lab/machines/<span class='param'>:labId</span>", a: "auth", d: "List machines for a given lab." },
  { m: "GET", p: "/api/lab/machine-by-serial/<span class='param'>:serialNumber</span>", a: "auth", d: "Look up a machine by serial number." },
  { m: "POST", p: "/api/lab/machines", a: "auth", d: "Add a machine, auto-assigns tests to the lab.", b: "lab_id, machine_id, name, model, manufacturer" },
  { m: "POST", p: "/api/lab/machines/sync", a: "auth", d: "Upsert a machine by serial number (cloud sync, called by LIS-Agent's Setup screen).", b: "lab_id, machine_id, name, model, manufacturer, serial_number, interface_type, port_ip, baud_rate" },
  { m: "PUT", p: "/api/lab/machines/<span class='param'>:id</span>", a: "auth", d: "Update a machine.", b: "name, model, manufacturer, status" },
  { m: "DELETE", p: "/api/lab/machines/<span class='param'>:id</span>", a: "auth", d: "Delete a machine; clears lab_tests.lab_id if no other machine of the same model remains." },
  { m: "POST", p: "/api/lab/analyzer-event", a: "auth", d: "Log an analyzer connect/disconnect event (called by LIS-Agent) and sync machine status.", b: "machine_id, machine_name, model, lab_id, port, event ('ONLINE'|'OFFLINE'), ip_address" },
  { m: "GET", p: "/api/lab/analyzer-logs", a: "auth", d: "Analyzer connection history.", b: "?lab_id= &amp; machine_id= &amp; event= &amp; limit=" },
  { m: "GET", p: "/api/lab/machine-stats", a: "auth", d: "Dashboard: totals, brand/model breakdown, per-machine detail, tests today.", b: "?lab_id=" },
  { m: "GET", p: "/api/lab/machine-protocol/<span class='param'>:model</span>", a: "auth", d: "Get the communication protocol config for a machine model." },
  { m: "GET", p: "/api/lab/hospital-code/<span class='param'>:userId</span>", a: "auth", d: "Get the hospital code used for machine-ID generation." },
]},
{ id: "billing", title: "Billing", desc: "Bill creation, payment, and invoicing.", endpoints: [
  { m: "POST", p: "/api/billing/create", a: "auth", d: "Create a bill + bill_items. Branch enforced from JWT unless Central.", b: "patient_id, patient_name, patient_phone, items[], discount_amount, payment_method, payment_status, paid_amount, notes, appointment_booking?" },
  { m: "GET", p: "/api/billing/all", a: "auth", d: "List all bills." },
  { m: "GET", p: "/api/billing/services/available", a: "auth", d: "List billable services (lab tests, appointments, etc.)." },
  { m: "GET", p: "/api/billing/patients/list", a: "auth", d: "List patients for billing selection." },
  { m: "GET", p: "/api/billing/patient/<span class='param'>:regNo</span>", a: "auth", d: "Get bills for a patient. Branch-scoped — matches the same clinical context as getPatientChart." },
  { m: "POST", p: "/api/billing/send-whatsapp", a: "auth", d: "Send an arbitrary WhatsApp message via the bot.", b: "phone, message" },
  { m: "PUT", p: "/api/billing/<span class='param'>:id</span>", a: "auth", d: "Update a bill (replaces bill_items). Branch-scoped.", b: "patient_id, items[], discount_amount, payment_method, payment_status, paid_amount, notes" },
  { m: "GET", p: "/api/billing/<span class='param'>:id</span>/pdf", a: "auth", d: "Download the invoice PDF. Branch-scoped." },
  { m: "POST", p: "/api/billing/<span class='param'>:id</span>/payment", a: "auth", d: "Record a payment against a bill. Branch-scoped.", b: "paid_amount, payment_method" },
  { m: "DELETE", p: "/api/billing/<span class='param'>:id</span>", a: "auth", d: "Delete a bill. Branch-scoped." },
  { m: "GET", p: "/api/billing/<span class='param'>:id</span>", a: "auth", d: "Get a bill by id/number. Branch-scoped." },
]},
{ id: "billing-packages", title: "Billing Packages", desc: "Bundled service packages by department.", endpoints: [
  { m: "GET", p: "/api/billing-packages", a: "auth", d: "List packages with filters.", b: "?department= &amp; is_active= &amp; branch_id=" },
  { m: "GET", p: "/api/billing-packages/department/<span class='param'>:department</span>", a: "auth", d: "List active packages by department.", b: "?branch_id=" },
  { m: "GET", p: "/api/billing-packages/<span class='param'>:id</span>", a: "auth", d: "Get a package by package_id or numeric id." },
  { m: "POST", p: "/api/billing-packages", a: "auth", d: "Create a package.", b: "package_id?, name, department, description?, items[], discount_percent?, is_active?" },
  { m: "PUT", p: "/api/billing-packages/<span class='param'>:id</span>", a: "auth", d: "Partial update." },
  { m: "DELETE", p: "/api/billing-packages/<span class='param'>:id</span>", a: "auth", d: "Delete a package." },
]},
{ id: "inv-core-items", title: "Inventory (Core) — Items, Batches, Stock", desc: "The original/legacy inventory subsystem: item master, batches, current stock, and expiry/low-stock alerts.", endpoints: [
  { m: "GET", p: "/api/inventory/dashboard", a: "auth", d: "Overall inventory dashboard stats." },
  { m: "GET", p: "/api/inventory/items", a: "auth", d: "List item master records." },
  { m: "GET", p: "/api/inventory/items/categories", a: "auth", d: "Static list of item categories." },
  { m: "GET", p: "/api/inventory/items/<span class='param'>:id</span>", a: "auth", d: "Get an item by id." },
  { m: "POST", p: "/api/inventory/items", a: "auth", d: "Create an item (auto item_code), initializes a zero stock row.", b: "item_name, category, brand, manufacturer, unit, min_stock_level, reorder_level, storage_condition, cost_price, selling_cost, expiry_required, lot_tracking, status" },
  { m: "PUT", p: "/api/inventory/items/<span class='param'>:id</span>", a: "auth", d: "Update item master fields." },
  { m: "DELETE", p: "/api/inventory/items/<span class='param'>:id</span>", a: "auth", d: "Delete an item (blocked if it has existing stock)." },
  { m: "GET", p: "/api/inventory/batches", a: "auth", d: "List batches." },
  { m: "POST", p: "/api/inventory/batches", a: "auth", d: "Add a batch.", b: "item_id, batch_number, lot_number, manufacturing_date, expiry_date, vendor_id, quantity_received, unit_cost, grn_id, open_vial_date, stability_days, branch_id" },
  { m: "PUT", p: "/api/inventory/batches/<span class='param'>:id</span>", a: "auth", d: "Update a batch.", b: "status, open_vial_date, stability_days" },
  { m: "PUT", p: "/api/inventory/batches/<span class='param'>:id</span>/open-vial", a: "auth", d: "Mark a vial/batch opened.", b: "open_vial_date, stability_days" },
  { m: "GET", p: "/api/inventory/alerts/low-stock", a: "auth", d: "Low stock alerts.", b: "?branch_id= &amp; role_level=" },
  { m: "GET", p: "/api/inventory/alerts/expiry", a: "auth", d: "Items nearing expiry." },
  { m: "GET", p: "/api/inventory/alerts/expired", a: "auth", d: "Already-expired stock." },
  { m: "GET", p: "/api/inventory/stock", a: "auth", d: "Current stock levels." },
  { m: "GET", p: "/api/inventory/stock/batches", a: "auth", d: "Stock levels joined with batches." },
  { m: "GET", p: "/api/inventory/stock/transactions", a: "auth", d: "Stock transaction history." },
  { m: "POST", p: "/api/inventory/stock/adjust", a: "auth", d: "Manual stock adjustment, logs a transaction.", b: "item_id, batch_id, adjustment_qty (non-zero), reason, performed_by" },
  { m: "GET", p: "/api/inventory/qc-inventory", a: "auth", d: "QC/Control/Calibrator batches with expiry/vial-stability calculations.", b: "?status=" },
]},
{ id: "inv-core-vendors", title: "Inventory (Core) — Vendors & Procurement", desc: "Vendors, purchase requisitions, purchase orders, and goods-receipt notes.", endpoints: [
  { m: "GET", p: "/api/inventory/vendors", a: "auth", d: "List vendors." },
  { m: "GET", p: "/api/inventory/vendors/purchase-summary", a: "auth", d: "Vendor purchase totals summary." },
  { m: "GET", p: "/api/inventory/vendors/<span class='param'>:id</span>", a: "auth", d: "Get a vendor by id." },
  { m: "POST", p: "/api/inventory/vendors", a: "auth", d: "Create a vendor (auto vendor_code).", b: "vendor_name, contact_person, phone, email, address, gst_number, payment_terms, lead_time_days" },
  { m: "PUT", p: "/api/inventory/vendors/<span class='param'>:id</span>", a: "auth", d: "Update a vendor." },
  { m: "DELETE", p: "/api/inventory/vendors/<span class='param'>:id</span>", a: "auth", d: "Delete a vendor." },
  { m: "GET", p: "/api/inventory/purchase-requisitions", a: "auth", d: "List purchase requisitions." },
  { m: "GET", p: "/api/inventory/purchase-requisitions/<span class='param'>:id</span>", a: "auth", d: "Get a PR by id." },
  { m: "POST", p: "/api/inventory/purchase-requisitions", a: "auth", d: "Create a PR with line items (transactional).", b: "department_id, request_date, required_date, priority, notes, items[], requested_by, branch_id" },
  { m: "PUT", p: "/api/inventory/purchase-requisitions/<span class='param'>:id</span>", a: "auth", d: "Update a PR.", b: "priority, required_date, notes, status" },
  { m: "PUT", p: "/api/inventory/purchase-requisitions/<span class='param'>:id</span>/approve", a: "auth", d: "Approve/reject a PR.", b: "status, notes" },
  { m: "GET", p: "/api/inventory/purchase-orders", a: "auth", d: "List purchase orders.", b: "?status= &amp; vendor_id= &amp; branch_id= &amp; role_level= &amp; district_id=" },
  { m: "GET", p: "/api/inventory/purchase-orders/<span class='param'>:id</span>", a: "auth", d: "Get a PO by id." },
  { m: "POST", p: "/api/inventory/purchase-orders", a: "auth", d: "Create a PO (adds 18% GST), marks the source PR converted.", b: "pr_id, vendor_id, order_date, expected_delivery, delivery_location, terms_conditions, items[], created_by, branch_id" },
  { m: "PUT", p: "/api/inventory/purchase-orders/<span class='param'>:id</span>", a: "auth", d: "Update a PO.", b: "expected_delivery, terms_conditions, status" },
  { m: "GET", p: "/api/inventory/goods-receipts", a: "auth", d: "List GRNs." },
  { m: "GET", p: "/api/inventory/goods-receipts/<span class='param'>:id</span>", a: "auth", d: "Get a GRN by id." },
  { m: "POST", p: "/api/inventory/goods-receipts", a: "auth", d: "Create a GRN with items (adds 18% GST).", b: "po_id, vendor_id, receipt_date, invoice_number, invoice_date, notes, items[], received_by, branch_id" },
  { m: "PUT", p: "/api/inventory/goods-receipts/<span class='param'>:id</span>/approve", a: "auth", d: "Approve a GRN (updates stock, creates batches on approval).", b: "status, approved_by" },
  { m: "GET", p: "/api/inventory/pending-grn", a: "auth", d: "List POs pending GRN creation." },
]},
{ id: "inv-core-transfers", title: "Inventory (Core) — Transfers, Reagents, Reports", desc: "Inter-department transfers, reagent-per-test mapping and auto-consumption, and canned reports.", endpoints: [
  { m: "GET", p: "/api/inventory/transfers", a: "auth", d: "List inter-department stock transfers.", b: "?status= &amp; from_department= &amp; to_department=" },
  { m: "GET", p: "/api/inventory/transfers/<span class='param'>:id</span>", a: "auth", d: "Get a transfer + items." },
  { m: "POST", p: "/api/inventory/transfers", a: "auth", d: "Create a transfer request, validates available stock.", b: "from_department, to_department, transfer_date, notes, items[], requested_by" },
  { m: "PUT", p: "/api/inventory/transfers/<span class='param'>:id</span>/approve", a: "auth", d: "Approve a stock transfer." },
  { m: "PUT", p: "/api/inventory/transfers/<span class='param'>:id</span>/receive", a: "auth", d: "Mark a transfer received (moves stock between departments)." },
  { m: "GET", p: "/api/inventory/reagent-mappings", a: "auth", d: "List test-reagent mappings.", b: "?test_id= &amp; item_id=" },
  { m: "POST", p: "/api/inventory/reagent-mappings", a: "auth", d: "Create a reagent-test mapping.", b: "test_id, item_id, quantity_per_test, unit, notes" },
  { m: "PUT", p: "/api/inventory/reagent-mappings/<span class='param'>:id</span>", a: "auth", d: "Update a mapping." },
  { m: "DELETE", p: "/api/inventory/reagent-mappings/<span class='param'>:id</span>", a: "auth", d: "Delete a mapping." },
  { m: "GET", p: "/api/inventory/tests/<span class='param'>:test_id</span>/reagents", a: "auth", d: "Get reagents required for a test." },
  { m: "POST", p: "/api/inventory/consume-reagents", a: "auth", d: "Auto-consume mapped reagents for a test using FEFO batch selection; logs consumption + transaction.", b: "test_result_id, bill_item_id, sample_id, test_id, performed_by" },
  { m: "GET", p: "/api/inventory/consumption-logs", a: "auth", d: "Consumption log history.", b: "?test_result_id= &amp; sample_id= &amp; item_id= &amp; start_date= &amp; end_date=" },
  { m: "GET", p: "/api/inventory/reports/stock-ledger", a: "auth", d: "Stock ledger report." },
  { m: "GET", p: "/api/inventory/reports/consumption", a: "auth", d: "Consumption report." },
  { m: "GET", p: "/api/inventory/reports/expiry", a: "auth", d: "Expiry report." },
  { m: "GET", p: "/api/inventory/reports/purchase", a: "auth", d: "Purchase report." },
  { m: "GET", p: "/api/inventory/reports/reagent-usage", a: "auth", d: "Reagent usage by test report." },
  { m: "GET", p: "/api/inventory/reports/low-stock", a: "auth", d: "Low stock report." },
]},
{ id: "inv2-master", title: "Inventory v2 — Master Data", desc: "A second, parallel inventory schema (vendors/items/batches) — simpler shape than the Core subsystem above.", endpoints: [
  { m: "GET", p: "/api/v2/inventory/vendors", a: "auth", d: "List v2 vendors.", b: "?status= &amp; search=" },
  { m: "GET", p: "/api/v2/inventory/vendors/<span class='param'>:id</span>", a: "auth", d: "Get a vendor by id." },
  { m: "POST", p: "/api/v2/inventory/vendors", a: "auth", d: "Create a vendor (auto vendor_code 'IVND...').", b: "vendor_name, contact_person, phone, email, address, tax_id, payment_terms, lead_time_days, bank_name, account_number, ifsc_code, status, rating" },
  { m: "PUT", p: "/api/v2/inventory/vendors/<span class='param'>:id</span>", a: "auth", d: "Update a vendor." },
  { m: "DELETE", p: "/api/v2/inventory/vendors/<span class='param'>:id</span>", a: "auth", d: "Delete a vendor (blocked if referenced by POs)." },
  { m: "GET", p: "/api/v2/inventory/items", a: "auth", d: "List v2 items.", b: "?status= &amp; category= &amp; search=" },
  { m: "GET", p: "/api/v2/inventory/items/<span class='param'>:id</span>", a: "auth", d: "Get an item by id." },
  { m: "POST", p: "/api/v2/inventory/items", a: "auth", d: "Create an item (auto item_code 'ITEM-...').", b: "item_code?, item_name, category, unit, min_stock_level, reorder_level, status, default_vendor_id, delivery_lead_time_days, unit_price" },
  { m: "PUT", p: "/api/v2/inventory/items/<span class='param'>:id</span>", a: "auth", d: "Update an item." },
  { m: "DELETE", p: "/api/v2/inventory/items/<span class='param'>:id</span>", a: "auth", d: "Delete an item (no dependency check)." },
  { m: "GET", p: "/api/v2/inventory/batches", a: "auth", d: "List batches (dynamically flags expired ones).", b: "?status= &amp; item_id= &amp; branch_id= &amp; search=" },
  { m: "GET", p: "/api/v2/inventory/batches/<span class='param'>:id</span>", a: "auth", d: "Get a batch by id." },
  { m: "POST", p: "/api/v2/inventory/batches", a: "auth", d: "Create a batch.", b: "item_id, vendor_id, branch_id, batch_number, expiry_date, quantity_available, quantity_received, purchase_date, status" },
  { m: "PUT", p: "/api/v2/inventory/batches/<span class='param'>:id</span>", a: "auth", d: "Update a batch." },
  { m: "DELETE", p: "/api/v2/inventory/batches/<span class='param'>:id</span>", a: "auth", d: "Delete a batch." },
]},
{ id: "inv2-tx", title: "Inventory v2 — Transactions, Mappings, Analytics", desc: "Stock movement logging, test-item mappings, smart analytics, and reorder suggestions.", endpoints: [
  { m: "GET", p: "/api/v2/inventory/transactions", a: "auth", d: "List transactions.", b: "?item_id= &amp; batch_id= &amp; type= &amp; start_date= &amp; end_date= &amp; branch_id=" },
  { m: "POST", p: "/api/v2/inventory/transactions", a: "auth", d: "Log a transaction, adjusts batch quantity, marks batch Empty if depleted, triggers auto-reorder check.", b: "item_id, batch_id, type ('IN'|'OUT'|'ADJUSTMENT'), quantity, reference_type, reference_id, remarks, created_by, branch_id" },
  { m: "GET", p: "/api/v2/inventory/mappings", a: "auth", d: "List test-item consumption mappings.", b: "?test_id=" },
  { m: "POST", p: "/api/v2/inventory/mappings", a: "auth", d: "Create a mapping.", b: "test_id, item_id, quantity_required" },
  { m: "DELETE", p: "/api/v2/inventory/mappings/<span class='param'>:id</span>", a: "auth", d: "Delete a mapping." },
  { m: "GET", p: "/api/v2/inventory/analytics", a: "auth", d: "Smart inventory analytics (predictive/consumption insights)." },
  { m: "GET", p: "/api/v2/inventory/suggestions", a: "auth", d: "List purchase suggestions.", b: "?branch_id=" },
  { m: "POST", p: "/api/v2/inventory/suggestions/generate", a: "auth", d: "Compute reorder point per item from 30-day usage (ADU/lead time/safety buffer), create/update Pending suggestions.", b: "branch_id" },
  { m: "PUT", p: "/api/v2/inventory/suggestions/<span class='param'>:id</span>", a: "auth", d: "Update suggestion status.", b: "status" },
]},
{ id: "inv2-transfers", title: "Inventory v2 — Inter-Branch Transfers", desc: "Stock transfers between branches (distinct from the Core subsystem's inter-department transfers).", endpoints: [
  { m: "GET", p: "/api/v2/inventory/transfers", a: "auth", d: "List inter-branch transfers with items." },
  { m: "POST", p: "/api/v2/inventory/transfers", a: "auth", d: "Create a transfer request (validates batch qty/expiry), auto-generates transfer_number.", b: "from_branch_id, to_branch_id (must differ), notes, items[], created_by" },
  { m: "PUT", p: "/api/v2/inventory/transfers/<span class='param'>:id</span>/status", a: "auth", d: "State-machine transition: APPROVED &rarr; IN_TRANSIT (deducts source stock) &rarr; COMPLETED (creates/adds destination batch + stock), or CANCELLED.", b: "status, user_id" },
]},
{ id: "inv2-ap", title: "Inventory v2 — Accounts Payable & Procurement", desc: "Supplier invoices/payments/ledger, and a second procurement (PR/PO) flow parallel to the Core one.", endpoints: [
  { m: "GET", p: "/api/v2/inventory/ap/stats", a: "auth", d: "AP dashboard stats (total payable, paid this month, overdue).", b: "?branch_id=" },
  { m: "GET", p: "/api/v2/inventory/ap/invoices", a: "auth", d: "List supplier invoices.", b: "?status= &amp; vendor_id= &amp; branch_id=" },
  { m: "POST", p: "/api/v2/inventory/ap/invoices", a: "auth", d: "Create a supplier invoice + ledger debit entry.", b: "invoice_number, vendor_id, po_id?, grn_id?, invoice_date, due_date, total_amount, branch_id?" },
  { m: "POST", p: "/api/v2/inventory/ap/payments", a: "auth", d: "Record a payment; updates invoice status, adds ledger credit, auto-generates payment_number.", b: "vendor_id, invoice_id, amount (&le; pending balance), payment_method, reference_no, paid_by, branch_id?" },
  { m: "GET", p: "/api/v2/inventory/ap/ledger/<span class='param'>:vendor_id</span>", a: "auth", d: "Get supplier ledger history." },
  { m: "GET", p: "/api/v2/inventory/procurement/requisitions", a: "auth", d: "List PRs (v2 table) with items.", b: "?branch_id= &amp; role_level=" },
  { m: "POST", p: "/api/v2/inventory/procurement/requisitions", a: "auth", d: "Create a PR, auto pr_number.", b: "branch_id, items[] (item_id + quantity each), requested_by" },
  { m: "PUT", p: "/api/v2/inventory/procurement/requisitions/<span class='param'>:id</span>/status", a: "auth", d: "Update PR status.", b: "status, approved_by" },
  { m: "GET", p: "/api/v2/inventory/procurement/orders", a: "auth", d: "List POs with items.", b: "?branch_id= &amp; role_level=" },
  { m: "POST", p: "/api/v2/inventory/procurement/orders", a: "auth", d: "Create a PO, computes totals, marks source PR PO_CREATED.", b: "vendor_id, expected_delivery_date, items[] (item_id + quantity each), created_by, pr_id?" },
  { m: "PUT", p: "/api/v2/inventory/procurement/orders/<span class='param'>:id</span>/status", a: "auth", d: "Update PO status." },
  { m: "POST", p: "/api/v2/inventory/procurement/orders/<span class='param'>:id</span>/send-email", a: "auth", d: "Email the PO to the vendor with a PDF attachment; fires a WhatsApp notification if a vendor phone is on file.", b: "pdf_base64" },
]},
{ id: "inv-network", title: "Inventory — Network Stats", desc: "Cross-branch inventory rollups by network tier.", endpoints: [
  { m: "GET", p: "/api/inventory-network/central", a: "auth", d: "Central-warehouse inventory stats." },
  { m: "GET", p: "/api/inventory-network/sub-central", a: "auth", d: "Sub-central warehouse inventory stats." },
  { m: "GET", p: "/api/inventory-network/branch", a: "auth", d: "Branch-level inventory stats." },
  { m: "GET", p: "/api/inventory-network/overall", a: "auth", d: "Overall/network-wide stock stats." },
]},
{ id: "barcodes", title: "Barcodes", desc: "Code128 + QR generation for sample/prescription labels.", endpoints: [
  { m: "POST", p: "/api/barcodes/generate", a: "auth", d: "Generate a batch of barcode + QR images. count is capped 1–200.", b: "prefix, year, startNumber, count (1–200)" },
  { m: "GET", p: "/api/barcodes/sample/<span class='param'>:sampleId</span>", a: "auth", d: "Generate a single barcode + QR for a lab sample.", b: "?full_id=" },
]},
{ id: "settings-infra", title: "Settings & Infrastructure", desc: "Hospital-wide settings and physical infrastructure (rooms/wards/beds — distinct from the org-setup bed endpoints above).", endpoints: [
  { m: "GET", p: "/api/settings", a: "auth", d: "Get hospital settings." },
  { m: "PUT", p: "/api/settings", a: "auth", d: "Upsert hospital settings.", b: "hospital_name, logo_url, address, phone, website, email, smtp_host, smtp_port?, smtp_user, smtp_pass, smtp_from_name, registration_fee?" },
  { m: "GET", p: "/api/infra", a: "auth", d: "List infrastructure items. Non-Central callers scoped to their own branch.", b: "?type= &amp; branch_id= (Central only)" },
  { m: "POST", p: "/api/infra/add", a: "auth", d: "Add an infrastructure item. branch_id forced to caller's branch unless Central.", b: "name, type, block, floor, capacity, status, branch_id" },
  { m: "PUT", p: "/api/infra/update/<span class='param'>:id</span>", a: "auth", d: "Update an item. Non-Central callers restricted to their own branch's records.", b: "name, type, block, floor, capacity, status" },
  { m: "DELETE", p: "/api/infra/delete/<span class='param'>:id</span>", a: "auth", d: "Delete an item. Non-Central callers restricted to their own branch's records." },
]},
{ id: "integrations", title: "Integrations", desc: "External-system sync: HL7-style HMIS integration and a CARE-order ingestion endpoint. Both use the shared X-API-Key scheme, not staff JWTs.", endpoints: [
  { m: "GET", p: "/api/hl7/patient/search", a: "key", d: "Search a patient by HL7-mappable fields, returns a PID-segment-style structure.", b: "?phone= | name= | aadhar= | uhid= (one required)" },
  { m: "POST", p: "/api/hl7/patient/register", a: "key", d: "Register a patient from an external HMIS via HL7-structured payload.", b: "uhid?, title, first_name, middle_name, last_name, dob, gender, phone, email, address, city, zip, aadhar, branch_id" },
  { m: "POST", p: "/send-order", a: "key", d: "Receive an external CARE/HL7 ORM order message; finds-or-creates the patient, resolves tests against the catalog, creates a bill + bill_items. Responds with an HL7-style ACK.", b: "raw_message (raw HL7 ORM string)" },
]},
{ id: "dashboard", title: "Dashboard", desc: "Aggregated KPIs at every network tier.", endpoints: [
  { m: "GET", p: "/api/dashboard/stats", a: "auth", d: "Legacy/global dashboard: totals, today vs yesterday, pending reports, revenue, recent activity." },
  { m: "GET", p: "/api/dashboard/central", a: "auth", d: "Central-admin dashboard: network branch counts, KPIs, per-branch breakdown, category breakdown, 7-day trend, recent activity." },
  { m: "GET", p: "/api/dashboard/sub-central", a: "auth", d: "District-scoped dashboard.", b: "?district_id=" },
  { m: "GET", p: "/api/dashboard/branch", a: "auth", d: "Single-branch dashboard: KPIs, category breakdown, top tests, 7-day trend, recent activity.", b: "?branch_id=" },
]},
{ id: "disaster", title: "Disaster Surveillance", desc: "Disease surveillance and alerting.", flag: "Both endpoints currently have zero auth middleware — genuinely public, unlike most of the API.", endpoints: [
  { m: "GET", p: "/api/disaster/surveillance", a: "public", d: "Disease surveillance data for the latest recorded date.", b: "?timeFilter= (accepted but currently unused)" },
  { m: "GET", p: "/api/disaster/alerts", a: "public", d: "Disaster/disease alerts (currently returns a hardcoded/mock list)." },
]},
{ id: "developer", title: "Developer Portal", desc: "Platform-operator console with its own OTP + JWT scheme (DEVELOPER_JWT_SECRET), entirely separate from staff/patient auth. The OTP-request step only accepts one hardcoded operator email.", endpoints: [
  { m: "POST", p: "/api/dev/send-otp", a: "public", rl: "5 / 10 min", d: "Send a 6-digit OTP (5-min expiry) to the configured developer email.", b: "email (must match DEVELOPER_EMAIL)" },
  { m: "POST", p: "/api/dev/verify-otp", a: "public", rl: "5 / 10 min", d: "Verify OTP (max 3 attempts) &rarr; developer JWT, 8h expiry.", b: "email, otp" },
  { m: "GET", p: "/api/dev/stats", a: "dev", d: "Global platform stats: hospitals/labs/users/active-users/districts, bills &amp; tests today." },
  { m: "GET", p: "/api/dev/hospitals", a: "dev", d: "List all branches + districts." },
  { m: "POST", p: "/api/dev/hospitals", a: "dev", d: "Create a hospital/branch.", b: "district_id, branch_name, hospital_code, category?, address, contact_number, branch_level?, parent_branch_id?" },
  { m: "PUT", p: "/api/dev/hospitals/<span class='param'>:id</span>", a: "dev", d: "Update a hospital/branch." },
  { m: "DELETE", p: "/api/dev/hospitals/<span class='param'>:id</span>", a: "dev", d: "Delete a hospital/branch (blocked if linked records exist)." },
  { m: "POST", p: "/api/dev/districts", a: "dev", d: "Create a district.", b: "name, state?" },
  { m: "GET", p: "/api/dev/labs", a: "dev", d: "List lab infrastructure entries with branch info + machine counts.", b: "?branch_id=" },
  { m: "POST", p: "/api/dev/labs", a: "dev", d: "Create a lab.", b: "name, branch_id, block?, floor?, capacity?, status?" },
  { m: "PUT", p: "/api/dev/labs/<span class='param'>:id</span>", a: "dev", d: "Update a lab." },
  { m: "DELETE", p: "/api/dev/labs/<span class='param'>:id</span>", a: "dev", d: "Delete a lab (blocked if machines/records reference it)." },
  { m: "GET", p: "/api/dev/brands", a: "dev", d: "List machine-brand protocol definitions from utils/machinesid.json." },
  { m: "GET", p: "/api/dev/users", a: "dev", d: "List all users network-wide.", b: "?branch_id= &amp; role=" },
  { m: "POST", p: "/api/dev/users", a: "dev", d: "Create a user/staff account.", b: "firstName, lastName, email, phone?, role, department?, staffId?, password, branch_id?, role_level?" },
  { m: "PUT", p: "/api/dev/users/<span class='param'>:id</span>", a: "dev", d: "Update a user." },
  { m: "PATCH", p: "/api/dev/users/<span class='param'>:id</span>/toggle", a: "dev", d: "Toggle a user's is_active flag." },
  { m: "PATCH", p: "/api/dev/users/<span class='param'>:id</span>/reset-password", a: "dev", d: "Reset a user's password.", b: "password (min 6 chars)" },
]},
];

const AUTH_LABELS = { auth: 'JWT', public: 'public', key: 'API key', dev: 'dev JWT' };

function EndpointCard({ e }) {
  return (
    <div className="api-endpoint">
      <div className="api-endpoint-row">
        <span className={`api-method api-method-${e.m.toLowerCase()}`}>{e.m}</span>
        <span className="api-path" dangerouslySetInnerHTML={{ __html: e.p }} />
        <span className={`api-auth-badge api-auth-${e.a}`}>{AUTH_LABELS[e.a] || e.a}</span>
        {e.rl && <span className="api-auth-badge">{e.rl}</span>}
      </div>
      <div className="api-endpoint-body">
        <p className="api-endpoint-desc" dangerouslySetInnerHTML={{ __html: e.d }} />
        {e.r && <div className="api-endpoint-meta"><span className="api-role">role: {e.r}</span></div>}
        {e.b && (
          <div className="api-body-params">
            <span className="api-params-label">params</span>
            <span dangerouslySetInnerHTML={{ __html: e.b }} />
          </div>
        )}
      </div>
    </div>
  );
}

export default function ApiDocs() {
  const [query, setQuery] = useState('');
  const [activeGroup, setActiveGroup] = useState(API[0].id);

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return API;
    return API
      .map(group => ({
        ...group,
        endpoints: group.endpoints.filter(e =>
          (e.m + ' ' + e.p + ' ' + e.d + ' ' + (e.b || '')).replace(/<[^>]+>/g, '').toLowerCase().includes(q)
        ),
      }))
      .filter(group => group.endpoints.length > 0);
  }, [query]);

  const totalEndpoints = API.reduce((sum, g) => sum + g.endpoints.length, 0);

  return (
    <div className="api-docs-shell">
      <aside className="api-sidebar">
        <div className="api-sidebar-head">
          <div className="api-brand">HIMS Backend API</div>
          <div className="api-brand-sub">v1 &middot; internal reference</div>
        </div>
        <div className="api-search-wrap">
          <input
            className="api-search-input"
            type="text"
            placeholder="Search paths, methods, fields&hellip;"
            autoComplete="off"
            value={query}
            onChange={(ev) => setQuery(ev.target.value)}
          />
        </div>
        <div className="api-stats-row">
          <span><b>{totalEndpoints}</b> endpoints</span>
          <span><b>{API.length}</b> groups</span>
        </div>
        <nav className="api-nav">
          {filtered.map(group => (
            <a
              key={group.id}
              className={`api-nav-item${activeGroup === group.id ? ' active' : ''}`}
              href={`#${group.id}`}
              onClick={() => setActiveGroup(group.id)}
            >
              <span>{group.title}</span>
              <span className="api-nav-item-count">{group.endpoints.length}</span>
            </a>
          ))}
        </nav>
      </aside>

      <main className="api-main">
        <div className="api-page-head">
          <div className="api-eyebrow">Reference &middot; HIMS-backend</div>
          <h1>API Reference</h1>
          <p className="api-dek">Every route mounted in <code>server.js</code>, grouped by resource. Auth column reflects what's actually enforced in each route file today &mdash; <code>authenticateToken</code> (JWT), a specific role list, the shared <code>X-API-Key</code> scheme, or none.</p>
          <div className="api-legend">
            <span><span className="api-dot" style={{ background: 'var(--api-get)' }} />GET</span>
            <span><span className="api-dot" style={{ background: 'var(--api-post)' }} />POST</span>
            <span><span className="api-dot" style={{ background: 'var(--api-put)' }} />PUT</span>
            <span><span className="api-dot" style={{ background: 'var(--api-patch)' }} />PATCH</span>
            <span><span className="api-dot" style={{ background: 'var(--api-delete)' }} />DELETE</span>
          </div>
        </div>

        {filtered.length === 0 && <div className="api-no-results">No endpoints match your search.</div>}

        {filtered.map(group => (
          <section className="api-group" id={group.id} key={group.id}>
            <div className="api-group-head">
              <h2>{group.title}</h2>
              <span className="api-group-count">{group.endpoints.length} endpoints</span>
            </div>
            <p className="api-group-desc">{group.desc}</p>
            {group.flag && <div className="api-group-flag">&#9888; {group.flag}</div>}
            <div style={{ marginTop: 16 }}>
              {group.endpoints.map((e, i) => <EndpointCard e={e} key={i} />)}
            </div>
          </section>
        ))}
      </main>
    </div>
  );
}
