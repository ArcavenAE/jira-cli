---
document_type: story
level: ops
story_id: "S-cycle8-jsm-attachments-oauth-verification"
epic_id: "OAUTH-SURFACE-CORRECTNESS-1"
title: "Verify JSM attachment upload/download/delete succeed end-to-end under OAuth once servicedeskapi routing lands (no src/ change)"
wave: 2
status: draft
intent: enhancement
feature_type: correctness
mode: feature
scope: standard
severity: LOW
trivial_scope: true
producer: story-writer
timestamp: "2026-09-17T00:00:00"
phase: 3
inputs:
  - ".factory/cycles/cycle-008/F1-delta-analysis.md"
  - ".factory/cycles/cycle-008/F2-architecture-delta.md"
  - ".factory/specs/architecture/decisions/ADR-0026-oauth-3lo-gateway-routing-invariant-and-granular-jira-software-scopes.md"
  - ".factory/specs/prd/bc-4-assets-cmdb.md"
  - "src/api/jsm/attachments.rs"
  - "src/api/jsm/servicedesks.rs"
  - "tests/attachment_jsm.rs"
input-hash: "456abfc"
traces_to: "ADR-0026 Decision 1 (attachments.rs dependency chain); BC-4.2.001 (transitive)"
cycle: cycle-008-oauth-surface-correctness
estimated_effort: xsmall
estimated_days: 0.5
target_module: "tests/attachment_jsm.rs"
subsystems: ["SS-05"]
# SS-05 (JSM API Resources) is the sole subsystem this story's verification
# target lives in -- src/api/jsm/attachments.rs itself is NOT edited (it
# already builds URLs from client.base_url() directly, confirmed correct by
# F1 code audit), but the test this story adds exercises that file's
# two-step upload flow end-to-end, so SS-05 is the correct subsystem anchor
# even though this story is test-only.
depends_on: ["S-cycle8-jsm-servicedeskapi-oauth-routing"]
# HARD dependency, not a sequencing recommendation. F1 delta-analysis.md §1
# item 1 establishes precisely why: src/api/jsm/attachments.rs's
# serviceDeskId parameter is resolved via resolve_service_desk_id ->
# get_or_fetch_project_meta -> client.list_service_desks() -- and
# list_service_desks is exactly the function
# S-cycle8-jsm-servicedeskapi-oauth-routing fixes (AC-001 of that story).
# Under OAuth, today, that upstream call 401s before attachments.rs is ever
# reached -- there is nothing for this story's end-to-end test to observe
# succeeding until the sibling story lands. This is the one genuinely hard
# cross-story dependency in cycle-008 (F1 §7, F2-architecture-delta.md §S5).
blocks: []
behavioral_contracts:
  - BC-4.2.001
bcs:
  - BC-4.2.001
verification_properties: []
# No new VP is introduced by this story -- F2-architecture-delta.md §S5 is
# explicit: "No new VP — covered transitively by VP-OAUTH-GW-001's fix to
# list_service_desks." This story's test is additional regression coverage
# for that same VP, not a new verification property.
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0026"]
sd_refs: []
priority: P2
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-008/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: facade
module_criticality: LOW
points: 2
acceptance_criteria_count: 4
assumption_validations: []
risk_mitigations: []
created: "2026-09-17"
version: "1.0"
last_updated: "2026-09-17"
breaking_change: false
retroactive: false
origin: >
  cycle-008 oauth-surface-correctness, Wave 2, HARD depends_on
  S-cycle8-jsm-servicedeskapi-oauth-routing, no blocks. F1 delta-analysis
  (.factory/cycles/cycle-008/F1-delta-analysis.md §1 item 1) confirmed
  src/api/jsm/attachments.rs needs ZERO code changes (both
  attach_temporary_file and post_request_attachment already build URLs from
  client.base_url() directly) but is TRANSITIVELY broken today under OAuth
  because its serviceDeskId input comes from a dependency chain rooted in
  list_service_desks, which the sibling routing story fixes. This story
  exists to close that dependency-chain visibility gap with an explicit
  end-to-end regression test, not to fix any code.
---

> **tdd_mode:** `facade` — this is a verification-only story: it adds a new
> integration test proving an existing, already-correct code path
> (`src/api/jsm/attachments.rs`) now succeeds end-to-end once its upstream
> dependency is fixed by the sibling routing story. There is no new
> production logic to scaffold with `todo!()` bodies — the new test IS the
> deliverable. `module_criticality: LOW` — this story cannot regress
> anything (zero `src/` changes) and its own test either passes (confirming
> the dependency chain is fixed) or fails loudly (confirming it is not).

> **Execute:** `/vsdd-factory:deliver-story S-cycle8-jsm-attachments-oauth-verification`

# S-cycle8-jsm-attachments-oauth-verification — JSM attachment OAuth dependency-chain verification

## Narrative

