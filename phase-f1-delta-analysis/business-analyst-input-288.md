---
document_type: business-analyst-input
phase: F1
issue: 288
producer: business-analyst
inputs:
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - ".factory/specs/prd/bc-7-output-render.md"
  - ".factory/specs/prd/cross-cutting.md"
  - ".factory/specs/prd/nfr-catalog.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - "src/api/auth.rs"
  - "tests/issue_create_json.rs"
  - "tests/queue.rs"
input-hash: "[pending]"
status: draft
timestamp: 2026-05-18
---

# F1 Business-Analyst Input — Issue #288

## BC Mapping

### Overview of the affected surface

Issue #288 introduces two distinct user-facing surfaces on top of the existing JSM (Jira Service
Management) infrastructure that `jr` partially uses today:

1. A new command group `jr requesttype` with two subcommands: `list` and `fields`.
2. A new flag `--request-type <NAME|ID>` on `jr issue create` that, when set, dispatches to
   `POST /rest/servicedeskapi/request` instead of `POST /rest/api/3/issue`.

Secondary changes that cascade from the above:

3. `write:servicedesk-request` must be added to `DEFAULT_OAUTH_SCOPES` in `src/api/auth.rs`.
4. Two optional flags on `jr issue create`: `--on-behalf-of <accountId>` and repeatable
   `--field NAME=VALUE` for JSM custom field injection.

The BC corpus has no existing contracts for `jr requesttype` at all. The existing `jr queue`
commands (BC-X.8.004) interact with the same service desk API layer but only on the read side.
BC-3.3.001 through BC-3.3.009 contract `jr issue create` exclusively against the platform v3
endpoint. BC-1.3.023 pins `DEFAULT_OAUTH_SCOPES` to its exact current set.

### Existing BCs requiring modification

| BC ID | Title | Change Required |
|-------|-------|-----------------|
| BC-1.3.023 | `DEFAULT_OAUTH_SCOPES` includes `offline_access`, CMDB scopes, and `write:jira-work` | MODIFICATION REQUIRED. The scope string in `src/api/auth.rs:59-64` must include `write:servicedesk-request`. The BC body must be amended to list the expanded set and note the JSM write-request scope. Confidence remains HIGH. The regression test `default_oauth_scopes_pins_the_full_set_with_offline_access` (cited at `src/api/auth.rs:57`) must be updated in the same PR that adds the scope — this test is a primary MUST-STAY-GREEN regression guard. |
| BC-3.3.001 | `issue create` POSTs `/rest/api/3/issue` returning `{"key": "FOO-123"}` | MODIFICATION REQUIRED (body update only). The BC title and behavior description state that `issue create` always POSTs to `/rest/api/3/issue`. After #288 that invariant becomes conditional: the platform endpoint is used ONLY when `--request-type` is absent. The BC body needs a routing clause: "When `--request-type` is absent, POSTs `/rest/api/3/issue`. When `--request-type` is present, dispatches to `POST /rest/servicedeskapi/request` (see BC-3.8.001)." The core BC is otherwise unchanged — the platform create path is unaffected. |

### Gaps requiring new BCs

The following new BCs are required. None can be collapsed into an existing BC body without
losing contractual precision.

**BC numbering proposal:** The current corpus ends `bc-3-issue-write.md` at section 3.7
(Remote Links, BC-3.7.001..004; 78 BCs cumulative). A new subdomain `3.8 JSM Request Create`
fits naturally there — it is issue-write semantics (the result is a Jira issue) dispatched
to a different endpoint. The `jr requesttype` discovery commands do not produce issues; they
are closer to the project-metadata discovery pattern in BC-X.8 (Projects & Queues). A new
cross-cutting section `X.12 JSM Request Types` is the right home.

**Justification for BC-3.8 vs. a new top-level section:** The `jr requesttype` commands
parallel `jr issue resolutions` (BC-3.2.010) and `jr project` (BC-X.8) — both are discovery
helpers subordinate to a write operation. BC-3.8 keeps JSM request creation alongside
the write path it modifies. X.12 keeps the discovery commands alongside the existing
project/queue discovery in the cross-cutting section.

#### Section BC-3.8 — JSM Request Create (new subdomain in bc-3-issue-write.md)

