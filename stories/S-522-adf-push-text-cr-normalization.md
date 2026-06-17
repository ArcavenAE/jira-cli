---
document_type: story
story_id: "S-522"
title: "Fix push_text / push_code: normalize lone \\r on the generic ADF parser path (issue #522, BC-7.2.011 EC-11)"
wave: feature-followup
status: ready
intent: bug-fix
feature_type: backend
mode: feature
scope: small
severity: MEDIUM
trivial_scope: true
issue: 522
points: 1
priority: P1
tdd_mode: strict
estimated_effort: xsmall
estimated_days: 0.5
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
spec_source: ".factory/phase-f1-delta-analysis/issue-522-delta-analysis.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 7
assumption_validations: []
risk_mitigations: []
created: "2026-06-16"
last_updated: "2026-06-16"
breaking_change: false
retroactive: false
predecessor_cycles: "PR #492 (issue #492, BC-7.2.011 block-HTML hardBreak fix — introduced the strict_cr=false proptest gap that this story closes)"
# BC status: ready — BC-7.2.011 EC-11 (INV-push-text-cr) authored by product-owner in F2
---

# S-522 — Fix push_text / push_code: normalize lone `\r` on the generic ADF parser path (issue #522, BC-7.2.011 EC-11)

## Source of Truth

