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

**Pass-1 adversarial-review correction (2026-09-03, Finding #5).** `should_fallback_to_dpapi`
itself stays a pure, OS-agnostic predicate — that is exactly what makes it unit-testable on any
CI runner (see Rationale) — but its **call site** in `store_oauth_tokens` (§2 below) is
`#[cfg(windows)]`-gated, not merely "practically never true on macOS/Linux." A new thin wrapper
makes this explicit:

```rust
#[cfg(windows)]
fn engage_dpapi_fallback(err: &keyring::Error) -> bool {
    auth_windows_store::should_fallback_to_dpapi(err)
}

#[cfg(not(windows))]
fn engage_dpapi_fallback(_err: &keyring::Error) -> bool {
    false
}
```

`store_oauth_tokens`'s match guards (§2) call `engage_dpapi_fallback`, never
`should_fallback_to_dpapi` directly. On `#[cfg(not(windows))]`, a `set_password` failure is
therefore matched and propagated exactly as it is today — `auth_windows_store::store_pair`/
`load_pair` are never reached from `store_oauth_tokens`/`load_oauth_tokens`, and the pre-existing
"Unlock your keychain" message path is untouched. This is required by BC-1.4.035 Invariant 3
("macOS/Linux byte-for-byte UNCHANGED"): without the call-site gate, a hypothetical non-Windows
`keyring::Error::TooLong` (no known backend returns this today, but the variant is not
Windows-exclusive in `keyring`'s own enum) would route through `auth_windows_store::store_pair`'s
`#[cfg(not(windows))]` arm, which always fails with `DpapiFallbackFailed` — and that marker is
rendered by the honest-fail message (§6) with **Windows-specific wording** ("Windows Credential
Manager's 2560-byte limit"), which would be both false and a behavior change on macOS/Linux.
Gating the call site is strictly safer than making the message platform-neutral: a
platform-neutral message would still be a NEW code path on non-Windows that does not exist
today, which Invariant 3's "byte-for-byte" wording rules out regardless of message wording.

**Pass-5 adversarial-review correction (2026-09-03, Finding #1) — a debug-only test-engagement
seam, because the production gate makes §2's routing branch structurally UNREACHABLE on
non-Windows.** The Pass-1 fix above is correct and stays exactly as specified: production
non-Windows behavior is, and remains, hardcoded `false`. But that gate has a direct, previously
unstated consequence for testability — with `engage_dpapi_fallback` hardcoded `false` on
`#[cfg(not(windows))]`, the `Err(e) if engage_dpapi_fallback(&e) => { … }` match arms in
`store_oauth_tokens` (§2) can **never** be entered on a Linux/macOS test run, no matter how the
test mocks `keyring::Error::TooLong` — the delete-keyring-first ordering, the rollback logic, and
the stale-keyring-shadow closure (Finding #1, Pass-3 review; BC-1.4.035 Invariant 1) are therefore
dead code on every CI runner except a real (or cross-compiled) Windows one. A downstream VP
(VP-AUTHDX-022, and sub-portions of VP-AUTHDX-011/012) that asserts outcomes of `store_oauth_tokens`
actually taking that branch — e.g. "both keyring keys are absent after `store_oauth_tokens`
returns `Ok`" — is not merely hard to run in default CI, it describes a code path the production
gate makes unreachable there **by construction**. This is the contradiction Finding #1 identifies:
Pass-1's fix (correctly) closed off the branch for production correctness, and in doing so silently
closed off the branch for default-CI testability too, without either pass noticing the entanglement.

**Decision: add a `#[cfg(debug_assertions)]`-gated, opt-in test seam, `JR_FORCE_DPAPI_FALLBACK`,**
following this codebase's established `JR_*` debug-only seam convention byte-for-byte (see
CLAUDE.md's "AI Agent Notes" seam table — e.g. `JR_S303_PERSIST_FAIL`, `JR_SERVICE_NAME`): a single
env-var check, gated out of release builds entirely, read at exactly one call site.

```rust
#[cfg(windows)]
fn engage_dpapi_fallback(err: &keyring::Error) -> bool {
    auth_windows_store::should_fallback_to_dpapi(err)
}

#[cfg(not(windows))]
fn engage_dpapi_fallback(err: &keyring::Error) -> bool {
    // JR_FORCE_DPAPI_FALLBACK=1: debug-only test seam (Pass-5 review,
    // Finding #1). Lets a Linux/macOS CI runner exercise
    // store_oauth_tokens's DPAPI-routing branch -- delete-keyring-first
    // ordering, rollback-on-partial-overflow, and the
    // neither-backend-on-store-failure shape (VP-AUTHDX-011/012/022) --
    // none of which is otherwise reachable on non-Windows, since this
    // function is hardcoded `false` in production. #[cfg(debug_assertions)]
    // -gated: compiled out of release builds entirely, identical in shape
    // to every other JR_* debug-only seam in this codebase. PRODUCTION
    // non-Windows behavior is UNCHANGED by this seam's existence: absent an
    // explicit opt-in (env var set) in a debug build, this function still
    // returns `false` unconditionally -- BC-1.4.035 Invariant 3 is not
    // weakened, only made independently testable at the branch level.
    #[cfg(debug_assertions)]
    {
        if std::env::var("JR_FORCE_DPAPI_FALLBACK").as_deref() == Ok("1") {
            return auth_windows_store::should_fallback_to_dpapi(err);
        }
    }
    false
}
```

**What the seam does, and does NOT, make testable on non-Windows.** Even with the seam engaged,
`auth_windows_store::store_pair`'s `#[cfg(not(windows))]` arm (§3) is unchanged — it ALWAYS
returns `DpapiFallbackFailed` immediately after the guard call; it never succeeds off Windows. The
seam therefore makes exactly ONE additional shape exercisable in default CI: **delete-then-fail** —
given a pre-existing, fitting keyring pair and a mocked `TooLong`, `store_oauth_tokens` deletes both
namespaced keyring keys FIRST (per §2's "Ordering, and why"), then calls `store_pair`, which fails;
the observable end state is "neither backend holds a pair for this profile, `store_oauth_tokens`
returns `Err`." This is a real, meaningful regression pin for the delete-first ordering decision
(§2) and for the stale-keyring-shadow closure's crash-safety reasoning (a mid-window fault must
leave the profile fully credential-less, never a stale-but-present keyring pair) — it is NOT a
weaker substitute for that reasoning, it is the honest cross-platform slice of it. What the seam
categorically CANNOT make testable off Windows is the **success** shape — `store_oauth_tokens`
returning `Ok`, the DPAPI file actually holding the fresh pair, and a subsequent `load_oauth_tokens`
reading it back — because that requires `store_pair`'s real, Windows-only DPAPI-protect/wrap/
temp-write/rename implementation to actually run and succeed, which is structurally impossible on
any non-Windows target regardless of this seam. See the companion `architecture-delta.md`'s
"Pass-5 architect guidance for formal-verifier" section for the exact, corrected per-VP
CI-classification this seam requires.

**Doc-fallout note for F4 (expanded, Pass-6 adversarial review, 2026-09-03, Finding #3).** A
Pass-6 review found this note incomplete: it named only the CLAUDE.md documentation step, but
`JR_FORCE_DPAPI_FALLBACK` gates a security-critical credential-storage routing decision, and this
codebase's established `JR_*` debug-only-seam convention (CLAUDE.md's "AI Agent Notes" — see
`JR_SERVICE_NAME`, `JR_STDIN_IS_TTY`, `JR_TEST_BLOCK_UNTIL_SIGINT`, `JR_BASE_URL`, and every other
listed seam) requires THREE things for a seam of this kind, not one. F4's `dpapi-storage-fix` story
MUST ship all three in the SAME commit that introduces the seam:

- **(a) A dedicated `tests/jr_force_dpapi_fallback_release_gate.rs` pin**, matching the sibling-seam
  convention byte-for-byte (model it on `tests/jr_test_block_until_sigint_release_gate.rs` or
  `tests/config_dir_release_gate.rs`): the test asserts `#[cfg(debug_assertions)]` appears within 5
  source lines of the `JR_FORCE_DPAPI_FALLBACK` env-var read in `src/api/auth.rs`'s
  `#[cfg(not(windows))] fn engage_dpapi_fallback` (§1 above) — proving, structurally, that a release
  build compiles the seam's env-var read out entirely, not merely that it happens to return `false`
  in today's source. This is a NEW test file, not an addition to an existing release-gate test, per
  the one-file-per-seam convention every sibling seam already follows.
- **(b) The CLAUDE.md `JR_*` seam-table entry** for `JR_FORCE_DPAPI_FALLBACK` (already required by
  the pre-Pass-6 text above) — unchanged, still required, still in the same commit.
- **(c) An explicit statement, in both the CLAUDE.md entry and the `tests/
  jr_force_dpapi_fallback_release_gate.rs` doc comment, that the seam affects `#[cfg(debug_assertions)]`
  builds ONLY and is compiled out of release** — production non-Windows behavior stays hardcoded
  `false` unconditionally, exactly as §1's code comment already documents; the release-gate test
  (a) is what makes this a proven property rather than an assertion resting on the seam's current
  source shape.

**Serialization requirement for the two opposing-outcome non-Windows tests (Pass-6 review, flagged
for Finding #4, which the formal-verifier specs into the VPs — not resolved here).** Because
`JR_FORCE_DPAPI_FALLBACK` is a process-global environment variable, two test bodies observe
OPPOSITE `engage_dpapi_fallback` outcomes on the identical non-Windows target depending solely on
whether it is set: the pre-existing legacy "Unlock your keychain" message test (asserted with the
env var UNSET) and the new VP-AUTHDX-011/012/022 delete-then-fail tests (§1 above; asserted with the
env var SET to `1`). Run in the same test binary without coordination, these two classes race —
`cargo test`'s default parallel test execution can interleave a `set_var`/`remove_var` from one
thread with an in-flight assertion in another, non-deterministically flipping either test's outcome.
**These MUST be serialized via an `env_lock`-style mutex**, exactly as CLAUDE.md documents for
`JR_SERVICE_NAME` in `tests/oauth_refresh_integration.rs` (a `std::sync::Mutex` guarding every test
that reads or writes the shared env var, held for the duration of the env-var-dependent section) —
not `#[serial]`/a crate-level attribute unless one is already in use elsewhere in this codebase for
the same purpose, and not test-binary-level `--test-threads=1`, which would serialize unrelated
tests too. This requirement governs the VP test implementation the formal-verifier specs (F6/F4
scope) — it does not change ADR-0021's production code shape in §1/§2 above.

**Doc-fallout note for F4 (original).** When this seam ships, CLAUDE.md's "AI Agent Notes" `JR_*`
seam table gains a `JR_FORCE_DPAPI_FALLBACK` entry in the SAME commit, per this codebase's own
codified doc-fallout convention (see the existing note there about `JR_BULK_UNKNOWN_GRACE_SECS`/
`JR_BULK_AWAIT_TIMEOUT_SECS` shipping without it once, retroactively fixed). Not done here — this
ADR is a design document, not the `src/`/`CLAUDE.md` change itself.

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
            Err(e) if engage_dpapi_fallback(&e) => {
                // Refresh overflowed after access succeeded. Two keyring
                // entries can now hold a value this write must not leave
                // behind: `access_key` holds the JUST-WRITTEN new access
                // token (roll it back, as before); `refresh_key` was never
                // touched by this attempt — if this profile previously
                // completed a FITTING login, `refresh_key` (and, by
                // extension, a stale `access_key` if the rollback below
                // did not run) can hold a stale, complete pair that would
                // otherwise permanently shadow the fresh DPAPI pair via
                // the read path's both-keys-present fast path (§4). Clear
                // BOTH keys, in this order, BEFORE the DPAPI write — see
                // the "Ordering, and why" note below (Finding #1, Pass-3
                // review). `engage_dpapi_fallback` is #[cfg(windows)]-gated
                // (see §1) — this arm is reachable on non-Windows only in
                // the sense that the compiler must type-check it; it never
                // fires there at runtime.
                delete_credential_tolerating_no_entry(&access_key)?;
                delete_credential_tolerating_no_entry(&refresh_key)?;
                auth_windows_store::store_pair(profile, access, refresh)
            }
            Err(e) => Err(e.into()), // genuine backend/lock error — propagate unchanged
        },
        Err(e) if engage_dpapi_fallback(&e) => {
            // Access overflowed; its set_password call never landed, so
            // whatever is currently under `access_key` (and `refresh_key`,
            // never even attempted) is untouched by this write attempt —
            // it can be a complete, stale pair from a prior FITTING login.
            // Clear both before routing the fresh pair to DPAPI, same
            // delete-before-store ordering and rationale as the arm above.
            delete_credential_tolerating_no_entry(&access_key)?;
            delete_credential_tolerating_no_entry(&refresh_key)?;
            auth_windows_store::store_pair(profile, access, refresh)
        }
        Err(e) => Err(e.into()),
    }
}
```

**Ordering, and why (Finding #1, Pass-3 adversarial review, STALE-KEYRING-SHADOWS-DPAPI).** The
original design routed an oversized pair to `auth_windows_store::store_pair` without ever
clearing a pre-existing, FITTING keyring pair for the same profile — the read path's "both
namespaced keys present" fast path (§4) would then return that stale pair forever, permanently
shadowing the fresh DPAPI-stored pair. The fix is not merely "also delete the keyring keys
somewhere" — the ORDER matters for crash-safety, and the two options are not equivalent:

- **(a) Delete the keyring pair FIRST, then call `store_pair`** (the chosen design, in the code
  above). A crash between the deletes and a successful `store_pair` rename leaves the profile
  with **no credentials in either backend** — `load_oauth_tokens` (§4) sees both keyring keys
  absent and `auth_windows_store::load_pair` returning `Ok(None)` (the temp file, not yet renamed
  to the final path, is invisible to `load_pair`), and falls through to the existing "No stored
  OAuth token" error. This forces a clean, honest re-login — annoying, but never wrong.
- **(b) Call `store_pair` first, then delete the keyring pair.** A crash between a successful
  `store_pair` rename and the keyring deletes leaves a **complete, stale keyring pair coexisting
  with a complete, fresh DPAPI pair** — exactly the shadowing condition this fix exists to close,
  now reachable again via an interrupted write instead of only via the original code path. This
  ordering can silently REINTRODUCE the defect it was meant to fix.

**Decision: (a).** A mid-crash outcome that forces a clean re-login is unambiguously safer than
one that can silently resurrect stale, possibly-rotated-or-revoked tokens as if they were current
— consistent with this ADR's existing honest-fail philosophy (§6): every other double-failure
path in this design (DPAPI fallback itself failing, a corrupt DPAPI file) already resolves to
"tell the user to re-authenticate," never to "silently keep using an old credential that might no
longer be valid." Choosing (a) means a genuine `store_pair` failure (not just a crash) after the
keyring deletes also leaves the profile fully credential-less rather than falling back to the old
keyring pair — this is an intentional, in-kind extension of that same philosophy, not a
regression: it is exactly the condition the existing honest-fail message (§6) already tells the
user to treat as "re-authenticate and revoke the dangling grant," so leaving a
questionable-but-present old pair in place would be inconsistent with the advice this ADR already
gives for that message.

**Resulting invariant (extends BC-1.4.035 Invariant 1).** The pair is therefore, at all times,
either **fully in the keyring** or **fully in one DPAPI file** — never one secret in each backend
— **and never a complete, stale keyring pair coexisting with a complete, fresh DPAPI pair for the
same profile.** This closes the pre-existing partial-write risk the research doc flags (today's
code has no atomicity at all, DPAPI or not) as a side effect of the routing design, and closes the
stale-shadow risk Finding #1 identifies, without needing a separate transaction mechanism. See the
companion `architecture-delta.md`'s "Pass-3 architect guidance for product-owner and
formal-verifier" section for the required BC-1.4.035 wording and the new VP this invariant needs.

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
```

**Version-field relationship, clarified (Finding #13, Pass-1 review).** There are deliberately
TWO version markers at two different layers, each governing a different, non-overlapping thing:

- The **outer 1-byte version** (in `wrap`'s unencrypted 5-byte header, alongside the `b"JROD"`
  magic) governs the on-disk **ciphertext framing** — how many header bytes precede the
  DPAPI-protected blob, and, for a future format change, whether a different protect/unprotect
  call shape or an entirely different encryption scheme is in play. It must be readable BEFORE
  any decryption is attempted, which is why it lives outside the encrypted region.
- The **inner JSON `version` field** (inside `envelope::encode`'s plaintext) governs the
  decrypted **plaintext schema** — which fields the JSON payload is expected to carry once
  decryption has already succeeded (today: `access`/`refresh` only; a future revision might add,
  e.g., an expiry timestamp). It can only be read AFTER a successful decrypt, so it is the correct
  governing field for any future plaintext-schema migration, independent of ciphertext framing.

**Single source of truth for migration:** a future change to the ciphertext/framing layer (e.g.,
swapping encryption primitives) bumps the OUTER version; a future change to the plaintext/schema
layer (e.g., adding a field) bumps the INNER version. Both are checked on read (`unwrap` checks
the outer, `decode` checks the inner) — this is not redundancy, each guards a different boundary,
and there is no single field that alone governs "the" format version.

**The outer header is unauthenticated by design, and this is safe.** The 5-byte header sits
outside the DPAPI-protected region, so a same-user process (already the established trust
boundary — see §8) could corrupt or rewrite it without needing to break DPAPI at all. This is an
accepted consequence, not an oversight: any tampering — outer header or inner ciphertext — that
does not happen to produce a byte-for-byte-valid, DPAPI-decryptable, correctly-versioned,
correctly-shaped JSON payload lands on the same safe path already specified above and in §4/§6: a
distinct corrupt/undecryptable-envelope error that forces re-login, never a silent "no token" or
a substituted value. A same-user actor capable of rewriting this file could, with or without
touching the version header, more directly just call `CryptUnprotectData` on the blob themselves
(§8) — the header's lack of authentication grants no capability beyond what that same-user trust
boundary already grants.

```rust

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
    // dependency decision).
    //
    // dwFlags = CRYPTPROTECT_UI_FORBIDDEN (0x1) (Pass-5 adversarial review,
    // Finding #3). Suppresses any OS-level UI prompt CryptProtectData/
    // CryptUnprotectData could otherwise raise -- which would hang, not
    // merely degrade, a headless/CI/service process (a real target: see
    // EC-1.4.035-3 and the F4 headless-validation spike, architecture-delta
    // §9 item 3). CRYPTPROTECT_LOCAL_MACHINE (0x4) is never set, in either
    // direction of this flag word -- that flag would let ANY local user
    // decrypt the blob, defeating the point of storing a per-user OAuth
    // secret. User scope, never machine scope, UI forbidden.
    pub fn protect(plaintext: &[u8]) -> std::io::Result<Vec<u8>> { /* … */ }
    pub fn unprotect(blob: &[u8]) -> std::io::Result<Vec<u8>> { /* … */ }
}

/// Atomic pair write: encode -> DPAPI-protect -> wrap -> temp-write ->
/// rename. On EVERY platform, the first statement is `file_path(profile)?`
/// (§9) — this invokes `reject_unsafe_profile_component` and is what makes
/// the guard's wiring at this entry point exercised, and
/// regression-catchable, on an ordinary Linux/macOS CI runner (Pass-4
/// adversarial review, Finding #2), not only on a real Windows machine.
/// `#[cfg(windows)]`: once the guard passes, the real DPAPI-protect/wrap/
/// temp-write/rename implementation runs. `#[cfg(not(windows))]`: once the
/// guard passes, always returns the honest-fail error immediately (DPAPI
/// is categorically unavailable; this path exists only so the
/// cross-platform call site in `store_oauth_tokens` compiles uniformly —
/// the size threshold that triggers it is realistically never hit by
/// macOS Keychain / Linux Secret Service, whose ceilings are far above
/// anything Atlassian emits). The `PathBuf` `file_path` returns is never
/// used by the `#[cfg(not(windows))]` arm's own logic — the call exists
/// solely to exercise the guard on every platform.
pub fn store_pair(profile: &Profile, access: &str, refresh: &str) -> anyhow::Result<()> { /* … */ }

/// On EVERY platform, the first statement is `file_path(profile)?` (§9) —
/// invoking `reject_unsafe_profile_component` before any other behavior
/// (Pass-4 adversarial review, Finding #2). `#[cfg(not(windows))]`: once
/// the guard passes, always returns `Ok(None)` — the resulting `PathBuf`
/// is discarded, nothing is read from disk. `#[cfg(windows)]`: once the
/// guard passes, `Ok(None)` if no file exists for this profile; `Err` on a
/// file that exists but could not be turned into a usable pair — see
/// `CorruptSecretFile` below for the typed discrimination between "this
/// content is corrupt" and "this is a genuine backend/IO error," never
/// silently coerced into "no token."
pub fn load_pair(profile: &Profile) -> anyhow::Result<Option<(String, String)>> { /* … */ }

/// On EVERY platform, the first statement is `file_path(profile)?` (§9) —
/// invoking `reject_unsafe_profile_component` before any other behavior
/// (Pass-4 adversarial review, Finding #2). `#[cfg(not(windows))]`: once
/// the guard passes, always returns `Ok(())` immediately — the resulting
/// `PathBuf` is discarded, no filesystem call is made. `#[cfg(windows)]`:
/// once the guard passes, delete the file if present; `NotFound` is
/// success (mirrors `delete_credential_tolerating_no_entry`'s
/// NoEntry-is-success shape).
pub fn remove_if_present(profile: &Profile) -> anyhow::Result<()> { /* … */ }

/// Marker: `load_pair` found a file but could not turn it into a usable
/// pair because its CONTENT was bad — DPAPI unprotect failed (wrong user,
/// tamper), the 5-byte wrap header was unrecognized (`envelope::unwrap`),
/// or the decrypted plaintext failed `envelope::decode` (malformed JSON,
/// missing field). Attached via `.context(CorruptSecretFile(profile.to_string()))`
/// (or an equivalent `anyhow::Error::from` wrap) at the exact point in
/// `load_pair` where decode/decrypt fails, then recovered by the caller
/// via `e.downcast_ref::<CorruptSecretFile>()` — the SAME type-based,
/// never-string-matched discrimination pattern `DpapiFallbackFailed` (§6)
/// already establishes for the write path.
pub(crate) struct CorruptSecretFile(pub String);
```

**Read-path error discrimination (Finding #2, Pass-2 adversarial review).** BC-1.4.036
(Invariant 3 / Postcondition 2b vs 2c / EC-1.4.036-4) requires `load_oauth_tokens` to distinguish
two DIFFERENT reasons `load_pair` can return `Err`, mirroring the write path's typed
`DpapiFallbackFailed` discrimination rather than ad-hoc `bail!` strings (which this codebase's
conventions forbid matching on):

- **Content is corrupt/undecryptable** (`e.downcast_ref::<CorruptSecretFile>()` is `Some`): the
  file exists and was readable as bytes, but decryption or parsing failed. This is the
  force-re-login condition — §4's existing message text applies unchanged.
- **A genuine backend/IO error reading an existing file** (`downcast_ref` is `None` — e.g.
  permission denied, a disk I/O failure, or the path-guard rejection in §9 firing on a corrupted
  on-disk profile-directory name): this is NOT a corruption signal and must NOT tell the user to
  re-login — re-authenticating would not fix a filesystem permission or I/O problem and would
  needlessly mint a new, unrevoked Atlassian grant. `load_oauth_tokens` propagates this case with
  its own distinct message (§4 step 2 below), never the corrupt-file wording.

This keeps `load_pair`'s public signature exactly as originally specified
(`anyhow::Result<Option<(String, String)>>`) — no new enum-shaped return type is needed — while
making the two failure reasons independently, non-string-matchably inspectable at the call site,
which is what BC-1.4.036's Postcondition 2b/2c split actually requires.

The atomic file write is: build the full file bytes in memory, write to
`<profile-dir>/oauth-tokens.dat.tmp-<random-suffix>` in the SAME directory as the final path,
then `std::fs::rename` over the final path. `rename` within one NTFS volume is atomic; the
directory is created (`create_dir_all`) before the temp write if absent.

**Fsync and temp-file cleanup expectations (Finding #17, Pass-1 review).** Today's
temp-write-then-rename sequence is reasoned only against process-kill (a killed process either
never reaches `rename`, or the rename has already atomically landed — POSIX/NTFS rename
semantics, not a "never partial" guarantee against OS crash or power loss). The write path MUST
`fsync` (`File::sync_all`) the temp file **before** the rename, so a crash immediately after
`rename` cannot leave a zero-length or truncated file visible under the final name on a filesystem
that reorders writes; a directory-entry fsync (`fsync` on the parent directory) after rename is
NOT required here — losing the rename's durability on a true crash lands on the pre-existing
"file absent or unreadable → treat as no-file / corrupt-file → force re-login" safe path already
specified above and in §4/§6, which is acceptable (this is a re-obtainable OAuth credential, not
data requiring crash-durability guarantees). **Orphaned temp files:** a mid-write crash (before
`rename`) can leave a `oauth-tokens.dat.tmp-<suffix>` file behind with no automatic cleanup
specified. `store_pair` MUST attempt to remove pre-existing `*.tmp-*` siblings for the same
profile directory before writing a new one (best-effort, `NotFound`-tolerant, mirroring
`remove_if_present`'s tolerance) — this bounds the leak to "at most one stale temp file per
profile between login attempts" rather than an unbounded accumulation of encrypted-blob-bearing
files across repeated crashes. This is a hygiene/disk-hygiene fix, not a security fix: an orphaned
`.tmp-*` file carries the SAME DPAPI-protected ciphertext and the SAME same-user trust boundary
as the final file (§8), so its accumulation is a disk-space and clutter concern, not a new
exposure.

**Pass-2 adversarial-review correction (2026-09-03, Finding #6) — cleanup is AGE-GATED, not a
blanket delete.** The pre-write cleanup MUST NOT unconditionally remove every `*.tmp-*` sibling it
finds: `refresh_coordinator.rs` single-flights refreshes only WITHIN one process (see its own
module doc) and this ADR adds no cross-process lock for `login`/`refresh` — two `jr` processes can
legitimately race a login/refresh for the SAME profile (e.g. an interactive `login --oauth` and a
concurrent background `refresh`). A blanket delete lets process B's cleanup pass unlink process
A's own in-flight temp file out from under it mid-write, so A's subsequent `rename` targets a path
that no longer exists (on Windows, `rename`/`MoveFileEx` over a vanished source fails; the net
effect is a spuriously failed login/refresh with no data-loss, but a real, avoidable failure).
`store_pair`'s cleanup step therefore only removes a `*.tmp-*` sibling whose file-modified time is
older than a fixed `STALE_TMP_THRESHOLD` (30 seconds) — comfortably longer than one
encode→DPAPI-protect→wrap→write→rename sequence, which is in-memory work plus one small
filesystem write, normally completing in well under a second. A temp file younger than the
threshold is assumed to belong to another process's in-flight write and is left untouched; only a
temp file old enough to be evidence of a genuinely abandoned (crashed) prior attempt is removed.
**Stated concurrency boundary:** this closes the common case (two racing `jr` invocations, normal
disk/DPAPI latency) without adding new cross-process locking machinery, which would be new scope
beyond DEC-334's mandate. The residual risk — a legitimate write that is itself slower than
`STALE_TMP_THRESHOLD` (e.g. a hung DPAPI call or a pathologically slow disk) racing a second
process's cleanup — is accepted and documented here, not engineered away; it is strictly narrower
than today's zero-concurrency-awareness state (no cleanup at all) and requires two independently
unlikely conditions (a concurrent second `jr` process AND an abnormally slow first write) to
manifest.

### 4. Read path — keyring first, then the DPAPI file

`load_oauth_tokens(profile)` gains one new branch, inserted where today's code reaches the
"both namespaced keys absent" case (before falling through to the existing `"default"`-only
legacy-flat-key recovery, which is unchanged):

1. Both namespaced keyring keys present → return them (unchanged, fast path for every
   non-oversized secret on every platform).
2. Both namespaced keyring keys absent → **NEW:** try `auth_windows_store::load_pair(profile)`.
   - `Ok(Some((a, r)))` → return them.
   - `Err(e)` where `e.downcast_ref::<ProfilePathEscape>()` is `Some` (the profile name itself
     fails `reject_unsafe_profile_component`, §9) → **checked FIRST, before `CorruptSecretFile`
     or any other discrimination (Pass-5 adversarial review, Finding #2).** Propagate a distinct
     exit-64 `JrError::UserError` naming the invalid profile — e.g. `"Profile name {profile:?}
     is not valid for credential storage on this platform ({reason}). Choose a different profile
     name."`, where `{reason}` is a short, variant-specific phrase (e.g. "contains a path
     separator," "is a reserved Windows device name") derived from the `ProfilePathEscape`
     variant, never the generic backend-IO wording below. This is required by BC-1.4.040
     Postcondition 6 and was previously unreachable: without this arm checked first, a
     `ProfilePathEscape` (which `anyhow`'s `?`-propagation through `file_path` turns into an
     ordinary `anyhow::Error` indistinguishable by TYPE from any other `load_pair` failure unless
     explicitly downcast-checked) would fall through to the generic backend/IO branch below and be
     rendered as a misleading "check file permissions" message that never mentions the actual
     problem (an invalid profile name).
   - `Err(e)` where (the above check did not match, and) `e.downcast_ref::<CorruptSecretFile>()`
     is `Some` (file present but corrupt/undecryptable — see Finding #2 note in §3) → propagate a
     distinct, force-re-login error: `"OAuth credentials for profile {profile:?} could not be
     decrypted (the file may be corrupted, or was created by a different Windows user account).
     Run \"jr auth login --oauth --profile {profile}\" to re-authenticate."` — never silently
     treated as "no token," which would misleadingly suggest the user never logged in.
   - `Err(e)` otherwise (neither of the above — a genuine backend/IO error reading an existing
     file, e.g. permission denied, a disk I/O failure) → propagate a distinct, NON-re-login error:
     `"Could not read stored OAuth credentials for profile {profile:?}: {e}. Check file
     permissions under %LOCALAPPDATA%\jr\secrets\{profile}\ and try again."` — re-login is not
     suggested, since re-authenticating would hit the identical read failure and would needlessly
     mint a new, unrevoked Atlassian grant.
   - `Ok(None)` → fall through to the existing `"default"`-only legacy-flat-key check, then the
     existing "No stored OAuth token" error (unchanged).

**Discrimination order, stated once, applies everywhere `anyhow::Error` from this module reaches a
message-rendering call site: `ProfilePathEscape` FIRST, then `CorruptSecretFile` (read path only),
then `DpapiFallbackFailed` (store path only, §6), then the generic/legacy fallback.** This ordering
is not arbitrary — `ProfilePathEscape` is checked before any other marker at every call site
because it is the only one of the three that signals a problem with the CALLER's input (the
profile name itself), not with the credential or the storage backend; conflating it with either of
the other two would misdirect the user toward "re-authenticate" or "check file permissions" when
the actual fix is "use a different profile name."
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
  (`refresh_oauth_token_with_url`'s post-refresh store-failure `map_err`):** branch, in order,
  first on `e.downcast_ref::<ProfilePathEscape>()`, then (only if that did not match) on
  `e.downcast_ref::<DpapiFallbackFailed>()`.
  - **`ProfilePathEscape` `Some(_)` → checked FIRST at both sites (Pass-5 adversarial review,
    Finding #2).** Same distinct exit-64 "invalid profile name" `JrError::UserError` as the read
    path (§4) — never the honest-fail message, never "Unlock your keychain." This case can only
    arise here if a profile name that passed whatever guard exists at profile-creation time (there
    is none today — `Profile::from(String)` is unvalidated, ADR-0011) later fails
    `reject_unsafe_profile_component` inside `store_pair`'s guard call; it is included for
    completeness and symmetry with the read path, not because it is expected to fire often in
    practice.
  - **`DpapiFallbackFailed` `Some(_)` → new honest-fail message** (only reached if
    `ProfilePathEscape` did not match): `"Authorization succeeded with Atlassian, but the
    OAuth tokens were too large for Windows Credential Manager's 2560-byte limit AND jr's
    encrypted-file fallback also failed ({inner}). Check available disk space and file
    permissions, then run \"jr auth login --oauth --profile {profile}\" again. You must first
    revoke the now-unused Atlassian grant: visit
    https://id.atlassian.com/manage-profile/apps."` — the revoke step is stated as a required
    action, not an aside, per DEC-334.
  - **Neither marker matched → unchanged existing "Unlock your keychain…" message** (still
    accurate: every error that reaches this branch with neither a `ProfilePathEscape` nor a
    `DpapiFallbackFailed` marker is a genuine lock/permission condition on the small-secret
    keyring path, or a non-Windows backend error where DPAPI was never engaged at all).
- **Site 2 (`refresh_oauth_token_with_url`'s `load_oauth_tokens` read-failure branch):** no
  message-text change — this site becomes DPAPI-aware automatically because it calls the
  corrected `load_oauth_tokens` (§4), which now itself distinguishes a genuine backend error
  (unchanged message here) from a corrupt-DPAPI-file condition (its own distinct message per
  §4, surfaced before this branch is ever reached).
- **Site 4 (`resolve_refresh_app_credentials`'s BYO app-credential-read error):**
  **unchanged.** This guards the OAuth *app's* client_id/client_secret pair — always short
  strings, never `TooLong`-reachable. F4 must audit (not modify) this to confirm.

**Message accuracy is now structural, not incidental (ties back to Finding #5, §1).** Because
`engage_dpapi_fallback` gates DPAPI engagement to `#[cfg(windows)]` at the call site,
`DpapiFallbackFailed` can never be produced by `store_oauth_tokens` on a non-Windows build — the
`Some(_)` branch above is therefore unreachable on macOS/Linux by construction, not merely
"unlikely." The Windows-specific wording in that branch's message is safe to keep exactly as
written.

### 7. Delete/clear paths clean up the DPAPI file too

`clear_profile_oauth_pair` and `clear_profile_creds` each gain one additional step:
`auth_windows_store::remove_if_present(profile)`, called alongside (not instead of) the
existing two keyring deletes, using the same `NoEntry`/`NotFound`-is-success tolerance already
established for `delete_credential_tolerating_no_entry`. Without this, `logout`/`remove`/a
mechanism switch would leave an orphaned encrypted file on disk after every other credential
trace is gone.

### 8. Security posture: same-user trust boundary, no additional entropy, ACL expectations

**Threat model, stated explicitly (Finding #11, Pass-1 review).** `dpapi::protect`/`unprotect`
call `CryptProtectData`/`CryptUnprotectData` with `pOptionalEntropy = NULL`. Any process running
as the SAME Windows user account that owns the file can call `CryptUnprotectData` on it and
recover the plaintext OAuth tokens — DPAPI's user-scope protection ties decryption to the
logged-on user's master key, not to `jr.exe` specifically, and no per-application secret is mixed
in. This is the IDENTICAL trust boundary CLAUDE.md's `SEC-WCM-DOC` already documents for Windows
Credential Manager storage ("Secrets stored there are accessible to any process running in the
same user session… OS-level user-session isolation is the trust boundary on Windows") — this ADR
extends that SAME boundary to the DPAPI-file fallback, deliberately not a stricter or looser one.
It was previously unstated for this new on-disk artifact; this section makes it explicit.

**Decision: no `pOptionalEntropy`.** A secondary entropy value strengthens DPAPI's protection
only if the entropy itself is kept somewhere a same-user attacker process could NOT also read —
`jr` has no secret-storage primitive more protected than DPAPI available to it (no HSM, no
TPM-backed key, no user-entered passphrase in this design), so any entropy `jr` could derive and
store (a sibling file, a registry value, a hardcoded constant compiled into the binary) is itself
readable by the exact same same-user process the entropy would be defending against — adding it
would be security theater, not real hardening. This is consistent with the precedent survey
already cited in Context (`git-credential-manager`'s `dpapi` store, `azure-cli`'s MSAL encrypted
file cache), neither of which is evidenced to rely on non-trivial entropy beyond DPAPI's own
user-scope binding. Revisit only if a future design introduces a genuinely separate secret (e.g.
a user-entered passphrase) to derive entropy from.

**Decision: `dwFlags = CRYPTPROTECT_UI_FORBIDDEN` (0x1), not `0` (Pass-5 adversarial review,
Finding #3).** The original §3 code comment specified no `dwFlags` value beyond implying `0`
(equivalent to "no flags," including no `CRYPTPROTECT_LOCAL_MACHINE`), and a downstream VP
(VP-AUTHDX-010(a)) accordingly pinned the literal constant `dwFlags == 0`. Passing bare `0` omits
`CRYPTPROTECT_UI_FORBIDDEN`, the standard flag for a non-interactive/headless/service context —
without it, `CryptProtectData`/`CryptUnprotectData` are free to raise an OS-level UI prompt (e.g.
a credential/master-key-recovery dialog) if the user's DPAPI master key needs recovery, which would
HANG rather than merely inconvenience a headless CI runner or an unattended service invocation of
`jr` — a real, not hypothetical, target per EC-1.4.035-3 and the F4 headless-validation spike
(architecture-delta.md §9 item 3). Setting `CRYPTPROTECT_UI_FORBIDDEN` costs nothing on an
interactive desktop session (the flag only suppresses a prompt that would otherwise appear; it
does not change whether the operation can succeed for a normal, non-corrupted user profile) and
closes an unforced headless-hang risk at zero downside. This is additive to, not a loosening of,
the existing user-scope decision: `CRYPTPROTECT_LOCAL_MACHINE` (0x4) is still never set, in either
direction.

**Consequence for the pinned security invariant: loosen `dwFlags == 0` to "the `LOCAL_MACHINE` bit
is clear," not "the whole word is zero."** `dwFlags == 0` as a literal pin now over-specifies the
property that actually matters and would need updating (and could silently drift back to a stale
`== 0` pin) every time a future, legitimate flag is added for a different reason (e.g. a
`CRYPTPROTECT_AUDIT` addition down the line). The security-relevant invariant — the one this
codebase actually needs to never regress — is narrower and more durable: `dwFlags &
CRYPTPROTECT_LOCAL_MACHINE == 0` (bit 2 / `0x4` clear), i.e. "never machine-scope." See the
companion `architecture-delta.md`'s "Pass-5 architect guidance for formal-verifier" section for the
required VP-AUTHDX-010(a) wording change.

**ACL / permission expectations for `secrets/<profile>/oauth-tokens.dat`.** This ADR does NOT add
new ACL-setting code (e.g. `SetNamedSecurityInfo`) — that would add a second `unsafe` FFI surface
beyond the two functions §5 already scopes and justifies, for a boundary DPAPI already enforces
at the decrypt layer regardless of file permissions. The expectation is: `secrets/` inherits its
parent directory's NTFS ACL via ordinary `create_dir_all` (no explicit ACL call), which on a
standard Windows profile restricts `%LOCALAPPDATA%` to the owning user account plus
SYSTEM/Administrators — the same inheritance `jr`'s existing `cache_root()` already relies on for
`%LOCALAPPDATA%\jr`'s other subtrees. **F4 must verify** (a Windows-only manual check, not new
production code) that this inheritance actually holds for a freshly created `secrets/`
subdirectory on a real Windows install: an inheritance gap here would let a DIFFERENT
same-user-but-different-logon-context reader (e.g. a scheduled task running as the same account
under a different token) read the ciphertext file — though DPAPI would still refuse to decrypt
it without that logon's matching master key, making this a defense-in-depth layer, not the
primary boundary. If that verification ever fails, adding explicit ACL restriction at creation
time is a tracked follow-up, out of this ADR's scope.

### 9. Profile-name path-traversal guard — host-independent recognizer (BC-1.4.040 / VP-AUTHDX-016)

**Pass-2 adversarial-review correction (2026-09-03, Finding #1).** `Profile::from(String)`
performs no validation (§9 item 1 of the companion `architecture-delta.md`, flagged as an
inherited risk) — `file_path(profile)` (§3) joins the raw profile string into a filesystem path
as a single component. The product-owner/formal-verifier's downstream BC-1.4.040 /
VP-AUTHDX-016 pass described the required guard only as "Windows-syntax-aware," which is
ambiguous in a way that matters: if implemented with `std::path::Path`/`Component` — the
obvious, idiomatic Rust tool — the check's behavior depends on the OS `cargo test` happens to run
on. `std::path::Path::new("C:\\evil")` on a **Linux** CI runner yields a SINGLE opaque
`Component::Normal("C:\\evil")` (backslash is not a Unix path separator), which is lexically
CONTAINED under `secrets/` and would be wrongly **ACCEPTED** — the exact opposite of the guard's
intent — for `"C:\\evil"`, `"\\\\server\\share"` (UNC), and `"name:$DATA"` (NTFS Alternate Data
Stream) alike. This would make VP-AUTHDX-016's "cross-platform, runs in default CI" claim false
as written: a Linux-CI-run test asserting these three inputs are rejected would pass against a
`std::path`-based implementation not because the guard works, but because the test never actually
exercises Windows path syntax on a runner that understands it.

**Decision: a dedicated, host-independent recognizer, not `std::path`.** New pure functions in
`src/api/auth_windows_store.rs` (same pure/impure seam as `envelope`/`should_fallback_to_dpapi`,
§3/§1 — this recognizer never touches the filesystem or the OS's own path parser):

```rust
/// Host-independent guard for a profile-derived path COMPONENT (never a
/// full path) about to be joined as `secrets/<profile>/oauth-tokens.dat`.
/// Deliberately does NOT use `std::path::Path`/`Component` — those parse
/// path syntax according to the COMPILATION/RUNTIME target's OS
/// conventions, so a check built on them behaves differently depending on
/// which OS it happens to run on (Pass-2 review Finding #1: a Linux CI
/// runner's `std::path` does not treat `\` as a separator or `:` as a
/// drive/stream marker, silently accepting Windows escape syntax). This
/// function instead implements its own minimal character-level scan,
/// evaluated IDENTICALLY regardless of host OS — its behavior, and its
/// test suite, never depend on which platform `cargo test` runs on, which
/// is what makes it genuinely testable in default CI on a Linux runner.
///
/// Containment is achieved by CONSTRUCTION, not by post-hoc
/// canonicalize-and-compare-prefix: every character or shape that could
/// ever be interpreted as a path separator, anchor, or escape on ANY
/// target OS is rejected outright, so any string that passes is
/// guaranteed to be a single, non-empty, non-dot, opaque path segment —
/// which can only ever resolve to a direct child of `secrets/`.
pub(crate) fn reject_unsafe_profile_component(
    profile: &str,
) -> Result<(), ProfilePathEscape> {
    use ProfilePathEscape::*;
    if profile.is_empty() {
        return Err(Empty);
    }
    if profile == "." || profile == ".." {
        return Err(DotSegment);
    }
    if profile.contains('\0') {
        return Err(NulByte);
    }
    // Reject BOTH separators on EVERY host, not just the host's own
    // convention. This alone rejects UNC (`\\server\share`,
    // `//server/share`) and any embedded traversal attempt identically on
    // Linux, macOS, and Windows CI.
    if profile.contains('/') || profile.contains('\\') {
        return Err(Separator);
    }
    // Drive letters ("C:") and NTFS Alternate Data Streams ("name:$DATA")
    // both use ':' — reject unconditionally rather than trying to
    // distinguish the two shapes; a profile name has no legitimate use
    // for a colon.
    if profile.contains(':') {
        return Err(Colon);
    }
    // A trailing '.' or space is silently stripped by the Windows shell
    // and several Win32 APIs, which could make a name that LOOKS distinct
    // from an existing one collide with it on disk.
    if profile.ends_with('.') || profile.ends_with(' ') {
        return Err(TrailingDotOrSpace);
    }
    if is_reserved_windows_device_name(profile) {
        return Err(ReservedDeviceName);
    }
    Ok(())
}

/// Case-insensitive match against the Windows reserved device-name list,
/// evaluated against the profile's STEM (the part before the first '.',
/// if any) — `NUL.txt` is exactly as reserved as bare `NUL` on real
/// Windows, since the device name resolves before extension handling.
/// Includes the console pseudo-handle names `CONIN$`/`CONOUT$` alongside
/// the classic DOS device names — both are reserved, real Win32 device
/// names (the active console's input/output buffer), not merely a
/// stylistic variant of `CON` (Pass-2 adversarial review, Finding #4).
///
/// **Pass-4 adversarial-review correction (2026-09-03, Finding #3).** Two
/// additions, both required to match Microsoft's own "Naming Files,
/// Paths, and Namespaces" reserved-name documentation exactly: (1) the
/// stem is computed against a LEADING-space-trimmed copy of the profile
/// string, so `" CON"` (and `" CON.txt"`) is recognized as reserved
/// exactly like bare `"CON"` — a leading space alone is not otherwise
/// rejected by `reject_unsafe_profile_component` (unlike a TRAILING
/// dot/space, which is a different hazard — Windows silently strips it —
/// and remains rejected outright there, not here); (2) the Unicode
/// superscript-digit device names `COM¹`/`COM²`/`COM³`
/// (U+00B9/U+00B2/U+00B3) and `LPT¹`/`LPT²`/`LPT³` are added to the match
/// set — Microsoft documents these as reserved alongside the ASCII-digit
/// forms. The superscript characters have no ASCII case, so
/// `to_ascii_uppercase` leaves them unchanged; only the `COM`/`LPT`
/// prefix's casing is folded, which is sufficient for an exact match.
/// Final authoritative set: **30 names** (6 + 9 + 9 + 6) — see the
/// companion `architecture-delta.md`'s Pass-4 guidance section for the
/// full enumeration and the required BC-1.4.040/VP-AUTHDX-016 wording.
///
/// **Scope decision (Pass-5 adversarial review, Finding #4) — only ASCII
/// space is trimmed; other whitespace is deliberately NOT normalized, and
/// this has now been verified, not merely assumed.** Only a LEADING ASCII
/// space (`trim_start_matches(' ')`, above) and a TRAILING ASCII space (via
/// `reject_unsafe_profile_component`'s separate `ends_with(' ')` check) are
/// treated as significant-but-disregardable. Whether Windows device-name
/// resolution also disregards a leading tab (`\t`), vertical tab (`\x0B`),
/// or form feed (`\x0C`) — which would let `"\tCON"` evade this stem match
/// the same way `" CON"` is caught — was researched during this pass
/// (Perplexity, cross-checked against Microsoft's `RtlIsDosDeviceName_U`
/// documentation, 2026-09-03): **REFUTE.** Microsoft documents the
/// recognized device-name forms (`CON`/`PRN`/`AUX`/`NUL`/`COMn`/`LPTn`/
/// `CONIN$`/`CONOUT$`, plus an optional trailing colon) without describing
/// any general Unicode-whitespace-trimming behavior in the recognizer —
/// only the ASCII-space case has documented/observed special handling.
/// `"\tCON"`, `"\x0BCON"`, and `"\x0CCON"` are therefore NOT expected to
/// resolve as the reserved `CON` device on real Windows, and no equivalent
/// trim is added here for them. This is a verified sufficiency claim, not
/// merely a documented limitation: extending the trim set to non-space
/// whitespace would each be adding a normalization Windows itself does not
/// perform, which would make this recognizer OVER-reject relative to actual
/// Windows behavior (rejecting `"\tmy-profile"` as if it collided with a
/// device name it does not, in fact, collide with) — a correctness bug in
/// the other direction, not a hardening. Profile names are also
/// operator-controlled local configuration (Invariant 2 of this ADR's
/// broader trust model, not a value ever accepted from an untrusted remote
/// party), which further lowers the value of over-fitting this guard to
/// characters Windows itself does not treat specially here. If Microsoft
/// ever documents additional whitespace-equivalence behavior for DOS device
/// name resolution, this scope note — and the trim set — should be revisited
/// against that documentation, not against speculation.
fn is_reserved_windows_device_name(profile: &str) -> bool {
    let trimmed = profile.trim_start_matches(' ');
    let stem = trimmed.split('.').next().unwrap_or(trimmed);
    matches!(
        stem.to_ascii_uppercase().as_str(),
        "CON" | "PRN" | "AUX" | "NUL" | "CONIN$" | "CONOUT$"
            | "COM1" | "COM2" | "COM3" | "COM4" | "COM5" | "COM6" | "COM7" | "COM8" | "COM9"
            | "LPT1" | "LPT2" | "LPT3" | "LPT4" | "LPT5" | "LPT6" | "LPT7" | "LPT8" | "LPT9"
            | "COM\u{b9}" | "COM\u{b2}" | "COM\u{b3}" | "LPT\u{b9}" | "LPT\u{b2}" | "LPT\u{b3}"
    )
}

/// Marker error for a rejected profile-derived path component. Carries no
/// string payload deliberately — the variant name alone is the stable,
/// non-string-matched signal a caller/CLI layer maps to
/// `JrError::UserError` (exit 64), mirroring `DpapiFallbackFailed`'s
/// type-based (never string-matched) discrimination convention.
pub(crate) enum ProfilePathEscape {
    Empty,
    DotSegment,
    NulByte,
    Separator,
    Colon,
    TrailingDotOrSpace,
    ReservedDeviceName,
}
```

**Call-site contract — one implementation, three entry points.** `file_path(profile)` (§3) is the
SOLE call site of `reject_unsafe_profile_component`, and is itself changed from returning a bare
`PathBuf` to `Result<PathBuf, ProfilePathEscape>`:

```rust
fn file_path(profile: &Profile) -> Result<std::path::PathBuf, ProfilePathEscape> {
    reject_unsafe_profile_component(profile.as_ref())?;
    Ok(crate::cache::cache_root().join("secrets").join(profile.as_ref()).join("oauth-tokens.dat"))
}
```

`store_pair`, `load_pair`, and `remove_if_present` each call `file_path(profile)?` as their FIRST
statement, before any directory creation, read, or write — this is what makes the guard fire "at
all three store entry points" (VP-AUTHDX-016) from a single implementation rather than three
independently-drifting checks. A rejected profile therefore never reaches a filesystem call; the
`ProfilePathEscape` error propagates up through `store_oauth_tokens`/`load_oauth_tokens`/
`clear_profile_*` exactly like any other `anyhow`-wrapped error from this module, and the CLI
layer maps it to `JrError::UserError` (exit 64) via the same downcast convention as
`DpapiFallbackFailed` — a new, explicit downcast branch is required at whichever call site first
surfaces this error to the user (F4 scope; not re-derived here).

**Pass-4 adversarial-review correction (2026-09-03, Finding #2) — the guard call is REQUIRED
on the non-Windows arm too, even though the resulting path is unused there.** The paragraph
above is easy to satisfy only on the `#[cfg(windows)]` arm, where `file_path`'s returned
`PathBuf` is genuinely needed for the real file I/O that follows. An implementer reaching for
the natural shortcut on `#[cfg(not(windows))]` — where the path is never used — could write,
e.g., `#[cfg(not(windows))] pub fn load_pair(_: &Profile) -> anyhow::Result<Option<(String,
String)>> { Ok(None) }` without calling `file_path`/the guard at all. That compiles cleanly,
passes every existing test, and silently exempts non-Windows builds from BC-1.4.040's
guarantee — which is exactly the gap Finding #2 identifies: the guarantee is untestable in
default (Linux/macOS) CI if the non-Windows arm never reaches the guard. The fix makes the call
MANDATORY and identical in shape on both cfg arms of all three functions; the returned
`PathBuf` is simply discarded on the arms that don't need it:

```rust
#[cfg(windows)]
pub fn store_pair(profile: &Profile, access: &str, refresh: &str) -> anyhow::Result<()> {
    let path = file_path(profile)?; // guard runs first; `?` propagates ProfilePathEscape
    /* … real DPAPI-protect/wrap/temp-write/rename against `path` … */
}

#[cfg(not(windows))]
pub fn store_pair(profile: &Profile, _access: &str, _refresh: &str) -> anyhow::Result<()> {
    file_path(profile)?; // guard-only call; the returned path is never used here
    Err(DpapiFallbackFailed("DPAPI is not available on this platform".into()).into())
}

#[cfg(windows)]
pub fn load_pair(profile: &Profile) -> anyhow::Result<Option<(String, String)>> {
    let path = file_path(profile)?;
    /* … real file read + DPAPI unprotect against `path` … */
}

#[cfg(not(windows))]
pub fn load_pair(profile: &Profile) -> anyhow::Result<Option<(String, String)>> {
    file_path(profile)?; // guard-only call; the returned path is never used here
    Ok(None)
}

#[cfg(windows)]
pub fn remove_if_present(profile: &Profile) -> anyhow::Result<()> {
    let path = file_path(profile)?;
    /* … real NotFound-tolerant delete of `path` … */
}

#[cfg(not(windows))]
pub fn remove_if_present(profile: &Profile) -> anyhow::Result<()> {
    file_path(profile)?; // guard-only call; the returned path is never used here
    Ok(())
}
```

This makes the guard-INVOCATION WIRING itself — not merely `reject_unsafe_profile_component`'s
own correctness — provable on a default Linux/macOS CI runner: a test that calls `store_pair`/
`load_pair`/`remove_if_present` directly with a profile name the guard rejects, and asserts
`Err` downcastable to `ProfilePathEscape` on every platform the test happens to run on, now
catches a regression that drops the call from ANY of the six arms above — including a
Windows-only regression, since the non-Windows arm's independent call is unaffected by a bug in
the Windows arm and vice versa; each of the six call sites is its own, independently
regression-catchable assertion. See the companion `architecture-delta.md`'s "Pass-4 architect
guidance for product-owner and formal-verifier" section for the required BC-1.4.040/
VP-AUTHDX-016 wording.

**Scope note.** This guard governs ONLY the new `auth_windows_store.rs` secrets path — it does
NOT retrofit `src/cache.rs::cache_dir(profile)`'s existing, unguarded profile-to-path join (the
inherited risk `architecture-delta.md` §9 item 1 already flags as out of this cycle's scope for
the lower-sensitivity, disposable cache namespace). Extending this same recognizer to
`cache_dir` is a plausible future hardening pass but is not required for BC-1.4.040/VP-AUTHDX-016
and is not specified here.

**BC-1.4.035 Invariant 3 scope clarification (Pass-5 adversarial review, Finding #2).** Because
Pass-4 (Finding #2, above) made `file_path(profile)?` — hence `reject_unsafe_profile_component` —
a mandatory first statement on BOTH cfg arms of `store_pair`/`load_pair`/`remove_if_present`, a
profile name that fails the guard is now REJECTED on macOS/Linux too, where previously (both
before this cycle, and even in this cycle's design prior to the Pass-4 fix) no such rejection
existed — `Profile::from(String)` performs no validation (ADR-0011) and nothing in the pre-cycle
codebase ever joined a profile name into a filesystem path this way on non-Windows. Read literally,
"macOS/Linux byte-for-byte unchanged" (Invariant 3) could be misread as forbidding this new
rejection. **It does not.** Invariant 3 governs one specific thing: the DPAPI-fallback ENGAGEMENT
decision (`engage_dpapi_fallback`/`should_fallback_to_dpapi`'s `TooLong`-routing behavior, §1/§2) —
it says a non-Windows build's *credential-storage backend selection* is unaffected by this cycle's
change. It says nothing about, and does not extend to, the profile-name VALIDATION guard (§9/
BC-1.4.040), which is deliberately new, deliberately cross-platform, security hardening — Pass-2's
Finding #1 and Pass-4's Finding #2 both required it to behave IDENTICALLY on every OS specifically
so its test suite would not depend on which OS `cargo test` happens to run on. A malformed or
hostile profile name (a path separator, a drive-letter colon, a reserved device name) being
rejected consistently on macOS/Linux exactly as it is on Windows is the INTENDED, in-scope outcome
of BC-1.4.040 — not a regression Invariant 3 forbids. The product-owner's BC-1.4.035 Invariant 3
wording should say this explicitly (e.g. "…unchanged, EXCLUDING the profile-name path-traversal
guard of BC-1.4.040, which is new, cross-platform behavior by design and applies identically on
every OS") so a future reader — or a future adversarial pass — does not mistake the two invariants
for being in tension. See the companion `architecture-delta.md`'s "Pass-5 architect guidance for
product-owner" section for the exact wording instruction.

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
- **Gating DPAPI engagement itself to `#[cfg(windows)]` (§1/§2)**, rather than relying on a
  non-Windows backend simply never producing `TooLong` in practice, converts BC-1.4.035
  Invariant 3 from a probabilistic property into a compile-time-structural one — the strongest
  form of "byte-for-byte unchanged" available without forking `store_oauth_tokens` into two
  separate functions per platform.
- **No `pOptionalEntropy` and no new ACL-setting code (§8)** keep the DPAPI fallback's `unsafe`
  surface exactly as narrow as §5 already commits to, on the reasoning that neither addition
  would move the actual trust boundary (same-user), only add code that looks more secure without
  being so.
- **A dedicated, host-independent recognizer for the profile-name path guard (§9), never
  `std::path`**, is the only design that makes the guard's own correctness — and its test
  suite — independent of which OS `cargo test` happens to run on, which is a hard requirement for
  a guard whose entire job is recognizing a DIFFERENT OS's path syntax (Windows) than the one it
  may be compiled/run on.
- **Type-based error discrimination on the read path (§3/§4, `CorruptSecretFile`)** extends the
  same convention `DpapiFallbackFailed` already established for the write path, rather than
  introducing a second, inconsistent (string-matched) mechanism for an analogous problem.

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
- BC-1.4.035 Invariant 3 (macOS/Linux unchanged) is now enforceable as a call-site compile/
  runtime gate (§1/§2), not merely an observation about current `keyring` behavior.
- BC-1.4.040's path-traversal guard is now concretely, host-independently specified (§9) — its
  Windows-syntax vectors are genuinely exercisable, and genuinely closed, by an ordinary
  `cargo test` run on Linux/macOS CI, not merely a check that happens to look right when read.
- BC-1.4.036's read-path error handling can now actually express the corrupt-vs-backend-IO
  discrimination the BC mandates (§3's `CorruptSecretFile` marker), rather than requiring an
  ad-hoc string-matched workaround this codebase's conventions forbid.
- **BC-1.4.035 Invariant 1 is now closed against the stale-keyring-shadows-DPAPI defect
  (Finding #1, Pass-3 review):** the DPAPI-fallback write route (§2) deletes any pre-existing
  keyring pair for the profile BEFORE routing to DPAPI, in the crash-safe order — a mid-crash
  outcome is "no credentials, forces clean re-login," never "a stale, complete keyring pair
  permanently shadows a fresh, complete DPAPI pair."

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
- The DPAPI file's confidentiality rests entirely on the OS-level same-user trust boundary
  (§8) — no additional entropy, no application-level ACL hardening beyond directory inheritance.
  This mirrors the already-accepted `SEC-WCM-DOC` posture for Credential Manager and is not a
  weaker guarantee than today's keyring-only storage, but it is a NEW on-disk artifact carrying
  that same exposure, now documented rather than implicit.
- Durability is only guaranteed against process-kill unless the temp-write is `fsync`'d before
  rename (§3, Finding #17); without an explicit temp-file cleanup step, a crash mid-write can
  accumulate orphaned `*.tmp-*` ciphertext files (bounded to one per profile by the required
  pre-write cleanup).

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
- Pass-1 adversarial review (cycle-004 F2, 2026-09-03) — Findings #5, #11, #13, #17 incorporated
  above: the `#[cfg(windows)]`-gated `engage_dpapi_fallback` call-site wrapper (§1/§2), the
  security-posture/entropy/ACL documentation (§8), the outer/inner version-field relationship
  (§3), and the fsync/temp-file-cleanup durability expectations (§3).
- Pass-2 adversarial review (cycle-004 F2, 2026-09-03) — Findings #1, #2, #6 incorporated above:
  the host-independent `reject_unsafe_profile_component` path-traversal recognizer for
  BC-1.4.040/VP-AUTHDX-016 (new §9), the `CorruptSecretFile` typed read-path error marker for
  BC-1.4.036 (§3/§4), and the age-gated (not blanket) `*.tmp-*` cleanup with its stated
  cross-process concurrency boundary (§3). See the companion `architecture-delta.md`'s "Pass-2
  architect guidance for product-owner and formal-verifier" section for the resulting
  BC-1.4.040/VP-AUTHDX-016 wording instruction.
- Pass-3 adversarial review (cycle-004 F2, 2026-09-03) — Finding #1 (STALE-KEYRING-SHADOWS-DPAPI)
  incorporated above: §2's DPAPI-fallback write route now deletes any pre-existing keyring pair
  BEFORE the DPAPI store (delete-then-store, not store-then-delete — the crash-safe ordering,
  reasoned explicitly in §2's new "Ordering, and why" note), and BC-1.4.035 Invariant 1 is
  extended to forbid a stale, complete keyring pair coexisting with a fresh, complete DPAPI pair.
  See the companion `architecture-delta.md`'s "Pass-3 architect guidance for product-owner and
  formal-verifier" section for the required BC-1.4.035 wording and the new VP-AUTHDX coverage.
- Pass-4 adversarial review (cycle-004 F2, 2026-09-03) — Findings #2, #3 incorporated above:
  `file_path(profile)?` (hence `reject_unsafe_profile_component`) is now a MANDATORY first
  statement on BOTH cfg arms of `store_pair`/`load_pair`/`remove_if_present` (§3/§9), making the
  guard's wiring — not just its own correctness — regression-catchable on default Linux/macOS
  CI; and `is_reserved_windows_device_name` (§9) is extended with the Unicode superscript-digit
  `COM¹`/`COM²`/`COM³`/`LPT¹`/`LPT²`/`LPT³` device names and leading-space-trimmed stem matching,
  bringing the authoritative reserved-name set to 30. See the companion `architecture-delta.md`'s
  "Pass-4 architect guidance for product-owner and formal-verifier" section for the required
  BC-1.4.040/VP-AUTHDX-016 wording.
- Pass-5 adversarial review (cycle-004 F2, 2026-09-03) — Findings #1, #2, #3, #4 incorporated
  above: (#1, HIGH) a `#[cfg(debug_assertions)]`-gated `JR_FORCE_DPAPI_FALLBACK` test-only seam
  (§1) resolves the testability contradiction between Pass-1's production call-site gate and
  VP-AUTHDX-011/012/022's default-CI claims, with the seam's honest boundary (delete-then-fail
  shape only; the success shape stays Windows-only) stated explicitly; (#2, MED) `ProfilePathEscape`
  is now checked FIRST, before `CorruptSecretFile`/`DpapiFallbackFailed`, at both the read path
  (§4) and the store-error sites (§6, Sites 1/3), and BC-1.4.035 Invariant 3's scope is clarified
  (§9) to exclude the intentional, new, cross-platform profile-name guard rejection; (#3, LOW)
  `dpapi::protect`/`unprotect`'s `dwFlags` now includes `CRYPTPROTECT_UI_FORBIDDEN` (0x1) to avoid
  a headless-hang risk, and the pinned security invariant is loosened from `dwFlags == 0` to
  "`CRYPTPROTECT_LOCAL_MACHINE` bit clear" (§8); (#4, LOW) research (Perplexity, cross-checked
  against Microsoft's `RtlIsDosDeviceName_U` documentation) REFUTES that non-ASCII-space
  whitespace (tab/vertical-tab/form-feed) is disregarded in Windows device-name resolution the way
  a leading ASCII space is — `is_reserved_windows_device_name` (§9) is confirmed sufficient as
  specified, with the verification recorded as a scope note rather than left as an open question.
  See the companion `architecture-delta.md`'s "Pass-5 architect guidance for product-owner and
  formal-verifier" section for the required BC/VP wording and CI-classification corrections.
- Pass-6 adversarial review (cycle-004 F2, 2026-09-03) — Finding #3 (MED, process-gap) incorporated
  above: §1's "Doc-fallout note for F4" is expanded from a single CLAUDE.md-entry reminder into a
  three-part mandatory checklist matching this codebase's full `JR_*` debug-only-seam convention —
  (a) a dedicated `tests/jr_force_dpapi_fallback_release_gate.rs` pin (modeled on the sibling
  `tests/jr_test_block_until_sigint_release_gate.rs`/`tests/config_dir_release_gate.rs` pattern)
  asserting `#[cfg(debug_assertions)]` sits within 5 source lines of the env-var read in
  `src/api/auth.rs`, (b) the CLAUDE.md seam-table entry (already required pre-Pass-6, retained),
  and (c) an explicit release-vs-debug scope statement in both places. Also flagged, for the
  formal-verifier to spec into the VPs (not resolved in this ADR): the two opposing-outcome
  non-Windows tests keyed on this process-global env var (the legacy-message test with the var
  UNSET, and the VP-AUTHDX-011/012/022 delete-then-fail tests with it SET) require `env_lock`-style
  mutex serialization, exactly as CLAUDE.md documents for `JR_SERVICE_NAME` in
  `tests/oauth_refresh_integration.rs`. See the companion `architecture-delta.md`'s "Pass-6
  architect guidance for formal-verifier" section.
</content>
