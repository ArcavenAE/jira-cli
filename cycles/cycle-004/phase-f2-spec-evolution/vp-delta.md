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
input-hash: "2db0acb"
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
| **VP-AUTHDX-011** | BC-1.4.035 | SAFETY INVARIANT | predicate cross-platform DEFAULT CI; routing-state core KEYRING-GATED | `should_fallback_to_dpapi` is `true` iff `keyring::Error::TooLong` (pure predicate, default CI, no seam, no keychain); `store_oauth_tokens` routes the whole pair to DPAPI iff a `TooLong` occurs, never a pre-flight length guess — the routing DISPATCH / rollback STATE core is **KEYRING-GATED** (`#[ignore]`+`JR_RUN_KEYRING_TESTS=1`, +`JR_FORCE_DPAPI_FALLBACK=1` on non-Windows), NOT default CI: the seam lifts only the cfg-gate, not `store_oauth_tokens`'s real `set_password`/delete keychain calls, and the keyring mock can't persist the pre-seed→re-read state (VP-005/006/007 boundary) — Pass-8 Finding #1 corrects Pass-5's overstated "default-CI via seam." |
| **VP-AUTHDX-012** | BC-1.4.037 (+BC-1.4.035) | SAFETY-CRITICAL | age-gate cleanup DEFAULT CI; rollback/no-split state core KEYRING-GATED; real rename Windows-only | The pair is always fully in ONE backend (never split; access write rolled back on refresh-`TooLong`); the file write is temp-then-rename so a mid-write crash leaves the OLD or NO file, never a partial; stale-temp cleanup is AGE-GATED (Pass-3 Finding #3) — a `*.tmp-*` sibling older than `STALE_TMP_THRESHOLD` (30 s) is removed while a younger one is PRESERVED (never a blanket delete). Sub-property (3) age-gate cleanup is plain-filesystem logic → DEFAULT CI (no keychain, no seam). The rollback/no-split ORDERING STATE core is **KEYRING-GATED** (`#[ignore]`+`JR_RUN_KEYRING_TESTS=1`, +`JR_FORCE_DPAPI_FALLBACK=1` on non-Windows), NOT default CI — Pass-8 Finding #1 corrects Pass-5's overstated "default-CI via seam" (the seam doesn't seam out `store_oauth_tokens`'s real keychain calls, and the mock can't persist the rollback re-read state); the real rename/fsync file mechanics stay Windows-only, unaffected by the seam. |
| **VP-AUTHDX-013** | BC-1.4.035 | COMPILE-TIME / cfg-ABSENCE | cross-platform | On `#[cfg(not(windows))]`, `dpapi::*` doesn't exist and `store_pair`/`load_pair`/`remove_if_present` do no I/O (`DpapiFallbackFailed`/`Ok(None)`/`Ok(())`) — macOS/Linux byte-for-byte unchanged — **for any profile name that PASSES `reject_unsafe_profile_component`**; a guard-REJECTING name returns `Err(ProfilePathEscape)` on every OS (Pass-9, consistent with VP-016(d) / BC-1.4.036 EC-1.4.036-7). |
| **VP-AUTHDX-014** | BC-1.4.037 | SAFETY-CRITICAL / PURE | cross-platform | `decode(encode(a,r)) == (a,r)` and `unwrap(wrap(x)) == x` for any input; malformed/unrecognized envelope → distinct `Err`, never a panic, never coerced to empty/absent. |
| **VP-AUTHDX-015** | BC-1.4.036 (co-covers BC-1.4.028) | SAFETY INVARIANT | both-absent branch DEFAULT CI (via `load_pair`-outcome injection — no keychain, NO `JR_FORCE_DPAPI_FALLBACK` env seam); exactly-one-present partial-state branch KEYRING-GATED | A present-but-undecryptable DPAPI file → distinct force-re-login error, NEVER "no token"; `Ok(Some)` load indistinguishable from keyring; `Ok(None)` falls through; amended partial-state branch applies the SAME typed distinction as the both-absent branch (3a prefer `Ok(Some)`, 3b corrupt→force-re-login, 3c backend/IO→distinct non-corruption error, 3d `Ok(None)`→partial), asserted under both keyring pre-states (Pass-4 Finding #1). Per BC-1.4.036's FOUR-WAY framing, a `load_pair` `Err` carrying a `ProfilePathEscape` is the FIRST-checked member and RENDERS as the exit-64 invalid-profile-name message — before corrupt-envelope and backend/IO — never "check file permissions" (Pass-5 Finding #2, EC-1.4.036-7; distinct from VP-016's guard-emission proof). |
| **VP-AUTHDX-016** | BC-1.4.040 | DEFENSE-IN-DEPTH (downgraded Pass-20 gate-audit, 2026-09-04, from "SECURITY INVARIANT (CWE-22) / HIGH" — the PRIMARY live gate is `validate_profile_name` / BC-6.1.004/BC-6.1.005; this guard BACKSTOPS it against a future charset/reserved-name relaxation or a validation-call-site regression, not a live CWE-22) | cross-platform / PURE | Host-independent character-level recognizer `reject_unsafe_profile_component` (NOT `std::path`, ADR-0021 §9): rejects — on ANY host, no `#[cfg(windows)]` gate — every `/` or `\` separator (incl. UNC via either), any `:` (drive-letter + NTFS ADS), empty/exact-`.`/`..`/NUL, trailing dot-or-space, and the 30-name reserved device set (ADR-0021 §9 authoritative list — 6 classic + `COM1-9` + `LPT1-9` + 6 Unicode superscript `COM¹/²/³`,`LPT¹/²/³`, leading-space-stem-trimmed) as a typed `ProfilePathEscape` → exit-64 BEFORE any FS op, at all three store entry points via `file_path`; a passing name is an opaque segment by construction (no post-hoc normalize-and-compare); ordinary names unchanged. Includes a DESIGN-CONFORMANCE assertion so a future `std::path` substitution is caught here on the Linux CI runner, not silently passed, PLUS a SEPARATE guard-WIRING oracle (Pass-4 Finding #2) calling `store_pair`/`load_pair`/`remove_if_present` directly with a guard-failing name and asserting each returns `Err`→`ProfilePathEscape` before any FS op/OS short-circuit — the wiring, not just the recognizer, is now default-CI-covered. |
| **VP-AUTHDX-017** | BC-1.4.039 | SAFETY INVARIANT | cross-platform | Sites 1/3 select the honest-fail message iff `downcast_ref::<DpapiFallbackFailed>()` is `Some` (else the unchanged "Unlock your keychain" message); the two sites use DISTINCT text (Finding #3) — Site 1 (login) instructs grant-revoke, Site 3 (refresh) MUST omit it (oracle asserts absence); Site 3 additionally clears the stale pair via `clear_profile_oauth_pair` so the next command sees "no stored OAuth token", not `invalid_grant` (Postcondition 4, Finding #7). Honest-fail reachable only when BOTH backends failed. A store error carrying a `ProfilePathEscape` RENDERS FIRST at BOTH sites as the exit-64 invalid-profile-name message — before `DpapiFallbackFailed` and before "Unlock your keychain" (Pass-5 Finding #2, EC-1.4.039-5; distinct from VP-016's guard-emission proof). |
| **VP-AUTHDX-018** | BC-1.4.038 | SAFETY INVARIANT | cross-platform (real delete Windows-only) | After `clear_profile_oauth_pair`/`clear_profile_creds`, NEITHER backend retains the pair; `NotFound` tolerated as success, a genuine FS error propagates (not swallowed); creds cleared before config entry. **Clear-path `ProfilePathEscape` tolerance (Pass-8 Findings #3/#2):** a guard-colliding name (`:`, `con`) clears to `Ok(())` with every keyring step still attempted — CROSS-PLATFORM / DEFAULT CI / NO `JR_FORCE_DPAPI_FALLBACK` seam (adapter `clear_dpapi_file_tolerating_path_escape` maps `ProfilePathEscape`→`Ok(())` like `NotFound`; guard rejects before any keychain/DPAPI touch); tolerated-`ProfilePathEscape` vs. genuine-FS-error kept provably distinct (EC-1.4.038-3); reserved-device-name case passes on Windows too; VP-016 EMITS / VP-017 RENDERS / VP-018 SWALLOWS are three independently-failing properties. |
| **VP-AUTHDX-019** | BC-1.2.052 | SAFETY INVARIANT / **HIGH** | cross-platform | `fetch_cloud_id` failure (non-2xx / network / malformed / missing field) NEVER aborts login and NEVER panics — soft-fail, cloud_id untouched, single stderr note; success overwrites; no auth header, no query string, 10s timeout; a non-`https://` (`http://`/scheme-less) `site_url` SKIPS the fetch entirely with ZERO network requests (wiremock `expect(0)`) and leaves cloud_id unchanged — same soft-fail path (Pass-4 Finding #4); `--cloud-id` override suppresses the fetch AND is itself written to `p.cloud_id` + persisted via `Config::save_global()` (Finding #8). |
| **VP-AUTHDX-020** | BC-1.2.053 | SAFETY INVARIANT / **HIGH** | cross-platform | oauth→api_token switch: fetch-success OVERWRITES stale cloud_id; fetch-failure PRESERVES the prior value (incl. `None`) — NEVER a bare clear. Extends VP-AUTHDX-003's mechanism-reconciliation harness. |
| **VP-AUTHDX-021** | BC-1.2.054 | REGRESSION PIN (confirmed-unchanged) | cross-platform | `Config::base_url()` selects the gateway iff `auth_method == "oauth"` (any other value incl. unset→api_token → site URL); `assets_base_url` is `cloud_id`-only, deliberately un-gated. Pins current behavior so a future pass cannot silently re-fix either. |
| **VP-AUTHDX-022** | BC-1.4.035 | SAFETY INVARIANT / **HIGH** | KEYRING-GATED core (real-DPAPI tail Windows-only); NO pure default-CI portion | Stale-keyring-shadow closure (Pass-3 Finding #1): given a PRE-EXISTING complete keyring pair + `TooLong` on BOTH arms (access-overflow; refresh-overflow-after-access-succeeded), after `store_oauth_tokens` both keyring keys are ABSENT, the DPAPI file holds the FRESH pair, and a subsequent `load_oauth_tokens` returns the FRESH DPAPI pair — never the stale keyring pair (no shadowing via BC-1.4.036's both-keys-present fast path); deletes keyring FIRST, so a mid-window crash leaves NEITHER backend populated. The entire routing/delete-ordering core is a pre-seed→re-read STATE property → **KEYRING-GATED** (`#[ignore]`+`JR_RUN_KEYRING_TESTS=1`, +`JR_FORCE_DPAPI_FALLBACK=1` on non-Windows), NOT default CI — Pass-8 Finding #1 corrects Pass-5's overstated "default-CI core" (the seam made the arm REACHABLE off-Windows but reaching it still needs a real keychain to observe the both-keys-absent state; the mock can't persist it — VP-005/006/007 boundary). |
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

**Honest default-CI split (Pass-8 adversarial review Finding #1, further corrected by Pass-12
adversarial review Finding #1 — supersedes the earlier "13 of 14 default CI" headline, then the
Pass-8 "10 of 14" figure, both of which OVERSTATED coverage — Pass-8 for VP-AUTHDX-011/012/022,
Pass-12 for VP-AUTHDX-015's partial-state branch):** the original tally
counted VP-AUTHDX-011, 012, and 022 as "default CI (with `JR_FORCE_DPAPI_FALLBACK=1`)." That was
wrong: `JR_FORCE_DPAPI_FALLBACK` lifts ONLY the `#[cfg(not(windows))]` cfg-gate on
`engage_dpapi_fallback` — it does NOT seam out `store_oauth_tokens`'s REAL keychain touchpoints
(`set_password` / `delete_credential_tolerating_no_entry`), and these three VPs' cores are
pre-seed→run→re-read STATE assertions ("both namespaced keyring keys ABSENT after
`store_oauth_tokens`", delete-first ordering). Exactly as cycle-003's VP-AUTHDX-005/006/007 document,
the keyring MOCK cannot persist state across `Entry::new()` and default Linux CI has no Secret
Service backend, so those STATE cores are KEYRING-GATED, not default CI. **Pass-12 Finding #1
extends the SAME reasoning to VP-AUTHDX-015:** its oracle asserts `load_oauth_tokens` behavior under
EACH of two keyring pre-states, and its exactly-one-key-present partial-state branch (BC-1.4.028)
can be reached ONLY when the keyring persists exactly one namespaced key — the identical
VP-AUTHDX-005/006/007 state-persistence boundary — so that partial-state branch is KEYRING-GATED
while the both-absent branch (which the mock supplies naturally) stays default CI; VP-AUTHDX-015 is
therefore a default-CI-portion + keyring-gated-partial-state-tail VP (same shape as
VP-AUTHDX-011/012), NOT fully default-CI. Corrected buckets:

- **Fully default-CI, no keychain-state persistence (9 of 14):** VP-AUTHDX-013 (compile-time
  cfg-absence), 014 (pure envelope), 016
  (pure recognizer + guard-WIRING oracle — the guard rejects before any keychain/FS op), 017
  (constructed-error message selection + the env-UNSET legacy-message store call that propagates
  without a state re-read), 018 (invocation/error-fold + Pass-8 clear-path `ProfilePathEscape`
  tolerance — the guard rejects before any keychain touch, so `Ok(())` is observable with no
  pre-seed), 019 (`wiremock` tenant_info), 020 (config-layer seam), 021 (`base_url()` regression
  pin), 023 (`JR_FORCE_DPAPI_FALLBACK` release-gate — a source-text-scan pin over `src/api/auth.rs`,
  host-independent and spike-independent, same class as VP-AUTHDX-010(a); Pass-6 Finding #3). These
  rely on pure functions (envelope, routing predicate, path guard), `keyring::Error` /
  `load_pair`-outcome fault-injection seams, `wiremock`, source-text scans, and the fact that on
  macOS/Linux `auth_windows_store::load_pair`→`Ok(None)` / `remove_if_present`→`Ok(())` /
  `store_pair`→`DpapiFallbackFailed` are no-ops for a profile name that PASSES `reject_unsafe_profile_component` (BC-1.4.035 Invariant 3; a guard-REJECTING name returns `Err(ProfilePathEscape)` on every OS instead — cross-ref VP-AUTHDX-016(d) / BC-1.4.036 EC-1.4.036-7) — none of them needs to
  pre-seed and re-read a stored keyring PAIR.
- **Default-CI PORTION + keyring-gated state/ordering core (3 of 14):** VP-AUTHDX-011 (sub-property
  (1)'s pure `should_fallback_to_dpapi` predicate is default CI, no seam, no keychain; sub-property
  (2)'s routing/rollback STATE core is KEYRING-GATED — `#[ignore]`+`JR_RUN_KEYRING_TESTS=1`,
  +`JR_FORCE_DPAPI_FALLBACK=1` on non-Windows), VP-AUTHDX-012 (sub-property (3)'s age-gated
  `*.tmp-*` cleanup is default CI — plain filesystem logic, no keychain, no seam; sub-property (1)'s
  no-split/rollback ORDERING state core is KEYRING-GATED, same gating; sub-property (2)'s real
  rename/fsync is Windows-only), and VP-AUTHDX-015 (Pass-12 Finding #1 — the BOTH-ABSENT branch's
  `load_pair`-outcome injection is default CI: constructed error values, no keychain, no seam; the
  EXACTLY-ONE-KEY-PRESENT partial-state branch (BC-1.4.028) is KEYRING-GATED —
  `#[ignore]`+`JR_RUN_KEYRING_TESTS=1`, with NO `JR_FORCE_DPAPI_FALLBACK` seam involved since this is
  the READ path, not the write/routing path — because reaching that branch requires the keyring to
  PERSIST exactly one namespaced key, the same VP-AUTHDX-005/006/007 state-persistence boundary the
  mock cannot satisfy).
- **Keyring-gated core + Windows-only real-DPAPI tail, NO pure default-CI portion (1 of 14):**
  VP-AUTHDX-022 — its entire routing/delete-ordering/both-keys-absent core is a pre-seed→re-read
  STATE property (KEYRING-GATED: `#[ignore]`+`JR_RUN_KEYRING_TESTS=1`, +`JR_FORCE_DPAPI_FALLBACK=1`
  on non-Windows); the seam made the delete-then-DPAPI-store arm REACHABLE off-Windows, but reaching
  it still needs a real keychain to observe the both-keys-absent state the oracle asserts. Its
  `(a)+(b)+(c)`-after-`Ok` success oracle is the additional Windows-only real-DPAPI round-trip tail
  (or cross-platform via a `load_pair` seam, still keyring-gated for the stale-pair pre-seed).
  - **Why VP-AUTHDX-011(2)/012(1)/022 are KEYRING-GATED, not default CI (Pass-8 adversarial review
    Finding #1, correcting Pass-5's overstatement).** These three cores have TWO independent gating
    dependencies, and Pass-5 accounted for only the first. **(i) Reachability (seam):** Pass-1's
    `engage_dpapi_fallback` is `#[cfg(not(windows))]`-hardcoded `false` in production, so the
    DPAPI-routing branch of `store_oauth_tokens` is dead code on any non-Windows runner unless the
    `#[cfg(debug_assertions)]`-gated `JR_FORCE_DPAPI_FALLBACK=1` opt-in test seam is engaged
    (ADR-0021 §1). **(ii) Observability (real keychain) — the dependency Pass-5 missed:** the seam
    lifts ONLY the cfg-gate; it does NOT seam out `store_oauth_tokens`'s real `set_password` /
    `delete_credential_tolerating_no_entry` keychain calls, and each core's substance is
    PRE-SEEDING a keyring pair and RE-READING keyring state to prove both keys became ABSENT
    (rollback / delete-first / no-split). Per cycle-003's VP-AUTHDX-005/006/007, the keyring MOCK
    cannot persist state across `Entry::new()` and default Linux CI has no Secret Service backend —
    so these STATE cores cannot run in default `cargo test` regardless of the seam. They are
    therefore **KEYRING-GATED** (`#[ignore]` + `JR_RUN_KEYRING_TESTS=1`, ADDITIONALLY +
    `JR_FORCE_DPAPI_FALLBACK=1` on non-Windows; on Windows the real keychain + real DPAPI make the
    seam unnecessary), mirroring the VP-AUTHDX-005/006/007 boundary. The seam is NECESSARY but NOT
    SUFFICIENT for default CI here — a real keychain is the second, independent requirement, which
    is exactly why these belong in the keyring-gated tier, not the default-CI tier. What genuinely
    needs NEITHER a keychain NOR the seam, and stays default CI: VP-AUTHDX-011's pure
    `should_fallback_to_dpapi` predicate (sub-property (1)) and VP-AUTHDX-012's age-gated `*.tmp-*`
    cleanup (sub-property (3), plain filesystem logic). VP-AUTHDX-012's real rename/fsync file
    mechanics and VP-AUTHDX-022's `(a)+(b)+(c)`-after-`Ok` success oracle remain the Windows-only
    real-DPAPI tails (a successful `store_pair` cannot happen off Windows with or without the seam).
    Each of these three VPs' oracle text in `bc-1-auth-identity.md` now states this KEYRING-GATED
    classification explicitly, so an F6 executor does not attempt to write these tests against the
    default-CI (mock, no-backend) path and discover the state is unobservable. Production/release
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
    toward the fully-default-CI bucket (the corrected "9 of 14" after Pass-12 Finding #1 moved
    VP-AUTHDX-015 to the portion+keyring-gated tier; see the Honest default-CI split above).
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
- **Windows-only / keyring-gated *portions* (5 of the cross-platform VPs' tails):** VP-AUTHDX-012's
  real `std::fs::rename`+`fsync` NTFS-atomicity step (and, if the age-gated cleanup is inlined only
  in `store_pair`'s Windows path rather than a factored directory-scan helper, its age-gate positive
  verification) and VP-AUTHDX-018's real DPAPI-file-absence-post-clear assertion each have a
  Windows-CI / keyring-gated tail beyond their cross-platform core; VP-AUTHDX-020's full
  real-keychain end-to-end oauth→api_token mechanism-switch scenario (extending
  `tests/auth_chosen_flow_reconcile.rs`'s gated tier) is a keyring-gated confirmation tail beyond
  its default-CI config-layer core (Finding #9); VP-AUTHDX-022's sub-assertions (b) "DPAPI file
  holds the fresh pair" and (c) "subsequent `load_oauth_tokens` returns the fresh DPAPI pair, not
  the stale keyring pair" are a Windows-only real-DPAPI round-trip tail (or cross-platform via a
  `load_pair` injection seam, still keyring-gated for the stale-pair pre-seed) beyond its
  delete-ordering/no-shadow-routing core — which is itself KEYRING-GATED, NOT default CI, per Pass-8
  Finding #1 (VP-AUTHDX-022 has no pure-default-CI portion). VP-AUTHDX-015's exactly-one-key-present
  partial-state branch (BC-1.4.028) is likewise a keyring-gated tail beyond its default-CI both-absent
  core: reaching that branch requires the keyring to PERSIST exactly one namespaced key — the
  VP-AUTHDX-005/006/007 state-persistence boundary the mock cannot satisfy — so it runs `#[ignore]` +
  `JR_RUN_KEYRING_TESTS=1` (no `JR_FORCE_DPAPI_FALLBACK` seam, this being the read path), while its
  both-absent-branch `load_pair`-outcome injection remains default CI (Pass-12 Finding #1). Likewise
  VP-AUTHDX-011's routing/rollback
  state core and VP-AUTHDX-012's no-split/rollback ordering state core are keyring-gated (their pure
  predicate and age-gate-cleanup portions, respectively, remain default CI).

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
- **Pass-8 adversarial-review follow-on (formal-verifier, 2026-09-03) — CI-classification only, count UNCHANGED at 55.** Finding #1 (HIGH): the "default CI" TALLY was corrected (no VP added/removed) — the earlier "13 of 14 default CI" headline OVERSTATED coverage for VP-AUTHDX-011/012/022, whose pre-seed→re-read STATE cores need a REAL keychain the `JR_FORCE_DPAPI_FALLBACK` seam does not provide (the seam lifts only `engage_dpapi_fallback`'s cfg-gate, not `store_oauth_tokens`'s real `set_password`/delete calls; the keyring mock cannot persist state across `Entry::new()` — the VP-AUTHDX-005/006/007 boundary). Honest split: **10 of 14** fully default-CI; **2 of 14** (VP-AUTHDX-011, 012) have a genuinely-default-CI PORTION (the pure `should_fallback_to_dpapi` predicate; the age-gated `*.tmp-*` cleanup) but a KEYRING-GATED state/ordering core; **1 of 14** (VP-AUTHDX-022) is keyring-gated core + Windows-only real-DPAPI tail with no pure default-CI portion; **1 of 14** (VP-AUTHDX-010) Windows-only. Finding #2 (MED): VP-AUTHDX-018 gained clear-path `ProfilePathEscape`-tolerance oracle assertions (guard-colliding name → `Ok(())`, cross-platform DEFAULT CI, no seam; tolerated-vs-genuine-error distinct; Windows too; VP-016/017/018 = three independently-failing EMITS/RENDERS/SWALLOWS properties). See the corrected "Honest default-CI split" and per-VP rows above. **(SUPERSEDED on the tally by the Pass-12 follow-on below: Pass-8's "10 of 14 / 2 of 14" figures were themselves an overstatement for VP-AUTHDX-015's partial-state branch and are corrected to "9 of 14 / 3 of 14" — see the next bullet.)**
- **Pass-12 adversarial-review follow-on (formal-verifier, 2026-09-04) — CI-classification only, count UNCHANGED at 55.** Finding #1 (MED): the Pass-8 "10 of 14 default-CI" figure still OVERSTATED coverage for VP-AUTHDX-015. Its oracle asserts `load_oauth_tokens` behavior under EACH of two keyring pre-states (BC-1.4.036 ~line 1136), and BC-1.4.028's amended partial-state branch is declared co-covered by it; the EXACTLY-ONE-KEY-PRESENT branch can be reached only when the keyring PERSISTS exactly one namespaced key — the same VP-AUTHDX-005/006/007 state-persistence boundary Pass-8 Finding #1 used to reclassify VP-AUTHDX-011/012/022's pre-seed→re-read cores. The BOTH-ABSENT branch is genuinely default CI (the mock supplies it naturally); the EXACTLY-ONE-PRESENT partial-state branch is KEYRING-GATED (`#[ignore]`+`JR_RUN_KEYRING_TESTS=1`; no `JR_FORCE_DPAPI_FALLBACK` seam — this is the READ path, not the write/routing path). VP-AUTHDX-015 is therefore reclassified from "fully default-CI" to "default-CI portion + keyring-gated partial-state tail" (same shape as VP-AUTHDX-011/012). Corrected split: **9 of 14** fully default-CI; **3 of 14** (VP-AUTHDX-011, 012, 015) default-CI portion + keyring-gated state/partial-state core; **1 of 14** (VP-AUTHDX-022) keyring-gated core + Windows-only real-DPAPI tail (no pure default-CI portion); **1 of 14** (VP-AUTHDX-010) Windows-only — sums to **14**. No VP added or removed; cumulative VP count stays **55**. Loci updated in the same pass: the vp-delta table VP-AUTHDX-015 Platform column, the "Honest default-CI split" buckets + its VP-AUTHDX-020 cross-reference, the tails section (new VP-AUTHDX-015 entry, count 4→5), and bc-1-auth-identity.md's VP-AUTHDX-015 coverage-boundary / verification-method text + Trace.

- **Pass-20 / gate-audit adversarial-review follow-on (formal-verifier, 2026-09-04) — priority-relabel only, count UNCHANGED at 55.** Applies the VP-side of the architect/product-owner gate-audit reconciliation for Finding #1 (HIGH — cross-corpus consistency / mischaracterized-threat-model, NOT a design or behavior defect). **VP-AUTHDX-016's class label is downgraded from "SECURITY INVARIANT / HIGH PRIORITY / CWE-22" to DEFENSE-IN-DEPTH** at both loci (the VP-016 row above and its oracle block in `bc-1-auth-identity.md`), and a cross-reference to **BC-6.1.004/BC-6.1.005** is added as the PRIMARY, live gate this guard backstops. The false premise "profile names are unvalidated today" is corrected: `validate_profile_name` (BC-6.1.004/BC-6.1.005, `src/config.rs`) already restricts every profile name reaching a credential-storage call site to ASCII `[A-Za-z0-9_-]` ≤64 chars with reserved-Windows-names excluded, enforced at config-load (both loaders) and at the CLI-flag/resolved-active-profile-name boundary before any subcommand dispatches — a strict superset that makes all 30 of VP-016's vectors already unreachable via any normal CLI/config path; `reject_unsafe_profile_component` is defense-in-depth against (a) a FUTURE relaxation of that validation's charset/reserved-name list or (b) a validation-call-site regression, NOT a live CWE-22 fix. **No VP oracle's asserted property is changed** — VP-016's 30-vector + separator/colon/NUL/trailing-dot-or-space rejection at all three entry points (both cfg arms), its DESIGN-CONFORMANCE and guard-WIRING sub-oracles, and its test count are UNCHANGED; only the priority/threat-model framing. A same-pass scan of every VP-AUTHDX-* oracle block (010..023) in `bc-1-auth-identity.md` and this vp-delta's rows/prose confirmed NO other oracle relies on or restates the false premise as justification: VP-AUTHDX-017 (RENDERS `ProfilePathEscape` as a distinct exit-64 message at Sites 1/3) and VP-AUTHDX-018 (SWALLOWS it → `Ok(())` on the clear path) assert behavioral EMITS/RENDERS/SWALLOWS properties that hold independently of the threat-model framing, and their BC bodies (BC-1.4.039/BC-1.4.038 Postconditions, Invariants, ECs, Related BCs, Trace) were reconciled by the architect/product-owner in the same Pass-20 round (out of formal-verifier's edit scope). No VP added or removed; cumulative VP count stays **55**.

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
