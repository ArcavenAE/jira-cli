---
document_type: f1-delta-analysis
phase: phase-f1-delta-analysis
producer: state-manager
issue: 288
status: orchestrator-approved
timestamp: 2026-05-18
project: jira-cli
mode: BROWNFIELD
intent: feature
feature_type: backend
trivial_scope: false
regression_risk: medium-to-high
inputs:
  - ".factory/phase-f1-delta-analysis/architect-input-288.md"
  - ".factory/phase-f1-delta-analysis/business-analyst-input-288.md"
---

# F1 Delta Analysis — Issue #288

## Issue Summary

Issue #288 ("feat(jsm): JSM request type support in `jr issue create`") adds two new user-facing surfaces to the `jr` CLI on top of the existing JSM infrastructure introduced by the `jr queue` commands. First, a new top-level command group `jr requesttype` with `list` and `fields` subcommands, backed by `GET /rest/servicedeskapi/servicedesk/{id}/requesttype` and `GET .../requesttype/{id}/field`. Second, a new `--request-type <NAME|ID>` flag on `jr issue create` that, when present, dispatches to `POST /rest/servicedeskapi/request` instead of the platform `POST /rest/api/3/issue`, enabling portal-style JSM ticket submission with `--on-behalf-of` and repeatable `--field NAME=VALUE` support. Cascading changes include an OAuth scope addition (`write:servicedesk-request`), a new request-type cache keyed per `(profile, serviceDeskId)`, and two new integration test files. The platform create path is entirely unchanged in behavior; the JSM path is a net-new code route gated by the presence of `--request-type`.

## Approved Scope

FEATURE — STANDARD scope. In scope: (1) `src/api/jsm/request_types.rs` and `src/api/jsm/requests.rs` (new API client files); (2) `src/types/jsm/request_type.rs` (new serde structs); (3) `src/cli/requesttype.rs` (new CLI handler for `list` and `fields` subcommands); (4) conditional dispatch branch in `src/cli/issue/create.rs::handle_create` for the JSM path; (5) `write:servicedesk-request` scope addition to `DEFAULT_OAUTH_SCOPES` in `src/api/auth.rs`, with the pinning test updated in the same commit; (6) request-type cache struct and read/write functions in `src/cache.rs`; (7) module declarations in `src/api/jsm/mod.rs`, `src/types/jsm/mod.rs`, `src/cli/mod.rs`, and a new dispatch arm in `src/main.rs`; (8) `tests/issue_create_jsm.rs` and `tests/requesttype_commands.rs` (new integration test files); (9) `CLAUDE.md` documentation update for the new scope and flags.

Out of scope: changes to `POST /rest/api/3/issue` behavior (platform create path is regression baseline); Confluence or Assets API changes; any change to the `jr queue` read path; JSM SLA or approval workflow endpoints; `--output json` envelope versioning (`NFR-O-P` remains deferred to v2).

## Impact Assessment Table

| Artifact | Change |
|----------|--------|
| PRD | 17 new BCs (BC-3.8.001..009 in `bc-3-issue-write.md`; BC-X.12.001..008 in `cross-cutting.md`). 2 existing BCs modified: BC-1.3.023 (`DEFAULT_OAUTH_SCOPES` expanded to include `write:servicedesk-request`); BC-3.3.001 (`issue create` platform-endpoint invariant becomes conditional on `--request-type` absence). BC-INDEX.md must be updated to reflect new section numbering and cumulative count. |
| Architecture | New modules: `src/api/jsm/requests.rs`, `src/api/jsm/request_types.rs`, `src/cli/requesttype.rs`, `src/types/jsm/request_type.rs`. `api-surface.md` gains JSM request endpoints. `module-decomposition.md` gains four new module entries. No new traits or crate dependencies. `src/cli/mod.rs` and `src/main.rs` gain new enum variants following the `jr queue` pattern exactly. |
| UX | No UX spec change. All new commands follow existing output-channel profiles: `jr requesttype list/fields` uses Read-only profile (stdout for data, stderr for hints). `jr issue create --request-type` uses Symmetric profile matching existing `issue create` output contract (`{"key": "FOO-123"}`). |
| Stories | +1 story file cycle (4-story decomposition recommended: S-288-A API layer, S-288-B cache + CLI discovery, S-288-C OAuth scope gate, S-288-D dispatch fork). STORY-INDEX.md updated at F3. |
| Tests | 2 new integration test files (`tests/issue_create_jsm.rs`, `tests/requesttype_commands.rs`). 1 existing inline test updated (`default_oauth_scopes_pins_the_full_set_with_offline_access` in `src/cli/auth/tests/mod.rs`). Existing `tests/issue_create_json.rs`, `tests/issue_commands.rs`, `tests/queue.rs`, `tests/auth_profiles.rs` are regression baseline — must remain green without modification. |
| VPs | No VP directory exists; property correctness is anchored at BC level. Proptest candidates noted at F6: `requestFieldValues` map construction from `--field NAME=VALUE` pairs (duplicate keys, empty values, unicode names). |

