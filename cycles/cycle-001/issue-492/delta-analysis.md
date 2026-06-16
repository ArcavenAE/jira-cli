---
issue: 492
phase: F1-delta-analysis
title: "Block-HTML ADF Fix — Retrospective F5 Findings"
date: 2026-06-15
routing: bug-fix
---

# Phase F1 Delta Analysis — Issue #492

## Classification

**Bug-fix routing** — all five findings address correctness or spec gaps in
`src/adf.rs` introduced by the #489 block-HTML preservation PR. No new
capability; no PRD scope expansion required.

---

## Impact Boundary

### Primary file

`src/adf.rs` — single file, all changes scoped here.

### Exact locations

| Finding | Location | Lines (approx.) |
|---------|----------|-----------------|
| F-1 interior-newline violation | `NodeKind::HtmlBlock` end-handler | adf.rs ~914–936 |
| F-4 CRLF/multi-newline trim | `text.strip_suffix('\n')` call | adf.rs ~928 |
| F-2 inaccurate comment | comment block above HtmlBlock handler | adf.rs ~915–921 |
| F-3 missing tests | `adf::tests` module | adf.rs ~6880+ |
| F-O missing spec | `docs/specs/` (no file) | filesystem |

### Functions touched

- `AdfBuilder::end()` — `NodeKind::HtmlBlock` arm (F-1, F-4)
- `HtmlBlock` docstring comment (F-2)
- Test module `adf::tests` (F-3)

### Regression-risk surface

1. `autolink_bare_urls` / `split_text_node_on_urls` — the HtmlBlock end-handler
   emits a single `paragraph > text` node into the root content array. After
   `finish()`, `autolink_bare_urls` walks the tree and will process the HtmlBlock
   text node the same as any other text node. If the text contains a bare
   `http(s)://` URL the node will be **split into multiple text nodes** (the URL
   run gains a `link` mark). This fragmentation is safe in terms of ADF
   structure, but if F-1 is fixed by option (a) (splitting on interior newlines),
   each sub-segment will be autolink-scanned independently — the interaction is
   benign but must be covered by the missing F-3 test.

2. `test_convert_multiline_block_html_preserves_interior_newlines` — this test
   currently **asserts the buggy behavior** (raw `\n` in text). It MUST be
   replaced (option a) or updated (option b) as part of the fix; it cannot be
   left as-is after F-1 is resolved.

3. `test_block_html_round_trips_through_adf_to_text` — currently passes because
   `adf_to_text` renders a `paragraph > text` node then appends `\n`. For a
   single-line case the text is newline-free and the round-trip is clean. For a
   multi-line case (option a), the round-trip becomes `line1\nline2` (hardBreak
   renders as `\n` in `adf_to_text`), which is reasonable but not currently
   tested. The new `test_multiline_block_html_round_trips_through_adf_to_text`
   test (F-3) must pin this.

4. No other callers of `NodeKind::HtmlBlock` exist. The `Tag::HtmlBlock` start
   arm simply pushes the node kind; the end arm is the only logic site.

---

## Governing BC

**BC-7.2** (ADF Rendering, `bc-7-output-render.md`) covers the full
`markdown_to_adf` surface. BC-7.2.003 pins the complex markdown→ADF snapshot
and states "round-trip covers: headings, lists, code blocks, blockquotes,
tables, links" — block HTML is not enumerated there, which is why #489 did not
add a BC entry.

**There is currently no dedicated BC for block-HTML→ADF behavior.** The #489
CLAUDE.md gotcha documents the behavior inline but there is no formal BC.

### Does the current behavior violate an existing BC?

The file-wide "text nodes must be newline-free" invariant is asserted by tests
(adf.rs ~2736–2738 and ~2795–2798) but is not formally articulated in any named
BC. The tests demonstrate it is a de-facto file-wide invariant. The HtmlBlock
end-handler violates this invariant by placing raw `\n` characters inside a
`text` node's `"text"` field.

**BC verdict: the existing behavior is a bug against the file-wide invariant
enforced everywhere else.** No BC version bump is required — the fix brings
HtmlBlock into conformance with the invariant that all other handlers already
satisfy. A new BC entry (BC-7.2.011) should be added to formally anchor
block-HTML→ADF behavior, but it should describe the correct (fixed) behavior,
not the current buggy behavior.

---

## Finding-by-Finding Disposition

### F-1 (HIGH): Interior newlines in text node — fix now

**Severity:** HIGH — violates the file-wide "text nodes must be newline-free"
invariant that is enforced by existing tests and observed everywhere else in the
file (SoftBreak → space, sanitize_table_cell_text strips `\r\n`,
flatten_table_to_paragraphs emits newline-free nodes, hardBreak is the canonical
ADF intra-paragraph line break).

