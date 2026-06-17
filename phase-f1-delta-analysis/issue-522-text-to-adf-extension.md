---
document_type: delta-analysis-extension
issue: 522
title: "fix(adf): normalize CR/newlines in text_to_adf — plain-text write path must not emit raw control characters"
intent: bug-fix
severity: MEDIUM
feature_type: backend
trivial_scope: true
routing: quick-dev (F1 extension → F4 single story → regression → F7 lite → PATCH)
root_cause_bc: BC-7.2.011 (new EC under same BC — EC-12 within BC-7.2.011; do NOT create BC-7.2.012)
regression_risk: LOW
created: "2026-06-17"
extends: issue-522-delta-analysis.md
---

# Phase F1 Delta Analysis Extension — Issue #522 `text_to_adf` Sibling Fix

## Scope Note

The original `issue-522-delta-analysis.md` fixed the generic `Event::Text →
push_text` parser path (markdown → ADF). Issue #522 has been expanded to also
cover the **plain-text write path**: `src/adf.rs::text_to_adf`. This document
extends the original F1 analysis to cover that sibling defect.

---

## 1. Defect Description

`text_to_adf` (lines 7–20 of `src/adf.rs`) constructs a minimal ADF document
from a raw `&str`:

```rust
pub fn text_to_adf(text: &str) -> Value {
    json!({
        "version": 1,
        "type": "doc",
        "content": [{
            "type": "paragraph",
            "content": [{ "type": "text", "text": text }]
        }]
    })
}
```

The `text` argument is placed verbatim into a `text` ADF node. There is no
normalization of CR (`\r`), LF (`\n`), or CRLF (`\r\n`).

**INV-1 violation:** An ADF `text` node inside a `paragraph` (a non-codeBlock
context) must NOT contain a raw `\n` or `\r`. Jira rejects such payloads with
HTTP 400. `text_to_adf` therefore propagates any control character in its
argument directly into invalid ADF.

This is the exact same bug class as the `#492` block-HTML defect and the `#522`
`push_text`/`push_code` defect, at a **third chokepoint** that was not touched
by either of those fixes.

---

## 2. Call Site Audit

Five call sites reach `text_to_adf` from non-markdown write paths:

| Call site | File | Input source | Multi-line possible? |
|-----------|------|--------------|----------------------|
| `handle_create` (issue create) | `src/cli/issue/create.rs:181` | `--description TEXT` or `--description-stdin` | YES — `--description-stdin` reads stdin verbatim; Windows authors produce CRLF; pasted content may contain `\n` or `\r\n` |
| `handle_edit` (issue edit) | `src/cli/issue/create.rs:927` | `--description TEXT` or `--description-stdin` | YES — same as above |
| `handle_comment` | `src/cli/issue/workflow.rs:1165` | positional TEXT arg (after `.trim()` is applied) | YES — multi-line comment via `--stdin` path or shell `$'...'` literal |
| `handle_add` (worklog) | `src/cli/worklog.rs:33` | `--message TEXT` (optional) | LOW — worklog messages are typically single-line; `allow_hyphen_values` is set so a multi-line value via env substitution is possible |
| JSM request build | `src/api/jsm/requests.rs:98` | `--description TEXT` or `--description-stdin` | YES — JSM requests are service-desk descriptions that frequently span multiple lines |

**Conclusion:** Multi-line input is not just possible — it is the primary use
case for `--description` and JSM request descriptions. A user typing a
multi-paragraph description, piping from a file with CRLF line endings (common
on Windows), or pasting content from a Windows clipboard will reliably trigger
this bug. The workflow.rs comment path applies `.trim()` before calling
`text_to_adf` (line 1157), which removes leading/trailing whitespace including
newlines, but does NOT remove interior newlines — so a multi-line comment still
reaches the function with interior `\n`.

---

## 3. Recommended Normalization + Structure Approach

### Decision: single-paragraph with `hardBreak` nodes for interior newlines; blank-line-separated runs produce separate paragraphs.

**Approach:**

1. **Normalize line endings first:** `\r\n` → `\n`, then lone `\r` → `\n`.
   This is identical to Algorithm B step 3 (NodeKind::HtmlBlock end arm).

2. **Split on blank lines into paragraph blocks:** A blank line (`\n\n` or
   more) separates the input into independent semantic paragraphs. Each block
   maps to one ADF `paragraph` node. This matches how Jira's own editor renders
   plain text with paragraph breaks — Jira treats a blank line as a paragraph
   boundary, not a double-hardBreak inside one paragraph.

