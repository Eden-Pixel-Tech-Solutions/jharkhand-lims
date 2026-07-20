# Meril–CDAC LIS Integration API Documentation

**Collection name:** RIMS_CDAC_LIS_INTEGRATION
**Postman schema:** v2.1.0
**Source file:** `Meril_CDAC_LIS_INTEGRATIO.postman_collection`

## 1. Overview

This API set integrates **Meril's POCT (Point-of-Care Testing) / LIS system** with **CDAC's e-Sushrut HMIS** (the hospital management system used across public hospitals on the `dcservices.in` platform). It lets the lab system (POCT) pull patient/order data from the hospital system and push back sample, status, result, and report data as a lab order moves through its lifecycle.

All 7 endpoints live under the same base path and are POST-only. Each call carries a `hmis_request_type` code identifying what operation is being performed — the URL path also names the operation, so the two are redundant but both must be sent correctly.

```
POST /hmis/api/inv/IntegrationHmisPoct/{operationName}
```

### 1.1 Hosts observed in the collection

| Environment (inferred) | Host |
|---|---|
| UAT | `https://e-sushrutnxjh.uat.dcservices.in` |
| Used on remaining 5 requests (likely prod or a second env) | `https://e-sushrutnx.in` |

> **Note:** Only the first two requests (`patDemographicInvestigationDtls`, `patSampleCollectionAndRequisitionDtls`) point at the `.uat.dcservices.in` UAT host with a Bearer token configured. The other five point at `e-sushrutnx.in` with no Bearer auth configured in the collection. This is likely just an artifact of how the collection was built/tested rather than an intentional difference — confirm the correct host and auth requirement per environment before using this collection as-is.

### 1.2 Workflow sequence

The seven calls map to a typical lab-order lifecycle:

1. **getHmisHospMapDataRowData** — look up hospital mapping/reference data.
2. **patDemographicInvestigationDtls** — pull patient demographics + the investigations (tests) ordered for that patient from HMIS.
3. **patSampleCollectionAndRequisitionDtls** — notify HMIS that a sample has been collected against a requisition.
4. **patInvestigationStatusUpdateDtlsRowData** — push individual test-parameter result values (the actual lab result data, parameter by parameter) once results are available.
5. **patInvestigationStatusUpdateDtls** — update the overall status of a requisition/test (e.g. mark it `AUTHORIZED`).
6. **patInvestigationViewDtls** — re-fetch/view investigation details for given requisitions (e.g. for verification or reprint).
7. **patInvestigationReportDtls** — submit the finalized report, including the report PDF (base64-encoded), typically once printed.

## 2. Authentication & Headers

Every request in the collection sends the same two custom headers:

| Header | Example value | Purpose |
|---|---|---|
| `HMIS-EXT-USER` | `inv-gims` | Identifies the external system/user calling the API |
| `API-ACCESS-KEY` | `HMIS <base64-like secret>` | Per-integration access key, prefixed with the literal string `HMIS ` followed by a secret token. **A different key is used per endpoint in this collection** — see each endpoint section below. |

