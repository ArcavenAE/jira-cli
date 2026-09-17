---
document_type: story
level: ops
story_id: "S-cycle8-jsm-servicedeskapi-oauth-routing"
epic_id: "OAUTH-SURFACE-CORRECTNESS-1"
title: "JSM servicedeskapi OAuth gateway routing: 6-site get_from_instance/post_to_instance -> get/post swap (issue #831)"
wave: 1
status: draft
intent: bug-fix
feature_type: correctness
mode: feature
scope: standard
severity: HIGH
trivial_scope: false
producer: story-writer
timestamp: "2026-09-17T00:00:00"
phase: 3
inputs:
  - ".factory/cycles/cycle-008/F1-delta-analysis.md"
  - ".factory/cycles/cycle-008/F2-architecture-delta.md"
  - ".factory/specs/architecture/decisions/ADR-0026-oauth-3lo-gateway-routing-invariant-and-granular-jira-software-scopes.md"
  - ".factory/cycles/cycle-008/verification-delta.md"
  - ".factory/specs/prd/bc-4-assets-cmdb.md"
  - "src/api/jsm/servicedesks.rs"
  - "src/api/jsm/request_types.rs"
  - "src/api/jsm/queues.rs"
  - "src/api/jsm/requests.rs"
  - "src/api/client.rs"
input-hash: "8862ea1"
traces_to: "ADR-0026 Decision 1; BC-4.2.001 unified fix table"
cycle: cycle-008-oauth-surface-correctness
estimated_effort: small
estimated_days: 1.5
target_module: "src/api/jsm/servicedesks.rs, src/api/jsm/request_types.rs, src/api/jsm/queues.rs, src/api/jsm/requests.rs"
subsystems: ["SS-05"]
# SS-05 (JSM API Resources, src/api/jsm/) is the sole subsystem this story
# touches -- all 6 call sites this story swaps live in that directory, and
# no other subsystem's code is edited (the docs/adr/ backlink task is prose
# forward-reference only, not a code change to any subsystem).
depends_on: []
blocks: ["S-cycle8-jsm-attachments-oauth-verification"]
# Hard, real dependency: S-cycle8-jsm-attachments-oauth-verification's whole
# purpose is to prove the JSM two-step attachment flow now succeeds under
# OAuth, and that flow's serviceDeskId resolution transitively calls
# list_service_desks (this story's own fix site) -- there is nothing for
# that story to verify until this one lands.
behavioral_contracts:
  - BC-4.2.001
bcs:
  - BC-4.2.001
verification_properties:
  - VP-OAUTH-GW-001
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0026"]
sd_refs: []
priority: P0
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-008/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: strict
module_criticality: HIGH
points: 5
acceptance_criteria_count: 9
assumption_validations: []
risk_mitigations: []
created: "2026-09-17"
version: "1.0"
last_updated: "2026-09-17"
breaking_change: false
retroactive: false
origin: >
  cycle-008 oauth-surface-correctness, Wave 1, no deps, blocks
  S-cycle8-jsm-attachments-oauth-verification. Closes GitHub issue #831
  (Defect 1 / JSM routing). F1 delta-analysis (.factory/cycles/cycle-008/F1-delta-analysis.md
  §2.1) code-audited all 6 call sites directly and confirmed each is a pure
  base-URL-method swap (get_from_instance -> get, post_to_instance -> post),
  no payload/response-shape change anywhere. ADR-0026 Decision 1 finalizes
  this as the canonical 7-call-site fix (6 in this story's JSM scope + 1 in
  the sibling S-cycle8-assets-workspace-oauth-routing story, sharing the
  single BC-4.2.001 anchor). Under API-token auth base_url() == instance_url(),
  so the swap is a provable no-op for that auth scheme; it only changes
  behavior for OAuth (3LO) profiles, where the two hosts diverge -- this is
  why every existing wiremock test (built via JiraClient::new_for_test, which
  sets base_url == instance_url) was structurally blind to this defect class
  until live OAuth use surfaced it. Human-approved at the cycle-008 F1/F2
  gates (DEC-368; F2 gate finalization 2026-09-17).
---

