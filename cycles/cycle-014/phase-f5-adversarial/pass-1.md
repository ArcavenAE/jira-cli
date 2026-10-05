# F5 Scoped Adversarial — Pass 1

- **Cycle:** cycle-014 (`issue-triage-quickfixes`)
- **Phase:** F5 scoped adversarial review (the delta loop resumed after `FIX-P5-001`/PR #891
  merged)
- **Scope:** `git diff 204b1fb5..769365ab` — the combined cycle-014 delta (STORY-A PR #886,
  STORY-C PR #887, STORY-B PR #888, `FIX-P5-001` PR #891), re-reviewed from fresh context after
  `FIX-P5-001`'s own PR-review/security-review rounds (`D-393`/`D-394`/`D-395`) had already closed.
- **Reviewers dispatched (3, fresh context, no visibility into each other's output):** adversary,
  code-reviewer, security-reviewer.
- **Date:** 2026-10-01
- **Convergence counter:** **0 of 3** (this pass is NOT CLEAN — the counter does not advance).
- **Pass verdict:** **NOT CLEAN — FINDINGS_PRESENT.**

## Reviewer Verdicts

| Reviewer | Verdict | Findings |
|---|---|---|
| **adversary** | FINDINGS_PRESENT | 6 findings (`F-001`..`F-006`, severities MEDIUM/MEDIUM/LOW/LOW/LOW/NIT) + 1 process-gap observation |
| **code-reviewer** | APPROVE, with items | 8 items (`CR-1`..`CR-8`): 2 SHOULD-FIX (`CR-1`, `CR-2`), 6 NIT (`CR-3`..`CR-8`) |
| **security-reviewer** | APPROVE | 0 new findings |

## Findings and Dispositions

All findings target `BC-7.1.006`/`VP-SEC-001-001` (`specs/prd/bc-7-output-render.md`), the same
BC `FIX-P5-001` landed at spec `v2.5.5`. Human decision **`D-396`** (2026-10-01) scoped a new fix
task, **`FIX-P5-002`**, to a subset of this pass's findings; the rest are tracked as follow-ups,
not fixed in-cycle.

### adversary findings

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `F-001` | MEDIUM | Caller-list error: `D-395`'s text (carried into `BC-7.1.006` v2.5.5) cites `jr issue edit --assignee`, but `IssueCommand::Edit` has no assignee-setting flag of any kind; the caller list also omitted `jr issue list --reporter` (`resolve_user` is called from both `--assignee` and `--reporter`). | **FIXED in `FIX-P5-002`.** Spec-corrected at `v2.5.6` (H1, `disambiguate_user` Behavior subsection, Out-of-scope lead, `**Trace**`, VP(c)) — no code change needed, the underlying 4 callers were already correct, only their names in prose were wrong. |
| `F-002` | MEDIUM | VP(c)/EC-16 test-coverage claims were overstated — tests the spec implied existed had not actually been written, and a claimed "one shared assertion helper" does not exist in `tests/table_output_sanitization.rs`. | **FIXED in `FIX-P5-002`** (spec-level correction; the 5 newly-named test targets are a `FIX-P5-002` implementation obligation, landed this burst — see Implementation Facts below). "Shared assertion helper" claim removed from the spec. |
| `F-003` | LOW | New residual: `src/cli/issue/create.rs::handle_create`'s `--to` field-echo loop (~L448) echoes the raw, unsanitized assignee `display_name`/`resolved_team_name` — same exposure class as the now-covered `handle_assign` sink. | **TRACKED, not fixed.** New Out-of-scope residual in `BC-7.1.006` v2.5.6; standing item `CREATE-TO-ECHO-SANITIZE` recorded in `cycles/OPEN-STANDING-ITEMS.md`. |
| `F-004` | LOW | `jr api` passthrough's raw, unsanitized stdout write is undocumented as a deliberate exception. | **FIXED in `FIX-P5-002`.** Documented as an explicit, permanent exception (`gh api` parity) in `BC-7.1.006` v2.5.6. |
| `F-005` | LOW | EC-16a's claim that the `Ambiguous` picker/message "still distinguishes the two accounts by their email/account-id fields" even when display names collide is FALSE — the `Ambiguous` arm carries `display_name` only. | **RETRACTED in `FIX-P5-002`** (spec correction — EC-16a's false claim removed). The underlying limitation itself is **TRACKED, not fixed**: standing item `AMBIGUOUS-PICKER-ACCOUNT-LABELS` recorded in `cycles/OPEN-STANDING-ITEMS.md`. |
| `F-006` | NIT | Imprecise `CLICOLOR_FORCE` wording in the Active-column color-behavior description. | **FIXED in `FIX-P5-002`.** Precise wording landed at `v2.5.6`, folded into the `CR-2` subsection. |
| `[process-gap]` | — | `FIX-P5-001` (a fix PR that grew scope 3 times) had no per-story adversary-convergence record of its own, which is why `F-001`/`F-002`'s doc/test drift escaped detection until this pass. | **RECORDED**, not a code/spec fix. `cycles/cycle-014/process-gaps.md` item `#46` — recommends extending Step-4.5-style adversary convergence (BC-5.39.001) to fix PRs delivered via `fix-pr-delivery`. |

### code-reviewer items

| ID | Tier | Finding | Disposition |
|---|---|---|---|
| `CR-1` | SHOULD-FIX | Single-line sinks (`handle_comment_view`'s labeled fields, `handle_assign`'s messages, `disambiguate_user`'s non-interactive messages/interactive picker labels) never neutralize an embedded `\n` — `sanitize_table_cell`/`sanitize_terminal_text` preserve `\n` by design, which is correct for genuinely multi-line sinks but lets a hostile value fabricate an extra line/field/picker item in a sink meant to render exactly one line (CWE-116). | **FIXED in `FIX-P5-002`.** New function `output::sanitize_terminal_line` (identical policy to `sanitize_table_cell` except `\n` -> single space); re-routed the named sinks. New `EC-17` (two parts, before/after contrast). Implemented and pushed this burst (see Implementation Facts). |
| `CR-2` | SHOULD-FIX | `--no-color`/`NO_COLOR` gating for `StyledCell`'s `fg` was caller-side only (`active_cell`'s own check) — `output::render_table_with_styles` itself applied `fg` unconditionally, leaving every FUTURE `StyledCell` caller to remember to re-implement the same check. | **FIXED in `FIX-P5-002`, human decision `D-396` ("move the `--no-color` check into the styled-table API").** `render_table_with_styles` now gates every `StyledCell`'s `fg` on `colored::control::SHOULD_COLORIZE.should_colorize()` structurally; `active_cell`'s own check is kept (redundant, harmless). Two new tests. Implemented and pushed this burst. |
| `CR-3`..`CR-8` | NIT (6 items) | Naming/doc-comment/test-organization-level suggestions on the `sanitize_table_cell`/`sanitize_terminal_text`/`disambiguate_user` cluster; none behavior-affecting. | **TRACKED, not fixed.** Bundled as one standing item, `OUTPUT-SANITIZER-CLEANUP-NITS`, in `cycles/OPEN-STANDING-ITEMS.md`. Full `CR-1`..`CR-8` list: `code-delivery/FIX-P5-001/review-summary.md`. |

### security-reviewer

No new findings. APPROVE — confirms `FIX-P5-001`'s shipped sanitization (`sanitize_table_cell`/
`sanitize_terminal_text`) introduces no new vulnerability class; the gaps it did flag (single-line
`\n` injection, structural color-gate) are the same ones the adversary/code-reviewer independently
surfaced as `CR-1`/`CR-2` above, not a fourth, distinct finding.

