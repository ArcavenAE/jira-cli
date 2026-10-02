# F5 Scoped Adversarial — Pass 7

- **Cycle:** cycle-014 (`issue-triage-quickfixes`)
- **Phase:** F5 scoped adversarial review (delta loop resumed after `FIX-P5-007`/PR #899 merged)
- **Scope:** `git diff 204b1fb5..ecbc5cda` — the combined cycle-014 delta (STORY-A PR #886,
  STORY-C PR #887, STORY-B PR #888, `FIX-P5-001` PR #891, `FIX-P5-002` PR #894,
  `FIX-P5-003` PR #895, `FIX-P5-004` PR #896, `FIX-P5-005` PR #897, `FIX-P5-006` PR #898,
  `FIX-P5-007` PR #899), re-reviewed from fresh context.
- **Reviewers dispatched (3, fresh context):** adversary, code-reviewer, security-reviewer.
- **Date:** 2026-10-02
- **Convergence counter:** **0 of 3** (NOT CLEAN — counter does not advance). 7 of 10 passes used.
- **Pass verdict:** **NOT CLEAN — FINDINGS_PRESENT** (adversary: 1 LOW + 3 NIT). Code-reviewer and
  security-reviewer both returned APPROVE.
- **Novelty assessment:** LOW. Adversary's note: "code delta converged at the code level;
  doc-precision only".

## Reviewer Verdicts

| Reviewer | Verdict | Findings |
|---|---|---|
| **adversary** | FINDINGS_PRESENT | `P7-001` LOW; `P7-002`..`P7-004` NIT |
| **code-reviewer** | APPROVE | `CR7-001`..`CR7-004` NIT |
| **security-reviewer** | APPROVE | none above INFO (1 INFO) |

## Findings and Dispositions

### adversary findings

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `P7-001` | LOW [process-gap] | `BC-X.7.002` still described `user_list_requires_project_flag`'s old loose assertion after `FIX-P5-006` strengthened it: a strengthened test was not propagated back to the BC prose describing it. | `FIX-P5-008` (`D-402`); process-gap `#52` |
| `P7-002` | NIT | "`strip_control_and_ansi` has no C1 handling" is wrong; it handles NEL. | `FIX-P5-008` (C1 wording fixed in the spec delta) |
| `P7-003` | NIT | The `cargo-mutants-policy` single/multi-line pairing is reversed. | `FIX-P5-008` |
| `P7-004` | NIT | The README says `jr api` ignores `--output`, but pre-flight errors honor `--output json`. | `FIX-P5-008` |

### code-reviewer findings (pass 7)

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `CR7-001` | NIT | Stale `hermetic.rs` header. | `FIX-P5-008` |
| `CR7-002` | NIT | `format_user_row_styled` column coupling. | `FIX-P5-008` |
| `CR7-003` | NIT | `search_field_list` redundant parameter plus eager sanitize. | `FIX-P5-008` |
| `CR7-004` | NIT | A `comfy_table`-only test. | `FIX-P5-008` |

The code-reviewer confirmed the approximate CLAUDE.md "~N LOC" entries match disk, so the
anti-drift measures introduced by `D-401(a)` worked.

### security-reviewer findings (pass 7)

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| (INFO) | INFO | The `issue_key` echo is not named in residual `b11` of the Canonical Sink Inventory. | `FIX-P5-008` (`issue_key` added to `b11`; spec delta) |

## Product-owner spec work (FIX-P5-008 spec delta)

While fixing `P7-001`, the product-owner audited EVERY spec test-assertion description
against the test bodies and found and fixed 7 mismatches:

- the three `user_list_requires_project_flag` descriptions;
- the `EC-X.14.004-9` / `EC-X.14.004-10` fixture descriptions;
- `VP-SEC-001-002`'s identity-collapse test description.

Spec delta (committed with this burst): `FIX-P5-008-spec-delta.md`, `BC-7.1.006` row 1.7.2
(`b11` `issue_key`, the C1 wording, the `VP-SEC-001-002` description),
`cross-cutting.md`, spec-changelog `[2.8.2]`.

## `FIX-P5-008` Scope (DECIDED 2026-10-02, `D-402`, human)

- `FIX-P5-008` fixes ALL Pass 7 items: `P7-001`..`P7-004`, `CR7-001`..`CR7-004`, and adds
  `issue_key` to `b11`.
- `FIX-P5-008` ALSO includes a full claim audit of this cycle's product-repo prose (README,
  CHANGELOG, CLAUDE.md, rustdoc, test docs) against the code.
- F5 continues under the **STRICT clean-pass rule**.
- Delivery: worktree `.worktrees/FIX-P5-008`, branch `fix/fix-p5-008-pass7-findings`, base
  `ecbc5cda`. After merge: post-merge spec conversion, then Pass 8.

## Pass Budget — ZERO SLACK

3 passes remain (8, 9, 10) and 3 consecutive clean passes are needed, so Passes 8, 9 and 10
must ALL be clean. **If Pass 8 is not clean, convergence within the 10-pass cap becomes
impossible, and the orchestrator stops and ESCALATES to the human rather than spending
Passes 9 and 10.**

## Status

Pass 7 is **NOT CLEAN**. Clean-pass counter **0/3** (10-pass cap; 7 used).
