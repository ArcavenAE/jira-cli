---
document_type: phase-report
level: ops
version: "1.0"
status: complete
producer: state-manager
timestamp: 2026-10-05T00:00:00Z
phase: F6
cycle: cycle-014
traces_to: ""
---

# cycle-014 F6 Targeted Hardening Report

**Delta:** `204b1fb5..3fb4cf3b` (develop @ `3fb4cf3b`)
**Verdict:** **PASS** (formal + security). One ADVISORY mutation pass (helpers.rs / workflow.rs) is still in flight; its results will be appended here later.
**Not applicable:** dtu-validator, accessibility audit, demo (no DTU clones, no UI).

## 1. Security final scan: PASS, no findings

| Check | Result |
|-------|--------|
| `cargo deny` | advisories / bans / licenses / sources all ok |
| `cargo audit` | 360 crates checked, none found |
| Dependency surface | delta does not touch `Cargo.toml` or `Cargo.lock` |
| `clippy` | clean |
| Delta code scan | adds no `unsafe`, `#[allow]`, `env::var`, `JR_*` seams, `get_from_instance`/`post_to_instance`, or new HTTP call sites; all 38 added `unwrap`/`expect` calls are in test modules |
| Secrets | `gitleaks` not installed locally; a pattern grep was used and found nothing. CI "Secret Scan (gitleaks)" passed on every PR |
| Regression runs | `output::` 77, `table_output_sanitization` 54, `api_query_param` 50 -- all pass |

## 2. Formal verification: PASS

VP source: `phase-f2-spec-evolution/verification-delta.md` (8 new VPs) plus `BC-7.1.006` VP-SEC-001-001..003 and EC-25.

All **PROVEN**: `VP-USER-LIST-PROJECT-001`, `VP-580-013`, `VP-API-QP-001..006`, `VP-SEC-001-001..003`, `EC-25`.

- Focused lib tests: 136 passed with `PROPTEST_CASES=2048` (some `output.rs` blocks pin their own case count at 1000 or 2000).
- Integration suites: `api_query_param` 50, `field_options` 88, `table_output_sanitization` 54, `user_commands` 43, `user_list_project_resolution` 34, `user_pagination` 39, `hermetic_helper` 30.
- Fuzz targets: none (none required).

## 3. Mutation testing (cargo-mutants 27.1.0, `--in-diff`)

108 mutants: `output.rs` 58, `field.rs` 24, `user.rs` 14, `api.rs` 10, `interactions.rs` 1, `main.rs` 1.

| Outcome | Count |
|---------|-------|
| Killed | 99 |
| **Missed** | **0** |
| Unviable | 7 |
| Equivalent | 2 |

- The 2 equivalents are `output.rs:474:9` and `output.rs:624:9`, each deleting the `'\r'` match arm: `classify_default_char` already drops C0 controls. Confirmed by hand.
- Two timeouts were resolved as kills: `field.rs:119` `handle` -> `Ok(())` was caught in run 3; `user.rs:115` `handle_view` -> `Ok(())` was confirmed by hand (7 `user_view` tests fail).
- It took three runs: run 1 hit the 2h background limit, and the run 2 baseline hung.
- **ADVISORY pass pending:** 8 mutants in `helpers.rs` / `workflow.rs` (outside `examine_globs`) are in flight. Results to be appended.

## 4. Follow-ups (target: next maintenance sweep)

| ID | Description |
|----|-------------|
| `MUTANTS-EXAMINE-GLOBS-HELPERS-WORKFLOW` | `helpers.rs` and `workflow.rs` are changed source files missing from `examine_globs`. |
| `MUTANTS-TIMEOUT-HEADROOM` | The full suite takes ~227s against the 240s per-mutant timeout in `cargo-mutants-policy.md`, so late kills or survivors report as TIMEOUT. |
| `OAUTH-HOLDOUT-KEYCHAIN-HANG` | `tests/oauth_flow_holdouts.rs::test_s_1_06_h_003_profile_precedence_chain` (`jr auth list`) probes the real macOS keychain and intermittently hangs. Isolate via `JR_SERVICE_NAME` or a probe seam. Pre-existing, outside the delta. |
| `API-SEPARATOR-ORACLE-NOT-INDEPENDENT` | The `VP-API-QP-001` proptest oracle mirrors the production case split; the pinned examples carry the independent kill power. |

## 5. Next

F7 Delta Convergence (consistency-validator 7-dimension loop, max 10 cycles), then HUMAN APPROVAL, then release.
