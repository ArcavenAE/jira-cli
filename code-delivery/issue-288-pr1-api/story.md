---
document_type: story
story_id: issue-288-pr1-api
title: "JSM request submission API client + types (no CLI surface)"
cycle: 3-feature-jsm-request-types-288
wave: 1
status: ready-for-implementation
priority: P0
estimated_effort: medium
tdd_mode: strict
version: "1.0.0"
date: 2026-05-18
producer: story-writer
bc_anchors:
  - BC-3.8.001
  - BC-X.12.001
  - BC-X.12.005
  - BC-X.12.008
holdout_anchors: []
nfr_anchors: []
adr_refs:
  - ADR-0014
sd_refs: []
files_modified:
  - src/api/jsm/requests.rs
  - src/api/jsm/request_types.rs
  - src/api/jsm/mod.rs
  - src/types/jsm/request_type.rs
  - src/types/jsm/mod.rs
  - tests/jsm_request_api.rs
breaking_change: false
depends_on: []
blocks:
  - issue-288-pr2-cli
  - issue-288-pr4-dispatch
issue: 288
---

# issue-288-pr1-api: JSM Request Submission API Client + Types (No CLI Surface)

## Context

This PR establishes the pure API/types layer for JSM request creation and request type
discovery. It is a prerequisite for both the CLI discovery commands (pr2) and the
`issue create --request-type` dispatch fork (pr4). No CLI surface is exposed in this PR;
no integration tests exercise the full CLI. The scope is bounded to:

1. Serde structs for all JSM request-type and request-submission response shapes
2. `JiraClient` methods for `POST /rest/servicedeskapi/request` (create) and
   `GET /rest/servicedeskapi/servicedesk/{id}/requesttype` (list, paginated) and
   `GET /rest/servicedeskapi/servicedesk/{id}/requesttype/{rtId}/field` (fields)

This PR follows the same split used by `api/jsm/queues.rs` and `api/jsm/servicedesks.rs`:
effectful HTTP methods on `JiraClient`, pure types in `types/jsm/`.

The module topology for this PR's additions is:

```
api::jsm::requests       → api::client (HTTP POST /servicedeskapi/request)
api::jsm::requests       → types::jsm::* (serde structs)
api::jsm::request_types  → api::client (HTTP GET /servicedeskapi/servicedesk/{id}/requesttype)
api::jsm::request_types  → api::pagination (ServiceDeskPage, isLastPage pattern)
api::jsm::request_types  → types::jsm::* (serde structs)
types::jsm::request_type → serde, std (pure — no I/O)
```

ADR-0014 selected the conditional dispatch fork (Option C) for `jr issue create`. This PR
implements the API half of that fork. The CLI half lives in pr4.

## Behavioral Contracts

| BC ID | Summary | This PR's coverage |
|-------|---------|-------------------|
| BC-3.8.001 | `--request-type` dispatches to `POST /rest/servicedeskapi/request` | API client method only (no CLI dispatch yet) |
| BC-X.12.001 | `jr requesttype list` → `GET .../servicedesk/<id>/requesttype` (paginated) | API client + pagination |
| BC-X.12.005 | `jr requesttype fields <NAME\|ID>` → `GET .../requesttype/<rtId>/field` | API client method |
| BC-X.12.008 | Request types cached per `(profile, serviceDeskId)` with 7-day TTL | Types defined here; cache functions in pr2 |

## Approved Scope

**New files:**
- `src/api/jsm/requests.rs` — `JiraClient::create_jsm_request(body: serde_json::Value) -> Result<JsmRequestCreated>`
- `src/api/jsm/request_types.rs` — `JiraClient::list_request_types(service_desk_id: &str, search_query: Option<&str>) -> Result<Vec<RequestType>>` (paginated via `ServiceDeskPage`); `JiraClient::get_request_type_fields(service_desk_id: &str, request_type_id: &str) -> Result<RequestTypeFieldsResponse>`
- `src/types/jsm/request_type.rs` — `RequestType`, `RequestTypeField`, `RequestTypeFieldsResponse`, `JsmRequest`, `JsmRequestCreated` serde structs

