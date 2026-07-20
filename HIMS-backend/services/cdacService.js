/**
 * CDAC e-Sushrut HMIS integration — raw API client.
 * 7 endpoints, all called BY us (CDAC never pushes to us). See
 * Meril_CDAC_LIS_Integration_API_Docs.md at the repo root for the full contract.
 *
 * Open items (see plan doc): no token refresh endpoint is documented for the
 * Bearer JWT, the correct host per environment is unconfirmed, and whether
 * API-ACCESS-KEY is per-endpoint/per-branch/shared is unconfirmed. getCdacToken()
 * is a single swappable seam for the first; the header resolution below covers
 * the other two without needing a code change once confirmed.
 */
import db from '../config/db.js';

const OPERATION_REQUEST_TYPE = {
  getHmisHospMapDataRowData: '7',
  patDemographicInvestigationDtls: '1',
  patSampleCollectionAndRequisitionDtls: '2',
  patInvestigationStatusUpdateDtls: '3',
  patInvestigationViewDtls: '4',
  patInvestigationReportDtls: '5',
  patInvestigationStatusUpdateDtlsRowData: '31',
};

/** Swappable auth seam — replace once CDAC clarifies token issuance/refresh. */
export async function getCdacToken() {
  return process.env.CDAC_BEARER_TOKEN || null;
}

export async function getBranchCdacConfig(branchId) {
  const [[row]] = await db.query(
    `SELECT * FROM branch_hmis_config WHERE branch_id = ? LIMIT 1`,
    [branchId]
  );
  return row || null;
}

function resolveApiAccessKey(hmisRequestType, branchConfig) {
  if (branchConfig?.api_access_key_override) return branchConfig.api_access_key_override;

  if (process.env.CDAC_API_ACCESS_KEY_MAP) {
    try {
      const map = JSON.parse(process.env.CDAC_API_ACCESS_KEY_MAP);
      if (map[hmisRequestType]) return map[hmisRequestType];
    } catch (e) {
      console.error('CDAC_API_ACCESS_KEY_MAP is not valid JSON:', e.message);
    }
  }

  return process.env.CDAC_API_ACCESS_KEY || null;
}

/** Redact the ~260KB base64 PDF before persisting a log row. */
function redactForLog(body) {
  if (!body?.investigation_data?.some((item) => item.poct_pdf_rpt_base64)) return body;
  return {
    ...body,
    investigation_data: body.investigation_data.map((item) =>
      item.poct_pdf_rpt_base64
        ? { ...item, poct_pdf_rpt_base64: `<redacted, length=${item.poct_pdf_rpt_base64.length}>` }
        : item
    ),
  };
}

