---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-15T00:00:00
phase: f2
inputs: [.factory/specs/prd/bc-3-issue-write.md, .factory/specs/prd/bc-8-components.md, .factory/phase-f2-spec-evolution/prd-delta-components.md, .factory/specs/prd/BC-INDEX.md, .factory/phase-f2-spec-evolution/verification-delta-components.md, .factory/specs/architecture/decisions/ADR-0018-component-resolution-caching-mutation-strategy.md]
input-hash: "4f00494"
traces_to: .factory/phase-f2-spec-evolution/prd-delta-components.md
pass: 11
previous_review: .factory/phase-f2-spec-evolution/adversarial-spec-delta-review-components-p10.md
---

# Adversarial Review: Component Management Bundle (Pass 11)

Adversarial Spec-Delta Review — Component Management (F2, pass 11). VERDICT: NOT CLEAN. 0 CRIT,
0 HIGH, 1 MEDIUM, 2 LOW, 2 INFO. ALL findings are pass-10-fix propagation lag in derivative docs
(design surfaces verified CLEAN).

## Finding ID Convention

Finding IDs use the format: `ADV-P11-<SEV>-<SEQ>` (no cycle prefix — no `.factory/current-cycle`
file present for this bundle at review time).

## Part A — Fix Verification (pass >= 2)

| ID | Previous Severity | Status | Notes |
|----|-------------------|--------|-------|
| ADV-P10-MED-001 (live-smoke gate mandates a REPLACE `jr` never emits — VP-012 §1.2/§5 + BC-3.4.023 Delivery note) | MEDIUM | PARTIALLY_RESOLVED | VP-COMPONENT-012 §1.2/§5 and BC-3.4.023's own Delivery note were corrected to "one ADD, one REMOVE" (VP-012 §1.2 now reads "F4/F6 MUST gate shipping behind a live smoke test (1×ADD, 1×REMOVE across ≥2 issues in one project…)"; BC-3.4.023 Delivery note matches). prd-delta-components.md's DEC-280 Linkage section (L230-231) was NOT re-synced and still reads the stale "(one ADD, one REMOVE, one REPLACE against ≥2 issues in one project)" — see ADV-P11-MED-001 below, same defect, different surface. |
| ADV-P10-LOW-001 (BC-8.1.001 "(endpoint confirmed non-paginated)" unsupported citation) | LOW | RESOLVED | BC-8.1.001 Source/Behavior softened to "assumed non-paginated … pending F4 live verification" with the superseded wording retained for audit trail (bc-8-components.md L49-57, L65-68). prd-delta-components.md's own summary table row (L50) was NOT re-synced and still reads "(non-paginated)" as fact — see ADV-P11-LOW-001 below, same defect, different surface. |
| ADV-P10-INFO-001 (BC-8.2.007 Postcondition 5 JRACLOUD-95368 drift-abort sub-path had no named exit code/message) | INFO | RESOLVED | BC-8.2.007 Postcondition 5 now names the synthesized outcome: exit 1, `JrError::UserError`-shaped message "could not reliably enumerate affected issues — aborting delete" (bc-8-components.md L1323-1331). prd-delta-components.md's Error Taxonomy table gained a matching new row (L173). However, VP-COMPONENT-017's drift-abort wiremock fixture (both in verification-delta-components.md and in BC-8.2.007's own VP-017 subsection) still pins only `.expect(0)` on DELETE and does not assert the new exit code/message — see ADV-P11-LOW-002 below. |
| ADV-P10-INFO-002 (BC-8.1.004 H1 reads as unconditional exit-64 for edit/delete, though numeric-ID exemption makes it conditional) | INFO | RESOLVED | BC-8.1.004 H1 now reads "...for `list`/`edit`/`delete` ONLY" with the numeric-ID exemption caveat folded into the summary row in prd-delta-components.md (L53) and cross-checked against the body's EC-8.1.004-6..8 exemption language — no residual title/body mismatch found on re-verification. |

## Part B — New Findings

### MEDIUM

#### ADV-P11-MED-001: prd-delta-components.md's DEC-280 Linkage still mandates the retired REPLACE live-smoke criterion, one line after pass-10 fixed it everywhere else

- **Severity:** MEDIUM
- **Category:** spec-fidelity / derivative-doc propagation lag
- **Location:** `.factory/phase-f2-spec-evolution/prd-delta-components.md` DEC-280 Linkage
  section (~L230-231)
- **Description:** Pass 10's MEDIUM-1 established that `jr` never emits a `REPLACE`
  `bulkEditMultiSelectFieldOption` — only `ADD`/`REMOVE` — and corrected the live-smoke gate
  wording in `VP-COMPONENT-012` §1.2/§5 and in BC-3.4.023's own Delivery note to "one ADD, one
  REMOVE across ≥2 issues in one project." That fix-burst missed this document's own DEC-280
  Linkage section, one paragraph below the Count Propagation section, which still reads "one ADD,
  one REMOVE, one REPLACE against ≥2 issues in one project" — the exact unsatisfiable criterion
  pass-10 retired. This is the third derivative surface carrying this wording (VP-012 §1.2, VP-012
  §5, BC-3.4.023 Delivery note were the first three, all now fixed) and the one this bundle's own
  fix-burst evidently didn't grep for. The separate enum-completeness mention at L226
  ("ADD/REMOVE/REPLACE/REMOVE_ALL", describing what the endpoint ACCEPTS as a wire-schema fact,
  not what `jr` generates) is correctly scoped and untouched by this finding.
- **Evidence:** prd-delta-components.md L229-231: "Implemented in BC-3.4.023, with an explicit
  delivery note gating F4 shipping behind a live smoke test (one ADD, one REMOVE, one REPLACE
  against ≥2 issues in one project) before release, per the `FIX-BULK-TRANSITION-001`/#446
  precedent". BC-3.4.023's own Delivery note (bc-3-issue-write.md, current) and VP-COMPONENT-012
  §1.2/§5 (verification-delta-components.md, current) both now read "one ADD, one REMOVE across
  ≥2 issues in one project" — this document is the sole remaining holdout.
- **Impact:** A reader tracing DEC-280 from this summary document (rather than the BC/VP bodies
  directly) would re-derive the same unsatisfiable "1×REPLACE" acceptance criterion pass-10 just
  eliminated, reintroducing the risk of F4/F6 wasting effort exercising a code path `jr` cannot
  construct, or misreading it as license for out-of-scope `set:`/`replace:` CLI grammar (#607
  territory).
- **Proposed Fix:** Re-sync the parenthetical at L230-231 to "(one ADD, one REMOVE against ≥2
  issues in one project)", matching BC-3.4.023 / VP-COMPONENT-012 §1.2/§5 / ADR-0018. Leave the
  enum-completeness mention at L226 untouched.

