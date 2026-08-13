---
document_type: research-brief
issue: 693
producer: research-agent
timestamp: 2026-08-13
status: complete
title: "queue view discards queue-endpoint fields then re-fetches a fixed field set"
---

# Research Brief — #693: `jr queue view` field-drop + double-fetch

## 1. Root cause — CONFIRMED against source

The reporter's mechanism is accurate. Verified with symbol-form citations:

- **Field drop.** `src/api/jsm/queues.rs::get_queue_issue_keys` (lines 40–84) deserializes each
  page of `/rest/servicedeskapi/servicedesk/{sdId}/queue/{queueId}/issue` into
  `ServiceDeskPage<QueueIssueKey>` and immediately maps every entry to `ik.key`
  (`all.extend(page.values.into_iter().map(|ik| ik.key))`, line 70), discarding everything else.
- **`QueueIssueKey` retains only `key`.** `src/types/jsm/queue.rs::QueueIssueKey` (lines 17–20) is
  `{ pub key: String }` — the doc comment explicitly says the queue endpoint "returns issues
  containing only the fields configured as queue columns, and we only need the key." The two unit
  tests (`deserialize_queue_issue_key`, `deserialize_queue_issue_key_ignores_extra_fields`)
  demonstrate the `fields` object being parsed and thrown away.
- **Second, narrower fetch.** `src/cli/queue.rs::handle_view` (lines 91–110) then builds a
  `key IN (...)` JQL (`build_key_in_jql`) and calls
  `client.search_issues(&jql, Some(keys.len() as u32), &[])` — note the empty `extra_fields` slice.
- **Fixed 17-field request.** `src/api/jira/issues.rs::search_issues` (line 164) starts from
  `BASE_ISSUE_FIELDS` (lines 13–31): summary, status, issuetype, priority, assignee, reporter,
  project, description, created, updated, duedate, resolution, components, fixVersions, labels,
  parent, issuelinks. **No custom fields.** `extra_fields` is empty from the queue caller, so no
  customfield is ever requested.

**Net:** the queue endpoint already returned each issue's queue-configured `fields` (including custom
fields); `jr` drops them, then re-fetches a fixed non-custom set. Two round-trips (queue-issue paging
+ a JQL search), and the custom fields the queue declares are absent from both `queue view` table and
`--output json`. Confirmed.

The `Queue` metadata struct already carries the column config: `src/types/jsm/queue.rs::Queue.fields:
Option<Vec<String>>` (line 8) — this is the `fields: [...]` the reporter saw in `jr queue list
--output json`. It is deserialized today but never used by `queue view`.

## 2. API confirmation — Atlassian Cloud JSM docs (load-bearing)

Source: **GET .../servicedesk/{serviceDeskId}/queue/{queueId}/issue** —
https://developer.atlassian.com/cloud/jira/service-desk/rest/api-group-servicedesk/#api-rest-servicedeskapi-servicedesk-servicedeskid-queue-queueid-issue-get
Pagination model: https://developer.atlassian.com/cloud/jira/service-desk/rest/intro/

- **Response shape.** Paged `PagedDTO`: top-level `_expands`, `size`, `start`, `limit`,
  `isLastPage`, `_links`, `values`. Each `values[]` item has exactly four top-level keys:
  **`fields`, `id`, `key`, `self`** — matching the reporter's `["fields","id","key","self"]`.
- **`values[].fields` is the queue's configured columns, NOT all fields.** Atlassian states
  verbatim: *"Only fields that the queue is configured to show are returned."* `fields` is a dynamic
  map keyed by Jira field id → that issue's normal Jira JSON value. **Custom fields configured as
  queue columns DO appear**, keyed `customfield_<id>`. This confirms the reporter's "5 customfields"
  observation.
