# Demo Evidence — S-605-1 (`issue create/edit --component`, single-key path)

- Story: `.factory/stories/S-605-1-issue-component-single-key.md`
- Worktree: `.worktrees/S-605-1`
- Feature HEAD SHA: `570d1263b54eb0f877c9b858cecc1d0993e97d03`
- Recording tool: [VHS](https://github.com/charmbracelet/vhs) (CLI product)
- Data discipline: all recordings run against a local placeholder Jira mock
  (`127.0.0.1:9999`, dummy `test:test` auth). Project key `FOO`, issue key
  `FOO-1`, component names `Backend`/`Frontend` — no real Jira keys, org IDs,
  instance URLs, or tokens anywhere in these recordings.
- Wire-shape evidence: each recording that must prove a specific HTTP body
  shows the mock server's captured request log (`jq`-formatted), rather than
  `--verbose-bodies` (CLAUDE.md discourages that flag in any recording/log
  destined for shared storage).

## Coverage map

| Recording | AC(s) covered | What it shows |
|---|---|---|
| `AC-001-edit-add-remove-native-wire-shape` | AC-001 | `issue edit FOO-1 --component add:Backend --component remove:Frontend` → captured PUT body is the exact native `update`-verb shape `{"update":{"components":[{"add":{"name":"Backend"}},{"remove":{"name":"Frontend"}}]}}`. |
| `AC-002-edit-bare-add-table-echo` | AC-002, AC-012 | `--component Backend` (bare, no prefix) → table echo `components → add:Backend` and captured PUT body normalizes to `{"add":{"name":"Backend"}}`. |
| `AC-007-create-initial-components` | AC-007 | `issue create --project FOO --component Backend --component Frontend` → captured POST body `fields.components == [{"name":"Backend"},{"name":"Frontend"}]`, CLI input order. |
| `AC-009-create-request-type-guard-exit64` | AC-009 (error path) | `issue create --request-type "IT Request" --component Backend` → exit 64, stderr names both flags and suggests the `jr issue edit --component` follow-up, and the mock server's request log is never created (zero HTTP calls). |
| `AC-013-edit-json-echo` | AC-013 | `--component Backend --output json` → `changed_fields.components == "add:Backend"` (a JSON string, not an array). |
| `AC-015-label-component-mutex-exit64` | AC-015 (error path) | `--label add:foo --component add:bar` on one key → exit 64, stderr contains `--label cannot be combined with` and `--component`; zero HTTP (no request log created). |
| `AC-016-dry-run-preview-zero-mutation` | AC-016 | `--dry-run` table preview `components → add:Backend, remove:Frontend`; only the read-only resolution GET fires — no PUT (zero mutation). |
| `AC-017-F1-dry-run-bare-and-unknown-name` | AC-017, F1 (error path) | Bare `--component Backend --dry-run` → preview normalizes to `add:Backend` (parity with the live echo); then `--component add:Nonexistent --dry-run` → exit 64 via the same BC-8.4.002 not-found message the live path emits. |
| `F1-edit-numeric-component-ids` | F1/Round-3 hardening | `--component add:10001 --component remove:10002` (numeric) → captured PUT body wires by `id`, never `name`: `{"add":{"id":"10001"}},{"remove":{"id":"10002"}}`. |
| `R7-edit-component-summary-atomic-put` | Round-7 atomicity | `--component add:Backend --summary "New"` → exactly ONE PUT captured, carrying both `update.components` and `fields.summary` in the same request body. |

## Files per recording

Each recording produces a `.gif` (PR embed), a `.webm` (archival), and its
source `.tape` script, all in this directory:

```
AC-001-edit-add-remove-native-wire-shape.{gif,webm,tape}
AC-002-edit-bare-add-table-echo.{gif,webm,tape}
AC-007-create-initial-components.{gif,webm,tape}
AC-009-create-request-type-guard-exit64.{gif,webm,tape}
AC-013-edit-json-echo.{gif,webm,tape}
AC-015-label-component-mutex-exit64.{gif,webm,tape}
AC-016-dry-run-preview-zero-mutation.{gif,webm,tape}
AC-017-F1-dry-run-bare-and-unknown-name.{gif,webm,tape}
F1-edit-numeric-component-ids.{gif,webm,tape}
R7-edit-component-summary-atomic-put.{gif,webm,tape}
```

## Mock server

All recordings run against a small Python `http.server`-based mock
(`mock_server.py`, kept outside this evidence directory in the recording
session's scratchpad — not committed, since it is tooling rather than
evidence) that serves:

- `GET /rest/api/3/project/FOO/components` → `[Backend(10001), Frontend(10002)]`
- `GET /rest/api/3/issue/FOO-1/editmeta` → `components.operations = ["add","remove"]` (selects the native `update`-verb path)
- `PUT /rest/api/3/issue/FOO-1` → `204`
- `POST /rest/api/3/issue` → `201 {"key":"FOO-1", ...}`

Every inbound request is appended to a JSON-lines log file, which the tapes
`cat`/`jq` to show the *exact* wire body `jr` sent — this is how AC-001,
AC-002, AC-007, and the numeric/atomicity recordings prove wire shape
without using `--verbose-bodies`.

## AC coverage not separately demoed

AC-003 (add-before-remove ordering regardless of CLI order), AC-004/005
(editmeta-gated fallback selection), AC-006 (unknown-name zero-PUT), AC-010
(one resolution GET, not duplicated), AC-011 (table echo, prefixed), AC-014
(Gate B fifth-field overlap) are covered by the automated integration suite
(`tests/issue_commands.rs`, 40+ component tests) but were not separately
recorded — the 10 recordings above were scoped to the acceptance criteria
and hardening rounds the orchestrator asked to demo, prioritizing wire-shape
proof (the highest-value visual evidence for a CLI's HTTP contract) and both
success and error paths.
