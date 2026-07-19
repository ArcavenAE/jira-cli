---
document_type: adversarial-pass-log
story: S-576-1
bundle: SOH-ATTACHMENTS-1
step: "4.5"
criterion: STRICT
converged: true
window: [pass-2, pass-3, pass-4]
date: 2026-07-19
---

# S-576-1 Step 4.5 Adversarial Convergence Log

## Summary

Criterion: STRICT (3 consecutive NITPICK_ONLY passes required).
Result: CONVERGED. Window: pass-2 / pass-3 / pass-4.
Passes: 4. Fix rounds: 2 (after pass-1; after pass-2 for ratification).
Human overrides: 0.
Spec trajectory: v1.3.94 → v1.3.95 → v1.3.96.
Story trajectory: v1.20 → v1.21 → v1.22 (input-hash d6e6eb3).

---

## Pass 1 — FINDINGS (2 MEDIUM, 3 LOW/INFO)

**Classification:** FINDINGS
**Severity ceiling:** MEDIUM

**Findings:**

- **P1-001 (MEDIUM):** `?` glob pattern missing from `#[cfg(test)]` import path in the attachment module stubs. Test-isolation boundary was incorrect — the import would not scope correctly to the test module in all configurations.
- **P1-002 (MEDIUM):** BC-2.7.002 author-curated-form ruling contradicted by story AC wording. The story AC text stated the raw Jira filename as the authoritative display form, conflicting with the spec's key-semantics clause which mandates the author-curated form. Spec authority = BC-2.7.002.
- **P1-003 (LOW):** Completeness-probe — the claim that all attachment endpoints were covered was unverified by an inline research citation. Discharged at PR time via probe-research agent citation.
- **P1-004 (LOW):** Unsanitized displayName/mimeType table cells — Jira API-supplied string values rendered directly in table output without sanitization for control characters or injection sequences. System-wide question; deferred to phase-5 bundle review.
- **P1-005/P1-006 (INFO):** Minor wording nits (no structural issues).

**Fix round 1** (commits 426f02b8 + 5dfa9bd1):
- Corrected test import glob (P1-001 discharged).
- Updated AC wording to match BC-2.7.002 author-curated-form ruling (P1-002 discharged).
- Spec bumped v1.3.94 → v1.3.95 (BC-2.7.002 author-curated-form ruling).
- Story S-576-1 v1.20 → v1.21 (propagation).
- rustfmt clean pass.
- P1-004 deferred to S-576-2 (recorded in residuals).
- P1-003 deferred to PR-time research citation.

---

## Pass 2 — NITPICK_ONLY (1 LOW) — Window 1/3

**Classification:** NITPICK_ONLY
**Severity ceiling:** LOW

**Findings:**

- **P2-001 (LOW):** EC-2.7.001-3 empty-string attachment-list response handling — story AC did not pin the empty-array JSON shape for the case when Jira returns an attachment list with zero items. The spec lacked an explicit normative statement for this edge case.

**Disposition:** Ratified into spec as a clarifying addition (v1.3.95 → v1.3.96, EC-2.7.001-3 empty-string ratification). Not suppressed — adversary correctly identified a spec gap even at LOW severity; STRICT criterion requires action on any delta-attributable finding.

**Fix round 2** (commit 5a8bf29b):
- Spec v1.3.95 → v1.3.96 (EC-2.7.001-3 empty-string ratification).
- Story S-576-1 v1.21 → v1.22 (hash refresh, input-hash d6e6eb3).
- Window streak: 1/3.

---

## Pass 3 — NITPICK_ONLY (1 LOW) — Window 2/3

**Classification:** NITPICK_ONLY
**Severity ceiling:** LOW

**Findings:**

- **P3-001 (LOW):** Query-projection pin — attachment list test fixture lacked an explicit assertion that only the expected JSON projection fields were serialized (no phantom fields emitted). The test verified field VALUES but not field SET completeness.

**Disposition:** Discharged via query-projection pin tests added in commit 6b422f02. No spec change required (implementation-level pin sufficient).

**Fix round:** Commit 6b422f02 (P3-001 query-projection pins).
Window streak: 2/3.

---

## Pass 4 — NITPICK_ONLY (1 LOW residual + 1 observation) — Window 3/3 — CONVERGED

**Classification:** NITPICK_ONLY
**Severity ceiling:** LOW

**Findings:**

- **P4-001 (LOW residual):** AttachmentObject serde brittleness — struct fields lack `#[serde(default)]`. Any future Jira API addition of optional fields to the attachment object response would cause deserialization failures (missing-field error). The download story (S-576-2) operates on the same struct and is the natural hardening point.
- **P4-002 (observation):** 403 ApiError prefix format — adversary noted the wording. Verified compliant per existing house pattern; no action required.

**Disposition:** P4-001 deferred to S-576-2 delivery (same struct; download story hardens it). P4-002 no action. No fix round. Window complete 3/3.

**STRICT CONVERGED.** Window: pass-2 / pass-3 / pass-4. Zero human overrides. Zero HIGH or MEDIUM in window.

---

## Accepted Residuals at Convergence

| ID | Severity | Description | Disposition | Target |
|----|----------|-------------|-------------|--------|
| P1-003 | LOW | Completeness-probe — endpoint coverage claim unverified by research | DISCHARGED at PR time via research citation | PR gate |
| P1-004 | LOW | Unsanitized displayName/mimeType table cells | DEFERRED — system-wide display-sanitization question; phase-5 | phase-5 |
| P4-001 | LOW | AttachmentObject serde missing `#[serde(default)]` | DEFERRED to S-576-2 delivery | S-576-2 |
| P4-002 | obs | 403 ApiError prefix format | COMPLIANT per house pattern; no action | n/a |
