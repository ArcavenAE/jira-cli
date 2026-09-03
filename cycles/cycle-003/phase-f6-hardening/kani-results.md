# F6 Formal Verification (Kani) — cycle-003 `auth-profile-dx`

- **Baseline:** `87f17aff` (v0.7.0-dev.3) → **HEAD:** `202414f2` (develop tip)
- **Date (UTC):** 2026-09-02
- **Verifier:** formal-verifier (F6 targeted hardening)

## Method: JUSTIFIED PROPTEST/UNIT-TEST SUBSTITUTION

Following the documented **cycle-002 precedent**, Kani model checking is substituted by
property-based (`proptest`) and example-based unit/integration tests.

### Justification

1. **No `#[kani::proof]` harnesses exist anywhere in the repo.** `grep -rn "kani::proof|#[kani"
   src/ tests/` returns zero harnesses. The only `kani` token in the tree is a comment in
   `tests/win_path_fallback_props.rs:21` that explicitly records proptest as the chosen
   verification method (no kani dependency/harness). No Kani harnesses were authored for the
   cycle-003 delta, and none pre-exist for the auth cluster.
2. **The delta surface is structured API + keychain I/O, not arithmetic/memory-safety-dense
   code.** Kani's comparative advantage (exhaustive proof of overflow/underflow, OOB access,
   bit-level state-machine invariants) has no purchase on the cycle-003 delta: the changed code
   is credential-string routing (`store_api_token`/`load_api_token` namespacing), an
   `Option::unwrap_or` fallback literal, a 2×3 flag/mechanism matrix, and a tolerant TOML
   deserialization field. These are exactly the invariant classes `proptest` covers naturally
   and that Kani would require heavy stubbing of the keyring backend to reach.
3. **Every cycle-003 VP already specifies `proptest`/keyring-gated integration as its
   verification method** (see the `**Verification method**` clause on each VP in
   `bc-1-auth-identity.md` / `bc-6-config-cache.md`). The spec authors did not designate any
   VP for formal (Kani) proof. Honoring the spec's declared method is the correct action, not
   inventing a Kani harness the spec never asked for.

## VP-AUTHDX-001..009 → covering-test map

| VP | Property (abridged) | Covering test(s) | Default-CI? |
|----|---------------------|------------------|-------------|
| VP-AUTHDX-001 | Non-interactive invocation never launches OAuth browser flow (SAFETY) | `tests/auth_oauth_default_creation.rs::test_vp_authdx_001_noninteractive_default_reaches_token_path_not_oauth` (proptest, 20 cases); airtight-guard cells at BC-1.1.016 (`tests/auth_oauth_default_creation.rs` tier-1e) | **YES** — deliberately NOT keyring-gated (property proven from error SHAPE, no keyring touched) |
| VP-AUTHDX-002 | Runtime `auth_method` default stays byte-identical `"api_token"` (regression pin) | `tests/auth_oauth_default_creation.rs::test_vp_authdx_002_profile_config_auth_method_none_falls_back_to_api_token` (proptest); `test_ac_009_from_config_resolves_api_token_when_auth_method_absent_end_to_end`; `tests/api_token_percred_wiring.rs::test_from_config_api_token_branch_reads_namespaced_never_legacy_flat` | **YES** (proptest tier); keychain companion gated |
| VP-AUTHDX-003 | `auth_method` intrinsic — no per-command mechanism override (SAFETY) | `tests/auth_chosen_flow_reconcile.rs::test_vp_authdx_003_refresh_mechanism_never_follows_the_flag_only_the_profile` (proptest, 2×3 matrix, 32 cases) + 2 fixed seeds (`..._api_token_profile_with_oauth_flag`, `..._oauth_profile_with_api_token_flag`) | **YES** (proptest + fixed seeds); tier-3 keyring companion gated |
| VP-AUTHDX-004 | Per-profile API-token store/load round-trip + cross-profile isolation (SECURITY) | `src/api/auth.rs::percred_proptests::prop_bc_1_4_031_round_trip_and_cross_profile_isolation` (proptest, bounded generators); direct cases `load_api_token_cross_profile_isolation`, `store_api_token_overwrites_unconditionally`, `load_api_token_propagates_backend_error_not_absent_message` | **GATED** — real OS keychain, no in-memory seam (documented boundary) |
| VP-AUTHDX-005 | Detect-and-instruct: no legacy pair ever read/copied (SAFETY-CRITICAL) | `src/api/auth.rs::absence_guard_proptests::prop_vp_authdx_005_detect_and_instruct_correctness` (proptest); direct cases `test_bc_1_4_032_*` | **GATED** (documented boundary, spec §"Coverage boundary, keyring-gated") |
| VP-AUTHDX-006 | No profile special-cased; `"default"` behaves identically (SAFETY) | `src/api/auth.rs::absence_guard_proptests::prop_vp_authdx_006_no_profile_is_special_cased` (proptest); `test_bc_1_4_032_default_profile_not_special_cased_identical_to_other_profiles` | **GATED** (documented boundary) |
| VP-AUTHDX-007 | Mandatory keyring-gated end-to-end detect-and-instruct SCENARIO | `src/api/auth.rs::test_vp_authdx_007_keyring_gated_end_to_end_detect_and_instruct_scenario` | **GATED by design** — the VP is *defined* as the real-backend scenario (macOS Keychain / Windows Cred Mgr / Linux Secret Service) |
| VP-AUTHDX-008 | No-half-credential safety, namespaced-pair case (SAFETY) | `src/api/auth.rs::absence_guard_proptests::prop_vp_authdx_008_namespaced_partial_state_safety` (proptest); `test_bc_1_4_033_namespaced_partial_*` | **GATED** (documented boundary) |
| VP-AUTHDX-009 | `ProfileConfig.env` tolerant-reader + round-trip over full input space | `src/config.rs::proptests_env_tag::{prop_profile_config_env_absent_key_always_none, prop_profile_config_env_some_round_trips, prop_profile_config_env_none_round_trips_as_none}` (proptest, 1000 cases) | **YES** |

## Coverage boundary (documented, NOT a gap)

VP-AUTHDX-004/005/006/007/008 execute **only** under `#[ignore]` + `JR_RUN_KEYRING_TESTS=1`
(real-OS-keychain-gated) and do NOT run in default `cargo test`. This is a **spec-declared
coverage boundary**, not an F6 gap: each of these VPs carries an explicit
`**Coverage boundary, keyring-gated (F5 adversarial review fix, cycle-003, MED-2)**` clause
stating that `store_api_token`/`load_api_token` read/write the real OS keychain with no
in-memory injection seam, and the keyring mock cannot persist state across `Entry::new()`. A
keychain injection seam that would let these run in-CI is a tracked follow-up. VP-AUTHDX-007 is
gated *by definition* (it exists precisely to prove the logic against the real backend). The
default-CI-covered VPs (001, 002, 003, 009) exercise the same logic layers through
non-keychain seams (error shape, `Option` semantics, tolerant deserialization).

## GAP count

**0 GAP.** Every VP-AUTHDX-001..009 has covering test coverage. Four VPs (001, 002, 003, 009)
are default-CI-covered; five (004, 005, 006, 007, 008) are keyring-gated per the spec's own
documented coverage boundary.

## Verdict

**PASS (Kani-substitution).** Justified proptest/unit-test substitution per cycle-002
precedent; 0 unmapped VPs; substitution rationale recorded above.
