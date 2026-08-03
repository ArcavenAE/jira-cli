---
context: bc-5
title: "Boards & Sprints"
total_bcs: 36   # cumulative claim (incl. range-collapsed); definitional_count below is individually-bodied headings
definitional_count: 18   # count of `#### BC-` headings in this file
last_updated: 2026-06-30
source_pass: 3
trace: |
  - L2: .factory/specs/domain-spec/bc-05-boards-sprints.md
  - Source broad: .factory/semport/jira-cli/jira-cli-pass-3-behavioral-contracts.md §2.5
  - Source R4: .factory/semport/jira-cli/jira-cli-pass-3-deep-r4.md §3.7 (BC-1138)
  - F2 addition (2026-06-30): BC-5.1.005 — `board view` scrum/kanban dispatch + truncation hint stderr + `--all` suppression (BC-subclause-pass F2)
---

# BC-5 — Boards & Sprints

36 behavioral contracts across 4 subdomains: Board commands (5.1), Sprint commands (5.2),
Team column parity (5.3), API layer (5.4).

---

## Subdomains

### 5.1 Board Commands

#### BC-5.1.001: `client.list_boards(project, type)` GETs `/rest/agile/1.0/board` with query params

**Confidence**: HIGH
**Source**: `tests/board_commands.rs::list_boards_with_project_and_type_filter`; `tests/sprint_commands.rs::mount_prereqs`
**Subject**: Boards & Sprints
**Behavior**: Boards filtered by `projectKeyOrId=PROJ` + `type=scrum|kanban`.
**Trace**: Pass 3 BC-401

---

#### BC-5.1.002: `board view --limit --all` clap conflict

**Confidence**: HIGH
**Source**: `tests/board_commands.rs::board_view_limit_and_all_conflict`; `tests/cli_smoke.rs::test_board_view_all_and_limit_conflict`
**Trace**: Pass 3 BC-408

---

#### BC-5.1.003: Auto-resolve board: list scrum boards for project, pick first

**Confidence**: HIGH
**Source**: `tests/sprint_commands.rs::mount_prereqs`
**Subject**: Boards & Sprints
**Behavior**: When no board_id configured, auto-resolves by listing boards and picking the first matching.
**Trace**: Pass 3 BC-410

---

#### BC-5.1.004: `client.get_sprint_issues(sprintId, jql, limit, fields)` with `limit=Some(3)` returns 3 issues, `has_more=true`

**Confidence**: HIGH
**Source**: `tests/board_commands.rs::get_sprint_issues_with_limit`
**Trace**: Pass 3 BC-409

---

#### BC-5.1.005: `jr board view` dispatches to sprint endpoints for scrum boards and JQL search for kanban boards; truncation hint emits to stderr; `--all` suppresses hint

**Confidence**: HIGH
**Source**: `src/cli/board.rs::handle_view` (implementation-defined; client-side routing and hint text are not defined by any Atlassian API spec)
**Subject**: Boards & Sprints

**Description**: `handle_view` fetches `GET /rest/agile/1.0/board/{id}/configuration` to determine
board type, then dispatches to entirely different API endpoints depending on whether the board is
scrum (`board_type == "scrum"`, case-insensitive) or kanban (any other value). The truncation hint
text format differs between scrum and kanban paths. All hint text goes to stderr; `--all` suppresses
it entirely.

**Preconditions**:
1. `jr board view [--board N] [--limit N] [--all]` is invoked.
2. Board ID is resolved (via `--board` flag, config `board_id`, or auto-resolve per BC-5.1.003).
3. `GET /rest/agile/1.0/board/{id}/configuration` returns a valid board config with a `board_type` field.

**Postconditions — Scrum path (`board_type` case-insensitively equals `"scrum"`)**:
1. `GET /rest/agile/1.0/board/{id}/configuration` is called first (fires on both paths).
2. `GET /rest/agile/1.0/board/{id}/sprint?state=active` is called to find the active sprint.
3. If no active sprint → exit 1 with message `"No active sprint found for board <id>."` to stderr. No issue-fetch endpoint is called after this failure.
4. `GET /rest/agile/1.0/sprint/{sprintId}/issue` (or equivalent `get_sprint_issues` call) is called with `effective_limit`.
5. `POST /rest/api/3/search/jql` (JQL search) is NOT called.
6. If `has_more && !all`: `eprintln!("Showing {} results. Use --limit or --all to see more.", issues.len())` to stderr. No approximate-count endpoint is called on the scrum path.
7. If `!has_more || all`: no truncation hint emitted.