| Proposed BC ID | Summary |
|----------------|---------|
| BC-3.8.001 | `issue create --request-type <NAME>` dispatches to `POST /rest/servicedeskapi/request`; body: `{serviceDeskId, requestTypeId, requestFieldValues, isAdfRequest?}`; response 201 includes `issueKey`; JSON output `{"key": "<issueKey>"}` |
| BC-3.8.002 | `issue create --request-type <NAME>` resolves service desk ID via project-meta lookup (same cache path as `jr queue`) before POSTing |
| BC-3.8.003 | `--request-type` with no matching request type in service desk → exit 64 + candidates list (mirrors `issue move` ambiguous-transition pattern) |
| BC-3.8.004 | `--request-type` partial-substring single-match (unambiguous) → exact resolution proceeds |
| BC-3.8.005 | `--request-type` and no `--project` flag → exit 64 "project is required for JSM request creation" (service desk ID cannot be discovered without it) |
| BC-3.8.006 | `--on-behalf-of <accountId>` on `issue create --request-type` injects `raiseOnBehalfOf` in the JSM request body; omission → field absent from body (NOT `null`) |
| BC-3.8.007 | `--field NAME=VALUE` (repeatable) on `issue create --request-type` maps field name to `requestFieldValues` map; parsing: first `=` is the delimiter (value may contain `=`); duplicate NAME → last wins |
| BC-3.8.008 | `issue create --request-type` without `--request-type` on non-JSM project produces no JSM API call; routes to platform create as before |
| BC-3.8.009 | `issue create --request-type` 403/401 → scope-mismatch detection path (BC-X.3.005) handles `write:servicedesk-request` scope error with actionable hint |

#### Section X.12 — JSM Request Types (new subdomain in cross-cutting.md)

| Proposed BC ID | Summary |
|----------------|---------|
| BC-X.12.001 | `jr requesttype list --project <KEY>` GETs `/rest/servicedeskapi/servicedesk/<id>/requesttype` and returns `[{id, name, description, ...}]` |
| BC-X.12.002 | `jr requesttype list --project <KEY> --output json` returns structured JSON array; table shows id, name, description columns |
| BC-X.12.003 | `jr requesttype list` without `--project` → exit 64 "project is required" |
| BC-X.12.004 | `jr requesttype list --project <KEY>` for a non-JSM (software) project → exit 64 with "Jira Software project" error (reuses `require_service_desk` path, BC-X.8.004) |
| BC-X.12.005 | `jr requesttype fields --project <KEY> --request-type <NAME|ID>` GETs `/rest/servicedeskapi/servicedesk/<id>/requesttype/<rtId>/field`; returns fields with `required: bool` |
| BC-X.12.006 | `jr requesttype fields --output json` returns structured JSON with `required` flag per field; table distinguishes REQUIRED vs OPTIONAL columns |
| BC-X.12.007 | `jr requesttype list` partial-match on name (case-insensitive substring): single match → exact resolution; multiple matches → exit 64 + candidates |
| BC-X.12.008 | `jr requesttype list` and `jr requesttype fields` 5xx → exit 1 + `API error (500)` (standard error path); 401 → exit 2 + `jr auth login` |

**Total new BCs: 17** (9 in BC-3.8, 8 in X.12).

**Total modified BCs: 2** (BC-1.3.023, BC-3.3.001).

### Key finding

BC-3.3.001 contracts the `issue create` platform endpoint unconditionally. After #288, it
becomes a conditional: platform endpoint when `--request-type` absent, JSM endpoint when
present. The two routing branches are parallel command executions — no user-visible flag
conflict between them (they are mutually exclusive by presence of `--request-type`). The
BC corpus currently has zero contracts for request-type discovery or JSM request creation.
The `jr queue` surface (tests/queue.rs) is the nearest precedent for the service desk API
layer but covers only the read path.

---

## NFR / VP Mapping

