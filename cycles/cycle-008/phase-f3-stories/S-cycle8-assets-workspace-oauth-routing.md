---
document_type: story
level: ops
story_id: "S-cycle8-assets-workspace-oauth-routing"
epic_id: "OAUTH-SURFACE-CORRECTNESS-1"
title: "Assets workspace-ID discovery OAuth gateway routing: 1-site get_from_instance -> get swap (repairs jr assets *)"
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
  - ".factory/specs/prd/bc-4-assets-cmdb.md"
  - "src/api/assets/workspace.rs"
  - "src/api/client.rs"
input-hash: "a7f6dfc"
traces_to: "ADR-0026 Decision 1; BC-4.2.001 unified fix table row 7"
cycle: cycle-008-oauth-surface-correctness
estimated_effort: xsmall
estimated_days: 0.5
target_module: "src/api/assets/workspace.rs"
subsystems: ["SS-06"]
# SS-06 (Assets API Resources, src/api/assets/) is the sole subsystem this
# story touches -- the one call site it swaps lives entirely in that
# directory, and no downstream Assets file (objects.rs/linked.rs/schemas.rs/
# tickets.rs) needs any change (confirmed already gateway-correct, F1 §1
# item 2 / §2.3).
depends_on: []
blocks: []
# No other cycle-008 story depends on this one. Unlike S-cycle8-jsm-*
# (which S-cycle8-jsm-attachments-oauth-verification hard-depends on), no
# cycle-008 story exercises the Assets surface as a verification target this
# cycle -- the F1/F2 passes did not scope an Assets-equivalent verification
# story, since the Assets AQL/object/schema layer needed no fix and its own
# existing test suite (tests/assets.rs, tests/assets_errors.rs) already
# covers the warm-cache and cold-cache paths without a cross-story
# dependency.
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
points: 2
acceptance_criteria_count: 5
assumption_validations: []
risk_mitigations: []
created: "2026-09-17"
version: "1.0"
last_updated: "2026-09-17"
breaking_change: false
retroactive: false
origin: >
  cycle-008 oauth-surface-correctness, Wave 1, no deps, no blocks. F1
  delta-analysis (.factory/cycles/cycle-008/F1-delta-analysis.md §2.3, §1 item
  2) narrowed this workstream's scope during code audit: the feature request
  originally framed "fix jr assets *" as touching the AQL/object/schema layer,
  but direct code read confirmed those calls are already unconditionally
  gateway-routed via `assets_base_url` (src/api/client.rs) and require no
  change. The ENTIRE Assets surface is OAuth-broken today solely because this
  one prerequisite call (`get_or_fetch_workspace_id`) is instance-routed --
  fixing this single call site repairs `jr assets *` end-to-end. ADR-0026
  Decision 1 anchors this as fix-table row 7, sharing BC-4.2.001 with the
  sibling S-cycle8-jsm-servicedeskapi-oauth-routing story's 6 JSM rows.
---

> **tdd_mode:** `strict` — this is a real, correctness-relevant routing fix
> on the sole prerequisite call for the entire Assets command family
> (`module_criticality: HIGH` despite the narrow 1-function blast radius,
> because the whole `jr assets *` surface plus `issue list --component`'s
> asset-clause path and `--field :asset` resolution are all gated behind
> this one call). The RED-before-GREEN proof uses the same
> `JiraClient::new_for_test_with_instance_url` seam as the sibling JSM
> routing story.

> **Execute:** `/vsdd-factory:deliver-story S-cycle8-assets-workspace-oauth-routing`

# S-cycle8-assets-workspace-oauth-routing — Assets workspace-ID discovery OAuth gateway routing

## Narrative

- **As a** `jr` user authenticated via OAuth (3LO)
- **I want to** have `get_or_fetch_workspace_id` route its `servicedeskapi` workspace-discovery
  request through the API gateway (`base_url`) instead of the site host (`instance_url`)
- **So that** `jr assets search/view/schemas/tickets`, `issue list --component`'s asset-clause
  path, and `issue create/edit --field :asset` resolution all stop 401-ing under OAuth, while
  remaining byte-for-byte unchanged for API-token profiles

## Behavioral Contracts

| BC | Role | Clauses this story implements |
|----|------|-------------------------------|
| BC-4.2.001 | PRIMARY (amended) | The "OAuth 3LO gateway-routing invariant" clause's fix-table row 7 (`get_or_fetch_workspace_id`) — this BC's own Behavior section already documents this call's request shape (path + 7d cache); this story implements only the routing-host half of the invariant the BC's amendment added |