## Files Likely Changed

| File | Change Type | Notes |
|------|-------------|-------|
| `src/api/jsm/requests.rs` | NEW | `JiraClient::create_jsm_request` (`POST /rest/servicedeskapi/request`); `JsmRequest` / `JsmRequestCreated` types inline |
| `src/api/jsm/request_types.rs` | NEW | `JiraClient::list_request_types` and `get_request_type_fields`; `isLastPage`-based pagination |
| `src/cli/requesttype.rs` | NEW | `handle(RequestTypeCommand, ...)` for `List` and `Fields`; uses `require_service_desk`, `partial_match`, and the two new API methods |
| `src/types/jsm/request_type.rs` | NEW | Serde structs: `RequestType`, `RequestTypeField`, `RequestTypeFieldsResponse` |
| `tests/issue_create_jsm.rs` | NEW | Wiremock tests: JSM dispatch path, `--on-behalf-of`, `--field`, non-JSM project error, platform-path non-interference |
| `tests/requesttype_commands.rs` | NEW | Wiremock tests: `requesttype list`, `requesttype fields`, `--output json` shape, partial-name disambiguation, not-found error |
| `src/api/jsm/mod.rs` | MODIFIED | Add `pub mod requests;` and `pub mod request_types;` |
| `src/types/jsm/mod.rs` | MODIFIED | Add `pub mod request_type;` and `pub use request_type::*;` |
| `src/cli/mod.rs` | MODIFIED | Add `pub mod requesttype;`; add `RequestType { command: RequestTypeCommand }` to `Command` enum; add `RequestTypeCommand` enum; add `--request-type`, `--field`, `--on-behalf-of` to `IssueCommand::Create` |
| `src/cli/issue/create.rs` | MODIFIED | Add `--request-type` conditional dispatch branch in `handle_create`; ~120–160 LOC addition to existing 1,601 LOC file |
| `src/api/auth.rs` | MODIFIED | Add `write:servicedesk-request` to `DEFAULT_OAUTH_SCOPES` concat literal (line 59) |
| `src/cli/auth/tests/mod.rs` | MODIFIED | Add `"write:servicedesk-request"` to `required` array in `default_oauth_scopes_pins_the_full_set_with_offline_access`; must be in the same commit as `auth.rs` |
| `src/cache.rs` | MODIFIED | Add `RequestTypeCache` struct, `Expiring` impl, `read_request_type_cache` / `write_request_type_cache` functions; cache key: `v1/<profile>/request_types_<service_desk_id>.json` |
| `src/main.rs` | MODIFIED | Add `cli::Command::RequestType { command }` dispatch arm following `cli::Command::Queue` pattern |
| `CLAUDE.md` | MODIFIED | Document `write:servicedesk-request` scope addition, `--request-type` / `--field` / `--on-behalf-of` flags, and two new top-level commands |

## Files NOT Changed (regression baseline)

- `tests/issue_create_json.rs` — UNCHANGED; `issue_create_json_returns_full_shape` pins the platform POST path; must fire to `/rest/api/3/issue`, not servicedeskapi, when `--request-type` is absent
- `tests/issue_commands.rs` — UNCHANGED; BC-3.3.002..006 coverage (platform create with assignee, without assignee, `--to me`, etc.); any dispatch-branch regression detected here
- `tests/issue_write_holdouts.rs` — UNCHANGED; holdout scenario guard for `issue create`; must remain green after dispatch refactor
- `tests/queue.rs` — UNCHANGED; `list_queues_returns_all_queues`, `list_queues_empty`; adjacent JSM API layer regression baseline
- `tests/auth_profiles.rs` — UNCHANGED; multi-profile isolation tests; scope expansion must not affect per-profile override behavior
- `tests/api_client.rs` — UNCHANGED; BC-1.6.042..045 scope-mismatch 401 handling; must still surface correct error hint for the new scope
- `src/api/jsm/servicedesks.rs` — UNCHANGED; `require_service_desk` and service desk ID resolution are reused, not modified
- `src/api/jsm/queues.rs` — UNCHANGED; adjacent JSM module; no behavior change
- `src/cli/issue/list.rs`, `workflow.rs`, `links.rs`, `helpers.rs` — UNCHANGED
- `src/api/jira/issues.rs` — UNCHANGED; platform create path unmodified
- `src/adf.rs`, `src/duration.rs`, `src/output.rs`, `src/jql.rs` — UNCHANGED
- `src/api/pagination.rs`, `src/api/rate_limit.rs`, `src/api/client.rs` — UNCHANGED

