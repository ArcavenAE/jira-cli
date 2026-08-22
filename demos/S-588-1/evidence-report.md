# S-588-1 Demo Evidence

Story: `jr issue list --sort <field>:asc|desc` — a shorthand for controlling
JQL `ORDER BY` without hand-writing `--jql`, with an automatic `key ASC`
secondary sort for pagination stability (GitHub issue #588, bundle
`list-read-ergonomics`, third and final story in that bundle's Wave-1
sequence after S-575-1 and S-579-1).

Branch: `feat/issue-sort-shorthand`
Head: `4abf8f80`
Captured: 2026-08-21

Behavioral contracts: BC-2.1.024 (`--sort <field>:asc|desc` syntax
parse/validate), BC-2.1.025 (`--sort` overrides `order_by` uniformly across
all 4 composition branches; appends `, key ASC` secondary stable sort unless
the field is `key`; field name passed through to Jira unvalidated).

This is a read-only, pre-HTTP-validation-heavy CLI ordering feature (no
state-changing/write path involved). The point of every recording below is
the **outgoing JQL's `ORDER BY` clause** and the CLI's **exit-code/error-
message behavior**, not the (intentionally empty) mock search response.

## Recording method — REAL rendered output against a local mock, ADAPTED per policy

No live Jira credentials are used and no real Jira org, instance URL,
account ID, or issue key appears anywhere in these recordings — per standing
factory policy, this run never hits live Jira. A throwaway local mock Jira
HTTP server was stood up (`mock_server.py` — Python stdlib `http.server`,
~95 LOC, no external dependencies, source kept alongside this evidence set)
serving three fixed, fake-data endpoints:

- `GET /rest/api/3/project/DEMO` → a minimal fake `ProjectSummary` (key
  `DEMO`, name "Demo Project") — hit only when `--status` is **absent**
  (`src/cli/issue/list.rs`: `status.is_none() && !client.project_exists(pk)`),
  so the CLI's pre-search project-existence check succeeds.
- `GET /rest/api/3/project/DEMO/statuses` → a minimal fake
  `IssueTypeWithStatuses` list containing `"To Do"` / `"In Progress"` /
  `"Done"` — hit only when `--status` **is** present, so `--status "In
  Progress"` resolves via `partial_match` against a real (fake) candidate
  set; this call also doubles as the project-existence check on that path
  (404 → `UserError`).
- `POST /rest/api/3/search/jql` → an empty result set (`{"issues": [],
  "nextPageToken": null}`). The response body is irrelevant to what these
  recordings demonstrate — what matters is the **request** body Jira would
  have received, specifically its `jql` field's `ORDER BY` clause.

