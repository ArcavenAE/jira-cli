---
title: "BC-05: Boards & Sprints"
version: "1.0.0"
snapshot_sha: "dea166471e22eff55974d7675593469b37048c5f"
traces_to: "README.md"
source_passes: "Pass 2 broad §2a.2 Jira (Board/Sprint) + §2b.1 Board/Sprint + Pass 8 §2.2 BC#6"
entity_count: 14
invariant_count: 14
bc_count: 35
risk_level: MEDIUM
---

# BC-05: Boards & Sprints

Covers `jr board list`, `board view`, `sprint list`, `sprint current`, `sprint add`, `sprint remove`, and the sprint-aware `issue list` dispatch (see also BC-02 INV-READ-006). The scrum/kanban distinction is the primary domain invariant.

Also covers: `jr worklog add`/`list`, `jr team list`, `jr user search`/`list`/`view`.

---

## §1 Ubiquitous Language

| Term | Definition |
|------|-----------|
| **Scrum board** | `board_type == "scrum"`. Supports sprint commands. |
| **Kanban board** | `board_type` other than `"scrum"`. Sprint commands error out. |
| **Board ID** | Integer ID of a Jira Agile board. Configured in `.jr.toml::board_id` or overridden with `--board`. |
| **Active sprint** | A sprint with `state == "active"`. `sprint current` uses the first active sprint on the board. |
| **`MAX_SPRINT_ISSUES = 50`** | Hard cap on issues per `sprint add`/`sprint remove` call. |
| **Org discovery** | GraphQL `tenantContexts` query (ADR-0005) to discover `org_id` for team list. Lazy: runs once per init or on first team-needing command without cached org_id. |
| **Team cache** | `teams.json` per profile, 7-day TTL. Populated by `jr team list`. Read (but not populated) by issue list for team-name resolution. |
| **`USER_PAGINATION_SAFETY_CAP = 1500`** | Max users returned by `jr user list --all` (15 pages × 100). Emits stderr warning when hit. |

---

## §2 Entities

| Entity | Module | Key Fields | Notes |
|--------|--------|-----------|-------|
| `Board` | `types/jira/board.rs:3-11` | `id: u64`, `name: String`, `board_type: String`, `location: Option<BoardLocation>` | Read-only. `board_type` drives scrum-vs-kanban behaviour. References `ProjectConfig.board_id`. |
| `BoardLocation` | `types/jira/board.rs:13-19` | `project_key: Option<String>`, `project_name: Option<String>` | — |
| `BoardConfig` | `types/jira/board.rs:21-27` | `id: u64`, `name: String`, `board_type: String` (default `""`) | Used to resolve kanban-vs-scrum check. |
| `Sprint` | `types/jira/sprint.rs:3-12` | `id: u64`, `name: String`, `state: Option<String>` (`"active"`/`"closed"`/`"future"`), `start_date: Option<String>`, `end_date: Option<String>` | Read via `list_sprints`, `get_sprint`. Sprint struct doesn't carry issues — fetched separately. |
| `TeamEntry` | `types/jira/team.rs:26-32` | `team_id: String`, `display_name: String` | Cached as `CachedTeam`. |
| `CachedTeam` | `cache.rs:45-49` | `id: String`, `name: String` | Persisted shape in `teams.json`. |
| `TeamCache` | `cache.rs:51-61` | `fetched_at: DateTime<Utc>`, `teams: Vec<CachedTeam>` | Whole-file `teams.json`, 7-day TTL. |
| `TenantContext` | `types/jira/team.rs:17-23` | `org_id: String`, `cloud_id: String` | Returned by GraphQL `tenantContexts`. |
| `TeamsResponse` | `types/jira/team.rs:34-39` | `entities: Vec<TeamEntry>`, `cursor: Option<String>` | Cursor-paginated. |
| `Worklog` | `types/jira/worklog.rs:6-16` | `id: Option<String>`, `author: Option<User>`, `time_spent_seconds: Option<u64>`, `time_spent: Option<String>`, `comment: Option<Value>` (ADF), `started: Option<String>` | Write: `POST /worklog`. List: `GET /worklog` — non-paginated (NFR-R-A). |
| `User` | (see BC-02) | — | Target for `user search`/`list`/`view`. |
| `ServiceDesk` | (see BC-02) | — | JSM service-desk detection for `queue` commands. |
| `Queue` | (see BC-02) | — | JSM queue for `jr queue list`/`view`. |
| `QueueIssueKey` | (see BC-02) | — | Thin-projection bridge from JSM queue to full issue. |

