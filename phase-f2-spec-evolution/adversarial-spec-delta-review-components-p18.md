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
pass: 18
previous_review: .factory/phase-f2-spec-evolution/adversarial-spec-delta-review-components-p17.md
---

# Adversarial Review: Component Management Bundle (Pass 18)

## Finding ID Convention

Finding IDs use the format: `ADV-<CYCLE>-P<PASS>-<SEV>-<SEQ>`

- `ADV`: Fixed prefix identifying adversarial findings
- `<CYCLE>`: Cycle prefix from `.factory/current-cycle` (e.g., `P1CONV`, `P3PATCH`)
  - No `.factory/current-cycle` file exists in this repo, so the cycle segment is omitted
    (falls back to `ADV-P<PASS>-<SEV>-<SEQ>`)
- `<PASS>`: Two-digit pass number (`P18` for this pass)
- `<SEV>`: Severity abbreviation (`CRIT`, `HIGH`, `MED`, `LOW`, `INFO`)
- `<SEQ>`: Three-digit sequence within the pass (e.g., `001`)

This pass has zero HIGH/MEDIUM/LOW findings, so no `ADV-P18-*` IDs are minted below; the three
INFO notes are numbered `P18-INFO-1..3` for continuity with this delta's established INFO
numbering convention (matching pass 17's `P17-INFO-1..3` style), not the full `ADV-P18-INFO-NNN`
form, since INFO notes are non-blocking and this delta's prior passes have consistently used the
shorter `P<PASS>-<SEV>-<SEQ>` form throughout (see pass 17 Part B).

Adversarial Spec-Delta Review — Component Management (F2, pass 18). VERDICT: CLEAN. Counts: 0
CRIT, 0 HIGH, 0 MEDIUM, 0 LOW, 3 INFO (none carries a concrete failure scenario → non-blocking).

## Part A — Re-Verification of Prior Fixes

Pass-17 CLEAN carried forward. Pass 17 recorded zero HIGH/MEDIUM/LOW findings (Part B), with
pass-16's single MEDIUM (BC-8.1.007 no-fields precondition ordering for a NAME input) confirmed
resolved in pass 17 Part A and re-confirmed again this pass by independent re-derivation: no
wiremock fixture built against VP-COMPONENT-023 as currently written can observe an HTTP call for
`jr component edit <NAME>` with no field flags, on either a warm or cold component-list cache.
No fix burst ran between pass 17 and this pass — the perimeter (BCs, ADR-0018, deltas, VP
catalog) is byte-identical to pass 17's reviewed state, consistent with the frozen `input-hash`
above and with a concurrent review running against the identical perimeter.

## Part B — New Findings

None. Independent re-derivation verified PASS across the full component-management bundle:

- **Count/enumeration** — bc-8 holds 28 BCs, reconciling as §8.1(8) + §8.2(8) + §8.3(7) +
  §8.4(5) = 28; prd-delta's 28 + 6 + 4 = 38 arithmetic checks out against the 661 → 699
  grand-total delta; BC-2.1.006 enumerates its 14 filter sources completely and without
  duplication.
- **VP catalog** — VP-COMPONENT-001 through 028 remain gapless and collision-free; VP-014's
  canonical home is BC-8.4.001 and VP-021's is BC-8.4.005, both correctly anchored; VP-015 spans
  5 BC homes and VP-025 spans 2 BC homes as a single-property check, both internally consistent
  with their own scope; §2 of the verification delta covers all 28 BCs; BC-2.3.040 traces
  correctly to VP-020.
- **Semantic anchoring** — every VP's stated BC home matches the BC's actual scope; module/path
  anchors are consistent across ADR-0018, the architecture delta, and the BC bodies; no
  mis-anchored VP or BC found.
- **Numeric-bypass confirming-GET surface** — all 4 usages (delete SOURCE, both dispositions;
  move-to TARGET; edit; rename) are correctly documented across ADR-0018 §1, BC-8.4.001, and
  BC-8.2.002/BC-8.1.007/BC-8.3.001 Method-1, with VP-004 asserting the uniform cross-project
  mismatch message across all four.
- **404 taxonomy** — resolver-layer and confirming-`GET` 404s map to exit 64 (user error);
  mutating-call-layer 404 (lost-update race) maps to exit 1 (API error); BC-8.2.008 is the
  canonical statement, with edit/rename correctly extending it and VP-024 covering the split.
- **BC-8.1.008 not-found message branching** — the three message branches (0/1/2) are correctly
  keyed: a bare NAME input defers to BC-8.4.002/BC-8.4.003; a numeric input branches on
  numeric-known-vs-no-project keyed on whether a project is known from ANY input source (not
  specifically `--project`); rename's message is always project-qualified. No contradiction found.
- **Snapshot fail-closed behavior** — BC-8.2.007 Precondition 5 correctly triggers `has_more=true`
  → `SnapshotIncomplete` → exit 1 on JRACLOUD-95368 drift mid-snapshot; `ORDER BY key ASC` is
  enforced; the affected-issue snapshot keys on `component=<resolvedId>`, not name.
- **Wire-shape taxonomy (DEC-280)** — the 3 distinct shapes remain internally consistent: the
  2×ceil chunking for bulk `--move-to` (BC-3.4.023 Precondition 6 / VP-012) is correctly applied;
  the echo path's `BTreeMap` shape (post the earlier H1 correction) is unchanged; the dry-run
  array shape (BC-3.4.021 / VP-028) remains structurally distinct from the live-call payload.
- **Precondition ordering** — BC-8.1.007's Precondition 1 (no-fields) < Precondition 2
  (§8.4 resolution) < Precondition 3 (confirming GET) ordering holds; EC-8.1.007-1 and
  EC-8.1.007-7 remain aligned with VP-023.
- **Filter grammar** — bare/`not:`/`none`/`all:` forms, coexistence rules, project-scope guards,
  and the documented reserved-syntax gaps are all internally consistent; VP-013/VP-015 correctly
  cover this surface.

### INFO (non-blocking)

#### P18-INFO-1: prd-delta error-taxonomy table omits two exit-code rows already fully specified by the authoritative BCs

- **Severity:** INFO (non-blocking, process-gap-adjacent)
- **Location:** `.factory/phase-f2-spec-evolution/prd-delta-components.md` error-taxonomy table,
  approx. L162–190.
- **Description:** The table lists the move-to TARGET out-of-project exit-64 case (approx. L170)
  but omits two rows that the authoritative BCs and VPs already fully specify: (1) the
  numeric-SOURCE cross-project mismatch exit-64 case (BC-8.2.002 / BC-8.1.007 / BC-8.3.001
  Method-1), and (2) the edit/rename PUT race-404 → exit-1 case (only the delete DELETE race-404
  row is listed, at approx. L174). F4 implements against the BCs and VPs directly, not against
  this summary table, so this is a documentation-completeness gap in a non-authoritative summary,
  not a spec contradiction.
- **Proposed Fix:** None required for correctness. Consider re-syncing the summary table with the
  authoritative BC/VP error taxonomy in a future pass for readability.
- **Status:** Noted, no action required.

#### P18-INFO-2: prd-delta summary table has no row for component edit's "no fields specified" exit-64 case

- **Severity:** INFO (non-blocking)
- **Location:** `.factory/phase-f2-spec-evolution/prd-delta-components.md` error-taxonomy summary
  table.
- **Description:** BC-8.1.007's Behavior section correctly and unambiguously specifies that
  `component edit` with no field flags exits 64 (DEC-188 UserError), but the prd-delta summary
  table has no corresponding row. As with P18-INFO-1, this is a summary-table omission only — the
  authoritative BC is complete and unambiguous.
- **Proposed Fix:** None required. Optionally add the row to the summary table for
  discoverability.
- **Status:** Noted, no action required.

#### P18-INFO-3: BC-8.1.007's "mirrors issue edit's equivalent guard" phrasing could be misread as an exit-code parity claim

- **Severity:** INFO (non-blocking, wording note)
- **Location:** `.factory/specs/prd/bc-8-components.md` BC-8.1.007 Behavior field.
- **Description:** BC-8.1.007's Behavior text says the no-fields guard "mirrors issue edit's
  equivalent guard." Issue edit's no-fields guard (BC-3.4.012) exits 1, while component edit's
  no-fields guard correctly exits 64 (DEC-188 UserError) — a deliberate and correct divergence.
  "Mirrors" refers to the conceptual guard-shape (reject an edit with no field changes specified),
  not the exit code, and BC-8.1.007 states its own exit code (64) unambiguously elsewhere in the
  same BC, so there is no actual contradiction — only a phrasing that a fast reader could
  momentarily misparse as an exit-code parity claim.
- **Proposed Fix:** None required for correctness. Consider adding a one-clause disambiguation
  (e.g., "…mirrors issue edit's equivalent guard in shape, though the exit code differs per
  DEC-188") in a future pass.
- **Status:** Noted, no action required.

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 0 |
| LOW | 0 |
| INFO | 3 |

**Overall Assessment:** CLEAN — pass-17's clean result (itself confirming pass-16's single
MEDIUM resolved) carried forward with zero regressions; independent re-derivation across the full
component-management bundle (count/enumeration, VP catalog gaplessness, semantic anchoring,
numeric-bypass confirming-GET surface, 404 taxonomy, not-found message branching, snapshot
fail-closed behavior, wire-shape taxonomy, precondition ordering, filter grammar) surfaced zero
new HIGH/MEDIUM/LOW findings; three non-blocking INFO notes recorded, all confined to
documentation-completeness in the non-authoritative prd-delta summary table plus one wording
clarification, none with a concrete failure scenario.
**Convergence:** clean pass — no findings requiring a fix burst.
**Readiness:** no revision required; perimeter (BCs, ADR-0018, deltas) left byte-identical this
pass, consistent with a concurrent review running against the identical perimeter; BC/VP counts
unchanged (bc-8 = 28 BCs, VP run 001–028, grand total 699).

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 18 |
| **New findings** | 0 |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | LOW — substantive spec (BCs/VPs/ADR/arch-delta) internally consistent and complete across the full hunt matrix; only residue is doc-completeness in the non-authoritative prd-delta summary table (INFO) |
| **Trajectory** | P14: 0 HIGH/MED + 3 LOW → P16: 0 HIGH + 1 MEDIUM + 0 LOW (isolated, non-propagating, fixed same burst) → P17: 0 HIGH/MEDIUM/LOW + 3 INFO (CLEAN, clean pass 1 of 3) → P18: 0 HIGH/MEDIUM/LOW + 3 INFO (CLEAN, clean pass 2 of 3) |
| **Verdict** | CONVERGED trajectory continues. This is the delta's second consecutive fully clean pass since pass 16's isolated MEDIUM; no severity has recurred at HIGH or CRITICAL since pass 12. Per the convergence policy (minimum 3 clean passes to declare full convergence), this counts as clean pass 2 of 3 for the component-management bundle — continue the review cadence for at least one more pass before closing out. Delta converged; this pass CLEAN. |