- **Pagination matches `ServiceDeskPage` exactly.** Query params `start` + `limit`; response
  `size`/`start`/`limit`/`isLastPage`. This is byte-for-byte what
  `src/api/pagination.rs::ServiceDeskPage` (lines 88–111) already deserializes and what
  `get_queue_issue_keys` already loops on (`has_more()` = `!is_last_page`, `next_start()` =
  `start + size`). **A fields-retaining refactor does NOT touch paging** — only the item type inside
  `ServiceDeskPage<T>` changes. No per-page numeric max is published (implementation detail); current
  `max_page_size = 50` is a safe self-imposed cap.
- **Relationship `queue.fields[]` ↔ `queue/{id}/issue`:** CONFIRMED, with one qualification. The
  QueueDTO `fields` array declares the configured column field ids; the issue endpoint renders those
  per issue. BUT the mapping is semantic, not 1:1 literal: the pseudo-column **`issuekey`** in
  `queue.fields[]` is surfaced as the issue's top-level `key`, not as `fields.issuekey`. Likewise a
  bare `issuetype`/`summary` token maps to a real field. **Discrepancy vs reporter:** the reporter
  implies `values[].fields` is a superset worth rendering directly; the docs show it is a
  **queue-admin-defined SUBSET** — it is a superset only for custom fields, and can be a strict subset
  for the columns `jr`'s table renders (see §3).

## 3. Fix assessment

What `queue view`'s table renders today (`src/cli/issue/format.rs::format_issue_row` lines 26–92,
`issue_table_headers` lines 98–120, both called with all-`false`/`None`): **Key, Type (issuetype),
Status, Priority, Assignee, Summary** — 6 columns. JSON mode emits the full typed `Issue` (via
`output::render_json`), and `IssueFields` has `#[serde(flatten)] pub extra: HashMap<String, Value>`
(`src/types/jira/issue.rs:79-80`) — so any requested `customfield_*` is captured AND re-serialized.

**Option 1 (PREFERRED by reporter — retain queue `fields`, skip `search_issues`): REJECT as a pure
form.** The queue-endpoint field set is admin-configured and is NOT guaranteed to contain the columns
`jr` renders. Atlassian's own example queue config is
`["issuetype","issuekey","summary","created","reporter","duedate"]` — it contains **no status, no
priority, no assignee**, all three of which `queue view` currently shows. Rendering directly from the
queue `fields` would silently blank those columns for any queue not configured to display them, and
would drop the guaranteed base fields (description, resolution, etc.) that JSON consumers already rely
on today. It saves one HTTP call at the cost of a real rendering regression. Also requires a new
render path (queue `fields` is a raw `HashMap<String,Value>`, not the typed `Issue` the formatter and
JSON path both consume) — larger blast radius, not smaller.

