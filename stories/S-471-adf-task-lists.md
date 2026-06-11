---
document_type: story
story_id: "S-471"
title: "GFM task lists (- [ ] / - [x]) → ADF taskList/taskItem nodes with content-model normalization"
wave: feature-followup
status: draft
intent: enhancement
feature_type: backend
mode: feature
scope: small
severity: LOW
trivial_scope: false
issue: 471
points: 3
priority: P1
tdd_mode: strict
estimated_effort: small
estimated_days: 1
target_module: adf
subsystems: []
depends_on: []
blocks: []
bc_anchors:
  - BC-7.2.010
bcs:
  - BC-7.2.010
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: ".factory/phase-f1-delta-analysis/issue-471-delta-analysis.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 18
assumption_validations: []
risk_mitigations: []
created: "2026-06-10"
last_updated: "2026-06-10"
breaking_change: false
retroactive: false
predecessor_cycles: "PR #487 (issue #483, BC-7.2.009 GFM alerts → panel), PR #477 (issue #470, BC-7.2.006 listItem normalization)"
---

# S-471 — GFM Task Lists → ADF taskList/taskItem

## Source of Truth

BC-7.2.010 body: `.factory/specs/prd/bc-7-output-render.md §7.2.010`
Delta analysis: `.factory/phase-f1-delta-analysis/issue-471-delta-analysis.md`
Research — node shape: `.factory/research/issue-471-adf-tasknode-shape.md`
Research — pulldown blockquote: `.factory/research/issue-471-pulldown-blockquote-tasklist.md`
Research — panel/taskList shape: `.factory/research/issue-471-panel-tasklist-shape.md`
Predecessor issue: #483 (GFM alerts → ADF panel; same pattern class: new node types + normalization + reverse path)
Design spec (to be authored in F4 implementer step): `docs/specs/adf-task-list.md`

## Summary

Map GFM task-list syntax (`- [ ] …` / `- [x] …`) to ADF `taskList`/`taskItem` nodes in
`markdown_to_adf`, assign deterministic counter-based `localId` strings via a
post-normalization DFS pre-order walk, normalize `taskList` in invalid parent containers
(`listItem`, `blockquote`), and render them back to `- [ ]`/`- [x]` in `adf_to_text`.

All changes are confined to `src/adf.rs`. Zero changes outside that file.

## Behavioral Contracts

| BC | Statement |
|----|-----------|
| BC-7.2.010 | `markdown_to_adf` maps GFM task lists (`- [ ] …` / `- [x] …`) to ADF `taskList`/`taskItem` nodes; state is uppercase `"TODO"`/`"DONE"`; localId is a counter-based deterministic string; `adf_to_text` renders `taskList`/`taskItem` back to `- [ ]`/`- [x]`; task list inside `listItem` or `blockquote` is normalized (unwrapped) before output. |

## Story Narrative

As a Jira user writing issue descriptions or comments in Markdown,
I want `jr issue create/edit --description` to emit proper ADF `taskList`/`taskItem`
nodes for GFM task-list syntax (`- [ ] pending` / `- [x] done`),
so that checkboxes are rendered as interactive task items in the Jira UI rather than as
literal `[x]`/`[ ]` text inside a bullet list.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file, post-adversarial-pass-1 revision) | ~3,200 |
| `src/adf.rs` (full file — only modified file) | ~4,200 |
| BC file delta (`bc-7-output-render.md` — BC-7.2.010 body) | ~700 |
| Test output (`cargo test adf::tests`) | ~600 |
| Delta analysis (`issue-471-delta-analysis.md`) | ~800 |
| **Total** | **~9,500** |

Well within a 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**Predecessor: issue #483 (BC-7.2.009, PR #487) — most direct template**
Introduced `normalize_panel_content`, `gfm_label_for_panel_type`, and `panel` arms in
`adf_to_text`. Also added `panel` to `is_empty_block_container`'s prune set and extended
`normalize_list_item_content` with a `panel` arm. This story follows the identical structural
pattern: new pulldown-cmark option flag → new node types → content-model normalization
passes → reverse path → prune set extension. The `normalize_panel_content` `_ => out.push(child)`
catch-all **already passes `taskList` through correctly** because `panel.content` permits
`taskList` (BC-7.2.009) — do NOT add a `taskList` arm to `normalize_panel_content`.

**REQUIRED: `wrap_inlines_as_blocks` Panel allowlist fix (confirmed by `.factory/research/issue-471-panel-tasklist-shape.md`):**
`normalize_panel_content` preserves the `taskList`, but the Panel arm's subsequent
`wrap_inlines_as_blocks` call (lines 451–459 in `end()`) has an allowlist
`["paragraph", "heading", "bulletList", "orderedList", "codeBlock", "rule"]` that does
NOT include `"taskList"`. Without the fix, a `taskList` is misclassified as inline and
wrapped into `panel > paragraph > taskList` — INVALID ADF (Jira 400). Adding `"taskList"`
to that allowlist is a REQUIRED one-line change for F4. See AC-008 and File Structure
Requirements for the checkable item.

**Predecessor: issue #470 (BC-7.2.006, PR #477)**
Introduced `normalize_list_item_content`, `is_empty_block_container`, and
`flatten_table_to_paragraphs`. The `normalize_list_item_content` function gains a
`"taskList"` arm in this story. The implementer must NOT disturb the existing
`blockquote`-unwrap and `panel`-unwrap arms when adding the `taskList` arm.

**Predecessor: issue #474 (BC-7.2.007/008, PR #474)**
Added `ENABLE_SUPERSCRIPT | ENABLE_SUBSCRIPT | ENABLE_HEADING_ATTRIBUTES` to the
options block in `markdown_to_adf`. This story adds `Options::ENABLE_TASKLISTS` to the
SAME options chain. The implementer must NOT disturb existing flags.

**Predecessor: issue #472 (footnotes, PR #481)**
Added `Options::ENABLE_FOOTNOTES`. The new `ENABLE_TASKLISTS` flag is added adjacent
in the same options chain without disturbing the footnotes block.

