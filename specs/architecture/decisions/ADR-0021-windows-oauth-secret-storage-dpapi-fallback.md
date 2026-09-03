---
document_type: adr
adr_id: ADR-0021
status: Accepted
date: 2026-09-03
subsystems_affected: ["SS-03", "SS-08", "SS-09"]
supersedes: null
superseded_by: null
related: ["ADR-0016", "ADR-0020"]
---

# ADR-0021: Windows OAuth Secret Storage — Keyring-First with DPAPI-Encrypted-File Fallback

## Status

**Accepted** (2026-09-03). Gate: F2 spec evolution for the `windows-correctness` bundle
(Feature Mode cycle-004; issue #759, DEC-334 in `.factory/STATE.md`'s Decisions Log). Locked
strategy per DEC-334 (human-decided, not re-litigated here): keyring-first with a user-scope
DPAPI-encrypted-file fallback for oversized OAuth secrets, plus an honest-fail backstop.
Chunking across Credential Manager entries and scope-trimming were evaluated by research
(`.factory/research/win-oauth-keychain-blob-limit-2026-09-03.md`) and REJECTED — no precedent
among comparable tools, transaction-less, and (for scope-trimming) does not remove the
overflow risk, only shrinks it.

> **NOTE — factory-artifact placement, not yet an F4 code artifact.** This ADR governs new
> code in `src/api/auth.rs` (`store_oauth_tokens`/`load_oauth_tokens`/`clear_profile_oauth_pair`/
> `clear_profile_creds`) and a new sibling module (`src/api/auth_windows_store.rs`), plus a new
> `[target.'cfg(windows)'.dependencies]` block in `Cargo.toml` and a `deny.toml` comment update
> — none of which exist in this shape in `src/` as of this writing (F2). It is the record F4's
> `dpapi-storage-fix` and `honest-fail-message` stories implement against.

## Context

`jr auth login --oauth` (and `jr init` → OAuth) can never succeed on Windows as of v0.6.0.
`store_oauth_tokens` (`src/api/auth.rs::store_oauth_tokens`) writes the OAuth access and
refresh tokens straight to `keyring::Entry::set_password`, which on the `windows-native`
backend maps to a single `CredWriteW` call with a hard `CRED_MAX_CREDENTIAL_BLOB_SIZE` = 2560
byte (~1280 UTF-16 code unit) ceiling — confirmed against Microsoft's own `CREDENTIALW`/
`CredWriteW` documentation and `keyring` 3.6.3's Windows backend source
(`.factory/research/win-oauth-keychain-blob-limit-2026-09-03.md` §A/§B/§B2, all CONFIRM).
Atlassian's own token contract states both `access_token` and `refresh_token` are opaque,
variable-length strings with **no documented maximum** — the research doc's best-evidenced
overflow risk is the *refresh* token (community reports of tokens well above 2048, anecdotally
~16,000 characters), not the access token or the 8-scope default scope set. This means
scope-trimming (§F, REFUTED as a durable fix) cannot close the gap, and any fixed-ceiling store
(chunking across additional Credential Manager entries, §C, REFUTED as a known/safe pattern)
merely relocates the cliff.

The dominant precedent among comparable tools — `git-credential-manager`'s `dpapi` store,
`azure-cli`'s MSAL encrypted file cache, the Azure Artifacts credential provider — is a
DPAPI-encrypted file under `%LOCALAPPDATA%`, not chunking and not a raised ceiling (research
doc §C/§D). This is validated design precedent only; no code is transfused from any of these
tools.

Today's `store_oauth_tokens` also writes access then refresh with **no atomicity** and, on any
keychain-layer failure, unconditionally blames a "locked keychain" — a message that is
accurate for zero of the failure modes actually reachable on Windows for this bug
(`keyring::Error::TooLong` is neither a lock nor a permission error). A dangling, unrevoked
Atlassian server-side grant is left behind on every failed attempt.

`jr`'s existing Windows path-resolution seam (`src/cache.rs::cache_root()`, BC-6.2.016/
BC-6.2.017) already resolves to `%LOCALAPPDATA%\jr` via `dirs::cache_dir()` and already honors
the `JR_CACHE_DIR` debug-only test-isolation seam (ADR-0016). Reusing this resolved root — in a
new, explicitly non-disposable sibling subtree, not the existing `v1/` cache namespace — is the
architecturally consistent choice.

