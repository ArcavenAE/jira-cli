---
document_type: story
story_id: issue-288-pr2-cli
title: "jr requesttype list/fields discovery commands + cache"
cycle: 3-feature-jsm-request-types-288
wave: 2
status: ready-for-implementation
priority: P0
estimated_effort: medium
tdd_mode: strict
version: "1.0.0"
date: 2026-05-18
producer: story-writer
bc_anchors:
  - BC-X.12.001
  - BC-X.12.002
  - BC-X.12.003
  - BC-X.12.004
  - BC-X.12.005
  - BC-X.12.006
  - BC-X.12.007
  - BC-X.12.008
  - BC-X.8.004
holdout_anchors:
  - H-NEW-JSM-RT-002
  - H-NEW-JSM-RT-005
nfr_anchors: []
adr_refs:
  - ADR-0014
sd_refs: []
files_modified:
  - src/cli/requesttype.rs
  - src/cli/mod.rs
  - src/main.rs
  - src/cache.rs
  - src/api/jsm/servicedesks.rs
  - src/cli/queue.rs
  - src/config.rs
  - src/types/jsm/request_type.rs
  - tests/requesttype_commands.rs
  - tests/queue.rs
  - tests/project_meta.rs
  - CLAUDE.md
breaking_change: false
depends_on:
  - issue-288-pr1-api
blocks:
  - issue-288-pr4-dispatch
issue: 288
---

# issue-288-pr2-cli: `jr requesttype list/fields` Discovery Commands + Cache

## Context

This PR wires the pr1 API layer into user-facing CLI commands (`jr requesttype list` and
`jr requesttype fields`) and adds request-type cache support. It also introduces the
`call-site label` contract to `require_service_desk`, making its error message
caller-specific (per BC-X.8.004 [UPDATED 2026-05-18]).

This is a **read-only** PR: no write operations, no OAuth scope change, no `issue create`
modification. The new commands follow the existing Read-only output-channel profile
(stdout for data, stderr for hints) consistent with `jr queue list` and `jr project list`.

**Dependency:** pr1-api must be merged first. This PR imports from `api::jsm::request_types`
and `types::jsm::request_type`, both created in pr1.

**`require_service_desk` signature change (internal, not user-facing):**
`src/api/jsm/servicedesks.rs::require_service_desk` currently hard-codes the error string
"Queue commands require…". This PR changes the signature to accept a caller-supplied
`context_label: &'static str` parameter, enabling call-site-specific error messages per
BC-X.8.004. The existing caller (`src/cli/queue.rs`) is updated in the same commit to
pass `"queue commands"`. This is a function-signature change but not a user-facing
breaking change (`breaking_change: false`).

## Behavioral Contracts

| BC ID | Summary | Coverage in this PR |
|-------|---------|-------------------|
| BC-X.12.001 | `jr requesttype list` → `GET .../servicedesk/<id>/requesttype` | Full CLI + API |
| BC-X.12.002 | `--search <QUERY>` → `searchQuery` server-side param | CLI flag + API forwarding |
| BC-X.12.003 | `--project <KEY>` overrides; `require_service_desk` call-site error | CLI handler |
| BC-X.12.004 | `--output json` returns structured array; table: Name + Description | Format output |
| BC-X.12.005 | `jr requesttype fields <NAME\|ID>` → fields endpoint | Full CLI + API |
| BC-X.12.006 | Partial-name resolution via `partial_match`; ambiguity hint | CLI handler |
| BC-X.12.007 | `--output json` for `fields` returns structured JSON | Format output |
| BC-X.12.008 | Request types cached per `(profile, serviceDeskId)`; TTL 7d | `src/cache.rs` |
| BC-X.8.004 | `require_service_desk` caller-supplied context label (MODIFIED) | `servicedesks.rs` |

## Approved Scope

**New files:**
- `src/cli/requesttype.rs` — handler for `RequestTypeCommand::List` and `RequestTypeCommand::Fields`;
  uses `require_service_desk`, `partial_match`, cache reads/writes
