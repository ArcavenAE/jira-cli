---
document_type: delta-analysis
issue: 522
title: "fix(adf): normalize lone \\r in push_text — heading and codeBlock text nodes must not contain raw CR"
intent: bug-fix
severity: MEDIUM
feature_type: backend
trivial_scope: true
routing: quick-dev (F1 → F4 single story → regression → F7 lite → PATCH)
root_cause_bc: BC-7.2.011 (INV-1 extension; new AC under same BC or new BC-7.2.012)
regression_risk: LOW
created: "2026-06-16"
---

# Phase F1 Delta Analysis — Issue #522

> **WARNING: SUPERSEDED IN PART BY F5**
>
> The uniform `\r`→`\n` normalization design described below was found during F5
> adversarial review to violate INV-1 (it would create a raw `\n` in non-codeBlock
> text nodes, which Jira rejects). The IMPLEMENTED contract is CONTEXT-AWARE:
>
> - **non-codeBlock** (heading, paragraph, inline code spans, list items, table cells,
>   blockquote, panel, inline marks): `\r\n` and lone `\r` → **SPACE**
>   Example: `"# x\ry"` → heading text node `"x y"` (not `"x\ny"`)
>   Example: `` `a\rb` `` → inline code text node `"a b"` (not `"a\nb"`)
> - **codeBlock**: `\r\n`→`\n`, lone `\r`→`\n` (multi-line code with LF is valid ADF)
>   Example: `"\ta\r"` → codeBlock text node `"a\n"`
> - **HtmlBlock**: CR untouched at `push_text`/`push_code` — Algorithm B (the
>   HtmlBlock end handler) owns CR normalization for that path independently.
>
> **Authoritative source:** BC-7.2.011 EC-11 (v1.9.9) in
> `.factory/specs/prd/bc-7-output-render.md`. Commit 7968d66.
>
> - **`strict_cr` parameter was REMOVED (not flipped to `true`):** the implemented
>   `assert_no_raw_newline_in_text_nodes` helper takes only `(adf, input)` — the
>   `strict_cr` bool was eliminated and the `\r` check is now unconditional. All
>   §4.1/§6.2/§8 references to "flip `strict_cr=false` → `strict_cr=true`" are
>   superseded by this removal.
>
> Per-site supersession annotations are inline below, prefixed **[SUPERSEDED]**.

## Feature / Bug Summary

**GitHub Issue #522:** A lone `\r` (U+000D carriage return without a following `\n`)
survives the generic `Event::Text → push_text` parser path in `markdown_to_adf`
(`src/adf.rs`) into **heading** and **codeBlock** ADF text nodes.

CommonMark §2.3 specifies line-ending normalization (lone CR → LF). pulldown-cmark
0.13 does not perform this normalization on the `Event::Text` path. A raw `\r`
inside an ADF text node is a JSON-level hazard — U+000D is invalid unescaped in
JSON strings — the same bug class as the raw-`\n` defect fixed for block HTML in
#492.

**Minimal repros (pinned in `test_lone_cr_survives_pre_existing_492_oos`):**
- `markdown_to_adf("# x\ry")` → heading text node contains `\r`
- `markdown_to_adf("\ta\r")` → codeBlock text node contains `\r`

This test is `#[ignore]`d and documents the current **buggy** behavior; the fix
must invert its assertions and flip the proptest's `strict_cr` argument to `true`.

---

## 1. Impact Boundary

### 1.1 Chokepoint Selection

**Best chokepoint: `AdfBuilder::push_text` at `src/adf.rs::AdfBuilder::push_text`
(line 1071–1085).**

Rationale:

1. `push_text` is the single convergence point for ALL `Event::Text` and
   `Event::InlineHtml` content entering the ADF tree through the generic parser
   path (line 396–398 in `process`):
   ```
   Event::Text(text) => self.push_text(text.as_ref()),
   Event::Html(html) | Event::InlineHtml(html) => self.push_text(html.as_ref()),
   ```
2. Every block type that receives inline text goes through this path: heading,
   paragraph, list items, table cells, blockquotes, footnote definitions, task
   items. The chokepoint is block-type-agnostic.