## Decision

We adopt, as one coherent change to OAuth credential storage on Windows:

### 1. Keyring-first, DPAPI-file fallback ONLY on `keyring::Error::TooLong`

`store_oauth_tokens(profile, access, refresh)` continues to attempt `keyring::Entry::set_password`
first for both secrets, unchanged on macOS/Linux and for any Windows secret that fits. The
DPAPI-encrypted-file path is engaged **only** when a `set_password` call returns
`keyring::Error::TooLong(_, _)` — never a pre-flight length guess against a hardcoded byte
budget (that would duplicate/hardcode `CRED_MAX_CREDENTIAL_BLOB_SIZE` outside `keyring`'s own
validation and drift silently if `keyring` ever changes its ceiling or encoding). This routing
predicate is a pure, cross-platform-testable function:

```rust
// src/api/auth_windows_store.rs (pure — testable on any OS)
pub(crate) fn should_fallback_to_dpapi(err: &keyring::Error) -> bool {
    matches!(err, keyring::Error::TooLong(_, _))
}
```

### 2. The access/refresh pair is stored ENTIRELY in one backend, never split

`store_oauth_tokens` treats the pair as one atomic unit at the BACKEND-SELECTION level, not
just the write level:

```rust
pub fn store_oauth_tokens(profile: &Profile, access: &str, refresh: &str) -> Result<()> {
    let access_key = oauth_access_key(profile.as_ref());
    let refresh_key = oauth_refresh_key(profile.as_ref());

    match entry(&access_key)?.set_password(access) {
        Ok(()) => match entry(&refresh_key)?.set_password(refresh) {
            Ok(()) => {
                // Both landed in keyring. Best-effort cleanup of a stale
                // DPAPI file from a prior oversized-token generation for
                // this profile (e.g. a shorter refresh token after
                // rotation now fits) — never fails the call.
                let _ = auth_windows_store::remove_if_present(profile);
                Ok(())
            }
            Err(e) if auth_windows_store::should_fallback_to_dpapi(&e) => {
                // Refresh overflowed after access succeeded — roll back
                // the access write so the pair can never end up split
                // across two backends.
                delete_credential_tolerating_no_entry(&access_key)?;
                auth_windows_store::store_pair(profile, access, refresh)
            }
            Err(e) => Err(e.into()), // genuine backend/lock error — propagate unchanged
        },
        Err(e) if auth_windows_store::should_fallback_to_dpapi(&e) => {
            // Access overflowed; don't even attempt refresh in keyring —
            // route the whole pair to the DPAPI store directly.
            auth_windows_store::store_pair(profile, access, refresh)
        }
        Err(e) => Err(e.into()),
    }
}
```

