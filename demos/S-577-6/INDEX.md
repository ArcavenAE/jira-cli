# S-577-6 Demo Evidence

Story: `comment view` handler  
Branch: `feat/comment-view-handler`  
Head: `9a82e84`  
Test file: `tests/comment_view.rs` (14 subprocess tests)  
Lib-unit: `src/cli/issue/interactions.rs` `#[cfg(test)]` (1 tier-i test)  
Captured: 2026-07-13

## Full Suite

| File | Command | Result |
|------|---------|--------|
| `full-suite.txt` | `cargo test --test comment_view` + `cargo test --lib -- test_bc_3_5_010_ec2a_adf_error_propagates_exit64` | 15/15 green (14 subprocess + 1 lib-unit) |

## Per-AC Evidence

All 11 story ACs use test-run captures via `cargo test -- <test_fn> --nocapture`.
No raw binary invocations: handler tests require a wiremock HTTP stub. Running the
raw binary without wiremock would fail on auth/connection.

AC-007 uses two tiers: (i) lib-unit in `interactions.rs` (programmatic ADF construction
bypasses serde 128-limit; calls adf_to_text directly); (ii) subprocess in
`tests/comment_view.rs` (pins boundary behavior: 129-deep JSON → serde parse error → exit 1).

| AC | BC Anchor | Demo File | Test Function(s) | Tier | Result |
|----|-----------|-----------|-----------------|------|--------|
| AC-001 | BC-3.5.010 | `AC-001.txt` | `test_bc_3_5_010_view_human_render_all_seven_fields` | subprocess | PASS |
| AC-002 | BC-3.5.010 Field-5 Yes | `AC-002.txt` | `test_bc_3_5_010_jsm_internal_yes_when_internal_true` | subprocess | PASS |
| AC-003 | BC-3.5.010 Field-5 No | `AC-003.txt` | `test_bc_3_5_010_jsm_internal_no_when_internal_false` | subprocess | PASS |
| AC-004 | BC-3.5.010 Field-5 N/A | `AC-004.txt` | `test_bc_3_5_010_jsm_internal_na_when_no_properties` | subprocess | PASS |
| AC-005 | BC-3.5.010 Field-6 | `AC-005.txt` | `test_bc_3_5_010_restricted_ladder_rung_a` (rung a) | subprocess | PASS |
| AC-005 | BC-3.5.010 Field-6 | `AC-005.txt` | `test_bc_3_5_010_restricted_ladder_rung_b` (rung b) | subprocess | PASS |
| AC-005 | BC-3.5.010 Field-6 | `AC-005.txt` | `test_bc_3_5_010_restricted_ladder_rung_c` (rung c) | subprocess | PASS |
| AC-005 | BC-3.5.010 Field-6 | `AC-005.txt` | `test_bc_3_5_010_restricted_ladder_rung_d` (rung d) | subprocess | PASS |
| AC-006 | BC-3.5.010 Field-7 | `AC-006.txt` | `test_bc_3_5_010_body_rendered_with_blank_line_separator` | subprocess | PASS |
| AC-007 | EC-3.5.010-2a | `AC-007.txt` | `test_bc_3_5_010_ec2a_adf_error_propagates_exit64` | lib-unit (tier i) | PASS |
| AC-007 | EC-3.5.010-2a | `AC-007.txt` | `test_bc_3_5_010_ec2a_deep_json_parse_error_exits_1` | subprocess (tier ii) | PASS |
| AC-008 | BC-3.5.010 404 | `AC-008.txt` | `test_bc_3_5_010_404_exits_64_with_body_surface` | subprocess | PASS |
| AC-009 | EC-3.5.010-1 / VP-577-016 / VP-577-007 | `AC-009.txt` | `test_bc_3_5_010_ec1_json_output_passthrough` | subprocess | PASS |
| AC-010 | EC-3.5.002-1 VP-577-022c | `AC-010.txt` | `test_bc_3_5_002_ec1_view_invalid_id_regex_exits_64` | subprocess | PASS |
| AC-011 | VP-577-021 variant 2 | `AC-011.txt` | `test_bc_3_5_010_body_absent_empty_block_stdout_ends_restricted_none` | subprocess | PASS |

**Total: 11/11 ACs covered. 15/15 test functions green.**

## Extra Test (Not AC-Mapped)

One additional test in `tests/comment_view.rs` beyond the 14 AC-mapped ones:

| Test | Purpose |
|------|---------|
| `test_bc_3_5_010_degraded_fixture_fallback_tokens` | Graceful-degradation tokens: absent `id`/`created`/`updated` → "N/A"; null `author` → "Unknown". Kills mutants on fallback arms. |

Passes in `full-suite.txt`.

## Key Implementation Notes

- AC-007 tier (i): `MAX_ADF_DEPTH` is `pub(crate)` — inaccessible from integration tests.
  The lib-unit constructs a 257-deep `serde_json::Value` programmatically (depth counting,
  not constant reference) and calls `adf_to_text` directly to verify the depth-guard
  error path maps to `UserError` / exit-64 class.
- AC-007 tier (ii): a 129-deep JSON body string (built from raw string concatenation to
  bypass `json!` macro limits) causes serde's 128-level recursion limit to fire BEFORE
  `adf_to_text` is reached — resulting in `JrError::Json` → exit 1, not exit 64. This
  is an implementation fact documented in the story and pinned by the subprocess test.
- AC-009: `query_param("expand", "properties")` matcher on the wiremock mock verifies
  the URL query parameter at the HTTP level — the mock only matches when the parameter
  is present, ensuring the `get_comment` call in S-577-2 passes it correctly.
- AC-010: GET mock has `.expect(0)` — wiremock auto-verifies on drop that zero requests
  were received, confirming `validate_comment_id` fires before any HTTP call.
