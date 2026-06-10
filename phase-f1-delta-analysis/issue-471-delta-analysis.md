---
document_type: delta-analysis
issue: 471
title: "feat(adf): support GFM task lists (- [ ] / - [x]) → ADF taskList/taskItem"
intent: enhancement
feature_type: backend
trivial_scope: false
routing: full-F2-F7
new_bcs:
  - BC-7.2.010 (proposed)
modified_bcs: []
regression_risk: MEDIUM
created: "2026-06-10"
---

# Phase F1 Delta Analysis — Issue #471

## Feature

**GitHub Issue #471:** `feat(adf): support GFM task lists (- [ ] / - [x]) → ADF taskList/taskItem`

Map GFM task-list syntax (`- [ ] …` / `- [x] …`) to ADF `taskList`/`taskItem` nodes in
`markdown_to_adf`, and render them back to GFM `- [ ]`/`- [x]` in `adf_to_text`.

---

## 1. Impact Boundary

### 1.1 Functions / Regions in `src/adf.rs`

All changes are confined to `src/adf.rs`. No other source files are affected.

| Region | Change Type | Detail |
|--------|-------------|--------|
| `markdown_to_adf` — options site (line 23–41) | MODIFIED | Add `Options::ENABLE_TASKLISTS` to the options bitmask |
| `NodeKind` enum (line 289–317) | MODIFIED | Add two variants: `TaskList` and `TaskItem { checked: bool }` |
| `AdfBuilder::start` — `Tag::List` arm (line 369) | MODIFIED | pulldown-cmark with ENABLE_TASKLISTS emits `Tag::List(None)` for task lists (same as bullet lists); the discriminator is `Event::TaskListMarker(bool)` arriving as the **first event inside** each `Tag::Item`. The `start` arm for `Tag::Item` must be changed: instead of immediately pushing `NodeKind::ListItem`, defer until after any leading `TaskListMarker` to know whether to push `NodeKind::TaskItem { checked }` instead. See §1.3 for the exact event-stream shape. |
| `AdfBuilder::process` — `_ => {}` catch-all (line 349) | MODIFIED | Add an arm `Event::TaskListMarker(checked) => self.on_task_list_marker(checked)` |
| `AdfBuilder::start` — `Tag::List(None)` arm (line 369) | MODIFIED | Must distinguish plain `BulletList` from a task list. See §1.3 — pulldown-cmark emits identical `Tag::List(None)` for both; the "this is a task list" signal is deferred to the first `TaskListMarker` inside a child item. The builder must either (a) emit `taskList` lazily (upgrade the BulletList → TaskList when the first TaskListMarker arrives), or (b) push `NodeKind::BulletList` initially and replace the finalized node type at `End(TagEnd::List)` time after seeing any TaskItem children. Option (a) is simpler: add a boolean `in_task_list` flag that is set by `on_task_list_marker` and checked in `End(TagEnd::List)` to emit `"taskList"` vs `"bulletList"`. |
| `AdfBuilder::end` — `NodeKind::BulletList` arm (line 474) | MODIFIED | Emit `"taskList"` when children contain `taskItem` nodes; otherwise emit `"bulletList"` as today. Simpler: add `NodeKind::TaskList` variant and push it from `start` when the **parent** list node knows it is a task list — but pulldown does not tell us in advance. See §1.3 for the precise approach. |
| `AdfBuilder::end` — new `NodeKind::TaskItem { checked }` arm | NEW | Emit `{ "type": "taskItem", "attrs": { "localId": "<uuid>", "state": "TODO"/"DONE" }, "content": [...] }`. The content model for `taskItem` is inline text only — no nested lists, code blocks, or block nodes. A `wrap_inlines_as_blocks`-style pass is NOT needed (task items contain only inline runs); emit content directly. |
| `AdfBuilder::end` — `NodeKind::TaskList` arm | NEW | Emit `{ "type": "taskList", "attrs": { "localId": "<uuid>" }, "content": [...] }` |
| `normalize_list_item_content` | UNCHANGED | Not called for `TaskItem` path (task items do not host nested block structures in practice); but see §4 EC-6 and §4 EC-7 for edge cases. |
| `normalize_panel_content` | POTENTIALLY MODIFIED | ADF panel content model explicitly allows `taskList` as a child (confirmed in BC-7.2.009 body: "permits … `taskList`/media/card/decision nodes"). Currently the `_ => out.push(child)` catch-all handles unknown types and will pass `taskList` through — this is already correct. No modification needed unless a normalize pass for `taskList`-inside-`panel` is required. Assessment: since `panel > taskList` is valid ADF, no normalization is needed. |
| `normalize_list_item_content` — `taskList` case | POTENTIALLY MODIFIED | ADF `listItem` content model does NOT permit `taskList` (permitted: `paragraph`, `bulletList`, `orderedList`, `codeBlock`, `mediaSingle`). If `- item\n  - [ ] nested task` produces a `listItem > taskList`, this is invalid ADF and must be normalized. The existing `normalize_list_item_content` `_ => out.push(child)` catch-all would pass it through incorrectly. A `"taskList"` arm must be added: unwrap or convert to `bulletList`. See §4 EC-5 for full edge-case treatment. |
| `is_empty_block_container` — `REQUIRES_CONTENT` array (line 745) | MODIFIED | Add `"taskList"` and `"taskItem"` to the prune set. An empty `taskList` (no items) is invalid ADF; an empty `taskItem` (no text) should be pruned or emitted with a placeholder. |
| `adf_to_text` — `AdfRenderer::render_node` (line 1006) | MODIFIED | Add arms for `"taskList"` and `"taskItem"`. `taskList` recurses into children with a task-list frame; `taskItem` emits `- [x] ` or `- [ ] ` based on `attrs.state == "DONE"`. Nesting (indentation) follows the same list-stack pattern as `bulletList`/`orderedList`. |
| `AdfRenderer::list_stack` / `ListFrame` enum (line 985) | MODIFIED | Add `ListFrame::Task` variant to track task-list context for indentation. |
| UUID generation | NEW | Both `taskList.attrs.localId` and `taskItem.attrs.localId` require UUID values. The codebase has no UUID dependency today. Options: (a) `uuid` crate — adds a new Cargo.toml dependency; (b) deterministic counter-based fake UUIDs (e.g., `"00000000-0000-0000-0000-000000000001"`) — acceptable for Jira Cloud REST API (it does not validate UUID format); (c) a simple incrementing counter formatted as a UUID-shaped string. This is an F2/F4 decision but must be flagged as a dependency choice. |

