# PR Review — S-cycle4-honest-fail-message (DPAPI-fallback honest-fail messages)

**PR:** #771 — https://github.com/Zious11/jira-cli/pull/771
**Branch:** feat/cycle4-honest-fail-message → develop
**Reviewer:** pr-reviewer-771-cycle1 (fresh-eyes final pre-merge gate, cycle 1)
**Verdict:** APPROVE — ready to merge
**Date:** 2026-09-05
**covered_sha:** b2a0c5d707a9daa8543f32acba6e718bcec77907

## Scope reviewed
Production: `src/api/auth.rs` (new `site1_login_store_failure_message` / `site3_refresh_store_failure_message` pure selectors; Site 3 proactive `clear_profile_oauth_pair` wiring in `refresh_oauth_token_with_url`; source-scan guard test)
Docs: `CHANGELOG.md` (`[Unreleased]` Fixed entry, DEC-334)
Tests: `src/api/auth.rs` inline `honest_fail_message_tests` (AC-001..007 + chain-ordering proof + Site-1 no-clear keyring-gated) and `test_no_account_wide_harmful_revoke_framing_in_auth_source`; `tests/oauth_refresh_integration.rs` (`remove_env` helper + Site-3 wired keyring-gated test)

## Independently verified (against source at HEAD, not just PR body)
- **Two distinct messages correct.** Site 1 `DpapiFallbackFailed` arm: names the 2560-byte Credential Manager limit, interpolates the DPAPI failure detail (`DpapiFallbackFailed.0`), instructs disk-space/permissions check + re-login, recommends scoped `jr auth logout`/`jr auth remove` as DEFAULT, presents `manage-profile/apps` revoke as OPTIONAL with an explicit ACCOUNT-WIDE ("sign out every jr profile on this Atlassian account") warning. Site 3 `DpapiFallbackFailed` arm: names the same limit + detail, instructs a fresh login, contains NO "revoke" and NO manage-profile URL.
- **Site 3 clears / Site 1 doesn't.** `refresh_oauth_token_with_url` (auth.rs:1826-1845) calls `clear_profile_oauth_pair` only when the `DpapiFallbackFailed` marker is present, before returning the honest-fail error; `oauth_login` clears nothing.
- **Marker discrimination is type-based** (`downcast_ref`), `ProfilePathEscape` checked FIRST at both sites → distinct exit-64 `JrError::UserError` via `invalid_profile_name_error` (exit code 64 confirmed). Chain-ordering test proves ProfilePathEscape wins regardless of position in the anyhow chain.
- **Source-scan guard is a real behavioral check**, not a no-op: `include_str!("auth.rs")` split at `"\nmod tests {"`, lowercase scan of the production half for `["no other consumer","must first revoke","safe cleanup"]`, asserts absence. Split correctly excludes the tests' own panic strings that reference the phrases.
- **No secret leakage.** `{inner}` is always an IO/syscall error string (`"DPAPI protect failed: …"`, `"failed to write secret file: …"`, or the non-Windows `"DPAPI is not available …"`) — never a token. `{e:#}` for `keyring::Error::TooLong` renders `"Attribute 'password' is longer than platform limit of N chars"` (attribute NAME only, verified in keyring 3.x `error.rs`); this interpolation is pre-existing, unchanged by the PR.
- **Local verification:** `cargo fmt --all -- --check` clean; inline `honest_fail_message_tests` 10/10 pass; source-scan guard 1/1 pass.
- **CI:** all 15 checks green at this SHA (CI Gate, Clippy ubuntu+windows, Format, MSRV, Mutation testing, Coverage, Deny, Secret Scan, Spec Guards, Test macos/ubuntu/windows).

## Non-blocking observations (no change required)
1. Source-scan guard is phrase-exact (3 literals) — a novel re-wording of harmful revoke framing would not be caught. Documented in the PR; PR review is the intended backstop.
2. Cosmetic wording inconsistency in Site 1: `DpapiFallbackFailed` arm says "stale credentials" with double-quoted commands, legacy arm says "stored credentials" with backtick commands. Both satisfy all ACs.

## Findings by severity
- HIGH: none
- MED: none
- LOW: two (both above), non-blocking.

## Merge note
CI green at `b2a0c5d7`. Nothing in the diff blocks merge.
