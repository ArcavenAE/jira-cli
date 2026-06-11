---
document_type: f3-story-decomposition
feature: "issue #475 — ADF E2E read-path coverage"
produced_by: story-writer
date: 2026-06-11
story_count: 1
status: complete
---

# F3 Story Decomposition — Issue #475: ADF E2E Read-Path Coverage

## Step 1: Existing Story Graph Summary

- Current total_stories: 67 (STORY-INDEX.md frontmatter, updated 2026-06-10)
- Highest semantic feature story IDs in the feature-followup group: S-483, S-474, S-471
- This story increments total to 68
- New story ID: `S-475` (semantic, following the issue number convention used by S-471, S-474, S-483)

## Step 2: Story Produced

ONE story: `S-475-adf-e2e-readpath.md`

Written to: `/Users/zious/Documents/GITHUB/jira-cli/.factory/stories/S-475-adf-e2e-readpath.md`

### Story Summary

| Field | Value |
|-------|-------|
| Story ID | S-475 |
| Title | ADF E2E read-path coverage: adf_to_text live test + listItem normalization live assert + comment read path + test rename |
| Wave | feature-followup |
| Status | draft |
| Points | 3 SP |
| Priority | P1 |
| tdd_mode | strict |
| BC Anchors | BC-7.2.003, BC-7.2.004, BC-7.2.006 |
| depends_on | [] (leaf node) |
| blocks | [] |

### AC → BC Traceability Table

| AC | Test name | BC anchor | Clause type | Coverage added |
|----|-----------|-----------|-------------|---------------|
| AC-1 | `test_e2e_adf_read_path_human_output` | BC-7.2.003 | postcondition ("round-trip covers headings, lists, code blocks, blockquotes, links") | First live exercise of `adf_to_text` via `jr issue view` human mode |
| AC-1 | `test_e2e_adf_read_path_human_output` | BC-7.2.004 | postcondition ("`adf_to_text` rendering … code, headings preserved") | Live human-mode rendering confirmed via content-word substring assertions |
| AC-2 | `test_e2e_adf_read_path_human_output` (sub-sequence) | BC-7.2.006 | postcondition ("`markdown_to_adf` produces only permitted child node types inside any `listItem`") | First live exercise of `normalize_list_item_content`; create exits 0; `adf_has_blockquote_in_list_item` negative assertion |
| AC-3 | `test_e2e_adf_read_path_human_output` (sub-sequence) | BC-7.2.004 | postcondition ("`adf_to_text` rendering") | First live exercise of `adf_to_text` via `jr issue comments` human mode; `_emphasis_` → `*emphasis*` discriminator |
| AC-4 | `test_e2e_markdown_description_produces_heading_node` (renamed) | BC-7.2.003 | postcondition ("round-trip covers headings") | Name accuracy; clarifying comment; no behavioral change |

Every BC in `bcs:` frontmatter is cited by at least one AC. Every AC cites a BC via trace
annotation. AC↔BC bidirectional traces are present.

## Step 3: Dependency Graph Extension

### New story dependencies

```
S-475 → depends_on: []
       blocks: []
```

S-475 is a leaf node. It has no dependencies on other stories (all prerequisite production
code is on `develop`) and no story blocks it.

### Topological sort result

Adding S-475 to the existing 67-story graph:
- S-475 has in-degree 0 (no dependencies)
- S-475 has out-degree 0 (blocks nothing)
- Topological sort: S-475 can be placed in any wave position; the existing wave ordering
  is completely unaffected.

**Result: NO CYCLE INTRODUCED.** The dependency graph remains acyclic.

### Visual (leaf node)

```
[all existing 67 stories]   [S-475 — test-only leaf]
                                    |
                               depends_on: []
                               blocks: []
```

## Step 4: Cycle Detection

Kahn's algorithm applied to the 68-story graph (67 existing + 1 new):

1. Compute in-degrees: all existing story in-degrees are unchanged. S-475 in-degree = 0.
2. Initialize queue with all 0-in-degree nodes: S-475 included.
3. Process queue: S-475 is processed; no outgoing edges → no in-degree decrements for others.
4. All 68 nodes processed. Queue empty. No cycle.

**Cycle detection: PASS. The extended dependency graph is acyclic.**

## Step 5: Conflict Detection

| Check | Result |
|-------|--------|
| Files modified by S-475 overlap with in-progress stories? | NO — `tests/e2e_live.rs` is not modified by any currently in-progress story. `docs/specs/e2e-live-jira-testing.md` is not modified by any in-progress story. |
| Dependencies on incomplete stories? | N/A — S-475 has no dependencies. |
| Race conditions? | None. S-475 is a leaf node. |

**Conflict detection: PASS. No conflicts.**

## Step 6: Estimation

| Field | Value |
|-------|-------|
| Story points | 3 SP |
| Estimated days | 1 |
| Parallelizable? | Yes — independent of all other stories |
| Critical path length | 1 story (leaf) |
| Wave | feature-followup (alongside S-471, which is also in draft/awaiting F4) |

## Step 7: Wave Schedule

S-475 is a feature-followup story (test-only, no production code changes). It belongs in
the feature-followup group alongside S-471, S-474, S-483.

Wave assignment: **feature-followup**. No wave dependency on any in-flight story. Can be
dispatched to F4 independently of S-471.