### 1.2 ADF Node Shape (Confirmed by Research)

Based on community examples, the Atlassian MCP server issue #25, and the ADF schema:

```json
{
  "type": "taskList",
  "attrs": { "localId": "<uuid>" },
  "content": [
    {
      "type": "taskItem",
      "attrs": { "localId": "<uuid>", "state": "TODO" },
      "content": [{ "type": "text", "text": "pending item" }]
    },
    {
      "type": "taskItem",
      "attrs": { "localId": "<uuid>", "state": "DONE" },
      "content": [{ "type": "text", "text": "done item" }]
    }
  ]
}
```

**Key confirmed facts:**
- `state` values are uppercase: `"TODO"` (unchecked) and `"DONE"` (checked). NOT `"todo"`/`"done"`.
- Both `taskList.attrs.localId` and `taskItem.attrs.localId` are required. Format is UUID-shaped.
- `taskItem` content is inline text nodes. No nested lists, code blocks, or rich block structure.
- `taskList` is a top-level block node — parallel to `bulletList`/`orderedList`.
- No `blockTaskItem` / `blockTaskList` variants exist in the current ADF spec.
- ADF REST API v3 (`POST /rest/api/3/issue`) accepts `taskList`/`taskItem` in `description`.
- `panel.content` explicitly allows `taskList` (per ADF schema and BC-7.2.009 body text).
- `listItem.content` does NOT permit `taskList` — this is a normalization obligation.
- `blockquote.content` does NOT permit `taskList` — normalization needed there too.

### 1.3 pulldown-cmark Event Stream for Task Lists

