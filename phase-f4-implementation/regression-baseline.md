# Cycle-007 Phase F4 — Pre-Implementation Regression Baseline (F4 Step 1)

## Context

- **Cycle:** cycle-007-auth-correctness-dx
- **Phase:** F4 Step 1 (regression baseline)
- **Runner:** `cargo test` (serial libtest — NOT nextest; see note below)
- **Repo:** `jira-cli` (`jr`)
- **Branch:** `develop`
- **Commit SHA (full):** `14e695aef0a553e01c63b45a95a4bef8b1b8f6bc`
- **Commit SHA (short):** `14e695ae`
- **Timestamp (UTC, run start):** 2026-09-11T16:17:00Z
- **Timestamp (UTC, run end):** 2026-09-11T17:52:00Z

> **Why `cargo test` (not nextest):** nextest's parallel `--list` binary-discovery phase
> mass-launches all 121 test binaries simultaneously, saturating macOS Gatekeeper
> (syspolicyd) at 57.7%+ CPU. A prior attempt (2026-09-11T16:02Z) stalled for >10 min
> with zero test completions. `cargo test` launches binaries serially (one at a time),
> keeping Gatekeeper pressure low. syspolicyd stayed at ≤28.6% CPU during this run and
> idled for most of it.

## Working Tree State

Clean with respect to tracked source files. `git status --porcelain` output:

```
?? .claude/hooks/
?? .claude/pr-reviews/
?? .claude/settings.local.json.bak
?? .claude/spec-config.json
```

No modified or staged tracked files. All untracked paths are `.claude/` tooling artifacts
unrelated to `src/`, `tests/`, `Cargo.toml`, or `Cargo.lock`.

## Test Suite Results

- **Invocation:** `time cargo test` (no `--include-ignored` — live-Jira E2E suite inert)
- **Overall result:** GREEN — all tests passed

| Metric | Value |
|---|---|
| Total tests | 5,267 |
| Passed | **5,091** |
| Failed | **0** |
| Ignored | 176 |
| Test binaries executed | 121 (1 lib unit + 119 integration + 1 doc-test) |
| Serial test-binary execution time | 771.5s (~12.9 min) |
| Wall-clock elapsed | ~95 min (includes compilation + Gatekeeper validation) |

### Notable binary timings

| Binary | Time |
|---|---|
| `adf_code_mark_exclusivity` (bc_7_2_015 subprocess tests) | 634.22s |
| `e2e_cli_surface_guard` | 43.06s |
| `attachment_download` | 30.02s |
| `auth_remove_logout_semantics` | 29.04s |
| doc-tests `jr` (profile.rs compile-fail) | 19.68s |

The `adf_code_mark_exclusivity` binary runs 4 tests that each spawn a `jr` subprocess to
validate ADF code-mark exclusivity via a wiremock-backed integration path; each subprocess
takes ~150s due to Gatekeeper first-launch validation of the newly-built debug binary.

## Lint Gate

- **Clippy:** `cargo clippy -- -D warnings` → **PASS** (exit code 0, zero warnings)
- **Format:** `cargo fmt --all -- --check` → **PASS** (exit code 0, zero diff)

## CONTRACT

> All **5,091** passing tests must still pass after cycle-007 F4 implementation;
> zero regressions permitted.

## Verdict

**GREEN — safe to start Wave 1.**

The full `cargo test` suite ran to completion with zero failures across 121 test binaries,
5,091 passing tests, and 176 appropriately-ignored tests (keyring, OAuth integration,
live-Jira E2E — all require environment not present in this run).
