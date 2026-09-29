# Fresh-Eyes PR Review — PR #886 (S-cycle14-user-list-project-resolution)

**VERDICT: APPROVE — 0 blocking, 3 non-blocking findings**

PR: `fix(user)!: resolve user list project via configured default, exit 64 when none` (closes #862)
Repo: Zious11/jira-cli · Base: `develop` · Head: `fix/user-list-project-resolution` @ `8b113241`
Diff: 13 files, +1298 / -17

## Summary

Changes `UserCommand::List.project` from a clap-required `String` to `Option<String>`, threads
`&Config` from `main.rs` into `cli::user::handle`, and resolves the project via the new pure
`resolve_user_list_project` (= `Config::project_key`). Precedence is local `--project` > global
`--project` (via clap global-value propagation) > `.jr.toml` > profile default > exit 64
(`JrError::UserError`, before any HTTP call). Implementation matches amended BC-X.7.002.

## Verification Performed

- `cargo test --test user_list_project_resolution --test user_commands --test user_pagination`: 38 / 47 / 43 passed, 0 failed.
- `cargo test --lib bc_x_7_002`: 2 passed (clap-propagation pin, resolver proptest).
- `cargo clippy --all-targets -- -D warnings`: clean.

## Spec Fidelity (BC-X.7.002)

- Fix step 1: type change only, `#[arg(long, short = 'p')]` retained, help text matches the pinned string (`src/cli/mod.rs:1146-1150`). PASS
- Fix step 3: `&Config` threaded from `src/main.rs:438`; no reload in handler. PASS
- Fix step 4: resolver signature/body match `field.rs::resolve_m2_project` (`src/cli/user.rs:20-25`); exit 64 on `None` before HTTP (`src/cli/user.rs:84-92`). PASS
- Fix step 5: no extra `cli.project` parameter; propagation covered by inline test. PASS
- Exit-64 message byte-identical to `queue.rs`/`requesttype.rs`. PASS
- EC-X.7.002-6 (`Some("")` pass-through): pinned by proptest and integration test. PASS
- Hermetic setup per verification-delta §2; zero HTTP proven with wiremock `.expect(0)`. PASS

## Findings

### NB-1 (non-blocking) — brittle clap-internal pin
`src/cli/mod.rs`, final assertion of `test_bc_x_7_002_user_list_project_clap_propagation`:
asserting `cli.project == Some("L")` on the both-flags argv pins clap's `fill_in_global_values`
write-back behavior, which `user list` does not depend on. A clap minor bump could break it
without a product regression. Intentional per P31-003(1)/D-389; noted only.

### NB-2 (non-blocking) — redundant legacy test
`tests/user_commands.rs::user_list_requires_project_flag` now passes via jr's exit-64 message,
not clap's "required" error. Name retention was accepted at the F1 gate; the new
`test_user_list_without_resolvable_project_exits_64_with_zero_http` covers the real contract.

### NB-3 (non-blocking, low) — no JSON error-envelope cell
No test asserts `--output json` yields `{"error": ..., "code": 64}` on the new exit-64 path.
Low risk: generic `main.rs` error rendering already covered elsewhere. Optional follow-up.

## Other Checks

- Preemption order (`JiraClient::from_config` before resolver) matches BC "preempt" clause.
- CHANGELOG entry under Breaking Changes with correct precedence.
- `.cargo/mutants.toml` glob and policy-doc count (32 → 33) consistent.
- `tests/common/hermetic.rs`: `vars_os` iteration, case-insensitive prefix match, original-key removal — correct.

## Posting Status

Not posted to GitHub by this reviewer: session had no gh CLI delegation authority (per
pr-manager instructions). pr-manager to dispatch github-ops with
`gh pr review 886 --approve --body-file <this file>`.

---

# Independent Fresh-Eyes Review (pr-reviewer-886-cycle1) — PR #886 @ `8b113241`

**VERDICT: APPROVE — 0 blocking, 4 non-blocking findings**

## Verification Performed

- `cargo fmt --all -- --check`: clean.
- `cargo clippy --all --all-features --tests -- -D warnings` (the CI invocation): clean.
- `cargo test` for `user_list_project_resolution`, `user_commands`, `user_pagination`, `all_flag_behavior`, and lib `user` tests: all pass.
- `scripts/check-cargo-mutants-policy-citations.sh`: "30 bullets parsed, 99 (file, fn) pairs validated". AC-011 requires exactly 30. `examine_globs` has 33 entries.
- Scoped cargo-mutants over `src/cli/user.rs` (whole file is now in scope; tests limited to lib, bin and the 4 user test binaries): 16/16 viable mutants caught, 0 missed, 0 timeouts, 1 unviable.
- `jr user list --help` rendered output checked on the built binary.

## Spec Fidelity (BC-X.7.002)

Fix steps 1, 3, 4 and 5, Postconditions 1-5, EC-1..6, and the Invariants all match the contract.
- The exit-64 message is byte-identical to `queue.rs:23` and `requesttype.rs:29`. It is returned before any HTTP call, pinned with wiremock `.expect(0)`.
- Every `--all` page carries exactly one `projectKeys=<resolved>`.
- `&Config` is threaded from `src/main.rs:438` with no reload; the EC-5 `--profile alt` cell catches a reload.

## Findings

### N-1 (non-blocking): help text trailing period
`src/cli/mod.rs:1146-1148`. clap strips the trailing period from a single-paragraph doc comment, so the rendered help ends "...or the active profile" without the final period. The backticks around `.jr.toml` are also printed literally. VP(d) pins substrings only, so no test breaks, and the source comment matches the BC text. If Fix step 1 is read as a rendered-output pin, clarify the spec rather than the code.

### N-2 (non-blocking): wrong rationale comment and duplicated helpers
`tests/user_pagination.rs`, doc comment on `write_default_profile_config`. It says the helper is duplicated "because each integration-test file compiles as its own separate binary crate". But `tests/common/` is shared across binaries, and this PR adds `tests/common/hermetic.rs` for that very purpose. `write_default_profile_config` and the hermetic `jr_cmd` builders could live in `common::hermetic`. At minimum, correct the comment.

### N-3 (non-blocking): inline tests re-run in every binary
`tests/common/hermetic.rs:102-134`. The `#[cfg(test)] mod tests` block compiles into every integration binary that declares `mod common;`, so the four `is_scrubbable` tests run once per binary. Consider moving them to a dedicated test file.

### N-4 (non-blocking, informational): EC-X.7.002-7 has no fixture
No test covers an empty configured project (`project = ""`). The proptest regexes never produce an empty string. The spec marks this edge case informational with no dedicated VP cell, so it is not a contract gap.
