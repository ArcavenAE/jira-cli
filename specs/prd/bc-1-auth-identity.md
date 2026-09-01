---
context: bc-1
title: "Auth & Identity"
total_bcs: 69   # cumulative claim (incl. range-collapsed); definitional_count below is individually-bodied headings
definitional_count: 58   # count of `#### BC-` headings in this file
last_updated: 2026-09-01
source_pass: 3
trace: |
  - F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01, DEC-312..325, ADR-0020, ADR-0011 amended): AMENDED BC-1.1.009/010, BC-1.2.013/014/017, BC-1.4.025/027/029, BC-1.6.046 for per-profile API-token credential storage (DEC-315), non-destructive `auth logout` + 4-step `auth remove` (DEC-322), and the `auth list` ENV column (DEC-324). ADDED BC-1.1.013/014/015 (OAuth-default-at-creation + non-interactive regression pins + runtime-default-unchanged pin, DEC-313), BC-1.2.048/049/050/051 (no-per-command-auth-switch invariant, `--oauth` deprecation, new `--api-token` flag, `auth refresh` override removal, DEC-313/321/323), BC-1.4.031/032/033 (per-profile API-token keychain functions, one-time lazy migration, partial-state handling, DEC-315), BC-1.6.047 (`env` tag JSON-shape contract, DEC-314/324). BC count 58→69 (47→58 individually-bodied). See `.factory/cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md` and `.factory/specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md`.
  - F2 spec evolution, bucket1-defects bundle (2026-08-13, issue #663): BC-1.2.018 AMENDED — carves out `auth switch` as the explicit exception to global `--profile` propagation (previous unqualified text retained inline for audit trail); BC-1.2.047 NEW — `auth switch --profile <X>` rejected with exit 64 (guard fires in `src/main.rs` before `Config::load_with`; standard `--output json` error envelope). BC count 57→58 (46→47 individually-bodied). See `.factory/research/bucket1-663-auth-switch-profile-2026-08-13.md`.
  - L2: .factory/specs/domain-spec/bc-01-auth-identity.md
  - Source broad: .factory/semport/jira-cli/jira-cli-pass-3-behavioral-contracts.md §2.1
  - Source R1: .factory/semport/jira-cli/jira-cli-pass-3-deep-r1.md §3.1
  - Source R4: .factory/semport/jira-cli/jira-cli-pass-3-deep-r4.md §3.8-3.9
---

# BC-1 — Auth & Identity

69 behavioral contracts across 6 subdomains: OAuth flow (1.1), Profile management (1.2),
Embedded OAuth app (1.3), Token keychain (1.4), OAuth state machine (1.5), Auth error handling (1.6).

---

## Subdomains

### 1.1 OAuth Flow & Profile Resolution

#### BC-1.1.001: `auth list` against fresh-install returns empty JSON array

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:~53`
**Subject**: Auth & Identity
**Behavior**: When no `~/.config/jr/config.toml` exists (or no `[profiles.*]` keys), `jr auth list --output json` exits 0 and stdout is `[]`.
**Effects**: stdout = `[]`, exit 0, no HTTP, no keychain access.
**Edge cases**: fresh install with no config file at all.
**Error taxonomy**: none.
**Trace**: Pass 3 BC-001; L2 E-01-01

---

#### BC-1.1.002: `auth status` against fresh install exits 0 with helpful stderr

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:~62`
**Subject**: Auth & Identity
**Behavior**: `jr auth status` against an uninitialized config exits 0 and prints `No profiles configured` to stderr. Supports first-run probes by setup scripts/CI.
**Edge cases**: no config.toml; no `[profiles]` section.
**Error taxonomy**: none — intentionally success.
**Trace**: Pass 3 BC-002

---

#### BC-1.1.003: `auth switch <unknown>` exits 64

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:~42`
**Subject**: Auth & Identity
**Behavior**: Switching to an unknown profile exits 64 (`UserError`) with no config mutation.
**Error taxonomy**: `JrError::UserError` (exit 64).
**Trace**: Pass 3 BC-003

---

#### BC-1.1.004: `auth status --profile <unknown>` exits 64 with "unknown profile"

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:~78`
**Subject**: Auth & Identity
**Behavior**: Explicit `--profile` flag naming absent profile → exit 64; stderr contains `unknown profile`.
**Error taxonomy**: `JrError::UserError`.
**Trace**: Pass 3 BC-004

---

#### BC-1.1.005: `auth logout --profile <unknown>` exits 64

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:~98`
**Subject**: Auth & Identity
**Behavior**: Logout against unknown profile exits 64 with `unknown profile` in stderr.
**Error taxonomy**: `JrError::UserError`.
**Trace**: Pass 3 BC-005

---

#### BC-1.1.006: `auth remove <active>` is rejected with exit 64

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:~120`
**Subject**: Auth & Identity
**Behavior**: Removing the currently-active profile exits 64 with stderr `cannot remove active`. No file changes, no keychain deletion.
**Error taxonomy**: `JrError::UserError`.
**Trace**: Pass 3 BC-006

---

#### BC-1.1.007: Profile resolution precedence: flag > JR_PROFILE env > config.default_profile > "default"

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:~142`; `src/config.rs:~95`
**Subject**: Auth & Identity
**Behavior**: `Config::load_with(cli_profile)` resolves active profile via precedence chain. Test populates three profiles (from-config / from-env / from-flag) — flag wins. `Config.active_profile_name` set accordingly.
**Effects**: `auth list --output json` returns exactly one element with `"active": true`.
**Trace**: Pass 3 BC-007

---

#### BC-1.1.008: Global `--profile` flag propagates to `auth status` via main.rs composition

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:~193`
**Subject**: Auth & Identity
**Behavior**: `jr --profile sandbox auth status` (no subcommand-level `--profile`) targets sandbox. main.rs composes effective profile via `subcmd.profile.or(cli.profile)`.
**Effects**: stderr/stdout reflect sandbox URL/name.
**Trace**: Pass 3 BC-008 → superseded by BC-030 (R1)

---

#### BC-1.1.009: `auth login --profile <new>` creates profile even when profile doesn't yet exist

**STATUS: AMENDED (2026-09-01, cycle-003 `auth-profile-dx`, DEC-315)** — the Effects clause's keychain-write description changes from shared/flat to per-profile-namespaced; the config-write behavior itself is unchanged.

**Confidence**: HIGH (`#[ignore]`-gated by JR_RUN_KEYRING_TESTS)
**Source**: `tests/auth_profiles.rs:~241`; ADR-0020 §Decision 1
**Subject**: Auth & Identity
**Behavior**: Login uses lenient config load (skips strict active-profile-existence check), then writes `[profiles.NEW]` with URL + auth_method.
**Effects**: writes config; writes the new profile's own `<NEW>:email`/`<NEW>:api-token` keychain pair (DEC-315) for an `api_token`-method profile, or `<NEW>:oauth-access-token`/`<NEW>:oauth-refresh-token` for an `oauth`-method profile — never a shared/flat pair.

**Previous version (superseded by DEC-315, retained for audit trail):**
> **Effects**: writes config, writes shared `email`/`api-token` keychain keys.

**Trace**: Pass 3 BC-009; F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01, DEC-315) — Effects amended for per-profile keychain storage; cross-reference BC-1.4.031 (new per-profile storage functions), BC-1.4.032 (migration for pre-existing shared-key installs).

---

#### BC-1.1.010: `auth login --profile X` succeeds even when JR_PROFILE points to absent profile

**STATUS: AMENDED (2026-09-01, cycle-003 `auth-profile-dx`, DEC-315)** — clarifies that the credential writes this login flow performs are per-profile-namespaced, not shared/flat.

**Confidence**: HIGH (`#[ignore]`-gated)
**Source**: `tests/auth_profiles.rs:~290`; ADR-0020 §Decision 1
**Subject**: Auth & Identity
**Behavior**: Login uses lenient load throughout — top-level + internal reloads in login_token/login_oauth. `JR_PROFILE=ghost` doesn't abort creation of a different profile.
**Effects**: any keychain credentials written during this flow target the profile actually being created/logged into (the `--profile X` value), namespaced per DEC-315/BC-1.4.031 — never the `JR_PROFILE`-resolved (absent) profile and never a shared/flat pair.
**Trace**: Pass 3 BC-010 → refined by BC-029 (R1); F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01, DEC-315) — Effects clause added for per-profile keychain storage clarity.

---

#### BC-1.1.011: `auth refresh --no-input` against unconfigured profile exits 64 naming "no URL configured"

**Confidence**: HIGH
**Source**: `tests/auth_refresh.rs:~43`
**Subject**: Auth & Identity
**Behavior**: With `--no-input` AND no profile URL configured, refresh exits 64 with stderr matching `no URL configured` + `jr auth login` + `--url`. Critically: stderr does NOT contain `panic`. Credentials NOT cleared on failure.
**Error taxonomy**: `JrError::UserError`.
**Trace**: Pass 3 BC-011 → refined by BC-025 (R1)

---

#### BC-1.1.012: Malformed config TOML errors exit 78 and does NOT overwrite the file

**Confidence**: HIGH
**Source**: `tests/auth_login_config_errors.rs:~18`
**Subject**: Auth & Identity
**Behavior**: When `~/.config/jr/config.toml` is malformed, `auth login --oauth ...` exits 78. Stderr contains `toml` or `parse`. The on-disk file is byte-identical to before (no silent overwrite). This is BC-1139 from Pass 3.
**Error taxonomy**: `JrError::ConfigError` (exit 78).
**Trace**: Pass 3 BC-012; BC-1139 (R4 tightened)

---

#### BC-1.1.013: `auth login` bare and interactive defaults to OAuth, mirroring `jr init`

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 5; `src/cli/init.rs::handle` (reference picker); `src/cli/auth/login.rs::handle_login` (F4 target)
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-313)

**Description**: `jr auth login` invoked bare (no `--oauth`/`--api-token` flag) in an interactive TTY session presents the same `["OAuth 2.0 (recommended)", "API Token"]` `dialoguer::Select` picker `jr init` already uses, defaulting the cursor to OAuth (`.default(0)`). This closes the pre-cycle-003 inconsistency where `jr init`'s picker already defaulted to OAuth while bare `jr auth login` silently defaulted to the API-token flow.

**Preconditions**:
1. `jr auth login [--profile <name>] [--url <url>]` is invoked with neither `--oauth` nor `--api-token` present.
2. Stdin is a TTY and `--no-input` is not set (interactive mode — see BC-1.1.014 for the non-interactive counterpart).

**Postconditions**:
1. The mechanism-selection picker is presented with items `["OAuth 2.0 (recommended)", "API Token"]` and `.default(0)` (OAuth pre-selected).
2. The user's selection is written as the new (or updated) profile's `auth_method` and drives which flow (`login_oauth`/`login_token`) actually runs for this invocation.
3. This is a creation-time/re-declaration event only — see BC-1.2.048 for the invariant that no *other*, later invocation may change the mechanism without going through `auth login` again.

**Invariants**:
1. Behavior is identical to `jr init`'s existing picker — no divergent copy, wording, or default between the two entry points.

**Edge Cases**:
- EC-1.1.013-1: `--oauth` or `--api-token` supplied explicitly → the picker is skipped entirely; the flag's mechanism is used directly (see BC-1.2.049/BC-1.2.050).
- EC-1.1.013-2: An existing profile re-running bare interactive `auth login` re-presents the picker (still defaulting to OAuth) — this is the "re-declaration" path DEC-321/BC-1.2.051 relies on for changing a profile's mechanism.

