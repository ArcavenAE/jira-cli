# S-577-4 Demo Evidence

Story: `comment edit` core — body sources + body-only PUT  
Branch: `feat/comment-edit-core`  
Head: `ef69662`  
Test file: `tests/comment_edit.rs` (13 subprocess tests)  
Captured: 2026-07-13

## Full Suite

| File | Command | Result |
|------|---------|--------|
| `full-suite.txt` | `cargo test --test comment_edit` | 13/13 green |

## Per-AC Evidence

All 13 ACs use test-run captures via `cargo test -- <test_fn> --nocapture`.
No raw binary invocations: handler tests require a wiremock HTTP stub. Running the
raw binary without wiremock would fail on auth/connection.

AC-012 and AC-013 are Step-4.5 coverage extensions added after the initial 11-AC
implementation. Both are coverage-additive (not red-first) and MUST pass against the
current code.

| AC | BC Anchor | Demo File | Test Function | Tier | Result |
|----|-----------|-----------|--------------|------|--------|
| AC-001 | BC-3.5.005 / VP-577-023 | `AC-001.txt` | `test_bc_3_5_005_edit_response_exact_key_set` | subprocess | PASS |
| AC-002 | BC-3.5.005 / VP-577-023 | `AC-002.txt` | `test_bc_3_5_005_edit_changed_fields_body_is_raw_pre_trim` | subprocess | PASS |
| AC-003 | BC-3.5.005 EC-3.5.005-1 / VP-577-001 | `AC-003.txt` | `test_bc_3_5_005_ec1_put_request_has_only_body_key` | subprocess | PASS |
| AC-004 | BC-3.5.009 | `AC-004.txt` | `test_bc_3_5_009_edit_file_body_source` | subprocess | PASS |
| AC-005 | BC-3.5.009 | `AC-005.txt` | `test_bc_3_5_009_edit_stdin_body_source` | subprocess | PASS |
| AC-006 | BC-3.5.009 EC-3.5.009-1 / VP-577-011 | `AC-006.txt` | `test_bc_3_5_009_ec1_file_not_found_exits_64` | subprocess | PASS |
| AC-007 | BC-3.5.009 EC-3.5.009-5 / VP-577-012 | `AC-007.txt` | `test_bc_3_5_009_ec5_empty_whitespace_body_exits_64` | subprocess | PASS |
| AC-008 | BC-3.5.005 EC-3.5.005-2 / VP-577-022(b) | `AC-008.txt` | `test_bc_3_5_002_ec1_edit_invalid_id_regex_exits_64` | subprocess | PASS |
| AC-009 | BC-3.5.005 / VP-577-026 variant 3 | `AC-009.txt` | `test_bc_3_5_005_jsm_internal_absent_in_default_path` | subprocess | PASS |
| AC-010 | BC-3.5.005 / VP-577-024 | `AC-010.txt` | `test_bc_3_5_005_put_404_exits_64_with_dual_stderr` | subprocess | PASS |
| AC-011 | BC-3.5.009 top-level rule | `AC-011.txt` | `test_bc_3_5_009_no_body_source_exits_64` | subprocess | PASS |
| AC-012 | BC-3.5.009 (Step-4.5 extension) | `AC-012.txt` | `test_bc_3_5_009_edit_markdown_source` | subprocess | PASS |
| AC-013 | BC-3.5.005 (Step-4.5 extension) | `AC-013.txt` | `test_bc_3_5_005_edit_500_exits_1_not_64` | subprocess | PASS |

**Total: 13/13 captures. 13/13 test functions green.**

## Key Implementation Notes

- AC-001 covers two variants in one test: JSON mode (exact key-set assertion) and human mode
  (stderr "Updated comment 10001 on FOO-1", stdout empty). Symmetric output profile.
- AC-002 dual-assertion design: (1) changed_fields.body is raw pre-trim "  hello world  ";
  (2) PUT wire ADF text node is trimmed "hello world". Mirrors issue edit description echo
  asymmetry (CLAUDE.md §issue edit description echo asymmetry). The two channels are
  intentionally non-identical: JSON is lossless, ADF is trimmed.
- AC-003 wire-level inspection: server.received_requests() parses PUT body as JSON and
  asserts exactly 1 key ("body"), no "properties" key (body-only invariant EC-3.5.005-1).
- AC-006 exit code 64 is critical: the NotFound remap is via explicit match on
  e.kind() == ErrorKind::NotFound → JrError::UserError, NOT a blanket map_err.
  Permission-denied / is-a-directory errors propagate unchanged (exit 1).
- AC-008 validates pipeline ordering: validate_comment_id fires FIRST (step 1), before
  body-source resolution (step 2); wiremock .expect(0) confirms no HTTP call.
- AC-010 preamble uses full context form "comment not found or permission denied: FOO-1#10001"
  (KEY#ID suffix per BC-3.5.005 §Response 404; mirrors delete handler at interactions.rs:225).
- AC-012 wire ADF differentiator: text_to_adf("**bold**") → text "**bold**" + no marks;
  markdown_to_adf("**bold**") → text "bold" + strong mark. Kills converter-swap mutant.
- AC-013 kills two guard mutations on the 404/403 re-wrap block. 500 must exit 1,
  NOT 64, and must NOT emit the "comment not found or permission denied" preamble.
