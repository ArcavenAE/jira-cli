---
document_type: vp-delta
feature: windows-correctness
cycle: cycle-004
phase: F2-spec-evolution
date: 2026-09-03
author: formal-verifier
status: complete
adr: ["ADR-0021", "ADR-0022"]
scheme: VP-AUTHDX
new_vps: 14
vp_count_before: 41
vp_count_after: 55
bc_count_unchanged: 742
inputs:
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - ".factory/specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md"
  - ".factory/specs/architecture/decisions/ADR-0022-api-token-cloud-id-acquisition-tenant-info.md"
  - ".factory/cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md"
  - ".factory/research/edge-tenant-info-cloudid-2026-09-03.md"
input-hash: "00725ec"
---

# VP Delta — Windows Correctness (`windows-correctness`, cycle-004, Phase F2)

Formal-verifier's F2 verification-property delta for the 9 new BCs (BC-1.4.035..040,
BC-1.2.052..054) and 1 amended BC (BC-1.4.028) the product-owner delivered this cycle. This is
**spec-authoring of VPs only** — proofs/fuzzers/mutation runs are F6 (targeted hardening), not
this pass.

**Scheme decision.** The architecture-delta §7 and the new BCs' own `VP Anchors` fields already
RESERVE the `VP-AUTHDX` scheme (F1-provisional IDs VP-AUTHDX-010..013), continuing the existing
cycle-003 auth verification-property scheme. Per the F2 convention ("use the scheme the
architecture-delta prescribes if it does"), all 14 new VPs continue `VP-AUTHDX`, numbered
010–023. VP-AUTHDX-001..009 are cycle-003's (008 in this file, 009 in `bc-6-config-cache.md`);
010..023 are new this cycle. VP-AUTHDX-010..021 (12) were authored in the original F2 VP-delta
pass; VP-AUTHDX-022 (1) was added in the Pass-3 adversarial-review follow-on (Finding #1,
STALE-KEYRING-SHADOWS-DPAPI — architecture-delta.md §12 + its Pass-3 architect guidance);
VP-AUTHDX-023 (1) was added in the Pass-6 adversarial-review follow-on (Finding #3, the
`JR_FORCE_DPAPI_FALLBACK` debug-seam release-gate — architecture-delta.md §15 + its Pass-6
architect guidance; ADR-0021 §1's expanded doc-fallout note), bringing the new-VP total to 14.

**Placement.** All VPs are authored INLINE within `bc-1-auth-identity.md`, under their home BC's
`**Verification Properties**:` field as `- **VP-AUTHDX-NNN — <title> (<class>).** Property: …
**Verification method**: … **F6 target**: …` bullets, mirroring the existing VP-AUTHDX-001..008
structure (each carries an explicit ORACLE and an F6 target). Each BC's `**VP Anchors**:` field
was updated from "(new, formal-verifier to allocate)" to the concrete IDs.

---

## New VPs — one-line oracles and BC traces

| VP | Home BC | Class / priority | Platform | One-line oracle |
|----|---------|------------------|----------|-----------------|
| **VP-AUTHDX-010** | BC-1.4.037 | SECURITY-CRITICAL | **Windows-only** | `dpapi::unprotect(dpapi::protect(p)) == p` for any `p` (incl. > 2560 bytes), ciphertext ≠ plaintext, USER-scope only (never `CRYPTPROTECT_LOCAL_MACHINE`). Sub-property (a) pins the security bit only — `dwFlags & CRYPTPROTECT_LOCAL_MACHINE == 0`, NOT `dwFlags == 0` (Pass-5 Finding #3; current concrete value `CRYPTPROTECT_UI_FORBIDDEN` = `0x1`). |
| **VP-AUTHDX-011** | BC-1.4.035 | SAFETY INVARIANT | cross-platform (routing dispatch seam-gated) | `should_fallback_to_dpapi` is `true` iff `keyring::Error::TooLong` (pure predicate, no seam); `store_oauth_tokens` routes the whole pair to DPAPI iff a `TooLong` occurs, never a pre-flight length guess — the routing DISPATCH is default-CI-reachable off-Windows ONLY via `JR_FORCE_DPAPI_FALLBACK=1` (Pass-5 Finding #1). |
| **VP-AUTHDX-012** | BC-1.4.037 (+BC-1.4.035) | SAFETY-CRITICAL | cross-platform (rollback logic seam-gated; real rename Windows-only) | The pair is always fully in ONE backend (never split; access write rolled back on refresh-`TooLong`); the file write is temp-then-rename so a mid-write crash leaves the OLD or NO file, never a partial; stale-temp cleanup is AGE-GATED (Pass-3 Finding #3) — a `*.tmp-*` sibling older than `STALE_TMP_THRESHOLD` (30 s) is removed while a younger one is PRESERVED (never a blanket delete). The rollback/no-split ORDERING logic is default-CI-reachable off-Windows ONLY via `JR_FORCE_DPAPI_FALLBACK=1` (Pass-5 Finding #1); the real rename/fsync/age-gated-cleanup file mechanics stay Windows-only, unaffected by the seam. |
| **VP-AUTHDX-013** | BC-1.4.035 | COMPILE-TIME / cfg-ABSENCE | cross-platform | On `#[cfg(not(windows))]`, `dpapi::*` doesn't exist and `store_pair`/`load_pair`/`remove_if_present` do no I/O (`DpapiFallbackFailed`/`Ok(None)`/`Ok(())`) — macOS/Linux byte-for-byte unchanged. |
| **VP-AUTHDX-014** | BC-1.4.037 | SAFETY-CRITICAL / PURE | cross-platform | `decode(encode(a,r)) == (a,r)` and `unwrap(wrap(x)) == x` for any input; malformed/unrecognized envelope → distinct `Err`, never a panic, never coerced to empty/absent. |
| **VP-AUTHDX-015** | BC-1.4.036 (co-covers BC-1.4.028) | SAFETY INVARIANT | cross-platform (via seam) | A present-but-undecryptable DPAPI file → distinct force-re-login error, NEVER "no token"; `Ok(Some)` load indistinguishable from keyring; `Ok(None)` falls through; amended partial-state branch applies the SAME typed distinction as the both-absent branch (3a prefer `Ok(Some)`, 3b corrupt→force-re-login, 3c backend/IO→distinct non-corruption error, 3d `Ok(None)`→partial), asserted under both keyring pre-states (Pass-4 Finding #1). Per BC-1.4.036's FOUR-WAY framing, a `load_pair` `Err` carrying a `ProfilePathEscape` is the FIRST-checked member and RENDERS as the exit-64 invalid-profile-name message — before corrupt-envelope and backend/IO — never "check file permissions" (Pass-5 Finding #2, EC-1.4.036-7; distinct from VP-016's guard-emission proof). |
| **VP-AUTHDX-016** | BC-1.4.040 | SECURITY INVARIANT (CWE-22) / **HIGH** | cross-platform / PURE | Host-independent character-level recognizer `reject_unsafe_profile_component` (NOT `std::path`, ADR-0021 §9): rejects — on ANY host, no `#[cfg(windows)]` gate — every `/` or `\` separator (incl. UNC via either), any `:` (drive-letter + NTFS ADS), empty/exact-`.`/`..`/NUL, trailing dot-or-space, and the 30-name reserved device set (ADR-0021 §9 authoritative list — 6 classic + `COM1-9` + `LPT1-9` + 6 Unicode superscript `COM¹/²/³`,`LPT¹/²/³`, leading-space-stem-trimmed) as a typed `ProfilePathEscape` → exit-64 BEFORE any FS op, at all three store entry points via `file_path`; a passing name is an opaque segment by construction (no post-hoc normalize-and-compare); ordinary names unchanged. Includes a DESIGN-CONFORMANCE assertion so a future `std::path` substitution is caught here on the Linux CI runner, not silently passed, PLUS a SEPARATE guard-WIRING oracle (Pass-4 Finding #2) calling `store_pair`/`load_pair`/`remove_if_present` directly with a guard-failing name and asserting each returns `Err`→`ProfilePathEscape` before any FS op/OS short-circuit — the wiring, not just the recognizer, is now default-CI-covered. |
| **VP-AUTHDX-017** | BC-1.4.039 | SAFETY INVARIANT | cross-platform | Sites 1/3 select the honest-fail message iff `downcast_ref::<DpapiFallbackFailed>()` is `Some` (else the unchanged "Unlock your keychain" message); the two sites use DISTINCT text (Finding #3) — Site 1 (login) instructs grant-revoke, Site 3 (refresh) MUST omit it (oracle asserts absence); Site 3 additionally clears the stale pair via `clear_profile_oauth_pair` so the next command sees "no stored OAuth token", not `invalid_grant` (Postcondition 4, Finding #7). Honest-fail reachable only when BOTH backends failed. A store error carrying a `ProfilePathEscape` RENDERS FIRST at BOTH sites as the exit-64 invalid-profile-name message — before `DpapiFallbackFailed` and before "Unlock your keychain" (Pass-5 Finding #2, EC-1.4.039-5; distinct from VP-016's guard-emission proof). |
| **VP-AUTHDX-018** | BC-1.4.038 | SAFETY INVARIANT | cross-platform (real delete Windows-only) | After `clear_profile_oauth_pair`/`clear_profile_creds`, NEITHER backend retains the pair; `NotFound` tolerated as success, a genuine FS error propagates (not swallowed); creds cleared before config entry. |
| **VP-AUTHDX-019** | BC-1.2.052 | SAFETY INVARIANT / **HIGH** | cross-platform | `fetch_cloud_id` failure (non-2xx / network / malformed / missing field) NEVER aborts login and NEVER panics — soft-fail, cloud_id untouched, single stderr note; success overwrites; no auth header, no query string, 10s timeout; a non-`https://` (`http://`/scheme-less) `site_url` SKIPS the fetch entirely with ZERO network requests (wiremock `expect(0)`) and leaves cloud_id unchanged — same soft-fail path (Pass-4 Finding #4); `--cloud-id` override suppresses the fetch AND is itself written to `p.cloud_id` + persisted via `Config::save_global()` (Finding #8). |
| **VP-AUTHDX-020** | BC-1.2.053 | SAFETY INVARIANT / **HIGH** | cross-platform | oauth→api_token switch: fetch-success OVERWRITES stale cloud_id; fetch-failure PRESERVES the prior value (incl. `None`) — NEVER a bare clear. Extends VP-AUTHDX-003's mechanism-reconciliation harness. |
| **VP-AUTHDX-021** | BC-1.2.054 | REGRESSION PIN (confirmed-unchanged) | cross-platform | `Config::base_url()` selects the gateway iff `auth_method == "oauth"` (any other value incl. unset→api_token → site URL); `assets_base_url` is `cloud_id`-only, deliberately un-gated. Pins current behavior so a future pass cannot silently re-fix either. |
| **VP-AUTHDX-022** | BC-1.4.035 | SAFETY INVARIANT / **HIGH** | cross-platform core (real-DPAPI tail Windows-only) | Stale-keyring-shadow closure (Pass-3 Finding #1): given a PRE-EXISTING complete keyring pair + `TooLong` on BOTH arms (access-overflow; refresh-overflow-after-access-succeeded), after `store_oauth_tokens` both keyring keys are ABSENT, the DPAPI file holds the FRESH pair, and a subsequent `load_oauth_tokens` returns the FRESH DPAPI pair — never the stale keyring pair (no shadowing via BC-1.4.036's both-keys-present fast path); deletes keyring FIRST, so a mid-window crash leaves NEITHER backend populated. |
| **VP-AUTHDX-023** | BC-1.4.035 | RELEASE-GATE / cfg-ABSENCE PIN — default-CI, spike-independent (same class as VP-010(a)) | cross-platform (source-text scan; Windows-COMPILED-buildable) | `JR_FORCE_DPAPI_FALLBACK` debug-seam release-gate (Pass-6 Finding #3, ADR-0021 §1 expanded doc-fallout note): a dedicated `tests/jr_force_dpapi_fallback_release_gate.rs` source-scan pin asserts `#[cfg(debug_assertions)]` sits within 5 source lines of the `JR_FORCE_DPAPI_FALLBACK` env-var read in `src/api/auth.rs`'s `#[cfg(not(windows))] fn engage_dpapi_fallback` — proving the seam is compiled OUT of release builds (production non-Windows stays hardcoded `false`), matching the sibling-seam convention (`tests/jr_test_block_until_sigint_release_gate.rs` / `tests/config_dir_release_gate.rs`, one file per seam). |

---

## Coverage map — every new/amended BC has ≥1 dedicated VP

| BC | Kind | VP(s) |
|----|------|-------|
| BC-1.4.035 (keyring-first + DPAPI fallback on `TooLong`) | NEW | VP-AUTHDX-011, VP-AUTHDX-013, VP-AUTHDX-022 (stale-keyring-shadow closure, Pass-3 Finding #1), VP-AUTHDX-023 (`JR_FORCE_DPAPI_FALLBACK` debug-seam release-gate, Pass-6 Finding #3) (+ VP-AUTHDX-012 no-split) |
| BC-1.4.036 (DPAPI-aware load path + corrupt→force-re-login) | NEW | VP-AUTHDX-015 (+ VP-AUTHDX-014 corrupt-envelope mechanism) |
| BC-1.4.037 (versioned envelope + atomic temp-write-rename) | NEW | VP-AUTHDX-010, VP-AUTHDX-012, VP-AUTHDX-014 |
| BC-1.4.038 (delete-both-backends) | NEW | VP-AUTHDX-018 |
| BC-1.4.039 (honest-fail `DpapiFallbackFailed` backstop) | NEW | VP-AUTHDX-017 |
| BC-1.4.040 (profile-name path-traversal guard) | NEW | VP-AUTHDX-016 |
| BC-1.2.052 (`cloud_id` acquisition via `/_edge/tenant_info`) | NEW | VP-AUTHDX-019 |
| BC-1.2.053 (mechanism-switch refresh-not-clear) | NEW | VP-AUTHDX-020 |
| BC-1.2.054 (`base_url()`/`assets_base_url` confirmed-unchanged) | NEW | VP-AUTHDX-021 |
| BC-1.4.028 (partial-state read now checks DPAPI file) | AMENDED | VP-AUTHDX-015 (co-covered; partial-state branch) |

**Security-critical properties explicitly covered** (per the F2 directive): path-traversal guard →
VP-AUTHDX-016; atomic write / no-partial-file → VP-AUTHDX-012 (+VP-AUTHDX-014 envelope integrity);
delete-both-backends completeness → VP-AUTHDX-018; cloud_id preserve-on-failure invariant →
VP-AUTHDX-020; stale-keyring-shadow closure (no stale keyring pair shadowing a fresh DPAPI pair) →
VP-AUTHDX-022. BC-1.2.054's confirmed-unchanged invariant gets a dedicated regression-pin
(VP-AUTHDX-021) so a future pass cannot silently "re-fix" it.

---

## Cross-platform testability boundary (no Windows runner required for the delta's bulk)

Every oracle states its testability boundary explicitly, so the F6 pass can run the bulk of the
delta in ordinary `cargo test` on macOS/Linux CI — mirroring the cycle-003 keyring-gated coverage
boundary already documented for VP-AUTHDX-005/006/007.

- **Cross-platform, runs in default CI (13 of 14):** VP-AUTHDX-011, 012 (no-split/rollback +
  temp-rename sequencing + age-gated `*.tmp-*` cleanup via a directory-scan seam), 013, 014, 015,
  016, 017, 018 (invocation/error-fold), 019, 020, 021, 022 (stale-keyring-shadow routing /
  delete-keyring-first ordering / neither-backend-on-mid-window-fault core), 023 (the
  `JR_FORCE_DPAPI_FALLBACK` debug-seam release-gate — a source-text-scan pin over `src/api/auth.rs`,
  host-independent and spike-independent, same class as VP-AUTHDX-010(a); Pass-6 Finding #3). These rely on: pure
  functions (envelope, routing predicate, path guard), `keyring::Error` and
  `load_pair`-outcome fault-injection seams, `wiremock` (tenant_info), and the fact that on
  macOS/Linux `auth_windows_store::load_pair`→`Ok(None)` / `remove_if_present`→`Ok(())` /
  `store_pair`→`DpapiFallbackFailed` are no-ops (BC-1.4.035 Invariant 3) — VP-AUTHDX-022's core in
  particular leverages the non-Windows `store_pair`→`DpapiFallbackFailed` return to exercise the
  mid-window-fault shape (keyring deleted, DPAPI store fails → neither backend populated) in
  default CI, with only its real-DPAPI-present + fresh-load round-trip deferred to a Windows-only
  tail (or a `load_pair` seam).
  - **The default-CI figure (now 13 of 14 after Pass-6's VP-AUTHDX-023) is unchanged in kind, but
    three of these default-CI classifications are now
    explicitly SEAM-GATED, not unconditional (Pass-5 adversarial review Finding #1).** Because
    Pass-1's `engage_dpapi_fallback` is `#[cfg(not(windows))]`-hardcoded `false` in production, the
    DPAPI-routing branch of `store_oauth_tokens` is dead code on any non-Windows runner — so the
    default-CI cores of VP-AUTHDX-011 (sub-property (2), the routing DISPATCH), VP-AUTHDX-012 (the
    rollback/no-split ORDERING logic), and VP-AUTHDX-022 (the delete-keyring-first ordering +
    neither-backend-on-store-failure "delete-then-fail" core) are reachable off-Windows ONLY with
    the new `#[cfg(debug_assertions)]`-gated `JR_FORCE_DPAPI_FALLBACK=1` opt-in test seam engaged
    (ADR-0021 §1). Without the seam, none of these three cores is an executable property on a
    non-Windows runner at all (they did not exist as such until this pass added the seam). What is
    NOT seam-gated and needs NO seam: VP-AUTHDX-011's pure `should_fallback_to_dpapi` predicate
    (sub-property (1)); VP-AUTHDX-012's real rename/fsync/age-gated-cleanup file mechanics (those
    are Windows-only regardless — they live inside `store_pair`'s `#[cfg(windows)]` arm the seam
    cannot reach); and VP-AUTHDX-022's success oracle "(a)+(b)+(c) after `store_oauth_tokens`
    returns `Ok`" (Windows-only real-DPAPI tail — a successful `store_pair` cannot happen off
    Windows with or without the seam; in the seam-engaged default-CI run `store_oauth_tokens`
    returns `Err`, which is exactly the delete-then-fail shape the core verifies). Each of these
    three VPs' oracle text in `bc-1-auth-identity.md` now states its `JR_FORCE_DPAPI_FALLBACK`
    dependency explicitly, so an F6 executor does not attempt to write these tests against the
    unseamed production path and discover the branch is simply unreachable. Production/release
    behavior is unchanged either way (still hardcoded `false` absent the seam).
  - **Pass-6 adversarial-review follow-on (two additions on this same seam, both scoped to
    F4/F6 test scaffolding — no production-code or VP-oracle change).** (i) **Finding #3** adds the
    dedicated release-gate VP-AUTHDX-023 (above): because `JR_FORCE_DPAPI_FALLBACK` gates a
    security-critical credential-storage routing decision, the established `JR_*` debug-seam
    convention (CLAUDE.md "AI Agent Notes") requires a `tests/jr_force_dpapi_fallback_release_gate.rs`
    pin proving the `#[cfg(debug_assertions)]` gate compiles the env read out of release builds —
    ADR-0021 §1's expanded doc-fallout note now makes this a three-part checklist F4's
    `dpapi-storage-fix` story ships in one commit. (ii) **Finding #4** adds, to VP-AUTHDX-011/012/022's
    verification-method text in `bc-1-auth-identity.md`, an explicit `env_lock`-style
    `std::sync::Mutex` serialization requirement (the `JR_SERVICE_NAME` pattern in
    `tests/oauth_refresh_integration.rs`, NOT `--test-threads=1`) for every test that sets/reads/unsets
    the process-global `JR_FORCE_DPAPI_FALLBACK` — the seam-engaged (`=1`) delete-then-fail tests and
    the env-UNSET legacy "Unlock your keychain" counterpart (VP-AUTHDX-017 / BC-1.4.035 Invariant 3's
    own test guidance) assert OPPOSING outcomes from the SAME `engage_dpapi_fallback` call site and
    would otherwise race under `cargo test`'s default parallelism.
  - **VP-AUTHDX-016's default-CI classification is contingent on ADR-0021 §9's host-independent
    recognizer design being followed — NOT on the OS the test runs on (Pass-2 adversarial review
    Finding #1).** The property is "cross-platform / runs in default CI" ONLY because
    `reject_unsafe_profile_component` is a character-level scan that never delegates to `std::path`;
    the ORIGINAL "Windows-syntax-aware" wording was equally satisfiable by a `std::path`-based
    implementation that would silently run NO real Windows-syntax check in default (Linux) CI while
    still reporting green (`Path::new("C:\\evil")` yields one opaque contained `Component::Normal` on
    Linux). The VP's harness therefore asserts every Windows-shaped vector (drive/ADS colon, UNC
    prefix via either separator, and each of the 30 reserved device names — ADR-0021 §9's
    authoritative set, incl. the Unicode superscript `COM¹`/`LPT¹` variants and the leading-space
    stem form `" CON"`, Pass-4 Finding #3) is REJECTED on the Linux/macOS runner ITSELF, with NO
    `#[cfg(windows)]` gate, PLUS a DESIGN-CONFORMANCE assertion that FAILS on a `std::path`
    substitution — so an implementer who reaches for `std::path` for expedience is caught by THIS VP
    on the default runner, not merely by the VP's label. **The guard-invocation WIRING is now
    default-CI-covered too (Pass-4 Finding #2), not only the recognizer:** because ADR-0021 §3/§9
    now require the non-Windows cfg arm of `store_pair`/`load_pair`/`remove_if_present` to call
    `file_path(profile)?` (hence the guard) as its literal first statement before its own
    short-circuit, VP-AUTHDX-016 adds a SEPARATE oracle assertion — call each of the three entry
    points directly on the Linux/macOS runner with a guard-failing name and assert each returns
    `Err` downcastable to `ProfilePathEscape` before any FS op / OS short-circuit. This closes the
    gap where a Windows-only regression dropping the guard call from an entry point would previously
    have passed every default-CI test; it is a distinct property from the recognizer's own
    correctness and fails independently.
  - **VP-AUTHDX-020 default-CI classification is via a CONFIG-LAYER seam, not the keyring-gated
    harness tier (Pass-1 adversarial review Finding #9, resolved via option (b)).** The property
    VP-AUTHDX-020 verifies — overwrite-on-fetch-success / preserve-on-fetch-failure / never-bare-clear —
    is a config-layer decision about applying a `tenant_info` fetch outcome to `ProfileConfig.cloud_id`
    (config.rs / `Config::save_global()`), SEPARATE from the keychain credential store. It is verified
    in default CI via `wiremock` (fetch) + a direct in-memory `ProfileConfig.cloud_id` overwrite/preserve
    assertion — the SAME fetch-and-apply seam VP-AUTHDX-019 uses — WITHOUT `store_api_token`/`load_api_token`.
    It does NOT run its default-CI assertion through `tests/auth_chosen_flow_reconcile.rs`'s real-keychain
    tier (that tier is `#[ignore]` + `JR_RUN_KEYRING_TESTS=1`, the documented VP-AUTHDX-005/006/007 boundary).
    The full real-keychain end-to-end mechanism-switch scenario is an OPTIONAL keyring-gated confirmation
    tail (see below), not the primary oracle — so VP-AUTHDX-020's config-layer core legitimately counts
    toward "13 of 14 in default CI."
- **Windows-only (1 of 14):** VP-AUTHDX-010 — the real `CryptProtectData`/`CryptUnprotectData`
  round-trip; the single property exercising the DPAPI syscalls. That round-trip (sub-property (b))
  runs on a `windows-latest` CI runner or via manual validation, and whether headless `windows-latest`
  GitHub Actions can exercise `CryptProtectData` is an OPEN F4 spike (architecture-delta §9 item 3),
  carried forward — this VP-delta does not resolve it. **BUT the single most security-critical DPAPI
  invariant — USER scope only, never `CRYPTPROTECT_LOCAL_MACHINE` — is split out as sub-property (a)
  and has SPIKE-INDEPENDENT automated coverage (Pass-1 adversarial review Finding #10):** a
  Windows-COMPILED unit test pins the security-relevant bit ONLY — `dwFlags & CRYPTPROTECT_LOCAL_MACHINE == 0`
  (`LOCAL_MACHINE` bit clear), NOT an exact `dwFlags == 0` on the full word (Pass-5 adversarial review
  Finding #3; the current concrete value is `CRYPTPROTECT_UI_FORBIDDEN` = `0x1`, so a whole-word `== 0`
  pin would over-specify and need re-pinning on any future unrelated flag) — and
  requires only that the code compiles for the `x86_64-pc-windows-msvc` target (`cargo test --target
  x86_64-pc-windows-msvc` / a `windows-latest` unit run), NOT that the DPAPI syscall executes headlessly.
  So this invariant is NOT left uncovered pending the spike; the F7 gate must treat sub-property (a) as
  the required automated coverage of never-`LOCAL_MACHINE` and must not record VP-AUTHDX-010 as entirely
  uncovered on an inconclusive (b) spike.
- **Windows-only / keyring-gated *portions* (4 of the cross-platform VPs' tails):** VP-AUTHDX-012's
  real `std::fs::rename`+`fsync` NTFS-atomicity step (and, if the age-gated cleanup is inlined only
  in `store_pair`'s Windows path rather than a factored directory-scan helper, its age-gate positive
  verification) and VP-AUTHDX-018's real DPAPI-file-absence-post-clear assertion each have a
  Windows-CI / keyring-gated tail beyond their cross-platform core; VP-AUTHDX-020's full
  real-keychain end-to-end oauth→api_token mechanism-switch scenario (extending
  `tests/auth_chosen_flow_reconcile.rs`'s gated tier) is a keyring-gated confirmation tail beyond
  its default-CI config-layer core (Finding #9); VP-AUTHDX-022's sub-assertions (b) "DPAPI file
  holds the fresh pair" and (c) "subsequent `load_oauth_tokens` returns the fresh DPAPI pair, not
  the stale keyring pair" are a Windows-only real-DPAPI round-trip tail (or cross-platform via a
  `load_pair` injection seam) beyond its cross-platform delete-ordering/no-shadow-routing core.

---

## Counts

- **BCs:** unchanged. VPs are authored as inline text under existing BCs' `Verification
  Properties` fields — no `#### BC-` heading added or removed. `bc-1-auth-identity.md`
  `definitional_count` stays **69**; `total_bcs` stays **80** (cumulative); repo-wide BC total
  stays **742**.
- **Cumulative VP count:** **41 → 55** (+14). VP-AUTHDX-010..021 (12) were authored in the
  original F2 VP-delta pass; VP-AUTHDX-022 (1) was added in the Pass-3 adversarial-review follow-on
  (Finding #1, STALE-KEYRING-SHADOWS-DPAPI); VP-AUTHDX-023 (1) was added in the Pass-6
  adversarial-review follow-on (Finding #3, the `JR_FORCE_DPAPI_FALLBACK` debug-seam release-gate —
  ADR-0021 §1's expanded doc-fallout note; architecture-delta.md §15). The 41 baseline is the
  cycle-003-close figure tracked in STATE.md (and flagged there as MED-1: never independently
  re-verified line-by-line — this delta adds to it, it does not re-audit the 41).

## Drift-check results (run from repo root after authoring)

- `bash scripts/check-spec-counts.sh` → exit **0** (BC/NFR/holdout frontmatter counts match
  bodies; VP counts are not tracked by this script).
- `bash scripts/check-bc-cumulative-counts.sh` → exit **0** (all BC-count surfaces agree at 742;
  unaffected by VP authoring).

## Not in scope / carried forward

- Proof/fuzz/mutation EXECUTION is F6, not this pass.
- VP-AUTHDX-010's real-Windows reachability (headless `windows-latest` vs. manual) — open F4/F6
  spike (architecture-delta §9 item 3).
- STATE.md's cumulative-VP figure is updated by state-manager at the end of the F2 burst, not
  here. No commit is made by this pass.