BC-7.2.011 body (EC-11 / INV-push-text-cr): `.factory/specs/prd/bc-7-output-render.md §BC-7.2.011`
F1 delta analysis: `.factory/phase-f1-delta-analysis/issue-522-delta-analysis.md`
Pinned regression test (pre-fix, `#[ignore]`d): `src/adf.rs::tests::test_lone_cr_survives_pre_existing_492_oos`
Proptest with strict_cr gate: `src/adf.rs::tests::prop_492_arbitrary_string_holds_core_invariants`
Predecessor: S-492 (block-HTML hardBreak fix — issue #492, shipped PR TBD, introduced `strict_cr=false` gap marker)

## Summary

Close the pre-existing, explicitly-documented CR-normalization gap on the generic
`markdown_to_adf` parser path. `AdfBuilder::push_text` and `AdfBuilder::push_code`
are the chokepoints for all `Event::Text`, `Event::InlineHtml`, and `Event::Code`
content (heading, paragraph, codeBlock, listItem, taskItem, tableCell, blockquote,
panel, inline marks, footnote definitions). Both must normalize `\r\n` → `\n` then
lone `\r` → `\n` before constructing any ADF `text` node.

The `NodeKind::HtmlBlock` end-handler (Algorithm B, issue #492) already normalizes CR
independently in step 3 and never calls `push_text`. This fix adds the complementary
normalization to the generic path, extending the no-raw-CR invariant (INV-1) from
block HTML only to all block types.

**Implementation: 4–6 LOC in two functions, one fast-path guard each.**

```rust
fn push_text(&mut self, text: &str) {
    // INV-push-text-cr (BC-7.2.011 EC-11, issue #522): no raw \r must
    // survive into an ADF text node on the generic parser path.
    // pulldown-cmark 0.13 does not normalize lone \r on Event::Text.
    // Mirrors Algorithm B step 3 in NodeKind::HtmlBlock end handler.
    // Note: \r\n → \n first to avoid double-counting CRLF as two newlines.
    let normalized;
    let text = if text.contains('\r') {
        normalized = text.replace("\r\n", "\n").replace('\r', "\n");
        &normalized
    } else {
        text  // fast path: no allocation when clean
    };
    // ... rest of existing logic unchanged
}
```

Apply the identical guard in `push_code`.

## Behavioral Contracts

| BC | Statement |
|----|-----------|
| BC-7.2.011 (EC-11 / INV-push-text-cr) | `AdfBuilder::push_text` and `AdfBuilder::push_code` normalize `\r\n`→`\n` then lone `\r`→`\n` before constructing any ADF text node, for ALL block types on the generic parser path. No raw `\r` character survives into any text node from any block type. Extends INV-1's CR-free guarantee from block-HTML-only (Algorithm B) to the full generic parser path. Mirrors CommonMark §2.3. |

## Story Narrative

As a Jira user whose issue description or comment source contains old-Mac (`\r`)
or Windows (`\r\n`) line endings — whether from pasting legacy content, using an
editor that saves CRLF, or constructing markdown programmatically — I want
`jr issue create/edit --description` to emit well-formed ADF text nodes for
heading, codeBlock, paragraph, and all other block types, so that no raw `\r`
character survives into the submitted JSON (a JSON-level validity hazard) and Jira
accepts the request without a 400 error.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~2,800 |
| `src/adf.rs` (full file — only modified file) | ~4,500 |
| BC-7.2.011 body (`bc-7-output-render.md` §BC-7.2.011, EC-11 section) | ~1,000 |
| F1 delta analysis (`issue-522-delta-analysis.md`) | ~1,400 |
| Test output (`cargo test adf::tests`) | ~600 |
| **Total** | **~10,300** |

Well within a 20% agent context window budget (~200k tokens). No splitting required.

## Previous Story Intelligence

**Predecessor: S-492 (issue #492, block-HTML hardBreak fix)**

S-492 fixed the `NodeKind::HtmlBlock` end-handler to implement Algorithm B:
normalize-then-split interior newlines into `text`/`hardBreak` nodes. As part of
that work, the `assert_no_raw_newline_in_text_nodes` test helper was given a
`strict_cr: bool` parameter. For the arbitrary-string proptest, `strict_cr=false`
was set to explicitly mark the remaining CR-normalization gap on the generic path as
a pre-existing defect — deferred to a follow-up fix. The `#[ignore]`d test
`test_lone_cr_survives_pre_existing_492_oos` pinned the two minimal repros.

**This story is that follow-up.** All assertions in this story flow directly from
the gap markers left by S-492.

**Key constraints from S-492:**

1. The `NodeKind::HtmlBlock` end-handler (Algorithm B) performs its own CR
   normalization in step 3 and explicitly bypasses `push_text` (see code comment:
   "do NOT route through push_text — would break the direct-content-array build").
   Adding normalization to `push_text` does NOT affect the block-HTML handler and
   creates no double-normalization risk.

2. `push_text` and `push_code` must apply the same two-pass normalization:
   `replace("\r\n", "\n")` THEN `replace('\r', "\n")`. Order matters: doing
   `replace('\r', "\n")` first would turn `\r\n` into `\n\n` (double newline).

3. The `contains('\r')` fast-path guard avoids allocation on the common case
   (LF-only inputs). This is load-bearing for performance on the hot parser path.

4. No new crate dependencies are added. The fix uses only `str::contains`,
   `str::replace`, and a borrowed-str rebinding.

5. `SoftBreak` → `push_text(" ")` — a fixed single space, no CR risk.

6. The `Event::Html` and `Event::InlineHtml` events both route to `push_text`
   (same line in `process`). Inline HTML is NOT block HTML (no Algorithm B wrapper),
   so a lone `\r` in inline HTML currently survives. The fix at `push_text` covers
   this path too.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Single primary modified file | F1 delta analysis §Impact Boundary | All production changes confined to `src/adf.rs`. No new modules, CLI, API, config, cache, or keychain changes. |
| No push_text in HtmlBlock end-handler | BC-7.2.011 / S-492 lesson | The `NodeKind::HtmlBlock` arm never calls `push_text`; that arm is NOT touched by this story. |
| Two-pass normalization order | BC-7.2.011 EC-11 | `replace("\r\n", "\n")` FIRST, then `replace('\r', "\n")`. Swapping the order double-counts CRLF. |
| contains('\r') fast-path guard | F1 delta analysis §1.1 | Wrap normalization in `if text.contains('\r')` to avoid allocation on LF-only (common) inputs. |
| Apply identical guard in push_code | F1 delta analysis §1.1 | `push_code` builds a `text` node with a `code` mark — same JSON hazard class as `push_text`. |
| No new crate dependencies | F1 delta analysis §Impact Boundary | Fix uses only `std::str` methods. Do NOT add any `Cargo.toml` entry. |
| cargo clippy -- -D warnings clean | CLAUDE.md conventions | Zero new clippy warnings. No `#[allow]` attributes without refactoring. |
| cargo fmt --all -- --check clean | CLAUDE.md conventions | All new code formatted per `rustfmt`. |

## Library and Framework Requirements

| Library | Version | Constraint |
|---------|---------|-----------|
| pulldown-cmark | 0.13.x (from `Cargo.toml`) | `Event::Text` / `Event::Code` / `Event::InlineHtml` event shapes unchanged. No parser option changes for this fix. |
| serde_json | current (from `Cargo.toml`) | No JSON schema changes; `text` node shape is unchanged. |

No new crate dependencies are added by this story.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `src/adf.rs` | MODIFY | (1) Add CR normalization guard to `AdfBuilder::push_text` (4 lines: `let normalized; let text = if text.contains('\r') { normalized = text.replace("\r\n", "\n").replace('\r', "\n"); &normalized } else { text };`); (2) Apply identical guard to `AdfBuilder::push_code`; (3) RENAME `test_lone_cr_survives_pre_existing_492_oos` → `test_push_text_normalizes_lone_cr_in_heading_and_code_block`, remove `#[ignore]`, INVERT both assertions (`any(contains('\r'))` → `all(!contains('\r'))`); (4) FLIP `prop_492_arbitrary_string_holds_core_invariants` `strict_cr` argument from `false` to `true`; update inline comment from "pre-existing out-of-#492-scope defect" to "fixed in #522: push_text/push_code normalize lone \\r"; (5) ADD 3 new focused unit tests (see AC-003, AC-004, AC-005). |

No new integration test files. All new tests are inline unit tests in `src/adf.rs::tests`.
No `docs/specs/` file created or modified (the spec doc `docs/specs/adf-block-html.md`
was created by S-492; a CLAUDE.md one-liner update to the BC-7.2.011 gotcha entry noting
that `\r` is now normalized across all paths is documentation fallout, NOT in scope for
this story — handle post-merge per the existing gotcha-update pattern).

## Acceptance Criteria

### AC-001 — `push_text` normalizes lone `\r` in heading and codeBlock
(traces to BC-7.2.011 EC-11 / INV-push-text-cr postcondition — lone `\r` normalized to `\n` in heading; codeBlock text node contains no `\r`)

`markdown_to_adf("# x\ry")` produces a heading node whose text nodes contain no
`\r` character. Specifically, no text-node `"text"` field in the returned ADF value
passes `contains('\r')`.

`markdown_to_adf("\ta\r")` (indented code block syntax) produces a codeBlock node
whose text-node `"text"` field contains no `\r` character.

Both repros are covered by the renamed, de-ignored test
`test_push_text_normalizes_lone_cr_in_heading_and_code_block` (formerly
`test_lone_cr_survives_pre_existing_492_oos`).

**Red Gate requirement:** The renamed test with inverted assertions MUST FAIL against
the pre-#522 `src/adf.rs` (where `push_text` does not normalize `\r`) and MUST PASS
after the normalization is added.

---

### AC-002 — `prop_492_arbitrary_string_holds_core_invariants` flipped to `strict_cr=true`
(traces to BC-7.2.011 EC-11 / INV-push-text-cr invariant — `strict_cr=true` asserts no raw `\r` in any text node from arbitrary markdown inputs)

The proptest `prop_492_arbitrary_string_holds_core_invariants` in `src/adf.rs::tests`
is updated to call `assert_no_raw_newline_in_text_nodes(&adf, &input, true)` (was
`false`). The inline comment at that call site is updated from the old "pre-existing
out-of-#492-scope defect — `strict_cr=false` exempt" wording to:
"fixed in #522: push_text/push_code normalize lone \\r on the generic parser path".

After this flip, the proptest runs 2048 cases including inputs containing lone `\r`
and asserts that none survive into any text node. This is the desired regression
harness for the fix.

**Red Gate requirement:** The flipped proptest with `strict_cr=true` MUST FAIL against
the pre-#522 code for some inputs containing `\r`, and MUST PASS after the fix.

---

### AC-003 — New test: `test_push_text_normalizes_crlf_in_paragraph`
(traces to BC-7.2.011 EC-11 / INV-push-text-cr postcondition — CRLF in paragraph input normalizes to `\n` in text nodes; no raw `\r`)

A new unit test `test_push_text_normalizes_crlf_in_paragraph` is added to
`src/adf.rs::tests`. Given input `"hello\r\nworld"`, `markdown_to_adf` must produce
ADF whose text nodes contain no `\r` character. (The CRLF may produce a `hardBreak`
node or a paragraph with `\n`-separated text depending on how pulldown-cmark
processes the soft break — the exact node shape is not asserted; only the absence of
`\r` in all text-node `"text"` fields is asserted.)

Test naming convention: `test_<verb>_<subject>_<expected_outcome>` per CLAUDE.md.

---

### AC-004 — New test: `test_push_code_normalizes_lone_cr_in_inline_code`
(traces to BC-7.2.011 EC-11 / INV-push-text-cr postcondition — `push_code` path normalized; inline code span text node contains no `\r`)

A new unit test `test_push_code_normalizes_lone_cr_in_inline_code` is added to
`src/adf.rs::tests`. Given input `` "`a\rb`" ``, `markdown_to_adf` must produce an
ADF value where the inline code span's text node has `"text": "a\nb"` — specifically:
- The `"text"` field equals `"a\nb"` (lone `\r` normalized to `\n`).
- No text node in the entire ADF value contains a raw `\r` character.

This test exercises the `push_code` path specifically (not `push_text`), confirming
that the `Event::Code` arm also normalizes CR.

---

### AC-005 — `test_push_text_normalizes_lone_cr_in_heading_and_code_block` (renamed + de-ignored + inverted)
(traces to BC-7.2.011 EC-11 — regression pin inverted; `#[ignore]` removed; both repros assert no `\r`)

The existing test `test_lone_cr_survives_pre_existing_492_oos` is:
1. **Renamed** to `test_push_text_normalizes_lone_cr_in_heading_and_code_block`
   (follows `test_<verb>_<subject>_<expected_outcome>` convention).
2. **De-ignored**: `#[ignore]` attribute removed.
3. **Assertions inverted**:
   - The heading repro assertion changes from
     `assert!(heading_texts.iter().any(|t| t.contains('\r')), …)`
     to `assert!(heading_texts.iter().all(|t| !t.contains('\r')), …)`.
   - The codeBlock repro assertion changes from
     `assert!(code_texts.iter().any(|t| t.contains('\r')), …)`
     to `assert!(code_texts.iter().all(|t| !t.contains('\r')), …)`.

The test body structure (ADF traversal to collect text node strings) and the two
input strings (`"# x\ry"` and `"\ta\r"`) are unchanged. Only the `#[ignore]` attribute
and the `assert!` conditions change.

---

### AC-006 — Regression: existing `prop_492_block_html_holds_core_invariants` unaffected
(traces to BC-7.2.011 invariants — Algorithm B CR normalization pre-existing; `strict_cr=true` in block-HTML proptest unchanged)

The proptest `prop_492_block_html_holds_core_invariants` uses `gen_block_html()` and
already calls `assert_no_raw_newline_in_text_nodes(&adf, &input, true)`. This
property is NOT modified by this story. It must continue to pass unchanged.

This AC is a regression guard, not a new behavior assertion.

---

### AC-007 — Full regression suite green; toolchain checks clean
(traces to BC-7.2.011 invariants — no regression on existing tests; clippy/fmt clean; no count drift)

All of the following must pass after the changes:

- `cargo test` exits 0 (all existing tests pass including the 3 renamed/de-ignored
  test and the flipped proptest; block-HTML tests from S-492 are unaffected).
- `cargo clippy -- -D warnings` exits 0; no new `#[allow]` attributes.
- `cargo fmt --all -- --check` exits 0.
- No new `unsafe` code.
- `scripts/check-spec-counts.sh` exits 0 (no BC frontmatter drift — this story
  adds a new AC to the BC-7.2.011 body but does NOT change any BC heading count
  or `total_bcs` / `definitional_count` frontmatter values in any bc-*.md file;
  the count-guard scripts count BC headings, not ACs).
- `scripts/check-bc-cumulative-counts.sh` exits 0 (no cumulative-count drift —
  no new BC-S.SS.NNN heading is created; only the existing BC-7.2.011 body gains
  new AC text which is not counted by this script).
- The ADF snapshot tests (`test_markdown_to_adf_snapshot` /
  `test_adf_to_text_snapshot`) are NOT changed (fixtures use LF-only inputs).
- No existing test asserts the old buggy behavior (i.e., that `\r` survives);
  only `test_lone_cr_survives_pre_existing_492_oos` did so, and it is renamed +
  inverted in AC-005.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-001 | Lone `\r` in heading (`"# x\ry"`) | `push_text` normalizes `\r` → `\n`; heading text nodes contain no `\r` |
| EC-002 | Indented codeBlock with trailing `\r` (`"\ta\r"`) | `push_text` normalizes `\r` → `\n`; codeBlock text node contains no `\r` |
| EC-003 | Inline code span with lone `\r` (`` "`a\rb`" ``) | `push_code` normalizes `\r` → `\n`; text node `"text"` is `"a\nb"` |
| EC-004 | CRLF in paragraph (`"hello\r\nworld"`) | `push_text` normalizes `\r\n` → `\n` (two-pass: `\r\n`→`\n` first, then no lone `\r` remains); text nodes contain no `\r` |
| EC-005 | LF-only input (common case) | `contains('\r')` is false; no allocation; existing behavior unchanged |
| EC-006 | Inline HTML with lone `\r` (`<em>\rx</em>` inside paragraph) | `Event::InlineHtml` routes to `push_text`; `\r` normalized to `\n` |
| EC-007 | Block HTML with CRLF (e.g., `<div>\r\nx</div>`) | Algorithm B (NodeKind::HtmlBlock step 3) normalizes independently; `push_text` NOT called from that handler; no double-normalization |
| EC-008 | Multiple consecutive `\r` (e.g., `"a\r\rb"`) | Two-pass: first `replace("\r\n", "\n")` finds no CRLF; then `replace('\r', "\n")` normalizes both lone `\r`s; result `"a\n\nb"` |

## Architecture Mapping

| Component | File | Pure/Effectful |
|-----------|------|---------------|
| `AdfBuilder::push_text` | `src/adf.rs` ~L1071–1085 | Pure (no I/O; deterministic string transform) |
| `AdfBuilder::push_code` | `src/adf.rs` ~L1087–1103 | Pure |
| Unit tests (renamed/new) | `src/adf.rs::tests` | N/A — tests |

## Tasks

### Phase 1 — Test-writer (Red Gate)

In `src/adf.rs::tests`:

1. **Rename + de-ignore + invert** `test_lone_cr_survives_pre_existing_492_oos`:
   - Remove `#[ignore]` attribute.
   - Rename to `test_push_text_normalizes_lone_cr_in_heading_and_code_block`.
   - Change both `assert!` calls: `any(|t| t.contains('\r'))` → `all(|t| !t.contains('\r'))`.
   - Verify this test NOW FAILS on the pre-fix code (`cargo test test_push_text_normalizes_lone_cr_in_heading_and_code_block -- --include-ignored` should FAIL before code change).

2. **Flip proptest** `prop_492_arbitrary_string_holds_core_invariants`:
   - Change `assert_no_raw_newline_in_text_nodes(&adf, &input, false)` → `(&adf, &input, true)`.
   - Update inline comment.
   - Verify proptest FAILS on pre-fix code for inputs containing `\r`.

3. **Add** `test_push_text_normalizes_crlf_in_paragraph`: `markdown_to_adf("hello\r\nworld")` → all text nodes have no `\r`.

4. **Add** `test_push_code_normalizes_lone_cr_in_inline_code`: `` markdown_to_adf("`a\rb`") `` → inline code text node `"text"` equals `"a\nb"`.

After step 1: `cargo test test_push_text_normalizes_lone_cr_in_heading_and_code_block` FAILS (Red Gate confirmed).
After all 4 steps: `cargo test` will have failures on the 3 new/modified tests and the proptest — do NOT implement yet.

### Phase 2 — Implementer (Green Gate)

In `src/adf.rs`:

5. **Add CR normalization to `push_text`** — insert the `let normalized; let text = if text.contains('\r') { ... }` guard at the top of the function body, before any existing logic. Rebind `text` to the normalized slice for all downstream code in the function.

6. **Add identical CR normalization to `push_code`** — same guard pattern at the top of the `push_code` function body.

7. **Run** `cargo test` — all tests including the 3 modified/new ones and the flipped proptest must PASS (Green Gate).

8. **Run** `cargo clippy -- -D warnings` — must exit 0. If any clippy warning arises from the rebinding pattern, refactor to fix the root cause (do NOT add `#[allow]`).

9. **Run** `cargo fmt --all -- --check` — must exit 0.

10. **Run** `scripts/check-spec-counts.sh` — must exit 0 (no count drift).

11. **Run** `scripts/check-bc-cumulative-counts.sh` — must exit 0 (no cumulative count drift).

## Dependencies

| Type | Description |
|------|-------------|
| `depends_on` | None — this story has no upstream story dependencies |
| `blocks` | None — this is a self-contained bug fix; no downstream stories depend on the `push_text` / `push_code` output shape |

Dependency justification: S-522 is a leaf story. The fix is confined to two private
methods of `AdfBuilder` in `src/adf.rs`. The external API surface (`markdown_to_adf`,
`adf_to_text`) is unchanged. No other story depends on the pre-fix (buggy) behavior
of `push_text` emitting raw `\r` in text nodes.

Topological ordering: S-522 has `depends_on: []` and `blocks: []` — it is a leaf.
Adding it does not introduce any cycle in the dependency graph.

## Forbidden Dependencies

The `src/adf.rs` module MUST NOT gain any new dependencies in `Cargo.toml` as a
result of this story. The fix uses only:
- `str::contains` (zero-allocation predicate)
- `str::replace` (two calls, only when `\r` is present)
- Local `let` binding for the normalized String

If any new `Cargo.toml` entry is required, STOP and escalate — the algorithm is
implementable with existing standard-library facilities.

## TDD Notes — Red Gate Requirements

| Test | Red Gate (pre-#522 code) | Green Gate (post-fix) |
|------|--------------------------|----------------------|
| `test_push_text_normalizes_lone_cr_in_heading_and_code_block` (RENAMED + INVERTED) | FAILS — `push_text` does not normalize `\r`; text nodes contain `\r`; inverted assertions catch the bug | PASSES — `push_text` normalizes `\r`→`\n`; text nodes are `\r`-free |
| `prop_492_arbitrary_string_holds_core_invariants` (FLIPPED to `strict_cr=true`) | FAILS for some inputs containing `\r` — proptest finds a counterexample | PASSES — all 2048 cases including those with `\r` produce `\r`-free text nodes |
| `test_push_text_normalizes_crlf_in_paragraph` (NEW) | FAILS — `push_text` passes `\r\n` through; text nodes contain `\r` | PASSES — two-pass normalization removes `\r` |
| `test_push_code_normalizes_lone_cr_in_inline_code` (NEW) | FAILS — `push_code` passes `\r` through; text node `"text"` is `"a\rb"` | PASSES — `push_code` normalizes `\r`→`\n`; text node is `"a\nb"` |
| `prop_492_block_html_holds_core_invariants` (UNCHANGED) | PASSES unchanged — block-HTML path unaffected | PASSES unchanged |
| All existing `adf::tests` | PASS unchanged — LF-only inputs; no behavior change | PASS unchanged |
