# cycle-013 Wave-2 Integration Gate — Regression Report

**Scope:** Post-merge integration validation of the merged `develop` tip as an integrated
whole. cycle-013 landed the MSRV 1.85 → 1.88 bump plus a ~73-site `collapsible_if`
let-chain retrofit (PR #818 @ `29e2d362`), followed by a docs-only reconciliation
(PR #819 @ `cfe1dedc`). Both PRs passed CI individually under `strict: false` branch
protection (tested tree ≠ merged tree, per CLAUDE.md) — this gate re-validates the
actual merged tip.

**Commit under test:** `cfe1dedc1cea3ae313a539e9766c6f5ab04390b5`
(`docs(cycle13): reconcile docs to MSRV 1.88 (Wave-2 S3) (#819)`)
**Working tree:** clean (`git status --short -uno` empty) at gate start.
**Active toolchain:** rustc/cargo `1.98.1` (resolved via `rust-toolchain.toml`
`channel = "stable"`, unmodified). `rust-version` manifest floor: `1.88` (`Cargo.toml`).

## Results Summary

| # | Command | Result |
|---|---|---|
| 1 | `cargo build` | **PASS** |
| 2 | `cargo test` | **PASS** |
| 3 | `cargo clippy -- -D warnings` | **PASS** |
| 4 | `cargo fmt --all -- --check` | **PASS** |
| 5 | MSRV 1.88.0 floor build | **PASS** |

## 1. `cargo build` (debug)

**PASS.** Clean build, no warnings/errors.

```
Compiling jr v0.7.0-dev.6 (/Users/zious/Documents/GITHUB/jira-cli)
Finished `dev` profile [unoptimized + debuginfo] target(s) in 16m 55s
[exited with code 0]
```

## 2. `cargo test` (all: unit, integration, proptest, snapshots, doctests)

**PASS.**

- Test-result blocks: 127
- Total tests passed: **5271**
- Total tests failed: **0**
- `FAILED` occurrences: none
- Compiler `error` lines: none
- Compiler `warning` lines: none
- Doc-tests: 1 passed (`src/profile.rs - profile::Profile (line 52) - compile fail`), 0 failed
- Exit code: 0

No flaky/ignored-without-gate anomalies observed. All 127 test binaries (unit tests
across `src/`, integration suites under `tests/`, proptests, insta snapshot tests,
`tests/ci_gate_completeness.rs`, `tests/claude_md_citations.rs`, `tests/common/wf.rs`
inline tests covering the S-CIGATE-3 YAML-parser machinery, etc.) reported
`test result: ok.` with zero failures.

## 3. `cargo clippy -- -D warnings`

**PASS.** Zero-warning policy holds on the merged tip — this specifically validates
that PR #818's ~73-site `collapsible_if` let-chain retrofit did not leave any residual
`collapsible_if` (or other) lint under the 1.98.1 clippy used by the active toolchain.

```
Finished `dev` profile [unoptimized + debuginfo] target(s) in 3m 33s
```
Warning count: 0. Error count: 0. Exit code: 0.

## 4. `cargo fmt --all -- --check`

**PASS.** No formatting diffs. Exit code: 0.

## 5. MSRV 1.88.0 floor confirmation

`rust-toolchain.toml` pins `channel = "stable"` (not altered, per task instructions) —
the default local/CI build floats to whatever `stable` currently resolves to (1.98.1
here), which does **not** by itself prove the `rust-version = "1.88"` floor still holds.
To validate the actual floor, ran the same shape of check the CI `msrv` job performs
(widened to `--all-targets` since the cycle-013 MSRV-1.88 bump, per CLAUDE.md Gotchas):

```
RUSTUP_TOOLCHAIN=1.88.0 cargo +1.88.0 check --all-targets
Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.55s
[exited with code 0]
```

0 errors, 0 warnings. Note: the 1.88.0 toolchain was already installed locally
(`rustup toolchain list` showed `1.88.0-aarch64-apple-darwin`) and this run completed
in 0.55s with no `Compiling`/`Checking` lines — i.e. cargo's fingerprint cache
determined the existing 1.88.0-toolchain build artifacts for this exact (clean,
unmodified) source tree were already up to date, so it reused them rather than
recompiling from scratch. This is a valid cache-hit confirmation (fingerprinting is
keyed to rustc version + source content), not a skipped check — no source files
changed since git status was clean throughout. If a from-scratch confirmation is
required, invalidate the cache (`cargo +1.88.0 clean` or a fresh target dir) and rerun.

Both the `with:` toolchain-install input and the `RUSTUP_TOOLCHAIN` env override
documented in CLAUDE.md's msrv Gotcha were honored (`RUSTUP_TOOLCHAIN=1.88.0` set
explicitly on the check command, `+1.88.0` toolchain override on the cargo invocation)
to avoid the `rust-toolchain.toml`-outranks-`rustup default` silent-stable-validation
pitfall described there.

## Findings

No failures, no warnings, no lint violations, no formatting drift, no MSRV-floor
regressions found on the merged `develop` tip at `cfe1dedc`. The integration gate
found the combination of PR #818 (MSRV bump + let-chain retrofit) and PR #819
(docs reconciliation) to be clean as merged — no interaction defects between the two
changes that individual per-PR CI runs (under `strict: false`) would have missed.

No fixes were made — this is a gate-check-only run per task instructions.

## GATE: PASS