- **As a** `jr` maintainer shipping the cycle-008 OAuth routing fixes
- **I want to** an explicit regression test proving `jr issue attachment upload/download/delete
  --public/--internal` on a JSM issue succeeds end-to-end under OAuth once
  `S-cycle8-jsm-servicedeskapi-oauth-routing` lands
- **So that** the transitive dependency between the two stories (attachments.rs's own code is
  already correct, but its `serviceDeskId` input comes from the routing story's fix) is proven by
  a test, not left as an unverified inference

## Behavioral Contracts

| BC | Role | Clauses this story implements |
|----|------|-------------------------------|
| BC-4.2.001 | TRANSITIVE (unchanged by this story) | This story adds regression coverage proving the OAuth gateway-routing invariant's downstream effect on the JSM attachment two-step flow, without amending the BC itself — the BC's own fix-table rows are all implemented by the sibling `S-cycle8-jsm-servicedeskapi-oauth-routing` story |

**Anchor justification:** BC-4.2.001 is cited here as the transitive BC this story's test provides
additional coverage for — per F2-architecture-delta.md §S5, this story introduces "No new VP —
covered transitively by VP-OAUTH-GW-001's fix to `list_service_desks`." No new BC or VP is minted;
citing BC-4.2.001 keeps this story's traceability chain intact without duplicating the sibling
story's own anchor claim.

## Acceptance Criteria

### AC-001 (traces to BC-4.2.001, transitive — two-step upload succeeds under OAuth)
`jr issue attachment upload --public`/`--internal` on a JSM issue, under an OAuth-constructed
client (`JiraClient::new_for_test_with_instance_url` with `base_url != instance_url`), completes
both steps of the JSM two-step flow (`attachTemporaryFile` then the request-attachment POST)
successfully — i.e. the mocked `base_url` endpoints for `list_service_desks` (now fixed by the
depended-on story), `attachTemporaryFile`, and the request-attachment POST are all hit, and NO
request reaches the `instance_url` mock at any step.
**Test:** `test_bc_4_2_001_jsm_attachment_upload_succeeds_end_to_end_under_oauth` — mounts wiremock
responses for the full chain (`list_service_desks` → `get_or_fetch_project_meta` →
`resolve_service_desk_id` → `attachTemporaryFile` → request-attachment POST) at `base_url` only;
asserts success and asserts the `instance_url` mock received zero requests across the whole chain.

### AC-002 (regression guard, traces to F1 §1 item 1 — attachments.rs itself unchanged)
`src/api/jsm/attachments.rs`'s `attach_temporary_file` and `post_request_attachment` functions are
BYTE-FOR-BYTE UNCHANGED by this story (and were already unchanged by the sibling routing story,
per that story's own File Structure Requirements, which do not list `attachments.rs`).
**Test:** diff review confirms zero lines changed in `src/api/jsm/attachments.rs`; this story's
`git diff` for the `src/` tree is empty (Task 4).

### AC-003 (regression guard — pre-fix failure mode documented, not re-asserted post-fix)
This story does NOT add a test asserting the PRE-fix failure (a 401 on `list_service_desks` under
OAuth blocking `attachments.rs`) — that failure mode is already exhaustively covered by
`S-cycle8-jsm-servicedeskapi-oauth-routing`'s own AC-001 (which proves the fix, implying the prior
broken state by contrast). This story's test (AC-001) is written and run AFTER that sibling
story's fix has landed, proving the POST-fix state only.
**Test:** N/A (a documentation/sequencing clause, not a runtime assertion) — enforced procedurally:
this story's Wave 2 placement in the dependency graph ensures it is never dispatched before the
depended-on story merges.

### AC-004 (traces to CLAUDE.md conventions — CHANGELOG delivery task)
`CHANGELOG.md`'s `[Unreleased]` section gains a `Fixed` entry (or amends the entry added by the
sibling routing story, if landing in the same release window) noting explicitly that `jr issue
attachment upload/download/delete --public/--internal` on JSM issues is now verified working
end-to-end under OAuth (3LO) profiles, closing the last piece of the JSM OAuth-routing dependency
chain.
**Test:** N/A (doc artifact); presence check via PR review.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `attach_temporary_file` / `post_request_attachment` (read-only reference, UNCHANGED) | `src/api/jsm/attachments.rs` | Effectful (HTTP multipart/JSON POST; already gateway-correct, confirmed by F1 code audit) |
| `list_service_desks` (read-only reference — the fix this story verifies, owned by the sibling story) | `src/api/jsm/servicedesks.rs` | Effectful (HTTP GET; fixed by `S-cycle8-jsm-servicedeskapi-oauth-routing`) |
| New end-to-end test | `tests/attachment_jsm.rs` | Pure (test code; orchestrates wiremock fixtures, no production-code effects of its own) |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-1 | This story dispatched before `S-cycle8-jsm-servicedeskapi-oauth-routing` merges | Not possible under correct wave scheduling (Wave 2, hard `depends_on`); if attempted anyway, AC-001's test fails at the `list_service_desks` step, correctly signaling the dependency is unmet |
| EC-2 | API-token profile running the same JSM attachment upload | Already covered by pre-existing `tests/attachment_jsm.rs` tests (constructed via `JiraClient::new_for_test`, `base_url == instance_url`) — unaffected by this story, no new coverage needed for that auth scheme |
| EC-3 | JSM `--internal`/`--public` visibility-flag combinations beyond the single AC-001 happy path | Out of scope for this story — those flag-combination behaviors are governed by pre-existing BC-3.9.003/005/006 and already tested; this story adds ONE new OAuth-routing-focused test, not a full re-test of the attachment upload flag matrix |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `src/api/jsm/attachments.rs` (read-only reference, UNCHANGED) | effectful-shell | HTTP multipart/JSON POST; already gateway-correct |
| `src/api/jsm/servicedesks.rs` (read-only reference, owned by sibling story) | effectful-shell | HTTP GET; fixed by `S-cycle8-jsm-servicedeskapi-oauth-routing` |
| `tests/attachment_jsm.rs` (new test) | pure-core | Test code orchestrating wiremock fixtures; no production-code effects of its own |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~1,600 |
| Referenced code (`src/api/jsm/attachments.rs` full file, read-only; `src/api/jsm/servicedesks.rs`'s dependency chain functions, read-only) | ~3,000 |
| Test files (`tests/attachment_jsm.rs` existing fixtures/helpers to reuse) | ~3,000 |
| Tool output overhead | ~1,000 |
| **Total** | **~8,600** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~4%** |

## Tasks

1. [ ] Confirm `S-cycle8-jsm-servicedeskapi-oauth-routing` is merged to the branch this story
   builds on (dependency gate check) before starting
2. [ ] Read `tests/attachment_jsm.rs`'s existing wiremock fixture helpers to identify what can be
   reused for the full dependency-chain mock setup (AC-001) — `test-writer`
3. [ ] Write `test_bc_4_2_001_jsm_attachment_upload_succeeds_end_to_end_under_oauth` using
   `JiraClient::new_for_test_with_instance_url` (AC-001) — `test-writer`
4. [ ] Run the new test; confirm it passes with zero `src/` changes (this story makes none) — if
   it fails, the depended-on story's fix is not actually present on this branch — STOP and
   escalate, do not attempt to patch `src/` from this story
5. [ ] Diff-confirm `git diff -- src/` is empty for this story's changes (AC-002)
6. [ ] Run full `cargo test --test attachment_jsm` — confirm zero regressions to existing
   API-token-path tests
7. [ ] Add/amend a CHANGELOG entry under `[Unreleased] > Fixed` (AC-004), before creating the PR
8. [ ] Run full `cargo test`, `cargo clippy -- -D warnings`, `cargo fmt --all -- --check`

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|-----------------|--------------------------|------------------------|
| S-cycle8-jsm-servicedeskapi-oauth-routing (Wave 1, HARD prerequisite) | This story's AC-001 fix to `list_service_desks` is the exact upstream call this story's new test depends on succeeding | Reuse the `JiraClient::new_for_test_with_instance_url` dual-mock pattern verbatim — do not invent a new test-construction approach | If the prerequisite story's PR changes the exact mocked path/response shape for `list_service_desks` between authorship and delivery of THIS story, re-read that story's final merged AC-001 test before writing this story's fixture, to avoid a stale mock shape |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| This story makes ZERO `src/` changes — it is verification-only | F1 §1 item 1; F2-architecture-delta.md §S5 | AC-002's diff-review requirement; Task 5 |
| This story MUST NOT be dispatched before `S-cycle8-jsm-servicedeskapi-oauth-routing` merges | F1 §7; frontmatter `depends_on` | Wave 2 placement in `wave-schedule.md`; Task 1's dependency gate check |
| Do not re-implement or duplicate `src/api/jsm/servicedesks.rs`'s fix inside this story's test setup — mock the ALREADY-FIXED behavior (requests reaching `base_url`), do not mock the pre-fix behavior | F1 §1 item 1 | AC-001's test asserts success against `base_url` mocks only |

## Library & Framework Requirements

No new dependency is added by this story. `wiremock` (existing, unchanged) provides the multi-step
mock chain AC-001 requires.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `tests/attachment_jsm.rs` | modify/add | New end-to-end OAuth-routing regression test (AC-001) |
| `src/api/jsm/attachments.rs` | none — read-only reference | Confirmed already gateway-correct; zero changes (AC-002) |
| `src/api/jsm/servicedesks.rs` | none — read-only reference | Owned/fixed by the sibling routing story; zero changes from this story |
| `CHANGELOG.md` | modify | `[Unreleased] > Fixed` entry (AC-004) |