The pair is therefore, at all times, either **fully in the keyring** or **fully in one DPAPI
file** — never one secret in each. This closes the pre-existing partial-write risk the research
doc flags (today's code has no atomicity at all, DPAPI or not) as a side effect of the routing
design, without needing a separate transaction mechanism.

### 3. DPAPI-encrypted-file store — pure/impure seam

New module `src/api/auth_windows_store.rs`, split so the encode/decode/routing logic is
cross-platform unit-testable and only the actual DPAPI syscalls are Windows-only:

```rust
// --- pure, testable on any OS ---
pub(crate) mod envelope {
    /// JSON-serialize {version, access, refresh} to plaintext bytes.
    pub fn encode(access: &str, refresh: &str) -> Vec<u8> { /* serde_json */ }
    /// Parse plaintext bytes back to (access, refresh). Any structural
    /// error (bad JSON, missing field) is a distinct "corrupt envelope"
    /// error, never silently coerced into "no token."
    pub fn decode(bytes: &[u8]) -> anyhow::Result<(String, String)> { /* … */ }
    /// Prepend a 4-byte magic (`b"JROD"`) + 1-byte version to the DPAPI-
    /// protected ciphertext, producing the on-disk file contents.
    pub fn wrap(protected: Vec<u8>) -> Vec<u8> { /* … */ }
    /// Validate the 5-byte header and return the remaining protected
    /// bytes. Unknown magic/version is a distinct "unrecognized envelope"
    /// error, never silently coerced into "no token."
    pub fn unwrap(file_bytes: &[u8]) -> anyhow::Result<&[u8]> { /* … */ }
}

pub(crate) fn should_fallback_to_dpapi(err: &keyring::Error) -> bool { /* §1 above */ }

fn file_path(profile: &Profile) -> std::path::PathBuf {
    // NEW sibling subtree to the existing cache root — deliberately NOT
    // under `v1/`, which is the documented-disposable, 7-day-TTL cache
    // namespace (src/cache.rs). A credential is not disposable; no
    // existing cache-expiry/cleanup logic may ever touch this path.
    crate::cache::cache_root()
        .join("secrets")
        .join(profile.as_ref())
        .join("oauth-tokens.dat")
}

// --- impure, Windows-only, thin unsafe FFI wrapper ---
#[cfg(windows)]
mod dpapi {
    // CryptProtectData/CryptUnprotectData via windows-sys (see §5 for the
    // dependency decision). User scope only — CRYPTPROTECT_LOCAL_MACHINE
    // is never passed; that flag would let ANY local user decrypt the
    // blob, defeating the point of storing a per-user OAuth secret.
    pub fn protect(plaintext: &[u8]) -> std::io::Result<Vec<u8>> { /* … */ }
    pub fn unprotect(blob: &[u8]) -> std::io::Result<Vec<u8>> { /* … */ }
}

/// Atomic pair write: encode -> DPAPI-protect -> wrap -> temp-write ->
/// rename. `#[cfg(windows)]`: real implementation. `#[cfg(not(windows))]`:
/// always returns the honest-fail error immediately (DPAPI is
/// categorically unavailable; this path exists only so the cross-platform
/// call site in `store_oauth_tokens` compiles uniformly — the size
/// threshold that triggers it is realistically never hit by macOS
/// Keychain / Linux Secret Service, whose ceilings are far above
/// anything Atlassian emits).
pub fn store_pair(profile: &Profile, access: &str, refresh: &str) -> anyhow::Result<()> { /* … */ }

/// Ok(None) if no file exists for this profile. Err on a file that exists
/// but fails to decrypt/parse (corruption, tamper, or a different Windows
/// user account) — this is a "force re-login" condition, never silently
/// coerced into "no token."
pub fn load_pair(profile: &Profile) -> anyhow::Result<Option<(String, String)>> { /* … */ }

/// Delete the file if present; `NotFound` is success (mirrors
/// `delete_credential_tolerating_no_entry`'s NoEntry-is-success shape).
pub fn remove_if_present(profile: &Profile) -> anyhow::Result<()> { /* … */ }
```

The atomic file write is: build the full file bytes in memory, write to
`<profile-dir>/oauth-tokens.dat.tmp-<random-suffix>` in the SAME directory as the final path,
then `std::fs::rename` over the final path. `rename` within one NTFS volume is atomic; the
directory is created (`create_dir_all`) before the temp write if absent.

### 4. Read path — keyring first, then the DPAPI file

`load_oauth_tokens(profile)` gains one new branch, inserted where today's code reaches the
"both namespaced keys absent" case (before falling through to the existing `"default"`-only
legacy-flat-key recovery, which is unchanged):

1. Both namespaced keyring keys present → return them (unchanged, fast path for every
   non-oversized secret on every platform).
2. Both namespaced keyring keys absent → **NEW:** try `auth_windows_store::load_pair(profile)`.
   - `Ok(Some((a, r)))` → return them.
   - `Err(e)` (file present but corrupt/undecryptable) → propagate a distinct,
     force-re-login error: `"OAuth credentials for profile {profile:?} could not be decrypted
     (the file may be corrupted, or was created by a different Windows user account). Run
     \"jr auth login --oauth --profile {profile}\" to re-authenticate."` — never silently
     treated as "no token," which would misleadingly suggest the user never logged in.
   - `Ok(None)` → fall through to the existing `"default"`-only legacy-flat-key check, then the
     existing "No stored OAuth token" error (unchanged).
3. Exactly one namespaced keyring key present (partial write) → **existing logic is extended,
   not replaced:** first attempt the existing `"default"`-only legacy-pair recovery (unchanged);
   if that doesn't resolve it, additionally check `auth_windows_store::load_pair(profile)` — if
   it exists and decrypts to a complete pair, prefer it (this can only arise from an unexpected
   dual-state that §2's routing invariant should prevent in normal operation) and emit a
   stderr warning noting a partial keyring remnant was ignored; otherwise fall through to
   today's "OAuth keychain entries … are partial" error, unchanged.

`#[cfg(not(windows))]`, `auth_windows_store::load_pair` always returns `Ok(None)` — this branch
is a no-op read on macOS/Linux, never engaged in practice (see VP-AUTHDX-013, F1 §7.4).

### 5. Dependency decision: `windows-sys` (already-present, promoted to a direct dependency), NOT the `windows` crate

**Recommendation: use `windows-sys` 0.60.2** for the `Win32_Security_Cryptography` /
`Win32_Foundation` FFI surface (`CryptProtectData`, `CryptUnprotectData`, `DATA_BLOB`,
`LocalFree`), added as a NEW `[target.'cfg(windows)'.dependencies]` entry in `Cargo.toml`:

```toml
[target.'cfg(windows)'.dependencies]
windows-sys = { version = "0.60", features = ["Win32_Security_Cryptography", "Win32_Foundation"] }
```

This is **not** a new crate in the dependency graph — `windows-sys` 0.60.2 is already present
transitively via `keyring`'s `windows-native` feature and already carries a documented,
reasoned `[[bans.skip]]` entry in `deny.toml` (`.factory/research/…` §D and §6 of the F1 delta
analysis independently re-verified this against `Cargo.lock`, correcting the research doc's
"likely already transitive" hedge for the *bare* `windows` crate specifically — that crate is
genuinely absent). Promoting `windows-sys` to a direct dependency at the SAME version (0.60)
that keyring already pulls introduces zero new versions into the lock file — it adds a second
consumer of an already-skipped version, not a new skip. The `deny.toml` `[[bans.skip]]` entry
for `windows-sys` version `"0.60"` (its `reason` field currently names only keyring's
`windows-native` feature) MUST be updated in the same F4 change to also name `jr`'s own DPAPI
usage as a second reason the 0.60 version is pinned — otherwise a future reader sees only
"keyring requires it" and might conclude removing keyring's `windows-native` feature makes the
skip removable, which would now also break the DPAPI module.

**Rejected: the `windows` crate (microsoft/windows-rs, 0.62.2).** The research doc's initial
ranking preferred `windows` for its safe, ergonomic wrappers (`DATA_BLOB` struct construction,
typed function signatures) over hand-written `unsafe` FFI. The F1 delta analysis independently
verified this is **not** a free ride: `windows-core` 0.62.2 is present in `Cargo.lock`, but via
`iana-time-zone` (a `chrono` dependency) — an unrelated chain — and the bare `windows` crate
itself does not appear in `Cargo.lock` at all. Adding it would be a genuinely NEW top-level
dependency, pulling its own `windows-core`/`windows-targets`/`windows-link` version graph at a
version this repo has never resolved against before, with an **unverified** interaction against
`deny.toml`'s existing `bans.multiple-versions = "deny"` posture and its already-intricate
four-version `windows-sys`/`windows-targets` skip ladder (S-WIN-3). For a security-critical
credential-storage path, minimizing NEW supply-chain surface outweighs the ergonomic gain of a
safe wrapper over a small, well-bounded FFI surface (two functions, one struct, one free) that
this codebase's existing conventions already require reviewing carefully (`auth_embedded.rs`'s
"thin sibling module" pattern; CLAUDE.md's "No unsafe code without explicit justification in a
comment" rule). `windows-dpapi` (0.2.0) was also considered and rejected — young (published
2026-03), low-download, and would be a wholly new, lightly-audited dependency for a feature
`windows-sys` already covers with the crate already in the tree.

