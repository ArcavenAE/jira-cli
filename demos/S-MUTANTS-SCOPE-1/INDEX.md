# Demo Evidence Index — S-MUTANTS-SCOPE-1

Close the `queue.rs`/`main.rs` mutation-scope false-green: add both files to
`.cargo/mutants.toml::examine_globs`, extract `run_until_shutdown` from
`src/main.rs`'s Ctrl+C/SIGINT fork behind a stable boundary contract, and
land the VP-MUTANTS-SCOPE-1-001/002 test pair.

This is an infrastructure / mutation-scope / behavior-preserving-refactor
story, not a user-facing CLI feature — there is no new command, flag, or
output shape to screen-record. Per project precedent (`S-693-1`'s
`demo-transcript.md`, `S-627-1`'s `--self-test` evidence), the correct demo
artifact is a **transcript of real command output**, driving the actual
compiled binary and the actual `cargo`/`cargo-mutants`/shell tooling — not a
VHS/Playwright recording, which would add no evidentiary value over the text
below.

## Artifacts in this directory

- **`demo-transcript.md`** — the full evidence transcript: mutation-testing
  result (AC-005), a real terminal SIGINT demo against the debug binary
  (AC-006/007/009/010), and passing guard/test output (AC-002/003/008/009/
  010/011/014).

## What each piece of evidence proves

| # | Evidence | Command | ACs | BC | Result |
|---|---|---|---|---|---|
| 1 | Mutation false-green closed | `cargo mutants --in-diff <diff> --jobs 4 --timeout 240` | AC-005 | drift item `MUTANTS-SCOPE-GAP-QUEUE-MAIN` | caught=3, missed=0, unviable=4, timeout=0 (7 mutants total). Before this story: `Found 0 mutants to test` for the identical diff shape — the silent false-green that let PRs #696/#698/#700 merge unchecked. |
| 2 | Real SIGINT → `"\nInterrupted"` → exit 130 | Backgrounded `JR_TEST_BLOCK_UNTIL_SIGINT=1 ./target/debug/jr me`, readiness-polled, `kill -INT` | AC-006, AC-007, AC-010 | BC-X.3.006 Behavior items 1–2, EC-1 | Exit code `130`; stderr byte-exact `0a 49 6e 74 65 72 72 75 70 74 65 64 0a` = `"\nInterrupted\n"`; signal sent only after the `JR-TEST-READY` marker appeared (10 polls, ~500ms) — no fixed sleep. |
| 3 | Out-of-process SIGINT test | `cargo test --test interrupt_signal` | AC-009, AC-010, AC-011 | BC-X.3.006 VP-MUTANTS-SCOPE-1-001 | 1 passed. |
| 4 | Seam release-gate pin | `cargo test --test jr_test_block_until_sigint_release_gate` | AC-010 | BC-X.3.006 EC-1 mitigation | 1 passed — confirms `#[cfg(debug_assertions)]` sits within 5 lines of the `JR_TEST_BLOCK_UNTIL_SIGINT` read in `src/main.rs`. |
| 5 | Policy-doc citation guard | `scripts/check-cargo-mutants-policy-citations.sh` | AC-002, AC-003, AC-014 | — (doc governance only) | `Check passed: 18 bullets parsed, 52 (file, fn) pairs validated` — 0 offenders, matches the delegation's expected bar exactly. |
| 6 (bonus) | Portable, non-signal `run_until_shutdown` coverage | `cargo test --bin jr run_until_shutdown` | AC-006, AC-008 | BC-X.3.006 VP-MUTANTS-SCOPE-1-002 | 2 passed — both `RunOutcome::Completed`/`RunOutcome::Interrupted` arms. |

## Not captured here

AC-001/AC-004 (`.cargo/mutants.toml` diff content and
`tests/mutants_glob_existence.rs`) and AC-012/AC-013 (no-other-behavior-
changed / human-decision-recorded) are documentation-content assertions
already visible in the `git diff` reproduced in `demo-transcript.md` §1 —
no separate runtime evidence was generated for them. AC-011's clippy
dead-code check on `#[cfg(unix)]` helpers under a non-Unix target build was
not re-run in this session (this worktree is macOS/Unix; that check is a
build-time compiler assertion, not a runtime demo).

## Provenance

- Worktree: `/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-MUTANTS-SCOPE-1`
- Branch: `test/mutants-scope-queue-main`
- HEAD at recording time: `c0fa930c`
- `git status`: clean before and after this recording session; only files
  under `.factory/demos/S-MUTANTS-SCOPE-1/` were written.
