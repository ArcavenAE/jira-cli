# PR #772 Review — FIX-W2-INT-README (cycle-004)

**Branch:** `docs/cycle4-readme-consistency` @ `f0856a92`
**Scope:** DOCS-ONLY (README.md + CHANGELOG.md) — 2 files, +38/-7
**Verdict:** CLEAN (merge-ready pending CI)

## Summary

Fresh-context, source-grounded review of a docs-only PR correcting 3 README
credential-storage / auth-default consistency defects. Each changed sentence was
ground-truthed against current `src/` code and the CHANGELOG. All three
corrections are ACCURATE; no new inaccuracy or contradiction was introduced; the
diff touches only README.md and CHANGELOG.md.

## Correction-by-correction verification

### (1) W2-INT-MED-001 — per-profile API-token storage — ACCURATE
README prose changed from "stored once ... shared by all `api_token` profiles"
to "stored per profile ... namespaced `<profile>:email`/`<profile>:api-token`".
- `src/api/auth.rs::api_token_email_key` → `format!("{profile}:email")` (line 50);
  `api_token_key` → `format!("{profile}:api-token")` (line 55); `store_api_token`
  writes both namespaced keys (line 701).
- Isolation confirmed by `load_api_token_cross_profile_isolation` (line 3124:
  profile A's creds unreadable under profile B's namespace; a third profile sees
  neither) and `load_api_token_default_profile_has_no_legacy_fallback` (line 3094:
  even the `"default"` profile does NOT fall back to legacy flat keys).
- Matches CLAUDE.md "Per-profile vs shared keychain keys" gotcha (BC-1.4.031).
- Parallel `jr auth logout` command-table row fix ("that profile's API token
  (stored per-profile, not shared) is NOT touched") is accurate: `logout.rs`
  uses `clear_profile_oauth_pair` and explicitly never touches the API-token pair
  (rustdoc lines 42-44).

### (2) W2-INT-LOW-001 — Windows DPAPI-fallback note — ACCURATE
New Windows note added.
- Cap "~2560 bytes": matches `auth_windows_store.rs` module header line 2.
- Trigger (`keyring::Error::TooLong`): `should_fallback_to_dpapi` (lines 169-170)
  `matches!(err, keyring::Error::TooLong(_, _))`.
- Path `%LOCALAPPDATA%\jr\secrets\<profile>\oauth-tokens.dat`: module header line
  11 and `file_path` (lines 268-273: `.join("secrets").join(<profile>).join("oauth-tokens.dat")`).
- Matches CLAUDE.md ADR-0021 gotcha. No overclaim: the note correctly scopes the
  fallback to oversized OAuth refresh tokens (file is `oauth-tokens.dat`), not API
  tokens, while still accurately opening with "Credentials ... stored in Windows
  Credential Manager".

### (3) W2-INT-LOW-002 — `jr auth login` default description — ACCURATE
Command-table row + Quick Start comment corrected.
- Interactive OAuth-first picker: `prompt_auth_method_picker` (login.rs line 745)
  uses items `["OAuth 2.0 (recommended)", "API Token"]` with `.default(0)` —
  OAuth pre-selected (lines 749-753).
- Dispatch precedence (login.rs lines 562-572): `--oauth` → OAuth; `--api-token`
  → API token (skips picker); `--no-input`/non-TTY → API token default; else →
  picker. Confirms "non-interactive defaults to API token".
- `--oauth` deprecated: `emit_oauth_deprecation_notice` fired on the `--oauth`
  branch (lines 480-482).
- CHANGELOG [0.7.0-dev.4] (lines 84-140) documents the picker (BC-1.1.013), the
  `--api-token` flag (BC-1.2.050), the non-interactive default (BC-1.1.014), and
  `--oauth` deprecation — all consistent with the README wording.

## Cross-checks
- **No residual stale claims** on the PR branch: grep for "shared by all",
  "stored once", "API token (default)", "shared API token", "--oauth for OAuth
  2.0", "Authenticate with API token" returns nothing on
  `origin/docs/cycle4-readme-consistency:README.md`. (The same grep against the
  working tree still shows them because the working tree is not on the PR branch.)
- **CHANGELOG entry accurate**: the new `[Unreleased]` bullet correctly names all
  three findings, cites `store_api_token`/`src/api/auth.rs`, the two isolation
  tests, ADR-0021/`auth_windows_store.rs`, and [0.7.0-dev.4]/BC-1.1.013; marked
  "Doc-only; no `src/` changes."
- **Scope**: `git diff --stat` = README.md + CHANGELOG.md only. Nothing in `src/`,
  tests, or CI touched.

## Findings
None (no BLOCKING / SUGGESTION / NIT).

## CI / merge status (as of review)
- `gh pr checks 772`: passing — Clippy(ubuntu), Deny, Format, MSRV, Mutation,
  Secret Scan, Spec Guards, dependency-review, Signing Workflow Injection Guard.
  Pending — Coverage, Test(ubuntu/macos/windows), Clippy(windows). No failures.
- `mergeable`: MERGEABLE; `mergeStateStatus`: BLOCKED (awaiting the still-pending
  required checks / CI Gate); `headRefOid`: f0856a928a3c30ef4b56a8e2c560932e6e86037b
  (matches expected head).

Not posted to GitHub; not merged (per instructions).