**Unsafe-code justification (required by CLAUDE.md convention):** the `#[cfg(windows)] mod
dpapi` block in `src/api/auth_windows_store.rs` is the sole location in this module tree
touching `unsafe` — two thin wrapper functions (`protect`/`unprotect`) around
`CryptProtectData`/`CryptUnprotectData`, each doing exactly: build a `DATA_BLOB` from a Rust
slice, call the FFI function, copy the output `DATA_BLOB` into an owned `Vec<u8>`, free the
output buffer via `LocalFree`. No other file-write, JSON, or routing logic is `unsafe`.

**MSRV verification is an explicit F4 task, not assumed here:** `windows-sys` 0.60.2's MSRV
against this repo's `rust-version = "1.85"` must be confirmed at F4 (the F1 delta analysis
flagged this as unverified for either dependency candidate).

### 6. Honest-fail backstop — reachable only when BOTH keyring AND the DPAPI store fail

A new, non-string-matched marker error distinguishes "the DPAPI fallback itself failed" from
every other error shape, mirroring this file's existing `NoAppCredentialsAvailable` pattern
(type-based, not string-matched):

```rust
/// Marker: the DPAPI-encrypted-file fallback failed after a keyring
/// TooLong. Distinguishes "the size-safe path is genuinely broken"
/// (disk full, DPAPI syscall failure, permission denied on the secrets
/// directory) from a normal locked-keychain condition on the small-secret
/// path, which keeps today's "Unlock your keychain" message.
pub(crate) struct DpapiFallbackFailed(pub String);
```