> **tdd_mode:** `strict` — this is a real, security/correctness-relevant
> routing fix on the entry point for the entire JSM command family
> (`module_criticality: HIGH`). Each of the 6 call sites needs a genuine
> RED-before-GREEN proof using the `JiraClient::new_for_test_with_instance_url`
> seam — a facade pinning test that merely re-asserts today's behavior would
> not prove the fix.

> **Execute:** `/vsdd-factory:deliver-story S-cycle8-jsm-servicedeskapi-oauth-routing`

# S-cycle8-jsm-servicedeskapi-oauth-routing — JSM servicedeskapi OAuth gateway routing (issue #831)

## Narrative

- **As a** `jr` user authenticated via OAuth (3LO)
- **I want to** have `jr queue`, `jr requesttype`, and `jr issue create --request-type` route
  their `servicedeskapi` requests through the API gateway (`base_url`) instead of the site host
  (`instance_url`)
- **So that** these commands stop 401-ing under OAuth while remaining byte-for-byte unchanged
  for API-token profiles, where the two hosts already resolve identically

## Behavioral Contracts

| BC | Role | Clauses this story implements |
|----|------|-------------------------------|
| BC-4.2.001 | PRIMARY (amended) | The "OAuth 3LO gateway-routing invariant" clause and its unified 7-call-site fix table — this story implements 6 of the 7 rows (the JSM `servicedeskapi` sibling sites); the 7th row (`get_or_fetch_workspace_id`) is implemented by the sibling story `S-cycle8-assets-workspace-oauth-routing`, sharing this same BC anchor per ADR-0026's explicit "anchored here... rather than duplicated" instruction |

**Anchor justification:** BC-4.2.001 is the single canonical BC-level statement of the OAuth
gateway-routing invariant across all 7 call sites (ADR-0026 Decision 1); this story does not
introduce a separate BC for its 6 JSM sites because the F1/F2 passes explicitly confirmed
BC-X.8.004-010 and BC-X.12.001-008 (the JSM payload/caching contracts) need NO shape change and
are confirmed unaffected by regression test, not by a spec edit — inventing a parallel routing BC
under `cross-cutting.md` would duplicate BC-4.2.001's own table.

## Acceptance Criteria

### AC-001 (traces to BC-4.2.001 fix-table row 1)
`src/api/jsm/servicedesks.rs::list_service_desks` (~L22) calls `self.get(&path)` instead of
`self.get_from_instance(&path)`. No other line in the function changes — same path string, same
response deserialization.
**Test:** `test_bc_4_2_001_list_service_desks_targets_base_url_under_oauth` — constructs the
client via `JiraClient::new_for_test_with_instance_url(base_url, instance_url, auth_header)` with
`base_url != instance_url`, mounts a wiremock server at `base_url` only, asserts the mock receives
the request and that an `instance_url`-mounted mock (also stood up in the same test) receives
ZERO requests.

### AC-002 (traces to BC-4.2.001 fix-table row 2)
`src/api/jsm/request_types.rs::list_request_types` (~L46) calls `self.get(...)` instead of
`self.get_from_instance(...)`.
**Test:** `test_bc_4_2_001_list_request_types_targets_base_url_under_oauth` — same
`new_for_test_with_instance_url` + dual-mock + zero-requests-on-`instance_url` pattern as AC-001.

### AC-003 (traces to BC-4.2.001 fix-table row 3)
`src/api/jsm/request_types.rs::get_request_type_fields` (~L73) calls `self.get(...)` instead of
`self.get_from_instance(...)`.
**Test:** `test_bc_4_2_001_get_request_type_fields_targets_base_url_under_oauth` — same pattern.

### AC-004 (traces to BC-4.2.001 fix-table row 4)
`src/api/jsm/queues.rs::list_queues` (~L24) calls `self.get(...)` instead of
`self.get_from_instance(...)`.
**Test:** `test_bc_4_2_001_list_queues_targets_base_url_under_oauth` — same pattern.

### AC-005 (traces to BC-4.2.001 fix-table row 5)
`src/api/jsm/queues.rs::get_queue_issue_keys` (~L67) calls `self.get(...)` instead of
`self.get_from_instance(...)`.
**Test:** `test_bc_4_2_001_get_queue_issue_keys_targets_base_url_under_oauth` — same pattern.

