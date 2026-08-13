# S-668-1 Demo Evidence

Story: Surface Jira `duedate` in `jr issue view`/`jr issue list` (JSON fields +
`issue view` always-on "Due Date" row + `issue list --duedate` opt-in column),
closing GitHub issue #668.

Branch: `feat/668-duedate`
Head: `c382f69d`
Captured: 2026-08-13

This is a read-only CLI display feature (no state-changing/write path involved).
Coverage below spans AC-1 through AC-9 — the runtime-observable ACs — via VHS
terminal recordings against a local mock. AC-10 through AC-16 are code-level/
static-verification ACs (shared-helper reuse, struct-field shape, field-array
literal position, other-call-site non-leakage) already covered by the story's
unit/integration test suite (`tests/issue_commands.rs`, `src/cli/issue/format.rs`
unit tests) and are not runtime-observable via a terminal recording.

## Recording method — REAL rendered output against a local mock, ADAPTED per the brief

No live Jira credentials are available, and per standing policy this factory
never hits live Jira or uses real Jira keys/org IDs/URLs. Rather than falling
back to a static `--help`-only demo, a throwaway local mock Jira HTTP server
was stood up (`mock_server.py` — Python stdlib `http.server`, ~70 LOC, no
external dependencies) serving two fixed, fake-data endpoints:

- `GET /rest/api/3/issue/PROJ-1` → fake issue with `duedate: "2027-07-30"`
- `GET /rest/api/3/issue/PROJ-2` → fake issue with `duedate: null`
- `POST /rest/api/3/search/jql` → both fake issues (PROJ-1 set, PROJ-2 unset)
  in one page, `nextPageToken: null`

All fixture data (issue keys `PROJ-1`/`PROJ-2`, project key `PROJ`, assignee
"Alex Rivera", reporter "Sam Okafor", dates in 2027) is synthetic — no real
Jira org, instance URL, account ID, or issue key appears anywhere in these
recordings.

Every recording below runs the **actual debug binary** (`./target/debug/jr`,
built from `c382f69d`) against this mock via the documented, `#[cfg(debug_assertions)]`-gated
test seams (CLAUDE.md "AI Agent Notes" — inert in release builds; this is the
exact same mechanism `tests/issue_commands.rs`'s wiremock-based integration
tests use, just with a hand-rolled mock server instead of `wiremock` so a
plain terminal recording tool could drive it):

- `JR_CONFIG_DIR=/tmp/jr-demo-config-668`, `JR_CACHE_DIR=/tmp/jr-demo-cache-668` → scratch dirs, isolated from any real `~/.config/jr` / `~/.cache/jr`
- `JR_BASE_URL=http://127.0.0.1:8934` → the local mock server above
- `JR_AUTH_HEADER=Basic ZmFrZTpmYWtl` → dummy fake credential (base64 of `fake:fake`)

So: **this is real code executing a real HTTP round-trip and rendering real
output** — not a canned screenshot — just against a local mock instead of a
live Jira Cloud instance, per the task's explicit no-live-Jira constraint.
Labeling per the brief: every tape's header comment states "ADAPTED DEMO —
NOT LIVE JIRA" and explains the mock.

`mock_server.py` is kept alongside this evidence set for regeneration; see
"Regeneration" below.

## Evidence