**Modified files:**
- `src/api/jsm/mod.rs` — add `pub mod requests;` and `pub mod request_types;`
- `src/types/jsm/mod.rs` — add `pub mod request_type;` and `pub use request_type::*;`

**Test files:**
- `tests/jsm_request_api.rs` — wiremock integration tests for all three API methods

**Out of scope for this PR:**
- CLI handler (`src/cli/requesttype.rs`) — pr2
- Cache read/write functions in `src/cache.rs` — pr2
- `jr issue create --request-type` CLI dispatch — pr4
- OAuth scope addition — pr3
- Any change to `CLAUDE.md` — pr2 or pr4

## Acceptance Criteria

**AC-001** (traces to BC-3.8.001 — API method exists and fires correct endpoint).
`JiraClient::create_jsm_request(body)` POSTs to `/rest/servicedeskapi/request` with
`Content-Type: application/json`. On HTTP 201, deserializes to `JsmRequestCreated`
which contains at minimum `issue_key: String` (serde name `issueKey`). Pinned by:
`tests/jsm_request_api.rs::test_create_jsm_request_posts_to_servicedeskapi_and_returns_issue_key`

**AC-002** (traces to BC-X.12.001 — list request types is paginated).
`JiraClient::list_request_types(service_desk_id, search_query)` GETs
`/rest/servicedeskapi/servicedesk/{id}/requesttype`. Pagination uses `ServiceDeskPage`
(the `isLastPage` pattern from `api/pagination.rs`, mirroring `list_queues` in
`api/jsm/queues.rs`). Returns `Vec<RequestType>` with all pages accumulated. Pinned by:
`tests/jsm_request_api.rs::test_list_request_types_paginates_isLastPage`

**AC-003** (traces to BC-X.12.001 — search_query forwarded as server-side param).
When `search_query` is `Some("password")`, the HTTP request includes query param
`searchQuery=password`. When `None`, the param is absent. Pinned by:
`tests/jsm_request_api.rs::test_list_request_types_search_query_forwarded`

**AC-004** (traces to BC-X.12.005 — fields endpoint).
`JiraClient::get_request_type_fields(service_desk_id, request_type_id)` GETs
`/rest/servicedeskapi/servicedesk/{id}/requesttype/{rtId}/field`. Returns
`RequestTypeFieldsResponse` containing `fields: Vec<RequestTypeField>`,
`can_raise_on_behalf_of: bool`, `can_add_request_participants: bool`. Pinned by:
`tests/jsm_request_api.rs::test_get_request_type_fields_returns_field_list`

**AC-005** (traces to BC-X.12.008 — type structs include ID for cache keying).
`RequestType` struct includes: `id: String`, `name: String`, `description: Option<String>`,
`help_text: Option<String>`, `issue_type_id: Option<String>`, `group_ids: Vec<String>`.
`RequestTypeField` struct includes: `field_id: String`, `name: String`, `required: bool`,
`jira_schema: serde_json::Value`. All serde names match the Atlassian API shape (camelCase
→ snake_case via `#[serde(rename_all = "camelCase")]` or per-field `#[serde(rename)]`).
Pinned by: round-trip deserialization test `tests/jsm_request_api.rs::test_request_type_struct_round_trip`

**AC-006** (traces to BC-3.8.001 — JsmRequestCreated normalizable to `{"key": "KEY"}`).
`JsmRequestCreated` has `issue_key: String` (serde: `issueKey`) which callers (in pr4) will
use to produce `{"key": "<issue_key>"}`. The struct also deserializes `issue_id: Option<String>`
(serde: `issueId`) without failure when present. Pinned by:
`tests/jsm_request_api.rs::test_jsm_request_created_extracts_issue_key`