| NFR-ID / VP-ID | Title | Coverage Note |
|----------------|-------|---------------|
| BC-7.1.003 (via NFR) | `--no-input` auto-enables when stdin is not a TTY | INHERITED. Both `jr requesttype list` and `jr requesttype fields` must have non-interactive flag equivalents. `--project` and `--request-type` flags are the non-interactive equivalents for these commands (no prompt fallbacks without `--no-input`). |
| BC-7.1.001 | `--output table` / `--output json` | INHERITED. All new commands inherit the table/JSON output bifurcation. JSON shapes must be documented in a new BC-7.4.X entry (proposed BC-7.4.017: `issue create --request-type --output json` → same shape as `issue create` without flag: `{"key": "FOO-123"}`). |
| BC-7.3.007 / BC-X.3.007 | Error messages must suggest next step | INHERITED. Every new error path (no-project, scope-mismatch, non-JSM-project, request-type-not-found) must include an actionable hint. This is the project convention codified in CLAUDE.md. |
| BC-X.3.002 | 401 → `Not authenticated` + `jr auth login` exit 2 | INHERITED by both new command groups. Standard 401 handling applies. |
| BC-X.3.003 | 5xx → `API error (status)` exit 1 | INHERITED. |
| BC-X.8.004 | `require_service_desk` errors for non-JSM project | REUSED. Both `jr requesttype list/fields` and `jr issue create --request-type` should reuse the `require_service_desk` check to fail fast on software projects. No new logic needed — reuse path. |
| BC-1.3.023 | `DEFAULT_OAUTH_SCOPES` set | DIRECTLY MODIFIED. Adding `write:servicedesk-request` to the scope string. This is not just an inherited NFR — it is a line-level change to `src/api/auth.rs:59-64`. |
| NFR-O-A (DEFER) | Structured logging (tracing) | NOT affected by #288. The `eprintln!` pattern is inherited by any new handler; no new concern. |
| NFR-S-B (HIGH) | `JR_AUTH_HEADER` env unconditional in production | NOT affected by #288. The JSM endpoints use the same `JiraClient` HTTP path as all other endpoints — no change to auth injection. |
| (no existing NFR) | `write:servicedesk-request` scope expansion regression | NEW CONCERN. The `default_oauth_scopes_pins_the_full_set_with_offline_access` inline test in `src/api/auth.rs` is the sole regression guard for scope drift. It must be updated in the same commit as the scope addition. If not, CI catches the diff immediately. This is a LOW-severity concern (caught by existing test infrastructure) but must be named explicitly. |

No new NFR entry is warranted at the catalog level. The scope addition is a one-line change
with an existing regression test; the new commands inherit all output, error, and
non-interactive NFRs already present in the catalog.

---

## Story Risk Zone

