# S-577-2 Demo Evidence

Story: API layer — `delete_comment`, `update_comment`, `get_comment`  
Branch: `feat/comment-crud-api`  
Head: `69369fd`  
Test file: `tests/comment_crud_api.rs`  
Captured: 2026-07-13

## Full Suite

| File | Command | Result |
|------|---------|--------|
| `full-suite.txt` | `cargo test --test comment_crud_api` | 6/6 green |

## Per-AC Evidence

| AC | BC Anchor | Demo File | Test Function | Result |
|----|-----------|-----------|---------------|--------|
| AC-001 | BC-3.5.002 | `ac-001-delete-204.txt` | `test_delete_comment_204_returns_ok` | ok |
| AC-002 | BC-3.5.005 | `ac-002-body-only.txt` | `test_update_comment_body_only_no_properties_key` | ok |
| AC-003 | BC-3.5.006 | `ac-003-internal-wire.txt` | `test_update_comment_internal_properties_wire_shape` | ok |
| AC-004 | BC-3.5.007 | `ac-004-public-wire.txt` | `test_update_comment_public_properties_wire_shape` | ok |
| AC-005 | BC-3.5.010 | `ac-005-expand-properties.txt` | `test_get_comment_sends_expand_properties_query_param` | ok |

## 6th Test (Additive Encoding Pin)

The 6th test `test_delete_comment_encodes_key_with_space_in_url` is not AC-mapped — it
is a cargo-mutants whole-body mutant kill pin. It runs as part of the full suite
(`full-suite.txt`) and verifies that `delete_comment` actually sends an HTTP request
(killing the stub-returns-Ok mutant) and that a space in the key is percent-encoded to
`%20` in the URL. Its output is captured in `full-suite.txt` line 11.

## Convention Note

No `.factory/demos/` directory existed prior to this story. This directory establishes
the pattern: one subdirectory per story ID (`S-NNN-N/`), with `INDEX.md` + one text file
per demo run. Demo files contain verbatim terminal output (command + cargo output).
