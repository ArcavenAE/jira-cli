---
document_type: security-review
level: ops
version: "1.0"
status: final
producer: security-reviewer
timestamp: 2026-07-15T00:00:00
feature: SOH-ATTACHMENTS-1
issues: "#576, #585"
phase: F2
authored: 2026-07-15
reviewer_role: security
verdict: APPROVE
inputs:
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/cross-cutting.md"
  - ".factory/research/issue-576-attachments-api-2026-07-15.md"
  - ".factory/phase-f1-delta-analysis/impact-boundary-576.md"
  - ".factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md"
input-hash: "fa52806"
traces_to: "DEC-179 item 6"
total_findings: 7
critical: 0
high: 0
medium: 1
low: 5
files_reviewed: 7
severity_summary: "1 MEDIUM (CWE-22 canonicalize — resolved), 5 LOW (CWE-22 Windows devices, CWE-522 redirect test, CWE-93 multipart encoding, CWE-352 XSRF test, stale cache — all resolved), 1 INFO (resolved)"
---

# Security Review: SOH-ATTACHMENTS-1 Attachment Read/Write (#576 + #585)

**Review scope**: Spec-level review of 27 new BCs in Section 2.7 (`bc-2-issue-read.md`),
Section 3.9 (`bc-3-issue-write.md`), and BC-X.8.010 (`cross-cutting.md`).

**Re-verification**: All 7 findings from the initial review (SPEC-CHANGES-REQUIRED) were
applied in spec v1.3.44. This pass independently verifies the BC text and updates finding
status. Verdict upgraded to **APPROVE**.

---

## Executive Summary

All 7 findings from the initial security review were correctly applied to the BC text in
spec v1.3.44. BC-2.7.011 now has the correct two-step containment check procedure (SEC-576-002,
MEDIUM) and a Windows device-name caller contract note (SEC-576-001). BC-2.7.007 carries the
wiremock test requirement for credential-stripping regression (SEC-576-003). BC-3.9.001 carries
the multipart encoding verification (SEC-576-004) and X-Atlassian-Token wiremock test (SEC-576-005),
with a parallel XSRF note also added to BC-3.9.003's step-1 clause. BC-X.8.010 has the
stale-ID self-healing + single-retry clause (SEC-576-006). BC-2.7.011 step 5.5 adds trailing
whitespace/dot stripping (SEC-576-007). All prior defensive measures verified unchanged.
Verdict: **APPROVE**.

---

## Findings

### SEC-576-001 — LOW — CWE-22 — Windows device names pass sanitization

**Severity**: LOW
**CWE**: CWE-22 (Path Traversal)
**OWASP**: A05:2021 Security Misconfiguration
**Affected BC**: BC-2.7.011
**Status**: **resolved**

**Verification**: BC-2.7.011 now contains a "Windows device-name caller note (SEC-576-001 — CWE-22)"
paragraph stating: "Any call site that writes the result to disk MUST ensure the final
on-disk filename contains at least one non-device-name character before the extension dot.
The SHA-1 prefix applied in BC-2.7.010 (`<sha1>_CON`, `<sha1>_NUL`, etc.) satisfies this
requirement." The unit test matrix was extended to include `"CON"`, `"NUL"`, `"COM1"`, and
`"nul.txt"` with the explicit assertion that `sanitize_attachment_filename` returns `Some(name)`
for device names (confirming the caller contract, not a function-level rejection).
Text verified directly in BC-2.7.011 body. PASS.

---

### SEC-576-002 — MEDIUM — CWE-22 — Containment check underspecified for non-existent paths

**Severity**: MEDIUM
**CWE**: CWE-22 (Path Traversal)
**OWASP**: A01:2021 Broken Access Control
**Affected BC**: BC-2.7.011
**Status**: **resolved**

**Verification**: BC-2.7.011 now has a "Defense-in-depth containment check (SEC-576-002 — CWE-22,
corrected procedure)" block. It explicitly states: "Do NOT call `canonicalize()` on the joined
path — `std::fs::canonicalize` returns `Err` for non-existent paths, which would cause every
new download to be treated as a containment failure." The two-step procedure is correctly
specified: (1) `let resolved_dir = out_dir.canonicalize()?` canonicalizes the existing `out_dir`;
(2) `resolved_dir.join(&sha1_filename).starts_with(&resolved_dir)` uses component-based
`Path::starts_with` on the non-existent target. The skip-with-warning path is now correctly
scoped to genuine containment failures only, not to the normal new-file case.
Text verified directly in BC-2.7.011 body. PASS.

