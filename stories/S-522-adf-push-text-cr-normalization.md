---
document_type: story
story_id: "S-522"
title: "Fix ADF CR/newline normalization: push_text / push_code (EC-11) AND text_to_adf plain-text path (EC-12) — BC-7.2.011 (issue #522)"
wave: feature-followup
status: ready
intent: bug-fix
feature_type: backend
mode: feature
scope: small
severity: HIGH
trivial_scope: true
issue: 522
points: 2
priority: P1
tdd_mode: strict
estimated_effort: small
estimated_days: 1.5
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
spec_source_ext: ".factory/phase-f1-delta-analysis/issue-522-text-to-adf-extension.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 19
assumption_validations: []
risk_mitigations: []
created: "2026-06-16"
last_updated: "2026-06-17"
# F5 HIGH-severity refinement (commit 182a93d): bare \n in Other context → INV-1 violation; push_text/push_code now normalize bare \n → space in Other ctx; AC count 14→19
breaking_change: false
retroactive: false
predecessor_cycles: "PR #492 (issue #492, BC-7.2.011 block-HTML hardBreak fix — introduced the strict_cr=false proptest gap that this story closes)"
# BC status: ready — BC-7.2.011 EC-11 (INV-push-text-cr) and EC-12 (INV-1-plain-text) both authored by product-owner
---

# S-522 — Fix ADF CR/newline normalization: `push_text`/`push_code` (EC-11) AND `text_to_adf` plain-text path (EC-12) — BC-7.2.011 (issue #522)

## Source of Truth