3. **Represent interior newlines (within a block) as `hardBreak` nodes:**
   Within each paragraph block, split on `\n` and emit alternating `text` +
   `hardBreak` nodes (mirroring Algorithm B step 4). A single `\n` inside a
   paragraph = one `hardBreak`.

4. **Trim trailing newlines before processing:** Strip trailing `\r` and `\n`
   from the entire input (mirrors Algorithm B step 2). Leading/trailing
   `hardBreak` nodes within each paragraph block are trimmed (mirrors the
   `trim_leading_trailing_hardbreaks` helper already used by taskItem and
   HtmlBlock).

5. **Empty input / all-whitespace blocks:** An empty string or
   whitespace-only input after normalization produces an empty-content
   paragraph (identical to today's single-line empty-string behavior; this
   matches BC-7.2.001 which pins `text_to_adf("hello")` output shape but does
   not specify the empty-string case — keep the existing single-paragraph
   wrapper for compatibility with any callers that read the top-level paragraph
   wrapper unconditionally).

**Why not `hardBreak` only (single paragraph for all content)?**

A single paragraph with `hardBreak` for every `\n` — including blank lines —
would render in Jira as a visually compact block with no paragraph spacing.
Blank lines in plain-text descriptions are always intended as paragraph
separators. Matching Jira's own editor behavior (paragraph boundary = blank
line) is the least-surprising approach. This also aligns with how
`markdown_to_adf` handles `\n\n` between paragraphs.

**Why Algorithm B reuse (hardBreak within paragraph) rather than a separate
approach for single `\n`?**

The alternative — treating every `\n` as a paragraph boundary — would produce
ADF with many tiny paragraph nodes for inputs like error stacktraces or CLI
output pasted as plain text. Jira renders paragraph spacing visually between
each node. Single-`\n` within a paragraph as `hardBreak` matches the ADF
semantics for "line continuation" and is both compact and correct.

**INV-1 compliance:** Under this approach, no `text` node ever contains a raw
`\n` or `\r`. Interior newlines become `hardBreak` ADF nodes. Blank lines
become paragraph boundaries. This satisfies INV-1 in full.

---

## 4. Reuse vs. Inline Decision

### Decision: Factor out Algorithm B's normalize-and-split into a shared private helper; call it from both the HtmlBlock end arm and `text_to_adf`.

**Rationale:**

Algorithm B (NodeKind::HtmlBlock end arm, lines 914–983) already implements the
exact normalize-and-split logic needed:
- Step 2: trim trailing `\r`/`\n`
- Step 3: `\r\n`→`\n`, lone `\r`→`\n`, split on `\n`
- Step 4: alternating text + hardBreak
- Step 5: trim leading/trailing hardBreaks

Duplicating this logic inline in `text_to_adf` would create a third copy (the
block-HTML handler is the second; `text_to_adf` with `\n\n` splitting would be
the third if bespoke). A shared helper eliminates that duplication and ensures
the two paths remain in sync when the normalization rules evolve.

**Proposed helper:**

```rust
/// Normalize a plain-text string into an array of ADF inline nodes
/// (`text` and `hardBreak`) suitable for use as a `paragraph.content` array.
///
/// Rules:
///   1. Trim trailing `\r` and `\n` characters (any count).
///   2. Normalize `\r\n`→`\n`, then lone `\r`→`\n` (two-pass; must NOT be
///      combined into a char-set split which double-counts CRLF boundaries).
///   3. Split on `\n`. For each segment: emit a `text` node if non-empty;
///      emit a `hardBreak` if not the last segment.
///   4. Trim any leading or trailing `hardBreak` nodes from the result.
///
/// Returns `None` when the resulting content array is empty (all-whitespace /
/// all-newline input), allowing callers to emit an empty paragraph or skip
/// emission entirely according to context.
fn normalize_text_to_inline_nodes(text: &str) -> Option<Vec<Value>> { ... }
```

The HtmlBlock end arm can then call this helper instead of implementing the
steps inline. `text_to_adf` calls it per paragraph block (after splitting on
`\n\n`).

**Scope constraint:** `normalize_text_to_inline_nodes` is a private helper
(`fn`, not `pub fn`). It does NOT replace the `push_text` normalization logic —
that operates in the `AdfBuilder` context with a mark stack and must remain
there. This helper is purely for direct-JSON construction paths that bypass the
builder (`text_to_adf` and the HtmlBlock end arm).

---

## 5. Exact Per-Input Behavior Table