**CRITICAL — Existing breaking test:**
`test_markdown_task_list_syntax_preserved_as_text` (line ~2455 in `src/adf.rs`)
pins the PRE-#471 behavior: `ENABLE_TASKLISTS is not set, so [x] renders as literal
text inside a bullet item`. When `ENABLE_TASKLISTS` is added, this test WILL FAIL.
This test MUST be REPLACED (not deleted) with new tests asserting `taskList`/`taskItem`
output shape. See AC-017 for the required replacement.

**Builder mechanics (BC-7.2.010 — post-hoc reclassification, Approach B):**
`Tag::List(None)` arrives before any `TaskListMarker` event, so the builder cannot know
at `Start(Tag::List)` time whether to push `BulletList` or `TaskList`. Approach B
(locked in BC): the builder initially treats the list as `BulletList`; at
`End(TagEnd::List)` it inspects whether any children are `taskItem` nodes — if so, it
emits `"taskList"` instead of `"bulletList"` and upgrades any plain `listItem` children
to `taskItem { state: "TODO" }`.

**localId assignment rule (BC-7.2.010 §Required attributes — load-bearing):**
localIds are assigned in a **single post-normalization, post-pruning DFS pre-order walk**
of the final ADF tree, using a 1-based monotonically increasing counter. Pruned nodes
never consume a counter slot. Container nodes are numbered before their children. This
replaces the F1 delta-analysis suggestion of UUID generation — no `uuid` crate dependency
is added.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Single modified file | delta-analysis.md §Impact Boundary | All production changes confined to `src/adf.rs`. No new modules, structs, enums outside this file. No CLI, API, config, cache, or keychain changes. |
| No uuid crate | BC-7.2.010 §Required attributes | localIds are counter-based strings ("1", "2", …). Do NOT add the `uuid` crate to `Cargo.toml`. |
| `additionalProperties: false` on attrs | BC-7.2.010 §Schema strictness note | Emit ONLY `localId` for `taskList.attrs`; ONLY `localId` + `state` for `taskItem.attrs`. Any extra key causes Jira HTTP 400. |
| taskItem content is inline-only | BC-7.2.010 §Required attributes | Do NOT wrap `taskItem` content in a `paragraph`. Text nodes and marks go directly in `taskItem.content`. This differs from `listItem` which uses `paragraph` wrappers. |
| Panel normalization: no-op | BC-7.2.010 Content-model obligation #3 | `panel.content` permits `taskList` — the existing `_ => out.push(child)` catch-all handles it correctly. Do NOT add a `taskList` arm to `normalize_panel_content`. |
| Panel `wrap_inlines_as_blocks` allowlist: add `"taskList"` | `.factory/research/issue-471-panel-tasklist-shape.md` §D (REQUIRED) | The Panel arm's `wrap_inlines_as_blocks` call (lines ~451–459) allowlist `["paragraph","heading","bulletList","orderedList","codeBlock","rule"]` MUST have `"taskList"` added. Without it, a surviving `taskList` child is misclassified as inline → `panel > paragraph > taskList` (INVALID ADF, Jira 400). This is a one-line required change. Pinned by `test_task_list_in_panel_passes_through` (AC-008). |
| ENABLE_GFM must not be added here | BC-7.2.009 (already shipped) | `ENABLE_GFM` was added in issue #483 for panel support. Adding it again is a no-op, but do NOT duplicate the flag in the options chain. |
| Dedup marks at all text-emission sites | BC-7.2.007 (already in force) | `dedup_marks_by_type` is already applied at `push_text` and `push_code`. The new `taskItem` inline-emission path must also call `dedup_marks_by_type`. |

## Library and Framework Requirements

| Library | Version | Constraint |
|---------|---------|-----------|
| pulldown-cmark | 0.13.x (from `Cargo.toml`) | `Options::ENABLE_TASKLISTS` must be present in 0.13.x. `TaskListMarker(bool)` event ordering is pinned: always the first child event after `Start(Tag::Item)`, before item text — in ALL nesting contexts (top-level, inside blockquote, inside nested list). Confirmed by `.factory/research/issue-471-pulldown-blockquote-tasklist.md` primary source. |
| serde_json | current (from `Cargo.toml`) | `json!({"type":"taskList","attrs":{"localId":"1"}})` construction — no version change. |

No new crate dependencies are added by this story.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `src/adf.rs` | MODIFY | (1) Add `Options::ENABLE_TASKLISTS` to parser options; (2) Add `TaskItem { checked: bool }` and `TaskList` to `NodeKind` enum; (3) Add `Event::TaskListMarker(checked)` arm in `AdfBuilder::process`; (4) Modify `Tag::Item` arm in `AdfBuilder::start` to defer task-item candidate creation; (5) Modify `TagEnd::List` arm in `AdfBuilder::end` for post-hoc reclassification; (6) Add `TagEnd::Item` finalization for TaskItem — the `End(TagEnd::Item)` pulldown event fires `end()`, which pops the stack and enters the `match kind` block; EC-16 inline-flattening (paragraph-strip + hardBreak-separator + leading/trailing-hardBreak trim) MUST run INSIDE the `NodeKind::TaskItem` arm of that `match kind` block (there is NO `match tag_end { TagEnd::Item => }` arm — the flatten logic lives in the `match kind` block), BEFORE the arm returns `Some(taskItem_node)` to the prune gate at ~line 608. Do NOT place the flatten in a post-`finish()` pass — that inverts the EC-16-before-EC-8 ordering and breaks the both-empty prune (see AC-015); (7) Add `"taskList"` arm in `normalize_list_item_content`; (8) Add `normalize_blockquote_content` pass (or equivalent) for blockquote→taskList unwrapping; (9) Add `"taskList"` and `"taskItem"` to `is_empty_block_container` — adding `"taskItem"` to `REQUIRES_CONTENT` is NECESSARY but INSUFFICIENT: `is_empty_block_container` currently checks `content.is_empty()` (zero-length array). A `taskItem` with `content: [hardBreak]` or `content: [text("   ")]` has a non-empty array and would NOT be pruned by membership alone. A second "structurally-empty inline content" branch is required, applied ONLY to `taskItem`: treat content as effectively empty when ALL nodes are either (a) whitespace-only text nodes (trim is empty) or (b) hardBreak nodes, with no other content. The structural-only `c.is_empty()` semantics for the existing 8 container types MUST NOT be altered — the existing `test_is_empty_block_container_membership` pin at ~line 2753 must still pass after adding the taskItem branch; (10) Add `ListFrame::Task` variant; (11) Add `"taskList"` and `"taskItem"` arms in `AdfRenderer::render_node`; (12) Implement post-normalization DFS localId assignment walk; **(13) [REQUIRED — AC-008] Add `"taskList"` to the Panel arm's `wrap_inlines_as_blocks` allowlist (lines ~451–459 in `end()`). Without this one-line change, a task list inside a GFM alert produces `panel > paragraph > taskList` — INVALID ADF (Jira 400). The fix is: add `"taskList"` to the `&[…]` slice passed to `wrap_inlines_as_blocks` in the `NodeKind::Panel` arm. Pinned by `test_task_list_in_panel_passes_through`. Source: `.factory/research/issue-471-panel-tasklist-shape.md` §D.** (14) Add 19 new named inline unit tests (net delta +18 from baseline: `test_markdown_task_list_emits_task_list_node`, `test_markdown_task_checked_item_emits_done_state`, `test_markdown_task_uppercase_x_emits_done_state`, `test_markdown_mixed_task_plain_list_promotes_container`, `test_markdown_task_item_inline_marks_preserved`, `test_task_list_in_list_item_normalized_to_nested_bullet_list`, `test_task_list_in_blockquote_normalized_to_paragraphs`, `test_task_list_in_panel_passes_through`, `test_empty_task_item_pruned`, `test_empty_task_list_pruned`, `test_hardbreak_only_task_item_pruned`, `test_task_list_roundtrip_adf_to_text`, `test_adf_to_text_external_lowercase_state`, `test_nested_task_list_preserved`, `test_malformed_task_markers_stay_literal_text`, `test_task_item_with_nested_plain_list_hoists_block_sibling`, `test_task_item_multi_paragraph_flattened_to_inline`, `test_task_item_native_hardbreak_inline_is_roundtrip_lossy`, `test_task_list_localid_dfs_preorder_assignment`; REPLACE (not delete) `test_markdown_task_list_syntax_preserved_as_text`). |
| `docs/specs/adf-task-list.md` | CREATE | Design spec authored during F4 (following the pattern of `docs/specs/adf-panel-content-model.md`). Documents builder mechanics, localId walk, normalization decisions, lossiness table. |
| `CLAUDE.md` | MODIFY | Add `"Markdown GFM task lists → ADF (adf.rs, issue #471)"` gotcha entry immediately after the existing bare-URL autolink entry. |

No new integration test files. All coverage is inline unit tests in `src/adf.rs::tests`.

## Acceptance Criteria

### AC-001 — Basic forward path: `- [ ] unchecked` → `taskItem` with `state: "TODO"`
(traces to BC-7.2.010 postcondition — ENABLE_TASKLISTS; TaskListMarker(false) → state: "TODO")

`markdown_to_adf("- [ ] unchecked item")` produces a `taskList` node containing one
`taskItem` with `attrs.state == "TODO"` and `content: [{"type":"text","text":"unchecked item"}]`.
The `localId` values are non-empty strings. The output contains NO `bulletList` node.

Pinned by: `test_markdown_task_list_emits_task_list_node`

---

### AC-002 — Checked item: `- [x] done` → `taskItem` with `state: "DONE"` (lowercase x)
(traces to BC-7.2.010 postcondition — TaskListMarker(true) → state: "DONE"; EC-1)

`markdown_to_adf("- [x] done item")` produces a `taskItem` with `attrs.state == "DONE"`.
`state` value is uppercase `"DONE"` (not `"done"` or `"Done"`).

Pinned by: `test_markdown_task_checked_item_emits_done_state`

---

### AC-003 — Uppercase `[X]` is recognized as checked (state: "DONE"); reverse renders `[x]`
(traces to BC-7.2.010 postcondition — EC-2; pulldown case-insensitive GFM spec; EC-10(f) lossy casing)

Two distinct behaviors, both pinned by the same test:

**AC-003a (forward path):** `markdown_to_adf("- [X] uppercase")` produces a `taskItem`
with `attrs.state == "DONE"`. `state` is uppercase `"DONE"` regardless of the input bracket
character case.

**AC-003b (reverse path / casing normalization):** The round-trip via `adf_to_text`
on the produced ADF renders as `- [x] uppercase` (lowercase x). The renderer always emits
`- [x] ` for DONE state, never `- [X] `. Casing normalization is documented lossiness
(EC-10(f)): `[X]`→`[x]` is permanent through the round-trip text form.

Pinned by: `test_markdown_task_uppercase_x_emits_done_state` — this test MUST assert BOTH
the forward `state == "DONE"` AND the reverse `adf_to_text` output contains `- [x] `
(not `- [X] `).

---

### AC-004 — Mixed task + plain items: whole container promoted to `taskList`
(traces to BC-7.2.010 postcondition — EC-3; mixed-list whole-container promotion)

Input `"- [ ] checkbox\n- plain item"` produces a `taskList` whose first item has
`state: "TODO"` and whose second item (the plain item) is also a `taskItem` with
`state: "TODO"`. No `listItem` nodes appear in the output. ADF does not permit
mixing `listItem` and `taskItem` in the same container; whole-container promotion
is the only schema-valid path.

Pinned by: `test_markdown_mixed_task_plain_list_promotes_container`

---

### AC-005 — Inline marks preserved inside a task item
(traces to BC-7.2.010 postcondition — EC-4; taskItem.content inline model)

`markdown_to_adf("- [x] **bold** and _em_")` produces a `taskItem` containing text
nodes with `strong` and `em` marks respectively. All standard inline marks (`strong`,
`em`, `link`, `code`, `subsup`, `strike`) are preserved in `taskItem.content`.
Content goes directly in `taskItem.content` — NOT wrapped in a paragraph.

Pinned by: `test_markdown_task_item_inline_marks_preserved`

---

### AC-006 — Nested task list inside a regular list item → `listItem > bulletList > listItem`
(traces to BC-7.2.010 postcondition — Content-model obligation #1; EC-5; EC-10(b) lossiness)

Input `"- outer\n  - [ ] inner task"` — the inner task list is normalized by
`normalize_list_item_content`'s `"taskList"` arm: each `taskItem`'s inline content
is wrapped in a `paragraph` to form a `listItem`, and all resulting `listItem`
nodes are collected into a new `bulletList`. The ADF-valid output shape is
`listItem > [bulletList > [listItem > paragraph(...)]]`.

**Additional mandatory assertions (closing F-002 gaps):**
- The inner nodes inside the new `bulletList` are `listItem` (NOT `taskItem`). Emitting
  `bulletList > [taskItem]` is INVALID ADF — `bulletList` may only contain `listItem`.
- The inner `listItem` nodes carry NO `state` attribute (no `attrs.state` field).
- The original checkbox state (`TODO`/`DONE`) from the source `taskItem` is **dropped**.
  This is documented lossiness (EC-10(b)): when a task list is normalized into a plain
  `bulletList`, checkbox state is irretrievably lost.

Directly placing converted `listItem` nodes inside the outer `listItem` without
the intervening `bulletList` would be INVALID ADF. No `taskList` node appears
inside any `listItem` in the output.

Pinned by: `test_task_list_in_list_item_normalized_to_nested_bullet_list`

---

### AC-007 — Task list inside a `blockquote` → `blockquote > [paragraph, ...]`
(traces to BC-7.2.010 postcondition — Content-model obligation #2; EC-6; unconditional)

Input `"> - [ ] item"` produces a `blockquote` whose children are `paragraph` nodes
containing the task item text. No `taskList` node appears inside any `blockquote` in
the output.

This normalization is **unconditional**: pulldown-cmark 0.13.3 **does** emit
`blockquote > taskList` for `> - [ ] item` — confirmed by direct primary-source read
of `firstpass.rs:128–160` (`.factory/research/issue-471-pulldown-blockquote-tasklist.md`).
The normalization pass is load-bearing.

Pinned by: `test_task_list_in_blockquote_normalized_to_paragraphs`

---

### AC-008 — Task list inside a `panel` → passes through as `panel > [taskList > taskItem]`
(traces to BC-7.2.010 postcondition — Content-model obligation #3; EC-7; no-op via catch-all + REQUIRED allowlist fix)

Input `"> [!NOTE]\n> - [ ] item"` produces a `panel` (from the GFM alert, per #483)
whose `content` is `[taskList > [taskItem(state: "TODO", content: [text("item")])]]`.
The `taskList` passes through `normalize_panel_content`'s `_ => out.push(child)` catch-all
unchanged. ADF `panel.content` permits `taskList` (BC-7.2.009 — confirmed against canonical
`@atlaskit/adf-schema` full.json v44.0.0).

**Expected shape LOCKED** (no F4-empirical confirmation needed). Evidence from
`.factory/research/issue-471-panel-tasklist-shape.md` (HIGH confidence, primary-source
code trace + ADF schema):

1. pulldown-cmark 0.13.3 emits `TaskListMarker` inside the alert-blockquote context
   identically to a plain blockquote — the task-marker scan in `firstpass.rs:142–160`
   is container-agnostic; the `kind` payload only tags the container type and does not
   alter the inner scan path.
2. `normalize_panel_content` preserves the `taskList` via the `_ => out.push(child)` arm
   (no unwrapping occurs).
3. `panel.content` explicitly permits `taskList_node` as a direct child in the canonical
   ADF schema (cross-checked v40.9.2 and v44.0.0).

**REQUIRED implementation change (not merely a test expectation):** The Panel arm's
`wrap_inlines_as_blocks` call (lines ~451–459 in `end()`) currently uses allowlist
`["paragraph", "heading", "bulletList", "orderedList", "codeBlock", "rule"]` — `"taskList"`
is MISSING. Without this one-line fix, a surviving `taskList` is misclassified as inline
and wrapped into `panel > paragraph > taskList` — INVALID ADF (Jira 400). The F4
implementer MUST add `"taskList"` to this allowlist. This change is checkable in the File
Structure Requirements section.

The locked expected ADF for the test input is:
```json
{
  "type": "panel",
  "attrs": { "panelType": "info" },
  "content": [{
    "type": "taskList",
    "attrs": { "localId": "<counter>" },
    "content": [{
      "type": "taskItem",
      "attrs": { "localId": "<counter>", "state": "TODO" },
      "content": [{ "type": "text", "text": "item" }]
    }]
  }]
}
```

**tableCell arm — OUT OF SCOPE (unreachable from markdown input):** The research file
flags the tableCell `wrap_inlines_as_blocks` allowlist as the same omission class.
However, GFM table cells are inline-only — pulldown-cmark does not emit `Tag::List`
(and therefore no `TaskListMarker`) inside a table cell. A `- [ ]` inside a `| cell |`
is parsed as literal text, not a list. A `taskList` node cannot arise inside a `tableCell`
from markdown→ADF input. No tableCell allowlist change is required.

**listItem arm — covered by AC-006:** The research file also notes the listItem
`wrap_inlines_as_blocks` allowlist lacks `"taskList"`. This case is correctly handled by
the existing `normalize_list_item_content` `"taskList"` arm (AC-006), which unwraps
`taskList` into a `bulletList > listItem` shape BEFORE `wrap_inlines_as_blocks` runs —
so no surviving `taskList` reaches the listItem allowlist call. No listItem allowlist
change is required.

Pinned by: `test_task_list_in_panel_passes_through` — asserts the definite locked shape
`panel(info) > [taskList > [taskItem(state: "TODO", content: [text("item")])]]`
unconditionally. No fallback or provisional branch.

---

### AC-009 — Empty task item pruned; empty task list pruned; hardBreak-only item pruned
(traces to BC-7.2.010 postcondition — EC-8/EC-9; is_empty_block_container prune set; deliberate product choice)

**Empty-content prune (EC-8):** `"- [ ]"` (no text after checkbox) — the `taskItem` has
empty content and is pruned by `is_empty_block_container`.

**Empty-list prune (EC-9):** When all `taskItem` nodes in a `taskList` are pruned, the
resulting empty `taskList` (minItems: 1 violated) is also pruned.

**hardBreak-only prune (deliberate product choice, resolves F-006):** A `taskItem`
containing ONLY a `hardBreak` node and no other content is also pruned. This is a
**deliberate product choice**, not schema-forced (a hardBreak IS schema-valid in
`taskItem.content`). The decision is: a checkbox item with nothing but whitespace/line
breaks is meaningless to the user; pruning it is the correct UX behavior.

This deliberate choice has a dedicated assertion: `test_hardbreak_only_task_item_pruned`
with input `"- [ ] \\\n"` (backslash hardBreak in GFM, producing `taskItem.content:
[hardBreak]` after inline processing). The `taskItem` must be pruned; the resulting
empty `taskList` must also be pruned.

**Implementation note — new emptiness branch required (resolves F-P2-001):**
Adding `"taskItem"` to `is_empty_block_container`'s `REQUIRES_CONTENT` array is necessary
but insufficient. The existing predicate checks `content.is_empty()` (zero-length array);
a hardBreak-only or whitespace-only `taskItem` has a non-empty array and will not be pruned
by membership alone. A second "structurally-empty inline content" branch must be added,
scoped exclusively to `"taskItem"`: treat `taskItem` content as effectively empty when ALL
nodes are either (a) whitespace-only text nodes (text.trim() is empty) or (b) `hardBreak`
nodes, with no other nodes present. The structural-only `c.is_empty()` check for the 8
existing container types MUST NOT change.

**Regression assertion:** The 8 existing container types (`blockquote`, `panel`, `heading`,
`listItem`, `bulletList`, `orderedList`, `table`, `tableRow`) retain structural-only
emptiness semantics — the existing `test_is_empty_block_container_membership` pin at ~line
2753 MUST still pass after adding the `taskItem` branch. The test for `taskItem`'s extended
semantics is separate (within `test_empty_task_item_pruned` and `test_hardbreak_only_task_item_pruned`).

Pinned by: `test_empty_task_item_pruned`, `test_empty_task_list_pruned`,
`test_hardbreak_only_task_item_pruned`

---

### AC-010 — Round-trip stability for top-level task lists
(traces to BC-7.2.010 postcondition — EC-10; adf_to_text + re-parse)

`adf_to_text(markdown_to_adf("- [ ] pending\n- [x] done"))` produces a string
containing `"- [ ] pending"` and `"- [x] done"`. Re-parsing that string with
`markdown_to_adf` produces semantically equivalent ADF (state values match;
localId values are not carried through the text form; a fresh re-parse re-derives
them deterministically from the counter (identical input yields identical localIds)).

Lossiness disclosed (BC-7.2.010 EC-10): mixed-list promotion, `listItem` normalization,
`blockquote` unwrapping, nested-plain-list hoist, multi-paragraph flattening,
`[X]`→`[x]` casing, and hardBreak-separator are all documented lossy transforms.

Pinned by: `test_task_list_roundtrip_adf_to_text`

---

### AC-011 — `adf_to_text` renders externally-authored `state: "done"` (lowercase) as `- [x]`
(traces to BC-7.2.010 postcondition — EC-12; case-insensitive state comparison)

An externally-authored ADF `taskItem` node with `attrs.state == "done"` (lowercase)
is rendered as `- [x] <text>` by `adf_to_text`. The comparison is
`attrs.state.eq_ignore_ascii_case("DONE")`. Any value other than a case-insensitive
match of `"DONE"` (including absent `state`) renders as `- [ ] `.

Pinned by: `test_adf_to_text_external_lowercase_state`

---

### AC-012 — Nested task list (task-in-task): sibling placement inside parent `taskList.content`
(traces to BC-7.2.010 postcondition — EC-13; nested taskList schema placement; reverse-path indentation)

**Forward path:** Input `"- [ ] outer\n  - [x] nested"` produces a `taskList` whose content
array is `[taskItem("outer text"), taskList([taskItem("nested text")])]` — the nested
`taskList` is placed as a sibling element in the parent `taskList`'s content array,
immediately AFTER the parent `taskItem`. It is NOT placed inside `taskItem.content`
(inline-only).

**Reverse path — 2-space indentation pinned (resolves F-008):** `adf_to_text` renders
nested task lists with exactly 2-space indentation per nesting level. The pinned rendered
string for the above ADF is:
```
- [ ] outer
  - [x] nested