BC-7.2.011 body (EC-11 / INV-push-text-cr + EC-12 / INV-1-plain-text): `.factory/specs/prd/bc-7-output-render.md §BC-7.2.011`
F1 delta analysis (EC-11): `.factory/phase-f1-delta-analysis/issue-522-delta-analysis.md`
F1 delta analysis extension (EC-12): `.factory/phase-f1-delta-analysis/issue-522-text-to-adf-extension.md`
Pinned regression test (pre-fix, `#[ignore]`d): `src/adf.rs::tests::test_lone_cr_survives_pre_existing_492_oos`
Proptest with strict_cr gate: `src/adf.rs::tests::prop_492_arbitrary_string_holds_core_invariants`
Predecessor: S-492 (block-HTML hardBreak fix — issue #492, shipped PR TBD, introduced `strict_cr=false` gap marker)

## Summary

**This story covers TWO chokepoints** in `src/adf.rs` that can emit raw `\r`/`\n`
into ADF text nodes — both are INV-1 violations (Jira rejects such payloads with HTTP
400). The story was originally scoped to EC-11 (the markdown parser path); it was
expanded to also cover EC-12 (the plain-text `text_to_adf` path).

### Chokepoint 1 — EC-11: `push_text` / `push_code` (markdown parser path)

Close the pre-existing, explicitly-documented CR-normalization gap on the generic
`markdown_to_adf` parser path. `AdfBuilder::push_text` and `AdfBuilder::push_code`
are the chokepoints for all `Event::Text`, `Event::InlineHtml`, and `Event::Code`
content (heading, paragraph, codeBlock, listItem, taskItem, tableCell, blockquote,
panel, inline marks, footnote definitions).

**F5 revision (INV-1-preserving, context-aware contract):** The fix uses a
CONTEXT-AWARE three-way dispatch — not a uniform `\r`→`\n` across all contexts —
because converting `\r` to `\n` in a non-codeBlock context (heading, paragraph, etc.)
would CREATE a raw `\n` in a text node, violating INV-1 (the file-wide invariant that
non-codeBlock text nodes must not contain raw `\n`):

1. **`CodeBlock` context**: `\r\n` → `\n`, then lone `\r` → `\n` (codeBlock text nodes may contain `\n`).
2. **`HtmlBlock` context**: CR is left UNCHANGED — Algorithm B (issue #492) owns all CR normalization for this context and never calls `push_text`.
3. **All other contexts** (heading, paragraph, listItem, taskItem, tableCell, blockquote, panel, inline marks, footnote definitions, inline HTML): `\r\n` → space, lone `\r` → space. Mirrors `Event::SoftBreak` (→ space), preserving INV-1.

`AdfBuilder::push_code` (inline code spans — always inline, never codeBlock): lone `\r` → space. Defense-in-depth only: pulldown-cmark §6.3 already converts `\r`→space in inline code before emitting `Event::Code`, so this guard is not reachable via the `markdown_to_adf` public path.

The `NodeKind::HtmlBlock` end-handler (Algorithm B, issue #492) already normalizes CR
independently in step 3 and never calls `push_text`. This fix adds the complementary
normalization to the generic path, extending the no-raw-CR invariant from
block HTML only to all block types.

### Chokepoint 2 — EC-12: `text_to_adf` (plain-text write path)

`text_to_adf` is the plain-text sibling function used by five call sites:
`handle_create` (`--description` without `--markdown`), `handle_edit`
(`--description`), `handle_comment` (positional message), `handle_add` (worklog
`--message`), and JSM request build (`--description`). It constructs ADF JSON
directly via the `json!` macro without going through the `AdfBuilder` or
pulldown-cmark — so EC-11's `push_text` normalization does NOT protect `text_to_adf`
inputs. Any `\r`, `\n`, or `\r\n` in the argument is placed verbatim into a `text`
node, violating INV-1.

**Normalization algorithm (mirrors Algorithm B steps 2–5):**

1. Strip trailing `\r` and `\n` characters (any count) from the entire input.
2. Normalize `\r\n`→`\n`, then lone `\r`→`\n` (two-pass; same CRLF-double-counting
   hazard as Algorithm B step 3 — do NOT use a char-set split).
3. Split on `/\n{2,}/` (blank lines) to produce independent `paragraph` blocks.
   Consecutive blank lines collapse to one paragraph boundary.
4. Within each block, split on `\n` and emit alternating `text` + `hardBreak` nodes
   (mirrors Algorithm B step 4). Trim leading/trailing `hardBreak` per paragraph.
5. Each block becomes one ADF `paragraph` node.

**Single-line no-regression guarantee:** Any input with no `\r`, `\n`, or `\r\n`
passes through unchanged — byte-identical to current `text_to_adf` output.

**Implementation option:** Factor Algorithm B's normalize-and-split steps into a shared
private helper `normalize_text_to_inline_nodes(text: &str) -> Option<Vec<Value>>`
called from both the HtmlBlock end arm and `text_to_adf`. If this refactor is
attempted, Algorithm B (HtmlBlock) output MUST remain byte-identical. If there is any
risk of regression, implement `text_to_adf` normalization inline without touching
Algorithm B.

## Behavioral Contracts

| BC | Statement |
|----|-----------|
| BC-7.2.011 (EC-11 / INV-push-text-cr) | `AdfBuilder::push_text` uses context-aware CR normalization: `CodeBlock` context → `\r\n`→`\n` then lone `\r`→`\n`; `HtmlBlock` context → CR untouched (Algorithm B owns it); all other contexts → `\r\n` and lone `\r` → space (preserves INV-1: no raw `\n` in non-codeBlock text nodes). `push_code` → lone `\r` → space (defense-in-depth). No raw `\r` survives into any text node from any block type on the generic parser path. Empirical: `"# x\ry"` → heading `"x y"` (SPACE); `"\ta\r"` → codeBlock `"a\n"`; `` `a\rb` `` → inline code `"a b"` (public path). |
| BC-7.2.011 (EC-12 / INV-1-plain-text) | `text_to_adf(text)` MUST NOT emit any ADF `text` node containing a raw `\r` (U+000D) or raw `\n` (U+000A). Interior newlines (after normalizing `\r\n`→`\n`, lone `\r`→`\n`) are represented as `hardBreak` nodes. Blank lines (`\n\n`) produce separate `paragraph` nodes. Trailing `\r`/`\n` stripped before processing. Single-line inputs (no newline chars) produce byte-identical output to pre-fix `text_to_adf` (no regression). Fix site: `src/adf.rs::text_to_adf`. |

## Story Narrative

As a Jira user whose issue description, comment, or worklog message contains old-Mac
(`\r`), Windows (`\r\n`), or Unix (`\n`) line endings — whether from pasting legacy
content, piping from a file with CRLF line endings (common on Windows), using an
editor that saves CRLF, or constructing descriptions programmatically — I want
`jr issue create/edit --description`, `jr issue comment`, `jr worklog add --message`,
and JSM request descriptions to emit well-formed ADF without raw `\r` or `\n` in text
nodes, so that Jira accepts the request without a 400 error.

**Markdown path (EC-11):** `jr ... --markdown` routes through `markdown_to_adf`.
In headings and other non-codeBlock contexts a carriage return becomes a space
(preserving INV-1); in codeBlock context it becomes `\n`.

**Plain-text path (EC-12):** `jr ... --description TEXT` (without `--markdown`)
routes through `text_to_adf`. Interior newlines become `hardBreak` ADF nodes within
the enclosing paragraph; blank lines produce separate paragraph nodes; trailing
newlines are stripped. Single-line inputs produce byte-identical output to the pre-fix
function (no regression on the dominant use case).

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file — expanded to cover EC-11 + EC-12 + F5 bare-`\n` ACs AC-015..AC-019) | ~5,200 |
| `src/adf.rs` (full file — only modified file) | ~4,500 |
| BC-7.2.011 body (`bc-7-output-render.md` §BC-7.2.011, EC-11 + EC-12 sections) | ~2,000 |
| F1 delta analysis (`issue-522-delta-analysis.md`) | ~1,400 |
| F1 delta analysis extension (`issue-522-text-to-adf-extension.md`) | ~1,600 |
| Test output (`cargo test adf::tests`) | ~800 |
| **Total** | **~15,500** |

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

2. **F5 revision:** `push_text` and `push_code` apply context-aware normalization,
   NOT a uniform `\r`→`\n`. See the three-way dispatch in the Summary and
   Architecture Compliance Rules. Order still matters within each branch: always
   `replace("\r\n", X)` FIRST, then `replace('\r', X)` — doing `\r` first would
   turn `\r\n` into `X\n` (double replacement).

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
| Context-aware three-way dispatch | BC-7.2.011 EC-11 | `push_text` checks `self.stack.last()`: CodeBlock → `\r\n`→`\n` then `\r`→`\n`; HtmlBlock → no normalization (Algorithm B owns it); all others → `\r\n`→space then lone `\r`→space (INV-1 preserved). A uniform `\r`→`\n` across all contexts violates INV-1 for non-codeBlock text nodes. |
| Two-pass ordering within each context | BC-7.2.011 EC-11 | Within each normalization branch, `replace("\r\n", X)` FIRST, then `replace('\r', X)`. Swapping the order would turn `\r\n` into a double replacement. |
| contains('\r') fast-path guard | F1 delta analysis §1.1 | Wrap normalization in `if text.contains('\r')` to avoid allocation on LF-only (common) inputs. |
| Apply `\r`→space guard in push_code | F1 delta analysis §1.1 | `push_code` builds a `text` node with a `code` mark — same JSON hazard class; inline context → `\r`→space (not `\n`; defense-in-depth). |
| No new crate dependencies | F1 delta analysis §Impact Boundary | Fix uses only `std::str` methods and `serde_json::json!`/`Value`. Do NOT add any `Cargo.toml` entry. |
| `text_to_adf` (EC-12): normalize-then-split, not char-set split | BC-7.2.011 EC-12 §2 | The `text_to_adf` normalization MUST use two-pass (`\r\n`→`\n` then lone `\r`→`\n`) followed by split on `\n`. Do NOT use a `['\r','\n']` char-set split — same CRLF double-counting hazard as Algorithm B. |
| `text_to_adf` (EC-12): single-line fast path | BC-7.2.011 EC-12 §single-line guarantee | If the input contains no `\r`, `\n`, or `\r\n`, use the existing single-text-node `json!` construction unchanged. The output MUST be byte-identical to the pre-fix `text_to_adf` for all single-line inputs. |
| HtmlBlock end arm: byte-identical if helper extracted | F1 delta analysis extension §4 | IF `normalize_text_to_inline_nodes` is extracted as a shared helper, the HtmlBlock end arm MUST produce byte-identical output before and after the refactor. Run `cargo test -- adf::tests::test_block_html` to verify. |
| Call sites: no change | F1 delta analysis extension §8 | `src/cli/issue/create.rs`, `src/cli/issue/workflow.rs`, `src/cli/worklog.rs`, `src/api/jsm/requests.rs` — all call `text_to_adf` unchanged. The fix is entirely within `text_to_adf`. |
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
| `src/adf.rs` | MODIFY | **EC-11 changes:** (1) Add CONTEXT-AWARE CR normalization to `AdfBuilder::push_text`: inspect `self.stack.last()` — `CodeBlock` context → `\r\n`→`\n` then `\r`→`\n`; `HtmlBlock` context → no normalization; all other contexts → `\r\n`→space then lone `\r`→space. (2) Add `\r`→space guard to `AdfBuilder::push_code` (defense-in-depth). (3) Remove `strict_cr: bool` parameter from `assert_no_raw_newline_in_text_nodes`; make the `\r`-absence check unconditional. (4) RENAME `test_lone_cr_survives_pre_existing_492_oos` → `test_push_text_normalizes_lone_cr_in_heading_and_code_block`, remove `#[ignore]`, UPDATE assertions: heading text = `"x y"` (SPACE), codeBlock text = `"a\n"`, no `\r` in output, no non-codeBlock `\n` in output; update `assert_no_raw_newline_in_text_nodes` call to new signature (no `strict_cr` param). (5) RENAME `test_push_text_normalizes_crlf_in_paragraph` → `test_push_text_normalizes_lone_cr_in_fenced_code_block`. (6) UPDATE `prop_492_arbitrary_string_holds_core_invariants`: call `assert_no_raw_newline_in_text_nodes(&adf, &input)` (no `strict_cr` param); update inline comment. (7) UPDATE `prop_492_block_html_holds_core_invariants`: same signature update. (8) ADD `test_push_text_crlf_two_pass_ordering_deterministic` (direct push_text, AC-003). (9) ADD `test_push_code_normalizes_lone_cr_in_inline_code` (direct push_code, AC-004). **EC-12 changes:** (10) MODIFY `text_to_adf` to normalize CR/newlines per BC-7.2.011 EC-12: replace one-liner `json!` macro with normalize-and-split construction (strip trailing `\r`/`\n` → normalize `\r\n`→`\n` then lone `\r`→`\n` → split on blank lines → emit `paragraph` + `hardBreak` + `text` nodes). OPTIONAL: extract shared private helper `normalize_text_to_inline_nodes(text: &str) -> Option<Vec<Value>>` and call it from both the HtmlBlock end arm and `text_to_adf`; if extracted, HtmlBlock end arm output MUST remain byte-identical. (11) ADD `test_text_to_adf_single_line_unchanged` (AC-008 — regression guard). (12) ADD `test_text_to_adf_normalizes_interior_lf_to_hardbreak` (AC-009). (13) ADD `test_text_to_adf_normalizes_interior_crlf_to_hardbreak` (AC-010). (14) ADD `test_text_to_adf_normalizes_interior_lone_cr_to_hardbreak` (AC-011). (15) ADD `test_text_to_adf_strips_trailing_newlines` (AC-012). (16) ADD `test_text_to_adf_blank_line_produces_two_paragraphs` (or `_double_hardbreak` if hardBreak-only approach chosen) (AC-013). (17) ADD `test_text_to_adf_no_raw_newline_in_any_text_node` (AC-014). (18) OPTIONALLY ADD `prop_text_to_adf_holds_inv1` (AC-014 optional proptest). |

No new integration test files. All new tests are inline unit tests in `src/adf.rs::tests`.
No `docs/specs/` file created or modified (the spec doc `docs/specs/adf-block-html.md`
was created by S-492; a CLAUDE.md one-liner update to the BC-7.2.011 gotcha entry noting
that `\r` is now normalized across all paths is documentation fallout, NOT in scope for
this story — handle post-merge per the existing gotcha-update pattern).

## Acceptance Criteria

> **F5 revision note:** ACs revised during F5 adversarial review to reflect the
> INV-1-preserving context-aware contract (commit 7968d66). The original ACs described
> a uniform `\r`→`\n` across all block types; F5 found that applying `\r`→`\n` in
> non-codeBlock contexts (headings, paragraphs) would create a raw `\n` in a text node,
> violating INV-1. The implemented contract uses context dispatch: non-codeBlock→space,
> codeBlock→`\n`, HtmlBlock→untouched. Empirical outcomes corrected: `"# x\ry"` →
> heading `"x y"` (SPACE, not `"x\ny"`); `` `a\rb` `` → inline code `"a b"` (not
> `"a\nb"` via public path). Test names updated accordingly. BC-7.2.011 EC-11 updated
> to v1.9.8 by product-owner. **F5 Pass 2 (stale-prose sweep):** five remaining sites
> describing non-codeBlock CRLF→`"a\nb"` corrected to `"a b"` (space) in AC-003
> header/body, EC-004, Tasks Phase 1 step 3, and TDD Notes Green Gate table; all
> codeBlock-context `"a\nb"` claims preserved.

### AC-001 — `push_text` normalizes lone `\r` in heading (→ space) and codeBlock (→ `\n`)
(traces to BC-7.2.011 EC-11 / INV-push-text-cr postcondition — context-aware: heading `\r`→space; codeBlock `\r`→`\n`; no `\r` survives in either context)

`markdown_to_adf("# x\ry")` produces a heading node whose text nodes contain no
`\r` character AND no non-codeBlock text node contains a raw `\n`. Specifically,
the heading text value is `"x y"` (a SPACE — the lone `\r` in heading context is
normalized to space, NOT to `\n`, to preserve INV-1). No text-node `"text"` field
in the returned ADF value passes `contains('\r')`.

`markdown_to_adf("\ta\r")` (indented code block syntax) produces a codeBlock node
whose text-node `"text"` field contains no `\r` character. In the codeBlock context
the lone `\r` is normalized to `\n`, so the text value is `"a\n"`.

Both repros are covered by the renamed, de-ignored test
`test_push_text_normalizes_lone_cr_in_heading_and_code_block` (formerly
`test_lone_cr_survives_pre_existing_492_oos`). The test calls
`assert_no_raw_newline_in_text_nodes` with no `strict_cr` parameter (the parameter
has been removed; the `\r` check is now unconditional) and additionally asserts that
no non-codeBlock text node contains a raw `\n` character.

**Red Gate requirement:** The renamed test with inverted assertions MUST FAIL against
the pre-#522 `src/adf.rs` (where `push_text` does not normalize `\r`) and MUST PASS
after the context-aware normalization is added.

---

### AC-002 — `prop_492_arbitrary_string_holds_core_invariants` updated: `strict_cr` parameter removed (check now unconditional)
(traces to BC-7.2.011 EC-11 / INV-push-text-cr invariant — `assert_no_raw_newline_in_text_nodes` called without `strict_cr` param; `\r` check unconditional across all block types)

The proptest `prop_492_arbitrary_string_holds_core_invariants` in `src/adf.rs::tests`
is updated to call `assert_no_raw_newline_in_text_nodes(&adf, &input)` without a
`strict_cr` argument (the `strict_cr: bool` parameter has been removed from the
helper; the `\r`-absence check is now always applied). The inline comment at that
call site is updated from the old "pre-existing out-of-#492-scope defect —
`strict_cr=false` exempt" wording to:
"fixed in #522: push_text/push_code normalize lone \\r on the generic parser path
via context-aware dispatch (non-codeBlock→space, codeBlock→`\n`, HtmlBlock→untouched)".

After this change, the proptest runs 2048 cases including inputs containing lone `\r`
and asserts that no `\r` character survives into any text node in the returned ADF.
This is the desired regression harness for the fix.

**Red Gate requirement:** With the `strict_cr` parameter removed (check unconditional),
the proptest MUST FAIL against the pre-#522 code for some inputs containing `\r`, and
MUST PASS after the context-aware normalization is in place.

---

### AC-003 — New test: `test_push_text_crlf_two_pass_ordering_deterministic`
(traces to BC-7.2.011 EC-11 / INV-push-text-cr postcondition — CRLF two-pass ordering: `\r\n`→space is applied BEFORE lone-`\r`→space, so non-codeBlock `"a\r\nb"` produces `"a b"` not `"a  b"`; codeBlock `"a\r\nb"` produces `"a\nb"`)

A new unit test `test_push_text_crlf_two_pass_ordering_deterministic` is added to
`src/adf.rs::tests`. This test exercises the two-pass ordering constraint via a
**direct `push_text` call** (not via the `markdown_to_adf` public path, where
pulldown-cmark may process CRLF before it reaches `push_text`). The test asserts:
- Input `"a\r\nb"` to `push_text` in a **non-codeBlock** context produces text node
  `"a b"` (a single SPACE) — `\r\n` is collapsed to a space by the first pass before
  the lone-`\r`→space rule of the second pass can fire on any remaining lone `\r`.
  This pins the ordering: if the passes were swapped (lone-`\r`→space first), the
  `\r` in `\r\n` would first become a space, then the `\n` would stay, yielding
  `"a \nb"` (wrong — raw `\n` in non-codeBlock text node, INV-1 violation); if
  CRLF were collapsed to `\n` instead of space, the result would be `"a\nb"` (wrong
  — raw `\n` in non-codeBlock text node, INV-1 violation).
- Input `"a\r\nb"` to `push_text` in a **codeBlock** context produces text node
  `"a\nb"` — CRLF → `\n` is correct in codeBlock context (codeBlock text nodes may
  contain `\n`).
- No `\r` character appears in either resulting text node.
- No raw `\n` appears in a non-codeBlock text node (INV-1 preserved).

Test naming convention: `test_<verb>_<subject>_<expected_outcome>` per CLAUDE.md.

---

### AC-004 — New test: `test_push_code_normalizes_lone_cr_in_inline_code`
(traces to BC-7.2.011 EC-11 / INV-push-text-cr postcondition — `push_code` defense-in-depth guard verified via direct call; lone `\r` → space; NOT `\r`→`\n`)

A new unit test `test_push_code_normalizes_lone_cr_in_inline_code` is added to
`src/adf.rs::tests`. This test uses a **direct `push_code` call** (not
`markdown_to_adf("`a\rb`")`, which exercises pulldown-cmark's own §6.3 `\r`→space
conversion before the event reaches `push_code`). The test asserts:
- Direct `push_code("a\rb")` produces a text node with `"text": "a b"` — the lone
  `\r` is normalized to a SPACE (not `\n`; inline code is always inline context,
  never codeBlock context; converting `\r` to `\n` here would violate INV-1).
- No text node in the result contains a raw `\r` character.

**Public-path note (load-bearing):** `markdown_to_adf("`a\rb`")` → inline code text
node = `"a b"` because pulldown-cmark §6.3 converts the `\r` to space BEFORE emitting
`Event::Code`. The `push_code` guard is defense-in-depth for direct call sites and
future parser changes — do NOT assert `"a\nb"` from the public path (that would be
wrong; the result is `"a b"` regardless of which layer converts the `\r`).

This test exercises the `push_code` path specifically (not `push_text`), confirming
that the `Event::Code` arm also eliminates raw `\r` characters.

---

### AC-005 — `test_push_text_normalizes_lone_cr_in_heading_and_code_block` (renamed + de-ignored + inverted + F5-revised assertions)
(traces to BC-7.2.011 EC-11 — regression pin inverted; `#[ignore]` removed; heading asserts `"x y"` SPACE; codeBlock asserts no `\r`; unconditional `\r`+non-codeBlock-`\n` check)

The existing test `test_lone_cr_survives_pre_existing_492_oos` is:
1. **Renamed** to `test_push_text_normalizes_lone_cr_in_heading_and_code_block`
   (follows `test_<verb>_<subject>_<expected_outcome>` convention).
2. **De-ignored**: `#[ignore]` attribute removed.
3. **Assertions updated (F5-revised — context-aware contract)**:
   - The heading repro assertion changes from
     `assert!(heading_texts.iter().any(|t| t.contains('\r')), …)`
     to assertions that: (a) no heading text node contains `\r`; (b) the heading text
     value is `"x y"` (SPACE — not `"x\ny"`); (c) no non-codeBlock text node
     contains a raw `\n` character (INV-1 preserved).
   - The codeBlock repro assertion changes from
     `assert!(code_texts.iter().any(|t| t.contains('\r')), …)`
     to `assert!(code_texts.iter().all(|t| !t.contains('\r')), …)`.
   - The `assert_no_raw_newline_in_text_nodes` call uses the updated signature without
     the `strict_cr` parameter (the parameter was removed; the `\r` check is unconditional).

The two input strings (`"# x\ry"` and `"\ta\r"`) are unchanged. The ADF traversal
structure is unchanged. Only the `#[ignore]` attribute, the `assert!` conditions, and
the helper call signature change.

---

### AC-006 — Regression: existing `prop_492_block_html_holds_core_invariants` unaffected
(traces to BC-7.2.011 invariants — Algorithm B CR normalization pre-existing; block-HTML proptest continues to pass after `strict_cr` parameter removal)

The proptest `prop_492_block_html_holds_core_invariants` uses `gen_block_html()` and
called `assert_no_raw_newline_in_text_nodes(&adf, &input, true)`. After removing the
`strict_cr` parameter from the helper, this call is updated to the new signature
`assert_no_raw_newline_in_text_nodes(&adf, &input)`. The behavior is unchanged
(the `\r` check was already enforced with `strict_cr=true`; making it unconditional
does not change what is asserted). This property MUST continue to pass unchanged.

This AC is a regression guard, not a new behavior assertion.

---

### AC-007 — Full regression suite green; toolchain checks clean
(traces to BC-7.2.011 invariants — no regression on existing tests; clippy/fmt clean; no count drift)

All of the following must pass after the changes:

- `cargo test` exits 0 (all existing tests pass including the renamed/de-ignored
  test and the updated proptest; block-HTML tests from S-492 are unaffected).
- `cargo clippy -- -D warnings` exits 0; no new `#[allow]` attributes.
- `cargo fmt --all -- --check` exits 0.
- No new `unsafe` code.
- `scripts/check-spec-counts.sh` exits 0 (no BC frontmatter drift — this story
  adds new AC text to the BC-7.2.011 body but does NOT change any BC heading count
  or `total_bcs` / `definitional_count` frontmatter values in any bc-*.md file;
  the count-guard scripts count BC headings, not ACs).
- `scripts/check-bc-cumulative-counts.sh` exits 0 (no cumulative-count drift —
  no new BC-S.SS.NNN heading is created; only the existing BC-7.2.011 body gains
  new AC text which is not counted by this script).
- The ADF snapshot tests (`test_markdown_to_adf_snapshot` /
  `test_adf_to_text_snapshot`) are NOT changed (fixtures use LF-only inputs).
- No existing test asserts the old buggy behavior (i.e., that `\r` survives);
  only `test_lone_cr_survives_pre_existing_492_oos` did so, and it is renamed +
  updated in AC-005.

---

## Acceptance Criteria — EC-12 (`text_to_adf` plain-text path)

> **Scope note (EC-12 block):** ACs AC-008 through AC-014 cover the plain-text
> `text_to_adf` chokepoint (BC-7.2.011 EC-12 / INV-1-plain-text). They were added
> when issue #522 was expanded to include the plain-text sibling fix. All ACs in this
> block trace to BC-7.2.011 EC-12. The existing `test_text_to_adf` test
> (`text_to_adf("Hello world")`) is NOT modified — it is the pre-existing regression
> anchor that AC-008 formalizes.

---

### AC-008 — `text_to_adf` single-line input: byte-identical to current output (no regression)
(traces to BC-7.2.011 EC-12 / INV-1-plain-text postcondition — single-line no-regression guarantee: `text_to_adf("hello")` → `doc > [paragraph > [text("hello")]]`, unchanged from pre-fix)

A new test `test_text_to_adf_single_line_unchanged` asserts that
`text_to_adf("hello")` (an input with no `\r`, `\n`, or `\r\n` characters) produces
exactly:

```json
{
  "version": 1,
  "type": "doc",
  "content": [{
    "type": "paragraph",
    "content": [{"type": "text", "text": "hello"}]
  }]
}
```

This is byte-identical to the pre-fix `text_to_adf` output for all single-line inputs.
The test also verifies that `assert_no_raw_newline_in_text_nodes` passes (no `\r` or
non-codeBlock `\n` in any text node).

The existing test `test_text_to_adf` (`text_to_adf("Hello world")`) continues to pass
unmodified — it also exercises the single-line path and is NOT renamed or altered.

**Red Gate requirement:** This test PASSES even before the `text_to_adf` fix (the
single-line path is unchanged). Its purpose is to pin the no-regression guarantee
so any future change that breaks single-line inputs fails CI immediately.

---

### AC-009 — `text_to_adf` interior LF → `hardBreak` (one paragraph, no raw `\n`)
(traces to BC-7.2.011 EC-12 / INV-1-plain-text postcondition — interior LF within a single paragraph becomes a `hardBreak` node; no raw `\n` in any text node)

A new test `test_text_to_adf_normalizes_interior_lf_to_hardbreak` asserts that
`text_to_adf("line1\nline2")` produces:

```json
{
  "version": 1,
  "type": "doc",
  "content": [{
    "type": "paragraph",
    "content": [
      {"type": "text", "text": "line1"},
      {"type": "hardBreak"},
      {"type": "text", "text": "line2"}
    ]
  }]
}
```

No text node in the result contains a raw `\n` character (verified by
`assert_no_raw_newline_in_text_nodes`). The `hardBreak` node is the ADF-schema-
sanctioned representation of an intra-paragraph line break.

**Red Gate requirement:** Before the fix, `text_to_adf("line1\nline2")` embeds a raw
`\n` in the single text node `"line1\nline2"`. The test MUST FAIL against pre-fix code
and MUST PASS after the normalization is implemented.

---

### AC-010 — `text_to_adf` interior CRLF → `hardBreak` (normalized before split)
(traces to BC-7.2.011 EC-12 / INV-1-plain-text postcondition — `\r\n` normalized to `\n` in step 2, then split on `\n` → `hardBreak`; same output as AC-009)

A new test `test_text_to_adf_normalizes_interior_crlf_to_hardbreak` asserts that
`text_to_adf("line1\r\nline2")` produces the same paragraph structure as the
interior-LF case (AC-009):

```json
{"type": "paragraph", "content": [
  {"type": "text", "text": "line1"},
  {"type": "hardBreak"},
  {"type": "text", "text": "line2"}
]}
```

The two-pass ordering rule applies: `\r\n`→`\n` is applied FIRST (step 2), then the
result is split on `\n` (step 4). If the passes were swapped (split first), CRLF would
produce a double-counted boundary and a spurious extra `hardBreak`. No `\r` character
appears in any text node.

**Red Gate requirement:** Before the fix, `text_to_adf("line1\r\nline2")` embeds raw
`\r\n` in the text node. This test MUST FAIL pre-fix and MUST PASS post-fix.

---

### AC-011 — `text_to_adf` interior lone `\r` → `hardBreak` (old-Mac line endings)
(traces to BC-7.2.011 EC-12 / INV-1-plain-text postcondition — lone `\r` normalized to `\n` in step 2, then split → `hardBreak`; same output as AC-009)

A new test `test_text_to_adf_normalizes_interior_lone_cr_to_hardbreak` asserts that
`text_to_adf("line1\rline2")` produces the same paragraph structure as the interior-LF
case (AC-009):

```json
{"type": "paragraph", "content": [
  {"type": "text", "text": "line1"},
  {"type": "hardBreak"},
  {"type": "text", "text": "line2"}
]}
```

The two-pass ordering rule applies within step 2: `\r\n`→`\n` FIRST, then lone
`\r`→`\n`. Here only the lone-`\r` rule fires. No `\r` or raw `\n` appears in any
text node.

**Red Gate requirement:** Before the fix, `text_to_adf("line1\rline2")` embeds a raw
`\r` in the text node. This test MUST FAIL pre-fix and MUST PASS post-fix.

---

### AC-012 — `text_to_adf` strips trailing newlines (LF, CRLF, lone CR)
(traces to BC-7.2.011 EC-12 / INV-1-plain-text postcondition — step 1: trailing `\r`/`\n` stripped; output same as single-line input for `"hello\n"`, `"hello\r\n"`, `"hello\r"`)

A new test `test_text_to_adf_strips_trailing_newlines` asserts that all three of the
following produce the same single-paragraph, single-text-node structure as
`text_to_adf("hello")`:

- `text_to_adf("hello\n")` → `doc > [paragraph > [text("hello")]]`
- `text_to_adf("hello\r\n")` → `doc > [paragraph > [text("hello")]]`
- `text_to_adf("hello\r")` → `doc > [paragraph > [text("hello")]]`

No `\r` or raw `\n` appears in any text node in any of the three results. The trailing
strip is applied before normalization and split (step 1), so any number of trailing
`\r`/`\n` characters are removed regardless of order or count.

**Red Gate requirement:** Before the fix, each of the three inputs embeds a trailing
`\n` or `\r` in the text node. This test MUST FAIL for at least two of the three cases
pre-fix and MUST PASS for all three post-fix.

---

### AC-013 — `text_to_adf` blank line produces two separate `paragraph` nodes
(traces to BC-7.2.011 EC-12 / INV-1-plain-text postcondition — `\n\n` (blank line) splits input into two `paragraph` nodes; double/triple blank lines also produce exactly two paragraphs, not three)

**Note:** This AC covers the blank-line paragraph-splitting behavior. Per BC-7.2.011
EC-12 §3, the split is on `/\n{2,}/` — consecutive blank lines collapse to one
paragraph boundary. If the implementer chooses the simpler "hardBreak for all `\n`
including blank lines" approach (no paragraph splitting), this AC is replaced by
"blank line produces two consecutive `hardBreak` nodes in one paragraph" — the
implementer must align with whichever approach they choose, and the BC explicitly
permits either.

A test `test_text_to_adf_blank_line_produces_two_paragraphs` (or, if the
hardBreak-only approach is chosen, `test_text_to_adf_blank_line_produces_double_hardbreak`)
asserts the chosen behavior for `text_to_adf("line1\n\nline2")`. The test also asserts:

- No raw `\n` or `\r` in any text node (INV-1).
- `text_to_adf("line1\n\n\nline2")` (double blank) produces the same output as
  `text_to_adf("line1\n\nline2")` (consecutive blank lines → single boundary).

**Red Gate requirement:** Before the fix, both inputs produce a single text node with
raw `\n\n` or `\n\n\n` embedded. This test MUST FAIL pre-fix and MUST PASS post-fix.

---

### AC-014 — No raw `\r` or `\n` in ANY text node from `text_to_adf` — INV-1 property test
(traces to BC-7.2.011 EC-12 / INV-1-plain-text invariant — property-style: `assert_no_raw_newline_in_text_nodes` passes for a sample of multi-line inputs; optional `prop_text_to_adf_holds_inv1` proptest)

A new test `test_text_to_adf_no_raw_newline_in_any_text_node` asserts that
`assert_no_raw_newline_in_text_nodes` (the existing helper, already used by EC-11
tests) passes for a representative sample of multi-line inputs:

- `text_to_adf("a\nb")` — interior LF
- `text_to_adf("a\r\nb")` — interior CRLF
- `text_to_adf("a\rb")` — interior lone CR
- `text_to_adf("a\n\nb")` — blank-line boundary
- `text_to_adf("a\r\n\r\nb")` — CRLF blank line
- `text_to_adf("a\nb\n\nc\nd")` — mixed interior LF + blank-line boundary
- `text_to_adf("\n\n\n")` — all newlines → empty paragraph

For each input, `assert_no_raw_newline_in_text_nodes(&result, input)` MUST pass — no
`text` node in the returned ADF value contains a raw `\r` (U+000D) or raw `\n`
(U+000A).

**Optional proptest `prop_text_to_adf_holds_inv1`** (low-cost extension — implement if
proptest infrastructure is already warmed up from EC-11 tests):

```rust
#[test]
fn prop_text_to_adf_holds_inv1() {
    let mut config = ProptestConfig::default();
    config.cases = 1000;
    TestRunner::new(config)
        .run(
            &string_regex("[\\r\\n\\t a-zA-Z0-9]{0,64}").unwrap(),
            |input| {
                let adf = text_to_adf(&input);
                assert_no_raw_newline_in_text_nodes(&adf, &input);
                Ok(())
            },
        )
        .unwrap();
}
```

The committed test uses a manual `TestRunner::new(config).run(&string_regex(...), |input| { ... })` form (not the `proptest!` macro) because EC-11's `prop_492_arbitrary_string_holds_core_invariants` uses the same manual runner pattern. The strategy regex `"[\\r\\n\\t a-zA-Z0-9]{0,64}"` explicitly samples `\r` (U+000D), `\n` (U+000A), tab, space, and alphanumeric characters, bounded to 0–64 characters — `".*"` does NOT match `\n` in the default regex flavour used by proptest, so it would silently exclude the very inputs the property needs to cover. The bounded charset ensures `\r`, `\n`, and `\r\n` sequences are generated while keeping proptest run times predictable. This generatively verifies INV-1 for the new implementation and is the `text_to_adf` equivalent of the updated `prop_492_arbitrary_string_holds_core_invariants` (EC-11 proptest).

**Red Gate requirement:** Before the fix, `assert_no_raw_newline_in_text_nodes` fails
for any multi-line input (all produce raw `\n` in text nodes). This test MUST FAIL
pre-fix and MUST PASS post-fix. The optional proptest, if added, MUST also fail
pre-fix and pass post-fix.

---

## Acceptance Criteria — EC-11 bare-`\n` chokepoint (F5 HIGH-severity refinement)

> **F5 HIGH-severity refinement note (commit 182a93d):** F5 adversarial review found
> that the original EC-11 fix handled `\r` presence but left a bare `\n` (no `\r`)
> reachable in Other (non-codeBlock) contexts. A bare `\n` in a text node is an INV-1
> violation — Jira rejects with HTTP 400. Confirmed end-to-end reachable via multi-line
> inline HTML: `markdown_to_adf("foo <span\ndata-x=\"1\">bar")` placed a raw `\n` into
> a text node. The fix (commit 182a93d) makes `push_text` / `push_code` self-sufficient
> in Other context: bare `\n` → space (mirrors SoftBreak→" " and the `\r`→space rule);
> codeBlock PRESERVES `\n`; HtmlBlock owned by Algorithm B (unchanged). ACs AC-015
> through AC-019 trace to BC-7.2.011 EC-11 / INV-1 (v1.11.0).

---

### AC-015 — `push_text` in Other context normalizes bare `\n` to space
(traces to BC-7.2.011 EC-11 / INV-1 postcondition — Other context: bare `\n` in input → space in text node; no raw `\n` survives; mirrors SoftBreak→" " and `\r`→space rule)

A new test `test_push_text_normalizes_bare_lf_in_other_context_to_space` asserts that
a direct `push_text` call in a non-codeBlock context (e.g., paragraph) with input
`"a\nb"` produces a text node with value `"a b"` (a SPACE — the bare `\n` is
normalized to space, NOT preserved). No text node in the result contains a raw `\n`
character (`assert_no_raw_newline_in_text_nodes` passes). This test covers the
self-sufficient chokepoint behavior: `push_text` alone (without relying on upstream
pulldown-cmark CR-stripping) prevents INV-1 violations in Other contexts.

The fix ensures that the `contains('\r')` fast-path guard is widened — or that the
bare-`\n` normalization runs independently — so that an input with a bare `\n` and no
`\r` is also normalized. The test specifically targets inputs with only `\n` (no `\r`)
to cover the regression path that was missed by the original `contains('\r')` guard.

**Red Gate requirement:** Before commit 182a93d, `push_text("a\nb")` in Other context
passes the `\n` through unchanged (INV-1 violation). This test MUST FAIL against
pre-182a93d code and MUST PASS after.

---

### AC-016 — `push_text` in CodeBlock context preserves bare `\n` byte-identically
(traces to BC-7.2.011 EC-11 / INV-1 invariant — CodeBlock context: bare `\n` is preserved; codeBlock text nodes may contain `\n`; no regression on the code-display path)

A new test `test_push_text_codeblock_preserves_bare_lf` asserts that a direct
`push_text` call in a CodeBlock context with input `"a\nb"` produces a text node with
value `"a\nb"` — the bare `\n` is preserved byte-identically (codeBlock text nodes are
explicitly permitted to contain `\n` per INV-1). This test is the codeBlock complement
of AC-015 and ensures the context-aware dispatch does NOT collapse `\n`→space in the
CodeBlock arm.

**Red Gate requirement:** This test PASSES both before and after the fix (codeBlock `\n`
preservation is pre-existing correct behavior). Its purpose is a regression pin: any
future change that accidentally normalizes `\n`→space in codeBlock context will fail
this test immediately.

---

### AC-017 — `push_code` (inline) normalizes bare `\n` to space
(traces to BC-7.2.011 EC-11 / INV-1 postcondition — `push_code` defense-in-depth: bare `\n` → space; inline code is always Other context; INV-1 preserved)

A new test `test_push_code_normalizes_bare_lf_to_space` asserts that a direct
`push_code("a\nb")` call produces a text node with value `"a b"` (a SPACE — the bare
`\n` in an inline code span is normalized to space). No text node contains a raw `\n`
character. Inline code spans are always in inline/non-codeBlock context; a bare `\n` in
an inline code span would violate INV-1.

This is the bare-`\n` counterpart to AC-004 (which covers `push_code` for `\r`).
Together AC-004 and AC-017 pin that `push_code` normalizes BOTH lone `\r` and bare `\n`
to space in inline context.

**Red Gate requirement:** Before commit 182a93d, `push_code("a\nb")` passes the `\n`
through unchanged. This test MUST FAIL against pre-182a93d code and MUST PASS after.

---

### AC-018 — End-to-end: `markdown_to_adf` with multi-line inline HTML upholds INV-1
(traces to BC-7.2.011 EC-11 / INV-1 postcondition — end-to-end reachable path: multi-line inline HTML in markdown input; no raw `\n` in any text node; confirms reachability of the bug)

A new test `test_markdown_multiline_inline_html_holds_inv1` asserts that
`markdown_to_adf("foo <span\ndata-x=\"1\">bar")` produces an ADF value in which no
text node contains a raw `\n` character (`assert_no_raw_newline_in_text_nodes` passes).
This is the exact end-to-end reachable path confirmed by F5 adversarial review — a
bare `\n` embedded in an inline HTML tag reaches `push_text` in Other (paragraph)
context, and without the fix, the `\n` survives into the text node (INV-1 violation,
Jira HTTP 400).

**Red Gate requirement (load-bearing):** This test MUST FAIL against pre-182a93d code
(the `\n` in the inline HTML tag survives into a text node) and MUST PASS after the
fix. This is the primary reachability proof: RED before fix, GREEN after fix confirms
that the F5-identified bug was real and the fix closes it.

---

### AC-019 — Property test: inline-HTML/markdown path fuzzing upholds INV-1
(traces to BC-7.2.011 EC-11 / INV-1 invariant — property-based: inputs interleaving `<>/"=` with `\r`/`\n` generate no raw newline in any text node; generative regression harness)

A new property test `prop_markdown_to_adf_html_chars_holds_inv1` generates inputs that
interleave HTML-relevant characters (`<`, `>`, `"`, `/`, `=`) with `\r`, `\n`, and
printable ASCII characters, and asserts that `assert_no_raw_newline_in_text_nodes`
passes for each generated input through `markdown_to_adf`. The strategy is designed to
exercise the multi-line inline-HTML path (AC-018) generatively, covering variations
that a manually authored test would miss (e.g., `\r\n` between attribute name and
value, multiple HTML tags each with embedded newlines, nested inline HTML, etc.).

The test uses the same manual `TestRunner::new(config).run(...)` form as the other EC-11
propertests. The strategy charset includes `[\r\n <>"/=a-zA-Z0-9]{0,80}` to reliably
generate inline-HTML-shaped fragments with embedded newlines.

**Red Gate requirement:** Before commit 182a93d, this proptest finds counterexamples
where `\n` survives into text nodes from inline-HTML paths. This test MUST FAIL
against pre-182a93d code and MUST PASS after the fix.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-001 | Lone `\r` in heading (`"# x\ry"`) | `push_text` in non-codeBlock context normalizes `\r` → SPACE; heading text value is `"x y"` (not `"x\ny"`) — INV-1 preserved |
| EC-002 | Indented codeBlock with trailing `\r` (`"\ta\r"`) | `push_text` in codeBlock context normalizes `\r` → `\n`; codeBlock text value is `"a\n"`; no `\r` in output |
| EC-003 | Inline code span with lone `\r` (`` "`a\rb`" `` via `markdown_to_adf`) | pulldown-cmark §6.3 converts `\r`→space before `Event::Code`; inline code text value is `"a b"` (space, not `\n`); `push_code` guard is defense-in-depth verified only via direct call |
| EC-004 | CRLF ordering pin (direct `push_text("a\r\nb")` in non-codeBlock context) | Two-pass non-codeBlock: `\r\n`→space first, then lone-`\r`→space (no lone `\r` remains after first pass); result `"a b"` (single space). If passes were swapped (lone-`\r`→space first), the `\n` would survive as a raw `\n`, yielding `"a \nb"` (INV-1 violation). codeBlock context: `\r\n`→`\n`; result `"a\nb"`. |
| EC-005 | LF-only input (common case) | `contains('\r')` is false; no allocation; existing behavior unchanged |
| EC-006 | Inline HTML with lone `\r` (`<em>\rx</em>` inside paragraph) | `Event::InlineHtml` routes to `push_text` in non-codeBlock context; `\r` normalized to SPACE (paragraph context); no `\r` or raw `\n` in output |
| EC-007 | Block HTML with CRLF (e.g., `<div>\r\nx</div>`) | Algorithm B (NodeKind::HtmlBlock step 3) normalizes independently; `push_text` NOT called from that handler (HtmlBlock context → CR untouched by push_text); no double-normalization |
| EC-008 | Multiple consecutive `\r` in non-codeBlock (e.g., `"a\r\rb"`) | Two-pass in non-codeBlock: `replace("\r\n", "\n")` finds no CRLF; `replace('\r', ' ')` normalizes both lone `\r`s to spaces; result `"a  b"` (two spaces) |
| EC-009 | `text_to_adf` with all-newline input (`"\n\n\n"`) | Trailing strip removes all `\n`; result after strip is `""` → single paragraph with empty text node `text("")` (same as `text_to_adf("")`) |
| EC-010 | `text_to_adf` with mixed interior LF + blank-line boundary (`"a\nb\n\nc\nd"`) | Two blocks after blank-line split: `"a\nb"` → `[text("a"), hardBreak, text("b")]`; `"c\nd"` → `[text("c"), hardBreak, text("d")]`; output is `doc > [paragraph1, paragraph2]`; no raw `\n` in any text node |

## Architecture Mapping

| Component | File | Pure/Effectful |
|-----------|------|---------------|
| `AdfBuilder::push_text` | `src/adf.rs` | Pure (no I/O; deterministic string transform) — EC-11 fix site |
| `AdfBuilder::push_code` | `src/adf.rs` | Pure — EC-11 defense-in-depth |
| `text_to_adf` | `src/adf.rs` | Pure (no I/O; replaces one-liner `json!` macro with normalize+split) — EC-12 fix site |
| `normalize_text_to_inline_nodes` | `src/adf.rs` (optional private helper) | Pure — shared by `text_to_adf` and optionally HtmlBlock end arm |
| Unit tests (renamed/new) | `src/adf.rs::tests` | N/A — tests |

## Tasks

### Phase 1 — Test-writer (Red Gate) — EC-11: `push_text` / `push_code`

In `src/adf.rs::tests`:

1. **Rename + de-ignore + update** `test_lone_cr_survives_pre_existing_492_oos`:
   - Remove `#[ignore]` attribute.
   - Rename to `test_push_text_normalizes_lone_cr_in_heading_and_code_block`.
   - Update assertions (F5-revised, context-aware):
     - Heading repro (`"# x\ry"`): assert text value is `"x y"` (SPACE, NOT `"x\ny"`); assert no `\r` in any text node; assert no non-codeBlock text node contains raw `\n`.
     - codeBlock repro (`"\ta\r"`): assert `all(|t| !t.contains('\r'))` (was `any(|t| t.contains('\r'))`).
   - Update `assert_no_raw_newline_in_text_nodes` call to new signature without `strict_cr` parameter.
   - Verify this test NOW FAILS on the pre-fix code (`cargo test test_push_text_normalizes_lone_cr_in_heading_and_code_block -- --include-ignored` should FAIL before code change).

2. **Update proptest** `prop_492_arbitrary_string_holds_core_invariants`:
   - Remove the `strict_cr: bool` parameter from `assert_no_raw_newline_in_text_nodes` (the `\r` check is now unconditional in the helper).
   - Change call from `assert_no_raw_newline_in_text_nodes(&adf, &input, false)` → `assert_no_raw_newline_in_text_nodes(&adf, &input)`.
   - Update inline comment to: "fixed in #522: push_text/push_code normalize lone \\r via context-aware dispatch".
   - Verify proptest FAILS on pre-fix code for inputs containing `\r`.

3. **Add** `test_push_text_crlf_two_pass_ordering_deterministic`: direct `push_text("a\r\nb")` in non-codeBlock context → text node `"a b"` (single space; CRLF collapsed to space by first pass, no lone `\r` remains for second pass; no `\r`, no raw `\n`); direct `push_text("a\r\nb")` in codeBlock context → text node `"a\nb"` (`\r\n`→`\n` is correct in codeBlock).

4. **Add** `test_push_code_normalizes_lone_cr_in_inline_code`: direct `push_code("a\rb")` call → text node `"text"` equals `"a b"` (SPACE — defense-in-depth guard; do NOT use `markdown_to_adf("`a\rb`")` for this test because pulldown-cmark §6.3 already converts `\r`→space before the event reaches `push_code`).

After step 1: `cargo test test_push_text_normalizes_lone_cr_in_heading_and_code_block` FAILS (Red Gate confirmed).
After all 4 steps: `cargo test` will have failures on the new/modified tests and the proptest — do NOT implement yet.

### Phase 1b — Test-writer (Red Gate) — EC-12: `text_to_adf`

In `src/adf.rs::tests` (continue the same file, immediately after the EC-11 tests):

5. **Add** `test_text_to_adf_single_line_unchanged` (AC-008):
   - Asserts `text_to_adf("hello")` produces exactly `doc > [paragraph > [text("hello")]]`.
   - Also verifies `assert_no_raw_newline_in_text_nodes` passes.
   - **This test PASSES pre-fix** (single-line path unchanged). Its purpose is to pin
     the no-regression guarantee — any future change that breaks single-line inputs
     will fail CI. Write it now anyway so the suite is complete at Red Gate.

6. **Add** `test_text_to_adf_normalizes_interior_lf_to_hardbreak` (AC-009):
   - Asserts `text_to_adf("line1\nline2")` → `paragraph > [text("line1"), hardBreak, text("line2")]`.
   - Asserts `assert_no_raw_newline_in_text_nodes` passes.
   - **This test MUST FAIL pre-fix** (pre-fix embeds raw `\n` in text node).

7. **Add** `test_text_to_adf_normalizes_interior_crlf_to_hardbreak` (AC-010):
   - Asserts `text_to_adf("line1\r\nline2")` → same output as AC-009.
   - Asserts no `\r` or raw `\n` in any text node.
   - **MUST FAIL pre-fix.**

8. **Add** `test_text_to_adf_normalizes_interior_lone_cr_to_hardbreak` (AC-011):
   - Asserts `text_to_adf("line1\rline2")` → same output as AC-009.
   - Asserts no `\r` or raw `\n` in any text node.
   - **MUST FAIL pre-fix.**

9. **Add** `test_text_to_adf_strips_trailing_newlines` (AC-012):
   - Asserts `text_to_adf("hello\n")`, `text_to_adf("hello\r\n")`, and
     `text_to_adf("hello\r")` each produce `doc > [paragraph > [text("hello")]]`.
   - **MUST FAIL for at least two of three cases pre-fix.**

10. **Add** `test_text_to_adf_blank_line_produces_two_paragraphs` (AC-013):
    - Asserts the chosen blank-line behavior for `text_to_adf("line1\n\nline2")` and
      `text_to_adf("line1\n\n\nline2")` (both produce the same output).
    - If paragraph-split approach: asserts two `paragraph` nodes.
    - If hardBreak-only approach: asserts two consecutive `hardBreak` nodes.
    - Asserts `assert_no_raw_newline_in_text_nodes` for both inputs.
    - **MUST FAIL pre-fix** (pre-fix embeds raw `\n\n` in text node).

11. **Add** `test_text_to_adf_no_raw_newline_in_any_text_node` (AC-014):
    - Asserts `assert_no_raw_newline_in_text_nodes` passes for the full sample
      list from AC-014: `"a\nb"`, `"a\r\nb"`, `"a\rb"`, `"a\n\nb"`,
      `"a\r\n\r\nb"`, `"a\nb\n\nc\nd"`, `"\n\n\n"`.
    - **MUST FAIL pre-fix** for all multi-line inputs.

12. **Optionally add** `prop_text_to_adf_holds_inv1` (AC-014 optional):
    - If proptest infrastructure is warmed up from step 2, add the companion property
      that generates arbitrary strings and asserts `assert_no_raw_newline_in_text_nodes`
      on `text_to_adf` output.
    - **MUST FAIL pre-fix** for proptest strategies generating `\r`/`\n` inputs.

After all Phase 1b steps: `cargo test` will have additional failures on EC-12 tests —
the test suite is now MAXIMALLY RED (both EC-11 and EC-12 failures visible).

### Phase 2 — Implementer (Green Gate) — EC-11: `push_text` / `push_code`

In `src/adf.rs`:

13. **Add context-aware CR normalization to `push_text`** — inspect `self.stack.last()` to determine context, then apply the appropriate rule before building any ADF text node:
    - `CodeBlock` context: `replace("\r\n", "\n").replace('\r', "\n")` (two-pass; `\r`→`\n` is safe in codeBlock).
    - `HtmlBlock` context: no normalization (Algorithm B owns CR for this context).
    - All other contexts (heading, paragraph, etc.): `replace("\r\n", " ").replace('\r', " ")` or equivalently collapse `\r\n`→space then lone `\r`→space (preserves INV-1 — no raw `\n` introduced in non-codeBlock text nodes).
    Wrap in `if text.contains('\r') { ... } else { text }` fast-path guard.

14. **Add `\r`→space guard to `push_code`** — inline code spans are always in inline/non-codeBlock context; lone `\r` → space. Same `contains('\r')` fast-path guard.

### Phase 2b — Implementer (Green Gate) — EC-12: `text_to_adf`

In `src/adf.rs`:

15. **Modify `text_to_adf`** — replace the one-liner `json!` macro with the
    normalize-and-split construction implementing BC-7.2.011 EC-12:
    1. Strip trailing `\r` and `\n` characters.
    2. Normalize `\r\n`→`\n`, then lone `\r`→`\n` (two-pass; do NOT use a char-set
       split — same CRLF double-counting hazard as Algorithm B).
    3. Split on blank lines (`/\n{2,}/` or `"\n\n"` with consecutive-collapse
       logic) to produce paragraph blocks.
    4. For each block, split on `\n` and emit alternating `text` + `hardBreak` nodes;
       trim leading/trailing `hardBreak`.
    5. Wrap each block in a `paragraph` node; emit `doc` with all paragraphs.
    - **Fast-path guard:** if the input contains no `\r` or `\n`, use the current
      single-text-node construction unchanged (avoids allocation on the common case).
    - **Optional shared helper:** if factoring into `normalize_text_to_inline_nodes`,
      the HtmlBlock end arm MUST produce byte-identical results after the refactor.
      If any risk of regression, implement `text_to_adf` normalization inline without
      touching the HtmlBlock arm.

### Phase 3 — Verification

16. **Run** `cargo test` — ALL tests (EC-11 + EC-12) must PASS (Green Gate).

17. **Run** `cargo clippy -- -D warnings` — must exit 0. If any clippy warning arises from the rebinding pattern, refactor to fix the root cause (do NOT add `#[allow]`).

18. **Run** `cargo fmt --all -- --check` — must exit 0.

19. **Run** `scripts/check-spec-counts.sh` — must exit 0 (no count drift).

20. **Run** `scripts/check-bc-cumulative-counts.sh` — must exit 0 (no cumulative count drift).

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

### EC-11 (`push_text` / `push_code`)

| Test | Red Gate (pre-#522 code) | Green Gate (post-fix) |
|------|--------------------------|----------------------|
| `test_push_text_normalizes_lone_cr_in_heading_and_code_block` (RENAMED + INVERTED + F5-REVISED) | FAILS — `push_text` does not normalize `\r`; heading text contains `\r`; inverted assertions catch the bug | PASSES — heading `\r`→space (text = `"x y"`); codeBlock `\r`→`\n` (text = `"a\n"`); no `\r` or non-codeBlock `\n` in output |
| `prop_492_arbitrary_string_holds_core_invariants` (`strict_cr` PARAM REMOVED — check unconditional) | FAILS for some inputs containing `\r` — proptest finds a counterexample | PASSES — all 2048 cases including those with `\r` produce `\r`-free text nodes |
| `test_push_text_crlf_two_pass_ordering_deterministic` (NEW) | FAILS — without the fix, direct `push_text("a\r\nb")` in non-codeBlock passes `\r` through or produces wrong ordering | PASSES — non-codeBlock `"a\r\nb"` → `"a b"` (single space; CRLF first-pass → space, no lone `\r` for second pass); codeBlock `"a\r\nb"` → `"a\nb"` (CRLF → `\n` in codeBlock context) |
| `test_push_code_normalizes_lone_cr_in_inline_code` (NEW — defense-in-depth, direct call) | FAILS — direct `push_code("a\rb")` passes `\r` through; text node is `"a\rb"` | PASSES — direct `push_code("a\rb")` → text node `"a b"` (SPACE; `\r`→space in inline context) |
| `test_push_text_normalizes_lone_cr_in_fenced_code_block` (RENAMED from `test_push_text_normalizes_crlf_in_paragraph`) | FAILS — fenced codeBlock `\r` not normalized pre-fix | PASSES — fenced codeBlock `\r`→`\n` (codeBlock context) |
| `prop_492_block_html_holds_core_invariants` (`strict_cr` PARAM REMOVED — call signature updated) | PASSES — block-HTML path already clean; `strict_cr` removal is a no-op on behavior | PASSES unchanged |
| All existing `adf::tests` | PASS unchanged — LF-only inputs; no behavior change | PASS unchanged |

### EC-12 (`text_to_adf`)

| Test | Red Gate (pre-fix) | Green Gate (post-fix) |
|------|---------------------|----------------------|
| `test_text_to_adf_single_line_unchanged` (NEW — regression guard) | PASSES — single-line path unchanged (this is the no-regression pin) | PASSES unchanged — byte-identical output for single-line inputs |
| `test_text_to_adf_normalizes_interior_lf_to_hardbreak` (NEW) | FAILS — `text_to_adf("line1\nline2")` embeds raw `\n` in text node | PASSES — paragraph > `[text("line1"), hardBreak, text("line2")]`; no raw `\n` in text nodes |
| `test_text_to_adf_normalizes_interior_crlf_to_hardbreak` (NEW) | FAILS — `text_to_adf("line1\r\nline2")` embeds raw `\r\n` in text node | PASSES — same output as interior-LF case; two-pass ordering produces one hardBreak |
| `test_text_to_adf_normalizes_interior_lone_cr_to_hardbreak` (NEW) | FAILS — `text_to_adf("line1\rline2")` embeds raw `\r` in text node | PASSES — same output as interior-LF case; lone `\r` normalized to `\n` then split |
| `test_text_to_adf_strips_trailing_newlines` (NEW) | FAILS — `text_to_adf("hello\n")` etc. leave `\n` in text node | PASSES — all three trailing-newline variants produce same output as `text_to_adf("hello")` |
| `test_text_to_adf_blank_line_produces_two_paragraphs` (NEW) | FAILS — `text_to_adf("line1\n\nline2")` embeds raw `\n\n` in text node | PASSES — blank line produces two separate `paragraph` nodes (or double `hardBreak`, per chosen approach) |
| `test_text_to_adf_no_raw_newline_in_any_text_node` (NEW) | FAILS — `assert_no_raw_newline_in_text_nodes` fails for all multi-line inputs | PASSES — all sample inputs produce text nodes with no raw `\r` or `\n` |
| `prop_text_to_adf_holds_inv1` (NEW, optional) | FAILS for inputs containing `\r`/`\n` | PASSES — all generated inputs produce INV-1-compliant text nodes |
