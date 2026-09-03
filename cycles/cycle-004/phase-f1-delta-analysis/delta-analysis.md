---
document_type: delta-analysis-report
feature_name: "windows-correctness (cycle-004)"
created: 2026-09-03
spec_version_at_analysis: "BC-INDEX v6.84 (733 BCs total); bc-1-auth-identity.md 71 cumulative/60 individually-bodied; bc-6-config-cache.md 44 cumulative/34 individually-bodied"
status: draft
intent: "bundle — #759: bug-fix; #760: docs/enhancement"
feature_type: backend (infrastructure; no UI)
scope: standard
severity: "#759: HIGH (see §4); #760: N/A (not a bug)"
producer: architect
inputs:
  - ".factory/research/win-oauth-keychain-blob-limit-2026-09-03.md"
  - "src/api/auth.rs"
  - "src/api/refresh_coordinator.rs"
  - "src/cli/auth/login.rs"
  - "src/cli/auth/refresh.rs"
  - "src/cli/auth/logout.rs"
  - "src/cli/auth/remove.rs"
  - "src/cli/auth/status.rs"
  - "src/config.rs"
  - "src/cache.rs"
  - "src/api/client.rs"
  - "Cargo.toml"
  - "Cargo.lock"
  - "deny.toml"
  - "README.md"
  - "CLAUDE.md"
  - ".factory/STATE.md"
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - ".factory/specs/prd/bc-6-config-cache.md"
  - ".factory/specs/prd/BC-INDEX.md"
traces_to: ".factory/STATE.md#DEC-334"
input-hash: "582b22f"
---

# F1 Delta Analysis: windows-correctness (cycle-004)

## 0. Bundle Summary

Feature Mode cycle bundling two GitHub issues discovered on the same Windows 11 install of
`jr` v0.6.0, both filed by the same reporter within the same session:

- **#759 — bug** — `jr auth login --oauth` (and `jr init` → OAuth) can never succeed on
  Windows. `store_oauth_tokens` (`src/api/auth.rs:268`) writes the OAuth access token straight
  to `keyring::Entry::set_password`, which on the `windows-native` backend maps to
  `CredWriteW` with a hard `CRED_MAX_CREDENTIAL_BLOB_SIZE` = 2560-byte (~1280-UTF-16-char)
  ceiling. Atlassian's access token (scaled by the 8 default scopes, and per the research
  doc, refresh tokens can be far larger and unbounded) routinely exceeds this, so the very
  first `set_password` call fails deterministically, post-consent. The surfaced error text
  additionally misattributes the failure to a locked keychain and tells the user to
  re-run — which fails identically every time — while leaving a live, unusable Atlassian
  grant behind.
- **#760 — docs** — Two README defects found on the same install: (1) stale Windows install
  guidance (tells users a Windows asset is still only "planned" and to use
  `prerelease = true`, when v0.6.0 already ships a stable `x86_64-pc-windows-msvc.zip`; no
  direct Windows download/`Unblock-File` steps exist at all) and (2) the documented config
  path (`~/.config/jr/config.toml`) is Unix-only — Windows actually resolves to
  `%APPDATA%\jr\config.toml` — with a silent failure mode (`jr` reports "No profiles
  configured" instead of a path hint). A minor third observation: `cloud_id` is documented as
  "auto-discovered", true only for the OAuth flow; the API-token flow leaves it unset, which
  matters more because #759 forces Windows users onto the API-token workaround.

**Locked strategy (DEC-334, human-decided — not re-litigated here):**
- **#759:** keyring-first with a **user-scope DPAPI-encrypted file fallback** under
  `%LOCALAPPDATA%` for oversized OAuth secrets (both access *and* refresh, written
  atomically as a pair), plus an **honest-fail backstop**: match `keyring::Error::TooLong(_,
  _)` specifically, replace every misdirecting "Unlock your keychain" message on the
  write-failure paths with an accurate one, and make the dangling server-side grant revoke
  an explicit remediation step rather than an aside. Chunking across Credential Manager
  entries and scope-trimming were evaluated by research and REJECTED (no precedent, moves
  the cliff rather than removing it, transaction-less).
- **#760:** README gets direct Windows install steps + an `Unblock-File` (mark-of-the-web)
  note, a per-platform config/cache path table, and a `cloud_id` auto-discovery caveat scoped
  to the OAuth flow only.

---

## 1. Intent Classification

| Issue | Signal | Intent | Route |
|-------|--------|--------|-------|
| #759 | "bug", deterministic reproducible failure, root cause identified in the report itself, "Expected result" section names the defect | `bug-fix` | Standard bug-fix route (F1→F2→F3→F4→F5→F6→F7 — see §13; NOT the skip-F2/F3 simple-bug-fix shortcut, and NOT the CRITICAL expedited flow) |
| #760 | "docs(windows):" title, "Suggested fix" sections, offers to open a PR for README changes only | `enhancement` (docs) | Near-trivial, folds into the same cycle's F2 spec-evolution as a documentation-only delta; independently would qualify for quick-dev but is bundled with #759's non-trivial work under DEC-334 |

Bundle-level intent for STATE.md/routing purposes: **mixed bug-fix + docs**, driven by #759's
severity and non-trivial scope (below).

---

## 2. Trivial-Scope Assessment

**#759 — NON-TRIVIAL.** Fails every trivial-scope criterion:
- Impact boundary is NOT a single module/file: it touches a new storage backend module, a
  security-critical existing module (`src/api/auth.rs`), a size-threshold router, and every
  caller that reads/writes/clears OAuth tokens (§5).
- New BCs are required (a size-safe storage contract does not exist today — see §7).
- No architecture *restructuring* (the profile/keychain layering is unchanged), but a **new
  architectural component** is introduced (a DPAPI-encrypted-file secret store) — itself
  enough to disqualify "no architecture change".
- New external dependency likely required (DPAPI FFI surface — §6), pending verification.
- Regression risk is HIGH on the core module (§10), not LOW.

**#760 — NEAR-TRIVIAL.** Single file (`README.md`), no BCs strictly required (documentation
corrections to already-existing, already-shipped behavior), no architecture change, no new
dependency, LOW regression risk (prose only, no `src/` change). In isolation this would
qualify for quick-dev routing. It does not travel alone here because it is bundled with #759
under the same `windows-correctness` cycle (DEC-334) and because its "cloud_id caveat" note
depends on a scope decision that also touches #759's territory (§12).

