---
context: bc-7
title: "Output Rendering & Error"
total_bcs: 89   # cumulative claim (incl. range-collapsed); definitional_count below is individually-bodied headings; +4 added 2026-05-08 (BC-7.4.013-016, Fix-PR A); +1 added 2026-06-08 (BC-7.2.006, issue #470 listItem content-model conformance); +2 added 2026-06-08 (BC-7.2.007..008, issue #474 markdown subsup + heading-attr); +1 added 2026-06-09 (BC-7.2.009, issue #483 GFM alerts → panel); +1 added 2026-06-10 (BC-7.2.010, issue #471 GFM task lists → taskList/taskItem)
definitional_count: 43   # count of `#### BC-` headings in this file
last_updated: 2026-06-10
source_pass: 4
trace: |
  - L2: .factory/specs/domain-spec/bc-07-output-render.md
  - Source broad: .factory/semport/jira-cli/jira-cli-pass-3-behavioral-contracts.md §2.12-2.13
  - Source R4: .factory/semport/jira-cli/jira-cli-pass-3-deep-r4.md §3.5-3.6
---

# BC-7 — Output Rendering & Error

89 behavioral contracts across 5 subdomains: Table/JSON output (7.1), ADF rendering (7.2),
Error display (7.3), JSON output shapes (7.4), Observability (7.5). (+4 BC-7.4.013-016 added 2026-05-08 by Fix-PR A for auth JSON shapes. +1 BC-7.2.006 added 2026-06-08 by issue #470 listItem content-model conformance. +2 BC-7.2.007..008 added 2026-06-08 by issue #474 markdown subsup + heading-attr. +1 BC-7.2.009 added 2026-06-09 by issue #483 GFM alerts → panel. +1 BC-7.2.010 added 2026-06-10 by issue #471 GFM task lists → taskList/taskItem.)

---

## Subdomains

### 7.1 Table / JSON Output

#### BC-7.1.001: `--output table` uses comfy-table renderer; `--output json` emits structured JSON

**Confidence**: HIGH
**Source**: `src/output.rs::tests`; integration tests using `--output json`
**Subject**: Output rendering
**Behavior**: Default is `table`. Integration test pattern: assert `serde_json::from_str(&stdout)` parses. Table uses comfy-table crate.
**Trace**: Pass 3 BC-1101

---

#### BC-7.1.002: `--no-color` and `NO_COLOR` env disable ANSI escape sequences

**Confidence**: HIGH
**Source**: `src/main.rs:13-15`; colored crate
**Trace**: Pass 3 BC-1102

---

#### BC-7.1.003: `--no-input` auto-enables when stdin is not a TTY (`IsTerminal` check)

**Confidence**: HIGH
**Source**: `src/main.rs:18-23`
**Subject**: Output rendering
**Behavior**: Auto-set on pipes / AI agents / scripts. Every command must have fully non-interactive flag equivalents.
**Trace**: Pass 3 BC-1103

---

#### BC-7.1.004: Truncation hint emitted to stderr (NOT stdout); `--all` suppresses hint

**Confidence**: HIGH
**Source**: `tests/sprint_commands.rs:97-100, 175-179`
**Subject**: Output rendering
**Behavior**: stderr line: `"Showing N results"`. With `--all`: NO hint. Used by issue list, sprint current, board view.
**Trace**: Pass 3 BC-1110, BC-1111

---

#### BC-7.1.005: `--output json` error shape: `{"error": "<message>", "code": <exit>}` to stderr

**Confidence**: MEDIUM
**Source**: `src/main.rs:34-49`
**Subject**: Output rendering
**Behavior**: When `--output json` is active AND an error occurs, stderr gets JSON error envelope.
**Trace**: Pass 3 BC-1208 (error handling context)

---

### 7.2 ADF Rendering (10 individually-bodied BCs: BC-7.2.001..010; 56 BCs cumulative including range-collapsed)

#### BC-7.2.001: `text_to_adf("hello")` emits `{type:"doc", version:1, content:[{type:"paragraph", content:[{type:"text", text:"hello"}]}]}`

**Confidence**: HIGH
**Source**: `src/adf.rs::tests` (unit tests covering text→ADF, markdown→ADF, ADF→text variants)
**Subject**: Output rendering
**Behavior**: Standard ADF doc shape. Version is always 1.
**Trace**: Pass 3 BC-1104

---

#### BC-7.2.002: `markdown_to_adf("**bold**")` emits marks `[{type:"strong"}]` on the text node

**Confidence**: HIGH
**Source**: `src/adf.rs::tests`
**Trace**: Pass 3 BC-1105

---

#### BC-7.2.003: ADF markdown round-trip covers: headings, lists, code blocks, blockquotes, tables, links

**Confidence**: HIGH
**Source**: `src/snapshots/jr__adf__tests__markdown_complex_to_adf.snap` (330-line snapshot)
**Subject**: Output rendering
**Behavior**: Canonical complex doc → ADF snapshot. Round-trip canary; specific bytes pinned.
**Trace**: Pass 3 BC-1117 (R4); `tests/e2e_live.rs::test_e2e_adf_read_path_human_output` (first live E2E exercise of ADF read path via `jr issue view` human mode — AC-1, issue #475); `tests/e2e_live.rs::test_e2e_markdown_description_produces_heading_node` (formerly `test_e2e_issue_markdown_description_roundtrip` — renamed issue #475 AC-4 to reflect forward-only markdown→ADF assertion)

---

#### BC-7.2.004: ADF→text rendering: table render, code, headings preserved; lossy nodes (mention/emoji/inlineCard/media) silently dropped

**Confidence**: HIGH
**Source**: `src/adf.rs::tests`; `src/snapshots/jr__adf__tests__adf_to_text_complex.snap` (18-line snapshot)
**Subject**: Output rendering
**Behavior**: `_` fall-through arm at `adf.rs:531-540` silently drops unsupported nodes (documented per #202 spec). NFR-O-A (MEDIUM): ADF lossy nodes in text mode.
**Trace**: Pass 3 BC-1106; BC-1116 (R4); `tests/e2e_live.rs::test_e2e_adf_read_path_human_output` (first live E2E exercise of `adf_to_text` — via `cli/issue/view.rs` human mode AC-1 and `cli/issue/comments.rs` human mode AC-3, issue #475)

---

#### BC-7.2.005: `markdown_to_adf("**bold text**")` body on wire: `marks: [{type: "strong"}]`; `text` is `"bold text"` NOT `"**bold text**"`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:647-687`
**Behavior**: Wire-level pin; markdown fully converted before HTTP.
**Trace**: Pass 3 BC-1056 (R4)

---

#### BC-7.2.006: `markdown_to_adf` produces only permitted child node types inside any `listItem` — `blockquote`, `heading`, `table`, and `rule` are normalized before output

**Confidence**: HIGH
**Source**: `src/adf.rs::normalize_list_item_content`; `src/adf.rs::flatten_table_to_paragraphs`; listItem unit tests in `src/adf.rs::tests`; `docs/specs/adf-listitem-content-model.md`
**Subject**: Output rendering
**Behavior**: The ADF `listItem` content model permits exactly five child node types: `paragraph`, `bulletList`, `orderedList`, `codeBlock`, `mediaSingle`. `markdown_to_adf` calls `normalize_list_item_content` on every `listItem` before `wrap_inlines_as_blocks`, applying four normalizations:
1. **`blockquote`** — unwrapped recursively; child block nodes are spliced inline in place of the `blockquote` node.
2. **`heading`** — converted to `paragraph`; inline content and marks are preserved exactly; the `level` attribute is dropped.
3. **`table`** — flattened by `flatten_table_to_paragraphs` to one `paragraph` per `tableRow` in `| a | b |` form; cell inline marks are preserved as real ADF marks (NOT via a lossy `adf_to_text` round-trip).
4. **`rule` (horizontal rule)** — dropped entirely; no replacement node emitted.

After normalization, no `listItem` in the output document contains any node type outside the five permitted types. This invariant holds recursively — nested lists whose items receive disallowed node types from nested markdown are also normalized.

**Edge cases**:
- A `blockquote` nested inside another `blockquote` inside a `listItem` is unwrapped recursively until all blockquote wrappers are removed.
- A `table` inside a `listItem` that contains cells with bold, italic, code, or link marks: cell paragraph nodes carry those marks as first-class ADF marks, not plain text with markdown syntax characters.
- A `rule` that is the only child of a `listItem`: after dropping the rule the `listItem` has no children; `wrap_inlines_as_blocks` subsequently wraps it in an empty `paragraph` to keep the list item structurally valid.
- A `listItem` containing only permitted node types (the common case): `normalize_list_item_content` is a no-op; output is byte-for-byte identical to pre-normalization behavior.

**Trace**: `src/adf.rs::normalize_list_item_content`; `src/adf.rs::flatten_table_to_paragraphs`; `src/adf.rs::tests` (listItem normalization unit tests); `docs/specs/adf-listitem-content-model.md`; issue #470 / PR #477; `tests/e2e_live.rs::test_e2e_adf_read_path_human_output` (first live E2E exercise of `normalize_list_item_content` — blockquote-in-listItem normalization sub-case AC-2, issue #475)

---

#### BC-7.2.007: `markdown_to_adf` maps `^x^`→`subsup` sup and `~x~`→`subsup` sub; double-tilde `~~x~~` stays `strike`

**Confidence**: HIGH
**Source**: `src/adf.rs::tests` (`test_markdown_superscript_to_subsup_sup`, `test_markdown_subscript_to_subsup_sub`, `test_markdown_intraword_superscript_stays_literal`, `test_markdown_double_tilde_still_strikethrough_not_subscript`, `test_render_subsup_mark_reverse_path`, `test_subsup_markdown_to_text_roundtrip`, `test_subsup_composes_with_strong`, `test_markdown_strike_sub_sup_coexist`, `test_markdown_nested_sub_in_sup_dedupes_subsup_mark`, `test_markdown_nested_sub_in_sup_keeps_outer_sup`, `test_markdown_superscript_no_mark_leak_to_trailing_text`)
**Subject**: Output rendering
**Behavior**: `markdown_to_adf` enables `Options::ENABLE_SUPERSCRIPT | Options::ENABLE_SUBSCRIPT`. The `AdfBuilder` handles the new pulldown-cmark events as follows:
- `Tag::Superscript` → `push_mark({"type":"subsup","attrs":{"type":"sup"}})` — text wrapped in `^…^` emits a `subsup` mark with `attrs.type = "sup"` on every text node inside the span.
- `Tag::Subscript` → `push_mark({"type":"subsup","attrs":{"type":"sub"}})` — text wrapped in single-tilde `~…~` emits a `subsup` mark with `attrs.type = "sub"`.
- Enabling `ENABLE_SUBSCRIPT` reassigns single-tilde `~x~` from strikethrough to subscript. Double-tilde `~~x~~` continues to produce `Tag::Strikethrough` → `strike` mark — this disambiguation is a load-bearing tokeniser behaviour of pulldown-cmark 0.13 pinned by `test_markdown_double_tilde_still_strikethrough_not_subscript`.
- **Deduplication (`dedup_marks_by_type`)**: ADF ProseMirror requires that each mark type appears at most once per text node. `dedup_marks_by_type` (a free function) filters `active_marks` to the first occurrence of each `type` value before emitting any text node. It is applied at both `push_text` and `push_code`. For nested same-type spans such as `^a ~b~ c^`, the inner text node `b` would otherwise carry two `subsup` marks (one sup from the outer `^`, one sub from the inner `~`); after dedup it carries exactly one `subsup` mark (first-wins, so `sup` (the outer span) in that specific nesting).
- **Reverse path (`adf_to_text`)**: The `apply_marks` function gains a `"subsup"` arm. If `attrs.type == "sub"`, the rendered text is wrapped as `~{text}~`; otherwise (sup or missing `type`) it is wrapped as `^{text}^`. This makes the markdown→ADF→text round-trip lossless for content that became a `subsup` mark (standalone `^x^` and `~x~`); intraword forms that never became a mark (EC-1) are out of scope of this guarantee — `^sup^` round-trips to `^sup^` and `~sub~` round-trips to `~sub~`.

**Edge cases**:
- **(EC-1) Intraword caret stays literal**: pulldown-cmark does not open a `Tag::Superscript` when `^` is immediately adjacent to a preceding word character. `mc^2^` produces literal text `mc^2^` with no `subsup` mark. Use `mc ^2^` (space before `^`) to produce a superscript. Pinned by `test_markdown_intraword_superscript_stays_literal`.
- **(EC-2) `code` mark cannot coexist with `subsup` on one text node**: ADF schema forbids the `code` mark alongside `subsup`, `em`, `strong`, or `strike` on the same text node. `` ^`x`^ `` (superscript wrapping a code span) would produce a node with both `code` and `subsup` marks, which Jira rejects with HTTP 400. This is an accepted known limitation in the same class as `` **`x`** `` (pre-existing); not guarded here, tracked as a follow-up.
- **(EC-3) Dedup is first-wins**: when two spans of the same type are nested (e.g., `^a ~b~ c^`), the first `subsup` mark encountered for a given text node is kept. The result is deterministic and consistent regardless of nesting depth.
- **(EC-4) Footnote marker interaction is inert**: `push_footnote_marker` (from issue #472) bypasses the dedup'd text-emission path entirely — it appends an unmarked text node directly via `append_child` without going through `push_text`, so `dedup_marks_by_type` is never called on that path. No interaction.

**Trace**: `src/adf.rs::markdown_to_adf` (Options block); `src/adf.rs::AdfBuilder::start` (Superscript/Subscript arms); `src/adf.rs::push_text` (dedup call); `src/adf.rs::push_code` (dedup call); `src/adf.rs::dedup_marks_by_type`; `src/adf.rs::apply_marks` (subsup arm); `src/adf.rs::tests` (`test_markdown_superscript_to_subsup_sup`, `test_markdown_subscript_to_subsup_sub`, `test_markdown_intraword_superscript_stays_literal`, `test_markdown_double_tilde_still_strikethrough_not_subscript`, `test_render_subsup_mark_reverse_path`, `test_subsup_markdown_to_text_roundtrip`, `test_subsup_composes_with_strong`, `test_markdown_strike_sub_sup_coexist`, `test_markdown_nested_sub_in_sup_dedupes_subsup_mark`, `test_markdown_nested_sub_in_sup_keeps_outer_sup`, `test_markdown_superscript_no_mark_leak_to_trailing_text`); issue #474

---

#### BC-7.2.008: `markdown_to_adf` consumes heading attribute syntax `## Title {#id}` instead of leaking it into heading text

**Confidence**: HIGH
**Source**: `src/adf.rs::tests` (`test_markdown_heading_attributes_stripped`, `test_markdown_heading_non_attribute_brace_stripped`)
**Subject**: Output rendering
**Behavior**: `markdown_to_adf` enables `Options::ENABLE_HEADING_ATTRIBUTES`. Once enabled, pulldown-cmark parses and discards id (`{#id}`), class (`{.cls}`), key-value (`{key=val}`), and combined (`{#id .cls}`) attribute blocks that appear at the end of a heading line — they are consumed internally by the parser and never emitted as `Event::Text`. The `AdfBuilder` requires no code change: heading text events already pass through the standard text handler; the absence of attribute-syntax text events means those characters never enter the heading node's content. Result: `## Title {#id}` yields a heading node whose text is exactly `"Title"`, not `"Title {#id}"`. ADF headings have no id attribute; the parsed id, class, and key-value values are silently dropped with no ADF representation.

**Edge cases**:
- **(EC-1) Four attribute forms are all consumed**: `{#myid}`, `{.cls}`, `{#id .cls}`, `{key=val}` — all produce heading text equal to the heading title only, with zero leakage. Pinned by `test_markdown_heading_attributes_stripped`.
- **(EC-2) Any trailing `{...}` block is consumed and dropped regardless of content**: when `ENABLE_HEADING_ATTRIBUTES` is active, pulldown-cmark consumes ANY trailing `{...}` block at the end of an ATX heading — including blocks whose contents are not valid attribute syntax. `## Foo {bar}` (contents `bar` contain no `#`, `.`, or `=`) yields heading text `"Foo"`, NOT `"Foo {bar}"`. Pinned by `test_markdown_heading_non_attribute_brace_stripped`. Scope: tested for the trailing-brace case only; behaviour for mid-heading braces (e.g., `## Fo{o} bar`) is untested and not asserted here.
- **(EC-3) No ADF id field emitted**: ADF does not support heading ids; there is no `id` field in the heading node's `attrs`. The parsed id value is consumed and not stored anywhere in the output document.

**Trace**: `src/adf.rs::markdown_to_adf` (Options block — `ENABLE_HEADING_ATTRIBUTES`); `src/adf.rs::tests` (`test_markdown_heading_attributes_stripped`, `test_markdown_heading_non_attribute_brace_stripped`); issue #474

---

#### BC-7.2.009: `markdown_to_adf` maps GFM alerts (`> [!NOTE|TIP|IMPORTANT|WARNING|CAUTION]`) to ADF `panel`, normalizing the panel content model; `adf_to_text` renders `panel` back to an alert

**Confidence**: HIGH
**Source**: `src/adf.rs::panel_type_for`; `src/adf.rs::gfm_label_for_panel_type`; `src/adf.rs::normalize_panel_content`; `src/adf.rs::normalize_list_item_content` (panel arm); `src/adf.rs::is_empty_block_container` (panel in prune set); `src/adf.rs::tests` (panel mapping + reverse + round-trip unit tests); `docs/specs/adf-panel-content-model.md`
**Subject**: Output rendering
**Behavior**: `markdown_to_adf` enables `Options::ENABLE_GFM`. In pulldown-cmark 0.13 this gates only alert blockquotes (no side effect on the individually-set tables/strikethrough/footnotes/subsup/heading-attr flags). A tagged alert arrives as `Tag::BlockQuote(Some(BlockQuoteKind))` and maps to an ADF `panel` with a portable `panelType`; a plain `Tag::BlockQuote(None)` stays a `blockquote`.

Kind → panelType (`panel_type_for`, exhaustive match): Note→`info`, Tip→`success`, Important→`note`, Warning→`warning`, Caution→`error`. Only the five always-portable panelTypes are emitted; `tip`/`custom` are avoided (editor-feature-gated, inconsistent on Jira Cloud).

The ADF `panel` content model permits `paragraph`(no marks)/`heading`(no marks)/`bulletList`/`orderedList`/`codeBlock`/`rule`/`taskList`/media/card/decision nodes — but forbids nested `panel`, `table`, and `blockquote`. `normalize_panel_content` runs over every panel's children before `wrap_inlines_as_blocks`, applying: nested `panel` → unwrapped recursively (inner panelType discarded); `blockquote` → unwrapped recursively; `table` → flattened to one `paragraph` per row via `flatten_table_to_paragraphs` (marks preserved); `heading`/`paragraph` → kept with any node-level `marks` stripped. `normalize_list_item_content` gains a `panel` arm (alongside `blockquote`) that unwraps a panel inside a `listItem` (ADF `listItem` forbids `panel`). `panel` is added to `is_empty_block_container`'s prune set so an empty alert shell is removed (invalid ADF).

Reverse path: `adf_to_text` gains a `panel` arm mapping `panelType` back to a GFM label via `gfm_label_for_panel_type` (info→NOTE, success→TIP, note→IMPORTANT, warning→WARNING, error→CAUTION), rendering `> [!KIND]` followed by the `> `-quoted body (line-prefixing mirrors the `blockquote` arm). An unmapped panelType renders as a plain blockquote with no marker. The markdown→ADF→text round-trip is stable for the five alert kinds.

**Edge cases**:
- **(EC-1) Parser leniency**: pulldown 0.13 recognizes the marker with or without the leading space (`>[!NOTE]`) and is case-insensitive (`[!note]`/`[!Note]`). The only disqualifiers are trailing text on the marker line (`> [!NOTE] extra` → plain blockquote) and an unknown kind (`> [!FOO]` → plain blockquote). The renderer keys off `Some(kind)` only and never string-matches the marker text.
- **(EC-2) Nested alerts**: `> [!NOTE]\n> > [!TIP]` would produce `panel > panel` (invalid); the inner panel is unwrapped, its blocks spliced into the outer panel. No panel contains a nested panel.
- **(EC-3) Alert wrapping a table**: the table is flattened out of the panel (no `panel > table`).
- **(EC-4) Alert inside a list item**: `- x\n\n  > [!NOTE]` produces no `listItem > panel`; the panel is unwrapped in place.
- **(EC-5) Empty alert**: `> [!NOTE]` with no body yields an empty panel shell, pruned by `is_empty_block_container`.

**Trace**: `src/adf.rs::panel_type_for`; `src/adf.rs::gfm_label_for_panel_type`; `src/adf.rs::normalize_panel_content`; `src/adf.rs::normalize_list_item_content`; `src/adf.rs::is_empty_block_container`; `src/adf.rs::tests` (GFM alert panel mapping unit tests); `docs/specs/adf-panel-content-model.md`; issue #483

---

#### BC-7.2.010: `markdown_to_adf` maps GFM task lists (`- [ ] …` / `- [x] …`) to ADF `taskList`/`taskItem` nodes; state is uppercase `"TODO"`/`"DONE"`; localId is a counter-based deterministic string; `adf_to_text` renders `taskList`/`taskItem` back to `- [ ]`/`- [x]`; task list inside `listItem` or `blockquote` is normalized (unwrapped) before output

**Confidence**: HIGH on node shape (canonical `@atlaskit/adf-schema` `full.json` v40.9.2 and JSDCLOUD-15228 live acceptance); HIGH on blockquote-nested task list behavior (pulldown-cmark 0.13.3 primary source — `.factory/research/issue-471-pulldown-blockquote-tasklist.md`, F4-conditional resolved at spec time); MEDIUM-HIGH on top-level doc placement (single best sandbox-probe candidate — `doc_node` schema enumeration ambiguous vs JSDCLOUD-15228 evidence; live round-trip verification deferred per project needs-sandbox discipline)
**Source**: `src/adf.rs::markdown_to_adf` (ENABLE_TASKLISTS); `src/adf.rs::AdfBuilder` (TaskListMarker arm); `src/adf.rs::normalize_list_item_content` (taskList arm); `src/adf.rs::is_empty_block_container` (taskList/taskItem in prune set); `src/adf.rs::adf_to_text` (taskList/taskItem arms); `src/adf.rs::tests` (task-list unit tests); `docs/specs/adf-task-list.md`
**Subject**: Output rendering
**Behavior**: `markdown_to_adf` enables `Options::ENABLE_TASKLISTS`. With this option, pulldown-cmark 0.13 intercepts task-list syntax and emits `Event::TaskListMarker(bool)` as the first child event inside each `Tag::Item` that has a checkbox. `true` → `state: "DONE"` (checked); `false` → `state: "TODO"` (unchecked). Both `[x]` and `[X]` produce `TaskListMarker(true)` (pulldown is case-insensitive per GFM spec); the forward path renders as `[x]` (lowercase) on the reverse path. **Reverse-path state rule:** only `state: "DONE"` (matched case-insensitively) renders as `- [x] `; all other values (including `"TODO"` and absent/unrecognized state) render as `- [ ] `. The round-trip is stable for top-level task list structure modulo localId values and the lossy transforms enumerated in EC-10 — it is NOT unconditionally clean in both directions due to the asymmetric state rule and the normalization lossiness documented below.

**ADF node shape (canonical, from `@atlaskit/adf-schema` `full.json`):**
```json
{
  "type": "taskList",
  "attrs": { "localId": "1" },
  "content": [
    {
      "type": "taskItem",
      "attrs": { "localId": "2", "state": "TODO" },
      "content": [{ "type": "text", "text": "unchecked item" }]
    },
    {
      "type": "taskItem",
      "attrs": { "localId": "3", "state": "DONE" },
      "content": [{ "type": "text", "text": "checked item" }]
    }
  ]
}
```

**Required attributes (from `full.json` schema — HIGH confidence):**
- `taskList.attrs.localId`: required string; any non-empty string is schema-valid (no UUID format constraint; no schema-enforced uniqueness — uniqueness is RECOMMENDED to avoid renderer ambiguity, not schema-mandated per `@atlaskit/adf-schema` `full.json` v40.9.2 §2). **Assignment rule:** localIds are assigned in a **single post-normalization, post-pruning DFS pre-order walk** of the final ADF tree, using a monotonically increasing counter starting at `"1"`. The walk is decoupled from build/emit order — pruned nodes never consume a counter slot. Within the walk the container node is numbered before its children. The monotonic counter yields document-wide-unique localIds (uniqueness is recommended to avoid renderer ambiguity, not schema-enforced — see research §2) across the whole document, including nested task lists (EC-13). The worked example above (taskList=`"1"`, first taskItem=`"2"`, second taskItem=`"3"`) reflects this final-tree-walk order. Counter is 1-based monotonic (any non-empty string is schema-valid; 1-based chosen for internal consistency). No `uuid` crate dependency is added.
- `taskItem.attrs.localId`: required string; draws from the same final-tree-walk counter as `taskList` (not a separate counter).
- `taskItem.attrs.state`: required; enum `"TODO"` or `"DONE"` — **uppercase only** per `full.json` `"enum": ["TODO", "DONE"]`.
- `taskList.content`: `minItems: 1` — a `taskList` without at least one `taskItem` is schema-invalid; handled by the prune strategy (see EC-8/EC-9 below).
- `taskItem.content`: array of **inline nodes only** (`$ref: inline_node`). Content is placed directly in `taskItem.content` — NOT wrapped in a paragraph. This differs from `listItem` (which uses `paragraph` wrappers); `taskItem` holds text nodes and marks directly. `hardBreak` is an inline node and is schema-valid inside `taskItem`.

**Schema strictness note:** `taskList.attrs` and `taskItem.attrs` are `additionalProperties: false` — emit ONLY `localId` (and `state` for `taskItem`); any extra attribute key is schema-invalid and will cause Jira to return HTTP 400.

**Mixed task + non-task items in one list:** When a list contains both checkbox items (`- [ ] …`) and plain items (`- item`), pulldown emits `TaskListMarker` only for the checkbox items. The F1 gate decision (locked): if ANY item in the list has a `TaskListMarker`, the entire container becomes a `taskList`. Plain items (no `TaskListMarker`) become `taskItem` nodes with `state: "TODO"` — their text content is preserved as inline nodes in `taskItem.content`. ADF does not permit mixing `listItem` and `taskItem` in the same container, so the whole-container promotion rule is the only schema-valid interpretation.

**Builder mechanics (observable contract; full implementation detail in `docs/specs/adf-task-list.md`):** `Tag::List(None)` arrives before any `TaskListMarker` event, so the container type cannot be known at `Start(Tag::List)` time. Approach B (post-hoc reclassification): the builder initially treats the list as `BulletList`; at `End(TagEnd::List)` it inspects whether any children are `taskItem` nodes — if so, it emits `"taskList"` instead of `"bulletList"` and ensures all children are `taskItem` nodes (plain `listItem` children are upgraded to `taskItem { state: "TODO" }`). **TaskListMarker event ordering (pinned, all nesting contexts):** `Event::TaskListMarker(bool)` is **always the first child event after `Start(Tag::Item)`, before the item text** — in top-level lists, in lists nested inside `blockquote`, and in nested task lists. This ordering is guaranteed by `firstpass.rs::parse_paragraph(ix, Some(task_list_marker))` (pulldown-cmark 0.13.3 `firstpass.rs:128–160`; `parse.rs:2269`) — the scan is container-agnostic and the marker is emitted before the paragraph/text content in all contexts (`.factory/research/issue-471-pulldown-blockquote-tasklist.md`). A **single code path** captures the TODO/DONE state from `TaskListMarker` regardless of whether the enclosing `Tag::Item` is inside a blockquote or at the top level — no container-dependent ordering branch is needed. **TaskListMarker event consumption:** when `Event::TaskListMarker(bool)` fires, the builder flips the in-progress listItem into a `taskItem` candidate and captures the TODO/DONE state (`true` → `"DONE"`, `false` → `"TODO"`) for use when the item is finalized at `End(Tag::Item)`.

**Content-model normalization obligations:**
1. **`normalize_list_item_content` — `taskList` arm (REQUIRED)**: ADF `listItem.content` permits `paragraph`, `bulletList`, `orderedList`, `codeBlock`, `mediaSingle` — `taskList` is NOT permitted. A nested task list inside a regular list item (e.g., `- outer\n  - [ ] inner`) would produce `listItem > taskList`, which is invalid ADF. `normalize_list_item_content` must gain a `"taskList"` arm: the `taskList` is unwrapped — each `taskItem`'s inline content is wrapped in a `paragraph` to produce a `listItem`, and all resulting `listItem` nodes are collected into a new `bulletList` node. The correct ADF-valid output shape is `listItem > [bulletList > [listItem > paragraph, ...]]`. This parallels the existing `blockquote`-unwrap and `panel`-unwrap arms. (Note: producing `listItem > [listItem > paragraph]` without the intervening `bulletList` would be INVALID ADF — a `listItem` cannot directly contain a `listItem`.)
2. **`blockquote` content — `taskList` arm (REQUIRED)**: ADF `blockquote.content` does NOT permit `taskList`. pulldown-cmark 0.13.3 **does** emit `blockquote > taskList` for input `> - [ ] item` — confirmed by direct primary-source read of `firstpass.rs:128–160` and `parse.rs:2269` (`.factory/research/issue-471-pulldown-blockquote-tasklist.md`). The task-list scan runs inside the generic list-marker branch, gated only on `ENABLE_TASKLISTS` with no condition on enclosing container type; the blockquote `>` prefix is stripped on a prior loop iteration before the scan runs. Therefore the normalization arm is load-bearing and unconditional: the normalization pass must unwrap the `taskList` — each `taskItem`'s inline content becomes a `paragraph` inside the blockquote, producing `blockquote > [paragraph, ...]`. The same unwrap strategy as obligation #1 applies. Implementation note: `blockquote` children currently go through `wrap_inlines_as_blocks`; a dedicated `normalize_blockquote_content` pass or extension to the existing wrap logic is required. *(F4-conditional status resolved at spec time — see spec-changelog [1.3.5].)*
3. **`panel` content — `taskList` arm (NO-OP)**: ADF `panel.content` explicitly permits `taskList` (per BC-7.2.009 body). The existing `_ => out.push(child)` catch-all in `normalize_panel_content` passes `taskList` through correctly. No modification needed.
4. **`taskItem` block-content hoist (REQUIRED)**: `taskItem.content` is inline-only — it cannot hold a `bulletList`, `orderedList`, `taskList`, or any other block node. When a plain list is nested inside a task item (e.g., `- [ ] outer\n  - plain inner`), the nested list node is INVALID inside `taskItem.content`. The builder must hoist nested block content out to the **grandparent block level**: the task item's inline text content is preserved in `taskItem.content`; the nested list node is removed from the `taskList` context entirely and appended as a sibling node AFTER the parent `taskList` at the grandparent block level. Note: appending as a sibling INSIDE the parent `taskList.content` array would be INVALID — `taskList.content` permits only `taskItem` and `taskList` nodes, never `bulletList`. See EC-15.

**`is_empty_block_container` prune set:** `"taskList"` and `"taskItem"` are added to the prune set. An empty `taskList` (no items, or all items pruned) violates the `minItems: 1` schema constraint. A `taskItem` is prunable when its `content` array is **empty OR contains only structurally-empty inline content** (whitespace-only text nodes, text nodes that are empty after trimming whitespace and backslash characters, and/or bare `hardBreak` nodes with no other content) — see EC-8 for the hardBreak-only prune and the backslash-text prune, both of which are DELIBERATE PRODUCT CHOICES (not schema-forced). If all `taskItem` children of a `taskList` are pruned, the resulting empty `taskList` is subsequently pruned by the `"taskList"` entry. Reconciliation note: `taskItem` holds inline content (not block nodes), yet belongs in this prune set because the criterion is "empty or structurally-empty content array" — a `taskItem` with zero meaningful content nodes should not appear in the output regardless of whether the content model is block-level or inline-level. The function name (`is_empty_block_container`) refers to "container whose content array must be non-empty or non-trivially-populated"; `taskItem` qualifies on this criterion even though its content items are inline.

**Reverse path (`adf_to_text`)**: `AdfRenderer::render_node` gains arms for `"taskList"` and `"taskItem"`. `taskList` recurses into its children using a `ListFrame::Task` variant in the list stack (for indentation tracking, parallel to `ListFrame::Bullet` and `ListFrame::Ordered`). `taskItem` emits `- [x] ` (if `attrs.state` equals `"DONE"` case-insensitively) or `- [ ] ` (all other values including `"TODO"` and absent/unrecognized state), followed by the item's inline content. This makes the markdown→ADF→text round-trip stable for top-level task lists with TODO/DONE items, modulo localId values and the lossy transforms enumerated in EC-10.

**Note on live-sandbox verification**: The top-level placement of `taskList` as a direct child of `doc` is MEDIUM-HIGH confidence (see headline) — primary evidence from JSDCLOUD-15228 (official Atlassian ticket, accepted payload) but `doc_node` schema enumeration is ambiguous. Live round-trip verification (one sandbox POST + GET) is deferred per the project's needs-sandbox discipline. The implementation is safe to author against the HIGH-confidence node shape; sandbox confirmation is verification, not discovery. If sandbox reveals top-level rejection, the safe fallback is to place `taskList` after a leading `paragraph` node.

**Cross-reference**: BC-7.2.003 ("ADF markdown round-trip covers: headings, lists, code blocks, blockquotes, tables, links") does not enumerate task lists. BC-7.2.010 is the task-list coverage anchor. The pre-#471 test `test_markdown_task_list_syntax_preserved_as_text` (which asserted `- [x]`/`- [ ]` rendered as literal bullet-list text) must be replaced in F4 with a new test asserting `taskList`/`taskItem` output shape (parallel to the `#474` handling of `test_markdown_double_tilde_still_strikethrough_not_subscript`).

**Edge cases**:
- **(EC-1) `[x]` checked vs `[ ]` unchecked**: `TaskListMarker(true)` → `state: "DONE"`, `TaskListMarker(false)` → `state: "TODO"`. Uppercase-only output enforced regardless of ADF input casing.
- **(EC-2) `[X]` uppercase recognized**: pulldown-cmark emits `TaskListMarker(true)` for both `[x]` and `[X]` (GFM case-insensitive). The resulting ADF `state` is `"DONE"`. Round-trip via `adf_to_text` renders as `- [x] ` (lowercase only — the renderer does not re-emit `[X]`).
- **(EC-3) Mixed task + plain items in one list**: Any list containing at least one `TaskListMarker` produces a `taskList`. Plain items are promoted to `taskItem { state: "TODO" }`. Rationale: ADF prohibits mixed `listItem`/`taskItem` containers; whole-container promotion is the only schema-valid path. Plain items carry their text content as inline nodes exactly as a checked item would.
- **(EC-4) Inline marks inside a task item (`- [x] **bold** item`)**: `TaskListMarker(true)` fires before the inline content. Marks (`strong`, `em`, `link`, `code`, `subsup`, `strike`) on text nodes inside a `taskItem` are preserved exactly as in any other inline context. The `taskItem.content` inline model accommodates all standard inline marks.
- **(EC-5) Nested task list inside a regular list item (`- outer\n  - [ ] inner`)**: The inner `taskList` is normalized by `normalize_list_item_content`'s `"taskList"` arm — each `taskItem`'s inline content is wrapped in a `paragraph` to form a `listItem`, and all resulting `listItem` nodes are collected into a new `bulletList` node. The ADF-valid output shape is `listItem > [bulletList > [listItem > paragraph, ...]]`. Directly placing converted `listItem` nodes inside the outer `listItem` without the intervening `bulletList` would be INVALID ADF (a `listItem` cannot directly contain a `listItem`). No `taskList` node appears inside any `listItem` in the output.
- **(EC-6) Task list inside a `blockquote` (`> - [ ] item`)**: ADF `blockquote.content` forbids `taskList`. pulldown-cmark 0.13.3 **does** emit `blockquote > taskList` for `> - [ ] item` — confirmed by direct primary-source read of `firstpass.rs:128–160` (`.factory/research/issue-471-pulldown-blockquote-tasklist.md`). The scan is container-agnostic: the blockquote `>` prefix is stripped on a prior loop iteration; the task-list scan then operates on the post-prefix line content identically to the top-level case. The normalization arm is therefore **required and unconditional**: the normalization pass must unwrap the `taskList` — each `taskItem`'s inline content is promoted to a `paragraph` inside the blockquote, producing `blockquote > [paragraph, ...]`. No `taskList` node appears inside any `blockquote` in the output. `blockquote.content` permits `paragraph`, so this normalization output shape is ADF-valid.
- **(EC-7) Task list inside a `panel` (`> [!NOTE]\n> - [ ] item`)**: ADF `panel.content` permits `taskList` (confirmed per BC-7.2.009). No normalization needed; `taskList` passes through `normalize_panel_content`'s `_ => out.push(child)` arm unchanged.
- **(EC-8) Empty task item (`- [ ]` with no text)**: **After EC-16 inline-flattening is applied** (which runs first — see EC-16 ordering note), `"taskItem"` is in `is_empty_block_container`'s prune set; an empty `taskItem` is pruned before output. pulldown-cmark emits `TaskListMarker(false)` followed by no `Text` events → the `taskItem` has empty content and is pruned. A task item containing only whitespace text (e.g., `- [ ]   `) is treated identically — the whitespace-only text node is trimmed and if the resulting content array is empty, the `taskItem` is pruned. **Backslash-text case (`- [ ] \`):** In pulldown-cmark 0.13.3, a trailing backslash in a task item does NOT produce a `hardBreak` node — it produces a literal `Text("\\")` node (a single backslash character). This was confirmed during F4 implementation and the as-built behavior is authoritative (DOCUMENT-AS-IS). The `is_empty_block_container` structurally-empty-inline branch treats a `taskItem` whose content contains only text nodes that are empty after trimming whitespace and backslash characters as prunable — so `- [ ] \` results in a pruned task item. This is a DELIBERATE PRODUCT CHOICE: a backslash-only body carries no semantic content as a task item. **HardBreak-only case:** A task item containing only a bare `hardBreak` node and no other content is likewise pruned. **Note: both the backslash-text prune and the hardBreak-only prune are DELIBERATE PRODUCT CHOICES, not schema-forced — a lone `hardBreak` and a lone backslash `Text` node are each schema-valid ADF inline content. Both are pruned because they carry no semantic content as a task item body; these choices should not be "corrected" by a future implementer.** The prune criterion covering all four cases (evaluated after EC-16 flattening): `taskItem.content` is empty OR contains only structurally-empty inline content (whitespace-only text nodes, text nodes empty after trimming whitespace and backslashes, and/or bare hardBreaks with no substantive text).
- **(EC-9) Empty task list (all items pruned)**: If all `taskItem` children of a `taskList` are pruned (all were empty), the `taskList` itself becomes empty, violating `minItems: 1`. `"taskList"` is in `is_empty_block_container`'s prune set; the empty `taskList` is subsequently pruned.
- **(EC-10) Round-trip stability**: A **top-level task list with no normalization applied** rendered by `adf_to_text` to `- [ ] …`/`- [x] …` re-parses to semantically equivalent ADF (modulo `localId` values, which are per-document counter-assigned and not preserved through text form). Inline marks inside task items are stable across the round-trip. **Lossiness disclosures (deliberate — same class as BC-7.2.006/009 table/nesting lossiness) — all known lossy transforms enumerated:** (a) Mixed-list promotion (EC-3) is lossy: the plain-item identity is lost at markdown→ADF promotion; the round-trip cannot recover it (on re-parse the item becomes a real checkbox item, not a plain bullet). (b) `listItem` normalization (EC-5) is lossy: task items converted to plain `listItem` nodes lose their checkbox state; re-parsing the output produces a `bulletList`, not a `taskList`. (c) `blockquote` unwrapping (EC-6) is lossy: task items converted to paragraphs lose their checkbox state permanently. (d) Nested-plain-list hoist to grandparent (EC-15) is lossy: the visual association between the task item and its sub-list is broken — they become independent siblings at the grandparent level. (e) Multi-paragraph flattening (EC-16) is lossy: paragraph breaks become line breaks (hardBreaks); the semantic distinction between a paragraph boundary and a hard break is lost. (f) `[X]`→`[x]` casing normalization (EC-2) is a non-identity transform: original uppercase `[X]` is rendered as lowercase `[x]` on the round-trip; the exact input casing is not recoverable. (g) hardBreak-separator round-trip loss: a `hardBreak` node injected by EC-16's multi-paragraph flattening does NOT survive the round-trip through text form — a bare newline inside a `- [ ] ` line re-parses as a soft break or item terminator, not as a GFM hardBreak (which requires two trailing spaces or a backslash before the newline); the separator is permanently lost. (h) Ordered-task-list ordinal-numbering drop (EC-17): an ordered list containing GFM task markers (`1. [ ] item`) is promoted to `taskList`/`taskItem` identically to a bullet task list — but the original ordinal numbering (`1.`, `2.`, …) is permanently discarded because ADF has no ordered task-list node (`orderedList.content` permits only `listItem`, not `taskItem`). Checkbox state is preserved; ordinal position is not recoverable from the output.
- **(EC-11) `taskItem` with `hardBreak` node**: `hardBreak` is an inline node (per `@atlaskit/adf-schema` `inline_node` definition) and is schema-valid inside `taskItem.content`. The builder emits `hardBreak` nodes inside `taskItem` the same way it does inside paragraphs. `adf_to_text` renders a `hardBreak` inside a task item as a newline continuation of the item line. **Round-trip is LOSSY** (cross-reference EC-10(g)): a bare newline inside a `- [ ] ` line re-parses as a soft break or item terminator, NOT as a GFM hardBreak (which requires two trailing spaces or a backslash before the newline). The `hardBreak` is therefore permanently lost through the round-trip text form. This lossiness applies equally to native hardBreak nodes (this EC) and to `hardBreak` nodes injected by EC-16's multi-paragraph flattening (EC-10(g)) — both produce the identical lossy artifact. Do NOT treat the "same rendering mechanism as paragraphs" as implying round-trip stability: the paragraph context provides `\n` after the trailing two spaces which re-encodes the break; the `- [ ] …` line format provides no such re-encoding mechanism. Test: `test_task_item_native_hardbreak_inline_is_roundtrip_lossy`.
- **(EC-12) `adf_to_text` on externally-authored `taskList` with lowercase `state: "done"`**: External ADF payloads from older editor versions may use lowercase state values. `adf_to_text`'s state comparison is case-insensitive (`attrs.state.eq_ignore_ascii_case("DONE")`): `"done"`, `"DONE"`, `"Done"` all render as `- [x] `. Any other value (including absent) renders as `- [ ] `.
- **(EC-13) Nested task list (task list as child of task list)**: ADF `taskList.content` schema permits nested `taskList` nodes (the `anyOf` in `taskList_node.content.items` includes `taskList_node`). GFM `  - [ ] nested` syntax produces a pulldown inner `Tag::List(None)` inside an outer `Tag::Item`, resulting in a nested `taskList`. **Exact ADF placement (schema-required):** the nested `taskList` is placed as a **sibling element in the parent `taskList`'s content array, immediately AFTER the parent `taskItem`** that owns the nesting — NOT inside the `taskItem` (inline-only), and NOT as the first element (the tuple schema requires the first element to be a `taskItem`). Example structure: `taskList.content = [taskItem("outer text"), taskList([taskItem("nested text")])]`. This is the schema-valid placement dictated by the `taskList_node` tuple definition (first element: `taskItem_node`; subsequent elements: `anyOf [taskItem_node, taskList_node]`). **Reconciliation with obligation #4:** nested TASK list → sibling `taskList` placed inside parent `taskList.content` (schema permits this); nested PLAIN list → hoisted to grandparent level OUTSIDE the `taskList` entirely (schema forbids `bulletList` inside `taskList.content`). The two cases are handled differently. `adf_to_text` renders nested task lists with standard indentation (2 spaces per nesting level, matching the bullet-list convention). The per-document localId counter continues monotonically across nested task lists (yielding unique localIds per the DFS-walk rule; see localId Required Attributes above).
- **(EC-14) Malformed / non-task bracket forms**: Only the three pulldown-cmark-recognized forms — `[ ]` (unchecked), `[x]` (checked, lowercase), and `[X]` (checked, uppercase) — produce `Event::TaskListMarker`. All other bracket forms produce literal text in a normal `bulletList`: `[]` (no space), `[*]`, `[-]`, `[  ]` (multi-space), `[ x]` (space before letter), `[X ]` (trailing space), and any other non-conforming variant stay as plain text nodes inside a `listItem`. This mirrors the parser-leniency documentation in BC-7.2.009 EC-1. Implementation note: this behavior is inherent in pulldown-cmark's parser and requires no additional code; it is documented here to anchor the test expectation. Test: `test_malformed_task_markers_stay_literal_text`.
- **(EC-15) Plain list nested inside a task item (`- [ ] outer\n  - plain inner`)**: `taskItem.content` is inline-only — a nested `bulletList` cannot be placed in `taskItem.content` (INVALID ADF). Additionally, `taskList.content` permits only `taskItem` and `taskList` nodes — a `bulletList` cannot be placed as a sibling inside the `taskList.content` array either (ALSO INVALID). The builder must hoist the nested block content **out of the `taskList` entirely, to the grandparent block level**: the task item's inline text content is preserved in `taskItem.content`; the nested list is appended as a sibling node AFTER the parent `taskList` at the grandparent level. This matches normalization obligation #4. The result at grandparent block level is `[..., taskList > [taskItem(inline text)], bulletList(...), ...]` — both the checkbox item and the sub-list are preserved, but the visual nesting relationship and association between them is permanently lost. This is a lossy transform (same class as EC-10 lossiness). Test: `test_task_item_with_nested_plain_list_hoists_block_sibling`.
- **(EC-16) Multi-paragraph task item (`- [ ] line1\n\n  line2`)**: When pulldown-cmark emits paragraph-wrapped bodies inside a task item (two blank-line-separated paragraphs), the paragraph wrappers must be stripped because `taskItem.content` is inline-only. The inline content of each paragraph is concatenated with a `hardBreak` node separator between them. **Ordering: EC-16 inline-flattening runs BEFORE the empty-content prune (EC-8); the prune evaluates the fully-concatenated `taskItem.content`.** **General hardBreak trim rule (addresses hardBreak/prune boundary):** after concatenating paragraphs with `hardBreak` separators, collapse/trim any LEADING or TRAILING `hardBreak` nodes AND any `hardBreak` adjacent to a pruned-empty paragraph — so `taskItem.content` never begins or ends with a `hardBreak`. Example (normal case): `- [ ] line1\n\n  line2` → `taskItem.content: [text("line1"), hardBreak, text("line2")]`. Example (trailing empty paragraph): `- [ ] x\n\n  ` — the second paragraph is whitespace-only and yields no inline nodes; after the separator hardBreak is trimmed (adjacent to a pruned-empty paragraph), the result is `taskItem.content: [text("x")]` (no trailing hardBreak). Example (leading empty paragraph followed by content): `- [ ]\n\n  y` — the first paragraph body is empty (only a `TaskListMarker` event, no text); if the resulting content before the separator is empty, any leading hardBreak is trimmed, yielding `taskItem.content: [text("y")]`. Example (BOTH paragraphs empty — all-empty case): `- [ ]\n\n  ` — both the first paragraph (only `TaskListMarker`, no text) and the second paragraph (whitespace-only or empty) yield no inline content; the flatten step produces an empty content array; the trim step has nothing to trim; the prune step (EC-8) fires because `taskItem.content` is empty, and the `taskItem` is pruned entirely. If the `taskList` had no other items, the empty `taskList` is subsequently pruned (EC-9). The sequence flatten→trim→prune all fire in order, and the final output contains no task item for this input. This is a lossy transform: the paragraph break becomes a line break (the semantic distinction between a paragraph and a hard break is lost). Deliberate — same class as EC-10 and the inline-flattening done for other ADF-inline-only content models. Test: `test_task_item_multi_paragraph_flattened_to_inline`.

- **(EC-17) Ordered list with GFM task markers promoted to `taskList` (ordered-list path, F5 back-propagation)**: An ordered list containing GFM task markers (e.g., `1. [ ] item`) is promoted to `taskList`/`taskItem` IDENTICALLY to a bullet list (`- [ ] item`). The container reclassification is whole-list: all items become `taskItem` nodes; plain items in a mixed ordered list (`1. plain\n2. [ ] checked`) are promoted to `taskItem { state: "TODO" }` (same rule as EC-3 for bullet lists); empty promoted items are pruned per EC-8. **Ordinal numbering is DROPPED** — this is a deliberate lossy transform documented in EC-10(h): ADF has no ordered task-list node, and `orderedList.content` permits only `listItem`, rejecting `taskItem` with HTTP 400. Checkbox state is preserved; ordinal position is permanently discarded. A plain ordered list with NO task markers (`1. first\n2. second`) is UNCHANGED and emits `orderedList > listItem` as before — the promotion fires only when at least one `TaskListMarker` event is emitted by pulldown-cmark. **Implementation note:** the `BulletList` and `OrderedList` finalization arms share a common `reclassify_as_task_list` helper that performs the whole-container inspection and reclassification — the ordered-list path calls the same helper as the bullet-list path, ensuring behavioral parity. Tests: `test_markdown_ordered_task_list_produces_task_list_not_ordered_list`, `test_markdown_ordered_task_list_mixed_promotes_plain_to_todo`, `test_markdown_ordered_task_list_nested_produces_nested_task_list`, `test_markdown_plain_ordered_list_unchanged_without_task_markers`.

**Trace**: `src/adf.rs::markdown_to_adf` (Options block — `ENABLE_TASKLISTS`); `src/adf.rs::AdfBuilder::process` (TaskListMarker arm); `src/adf.rs::AdfBuilder::start` (Tag::Item deferred dispatch); `src/adf.rs::AdfBuilder::end` (BulletList and OrderedList finalization arms — taskList reclassification via `reclassify_as_task_list`; TaskItem finalization arm); `src/adf.rs::normalize_list_item_content` (taskList arm); `src/adf.rs::is_empty_block_container` (taskList, taskItem in prune set); `src/adf.rs::AdfRenderer::render_node` (taskList, taskItem arms); `src/adf.rs::ListFrame` (Task variant); `src/adf.rs::reclassify_as_task_list` (shared helper — called by BulletList and OrderedList finalization arms); `src/adf.rs::tests` (`test_markdown_task_list_emits_task_list_node`, `test_markdown_task_checked_item_emits_done_state`, `test_markdown_task_uppercase_x_emits_done_state`, `test_markdown_mixed_task_plain_list_promotes_container`, `test_markdown_task_item_inline_marks_preserved`, `test_task_list_in_list_item_normalized_to_nested_bullet_list`, `test_task_list_in_blockquote_normalized_to_paragraphs` **(asserts definite output: blockquote-nested taskList is normalized to `blockquote > [paragraph, ...]`; unconditional — pulldown-cmark 0.13.3 confirmed to emit `blockquote > taskList` per `.factory/research/issue-471-pulldown-blockquote-tasklist.md`)**, `test_task_list_in_panel_passes_through`, `test_empty_task_item_pruned`, `test_empty_task_list_pruned`, `test_hardbreak_only_task_item_pruned` **(EC-8 DELIBERATE PRODUCT CHOICE — asserts: a task item whose content is only a hardBreak node is pruned; this is a deliberate product choice, not schema-forced)**, `test_task_list_roundtrip_adf_to_text`, `test_adf_to_text_external_lowercase_state`, `test_nested_task_list_preserved`, `test_malformed_task_markers_stay_literal_text`, `test_task_item_with_nested_plain_list_hoists_block_sibling`, `test_task_item_multi_paragraph_flattened_to_inline`, `test_task_item_native_hardbreak_inline_is_roundtrip_lossy` **(EC-11 — asserts: (1) a native hardBreak in taskItem.content renders as a newline continuation via adf_to_text; (2) the round-trip re-parse does NOT recover a hardBreak — the lossy artifact is a soft break or item terminator, not a GFM hardBreak)**, `test_task_list_localid_dfs_preorder_assignment` **(AC-018 / Required-attributes DFS-counter pin — asserts concrete localId values after DFS-preorder assignment and dense-after-prune recount)**, `test_markdown_ordered_task_list_produces_task_list_not_ordered_list` **(EC-17 — ordered list with task markers → taskList, not orderedList)**, `test_markdown_ordered_task_list_mixed_promotes_plain_to_todo` **(EC-17 — plain items in mixed ordered task list promoted to taskItem { state: "TODO" })**, `test_markdown_ordered_task_list_nested_produces_nested_task_list` **(EC-17 — nested ordered task list)**, `test_markdown_plain_ordered_list_unchanged_without_task_markers` **(EC-17 — plain ordered list without task markers is unchanged)**); `docs/specs/adf-task-list.md`; issue #471

---

### 7.3 Error Display

#### BC-7.3.001: `extract_error_message` 7-step precedence chain (canonical from source)

**Confidence**: HIGH
**Source**: `src/api/client.rs:448-490`; `tests/api_client.rs:257-342`
**Subject**: Output rendering
**Behavior**: Precedence (first match wins, returning `String`):
1. Empty body (len == 0) → literal string `"<empty response body>"` (early return before UTF-8 check)
2. Non-UTF-8 bytes → `String::from_utf8_lossy` with replacement chars (early return)
3. `errorMessages[]` non-empty (JSON array with at least one string element) → elements joined with `"; "`
4. `errors{}` non-empty (JSON object) → `"field: value"` pairs, alphabetically sorted, joined with `"; "`; non-string values use `serde_json::Value` display
5. `message` string field → as-is
6. `errorMessage` string field (singular; seen in JSM endpoints) → as-is
7. Raw body string fallback (non-JSON or no recognized field matches)

**Key invariant**: Empty body check is step 1 — the literal `"<empty response body>"` string IS the return value. There is no None/caller-derives path; the string propagates into `ApiError { message }`.

Note: The function doc comment inside client.rs lists precedence as "1. errorMessages … 5. Empty body … 6. Raw body" — this comment is STALE and does NOT reflect code execution order. Steps 1–2 are early returns before JSON parsing begins. Source code is authoritative; doc comment will be fixed in Phase 3. Corrected by R1 CONV-ABS-004; further corrected by ADV-P2-001.
**Trace**: Pass 3 BC-1201-R (R1); ADV-P2-001

---

#### BC-7.3.002: `errors{}` string values: `field: <value>`; non-string: `field: <serde_json::Value debug>`

**Confidence**: HIGH
**Source**: `src/api/client.rs:469-475`; `tests/api_client.rs:303-307`
**Behavior**: Mixed types: `{summary: "is req", customfield_10001: {messages:["invalid"]}}` → `customfield_10001: {"messages":["invalid"]}`.
**Trace**: Pass 3 BC-1201a (R1)

---

#### BC-7.3.003: `errors{}` iteration is alphabetically sorted (deterministic)

**Confidence**: HIGH
**Source**: `src/api/client.rs:477`; `tests/api_client.rs:286-292`
**Behavior**: `pairs.sort()` before join. `{summary: "req", priority: "req"}` → `priority: req; summary: req` (priority first).
**Trace**: Pass 3 BC-1201b (R1)

---

#### BC-7.3.004: Empty `errorMessages[]` and empty `errors{}` fall through to raw body (no early exit)

**Confidence**: HIGH
**Source**: `src/api/client.rs:459-466`; `tests/api_client.rs:294-300`
**Trace**: Pass 3 BC-1201c (R1)

---

#### BC-7.3.005: `--output json` + empty 4xx body → stderr JSON `{"error": "<empty response body>", "code": <exit>}`

**Confidence**: HIGH
**Source**: `src/main.rs:34-49`; `src/api/client.rs:448-490`
**Subject**: Output rendering
**Behavior**: When `--output json` is active AND the response has a zero-length body (4xx), `extract_error_message` returns the literal string `"<empty response body>"` (step 1 of BC-7.3.001). This string propagates into `JrError::ApiError { message }` and then into the JSON error envelope: `{"error": "<empty response body>", "code": <exit-code>}` to stderr. `code` is the integer exit code matching `JrError::exit_code()`. There is no status-code-derived substitution; the literal string IS the message.
**Edge case**: If body is `{}` (empty JSON object, NOT zero-length bytes), `extract_error_message` falls to step 7 (raw body `{}`), not the empty-body path. The `"<empty response body>"` literal only appears when `body.is_empty()` is true (byte length == 0).
**Trace**: Pass 3 BC-1208; BC-7.3.001 (extract_error_message); ADV-P1-026; ADV-P2-001

---

#### BC-7.3.006: `JrError::exit_code()` mapping

**Confidence**: HIGH
**Source**: `src/error.rs:51-62`; inline tests
**Subject**: Output rendering
**Behavior**: See error-taxonomy.md for full table. Key codes: NotAuthenticated=2, InsufficientScope=2, ConfigError=78, UserError=64, Interrupted=130, NetworkError=1, ApiError=1, Json=1, Http=1, Other=1, Success=0.
**Trace**: Pass 3 BC-1204

---

#### BC-7.3.007: All API errors must suggest a next step (CLAUDE.md convention)

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs`, `tests/issue_resolution.rs`, `tests/auth_refresh.rs`, `tests/issue_view_errors.rs`
**Subject**: Output rendering
**Behavior**: At least one of: `jr auth login`, `--jql`, `--resolution`, `jr issue resolutions`, `jr team list --refresh`, `board_id`, `check your connection`, `jr init` must appear in stderr.
**Trace**: Pass 3 BC-1212

---

#### BC-7.3.008: stderr must NEVER contain `panic`

**Confidence**: HIGH
**Source**: 16+ tests across `tests/*_errors.rs` files asserting `!stderr.contains("panic")`
**Subject**: Output rendering
**Behavior**: Universal constraint. All error paths produce friendly messages.
**Trace**: Pass 3 BC-1205

---

#### BC-7.3.009: Internal errors prefix with `Internal error:`

**Confidence**: MEDIUM
**Source**: `src/error.rs:30-36`
**Trace**: Pass 3 BC-1213

---

### 7.4 JSON Output Shapes (insta snapshot contracts)

All snapshots from `src/cli/issue/snapshots/` and `src/cli/snapshots/`. Keys are sorted alphabetically in insta output.

#### BC-7.4.001: move changed → `{"changed": true, "key": "TEST-1", "status": "In Progress"}`
**Source**: `jr__cli__issue__json_output__tests__move_response_changed.snap`
**Trace**: Pass 3 BC-1104 (R4)

#### BC-7.4.002: move unchanged → `{"changed": false, "key": "TEST-1", "status": "Done"}`
**Source**: `jr__cli__issue__json_output__tests__move_response_unchanged.snap`
**Trace**: Pass 3 BC-1105 (R4)

#### BC-7.4.003: assign changed → `{"assignee": "Jane Doe", "assignee_account_id": "abc123", "changed": true, "key": "TEST-1"}` — `assignee_account_id` is snake_case (NOT camelCase)
**Source**: `jr__cli__issue__json_output__tests__assign_changed.snap`
**Trace**: Pass 3 BC-1106 (R4)

#### BC-7.4.004: unassign → `{"assignee": null, "changed": true, "key": "TEST-1"}` — `assignee` is EXPLICIT null (NOT omitted)
**Source**: `jr__cli__issue__json_output__tests__unassign.snap`
**Trace**: Pass 3 BC-1108 (R4)

#### BC-7.4.005: edit → `{"key": "TEST-1", "updated": true}` — minimal 2-key shape
**Source**: `jr__cli__issue__json_output__tests__edit.snap`
**Trace**: Pass 3 BC-1109 (R4)

#### BC-7.4.006: link → `{"key1": "TEST-1", "key2": "TEST-2", "linked": true, "type": "Blocks"}` — symmetric key1/key2
**Source**: `jr__cli__issue__json_output__tests__link.snap`
**Trace**: Pass 3 BC-1110 (R4)

#### BC-7.4.007: unlink → `{"count": 2, "unlinked": true}`; no-match → `{"count": 0, "unlinked": false}` (count: 0 NOT omitted)
**Source**: `jr__cli__issue__json_output__tests__unlink_success.snap`
**Trace**: Pass 3 BC-1111 (R4)

#### BC-7.4.008: remote-link → `{"id": 10000, "key": "TEST-1", "self": <url>, "title": <title>, "url": <url>}` — id is u64
**Source**: `jr__cli__issue__json_output__tests__remote_link.snap`
**Trace**: Pass 3 BC-1112 (R4)

#### BC-7.4.009: sprint add → `{"added": true, "issues": [...], "sprint_id": 100}` — sprint_id snake_case
**Source**: `jr__cli__sprint__tests__sprint_add_response.snap`
**Trace**: Pass 3 BC-1113 (R4)

#### BC-7.4.010: sprint remove → `{"issues": [...], "removed": true}` — NO sprint_id (remove is sprint-agnostic)
**Source**: `jr__cli__sprint__tests__sprint_remove_response.snap`
**Trace**: Pass 3 BC-1114 (R4)

#### BC-7.4.011: auth list table → 4 cols: NAME, URL, AUTH, STATUS; active prefix `* ` (asterisk-space); inactive `  ` (2 spaces)
**Source**: `jr__cli__auth__tests__list_table_snapshot.snap`
**Trace**: Pass 3 BC-1115 (R4)

#### BC-7.4.012: `user view` hidden email → table shows em-dash `—`; JSON output shows explicit `null` (privacy boundary)
**Source**: `tests/user_commands.rs` BC-1132j/k
**Trace**: Pass 3 BC-1132j, BC-1132k (R4)

#### BC-7.4.013: `auth login --output json` emits `{"profile": <name>, "action": "login", "ok": true}` to stdout on success

**Confidence**: HIGH
**Source**: `src/cli/auth.rs::handle_login` (JSON branch); `src/cli/auth.rs::auth_json_response`
**Subject**: JSON output shape — auth login
**Behavior**: When `--output json` is set and `jr auth login` completes successfully, stdout receives exactly the JSON object `{"action": "login", "ok": true, "profile": "<profile-name>"}` (keys sorted alphabetically in insta output). The `profile` field reflects the profile name that was logged in. No other output is written to stdout. Human-readable success text is suppressed when `--output json` is active.

```json
{"action": "login", "ok": true, "profile": "<name>"}
```

Field types: `profile` is `string`, `action` is `string` literal `"login"`, `ok` is `bool` literal `true`.
**Production code**: `src/cli/auth.rs::handle_login` (JSON branch); helper `auth_json_response(profile_name, "login")`
**Snapshot test**: `src/cli/snapshots/jr__cli__auth__tests__auth_login_json_shape.snap`
**Trace**: S-2.07 v2.0.0 (BC-7.4.013, added 2026-05-08 by Fix-PR A)

---

#### BC-7.4.014: `auth switch --output json` emits `{"profile": <name>, "action": "switch", "ok": true}` to stdout on success

**Confidence**: HIGH
**Source**: `src/cli/auth.rs::handle_switch` (JSON branch); `src/cli/auth.rs::auth_json_response`
**Subject**: JSON output shape — auth switch
**Behavior**: When `--output json` is set and `jr auth switch <profile>` completes successfully, stdout receives exactly the JSON object `{"action": "switch", "ok": true, "profile": "<profile-name>"}` (keys sorted alphabetically). The `profile` field reflects the profile switched to. Human-readable success text is suppressed when `--output json` is active.

```json
{"action": "switch", "ok": true, "profile": "<name>"}
```

Field types: `profile` is `string`, `action` is `string` literal `"switch"`, `ok` is `bool` literal `true`.
**Production code**: `src/cli/auth.rs::handle_switch` (JSON branch); helper `auth_json_response(profile_name, "switch")`
**Snapshot test**: `src/cli/snapshots/jr__cli__auth__tests__auth_switch_json_shape.snap`
**Trace**: S-2.07 v2.0.0 (BC-7.4.014, added 2026-05-08 by Fix-PR A)

---

#### BC-7.4.015: `auth logout --output json` emits `{"profile": <name>, "action": "logout", "ok": true}` to stdout on success

**Confidence**: HIGH
**Source**: `src/cli/auth.rs::handle_logout` (JSON branch); `src/cli/auth.rs::auth_json_response`
**Subject**: JSON output shape — auth logout
**Behavior**: When `--output json` is set and `jr auth logout` completes successfully, stdout receives exactly the JSON object `{"action": "logout", "ok": true, "profile": "<profile-name>"}` (keys sorted alphabetically). The `profile` field reflects the profile logged out. Human-readable success text is suppressed when `--output json` is active.

```json
{"action": "logout", "ok": true, "profile": "<name>"}
```

Field types: `profile` is `string`, `action` is `string` literal `"logout"`, `ok` is `bool` literal `true`.
**Production code**: `src/cli/auth.rs::handle_logout` (JSON branch); helper `auth_json_response(profile_name, "logout")`
**Snapshot test**: `src/cli/snapshots/jr__cli__auth__tests__auth_logout_json_shape.snap`
**Trace**: S-2.07 v2.0.0 (BC-7.4.015, added 2026-05-08 by Fix-PR A)

---

#### BC-7.4.016: `auth remove --output json` emits `{"profile": <name>, "action": "remove", "ok": true}` to stdout on success

**Confidence**: HIGH
**Source**: `src/cli/auth.rs::handle_remove` (JSON branch); `src/cli/auth.rs::auth_json_response`
**Subject**: JSON output shape — auth remove
**Behavior**: When `--output json` is set and `jr auth remove <profile>` completes successfully, stdout receives exactly the JSON object `{"action": "remove", "ok": true, "profile": "<profile-name>"}` (keys sorted alphabetically). The `profile` field reflects the profile removed. Human-readable success text is suppressed when `--output json` is active.

```json
{"action": "remove", "ok": true, "profile": "<name>"}
```

Field types: `profile` is `string`, `action` is `string` literal `"remove"`, `ok` is `bool` literal `true`.
**Production code**: `src/cli/auth.rs::handle_remove` (JSON branch); helper `auth_json_response(profile_name, "remove")`
**Snapshot test**: `src/cli/snapshots/jr__cli__auth__tests__auth_remove_json_shape.snap`
**Trace**: S-2.07 v2.0.0 (BC-7.4.016, added 2026-05-08 by Fix-PR A)

---

### 7.5 Observability

#### BC-7.5.001: Verbose request logging emits `[verbose] METHOD URL` + `[verbose] body: <utf8>` (when body present)

**Confidence**: HIGH
**Source**: `src/api/client.rs:197-204, 274-279`
**Subject**: Output rendering
**Behavior**: Two lines per request. Body is utf-8 lossy. Retry logging: `[verbose] Rate limited (429). Retrying in {delay}s (attempt N/M)`. Authorization header NOT logged (NFR-S-C flag — body IS logged, auth NOT).
**Trace**: Pass 3 BC-1405; BC-1405-R (R1)

---

#### BC-7.5.002: `log_parse_failure_once` gate — parse failure logged at most once per (process, key)

**Confidence**: MEDIUM
**Source**: `src/observability.rs::tests`
**Trace**: Pass 3 BC-1109 (format.rs context)

---

#### BC-7.5.003: `format_duration(seconds)` collapses to `30m` / `2h` / `1h30m` (hours+minutes only; never weeks/days)

**Confidence**: HIGH
**Source**: `src/duration.rs:52-60`
**Trace**: Pass 3 BC-1107

---

## Key Invariants

- stdout = data; stderr = errors, warnings, hints (universal discipline)
- ADF lossy for mention/emoji/inlineCard/media — documented, not a bug
- JSON output uses snake_case for jr-internal fields (NOT Atlassian camelCase)
- Insta snapshots pin exact bytes — any glyph or key change breaks snapshot test
- `extract_error_message` empty-body check is FIRST (not last)

---

## Spec Changelog

| Version | Date | Author | Change |
|---------|------|--------|--------|
| 1.0.0 | 2026-06-10 | product-owner | Initial BC-7.2.010 (issue #471 GFM task lists → taskList/taskItem) |
| 1.1.0 | 2026-06-10 | product-owner | F5 back-propagation: added EC-17 (ordered list with GFM task markers promoted to `taskList` — DOCUMENT-AS-IS from F5 implementation review); added EC-10(h) to lossiness ledger (ordinal-numbering-dropped on ordered task lists); added `reclassify_as_task_list` shared helper note and four EC-17 test names to Trace field |