**AC-007** (release-gate). `cargo test --lib`, `cargo test --test jsm_request_api`,
`cargo clippy -- -D warnings`, and `cargo fmt --check` all pass. No new `unsafe` blocks.
No new clippy allows. Module is importable from `src/api/jsm/` and `src/types/jsm/`
without compiler error.

## Implementation Tasks

- [ ] Create `src/types/jsm/request_type.rs` with serde structs (`RequestType`,
      `RequestTypeField`, `RequestTypeFieldsResponse`, `JsmRequest`, `JsmRequestCreated`).
      Use `#[serde(rename_all = "camelCase")]` on structs. Derive `Debug, Clone, Serialize, Deserialize`.
- [ ] Add `pub mod request_type;` and `pub use request_type::*;` to `src/types/jsm/mod.rs`.
- [ ] Write RED tests in `tests/jsm_request_api.rs` (AC-001..AC-006) before any
      implementation (TDD Red Gate).
- [ ] Create `src/api/jsm/requests.rs` with `impl JiraClient { pub async fn create_jsm_request(...) }`.
      Mirror `api/jsm/queues.rs` for HTTP plumbing: `self.post_to_instance("/rest/servicedeskapi/request", body)`.
- [ ] Create `src/api/jsm/request_types.rs` with `list_request_types` (pagination loop using
      `ServiceDeskPage`, mirroring `list_queues`) and `get_request_type_fields`.
      Pagination advance: use `ServiceDeskPage::next_start()` (NOT USER_PAGE_SIZE fixed-window;
      JSM list endpoint does NOT exhibit JRACLOUD-71293).
- [ ] Add `pub mod requests;` and `pub mod request_types;` to `src/api/jsm/mod.rs`.
- [ ] Verify `cargo test --test jsm_request_api` goes green (TDD Green Gate).
- [ ] Run `cargo clippy -- -D warnings` and `cargo fmt --all -- --check`.

## Testing Strategy

All tests in `tests/jsm_request_api.rs` use the wiremock harness pattern established by
`tests/queue.rs`. Key patterns:

- `Mock::given(method("POST")).and(path("/rest/servicedeskapi/request"))` for create
- `Mock::given(method("GET")).and(path_regex(...))` for list and fields
- `expect(1)` on each mock to validate exact call count
- Response shapes must mirror actual Atlassian API (see BC-3.8.001 Source field)

**Pagination test:** mount two mocks — page 1 with `isLastPage: false`, page 2 with
`isLastPage: true` — assert the returned `Vec<RequestType>` contains items from both pages.

**No subprocess tests in this PR** (no CLI surface yet). All tests are library-level tokio
async tests using `JiraClient::new_for_test(base_url, auth_header)`.

## Architecture Compliance Rules

- `src/api/jsm/requests.rs` and `src/api/jsm/request_types.rs` are **Effectful** modules
  (L4 in the dependency graph — HTTP calls via `api::client`). Do NOT add business logic;
  keep these as thin HTTP wrappers.
- `src/types/jsm/request_type.rs` is **Pure** (L5 — serde structs only). No I/O, no
  `JiraClient` imports, no `async` functions.
- Pagination MUST use `ServiceDeskPage` from `src/api/pagination.rs` (same as `queues.rs`).
  Do NOT hand-roll an `isLastPage` loop — use `has_more()` and `next_start()`.
- No new crate dependencies. `serde_json` and `reqwest` are already in `Cargo.toml`.
- No `unsafe` blocks.
- No `#[allow(...)]` lint suppressions — fix the root cause if clippy warns.

