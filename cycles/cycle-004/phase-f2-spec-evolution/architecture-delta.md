---
document_type: architecture-delta
feature: windows-correctness
cycle: cycle-004
base_ref: 42e92b46
base_version: 0.7.0-dev.4
date: 2026-09-03
author: architect
status: accepted
adr: ["ADR-0021", "ADR-0022"]
related_adr: ["ADR-0016", "ADR-0020"]
traces_to: .factory/specs/architecture/ARCH-INDEX.md
feature_type: backend + infrastructure
dtu_required: false
gene_transfusion_required: false
inputs:
  - ".factory/cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md"
  - ".factory/research/win-oauth-keychain-blob-limit-2026-09-03.md"
  - ".factory/research/edge-tenant-info-cloudid-2026-09-03.md"
  - "src/api/auth.rs"
  - "src/api/client.rs"
  - "src/api/refresh_coordinator.rs"
  - "src/cli/auth/login.rs"
  - "src/config.rs"
  - "src/cache.rs"
  - "Cargo.toml"
  - "Cargo.lock"
  - "deny.toml"
input-hash: "8f572bf"
---

# Architecture Delta — Windows Correctness (`windows-correctness`, cycle-004)

This document covers the concrete architectural shape for cycle-004's `windows-correctness`
bundle (issues #759, #760; DEC-334; A-PA-LOW-001). It is structured as a delta: only what
changes from today's architecture is described. The decisions themselves — rationale,
alternatives, consequences — live in `ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md`
and `ADR-0022-api-token-cloud-id-acquisition-tenant-info.md`; this document gives the "how,"
concrete enough for the product-owner's parallel F2 BC-authoring pass and for the formal-
verifier's VP-authoring pass to proceed without re-deriving the design.

No `src/` file has been touched by this document. All code shapes below are TARGET design, not
current state, unless explicitly marked "Current."

**Feature type: backend + infrastructure.** No UI surface (`jr` is CLI-only). `dtu_required:
false` — DPAPI is a Windows OS API (syscall FFI, not a network service to twin), and
`/_edge/tenant_info` is an existing-vendor (Atlassian) endpoint the codebase already integrates
with elsewhere (`accessible-resources`, GraphQL org discovery) — neither is a new third-party
service dependency requiring DTU fidelity assessment. `gene_transfusion_required: false` — no
proven reference implementation is being translated; both changes are original, small,
codebase-native designs.

---

## 1. Component / Data-Flow Overview

### 1.1 Current State (baseline, 42e92b46)

```mermaid
flowchart LR
    subgraph Keychain["System Keychain"]
        OAuthPair["&lt;profile&gt;:oauth-access-token\n&lt;profile&gt;:oauth-refresh-token"]
    end

    subgraph Config["config.toml"]
        Profile["[profiles.&lt;name&gt;]\nauth_method, url, cloud_id"]
    end

    LoginOAuth["login_oauth\n(cli/auth/login.rs)"] -->|"set_password x2\n(CredWriteW on Windows,\nno size handling)"| OAuthPair
    LoginOAuth -->|accessible-resources\ndiscovers cloud_id| Profile

    LoginToken["login_token\n(cli/auth/login.rs)"] -->|"no cloud_id\nacquisition at all"| Profile

    OAuthPair -.->|"CredWriteW TooLong\non oversized token\n(Windows only) --\nFIRST call fails,\nmisattributed to\n'locked keychain'"| Fail["jr auth login --oauth\nfails deterministically\non Windows (#759)"]

    ClientRS["JiraClient::from_config\n(client.rs)"] -->|"assets_base_url:\ncloud_id-only, correct"| AssetsGW["api.atlassian.com/ex/jira/&lt;id&gt;/jsm/assets"]
    ConfigRS["Config::base_url()\n(config.rs)"] -->|"auth_method==oauth\nguard ALREADY PRESENT"| CoreGW["api.atlassian.com/ex/jira/&lt;id&gt;\n(oauth only)"]
    ConfigRS -->|"api_token, any cloud_id"| SiteURL["&lt;site&gt;.atlassian.net\n(site URL)"]
```

**Current problems this cycle fixes:**
1. `store_oauth_tokens` has no size-aware routing at all — the first oversized `set_password`
   on Windows fails with `keyring::Error::TooLong`, misreported as "Unlock your keychain."
2. `login_token` never acquires `cloud_id` — Assets/CMDB permanently fails on every API-token
   profile, a gap #759's fix widens by pushing more Windows users onto this path.
3. (Verified, NOT a problem) `Config::base_url()`'s `auth_method == "oauth"` gateway guard and
   `assets_base_url`'s cloud_id-only computation are both **already correct** — see §4.

### 1.2 Target State (this cycle)

```mermaid
flowchart LR
    subgraph Keychain["System Keychain (unchanged shape)"]
        OAuthPair["&lt;profile&gt;:oauth-access-token\n&lt;profile&gt;:oauth-refresh-token"]
    end

    subgraph DPAPI["auth_windows_store.rs (NEW, Windows-only engagement)"]
        Envelope["envelope::{encode,decode,wrap,unwrap}\n(pure, cross-platform testable)"]
        Route["should_fallback_to_dpapi(err)\n(pure, cross-platform testable)"]
        Dpapi["dpapi::{protect,unprotect}\n(impure, #[cfg(windows)], unsafe FFI)"]
        SecretFile["%LOCALAPPDATA%\\jr\\secrets\\&lt;profile&gt;\\oauth-tokens.dat\n(NEW on-disk artifact, non-disposable)"]
    end

    subgraph Config["config.toml"]
        Profile["[profiles.&lt;name&gt;]\nauth_method, url, cloud_id"]
    end

    subgraph Tenant["api/jira/tenant.rs (NEW)"]
        FetchCloudId["fetch_cloud_id(site_url)\n(impure: one unauth GET)"]
    end

    StoreOAuth["store_oauth_tokens\n(auth.rs, MODIFIED)"] -->|"1st attempt, both platforms"| OAuthPair
    StoreOAuth -->|"TooLong -> route whole pair"| Route
    Route --> Envelope --> Dpapi --> SecretFile

    LoadOAuth["load_oauth_tokens\n(auth.rs, MODIFIED)"] -->|"keyring first"| OAuthPair
    LoadOAuth -->|"both absent -> try"| SecretFile

    ClearFns["clear_profile_oauth_pair /\nclear_profile_creds\n(auth.rs, MODIFIED)"] -->|"delete both backends"| OAuthPair
    ClearFns --> SecretFile

    LoginToken["login_token\n(cli/auth/login.rs, MODIFIED)"] -->|"--cloud-id override,\nelse fetch"| FetchCloudId
    FetchCloudId -->|"soft-fail on error"| Profile
    LoginToken -->|"auth_method=api_token"| Profile

    ConfigRS["Config::base_url()\n(config.rs, UNCHANGED --\nverified correct)"] -.->|"auth_method==oauth\nguard already gates gateway"| CoreGW["gateway (oauth only)"]
    ConfigRS -.-> SiteURL["site URL (api_token, any cloud_id)"]
```

---

## 2. New Modules

### 2.1 `src/api/auth_windows_store.rs` (NEW)

Sibling module to `src/api/auth.rs`, following the same "thin sibling module" pattern already
established by `src/api/auth_embedded.rs`. Subsystem: **SS-03** (HTTP Client Core — this
module's Primary Source Files list gains this file).

**Anchor justification (verified against ARCH-INDEX.md, Pass-2 review Finding #9).** SS-03's own
Subsystem Registry entry (`ARCH-INDEX.md`) already lists `src/api/auth.rs` and
`src/api/auth_embedded.rs` as SS-03 member files — neither does any HTTP itself (`auth_embedded.rs`
is XOR-obfuscated embedded-credential plumbing with zero network calls; `auth.rs`'s keychain/DPAPI
code is not HTTP either). SS-03's registry description ("HTTP Client Core") is therefore broader
in practice than its label: it is this codebase's auth-and-HTTP-client-infrastructure subsystem,
not literally "code that makes HTTP requests." `auth_windows_store.rs` belongs to SS-03 for the
same reason `auth_embedded.rs` does — it is a thin sibling module extending `auth.rs`'s
credential-storage responsibility, not because it performs HTTP I/O (it performs none: DPAPI
syscalls and local file I/O only). This is a consistent placement, not a mis-anchor; no change to
the Subsystem Registry or to this module's anchor is needed.

**Public/`pub(crate)` interface** (see ADR-0021 §3 for full signatures and doc comments):

| Item | Visibility | Purity | Cross-platform behavior |
|------|-----------|--------|--------------------------|
| `envelope::encode(access, refresh) -> Vec<u8>` | `pub(crate)` | **Pure** | Identical on all platforms |
| `envelope::decode(bytes) -> Result<(String,String)>` | `pub(crate)` | **Pure** | Identical on all platforms |
| `envelope::wrap(protected) -> Vec<u8>` | `pub(crate)` | **Pure** | Identical on all platforms |
| `envelope::unwrap(file_bytes) -> Result<&[u8]>` | `pub(crate)` | **Pure** | Identical on all platforms |
| `should_fallback_to_dpapi(err: &keyring::Error) -> bool` | `pub(crate)` | **Pure** | Identical on all platforms |
| `engage_dpapi_fallback(err: &keyring::Error) -> bool` (in `auth.rs`, NOT `auth_windows_store.rs`) | private | **Pure** | `#[cfg(windows)]`: delegates to `should_fallback_to_dpapi`. `#[cfg(not(windows))]`: `false` in production (call-site gate closing Finding #5, Pass-1 review; `store_oauth_tokens`'s match guards call this, never `should_fallback_to_dpapi` directly, so `DpapiFallbackFailed` can never be produced on non-Windows in a release build). **In `#[cfg(debug_assertions)]` builds only, additionally honors the `JR_FORCE_DPAPI_FALLBACK=1` opt-in test seam** (Pass-5 review, Finding #1) — delegates to `should_fallback_to_dpapi` when set, else still `false`. Production/release behavior is unchanged either way. |
| `store_pair(profile, access, refresh) -> Result<()>` | `pub` | **Impure** (I/O + syscall) | Guard (`reject_unsafe_profile_component`, via `file_path`) is invoked FIRST on BOTH cfg arms (Pass-4 review, Finding #2). `#[cfg(windows)]`: guard, then real DPAPI + atomic file write. `#[cfg(not(windows))]`: guard, then always returns the honest-fail `DpapiFallbackFailed` error immediately — no file I/O attempted. |
| `load_pair(profile) -> Result<Option<(String,String)>>` | `pub` | **Impure** (I/O + syscall) | Guard invoked FIRST on BOTH cfg arms (Pass-4 review, Finding #2). `#[cfg(windows)]`: guard, then real file read + DPAPI unprotect. `#[cfg(not(windows))]`: guard, then always `Ok(None)` — no file I/O attempted. |
| `remove_if_present(profile) -> Result<()>` | `pub` | **Impure** (I/O) | Guard invoked FIRST on BOTH cfg arms (Pass-4 review, Finding #2). `#[cfg(windows)]`: guard, then real delete, `NotFound`-tolerant. `#[cfg(not(windows))]`: guard, then always `Ok(())` immediately. Signature/contract UNCHANGED by Pass-8 review (Finding #3) — see `clear_dpapi_file_tolerating_path_escape` below for the caller-side change. |
| `clear_dpapi_file_tolerating_path_escape(profile) -> Result<()>` (in `auth.rs`, NOT `auth_windows_store.rs`; Pass-8 review Finding #3) | private | **Impure** (delegates to `remove_if_present`) | Identical on all platforms. Adapter used ONLY by `clear_profile_oauth_pair`/`clear_profile_creds`: calls `remove_if_present`, then maps `Err(e)` where `e.downcast_ref::<ProfilePathEscape>()` is `Some` to `Ok(())` (tolerated, equivalent to `NotFound`); any other `Err` propagates unchanged. Provably safe: `reject_unsafe_profile_component` is also `store_pair`'s mandatory first statement, so a guard-rejected name could never have had a DPAPI file written for it. NOT used by `store_oauth_tokens`'s best-effort post-success cleanup call (already discards all errors via `let _ =`) or by any store/read-path call site (those correctly keep rendering `ProfilePathEscape` distinctly). |
| `dpapi::protect(plaintext) -> io::Result<Vec<u8>>` | private, `#[cfg(windows)]` | **Impure** (unsafe FFI) | Windows-only; does not exist in a non-Windows compilation unit at all. |
| `dpapi::unprotect(blob) -> io::Result<Vec<u8>>` | private, `#[cfg(windows)]` | **Impure** (unsafe FFI) | Windows-only; does not exist in a non-Windows compilation unit at all. |
| `DpapiFallbackFailed(String)` marker error | `pub(crate)` | n/a (data) | Identical on all platforms |
| `reject_unsafe_profile_component(profile) -> Result<(), ProfilePathEscape>` (Pass-2 review Finding #1, ADR-0021 §9) | `pub(crate)` | **Pure** | Host-independent Windows-syntax recognizer — NOT `std::path` — so behavior is identical regardless of the OS `cargo test` runs on; the sole call site is `file_path`, invoked first by all three of `store_pair`/`load_pair`/`remove_if_present`, on BOTH their cfg arms (Pass-4 review, Finding #2 — the guard call is not merely conceptually first, it is a mandatory first statement in every cfg-gated function body, so its wiring is regression-catchable on default Linux/macOS CI). Reserved-device-name recognition extended (Pass-4 review, Finding #3) to include the Unicode superscript-digit `COM`/`LPT` variants and leading-space-trimmed stem matching — final set is 30 names, see ADR-0021 §9. |
| `ProfilePathEscape` marker error (Pass-2 review Finding #1, ADR-0021 §9) | `pub(crate)` | n/a (data) | Identical on all platforms |
| `CorruptSecretFile(String)` marker error (Pass-2 review Finding #2, ADR-0021 §3) | `pub(crate)` | n/a (data) | Identical on all platforms; distinguishes a corrupt/undecryptable `load_pair` result from a genuine backend/IO error, mirroring `DpapiFallbackFailed`'s discrimination pattern. |

**Wiring to existing callers** (all in `src/api/auth.rs`):
- `store_oauth_tokens` — modified per ADR-0021 §2 (backend-selection-level routing + rollback).
- `load_oauth_tokens` — modified per ADR-0021 §4 (DPAPI-file fallback branch inserted before
  the existing `"default"`-only legacy recovery).
- `clear_profile_oauth_pair`, `clear_profile_creds` — each gains one DPAPI-removal step, called
  through a NEW private adapter, `clear_dpapi_file_tolerating_path_escape(profile)` (ADR-0021 §7,
  Pass-8 review Finding #3) — NOT a direct `auth_windows_store::remove_if_present(profile)` call.
  The adapter treats a `ProfilePathEscape` result as TOLERATED (equivalent to `NotFound`), never
  a genuine error, so a pre-existing profile whose name collides with BC-1.4.040's guard is still
  fully cleared on every OS. `remove_if_present`'s own signature/contract is unchanged; only the
  clear path's interpretation of its `ProfilePathEscape` outcome changes.
- `oauth_login`'s and `refresh_oauth_token_with_url`'s `store_oauth_tokens` `map_err` closures —
  branch on `e.downcast_ref::<auth_windows_store::DpapiFallbackFailed>()` (ADR-0021 §6).
- `load_oauth_tokens`'s new DPAPI-fallback-read branch — branches on
  `e.downcast_ref::<auth_windows_store::CorruptSecretFile>()` to select the force-re-login
  message vs. the distinct backend/IO-error message (ADR-0021 §3/§4, Pass-2 review Finding #2).
- Whichever call site first surfaces a `ProfilePathEscape` to the user — maps it to
  `JrError::UserError` (exit 64) via the same downcast convention, a new branch alongside the
  `DpapiFallbackFailed` one (ADR-0021 §9, Pass-2 review Finding #1; exact call site is F4 scope).

No other file needs to know this module exists — every existing call site of
`store_oauth_tokens`/`load_oauth_tokens`/`clear_profile_*` (F1 §5.3: `refresh_coordinator.rs`,
`cli/auth/{login,refresh,logout,remove,status}.rs`, `client.rs`) is unaffected by signature —
only by behavior, and only in the oversized-secret case that previously crashed on Windows.

### 2.2 `src/api/jira/tenant.rs` (NEW)

New file in the existing `src/api/jira/` product-namespaced directory. Subsystem: **SS-04**
(Jira API Resources — already covers this directory generically; no Subsystem Registry text
change needed).

**Public interface** (see ADR-0022 §1 for the full implementation):

| Item | Visibility | Purity | Notes |
|------|-----------|--------|-------|
| `fetch_cloud_id(site_url: &str) -> Result<String>` | `pub` | **Impure** (network I/O) | Plain `reqwest` call, NOT routed through `JiraClient` (mirrors `oauth_login`'s direct `accessible-resources` call — no authenticated client exists yet at login time). Client is built with `redirect::Policy::none()` (Finding #12, Pass-1 review) — a 3xx response is treated as a plain non-2xx failure, never followed cross-host. Does not share `JiraClient`'s proxy/CA config (Finding #14, accepted — see ADR-0022 §1). Requires `site_url` to start with `https://` (case-insensitive) — an `http://` or scheme-less site skips the fetch entirely with no network call, soft-failing identically to any other fetch failure (Finding #4, Pass-4 review — see ADR-0022 §1). |

**Wiring to existing callers:**
- `src/cli/auth/login.rs::login_token` — gains a `cloud_id_override: Option<&str>` parameter
  (mirroring `login_oauth`'s existing parameter of the same name) and calls `fetch_cloud_id`
  when no override is supplied, per the fallback chain in ADR-0022 §2.
- `src/cli/auth/login.rs::handle_login` — passes `args.cloud_id.as_deref()` through to
  `login_token` (currently dropped on the API-token branch — this is the concrete one-line
  dispatch fix).
- `src/cli/auth/refresh.rs::refresh_credentials` (Pass-3 adversarial review, Finding #2) — a
  SECOND, previously-unlisted direct `login_token` caller; the new parameter makes this a
  compile-forcing change here too. Updated call: `login_token(&target, args.email, args.token,
  None, args.no_input).await` — `None` hardcoded (no `RefreshArgs.cloud_id` field, no
  `--cloud-id` support added), mirroring the identical `None` already hardcoded on this
  function's sibling `login_oauth` call. Consequence: `jr auth refresh` on an api_token profile
  now performs the tenant_info fetch on every invocation — see ADR-0022 §2's "Decision" note for
  why this is intentional, not a gap.
- `src/cli/init.rs` (API-token branch) — must call the same `login_token`/`fetch_cloud_id`
  plumbing, not a second independent tenant_info call site (ADR-0022 §2). Exact `init.rs`
  wiring is an F3/F4 story-authoring detail.

---

## 3. Modified Components

| Component | File : Symbol | Change | Governing ADR |
|-----------|---------------|--------|----------------|
| `store_oauth_tokens` | `src/api/auth.rs` | Backend-selection-level routing on `keyring::Error::TooLong`; rollback of a partial keyring write; delegates to `auth_windows_store::store_pair` | ADR-0021 §2 |
| `load_oauth_tokens` | `src/api/auth.rs` | New DPAPI-file-fallback branch when both namespaced keyring keys are absent; extended (not replaced) partial-state handling | ADR-0021 §4 |
| `clear_profile_oauth_pair` | `src/api/auth.rs` | Additional DPAPI-removal step via the new `clear_dpapi_file_tolerating_path_escape` adapter (NOT a direct `remove_if_present` call) — tolerates `ProfilePathEscape` as a no-op | ADR-0021 §7 (Pass-8 review Finding #3) |
| `clear_profile_creds` | `src/api/auth.rs` | Same adapter-wrapped DPAPI-removal step as above, within its existing four-step delete | ADR-0021 §7 (Pass-8 review Finding #3) |
| `clear_all_credentials` (test-only) | `src/api/auth.rs` | Test-fixture parity update only — no behavior/production-callers change (F1 §5.2 row 5) | ADR-0021 (incidental) |
| `oauth_login`'s store-failure `map_err` | `src/api/auth.rs` | Branches on `DpapiFallbackFailed` marker; new honest-fail message on that arm only | ADR-0021 §6 |
| `refresh_oauth_token_with_url`'s post-refresh store-failure `map_err` | `src/api/auth.rs` | Same branch shape as above | ADR-0021 §6 |
| `refresh_oauth_token_with_url`'s read-failure branch | `src/api/auth.rs` | No message change; becomes DPAPI-aware transitively via the corrected `load_oauth_tokens` | ADR-0021 §6 |
| `login_token` | `src/cli/auth/login.rs` | New `cloud_id_override` parameter; calls `fetch_cloud_id` per the fallback chain; soft-fail on failure | ADR-0022 §2 |
| `handle_login` | `src/cli/auth/login.rs` | Passes `args.cloud_id.as_deref()` to `login_token` (currently dropped) | ADR-0022 §2 |
| `refresh_credentials` | `src/cli/auth/refresh.rs` | Second, previously-unlisted `login_token` call site updated for the new parameter (hardcoded `None`, mirroring the sibling `login_oauth` call on the same function); `auth refresh` on an api_token profile now triggers the tenant_info fetch on every invocation (intentional — ADR-0022 §2 "Decision") | ADR-0022 §2 (Pass-3 Finding #2) |
| `Cargo.toml` | root | New `[target.'cfg(windows)'.dependencies]` section: `windows-sys` (direct, `Win32_Security_Cryptography` + `Win32_Foundation` features) | ADR-0021 §5 |
| `deny.toml` | root | `reason` field of the existing `windows-sys` version `"0.60"` `[[bans.skip]]` entry updated to name `jr`'s own DPAPI usage alongside keyring's `windows-native` feature | ADR-0021 §5 |

## 4. Confirmed-Unchanged (verified during this F2 pass, not re-implemented)

- **`Config::base_url()`** (`src/config.rs`) already gates the OAuth gateway URL
  (`https://api.atlassian.com/ex/jira/{cloud_id}`) behind `profile.auth_method.as_deref() ==
  Some("oauth")`; any other `auth_method` — including `api_token` and an unset `auth_method`
  (which `JiraClient::from_config` defaults to `api_token` via `.unwrap_or("api_token")`) —
  falls through to the site URL regardless of whether `cloud_id` is present. This is the guard
  research Question E ("A-PA-LOW-001") recommends; it already exists. **No change.**
- **`JiraClient::from_config`'s `assets_base_url` computation** (`src/api/client.rs`) derives
  the Assets/CMDB gateway URL from `profile.cloud_id` alone, with no `auth_method` gate. This
  remains the architecturally correct shape — Assets has no site-URL alternative for its data
  calls — but **whether the gateway actually accepts `jr`'s classic-token Basic auth is
  unconfirmed** (Pass-1 review Finding #1: the research's supporting evidence, issue #185, is
  for a scoped token only; see ADR-0022 Context and Consequences). **No code change**, but do not
  read this row as confirming Assets succeeds for classic tokens — the guaranteed benefit of this
  cycle's fix is A-PA-LOW-001 closure (fresh/correct `cloud_id` persisted), not Assets success.

Both confirmations are documented explicitly in ADR-0022 §4 so a future pass does not
mistakenly "fix" either a second time.

---

## 5. Dependency Graph Impact

```mermaid
flowchart TD
    auth_rs["api/auth.rs"] --> auth_windows_store["api/auth_windows_store.rs (NEW)"]
    auth_windows_store --> cache_rs["cache.rs (cache_root(), reused read-only)"]
    auth_windows_store -.->|"#[cfg(windows)] only"| windows_sys["windows-sys (direct dep, cfg(windows))"]
    auth_windows_store --> profile_rs["profile.rs (Profile newtype, reused)"]

    login_rs["cli/auth/login.rs"] --> jira_tenant["api/jira/tenant.rs (NEW)"]
    jira_tenant --> reqwest["reqwest (existing dep)"]

    refresh_coordinator["api/refresh_coordinator.rs"] --> auth_rs
    client_rs["api/client.rs"] --> auth_rs
    login_rs --> auth_rs
    logout_rs["cli/auth/logout.rs"] --> auth_rs
    remove_rs["cli/auth/remove.rs"] --> auth_rs
```

**Acyclicity check:** `auth_windows_store.rs` depends only on `cache.rs` (read-only reuse of
`cache_root()`) and `profile.rs` (the `Profile` newtype) — both already-leaf-ward modules
relative to `auth.rs` in the existing graph (`auth.rs` already depends on both). `auth.rs`
gains a new outgoing edge to `auth_windows_store.rs`; `auth_windows_store.rs` has **no** edge
back to `auth.rs`. `api/jira/tenant.rs` depends only on `reqwest` (external) — no edge to
`auth.rs`, `config.rs`, or any other `api/jira/` sibling. `cli/auth/login.rs` gains one new
outgoing edge to `api/jira/tenant.rs`, consistent with its existing role as the orchestration
layer that already depends on `api/auth.rs`, `config.rs`, and other `api/` modules. **No new
cycle is introduced; the graph remains acyclic.**

---

## 6. Purity Boundary Map Update

| Module / Function | Classification | Notes |
|---|---|---|
| `auth_windows_store::envelope::{encode,decode,wrap,unwrap}` | **Pure Core** | Deterministic byte transforms; no I/O, no syscalls. Unit-testable on any OS/CI runner. |
| `auth_windows_store::should_fallback_to_dpapi` | **Pure Core** | Deterministic predicate over a `keyring::Error` value. Unit-testable on any OS/CI runner. |
| `auth_windows_store::reject_unsafe_profile_component` | **Pure Core** | Host-independent character-level recognizer, not `std::path` (ADR-0021 §9, Pass-2 review Finding #1). Unit-testable on any OS/CI runner — including Windows-syntax vectors (drive letters, ADS colons, UNC prefixes) run from Linux/macOS CI, since the recognizer never delegates to the host's own path parser. |
| `auth_windows_store::store_pair` / `load_pair` / `remove_if_present` | **Effectful Shell** | File I/O + (on Windows) DPAPI syscalls. The `#[cfg(not(windows))]` arms are still "effectful" by classification (they are the boundary functions), even though they perform no actual I/O — the classification follows the function's role, not whether a given cfg-arm happens to touch disk. |
| `auth_windows_store::dpapi::{protect,unprotect}` | **Effectful Shell** (`unsafe`) | Windows-only FFI. The sole `unsafe` code in this module tree; two functions, unit-testable only via real `CryptProtectData`/`CryptUnprotectData` round-trips (Windows CI or manual, per F1 §10). |
| `api/jira/tenant::fetch_cloud_id` | **Effectful Shell** | Network I/O (`reqwest`). No pure sub-component to extract — the entire function is "make one HTTP call, parse one field." |
| `store_oauth_tokens` / `load_oauth_tokens` (post-change) | **Effectful Shell** (unchanged classification) | Already effectful (keychain I/O) before this cycle; the new DPAPI-routing logic they call out to is itself split pure/impure per the rows above, but the calling functions remain shell-classified as a whole. |
| `login_token` (post-change) | **Effectful Shell** (unchanged classification) | Already effectful (keychain + config I/O); gains one more effectful call (`fetch_cloud_id`). |

This split directly answers the F1 §10 Windows-only-testability risk: the routing DECISION
(`should_fallback_to_dpapi`) and the envelope FORMAT (`encode`/`decode`/`wrap`/`unwrap`) are
fully covered by ordinary `cargo test` on macOS/Linux CI; only the two-function DPAPI FFI
wrapper and a genuine end-to-end `jr auth login --oauth` round-trip require Windows CI or
manual validation.

---

## 7. Verification-Property Hooks (for the formal-verifier's F2 pass)

Carried forward from F1 §7.4, now targeted at the concrete modules above — the formal-verifier
owns drafting the actual VP-NNN documents; this section only pins target module + tool:

| VP (F1-provisional ID) | Target | Tool | Platform |
|---|---|---|---|
| VP-AUTHDX-010 | `auth_windows_store::dpapi::{protect,unprotect}` round-trip | Manual / Windows CI integration test | Windows-only |
| VP-AUTHDX-011 | `store_oauth_tokens`'s `TooLong` routing (§2 of ADR-0021) | proptest / unit test (mocked `keyring::Error`) | Cross-platform for the pure `should_fallback_to_dpapi` predicate, no seam needed. Cross-platform for the ROUTING dispatch (that `store_oauth_tokens` actually calls `store_pair` on `TooLong`) **only with `JR_FORCE_DPAPI_FALLBACK=1` engaged** (Pass-5 review, Finding #1) — see §14 below; without the seam, that dispatch is unreachable on non-Windows and the sub-property is Windows-only. |
| VP-AUTHDX-012 | Atomic dual-write invariant (rollback-on-partial-overflow, ADR-0021 §2) | Unit test with a fault-injection seam (mirrors the existing `JR_S303_PERSIST_FAIL` pattern) | Cross-platform for the rollback/ordering LOGIC **only with `JR_FORCE_DPAPI_FALLBACK=1` engaged** (Pass-5 review, Finding #1) — without it, the logic is unreachable on non-Windows. Windows CI for the real file-rename/fsync/age-gated-cleanup step (unaffected by the seam — that code exists only in `store_pair`'s `#[cfg(windows)]` arm). |
| VP-AUTHDX-013 | Cross-platform non-engagement of `#[cfg(windows)] mod dpapi` | Compile-time (`cfg`-gated absence), not a runtime test | Cross-platform (proves absence on non-Windows) |
| (new, unnumbered — formal-verifier to allocate) | `api/jira/tenant::fetch_cloud_id` — soft-fail on non-2xx/network error/malformed JSON | Unit test with `wiremock` | Cross-platform |
| (new, unnumbered — formal-verifier to allocate) | `login_token`'s `cloud_id` refresh-not-clear behavior on a mechanism switch (ADR-0022 §3), AND `jr auth refresh`'s direct `login_token` call triggering the fetch on every invocation (ADR-0022 §2 "Decision", Pass-3 Finding #2) | Integration test extending `tests/auth_chosen_flow_reconcile.rs` | Cross-platform |
| (new, unnumbered — formal-verifier to allocate; Pass-3 Finding #1, STALE-KEYRING-SHADOWS-DPAPI; **CI classification corrected Pass-5, Finding #1 — see §14/guidance below**) | `store_oauth_tokens`'s keyring-clear-before-DPAPI-store route (ADR-0021 §2): given a PRE-EXISTING complete keyring pair for a profile AND a fresh `access` write that returns `TooLong` (both the access-overflow arm and the refresh-overflow-after-access-succeeded arm), assert that after `store_oauth_tokens` returns `Ok`: (a) both namespaced keyring keys are absent, (b) the DPAPI file contains the fresh pair, and (c) a subsequent `load_oauth_tokens` returns the fresh DPAPI pair — never the stale keyring values | Unit test with a fault-injection seam producing `keyring::Error::TooLong` on a pre-seeded keyring pair | **Windows-only for the (a)+(b)+(c) success oracle as written** (requires `store_oauth_tokens` to return `Ok`, which is impossible on non-Windows regardless of any seam — `store_pair`'s `#[cfg(not(windows))]` arm always fails). **Cross-platform, but ONLY with `JR_FORCE_DPAPI_FALLBACK=1` engaged**, for the narrower delete-then-fail sub-property: given the same pre-existing pair and `TooLong`, both keyring keys are deleted BEFORE `store_pair` is attempted, and on `store_pair`'s (guaranteed, off-Windows) failure, `store_oauth_tokens` returns `Err` with neither backend populated. Without the seam, NEITHER sub-property is reachable in default CI — the whole match arm is dead code on non-Windows. |

---

## 8. Regression Baseline (unaffected by this cycle, confirm at F7)

Unchanged from F1 §9's "explicitly NOT changed" list: `src/api/auth_embedded.rs`,
`src/profile.rs`, all non-auth CLI command families, every `types/`/`adf.rs`/`jql.rs`/
`duration.rs`/`observability.rs`/`output.rs` module. Additionally confirmed unchanged by this
delta (§4): `Config::base_url()`'s gateway guard, `JiraClient::from_config`'s `assets_base_url`
computation.

---

## 9. Residual Design Questions Flagged for Product-Owner / Formal-Verifier / F2 Gate

1. **Profile-name-as-filename trust boundary — RESOLVED this pass (Pass-2 adversarial review,
   Finding #1).** `Profile::from(String)` performs **no validation** (`src/profile.rs`,
   "Infallible by design," ADR-0011) — a profile name can be any string, including one
   containing path-traversal-unsafe characters. This item was originally flagged here as a
   hardening opportunity for the formal-verifier to decide on; the product-owner/formal-verifier
   subsequently committed it as BC-1.4.040/VP-AUTHDX-016 this same F2 pass, described only as a
   "Windows-syntax-aware" guard — ambiguous enough that a `std::path`-based implementation run on
   Linux CI would silently accept `"C:\\evil"`, `"\\\\server\\share"`, and `"name:$DATA"` as
   ordinary filenames (Pass-2 Finding #1). ADR-0021 §9 now mandates a concrete, host-independent
   recognizer (`reject_unsafe_profile_component`, never `std::path`) wired as the first statement
   of `file_path`, itself the sole call site reached by all three of `store_pair`/`load_pair`/
   `remove_if_present`. This guard is scoped to the NEW `auth_windows_store.rs` secrets path only
   — `cache_dir(profile)` (`src/cache.rs`)'s pre-existing, unguarded join for the
   lower-sensitivity, disposable cache namespace remains untouched and is still a separate,
   inherited (not new) risk, out of this cycle's scope. See the "Pass-2 architect guidance for
   product-owner and formal-verifier" section below for the required BC-1.4.040/VP-AUTHDX-016
   wording correction.
2. **`jr init`'s exact API-token wiring** (ADR-0022 §2) is intentionally left to F3/F4
   story-authoring rather than specified line-by-line here, since `init.rs` was not read in
   full during this pass — only its existing call-through-to-`login_token` relationship
   (documented in ADR-0020's Context) was confirmed. The product-owner/story-writer should
   verify `init.rs`'s API-token branch actually calls `login_token` (not a separate, parallel
   credential-write path) before assuming this ADR's fix reaches it for free.
3. **Windows-only testability / manual validation gate** (carried forward from F1 §10,
   unresolved by this architecture pass by design — it is a process question, not a design
   one): is a manual smoke test on real Windows an acceptable, available F7 gate, or does F4
   need to first spike whether `windows-latest` GitHub Actions CI can exercise
   `CryptProtectData` end-to-end? This materially affects how much of ADR-0021's DPAPI logic
   gets CI coverage vs. manual-only coverage, and should be resolved before F4 commits to a
   story estimate.
4. **BC/EC allocation for the mechanism-switch refresh behavior** (ADR-0022 §3): the fix has no
   dedicated code branch (it falls out of `login_token`'s general behavior), so it is easy to
   under-specify at the BC layer. The product-owner's BC-authoring pass should write an explicit
   BC/EC pair for "oauth→api_token switch refreshes cloud_id on success, preserves the prior
   value on fetch failure" so it gets its own test, not just incidental coverage from
   `login_token`'s general-case tests.

---

## 10. Pass-1 Adversarial Review Amendments (2026-09-03)

A Pass-1 adversarial review of this F2 spec delta raised 6 findings, all resolved by editing
ADR-0021/ADR-0022 (and, for Finding #1, this document's §4) directly — no `src/` change, no
scope change to what F4 implements beyond what the ADRs already specified:

| # | Sev | Finding (one-line) | Resolution |
|---|-----|---------------------|------------|
| 1 | HIGH | ADR-0022 presented the Assets-succeeds-after-`cloud_id` path as settled; the research's gateway-Basic-auth confirmation (#185) is for a **scoped** token only, not `jr`'s classic tokens. | ADR-0022 Context/§4/Consequences rewritten to scope the guaranteed benefit to A-PA-LOW-001 closure only; this doc's §4 bullet corrected. See guidance note below for BC-1.2.054. |
| 5 | MED | `should_fallback_to_dpapi` engaged on any OS; a non-Windows `TooLong` would route through `store_pair`'s `#[cfg(not(windows))]` arm and render a Windows-specific honest-fail message, contradicting BC-1.4.035 Invariant 3. | ADR-0021 §1/§2 add a `#[cfg(windows)]`-gated `engage_dpapi_fallback` call-site wrapper; `should_fallback_to_dpapi` itself stays pure/cross-platform-testable. See guidance note below for BC-1.4.035/BC-1.4.039. |
| 11 | LOW/MED | DPAPI file's security posture (no `pOptionalEntropy`, plain file, same-user trust boundary) was unstated. | ADR-0021 new §8 documents the posture explicitly, justifies omitting entropy, and specifies ACL/inheritance expectations + an F4 verification task. |
| 12 | LOW | `fetch_cloud_id` used `reqwest`'s default (redirect-following) policy — a redirect could deliver a `cloudId` from a different host/tenant. | ADR-0022 §1 adds `redirect::Policy::none()`; a redirect now surfaces as an ordinary soft-fail. |
| 13 | LOW | Dual version fields (inner JSON `version`, outer 1-byte wrap-header version) had no stated relationship. | ADR-0021 §3 clarifies: outer governs ciphertext framing, inner governs plaintext schema; both are independently checked; outer header's lack of authentication is explicitly reasoned as safe. |
| 14 | LOW | `fetch_cloud_id`'s bare `reqwest::Client` doesn't share `JiraClient`'s proxy/CA config — silent soft-fail in proxied/custom-CA environments. | ADR-0022 §1 documents the divergence explicitly, notes it is not new (mirrors `oauth_login`'s existing `accessible-resources` call), and accepts it for this cycle with a tracked follow-up. |
| 17 | LOW | Atomicity reasoned only against process-kill; no fsync before rename, no orphaned-`.tmp-*`-file cleanup specified. | ADR-0021 §3 adds an explicit fsync-before-rename requirement and a best-effort pre-write cleanup of stale `*.tmp-*` siblings. |

---

## Pass-1 architect guidance for product-owner

### Finding #1 — rescope BC-1.2.054 EC-1.2.054-3

Rescope EC-1.2.054-3 so it no longer asserts that Assets/CMDB succeeds as a consequence of
`cloud_id` acquisition. The architecture's only **guaranteed** benefit (ADR-0022, Context and
Consequences, Finding #1) is closing A-PA-LOW-001: a correct, fresh `cloud_id` is persisted for
the API-token profile; core Jira REST v3 calls remain unaffected either way (already inert to a
stale `cloud_id` via `Config::base_url()`'s existing `auth_method == "oauth"` guard); and any
Assets/CMDB attempt is tied to the right tenant, producing either a genuine response or a clean,
`cloud_id`-specific error — never a silent stale-tenant misdirection. Whether the Assets gateway
(`api.atlassian.com/ex/jira/{cloudId}/jsm/assets/...`) actually accepts `jr`'s **classic**
API-token Basic auth is **unconfirmed** — the only supporting evidence (issue #185, cited in
`.factory/research/edge-tenant-info-cloudid-2026-09-03.md` §E) is for a **scoped** token, and
Atlassian documents classic tokens as belonging on the site URL with no gateway guarantee.
EC-1.2.054-3 must therefore be worded as a conditional/best-effort outcome (e.g., "IF the Jira
instance's Assets gateway accepts the profile's API-token auth, THEN Assets commands succeed
after `cloud_id` acquisition; acquisition itself is unconditional and does not depend on Assets
working") rather than an unconditional "Assets works" assertion, and its test should assert the
acquisition/persistence behavior (fresh `cloud_id` stored; the correct error surfaced to Assets
callers on failure) rather than asserting a live Assets 200 response, which this architecture
cannot guarantee for classic tokens.

### Finding #5 — required BC-1.4.035 / BC-1.4.039 wording

Word BC-1.4.035 Invariant 3 ("macOS/Linux byte-for-byte UNCHANGED") as a **structural**
guarantee, not an incidental one: the DPAPI-fallback engagement check in `store_oauth_tokens` is
`#[cfg(windows)]`-gated at the call site (a new `engage_dpapi_fallback` wrapper, ADR-0021 §1/§2),
so on non-Windows a `keyring::Error::TooLong` — however unlikely a given backend is to produce
one — is matched and propagated exactly as before this fix: `auth_windows_store::store_pair`/
`load_pair` are never reached, and `DpapiFallbackFailed` can never be produced by
`store_oauth_tokens` on a non-Windows build. Invariant 3's test should assert this call-site
gating directly (e.g., feed a mocked `TooLong` error into `store_oauth_tokens` on a non-Windows
test run and assert the **legacy** "Unlock your keychain" message appears, not the new
honest-fail text) rather than only asserting no observable behavior change under normal
(non-error) conditions. BC-1.4.039 (the honest-fail message) should be worded as Windows-only
**by construction** — state explicitly that the `DpapiFallbackFailed`-branch message is
unreachable on macOS/Linux, not merely "not currently triggered there" — since the gate makes
this a structural, testable guarantee rather than a probabilistic one.

---

## 11. Pass-2 Adversarial Review Amendments (2026-09-03)

A Pass-2 adversarial review of this F2 spec delta (run after the product-owner/formal-verifier
delivered BC-1.4.040/VP-AUTHDX-016 and the vp-delta.md CI-classification table) raised 5
findings, all resolved by editing ADR-0021 and this document directly — no `src/` change, no
scope change to what F4 implements beyond what ADR-0021 §9/§3 now concretely specify:

| # | Sev | Finding (one-line) | Resolution |
|---|-----|---------------------|------------|
| 1 | HIGH | BC-1.4.040/VP-AUTHDX-016's path-traversal guard was specified only as "Windows-syntax-aware" — ambiguous enough that a `std::path`-based implementation run on Linux CI would lexically-contain (and thus wrongly ACCEPT) `"C:\\evil"`, `"\\\\server\\share"`, and `"name:$DATA"`, falsifying the "runs in default CI, cross-platform" VP claim as written. | ADR-0021 new §9 mandates a host-independent recognizer (`reject_unsafe_profile_component`, never `std::path`), wired as `file_path`'s first statement, reached by all three of `store_pair`/`load_pair`/`remove_if_present`. This document's §9 item 1 marked resolved; §2.1/§6 tables updated. See guidance note below for the required BC-1.4.040/VP-AUTHDX-016 wording and vp-delta.md correction. |
| 2 | MED | ADR-0021 §3 defined `load_pair -> anyhow::Result<Option<(String,String)>>` with no read-path marker type, so BC-1.4.036's mandated "corrupt content vs. backend/IO error" distinction (mirroring `DpapiFallbackFailed`) had no expressible mechanism — an implementer would be forced into ad-hoc `bail!` string-matching. | ADR-0021 §3 adds a `CorruptSecretFile` marker type (same downcast convention as `DpapiFallbackFailed`); §4's read-path bullet list now branches explicitly on `downcast_ref::<CorruptSecretFile>()` vs. a genuine backend/IO error, each with its own distinct message. `load_pair`'s public signature is unchanged. |
| 6 | LOW | `store_pair`'s "best-effort remove any stale `*.tmp-*` siblings before writing" was a blanket delete — two concurrent `jr` processes (login racing refresh) for the same profile could have process B's cleanup delete process A's in-flight temp file, breaking A's rename. `refresh_coordinator.rs` single-flights only within one process. | ADR-0021 §3 changes the cleanup to an age-gated delete (`STALE_TMP_THRESHOLD` = 30s) — a temp file younger than the threshold is assumed to be another process's in-flight write and is left alone; only a genuinely abandoned (crashed) prior attempt is removed. The residual cross-process concurrency boundary is stated explicitly (no new locking added; out of DEC-334's scope). |
| 4 | LOW | ADR-0021 §9's reserved-device-name set (`CON`/`PRN`/`AUX`/`NUL`/`COM1-9`/`LPT1-9`) omitted the console pseudo-handle reserved names `CONIN$`/`CONOUT$` — legitimate, real Win32 reserved device names (the active console's input/output buffer), not a stylistic variant of `CON`. | ADR-0021 §9's `is_reserved_windows_device_name` match set extended to add `"CONIN$" \| "CONOUT$"` (case-insensitive, stem-matched like every other entry). Final complete reserved-name set: `CON`, `PRN`, `AUX`, `NUL`, `CONIN$`, `CONOUT$` (6) + `COM1`–`COM9` (9) + `LPT1`–`LPT9` (9) = **24 names** (see ADR-0021 §9 for the authoritative list — cited by reference here rather than re-stated as a bare count, to avoid this exact class of drift). This guidance section's Finding #1 paragraph updated to match. |
| 9 | LOW (verify intent) | `architecture-delta.md` §2.1 anchors `auth_windows_store.rs` to SS-03 "HTTP Client Core," but the module does DPAPI syscalls + file I/O with zero HTTP. | Verified against `ARCH-INDEX.md`'s Subsystem Registry: `src/api/auth.rs` and `src/api/auth_embedded.rs` (also zero-HTTP) are both already canonically SS-03 — the registry's "HTTP Client Core" label is broader in practice than its name, covering this codebase's auth-and-HTTP-client-infrastructure subsystem. `auth_windows_store.rs`'s SS-03 placement is consistent (sibling to `auth.rs`/`auth_embedded.rs`), not a mis-anchor. §2.1 gains a one-line rationale; the anchor itself is UNCHANGED. |

---

## Pass-2 architect guidance for product-owner and formal-verifier

### Finding #1 — required BC-1.4.040 / VP-AUTHDX-016 wording, and the vp-delta.md CI-count correction

**For the product-owner (BC-1.4.040).** Reword the guard's requirement from "Windows-syntax-aware"
to name the concrete mechanism ADR-0021 §9 now mandates: the guard MUST recognize Windows path
syntax (drive letters, NTFS Alternate Data Stream colons, UNC prefixes, both `/` and `\` as
separators, reserved device names `CON`/`PRN`/`AUX`/`NUL`/`CONIN$`/`CONOUT$`/`COM1-9`/`LPT1-9` —
24 names total (6 + 9 + 9; see ADR-0021 §9 for the authoritative list, cited by reference rather
than a bare count), case-insensitive, stem-matched) via its OWN character-level scan — explicitly NOT via `std::path::Path`/`Component`, since that API's
behavior is scoped to the compilation/runtime target's OS and would silently under-recognize
Windows syntax when the check runs on Linux/macOS CI. State this as a MUST, not an implementation
suggestion: an implementer who reaches for `std::path` here (the idiomatic Rust instinct) produces
code that passes a shallow read but fails the actual security property. Reference ADR-0021 §9's
`reject_unsafe_profile_component` by name so the BC's postcondition text and the eventual `src/`
implementation stay traceable to one specification.

**For the formal-verifier (VP-AUTHDX-016 and the vp-delta.md CI-classification table).** Two
corrections:

1. **VP-AUTHDX-016's oracle text** should cite the concrete mechanism (host-independent
   character-level recognizer, not `std::path`) rather than repeating "Windows-syntax-aware"
   unqualified — the oracle should assert, for each of the Windows vectors (drive-letter colon,
   ADS colon, UNC prefix via either separator, reserved device names with and without an
   extension) AND each Unix vector (`..`, `/`, absolute, empty, bare-dot, NUL byte), that
   `reject_unsafe_profile_component` rejects it **when the test itself is run on a Linux/macOS CI
   runner** — the test's own assertion should make this platform-independence explicit (e.g. a
   doc-comment or test-name noting "asserted without any `#[cfg(windows)]` gate, proving the
   recognizer — not the host OS — does the work"), not merely rely on the surrounding suite
   happening to run on Linux.
2. **vp-delta.md's "Cross-platform, runs in default CI (10 of 12)" claim for VP-AUTHDX-016 is now
   accurate ONLY because ADR-0021 §9 mandates the host-independent design** — it was not
   accurate as a claim about the ORIGINAL "Windows-syntax-aware" wording alone, since that wording
   was equally satisfiable by a `std::path`-based implementation that would silently fail to run
   any real Windows-syntax check in default (Linux) CI while still reporting green. Update
   vp-delta.md's VP-AUTHDX-016 row and its "Cross-platform testability boundary" section to note
   the classification depends on ADR-0021 §9's specific host-independent recognizer design being
   followed, not merely on the property being "cross-platform" in the abstract — so a future
   implementer who substitutes `std::path` for expedience is caught by a design-conformance check
   (e.g. a test asserting the Windows vectors are rejected identically under a forced non-Windows
   `cfg`), not just by the VP's label.

### Findings #2 and #6 — no BC/VP wording change required, confirm coverage only

Neither finding changes a BC's stated postcondition (BC-1.4.036's corrupt-vs-IO-error split and
BC-1.4.037's atomicity requirement were already worded correctly) — they only made the ADR's
design concretely implementable. Two confirmation asks, not wording changes:
- **Formal-verifier:** confirm VP-AUTHDX-015's harness (BC-1.4.036) exercises BOTH the
  `CorruptSecretFile` branch AND a genuine backend/IO-error branch (e.g. a permission-denied
  fault-injection case) as distinct oracle assertions, not just the corrupt-file case — the ADR
  now gives this a concrete typed mechanism to assert against (ADR-0021 §3).
- **Formal-verifier:** confirm VP-AUTHDX-012's atomicity oracle does not assume single-process
  operation — it should not assert that a temp file is ALWAYS absent after `store_pair` returns
  in a way that would be falsified by the age-gated cleanup's deliberate non-deletion of another
  process's fresh in-flight temp file (ADR-0021 §3, Finding #6). The single-process happy-path
  oracle is unaffected; only a multi-process test scenario, if one exists, needs this caveat.

---

## 12. Pass-3 Adversarial Review Amendments (2026-09-03)

A Pass-3 adversarial review of this F2 spec delta raised 2 findings requiring architecture-level
fixes (HIGH #1, MED #2) plus one documentation-drift finding (MED #4), all resolved by editing
ADR-0021/ADR-0022 and this document directly — no `src/` change, no scope change to what F4
implements beyond what the ADRs now concretely specify:

| # | Sev | Finding (one-line) | Resolution |
|---|-----|---------------------|------------|
| 1 | HIGH | STALE-KEYRING-SHADOWS-DPAPI: ADR-0021 §2's DPAPI-fallback write route never cleared a pre-existing, FITTING keyring pair — the read path's both-keys-present fast path would then return the stale keyring pair forever, permanently shadowing the fresh DPAPI pair after any refresh whose new token overflowed the keyring. | ADR-0021 §2 rewritten: both `TooLong` arms now delete the profile's keyring pair BEFORE calling `auth_windows_store::store_pair` (delete-then-store, not store-then-delete) — the ordering is reasoned explicitly for crash-safety in a new "Ordering, and why" note, and BC-1.4.035 Invariant 1 is extended to forbid a stale, complete keyring pair coexisting with a fresh, complete DPAPI pair. See guidance note below for BC-1.4.035 wording and the new VP (§7 table, new row). |
| 2 | MED | `src/cli/auth/refresh.rs::refresh_credentials` is a second, unlisted direct `login_token` caller (~line 177, current 4-arg signature) — ADR-0022 names only `handle_login` as the caller needing the new `cloud_id_override` parameter, so the refresh call site would fail to compile once F4 lands the signature change; separately, whether `auth refresh` should also trigger the tenant_info fetch on an api_token profile was undecided. | ADR-0022 §2 adds `refresh.rs` to the call-site inventory (fix: hardcode `None` for `cloud_id_override`, mirroring the existing sibling `login_oauth` call on the same function, which already hardcodes `None`) and this document's §2.2/§3 updated to match. Explicit decision recorded: YES, `auth refresh` triggers the fetch on every invocation — intentional, required by the A-PA-LOW-001 refresh-not-clear design (§3), and priced into Consequences. See guidance note below for BC-1.2.052 Invariant 3 wording. |
| 4 | LOW | This document's §11 Finding #4 row and its "Pass-2 architect guidance for product-owner" paragraph both stated the reserved-Windows-device-name set as "18 names" — the actual set (`CON`,`PRN`,`AUX`,`NUL`,`CONIN$`,`CONOUT$` = 6, `COM1`–`COM9` = 9, `LPT1`–`LPT9` = 9) is 24. ADR-0021 §9, the vp-delta.md, and BC-1.4.040 all already correctly say 24 — only this document had drifted. | Both "18" occurrences corrected to 24 (with the 6+9+9 arithmetic spelled out) and each now cites ADR-0021 §9 as the authoritative list by reference, rather than restating a bare count that can drift again. |

---

## Pass-3 architect guidance for product-owner and formal-verifier

### Finding #1 — required BC-1.4.035 wording, and a new VP

**For the product-owner (BC-1.4.035).** Extend Invariant 1's stated guarantee. Today it says (or
should say, per ADR-0021 §2's original design) something like "the access/refresh pair is never
split across backends — always fully in the keyring or fully in one DPAPI file." Add the second
half Finding #1 makes necessary: **"…and a profile's keyring pair and DPAPI-file pair are never
simultaneously both complete for the same profile — after any successful `store_oauth_tokens`
call, at most one of the two backends holds a usable pair for that profile."** Word this as a
postcondition of `store_oauth_tokens` specifically (not merely a general property), since it is
enforced there, not at read time — `load_oauth_tokens`'s both-keys-present fast path is exactly
the mechanism that turns a violation of this invariant into a real, user-visible defect (silent
authentication with stale/rotated tokens), so the BC should say plainly why the write-side
guarantee matters to the read-side behavior, not just state the write-side fact in isolation.

**For the formal-verifier.** A new VP is required (added to this document's §7 table, unnumbered
— allocate an ID): given a profile with a PRE-EXISTING complete keyring pair, force
`store_oauth_tokens`'s `access` write to return `keyring::Error::TooLong` (covering BOTH the
access-overflow arm and the refresh-overflow-after-access-succeeded arm as distinct test cases,
since Finding #1 identified both as vulnerable), then assert: (a) both namespaced keyring keys are
absent after `store_oauth_tokens` returns `Ok`, (b) the DPAPI file holds the fresh pair, and (c) a
subsequent `load_oauth_tokens` call returns the fresh DPAPI values, never the pre-existing stale
ones. This VP's oracle is the concrete, executable form of the extended BC-1.4.035 Invariant 1
above — without it, a future regression that re-introduces store-then-delete ordering (or drops
the deletes entirely) would not be caught by any existing test, since every other VP in this
delta's §7 table exercises either a fresh profile (no pre-existing pair to shadow) or the
non-`TooLong` happy path.

### Finding #2 — required BC-1.2.052 Invariant 3 wording

**For the product-owner (BC-1.2.052).** Invariant 3 currently enumerates the tenant_info
fetch-trigger sites as `auth login` and `jr init` only. Add `auth refresh` (specifically: any `jr
auth refresh` invocation that resolves to the api_token flow, per `chosen_flow_for_profile`) as a
third trigger site — this is not an edge case or a rare path, it fires on every such invocation,
identically to `auth login`. Word it explicitly rather than leaving it implied by "`login_token`
is called," since a reader who doesn't already know `refresh_credentials` calls `login_token`
directly (rather than some refresh-specific, fetch-free code path) would reasonably assume
`refresh` is fetch-exempt — the whole point of Pass-3 Finding #2 was that this was genuinely
ambiguous until decided. The corresponding test should assert a `jr auth refresh` on an api_token
profile issues (or attempts) the `/_edge/tenant_info` GET, mirroring whatever test already covers
this for `auth login`, and should assert `--cloud-id` remains unsupported/inert on `refresh` for
both flows (no `RefreshArgs.cloud_id` field exists, and `login_oauth`'s call on this path already
hardcodes `None` — see ADR-0022 §2).

---

## 13. Pass-4 Adversarial Review Amendments (2026-09-03)

A Pass-4 adversarial review of this F2 spec delta raised 3 findings requiring architecture-level
fixes (MED #2, LOW #3, LOW #4), all resolved by editing ADR-0021/ADR-0022 and this document
directly — no `src/` change, no scope change to what F4 implements beyond what the ADRs now
concretely specify:

| # | Sev | Finding (one-line) | Resolution |
|---|-----|---------------------|------------|
| 2 | MED | BC-1.4.040 Postcondition 8's real guarantee — that `store_pair`/`load_pair`/`remove_if_present` each invoke the profile-name guard BEFORE any FS op — was not testable in default (Linux/macOS) CI, because the non-Windows arms short-circuit to `Ok(None)`/`Ok(())`/`DpapiFallbackFailed` before ever reaching `file_path`. A Windows-only regression dropping the guard call from an entry point would pass every default-CI test. | ADR-0021 §3/§9 now mandate that the non-Windows arm of each of the three functions ALSO calls `file_path(profile)?` (hence the guard) as its literal first statement, before its own early return — the resulting `PathBuf` is discarded on non-Windows (never used for I/O there), but `Err(ProfilePathEscape)` propagates identically to the Windows arm. This wires the guard-invocation contract into BOTH cfg arms of all three entry points, making it exercisable — and a regression in it catchable — on an ordinary Linux/macOS `cargo test` run. See guidance note below for BC-1.4.040/VP-AUTHDX-016. |
| 3 | LOW | ADR-0021 §9's reserved-device-name set (24 names) omitted the superscript-digit device names Microsoft's "Naming Files, Paths, and Namespaces" also reserves (`COM¹`/`COM²`/`COM³`, `LPT¹`/`LPT²`/`LPT³` — U+00B9/U+00B2/U+00B3), and the recognizer did not reject a leading space (e.g. `" CON"`). | ADR-0021 §9's `is_reserved_windows_device_name` match set extended with the six superscript variants (30 names total: 6 + 9 + 9 + 6); the stem computation now trims leading spaces (`" CON"` → `"CON"`) before matching, closing the leading-space gap without a new error variant — trailing dot/space remains rejected outright by `reject_unsafe_profile_component` itself (a separate hazard: Windows silently strips it), while a leading space is instead absorbed into the reserved-name stem normalization, since a leading-space-prefixed NON-reserved name (e.g. `" my-profile"`) has no other Windows-specific hazard requiring outright rejection. See guidance note below for the final wording. |
| 4 | LOW | ADR-0022 §1's `fetch_cloud_id` had no scheme requirement — an `http://` `site_url` yields a plaintext GET, letting an on-path attacker return a well-formed `{"cloudId": …}` that gets persisted (wrong-tenant Assets misdirection; impact bounded because `cloud_id` is non-secret and `Config::base_url()`'s OAuth guard makes it inert for core Jira REST v3). | **Decision: require `https://`.** ADR-0022 §1 now has `fetch_cloud_id` skip the fetch (same soft-fail path as any other failure, no network call made) when `site_url` does not start with `https://` (case-insensitive). This costs nothing in the overwhelmingly common case (every real Jira Cloud site is `https://`) and removes a real, if bounded, on-path tenant-misdirection vector. See guidance note below for BC-1.2.052. |

---

## Pass-4 architect guidance for product-owner and formal-verifier

### Finding #2 — required BC-1.4.040 wording, and how VP-AUTHDX-016 should assert the wiring

**For the product-owner (BC-1.4.040).** Word Postcondition 8 so the guard-invocation guarantee
is explicitly ACROSS-PLATFORM, not merely "the guard exists and is correct in isolation" (which
VP-AUTHDX-016 already covers via the pure recognizer). State it as: "On every supported OS,
`store_pair`, `load_pair`, and `remove_if_present` each invoke the profile-name guard
(`reject_unsafe_profile_component`, via `file_path`) as their first action, before any other
behavior — including each function's own OS-specific short-circuit (the DPAPI-unavailable
honest-fail on `store_pair`, the no-file `Ok(None)` on `load_pair`, and the no-op `Ok(())` on
`remove_if_present`, all on a non-Windows build). A profile name that fails the guard is
rejected identically on every OS, before any of these OS-specific behaviors run." This closes
the gap between "the guard is correct" (already provable cross-platform, VP-AUTHDX-016) and "the
guard is actually wired in at all three entry points on every OS" (previously true only by
inspection, not by test).

**For the formal-verifier (VP-AUTHDX-016).** The harness can now assert the WIRING, not just the
pure recognizer, on a default Linux/macOS CI runner: call `store_pair`/`load_pair`/
`remove_if_present` directly with a profile name that fails `reject_unsafe_profile_component`
(e.g. one containing `/`, `:`, or a reserved device name) and assert each returns `Err`
downcastable to `ProfilePathEscape` — on every platform the test runs on, including non-Windows,
where before this fix the same call would have returned a "successful" no-op (`Ok(None)`/
`Ok(())`) or the unrelated `DpapiFallbackFailed` marker instead, silently swallowing the bad
name. Add this as a new oracle assertion in VP-AUTHDX-016's test (or a sibling test in the same
module) rather than folding it into the existing pure-recognizer unit tests — it tests the CALL
SITE's wiring, a different property than the recognizer's own correctness, and the two should
fail independently and legibly if either regresses.

### Finding #3 — final reserved-device-name set and normalization rules

**For the product-owner (BC-1.4.040) and formal-verifier (VP-AUTHDX-016).** The final,
authoritative reserved-device-name set, superseding the "24 names" figure recorded in this
document's Pass-2/Pass-3 sections above (left as historical record, not re-edited — ADR-0021 §9
is the current, single source of truth) is **30 names**:
- `CON`, `PRN`, `AUX`, `NUL`, `CONIN$`, `CONOUT$` (6)
- `COM1`–`COM9` (9)
- `LPT1`–`LPT9` (9)
- `COM¹`, `COM²`, `COM³`, `LPT¹`, `LPT²`, `LPT³` (6 — the Unicode superscript-digit variants,
  U+00B9/U+00B2/U+00B3, that Microsoft's "Naming Files, Paths, and Namespaces" also reserves)

Matching is case-insensitive (ASCII-fold only — the superscript characters have no case) and is
evaluated against the profile's STEM (the part before the first `.`, if any) after trimming any
LEADING spaces (`" CON"` → stem `"CON"` → reserved; a leading-space-prefixed non-reserved name
has no separate rejection reason and remains accepted). Trailing dot/space is unrelated to this
list — it is, and remains, rejected outright by `reject_unsafe_profile_component` itself (a
distinct hazard: Windows silently strips a trailing dot/space, which could make a name collide
with an unrelated existing one).

BC-1.4.040 and VP-AUTHDX-016 should cite ADR-0021 §9 by reference for the authoritative list (as
the Pass-2 guidance note already recommended) rather than restating a bare count in BC/VP prose
— this is exactly the class of drift Pass-3 Finding #4 already had to correct once for the prior
18→24 count, and citing by reference is what prevents a third recurrence when the set changes
again in the future.

### Finding #4 — https requirement decision for BC-1.2.052

**Decision: require `https://`, not accept-and-document.** `fetch_cloud_id` now skips the
`/_edge/tenant_info` lookup entirely (no network call made) when the profile's configured
`site_url` does not start with `https://` (case-insensitive) — this is a new, additional
soft-fail trigger, using the exact same non-blocking, no-diagnostic-beyond-the-existing-
Assets-error path ADR-0022 §2 step 3 already specifies for every other fetch failure. No new
error type or message is introduced.

**For the product-owner (BC-1.2.052).** Add one line to the Invariant/Postcondition covering
`fetch_cloud_id`'s soft-fail conditions: "the fetch is also skipped, without any network request
being made, when the profile's configured site URL does not use the `https://` scheme." No new
user-visible message is needed — this is indistinguishable, from the user's perspective, from
any other soft-fail (network error, non-2xx, malformed body): `cloud_id` simply stays
unset/unchanged, and the existing `"Cloud ID not configured…"` error remains the actionable path
if Assets is later attempted. The corresponding test should configure a profile with an
`http://` (or scheme-less) `site_url` and assert `fetch_cloud_id` returns `Err` without any HTTP
request being observed (e.g. via a `wiremock` server that would fail the test if it received any
request).

---

## 14. Pass-5 Adversarial Review Amendments (2026-09-03)

A Pass-5 adversarial review of this F2 spec delta raised 1 HIGH, 1 MED, and 2 LOW findings, all
resolved by editing ADR-0021 and this document directly — no `src/` change, no scope change to
what F4 implements beyond what ADR-0021 now concretely specifies:

| # | Sev | Finding (one-line) | Resolution |
|---|-----|---------------------|------------|
| 1 | HIGH | Testability contradiction: Pass-1's `#[cfg(windows)]`-gated `engage_dpapi_fallback` (correctly) makes `store_oauth_tokens`'s DPAPI-routing branch unreachable at runtime on non-Windows, but VP-AUTHDX-022 (and portions of VP-AUTHDX-011/012) asserted outcomes — e.g. "both keyring keys absent after `store_oauth_tokens` returns `Ok`" — that are structurally unreachable there; vp-delta.md's "12 of 13 default CI" classification did not account for this. | ADR-0021 §1 adds a `#[cfg(debug_assertions)]`-gated `JR_FORCE_DPAPI_FALLBACK` opt-in test seam, following the existing `JR_*` debug-only seam convention exactly (release/production behavior unchanged — still hardcoded `false` absent the seam). The seam's honest boundary is stated explicitly: it makes the delete-then-fail shape (keyring cleared, DPAPI store attempted and fails, neither backend populated) testable in default CI, but NOT the success shape (DPAPI file holds the fresh pair; a real `store_pair` success is structurally Windows-only regardless of the seam). This document's §2.1/§7 tables and the guidance section below give the corrected per-VP classification. |
| 2 | MED | `ProfilePathEscape` had no correct rendering path — `load_oauth_tokens` only checked `downcast_ref::<CorruptSecretFile>()`, so a `ProfilePathEscape` fell into the generic backend/IO branch and was rendered as a misleading "check file permissions" message, contradicting BC-1.4.040 Postcondition 6. Separately, ADR-0021 §3/§4/§9 were internally inconsistent about what the rejection message should say, and BC-1.4.035 Invariant 3's "byte-for-byte unchanged on non-Windows" wording was in unstated tension with Pass-4's mandatory non-Windows guard call. | ADR-0021 §4 (read path) and §6 (Sites 1/3, store path) now check `e.downcast_ref::<ProfilePathEscape>()` FIRST, before `CorruptSecretFile`/`DpapiFallbackFailed`/the generic fallback, at every message-rendering call site — routing to a distinct exit-64 "invalid profile name" `JrError::UserError` naming the profile. ADR-0021 §9 adds an explicit BC-1.4.035 Invariant 3 scope clarification: the invariant governs DPAPI-fallback ENGAGEMENT only, and explicitly excludes the intentional, new, cross-platform profile-name guard rejection. See guidance below for BC-1.4.036/1.4.039/1.4.035 wording. |
| 3 | LOW | ADR-0021 §3/§8 specified `dwFlags = 0` and VP-AUTHDX-010(a) pinned the literal `== 0`, omitting `CRYPTPROTECT_UI_FORBIDDEN` (0x1) — the standard non-interactive/headless flag — and foreclosing adding it without breaking the pin. | **Decision: set `CRYPTPROTECT_UI_FORBIDDEN`.** ADR-0021 §3's `dpapi` module comment and §8 now specify `dwFlags = CRYPTPROTECT_UI_FORBIDDEN` (0x1), avoiding an OS-level UI-prompt hang risk on headless/CI/service invocations, with `CRYPTPROTECT_LOCAL_MACHINE` (0x4) still never set. The pinned security invariant is loosened from `dwFlags == 0` to "`CRYPTPROTECT_LOCAL_MACHINE` bit clear" — the property that actually matters and that will not need re-pinning if a future, unrelated flag is ever added. See guidance below for VP-AUTHDX-010(a). |
| 4 | LOW | `is_reserved_windows_device_name` trims only a leading ASCII space; whether Windows also disregards a leading tab/vertical-tab/form-feed in device-name resolution (which would let `"\tCON"` evade the stem match) was unverified. | **Researched and REFUTED** (Perplexity, cross-checked against Microsoft's `RtlIsDosDeviceName_U` documentation, 2026-09-03): non-ASCII-space whitespace is not documented or evidenced as disregarded in DOS device-name recognition. ADR-0021 §9 records this as a verified scope note — only ASCII leading/trailing space is normalized, and this is confirmed SUFFICIENT (not merely assumed), since adding a trim for other whitespace would make the guard over-reject relative to actual Windows behavior. No BC/VP wording change required. |

---

## Pass-5 architect guidance for product-owner and formal-verifier

### Finding #1 — corrected per-VP CI-classification for the formal-verifier

**For the formal-verifier.** vp-delta.md's "Cross-platform, runs in default CI (12 of 13)" bucket
must be corrected for VP-AUTHDX-011, VP-AUTHDX-012, and VP-AUTHDX-022 — not by removing them from
default CI, but by making explicit that their default-CI coverage now DEPENDS on the new
`JR_FORCE_DPAPI_FALLBACK` debug-only seam (ADR-0021 §1), which did not exist when that
classification was written. Without the seam, none of the three properties below is reachable in
default CI at all — the production `#[cfg(not(windows))]` gate makes the relevant code dead on any
non-Windows runner, seam or no seam being the only thing that changes that. Exact classification:

- **VP-AUTHDX-011** (`should_fallback_to_dpapi` / `TooLong` routing, BC-1.4.035). Split into two
  sub-properties with DIFFERENT boundaries:
  (a) the pure predicate `should_fallback_to_dpapi(err) == matches!(err, keyring::Error::TooLong(..))`
  — cross-platform, default CI, NO seam needed (this was already correctly a pure-function test and
  remains so).
  (b) that `store_oauth_tokens` ACTUALLY dispatches to `auth_windows_store::store_pair` when a
  `TooLong` occurs (i.e., the routing is wired, not just the predicate is correct) — this requires
  `engage_dpapi_fallback` to return `true`, which in a default-CI (non-Windows) run only happens
  with `JR_FORCE_DPAPI_FALLBACK=1` set. Word this sub-property's oracle and platform tag as
  "cross-platform, default CI, REQUIRES `JR_FORCE_DPAPI_FALLBACK=1`" — not bare "cross-platform" —
  so a reader does not assume it runs unconditionally.
- **VP-AUTHDX-012** (no-split / rollback, BC-1.4.037+BC-1.4.035). The rollback-ordering LOGIC
  (delete `access_key`, delete `refresh_key`, call `store_pair`, in that order, on either overflow
  arm) is testable in default CI **only with the seam engaged** — same correction as VP-011(b). The
  real temp-write/rename/fsync/age-gated-cleanup file mechanics remain Windows-only exactly as
  already classified (the seam has no bearing on that portion — it lives entirely inside
  `store_pair`'s `#[cfg(windows)]` arm, which the seam does not and cannot reach from a non-Windows
  build).
- **VP-AUTHDX-022** (stale-keyring-shadow closure, BC-1.4.035, the Pass-3-added VP). This is the
  property most directly misclassified. Split explicitly into:
  - **Default-CI-reachable, WITH the seam, core:** given a pre-existing complete keyring pair and a
    mocked `TooLong` (either overflow arm), assert (i) both keyring keys are deleted BEFORE
    `store_pair` is called, and (ii) because `store_pair` is guaranteed to fail on a non-Windows
    build, `store_oauth_tokens` returns `Err` with NEITHER backend populated afterward. This is the
    delete-first-ordering / mid-window-fault-safety property, and it is a genuine, valuable
    regression pin for the crash-safety reasoning in ADR-0021 §2's "Ordering, and why" note.
  - **Windows-only, unaffected by the seam:** the full success oracle as originally written — "(a)
    both keyring keys absent, (b) the DPAPI file holds the fresh pair, (c) `load_oauth_tokens`
    returns the fresh pair" — requires `store_oauth_tokens` to return `Ok`, which requires a real,
    successful `store_pair`, which cannot happen off Windows with or without the seam. This portion
    was already correctly flagged as a "Windows-only real-DPAPI round-trip tail" in vp-delta.md's
    testability-boundary section — that classification stands unchanged; what was inaccurate was
    treating VP-AUTHDX-022 as if its WHOLE property (not just this tail) already counted toward the
    "12 of 13 default CI" figure, when in fact its default-CI-reachable core did not exist as an
    executable property at all until this pass added the seam.
- **Net effect on the "12 of 13" figure.** The count itself does not need to change — VP-AUTHDX-011,
  012, and 022 were already being counted (correctly, in aggregate) as having a default-CI-covered
  core. What was missing, and must be added now, is the explicit dependency on
  `JR_FORCE_DPAPI_FALLBACK` for each of the three, worded plainly enough that a future reader (or F6
  executor) does not attempt to write these tests against the unseamed production code path and
  discover — as this Pass-5 review did — that the relevant branch is simply unreachable.

### Finding #3 — required VP-AUTHDX-010(a) wording change

**For the formal-verifier.** Reword VP-AUTHDX-010's sub-property (a) from "pins the `dwFlags`
constant (`== 0`, `LOCAL_MACHINE` bit clear)" to pin ONLY the security-relevant bit: **"`dwFlags &
CRYPTPROTECT_LOCAL_MACHINE == 0`"** (bit 2 / `0x4` clear) — not the whole word. The oracle should
separately, non-normatively, note the current concrete value (`CRYPTPROTECT_UI_FORBIDDEN`, `0x1`)
so a reader can see what's actually passed, but the PINNED assertion must be the bit-clear property,
not an exact-equality on the full flag word, so this VP does not need editing again the next time a
legitimate, unrelated flag is added to `dwFlags`. This sub-property remains spike-independent
automated coverage (a Windows-COMPILED unit test, no headless DPAPI syscall execution required) —
Pass-1 Finding #10's original rationale for why this doesn't wait on the `windows-latest`-headless
spike is unaffected by this wording change.

### Finding #2 — required BC-1.4.035 / BC-1.4.036 / BC-1.4.039 wording

**For the product-owner (BC-1.4.036).** The read-path discrimination is now THREE-way, not
two-way: word the Invariant/Postcondition so `load_oauth_tokens`'s handling of a `load_pair` `Err`
checks, in order, (1) `ProfilePathEscape` → distinct exit-64 "invalid profile name" error naming
the profile, (2) (else) `CorruptSecretFile` → the existing force-re-login error, (3) (else) a
generic backend/IO error → the existing non-re-login error. State explicitly that (1) is checked
BEFORE (2), since both are plausible for a "file present but the read logically failed" scenario
and only one is the correct diagnosis for an invalid profile name. The corresponding test should
assert a profile name that fails `reject_unsafe_profile_component` produces the invalid-profile-name
message specifically, not the corrupt-file or backend-IO message, even in a scenario an implementer
might otherwise route to the generic branch by omission.

**For the product-owner (BC-1.4.039).** Sites 1 and 3's honest-fail discrimination is likewise now
three-way: `ProfilePathEscape` FIRST (new — same invalid-profile-name error as the read path), then
`DpapiFallbackFailed` (existing honest-fail message), then the legacy "Unlock your keychain" message.
Word Postcondition text so a reader does not assume `DpapiFallbackFailed` is the only marker checked
at these two sites.

**For the product-owner (BC-1.4.035 Invariant 3).** Add the scope-clarification sentence ADR-0021
§9 now specifies verbatim or in substance: Invariant 3 ("macOS/Linux byte-for-byte unchanged")
governs the DPAPI-fallback ENGAGEMENT decision only (`engage_dpapi_fallback`/`TooLong`-routing) —
it does NOT extend to, and is not violated by, the profile-name path-traversal guard of BC-1.4.040,
which is intentionally new, cross-platform behavior applying identically on every OS. Without this
sentence, a future adversarial pass (or a careless implementer) could read Invariant 3 as forbidding
BC-1.4.040's non-Windows rejection and either wrongly "fix" it away or wrongly flag it as a defect.

### Finding #4 — no BC/VP wording change required, confirmation only

Neither the product-owner nor the formal-verifier needs to change any BC/VP text for this finding —
`is_reserved_windows_device_name`'s ASCII-space-only trim scope was already the specified design
(Pass-4); this pass only added verified evidentiary support (a REFUTE on the "other whitespace is
also disregarded" hypothesis) confirming that scope is sufficient, not a design change. No action
required beyond what ADR-0021 §9 now records.

## 15. Pass-6 Adversarial Review Amendments (2026-09-03)

A Pass-6 adversarial review of this F2 spec delta raised 1 MED (process-gap) finding on the
`JR_FORCE_DPAPI_FALLBACK` debug seam introduced by Pass-5 (§14 above). Resolved by editing
ADR-0021 directly — no `src/` change, no scope change to what F4 implements beyond what ADR-0021
now concretely specifies:

| # | Sev | Finding (one-line) | Resolution |
|---|-----|---------------------|------------|
| 3 | MED | Process-gap: ADR-0021 §1's "Doc-fallout note for F4" (added Pass-5) named only a CLAUDE.md seam-table entry as the required follow-through for `JR_FORCE_DPAPI_FALLBACK` — a debug-only seam gating a security-critical credential-storage routing decision. The established `JR_*` debug-only-seam convention (CLAUDE.md's "AI Agent Notes") requires two MORE things this note omitted: a dedicated `tests/*_release_gate.rs` pin proving the seam compiles out of release builds, and confirmation that the env read itself is `#[cfg(debug_assertions)]`-gated at its read site. | ADR-0021 §1's "Doc-fallout note for F4" is expanded into a three-part mandatory checklist F4's `dpapi-storage-fix` story must ship in one commit: (a) `tests/jr_force_dpapi_fallback_release_gate.rs`, matching the sibling-seam convention (e.g. `tests/jr_test_block_until_sigint_release_gate.rs`), pinning `#[cfg(debug_assertions)]` within 5 source lines of the env-var read in `src/api/auth.rs`; (b) the CLAUDE.md `JR_*` seam-table entry (already required, retained); (c) an explicit statement in both places that the seam affects `#[cfg(debug_assertions)]` builds only and is compiled out of release — production non-Windows behavior stays hardcoded `false`. See ADR-0021 §1 for the full text and the Source/Origin Pass-6 entry for traceability. |

---

## Pass-6 architect guidance for formal-verifier

### Finding #3 (release-gate + doc-fallout completeness) — required F4/F6 test-scope addition, no BC/VP wording change

**For the formal-verifier.** ADR-0021 §1's expanded doc-fallout note (above) is a build/test-scaffolding
requirement, not a behavioral property of `store_oauth_tokens` itself — it does not change any
VP's oracle text. Add it as an explicit F4/F6 deliverable checklist item alongside the VP-AUTHDX-011/
012/022 test authoring already scoped to this seam (§14 above): `tests/
jr_force_dpapi_fallback_release_gate.rs` must exist and pass in the same commit that introduces
`JR_FORCE_DPAPI_FALLBACK`, following the exact structural pattern of the other `*_release_gate.rs`
files in `tests/` (e.g. asserting the `#[cfg(debug_assertions)]` gate's proximity to the env-var
read via a source-text scan, not by exercising runtime behavior).

**Also flagged for the formal-verifier (Finding #4, mutex serialization — not a Pass-6 numbered
finding in its own right, but raised alongside Finding #3 during this pass and requiring VP
treatment):** the two test classes that key off `JR_FORCE_DPAPI_FALLBACK`'s process-global state on
a non-Windows target — (i) the pre-existing legacy "Unlock your keychain" message test, run with the
env var UNSET, and (ii) the new VP-AUTHDX-011/012/022 delete-then-fail tests (§14 above), run with
the env var SET to `1` — assert OPPOSING outcomes from the SAME `engage_dpapi_fallback` call site.
Spec the VP test-authoring guidance to require `env_lock`-style mutex serialization between these
two classes, exactly as CLAUDE.md documents for `JR_SERVICE_NAME` in
`tests/oauth_refresh_integration.rs` (an in-process `std::sync::Mutex` held for the duration of the
env-var-dependent section of each test — not a test-binary-wide `--test-threads=1`, which would
over-serialize unrelated tests). Without this, `cargo test`'s default parallelism can interleave a
`set_var`/`remove_var` from one test with an in-flight assertion in the other, producing
non-deterministic CI flakiness on either side. This is scoped to the VP test implementation
(F4/F6) — it requires no change to ADR-0021's production code (§1/§2).

---

## 16. Pass-8 Adversarial Review Amendments (2026-09-03)

**Numbering note.** A Pass-7 adversarial review ran between Pass-6 and this pass; it corrected a
misstatement inside BC-1.4.039's own prose (about `JR_FORCE_DPAPI_FALLBACK`'s per-error-variant
behavior) by pointing back to ADR-0021 §1's already-correct code — it required no
`architecture-delta.md`/ADR-0021 edit, so there is no "§ Pass-7" section here. This section is
Pass-8's.

A Pass-8 adversarial review examined the CLEAR path (`auth logout`/`auth remove` →
`clear_profile_oauth_pair`/`clear_profile_creds` → `remove_if_present`) — a surface no prior pass
in this cycle had examined — and raised 1 MED finding requiring an architecture-level fix (which
resolves a second, dependent MED finding), resolved by editing ADR-0021 §7 and this document
directly — no `src/` change, no scope change to what F4 implements beyond what ADR-0021 §7 now
concretely specifies:

| # | Sev | Finding (one-line) | Resolution |
|---|-----|---------------------|------------|
| 3 | MED | BACKWARD-COMPAT REGRESSION: Pass-4's mandatory `file_path(profile)?`/guard call on BOTH cfg arms of `remove_if_present` (Finding #2, §9) is correct for the write/read entry points it was designed around, but `remove_if_present` is ALSO invoked UNCONDITIONALLY by `clear_profile_oauth_pair`/`clear_profile_creds` on EVERY `auth logout`/`auth remove`, for EVERY profile — not only one that ever engaged DPAPI. A pre-existing profile name that is legal for keyring-only storage (a Unix profile containing `:`, or — since `Profile::from(String)` performs no validation, ADR-0011 — even a WINDOWS profile literally named a reserved device name like `con`, which keyring-only storage never cared about) now makes the clear operation itself fail with exit 64, per BC-1.4.038 Postcondition 4's "first genuine error propagated" contract — a regression reachable on EVERY OS, not only macOS/Linux as the finding was originally framed. | ADR-0021 §7 adds a caller-side adapter, `clear_dpapi_file_tolerating_path_escape`, used only by `clear_profile_oauth_pair`/`clear_profile_creds`: it treats a `ProfilePathEscape` from `remove_if_present` as TOLERATED (equivalent to `NotFound`), never a genuine error, on every OS — provably safe because the SAME guard is also `store_pair`'s mandatory first statement, so a guard-rejected name could never have had a DPAPI file written for it in the first place. `remove_if_present`'s own signature and guard-invocation contract (Pass-4 Finding #2) are UNCHANGED — its Windows-path security value and cross-platform regression-catchability are both fully preserved. See guidance below for the required BC-1.4.038 wording and VP-AUTHDX-018 oracle additions. |
| 2 | MED | (Dependent on #3.) `ProfilePathEscape` rendering was specified for the read path (BC-1.4.036) and the store-error sites (BC-1.4.039 Sites 1/3), but the clear path (BC-1.4.038/VP-AUTHDX-018) had no rendering treatment at all — a `ProfilePathEscape` from `remove_if_present` fell into BC-1.4.038 Postcondition 4's generic "first genuine error" bucket with no dedicated exit-64 invalid-profile-name message. | Resolved as a CONSEQUENCE of Finding #3's design, not by adding a rendering branch: because the clear path now tolerates (swallows) `ProfilePathEscape` from `remove_if_present` entirely via the new adapter, it NEVER surfaces as a user-visible error on the clear path at all. There is deliberately no exit-64 "invalid profile name" rendering here, unlike the store/read paths — see guidance below for why this asymmetry is correct and how BC-1.4.038 should state it explicitly. |

---

## Pass-8 architect guidance for product-owner and formal-verifier

### Finding #3 — required BC-1.4.038 wording (Postcondition, Invariant, new Edge Cases)

**For the product-owner (BC-1.4.038).** Amend Postcondition 4's fan-out contract to add an
explicit outcome-classification clause for the `remove_if_present` step specifically: "The
`remove_if_present` step's result is further discriminated before it can count as a 'genuine
error' for this fan-out: a `ProfilePathEscape` result is TOLERATED — treated identically to
`NotFound` — on EVERY OS, never propagated as the function's error. This is provably safe, not
merely convenient: `reject_unsafe_profile_component` (BC-1.4.040) is ALSO the mandatory first
statement of `store_pair`, so no profile name this guard rejects could ever have had a DPAPI
file successfully written for it by any version of `jr` carrying this guard — 'the guard refuses
to compute the path' and 'no file exists under this name' are the same fact for such a profile.
Any OTHER error from `remove_if_present` (a genuine filesystem error, e.g. permission denied) is
NOT tolerated and remains the propagated genuine error exactly as EC-1.4.038-3 already specifies."

Add a new Invariant: "A profile name that is legal for keyring-only credential storage but fails
`reject_unsafe_profile_component` (BC-1.4.040) — whether because it predates this guard's
introduction, or because a future tightening of the reserved-name set newly rejects it — continues
to have its credentials FULLY cleared by `auth logout`/`auth remove`, on every OS including
Windows. This is a hard backward-compatibility guarantee: BC-1.4.040's guard, deliberately
hardened and applied identically on every OS for NEW writes/reads, must never block the cleanup
of credentials that predate it or that were never subject to it."

Add two new Edge Cases:
- **EC-1.4.038-5**: A profile name that fails `reject_unsafe_profile_component` — e.g. a Unix
  profile literally containing `:`, or a profile literally named a reserved Windows device-name
  stem such as `con` (legal on EVERY OS pre-cycle, since `Profile::from(String)` performs no
  validation, ADR-0011) — is cleared successfully by `auth logout`/`auth remove`: the
  DPAPI-removal step is tolerated as a no-op (never a genuine error, per the amended Postcondition
  4 above), and every other deletion step (the keyring pair(s), the API-token pair for
  `clear_profile_creds`, the cache directory, the config entry) proceeds and completes normally.
  This holds identically on Windows, macOS, and Linux — it is NOT a macOS/Linux-only fix, since a
  Windows profile whose name happens to be a reserved device name was equally exposed before this
  fix (keyring-only storage never validated profile names against Windows filesystem syntax).
- **EC-1.4.038-6** (accepted residual, documented not engineered away): A DPAPI file that somehow
  exists on disk under a name the CURRENT guard would reject — reachable only via an out-of-band
  mechanism, a future guard-tightening applied after such a file already existed, or a defect in
  an earlier `jr` version that lacked this guard — is NOT found or removed by `remove_if_present`,
  since `file_path` fails the guard before any existence check runs. This is a narrow completeness
  gap only — it never affects the credential's CONFIDENTIALITY, since DPAPI still gates decryption
  regardless of whether the file is ever deleted — and mirrors the ADR's already-accepted
  stale-`*.tmp-*`-file residual (ADR-0021 §3). No test is required to exercise this residual; it
  should be recorded as a documented, out-of-scope limitation, not asserted as a passing property.

**For the formal-verifier (VP-AUTHDX-018).** Add new oracle assertions, distinct from the
existing genuine-FS-error oracle (EC-1.4.038-3):

1. Given a profile name that fails `reject_unsafe_profile_component` (cover at least: a name
   containing `:`, and a name that is a reserved device-name stem such as `con`), calling
   `clear_profile_oauth_pair(profile)` and, separately, `clear_profile_creds(profile)` each return
   `Ok(())` — NOT `Err` downcastable to `ProfilePathEscape` and not any other error — AND every
   keyring deletion step in the function's fixed attempt order is still observed to have been
   attempted (via whatever fault-injection/spy seam the other BC-1.4.038 attempt-all assertions
   already use). Cross-platform, runs in default CI, and — unlike VP-AUTHDX-011/012/022 — needs
   NO `JR_FORCE_DPAPI_FALLBACK` seam: this property is entirely about the guard-rejection branch
   of `remove_if_present`, which is reachable identically on every OS via `file_path`'s mandatory
   first-statement call on both cfg arms (Pass-4 Finding #2), with no dependency on `TooLong` or
   DPAPI engagement at all.
2. Assert this TOLERATED classification is genuinely distinct from the existing GENUINE-error
   classification, not merely two names for the same fallback: inject a `ProfilePathEscape` from
   `remove_if_present` in one test case (expect `Ok(())`, tolerated) and a DIFFERENT, distinct
   genuine `anyhow` error (e.g. a simulated permission-denied) from `remove_if_present` in a
   sibling test case (expect that error to be the function's propagated result, per EC-1.4.038-3)
   — the two cases must diverge, so a future change that collapses the two classifications back
   together is caught by this VP failing, not silently passing.
3. Include a case naming a profile a reserved Windows device-name stem (e.g. `"con"`) and assert
   the clear succeeds when the TEST SUITE ITSELF runs on Windows too, not only on Linux/macOS —
   this property is not gated to non-Windows platforms, unlike `remove_if_present`'s own
   `#[cfg(not(windows))]` no-op arm.
4. State explicitly in the oracle text that this VP does NOT assert anything about a NEW,
   successful DPAPI write ever having occurred for the tested profile — it is purely a
   clear-path/guard-interaction property, fully decoupled from `TooLong`/DPAPI engagement.

### Finding #2 — required BC-1.4.038 wording (explicit no-rendering statement) and VP-AUTHDX-018 guidance

**For the product-owner (BC-1.4.038).** Add one explicit sentence stating the asymmetry with the
store/read paths, so a future reader does not assume the same three-way discrimination applies
here: "Unlike BC-1.4.036's read-path handling and BC-1.4.039's Sites 1/3 (which check
`ProfilePathEscape` FIRST and render it as a distinct, user-visible exit-64 'invalid profile name'
error for a NEW write/read), the clear path NEVER renders a `ProfilePathEscape` from
`remove_if_present` as a user-visible error at all — per the amended Postcondition 4 above, it is
tolerated identically to `NotFound`. `auth logout`/`auth remove` have only two outcomes for this
step: tolerated (no-op; includes both `NotFound` and `ProfilePathEscape`) or genuine-error
(propagated, per EC-1.4.038-3)." Cross-reference BC-1.4.039's Postcondition 1 in this sentence so
the two BCs' differing treatment of the same marker type is legible side-by-side rather than
appearing contradictory to a future reader.

**For the formal-verifier (VP-AUTHDX-018).** The oracle must assert the ABSENCE of any rendered
error for this case — `Ok(())` returned, no message text to inspect — which is a different and
stronger claim than "the correct message was rendered," the shape every other `ProfilePathEscape`
oracle in this delta (VP-AUTHDX-016's guard-emission proof, VP-AUTHDX-017's Sites-1/3
rendering proof) asserts. State this distinction explicitly in VP-AUTHDX-018's oracle text: VP-016
proves the guard EMITS `ProfilePathEscape` at `remove_if_present`'s own entry point; VP-017 proves
the STORE path (Sites 1/3) RENDERS it distinctly; VP-018 (this Pass-8 addition) proves the CLEAR
path SWALLOWS it — three genuinely different properties at three different call sites, each
capable of failing independently if any one of them regresses.
</content>
