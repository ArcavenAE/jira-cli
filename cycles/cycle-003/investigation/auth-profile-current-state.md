# Cycle-003 Investigation — Auth & Profile Current-State Map

**Scope:** READ-ONLY grounding for a Feature Mode cycle that wants to (1) restructure
API-token + OAuth 2.0 auth, (2) make OAuth the DEFAULT path, (3) separate the "kinds"
of profiles. This document maps the *current reality only* — it does not design the
feature. All citations are `file::symbol` or `file:~line` at absolute paths.

Files read in full or in relevant part:
`src/api/auth.rs`, `src/api/auth_embedded.rs`, `src/api/refresh_coordinator.rs`,
`src/api/client.rs`, `src/config.rs`, `src/cli/auth/{mod,login,keychain,switch,status,refresh,list,logout,remove}.rs`,
`src/cli/init.rs`, `src/cli/mod.rs` (AuthCommand), `docs/adr/{0006,0011,0013}.md`,
`docs/specs/multi-profile-auth.md`, `.factory/specs/prd/bc-1-auth-identity.md` (head).

---

## A. Authentication Mechanisms (Current State)

### A.1 OAuth 2.0 flow (3LO authorization-code, NO PKCE)

- **Login orchestration:** `/Users/zious/Documents/GITHUB/jira-cli/src/api/auth.rs::oauth_login`
  (auth.rs:687). Five steps: bind local callback listener → open browser to Atlassian
  authorize URL → accept HTTP callback + CSRF `state` check → exchange auth code for
  tokens at `https://auth.atlassian.com/oauth/token` → fetch `accessible-resources` to
  resolve cloudId → store tokens in keychain. State is 256-bit CSPRNG hex
  (`auth.rs::generate_state`, ~1138). No PKCE (ADR-0013 — Atlassian 3LO exposes no
  public-client/PKCE controls).
- **CLI wrapper:** `src/cli/auth/login.rs::login_oauth` (login.rs:114). Resolves app
  creds, picks redirect strategy by source, resolves scopes, persists BYO creds, calls
  `oauth_login`, then writes `url`/`cloud_id`/`auth_method="oauth"` to the target
  `[profiles.<name>]`.
- **Embedded app vs BYO** (ADR-0006):
  - Embedded creds live compile-time XOR-obfuscated in
    `src/api/auth_embedded.rs` (`embedded_oauth_app()` decodes once via `OnceLock`;
    `embedded_oauth_app_present()` is a cheap no-decode probe). `build.rs` emits
    `EMBEDDED_ID`/`EMBEDDED_SECRET_XOR`/`EMBEDDED_SECRET_KEY`; fork/source builds have
    none and fall through to BYO.
  - App-credential source precedence for *login*:
    `src/cli/auth/keychain.rs::resolve_oauth_app_credentials` →
    `resolve_oauth_app_credentials_for_test` (keychain.rs:88/150): **flag → env → keychain
    → embedded → prompt**, with `OAuthAppSource` reporting which won (auth_embedded.rs:47).
    Flag/env pairs are all-or-nothing (partial pair is a hard `UserError`).
- **Callback port:** `src/api/auth.rs::EMBEDDED_CALLBACK_PORT = 53682` (auth.rs:526).
  Embedded → `RedirectUriStrategy::FixedPort` → `http://127.0.0.1:53682/callback`
  (literal IPv4, exact-match registered in Developer Console — breaking to change). BYO →
  `RedirectUriStrategy::DynamicPort` → `http://localhost:{port}/callback` (auth.rs:640-671).
  Listener is bound *before* browser open (`RedirectUriStrategyRequest::bind`, TOCTOU-safe).
- **Scopes:** `src/api/auth.rs::DEFAULT_OAUTH_SCOPES` (auth.rs:65) — classic jira-work +
  servicedesk + cmdb + `offline_access`. Per-profile override via
  `[profiles.<name>].oauth_scopes` resolved in `login.rs::resolve_oauth_scopes` (login.rs:22).
