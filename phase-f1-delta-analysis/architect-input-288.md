# F1 Architect Input — Issue #288

Issue: feat(jsm): JSM request type support in `jr issue create` — `--request-type` flag + `jr requesttype list/fields` discovery commands
Source: User report (Luke Adamson, 2026-05-05); GitHub issue #288.
Date: 2026-05-18

---

## Impact Boundary

| Component | File | Change Type | Justification |
|-----------|------|-------------|---------------|
| JSM request API client | `src/api/jsm/requests.rs` | NEW | New file implementing `JiraClient::create_jsm_request` (`POST /rest/servicedeskapi/request`) and the `JsmRequest` / `JsmRequestCreated` types inline. Kept in the jsm namespace, parallel to `queues.rs`. |
| JSM request type API client | `src/api/jsm/request_types.rs` | NEW | New file implementing `JiraClient::list_request_types` (`GET /rest/servicedeskapi/servicedesk/{id}/requesttype`) and `JiraClient::get_request_type_fields` (`GET .../requesttype/{id}/field`). Handles `isLastPage`-based pagination. |
| JSM API module | `src/api/jsm/mod.rs` | MODIFIED | Add `pub mod requests;` and `pub mod request_types;` declarations. Currently only two lines; this becomes four. |
| JSM request types CLI | `src/cli/requesttype.rs` | NEW | New file implementing `handle(RequestTypeCommand, ...)` for `RequestType::List` and `RequestType::Fields`. Uses `require_service_desk`, `partial_match`, and the two new API methods above. Output-channel profile: Read-only (stdout for data, stderr for hints). |
| JSM request types types | `src/types/jsm/request_type.rs` | NEW | Serde structs: `RequestType { id, name, description, help_text }`, `RequestTypeField { field_id, name, description, required, default_values, valid_values, jira_schema, visible }`, `RequestTypeFieldsResponse { can_raise_on_behalf_of, can_add_request_participants, request_type_fields }`. |
| JSM types module | `src/types/jsm/mod.rs` | MODIFIED | Add `pub mod request_type;` and `pub use request_type::*;`. Currently four lines. |
| CLI module declarations | `src/cli/mod.rs` | MODIFIED | (1) Add `pub mod requesttype;` to top-level module list. (2) Add `RequestType { command: RequestTypeCommand }` arm to `Command` enum. (3) Add `RequestTypeCommand` enum with `List { project, search, output }` and `Fields { name_or_id, project, output }` variants. (4) Add `--request-type`, `--field`, and `--on-behalf-of` flags to `IssueCommand::Create` variant. |
| `jr issue create` handler | `src/cli/issue/create.rs` | MODIFIED | `handle_create` gains a `request_type` / `field` / `on_behalf_of` branch: when `--request-type` is set, dispatch to `api::jsm::requests::create_jsm_request` instead of `api::jira::issues::create_issue`. Existing platform path is unchanged. File grows from ~1,601 LOC; estimated addition ~120–160 LOC. |
| OAuth scopes constant | `src/api/auth.rs` | MODIFIED | Add `write:servicedesk-request` to the `DEFAULT_OAUTH_SCOPES` `concat!` literal (line 59). This is a single-line addition with outsized ripple: the literal must match the Atlassian Developer Console app registration exactly, and the regression test `default_oauth_scopes_pins_the_full_set_with_offline_access` in `src/cli/auth/tests/mod.rs` must be updated to assert the new scope. |
| OAuth scope regression test | `src/cli/auth/tests/mod.rs` | MODIFIED | Add `"write:servicedesk-request"` to the `required` array in `default_oauth_scopes_pins_the_full_set_with_offline_access`. Test must be updated in the same commit as `auth.rs` to keep CI green. |
| Request type cache | `src/cache.rs` | MODIFIED | Add `RequestTypeCache { fetched_at, service_desk_id, request_types: Vec<CachedRequestType> }` and the `Expiring` impl, plus `read_request_type_cache(profile, service_desk_id)` / `write_request_type_cache(profile, service_desk_id, types)`. Cache file: `v1/<profile>/request_types_<service_desk_id>.json` (keyed by serviceDeskId, 7-day TTL). Pattern is identical to `teams.json`. |
| Main dispatch | `src/main.rs` | MODIFIED | Add `cli::Command::RequestType { command }` arm in `run()`'s match block, following the same config/client construction pattern used by `cli::Command::Queue`. |
| Integration tests — create JSM | `tests/issue_create_jsm.rs` | NEW | Wiremock tests covering: (1) `jr issue create --request-type NAME` dispatches to `POST /rest/servicedeskapi/request` not `/rest/api/3/issue`; (2) JSON output returns `issueKey`; (3) `--on-behalf-of` propagates `raiseOnBehalfOf`; (4) `--request-type` on a non-JSM project returns an error (via `require_service_desk`). |
| Integration tests — requesttype commands | `tests/requesttype_commands.rs` | NEW | Wiremock tests covering: `jr requesttype list --project KEY`, `jr requesttype fields NAME --project KEY`, `--output json` shape parity, partial-name match disambiguation, not-found error path. |
| CLAUDE.md | `CLAUDE.md` | MODIFIED | Document the scope addition (`write:servicedesk-request`), the new `--request-type` / `--field` / `--on-behalf-of` flags on `issue create`, and the two new top-level commands under the Conventions / Key Decisions section. No new `JR_*` env vars anticipated; update this note if a test-seam env var is added during implementation. |