## Risk Assessment

| Module | Risk | Rationale |
|--------|------|-----------|
| `src/api/auth.rs` — `DEFAULT_OAUTH_SCOPES` | HIGH | Scope addition affects every OAuth-authenticated user on next token refresh or new login. If `write:servicedesk-request` is not registered in the Atlassian Developer Console for the embedded `jr` OAuth app before release, every new OAuth login and refresh will fail with `invalid_scope`. This is a release-coordination dependency — CI cannot catch the Developer Console mismatch. The pinning test `default_oauth_scopes_pins_the_full_set_with_offline_access` must be updated in the same commit; if it is updated but the Developer Console is not, CI passes but production breaks. Manual staging validation required before merge to `develop`. |
| `src/cli/issue/create.rs` — conditional dispatch fork | HIGH | `handle_create` is 1,601 LOC and the most complex handler in the codebase. The new `--request-type` branch must not alter the code path for calls that omit `--request-type`. Any accidental early-return, moved variable binding, or changed default for existing flags would silently break the platform path. Existing integration tests in `tests/issue_create_json.rs`, `tests/issue_commands.rs`, and `tests/issue_write_holdouts.rs` are the regression guards; they must remain green without modification. |
| `src/cli/mod.rs` — `IssueCommand::Create` variant | MEDIUM | Adding `--request-type`, `--field`, `--on-behalf-of` fields to the `Create` variant requires updating every exhaustive pattern match on `IssueCommand::Create` in the codebase. Rust's compiler enforces completeness — risk is a compilation-time failure rather than a silent regression, but it must be resolved before CI can pass. |
| `--no-input` parity on `jr issue create --request-type` | MEDIUM | When `--request-type NAME` resolves to an ambiguous partial match and `--no-input` is set, the handler must error cleanly rather than prompting. The `partial_match` module's `MatchResult::Ambiguous` arm must be wired to `JrError::UserError` in non-interactive mode, matching the pattern in `cli/queue.rs`. Omitting this would cause `--no-input` mode to hang or panic on ambiguous input. |
| JSON output shape parity for `issue create --request-type` | MEDIUM | The JSM `POST /rest/servicedeskapi/request` response differs from the platform `POST /rest/api/3/issue` response. Both return `issueKey` but in different top-level shapes. The JSON output when `--request-type` is set must emit `{"key": "<KEY>"}` to preserve the existing `--output json` contract used by automation (BC-3.3.001 / BC-3.8.001). |
| `src/cli/auth/tests/mod.rs` — scope pin test | MEDIUM | If `DEFAULT_OAUTH_SCOPES` is updated but the test is not (or vice versa), CI fails immediately. Risk is ordering: test must be updated in the same commit as `auth.rs`. No silent failure possible, but a broken CI that blocks unrelated PRs is a disruption risk during implementation. |
| `src/cache.rs` — new request type cache | LOW | Purely additive. New struct and two functions do not touch existing cache paths. Cache-miss behavior is self-healing via the existing `read_cache` pattern. No cross-profile leakage risk as long as cache key includes `service_desk_id`. |
| `src/api/jsm/requests.rs`, `request_types.rs` — new files | LOW | New files with no prior callers. Regression risk is zero for existing behavior; forward risk bounded by `tests/issue_create_jsm.rs` and `tests/requesttype_commands.rs`. |
| `src/types/jsm/request_type.rs` — new types | LOW | Additive serde structs. No existing type is modified. Deserialization failure on a real API response surfaces as a runtime error, not a silent regression. |
| `src/main.rs` — new dispatch arm | LOW | Adding `Command::RequestType` arm to an exhaustive match. Rust enforces completeness; a missing arm is a compile error. Follows exact `Command::Queue` template. |
| Output channel correctness — `jr requesttype` | LOW | New commands follow the Read-only profile. If stderr accidentally bleeds into stdout, `--output json` consumers receive corrupt output. Integration tests with `--output json` guard this. |