- **Refresh — two distinct paths:**
  1. **Silent refresh-token grant** (`refresh_oauth_token` / `refresh_oauth_token_with_url`,
     auth.rs:890/902). Refresh-side app-cred resolver is **keychain → embedded only**
     (`resolve_refresh_app_credentials`, auth.rs:1037 — deliberately NO flag/env, to avoid
     silently flipping a BYO user onto the embedded app). This grant is wired into the
     HTTP client's 401 auto-refresh path only (see below); it has NO direct CLI caller.
  2. **User-facing `jr auth refresh`** (`src/cli/auth/refresh.rs::refresh_credentials`,
     refresh.rs:55) does NOT call the silent grant — it does a clear-then-relogin
     (full 3LO browser flow for OAuth, re-prompt for api_token). This is the macOS
     Keychain-ACL rebind workaround (#207).
- **401 auto-refresh:** `src/api/client.rs::send_inner` (client.rs:528, blanket-401 path
  ~787). On a `Bearer`-auth 401 (Atlassian gives no machine-readable expiry signal), it
  refreshes via `refresh_coordinator::refresh_with_single_flight` and retries once.
  Basic/api_token 401 → `NotAuthenticated` (nothing to refresh).
- **Concurrent-refresh single-flight:** `src/api/refresh_coordinator.rs::refresh_with_single_flight`
  (refresh_coordinator.rs:99). Per-profile `Arc<TokioMutex<RefreshState>>` keyed
  `{profile}:{token_url}`; outer `StdMutex` released before any `.await`; single-use
  refresh tokens (Atlassian rotates on each use).
- **Token storage:** namespaced keychain keys `<profile>:oauth-access-token` /
  `<profile>:oauth-refresh-token` (`store_oauth_tokens`/`load_oauth_tokens`, auth.rs:235/253).

### A.2 API-token auth

- **Storage:** flat shared keychain keys `email` + `api-token`
  (`store_api_token`/`load_api_token`, auth.rs:212/220). Account-level, shared across all
  profiles by design (multi-profile-auth.md §Keyring Layout).
- **Login:** `src/cli/auth/login.rs::login_token` (login.rs:47). Resolves email+token via
  flag → env (`JR_EMAIL`/`JR_API_TOKEN`) → prompt (`keychain.rs::resolve_credential`),
  stores shared keys, sets `auth_method="api_token"` on the profile.
- **Auth header composition:** `src/api/client.rs::JiraClient::load_auth_from_keychain`
  (client.rs:124). `auth_method=="oauth"` → `Bearer <access>`; anything else (default) →
  `Basic base64(email:token)`.

### A.3 How `jr` chooses OAuth vs API-token TODAY

- **At runtime (which header to send):** per-profile config field `auth_method:
  Option<String>` in `ProfileConfig` (config.rs:19). Read in
  `JiraClient::from_config` (client.rs:73-75) with **`.unwrap_or("api_token")` — api_token
  is the hard-coded default when unset.** `Config::base_url()` also branches on it:
  oauth+cloud_id → `https://api.atlassian.com/ex/jira/{cloud_id}`, else the raw site URL
  (config.rs:397-402).
- **At login time (which flow to run):** decided by the `--oauth` bool flag, NOT config.
  `src/cli/auth/login.rs::handle_login` (login.rs:319): `args.oauth` → `login_oauth`, else
  `login_token`. So **bare `jr auth login` defaults to API-TOKEN; OAuth is opt-in via
  `--oauth`** (`src/cli/mod.rs` AuthCommand::Login, mod.rs:214-247, `oauth: bool` default false).
- **`chosen_flow_for_profile`** (`src/cli/auth/mod.rs:107`) is used by `refresh` only:
  `--oauth` override → OAuth; `auth_method=="oauth"` → OAuth; else Token.
- **INCONSISTENCY (already present):** `jr init`'s interactive picker DOES default to OAuth:
  `src/cli/init.rs:95-99` — `["OAuth 2.0 (recommended)", "API Token"]` with `.default(0)`,
  dispatching `login_oauth` for choice 0 (init.rs:142-149). So the *guided setup* already
  recommends OAuth while the *direct `auth login`* command defaults to token. This is the
  seam the "make OAuth default" ask is really about.

### A.4 Keychain layout (single service, mixed scoping)

Service name `jr-jira-cli` (`auth.rs::DEFAULT_SERVICE_NAME`, `JR_SERVICE_NAME` debug-only
override). Keys:

| Key | Scope | Notes |
|---|---|---|
| `email`, `api-token` | Shared (flat) | Account-level classic token |
| `oauth_client_id`, `oauth_client_secret` | Shared (flat) | BYO OAuth app creds |
| `<profile>:oauth-access-token` / `-refresh-token` | Per-profile | cloudId-scoped |
| `oauth-access-token` / `oauth-refresh-token` | Legacy flat | **Lazy-migrated for `"default"` profile ONLY** on read (`load_oauth_tokens`, auth.rs:253-311); also cleared for `"default"` in `clear_profile_creds`/`clear_all_credentials` (auth.rs:422/467) |

`clear_all_credentials(profiles)` wipes shared keys + each listed profile's OAuth pair;
`clear_profile_creds(profile)` wipes only that profile's OAuth (+ legacy if `"default"`).

---

## B. Profile Architecture (Current State)

### B.1 Config model (`src/config.rs`)

- `GlobalConfig` (config.rs:29): `default_profile: Option<String>`,
  `profiles: BTreeMap<String, ProfileConfig>` (BTreeMap → deterministic listing),
  `instance: InstanceConfig` (legacy, `skip_serializing`), `fields: FieldsConfig` (legacy,
  `skip_serializing`), `defaults: DefaultsConfig`.
- `ProfileConfig` (config.rs:16): `url, auth_method, cloud_id, org_id, oauth_scopes,
  team_field_id, story_points_field_id, project`. **All fields are `Option`; the profile
  is a flat bag keyed only by its name — there is no "kind"/"type"/"group" field.**
- Per-project `.jr.toml` → `ProjectConfig { project, board_id }` discovered by walking up
  from cwd (`Config::find_project_config`, config.rs:362).
- **Figment layering** (`Config::load_inner`, config.rs:249):
  `Serialized::defaults` ← `Toml(config.toml)` ← `Env::prefixed("JR_")`. Env overlay is
  in-memory only; migration write-back and `save_global` re-read file-only to avoid baking
  transient env vars to disk (config.rs:277, 461).
- **Legacy migration** `migrate_legacy_global` (config.rs:166): copies `[instance]`+
  `[fields]` into `[profiles.default]`, sets `default_profile="default"`. Idempotent;
  fires once in `load_inner` when `[profiles]` empty AND any legacy field present.
- **Profile-name validation** `validate_profile_name` (config.rs:115): `[A-Za-z0-9_-]{1,64}`,
  rejects Windows reserved names; `UserError` (exit 64). The `:` rejection is what keeps
  keychain-key parsing and cache-dir paths unambiguous.

### B.2 Active-profile resolution

`resolve_active_profile_name` (config.rs:97): **`--profile` flag > `JR_PROFILE` env >
`default_profile` field > literal `"default"`.** `--profile` is threaded as a function
parameter via `Config::load_with(cli_profile)` (config.rs:220) — deliberately NOT an
env-var seam (unsafe under `#[tokio::main]`). Result stored in `Config::active_profile_name`;
strict `Config::load` errors (`UserError`) if the resolved name isn't in `[profiles]`,
`load_lenient` (used only by `auth login`/`init`) skips that check so a profile can be
created on demand.

### B.3 Per-profile boundaries

- **Cache:** every reader/writer takes `profile: &str` first arg; root
  `~/.cache/jr/v1/<profile>/` (multi-profile-auth.md §Cache Layout). Soft-fence convention,
  **NOT compile-enforced** — ADR-0011 (type-level `Profile` newtype) is DEFERRED.
- **Field IDs:** `team_field_id` / `story_points_field_id` are per-profile (site-scoped;
  ADR-0007) — cross-profile leakage is a correctness bug.
- **cloudId scoping:** OAuth tokens + `base_url` gateway are cloudId-scoped; `JiraClient`
  carries `profile_name` (client.rs:29) so cache call-sites without `&Config` stay scoped.

### B.4 `auth` command family (`src/cli/auth/`)

| Cmd | Handler | Profile behavior |
|---|---|---|
| `login` | `login.rs::handle_login` | Creates/updates target profile; `--profile` selects, `--oauth` picks flow; sets `auth_method`; promotes to `default_profile` if unset |
| `status` | `status.rs::status` | Reports one profile (default: active); shows auth_method + cred presence + next OAuth-app source (`peek_oauth_app_source`). **Human text only — no JSON path** |
| `refresh` | `refresh.rs::refresh_credentials` | Clear-then-relogin per target profile's `auth_method` (+ `--oauth` override) |
| `switch` | `switch.rs::handle_switch` | Sets `default_profile`. **Rejects global `--profile` (S-663-1 / BC-1.2.047)** — only the positional `<name>` selects target; guard in `src/main.rs` before `Config::load_with` |
| `list` | `list.rs::handle_list` | Table/JSON of all profiles; `STATUS ∈ {configured, unset}` = URL-on-file only (NOT credential presence) |
| `logout` | `logout.rs::handle_logout` | Clears that profile's OAuth tokens; config entry + shared api-token untouched |
| `remove` | `remove.rs::handle_remove` | Deletes profile config + cache subdir + per-profile OAuth; refuses active/default_profile target; shared creds never touched |

### B.5 What "kinds" of profiles exist today — and how (little) is modeled

**Nothing structural.** Profiles are a flat `BTreeMap<String, ProfileConfig>` keyed by an
opaque name. The only *structured* discriminator on a profile is `auth_method`
("oauth"/"api_token") — and that is a credential mechanism, not a category. Every other
"kind" distinction is IMPLICIT / by naming convention only:

- **By auth type:** `auth_method` field (the one semi-structured axis).
- **By site / instance:** `url` + `cloud_id` (one site per profile) — not a grouping.
- **By sandbox-vs-prod:** convention only (e.g. a profile literally named `sandbox` in
  spec examples, config.rs tests) — nothing enforces or tags it.
- **By org:** `org_id` exists but is only used for team GraphQL queries, not as a grouping key.
- **By JSM-vs-platform / product:** NOT modeled at the profile level at all — JSM vs
  platform is decided per-command (e.g. `--request-type` dispatch fork), never per-profile.

There is no profile grouping, tagging, aliasing, nesting (`[profiles.<kind>.<name>]`), or
"kind" enum anywhere. multi-profile-auth.md §Out of Scope explicitly deferred a separate
`jr profile` subcommand tree and profile renaming.

---

## C. Governance Already in Place

**ADRs touching auth/profiles** (`docs/adr/`):
- **ADR-0002** — OAuth with embedded secret (SUPERSEDED by 0006).
- **ADR-0006** — Embedded `jr` OAuth app + compile-time XOR obfuscation; fixed callback
  port 53682 as a permanent contract; BYO escape hatch; "no silent app-flip mid-session".
- **ADR-0007** — Per-profile field IDs must be read from `ProfileConfig`, not global.
- **ADR-0011** — Type-level `Profile` newtype fence DEFERRED (soft-fence convention holds;
  revisit triggers: a leakage bug, >5 committers, or a config overhaul — *this cycle could
  be that overhaul window*).
- **ADR-0013** — PKCE deferral (Atlassian 3LO has no public PKCE); embedded `client_secret`
  is required for token exchange; reactivation trigger defined (OAuth 2.1 / Atlassian PKCE).
- **ADR-0014** — JSM request-type dispatch (auth-adjacent: drives `write:servicedesk-request`
  scope hint on 401).

**Specs:** `docs/specs/multi-profile-auth.md` (canonical design — schema, keyring/cache
layout, CLI surface, migration, error table), `docs/specs/oauth-scopes-configurable.md`.
**Behavioral contracts:** `.factory/specs/prd/bc-1-auth-identity.md` (58 BCs across 6
subdomains: 1.1 OAuth flow & profile resolution, 1.2 profile management, 1.3 embedded OAuth
app, 1.4 token keychain, 1.5 OAuth state machine, 1.6 auth error handling),
`.factory/specs/prd/bc-6-config-cache.md`, `.factory/specs/prd/nfr-catalog.md`.

**Constraints any change MUST respect:**
- **SD-002 release gates:** `JR_AUTH_HEADER` and `JR_BASE_URL` are `#[cfg(debug_assertions)]`
  only (release binaries ignore them; both are token-leak vectors). Gated at BOTH
  `config.rs::base_url` and `client.rs::from_config`; pinned by `tests/base_url_release_gate.rs`.
  `JR_SERVICE_NAME` similarly gated (`tests/jr_service_name_release_gate.rs`).
- **PKCE deferral (ADR-0013):** cannot move to a pure public-client OAuth flow; the
  embedded-secret model is load-bearing for "OAuth just works".
- **Single-use refresh tokens** + mandatory `refresh_coordinator` single-flight.
- **Fixed callback port 53682** = breaking to change (Developer Console exact-match).
- **`DEFAULT_OAUTH_SCOPES` changes** require Developer Console permission update + CHANGELOG
  re-consent note (CLAUDE.md).
- **Windows Credential Manager posture:** user-session isolation is the trust boundary
  (SEC-WCM-DOC).
- **`auth switch` rejects `--profile`** (BC-1.2.047) — a precedent that CLI-surface breaking
  changes to the auth family are acceptable when documented.
- **Cache versioned root `v1/`** — a schema break can orphan stale files by bumping to `v2/`.

---

## D. Impact & Risk Surface (Delta Boundary)

### D.1 Files a "make OAuth default" change most likely touches
- `src/cli/mod.rs` (AuthCommand::Login/Refresh, mod.rs:214-282) — the `oauth: bool` flag
  would need to invert to an `--api-token` opt-out, or gain a default flip. **CLI-surface
  breaking.**
- `src/cli/auth/login.rs::handle_login` (login.rs:319) — flow-selection branch.
- `src/cli/auth/mod.rs::chosen_flow_for_profile` (mod.rs:107) — refresh flow default.
- `src/api/client.rs::from_config` (client.rs:73-75) — `.unwrap_or("api_token")` default
  when `auth_method` unset; and `src/config.rs::base_url` oauth/api_token branch (config.rs:397).
- `src/cli/init.rs` (already OAuth-default — the model to mirror).
- Docs/specs: `docs/specs/multi-profile-auth.md`, `bc-1-auth-identity.md`, CLAUDE.md.

### D.2 Files a "profile-kind separation" change most likely touches
- `src/config.rs` — `ProfileConfig`/`GlobalConfig` schema (new "kind" field, tag set, or
  nested namespace) + `migrate_legacy_global` + `validate_profile_name`.
- `src/api/auth.rs` — keychain key layout IF "kind" becomes part of a key (currently only
  profile-name is; a kind axis would multiply the namespace).
- `src/cache.rs` — per-profile cache dir IF kind enters the path.
- `src/cli/auth/list.rs` + all auth handlers — display/selection of kinds.
- ADR-0011 (soft-fence) becomes more relevant if the profile identity gains structure.

### D.3 Breaking-change / migration risks
- **Login-default flip:** existing scripts/agents/CI invoking `jr auth login` (bare) +
  `JR_EMAIL`/`JR_API_TOKEN` expect the api-token flow. Flipping to OAuth would break
  non-interactive automation (OAuth needs a browser or BYO app). An opt-out flag +
  clap default change is itself a CLI-surface break.
- **Runtime default flip:** `client.rs:74` defaults unset `auth_method` to `api_token`.
  Any profile with unset `auth_method` (hand-edited, or a future kind that omits it) would
  silently switch to attempting OAuth-token loads that don't exist → 401/NotAuthenticated.
- **Stored credentials:** api-token users flipping to OAuth need a full re-auth + Atlassian
  re-consent; the shared `email`/`api-token` keys vs per-profile `<profile>:oauth-*` split
  must be preserved. Forks/source builds have NO embedded app — "OAuth default" is only
  zero-config on official binaries (ADR-0006).
- **Profile-kind schema change** = config-schema break → needs the same auto-migration
  discipline as the legacy `[instance]` path, plus possible cache/keychain namespace
  migration (versioned-root `v1→v2` bump is the existing lever). The `"default"`-only
  legacy OAuth-key migration in `load_oauth_tokens` is a fragile edge that any keychain
  layout change must not regress.

### D.4 Existing test coverage for auth/profiles
- **Integration (always-run):** `tests/auth_profiles.rs`, `tests/auth_output_json.rs`,
  `tests/multi_cloudid_disambiguation.rs`.
- **Keyring-gated** (`JR_RUN_KEYRING_TESTS=1` + `#[ignore]`): subset of `auth_profiles.rs`,
  `multi_cloudid_disambiguation.rs`, `tests/oauth_refresh_integration.rs` (401 auto-refresh
  coordinator AC-002/009-011).
- **OAuth integration gated** (`JR_RUN_OAUTH_INTEGRATION=1`): `tests/oauth_embedded_login.rs`
  — currently `unimplemented!()` (needs a wiremock base-URL override before a real assertion).
- **Release-gate pins:** `tests/base_url_release_gate.rs`, `tests/jr_service_name_release_gate.rs`,
  `tests/config_dir_release_gate.rs`.
- **Unit:** `config.rs::tests` (precedence, validation, migration, base_url oauth/api_token),
  `auth.rs::tests` (redirect strategy, port 53682, state hex), `auth_embedded.rs::tests`
  (decode/present/redaction), `cli/auth/tests` (credential-resolver precedence),
  `refresh_coordinator` single-flight.
- **E2E live** (`JR_RUN_E2E=1`): `tests/e2e_live.rs`.

---

## Open Scoping Questions (decisions a human architect must make to bound this feature)

1. **OAuth-default migration posture for existing api-token users.** Does "make OAuth
   default" flip the `jr auth login` CLI default (breaking — needs an `--api-token` opt-out
   and breaks non-interactive api-token automation), or only change *guided setup + docs*
   (init already defaults to OAuth) while leaving `auth login` bare = api_token? And does
   the runtime default at `client.rs:74` (`unset auth_method → api_token`) stay, or flip to
   oauth (risking silent breakage of hand-edited/unset profiles)?