**Option 2 (honour the queue's declared `fields[]` when building the `search_issues` call):
RECOMMENDED.** Keep the two-step fetch (it guarantees the base render fields and the typed `Issue`
shape), but pass the queue's custom columns as `extra_fields`:
1. Retain the resolved `Queue` (its `fields: Option<Vec<String>>`) instead of discarding it —
   `resolve_queue_by_name` currently returns only the id; have it (or a sibling) also surface the
   `Queue`. For the `--id` path, a `list_queues` lookup by id yields the same `fields`.
2. Filter `queue.fields` to real requestable field ids — drop pseudo-tokens (`issuekey`,
   and anything already in `BASE_ISSUE_FIELDS`) — and pass the remainder as `extra_fields` to
   `search_issues`. Requesting `customfield_*` there flows straight into `IssueFields.extra` and
   serializes back out in `--output json` with zero formatter change.
- **Correctness:** table unchanged; JSON gains exactly the queue's custom fields. No regression.
- **Perf:** still two calls, but the *right* data. (The extra round-trip is inherent to reusing the
  typed `Issue`/JQL path; eliminating it is Option 1's regression trade.)
- **Blast radius:** smallest — one new `extra_fields` argument threaded through, `format_issue_row`
  and the JSON path untouched.

**Option 3 (`--fields <CSV>` passthrough): out of scope here — that is #575.** It is the *user
override* knob; #693 is the *queue-config-derived* default. They are complementary and should share
`search_issues(extra_fields)` plumbing (see §4), not compete.

**Recommendation: Option 2**, optionally leaving a hook for #575's `--fields` to append further user
CSV to the same `extra_fields`. If a future story wants the perf win, a *hybrid* — render from queue
`fields` only when the queue config is a proven superset of the render columns, else fall back to
`search_issues` — is possible but adds branching for marginal benefit; not recommended now.

## 4. Relationship to #575

Same root cause (`BASE_ISSUE_FIELDS` is fixed; `extra_fields` is the escape hatch). They should
**share the `extra_fields` machinery** but stay distinct in origin: #693 auto-derives extra fields
from the queue's declared column config; #575 lets the user name fields explicitly via CSV. Cleanest:
land #693 queue-scoped (auto-honour `queue.fields[]`), and let #575 add a general `--fields` that, on
`queue view`, unions with the queue-derived set. Do not block #693 on #575.

## 5. BC / spec impact

- **`cross-cutting.md` BC-X.8.009** (`jr queue view`, lines ~685–720) — **NEEDS AMENDMENT.** Its
  "Issue fetch pipeline" step 3 currently contracts `search_issues(&jql, Some(keys.len()), &[])` with
  the empty `extra_fields` slice, and its JSON-output clause (line ~710) says the array is "full
  `Issue` objects (each has `key` + `fields`)" without acknowledging that custom/queue-configured
  fields are absent. Amend to contract: the queue's declared `fields[]` are passed as `extra_fields`
  so queue-configured custom fields appear in `values[].fields` → JSON output. Update the step-3 call
  signature description and the JSON clause.
- **`cross-cutting.md` BC-X.8.008** (`jr queue list`) — unaffected (already documents `Queue.fields`
  deserialization; no behavior change).
- **`bc-2-issue-read.md`** BASE_ISSUE_FIELDS BCs (BC-2.2.028 etc.) — unaffected; the field set is
  extended per-call via `extra_fields`, not by changing the constant.
- No new BC strictly required if amending BC-X.8.009 suffices; F1 may prefer a new sub-BC for the
  queue-field-passthrough behavior. `Queue.fields` and `QueueIssueKey` structs already exist — the
  data is available, only the wiring is missing.

## 6. Risks / inconclusive

- **Non-field tokens in `queue.fields[]`.** The array can contain pseudo-columns (`issuekey`) and
  bare built-ins (`issuetype`, `summary`, `status`). Passing these verbatim as `fields` params to
  `/rest/api/3/search/jql` is at best redundant and at worst rejected. Implementation MUST filter to
  requestable field ids (recommended: keep only `customfield_*` and any token not already in
  `BASE_ISSUE_FIELDS`). Confirm Jira's tolerance of unknown `fields` tokens during F4 (empirically
  Jira ignores unknown fields, but `issuekey` specifically is not a valid `fields` value).
- **No custom-field NAME resolution / no table column.** Option 2 surfaces custom fields in `--output
  json` only (raw `customfield_<id>` keys, raw values). The human table has no column for them — that
  would need column plumbing akin to `--points`/`--assets`, which is #575 territory, not #693. The
  issue's primary complaint is the JSON `fields`, so this is acceptable scope; state it explicitly so
  F1 doesn't over-scope a table change.
- **`--id` path queue-metadata fetch.** Getting `queue.fields` for the `--id <id>` path needs a
  `list_queues` call (the name path already has the `Queue` in hand via `resolve_queue_by_name`).
  Minor extra call on the id path only; acceptable, but note it so the fix doesn't assume the queue
  object is always already loaded.
- **Verified, not assumed:** `IssueFields.extra` is `#[serde(flatten)]` with no `skip_serializing`,
  so requested custom fields DO round-trip to JSON output — Option 2 is viable end-to-end. If that
  attribute changes, re-verify.