```
The test MUST assert this exact string (or equivalent with `\n  - [x] nested` substring)
— 2 spaces before the nested `- [x]`. Emitting 4-space, tab, or no indentation would fail
this assertion.

Pinned by: `test_nested_task_list_preserved` — this test MUST assert BOTH the forward
ADF tree shape AND the reverse `adf_to_text` output with pinned 2-space indentation.

---

### AC-013 — Malformed bracket forms stay literal text in `bulletList`
(traces to BC-7.2.010 postcondition — EC-14; pulldown parser leniency)

Only the three pulldown-recognized forms produce `TaskListMarker`: `[ ]`, `[x]`, `[X]`.
The following forms produce NO `TaskListMarker` and stay as literal text nodes inside
a `bulletList` (not a `taskList`): `[]` (no space), `[*]`, `[-]`, `[  ]` (multi-space),
`[ x]` (space before letter), `[X ]` (trailing space).

Pinned by: `test_malformed_task_markers_stay_literal_text`

---

### AC-014 — Plain list nested inside a task item → hoisted to grandparent block level
(traces to BC-7.2.010 postcondition — Content-model obligation #4; EC-15)

Input `"- [ ] outer\n  - plain inner"` — the nested `bulletList` cannot be placed in
`taskItem.content` (inline-only) or as a sibling inside `taskList.content`
(only `taskItem`/`taskList` permitted). The builder hoists the nested list out of the
`taskList` entirely, appending it as a sibling node AFTER the parent `taskList` at the
grandparent block level. Output at grandparent level: `[taskList > [taskItem("outer")], bulletList(...)]`.

This is a lossy transform (visual nesting association lost). Deliberate — same class as
other EC-10 lossiness.

**Scope justification (resolves F-003 — non-root case analysis):** This AC is explicitly
scoped to the doc-root case and this is the ONLY valid scope. Non-root cases cannot
arise from valid GFM markdown because the two container contexts that could produce a
non-root task list are both normalized earlier in the pipeline:
- `blockquote > taskList` → normalized by AC-007 (unconditional blockquote unwrap) before
  hoist runs; no `taskList` survives inside any `blockquote` to trigger this path.
- `panel > taskList` → passes through unchanged (AC-008); panels do not have the
  `taskItem.content` inline-only restriction, so the hoist path is never triggered.
The only reachable hoist scenario from valid GFM markdown is therefore a top-level
task item with a nested plain list, where "grandparent" IS the document root.
The test input correctly covers the full behaviorally reachable scope.

Pinned by: `test_task_item_with_nested_plain_list_hoists_block_sibling`

---

### AC-015 — Multi-paragraph task item: paragraph wrappers stripped; `hardBreak` separator injected
(traces to BC-7.2.010 postcondition — EC-16; inline-flattening; hardBreak trim rule; EC-16-before-EC-8 ordering)

**Normal case:** Input `"- [ ] line1\n\n  line2"` — pulldown emits paragraph-wrapped bodies;
the paragraph wrappers are stripped (taskItem is inline-only) and inline content is
concatenated with a `hardBreak` separator:
`taskItem.content: [text("line1"), hardBreak, text("line2")]`.

**hardBreak trim rule:** after concatenation, leading/trailing `hardBreak` nodes and any
`hardBreak` adjacent to a pruned-empty paragraph are trimmed. `taskItem.content` never
begins or ends with a `hardBreak`.

**Additional sub-assertions (resolves F-005 — EC-16 ordering verification):**

**Trailing-empty-paragraph trim:** Input `"- [ ] x\n\n  "` (second paragraph is
whitespace-only / empty after stripping) — the resulting `taskItem.content` is
`[text("x")]` with NO trailing `hardBreak`. The trim pass removes the hardBreak that
would have been injected before the empty paragraph.

**Both-empty flatten→trim→prune sequence (load-bearing ordering test — resolves F-P2-002):**
Input `"- [ ]\n\n  "` — the taskItem has two empty paragraphs. EC-16 inline-flattening
runs first (INSIDE the `NodeKind::TaskItem` arm of `end()`'s `match kind` block (which fires
on the `End(TagEnd::Item)` event), before the node is returned to the prune gate at ~line 608)
and produces an empty `content` array (both paragraphs empty → no text nodes → no hardBreak
separator). EC-8 prune then fires because `taskItem.content` is empty → the `taskItem` is
ABSENT from the output. The `taskList` is also absent if no items remain.

This sub-assertion OBSERVABLY distinguishes the two orderings and MUST be phrased to FAIL if
prune-before-flatten is implemented:
- **Flatten-first (correct):** EC-16 runs inside the `NodeKind::TaskItem` arm of `end()`'s
  `match kind` block (on the `End(TagEnd::Item)` event) → content becomes `[]` → prune gate
  sees empty array → `taskItem` pruned → ABSENT from output.
- **Prune-first (bug):** prune gate evaluates the unflattened `[paragraph(""), paragraph("")]`
  shape → non-empty content array → NOT pruned → stray empty `taskItem` PRESENT in output.

The test for the both-empty case MUST assert the `taskItem` (or its enclosing `taskList`) is
**absent** from the output, so that placing the flatten in a post-`finish()` pass (which
inverts the ordering) causes a test failure.

**Ordering:** EC-16 inline-flattening runs INSIDE the `NodeKind::TaskItem` arm of `end()`'s
`match kind` block (which fires on the `End(TagEnd::Item)` event), BEFORE returning
`Some(taskItem_node)` to the prune gate at ~line 608. This is a real, test-pinned behavioral
contract — not an implementation detail.

Pinned by: `test_task_item_multi_paragraph_flattened_to_inline` — this test MUST cover
the normal two-paragraph case AND the trailing-empty-paragraph trim AND the
both-empty→prune sequence (three sub-assertions, one test function with multiple assert blocks).

---

### AC-016 — Native `hardBreak` in task item is schema-valid; round-trip is lossy
(traces to BC-7.2.010 postcondition — EC-11; hardBreak inline model)

A `hardBreak` node is schema-valid inside `taskItem.content` and is emitted normally.
`adf_to_text` renders it as a newline continuation of the item line.

The round-trip is **lossy**: a bare newline inside a `- [ ] …` line re-parses as a soft
break or item terminator, NOT as a GFM hardBreak (which requires two trailing spaces or
a backslash before the newline). The `hardBreak` is permanently lost through the
round-trip text form. Do NOT treat this as a bug.

Pinned by: `test_task_item_native_hardbreak_inline_is_roundtrip_lossy`

---

### AC-017 — Replacement of the breaking test: `test_markdown_task_list_syntax_preserved_as_text`
(traces to BC-7.2.010 cross-reference — pre-#471 literal-text behavior SUPERSEDED)

The existing test `test_markdown_task_list_syntax_preserved_as_text` (which asserts
`- [x]`/`- [ ]` renders as literal bullet-list text with the comment "ENABLE_TASKLISTS
is not set") **MUST be replaced** with a test asserting the new `taskList`/`taskItem`
output shape. It must NOT be silently deleted — the replacement must carry a comment
explaining what changed and why (parallel to `#474`'s
`test_markdown_double_tilde_still_strikethrough_not_subscript` treatment).

