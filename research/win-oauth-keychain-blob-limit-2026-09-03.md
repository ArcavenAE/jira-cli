# Windows OAuth-Token Storage Bug (#759) — Research & Assumption Validation

**Date:** 2026-09-03
**Type:** general (technology/implementation)
**Topic:** Windows Credential Manager 2560-byte blob limit vs. Atlassian 3LO OAuth token storage in `jr` (keyring crate v3.6.3, `windows-native`)
**Status:** complete
**Scope:** Research only — no `src/` changes, no PR. Validates the assumptions in the bug report and evaluates candidate fixes.

---

## Executive verdict table

| Q | Claim under test | Verdict |
|---|---|---|
| A | CredMan limit = 2560 **bytes**; UTF-16 encoding gives ~1280-char ceiling; keyring mislabels "bytes" as "chars" | **CONFIRM** (all four sub-claims) |
| B | keyring `windows-native` → `CredWriteW`; typed distinguishable error exists; no built-in chunking | **CONFIRM** |
| B2 | Matchable variant is `Error::TooLong(String, u32)`, reliably returned for oversized secret | **CONFIRM** |
| C | Chunking across multiple generic credentials is a known/safe pattern; comparable tools do it | **REFUTE (as "known/safe standard")** / peers use DPAPI files, not chunking |
| D | Maintained Rust DPAPI crates exist; user-scope DPAPI + `%LOCALAPPDATA%` is correct | **CONFIRM** (with one nuance corrected) |
| E | Atlassian access tokens scale with scopes; 8-scope token plausibly >1280 chars | **INCONCLUSIVE** (scaling plausible but unproven for *this* token; refresh-token overflow is the better-evidenced risk) |
| F | Scope-trimming materially shrinks the token and is a durable fix | **REFUTE (as durable fix)** — modest shrink, moves the cliff, triggers re-consent |

**Headline assumption that turned out to need correction:** the bug is framed around the *access token* overflowing on the *first* `set_password`. The evidence says the token-size risk is real but **unbounded and not primarily scope-driven** — Atlassian explicitly refuses to guarantee any max length, and the strongest length evidence points at *refresh* tokens (reported >2048 and anecdotally ~16,000 chars), not the 8-scope access token. This reframes the fix from "shrink the token" to "stop using a fixed-ceiling store."

---

## A. Windows Credential Manager size limit — **CONFIRM (4/4)**

1. **2560-byte figure — CONFIRM.** Microsoft's `CREDENTIALW` documentation states `CredentialBlobSize` is "the size, in bytes, of the `CredentialBlob`" and "cannot be larger than `CRED_MAX_CREDENTIAL_BLOB_SIZE` (5*512) bytes" = **2560 bytes**. The limit is on the blob **in BYTES**, not characters.
   - Source: Microsoft Learn, `wincred.h` `CREDENTIALW` structure (ns-wincred-credentialw); `CredWriteW` (nf-wincred-credwritew).

2. **UTF-16 encoding — CONFIRM.** keyring 3.6.3's Windows backend converts the Rust `&str` via `encode_utf16()`, writing exactly **2 bytes per UTF-16 code unit** (little-endian, no trailing NUL) into `CredentialBlob`, and sets `CredentialBlobSize = blob.len()`.
   - Source: docs.rs `keyring` 3.6.3 Windows implementation (`x86_64-pc-windows-msvc` `keyring::windows`).

3. **~1280-character ceiling — CONFIRM (with precision).** 2560 bytes ÷ 2 bytes/code-unit = **1280 UTF-16 code units**. For ASCII/BMP text (which all Atlassian tokens are — base64url/JWT charset) that equals ~1280 `char`s. Supplementary-plane characters (surrogate pairs) would halve this to 640, but tokens contain none, so **1280 chars is the correct effective ceiling for token text**.