Candidate parallel group with S-471 (both are `depends_on: []`, both are feature-followup
E2E test stories, both modify `tests/e2e_live.rs`). Note: if both are dispatched in
parallel, the implementers must coordinate the merge order to avoid conflicts on
`tests/e2e_live.rs`. Recommend sequential dispatch: S-471 first (unit tests), S-475 second
(E2E integration tests) — or coordinate as a single PR if the F4 implementer handles both.

## Step 8: STORY-INDEX.md Update Required

The following fields in `/Users/zious/Documents/GITHUB/jira-cli/.factory/stories/STORY-INDEX.md`
must be updated (by state-manager or the implementer in the same commit as the story file):

1. `total_stories:` frontmatter: 67 → 68
2. The Feature Followup table: add a row for S-475
3. The Story Manifest section: add a row for S-475 with its file path
4. The last_updated timestamp and changelog prose in the wave-plan preamble

Story Manifest row to add:
```
| S-475 | feature-followup | /Users/zious/Documents/GITHUB/jira-cli/.factory/stories/S-475-adf-e2e-readpath.md |
```

Feature Followup table row to add:
```
| S-475 | ADF E2E read-path coverage: `adf_to_text` live test + listItem normalization live assert + comment read path + rename `test_e2e_issue_markdown_description_roundtrip` → `test_e2e_markdown_description_produces_heading_node` | BC-7.2.003, BC-7.2.004, BC-7.2.006 | — | **draft** — F3 COMPLETE (2026-06-11); awaiting F4 dispatch | small (3 SP) |
```

## Step 9: Quality Gate Check

- [x] Story ID continues the existing sequence without collisions (S-475 is unique)
- [x] Story is a per-file STORY-NNN.md (not monolithic)
- [x] Every new story references BCs in `bcs:` frontmatter AND in AC trace annotations
- [x] Every new story has testable acceptance criteria (4 ACs with test function names)
- [x] `verification_properties: []` — this is a test-only story with no new VPs; the BCs exercised are existing and already have VPs if any (none for these test-infrastructure BCs)
- [x] Dependency graph has no cycles (topological sort PASS)
- [x] Dependency graph extended without modifying existing stories
- [x] Wave schedule: feature-followup (leaf node; no wave dependency)
- [x] No DTU clone stories needed (no external service dependency)
- [x] No gene transfusion stories (standard TDD implementation)
- [x] No conflicts with in-progress work
- [x] Effort estimated (3 SP; 1 day)
- [x] All six context-engineering sections present in the story file:
      - [x] Token Budget Estimate
      - [x] Previous Story Intelligence
      - [x] Architecture Compliance Rules
      - [x] Library and Framework Requirements
      - [x] File Structure Requirements
      - [x] (Tasks section is embedded in Definition of Done — acceptable for this project's convention; no dedicated Tasks section in peer stories S-471/S-483/S-474)
- [x] tdd_mode: strict (no facade mode; this is a standard test authoring story)
- [x] BC array propagation: `bcs:` frontmatter matches body BC table AND AC traces
- [x] Spec-First Gate (S-7.01): `behavioral_contracts`/`bcs:` is non-empty → status may be `draft`
      (not `ready` until PO confirms; BCs are existing, no new authoring needed — may advance to ready after human review)

## Ambiguities Flagged for F4 Implementer

1. **Line numbers in `tests/e2e_live.rs` for AC-4 rename**: The F2 spec cites ~line 4591
   for `test_e2e_issue_markdown_description_roundtrip`. This is an approximation. The F4
   implementer must locate the actual function definition with `grep -n` before renaming.
   (Instruction: `grep -n "fn test_e2e_issue_markdown_description_roundtrip" tests/e2e_live.rs`)

2. **`docs/specs/e2e-live-jira-testing.md` AC-4 touch-point line**: Cited as ~123. The F4
   implementer must locate the bullet with the old test name.
   (Instruction: `grep -n "test_e2e_issue_markdown_description_roundtrip" docs/specs/e2e-live-jira-testing.md`)

3. **Exact `poll_view` semantics**: `poll_view` (line ~474) returns a `serde_json::Value`
   representing the full `jr issue view <key> --output json` output. The description ADF
   tree is at `json_output["fields"]["description"]`. The F4 implementer should verify this
   path matches the actual JSON shape of `jr issue view --output json` by inspecting an
   existing test that uses `poll_view` with `fields.description` (e.g. the task-list tests
   around line 9074 use `description_json = &json_output["fields"]["description"]`).

4. **S-471 coordination**: S-471 also targets `tests/e2e_live.rs` (for ADF task list
   content-model normalization) but that story does NOT add new E2E test functions — it
   adds inline unit tests to `src/adf.rs` only (the S-471 story spec §Test Coverage Summary
   confirms: "All tests are inline unit tests in `src/adf.rs::tests`. No new integration
   test files"). There is therefore no code conflict with S-475 on `tests/e2e_live.rs`. The
   implementer should nonetheless verify S-471's merge status before the S-475 PR is created.

5. **E2E project env var**: The issue is created in `project()` (which reads `JR_E2E_PROJECT`).
   This is the standard E2E project — same as all other write tests. No JSM project needed.
   The label-based CI sweeper covers cleanup; no `jsm_self_close` needed.