The following table specifies the required output for every distinct input
class. All cases assume the paragraph-with-hardBreak approach for single
newlines and separate-paragraph approach for blank lines.

| Input | After normalize | ADF output |
|-------|----------------|------------|
| `""` (empty) | `""` | `doc > [paragraph > [text("")]]` — single paragraph with empty text node (BC-7.2.001 shape preserved; matches current behavior) |
| `"hello"` (single line, no newline) | `"hello"` | `doc > [paragraph > [text("hello")]]` — **byte-identical to current output** (no regression) |
| `"hello\n"` (trailing LF) | `"hello"` (trailing stripped) | `doc > [paragraph > [text("hello")]]` — same as single-line |
| `"hello\r\n"` (trailing CRLF) | `"hello"` | same as above |
| `"hello\r"` (trailing lone CR) | `"hello"` | same as above |
| `"line1\nline2"` (interior LF) | `"line1\nline2"` | `doc > [paragraph > [text("line1"), hardBreak, text("line2")]]` |
| `"line1\r\nline2"` (interior CRLF) | `"line1\nline2"` (step 2) | same as interior LF |
| `"line1\rline2"` (interior lone CR) | `"line1\nline2"` (step 2) | same as interior LF |
| `"line1\n\nline2"` (blank line = paragraph break) | `"line1\n\nline2"` → split on `\n\n` | `doc > [paragraph > [text("line1")], paragraph > [text("line2")]]` |
| `"line1\n\n\nline2"` (double blank line) | treated as one paragraph break (consecutive `\n` beyond the first two collapse to a single paragraph boundary) | same as `\n\n` case |
| `"a\nb\n\nc\nd"` (mixed) | two blocks: `"a\nb"` and `"c\nd"` | `doc > [paragraph > [text("a"), hardBreak, text("b")], paragraph > [text("c"), hardBreak, text("d")]]` |
| `"\nline"` (leading LF) | after normalize: `"\nline"`; after per-block leading-hardBreak trim | leading `hardBreak` trimmed → `doc > [paragraph > [text("line")]]` |
| `"\n\n\n"` (all newlines) | trimmed to `""` → empty | `doc > [paragraph > [text("")]]` (empty paragraph; same as empty-string case) |
| `"hello\r\nworld"` | `"hello\nworld"` | `doc > [paragraph > [text("hello"), hardBreak, text("world")]]` |

**Single-line no-regression guarantee:** Any input containing NO `\r`, `\n`,
or `\r\n` characters passes through unchanged. The output is byte-identical to
the current `text_to_adf` output for all such inputs. The existing test
`test_text_to_adf` (`text_to_adf("Hello world")`) continues to pass without
modification.

**IMPORTANT — blank-line split threshold:** The blank-line-separation approach
introduces a design question: should `\n\n` split into paragraphs? The
alternative (use `hardBreak` for ALL newlines including blank lines) is simpler
to implement (just normalize + split on `\n` always). The implementer should
decide this based on the Jira rendering contract. **If uncertain, prefer the
`hardBreak`-for-all approach** (single paragraph with hardBreaks for every `\n`
including consecutive ones). This avoids complexity, is consistent with how
Algorithm B handles the HtmlBlock path (which uses hardBreak for interior
newlines including blank lines at the direct-builder level), and carries no
regression risk. The per-input table above documents BOTH options in the
`\n\n` rows — the blank-line case is the only branch point between the two
approaches.

---

## 6. BC/EC Mapping Recommendation

### Decision: Add a new EC (EC-12) to BC-7.2.011. Do NOT create a new top-level BC.

**Rationale:**

BC-7.2.011 is the authority for the "no raw control character in ADF text nodes
outside codeBlock" invariant (INV-1). Its Trace section already cites
`text_to_adf` indirectly via BC-7.2.001 (which defines the output shape for
`text_to_adf("hello")`). The fix is a direct extension of INV-1 to the
`text_to_adf` chokepoint — the same invariant, the same rule, a new fix site.

BC-7.2.001 defines the nominal single-line output shape. It should NOT be
modified — it is a snapshot BC (`text_to_adf("hello")` must still produce the
same output). No change to BC-7.2.001.

