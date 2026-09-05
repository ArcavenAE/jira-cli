# F6 Formal Verification (Kani) — cycle-004 `windows-correctness`

- **Baseline:** `42e92b46` (v0.7.0-dev.4) → **HEAD:** `3b62cefa` (develop tip)
- **Date (UTC):** 2026-09-05
- **Verifier:** formal-verifier (F6 targeted hardening)
- **Information-asymmetry wall:** VP coverage derived from the SPEC (`vp-delta.md` +
  `bc-1-auth-identity.md` oracles) and the delta's own test bodies — NOT from any F5
  adversarial finding.

## Method: JUSTIFIED PROPTEST / UNIT-TEST SUBSTITUTION (Kani skip)

Kani model checking is substituted by property-based (`proptest`) and example-based
unit/integration tests, following the **documented cycle-002 and cycle-003 precedent**
(`.factory/cycles/cycle-003/phase-f6-hardening/kani-results.md`).

### Skip justification

1. **No `#[kani::proof]` harnesses exist anywhere in the repo.** `grep -rn "kani::proof\|#\[kani"
   src/ tests/` returns zero harnesses; Kani is not a dependency in `Cargo.toml` and no Kani
   toolchain is provisioned in CI. No Kani harness pre-exists for the auth cluster, and none
   was authored for the cycle-004 delta.
2. **Every cycle-004 VP declares `proptest` / unit / keyring-gated integration as its
   verification method** — none designates formal (Kani) proof. `vp-delta.md` §"Cross-platform
   testability boundary" enumerates the method for all 14 VPs (pure functions, `keyring::Error`
   / `load_pair`-outcome fault-injection seams, `wiremock`, source-text scans, Windows-compiled
   unit pin). Honoring the spec's declared method is correct; inventing a Kani harness the spec
   never asked for is not.
3. **The delta surface is structured credential I/O + a small parse surface, not
   arithmetic/memory-safety-dense code.** Kani's comparative advantage (exhaustive
   overflow/OOB/bit-level state-machine proof) has no purchase on: DPAPI envelope
   encode/decode + magic/version framing, a `keyring::Error::TooLong` routing predicate, a
   character-level profile-name recognizer, a `/_edge/tenant_info` HTTPS fetch with a 64 KiB
   body cap, and a UUID-shape plausibility check. These are exactly the invariant classes
   `proptest` covers naturally and that Kani would require heavy stubbing (keyring backend,
   Win32 DPAPI syscalls, reqwest streaming) to reach. The one true round-trip invariant that
   *would* suit Kani — `decode(encode(a,r)) == (a,r)` — is already discharged by a `proptest`
   over the full input space (`prop_envelope_encode_decode_round_trip`,
   `prop_envelope_wrap_unwrap_round_trip` with `any::<u8>()` 0..8000-byte ciphertext).

## VP-AUTHDX-010..023 → covering-test map (14 new VPs)

