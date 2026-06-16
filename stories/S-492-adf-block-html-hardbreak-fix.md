---
document_type: story
story_id: "S-492"
title: "Implement block-HTML → ADF hardBreak interior-newline fix (issue #492, BC-7.2.011)"
wave: feature-followup
status: ready
intent: bug-fix
feature_type: backend
mode: feature
scope: small
severity: HIGH
trivial_scope: false
issue: 492
points: 3
priority: P1
tdd_mode: strict
estimated_effort: small
estimated_days: 1
target_module: adf
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  - BC-7.2.011
bcs:
  - BC-7.2.011
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: ".factory/cycles/cycle-001/issue-492/delta-analysis.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 7
assumption_validations: []
risk_mitigations: []
created: "2026-06-16"
last_updated: "2026-06-16"
breaking_change: false
retroactive: false
predecessor_cycles: "PR #489 (issue #489, BC-7.2.011 block-HTML preservation), PR #499 (issue #475, BC-7.2.003/004/006 ADF E2E read-path)"
---

# S-492 — Implement block-HTML → ADF hardBreak interior-newline fix (issue #492, BC-7.2.011)

## Source of Truth

BC-7.2.011 body: `.factory/specs/prd/bc-7-output-render.md §BC-7.2.011`
F1 delta analysis: `.factory/cycles/cycle-001/issue-492/delta-analysis.md`
F2 convergence record: `.factory/cycles/cycle-001/issue-492/f2-convergence.md`
Predecessor issue: #489 (original block-HTML preservation PR that introduced the `NodeKind::HtmlBlock` end-handler with the raw-`\n`-in-text bug)
Spec doc to create: `docs/specs/adf-block-html.md`

## Summary

Fix the `NodeKind::HtmlBlock` end-handler in `src/adf.rs` to implement the
7-step Algorithm B from BC-7.2.011: normalize-then-split on interior newlines,
emitting alternating `text` and `hardBreak` nodes inside the manufactured
`paragraph`, rather than a single text node containing raw `\n` characters.

The fix also corrects the CRLF trailing-trim fragility (replace `strip_suffix('\n')`
with `trim_end_matches(['\r', '\n'])`), replaces the inaccurate "symmetric with inline
HTML" comment, replaces one existing test that asserts the buggy behavior, adds
eight new tests from BC-7.2.011 Source/Trace, and creates `docs/specs/adf-block-html.md`.

All changes are confined to `src/adf.rs` and `docs/specs/adf-block-html.md`.
No CLI, API, config, cache, or keychain changes.

## Behavioral Contracts

| BC | Statement |
|----|-----------|
| BC-7.2.011 | `markdown_to_adf` preserves block-level HTML as literal text in a `paragraph` with interior newlines represented as `hardBreak` nodes — never as raw `\n` inside a text-node string; `adf_to_text` round-trips losslessly at the line-structure level for non-URL-bearing content (LF-only inputs byte-identical; CRLF/lone-`\r` normalize to `\n`). |

## Story Narrative

As a Jira user writing issue descriptions that include block-level HTML
(e.g., `<div>…</div>` or `<!-- comment -->`),
I want `jr issue create/edit --description` to emit well-formed ADF for multi-line
block HTML with `hardBreak` nodes separating source lines,
so that the submitted ADF is schema-valid and the line structure of the HTML is
faithfully preserved rather than embedding invalid raw `\n` characters in a text node.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~2,500 |
| `src/adf.rs` (full file — only modified file) | ~4,500 |
| BC-7.2.011 body (`bc-7-output-render.md` section) | ~1,800 |
| F1 delta analysis (`issue-492/delta-analysis.md`) | ~800 |
| F2 convergence record (`issue-492/f2-convergence.md`) | ~400 |
| Test output (`cargo test adf::tests`) | ~600 |
| **Total** | **~10,600** |

Well within a 20% agent context window budget (~200k tokens). No splitting required.

## Previous Story Intelligence

**Predecessor: issue #489 (block-HTML preservation — the PR that introduced the bug)**

The `NodeKind::HtmlBlock` end-handler was added in #489 to preserve block HTML as
literal text rather than silently dropping it. The current (buggy) implementation
concatenates all per-line `Event::Html` strings and emits them as a single text
node, with only a single `strip_suffix('\n')` for trailing cleanup. This violates
the file-wide "text nodes must be newline-free" invariant and produces a text node
whose `"text"` field contains raw `\n` characters — invalid per the ADF schema.

