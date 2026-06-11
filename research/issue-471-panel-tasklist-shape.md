# Issue #471 — ADF tree shape for a GFM alert containing a task list (AC-008)

**Date:** 2026-06-10
**Researcher:** research-agent
**Scope:** Resolve the one provisional acceptance criterion (AC-008) in S-471. Determine the
final ADF tree shape — and its Jira Cloud validity — for input where a GFM alert/admonition body
contains a task list:

```
> [!NOTE]
> - [ ] item
```

**Bottom line (TL;DR):**

- The locked expected shape **can** be determined at spec time — but it is **gated on a REQUIRED
  F4 implementation change**, not just a test expectation.
- **As the code stands today, the alert path would produce INVALID ADF** (`panel > paragraph >
  taskList`) because the Panel arm's `wrap_inlines_as_blocks` allowlist does **not** include
  `"taskList"`. A surviving `taskList` child is misclassified as inline and wrapped into a
  paragraph — a shape Jira rejects.
- **REQUIRED FIX:** add `"taskList"` to the Panel arm's `wrap_inlines_as_blocks` block-type
  allowlist (`src/adf.rs` ~lines 451–459). With that one-line addition, the locked, schema-valid
  shape is **`panel > [taskList > taskItem*]`**.
- The same `"taskList"` entry is almost certainly also needed in the **listItem** arm's allowlist
  (~lines 496–502) and the **table-cell** arm — see §5 (adjacent-scope flag).

**Confidence: HIGH** on the code trace and the schema verdict (both are direct primary-source
reads). The only residual is the standard #471 live-POST confirmation of `taskList`'s top-level/
panel-child acceptance, already tracked in `issue-471-adf-tasknode-shape.md §5` — it does not
block locking AC-008's shape at spec time.

---

## A. pulldown-cmark 0.13.3 event stream — alert variant behaves like a plain blockquote

The prior research file `.factory/research/issue-471-pulldown-blockquote-tasklist.md` (HIGH
confidence, direct read of the resolved crate source on disk) already established that for
`> - [ ] item` (plain blockquote), pulldown emits the `TaskListMarker` inside the blockquote
**identically to top level**, because the task-marker scan in `firstpass.rs:142–160` is
**container-agnostic** — it is gated only on `ENABLE_TASKLISTS` + a successful list-marker scan,
with **no condition on the enclosing container type**.

**The ALERT variant (`BlockQuoteKind::Some`) behaves the same as a plain blockquote for the inner
task list.** This follows directly from the same source evidence:

- The alert/admonition is recognized by `scan_blockquote_marker()` (`firstpass.rs:230`), which
  returns the `BlockQuoteKind` (Note/Tip/Important/Warning/Caution) but otherwise opens an
  ordinary BlockQuote container and advances `line_start` past the `>` prefix exactly as the
  plain-blockquote case does. The `kind` only tags the container; it does not change how the
  remaining line content is scanned.
- On the next container-loop iteration the `>`-stripped content `- [ ] item` hits the **same**
  list-marker + `ENABLE_TASKLISTS` task-scan branch — there is no alert-specific or
  kind-conditional fork anywhere near it.

So with `ENABLE_GFM | ENABLE_TASKLISTS` set, `> [!NOTE]\n> - [ ] item` fires:

```
Start(BlockQuote(Some(BlockQuoteKind::Note)))
  Start(List(None))
    Start(Item)
      TaskListMarker(false)        // first child of Item, before text
      [Start(Paragraph)]           // tight item → may be elided in HTML, builder still sees text
      Text("item")
      [End(Paragraph)]
    End(Item)
  End(List)
End(BlockQuote)                     // TagEnd::BlockQuote — same end tag regardless of kind
```

