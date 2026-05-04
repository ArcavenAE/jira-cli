---
title: "BC-03: Issue Write (create/edit/move/assign/comment/link)"
version: "1.0.0"
snapshot_sha: "dea166471e22eff55974d7675593469b37048c5f"
traces_to: "README.md"
source_passes: "Pass 2 broad §2b.1 Issue subsystem + Pass 8 §2.2 BC#3 + R5 §3.3 (NEW-INV-244)"
entity_count: 18
invariant_count: 24
bc_count: 77
risk_level: HIGH
---

# BC-03: Issue Write

Covers the write side of the Issue domain: `jr issue create`, `edit`, `move`, `assign`, `comment`, `link`, `unlink`, `remote-link`. Distinct from issue-read (BC-02) because write operations have mutation semantics, idempotency contracts, and resolution pipelines.

---

## §1 Ubiquitous Language

| Term | Definition |
|------|-----------|
| **Transition** | A Jira-computed state change available for an issue at a given moment. `jr issue move` selects a transition by name or number. |
| **Idempotent move** | `issue move FOO-123 "In Progress"` exits 0 with no HTTP write if already in "In Progress". Canonical idempotency rule. |
| **Resolution resolver** | The pipeline in `workflow.rs` that maps `--resolution` to a `CachedResolution`. Does NOT auto-promote single substring hits — `Ambiguous` always errors. |
| **Transition resolver** | Resolves `--status` against the union of (transition names ∪ to-status names). Number wins over name if `--status` parses as a number. |
| **`partial_match`** | Shared resolver used by transitions, status names, resolution names, link types, and user names. Single-substring → `Ambiguous` → prompt or error. |
| **Link type** | `IssueLinkType` with `name`, `inward`, `outward`. Default link name is `"Relates"`. |
| **Remote link** | A URL-based link to an external resource (`POST /rest/api/3/issue/<key>/remotelink`). Not an issue-to-issue link. |
| **`--internal`** | Flag on `issue comment` that adds `{key:"sd.public.comment", value:{internal:true}}` property. Silent no-op on non-JSM projects. |
| **ADF description** | Issue descriptions and comment bodies are Atlassian Document Format JSON. `jr` converts plain text or markdown to ADF on write. |
| **Write-op JSON shape** | The JSON returned by write commands varies per operation: `{key, status, transitioned}` for move; `{key}` for create; `{changed: bool}` for assign; `{linked: bool}` for link; `{unlinked: bool}` for unlink; `{updated: bool}` for edit. Four distinct boolean names — inconsistency noted (P5R1-AP-05). |

---

## §2 Entities

| Entity | Module | Key Fields | Notes |
|--------|--------|-----------|-------|
| `Transition` | `types/jira/issue.rs:200-205` | `id: String`, `name: String`, `to: Option<Status>` | Read-only — Jira computes available transitions per-issue. Used by `issue move` resolver. |
| `TransitionsResponse` | `types/jira/issue.rs:207-210` | `transitions: Vec<Transition>` | Wrapper for `GET /transitions` payload. |
| `CreateIssueResponse` | `types/jira/issue.rs:228-231` | `key: String` | Intentionally narrow — no `id`, no `self` URL. |
| `CreateRemoteLinkResponse` | `types/jira/issue.rs:233-238` | `id: u64`, `self_url: String` | Returned by `create_remote_link`. |
| `IssueLink` | `types/jira/issue.rs:25-34` | `id: String`, `link_type: IssueLinkType`, `inward_issue: Option<LinkedIssue>`, `outward_issue: Option<LinkedIssue>` | Created via `POST /issueLink`, deleted via `DELETE /issueLink/<id>`. |
| `IssueLinkType` | `types/jira/issue.rs:42-48` | `id: Option<String>`, `name: String`, `inward: Option<String>`, `outward: Option<String>` | Resolved via partial_match. Default: `"Relates"`. |
| `IssueLinkTypesResponse` | `types/jira/issue.rs:50-54` | `issue_link_types: Vec<IssueLinkType>` | — |
| `CachedResolution` | `cache.rs:202-208` | `id: String` (non-optional), `name: String`, `description: Option<String>` | `id` non-optional — resolutions without id are dropped on cache write (with stderr count warning). |
| `ResolutionsCache` | `cache.rs:210-220` | `resolutions: Vec<CachedResolution>`, `fetched_at: DateTime<Utc>` | Whole-file `resolutions.json`, 7-day TTL. |
| `Comment` | (see BC-02) | — | Write side: `POST /rest/api/3/issue/<key>/comment`. ADF body from text/markdown/file/stdin. |
| `Worklog` | `types/jira/worklog.rs:6-16` | `id: Option<String>`, `author: Option<User>`, `time_spent_seconds: Option<u64>`, `time_spent: Option<String>`, `comment: Option<Value>` (ADF), `started: Option<String>` | Write: `POST /worklog`. List: `GET /worklog` (non-paginated — NFR-R-A). |
| `User` | (see BC-02) | — | Assignee resolution target for `issue assign`. |
| `IssueType` | (see BC-02) | — | Input for `issue create --type`, `issue edit --type`. |
| `Priority` | (see BC-02) | — | Input for `issue create --priority`, `issue edit --priority`. |
| Move JSON shape | `cli/issue/json_output.rs` | `{key, status, transitioned: bool}` | `transitioned: false` when already in target state. |
| Create JSON shape | `cli/issue/json_output.rs` | `{key: String}` | Plus `url` field per spec `issue-create-json-full-shape.md`. |
| Assign JSON shape | `cli/issue/json_output.rs` | `{changed: bool}` | `changed: false` when target == current assignee. |
| Edit JSON shape | `cli/issue/json_output.rs` | `{updated: bool}` | — |

