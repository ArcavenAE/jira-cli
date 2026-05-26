---
title: "BC-01: Auth & Identity"
version: "1.0.0"
snapshot_sha: "dea166471e22eff55974d7675593469b37048c5f"
traces_to: "README.md"
source_passes: "Pass 2 broad §2a.2 Auth + R1 §3.1 T-01 + Pass 8 §2.2 BC#1"
entity_count: 14
invariant_count: 22
bc_count: 57
risk_level: HIGH
adr_refs: "ADR-0002 (superseded), ADR-0006"
---

# BC-01: Auth & Identity

The Auth & Identity bounded context owns all credential management, OAuth 2.0 flows, keychain interactions,
and per-profile identity namespacing. It is the highest-risk context (3,645 LOC across 3 files).

---

## §1 Ubiquitous Language

| Term | Definition |
|------|-----------|
| **Login flow** | The full sequence: credential resolution → OAuth/token flow → keychain write → profile update |
| **API token** | A per-user Atlassian API token (email + token pair). Default auth method. |
| **OAuth 2.0 (3LO)** | Three-legged OAuth. Optional via `jr auth login --oauth`. Requires `client_id`/`client_secret`. |
| **Embedded app** | The official `jr` Atlassian OAuth app; credentials XOR-obfuscated into release binaries (ADR-0006). |
| **BYO app** | User-supplied OAuth app credentials via flags, env vars, or keychain. |
| **Credential resolution chain** | Flag > Env (`JR_OAUTH_CLIENT_ID`/`_SECRET`) > Keychain > Embedded app > Prompt (interactive only). For refresh: Keychain > Embedded only (2-source `RefreshAppSource`). |
| **Fixed-port strategy** | `FixedPort(53682)` — used by embedded app. Atlassian registered callback URL is `http://127.0.0.1:53682/callback` (literal IPv4, not `localhost`). |
| **Dynamic-port strategy** | `DynamicPort(0)` — used by BYO app. OS assigns an ephemeral port; `localhost:N/callback` format. |
| **TOCTOU closure** | `ResolvedRedirect` binds the listener atomically in `bind()` so the port cannot be stolen between probe and use. |
| **Namespaced keychain key** | `<profile>:oauth-access-token` / `<profile>:oauth-refresh-token` — per-profile OAuth token storage. |
| **Shared keychain key** | `email`, `api-token`, `oauth_client_id`, `oauth_client_secret` — account-level, shared across profiles. |
| **Legacy flat keys** | `oauth-access-token` / `oauth-refresh-token` without profile prefix — read-only; migrated to namespaced on first use by `"default"` profile only. |
| **OAuthAppSource** | Enum reporting which credential source drove the live session. Exposed by `jr auth status`. |
| **Clear-and-relogin** | The current `auth refresh` implementation: delete keychain pair + cache, then re-run login. NOT a token-grant refresh. |
| **`refresh_oauth_token`** | A `pub` function at `api/auth.rs:704` for token-grant refresh. Has zero production callers (deferred integration). |

---

## §2 Entities

Source: Pass 2 broad §2a.2 + R1 §3.1 (E-01-01 through E-01-09 new entities).