---

## §3 Value Objects & Enums

- **`MAX_SPRINT_ISSUES = 50`** (`cli/sprint.rs:107`): enforced before any API call; exceeding errors with explicit message.
- **Sprint state vocabulary**: `"active"`, `"closed"`, `"future"` — raw strings from Jira API.
- **`USER_PAGINATION_SAFETY_CAP = 1500`** (`api/jira/users.rs`): 15 pages × 100. Emits `"hit pagination safety cap"` on stderr (exit 0).
- **`USER_PAGE_SIZE = 100`**: page size for user list operations. `--all` advances by REQUESTED `maxResults` (deliberate JRACLOUD-71293 workaround).

---

## §4 Operations

| Command | HTTP | Idempotent? | Notes |
|---------|------|-------------|-------|
| `board list [--type T]` | `GET /rest/agile/1.0/board` | Yes | Type filter: `scrum`/`kanban`. |
| `board view [--board ID]` | `GET /rest/agile/1.0/board/<id>/issue` | Yes | Resolves board from `--board` or `.jr.toml::board_id`. |
| `sprint list [--board ID]` | `GET /rest/agile/1.0/board/<id>/sprint` | Yes | Errors on kanban. |
| `sprint current [--board ID]` | As above + sprint issues | Yes | Uses first active sprint. |
| `sprint add <issue...> (--sprint ID \| --current)` | `POST /rest/agile/1.0/sprint/<id>/issue` | No (API behavior) | Cap: 50 issues/call. |
| `sprint remove <issue...>` | `POST /rest/agile/1.0/board/<id>/backlog` | Yes (API layer) | Cap: 50 issues/call. |
| `worklog add <key> <duration>` | `POST /rest/api/3/issue/<key>/worklog` | No | Hardcoded 8h/day, 5d/week (NFR-R-C). |
| `worklog list <key>` | `GET /rest/api/3/issue/<key>/worklog` | Yes | Non-paginated — silently truncates at 50 (NFR-R-A). |
| `team list [--refresh]` | Cache-first; on miss: GraphQL `tenantContexts` + `GET /gateway/api/public/teams/v1/org/<orgId>/teams` | Yes | Cursor-paginated. |
| `user search <query>` | `GET /rest/api/3/user/search?query=<q>` | Yes | Paginated up to 1000-user hard cap. |
| `user list -p <project>` | `GET /rest/api/3/user/assignable/multiProjectSearch` | Yes | Paginated. |
| `user view <accountId>` | `GET /rest/api/3/user?accountId=<a>` | Yes | — |
| `queue list` | `GET /servicedeskapi/servicedesk/<id>/queue` | Yes | Requires service desk discovery (cache or API). |
| `queue view [name]` | `GET /servicedeskapi/servicedesk/<id>/queue/<qid>/issue` + followup search | Yes | Resolves queue by partial_match name or `--id`. |

---

## §5 Business Rules & Invariants