**Bundle verdict: standard route, NOT quick-dev.** #759's non-trivial classification governs
the bundle; #760 rides through F2 as a documentation-only delta scoped inside the same cycle
rather than a separate quick-dev PR, per DEC-334's framing of this as one Feature Mode cycle.

---

## 3. Severity (#759)

| Criterion | Assessment |
|-----------|------------|
| CRITICAL (production down / data loss / security breach) | **NO.** No data is lost — the OAuth authorization attempt fails cleanly with nothing persisted (`cmdkey /list` shows no `jr` entries per the report); no security boundary is crossed; nothing is corrupted. A dangling *server-side* grant is left at Atlassian, which is a cleanup/hygiene issue, not a breach. |
| HIGH (major functionality broken, no workaround) | **Functionality: YES, major** — OAuth 2.0, the recommended default auth mechanism as of cycle-003 (DEC-313, `auth-profile-dx`), is **100% broken on Windows** — not degraded, not intermittent, deterministic on every attempt with the default scope set. **Workaround: YES, EXISTS** — the API-token flow works (reporter verified `jr me`, `jr project list`, `jr issue list/view/comments/changelog/transitions`, `jr queue list`, `jr requesttype list`, `--jql`, `--output json` all functional via API token). |
| MEDIUM (functionality impaired, workaround exists) | Partially matches on the "workaround exists" clause alone, but understates the impact: this is not a degraded feature, it is the **default** recommended mechanism failing 100% of the time on an entire supported platform (Windows is a first-class release target per ADR-0016). |
| LOW (minor/cosmetic/edge case) | Does not apply — this is neither cosmetic nor an edge case; it fires on the very first OAuth attempt for every Windows user with the default scope set. |

**Classification: HIGH**, not CRITICAL, on the strength of the workaround — but flagged as
**HIGH-with-elevated-urgency** for two reasons specific to this codebase's recent history:
1. **Cycle-003 (`auth-profile-dx`, DEC-313, released as v0.7.0-dev.4 @ `42e92b46`, the exact
   commit this cycle starts from) made OAuth the *default* auth mechanism at profile
   creation.** Before that change, a Windows user choosing API-token by habit would never hit
   this bug; after it, the *default* path for a brand-new Windows user now dead-ends unless
   they know to override at the `jr init`/`jr auth login` picker. This is a regression in
   practical severity introduced by an unrelated, already-shipped feature, not by this
   bug itself — but it means the bug's blast radius grew the day cycle-003 released.
2. The workaround is a real capability *reduction*, not merely a different path: JSM
   `write:servicedesk-request`-scoped operations and CMDB/Assets access depend on scopes an
   API token (especially a classic, unscoped one) does not carry identically, and the
   reporter's own environment observation (#760's cross-reference) shows the API-token path
   additionally drops `cloud_id`, breaking Assets/CMDB entirely as a second-order effect.

**Expedited-flow recommendation: DO NOT apply.** The CRITICAL-only expedited flow (skip demo
baseline, minimal F1, async human approval, 1-round F5, security-scan-only F6) is reserved for
CRITICAL severity; this is HIGH. This bug also **requires real spec work** — a new storage
backend, a size-threshold router, and an atomic dual-secret write are new architecture, not a
one-line fix — which independently argues against any expedited/quick-dev shortcut regardless
of severity label. Standard F1→F7 applies (§13).

---

## 4. Root-Cause BC (Bug-Fix Requirement)

**Behavioral contract that SHOULD hold but doesn't:** *"OAuth 2.0 credentials, once a user
successfully authorizes with Atlassian, persist reliably on every officially supported
platform (macOS, Linux, Windows — ADR-0016), regardless of token size."* Today this holds
only on macOS (Keychain) and Linux (Secret Service), both of which have credential-size
ceilings far above what Atlassian ever emits; on Windows it is FALSE by construction —
Credential Manager's 2560-byte `CredentialBlobSize` ceiling is not survivable by any
currently-issued Atlassian access token under the default 8-scope set, and per the research
doc, refresh tokens are individually unbounded by Atlassian's own contract and are the
better-evidenced overflow risk going forward.

A secondary, narrower root-cause BC: *"A keychain-layer failure is reported accurately,
distinguishing an actionable retry (locked/permission-denied) from a non-retryable one
(structurally oversized secret)."* Today `store_oauth_tokens`'s only failure handling is a
blanket `map_err` that always says "Unlock your keychain" — this is true for zero of the
paths that can actually trigger it on Windows (`TooLong` is neither a lock nor a permission
error).