4. **keyring mislabels bytes as "chars" — CONFIRM.** keyring's `Error::Display` formats `TooLong(name, len)` as `Attribute '{name}' is longer than platform limit of {len} chars`. The Windows backend passes `len = CRED_MAX_CREDENTIAL_BLOB_SIZE = 2560` (a **byte** count), so the rendered message reads `...platform limit of 2560 chars` — the word "chars" is a unit mislabel; it is really 2560 **bytes** (= 1280 code units). This exactly matches the reporter's symptom string.
   - Source: docs.rs `keyring/error.rs` (`Error::Display`) + Windows `validate_attributes`.

---

## B / B2. keyring v3.6.x Windows behavior — **CONFIRM**

- **Maps to `CredWriteW` — CONFIRM.** `set_password` → UTF-16LE blob → `set_secret` → `save_credential` → a single `CredWriteW(p_credential, 0)` with credential type `CRED_TYPE_GENERIC`. (docs.rs keyring 3.6.3 Windows source.)

- **Exact `keyring::Error` enum (v3.6.3) — quoted from docs.rs `error.rs`:**
  ```rust
  #[non_exhaustive]
  pub enum Error {
      PlatformFailure(Box<dyn std::error::Error + Send + Sync>),
      NoStorageAccess(Box<dyn std::error::Error + Send + Sync>),
      NoEntry,
      BadEncoding(Vec<u8>),
      TooLong(String, u32),
      Invalid(String, String),
      Ambiguous(Vec<Box<Credential>>),
  }
  ```

- **B2 — Distinguishable typed error — CONFIRM.** Before writing, the Windows backend's `validate_attributes` computes `password.encode_utf16().count() * 2` and, if it exceeds `CRED_MAX_CREDENTIAL_BLOB_SIZE`, returns **`Error::TooLong("password encoded as UTF-16", 2560)`** — a *distinct* variant from `NoEntry`, `NoStorageAccess` (lock/ACL), and `PlatformFailure`. This is a **pre-flight validation inside keyring**, returned deterministically for oversized input rather than a generic Win32 error surfaced from `CredWriteW`. It is therefore reliably matchable, exactly like the existing `Error::NoEntry` match in `src/api/auth.rs`.
  - **Match shape for the honest-fail path:** `Err(keyring::Error::TooLong(attr, limit))` where `attr == "password encoded as UTF-16"` and `limit == 2560`. (A raw-binary secret path would instead yield `TooLong("secret", 2560)`, but `jr` uses `set_password`, so the UTF-16 attribute name applies.)

- **No built-in chunking / large-secret handling — CONFIRM.** keyring v3 validates against 2560 bytes, copies the blob once, and issues one `CredWriteW`. There is no sharding, multi-credential scheme, or reassembly anywhere in the Windows backend.

- **Upstream issues/PRs:** The relevant records are **closed issue #85** ("Error code 1783 on Windows", reproduced at a 1,461-char password) and **merged PR #107** (2023-01-17), which *added* the corrected UTF-16 byte-size validation and the `TooLong` error. No *currently open* keyring issue/PR is devoted to raising or working around the 2560-byte limit (this negative is lower-confidence — GitHub's filtered search pages were not fully crawlable).

---

## C. Chunking viability & peer behavior — **REFUTE (as a "known/safe standard pattern")**

**Technically possible, not an established safe standard, and NOT what comparable tools do.**

- **Is splitting one secret across `target:0`, `target:1`, + a count marker a known/safe pattern? — REFUTE.** Each `(Type, TargetName)` tuple is independently addressable via `CredWrite`/`CredEnumerate`, so it *can* be built, but there is **no Microsoft-defined chunking protocol** and **no evidence any mainstream tool uses one**. Windows offers **no multi-entry transaction**, so a crash mid-write can leave a new manifest with stale/missing chunks. Safety would depend entirely on a hand-rolled protocol (write chunks → verify → publish manifest last → MAC the reconstructed value → GC old generation). This is bespoke risk, not a blessed pattern.