| Entity | Module | Key Fields | Lifecycle |
|--------|--------|-----------|----------|
| `EmbeddedOAuthApp` | `api/auth_embedded.rs:22-26` | `client_id: String`, `client_secret: String` | Decoded once per process via `OnceLock` from XOR-obfuscated build constants. Custom `Debug` redacts `client_secret`. |
| `OAuthAppSource` (enum) | `api/auth_embedded.rs:46-57` | Variants: `Flag, Env, Keychain, Embedded, Prompt, None` | Reported by `jr auth status` via `peek_oauth_app_source` (no-decode presence check). |
| `RefreshAppSource` (enum) | `api/auth.rs:822-826` | Private 2-variant enum | Used internally by `resolve_refresh_app_credentials`: Keychain or Embedded only. |
| `RedirectUriStrategyRequest` (enum) | `api/auth.rs:398-407` | Variants: `Dynamic`, `Fixed(u16)` | Constructed by `cli/auth.rs::login_oauth` based on `OAuthAppSource`. `Fixed` → embedded app (port 53682). `Dynamic` → BYO (port 0). |
| `ResolvedRedirect` | `api/auth.rs:459-478` | Private: `strategy: RedirectUriStrategy`, `listener: tokio::net::TcpListener` | Created by `RedirectUriStrategyRequest::bind()`. TOCTOU-closed: private fields prevent stale-strategy extraction. Consumed once by `oauth_login` via `into_parts()`. |
| `RedirectUriStrategy` (enum) | `api/auth.rs:490-496` | Variants: `DynamicPort(u16)`, `FixedPort(u16)` | `redirect_uri()` method: `FixedPort` → `http://127.0.0.1:{p}/callback`; `DynamicPort` → `http://localhost:{p}/callback`. |
| `OAuthResult` | `api/auth.rs:368-372` | `cloud_id: String`, `site_url: String`, `site_name: String` | Returned by `oauth_login` after the 5-step flow (browser → callback → exchange → resources → persist). |
| `LoginArgs` | `cli/auth.rs:543` | `profile: Option<String>`, `url: Option<String>`, `oauth: bool`, `email: Option<String>`, `token: Option<String>`, `client_id: Option<String>`, `client_secret: Option<String>`, `no_input: bool` | Bundles all login inputs through `handle_login → login_token / login_oauth`. |
| `RefreshArgs<'_>` | `cli/auth.rs:845` | Same shape as `LoginArgs` but borrowed | Refresh = clear-and-relogin; same resolver path. |
| Keychain key namespacing | `api/auth.rs:18-32` | Constants: `KEY_EMAIL`, `KEY_API_TOKEN`; fns: `oauth_access_key(profile)`, `oauth_refresh_key(profile)` | `email`/`api-token`/`oauth_client_*` are flat (shared). `<profile>:oauth-access-token`/`oauth-refresh-token` are per-profile. `KEY_OAUTH_ACCESS_LEGACY` is read-only post-migration. |
| `DEFAULT_OAUTH_SCOPES` | `api/auth.rs:58-63` | 7 scopes as `&'static str` (concat!) | `read:jira-work write:jira-work read:jira-user read:servicedesk-request read:cmdb-object:jira read:cmdb-schema:jira offline_access`. Pinned by regression test. |
| `EMBEDDED_CALLBACK_PORT` | `api/auth.rs:384` | `53682u16` constant | Permanent contract. Changing it is a breaking release (ADR-0006). |
| OAuth scope set | `api/auth.rs:58-63` | 7 scopes | Used verbatim in `build_authorize_url`. Exact match required or Atlassian rejects with `invalid_scope`. |
| Build-time codegen | `build.rs`, `$OUT_DIR/embedded_oauth.rs` | `EMBEDDED_ID: Option<&str>`, `EMBEDDED_SECRET_XOR: Option<&[u8]>`, `EMBEDDED_SECRET_KEY: Option<&[u8]>` | Set only when `JR_BUILD_OAUTH_CLIENT_ID`/`_SECRET` are set at compile time. Missing → all `None` → BYO/prompt path. |

---

## §3 Value Objects & Enums

- **`OAuthAppSource`** — 6-variant enum with `label() -> &'static str`. Used by `jr auth status`.
- **`RefreshAppSource`** — 2-variant private enum (Keychain, Embedded). Refresh resolver uses fewer sources than login resolver by design.
- **`RedirectUriStrategy`** — 2-variant enum with `redirect_uri() -> String`. Host form differs: `127.0.0.1` (fixed) vs `localhost` (dynamic).
- Keychain key constants (`KEY_EMAIL = "email"`, `KEY_API_TOKEN = "api-token"`) — load-bearing string constants that form the keychain namespace.

---

## §4 Operations

| Command | Key Behavior | Idempotent? |
|---------|-------------|-------------|
| `auth login` | Resolves credentials (6-source chain for OAuth; 3-source for token). Writes to keychain. Writes/updates profile in `config.toml`. For OAuth: opens browser, binds local listener, CSRF-validates state, exchanges code, discovers `cloud_id`. | Yes-ish (re-run overwrites tokens) |
| `auth status` | Reads profile + keychain presence. Reports `OAuthAppSource` via presence-only check (no plaintext decode). | Yes (read-only) |
| `auth refresh` | **Clear-and-relogin**: deletes keychain pair + clears profile cache, then re-runs `handle_login`. Not a refresh-token grant. | Yes (destructive but idempotent) |
| `auth switch <name>` | Validates `<name>` exists in `[profiles]`, sets `default_profile = <name>`, saves config. | Yes |
| `auth list` | Renders all profiles with URL, auth method, cloudId, active marker. | Yes (read-only) |
| `auth logout` | Deletes `<profile>:oauth-*` keychain entries only. Config entry and shared credentials untouched. | Yes (second call is no-op) |
| `auth remove <name>` | Deletes `[profiles.<name>]` from config, per-profile OAuth tokens, and per-profile cache dir. Errors if `name == active`. Shared credentials untouched. | Yes (second call errors "unknown profile") |