In addition, the first two requests carry **Bearer token** auth:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6W3siYXV0aG9yaXR5IjoiMTAwMDIifV0sInN1YiI6IkRoYXJ2aWsiLCJpYXQiOjE3NzE0OTEwMzgsImV4cCI6MTc3MTQ5MjgzOH0.cEL7zIqSongwZbSRYXmM7zdO3UMDsGPX3WtTsyZGCoY
```

Decoding this JWT payload gives:
```json
{
  "roles": [{ "authority": "10002" }],
  "sub": "Dharvik",
  "iat": 1771491038,
  "exp": 1771492838
}
```
(short-lived token — ~30 min validity based on `iat`/`exp`). The remaining five requests have no `auth` block configured in the collection; they may rely solely on the `API-ACCESS-KEY` header, or a Bearer token may simply not have been added to those requests yet. Confirm with the CDAC integration team which endpoints actually require the Bearer token.

**Content-Type:** all requests send a raw JSON body (`body.mode = raw`, `language = json`); no explicit `Content-Type` header is set in the collection, so make sure to send `Content-Type: application/json` when implementing this yourself.

## 3. Common Request Fields

These fields recur across most endpoints:

| Field | Type | Description |
|---|---|---|
| `hmis_hosp_mapping_code` | string | Hospital identifier code as mapped in HMIS (e.g. `"10000"`, `"2317"`) |
| `hmis_request_type` | string | Operation code — see table in §3.1 |
| `hmis_patCrNo` | string | Patient CR (registration) number in HMIS |
| `hmis_episode_code` | string | Episode/encounter code for the patient visit |
| `hmis_episode_visitno` | string | Visit number within the episode |
| `investigation_data` | array | Array of per-test/per-parameter objects; shape varies by endpoint (see below) |
| `hmis_req_no` | string | Requisition number (order-level identifier) |
| `hmis_req_dno` | string | Requisition detail number (line-item/test-level identifier under a requisition) |
| `poct_lab_code` / `hmis_lab_code` | string | Lab code (as assigned by CDAC/HMIS) |
| `poct_test_code` / `hmis_test_code` | string | Test code |
| `poct_sample_code` / `hmis_sample_code` | string | Sample type code |
| `poct_status` | string | Status of the sample/test — observed values: `SAMPLE_COLLECTED`, `AUTHORIZED`, `PRINTED` |

### 3.1 `hmis_request_type` code map

| Code | Endpoint |
|---|---|
| `1` | patDemographicInvestigationDtls |
| `2` | patSampleCollectionAndRequisitionDtls |
| `3` | patInvestigationStatusUpdateDtls |
| `4` | patInvestigationViewDtls |
| `5` | patInvestigationReportDtls |
| `7` | getHmisHospMapDataRowData |
| `31` | patInvestigationStatusUpdateDtlsRowData |

> None of the requests in the source collection include saved example responses, so response schemas below are based only on the endpoint name/purpose and are marked accordingly — confirm actual response shape against a live/UAT call.

---

## 4. Endpoint Reference

### 4.1 `patDemographicInvestigationDtls`

**Purpose:** Retrieve a patient's demographic details and the investigations (tests) ordered for them, given their patient CR number. This is typically the first call POCT makes when a sample/order needs to be pulled into the lab system.

- **Method:** `POST`
- **URL:** `https://e-sushrutnxjh.uat.dcservices.in/hmis/api/inv/IntegrationHmisPoct/patDemographicInvestigationDtls`
- **Request type code:** `1`

**Headers**

| Key | Value |
|---|---|
| `HMIS-EXT-USER` | `inv-gims` |
| `API-ACCESS-KEY` | `HMIS TO79oqcF06RPRvnh+GrZ8WDGYIlUhvVQF1PjuWsfGOSFCrIpc/ZIHGAfUvnow32MsIgsIi3FAkO15hbFtO+wZQ==` |

**Auth:** Bearer token (see §2)

**Request body**

```json
{
    "hmis_hosp_mapping_code" : "10000",
    "hmis_request_type": "1",
    "hmis_patCrNo": "100002600003755"
}
```

**Field notes**

| Field | Required | Notes |
|---|---|---|
| `hmis_hosp_mapping_code` | Yes | Hospital code |
| `hmis_request_type` | Yes | Must be `"1"` |
| `hmis_patCrNo` | Yes | Patient CR number to look up |

**Response:** Not documented in the source collection. Expected to return patient demographics plus a list of ordered investigations (likely including `hmis_req_no`, `hmis_req_dno`, test/sample codes) based on the endpoint's purpose.

---

### 4.2 `patSampleCollectionAndRequisitionDtls`

**Purpose:** Push sample collection and requisition details back to HMIS — i.e. tell HMIS that a sample for a given test has been collected.

- **Method:** `POST`
- **URL:** `https://e-sushrutnxjh.uat.dcservices.in/hmis/api/inv/IntegrationHmisPoct/patSampleCollectionAndRequisitionDtls`
- **Request type code:** `2`

**Headers**