**Verification Properties**: None dedicated to this BC. **[TRIAGED 2026-09-01, F2 VP-delta pass]** The original draft candidate (bare interactive `auth login` → picker shown, default cursor index 0) is an example-based UI-presentation assertion (specific picker text/default-selection behavior), not an invariant or property — DEMOTED to an ordinary F4 test acceptance criterion anchored directly to this BC's Postcondition 1 (test-writer implements as a standard `dialoguer::Select` presentation/default-index unit test, no proptest/Kani/trybuild warranted).

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-313; ADR-0020 §Decision 5; cross-reference `src/cli/init.rs::handle` (model implementation).

---

#### BC-1.1.014: `auth login` in non-interactive mode always selects API-token and never launches a browser

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 5 (regression-safety pin); `src/cli/auth/login.rs::handle_login` (F4 target)
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-313) — regression-safety contract

**Description**: This is a negative-space contract pinning DEC-313's explicit "CI stays token-first" guarantee: introducing an OAuth-default picker for the interactive path (BC-1.1.013) must never cause a non-interactive invocation to attempt OAuth (which would require a browser and is unrunnable in CI/automation).

**Preconditions**:
1. `jr auth login` is invoked with neither `--oauth` nor `--api-token`, AND at least one of: `--no-input` is set, stdin is not a TTY, or `JR_EMAIL`/`JR_API_TOKEN` are both present in the environment.

**Postconditions**:
1. The mechanism-selection picker (BC-1.1.013) is NOT presented.
2. The profile's `auth_method` is set to `api_token` and `login_token`'s flow runs.
3. No browser is launched under any circumstance reachable via this precondition set.

**Invariants**:
1. This is a byte-for-byte-unchanged guarantee relative to pre-cycle-003 non-interactive `auth login` behavior — BC-1.1.013's new interactive default must not regress this path.

**Edge Cases**:
- EC-1.1.014-1: `--no-input` set but `JR_EMAIL`/`JR_API_TOKEN` absent and no `--email`/`--token` flags supplied → falls through to the pre-existing non-interactive credential-resolution error path (unchanged), not a picker.
- EC-1.1.014-2: stdin redirected from a file/pipe (non-TTY) without `--no-input` explicitly passed → still classified non-interactive; same guarantee applies (mirrors `main.rs`'s existing auto-`--no-input` TTY detection).

**Verification Properties**:
- **VP-AUTHDX-001 — Non-interactive invocation never launches the OAuth browser flow (SAFETY INVARIANT, PROMOTED 2026-09-01, F2 VP-delta pass, merges draft candidates VP-cycle3-002/003).** Property: for ANY non-interactive trigger condition in the set `{--no-input set, stdin not a TTY, JR_EMAIL+JR_API_TOKEN both present}`, crossed with any credential-completeness state, `jr auth login`/any invocation reachable via this BC's precondition NEVER binds an OAuth callback listener on port 53682 and NEVER attempts to open a browser — the resolved `auth_method` is always `api_token` when the picker is bypassed this way. This is regression-critical per F1 delta-analysis §3 (a CI-breaking regression class: a script or agent running `jr` non-interactively must never hang waiting on a browser redirect). **Verification method**: property test (`proptest`) enumerating the 3-member non-interactive trigger set × credential-presence/absence, asserting `no_browser_launched` and `auth_method == "api_token"` as the invariant on every generated case; supplemented by the two concrete regression cases from the original candidates as fixed proptest regression seeds — (a) `--no-input --email <e> --token <t>` and (b) CI-style non-TTY stdin with `JR_EMAIL`/`JR_API_TOKEN` set. **F6 target**: `src/cli/auth/login.rs::handle_login`.

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-313; ADR-0020 §Decision 5; cross-reference BC-1.1.013 (interactive counterpart), BC-1.1.011 (related non-interactive failure path, unaffected by this BC).

---

#### BC-1.1.015: `JiraClient::from_config`'s `.unwrap_or("api_token")` runtime default for an unset `auth_method` is unchanged

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 5 (regression pin); `src/api/client.rs::JiraClient::from_config`
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-313) — regression-safety pin

**Description**: DEC-313 makes OAuth the default at profile-*creation* time (BC-1.1.013), but explicitly does NOT change the fallback `jr` uses at *runtime* when a profile's `auth_method` field is absent altogether (e.g. a hand-edited config, or any future code path that omits it). This BC pins that the two are independent: the creation-time UX default and the runtime absent-field default are allowed to differ, and this cycle intentionally leaves the runtime default unchanged.

**Preconditions**:
1. A `ProfileConfig` exists with `auth_method: None` (field entirely absent or explicitly null in `config.toml`).
2. `JiraClient::from_config` is called for that profile.

**Postconditions**:
1. `let auth_method = profile.and_then(|p| p.auth_method.as_deref()).unwrap_or("api_token")` resolves to `"api_token"` — byte-for-byte identical to pre-cycle-003 behavior.
2. `jr` attempts api-token (Basic) auth using the profile's stored (or migrated, per BC-1.4.032) per-profile api-token credential — never a silent OAuth attempt against absent tokens.

**Invariants**:
1. This fallback is deliberately conservative: an unset `auth_method` must never silently attempt to launch an OAuth browser flow at HTTP-client-construction time.
2. `Config::base_url`'s `profile.auth_method.as_deref() == Some("oauth")` branch is unaffected by this BC — it already reads the intrinsic per-profile field and has no absent-field ambiguity to resolve.

**Edge Cases**:
- EC-1.1.015-1: a profile created via BC-1.1.013's new OAuth-default picker always has `auth_method` explicitly set to `"oauth"` or `"api_token"` — this BC's absent-field path is unreachable for profiles created through the new creation flow; it remains reachable only via hand-edited config or legacy profiles predating `auth_method`'s introduction.

**Verification Properties**:
- **VP-AUTHDX-002 — Runtime-default-unchanged regression pin (PROMOTED 2026-09-01, F2 VP-delta pass, was VP-cycle3-004).** Property: for a `ProfileConfig` with `auth_method` absent/`None` (any TOML shape that produces this — key omitted entirely, or explicitly `null`), `JiraClient::from_config`'s `.unwrap_or("api_token")` resolves to exactly `"api_token"`, byte-for-byte identical to the pre-cycle-003 value, regardless of any other field on the profile (url, env, cloud_id). Promoted because this is the exact mechanism DEC-313 requires must NOT flip, and a silent regression here (e.g. a future refactor changing the fallback literal) would misroute existing hand-edited or legacy configs into an unintended OAuth attempt. **Verification method**: property test (`proptest`, arbitrary `ProfileConfig` field combinations holding `auth_method: None` fixed) asserting the resolved value is always `"api_token"`; a literal string-pin unit test is retained as the fixed regression seed. **F6 target**: `src/api/client.rs::JiraClient::from_config`.

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-313; ADR-0020 §Decision 5 (verbatim regression-pin language); cross-reference BC-1.1.013/BC-1.1.014 (creation-time vs. runtime-default distinction).

---

### 1.2 Profile Lifecycle Management

#### BC-1.2.013: `auth logout` is a non-destructive, OAuth-session-clear-only operation — preserves the profile entry and all non-OAuth-session credentials

**STATUS: AMENDED (2026-09-01, cycle-003 `auth-profile-dx`, DEC-322)** — restates `logout`'s scope as an explicit, deliberate design decision (session-clear only) now that DEC-315 removes the single "shared keys" bucket the previous wording relied on; also confirms `logout` remains OAuth-specific by design (does not grow API-token-clearing behavior — resolves F1 Open Question 6).

**Confidence**: HIGH (PROMOTED from MEDIUM in R1)
**Source**: `src/api/auth.rs:~24, 88-97`; `src/cli/auth/logout.rs::handle_logout`; ADR-0020 §Decision 7
**Subject**: Auth & Identity
**Behavior**: Deletes `<profile>:oauth-access-token` and `<profile>:oauth-refresh-token` via `delete_credential`. Profile config entry is preserved in full — `url`, `cloud_id`, `env`, and (for an `api_token`-method profile) the per-profile `<profile>:email`/`<profile>:api-token` pair are all PRESERVED, not cleared. The shared/flat `oauth_client_id`/`oauth_client_secret` (BYO OAuth **app**-credential pair) are also untouched — a different axis entirely. Re-login (`jr auth login <profile>`, no flags needed) needs no re-entry of URL/email/token for an `api_token` profile, since those survive `logout` intact.
**Effects**: `jr auth logout` on an `api_token`-method profile is a no-op with respect to that profile's credentials — by design, not by omission (ADR-0020 §Decision 7): "logout" is a session-clear concept (ending a live OAuth session while keeping the profile ready for frictionless re-login); API-token auth has no session to end. Deleting the API-token credential outright is `auth remove`'s job (BC-1.2.014, amended), not `logout`'s.

**Previous version (superseded by DEC-315/DEC-322 restatement, retained for audit trail):**
> **Behavior**: Deletes `<profile>:oauth-access-token` and `<profile>:oauth-refresh-token` via `delete_credential`. Profile config entry preserved. Shared keys (`email`, `api-token`, `oauth_client_id`, `oauth_client_secret`) untouched. Re-login uses preserved API-token/OAuth credentials.