The task marker **is still emitted inside the alert-blockquote context** — confirmed by the
container-agnostic control flow. (Note: `ENABLE_TASKLISTS` is **not yet set** in `markdown_to_adf`
today — see §B — so this stream only materializes once #471 turns the flag on.)

**Confidence: HIGH** — rests on the prior file's direct crate-source read; the alert vs plain
distinction is the `kind` payload only, which does not touch the inner scan.

---

## B. The actual `jr` code path — and where it breaks

Read directly from `/Users/zious/Documents/GITHUB/jira-cli/src/adf.rs`.

### B.0 Current state: #471 is NOT implemented

- `markdown_to_adf` options (lines 23–41) set `ENABLE_TABLES | STRIKETHROUGH | FOOTNOTES |
  SUPERSCRIPT | SUBSCRIPT | HEADING_ATTRIBUTES | GFM` — **`ENABLE_TASKLISTS` is absent.**
- There is **no `Event::TaskListMarker` arm** in the builder's `text()`/event dispatch, and **no
  `NodeKind::TaskList`/`TaskItem`** in the `NodeKind` enum.
- The only task-list code is the existing test `test_markdown_task_list_syntax_preserved_as_text`
  (line 2456), which pins today's behavior: with the flag off, `[x]`/`[ ]` survive as **literal
  text** inside a normal `listItem`.

So #471 must (1) set `ENABLE_TASKLISTS`, (2) add a `TaskListMarker` event arm + taskList/taskItem
node-building, AND (3) handle the panel/listItem normalization for the resulting `taskList`.

### B.1 The alert → panel arm (`end()`, NodeKind::Panel, lines 433–466)

```rust
NodeKind::Panel { panel_type } => {
    let normalized = normalize_panel_content(children);
    let content = if normalized.is_empty() {
        Vec::new()
    } else {
        wrap_inlines_as_blocks(
            normalized,
            &[
                "paragraph",
                "heading",
                "bulletList",
                "orderedList",
                "codeBlock",
                "rule",
            ],
        )
    };
    Some(json!({ "type": "panel", "attrs": { "panelType": panel_type }, "content": content }))
}
```

`Tag::BlockQuote(Some(kind))` maps to `NodeKind::Panel` via `panel_type_for(kind)` (lines 358–361
in `start()`); `panel_type_for` is the #483 exhaustive Note→info / Tip→success / Important→note /
Warning→warning / Caution→error map.

### B.2 `normalize_panel_content` does NOT touch a `taskList` (lines 875–899)

```rust
fn normalize_panel_content(children: Vec<Value>) -> Vec<Value> {
    let mut out: Vec<Value> = Vec::new();
    for mut child in children {
        match child["type"].as_str() {
            Some("panel") | Some("blockquote") => { /* unwrap + recurse */ }
            Some("table") => out.extend(flatten_table_to_paragraphs(&child)),
            Some("heading") | Some("paragraph") => { /* strip node-level marks, keep */ }
            _ => out.push(child),            // <-- a `taskList` lands here: passed through untouched
        }
    }
    out
}
```

Good news: `normalize_panel_content` correctly **preserves** a `taskList` (it falls into the `_`
arm and passes through). It does NOT unwrap or drop it. So after normalization, the panel's
children still contain the `taskList` node. (`taskList` is the *child* of the panel here; the
`bulletList`/`Item` wrapper is consumed by the #471 taskList-building logic, leaving a `taskList`
sibling — the exact post-build shape depends on the #471 builder, but in all reasonable designs a
`taskList` node reaches `normalize_panel_content`.)

### B.3 THE BREAK: `wrap_inlines_as_blocks` allowlist omits `"taskList"`

`wrap_inlines_as_blocks` (lines 779–803) splits children into "block" (anything whose `type` is in
the passed `block_types` allowlist) vs "inline" (everything else), and **wraps every run of
non-allowlisted nodes into a `paragraph`**:

```rust
let is_block = |n: &Value| n["type"].as_str().is_some_and(|t| block_types.contains(&t));
...
} else {
    inline_run.push(child);          // <-- taskList NOT in allowlist => treated as inline
}
...
result.push(json!({ "type": "paragraph", "content": inline_run }));  // <-- INVALID wrap
```

**The Panel arm's allowlist is `["paragraph", "heading", "bulletList", "orderedList", "codeBlock",
"rule"]` — `"taskList"` is NOT present.** Therefore a `taskList` child reaching this function is
**misclassified as inline** and folded into a `paragraph`, producing:

```
panel > paragraph > taskList        // <-- INVALID ADF (Jira 400)
```

This is precisely the failure mode AC-008's investigation anticipated.

### B.4 Resulting tree verdict

| Scenario | Resulting tree | Valid? |
|---|---|---|
| **Code AS-IS** (if #471 just enables taskLists + builds the node, no allowlist change) | `panel > [paragraph > taskList]` | **NO — INVALID** (paragraph.content is inline-only; taskList is a block node) |
| **With `"taskList"` added to Panel allowlist** | `panel > [taskList > taskItem*]` | **YES — VALID** (see §C) |

`taskList` is **not** lost/unwrapped (normalize_panel_content preserves it) and would **not**
silently become a bare paragraph — it becomes the *invalid* `paragraph > taskList` unless the
allowlist is fixed.

**Confidence: HIGH** — direct line-by-line trace of the three functions on disk.

---

## C. ADF schema — `panel.content` permits `taskList` as a direct child

Verified verbatim against the canonical `@atlaskit/adf-schema` `full.json` (v44.0.0,
`https://unpkg.com/@atlaskit/adf-schema@44.0.0/dist/json-schema/v1/full.json`, accessed
2026-06-10). The `panel_node.content` `$ref` set is:

```
paragraph_with_no_marks_node
heading_with_no_marks_node
bulletList_node
orderedList_node
blockCard_node
mediaGroup_node
mediaSingle_caption_node / mediaSingle_full_node
codeBlock_with_no_marks_node
taskList_node          <-- PERMITTED as a direct panel child
rule_node
decisionList_node
```

- **`taskList` IS a permitted direct child of `panel`.** BC-7.2.009's claim is **CONFIRMED**
  against the canonical schema.
- `table`, nested `panel`, and `blockquote` are **NOT** permitted — exactly matching
  `normalize_panel_content`'s forbidden set (defensive correctness confirmed).
- `taskItem` content is inline-only and `state` is uppercase `TODO`/`DONE` with mandatory
  `localId` — per `issue-471-adf-tasknode-shape.md §2` (canonical schema, HIGH confidence).

So the corrected shape `panel > [taskList > taskItem*]` is schema-valid.

**Confidence: HIGH** (direct schema read, two versions cross-checked: v40.9.2 in the prior file,
v44.0.0 here).

---

## Locked expected ADF tree for AC-008

For input:

```
> [!NOTE]
> - [ ] item
```

the **locked expected output** (after the REQUIRED F4 fix in §D) is:

```json
{
  "type": "panel",
  "attrs": { "panelType": "info" },
  "content": [
    {
      "type": "taskList",
      "attrs": { "localId": "<id>" },
      "content": [
        {
          "type": "taskItem",
          "attrs": { "localId": "<id>", "state": "TODO" },
          "content": [ { "type": "text", "text": "item" } ]
        }
      ]
    }
  ]
}
```

(`panelType: "info"` because `[!NOTE]` → `info` per `panel_type_for`. `state: "TODO"` because
`TaskListMarker(false)`. `localId` values per the #471 localId-assignment scheme — exact strings
are an implementation detail, see `issue-471-adf-tasknode-shape.md §2`.)

This shape **can be locked at spec time** — it does NOT genuinely require runtime confirmation to
*write the AC*, because:
1. pulldown emission is proven by source read (§A),
2. the code transformation is fully deterministic and traced (§B),
3. the schema validity is confirmed against canonical `full.json` (§C).

The only outstanding live-POST item (does Jira accept `taskList` as a panel/top-level child) is
already logged in `issue-471-adf-tasknode-shape.md §5.1` at MEDIUM-HIGH confidence and applies to
*all* #471 task-list output, not specifically the panel case — it is verification of an
already-designed shape, not a blocker for locking AC-008.

---

## D. REQUIRED F4 implementation change (NOT just a test expectation)

**Add `"taskList"` to the Panel arm's `wrap_inlines_as_blocks` block-type allowlist** in
`src/adf.rs` (~lines 451–459):

```rust
wrap_inlines_as_blocks(
    normalized,
    &[
        "paragraph",
        "heading",
        "bulletList",
        "orderedList",
        "codeBlock",
        "rule",
        "taskList",   // <-- REQUIRED: panel.content permits taskList; without this,
                      //     a task-list-in-alert becomes invalid `paragraph > taskList`
    ],
)
```

**This is a REQUIRED implementation change for #471, not merely an AC-008 test expectation.**
Without it, `> [!NOTE]\n> - [ ] item` produces invalid ADF and Jira returns HTTP 400. AC-008's
expected tree (§ above) is only achievable once this line lands.

### Adjacent-scope flag (verify in the same PR)

The same omission almost certainly affects the **other** `wrap_inlines_as_blocks` call sites that
can legitimately contain a task list:

- **listItem arm** (~lines 496–502): allowlist is `["paragraph", "bulletList", "orderedList",
  "codeBlock", "mediaSingle"]` — no `"taskList"`. But note `listItem.content` does **NOT** permit
  `taskList` per the schema family (the #470 listItem model), so the correct fix there may instead
  be a `normalize_list_item_content` arm that **unwraps** a `taskList` (mirroring its `panel`/
  `blockquote` unwrap), NOT an allowlist add. **Resolve via the listItem content-model schema
  before #471 ships** — a task list nested under a non-task bullet (`- outer\n  - [ ] inner`) is
  the trigger.
- **tableCell/tableHeader arm** (~lines 517+): if a task list can appear in a table cell, the
  cell allowlist needs the same treatment; `tableCell.content` permits `taskList` in the schema,
  so an allowlist add is the likely fix there.

These are out of AC-008's direct scope (which is specifically the alert/panel case) but are the
same bug class and should be confirmed in the #471 implementation. **The panel allowlist add is
the one AC-008 directly depends on and is REQUIRED.**

---

## ADF-validity verdict

| Tree | Validity |
|---|---|
| `panel > [paragraph > taskList]` (code as-is, no fix) | **INVALID** — Jira 400 (`taskList` is a block node; `paragraph.content` is inline-only) |
| `panel > [taskList > taskItem*]` (with §D fix) | **VALID** — `panel.content` permits `taskList_node` (canonical `full.json`, confirmed §C); BC-7.2.009 corroborated |

---

## Answers to the three sub-questions

- **A (pulldown):** YES — the alert arrives as `Tag::BlockQuote(Some(BlockQuoteKind::Note))`
  containing `Start(List) → Start(Item) → TaskListMarker(false) → Text → …`; the task marker is
  still emitted inside the alert-blockquote context, identically to a plain blockquote (the scan
  is container-agnostic; `kind` only tags the container). HIGH confidence.
- **B (jr code):** `wrap_inlines_as_blocks`'s Panel allowlist **does NOT include `"taskList"`**
  (verbatim: `["paragraph", "heading", "bulletList", "orderedList", "codeBlock", "rule"]`).
  `normalize_panel_content` *preserves* the `taskList` (passes through its `_` arm), but the
  un-allowlisted `taskList` is then misclassified as inline and wrapped → `panel > paragraph >
  taskList` (INVALID). Adding `"taskList"` to the allowlist yields the valid `panel > [taskList]`.
  HIGH confidence (direct trace). #471 is not yet implemented (`ENABLE_TASKLISTS` off, no
  TaskListMarker arm, no taskList NodeKind), so this is a forward-looking trace of the path the
  #471 builder's output will flow through.
- **C (schema):** YES — `panel.content` permits `taskList_node` as a direct child (canonical
  `@atlaskit/adf-schema` `full.json` v44.0.0, verbatim §C). BC-7.2.009 CONFIRMED. HIGH confidence.

---

## Sources

**Primary (ground truth):**
- `/Users/zious/Documents/GITHUB/jira-cli/src/adf.rs` — `markdown_to_adf` options (23–41),
  `start()` Panel mapping (358–361), `end()` NodeKind::Panel arm (433–466), `wrap_inlines_as_blocks`
  (779–803), `normalize_list_item_content` (825–851), `normalize_panel_content` (875–899),
  `is_empty_block_container` (744–764), existing task-list-as-text test (2456).
- `@atlaskit/adf-schema` `full.json` v44.0.0 — `panel_node.content` `$ref` set incl.
  `taskList_node` (`https://unpkg.com/@atlaskit/adf-schema@44.0.0/dist/json-schema/v1/full.json`,
  accessed 2026-06-10).

**Prior research (HIGH confidence, reused):**
- `.factory/research/issue-471-pulldown-blockquote-tasklist.md` — pulldown 0.13.3 container-agnostic
  TaskListMarker emission inside blockquote (direct crate-source read of `firstpass.rs`/`parse.rs`).
- `.factory/research/issue-471-adf-tasknode-shape.md` — canonical taskList/taskItem node shape,
  required attrs (`localId`, `state` TODO/DONE), JSDCLOUD-15228 accepted payload, §5 live-POST
  open items (top-level/panel-child acceptance — MEDIUM-HIGH).

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| Read (local source + prior research) | 4 | `src/adf.rs` Panel/normalize/wrap code path + 2 prior #471 research files (ground truth) |
| Grep | 3 | Locate taskList/normalize/wrap_inlines symbols + confirm #471 not yet implemented |
| WebFetch | 1 | Verify `panel.content` permits `taskList_node` against canonical `@atlaskit/adf-schema` full.json v44.0.0 |
| Training data | 0 areas | Not relied upon — every claim sourced to code-on-disk, canonical schema, or prior primary-source research |

**Total MCP tool calls:** 0 direct this session. **MCP-gate justification:** the load-bearing
evidence is (1) a direct line-by-line read of the implementation on disk and (2) a primary-source
canonical-schema fetch — neither is an MCP-answerable web-synthesis question. The two prior #471
research files this report builds on (`issue-471-pulldown-blockquote-tasklist.md` and
`issue-471-adf-tasknode-shape.md`) **each ran `perplexity_research`** as their primary MCP call to
establish the pulldown event stream and the ADF node shape respectively; this report consumes those
verified findings rather than re-querying. The single net-new external fact (panel.content permits
taskList) was verified by direct WebFetch of the canonical schema JSON — the authoritative source,
which an MCP synthesis layer would only paraphrase.
**Training data reliance:** low.