The replacement test is: `test_markdown_task_list_emits_task_list_node` (covered by AC-001
above). The implementer must confirm the old test is removed and the new test is present.

**AC-to-test asymmetry note (resolves F-009):** AC-017 is a **review-verified checklist
item**, not an additional independent automated assertion. It shares its test with AC-001
(`test_markdown_task_list_emits_task_list_node`). This intentionally creates an asymmetry:
18 ACs map to 19 distinct named test functions (AC-009 pins 3 tests; AC-010/AC-014 each
pin 1; all others 1:1; AC-017 shares AC-001's test). Net delta from baseline: +18 (19 new
names added, 1 old name removed). Reviewers should NOT expect a 19th novel test for
AC-017 — AC-017 is verified by code review confirming the old test was replaced rather
than deleted.

---

### AC-018 — localId DFS preorder assignment: concrete values, container-before-children, no gaps from pruned nodes
(traces to BC-7.2.010 postcondition — Required attributes; §localId counter-based deterministic assignment)

**Concrete-values assertion (resolves F-004):**
Input `"- [ ] first\n- [x] second"` — a 2-item task list — produces a `taskList` with:
- `taskList.attrs.localId == "1"` (container; numbered first in DFS preorder)
- `taskItem[0].attrs.localId == "2"` (first child)
- `taskItem[1].attrs.localId == "3"` (second child)