## Recommended Scope for Subsequent Phases

**F2 (Spec Evolution):**
- Architect: "PRD requires a new BC group for JSM request submission (distinct from existing `bc-3-issue-write.md` which covers platform issue creation). Verification properties needed for: (1) `--request-type` dispatches to JSM endpoint when set and platform endpoint when absent; (2) `requestFieldValues` map keys match `jira_schema.system` / `jira_schema.custom` names correctly; (3) partial-name resolution of request type name → ID is case-insensitive and errors cleanly on ambiguity; (4) cache is keyed per (profile, serviceDeskId), not globally. Architecture section updates: `api-surface.md` gains JSM request endpoints; `module-decomposition.md` gains `api/jsm/requests`, `api/jsm/request_types`, `cli/requesttype`, `types/jsm/request_type`."
- BA: Mint 17 new BCs (BC-3.8.001..009 in `bc-3-issue-write.md`; BC-X.12.001..008 in `cross-cutting.md`). Modify BC-1.3.023 and BC-3.3.001. Add 3 holdout scenarios (H-NEW-JSM-RT-001/002/003) as a new "Group 7: JSM Request Types" block in `holdout-scenarios.md`. Holdout count rises from 50 to 53. BC-INDEX.md updated for new sections and cumulative BC count.

**F3 (Story Decomposition):**
- Architect: "Decompose into at least four stories: S-288-A (new types + API client — pure API layer, no CLI); S-288-B (cache support + `jr requesttype list/fields` CLI commands — read-only surface, no OAuth scope change); S-288-C (OAuth scope addition + Developer Console coordination gate — prerequisite for write path); S-288-D (`jr issue create --request-type` conditional dispatch — depends on S-288-A, S-288-B, S-288-C)."
- BA: Register all four stories in STORY-INDEX.md at next available IDs. S-288-C acts as a release-gate blocker for S-288-D; this dependency must be explicit in the story file.

**F4 (Implementation):**
- Architect: "The `handle_create` modification (S-288-D) carries the highest risk and should be implemented last, after the read path is verified. ADF handling is already available (`markdown_to_adf`, `text_to_adf`) — pass `isAdfRequest: true` unconditionally when description is provided, matching existing platform behavior."
- BA: Every new integration test in `tests/issue_create_jsm.rs` and `tests/requesttype_commands.rs` should be written TDD-first (Red Gate) before the implementation files are added. The inline scope-pin test must be updated in the same atomic commit as the `DEFAULT_OAUTH_SCOPES` change.

**F5 (Adversarial Review):**
- Architect priority checks: "(1) Does the JSM path silently swallow the `--type` flag (issue type) that is required on the platform path but meaningless on the JSM path? Must error or warn clearly. (2) Does `--field NAME=VALUE` correctly construct `requestFieldValues` for multi-value fields (arrays vs. scalars)? (3) Is the `raiseOnBehalfOf` accountId validated before being passed through, or does it pass raw user input to the API?"

**F6 (Hardening):**
- Architect: "Proptest candidates: `requestFieldValues` map construction from `--field NAME=VALUE` pairs (duplicate keys, empty values, unicode names). Mutation testing scope: the `partial_match` resolution branch in `requesttype` handler and the `request_type.is_some()` branch gate in `handle_create`."

**F7 (Convergence):**
- Architect: "Developer Console scope registration must be confirmed before the PR merges to `develop`. Suggest a checklist item in the PR template for this feature specifically."
- BA: PR labels: `feat`, `jsm`. Target branch: `develop`. Closes #288.

## Deferred

- `jr version --output json` (NFR-O-X): remains deferred to v2; not affected by #288.
- JSON output `_meta: {version: N}` envelope (NFR-O-P): remains deferred to v2.
- JSM SLA management, approval workflows, linked asset submission via JSM: out of scope; file as separate issues if encountered during implementation.
- `sprint list` start/end dates (NFR-O-U): unrelated; remains deferred.
- Multi-value `requestFieldValues` array vs. scalar disambiguation beyond first `=` split: implementation detail to be resolved in F4; if complex, file as a follow-up issue rather than blocking S-288-D.
- `auth list --output json` (NFR-O-N): unrelated; remains deferred.