**Affected module for scoped holdout:** `src/api/auth.rs` — specifically the credential
persistence surface (`store_oauth_tokens`, `load_oauth_tokens`, `clear_profile_oauth_pair`,
`clear_profile_creds`, `clear_all_credentials`) plus the four write/read-failure message
sites enumerated in §5.1. Holdout scope should be this module plus its two direct dependents
that also touch OAuth persistence (`src/api/refresh_coordinator.rs`'s call path through
`refresh_oauth_token_with_url`, and `src/api/client.rs`'s read call sites) — not the full
product.

---

## 5. Impact Boundary

### 5.1 NEW components

| Component | Description |
|-----------|-------------|
| **Windows DPAPI-encrypted-file secret-store module** (new file, likely `src/api/auth_dpapi_store.rs` or a `windows_secret_store` submodule of `src/api/auth.rs`) | User-scope `CryptProtectData`/`CryptUnprotectData` (never `CRYPTPROTECT_LOCAL_MACHINE`) wrapping a versioned-envelope encrypted blob per profile, holding the OAuth access+refresh pair together. Location: under `cache_root()` (`src/cache.rs:87`, already resolves to `%LOCALAPPDATA%\jr` on Windows via `dirs::cache_dir()` and already honors the `JR_CACHE_DIR` debug-only test-isolation seam) — reusing this existing path-resolution seam rather than inventing a new one is the architecturally consistent choice and gives the new store the same test-isolation story for free. `#[cfg(windows)]`-gated; a stub/no-op (or simply "never selected") on macOS/Linux, where the size-threshold router (below) never routes to it. |
| **Size-threshold router** (new logic inside `src/api/auth.rs`, e.g. `store_oauth_tokens_sized`/an internal helper) | Decides, per secret, whether `keyring::Entry::set_password` is attempted first (small values keep using Credential Manager unchanged on all platforms) or the write falls through to the DPAPI file store. Per DEC-334 this is **keyring-first**: attempt the OS keychain, and only spill to the DPAPI file on a `keyring::Error::TooLong` — not a pre-flight length pre-check against a hardcoded byte budget (avoids duplicating/hardcoding `CRED_MAX_CREDENTIAL_BLOB_SIZE` outside the `keyring` crate's own validation). |
| **Atomic access+refresh pair write/rollback logic** | DEC-334 requires access AND refresh to be written atomically as a pair (temp-write + rename per the research doc's recommendation), addressing the pre-existing partial-write risk the research doc flags in the CURRENT code too (`store_oauth_tokens` writes access then refresh with no atomicity today — a partial-write is already possible, DPAPI or not). This is new logic regardless of backend; on the keyring path "atomic" means both `set_password` calls succeed or the caller sees a clearly-labeled partial state (today's partial-state messaging in `load_oauth_tokens` — lines 314-343 — already models the "partial pair" shape and should be the template for the new write-side atomicity contract). |

### 5.2 MODIFIED components

| Component | File : Symbol | Change |
|-----------|---------------|--------|
| `store_oauth_tokens` | `src/api/auth.rs:268` | Route through the new size-threshold router instead of two unconditional `set_password` calls; on `TooLong`, fall through to the DPAPI file store instead of propagating the raw keyring error. |
| `load_oauth_tokens` | `src/api/auth.rs:286` | Must additionally check the DPAPI file store (in profile/precedence order — e.g. namespaced-keyring pair, then DPAPI file, mirroring the existing legacy-fallback shape at lines 294-343) before concluding "no stored OAuth token". |
| `clear_profile_oauth_pair` | `src/api/auth.rs:589` | Must also delete the DPAPI file (if present) alongside the two keyring deletes, or a `logout`/mechanism-switch leaves an orphaned encrypted file behind. |
| `clear_profile_creds` | `src/api/auth.rs:672` | Same DPAPI-file cleanup addition, for `auth remove`'s stronger guarantee. |
| `clear_all_credentials` | `src/api/auth.rs:755` (test-only, per its own rustdoc — "zero production call sites... every remaining caller is `#[cfg(test)]`") | If kept test-only, its test fixtures/assertions still need a DPAPI-file-aware update so tests exercising this path don't silently miss the new storage backend; low priority relative to the four production sites above. |
| Error-message site 1 — `oauth_login`'s store-failure map_err | `src/api/auth.rs:~1138-1151` (the exact `.map_err` closure wrapping `store_oauth_tokens` inside `oauth_login`) | Currently unconditionally emits "Unlock your keychain (or grant access to jr) and run `jr auth login --oauth --profile {profile}` again. To fully revoke the active grant first, visit https://id.atlassian.com/manage-profile/apps." for EVERY error type. Must branch: DPAPI-fallback-write failure → new accurate message (mentioning the size limit did NOT apply because the DPAPI path itself failed — a different, rarer failure mode, e.g. disk full, DPAPI API failure); genuine lock/permission `keyring::Error` on the *small-secret* path → keep today's message (still correct there); a `TooLong` that somehow still surfaces (i.e., the DPAPI fallback path itself is unavailable/fails) → the honest-fail message from §5.1, making the revoke-grant instruction a **required step**, not an aside. |
| Error-message site 2 — `refresh_oauth_token_with_url`'s `load_oauth_tokens` read-failure branch | `src/api/auth.rs:~1229-1239` (`is_backend_keyring_error` branch) | Read-side, not write-side — `TooLong` cannot occur here (it's a pre-write validation), but this branch must become DPAPI-file-aware too: a genuine keyring backend error here must not be conflated with "the token actually lives in the DPAPI file and the keyring read is a red herring" — the read path itself needs the same precedence-aware lookup as `load_oauth_tokens` gets in general (§5.2 row 2), so this site's fix is really "call the corrected `load_oauth_tokens`", with its own message left mostly as-is (still an accurate diagnosis for a genuine locked-keychain read failure on the small-secret path). |
| Error-message site 3 — `refresh_oauth_token_with_url`'s post-refresh `store_oauth_tokens` map_err | `src/api/auth.rs:~1328-1341` | Same fix shape as site 1 (`oauth_login`'s store failure) — this is the refresh-rotation twin of the login-time write, and per the research doc refresh tokens are the *more likely* overflow case going forward (unbounded, no scope-count correlation), so this site is at least as important to fix as site 1, arguably more so since it fires on every subsequent token rotation, not just first login. |
| Error-message site 4 — `resolve_refresh_app_credentials`'s `try_load_oauth_app_credentials` error branch | `src/api/auth.rs:~1364-1371` | This is about the **BYO OAuth *app* credential pair** (`oauth_client_id`/`oauth_client_secret`), a different, always-small secret pair — genuinely a locked-keychain scenario, not a `TooLong` candidate. Recommend: leave this message as-is (it is accurate for what it actually guards), but audit it during F2/F4 to confirm no `TooLong` path is reachable here (client ids/secrets are short strings, so this should be a confirmation, not a change). |