---

## §5 Business Rules & Invariants

Source: Pass 2 broad §2a.4, §2b.5; R1 §3.1; Pass 8 §3.2.

| ID | Invariant | Source |
|----|----------|--------|
| INV-AUTH-001 | OAuth login for embedded app uses `FixedPort(53682)`; BYO uses `DynamicPort(0)`. The two are mutually exclusive based on `OAuthAppSource`. | `api/auth.rs:374-477`, ADR-0006 |
| INV-AUTH-002 | `redirect_uri` for `FixedPort` is `http://127.0.0.1:53682/callback` (literal IPv4). `redirect_uri` for `DynamicPort` is `http://localhost:{p}/callback`. Host form differs and is load-bearing for Atlassian's exact-match validation (JRACLOUD-92180). | `api/auth.rs:506-528`, pinned by test `redirect_uri_strategy_strings` |
| INV-AUTH-003 | `ResolvedRedirect` private-field design prevents TOCTOU between listener bind and port use. No caller can extract stale strategy from a moved listener. | `api/auth.rs:451-458` |
| INV-AUTH-004 | OAuth state parameter: 32 bytes from `SysRng` → 64 hex chars. State is validated against CSRF at callback. A state mismatch → login error; keychain NOT written. | `api/auth.rs` (BC-1146) |
| INV-AUTH-005 | No PKCE in OAuth flow (`code_challenge`/`code_verifier` absent). Current model: confidential-client with embedded secret. NFR-S-A (MEDIUM security gap). | `api/auth.rs:608-616`, NEW-INV-178 |
| INV-AUTH-006 | `accessible_resources.first()` — silent first-result-wins. Multi-site users are silently authenticated to whichever Atlassian returns first. NFR gap (NEW-INV-179). | `api/auth.rs:666-668` |
| INV-AUTH-007 | Per-profile namespaced keychain keys: `<profile>:oauth-access-token`, `<profile>:oauth-refresh-token`. Non-default profiles NEVER inherit legacy flat keys. | `api/auth.rs:88-97`, `api/auth.rs:1323-1341` |
| INV-AUTH-008 | Legacy flat key migration: `"default"` profile only. On first read of absent namespaced pair, reads legacy flat keys, writes to namespaced, DELETES the legacy flat keys. "Read once, move forever." | `api/auth.rs:1153-1178` |
| INV-AUTH-009 | `load_oauth_tokens` errors on PARTIAL state: access-token without refresh-token (or vice versa) → `JrError`. Not silently usable as a half-credential. | `api/auth.rs:1249-1269` |
| INV-AUTH-010 | `resolve_refresh_app_credentials` prefers Keychain over Embedded. A BYO user who stored credentials in keychain does not flip to embedded mid-session on refresh. | `api/auth.rs:1347-1357` |
| INV-AUTH-011 | `EmbeddedOAuthApp::Debug` NEVER includes `client_secret` in its output — `<redacted>` only. Pinned by test `embedded_oauth_app_debug_redacts_secret`. | `api/auth_embedded.rs:34-41` |
| INV-AUTH-012 | `embedded_oauth_app_present()` returns `false` and does NOT decode when build lacked `JR_BUILD_OAUTH_CLIENT_ID`/`_SECRET`. "Empty-ciphertext → None" built-in. | `api/auth_embedded.rs:100-106, 132-136` |
| INV-AUTH-013 | `embedded_oauth_app()` decodes lazily via `OnceLock`. Plaintext held for process lifetime once decoded. | `api/auth_embedded.rs:22-26` |
| INV-AUTH-014 | OAuth scope set is pinned to exactly 7 scopes. Registered Atlassian app must match or `invalid_scope` is returned. Changing scopes requires re-registering the app. | `api/auth.rs:58-63`, pinned by regression test |
| INV-AUTH-015 | `auth refresh` is clear-and-relogin, NOT a token-grant refresh. `refresh_oauth_token` (`api/auth.rs:704`) has zero production callers — deferred integration. | `cli/auth.rs::refresh_credentials`, Pass 8 §5.2 |
| INV-AUTH-016 | Hostile `client_id` containing `&redirect_uri=evil.example#frag` is percent-encoded in `build_authorize_url`. Output MUST NOT contain raw `&redirect_uri=evil.example`. | `api/auth.rs:1043-1060`, BC-1149 |
| INV-AUTH-017 | Shared API-token credentials (`email`, `api-token`) are NEVER deleted by `auth logout` or `auth remove`. Only per-profile OAuth tokens and cache are removed. | `cli/auth.rs::handle_logout, handle_remove` |
| INV-AUTH-018 | `auth remove <name>` errors if `name == active_profile`. Active profile cannot be removed. | `cli/auth.rs::handle_remove` |
| INV-AUTH-019 | Profile name validation runs at three boundaries: `--profile` CLI flag, every `[profiles.*]` TOML key, resolved active-profile name. All reject non-`[A-Za-z0-9_-]`, >64 chars, and reserved Windows names. | `config.rs:113-140`, BC-019 |
| INV-AUTH-020 | `JR_AUTH_HEADER` env var is honored in production binary (no `#[cfg(test)]` gate). This is an NFR-S-B (HIGH) security gap — any process inheriting this env bypasses keychain auth. | `api/client.rs:64-66`, NFR-S-B |
| INV-AUTH-021 | `Fixed(port).bind()` against a pre-bound port → friendly error containing `"port {port}"`, `"in use"`, `"--client-id"`. | `api/auth.rs:438-442`, BC-1161 |
| INV-AUTH-022 | `auth login --profile NEW` writes `<NEW>:oauth-access-token` and `<NEW>:oauth-refresh-token` (namespaced). NEVER writes to flat keys for new profiles. | `api/auth.rs:88-97` |