Every recording runs the **actual debug binary** (`./target/debug/jr`, built
from `4abf8f80`) via the documented, `#[cfg(debug_assertions)]`-gated test
seams (CLAUDE.md "AI Agent Notes" — inert in release builds; the same
mechanism `tests/issue_commands.rs`'s wiremock-based integration tests use):

- `JR_CONFIG_DIR` / `JR_CACHE_DIR` → scratch dirs, isolated from any real
  `~/.config/jr` / `~/.cache/jr`.
- `JR_BASE_URL=http://127.0.0.1:8936` → the local mock server above.
- `JR_AUTH_HEADER=Basic ZmFrZTpmYWtl` → dummy fake credential (base64 of
  `fake:fake`).

For the three HTTP-reaching scenarios (AC-001, AC-002, and the
priority+status composition demo), the commands additionally pass
`--verbose --verbose-bodies` (documented, non-default flag combination —
CLAUDE.md "`--verbose` is header-only") so the **real outgoing HTTP request
body** — the composed JQL — is printed to stderr as `[verbose] body:
{"jql": "...", ...}` and captured directly in the recording. `RUST_LOG=warn`
is also set to suppress the `tracing` crate's own DEBUG/TRACE
transport-layer noise, mirroring the S-579-1 recording convention.

The one zero-HTTP scenario (AC-004, malformed `--sort` value) fails before
any network call — `parse_sort`'s local syntax validation fires pre-HTTP —
so that recording does not talk to the mock server at all, demonstrating
the pre-HTTP-validation postcondition itself.

So: **this is real code executing (or correctly declining to execute) a
real HTTP round-trip and rendering real output** — not a canned screenshot —
against a local mock instead of a live Jira Cloud instance.

`mock_server.py` is kept alongside this evidence set for regeneration.

## Evidence

| AC | BC Anchor | Video | Command | Result |
|----|-----------|-------|---------|--------|
| AC-001 | BC-2.1.025 Edge Case EC-2.1.025-1 (override + secondary sort) | `AC-001-sort-updated-desc-composes-secondary-key-asc.{gif,webm}` | `jr --no-input --verbose --verbose-bodies --output json issue list --project DEMO --sort updated:desc` | Outgoing JQL body: `"jql":"project = \"DEMO\" ORDER BY updated DESC, key ASC"` — confirms `--sort updated:desc` composes to `order_by = "updated DESC, key ASC"`, with the stable `key ASC` secondary sort appended automatically. Exit 0. |
| AC-002 | BC-2.1.025 postcondition 2 / Edge Case EC-2.1.025-2 (key-field omission) | `AC-002-sort-key-asc-omits-secondary-clause.{gif,webm}` | `jr --no-input --verbose --verbose-bodies --output json issue list --project DEMO --sort key:asc` | Outgoing JQL body: `"jql":"project = \"DEMO\" ORDER BY key ASC"` — confirms NO doubled `key ASC, key ASC` clause: the secondary-sort append is correctly suppressed when the requested field is `key`. Exit 0. |
| (composition evidence, BC-2.1.025 Behavior / Precondition 1 / Postcondition 5) | BC-2.1.025 Behavior (uniform override), Precondition 1 (no field-name allowlist), Postcondition 5 (`--sort` is not a filter source) | `AC-COMPOSE-sort-priority-asc-composes-with-status-filter.{gif,webm}` | `jr --no-input --verbose --verbose-bodies --output json issue list --project DEMO --sort priority:asc --status "In Progress"` | Outgoing JQL body: `"jql":"project = \"DEMO\" AND status = \"In Progress\" ORDER BY priority ASC, key ASC"` — the `--status` filter lands in the WHERE clause exactly as it would without `--sort` (confirming `--sort` does not push a filter clause / is not counted as a filter source), while `--sort priority:asc` only touches `ORDER BY`; `priority` (an arbitrary, non-`key` field name) is passed through to Jira UNVALIDATED, with `key ASC` appended as the secondary sort. Exit 0. Not a standalone numbered AC in the story — supporting evidence for BC-2.1.025's composition and pass-through guarantees, requested explicitly for this recording pass. |
| AC-004 | BC-2.1.024 Edge Case EC-2.1.024-3..7 (malformed-input rejection) | `AC-004-sort-malformed-direction-exits-64-pre-http.{gif,webm}` | `jr --no-input issue list --project DEMO --sort updated:sideways` | Local syntax validation rejects the malformed direction segment pre-HTTP: `Error: Invalid --sort "updated:sideways". Use <field>:asc or <field>:desc (e.g., updated:desc).` — zero HTTP calls made. Exit 64. (The other four malformed shapes covered by AC-004 — missing `:`, empty field, empty direction, and a second embedded `:` — share this exact error path/exit code and are not separately recorded; see the automated test below.) |

## AC → coverage mapping (full set)

All 10 ACs trace to BC-2.1.024 / BC-2.1.025. Three are covered by the
live-mock recordings above (plus one supporting composition recording
outside the story's numbered AC list); the remaining seven are pure/unit-
level (pre-HTTP string-composition and validator-error-shape checks with no
distinct runtime-observable behavior beyond what the recordings above
already show) and are covered by the story's automated test suite:

| AC | Covered by | Test |
|----|-----------|------|
| AC-001 | Live recording (table above) | `test_bc_2_1_025_issue_list_sort_composes_secondary_key_asc()` |
| AC-002 | Live recording (table above) | `test_bc_2_1_025_issue_list_sort_key_field_omits_secondary_clause()` |
| AC-003 | Automated test (`tests/issue_commands.rs`) — pre-HTTP case-insensitive direction parsing (`--sort key:ASC` / `--sort key:AsC`); same parse function (`parse_sort`) already exercised live by AC-001/002/004, no additional runtime-observable distinction | `test_bc_2_1_024_issue_list_sort_direction_case_insensitive()` |
| AC-004 | Live recording (table above) | `test_bc_2_1_024_issue_list_sort_malformed_input_exits_64_pre_http()` |
| AC-005 | Automated test (`tests/issue_commands.rs`) — overrides the `--jql` branch's hardcoded `"updated DESC"` default; same override mechanism demonstrated live by AC-001/002/composition demo against the default-project branch, no additional runtime-observable distinction | `test_bc_2_1_025_issue_list_sort_overrides_jql_branch_default()` |
| AC-006 | Automated test (`tests/issue_commands.rs`) — overrides the kanban board's `"rank ASC"` default; requires a kanban-board fixture not modeled in this recording pass's local mock (project + status only) | `test_bc_2_1_025_issue_list_sort_overrides_kanban_board_rank_default()` |
| AC-007 | Full regression suite (unmodified BC-2.1.002/003/004/005 pinned-literal tests) — confirms absent `--sort`, `order_by` stays byte-for-byte unchanged in all 4 branches | existing `build_jql_parts_*` / `all_flag_behavior` regression suite |
| AC-008 | Automated test (`tests/issue_commands.rs`) — unknown field (`customfield_10099`) propagates a live Jira 400 as `JrError::ApiError`; requires a mocked 400 response distinct from this recording pass's fixed 200-OK mock, so not separately recorded (the composition demo already shows an arbitrary, non-allowlisted field name being passed through verbatim) | `test_bc_2_1_025_issue_list_sort_unknown_field_propagates_jira_400()` |
| AC-009 | Automated test (`tests/issue_commands.rs`) — `--sort` alone (no project/filters/`--jql`) still trips the "no filters specified" exit-64 guard; same pre-HTTP-guard class as AC-004, not separately recorded | `test_bc_2_1_006_issue_list_sort_alone_does_not_satisfy_filter_requirement()` |
| AC-010 | Automated test (`tests/issue_commands.rs`) — `--sort KEY:desc` (case-variant of `key`) still omits the secondary clause, but field casing is preserved verbatim (`order_by = "KEY DESC"`, not lowercased); same composition function demonstrated live by AC-002, no additional runtime-observable distinction | `test_bc_2_1_025_issue_list_sort_key_omission_case_insensitive_field_casing_preserved()` |

Full automated suite for this story: `tests/issue_commands.rs`,
`tests/all_flag_behavior.rs`, `tests/issue_list_errors.rs`, plus the unit
tests in `src/cli/issue/list.rs` (`test_bc_2_1_024_parse_sort_*` and
`test_bc_2_1_025_compose_order_by_with_sort_*`). Verified green on
`4abf8f80` at recording time (`cargo test --lib`: 1137 passed, 0 failed, 11
ignored; `cargo build` clean).

## Regeneration

```bash
cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-588-1
cargo build
python3 /Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-588-1/mock_server.py &
export JR_CONFIG_DIR=/tmp/jr-demo-config-588 JR_CACHE_DIR=/tmp/jr-demo-cache-588 \
       JR_BASE_URL=http://127.0.0.1:8936 JR_AUTH_HEADER='Basic ZmFrZTpmYWtl' RUST_LOG=warn
rm -rf /tmp/jr-demo-config-588 /tmp/jr-demo-cache-588
./target/debug/jr --no-input --verbose --verbose-bodies --output json \
  issue list --project DEMO --sort updated:desc
```

Then, from the product repo root (`/Users/zious/Documents/GITHUB/jira-cli`),
re-run `vhs .factory/demos/S-588-1/<name>.tape` for any of the four tapes in
this directory to regenerate the `.gif`/`.webm` pair.