---

## Architecture Delta

This is a structural expansion, not an internal refactor. It crosses four module boundaries:

**New API surface.** Two new files in `src/api/jsm/` implement distinct API resources (`/request` and `/requesttype/{id}/field`). These are `impl JiraClient` blocks, consistent with how all existing jsm and jira API modules are structured. No trait changes to `JiraClient` are needed — the pattern is direct method addition, same as `list_queues`, `list_service_desks`, etc.

**New top-level command group.** `jr requesttype` is a new top-level `Command` variant, following the exact pattern of `jr queue` (new `cli::mod.rs` enum variant + new `cli/requesttype.rs` handler). This requires additions in three files: `cli/mod.rs` (enum variant + subcommand enum), `cli/requesttype.rs` (handler), and `src/main.rs` (dispatch arm). No changes to existing command routing.

**Conditional dispatch fork in `handle_create`.** The only structural change to an existing handler is the branch point in `src/cli/issue/create.rs`: when `--request-type` is present, execution takes the JSM path; otherwise it takes the existing platform path, which is entirely unchanged. This is the highest complexity change in the feature because `handle_create` is already 1,601 LOC and the new flags must integrate without disrupting the existing resolve-project / resolve-type / build-fields flow. The JSM path resolves `serviceDeskId` via `require_service_desk`, resolves the request type ID via `partial_match` against a cached or fetched request type list, constructs a `requestFieldValues` map (same shape as platform `fields`), and calls `create_jsm_request`.

**Cache extension.** `src/cache.rs` grows one new struct and two new read/write functions, following a well-worn pattern. The cache is keyed by `(profile, service_desk_id)` to respect the multi-profile boundary invariant.

**OAuth scope addition.** Adding `write:servicedesk-request` to `DEFAULT_OAUTH_SCOPES` is a one-character-class change but has release-level consequences: the constant must be kept in lockstep with the `jr` Atlassian Developer Console app registration, and the pinning test must be updated in the same atomic commit.

No changes to `JiraClient`'s trait surface, pagination infrastructure, ADF utilities, output formatting, or error type hierarchy. The feature is entirely additive to existing module contracts.

---

## Regression Risk

