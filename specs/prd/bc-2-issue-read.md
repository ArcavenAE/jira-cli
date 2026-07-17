---
context: bc-2
title: "Issue Read (list/view/comments/changelog)"
total_bcs: 106   # cumulative claim (incl. range-collapsed); definitional_count below is individually-bodied headings
definitional_count: 64   # count of `#### BC-` headings in this file
last_updated: 2026-07-17
source_pass: 3
trace: |
  - L2: .factory/specs/domain-spec/bc-02-issue-read.md
  - Source broad: .factory/semport/jira-cli/jira-cli-pass-3-behavioral-contracts.md §2.2
  - Source R1: .factory/semport/jira-cli/jira-cli-pass-3-deep-r1.md §3.2
  - Source R4: .factory/semport/jira-cli/jira-cli-pass-3-deep-r4.md §3.1
  - SOH-ATTACHMENTS-1 F2 addition (2026-07-15): BC-2.7.001..012 — Attachment Read: attachment list (table+JSON, filters mime/name/size-max), attachment download (single/batch/newest, streaming, redirect-following, CWE-22 sanitization, SHA-1 default path, JSDCLOUD-10841 JSM uniform), error taxonomy (DEC-179, issues #576 #585)
  - SOH-ATTACHMENTS-1 adversary pass-19 (2026-07-16): BC-2.7.002 BTreeMap-alphabetical key order clause + example reorder (P19-001); EC-2.7.001-2 JSON-mode filter-count hint clause (P19-002); EC-2.7.007-5 best-effort MUST + tokio ctrl_c implementation note (P19-003); spec v1.3.59
  - SOH-ATTACHMENTS-1 adversary pass-20 (2026-07-16): BC-2.7.007 `--out` unconditional step-1 clause added — step 1 always issued even with `--out`; pre-stream existence validation; one extra GET accepted cost (P20-003); VP-576-004 attachment-object JSON transformation pin added to BC-2.7.002 — `"self"` OMITTED, `"content"` RENAMED to `"contentUrl"` (P20-006); spec v1.3.60
  - SOH-ATTACHMENTS-1 adversary pass-21 (2026-07-16): BC-2.7.012 KEY-404 batch-paths-only annotation — `--id` does not server-verify KEY per BC-2.7.007 (P21-006); spec v1.3.61
  - SOH-ATTACHMENTS-1 adversary pass-22 (2026-07-16): BC-2.7.012 body prose "Unknown issue key" sentence prepended with batch-only caveat; BC-2.7.012 Trace field updated with P22-003 citation (P22-003); spec v1.3.62
  - v1.3.64 — P24 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): VP-576-004 story-allocation annotation added (P24-002): list half verified at S1 (BC-2.7.002 home); upload-platform-POST half verified at S3 (BC-3.9.009); full cross-path test lands at S3 — S3 depends_on S1 for shared curated-serialization plumbing (R3.13 earliest-consumer principle); NOT part of S1 acceptance matrix as a whole; S1 matrix includes only the list half. (Note: v1.3.63 entry is NOT owed — P23 did not touch bc-2-issue-read.md.)
  - v1.3.65 — P25 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): EC-2.7.008-6 extended — JSON-mode hint-vs-error policy added (per-file failure warnings ARE emitted in JSON mode as ERRORS; `Downloaded N of M` summary NOT emitted in JSON mode as it is a HINT) (P25-001); EC-2.7.008-7 mode-scoped — summary scoped to human mode only (P25-001); Per-file download error policy point (3) updated — summary clause scoped to human mode (P25-001); BC-2.7.008 Trace updated; BC-2.7.011 containment step-1 case (c) reworded — pure does-not-apply exclusion for `--out <PATH>` (trusted operator input; neither step-1 canonicalize nor step-2 starts_with applies) (P25-002).
  - v1.3.66 — P26 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): BC-2.7.012 KEY-403 batch-paths-only row added to error table (P26-001); BC-2.7.007 step 1 partial-struct absent-tolerance clause added (P26-003); BC-2.7.007 and BC-2.7.012 Trace fields updated.
  - v1.3.67 — P27 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): EC-2.7.007-7 `filename` semantics clause added — `downloaded[].filename` is RAW Jira name (pre-sanitization); on-disk basename recoverable from `path`; deliberate pairing documented (P27-001); EC-2.7.008-6 same `filename` semantics clause added; collision-skip warnings classified as NON-ERROR hints, suppressed in JSON mode (P27-003); BC-2.7.007 and BC-2.7.008 Trace fields updated.
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
**Source**: `tests/issue_commands.rs:~7-31, 130-166`
**Subject**: Issue read
**Behavior**: `client.search_issues(jql, limit, fields)` posts to `/rest/api/3/search/jql`; returns `{issues: Vec<Issue>, has_more: bool}`. Pagination via `nextPageToken` cursor.
**Trace**: Pass 3 BC-101

---

#### BC-2.1.002: `--jql X` wraps in parens, strips ORDER BY, re-appends `ORDER BY updated DESC`

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~36-52`; `tests/all_flag_behavior.rs:~54-66`; unit tests covering `build_jql_base_parts` variants
**Subject**: Issue read
**Behavior**: `build_jql_base_parts(jql, project_key)` calls `jql::strip_order_by(jql)`, wraps in parens. Order-by slot is ALWAYS `"updated DESC"` — user's `ORDER BY rank ASC` is silently replaced. `--jql "priority = Highest ORDER BY created DESC" --project PROJ` → `(project = "PROJ") AND (priority = Highest) ORDER BY updated DESC`.
**Edge cases**: user ORDER BY is stripped, never preserved.
**Trace**: Pass 3 BC-102, BC-125 (R1)

---

#### BC-2.1.003: Scrum board with active sprint → JQL `sprint = <id> ORDER BY rank ASC`

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~278-282`; `tests/all_flag_behavior.rs:~347-352`
**Subject**: Issue read
**Behavior**: When no `--jql` AND board_id+scrum+active-sprint: `sprint = {sprint.id}` + order by `rank ASC`. Sprint ID from `client.list_sprints(bid, Some("active"))`.
**Trace**: Pass 3 BC-126 (R1)

---

#### BC-2.1.004: Kanban board → `project = "X" AND statusCategory != Done ORDER BY rank ASC`

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~302-310`; `tests/all_flag_behavior.rs:~497-516, 542-562`
**Subject**: Issue read
**Behavior**: Body-match pins literal composed JQL. The `statusCategory != Done` is server-side (not `--open` flag).
**Trace**: Pass 3 BC-127 (R1)

---

#### BC-2.1.005: No board_id → `project = "X" ORDER BY updated DESC`

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~331-338`; `tests/all_flag_behavior.rs:~42-86`
**Trace**: Pass 3 BC-128 (R1)

---

#### BC-2.1.006: No project AND no filters AND no `--jql` → exit 64 listing all 13 filter sources

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~344-351`
**Subject**: Issue read
**Behavior**: stderr contains literal `"No project or filters specified. Use --project, --assignee, --reporter, --status, --open, --team, --recent, --created-after, --created-before, --updated-after, --updated-before, --asset, or --jql. You can also set a default project in .jr.toml or run \"jr init\"."`.
**Error taxonomy**: `JrError::UserError` (exit 64).
**Trace**: Pass 3 BC-129 (R1)

---

#### BC-2.1.007: `build_filter_clauses` emits in stable order: assignee, reporter, status, open, team, recent, asset, created-after/before, updated-after/before

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~613-649`; unit tests covering `build_jql_parts_*` clause variants
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
**Source**: `src/cli/issue/list.rs:~90-92`; `src/jql.rs:~16-34`
**Subject**: Issue read
**Behavior**: `validate_duration("4w2d")` → Err. `--recent 4w2d` → `JrError::UserError("Invalid duration '4w2d'. Use a number followed by y, M, w, d, h, or m (e.g., 7d, 4w, 2M).")`. Pre-HTTP validation.
**Trace**: Pass 3 BC-131 (R1)

---

#### BC-2.1.009: `--created-after/before` and `--updated-after/before` validated via `jql::validate_date` BEFORE any HTTP

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~95-114`
**Subject**: Issue read
**Behavior**: Format: `YYYY-MM-DD`. On invalid: `Invalid date "<X>". Expected format: YYYY-MM-DD (e.g., 2026-03-18).` All four validators run before HTTP.
**Trace**: Pass 3 BC-132 (R1)

---

#### BC-2.1.010: `--created-before` and `--updated-before` use `date + Days::new(1)` for end-day-inclusive semantics

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~118-126`
**Subject**: Issue read
**Behavior**: User passes `--created-before 2026-03-31`; emitted clause is `created < "2026-04-01"`. Pinned by unit test `build_jql_parts_created_date_range`.
**Trace**: Pass 3 BC-133 (R1)

---

#### BC-2.1.011: `--asset KEY` resolves via CMDB fields; if NO CMDB fields → exit 64 with JSM plan message

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~168-183`
**Subject**: Issue read
**Behavior**: On `cmdb_fields.is_empty()`: `JrError::UserError("--asset requires Assets custom fields on this Jira instance. Assets requires a paid Jira Service Management plan.")`.
**Trace**: Pass 3 BC-134 (R1)

---

#### BC-2.1.012: `--asset KEY` ambiguous AQL result → exit 64 `Multiple assets match`; NO issue search fired

**Confidence**: HIGH
**Source**: `tests/assets.rs:~1480-1573`; `src/cli/issue/list.rs:~128-133`
**Subject**: Issue read
**Behavior**: Test asserts `stderr.contains("Multiple assets match")` + both candidate labels + `expect(0)` on `/rest/api/3/search/jql`. Exit 64.
**Trace**: Pass 3 BC-135 (R1)

---

#### BC-2.1.013: `--status <single-substring>` → exit 64 `Ambiguous status`; NO JQL search fired

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs:~368-422`; `src/cli/issue/list.rs:~222-247`
**Subject**: Issue read
**Behavior**: `Mock::expect(0)` on `POST /rest/api/3/search/jql`. stderr `Ambiguous status "prog". Matches: In Progress`. Exit 64.
**Trace**: Pass 3 BC-105, BC-136 (R1)