### LOW

#### ADV-P11-LOW-001: prd-delta-components.md's BC-8.1.001 summary row still states "(non-paginated)" as settled fact, one release after the BC itself was softened to "assumed, pending F4"

- **Severity:** LOW
- **Category:** citation-fidelity / derivative-doc propagation lag
- **Location:** `.factory/phase-f2-spec-evolution/prd-delta-components.md` §"New BCs —
  bc-8-components.md" summary table, BC-8.1.001 row (~L50)
- **Description:** Pass 10's LOW-1 established that BC-8.1.001's "(endpoint confirmed
  non-paginated)" citation was unsupported by its cited research file and corrected the BC body's
  Source/Behavior text to "assumed non-paginated … pending F4 live verification." This document's
  own one-line summary of BC-8.1.001, in the §8.1 table, was not re-synced and still reads
  "`jr component list [--project KEY]` GETs `/rest/api/3/project/{key}/components`
  (non-paginated); table columns ID/Name/Description/Lead/Assignee Type" — asserting the same
  now-softened claim as settled fact, with no "assumed"/"pending F4" qualifier.
- **Evidence:** prd-delta-components.md L50: "...`/rest/api/3/project/{key}/components`
  (non-paginated); table columns...". bc-8-components.md (current) L65-66: "GETs
  `/rest/api/3/project/{key}/components` (assumed non-paginated, pending F4 live verification —
  standard `/project/{key}/components` behavior is that the endpoint returns the full component
  set...)".
- **Impact:** Low — same class as pass-10's original finding, one hop further from the BC body,
  so a reader relying on this summary table (rather than opening the BC file) inherits the
  overstated "confirmed" posture pass-10 explicitly retracted.
- **Proposed Fix:** Qualify the summary row to "(assumed non-paginated, pending F4)" to match the
  softened BC-8.1.001 body wording.

#### ADV-P11-LOW-002: VP-COMPONENT-017's drift-abort fixture pins only `.expect(0)` on DELETE; the exit-1/message contract pass-10 added to BC-8.2.007 Postcondition 5 is unasserted in both the verification-delta and the BC's own VP-017 subsection

- **Severity:** LOW
- **Category:** verification-gap / derivative-doc propagation lag
- **Location:** `.factory/phase-f2-spec-evolution/verification-delta-components.md`
  VP-COMPONENT-017 (~L347-381); `.factory/specs/prd/bc-8-components.md` BC-8.2.007's own
  `**Verification Properties**` VP-COMPONENT-017 subsection (~L1332-1351)