### AC-006 (traces to BC-4.2.001 fix-table row 6)
`src/api/jsm/requests.rs::create_jsm_request` (~L28) calls `self.post(...)` instead of
`self.post_to_instance(...)`. Request body construction (`JsmRequestBuilder::build`) is
UNCHANGED — this AC touches only the transport call, never the payload.
**Test:** `test_bc_4_2_001_create_jsm_request_targets_base_url_under_oauth` — same
`new_for_test_with_instance_url` pattern, POST variant; asserts the mocked gateway endpoint
receives the POST body byte-for-byte identical to today's payload shape.

### AC-007 (regression guard, traces to F1 §2.1 / ADR-0026 Decision 1 "no payload change")
All pre-existing wiremock tests in `tests/jsm_request_api.rs` that exercise these 6 functions
(constructed via the ordinary `JiraClient::new_for_test`, where `base_url == instance_url`) pass
unmodified after the swap — proving the fix is a no-op for API-token profiles.
**Test:** full `cargo test --test jsm_request_api` (and any other test file covering these 6
functions) green, no test file edits required for this AC beyond what AC-001..006 add.

### AC-008 (regression guard, traces to F1 §3 — BC-X.8.004-010 / BC-X.12.001-008 unaffected)
`src/api/jsm/servicedesks.rs::get_or_fetch_project_meta`, `require_service_desk`, and
`resolve_service_desk_id` (all downstream of `list_service_desks` in the same file) are
byte-for-byte UNCHANGED — this story touches only the one line inside `list_service_desks` named
in AC-001.
**Test:** diff review confirms no other line in `servicedesks.rs` changes; existing
`require_service_desk`/queue/requesttype test suites (`tests/jsm_request_api.rs`, any
`require_service_desk`-specific tests) pass unmodified.