**Key lesson from delta analysis:** The fix is NOT to use `push_text` (that method
appends to the current stack top and consults `active_marks` — wrong in a mid-pop
end-handler). The `HtmlBlock` end-handler builds the paragraph content array
directly. The `is_empty_block_container` helper is NOT involved (paragraph is
deliberately excluded from its `REQUIRES_CONTENT` set); the empty-result path is
handled by the end-handler's own early-return guard (Algorithm B step 6).

**Predecessor: issue #474/PR #474 (BC-7.2.007/008, subsup + heading-attr stripping)**

`trim_leading_trailing_hardbreaks` was reused by issue #471 for the `taskItem`
multi-paragraph EC-16 flatten step. Issue #492 reuses the same helper for
Algorithm B step 5b (removing any leading or trailing `hardBreak` that arises from
a leading blank source line). Implementers must NOT modify `trim_leading_trailing_hardbreaks`
— it is shared with the taskItem path.

**Predecessor: issue #473 (bare-URL autolinking)**

After `finish()`, `autolink_bare_urls` walks the ADF tree and splits text nodes
containing bare `http(s)://` URLs at valid autolink boundaries. After the Algorithm B
fix, the block-HTML paragraph's text nodes are independent per-line nodes — the
autolink pass operates on each independently. A URL flush against `"`, `=`, or `>` (the
common `href="…"` form) is NOT at a valid autolink boundary per #473's boundary rules and
does NOT receive a link mark. This is tested by `test_block_html_bare_url_gets_link_mark`.

**Test replacement obligation (CRITICAL — Red Gate requirement):**

`test_convert_multiline_block_html_preserves_interior_newlines` (src/adf.rs ~L6887)
currently ASSERTS THE BUGGY BEHAVIOR (a single text node with raw `\n` in its
`"text"` field). This test MUST be REPLACED before the Algorithm B implementation.
After replacement, the test MUST FAIL against the current pre-#492 code (Red Gate)
and MUST PASS after the handler fix. All eight new tests (AC-005 list) must also
exhibit Red-then-Green behavior against the pre-#492 handler.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Single primary modified file | delta-analysis.md §Impact Boundary | All production changes confined to `src/adf.rs`. The only other file created is `docs/specs/adf-block-html.md` (documentation). No new modules, CLI, API, config, cache, or keychain changes. |
| No `push_text` in HtmlBlock end-handler | BC-7.2.011 step 4a / delta-analysis.md F-1 §F-3 correction | `push_text` targets the current stack top and merges `active_marks` — both are wrong for a mid-pop end-handler. Build the paragraph `content` array directly as `Vec<serde_json::Value>`. |
| Normalize-then-split (NOT char-set split) | BC-7.2.011 step 3 | `trim_end_matches(['\r', '\n'])` THEN `replace("\r\n", "\n")` + `replace('\r', '\n')` THEN `split('\n')`. Do NOT use `split(['\r', '\n'])` — that double-counts CRLF boundaries, emitting spurious `hardBreak` nodes. |
| `trim_leading_trailing_hardbreaks` reuse | BC-7.2.011 step 5b | Call the existing `trim_leading_trailing_hardbreaks` helper on the constructed `content` Vec before the step-6 empty-check. Do NOT modify the helper (it is shared with the `taskItem` path). |
| `is_empty_block_container` not involved | BC-7.2.011 step 6 / delta-analysis.md F-1 §F-3 correction | `paragraph` is deliberately excluded from `is_empty_block_container`'s `REQUIRES_CONTENT` set. The empty-result early-return is handled ENTIRELY in the HtmlBlock end-handler after step 5b. No changes to `is_empty_block_container`. |
| No new crate dependencies | delta-analysis.md §Impact Boundary | The fix uses only existing standard-library string operations and the existing `trim_leading_trailing_hardbreaks` helper. Do NOT add any new entry to `Cargo.toml`. |
| `cargo clippy -- -D warnings` clean | CLAUDE.md conventions | Zero new clippy warnings. No `#[allow]` attributes without refactoring. |
| `cargo fmt --all -- --check` clean | CLAUDE.md conventions | All new code is formatted per `rustfmt`. |

## Library and Framework Requirements