| ID | Invariant | Source |
|----|----------|--------|
| INV-BS-001 | `sprint list`/`sprint current` against a kanban board errors with explicit `"Sprint commands are only available for scrum boards. Board <id> is a <type> board."` — hard error, NOT silent degrade. | `cli/sprint.rs:79-86` |
| INV-BS-002 | `sprint add`/`sprint remove` cap at `MAX_SPRINT_ISSUES = 50` per call. Error message is emitted BEFORE any API call if count exceeds 50. | `cli/sprint.rs:35-41,55-61,107` |
| INV-BS-003 | Scrum board in `issue list` with no active sprint silently degrades to project-scoped query (`ORDER BY updated DESC`). NO `eprintln!` warning. Cross-module asymmetry with `cli/sprint.rs`. | `cli/issue/list.rs:283-293`, NEW-INV-219 |
| INV-BS-004 | Kanban board in `issue list` uses `statusCategory != Done ORDER BY rank ASC`. Hardcoded heuristic for kanban WIP region. | `cli/issue/list.rs:302-310`, NEW-INV-220 |
| INV-BS-005 | Any `board_type` other than `"scrum"` falls to the kanban arm in `issue list`, including future Atlassian board types. | `cli/issue/list.rs`, NEW-INV-222 |
| INV-BS-006 | Board-fetch 404 in `issue list` → `UserError` (not silent degrade). | `cli/issue/list.rs` |
| INV-BS-007 | Team cache is populated by `jr team list` ONLY. `issue list` reads it but never populates it. | `cli/issue/list.rs:514-517`, NEW-INV-224 |
| INV-BS-008 | Org discovery (GraphQL `tenantContexts`) is lazy: runs once on `jr init` or on first team-needing command without cached `org_id`. Results cached in `config.toml`. | ADR-0005, `cli/team.rs` |
| INV-BS-009 | `worklog add` hardcodes `8h/day, 5d/week` for duration parsing. Instance time-tracking settings are ignored (NFR-R-C MEDIUM). | `cli/worklog.rs:32` |
| INV-BS-010 | `list_worklogs` non-paginated: fetches one page, returns `.items().to_vec()`. Silent truncation at ~50 worklogs (NFR-R-A HIGH). | `api/jira/worklogs.rs:25-30` |
| INV-BS-011 | `user list --all` uses `USER_PAGINATION_SAFETY_CAP = 1500` (15 pages × 100). Hits cap → emits `"hit pagination safety cap"` on stderr; exits 0. | `api/jira/users.rs`, BC-1124/1125 |
| INV-BS-012 | `user search`/`user list` `--all` advances by REQUESTED `maxResults` (not ACTUAL returned count). Deliberate JRACLOUD-71293 workaround. | `api/jira/users.rs` |
| INV-BS-013 | JSM service-desk detection uses `cache::ProjectMeta::service_desk_id` if present. On miss, fetches and caches. A project with `project_type_key != "service_desk"` → no service desk → `queue` commands error. | `api/jsm/servicedesks.rs`, `cache.rs` |
| INV-BS-014 | `queue view` by name uses `partial_match` with the same single-substring-is-Ambiguous semantics as all other name resolvers. | `cli/queue.rs` |

---

## §6 Aggregate Boundaries

- **`Board`** is a thin root. Does not aggregate sprints or issues — those are queried separately.
- **`Sprint`** is its own root. Does not own issues.
- **`ServiceDesk → Queue → Issue`** is a three-level lookup; the aggregate boundary stops at issue key (thin-projection).

---

## §7 Cross-Context Dependencies

| Depends on | Reason |
|-----------|--------|
| **Configuration (BC-06)** | `.jr.toml::board_id`, `org_id` in profile for team discovery. |
| **Cache (BC-06)** | `teams.json`, `project_meta.json` (JSM detection). |
| **Issue Read (BC-02)** | `sprint current` feeds issue keys to `search_issues` (same path as `issue list`). |
| **Auth (BC-01)** | `JiraClient` for all HTTP. |
| **Output (BC-07)** | Table/JSON for all commands. |
| **Cross-cutting** | `duration.rs` for `worklog add`. `partial_match` for queue name resolution. |