### AC-009 (traces to CLAUDE.md conventions — CHANGELOG delivery + deferred docs backlink)
`CHANGELOG.md`'s `[Unreleased]` section gains a `Fixed` entry describing: `jr queue`,
`jr requesttype`, and `jr issue create --request-type` now work under OAuth (3LO) profiles
(previously 401'd due to wrong-host routing); no behavior change for API-token profiles; closes
#831. Additionally, in the SAME PR, `docs/adr/0009-handle-open-instance-url.md`,
`docs/adr/0006-embedded-jr-oauth-app.md`, and `docs/adr/0013-pkce-deferral.md` each gain a short
forward-reference line in their existing "Related ADRs"/equivalent section pointing at ADR-0026 —
via a direct, minimal `Edit` to each file, per ADR-0026's own "Bidirectional backlink note"
(these three files live in the pre-VSDD-factory `docs/adr/` track, editable only through the
normal PR flow against `develop`, not through `.factory/`-only tooling or the `create-adr`
skill's bidirectional-patch mechanism).
**Test:** N/A (doc artifact); presence check via PR review.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `list_service_desks` | `src/api/jsm/servicedesks.rs` | Effectful (HTTP GET) |
| `list_request_types` / `get_request_type_fields` | `src/api/jsm/request_types.rs` | Effectful (HTTP GET) |
| `list_queues` / `get_queue_issue_keys` | `src/api/jsm/queues.rs` | Effectful (HTTP GET) |
| `create_jsm_request` | `src/api/jsm/requests.rs` | Effectful (HTTP POST) |
| `get`/`post`/`get_from_instance`/`post_to_instance` | `src/api/client.rs` | Effectful (unchanged — this story only changes WHICH of these each call site invokes) |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-1 | API-token profile, any of the 6 commands | Byte-for-byte unchanged behavior — `base_url() == instance_url()` for this auth scheme, confirmed by AC-007 |
| EC-2 | OAuth profile, cache-hit path (e.g. `get_or_fetch_project_meta` already cached) | No HTTP call at all — this story's swap only affects the shape of a live request when one is actually made; cache-hit paths are unaffected |
| EC-3 | A future accidental revert of any of the 6 sites back to `get_from_instance`/`post_to_instance` | Immediately caught — each AC-00X test's negative-control assertion (`instance_url` mock received zero requests) fails |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `src/api/jsm/servicedesks.rs` | effectful-shell | HTTP GET call, network I/O |
| `src/api/jsm/request_types.rs` | effectful-shell | HTTP GET calls, network I/O |
| `src/api/jsm/queues.rs` | effectful-shell | HTTP GET calls, network I/O |
| `src/api/jsm/requests.rs` | effectful-shell | HTTP POST call, network I/O |
| `src/api/client.rs` (`get`/`post`/`get_from_instance`/`post_to_instance`) | effectful-shell | HTTP transport primitives, unchanged by this story |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~2,400 |
| Referenced code (6 functions across 4 files, `client.rs`'s `get`/`post`/`get_from_instance`/`post_to_instance`/`new_for_test_with_instance_url`) | ~4,000 |
| Test files (`tests/jsm_request_api.rs` relevant sections, new test module) | ~3,500 |
| Tool output overhead (cargo test/clippy) | ~2,000 |
| **Total** | **~11,900** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~6%** |

## Tasks

1. [ ] Write failing tests AC-001 through AC-006 (one per call site, `new_for_test_with_instance_url`
   seam, dual-mock + negative-control pattern) — `test-writer`
2. [ ] Verify Red Gate: all 6 new tests fail against current code (each hits the `instance_url`
   mock instead of `base_url`)
3. [ ] Implement AC-001: `list_service_desks` `get_from_instance` → `get` — `implementer`
4. [ ] Implement AC-002/AC-003: `list_request_types`/`get_request_type_fields` swap — `implementer`
5. [ ] Implement AC-004/AC-005: `list_queues`/`get_queue_issue_keys` swap — `implementer`
6. [ ] Implement AC-006: `create_jsm_request` `post_to_instance` → `post` — `implementer`
7. [ ] Confirm Green Gate: all 6 new tests pass
8. [ ] Run full existing `tests/jsm_request_api.rs` (and any other test file touching these
   6 functions) — confirm zero regressions (AC-007/AC-008)
9. [ ] Diff review confirming no line outside the 6 named call sites changed in these 4 files
   (AC-008)
10. [ ] Add the three `docs/adr/` forward-reference backlinks to ADR-0026 (AC-009) — `implementer`
11. [ ] Add a CHANGELOG entry under `[Unreleased] > Fixed` (AC-009), before creating the PR
12. [ ] Run full `cargo test`, `cargo clippy -- -D warnings`, `cargo fmt --all -- --check`

## Previous Story Intelligence

N/A — first cycle-008 story, no prior cycle-008 stories exist.

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| API calls under an OAuth profile MUST use `base_url` (`get`/`post`), never `instance_url` (`get_from_instance`/`post_to_instance`) | ADR-0026 Decision 1 | The 6 AC tests using `new_for_test_with_instance_url` are the enforcement mechanism — a call site using the wrong method fails its test's negative-control assertion |
| `instance_url` remains reserved exclusively for browser-facing URLs (`handle_open`), per ADR-0009 | ADR-0009 (inverse case) | This story does not touch `handle_open` or any browser-URL call site — confirmed by diff review (AC-008) |
| No payload/response-shape change is permitted in this story | F1 §2.1; ADR-0026 Decision 1 | AC-006's byte-for-byte payload assertion; AC-007's full pre-existing-suite regression pass |
| `JiraClient::new_for_test_with_instance_url` is the correct, already-existing test primitive — do not build new test infrastructure | F1 §5; ADR-0026 Decision 1 | Every AC-00X test reuses this existing seam |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| `wiremock` | existing (unchanged) | Dual-host mocking (`base_url` mock + `instance_url` mock) for the negative-control assertion |

No new dependency is added by this story.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/api/jsm/servicedesks.rs` | modify | `list_service_desks` method swap (AC-001) |
| `src/api/jsm/request_types.rs` | modify | `list_request_types`/`get_request_type_fields` method swap (AC-002/003) |
| `src/api/jsm/queues.rs` | modify | `list_queues`/`get_queue_issue_keys` method swap (AC-004/005) |
| `src/api/jsm/requests.rs` | modify | `create_jsm_request` method swap (AC-006) |
| `tests/jsm_request_api.rs` (or a new sibling test file) | modify/add | 6 new OAuth-routing test cases |
| `docs/adr/0009-handle-open-instance-url.md`, `docs/adr/0006-embedded-jr-oauth-app.md`, `docs/adr/0013-pkce-deferral.md` | modify | Forward-reference backlink to ADR-0026 (AC-009) |
| `CHANGELOG.md` | modify | `[Unreleased] > Fixed` entry (AC-009) |
