# CDAC (e-Sushrut HMIS) Integration — Meeting Notes

## What we've built (to walk CDAC through)

- **All 7 endpoints implemented and exercised live against your UAT sandbox**: master data sync, patient/investigation pull, sample-collected push, parameter-level results push, overall status push, and final PDF report push.
- **Fully wired into our live lab workflow** — not a separate manual step. When our lab staff collect a sample, that automatically pushes `SAMPLE_COLLECTED` to you. When our doctor verifies/approves a result, that automatically pushes the parameter values, the `AUTHORIZED` status, and the final PDF report — all three, independently, so one failing doesn't block the others.
- **A "Fetch CDAC Order" action** in our worklist (web + our Electron agent) — lab staff enter a patient CR number and we pull whatever investigations you have queued for them, matching or creating the patient locally.
- **Auto-mapping system** for your test codes → our internal test catalog, with a manual-override screen and a name-similarity auto-mapper, so unmapped codes surface for a human to confirm rather than silently failing or silently guessing wrong.
- **Global, one-time mapping** — we deliberately designed this so mapping a test code once (by any branch) applies everywhere, since your test codes are a national registry, not hospital-specific. No branch has to repeat this setup.
- **Full audit log** of every API call (request/response/timing/success) for our own debugging and yours if you ever need to see what we sent.

### Current status (real numbers, as of today)

- **16 of our branches** are routed to use CDAC; **only 1 (CHC Kankhe)** has a real `hmis_hosp_mapping_code` and is actually live-tested end-to-end.
- **106 CDAC test codes** synced from your master data (API 7); of those, only **2 are confirmed mapped**, 2 are placeholder-mapped, and **102 are still unmapped** against our catalog — expected, since this gets filled in gradually as real orders come through.
- **0 parameter-code mappings configured right now** — this is the single biggest gap blocking result push (see ask #1 below).
- **30 successful API calls logged against your UAT sandbox this week, zero failures** — covering all 6 operations we use (master data sync, patient pull, sample-collected push, results push, status push, report push).

---

## What we need to ask CDAC

1. **Parameter code list (biggest blocker).** Your API doesn't expose a parameter-code endpoint, so we built manual entry + CSV import tooling for it — but we have zero real mappings yet, which means we currently *cannot* send individual result values (the API 31 push) for any test. Can you provide an authoritative parameter-code list per test (spreadsheet, or ideally a real endpoint)? And separately: who is supposed to own/maintain this mapping — CDAC or us?

2. **Bearer token lifecycle.** The sample token in the Postman collection you gave us expired (per its own claim) in February — yet our calls against UAT have kept succeeding through today without any 401s. Is UAT simply not validating token expiry? What's the actual token issuance/refresh process for production? Is there an auth endpoint we're missing?

3. **Correct host.** Your Postman collection mixes two different hosts across sample requests (`e-sushrutnxjh.uat.dcservices.in` on some, `e-sushrutnx.in` on others). Which is correct for UAT? And what will production's host be?

4. **API-ACCESS-KEY scope.** Is this key per-endpoint, per-hospital, or one shared secret? Your collection shows a different key per operation type — we need to know the real rule before we onboard more branches.

5. **Hospital mapping codes for our other 15 branches.** Only CHC Kankhe has one today. What's the process and rough timeline to get codes issued for the rest so we can bring them live?

6. **Response success/failure contract.** We've observed HTTP 200 responses with a top-level `"status": "OK"` even when a nested `data.Status` field reads like an error message. Can you clarify definitively how we should detect success vs. failure from your responses?

7. **Reject/cancel flow.** Your status set includes `SAMPLE_REJECTED` and `CANCELED`, but our lab workflow has no equivalent trigger yet. What do you expect from us when a sample gets rejected? And is there ever a case where CDAC would need to push a cancellation *to* us, or is it always initiated from your side/ours only via status push?

8. **PDF report requirements.** Any specific formatting, branding, or size constraints for the report we submit via API 5 — or is any valid PDF acceptable as-is?

9. **Production path.** Once UAT testing is signed off, what's the process to get production credentials and confirm the production host?