- `tests/requesttype_commands.rs` — integration tests covering all BC-X.12.001..008 paths

**Modified files:**
- `src/cli/mod.rs` — add `pub mod requesttype;`, `Command::RequestType { command: RequestTypeCommand }`,
  `RequestTypeCommand` enum with `List` and `Fields` variants
- `src/main.rs` — add dispatch arm for `Command::RequestType` following `Command::Queue` pattern
- `src/cache.rs` — add two new cache families:
  - Family 1: `RequestTypeCache` struct, `read_request_type_cache(profile, service_desk_id)`,
    `write_request_type_cache(profile, service_desk_id, types)` — key: `v1/<profile>/request_types_<sid>.json`
  - Family 2: `RequestTypeFieldsCache` struct, `read_request_type_fields_cache(profile, service_desk_id, request_type_id)`,
    `write_request_type_fields_cache(...)` — key: `v1/<profile>/request_type_fields_<sid>_<rtId>.json`
- `src/api/jsm/servicedesks.rs` — extend `require_service_desk` to accept `context_label: &'static str`
  parameter; error message now uses caller-supplied label (per BC-X.8.004 implementation contract)
- `src/cli/queue.rs` — update `require_service_desk` call to pass `"queue commands"` label
- `CLAUDE.md` — document the two new commands, call-site label contract, and cache key families

## Acceptance Criteria

**AC-001** (traces to BC-X.12.001 — list command fires correct endpoint).
`jr requesttype list --project HELP` calls `GET /rest/servicedeskapi/servicedesk/{id}/requesttype`.
Response is rendered as a table with columns `Name` and `Description`. Pinned by:
`tests/requesttype_commands.rs::test_requesttype_list_returns_types_table`

**AC-002** (traces to BC-X.12.002 — search param forwarded).
`jr requesttype list --project HELP --search "password"` includes `?searchQuery=password`
in the HTTP request. Pinned by:
`tests/requesttype_commands.rs::test_requesttype_list_search_forwarded_as_query_param`

**AC-003** (traces to BC-X.12.003 + BC-X.8.004 — non-JSM project error is call-site-specific).
`jr requesttype list --project SW` on a software project exits 64 with stderr containing
'`jr requesttype` commands require a Jira Service Management project'. The error does NOT
contain "Queue commands require". Pinned by:
`tests/requesttype_commands.rs::test_requesttype_list_non_jsm_project_exits_64_with_callsite_message`
(holdout H-NEW-JSM-RT-002 partial: non-JSM project gate)

**AC-004** (traces to BC-X.12.004 — JSON output for list).
`jr requesttype list --project HELP --output json` emits a JSON array where each element
has `id`, `name`, `description`, `helpText`, `issueTypeId`, `groupIds` keys. Pinned by:
`tests/requesttype_commands.rs::test_requesttype_list_output_json_shape`

**AC-005** (traces to BC-X.12.005 — fields command fires correct endpoint).
`jr requesttype fields "Password Reset" --project HELP` resolves the request type name to
an ID via `partial_match`, then calls `GET /rest/servicedeskapi/servicedesk/{id}/requesttype/{rtId}/field`.
Default table output shows `Field Name`, `Required`, `Type` columns. Pinned by:
`tests/requesttype_commands.rs::test_requesttype_fields_resolves_name_and_returns_table`

**AC-006** (traces to BC-X.12.006 — ambiguity error with hint).
`jr requesttype fields "Pass" --project HELP` when "Pass" matches two request types exits 64
with "Ambiguous request type" + candidate names + hint `jr requesttype list --project HELP`.
In `--no-input` mode, exits 64 cleanly (does NOT prompt). Pinned by:
`tests/requesttype_commands.rs::test_requesttype_fields_ambiguous_exits_64_with_hint`

**AC-007** (traces to BC-X.12.007 — JSON output for fields).
`jr requesttype fields <NAME> --project HELP --output json` emits a JSON object with
`canRaiseOnBehalfOf`, `canAddRequestParticipants`, and `fields` array where each field has
`fieldId`, `name`, `required`, and `jiraSchema` keys. Pinned by:
`tests/requesttype_commands.rs::test_requesttype_fields_output_json_shape`

