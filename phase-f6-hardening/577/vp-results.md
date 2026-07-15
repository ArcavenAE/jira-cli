---
phase: f6-targeted-hardening
dimension: vp-verification
bundle: SOH-COMMENT-CRUD-1
issue: "#577"
head_sha: ae2e3db
vp_range: VP-577-001..030
proven_by_test: 30
gaps: 0
date: 2026-07-14
verdict: PASS
---

# F6 Dimension — Verification-Property Sweep (VP-577-001..030)

Every VP defined in `.factory/specs/prd/bc-3-issue-write.md` for the
SOH-COMMENT-CRUD-1 bundle is traced to at least one committed test. All proving
tests are in the full-regression suite exercised in Dimension 5 (green). No
unexplained gaps. Several visibility/wire-shape VPs additionally carry
live-probe evidence in the gated `tests/e2e_live.rs` (F4/F5 nightly EJ probe).

## Trace table

| VP | Status | Proving test(s) |
|----|--------|-----------------|
| VP-577-001 | PROVEN-BY-TEST | `comment_edit.rs::test_bc_3_5_005_ec1_put_request_has_only_body_key`; `comment_crud_api.rs::test_update_comment_body_only_no_properties_key` (PUT body key-set == `{"body"}`) |
| VP-577-002 | PROVEN-BY-TEST + LIVE | `comment_crud_api.rs::test_update_comment_internal_properties_wire_shape`; `comment_edit.rs::test_bc_3_5_006_internal_puts_properties_true` + `_changed_fields_jsm_internal_true` (internal:true bool, key-set `{"body","properties"}`). Live: `e2e_live.rs::test_e2e_comment_edit_visibility_merge_semantics` |
| VP-577-003 | PROVEN-BY-TEST + LIVE | `comment_crud_api.rs::test_update_comment_public_properties_wire_shape`; `comment_edit.rs::test_bc_3_5_007_public_puts_properties_false` + `_changed_fields_jsm_internal_false` (internal:false bool). Live: `test_e2e_comment_edit_visibility_merge_semantics` (Scenario 3) |
| VP-577-004 | PROVEN-BY-TEST | `comment_delete.rs::test_bc_3_5_004_delete_404_exits_64_with_body` (dual-line stderr: preamble + Jira body) |
| VP-577-005 | PROVEN-BY-TEST | `comment_delete.rs::test_bc_3_5_003_no_input_without_yes_exits_64_no_delete` (`.expect(0)` on DELETE) |
| VP-577-006 | PROVEN-BY-TEST | `comment_edit.rs::test_bc_3_5_008_public_no_input_without_yes_exits_64` (dual-pin: `"visibility to public"` + `"--yes"`, `.expect(0)` on PUT) |
| VP-577-007 | PROVEN-BY-TEST + LIVE | `comment_view.rs::test_bc_3_5_010_ec1_json_output_passthrough` (`expand=properties` in request URL; `properties[0].value.internal == true`). Live: `test_e2e_jsm_comment_visibility` |
| VP-577-008 | PROVEN-BY-TEST | `cli_smoke.rs::test_bc_3_5_012_old_flat_comment_form_exits_2_with_migration_hint` (exit 2 + ``use `jr issue comment add` instead``) |
| VP-577-009 | PROVEN-BY-TEST | `comment_delete.rs::test_bc_3_5_002_delete_204_json_output_key_set` (key-set `{"deleted","id","key"}`) + `_delete_204_human_output_yes` |
| VP-577-010 | PROVEN-BY-TEST | `comment_edit.rs::test_bc_3_5_011_internal_and_public_clap_exit_2` (`--internal --public` → exit 2, `"cannot be used with"`) |
| VP-577-011 | PROVEN-BY-TEST | `comment_edit.rs::test_bc_3_5_009_ec1_file_not_found_exits_64` (`--file /nonexistent` → exit 64, no PUT) |
| VP-577-012 | PROVEN-BY-TEST | `comment_edit.rs::test_bc_3_5_009_ec5_empty_whitespace_body_exits_64` (`"   "` → exit 64, `"comment body cannot be empty"`) |
| VP-577-013 | PROVEN-BY-TEST | `comment_delete.rs::test_bc_3_5_003_interactive_cancel_json_key_set` (cancel envelope `{"cancelled","deleted"}`; `JR_STDIN_IS_TTY` seam) |
| VP-577-014 | PROVEN-BY-TEST | `cli_smoke.rs::test_bc_3_5_012_bare_comment_emits_clap_listing_not_custom_hint` (bare `comment` → clap listing, no custom hint prefix) |
| VP-577-015 | PROVEN-BY-TEST | `cli_smoke.rs::test_bc_3_5_012_comment_list_token_emits_plural_hint` (`comment list` → `"jr issue comments"`) |
| VP-577-016 | PROVEN-BY-TEST | `comment_view.rs::test_bc_3_5_010_ec1_json_output_passthrough` (`"self"` field survives — lossless `Value` passthrough) |
| VP-577-017 | PROVEN-BY-TEST | `comment_edit.rs::test_bc_3_5_008_ec3_stdin_without_yes_public_exits_64` (both variants: `--public --stdin` w/o `--yes` → exit 64, `"--stdin"`+`"--yes"`; + `JR_STDIN_IS_TTY=1` variant) |
| VP-577-018 | PROVEN-BY-TEST | `cli_smoke.rs::test_bc_3_5_012_comment_add_allows_leading_dash_body` (`"- [ ] task"` parses, not exit 2) |
| VP-577-019 | PROVEN-BY-TEST | `cli_smoke.rs::test_bc_3_5_012_comment_edit_allows_leading_dash_body` (`"- update"` parses) |
| VP-577-020 | PROVEN-BY-TEST | `cli_smoke.rs::test_bc_3_5_012_comment_ls_mixed_case_emits_plural_hint` (`ls`/`LS` → plural hint; `eq_ignore_ascii_case`) |
| VP-577-021 | PROVEN-BY-TEST | `comment_view.rs`: `_view_human_render_all_seven_fields` (v1), `_body_rendered_with_blank_line_separator` (v1), `_body_absent_empty_block_stdout_ends_restricted_none` + `_degraded_fixture_fallback_tokens` (v2), `_jsm_internal_na_when_no_properties` (v3), `_restricted_ladder_rung_a` (v4–6), `_jsm_internal_no_when_internal_false` (v7), `_jsm_internal_yes_when_internal_true` (v1) — all 7 variants |
| VP-577-022 | PROVEN-BY-TEST | three-command regex pin: `comment_delete.rs::test_bc_3_5_002_ec1_delete_invalid_id_regex_exits_64`, `comment_edit.rs::..._edit_...`, `comment_view.rs::..._view_...` (3 tests confirmed present) |
| VP-577-023 | PROVEN-BY-TEST | `comment_edit.rs::test_bc_3_5_005_edit_response_exact_key_set` (key-set `{"changed_fields","id","key","updated"}`) + `_edit_changed_fields_body_is_raw_pre_trim` (raw whitespace preserved) |
| VP-577-024 | PROVEN-BY-TEST | `comment_edit.rs::test_bc_3_5_005_put_404_exits_64_with_dual_stderr` (PUT 404 → exit 64, dual-line) |
| VP-577-025 | PROVEN-BY-TEST | `comment_edit.rs::test_bc_3_5_006_jsdcloud_hint_appears_on_internal` (v1: `"(marked internal)"`+`"JSDCLOUD-6050"`) + `_007_jsdcloud_hint_appears_on_public_yes` (v2: `--public --yes` still hints) |
| VP-577-026 | PROVEN-BY-TEST | `comment_edit.rs::test_bc_3_5_006_changed_fields_jsm_internal_true` (v1), `_007_changed_fields_jsm_internal_false` (v2), `_005_jsm_internal_absent_in_default_path` (v3: key omitted) |
| VP-577-027 | PROVEN-BY-TEST | `comment_delete.rs::test_bc_3_5_002_ec2_delete_key_url_encoding` (CLI-level `MY%20KEY-1`) + `comment_crud_api.rs::test_delete_comment_encodes_key_with_space_in_url` (API-level) |
| VP-577-028 | PROVEN-BY-TEST | `comment_edit.rs::test_bc_3_5_008_ec4_yes_without_public_is_silent_noop` (v1: one PUT hit) + `_runtime_probe_exit64` (v2: `--yes` w/o `--public`, empty body → exit 64 not 2, proves no `requires("public")`) |
| VP-577-029 | PROVEN-BY-TEST | `comment_edit.rs::test_bc_3_5_008_public_interactive_cancel_json_key_set` (cancel envelope `{"cancelled","updated"}`; `JR_STDIN_IS_TTY=1`) |
| VP-577-030 | PROVEN-BY-TEST | `comment_delete.rs::test_bc_3_5_003_ec3_delete_prompt_eof_exits_130` (v1) + `comment_edit.rs::test_bc_3_5_008_ec5_public_prompt_eof_exits_130` (v2) — EOF → `JrError::Interrupted` exit 130 |