---

## §6 Aggregate Boundaries

- **Auth aggregate root** is the `keyring` service `jr-jira-cli`. Inside it, two namespaces co-exist: shared/flat keys and per-profile `<profile>:` prefixed keys.
- `api::auth` owns keychain I/O and the OAuth token exchange logic.
- `cli::auth` owns per-subcommand orchestration, JSON output shapes, and the `LoginArgs`/`RefreshArgs` structs.
- `api::auth_embedded` is a thin sibling for XOR-obfuscation runtime; it does NOT own keychain writes.
- Build-time (`build.rs`) is the only site that produces the XOR key. Runtime decodes lazily.

---

## §7 Cross-Context Dependencies

| Depends on | Reason |
|-----------|--------|
| **Configuration (BC-06)** | Reads/writes `ProfileConfig.url`, `.auth_method`, `.cloud_id`, `.org_id`, `.oauth_scopes`. Profile resolution (`Config::load_with`) provides active profile name. |
| **Cache (BC-06)** | `auth refresh` calls `cache::clear_profile_cache(name)` before re-login. Auth itself does not read the cache. |
| **Output (BC-07)** | `jr auth list`, `jr auth status` emit table or JSON via `output.rs`. |
| **Error (BC-07)** | `JrError::NotAuthenticated` (exit 2), `JrError::InsufficientScope` (exit 2), `JrError::ConfigError` (exit 78) all originate here. |

---

## Harmonization Notes

- **ADR-0002 (superseded):** The original "embed secret" decision was superseded by ADR-0002's successor "BYO only", then re-superseded back to embed by ADR-0006. This spec reflects the ADR-0006 state only. ADR-0002 is marked `Superseded` and has no live code claims.
- **`refresh_oauth_token` orphan:** The function exists `pub` at `api/auth.rs:704` with no production callers. This is intentional (deferred 401 auto-refresh). The spec documents it as-is; product-owner will decide whether to wire it in Burst 2.
- **NFR-S-A (no PKCE):** Documented as a gap, not a bug. ADR-0006 acknowledges the confidential-client model; PKCE is a defense-in-depth complement that the current implementation lacks.
