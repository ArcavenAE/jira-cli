---
document_type: red-gate-log
level: ops
version: "1.0"
status: final
producer: state-manager
timestamp: "2026-09-13T00:00:00"
phase: 3
inputs: []
input-hash: "d41d8cd"
traces_to: "S-cycle12-platform-adf-autoconvert"
stub_architect_agent: "stub-architect (cycle-012)"
stub_compile_verified: true
test_writer_agent: "test-writer (cycle-012)"
red_gate_verified: true
---

# Red Gate Log: S-cycle12-platform-adf-autoconvert

## Summary
| Story | Tests Written | All Fail (Red)? | Gate |
|-------|---------------|-----------------|------|
| S-cycle12-platform-adf-autoconvert | 19 story tests | YES | PASS |

## Context
- **Cycle:** cycle-012
- **Wave:** 1
- **Mode:** strict TDD
- **Worktree branch:** `feature/S-cycle12-platform-adf-autoconvert` (off `develop@30bb1a18`)
- **Stub commit:** `bce6e4d2`
- **Test commit:** `0208b81a`

## Stubs Created (bce6e4d2)

### S-cycle12-platform-adf-autoconvert
- `fn is_adf_schema(…)` — module-private; detects ADF schema structure
- `fn is_adf_field(…)` — module-private; detects whether a field name is on the ADF allowlist
- `fn is_adf_field_value(…)` — `pub(crate)`; detects whether a resolved value should be treated as ADF
- `field_markers: BTreeMap<…>` — added to `FieldResolutionOutputs`; tracks per-field ADF metadata
- `editmeta.rs` — `Option<String>` for relevant field already present (pre-existing)

## Red Gate Verification

### Compile check
- `cargo test --no-run` — **PASS** (dead-code warnings on unused stubs only; no errors)

### Inline tests — `src/cli/issue/field_resolve.rs` (4 tests)

| AC | Test | Outcome |
|----|------|---------|
| AC-001 | `prop_bc_3_4_033_is_adf_field_fires_only_on_allowlist` | FAIL (expected — `todo!()` panic) |
| AC-002 | `test_bc_3_4_033_is_adf_field_allowlist_positive_and_negative_anchors` | FAIL (expected — `todo!()` panic) |
| AC-003 | `prop_bc_3_4_033_dispatch_field_value_adf_backed_returns_adf_object` | FAIL (ASSERTION: "expected ADF doc object, got String") |
| AC-004 | `test_adf_empty_guard_fires_only_on_bare_form_not_hinted_platform` | FAIL (expected) |

### Integration tests — `tests/issue_edit_field_adf.rs` (10 tests)

| AC | Test | Outcome |
|----|------|---------|
| AC-005 | `test_bc_3_4_033_edit_field_adf_converts_markdown_to_adf_on_adf_schema` | FAIL (assertion vs current `Value::String`) |
| AC-006 | `test_bc_3_4_033_edit_field_adf_no_conversion_on_non_adf_schema` | FAIL (assertion) |
| AC-007 | `test_bc_3_4_033_edit_field_adf_hinted_id_bypasses_adf_conversion` | FAIL (assertion) |
| AC-008 | `test_bc_3_4_033_edit_field_adf_hinted_option_bypasses_adf_conversion` | FAIL (assertion) |
| AC-009 | `test_bc_3_4_033_edit_field_adf_empty_guard_exits_64` | FAIL (old --markdown message absent) |
| AC-010 | `test_bc_3_4_033_edit_field_adf_field_markers_populated` | FAIL (no `field_markers` behavior) |
| AC-011 | `test_bc_3_4_033_edit_field_adf_bulk_excluded` | FAIL (assertion) |
| AC-012 | `test_bc_3_4_033_edit_field_adf_invalid_markdown_exits_64` | FAIL (assertion) |
| AC-013 | `test_bc_3_4_033_edit_field_adf_output_json_contains_adf_object` | FAIL (assertion) |
| AC-014 | `test_bc_3_4_033_edit_field_adf_dry_run_shows_adf_indicator` | FAIL (assertion) |

### Integration tests — `tests/issue_create_field_adf.rs` (5 tests)

| AC | Test | Outcome |
|----|------|---------|
| AC-005b | `test_bc_3_3_010_create_field_adf_converts_markdown` | FAIL (assertion) |
| AC-006b | `test_bc_3_3_010_create_field_adf_no_conversion_non_adf` | FAIL (assertion) |
| AC-007b | `test_bc_3_3_010_create_field_adf_hinted_bypasses` | FAIL (assertion) |
| AC-008b | `test_bc_3_3_010_create_field_adf_empty_guard` | FAIL (assertion) |
| AC-009b | `test_bc_3_3_010_create_field_adf_field_markers_create` | FAIL (assertion) |

### E2E test — `tests/e2e_live.rs`
- `test_e2e_adf_textarea_create_path_smoke` — `#[ignore]`-gated; NOT run under plain `cargo test` (correct by design, AC-015 scope)

## Regression Check
| Existing Tests | Status |
|----------------|--------|
| 26 `common::wf::tests::*` shared-helper tests (fired via `mod common;` in new test binaries) | all PASS |
| All other pre-existing tests | not degraded by stub additions |

Note: the 26 `common::wf::*` tests are unrelated to this story — they are a standard artifact of the shared `mod common;` include in the new integration test binaries. They are not part of the Red Gate scope.

## Acceptance Criterion Coverage
| AC | Description | Red Gate Status |
|----|-------------|-----------------|
| AC-001 | `is_adf_field` allowlist predicate | RED (todo!) |
| AC-002 | Positive/negative anchors on allowlist | RED (todo!) |
| AC-003 | `dispatch_field_value` returns ADF object for ADF fields | RED (assertion) |
| AC-004 | Empty guard fires only on bare form | RED |
| AC-005 | Edit path converts markdown→ADF on ADF-schema field | RED |
| AC-006 | Edit path no conversion on non-ADF field | RED |
| AC-007 | Hinted `:id` bypasses ADF conversion | RED |
| AC-008 | Hinted `:option` bypasses ADF conversion | RED |
| AC-009 | Empty guard exits 64 | RED |
| AC-010 | `field_markers` populated in output | RED |
| AC-011 | Bulk excluded | RED |
| AC-012 | Invalid markdown exits 64 | RED |
| AC-013 | JSON output contains ADF object | RED |
| AC-014 | Dry-run shows ADF indicator | RED |
| AC-015 | E2E smoke + mutants-toml entry | PR-time check (doc-only at Red Gate) |

All 15 ACs covered; AC-015 is deferred to PR-time as a doc/config check.

## Hand-Off to Implementer
- Stories ready for implementation: `S-cycle12-platform-adf-autoconvert`
- Pick the next failing test, write minimum code to make it pass, micro-commit each step.
- Suggested order: AC-001/002 (allowlist predicate) → AC-003 (dispatch) → AC-004 (empty guard) → AC-005/006 (edit path conversion) → AC-007/008 (hint bypass) → AC-009 (empty-guard exit) → AC-010 (field_markers) → AC-011 (bulk guard) → AC-012 (invalid markdown) → AC-013 (JSON) → AC-014 (dry-run) → AC-015 (PR-time).
- Worktree: `/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-cycle12-platform-adf-autoconvert`
