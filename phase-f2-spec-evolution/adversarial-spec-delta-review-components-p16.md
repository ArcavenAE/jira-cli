---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-15T00:00:00
phase: f2
inputs: [.factory/specs/prd/bc-3-issue-write.md, .factory/specs/prd/bc-8-components.md, .factory/specs/prd/bc-2-issue-read.md, .factory/phase-f2-spec-evolution/prd-delta-components.md, .factory/specs/prd/BC-INDEX.md, .factory/phase-f2-spec-evolution/verification-delta-components.md, .factory/specs/architecture/decisions/ADR-0018-component-resolution-caching-mutation-strategy.md]
input-hash: "84129ce"
traces_to: .factory/phase-f2-spec-evolution/prd-delta-components.md
pass: 16
previous_review: .factory/phase-f2-spec-evolution/adversarial-spec-delta-review-components-p14.md
---

# Adversarial Review: Component Management Bundle (Pass 16)

Adversarial Spec-Delta Review — Component Management (F2, pass 16). VERDICT: NOT CLEAN. 0 CRIT,
0 HIGH, 1 MEDIUM, 0 LOW, 2 INFO.

## Part A — Re-Verification of Prior Fixes

Novelty LOW — single ordering contradiction at the P6-ordering-note × older-Behavior/EC/VP seam;
everything else re-verified clean. Re-checked and CONFIRMED CLEAN/CONVERGED this pass: the
create/edit/delete/rename wire-shape triad against research §Q2.2/Q2.3; live-smoke gate wording
(1×ADD, 1×REMOVE only, no REPLACE — pass-10 fix holds); BC-8.2.007's snapshot fail-closed
`SnapshotIncomplete`→exit-1 taxonomy (pass-14 fix holds); the numeric-source confirming-`GET`
mechanism's four callers (BC-8.1.007/BC-8.2.002/BC-8.3.001 M1, plus BC-8.1.008's shared
not-found-message taxonomy); the uniform 404 taxonomy (resolver/confirming-GET 404 → exit 64;
mutating-call-layer race 404 → exit 1) across `edit`/`delete`/`rename`; the `--component` filter
grammar; `Component.id`'s dual string/absent-id typing (VP-COMPONENT-020); the BC count (28) and
VP run (001-028, gapless, collision-free); no capability/subsystem mis-anchoring found. No
regression in any previously-fixed finding (P1 through P14).

## Part B — New Findings

### MEDIUM

#### P16-MED-1: BC-8.1.007's no-fields zero-HTTP guarantee contradicts its own Precondition-ordering note for a NAME input

- **Severity:** MEDIUM
- **Category:** precondition-ordering / spec-internal contradiction
- **Location:** `.factory/specs/prd/bc-8-components.md` BC-8.1.007 Behavior (~L446), EC-8.1.007-1
  (~L527, pre-fix), the Preconditions ordering note (~L504, pre-fix); cross-check
  `.factory/phase-f2-spec-evolution/verification-delta-components.md` VP-COMPONENT-023
  (~L484-488, pre-fix).