- **Practical limit on NUMBER of generic credentials?** No documented numeric maximum in Microsoft's `CredWrite`/`CredEnumerate`/`CREDENTIAL` docs. The oft-cited "20-credential limit" pertains to a different Remote Desktop/Vault scenario, not generic `CredWrite`. Empirically a GCM maintainer hit "Not enough memory resources" around **~1,474** generic credentials in one environment (informal, environment-dependent, not contractual). Chunking a token into a handful of entries won't approach any count ceiling — but don't design around an assumed unlimited count.

- **What comparable tools actually do (verified):**
  | Tool | Windows storage for large tokens | Chunks? |
  |---|---|---|
  | **git-credential-manager (GCM)** | Default `wincredman` (subject to 2560-byte limit); **alternative `dpapi` backend** = DPAPI-encrypted **files** under `%USERPROFILE%\.gcm\dpapi_store`, selected via `credential.credentialStore=dpapi`. Issue **#452** frames the DPAPI-file store as the answer to the 2560-byte cap. | **No** — separate selectable backends, no auto-chunk, no auto-fallback |
  | **GitHub CLI (`gh`)** | System store = Windows Credential Manager (Wincred); metadata in `hosts.yml`. Falls back to **plaintext file** if secure storage unavailable/`--insecure-storage`. | **No** |
  | **azure-cli** | MSAL **encrypted file cache** (`msal_token_cache.bin`) under `%USERPROFILE%\.azure`, DPAPI-protected — not Credential Manager. | **No** |
  | **Azure Artifacts Cred Provider** | File caches under `%LOCALAPPDATA%` (`SessionTokenCache.dat`, `.IdentityService\msal.cache`, "OS-secured"). | **No** |
  | **aws-cli / SDK (SSO)** | Plain **JSON files** under `%USERPROFILE%\.aws\sso\cache` (readable `accessToken`). Not CredMan, not DPAPI. | **No** |

  **Precedent conclusion:** the dominant industry answer to "OAuth token too big for CredMan" is **a DPAPI-encrypted file under `%LOCALAPPDATA%`** (GCM, azure-cli, Azure cred provider), or a plain file (gh/aws). **No surveyed tool chunks across Credential Manager entries.**

---

## D. DPAPI-in-Rust option — **CONFIRM (one nuance corrected)**