---

### SEC-576-003 — LOW — CWE-522 — reqwest redirect-strips-auth invariant not regression-pinned

**Severity**: LOW
**CWE**: CWE-522 (Insufficiently Protected Credentials)
**OWASP**: A02:2021 Cryptographic Failures
**Affected BCs**: BC-2.7.007, ADR-0017
**Status**: **resolved**

**Verification**: BC-2.7.007 now has EC-2.7.007-3: "A wiremock integration test MUST assert
that `GET /rest/api/3/attachment/content/{id}` following a cross-host 302/303 redirect does
NOT include an `Authorization` header on the redirect-target request. Use a two-server
wiremock setup (one for the Jira API endpoint, one for the simulated CDN redirect target).
This guards against a future `JiraClient` refactor adding a custom `RedirectPolicy` that
silently forwards bearer/Basic credentials to CDN hosts." The Trace line for BC-2.7.007
cites "SEC-576-003 (CWE-522 credential-stripping wiremock test requirement added 2026-07-15)".
Text verified directly in BC-2.7.007 body. PASS.

---

### SEC-576-004 — LOW — CWE-93 — Multipart filename encoding not verified

**Severity**: LOW
**CWE**: CWE-93 (Improper Neutralization of CRLF Sequences)
**OWASP**: A03:2021 Injection
**Affected BC**: BC-3.9.001
**Status**: **resolved**

**Verification**: BC-3.9.001 now has a "Multipart filename encoding (SQ-6 resolution — SEC-576-004
CWE-93)" paragraph: "reqwest 0.13's `multipart::Part` applies percent-encoding to the filename
value in the `Content-Disposition` header. The implementer MUST include a unit test with
filenames containing `;`, `"`, and `\r\n` and assert the resulting multipart POST body has a
well-formed `Content-Disposition` header (no CRLF injection, no boundary escape). This
resolves SQ-6 from `.factory/phase-f1-delta-analysis/impact-boundary-576.md`, to be verified
at Story 3 delivery." The Trace line cites "SEC-576-004 (CWE-93 multipart encoding test added
2026-07-15)". Text verified directly in BC-3.9.001 body. PASS.

---

### SEC-576-005 — LOW — CWE-352 — X-Atlassian-Token header not test-asserted

**Severity**: LOW
**CWE**: CWE-352 (Cross-Site Request Forgery)
**OWASP**: A01:2021 Broken Access Control
**Affected BC**: BC-3.9.001
**Status**: **resolved**

**Verification**: BC-3.9.001 now has EC-3.9.001-5: "A wiremock integration test MUST assert
that every `POST /rest/api/3/issue/{key}/attachments` upload request includes the header
`X-Atlassian-Token: no-check`. A regression omitting this header produces HTTP 403 silently
in live testing; the wiremock test catches it at CI time." The Trace line cites "SEC-576-005
(CWE-352 X-Atlassian-Token wiremock test added 2026-07-15)". Additionally, BC-3.9.003's
step-1 clause now includes: "The `POST .../attachTemporaryFile` request MUST include
`X-Atlassian-Token: no-check` (same CSRF requirement as BC-3.9.001; SEC-576-005 parallel —
a wiremock test MUST assert this header is present on step-1 POSTs)." BC-3.9.003 Trace also
cites SEC-576-005. Both call sites covered. PASS.

---

### SEC-576-006 — LOW — Stale serviceDeskId cache not invalidated on HTTP 404

**Severity**: LOW
**CWE**: (Correctness/availability)
**OWASP**: A04:2021 Insecure Design
**Affected BCs**: BC-X.8.010, BC-3.9.003
**Status**: **resolved**

**Verification**: BC-X.8.010 now has a "Stale-ID self-healing (SEC-576-006)" block specifying
that if a cached `serviceDeskId` produces a step-1 HTTP 404 or 403, the implementation MUST
delete the cache entry, re-run the resolution chain once, and retry step-1 with the freshly
resolved ID. The block explicitly states "The retry is a single-attempt guard — it does not
loop" and that a second failure is surfaced as a genuine error, not a cache issue. Trace line
cites "SEC-576-006 (stale-ID self-healing clause added 2026-07-15)". Text verified directly
in BC-X.8.010 body. PASS.