**Postconditions — Kanban path (`board_type` is anything other than `"scrum"`)**:
1. `GET /rest/agile/1.0/board/{id}/sprint` is NOT called.
2. JQL `<project-clause> AND statusCategory != Done ORDER BY rank ASC` is sent to `POST /rest/api/3/search/jql`. If no project is configured, the `project = <key>` clause is omitted and a warning is emitted to stderr: `"warning: no project configured for board. Showing issues across all projects. Set project in .jr.toml to scope results."`.
3. If `has_more && !all`: attempts `approximate_count` via `POST /rest/api/3/search/approximate-count`. The request body is `{"jql": <count_jql>}` where `count_jql` = kanban JQL with `ORDER BY rank ASC` stripped via `jql::strip_order_by` (`src/cli/board.rs` line 280). The count-call JQL body is **NOT byte-identical** to the `/search/jql` body in PC2 (no ORDER BY clause). Holdout mocks for the count endpoint must match a body without the ORDER BY.
   - If total > 0: `eprintln!("Showing {} of ~{} results. Use --limit or --all to see more.", issues.len(), total)` to stderr.
   - If total == 0 or count call fails: `eprintln!("Showing {} results. Use --limit or --all to see more.", issues.len())` to stderr (graceful fallback).
4. If `!has_more || all`: no truncation hint emitted.

**Common postconditions (both paths)**:
- All truncation hint text is emitted to **stderr**, not stdout.
- `--all` sets `effective_limit = None` (no cap); `has_more` is then false; no hint is emitted.
- `--limit` + `--all` is a clap-level conflict (BC-5.1.002): exit 2 before any HTTP.
- Table output: issues in the order returned by the API (no client-side reorder).
- JSON output (`--output json`): issues array on stdout; truncation hint still emits to stderr (hints are diagnostic, not data).

**Invariants**:
1. The routing decision is `board_type.to_lowercase() == "scrum"` (case-insensitive on the API-returned string). Any value other than `"scrum"` (e.g., `"kanban"`, `"KANBAN"`, `"next-gen"`) takes the kanban path.
2. Sprint and JQL endpoints are mutually exclusive per invocation — exactly one dispatch path executes.
3. Hint text is ALWAYS on stderr (never stdout). This applies regardless of `--output` mode.
4. `--all` is the only mechanism to suppress the truncation hint — there is no auto-suppress based on result count below a threshold.
5. The board configuration call (`GET /rest/agile/1.0/board/{id}/configuration`) fires on both scrum and kanban paths — it is the branching condition, not part of either branch.

**Edge Cases**:
- EC-5.1.005-1: Scrum board, active sprint exists, results ≤ limit → exit 0, no truncation hint.
- EC-5.1.005-2: Scrum board, active sprint exists, results > limit → exit 0, stderr hint `"Showing N results. Use --limit or --all to see more."` (scrum format — no `~M` component).
- EC-5.1.005-3: Scrum board, no active sprint → exit 1, stderr `"No active sprint found for board <id>."`; issue-fetch call NOT made.
- EC-5.1.005-4: Kanban board, results > limit, count available → stderr `"Showing N of ~M results. Use --limit or --all to see more."` (kanban format with `~M`).
- EC-5.1.005-5: Kanban board, results > limit, count call fails → stderr `"Showing N results. Use --limit or --all to see more."` (graceful fallback, same format as scrum path).
- EC-5.1.005-6: `--all` on scrum board → no truncation hint; sprint endpoint called with no limit cap; `has_more` is false.
- EC-5.1.005-7: Kanban, no project configured → stderr warning before JQL is sent; JQL omits `project =` clause.
- EC-5.1.005-8: `GET /rest/agile/1.0/board/{id}/configuration` fires first on BOTH paths — board_type is determined from the config, so mock servers must respond to the configuration endpoint before any sprint or JQL call.
- EC-5.1.005-9: Scrum sprint-list wire URL is `GET /rest/agile/1.0/board/{id}/sprint?startAt=0&maxResults=50&state=active` (`src/api/jira/sprints.rs` lines 14–20; pagination adds `&state=active` URL-encoded; `startAt=0` on first iteration). Sprint-issues wire URL is `GET /rest/agile/1.0/sprint/{sprintId}/issue?startAt=0&maxResults=50&fields=summary,status,issuetype,priority,assignee,project[,extraFields]`. Holdout mock servers must match these exact query-string forms.
- EC-5.1.005-10: Scrum `--limit N` is CLIENT-SIDE truncation only. `get_sprint_issues` always sends `maxResults=50` on the wire (`src/api/jira/sprints.rs` line 45); the limit is applied as early-stop + `Vec::truncate` in the pagination loop (lines 68–73). Holdout servers must respond to `maxResults=50` queries regardless of the `--limit` value passed by the user.
- EC-5.1.005-11: Kanban JQL project clause uses double-quoted project key via `jql::escape_value` (`src/cli/board.rs` line 166). For project key `FOO`, the clause is `project = "FOO"` (not `project = FOO`). Full JQL for a configured project: `project = "FOO" AND statusCategory != Done ORDER BY rank ASC`. Holdout mock JQL body matchers must expect the quoted form.