**Anchor justification:** BC-4.2.001 lives in `bc-4-assets-cmdb.md` and IS this call site's own
subject-area BC (unlike the sibling JSM story, which borrows BC-4.2.001 across subject areas per
ADR-0026's explicit "anchored here... rather than duplicated" instruction — this story's anchor is
the native, subject-matching one). No second BC is introduced.

## Acceptance Criteria

### AC-001 (traces to BC-4.2.001 fix-table row 7)
`src/api/assets/workspace.rs::get_or_fetch_workspace_id` calls `client.get(...)` instead of
`client.get_from_instance("/rest/servicedeskapi/assets/workspace")`. No other line in the function
changes — same path string, same `{values: [{workspaceId: "..."}]}` response deserialization, same
7-day-TTL cache read/write logic.
**Test:** `test_bc_4_2_001_get_or_fetch_workspace_id_targets_base_url_under_oauth` — constructs the
client via `JiraClient::new_for_test_with_instance_url(base_url, instance_url, auth_header)` with
`base_url != instance_url`, mounts a wiremock server at `base_url` only, asserts the mock receives
the request and that an `instance_url`-mounted mock (also stood up in the same test) receives ZERO
requests.

### AC-002 (regression guard, traces to F1 §1 item 2 — cache-hit path unaffected)
When `WorkspaceCache` already holds a valid (non-expired) entry, `get_or_fetch_workspace_id`
issues NO HTTP call at all (cache hit short-circuits before either `get`/`get_from_instance` is
reached) — this story's swap only changes the shape of a live request when the cache misses.
**Test:** existing cache-hit test(s) in `tests/assets.rs` (or wherever the cache-hit path is
covered) pass unmodified; if no such test currently exists, add
`test_get_or_fetch_workspace_id_cache_hit_issues_no_http_call`.

### AC-003 (regression guard, traces to F1 §1 item 2 / §2.3 — downstream Assets calls need no change)
`src/api/assets/objects.rs` (`search_assets`/`get_asset`/`get_object_attributes`/
`get_object_type_attributes`) and `src/api/client.rs::get_assets`/`post_assets`
(`assets_base_url`-based) are BYTE-FOR-BYTE UNCHANGED by this story — confirmed already
gateway-correct.
**Test:** diff review confirms zero lines changed in `objects.rs`, `linked.rs`, `schemas.rs`,
`tickets.rs`, or `client.rs`'s `get_assets`/`post_assets`/`assets_base_url` definitions; full
`cargo test --test assets` (and `assets_errors`) green, no test edits required in those files.

### AC-004 (regression guard, traces to F1 §2.1 / ADR-0026 Decision 1 "no payload change")
All pre-existing wiremock tests in `tests/assets.rs`/`tests/assets_errors.rs` that exercise
`get_or_fetch_workspace_id` (constructed via the ordinary `JiraClient::new_for_test`, where
`base_url == instance_url`) pass unmodified after the swap — proving the fix is a no-op for
API-token profiles.
**Test:** full `cargo test --test assets --test assets_errors` green, no test file edits required
for this AC beyond what AC-001/AC-002 add.