3. `push_code` at line 1087–1103 handles `Event::Code` (inline code spans). It
   builds a `text` node with a `code` mark. A `\r` in an inline code span is the
   same JSON hazard. This path is also a chokepoint candidate.
4. The `#492` Algorithm B `NodeKind::HtmlBlock` handler (line 914–983) already
   normalizes CR independently at its own Step 3 (`trimmed.replace("\r\n",
   "\n").replace('\r', "\n")`). That handler does NOT route through `push_text`
   (see code comment at line 951: "do NOT route through push_text… would break
   the direct-content-array build"). No conflict or double-normalization risk.

**[SUPERSEDED] Normalization to apply** (the sketch below is the original F1 design —
uniform `\r`→`\n` for all paths. The F5-implemented contract is context-aware; see
banner above. The actual implementation in commit 7968d66 applies `\r`→space in
non-codeBlock context and `\r`→`\n` only in codeBlock context.):
```rust
// SUPERSEDED DESIGN — uniform \r→\n for all paths (NOT implemented).
// Actual: context-aware — see BC-7.2.011 EC-11 and commit 7968d66.
fn push_text(&mut self, text: &str) {
    // Normalize CR line endings before building the ADF text node.
    // CommonMark §2.3: lone \r → \n (pulldown-cmark 0.13 does not normalize
    // this on the Event::Text path). A raw \r in a JSON string is invalid
    // (U+000D). Mirrors Algorithm B step 3 in NodeKind::HtmlBlock end handler.
    // Note: \r\n → \n first to avoid double-counting CRLF as two newlines.
    let normalized;
    let text = if text.contains('\r') {
        normalized = text.replace("\r\n", "\n").replace('\r', "\n");
        &normalized
    } else {
        text
    };
    // ... rest of existing logic unchanged
}
```

The same normalization must be applied in `push_code` for `Event::Code` (inline
code spans — same JSON hazard). **(SUPERSEDED — actual: non-codeBlock inline code
also uses `\r`→space, not `\r`→`\n`; see banner above.)**

### 1.2 Functions to Modify

| Symbol | Change Type | Lines (approx) | Reason |
|--------|-------------|----------------|--------|
| `AdfBuilder::push_text` | MODIFIED | 1071–1085 | Primary chokepoint for Event::Text + InlineHtml |
| `AdfBuilder::push_code` | MODIFIED | 1087–1103 | Inline code span (Event::Code) — same hazard class |

No other functions require modification. The `NodeKind::HtmlBlock` end arm is
already CR-normalized (Algorithm B step 3) and is not touched.

---

## 2. Blast Radius

Every block type that passes through `push_text` is in scope. This is **uniformly
safe** for all of them:

| Block type reaching push_text | Via NodeKind | CR-normalization correct? |
|-------------------------------|-------------|--------------------------|
| `heading` | `NodeKind::Heading` | YES — heading text must never contain control chars |
| `paragraph` | `NodeKind::Paragraph` | YES — already no-CR invariant (INV-1, strict_cr scope expands) |
| `codeBlock` | `NodeKind::CodeBlock` | YES — `\r` is invalid in codeBlock text too; `\n` in codeBlock IS valid ADF, so `\r\n`→`\n` and `\r`→`\n` are safe transforms that preserve line structure *(context-aware `\r`→`\n` for codeBlock is correct and matches the implemented contract)* |
| `bulletList` / `orderedList` / `listItem` | `NodeKind::ListItem` etc. | YES — inline text in list items must be CR-free |
| `taskItem` | `NodeKind::TaskItem` | YES — inline text only; `\r` invalid |
| `blockquote` | `NodeKind::BlockQuote` | YES |
| `panel` | `NodeKind::Panel` | YES |
| `tableCell` / `tableHeader` | `NodeKind::TableCell` | YES |
| inline marks (em, strong, link, subsup, strike) | `NodeKind::InlineMark` | YES — push_text is called with the mark stack active; normalization is mark-agnostic |
| `footnoteDefinition` (flushed at finish) | internal | YES |
| inline HTML (`Event::InlineHtml`) | same line as `Event::Html` | YES — same path as Event::Text |

**No path intentionally preserves CR.** There is no ADF node type that requires
or permits a raw `\r` in a text node content string. The `codeBlock` exemption in
INV-1 applies to `\n` (multi-line code is valid as a single text node with LF
newlines, which Jira accepts) — it does NOT apply to `\r`. **(SUPERSEDED — see
banner above for the context-aware outcome: non-codeBlock `\r`→space so that no raw
`\n` is injected into a heading/paragraph/inline-code text node; codeBlock `\r`→`\n`
as stated here. The claim "`\r\n` and lone `\r` become `\n`" is correct only for
the codeBlock context.)**

**`push_code` blast radius:** `Event::Code` maps to inline code spans. The `code`
mark in ADF does not grant a CR exemption (only `codeBlock` interiors carry the
`\n` exemption, and only in the `in_code_block` check in `assert_no_raw_newline_in_text_nodes`).
Normalizing `\r` in `push_code` is uniformly correct. **(SUPERSEDED — actual
implemented behavior: `push_code` applies `\r`→space since inline code spans are NOT
codeBlock context; the F1 claim "uniformly correct" meaning `\r`→`\n` was superseded
by the context-aware contract. `` `a\rb` `` → `"a b"`, not `"a\nb"`.)**

---

## 3. Interaction with #492 Algorithm B

The `NodeKind::HtmlBlock` end arm (line 914–983) already performs CR normalization
independently in its Step 3 (line 943):
```rust
let normalized = trimmed.replace("\r\n", "\n").replace('\r', "\n");
```
This path explicitly bypasses `push_text` (see comment at line 951–953):
> "Build the content Vec directly — do NOT route through push_text (which applies
> active_marks; HtmlBlock has no active marks, but routing through it would also
> break the direct-content-array build)."

