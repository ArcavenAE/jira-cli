---
document_type: story
level: ops
epic_id: "none"
story_id: "S-605-2"
title: "issue edit --component (multi-key/--jql bulk path)"
wave: null
status: draft
intent: feature
feature_type: backend
mode: feature
scope: standard
severity: N/A
trivial_scope: false
issue: 605
points: 5
priority: P0
tdd_mode: strict
estimated_effort: small
producer: story-writer
timestamp: "2026-08-15T00:00:00"
phase: 2
cycle: cycle-component-mgmt
inputs:
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/architecture/decisions/ADR-0018-component-resolution-caching-mutation-strategy.md"
  - ".factory/phase-f2-spec-evolution/verification-delta-components.md"
  - ".factory/research/component-delete-and-bulk-wire-2026-08-15.md"
traces_to: ".factory/specs/prd/bc-3-issue-write.md"
estimated_days: 2
target_module: src/cli/issue/edit.rs
subsystems: ["SS-02", "SS-04"]
depends_on: ["S-605-1"]
blocks: []
behavioral_contracts:
  - "BC-3.4.023"
bcs:
  - "BC-3.4.023"
verification_properties: ["VP-COMPONENT-012"]
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0018"]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-3-issue-write.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 10
assumption_validations: []
risk_mitigations: []
created: "2026-08-15"
version: "1.2"
last_updated: "2026-08-19"
breaking_change: false
retroactive: false
origin: >
  GitHub issue #605 (`issue create/edit --component`), multi-key bulk facet (DEC-280).
  Depends on S-605-1 because it shares the same resolver contract and add:/remove:
  CLI-surface parsing S-605-1 establishes for the single-key path, and reuses the SAME
  §8.4 resolution round-trip (component names → ids) before converting to the bulk
  endpoint's integer `componentId` shape. Carries a LIVE-JIRA smoke-test release gate
  (BC-3.4.023's Delivery note, DEC-280 / FIX-BULK-TRANSITION-001 precedent) — this wire
  shape is documented and triple-corroborated but not yet live-verified at spec-authoring
  time; the smoke test (one ADD, one REMOVE, ≥2 issues, one project) MUST pass before this
  path ships to release, mirroring how `FIX-BULK-TRANSITION-001` discovered a wrong
  documented shape for bulk transitions.
files_modified:
  - src/cli/issue/edit.rs
  - src/api/jira/bulk.rs
test_files:
  - tests/issue_commands.rs
  - tests/common/fixtures.rs
# input-hash recomputed 2026-08-19 (was 9e1c71f) — bc-3-issue-write.md, a listed input,
# was amended with the BC-3.4.023 Invariant 2 error-taxonomy clarification (S-605-2 Step-4.5
# adversarial finding) this story propagates. New value below was reported by the
# validate-input-hash factory-dispatcher hook itself (computed d4fba74, confirmed via
# `compute-input-hash <file> --check`) after this edit; not hand-derived.
input-hash: "d4fba74"
---

> **tdd_mode:** `strict`.
>
> **LIVE-JIRA GATE (DEC-280, BC-3.4.023 Delivery note):** this story's implementation MUST
> NOT be marked done, and this path MUST NOT ship to a release, until a live smoke test
> (one ADD, one REMOVE, against ≥2 issues in one real project) confirms the
> `multiselectComponents` wire shape documented below. If the live run contradicts this
> BC, correct the BC to the observed truth before proceeding (do not silently patch around
> a wrong documented shape, per the `FIX-BULK-TRANSITION-001`/#446 precedent).

# S-605-2: `issue edit --component` (multi-key/`--jql` bulk path)

## Narrative

As a `jr` user who needs to add or remove a component across many issues at once, I want
`issue edit KEY1 KEY2 ... --component add:X` (or a `--jql` query matching 2+ issues) to route
through Jira's bulk-fields endpoint with the correct `multiselectComponents` integer-id wire
shape, so that a bulk component edit works exactly as reliably as the existing bulk
`--type`/`--label` paths, without silently corrupting on Jira's third distinct component wire
shape.

## Source of Truth

Read **BC-3.4.023** in `bc-3-issue-write.md` §3.4 IN FULL, including its "Delivery note"
callout box and its dense pass-14 correction on Postcondition 3 (TWO sequential POSTs for
mixed add:/remove:, NOT a single-POST coalescing — this directly contradicts the naive
assumption that this mirrors labels' single-POST shape). Also read `research/
component-delete-and-bulk-wire-2026-08-15.md` §Q2 in full and **ADR-0018 Decision §4**
(wire-shape asymmetry) and its "Why implement the bulk wire shape now" Rationale paragraph.

## Behavioral Contracts

| BC ID | Title |
|-------|-------|
| BC-3.4.023 | `issue edit KEY1 KEY2 --component add:X` (multi-key/`--jql` bulk path) — `POST /bulk/issues/fields` with `multiselectComponents`/integer `componentId` |

## Behavior Summary (verbatim per BC — do not deviate)

- **Wire shape**: `selectedActions: ["components"]` (lowercase); `editedFieldsInput.
  multiselectComponents` is a SINGLE OBJECT (not an array, NOT `componentsFields`):
  `{"fieldId":"components","components":[{"componentId":10001}],
  "bulkEditMultiSelectFieldOption":"ADD"}`. `bulkEditMultiSelectFieldOption` is one of `ADD` |
  `REMOVE` | `REPLACE` | `REMOVE_ALL` — `jr` only ever emits `ADD`/`REMOVE` (no `set:`/
  `replace:`/`clear:` CLI grammar exists; that is `#607` territory, explicitly out of scope).
- **`sendBulkNotification` is deliberately OMITTED from the POST body** **[CLARIFIED
  2026-08-19, S-605-2 wire-shape research —
  `.factory/research/S-605-2-bulk-component-wire-2026-08-19.md`, "What the story may have
  MISSED" item 1]**: the Atlassian doc's worked example for this endpoint shows
  `"sendBulkNotification": false` alongside the body, but `jr` reuses the EXISTING
  `bulk_edit_fields` composition (`src/api/jira/bulk.rs`) as-is, which builds
  `BulkEditRequest` with only `selectedIssueIdsOrKeys`, `selectedActions`, and
  `editedFieldsInput` — no `sendBulkNotification` key at all. That omission is already
  live-proven via the issue #446 bulk labels/type path; `sendBulkNotification` is a
  documented OPTIONAL field, so omitting it is spec-conformant, not an oversight.
  Implementers MUST NOT add `sendBulkNotification` to the components body merely to mirror
  the Atlassian doc example — the live-proven `bulk_edit_fields` composition, not the doc
  example, is the source of truth for this wire body.
- **TWO sequential POSTs for mixed add:/remove:, NOT single-POST coalescing** (this is the
  key divergence from the label bulk path — do NOT copy `handle_edit_bulk_labels`'s
  single-POST-per-request shape here): the `multiselectComponents` schema holds only ONE
  `bulkEditMultiSelectFieldOption` per POST, so `jr` performs the ADD POST first, fully polled
  to completion, THEN the REMOVE POST, fully polled to completion. Only the ORDERING (ADD
  before REMOVE) mirrors BC-3.4.006/BC-3.4.020's convention — the coalescing itself does not.
- **Component NAMES → NUMERIC `componentId`s client-side BEFORE the POST**: resolved via §8.4
  (`resolve_component`, S-604-1/S-605-1's shared resolver) then an explicit `id.parse::<u64>()`
  (the resolver returns `String`; the bulk endpoint requires a JSON integer, never a
  string/object). This parse is expected to always succeed (every resolver-returned component
  id is itself a digit-only string on the wire); a parse failure would indicate an internal
  invariant violation elsewhere, not a user-input error — surface as an internal error, not
  `JrError::UserError`.
- **Cross-project guard**: 2+ keys (or `--jql` matching 2+) spanning MORE than one project →
  exit 64 BEFORE any HTTP (mirrors BC-3.4.019's `--type` cross-project guard exactly —
  component ids are project-scoped, a single `componentId` cannot correctly apply across
  projects).
- **1000-issue chunking (M9 fix-burst)**: `POST /rest/api/3/bulk/issues/fields` caps a single
  request at 1000 issues (Atlassian Bulk Operations limit). A resolved key set exceeding 1000
  issues splits into sequential chunks of ≤1000, each fully polled to completion BEFORE the
  next chunk's POST fires. Chunk order follows the resolved key-set order. When BOTH >1000
  issues AND mixed add:/remove: specs occur together: chunk-major, action-minor ordering —
  `N > 1000` issues with mixed add:/remove: produces `2 * ceil(N/1000)` sequential POSTs
  total.
- **Chunk-sequence failure handling**: NOT the `rename --all-projects` per-target continue-
  on-error shape — a chunk failure ABORTS the remaining chunk sequence (chunk 3 of 3 is never
  POSTed if chunk 2 fails); surfaced via the EXISTING `await_bulk_task` error path (same shape
  any single bulk POST failure already produces). Already-successful earlier chunks are NOT
  rolled back (non-transactional across chunks) but `jr`'s error output does not itemize which
  chunk(s) succeeded — a caller needing that detail must independently re-query.
- **Async polling**: reuses the EXISTING `await_bulk_task`/poll-loop machinery
  (`JR_BULK_AWAIT_TIMEOUT_SECS`, unknown-status grace) — no new polling mechanism introduced.

## Acceptance Criteria

### AC-001 (traces to BC-3.4.023 postcondition 1/2 — wire shape)
`jr issue edit FOO-1 FOO-2 --component add:Backend` → `POST /rest/api/3/bulk/issues/fields`
body: `selectedActions == ["components"]`; `editedFieldsInput.multiselectComponents ==
{"fieldId":"components","components":[{"componentId":10001}],
"bulkEditMultiSelectFieldOption":"ADD"}` (single object, not array).
**Clarifying note (2026-08-19):** the test's wire-shape assertion should also assert the
POST body's top-level key SET is exactly `{selectedIssueIdsOrKeys, selectedActions,
editedFieldsInput}` — i.e. it does NOT include `sendBulkNotification` (see the "Behavior
Summary" bullet above; `.factory/research/S-605-2-bulk-component-wire-2026-08-19.md` item
1).
**Test:** `test_bc_3_4_023_issue_edit_bulk_component_add_wire_shape()`

### AC-002 (traces to BC-3.4.023 postcondition 3 — two sequential POSTs)
`jr issue edit FOO-1 FOO-2 --component add:X --component remove:Y` → EXACTLY two sequential
`POST /bulk/issues/fields` calls, ADD first (fully polled to completion) then REMOVE — NOT
one coalesced POST.
**Test:** `test_bc_3_4_023_issue_edit_bulk_component_mixed_add_remove_two_sequential_posts()`

### AC-003 (traces to BC-3.4.023 Invariant 2 — integer componentId, parse step)
The resolved `String` component id is explicitly parsed to a `u64`/`i64` before body
assembly — `components[].componentId` in the POST body is a JSON integer, never a string or
`{"name":...}` object.
**Clarifying note (2026-08-19, S-605-2 Step-4.5 adversarial finding — error-taxonomy):**
Invariant 2 distinguishes two distinct parse-failure origins — see "Edge Cases" below for
the full split. A resolver-returned id that fails to parse is `JrError::Internal`
(defensive test, not expected reachable); a numeric-bypass user-supplied digit string
exceeding `u64::MAX` is `JrError::UserError`, exit 64, zero POSTs (covered, user-facing).
**Test:** `test_bc_3_4_023_issue_edit_bulk_component_id_is_json_integer_not_string()`

### AC-004 (traces to BC-3.4.023 postcondition 4 — resolution before POST)
Component NAMES resolve via §8.4 to numeric ids BEFORE the bulk POST is built; an
unknown/ambiguous name → exit 64, ZERO bulk POST calls (`.expect(0)`).
**Test:** `test_bc_3_4_023_issue_edit_bulk_component_unknown_name_zero_post()`

### AC-005 (traces to BC-3.4.023 Edge Case EC-3.4.023-1 — cross-project guard)
Keys spanning 2+ projects with `--component` → exit 64 BEFORE any HTTP (mirrors BC-3.4.019).
**Test:** `test_bc_3_4_023_issue_edit_bulk_component_cross_project_guard()`

### AC-006 (traces to BC-3.4.023 Edge Case EC-3.4.023-3 — single-issue fallthrough)
`--jql` matching exactly 1 issue → routes to S-605-1's single-key path (BC-3.4.022), NOT
this bulk path.
**Test:** `test_bc_3_4_023_issue_edit_component_jql_single_match_uses_single_key_path()`

### AC-007 (traces to BC-3.4.023 postcondition 6 — 1000-issue chunking)
1500 issues in one project, `--component add:Backend` → TWO sequential bulk POSTs, first
with 1000 issues' worth of `selectedIssueIdsOrKeys`, second with the remaining 500, each
polled to completion before the next starts; exit 0 iff BOTH chunks succeed.
**Test:** `test_bc_3_4_023_issue_edit_bulk_component_1000_issue_chunking()`

### AC-008 (traces to BC-3.4.023 postcondition 6 — chunk-major/action-minor with mixed ops)
1500 issues, `--component add:X --component remove:Y` (both >1000 chunking AND mixed
add/remove) → `2 * ceil(1500/1000) == 4` sequential POSTs total, chunk-major then
action-minor ordering.
**Test:** `test_bc_3_4_023_issue_edit_bulk_component_chunking_and_mixed_ops_four_posts()`

### AC-009 (traces to BC-3.4.023 Edge Case EC-3.4.023-4 — chunk-failure abort, non-transactional)
Chunk 1 of a 2-chunk sequence succeeds, chunk 2 fails → chunk 3 (if any) is never attempted;
chunk 1's already-committed change is NOT rolled back; error output surfaces only chunk 2's
`await_bulk_task` failure, not a per-chunk `renamed[]`/`failed[]` report shape.
**Test:** `test_bc_3_4_023_issue_edit_bulk_component_chunk_failure_aborts_remaining()`

### AC-010 (LIVE-JIRA REQUIRED — traces to BC-3.4.023 Delivery note / VP-COMPONENT-012)
Live smoke test against a real Jira Cloud project: one `add:` POST and one `remove:` POST,
each against ≥2 real issues in one project, confirms the `multiselectComponents` wire shape
matches this BC's documented body exactly. MUST PASS before this path ships to release; a
mismatch requires correcting this BC (and re-running test-writer/implementer against the
corrected shape) rather than silently adjusting the implementation around an unconfirmed
guess. **Precondition [ADDED 2026-08-19, S-605-2 wire-shape research —
`.factory/research/S-605-2-bulk-component-wire-2026-08-19.md`, "What the story may have
MISSED" item 4]:** the smoke-test project MUST have ≥1 component already defined. Jira's
`GET /rest/api/3/bulk/issues/fields` field-discovery response only includes `components` in
the bulk-edit allowlist when the selected issues' project actually has components
configured — a componentless project surfaces `components` with an `unavailableMessage`
instead, so the field would never be selectable and the test would false-negative for a
reason unrelated to wire-shape correctness.
**Test:** live smoke test, gated behind `JR_RUN_E2E=1` (mirrors `tests/e2e_live.rs`
conventions) — NOT part of the standard `cargo test` suite.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `handle_edit_bulk_fields` component branch | `src/cli/issue/edit.rs` (additive) | Effectful shell |
| Bulk POST body composition (`multiselectComponents`) | `src/api/jira/bulk.rs` (additive, or co-located per existing bulk-fields shape) | Pure (body composition) + Effectful (the POST itself) |
| Chunking loop (≤1000-issue splits) | `src/cli/issue/edit.rs` (additive) | Effectful shell |

## Edge Cases

Covered by dedicated ACs: EC-3.4.023-1, EC-3.4.023-3, EC-3.4.023-4.

**`componentId` parse failure — TWO distinct origins [CLARIFIED 2026-08-19, S-605-2 Step-4.5
adversarial finding — error-taxonomy; BC-3.4.023 Invariant 2]:**
- **(a) Numeric-bypass user input (user-facing, covered):** an all-ASCII-digit
  `--component add:<digits>`/`remove:<digits>` value takes BC-8.4.001 step (1)'s
  numeric-bypass path (no existence check, no name-list GET) and is passed through
  unchanged; if that digit string exceeds `u64::MAX` (e.g. a 26-digit value) it fails
  `id.parse::<u64>()`. This is user-supplied text, not resolver output — `jr` surfaces
  `JrError::UserError`, exit 64, with ZERO bulk-fields POSTs issued (the parse happens
  client-side before Postcondition 4's POST body is built). Needs a covered unit test
  asserting exit 64 + zero POSTs, same rigor as AC-004's unknown-name case.
- **(b) Resolver-returned lookup result (internal-invariant case, not user-facing):** a
  genuine §8.4 resolver-returned name→id lookup result (BC-8.4.001 step (2), the
  non-digit `partial_match` path) that unexpectedly fails to parse remains
  `JrError::Internal`, not expected to be reachable with a real resolver. Should have a
  defensive unit test even though it is not expected to be reachable in practice.

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `cli/issue/edit.rs` bulk-component branch | Effectful shell | HTTP + polling |
| Body-composition helper (`{"componentId": N}` array construction) | Pure | Pure data transform, testable in isolation from HTTP |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|--------------------|
| This story spec | ~5k |
| BC-3.4.023 body (dense, read in full) | ~8k |
| Research file §Q2 | ~3k |
| ADR-0018 Decision §4 | ~2k |
| `handle_edit_bulk_labels`/`--type` bulk precedent (`edit.rs`) | ~4k |
| `await_bulk_task`/poll-loop machinery (existing) | ~2k |
| Test files + fixtures | ~6k |
| Tool outputs | ~4k |
| **Total** | **~34k** |
| Agent context window | 200K |
| **Budget usage** | **~17%** |

## Tasks (MANDATORY)

1. [ ] Write failing tests for the wire shape (single object, not array; ADD/REMOVE two-POST
   sequencing)
2. [ ] Write failing tests for the `String`→`u64` componentId parse step
3. [ ] Write failing tests for the cross-project guard and single-issue fallthrough
4. [ ] Write failing tests for 1000-issue chunking (plain and chunk-major/action-minor mixed)
5. [ ] Write failing tests for chunk-failure abort/non-transactional behavior
6. [ ] Verify Red Gate
7. [ ] Implement bulk-fields component branch reusing `await_bulk_task`
8. [ ] Implement chunking loop
9. [ ] Refactor; full suite green
10. [ ] **Gate: schedule and run the live smoke test (JR_RUN_E2E) BEFORE marking this story
    done** — correct BC-3.4.023 first if the live shape diverges. **Precondition [ADDED
    2026-08-19]:** confirm the target project has ≥1 component already defined BEFORE
    running the smoke test — a componentless project makes `components` unselectable in
    the bulk-edit field allowlist (`unavailableMessage`) and false-negatives the test for a
    reason unrelated to wire-shape correctness.

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|----------------|------------------------|-----------------------|
| S-605-1 | Single-key `--component` add:/remove: CLI parsing, §8.4 resolver reuse | The `add:`/`remove:` prefix-parsing CLI surface is SHARED between single-key and bulk paths — parse ONCE, then fork on `keys.len()`, do not reimplement parsing per path | The resolver returns `String` ids; this story's `componentId` field needs an explicit `u64` parse the single-key path never needed (single-key sends `{"name":...}` objects, never a bare integer) |

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|--------------|
| `selectedActions: ["components"]` (lowercase) vs `editedFieldsInput.multiselectComponents` (camelCase, different word) — do NOT unify | BC-3.4.023 Invariant 1 | AC-001; code review |
| Mixed add:/remove: is TWO sequential POSTs, never one coalesced POST — do not copy the label bulk path's coalescing shape | BC-3.4.023 Postcondition 3 (pass-14 correction) | AC-002 |
| `componentId` is ALWAYS a JSON integer — explicit `String`→`u64` parse required, resolver output is never sent as-is | BC-3.4.023 Invariant 2 | AC-003 |
| Parse-failure origin split: numeric-bypass oversized user digits → `JrError::UserError` exit 64 zero-POST; resolver-returned lookup parse failure → `JrError::Internal` (defensive test only) — do NOT collapse both into one internal-error outcome | BC-3.4.023 Invariant 2 clarification (2026-08-19, S-605-2 Step-4.5 adversarial finding) | AC-003 clarifying note; Edge Cases |
| This bulk path is entirely SEPARATE from S-605-1's single-key `update`-verb path — routing is purely `keys.len()`, never mixed within one invocation | BC-3.4.023 Invariant 3 | AC-006 |
| A chunk failure aborts the remaining sequence (no continue-on-error) — do NOT reuse `rename --all-projects`'s per-target fail-soft shape here | BC-3.4.023 Edge Case EC-3.4.023-4 | AC-009 |
| This path MUST NOT ship to release until the live smoke test passes | BC-3.4.023 Delivery note, DEC-280 | AC-010 (release gate, not `cargo test`) |
| Do NOT add `sendBulkNotification` to the bulk-component body — reuse `bulk_edit_fields` as-is (the #446-live-proven composition is source of truth, not the Atlassian doc example) | BC-3.4.023 Postcondition 2 clarification (2026-08-19) | code review; AC-001 wire-shape assertion asserts the exact body key set |

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|----------|
| reqwest / serde (existing) | as in `Cargo.lock` | Bulk POST body composition |
| wiremock (existing) | as in `Cargo.lock` | Integration tests (multi-chunk fixtures) |

No new crate dependencies.

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|----------|
| `src/cli/issue/edit.rs` | MODIFY | Bulk-fields component branch, chunking loop |
| `src/api/jira/bulk.rs` | MODIFY | `multiselectComponents` body-composition types/fn |
| `tests/issue_commands.rs` | MODIFY | New test cases (10 ACs) |
| `tests/common/fixtures.rs` | MODIFY | Multi-chunk bulk-fields fixtures |

**MUST NOT change**: `src/cli/issue/edit.rs`'s single-key component path (S-605-1's scope);
`handle_edit_bulk_labels` (unrelated field, different wire shape — do not generalize).