## Coverage notes

- **All 30 VPs PROVEN-BY-TEST. Zero GAPs, zero unexplained DEFERRED.**
- **Live-probe reinforcement (not the primary proof):** VP-577-002/003/007/026/027
  are additionally exercised by the gated `tests/e2e_live.rs` functions
  (`test_e2e_comment_edit_visibility_merge_semantics`,
  `test_e2e_jsm_comment_visibility`,
  `test_e2e_write_flow_create_edit_comment_worklog_close`,
  `test_e2e_issue_comment_input_channels`). These run only under `JR_RUN_E2E=1`
  + `JR_E2E_JSM_PROJECT` (nightly `e2e.yml`); they are inert in `cargo test` and
  are NOT counted as the primary VP proof — the wiremock subprocess tests above
  are the CI-blocking proof. The MERGE-vs-PRESERVE properties-merge semantics
  (JSDCLOUD server behavior) can only be *fully* confirmed live, hence the
  live-probe supplement.
- **Test types:** VPs 008/010/014/015/018/019/020 are parse-level (wiremock-free);
  the rest are wiremock subprocess tests (`assert_cmd` + `wiremock`) or pure-fn
  unit tests. Interactive-branch VPs (013/017v2/029/030) rely on the
  `JR_STDIN_IS_TTY` debug seam, release-gated by
  `tests/jr_stdin_is_tty_release_gate.rs`.

## Verdict

**PASS** — 30/30 VPs traced to committed tests; 0 gaps; live-probe supplements
present for the server-dependent visibility/merge properties.