| Library | Version | Constraint |
|---------|---------|-----------|
| pulldown-cmark | 0.13.x (from `Cargo.toml`) | `Tag::HtmlBlock` / `Event::Html` event shape unchanged from issue #489. Per-line `Event::Html` events are concatenated during `Start(Tag::HtmlBlock)` → `End(TagEnd::HtmlBlock)`. No parser option changes. |
| serde_json | current (from `Cargo.toml`) | `json!({"type":"hardBreak"})` is the correct ADF hardBreak node form — identical to the existing `Event::HardBreak` arm. No version change. |

No new crate dependencies are added by this story.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `src/adf.rs` | MODIFY | (1) Replace `strip_suffix('\n')` with `trim_end_matches(['\r', '\n'])` (step 2); (2) Add CR-normalize step: `replace("\r\n", "\n")` then `replace('\r', '\n')` (step 3); (3) Implement Algorithm B step 4 walk: iterate segments with index `i`, emit `text` node if non-empty, emit `hardBreak` if `i < len-1`; (4) Apply `trim_leading_trailing_hardbreaks` (step 5b); (5) Add early-return if content empty (step 6); (6) Replace the inaccurate "symmetric with inline HTML" comment with accurate language enumerating the 3 differences per BC-7.2.011 "Difference from inline HTML"; (7) REPLACE `test_convert_multiline_block_html_preserves_interior_newlines` to assert hardBreak-segmented content per EC-3/EC-6; (8) Add 8 new named tests: `test_multiline_block_html_round_trips_through_adf_to_text`, `test_block_html_comment_only_behavior`, `test_block_html_bare_url_gets_link_mark`, `test_block_html_crlf_interior_no_dangling_cr`, `test_block_html_consecutive_blank_lines_produce_double_hardbreak`, `test_block_html_leading_blank_line_no_leading_hardbreak`, `test_block_html_lone_cr_interior_produces_single_hardbreak`, `test_block_html_trailing_whitespace_final_line_not_byte_identical`. |
| `docs/specs/adf-block-html.md` | CREATE | Spec document for the block-HTML → ADF mapping. Documents: Algorithm B 7 steps; hardBreak-split rationale; normalize-then-split requirement; trailing-trim rule (step 2); 3 differences from inline HTML; `autolink_bare_urls` interaction; 5-condition byte-identity round-trip characterization; governing BC-7.2.011. (created by issue #492, per BC-7.2.011 Source field) |

No new integration test files. All new tests are inline unit tests in `src/adf.rs::tests`.
No changes to `CLAUDE.md` (the existing `#489` gotcha entry already documents the block-HTML behavior; the CLAUDE.md entry will be updated as documentation fallout in a separate post-merge step if needed, following the pattern of other feature gotchas).

## Acceptance Criteria

### AC-001 — Algorithm B 7-step implementation in `NodeKind::HtmlBlock` end-handler
(traces to BC-7.2.011 postcondition — 7-step Algorithm B; normalize-then-split; hardBreak-separator; step 5b trim; step 6 early-return)

The `NodeKind::HtmlBlock` arm of `AdfBuilder::end()` (`src/adf.rs` ~L914–936)
implements Algorithm B in canonical step order:

1. Concatenate per-line `Event::Html` strings (existing behavior preserved).
2. `trim_end_matches(['\n', '\r'])` — strips all trailing `\r`/`\n` characters
   (replaces the current fragile `strip_suffix('\n')`). Trailing non-newline
   whitespace (spaces/tabs) is NOT stripped.
3. CR-normalize: `replace("\r\n", "\n")` THEN `replace('\r', '\n')` — then
   `split('\n')` into segments. A `['\r', '\n']` char-set split is FORBIDDEN
   (double-counts CRLF boundaries).
4. Walk segments with index `i` from `0` to `len-1`: if `segments[i]` is non-empty,
   append a `text` node; if `i < len-1`, append a `hardBreak` node (one per boundary
   regardless of segment emptiness).
5. Assemble `content` into a `paragraph` node.
5b. Apply `trim_leading_trailing_hardbreaks` to remove any leading or trailing
    `hardBreak` nodes.
6. If `content` is empty after step 5b, return early with no node emitted.
7. The step-7 `autolink_bare_urls` post-pass runs after `finish()` as existing behavior
   — no handler change required.

The handler does NOT call `push_text` (wrong target; wrong marks context).
The handler does NOT call `is_empty_block_container` (not applicable to paragraph).

---

### AC-002 — Trailing whitespace: only `\r`/`\n` trimmed; spaces/tabs preserved
(traces to BC-7.2.011 step 2 — trailing non-newline whitespace NOT trimmed; EC-10)

The step-2 trim removes only `\r` and `\n` characters from the end of the
concatenated string. Trailing spaces or tabs on the final source line are
NOT stripped by step 2 and are preserved verbatim in the last text node.

Pinned by: `test_block_html_trailing_whitespace_final_line_not_byte_identical`
(EC-10): input `<div>x</div>\n   ` → forward ADF preserves
`[text("<div>x</div>"), hardBreak, text("   ")]`; round-trip via `adf_to_text`
yields `"<div>x</div>"` (trailing whitespace stripped by `AdfRenderer::finish`
document-global `trim_end()` — NOT by step 2). The forward ADF is correct;
the round-trip lossiness is documented and expected.

---

### AC-003 — Inaccurate comment replaced with accurate 3-difference enumeration
(traces to BC-7.2.011 "Difference from inline HTML" section)

The comment block above the `NodeKind::HtmlBlock` end-handler arm that currently
reads `"Symmetric with the inline-HTML path, which preserves tags as literal text"`
is replaced with accurate language enumerating the three load-bearing differences:

1. Block HTML is wrapped in its own manufactured `paragraph`; inline HTML flows
   into the enclosing paragraph directly.
2. Trailing `\r`/`\n` is trimmed from block HTML; inline HTML text is not trimmed.
3. Block HTML carries no `active_marks` (mark stack is always empty when a
   `HtmlBlock` end fires); inline HTML inherits the current mark stack.

The replacement comment also notes that preservation (not dropping) was introduced
by issue #489, and that interior newlines are represented as `hardBreak` nodes
per this fix (issue #492 / BC-7.2.011).

---

### AC-004 — `test_convert_multiline_block_html_preserves_interior_newlines` replaced
(traces to BC-7.2.011 postcondition — EC-3/EC-6; Red Gate requirement)

The existing test at `src/adf.rs` ~L6887 that currently asserts a single text node
containing a raw `\n` character is REPLACED (not deleted, not renamed-and-kept)
with a new body asserting hardBreak-segmented content per Algorithm B.

For a canonical multi-line input such as `<div>\n  <span>x</span>\n</div>`, the
replacement test asserts that the resulting paragraph `content` array is:
`[text("<div>"), hardBreak, text("  <span>x</span>"), hardBreak, text("</div>")]` —
three `text` nodes and two `hardBreak` nodes, with no `\n` character in any `text`
node's `"text"` field.

**Red Gate requirement:** This test MUST FAIL against the current pre-#492
`src/adf.rs` (where the handler produces a single `\n`-bearing text node) and
MUST PASS after the Algorithm B fix is applied.

---

### AC-005 — Eight new tests added from BC-7.2.011 Source/Trace, all passing
(traces to BC-7.2.011 Source/Trace field — 8 named tests; Red Gate requirement for all 8)

The following eight tests are added to `src/adf.rs::tests`. Each MUST FAIL against
the current pre-#492 handler code and MUST PASS after the fix:

1. **`test_multiline_block_html_round_trips_through_adf_to_text`** (EC-3 extended):
   A multi-line block HTML input (e.g., `<div>\na\n</div>`) round-trips through
   `adf_to_text` to reconstruct the original line structure with `\n` separators.
   Input using only non-whitespace final lines to achieve byte-identity (e.g.,
   `a\n\nb`). Assert the round-trip output equals the original input string.

2. **`test_block_html_comment_only_behavior`** (EC-3 DOCUMENT-AS-IS):
   A standalone HTML comment `<!-- x -->` (single line, no interior newlines)
   produces a `paragraph` with exactly one `text` node containing `"<!-- x -->"`.
   No `hardBreak` nodes in content.

3. **`test_block_html_bare_url_gets_link_mark`** (EC-4):
   (a) A URL preceded by whitespace at a valid autolink boundary (e.g.,
   `<div>see https://example.com</div>`) — after the `autolink_bare_urls` post-pass,
   the text node containing `https://example.com` has a `link` mark.
   (b) A URL flush against `"` (e.g., `href="https://example.com"`) does NOT
   receive a link mark and stays a plain text node. Both assertions must pass in
   the same test.

4. **`test_block_html_crlf_interior_no_dangling_cr`** (EC-1):
   Input `<div>\r\n  x\r\n</div>` yields exactly
   `[text("<div>"), hardBreak, text("  x"), hardBreak, text("</div>")]`.
   Three text nodes, two hardBreaks, zero `\r` characters in any text node.

5. **`test_block_html_consecutive_blank_lines_produce_double_hardbreak`** (EC-6):
   Input `<div>\n\na\n</div>` (4 segments after split: `["<div>", "", "a", "</div>"]`)
   yields `[text("<div>"), hardBreak, hardBreak, text("a"), hardBreak, text("</div>")]`.
   Exactly two consecutive `hardBreak` nodes between `<div>` and `a`.

6. **`test_block_html_leading_blank_line_no_leading_hardbreak`** (EC-8):
   An input beginning with `\n` (leading blank line) produces NO leading `hardBreak`
   in the final content array — `trim_leading_trailing_hardbreaks` (step 5b) eliminates it.

7. **`test_block_html_lone_cr_interior_produces_single_hardbreak`** (EC-9):
   Input `<div>\rx</div>` (lone `\r`, old-Mac line endings) yields exactly
   `[text("<div>"), hardBreak, text("x</div>")]` — exactly ONE `hardBreak`, no `\r`
   in any text node.

8. **`test_block_html_trailing_whitespace_final_line_not_byte_identical`** (EC-10):
   See AC-002 above for the full assertion shape.

**Red Gate note:** All 8 tests exercise the Algorithm B logic that does not yet
exist in the pre-#492 handler. They are designed to fail against the current
single-text-node implementation and pass only after the fix is applied.

---

### AC-006 — `docs/specs/adf-block-html.md` created
(traces to BC-7.2.011 Source field — "`docs/specs/adf-block-html.md` (created by issue #492)")

`docs/specs/adf-block-html.md` is created documenting:

- The block-HTML → ADF mapping decision and rationale (preserve-not-drop, issue #489).
- Algorithm B 7 steps (canonical implementation guide).
- The normalize-then-split rule and why char-set split is forbidden (CRLF double-count).
- Trailing-whitespace trim rule (step 2): only `\r`/`\n` trimmed; spaces/tabs preserved.
- The three differences from inline-HTML handling (per BC-7.2.011 "Difference from inline HTML").
- The `autolink_bare_urls` interaction (post-`finish()` pass; boundary-char rules;
  href-attribute form not autolinked).
- Round-trip behavior: line-structure-lossless for non-URL content; byte-identical only
  for the 5-condition exhaustive enumeration from BC-7.2.011 Behavior paragraph.
- The governing BC reference: BC-7.2.011 in `.factory/specs/prd/bc-7-output-render.md`.

---

### AC-007 — Full regression suite green; toolchain checks clean
(traces to BC-7.2.011 invariants — file-wide newline-free-text-node rule; no-leading/trailing-hardBreak invariant; CRLF normalization)

All of the following must pass after the changes:

- `cargo test` exits 0 (all existing tests pass, including the pre-existing
  `test_convert_block_html_is_preserved_as_literal_text` and
  `test_block_html_round_trips_through_adf_to_text` — single-line behavior unchanged).
- `cargo clippy -- -D warnings` exits 0; no new `#[allow]` attributes.
- `cargo fmt --all -- --check` exits 0.
- No new `unsafe` code.
- No lint suppression without refactoring.
- The BC-7.2.003 ADF snapshot test (`jr__adf__tests__markdown_complex_to_adf.snap`)
  is NOT changed (the complex-markdown fixture does not contain block-level HTML).

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-1 | CRLF interior (`<div>\r\n  x\r\n</div>`) | Normalize `\r\n`→`\n` in step 3; result: 3 text nodes, 2 hardBreaks, zero `\r` in any text node |
| EC-2 | Multiple trailing newlines (`<div>x</div>\n\n\n`) | Step 2 strips all trailing `\r`/`\n`; single text node, no hardBreak, no trailing empty segment |
| EC-3 | Comment-only block (`<!-- x -->`) | Single text node `"<!-- x -->"`, no hardBreak (DOCUMENT-AS-IS pin) |
| EC-4 | Bare URL at autolink boundary inside block HTML | URL-bearing text node receives `link` mark from `autolink_bare_urls` post-pass; `href="…"` form NOT autolinked (non-boundary) |
| EC-5 | Single-line block HTML (`<hr/>`) | Single text node, no hardBreak; existing behavior unchanged |
| EC-6 | Consecutive blank lines (`<div>\n\na\n</div>`) | 4 segments → double-hardBreak between `<div>` and `a` |
| EC-7 | All-empty block (`\n\n\n` only) | Step 6 early-return: no paragraph emitted |
| EC-8 | Leading blank line (`\n<div>x</div>`) | Step 5b trim removes leading hardBreak; output: `[text("<div>x</div>")]` |
| EC-9 | Lone `\r` separator (`<div>\rx</div>`) | Step 3 normalizes `\r`→`\n`; exactly 1 hardBreak, no `\r` in text node |
| EC-10 | Trailing-whitespace final line (LF-only, document-final) | Forward ADF preserves `text("   ")`; round-trip via `adf_to_text` loses trailing-whitespace via `finish().trim_end()` |

## Architecture Mapping

| Component | File | Pure/Effectful |
|-----------|------|---------------|
| `AdfBuilder::end` — `NodeKind::HtmlBlock` arm | `src/adf.rs` ~L914–936 | Pure (no I/O; deterministic string transform) |
| `trim_leading_trailing_hardbreaks` | `src/adf.rs` (existing helper; reused, not modified) | Pure |
| `autolink_bare_urls` / `split_text_node_on_urls` | `src/adf.rs` (existing; no changes) | Pure |
| `adf_to_text` — hardBreak arm | `src/adf.rs` (existing; no changes) | Pure |
| `docs/specs/adf-block-html.md` | `docs/specs/` | N/A — documentation |

## Dependencies

| Type | Description |
|------|-------------|
| `depends_on` | None — this story has no upstream story dependencies |
| `blocks` | None — this is an independent bug-fix; no downstream stories depend on the Algorithm B node shape |

Dependency justification: This is a self-contained fix to a single function in `src/adf.rs`.
No other story in the manifest depends on the block-HTML ADF output shape, and the fix does
not alter any external API surface, CLI flags, JSON output shapes, or cache schemas.

## Forbidden Dependencies

The `src/adf.rs` module MUST NOT gain any new dependencies in `Cargo.toml` as a result
of this story. The fix uses only:
- `std::string::String` methods (`trim_end_matches`, `replace`, `split`)
- `serde_json::json!` macro (already a dependency)
- The existing `trim_leading_trailing_hardbreaks` helper (same file)

If any new `Cargo.toml` entry is required, STOP and escalate — the algorithm is
implementable with existing standard-library facilities.

## TDD Notes — Red Gate Requirements

The following tests MUST exhibit Red-then-Green behavior:

| Test | Red Gate (pre-#492 code) | Green Gate (post-fix) |
|------|--------------------------|----------------------|
| `test_convert_multiline_block_html_preserves_interior_newlines` (REPLACED) | Fails — new body asserts hardBreak content; old handler emits single `\n`-bearing text | Passes after Algorithm B implementation |
| `test_block_html_crlf_interior_no_dangling_cr` (NEW) | Fails — old handler doesn't normalize CRLF; `\r` survives into text node | Passes after step-3 normalize + split |
| `test_block_html_consecutive_blank_lines_produce_double_hardbreak` (NEW) | Fails — old handler emits one text node with `\n\n` embedded | Passes after Algorithm B walk |
| `test_multiline_block_html_round_trips_through_adf_to_text` (NEW) | Fails — `adf_to_text` on single `\n`-bearing text node doesn't reconstruct line structure | Passes after hardBreak nodes enable correct `hardBreak`→`\n` reverse path |
| `test_block_html_comment_only_behavior` (NEW) | Passes even against old code (single-line, no interior `\n`) — this is a REGRESSION GUARD, not a Red Gate test |
| `test_block_html_bare_url_gets_link_mark` (NEW) | Passes for the autolink-boundary assertion (URL splitting is independent of the text-node structure); href-form no-link assertion also independent — REGRESSION GUARD |
| `test_block_html_leading_blank_line_no_leading_hardbreak` (NEW) | Fails against old code (old handler emits `\n<div>x</div>` as one text starting with `\n`) | Passes after step 5b trim |
| `test_block_html_lone_cr_interior_produces_single_hardbreak` (NEW) | Fails — old handler emits `\r` inside text node | Passes after step-3 normalization |
| `test_block_html_trailing_whitespace_final_line_not_byte_identical` (NEW) | Partially fails — old handler emits single text with embedded `\n`; new test structure asserts split ADF shape | Passes after Algorithm B splits correctly |

The replaced `test_convert_multiline_block_html_preserves_interior_newlines` and the
three always-failing new tests (`_crlf_`, `_consecutive_blank_`, `_lone_cr_`) form the
primary Red Gate set. Implementers MUST observe these failing BEFORE making any code
changes, then observe them passing after.