- **Description:** Pass 10's INFO-1 added a new synthesized-error contract to BC-8.2.007
  Postcondition 5: on detecting the JRACLOUD-95368 anti-loop drift abort (`has_more=true`,
  partial key set, a *successful* Rust return, not an `Err`), `component delete` must exit 1 with
  a `JrError::UserError`-shaped message on the model of "could not reliably enumerate affected
  issues — aborting delete" — and prd-delta-components.md's Error Taxonomy table gained a matching
  row (L173). Neither VP-COMPONENT-017 text was updated to match: both the verification-delta
  document's VP-017 property/method text and the BC's own inline VP-017 subsection still describe
  the anti-loop-drift wiremock fixture as asserting only `.expect(0)` on `DELETE` — the DELETE
  never fires, but nothing pins that the command additionally exits 1 or emits the synthesized
  message. A mutant that correctly aborts the DELETE (satisfying `.expect(0)`) but exits 0, or
  exits 1 with an unrelated/generic message, would pass VP-017's assertions as currently worded
  while violating the safety-signal contract Postcondition 5 now specifies — the user would see no
  clear signal that the delete was aborted for a data-integrity reason rather than succeeding
  trivially (e.g. zero affected issues).
- **Evidence:** verification-delta-components.md L376-381 (drift-abort fixture description):
  "...simulates the JRACLOUD-95368 abort condition ... and asserts `.expect(0)` on `DELETE` — a
  mutant that treats the anti-loop guard's `has_more=true` partial return as 'pagination completed
  successfully' must fail this assertion." — no exit-code or message assertion named.
  bc-8-components.md L1346-1351 (BC's own VP-017 subsection): identical `.expect(0)`-only wording.
  Contrast bc-8-components.md L1323-1331 (Postcondition 5, pass-10 text): "`jr` exits 1 with
  `JrError::UserError`-shaped text on the model of 'could not reliably enumerate affected issues —
  aborting delete'". prd-delta-components.md L173 (Error Taxonomy, pass-10 row): "exit 1,
  synthesized `JrError::UserError`-shaped message ('could not reliably enumerate affected issues —
  aborting delete')".
- **Impact:** Low — the DELETE-never-fires safety property is still correctly pinned (the
  irreversible action cannot happen), so this is a completeness gap in the OBSERVABLE-behavior
  assertion, not a hole in the delete-safety guarantee itself. But it leaves the exit-code/message
  half of pass-10's own fix unverified by the property meant to cover this exact scenario,
  inviting a silent regression (e.g. a future refactor that accidentally routes the drift-abort
  through exit 0 with a vague warning) to go undetected by F4/F6's wiremock suite.
- **Proposed Fix:** Extend the anti-loop-drift fixture description in BOTH locations (verification-
  delta-components.md's VP-COMPONENT-017 entry and BC-8.2.007's own inline VP-017 subsection) to
  additionally assert: (a) the process exits 1, and (b) stderr/the error message contains the
  substring "could not reliably enumerate affected issues — aborting delete" — parity with how
  VP-017's sibling assertions already pin exact JQL-body substrings (`ORDER BY key ASC`, resolved
  id vs. name) rather than structural-only checks.

### INFO

#### ADV-P11-INFO-001: verification-delta-components.md's changelog header narrates only through pass-7 (§12), though the document carries inline pass-10 edits (VP-012, §5) and now a pass-11 review exists

- **Severity:** INFO
- **Category:** doc-hygiene
- **Location:** `.factory/phase-f2-spec-evolution/verification-delta-components.md` header
  changelog (~L3-15)
- **Description:** The header's running changelog narrates the document's revision history
  through "pass-7 fix-burst, minting VP-COMPONENT-027/028 ... see §12" and stops there. But the
  document body carries pass-10 fix-burst edits inline (VP-COMPONENT-012 §1.2/§5's ADD/REMOVE
  correction, and the BC-8.2.007-adjacent §5 callout), with no corresponding header sentence
  documenting when or why those edits landed. A reader opening the header alone (the document's
  own convention for "what changed and when") would not learn that pass-10 touched this file at
  all, nor that a pass-11 review has now run.
- **Evidence:** verification-delta-components.md L3-15 header text ends at "...citing the
  pre-existing base VP-396-005 for BC-3.4.017 — run extends to a complete, gapless,
  collision-free `001..028` — see §12)" with no further sentence. §5 (~L698-705) and
  VP-COMPONENT-012 (~L277, within §1.2) both carry pass-10-dated corrections in their body text
  with no matching header entry.
- **Proposed Fix:** Append a header changelog sentence covering: "further updated same-day,
  pass-10 fix-burst, correcting VP-COMPONENT-012 §1.2/§5's live-smoke gate wording from
  1×ADD/1×REMOVE/1×REPLACE to 1×ADD/1×REMOVE (jr never emits REPLACE) — run stays 001..028"; and a
  second sentence for this pass: "further updated same-day, pass-11 fix-burst, extending
  VP-COMPONENT-017's drift-abort fixture to assert exit code and message — no new VPs minted, run
  stays 001..028."