| Key | Value |
|---|---|
| `HMIS-EXT-USER` | `inv-gims` |
| `API-ACCESS-KEY` | `HMIS oU1OmoB2NYf1yKH2ty5Oib+BkiwW/bsQ6Nd1bV9HMMt/QfV1azz+oHXuh/exJ1lQsELYtTM3b2Wt7DLzHcqwbg==` |

**Auth:** Bearer token (see §2)

**Request body**

```json
{
    "hmis_hosp_mapping_code" : "10000",
    "hmis_request_type": "2",
    "hmis_patCrNo": "100002600001361",
    "hmis_episode_code": "19811001",
    "hmis_episode_visitno": "1",
    "investigation_data": [
        {
            "hmis_req_no": "1000010103260223100003",
            "hmis_req_dno": "100001010326022310000301",
            "poct_lab_code": "10103",
            "poct_test_code": "10011",
            "poct_sample_code": "1001",
            "poct_status": "SAMPLE_COLLECTED",
            "req_type": "1"
        }
    ]
}
```

**`investigation_data[]` item fields**

| Field | Notes |
|---|---|
| `hmis_req_no` | Requisition (order) number |
| `hmis_req_dno` | Requisition detail (line-item) number |
| `poct_lab_code` | Lab code |
| `poct_test_code` | Test code |
| `poct_sample_code` | Sample type code |
| `poct_status` | Sample status — `SAMPLE_COLLECTED` in this example |
| `req_type` | Requisition type flag (`"1"` in example — meaning not documented in collection) |

**Response:** Not documented in the source collection.

---

### 4.3 `patInvestigationStatusUpdateDtls`

**Purpose:** Update the overall status of one or more requisition line items (e.g. mark results as `AUTHORIZED`).

- **Method:** `POST`
- **URL:** `https://e-sushrutnx.in/hmis/api/inv/IntegrationHmisPoct/patInvestigationStatusUpdateDtls`
- **Request type code:** `3`

**Headers**

| Key | Value |
|---|---|
| `HMIS-EXT-USER` | `inv-gims` |
| `API-ACCESS-KEY` | `HMIS jZRghrjFcrxc9GgPtoMSD9lXjRWBYOktqFjmQ7L3yi6MilbwW+k4U4wlnVO8r0RlfdwQLRnTmPtGJP5sbucerQ==` |

**Auth:** None configured in collection

**Request body**

```json
{
    "hmis_hosp_mapping_code" : "2317",
    "hmis_request_type": "3",
    "hmis_patCrNo": "991012200000014",
    "investigation_data": [
        {
            "hmis_req_no": "9910110091220325100004",
            "hmis_req_dno": "991011009122032510000402",
            "poct_status": "AUTHORIZED"
        },
        {
            "hmis_req_no": "9910110091220408100001",
            "hmis_req_dno": "991011009122040810000104",
            "poct_status": "AUTHORIZED"
        }
    ]
}
```

**`investigation_data[]` item fields**

| Field | Notes |
|---|---|
| `hmis_req_no` | Requisition number to update |
| `hmis_req_dno` | Requisition detail number to update |
| `poct_status` | New status — `AUTHORIZED` in this example |

Supports **multiple requisitions in one call** (array of update objects).

**Response:** Not documented in the source collection.

---

### 4.4 `patInvestigationViewDtls`

**Purpose:** Fetch/view investigation details for one or more specific requisition line items — e.g. to re-verify data before finalizing, or to display current state.

- **Method:** `POST`
- **URL:** `https://e-sushrutnx.in/hmis/api/inv/IntegrationHmisPoct/patInvestigationViewDtls`
- **Request type code:** `4`

**Headers**

| Key | Value |
|---|---|
| `HMIS-EXT-USER` | `inv-gims` |
| `API-ACCESS-KEY` | `HMIS NKNgXcv4xPTMrCQUhfoA6vkwxCj3Qvo131XIDGOigi+SN8UImX32EGvr0lWX32KV3R5HcaT5ZbQZ7pFPJS1wuQ==` |

**Auth:** None configured in collection

**Request body**