**AC-008** (traces to BC-X.12.008 — cache hit prevents second HTTP call).
Second call to `jr requesttype list --project HELP` reads from cache — only ONE HTTP call
to the request type list endpoint across both invocations (verified with `expect(1)` on
the wiremock mock). Pinned by:
`tests/requesttype_commands.rs::test_requesttype_list_cache_hit_no_second_http`

**AC-009** (traces to BC-X.12.005 + BC-X.12.008 — fields cache hit; holdout H-NEW-JSM-RT-005).
Second call to `jr requesttype fields <ID> --project HELP` reads from the fields cache —
only ONE HTTP call to the fields endpoint. Pinned by:
`tests/requesttype_commands.rs::test_requesttype_fields_cache_hit_no_second_http`
(holdout H-NEW-JSM-RT-005)

**AC-010** (traces to BC-X.8.004 — `require_service_desk` queue caller unchanged).
After this PR, `jr queue list --project HELP` on a non-JSM project still exits 64 with
a message containing the verbatim BC-X.8.004 phrase `"Queue commands (`jr queue`) require a Jira Service Management project"` (capitalised "Queue", parenthetical `` (`jr queue`) ``, plural verb "require") in stderr. The error message is NOT changed for queue callers.
Pinned by: `tests/queue.rs::test_queue_list_non_jsm_project_emits_canonical_callsite_message` (NEW assertion added by adversary-pass-01 H-5 remediation, verifies the literal BC-X.8.004 phrase appears verbatim in stderr). Test-writer will add this test in a follow-up pass.
[UPDATED 2026-05-18 issue #288 adversary-pass-01 H-5]: Removed false "existing test — must remain green without modification" claim. No test named test_queue_list_non_jsm_project_emits_canonical_callsite_message exists in tests/queue.rs; a new test must be added. The exact verbatim phrase from BC-X.8.004 is pinned here so test-writer has an unambiguous string literal to assert against.

**AC-011** (traces to BC-X.12.003 — `--project` from profile, not flag only).
When no `--project` flag is given but the active profile has a project configured,
`jr requesttype list` uses the profile project. When neither flag nor profile project is
configured, exits 64 with actionable message. Pinned by:
`tests/requesttype_commands.rs::test_requesttype_list_uses_profile_project_when_no_flag`

**AC-012** (release-gate). `cargo test`, `cargo clippy -- -D warnings`, `cargo fmt --check`
all pass. `tests/requesttype_commands.rs` all green. Regression: `tests/queue.rs`,
`tests/auth_profiles.rs`, and `tests/project_meta.rs` must remain green. `tests/queue.rs`
and `tests/project_meta.rs` receive S-288-pr2 modifications (per `files_modified`);
`tests/auth_profiles.rs` must remain green without modification.

## Implementation Tasks

- [x] Write RED tests in `tests/requesttype_commands.rs` covering AC-001..AC-011 before
      implementing (TDD Red Gate).
- [x] Extend `require_service_desk` in `src/api/jsm/servicedesks.rs` to accept
      `context_label: &'static str`; update error message to embed the label.
      Update `src/cli/queue.rs` call site to pass `"queue commands"` in the same commit.
- [x] Add `RequestTypeCache` struct (with `fetched_at: DateTime<Utc>`, `service_desk_id: String`,
      `request_types: Vec<CachedRequestType>`) to `src/cache.rs`. Add `read_request_type_cache`
      and `write_request_type_cache`. Mirror `read_team_cache` / `write_team_cache` patterns
      (same 7-day TTL check, same XDG path construction using `profile` parameter).
- [x] Add `RequestTypeFieldsCache` struct (with `fetched_at`, `service_desk_id`, `request_type_id`,
      `fields_response`) to `src/cache.rs`. Add `read_request_type_fields_cache` and
      `write_request_type_fields_cache`. Cache key: `request_type_fields_<sid>_<rtId>.json`.
- [x] Create `src/cli/requesttype.rs` with `pub async fn handle(...)`. Implement `List` arm:
      `require_service_desk`, cache read, API call if miss, cache write, format output.
      Implement `Fields` arm: same pattern with field-level cache.
      Use `partial_match::partial_match` for name→ID resolution in `Fields` (not a bespoke matcher).
- [x] Add `pub mod requesttype;` to `src/cli/mod.rs`. Add `Command::RequestType { command: RequestTypeCommand }`.
      Add `RequestTypeCommand` enum with `List { project, search, output }` and
      `Fields { name_or_id, project, output }` variants. Follow `Command::Queue` clap annotations.
- [x] Add `Command::RequestType { command }` dispatch arm to `src/main.rs` following
      `Command::Queue` pattern.
- [x] Update `CLAUDE.md` with new commands and call-site label contract.
- [x] Verify `cargo test --test requesttype_commands` green.
- [x] Verify `cargo test --test queue` still green (regression guard for BC-X.8.004 queue path).
- [x] Run full `cargo test`, `cargo clippy -- -D warnings`, `cargo fmt --check`.
- [ ] Create PR and obtain merge to develop. (Pending — Step 5-7 of per-story delivery.)

[UPDATED 2026-05-18 issue #288 adversary-pass-05 M-1 + M-2 + L-5] Frontmatter
files_modified completed (was missing src/config.rs, src/types/jsm/request_type.rs,
tests/queue.rs, tests/project_meta.rs); AC-012 regression-guard list extended to
include tests/project_meta.rs; Implementation Tasks checked off for completed
work (PR creation / merge remain pending).

## Testing Strategy

**New test file:** `tests/requesttype_commands.rs` using wiremock + `JiraClient::new_for_test`.

Pattern follows `tests/queue.rs`:
- Mount mocks for service desk resolution (`GET /rest/servicedeskapi/servicedesk?...`)
- Mount mocks for request type list endpoint
- Mount mocks for request type fields endpoint
- Use `expect(1)` for cache-hit tests (verify no second HTTP call)

**Cache hit tests:** Run the command twice against the same wiremock server. First call
sets `expect(1)`. After first call, assert mock was satisfied. Reset mock with `expect(0)`
for second call. Run second call — assert mock receives 0 calls (cache was used).

**Subprocess tests for stderr:** Tests verifying `--no-input` ambiguity exit and error
messages must use the subprocess (binary) test pattern if they need to capture stderr.
Use the library-level pattern for all other tests.

**Regression guard:** `tests/queue.rs` must pass unchanged. Do NOT modify `tests/queue.rs`.

## Architecture Compliance Rules

- `src/cli/requesttype.rs` is an **Effectful** module (L2 handler — HTTP + cache + stdin).
  It follows the same boundary class as `cli/queue.rs`.
- `require_service_desk` MUST accept `context_label: &'static str` (NOT `&str` to avoid
  lifetime complications in async context). This is the BC-X.8.004 implementation contract.
- Cache functions MUST accept `profile: &str` as the first argument — cross-profile leakage
  is a correctness bug (not UX issue). Pass `&config.active_profile_name`.
- `partial_match::partial_match` from `src/partial_match.rs` MUST be used for name→ID
  resolution. If a bespoke matcher is introduced, a new proptest property is required.
- All `Command` enum variants must follow the existing clap derive annotation style.
- No `#[allow(...)]` lint suppressions.
- No `unsafe` blocks.

**Forbidden dependencies for this PR's new modules:**
- `src/cli/requesttype.rs` MUST NOT bypass `require_service_desk` for project resolution
- `src/cache.rs` new functions MUST follow the same multi-profile-aware signature pattern
  as existing cache functions (first arg: `profile: &str`)

## Library and Framework Requirements

All versions already pinned in `Cargo.toml`. No new dependencies.

| Library | Purpose in this PR |
|---------|-------------------|
| `serde_json` | Cache struct serialization |
| `chrono` (already used by cache.rs) | `fetched_at` timestamp in cache structs |
| `comfy-table` | Table output formatting (already used by `output.rs`) |
| `wiremock` (dev) | Mock server for integration tests |

## File Structure Requirements

```
src/cli/
  mod.rs                  MODIFIED — pub mod requesttype; Command::RequestType; RequestTypeCommand enum
  requesttype.rs          NEW — handle(RequestTypeCommand, ...) for List + Fields

src/cache.rs              MODIFIED — RequestTypeCache, RequestTypeFieldsCache, 4 new functions

src/api/jsm/
  servicedesks.rs         MODIFIED — require_service_desk signature: add context_label param
src/cli/
  queue.rs                MODIFIED — update require_service_desk call with "queue commands" label

src/main.rs               MODIFIED — Command::RequestType dispatch arm

tests/
  requesttype_commands.rs NEW — AC-001..AC-012 integration tests

CLAUDE.md                 MODIFIED — document new commands + call-site label contract
```

## Token Budget Estimate

| Context item | Estimated tokens |
|---|---|
| This story | ~2,200 |
| `src/cli/queue.rs` (pattern template for handler) | ~800 |
| `src/api/jsm/servicedesks.rs` (require_service_desk to modify) | ~400 |
| `src/cache.rs` (existing cache patterns to mirror) | ~1,200 |
| `src/cli/mod.rs` (existing Command enum to extend) | ~600 |
| `src/main.rs` (dispatch pattern to mirror) | ~300 |
| `src/partial_match.rs` (usage reference) | ~300 |
| BC-X.12.001..008 (cross-cutting.md §X.12) | ~500 |
| BC-X.8.004 (cross-cutting.md §X.8.004) | ~300 |
| `tests/queue.rs` (test pattern precedent) | ~600 |
| pr1-api story (context for what was built) | ~400 |
| **Total** | **~7,600** |

Within 20-30% of agent context window. No split required.

## Previous Story Intelligence

pr1-api (S-288-pr1-api) established:

1. All three `JiraClient` methods are available: `create_jsm_request`, `list_request_types`,
   `get_request_type_fields` — import these in `src/cli/requesttype.rs`.
2. Struct names: `RequestType`, `RequestTypeField`, `RequestTypeFieldsResponse`,
   `JsmRequestCreated` — all re-exported from `types::jsm::*`.
3. `ServiceDeskPage` pagination is already working for `list_request_types` — do NOT
   add pagination logic in the CLI handler; the API method handles accumulation.
4. Cache functions in this PR must use the same `Expiring<T>` wrapper pattern as
   `read_team_cache` (check `stored_at` + 7-day TTL) — see `src/cache.rs::read_team_cache`
   for the exact pattern.

## Risks / Notes

- **`require_service_desk` signature change** is an internal API change. The Rust compiler
  will enforce that all call sites are updated (`queue.rs` is the only existing caller).
  This is detected at compile time — not a silent regression risk.
- **`--no-input` ambiguity:** When `--no-input` is set and the request type name is
  ambiguous, the handler MUST exit 64 cleanly. Do NOT prompt in `--no-input` mode.
  Mirror the `cli/queue.rs` `Ambiguous` arm handling exactly.
- **Cache key family 2** (`request_type_fields_<sid>_<rtId>.json`) uses two ID components.
  Ensure both are included in the key to prevent cross-request-type cache poisoning.

## Out of Scope

- `issue create --request-type` dispatch (pr4)
- OAuth scope expansion (pr3)
- Proptest properties for `--field` parser (pr4 scope per verification-delta)
- Mutation testing scope updates (pr4 scope per verification-delta)

## Done When

- `cargo test --test requesttype_commands` exits 0 (all ACs green)
- `cargo test --test queue` exits 0 (regression guard: BC-X.8.004 queue path unchanged)
- `cargo test` exits 0 (full suite)
- `cargo clippy -- -D warnings` exits 0
- `cargo fmt --all -- --check` exits 0
- PR passes CI (GitHub Actions green)
- PR description notes "read-only CLI layer; no scope change; no issue create modification"
- PR links to issue #288 and notes dependency on pr1 being merged first