### 5.3 DEPENDENT components (unchanged code, but behavior depends on the above)

| Component | File : Symbol | Why dependent |
|-----------|---------------|----------------|
| `refresh_with_single_flight` | `src/api/refresh_coordinator.rs:99` | Calls a `refresh_fn` closure that ultimately bottoms out in `refresh_oauth_token_with_url`'s `store_oauth_tokens` call (site 3 above) — its own logic (single-flight locking, cached-result short-circuit) is unaffected, but its error propagation surfaces whatever `store_oauth_tokens`/the router now returns. No code change expected here, but its test coverage is in the regression-risk zone (§10) because the underlying call it wraps is changing shape. |
| `login_oauth` CLI handler | `src/cli/auth/login.rs` (`oauth_login` caller) | Presents the browser flow and reports `OAuthResult`/errors to the user; must not need its own changes if `oauth_login`'s error message is fixed at the source, but its interactive/`--no-input` output-channel tests are regression-risk. |
| `refresh_credentials` CLI handler | `src/cli/auth/refresh.rs` (relogin-then-replace flow, DEC-321/BC-1.2.051) | Calls into the same storage functions; the "obtain-first, then unconditional overwrite" (relogin-then-replace) invariant this handler depends on must continue to hold once the storage layer gains a second backend — i.e., the new atomic-pair-write logic must preserve "never destroys the old credential until the new one's write has fully succeeded", which is the exact property `refresh_credentials` was redesigned around in cycle-003 (DEC-321, PR #762). |
| `handle_logout` / `handle_remove` | `src/cli/auth/logout.rs`, `src/cli/auth/remove.rs` | Depend on `clear_profile_oauth_pair`/`clear_profile_creds` correctly cleaning up whichever backend the credential actually landed in — no CLI-layer code change expected, but their existing tests assert on keyring-only state today and must be extended (not rewritten) to also assert DPAPI-file absence post-clear. |
| `status()` | `src/cli/auth/status.rs:145` (`auth::load_oauth_tokens(&target_profile).is_ok()`) | Presence check only — depends on `load_oauth_tokens` correctly reporting "present" for a DPAPI-file-backed token, or `auth status` will falsely report "not authenticated" for exactly the users this fix is meant to help. |
| `JiaClient::from_config` / `JiaClient::send` (401 reconcile path) | `src/api/client.rs:131, 816, 875` | Three call sites reading `load_oauth_tokens` for the auth header and for post-refresh reconciliation — all three must see a DPAPI-file-backed token identically to a keyring-backed one; no logic change expected here beyond the shared `load_oauth_tokens` fix propagating up. |

---

## 6. New-Dependency Assessment

**Correction to the research doc's assumption, verified against this repo's actual
`Cargo.lock` (not just "likely present"):**

- `Cargo.lock` shows **`keyring` 3.6.3 depends on `windows-sys` 0.60.2`, NOT the higher-level
  `windows` crate.** `windows-sys` is raw, unsafe `extern "system"` FFI bindings (no ergonomic
  `DATA_BLOB`/safe-wrapper types) — it is a strictly lower-level crate than the `windows`
  crate the research doc recommends as first choice. **The bare `windows` crate is absent
  from `Cargo.lock` entirely** (`grep -n '^name = "windows"$' Cargo.lock` returns nothing).
  `windows-core` 0.62.2 IS present, but transitively via `iana-time-zone` (a `chrono`
  dependency), not via `keyring` — a different, unrelated dependency chain.
- This means the research doc's ordering ("(1) `windows` crate — best-supported ... note `jr`
  may already pull `windows`/`windows-sys` transitively via keyring's `windows-native`") needs
  updating: **adding the `windows` crate is a genuinely NEW top-level dependency**, not a
  free ride on an existing transitive one. `windows-sys` (already present via `keyring`) COULD
  be used directly for the raw `CryptProtectData`/`CryptUnprotectData` calls plus manual
  `DATA_BLOB` struct construction, avoiding the new dependency entirely, at the cost of
  writing (and unit-testing) the unsafe FFI wrapper by hand instead of using the `windows`
  crate's safe surface.
- **cargo-deny / license implications:** `deny.toml` has `bans.multiple-versions = "deny"`.
  This repo already carries an *existing*, documented `[[bans.skip]]` block for
  `windows-sys` at version `0.60` (added for keyring's `windows-native` feature per
  `tests/keyring_windows_native_feature_present.rs`, S-WIN-3, AC-002) plus transitive
  `windows-targets`/`windows_*` arch-crate skips at `0.53`. Adding the `windows` crate
  (Microsoft-published, MIT/Apache-2.0 — both already allowed in `deny.toml`'s
  `[licenses].allow` list) would pull its own `windows-core`/`windows-targets`/`windows-link`
  version graph, likely at a *different* version than the ones `keyring`/`iana-time-zone`
  already pull (0.62.x territory is already present via `windows-core`, so there is a
  realistic chance of landing on a compatible/shared version — this must be verified with an
  actual `cargo add windows --features Win32_Security_Cryptography` dry run at F4, not
  assumed here) — any mismatch requires a new `[[bans.skip]]` entry with root-cause
  documentation, following this repo's existing convention (see the six `[[bans.skip]]`
  blocks already in `deny.toml` for the getrandom/r-efi/security-framework/serde_spanned
  splits). `windows-dpapi` (0.2.0, young/small per the research doc) would be a wholly new,
  lightly-audited dependency and is the weaker supply-chain choice either way.
- **MSRV (1.85):** whichever crate is chosen must be checked for MSRV compatibility at
  1.85.0 as part of F4 — the research doc did not verify this for `windows` 0.62.2 or
  `windows-dpapi` 0.2.0 specifically (only flagged the *already-present* `saphyr-parser`'s
  1.85.0 MSRV as a separate, unrelated CI-tooling concern in CLAUDE.md). Recommend the F2
  spec explicitly name this as an F4 verification task rather than assume it.
- **Recommendation for F2 to decide (not decided here):** prefer `windows-sys` (zero new
  dependency, more unsafe code to write and test) over adding the `windows` crate (ergonomic,
  but a new top-level dependency with an unverified `cargo deny` interaction) — the
  size/security-critical nature of this module argues for minimizing new supply-chain
  surface, but the `windows` crate's safety wrappers reduce the chance of an unsafe-FFI bug
  in a security-critical path. This is a real design tradeoff for the architect to resolve at
  F2, not a foregone conclusion.

---

## 7. Affected Artifacts

### 7.1 Existing BCs — MODIFIED (amend in place)

| BC | File | What changes |
|----|------|---------------|
| BC-1.4.031 (per-profile OAuth/API-token credential storage contract) | `bc-1-auth-identity.md` | Must gain a Windows-specific clause: "on Windows, a secret exceeding the Credential Manager blob limit is stored in a DPAPI-encrypted file under `%LOCALAPPDATA%\jr` instead of the OS keychain; the profile's credential-presence contract is backend-agnostic from the caller's perspective." |
| (the BC(s) documenting `store_oauth_tokens`/`load_oauth_tokens` behavior — likely within BC-1.4.02x/03x range; exact BC needs a text search at F2, not enumerated by number here to avoid guessing an ID that does not match the file's actual structure) | `bc-1-auth-identity.md` | Partial-write / atomicity contract needs updating: today's implicit "access then refresh, no atomicity" behavior becomes an explicit atomic-pair-write contract. |
| BC-6.1.014 / BC-6.2.016 (Windows config/cache path resolution, `%APPDATA%`/`%LOCALAPPDATA%`) | `bc-6-config-cache.md` | Should cross-reference the new DPAPI-file location (`%LOCALAPPDATA%\jr\...`) as a sibling artifact under the same cache root these BCs already govern — likely a cross-reference addition, not a behavioral rewrite, since `cache_root()` itself is unchanged. |

### 7.2 New BCs needed (BC-S.SS.NNN format; exact numbers allocated at F2 — bc-1-auth-identity.md's cumulative count is 71 as of BC-INDEX v6.84, so the next candidates are BC-1.4.035+ if grouped with the existing per-profile-credential-storage cluster, BC-1.4.031-034, or a new BC-1.7.xxx subsection if the architect decides Windows-specific storage warrants its own subsection):

1. Size-threshold routing contract: keyring-first, DPAPI-file fallback ONLY on
   `keyring::Error::TooLong`, never a pre-flight length guess.
2. Atomic access+refresh pair write (temp-write + rename, or equivalent) — a partial write
   must never leave the pair in an inconsistent state, and a failure must clearly report
   which half (if either) persisted.
3. DPAPI-file read path: versioned envelope, decryption-failure → treated as "force
   re-login" (not silently swallowed as "no token").
4. DPAPI-file cleanup: `clear_profile_oauth_pair`/`clear_profile_creds` must delete the file
   alongside the keyring entries.
5. Honest-fail message contract: `TooLong` (should now only be reachable if the DPAPI
   fallback itself fails) produces an accurate, actionable message distinct from the
   lock/permission-denied message, and explicitly instructs the user to revoke the dangling
   grant at `https://id.atlassian.com/manage-profile/apps` as a **required**, not optional,
   step.
6. Cross-platform behavior pin: macOS/Linux behavior is byte-for-byte UNCHANGED — the
   size-threshold router must never engage the DPAPI path on non-Windows targets (this is a
   regression-safety BC, not new user-facing behavior).

### 7.3 Existing tests in the regression-risk zone

Enumerate (do not rewrite; extend or add sibling assertions):

- `tests/auth_profiles.rs` (per-profile keychain read/write round-trips, `global_profile_flag_targets_auth_status`)
- `tests/auth_chosen_flow_reconcile.rs` (VP-AUTHDX-003, 2×3 cross product of flow-reconciliation cases)
- `tests/auth_oauth_default_creation.rs` (VP-AUTHDX-001/002, BC-1.1.013-016 OAuth-default guard)
- `tests/api_token_percred_wiring.rs` (BC-1.4.031 per-profile API-token wiring)
- `tests/auth_remove_logout_semantics.rs` (BC-1.2.013/014, `clear_profile_oauth_pair` vs `clear_profile_creds` — directly touches the functions in §5.2)
- `tests/oauth_refresh_integration.rs` (`#[ignore]`, `JR_RUN_KEYRING_TESTS=1` — real keychain round-trip; this is the closest existing harness to what a Windows-only DPAPI test would need to mirror)
- `tests/oauth_embedded_login.rs` (currently `unimplemented!()`, gated `JR_RUN_OAUTH_INTEGRATION=1` — not exercised by CI today; still a placeholder that should not silently rot further once the storage layer changes underneath it)
- `tests/oauth_flow_holdouts.rs` (holdout-style OAuth flow scenarios)
- `tests/keyring_windows_native_feature_present.rs` (S-WIN-3 manifest-text pins for `windows-native`/`deny.toml` skips — WILL need new pins added, not rewritten, if a new `windows`/`windows-sys` feature or dependency version lands per §6)
- `tests/keyring_guard_idiom.rs` (whatever convention this pins for keyring error-handling idiom — likely needs a sibling case for `TooLong`)
- `tests/auth_header_release_gate.rs`, `tests/auth_login_config_errors.rs`, `tests/auth_output_json.rs` — lower direct exposure, but exercise adjacent auth-header/login-error/JSON-output paths that must not silently change shape.
- Inline `#[cfg(test)]` modules in `src/api/auth.rs` itself (extensive — `store_oauth_tokens`/`load_oauth_tokens`/`clear_profile_*` all have colocated unit tests using `JR_SERVICE_NAME` test isolation; these are the PRIMARY tests to extend for the new router logic, since they can run on any OS today by mocking the keyring backend — but genuine Windows DPAPI behavior cannot be exercised this way, see §11).

### 7.4 VP-AUTHDX extension

This repo's convention (confirmed: no separate `.factory/specs/verification-properties/`
directory exists — VPs are cited inline in test/rustdoc comments as `VP-AUTHDX-NNN`, current
range VP-AUTHDX-001 through VP-AUTHDX-009, e.g. `src/api/auth.rs:2615, 2747, 3005, 3073,
3211, 3292, 3356, 3397`) should gain:

