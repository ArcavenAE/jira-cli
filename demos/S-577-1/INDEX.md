# S-577-1 Demo Evidence

Story: CLI subcommand group refactor — `comment → CommentSubcommand` (add/delete/edit/view) + interactions.rs shard
Branch: `feat/comment-subcommand-refactor`
Head: `08824fe`
Binary: `target/debug/jr` (debug build)
Captured: 2026-07-13

## Summary

All 13 ACs verified. Captures are live binary invocations (exits are real process exits);
no live Jira calls were made (all demos are parse-level errors, test runs, or config-missing exits).

## Per-AC Evidence

| AC | BC Anchor | Demo File | Invocation / Test | Result |
|----|-----------|-----------|-------------------|--------|
| AC-001 | BC-3.5.012 EC-3.5.012-1 | `ac-001-flat-form-migration-hint.txt` | `jr issue comment FOO-1 "some text"` → exit 2; stderr contains `"use \`jr issue comment add\` instead"` | ok |
| AC-002 | BC-3.5.012 EC-3.5.012-1 | `ac-002-bare-comment-clap-listing.txt` | `jr issue comment` → exit 2; lists add/delete/edit/view; NO custom hint | ok |
| AC-003 | BC-3.5.012 EC-3.5.012-1 | `ac-003-list-ls-plural-hint.txt` | `jr issue comment list/ls/LS FOO-1` (3 invocations) → exit 2; stderr contains `"jr issue comments"` | ok |
| AC-004 | BC-3.5.012 EC-3.5.012-3 | `ac-004-005-leading-dash-parse-accepted.txt` | `jr issue comment add FOO-1 "- [ ] task"` → exit 78 (config miss, not exit 2 — parse accepted) | ok |
| AC-005 | BC-3.5.012 EC-3.5.012-3 | `ac-004-005-leading-dash-parse-accepted.txt` | `jr issue comment edit FOO-1 --id 10001 "- update"` → exit 78 (parse accepted) | ok |
| AC-006 | BC-3.5.012 EC-3.5.012-2 | `ac-006-007-008-test-suite.txt` | `cargo test --test cli_smoke -- test_bc_3_5` — 12/12 green (includes VP-577-008/014/015/020 + 4 AC-012 parse tests + AC-013 + 2 VP-018/019) | ok |
| AC-007 | BC-3.5.012 EC-3.5.012-5(d) | `ac-006-007-008-test-suite.txt` | `cargo test --test e2e_cli_surface_guard` — 10/10 green (SURFACE table updated with 4 comment sub-rows) | ok |
| AC-008 | BC-3.5.012 EC-3.5.012-5(e) | `ac-006-007-008-test-suite.txt` | Verified transitively by `test_parser_paths_are_subset_of_surface_table` (green) | ok |
| AC-009 | BC-3.5.012 EC-3.5.012-5(f-j) | `ac-009-010-011-doc-greps.txt` | Greps: `changed_fields` in json-output-shapes.md ✓; `"deleted"` in json-output-shapes.md ✓; `interactions.rs` in .cargo/mutants.toml ✓; `comment add` in README.md ✓; `comment-crud.md` exists ✓ | ok |
| AC-010 | BC-3.5.012 CHANGELOG | `ac-009-010-011-doc-greps.txt` | `grep -F '#577' CHANGELOG.md` → Breaking Changes entry found | ok |
| AC-011 | BC-3.5.012 EC-3.5.012-5(a-c) | `ac-009-010-011-doc-greps.txt` | Non-InvalidSubcommand errors pass through byte-identical (verified by full test suite green — remote-link, JSM create, snapshot tests) | ok |
| AC-012 | BC-3.5.009 / BC-3.5.011 | `ac-012-mutual-exclusion.txt` | `--file + --stdin` → exit 2; `--internal + --public` → exit 2 (clap conflicts_with fires) | ok |
| AC-013 | BC-3.5.012 EC-011/EC-010 | `ac-013-context-interception.txt` | `jr --output json issue comment FOO-1 "text"` → exit 2 + hint (context() intercept works with global flag); `jr issue foo BAR-1` → exit 2, no hint | ok |

## New-Surface Tour

| File | Invocations | Result |
|------|-------------|--------|
| `surface-tour.txt` | `jr issue comment --help` (exit 0) + `jr issue comment add --help` (exit 0) | Both exit 0; all 4 subcommands listed in group help |

## Convention Note

Pattern established by `S-577-2/INDEX.md`: one subdirectory per story ID, `INDEX.md` +
per-topic capture files. This story's captures are grouped by AC cluster rather than
one-file-per-AC because several ACs share a single invocation (AC-004/005, AC-006/007/008).