---

#### BC-2.1.014: `--status NOMATCH` → `JrError::UserError` listing available statuses alphabetically

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~234-246`
**Subject**: Issue read
**Behavior**: `MatchResult::None(all)` constructs full error: `"No status matching \"X\" for project Y. Available: <comma-joined alphabetical list>"`. List always sorted.
**Trace**: Pass 3 BC-138 (R1)

---

#### BC-2.1.015: `--status <ExactMultiple>` treated as Exact (case-variant duplicates)

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~223-226`
**Trace**: Pass 3 BC-137 (R1)

---

#### BC-2.1.016: `--assets` column auto-enabled when `--asset KEY` filter is set

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~86-87`
**Subject**: Issue read
**Behavior**: `let show_assets = show_assets || asset_key.is_some();`
**Trace**: Pass 3 BC-145 (R1)

---

#### BC-2.1.017: `--assets` with no CMDB fields → stderr warning, no asset column

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~357-371`
**Behavior**: stderr: `"warning: --assets ignored. No Assets custom fields found on this Jira instance."`.
**Trace**: Pass 3 BC-146 (R1)

---

### 2.2 Issue List Behavior

#### BC-2.2.018: `--all` passes `maxResults=50`; default passes `maxResults=30`

**Confidence**: HIGH
**Source**: `tests/all_flag_behavior.rs:~42-145`
**Subject**: Issue read
**Behavior**: `maxResults=50` for `--all`; `maxResults=30` for default. Pinned by request body match. `src/api/jira/issues.rs:~50`: `max_per_page = limit.unwrap_or(50).min(100)`.
**Trace**: Pass 3 BC-103, BC-141 (R1)

---

#### BC-2.2.019: Truncation triggers second HTTP `POST /rest/api/3/search/approximate-count`

**Confidence**: HIGH
**Source**: `tests/all_flag_behavior.rs:~88-145`; body-match pins `"jql": "(project = CAP)"`
**Subject**: Issue read
**Behavior**: When `--all` NOT set AND results > limit: issues `POST /search/approximate-count` with ORDER BY-stripped JQL. Stderr: `Showing 30 of ~42`. With `--all`: no truncation hint AND no count call.
**Trace**: Pass 3 BC-104, BC-140 (R1)

---

#### BC-2.2.020: `--all` + `--limit N` clap conflict: `cannot be used with`

**Confidence**: HIGH
**Source**: `tests/cli_smoke.rs:~300-307`
**Trace**: Pass 3 BC-142 (R1)

---

#### BC-2.2.021: `--points` with no story_points_field_id → silently ignored, stderr warning

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~756-770`
**Subject**: Issue read
**Behavior**: stderr: `"warning: --points ignored. Story points field not configured. Run "jr init" or set story_points_field_id under [profiles.<name>] in ~/.config/jr/config.toml"`. Non-fatal; list proceeds without points column. Note: message must reference `[profiles.<name>]` not the deprecated `[fields]` section.
**Related**: BC-6.3.001 (multi-profile fields MUST-FIX); the error message text updated here is one of the pinned-text changes required by that fix.
**Trace**: Pass 3 BC-143 (R1)

---

#### BC-2.2.022: `--points` with configured field → pushes `customfield_NNNNN` onto request `extra` fields list

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~147-149, 656-668`
**Trace**: Pass 3 BC-144 (R1)

---

#### BC-2.2.023: Asset enrichment deduplicates by `(workspace_id, object_id)` before per-asset GETs

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~397-411`
**Subject**: Issue read
**Behavior**: `to_enrich: HashMap<(String, String), ()>` collects unique workspace/object pairs. Per-asset GETs issued once per unique key via `join_all` (concurrent). Mitigates partial N+1.
**Trace**: Pass 3 BC-147 (R1)

---

#### BC-2.2.024: board_id 404 → exit 64 with `Board 42 not found or not accessible` + board_id hint + `--jql` hint

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs:~21-76`
**Error taxonomy**: `JrError::UserError`.
**Trace**: Pass 3 BC-106

---

#### BC-2.2.025: board config 5xx → exit 1 with `Failed to fetch config for board 42` + `--jql` hint

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs:~78-130`
**Trace**: Pass 3 BC-107

---

#### BC-2.2.026: Sprint list 5xx → exit 1 with `Failed to list sprints for board 42` + `--jql` hint

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs:~132-194`
**Trace**: Pass 3 BC-108

---

#### BC-2.2.027: No active sprint → falls back to project-scoped JQL without error

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs:~196-263`
**Subject**: Issue read
**Behavior**: Empty `state=active` sprint list → falls back to `project = PROJ` JQL. No error, no warning (silent degrade per state machine §2.5 of Pass 8 synthesis).
**Trace**: Pass 3 BC-109

---

#### BC-2.2.028: `search_issues` default fields list: 16 fields in EXACT order

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~967-1022`
**Subject**: Issue read
**Behavior**: `summary, status, issuetype, priority, assignee, reporter, project, description, created, updated, resolution, components, fixVersions, labels, parent, issuelinks`. Body partial-JSON match asserts EXACT array.
**Trace**: Pass 3 BC-1063 (R4)

---

#### BC-2.2.029: `search_issues` with cursor continuation token sets `has_more = true`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~264-310`
**Trace**: Pass 3 BC-1047, BC-1048 (R4)

---

#### BC-2.2.030: `search_issues` JQL body includes literal composed string with double-quoted project key

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~492-524`
**Behavior**: `project = "PROJ" AND (priority = Highest) ORDER BY updated DESC` pinned by body partial-match.
**Trace**: Pass 3 BC-1052 (R4)

---

#### BC-2.2.031: `client.approximate_count(jql)` POSTs to `/rest/api/3/search/approximate-count`; 5xx propagates as Err

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~337-386`
**Behavior**: Returns `u64`. Zero and 42 boundary cases tested. Server error → Err.
**Trace**: Pass 3 BC-1050 (R4)

---

### 2.3 Issue View

