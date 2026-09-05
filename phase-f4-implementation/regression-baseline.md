# Cycle-004 Phase F4 — Pre-Implementation Regression Baseline

## Context

- **Purpose:** Establish the regression contract that all Phase F4 (delta implementation) work must not break, before creating the Wave 1 story worktrees.
- **Repo:** `jira-cli` (`jr`)
- **Branch:** `develop`
- **Commit SHA:** `42e92b46` (full: `42e92b464201a9d3def2b8c1f6a14668c3dc7ab5`)
- **Working tree state:** Clean with respect to `src/`, `tests/`, `Cargo.toml`, `Cargo.lock` (verified via `git status --porcelain=v1 -- src tests Cargo.toml Cargo.lock` → empty output). The only untracked paths in the main repo tree were `.claude/hooks/`, `.claude/pr-reviews/`, `.claude/settings.local.json.bak`, `.claude/spec-config.json` — unrelated to source, not touched. The three known-dirty `.factory/` artifacts (`regression-state.json`, `sidecar-learning.md`, the `S-cycle3-env-tag` demo gif) live in the `.factory/` git worktree (orphan `factory-artifacts` branch), not the main repo tree, and are out of scope here.

## Build

- **Invocation:** `cargo build`
- **Result:** SUCCESS (exit 0)
- **Notes:** `Compiling jr v0.7.0-dev.4 (...)`, `Finished \`dev\` profile [unoptimized + debuginfo] target(s) in 13m 59s`. No warnings emitted.
- **Timestamp (UTC, build start):** 2026-09-04T21:32:21Z

## Test Suite

- **Invocation (exact):** `cargo test --workspace`
- **Timestamp (UTC, test run start):** recorded via `date -u +"%Y-%m-%dT%H:%M:%SZ" > /tmp/f4_test_start.txt` immediately preceding the run (same session as the build above; test run followed the build).
- **Result:** GREEN — 0 failures.

| Metric | Count |
|---|---|
| Test-result blocks (binaries + doc-tests) | 115 |
| Total tests (passed + failed + ignored) | 4920 |
| Passed | 4763 |
| Failed | **0** |
| Ignored | 157 |
| Measured (benchmarks) | 0 |
| Filtered out | 0 |

- No `FAILED`, `panicked`, or non-zero `failed` count appears anywhere in the full log across all 115 `test result:` blocks (unit tests, every `tests/*.rs` integration binary, and the 1 doc-test in `src/profile.rs`).
- Ignored tests are the expected gated categories per CLAUDE.md conventions: keyring-backend tests (`JR_RUN_KEYRING_TESTS=1` required), live-Jira E2E tests (`JR_RUN_E2E=1` required), OAuth integration tests (`JR_RUN_OAUTH_INTEGRATION=1` required), and platform-specific (`#[cfg(unix)]`) tests not applicable on this run's target.
- Full raw log preserved at `/tmp/f4_cargo_test_full.log` for this session (not committed; local scratch artifact).

## Lint — Clippy

- **Invocation (exact):** `cargo clippy -- -D warnings`
- **Timestamp (UTC, start):** recorded via `date -u +"%Y-%m-%dT%H:%M:%SZ" > /tmp/f4_clippy_start.txt` immediately preceding the run.
- **Result:** PASS (exit 0). `Checking jr v0.7.0-dev.4 (...)`, `Finished \`dev\` profile [unoptimized + debuginfo] target(s) in 1m 56s`. Zero warning lines in output.

## Format Check

- **Invocation (exact):** `cargo fmt --all -- --check`
- **Result:** PASS (exit 0). No diff output.

## Verdict

**BASELINE IS GREEN.** 0 failing tests, 0 clippy warnings, 0 fmt diffs, clean build. Phase F4 delta implementation may proceed on top of this commit (`42e92b46`) as the regression safety net.

## Wave 1 Worktrees (created after this GREEN baseline)

- `.worktrees/S-cycle4-dpapi-storage-fix` — branch `feat/cycle4-dpapi-storage-fix`, based off `develop` @ `42e92b46`
- `.worktrees/S-cycle4-cloud-id-correctness` — branch `feat/cycle4-cloud-id-correctness`, based off `develop` @ `42e92b46`

Both stories are file-disjoint per the Wave 1 schedule and are safe to implement in parallel.
