---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-15T00:00:00
phase: f2
inputs: [.factory/specs/prd/bc-3-issue-write.md, .factory/specs/prd/bc-8-components.md, .factory/specs/prd/bc-2-issue-read.md, .factory/phase-f2-spec-evolution/prd-delta-components.md, .factory/specs/prd/BC-INDEX.md, .factory/phase-f2-spec-evolution/verification-delta-components.md, .factory/specs/architecture/decisions/ADR-0018-component-resolution-caching-mutation-strategy.md]
input-hash: "a88f24e"
traces_to: .factory/phase-f2-spec-evolution/prd-delta-components.md
pass: 14
previous_review: .factory/phase-f2-spec-evolution/adversarial-spec-delta-review-components-p13.md
---

# Adversarial Review: Component Management Bundle (Pass 14)

Adversarial Spec-Delta Review — Component Management (F2, pass 14). VERDICT: NOT CLEAN. 0 CRIT,
0 HIGH, 0 MEDIUM, 3 LOW, 1 INFO.

## Part A — Re-Verification of Prior Fixes

Novelty LOW — localized last-mile precision; core CRUD/delete-safety/rename/resolver/wire-fork
fully converged; ADR synced (P5 four-caller state), ARCH-INDEX/adr-index/SS-02/04/07/08 correct,
BC↔VP 001-028 gapless, counts arithmetically consistent (bc-2 108→114, bc-3 140→144, bc-8 28,
grand 661→699), title-sync + message-consistency hold. Pass-13's P13-LOW-1 flag-name typo fix
(`--components`→`--component` in BC-3.4.020 Precondition 3's Gate B cross-reference) was
re-verified in place — no regression.

## Part B — New Findings

### LOW

#### P14-LOW-1: Exit-code miscategorization on the JRACLOUD-95368 drift-abort synthesized error

- **Severity:** LOW
- **Category:** exit-code / error-taxonomy consistency
- **Location:** `.factory/specs/prd/bc-8-components.md` BC-8.2.007 Postcondition 5 (~L1323-1331,
  pre-fix); `.factory/phase-f2-spec-evolution/prd-delta-components.md` Error Taxonomy table
  (~L173); cross-check `.factory/phase-f2-spec-evolution/verification-delta-components.md`
  VP-COMPONENT-017 (~L388-394).
- **Description:** The JRACLOUD-95368 drift-abort sub-path was stated to exit 1, but the error
  was described as "`JrError::UserError`-shaped" — and `JrError::UserError` maps to exit 64
  everywhere in this codebase (`src/error.rs::JrError::exit_code()`; CLAUDE.md exit-code set;
  ~10 other taxonomy rows use `UserError`→64). This was the only taxonomy row describing an
  error by "shape" instead of a concrete variant, and the cited variant yields the WRONG exit
  code for the row's own "exit 1" column. A naive implementation of `Err(JrError::UserError(...))`
  compiles and reads as correct but exits 64, not 1 — failing VP-COMPONENT-017's "(a) exits 1"
  assertion, or, if the VP were built to match the naive implementation instead, giving users an
  exit-64 (don't-retry) signal for what is actually a transient/retryable pagination-drift
  condition that should exit 1.
- **Proposed Fix:** Stop citing `JrError::UserError`; specify a concrete exit-1 mechanism instead
  — a NEW, purpose-built `JrError` variant to be added at F4 (e.g. `JrError::SnapshotIncomplete`),
  falling to the same exit-code default (`_ => 1`) already used by `ApiError`/`NetworkError`/
  `Internal`/`Http`/`Io`/`Json`. `JrError::Internal` was considered and rejected: its doc comment
  reserves it for "invariant violation / should never happen" bugs, and a JRACLOUD-95368
  anti-loop abort is an expected, already-documented external data-consistency condition, not a
  `jr` bug. Keep the message "could not reliably enumerate affected issues — aborting delete".
- **Status:** FIXED same burst — BC-8.2.007 Postcondition 5, the prd-delta taxonomy row, and
  VP-COMPONENT-017 now name the same concrete exit-1 mechanism consistently (superseded text
  retained inline for audit trail per this repo's append-only convention).

#### P14-LOW-2: Missing Error Taxonomy row for the `--component` + `--request-type` M11/DEC-188 guard

- **Severity:** LOW
- **Category:** spec-delta completeness / taxonomy coverage
- **Location:** `.factory/phase-f2-spec-evolution/prd-delta-components.md` Error Taxonomy table
  (~L162-189) vs. `.factory/specs/prd/bc-3-issue-write.md` BC-3.4.024 Postcondition 3 +
  EC-3.4.024-3 (~L2688-2704), VP-COMPONENT-025.
- **Description:** The prd-delta Error Taxonomy table (the delta exit-code catalog, re-synced
  pass-7) enumerates every sibling `--component` exit-64 path (unresolvable/ambiguous name,
  cross-project bulk, Gate B, label conflict) but omitted the M11/DEC-188 `issue create
  --component` combined with `--request-type` guard — a distinct exit-64 path with its own
  message and its own VP coverage (VP-COMPONENT-025). A reviewer or F4 implementer enumerating
  exit-64 paths for coverage from this table alone would miss it.
- **Proposed Fix:** Add row: `issue create --component combined with --request-type | 64 |
  JrError::UserError | BC-3.4.024`, placed alongside the sibling `--component` exit-64 rows.
- **Status:** FIXED same burst.

#### P14-LOW-3: Self-contradictory postcondition text in BC-3.4.023 (single-POST coalescing vs. two sequential POSTs)

- **Severity:** LOW
- **Category:** spec-fidelity / internal contradiction
- **Location:** `.factory/specs/prd/bc-3-issue-write.md` BC-3.4.023 Postcondition 3
  (~L2520-2529).
- **Description:** The postcondition opened with "...`jr` issues TWO coalesced entries in a
  single POST — mirroring BC-3.4.006/BC-3.4.020's ADD-then-REMOVE coalescing convention..."
  and then reversed to "...`jr` performs TWO sequential bulk POSTs (ADD POST first, REMOVE POST
  second)." The single-POST coalescing framing is the label-path (`labelsFields`
  array-of-elements) behavior, and is WRONG for components: the `multiselectComponents`
  single-object schema forbids carrying both ADD and REMOVE in one POST — exactly the
  divergence this BC exists to specify. The net contract elsewhere in the BC (EC-3.4.023-2,
  Postcondition 6, Invariant 1, VP-COMPONENT-012) was unambiguous, but the normative
  postcondition text itself was internally contradictory. An implementer reading Postcondition 3
  in isolation could build a single coalesced POST, silently dropping or malforming the REMOVE
  action — the same defect class `BUG-LABEL-400`/`FIX-BULK-TRANSITION-001` (DEC-280) exists to
  prevent.
- **Proposed Fix:** Remove the "TWO coalesced entries in a single POST — mirroring ...
  coalescing convention" framing; state only the mirrored ADD-then-REMOVE ORDERING (not
  single-POST coalescing), concluding with the correct TWO sequential POSTs.