**Recommended direction: Option (a) — split on interior newlines into
hardBreak-segmented text nodes.**

Rationale:

1. **Convention alignment is unambiguous.** The ADF schema's canonical intra-
   paragraph line break is `hardBreak`. The file uses it throughout: `Event::HardBreak`
   → `append_child(json!({ "type": "hardBreak" }))`, taskItem EC-16 uses it to
   separate paragraph runs, and `adf_to_text` renders `hardBreak` as `\n`.
   Option (b) (collapse `\n`→space) loses semantic information (newlines become
   spaces, hiding the multi-line structure of the HTML), which is worse fidelity
   than option (a).

2. **Option (c) (confirm Jira accepts raw `\n`) is moot as a disposition
   decision.** Even if Jira happens to accept raw `\n` today, the behavior would
   violate an invariant enforced by the rest of the file, be inconsistent with
   how every other newline-producing event is handled, and be fragile to Jira-
   Cloud API schema enforcement changes. The research result frames the risk, not
   the design decision: if Jira currently accepts raw `\n`, option (a) is still
   the right fix because it is *also* accepted (a `hardBreak` node is explicitly
   permitted in paragraph content by the ADF schema). Option (a) is strictly
   safer regardless of the research outcome.

3. **Option (a) vs option (b):** For block HTML (raw `<div>` source), preserving
   line breaks as `hardBreak` nodes is more faithful than collapsing them to
   spaces. A two-line `<div>\n  <span>x</span>\n</div>` has three visually
   distinct lines; collapsing to spaces renders them as a single run, losing
   structure that the user wrote deliberately.