Therefore:
- The block-HTML handler normalizes CR on its own, BEFORE building text nodes.
- Adding CR normalization to `push_text` does NOT affect the block-HTML handler
  because that handler never calls `push_text` for its output content.
- No double-normalization: the block-HTML text nodes are built directly via
  `json!({"type":"text","text": seg})` on already-normalized segments; they never
  pass through `push_text`.
- The `prop_492_block_html_holds_core_invariants` proptest continues to pass
  unchanged (`strict_cr=true` remains correct there).

The fix is **additive**: it extends INV-1's CR guarantee to cover the generic
parser path, closing the gap the #492 scope note explicitly documented as
out-of-scope.

---

## 4. Regression Risk

**Risk: LOW**

### 4.1 Tests That Must Change

| Test | Location | Change Required |
|------|----------|-----------------|
| `test_lone_cr_survives_pre_existing_492_oos` | `src/adf.rs::tests` ~line 9280 | **INVERT assertions**: change `assert!(…any(|t| t.contains('\r')),…)` to `assert!(…all(|t| !t.contains('\r')),…)`; remove `#[ignore]`; rename to match `test_<verb>_<subject>_<expected_outcome>` convention (e.g. `test_push_text_normalizes_lone_cr_in_heading_and_code_block`) |
| `prop_492_arbitrary_string_holds_core_invariants` | `src/adf.rs::tests` ~line 9180 | **Flip `strict_cr` argument from `false` to `true`**: change `assert_no_raw_newline_in_text_nodes(&adf, &input, false)` to `assert_no_raw_newline_in_text_nodes(&adf, &input, true)`. The `\r` exemption comment in that call site (`strict_cr=false: pre-existing defect`) must be removed and replaced with the post-fix rationale. **(SUPERSEDED — `strict_cr` was REMOVED entirely; helper is now `assert_no_raw_newline_in_text_nodes(adf, input)` with no bool; the `\r` check is unconditional.)** |

### 4.2 Snapshot Tests

The two insta snapshot tests (`test_markdown_to_adf_snapshot` / `test_adf_to_text_snapshot`)
use inputs constructed with Rust `concat!` and `\n` newlines only — no `\r` characters.
These snapshots are **not affected** by the CR normalization.

