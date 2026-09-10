# PR #795 — Fresh-Eyes Review (Fix-PR Gate)

**Branch:** `fix/cycle5-mention-boundary-f5` → `develop`
**Scope:** cycle-005 Phase-F5 fix — F-M1 (spec-fidelity/regression), F-L1 (dead-code cleanup), CLAUDE.md gotcha.

## Verdict: APPROVE

No blocking findings. The diff correctly and completely fixes F-M1 without over-narrowing; the bracket-form path is unaffected.

## What was verified (against the PR-branch source, not just the base working tree)

- **Char sets:** `is_mention_boundary` (src/adf.rs:569) retains its full set `whitespace | * _ ~ ( [ ] \` (still includes `]`). New `is_at_name_boundary` (src/adf.rs:596) is that set **minus `]`** — `whitespace | * _ ~ ( [ \`. Exactly the intended narrowing.
- **Bracket-form path unaffected:** the only bracket boundary check is `protect_bracket_mentions` (src/adf.rs:712), which still calls `is_mention_boundary` on RAW markdown. `scan_mention_spans`'s bracket branch matches `BRACKET_SENTINEL_OPEN` (inserted pre-parse), never a raw `]`. The `]` admission needed for adjacent brackets `[~accountid:a][~accountid:b]` lives entirely in the untouched pre-parse pass.
- **Only the `@Name` branch changed** (src/adf.rs:917), the single shared detection grammar used by BOTH the collect-only walk (`find_mention_candidates`) and the emit/mutate walk — so candidate collection and conversion stay consistent. Correct single-source-of-truth location.
- **No over-narrowing:** `is_at_name_boundary` still admits whitespace, `(`, `[`, `*_~`, `\`, so a genuine `@Name` after every sanctioned boundary is still detected. A literal `]` before `@` can only occur post-parse in ordinary unmatched-bracket prose (bracket mentions are sentinels by then), so no legitimate `@Name`-after-`]` case is lost.
- **Tests hit the changed code:** `at_name_candidates` routes through `find_mention_candidates` → `scan_mention_spans` → `is_at_name_boundary`. RED-proven `test_f_m1_at_name_after_bracket_close_is_not_a_candidate` (`config[env]@home`, `array[i]@ts` → empty) exercises the fix directly. `test_f_m1_adjacent_bracket_mentions_still_both_convert_regression` guards the bracket path. `test_f_m1_at_name_after_sanctioned_boundaries_still_detected` guards against over-narrowing.
- **F-L1 clean & safe:** zero `allow(dead_code)` remain in adf.rs (complete sweep). `src/cli/issue/mentions.rs::resolve_mentions` calls `adf::find_mention_candidates(text)?` and consumes both `MentionCandidateKind` arms — API genuinely live. clippy `-D warnings` clean (orchestrator-verified) is authoritative that none of the four un-allowed items is dead.
- **Citations:** new CLAUDE.md bullet cites `src/adf.rs`, `src/cli/issue/mentions.rs` (both exist on branch) + qualitative BC/EC IDs; no numeric test counts, no dead paths. `tests/claude_md_citations.rs` rides the passing `test` job.

## Findings

| Severity | Category | File | Finding | Suggestion |
|----------|----------|------|---------|------------|
| nit | coverage | src/adf.rs (`test_f_m1_at_name_after_sanctioned_boundaries_still_detected`) | Comment claims coverage of the `(` boundary, but `(cc @jsmith)` actually exercises the *whitespace* boundary (`@` follows a space, not `(`). | Optional: add a direct `(@jsmith)` assertion to match the comment. Not a correctness gap — `(` is unchanged from `is_mention_boundary` and covered by pre-existing EC tests. |

## Test Evidence (orchestrator-verified, relied upon)

- Full `cargo test`: 121/121 suites, 0 failures
- `cargo clippy -- -D warnings`: clean
- `cargo fmt --all -- --check`: clean
- 3 new regression tests incl. RED-proven `test_f_m1_at_name_after_bracket_close_is_not_a_candidate`

Ready to merge from a fresh-eyes standpoint.