### AC-005 (traces to CLAUDE.md conventions — CHANGELOG delivery task)
`CHANGELOG.md`'s `[Unreleased]` section gains a `Fixed` entry describing: `jr assets search/view/
schemas/tickets`, `issue list --component`, and `issue create/edit --field :asset` now work under
OAuth (3LO) profiles (previously 401'd due to wrong-host workspace-ID discovery); no behavior
change for API-token profiles.
**Test:** N/A (doc artifact); presence check via PR review.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `get_or_fetch_workspace_id` | `src/api/assets/workspace.rs` | Effectful (HTTP GET + cache read/write) |
| `get`/`get_from_instance` | `src/api/client.rs` | Effectful (unchanged — this story only changes WHICH of these the call site invokes) |
| `search_assets`/`get_asset`/`get_object_attributes`/`get_object_type_attributes` | `src/api/assets/objects.rs` | Effectful (HTTP; UNCHANGED by this story, AC-003) |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-1 | API-token profile, any `jr assets *` command | Byte-for-byte unchanged behavior — `base_url() == instance_url()` for this auth scheme, confirmed by AC-004 |
| EC-2 | OAuth profile, warm workspace-ID cache | No HTTP call at all — AC-002 |
| EC-3 | OAuth profile, cold cache, first `jr assets search` after this fix lands | Workspace discovery now succeeds via the gateway; the subsequent AQL/object call (already gateway-correct) succeeds too — the whole command now completes end-to-end under OAuth |
| EC-4 | A future accidental revert of this one site back to `get_from_instance` | Immediately caught — AC-001's negative-control assertion (`instance_url` mock received zero requests) fails |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `src/api/assets/workspace.rs::get_or_fetch_workspace_id` | effectful-shell | HTTP GET call + cache read/write, network and disk I/O |
| `src/api/assets/objects.rs`, `linked.rs`, `schemas.rs`, `tickets.rs` | effectful-shell | HTTP calls, network I/O; UNCHANGED by this story |
| `src/api/client.rs` (`get`/`get_from_instance`/`get_assets`/`post_assets`) | effectful-shell | HTTP transport primitives, unchanged by this story |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~1,800 |
| Referenced code (`src/api/assets/workspace.rs` full file, `client.rs`'s `get`/`get_from_instance`/`new_for_test_with_instance_url`) | ~2,000 |
| Test files (`tests/assets.rs` workspace-discovery test group, `tests/assets_errors.rs` relevant sections) | ~2,500 |
| Tool output overhead | ~1,000 |
| **Total** | **~7,300** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~4%** |

## Tasks

1. [ ] Write failing test AC-001 (`new_for_test_with_instance_url` seam, dual-mock + negative-control
   pattern) — `test-writer`
2. [ ] Verify Red Gate: the new test fails against current code (hits the `instance_url` mock)
3. [ ] Implement AC-001: `get_or_fetch_workspace_id` `get_from_instance` → `get` — `implementer`
4. [ ] Confirm Green Gate: the new test passes
5. [ ] Confirm/add AC-002's cache-hit-issues-no-HTTP-call test — `test-writer`
6. [ ] Run full existing `tests/assets.rs`/`tests/assets_errors.rs` — confirm zero regressions
   (AC-003, AC-004)
7. [ ] Diff review confirming no line outside `get_or_fetch_workspace_id` changed in
   `workspace.rs`, and zero lines changed in `objects.rs`/`linked.rs`/`schemas.rs`/`tickets.rs`
   (AC-003)
8. [ ] Add a CHANGELOG entry under `[Unreleased] > Fixed` (AC-005), before creating the PR
9. [ ] Run full `cargo test`, `cargo clippy -- -D warnings`, `cargo fmt --all -- --check`

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|-----------------|--------------------------|------------------------|
| S-cycle8-jsm-servicedeskapi-oauth-routing (Wave 1, sibling) | Established the `JiraClient::new_for_test_with_instance_url` dual-mock + negative-control test pattern for this cycle's routing fixes | This story reuses that exact test pattern for its single call site — no new test infrastructure invented | None applicable — no file overlap; `workspace.rs` is not touched by the JSM story |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| API calls under an OAuth profile MUST use `base_url` (`get`/`post`), never `instance_url` (`get_from_instance`/`post_to_instance`) | ADR-0026 Decision 1 | AC-001's `new_for_test_with_instance_url` test is the enforcement mechanism |
| Do NOT touch `src/api/assets/objects.rs`, `linked.rs`, `schemas.rs`, `tickets.rs`, or `client.rs`'s `get_assets`/`post_assets`/`assets_base_url` — these are confirmed already gateway-correct and are a regression baseline | F1 §1 item 2, §8 (Files NOT Changed); F2-architecture-delta.md §S3 | AC-003's diff-review + full-suite-green requirement |
| `JiraClient::new_for_test_with_instance_url` is the correct, already-existing test primitive — do not build new test infrastructure | F1 §5; ADR-0026 Decision 1 | AC-001's test reuses this existing seam |

## Library & Framework Requirements

No new dependency is added by this story. `wiremock` (existing, unchanged) provides the dual-host
mocking needed for AC-001's negative-control assertion.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/api/assets/workspace.rs` | modify | `get_or_fetch_workspace_id` method swap (AC-001) |
| `tests/assets.rs` | modify/add | New OAuth-routing test case (AC-001) and cache-hit-no-HTTP test if not already present (AC-002) |
| `CHANGELOG.md` | modify | `[Unreleased] > Fixed` entry (AC-005) |