Counter is 1-based, monotonically increasing, DFS preorder (container before children).
Each `taskList` and `taskItem` node receives exactly one localId string. No `uuid` crate;
no random values; deterministic.

**Dense-assignment assertion (pruned nodes skip the counter):**
Input `"- [ ] keep\n- [ ]\n- [ ] also"` — the middle item has no text and is pruned.
After pruning, the post-normalization localId walk assigns IDs only to surviving nodes:
- `taskList.attrs.localId == "1"`
- `taskItem("keep").attrs.localId == "2"`
- `taskItem("also").attrs.localId == "3"`

The pruned middle item does NOT consume counter slot `"2"` or leave a gap. The
remaining items have dense IDs `"1"`, `"2"`, `"3"`.

**Rationale:** This confirms (a) the walk runs post-normalization/post-pruning (pruned
nodes never participate), and (b) counter assignment is strictly document-wide DFS, not
per-list or per-depth.

Pinned by: `test_task_list_localid_dfs_preorder_assignment` (two assert blocks in one test:
the 2-item case and the pruned-gap case).

---

## Implementation Notes

- `markdown_to_adf`: add `| Options::ENABLE_TASKLISTS` to the options bitmask.
- `NodeKind` enum: add `TaskList` and `TaskItem { checked: bool }` variants.
- `AdfBuilder::process`: add `Event::TaskListMarker(checked) => self.on_task_list_marker(checked)` arm.
- `AdfBuilder::start` / `AdfBuilder::end`: post-hoc reclassification (Approach B — locked in BC);
  at `End(TagEnd::List)`, inspect children for `taskItem`; if found, emit `"taskList"` and
  upgrade any plain `listItem` children to `taskItem { state: "TODO" }`.