#### BC-2.3.032: `issue view <key>` GETs `/rest/api/3/issue/<key>` with `--output json` returning raw JSON

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~33-53`
**Trace**: Pass 3 BC-112

---

#### BC-2.3.033: `issue view` 5xx → exit 1 + `API error (500)` + no panic

**Confidence**: HIGH
**Source**: `tests/issue_view_errors.rs:~18-56`
**Trace**: Pass 3 BC-113; BC-1135a (R4)

---

#### BC-2.3.034: `issue view` 401 → exit 2 + `Not authenticated` + `jr auth login`

**Confidence**: HIGH
**Source**: `tests/issue_view_errors.rs:~58-100`
**Trace**: Pass 3 BC-114; BC-1135b (R4)

---

#### BC-2.3.035: Corrupt `teams.json` cache is non-fatal; UUID + "name not cached" hint shown inline

**Confidence**: HIGH
**Source**: `tests/issue_view_errors.rs:~142-206`
**Subject**: Issue read
**Behavior**: Truncated `teams.json` (`{"teams": [`) → `read_cache` returns `Ok(None)` (parse-fail = cache miss). Issue view exits 0. Team row shows raw UUID + `(name not cached — run 'jr team list --refresh')`. stderr NOT contain `panic`.
**Trace**: Pass 3 BC-115; BC-1135d (R4); Top-30 BC rank #26

---

#### BC-2.3.036: `get_issue` deserializes: created, updated, reporter, resolution, components, fix_versions (all nullable)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~526-577, 579-607`
**Behavior**: Full fixture: all fields present. Minimal fixture: all return `None` (NOT panic). RFC3339+0000 timestamps, camelCase JSON paths.
**Trace**: Pass 3 BC-1053, BC-1054 (R4)

---

#### BC-2.3.037: `get_issue` with parent + links deserializes `fields.parent.key`, `fields.issuelinks[0].link_type.name`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~208-231`
**Trace**: Pass 3 BC-1044 (R4)

---

#### BC-2.3.038: `IssueFields::story_points("customfield_X")` returns None for non-numeric values

**Confidence**: HIGH
**Source**: `src/types/jira/issue.rs:~83-85`
**Trace**: Pass 3 BC-124

---

### 2.4 Comments

#### BC-2.4.039: `issue comments <key>` paginates at 100/page with `expand=properties`

**Confidence**: HIGH
**Source**: `tests/comments.rs:~9-46, 73-158`
**Subject**: Issue read
**Behavior**: `maxResults=100`. `--limit N` → `maxResults=N`. Paginates via startAt until total reached.
**Trace**: Pass 3 BC-116

---

#### BC-2.4.040: `issue comments` 5xx → exit 1 + `API error (500)`

**Confidence**: HIGH
**Source**: `tests/comments.rs:~163-200`
**Trace**: Pass 3 BC-117

---

#### BC-2.4.041: `issue comments --internal` adds `sd.public.comment` property (JSM-aware)

**Confidence**: MEDIUM
**Source**: `src/api/jira/issues.rs:~181-198`
**Behavior**: `properties: [{key:"sd.public.comment", value:{internal:true}}]` on write. Read shape preserves `EntityProperty[]`. Non-JSM: Jira silently ignores.
**Trace**: Pass 3 BC-118

---

#### BC-2.4.042: `client.list_comments(key, None)` lists ALL comments via offset pagination

**Confidence**: HIGH
**Source**: `tests/comments.rs:~104-158`
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
**Source**: `tests/issue_commands.rs:~130-166`
**Trace**: Pass 3 BC-1041 (R4)

---

#### BC-2.6.048: `client.find_story_points_field_id()` returns fields with name == "Story Points" from `/rest/api/3/field`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~168-186`
**Trace**: Pass 3 BC-1042 (R4)

---

#### BC-2.6.049: `search_users` accepts FOUR distinct response shapes (bare array, paginated, empty, error)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~388-490`
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
**Output channel profile**: 2 (Read-only) — table data to stdout; filter-count hint to stderr; no filter-count hint on stderr when no filter is active.

`jr issue attachment list <KEY>` fetches `GET /rest/api/3/issue/{key}?fields=attachment` and renders the `fields.attachment[]` array as a comfy-table on stdout. There is no dedicated Jira "list attachments" endpoint; all attachment metadata is returned in a single response via the issue field projection (no cursor pagination for this call — confirmed in research §1a of `.factory/research/issue-576-attachments-api-2026-07-15.md`).

**ASSUMPTION — completeness of `fields.attachment`**: `fields.attachment` is returned COMPLETE (not paginated) in this single response. The current Jira Cloud REST API v3 schema does not paginate the attachment field. **S1 delivery obligation**: the S1 implementer MUST live-verify against an issue with more than 100 attachments, OR document the maximum attachment count per issue if explicitly bounded by Atlassian documentation, before S1 delivery. The correctness of `--all`, `--newest N`, and `--older-than` (BC-3.9.019) depends entirely on this completeness assumption — a partial list would silently miss attachments. BC-3.9.019 cites this clause.

Table columns (in display order):

| Column | Source field | Notes |
|--------|-------------|-------|
| ID | `attachment.id` | Numeric string |
| Filename | `attachment.filename` | Raw as returned by Jira; untrusted for disk write (see BC-2.7.011) |
| Type | `attachment.mimeType` | MIME type string |
| Size | `attachment.size` | Human-readable formatted (e.g., `42.0 KB`, `1.2 MB`); raw bytes in JSON output (BC-2.7.002) |
| Created | `attachment.created` | ISO 8601 string; displayed as-is (no parsing or TZ conversion) |
| Author | `attachment.author.displayName` | Falls back to `attachment.author.accountId` when `displayName` is absent or null; falls back to `"(anonymous)"` when both are absent or null (full chain: displayName → accountId → "(anonymous)") |

When the issue has zero attachments, the handler exits 0 with no table, empty stdout (pipe-friendly), and emits `"No attachments on <KEY>."` to stderr (profile 2 hint — same canonical string as EC-2.7.001-1 and EC-2.7.008-1); this is not an error.

**Thumbnail omitted**: the `thumbnail` field (pre-signed short-TTL URL) present in some Jira attachment metadata is NOT included in the table. Only the six columns listed above are displayed in this slice.

**EC-2.7.001-1** (zero attachments): `attachment list <KEY>` on a valid issue with no attachments → exit 0, empty stdout (pipe-friendly; no table, no message on stdout); stderr: `"No attachments on <KEY>."` (profile 2 hint — human mode; JSON mode: empty stdout `[]` per BC-2.7.002, no stderr, exit 0).

**EC-2.7.001-2** (filter-count hint): when any `--filter` flag is active and reduces the displayed row count, a hint is emitted to stderr: `"Showing N of M attachments."` (N = filtered count, M = total from API). When no filter is active this hint is suppressed. **JSON mode**: the hint fires in `--output json` mode as well — emitted to stderr via `eprintln!` unconditionally after the JSON array is written to stdout. This mirrors the empirical house behavior in `src/cli/issue/list.rs::handle_list` (the `eprintln!` at ~line 580 fires after `output::print_output` regardless of `output_format`) and `src/cli/board.rs::handle_view` (~line 283). **Deliberate asymmetry with EC-2.7.001-1**: the zero-attachment hint from EC-2.7.001-1 IS suppressed in JSON mode (the empty `[]` array is self-describing and unambiguous); the filter-count hint here is NOT suppressed because a filtered JSON array gives no indication of the total — without the hint, a script would see a smaller array than expected with no context. (P19-002)

**EC-2.7.001-3** (null/missing author or exhausted fallback chain): the Author column displays `"(anonymous)"` when: (a) `attachment.author` is absent or null (system-generated or anonymous attachment); OR (b) `attachment.author` is present but both `displayName` and `accountId` are absent or null (exhausted fallback chain). Full resolution chain: (1) `attachment.author.displayName` if present and non-null; (2) else `attachment.author.accountId` if present and non-null; (3) else `"(anonymous)"`. This covers the H-NEW-ATTACHMENT-001 Call B fixture (author present, `displayName` null, no `accountId`).

**CLI flags** (pinned for e2e surface guard): `<KEY>` (positional, required); `--filter <FILTER>` (repeatable; key=value form); `--output json`; `--no-input`; `--profile <NAME>`; `--no-color`.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design; research §1a VERIFIED — no dedicated list endpoint)

---

#### BC-2.7.002: `attachment list <KEY> --output json` shape — `[{author, contentUrl, created, filename, id, mimeType, size}]`

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_list` (implementation pending — SOH-ATTACHMENTS-1 Story 1); `src/api/jira/attachments.rs::list_attachments` (implementation pending); `src/output.rs::render_json`
**Subject**: Issue read

`attachment list --output json` routes through `output::render_json` (JSON render invariant #526). The output is a JSON array; each element:

```json
[
  {
    "author": {
      "accountId": "62abc123...",
      "displayName": "Alice Operator"
    },
    "contentUrl": "https://mysite.atlassian.net/rest/api/3/attachment/content/10042",
    "created": "2026-07-10T14:23:11.000+0000",
    "filename": "screenshot.png",
    "id": "10042",
    "mimeType": "image/png",
    "size": 43008
  }
]
```

Field notes:
- `size` is a raw `u64` integer (bytes), never a human-formatted string (contrast with the table in BC-2.7.001).
- `contentUrl` is the stable authenticated Jira content endpoint (`/rest/api/3/attachment/content/{id}`) — it is an indirection that 303-redirects to a pre-signed media URL at request time; it is NOT itself an expiring signed URL. Surfacing this field satisfies issue #585 (absorbed into SOH-ATTACHMENTS-1 Story 1; close #585 as fixed-by #576 after Story 1 ships). **Research basis**: research §7 VERIFIED — the `content` field is already present in `fields.attachment[]` and is a stable Jira endpoint. **Field name rationale**: `jr` exposes this as `contentUrl` (not the raw Jira API field name `content`) for clarity — `content` alone is ambiguous in a JSON context; `contentUrl` makes the type (URL) self-evident. This is a `jr` display convention documented here.
- `author` mirrors the existing `User` serde shape from `src/types/jira/user.rs`.
- `thumbnail` / `thumbnailUrl` fields that may appear in some Jira attachment objects are **omitted** from both the table output (BC-2.7.001) and this JSON output in this slice. They are not surfaced because thumbnail availability is instance-dependent and the pre-signed thumbnail URL has a short TTL unsuitable for offline use.

Empty issue → `[]` array, exit 0, no error.

**JSON key ordering (BTreeMap-canonical — P19-001)**: the canonical attachment-object JSON shape has BTreeMap-ordered (alphabetical) keys at all depths: `author` < `contentUrl` < `created` < `filename` < `id` < `mimeType` < `size` at the top level; `accountId` < `displayName` within the `author` object. This is consistent with BC-3.9.010 (delete shapes, BTreeMap-ordered) and the EC-2.7.007-7 download manifest inner key ordering (`filename` < `id` < `path` < `size`). Implementation consequence: serialize via a type that yields alphabetical key order — e.g., a `BTreeMap`-backed serializer or `serde_json::Map` without the `preserve_order` feature (which is NOT enabled in this crate). Bare struct-declaration order does NOT guarantee alphabetical JSON emission.

**Null author in JSON**: when `attachment.author` is absent or null, the JSON element emits `"author": null` (not an omitted key and not an empty object). This is consistent with the Jira API's own null representation for missing sub-objects. **Partial-author case** (author present but `displayName` and `accountId` both absent or null): the JSON element emits the `author` object as received from the API — no `"(anonymous)"` substitution is applied in JSON mode. The resolution chain in EC-2.7.001-3 is a table-rendering convention only; JSON mode is pass-through.

All `--output json` paths MUST route through `output::render_json` or `output::print_output` — never `serde_json::to_string_pretty` or direct compact printing (JSON render invariant #526).

**Authority for all attachment-object serializations**: the curated form defined in this BC is the single canonical attachment-object JSON shape for `jr` attachment **list** and **upload** (platform POST + bulk echo) responses. **`download` is excluded**: the download JSON shape is the distinct `{"downloaded":[...]}` manifest defined in BC-2.7.007 (EC-2.7.007-7), not an attachment-object array. [P6-003 correction] BC-3.9.009 (upload JSON output) cross-references this BC as the authority. The `"self"` field MUST be omitted and `"content"` MUST be renamed to `"contentUrl"` across every code path that serializes a Jira attachment object.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; #585 absorbed — research §7 VERIFIED; DEC-179 ratified design)

**VP-576-004**: curated attachment-object JSON transformation pin — `jr issue attachment list <KEY> --output json` and `jr issue attachment upload <KEY> <FILE> --output json` via wiremock: inspect every JSON object in the returned array and assert: (1) NO element contains a `"self"` key — the Jira API `"self"` field MUST be omitted from `jr` output; (2) every element contains a `"contentUrl"` key and NO element contains a `"content"` key — the Jira API `"content"` field MUST be renamed to `"contentUrl"`. These two invariants hold for ALL serialization paths — list (BC-2.7.002) and upload platform POST (BC-3.9.009). A regression that passes `"self"` through or emits `"content"` instead of `"contentUrl"` MUST fail these assertions. Pins BC-2.7.002 authority clause ("the `'self'` field MUST be omitted and `'content'` MUST be renamed to `'contentUrl'` across every code path that serializes a Jira attachment object"); cross-references BC-3.9.009 (upload JSON output authority). P20-006. **Story allocation (P24-002)**: list half verified at S1 (BC-2.7.002 home); upload-platform-POST half verified at S3 (BC-3.9.009); the full cross-path test lands at S3 — S3 depends_on S1 for the shared curated-serialization plumbing (earliest consumer S1 ships it, per the R3.13 principle). NOT part of the S1 acceptance matrix as a whole; the S1 matrix includes only the list half.

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
**EC-2.7.003-2** (unknown filter key or missing `=` — applies to the entire `--filter` family across `attachment list` and `attachment download`): if a `--filter` value does not contain `=`, exit 64 before any HTTP call: `"Invalid filter '<VALUE>': expected key=value form. Accepted keys: mime=, name=, size-max=."`. If `=` is present but the key before it is not `mime`, `name`, or `size-max`, exit 64: `"Unknown filter key '<KEY>'. Accepted keys: mime=, name=, size-max=."`. This validation is an application pre-flight check; no HTTP call is issued on either path.

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
| 403 | 1 | `"Permission denied: cannot access issue <KEY>."` |
| 401 | 2 | Not authenticated + `jr auth login` hint |
| 5xx | 1 | `API error (<N>)` |
| Network error | 1 | Connectivity hint |

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design; follows BC-2.3.033/034 universal error pattern); P15-005 (403 row added — consistent with BC-2.7.012 403 = exit 1)

---

#### BC-2.7.007: `attachment download <KEY> --id <AID>` single-file download; `--out <PATH>` path override

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_download` (implementation pending — SOH-ATTACHMENTS-1 Story 2); `src/api/jira/attachments.rs::get_attachment_content` (implementation pending)
**Subject**: Issue read
**Output channel profile**: 3 (Mixed) — human mode writes no stdout data (completion hints and errors to stderr); `--output json` writes the download manifest to stdout (EC-2.7.007-7 shape).

`jr issue attachment download <KEY> --id <AID>` downloads a single attachment to disk.

**Selector required (clap required-group)**: `jr issue attachment download <KEY>` without any selector (`--id`, `--all`, or `--newest`) is rejected by clap at parse time — the three selector flags form a required mutually-exclusive group. clap exits 2 with a usage hint listing all three options. This is enforced at the CLI layer; no HTTP call is made.

**AID validation (P7-001, CWE-88)**: before issuing any HTTP request, `jr` validates `<AID>` against `^[0-9]+$`. A non-numeric or path-traversal-shaped AID (e.g., `"10001/../../issue/X"`) → exit 64; stderr: `"invalid attachment id: '<VALUE>' (must be numeric)"`; no HTTP calls issued. This fires before step 1 below.

**Wire path (two-step)**:
1. `GET /rest/api/3/attachment/{id}` — metadata fetch (read-only). The Jira API response includes a `"content"` field (the stable content URL); `jr` renames this to `"contentUrl"` in its curated output (BC-2.7.002 convention). The download flow does NOT read this field from the step-1 response — it constructs the content URL from the attachment id directly (see step 2). The metadata response is used solely to obtain the canonical `filename` for BC-2.7.010 naming. **The metadata deserialization uses a PARTIAL struct requiring only `filename` (id implied by the request); all other fields (`created`, `author`, `mimeType`, `size`, `content`) are absent-tolerant — the step's sole purpose is canonical-filename retrieval, and fixtures/servers may omit metadata fields. (P26-003)** (Curated `jr` output fields from BC-2.7.002: `author`, `contentUrl`, `created`, `filename`, `id`, `mimeType`, `size` — BTreeMap-alphabetical order per P19-001.) **The `<KEY>` argument is NOT server-verified on the `--id` path** — the AID is authoritative; `<KEY>` is accepted for CLI-surface uniformity but `jr` does not issue a separate key-ownership check.
2. `GET /rest/api/3/attachment/content/{id}` — streaming download. This path is uniform for both platform and JSM issues. The servicedeskapi `links.content` URLs MUST NOT be used for download: JSDCLOUD-10841 (confirmed in research §P2-6 of `.factory/research/issue-576-attachments-api-2026-07-15.md`) shows these URLs return 404.

**`--out` does NOT skip step 1 (UNCONDITIONAL two-step; P20-003)**: When `--out <PATH>` is supplied, `GET /rest/api/3/attachment/{id}` (step 1, metadata fetch) is issued unconditionally before any download begins. Rationale: uniform wire story + pre-stream existence validation — if the AID does not exist or is inaccessible, `jr` exits 64 (EC-2.7.007-1 / EC-2.7.007-1b) before writing any bytes to the specified output path. The accepted cost is one extra GET per download on the `--out` path.

**Redirect following**: Jira Cloud redirects this endpoint (302/303) to a pre-signed CDN URL (`media.atlassian.com` or AWS). The reqwest client MUST rely on its default redirect policy (up to 10 redirects). reqwest 0.13.4 strips `Authorization`, `Cookie`, and `Proxy-Authorization` headers on cross-host redirects — VERIFIED in research §1c and independently corroborated by GHSA-9857-6MW7-FQ2M (which explicitly states the reqwest backend compares `prev_url.host_str()` to `curr_url.host_str()` and strips sensitive headers on cross-domain hops). No custom `RedirectPolicy` is needed. **CRITICAL**: `?redirect=false` MUST NOT be used — JRACLOUD-97046 (research §6) causes encoded or broken responses for some file formats when this query parameter is present.

**Streaming**: response bytes are streamed to disk via `Response::bytes_stream()` + incremental write (e.g., `tokio::io::copy`). The full body is never buffered in memory, guarding against OOM for large attachments. Requires the reqwest `stream` feature in `Cargo.toml` (Rev 2 §R2.1).

**Output path**: for single `--id` without `--out`, the default filename is the bare sanitized basename (no SHA-1 prefix) — see BC-2.7.010 (single-id bare naming rule) and the degenerate-name fallback (id-as-filename when sanitization yields None). `--out <PATH>` overrides the default with an explicit file path; the user-supplied path is NOT sanitized against CWE-22 (trusted input from the operator).

**Overwrite behavior** (DEC-179 ruling 3): if the computed or specified output path already exists as a regular file, the handler MUST refuse with exit 64: `"File already exists: <path>. Use --force to overwrite."` The `--force` flag bypasses this check and overwrites silently. This prevents accidental data loss for idempotent re-runs.

On success, a completion hint is emitted to stderr: `"Downloaded: <path> (<size_human>)."` Nothing is written to stdout (profile 3).

**Write-to-temp + atomic-rename**: The download MUST write to a temporary file named `tmp_<random>` in the same directory as the final path (where `<random>` is a process-unique random string; NO basename is embedded). A deterministic or basename-derived name (e.g., `.partial` suffix, `tmp_<random>_<basename>`) MUST NOT be used — a fixed name collides when two processes download to the same directory concurrently, and embedding the basename risks overflowing `NAME_MAX` when the sanitized basename is near the 214-byte cap (41-byte SHA-1 prefix + random token + basename can exceed 255 bytes on the temp filename even when the final name fits). Only on successful stream completion does `jr` atomically rename the temporary file to the final path. This prevents an interrupted download from leaving a truncated file at the final path that would block a retry (the overwrite-refuse guard checks for the FINAL path, not the temp file). On any error (network failure, disk error, process signal), the temporary file MUST be deleted before `jr` exits; the final path is NOT written.

**Ctrl+C / SIGINT during download** (exit 130): if the user interrupts the download mid-stream, the partial file is cleaned up (deleted), the final path is not written, and `jr` exits 130 (standard signal-interrupt exit code). Exit 130 is consistent with `JrError::Interrupted` (maps to exit code 130 in `src/error.rs`).

**EC-2.7.007-6** (`--out <PATH>` with missing parent directory): if the user-specified `--out <PATH>` names a file in a parent directory that does not exist, `jr` exits 64 before any download: `"Output directory does not exist: <parent>"`. The handler does NOT create parent directories automatically.

**EC-2.7.007-1** (AID does not exist — 404): `GET /rest/api/3/attachment/{id}` (metadata step 1) returns 404 → exit 64: `"Attachment <AID> not found or not accessible."` (canonical not-found string — aligns with BC-2.7.012, BC-3.9.008 EC-3.9.008-2, BC-3.9.015 EC-3.9.015-6); no streaming request issued; no file created. (see BC-2.7.012 for full error taxonomy).

**EC-2.7.007-1b** (AID permission denied — 403): `GET /rest/api/3/attachment/{id}` (metadata step 1) returns 403 → exit 1: `"Permission denied: cannot access attachment <AID>."` (NOT the canonical not-found string — 403 means the attachment exists but is inaccessible, which is a distinct condition; consistent with the 403 = exit 1 mapping across all attachment operations); no streaming request issued; no file created.

**EC-2.7.007-2** (JSM issue uniform behavior): downloading an attachment from a JSM issue uses the exact same platform content endpoint as a non-JSM issue. There is no JSM-specific code path for download. JSDCLOUD-10841 confirms the servicedeskapi links are unreliable; the platform endpoint is the correct single code path.

**EC-2.7.007-3** (credential-stripping regression guard — SEC-576-003 CWE-522): A wiremock integration test MUST assert that `GET /rest/api/3/attachment/content/{id}` following a cross-host 302/303 redirect does NOT include an `Authorization` header on the redirect-target request. Use a two-server wiremock setup (one for the Jira API endpoint, one for the simulated CDN redirect target). **The two wiremock servers MUST use DISTINCT HOST STRINGS** (e.g., `127.0.0.1` for the Jira API server and a second address such as `[::1]` or a distinct loopback hostname for the CDN target). Using the same host at different ports (e.g., two `127.0.0.1` instances on different ports) would make the assertion vacuous: reqwest's cross-host check compares `host_str()` output which IGNORES port numbers, so a same-host-different-port redirect would NOT strip `Authorization` headers — the test would pass while the credential-stripping invariant goes untested. This guards against a future `JiraClient` refactor adding a custom `RedirectPolicy` that silently forwards bearer/Basic credentials to CDN hosts.

**EC-2.7.007-4** (error mid-stream): temporary file (`tmp_<random>`) deleted; exit 1; `"Download failed: <reason>"` on stderr; final path not written.
**EC-2.7.007-5** (Ctrl+C / SIGINT mid-stream): best-effort MUST — temporary file (`tmp_<random>`) is deleted when possible; exit 130; no final path written. **Implementation-strategy note**: cleanup runs in the existing `tokio::signal::ctrl_c()` select! arm at `src/main.rs:~393` (the `tokio::select!` race that calls `std::process::exit(130)` on signal receipt); it does NOT run via `Drop` guards — the release profile uses `panic = abort` and `std::process::exit()` does not invoke destructors, so `Drop` is unreliable on the abort/signal path. The practical cleanup mechanism is explicit pre-exit deletion within the signal-handling code path. **Not holdout/VP-pinned**: this path is not deterministically testable in CI (signal timing dependent); the error-path cleanup (EC-2.7.007-4, H-NEW-ATTACHMENT-002) is the tested proxy for temp-file correctness. (P19-003)

**EC-2.7.007-8** (concurrent downloads, same out-dir): if two `jr` processes download the same attachment to the same output directory simultaneously, each writes to its own uniquely-named `tmp_<random>` file. There is no interleaving of temp files. When both rename to the final path, the last successful rename wins (standard OS atomic-rename semantics); the earlier written file is silently overwritten. This is safe: both processes produce identical bytes (same source URL), so the last rename wins without data loss. No locking between processes is required.
**EC-2.7.007-7** (`--output json` success shape for `--id`): `{"downloaded":[{"filename":"<name>","id":"<AID>","path":"<written path>","size":N}]}`; one-element `downloaded` array; inner keys in alphabetical order (`filename` < `id` < `path` < `size`); stdout only; exit 0. `path` is the output path as-constructed by `jr` — NOT canonicalized, NOT made absolute (BC-2.7.010 path-non-determinism note; P18-004). `size` is the byte count written. No stderr output in JSON mode. Output MUST route through `output::render_json` (#526 invariant). **`filename` semantics (P27-001)**: `downloaded[].filename` is the RAW Jira `attachment.filename` (pre-sanitization); the on-disk basename (post-sanitization per BC-2.7.011) is recoverable from `path` (basename of `path` = on-disk name). Deliberate pairing: `filename` = what Jira calls it; `path` = where it landed. **Degenerate-name warning in JSON mode (INFO-NEW-7)**: when the degenerate-name fallback fires (BC-2.7.010 R3.10), its stderr warning is a NON-ERROR hint suppressed in `--output json` mode — consistent with the "No stderr output in JSON mode" policy of this EC; shared rule defined at BC-2.7.010.

**EC-2.7.007-9** (`--out` without `--id` — clap binding): `--out <PATH>` MUST be declared with `requires = "id"` (clap `requires` → exit 2 when `--out` is supplied without `--id`). `--out` combined with `--all` or `--newest` is invalid: batch downloads write to a directory (`--out-dir`), not a single file path.

**EC-2.7.007-10** (`--filter` with `--id` — clap conflict): `--filter <FILTER>` MUST be declared with `conflicts_with = "id"` (clap `conflicts_with` → exit 2 when `--filter` is supplied together with `--id`). `--filter` applies only to `--all` and `--newest N` batch paths; it has no defined semantics on the single-ID path (the AID already uniquely identifies one attachment). Applies to all `--filter` variants (mime/name/size-max). P15-004.

**EC-2.7.007-11** (`--out <PATH>` names an existing directory): if the user-specified `--out <PATH>` resolves to a path that already exists as a **directory**, `jr` exits 64 before any download: `"output path is a directory: <PATH>"`. Checked pre-download in the same pre-flight family as the overwrite-refuse guard (BC-2.7.007 Overwrite behavior). No file is created and no streaming request is issued. P15-006.

**Observability** (`--verbose` / `--verbose-bodies`): `--verbose` logs method + URL only (unchanged CLAUDE.md rule SD-003). `--verbose-bodies` MUST NOT attempt to materialize the streaming response body — the body is a potentially large binary stream and buffering it for logging would defeat the OOM-safety design of streaming download. On a download response, `--verbose-bodies` MUST log response headers and the final written byte count ONLY (e.g., `<download body: N bytes written to <path>>`), never content. The PII warning that `--verbose-bodies` emits extends to attachment content by extension (attachment payloads may contain credentials, personal data, or confidential documents).

**CLI flags** (pinned for e2e surface guard): `<KEY>` (positional, required); `--id <AID>` (single download); `--all` (batch); `--newest <N>` (top-N); `--out <PATH>` (single-file path override; requires `--id`, clap `requires` — EC-2.7.007-9); `--out-dir <DIR>` (batch target directory; requires `--all` or `--newest` via clap `ArgGroup` + `requires` — EC-2.7.008-9); `--force` (overwrite existing); `--filter <FILTER>` (repeatable; `conflicts_with = "id"` — exit 2 when combined with `--id` — EC-2.7.007-10); `--output json`; `--no-input`; `--profile <NAME>`; `--no-color`.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design; research §1b–1d VERIFIED; JSDCLOUD-10841 §P2-6 VERIFIED — platform endpoint for JSM; JRACLOUD-97046 §6 no-redirect-false; GHSA-9857-6MW7-FQ2M corroboration); SEC-576-003 (CWE-522 credential-stripping wiremock test requirement added 2026-07-15); P26-003 (step 1 partial-struct clause added — metadata deserialization is absent-tolerant on all fields except `filename`; partial form distinguished from shared LIST-path struct); P27-001 (EC-2.7.007-7 `filename` semantics clause added: RAW Jira name pre-sanitization; on-disk basename recoverable from `path`)

---

#### BC-2.7.008: `attachment download <KEY> --all` batch download to `--out-dir <DIR>`; default dir is cwd

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_download` (implementation pending — SOH-ATTACHMENTS-1 Story 2)
**Subject**: Issue read

`jr issue attachment download <KEY> --all` downloads all attachments on the issue to a directory. Default target is the current working directory; `--out-dir <DIR>` overrides. The handler first fetches the full attachment list (same `GET /rest/api/3/issue/{key}?fields=attachment` call as `attachment list`). **Batch metadata source**: filename, size, and `contentUrl` for each attachment are taken directly from `fields.attachment[]` in this list response. The per-attachment step-1 `GET /rest/api/3/attachment/{id}` metadata fetch used by single-`--id` download (BC-2.7.007) is SKIPPED on batch paths — that step is only needed on the single-ID path to obtain the canonical filename when no list is available. The handler then issues the streaming step-2 `GET /rest/api/3/attachment/content/{id}` for each attachment (the download step from BC-2.7.007 wire path). H-NEW-ATTACHMENT-003 and H-NEW-ATTACHMENT-007 holdout mock topologies correctly reflect this: they mount only the issue-fetch GET and per-attachment content GETs, not per-attachment metadata GETs. Each file is named using BC-2.7.010 (batch path: `<sha1-of-id>_<sanitized-basename>`) within the target directory.

**Overwrite behavior with `--all`**: without `--force`, per-file collision is handled fail-soft — the colliding file is skipped with a per-file stderr warning (e.g., `"Skipping <filename>: file already exists. Use --force to overwrite."`). The download continues for remaining attachments. With `--force`, existing files are overwritten silently. **Collision-skip is a NON-ERROR**: the overall exit code is 0 even if some files were skipped for being pre-existing (same class as `--filter` exclusions). Exit 1 is scoped exclusively to content-GET/stream failures (EC-2.7.008-7/8).

On completion a summary hint emits to stderr: `"Downloaded N of M attachments to <dir>."` (N = successful, M = total).

**Per-file download error policy (fail-soft-continue)**: A per-file content-GET failure (403, 404, 5xx, network error, or mid-stream abort on `GET /rest/api/3/attachment/content/{id}`) on a batch path (`--all` / `--newest`) does NOT abort the batch. For each failed file: (1) a stderr warning is emitted: `"warning: failed to download attachment <AID>: <reason>"`; (2) any in-progress temporary file for that attachment is deleted (same temp-delete mechanics as EC-2.7.007-4 for the single-ID path); (3) the failed attachment is excluded from the `downloaded` array in JSON mode and from the N count in the human-mode summary (the `"Downloaded N of M"` summary is a HINT — not emitted in JSON mode per EC-2.7.008-6 JSON-mode stderr policy, P25-001). The batch continues with the remaining attachments. **Final exit code**: 0 if all files succeeded; 1 if ANY file failed (including all-fail). In `--output json` mode on partial failure, the manifest is still emitted to stdout (partial `downloaded` array) while exit code is 1 — callers MUST NOT assume a non-zero exit code implies no stdout output on download commands.

**EC-2.7.008-1** (empty attachment list): issue has no attachments → exit 0; stderr: `"No attachments on <KEY>."` (canonical string — unified with EC-2.7.001-1; "found" removed for consistency)

**EC-2.7.008-2** (directory does not exist): if `--out-dir <DIR>` is specified and the directory does not exist → exit 64 before any download: `"Output directory does not exist: <DIR>"`. The handler does NOT create the directory automatically.

**EC-2.7.008-3** (`--id` and `--all` mutual exclusion): clap enforces `conflicts_with` → exit 2 when both are supplied simultaneously.
**EC-2.7.008-4** (`--out-dir` path exists but is not a directory): exit 64: `"Not a directory: <PATH>"`. A regular file at the specified path is rejected; the handler requires a directory.
**EC-2.7.008-5** (`--out-dir` path does not exist): supersedes EC-2.7.008-2 wording clarification — same exit 64: `"Output directory does not exist: <DIR>"`.
**EC-2.7.008-6** (`--output json` success shape for `--all` / `--newest N`): `{"downloaded":[{"filename":"<name>","id":"<AID>","path":"<written path>","size":N},…]}`; N-element `downloaded` array (one entry per file written; files skipped due to collision or `--filter` are NOT in the array); inner keys alphabetical; stdout only; exit 0 (all attempted downloads either succeeded or were skipped as pre-existing — collision-skips are NON-ERROR, same class as `--filter` exclusions) or exit 1 (content-GET/stream failure — per EC-2.7.008-7/8; the manifest is still emitted even when exit code is 1). **JSON-mode stderr policy (hint-vs-error distinction, P25-001)**: per-file failure warnings (`"warning: failed to download attachment <AID>: <reason>"`) ARE emitted to stderr in JSON mode — download failures are ERRORS, not hints, and fire unconditionally (consistent with the model-b cache-writer warning convention). The `"Downloaded N of M"` summary is NOT emitted in JSON mode — it is a HINT, suppressed in JSON mode by this rule. **Collision-skip warnings (P27-003)**: collision-skip warnings (e.g., `"Skipping <filename>: file already exists. Use --force to overwrite."`) are NON-ERROR hints — suppressed in `--output json` mode (same class as the `"Downloaded N of M"` summary and `--filter` exclusions which are silent; the manifest's omission of the skipped file IS the machine signal, consistent with EC-2.7.008-10 filtered-to-zero precedent). Human mode unchanged. `path` is the output path as-constructed by `jr` — NOT canonicalized, NOT made absolute (BC-2.7.010 path-non-determinism note; P18-004). Shape aligns with EC-2.7.007-7 for a uniform download response type. Output MUST route through `output::render_json` (#526 invariant). **`filename` semantics (P27-001)**: `downloaded[].filename` is the RAW Jira `attachment.filename` (pre-sanitization); the on-disk basename (post-sanitization per BC-2.7.011, post-SHA-1-prefix for batch paths per BC-2.7.010) is recoverable from `path`. Deliberate pairing: `filename` = what Jira calls it; `path` = where it landed.



**EC-2.7.008-7** (some-fail-some-succeed — fail-soft exit code): if one or more content-GET/stream steps fail while others succeed, exit code is 1; `downloaded` array in JSON mode contains only the successful entries (failed attachments excluded); stderr per-file warnings emitted for each failure (in both human and JSON modes — failures are ERRORS, not hints; see EC-2.7.008-6 JSON-mode stderr policy, P25-001); **human mode only**: summary prints actual `N` of `M` where N < M (the `Downloaded N of M` summary is not emitted in JSON mode — it is a HINT per EC-2.7.008-6). Temp file deleted per failure (EC-2.7.007-4 mechanics).

**EC-2.7.008-8** (all-fail): if every content-GET step fails, exit 1; `downloaded` array is empty (`[]`) in JSON mode; summary prints `"Downloaded 0 of M attachments to <dir>."` Per-file stderr warnings still emitted for each failure.

**EC-2.7.008-9** (`--out-dir` without `--all` or `--newest` — clap binding): `--out-dir` MUST be declared with `#[arg(requires = "batch_selector")]` where `batch_selector` is an `ArgGroup` containing `[all, newest]` — the correct clap 4 mechanism for "requires any one of a group" (clap 4 has no `requires_one_of` attribute; `ArgGroup` is the canonical approach; note this is `jr`'s first `ArgGroup` use, establishing precedent). clap exits 2 when `--out-dir` is supplied without either `--all` or `--newest`. Supplying `--out-dir` with `--id` is invalid: a single-file download writes to an explicit `--out <PATH>` or defaults to the current directory.

**EC-2.7.008-10** (filtered-to-zero on a non-empty issue): when `--all` is used with one or more `--filter` flags and the filter set matches zero attachments from a non-empty issue (i.e., the issue has ≥1 attachments but none pass the filter), the behavior is **distinct** from EC-2.7.008-1 (empty-issue path): → exit 0; stderr: `"No attachments matched the filter on <KEY>."` (canonical string; different from `"No attachments on <KEY>."` which is the empty-issue message); JSON mode: stdout `{"downloaded":[]}` (empty array, consistent with EC-2.7.008-6 uniform `downloaded` array shape); **JSON-mode stderr**: the `"No attachments matched the filter"` message is a HINT — suppressed in JSON mode (same class as EC-2.7.001-1 zero-attachment hint; the empty `downloaded` array is self-describing; per EC-2.7.008-6 hint-vs-error principle, INFO-NEW-6); no download requests issued. P15-007.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design); P15-007 (EC-2.7.008-10 filtered-to-zero non-empty); P25-001 (EC-2.7.008-6 JSON-mode hint-vs-error policy; EC-2.7.008-7 human-mode summary scoping; Per-file download error policy point (3) scoped); INFO-NEW-6 (EC-2.7.008-10 JSON-mode stderr: filtered-to-zero hint suppressed — per EC-2.7.008-6 hint-vs-error principle); P27-001 (EC-2.7.008-6 `filename` semantics clause added: RAW Jira name pre-sanitization; on-disk basename recoverable from `path`); P27-003 (EC-2.7.008-6 collision-skip hint-vs-error classification: collision-skip warnings are NON-ERROR hints, suppressed in JSON mode)