| Story / PR | Why in risk zone |
|------------|-----------------|
| PR that delivered `jr queue list/view` (bc-X.8.004 / `tests/queue.rs`) | Delivered `src/api/jsm/servicedesks.rs` and `src/api/jsm/queues.rs` — the JSM API layer. #288 extends this same layer. Any regression in service-desk-ID resolution or JSM pagination affects #288's implementation. |
| PR that delivered `jr issue create` (BC-3.3.001..009 / `tests/issue_create_json.rs`) | `src/cli/issue/create.rs::handle_create` is the dispatch point. #288 adds a conditional branch to this function. Every existing `issue create` test is in the blast radius of the routing refactor. |
| PR that delivered `jr issue create --output json` full-shape (issue #253 / `tests/issue_create_json.rs`) | Delivered the POST+GET-then-merge shape for create JSON output. #288's JSM path must produce an equivalent or identical JSON shape — the test `issue_create_json_returns_full_shape` is a regression baseline. |
| `src/api/auth.rs` — DEFAULT_OAUTH_SCOPES and the embedded OAuth app PR (ADR-0006) | Any change to `DEFAULT_OAUTH_SCOPES` affects every new OAuth login. The `default_oauth_scopes_pins_the_full_set_with_offline_access` regression test is the MUST-STAY-GREEN guard. |
| BC-3.2.009 / `tests/issue_resolution.rs` (`jr issue resolutions`) | Precedent for a discovery command subordinate to a write path. #288's `jr requesttype list/fields` follows this same pattern; the implementation pattern is the reference. |

---

## Tests in Neighborhood

### MUST stay green (regression baseline)

| File | Test | Relation to #288 |
|------|------|-----------------|
| `tests/issue_create_json.rs` | `issue_create_json_returns_full_shape` | POSTs to `/rest/api/3/issue` — the platform path that must remain the default when `--request-type` is absent. If the dispatch refactor breaks the routing condition, this test detects it. |
| `tests/issue_create_json.rs` | All tests in file | Entire `issue create` integration surface. Any signature change to `handle_create` ripples here. |
| `tests/cli_smoke.rs` | `test around BC-3.3.007` (`--to` ⊕ `--account-id` conflict) | Clap flag-conflict tests for `issue create` will break if the new flags (`--request-type`, `--on-behalf-of`, `--field`) introduce accidental conflicts. |
| `src/api/auth.rs` | `default_oauth_scopes_pins_the_full_set_with_offline_access` (inline test, approx. line 57 vicinity) | Pins the exact scope string byte-for-byte. MUST be updated in the same commit as the scope addition. Failure here breaks the OAuth login path for all users. |
| `tests/queue.rs` | `list_queues_returns_all_queues`, `list_queues_empty` | Exercises `client.list_queues(serviceDesk_id)` — the adjacent JSM API layer. Regression here would indicate a break in the `JiraClient` routing to `servicedeskapi` base path. |
| `tests/issue_commands.rs` | BC-3.3.002..006 coverage (create with assignee, without assignee, `--to me`, etc.) | All `issue create` platform-path integration tests. Must not be affected by the `--request-type` dispatch branch. |
| `tests/auth_profiles.rs` | All multi-profile tests | Scope expansion affects every OAuth login flow. Profile isolation must be preserved — new scope does not change per-profile override behavior. |
| `tests/api_client.rs` | BC-1.6.042..045 (scope-mismatch 401 handling) | The 401 scope-mismatch detection (case-insensitive substring `"scope does not match"`) is the UX gate for the new `write:servicedesk-request` requirement. These tests must stay green to ensure the error path surfaces the right hint. |

### Needs new coverage (gap)

| File (proposed) | Test description |
|-----------------|-----------------|
| `tests/issue_create_jsm.rs` (new) | `issue_create_with_request_type_posts_to_servicedeskapi` — POST to `/rest/servicedeskapi/request` with body `{serviceDeskId, requestTypeId, requestFieldValues}` and response `{issueId, issueKey}`. Assert stdout JSON `{"key": "HELP-42"}`. |
| `tests/issue_create_jsm.rs` (new) | `issue_create_without_request_type_does_not_call_servicedeskapi` — `Mock::expect(0)` on `/rest/servicedeskapi/request`; POST to `/rest/api/3/issue` fires as before. |
| `tests/issue_create_jsm.rs` (new) | `issue_create_request_type_not_found_exits_64` — service desk returns request types list without the named type; assert exit 64 + candidates in stderr. |
| `tests/issue_create_jsm.rs` (new) | `issue_create_on_behalf_of_injects_raise_on_behalf_of_field` — body contains `raiseOnBehalfOf: "<accountId>"` when `--on-behalf-of` flag is set; absent when flag is omitted. |
| `tests/issue_create_jsm.rs` (new) | `issue_create_field_flag_populates_request_field_values` — `--field "Summary=VPN broken"` produces `{"Summary": "VPN broken"}` in `requestFieldValues`. |
| `tests/requesttype_commands.rs` (new) | `requesttype_list_returns_types_from_servicedesk` — GET `/rest/servicedeskapi/servicedesk/<id>/requesttype` returns 2 types; assert table/JSON output. |
| `tests/requesttype_commands.rs` (new) | `requesttype_list_non_jsm_project_exits_64` — project meta indicates software project; exit 64 + "Jira Software project" message; no HTTP to servicedeskapi endpoint. |
| `tests/requesttype_commands.rs` (new) | `requesttype_fields_returns_required_and_optional_fields` — GET `/rest/servicedeskapi/servicedesk/<id>/requesttype/<rtId>/field`; JSON includes `required: true/false` per field. |
| `tests/requesttype_commands.rs` (new) | `requesttype_list_partial_match_ambiguous_exits_64` — two request types with names both containing the substring; assert exit 64 + both candidates. |
| `src/api/auth.rs` | Update `default_oauth_scopes_pins_the_full_set_with_offline_access` inline test to include `write:servicedesk-request` in the expected string. |
| `tests/cli_smoke.rs` | New flag smoke tests: `--request-type` accepted by `issue create`; `--on-behalf-of` accepted; `--field` accepted as repeatable; `jr requesttype list --help` accepted; `jr requesttype fields --help` accepted. |

---

## Feature Type

`backend` — all changes are within `src/` CLI handlers and API layer. No UI, no config
format change (the scope string is code-side, not user-side config). One new serde
struct group (JSM request types response) and one new CLI subcommand group.

---

## Intent Classification

`feature`

**Reasoning:** Issue #288 introduces entirely new user-visible commands (`jr requesttype
list`, `jr requesttype fields`) and a new flag on an existing command (`--request-type` on
`jr issue create`). The platform-create path is unchanged in behavior. The JSM dispatch
path is a net-new capability with a different API endpoint, different request body, and
a new scope requirement.

**Not `refactor`:** New user-facing behavior is added. Platform create path is unmodified.

**Not `bug-fix`:** No existing behavior is broken or wrong. The issue is a capability gap.

---

## Trivial-Scope Verdict

NOT TRIVIAL — STANDARD scope.

Criterion-by-criterion:

- **Single module / single file:** NO. Changes span at minimum: `src/cli/issue/create.rs`
  (dispatch branch), `src/api/jsm/servicedesks.rs` or a new `src/api/jsm/request_types.rs`
  (new API call), `src/cli/` (new `requesttype.rs` handler), `src/api/auth.rs` (scope
  addition), plus at least one new types file in `src/types/jsm/`.
- **No new BCs:** NO. 17 new BCs proposed (9 in BC-3.8, 8 in X.12), 2 BCs modified.
- **No architecture change:** MODERATE. A new top-level CLI subcommand group (`requesttype`)
  is added, matching the existing pattern for `board`, `sprint`, `queue`. No new abstraction
  layer. No new crate dependency anticipated. The JSM API module exists (`src/api/jsm/`).
- **No new external deps:** LIKELY YES. The `wiremock` + `assert_cmd` test patterns used
  for `queue.rs` cover the JSM API layer without new crates.
- **LOW regression risk:** NO. The existing `issue create` dispatch is modified
  (conditional branch), and `DEFAULT_OAUTH_SCOPES` is changed (regression-pinned by an
  existing inline test that must be updated simultaneously). Both are moderate-risk changes
  that require attention.

Verdict: **STANDARD**. Requires a proper story file, BC-level F2 spec evolution for the
17 new BCs, and a full TDD pass for the new commands and dispatch branch.

---

## Holdout Scenario Gap Analysis

The current `holdout-scenarios.md` (50 scenarios, version 1.1.1, last updated 2026-05-07)
contains no JSM request-type scenarios. The nearest existing holdouts are:

- H-012: 401 + scope-mismatch — relevant to the `write:servicedesk-request` scope expansion
  path but does not test JSM request creation specifically.
- No scenario covers `jr requesttype list`, `jr requesttype fields`, or
  `jr issue create --request-type`.

**Proposed new holdout scenarios:**

### H-NEW-JSM-RT-001: JSM request creation via `issue create --request-type`

**Setup**: Wiremock service desk with request type list `[{id: 5, name: "IT Help", ...}]`.
Mock POST `/rest/servicedeskapi/request` returns `201 {issueId: "10042", issueKey: "HELP-42", _links: {web: {href: "https://example.atlassian.net/browse/HELP-42"}}}`.
**Action**: `jr issue create --project HELPDESK --request-type "IT Help" --summary "VPN broken" --no-input --output json`
**Expected**: exit 0; stdout JSON `{"key": "HELP-42"}`; POST to `/rest/servicedeskapi/request` fired exactly once with body containing `requestTypeId: 5` and `requestFieldValues.summary: "VPN broken"`. Platform POST `/rest/api/3/issue` mock NOT called (`expect(0)`).
**Why hidden**: The routing branch decision between platform and JSM endpoints is invisible
from output alone — mock-call counts are required to pin which endpoint was invoked.
**BC refs**: BC-3.8.001, BC-3.8.002, BC-3.8.008

---

### H-NEW-JSM-RT-002: `requesttype list` on software project exits 64 with JSM hint

**Setup**: Config with project `PROJ` returning project meta with `typeKey = "software"`.
No servicedeskapi mock (or `expect(0)` on it).
**Action**: `jr requesttype list --project PROJ --no-input`
**Expected**: exit 64; stderr contains `Jira Software project` AND actionable suggestion
(e.g., `Queue commands require a JSM project`). No HTTP call to servicedeskapi.
**Why hidden**: The `require_service_desk` gate is a client-side check before any HTTP;
its correct invocation for `requesttype list` is invisible without mock-call verification.
**BC refs**: BC-X.12.004, BC-X.8.004

---

### H-NEW-JSM-RT-003: `issue create --request-type` 401 surfaces `write:servicedesk-request` scope hint

**Setup**: Wiremock POST `/rest/servicedeskapi/request` returns 401 body
`{message: "Unauthorized; scope does not match"}`.
**Action**: `jr issue create --project HELPDESK --request-type "IT Help" --summary "VPN broken" --no-input`
**Expected**: exit 2; stderr contains `Insufficient token scope` AND `write:servicedesk-request`
AND an OAuth re-authorization hint. Mirrors H-012 behavior for the new write scope.
**Why hidden**: The 401-scope-mismatch dispatch (BC-X.3.005) must pick up the new scope name
in its hint text. Without an explicit test, a copy-paste of the existing hint that omits
`write:servicedesk-request` would be invisible to users — they would see a generic scope
error with no actionable path to fix it.
**BC refs**: BC-3.8.009, BC-X.3.005, BC-1.6.042

---

**Holdout count after #288:** 53 (50 existing + 3 new). Proposed IDs:
H-NEW-JSM-RT-001, H-NEW-JSM-RT-002, H-NEW-JSM-RT-003.

These should be added to `holdout-scenarios.md` as a new "Group 7: JSM Request Types" block
in the same F2 spec-evolution pass that mints the BC-3.8 and X.12 BC bodies.