- `normalize_list_item_content`: add `"taskList"` arm — each `taskItem`'s inline content
  wrapped in `paragraph` → `listItem` → new `bulletList`. NOT: `listItem > listItem` (INVALID ADF).
- **[REQUIRED — one-line fix, AC-008]** Panel arm's `wrap_inlines_as_blocks` allowlist
  (lines ~451–459): add `"taskList"` to the `&[…]` slice. Failure mode without this fix:
  `panel > paragraph > taskList` (INVALID ADF — Jira 400). `normalize_panel_content`'s
  catch-all already preserves the `taskList`; this allowlist add is the second required step
  to prevent it from being re-wrapped. Pinned by `test_task_list_in_panel_passes_through`.
- `normalize_blockquote_content` (new, or extend existing `wrap_inlines_as_blocks` path):
  unwrap `taskList` → each `taskItem`'s inline content becomes a `paragraph` in the blockquote.
- `is_empty_block_container`: add `"taskList"` and `"taskItem"` to the prune set. IMPORTANT:
  adding `"taskItem"` to `REQUIRES_CONTENT` is necessary but INSUFFICIENT (resolves F-P2-001).
  The existing predicate checks `c.is_empty()` (zero-length array). A `taskItem` with
  `content: [hardBreak]` has a non-empty array and would NOT be pruned by membership alone.
  Add a second "structurally-empty inline content" branch scoped ONLY to `"taskItem"`: treat
  as effectively empty when ALL content nodes are whitespace-only text nodes and/or `hardBreak`
  nodes with no other content. The structural-only `c.is_empty()` path for the 8 existing types
  MUST NOT change — `test_is_empty_block_container_membership` must still pass.
- `ListFrame`: add `Task` variant for indentation tracking in `adf_to_text`.
- `AdfRenderer::render_node`: add `"taskList"` (recurse with `ListFrame::Task`) and
  `"taskItem"` (`- [x] ` or `- [ ] ` + inline content) arms.
- **localId post-walk**: after `finish()`, before returning the final `doc` node, run a
  single DFS pre-order walk that assigns monotonically increasing 1-based counter strings
  (`"1"`, `"2"`, …) to all `taskList.attrs.localId` and `taskItem.attrs.localId` fields.
  Container node receives its ID before its children. Pruned nodes do not participate
  in the walk and do not consume counter slots. No `uuid` crate. Counter chosen for
  testability and pinned by `test_task_list_localid_dfs_preorder_assignment` (AC-018).
