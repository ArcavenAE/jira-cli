---
baseline_sha: 45ddf7a
branch: develop
timestamp: 2026-06-19T02:41:46Z
phase: f4-step-1
---

# Phase F4 Regression Baseline

## Commit

SHA: `45ddf7a` — `chore(release): v0.6.0-dev.4`
Branch: `develop`
Recorded: 2026-06-19T02:41:46Z

## Test Results

| Scope | Passed | Failed | Ignored |
|---|---|---|---|
| Unit tests (lib) | 947 | 0 | 10 |
| Integration tests (tests/*) | 908 | 0 | 82 |
| **Total** | **1855** | **0** | **92** |

Exit code: 0 (all test result lines show `ok`)

Notable ignored tests are gated behind `JR_RUN_KEYRING_TESTS=1`, `JR_RUN_E2E=1`, or `JR_RUN_OAUTH_INTEGRATION=1` — none are structural failures.

## Lint / Format

| Check | Result |
|---|---|
| `cargo clippy -- -D warnings` | CLEAN (exit 0) |
| `cargo fmt --all -- --check` | CLEAN (exit 0, no output) |

## Contract

Post-implementation regression gate (Phase F4 Step 5) must show:
- Total passing >= 1855
- Failed = 0
- clippy clean
- fmt clean

Any regression against these numbers is a STOP condition before merge.

## Worktrees Created (Step 2a)

| Worktree path | Branch | Base SHA |
|---|---|---|
| `.worktrees/S-FORK-OPS-BACKFILL-1` | `feat/fork-ops-backfill-parity` | `45ddf7a` |
| `.worktrees/S-FORK-OPS-GITLEAKS-DOC-1` | `docs/gitleaks-disabled` | `45ddf7a` |