2. **What dimension does "profile kinds" actually mean?** Candidates, none modeled today:
   (a) auth type, (b) site-role prod/sandbox/UAT, (c) product platform-vs-JSM, (d) org
   grouping. Is it a new *structured field* on `ProfileConfig`, a *tag set*, or a *nested
   namespace* (`[profiles.<kind>.<name>]`)? This decides whether keychain/cache key layouts
   change (and thus migration cost + a possible `v1→v2` cache-root bump).

3. **Deprecation vs coexistence of API-token auth.** Is api-token being retired to
   legacy/frozen status, or remaining a first-class coequal path? This bounds how much of
   the api-token surface (shared-key layout, `login_token`, Basic-header composition) is in
   scope to change vs. leave untouched.

4. **Embedded-app dependency for "OAuth default".** OAuth is only zero-config on *official*
   binaries (embedded app, ADR-0006). Forks/source builds fall to BYO/prompt. Is closing
   that friction (or explicitly accepting it) in scope, given "OAuth default" implies a
   working zero-config path?

5. **CLI-surface break tolerance.** Is inverting the `--oauth` flag semantics (e.g. to
   `--api-token`) and/or changing `chosen_flow_for_profile` defaults an acceptable breaking
   change? The `auth switch --profile` rejection (BC-1.2.047) is precedent that auth-family
   CLI breaks are done when documented — confirm the same latitude here.

6. **Shared-vs-per-profile keychain invariant under a kind change.** If profile identity
   gains a "kind" axis, how is the account-level shared `email`/`api-token`/`oauth_client_*`
   layout and the `"default"`-only legacy OAuth-key lazy migration (`load_oauth_tokens`,
   auth.rs:253) preserved? And should this cycle finally un-defer ADR-0011's `Profile`
   newtype (the "config overhaul" revisit trigger) to hard-fence the boundary?

---

### Flagged unknowns / not verified in this pass
- Full body of `bc-1-auth-identity.md` (only header + first BCs read) and
  `bc-6-config-cache.md` were not read line-by-line — exact per-BC wording for any auth/config
  contract that a change would amend should be re-read before spec crystallization.
- `nfr-catalog.md` auth/security NFRs were not enumerated here.
- The exact `src/main.rs` dispatch for `auth switch --profile` rejection (BC-1.2.047) was
  cited from CLAUDE.md/spec, not read directly this pass.