**Canonical Test Vectors**:

| Scenario | Board type | API mocks | Expected hint |
|----------|-----------|-----------|---------------|
| Scrum, under limit | scrum | sprint→2 issues, `has_more=false` | none |
| Scrum, over limit | scrum | sprint→30 issues, `has_more=true` | stderr: "Showing 30 results. Use --limit or --all to see more." |
| Scrum, no sprint | scrum | sprint→empty | exit 1, stderr: "No active sprint found for board 5." |
| Kanban, over limit with count | kanban | search→30 issues `has_more=true`, count=87 | stderr: "Showing 30 of ~87 results. Use --limit or --all to see more." |
| Kanban, `--all` | kanban | search→all issues, `has_more=false` | no hint |

**Verification Properties**:
- VP-BOARD-VIEW-001: Scrum board invocation calls sprint endpoint; JQL search mock is not hit (`.expect(0)`).
- VP-BOARD-VIEW-002: Kanban board invocation calls JQL search endpoint; sprint mock is not hit (`.expect(0)`).
- VP-BOARD-VIEW-003: Scrum board with `has_more=true` → stderr contains "Showing" and "results" and "Use --limit or --all" but does NOT contain "~" (no approximate count on scrum path).
- VP-BOARD-VIEW-004: Kanban board with `has_more=true` and count=87 → stderr contains "Showing" and "~87" and "results".
- VP-BOARD-VIEW-005: `--all` on either board type → no truncation hint text on stderr.

**Trace**: `src/cli/board.rs::handle_view`; `src/api/jira/boards.rs`; CLAUDE.md `"board view truncation hint emits to stderr"`; H-NEW-BOARD-VIEW-001 (holdout unblocked by this BC)

[NEW 2026-06-30 BC-subclause-pass F2]

---

### 5.2 Sprint Commands

#### BC-5.2.001: `sprint list/current` errors on kanban boards with `"Sprint commands are only available for scrum boards"`

**Confidence**: HIGH
**Source**: `src/cli/sprint.rs::resolve_scrum_board`; inline tests
**Subject**: Boards & Sprints
**Behavior**: `if board_type != "scrum"` → bail with the literal message. Hard error (not silent degrade).
**Trace**: Pass 3 BC-402

---

#### BC-5.2.002: `sprint add --sprint ID` and `sprint add --current` are mutually exclusive (clap)

**Confidence**: HIGH
**Source**: `tests/cli_smoke.rs::test_sprint_add_sprint_and_current_conflict`
**Trace**: Pass 3 BC-403

---

#### BC-5.2.003: `sprint add` requires `--sprint` or `--current`

**Confidence**: HIGH
**Source**: `tests/cli_smoke.rs::test_sprint_add_requires_sprint_or_current`
**Trace**: Pass 3 BC-404

---

#### BC-5.2.004: `MAX_SPRINT_ISSUES = 50` caps `sprint add` and `sprint remove`

**Confidence**: MEDIUM
**Source**: `src/cli/sprint.rs::handle`; `src/cli/sprint.rs::MAX_SPRINT_ISSUES`; inline unit tests
**Subject**: Boards & Sprints
**Behavior**: At most 50 issues processed per sprint operation.
**Trace**: Pass 3 BC-405

---

#### BC-5.2.005: `sprint current` truncates to 30 by default; with `--all` returns full set; under-limit no hint

**Confidence**: HIGH
**Source**: `tests/sprint_commands.rs::sprint_current_default_limit_caps_at_30`; `tests/sprint_commands.rs::sprint_current_limit_flag`; `tests/sprint_commands.rs::sprint_current_all_flag_returns_everything`
**Subject**: Boards & Sprints
**Behavior**: 35 issues + default → 30 in stdout + stderr `"Showing 30 results"`. With `--all` → 35 + no hint. With 10 issues → no hint.
**Trace**: Pass 3 BC-406

---

#### BC-5.2.006: `sprint current --all --limit N` clap conflict

**Confidence**: HIGH
**Source**: `tests/cli_smoke.rs::test_sprint_current_all_and_limit_conflict`
**Trace**: Pass 3 BC-407

---

#### BC-5.2.007: Sprint JSON output snapshot: `sprint_add_response(100, &["TEST-1", "TEST-2"])` → `{"added": true, "issues": ["TEST-1", "TEST-2"], "sprint_id": 100}`

