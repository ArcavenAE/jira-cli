---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-15T00:00:00
phase: f2
inputs: [.factory/specs/prd/bc-3-issue-write.md, .factory/specs/prd/bc-8-components.md, .factory/specs/prd/bc-2-issue-read.md, .factory/phase-f2-spec-evolution/prd-delta-components.md, .factory/specs/prd/BC-INDEX.md, .factory/phase-f2-spec-evolution/verification-delta-components.md, .factory/specs/architecture/decisions/ADR-0018-component-resolution-caching-mutation-strategy.md]
input-hash: "520f43e"
traces_to: .factory/phase-f2-spec-evolution/prd-delta-components.md
pass: 13
previous_review: .factory/phase-f2-spec-evolution/adversarial-spec-delta-review-components-p12.md
---

# Adversarial Review: Component Management Bundle (Pass 13)

Adversarial Spec-Delta Review — Component Management (F2, pass 13). VERDICT: NOT CLEAN. 0 CRIT,
0 HIGH, 0 MEDIUM, 1 LOW, 1 INFO.

## Part A — Re-Verification of Prior Fixes

COUNT/ENUM VERIFIED CLEAN: filter-source 14 (BC-2.1.006 title + stderr literal + prd-delta L119);
`--label` conflict block 13 (BC-3.4.020 P3 + EC-3.4.017-14 R2 pin + "13 fields" + VP-027 +
co-author "11 tests" = 13-minus-field-summary); Gate B 5 (BC-3.4.017 title/scope/preconds/Inv4/
EC-3.4.017-11/VP-396-005); VP 001-028 gapless/collision-free (§0.1 28 rows, §2 method table, §3
mapping, prd-delta L269; 014/021 split; 004/024 extensions); ADR-0018 synced (§1 four callers, §3
resolvedId+ORDER BY, §4/Rationale ADD/REMOVE-only gate; prior §1 staleness resolved); prd-delta
derivative synced (38 new BCs 28+6+4, 7 amended, taxonomy L53/L164 P7-corrected, VP range
P8-corrected).

All pass-12 fixes (P12-HIGH-1's 13-count propagation to EC-3.4.017-14, the P12-sweep INFO-3 fix to
EC-3.4.017-11's Gate B canonical-key enumeration) were re-verified in place and consistent across
every citing surface. No regression found.

## Part B — New Findings

### LOW

#### P13-LOW-1: Gate B cross-reference in BC-3.4.020 Precondition 3 cites the nonexistent flag `--components` (plural) instead of `--component` (singular)

- **Severity:** LOW
- **Category:** spec-fidelity / flag-name accuracy
- **Location:** `.factory/specs/prd/bc-3-issue-write.md` ~L2118, BC-3.4.020 Precondition 3 (the
  Gate B cross-reference sentence).
- **Description:** The sentence reads "...Gate B covers ... `--summary`/`--description`/`--type`/
  `--priority`/`--components` only" — every other item in this list is a CLI flag name
  (`--summary`, `--description`, `--type`, `--priority`), so the fifth item, by the list's own
  established shape, must also be a flag name. The real flag is `--component` (singular). The
  plural `components` (no `--` prefix) is correct only when referring to the Jira system field
  key elsewhere in the spec — it is not a valid CLI flag spelling. `--components` (plural,
  flag-prefixed) is the sole occurrence of this exact token anywhere in `.factory/specs/prd/`
  (grep-confirmed 1 hit pre-fix).
- **Rationale for LOW, not MEDIUM:** Self-correcting. The authoritative owner of Gate B's flag
  scope is BC-3.4.017 ("Scope of Gate B" paragraph, Preconditions, and Invariant 4), which
  unambiguously and consistently uses `--component` (singular) throughout. A test-writer or
  implementer building against BC-3.4.020's cross-reference who searches the clap CLI definition
  for `--components` will find nothing, and will reconcile against BC-3.4.017's unambiguous
  singular spelling rather than propagate the typo into code. No test pin, R2 assertion, or wire
  schema depends on this specific string — it is prose-only.
- **Evidence:**
  - bc-3-issue-write.md ~L2118 (BC-3.4.020 Precondition 3): "the flag-overlap for
    `--summary`/`--description`/`--type`/`--priority`/`--components` only" (plural, pre-fix).
  - bc-3-issue-write.md BC-3.4.017 "Scope of Gate B" / Preconditions / Invariant 4: consistently
    singular `--component` throughout (5-member set: `summary`, `description`, `issuetype`,
    `priority`, `components` as the Jira field key; `--component` as the CLI flag).
- **Impact:** Cosmetic — a careful reader following the Gate B cross-reference could be briefly
  confused about the correct flag spelling, but BC-3.4.017 remains the unambiguous, correctly-spelled
  source of truth two sections over.
- **Novelty:** genuinely new — pass 12's Gate B sweep (item (a) in its Sweep Findings) verified the
  5-member field-count consistency at BC-3.4.017's own paragraphs but did not check the
  BC-3.4.020 cross-reference sentence's individual token spellings against the CLI flag surface.
- **Proposed Fix:** L2118: `--components` → `--component`.

### INFO

#### P13-INFO-1 (non-blocking, no fix applied): BC-3.4.023 bulk POST example body omits top-level `sendBulkNotification: false`

- **Severity:** INFO
- **Category:** wire-example completeness (non-blocking)
- **Location:** `.factory/specs/prd/bc-3-issue-write.md` ~L2508-2519, BC-3.4.023 bulk POST example
  body.
- **Description:** Research (Q2.2) shows the live Jira bulk-transition wire schema includes a
  top-level `sendBulkNotification: false` key (see also the FIX-BULK-TRANSITION-001 CLAUDE.md
  entry documenting the nested `bulkTransitionInputs` shape). BC-3.4.023's example POST body omits
  this key.
- **Ruling: NOT a defect.** Sibling bulk BCs — BC-3.4.020 Path B and BC-3.4.018 — also omit
  `sendBulkNotification` from their example bodies; this is an established convention in this file
  for illustrative example bodies (they show the shape of the fields under discussion, not every
  wire-level key). The actual wire shape is live-smoke-gated and will be corrected against the
  observed real shape if it diverges. No spec change proposed.
- **Impact:** None on this pass's verdict. Recorded for audit trail per task instruction; F4
  implementation smoke-testing should confirm the field is actually emitted on the wire.
- **Proposed Fix:** None — intentionally left as-is per established sibling-BC convention.

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 0 |
| LOW | 1 |
| INFO | 1 |

**Overall Assessment:** pass-with-findings (single LOW, cosmetic flag-name typo)
**Convergence:** findings remain — iterate (fixed in the same burst that produced this review)
**Readiness:** requires revision (one-token fix only; no wire-shape/resolver-mechanism/count defect)

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 13 |
| **New findings** | 2 (LOW-1, INFO-1) |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 2 / (2 + 0) = 1.0 by location; qualitatively LOW by class — single isolated
  typo, no propagation, no count/enumeration defect family |
| **Trajectory** | P11: 1 MED + 2 LOW → P12: 1 HIGH + 0 MED/LOW → P13: 0 HIGH/MED + 1 LOW |
| **Verdict** | FINDINGS_REMAIN; fixed in this burst. Trajectory strongly suggests convergence at
  pass 14 — novelty has decayed from a HIGH-severity sibling-BC count-drift class (pass 12) to a
  single isolated LOW-severity typo (pass 13) with no residual class-level defects identified in
  this pass's re-verification sweep. |