---

## §3 Value Objects & Enums

- **Write-op boolean names:** `transitioned` (move), `updated` (edit), `linked` (link), `unlinked` (unlink), `changed` (assign/unassign). Four distinct names — anti-pattern P5R1-AP-05.
- **`MAX_SPRINT_ISSUES = 50`** (`cli/sprint.rs:107`): per-call cap on `sprint add`/`sprint remove`.
- **`--label` add/remove prefixes:** `add:foo` or `remove:foo` syntax for label mutations in `issue edit`.
- **`--description-stdin`** flag: reads description from stdin pipe (AI-agent friendly).
- **`--markdown`** flag: converts description from Markdown to ADF via `adf::markdown_to_adf`.

---

## §4 Operations

| Command | HTTP | Idempotent? | Notes |
|---------|------|-------------|-------|
| `issue create` | `POST /rest/api/3/issue` | No (each call creates a new issue) | ADF-converts description. Optional team/user resolution. |
| `issue edit <key>` | `PUT /rest/api/3/issue/<key>` | No (replaces/modifies state) | Computes field deltas. Labels use `add:`/`remove:` prefixes. |
| `issue move <key> [status]` | `GET /transitions` + `GET /issue` + `POST /transitions` | **Yes** | Exits 0 with `transitioned:false` if already in target. Number beats name for transition selection. |
| `issue assign <key>` | `PUT /rest/api/3/issue/<key>/assignee` | **Yes** | Exits 0 with `changed:false` if target == current. `--unassign` sends `{accountId:null}`. |
| `issue comment <key>` | `POST /rest/api/3/issue/<key>/comment` | No (creates new comment each call) | `--internal` adds JSM property (silent no-op on non-JSM). |
| `issue link <k1> <k2>` | `POST /rest/api/3/issueLink` | No | Resolves link type via partial_match. Default: `"Relates"`. |
| `issue unlink <k1> <k2>` | `DELETE /rest/api/3/issueLink/<id>` (per-match) | **Yes** (re-run = no-op if already unlinked) | Lists links, filters by k2 + optional type, deletes each match. |
| `issue remote-link <key>` | `POST /rest/api/3/issue/<key>/remotelink` | No | Title defaults to URL. |
| `issue resolutions` | Cache-first, `GET /rest/api/3/resolution` | Yes (read-only) | 7-day TTL. `--refresh` forces re-fetch. |
| `sprint add <issue...>` | `POST /rest/agile/1.0/sprint/<id>/issue` | No (API behavior) | Cap: 50 issues/call. |
| `sprint remove <issue...>` | `POST /rest/agile/1.0/board/<id>/backlog` | Yes (API layer) | Cap: 50 issues/call. |
| `worklog add <key> <duration>` | `POST /rest/api/3/issue/<key>/worklog` | No | Duration parsed via `duration::parse_duration(dur, 8, 5)` — hardcoded 8h/day, 5d/week (NFR-R-C). |

---

## §5 Business Rules & Invariants