**Confidence**: HIGH
**Source**: `src/cli/snapshots/jr__cli__sprint__tests__sprint_add_response.snap`
**Behavior**: 3 keys: `sprint_id` (snake_case), `issues` (array), `added` (bool). Sprint ID included on add.
**Trace**: Pass 3 BC-1113 (R4)

---

#### BC-5.2.008: Sprint JSON output: `sprint_remove_response(&["TEST-1", "TEST-2"])` → `{"issues": [...], "removed": true}` (NO sprint_id)

**Confidence**: HIGH
**Source**: `src/cli/snapshots/jr__cli__sprint__tests__sprint_remove_response.snap`
**Behavior**: 2 keys only. Asymmetric with add — remove is sprint-agnostic.
**Trace**: Pass 3 BC-1114 (R4)

---

### 5.3 Team Column Parity

#### BC-5.3.001: Team column appears IFF `team_field_id` configured AND at least one issue has populated team UUID

**Confidence**: HIGH
**Source**: `tests/team_column_parity.rs::sprint_current_shows_team_column_when_populated`; `tests/team_column_parity.rs::board_view_kanban_shows_team_column_when_populated`
**Subject**: Boards & Sprints
**Behavior**: Column gating is conjunctive — both conditions required. Affects `jr sprint current`, `jr board view`, and `jr issue list` (all three call sites use the identical three-level nested-if gate: `OutputFormat::Table` → `team_field_id is Some` → `any uuid is Some`; see `src/cli/board.rs::handle_view` and `src/cli/issue/list.rs::handle_list`).
**Trace**: Pass 3 BC-1138a/c (R4)

---

#### BC-5.3.002: Team column omitted when `team_field_id` not configured OR no issue has team UUID

**Confidence**: HIGH
**Source**: `tests/team_column_parity.rs::sprint_current_omits_team_column_when_field_unconfigured`; `tests/team_column_parity.rs::sprint_current_omits_team_column_when_no_issue_has_team`; `tests/team_column_parity.rs::board_view_kanban_omits_team_column_when_no_issue_has_team`; `tests/team_column_parity.rs::test_board_view_omits_team_column_when_field_unconfigured`; `tests/team_column_parity.rs::test_issue_list_omits_team_column_when_field_unconfigured`
**Trace**: Pass 3 BC-1138b/d (R4); S-626-1 let-chain rewrite adds `else { Vec::new() }` branch coverage for board view and issue list

---

#### BC-5.3.003: Team column falls back to bare UUID when team name is not in cache

**Confidence**: HIGH
**Source**: `tests/team_column_parity.rs::sprint_current_falls_back_to_uuid_when_team_not_cached`
**Behavior**: When the team UUID has no corresponding entry in `teams.json` (cache miss or empty cache), the table cell shows the raw UUID string only — no parenthetical suffix. Implementation: `team_map.get(uuid).cloned().unwrap_or_else(|| uuid.clone())` in `src/cli/board.rs::handle_view` and `src/cli/issue/list.rs::handle_list`. Cross-reference: the `(name not cached — run 'jr team list --refresh')` hint string is ONLY emitted on the single-issue `jr issue view` path (`src/cli/issue/view.rs:~264,269`) and is exclusively owned by **BC-2.3.035**. Do not attribute that hint string to the Team column table path.
**Trace**: Pass 3 BC-1138e (R4)

---

#### BC-5.3.004: `--output json` preserves team UUID without resolution (no cache lookup)

**Confidence**: HIGH
**Source**: `tests/team_column_parity.rs::sprint_current_json_output_keeps_team_uuid_without_resolution`
**Trace**: Pass 3 BC-1138f (R4)

---

### 5.4 API Layer

#### BC-5.4.001: `IssueFields::team_id` accepts string-UUID; rejects non-string id (object form without `id` key)

**Confidence**: HIGH
**Source**: `src/types/jira/issue.rs::IssueFields::team_id`; tests in `src/types/jira/issue.rs::tests`; `tests/team_object_shape.rs`
**Subject**: Boards & Sprints
**Behavior**: String UUID → deserialized. Object `{id: "<uuid>"}` → deserialized (object form). Non-string id without proper structure → `None` or Err.
**Trace**: Pass 3 BC-606

---

## Key Invariants

- `MAX_SPRINT_ISSUES = 50`: hard cap, not configurable
- Scrum-only check: `sprint` commands hard-error on kanban; `issue list` silently degrades (asymmetry documented in Pass 8 §2.5)
- Default limit = 30 (`DEFAULT_LIMIT`); with `--all` → no cap
- Truncation hint emitted to stderr (NOT stdout)
- `--all` suppresses truncation hint