**Forbidden dependencies for this PR's new modules:**
- `src/api/jsm/requests.rs` MUST NOT import `src/cli/` (no CLI layer imports in API layer)
- `src/api/jsm/request_types.rs` MUST NOT import `src/cache.rs` (cache wiring is pr2's scope)
- `src/types/jsm/request_type.rs` MUST NOT import any `api::` or `cli::` modules

## Library and Framework Requirements

All versions already pinned in `Cargo.toml`. No new dependencies introduced.

| Library | Already in Cargo.toml | Purpose in this PR |
|---------|----------------------|-------------------|
| `serde` + `serde_json` | yes | Struct serialization |
| `reqwest` | yes | HTTP client (via `JiraClient`) |
| `wiremock` (dev) | yes | Mock server for integration tests |
| `tokio` (dev) | yes | Async test runtime |

## File Structure Requirements

```
src/types/jsm/
  mod.rs                  MODIFIED — add pub mod request_type; pub use request_type::*;
  request_type.rs         NEW — RequestType, RequestTypeField, RequestTypeFieldsResponse,
                               JsmRequest, JsmRequestCreated

src/api/jsm/
  mod.rs                  MODIFIED — add pub mod requests; pub mod request_types;
  requests.rs             NEW — JiraClient::create_jsm_request
  request_types.rs        NEW — JiraClient::list_request_types, get_request_type_fields

tests/
  jsm_request_api.rs      NEW — integration tests (all 6 ACs above)
```

## Token Budget Estimate

| Context item | Estimated tokens |
|---|---|
| This story | ~1,800 |
| `src/api/jsm/queues.rs` (pagination pattern precedent) | ~800 |
| `src/api/jsm/servicedesks.rs` (HTTP plumbing pattern) | ~600 |
| `src/api/pagination.rs` (ServiceDeskPage) | ~500 |
| `src/types/jsm/mod.rs` + existing type files | ~300 |
| BC-3.8.001..010 (bc-3-issue-write.md §3.8) | ~600 |
| BC-X.12.001..008 (cross-cutting.md §X.12) | ~500 |
| ADR-0014 | ~400 |
| `tests/queue.rs` (wiremock pattern reference) | ~600 |
| **Total** | **~6,100** |

Well within 20-30% of agent context window. No split required.

## Previous Story Intelligence

N/A — this is the first PR in the issue-288 feature cycle. Related precedents:

1. `src/api/jsm/queues.rs` establishes the exact HTTP + pagination pattern to mirror.
   The `list_queues` function is the template for `list_request_types` (same
   `ServiceDeskPage` loop, same `get_from_instance` call structure).
2. `tests/queue.rs` establishes the wiremock test pattern for JSM API tests.
3. `src/types/jsm/queues.rs` establishes the serde struct conventions (`camelCase`
   rename, derive `Debug, Clone, Serialize, Deserialize`).
4. Do NOT use `USER_PAGE_SIZE` fixed-window pagination — that is a JRACLOUD-71293
   workaround for the Jira users endpoint only. JSM list endpoints use standard
   `next_start()` / `isLastPage` pagination.

## Risks / Notes

- **Response shape verification:** The mock fixtures in `tests/jsm_request_api.rs` must
  match the actual Atlassian API response shape (BC-3.8.001 Source field). If Atlassian
  changes the shape, the mock-based tests will not catch it — this is a known limitation
  of wiremock-based testing documented in the F2 verification delta.
- **`isLastPage` vs. `has_more`:** `ServiceDeskPage` uses `isLastPage` from the API
  response; the `has_more()` method returns `!is_last_page`. Confirm this matches the
  actual JSM API response field name before writing the struct.

## Out of Scope

- Cache read/write functions (pr2)
- CLI handler and commands (pr2)
- OAuth scope expansion (pr3)
- `issue create --request-type` dispatch (pr4)
- Any change to `CLAUDE.md`

## Done When

- `cargo test --test jsm_request_api` exits 0 with all 6 ACs green
- `cargo test --lib` exits 0 (no regression on existing unit tests)
- `cargo clippy -- -D warnings` exits 0
- `cargo fmt --all -- --check` exits 0
- PR passes CI (GitHub Actions green)
- PR description links to issue #288 and notes "API layer only; no CLI surface"