- **Maintained crates exposing `CryptProtectData`/`CryptUnprotectData` (as of 2026-09-03):**
  | Crate | Latest | Maintenance | Approx downloads | DPAPI surface |
  |---|---|---|---|---|
  | **`windows`** (microsoft/windows-rs) | 0.62.2 | **Active, Microsoft-official** | ~117.5M total | `windows::Win32::Security::Cryptography::{CryptProtectData, CryptUnprotectData, DATA_BLOB, CRYPTPROTECT_LOCAL_MACHINE}` under `Win32_Security_Cryptography` feature |
  | **`winapi`** | 0.3.9 | Mature but **stale** (last release 2020-06) | ~476M total | `winapi::um::dpapi::{CryptProtectData, CryptUnprotectData}` (`dpapi` feature) |
  | **`windows-dpapi`** | 0.2.0 | **Young/small**, recently published (2026-03) | ~65.6k total | Safe wrapper: `encrypt_data`/`decrypt_data`, `Scope::{User, Machine}`; internally calls `winapi` DPAPI (`User`→flag 0, `Machine`→`0x4`) |

  - **No crate literally named `dpapi` wrapping the local-user API was verified.** `dpapi-core` = a pure-Rust blob-format parser (needs the master key already); `dpapi-ng` = DPAPI-NG/gMSA/LAPS (MS-GKDI), **not** the ordinary `CryptProtectData`. Do not confuse these.
  - **Recommended ordering for a new CLI:** (1) `windows` crate (best-supported, most future-proof; note `jr` may already pull `windows`/`windows-sys` transitively via keyring's `windows-native`), (2) `windows-dpapi` (convenient but review its young API), (3) `winapi` (only if already depended on).

- **DPAPI scoping — CONFIRM.** User scope (no flag): normally only the same user, and generally the same computer, can decrypt. `CRYPTPROTECT_LOCAL_MACHINE` (0x4): binds to the *machine* (any local user can decrypt) — materially less restrictive; wrong for per-user token secrecy. Optional entropy adds app-specific separation; `CryptUnprotectData` performs an integrity/MAC check so tampering fails decryption.
  - Source: Microsoft Learn `dpapi.h` `CryptProtectData` / `CryptUnprotectData`.

- **Roaming `%APPDATA%` vs `%LOCALAPPDATA%` — CONFIRM the recommendation, with a correction to the absolute claim.** The premise "a user-scoped DPAPI blob written under roaming `%APPDATA%` can fail to decrypt on another machine, so `%LOCALAPPDATA%` is correct" is **directionally right and is the safe engineering choice**, BUT Microsoft's docs contain an **explicit exception**: a user *with a correctly functioning roaming profile* may decrypt on another computer. So it is **not universally true** that user-scoped blobs are machine-locked.
  - **Actionable conclusion:** store the DPAPI token blob in **`%LOCALAPPDATA%`** (matches `jr`'s existing Windows cache location via `dirs::cache_dir()`), use **user scope** (never `CRYPTPROTECT_LOCAL_MACHINE`), do atomic temp-write + rename, add a versioned envelope, and treat any decryption failure as "force re-auth." Do not rely on `%APPDATA%` roaming for portability, and do not *document* user-scope blobs as guaranteed machine-locked.

- **Supply-chain / `cargo deny` note:** `windows` is Microsoft-published and already in the likely dependency closure (keyring `windows-native` pulls `windows-sys`) — lowest marginal `cargo deny` surface. `windows-dpapi` is low-download and young → adds a new, lightly-audited dependency; weigh under the repo's `cargo deny` license/advisory policy. `winapi` is legacy but ubiquitous. DPAPI via the already-present `windows` family is the cleanest supply-chain choice.

---

## E. Atlassian 3LO token sizes — **INCONCLUSIVE (key sub-claims REFUTED/unproven)**

- **Opaque vs JWT — mixed.** Atlassian's official position: authorization codes and "all API tokens" are **contractually opaque** — clients must not depend on size, structure, or format. *Currently*, access tokens are **often JWT-formatted internally** (an Atlassian engineer confirmed a decodable JWT with scope claims in one 2024 thread, though that was a Forge-issued token). The 3LO docs type both `access_token` and `refresh_token` merely as `<string>` with **no length specified**. So: treat as opaque/variable-length; JWT is an unguaranteed implementation detail.

- **Do access tokens scale with scope count? — PLAUSIBLE but unproven for this token.** If the token is a JWT encoding granted scopes, more scopes → larger payload. One community report hit a max-header-size problem only at **~70 granular scopes**. A separate Forge issue tied >2048-char *system* tokens partly to large scope counts (Forge system-token evidence, not clean 3LO). **For the exact 8 scopes in `DEFAULT_OAUTH_SCOPES`, no report establishes an access token over 1280 chars / 2560 bytes.** The 8 scope strings total ~150 raw chars; encoding them once in a JWT claim adds roughly that order, and dropping the two ~21-char CMDB scopes changes the base64url payload by only ~55–60 chars — **scope count is unlikely to be the dominant term**; other undisclosed claims (signature, key id, account/site context) dominate.

- **Was the reporter's "first `set_password` (access token) overflows" mechanism confirmed? — INCONCLUSIVE.** It's *possible* the access token exceeds 1280 UTF-16 units on some accounts/sites, but there is **no public evidence tying an 8-scope 3LO access token to a Windows CredMan 2560-byte failure specifically**. The overflow could also be driven by site/account-specific claim bloat rather than the scope set. The bug is real and deterministic per the report; the *root cause attribution to scope count* is not externally corroborated.

- **Refresh-token size — the better-evidenced risk.** Refresh tokens are also opaque/variable-length and **rotate** on every refresh. Community reports: a `varchar(2048)` column was already too small for some refresh tokens, with a second-hand mention of a **~16,000-character** refresh token; Atlassian states there is **no specified maximum or range**. **Assume a refresh token can exceed 2560 bytes.** Even if the access token fits today, the *second* `set_password(refresh)` is an independent overflow risk — and the store must handle both.

---

## F. Scope-trimming as mitigation — **REFUTE (as a durable fix)**

- **Material shrink? — Marginal.** Removing `read:cmdb-object:jira` + `read:cmdb-schema:jira` drops ~43 raw scope chars → ~57 base64url chars in the JWT payload. That only helps if the token is *barely* over the limit; it cannot cure a many-hundred-char excess.

- **Durable? — No.** Atlassian explicitly reserves the right to change token size/structure/format. A token that fits only because it's under 1280 chars today can break again from added claims, grant/resource changes, signature/key changes, or a future token format. **Scope-trimming moves the cliff; it does not remove it.** (Minimizing scopes for least-privilege is still worthwhile on its own merits — just not as a storage-size guarantee.)

- **Re-consent implications — real.** Atlassian documents that **both adding and removing** an app's registered scopes require users to **re-consent** (dev-console "Add/Remove … users who previously consented will need to re-consent"). Changing `DEFAULT_OAUTH_SCOPES` is a user-visible re-authentication event — consistent with the existing CLAUDE.md guidance on `DEFAULT_OAUTH_SCOPES` changes (update the Developer Console app + CHANGELOG re-consent note). This is a cost, not a benefit, of the scope-trim path.

---

## Synthesis & recommendation

**Which fix the evidence best supports.** Ranked:

1. **DPAPI-encrypted file under `%LOCALAPPDATA%` (leading durable fix).** This is exactly what the closest precedents do (GCM's `dpapi` store, azure-cli's MSAL cache, Azure Artifacts cred provider). It removes the fixed 2560-byte ceiling entirely, handles both access *and* refresh tokens regardless of future Atlassian size changes, and can reuse the `windows` crate likely already in the tree (via keyring's `windows-native`). Store user-scope (`CryptProtectData`, no `LOCAL_MACHINE`), atomic temp-write+rename, versioned envelope, decryption-failure → force re-login. This is the only option that makes the "token grows unpredictably" reality a non-issue.

2. **Honest-fail on `Error::TooLong` (minimum viable, ship-now).** At the very least, `store_oauth_tokens` should **match `keyring::Error::TooLong(_, _)`** (established pattern — mirrors the existing `Error::NoEntry` match) and surface an actionable, correct message instead of the mislabeled "2560 chars" keyring string — e.g. "Your Atlassian token is too large for Windows Credential Manager's 2560-byte limit; jr will store it in an encrypted local file" (once #1 lands) or a clear diagnostic + guidance in the interim. This turns a cryptic failure into a comprehensible one and is a safe, small change independent of the storage redesign. **Note:** the current code writes access *then* refresh with no size handling; a partial-write is possible if only one overflows — the honest-fail (and ultimately the DPAPI store) should treat the OAuth pair atomically.

3. **Scope-trim — NOT recommended as the fix.** Marginal shrink, moves the cliff, forces re-consent, and isn't corroborated as the actual root cause. Keep least-privilege scope hygiene as a separate concern.

4. **Chunking across CredMan entries — NOT recommended.** Bespoke, transaction-less, unprecedented among peer tools, and strictly more complex/fragile than a single DPAPI file for zero additional security benefit.

**Recommended path:** ship **#2 (honest-fail on `TooLong`)** immediately as a safety net, and implement **#1 (DPAPI file under `%LOCALAPPDATA%`, user scope)** as the durable fix — matching GCM/azure-cli precedent. Consider a keyring-first-with-DPAPI-fallback layering so small tokens keep using the OS credential store and only oversized ones spill to the encrypted file (mirrors GCM's model without auto-chunk complexity).

**Assumptions that turned out FALSE or overstated:**
- *"Scope count is why the access token overflows"* — **unproven / likely not dominant** (E). Other JWT claims dominate; refresh-token size is the better-evidenced overflow risk.
- *"Scope-trimming is a fix"* — **false as a durable fix** (F); it only moves the cliff and triggers re-consent.
- *"Chunking is a known/safe pattern"* — **false as a standard** (C); no surveyed tool does it; peers use DPAPI files.
- *"User-scoped DPAPI blobs are always machine-locked"* — **not universally true** (D); Microsoft documents a roaming-profile exception. `%LOCALAPPDATA%` is still the correct choice, but don't document an absolute guarantee.
- Everything in the bug report's *mechanism* (2560 bytes, UTF-16, ~1280-char ceiling, keyring's "chars" mislabel, matchable `TooLong`) — **CONFIRMED**.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 3 | (1) CredMan 2560-byte limit + keyring v3.6.x Windows internals/Error enum/TooLong + chunking + upstream issues; (2) comparable tools (GCM/gh/azure-cli/aws) + chunking safety + credential-count limits + Rust DPAPI crates + DPAPI scoping/roaming; (3) Atlassian 3LO access/refresh token format & size, scope scaling, scope-trim & re-consent |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 (attempted — `mcp__context7__resolve-library-id` returned "No such tool available"; keyring docs.rs source was instead retrieved via perplexity_research) | intended keyring API/Error-enum lookup |
| Grep/Read (local) | 2 | Confirmed `DEFAULT_OAUTH_SCOPES` (8 scopes incl. cmdb/assets + offline_access) and `store_oauth_tokens`/`Error::NoEntry` match pattern in `src/api/auth.rs` |
| WebFetch | 0 | — |
| WebSearch | 0 | — |
| Training data | 1 area | General framing of OAuth/keyring/DPAPI concepts — every load-bearing claim independently sourced above; flagged where inconclusive |

**Total MCP tool calls:** 3 (all `perplexity_research`, `search_context_size: high`)
**Training data reliance:** low — all substantive claims are cited to Microsoft Learn, docs.rs (keyring 3.6.3 source), the keyring-rs/GCM/azure-cli/aws-cli repos, and developer.atlassian.com / community.developer.atlassian.com. Explicitly flagged INCONCLUSIVE items: the 8-scope access-token overflow attribution (E) and the absence of a *currently open* keyring issue on the limit.

### Key primary sources
- Microsoft Learn — `CREDENTIALW` (`ns-wincred-credentialw`): `CredentialBlobSize` in **bytes**, max `CRED_MAX_CREDENTIAL_BLOB_SIZE = 5*512 = 2560`.
- Microsoft Learn — `CredWriteW` (`nf-wincred-credwritew`); `CryptProtectData` / `CryptUnprotectData` (`dpapi.h`) incl. `CRYPTPROTECT_LOCAL_MACHINE` and the roaming-profile decryption exception.
- docs.rs — `keyring` 3.6.3 Windows backend + `error.rs` (`Error` enum, `TooLong(String,u32)`, `Display` "chars" mislabel).
- GitHub — `hwchen/keyring-rs` issue #85, PR #107; `git-ecosystem/git-credential-manager` issue #452 (2560-byte cap → DPAPI file store), `docs/credstores.md`; `cli/cli`, `Azure/azure-cli`, `microsoft/artifacts-credprovider`, `aws/aws-cli` storage docs.
- developer.atlassian.com — 3LO apps (`access_token`/`refresh_token` typed `<string>`), managing-oauth-apps (re-consent on scope add/remove); community.developer.atlassian.com — token-format ("opaque"), token-length & max-header-size threads (refresh tokens >2048 / ~16k chars).
- crates.io / docs.rs — `windows` 0.62.2, `winapi` 0.3.9, `windows-dpapi` 0.2.0 (and disambiguation of `dpapi-core` / `dpapi-ng`).
