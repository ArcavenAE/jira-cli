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
pass: 17
previous_review: .factory/phase-f2-spec-evolution/adversarial-spec-delta-review-components-p16.md
---

# Adversarial Review: Component Management Bundle (Pass 17)

## Finding ID Convention

Finding IDs use the format: `ADV-<CYCLE>-P<PASS>-<SEV>-<SEQ>`

- `ADV`: Fixed prefix identifying adversarial findings
- `<CYCLE>`: Cycle prefix from `.factory/current-cycle` (e.g., `P1CONV`, `P3PATCH`)
  - No `.factory/current-cycle` file exists in this repo, so the cycle segment is omitted
    (falls back to `ADV-P<PASS>-<SEV>-<SEQ>`)
- `<PASS>`: Two-digit pass number (`P17` for this pass)
- `<SEV>`: Severity abbreviation (`CRIT`, `HIGH`, `MED`, `LOW`, `INFO`)
- `<SEQ>`: Three-digit sequence within the pass (e.g., `001`)

This pass has zero HIGH/MEDIUM/LOW findings, so no `ADV-P17-*` IDs are minted below; the three
INFO notes are numbered `P17-INFO-1..3` for continuity with this delta's established INFO
numbering convention (matching pass 16's `P16-INFO-1`/`P16-INFO-2` style), not the full
`ADV-P17-INFO-NNN` form, since INFO notes are non-blocking and this delta's prior passes have
consistently used the shorter `P<PASS>-<SEV>-<SEQ>` form throughout (see pass 16 Part B).

Adversarial Spec-Delta Review — Component Management (F2, pass 17). VERDICT: CLEAN (zero
HIGH/MEDIUM/LOW). Counts: 0 CRIT, 0 HIGH, 0 MEDIUM, 0 LOW, 3 INFO.

## Part A — Re-Verification of Prior Fixes

Pass-16 MED-1 (BC-8.1.007 no-fields precondition ordering for a NAME input) CONFIRMED RESOLVED:
the no-fields guard is now Precondition 1 in BC-8.1.007's Preconditions block, checked before
both §8.4 resolution (now Precondition 2) and the numeric-source confirming `GET` (Precondition
3, unchanged numbering, preserving existing cross-references elsewhere in the file). EC-8.1.007-1
(NAME-input zero-HTTP, now explicitly including zero resolution `GET` even on a cold cache) and
EC-8.1.007-7 (numeric-input zero-HTTP) agree with each other and with the renumbered ordering
note. VP-COMPONENT-023's Method now asserts `.expect(0)` on BOTH the §8.4 resolution `GET` and
the `PUT` for the no-fields fixture, closing the gap the four-surfaces contradiction previously
left open. Precondition 3 keeps its original number post-renumbering, so no downstream
"Precondition 3"/"Postcondition 3" cross-reference elsewhere in `bc-8-components.md` was
invalidated by the fix. Independently re-derived: no wiremock fixture built against
VP-COMPONENT-023 as currently written can observe an HTTP call for `jr component edit <NAME>`
with no field flags, on either a warm or cold component-list cache.

## Part B — New Findings

None. Independent re-derivation across the full component-management bundle re-confirmed CLEAN
in every area re-walked this pass:

- **CRUD/exit-code taxonomy** — numeric-ID exemption applies uniformly to `list`/`edit`/`delete`
  and is correctly excluded from `rename` (name-only target by definition); `create`'s
  clap-required-arg enum maps to exit 2 per DEC-188; `edit` remains a partial-PUT (only supplied
  fields sent).
- **Delete safety (DEC-279)** — disposition guard fires at the application level (exit 64, not
  clap); `--move-to` resolves the TARGET component before the DELETE fires; both SOURCE and
  TARGET numeric-ID inputs get their own project-membership confirming `GET`; self-move is
  rejected via numeric-ID equality (not name string compare); the orphan-count confirmation gate
  fires before the destructive call; the affected-issue snapshot enforces `ORDER BY key ASC` with
  full pagination and fails closed (`SnapshotIncomplete` → exit 1) on JRACLOUD-95368 drift mid-
  snapshot. All six items match research Q1.1–Q1.6 verbatim, re-checked against the current file
  state, not merely against pass-16's summary of them.
- **404 taxonomy** — uniform across `edit`/`delete`/`rename`: resolver-layer and confirming-`GET`
  404s map to exit 64 (user error — bad target); mutating-call-layer 404 (lost-update race
  between resolution and the write) maps to exit 1 (API error). VP-COMPONENT-024 still covers
  this split correctly.
- **Not-found message branching** — the project-known-by-any-source correction (carried from an
  earlier pass, referred to internally as "P6-corrected") still holds: the not-found message
  varies only on whether a project key was resolvable from ANY input source, not specifically
  from `--project`.
- **Resolver/cross-project surface** — BC-8.4.001 through BC-8.4.005 and ADR-0018 §1 remain
  internally consistent; BC-8.4.001's "ALL FOUR usages" claim still enumerates correctly against
  the four call sites (list/edit/delete SOURCE/delete TARGET via `--move-to`); the
  `--all-projects` flag's exact-equality matching (VP-COMPONENT-026) and component-ID global
  uniqueness assumption are unchanged and unbroken.
- **Wire shapes (DEC-280)** — the three distinct shapes (update-verb object for `edit`/`rename`;
  bulk `multiselectComponents` integer `componentId` array with 2×ceil chunking for `delete
  --move-to`; additive array for `create`) remain internally consistent and match research Q2.2;
  the live-smoke gate still exercises ADD and REMOVE only (no REPLACE), matching the pass-10 fix.
- **Echo/dry-run behavior** — string-keyed `BTreeMap` echo (post an earlier correction referred to
  internally as "H1-corrected"), bare-value-to-`add:` normalization, and the dry-run JSON array
  shape (structurally distinct from the live-call payload) are all unchanged and consistent.
- **VP catalog** — VP-COMPONENT-001 through 028 remain gapless and collision-free; the
  014–021 split is intact; exactly one VP (012) carries the `LIVE-JIRA` marker; §3's VP↔BC map is
  still in sync with the catalog body.
- **BC/VP counts** — bc-8 holds at 28 BCs; the VP run holds at 001–028; grand total holds at 699.
  No BC, VP, ADR, or delta file was touched to produce this pass.

### INFO (non-blocking)

#### P17-INFO-1: BC-8.1.003's `--counts` column repurposes the `relatedIssueCounts` endpoint reference from delete-safety research context

- **Severity:** INFO (non-blocking)
- **Location:** `.factory/specs/prd/bc-8-components.md` BC-8.1.003 Source field.
- **Description:** BC-8.1.003's Source citation for the `--counts` column points at the same
  `relatedIssueCounts` endpoint that research Q1.3/Q1.6-item-1 documents primarily in the
  delete-safety (orphan-count confirmation) context. The endpoint reference itself is genuine —
  it is the correct endpoint for both uses — but the phrasing reads as a mild repurposing of a
  delete-safety-flavored citation into a `list`-flavored one. No contradiction with BC-8.1.001's
  pagination note; both BCs correctly describe their own call site's behavior independently.
- **Proposed Fix:** None — accurate as written; optionally reword the Source field in a future
  pass to state the `list --counts` use case first, independent of the delete-safety framing, for
  readability only.
- **Status:** Noted, no action required.

#### P17-INFO-2: ADR-0018 §1's "four numeric-ID mutation paths" prose enumerates via three command bullets

- **Severity:** INFO (non-blocking)
- **Location:** `.factory/specs/architecture/decisions/ADR-0018-component-resolution-caching-mutation-strategy.md` §1.
- **Description:** ADR-0018 §1 states "four numeric-ID mutation paths" in prose but the bulleted
  enumeration underneath lists three command-level bullets, because `delete`'s `--move-to` TARGET
  usage is folded into the single `delete` bullet alongside the SOURCE usage rather than broken
  out as its own bullet. The count is accurate (4 distinct numeric-ID usages: list SOURCE, edit
  SOURCE, delete SOURCE, delete/--move-to TARGET) — it is a presentation choice, not a
  miscount — and BC-8.4.001's Behavior text already states "ALL FOUR usages" explicitly and
  correctly, so no cross-document inconsistency results.
- **Proposed Fix:** None required — optionally split the `delete` bullet into two (SOURCE /
  TARGET) in a future pass for 1:1 bullet-to-usage correspondence; cosmetic only.
- **Status:** Noted, no action required.

#### P17-INFO-3: Two verification axes remain outside what a read-only spec-delta pass can discharge

- **Severity:** INFO (non-blocking, scope note)
- **Location:** N/A — process/scope observation, not a file-level finding.
- **Description:** Two checks this review cannot itself execute or complete under a read-only,
  perimeter-frozen constraint: (a) BC H1-title ↔ `BC-INDEX.md` title-column sync for the
  component-management BCs is outside this delta's file perimeter (BC-INDEX.md is not one of
  this review's `inputs:`), so H1/title drift, if any, would not be visible from this pass alone;
  (b) `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` are executable
  guards, not something this review can "pass" by inspection — `prd-delta-components.md` and
  `verification-delta-components.md` document their expected exit-0 state, but this pass notes
  that expectation rather than asserting it independently (the calling burst runs the scripts
  separately, outside this review document).
- **Proposed Fix:** None — these are scope boundaries of the review type, not defects. Flagged
  for continuity so a future pass with BC-INDEX.md in its input set can close axis (a).
- **Status:** Noted, not asserted as a finding.

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 0 |
| LOW | 0 |
| INFO | 3 |

**Overall Assessment:** CLEAN — pass-16's single MEDIUM (precondition-ordering contradiction)
confirmed resolved; independent re-derivation across the full component-management bundle
(CRUD/exit-code taxonomy, delete safety, 404 taxonomy, not-found messaging, resolver/cross-
project surface, wire shapes, echo/dry-run behavior, VP catalog, BC/VP counts) surfaced zero new
HIGH/MEDIUM/LOW findings; three non-blocking INFO notes carried/added for continuity.
**Convergence:** clean pass — no findings requiring a fix burst.
**Readiness:** no revision required; perimeter (BCs, ADR-0018, deltas) left byte-identical this
pass; BC/VP counts unchanged (bc-8 = 28 BCs, VP run 001–028, grand total 699).

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 17 |
| **New findings** | 0 |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 0 / (0 + 0) — undefined by the ratio form; qualitatively ZERO — no new gap surfaced anywhere in the re-derivation |
| **Trajectory** | P13: 0 HIGH/MED + 1 LOW → P14: 0 HIGH/MED + 3 LOW → P16: 0 HIGH + 1 MEDIUM + 0 LOW (isolated, non-propagating, fixed same burst) → P17: 0 HIGH/MEDIUM/LOW + 3 INFO (CLEAN) |
| **Verdict** | CONVERGED this pass. This is the delta's first fully clean pass since pass 16's isolated MEDIUM; no severity has recurred at HIGH or CRITICAL since pass 12. Per the convergence policy (minimum 3 clean passes to declare full convergence), this counts as clean pass 1 of 3 for the component-management bundle — continue the review cadence rather than closing out after a single clean result. |
