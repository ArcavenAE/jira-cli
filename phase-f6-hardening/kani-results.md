# Phase F6 — Formal Verification Results (field-dx delta)

- **Producer:** formal-verifier (Phase F6 targeted hardening)
- **Branch / commit:** `develop` @ `4e4ae4f540ed04e652ced2cf113e11f851fe6d34`
- **Scope:** field-dx bundle (issues #578, #580), delta `91d04fe1..4e4ae4f5`
- **Ground truth:** `.factory/phase-f2-spec-evolution/verification-delta-field-dx.md`
- **Information-asymmetry wall (DF-025):** No Phase F5 adversarial-review artifact was read. Coverage was verified independently from the VP catalog and the source/tests, not from any reviewer's findings.

---

## 1. Kani availability finding

**Kani is NOT set up in this repository.** Verified:

- No `kani` dependency in `Cargo.toml` (`grep -rn -i kani Cargo.toml .cargo src` → no dependency entry).
- No `#[kani::proof]` harness anywhere in `src/` or `tests/` (`grep -rn "kani::proof"` → 0 hits).
- The only `kani` mention is a documentation note in `tests/win_path_fallback_props.rs` (lines 17–21) stating explicitly: *"The crate is not wired for Kani (no `kani` dependency / harness). Property tests are the recorded method."*

### Justified substitution → proptest (repo-native property testing)

Per CLAUDE.md ("Property tests with proptest") and the repo convention documented in
`verification-delta-field-dx.md §0` ("this repository has **no standalone VP-NNN registry**;
property-style guarantees live as inline `proptest!` blocks and targeted unit/integration
tests co-located with the code, and their VP-NNN ids are declared inline in the BC bodies"),
the recorded formal-verification method for this crate is **`proptest` + targeted unit/wiremock
integration tests**, not Kani model checking.

This substitution is appropriate for the field-dx surface: the delta is dominated by
string parsing (`parse_field_kv`, hint-kind splitting, `WS:OBJ` / `Parent>Child`
composition), HTTP wire-shape composition, and CLI arity/dispatch — all of which are
naturally expressed as universally-quantified proptest properties over arbitrary UTF-8
inputs and as per-row wiremock taxonomies. There is no unbounded arithmetic, no unsafe
pointer manipulation, and no array-indexing invariant that would specifically demand a
bounded model checker. Kani would add no coverage the proptest/unit/wiremock layers do not
already provide for this delta.

---

## 2. VP → test coverage matrix (PASS / GAP)

VP ids that carry an inline VP tag in code/tests are cited by tag; VP-578-013/014 follow the
repo convention of tagging the malformed-hint / regression-pin catalog by **BC id**
(`BC-3.4.031`) rather than VP id — they are realized, not gaps.

### 2.1 Newly-minted inline VPs (`new_properties`)

| VP | Concern | Realizing test(s) | Verdict |
|---|---|---|---|
| VP-578-020 | createmeta-family multi-page resolution (FIELDS `--field` + ISSUE-TYPES `--type`), both endpoints paginated | `tests/issue_create_field.rs` two-page wiremock tests (~660, 719, 779, 860) — one per createmeta endpoint | **PASS** |
| VP-578-021 | create-path Gate-B collision guard over the 10-member governed set (any argv order × any hint kind → exit 64, zero HTTP) + negative pin | `field_resolve.rs::detect_flag_field_overlap` (201) + `tests/issue_create_field.rs` (1391, 1470, 1531, 1587, 1646) | **PASS** |
| VP-578-022 | `:asset` cold-cache workspace-discovery failure taxonomy on all 3 call sites (edit, platform-create, JSM-create) | `jsm_create.rs` (436) + `tests/issue_create_field.rs` (1066), `tests/issue_create_jsm.rs` (6645), `tests/issue_field_hint_kinds.rs` (1206) | **PASS** |
| VP-578-023 | non-cascading `>`-collision message (empty `children` → exit 64, pinned substrings) + bare-form `>`-literal fall-through + `AllowedValue.children: Vec` type dep | `tests/issue_field_hint_kinds.rs::test_bc_3_4_027_ec7_non_cascading_collision_distinct_message` (504, 566); `editmeta.rs` serde | **PASS** |
| VP-578-024 | dry-run `plannedChanges` hint-preview wire shape per kind + `:asset` cold-cache side-effect (exit-64-before-preview) | `tests/issue_field_hint_kinds.rs` (1436, 1705) | **PASS** |
| VP-580-006 | context mutual-exclusion arity guard (exactly one of type/request-type/issue), pre-HTTP | `src/cli/field.rs::resolve_field_context` (585, 822, 866) proptest + `tests/field_options.rs` | **PASS** |
| VP-580-007 | `--value` client-side substring filter correctness | `src/cli/field.rs` (1477, 1601, 1625, 1641) unit + proptest | **PASS** |
| VP-580-008 | table/JSON output shape `{id,label,children}` | `src/cli/field.rs` (1657) + `tests/field_options.rs` (2652) | **PASS** |
| VP-580-009 | `--project --request-type` together is a VALID M3, not an arity error (regression pin, realized within VP-580-006) | `tests/field_options.rs::test_bc_x_14_001_m3_project_request_type_together_is_valid` (777) | **PASS** |
| VP-580-010 | M2 post-arity project resolution (`resolve_m2_project`): flag OR profile default → Ok; neither → exit 64 pre-HTTP | `src/cli/field.rs::resolve_m2_project` (612, 1071) + `tests/field_options.rs` (474) | **PASS** |
| VP-580-011 | `--value` + graceful-degrade interaction (filter post-fetch, degrade hint still fires, stdout `[]`, exit 0) | `tests/field_options.rs` (2355) | **PASS** |
| VP-580-012 | `--project` not-found (404) taxonomy on M2 + M3 enumeration paths (regression pin, realized within VP-580-004) | `src/cli/field.rs` (300) + `tests/field_options.rs` (270, 593, 632, 1841, 1869) | **PASS** |

### 2.2 Realizations of existing inline VPs (`realizes_inline_vps`)

| VP | Concern | Realizing test(s) | Verdict |
|---|---|---|---|
| VP-578-001 | platform-create `--field` resolves via createmeta, never editmeta | `field_resolve.rs` (628) + `tests/issue_create_field.rs` (18, 663, 683, 714) | **PASS** |
| VP-578-002 | `fields.json` cache shared between edit --field and create --field | `tests/issue_create_field.rs` (611) warm-cache reuse | **PASS** |
| VP-578-003 | all-or-nothing multi-`--field` failure on create (zero POST on any failure) | `tests/issue_create_field.rs` (1326, 1379) | **PASS** |
| VP-578-004 | create-path error-taxonomy rows each independently exercised | `tests/issue_create_field.rs` (1703) per-row wiremock | **PASS** |
| VP-578-005 | hint-splitter multibyte / Unicode-scalar safety | `create.rs::prop_field_hint_split_no_panic` (1140, `\PC{0,80}`), `prop_field_hint_value_bytes_preserved` (1221) | **PASS** |
| VP-578-006 | bare-name map key last-wins across kinds (no composite-key double-apply) | `create.rs::prop_field_kv_last_wins_across_kinds` (1154) + unit (736, 748, 757) | **PASS** |
| VP-578-007 | `:option` → byte-identical to bare | `field_resolve.rs` (1103) + `tests/issue_field_hint_kinds.rs` (257) | **PASS** |
| VP-578-008 | `:option` cascading `Parent>Child` composition + D3 `>`-split no-panic | `tests/issue_field_hint_kinds.rs` (328) + `prop_cascading_split_no_panic` (470) | **PASS** |
| VP-578-009 | `:id` → `{"id":v}` verbatim, no lookup | `tests/issue_field_hint_kinds.rs` (633) | **PASS** |
| VP-578-010 | `:name` → `{"name":v}`; `--field priority:name=X` ≡ `--priority X` | `tests/issue_field_hint_kinds.rs` (689) | **PASS** |
| VP-578-011 | `:asset` → `[{workspaceId,id,objectId}]` wire shape | `tests/issue_field_hint_kinds.rs` (750) | **PASS** |
| VP-578-012 | `:asset` composer safety (never malformed JSON body) + `:`-split no-panic | `tests/issue_field_hint_kinds.rs::prop_asset_composer_no_malformed_json_ever` (1150) + unit (885, 1134) | **PASS** |
| VP-578-013 | malformed-hint catalog → exit 64, one error/invocation | `create.rs` `test_bc_3_4_031_ec1/ec5/ec2a` (765, 795, 906, 981) + `tests/issue_field_hint_kinds.rs` `test_bc_3_4_031_ec2a/b/c/d/ec3` (892, 940, 984, 1037, 1081) | **PASS** (BC-tagged) |
| VP-578-014 | EC-6/EC-7 regression pins (colon-in-VALUE resolves; unknown-kind fires specific error) | `create.rs::test_bc_3_4_031_ec6_colon_in_value_resolves_normally` (819), `test_bc_3_4_031_ec7_multi_colon_name_fires_unknown_kind_not_other_error` (840); `tests/issue_field_hint_kinds.rs::test_ec6_ec7_ec8_ec9_regression_at_edit_call_site` (1776) | **PASS** (BC-tagged) |
| VP-578-017 | DEC-310 reversal: `--field` alone → exit 0, platform POST | `tests/issue_create_field.rs` (378, 430) + `tests/issue_create_jsm.rs` (2570, 2909, 2994) | **PASS** |
| VP-578-018 | DEC-310 reversal: `--field --on-behalf-of` → exit 64 via standalone guard | `tests/issue_create_field.rs` (445, 488) + `tests/issue_create_jsm.rs` (2794) | **PASS** |
| VP-578-019 | DEC-310 reversal regression pin: `--on-behalf-of` alone → exit 64 | `tests/issue_create_field.rs` (506, 542) | **PASS** |
| VP-580-005 | graceful degrade: no enumerable options → exit 0, no panic | `src/cli/field.rs` (1120, 1183, 1210, 1236, 1268) + `tests/field_options.rs` degrade tests | **PASS** |

### 2.3 JSM-parity pair (`aligns_with_inline_vps`)

| VP | Concern | Realizing test(s) | Verdict |
|---|---|---|---|
| VP-578-015 | JSM parity — bare-form byte-identical (relative parity claim) | `src/api/jsm/requests.rs` (127) + `tests/issue_create_jsm.rs` (5469, 5727, 5782, 6979, 7057) | **PASS** |
| VP-578-016 | JSM parity — `:id`/`:name`/`:asset` → `requestFieldValues` wire target | `src/api/jsm/requests.rs` (129, 180, 206) + `tests/issue_create_jsm.rs` (5483, 5586, 6057, 7078, 7144) | **PASS w/ documented caveat** — **UNVERIFIED / parity-PENDING by spec design** (F2 reframe, §1.1): JSM `requestFieldValues` WRITE wire shapes are NOT research-verified and are intentionally realized/verified at F4 against live JSM, not pinned firm at F2. This is an intentional deferral in the VP catalog, **not** an F6 coverage gap. |

### 2.4 Coverage summary

- **32 declared inline VPs** in the field-dx delta inventory (VP-578-001..024 + VP-580-005..012).
- **All 32 have realizing proptest/unit/wiremock coverage in the tree** at `4e4ae4f5`.
- **PASS: 31/32** with firm coverage; **1/32 (VP-578-016)** is PASS-with-caveat — coverage exists but the JSM write wire-shape is a spec-intended F4/live-validation deferral (UNVERIFIED/PENDING), not an accidental omission.
- **GAP: 0.** No field-dx VP is left without a property/test realization.

**Mutation-scope note (informational, not a gap):** `.cargo/mutants.toml` `examine_globs`
includes `create.rs`, `edit.rs`, and `jsm_create.rs` but **not** `field_resolve.rs` or
`field.rs`. Mutation testing runs under the PR-diff-scope policy
(`docs/specs/cargo-mutants-policy.md`), which is out of scope for this F6 proptest/regression
pass; flagged here only so a future mutants-scope review can decide whether the two new
field-dx modules warrant addition to `examine_globs`.

---

## 3. Field-dx proptests — execution

All field-dx property tests are present, arbitrary-input, and panic-free:

- `parse_field_kv` surface (in `src/cli/issue/create.rs`): `prop_field_hint_split_no_panic`
  (`\PC{0,80}`), `prop_field_hint_value_bytes_preserved` (value `\PC{0,40}`),
  `prop_field_kv_last_wins_across_kinds`, plus the pre-existing
  `prop_parse_field_kv_no_panic_on_arbitrary_input` / `_first_equals_split` /
  `_empty_value_allowed` / `_last_value_wins_on_duplicates`.
- `:option` cascading split (in `tests/issue_field_hint_kinds.rs`):
  `prop_cascading_split_no_panic` (`[^\x00]{0,24}`).
- `:asset` composer (in `tests/issue_field_hint_kinds.rs`):
  `prop_asset_composer_no_malformed_json_ever` (`prop_oneof![5 => "[^\x00]{0,24}", 2 => "[0-9]{1,10}"]`).

These execute as part of the full suite (below); no field-dx proptest failed.

---

## 4. Full regression result

`cargo test` (full suite) on `develop` @ `4e4ae4f5`:

- **Result: PASS — exit code 0.**
- **4660 passed; 0 failed; 106 ignored** (ignored = the gated keyring / OAuth / live-E2E `#[ignore]` tests), aggregated across **111 test-result lines** (lib unit tests + 108 integration test binaries + doctests).
- Zero `FAILED` lines; no panics.
- The field-dx proptests (`prop_field_hint_split_no_panic`, `prop_field_hint_value_bytes_preserved`, `prop_field_kv_last_wins_across_kinds`, `prop_cascading_split_no_panic`, `prop_asset_composer_no_malformed_json_ever`) executed within this run and passed.

Note: a first full-suite invocation's captured log was truncated by harness/output handling (17 binaries captured, all green, no EXIT marker). This clean re-run is the authoritative result: exit 0, 0 failures across the entire suite.

---

## 5. F6 gate assessment

- **Kani setup present:** No (justified proptest substitution documented, §1).
- **VP coverage:** 31/32 firm PASS, 1/32 PASS-with-intended-deferral (VP-578-016 JSM write shape, F4/live-validation-PENDING per spec). **0 GAPs.**
- **CRITICAL/HIGH gaps that should block F6:** **None.**
