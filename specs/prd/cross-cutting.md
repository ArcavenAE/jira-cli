---
context: bc-x
title: "Cross-cutting (HTTP client, Runtime, Users, Teams, Worklogs, Projects, Queues, JQL, Partial-match, JSM Request Types, CI Guards)"
total_bcs: 148   # cumulative claim (incl. range-collapsed); definitional_count below is individually-bodied headings
definitional_count: 82   # count of `#### BC-` headings in this file
last_updated: 2026-07-06
source_pass: 3
trace: |
  - L2: .factory/specs/domain-spec/cross-cutting.md
  - Source broad: .factory/semport/jira-cli/jira-cli-pass-3-behavioral-contracts.md §2.6-2.15
  - Source R1: .factory/semport/jira-cli/jira-cli-pass-3-deep-r1.md §3.6-3.8
  - Source R4: .factory/semport/jira-cli/jira-cli-pass-3-deep-r4.md §3.2-3.4
  - F2 addition (2026-05-18): BC-X.12.001..008 — JSM request type discovery (issue #288)
  - F2 addition (2026-05-19): BC-X.8.006..007 — auth-conditional 401 hints on require_service_desk path (cache miss only): Basic-auth (is_oauth_auth==false) → API-token hint with InsufficientScope rewrite; OAuth (is_oauth_auth==true) → read:jira-work + read:servicedesk-request hint (issue #384; corrected model: gate is is_oauth_auth() alone)
  - S-QUEUE-BC-1 addition (2026-06-08): BC-X.8.008..009 — document-as-is BCs for jr queue list and jr queue view (queue traceability orphan closure)
  - DEAD-CITATION-CI F2 addition (2026-06-19): BC-X.13.001..003 — CLAUDE.md dead-citation CI guard (citation path-existence, glob/suffix/punct exclusion, ALL .factory/ excluded — re-scoped F2 Iteration 2)
  - F2 pass-5 precision fix (2026-06-27): BC-X.10.001 Trace — removed false `expect(1)` pin claim; `resolve_queue_single_substring_is_ambiguous` uses absence-of-mount (zero `.expect(` calls confirmed), not `expect(1)`; no behavioral or count change
  - CITATION-GUARDS Story B F2 addition (2026-07-05): BC-X.13.004..006 — Guard 1 bc-*.md Trace/Source file::symbol citation guard (S-BC-CITATION-GUARD-1, story #102)
  - DEC-154 Option A spec update (2026-07-06): BC-X.13.005 — extend v1 grammar (3 branches: ::tests, ::tests::testfn, standalone CamelCase); space-tolerant two-pass extraction (F-B2-02); BC-X.13.004 — FLOOR recalibration N=326, FLOOR=244; BC-X.13.006 — fixture count 7→10 (A–K)
---

# BC-X — Cross-cutting

148 behavioral contracts covering: HTTP client (X.1), Pagination (X.2), Error handling (X.3),
Rate limiting (X.4), Worklogs & duration (X.5), Teams (X.6), Users (X.7), Projects & Queues (X.8),
JQL utilities (X.9), Partial-match (X.10), Build-time (X.11), JSM Request Types (X.12),
CI Guards (X.13).

---

## Subdomains

### X.1 HTTP Client (JiraClient)

#### BC-X.1.001: Auth header injected on every API call via `req.header("Authorization", &self.auth_header)` at line 195

**Confidence**: HIGH
**Source**: `tests/api_client.rs:14-40`; `src/api/client.rs:195`
**Subject**: HTTP client
**Behavior**: Header value is verbatim auth string (e.g., `Basic dGVzdEBleGFtcGxlLmNvbTpteS1hcGktdG9rZW4=`). Pinned by wiremock `header(...)` matcher. Injected on every retry attempt including the first.
**Trace**: Pass 3 BC-1410-R (R1); BC-1082 (R4)

---

#### BC-X.1.002: `client.send(request)` retries 429 transparently; returns parsed response on 200

**Confidence**: HIGH
**Source**: `tests/api_client.rs:42-70`
**Behavior**: 429-then-200 → caller sees 200 (typed T). Retry is transparent.
**Trace**: Pass 3 BC-1402; BC-1083 (R4)

---

#### BC-X.1.003: `client.send(request)` on exhausted 429 raises `JrError::ApiError{status: 429}` via `parse_error`

**Confidence**: HIGH
**Source**: `src/api/client.rs:184-253`
**Behavior**: After MAX_RETRIES=3 (4 total calls), the last 429 response is parsed via `parse_error` → `JrError::ApiError`. Distinct from `send_raw` behavior (which returns 429, not raises).
**Trace**: Pass 3 BC-1402-R (R1)

---

#### BC-X.1.004: `client.send(request)` requires `RequestBuilder::try_clone()` to succeed; non-cloneable bodies panic

**Confidence**: HIGH
**Source**: `src/api/client.rs:191-194`
**Behavior**: `request.try_clone().expect("request should be cloneable (JSON body)")`. Streaming-body refactor would panic.
**Trace**: Pass 3 BC-1402a (R1)

---

#### BC-X.1.005: `client.send_raw(request)` returns 429 to caller (NOT raises) after MAX_RETRIES=3; `expect(4)` pin

**Confidence**: HIGH
**Source**: `tests/api_client.rs:424-444`
**Subject**: HTTP client
**Behavior**: 4 total calls (initial + 3 retries). FINAL response IS 429. `send_raw` returns it, not raises.
**Trace**: Pass 3 BC-1401; BC-1092 (R4)

---

#### BC-X.1.006: `send_raw` 429-then-200 retries identically to `send`; caller sees 200

**Confidence**: HIGH
**Source**: `tests/api_client.rs:394-422`
**Trace**: Pass 3 BC-1091 (R4)

---

#### BC-X.1.007: `send_raw` preserves 404 as response (NOT converted to Err); used by `jr api` raw passthrough

**Confidence**: HIGH
**Source**: `tests/api_client.rs:367-392`
**Subject**: HTTP client
**Behavior**: 404 response returned to caller with body intact. Error-conversion happens in `get`/`post`/etc., NOT `send_raw`.
**Trace**: Pass 3 BC-1409-R (R1); BC-1090 (R4)

---

#### BC-X.1.008: `send_raw` non-cloneable body returns `anyhow::Error` with explicit message (NOT panic)

**Confidence**: HIGH
**Source**: `src/api/client.rs:267-272`
**Behavior**: `req.try_clone().ok_or_else(|| anyhow::anyhow!("request cannot be retried..."))`. More defensive than `send`.
**Trace**: Pass 3 BC-1402b (R1)

---

#### BC-X.1.009: 429-exhausted warning always emitted to stderr (not verbose-gated)

**Confidence**: HIGH
**Source**: `src/api/client.rs:233-237, 309-313`
**Behavior**: `"warning: rate limited by Jira — gave up after 3 retries. Wait a moment and try again."` — unconditional. Same from both `send` and `send_raw`.
**Trace**: Pass 3 BC-1404; BC-1404-R (R1)

---

#### BC-X.1.010: All HTTP methods (get, post, put, delete, send_raw) inject auth header — no bypass

**Confidence**: HIGH
**Source**: `src/api/client.rs` (R4 §4.1 verification)
**Behavior**: 9 high-level methods use `self.send(request)` (auth at line 195). 2 raw methods use `self.client.execute(req)` after `self.request()` injects header. No method bypasses.
**Trace**: Pass 4 R4 §4.1

---

### X.2 Pagination

#### BC-X.2.001: Offset pagination: `startAt`/`maxResults` + `total` for issue comments, projects, worklogs

**Confidence**: HIGH
**Source**: `src/api/pagination.rs`; unit test suite (pagination module); `tests/comments.rs:104-158`
**Trace**: Pass 3 BC-1406, BC-1407-R (R1)

---

#### BC-X.2.002: Cursor pagination via `nextPageToken` for JQL search

**Confidence**: HIGH
**Source**: `src/api/pagination.rs::CursorPage`; `tests/issue_commands.rs`
**Trace**: Pass 3 BC-1406

---

#### BC-X.2.003: ServiceDeskPage pagination (JSM service desks)

**Confidence**: HIGH
**Source**: `src/api/pagination.rs::ServiceDeskPage`
**Trace**: Pass 3 BC-1406

---

#### BC-X.2.004: `AssetsPage::is_last` accepts bool or string-encoded bool (custom deserializer)

**Confidence**: HIGH
**Source**: `src/api/pagination.rs::AssetsPage`
**Trace**: Pass 3 BC-317 (R1)

---

#### BC-X.2.005: User pagination advances `startAt` by REQUESTED `maxResults` (NOT by returned count)

**Confidence**: HIGH
**Source**: `tests/user_pagination.rs:202-247`; `tests/all_flag_behavior.rs:155-208`
**Subject**: Pagination
**Behavior**: Page 1 returns 35 users; page 2 startAt=100 (advanced by requested 100, NOT by 35). This is a deliberate workaround for JRACLOUD-71293.
**Trace**: Pass 3 BC-702; BC-1119 (R4)

---

#### BC-X.2.006: `USER_PAGINATION_SAFETY_CAP = 1500` (15 pages × 100); emits stderr `"hit pagination safety cap"`; exits 0

**Confidence**: HIGH
**Source**: `tests/user_pagination.rs:459-520`
**Behavior**: Safety cap prevents infinite loops. Warning is observable; exit 0.
**Trace**: Pass 3 BC-1124, BC-1125 (R4)

---

### X.3 Error Handling (universal rules)

#### BC-X.3.001: Network drop → `Could not reach <host>; check your connection` exit 1

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs:320-360`; `tests/issue_view_errors.rs:102-134`; `tests/assets_errors.rs:115-153`
**Behavior**: Connect-refused (port 1) → `JrError::NetworkError(host)`.
**Trace**: Pass 3 BC-1206

---

#### BC-X.3.002: 401 → `Not authenticated` + `jr auth login` exit 2 (universal across all subcommands)

**Confidence**: HIGH
**Source**: 6+ test files; `tests/issue_list_errors.rs`, `tests/issue_view_errors.rs`, `tests/comments.rs`, `tests/worklog_commands.rs`, `tests/team_commands.rs`, `tests/assets_errors.rs`
**Trace**: Pass 3 BC-1207

> **[UPDATED 2026-05-19 issue #384]** JSM auth-conditional footnote: For JSM dispatch paths (both `handle_jsm_create` and `require_service_desk`), 401 behavior is auth-conditional — see BC-3.8.014 / BC-X.8.006 (Basic-auth: `is_oauth_auth() == false` → API-token-expiry hint; any `InsufficientScope` is REWRITTEN to `NotAuthenticated` before surfacing) and BC-3.8.015 / BC-X.8.007 (OAuth: `is_oauth_auth() == true` → existing error-variant behavior preserved). The gate is `is_oauth_auth()` alone, not error variant. The Base contract BC-X.3.002 applies to all non-JSM paths and to any JSM path that does not trigger the auth-conditional map_err.

---

#### BC-X.3.003: 5xx → `API error (<status>)` + extract_error_message(body) + exit 1

**Confidence**: HIGH
**Source**: All `*_errors.rs` files; assert `stderr.contains("API error (500)")`
**Trace**: Pass 3 BC-1210

---

#### BC-X.3.004: 400 with field-specific Jira error → stderr formatted as `field: message` (sorted alphabetically)

**Confidence**: HIGH
**Source**: `tests/issue_resolution.rs:124-158`
**Trace**: Pass 3 BC-1211

---

#### BC-X.3.005: 401 + scope-mismatch (case-insensitive) → InsufficientScope with 5 substrings; 403 with substring NOT dispatched

**Confidence**: HIGH
**Source**: `tests/api_client.rs:99-255`
**Trace**: Pass 3 BC-015..018; BC-1085..1088 (R4)

---

#### BC-X.3.006: Ctrl+C exits 130 with `Interrupted` handling

**Confidence**: MEDIUM
**Source**: `src/main.rs:264`
**Trace**: Pass 3 BC-1209

---

#### BC-X.3.007: Error messages must suggest next step (CLAUDE.md convention, universal)

**Confidence**: HIGH
**Source**: Multiple integration tests asserting remediation strings
**Trace**: Pass 3 BC-1212

---

#### BC-X.3.008: stderr must NEVER contain `panic` (universal)

**Confidence**: HIGH
**Source**: 16+ negative assertion tests
**Trace**: Pass 3 BC-1205

---

### X.4 Rate Limiting

#### BC-X.4.001: MAX_RETRIES = 3 (initial + 3 = 4 total calls); `expect(4)` pin

**Confidence**: HIGH
**Source**: `tests/api_client.rs:424-444`; `src/api/client.rs:265-320`
**Trace**: Pass 3 BC-1401-R (R1)

---

#### BC-X.4.002: `Retry-After` header parsed as u64 INTEGER ONLY — HTTP-date format NOT supported

**Confidence**: HIGH
**Source**: `src/api/rate_limit.rs:14-18`; unit test suite (rate_limit module)
**Subject**: Rate limiting
**Behavior**: `header.parse::<u64>()`. HTTP-date format → `None` → falls back to `DEFAULT_RETRY_SECS = 1`. No upper bound — `Retry-After: 86400` is honored as 24h (NFR-R-NEW-1, LOW). CONV-ABS-001 correction.
**Trace**: Pass 3 BC-1403-R (R1)

---

 > [BC-X.4.003..008 are range-collapsed in BC-INDEX.md; not individually bodied]

#### BC-X.4.009: `MAX_RETRY_AFTER_SECS = 60` cap — Retry-After exceeding 60s prints warning and aborts retry

**Confidence**: HIGH (PROPOSED — FIX-IN-PHASE-3)
**Source**: `src/api/rate_limit.rs` (proposed addition)
**Subject**: Rate limiting
**Behavior**: When `Retry-After` header value is a valid u64 AND exceeds `MAX_RETRY_AFTER_SECS = 60`: (1) print to stderr `"warning: Retry-After <NNN>s exceeds 60s; aborting retry, run jr again later"` and (2) exit non-zero (the retry loop does NOT sleep and retry; it returns the 429 response). Values ≤ 60s continue to be honored as before.
**Related**: NFR-R-NEW-1 (cross-link); H-027 (holdout that pins current no-upper-bound behavior — will need updating when this fix lands).
**Note**: This BC describes the PROPOSED fixed behavior, not current behavior. Currently BC-X.4.002 documents no upper bound. This BC is the Phase 3 target state. H-027 documents the current gap.
**Trace**: ADV-P1-029; NFR-R-NEW-1

---

### X.5 Worklogs & Duration

#### BC-X.5.001: `client.add_worklog(key, seconds, message)` POSTs `/issue/<key>/worklog`; returns Worklog; accepts 201

**Confidence**: HIGH
**Source**: `tests/worklog_commands.rs:8-26`
**Trace**: Pass 3 BC-501

---

#### BC-X.5.002: `client.list_worklogs(key)` paginates via `/issue/<key>/worklog` [MUST-FIX: NFR-R-A — HIGH]

**Confidence**: HIGH
**Source**: `src/api/jira/worklogs.rs:25-30` (BUG SITE)

> **MUST-FIX (HIGH — NFR-R-A):** Current code fetches ONE `OffsetPage<Worklog>` and discards
> `total`/`start_at`/`max_results`. Issues with >50 worklogs silently truncate. This contract
> describes the FIXED behavior.

**Spec contract (fixed behavior):**
`list_worklogs` MUST paginate in a loop until `page.total <= page.start_at + page.items().len()`. All pages concatenated and returned to caller. No silent truncation.

**Holdout:** H-045 — `list_worklogs` pagination — all pages returned.
**Trace**: Pass 3 BC-502; NFR-R-A; Pass 4 R4 §1.1

---

#### BC-X.5.003: `worklog list` 5xx → exit 1 + `API error (500)`

**Confidence**: HIGH
**Source**: `tests/worklog_commands.rs:55-93`
**Trace**: Pass 3 BC-503

---

#### BC-X.5.004: `worklog list` 401 → exit 2 + `Not authenticated` + `jr auth login`

**Confidence**: HIGH
**Source**: `tests/worklog_commands.rs:95-120`
**Trace**: Pass 3 BC-504

---

#### BC-X.5.005: `parse_duration_validate("1w2d3h30m")` accepts combined units (validator — production path only)

**Confidence**: HIGH
**Source**: `src/duration.rs::tests::test_complex`
**Subject**: Duration
**Behavior**: Distinguished from JQL `validate_duration` which rejects combined units. Used for worklog add. `parse_duration_validate("1w2d3h30m")` is the sole production path. Note: the 3-arg `parse_duration(s, hours_per_day, days_per_week)` calculator was deleted in S-3.10 — it had no production caller after S-2.06 v2.0.0 and was retained only for the `format_duration` round-trip proptest, which has been rewritten to not depend on it.
**Trace**: Pass 3 BC-505

---

#### BC-X.5.006: `parse_duration` is case-insensitive (input lowercased first)

**Confidence**: HIGH
**Source**: `src/duration.rs:6`
**Trace**: Pass 3 BC-506

---

#### BC-X.5.007: `parse_duration("")` errors `Duration cannot be empty`

**Confidence**: HIGH
**Source**: `src/duration.rs:7-9`
**Trace**: Pass 3 BC-507

---

#### BC-X.5.008: `parse_duration("5")` errors `Number without unit`

**Confidence**: HIGH
**Source**: `src/duration.rs:38-42`
**Trace**: Pass 3 BC-508

---

#### BC-X.5.009: `worklog add` forwards the user-supplied duration string to Jira as `timeSpent`

**Confidence**: HIGH
**Source**: `src/cli/worklog.rs::handle_add` + `src/api/jira/worklogs.rs::add_worklog` + `src/duration.rs::parse_duration_validate`
**Subject**: Duration
**Behavior**: `worklog add` forwards the user-supplied duration string to Jira as `timeSpent`. Jira's server applies its configured `workingHoursPerDay`/`workingDaysPerWeek`. `parse_duration_validate` is a client-side syntax validator only (no arithmetic). Resolves NFR-R-C silent-wrong-answer on customized instances. RESOLVED via S-2.06 v2.0.0 (PR #308 / c8f15d8 / DEC-010 / Option 1 pivot).
**Trace**: Pass 3 BC-1014 (R4)

---

#### BC-X.5.010: Duration proptest: `valid_single_units_always_parse`; `combined_units_always_parse`; `garbage_input_never_panics`; `format_roundtrip` (sub-day)

**Confidence**: HIGH
**Source**: `src/duration.rs:128-157`
**Trace**: Pass 3 BC-1099..BC-1102 (R4)

---

### X.6 Teams

#### BC-X.6.001: `client.get_org_metadata(hostname)` POSTs GraphQL `tenantContexts` query to `/gateway/api/graphql`

**Confidence**: HIGH
**Source**: `tests/team_commands.rs:8-26`
**Subject**: Teams
**Behavior**: Returns `TenantContext { org_id, cloud_id }` (ADR-0005).
**Trace**: Pass 3 BC-601

---

#### BC-X.6.002: `client.list_teams(orgId)` GETs `/gateway/api/public/teams/v1/org/<orgId>/teams`

**Confidence**: HIGH
**Source**: `tests/team_commands.rs:28-46`
**Trace**: Pass 3 BC-602

---

#### BC-X.6.003: `team list` 5xx → exit 1; 401 → exit 2; standard error paths

**Confidence**: HIGH
**Source**: `tests/team_commands.rs:62-`
**Trace**: Pass 3 BC-603, BC-604

---

#### BC-X.6.004: `team list` cache-first (7d TTL); `--refresh` forces re-fetch

**Confidence**: MEDIUM
**Source**: `src/cache.rs`
**Trace**: Pass 3 BC-605

---

### X.7 Users

#### BC-X.7.001: `user search Q` GETs `/rest/api/3/user/search?query=Q`

**Confidence**: HIGH
**Source**: `tests/user_commands.rs`; `tests/all_flag_behavior.rs:155-208`
**Trace**: Pass 3 BC-701

---

#### BC-X.7.002: `user list --project P` calls `/rest/api/3/user/assignable/multiProjectSearch?projectKeys=P`

**Confidence**: HIGH
**Source**: `tests/all_flag_behavior.rs:260-`
**Trace**: Pass 3 BC-704

---

#### BC-X.7.003: `user list` (default, no --all) uses single-call legacy path; no startAt/maxResults params

**Confidence**: HIGH
**Source**: `tests/all_flag_behavior.rs:271-275`
**Behavior**: `query_param_is_missing("startAt")` assertion.
**Trace**: Pass 3 BC-705

---

#### BC-X.7.004: Duplicate display names + `--no-input` → exit non-zero; stderr shows emails + accountIds + duplicate name

**Confidence**: HIGH
**Source**: `tests/duplicate_user_disambiguation.rs:21-275`
**Subject**: Users
**Behavior**: Three users "John Smith" x2 + "John Smithson" → disambiguation shows only the two Smiths (not Smithson).
**Trace**: Pass 3 BC-706..BC-708

---

#### BC-X.7.005: `user view <id>` → 404 → friendly `"User with accountId '<id>' not found"` exit 64

**Confidence**: HIGH
**Source**: `tests/user_commands.rs` BC-1132i
**Trace**: Pass 3 BC-1132i (R4)

---

#### BC-X.7.006: `user search --all` advances startAt by REQUESTED maxResults (JRACLOUD-71293 workaround)

**Confidence**: HIGH
**Source**: `tests/user_pagination.rs:202-247`
**Trace**: Pass 3 BC-1119 (R4)

---

### X.8 Projects & Queues

#### BC-X.8.001: `project_exists(key)` → true on 200; false on 404

**Confidence**: HIGH
**Source**: `tests/input_validation.rs:9-42`
**Trace**: Pass 3 BC-801

---

#### BC-X.8.002: `get_project_statuses(key)` → 404 → `JrError::ApiError{status: 404}`

**Confidence**: HIGH
**Source**: `tests/input_validation.rs:233-253`
**Trace**: Pass 3 BC-802

---

#### BC-X.8.003: `get_or_fetch_project_meta(client, key)` caches by project key with 7d TTL

**Confidence**: HIGH
**Source**: `tests/project_meta.rs:24-67`
**Behavior**: Service-desk project → `service_desk_id = Some("15")`. Software project → `None`.
**Trace**: Pass 3 BC-804

---

#### BC-X.8.004: `require_service_desk` errors for software project: "Jira Software project" + queue-command-specific error message

**Confidence**: HIGH
**Source**: `tests/project_meta.rs:99-126`
**Trace**: Pass 3 BC-805

> **[UPDATED 2026-05-18 issue #288]** The literal "Queue commands require…" error string is removed from `src/api/jsm/servicedesks.rs::require_service_desk` and replaced by a caller-supplied context label. BC-X.8.004 now defines the queue-command-specific message only: 'Project "<KEY>" is a <type> project. Queue commands (`jr queue`) require a Jira Service Management project. Run "jr project list" to find a JSM project.' For the `jr issue create --request-type` call site, the error message is: 'Project "<KEY>" is a <type> project. `--request-type` requires a Jira Service Management project. Run "jr project list" to find a JSM project.' (see BC-3.8.002). For `jr requesttype list/fields` call sites: 'Project "<KEY>" is a <type> project. `jr requesttype` commands require a Jira Service Management project. Run "jr project list" to find a JSM project.' (see BC-X.12.003). Previous version of this BC required only the common prefix "Jira Software project" — the call-site-specific suffix is now part of the contract.
>
> **Implementation contract**: The call-site label is passed to `require_service_desk(client, project_key, call_site_label)` as a `&'static str` parameter. The function MUST NOT hard-code per-call-site branches; the message is formatted with the supplied label. Acceptable `call_site_label` values: `"queue commands"`, `"--request-type"`, `"jr requesttype commands"` (or equivalent constants in the calling modules). The implementer may use an enum if it strengthens type safety, but the boundary contract at the function signature is `&'static str`.

---

#### BC-X.8.005: `list_projects` paginates via `startAt`; filter via `typeKey` query param

**Confidence**: HIGH
**Source**: `tests/project_commands.rs:1-323`
**Trace**: Pass 3 BC-1133d, BC-1133e (R4)

---

#### BC-X.8.006: Basic-auth 401 from `require_service_desk` (cache miss) → API-token-expiry hint; no OAuth-scope language

**Confidence**: HIGH
**Subject**: X.8 Projects & Queues (JSM auth-conditional error hint — require_service_desk path)
**Behavior**: `require_service_desk` in `src/api/jsm/servicedesks.rs` calls `get_or_fetch_project_meta` which is cache-first (7-day TTL). The 401 hint described here fires ONLY on a cache MISS — when live HTTP calls are actually issued. **Trigger clarification (C-01):** `get_or_fetch_project_meta` issues TWO live GETs on a cache miss for a `service_desk`-type project: (1) `GET /rest/api/3/project/{key}` to fetch project details, and (2) `GET /rest/servicedeskapi/servicedesk` (via `client.list_service_desks()`) to match service desk by `projectId`. The new `map_err` wraps the entire `get_or_fetch_project_meta(...)` future, so it catches a 401 from EITHER GET. Both are JSM-read operations; the API-token-expiry hint applies uniformly to both. **User-facing behavioral boundary**: a warm `(profile, project_key)` project-meta cache entry suppresses this hint at the `require_service_desk` step; the 401 then surfaces at the next live HTTP call (e.g., the JSM POST → BC-3.8.014/015). Any test exercising this BC MUST force a cache miss (e.g., by not pre-populating the project-meta cache).

When a live GET inside `get_or_fetch_project_meta` returns 401 AND the active auth scheme is Basic (i.e., `JiraClient::is_oauth_auth()` returns `false`), the implementation MUST **introduce a NEW `map_err`** on the `get_or_fetch_project_meta(...)` call inside `require_service_desk` (line 117 of `src/api/jsm/servicedesks.rs`). The current code at line 117 is `let meta = get_or_fetch_project_meta(client, project_key).await?;` — the `?` propagates raw with no hint. The new `map_err` must surface an API-token-expiry hint. The gate is `is_oauth_auth() == false` ALONE — the incoming error variant is irrelevant.

**Dual exit codes on `require_service_desk`:** After this BC is implemented, `require_service_desk` has TWO failure exit codes: exit 64 (`JrError::UserError`, the existing non-JSM-project path, BC-X.8.004) and exit 2 (`JrError::NotAuthenticated`, the new 401 path). The implementer MUST NOT normalize them — they are distinct error categories.

Implementation: the new `map_err` must REWRITE any incoming error (whether `JrError::NotAuthenticated` or `JrError::InsufficientScope`) to `JrError::NotAuthenticated { hint: API_TOKEN_EXPIRY_HINT }`. The shared constant `API_TOKEN_EXPIRY_HINT` (defined once in **`src/error.rs`** — NOT in `src/api/client.rs` or any new module) is referenced identically by both the `handle_jsm_create` site (BC-3.8.014) and this `require_service_desk` site. `src/error.rs` is imported by both the `api` and `cli` layers with no layering inversion. This prevents hint-text divergence between the two call sites and adds no new modules.

The `hint` field value (stored in `JrError::NotAuthenticated { hint }`) MUST be identical to BC-3.8.014's hint (shared constant). The rendered stderr line prepends `"Not authenticated. "`; the `hint` field contains only the body text. Tests MUST assert via `contains`, not `==`. The hint field value is:

<!-- This block is duplicated from the CANONICAL copy in prd-delta-384.md §BC-3.8.014 — all copies MUST be updated together; cf. the JR_* doc-fallout pattern in CLAUDE.md (adversary-pass-4 F-04). -->
```
Your API token may be expired or revoked. Regenerate it at
https://id.atlassian.com/manage-profile/security/api-tokens
then run `jr auth login` to re-store the credentials.
```

This hint MUST NOT contain any OAuth-scope language. The hint MUST NOT say `jr auth refresh` (meaningless for Basic auth). The `require_service_desk` function is shared across all JSM callers: `handle_jsm_create` (`jr issue create --request-type`), `jr queue list/view`, and `jr requesttype list/fields`. All callers benefit from this contract.

Gate: `client.is_oauth_auth() == false` at the new `map_err` site on the `get_or_fetch_project_meta` call inside `require_service_desk` (per orchestrator decision 1: the contract is on `require_service_desk` itself, not on individual callers).

**Inputs**: Active auth = Basic; `GET /rest/api/3/project/{key}` returns HTTP 401 (any body shape); project-meta cache is empty (cache miss — the live GET is issued).
**Outputs/Effects**: exit 2; stderr contains the API-token-expiry hint (assert via `contains`); stdout empty; any `InsufficientScope` from the 401 is rewritten to `NotAuthenticated` before surfacing.
**Errors**: None beyond the 401 itself — this BC IS the error-handling contract.
**Setup** (for `test_require_service_desk_basic_auth_401_surfaces_api_token_hint`):
0. **Isolated `XDG_CACHE_HOME` tempdir** (e.g., `tempfile::tempdir()`) — forces a project-meta cache miss so the live GET inside `get_or_fetch_project_meta` actually fires. A warm cache would bypass the HTTP call and the 401 would never be seen.
1. Auth fixture: `JR_AUTH_HEADER=Basic <b64>` (capital B, single space — any valid Base64 value; e.g., `Basic dGVzdDp0ZXN0`).
2. Mount `GET /rest/api/3/project/{KEY}` to return HTTP 401 with a verbatim generic-expiry body: `{"errorMessages": ["The access token provided is expired, revoked, malformed, or invalid for other reasons."], "errors": {}}`. This is the **canonical pinned 401 path** for this named test — the project GET is triggered first by `get_or_fetch_project_meta` on a cache miss. **URL-encoding note (adversary-pass-8 LOW):** the project key is URL-encoded by `get_or_fetch_project_meta` via `urlencoding::encode`, so a wiremock `path()` matcher is exact for plain-alphanumeric keys (the named test uses `HELP`); a project key containing special characters would require an encoded mock path.
3. The second GET arm (`list_service_desks()` → `GET /rest/servicedeskapi/servicedesk`) is covered **structurally** because the `map_err` wraps the entire `get_or_fetch_project_meta` future — it is NOT separately pinned by this test. A dedicated test for the service-desk-list 401 arm is not required; the `map_err` wraps both GETs uniformly. The canonical-vs-structural distinction is explicit: this test pins the project-GET arm; the service-desk-list arm is covered by the shared `map_err` on `get_or_fetch_project_meta`.
4. Drive via: `jr issue create --project <KEY> --request-type <NAME> --summary "..." --no-input` (which calls `require_service_desk` first, triggering the 401 before reaching the JSM POST).
**Trace**: `tests/issue_create_jsm.rs` (integration test `test_require_service_desk_basic_auth_401_surfaces_api_token_hint` — NEW; Basic-auth fixture, cache miss forced; asserts stderr `contains` "expired or revoked" and `contains` `id.atlassian.com/manage-profile/security/api-tokens` and `contains` `jr auth login`; asserts stderr does NOT contain `write:servicedesk-request`). The new `map_err` is placed inside `require_service_desk` (shared by `jr issue create`, `jr queue`, `jr requesttype`), so all three callers structurally benefit; this test pins the `create` caller path; existing `queue`/`requesttype` integration tests cover regression for those callers.
**Source**: Issue #384 F2; O-08-05 CONFIRMED in `.factory/research/issue-288-pr4-deferred-validation.md` (lines 342-381); `src/api/client.rs:696-704` (body check before Bearer guard — same issue as BC-3.8.014); `src/api/jsm/servicedesks.rs:52-85` (get_or_fetch_project_meta issues TWO live GETs on a service_desk-type cache miss: GET /rest/api/3/project/{key} AND GET /rest/servicedeskapi/servicedesk; the new map_err must wrap the entire future, catching 401 from either GET); `src/api/jsm/servicedesks.rs:117` (raw `?` propagation — no existing map_err on get_or_fetch_project_meta call; the new map_err MUST be introduced here).
**Confidence**: HIGH

[NEW 2026-05-19 issue #384 F2] Closes O-08-05: `require_service_desk` 401 on the project-GET/service-desk-list path had no JSM-specific hint. The auth-conditional `map_err` is placed inside `require_service_desk` itself (not at call sites), so all three JSM caller paths benefit. Gate is `is_oauth_auth() == false` alone; map_err must rewrite both `NotAuthenticated` and `InsufficientScope` to the API-token hint (shared constant with BC-3.8.014 site).

[REVISED 2026-05-19 issue #384 F2 adversary correction] Previous version incorrectly stated `src/api/client.rs:711-722 (Basic-auth 401 → NotAuthenticated)` as the explanation. This is incomplete: a Basic-auth 401 with a "scope does not match" body lands in `InsufficientScope` (body check at line 696 fires before Bearer guard at line 718). The corrected model: gate is `is_oauth_auth() == false` alone; `map_err` rewrites any incoming variant.

[REVISED 2026-05-19 issue #384 F2 adversary-pass-2 C-01/H-01/H-04/M-02/M-03] (C-01) Changed "map_err inside require_service_desk" to "MUST introduce a NEW map_err" — no existing map_err exists at line 117; the implementation must add one. (H-01) Dual exit codes documented explicitly: exit 64 (UserError, non-JSM) vs exit 2 (NotAuthenticated, 401). (M-02) Cache-warm suppression stated as user-facing behavioral boundary, not just a test-setup note. (M-03) API_TOKEN_EXPIRY_HINT constant location pinned to src/error.rs.

[REVISED 2026-05-19 issue #384 F2 adversary-pass-3 C-01/H-05] (C-01) Trigger broadened: `get_or_fetch_project_meta` issues TWO live GETs for service_desk-type projects — the project GET AND the service-desk list GET. The new map_err catches 401 from either. (H-05) Named acceptance test function added: `test_require_service_desk_basic_auth_401_surfaces_api_token_hint`; cross-caller coverage clarified (map_err is in require_service_desk; test pins create path; queue/requesttype existing tests cover regression).

---

#### BC-X.8.007: OAuth 401 from `require_service_desk` (cache miss) → read-side scope hint (`read:jira-work` + `read:servicedesk-request`)

**Confidence**: HIGH
**Subject**: X.8 Projects & Queues (JSM auth-conditional error hint — require_service_desk path)
**Behavior**: `require_service_desk` calls `get_or_fetch_project_meta` which is cache-first (7-day TTL). This BC fires ONLY on a cache MISS — when live HTTP calls are actually issued. **Trigger clarification (C-01):** `get_or_fetch_project_meta` issues TWO live GETs on a cache miss for a `service_desk`-type project: (1) `GET /rest/api/3/project/{key}` to fetch project details, and (2) `GET /rest/servicedeskapi/servicedesk` (via `client.list_service_desks()`) to match service desk by `projectId`. The new `map_err` wraps the entire `get_or_fetch_project_meta(...)` future, so it catches a 401 from EITHER GET. Both are JSM-read operations; the read-side scope hint applies uniformly to both. **User-facing behavioral boundary**: a warm `(profile, project_key)` project-meta cache entry suppresses this hint at the `require_service_desk` step; the 401 then surfaces at the next live HTTP call (e.g., the JSM POST → BC-3.8.014/015). Any test exercising this BC MUST force a cache miss.

When a live GET inside `get_or_fetch_project_meta` returns 401 AND the active auth scheme is OAuth/Bearer (i.e., `JiraClient::is_oauth_auth()` returns `true`), the NEW `map_err` introduced inside `require_service_desk` (see BC-X.8.006 — same new `map_err` on line 117) MUST surface a read-side scope hint for BOTH sub-cases, via `JrError::NotAuthenticated { hint }`. The gate is `is_oauth_auth() == true` ALONE.

**Dual exit codes on `require_service_desk`:** After BC-X.8.006/007 are implemented, `require_service_desk` has TWO failure exit codes: exit 64 (`JrError::UserError`, the existing non-JSM-project path, BC-X.8.004) and exit 2 (`JrError::NotAuthenticated`, the new 401 path from this BC and BC-X.8.006). The implementer MUST NOT normalize them — they are distinct error categories.

For both sub-cases of OAuth 401, the implementation rewrites to `JrError::NotAuthenticated { hint }` (NOT `InsufficientScope` — the `InsufficientScope` Display is a fixed template purpose-built for the issue-#185 POST scenario; for a read GET it produces irrelevant POST-specific noise). Both arms of the `map_err` emit the SAME single canonical hint string — there is ONE pinnable hint text, not two. This makes the acceptance test unambiguous: both the `InsufficientScope` arm and the `NotAuthenticated` arm produce identical output.

Rationale for hint content: `GET /rest/api/3/project/{key}` is a platform endpoint requiring `read:jira-work`; JSM service-desk context discovery additionally requires `read:servicedesk-request`. Both scopes are in `DEFAULT_OAUTH_SCOPES` (verified: `src/api/auth.rs:60-61`), so re-consent via `jr auth login` genuinely obtains them — the hint IS actionable. Because jr's default OAuth app already grants these scopes, expiry is the more common cause for default-scoped users. The hint therefore LEADS with session-expiry recovery (`jr auth refresh` / `jr auth login`) and SECOND mentions, for BYO-OAuth users, that `jr auth login` must be used to re-consent with `read:jira-work` and `read:servicedesk-request` — `jr auth refresh` alone cannot add missing scopes (it re-mints with the same granted scope set) (H-03: expiry-recovery leads; BYO-scope sentence is secondary and explicitly connects `jr auth login` to scope acquisition).

NOTE: this does NOT change BC-3.8.015 — the JSM POST OAuth `InsufficientScope` arm is genuinely the #185 POST scenario, so keeping `InsufficientScope` there is correct and unchanged. Scopes are `read:jira-work` + `read:servicedesk-request` (NOT `write:servicedesk-request` — that applies to the subsequent POST, which `require_service_desk` never reaches).

Gate: `client.is_oauth_auth() == true` at the new `map_err` site inside `require_service_desk` (same `map_err` as BC-X.8.006, branching on the predicate result).

The `hint` field value (body text after the `"Not authenticated. "` renderer prefix from `src/error.rs`). Tests MUST assert via `contains`, not `==`. Both arms of the `require_service_desk` OAuth 401 `map_err` emit this identical hint:

<!-- This block is duplicated from the CANONICAL copy in prd-delta-384.md §BC-X.8.007 — all copies MUST be updated together; cf. the JR_* doc-fallout pattern in CLAUDE.md (adversary-pass-4 F-04). -->
```
Your OAuth token may be expired. Run `jr auth refresh` to renew the token, or
`jr auth login` to re-authorize. If using a custom OAuth app, run `jr auth login`
to re-consent with read:jira-work and read:servicedesk-request — `jr auth refresh`
alone cannot add missing scopes (it re-mints with the same granted scope set).
```

This is the canonical pinnable string for `test_require_service_desk_oauth_401_surfaces_read_scope_hint`. Acceptance tests assert `contains` `read:jira-work` AND `contains` `read:servicedesk-request`; assert does NOT contain `write:servicedesk-request`.

**Inputs**: Active auth = Bearer/OAuth; a live GET inside `get_or_fetch_project_meta` returns HTTP 401 (any body — project GET or service-desk list GET); project-meta cache is empty (cache miss — the live GETs are issued).
**Outputs/Effects**: exit 2; stderr contains `"Not authenticated. "` prefix and read-scope hint (assert `contains` `read:jira-work` AND `contains` `read:servicedesk-request`; assert does NOT contain `write:servicedesk-request`); stdout empty.
**Errors**: None beyond the 401 itself — this BC IS the error-handling contract.
**Setup** (for `test_require_service_desk_oauth_401_surfaces_read_scope_hint`):
0. **Isolated `XDG_CACHE_HOME` tempdir** (e.g., `tempfile::tempdir()`) — forces a project-meta cache miss so the live GET inside `get_or_fetch_project_meta` actually fires. A warm cache would bypass the HTTP call and the 401 would never be seen.
1. Auth fixture: `JR_AUTH_HEADER=Bearer test-oauth-token` (capital B, single space — the established OAuth/Bearer fixture string used throughout `tests/issue_create_jsm.rs`).
2. Mount `GET /rest/api/3/project/{KEY}` to return HTTP 401 with a **scope-mismatch body**: `{"errorMessages": ["Unauthorized; scope does not match"]}`. **WHY scope-mismatch body is required:** A Bearer client receiving a generic-expiry 401 body on this GET does NOT short-circuit to `JrError::InsufficientScope` — it enters the auto-refresh coordinator (client.rs:727+), which deterministically fails with a raw `anyhow::bail!` error (not a `JrError`) via the `JR_AUTH_HEADER` seam (no keychain tokens). That raw error propagates without entering the `map_err`'s `JrError` match arms, so the read-scope hint is never injected. The scope-mismatch body (`"scope does not match"` substring) triggers the short-circuit at client.rs:696-704 BEFORE the refresh coordinator, landing as `JrError::InsufficientScope` in the `map_err`, which then rewrites to `JrError::NotAuthenticated { hint }` with the read-scope hint. A generic-expiry body would produce a non-deterministic, non-`JrError` failure path — not a valid pin for this BC. **BC-X.8.006 (Basic) is NOT affected** by this constraint: a Basic 401 never enters the refresh path (gated on `Bearer` at client.rs:718), so any body deterministically yields a `JrError`; BC-X.8.006's Setup may use a generic-expiry body (as specified). This is the **canonical pinned 401 path** for this named test — the project GET is triggered first by `get_or_fetch_project_meta` on a cache miss. **URL-encoding note (adversary-pass-8 LOW):** the project key is URL-encoded by `get_or_fetch_project_meta` via `urlencoding::encode`, so a wiremock `path()` matcher is exact for plain-alphanumeric keys (the named test uses `HELP`); a project key containing special characters would require an encoded mock path.
3. The second GET arm (`list_service_desks()` → `GET /rest/servicedeskapi/servicedesk`) is covered **structurally** because the `map_err` wraps the entire `get_or_fetch_project_meta` future — it is NOT separately pinned by this test. The canonical-vs-structural distinction is explicit: this test pins the project-GET arm; the service-desk-list arm is covered by the shared `map_err` on `get_or_fetch_project_meta`. No dedicated test for the service-desk-list 401 arm is required; both arms emit the identical hint (as established in BC-X.8.007 body above).
4. Drive via: `jr issue create --project <KEY> --request-type <NAME> --summary "..." --no-input` (which calls `require_service_desk` first, triggering the 401 before reaching the JSM POST). The test mounts only the 401 project-GET mock; no request-type resolution mock is needed because the command exits at the `require_service_desk` step.
**Trace**: `tests/issue_create_jsm.rs` (integration test `test_require_service_desk_oauth_401_surfaces_read_scope_hint` — NEW; OAuth/Bearer fixture, cache miss forced; asserts stderr `contains` `read:jira-work` AND `contains` `read:servicedesk-request`; asserts stderr does NOT contain `write:servicedesk-request`). The new `map_err` is placed inside `require_service_desk` (shared by `jr issue create`, `jr queue`, `jr requesttype`), so all three callers structurally benefit; this test pins the `create` caller path; existing `queue`/`requesttype` integration tests cover regression for those callers.
**Source**: Issue #384 F2; O-08-05 CONFIRMED; `src/api/auth.rs:60-61` (both `read:jira-work` and `read:servicedesk-request` in DEFAULT_OAUTH_SCOPES — hint IS actionable for default-scoped users); `src/api/client.rs:696-704` (scope-mismatch body detection → InsufficientScope); `src/api/jsm/servicedesks.rs:52-85` (get_or_fetch_project_meta issues TWO live GETs on a service_desk-type cache miss: GET /rest/api/3/project/{key} AND GET /rest/servicedeskapi/servicedesk; the new map_err must wrap the entire future); orchestrator decision: read-side scopes for this path, NOT write-scope; `src/api/jsm/servicedesks.rs:117` (new map_err must be introduced here — see BC-X.8.006).
**Confidence**: HIGH

[NEW 2026-05-19 issue #384 F2] Pins the OAuth read-scope hint for the require_service_desk 401 path. Prior to issue #384, no hint existed for this path. The read-side scope names differ from BC-3.8.015's write-scope name — a user whose token has `write:servicedesk-request` but not `read:jira-work` would fail at require_service_desk before ever reaching the POST. Both scopes are in DEFAULT_OAUTH_SCOPES, making `jr auth login` genuinely actionable for session-expiry cases.

[REVISED 2026-05-19 issue #384 F2 adversary-pass-2 C-02/C-03/H-01/M-02] (C-02) Removed incorrect "Insufficient token scope. " (period) renderer-prefix citation — the actual `InsufficientScope` Display renders with a colon: "Insufficient token scope: {message}". (C-03) Both sub-case arms of the OAuth 401 now rewrite to `JrError::NotAuthenticated { hint }` — NOT `InsufficientScope`. The `InsufficientScope` Display is purpose-built for the issue-#185 POST scenario and always appends irrelevant POST-specific guidance when applied to a read GET. (H-01) Dual exit codes documented explicitly. (M-02) Cache-warm suppression stated as user-facing behavioral boundary.

[REVISED 2026-05-19 issue #384 F2 adversary-pass-3 C-01/H-03/H-04/H-05] (C-01) Trigger broadened: get_or_fetch_project_meta issues TWO live GETs for service_desk-type projects; map_err wraps the entire future and catches 401 from either. (H-03) Hint ordering corrected: leads with session-expiry recovery (jr auth refresh / jr auth login), BYO-scope sentence is SECONDARY. (H-04) Both arms of the map_err emit ONE canonical verbatim hint — no sub-case difference; single pinnable string documented; hint block relabeled "both arms emit this identical hint". (H-05) Named acceptance test function added: `test_require_service_desk_oauth_401_surfaces_read_scope_hint`; cross-caller coverage clarified.

[REVISED 2026-05-19 issue #384 adversary-pass-6 F-07] BYO-OAuth sentence in hint reworded: for a BYO-OAuth user with genuinely missing scopes, `jr auth refresh` re-mints a token with the SAME deficient scope set — it cannot add scopes. Only `jr auth login` re-consents and can acquire `read:jira-work` + `read:servicedesk-request`. Hint text updated to connect `jr auth login` explicitly to scope acquisition; `jr auth refresh` positioned as expiry-recovery only. Rationale paragraph in BC body aligned.

[REVISED 2026-05-19 issue #384 adversary-pass-9 C-01 CRITICAL design correction] Setup block corrected: the project-GET 401 mock body changed from generic-expiry to **scope-mismatch** (`{"errorMessages": ["Unauthorized; scope does not match"]}`). A Bearer client receiving a generic-expiry 401 on this GET routes through the refresh coordinator (client.rs:727+), which fails with a raw anyhow error (not a `JrError`) via the `JR_AUTH_HEADER` seam — the read-scope hint is never injected, making the test non-deterministic. The scope-mismatch body short-circuits to `JrError::InsufficientScope` at client.rs:696-704 BEFORE the refresh coordinator, deterministically reaching the `map_err`. BC-X.8.006 (Basic) is UNAFFECTED — Basic 401s never enter the refresh path and any body yields a `JrError` deterministically; BC-X.8.006's generic-expiry Setup remains as-is.

---

#### BC-X.8.008: `jr queue list` auto-paginates `/rest/servicedeskapi/servicedesk/{sdId}/queue` and renders `["Queue", "Issues"]` table; empty queue list is a valid success

**Confidence**: HIGH
**Subject**: X.8 Projects & Queues (JSM queue list)
**Behavior**: `handle_list` in `src/cli/queue.rs` calls `client.list_queues(service_desk_id)`. `list_queues` auto-paginates `GET /rest/servicedeskapi/servicedesk/{sdId}/queue?includeCount=true&start={N}&limit=50` using `ServiceDeskPage` until `isLastPage == true`, collecting all `Queue` values. Exit 0 on success. Requires a JSM service desk project — non-JSM projects are rejected by `require_service_desk` before `handle_list` is reached (BC-X.8.004).

**Table output** (default): two-column table with headers `["Queue", "Issues"]`. The Issues cell shows `q.issue_count.map(|c| c.to_string()).unwrap_or_else(|| "\u{2014}".into())` — i.e., the numeric count when `issueCount` is present in the API response, or em-dash `—` (U+2014) when `issueCount` is absent (None). An empty queue list (service desk with zero queues) in table mode renders the literal `No results found.` line (dimmed, via `src/output.rs::print_output`'s empty-rows branch), or `[]` in JSON mode, and exits 0 — NOT an error condition.

**JSON output** (`--output json`): `Vec<Queue>` serialized directly to a JSON array. Each element is a `Queue` object: `id` (string, non-null — serde `String`; empty-string is not type-prevented), `name` (string, non-null — serde `String`; empty-string is not type-prevented), and optionally `jql` (string or null), `fields` (array of strings or null), `issueCount` (number or null, serde field name `issueCount`). An empty array `[]` is a valid success state. The JSON output shape is governed by `src/types/jsm/Queue`'s `#[derive(Serialize)]` and the `#[serde(rename = "issueCount")]` annotation on `issue_count`.

**Pagination details**: page size is 50 per request; `includeCount=true` query param is always sent (causes the API to populate `issueCount` on each queue object). Pagination uses `ServiceDeskPage::has_more()` and `ServiceDeskPage::next_start()` for loop control. No client-side item cap (unlike `handle_view`).

**Inputs**: `service_desk_id` string (resolved by `require_service_desk`); `output_format` (table or JSON).
**Outputs/Effects**: stdout table or JSON array; exit 0.
**Errors**: 5xx → exit 1, `API error (N)` on stderr. 401 → exit 2, `Not authenticated` + `jr auth login` on stderr. Network drop → exit 1, `Could not reach <host> — check your connection` on stderr. Non-JSM project → exit 64 via `require_service_desk` (BC-X.8.004), before reaching `handle_list`.
**Trace**: `tests/queue.rs` (list_queues_returns_all_queues, list_queues_empty, queue_list_server_error_surfaces_friendly_message, queue_list_unauthorized_dispatches_reauth_message, queue_list_network_drop_surfaces_reach_error, test_queue_list_non_jsm_project_emits_canonical_callsite_message); `src/cli/queue.rs::handle_list`; `src/api/jsm/queues.rs::list_queues`
**Source**: S-QUEUE-BC-1 document-as-is; `src/cli/queue.rs::handle_list`; `src/api/jsm/queues.rs::list_queues`; `src/types/jsm/queue.rs`

[NEW 2026-06-08 S-QUEUE-BC-1] Closes traceability orphan: `jr queue list` was implemented but had no individually-bodied BC. Document-as-is: no aspirational behavior — all details verified against source and test files.

---

#### BC-X.8.009: `jr queue view` resolves queue by name (via `partial_match`) or `--id` (string pass-through), fetches issue keys in queue order, batch-fetches full issues, and reorders to queue position; issues absent from search are silently omitted

**Confidence**: HIGH
**Subject**: X.8 Projects & Queues (JSM queue view)
**Behavior**: `handle_view` in `src/cli/queue.rs` resolves a queue ID by one of two paths, then fetches and renders issues.

**Queue ID resolution (two paths):**
1. **By `--id <id>`**: The `id: Option<String>` argument is taken verbatim as the queue ID string. It is passed directly to `get_queue_issue_keys` without validation. There is no numeric validation — any string is accepted (e.g., `--id 10`, `--id "my-queue"`). This path BYPASSES `resolve_queue_by_name` entirely.
2. **By positional `<name>`**: `resolve_queue_by_name(service_desk_id, &name, client)` is called, which calls `client.list_queues(service_desk_id)` and applies `partial_match::partial_match(name, &names)`. Resolution outcomes:
   - `MatchResult::Exact(matched_name)` → returns the `id` of the matched queue. Proceeds.
   - `MatchResult::Ambiguous(matches)` → exit 64: `"<name>" matches multiple queues: "<m1>", "<m2>". Be more specific or use --id.`
   - `MatchResult::ExactMultiple(matched_name)` → exit 64: `Multiple queues named "<matched_name>" found (IDs: <id1>, <id2>, ...). Use --id <id1> to specify.` (where `<matched_name>` carries the queue's stored casing, e.g., input `"triage"` yields `Multiple queues named "Triage"` — NOT the user's input string)
   - `MatchResult::None(_)` → exit 64: `No queue matching "<name>" found. Run "jr queue list" to see available queues.`
   - Neither `<name>` nor `--id` supplied → exit 64: `Specify a queue name or use --id. Run "jr queue list" to see available queues.`
   
   **Partial-match semantics (verified from unit tests in `src/cli/queue.rs` and `tests/queue.rs`):** A lone substring hit (e.g., `"escal"` matching `"Escalations"`) is returned as `MatchResult::Ambiguous` — NOT Exact. The caller must supply the full exact name (case-insensitive) for `MatchResult::Exact` to fire. This is the strict-matching invariant from `src/partial_match.rs`.

**Issue fetch pipeline (after queue ID is resolved):**
1. `client.get_queue_issue_keys(service_desk_id, &queue_id, effective_limit)` — GETs `/rest/servicedeskapi/servicedesk/{sdId}/queue/{queueId}/issue` in pages of up to 50, collecting issue keys in queue order. The effective limit is `limit.or(Some(crate::cli::DEFAULT_LIMIT))` — i.e., `DEFAULT_LIMIT = 30` when `--limit` is absent; `--limit N` caps collection at N.
2. If the keys list is empty (queue has zero issues): renders the `No results found.` line in table mode (via `src/output.rs::print_output`) or `[]` in JSON mode, and exits 0 immediately — no `search_issues` call is made.
3. Otherwise: `client.search_issues(&jql, Some(keys.len() as u32), &[])` with `jql = "key IN (<k1>, <k2>, ...)"` (keys NOT quoted in JQL — issue keys are identifiers). Batch size equals the number of keys fetched.
4. `reorder_by_queue_position(search_result.issues, &keys)` — re-orders the batch-fetched issues to match the original queue key ordering. Issues present in the queue keys but absent from the search result (e.g., permission-denied) are silently omitted (issues absent from the `search_issues` result are never present in the returned vec — `reorder_by_queue_position` only reorders the issues search actually returned; it neither synthesizes nor drops missing keys).

**Output (both resolution paths):**
- **Table output** (default): standard issue table using `issue_table_headers(false, false, false)` and `format_issue_rows_public(&issues)`. Same column set as `jr issue list`.
- **JSON output** (`--output json`): JSON array of full `Issue` objects (each has `key` + `fields`). NOT Queue objects. Empty array `[]` is a valid success state (queue exists, zero issues or all silently omitted).

**Requires JSM service desk project**: delegated to `require_service_desk` in the shared `handle` dispatcher before `handle_view` is entered (BC-X.8.004).

**Inputs**: `service_desk_id` string (from `require_service_desk`); `name: Option<String>` (positional); `id: Option<String>` (`--id` flag); `limit: Option<u32>` (`--limit` flag); `output_format`.
**Outputs/Effects**: stdout table or JSON array of issue objects; exit 0.
**Errors**: Name resolution errors → exit 64 (see messages above). 5xx from any HTTP call → exit 1, `API error (N)`. 401 → exit 2, `Not authenticated` + `jr auth login`. Network drop → exit 1, `Could not reach`. Non-JSM project → exit 64 via `require_service_desk` (BC-X.8.004), before reaching `handle_view`.
**Trace**: `tests/queue.rs` (resolve_queue_duplicate_names_error_message, resolve_queue_single_substring_is_ambiguous, resolve_queue_mixed_case_duplicate_names_error_message, get_queue_issue_keys_returns_keys, get_queue_issue_keys_with_limit, get_queue_issue_keys_paginated); `src/cli/queue.rs` (handle_view, resolve_queue_by_name, build_key_in_jql, reorder_by_queue_position); `src/api/jsm/queues.rs::get_queue_issue_keys`
**Source**: S-QUEUE-BC-1 document-as-is; `src/cli/queue.rs::handle_view`; `src/cli/queue.rs::resolve_queue_by_name`; `src/api/jsm/queues.rs::get_queue_issue_keys`; `src/cli/mod.rs::DEFAULT_LIMIT`

[NEW 2026-06-08 S-QUEUE-BC-1] Closes traceability orphan: `jr queue view` was implemented but had no individually-bodied BC. Document-as-is: no aspirational behavior — all details verified against source and test files.

---

### X.9 JQL Utilities

#### BC-X.9.001: `escape_value` proptest: for any printable Unicode up to 100 chars, output has NO unescaped quote

**Confidence**: HIGH
**Source**: `src/jql.rs:383-394`; `proptest-regressions/jql.txt` (seed: `s = ""`)
**Subject**: JQL
**Behavior**: `has_unescaped_quote` helper tracks backslash-runs. Regression corpus pinned.
**Trace**: Pass 3 BC-1094 (R4)

---

#### BC-X.9.002: `validate_duration("4w2d")` → Err; single unit `"7d"` → Ok

**Confidence**: HIGH
**Source**: `src/jql.rs:16-34`
**Behavior**: JQL relative-date validator (distinct from worklog parser).
**Trace**: Pass 3 BC-131 (R1)

---

#### BC-X.9.003: `validate_date` → `YYYY-MM-DD` format only; invalid → `JrError::UserError`

**Confidence**: HIGH
**Source**: `src/jql.rs`
**Trace**: Pass 3 BC-132 (R1)

---

#### BC-X.9.004: `strip_order_by` removes ORDER BY clause before count calls and paren-wrapping

**Confidence**: HIGH
**Source**: `src/jql.rs`; `src/cli/issue/list.rs`
**Trace**: Pass 3 BC-102, BC-125 (R1)

---

### X.10 Partial-Match

#### BC-X.10.001: `partial_match` with single-substring → `Ambiguous` (NOT Exact); never auto-resolves

**Confidence**: HIGH
**Source**: `src/partial_match.rs::tests`; unit test suite (partial_match module); property tests
**Subject**: Partial-match
**Behavior**: Single-substring match returns `MatchResult::Ambiguous(matches)`. Callers must reject this under `--no-input`. This is the fail-closed invariant.

**Edge cases**:
- **(EC-1) Ambiguous input short-circuits before any network call (no-network pre-API property)**: `partial_match` is a pure function — it takes a `&str` input and a `&[String]` candidates slice and returns a `MatchResult` without performing any I/O. The callers (e.g., `src/cli/queue.rs::resolve_queue_by_name`, `src/cli/issue/workflow.rs` move-status resolution, `src/cli/requesttype.rs` request-type name resolution) evaluate `partial_match` BEFORE issuing any additional HTTP requests. Consequence: when the result is `MatchResult::Ambiguous`, the handler exits 64 with the disambiguation message and ZERO extra HTTP requests are issued beyond the initial list-fetch needed to populate the candidates. Wiremock integration tests can assert `expect(1)` (list fetch only, no follow-on GET/PUT/POST) to verify this no-network property. The no-network behavior is a consequence of `partial_match` being a pure function, not a separately configurable mode.

**Trace**: Pass 3 BC-105 context; `src/partial_match.rs` (pure function — no I/O); `src/cli/queue.rs::resolve_queue_by_name` (ambiguous → exit 64 before queue-issues fetch); `src/cli/issue/workflow.rs` (ambiguous status name → exit 64 before transition POST); `src/cli/requesttype.rs` (ambiguous RT name → exit 64 before RT-fields fetch); `tests/queue.rs::resolve_queue_single_substring_is_ambiguous` — this test mounts ONLY the queue-list GET and asserts the Ambiguous short-circuit (`JrError::UserError` + `"matches multiple queues"` message); the second endpoint (queue-issues) is never mounted, so any follow-on request would return 404 as unmatched. The zero-follow-on-HTTP property holds STRUCTURALLY via `partial_match` purity. This test does NOT use a wiremock `expect(1)` call-count pin (confirmed: zero `.expect(` calls in the test body); adding one (as in `tests/requesttype_commands.rs::test_requesttype_list_cache_hit_no_second_http`) is recommended future coverage.

---

#### BC-X.10.002: `partial_match(s, &candidates)` proptest: exact match always found; never panics on arbitrary input; empty candidates → None

**Confidence**: HIGH
**Source**: `src/partial_match.rs:153-198`
**Trace**: Pass 3 BC-1095..BC-1097 (R4)

---

#### BC-X.10.003: Duplicate candidates → `MatchResult::ExactMultiple(name)` with `name.to_lowercase() == input.to_lowercase()`

**Confidence**: HIGH
**Source**: `src/partial_match.rs:182-198`
**Trace**: Pass 3 BC-1098 (R4)

---

### X.11 Build-Time

#### BC-X.11.001: `build.rs` reads `JR_BUILD_OAUTH_CLIENT_ID` + `_SECRET` env vars

**Confidence**: HIGH
**Source**: `build.rs` (125 LOC)
**Trace**: Pass 3 BC-1301

---

#### BC-X.11.002: Unix → `/dev/urandom` for 32-byte XOR key; Windows → inline `BCryptGenRandom` FFI

**Confidence**: HIGH
**Source**: `build.rs`
**Trace**: Pass 3 BC-1302

---

#### BC-X.11.003: Non-unix/non-windows → `compile_error!`

**Confidence**: HIGH
**Source**: `build.rs`
**Trace**: Pass 3 BC-1303

---

#### BC-X.11.004: Unset build vars → `EMBEDDED_*` constants are `None`; BYO/prompt path proceeds

**Confidence**: HIGH
**Source**: `build.rs`; `src/api/auth_embedded.rs::tests`
**Trace**: Pass 3 BC-1304

---

#### BC-X.11.005: `proptest-regressions/jql.txt` pinned regression seed for `escape_value("")`

**Confidence**: HIGH
**Source**: `proptest-regressions/jql.txt`
**Trace**: Pass 3 BC-1103 (R4)

---

## BC-X.12: JSM Request Type Discovery

8 behavioral contracts covering `jr requesttype list` and `jr requesttype fields` subcommands,
backed by the service desk requesttype API. These are discovery commands used before
`jr issue create --request-type` to identify valid request types and their required fields.

---

#### BC-X.12.001: `jr requesttype list` lists request types for the active project's service desk

**Confidence**: HIGH
**Subject**: JSM request type discovery
**Behavior**: `jr requesttype list --project <KEY>` calls `GET /rest/servicedeskapi/servicedesk/<id>/requesttype` (paginated via `isLastPage`). Default table output shows columns: Name, Description. ID is available in `--output json` only. Returns all request types for the resolved service desk. Uses `require_service_desk(client, key)` to resolve the `serviceDeskId` before calling the list endpoint.
**Inputs**: `--project <KEY>` (required; uses active-profile project if absent and profile has one configured)
**Outputs/Effects**: stdout table (Name + Description columns by default); exit 0 on success.
**Errors**: No project configured and no `--project` flag → exit 64 "project is required". Non-JSM project → exit 64 via `require_service_desk` (BC-X.8.004).
**Trace**: `tests/requesttype_commands.rs` (list command, table output); `src/cli/requesttype.rs`; `src/api/jsm/request_types.rs`
**Source**: API-verified: `GET /rest/servicedeskapi/servicedesk/{id}/requesttype` returns `{start, limit, isLastPage, values}`
**Confidence**: HIGH

---

#### BC-X.12.002: `--search <QUERY>` filters via JSM `searchQuery` parameter (name or description partial match)

**Confidence**: HIGH
**Subject**: JSM request type discovery
**Behavior**: When `--search <QUERY>` is set, the `searchQuery` query parameter is appended to `GET /rest/servicedeskapi/servicedesk/<id>/requesttype?searchQuery=<QUERY>`. Filtering is server-side (Atlassian API). No client-side secondary filtering is applied. If `--search` returns an empty `values` array, the command exits 0 with an empty table (NOT an error). The `searchQuery` parameter supports name and description substring matching as defined by the Atlassian API.
**Inputs**: `--search <QUERY>` (optional)
**Outputs/Effects**: Filtered request type list; may be empty table on no match.
**Errors**: API error (5xx) → exit 1 + "API error (N)". 401 → exit 2 + `jr auth login`.
**Trace**: `tests/requesttype_commands.rs` (search parameter propagation, empty-result path)
**Source**: API-verified: `searchQuery` is a supported query param on the list endpoint
**Confidence**: HIGH

---

#### BC-X.12.003: `--project <KEY>` overrides active profile; `require_service_desk` errors clean on non-JSM project with call-site-specific message

**Confidence**: HIGH
**Subject**: JSM request type discovery
**Behavior**: `--project <KEY>` takes precedence over any project configured in the active profile (same precedence rule as all other project-flag uses). The flag is the non-interactive mechanism for specifying the target project. `require_service_desk` returns a typed error for non-JSM (software) projects — the command exits 64 with a call-site-specific error message (NOT the legacy "Queue commands require…" string). Error message MUST be: 'Project "<KEY>" is a <type> project. `jr requesttype` commands require a Jira Service Management project. Run "jr project list" to find a JSM project.' Zero HTTP calls to the requesttype endpoint are made.
**Inputs**: `--project <KEY>` (overrides profile-level project config)
**Outputs/Effects**: Project-scoped service desk ID resolved before any requesttype API call.
**Errors**: Non-JSM project → exit 64 + call-site-specific message (see above); NO requesttype HTTP. Software project check fires before the list request.
**Trace**: `tests/requesttype_commands.rs` (non-JSM project exit-64 path); `src/api/jsm/servicedesks.rs::require_service_desk`
**Source**: Reuses `require_service_desk` established for `jr queue`; caller-supplied context label per BC-X.8.004 [UPDATED 2026-05-18 issue #288]
**Confidence**: HIGH

---

#### BC-X.12.004: `--output json` returns structured JSON array; default table shows Name + Description columns

**Confidence**: HIGH
**Subject**: JSM request type discovery
**Behavior**: `jr requesttype list --output json` returns a JSON array to stdout: `[{id: "<str>", name: "<str>", description: "<str>", helpText: "<str>"|null, issueTypeId: "<str>"|null, groupIds: ["<str>", ...]}, ...]`. Each element uses the fields returned by the Atlassian API; `null` for absent optional fields. Table output (default) shows Name + Description columns only; ID is not shown in table mode. Truncation hint ("Showing N of M") goes to stderr when applicable.
**Inputs**: `--output json` (optional flag)
**Outputs/Effects**: stdout JSON array on `--output json`; stdout table on default.
**Errors**: Empty list returns `[]` (JSON) or empty table; NOT an error condition.
**Trace**: `tests/requesttype_commands.rs` (JSON output shape, table output shape); body deserialization tests
**Source**: API-verified: response values include `id`, `name`, `description`, `helpText`, `issueTypeId`, `groupIds`
**Confidence**: HIGH

---

#### BC-X.12.005: `jr requesttype fields <NAME|ID>` lists fields for a request type

**Confidence**: HIGH
**Subject**: JSM request type discovery
**Behavior**: `jr requesttype fields <NAME|ID> --project <KEY>` resolves the request type (by name or numeric ID, same logic as BC-X.12.006 below), then calls `GET /rest/servicedeskapi/servicedesk/<id>/requesttype/<rtId>/field`. Returns metadata about each field: `fieldId`, `name`, `required` (bool), `jiraSchema` (system/custom type info), and optionally `defaultValues` and `validValues`. Default table output shows columns: Field Name, Required (YES/NO), Type.
**Inputs**: `<NAME|ID>` positional argument (required); `--project <KEY>` (required or from profile)
**Outputs/Effects**: stdout table with field metadata; exit 0 on success.
**Errors**: Request type not found → exit 64 via `partial_match` (BC-X.12.006). Non-JSM project → exit 64 via `require_service_desk`.
**Caching**: Fields for a request type are cached per `(profile, serviceDeskId, requestTypeId)` with 7-day TTL at cache key `~/.cache/jr/v1/<profile>/request_type_fields_<service_desk_id>_<request_type_id>.json`. Cache miss → HTTP fetch + write. Corrupt or expired cache is treated as a miss (self-heals). Recovery path: manual deletion of the cache file (same convention as BC-X.12.008 for the request-type list cache). No `--refresh` flag is provided in this delta.
**Trace**: `tests/requesttype_commands.rs` (fields command, required/optional field rendering, cache hit: second call fires no HTTP); `src/cli/requesttype.rs`; `src/api/jsm/request_types.rs`; `src/cache.rs` (request_type_fields cache read/write functions)
**Source**: API-verified: `GET .../requesttype/{rtId}/field` returns `{canRaiseOnBehalfOf, canAddRequestParticipants, requestTypeFields[{fieldId, name, description?, required, defaultValues?, validValues?, jiraSchema{system|custom|customId|type}, visible}]}`. See also architecture-delta.md §"Cache Key Prefix".
**Confidence**: HIGH

---

#### BC-X.12.006: Partial-name resolution for `<NAME|ID>` uses `partial_match`; ambiguity errors with disambiguation hint

**Confidence**: HIGH
**Subject**: JSM request type discovery
**Behavior**: When `<NAME|ID>` is a non-numeric string, the handler fetches (or cache-hits) the request type list, extracts names, and calls `partial_match(input, &names)`. `MatchResult::Exact(id)` → proceeds. `MatchResult::Ambiguous` → exits 64 with "Ambiguous request type" + all candidate names listed in stderr + hint "Run `jr requesttype list --project <KEY>` to see all request types". `MatchResult::None` → exits 64 with "Request type not found: <input>" + same hint. `MatchResult::ExactMultiple(name)` (case-variant duplicates, e.g., "Password Reset" and "password reset") → exits 64 with `'Multiple request types named "<name>" found (IDs: <id1>, <id2>, ...). Pass the numeric ID directly.'` in stderr. Rationale: Atlassian REST does not guarantee a stable ordering for case-variant duplicates within the same service desk, so deterministic resolution requires the numeric ID. This matches the `cli/queue.rs` precedent for duplicate queue names. In `--no-input` mode, ambiguous result exits 64 cleanly without prompting.
[UPDATED 2026-05-18 issue #288 adversary-pass-01 H-3]: ExactMultiple was previously documented as "treated as Exact, proceeds" — hardened to exits 64 after impl review confirmed Atlassian REST does not guarantee stable ordering for case-variant duplicates, making "pick first" non-deterministic and unsafe. Conservative resolution (require numeric ID) matches cli/queue.rs precedent.
[UPDATED 2026-05-18 issue #288 adversary-pass-01 M-2]: Hint verb changed from "Use" to "Run" to match imperative active voice used throughout jr's CLI ergonomics and the impl's actual emission.
**Inputs**: `<NAME|ID>` positional (non-numeric → name resolution; numeric → bypass as in BC-3.8.004)
**Outputs/Effects**: Resolved `requestTypeId` integer used for the field fetch call.
**Errors**: Ambiguous → exit 64; None → exit 64; both without firing the field GET.
**Trace**: `tests/requesttype_commands.rs` (partial-match disambiguation, not-found, numeric bypass); `src/partial_match.rs`
**Source**: Follows `partial_match` pattern established by `jr queue` and `jr issue move`
**Confidence**: HIGH

---

#### BC-X.12.007: `--output json` for `jr requesttype fields` returns structured JSON with `required` bool per field; default table shows Field, Required, Type

**Confidence**: HIGH
**Subject**: JSM request type discovery
**Behavior**: `jr requesttype fields <NAME|ID> --output json --project <KEY>` returns a JSON object to stdout: `{canRaiseOnBehalfOf: bool, canAddRequestParticipants: bool, fields: [{fieldId: "<str>", name: "<str>", required: bool, jiraSchema: {type: "<str>", ...}, defaultValues?: [...], validValues?: [...]}]}`. The `required` field is a boolean (true = must be provided by submitter). Default table output shows: Field (name column), Required (YES/NO), Type (from `jiraSchema.type`).
**Inputs**: `--output json` (optional flag)
**Outputs/Effects**: stdout JSON object on `--output json`; stdout table on default.
**Errors**: API error (5xx) → exit 1. 401 → exit 2.
**Trace**: `tests/requesttype_commands.rs` (JSON output shape, required flag rendering)
**Source**: API-verified: `requestTypeFields[].required` is a boolean field in the API response
**Confidence**: HIGH

---

#### BC-X.12.008: Request types cached per `(profile, serviceDeskId)` with 7-day TTL; cache miss self-heals; cache key: `v1/<profile>/request_types_<service_desk_id>.json`

**Confidence**: HIGH
**Subject**: JSM request type discovery
**Behavior**: On `requesttype list` or name-resolution calls, the handler first checks `read_request_type_cache(profile, service_desk_id)`. Cache hit (valid, within 7-day TTL) → returns cached `Vec<RequestType>` without HTTP. Cache miss (absent, expired, or corrupt JSON) → fetches from API, writes to `write_request_type_cache(profile, service_desk_id, types)`, then proceeds. Cache file path: `~/.cache/jr/v1/<profile>/request_types_<service_desk_id>.json`. The `<service_desk_id>` in the filename is the numeric service desk ID as a string. Cache is keyed per `(profile, serviceDeskId)` to respect multi-profile isolation invariant (different profiles may have different service desks). Corrupt cache file is treated as a miss (self-heals).
**Inputs**: profile name (active profile), serviceDeskId (resolved by `require_service_desk`)
**Outputs/Effects**: Cache write on miss; cache read on hit (no HTTP). Cache TTL = 7 days (matching all other `jr` caches).
**Errors**: Cache write failure is non-fatal (logged to stderr as hint; does not abort the command). Cache corruption is non-fatal (treated as miss).
**Stale-cache window**: Up to 7 days. If a Jira admin renames a request type or modifies its required fields, users will see stale data for up to 7 days. No `--refresh` or `--no-cache` flag is provided in this delta (deferred). Recovery path: users may force a refresh by deleting `~/.cache/jr/v1/<profile>/request_types_<service_desk_id>.json` manually. Cache miss on `partial_match::None` does NOT auto-retry with cache-bypass; the error message MUST hint at manual cache deletion: 'Request type "<NAME>" not found. Run `jr requesttype list --project <KEY>` to see all request types, or delete the cache file at ~/.cache/jr/v1/<profile>/request_types_<service_desk_id>.json if a recent admin change is suspected.'

[UPDATED 2026-05-18 issue #288 adversary-pass-04 M-1 + M-4] Aligned hint phrasing
to BC-X.12.006 ("see all request types") and added the `--project <KEY>` flag for
actionability when no profile project is configured. Prior wording ("current types"
without `--project`) is superseded; impl + tests already match the aligned form.
**Fields cache**: See BC-X.12.005 §Caching for the per-request-type fields cache (sibling cache, same 7-day TTL and recovery semantics).
**Trace**: `tests/requesttype_commands.rs` (cache hit: second call fires no HTTP); `src/cache.rs` (RequestTypeCache struct); `src/api/jsm/request_types.rs`
**Source**: Follows `teams.json` cache pattern; 7-day TTL matches all other caches in `src/cache.rs`
**Confidence**: HIGH

---

## BC-X.13: CI Guards

6 behavioral contracts covering Guard 0 (`tests/claude_md_citations.rs` — the CLAUDE.md doc-fallout
guard verifying every file-path citation resolves to a real on-disk file; BC-X.13.001..003) and
Guard 1 (`scripts/check-bc-citation-symbols.sh` — the bc-*.md Trace/Source file::symbol citation
guard; BC-X.13.004..006; CITATION-GUARDS Story B, 2026-07-05).

---

#### BC-X.13.001: Every in-scope backtick-quoted path citation in CLAUDE.md resolves to a real on-disk file; guard fails listing all dead references with source context

**Confidence**: HIGH
**Subject**: CI guard / doc-fallout invariant
**Behavior**: The `test_claude_md_citations_resolve_to_real_files` test in `tests/claude_md_citations.rs` reads `CLAUDE.md` via `include_str!("../CLAUDE.md")`, extracts every backtick-quoted token that is IN-SCOPE per BC-X.13.002 step (c) — either (1) starts with a develop-tracked directory prefix (`src/`, `tests/`, `docs/`, `.github/`, `scripts/`) OR (2) exactly equals a member of the curated ROOT_FILES set (`build.rs`, `Cargo.toml`, `CHANGELOG.md`, `CLAUDE.md`, `deny.toml`, `README.md`, `rust-toolchain.toml`) — AND has a recognized file extension (`.md`, `.rs`, `.sh`, `.toml`, `.yml`, `.yaml`), after normalization per BC-X.13.002 (glob skip, symbol-form strip, line-ref strip, trailing-punct trim), then asserts `Path::new(root).join(&citation).exists()` for each remaining path. ALL `.factory/` prefixes are EXCLUDED — `.factory/` is git-ignored and lives in a separate orphan-branch worktree that is ABSENT from the CI checkout; dead-citation coverage for `.factory/` paths is handled by the maintenance doc-drift sweep, NOT this guard. Bare-filename shorthands (e.g., `ci.yml`, `adf.rs`, `fields.json`) that are not in ROOT_FILES remain excluded. On failure, the assertion message lists EVERY dead path (not just the first) with the canonical message format below. The test passes green on the current `develop` HEAD (zero dead citations) and fails deterministically when any newly-cited path does not exist.

**Preconditions**:
- `CLAUDE.md` is readable via `include_str!` at compile time
- The crate root (`CARGO_MANIFEST_DIR`) is the jira-cli repo root
- All cited develop-tracked paths in CLAUDE.md exist as files on the working branch at test time

**Postconditions (on success)**:
- Exit 0; test passes
- Every backtick token matching the in-scope grammar — dir-prefix (`src/...`, `tests/...`, `docs/...`, `.github/...`, `scripts/...`) OR ROOT_FILES exact-match (`build.rs`, `Cargo.toml`, `CHANGELOG.md`, `CLAUDE.md`, `deny.toml`, `README.md`, `rust-toolchain.toml`) — resolves to a real file

**Postconditions (on failure)**:
- Test fails with the CANONICAL failure message (exact wording, authoritative per error-taxonomy CI-CITE-001):
  ```
  CLAUDE.md cites file paths that do not exist on disk:
    <path> (line 142)
    <path> (line 287)
  Fix the citation or restore the file.
  Note: .factory/, glob, and symbol-form tokens are auto-excluded. Root-level files (Cargo.toml, CLAUDE.md, etc.) are checked.
  ```
- Each dead citation is listed on its own line, prefixed with two spaces, followed by ` (line {n})` where `{n}` is the real 1-based line number in CLAUDE.md where the backtick citation occurs — computed from the `(path, line)` pairs returned by `extract_path_citations` filtered by `!Path::exists()`
- The message includes the "Fix the citation or restore the file." instruction plus the auto-exclusion note and root-file inclusion note

**Invariants**:
- The guard runs on the 3-OS matrix (ubuntu, macos, windows) as part of the existing `test` job — no new CI job or `ci-gate.needs` edit required
- A citation that was valid when committed becomes a failing test the moment the referenced file is deleted or renamed — drift is caught at the NEXT CI run touching either CLAUDE.md or the deleted file
- `Path::join` (not string concatenation) is used to resolve paths — correct path-separator handling on Windows without a separate codepath
- ALL `.factory/` prefixes are excluded — no partitioning between `.factory/research/` (checked) and `.factory/specs/` (allowlisted); the old "off-branch allowlist" design is SUPERSEDED by this all-exclude rule
- ROOT_FILES members (`build.rs`, `Cargo.toml`, `CHANGELOG.md`, `CLAUDE.md`, `deny.toml`, `README.md`, `rust-toolchain.toml`) ARE checked — bare-filename shorthands not in ROOT_FILES remain excluded

**Edge Cases**:
- EC-CITE-001: CLAUDE.md contains zero in-scope citations → test passes (empty `dead` vec)
- EC-CITE-002: A citation uses `Detail: path1, path2` comma-delimited form → both tokens extracted (interior whitespace tokenization); trailing comma stripped by trailing-punct rule (BC-X.13.002 step (b) sub-step (4)) → both checked independently
- EC-CITE-003: A citation has CRLF line ending (Windows checkout) → `lines()` and `.trim_end_matches('\r')` normalize before tokenization; no false positive
- EC-CITE-004: A path with a recognized extension (e.g., `src/cli/issue.rs`) that resolves to a directory rather than a file → `Path::exists()` returns true for directories; guard passes (the "path is a directory" case only arises when an extensioned token happens to name an existing directory, which is extremely rare; extensionless directory tokens such as `src/cli/issue` are excluded earlier by the extension filter at step (d))
- EC-CITE-005: Two different CLAUDE.md lines cite the same path → path checked twice; redundant but not harmful (no dedup needed)
- EC-CITE-016 (M-1): Token appears inside a triple-backtick fenced code block (e.g., the architecture tree in CLAUDE.md) → OUT OF SCOPE; the guard extracts ONLY inline single-backtick spans, not fenced-block contents; fenced-block paths are never checked and never cause false positives
- EC-CITE-017: CLAUDE.md cites `.factory/research/S-3.03-wave3-verification.md` → prefix `.factory/` → EXCLUDED (not checked); no failure even if file exists or does not exist on the working tree
- EC-CITE-022 (forward-reference): A CLAUDE.md citation references a develop-tracked file (e.g., `tests/claude_md_citations.rs`) that does not yet exist on the working tree at CI time → the guard FAILS with a dead-citation error for that path. In-scope citations must reference files present in the SAME working tree at test time. The correct fix is to land the citation and the referenced file in the SAME commit or PR — e.g., the guard's own doc-fallout note in CLAUDE.md and the new `tests/claude_md_citations.rs` file must be introduced together, not in separate PRs.

**Canonical Test Vectors**:

| Input token (after backtick extraction) | In-scope? | Expected outcome |
|----------------------------------------|-----------|-----------------|
| `src/adf.rs` | YES | Pass (file exists) — dir-prefix rule |
| `tests/auth_profiles.rs` | YES | Pass (file exists) — dir-prefix rule |
| `docs/adr/0016-windows-build-target.md` | YES | Pass (file exists) — dir-prefix rule |
| `.factory/research/S-3.03-wave3-verification.md` | NO | Excluded (`.factory/` prefix) |
| `.factory/specs/prd/bc-3-issue-write.md` | NO | Excluded (`.factory/` prefix) |
| `scripts/check-spec-counts.sh` | YES | Pass (file exists) — dir-prefix rule |
| `src/api/jsm/nonexistent.rs` | YES | FAIL — listed in dead citations |
| `Cargo.toml` | YES | Pass (file exists) — ROOT_FILES inclusion |
| `CLAUDE.md` | YES | Pass (file exists) — ROOT_FILES inclusion |
| `build.rs` | YES | Pass (file exists) — ROOT_FILES inclusion |
| `deny.toml` | YES | Pass (file exists) — ROOT_FILES inclusion |
| `ci.yml` | NO | Excluded (not in ROOT_FILES; `.github/workflows/` shorthand) |
| `adf.rs` | NO | Excluded (not in ROOT_FILES; `src/` shorthand) |
| `fields.json` | NO | Excluded (not in ROOT_FILES; cache-file shorthand) |
| `~/.config/jr/config.toml` | NO | Excluded (no known dir prefix, not in ROOT_FILES) |
| `%APPDATA%\jr` | NO | Excluded (no known dir prefix, not in ROOT_FILES) |
| `http://127.0.0.1:53682/callback` | NO | Excluded (no known dir prefix, not in ROOT_FILES) |
| `JR_BASE_URL` | NO | Excluded (no `/` and no extension, not in ROOT_FILES) |
| `std::sync::Mutex` | NO | Excluded (no known dir prefix, not in ROOT_FILES) |
| `BC-3.2.013` | NO | Excluded (no `/`, not in ROOT_FILES) |
| `JRACLOUD-95368` | NO | Excluded (no `/`, not in ROOT_FILES) |

**Verification Properties**:
- VP-CITE-001: `extract_path_citations` grammar — unit + proptest coverage of in-scope detection and all normalization/exclusion rules including ROOT_FILES inclusion (EC-CITE-029..031); no false positives on documented edge cases. See `verification-delta-DEAD-CITATION-CI.md` §VP-CITE-001.
- VP-CITE-002: Integration self-verification — `test_claude_md_citations_resolve_to_real_files` passes green on develop HEAD; fails deterministically when fed a fixture with a known-dead citation; ROOT_FILES members (Cargo.toml, CLAUDE.md, etc.) are included in the existence check. See `verification-delta-DEAD-CITATION-CI.md` §VP-CITE-002.

**Traceability**:
- F1 Delta Analysis: `DEAD-CITATION-CI-delta-analysis.md` §7 BC-CITE-001
- Research: `maint-pg-dead-citation-ci-approach.md` §(a)
- Implementing story: S-MAINT-DEAD-CITATION-CI (F3)
- Source: `tests/claude_md_citations.rs::test_claude_md_citations_resolve_to_real_files` (new file)

---

#### BC-X.13.002: Backtick tokens with glob wildcards (`*`, `{`, `}`), symbol suffixes (`::fn`), line-ref suffixes (`:~NN`/`:NN`), trailing punctuation, and section refs (` §N`) are excluded from or normalized before the path-existence check — no false positives on these forms

**Confidence**: HIGH
**Subject**: CI guard / parser grammar
**Behavior**: The `extract_path_citations(doc: &str) -> Vec<(String, usize)>` helper in `tests/claude_md_citations.rs` applies a two-step extraction followed by a canonical pipeline in order before the `Path::exists()` check. Each entry in the returned vec is a `(normalized_path, line_number)` pair where `line_number` is the 1-based line in `doc` where the backtick citation token occurs. Line tracking is deterministic from the input string (count newlines up to the token start) and requires no I/O. The function remains pure (no `Path::exists()` calls inside):

**Two-step extraction (SR-001):**
1. Extract all inline single-backtick spans (`` `…` ``) from the CLAUDE.md text. Fenced triple-backtick code blocks are OUT OF SCOPE and never read (M-1).
2. Split each span interior on ASCII whitespace. Each whitespace-delimited token is a candidate citation.

Section-ref tokens (`§9`-style) require no special pipeline step — they lack a known directory prefix and are excluded automatically by the dir-prefix filter at step (c). Whitespace tokenization (step 2 above) has already separated them from any preceding path token.

**Canonical normalization/skip pipeline (steps applied in this exact order — SR-004, merged-fixpoint revision F2-Iter5):**

a. **Glob skip**: if the token contains `*`, `{`, or `}` anywhere, skip entirely (not checked). Handles ``.factory/specs/prd/bc-*.md``, `adf-{block,task}-list.md`, and similar brace-glob forms (SR-002).
b. **Normalize — single fixpoint (SR-005, merges former steps b/c/e)**: Repeat the following ordered sub-steps as ONE unit until a complete pass leaves the token unchanged:
   (1) strip a trailing `::…` symbol-form suffix (strip from first `::` onward). `src/adf.rs::push_text` → `src/adf.rs`. `adf::tests::test_bare_*` → already skipped at step (a).
   (2) strip a trailing `:~[0-9]+` or `:[0-9]+` line-ref suffix. `src/config.rs:~42` → `src/config.rs`.
   (3) strip one leading `(` or `[`.
   (4) greedily trim trailing `.`, `,`, `;`, `:` (repeat until none remain on this sub-step pass).
   (5) trim one trailing `)` iff `count('(') < count(')')` over the whole token.
   (6) trim one trailing `]` iff `count('[') < count(']')` over the whole token.
   **Termination**: ONE condition — a full pass (all six sub-steps) makes no change. There is no per-sub-step early exit. Merging symbol-strip (1), line-ref-strip (2), and punctuation-trim (3)–(6) into one fixpoint eliminates the ordering-class bug where a leading `(` prevented the line-ref suffix from being seen in a single non-iterating strip (F-PASS6-01): `(src/config.rs:~42)` → pass 1: sub-step (3) strips `(` → `src/config.rs:~42)`, sub-step (5) strips `)` → `src/config.rs:~42`; pass 2: sub-step (2) strips `:~42` → `src/config.rs`; pass 3: stable. Result: `src/config.rs` (checked).
c. **Dir-prefix filter + ROOT_FILES inclusion**: a token (after all normalization above) is IN-SCOPE if it meets EITHER of the following two conditions:
   - **Condition 1 (dir-prefix)**: the token starts with a develop-tracked directory prefix: `src/`, `tests/`, `docs/`, `.github/`, `scripts/`. ALL `.factory/` prefixes are excluded at this step — they are absent from the CI checkout. URL tokens (`http://`, `https://`), home-directory tokens (`~/`), Windows-env tokens (`%APP`), and bare identifiers with no `/` that do not exactly match ROOT_FILES are all excluded here as corollaries.
   - **Condition 2 (ROOT_FILES inclusion)**: the normalized token exactly equals one of the following curated root-level tracked files (this set is explicitly enumerated — do NOT expand it without updating BC-X.13.002):
     `ROOT_FILES = { build.rs, Cargo.toml, CHANGELOG.md, CLAUDE.md, deny.toml, README.md, rust-toolchain.toml }`
     These files are git-tracked at the repo root (confirmed by `git ls-files --full-name | grep -v /`) and are stable, citable reference targets. Bare-filename shorthands for files in subdirectories (e.g., `ci.yml` for `.github/workflows/ci.yml`, `adf.rs` for `src/adf.rs`, `fields.json` for a cache file) are NOT in ROOT_FILES and remain excluded.

   **False-positive-safety rationale**: the ROOT_FILES set is curated via exact-match, not a structural rule. The following categories are intentionally EXCLUDED from ROOT_FILES to prevent false positives:
   - Workflow shorthands: `ci.yml`, `e2e.yml`, `release.yml` → NOT in ROOT_FILES (they are `.github/workflows/` shorthands; checking them at root would false-positive)
   - Cache-file shorthands: `fields.json` → NOT in ROOT_FILES (a cache file shorthand, not a root file)
   - Source-file shorthands: `adf.rs`, `auth.rs`, `view.rs`, `comments.rs`, `refresh_coordinator.rs`, `embedded_oauth.rs` → NOT in ROOT_FILES (`src/` shorthands; covered by the dir-prefix rule if cited correctly)
   - `Cargo.lock` → NOT in ROOT_FILES (`.lock` is not in the recognized extension set at step (d), so it would be excluded there anyway; excluded from ROOT_FILES for consistency)
d. **Extension filter**: after all normalization, the token must end with a recognized file extension: `.md`, `.rs`, `.sh`, `.toml`, `.yml`, `.yaml`. Extensionless tokens (`src/cli/issue`) are excluded here.
e. **Path::exists() check**: only tokens surviving steps (a)-(d) reach this check.

**Cardinality note (F2-Iter5 merged-fixpoint, supersedes F3-MINOR/LOW-1/LOW-2/LOW-3):** BC-X.13.002 now defines 5 top-level pipeline steps (a)–(e). Step (b) is the single unified normalization fixpoint encompassing all former symbol-strip, line-ref-strip, and punctuation-trim rules as ordered sub-steps (1)–(6). Steps (c) and (d) are the two filter gates. Step (e) is the effectful existence check. References to the former (a)–(h) scheme (steps b/c/d/e/f/g/h) are superseded by this canonical (a)–(e) statement.

**Preconditions**:
- `extract_path_citations` is called with the full CLAUDE.md text as a `&str`
- The CLAUDE.md citation conventions described in CLAUDE.md §"Citation form in spec/CLAUDE.md" are in effect (symbol-form `<file>::<fn>`, approximate line `<file>:~NN`)

**Postconditions**:
- Returns `Vec<(String, usize)>` — each entry is `(normalized_path, line_number)` where `line_number` is the 1-based line in the input `doc` where the backtick citation token appears
- No token matching the glob, brace-glob, symbol-form, line-ref, trailing-punct, or section-ref patterns causes a false-positive path-existence failure
- After normalization (stripping in fixpoint step b), the underlying file path (e.g. `src/adf.rs`) IS checked — the guard doesn't skip the file entirely, only strips the disambiguation suffix
- `[docs/x.md]`-style bracket-wrapped tokens are CHECKED (not silently excluded) — fixpoint sub-step (6) strips the unbalanced `]` before the extension filter at step (d) runs
- `(src/config.rs:~42)`-style combined paren-wrapped + line-ref tokens are CHECKED — the merged fixpoint resolves both the leading `(` and the `:~42` suffix across successive passes (F-PASS6-01 fix)

**Invariants**:
- `::` cannot appear in a file path on any supported OS (Windows, macOS, Linux) — stripping `::.*` in sub-step (1) is unambiguous and safe
- A glob/brace-glob pattern (`*`, `{`, `}`) causes skip at step (a), not strip — the base path before the wildcard would be a directory, not a file, and the glob intent is documentation of a naming pattern, not a specific file
- The single unified fixpoint at step (b) is the sole normalization loop — there is no separate per-rule single-pass outside it
- **ROOT_FILES set is immutable without a BC update (F2 amendment):** The curated set `{ build.rs, Cargo.toml, CHANGELOG.md, CLAUDE.md, deny.toml, README.md, rust-toolchain.toml }` is ENUMERATED in BC-X.13.002 step (c). Adding or removing a root file from the set requires updating this BC, the arch-delta, and the verification-delta in the SAME commit. Never expand ROOT_FILES by structural rule (e.g., "all root files with extension X") — the exact-match approach is the false-positive-safety guarantee.
- **ROOT_FILES extension dependency:** Every file in ROOT_FILES must also have a recognized extension per step (d) (`.md`, `.rs`, `.sh`, `.toml`, `.yml`, `.yaml`). `Cargo.lock` is excluded because `.lock` is not in the recognized extension set; if `.lock` were added to the extension filter, `Cargo.lock` could be added to ROOT_FILES. Do not add files to ROOT_FILES whose extension is not in step (d).
- **Case-sensitivity limitation (M-2, v1 documented):** `Path::exists()` uses the host OS's native case sensitivity. On case-insensitive filesystems (macOS HFS+, Windows NTFS), a citation with wrong case (e.g., `Src/adf.rs` instead of `src/adf.rs`) will return true and pass the guard. This is a documented v1 limitation; case-exact readdir validation is deferred to v2.
- **Space-containing paths (L-2, v1 documented):** paths containing spaces are unsupported by the whitespace tokenizer and will be split into multiple fragments. By design; no escape exists in v1.
- **Backslash paths (L-4, v1 documented):** only forward-slash path tokens are recognized. Windows-style `%APPDATA%\jr` paths are excluded by the dir-prefix filter at step (c) and are not checked.
- **Proptest alphabet requirement:** The proptest covering `extract_path_citations` must include `]` alongside `(`, `)`, `[` in its character alphabet, and must include `:`, `~` to exercise the line-ref strip sub-step. Architect note: this applies to `VP-CITE-001`'s proptest coverage.

**Edge Cases**:
- EC-CITE-006: Token is `src/adf.rs::tests::test_bare_url_split_by_emphasis_links_only_leading_run` — fixpoint pass 1 sub-step (1) strips from first `::` → `src/adf.rs` → stable → checked → pass
- EC-CITE-007: Token is `src/config.rs:~42` — fixpoint pass 1 sub-step (2) strips `:~42` → `src/config.rs` → stable → checked → pass
- EC-CITE-008: Token is `.factory/specs/prd/bc-*.md` — contains `*` → skip entirely at step (a) → no false positive
- EC-CITE-009: Token is `docs/specs/e2e-live-jira-testing.md §9` — whitespace tokenization yields `docs/specs/e2e-live-jira-testing.md` (checked) and `§9` (excluded by dir-prefix filter at step c) → pass
- EC-CITE-010: Token is `adf::tests::test_bare_url_split` — has `::` but NO known directory prefix in the portion before `::` — after fixpoint strip `adf` has no known prefix → excluded by dir-prefix filter at step (c)
- EC-CITE-011: Token is `src/cli/issue` (no extension, from hypothetical prose) — fixpoint leaves token unchanged; no recognized extension after normalization → excluded by extension filter at step (d)
- EC-CITE-012 (trailing punct): Token is `src/adf.rs,` from a comma-delimited `Detail:` line — fixpoint sub-step (4) trims trailing comma → `src/adf.rs` → checked → pass
- EC-CITE-013 (brace-glob): Token is `adf-{block,task}-list.md` — contains `{` and `}` → skip at step (a) → no false positive
- EC-CITE-014 (unbalanced paren — leading punct): Token is `(src/adf.rs)` from prose — fixpoint pass 1: sub-step (3) strips leading `(` → `src/adf.rs)`; sub-step (5) `count('(')=0 < count(')')=1` → strips `)` → `src/adf.rs`; pass 2: stable → passes dir-prefix filter (step c) → checked. Outcome: CHECKED (no false negative).
- EC-CITE-015 (balanced paren — no leading punct): Token is `src/types/assets/mod.rs(foo)` (hypothetical) — no leading `(` or `[` to strip at sub-step (3); sub-step (5): `count('(')=1, count(')')=1` → balanced → NOT trimmed; fixpoint: stable → token remains `src/types/assets/mod.rs(foo)` → extension filter at step (d) excludes it (no recognized terminal extension after `)`) → excluded, no false positive. Outcome: EXCLUDED (correct; the `(foo)` suffix is not a real file path).
- EC-CITE-016 (fenced block, M-1): Token appears inside a triple-backtick fenced code block → not extracted (only inline single-backtick spans are processed) → never checked
- EC-CITE-023 (`[`/`]` symmetric trim, LOW-1): Token is `[docs/x.md]` — fixpoint pass 1: sub-step (3) strips leading `[` → `docs/x.md]`; sub-step (6) `count('[')=0 < count(']')=1` → strips `]` → `docs/x.md`; pass 2: stable → passes dir-prefix + extension filters → CHECKED. Without sub-step (6), the `.md]` suffix fails the extension filter and the citation is silently excluded — a latent false-negative.
- EC-CITE-024 (mixed trailing punct, LOW-2): Token is `(src/adf.rs).` — fixpoint pass 1: sub-step (3) strips `(` → `src/adf.rs).`; sub-step (4) strips `.` → `src/adf.rs)`; sub-step (5) `count('(')=0 < count(')')=1` → strips `)` → `src/adf.rs`; pass 2: stable → checked. Demonstrates sub-step (4) plain-punct stripping runs before the bracket balance checks within one pass.
- EC-CITE-025 (double-wrap, LOW-3): Token is `((src/x.rs))` — fixpoint pass 1: sub-step (3) strips leading `(` → `(src/x.rs))`; sub-step (5) `count('(')=1, count(')')=2` → strips one `)` → `(src/x.rs)`; pass 2: sub-step (3) strips `(` → `src/x.rs)`; sub-step (5) `count('(')=0, count(')')=1` → strips `)` → `src/x.rs`; pass 3: stable → checked. Single-fixpoint rule handles arbitrarily nested wraps deterministically.
- EC-CITE-026 (paren-wrap + line-ref — F-PASS6-01 fix): Token is `(src/config.rs:~42)` — fixpoint pass 1: sub-steps (1)/(2) find no suffix to strip (still has leading `(`); sub-step (3) strips leading `(` → `src/config.rs:~42)`; sub-step (5) `count('(')=0 < count(')')=1` → strips `)` → `src/config.rs:~42`; pass 2: sub-step (2) strips `:~42` → `src/config.rs`; pass 3: stable → checked → pass. Under the former separated pipeline this token was a false-negative: the one-shot line-ref strip ran on `(src/config.rs:~42)` (no match, trailing `)`), leaving `:~42` after paren trim completed.
- EC-CITE-027 (line-ref + trailing comma): Token is `src/api/client.rs:195,` — fixpoint pass 1: sub-step (4) strips trailing `,` → `src/api/client.rs:195`; pass 2: sub-step (2) strips `:195` → `src/api/client.rs`; pass 3: stable → checked → pass.
- EC-CITE-028 (symbol-form + trailing punct): Token is `src/foo.rs::bar().` — fixpoint pass 1: sub-step (1) strips from first `::` → `src/foo.rs`; sub-steps (2)-(6) find nothing to strip on `src/foo.rs`; pass 2: stable → checked → pass. (The trailing `.` is inside the `::bar().` suffix and is eliminated together with it by sub-step (1); no separate plain-punct pass is needed.)
- EC-CITE-029 (ROOT_FILES inclusion — Cargo.toml): Token is `Cargo.toml` — no known dir prefix; exactly matches ROOT_FILES member → IN-SCOPE at step (c) → passes extension filter at step (d) (`.toml`) → checked. `Cargo.toml` exists at repo root → pass. Demonstrates that root-level file citations without a dir prefix ARE checked when in ROOT_FILES.
- EC-CITE-030 (ROOT_FILES exclusion — ci.yml shorthand): Token is `ci.yml` — no known dir prefix; does NOT exactly match any ROOT_FILES member → EXCLUDED at step (c). The file `.github/workflows/ci.yml` exists, but the bare `ci.yml` shorthand is a path shorthand, not a root file; checking it at root would false-positive. Correct citation is `.github/workflows/ci.yml`.
- EC-CITE-031 (ROOT_FILES exclusion — adf.rs shorthand): Token is `adf.rs` — no known dir prefix; does NOT exactly match any ROOT_FILES member (`adf.rs` is a shorthand for `src/adf.rs`, not a root file) → EXCLUDED at step (c). No false positive. The correct citation is `src/adf.rs` (which IS in-scope via the dir-prefix rule).
- EC-CITE-032 (ROOT_FILES paren-wrapped — punctuation interaction): Token is `(Cargo.toml)` — fixpoint pass 1: sub-step (3) strips leading `(` → `Cargo.toml)`; sub-step (5) `count('(')=0 < count(')')=1` → strips `)` → `Cargo.toml`; pass 2: stable. Now no dir prefix, but exactly matches ROOT_FILES member → IN-SCOPE at step (c) → passes extension filter at step (d) (`.toml`) → CHECKED. `Cargo.toml` exists at repo root → pass. **Load-bearing interaction:** confirms that punctuation unwrapping (step b) runs BEFORE the ROOT_FILES exact-match test (step c) — a token like `(Cargo.toml)` reaches the ROOT_FILES check only after the fixpoint strips its parens. Proptest note: the proptest alphabet must include `(` and `)` to exercise this interaction (i.e., generate `(Cargo.toml)` class inputs); the architect should add a `Cargo.toml` (or any ROOT_FILES member) with paren wrapping to the VP-CITE-001 proptest alphabet so the wrap+exact-match interaction is exercised by random inputs.

**Canonical Test Vectors** (for `extract_path_citations` unit tests; returned type is `Vec<(String, usize)>` — tests assert on the path component of each tuple):

| Raw backtick content | Extracted path (after normalization) | Checked? |
|---------------------|-------------------------------------|---------|
| `src/adf.rs::push_text` | `src/adf.rs` (fixpoint sub-step (1) strips `::push_text`) | YES |
| `src/config.rs:~42` | `src/config.rs` (fixpoint sub-step (2) strips `:~42`) | YES |
| `.factory/specs/prd/bc-*.md` | (skipped — contains `*`, step a) | NO |
| `adf-{block,task}-list.md` | (skipped — contains `{`, step a) | NO |
| `docs/specs/e2e-live-jira-testing.md` | `docs/specs/e2e-live-jira-testing.md` | YES |
| `adf::tests::test_bare_*` | (skipped — contains `*`, step a) | NO |
| `std::sync::Mutex<HashMap>` | (excluded — no known dir prefix, step c) | NO |
| `src/api/jsm/servicedesks.rs::require_service_desk` | `src/api/jsm/servicedesks.rs` (fixpoint sub-step (1)) | YES |
| `.factory/research/S-3.03-wave3-verification.md` | (excluded — `.factory/` prefix, step c) | NO |
| `src/config.rs,` | `src/config.rs` (fixpoint sub-step (4) trims trailing comma) | YES |
| `(src/adf.rs)` | `src/adf.rs` (fixpoint: sub-step (3) strips `(`; sub-step (5) strips unbalanced `)`) | YES |
| `src/types/assets/mod.rs(foo)` | excluded (fixpoint: `)` is balanced → not stripped; no recognized extension after `)`, step d) | NO |
| `[docs/x.md]` | `docs/x.md` (fixpoint: sub-step (3) strips `[`; sub-step (6) strips unbalanced `]`) | YES |
| `(src/adf.rs).` | `src/adf.rs` (fixpoint pass 1: sub-step (3) strips `(` → `src/adf.rs).`; sub-step (4) strips `.` → `src/adf.rs)`; sub-step (5) strips `)` → `src/adf.rs`; pass 2: stable) | YES |
| `((src/x.rs))` | `src/x.rs` (fixpoint pass 1: sub-step (3) strips `(` → `(src/x.rs))`; sub-step (5) strips one `)` → `(src/x.rs)`; pass 2: sub-step (3) strips `(` → `src/x.rs)`; sub-step (5) strips `)` → `src/x.rs`; pass 3: stable) | YES |
| `(src/config.rs:~42)` | `src/config.rs` (fixpoint pass 1: sub-step (3) strips `(` → `src/config.rs:~42)`; sub-step (5) strips `)` → `src/config.rs:~42`; pass 2: sub-step (2) strips `:~42` → `src/config.rs`; pass 3: stable — NEW, EC-CITE-026, F-PASS6-01 fix) | YES |
| `src/api/client.rs:195,` | `src/api/client.rs` (fixpoint pass 1: sub-step (4) strips `,` → `src/api/client.rs:195`; pass 2: sub-step (2) strips `:195` → `src/api/client.rs`; pass 3: stable — NEW, EC-CITE-027) | YES |
| `src/foo.rs::bar().` | `src/foo.rs` (fixpoint pass 1: sub-step (1) strips `::bar().` → `src/foo.rs`; pass 2: stable — NEW, EC-CITE-028) | YES |
| `Cargo.toml` | `Cargo.toml` (no dir prefix; exactly matches ROOT_FILES member → step (c) passes; `.toml` passes step (d) → checked — NEW, EC-CITE-029) | YES |
| `ci.yml` | excluded (no dir prefix; NOT in ROOT_FILES — bare shorthand for `.github/workflows/ci.yml`; step (c) excludes — NEW, EC-CITE-030) | NO |
| `adf.rs` | excluded (no dir prefix; NOT in ROOT_FILES — shorthand for `src/adf.rs`; step (c) excludes — NEW, EC-CITE-031) | NO |
| `(Cargo.toml)` | `Cargo.toml` (fixpoint pass 1: sub-step (3) strips `(` → `Cargo.toml)`; sub-step (5) strips unbalanced `)` → `Cargo.toml`; pass 2: stable → exactly matches ROOT_FILES member → step (c) passes; `.toml` passes step (d) → checked — NEW, EC-CITE-032) | YES |
| `fields.json` | excluded (no dir prefix; NOT in ROOT_FILES — cache-file shorthand; step (c) excludes) | NO |
| `release.yml` | excluded (no dir prefix; NOT in ROOT_FILES — `.github/workflows/` shorthand; step (c) excludes) | NO |

**Verification Properties**:
- VP-CITE-001: `extract_path_citations` grammar — unit + proptest coverage of all normalization/exclusion rules including glob-skip at step (a) (with `{`/`}`), merged-fixpoint at step (b) (symbol-form strip sub-step 1, line-ref strip sub-step 2, leading-bracket strip sub-step 3, plain-punct trim sub-step 4, unbalanced `)` trim sub-step 5, unbalanced `]` trim sub-step 6), dir-prefix filter and ROOT_FILES inclusion at step (c) (curated set: `build.rs`, `Cargo.toml`, `CHANGELOG.md`, `CLAUDE.md`, `deny.toml`, `README.md`, `rust-toolchain.toml`; bare shorthands `ci.yml`, `adf.rs`, `fields.json`, `release.yml` excluded), extension filter at step (d); no false positives on any documented edge cases including combined paren-wrap + line-ref tokens (EC-CITE-026) and ROOT_FILES shorthands (EC-CITE-029..031). See `verification-delta-DEAD-CITATION-CI.md` §VP-CITE-001.

**Traceability**:
- F1 Delta Analysis: `DEAD-CITATION-CI-delta-analysis.md` §5b OUT-OF-SCOPE, §6 Risk 1/2/3/4
- Research: `maint-pg-dead-citation-ci-approach.md` §(d) grammar rules 4/5
- Implementing story: S-MAINT-DEAD-CITATION-CI (F3)
- Source: `tests/claude_md_citations.rs::extract_path_citations` (new function; returns `Vec<(String, usize)>`; has inline `#[cfg(test)]` unit tests)

[REVISED 2026-06-19 F2-Iter5 F-PASS6-01] Merged the formerly separate symbol-form-strip step (b), line-ref-strip step (c), and punctuation-trim fixpoint step (e) into ONE unified normalization fixpoint as step (b) with ordered sub-steps (1)–(6). Pipeline is now (a)–(e) instead of (a)–(h). Root cause: under the former separated pipeline, a token like `(src/config.rs:~42)` caused a false-negative — the one-shot line-ref strip (former step c) ran when the token still had its leading `(`, so `:~42$` didn't match the trailing `)`, and after paren-trim completed the `:~42` residue was left unchecked. The merged single-fixpoint eliminates this ordering-class entirely by re-running all sub-steps until stable. Step (d) (section-ref) was always a no-op code marker — it is now folded into the extraction preamble prose. References to former steps (a)–(h) in external docs (arch-delta, verification-delta) have been propagated (F2-Iter6 step-letter propagation sweep, 2026-06-19).

---

#### BC-X.13.003: ALL `.factory/` paths are excluded from the guard; `.factory/` is absent from the CI checkout; the dead-citation class for `.factory/` is covered by the maintenance doc-drift sweep, NOT this guard

**Confidence**: HIGH
**Subject**: CI guard / directory scope
**Behavior**: The guard's step (c) filter (BC-X.13.002) recognizes ONLY the following as in-scope: tokens starting with develop-tracked directory prefixes (`src/`, `tests/`, `docs/`, `.github/`, `scripts/`) OR tokens exactly matching the ROOT_FILES set (`build.rs`, `Cargo.toml`, `CHANGELOG.md`, `CLAUDE.md`, `deny.toml`, `README.md`, `rust-toolchain.toml`). `.factory/` is NOT in either category — it is not a develop-tracked directory prefix and not a ROOT_FILES member. As a result, ALL `.factory/` citations — regardless of sub-path (`specs/`, `research/`, `holdout-scenarios/`, `cycles/`, or any other) — are excluded by the step (c) filter and never reach the `Path::exists()` check. The ROOT_FILES addition (F2 amendment 2026-06-19) does not affect `.factory/` exclusion — `.factory/` paths begin with `.factory/` not with any ROOT_FILES exact-match string.

**Rationale:** `.factory/` is git-ignored in the develop working tree and lives in a separate orphan-branch worktree (`factory-artifacts`). It is ABSENT from a normal `git checkout develop` or any CI checkout of `develop`. There is no sub-path partition within `.factory/` that is tracked on develop — the old "off-branch allowlist" design (which checked `.factory/research/` but allowlisted `.factory/specs/`) was based on an incorrect premise (`.factory/research/` is also absent from the CI checkout). That design is SUPERSEDED by this all-exclude rule.

Dead-citation coverage for `.factory/` paths is handled by the maintenance doc-drift sweep, which runs with access to the `factory-artifacts` worktree and can check factory-spec citations against their actual content.

There is NO `is_off_working_branch_allowlisted` function in the final implementation — the old allowlist concept is replaced by the simpler and correct dir-prefix exclusion rule.

**Preconditions**:
- The checked-out working tree is `develop` (or a feature branch off `develop`), produced by a standard `git checkout`
- `.factory/` is NOT present in this working tree (it is git-ignored and lives only in the orphan-branch worktree)

**Postconditions**:
- ANY CLAUDE.md citation starting with `.factory/` (e.g., `.factory/specs/prd/bc-3-issue-write.md`, `.factory/research/S-3.03-wave3-verification.md`, `.factory/holdout-scenarios/H-001.md`) does NOT cause the guard to fail — it is excluded by the step (c) filter before any existence check
- The guard only fails for dead citations that are either: (a) in develop-tracked directories (`src/`, `tests/`, `docs/`, `.github/`, `scripts/`) or (b) exact members of ROOT_FILES (`build.rs`, `Cargo.toml`, `CHANGELOG.md`, `CLAUDE.md`, `deny.toml`, `README.md`, `rust-toolchain.toml`) that do not exist at the repo root

**Invariants**:
- The dir-prefix filter is the single mechanism for `.factory/` exclusion — no allowlist function is needed or implemented
- Adding a new develop-tracked directory (e.g., `benchmarks/`) requires updating the dir-prefix filter in `extract_path_citations`; adding a new `.factory/` sub-path requires NO guard change
- The maintenance doc-drift sweep (not this guard) is the responsible party for `.factory/` citation health

**Edge Cases**:
- EC-CITE-017: CLAUDE.md cites `.factory/research/S-3.03-wave3-verification.md` → prefix `.factory/` → excluded by dir-prefix filter → not checked → no failure (supersedes the old "NOT allowlisted → checked" behavior)
- EC-CITE-018: CLAUDE.md cites `.factory/specs/prd/bc-3-issue-write.md` → prefix `.factory/` → excluded by dir-prefix filter → not checked → no false positive (same result as old allowlist, but via dir-prefix exclusion not allowlist lookup)
- EC-CITE-019: CLAUDE.md cites `.factory/holdout-scenarios/H-001.md` → prefix `.factory/` → excluded by dir-prefix filter → not checked → no false positive
- EC-CITE-020: CLAUDE.md cites `.factory/cycles/cycle-01.md` → prefix `.factory/` → excluded by dir-prefix filter → not checked → no false positive
- EC-CITE-021: A future CLAUDE.md citation uses a new `.factory/` sub-path not previously seen → still excluded (prefix rule; no allowlist update needed)

**Canonical Test Vectors** (for `extract_path_citations` step (c) filter unit tests):

| Path | Excluded by step (c) filter? | Rationale |
|------|------------------------------|-----------|
| `.factory/specs/prd/bc-3-issue-write.md` | YES | `.factory/` not in develop-tracked prefix set; not in ROOT_FILES |
| `.factory/holdout-scenarios/H-001.md` | YES | `.factory/` not in develop-tracked prefix set; not in ROOT_FILES |
| `.factory/cycles/cycle-01.md` | YES | `.factory/` not in develop-tracked prefix set; not in ROOT_FILES |
| `.factory/research/S-3.03-wave3-verification.md` | YES | `.factory/` not in develop-tracked prefix set; not in ROOT_FILES |
| `docs/adr/0016-windows-build-target.md` | NO | `docs/` is develop-tracked; existence is checked |
| `src/adf.rs` | NO | `src/` is develop-tracked; existence is checked |
| `.github/workflows/ci.yml` | NO | `.github/` is develop-tracked; existence is checked |
| `Cargo.toml` | NO | Exactly matches ROOT_FILES member; existence is checked (F2 amendment) |
| `CLAUDE.md` | NO | Exactly matches ROOT_FILES member; existence is checked (F2 amendment) |
| `build.rs` | NO | Exactly matches ROOT_FILES member; existence is checked (F2 amendment) |
| `ci.yml` | YES | NOT in ROOT_FILES (`.github/workflows/` shorthand); NOT a develop-tracked prefix token (F2 amendment) |

**Verification Properties**:
- VP-CITE-002: Integration self-verification — `test_claude_md_citations_resolve_to_real_files` passes green on develop HEAD; `.factory/` citations never trigger failures; fixture-based `test_dead_citation_detected_in_fixture` verifies develop-tracked dead citations ARE detected. See `verification-delta-DEAD-CITATION-CI.md` §VP-CITE-002.

**Traceability**:
- F1 Delta Analysis: `DEAD-CITATION-CI-delta-analysis.md` §5c (superseded by re-scope)
- Re-scope decision: DEAD-CITATION-CI F2 Iteration 2 (2026-06-19, human-approved)
- Implementing story: S-MAINT-DEAD-CITATION-CI (F3)
- Source: `tests/claude_md_citations.rs::extract_path_citations` (returns `Vec<(String, usize)>`; dir-prefix filter — `.factory/` absence from prefix set)

---

#### BC-X.13.004: Every `src/` file path cited in a `**Trace**:` or `**Source**:` field of any bc-*.md body resolves to a real on-disk file in the develop checkout; guard exits 1 listing all dead references with collect-all semantics; fail-closed SCOPE-EMPTY guard; coverage floor = floor(0.75 × N) ≈ 248 in CANONICAL_MODE

**Confidence**: HIGH
**Subject**: CI guard / Trace/Source file-existence (Guard 1)

**Behavior**: `scripts/check-bc-citation-symbols.sh` (Guard 1) scans all `bc-*.md` files in `.factory/specs/prd/` by running in the `spec-guard` CI job, which simultaneously mounts the develop checkout (containing `src/`) and the `factory-artifacts` worktree (containing `.factory/specs/prd/bc-*.md`). For each `bc-*.md` file, every line matching the anchor `^\*\*(Trace|Source)\*\*:` is extracted. From those lines, all backtick-quoted `src/` citation tokens are extracted via the space-tolerant two-pass extractor (see BC-X.13.005 Step 1 for the canonical extraction spec and normalization pipeline). Each extracted token is normalized to a bare file path (stripping `::symbol`, `:~NN`/`:NN` suffixes, and space-trailing content via the first-space split of Step 1 Pass 2 — see BC-X.13.005 Steps 1–3) and checked for file existence at `$src_root/$file`. Tokens with `::symbol` suffix additionally undergo a symbol-definition check (see BC-X.13.005 Step 5). Dead citations are accumulated into an offenders list without early exit — ALL citations in ALL bc-*.md files are checked before reporting (collect-all semantics, matching BC-X.13.001's approach). **Fail-closed SCOPE-EMPTY guard**: if no `bc-*.md` files are found in the bc_dir, the guard exits 1 immediately with `BC-CITE-001: no bc-*.md files found in <dir>` — the guard NEVER exits 0 vacuously on an empty corpus. **Coverage floor (CANONICAL_MODE only)**: after processing all citations, if the total count of checked `src/` citations is below `FLOOR = floor(0.75 × N)` — where N is the measured citation count on develop HEAD at delivery time; the F-B3-03 recalibration (post-Task-0-hygiene census) yields N ≈ 331, FLOOR ≈ 248 (implementer remeasures at delivery; pre-hygiene DEC-154 census: N=326, FLOOR=244) — the guard exits 1 with `BC-CITE-COVERAGE-FLOOR: expected >= <FLOOR> src/ citations, got <N>. Update FLOOR when citations are intentionally removed (the floor is a lower bound; additions never fire it).` This floor guards against the fail-open scenario where an extraction-logic regression (e.g., bc_dir misconfiguration or regex change) silently drops all citations and exits 0 vacuously. `FLOOR` is declared once at script scope (top-level assignment, not `local` inside any function) — this is the single recalibration touchpoint; update it there when intentionally removing citations. `CANONICAL_MODE` is set to 1 at script entry when neither `--self-test` nor `--bc-dir` is supplied, and 0 otherwise; it is also a script-scope variable (see Invariants).

**Preconditions**:
- `scripts/check-bc-citation-symbols.sh` runs in the `spec-guard` CI job, which mounts both the develop checkout (`src/` tree available) and the `factory-artifacts` worktree (`.factory/specs/prd/bc-*.md` available); see BC-X.13.006 for CI topology
- At least one `bc-*.md` file exists in the bc_dir (fail-closed if not — SCOPE-EMPTY guard)
- `src/` paths cited in Trace/Source fields reference files tracked on develop HEAD at the time the citation was written

**Postconditions (on success)**:
- Guard exits 0; prints `Check passed: N citations checked` (N ≥ FLOOR when CANONICAL_MODE=1)
- Every `src/` file path extracted from a Trace/Source line in any bc-*.md file resolves to a real file under `$src_root`
- Every `src/file.rs::symbol` citation has the symbol present as a definition (not merely an import) in the referenced file (see BC-X.13.005 Step 5)

**Postconditions (on failure)**:
- Guard exits 1
- Dead citations are reported as one or more of:
  - `DEAD: <file> not found` — file path does not exist on disk
  - `DEAD: <symbol> not found in <file>` — file exists but symbol definition absent (see BC-X.13.005)
  - `DEAD: malformed citation skipped: <token>` — extracted token fails path shape guard (BC-X.13.005 Step 3b)
  - `BC-CITE-COVERAGE-FLOOR: expected >= <FLOOR> src/ citations, got <N>. Update FLOOR when citations are intentionally removed (the floor is a lower bound; additions never fire it).` (CANONICAL_MODE=1 only)
- Summary line (non-floor failures): `<K> stale citation(s) found in bc-*.md Trace/Source fields`
- ALL dead citations across ALL bc-*.md files are reported before exit (collect-all; no early termination)

**Invariants**:
- The guard runs in the spec-guard CI job on every PR touching develop, regardless of whether the PR modifies bc-*.md files — drift is caught at the NEXT spec-guard run after the referenced file is deleted or symbol moved
- `FLOOR` is a script-scope variable, NOT a `local` inside `run_check` (single declaration at script top — the single recalibration touchpoint). Because `FLOOR` is script-scope, self-test Fixture G can set `CANONICAL_MODE=1` in the shell environment and invoke `run_check` with an undersupply of citations, whereupon the comparison `[ "$total_citations" -lt "$FLOOR" ]` resolves the SAME `FLOOR` the guard uses — making the mutation-catching guarantee sound. A mutation that hardens the comparison to a literal (e.g., replaces `"$FLOOR"` with `"5"` in the comparison while leaving `"expected >= ${FLOOR}"` unchanged) is caught by Fixture G: the guard no longer exits 1 for a 100-citation undersupply (100 ≥ 5), so Fixture G sees exit 0 where it expects exit 1, catching the weakening. `FLOOR` uses the symbol in BOTH the comparison AND the message interpolation — they share the same script-scope binding.
- `CANONICAL_MODE` is a script-scope variable, NOT a `local` inside `run_check`; the Fixture G toggle mechanism (`CANONICAL_MODE=1` set in shell scope before invoking `run_check`) requires this to work correctly — if `CANONICAL_MODE` were `local`, Fixture G's toggle would be a no-op and the floor guard would false-green

**Edge Cases**:
- EC-CITE-033: No bc-*.md files in bc_dir → exit 1 immediately; `BC-CITE-001: no bc-*.md files found in <dir>` (SCOPE-EMPTY guard; never false-green on empty corpus)
- EC-CITE-034: bc-*.md files exist but have no Trace/Source lines → 0 citations extracted → CANONICAL_MODE floor guard fires (0 < FLOOR) → exit 1; non-CANONICAL_MODE → exit 0 (bc-*.md with no Trace/Source fields is unusual but not invalid)
- EC-CITE-035: Multiple backtick-quoted `src/` tokens on one Trace/Source line → each extracted independently; all checked; all offenders accumulated (collect-all)
- EC-CITE-036: A file cited in Trace/Source was deleted or renamed without updating the BC body → `DEAD: <file> not found` → guard fires deterministically on the next spec-guard run
- EC-CITE-037: Total citation count drops below FLOOR in CANONICAL_MODE (e.g., large BC refactor removes many Trace/Source lines) → `BC-CITE-COVERAGE-FLOOR:` message; developer updates `FLOOR=N` (script-scope assignment at script top — the single recalibration touchpoint) to the new validated baseline in the same commit

**Canonical Test Vectors**:

| Input (Trace/Source line content) | Expected outcome |
|-----------------------------------|-----------------|
| `**Trace**: \`src/cli/issue/edit.rs::handle_edit\`` (file exists, fn defined) | Pass — file exists, symbol check passes (BC-X.13.005) |
| `**Trace**: \`src/cli/issue/create.rs::handle_jsm_create\`` (file exists, fn only in import) | DEAD: handle_jsm_create not found in src/cli/issue/create.rs |
| `**Source**: \`src/cache.rs\`` (file exists, bare path) | Pass — bare file, existence check only |
| `**Trace**: \`src/nonexistent.rs::some_fn\`` (file absent) | DEAD: src/nonexistent.rs not found |
| No bc-*.md files in bc_dir | Exit 1; BC-CITE-001: no bc-*.md files found in \<dir\> |
| 0 citations extracted, CANONICAL_MODE=1, FLOOR=248 | Exit 1; BC-CITE-COVERAGE-FLOOR: expected >= 248 src/ citations, got 0 |

**Verification Properties**:
- VP-BC-CITE-001: File-existence assertion — every Trace/Source `src/` citation in bc-*.md is checked against the develop src/ tree; dead citations reported collect-all; SCOPE-EMPTY guard fires on empty corpus; coverage floor fires in CANONICAL_MODE when count < FLOOR. Covered by `scripts/check-bc-citation-symbols.sh --self-test` Fixtures B, D, F, G (S-BC-CITATION-GUARD-1 AC-002).
- VP-BC-CITE-002: Integration self-verification — guard exits 0 on develop HEAD with factory-artifacts mounted; Fixture G proves CANONICAL_MODE floor guard is active and FLOOR symbol is bound in both comparison and message.

**Traceability**:
- Implementing story: S-BC-CITATION-GUARD-1 (CITATION-GUARDS Story B, issue #102)
- Root-cause cycle: DEC-148 (12 stale Trace/Source citations in bc-3-issue-write.md after ADR-0012 Seam A/B; ~30 adversarial passes to hand-fix)
- F1 delta analysis: `.factory/phase-f1-delta-analysis/citation-guards-2026-07-02-delta.md §2`
- Error taxonomy: BC-CITE-001 (Section 8 of error-taxonomy.md)
- Source: `scripts/check-bc-citation-symbols.sh::run_check` (new file; CI script — not in `src/`)

---

#### BC-X.13.005: Extraction grammar for Guard 1 Trace/Source `src/` citation tokens — canonical extraction regex; `::symbol` form normalization; definition-anchored `fn`-grep for function symbols; v1-pragmatic shape-split (Type::method + constants); glob citation silent-skip; type-def/module-def checks deferred to v2

**Confidence**: HIGH
**Subject**: CI guard / Trace/Source citation extraction grammar (Guard 1)

**Behavior**: The `run_check` function in `scripts/check-bc-citation-symbols.sh` applies the following pipeline to each Trace/Source line (lines matching `^\*\*(Trace|Source)\*\*:` anchor), in this exact order:

**Step 1 — Extraction**: From each Trace/Source line, all backtick-quoted tokens starting with `src/` are extracted via a space-tolerant two-pass extractor (DEC-154 F-B2-02 fix):

- **Pass 1** — extract every full backtick-quoted token that begins with `src/`, including internal spaces: `` grep -oE '`src/[^`]+`' | tr -d '`' `` — MUST be `|| true`-guarded at the call site (i.e., `… | tr -d '`' || true`) so zero-match Trace/Source lines return empty string rather than aborting under `set -euo pipefail`; zero matches is a legitimate state that must flow to the SCOPE-EMPTY/coverage-floor guards, not abort extraction (Story A pipefail-safety precedent)
- **Pass 2** — for each extracted token, split on the first space (if present) and keep only the portion before the space. This correctly reduces: `` `src/file.rs § "section"` `` → `src/file.rs`; `` `src/config.rs:269-282, 308-310` `` → `src/config.rs:269-282` (further reduced at Step 2 line-ref strip); `` `src/api/jira/issues.rs::add_comment(internal: bool)` `` → `src/api/jira/issues.rs::add_comment(internal:` (Step 5 strip-from-first-`(` normalizes to `add_comment`).
- **Pass 2 — comma-lineref normalization**: after the space-split, strip any trailing `, NN` or `, NN-MM` groups that appear in the file component (comma-space line-ref list form, e.g., `src/cache.rs:7, 30-32` → after space-split already reduced to `src/cache.rs:7`; Step 2 line-ref strip then reduces to `src/cache.rs`).

**Why the fix matters**: the prior single-pass regex `` `src/[^` ]+` `` used a stop-on-backtick-OR-space character class. Any backtick-quoted token containing an internal space (10 comma-space line-ref lists + 1 fn-with-space-args, 11 tokens total in the corpus) failed to match at all and was silently dropped — these citations were neither checked nor counted. The two-pass form recovers all 11 tokens. N increases from ~315 to ~326; FLOOR increases from 236 to 244 (adjudication §4 census, 2026-07-06).

**Step 2 — Form classification**: Each extracted token is classified:
- **`::symbol` form**: `file="${token%%::*}"` (strip at first `::` → bare file path); `symbol="${token##*::}"` (last `::` strip → symbol name). If `file == token` (no `::`), the token has no symbol component — treat as bare-file form.
- **`:~NN` or `:NN`/`:NN-MM` form** (line-ref suffix): `file="${token%%:*}"` (strip at first `:`); treated as bare-file form after stripping.
- **Bare file**: `file = $token`.

**Step 3 — Path shape validation**: Validate `file` against `^src/[a-zA-Z0-9_/.-]+\.rs$`; reject path-traversal (`..`). Malformed → emit `DEAD: malformed citation skipped: <token>` (continue; do NOT exit early). **Glob-citation silent-skip (EC-011 class)**: if the file component contains `*` (e.g., `src/cli/**/*.rs` from a Trace/Source line referencing a directory pattern) → silently skip with no DEAD message. This mirrors BC-X.13.002 step (a)'s glob-skip rule: glob tokens document naming patterns, not specific files, and must not be DEAD-flagged.

**Step 4 — File-existence check**: `[ -f "$src_root/$file" ]` — if fails, emit `DEAD: <file> not found`; continue (do not attempt symbol check for a missing file).

**Step 5 — Symbol check (`::symbol` form only)**: Strip from the first `(` onward from `symbol` before classification (`symbol="${symbol%%\(*}"` — subsumes bare `()` and `(args...)`, e.g., `cache_root()` → `cache_root`; `add_comment(internal: bool)` → `add_comment`; `from_config()` → `from_config`). Then apply the v1-pragmatic shape-split (ratified by research adjudication 2026-07-05, Q4):

(a) **Function / method (primary — applies to all symbols first)**: Definition-anchored grep (the canonical Guard 1 grep, preventing import-only false-greens — the DEC-148 class):
```bash
grep -Eq "^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?((unsafe|const|async|extern[[:space:]]+\"[^\"]*\")[[:space:]]+)*fn[[:space:]]+${symbol}([^[:alnum:]_]|$)" \
    "$src_root/$file"
```
If this grep matches → ALIVE. If it fails → proceed to shape-based routing (b)/(c).

(b) **`::tests` module-path [DEC-154 addition — on fn-grep failure]**: If `symbol` matches `^tests$` (exact — the `mod tests` module-path form such as `src/adf.rs::tests`), run the module-definition anchored grep (verified against all 5 cited files in adjudication §2.1, 5/5 pass):
```bash
grep -Eq '^[[:space:]]*(pub[[:space:]]+)?mod[[:space:]]+tests[[:space:]{]' "$src_root/$file"
```
The `[[:space:]{]` end-anchor requires a space or opening brace after `tests`, preventing false-matches on `mod testsuite` or `mod tests_helpers`. If this grep matches → ALIVE. If it fails → DEAD (no further fallback for the `::tests` shape).

(c) **`::tests::testfn` composition [DEC-154 addition — on fn-grep failure]**: If the full post-file component of the token (everything between `file::` and end of token) matches `^tests::[a-z_][a-z0-9_]*$` (i.e., the token has the form `src/file.rs::tests::testfn`), apply a defense-in-depth composition: (1) run the `mod tests` check from (b) on the file; (2) run the fn-grep from (a) on the final `testfn` symbol. Both must pass → ALIVE. If either fails → DEAD. **Note**: in the current corpus the sole instance (`src/types/assets/linked.rs::tests::display_id_fallback_with_hint`) is also ALIVE via branch (a) alone — test functions are defined with `fn`, so the fn-grep on the final component succeeds independently. Branch (c) is therefore defense-in-depth that confirms the test module exists in addition to the function.

(d) **Constant [was (b) — on fn-grep failure]**: If `symbol` matches `^[A-Z][A-Z0-9_]*$` (all-caps Rust constant convention — uppercase letters, digits, underscores only), apply a secondary anchored grep:
```bash
grep -Eq "^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?(const|static)[[:space:]]+${symbol}[[:space:]:]" \
    "$src_root/$file"
```
The `^[[:space:]]*` line anchor prevents mid-line false-greens — a `const` declaration occurring after non-whitespace content on the same line (e.g., in a doc comment `/// pub const NAME:` or a string literal) would match the unanchored form but is rejected by the anchor. The `(\([^)]*\))?` group captures visibility-restriction suffixes — `pub(crate)`, `pub(super)`, `pub(in path::to::mod)` — so constants like `pub(crate) const MAX_ADF_DEPTH: usize` are matched. The anchor and group together are the operative protection: without the anchor the `(\([^)]*\))?` group alone does not prevent mid-line false-greens; without the group the anchor alone does not handle `pub(crate)` visibility. Without this group, any `pub(crate) const NAME:` declaration would fall through to DEAD (latent false-DEAD for 8+ real declarations in `src/`).
If this grep matches → ALIVE. If it fails → DEAD. **Ordering note**: this branch MUST run before branch (e) — the standalone-CamelCase pattern `^[A-Z][A-Za-z0-9_]*$` also matches UPPER_CASE symbols (e.g., `MAX_ADF_DEPTH` matches both); running (d) first ensures UPPER_CASE symbols are not mis-routed to the type-def grep.

(e) **Standalone CamelCase type [DEC-154 addition — on fn-grep and UPPER_CASE failure]**: If `symbol` matches `^[A-Z][A-Za-z0-9_]*$` (CamelCase — starts with uppercase, body may contain mixed-case letters, digits, underscores; no further `::` separators in the post-file component — forms such as `src/adf.rs::AdfBuilder` or `src/types/jira/bulk.rs::BulkTransitionRequest`), run the type-definition anchored grep (verified against 6/6 cited types in adjudication §2.3):
```bash
grep -Eq "^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?(struct|enum|type|trait|union)[[:space:]]+${symbol}[<[:space:](]" \
    "$src_root/$file"
```
The `[<[:space:](]` end-anchor handles: generics (`struct Foo<T>`), unit-struct brace (`struct Foo {`), tuple struct (`struct Foo(`), and type-alias space (`type Foo =`). If this grep matches → ALIVE. If it fails → DEAD. Because branch (d) has already run, any UPPER_CASE symbol that reaches (e) has already failed the const/static check and is correctly DEAD.

(f) **Type::method [was (c) — on fn-grep failure]**: If the original `::symbol` token has at least two `::` separators AND the component before the last `::` is a CamelCase identifier (suggesting a `Type::method` form such as `src/adf.rs::AdfBuilder::finish`), apply a dual check: (1) run the fn-grep on the method name (last `::` component) in the file; (2) verify the type name (CamelCase component before the last `::`) appears as a type definition: `grep -Eq "(struct|enum|type|trait|impl)[[:space:]]+${type_name}"`. If BOTH sub-checks pass → ALIVE. If either fails → DEAD.

**No permissive fallback**: symbols that do not match any of the 7 branches — (a) fn-grep primary, (b) `::tests` module-path, (c) `::tests::testfn` composition, (d) UPPER_CASE constant, (e) standalone CamelCase type, (f) Type::method, or (7) otherwise DEAD — are classified DEAD. The draft's "secondary `grep -q $symbol`" fallback is intentionally NOT implemented — it false-greens on import-only occurrences (`use super::module::fn_name` matches bare `grep -q "fn_name"`), exactly reopening the DEC-148 class. Fixture C in `--self-test` proves import-only occurrences are correctly DEAD.

**v2 deferrals (explicitly out of scope for v1, superseded by DEC-154 for classes 8/9/10)**:
- Macro citations (`macro_rules! sym`) — no grep primitive added; fall through to DEAD
- `Type::method` correlation: when both sub-checks in (f) fail, the error reports the method as DEAD but does not indicate whether the Type name itself is still valid — correlation reporting deferred
- Continuation-line Trace/Source blocks (class 16 — 5 tokens on bc-3-issue-write.md L1434-1441 and L1555-1559): multi-line Trace/Source fields are not stitched; pre-AC-001 hygiene re-flow of those 5 tokens belongs to the story PR's `files_modified`, not the grammar extension

**Preconditions**:
- Called from within `run_check` with a valid `src_root` pointing to the develop checkout
- The anchor filter `^\*\*(Trace|Source)\*\*:` has already been applied; only Trace/Source lines are processed
- `set -euo pipefail` is active; all `grep` calls that may return exit 1 (zero matches) are guarded with `|| true` to prevent unintended script abort under `pipefail`

**Postconditions**:
- Every extracted token is classified ALIVE or DEAD
- Import-only occurrences of a function name are classified DEAD (fn-grep requires a definition, not a use-site — the DEC-148 class)
- Trailing `(` and any following text (bare `()` or `(args...)` forms) on symbol names does not affect classification — strip-from-first-`(` (`symbol="${symbol%%\(*}"`) is applied before Step 5 classification
- Glob-containing file paths (`*` in path component) are silently skipped — no DEAD message, no false positive
- `§`-form citations (e.g., `` `src/file.rs § "note"` ``) are treated as bare-file existence checks (no symbol verification) — Pass 2 space-split of Step 1 reduces them to `src/file.rs`; the `§` and trailing text are discarded before Steps 2–5

**Invariants**:
- The two-pass extractor (Pass 1: `` grep -oE '`src/[^`]+`' ``, Pass 2: split on first space) is the single source-of-truth extraction pattern; it appears in the script exactly once as the authoritative call (analogous to BC-X.13.002's single-fixpoint principle; Story A F-VA-33-3 finding). The prior single-pass form `` grep -oE '`src/[^` ]+`' `` is superseded by DEC-154 — do not revert to it
- The fn-grep regex uses POSIX ERE (`-E`, not `-P`), POSIX character classes (`[[:space:]]`, `[[:alnum:]]`), and `([^[:alnum:]_]|$)` (not `\b`) for word boundary — BSD grep / macOS portability required (spec-guard runs on ubuntu-latest; `--self-test` SHOULD also pass on macOS for local verification)
- The symbol boundary anchor `([^[:alnum:]_]|$)` prevents substring false-greens: `handle_foobar` is NOT matched by a citation checking for `handle_foo`

**Edge Cases**:
- EC-CITE-038: `src/cli/issue/edit.rs::handle_edit` — `fn handle_edit` is defined in the file → fn-grep matches → ALIVE
- EC-CITE-039: `src/cli/issue/create.rs::handle_jsm_create` — appears only as `use super::jsm_create::{JsmCreateArgs, handle_jsm_create};` → fn-grep fails; not UPPER_CASE; not Type::method → DEAD (the DEC-148 class; Fixture C in `--self-test` pins this)
- EC-CITE-040: `src/adf.rs::AdfBuilder::finish` — Type::method form; method `finish` fn-grep passes; type `AdfBuilder` struct found → ALIVE via (f)
- EC-CITE-041: `src/cli/issue/edit.rs::CROSS_HIERARCHY_HINT` — matches UPPER_CASE pattern → const/static anchored grep → ALIVE via (d)
- EC-CITE-042: `src/cache.rs::cache_root()` — strip-from-first-`(` (`symbol%%\(*`) → `cache_root` → fn-grep matches → ALIVE via (a)
- EC-CITE-043 (glob skip / EC-011 class): `src/cli/**/*.rs` from a bc-*.md Trace/Source line (e.g., bc-7-output-render.md:677 BC-7.3.010) → shape guard detects `*` in path component → silently skipped; no DEAD message; no false positive (research cross-cutting finding F1, 2026-07-05)
- EC-CITE-044: `src/adf.rs:~120` → `:~120` suffix stripped at Step 2 → bare file `src/adf.rs` → file-existence check only; Step 5 does not run
- EC-CITE-045 [F-B2-02 corrected]: `` `src/file.rs § "some section"` `` → Pass 1 extracts the FULL token `src/file.rs § "some section"` (no space-stop); Pass 2 splits on first space → `src/file.rs`; Steps 2–5 process `src/file.rs` as bare-file check only. Under the superseded single-pass regex `` `src/[^` ]+` `` (stop-on-space), the §-form token would have been SILENTLY DROPPED (no match), not reduced to `src/file.rs` — census shows 0 §-form tokens in Trace/Source scope, so this was a latent bug with no observable impact on N
- EC-CITE-051 [F-B1-07 + F-B3-02 — anchor+group]: `src/adf.rs::MAX_ADF_DEPTH` — matches UPPER_CASE pattern; anchored const/static grep `^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?(const|static)[[:space:]]+MAX_ADF_DEPTH[[:space:]:]` finds `pub(crate) const MAX_ADF_DEPTH:` at line-start in `src/adf.rs` → ALIVE via (d). Kill-trace basis: the anchor AND the group together provide the operative protection — (1) with the anchor, removing the `(\([^)]*\))?` group alone reverts to `(pub[[:space:]]+)?`, which no longer matches `pub(crate) const MAX_ADF_DEPTH:` from line start (the `(crate)` suffix is not captured by the simplified pub pattern) → DEAD → mutation caught; (2) removing the `^[[:space:]]*` anchor alone allows mid-line occurrences such as `    // pub const MAX_ADF_DEPTH: usize = 256` (a doc-comment or string literal inside a function body) to match the unanchored form → false-ALIVE. Negative probe expectation: a mock file containing ONLY a doc-comment or string-literal line that mentions `const MAX_ADF_DEPTH:` after non-whitespace content (e.g., `    // pub const MAX_ADF_DEPTH: usize = 256` where `//` precedes the constant text) MUST classify DEAD under the anchored form — the `//` is not whitespace, so after `^[[:space:]]*` the next char is `/`, not `pub` or `const`, and the pattern fails to match. This distinguishes the anchored form from the unanchored mutation, which would match `const MAX_ADF_DEPTH:` anywhere on the line.
- EC-CITE-052 [DEC-154 branch (b) positive]: `src/adf.rs::tests` — symbol == `tests`; mod-tests anchored grep finds `mod tests {` at line 2561 in `src/adf.rs` → ALIVE via (b). Covers 20 corpus occurrences of `src/adf.rs::tests` in bc-7 (adjudication §1.3 class 9). Self-test Fixture I.
- EC-CITE-053 [DEC-154 branch (b) negative]: `src/adf.rs::nonexistent_mod` (fabricated) — symbol `nonexistent_mod` does NOT match `^tests$`; fn-grep fails; does not match any other branch → DEAD. Self-test Fixture J.
- EC-CITE-054 [DEC-154 branch (e) positive]: `src/types/jira/bulk.rs::BulkTransitionRequest` — fn-grep fails (no `fn BulkTransitionRequest`); not `tests`; not `tests::*`; UPPER_CASE check fails (has mixed-case); CamelCase check fires → type-def grep finds `pub struct BulkTransitionRequest {` at line 297 → ALIVE via (e). Self-test Fixture K.
- EC-CITE-055 [DEC-154 branch (e) negative]: `src/adf.rs::NonexistentType` (fabricated) — fn-grep fails; UPPER_CASE fails; CamelCase check fires → type-def grep finds no `struct|enum|type|trait|union NonexistentType` → DEAD.
- EC-CITE-056 [DEC-154 branch (c) — defense-in-depth]: `src/types/assets/linked.rs::tests::display_id_fallback_with_hint` — post-file component is `tests::display_id_fallback_with_hint` (matches `^tests::[a-z_][a-z0-9_]*$`); fn-grep (a) already finds `fn display_id_fallback_with_hint` at line 100 → ALIVE via (a); branch (c) additionally confirms `mod tests` at line 68. Both paths concur: ALIVE.
- EC-CITE-057 [DEC-154 F-B2-02 extraction recovery]: `src/config.rs:269-282, 308-310` on a Trace/Source line — Pass 1 extracts full token `src/config.rs:269-282, 308-310`; Pass 2 splits on first space → `src/config.rs:269-282`; comma-lineref normalization strips trailing `, 308-310` residue if present before Step 2; Step 2 line-ref strip → bare file `src/config.rs` → file-existence check only. Previously silently MISSED by single-pass regex (one of 10 comma-space line-ref list tokens recovered by the fix; adjudication §1.2 class 14).
- EC-CITE-058 [Pre-AC-001 hygiene dependency]: 3 truly-dead citation clusters that the guard CORRECTLY flags as DEAD — (a) `src/cli/auth.rs::*` (~7-8 tokens across bc-7 and bc-1): file does not exist; `auth` was refactored to directory `src/cli/auth/mod.rs` + siblings; (b) `src/cli/assets.rs:303-321` (bc-4): file does not exist; `assets` refactored to `src/cli/assets/`; (c) `src/cli/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` (bc-1): moved to `src/cli/auth/tests/snapshots/`. These are not grammar failures — they are citation hygiene issues that must be resolved in the story PR's `files_modified` list BEFORE Guard 1 can reach GREEN on develop HEAD. The guard flagging them is correct behavior.
- EC-CITE-059 [F-B3-01 class-15 normalization — fn with space args]: `src/api/jira/issues.rs::add_comment(internal: bool)` (bc-3:~2100) — Pass 2 space-split reduces the full backtick-quoted token to `src/api/jira/issues.rs::add_comment(internal:`; Step 5 strip-from-first-`(` (`symbol="${symbol%%\(*}"`) then reduces `add_comment(internal:` → `add_comment`; fn-grep finds `fn add_comment` at `src/api/jira/issues.rs:~579` → ALIVE via (a). Under the prior bare-`()` strip (`symbol="${symbol%()}"`) the symbol `add_comment(internal:` had no trailing `)` to strip — the strip was a no-op → symbol `add_comment(internal:` was emitted to the fn-grep ERE → malformed pattern → DEAD → AC-001 blocked. The F-B3-01 fix (`%%\(*` strip-from-first-`(`) subsumes both the bare-`()` case (EC-CITE-042) and the class-15 space-args case, making the two classes a single strip rule. Note: Fixture F's sub-probe citation must use a SPACE-ARGS form (e.g., `src/mock_f.rs::mock_f_fn_selftest(args: T)`) to give Step-5 strip-from-first-`(` mutation coverage. A bare-`()` form is UNSOUND: under a delete-strip mutation `()` is a valid empty ERE group, so `fn name() {}` still matches → mutation ALIVE → not caught; only the space-args form forces Pass 2 to yield `name(args:` (unbalanced `(`) → fn-grep ERE malformed (grep exits 2) → mutation DEAD → caught. This fixture content detail is story-writer scope (the BC does not pin the exact mock file text).

**Canonical Test Vectors** (for `run_check` Step 5 unit coverage via `--self-test`):

| Token | Form | Step 5 path | Expected |
|-------|------|-------------|---------|
| `src/cli/issue/edit.rs::handle_edit` | ::symbol (function) | fn-grep: `fn handle_edit` | ALIVE |
| `src/cli/issue/create.rs::handle_jsm_create` | ::symbol (import only) | fn-grep fails; not `tests`; not CamelCase; not UPPER_CASE; not Type::method → DEAD | DEAD (Fixture C) |
| `src/adf.rs::AdfBuilder::finish` | Type::method | fn-grep on `finish` + type def for `AdfBuilder` | ALIVE via (f) |
| `src/cli/issue/edit.rs::CROSS_HIERARCHY_HINT` | constant (UPPER_CASE) | const/static anchored grep | ALIVE via (d) |
| `src/cache.rs::cache_root()` | fn with `()` suffix | strip-from-first-`(` → `cache_root` → fn-grep `fn cache_root` | ALIVE via (a) |
| `src/api/jira/issues.rs::add_comment(internal: bool)` (extracted bc-3:~2100) | fn with space args (class-15) | Pass 2 space-split → `add_comment(internal:`; strip-from-first-`(` → `add_comment`; fn-grep | ALIVE via (a) (EC-CITE-059) |
| `src/cli/**/*.rs` | glob | shape guard: `*` in path → silently skip | SKIPPED (no DEAD) |
| `src/adf.rs:~120` | line-ref | stripped at Step 2 → bare file | file-exists check only (Fixture E analog) |
| `src/adf.rs::MAX_ADF_DEPTH` | constant (UPPER_CASE, `pub(crate)`) | anchored const/static grep `^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?` | ALIVE via (d) (EC-CITE-051) |
| `src/adf.rs::tests` | `::tests` module-path | symbol == `tests` → mod-tests anchored grep | ALIVE via (b) (EC-CITE-052; Fixture I) |
| `src/adf.rs::nonexistent_mod` | `::tests` negative | symbol `nonexistent_mod` does not match any branch → DEAD | DEAD (EC-CITE-053; Fixture J) |
| `src/types/jira/bulk.rs::BulkTransitionRequest` | standalone CamelCase type | fn-grep fails; UPPER_CASE fails; CamelCase → type-def grep | ALIVE via (e) (EC-CITE-054; Fixture K) |

**Verification Properties**:
- VP-BC-CITE-001: Extraction grammar coverage — Fixtures A (dead symbol), C (import-only DEAD), E (§-form file-only check), F (success path with fn defined), I (`::tests` module-path ALIVE), J (`::tests` negative DEAD), K (standalone CamelCase ALIVE) in `scripts/check-bc-citation-symbols.sh --self-test` cover all 7 grammar branches. Glob-skip (EC-043), strip-from-first-`(` (EC-042/EC-059), and Type::method (EC-040) are covered by AC-002 Fixtures F variant (Fixture F sub-probe must use a SPACE-ARGS form (e.g., `src/mock_f.rs::mock_f_fn_selftest(args: T)`) to give strip-from-first-`(` mutation coverage — story-writer scope) and the import-only proof. See S-BC-CITATION-GUARD-1 AC-002.

**Traceability**:
- Implementing story: S-BC-CITATION-GUARD-1 (CITATION-GUARDS Story B, issue #102)
- Root-cause analysis: F1 delta analysis §6 — file-existence alone too weak; must check symbol definition; import-only false-green was the DEC-148 root cause
- Research adjudication: `.factory/research/story-b-open-questions-2026-07-05.md` Q4 — v1-pragmatic shape-split (Type::method + constants mandatory; type-def/module-def deferred v2); permissive fallback explicitly rejected
- DEC-154 adjudication: `.factory/research/story-b-grammar-adjudication-2026-07-06.md` — extends v1 grammar with 3 new branches (::tests, ::tests::testfn, standalone CamelCase); space-tolerant two-pass extraction (F-B2-02); FLOOR recalibration N=326, FLOOR=244
- Source: `scripts/check-bc-citation-symbols.sh::run_check` Steps 1–5 (new file; CI script — not in `src/`)

---

#### BC-X.13.006: Guard 1 is GREEN on develop HEAD; RED on stale citation introduction; scope limited to bc-*.md Trace/Source fields; BC-INDEX.md and tests/ citations excluded; CI topology via spec-guard job dual-worktree (develop + factory-artifacts)

**Confidence**: HIGH
**Subject**: CI guard / Guard 1 scope, CI topology, self-verifiability

**Behavior**: Guard 1 (`scripts/check-bc-citation-symbols.sh`) has the following scope, CI topology, and verifiability properties:

**Scope**: The guard scans ONLY lines matching the anchor `^\*\*(Trace|Source)\*\*:` in `bc-*.md` files — lines that begin with exactly `**Trace**:` or `**Source**:` (no leading whitespace; exact markdown bold markup). Citations in BC body prose (Description, Preconditions, Postconditions, Invariants, Examples, Canonical Test Vectors sections), BC frontmatter YAML, and BC-INDEX.md are NOT scanned. `tests/` citation paths on Trace/Source lines are NOT extracted — only `src/`-prefixed backtick tokens are in scope (BC-X.13.005 Step 1 canonical regex enforces this programmatically).

**BC-INDEX.md exclusion (structural)**: BC-INDEX.md is NOT scanned by Guard 1. Rationale: BC-INDEX.md has zero lines matching the `^\*\*(Trace|Source)\*\*:` anchor — the BC-INDEX uses section-header and pipe-table format, not Trace/Source field format. The scope exclusion is both a deliberate design choice and a structural fact (zero extractions would result regardless). BC-INDEX.md citation health is a manual review concern (PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY drift item, partially addressed). See research cross-cutting finding F2 (2026-07-05).

**CI topology (spec-guard dual-worktree)**: Guard 1 runs as two sequential steps in the existing `spec-guard` CI job (confirmed by F1 §3 against live `.github/workflows/ci.yml`):
1. `--self-test` step: runs all 10 self-test fixtures offline using hermetic temp dirs; exits 0 if all pass, 1 if any fail
2. Canonical step: runs Guard 1 against the real factory-artifacts and develop src/ tree

The `spec-guard` job already mounts the `factory-artifacts` worktree via `git worktree add .factory origin/factory-artifacts` before the BC-count steps — Guard 1 inherits this dual-mount. This is CI topology option (a) from F1 §3; options (b) (pre-commit only) and (c) (new dual-checkout job) are rejected. No new CI job is created; no `ci-gate.needs` change is needed — `spec-guard` is already in `ci-gate.needs` per DEC-096/097.

**Self-test fixture suite**: 10 fixtures (A–K) embedded in `scripts/check-bc-citation-symbols.sh --self-test` cover all key failure modes (Fixture A: dead symbol; B: dead file; C: import-only false-green prevention; D: Source-field extraction; E: §-form file-only; F: success path; G: coverage-floor RED probe; I: `::tests` module-path ALIVE [DEC-154]; J: `::tests` negative DEAD [DEC-154]; K: standalone CamelCase type ALIVE [DEC-154]). `--self-test` step ALWAYS executes BEFORE the canonical step in CI.

**GREEN on develop HEAD**: Running `bash scripts/check-bc-citation-symbols.sh` from the repo root with `.factory/specs/prd/` mounted exits 0 on develop HEAD (post-DEC-148 cleanup). All bc-*.md Trace/Source `src/` citations are alive.

**RED on stale citation**: If a PR moves a function without updating bc-*.md Trace/Source fields (e.g., a Seam extraction as in ADR-0012), the next spec-guard run emits `DEAD: <symbol> not found in <old-file>` and exits 1, blocking CI. The guard fires on the PR introducing the drift, not only PRs touching bc-*.md.

**Preconditions**:
- `spec-guard` job mounts both develop checkout and factory-artifacts worktree
- `scripts/check-bc-citation-symbols.sh` is present in the develop checkout at `scripts/`
- The `--self-test` step runs and passes before the canonical step (enforced by CI step ordering)

**Postconditions (on GREEN)**:
- Guard exits 0; prints `Check passed: N citations checked` (N ≥ FLOOR)
- No stale `src/` citations exist in any bc-*.md Trace/Source field on develop HEAD
- `--self-test` step exits 0; script prints `All self-test fixtures passed (10/10)` (the observable success string; the count `10/10` is load-bearing — any reduction in fixture coverage surfaces here)

**Postconditions (on RED)**:
- Guard exits 1; developer receives actionable `DEAD:` offender list
- The `--self-test` step failing independently provides a distinct failure signal when the fixture suite itself regresses vs when a real citation is stale

**Invariants**:
- `--self-test` step ALWAYS runs BEFORE the canonical step in CI; fixture-suite regression fails visibly rather than silently corrupting the canonical run (MUTANTS-ARBITER-OFFLINE-SELFTEST precedent from Story A)
- Guard 1 delivers ZERO changes to `src/` files — the F4 delivery is bash script + CI YAML + CLAUDE.md + CHANGELOG only; no Rust source mutations; no `cargo test` regression possible
- `tests/` citation paths on Trace/Source lines are excluded from extraction — the `#492-PG-TRACE-TESTS` drift item (tests/ citation hygiene) remains OPEN after Guard 1 delivery
- BC-INDEX.md has zero `^\*\*(Trace|Source)\*\*:` lines — the scope exclusion is both deliberate and structural; the anchor pattern enforces it mechanically

**Edge Cases**:
- EC-CITE-046: Guard runs on a PR that does NOT modify bc-*.md (e.g., a pure Rust source refactor) → Guard 1 still runs in spec-guard; if the refactor moved a cited symbol, the guard catches the staleness → exit 1 (desired behavior; cross-PR drift detection)
- EC-CITE-047: Guard runs on develop HEAD where all citations are alive → exit 0; `Check passed: N citations checked` with N ≥ FLOOR
- EC-CITE-048: A stale citation is introduced (file renamed, symbol moved) in a PR → guard fires → exit 1 with `DEAD:` offender list → CI blocked
- EC-CITE-049: BC-INDEX.md has zero `^\*\*(Trace|Source)\*\*:` lines → excluded by anchor pattern; no extraction; no false positive (research cross-cutting finding F2)
- EC-CITE-050: `tests/issue_commands.rs:1646-1703` appears on a Trace/Source line → NOT extracted; canonical regex only matches `src/`-prefixed backtick tokens; excluded from scope

**Canonical Test Vectors**:

| Scenario | Expected behavior |
|----------|-------------------|
| `bash scripts/check-bc-citation-symbols.sh --self-test` (all 10 fixtures pass) | Exit 0; `All self-test fixtures passed (10/10)` |
| `bash scripts/check-bc-citation-symbols.sh` on develop HEAD (factory-artifacts mounted) | Exit 0; `Check passed: N citations checked` (N ≥ 248) |
| PR moves `fn handle_jsm_create` from `create.rs` to `jsm_create.rs` without updating bc-*.md | Guard fires: `DEAD: handle_jsm_create not found in src/cli/issue/create.rs`; exit 1 |
| BC-INDEX.md has no Trace/Source lines | Zero extractions from BC-INDEX.md; no DEAD messages; guard unaffected |
| `tests/claude_md_citations.rs::some_test` on a bc-*.md Trace/Source line | NOT extracted; `src/`-only scope enforced by canonical regex |

**Verification Properties**:
- VP-BC-CITE-002: Integration self-verification — `scripts/check-bc-citation-symbols.sh --self-test` exits 0 with all 10 fixtures passing; canonical run exits 0 on develop HEAD with factory-artifacts mounted; Fixture A proves dead-symbol detection; Fixture C proves import-only is DEAD; Fixture G proves CANONICAL_MODE floor guard is active; Fixtures I/J/K prove DEC-154 grammar branches (::tests, negative, standalone CamelCase). See S-BC-CITATION-GUARD-1 AC-001/AC-002/AC-005/AC-006.

**Traceability**:
- Implementing story: S-BC-CITATION-GUARD-1 (CITATION-GUARDS Story B, issue #102)
- CI topology: F1 delta analysis §3 — option (a) spec-guard dual-worktree confirmed; DEC-129 lesson (Rust test in `test` job cannot access factory-artifacts) applied
- Scope decision: F1 §6 — `src/`-only; `tests/` excluded; BC-INDEX.md excluded (structural zero-Trace/Source lines; research cross-cutting finding F2)
- Prior art: `scripts/check-cargo-mutants-policy-citations.sh` (S-MUTANTS-SCOPE-GUARDS-1, self-test fixture idiom)
- Source: `scripts/check-bc-citation-symbols.sh` (new file; CI script — not in `src/`); `.github/workflows/ci.yml` `spec-guard` job (modified)

[NEW 2026-07-05 CITATION-GUARDS Story B S-BC-CITATION-GUARD-1 issue #102] Guard 1 bc-*.md Trace/Source file::symbol citation guard, extending the BC-X.13 CI-guards subsystem established by DEAD-CITATION-CI.

---

## Key Invariants

- MAX_RETRIES = 3 (4 total calls); change trips `expect(4)` wiremock assertions
- DEFAULT_RETRY_SECS = 1 (Retry-After fallback)
- No upper bound on Retry-After integer (NFR-R-NEW-1 LOW)
- `partial_match` single-substring → Ambiguous (fail-closed invariant)
- User pagination advances by REQUESTED size (JRACLOUD-71273 workaround)
- Worklog days/hours: 8h/day, 5d/week (hardcoded, NFR-R-C)
- `send` vs `send_raw` bifurcation: typed path vs raw passthrough
