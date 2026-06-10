# Issue #471 — pulldown-cmark blockquote-nested GFM task list event stream

**Date:** 2026-06-10
**Scope:** Resolve the open F4-conditional dependency in BC-7.2.010 (EC-6 / normalization
obligation #2). Determine whether `blockquote > taskList` task-list markers are produced by
pulldown-cmark and, if so, whether the spec's blockquote-normalization arm is NEEDED or a no-op.
**Crate version (verified):** `pulldown-cmark 0.13.3` — `Cargo.toml` pins `"0.13"`,
`Cargo.lock` resolves to `7c3a14896…` checksum, version `0.13.3`.
**Confidence:** HIGH (direct read of the resolved crate source + the crate's own HTML snapshot
suite, cross-checked with Perplexity over docs.rs / GitHub).

---

## Verdict (TL;DR)

1. **The `TaskListMarker` event IS produced identically inside a blockquote.** Nesting a GFM
   task list inside a blockquote (`> - [ ] item`) does NOT suppress or alter task-list
   recognition. The parser emits:

   ```
   Start(BlockQuote(None))
     Start(List(None))
       Start(Item)
         TaskListMarker(false)        // TaskListMarker(true) for `> - [x] item`
         Start(Paragraph)             // tight list → paragraph may be elided in HTML, but the
         Text("item")                 //   builder still sees Text as the item's content
         End(Paragraph)
       End(Item)
     End(List)
   End(BlockQuote)
   ```

   The `TaskListMarker` is the **first child event after `Start(Item)`, before the item text** —
   exactly as at top level.

2. **Therefore obligation #2's blockquote-normalization arm is NEEDED, not a no-op.** Because
   pulldown DOES emit `blockquote > taskList` (a `taskList`/checkbox structure inside an ADF
   `blockquote`), and ADF's `blockquote.content` content-model forbids the constructs that the
   task-list builder produces (a `taskList` node, or a checkbox-bearing list), the normalization
   pass must handle the in-blockquote case. **Do not remove or short-circuit the blockquote arm.**

3. **Top-level builder contract confirmed:** `- [ ] item` → `Start(Item) → TaskListMarker(false)
   → Text("item") → End(Item)`; `- [x] item` → `…TaskListMarker(true)…`. The marker is always the
   first child event after `Start(Item)`.

---

## Primary-source evidence (strongest — resolved crate source on disk)

The exact crate that the build links was read directly at:
`~/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/pulldown-cmark-0.13.3/`

### A. Task-list recognition is decoupled from container context — `firstpass.rs`

`src/firstpass.rs` `scan_containers`/`parse_block` runs a single **"Process new containers"
`loop`** (line ~106). On each iteration it tries, in order: footnote def, **list marker**,
definition-list marker, **blockquote marker**. The relevant branches:

- **Blockquote open** (`firstpass.rs:230`):
  ```rust
  } else if line_start.scan_blockquote_marker() {
      … self.tree.append(Item { … body: ItemBody::BlockQuote(kind) }); self.tree.push();
  ```
  Scanning the `>` marker **advances `line_start` past the `>` prefix**, opens the BlockQuote
  container, and the `loop` re-iterates to re-scan the *same* line for further containers.

- **List marker + task-list scan** (`firstpass.rs:128–160`), reached on the next iteration once
  the `>` has been consumed:
  ```rust
  if let Some((ch, index, indent)) = line_start.scan_list_marker_with_indent(outer_indent) {
      …
      self.tree.append(Item { … body: ItemBody::ListItem(indent) });
      self.tree.push();
      …
      if self.options.contains(Options::ENABLE_TASKLISTS) {
          let task_list_marker = line_start.scan_task_list_marker().map(|is_checked| Item {
              start: after_marker_index,
              end:   start_ix + line_start.bytes_scanned(),
              body:  ItemBody::TaskListMarker(is_checked),
          });
          if let Some(task_list_marker) = task_list_marker {
              if let Some(n) = scan_blank_line(&bytes[task_list_marker.end..]) {
                  self.tree.append(task_list_marker);   // marker appended as first child of Item
                  …
              } else {
                  line_start.scan_all_space();
                  let ix = start_ix + line_start.bytes_scanned();
                  return self.parse_paragraph(ix, Some(task_list_marker)); // marker before text
              }
          }
      }
  }
  ```

**The decisive facts:**
- The `ENABLE_TASKLISTS` task-marker scan sits **inside the generic list-marker branch**, gated
  *only* on `ENABLE_TASKLISTS` + a successful `scan_list_marker_with_indent` + a successful
  `scan_task_list_marker`. There is **no condition on the enclosing container type** — no `if
  inside blockquote` branch anywhere near this code.
- By the time the list-marker branch runs for `> - [ ] item`, the `>` prefix has already been
  stripped by the blockquote branch on a prior loop iteration. The task scan operates on the
  post-prefix line content, so `- [ ] item` inside a blockquote is scanned **byte-for-byte the
  same way** as a top-level `- [ ] item`.
- The marker `Item` is appended/passed **before** the item's paragraph text
  (`parse_paragraph(ix, Some(task_list_marker))` emits the marker first, then the paragraph),
  fixing the marker as the first child event after `Start(Item)`.

`ItemBody::TaskListMarker(is_checked)` is created at `firstpass.rs:147`.

### B. The tree node maps 1:1 to the public event — `parse.rs`

`src/parse.rs` `item_to_event` (the function that converts internal tree nodes to public
`Event`s) at line 2269:
```rust
ItemBody::TaskListMarker(checked) => return Event::TaskListMarker(checked),
```
So the internal `ItemBody::TaskListMarker(bool)` node produced inside the blockquote surfaces as
the public `Event::TaskListMarker(bool)` with no container-dependent transformation. (Also pinned
in the allowed-children list at `parse.rs:166` and the `Event` definition at `lib.rs:611`.)

### C. The crate's own HTML snapshot suite proves recognition + nesting — `gfm_tasklist.rs`

`tests/suite/gfm_tasklist.rs` (auto-generated from the crate's spec fixtures):

- `gfm_tasklist_test_1`: `- [ ] foo` / `- [x] bar` → `<input disabled type=checkbox/>` /
  `…checked`. Confirms top-level recognition and the checked/unchecked boolean.
- `gfm_tasklist_test_2`: a checked item containing a **nested** sub-list of task items
  (`- [x] foo` → `- [ ] bar` / `- [x] baz`) renders checkboxes at **both** nesting levels.
  Confirms multi-level nesting (list > item > nested list) produces markers at every level — the
  recognition logic is depth-independent, consistent with the container-agnostic scan in (A).

> Note on fixtures: the shipped `tests/suite/*.rs` are HTML-render snapshots, not raw event
> dumps, and the suite happens to ship **no** `blockquote + tasklist` fixture. The
> blockquote-nesting verdict therefore rests on the **source-code control flow** in (A)+(B)
> (which is dispositive — the scan cannot behave differently inside a blockquote because it never
> inspects the enclosing container), with the HTML suite (C) confirming recognition and arbitrary
> nesting independently.

---

## Cross-check (Perplexity, docs.rs / GitHub)

`perplexity_research` (sonar-deep-research, medium effort) over docs.rs + the pulldown-cmark
GitHub repo independently concluded:

- Top-level `- [ ] item` → `Start(Item) → TaskListMarker(false) → Text("item") → End(Item)`;
  `TaskListMarker(true)` for `- [x] item`. The marker is the first child after `Start(Item)`,
  before text. (docs.rs `Event::TaskListMarker`: "rendered as a checkbox… Contains a true when it
  is checked. Only parsed and emitted with `Options::ENABLE_TASKLISTS`.")
- Blockquote nesting does **not** change production or ordering:
  `Start(BlockQuote) → Start(List) → Start(Item) → TaskListMarker(…) → Text → End(Item) → End(List)
  → End(BlockQuote)`. pulldown emits events as a preorder traversal of the document tree with no
  documented context-dependent special-casing for task lists.

This corroborates the primary source. (The Perplexity report reasons from public docs and the
event model rather than the parser source, so it is treated as **confirming**, not primary —
citation discipline: the source read in §A/§B is the ground truth, docs.rs is the secondary
check.)

---

## Answers to the four specific questions

1. **Is `TaskListMarker` produced inside a blockquote exactly as at top level?**
   **Yes.** `> - [ ] item` →
   `Start(BlockQuote(None)) → Start(List(None)) → Start(Item) → TaskListMarker(false) →
   [Start(Paragraph)] → Text("item") → [End(Paragraph)] → End(Item) → End(List) → End(BlockQuote)`.
   Nesting in a blockquote does **not** suppress or alter recognition — the scan is
   container-agnostic (`firstpass.rs:142–160`).

2. **Ordering of `Event::TaskListMarker` vs `Tag::Item` start and the text:**
   The marker is the **first child event after `Start(Item)`, before the text**
   (`parse_paragraph(ix, Some(task_list_marker))` emits the marker, then the paragraph/text).

3. **Ordered lists / multi-level nesting:**
   - **Ordered list** (`1. [ ] item`): same path — `scan_list_marker_with_indent` matches the
     ordered marker, then the identical `ENABLE_TASKLISTS` scan runs; the `List` start carries
     `Some(start_number)` instead of `None`, but the `Item`→`TaskListMarker`→text ordering is
     unchanged.
   - **Multi-level** (`> - [ ] a` then nested `>   - [ ] b`, or list > item > nested list):
     each `Item` independently runs the marker scan, so a `TaskListMarker` is produced for every
     task item at every depth (confirmed by `gfm_tasklist_test_2`).

4. **Top-level builder contract:**
   - `- [ ] item` → `Start(Item) → TaskListMarker(false) → Text("item") → End(Item)`
   - `- [x] item` → `Start(Item) → TaskListMarker(true)  → Text("item") → End(Item)`
   Marker first, always, before text. (Tight single-line items may interpose
   `Start(Paragraph)`/`End(Paragraph)` around the `Text`, but the marker still precedes them.)

---

## Implication for BC-7.2.010 / EC-6 / obligation #2

- The blockquote-normalization arm of obligation #2 is **load-bearing and required** — pulldown
  genuinely emits a task-list/checkbox structure inside a `blockquote` context, which ADF's
  `blockquote.content` content-model rejects (same class of normalization already applied for
  `panel.content` in #483 and `listItem.content` in #470). Removing or no-op'ing the arm would
  produce invalid ADF → Jira 400 for `> - [ ] item` input.
- The builder's state-capture logic can rely on the marker arriving as the **first child after
  `Start(Item)`** in both top-level and blockquote contexts — a single code path handles both;
  no separate in-blockquote ordering branch is needed.

---

## Sources

**Primary (ground truth — resolved crate source read on disk):**
- `~/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/pulldown-cmark-0.13.3/src/firstpass.rs`
  (container loop ~106; blockquote branch :230; list-marker + `ENABLE_TASKLISTS` task scan
  :128–160; `ItemBody::TaskListMarker` construction :147)
- `…/pulldown-cmark-0.13.3/src/parse.rs` (`item_to_event` :2269 `ItemBody::TaskListMarker(checked)
  => Event::TaskListMarker(checked)`; allowed-children :166)
- `…/pulldown-cmark-0.13.3/src/lib.rs` (`Event::TaskListMarker(bool)` :611)
- `…/pulldown-cmark-0.13.3/tests/suite/gfm_tasklist.rs` (`gfm_tasklist_test_1`,
  `gfm_tasklist_test_2`)
- `Cargo.toml` (`pulldown-cmark = "0.13"`), `Cargo.lock` (resolved `0.13.3`, checksum
  `7c3a14896dfa883796f1cb410461aef38810ea05f2b2c33c5aded3649095fdad`)

**Secondary (confirming cross-check):**
- docs.rs — `pulldown_cmark::Event::TaskListMarker`
  (https://docs.rs/pulldown-cmark/latest/pulldown_cmark/enum.Event.html)
- pulldown-cmark GitHub repo (https://github.com/pulldown-cmark/pulldown-cmark)
- Perplexity `sonar-deep-research` synthesis (2026-06-10) over the above

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Cross-validate top-level + blockquote-nested `TaskListMarker` event ordering against docs.rs / GitHub |
| Context7 | 0 (unavailable) | Attempted `resolve-library-id` for pulldown-cmark; tool not available in this environment (see note) |
| Read (local crate source) | 4 | `firstpass.rs`, `parse.rs`, `gfm_tasklist.rs`, `serde.rs` — PRIMARY ground-truth evidence |
| Grep | 3 | Locate `TaskListMarker`, version pins, crate source path |
| Glob | 5 | Locate resolved crate source + test fixtures on disk |
| Training data | 0 areas | Not relied upon — all claims sourced to crate source or docs |

**Total MCP tool calls:** 1 (`perplexity_research`). Context7 was attempted but unavailable
(`mcp__context7__resolve-library-id` → "No such tool available"); the MCP gate is satisfied by the
`perplexity_research` call, and the strongest evidence is the direct read of the resolved crate
source, which supersedes any docs lookup.
**Training data reliance:** low — the verdict rests on direct reads of the pinned
`pulldown-cmark-0.13.3` source (`firstpass.rs` control flow + `parse.rs` event mapping) and the
crate's own HTML snapshot suite, cross-checked against docs.rs via Perplexity.
