---
document_type: red-gate-log
level: ops
version: "1.0"
status: verified
producer: test-writer
timestamp: 2026-07-19T00:00:00
phase: 3
inputs:
  - S-576-1.md
input-hash: "584cadd"
traces_to: "BC-2.7.001..BC-2.7.006"
stub_architect_agent: "[stub-architect, commit 64161657]"
stub_compile_verified: true
test_writer_agent: "[test-writer, commit 10e1f044]"
red_gate_verified: true
---

# Red Gate Log: S-576-1 — Attachment List

**Date:** 2026-07-19
**Story:** S-576-1 — `jr issue attachments` (attachment list command)
**Branch:** `feat/S-576-1-attachment-list`
**Base:** develop @ 21f54581
**Worktree:** `.worktrees/S-576-1`
**Red Gate verified by:** orchestrator, 2026-07-19 (`cargo test --test attachment_list`)

## Summary

| Story | Tests Written | All Fail (Red)? | Gate |
|-------|---------------|-----------------|------|
| S-576-1 | 14 | Yes — 0 passed / 14 failed | PASSED |

Two-commit Red Gate staged per TDD discipline:

- **Commit 64161657 (stub-architect):** `feat(S-576-1): add module stubs` — 4 `todo!()` stubs introduced: `handle_attachment_list`, `display_sanitize_filename`, `serialize_attachment_curated`, `list_attachments`. `cargo check` and `cargo check --tests` both clean.
- **Commit 10e1f044 (test-writer):** `test(S-576-1): add failing tests for BC-2.7.001..006` — `tests/attachment_list.rs` with 14 wiremock subprocess tests covering all 6 BCs.

Red Gate VERIFIED by orchestrator:

- `cargo check --all-targets` — CLEAN (no compile errors; `todo!()` macros are valid Rust)
- `cargo test --test attachment_list` — **0 passed / 14 failed / 0 ignored** (all failures are exit-code assertion errors: subprocess exits 101 from `todo!()` panic vs expected 0/64/2/1)
- Build errors: none — all failures are runtime panics from stub bodies, confirming correct Red state

## Step (a): Stubs — commit 64161657

Files introduced / modified by stub-architect:

- New stub functions (all bodies are `todo!()`):
  - `handle_attachment_list` — top-level CLI handler for `jr issue attachments`
  - `display_sanitize_filename` — sanitize attachment filenames for display
  - `serialize_attachment_curated` — serialize attachment data in curated JSON form
  - `list_attachments` — API call to retrieve attachments for an issue key

`cargo check` output: PASS (0 errors).
`cargo check --tests` output: PASS (0 errors).

## Step (b): Tests — commit 10e1f044

File introduced by test-writer:

- `tests/attachment_list.rs` — 14 wiremock subprocess integration tests

## Red Gate Verification

### S-576-1 — all 14 tests FAIL as expected

| Test | BC | Failure Mode | Status |
|------|----|--------------|--------|
| `test_bc_2_7_001_table_six_columns_order` | BC-2.7.001 | exit 101 (todo!() panic) vs expected 0 | FAIL (expected) |
| `test_bc_2_7_001_filter_count_hint_fires_when_reduced` | BC-2.7.001 | exit 101 (todo!() panic) vs expected 0 | FAIL (expected) |
| `test_bc_2_7_001_zero_attachments_empty_stdout_stderr_hint` | BC-2.7.001 | exit 101 (todo!() panic) vs expected 0 | FAIL (expected) |
| `test_bc_2_7_002_json_shape_curated_form` | BC-2.7.002 | exit 101 (todo!() panic) vs expected 0 | FAIL (expected) |
| `test_bc_2_7_002_json_uses_render_json_not_string_pretty` | BC-2.7.002 | exit 101 (todo!() panic) vs expected 0 | FAIL (expected) |
| `test_bc_2_7_003_invalid_filter_key_exits_64` | BC-2.7.003 | exit 101 (todo!() panic) vs expected 64 | FAIL (expected) |
| `test_bc_2_7_003_mime_filter_image_wildcard` | BC-2.7.003 | exit 101 (todo!() panic) vs expected 0 | FAIL (expected) |
| `test_bc_2_7_004_name_filter_glob_and_composition` | BC-2.7.004 | exit 101 (todo!() panic) vs expected 0 | FAIL (expected) |
| `test_bc_2_7_005_size_max_filter_and_parse_error` | BC-2.7.005 | exit 101 (todo!() panic) vs expected 0/64 | FAIL (expected) |
| `test_bc_2_7_006_key_401_exit_2` | BC-2.7.006 | exit 101 (todo!() panic) vs expected 2 | FAIL (expected) |
| `test_bc_2_7_006_key_403_exit_1` | BC-2.7.006 | exit 101 (todo!() panic) vs expected 1 | FAIL (expected) |
| `test_bc_2_7_006_key_5xx_exit_1` | BC-2.7.006 | exit 101 (todo!() panic) vs expected 1 | FAIL (expected) |
| `test_bc_2_7_006_key_network_exit_1` | BC-2.7.006 | exit 101 (todo!() panic) vs expected 1 | FAIL (expected) |
| `test_bc_2_7_006_unknown_key_exits_64` | BC-2.7.006 | exit 101 (todo!() panic) vs expected 64 | FAIL (expected) |

All 14 failures are exit-code assertion errors from `todo!()` panic (Rust exit 101), not compilation
failures. This is the correct Red state: the test suite compiles and runs, and every test
exercises a stub that panics — exactly BC-5.38.001 compliance.

## Regression Check

| Existing Tests | Status |
|----------------|--------|
| Pre-existing test suite (all other tests) | not re-run as part of this Red Gate verification; compile clean confirms no breakage introduced by stubs |

## Hand-Off to Implementer

- Stories ready for implementation: S-576-1
- Implementation guidance:
  - All 4 stubs need real bodies: `handle_attachment_list`, `display_sanitize_filename`, `serialize_attachment_curated`, `list_attachments`
  - BCs to satisfy in order: BC-2.7.001 (table display), BC-2.7.002 (JSON output), BC-2.7.003 (MIME filter), BC-2.7.004 (name filter), BC-2.7.005 (size filter), BC-2.7.006 (error exit codes)
  - Green Gate target: 14/14 passing
  - Worktree already set up at `.worktrees/S-576-1`, branch `feat/S-576-1-attachment-list`
