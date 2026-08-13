---
context: bc-1
title: "Auth & Identity"
total_bcs: 58   # cumulative claim (incl. range-collapsed); definitional_count below is individually-bodied headings
definitional_count: 47   # count of `#### BC-` headings in this file
last_updated: 2026-08-13
source_pass: 3
trace: |
  - F2 spec evolution, bucket1-defects bundle (2026-08-13, issue #663): BC-1.2.018 AMENDED — carves out `auth switch` as the explicit exception to global `--profile` propagation (previous unqualified text retained inline for audit trail); BC-1.2.047 NEW — `auth switch --profile <X>` rejected with exit 64 (guard fires in `src/main.rs` before `Config::load_with`; standard `--output json` error envelope). BC count 57→58 (46→47 individually-bodied). See `.factory/research/bucket1-663-auth-switch-profile-2026-08-13.md`.
  - L2: .factory/specs/domain-spec/bc-01-auth-identity.md
  - Source broad: .factory/semport/jira-cli/jira-cli-pass-3-behavioral-contracts.md §2.1
  - Source R1: .factory/semport/jira-cli/jira-cli-pass-3-deep-r1.md §3.1
  - Source R4: .factory/semport/jira-cli/jira-cli-pass-3-deep-r4.md §3.8-3.9
---

# BC-1 — Auth & Identity

58 behavioral contracts across 6 subdomains: OAuth flow (1.1), Profile management (1.2),
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

**Confidence**: HIGH (`#[ignore]`-gated by JR_RUN_KEYRING_TESTS)
**Source**: `tests/auth_profiles.rs:~241`
**Subject**: Auth & Identity
**Behavior**: Login uses lenient config load (skips strict active-profile-existence check), then writes `[profiles.NEW]` with URL + auth_method.
**Effects**: writes config, writes shared `email`/`api-token` keychain keys.
**Trace**: Pass 3 BC-009

---

#### BC-1.1.010: `auth login --profile X` succeeds even when JR_PROFILE points to absent profile

**Confidence**: HIGH (`#[ignore]`-gated)
**Source**: `tests/auth_profiles.rs:~290`
**Subject**: Auth & Identity
**Behavior**: Login uses lenient load throughout — top-level + internal reloads in login_token/login_oauth. `JR_PROFILE=ghost` doesn't abort creation of a different profile.
**Trace**: Pass 3 BC-010 → refined by BC-029 (R1)

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

### 1.2 Profile Lifecycle Management

#### BC-1.2.013: `auth logout` deletes only `<profile>:oauth-access-token` and `<profile>:oauth-refresh-token`

**Confidence**: HIGH (PROMOTED from MEDIUM in R1)
**Source**: `src/api/auth.rs:~24, 88-97`; `src/cli/auth/logout.rs::handle_logout`
**Subject**: Auth & Identity
**Behavior**: Deletes `<profile>:oauth-access-token` and `<profile>:oauth-refresh-token` via `delete_credential`. Profile config entry preserved. Shared keys (`email`, `api-token`, `oauth_client_id`, `oauth_client_secret`) untouched. Re-login uses preserved API-token/OAuth credentials.
**Trace**: Pass 3 BC-013-R

---

#### BC-1.2.014: `auth remove <name>` performs three-step delete: config entry, OAuth tokens, cache directory

**Confidence**: HIGH (PROMOTED from MEDIUM in R1)
**Source**: `src/cli/auth/remove.rs::handle_remove`; `src/cache.rs:~82`; `tests/auth_profiles.rs:~120`
**Subject**: Auth & Identity
**Behavior**: Three-step: (1) remove `[profiles.<name>]` from config, (2) delete `<name>:oauth-*` keychain keys, (3) `cache::clear_profile_cache(name)` removes `~/.cache/jr/v1/<name>/`. Step (3) is no-op if dir absent. All three are best-effort; partial state does not cascade. Errors if name == active (exit 64 first).
**Trace**: Pass 3 BC-014-R

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

**Confidence**: HIGH (`#[ignore]`-gated)
**Source**: `tests/auth_profiles.rs:~282`
**Subject**: Auth & Identity
**Behavior**: Round-5 regression fix. Both internal reloads in login flow use `load_lenient_with`. Test sets `JR_PROFILE=ghost`, runs `jr auth login --profile fresh --url https://fresh.example`, asserts `[profiles.fresh]` written.
**Trace**: Pass 3 BC-029 (R1)

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

**Confidence**: HIGH (PROMOTED from MEDIUM in R1)
**Source**: `src/api/auth.rs:~111`
**Subject**: Auth & Identity
**Behavior**: `load_oauth_tokens(profile)`: if both namespaced keys present → return. If both missing → ONLY `"default"` reads legacy flat keys, copies to namespaced, deletes legacy. Non-default profiles error on partial state with actionable message. Two `if profile == "default"` guards at lines 124 and 151.
**Trace**: Pass 3 BC-023-R

---

#### BC-1.4.026: `refresh_oauth_token` signature is `(profile: &str)` only — resolves credentials internally

**Confidence**: HIGH (PROMOTED from LOW in R1)
**Source**: `src/api/auth.rs:~700`; CLAUDE.md
**Subject**: Auth & Identity
**Behavior**: Function takes only `profile: &str`. Internally resolves keychain → embedded. No production callers as of v0.5.0-dev.7 — exists for future 401 auto-refresh. Re-introducing `client_id/_secret` would break embedded-OAuth path.
**Trace**: Pass 3 BC-024-R

---

#### BC-1.4.027: Per-profile keychain keys: `<profile>:oauth-access-token` / `<profile>:oauth-refresh-token`

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~24`
**Subject**: Auth & Identity
**Behavior**: All OAuth token storage/retrieval uses namespaced keys. Shared keys (`email`, `api-token`, `oauth_client_id`, `oauth_client_secret`) are NOT namespaced.
**Trace**: Pass 3 BC-1153 (R4)

---

#### BC-1.4.028: `load_oauth_tokens` errors on PARTIAL state (one token present, other missing)

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~1249`
**Subject**: Auth & Identity
**Behavior**: Access-token without refresh-token (or vice versa) → `Err`. Prevents silent half-credential use.
**Trace**: Pass 3 BC-1156 (R4)

---

#### BC-1.4.029: `load_oauth_tokens("sandbox")` does NOT inherit legacy flat keys

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~1323`
**Subject**: Auth & Identity
**Behavior**: Lazy migration is `default`-profile-only by design. "sandbox" only reads `sandbox:oauth-*` namespaced keys.
**Trace**: Pass 3 BC-1158 (R4)

---

#### BC-1.4.030: `resolve_refresh_app_credentials` prefers KEYCHAIN over EMBEDDED

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~1347`
**Subject**: Auth & Identity
**Behavior**: BYO user does NOT silently flip onto embedded mid-session. Keychain wins.
**Trace**: Pass 3 BC-1159 (R4)

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

#### BC-1.6.046: `auth list` table snapshot: 4 columns, active profile with `* ` prefix

**Confidence**: HIGH
**Source**: `src/cli/auth/tests/snapshots/jr__cli__auth__tests__list_table_snapshot.snap`
**Subject**: Auth & Identity
**Behavior**: Columns: `NAME, URL, AUTH, STATUS`. Active profile prefixed `* ` (asterisk-space). Inactive: `  ` (2 spaces). 3-profile fixture: default* (api_token), sandbox (oauth), staging (api_token). All STATUS cells `configured`.
**Trace**: Pass 3 BC-1115 (R4)

---

## Summary Stats

| Subdomain | BCs | Confidence |
|-----------|-----|-----------|
| 1.1 OAuth Flow & Profile Resolution | 12 | All HIGH |
| 1.2 Profile Lifecycle Management | 6 | All HIGH |
| 1.3 Embedded OAuth App | 6 | All HIGH |
| 1.4 Token Keychain Layout | 6 | All HIGH |
| 1.5 OAuth State Machine | 11 | All HIGH |
| 1.6 Auth Error Handling & 401 Dispatch | 5 | All HIGH |
| **Total** | **46** | **46 HIGH** |

Note: 57 total BCs including 11 additional from R4 (BC-1140..1178 subset) incorporated inline above. The complete pass-3 BC mapping is in BC-INDEX.md.