async function logCdacCall({
  operation, hmisRequestType, branchId, requestBody, responseBody,
  httpStatus, success, errorMessage, durationMs,
}) {
  const firstItem = requestBody?.investigation_data?.[0];
  try {
    await db.query(
      `INSERT INTO cdac_integration_logs
        (operation, hmis_request_type, bill_item_id, hmis_req_no, hmis_req_dno, hmis_patCrNo,
         branch_id, request_payload, response_payload, http_status, success, error_message, duration_ms)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        operation,
        hmisRequestType || null,
        null,
        firstItem?.hmis_req_no || null,
        firstItem?.hmis_req_dno || null,
        requestBody?.hmis_patCrNo || null,
        branchId || null,
        JSON.stringify(redactForLog(requestBody)),
        responseBody != null ? JSON.stringify(responseBody) : null,
        httpStatus || null,
        success ? 1 : 0,
        errorMessage || null,
        durationMs || null,
      ]
    );
  } catch (logErr) {
    console.error('Failed to write cdac_integration_logs row:', logErr.message);
  }
}

/**
 * Shared caller for all 7 endpoints.
 * @param {string} operation - operation name, also the URL path segment
 * @param {object} body - request body, minus hmis_request_type (added here)
 * @param {object} [opts]
 * @param {object} [opts.branchConfig] - row from branch_hmis_config, for key override
 * @param {number} [opts.timeoutMs]
 */
async function callCdac(operation, body, { branchConfig = null, timeoutMs } = {}) {
  const hmisRequestType = OPERATION_REQUEST_TYPE[operation];
  if (!hmisRequestType) throw new Error(`Unknown CDAC operation: ${operation}`);

  const baseUrl = process.env.CDAC_BASE_URL;
  if (!baseUrl) throw new Error('CDAC_BASE_URL is not configured');

  const fullBody = { ...body, hmis_request_type: hmisRequestType };
  const isReportCall = operation === 'patInvestigationReportDtls';
  const effectiveTimeout =
    timeoutMs ||
    Number(isReportCall ? process.env.CDAC_REPORT_REQUEST_TIMEOUT_MS : process.env.CDAC_REQUEST_TIMEOUT_MS) ||
    (isReportCall ? 60000 : 15000);

  const headers = {
    'Content-Type': 'application/json',
    'HMIS-EXT-USER': process.env.CDAC_HMIS_EXT_USER || '',
    'API-ACCESS-KEY': resolveApiAccessKey(hmisRequestType, branchConfig) || '',
  };
  const token = await getCdacToken();
  if (token) headers['Authorization'] = `Bearer ${token}`;

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), effectiveTimeout);

  const startedAt = Date.now();
  let httpStatus = null;
  let responseBody = null;
  let success = false;
  let errorMessage = null;

  try {
    const res = await fetch(`${baseUrl}/hmis/api/inv/IntegrationHmisPoct/${operation}`, {
      method: 'POST',
      headers,
      body: JSON.stringify(fullBody),
      signal: controller.signal,
    });
    httpStatus = res.status;

    const text = await res.text();
    try { responseBody = text ? JSON.parse(text) : null; } catch { responseBody = { raw: text }; }

    if (!res.ok) {
      throw new Error(`CDAC ${operation} returned HTTP ${res.status}: ${text.slice(0, 500)}`);
    }

    // CDAC has been observed to return HTTP 200 with a top-level "status": "OK"
    // envelope even when data.Status carries an error message — log a warning,
    // but don't treat it as fatal since the exact semantics aren't confirmed.
    const nestedStatus = responseBody?.data?.Status || responseBody?.data?.status;
    if (nestedStatus && /error|invalid|define/i.test(nestedStatus)) {
      console.warn(`CDAC ${operation} returned HTTP 200 but data.Status looks like an error: "${nestedStatus}"`);
    }

    success = true;
    return responseBody;
  } catch (err) {
    errorMessage = err.name === 'AbortError' ? `Timed out after ${effectiveTimeout}ms` : err.message;
    throw err;
  } finally {
    clearTimeout(timer);
    await logCdacCall({
      operation,
      hmisRequestType,
      branchId: branchConfig?.branch_id,
      requestBody: fullBody,
      responseBody,
      httpStatus,
      success,
      errorMessage,
      durationMs: Date.now() - startedAt,
    });
  }
}

// ── API 7 — master data pull ────────────────────────────────────────────────
export async function getHmisHospMapDataRowData(hospMappingCode, branchConfig) {
  return callCdac('getHmisHospMapDataRowData', {
    hmis_hosp_mapping_code: hospMappingCode,
  }, { branchConfig });
}

// ── API 1 — patient + investigation pull ────────────────────────────────────
export async function getPatDemographicInvestigationDtls({ hospMappingCode, patCrNo }, branchConfig) {
  return callCdac('patDemographicInvestigationDtls', {
    hmis_hosp_mapping_code: hospMappingCode,
    hmis_patCrNo: patCrNo,
  }, { branchConfig });
}

// ── API 2 — sample collected push ───────────────────────────────────────────
export async function pushSampleCollectionAndRequisitionDtls(
  { hospMappingCode, patCrNo, episodeCode, episodeVisitNo, investigationData },
  branchConfig
) {
  return callCdac('patSampleCollectionAndRequisitionDtls', {
    hmis_hosp_mapping_code: hospMappingCode,
    hmis_patCrNo: patCrNo,
    hmis_episode_code: episodeCode,
    hmis_episode_visitno: episodeVisitNo,
    investigation_data: investigationData,
  }, { branchConfig });
}

// ── API 3 — overall status push (e.g. AUTHORIZED) ───────────────────────────
export async function pushInvestigationStatusUpdateDtls({ hospMappingCode, patCrNo, investigationData }, branchConfig) {
  return callCdac('patInvestigationStatusUpdateDtls', {
    hmis_hosp_mapping_code: hospMappingCode,
    hmis_patCrNo: patCrNo,
    investigation_data: investigationData,
  }, { branchConfig });
}

// ── API 4 — re-view a requisition ───────────────────────────────────────────
export async function getInvestigationViewDtls({ hospMappingCode, patCrNo, investigationData }, branchConfig) {
  return callCdac('patInvestigationViewDtls', {
    hmis_hosp_mapping_code: hospMappingCode,
    hmis_patCrNo: patCrNo,
    investigation_data: investigationData,
  }, { branchConfig });
}

// ── API 5 — final PDF report push ───────────────────────────────────────────
export async function pushInvestigationReportDtls({ hospMappingCode, patCrNo, investigationData }, branchConfig) {
  return callCdac('patInvestigationReportDtls', {
    hmis_hosp_mapping_code: hospMappingCode,
    hmis_patCrNo: patCrNo,
    investigation_data: investigationData,
  }, { branchConfig });
}

// ── API 31 — parameter-level result values push ─────────────────────────────
export async function pushInvestigationStatusUpdateDtlsRowData(
  { hospMappingCode, patCrNo, investigationData },
  branchConfig
) {
  return callCdac('patInvestigationStatusUpdateDtlsRowData', {
    hmis_hosp_mapping_code: hospMappingCode,
    hmis_patCrNo: patCrNo,
    investigation_data: investigationData,
  }, { branchConfig });
}
