# F5 Scoped Adversarial — Pass 2

- **Cycle:** cycle-014 (`issue-triage-quickfixes`)
- **Phase:** F5 scoped adversarial review (the delta loop resumed after `FIX-P5-002`/PR #894
  merged)
- **Scope:** `git diff 204b1fb5..cc19c2f9` — the combined cycle-014 delta (STORY-A PR #886,
  STORY-C PR #887, STORY-B PR #888, `FIX-P5-001` PR #891, `FIX-P5-002` PR #894), re-reviewed from
  fresh context after `FIX-P5-002`'s own PR-review/security-review rounds had already closed.
- **Reviewers dispatched (3, fresh context, no visibility into each other's output):** adversary,
  code-reviewer, security-reviewer.
- **Date:** 2026-10-01
- **Convergence counter:** **0 of 3** (this pass is NOT CLEAN — the counter does not advance).
- **Pass verdict:** **NOT CLEAN — FINDINGS_PRESENT.** Driven entirely by the adversary verdict;
  code-reviewer and security-reviewer both returned APPROVE.

## Reviewer Verdicts

| Reviewer | Verdict | Findings |
|---|---|---|
| **adversary** | FINDINGS_PRESENT | 5 findings (`P2-001`..`P2-005`, severities HIGH(doc-only)/MEDIUM/MEDIUM/LOW/LOW) + 1 NIT + 1 process-gap observation |
| **code-reviewer** | APPROVE, 0 blocking | 2 SHOULD-FIX (`CR2-1`, `CR2-2`) + 2 NIT (`CR2-N1`, `CR2-N2`) |
| **security-reviewer** | APPROVE | 0 new findings |

## Findings and Dispositions

All findings target the `FIX-P5-001`/`FIX-P5-002` output-sanitization cluster
(`src/output.rs`, `src/cli/user.rs`, `src/cli/issue/{interactions,workflow,helpers}.rs`,
`tests/table_output_sanitization.rs`) landed via `BC-7.1.006`/`VP-SEC-001-001`. None of these
findings are fixed in this burst — this burst only records them. The scope of a prospective fix
task, **`FIX-P5-003`**, is proposed below, pending a human decision.

### adversary findings

| ID | Severity | Finding | Notes |
|---|---|---|---|
| `P2-001` | HIGH, doc-only | `F-001` partial fix. `src/output.rs` ~L376-472 rustdoc still names `jr issue edit --assignee`, omits `--reporter`, says sinks use `sanitize_terminal_text` (false since `CR-1`), advises the next fixer to use `sanitize_terminal_text` (would reopen `CR-1`), and its residual list lacks `create.rs::create_echo` and `resolve_asset`. Also `tests/table_output_sanitization.rs` L29-35/L1141/L1145. | Doc-only — no behavior change implied, but actively misleading to a future fixer. |
| `P2-002` | MEDIUM | Test race: `TERMINAL_COLOR_OVERRIDE_LOCK` (`src/output.rs` ~L1583) and `COLOR_OVERRIDE_LOCK` (`src/cli/user.rs` ~L349) are separate mutexes guarding the same global `colored` override, so this can cause intermittent ci-gate false-reds. | Fix: one shared `pub(crate)` `cfg(test)` guard. Same underlying defect code-reviewer independently found as `CR2-2`. |
| `P2-003` | MEDIUM | The `BC-7.1.006` spec still says "NOT YET IMPLEMENTED" post-merge. | Being fixed in-flight by product-owner's post-#894 citation conversion (PARTIAL at wrap — see Session Resume Checkpoint). |
| `P2-004` | LOW | The `StyledCell::colored` rustdoc (`output.rs` ~L58-61) and the `render_table_with_styles` rustdoc don't reflect the `CR-2` structural gate. | Doc drift, same class as `P2-001`. |
| `P2-005` | LOW | `test_bc_7_1_006_render_table_with_styles_strips_hostile_colored_cell` assumes non-TTY stdout and fails under interactive `cargo test`. | Test-environment assumption bug. |
| `[NIT]` | NIT | The CLAUDE.md `output.rs` LOC figure is stale (1,671 total / 634 prod). | Cosmetic doc drift. |
| `[process-gap]` | — | No guard exists for post-merge "NOT YET IMPLEMENTED" spec qualifiers, and no grep-closure check for fix-propagation claims. | Recommends a spec-guard script addition at a future maintenance sweep. |

### code-reviewer findings (pass 2)

| ID | Severity | Finding | Notes |
|---|---|---|---|
| `CR2-1` | SHOULD-FIX | `sanitize_table_cell` and `sanitize_terminal_line` duplicate the per-char default policy (the `_` arms at `src/output.rs` ~L528-543 and ~L617-630). | Fix: extract a shared `classify_default_char`. Mitigated today by the equivalence proptests — not a correctness bug, a duplication risk. |
| `CR2-2` | SHOULD-FIX | The same test-lock race as adversary `P2-002` (two mutexes guarding the one `colored` global). | Fix: one shared `pub(crate)` `cfg(test)` lock — identical remedy to `P2-002`; a single `FIX-P5-003` change item closes both. |
| `CR2-N1` | NIT | The `active_cell` rustdoc (`src/cli/user.rs` ~L203-215) still calls its `SHOULD_COLORIZE` check "necessary, not redundant", which contradicts `CR-2` and the CHANGELOG. | Doc drift from the `CR-2`/`FIX-P5-002` behavior change. |
| `CR2-N2` | NIT | `src/output.rs` ~L568 says there is "exactly one sanitization implementation", which overstates it — only the CSI/OSC engine is shared. | Imprecise claim, same class as `CR2-N1`. |

## Proposed `FIX-P5-003` Scope (pending human decision)

Not yet decided. Proposed candidate scope, for the human to accept, trim, or expand:
`P2-001`, `P2-002`, `P2-003`, `P2-004`, `P2-005`, the CLAUDE.md LOC NIT, `CR2-1`, `CR2-2`,
`CR2-N1`, `CR2-N2`. `P2-002` and `CR2-2` describe the identical underlying defect (dual test-lock
mutexes) and would be closed by one change item, not two.

## Status at Wrap

All three pass-2 reviewers returned verdicts this burst — adversary FINDINGS_PRESENT,
code-reviewer APPROVE (0 blocking), security-reviewer APPROVE (0 new). No reviewer dispatch for
pass 2 remains outstanding. Pass 2 is **NOT CLEAN** solely on the adversary's verdict. Clean-pass
counter stays **0/3** (10-pass cap, F5 scoped-adversarial convergence rule). Pipeline is **PAUSED**
pending the human's `FIX-P5-003` scope decision; resume by dispatching the fix once scoped.