The four existing "Unlock your keychain" message sites in `src/api/auth.rs` (F1 delta analysis
§5.2, sites 1–4) are revised:

- **Site 1 (`oauth_login`'s store-failure `map_err`) and Site 3
  (`refresh_oauth_token_with_url`'s post-refresh store-failure `map_err`):** branch
  on `e.downcast_ref::<DpapiFallbackFailed>()`.
  - `Some(_)` → **new honest-fail message**: `"Authorization succeeded with Atlassian, but the
    OAuth tokens were too large for Windows Credential Manager's 2560-byte limit AND jr's
    encrypted-file fallback also failed ({inner}). Check available disk space and file
    permissions, then run \"jr auth login --oauth --profile {profile}\" again. You must first
    revoke the now-unused Atlassian grant: visit
    https://id.atlassian.com/manage-profile/apps."` — the revoke step is stated as a required
    action, not an aside, per DEC-334.
  - `None` → unchanged existing "Unlock your keychain…" message (still accurate: every error
    that reaches this branch with no `DpapiFallbackFailed` marker is a genuine lock/permission
    condition on the small-secret keyring path, or a non-Windows backend error where DPAPI was
    never engaged at all).
- **Site 2 (`refresh_oauth_token_with_url`'s `load_oauth_tokens` read-failure branch):** no
  message-text change — this site becomes DPAPI-aware automatically because it calls the
  corrected `load_oauth_tokens` (§4), which now itself distinguishes a genuine backend error
  (unchanged message here) from a corrupt-DPAPI-file condition (its own distinct message per
  §4, surfaced before this branch is ever reached).
- **Site 4 (`resolve_refresh_app_credentials`'s BYO app-credential-read error):**
  **unchanged.** This guards the OAuth *app's* client_id/client_secret pair — always short
  strings, never `TooLong`-reachable. F4 must audit (not modify) this to confirm.

### 7. Delete/clear paths clean up the DPAPI file too

`clear_profile_oauth_pair` and `clear_profile_creds` each gain one additional step:
`auth_windows_store::remove_if_present(profile)`, called alongside (not instead of) the
existing two keyring deletes, using the same `NoEntry`/`NotFound`-is-success tolerance already
established for `delete_credential_tolerating_no_entry`. Without this, `logout`/`remove`/a
mechanism switch would leave an orphaned encrypted file on disk after every other credential
trace is gone.

## Rationale

- **Keyring-first preserves the existing, working behavior for every non-Windows-oversized
  secret** — macOS Keychain and Linux Secret Service are untouched byte-for-byte; only the one
  Windows failure mode this bug report identifies gains a fallback. This is the narrowest
  change that closes the actual defect.
- **Routing on `TooLong` specifically (not a length pre-check) keeps `jr` from duplicating
  `keyring`'s own validation logic** and from drifting silently if `keyring` changes its
  encoding or ceiling in a future release — the crate's own pre-flight check is already
  reliably typed and matchable (F1 §5.1, confirmed by research doc §B2).
- **Backend-selection-level atomicity (§2) is simpler and more robust than write-level
  transaction machinery** (e.g. a two-phase commit across keyring and DPAPI) — by construction,
  there is only ever one active backend for a given pair at a given time, so "atomic pair write"
  reduces to "one atomic operation in one backend," which the DPAPI path already gets for free
  from `rename`'s filesystem semantics.
- **The pure/impure seam (§3) is required for testability, not merely nice-to-have.** The F1
  delta analysis (§10) identified Windows-only testability as the single largest execution risk
  in this cycle — envelope encode/decode, the routing predicate, and the honest-fail message
  text are all cross-platform unit-testable; only the two-function DPAPI FFI wrapper and the
  real `CryptProtectData`/`CryptUnprotectData` round-trip require Windows CI or manual
  validation (VP-AUTHDX-010 through VP-AUTHDX-013, F1 §7.4).
- **`windows-sys` over `windows`** is a deliberate minimization of new supply-chain surface on a
  security-critical path, at the cost of writing (and unit-testing at the envelope boundary) a
  small amount of `unsafe` FFI code — see §5 for the full comparison.

## Consequences

### Positive
- OAuth 2.0 login becomes possible on Windows for every token size Atlassian can plausibly
  issue, closing the #759 defect at its root rather than shrinking the failure window
  (scope-trimming) or moving it (chunking).
- The access/refresh pair gains a real atomicity guarantee it never had before, on ANY
  platform — a side effect of the backend-selection design, not a separate feature.
- Zero new dependency-graph nodes; `windows-sys` 0.60.2 gains one more consumer inside the
  existing, already-reasoned skip.
- Every "Unlock your keychain" message site becomes accurate for the failure it actually
  reports, closing the secondary root-cause BC (F1 §4) and making the dangling-grant revoke
  step explicit.

### Negative / Trade-offs
- New `unsafe` FFI surface (two functions) in a security-critical module — mitigated by
  minimal scope, code review, and VP-AUTHDX-010's mandatory real-Windows round-trip proof.
- A new non-disposable on-disk artifact (`%LOCALAPPDATA%\jr\secrets\<profile>\oauth-tokens.dat`)
  that must be kept in sync (write, read, delete) across every OAuth-token call site — this is
  the module's core correctness burden, addressed by making every existing call site route
  through the same `store_oauth_tokens`/`load_oauth_tokens`/`clear_profile_*` functions rather
  than introducing parallel call sites.
- Genuinely Windows-only correctness (the real DPAPI round-trip) cannot be proven on
  macOS/Linux CI — per F1 §10, manual validation on real Windows, or a `windows-latest` CI spike
  proving `CryptProtectData` is reachable in that headless runner context, is very likely
  required before F7 convergence. This ADR does not resolve that open question (F1 §13 Q3);
  it is carried forward to the F2 human gate.

### Status as of this ADR (2026-09-03, cycle-004 F2)
**Accepted, not yet implemented.** No `src/` file has changed. This ADR is the design F4's
`dpapi-storage-fix` and `honest-fail-message` stories implement against.

## Alternatives Considered

- **Chunking a secret across multiple Credential Manager entries** (`target:0`, `target:1`,
  a count-marker entry): rejected. No Microsoft-defined protocol, no evidence any mainstream
  tool does this, no multi-entry transaction primitive on Windows — a crash mid-write can leave
  a manifest referencing missing/stale chunks. Research doc §C, REFUTE.
- **Scope-trimming `DEFAULT_OAUTH_SCOPES`** to shrink the access token: rejected as a durable
  fix. Marginal shrink (~55-60 base64url chars), does not address the better-evidenced refresh-
  token overflow risk, forces user re-consent, and Atlassian reserves the right to change token
  size/structure regardless of scope count. Research doc §F, REFUTE.
- **`windows` crate for DPAPI FFI**: rejected — see §5. Ergonomically superior, but a genuinely
  new top-level dependency with an unverified `deny.toml` interaction, for a small, well-bounded
  FFI surface `windows-sys` already covers with the crate already in the tree.
- **`windows-dpapi` crate (0.2.0)**: rejected — young, low-download, wholly new dependency;
  internally wraps the legacy `winapi` crate rather than `windows-sys`/`windows`.
- **A pre-flight length check against a hardcoded 2560-byte budget**, attempted before ever
  calling `set_password`: rejected — duplicates `keyring`'s own validation outside the crate,
  and would silently desync if `keyring` changes its UTF-16 encoding or ceiling in a future
  release. Routing on the typed `TooLong` error keeps `jr` a passive consumer of `keyring`'s own
  authoritative check.

## Source / Origin

- `.factory/research/win-oauth-keychain-blob-limit-2026-09-03.md` — primary evidence base
  (Microsoft Learn `CREDENTIALW`/`CredWriteW`/`dpapi.h`; `keyring` 3.6.3 source; GCM/azure-cli/
  gh/aws-cli precedent survey; Atlassian 3LO token-size research).
- `.factory/cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md` §§3-10 — impact
  boundary, new/modified/dependent components, new-dependency assessment (§6, the `windows`-vs-
  `windows-sys` Cargo.lock correction), affected artifacts (§7), Windows-only testability risk
  (§10).
- `src/api/auth.rs::store_oauth_tokens`, `::load_oauth_tokens`, `::clear_profile_oauth_pair`,
  `::clear_profile_creds`, `::oauth_login`, `::refresh_oauth_token_with_url`,
  `::resolve_refresh_app_credentials`, `::NoAppCredentialsAvailable` — the existing functions
  this ADR modifies and the type-based marker-error pattern it mirrors.
- `src/cache.rs::cache_root()` — the existing Windows path-resolution seam this ADR reuses
  (new `secrets/` sibling subtree, not the disposable `v1/` cache namespace).
- `Cargo.lock` (read directly, 2026-09-03) — confirms `windows-sys` 0.60.2 present via keyring;
  the bare `windows` crate absent; `windows-core` 0.62.2 present via an unrelated
  `iana-time-zone`/`chrono` chain.
- `deny.toml`'s existing `windows-sys`/`windows-targets` `[[bans.skip]]` ladder (S-WIN-3) — the
  four-version skip set this ADR's dependency choice extends (one entry's `reason` updated)
  without adding a new skip.
- ADR-0016 (Windows build target) — carried-forward context: Windows is a first-class release
  target; this ADR's DPAPI dependency is `#[cfg(windows)]`-gated the same way ADR-0016's
  Windows-only build concerns are scoped.
- ADR-0020 — the most recent auth-subsystem ADR; this ADR's new module sits alongside, not in
  tension with, ADR-0020's per-profile credential-ownership model (the DPAPI file is keyed by
  the same `Profile` newtype and namespacing convention).
</content>