```json
{
    "hmis_hosp_mapping_code" : "2317",
    "hmis_request_type": "4",
    "hmis_patCrNo": "991012200000014",
    "investigation_data": [
        {
            "hmis_req_no": "9910110091220325100004",
            "hmis_req_dno": "991011009122032510000402"
        },
        {
            "hmis_req_no": "9910110091220408100001",
            "hmis_req_dno": "991011009122040810000104"
        }
    ]
}
```

**`investigation_data[]` item fields**

| Field | Notes |
|---|---|
| `hmis_req_no` | Requisition number to view |
| `hmis_req_dno` | Requisition detail number to view |

**Response:** Not documented in the source collection. Expected to return full investigation/result details for the requested requisitions.

---

### 4.5 `patInvestigationReportDtls`

**Purpose:** Submit the finalized investigation report — including the rendered report as a base64-encoded PDF — back to HMIS, typically once the report has been printed/finalized.

- **Method:** `POST`
- **URL:** `https://e-sushrutnx.in/hmis/api/inv/IntegrationHmisPoct/patInvestigationReportDtls`
- **Request type code:** `5`

**Headers**

| Key | Value |
|---|---|
| `HMIS-EXT-USER` | `inv-gims` |
| `API-ACCESS-KEY` | `HMIS WM2DZO1W6qtGm2UyB/K0JbauLOVenfQF5quurvLnZA/JYyvIiRsktKnigSJdhuYjdWzUFpGE+3kRQlnLqc40cQ==` |

**Auth:** None configured in collection

**Request body** (base64 payload truncated for readability — full field is a valid single-page PDF in the source file, ~260 KB base64-encoded)

```json
{
    "hmis_hosp_mapping_code" : "2317",
    "hmis_request_type": "5",
    "hmis_patCrNo": "991012200000014",
    "investigation_data": [
        {
            "hmis_req_no": "9910110091220325100004",
            "hmis_req_dno": "991011009122032510000402",
            "poct_status": "PRINTED",
            "poct_pdf_rpt_base64": "JVBERi0xLjQKJeLjz9MK...<base64-encoded PDF>...JSVFT0YK"
        }
    ]
}
```

**`investigation_data[]` item fields**

| Field | Notes |
|---|---|
| `hmis_req_no` | Requisition number the report belongs to |
| `hmis_req_dno` | Requisition detail number the report belongs to |
| `poct_status` | Status — `PRINTED` in this example |
| `poct_pdf_rpt_base64` | The report file, base64-encoded (decodes to a standard PDF, confirmed via the `%PDF`/`%%EOF` header/footer bytes) |

> This is by far the largest payload in the collection (~263 KB) — plan for larger request size limits/timeouts on this endpoint specifically.

**Response:** Not documented in the source collection.

---

### 4.6 `patInvestigationStatusUpdateDtlsRowData`

**Purpose:** Push individual, parameter-level result data for a test — i.e. the actual lab result values, one row per analyte/parameter, rather than just an overall status. This is the most granular of the write-back endpoints.

- **Method:** `POST`
- **URL:** `https://e-sushrutnx.in/hmis/api/inv/IntegrationHmisPoct/patInvestigationStatusUpdateDtlsRowData`
- **Request type code:** `31`

**Headers**

| Key | Value |
|---|---|
| `HMIS-EXT-USER` | `inv-gims` |
| `API-ACCESS-KEY` | `HMIS m1O9yvh/aB84aHRf/YdL0cW91sQhpRyPW1wH9xjOgRM9Rbw0PX5NWTOzRJdkJcWqYWzrWI4lNBsWWPZ7S7+wwA==` |

**Auth:** None configured in collection

**Request body** (inline comments are from the original collection author and clarify who supplies each value)

```json
{
    "hmis_hosp_mapping_code" : "2317",
    "hmis_request_type": "31",
    "hmis_patCrNo": "991012200559615",
    "investigation_data": [
        {
            "hmis_req_no": "9910110101250408100002",
            "hmis_req_dno": "991011010125040810000201",
            "poct_status": "AUTHORIZED",
            "hmis_lab_code": "10101",
            "hmis_test_code": "14333",
            "hmis_sample_code": "1001",
            "hmis_parent_parameter_code": "143335126",
            "hmis_str_value": "34",
            "hmis_parameter_code": "5126",
            "hmis_referencerange": "",
            "hmis_str_uom": "101",
            "hmis_str_ref_range": "",
            "hmis_isinrefrange": "0"
        }
    ]
}
```