### 4.3 Proptest Interactions

The `prop_492_block_html_holds_core_invariants` property uses `gen_block_html()` and
already asserts `strict_cr=true`. This property is not affected.

The `prop_492_block_html_round_trip_line_structure_lossless` property asserts
line-structure losslessness for block-HTML inputs. Not affected — block-HTML CR
normalization is pre-existing in Algorithm B.

After the fix, `prop_492_arbitrary_string_holds_core_invariants` with `strict_cr=true`
will also randomly generate inputs containing lone `\r` (Rust `".*"` generates
arbitrary Unicode, including CR) and assert the fix holds across all of them. This
is the desired outcome — the property becomes a regression harness for the fix.

### 4.4 `adf_to_text` Round-Trip Implications

`adf_to_text` reads ADF JSON and renders to text. A heading text node with `"x\ry"`
would render as `# x\ry` in the current (buggy) state. **(SUPERSEDED — see banner
above. After the fix, the input `"# x\ry"` produces a heading text node with `"x y"`
(CR normalized to SPACE in non-codeBlock context, not `"x\ny"`), and `adf_to_text`
renders it as `# x y` on a single line. The original F1 analysis below is stale:)**

~~After the fix, the input `"# x\ry"` produces a heading text node with `"x\ny"` (CR
normalized to LF), and `adf_to_text` renders it as:~~
```
# x y
```
*(Actual implemented outcome: `"x y"` on one line — non-codeBlock `\r`→space.)*

The `AdfRenderer::finish()` method applies `.trim_end()` which already strips
trailing whitespace from the rendered string.

No existing `adf_to_text` test passes ADF with literal `\r` in text nodes, so no
round-trip tests break.

---

## 5. BC Mapping

### Decision: Extend BC-7.2.011 with a new acceptance criterion; do NOT create BC-7.2.012.

**Rationale:**

BC-7.2.011 is the authority for the "no raw control character in ADF text nodes"
invariant (INV-1). The existing BC body and proptest comments explicitly document
this defect as a "pre-existing, out-of-scope parser CR gap" deferred from the #492
delta. The fix closes that gap.

The `strict_cr` boolean in `assert_no_raw_newline_in_text_nodes` was introduced
SPECIFICALLY to track when this fix lands: the rustdoc at line 8902 says:
> "strict_cr = false (arbitrary-markdown inputs): the `\r` clause is NOT asserted.
> A lone `\r` surviving into a NON-block-HTML text node… is a SEPARATE,
> PRE-EXISTING defect… pinned by the `#[ignore]`d regression for a follow-up fix."

This is not a new behavioral contract — it is a repair to an existing invariant
(INV-1) that was left with a documented gap. Adding a new acceptance criterion to
BC-7.2.011 is the correct governance action.

**New acceptance criterion to add to BC-7.2.011:**
> **(AC-new) `push_text` CR normalization:** `markdown_to_adf` must not produce any
> ADF text node (in any block type: heading, paragraph, codeBlock, listItem,
> taskItem, tableCell, blockquote, panel, or inline mark) containing a raw `\r`
> (U+000D) character. A lone `\r` in the input is normalized to `\n` at the
> `push_text` / `push_code` chokepoints before the text node is built. This extends
> INV-1's CR-free guarantee from block-HTML-only (Algorithm B) to the full generic
> parser path. Mirrors CommonMark §2.3 (lone CR is a line ending).
>
> **(SUPERSEDED — the "normalized to `\n`" claim in this AC draft is the original F1
> design. The authoritative EC-11 (v1.9.9) in BC-7.2.011 reflects the context-aware
> contract: non-codeBlock `\r`→space; codeBlock `\r`→`\n`; HtmlBlock untouched.
> Commit 7968d66. Do not use this AC draft as a spec reference.)**

The BC-7.2.011 frontmatter `total_bcs` and `definitional_count` do NOT change
(this is a new AC in an existing BC, not a new BC heading). The BC-INDEX row for
BC-7.2.011 summary text should be updated to mention the CR fix.

---

## 6. Affected Test Inventory

