# PR #864 Fresh-Eyes Review — test(client): kill missed mutants in error-parsing/retry/sanitize helpers

**Verdict: REQUEST_CHANGES** (one trivial blocking fix; test work itself is approve-quality)

Repo: `Zious11/jira-cli` · Branch: `test/client-mutation-coverage` → `develop` · Diff: +781 / -0, single file `src/api/client.rs`

## Blocking finding (HIGH) — fails the CI gate

**F1 — 4 clippy `manual_repeat_n` errors in the new test code.**
- Locations: `src/api/client.rs:2802`, `:2854`, `:2915`, `:2920` — all `std::iter::repeat(x).take(n)`.
- CI runs `cargo clippy --all --all-features --tests -- -D warnings` (`.github/workflows/ci.yml:40`) and `clippy` is a required member of `ci-gate.needs` (`ci.yml:732`). These 4 errors turn the `clippy` job red → `ci-gate` red → merge blocked. The PR's "clean local code-reviewer pass" did not lint test targets.
- Fix (mechanical): replace each `std::iter::repeat(X).take(N)` with `std::iter::repeat_n(X, N)`. `repeat_n` is stable since Rust 1.82; repo MSRV is 1.88, so safe. Re-run `cargo clippy --all --all-features --tests -- -D warnings` to confirm green.
- `cargo fmt --all -- --check` is already clean (exit 0).

## Verified good

**Genuinely test-only / additive.** All 781 additions live inside `#[cfg(test)]` code: the existing `mod sanitize_tests` plus two new `#[cfg(test)]` modules (`client_accessor_tests`; additions to `sanitize_tests`). No production (non-test) lines changed — the bodies of `cap_entry`, `sanitize_for_stderr`, `serialize_value_bounded`, `extract_error_message_raw`, `authorization_header`, `reqwest_client` are untouched.

**Tests are meaningful, not padding.** Spot-checked ~10 of 23 against the real implementations and traced the mutation each claims to kill:
- Exact-length pins are real math, not magic numbers: `test_sanitize_for_stderr_retroactive_trim_walks_back_across_multibyte_char` pins content.len()==4059 (marker 36, target 4060, walk back to 日 boundary 4059 — verified); non-UTF8 U+FFFD variant pins 975 (marker 48, target 976 → 975 — verified).
- `test_sanitize_for_stderr_clean_input_at_exact_cap_reuses_same_allocation` uses pointer identity to distinguish fast-path (`>`) from `>=` at len==CAP where the string VALUE is identical — a sound kill, and honestly documents its prior mischaracterization as equivalent.
- errorMessages/errors join-budget tests reproduce the implementation's own greedy `acc + separator_len + entry_len > content_budget_join` accounting to pin retained length; exact-boundary tests correctly prove `>` (accept exact fit) vs `>=` (reject one early) using filler entries so the marker fires either way. Entry-length choices (3 vs 5, 17 vs 14) are explicitly justified to make second-`+`→`*` precedence mutants observable.
- Self-consistency guards fail loudly if setup assumptions drift.
- Accessor tests match the real `&self.auth_header` / `&self.client` bodies.
- All 81 client.rs unit tests pass locally, including every new one.

**"Remaining survivors" claims are internally consistent** with the code: cap_entry's `marker.len() >= MAX_ERROR_ENTRY_LEN` guard (`:1237`) and extract_error_message_raw's `target_prefix_len == 0` guard (`:1749`) are genuinely unreachable given the 1024-byte cap vs ~48-byte max marker; the `is_char_boundary(len())`-always-true no-ops and clamp_retry_sleep sub-millisecond-timing survivors are plausible against the function bodies (not independently re-run under cargo-mutants).

**Conventions:** test naming follows `test_<verb>_<subject>_<expected_outcome>`; per-test doc comments name the specific mutant killed. JSON-render/output conventions not applicable (no handler code).

## Recommendation
Send back for the one-line-each `repeat`→`repeat_n` fix at the 4 sites, confirm clippy green, then clean approve.