With `ENABLE_TASKLISTS`, the event stream for `- [x] done\n- [ ] todo` is:

```
Start(Tag::List(None))         -- same as a plain bullet list
  Start(Tag::Item)
    Event::TaskListMarker(true)   -- [x] → checked=true (fires BEFORE the item text)
    Event::Text("done")
  End(TagEnd::Item)
  Start(Tag::Item)
    Event::TaskListMarker(false)  -- [ ] → checked=false
    Event::Text("todo")
  End(TagEnd::Item)
End(TagEnd::List)
```

**Critical design implication:** `Tag::List(None)` arrives before any `TaskListMarker` event, so the builder cannot know at `Start(Tag::List)` time whether to push `NodeKind::BulletList` or `NodeKind::TaskList`. Two viable approaches:

- **Approach A (lazy upgrade):** Push `NodeKind::BulletList` initially; when first `TaskListMarker` arrives, mutate the top-of-stack node kind to `TaskList`. Clean and avoids lookahead.
- **Approach B (post-hoc reclassification):** In `end(TagEnd::List)`, check if any children are `taskItem` nodes; if so, emit `taskList` instead of `bulletList`. Avoids enum mutation but requires inspecting `children`.

Both approaches handle mixed lists (§4 EC-3) identically. Approach B is more aligned with the existing pattern (node kind is determined at End time). **Recommendation for F2/F4: Approach B** — consistent with how `NodeKind::HtmlBlock` accumulates text and decides on End.

`[X]` (uppercase) is recognized as checked by pulldown-cmark (case-insensitive per GFM spec); `TaskListMarker(true)` is emitted for both `[x]` and `[X]`.

---

## 2. Classification

| Field | Value |
|-------|-------|
| Intent | `enhancement` |
| Feature type | `backend` |
| Trivial scope | NO — new NodeKind variants, new ADF node type, UUID dependency decision, content-model normalization, reverse render path, existing test breakage |
| Routing | **Full F2-F7** |
| Severity | LOW (not a bug; enhancement) |

This follows the same classification pattern as #474 (subsup/heading-attrs, F2-F7) and #483 (GFM alerts, F2-F7). The BC corpus gains one new BC in §7.2 (BC-7.2.010).

---

## 3. Affected Artifacts

### 3.1 New BCs

**BC-7.2.010** (to be authored in F2): `markdown_to_adf` maps GFM task lists (`- [ ] …` / `- [x] …`) to ADF `taskList`/`taskItem` nodes with `state: "TODO"/"DONE"`; `adf_to_text` renders `taskList`/`taskItem` back to `- [ ]`/`- [x]`; task list inside `listItem` or `blockquote` is normalized (unwrapped/converted) before output.

This follows the §7.2 ADF Rendering subsection established by BC-7.2.006 through BC-7.2.009.

### 3.2 Modified BCs

None. No existing BC semantics change.

Cross-reference note: BC-7.2.003 ("ADF markdown round-trip covers: headings, lists, code blocks, blockquotes, tables, links") does not enumerate task lists, so it needs no body modification — but its trace should be updated to reference the new BC-7.2.010 as the task-list coverage anchor.

### 3.3 Affected Stories

| Story | Status | Relation |
|-------|--------|----------|
| S-483-adf-gfm-alerts-panel.md | implemented | Precedent pattern (GFM → ADF node type, content-model normalization, reverse path) |
| S-474-adf-minor-constructs.md | implemented | Precedent pattern (pulldown option flag → new NodeKind variants) |

**New story required:** `S-471-adf-task-lists.md` (to be authored in F3)

### 3.4 Affected Spec Files

| File | Change |
|------|--------|
| `.factory/specs/prd/bc-7-output-render.md` | Add BC-7.2.010; update §7.2 header count (9 → 10 individually-bodied BCs); update frontmatter `total_bcs` (88 → 89) |
| `CANONICAL-COUNTS.md` | Update bc-7 count |
| `BC-INDEX.md` | Add BC-7.2.010 row |
| `CLAUDE.md` | Add `"Markdown GFM task lists → ADF (adf.rs, issue #471)"` gotcha entry after the existing bare-URL entry |