---

### SEC-576-007 — INFO — Trailing dots/spaces on Windows filenames

**Severity**: INFO
**CWE**: CWE-22 (Path Traversal — informational)
**Affected BC**: BC-2.7.011
**Status**: **resolved** (implemented as optional improvement)

**Verification**: BC-2.7.011 now has step 5.5 in the required algorithm: "**Trailing
whitespace/dot strip** (SEC-576-007 — Windows predictability): strip trailing ASCII whitespace
characters and trailing `.` from the basename after the length cap. Windows silently removes
trailing dots and spaces from filename components on write; stripping them makes the sanitized
output identical on Windows and POSIX, preventing unpredictable collision between two Jira
attachments whose names differ only by trailing characters." This was flagged as optional in
the initial review; the spec author chose to implement it. Trace cites "SEC-576-007
(trailing-whitespace/dot strip step 5.5 added 2026-07-15)". PASS.

---

## Summary Table

| ID | Severity | CWE | Affected BC | Status |
|----|----------|-----|-------------|--------|
| SEC-576-001 | LOW | CWE-22 | BC-2.7.011 | resolved — Windows device-name caller contract + test matrix added |
| SEC-576-002 | MEDIUM | CWE-22 | BC-2.7.011 | resolved — two-step canonicalize procedure specified correctly |
| SEC-576-003 | LOW | CWE-522 | BC-2.7.007 | resolved — EC-2.7.007-3 wiremock test requirement added |
| SEC-576-004 | LOW | CWE-93 | BC-3.9.001 | resolved — SQ-6 resolution + test requirement in BC-3.9.001 |
| SEC-576-005 | LOW | CWE-352 | BC-3.9.001, BC-3.9.003 | resolved — EC-3.9.001-5 + parallel step-1 note both present |
| SEC-576-006 | LOW | (correctness) | BC-X.8.010 | resolved — stale-ID self-healing + single-retry clause added |
| SEC-576-007 | INFO | CWE-22 | BC-2.7.011 | resolved — step 5.5 trailing-strip implemented |

---

## Positive Findings (Defensive Measures Present)

All positive findings from the initial review remain intact and verified in the current BC
text. No regressions were introduced by the spec-author's fix pass.

- **CWE-22 core algorithm (BC-2.7.011)**: `Path::file_name()`, NUL rejection, char scrub, length cap, and now step 5.5 trailing-strip all present and correct. PASS.
- **SHA-1 prefix design (BC-2.7.010)**: unchanged; provides collision-resistance and incidental Windows device-name protection. PASS.
- **reqwest redirect credential-stripping (BC-2.7.007)**: documented and now regression-test-required via EC-2.7.007-3. PASS.
- **SSRF posture**: unchanged; download URL is template-constructed from attachment ID, not taken from an attacker-controlled response field. PASS.
- **JSM visibility gate (BC-3.9.003/BC-3.9.014)**: unchanged; no flag combination or race can produce customer-visible files without explicit user intent. PASS.
- **Platform-POST safe default (BC-3.9.002)**: unchanged; internal by default on JSM (P2-4a confirmed). PASS.
- **Per-profile cache isolation (BC-X.8.010)**: unchanged; `(profile, projectKey)` composite key prevents cross-profile leakage. PASS.
- **No zip-bomb surface**: unchanged; raw bytes only, no extraction. PASS.
- **OAuth scope coverage**: unchanged; all attachment operations covered by existing scopes; no re-consent required. PASS.

---

## Recommendations Priority

### Immediate (before merge of Story 2 — attachment download)

All S2-blocking findings resolved. No remaining action.

### Before Release (before Story 3 — attachment upload)

All S3-blocking findings resolved. No remaining action.

### Post-Release (before Story 5 — JSM visibility)

All S5-blocking findings resolved. No remaining action.

---

## Verdict: APPROVE

All 7 findings verified as correctly applied in spec v1.3.44 by independent reading of
the current BC text. No finding is partially applied. No regression in existing defensive
measures detected. The behavioral contracts for SOH-ATTACHMENTS-1 fully specify the security
posture. Story decomposition may proceed.