| ID | Invariant | Source |
|----|----------|--------|
| INV-WRITE-001 | `issue move` is idempotent: if `current_status == target` (case-insensitive), exits 0 with `transitioned:false` and NO HTTP write. | `cli/issue/workflow.rs:192-224`, BC-207 |
| INV-WRITE-002 | Transition match by NUMBER takes precedence over name match. `jr issue move FOO-1 3` selects the 3rd transition by index, not a transition named `"3"`. | `cli/issue/workflow.rs:227-235`, NEW-INV-244 |
| INV-WRITE-003 | Resolution resolver does NOT auto-promote single substring hits. `MatchResult::Ambiguous` always errors; only `Exact` (case-insensitive) resolves. | `workflow.rs:65-79`, Pass 2 INV-10 |
| INV-WRITE-004 | `issue assign` is idempotent: checks current assignee before write. Exits 0 with `changed:false` if target == current. | `cli/issue/workflow.rs`, CLAUDE.md |
| INV-WRITE-005 | 400 "resolution required" from Jira is rewritten to a user-facing hint suggesting `--resolution`. | `workflow.rs:357-377` |
| INV-WRITE-006 | Comment `--internal` adds `{key:"sd.public.comment", value:{internal:true}}` to `properties[]`. On non-JSM projects, Jira silently ignores the property — no error. | `api/jira/issues.rs:181-198`, NEW-INV-257 (per Pass 8 §2.2 BC#10) |
| INV-WRITE-007 | `issue unlink` without `--type` filter removes ALL links between k1 and k2. With `--type`, removes only matching-type links. Re-running on already-unlinked is a no-op (filter empties out). | `cli/issue/links.rs`, Pass 2 §2b.1 |
| INV-WRITE-008 | `sprint add`/`sprint remove` cap at `MAX_SPRINT_ISSUES = 50` per call. Exceeding this count errors with an explicit message before any API call. | `cli/sprint.rs:35-41,55-61,107` |
| INV-WRITE-009 | `worklog add` hardcodes `8h/day, 5d/week` as duration parsing parameters (`parse_duration(dur, 8, 5)`). Jira instance time-tracking settings are ignored. This is NFR-R-C (MEDIUM). | `cli/worklog.rs:32` |
| INV-WRITE-010 | `list_worklogs` fetches only one `OffsetPage<Worklog>` and returns `.items().to_vec()`. `total`/`start_at`/`max_results` silently discarded. Silent truncation at 50 worklogs. This is NFR-R-A (HIGH). | `api/jira/worklogs.rs:25-30` |
| INV-WRITE-011 | Resolutions without an `id` are dropped on cache write, with a stderr count warning. `CachedResolution.id` is non-optional. | `cli/issue/workflow.rs:117-133` |
| INV-WRITE-012 | `issue create` ADF conversion path: plain text → ADF via `adf::text_to_adf`; `--markdown` → ADF via `adf::markdown_to_adf`. Both paths produce ADF JSON consumed by Jira. | `cli/issue/create.rs` |
| INV-WRITE-013 | `issue edit --label add:foo` adds a label; `remove:foo` removes. Labels without prefix are treated as replacements (behavior per Jira field semantics). | `cli/issue/create.rs` |
| INV-WRITE-014 | Write operations that accept `--to <name>` and `--account-id <id>` are mutually exclusive at the clap level. | `cli/mod.rs` |
| INV-WRITE-015 | JSON write-op shapes use 4 distinct boolean field names: `transitioned` (move), `changed` (assign), `updated` (edit), `linked`/`unlinked` (link/unlink). No canonical name. Anti-pattern P5R1-AP-05. | `cli/issue/json_output.rs` |
| INV-WRITE-016 | `issue open <key>` URL composition uses `client.base_url()`, NOT `client.instance_url()`. Broken for OAuth profiles. NFR-R-B (HIGH bug). One-line fix: change `base_url()` → `instance_url()`. | `cli/issue/workflow.rs:636` |
| INV-WRITE-017 | `sprint list`/`sprint current` against a kanban board errors with `"Sprint commands are only available for scrum boards"`. Hard error — unlike `issue list` which silently degrades for kanban. Cross-module asymmetry. | `cli/sprint.rs:79-86` |
| INV-WRITE-018 | `sprint add`/`sprint remove` scrum-only check is done via `board_type == "scrum"` (same as `issue list`). Kanban → error (not silent degrade). | `cli/sprint.rs` |
| INV-WRITE-019 | Resolutions cache is loaded lazily: only when `--resolution` flag is provided on `issue move`. | `cli/issue/workflow.rs` |
| INV-WRITE-020 | `issue assign --unassign` sends `{accountId: null}` via Jira assignee endpoint. This is the canonical unassign mechanism. | `cli/issue/workflow.rs` |
| INV-WRITE-021 | `issue comment` reads message from: positional arg → `--file <path>` → `--stdin`. Exactly one source must be present in `--no-input` mode. | `cli/issue/workflow.rs::handle_comment` |
| INV-WRITE-022 | Auth subcommands (login/switch/logout/remove/refresh) lack JSON output paths. Only text output. 5 of N commands without `--output json` support. Gap noted in Pass 5 R2-T2. | `cli/auth.rs` |
| INV-WRITE-023 | `issue remote-link` title defaults to the URL when `--title` is not provided. | `cli/issue/links.rs::handle_remote_link` |
| INV-WRITE-024 | `issue link` default link type is `"Relates"` when `--type` is not provided. | `cli/mod.rs`, `cli/issue/links.rs` |

---

## §6 Aggregate Boundaries

- **`Issue`** is the aggregate root for all write operations. Mutations (edit, move, assign) act on the `Issue` via Jira API.
- **`Comment`** is its own root: written via separate endpoint, not aggregated into `Issue`.
- **`Worklog`** is its own root: written via separate endpoint.
- **`IssueLink`** is created and deleted at its own endpoint; not part of the `Issue` aggregate in the write sense.
- **Resolution cache** is owned by the Cache context but consumed here by `workflow.rs`.

---

## §7 Cross-Context Dependencies

| Depends on | Reason |
|-----------|--------|
| **Configuration (BC-06)** | Reads `story_points_field_id`, `team_field_id` (NFR-R-D: currently reads legacy `config.global.fields.*`, not per-profile). |
| **Cache (BC-06)** | Reads `resolutions.json` for `issue move --resolution`. |
| **Auth (BC-01)** | `JiraClient` for all HTTP. |
| **Output (BC-07)** | JSON shapes via `json_output.rs`. |
| **Cross-cutting** | `partial_match` for transition/resolution/link-type name resolution. `duration.rs` for `worklog add`. `adf.rs` for description/comment conversion. |
