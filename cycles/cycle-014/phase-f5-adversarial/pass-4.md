# F5 Scoped Adversarial — Pass 4

- **Cycle:** cycle-014 (`issue-triage-quickfixes`)
- **Phase:** F5 scoped adversarial review (delta loop resumed after `FIX-P5-004`/PR #896 merged)
- **Scope:** `git diff 204b1fb5..6cece14b` — the combined cycle-014 delta (STORY-A PR #886,
  STORY-C PR #887, STORY-B PR #888, `FIX-P5-001` PR #891, `FIX-P5-002` PR #894,
  `FIX-P5-003` PR #895, `FIX-P5-004` PR #896), re-reviewed from fresh context.
- **Reviewers dispatched (3, fresh context):** adversary, code-reviewer, security-reviewer.
- **Date:** 2026-10-01
- **Convergence counter:** **0 of 3** (NOT CLEAN — counter does not advance). 4 of 10 passes used.
- **Pass verdict:** **NOT CLEAN — FINDINGS_PRESENT** (adversary). Code-reviewer and
  security-reviewer both returned APPROVE.
- **Novelty assessment:** LOW — documentation drift plus one recurring policy theme
  (invisible/format characters, now resolved at the policy level by `D-399`).

## Reviewer Verdicts

| Reviewer | Verdict | Findings |
|---|---|---|
| **adversary** | FINDINGS_PRESENT | `P4-001`..`P4-003` LOW, `P4-004`..`P4-007` NIT |
| **code-reviewer** | APPROVE | `CR4-001`/`CR4-002` SHOULD-FIX, `CR4-003`/`CR4-004` NIT, `CR4-005` known |
| **security-reviewer** | APPROVE | `SEC4-001`/`SEC4-002` LOW |

## Findings and Dispositions

### adversary findings

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `P4-001` | LOW | CHANGELOG `[Unreleased]` earlier Security bullets say single-line sinks use `sanitize_terminal_text`, contradicting the `CR-1` bullet. | `FIX-P5-005` (`D-399`) |
| `P4-002` | LOW | `cargo-mutants-policy.md`'s 2026-08-21 S-575-1 history row was rewritten to `:393`; it should stay `:374` (historical). | `FIX-P5-005` (merged with `CR4-004`) |
| `P4-003` | LOW | The invisible-character set misses same-class characters (variation selectors, CGJ, soft hyphen, U+180E, Hangul fillers). | `FIX-P5-005`: principled Cf policy per `D-399` (`BC-7.1.006` v1.6.0 `EC-21`/`EC-22`/`EC-23`) |
| `P4-004` | NIT | TTY-under-`cargo test` rustdoc is wrong. | `FIX-P5-005` |
| `P4-005` | NIT | The `hermetic_helper` trim test is tautological. | `FIX-P5-005` |
| `P4-006` | NIT | `sanitize_control_and_ansi_core` rustdoc says "both" sanitizers. | `FIX-P5-005` |
| `P4-007` | NIT | Stale test comment. | `FIX-P5-005` |

### code-reviewer findings (pass 4)

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `CR4-001` | SHOULD-FIX | Same class as `P4-003`, plus U+206A..=206F. | `FIX-P5-005` (merged with `P4-003`) |
| `CR4-002` | SHOULD-FIX | `jr field options` cannot resolve system field IDs (`issuetype` -> not found) despite the help/README "custom or system fields" wording added in #861. Orchestrator-verified in `src/cli/field.rs::resolve_field_id`/`search_field_list`. | `FIX-P5-005`: `BC-X.14.001`/`BC-X.14.004` amended (spec 2.7.0) |
| `CR4-003` | NIT | Misplaced doc comment in `helpers.rs` tests. | `FIX-P5-005` |
| `CR4-004` | NIT | Same as `P4-002`. | `FIX-P5-005` (merged with `P4-002`) |
| `CR4-005` | NOTE | Known `SANITIZE-ENV-DISPLAY-C1-GAP`. | Already tracked; no new action. |

### security-reviewer findings (pass 4)

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `SEC4-001` | LOW | U+2065 / U+206A..=206F gap in the invisible-character set. | `FIX-P5-005` (covered by the full-Cf policy, `D-399`) |
| `SEC4-002` | LOW | The env-display sanitizer (`strip_control_and_ansi`) lacks the invisible-char stripping. | Folded into `SANITIZE-ENV-DISPLAY-C1-GAP` with a note (`cycles/OPEN-STANDING-ITEMS.md`); no code change in `FIX-P5-005`. |

## `FIX-P5-005` Scope (DECIDED 2026-10-01, `D-399`)

Human decision `D-399`:

- **(a) Invisible-character policy is now principled.** Strip ALL Unicode 17.0.0
  `General_Category=Cf`, plus U+034F and the Hangul fillers U+115F/U+1160/U+3164/U+FFA0.
  KEEP variation selectors (an accepted risk, `EC-23`, styled like `EC-20`). The full tag
  block stays stripped as a superset. Rationale: end the recurring per-pass invisible-char
  findings with one rule.
- **(b) Scope is ALL Pass 4 findings:** `CR4-002` system field IDs (`BC-X.14.001`/`004`
  amended), `P4-001`, `P4-002`/`CR4-004`, and all NITs.
- **(c) Orchestrator note:** the spec-proposed test
  `test_bc_7_1_006_cf_table_pinned_unicode_version_is_17` was intentionally NOT implemented.
  It would fail CI on any unpinned-stable Unicode bump, the same class as
  `CI-CLIPPY-TOOLCHAIN-PIN`. To be removed from the spec post-merge.

Spec delta (committed with this burst): `FIX-P5-005-spec-delta.md`, `BC-7.1.006` v1.6.0,
`BC-X.14.001`/`004` amended, spec-changelog `[2.7.0]`. Delivery: worktree
`.worktrees/FIX-P5-005`, branch `fix/fix-p5-005-pass4-findings`, base `6cece14b`. After merge:
post-merge spec conversion (`EC-21`/`22`/`23`, `VP-SEC-001-003`, `BC-X.14` ECs; drop the
pinned-unicode-version test target), then Pass 5.

## Status

Pass 4 is **NOT CLEAN**. Clean-pass counter **0/3** (10-pass cap; 4 used).