- **VP-AUTHDX-010** — DPAPI-storage roundtrip: encrypt→decrypt yields the original secret
  byte-for-byte, across a representative size range including values well above the 2560-byte
  Credential Manager ceiling.
- **VP-AUTHDX-011** — `TooLong`-triggered fallback: a secret engineered to exceed the keyring
  limit is routed to the DPAPI file, never silently dropped or truncated.
- **VP-AUTHDX-012** — Atomic dual-write invariant: a simulated failure mid-write (mirroring
  the existing `JR_S303_PERSIST_FAIL` fault-injection seam pattern already used for the
  persist-before-publish invariant in `refresh_oauth_token_with_url`) leaves the credential
  pair in a state that is either fully old or fully new, never mixed.
- **VP-AUTHDX-013** — Cross-platform non-engagement: on macOS/Linux, the size-threshold router
  never calls into DPAPI-only code (compile-time `#[cfg(windows)]` proof, not just a runtime
  branch — this should be a `cfg`-gated compile assertion, not merely a passing test, since a
  cross-platform *test* cannot prove the DPAPI code path is absent from a non-Windows binary).

---

## 8. Feature Type

**Backend + infrastructure.** No UI surface — `jr` is CLI-only. Every touch point is CLI
dispatch (`src/cli/auth/*`), a security-critical storage module (`src/api/auth.rs`), a new
platform-specific storage backend, and documentation (`README.md`). No UX Spec is
anticipated, consistent with prior cycles' precedent for this all-backend codebase.

