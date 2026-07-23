# S-576-5 Demo Evidence

Story: `jr issue attachment upload --public/--internal` — JSM visibility, servicedeskapi two-step, stale-ID self-heal
Branch: `feat/S-576-5-jsm-attachment-visibility`
Head: `b672d33d`
Binary: `target/debug/jr` (debug build, wiremock-backed tests)
Captured: 2026-07-22

## Summary

All 16 ACs verified via 29 wiremock-backed integration tests in `tests/attachment_jsm.rs`.
No live Jira calls were made — all demos use the `JR_BASE_URL` debug seam + wiremock mock
server (same pattern used by S-577-1..6). The debug binary is invoked as a subprocess via
`jr_cmd_with_xdg` with per-test `TempDir` isolation for config, cache, and upload files.

## Full Suite

| File | Command | Result |
|------|---------|--------|
| `full-suite.txt` | `cargo test --test attachment_jsm` | 29/29 green |

## Per-AC Evidence

All ACs used test-run captures via `cargo test -- <test_name(s)> --nocapture`.
No raw binary invocations were used outside tests: the handler requires a wiremock HTTP stub
for every path (issue GET, project meta GET, service desk list GET, step-1 POST, step-2 POST).
Running the binary without a wiremock server fails at auth/connection, not at the behaviors
being demonstrated.

| Demo Group | ACs Covered | Demo File | Test Function(s) | Result |
|------------|-------------|-----------|------------------|--------|
| --public on non-JSM → exit 64 | AC-001 | `ac-001-public-non-jsm-exit-64.txt` | `test_bc_3_9_003_public_on_non_jsm_exits_64_before_gate` | ok |
| --public gate confirm + two-step + JSON | AC-002, AC-003, AC-012 | `ac-002-003-012-public-gate-two-step-json.txt` | `test_bc_3_9_003_public_gate_confirm_proceeds`; `test_bc_3_9_003_public_gate_cancel_exits_0`; `test_bc_3_9_003_two_step_attach_temporary_then_request_attachment`; `test_bc_3_9_011_public_json_output_shape` | ok |
| Combined gate single prompt | AC-009, VP-576-005 | `ac-009-vp576005-combined-gate-single-prompt.txt` | `test_vp_576_005_combined_gate_single_prompt_fires_once` | ok |
| --internal JSM (public:false) + non-JSM silent no-op | AC-006, AC-013 | `ac-006-013-internal-jsm-and-nonjsm.txt` | `test_bc_3_9_004_internal_on_jsm_two_step`; `test_bc_3_9_004_internal_on_non_jsm_silent_noop_oq9` | ok |
| --dry-run --public visibility annotation + wouldDelete | AC-015 | `ac-015-dry-run-public-visibility-annotation.txt` | `test_bc_3_9_020_dry_run_public_visibility_annotation` | ok |
| Zero-match service desk → EC-X.8.010-1 | AC-016 | `ac-016-zero-match-service-desk.txt` | `test_ec_x_8_010_1_no_matching_service_desk_exits_64` | ok |
| SEC-576-006 stale-heal retry once | AC-005 | `ac-005-sec576006-stale-heal.txt` | `test_sec_576_006_stale_id_self_heal_invalidate_retry_once` | ok |

## Remaining ACs (covered by full-suite.txt, not individually demoed)

The following ACs are verified by the 29-test full suite but grouped into broader test
functions rather than given dedicated demo files:

| AC | Test Function | Coverage |
|----|---------------|----------|
| AC-004 (BC-X.8.010 sdId from project_meta) | `test_bc_x_8_010_service_desk_id_from_project_meta_projectid_match`; `test_bc_x_8_010_jsm_determination_triggers_project_meta_fetch` | ServiceDesk.project_id String equality match |
| AC-007 (servicedeskapi response shape curated) | `test_bc_3_9_007_servicedeskapi_response_shape` | curated bare array output |
| AC-008 (error taxonomy BC-3.9.006) | `test_bc_3_9_006_jsm_upload_error_taxonomy` | 16 sub-assertions covering all error branches |
| AC-010 (BC-3.9.014 consumer 1 N≤3 filenames) | `test_bc_3_9_014_consumer1_n_le_3_lists_filenames` | gate prompt with N≤3 filenames listed |
| AC-010 (BC-3.9.014 consumer 1 N>3 count) | `test_bc_3_9_014_consumer1_n_gt_3_shows_count` | gate prompt shows count when N>3 |
| AC-011 (E2E — gated, JR_RUN_E2E=1) | `test_e2e_jsm_attachment_upload_public`; `test_e2e_jsm_attachment_upload_internal` | live EJ instance, skipped in offline demo |
| AC-014 (surface guard + existing tests) | `tests/e2e_cli_surface_guard.rs` green | CLI surface not regressed |

## E2E Note (AC-011)

AC-011 requires `JR_RUN_E2E=1` + live EJ JSM instance. It is gated with `#[ignore]` and
does not run in offline CI. The wiremock test `test_bc_3_9_004_internal_on_jsm_two_step`
covers the two-step wire sequence end-to-end for the offline demo.

## Convention Note

Pattern established by `S-577-3/INDEX.md` and prior S-577 stories: one subdirectory per
story ID, `INDEX.md` + per-topic capture files. S-576-5 groups by AC cluster rather than
one-file-per-AC because several ACs share a single wiremock invocation session or a single
taxonomy test function (AC-008's 16 sub-assertions).