**`investigation_data[]` item fields**

| Field | Source (per collection comments) | Notes |
|---|---|---|
| `hmis_req_no` | — | Requisition number |
| `hmis_req_dno` | — | Requisition detail number |
| `poct_status` | — | Status, e.g. `AUTHORIZED` |
| `hmis_lab_code` | — | Lab code |
| `hmis_test_code` | — | Test code |
| `hmis_sample_code` | — | Sample type code |
| `hmis_parent_parameter_code` | **CDAC-supplied** | Parent parameter code (e.g. for grouped/panel parameters) |
| `hmis_str_value` | **POCT-supplied** | The actual result value for the parameter |
| `hmis_parameter_code` | **CDAC-supplied** | Parameter (analyte) code |
| `hmis_referencerange` | **POCT-supplied** | Reference range data |
| `hmis_str_uom` | **CDAC-supplied** | Unit of measure code |
| `hmis_str_ref_range` | **POCT-supplied** | Reference range (string form) |
| `hmis_isinrefrange` | **POCT-supplied** | Flag: whether the result falls within reference range (`"0"`/`"1"`) |

> The distinction called out in the source collection: **code values** (`hmis_parent_parameter_code`, `hmis_parameter_code`, `hmis_str_uom`) are supplied by CDAC/HMIS as master-data lookups, while **result values** (`hmis_str_value`, `hmis_referencerange`, `hmis_str_ref_range`, `hmis_isinrefrange`) are supplied by the POCT/lab system at result time.

**Response:** Not documented in the source collection.

---

### 4.7 `getHmisHospMapDataRowData`

**Purpose:** Retrieve hospital mapping reference/lookup data (e.g. hospital code mappings used by the other endpoints).

- **Method:** `POST`
- **URL:** `https://e-sushrutnx.in/hmis/api/inv/IntegrationHmisPoct/getHmisHospMapDataRowData`
- **Request type code:** `7`

**Headers**

| Key | Value |
|---|---|
| `HMIS-EXT-USER` | `inv-gims` |
| `API-ACCESS-KEY` | `HMIS 1KVEe6/tCCZlNdvXvvMcCeDM9tTUzyoBxH5YItC5hZauAkMdj+pRdh9LJ1JXPqjcUUozqAvkI1K9sE4y8b3gWA==` |

**Auth:** None configured in collection

**Request body**

```json
{
    "hmis_hosp_mapping_code" : "2317",
    "hmis_request_type": "7"
}
```

**Field notes**

| Field | Required | Notes |
|---|---|---|
| `hmis_hosp_mapping_code` | Yes | Hospital code to look up mapping data for |
| `hmis_request_type` | Yes | Must be `"7"` |

**Response:** Not documented in the source collection. Expected to return the hospital's mapping/reference dataset (likely lab, test, sample, parameter, and UOM code mappings referenced by the other endpoints).

---

## 5. Observations & Open Questions

- **Inconsistent auth across endpoints:** only 2 of 7 requests have a Bearer token configured; confirm whether the other 5 genuinely don't require one or whether this is incomplete in the source collection.
- **Inconsistent hosts:** the first 2 requests use the UAT host (`e-sushrutnxjh.uat.dcservices.in`); the other 5 use `e-sushrutnx.in`. Confirm the correct host per environment (UAT vs. production) before relying on this collection.
- **No example responses saved:** none of the 7 requests have a saved response in the collection, so response schemas, status codes, and error formats are unknown and should be captured from a live/UAT test run.
- **`API-ACCESS-KEY` differs per endpoint:** each request uses its own distinct key value rather than one shared key — confirm whether these are meant to be endpoint-specific secrets or just per-request test artifacts in this collection.
- **Undocumented fields:** `req_type` (in `patSampleCollectionAndRequisitionDtls`) has no explanation of its accepted values in the source collection.