---

## 9. Regression Risk

| Module | Risk | Why |
|--------|------|-----|
| `src/api/auth.rs` | **HIGH** | Core security-critical module; every credential read/write/clear path in the CLI ultimately funnels through it; many dependents (§5.3); the change (new storage backend + routing logic) is exactly the kind of change most likely to introduce a subtle regression in an already load-bearing, heavily-conditioned module (3,459 lines, extensive inline test coverage already defending multiple prior migrations — legacy-flat-key, per-profile-namespacing, no-copy-detect-and-instruct). |
| `src/api/refresh_coordinator.rs` | **MEDIUM** | Small (165 lines), well-isolated single-flight coordinator; does not itself touch storage, but its correctness depends on `store_oauth_tokens`'s error/success contract not changing shape in a way the coordinator's `Result<(String,String), anyhow::Error>` closure signature can't express — verify at F4 that the new router's error types still map cleanly. |
| `src/cli/auth/login.rs`, `refresh.rs`, `logout.rs`, `remove.rs`, `status.rs` | **MEDIUM** | DEPENDENT, not MODIFIED — no code change expected, but each has meaningful existing test coverage (§7.3) built against keyring-only behavior; risk is in tests silently passing while missing the new DPAPI path, not in the CLI logic itself. |
| `src/api/client.rs` | **LOW-MEDIUM** | Three read call sites of `load_oauth_tokens`; purely consumes the fixed contract, no behavioral change of its own, but sits on the hot 401-auto-refresh path (S-3.03) — any regression here is high-*impact* even though the change touching it is low-*probability*. |
| New DPAPI store module | **N/A (new code, no regression baseline)** — but its OWN correctness is the primary risk surface for this cycle; see §11. |
| `README.md` (#760) | **LOW** | Prose-only change to already-shipped, already-correct behavior; no `src/` touch; worst case is a documentation inaccuracy, not a functional regression. |

**Regression baseline — files explicitly NOT changed by this cycle** (confirm unaffected at
F7): `src/api/auth_embedded.rs` (embedded OAuth app credential obfuscation — orthogonal axis,
untouched), `src/config.rs` (path resolution — `global_config_dir()`/`cache_root()` are
*reused*, not modified, by the new DPAPI store), `src/profile.rs` (the `Profile` newtype
fence, ADR-0011 — untouched), all non-auth CLI command families (`issue`, `board`, `sprint`,
`worklog`, `team`, `user`, `project`, `component`, `queue`, `requesttype`, `assets`, `api`),
and every `types/`/`adf.rs`/`jql.rs`/`duration.rs`/`observability.rs`/`output.rs` module.

---

## 10. Windows-Only Testability Risk (first-class F1 risk)

This is the single largest execution risk in the cycle, called out prominently per the
task's instruction:

- **The dev/CI-default environment is macOS/Linux.** `CredWriteW`'s `TooLong` validation is
  keyring's own cross-platform logic (testable anywhere by constructing an over-length string
  and calling `set_password` against the `windows-native` backend's *validation* function —
  but `keyring`'s Windows backend code is itself `#[cfg(windows)]`-gated inside the `keyring`
  crate, so **even the `TooLong` trigger cannot be exercised on macOS/Linux CI** — the
  `windows-native` feature's code simply does not compile into a non-Windows binary). The
  actual `CryptProtectData`/`CryptUnprotectData` DPAPI syscalls are Windows-kernel-level and
  categorically cannot run anywhere else.
- **`windows-latest` CI job:** this repo's CI already has Windows coverage (per
  `tests/mutants_glob_existence.rs`/`ci.yml`'s cross-platform test matrix and the WIN-STACK/
  Windows-Credential-Manager gotchas already documented in CLAUDE.md), but **GitHub-hosted
  Windows runners have no interactive user session and, critically for DPAPI, an ephemeral,
  freshly-provisioned per-job user profile** — `CryptProtectData` user-scope keys ARE
  available in a headless CI user context (DPAPI does not require an interactive desktop,
  unlike some credential-prompt UIs), so a real end-to-end DPAPI round-trip test likely CAN
  run in `windows-latest` CI — this is a genuine testable seam, not a dead end, but it has
  never been exercised in this repo and must be proven, not assumed, at F4. Whether
  Credential Manager's `CredWriteW` itself is reachable/writable in that same headless
  context also needs empirical confirmation (existing `tests/oauth_refresh_integration.rs`'s
  `JR_RUN_KEYRING_TESTS=1` gate exists specifically because keyring round-trips are flaky in
  exactly this kind of environment — "Linux CI may lack secret-service; macOS prompts on
  novel service names" per its own doc comment — Windows CI's own quirks here are unknown
  and must be researched/spiked before F4 commits to a specific CI test design).
