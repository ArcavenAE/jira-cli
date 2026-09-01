---
document_type: f7-traceability-chain-delta
feature: field-dx (GitHub #578 + #580)
spec_files: [".factory/specs/prd/bc-3-issue-write.md", ".factory/specs/prd/cross-cutting.md"]
spec_version_field_dx: v1.3.107 -> v1.3.164 (bc-3-issue-write.md, DEC-188/DEC-310 amendment trail)
bc_index_total: 719 (unchanged through F4/F5/F6 — field-dx BCs already counted at F2 close)
pr: "#739, #740, #741, #742, #746 (5 stories) + #747 (FIX-F5-001), #749 (FIX-F6-001), #750 (FIX-F7-001)"
develop_tip: 2000c455
activation_version: v0.7.0-dev.2
date: 2026-08-31
producer: state-manager (F7 delta traceability synthesis)
status: see delta-convergence-report.md
---

# Traceability Chain — field-dx Delta

4-level hierarchy (BC -> VP -> test -> src) for each of the 5 field-dx stories, plus
cross-references (DEC-310 reversal, S-578-4's dependency on S-580-1/S-578-2, and the
`field_resolve.rs` module shared by the edit and create paths). This file is the
bundle-prefixed F7 traceability record for cycle-002's field-dx bundle, following the
naming convention already established by `bucket1-defects-traceability-chain-delta.md`,
`components-traceability-chain-delta.md`, and `soh-attachments-1-traceability-chain-delta.md`
in this same directory (no cycle-level generic `traceability-chain-delta.md` filename is
reused for a bundle-specific record).

---

## S-578-1 — `--field NAME:kind=VALUE` hint-syntax parser (closes #578 part 1, PR #739 @ `993de833`)

```
BC-3.4.026 (NEW: NAME:kind=VALUE hint-shape grammar — last-':'-before-'=' split isolates
            NAME from an optional :kind tag; bare form with no kind tag unchanged;
            multibyte-safe UTF-8 boundary split; ADR-0019 §2(b) last-wins on duplicate NAME
            across kinds)
BC-3.4.031 (NEW: FieldValueKind enum — id/name/option/asset; unrecognized kind tag falls
            through as literal ':' in NAME, case-sensitive lowercase-only kind match)
  -> STORY S-578-1 (.factory/stories/S-578-1-field-value-kind-hint-parser.md, 5 pts, P1)
  -> src/cli/issue/create.rs (FieldValueSpec/FieldValueKind types + parse_field_kv extension,
                              last-':'-before-'=' split, char_indices multibyte-boundary walk,
                              last-wins across-kind map collapse)
  -> inline #[cfg(test)] unit tests in src/cli/issue/create.rs, incl.:
       test_bc_3_4_026_first_equals_then_last_colon_split                (VP-578-005)
       test_bc_3_4_026_multi_colon_name_isolates_kind_from_last_colon    (VP-578-005)
       test_bc_3_4_026_bare_form_no_kind_tag_unchanged                  (VP-578-005)
       test_bc_3_4_026_last_wins_across_kinds_single_map_entry          (VP-578-006)
       test_bc_3_4_026_kind_validation_case_sensitive_lowercase_only    (VP-578-013)
     plus a proptest suite (multibyte-safety property, duplicate-NAME-across-kinds
     property) pinned at VP-578-005 property 3 / VP-578-006 PROPTEST form (~L1132-1250)
  -> VP-578-014 (bare-form fallthrough when the ':' tag doesn't match a known kind) realized
     by test_bc_3_8_008_missing_equals_error_includes_actionable_guidance and the bare-form
     regression pin above
  -> PR #739 (993de833), CI green; consumed downstream by S-578-2/S-578-3/S-578-4 (blocks
     all three per this story's frontmatter `blocks:` list)
```

## S-580-1 — `jr field options <field>` command (closes #580, PR #740 @ `74221bbc`)

```
BC-X.14.001 (NEW: M1/M2/M3 context-mechanism resolution — createmeta PRIMARY for platform
             projects, requesttype-fields PRIMARY for JSM, editmeta FALLBACK)
BC-X.14.002 (NEW: option enumeration output shape, human + --output json)
BC-X.14.003 (NEW: cascading-select child enumeration, `>` delimiter per ADR-0019)
BC-X.14.004 (NEW: field-name resolution reuses partial_match; ambiguous/zero-match exit 64)
  -> STORY S-580-1 (.factory/stories/S-580-1-field-options-command.md, 8 pts, P1)
  -> src/cli/field.rs (jr field options handler; get_createmeta_fields all-pages pagination;
                       M1 editmeta reuse for an existing issue; M2 profile-default-project
                       resolution reusing the S-331 type-resolution path; M3 requires_service_desk
                       gate for JSM projects)
  -> tests/field_options.rs (51 tests), incl.:
       test_bc_x_14_001_field_name_human_name_resolves_via_partial_match  (VP-580-005)
       test_bc_x_14_001_field_name_ambiguous_exits_64                     (VP-580-005)
       test_bc_x_14_001_field_name_zero_match_exits_64                    (VP-580-005)
       test_bc_x_14_001_get_createmeta_fields_paginates_all_pages         (VP-580-006)
       test_bc_x_14_001_get_createmeta_fields_continues_pagination_when_total_absent
                                                                            (VP-580-006, F5-001 fix)
       test_bc_x_14_001_get_createmeta_fields_hard_cap_prevents_infinite_loop (VP-580-006)
       test_bc_x_14_001_get_createmeta_fields_empty_page_terminates_not_infinite_loop
                                                                            (VP-580-006)
       test_bc_x_14_001_m1_issue_reuses_get_editmeta                      (VP-580-007)
       test_bc_x_14_001_m1_stray_project_harmlessly_ignored               (VP-580-007)
       test_bc_x_14_001_m2_resolves_via_profile_default_project           (VP-580-008)
       test_bc_x_14_001_m2_type_resolution_reused_from_s331               (VP-580-008)
       test_bc_x_14_001_m3_non_jsm_project_exits_64_require_service_desk  (VP-580-009)
       test_bc_x_14_001_m3_project_request_type_together_is_valid         (VP-580-010)
       test_bc_x_14_001_customfield_bypass_skips_list_fields              (VP-580-011)
       test_bc_x_14_001_empty_field_name_exits_64_zero_http               (VP-580-012)
  -> PR #740 (74221bbc), CI green; 5 non-blocking pr-reviewer nits tracked as
     S-580-1-PR740-S1/S2/S3/N1/N2 (STATE.md Drift/Standing Items)
  -> `get_createmeta_fields` (this story's `src/cli/field.rs`) is the SAME pagination
     helper S-578-4's platform createmeta resolution and VP-578-020's fields-page≥2 test
     reuse — no duplicated pagination logic across the two stories
```

## S-578-2 — `issue edit --field` hint-kind dispatch + cascading select + dry-run (closes #578 part 3, PR #741 @ `a3739763`)

```
BC-3.4.015 (AMENDED: hinted-field bypass runs before bare dispatch; dry-run runs inside the
            hinted-resolution block)
BC-3.4.016 (AMENDED: bare '>' literal fallthrough when not a recognized cascading hint)
BC-3.4.021 (AMENDED: dry-run preview shape extended to all 4 hint kinds — option/id/name/asset)
BC-3.4.027 (NEW: cascading-select `>` split-once wire shape; second `>` is a verbatim child
            value, not a further cascade level)
BC-3.4.028 (NEW: :id / :name hint-kind dispatch against editmeta allowedValues)
BC-3.4.029 (NEW: :asset hint-kind dispatch — WORKSPACE:OBJECT composite resolution)
BC-3.4.030 (NEW: :asset cold-cache error-mapping taxonomy — 401/403/404/5xx/network,
            standard auth-error mapping reused, empty-workspace edge case)
BC-3.4.031 (shared with S-578-1 — FieldValueKind dispatch consumed here)
  -> STORY S-578-2 (.factory/stories/S-578-2-edit-field-hint-dispatch.md, 13 pts, P1,
                    depends_on: [S-578-1])
  -> src/cli/issue/field_resolve.rs (resolve_edit_fields hint-kind dispatch: :option cascading
                                     split, :id/:name against editmeta.allowedValues, :asset
                                     WORKSPACE:OBJECT L2 composite via compose_asset_hint)
  -> tests/issue_field_hint_kinds.rs (36 tests), incl.:
       test_bc_3_4_015_hinted_bypass_runs_before_bare_dispatch              (VP-578-007)
       test_bc_3_4_015_dry_run_hinted_field_resolution_runs_inside_dry_run_block (VP-578-007)
       test_bc_3_4_015_bare_form_greater_than_is_literal_falls_through_to_ec_3_4_016_2
                                                                              (VP-578-008)
       test_bc_3_4_021_dry_run_option_hint_cascading_preview_shape          (VP-578-009)
       test_bc_3_4_021_dry_run_option_hint_non_cascading_preview_shape      (VP-578-009)
       test_bc_3_4_021_dry_run_id_hint_preview_shape                       (VP-578-009)
       test_bc_3_4_021_dry_run_name_hint_preview_shape                     (VP-578-009)
       test_bc_3_4_021_dry_run_asset_hint_preview_shape                    (VP-578-009)
       test_bc_3_4_027_cascading_split_once_wire_shape                     (VP-578-010)
       test_bc_3_4_027_cascading_second_greater_than_is_verbatim_child     (VP-578-010)
       test_bc_3_4_027_ec1_array_type_reuses_ec_3_4_015_5_message          (VP-578-011)
       test_bc_3_4_027_ec1_gate_runs_before_allowed_values_children_inspection (VP-578-011)
       test_bc_3_4_030_jsm_path_asset_cold_cache_401_standard_auth_mapping (VP-578-012)
       test_bc_3_4_030_jsm_path_asset_cold_cache_403_404_assets_unavailable (VP-578-012)
       test_bc_3_4_030_jsm_path_asset_cold_cache_5xx_network_standard_mapping (VP-578-012)
       test_bc_3_4_030_jsm_path_asset_cold_cache_empty_workspace           (VP-578-012)
  -> VP-578-022/023/024 (cross-cutting: shared editmeta resolver reuse, error-taxonomy
     parity with S-578-4's create-path :asset dispatch) realized jointly with S-578-3/S-578-4
     coverage in tests/issue_create_field.rs and tests/issue_create_jsm.rs (see below)
  -> PR #741 (a3739763), CI green; 7 non-blocking pr-reviewer nits tracked as
     S-578-2-PR741-RESIDUAL-NITS; SEC-001-EDITMETA-RECURSION-GUARD (LOW, security follow-up)
     opened against AllowedValue.children deserialization depth, cross-referenced by F6's
     SEC-F6-2
```

## S-578-3 — JSM `issue create --field` hint-kind uniformity (closes #578 part 4, PR #742 @ `41763ff0`)

```
BC-3.8.008 (AMENDED: JsmRequestBuilder::build() extra_fields serialization now kind-aware —
            :asset bare-form/explicit-workspace L2 resolution parity with the edit path;
            D2 collision-guard decision F-3 RESOLVED — retain pre-existing last-wins, no
            guard extension for the JSM create path)
  -> STORY S-578-3 (.factory/stories/S-578-3-jsm-create-field-hint-dispatch.md, 8 pts, P1,
                    depends_on: [S-578-1])
  -> src/api/jsm/requests.rs (JsmRequestBuilder::build kind-aware extra_fields serialization;
                              resolve_asset_field_l2 workspace-ID resolution, parallel to but
                              NOT sharing code with field_resolve.rs::compose_asset_hint —
                              tracked as S-578-3-SHARED-ASSET-VALIDATOR, LOW, deferred)
  -> tests/issue_create_jsm.rs, incl.:
       test_bc_3_8_008_asset_bare_form_l2_resolves_workspace_before_build   (VP-578-015)
       test_bc_3_8_008_asset_explicit_workspace_l2_composes_no_cache_lookup (VP-578-015)
       test_vp_578_015_bare_field_byte_identical_pre_post_amendment        (VP-578-015)
       test_ec_3_8_008_asset_empty_objectid_with_colon_exits_64_zero_post  (VP-578-016)
       test_ec_3_8_008_asset_empty_value_exits_64_zero_post                (VP-578-016)
       test_ec_3_8_008_asset_empty_workspace_segment_exits_64_zero_post    (VP-578-016)
       test_ec_3_8_008_asset_extra_colon_exits_64_zero_post                (VP-578-016)
       test_ec_3_8_008_asset_non_numeric_objectid_exits_64_zero_post       (VP-578-016)
  -> VP-578-016 carries an intended parity-PENDING deferral (F6 formal-verifier PASS-with-
     intended-deferral, not a GAP) — documented in phase-f6-hardening/kani-results.md
  -> VP-578-022 (cross-cutting error-taxonomy parity, shared with S-578-2/S-578-4)
  -> PR #742 (41763ff0), CI green; 3 non-blocking items tracked: S-578-3-SHARED-ASSET-VALIDATOR
     (LOW), S-578-3-FIELDVALUESPEC-RELOCATION (LOW, architectural), S-578-3-PR742-RESIDUAL-NITS
     (LOW)
```

## S-578-4 — platform `issue create --field` (non-JSM) path (closes #578 part 5, DEC-310, PR #746 @ `ae8514b8`)

```
BC-3.3.010 (NEW: platform create-path --field resolves via createmeta, never editmeta;
            fields.json cache SHARED with edit --field, same profile; all-or-nothing
            multi-field failure; hint-kinds id/name/option/asset all available on create)
BC-3.3.011 (NEW: create-path --field error-taxonomy — 10 rows, each independently exercised)
BC-3.4.014 (AMENDED: field echo extended to bare + all 4 hint kinds on the create path,
            JSON mode unchanged — no changed_fields key)
BC-3.8.012 (REVERSED in place, DEC-310 reverses DEC-188: --field-alone platform-create
            exit-64 pre-flight guard REMOVED; `[DEC-188 BEHAVIOR, 2026-05..2026-08-25]`
            historical section retained; guard now resolves via createmeta instead of
            rejecting)
BC-3.8.013 (AMENDED alongside BC-3.8.012 — --on-behalf-of-alone guard unaffected by DEC-310,
            still exits 64 without --request-type; only the --field-alone half reversed)
  -> STORY S-578-4 (.factory/stories/S-578-4-platform-create-field-support.md, 13 pts, P0,
                    depends_on: [S-580-1, S-578-2])
  -> src/cli/issue/create.rs (handle_create create-path createmeta resolution fork;
                              detect_flag_field_overlap D2 collision guard)
  -> src/cli/issue/field_resolve.rs (resolve_against_createmeta — shared resolution engine,
                                     reused from S-578-2's editmeta-based resolve_edit_fields;
                                     eq_ignore_ascii_case issue-type casefold, diverging from
                                     field.rs's to_lowercase() — tracked LOW,
                                     F5-ISSUETYPE-CASEFOLD-SPLIT)
  -> tests/issue_create_field.rs (37 tests) + tests/issue_create_jsm.rs (create-path parity
     assertions), incl.:
       test_bc_3_3_010_source_substitution_createmeta_not_editmeta       (VP-578-001)
       test_bc_3_3_010_cache_first_field_name_resolution                 (VP-578-002)
       test_bc_3_3_010_two_names_same_field_id_resolve_like_edit_no_false_screen_error
                                                                           (VP-578-002)
       test_bc_3_3_010_customfield_bypass_on_create                      (VP-578-003)
       test_bc_3_3_010_field_resolution_ordering_after_project_type_before_post (VP-578-003)
       test_bc_3_3_011_error_taxonomy_all_10_rows                        (VP-578-004)
       test_bc_3_3_010_create_post_body_wire_shape_id                    (VP-578-017)
       test_bc_3_3_010_create_post_body_wire_shape_name                  (VP-578-017)
       test_bc_3_3_010_create_post_body_wire_shape_option                (VP-578-017)
       test_bc_3_3_010_create_post_body_wire_shape_asset                 (VP-578-017)
       test_bc_3_3_010_hint_kinds_available_on_platform_create           (VP-578-018)
       test_bc_3_3_010_type_dispatch_shares_resolve_edit_fields_createmeta_source
                                                                           (VP-578-019)
       test_bc_3_4_014_field_echo_bare_and_hinted_per_kind               (VP-578-019)
       test_bc_3_4_014_field_echo_cascading_option                      (VP-578-019)
       test_bc_3_4_014_field_echo_asset_composite                       (VP-578-019)
       test_bc_3_4_014_json_mode_unchanged_no_changed_fields_key         (VP-578-019)
       (VP-578-020, NEW at adversary pass-28/29 F-1) two-page createmeta wiremock tests,
         one per endpoint (fields page≥2, issue-types page≥2) — see
         .factory/phase-f2-spec-evolution/verification-delta-field-dx.md §VP-578-020 for
         the full wiremock-fixture citation, realized in tests/issue_create_field.rs
       test_vp578021 negative-pin display-name-spelling-does-not-trip-guard test in
         tests/issue_create_field.rs (VP-578-021; carries the tracked LOW weak-assertion
         item F5-VP578021-WEAK-NEGPIN — asserts only !requests.is_empty(), not exit-0/
         POST-body/last-wins residual)
       test_bc_3_4_030_create_path_asset_cold_cache_401_standard_auth_mapping (VP-578-022,
         create-path parity with S-578-2's edit-path VP-578-012 coverage)
       test_bc_3_4_030_create_path_asset_cold_cache_403_404_assets_unavailable (VP-578-022)
       test_bc_3_4_030_create_path_asset_cold_cache_5xx_network_standard_mapping (VP-578-022)
       test_ac12_help_text_substring_count_is_1_on_behalf_of_only (BC-3.8.013 regression pin —
         confirms the --on-behalf-of guard is UNAFFECTED by DEC-310)
  -> holdout anchors H-NEW-PREFLIGHT-001..006 (BC-3.8.012/013 pre-flight guard scenarios,
     DEC-188-era, re-validated post-DEC-310 reversal for the --field-alone half)
  -> PR #746 (ae8514b8), CI green
  -> FIX-F5-001, PR #747 @ 4e4ae4f5: `get_issue_types_for_project` pagination-termination
     bound + total-absent heuristic, mirroring get_createmeta_fields (F5 MEDIUM finding,
     shared fix across S-580-1's and S-578-4's createmeta-family pagination)
  -> FIX-F6-001, PR #749 @ dd311e13: .cargo/mutants.toml examine_globs gained
     src/cli/field.rs + src/cli/issue/field_resolve.rs (18->20); numeric mutation run
     93/93 caught, 0 missed on both newly-covered files
  -> FIX-F7-001, PR #750 @ 2000c455: create.rs size-deviation CLAUDE.md write-up +
     DEC-310 pre-flight note + field-dx CHANGELOG entries (documentation-only, no BC/test
     change)
```

---

## Cross-References

- **DEC-310 reverses DEC-188** (STATE.md Decisions Log): DEC-188 (2026-05..2026-07, issue
  #639) introduced the platform-create `--field`-alone / `--on-behalf-of`-alone exit-64
  pre-flight guard (BC-3.8.012/013). DEC-310 (registered 2026-08-25/26, human-approved at the
  F2 gate) reverses ONLY the `--field`-alone half in place: non-JSM `--field` support was the
  entire point of issue #578, and the DEC-188 guard predates that scope and would otherwise
  block it needlessly. The `--on-behalf-of`-alone half of BC-3.8.013 is explicitly UNAFFECTED
  — it still exits 64 without `--request-type`, pinned by `test_ac12_help_text_substring_count_is_1_on_behalf_of_only`
  in S-578-4's test suite. `bc-3-issue-write.md` line ~75 documents the DEC-307->DEC-310
  renumbering (DEC-307 was found already allocated); the historical `[DEC-188 BEHAVIOR,
  2026-05..2026-08-25]` section is retained in place in BC-3.8.012's body rather than deleted,
  per the repo's amendment-not-erasure convention for BC history.

- **S-578-4 depends_on S-580-1 and S-578-2** (frontmatter `depends_on: [S-580-1, S-578-2]`):
  S-578-4's platform createmeta resolution reuses `get_createmeta_fields` (introduced by
  S-580-1's `src/cli/field.rs` for the `jr field options` command, including the F5-001
  pagination-termination fix) and reuses the hint-kind dispatch engine
  `field_resolve.rs::resolve_edit_fields`-family functions (introduced by S-578-2 for
  `issue edit --field`). Wave scheduling in `cycles/cycle-002/burst-log.md` reflects this:
  S-580-1 (Wave 1) and S-578-2 (Wave 2) both merged before S-578-4 (Wave 3) began.

- **`field_resolve.rs` shared by edit AND create** (S-578-2 introduces it for `issue edit
  --field`; S-578-4 extends it with `resolve_against_createmeta` for `issue create --field`):
  both call sites share the same hint-kind dispatch primitives (`:option` cascading split,
  `:id`/`:name` allowedValues matching, `:asset` L2 composite resolution via
  `compose_asset_hint`), differing only in the metadata SOURCE (`editmeta` for edit,
  `createmeta` for create per BC-3.3.010's explicit "never editmeta" requirement). This is
  the mechanism behind VP-578-002's cache-sharing guarantee (a `fields.json` cache populated
  by `edit --field` satisfies `create --field` for the same profile) and VP-578-019's
  `resolve_edit_fields`/createmeta-source reuse assertion. The one deliberately NOT-shared
  sibling is `S-578-3`'s JSM-path `resolve_asset_field_l2` in `src/api/jsm/requests.rs` —
  parallel logic, tracked as the LOW `S-578-3-SHARED-ASSET-VALIDATOR` deferred item (both F5
  and F6 cross-referenced this as the same underlying candidate, not duplicated findings).

- **VP-578-020 (createmeta-family multi-page pagination, adversary pass-28/29 F-1)** spans
  BOTH the FIELDS half (`get_createmeta_fields`, shared with S-580-1) and the ISSUE-TYPES half
  (`get_issue_types_for_project`, shared with the pre-existing S-331 bulk `--type` resolution
  and fixed for the total-absent case by FIX-F5-001) — attribution is synced to BC-3.3.010 at
  C-LOW severity, not split across two BC citations.

- **No Kani proof harness applies to this codebase** (thin HTTP client, no `unsafe`, no Kani
  infrastructure repo-wide, per CLAUDE.md architecture) — that level of a hypothetical 6-level
  chain is N/A by design across all 5 stories, consistent with the components-mgmt and
  bucket1-defects bundles' own traceability records in this same directory.

- **No cycle-level master traceability-chain file existed prior to this pass** — this F7 pass
  is the first to populate `.factory/cycles/cycle-002/convergence/traceability-chain.md`; the
  new links above are APPENDED there (not replacing any prior content, since none existed).
