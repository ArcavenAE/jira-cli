# F5 Scoped Adversarial — Pass 9

- **Cycle:** cycle-014 (`issue-triage-quickfixes`)
- **Phase:** F5 scoped adversarial review (delta loop resumed after `FIX-P5-009`/PR #902 merged)
- **Scope:** `git diff 204b1fb5..f72255cd` — the combined cycle-014 delta (STORY-A PR #886,
  STORY-C PR #887, STORY-B PR #888, `FIX-P5-001` PR #891, `FIX-P5-002` PR #894,
  `FIX-P5-003` PR #895, `FIX-P5-004` PR #896, `FIX-P5-005` PR #897, `FIX-P5-006` PR #898,
  `FIX-P5-007` PR #899, `FIX-P5-008` PR #901, `FIX-P5-009` PR #902), re-reviewed from fresh context.
- **Reviewers dispatched (3, fresh context):** adversary, code-reviewer, security-reviewer.
- **Date:** 2026-10-02
- **Convergence counter:** **0 of 3** (NOT CLEAN — counter does not advance). 9 of 15 passes used
  (cap raised from 10 to 15 by `D-403`).
- **Pass verdict:** **NOT CLEAN — FINDINGS_PRESENT** (adversary: 1 MEDIUM + 1 NIT). Code-reviewer
  returned APPROVE with CONVERGENCE_REACHED; security-reviewer returned APPROVE.
- **Novelty assessment:** MEDIUM. Orchestrator's note: `P9-001` was caused by the `FIX-P5-009`
  completeness claim ("Canonical Sink Inventory complete for all delta `src` files"), which an
  adversary then audited at whole-file granularity rather than diff granularity.

## Reviewer Verdicts

| Reviewer | Verdict | Findings |
|---|---|---|
| **adversary** | FINDINGS_PRESENT | `P9-001` MEDIUM; `P9-002` NIT |
| **code-reviewer** | APPROVE (CONVERGENCE_REACHED) | `CR9-001`, `CR9-002` NIT |
| **security-reviewer** | APPROVE | `SEC9-001` LOW (optional) |

## Findings and Dispositions

### adversary findings

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `P9-001` | MEDIUM | `BC-7.1.006`'s Canonical Sink Inventory claimed COMPLETENESS for the changed `src` files, but a whole-file read found unlisted echo sites. These included SERVER text (`handle_move`'s resolution-name picker items; `handle_comment`'s `comment.id` in `print_success`) and USER-typed key/id echoes in `interactions.rs`/`workflow.rs`. | `FIX-P5-010` (`D-404`): split the claim (see below) |
| `P9-002` | NIT | `user.rs` test rustdoc contradicts itself on whether libtest redirects fd 1. | `FIX-P5-010` (product-repo rustdoc reword) |

### code-reviewer findings (pass 9) — APPROVE, CONVERGENCE_REACHED

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `CR9-001` | NIT | The `user.rs` Active glyph is computed twice. | Part of the already-deferred `USER-ACTIVE-COLUMN-HEADER-MATCH`; no new item |
| `CR9-002` | NIT | `force_styling` reported as undocumented. | On check it was already documented; `FIX-P5-010` only verifies the note on `output.rs::render_table_with_styles_inner` |

### security-reviewer findings (pass 9) — APPROVE

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `SEC9-001` | LOW (optional) | `sanitize_*` drops U+2028/U+2029 rather than mapping them to a space, which can merge flanking words; tabs are mapped to a space for exactly that reason. A consistency suggestion against a documented deliberate choice. | RECORDED as new `OPEN-STANDING-ITEMS` entry `LINE-SEPARATOR-DROP-VS-SPACE` (LOW) |

## Human decision `D-404` (2026-10-02)

`FIX-P5-010` SPLITS the Canonical Sink Inventory completeness claim:

- **(i) SERVER/CONFIG echoes: COMPLETE** for the 11 changed `src` files, verified by a MECHANICAL
  whole-file sweep (306 grep hits reduced to 97 interpolating sites; table in
  `FIX-P5-010-spec-delta.md`). All 46 unsanitized SERVER/CONFIG sites are now listed in
  inventory group `(b)`, with new items `(b)25`-`(b)32`.
- **(ii) USER-typed echoes: explicitly NON-EXHAUSTIVE** (self-injection); `SEC6-003`
  (`ERROR-FORMATTER-SANITIZE-CHOKEPOINT`) is the systematic fix.
- Product-repo side: the `P9-002` rustdoc fix plus a `CR9-002` check.
- Spec `2.8.6` (`BC-7.1.006` v1.7.6).
- Delivery: worktree `.worktrees/FIX-P5-010`, branch `fix/fix-p5-010-pass9-findings`, base
  `f72255cd`. Then PR -> human merge -> post-merge spec sync -> Pass 10.

## Lesson

Any "complete" / "only" / "every" claim must be MECHANICALLY verified (a whole-file sweep with a
recorded method) BEFORE it is made. A diff-driven audit cannot support a completeness claim about
whole files. Recorded in `sidecar-learning.md`.

## Product-owner spec work (uncommitted, committed with this burst)

`specs/prd/bc-7-output-render.md` (`BC-7.1.006` v1.7.6); `spec-changelog.md` `[2.8.6]`;
`cycles/cycle-014/phase-f5-adversarial/FIX-P5-010-spec-delta.md`; plus hook-stamped files.

## Pass Budget

Cap 15; 9 used; 6 remain (10-15). 3 consecutive clean are needed, so at most 3 more non-clean
passes can occur before convergence becomes impossible; escalate to the human at that point.

## Status

Pass 9 is **NOT CLEAN**. Clean-pass counter **0/3** (cap 15; 9 used).