- **Cross-platform-unit-testable seams (CAN be covered on macOS/Linux CI today):**
  - The size-threshold ROUTER's decision logic (given a `keyring::Error::TooLong` outcome,
    does it correctly select the fallback path?) — testable by injecting a fake/mock error,
    not a real Windows credential store.
  - The DPAPI-file envelope's ENCODE/DECODE logic, if the versioned-envelope format (header +
    ciphertext + integrity tag) is designed as a pure function separable from the actual
    `CryptProtectData`/`CryptUnprotectData` FFI calls — i.e., architect should design the new
    module with a clean seam between "build the envelope bytes" (pure, cross-platform
    testable) and "encrypt/decrypt the envelope via DPAPI" (impure, Windows-only, thin FFI
    wrapper) — mirroring this codebase's existing purity-boundary discipline elsewhere.
  - The honest-fail error-message text itself (string content, independent of which OS
    produced the triggering condition) — fully testable everywhere via constructed
    `keyring::Error::TooLong` values.
  - The atomic-write temp-file + rename logic, IF implemented using `std::fs`/`tokio::fs`
    primitives that behave the same cross-platform (rename-based atomicity is POSIX- and
    NTFS-both-safe) — this can be unit-tested on any OS against a plain temp directory,
    independent of DPAPI.
- **Genuinely Windows-only bits (CANNOT be covered on macOS/Linux, CI or otherwise):**
  - The real `CryptProtectData`/`CryptUnprotectData` syscalls and their actual
    encrypt/decrypt round-trip against the Windows DPAPI subsystem.
  - The real `CredWriteW` `TooLong` trigger from a live, oversized Atlassian-shaped secret
    (mockable elsewhere, but the ACTUAL platform ceiling behavior is Windows-only).
  - Real end-to-end `jr auth login --oauth` on Windows against a live or wiremocked
    Atlassian, proving the full flow (browser round-trip → oversized token → DPAPI fallback
    → successful persist → subsequent `jr auth status`/API call succeeds).
- **Manual validation on real Windows is very likely REQUIRED**, not merely nice-to-have, for
  final sign-off — this is a first-class F1 risk to flag to the human: **the fix could pass
  100% of mac/linux CI (all the cross-platform-testable seams above) while its actual DPAPI
  encrypt/decrypt correctness on real Windows remains unverified by CI alone.** The original
  reporter (or another Windows user) performing a manual smoke test against a real Windows 11
  install — mirroring exactly the repro steps in #759 — should be treated as a required gate
  before this cycle's F7 convergence, not an optional nice-to-have. Recommend F6/F7 explicitly
  schedule this manual step and record its outcome, rather than let "CI is green" stand in for
  "verified on the platform this fixes."

---

## 11. Cross-Cutting `cloud_id` Observation (flag, do not decide)