4. **Implementation is straightforward.** At the `NodeKind::HtmlBlock` end
   boundary, instead of concatenating all child text into one string and emitting
   a single text node, split the concatenated string on `\n` (after the trailing-
   newline trim), then interleave `text` nodes and `hardBreak` nodes:

   ```
   "<div>\n  <span>x</span>\n</div>"
   →  text("<div>"), hardBreak, text("  <span>x</span>"), hardBreak, text("</div>")
   ```

   Empty segments (from consecutive `\n\n` lines) emit no `text` node but still
   emit a `hardBreak` for the split boundary (Algorithm B). The `content` array
   is built directly in the end-handler (NOT via `push_text`, which appends to
   the top-of-stack and consults active_marks — incorrect for a mid-pop
   end-handler). If all segments are empty, the `content` array ends up with only
   `hardBreak` nodes; `trim_leading_trailing_hardbreaks` (step 5b) removes them,
   leaving an empty array; the end-handler early-returns with no node. The
   `is_empty_block_container` helper is NOT involved for paragraphs — paragraph is
   deliberately excluded from the REQUIRES_CONTENT set; the empty-result path is
   handled entirely by the end-handler's own early-return guard (step 6).

   **[F-3 correction, 2026-06-15]:** The original text above ("that the existing
   `push_text` guard … handles naturally" and "`is_empty_block_container` … still
   applies") was inaccurate. `push_text` is not in the HtmlBlock end-handler call
   path; using it would be wrong (it targets the current stack top and merges
   marks, both inappropriate here). `is_empty_block_container` excludes paragraphs
   by design. The authoritative algorithm is in BC-7.2.011 steps 4/5b/6.

5. **Autolink interaction is benign.** After option (a), `autolink_bare_urls`
   processes each resulting `text` node independently. A bare URL that straddles
   a line boundary would be split on the newline first, so only the URL portion
   on each line is considered — this is consistent with how autolink handles
   split-by-emphasis (CLAUDE.md: "only the leading plain run links").

**If research shows Jira mangles raw `\n`:** option (a) is already the fix.
**If research shows Jira accepts raw `\n`:** option (a) is still the correct
fix on convention grounds. The only scenario where this matters is if option (a)
introduces a Jira regression; the ADF schema explicitly permits `hardBreak` in
paragraph content, so that risk is near-zero.

---

### F-4 (MED): CRLF and multi-trailing-newline fragility — fix now (same PR)

**Current code:** `text.strip_suffix('\n').unwrap_or(&text)` at adf.rs ~928.

**Problem:**
- CRLF line endings (`\r\n`) leave a dangling `\r` after the strip.
- Multiple trailing newlines (e.g. pulldown-cmark occasionally emits an extra
  `\n` after the block) leave one `\n` intact.

**Fix:** `text.trim_end_matches(['\n', '\r'])` (suffix-only trim, anchored to
the end of the string, applies to all trailing `\r`/`\n` in sequence).

Note: with option (a) for F-1, the trim now applies *before* splitting on
interior newlines, so the full concatenated string is right-trimmed first, then
split. This is the correct order: trim terminal whitespace, then segment interior
newlines.

**Disposition: Fix in the same commit as F-1.** This is a one-liner change and
has no standalone test risk.

---

### F-2 (MED): Inaccurate "symmetric with inline HTML" comment — fix now (same PR)

**Current comment (adf.rs ~919–921):**
```
// honest literal representation (issue #489). Symmetric with the
// inline-HTML path, which preserves tags as literal text.
```

**Problems identified:**
- Block HTML manufactures its own wrapping `paragraph` node; inline HTML does not.
- Block HTML trims trailing `\n`; inline HTML does not.
- Block HTML force-emits an unmarked node; inline HTML inherits `active_marks`.
- The word "symmetric" implies the two paths are interchangeable — they are not.

**Fix:** Replace the comment to enumerate the actual differences. Example:
```
// ADF has no raw-HTML node. Block HTML differs from inline HTML in three ways:
// (1) it is wrapped in its own `paragraph`; inline HTML flows into the
//     enclosing paragraph directly; (2) trailing \r\n is trimmed from the
//     block; inline HTML text is not trimmed; (3) block HTML carries no
//     active_marks; inline HTML inherits the current mark stack.
// Rather than silently discarding block HTML (data loss), we preserve the
// verbatim source as literal text (#489).
```

**Disposition: Fix in the same commit as F-1.** Comment-only change, zero risk.

---

### F-3 (MED): Missing tests — add in the same PR

Three tests are absent; all are needed to prevent regression of the fixed behavior:

1. **`test_multiline_block_html_round_trips_through_adf_to_text`** — verifies
   that a multi-line block HTML input survives the ADF→text path. Currently
   `test_block_html_round_trips_through_adf_to_text` only tests single-line.
   After option (a), the multi-line round-trip should produce
   `"<div>\n  <span>x</span>\n</div>"` (hardBreak renders as `\n` in `adf_to_text`),
   which is the faithful original.

2. **`test_block_html_comment_only_behavior`** — verifies `<!-- x -->` on its
   own line (a standalone HTML comment block). pulldown-cmark emits a
   `Tag::HtmlBlock` event for this. After the fix: should produce one
   `paragraph > text("<!-- x -->")` (no trailing newline, no hardBreak nodes
   since there are no interior newlines). This case is distinct from `<div>x</div>`
   because HTML comments are the most common "accidental" block-HTML users produce
   in markdown; confirming they are preserved rather than dropped is important.

3. **`test_block_html_bare_url_gets_link_mark`** — verifies the autolink (#473)
   interaction with a block HTML text node that contains a bare URL. Example input:
   `<a href="https://example.com">`. After option (a) and autolink processing,
   the `https://example.com` span should receive a `link` mark on the text node
   that contains it. This pins the specific interaction between the two post-#489
   / post-#473 code paths and prevents a future refactor from accidentally
   suppressing autolink on HtmlBlock-derived text nodes.

**Additionally:** `test_convert_multiline_block_html_preserves_interior_newlines`
(currently asserting the buggy `\n`-in-text behavior) MUST be **replaced** — not
just updated — by a test asserting the fixed behavior (hardBreak-segmented nodes).
The old test name can be reused or a new name chosen; either way, the body must
assert the correct post-fix output.

**Disposition: Add/replace all four tests in the same PR as F-1.**

---

### F-O (LOW): Missing `docs/specs/` feature spec — add in the same PR

**CLAUDE.md** mandates: "When adding a new feature: ... Create a feature spec in
`docs/specs/` before implementing." The #489 PR shipped without
`docs/specs/adf-block-html.md`. This is a process debt item, not a runtime bug.

**Required:** Add `docs/specs/adf-block-html.md` documenting:
- The block-HTML → ADF mapping decision and rationale.
- The hardBreak-split behavior for interior newlines.
- The trailing-whitespace trim rule (post-F-4 fix).
- The difference from inline-HTML handling (post-F-2 fix).
- The `autolink_bare_urls` interaction.
- Round-trip behavior via `adf_to_text`.
- The governing BC (new BC-7.2.011 to be added to `bc-7-output-render.md`).

**Disposition: Add in the same PR.** A CLAUDE.md-mandated spec file costs
minimal effort but satisfies the process requirement. Without it a future F5
pass will flag the gap again.

---

## BC Changes Required

### New BC-7.2.011 (block-HTML → ADF)

Add a new BC entry to `bc-7-output-render.md` between BC-7.2.010 and 7.3.001.
The entry should describe the **fixed** behavior:

- A block-HTML run (pulldown `Tag::HtmlBlock`) is preserved as literal text inside
  a `paragraph` node rather than silently dropped.
- Interior newlines in the HTML source are represented as `hardBreak` nodes
  (not as raw `\n` characters in a text node's `"text"` field).
- Trailing `\r`/`\n` characters are trimmed before segmentation.
- Block HTML carries no active inline marks (unlike inline HTML, which inherits
  the current mark stack).
- The `autolink_bare_urls` post-pass applies normally to the resulting text nodes;
  bare `http(s)://` URLs within block HTML receive `link` marks.

**No existing BC requires a version bump.** The fix is conformance with the
file-wide invariant, not a behavioral contract change to any currently-specified BC.

The `bc-7-output-render.md` frontmatter `total_bcs:` and `definitional_count:`
fields must be incremented by 1, and `last_updated:` updated.

---

## Affected Tests

### Must be replaced (assert buggy behavior)

- `test_convert_multiline_block_html_preserves_interior_newlines` (adf.rs ~6887)
  — currently pins `"<div>\n  <span>x</span>\n</div>"` as the text field of a
  single text node. Must be replaced to assert `hardBreak`-segmented content.

### Must be extended / updated

- `test_block_html_round_trips_through_adf_to_text` (adf.rs ~6904) — currently
  only tests single-line. Should be supplemented (not replaced) by the new
  multi-line round-trip test (F-3 item 1).

### Must be added (new)

1. `test_multiline_block_html_round_trips_through_adf_to_text`
2. `test_block_html_comment_only_behavior`
3. `test_block_html_bare_url_gets_link_mark`

---

## Regression Risk

| Risk | Severity | Mitigation |
|------|----------|------------|
| Breaking the single-line HtmlBlock path | LOW | Existing `test_convert_block_html_is_preserved_as_literal_text` and `test_block_html_round_trips_through_adf_to_text` continue to assert single-line behavior |
| `autolink_bare_urls` double-processing after split | LOW | Each resulting text node is an independent leaf; autolink scans are stateless; no double-application risk |
| `is_empty_block_container` pruning a legitimate multi-line HtmlBlock | NEGLIGIBLE | Pruning fires only on empty `content` arrays; multi-line HTML produces at least one non-empty text node |
| `adf_to_text` render of hardBreak nodes in HtmlBlock paragraph | LOW | `hardBreak` → `\n` in `adf_to_text` is the existing behavior for all other hardBreak sites; no special case needed |
| CRLF regression on Windows (F-4) | LOW | `trim_end_matches` is byte-stable; Windows test environment exercises `\r\n` line endings |
| Snapshot test regressions (BC-7.2.003 snapshot) | LOW | The `jr__adf__tests__markdown_complex_to_adf.snap` snapshot does not contain block-level HTML, so the change will not force a snapshot update |

---

## Proposed Fix-Story Shape

**Single story, single PR.** All five findings are scoped to one file and one
logical fix site.

**Story title:** Fix block-HTML ADF emission to use hardBreak nodes for interior
newlines, not raw `\n` in text (issue #492)

**Acceptance criteria:**

1. `NodeKind::HtmlBlock` end-handler splits the concatenated HTML lines on
   interior newlines, emitting alternating `text` and `hardBreak` nodes inside
   the resulting `paragraph`. Empty segments are discarded.

2. Trailing `\r`/`\n` are trimmed with `trim_end_matches(['\n', '\r'])` (replacing
   the fragile `strip_suffix('\n')`).

3. The "symmetric with inline HTML" comment is replaced with accurate language
   enumerating the three differences between block and inline HTML handling.

4. `test_convert_multiline_block_html_preserves_interior_newlines` is replaced to
   assert `hardBreak`-segmented content (not raw `\n` in text).

5. Three new tests are added: `test_multiline_block_html_round_trips_through_adf_to_text`,
   `test_block_html_comment_only_behavior`, `test_block_html_bare_url_gets_link_mark`.

6. `docs/specs/adf-block-html.md` is created documenting the block-HTML→ADF
   mapping, the hardBreak-split behavior, trailing-trim rule, inline-HTML
   differences, autolink interaction, and round-trip behavior.

7. BC-7.2.011 is added to `bc-7-output-render.md` describing the fixed (correct)
   behavior. `total_bcs:` incremented from 89 to 90, `definitional_count:` from
   43 to 44, `last_updated:` updated.

**Mandatory regression test:** `test_convert_multiline_block_html_preserves_interior_newlines`
(replaced) must fail against the old code and pass against the new code.
`test_block_html_bare_url_gets_link_mark` must pass, confirming the #473 autolink
interaction is not broken by the #489 fix.

**Scope explicitly excluded:**
- No changes to `autolink_bare_urls` logic.
- No changes to `adf_to_text` (the `hardBreak` → `\n` path is already correct).
- No changes to `sanitize_table_cell_text` or `flatten_table_to_paragraphs`.
- No other BC modifications.