| Module | Risk | Rationale |
|--------|------|-----------|
| `src/api/auth.rs` — `DEFAULT_OAUTH_SCOPES` | HIGH | Scope additions affect every OAuth-authenticated user on their next token refresh or new login. If `write:servicedesk-request` is not registered in the Atlassian Developer Console for the embedded `jr` OAuth app before the release ships, every new OAuth login (and refresh on scoped-token services) will fail with `invalid_scope`. This is a release-coordination dependency, not just a code change. The pinning test `default_oauth_scopes_pins_the_full_set_with_offline_access` must be updated in lockstep; if it is updated but the Developer Console is not, CI passes but production breaks. CI cannot catch the Developer Console mismatch — it must be validated manually in staging before release. |
| `src/cli/issue/create.rs` — conditional dispatch | HIGH | `handle_create` is 1,601 LOC and already the most complex handler. The new `--request-type` branch must not alter the code path for calls that omit `--request-type`. Any accidental early-return, moved variable binding, or changed default for existing flags would silently break the platform-path. Existing integration tests in `tests/issue_create_json.rs`, `tests/issue_commands.rs`, and `tests/issue_write_holdouts.rs` guard the platform path; these must remain green without modification. |
| `src/cli/mod.rs` — `IssueCommand::Create` variant | MEDIUM | Adding three new fields (`request_type`, `field`, `on_behalf_of`) to the `Create` variant requires updating every exhaustive pattern match on `IssueCommand::Create` in the codebase. Rust's compiler enforces this, so the risk is a compilation-time failure rather than a silent regression — but it must be resolved before CI can pass. |
| `src/cache.rs` — new request type cache | LOW | Cache additions are purely additive. New struct + two functions do not touch existing `read_project_meta`, `read_team_cache`, or `cmdb_fields` code paths. Cache-miss behavior (file absent, expired, or corrupt) is self-healing via the existing `read_cache` pattern. No cross-profile leakage risk as long as the cache key includes `service_desk_id`. |
| `src/api/jsm/requests.rs` and `request_types.rs` — new files | LOW | New files with no prior callers. Regression risk is zero for existing behavior; forward risk is bounded by integration tests in `tests/issue_create_jsm.rs` and `tests/requesttype_commands.rs`. |
| `src/types/jsm/request_type.rs` — new types | LOW | Additive serde structs. No existing type is modified. Deserialization failure on a real API response would surface as a runtime error, not a silent regression. |
| `src/main.rs` — new dispatch arm | LOW | Adding a `Command::RequestType` arm to an exhaustive match. Rust enforces completeness; a missing arm is a compile error. The arm pattern follows the exact template of `Command::Queue`. |
| Output channel correctness — `jr requesttype` | LOW | New commands follow the Read-only profile (stdout for data, stderr for hints). If stderr output accidentally bleeds into stdout, `--output json` consumers would receive corrupt output. Integration tests with `--output json` flag guard this. |
| `--no-input` parity on `jr issue create --request-type` | MEDIUM | If `--request-type NAME` resolves to an ambiguous partial match and `--no-input` is set, the handler must error cleanly rather than prompting. The `partial_match` module's `MatchResult::Ambiguous` arm must be wired to a `JrError::UserError` in non-interactive mode, matching the pattern used in `cli/queue.rs`. Omitting this would cause `--no-input` mode to hang or panic on ambiguous input. |
| JSON output shape parity for `issue create --request-type` | MEDIUM | The JSM `POST /rest/servicedeskapi/request` response body differs from the platform `POST /rest/api/3/issue` response. Both return `issueKey`, but the JSM response wraps it in a different top-level shape. The JSON output for `issue create` when `--request-type` is set must still emit `{"key": "<KEY>"}` to preserve the existing `--output json` contract used by automation. |
| `src/cli/auth/tests/mod.rs` — scope pin test | MEDIUM | If `DEFAULT_OAUTH_SCOPES` is updated but the test is not (or vice versa), CI fails immediately. The risk is ordering: the test must be updated in the same commit as `auth.rs`. No silent failure is possible, but a broken CI that blocks unrelated PRs is a disruption risk during implementation. |

---

## Recommendation

**Scope: FULL-FEATURE — not trivial.**