Both issues independently surface the same defect from different angles: an API-token login
does not persist `cloud_id`, breaking every Assets/CMDB command
(`Error: Cloud ID not configured. Run "jr init" to set up your instance.`) even after a
"successful" login. #760 frames this as a documentation caveat ("config schema describes
`cloud_id` as auto-discovered — true only for OAuth"). The reporter also names the concrete
fix mechanism: `GET /_edge/tenant_info` is unauthenticated-per-site and could be called
during API-token login to fetch and persist `cloud_id` the same way OAuth's org-selection step
already does. This overlaps the already-tracked `A-PA-LOW-001` finding (referenced in this
codebase's adversarial-review history, not independently re-verified in this pass).

**This report does NOT decide the scope.** #760 unambiguously covers only the DOCUMENTATION
caveat (state clearly that `cloud_id` auto-discovery is OAuth-only, API-token users must set
it manually). Whether the ACTUAL FIX (fetch+persist `cloud_id` on API-token login via
`GET /_edge/tenant_info`) belongs in this cycle or a separate future cycle is an **open
question for the F1 human gate** (§14) — it is directly relevant here only because #759's fix
forces more Windows users onto the API-token path than before, amplifying this defect's
practical impact, but it is a materially different, independent piece of work (a new
unauthenticated HTTP call + config write during `jr auth login` for API-token profiles) from
either #759's storage fix or #760's doc fix.

---

## 12. Recommended Scope for F2-F7

**Standard bug-fix route WITH F2 and F3 — NOT the skip-F2/F3 simple-bug-fix shortcut.**

Justification for F2 (spec evolution) being necessary, contrary to what a "simple bug fix"
shortcut would assume:
- A wholly NEW architectural component (DPAPI-encrypted-file secret store) requires new BCs
  (§7.2) — this is not merely correcting an existing contract's text, it is adding contracts
  that did not exist before (a size-safe storage guarantee, an atomicity guarantee, a
  cross-platform non-engagement guarantee).
- A new external dependency decision (§6, `windows` crate vs raw `windows-sys`) is an
  architecture-level choice with real cargo-deny/supply-chain consequences, requiring
  documented rationale (an ADR is plausible, at minimum an F2 architecture-delta note).
- The honest-fail message design and the atomic dual-write invariant both need explicit
  acceptance-criteria specification before implementation — these are exactly the kind of
  "verification-ready by construction" properties this pipeline exists to specify up front,
  not discover during coding.

Justification for F3 (incremental stories) being necessary:
- The work naturally decomposes into at least three independently deliverable, independently
  testable stories (estimate below), each with its own TDD cycle — this is not a single
  one-file, one-function patch.

**Estimated stories for F3:**
1. **`dpapi-storage-fix`** — new DPAPI-encrypted-file store module + size-threshold router +
   atomic dual-write logic + `load_oauth_tokens`/`clear_profile_*` DPAPI-awareness (the bulk
   of the engineering; HIGH regression risk module, needs the most adversarial scrutiny).
2. **`honest-fail-message`** — replace the four "Unlock your keychain" sites' error handling
   per §5.2, matching `keyring::Error::TooLong` specifically and making the grant-revoke step
   explicit/required. Can be delivered independently of story 1 (it's a strict improvement
   even before the DPAPI fallback exists, and DEC-334 explicitly treats it as its own
   backstop) — consider sequencing this FIRST as a smaller, faster, immediately-shippable
   safety net while story 1's larger surface goes through more scrutiny.
3. **`windows-docs`** — #760's README changes (install steps, `Unblock-File` note,
   config/cache path table, `cloud_id` caveat scoped to OAuth-only). Independently
   shippable, LOW risk, can land in parallel with 1/2.
4. *(Contingent on the F1 human gate's answer to §11)* **`cloud-id-api-token-autodiscovery`**
   — only if the human decides the actual `cloud_id` fetch-and-persist fix belongs in this
   cycle rather than a separate one.

Through F4 (TDD implementation, full regression suite as safety net), F5 (scoped adversarial
review — MUST include a reviewer pass specifically probing the atomicity and honest-fail
message correctness, given §10's testability gap), F6 (targeted hardening — the size-threshold
router and envelope encode/decode are strong candidates for property-based/fuzz testing even
though the DPAPI syscalls themselves cannot be fuzzed cross-platform), F7 (delta convergence,
gated on the manual Windows validation step per §10), then release.

---

## 13. Open Questions for the F1 Human Gate

1. **Is the overall scope correct?** Confirm the three-story (or four, pending Q2) F3
   decomposition in §12 matches intent, and that `dpapi-storage-fix` + `honest-fail-message`
   + `windows-docs` is the right split (vs., e.g., merging 1+2 into one story since they touch
   the same file, or splitting `dpapi-storage-fix` further).
2. **Is the `cloud_id` auto-discovery FIX (not just the doc caveat) in scope for cycle-004, or
   a separate future cycle/issue?** (§11) — recommend a decision now so F2 doesn't have to
   re-litigate it, but this report deliberately does not pre-decide it.
3. **Is the Windows-validation plan in §10 acceptable?** Specifically: (a) is a manual smoke
   test by a human on real Windows an acceptable/available gate before F7 convergence, or
   does this need a different verification strategy (e.g., recruiting the original reporter,
   or provisioning a real Windows VM for the team)? (b) should F4 spike whether
   `windows-latest` GitHub Actions CI can actually exercise `CryptProtectData` end-to-end
   before committing the story estimate in §12, since that answer changes how much of the
   DPAPI logic gets CI coverage vs. manual-only coverage?
4. **`windows` crate vs. raw `windows-sys` (§6)?** — a real architecture decision with
   supply-chain tradeoffs; needs the architect's F2 recommendation plus a `cargo add` dry-run
   against this repo's actual `deny.toml`/`Cargo.lock` before committing, not assumed here.
5. **Any module to exclude from this cycle's scope?** In particular: should
   `clear_all_credentials` (§5.2, currently test-only per its own rustdoc, with an explicit
   "do NOT reintroduce a call to this function from refresh/login" warning from a prior
   incident) be touched at all, or left genuinely untouched and out of scope, given it has no
   production call sites today?
6. **Sequencing preference:** ship `honest-fail-message` (story 2) ahead of / independently
   from `dpapi-storage-fix` (story 1) as a fast-follow safety net, or require both to land
   together in one release? (§12 recommends independent sequencing but does not mandate it.)

---

## Notes on Confidence / What Was NOT Independently Re-Verified

- The research doc's claims (A-F verdict table) are treated as authoritative per this task's
  instructions and were not re-derived from primary sources in this pass — this F1 analysis
  builds on them as given.
- The `windows`-crate-vs-`windows-sys` correction in §6 WAS independently re-verified against
  this repo's actual `Cargo.lock` (not merely re-stated from the research doc) — the research
  doc's own "likely already transitive" language was appropriately hedged, and this analysis
  confirms the more precise, less favorable answer (`windows-sys` present, not `windows`).
- Exact new BC numbers in §7.2 are NOT allocated here — that is F2's job; this report only
  estimates the count and cluster, consistent with how `cycle-003`'s F1 delta analysis handled
  the same forward-reference problem.
- `A-PA-LOW-001` (§11 cross-reference) was cited from this report author's general knowledge
  of this codebase's tracked-findings conventions and was NOT independently looked up in this
  pass — the architect/human should confirm this ID is accurate before it propagates further.