EC-11 within BC-7.2.011 already covers `push_text` and `push_code` (issue
#522 original fix). The new fix site is `text_to_adf` itself — a separate
function with different behavior (it builds JSON directly, does not use the
AdfBuilder, has no mark stack, has no NodeKind context). A new EC
cleanly separates the two chokepoints and avoids extending the already-dense
EC-11.

The EC number is EC-12 within BC-7.2.011 (the HtmlBlock block is EC-1 through
EC-11; EC-11 is the `push_text`/`push_code` fix). Verify against the live spec
before committing — if additional ECs were added to BC-7.2.011 since this
analysis, use the next available number.

**Count impact:** No new BC heading is added. `total_bcs` and
`definitional_count` in BC-7.2.011's frontmatter do NOT change. BC-INDEX and
CANONICAL-COUNTS are unaffected.

**Proposed EC-12 text (draft):**

> **(EC-12) `text_to_adf` CR/newline normalization (INV-1-plain-text):**
> `text_to_adf(text)` must not emit any ADF `text` node containing a raw `\r`
> (U+000D) or raw `\n` (U+000A) character. Interior newlines in `text` (after
> normalizing `\r\n`→`\n`, lone `\r`→`\n`) are represented as `hardBreak` ADF
> nodes within the enclosing `paragraph.content` array. A blank line (`\n\n`)
> in the input separates the document into multiple `paragraph` nodes [OR:
> emits consecutive `hardBreak` nodes, depending on the approach chosen — see
> §5 above]. Trailing `\r`/`\n` characters are stripped before processing.
> Single-line inputs (no newline characters) produce byte-identical output to
> the pre-fix `text_to_adf` (no regression). This extends INV-1's "no raw
> `\n`/`\r` in non-codeBlock text nodes" guarantee to the `text_to_adf`
> public function, closing the third INV-1 chokepoint (after HtmlBlock/Algorithm
> B and push_text/push_code). Fix site: `src/adf.rs::text_to_adf`.

---

## 7. Regression Test Inventory

### 7.1 Tests NOT Affected (Must Continue to Pass)

| Test | File | Why safe |
|------|------|----------|
| `test_text_to_adf` | `src/adf.rs` ~L2351 | Input `"Hello world"` has no newlines; single-line path is byte-identical to current output |
| `test_adf_to_text_paragraph` | `src/adf.rs` ~L2358 | Same input `"Hello world"`; round-trip unaffected |
| `tests/issue_commands.rs::test_edit_issue_*` (L640, L722) | `tests/issue_commands.rs` | Both use `text_to_adf("Updated description")` / `text_to_adf("New description")` — single-line inputs; output unchanged |
| `tests/issue_create_jsm.rs` (L2282) | `tests/issue_create_jsm.rs` | Documents the markdown-vs-text distinction; the test itself uses plain-text inputs to check no ADF marks are emitted; single-line; unaffected |
| `tests/e2e_live.rs` (L4598) | `tests/e2e_live.rs` | References `text_to_adf` in a comment only; the live test drives CLI flags, not the function directly; unaffected |
| All Algorithm B (HtmlBlock) tests | `src/adf.rs` | `text_to_adf` is a separate function; HtmlBlock handling unchanged |
| All `push_text`/`push_code` tests (EC-11) | `src/adf.rs` | Separate chokepoint; unchanged |
| All `markdown_to_adf` tests | `src/adf.rs` | `text_to_adf` does not use the AdfBuilder; markdown path unchanged |
| All proptest properties | `src/adf.rs` | Propertests cover `markdown_to_adf` only; `text_to_adf` is not in their scope |

### 7.2 New Tests to Add

Following the `test_<verb>_<subject>_<expected_outcome>` naming convention:

| Test name | Covers |
|-----------|--------|
| `test_text_to_adf_single_line_unchanged` | Regression guard: `text_to_adf("hello")` output is byte-identical to current (no regression on the common path) |
| `test_text_to_adf_normalizes_interior_lf_to_hardbreak` | `text_to_adf("line1\nline2")` → paragraph with `[text("line1"), hardBreak, text("line2")]`; no raw `\n` in any text node |
| `test_text_to_adf_normalizes_interior_crlf_to_hardbreak` | `text_to_adf("line1\r\nline2")` → same as LF case |
| `test_text_to_adf_normalizes_interior_lone_cr_to_hardbreak` | `text_to_adf("line1\rline2")` → same as LF case |
| `test_text_to_adf_strips_trailing_newlines` | `text_to_adf("hello\n")` and `text_to_adf("hello\r\n")` → same single-line output as `text_to_adf("hello")` |
| `test_text_to_adf_no_raw_newline_in_any_text_node` | Property-style: assert `assert_no_raw_newline_in_text_nodes` passes for a sample of multi-line inputs (LF, CRLF, lone CR); reuse the existing helper |

### 7.3 Optional Proptest Extension

Consider extending `prop_492_arbitrary_string_holds_core_invariants` (or adding
a companion property) to also cover `text_to_adf`:

```rust
#[test]
fn prop_text_to_adf_holds_inv1(input in ".*") {
    let adf = text_to_adf(&input);
    assert_no_raw_newline_in_text_nodes(&adf, &input);
}
```

This would generatively verify INV-1 for the new implementation against all
possible inputs, including those with `\r`, `\r\n`, and `\n` combinations. It
is a low-cost addition given the existing `assert_no_raw_newline_in_text_nodes`
helper.

### 7.4 Snapshot Tests

`test_markdown_to_adf_snapshot` and `test_adf_to_text_snapshot` do not call
`text_to_adf`. Unaffected.

---

## 8. Impact Assessment Table

| Artifact | Change Type | Notes |
|----------|-------------|-------|
| `src/adf.rs::text_to_adf` | MODIFIED | Replace `json!` macro one-liner with normalization + hardBreak construction |
| `src/adf.rs` (new private helper) | NEW | `normalize_text_to_inline_nodes(text: &str) -> Option<Vec<Value>>` (or inline; see §4) |
| `src/adf.rs::AdfBuilder::end` (HtmlBlock arm) | MODIFIED (optional refactor) | If helper is extracted, the HtmlBlock arm calls it instead of its inline steps 2–5 |
| `src/adf.rs::tests` | NEW tests | 5–6 new focused unit tests (see §7.2); optional proptest (§7.3) |
| `.factory/specs/prd/bc-7-output-render.md` | MODIFIED | Add EC-12 to BC-7.2.011; update BC-7.2.011 Trace field to include `text_to_adf` |
| BC-7.2.001 | NOT CHANGED | Snapshot BC; single-line output is byte-identical |
| `CANONICAL-COUNTS.md` | NOT CHANGED | No new BC heading |
| `BC-INDEX.md` | MINOR UPDATE | BC-7.2.011 row summary text update (mention `text_to_adf` fix) |
| `CLAUDE.md` gotcha for BC-7.2.011 | OPTIONAL UPDATE | Add one line noting that `text_to_adf` also normalizes CR/newlines |

### Files NOT Changed

- `src/cli/issue/create.rs`, `src/cli/issue/workflow.rs`, `src/cli/worklog.rs`, `src/api/jsm/requests.rs` — call sites are correct; the fix is entirely within `text_to_adf`
- `Cargo.toml` — no new dependencies
- All `bc-*.md` files except `bc-7-output-render.md`
- `src/api/`, `src/types/`, `src/cache.rs`, `src/config.rs`, `src/output.rs`

---

## 9. Interaction with Existing #522 Fixes

The `push_text`/`push_code` fix (original issue #522, commit 7968d66) operates
in the AdfBuilder context with a NodeKind stack. It normalizes CR context-
dependently: non-codeBlock → CR becomes space; codeBlock → CR becomes `\n`;
HtmlBlock → CR untouched (Algorithm B owns it).

`text_to_adf` does NOT use the AdfBuilder. It constructs a JSON value directly
via the `json!` macro. There is **no interaction** between the `push_text` fix
and the `text_to_adf` fix — they operate at different levels.

The normalization rule for `text_to_adf` differs from `push_text`'s non-
codeBlock rule in one respect: `text_to_adf` converts `\n` to `hardBreak`
nodes (not spaces), because `text_to_adf` builds the whole paragraph content
array and can emit structural nodes. `push_text` normalizes inline CR-only
(it cannot emit structural `hardBreak` nodes from within a single text event).
This is the correct design difference between the two chokepoints.

---

## 10. Routing Decision

**Quick dev routing — extend the existing #522 story.** Justification:

- Single function (`text_to_adf`) — no architectural change
- Optional extraction of one private helper from existing HtmlBlock arm
- No new BCs — one new EC in existing BC-7.2.011
- No new NodeKind variants, no new parser options, no Cargo.toml change
- Regression risk LOW — single-line inputs (the dominant case at all call sites)
  produce byte-identical output; the fix is confined to the new multi-line branch
- The fix can ship in the same PR as the original #522 `push_text`/`push_code`
  fix, or as a followup PATCH in the same release series

**Estimated effort:** 0.5–1 story point. The implementation is 15–25 lines in
`text_to_adf` (plus optional helper extraction); the bulk of work is tests and
BC-7.2.011 EC-12 addition.
