Subject: Meril LIMS ↔ CARE integration — a few confirmations needed before go-live

Hi team,

We've built our side of the CARE gateway/lab-analyzer integration (HL7 ORM in, ORU results out, JWT/JWKS auth) against the UAT doc you shared, and it's passing our internal tests. Before we test against the real staging environment, a few things need confirming on your end:

**1. Gateway device registration — endpoint address**
In the CARE admin UI, our gateway device currently shows:
- Endpoint Address: `meril-gateway.example.com` (placeholder)
- "Start Monitoring" reports Server/Database both Offline, "Failed to fetch"

We're running our service behind a temporary tunnel for testing:
`https://reenact-wasp-hastiness.ngrok-free.dev`
(Note: this is an ephemeral free-tier ngrok URL and will change if we restart it — we'll move to a stable domain before production. We'll let you know if/when it changes during testing.)

Could you:
- Update the gateway device's endpoint_address to the URL above (or confirm if we can edit this ourselves from our side of the admin UI)?
- Do the same for the lab-analyzer device's endpoint_address?
- Confirm the `GATEWAY_EXTERNAL_ID` value we should send as the `X-Gateway-Id` header — we don't see this surfaced anywhere in the UI yet.

**2. Multiple branches on one gateway?**
We have two branches under Ramgarh that would both use this integration eventually. The UAT setup shows one facility with one gateway + one lab-analyzer device registered. Does each branch/facility need its own separate gateway + lab-analyzer device registration, or can one gateway serve multiple facilities some other way (e.g. disambiguated per-order)? We'll only activate one branch to start, but want to plan correctly for the second.

**3. Results in LOINC codes**
The sample ORU message in the doc uses LOINC codes for OBX-3 (e.g. `718-7` Hemoglobin, `6690-2` Leukocytes, `777-3` Platelets). We're building our result push to always send LOINC-coded values, matching that example. Please confirm:
- This is required/correct for all results, not just the sample panel shown.
- Whether you have a preferred or authoritative LOINC code list for the specific tests you expect from us. We've pre-seeded LOINC codes for common CBC / metabolic panel / lipid panel analytes on our end as a starting point, but would rather use your definitive list if one exists, so nothing gets mismatched.

**4. JWT claim shape (both directions)**
The doc specifies "JWT" for both `Care_Bearer` (sent by you to us) and `Gateway_Bearer` (sent by us to you), but doesn't show the actual claims. Could you share:
- A sample decoded `Care_Bearer` token (issuer/subject/audience/expiry conventions), and whether it includes a `kid` in the header.
- What claims you expect in our `Gateway_Bearer` token when we call your endpoints.

**5. `POST /send-order/` response**
The doc shows the request body CARE sends us, but not what response body/status you expect back. We currently return `{"success": true/false, "message": "...", ...}` with 201/400/etc. Let us know if you need a specific response shape (e.g. an HL7 ACK) instead.

**6. `GET /health/status/` expected shape**
Since your monitoring UI shows separate Server/Database indicators, we've updated our response to:
```json
{"status": "ok", "server": "ok", "database": "ok", "service": "...", "timestamp": "..."}
```
Please confirm this matches what your monitor reads, or share the exact shape/field names it expects.

**7. `GET /openid-configuration/` expected shape**
We're currently returning a bare JWKS document: `{"keys": [...]}`. Should this instead be a full OIDC discovery document, or is the bare JWKS correct?

**8. Auth scheme strings**
Please confirm `Care_Bearer` and `Gateway_Bearer` are exact, case-sensitive strings (not the standard `Bearer` scheme) so we parse the Authorization header correctly.

**9. How do we place a test order from the staging UI?**
We have login access to `https://staging.ohc.network/facility/14bab13a-93a5-4727-a91e-64f78df3e2d4/overview` but haven't found where to actually place/book a lab order that would trigger an ORM message to our `/send-order` endpoint. Could you point us to the right screen/flow, so we can test a full round trip (order in → result out) on our side?

Happy to hop on a call if that's faster for any of the above. Thanks!