| VP | Property (abridged) | Covering test(s) | Default-CI? |
|----|---------------------|------------------|-------------|
| **010** | DPAPI round-trip + USER-scope only, never `LOCAL_MACHINE` (sub-prop (a) = the security bit) | `auth_windows_store::win_tests::test_dpapi_protect_flags_never_set_local_machine_bit` (Windows-compiled, spike-independent); `test_dpapi_protect_unprotect_real_round_trip` (Windows real-syscall tail) | **Windows-only** (sub-prop (a) is Windows-*compiled*, not headless-dependent) |
| **011** | `should_fallback_to_dpapi` true iff `TooLong`; whole-pair routing, no pre-flight guess | `test_should_fallback_to_dpapi_true_for_toolong`; `test_should_fallback_to_dpapi_false_for_every_other_variant`; routing STATE core: `auth::…::test_store_oauth_tokens_*_overflow_deletes_stale_pair_and_routes_to_dpapi` | predicate **YES**; routing/rollback core **keyring-gated** |
| **012** | Pair always in ONE backend; temp-then-rename; age-gated stale-`*.tmp-*` cleanup | `test_cleanup_stale_tmp_siblings_removes_only_stale_entries` (age-gate, default CI); `test_atomic_write_no_tmp_file_left_behind_on_success`; `test_atomic_write_creates_final_file_with_exact_contents`; `test_atomic_write_round_trips_after_parent_dir_fsync_added` | age-gate + atomic-write **YES**; no-split ordering core **keyring-gated**; real rename **Windows-only** |
| **013** | `#[cfg(not(windows))]`: `dpapi::*` absent; `store/load/remove` do no I/O for guard-passing name | `test_non_windows_store_pair_returns_dpapi_fallback_failed_for_valid_name`; `test_non_windows_load_pair_returns_ok_none_for_valid_name`; `test_non_windows_remove_if_present_returns_ok_for_valid_name` | **YES** |
| **014** | `decode(encode(a,r))==(a,r)`, `unwrap(wrap(x))==x`; malformed→distinct `Err`, never panic/empty | `prop_envelope_encode_decode_round_trip`; `prop_envelope_wrap_unwrap_round_trip`; unit: `test_envelope_decode_rejects_{structurally_malformed_json,json_missing_access_field,json_missing_refresh_field,empty_input,binary_garbage_with_high_bytes}`, `test_envelope_unwrap_rejects_{truncated_header,bad_magic,unrecognized_version}`, `test_envelope_wrap_prepends_jrod_magic` | **YES** |
| **015** | Undecryptable DPAPI file → force-re-login, never "no token"; `Ok(Some)`≈keyring; `Ok(None)` falls through; partial-state typed distinction | both-absent branch via `load_pair`-outcome injection: `auth::…::test_classify_corrupt`, `test_corrupt_secret_file_error_message_names_profile`; partial-state branch keyring-gated (`test_bc_1_4_033_namespaced_partial_*`) | both-absent **YES**; exactly-one-present partial-state **keyring-gated** |
| **016** | Host-independent `reject_unsafe_profile_component` (separators/colon/NUL/trailing dot-or-space/30 reserved names) + guard-WIRING + design-conformance | `prop_reject_unsafe_profile_component_acceptance_implies_opaque_segment`; unit set `test_reject_unsafe_profile_component_*` (all 30 device names, both separators, colon-everywhere, leading-space stem); `test_design_conformance_std_path_would_wrongly_accept_windows_vectors_on_this_host`; wiring: `test_guard_wiring_{store_pair,load_pair,remove_if_present}_rejects_bad_profile_before_anything_else` | **YES** |
| **017** | Sites 1/3 select honest-fail iff `DpapiFallbackFailed`; distinct text; Site 3 omits grant-revoke + clears stale pair; `ProfilePathEscape` renders first | `auth::…::test_bc_1_4_039_site1_dpapi_fallback_failed_recommends_scoped_cleanup_by_default`; `…_site3_dpapi_fallback_failed_omits_grant_revoke`; `…_site1_and_site3_dpapi_messages_are_textually_distinct`; `…_ac_007_plain_toolong_without_marker_uses_legacy_message`; `…_site1_dpapi_fallback_failed_clears_nothing`; `tests/oauth_refresh_integration.rs` (Site 3 clear, keyring-gated tail) | **YES** (message selection); real-clear tail keyring-gated |
| **018** | `clear_*`: neither backend retains pair; `NotFound` tolerated, genuine FS error propagates; `ProfilePathEscape` tolerated→`Ok(())` | `auth::…::test_clear_dpapi_file_tolerating_path_escape_maps_guard_rejection_to_ok`; `test_clear_profile_oauth_pair_succeeds_for_guard_colliding_profile_name`; `test_clear_profile_creds_succeeds_for_reserved_device_name`; `test_bc_1_2_014_clear_profile_creds_*`; `test_ac_002_clear_profile_creds_propagates_genuine_backend_error_not_swallowed`; `classify_dpapi_removal_*` set | **YES** (real delete Windows-only tail) |
| **019** | `fetch_cloud_id` failure never aborts login / never panics — soft-fail; non-`https` skips fetch (0 requests); `--cloud-id` suppresses + persists | `tests/cloud_id_tenant_info.rs` (wiremock: non-2xx / network / malformed / missing field / body-cap / `expect(0)` on http scheme); `tenant::tests::test_validate_and_trim_site_url_*`, `test_is_plausible_cloud_id_*` | **YES** |
| **020** | oauth→api_token switch: fetch-success overwrites stale cloud_id; failure preserves prior (incl. `None`), never bare clear | `tests/auth_chosen_flow_reconcile.rs` (config-layer overwrite/preserve via wiremock seam) | **YES** (config-layer core); full real-keychain E2E keyring-gated tail |
| **021** | `base_url()` gateway iff `auth_method=="oauth"`; `assets_base_url` cloud_id-only (regression pin) | `src/config.rs` + `src/api/client.rs` regression assertions (VP-AUTHDX-021 tags) | **YES** |
| **022** | Stale-keyring-shadow closure: after `TooLong` on both arms, both keyring keys absent, DPAPI holds fresh pair, load returns fresh; delete keyring FIRST | `auth::…::test_store_oauth_tokens_{refresh,access}_overflow_deletes_stale_pair_and_routes_to_dpapi`; `test_store_oauth_tokens_toolong_on_fresh_profile_leaves_no_keyring_remnant` | **keyring-gated** core + Windows-only real-DPAPI tail (no pure default-CI portion, per Pass-8) |
| **023** | `JR_FORCE_DPAPI_FALLBACK` debug-seam release-gate: `#[cfg(debug_assertions)]` within 5 lines of env read | `tests/jr_force_dpapi_fallback_release_gate.rs` (source-text scan) | **YES** |

## Coverage boundary (documented, NOT a gap)

Per the spec's own **honest default-CI split** (`vp-delta.md`, corrected through Pass-8 and
Pass-12): **9 of 14** VPs are fully default-CI; **3 of 14** (011, 012, 015) have a
default-CI portion + a keyring-gated state/partial-state core; **1 of 14** (022) is
keyring-gated core + Windows-only real-DPAPI tail with no pure default-CI portion; **1 of 14**
(010) is Windows-only (with sub-property (a) — never-`LOCAL_MACHINE` — spike-independently
covered by a Windows-*compiled* unit pin). The keyring-gated cores run only under `#[ignore]`
+ `JR_RUN_KEYRING_TESTS=1` (+ `JR_FORCE_DPAPI_FALLBACK=1` on non-Windows for the write/routing
path) — the same VP-AUTHDX-005/006/007 real-OS-keychain boundary documented since cycle-003
(the keyring mock cannot persist state across `Entry::new()`; default Linux CI has no Secret
Service backend). This is a **spec-declared coverage boundary**, not an F6 gap.

## GAP count

**0 GAP.** Every VP-AUTHDX-010..023 has a covering `proptest` and/or unit/integration test
present in the delta (all 14 VP IDs are referenced from `src/` and/or `tests/`, and each maps
to concrete named test functions above). The default-CI portion of every VP runs in ordinary
`cargo test` on macOS/Linux; the keyring-gated cores and the Windows-only DPAPI-syscall tails
execute under their declared gates.

## Verdict

**PASS (Kani-substitution).** Justified proptest/unit-test substitution per cycle-002/003
precedent; 0 unmapped VPs; substitution rationale recorded above.