No new NFR expected (consistent with #474 and #483).

### 3.5 New Spec File

`docs/specs/adf-task-list.md` — design spec for the task-list mapping (following the pattern of `docs/specs/adf-panel-content-model.md` for #483 and `docs/specs/adf-listitem-content-model.md` for #470).

---

## 4. Edge Cases for F2 / Test-Writer

The following edge cases must be enumerated in BC-7.2.010 and covered by tests:

| ID | Edge Case | Expected Behavior |
|----|-----------|-------------------|
| EC-1 | `[x]` checked vs `[ ]` unchecked | `TaskListMarker(true)` → `state: "DONE"`, `TaskListMarker(false)` → `state: "TODO"` |
| EC-2 | `[X]` uppercase | pulldown emits `TaskListMarker(true)` for `[X]`; result is `state: "DONE"`. Round-trip renders as `[x]` (lowercase). |
| EC-3 | Mixed task + non-task items in one list | pulldown-cmark emits `TaskListMarker` only for items that have the checkbox syntax; a plain `- item` within the same list does NOT produce a `TaskListMarker`. The builder must handle a list that has some `TaskItem` and some plain `ListItem` children. F2 must define: (a) if ANY item has a marker, the container becomes `taskList`; plain items become `taskItem { state: "TODO" }` with their text but no checkbox state — this is the least-bad interpretation. Or (b) fall back to `bulletList` with `[x]`/`[ ]` as literal text for the mixed case. **Open design question — must be resolved in F2.** |
| EC-4 | Task item with inline marks (`- [x] **bold** item`) | `TaskListMarker(true)` fires before the inline content. Marks (`strong`, `em`, `link`, `code`) on the text nodes inside a `taskItem` must be preserved. |
| EC-5 | Nested task list inside a regular list item (`- outer\n  - [ ] inner`) | pulldown-cmark emits a `List(None) > Item > TaskListMarker` nested inside an outer `Item`. The inner list produces a `taskList` node. ADF `listItem.content` does NOT permit `taskList`. `normalize_list_item_content` must gain a `"taskList"` arm: convert to a `bulletList`-equivalent or unwrap task items to plain list items. **Normalization obligation.** |
| EC-6 | Task list inside a `blockquote` (`> - [ ] item`) | ADF `blockquote.content` does NOT permit `taskList`. The blockquote's children go through `wrap_inlines_as_blocks` but NOT through a dedicated normalize pass. A `normalize_blockquote_content` pass may be needed, OR the existing `normalize_list_item_content` logic extended to handle the blockquote container. **Normalization obligation — confirm with F2.** |
| EC-7 | Task list inside a `panel` (`> [!NOTE]\n> - [ ] item`) | ADF `panel.content` DOES permit `taskList`. No normalization needed; `taskList` passes through `normalize_panel_content`'s `_ => out.push(child)` arm correctly. |
| EC-8 | Empty task item (`- [ ]` with no text) | pulldown-cmark emits `TaskListMarker(false)` followed by no `Text` events. The `taskItem` has empty content. ADF may reject empty `taskItem.content`. Decision: add `taskItem` to `is_empty_block_container` prune set, OR insert a placeholder empty text node. **Confirm in F2.** |
| EC-9 | Empty task list (a list containing only empty items, all pruned) | If all `taskItem` children are pruned, the containing `taskList` becomes empty. `is_empty_block_container` must include `"taskList"` to prune it. |
| EC-10 | Round-trip stability (`adf_to_text` → `markdown_to_adf`) | A `taskList` rendered by `adf_to_text` to `- [ ] …` / `- [x] …` must re-parse to identical ADF (modulo UUID values which are non-deterministic). |
| EC-11 | `taskItem` with `hardBreak` node | pulldown-cmark may emit `HardBreak` inside a task item (e.g., `- [ ] line1\\\nline2`). ADF `hardBreak` inside a `taskItem` — confirm schema allows it. If not, normalize to a space. |
| EC-12 | `adf_to_text` on externally-authored `taskList` with `state: "done"` (lowercase) | External ADF payloads may use lowercase. `adf_to_text` should handle both `"DONE"` and `"done"` in the state comparison (case-insensitive render). |

---

## 5. Regression Risk

**Risk Level: MEDIUM**

### 5.1 Existing Test That Will Break (MANDATORY UPDATE IN F4)

One existing test is a direct regression pin that asserts the current (pre-#471) behavior and MUST be updated when `ENABLE_TASKLISTS` is added:

**`test_markdown_task_list_syntax_preserved_as_text`** (line 2455–2489 in `src/adf.rs`)

This test explicitly documents the current behavior: `ENABLE_TASKLISTS is not set, so [x] renders as literal text inside a bullet item`. It asserts that `- [x] done task\n- [ ] pending task` produces a `bulletList` with `[x]`/`[ ]` appearing in the text content.

When `ENABLE_TASKLISTS` is added, this test will fail because pulldown-cmark will parse the checkboxes as `TaskListMarker` events instead of literal text. The test must be replaced with a new test asserting the `taskList`/`taskItem` output shape. The new test name must follow the `test_<verb>_<subject>_<expected_outcome>` convention (e.g., `test_markdown_task_list_emits_task_list_node` / `test_markdown_task_checked_item_emits_done_state`).

This is the exact analog of `#474`'s `test_markdown_double_tilde_still_strikethrough_not_subscript` reassignment (double-tilde behavior after `ENABLE_SUBSCRIPT` was added). The pre-existing test must be updated — not silently deleted — with a comment explaining what changed and why.

### 5.2 Other Regression Surfaces

| Surface | Risk | Notes |
|---------|------|-------|
| `test_markdown_task_list_syntax_preserved_as_text` | HIGH — will fail | Must be updated in F4 |
| Existing bullet list tests (`bulletList` output) | LOW | Unaffected — plain `- item` lists emit no `TaskListMarker`; `Tag::List(None)` without any `TaskListMarker` children stays a `bulletList` |
| Footnote / subsup / GFM alert tests | LOW | No interaction with task list parsing |
| `adf_to_text` tests for `bulletList` / `orderedList` | LOW | New `TaskList` frame in `list_stack` is additive; existing frames untouched |
| `normalize_list_item_content` tests | LOW-MEDIUM | If a `taskList` arm is added to the normalize function, existing normalization paths are unaffected |
| `is_empty_block_container` tests | LOW | Additive constant entries |

---

## 6. Open Questions / F1 Gate Items

### OQ-1 (CRITICAL — Node Shape): `taskList` vs `blockTaskItem`
**Status:** RESOLVED by research.
`blockTaskItem` / `blockTaskList` do NOT exist in the current ADF spec. The canonical node types are `taskList` (container) and `taskItem` (item). State values are uppercase `"DONE"` / `"TODO"`. Both require `localId` UUID attrs. No blockers on node shape.

### OQ-2 (DESIGN): UUID Generation Strategy
`taskList.attrs.localId` and `taskItem.attrs.localId` are required by the ADF schema. The codebase has no UUID crate dependency.

**Options:**
- (a) Add `uuid` crate (`uuid = { version = "1", features = ["v4"] }`) — idiomatic, UUID v4 random.
- (b) Use a deterministic counter (e.g., `"00000000-0000-0000-0000-{counter:012}"`) — no new dependency, deterministic in tests, sufficient for Jira Cloud REST (which does not validate UUID uniqueness or format).
- (c) Use `format!` with a thread-local counter.

Option (b) is recommended for simplicity and testability (deterministic IDs enable snapshot tests). Must be decided in F2 before F4 implementation. **Requires human decision if the `uuid` crate is preferred.**

### OQ-3 (DESIGN): Mixed task + non-task items in one list (EC-3)
When a list has both `- [ ] task item` and `- plain item`, the builder sees `TaskListMarker` for some items but not others. ADF does not permit mixing `listItem` and `taskItem` inside the same `taskList`. Options:

- (a) If ANY item has a marker → entire container becomes `taskList`; plain items become `taskItem { state: "TODO" }`.
- (b) Only items with markers become `taskItem`; plain items become `listItem`; container becomes whichever was first (ambiguous).
- (c) Mixed list → emit as `bulletList`, treat `[x]`/`[ ]` as literal text for plain items.

Must be resolved in F2 with a clear BC-level decision. Recommend (a) for simplicity.

### OQ-4 (NORMALIZATION): Task list inside `blockquote`
ADF `blockquote.content` does not permit `taskList`. The current code does not normalize blockquote children. If `> - [ ] item` parses to `blockquote > taskList`, this produces invalid ADF. Confirm whether pulldown-cmark actually emits this structure and whether a normalize pass is needed. **F2 must address.**

### OQ-5 (NORMALIZATION): Task list inside `listItem`
`normalize_list_item_content` must gain a `"taskList"` arm. Define the normalization behavior: convert to `bulletList` (each `taskItem` → `listItem`) or unwrap `taskItem` children directly. **F2 must specify.**

### OQ-6 (SCHEMA CONFIRMATION): `taskItem` content model
Research indicates `taskItem.content` is inline text only. Confirm whether `hardBreak` nodes inside a task item are valid ADF. If not, the builder must convert them to spaces. This affects EC-11.

---

## 7. Impact Assessment Table

| Artifact | Change Type | Notes |
|----------|-------------|-------|
| `src/adf.rs` | MODIFIED | Single file, ~6 regions |
| `NodeKind` enum | MODIFIED | +2 variants: `TaskList`, `TaskItem { checked: bool }` |
| `AdfBuilder::process` | MODIFIED | New `TaskListMarker` arm |
| `AdfBuilder::start` | MODIFIED | `Tag::Item` arm update |
| `AdfBuilder::end` | MODIFIED | New `TaskList` and `TaskItem` finalization arms |
| `normalize_list_item_content` | MODIFIED | Add `"taskList"` arm |
| `is_empty_block_container` | MODIFIED | Add `"taskList"`, `"taskItem"` to prune set |
| `AdfRenderer::render_node` | MODIFIED | Add `"taskList"`, `"taskItem"` arms |
| `ListFrame` enum | MODIFIED | Add `Task` variant |
| `Cargo.toml` | POSSIBLY MODIFIED | Only if `uuid` crate chosen (OQ-2) |
| `bc-7-output-render.md` | MODIFIED | +1 BC (BC-7.2.010) |
| `BC-INDEX.md` | MODIFIED | +1 row |
| `CANONICAL-COUNTS.md` | MODIFIED | bc-7 count +1 |
| `CLAUDE.md` | MODIFIED | New gotcha entry |
| `docs/specs/adf-task-list.md` | NEW | Feature spec |

**Files NOT changed (regression baseline):**
- `src/api/` — no API layer changes
- `src/cli/` — no CLI changes
- `src/types/` — no type changes
- `src/cache.rs`, `src/config.rs`, `src/output.rs` — no changes
- `tests/` (integration tests) — no existing integration tests touch `adf.rs`; new tests will be added inline in `src/adf.rs::tests`
- All `bc-*.md` files except `bc-7-output-render.md`

---

## 8. Routing Decision

**Full F2-F7 cycle.** Justification:
- New BC required (BC-7.2.010)
- New NodeKind variants and ADF node types
- Content-model normalization obligations in multiple code paths
- UUID generation dependency decision
- Existing test `test_markdown_task_list_syntax_preserved_as_text` will fail and must be replaced
- Multiple open design questions (OQ-2 through OQ-6) require spec resolution before implementation
- Consistent with the #474 and #483 precedent cycles which both ran full F2-F7

**Estimated story points:** 3 (same as S-483). Medium complexity — new node types, normalization, reverse path, one breaking test — but entirely within `src/adf.rs`.

---

## 9. F2 Pre-conditions

Before F2 can begin, the following must be resolved:

1. **OQ-2 (UUID strategy)** — human decision or default to deterministic counter approach.
2. **OQ-3 (mixed list behavior)** — design decision, recommend option (a).
3. **OQ-4 (blockquote normalization)** — needs empirical pulldown-cmark test to confirm event stream; if `blockquote > taskList` is produced, normalization is needed.

All other open questions can be resolved during F2 spec authoring.