- **EC-16 flatten lifecycle (resolves F-P2-002)**: EC-16 inline-flattening (paragraph-strip,
  hardBreak-separator injection, leading/trailing hardBreak trim) MUST run INSIDE the
  `NodeKind::TaskItem` arm of `end()`'s `match kind` block (which fires on the
  `End(TagEnd::Item)` event — there is NO `match tag_end { TagEnd::Item => }` arm; the
  flatten logic lives in the `match kind` block), BEFORE the arm returns `Some(taskItem_node)`
  to the prune gate at ~line 608. Do NOT place the flatten in a post-`finish()` pass — that
  would invert EC-16-before-EC-8 ordering and produce a stray non-pruned taskItem for the
  both-empty input `"- [ ]\n\n  "` (see AC-015 both-empty sub-assertion).
- **hardBreak-only item prune**: `is_empty_block_container` must treat a `taskItem`
  containing only a `hardBreak` as empty (deliberate product choice; requires the new
  structurally-empty inline content branch — structural membership alone is insufficient).
  Pinned by `test_hardbreak_only_task_item_pruned` (AC-009).

Full implementation detail: `docs/specs/adf-task-list.md` (F4 deliverable).

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `AdfBuilder::process` (TaskListMarker arm) | `src/adf.rs` | Effectful (mutates builder state) | Flips in-progress listItem to taskItem candidate; captures TODO/DONE state |
| `AdfBuilder::start` / `AdfBuilder::end` (TaskList/TaskItem arms) | `src/adf.rs` | Effectful (mutates builder state) | Post-hoc reclassification at End(TagEnd::List); finalizes taskItem at End(TagEnd::Item) |
| `normalize_list_item_content` (new `"taskList"` arm) | `src/adf.rs` | Pure | Free function over `Vec<AdfNode>`; no I/O |
| `normalize_blockquote_content` (new pass or extension) | `src/adf.rs` | Pure | Free function over `Vec<AdfNode>`; no I/O |
| `is_empty_block_container` (new entries) | `src/adf.rs` | Pure | Constant string match; no I/O |
| `AdfRenderer::render_node` (taskList/taskItem arms) | `src/adf.rs` | Effectful (writes to output string) | Renders ADF node tree to text |
| localId DFS walk | `src/adf.rs` | Effectful (mutates ADF tree in-place) | Post-normalization pass; mutates `attrs.localId` on taskList/taskItem nodes |
| `markdown_to_adf` options block | `src/adf.rs` | Pure (parser construction) | Adds `ENABLE_TASKLISTS` to Options bitmask |

**Subsystem anchor justification:** No ARCH-INDEX subsystem applies — this is a single-file
pure transformation module (`src/adf.rs`) with no cross-subsystem interaction.

**Dependency anchor justification:** `depends_on: []` — issues #470, #472, #474, #483 are
fully merged; their code is present on `develop`. No story blocks this work. `blocks: []`
— no story depends on #471 task-list support.

## Edge Cases

> Note: The F1 delta analysis lists EC-1..EC-12 (an earlier subset). The BC body and this
> story are authoritative for the full EC-1..EC-16 list. Do not edit the delta analysis.

| ID | Source | Description | Expected Behavior | AC |
|----|--------|-------------|-------------------|----|
| EC-001 | BC-7.2.010 EC-1 | `[x]` vs `[ ]` TaskListMarker bool mapping | `true` → `"DONE"`, `false` → `"TODO"` (uppercase) | AC-001, AC-002 |
| EC-002 | BC-7.2.010 EC-2 | `[X]` uppercase recognized | `TaskListMarker(true)` → `state: "DONE"`; reverse renders as `[x]` (casing normalization, documented lossy) | AC-003 |
| EC-003 | BC-7.2.010 EC-3 | Mixed task + plain items in one list | Whole-container promotion: all items become `taskItem`; plain items get `state: "TODO"` | AC-004 |
| EC-004 | BC-7.2.010 EC-4 | Inline marks inside task item (`**bold**`, `_em_`, code, etc.) | All standard marks preserved; content goes directly in `taskItem.content` (no paragraph wrapper) | AC-005 |
| EC-005 | BC-7.2.010 EC-5 | Nested task list inside regular `listItem` | `normalize_list_item_content` `"taskList"` arm: `listItem > [bulletList > [listItem > paragraph]]` | AC-006 |
| EC-006 | BC-7.2.010 EC-6 | Task list inside `blockquote` | Unconditional normalization: `blockquote > [paragraph, ...]`; pulldown confirmed to emit `blockquote > taskList` | AC-007 |
| EC-007 | BC-7.2.010 EC-7 | Task list inside `panel` | No-op pass-through; `panel.content` permits `taskList`; catch-all handles it | AC-008 |
| EC-008 | BC-7.2.010 EC-8 | Empty task item (`- [ ]` no text) | Pruned by `is_empty_block_container`; test: `test_empty_task_item_pruned` | AC-009 |
| EC-009 | BC-7.2.010 EC-9 | All items pruned → empty `taskList` | `taskList` itself pruned (minItems: 1 violated); test: `test_empty_task_list_pruned` | AC-009 |
| EC-008b | BC-7.2.010 deliberate | hardBreak-only task item | Pruned (deliberate product choice — not schema-forced); test: `test_hardbreak_only_task_item_pruned` | AC-009 |
| EC-010 | BC-7.2.010 EC-10 | Round-trip stability | Stable modulo localId values; all lossy transforms documented (mixed-list, normalization, `[X]`→`[x]`, hardBreak) | AC-010 |
| EC-011 | BC-7.2.010 EC-11 | Native `hardBreak` inside task item | Schema-valid; renders as newline; round-trip lossy (bare newline re-parses as soft break) | AC-016 |
| EC-012 | BC-7.2.010 EC-12 | External ADF with lowercase `state: "done"` | Case-insensitive comparison: renders as `- [x] ` | AC-011 |
| EC-013 | BC-7.2.010 EC-13 | Nested task list (task-in-task) | Nested `taskList` placed as sibling AFTER parent `taskItem` in `taskList.content` (schema-required placement) | AC-012 |
| EC-014 | BC-7.2.010 EC-14 | Malformed bracket forms (`[]`, `[*]`, `[-]`, `[  ]`, etc.) | No `TaskListMarker` emitted by pulldown; stay as literal text in `bulletList` | AC-013 |
| EC-015 | BC-7.2.010 EC-15 | Plain list nested inside task item | Hoisted to grandparent block level (outside `taskList`); both `taskList.content` and `taskItem.content` forbid `bulletList` | AC-014 |
| EC-016 | BC-7.2.010 EC-16 | Multi-paragraph task item | Inline-flattening: paragraph wrappers stripped; `hardBreak` separator; leading/trailing hardBreaks trimmed; EC-16 runs before EC-8 prune | AC-015 |
| EC-017 | delta-analysis §5.1 | Pre-existing test `test_markdown_task_list_syntax_preserved_as_text` will fail | MUST be replaced (not deleted) with test asserting `taskList`/`taskItem` output | AC-017 |

## Test Coverage Summary