### 6.1 Pinned Regression Test (INVERT + DE-IGNORE)

| Test | File | Action |
|------|------|--------|
| `test_lone_cr_survives_pre_existing_492_oos` | `src/adf.rs` ~L9280 | Remove `#[ignore]`, invert both `assert!` calls: `any(…contains('\r'))` → `all(…!contains('\r'))`, rename to `test_push_text_normalizes_lone_cr_in_heading_and_code_block` |

### 6.2 Proptest Knob (FLIP)

| Property | File | Change |
|----------|------|--------|
| `prop_492_arbitrary_string_holds_core_invariants` | `src/adf.rs` ~L9180 | Change `strict_cr=false` → `strict_cr=true`; update the inline comment from "pre-existing out-of-#492-scope defect" to "fixed in #522: push_text normalizes lone \\r" **(SUPERSEDED — `strict_cr` was REMOVED entirely; helper is now `assert_no_raw_newline_in_text_nodes(adf, input)` with no bool; the `\r` check is unconditional.)** |

### 6.3 New Tests to Add

These should be in-file unit tests in `src/adf.rs::tests`, following the
`test_<verb>_<subject>_<expected_outcome>` naming convention:

| Test | Covers |
|------|--------|
| `test_push_text_normalizes_lone_cr_in_heading_and_code_block` | The two repros from the issue pinned in the de-ignored test: `"# x\ry"` and `"\ta\r"` |
| `test_push_text_normalizes_crlf_in_paragraph` | **(SUPERSEDED — this test was RENAMED to `test_push_text_normalizes_lone_cr_in_fenced_code_block` in the F5-implemented contract. The original F1 expectation "`"hello\r\nworld"` → paragraph text nodes contain `\n` or `hardBreak`" is wrong: paragraph is non-codeBlock so `\r\n`→space, not `\n`/hardBreak. The renamed test covers a codeBlock context where `\r\n`→`\n` is correct.)** |
| `test_push_code_normalizes_lone_cr_in_inline_code` | `` "`a\rb`" `` → inline code span text node is `"a\nb"` **(SUPERSEDED — actual: `"a b"`, not `"a\nb"`. Inline code spans are non-codeBlock context; `\r`→space. See banner above.)** |

### 6.4 Tests NOT Affected

| Test / Property | Reason |
|-----------------|--------|
| `prop_492_block_html_holds_core_invariants` | Block-HTML CR normalization is pre-existing in Algorithm B; `strict_cr=true` unchanged |
| `prop_492_block_html_round_trip_line_structure_lossless` | Block-HTML path; unchanged |
| `test_block_html_lone_cr_interior_produces_single_hardbreak` | Handler unit test for Algorithm B; unchanged |
| `test_markdown_to_adf_snapshot` / `test_adf_to_text_snapshot` | Use LF-only inputs; snapshots not affected |
| All `test_markdown_task_*` / `test_task_*` / `test_nested_task_*` | Task list tests use LF-only inputs |
| All `test_markdown_alert_*` / `test_render_panel_*` | GFM alert / panel tests use LF-only inputs |
| All `test_bare_*` / URL autolink tests | URL tests use LF-only inputs |
| `tests/e2e_live.rs`, `tests/e2e_cli_surface_guard.rs` | No ADF-layer impact |

---

## 7. Classification

| Field | Value |
|-------|-------|
| Intent | `bug-fix` |
| Feature type | `backend` |
| Severity | MEDIUM — functionality impaired for inputs with lone `\r`; no workaround at the API level (the raw `\r` reaches Jira as invalid JSON); does not affect the common case (LF-only inputs) |
| Trivial scope | YES — single function + companion, no new BCs, no architecture change, no new external dependencies, no new NodeKind variants |
| Routing | **Quick dev: F1 → F4 (single story) → regression suite → F7 lite → PATCH** |

---

## 8. Impact Assessment Table