This feature introduces two new API modules, a new top-level command group, a conditional dispatch fork in the largest handler in the codebase, a cache extension, an OAuth scope addition with Developer Console coordination, and two new integration test files. It touches eight existing files and creates six new files.

**F2 (Spec Evolution):** PRD requires a new BC group for JSM request submission (distinct from existing `bc-3-issue-write.md` which covers platform issue creation). Verification properties needed for: (1) `--request-type` dispatches to JSM endpoint when set and platform endpoint when absent; (2) `requestFieldValues` map keys match `jira_schema.system` / `jira_schema.custom` names correctly; (3) partial-name resolution of request type name → ID is case-insensitive and errors cleanly on ambiguity; (4) cache is keyed per (profile, serviceDeskId), not globally. Architecture section updates: `api-surface.md` gains JSM request endpoints; `module-decomposition.md` gains `api/jsm/requests`, `api/jsm/request_types`, `cli/requesttype`, `types/jsm/request_type`.

**F3 (Story Decomposition):** Recommend decomposing into at least four stories:
- S-288-A: New types + API client (`request_types.rs`, `requests.rs`, `types/jsm/request_type.rs`) — pure API layer, no CLI
- S-288-B: Cache support + `jr requesttype list/fields` CLI commands — read-only surface, no OAuth scope change
- S-288-C: OAuth scope addition (`write:servicedesk-request`) + Developer Console coordination gate — prerequisite for write path
- S-288-D: `jr issue create --request-type` conditional dispatch — depends on S-288-A, S-288-B, S-288-C

**F4 (Implementation):** The `handle_create` modification (S-288-D) carries the highest risk and should be implemented last, after the read path is verified. ADF handling is already available (`markdown_to_adf`, `text_to_adf`) — pass `isAdfRequest: true` unconditionally when description is provided, matching existing platform behavior.

**F5 (Adversarial Review):** Priority checks: (1) Does the JSM path silently swallow the `--type` flag (issue type) that is required on the platform path but meaningless on the JSM path? Must error or warn clearly. (2) Does `--field NAME=VALUE` correctly construct `requestFieldValues` for multi-value fields (arrays vs. scalars)? (3) Is the `raiseOnBehalfOf` accountId validated before being passed through, or does it pass raw user input to the API?

**F6 (Hardening):** Proptest candidates: `requestFieldValues` map construction from `--field NAME=VALUE` pairs (duplicate keys, empty values, unicode names). Mutation testing scope: the `partial_match` resolution branch in `requesttype` handler and the `request_type.is_some()` branch gate in `handle_create`.

**F7 (Convergence):** Developer Console scope registration must be confirmed before the PR merges to `develop`. Suggest a checklist item in the PR template for this feature specifically.

---

## Trivial-Scope Eligibility

**NOT ELIGIBLE for trivial scope.**

Disqualifying factors (multiple are individually sufficient):

1. **New files (6):** `src/api/jsm/requests.rs`, `src/api/jsm/request_types.rs`, `src/cli/requesttype.rs`, `src/types/jsm/request_type.rs`, `tests/issue_create_jsm.rs`, `tests/requesttype_commands.rs`. Trivial scope permits at most one file change.

2. **New top-level CLI command group** (`jr requesttype`) with two subcommands. This requires coordinated changes across `src/cli/mod.rs`, `src/main.rs`, and the new handler file.

3. **OAuth scope addition** (`write:servicedesk-request`) that affects every user on next OAuth login/refresh and requires out-of-band Developer Console registration coordination before release. This is a release-gating dependency.

4. **Regression risk on `src/cli/issue/create.rs`** — the largest and most complex handler in the codebase. The conditional dispatch fork must be verified not to alter the existing platform path under any flag combination.

5. **New BC group needed** in the PRD. Trivial scope does not spawn new behavioral contracts.

6. **Multi-story decomposition required** (minimum 4 stories). Trivial scope is a single, immediately deliverable change.
