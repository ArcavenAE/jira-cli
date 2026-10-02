# F5 Scoped Adversarial — Pass 6

- **Cycle:** cycle-014 (`issue-triage-quickfixes`)
- **Phase:** F5 scoped adversarial review (delta loop resumed after `FIX-P5-006`/PR #898 merged)
- **Scope:** `git diff 204b1fb5..ce6be7ad` — the combined cycle-014 delta (STORY-A PR #886,
  STORY-C PR #887, STORY-B PR #888, `FIX-P5-001` PR #891, `FIX-P5-002` PR #894,
  `FIX-P5-003` PR #895, `FIX-P5-004` PR #896, `FIX-P5-005` PR #897, `FIX-P5-006` PR #898),
  re-reviewed from fresh context.
- **Reviewers dispatched (3, fresh context):** adversary, code-reviewer, security-reviewer.
- **Date:** 2026-10-02
- **Convergence counter:** **0 of 3** (NOT CLEAN — counter does not advance). 6 of 10 passes used.
- **Pass verdict:** **NOT CLEAN — FINDINGS_PRESENT** (adversary, 4 LOW). Code-reviewer and
  security-reviewer both returned APPROVE.
- **Novelty assessment:** LOW. Adversary's note: "code has converged; remaining items are
  doc/spec/test-hygiene propagation gaps".

## Reviewer Verdicts

| Reviewer | Verdict | Findings |
|---|---|---|
| **adversary** | FINDINGS_PRESENT | `P6-001`..`P6-004` LOW |
| **code-reviewer** | APPROVE | `CR6-001`, `CR6-002` NIT |
| **security-reviewer** | APPROVE | `SEC6-001`..`SEC6-003` LOW |

## Findings and Dispositions

### adversary findings

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `P6-001` | LOW | Spec contradiction: "exact ID match never ambiguous" vs `EC-X.14.001-21`. | `FIX-P5-007` (spec delta already authored) |
| `P6-002` | LOW | Stale CLAUDE.md `output.rs` LOC (2,102 claimed vs 2,111 actual; orchestrator verified). | `FIX-P5-007` (approximate "~N LOC" convention; removes the drift source) |
| `P6-003` | LOW | Coverage claims say "three non-table sites", but `search_field_list` is a fourth. | `FIX-P5-007` (single Canonical Sink Inventory) |
| `P6-004` | LOW [process-gap] | `tests/field_options.rs` `Harness` is not hermetic for the M2/M3 exit-64 tests. | `FIX-P5-007` |

### code-reviewer findings (pass 6)

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `CR6-001` | NIT | Same as `P6-002`. | `FIX-P5-007` (merged with `P6-002`) |
| `CR6-002` | NIT | `resolve_field_id` not-found error echoes the raw query, inconsistent with the stated intent. | `FIX-P5-007` |

### security-reviewer findings (pass 6)

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `SEC6-001` | LOW | Invisible non-`Cf` characters. Mostly already-accepted `EC-23`/`EC-24`; only U+2065 (unassigned, `Cn`) is new. | ACCEPTED RESIDUAL — U+2065 added to `BC-7.1.006` `EC-24` (spec delta); no code change. |
| `SEC6-002` | LOW | Server `field_id` echoed raw in three "not available" errors (`field.rs`). | `FIX-P5-007` |
| `SEC6-003` | LOW | Config/input-sourced echoes (`project_key`, `type_name`/`rt_query`, `disambiguate_user` name). Reviewer suggested one `main.rs` error-formatter chokepoint. | DEFERRED (`D-401(b)`) — follow-up, tracked as `ERROR-FORMATTER-SANITIZE-CHOKEPOINT` in `cycles/OPEN-STANDING-ITEMS.md` |

## Orchestrator Analysis

Since Pass 3 every finding has been doc drift, and much of it was reintroduced by our own
fixes: exact LOC figures in CLAUDE.md and duplicated sink inventories (prose, rustdoc, CLAUDE.md)
that each fix has to update in lockstep. The fix for the class, not the instance, is to remove
the drift sources (see `D-401(a)`).

## `FIX-P5-007` Scope (DECIDED 2026-10-02, `D-401`, human)

- **(a)** `FIX-P5-007` fixes `P6-001`..`P6-004`, `SEC6-002` and `CR6-002`, AND removes the drift
  sources:
  - CLAUDE.md size-deviation entries become approximate "~N LOC", with no exact line numbers;
  - `BC-7.1.006` gets a single "Canonical Sink Inventory" (covered + residual);
  - rustdoc and CLAUDE.md point to it instead of duplicating it;
  - older duplicate membership prose in `BC-7.1.006` is trimmed to rules.
- **(b)** `SEC6-003` is DEFERRED to a follow-up: a single error-formatter sanitization chokepoint
  in `main.rs` (human stderr + JSON `"error"`, preserving `\n`), which would retire most
  `JrError`-body residuals. Deferred because it changes all error rendering and is out of scope
  for this quick-fix cycle at a tight pass budget. Recorded as an OPEN-STANDING-ITEMS entry
  (not a STORY-INDEX draft; see the burst log for the rationale).

Spec delta (committed with this burst): `FIX-P5-007-spec-delta.md`, `BC-7.1.006` v1.7.0
(Canonical Sink Inventory, trimmed membership prose, `EC-24` U+2065), `cross-cutting.md`
(`EC-X.14.004-10`, `P6-001` fixes, `BC-X.14.004` Preconditions), spec-changelog `[2.8.0]`.
Delivery: worktree `.worktrees/FIX-P5-007`, branch `fix/fix-p5-007-pass6-findings`, base
`ce6be7ad`. After merge: post-merge spec conversion, then Pass 7.

## Pass Budget

4 passes remain (7–10) and 3 consecutive clean passes are needed, so at most ONE more slip.
If the 10-pass cap is reached without convergence, escalate to the human per the F5 rules.

## Status

Pass 6 is **NOT CLEAN**. Clean-pass counter **0/3** (10-pass cap; 6 used).