| Artifact | Change Type | Notes |
|----------|-------------|-------|
| `src/adf.rs::AdfBuilder::push_text` | MODIFIED | Add CR normalization before text node construction |
| `src/adf.rs::AdfBuilder::push_code` | MODIFIED | Same normalization for inline code spans |
| `src/adf.rs::tests::test_lone_cr_survives_pre_existing_492_oos` | MODIFIED | Remove `#[ignore]`; invert assertions; rename |
| `src/adf.rs::tests::prop_492_arbitrary_string_holds_core_invariants` | MODIFIED | Flip `strict_cr=false` → `strict_cr=true`; update comment **(SUPERSEDED — `strict_cr` was REMOVED entirely; helper is now `assert_no_raw_newline_in_text_nodes(adf, input)` with no bool; the `\r` check is unconditional.)** |
| `src/adf.rs::tests` | NEW tests | 3 new focused unit tests (see §6.3) |
| `.factory/specs/prd/bc-7-output-render.md` | MODIFIED | Add new AC to BC-7.2.011 body; update BC-INDEX row summary text |

### Files NOT Changed (Regression Baseline)

- `src/adf.rs::AdfBuilder::NodeKind` — no new variants
- `src/adf.rs::markdown_to_adf` — no options change
- `src/adf.rs::AdfBuilder::start` / `::end` — no new arms
- `src/adf.rs::NodeKind::HtmlBlock` end arm — Algorithm B unchanged
- `src/adf.rs::adf_to_text` / `AdfRenderer` — no change (renders text nodes as-is; normalization is on the write path)
- `src/api/`, `src/cli/`, `src/types/`, `src/cache.rs`, `src/config.rs`, `src/output.rs` — zero impact
- `Cargo.toml` — no new dependencies
- All `bc-*.md` files except `bc-7-output-render.md`
- `CANONICAL-COUNTS.md` — no count change (no new BC heading)
- `BC-INDEX.md` — only BC-7.2.011 summary text update (not a row addition)

---

## 9. Risks for Subsequent Phases

1. **`push_code` normalization confirmation:** The bug report and pinned test focus
   on `Event::Text` (heading, codeBlock via indented-code path). The `Event::Code`
   path (`push_code`) is structurally identical — it builds a `text` node with the
   same `text: text` field. Confirm with a `\r`-containing inline code span test
   before the PR merges.

2. **`SoftBreak` path:** `Event::SoftBreak` maps to `self.push_text(" ")` — a
   fixed single space, no CR risk. Safe.

3. **`Event::Html` vs `Event::InlineHtml` distinction:** Both map to `push_text`
   at line 398. Inline HTML is NOT block HTML (no Algorithm B wrapper). A lone `\r`
   in inline HTML (e.g., `<em>\rx</em>` inside a paragraph) currently survives into
   the text node. The fix at `push_text` covers this path too — this is the correct
   behavior.

4. **`prop_492_arbitrary_string_holds_core_invariants` with `strict_cr=true`:**
   After the flip, the proptest will run 2048 cases including some with lone `\r`.
   If any remaining CR-producing path is missed (e.g., a hypothetical inline
   construct not covered by push_text/push_code), the property will catch it. This
   is the desired safety net.

5. **CLAUDE.md gotcha entry:** The BC-7.2.011 gotcha in `CLAUDE.md` references the
   `#492` block-HTML work. After this fix, the description of the "no raw `\n` in
   text nodes" invariant should note that `\r` is also normalized across all paths
   (not just block HTML). A one-line update to the existing entry is sufficient.

---

## 10. Routing Decision

**Quick dev routing.** Justification:
- Single function pair (push_text + push_code) — no architectural change
- No new BCs — one new AC in existing BC-7.2.011
- No new NodeKind variants, no new parser options, no Cargo.toml change
- Regression risk LOW — the fix is confined to the `push_text` / `push_code`
  bodies; no existing test uses CR-containing non-HTML markdown inputs
- Consistent with the quick-dev pattern: single story, worktree, TDD, PR, review,
  security check (src/adf.rs is NOT in the CRITICAL or HIGH module-criticality
  tier for security — it is a pure data-transformation module), regression suite,
  F7 lite convergence, PATCH release

**Estimated effort:** 1 story point. The implementation is 4–6 lines of code in
two functions; the bulk of the work is updating the test assertions and the BC.