#### ADV-P11-INFO-002: pattern watch — fourth consecutive instance of "fix-burst corrects BC/VP body, sibling derivative-doc summary/header not re-synced in the same burst"

- **Severity:** INFO
- **Category:** process-gap
- **Location:** cumulative across ADV-P10-MED-001/LOW-1/INFO-1 (pass 10) and
  ADV-P11-MED-001/LOW-1/LOW-2/INFO-1 (this pass)
- **Description:** Pass 10's own INFO-2 flagged that three separate pass-10 findings shared one
  root cause — "pass-10 corrected BC/VP but prd-delta/verification-delta header not re-synced" —
  and warned that a 4th instance in a later pass should promote this to a tracked process gap.
  This pass found FOUR such instances, all still on the SAME axis (a fix-burst edits the
  authoritative BC/VP body text but the two F2 derivative reconciliation docs —
  `prd-delta-components.md` and `verification-delta-components.md` — are not swept for every
  citing/summarizing location in the same commit): MED-1 (DEC-280 Linkage parenthetical), LOW-1
  (BC-8.1.001 summary row), LOW-2 (VP-COMPONENT-017 fixture description in both derivative and
  BC-inline copies), and INFO-1 (changelog header). The trigger condition from pass 10 is
  satisfied — this is now formally promoted from "pattern watch" to a documented, recurring
  process gap: **derivative-doc re-sync is not enforced as part of a fix-burst that edits a BC/VP
  body**, and each adversarial pass re-discovers whatever the previous pass's fix-burst didn't
  grep for, in escalating whack-a-mole fashion. The comprehensive reconciliation sweep run as part
  of this same pass-11 burst (see burst summary) is a one-time catch-up, not a durable fix for the
  recurrence — the next fix-burst that touches a BC/VP body without also greping both derivative
  docs for every citation of the changed text will reopen this class.
- **Proposed Fix (process, not spec-content):** Recommend a standing convention (to be ratified
  by product-owner/architect, not unilaterally adopted here): any fix-burst that edits BC/VP body
  text cited by `prd-delta-*.md`/`verification-delta-*.md` must `grep` both derivative docs for
  every reference to the changed BC/VP ID in the SAME burst and reconcile all hits, not just the
  location the adversarial finding named. This is a documentation recommendation for future
  bursts, not a spec change — no BC/VP content is affected by this finding itself.

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 1 |
| LOW | 2 |
| INFO | 2 |

**Overall Assessment:** pass-with-findings
**Convergence:** findings remain — iterate (fixed in the same burst that produced this review; see
burst summary for the comprehensive reconciliation sweep beyond the 3 flagged items)
**Readiness:** requires revision (derivative-doc re-sync only; no behavioral defect — zero
CRITICAL/HIGH for the second consecutive pass, and the fourth-in-a-row "same class, new location"
pattern is now the dominant signal, not fresh design gaps)

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 11 |
| **New findings** | 5 (MED-1, LOW-1, LOW-2, INFO-1, INFO-2) |
| **Duplicate/variant findings** | 0 (each is a genuinely new location, though all five share one root-cause CLASS with pass 10's MED-1/LOW-1/INFO-1) |
| **Novelty score** | 5 / (5 + 0) = 1.0 raw by location; qualitatively LOW by CLASS (see prose below) |
| **Median severity** | 2.6 (MED=3, LOW=2, LOW=2, average of the three substantive findings; INFO items excluded from severity trend per pass-10 convention) |
| **Trajectory** | P9: 1 HIGH + 1 LOW → P10: 1 MED + 1 LOW → P11: 1 MED + 2 LOW |
| **Verdict** | FINDINGS_REMAIN, but converging on a single recurring CLASS (derivative-doc propagation lag) rather than new design defects; all findings fixed in this same burst including a comprehensive sweep beyond the flagged items — expect CONVERGENCE_REACHED at pass 12 if the sweep's fixes hold and no further derivative-doc drift is found |

By LOCATION, novelty is nominally 1.0 (every finding is a new file:line). By CLASS, novelty is LOW
— all five findings are the identical "authoritative BC/VP body was fixed, derivative summary/
header doc lagged" defect shape pass-10's own INFO-2 predicted would recur, now formally promoted
to a tracked process-gap (INFO-2 above) rather than merely re-observed. No CRITICAL/HIGH has
appeared in two consecutive passes; the underlying `jr` design (wire shapes, delete-safety
ordering, resolver contracts, VP↔BC mapping) continues to test as sound. The recurring defect is
entirely in keeping two hand-maintained reconciliation documents in sync with the BC/VP bodies
they summarize — a process gap, not a spec-content gap.