---

#### BC-2.7.009: `attachment download <KEY> --newest N` — select most-recent N attachments by `created` date, then download

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_download` (implementation pending — SOH-ATTACHMENTS-1 Story 2)
**Subject**: Issue read

`jr issue attachment download <KEY> --newest N` downloads at most N attachments, selecting the N most recently created (by `attachment.created` descending). The `created` field is parsed as a `chrono::DateTime<FixedOffset>` before sorting; lexicographic sort MUST NOT be used (consistent with BC-3.9.019 which also mandates `chrono` for `created` comparison). Fixtures typically use the `+0000` offset, but the implementation MUST NOT assume a uniform offset — different attachments on the same issue may carry distinct UTC offsets, making lexicographic comparison incorrect in the general case.

**Behavior**: fetch full attachment list (same `GET /rest/api/3/issue/{key}?fields=attachment` as `attachment list`) → apply any `--filter` flags (mime/name/size-max) → sort by `created` descending → take first N → issue step-2 streaming `GET /rest/api/3/attachment/content/{id}` for each selected attachment. **Batch metadata source**: filename, size, and `contentUrl` are taken from `fields.attachment[]` in the list response. The per-attachment step-1 `GET /rest/api/3/attachment/{id}` metadata fetch is SKIPPED (same as BC-2.7.008) — that step is single-`--id`-only. Output naming follows BC-2.7.010.

`--filter` applies BEFORE the top-N selection: `--newest 3 --filter mime=image/*` = the 3 most recently added images.

If the issue has fewer than N attachments after filtering, all available attachments are downloaded (not an error; N > available count is handled gracefully).

`--newest N` is mutually exclusive with `--id` (clap `conflicts_with` → exit 2). `--newest N` combined with `--all` is rejected (clap `conflicts_with` → exit 2). Overwrite and `--force` behavior follow BC-2.7.007/BC-2.7.008. Per-file content-GET errors on `--newest` batch downloads follow BC-2.7.008's fail-soft-continue policy (EC-2.7.008-7/8): per-file warning + temp-delete + continue; exit 1 if any file failed.

**EC-2.7.009-1** (N ≤ 0 — clap parses `--newest` as a signed integer i64; app validates N ≥ 1): `--newest` MUST be declared with `allow_negative_numbers = true` so that negative values (e.g. `-5`) reach the handler as a valid i64 rather than being intercepted by clap as an unknown flag (clap exit 2). The handler validates N ≥ 1; if it finds N ≤ 0, exit 64 before any HTTP call: `"--newest requires a positive integer."` N = 0 is rejected (zero-download is ambiguous, not silently accepted). (arg-level `Arg::allow_negative_numbers`, clap 4 — verified against docs.rs 4.6.1, P17-007)
**EC-2.7.009-2** (non-integer value for `--newest`): clap cannot parse the value as i64 → clap exit 2 with a usage error; no HTTP call. Message is clap-generated (not controlled by `jr` application code).

**EC-2.7.009-3** (filtered-to-zero on a non-empty issue): when `--newest N` is used with one or more `--filter` flags and the filter set matches zero attachments from a non-empty issue (i.e., the issue has ≥1 attachments but none pass the filter), the behavior is distinct from the empty-issue case: → exit 0; stderr: `"No attachments matched the filter on <KEY>."` (canonical string; matches EC-2.7.008-10; different from the empty-issue message); JSON mode: stdout `{"downloaded":[]}` (empty array); **JSON-mode stderr**: the `"No attachments matched the filter"` message is a HINT — suppressed in JSON mode (same class as EC-2.7.008-10 / EC-2.7.001-1; per EC-2.7.008-6 hint-vs-error principle, INFO-NEW-6); no download requests issued. P15-007.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design); P15-007 (EC-2.7.009-3 filtered-to-zero non-empty); INFO-NEW-6 (EC-2.7.009-3 JSON-mode stderr: filtered-to-zero hint suppressed — per EC-2.7.008-6 hint-vs-error principle)

---

#### BC-2.7.010: Default download output path — batch: `<sha1-of-id>_<sanitized-basename>`; single-`--id`: bare sanitized basename; id-as-filename degenerate fallback

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_download` (implementation pending — SOH-ATTACHMENTS-1 Story 2)
**Subject**: Issue read

When no `--out <PATH>` is specified, the default output filename depends on the selector used:

**Single-`--id` path (bare naming)**: the default filename is the bare result of `sanitize_attachment_filename(attachment.filename)` (BC-2.7.011 pipeline). No SHA-1 prefix. Filename is human-readable; overwrite-refuse (`--force`) handles collisions on re-runs (BC-2.7.007). This aligns with peer conventions (e.g., `curl` default, `gh` download).

**Batch paths (`--all` / `--newest N`) — SHA-1-prefix naming**:
```
<sha1-of-id>_<sanitized-basename>
```
- `<sha1-of-id>`: full 40-character lowercase hex-encoded SHA-1 of the attachment `id` string (NOT a content hash — ID is stable; deterministic naming without reading file content).
- `<sanitized-basename>`: result of `sanitize_attachment_filename(attachment.filename)` per BC-2.7.011.

**Rationale for SHA-1 prefix on batch paths**: collision-resistance when an issue has multiple attachments sharing the same sanitized basename (e.g., two files both named `report.pdf`); idempotency (re-running `--all` produces the same filenames, allowing `--force` to overwrite predictably). On single-`--id`, there is only one file; collisions are handled by the overwrite-refuse guard; the prefix is unnecessary and reduces usability.

**Single-vs-batch asymmetry (deliberate)**: the two modes intentionally differ. Peer-convention alignment (bare for targeted download) and deduplication-safety (prefixed for batch) are both served. This is the research-backed ruling (Part 3 of `.factory/research/issue-576-attachments-api-2026-07-15.md`).

**Degenerate-name fallback (R3.10 ruling)**: if `sanitize_attachment_filename` returns `None` or an empty string (rejects path-traversal, NUL bytes, etc.), the fallback depends on mode: **single-`--id` mode** → raw attachment `id` string (bare, no prefix — consistent with single-id bare naming); **batch mode (`--all`/`--newest N`)** → `<sha1-of-id>_<id>` (SHA-1 prefix of the id + raw id — consistent with the normal batch naming scheme, and zero special-cases in batch collision logic). In both cases the id string is always a safe filename (numeric-only, no path components). The fallback is NOT subject to BC-2.7.011 (the id needs no sanitization). Emit a stderr informational note: `"warning: using id as filename for attachment <AID> — original name '<raw>' could not be sanitized."` (distinct wording from the "skipping" warning in BC-2.7.011 caller contract; this fallback writes a file rather than skipping). **Degenerate-name warning channel classification (INFO-NEW-7)**: this warning is a NON-ERROR hint — suppressed in `--output json` mode (same class as collision-skip warnings per EC-2.7.008-6 hint-vs-error taxonomy; the operation succeeds and the manifest `path` field reveals the id-based substituted name). Human mode unchanged. This classification applies to both single-`--id` and batch paths.

**Combined-name length cap (batch)**: `<sha1(40)>_<basename>` is at most 255 bytes (41-byte prefix + 214-byte cap from BC-2.7.011 step 5 = 255). **Single-id**: bare name is capped at 214 bytes (BC-2.7.011 step 5) — conservative, fits within 255 bytes.

**Examples (single-`--id`)**:
- `id="10042"`, `filename="notes.txt"` → `notes.txt` (bare)
- `id="10042"`, `filename="../../../etc/passwd"` → sanitized → `passwd` (bare)
- `id="10042"`, `filename=".."` → sanitization returns `None` → fallback `10042`

**Examples (batch)**:
- `id="20001"`, `filename="report.pdf"` → `<sha1("20001")>_report.pdf`
- `id="20002"`, `filename="report.pdf"` → `<sha1("20002")>_report.pdf` (distinct prefix prevents collision)
- `id="20003"`, `filename=".."` → sanitization returns `None` → fallback `<sha1("20003")>_20003` (batch degenerate: SHA-1 prefix + raw id, R3.10)

When `--out <PATH>` is supplied on the single-file path (BC-2.7.007), all default naming is bypassed and the explicit path is used. The user-supplied path is NOT sanitized (trusted operator input).

**`path` field non-determinism (P18-004 ruling)**: the `path` value in the download JSON manifest (EC-2.7.007-7 / EC-2.7.008-6) is the output path exactly as constructed by `jr`: the user-supplied `--out` value verbatim, or the out-dir joined with the final filename (BC-2.7.010 naming rules above). The path is NOT canonicalized and NOT made absolute. Consequently: snapshot tests MUST redact or normalize `path` (e.g., via a TempDir root substitution); exact-match assertions on `path` are only valid with a controlled current working directory.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design; #576 SHA-1-prefix proposal incorporated); P18-004 (path-non-determinism ruling added)

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
5. **Length cap** (UTF-8-safe truncation for the sanitized basename): truncate to at most **214 bytes** on a valid UTF-8 character boundary (Rust `floor_char_boundary` semantics — never split a multi-byte codepoint). Rationale for 214 bytes: batch paths (BC-2.7.010) prepend a 41-byte SHA-1 prefix (`<40 hex chars>_`); 214 + 41 = 255 = POSIX/Windows NTFS filename component limit. Single-`--id` bare paths and `--out <PATH>` overrides carry no prefix and could in principle allow up to 255 bytes, but 214 bytes is retained as a conservative uniform cap — avoids a dual cap-calculation per call site and leaves headroom for OS metadata.
5.5. **Trailing whitespace/dot strip** (SEC-576-007 — Windows predictability): strip trailing ASCII whitespace characters and trailing `.` from the basename after the length cap. Windows silently removes trailing dots and spaces from filename components on write; stripping them makes the sanitized output identical on Windows and POSIX, preventing unpredictable collision between two Jira attachments whose names differ only by trailing characters.

Return `Some(sanitized_name)` if all steps produce a non-empty string; otherwise `None`.

**Caller contract** [P8-001 CORRECTION — prior "MUST skip" + skip-warning text reversed; R3.10 fallback writes the file, does not skip]: if `sanitize_attachment_filename` returns `None` or an empty string, the caller MUST apply the BC-2.7.010 R3.10 degenerate-name fallback: **single-`--id` mode** → write the file named with the raw attachment `id` string (bare, no prefix); **batch mode** → write the file named `<sha1-of-id>_<id>`. In both cases emit a per-file stderr informational note: `"warning: using id as filename for attachment <AID> — original name '<raw>' could not be sanitized."` (wording is intentionally distinct from the CWE-22 path-escape warning; see BC-2.7.010 R3.10 for the naming rule). The overall download operation continues for remaining attachments (fail-soft per-file).

**Windows device-name caller note (SEC-576-001 — CWE-22)**: The sanitized name returned by `sanitize_attachment_filename` may match a Windows reserved device base-name (`CON`, `NUL`, `PRN`, `AUX`, `COM1`–`COM9`, `LPT1`–`LPT9`). Any call site that writes the result to disk MUST ensure the final on-disk filename is not a bare device name before the extension dot. **Batch paths** (BC-2.7.010): the SHA-1 prefix (`<sha1>_CON`, `<sha1>_NUL`, etc.) satisfies this requirement automatically — `<sha1>_CON` is NOT a Windows reserved name. **Single-`--id` bare naming** (BC-2.7.010): the implementation call site MUST apply a device-name escape before writing (e.g., prepend `_` when the sanitized basename before the first `.` is a reserved device name). **`--out <PATH>` override**: uses trusted operator-supplied paths and is NOT subject to this note (the operator is responsible for their path choice).

**Defense-in-depth containment check (SEC-576-002 — CWE-22, corrected procedure)**: after joining the sanitized name with the target directory, the implementer MUST use the following two-step procedure. Do NOT call `canonicalize()` on the joined path — `std::fs::canonicalize` returns `Err` for non-existent paths, which would cause every new download to be treated as a containment failure:

1. `let resolved_dir = out_dir.canonicalize()?` — canonicalize `out_dir` (which is guaranteed to exist: (a) `--all`/`--newest` batch paths enforce existence via BC-2.7.008 EC-2.7.008-2 before any download begins; (b) single-`--id` without `--out` defaults `out_dir` to the current working directory — `canonicalize(cwd)` trivially succeeds since cwd always exists; (c) **`--out <PATH>` is excluded from this containment check entirely** — the user-supplied path is trusted operator input (BC-2.7.007/BC-2.7.010); neither step 1 (`canonicalize(out_dir)`) nor step 2 (`starts_with`) of this check applies to `--out`-supplied paths).
2. Assert `resolved_dir.join(&sha1_filename).starts_with(&resolved_dir)` — `Path::starts_with` is component-based (not a string-prefix check), so it correctly evaluates containment for a file that does not yet exist on disk.

Since step 4 of sanitization already strips `../`, `/`, `\`, `:`, the join will in practice always satisfy the `starts_with` assertion. The check is defense-in-depth against any encoding edge case not caught by steps 1–4. If `starts_with` returns `false`, skip with a warning: `"warning: skipping attachment <AID> — path escape detected after sanitization."` This skip-case is a defensive guard only; it should not occur for any name produced by the five-step algorithm above.

**Coverage/mutation exemption note**: The `starts_with` false branch is intentionally unreachable via any current Jira API-supplied filename after steps 1–5. This branch exists as defense-in-depth against future encoding edge cases or platform differences not covered by the step 1–5 guarantee. A mutation testing or line-coverage exemption for this specific branch is acceptable; annotate the branch with a comment referencing this BC (e.g., `// BC-2.7.011 defense-in-depth: unreachable via API-supplied filenames after sanitization steps 1-5`).

**Naive blacklist approaches are INSUFFICIENT**: do NOT rely on string-stripping `../` patterns alone — such blacklists are bypassable. The algorithm above is the required standard mitigation (research §4 of `.factory/research/issue-576-attachments-api-2026-07-15.md`, VERIFIED HIGH; OWASP/PortSwigger/CWE-31/22 first-principles).

**Unit test coverage required**: at minimum: `../../etc/passwd`, `/etc/passwd`, `C:\Windows\system32\foo.exe`, `"."`, `".."`, empty string, NUL-containing string, a normal filename, a filename exceeding 255 bytes, a filename containing `:` (Windows drive path), `"CON"` (Windows device name → `Some("CON")`), `"NUL"` (Windows device name → `Some("NUL")`), `"COM1"` (Windows device name → `Some("COM1")`), and `"nul.txt"` (Windows device name with extension → `Some("nul.txt")`), and a filename containing a multi-byte UTF-8 codepoint at the truncation boundary (e.g., a 214-byte ASCII prefix followed by a 3-byte UTF-8 char `"é"` — the char must be dropped, not split, so the output is the 214-byte prefix without truncation artifact). The test matrix confirms that `sanitize_attachment_filename` returns `Some(name)` for device names — the call-site device-name escape (SEC-576-001 caller note above, not this function) is what prevents on-disk device-name collisions on Windows for both batch (SHA-1 prefix) and single-id bare (explicit `_`-prefix escape at call site) paths.

**VP-576-001**: `sanitize_attachment_filename` property-based test — for every input in the required test matrix (BC-2.7.011 "Unit test coverage required" list): assert (1) no `Some(name)` result contains `/`, `\`, `:`, or a NUL byte; (2) `Some(name)` length in bytes is ≤ 214; (3) all `Some(name)` values are valid UTF-8 (no truncated multi-byte codepoints — `std::str::from_utf8` succeeds); (4) the specific cases `"."`, `".."`, empty string, and NUL-byte inputs each return `None`; (5) `"../../etc/passwd"` returns `Some("passwd")`; (6) `"/etc/passwd"` returns `Some("passwd")`; (7) a 214-byte ASCII prefix + 3-byte UTF-8 char returns `Some(214-byte prefix)` (char dropped, not split). Additional containment assertion for any `Some(name)`: `resolved_dir.join(&name).starts_with(&resolved_dir)` must hold for any `out_dir = TempDir::new()`. Pins BC-2.7.011 steps 1–5 and the defense-in-depth containment check. P14-007.

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; research §4 CWE-22 VERIFIED HIGH; DEC-179 SQ-1 resolved; OWASP/CWE-22/CWE-31 first-principles); SEC-576-001 (CWE-22 Windows device-name caller note + unit test matrix added 2026-07-15); SEC-576-002 (CWE-22 corrected two-step containment check procedure added 2026-07-15); SEC-576-007 (trailing-whitespace/dot strip step 5.5 added 2026-07-15); P14-007 (VP-576-001 added); P25-002 (containment step-1 case (c) reworded — pure does-not-apply exclusion for `--out <PATH>`: trusted operator input; neither step 1 nor step 2 applies to `--out`-supplied paths)

---

#### BC-2.7.012: `attachment download` on unknown KEY or unknown AID → exit 64 with informative error

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs::handle_attachment_download` (implementation pending — SOH-ATTACHMENTS-1 Story 2); `src/api/jira/attachments.rs::get_attachment_content` (implementation pending)
**Subject**: Issue read

**Unknown issue key** (batch paths only — `--all`/`--newest`; the `--id` path does not server-verify KEY per BC-2.7.007): when `<KEY>` does not exist or is inaccessible, `GET /rest/api/3/issue/{key}?fields=attachment` returns 404. Handler exits 64: `"Issue <KEY> not found or not accessible."`

**Unknown attachment ID**: when `--id <AID>` references a non-existent attachment, `GET /rest/api/3/attachment/{id}` (metadata step 1, per BC-2.7.007 two-step wire path) returns 404 → handler exits 64: `"Attachment <AID> not found or not accessible."` (canonical not-found string). A 403 response instead exits 1: `"Permission denied: cannot access attachment <AID>."` (403 = exists-but-inaccessible, not missing; consistent with 403 = exit 1 across all attachment operations).

**404 body-surfacing asymmetry (deliberate read-vs-write divergence)**: A 404 from the download metadata endpoint (`GET /rest/api/3/attachment/{id}`) emits the canonical string ONLY — the Jira error body is NOT appended. This diverges from `attachment delete` (BC-3.9.008), where a 404 surfaces the Jira error body per DEC-168. Rationale: delete is a write operation targeting a specific user-named resource (DEC-168: 404 on a targeted delete is a user error requiring the Jira body context); download metadata fetch is a read operation where the canonical string is sufficient and the Jira body would add no actionable information.

**Match-by-ID invariant** (JRACLOUD-96384 + JRACLOUD-78388, both confirmed in research §6): attachment operations MUST identify attachments by their numeric `id`, not by `filename`. Multiple attachments with the same `filename` on one issue are legal in Jira (JRACLOUD-96384); filename-based matching is ambiguous and unreliable. There is also no reliable REST mapping from a comment to the attachments it contains (JRACLOUD-78388). `--id <AID>` is the sole selector for single-file download operations.

**Error path taxonomy**:

| Condition | Exit code | stderr |
|-----------|-----------|--------|
| Invalid `--id` AID (non-numeric, e.g. path-traversal) | 64 | `"invalid attachment id: '<VALUE>' (must be numeric)"` (no HTTP) |
| KEY 404 (batch paths only — `--id` does not server-verify KEY per BC-2.7.007) | 64 | `"Issue <KEY> not found or not accessible."` |
| KEY 403 (batch paths only — `--all`/`--newest`) | 1 | `"Permission denied: cannot access issue <KEY>."` |
| AID 404 from metadata endpoint (`GET /attachment/{id}`) | 64 | `"Attachment <AID> not found or not accessible."` |
| AID 403 from metadata endpoint (`GET /attachment/{id}`) | 1 | `"Permission denied: cannot access attachment <AID>."` |
| KEY or AID 401 | 2 | Not authenticated + `jr auth login` hint |
| KEY or AID 5xx | 1 | `API error (<N>)` (single mode; batch mode: per-file fail-soft per BC-2.7.008) |
| Network error | 1 | Connectivity hint (single mode; batch mode: per-file fail-soft per BC-2.7.008) |
| Disk full (ENOSPC) writing to temp file | 1 | `"Disk full: not enough space to write <path>"` (single mode; batch mode: per-file fail-soft per BC-2.7.008) |
| Permission denied on target directory (EACCES / read-only FS) | 1 | `"Permission denied: cannot write to <dir>"` (single mode; batch mode: per-file fail-soft per BC-2.7.008) |
| Target directory not writable (other OS write error) | 1 | OS error message surfaced on stderr (single mode; batch mode: per-file fail-soft per BC-2.7.008) |

**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design; research §6 JRACLOUD-96384/-78388 VERIFIED); P21-006 (KEY-404 batch-paths-only annotation — `--id` does not server-verify KEY per BC-2.7.007); P22-003 (body prose "Unknown issue key" sentence prepended with batch-only caveat: batch paths only — `--all`/`--newest`; `--id` does not server-verify KEY per BC-2.7.007); P26-001 (KEY-403 batch-paths-only row added to error table — mirrors BC-2.7.006 P15-005 row; error-taxonomy row 95 issue-GET sub-variant citation re-pointed to BC-2.7.012)

---

## Error Path Summary

All issue-read errors follow the universal pattern (BC-X.3.012):
- Network drop → exit 1 + `"Could not reach <host>; check your connection"`
- 401 → exit 2 + `Not authenticated` + `jr auth login`
- 5xx → exit 1 + `API error (5xx)` + friendly message
- Never: `panic` in stderr

Pass 3 sources: `tests/issue_list_errors.rs`, `tests/issue_view_errors.rs`, `tests/comments.rs`

## Total BCs in this file: 64 individually-bodied (cumulative 106 incl. range-collapsed; see BC-INDEX.md)