All tests are inline unit tests in `src/adf.rs::tests`. No new integration test files.
No E2E test (pure transformation-layer; no observable HTTP shape change visible to a live
Jira instance — valid ADF accepted by Jira Cloud REST API per JSDCLOUD-15228 evidence).

| Test name | BC clause | AC |
|-----------|-----------|-----|
| `test_markdown_task_list_emits_task_list_node` | BC-7.2.010 postcondition | AC-001, AC-017 (replacement) |
| `test_markdown_task_checked_item_emits_done_state` | BC-7.2.010 postcondition EC-1 | AC-002 |
| `test_markdown_task_uppercase_x_emits_done_state` | BC-7.2.010 postcondition EC-2; EC-10(f) | AC-003 (forward + reverse) |
| `test_markdown_mixed_task_plain_list_promotes_container` | BC-7.2.010 postcondition EC-3 | AC-004 |
| `test_markdown_task_item_inline_marks_preserved` | BC-7.2.010 postcondition EC-4 | AC-005 |
| `test_task_list_in_list_item_normalized_to_nested_bullet_list` | BC-7.2.010 obligation #1 EC-5; EC-10(b) | AC-006 |
| `test_task_list_in_blockquote_normalized_to_paragraphs` | BC-7.2.010 obligation #2 EC-6 | AC-007 |
| `test_task_list_in_panel_passes_through` | BC-7.2.010 obligation #3 EC-7; confirmed shape: panel > [taskList > taskItem*] | AC-008 |
| `test_empty_task_item_pruned` | BC-7.2.010 postcondition EC-8 | AC-009 |
| `test_empty_task_list_pruned` | BC-7.2.010 postcondition EC-9 | AC-009 |
| `test_hardbreak_only_task_item_pruned` | BC-7.2.010 deliberate product choice | AC-009 |
| `test_task_list_roundtrip_adf_to_text` | BC-7.2.010 postcondition EC-10 | AC-010 |
| `test_adf_to_text_external_lowercase_state` | BC-7.2.010 postcondition EC-12 | AC-011 |
| `test_nested_task_list_preserved` | BC-7.2.010 postcondition EC-13; reverse-path indentation | AC-012 |
| `test_malformed_task_markers_stay_literal_text` | BC-7.2.010 postcondition EC-14 | AC-013 |
| `test_task_item_with_nested_plain_list_hoists_block_sibling` | BC-7.2.010 obligation #4 EC-15 | AC-014 |
| `test_task_item_multi_paragraph_flattened_to_inline` | BC-7.2.010 postcondition EC-16; trim; ordering | AC-015 |
| `test_task_item_native_hardbreak_inline_is_roundtrip_lossy` | BC-7.2.010 postcondition EC-11 | AC-016 |
| `test_task_list_localid_dfs_preorder_assignment` | BC-7.2.010 Required attributes; DFS counter | AC-018 |

Total: 19 distinct test names present in `src/adf.rs::tests` after this story (1 replaces the
pre-existing `test_markdown_task_list_syntax_preserved_as_text`; net delta from baseline = +18).

Breakdown: 19 new named tests added, 1 old test name removed → net +18.
The 19 names are enumerated in the table above.

**Do NOT use a frozen integer as the expected count (resolves F-001/F-011).** The baseline at
story-authoring time was 155 (confirmed 2026-06-10: `grep -c '#\[test\]' src/adf.rs` on develop
= 155, reflecting PRs #483, #488, #490, #491 all merged). The target is NOT an absolute integer;
it is a delta: the implementer MUST verify the count increases by exactly +18 from the merge-base
baseline. At implementation time, run:
```
git merge-base develop HEAD | xargs git show | grep -c '#\[test\]'
```
or equivalently count on the unmodified file before adding tests. The final count will be
`<baseline> + 18`. Do not hardcode this target — future PRs may merge before F4 dispatch.

## Out of Scope (explicit)

**`uuid` crate dependency**: localIds use deterministic counter strings. No `uuid` crate is
added. This is a spec-locked decision (BC-7.2.010 §Required attributes).

**Live-sandbox verification of top-level `taskList` placement**: MEDIUM-HIGH confidence from
JSDCLOUD-15228 evidence; deferred per project needs-sandbox discipline. If sandbox reveals
top-level rejection, the safe fallback is a leading `paragraph` node.

**`code` mark + `subsup` coexistence**: A pre-existing limitation (same class as `**\`x\`**`);
not guarded here. Tracked as a follow-up from issue #474.

**Non-`src/adf.rs` changes**: No API, CLI, config, cache, types, or test-file changes outside
`src/adf.rs` (plus `docs/specs/adf-task-list.md` and `CLAUDE.md`).

## Dependency Analysis

**No dependency cycle introduced.** This story has `depends_on: []` and `blocks: []`.
It is a leaf node in the dependency graph.

Topological sort validation:
- S-471 has no incoming edges (depends_on: []).
- S-471 has no outgoing edges that cycle back.
- The dependency graph remains acyclic.

Wave placement: feature-followup (new story for feature in progress).

## Definition of Done

- [ ] All 18 ACs covered by passing inline unit tests in `src/adf.rs::tests` (AC-018 added
      for localId DFS preorder; AC-009 now pins 3 tests; AC-017 is review-verified/shares AC-001's
      test; 19 distinct test function names total in the test coverage table).
- [ ] `test_markdown_task_list_syntax_preserved_as_text` REPLACED (not deleted); replacement
      carries a comment explaining the behavior change.
- [ ] `cargo test` full tree green; `cargo clippy -- -D warnings` clean; `cargo fmt --all -- --check` clean.
- [ ] BC-7.2.010 authored in `bc-7-output-render.md`; all 8 count surfaces consistent
      (both `check-spec-counts.sh` and `check-bc-cumulative-counts.sh` pass).
- [ ] `docs/specs/adf-task-list.md` authored (design spec; follows `adf-panel-content-model.md` pattern).
- [ ] CLAUDE.md gotcha entry added for `"Markdown GFM task lists → ADF (adf.rs, issue #471)"`.
- [ ] `adf::tests` count increases by exactly **+18** from the merge-base baseline (NOT an
      absolute target — run `grep -c '#\[test\]' src/adf.rs` before and after; delta must be +18).
      At story-authoring time the baseline was 155; the net +18 delta is: 19 new test names
      added, 1 old test name (`test_markdown_task_list_syntax_preserved_as_text`) removed.
- [ ] No count-surface drift (DRIFT-001 / DRIFT-002 guards pass).
- [ ] Fresh-context adversarial review → clean (F5 pass).
- [ ] PR → develop; CI green; Copilot comments addressed.
- [ ] Live-Jira sandbox verification of produced shapes (needs-sandbox; deferred).

## Story Points and Effort

**3 story points** (same as S-483 and S-474 — same pattern class).

Breakdown:
- F3 story authoring: 0.5 SP
- F4 implementation (TDD — `todo!()` stubs + tests red, then green): 1.5 SP
- F5/F7 adversarial review + PR: 1 SP