**Trace**: Pass 3 BC-013-R; F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01, DEC-322) — restated as explicit session-clear-only design decision; ADR-0020 §Decision 7 resolves F1 Open Question 6; cross-reference BC-1.2.014 (amended — `remove`'s full-delete contrast), BC-1.4.031 (per-profile api-token pair this BC now explicitly preserves).

---

#### BC-1.2.014: `auth remove <name>` performs four-step delete: config entry, cache directory, OAuth tokens, API-token credential pair

**STATUS: AMENDED (2026-09-01, cycle-003 `auth-profile-dx`, DEC-322)** — gains a fourth delete step for the new per-profile `<name>:email`/`<name>:api-token` pair (DEC-315), making `remove`'s "delete everything this profile owns" contract symmetric across both credential kinds.

**Confidence**: HIGH (PROMOTED from MEDIUM in R1)
**Source**: `src/cli/auth/remove.rs::handle_remove`; `src/cache.rs:~82`; `tests/auth_profiles.rs:~120`; ADR-0020 §Decision 7
**Subject**: Auth & Identity
**Behavior**: Four steps: (1) remove `[profiles.<name>]` from config, (2) `cache::clear_profile_cache(name)` removes `~/.cache/jr/v1/<name>/` (no-op if absent), (3) delete `<name>:oauth-access-token`/`<name>:oauth-refresh-token` keychain keys, (4) delete `<name>:email`/`<name>:api-token` keychain keys (NEW, DEC-315). `clear_profile_creds`/`clear_all_credentials` (`src/api/auth.rs`) each gain the per-profile API-token pair as an additional deletable-key branch, using the same `NoEntry`-is-success aggregation pattern already used for the OAuth pair. All four steps are best-effort; partial state does not cascade. Errors if name == active (exit 64 first, before any step runs).
**Effects**: after `auth remove <name>` succeeds, NEITHER credential kind survives for that profile — this makes `remove` (not `logout`, see BC-1.2.013 amended) the sole full-delete operation for API-token credentials.

**Previous version (superseded by DEC-315, retained for audit trail):**
> **Behavior**: Three-step: (1) remove `[profiles.<name>]` from config, (2) delete `<name>:oauth-*` keychain keys, (3) `cache::clear_profile_cache(name)` removes `~/.cache/jr/v1/<name>/`. Step (3) is no-op if dir absent. All three are best-effort; partial state does not cascade. Errors if name == active (exit 64 first).

**Trace**: Pass 3 BC-014-R; F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01, DEC-315/DEC-322) — fourth delete step added; ADR-0020 §Decision 7; cross-reference BC-1.2.013 (amended — `logout`'s narrower, non-destructive contrast), BC-1.4.031 (the per-profile pair now deleted here).

---

#### BC-1.2.015: `auth refresh --help` includes the `--oauth` flag

**Confidence**: HIGH
**Source**: `tests/auth_refresh.rs:~7`
**Subject**: Auth & Identity
**Behavior**: `jr auth refresh --help` exits 0; stdout contains both `refresh` and `--oauth`.
**Trace**: Pass 3 BC-026 (R1)

---

#### BC-1.2.016: `auth refresh --oauth --help` is accepted in either flag order

**Confidence**: HIGH
**Source**: `tests/auth_refresh.rs:~26`
**Subject**: Auth & Identity
**Behavior**: clap accepts both `--oauth --help` and `--help --oauth`, exit 0.
**Trace**: Pass 3 BC-027 (R1)

---

#### BC-1.2.017: `auth login --profile X` against `JR_PROFILE=ghost` succeeds creating profile X

**STATUS: AMENDED (2026-09-01, cycle-003 `auth-profile-dx`, DEC-315)** — clarifies per-profile keychain writes for this flow. (Note: the F1 delta analysis' impact table cites this contract as "BC-1.1.017"; this file has no BC-1.1.017 — the intended reference is this BC, BC-1.2.017, which covers the identical `auth login --profile X` lenient-load creation flow the F1 report describes. Reconciled here; flagged for the integrate pass.)

**Confidence**: HIGH (`#[ignore]`-gated)
**Source**: `tests/auth_profiles.rs:~282`; ADR-0020 §Decision 1
**Subject**: Auth & Identity
**Behavior**: Round-5 regression fix. Both internal reloads in login flow use `load_lenient_with`. Test sets `JR_PROFILE=ghost`, runs `jr auth login --profile fresh --url https://fresh.example`, asserts `[profiles.fresh]` written.
**Effects**: keychain credentials written for `fresh` target `fresh:email`/`fresh:api-token` (or `fresh:oauth-*`), namespaced per DEC-315/BC-1.4.031 — never a shared/flat pair, and never the absent `ghost` profile's namespace.
**Trace**: Pass 3 BC-029 (R1); F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01, DEC-315) — Effects clause added; ID-reconciliation note re: F1 report's "BC-1.1.017" citation.

---

#### BC-1.2.018: Global `--profile` propagates to all auth subcommands EXCEPT `auth switch` (rejected, exit 64) — composed via `subcmd.profile.or(cli.profile)` for Login/Status/Refresh/Logout, passed through directly for List/Remove

**STATUS: UPDATED (2026-08-13, issue #663)** — carves out `auth switch` as an explicit exception to the propagation rule this BC previously stated unconditionally. Previous (pre-#663) version retained below for audit trail.

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:~188`; `src/main.rs` (`AuthCommand::Switch` guard, new — see BC-1.2.047; `AuthCommand::List`/`Remove` dispatch arms, pre-existing, unaffected)
**Subject**: Auth & Identity
**Behavior**: Round-10 regression fix. `main.rs` composes `subcmd.profile.or(cli.profile)` for `AuthCommand::Login`, `Status`, `Refresh`, and `Logout` — each of these four declares its own subcommand-level `profile: Option<String>` field to compose with. **[CLARIFIED 2026-08-13, adversary pass-1 LOW-2]** `AuthCommand::List` and `AuthCommand::Remove` have NO subcommand-level `profile` field at all — for these two, `cli.profile.as_deref()` is passed straight through with no `.or()` step (there is nothing else to compose against). They still HONOR the global `--profile` flag, via this simpler direct-pass-through mechanism rather than the four-way `.or()` composer. **`auth switch` is the sole exception to "the global flag has effect at all"**: it also has no subcommand-level `profile` field, but as of issue #663 the global `--profile` flag is REJECTED outright (exit 64) rather than passed through — see BC-1.2.047 for the full rejection contract. Do not read "sole exception" as implying `List`/`Remove` ignore `--profile` — they honor it; only `Switch` rejects it.

**Previous version (superseded by issue #663, retained for audit trail):**
> **Behavior**: Round-10 regression fix. main.rs now composes `subcmd.profile.or(cli.profile)`.
>
> (Unqualified — no `auth switch` carve-out. Pre-#663, `--profile` was silently accepted on `auth switch` and had no effect on the switch target, its only side effect being an extra existence-check constraint inside `Config::load_with`. See research brief `.factory/research/bucket1-663-auth-switch-profile-2026-08-13.md` §1.4 for the confirmed no-op mechanism this reversed-to-rejection replaces.)

**Trace**: Pass 3 BC-030 (R1); F2 amended (2026-08-13, issue #663) — `auth switch` carve-out; see BC-1.2.047; F2 adversary pass-1 fix round (2026-08-13, LOW-2) — title/Behavior clarified so `List`/`Remove`'s direct-pass-through propagation is not misread as unaffected-by-omission; `Switch` remains the only subcommand where `--profile` is rejected rather than honored

---

#### BC-1.2.047: `auth switch --profile <X>` is rejected with exit 64 — the switch target is the positional `<NAME>` only

**Confidence**: HIGH
**Source**: `src/main.rs` (`AuthCommand::Switch` dispatch arm, guard fires before `Config::load_with`); `src/cli/auth/switch.rs::handle_switch`; research brief `.factory/research/bucket1-663-auth-switch-profile-2026-08-13.md`
**Subject**: Auth & Identity
**Origin**: NEW (issue #663)

**Description**: `auth switch` takes its target profile from the required positional `<NAME>` only — it has no subcommand-level `profile: Option<String>` field (unlike `Login`/`Status`/`Refresh`/`Logout`, each of which composes `subcmd.profile.or(cli.profile)` per BC-1.2.018). Before #663, the GLOBAL `--profile` flag (declared `global = true` on `Cli`, propagated by clap to every subcommand including `auth switch`) was silently accepted but had no effect on the switch target — its only observable side effect was forcing `Config::load_with`'s active-profile-existence check to additionally validate the flag's value, producing the confusing `jr auth switch --profile X X` incantation the issue reports. This BC replaces that silent no-op with an explicit rejection.

**Preconditions**:
1. `jr auth switch <NAME>` is invoked with the global `--profile` flag also supplied (`jr auth switch --profile <X> <NAME>`, in either flag/positional order).

**Postconditions**:
1. The guard fires in `src/main.rs`, in the `AuthCommand::Switch` dispatch arm, BEFORE `Config::load_with` is called — so a nonexistent `--profile` value does NOT first trip `Config::load_with`'s active-profile existence-check side effect. The rejection is unconditional on `cli.profile.is_some()`, independent of whether `<X>` or `<NAME>` name real profiles.
2. Exit code 64 (`JrError::UserError`).
3. **Human mode** (stderr): `--profile is not valid for 'auth switch'. The profile to activate is the positional argument. Try: jr auth switch <NAME>` — a fixed constant string, no value interpolation.
4. **`--output json`**: the standard `{"error": "<message>", "code": 64}` envelope (per the #526 JSON render invariant — no bespoke formatter; this flows through the same central error handler as every other exit-64 `UserError` in `jr`).
5. No config read/write and no keychain access occurs — the guard fires before any of `handle_switch`'s three steps (`Config::load_with`, `handle_switch_in_memory`, `config.save_global()`).

**Invariants**:
1. This guard is `Switch`-only. `AuthCommand::Login`/`Status`/`Refresh`/`Logout` are unaffected — each continues to compose `subcmd.profile.or(cli.profile)` exactly as BC-1.2.018 (amended) describes. `AuthCommand::List`/`Remove` are also unaffected — they continue to pass `cli.profile.as_deref()` straight through with no `.or()` composition (BC-1.2.018's LOW-2 clarification): `--profile` remains fully honored on both, never rejected.
2. The positional `<NAME>` remains the sole way to specify the switch target; this BC does not change `handle_switch_in_memory`'s write logic. BC-1.1.003's unknown-profile exit-64 path is unaffected — it fires on a bad positional; this BC fires on a supplied `--profile` flag regardless of positional validity.

**Edge Cases**:
- EC-1.2.047-1: `jr auth switch --profile foo foo` (both real profiles — the "confusing incantation" the issue reports) → still exits 64; the flag is rejected regardless of whether its value coincides with the positional or names a real profile.
- EC-1.2.047-2: `jr auth switch --profile bogus realprofile` → exits 64 on the `--profile` guard, NOT on a "bogus profile does not exist" message — the guard fires before any profile-existence check is reachable.
- EC-1.2.047-3: `jr auth switch realprofile --profile bogus` (flag supplied after the positional) → same exit-64 rejection; clap's global-arg parsing accepts either order, and the guard is order-independent (checks `cli.profile.is_some()`, not argument position).
- EC-1.2.047-4 (adversary pass-1 MEDIUM-2 — guard keys ONLY on the `--profile` FLAG, never on the resolved active profile / `JR_PROFILE` / config default): `JR_PROFILE=sandbox jr auth switch realprofile` (the global `--profile` FLAG is absent — only the `JR_PROFILE` environment variable is set) → NOT rejected; the guard checks `cli.profile.is_some()` only, which reflects solely whether the `--profile` CLI flag was passed, and is `None`/false regardless of `JR_PROFILE`, `config.default_profile`, or any other stage of the profile-resolution precedence chain (BC-1.1.007). The switch proceeds normally to `handle_switch_in_memory("realprofile")`, exit 0 on success. This is load-bearing for the direnv-scoped-sandbox workflow (CLAUDE.md: "combine with direnv to scope a repo to a sandbox site") — a directory-scoped `JR_PROFILE` export must not make `auth switch` unusable in that directory. Only an explicit `--profile` (or `--profile=X`) token on the command line trips the guard; `JR_PROFILE`, `.envrc`, and `config.toml`'s `default_profile` are all inert with respect to this guard by construction (`cli.profile` is populated exclusively from clap parsing the `--profile` argument — CLAUDE.md's documented precedence chain "flag > env > config > default" describes ACTIVE-PROFILE RESOLUTION, a separate concern from this guard's flag-presence check).
- EC-1.2.047-5 (NEW, adversary pass-4 INFO — syntactically-INVALID `--profile` value pre-empts this BC's guard): `jr auth switch --profile 'in!valid' realprofile` → still exits 64, but via a DIFFERENT, EARLIER check than this BC's guard: `config::validate_profile_name` (`src/config.rs`, called unconditionally from `run()` — `src/main.rs`, at the very top of `run()`, whenever `cli.profile.is_some()` — BEFORE the `match cli.command` dispatch that contains the `AuthCommand::Switch` arm this BC's guard lives in) rejects any `--profile` value containing characters outside `[a-zA-Z0-9_-]` with stderr `"Profile name contains invalid characters (use a-z, 0-9, -, _)"` — NOT this BC's `"--profile is not valid for 'auth switch'…"` message. Both paths exit 64 and both are triggered by the mere presence of `--profile` on `auth switch`, but the STDERR TEXT differs depending on whether the supplied value is syntactically valid: a syntactically-valid value (e.g. `--profile foo`) reaches this BC's Switch-arm guard and gets the "not valid for 'auth switch'" message (BC-1.2.047 Postcondition 3); a syntactically-INVALID value (e.g. `--profile 'in!valid'`) never reaches the Switch-arm guard at all — `validate_profile_name` rejects it first, with the charset message. Both exit-64 paths are correct and unambiguous once this ordering is understood; a test asserting the WRONG message for a charset-invalid `--profile` value on `auth switch` would be testing the wrong layer.

**Explicitly out of scope** (research brief §3, human-ruled): clap `conflicts_with = "profile"` as a belt-and-suspenders second layer — dropped from scope entirely; documented unreliable for `global = true` args (clap issues #5335, #5358) and incomplete for the flag-without-positional case, so it is not pursued even as a secondary defense. Usage-string full unification (`<NAME>` vs `[OPTIONS] <NAME>` vs the pre-#663 promoted third form) is accepted as universal, unavoidable clap behavior (inherent to `--help` vs missing-required-arg usage rendering) and is NOT pursued via `override_usage`.

**Verification Properties**:
- VP-663-001: `jr auth switch --profile foo foo` (both existing profiles) → exit 64; stderr contains `"--profile is not valid for 'auth switch'"`; no config file write (mtime unchanged); no keychain access.
- VP-663-002 (**[CORRECTED, adversary pass-3 HIGH-1]**): `jr auth switch --profile foo foo --output json` → exit 64; **stdout is EMPTY**; **stderr** parses as JSON; parsed object keys == `{"error", "code"}`; `code == 64`. Channel-separation invariant (#526), source-verified: `src/main.rs`'s error-exit handler uses `eprintln!` for the `OutputFormat::Json` arm — the envelope is never written to stdout. **Previous version (original F2 delta pass, INCORRECT from authoring, retained for audit trail — do NOT re-implement):** "stdout parses as JSON; parsed object keys == {\"error\", \"code\"}" — this VP was written with the wrong channel from its initial authoring (not a pass-2 regression — BC-1.2.047 Postcondition 4 itself was always channel-agnostic and correct); pass-3 (fresh context, source-verified against `src/main.rs` and `tests/common/assertions.rs::assert_json_error_envelope`) is the first pass to catch and correct it.
- VP-663-003 (adversary pass-1 MEDIUM-2, pins EC-1.2.047-4): with `JR_PROFILE=sandbox` set in the environment and NO `--profile` flag on the command line, `jr auth switch realprofile` → exit 0; `[profiles.default].default_profile` (or the config's active-profile pointer) is updated to `realprofile`; the exit-64 guard does NOT fire. Negative-space companion to VP-663-001/002: confirms the guard is flag-presence-gated, not resolved-profile-gated.

**Trace**: F2 spec evolution (2026-08-13, issue #663); research brief `.factory/research/bucket1-663-auth-switch-profile-2026-08-13.md` §3 Option 3 (recommended), §4; cross-reference BC-1.2.018 (amended sibling), BC-1.1.003 (unaffected sibling — unknown-profile positional path), BC-7.4.014 (unaffected — success-shape BC, this BC covers only the error path); F2 adversary pass-1 fix round (2026-08-13): EC-1.2.047-4 + VP-663-003 added (MEDIUM-2 — guard keys on the `--profile` flag only, never `JR_PROFILE`/config default, protecting the direnv-scoped-sandbox workflow); BC-1.2.018 title/Behavior clarified re: List/Remove propagation mechanism (LOW-2); F2 adversary pass-3 fix round (2026-08-13, fresh context): VP-663-002 corrected — it had the JSON error envelope on stdout since its original authoring; source-verified (`src/main.rs`'s error-exit handler, `tests/common/assertions.rs::assert_json_error_envelope`) that the envelope is on stderr, stdout empty, matching Postcondition 4's channel-agnostic wording, which was correct all along (HIGH-1); F2 adversary pass-4 fix round (2026-08-13): EC-1.2.047-5 added — pins that `config::validate_profile_name` (`src/main.rs`'s `run()`, before command dispatch) rejects a syntactically-invalid `--profile` value with the charset message BEFORE this BC's Switch-arm guard is ever reached, so a charset-invalid value never surfaces this BC's "not valid for 'auth switch'" message (INFO, source-verified against `src/config.rs::validate_profile_name`)

---

#### BC-1.2.048: Once `auth_method` is set at profile creation, no per-command flag changes which mechanism an invocation uses

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 5/§6; `.factory/STATE.md` DEC-313
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-313) — negative-space invariant

**Description**: `auth_method` is an intrinsic, per-profile property, not a per-invocation choice. This BC states the general "no per-command auth switch" invariant DEC-313 establishes; BC-1.2.051 states its specific, previously-non-compliant instance (`auth refresh --oauth`'s prior override power, now removed).

**Preconditions**:
1. A profile exists with `auth_method` already set (via `auth login`'s creation-time flow, BC-1.1.013/BC-1.1.014, or a prior `auth login` re-declaration).
2. Any `jr` subcommand operating against that profile is invoked, with or without a flag that historically could have implied a different mechanism (e.g. `--oauth`, `--api-token`).

**Postconditions**:
1. The invocation uses exactly the profile's stored `auth_method` — no flag on any command other than `auth login` itself changes which mechanism is used for that invocation.
2. The only way to change a profile's mechanism is to re-run `jr auth login <profile>` (interactively re-picking, or with `--oauth`/`--api-token` explicit) — a creation-time-shaped re-declaration, not a per-command override.

**Invariants**:
1. This invariant is scoped to *mechanism selection*, not credential *rotation* — `auth refresh` still rotates/relogs credentials for the profile's existing mechanism (BC-1.2.051); it just no longer changes which mechanism.

**Edge Cases**:
- EC-1.2.048-1: `--oauth`/`--api-token` supplied to a non-`login` command (e.g. `auth refresh`) → accepted syntactically (deprecated-alias parity, BC-1.2.049/050) but has zero effect on mechanism selection for that invocation (BC-1.2.051).

**Verification Properties**:
- **VP-AUTHDX-003 — `auth_method`-is-intrinsic invariant: no per-command mechanism override (SAFETY INVARIANT, PROMOTED 2026-09-01, F2 VP-delta pass, merges draft candidates VP-cycle3-005/010/011).** Property: for the full cross product of {profile's stored `auth_method` ∈ `{oauth, api_token}`} × {flag passed to `auth refresh` ∈ `{none, --oauth, --api-token}`}, the mechanism actually used by the invocation is ALWAYS the profile's stored `auth_method`, never the flag — specifically: an `api_token` profile with `--oauth` supplied never binds an OAuth callback listener and never launches a browser; an `oauth` profile with `--api-token` supplied never shows an api-token prompt. This is the general invariant this BC states; BC-1.2.051 documents its specific previously-non-compliant instance (the removed `chosen_flow_for_profile` override). Promoted because it is the central architectural guarantee DEC-313/DEC-321 introduce (auth mechanism as an intrinsic, non-overridable profile property) and a regression here silently reopens the exact security/UX defect (a flag forcing an unwanted OAuth browser flow or unwanted credential prompt) DEC-321 was written to close. **Verification method**: property test (`proptest`) over the 2×3 mechanism/flag matrix, asserting `actual_mechanism_used == profile.auth_method` and the associated no-browser/no-prompt side-effect predicates on every generated case; the two concrete cases from the original candidates (api_token profile + `--oauth`; oauth profile + `--api-token`) are retained as fixed regression seeds. **F6 target**: `src/cli/auth/mod.rs::chosen_flow_for_profile` (post-DEC-321 simplification/removal), `src/cli/auth/refresh.rs::refresh_credentials`.

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-313; ADR-0020 §Decision 5; cross-reference BC-1.2.051 (specific `auth refresh` resolution — VP-AUTHDX-003 declared here, cited not duplicated at BC-1.2.051), BC-1.1.013/014/015.

---

#### BC-1.2.049: `--oauth` on `auth login`/`auth refresh` is retained as a deprecated-but-accepted alias with a stderr-only deprecation notice

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 5; DEC-323
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-313/DEC-323)

**Description**: `--oauth` is not removed. It continues to function exactly as before (selects/declares the OAuth mechanism on `login`; is a syntactically-accepted no-op on mechanism selection on `refresh`, per BC-1.2.051), but now emits a one-line deprecation notice pointing at the new `--api-token`/creation-time-picker semantics. No removal date is set.

**Preconditions**:
1. `jr auth login --oauth …` or `jr auth refresh --oauth …` is invoked.

**Postconditions**:
1. Functional behavior is unchanged from pre-cycle-003 (`login`: selects OAuth; `refresh`: see BC-1.2.051 for its now-inert mechanism-override semantics).
2. A deprecation notice is written to **stderr only**, in human-output mode only — never emitted when `--output json` is set, and never written to stdout under any output mode (preserving the #526 JSON-render invariant).
3. Exit code and all other observable behavior (config writes, keychain writes, HTTP calls) are byte-for-byte unchanged from the pre-deprecation `--oauth` path.

**Invariants**:
1. No hard removal date exists for `--oauth` as of this cycle (F1 Open Question 4 remains open, by design — not resolved here).
2. Scripts/CI that already pass `--oauth` continue to succeed with identical exit codes and stdout; only stderr gains a new line in human mode.

**Edge Cases**:
- EC-1.2.049-1: `--oauth --output json` → no deprecation notice on stderr either — the notice is gated on OUTPUT FORMAT, not TTY-ness: `--output json` suppresses it regardless of interactivity, since a JSON consumer has no use for an unstructured stderr line and the notice must never contaminate scripted stderr-parsing either. (Documented explicitly so this isn't confused with a TTY-interactivity gate.)
- EC-1.2.049-2: `--oauth` combined with the new `--api-token` flag on the same invocation → mutually exclusive, clap-level rejection (exit 2), consistent with existing `conflicts_with` conventions on this CLI surface.

**Verification Properties**: None dedicated to this BC. **[TRIAGED 2026-09-01, F2 VP-delta pass]** The original draft candidates (deprecation notice absent under `--output json`; present on stderr in human mode) are output-channel/wording checks for one specific new CLI message — the same shape as the corpus's many existing channel-placement unit tests (e.g. BC-2.7.001's stderr truncation hints), not a cross-cutting property distinct from the general #526 JSON-render invariant this codebase already enforces architecturally. DEMOTED to two ordinary F4 test acceptance criteria anchored directly to this BC's Postcondition 2/EC-1.2.049-1 (test-writer implements as standard stdout/stderr capture assertions, one per output mode; no proptest/Kani/trybuild warranted).

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-313; DEC-323; ADR-0020 §Decision 5; cross-reference BC-1.2.015/016 (pre-existing `--oauth` flag-presence pins, unaffected), BC-1.2.050 (`--api-token` coequal flag), BC-1.2.051 (`refresh`'s specific inert-override behavior).

---

#### BC-1.2.050: `auth login`/`auth refresh` gain an explicit `--api-token` flag, symmetric with `--oauth`

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 5; DEC-323
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-323)

**Description**: A new, non-deprecated `--api-token` boolean flag is added to `LoginArgs`/`RefreshArgs` as `--oauth`'s coequal, explicit opt-in — resolving F1 Open Question 5 in favor of an explicit flag over interactive-picker-only creation-time selection. This gives non-interactive users an unambiguous way to declare `api_token` even when `JR_EMAIL`/`JR_API_TOKEN` are not yet set (e.g. scripting profile creation with `--email`/`--token` flags instead of env vars).

**Preconditions**:
1. `jr auth login --api-token [--profile <name>] [--url <url>] [--email <e>] [--token <t>]` is invoked.

**Postconditions**:
1. The mechanism-selection picker (BC-1.1.013) is skipped; `auth_method` is set to `api_token` directly.
2. On `auth login`, this flag behaves as the direct, symmetric counterpart to `--oauth` — both are accepted flags that fully bypass the interactive picker.
3. On `auth refresh`, `--api-token` is syntactically accepted (parity with `--oauth`'s BC-1.2.049 acceptance) but is a no-op on mechanism selection per BC-1.2.051/BC-1.2.048 — `refresh` always follows the profile's own stored `auth_method`.

**Invariants**:
1. `--api-token` and `--oauth` are mutually exclusive on the same invocation (clap `conflicts_with`, exit 2 on both present).
2. `--api-token` is NOT deprecated — it is the modern, non-legacy explicit-selection surface introduced alongside `--oauth`'s demotion.

**Edge Cases**:
- EC-1.2.050-1: `--api-token` supplied together with `--no-input` and complete `--email`/`--token` (or `JR_EMAIL`/`JR_API_TOKEN`) → succeeds identically to the pre-existing non-interactive path (BC-1.1.014), just with the mechanism now explicit rather than implied by non-interactivity alone.
- EC-1.2.050-2: `--api-token` supplied interactively with incomplete credentials → falls through to the existing interactive credential-prompt behavior for the api-token flow (unchanged).

**Verification Properties**: None dedicated to this BC. **[TRIAGED 2026-09-01, F2 VP-delta pass]** The original draft candidates are both ordinary example-based CLI tests, not invariants: (a) the explicit-flag-selection case is a specific instance already subsumed by VP-AUTHDX-001's non-interactive-never-browser property (BC-1.1.014) plus this BC's own Postcondition 1 — no independent property remains once that invariant is proven; (b) `--oauth`/`--api-token` mutual exclusion is a standard clap `conflicts_with` arity check, the same shape as many pre-existing mutually-exclusive flag pairs on this CLI surface (e.g. `--resolution`/`--no-resolution`, `--description`/`--description-stdin`) that this corpus has never elevated to VP status. DEMOTED to two ordinary F4 test acceptance criteria anchored directly to this BC's Postcondition 1 / Invariant 1 (test-writer implements as standard flag-combination unit tests).

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-323; ADR-0020 §Decision 5; cross-reference BC-1.1.013/014 (picker/non-interactive defaults this flag bypasses), BC-1.2.049 (`--oauth`'s parallel deprecated-alias contract).

---

#### BC-1.2.051: `auth refresh --oauth`/`--api-token` no longer override the profile's stored `auth_method` — refresh always follows the intrinsic mechanism

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 6; DEC-321; `src/cli/auth/mod.rs::chosen_flow_for_profile` (F4 target for removal/simplification)
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-321) — resolves F1 Open Question 8

**Description**: Pre-cycle-003, `chosen_flow_for_profile` let a per-invocation `--oauth` flag on `auth refresh` override the target profile's stored `auth_method` for that one call — the only place in the codebase where a per-command flag outranked a profile's intrinsic mechanism. DEC-321 removes this override entirely: `auth refresh` always follows the profile's own `auth_method`. Changing a profile's mechanism requires `auth login <profile>` re-declaration (BC-1.1.013's picker, or `--oauth`/`--api-token` explicit), never a `refresh`-time flag.

**Preconditions**:
1. A profile exists with a stored `auth_method` (`oauth` or `api_token`).
2. `jr auth refresh [--oauth | --api-token] <profile>` is invoked, where the supplied flag (if any) names a DIFFERENT mechanism than the profile's stored `auth_method`.

**Postconditions**:
1. `refresh`'s "clear-then-relogin" always re-logs in via the profile's own intrinsic `auth_method` — the supplied `--oauth`/`--api-token` flag has NO effect on which mechanism is used.
2. The flag is still syntactically accepted (no clap error) — this is a silent behavior narrowing, not a hard error, consistent with BC-1.2.049/050's deprecated/parity-alias framing. The flag additionally carries the same deprecation-notice contract as `login`'s `--oauth` (BC-1.2.049) when it is the legacy `--oauth` spelling; `--api-token` on `refresh` is non-deprecated parity per BC-1.2.050.
3. `chosen_flow_for_profile`'s prior `oauth_override: bool` behavior is removed — the function (if retained at all) resolves solely from the profile's stored `auth_method`.

**Invariants**:
1. This closes the sole pre-cycle-003 exception to "auth_method is intrinsic" (BC-1.2.048) — after this BC, there are zero per-command mechanism overrides anywhere in `jr`.

**Edge Cases**:
- EC-1.2.051-1: `jr auth refresh --oauth <profile>` where `<profile>.auth_method == "api_token"` → refresh proceeds as an api-token credential refresh/relogin; NO OAuth browser flow is launched. This is a documented, intentional behavior change from pre-cycle-003 (the flag previously WOULD have forced an OAuth relogin) — flagged as a breaking change in ADR-0020's Breaking-Change Acknowledgment.
- EC-1.2.051-2: `jr auth refresh <profile>` with no flag at all → unaffected; always followed the stored `auth_method` already.

**Verification Properties**: This BC's specific instances (an `api_token` profile with `refresh --oauth`; an `oauth` profile with `refresh --api-token`) are covered by **VP-AUTHDX-003**, declared at BC-1.2.048 (the general "`auth_method` is intrinsic" invariant this BC is the previously-non-compliant special case of) — not duplicated here. The original draft candidates VP-cycle3-010/011 were the two concrete generated-case seeds folded into VP-AUTHDX-003's proptest matrix at promotion time (2026-09-01, F2 VP-delta pass).

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-321; ADR-0020 §Decision 6 (resolves F1 delta analysis Open Question 8); cross-reference BC-1.2.048 (general invariant, VP-AUTHDX-003 declared there), BC-1.2.015/016 (pre-existing `--oauth`-on-refresh flag-presence pins — still true, only the override BEHAVIOR changes, not the flag's continued existence).

---

### 1.3 Embedded OAuth App

#### BC-1.3.019: Embedded OAuth app `Debug` redacts client_secret

**Confidence**: HIGH
**Source**: `src/api/auth_embedded.rs:~34, 220-239`
**Subject**: Auth & Identity
**Behavior**: `format!("{:?}", EmbeddedOAuthApp{...})` never emits plaintext secret. Custom Debug impl substitutes `<redacted>`. This is BC-1168 from Pass 3 R4.
**Trace**: Pass 3 BC-019; BC-1168 (R4)

---

#### BC-1.3.020: Build with empty XOR inputs → `embedded_oauth_app()` returns None

**Confidence**: HIGH
**Source**: `src/api/auth_embedded.rs:~100`
**Subject**: Auth & Identity
**Behavior**: Setting `JR_BUILD_OAUTH_CLIENT_ID=""` at build time → binary returns `None` from embedded accessor. BYO/prompt fallback proceeds.
**Trace**: Pass 3 BC-020

---

#### BC-1.3.021: `embedded_oauth_app_present()` checks presence without decoding

**Confidence**: HIGH
**Source**: `src/api/auth_embedded.rs:~132`
**Subject**: Auth & Identity
**Behavior**: Presence check inspects only `EMBEDDED_ID.is_some_and(|s| !s.is_empty())`. Does NOT invoke `decode()`. Used by `auth status` to report `OAuthAppSource::Embedded` without materializing plaintext.
**Trace**: Pass 3 BC-021; BC-022-R (R1)

---

#### BC-1.3.022: `OAuthAppSource` resolution chain: Flag > Env > Keychain > Embedded > Prompt > None

**Confidence**: HIGH (PROMOTED from MEDIUM in R1)
**Source**: `src/api/auth_embedded.rs:~46`; `src/cli/auth/status.rs::peek_oauth_app_source`
**Subject**: Auth & Identity
**Behavior**: First non-None-equivalent source wins; lower-priority sources never short-circuit higher. `auth status` reports source via this chain.
**Trace**: Pass 3 BC-022-R

---

#### BC-1.3.023: DEFAULT_OAUTH_SCOPES includes `offline_access`, CMDB scopes, `write:jira-work`, and `write:servicedesk-request`

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~34` (line 59 is the concat! literal site)
**Subject**: Auth & Identity
**Behavior**: DEFAULT_OAUTH_SCOPES is: `read:jira-work write:jira-work read:jira-user read:servicedesk-request write:servicedesk-request read:cmdb-object:jira read:cmdb-schema:jira offline_access`. The embedded `jr` OAuth app's Developer Console registration MUST include `write:servicedesk-request` or the authorize call will reject with `invalid_scope` for all new OAuth logins and token refreshes. The pinning test `default_oauth_scopes_pins_the_full_set_with_offline_access` in `src/cli/auth/tests/mod.rs` MUST be kept in lockstep with `auth.rs:~59` — it must be updated in the same commit as any change to the scope constant. Regression test asserts no double spaces and the full exact scope string.
**Effects**: Scope addition affects every OAuth-authenticated user on next token refresh or new login. CI cannot catch a Developer Console registration mismatch — manual staging validation is required before release when this constant is modified.

**Maintainer coordination:** when changing `DEFAULT_OAUTH_SCOPES`, the maintainer also updates the embedded `jr` OAuth app's permissions in the Atlassian Developer Console (https://developer.atlassian.com/console/myapps/ → My apps → jr → Permissions → Configure → Add) before tagging a release. Existing users will be prompted to re-consent on their next OAuth login or token refresh (Atlassian auto-handles this UX; see [Atlassian managing-OAuth-apps docs](https://developer.atlassian.com/cloud/oauth/getting-started/managing-oauth-apps/)). CHANGELOG entries for any release that changes this constant MUST mention the re-consent prompt so users aren't surprised. No CI hook, no PR template; the existing code comment at `src/api/auth.rs:~46` is the implementer-side reminder, the maintainer checklist lives in CLAUDE.md OAuth Gotcha section.

> **[UPDATED 2026-05-18 issue #288 + F1d pass-01 fix-applied + scope-simplified per research-validated risk profile]** `write:servicedesk-request` added to enable `jr issue create --request-type` JSM submission (BC-3.8.001).
> - **Previous (pre-#288):** Scope string was `read:jira-work write:jira-work read:jira-user read:servicedesk-request read:cmdb-object:jira read:cmdb-schema:jira offline_access` (no `write:servicedesk-request`).

**Trace**: Pass 3 BC-035 (R1); issue #288 F2 (2026-05-18); issue #288 F1d adversary pass-01 (2026-05-18 — release gate enforcement added); issue #288 F1d pass-01 scope-simplified (2026-05-18 — PR template gate removed per research-validated risk profile)

---

#### BC-1.3.024: Embedded OAuth integration test is `#[ignore]`-gated and stubs `unimplemented!()`

**Confidence**: HIGH
**Source**: `tests/oauth_embedded_login.rs:~13`
**Subject**: Auth & Identity
**Behavior**: Test intentionally `unimplemented!()` when `JR_RUN_OAUTH_INTEGRATION=1`. Without that env var, test early-returns. Guards against false coverage signals.
**Trace**: Pass 3 BC-028 (R1)

---

### 1.4 Token Keychain Layout

#### BC-1.4.025: `default` profile lazy-migrates legacy flat OAuth keys; non-default profiles never inherit

**STATUS: AMENDED (2026-09-01, cycle-003 `auth-profile-dx`, DEC-315)** — adds a regression-confirmation clause: this OAuth-token migration's own code and behavior are UNCHANGED by cycle-003; a separate, sibling migration for API-token credentials is added alongside it (BC-1.4.032), not merged into it.

**Confidence**: HIGH (PROMOTED from MEDIUM in R1)
**Source**: `src/api/auth.rs:~111`
**Subject**: Auth & Identity
**Behavior**: `load_oauth_tokens(profile)`: if both namespaced keys present → return. If both missing → ONLY `"default"` reads legacy flat keys, copies to namespaced, deletes legacy. Non-default profiles error on partial state with actionable message. Two `if profile == "default"` guards at lines 124 and 151.
**Regression confirmation (cycle-003)**: this function and its test suite (`auth.rs::tests`, dedicated unit tests covering default-partial-recovery and non-default non-inheritance) are explicitly a MUST-NOT-TOUCH regression baseline for cycle-003 — the new API-token migration (BC-1.4.032) mirrors this function's PATTERN in a separate, sibling function, never by modifying `load_oauth_tokens` itself. A diff-zero regression check against this function's existing test suite is a mandatory CI gate for any cycle-003 PR touching `src/api/auth.rs`.
**Trace**: Pass 3 BC-023-R; F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01) — regression-confirmation clause added; cross-reference BC-1.4.032 (the new, sibling API-token migration this BC's pattern is mirrored into, not merged with).

---

#### BC-1.4.026: `refresh_oauth_token` signature is `(profile: &str)` only — resolves credentials internally

**Confidence**: HIGH (PROMOTED from LOW in R1)
**Source**: `src/api/auth.rs:~700`; CLAUDE.md
**Subject**: Auth & Identity
**Behavior**: Function takes only `profile: &str`. Internally resolves keychain → embedded. No production callers as of v0.5.0-dev.7 — exists for future 401 auto-refresh. Re-introducing `client_id/_secret` would break embedded-OAuth path.
**Trace**: Pass 3 BC-024-R

---

#### BC-1.4.027: Per-profile keychain keys: `<profile>:oauth-access-token` / `<profile>:oauth-refresh-token`; `<profile>:email` / `<profile>:api-token`

**STATUS: AMENDED (2026-09-01, cycle-003 `auth-profile-dx`, DEC-315)** — the previous "Shared keys… are NOT namespaced" claim becomes FALSE for `email`/`api-token`, which are now namespaced per-profile (BC-1.4.031). Only `oauth_client_id`/`oauth_client_secret` (the BYO **OAuth app**-credential pair) remain shared/flat — a genuinely different axis (one OAuth app registration per keychain, not per profile).

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~24`; ADR-0020 §Decision 1
**Subject**: Auth & Identity
**Behavior**: All OAuth token storage/retrieval uses namespaced keys (`<profile>:oauth-access-token`/`-refresh-token`). All API-token credential storage/retrieval ALSO uses namespaced keys (`<profile>:email`/`<profile>:api-token`, DEC-315) — symmetric with the OAuth pair. The ONLY remaining shared/flat keychain keys are `oauth_client_id` and `oauth_client_secret` (the BYO OAuth **app** credential pair, explicitly out of scope for DEC-315's per-profile restructuring, since a BYO app registration is inherently one-per-keychain).

**Previous version (superseded by DEC-315, retained for audit trail):**
> **Behavior**: All OAuth token storage/retrieval uses namespaced keys. Shared keys (`email`, `api-token`, `oauth_client_id`, `oauth_client_secret`) are NOT namespaced.

**Trace**: Pass 3 BC-1153 (R4); F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01, DEC-315) — split shared-vs-namespaced claim; ADR-0020 §Decision 1; cross-reference BC-1.4.031 (new per-profile API-token functions), BC-1.4.030 (unaffected — governs the still-shared OAuth **app**-credential resolver).

---

#### BC-1.4.028: `load_oauth_tokens` errors on PARTIAL state (one token present, other missing)

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~1249`
**Subject**: Auth & Identity
**Behavior**: Access-token without refresh-token (or vice versa) → `Err`. Prevents silent half-credential use.
**Trace**: Pass 3 BC-1156 (R4)

---

#### BC-1.4.029: `load_oauth_tokens("sandbox")` does NOT inherit legacy flat keys

**STATUS: AMENDED (2026-09-01, cycle-003 `auth-profile-dx`, DEC-315)** — adds a cross-reference confirming the identical non-inheritance guarantee holds for the new per-profile API-token reader.

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~1323`; ADR-0020 §Decision 2
**Subject**: Auth & Identity
**Behavior**: Lazy migration is `default`-profile-only by design. "sandbox" only reads `sandbox:oauth-*` namespaced keys.
**Cross-reference (cycle-003)**: the identical guarantee holds for `load_api_token`: `load_api_token("sandbox")` only ever reads `sandbox:email`/`sandbox:api-token` namespaced keys and never inherits the legacy flat `email`/`api-token` pair, regardless of whether that legacy pair still exists in the keychain (BC-1.4.032 EC-1.4.032-3).
**Trace**: Pass 3 BC-1158 (R4); F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01) — cross-reference added; see BC-1.4.032 for the new function's own non-inheritance contract.

---

#### BC-1.4.030: `resolve_refresh_app_credentials` prefers KEYCHAIN over EMBEDDED

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~1347`
**Subject**: Auth & Identity
**Behavior**: BYO user does NOT silently flip onto embedded mid-session. Keychain wins.
**Trace**: Pass 3 BC-1159 (R4)

---

#### BC-1.4.031: Per-profile API-token keychain storage: `store_api_token(profile, …)` / `load_api_token(profile)`

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 1; DEC-315; `src/api/auth.rs` (F4 target — new functions, mirroring `store_oauth_tokens`/`load_oauth_tokens`)
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-315)

**Description**: API-token credentials (`email`, `api-token`) move from shared, account-level flat keychain keys to per-profile-namespaced keys (`<profile>:email`, `<profile>:api-token`), symmetric with the OAuth token pair's existing `<profile>:oauth-access-token`/`-refresh-token` namespacing (BC-1.4.027, amended). This reverses the mixed-scoping invariant BC-1.4.027 previously documented as intentional.

**Preconditions**:
1. `store_api_token(profile, email, token)` is called for a given profile (typically from `login_token`, `src/cli/auth/login.rs`).

**Postconditions**:
1. `email` is stored under key `<profile>:email`; `token` is stored under key `<profile>:api-token`.
2. `load_api_token(profile)` reads back the SAME namespaced pair — no shared/flat fallback for a profile whose namespaced keys are already present.
3. `JiraClient::from_config`'s `api_token` branch (`load_auth_from_keychain`) reads via `load_api_token(profile_name)`, never the old flat-key reader.
4. The shared/flat `oauth_client_id`/`oauth_client_secret` keys (the BYO **OAuth app** credential pair — a different axis) are explicitly OUT of scope and remain shared/flat; this BC does not touch them.

**Invariants**:
1. This is a straight signature change (profile-scoped, mirroring the OAuth pair byte-for-byte in shape) — not a new storage backend or isolation boundary (Windows Credential Manager posture, SEC-WCM-DOC, is unaffected).
2. Two profiles with distinct `auth_method: api_token` never share a credential pair — each profile's `load_api_token` reads only its own namespaced keys (barring the one-time `"default"` migration, BC-1.4.032).

**Edge Cases**:
- EC-1.4.031-1: a brand-new profile with no namespaced keys and no legacy flat keys present (and not `"default"`) → `load_api_token` returns the same actionable "no stored credential, run `jr auth login`" error `load_oauth_tokens` already produces for its non-default absent case (BC-1.4.025's error shape, mirrored).

**Verification Properties**:
- **VP-AUTHDX-004 — Per-profile API-token store/load round-trip + cross-profile credential isolation (SECURITY INVARIANT, PROMOTED 2026-09-01, F2 VP-delta pass, merges draft candidates VP-cycle3-012/013).** Two properties, both strengthened by this cycle's per-profile namespacing: (1) **Round-trip correctness**: for ANY profile name and ANY `(email, token)` string pair (including empty strings, unicode, and strings containing keychain-hostile characters), `store_api_token(profile, email, token)` followed by `load_api_token(profile)` returns exactly `(email, token)`, and the keychain contains the namespaced pair `<profile>:email`/`<profile>:api-token`, never a flat `email`/`api-token` pair. (2) **Cross-profile isolation**: for ANY two distinct profile names `p1 ≠ p2`, after `store_api_token(p1, e1, t1)`, `load_api_token(p2)` NEVER returns `(e1, t1)` (nor any component of it) — a profile's credentials are never observable from another profile's read path. Promoted because credential cross-contamination is a security-relevant defect class (sandbox/prod credential bleed), not merely a correctness bug, and the round-trip property is the foundational correctness guarantee every other BC in this cluster (migration, partial-state) depends on. **Verification method**: property test (`proptest`, arbitrary profile-name and credential-string generators) for both properties; a keyring-gated integration test (`JR_RUN_KEYRING_TESTS=1`, pattern: existing `#[ignore]`-gated tests) proving the property against the REAL OS keychain backend, not just an in-memory double, mirroring BC-6.2.009/010's existing cross-profile cache-isolation test pattern. **F6 target**: `src/api/auth.rs::store_api_token`/`load_api_token` (new functions).

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-315; ADR-0020 §Decision 1; cross-reference BC-1.4.027 (AMENDED sibling — the "NOT namespaced" claim this BC reverses for email/api-token specifically), ADR-0007 (the per-profile-data precedent this ADR extends from config fields to keychain credentials).

---

#### BC-1.4.032: One-time lazy migration of shared flat `email`/`api-token` → `<default>:email`/`<default>:api-token`

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 2; DEC-315; `src/api/auth.rs::load_oauth_tokens` (pattern this migration mirrors)
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-315) — highest-risk new contract in the cycle (F1 delta analysis §3)

**Description**: `load_api_token(profile)` mirrors `load_oauth_tokens`'s exact `"default"`-only lazy migration discipline: try namespaced keys first; if both absent AND `profile == "default"`, read and copy the legacy flat pair, best-effort-delete the legacy pair, and return the copied values. Any other profile's absent namespaced keys surface the standard actionable error, never a silent misread or cross-profile inheritance.

**Preconditions**:
1. Keychain holds a legacy flat `email`/`api-token` pair (pre-cycle-003 state) and NO `default:email`/`default:api-token` namespaced pair yet.
2. `load_api_token("default")` is called (first read after upgrading to a cycle-003-or-later binary).

**Postconditions**:
1. The legacy flat pair is copied to `default:email`/`default:api-token`.
2. The legacy flat pair is best-effort deleted (`Ok(()) | Err(NoEntry)` both treated as success — matching `load_oauth_tokens`'s delete semantics; a delete failure does not fail the read).
3. The function returns the copied `(email, token)` values — the caller (`from_config`) proceeds identically to a pre-migration read.
4. **Idempotency**: a second `load_api_token("default")` call short-circuits at the namespaced-keys-present check — no-op, byte-identical result, no further legacy-key access attempted.
5. **Scope discipline**: any profile OTHER than `"default"` with absent namespaced keys does NOT read the legacy flat pair — it surfaces the standard "no stored credential" error instead, exactly as `load_oauth_tokens` already does for non-default profiles.
6. This migration fires ONLY for `api_token`-method profiles reading via `load_api_token` — it never fires for, reads, or conflates with the separate OAuth-token migration (`load_oauth_tokens`), which operates on entirely different keys.

**Invariants**:
1. No eager, config-load-time migration — this is lazy, on first read only, unlike the eager TOML `[instance]`→`[profiles.default]` migration (which must run before any profile is resolvable at all; this migration has no such ordering dependency).
2. Backward compat/rollback posture is identical to the existing OAuth-token migration: no automated rollback; a user reverting to a pre-cycle-003 binary after migration has run must re-run `jr auth login` (the legacy flat keys are already deleted). This is an ACCEPTED, pre-existing posture (already documented for the OAuth migration in `docs/specs/multi-profile-auth.md`'s "Rollback story (manual only)"), not a new risk this BC introduces.

**Edge Cases**:
- EC-1.4.032-1 (partial-state — see also BC-1.4.033): legacy flat `email` present but `api-token` absent (or vice versa) → NOT copied silently; see BC-1.4.033 for the dedicated partial-state contract.
- EC-1.4.032-2: `"default"` profile already has namespaced keys (e.g. from a fresh `jr auth login` on a cycle-003-or-later binary, never having had legacy flat keys) → migration path is never entered; behaves identically to BC-1.4.031's ordinary namespaced read.
- EC-1.4.032-3: a non-`"default"` profile (e.g. `"sandbox"`) with absent namespaced keys, while a legacy flat pair STILL exists in the keychain (never migrated because `"default"` was never read) → `sandbox` does NOT inherit the legacy pair; it surfaces the standard non-default absent-credential error (mirrors BC-1.4.029's OAuth-equivalent non-inheritance guarantee).

**Verification Properties**:
- **VP-AUTHDX-005 — Migration correctness + idempotency (SAFETY-CRITICAL PROPERTY, PROMOTED 2026-09-01, F2 VP-delta pass, merges draft candidates VP-cycle3-014/015).** Property: for ANY legacy flat `(email, token)` string pair pre-seeded in the keychain, (a) **correctness**: the first `load_api_token("default")` call returns exactly the seeded pair, `default:email`/`default:api-token` now hold that same pair, and the legacy flat pair is gone; (b) **idempotency**: every SUBSEQUENT `load_api_token("default")` call is a value-identical no-op — same returned pair, byte-for-byte, with no further legacy-key access attempted (the namespaced-keys-present short-circuit at Postcondition 4 fires unconditionally). This is the F1 delta-analysis §3 HIGH-regression-risk item's core correctness proof: a bug here means either silent auth failure on upgrade or a security-relevant leak if migration copies to the wrong profile. **Verification method**: property test (`proptest`, arbitrary legacy email/token strings) for (a); a repeated-call harness (call twice/thrice in sequence, assert result and keychain-access-count are stable after the first call) for (b), direct-ported from `load_oauth_tokens`'s existing idempotency proof pattern (BC-6.1.002-equivalent for the OAuth sibling). **F6 target**: `src/api/auth.rs::load_api_token` (new function, mirroring `load_oauth_tokens`).
- **VP-AUTHDX-006 — `"default"`-only migration scope + non-default non-inheritance (SAFETY INVARIANT, PROMOTED 2026-09-01, F2 VP-delta pass, was VP-cycle3-016).** Property: for ANY profile name `p ≠ "default"` with absent namespaced keys, EVEN WHEN a complete legacy flat pair still exists in the keychain, `load_api_token(p)` NEVER reads, copies, or is influenced by the legacy pair — it surfaces the standard actionable "no stored credential" error, and the legacy flat pair is left byte-for-byte UNCHANGED (not partially or fully consumed). Promoted because this is the safety boundary preventing a non-default profile (e.g. a sandbox) from silently inheriting a different environment's (e.g. production's) credentials — exactly the class of cross-environment credential leak this per-profile restructuring exists to prevent, mirroring `load_oauth_tokens`'s already-proven non-inheritance guarantee (BC-1.4.029). **Verification method**: property test (`proptest`, arbitrary non-`"default"` profile names) asserting the error-and-untouched-legacy-pair invariant holds for every generated name. **F6 target**: `src/api/auth.rs::load_api_token`.
- **VP-AUTHDX-007 — Keyring-gated end-to-end migration proof (PROMOTED 2026-09-01, F2 VP-delta pass, was VP-cycle3-017).** Scenario: pre-cycle-003 shared keys present in the REAL OS keychain → first post-upgrade `jr` invocation against `"default"` → `default:*` populated, shared keys deleted, a `"sandbox"` profile (if configured) is unaffected. Promoted (rather than left as an ordinary integration test) because F1 delta-analysis §3 names this exact end-to-end proof as one of the three MANDATORY new tests for the cycle's highest-risk item — unit-level property tests (VP-AUTHDX-005/006) prove the logic against a mocked/in-memory keychain double; this VP is the only one in the cluster that proves the SAME logic against the real, non-mockable OS keychain backend (macOS Keychain / Windows Credential Manager / Linux Secret Service), which is where a platform-specific serialization or timing defect would actually surface. **Verification method**: keyring-gated integration test (`#[ignore]`, `JR_RUN_KEYRING_TESTS=1`), pattern: existing gated tests in `src/api/auth.rs`/`tests/oauth_refresh_integration.rs`. **F6 target**: `src/api/auth.rs::load_api_token` against the real keyring backend.

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-315; ADR-0020 §Decision 2; F1 delta analysis §3 (HIGH regression risk) and §4.1 (migration surface); cross-reference BC-1.4.025 (AMENDED — the OAuth-token migration this BC's shape is direct-ported from, explicitly confirmed UNCHANGED by this cycle), BC-1.4.028 (OAuth partial-state `Err` pattern), BC-1.4.033 (this migration's own partial-state instance).

---

#### BC-1.4.033: Partial-state handling for the per-profile API-token pair (one of `email`/`api-token` present, the other absent)

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 2 (item 4); DEC-315; `src/api/auth.rs::load_oauth_tokens`'s partial-state pattern (BC-1.4.028, mirrored)
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-315)

**Description**: Mirrors BC-1.4.028's OAuth partial-state `Err` contract for the new credential pair: an inconsistent keychain state (one of the two keys present, the other missing) must never be silently treated as "no credential" or silently proceed with a half-credential — it must surface a clear, actionable error.

**Preconditions**:
1. For a namespaced pair (`<profile>:email`/`<profile>:api-token`), exactly one of the two keys is present and the other is absent.
2. OR, for the `"default"`-only legacy-recovery path (BC-1.4.032), exactly one of the legacy flat `email`/`api-token` keys is present and the other is absent.

**Postconditions**:
1. `load_api_token(profile)` returns `Err` — never a silently-incomplete `Ok` with a placeholder/empty value for the missing field.
2. The error message is actionable: it directs the user to restore a clean state, e.g. "run `jr auth logout`/`jr auth login` to restore a clean state" (mirroring the wording style ADR-0020 §Decision 2 item 4 specifies), not a generic keychain-access failure message.
3. For the `"default"`-legacy-partial case specifically: NO copy/migration is attempted with the incomplete pair — migration only proceeds when BOTH legacy keys are present (BC-1.4.032 Precondition 1).

**Invariants**:
1. Same failure-mode philosophy as BC-1.4.028: prevents silent half-credential use, which could otherwise produce a confusing downstream 401 rather than a clear upfront diagnostic.

**Edge Cases**:
- EC-1.4.033-1: `default:email` present, `default:api-token` absent, AND a complete legacy flat pair also exists → the namespaced partial state takes precedence (namespaced keys are checked first per BC-1.4.031 Postcondition 2) — this surfaces the partial-state `Err`, it does NOT fall through to reading the legacy pair (which would silently ignore the corrupted namespaced state).

**Verification Properties**:
- **VP-AUTHDX-008 — No-half-credential safety invariant, namespaced + legacy partial states (SAFETY INVARIANT, PROMOTED 2026-09-01, F2 VP-delta pass, merges draft candidates VP-cycle3-018/019).** Property: for ANY of the four partial-state combinations — {namespaced pair, legacy flat pair} × {`email` present/`api-token` absent, `api-token` present/`email` absent} — `load_api_token(profile)` ALWAYS returns `Err` with the actionable restore-a-clean-state message, NEVER a panic and NEVER a silently-incomplete `Ok` with a placeholder/empty value; for the legacy-partial sub-case specifically, no copy/migration is attempted and no namespaced keys are written (migration does not partially execute). Promoted because a silent half-credential `Ok` is the exact failure mode that produces a confusing downstream 401 instead of a clear upfront diagnostic (same philosophy as BC-1.4.028's OAuth partial-state `Err`, which this BC mirrors) — this is a data-integrity safety net for a HIGH-regression-risk migration path (F1 §3), not an ordinary example-based error-message test. **Verification method**: property test (`proptest`) over the 2×2 partial-state matrix, asserting `Err` + no-write-side-effects on every generated case; the exact message-substring assertion is retained as a fixed regression seed. **F6 target**: `src/api/auth.rs::load_api_token`.

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-315; ADR-0020 §Decision 2 item 4; cross-reference BC-1.4.028 (OAuth partial-state pattern this BC mirrors), BC-1.4.032 (the migration this partial-state guard protects).

---

### 1.5 OAuth State Machine

#### BC-1.5.031: Embedded OAuth callback URL is exactly `http://127.0.0.1:53682/callback`

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~374`; CLAUDE.md; ADR-0006
**Subject**: Auth & Identity
**Behavior**: `EMBEDDED_CALLBACK_PORT: u16 = 53682`. IPv4 literal `127.0.0.1` (NOT `localhost` — avoids macOS/Chrome `localhost`→`::1` resolver pitfall). Atlassian validates `redirect_uri` by EXACT string match. Changing this is a breaking release.
**Trace**: Pass 3 BC-031 (R1); BC-1140/1141 (R4)

---

#### BC-1.5.032: `RedirectUriStrategyRequest::Fixed(p)` produces EADDRINUSE friendly error

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~427`
**Subject**: Auth & Identity
**Behavior**: On port-in-use: `"port {p} is in use; the jr OAuth callback needs this port. Set --client-id/--client-secret (or set JR_OAUTH_CLIENT_ID/JR_OAUTH_CLIENT_SECRET) to fall back to a dynamic port."` Contains 5 substrings: `port 53682 is in use`, `the jr OAuth callback needs this port`, `--client-id/--client-secret`, `JR_OAUTH_CLIENT_ID/JR_OAUTH_CLIENT_SECRET`, `dynamic port`.
**Trace**: Pass 3 BC-032 (R1); BC-1161 (R4)

---

#### BC-1.5.033: `ResolvedRedirect` private fields prevent listener detachment from strategy

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~455`
**Subject**: Auth & Identity
**Behavior**: Type-system-enforced TOCTOU-closure. Caller cannot move listener out and derive a redirect_uri from strategy that no longer matches.
**Trace**: Pass 3 BC-033 (R1)

---

#### BC-1.5.034: BYO OAuth uses `DynamicPort` (dynamic `:0`); embedded uses `FixedPort(53682)`

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~927`
**Subject**: Auth & Identity
**Behavior**: `RedirectUriStrategy::FixedPort(53682).redirect_uri() == "http://127.0.0.1:53682/callback"` (IPv4). `DynamicPort(54321).redirect_uri() == "http://localhost:54321/callback"` (localhost). The two literals differ; Atlassian validates by exact match.
**Trace**: Pass 3 BC-1140 (R4)

---

#### BC-1.5.035: `generate_state()` produces 32 bytes from SysRng encoded as 64 hex chars

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~882`; Pass 3 R4 §3.10
**Subject**: Auth & Identity
**Behavior**: CSRF state token generation. State is validated at callback step.
**Trace**: Pass 3 BC-1146 (R4)

---

#### BC-1.5.036: OAuth flow has NO PKCE (`code_challenge`/`code_verifier` absent)

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~608`
**Subject**: Auth & Identity
**Behavior**: `build_authorize_url` does not include PKCE parameters. NFR-S-A (MEDIUM): defense-in-depth gap per RFC 8252. Documented as POLICY-DECISION.
**Trace**: Pass 3 BC-1148, BC-1149 (R4)

---

#### BC-1.5.037: `build_authorize_url` percent-encodes hostile `client_id` containing injection chars

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~1043`
**Subject**: Auth & Identity
**Behavior**: `client_id` containing `&redirect_uri=evil.example#frag` → output has `client_id=real_id%26redirect_uri%3Devil.example%23frag` and MUST NOT contain `&redirect_uri=evil.example`.
**Trace**: Pass 3 BC-1149 (R4); Top-30 BC rank #2

---

#### BC-1.5.038: `accessible_resources` first-wins for cloud_id discovery (silent first-only)

**Confidence**: HIGH
**Source**: Pass 3 R4 §3.10; `src/api/auth.rs`
**Subject**: Auth & Identity
**Behavior**: After token exchange, `accessible_resources.first()` is used for cloud_id. No prompt if multiple sites — first is silently used (NEW-INV-179).
**Trace**: Pass 3 BC-1176 (R4)

---

#### BC-1.5.039: OAuth token stored as `<profile>:oauth-access-token` and `<profile>:oauth-refresh-token` post-login

**Confidence**: HIGH
**Source**: `src/api/auth.rs` (post-exchange persistence)
**Subject**: Auth & Identity
**Behavior**: Tokens are namespaced to profile. Profile config written post-storage.
**Trace**: Pass 3 BC-1151 (R4)

---

#### BC-1.5.040: OAuth callback validates state (CSRF check) before token exchange

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~898`; Pass 3 R4 §3.10
**Subject**: Auth & Identity
**Behavior**: State mismatch → abort with error; keychain NOT touched.
**Trace**: Pass 3 H-047 (holdout)

---

#### BC-1.5.041: `extract_query_param` parses `code` and `state` from HTTP GET request line

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~948`
**Subject**: Auth & Identity
**Behavior**: `extract_query_param("GET /callback?code=abc123&state=xyz HTTP/1.1\r\n", "code")` → `Some("abc123")`. Missing param → `None`. No query string → `None`.
**Trace**: Pass 3 BC-1142, BC-1143, BC-1144 (R4)

---

### 1.6 Auth Error Handling & 401 Dispatch

#### BC-1.6.042: 401 + `scope does not match` body → InsufficientScope with 5 required substrings

**Confidence**: HIGH
**Source**: `tests/api_client.rs:~99`
**Subject**: Auth & Identity
**Behavior**: 401 body containing `scope does not match` (case-insensitive) → `JrError::InsufficientScope`. Display MUST contain: `Insufficient token scope`, raw gateway message, **the resolved required scope name** (`write:jira-work` when `required_scope` is `None`, otherwise the call-site-supplied scope name such as `write:servicedesk-request`), `OAuth 2.0`, `github.com/Zious11/jira-cli/issues/185`. Exit code 2.

**Empty-Some policy:** Construction sites MUST pass either `None` or `Some(s)` where `s` is a non-empty ASCII scope name. To enforce this defensively, the Display impl treats `Some("")` identically to `None` — i.e., falls back to `write:jira-work`. The thiserror template MUST use `.filter(|s| !s.is_empty())` between `as_deref()` and `unwrap_or` to enforce this. A unit test MUST pin `Some("")` → fallback behavior.

**Trace**: Pass 3 BC-015; BC-1085 (R4); Top-30 BC rank #1
**Change**: [MODIFIED 2026-05-19 issue #382] Parameterized substring #3 to support runtime-resolved scope name via `JrError::InsufficientScope { required_scope: Option<String> }` field. Backward-compatible: `None` branch preserves historical literal `write:jira-work`. [MODIFIED 2026-05-19 issue #382 pass-02] Added Empty-Some policy: Some("") treated as None per defensive fallback.

---

#### BC-1.6.043: 401 without scope-mismatch substring → NotAuthenticated, NOT InsufficientScope

**Confidence**: HIGH
**Source**: `tests/api_client.rs:~146`
**Subject**: Auth & Identity
**Behavior**: 401 with `Session expired` body → `Not authenticated`. MUST NOT contain `Insufficient token scope`.
**Trace**: Pass 3 BC-016; BC-1086 (R4)

---

#### BC-1.6.044: 401 scope-mismatch match is case-insensitive (`to_ascii_lowercase`)

**Confidence**: HIGH
**Source**: `tests/api_client.rs:~183`
**Subject**: Auth & Identity
**Behavior**: `"Unauthorized; Scope Does Not Match"` (mixed case) → InsufficientScope.
**Trace**: Pass 3 BC-017; BC-1087 (R4)

---

#### BC-1.6.045: Non-401 status with scope-mismatch substring does NOT dispatch to InsufficientScope

**Confidence**: HIGH
**Source**: `tests/api_client.rs:~219`
**Subject**: Auth & Identity
**Behavior**: 403 with `scope does not match policy` → `API error (403)`, NOT InsufficientScope. Status gate prevents broadening.
**Trace**: Pass 3 BC-018; BC-1088 (R4)

---

#### BC-1.6.046: `auth list` table snapshot: 5 columns (NAME, URL, ENV, AUTH, STATUS), active profile with `* ` prefix

**STATUS: AMENDED (2026-09-01, cycle-003 `auth-profile-dx`, DEC-324) — DELIBERATE, ACKNOWLEDGED BREAKING CHANGE** to the previously-pinned 4-column insta-snapshot. The `env` tag (DEC-314) is added as a table column rather than left JSON-only, resolving F1 Open Question 7 at the architecture level (ADR-0020 §Decision 4): the tag's entire purpose — distinguishing prod/sandbox/uat profiles at a glance — is defeated if it is invisible in the one place a human scans all profiles side-by-side.

**Confidence**: HIGH
**Source**: `src/cli/auth/tests/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` (snapshot regeneration is an F4 implementation-story deliverable, not performed by this F2 spec pass); ADR-0020 §Decision 4
**Subject**: Auth & Identity
**Behavior**: Columns: `NAME, URL, ENV, AUTH, STATUS` — `ENV` inserted between `URL` and `AUTH` (grouping the two profile-identity/environment-facing columns before the two mechanism/health columns). Active profile prefixed `* ` (asterisk-space). Inactive: `  ` (2 spaces). `ENV` cell shows the profile's `env` value verbatim when set, or an empty/placeholder cell (exact placeholder text — e.g. blank vs. `-` — is an F4 implementation-story detail, not fixed by this BC) when unset. 3-profile fixture (to be extended in F4 with at least one `env`-tagged profile): default* (api_token), sandbox (oauth), staging (api_token). All STATUS cells `configured`.

**Previous version (superseded by DEC-324, retained for audit trail):**
> **Behavior**: Columns: `NAME, URL, AUTH, STATUS`. Active profile prefixed `* ` (asterisk-space). Inactive: `  ` (2 spaces). 3-profile fixture: default* (api_token), sandbox (oauth), staging (api_token). All STATUS cells `configured`.

**Trace**: Pass 3 BC-1115 (R4); F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01, DEC-314/DEC-324) — 5th column added, ADR-0020 §Decision 4 resolves F1 Open Question 7; cross-reference BC-1.6.047 (new — the JSON-shape sibling contract for `env` display); the actual insta snapshot file is regenerated as part of the F4 implementing story, not by this spec pass. **Cross-ref confirmed (integrate pass, 2026-09-01):** bc-6's BC-6.1.015 (`ProfileConfig.env: Option<String>`, `bc-6-config-cache.md` §6.1) cites this BC and BC-1.6.047 as its display-layer consumers (see its "Cross-reference (bc-1, not authored here)" clause).

---

#### BC-1.6.047: `env` tag is surfaced unconditionally in `auth list --output json` and `auth status` JSON/text output

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 4; DEC-314; DEC-324
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-314/DEC-324)

**Description**: The additive `env`/role tag (schema field itself owned by bc-6's config-schema BCs — cross-ref TODO for the integrate pass) is surfaced in every profile-listing/status output path. This BC covers the JSON-shape contract; BC-1.6.046 (amended) covers the human-table column contract specifically for `auth list`.

**Preconditions**:
1. At least one configured profile exists, with `env` set to some string or left unset (`None`).

**Postconditions**:
1. `jr auth list --output json` includes an `"env"` key for every profile object: the configured string value when set, or JSON `null` when unset/absent. The key is never OMITTED — every profile object carries the key, only its value varies.
2. `jr auth status` (JSON and human-text modes alike, for whichever profile(s) it reports on) surfaces the same `env` value using the same "present with `null` for unset" convention — no divergence between `list` and `status`'s JSON shapes for this field.
3. An old `config.toml` profile entry predating the `env` field deserializes with `env: None` and is displayed identically to a profile that explicitly has no `env` tag set — no migration-required distinction is observable to the user.

**Invariants**:
1. No enum/allowlist validation is imposed on `env`'s value at the display layer — whatever string (or absence) the config carries is echoed verbatim; `prod`/`sandbox`/`uat` are examples, not an exhaustive set (ADR-0020 §Decision 4).
2. `env` is a human-readable label only — it is NOT an access-control boundary; `url` remains the actual environment lock. This BC does not change auth/authorization behavior in any way, only display.

**Edge Cases**:
- EC-1.6.047-1: a profile with `env` set to an unusual/arbitrary string (e.g. `"my-custom-tag"`) → displayed verbatim, no rejection, no truncation.
- EC-1.6.047-2: `auth status --output json` is NOT currently implemented at all per NFR-O-N (documented gap) — this BC's `status` JSON obligation is therefore contingent on that gap's resolution; until then, this BC's postcondition 2 applies only to `status`'s human-text output for the `env` field, and the JSON obligation applies in full to `list` only. (Flagged explicitly so this BC is not read as silently implementing NFR-O-N's deferred JSON support as a side effect.)

**Verification Properties**: None dedicated to this BC. **[TRIAGED 2026-09-01, F2 VP-delta pass]** Both original draft candidates are ordinary JSON-shape/output-formatting checks (specific field-presence and value assertions for a fixed set of example profiles) — DEMOTED to two ordinary F4 test acceptance criteria anchored directly to Postconditions 1/3 (test-writer implements as standard JSON-shape assertions). The genuine underlying PROPERTY that VP-cycle3-021 was reaching for — "an old `config.toml` with the `env` key absent deserializes indistinguishably from an explicit absence, with no migration required, across the full input space of possible pre-cycle-003 config shapes" — is a schema/deserialization-layer property, not a display-layer one; it is promoted instead at its correct layer as **VP-AUTHDX-009**, declared at BC-6.1.015 in `bc-6-config-cache.md` §6.1 (the `ProfileConfig.env` field's own storage contract). This BC's display layer merely echoes whatever that lower-layer property already guarantees.

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-314; DEC-324; ADR-0020 §Decision 4; cross-reference BC-1.6.046 (AMENDED — human-table column contract), NFR-O-N (`auth status --output json` gap, cited for scope discipline). **Cross-ref confirmed (integrate pass, 2026-09-01):** the `ProfileConfig.env: Option<String>` schema field's additive/tolerant-deserialization storage contract, including VP-AUTHDX-009, is BC-6.1.015 in `bc-6-config-cache.md` §6.1, which cross-links back to this BC and BC-1.6.046 as its display-layer consumers.

---

## Summary Stats

| Subdomain | BCs | Confidence |
|-----------|-----|-----------|
| 1.1 OAuth Flow & Profile Resolution | 15 | All HIGH |
| 1.2 Profile Lifecycle Management | 11 | All HIGH |
| 1.3 Embedded OAuth App | 6 | All HIGH |
| 1.4 Token Keychain Layout | 9 | All HIGH |
| 1.5 OAuth State Machine | 11 | All HIGH |
| 1.6 Auth Error Handling & 401 Dispatch | 6 | All HIGH |
| **Total** | **58** | **58 HIGH** |

Note: 69 total BCs (cumulative, incl. range-collapsed) including 11 additional pre-cycle-003 R4 contracts (BC-1140..1178 subset) incorporated inline above, plus 11 new individually-bodied contracts added in cycle-003's `auth-profile-dx` F2 pass (2026-09-01, DEC-312..325, ADR-0020/ADR-0011). The complete pass-3 BC mapping is in BC-INDEX.md (bc-6/BC-INDEX.md reconciliation of this file's new total is an integrate-pass task, not performed here per the coordination boundary).