- **Confidence:** HIGH
- **Description:** Four surfaces assert that `jr component edit <NAME|ID>` with none of
  `--name`/`--description`/`--lead` supplied exits 64 with ZERO HTTP calls: the Behavior
  paragraph ("MUST be supplied, or the command exits 64 before any HTTP call"), EC-8.1.007-1
  (`jr component edit foo` → "exit 64, zero HTTP"), VP-COMPONENT-023 ("Supplying none of
  `--name`/`--description`/`--lead` → exit 64 pre-flight, zero HTTP"), and the general shape of
  BC-8.1.007's design intent. But the pass-6 "ORDERING NOTE" on the Preconditions block stated
  the checked order as Precondition 1 (`NAME|ID` resolves via §8.4) → Precondition 2 (≥1 field
  flag supplied) → Precondition 3 (numeric-source confirming `GET`), and only ever guaranteed
  that Precondition 2 precedes Precondition 3 (closing the NUMERIC no-fields case, EC-8.1.007-7,
  pass 6's INFO-1). It never addressed Precondition 2 vs. Precondition 1. For a NAME `NAME|ID`
  on a cold component-list cache, §8.4 resolution (Precondition 1, as previously numbered) fires
  `GET /project/{key}/components` to build the candidate list BEFORE the Precondition-2 no-fields
  check is ever reached — one HTTP call, directly contradicting the "zero HTTP" guarantee all
  four surfaces make for exactly this input shape (`jr component edit foo`, no flags).
- **Failure mode if unfixed:** A wiremock fixture built from VP-COMPONENT-023 in a cold, freshly
  provisioned XDG temp dir, asserting `.expect(0)` on the component-list `GET` for
  `edit foo` with no flags, fails — the mock server records one hit. Alternatively, an
  implementer who builds literally to the Preconditions block's LISTED ORDER (resolve first,
  then check fields) produces code that is internally consistent with that block but violates
  the Behavior/EC-8.1.007-1/VP-COMPONENT-023 zero-HTTP claim for every NAME-input no-fields
  invocation — the four surfaces cannot all be satisfied simultaneously as written. This is a
  spec-unsatisfiability defect, not an implementation bug: no F4 implementation can be correct
  against all four surfaces at once until they are reconciled.
- **Proposed Fix:** Make the no-fields guard (previously Precondition 2) the FIRST pre-flight
  check evaluated — before BOTH `NAME|ID` resolution (previously Precondition 1) and the
  numeric-source confirming `GET` (Precondition 3) — so `jr component edit <NAME-or-numeric>`
  with no field flags is zero-HTTP for BOTH input kinds uniformly. This is a DELIBERATE
  divergence from `delete` (BC-8.2.001 Precondition 2: resolution runs regardless of disposition-
  flag state, so a bad `NAME|ID` is reported as not-found BEFORE the disposition guard, per
  BC-8.2.001 Invariant 1) — `edit`'s no-fields guard is a pure-flag check with no dependency on
  the target's existence, mirroring `issue edit`'s equivalent guard, which BC-8.1.007's own
  Behavior text already cites as precedent. Renumber the Preconditions list (no-fields check →
  Precondition 1; resolution → Precondition 2; numeric-source confirming `GET` stays Precondition
  3, unchanged, preserving existing "Precondition 3"/"Postcondition 3" cross-references
  elsewhere in the file) and rewrite the ordering note so it is literally true. Update
  EC-8.1.007-1 to state explicitly that this holds for the NAME case (zero §8.4 resolution GET,
  even on a cold cache) and EC-8.1.007-7 to reflect the renumbering and the strengthened
  guarantee. Extend VP-COMPONENT-023's Method to require `.expect(0)` on the §8.4 resolution
  `GET` for a NAME-input no-fields fixture, not only on the `PUT`.
- **Status:** FIXED same burst — `bc-8-components.md` BC-8.1.007's Preconditions block, ordering
  note, EC-8.1.007-1, and EC-8.1.007-7 now state the no-fields guard as Precondition 1, checked
  before both resolution (Precondition 2) and the numeric-source confirming `GET` (Precondition
  3, unchanged); `verification-delta-components.md` VP-COMPONENT-023's Property and Method were
  extended in place to require `.expect(0)` on the §8.4 resolution `GET` for the NAME-input
  no-fields case, not merely the `PUT`. EC-8.1.007-7's numeric no-fields zero-HTTP guarantee
  (pass 6) still holds — it is now explicitly stated as a special case of the same, broader
  Precondition-1-fires-first rule rather than a narrower numeric-only guarantee. No BC/VP count
  change (bc-8 stays 28 BCs; VP run stays 001-028; grand total stays 699).

### INFO (non-blocking)

#### P16-INFO-1: BC-8.1.004's numeric-exemption edge cases remain transitively (not directly) pinned

- **Severity:** INFO (non-blocking)
- **Location:** `.factory/specs/prd/bc-8-components.md` BC-8.1.004 (EC-8.1.004-6/7/8).
- **Description:** BC-8.1.004 mints no dedicated VP of its own for its numeric-ID project-
  required exemption; coverage is transitive via BC-8.1.008's EC-8.1.008-1 → VP-COMPONENT-014
  and BC-8.2.001's EC-8.2.001-4 → VP-COMPONENT-003, plus structural precedent from the already-
  tested BC-2.1.006 numeric-bypass guard. Re-verified this pass: the transitive citations still
  resolve correctly and no gap has opened since pass 14's carried-forward INFO note on a related
  (but distinct) BC-8.1.001 pagination assumption.
- **Proposed Fix:** None — acceptable coverage; no action required.
- **Status:** Carried forward, no action this pass.

#### P16-INFO-2: BC-8.2.006 Precondition 4 is non-sequentially numbered but unambiguous

- **Severity:** INFO (non-blocking)
- **Location:** `.factory/specs/prd/bc-8-components.md` BC-8.2.006.
- **Description:** BC-8.2.006 lists Precondition 4 (the numeric-source confirming `GET`) AFTER
  Precondition 3 (the affected-issue snapshot) in body order, but Precondition 4's own text
  self-states it is "resolved and passed BEFORE the snapshot (Precondition 3)" — i.e., the
  listed body order and the actual execution order diverge, but the text discloses this
  explicitly and makes no "checked in the listed order" claim the way BC-8.1.007's block did
  pre-fix. This is a different, and lower-risk, shape than P16-MED-1: BC-8.2.006 never asserts
  an order-implies-execution-sequence invariant that its own numbering then violates, so there
  is no spec-internal contradiction — just non-sequential numbering with a self-correcting
  annotation.
- **Proposed Fix:** None required — unambiguous as written. Optionally renumber in a future pass
  for readability parity with BC-8.1.007's now-corrected block, but this is cosmetic, not a
  defect.
- **Status:** Carried forward, no action this pass.

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 1 |
| LOW | 0 |
| INFO | 2 |

**Overall Assessment:** pass-with-findings (one MEDIUM precondition-ordering contradiction across
four surfaces for a single BC's no-fields guard; two carried-forward, non-blocking INFO notes;
no wire-shape, resolver-mechanism, or count/enumeration defect)
**Convergence:** findings remain — iterate (fixed in the same burst that produced this review)
**Readiness:** requires revision (ordering/wording fixes only; no BC/VP count change — 699 held
constant)

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 16 |
| **New findings** | 1 (MED-1) |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 1 / (1 + 0) = 1.0 by location; qualitatively LOW by class — a single,
  isolated ordering contradiction at the seam between a pass-6 partial fix (numeric-only
  ordering) and older, unrevised Behavior/EC/VP surfaces (NAME-input zero-HTTP claim); no
  propagation to other BCs, no count/enumeration defect family |
| **Trajectory** | P12: 1 HIGH + 0 MED/LOW → P13: 0 HIGH/MED + 1 LOW → P14: 0 HIGH/MED + 3 LOW
  → P16: 0 HIGH + 1 MEDIUM + 0 LOW (isolated, non-propagating) |
| **Verdict** | FINDINGS_REMAIN; fixed in this burst. Severity remains bounded at MEDIUM-or-below
  since pass 12 (no HIGH/CRITICAL recurrence); this pass's single finding is a residual of a
  PRIOR partial fix (pass 6 fixed the numeric half of this exact ordering question but not the
  NAME half) rather than a newly introduced defect — a pattern worth flagging for future passes:
  when a fix note narrows an ordering guarantee to one input variant, re-check the sibling
  variant(s) in the same burst. |
