---
context: bc-2
title: "Issue Read (list/view/comments/changelog)"
total_bcs: 106   # cumulative claim (incl. range-collapsed); definitional_count below is individually-bodied headings
definitional_count: 64   # count of `#### BC-` headings in this file
last_updated: 2026-07-15
source_pass: 3
trace: |
  - L2: .factory/specs/domain-spec/bc-02-issue-read.md
  - Source broad: .factory/semport/jira-cli/jira-cli-pass-3-behavioral-contracts.md §2.2
  - Source R1: .factory/semport/jira-cli/jira-cli-pass-3-deep-r1.md §3.2
  - Source R4: .factory/semport/jira-cli/jira-cli-pass-3-deep-r4.md §3.1
  - SOH-ATTACHMENTS-1 F2 addition (2026-07-15): BC-2.7.001..012 — Attachment Read: attachment list (table+JSON, filters mime/name/size-max), attachment download (single/batch/newest, streaming, redirect-following, CWE-22 sanitization, SHA-1 default path, JSDCLOUD-10841 JSM uniform), error taxonomy (DEC-179, issues #576 #585)
---

# BC-2 — Issue Read (list / view / comments / changelog)

106 behavioral contracts across 7 subdomains: JQL composition (2.1), Issue list
behavior (2.2), Issue view (2.3), Comments (2.4), Changelog (2.5), API layer (2.6),
Attachment Read (2.7).

---

## Subdomains

### 2.1 JQL Composition (the canonical build pipeline)

#### BC-2.1.001: `issue list` cursor-paginates via `POST /rest/api/3/search/jql`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:7-31, 130-166`
**Subject**: Issue read
**Behavior**: `client.search_issues(jql, limit, fields)` posts to `/rest/api/3/search/jql`; returns `{issues: Vec<Issue>, has_more: bool}`. Pagination via `nextPageToken` cursor.
**Trace**: Pass 3 BC-101

---

#### BC-2.1.002: `--jql X` wraps in parens, strips ORDER BY, re-appends `ORDER BY updated DESC`

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:36-52`; `tests/all_flag_behavior.rs:54-66`; unit tests covering `build_jql_base_parts` variants
**Subject**: Issue read
**Behavior**: `build_jql_base_parts(jql, project_key)` calls `jql::strip_order_by(jql)`, wraps in parens. Order-by slot is ALWAYS `"updated DESC"` — user's `ORDER BY rank ASC` is silently replaced. `--jql "priority = Highest ORDER BY created DESC" --project PROJ` → `(project = "PROJ") AND (priority = Highest) ORDER BY updated DESC`.
**Edge cases**: user ORDER BY is stripped, never preserved.
**Trace**: Pass 3 BC-102, BC-125 (R1)

---

#### BC-2.1.003: Scrum board with active sprint → JQL `sprint = <id> ORDER BY rank ASC`

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:278-282`; `tests/all_flag_behavior.rs:347-352`
**Subject**: Issue read
**Behavior**: When no `--jql` AND board_id+scrum+active-sprint: `sprint = {sprint.id}` + order by `rank ASC`. Sprint ID from `client.list_sprints(bid, Some("active"))`.
**Trace**: Pass 3 BC-126 (R1)

---

#### BC-2.1.004: Kanban board → `project = "X" AND statusCategory != Done ORDER BY rank ASC`

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:302-310`; `tests/all_flag_behavior.rs:497-516, 542-562`
**Subject**: Issue read
**Behavior**: Body-match pins literal composed JQL. The `statusCategory != Done` is server-side (not `--open` flag).
**Trace**: Pass 3 BC-127 (R1)

---

#### BC-2.1.005: No board_id → `project = "X" ORDER BY updated DESC`

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:331-338`; `tests/all_flag_behavior.rs:42-86`
**Trace**: Pass 3 BC-128 (R1)

---

#### BC-2.1.006: No project AND no filters AND no `--jql` → exit 64 listing all 13 filter sources

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:344-351`
**Subject**: Issue read
**Behavior**: stderr contains literal `"No project or filters specified. Use --project, --assignee, --reporter, --status, --open, --team, --recent, --created-after, --created-before, --updated-after, --updated-before, --asset, or --jql. You can also set a default project in .jr.toml or run \"jr init\"."`.
**Error taxonomy**: `JrError::UserError` (exit 64).
**Trace**: Pass 3 BC-129 (R1)

---

#### BC-2.1.007: `build_filter_clauses` emits in stable order: assignee, reporter, status, open, team, recent, asset, created-after/before, updated-after/before

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:613-649`; unit tests covering `build_jql_parts_*` clause variants
**Subject**: Issue read
**Behavior**: Each `Some` flag pushes clause in listed order. Final JQL: `parts.join(" AND ")`. Order stable across invocations. Key clause shapes:
- `assignee = currentUser()` (for `--assignee me`)
- `reporter = <accountId>` (raw, not quoted)
- `created >= -7d` (for `--recent 7d`)
- `statusCategory != Done` (for `--open`)
- `status = "He said \"hi\" \\o/"` (JQL-escaped)
**Trace**: Pass 3 BC-130 (R1); BC-1093 (R4 enumeration)

---

#### BC-2.1.008: `--recent <duration>` validated by `jql::validate_duration` (NOT `duration::parse_duration`); combined units rejected

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:90-92`; `src/jql.rs:16-34`
**Subject**: Issue read
**Behavior**: `validate_duration("4w2d")` → Err. `--recent 4w2d` → `JrError::UserError("Invalid duration '4w2d'. Use a number followed by y, M, w, d, h, or m (e.g., 7d, 4w, 2M).")`. Pre-HTTP validation.
**Trace**: Pass 3 BC-131 (R1)

---

#### BC-2.1.009: `--created-after/before` and `--updated-after/before` validated via `jql::validate_date` BEFORE any HTTP

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:95-114`
**Subject**: Issue read
**Behavior**: Format: `YYYY-MM-DD`. On invalid: `Invalid date "<X>". Expected format: YYYY-MM-DD (e.g., 2026-03-18).` All four validators run before HTTP.
**Trace**: Pass 3 BC-132 (R1)

---

#### BC-2.1.010: `--created-before` and `--updated-before` use `date + Days::new(1)` for end-day-inclusive semantics

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:118-126`
**Subject**: Issue read
**Behavior**: User passes `--created-before 2026-03-31`; emitted clause is `created < "2026-04-01"`. Pinned by unit test `build_jql_parts_created_date_range`.
**Trace**: Pass 3 BC-133 (R1)

---

#### BC-2.1.011: `--asset KEY` resolves via CMDB fields; if NO CMDB fields → exit 64 with JSM plan message

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:168-183`
**Subject**: Issue read
**Behavior**: On `cmdb_fields.is_empty()`: `JrError::UserError("--asset requires Assets custom fields on this Jira instance. Assets requires a paid Jira Service Management plan.")`.
**Trace**: Pass 3 BC-134 (R1)

---

#### BC-2.1.012: `--asset KEY` ambiguous AQL result → exit 64 `Multiple assets match`; NO issue search fired

**Confidence**: HIGH
**Source**: `tests/assets.rs:1480-1573`; `src/cli/issue/list.rs:128-133`
**Subject**: Issue read
**Behavior**: Test asserts `stderr.contains("Multiple assets match")` + both candidate labels + `expect(0)` on `/rest/api/3/search/jql`. Exit 64.
**Trace**: Pass 3 BC-135 (R1)

---

#### BC-2.1.013: `--status <single-substring>` → exit 64 `Ambiguous status`; NO JQL search fired

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs:368-422`; `src/cli/issue/list.rs:222-247`
**Subject**: Issue read
**Behavior**: `Mock::expect(0)` on `POST /rest/api/3/search/jql`. stderr `Ambiguous status "prog". Matches: In Progress`. Exit 64.
**Trace**: Pass 3 BC-105, BC-136 (R1)

---

#### BC-2.1.014: `--status NOMATCH` → `JrError::UserError` listing available statuses alphabetically

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:234-246`
**Subject**: Issue read
**Behavior**: `MatchResult::None(all)` constructs full error: `"No status matching \"X\" for project Y. Available: <comma-joined alphabetical list>"`. List always sorted.
**Trace**: Pass 3 BC-138 (R1)

---

#### BC-2.1.015: `--status <ExactMultiple>` treated as Exact (case-variant duplicates)

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:223-226`
**Trace**: Pass 3 BC-137 (R1)

---

#### BC-2.1.016: `--assets` column auto-enabled when `--asset KEY` filter is set

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:86-87`
**Subject**: Issue read
**Behavior**: `let show_assets = show_assets || asset_key.is_some();`
**Trace**: Pass 3 BC-145 (R1)

---

#### BC-2.1.017: `--assets` with no CMDB fields → stderr warning, no asset column

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:357-371`
**Behavior**: stderr: `"warning: --assets ignored. No Assets custom fields found on this Jira instance."`.
**Trace**: Pass 3 BC-146 (R1)

---

### 2.2 Issue List Behavior

#### BC-2.2.018: `--all` passes `maxResults=50`; default passes `maxResults=30`

**Confidence**: HIGH
**Source**: `tests/all_flag_behavior.rs:42-145`
**Subject**: Issue read
**Behavior**: `maxResults=50` for `--all`; `maxResults=30` for default. Pinned by request body match. `src/api/jira/issues.rs:50`: `max_per_page = limit.unwrap_or(50).min(100)`.
**Trace**: Pass 3 BC-103, BC-141 (R1)

---

#### BC-2.2.019: Truncation triggers second HTTP `POST /rest/api/3/search/approximate-count`

**Confidence**: HIGH
**Source**: `tests/all_flag_behavior.rs:88-145`; body-match pins `"jql": "(project = CAP)"`
**Subject**: Issue read
**Behavior**: When `--all` NOT set AND results > limit: issues `POST /search/approximate-count` with ORDER BY-stripped JQL. Stderr: `Showing 30 of ~42`. With `--all`: no truncation hint AND no count call.
**Trace**: Pass 3 BC-104, BC-140 (R1)

---

#### BC-2.2.020: `--all` + `--limit N` clap conflict: `cannot be used with`

**Confidence**: HIGH
**Source**: `tests/cli_smoke.rs:300-307`
**Trace**: Pass 3 BC-142 (R1)

---

#### BC-2.2.021: `--points` with no story_points_field_id → silently ignored, stderr warning

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:756-770`
**Subject**: Issue read
**Behavior**: stderr: `"warning: --points ignored. Story points field not configured. Run "jr init" or set story_points_field_id under [profiles.<name>] in ~/.config/jr/config.toml"`. Non-fatal; list proceeds without points column. Note: message must reference `[profiles.<name>]` not the deprecated `[fields]` section.
**Related**: BC-6.3.001 (multi-profile fields MUST-FIX); the error message text updated here is one of the pinned-text changes required by that fix.
**Trace**: Pass 3 BC-143 (R1)

---

#### BC-2.2.022: `--points` with configured field → pushes `customfield_NNNNN` onto request `extra` fields list

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:147-149, 656-668`
**Trace**: Pass 3 BC-144 (R1)

---

#### BC-2.2.023: Asset enrichment deduplicates by `(workspace_id, object_id)` before per-asset GETs

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:397-411`
**Subject**: Issue read
**Behavior**: `to_enrich: HashMap<(String, String), ()>` collects unique workspace/object pairs. Per-asset GETs issued once per unique key via `join_all` (concurrent). Mitigates partial N+1.
**Trace**: Pass 3 BC-147 (R1)

---

#### BC-2.2.024: board_id 404 → exit 64 with `Board 42 not found or not accessible` + board_id hint + `--jql` hint

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs:21-76`
**Error taxonomy**: `JrError::UserError`.
**Trace**: Pass 3 BC-106

---

#### BC-2.2.025: board config 5xx → exit 1 with `Failed to fetch config for board 42` + `--jql` hint

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs:78-130`
**Trace**: Pass 3 BC-107

---

#### BC-2.2.026: Sprint list 5xx → exit 1 with `Failed to list sprints for board 42` + `--jql` hint

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs:132-194`
**Trace**: Pass 3 BC-108

---

#### BC-2.2.027: No active sprint → falls back to project-scoped JQL without error

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs:196-263`
**Subject**: Issue read
**Behavior**: Empty `state=active` sprint list → falls back to `project = PROJ` JQL. No error, no warning (silent degrade per state machine §2.5 of Pass 8 synthesis).
**Trace**: Pass 3 BC-109

---

#### BC-2.2.028: `search_issues` default fields list: 16 fields in EXACT order

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:967-1022`
**Subject**: Issue read
**Behavior**: `summary, status, issuetype, priority, assignee, reporter, project, description, created, updated, resolution, components, fixVersions, labels, parent, issuelinks`. Body partial-JSON match asserts EXACT array.
**Trace**: Pass 3 BC-1063 (R4)

---

#### BC-2.2.029: `search_issues` with cursor continuation token sets `has_more = true`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:264-310`
**Trace**: Pass 3 BC-1047, BC-1048 (R4)

---

#### BC-2.2.030: `search_issues` JQL body includes literal composed string with double-quoted project key

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:492-524`
**Behavior**: `project = "PROJ" AND (priority = Highest) ORDER BY updated DESC` pinned by body partial-match.
**Trace**: Pass 3 BC-1052 (R4)

---

#### BC-2.2.031: `client.approximate_count(jql)` POSTs to `/rest/api/3/search/approximate-count`; 5xx propagates as Err

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:337-386`
**Behavior**: Returns `u64`. Zero and 42 boundary cases tested. Server error → Err.
**Trace**: Pass 3 BC-1050 (R4)

---

### 2.3 Issue View

#### BC-2.3.032: `issue view <key>` GETs `/rest/api/3/issue/<key>` with `--output json` returning raw JSON

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:33-53`
**Trace**: Pass 3 BC-112

---

#### BC-2.3.033: `issue view` 5xx → exit 1 + `API error (500)` + no panic

**Confidence**: HIGH
**Source**: `tests/issue_view_errors.rs:18-56`
**Trace**: Pass 3 BC-113; BC-1135a (R4)

---

#### BC-2.3.034: `issue view` 401 → exit 2 + `Not authenticated` + `jr auth login`

**Confidence**: HIGH
**Source**: `tests/issue_view_errors.rs:58-100`
**Trace**: Pass 3 BC-114; BC-1135b (R4)

---

#### BC-2.3.035: Corrupt `teams.json` cache is non-fatal; UUID + "name not cached" hint shown inline

**Confidence**: HIGH
**Source**: `tests/issue_view_errors.rs:142-206`
**Subject**: Issue read
**Behavior**: Truncated `teams.json` (`{"teams": [`) → `read_cache` returns `Ok(None)` (parse-fail = cache miss). Issue view exits 0. Team row shows raw UUID + `(name not cached — run 'jr team list --refresh')`. stderr NOT contain `panic`.
**Trace**: Pass 3 BC-115; BC-1135d (R4); Top-30 BC rank #26

---

#### BC-2.3.036: `get_issue` deserializes: created, updated, reporter, resolution, components, fix_versions (all nullable)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:526-577, 579-607`
**Behavior**: Full fixture: all fields present. Minimal fixture: all return `None` (NOT panic). RFC3339+0000 timestamps, camelCase JSON paths.
**Trace**: Pass 3 BC-1053, BC-1054 (R4)

---

#### BC-2.3.037: `get_issue` with parent + links deserializes `fields.parent.key`, `fields.issuelinks[0].link_type.name`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:208-231`
**Trace**: Pass 3 BC-1044 (R4)

---

#### BC-2.3.038: `IssueFields::story_points("customfield_X")` returns None for non-numeric values

**Confidence**: HIGH
**Source**: `src/types/jira/issue.rs:83-85`
**Trace**: Pass 3 BC-124

---

### 2.4 Comments

#### BC-2.4.039: `issue comments <key>` paginates at 100/page with `expand=properties`

**Confidence**: HIGH
**Source**: `tests/comments.rs:9-46, 73-158`
**Subject**: Issue read
**Behavior**: `maxResults=100`. `--limit N` → `maxResults=N`. Paginates via startAt until total reached.
**Trace**: Pass 3 BC-116

---

#### BC-2.4.040: `issue comments` 5xx → exit 1 + `API error (500)`

**Confidence**: HIGH
**Source**: `tests/comments.rs:163-200`
**Trace**: Pass 3 BC-117

---

#### BC-2.4.041: `issue comments --internal` adds `sd.public.comment` property (JSM-aware)

**Confidence**: MEDIUM
**Source**: `src/api/jira/issues.rs:181-198`
**Behavior**: `properties: [{key:"sd.public.comment", value:{internal:true}}]` on write. Read shape preserves `EntityProperty[]`. Non-JSM: Jira silently ignores.
**Trace**: Pass 3 BC-118

---

#### BC-2.4.042: `client.list_comments(key, None)` lists ALL comments via offset pagination

**Confidence**: HIGH
**Source**: `tests/comments.rs:104-158`
**Behavior**: Advances `startAt` by 100 until total reached.
**Trace**: Pass 3 BC-122

---

#### BC-2.4.043: `list_comments` offset pagination aborts cleanly if startAt does not advance (anti-stall guard)

**Confidence**: HIGH
**Source**: `src/api/jira/issues.rs::list_comments` (impl guard); `tests/comments.rs::test_list_comments_stall_guard_returns_error_when_start_at_does_not_advance` (verification)
**Subject**: Issue read
**Behavior**: After each page fetch inside `list_comments`, before advancing `start_at`, the implementation MUST check `if next_start_at <= start_at`. If the condition is true, it MUST return `Err(anyhow::anyhow!("Jira comment pagination did not advance (startAt {} → {}) — aborting to prevent infinite loop", start_at, next_start_at))` — an abort, not a silent loop or an empty-result return. `start_at` is only advanced to `next_start_at` when `next_start_at > start_at`. This guard pattern is identical to the one in `get_changelog` (the reference implementation) and is a defensive-by-design guard against a non-advancing `startAt` offset / stale `has_more` (infinite-loop class). No external tracker ticket is cited — none publicly documents this symptom for the comment endpoint; the guard exists to mirror the `get_changelog` anti-loop guard as a precautionary measure. The guard does NOT apply to cursor-based paginators (`search_issues`, `search_issue_keys`) — those use the JRACLOUD-95368 repeated-token guard instead (BC-2.6.050, BC-2.6.051).
**Edge cases**:
- EC-1: Server returns `total > current_count` (has_more true) but `next_start_at == start_at` (zero-advance) → Err, no further pages fetched.
- EC-2: Server returns `total > current_count` but `next_start_at < start_at` (regression) → same Err path. _(Note: the strict-regression branch `next < start_at` is unreachable for a well-formed u32 OffsetPage response — reaching it would require u32 offset overflow. The `<=` guard is retained as defensive code mirroring `get_changelog`; the reachable case under test is the `==` zero-advance arm, EC-1 above, which is exercised by `max_results == 0`.)_
- EC-3: Normal page where `next_start_at > start_at` → advances cleanly, loop continues.
- EC-4: Final page where `has_more = false` → exits loop normally before guard is evaluated.
**Trace**: CR-001 (Bundle C 2026-06-17); reference impl: `src/api/jira/issues.rs::get_changelog` offset-guard at `if next <= start_at`

---

### 2.5 Changelog

#### BC-2.5.043: `issue changelog --field <substr>` filters items by case-insensitive field substring (client-side)

**Confidence**: MEDIUM
**Source**: `src/cli/issue/changelog.rs`; unit tests in `src/cli/issue/changelog.rs::tests`
**Trace**: Pass 3 BC-119

---

#### BC-2.5.044: `issue changelog --author X` smart-constructs author needle (`:` or 12+ chars with digit → exact accountId)

**Confidence**: MEDIUM
**Source**: `src/cli/issue/changelog.rs` author needle
**Trace**: Pass 3 BC-120

---

#### BC-2.5.045: `issue changelog --reverse` reverses chronological order

**Confidence**: MEDIUM
**Source**: `src/cli/issue/changelog.rs`
**Trace**: Pass 3 BC-121

---

#### BC-2.5.046: Changelog JSON output snapshot pins full shape including nullable `fromString`/`toString`

**Confidence**: HIGH
**Source**: `tests/snapshots/issue_changelog__changelog_json_output_snapshot.snap`
**Subject**: Issue read
**Behavior**: `{entries: [{author: {accountId, active, displayName, emailAddress}, created, id, items: [{field, fieldtype, from, fromString, to, toString}]}], key}`. `author` can be `null` (system events). `fromString`/`toString` ARE nullable (null != missing).
**Trace**: Pass 3 BC-1118 (R4)

---

### 2.6 API Layer (Search / Find)

#### BC-2.6.047: `client.search_issues` with story-points extra field: deserializes `Some(5.0)` for issue with field, `None` without

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:130-166`
**Trace**: Pass 3 BC-1041 (R4)

---

#### BC-2.6.048: `client.find_story_points_field_id()` returns fields with name == "Story Points" from `/rest/api/3/field`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:168-186`
**Trace**: Pass 3 BC-1042 (R4)

---

#### BC-2.6.049: `search_users` accepts FOUR distinct response shapes (bare array, paginated, empty, error)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:388-490`
**Subject**: Issue read
**Behavior**: Bare array `[{...}]`; `{values: [...]}` paginated envelope; `[]`; error shape → Err. Via serde-untagged enum. Unrecognized shapes do NOT default to empty — they error.
**Trace**: Pass 3 BC-1051 (R4); Top-30 BC rank #20

---

#### BC-2.6.050: `client.search_issue_keys(jql, limit)` posts `/rest/api/3/search/jql` with body `fields: ["key"]` and returns `KeySearchResult { keys, has_more }`

**Confidence**: HIGH
**Source**: issue #350 (audit-followup from PR #348 / issue #110 PR2 Copilot review round 7); spec at `docs/specs/2026-05-13-search-issue-keys.md`; research at `.factory/research/issue-350-search-issue-keys-design.md`
**Subject**: Issue read (API layer — keys-only JQL search)
**Behavior**: POST `/rest/api/3/search/jql` sends body `fields: ["key"]` exclusively (never `BASE_ISSUE_FIELDS`). Deserializes only the top-level `key` per issue; ignores `fields {}` and unknown top-level fields. Paginates via `nextPageToken` cursor identically to `search_issues`, including the JRACLOUD-95368 repeated-cursor anti-loop guard (same stderr warning text). Returns `KeySearchResult { keys: Vec<String>, has_more: bool }`; `has_more = true` under TWO conditions: (a) the caller's limit was hit while the API still had rows (caller-side truncation), OR (b) the JRACLOUD-95368 repeated-cursor anti-loop guard fired (results may be incomplete; data loss is signaled to callers via this bit). Pure cursor exhaustion (page_has_more = false on a non-truncated path) always returns `has_more = false`. Refinement from PR #362 Copilot R1. Clamps `maxResults` per page to `.min(100)` for parity with `search_issues`. On every page-fetch iteration, after extending `all_keys` and before any break-decision check, `search_issue_keys` deduplicates `all_keys` in-place using order-preserving, first-occurrence-wins deduplication (HashSet retain, keyed on the key string). All exit paths (guard-abort, limit-truncation, cursor-exhaustion) therefore return a duplicate-free `keys` vec. Introduced in #365.
**Trace**: `src/api/jira/issues.rs::search_issue_keys` (impl); `src/cli/issue/edit.rs::handle_edit` (effective_keys caller); `tests/search_issue_keys.rs` (wiremock suite: library tokio + subprocess) + `tests/issue_bulk_pr2.rs::test_handle_edit_jql_truncation_error_still_triggers_after_migration` (caller-level regression)

---

#### BC-2.6.051: `client.search_issues(jql, limit, fields)` deduplicates results in-place on all exit paths (JRACLOUD-95368 mitigation)

**Confidence**: HIGH
**Source**: issue #365 (dedupe follow-up from PR #362); spec at `docs/specs/2026-05-14-search-issue-keys-dedupe.md`; research at `.factory/research/issue-365-design-validation.md`
**Subject**: Issue read (API layer — full-body JQL search)
**Behavior**: On every page-fetch iteration, after extending `all_issues` and before any break-decision check, `search_issues` deduplicates `all_issues` in-place using order-preserving, first-occurrence-wins deduplication keyed on `issue.key` (HashSet<String> of cloned keys, because `Issue` does not impl `Hash`). All exit paths (guard-abort, limit-truncation, cursor-exhaustion) therefore return a duplicate-free `issues` vec. `SearchResult.has_more` semantics are unchanged. As of issue #365, `has_more = true` on the guard-abort path no longer implies that `issues` contains duplicates. Symmetric to BC-2.6.050.
**Trace**: `src/api/jira/issues.rs::search_issues` (impl); `tests/rate_limit_cap_tests.rs` (dedupe regression suite added in #365: `test_search_issues_repeated_cursor_abort_dedupes`, `test_search_issues_dedupes_non_consecutive_across_pages`, `test_search_issues_limit_truncation_dedupes_under_drift`, `test_search_issues_apr2025_overshoot_silenced_by_drift_dedupe`)

---

### 2.7 Attachment Read

#### BC-2.7.001: `attachment list <KEY>` table columns — id, filename, mimeType, size (human-readable), created, author

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_list` (implementation pending — SOH-ATTACHMENTS-1 Story 1); `src/api/jira/attachments.rs::list_attachments` (implementation pending)
**Subject**: Issue read
**Output channel profile**: 2 (Read-only) — table data to stdout; filter-count hint to stderr; no stderr output when no filter is active.

`jr issue attachment list <KEY>` fetches `GET /rest/api/3/issue/{key}?fields=attachment` and renders the `fields.attachment[]` array as a comfy-table on stdout. There is no dedicated Jira "list attachments" endpoint; all attachment metadata is returned in a single response via the issue field projection (no cursor pagination for this call — confirmed in research §1a of `.factory/research/issue-576-attachments-api-2026-07-15.md`).

Table columns (in display order):

| Column | Source field | Notes |
|--------|-------------|-------|
| ID | `attachment.id` | Numeric string |
| Filename | `attachment.filename` | Raw as returned by Jira; untrusted for disk write (see BC-2.7.011) |
| Type | `attachment.mimeType` | MIME type string |
| Size | `attachment.size` | Human-readable formatted (e.g., `42.0 KB`, `1.2 MB`); raw bytes in JSON output (BC-2.7.002) |
| Created | `attachment.created` | ISO 8601 string; displayed as-is (no parsing or TZ conversion) |
| Author | `attachment.author.displayName` | Falls back to `attachment.author.accountId` when `displayName` is absent |

When the issue has zero attachments the handler exits 0 with no table and empty stdout; this is not an error.

**Thumbnail omitted**: the `thumbnail` field (pre-signed short-TTL URL) present in some Jira attachment metadata is NOT included in the table. Only the six columns listed above are displayed in this slice.

**EC-2.7.001-1** (zero attachments): `attachment list <KEY>` on a valid issue with no attachments → exit 0, empty stdout, no stderr output.

**EC-2.7.001-3** (null/missing author): when `attachment.author` is absent or null (system-generated or anonymous attachment), the Author column displays `"(anonymous)"` in the table.

**EC-2.7.001-2** (filter-count hint): when any `--filter` flag is active and reduces the displayed row count, a hint is emitted to stderr: `"Showing N of M attachments."` (N = filtered count, M = total from API). When no filter is active this hint is suppressed.

**CLI flags** (pinned for e2e surface guard): `<KEY>` (positional, required); `--filter <FILTER>` (repeatable; key=value form); `--output json`; `--no-input`; `--profile <NAME>`; `--no-color`.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design; research §1a VERIFIED — no dedicated list endpoint)

---

#### BC-2.7.002: `attachment list <KEY> --output json` shape — `[{id, filename, mimeType, size, created, author, contentUrl}]`

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_list` (implementation pending — SOH-ATTACHMENTS-1 Story 1); `src/api/jira/attachments.rs::list_attachments` (implementation pending); `src/output.rs::render_json`
**Subject**: Issue read

`attachment list --output json` routes through `output::render_json` (JSON render invariant #526). The output is a JSON array; each element:

```json
[
  {
    "id": "10042",
    "filename": "screenshot.png",
    "mimeType": "image/png",
    "size": 43008,
    "created": "2026-07-10T14:23:11.000+0000",
    "author": {
      "accountId": "62abc123...",
      "displayName": "Alice Operator"
    },
    "contentUrl": "https://mysite.atlassian.net/rest/api/3/attachment/content/10042"
  }
]
```

Field notes:
- `size` is a raw `u64` integer (bytes), never a human-formatted string (contrast with the table in BC-2.7.001).
- `contentUrl` is the stable authenticated Jira content endpoint (`/rest/api/3/attachment/content/{id}`) — it is an indirection that 303-redirects to a pre-signed media URL at request time; it is NOT itself an expiring signed URL. Surfacing this field satisfies issue #585 (absorbed into SOH-ATTACHMENTS-1 Story 1; close #585 as fixed-by #576 after Story 1 ships). **Research basis**: research §7 VERIFIED — the `content` field is already present in `fields.attachment[]` and is a stable Jira endpoint. **Field name rationale**: `jr` exposes this as `contentUrl` (not the raw Jira API field name `content`) for clarity — `content` alone is ambiguous in a JSON context; `contentUrl` makes the type (URL) self-evident. This is a `jr` display convention documented here.
- `author` mirrors the existing `User` serde shape from `src/types/jira/user.rs`.
- `thumbnail` / `thumbnailUrl` fields that may appear in some Jira attachment objects are **omitted** from both the table output (BC-2.7.001) and this JSON output in this slice. They are not surfaced because thumbnail availability is instance-dependent and the pre-signed thumbnail URL has a short TTL unsuitable for offline use.

Empty issue → `[]` array, exit 0, no error.

**Null author in JSON**: when `attachment.author` is absent or null, the JSON element emits `"author": null` (not an omitted key and not an empty object). This is consistent with the Jira API's own null representation for missing sub-objects.

All `--output json` paths MUST route through `output::render_json` or `output::print_output` — never `serde_json::to_string_pretty` or direct compact printing (JSON render invariant #526).

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; #585 absorbed — research §7 VERIFIED; DEC-179 ratified design)

---

#### BC-2.7.003: `attachment list <KEY> --filter mime=<glob>` client-side mimeType filter

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_list` (implementation pending — SOH-ATTACHMENTS-1 Story 1)
**Subject**: Issue read

`--filter mime=<glob>` applies a client-side filter retaining only rows whose `mimeType` field matches the glob pattern. The full attachment list is fetched from the API before filtering; no server-side filter is applied.

Glob semantics: `*` matches any character sequence (including `/`); `?` matches any single character; matching is case-insensitive. Examples:
- `--filter mime=image/*` → retains `image/png`, `image/jpeg`, `image/gif`, etc.
- `--filter mime=application/pdf` → exact match (glob-interpreted but no wildcards)

After filtering, the table is rendered (BC-2.7.001) with only matching rows. When `--output json` is combined with `--filter mime=`, the JSON array contains only matching elements (BC-2.7.002 shape unchanged). The filter-count hint (EC-2.7.001-2) fires when the filter reduces row count.

**Filter composition with download commands**: `--filter mime=<glob>` (and all `--filter` flags) also applies to `jr issue attachment download --all` and `--newest N`. The filter runs before top-N selection: `--newest 3 --filter mime=image/*` yields the 3 most recently created images (see BC-2.7.008/BC-2.7.009).

**EC-2.7.003-1** (zero matches): empty table or `[]` JSON, exit 0. Hint fires: `"Showing 0 of M attachments."`

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design)

---

#### BC-2.7.004: `attachment list <KEY> --filter name=<glob>` client-side filename filter

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_list` (implementation pending — SOH-ATTACHMENTS-1 Story 1)
**Subject**: Issue read

`--filter name=<glob>` applies a client-side filter retaining only rows whose `filename` field matches the glob pattern. Semantics mirror BC-2.7.003 (glob, case-insensitive, client-side). Examples:
- `--filter name=*.png` → PNG files only
- `--filter name=screenshot*` → files starting with "screenshot"

The filter matches against the raw `filename` as returned by Jira. This BC governs display/filter behavior only; CWE-22 sanitization for disk writes is covered by BC-2.7.011.

Multiple `--filter` flags combine with AND semantics: `--filter mime=image/* --filter name=screenshot*` retains only images whose filename starts with "screenshot".

**Filter composition with download commands**: same as BC-2.7.003 — `--filter name=<glob>` also applies to `--all` and `--newest N` download paths (filter-before-select order).

**EC-2.7.004-1** (zero matches): same as EC-2.7.003-1.

**EC-2.7.004-2** (JRACLOUD-96384 note): when multiple attachments share the same `filename`, all matching rows are returned. Downstream callers performing download or delete operations MUST reference attachments by `id`, not by `filename`, because filename collisions are legal in Jira and filename-based matching is ambiguous (JRACLOUD-96384, confirmed in research §6 of `.factory/research/issue-576-attachments-api-2026-07-15.md`).

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; research §6 JRACLOUD-96384 match-by-id invariant VERIFIED)

---

#### BC-2.7.005: `attachment list <KEY> --filter size-max=<bytes>` client-side size filter

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_list` (implementation pending — SOH-ATTACHMENTS-1 Story 1)
**Subject**: Issue read

`--filter size-max=<bytes>` applies a client-side filter retaining only rows whose `size` (bytes, `u64`) is less than or equal to the given byte limit. The argument is a raw non-negative integer. Examples:
- `--filter size-max=10485760` → files at most 10 MB
- `--filter size-max=0` → zero-byte attachments only (valid edge case)

The `size` field from API metadata is authoritative; no hard-coded instance cap is assumed or enforced here (research §3a INCONCLUSIVE on cloud attachment cap; Rev 2 §R2.5 SQ-5 ruling — no hard-coded cap).

Multiple `--filter` flags combine with AND semantics (see BC-2.7.004).

**Filter composition with download commands**: same as BC-2.7.003 — `--filter size-max=<bytes>` also applies to `--all` and `--newest N` download paths (filter-before-select order).

**EC-2.7.005-1** (parse error): if `<bytes>` is not a valid non-negative integer → exit 64 before any HTTP call; message includes the invalid value and states that `--filter size-max` expects a byte count integer.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; research §3a INCONCLUSIVE ruling — no hard-coded cap)

---

#### BC-2.7.006: `attachment list <KEY>` on unknown or inaccessible KEY → exit 64

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_list` (implementation pending — SOH-ATTACHMENTS-1 Story 1); `src/api/jira/attachments.rs::list_attachments` (implementation pending)
**Subject**: Issue read

When `<KEY>` does not exist or the authenticated user lacks Browse Projects permission, `GET /rest/api/3/issue/{key}?fields=attachment` returns 404. The handler maps this to `JrError::UserError` (exit 64).

**Error paths**:

| Condition | Exit code | stderr |
|-----------|-----------|--------|
| KEY 404 (not found / no access) | 64 | `"Issue <KEY> not found or not accessible."` |
| 401 | 2 | Not authenticated + `jr auth login` hint |
| 5xx | 1 | `API error (<N>)` |
| Network error | 1 | Connectivity hint |
| Disk full (ENOSPC) writing to temp file | 1 | `"Disk full: not enough space to write <path>"` |
| Permission denied on target directory (EACCES / read-only FS) | 1 | `"Permission denied: cannot write to <dir>"` |
| Target directory not writable (other OS write error) | 1 | OS error message surfaced on stderr |

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design; follows BC-2.3.033/034 universal error pattern)

---

#### BC-2.7.007: `attachment download <KEY> --id <AID>` single-file download; `--out <PATH>` path override

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_download` (implementation pending — SOH-ATTACHMENTS-1 Story 2); `src/api/jira/attachments.rs::get_attachment_content` (implementation pending)
**Subject**: Issue read
**Output channel profile**: 3 (Mixed) — no stdout data; progress/completion hints to stderr; errors to stderr.

`jr issue attachment download <KEY> --id <AID>` downloads a single attachment to disk.

**Selector required (clap required-group)**: `jr issue attachment download <KEY>` without any selector (`--id`, `--all`, or `--newest`) is rejected by clap at parse time — the three selector flags form a required mutually-exclusive group. clap exits 2 with a usage hint listing all three options. This is enforced at the CLI layer; no HTTP call is made.

**Wire path**: `GET /rest/api/3/attachment/content/{id}` — the platform content endpoint. This path is uniform for both platform and JSM issues. The servicedeskapi `links.content` URLs MUST NOT be used for download: JSDCLOUD-10841 (confirmed in research §P2-6 of `.factory/research/issue-576-attachments-api-2026-07-15.md`) shows these URLs return 404.

**Redirect following**: Jira Cloud redirects this endpoint (302/303) to a pre-signed CDN URL (`media.atlassian.com` or AWS). The reqwest client MUST rely on its default redirect policy (up to 10 redirects). reqwest 0.13.4 strips `Authorization`, `Cookie`, and `Proxy-Authorization` headers on cross-host redirects — VERIFIED in research §1c and independently corroborated by GHSA-9857-6MW7-FQ2M (which explicitly states the reqwest backend compares `prev_url.host_str()` to `curr_url.host_str()` and strips sensitive headers on cross-domain hops). No custom `RedirectPolicy` is needed. **CRITICAL**: `?redirect=false` MUST NOT be used — JRACLOUD-97046 (research §6) causes encoded or broken responses for some file formats when this query parameter is present.

**Streaming**: response bytes are streamed to disk via `Response::bytes_stream()` + incremental write (e.g., `tokio::io::copy`). The full body is never buffered in memory, guarding against OOM for large attachments. Requires the reqwest `stream` feature in `Cargo.toml` (Rev 2 §R2.1).

**Output path**: the default filename uses the SHA-1-prefix + sanitized-basename scheme from BC-2.7.010. `--out <PATH>` overrides the default with an explicit file path; the user-supplied path is NOT sanitized against CWE-22 (trusted input from the operator).

**Overwrite behavior** (DEC-179 ruling 3): if the computed or specified output path already exists as a regular file, the handler MUST refuse with exit 64: `"File already exists: <path>. Use --force to overwrite."` The `--force` flag bypasses this check and overwrites silently. This prevents accidental data loss for idempotent re-runs.

On success, a completion hint is emitted to stderr: `"Downloaded: <path> (<size_human>)."` Nothing is written to stdout (profile 3).

**Write-to-temp + atomic-rename**: The download MUST write to a temporary file in the same directory as the final path (e.g., `<final_path>.partial` or a random `tmp_<random>_<basename>` name) and only rename it to the final path on successful stream completion. This prevents an interrupted download from leaving a truncated file that would block a retry (the overwrite-refuse guard checks for the FINAL path, not the `.partial` file). On any error (network failure, disk error, process signal), the temporary file MUST be deleted before `jr` exits; the final path is NOT written.

**Ctrl+C / SIGINT during download** (exit 130): if the user interrupts the download mid-stream, the partial file is cleaned up (deleted), the final path is not written, and `jr` exits 130 (standard signal-interrupt exit code). Exit 130 is consistent with `JrError::Interrupted` (maps to exit code 130 in `src/error.rs`).

**EC-2.7.007-6** (`--out <PATH>` with missing parent directory): if the user-specified `--out <PATH>` names a file in a parent directory that does not exist, `jr` exits 64 before any download: `"Output directory does not exist: <parent>"`. The handler does NOT create parent directories automatically.

**EC-2.7.007-1** (AID does not exist): `GET /rest/api/3/attachment/content/{id}` returns 404 → exit 64: `"Attachment <AID> not found."` (see BC-2.7.012 for full error taxonomy).

**EC-2.7.007-2** (JSM issue uniform behavior): downloading an attachment from a JSM issue uses the exact same platform content endpoint as a non-JSM issue. There is no JSM-specific code path for download. JSDCLOUD-10841 confirms the servicedeskapi links are unreliable; the platform endpoint is the correct single code path.

**EC-2.7.007-3** (credential-stripping regression guard — SEC-576-003 CWE-522): A wiremock integration test MUST assert that `GET /rest/api/3/attachment/content/{id}` following a cross-host 302/303 redirect does NOT include an `Authorization` header on the redirect-target request. Use a two-server wiremock setup (one for the Jira API endpoint, one for the simulated CDN redirect target). This guards against a future `JiraClient` refactor adding a custom `RedirectPolicy` that silently forwards bearer/Basic credentials to CDN hosts.

**EC-2.7.007-4** (error mid-stream): temporary file deleted; exit 1; `"Download failed: <reason>"` on stderr; final path not written.
**EC-2.7.007-5** (Ctrl+C / SIGINT mid-stream): temporary file deleted; exit 130; no final path written.

**CLI flags** (pinned for e2e surface guard): `<KEY>` (positional, required); `--id <AID>` (single download); `--all` (batch); `--newest <N>` (top-N); `--out <PATH>` (single-file path override); `--out-dir <DIR>` (batch target directory); `--force` (overwrite existing); `--filter <FILTER>` (repeatable); `--output json`; `--no-input`.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design; research §1b–1d VERIFIED; JSDCLOUD-10841 §P2-6 VERIFIED — platform endpoint for JSM; JRACLOUD-97046 §6 no-redirect-false; GHSA-9857-6MW7-FQ2M corroboration); SEC-576-003 (CWE-522 credential-stripping wiremock test requirement added 2026-07-15)

---

#### BC-2.7.008: `attachment download <KEY> --all` batch download to `--out-dir <DIR>`; default dir is cwd

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_download` (implementation pending — SOH-ATTACHMENTS-1 Story 2)
**Subject**: Issue read

`jr issue attachment download <KEY> --all` downloads all attachments on the issue to a directory. Default target is the current working directory; `--out-dir <DIR>` overrides. The handler first fetches the full attachment list (same `GET /rest/api/3/issue/{key}?fields=attachment` call as `attachment list`), then downloads each attachment sequentially using the BC-2.7.007 wire path. Each file is named using BC-2.7.010 (SHA-1-prefix + sanitized-basename) within the target directory.

**Overwrite behavior with `--all`**: without `--force`, per-file collision is handled fail-soft — the colliding file is skipped with a per-file stderr warning (e.g., `"Skipping <filename>: file already exists. Use --force to overwrite."`). The download continues for remaining attachments. With `--force`, existing files are overwritten silently.

On completion a summary hint emits to stderr: `"Downloaded N of M attachments to <dir>."` (N = successful, M = total).

**EC-2.7.008-1** (empty attachment list): issue has no attachments → exit 0; stderr: `"No attachments found on <KEY>."`

**EC-2.7.008-2** (directory does not exist): if `--out-dir <DIR>` is specified and the directory does not exist → exit 64 before any download: `"Output directory does not exist: <DIR>"`. The handler does NOT create the directory automatically.

**EC-2.7.008-3** (`--id` and `--all` mutual exclusion): clap enforces `conflicts_with` → exit 2 when both are supplied simultaneously.
**EC-2.7.008-4** (`--out-dir` path exists but is not a directory): exit 64: `"Not a directory: <PATH>"`. A regular file at the specified path is rejected; the handler requires a directory.
**EC-2.7.008-5** (`--out-dir` path does not exist): supersedes EC-2.7.008-2 wording clarification — same exit 64: `"Output directory does not exist: <DIR>"`.



**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design)

---

#### BC-2.7.009: `attachment download <KEY> --newest N` — select most-recent N attachments by `created` date, then download

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_download` (implementation pending — SOH-ATTACHMENTS-1 Story 2)
**Subject**: Issue read

`jr issue attachment download <KEY> --newest N` downloads at most N attachments, selecting the N most recently created (by `attachment.created` descending). Because Jira's ISO 8601 timestamp format (`2026-07-10T14:23:11.000+0000`) is lexicographically sortable descending, lexicographic sort is correct for this field.

**Behavior**: fetch full attachment list → apply any `--filter` flags (mime/name/size-max) → sort by `created` descending → take first N → download each using BC-2.7.007 wire path and BC-2.7.010 output naming.

`--filter` applies BEFORE the top-N selection: `--newest 3 --filter mime=image/*` = the 3 most recently added images.

If the issue has fewer than N attachments after filtering, all available attachments are downloaded (not an error; N > available count is handled gracefully).

`--newest N` is mutually exclusive with `--id` (clap `conflicts_with` → exit 2). `--newest N` combined with `--all` is rejected (clap `conflicts_with` → exit 2). Overwrite and `--force` behavior follow BC-2.7.007/BC-2.7.008.

**EC-2.7.009-1** (invalid N): N at or below 0, or non-integer → exit 64 before any HTTP call: `"--newest requires a positive integer."` N = 0 is rejected (zero-download is ambiguous, not silently accepted).

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design)

---

#### BC-2.7.010: Default download output path — `<sha1-of-id>_<sanitized-basename>` in target directory

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_download` (implementation pending — SOH-ATTACHMENTS-1 Story 2)
**Subject**: Issue read

When no `--out <PATH>` is specified, the default output filename for a downloaded attachment is:

```
<sha1-of-id>_<sanitized-basename>
```

- `<sha1-of-id>`: the full 40-character lowercase hex-encoded SHA-1 of the attachment `id` string (NOT a content hash — the attachment ID is stable, yielding deterministic naming without reading file content first).
- `<sanitized-basename>`: the result of `sanitize_attachment_filename(attachment.filename)` per BC-2.7.011. If sanitization returns `None`, the attachment is skipped with a warning (BC-2.7.011 caller contract).

**Rationale for SHA-1 prefix**: idempotency (re-running `attachment download` on the same attachment ID always produces the same filename) and collision-resistance between two attachments sharing the same sanitized basename. The prefix is NOT a file-integrity hash.

**Combined-name length cap**: the full default filename `<sha1(40)>_<basename>` is at most 255 bytes total. The SHA-1 hex string is exactly 40 bytes plus the `_` separator = 41 bytes; BC-2.7.011 step 5 caps the sanitized basename at 214 bytes (214 + 41 = 255). This keeps the combined filename within the POSIX `NAME_MAX` and Windows NTFS per-component limit. Call sites that bypass BC-2.7.010 naming (e.g., `--out <PATH>`) receive sanitized names that are still at most 214 bytes from BC-2.7.011 — always within the limit.

**Examples**:
- `id="10042"`, `filename="report.pdf"` → `<sha1("10042")>_report.pdf`
- `id="10042"`, `filename="../../../etc/passwd"` → sanitized basename is `passwd` → `<sha1("10042")>_passwd`

When `--out <PATH>` is supplied on the single-file path (BC-2.7.007), SHA-1-prefix naming is bypassed entirely and the explicit path is used. The user-supplied path is NOT sanitized (trusted operator input).

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design; #576 SHA-1-prefix proposal incorporated)

---

#### BC-2.7.011: Filename sanitization (CWE-22 path traversal mitigation) — `sanitize_attachment_filename(name: &str) -> Option<String>`

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::sanitize_attachment_filename` (implementation pending — SOH-ATTACHMENTS-1 Story 2)
**Subject**: Issue read (security invariant — applies to all attachment download paths)

The `filename` field in Jira attachment metadata is **attacker-controllable**: any user who can attach to an issue controls this value, and JSM portals accept customer uploads. When this field is used to construct a local path, it MUST be sanitized before use.

**Required algorithm** (`sanitize_attachment_filename(name: &str) -> Option<String>`):

1. **Basename extraction**: apply `Path::new(name).file_name()` — strips any directory component (`../../etc/passwd` becomes `passwd`; `/etc/passwd` becomes `passwd`; `C:\Windows\system32\calc.exe` becomes `calc.exe`). If `file_name()` returns `None` (path ends in `..` or reduces to empty), return `None` (reject).
2. **Pseudo-name rejection**: if the extracted basename as a `Path` component equals `"."` or `".."`, return `None`. Empty string after OsStr conversion also returns `None`.
3. **NUL byte rejection**: if the name contains a NUL byte (`\0`), return `None`. NUL terminates strings in OS path APIs and is never a valid filename character on any supported platform.
4. **Character scrub** (defensive-depth): replace any remaining `/`, `\`, or `:` in the string with `_`. These are path separators on various platforms and MUST NOT appear in a filename component even after step 1 (guards against encoding edge cases on Windows UNC and drive-letter paths).
5. **Length cap** (UTF-8-safe truncation for the sanitized basename): truncate to at most **214 bytes** on a valid UTF-8 character boundary (Rust `floor_char_boundary` semantics — never split a multi-byte codepoint). Rationale for 214 bytes: the default output path in BC-2.7.010 prepends a 41-byte SHA-1 prefix (`<40 hex chars>_`); 214 + 41 = 255, which fits within the POSIX/Windows NTFS filename component limit. If the `--out <PATH>` override is used (no SHA-1 prefix), the sanitized name is still capped at 214 bytes (conservative; avoids a second cap calculation per call site).
5.5. **Trailing whitespace/dot strip** (SEC-576-007 — Windows predictability): strip trailing ASCII whitespace characters and trailing `.` from the basename after the length cap. Windows silently removes trailing dots and spaces from filename components on write; stripping them makes the sanitized output identical on Windows and POSIX, preventing unpredictable collision between two Jira attachments whose names differ only by trailing characters.

Return `Some(sanitized_name)` if all steps produce a non-empty string; otherwise `None`.

**Caller contract**: if `sanitize_attachment_filename` returns `None`, the caller MUST skip that attachment and emit a per-file stderr warning: `"warning: skipping attachment <AID> — filename '<raw>' could not be sanitized safely."` The overall download operation continues for remaining attachments (fail-soft per-file).

**Windows device-name caller note (SEC-576-001 — CWE-22)**: The sanitized name returned by `sanitize_attachment_filename` may match a Windows reserved device base-name (`CON`, `NUL`, `PRN`, `AUX`, `COM1`–`COM9`, `LPT1`–`LPT9`). Any call site that writes the result to disk MUST ensure the final on-disk filename contains at least one non-device-name character before the extension dot. The SHA-1 prefix applied in BC-2.7.010 (`<sha1>_CON`, `<sha1>_NUL`, etc.) satisfies this requirement — `<sha1>_CON` is NOT a Windows reserved name. Call sites that bypass BC-2.7.010 naming (e.g., `--out <PATH>`) use trusted operator-supplied paths and are not subject to this note.

**Defense-in-depth containment check (SEC-576-002 — CWE-22, corrected procedure)**: after joining the sanitized name with the target directory, the implementer MUST use the following two-step procedure. Do NOT call `canonicalize()` on the joined path — `std::fs::canonicalize` returns `Err` for non-existent paths, which would cause every new download to be treated as a containment failure:

1. `let resolved_dir = out_dir.canonicalize()?` — canonicalize `out_dir` (which is guaranteed to exist; BC-2.7.008 EC-2.7.008-2 enforces this pre-condition before any download begins).
2. Assert `resolved_dir.join(&sha1_filename).starts_with(&resolved_dir)` — `Path::starts_with` is component-based (not a string-prefix check), so it correctly evaluates containment for a file that does not yet exist on disk.

Since step 4 of sanitization already strips `../`, `/`, `\`, `:`, the join will in practice always satisfy the `starts_with` assertion. The check is defense-in-depth against any encoding edge case not caught by steps 1–4. If `starts_with` returns `false`, skip with a warning: `"warning: skipping attachment <AID> — path escape detected after sanitization."` This skip-case is a defensive guard only; it should not occur for any name produced by the five-step algorithm above.

**Coverage/mutation exemption note**: The `starts_with` false branch is intentionally unreachable via any current Jira API-supplied filename after steps 1–5. This branch exists as defense-in-depth against future encoding edge cases or platform differences not covered by the step 1–5 guarantee. A mutation testing or line-coverage exemption for this specific branch is acceptable; annotate the branch with a comment referencing this BC (e.g., `// BC-2.7.011 defense-in-depth: unreachable via API-supplied filenames after sanitization steps 1-5`).

**Naive blacklist approaches are INSUFFICIENT**: do NOT rely on string-stripping `../` patterns alone — such blacklists are bypassable. The algorithm above is the required standard mitigation (research §4 of `.factory/research/issue-576-attachments-api-2026-07-15.md`, VERIFIED HIGH; OWASP/PortSwigger/CWE-31/22 first-principles).

**Unit test coverage required**: at minimum: `../../etc/passwd`, `/etc/passwd`, `C:\Windows\system32\foo.exe`, `"."`, `".."`, empty string, NUL-containing string, a normal filename, a filename exceeding 255 bytes, a filename containing `:` (Windows drive path), `"CON"` (Windows device name → `Some("CON")`), `"NUL"` (Windows device name → `Some("NUL")`), `"COM1"` (Windows device name → `Some("COM1")`), and `"nul.txt"` (Windows device name with extension → `Some("nul.txt")`), and a filename containing a multi-byte UTF-8 codepoint at the truncation boundary (e.g., a 214-byte ASCII prefix followed by a 3-byte UTF-8 char `"é"` — the char must be dropped, not split, so the output is the 214-byte prefix without truncation artifact). The test matrix confirms that `sanitize_attachment_filename` returns `Some(name)` for device names — the BC-2.7.010 SHA-1 prefix (not this function) is what prevents on-disk device-name collisions on Windows (SEC-576-001 caller note above).

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; research §4 CWE-22 VERIFIED HIGH; DEC-179 SQ-1 resolved; OWASP/CWE-22/CWE-31 first-principles); SEC-576-001 (CWE-22 Windows device-name caller note + unit test matrix added 2026-07-15); SEC-576-002 (CWE-22 corrected two-step containment check procedure added 2026-07-15); SEC-576-007 (trailing-whitespace/dot strip step 5.5 added 2026-07-15)

---

#### BC-2.7.012: `attachment download` on unknown KEY or unknown AID → exit 64 with informative error

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_download` (implementation pending — SOH-ATTACHMENTS-1 Story 2); `src/api/jira/attachments.rs::get_attachment_content` (implementation pending)
**Subject**: Issue read

**Unknown issue key**: when `<KEY>` does not exist or is inaccessible, `GET /rest/api/3/issue/{key}?fields=attachment` returns 404. Handler exits 64: `"Issue <KEY> not found or not accessible."`

**Unknown attachment ID**: when `--id <AID>` references a non-existent attachment, `GET /rest/api/3/attachment/content/{id}` returns 404. Handler exits 64: `"Attachment <AID> not found."`

**Match-by-ID invariant** (JRACLOUD-96384 + JRACLOUD-78388, both confirmed in research §6): attachment operations MUST identify attachments by their numeric `id`, not by `filename`. Multiple attachments with the same `filename` on one issue are legal in Jira (JRACLOUD-96384); filename-based matching is ambiguous and unreliable. There is also no reliable REST mapping from a comment to the attachments it contains (JRACLOUD-78388). `--id <AID>` is the sole selector for single-file download operations.

**Error path taxonomy**:

| Condition | Exit code | stderr |
|-----------|-----------|--------|
| KEY 404 | 64 | `"Issue <KEY> not found or not accessible."` |
| AID 404 from content endpoint | 64 | `"Attachment <AID> not found."` |
| KEY or AID 401 | 2 | Not authenticated + `jr auth login` hint |
| KEY or AID 5xx | 1 | `API error (<N>)` |
| Network error | 1 | Connectivity hint |

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design; research §6 JRACLOUD-96384/-78388 VERIFIED)

---

## Error Path Summary

All issue-read errors follow the universal pattern (BC-X.3.012):
- Network drop → exit 1 + `"Could not reach <host>; check your connection"`
- 401 → exit 2 + `Not authenticated` + `jr auth login`
- 5xx → exit 1 + `API error (5xx)` + friendly message
- Never: `panic` in stderr

Pass 3 sources: `tests/issue_list_errors.rs`, `tests/issue_view_errors.rs`, `tests/comments.rs`

## Total BCs in this file: 64 individually-bodied (cumulative 106 incl. range-collapsed; see BC-INDEX.md)