| AC | BC Anchor | Video | Command | Result |
|----|-----------|-------|---------|--------|
| AC-1 | BC-2.3.036 [AMENDED] / BC-2.2.028 | `AC-001-view-json-duedate-set.gif`/`.webm` | `jr issue view PROJ-1 --output json \| jq '.fields.duedate'` | `"2027-07-30"` — verbatim, set value present |
| AC-2 | BC-2.3.036 [AMENDED] | `AC-002-view-json-duedate-unset.gif`/`.webm` | `jr issue view PROJ-2 --output json \| jq '{hasKey, value}'` | `hasKey: true, value: null` — key PRESENT as JSON `null`, not omitted |
| AC-3 | BC-2.2.028 / BC-2.2.032 JSON-mode | `AC-003-list-json-duedate-unconditional.gif`/`.webm` | `jr issue list --jql "project = PROJ" --output json` (no `--duedate` flag) | Both rows' `.fields.duedate` present (`"2027-07-30"` / `null`) — JSON shape is unconditional of the flag |
| AC-4 | BC-2.3.039 | `AC-004-view-human-due-date-row-set.gif`/`.webm` | `jr issue view PROJ-1` (human) | "Due Date" row present, value `2027-07-30` verbatim, positioned between "Updated" and "Project" |
| AC-5 | BC-2.3.039 empty-rendering | `AC-005-view-human-due-date-dash-when-unset.gif`/`.webm` | `jr issue view PROJ-2` (human) | "Due Date" row renders `-` (not `(none)`) |
| AC-6 + AC-7 | BC-2.2.032 column-position + empty-rendering | `AC-006-list-duedate-column-position.gif`/`.webm` | `jr issue list --jql "project = PROJ" --duedate` (human) | Header order `Key, Type, Status, Priority, Due Date, Assignee, Summary`; PROJ-1 cell `2027-07-30` (AC-6), PROJ-2 cell `-` (AC-7) — same invocation evidences both |
| AC-8 | BC-2.2.032 opt-in clause | `AC-008-list-without-flag-omits-column.gif`/`.webm` | `jr issue list --jql "project = PROJ"` (no `--duedate`, human) | No "Due Date" header/column anywhere in output |
| AC-9 | BC-2.2.032 JSON-mode clause | `AC-009-list-duedate-json-noop.gif`/`.webm` | Runs `--duedate --output json` and plain `--output json` back to back, `diff`s the two JSON files, `wc -l`s both stderr captures | `diff` empty + "JSON IDENTICAL (AC-9 pass)"; both stderr captures 0 lines — `--duedate` has zero effect on JSON shape and emits no warning |

## What is NOT covered here (and why)

- **AC-10** (shared `render_due_date` helper used by both call sites, `None`/`Some("")`/`Some(value)`
  unit-tested) — code-level/unit-test verification, not runtime-observable via a
  terminal recording. Covered by `src/cli/issue/format.rs::tests`.
- **AC-11 through AC-15** (exact 17-element `BASE_ISSUE_FIELDS` array/order,
  `IssueFields.duedate` deserialization present/absent, named-field-not-`extra`
  placement) — wire-shape/struct-shape assertions, covered by
  `tests/issue_commands.rs` (`test_search_issues_includes_labels_parent_issuelinks`,
  `get_issue_includes_standard_fields`, `get_issue_null_standard_fields`).
- **AC-16** (other `format_issue_row`/`issue_table_headers` call sites —
  `board view`, `queue view`, `sprint current` — do NOT gain a Due Date column)
  — this is a "column does NOT leak in" negative assertion across three other
  commands; covered by the story's integration tests. Not staged as its own
  demo since it would just be three more "nothing changed" recordings with
  no positive rendering to show.
- **Error paths**: this is a read-only display feature — `duedate` introduces
  no new failure mode (no new validation, no new write path, no new exit
  code). The closest analogue to an "edge case" path is the unset/`null`
  rendering, which IS demonstrated (AC-2, AC-5, AC-7, all above) as the "-"
  and JSON-`null` conventions.

## Regeneration

The `.tape` files use quoted `Output` paths relative to `.factory/demos/S-668-1/…`
(this VHS version, 0.11.0, requires quoted `Output` paths — differs from some
older tapes elsewhere in this directory tree that used bare paths), which
resolve correctly only when `vhs` is invoked from the directory that has
`.factory/` as an immediate child — i.e. the **top-level repo root**
(`/Users/zious/Documents/GITHUB/jira-cli`, where `.factory/` is its own
worktree on the `factory-artifacts` branch), not from inside
`.worktrees/S-668-1/`. The tapes themselves `cd` into the story worktree and
run the pre-built binary from there via a hidden setup block.

To regenerate against a different head:

```bash
cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-668-1   # build first
cargo build

# start the mock server (leave running in another terminal / background job)
python3 /Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-668-1/mock_server.py &

cd /Users/zious/Documents/GITHUB/jira-cli                       # then run vhs from repo root
for t in .factory/demos/S-668-1/*.tape; do
  vhs "$t"
done
```