## Human Decision `D-396` (2026-10-01)

**`FIX-P5-002` covers:** `F-001`, `F-002`, `F-004`, `F-005` (the retraction, not the underlying
limitation), `F-006`, `CR-1`, `CR-2`.

**Tracked as follow-ups, NOT fixed in `FIX-P5-002`:** `F-003` (`CREATE-TO-ECHO-SANITIZE`), the
underlying limitation behind `F-005` (`AMBIGUOUS-PICKER-ACCOUNT-LABELS`), `CR-3`..`CR-8`
(`OUTPUT-SANITIZER-CLEANUP-NITS`). All three recorded as new standing items in
`cycles/OPEN-STANDING-ITEMS.md`.

## Spec Delta

`BC-7.1.006`/`VP-SEC-001-001` amended in place, spec `v2.5.5 -> v2.5.6` (PATCH — no new BC/VP ID).
Full delta: `cycles/cycle-014/phase-f5-adversarial/FIX-P5-002-spec-delta.md`. BC count unchanged
(773 cumulative, 98/54 in bc-7); VP count unchanged (98). [CORRECTED 2026-10-05, F7C1-001: 98 was correct at this point; the cycle-014 total later became 100 via VP-SEC-001-002/003.] All 4 spec-guard scripts
(`check-spec-counts.sh`, `check-bc-cumulative-counts.sh`, `check-bc-citation-symbols.sh`,
`check-bc-no-numeric-test-counts.sh`) re-run and PASS.

## Implementation Facts (FIX-P5-002, this burst)

Branch `fix/FIX-P5-002`, pushed, HEAD `3ef98c15`. 4 commits: `2e1f5d20` (refactor stub +
`render_table_with_styles_inner` test seam), `df79e4e9` (RED tests), `8f206627` (fix —
`sanitize_terminal_line` + structural `SHOULD_COLORIZE` gate), `3ef98c15` (docs — BC coverage
correction). Verified: lib 1,604 passed; full suite green; clippy and fmt clean. Demo evidence (16
files: 4 ACs x `.gif`/`.tape`/`.webm` + `evidence-report.md`/`mock_server.py`/`setup.sh`/`fixtures/`)
copied from `.worktrees/FIX-P5-002/docs/demo-evidence/FIX-P5-002/` to `.factory/demos/FIX-P5-002/`,
counts verified matching (16/16).

## Conclusion

**Pass 1: NOT CLEAN.** Clean-pass counter stays at **0/3** — a NOT-CLEAN pass does not advance the
counter and the next pass must restart the count from a fresh clean result, per the standard
3-consecutive-clean convergence rule. `FIX-P5-002` (the fix task `D-396` routed) is implemented and
pushed as of this burst, but NOT yet merged. **NEXT:** `pr-manager` takes `FIX-P5-002`'s PR to
merge-ready (`pr-reviewer` + security review) -> human merges -> worktree cleanup -> **Pass 2**:
resume the F5 delta adversarial loop (fresh adversary + code-reviewer + security-reviewer context)
over `204b1fb5..<new develop HEAD after FIX-P5-002 merges>`.