- **Status:** FIXED same burst — consistent with EC-3.4.023-2, Postcondition 6, Invariant 1,
  VP-COMPONENT-012.

### INFO

#### P14-INFO-1: BC-8.1.001 assumed-non-paginated (carried forward, non-blocking)

- **Severity:** INFO (non-blocking)
- **Location:** `.factory/specs/prd/bc-8-components.md` BC-8.1.001 (~L46-68).
- **Description:** `GET /project/{key}/components` non-pagination is ASSUMED pending F4
  verification — already correctly softened as an F4-verification assumption since pass-10.
  Not a defect; F4 must confirm (both `resolve_component`'s candidate list and `rename
  --all-projects`'s fan-out depend on a complete component list — a paginated reality would be
  a genuine correctness issue, not merely a documentation gap).
- **Proposed Fix:** None — leave as-is; F4 delivery-task obligation already covers this.
- **Status:** Carried forward, no action this pass.

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 0 |
| LOW | 3 |
| INFO | 1 |

**Overall Assessment:** pass-with-findings (three isolated LOWs — one exit-code miscategorization,
one taxonomy-completeness gap, one internally-contradictory postcondition sentence — no
wire-shape, resolver-mechanism, or count/enumeration defect)
**Convergence:** findings remain — iterate (fixed in the same burst that produced this review)
**Readiness:** requires revision (wording/variant/row fixes only; no BC/VP count change — 699
held constant)

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 14 |
| **New findings** | 3 (LOW-1, LOW-2, LOW-3) |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 3 / (3 + 0) = 1.0 by location; qualitatively LOW by class — three
  isolated, localized wording/citation defects, no propagation, no count/enumeration defect
  family |
| **Trajectory** | P12: 1 HIGH + 0 MED/LOW → P13: 0 HIGH/MED + 1 LOW → P14: 0 HIGH/MED + 3 LOW
  (isolated, non-propagating) |
| **Verdict** | FINDINGS_REMAIN; fixed in this burst. Trajectory continues to show severity decay
  (no HIGH/MEDIUM since pass 12) with only isolated, single-location LOW findings — no residual
  class-level defects identified in this pass's re-verification sweep. |
