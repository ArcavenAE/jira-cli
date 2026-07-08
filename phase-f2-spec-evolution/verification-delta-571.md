---
document_type: verification-delta
issue: "#571"
title: "Verification properties for ADF code-mark exclusivity"
date: "2026-07-07"
phase: F2
new_vps:
  - VP-571-001
  - VP-571-002
  - VP-571-003
  - VP-571-004
  - VP-571-005
related_bcs:
  - BC-7.2.015
  - BC-7.2.007
updated_vps: []
---

# Verification Delta — Issue #571: ADF Code-Mark Exclusivity

Companion to `.factory/phase-f2-spec-evolution/prd-delta-571.md`. Defines the
verification properties (VPs) that pin BC-7.2.015 (positive mark-coexistence
invariant) and the closure of BC-7.2.007 EC-2 (deferred follow-up from #474).

**Verification toolchain in scope for this cycle**: proptest + example-based
unit tests inside `src/adf.rs::tests` + `cargo-mutants` (`src/adf.rs` is in
`.cargo/mutants.toml` §examine_globs). This project has never used Kani or any
other formal-methods toolchain for `adf.rs` — no new toolchain is introduced.

**Registration surface**: VPs are recorded inline in a `**Verification
Properties**:` subsection of the BC-7.2.015 body in
`.factory/specs/prd/bc-7-output-render.md`. This project inlines VPs directly
in BC bodies rather than maintaining a separate VP-INDEX / VP-registry /
verification-architecture.md — see the "Project Convention Note" section at the
foot of `.factory/phase-f2-spec-evolution/verification-delta-398.md`. No
separate index propagation is required. Frontmatter of `bc-7-output-render.md`
has no VP-count fields; no additional count sweep is triggered by this delta.

---

## New Verification Properties

### VP-571-001: Property-based code-mark exclusivity invariant (primary property)

**Description**: Over generated markdown inputs, `markdown_to_adf` output
satisfies the following whole-document invariant: for **every** ADF text node
anywhere in the tree whose `marks` array contains a mark of type `"code"`, that
same `marks` array contains **no mark of any type outside the allow-set
`{"code", "link", "annotation"}`**. Equivalently: the forbidden set on a
code-marked text node is `{"strong", "em", "strike", "subsup", "underline",
"textColor", "backgroundColor"}` (and any future typographic mark). This is the
BC-7.2.015 positive invariant expressed as a universal quantifier over the
emitted ADF, and it holds regardless of nesting context (paragraphs, headings,
blockquotes, lists / task lists, panels, table cells, etc.).

**Applies to**:
- BC-7.2.015 (all ECs — this property IS the BC's normal form).
- BC-7.2.007 EC-2 (closure of "not guarded here, tracked as a follow-up" — the
  property now holds for the subsup+code combination that EC-2 previously
  documented as unguarded).

**Test strategy** (proptest, `src/adf.rs::tests`):

1. **Generator**: build a proptest strategy `gen_mark_composition_markdown()`
   that generates markdown strings biased toward inline-code composition with
   typographic wrappers and links. Suggested space (representative, not
   exhaustive):
   - **Alphabet**: `[a-z]{1,4}` for text bodies (small — the invariant is on
     mark structure, not text content; small strings shrink faster).
   - **Inline templates** (chosen with `prop_oneof![...]`):
     - `` `{body}` `` (plain code, control)
     - `` **`{body}`** `` (strong+code — EC-1)
     - `` _`{body}`_ `` (em+code — EC-2)
     - `` ~~`{body}`~~ `` (strike+code — EC-3)
     - `` ^`{body}`^ `` (subsup sup+code — EC-4 primary regression target)
     - `` ~`{body}`~ `` (subsup sub+code — EC-4 variant)
     - `` [`{body}`](https://x/{seg}) `` (link+code — EC-5 preservation)
     - `` **a `{body}` c** `` and `` _a `{body}` c_ `` (mixed range — EC-6)
     - Nested combinations (e.g. `` **_`{body}`_** ``, `` [**`{body}`**](url) ``)
   - **Container wrappers** (chosen with `prop_oneof![...]`, to cover
     nested contexts). The strategy MUST include exactly these nine
     wrappers, no more and no fewer — R9 scope authority, see below:

     1. **none** (bare inline template at document root)
     2. **blockquote** (`> `)
     3. **unordered list** (`- `)
     4. **ordered list** (`1. `)
     5. **GFM task list** (`- [ ] ` / `- [x] `)
     6. **GFM alert** (`> [!NOTE]\n> `) — see Footnote A below
     7. **heading** (`## `)
     8. **GFM table cell** — see Footnote B below
     9. **footnote-definition body** — see Footnote C below

     Every entry in this wrapper list corresponds one-to-one with an
     ADF container node type enumerated by the traversal helper (see
     "Property body" bullet below): `blockquote.content`,
     `listItem.content`/`bulletList.content`/`orderedList.content`,
     `taskItem.content`/`taskList.content`, `panel.content`,
     `heading.content`, `table.content`/`tableRow.content`/`tableCell.content`/`tableHeader.content`, and the appended footnote-section
     `paragraph.content`. This ensures the property is not
     accidentally-true only at the top-level paragraph — every listed
     nested context routes through the same `push_code` chokepoint.

     **Footnote A (GFM alert — outermost-only constraint, R10 ruling)**:
     when the alert wrapper is chosen it MUST be the outermost wrapper;
     the generator MUST NOT nest the alert inside any other wrapper
     (list / blockquote / task list / table cell / footnote-definition
     body). Rationale: alert markers only open
     `Tag::BlockQuote(Some(kind))` in positions pulldown-cmark accepts
     — an alert marker inside a list item or another blockquote is
     not recognized as an alert and degrades to plain text or a nested
     blockquote (silently), producing no `panel` node and no
     traversal into `panel.content`. Constraining alerts to outermost
     position keeps the wrapper honest. Implementation: build the
     alert branch as `Just(WrapKind::Alert)` gated by a `depth == 0`
     predicate in `prop_oneof![...]`, or exclude the alert branch
     from the recursive-nesting strategy and only include it at the
     top-level wrap step.

     **Footnote B (GFM table cell — 2-column shape)**: 2-column,
     1-row header + 1-row body: `` | {inline_template} | plain |\n|---|---|\n| plain | {inline_template} | `` — exercises the `table` →
     `tableRow` → `tableHeader`/`tableCell` container chain so
     table-cell content flows through `active_marks` the same way as
     top-level paragraph content.

     **Footnote C (footnote-definition body — mechanism)**: reference
     `` Body.[^1]\n\n[^1]: {inline_template} `` — pulldown-cmark
     emits `Tag::FootnoteDefinition(label)` which `AdfBuilder::start`
     pushes as `NodeKind::FootnoteDefinition { label }`; inline
     events inside the definition body route through the normal
     `push_text` / `push_code` chokepoints (so typographic marks
     around inline code inside the definition body are exercised at
     emission time via the same `push_code` filter site as any
     other paragraph); at `NodeKind::FootnoteDefinition` end, the
     built blocks are extended into `self.footnote_defs`, which is
     finally flushed by `finish()` into an appended paragraph
     section prefixed with `[label] `. `push_footnote_marker`
     handles only the `[^label]` REFERENCE marker (invoked from the
     `Event::FootnoteReference` arm), NOT the definition body — the
     definition-body path is `Tag::FootnoteDefinition` →
     `NodeKind::FootnoteDefinition` → `push_code` for the inline-code
     span inside.
   - **pulldown-cmark feature flags relied on** (all already enabled in
     `markdown_to_adf`): `ENABLE_TABLES` (GFM tables — see BC-7.2 §GFM-table
     path; the parser emits `Tag::Table`/`TableHead`/`TableRow`/`TableCell`
     events which `AdfBuilder` maps to `table`/`tableRow`/`tableHeader`/`tableCell`) and `ENABLE_FOOTNOTES` (footnote definitions — BC-7.2.013;
     `Event::FootnoteReference` for `[^1]`, `Tag::FootnoteDefinition` for the
     `[^1]:` body). Both are on today; no `markdown_to_adf` change is required
     for the generator to exercise these paths. `ENABLE_GFM` (alerts) and
     `ENABLE_TASKLISTS` are also on for the alert / task-list templates.
   - **Bounded depth (generator wrapper-count heuristic, NOT an ADF-tree-depth
     count)**: keep total generator wrapper nesting to ≤ 3. This is a
     GENERATOR-SIDE budget on how many container templates the strategy stacks
     around a single inline template — it prevents runaway generation cases
     (e.g. a 20-deep blockquote stack) and keeps proptest shrinking tractable.
     It is NOT a bound on the resulting ADF tree's node-nesting depth. Real
     ADF nesting is intrinsically larger: for example the GFM-table template
     alone produces `table` → `tableRow` → `tableCell`/`tableHeader` →
     `paragraph` → `text` (four container levels between the doc root and the
     leaf text node) which counts as **one** generator wrapper level here.
     Even at the generator's ≤ 3 wrapper budget, the resulting ADF-tree depth
     stays comfortably below `MAX_ADF_DEPTH = 256` (BC-7.2.012) — typical
     resulting depth is ≲ 12 (e.g. two nested list wrappers + a GFM-table +
     inline typographic marks) — so `markdown_to_adf` will not exercise the
     depth guard in this proptest, and depth-guard hits are handled cleanly
     via `.expect("no depth error at this bound")` in the property body.

2. **Property body**:
   ```text
   let adf = markdown_to_adf(&input).expect("no depth error at this bound");
   assert_code_mark_exclusivity(&adf); // tree-walk helper
   ```
   The helper `assert_code_mark_exclusivity` MUST **recurse through `content`
   arrays** (the ADF child-node containers) and, at each visited node,
   **inspect that node's `marks` array as a terminal leaf** (mark objects are
   `{"type": "...", "attrs": {...}?}` — flat, non-nested, no further descent
   is needed or valid). For every `text` node whose `marks` array contains an
   object with `"type": "code"`, the helper MUST assert that no other mark
   object in that same array has a `"type"` outside `{"code", "link",
   "annotation"}`. Container-recursion coverage (via `node["content"]`) MUST
   include: `paragraph.content`, `heading.content`, `blockquote.content`,
   `listItem.content`, `bulletList.content`, `orderedList.content`,
   `taskList.content`, `taskItem.content`, `panel.content`, `table.content`,
   `tableRow.content`, `tableCell.content`, `tableHeader.content`. A generic
   recursive descent that treats any `content: [...]` array uniformly (and
   handles `marks: [...]` as a per-node inspection step, not another
   recursion axis) is preferred over an enumerated match — new container
   types stay covered automatically.

3. **Cases required from proptest**: default (~256 cases) is sufficient given
   the small alphabet and bounded depth; the invariant is universal, not
   probabilistic. If flake pressure appears in CI, cap to 128 with
   `#![proptest_config(ProptestConfig { cases: 128, .. })]`.

**Generator scope authority (F2 R9 orchestrator decision)**: the full
generator specified above — **all** inline templates (plain / strong / em /
strike / subsup ×2 / link+code / mixed-range / nested combinations) × **all**
container wrappers (none / blockquote / bullet list / ordered list / GFM task
list / GFM alert / heading / GFM table cell / footnote-definition body),
with the ≤ 3 generator wrapper-count budget and cases capped at 128 — is
**REQUIRED**. No MVP subset is authorized. The generator scope is not
negotiable at F3 or F4; a story-writer or implementer proposing a reduced
generator (e.g. "just strong/em/subsup, skip the containers for the initial
landing") MUST route the request back to the orchestrator for a scope-change
adjudication rather than silently shipping a narrower property. Locked by
F2 pass 11 (R9-F-LOW-2), orchestrator decision, 2026-07-07.

4. **Shrinking**: proptest's default shrinking over the generator is adequate.
   The minimized case for any failure will be a small string like `` **`a`** ``
   or `` ^`a`^ ``, which is exactly the example-based EC test — a failure
   converts into a deterministic regression unit test at that shape.

5. **No panic invariant**: the property body already implicitly asserts no
   panic from `markdown_to_adf` on any generated input (same envelope as the
   existing task-list property at `src/adf.rs::tests` proptest block — see
   the neighborhood of the recursive `GenNode` strategy and its accompanying
   `proptest!` macro invocation in the `#[cfg(test)]` module of `src/adf.rs`).

**Suggested test placement**: within the existing `proptest!` block in
`src/adf.rs::tests` (co-located with the task-list property's `GenNode`
strategy neighborhood — grep for `GenNode` inside `#[cfg(test)] mod tests`),
or a new `proptest!` block adjacent to it. The
`assert_code_mark_exclusivity` helper is a free function in the same
`#[cfg(test)]` module of `src/adf.rs`.

**Suggested test name**:
`prop_bc_7_2_015_no_code_marked_text_node_carries_typographic_marks`.

---

### VP-571-002: Example-based EC anchors (deterministic regressions)

**Description**: One deterministic unit test per EC from BC-7.2.015 (§Edge
cases) plus a plain-code control. These anchor the property against
shrink-minimized failure cases and remain readable in the test file after a
proptest run (proptest failures shrink to shapes like these, but the anchors
below MUST exist unconditionally — the property is complementary evidence, not
a substitute).

**Applies to**:
- BC-7.2.015 EC-1 through EC-6.
- BC-7.2.007 EC-2 (revised: the subsup+code case is now emitted with `code`
  only; the deferred follow-up is closed).

**Anchor matrix** (all forward path, `src/adf.rs::tests`):

| EC | Input markdown | ADF marks on code text node | Test name (suggested) |
|----|----------------|------------------------------|------------------------|
| control | `` `x` `` | `[code]` | `test_bc_7_2_015_plain_code_baseline` — **GREEN pre-fix AND post-fix** (harness/baseline anchor — proves the assertion harness and the plain-code baseline; not a `push_code` invariant pin — the surrounding EC-1..EC-6 anchors carry the invariant assertions) |
| EC-1 | `` **\`x\`** `` | `[code]` — strong stripped | `test_bc_7_2_015_strong_stripped_from_code_node` — RED pre-fix (proven today by `test_markdown_inline_code_mark_and_composition` — asserts `strong+code` on the code node); GREEN post-fix |
| EC-2 | `` _\`x\`_ `` | `[code]` — em stripped | `test_bc_7_2_015_em_stripped_from_code_node` — pre-fix RED/GREEN status **empirically unconfirmed** (see F4 Red-Gate empirical-check checklist below) |
| EC-3 | `` ~~\`x\`~~ `` | `[code]` — strike stripped | `test_bc_7_2_015_strike_stripped_from_code_node` — pre-fix RED/GREEN status **empirically unconfirmed** (see checklist below) |
| EC-4 | `` ^\`x\`^ `` | `[code]` — subsup stripped | `test_bc_7_2_015_subsup_stripped_from_code_node` (primary regression target — closes BC-7.2.007 EC-2 follow-up; issue #474 → #571) — pre-fix RED/GREEN status **empirically unconfirmed** (see checklist below; STATE.md EC-4 carry-forward folded here) |
| EC-5 | `` [\`x\`](https://ex/) `` | `{code, link{href:"https://ex/"}}` (unordered set — actual emission order is `[link, code]` because `link` is already in `active_marks` when `code` is appended by `push_code`; VP does NOT pin order, see order-agnostic assertion note below) — link preserved | `test_bc_7_2_015_link_preserved_on_code_node` — **retention / mutation-catcher — GREEN pre-fix AND post-fix; NOT a Red-Gate regression pin** (link is a permitted co-mark; today's `push_code` does not filter marks at all, so `link` survives trivially; post-fix, `link` survives the allowlist filter by design — the anchor's job is to catch a future mutant that *removes* `link` from the allowlist, not to pin a pre-fix→post-fix behavior change; disclosure mirrors VP-571-004's "retention checkpoint" framing) |
| EC-6 | `` **a \`b\` c** `` | code node `b`: `[code]`; surrounding nodes `"a "` / `" c"`: `[strong]` | `test_bc_7_2_015_mixed_range_surrounding_marks_retained` — pre-fix behavior for `"b"` node RED (currently emits `strong+code`, same class as EC-1); surrounding `"a "` / `" c"` GREEN pre-fix AND post-fix (retention) |
| PANEL-ANCHOR (VP-571-002 supplementary anchor — belt-and-suspenders for `panel.content` traversal; NOT a BC-7.2.015 EC — BC body defines only EC-1..EC-7; added F2 R10) | `` > [!NOTE]\n> **`x`** `` (top-level GFM alert with strong+code inline) | ADF: top-level `panel` (`panelType: "info"`) whose `content` includes a `paragraph` whose `content` includes a text node `"x"` with marks `[code]` (strong stripped) | `test_bc_7_2_015_alert_wrapper_strong_code_stripped` — pre-fix RED **expected** via the strong class (same class as EC-1: pulldown-cmark opens `Tag::Strong` around `Event::Code` regardless of whether the surrounding container is a `panel` or a top-level `paragraph`, so the code text node inherits `[strong]` at `push_code` invocation, identical to EC-1's proven pre-fix RED shape); post-fix GREEN. **Purpose**: belt-and-suspenders coverage for the `panel.content` traversal path — pins that the assertion walker descends into `panel.content` and that the `push_code` filter is invoked on inline-code events inside a `panel`, not only inside a top-level `paragraph`. Complements VP-571-001's proptest by providing a deterministic anchor at the specific alert-wrapper shape (which VP-571-001 constrains to outermost-only, so the proptest exercises this shape but proves nothing at a fixed input). Note: this anchor's pre-fix RED status is *expected* by class-transfer argument from EC-1, but the F4 test-writer MUST still empirically verify per the Red-Gate empirical-check checklist below — the pulldown-cmark alert path is a different code chain from the top-level paragraph path, and class-transfer arguments are not empirical evidence. |

**F4 Red-Gate empirical-check checklist** (test-writer MUST execute BEFORE
authoring anchors EC-2, EC-3, EC-4):

The Red-Gate contract (BC-5.38.001) requires every anchor added under
"this is a regression pin" framing to actually fail on the pre-fix
implementation — otherwise it is vacuously green and provides no evidence
of the fix. Today only **EC-1 (strong)** is proven pre-fix RED by the
existing `test_markdown_inline_code_mark_and_composition` in
`src/adf.rs::tests`, which asserts `mark_types.contains(&"code") &&
mark_types.contains(&"strong")` on the code text node of the input
`` **bold `code` bold** ``. For EC-2, EC-3, EC-4 (both `^…^` and `~…~`
subsup variants), pulldown-cmark's willingness to open the outer
typographic span *around a `Event::Code`* is **not empirically confirmed
in this repo** at F2 authoring time. If the outer span does not open, the
code node is emitted with an empty `active_marks` and the "stripped"
anchor is **vacuously green pre-fix** — masking any Red-Gate obligation.

For each of EC-2, EC-3, EC-4 (×2 variants), the F4 test-writer MUST:

1. Author the anchor as specified above.
2. Run the anchor against `HEAD` on the story branch **before**
   applying the F4 `push_code` filter change. Capture the actual
   emitted `marks` array on the code text node.
3. If the pre-fix `marks` array contains the expected typographic mark
   type alongside `code` (e.g. `em+code` for EC-2), the anchor is a
   valid Red-Gate regression pin — proceed with the F4 change and
   confirm the anchor turns GREEN after the filter is applied.
4. If the pre-fix `marks` array contains `code` only (no typographic
   mark), the wrapper did not open around `Event::Code` for that
   input in this pulldown-cmark version. Two acceptable resolutions:
   - **(a) Adjust input to a composing form**: rewrite the anchor input
     to a shape that does compose — e.g. add whitespace at the wrapper
     boundaries (`` _ `x` _ `` → `` _x `y` z_ `` where the code node
     inherits `em` from the surrounding text run), or use the mixed-range
     form (`` _a `b` c_ `` — analogous to EC-6's `` **a `b` c** ``, which
     is already known to compose per the existing failing test). Re-run
     step 2 with the new input.
   - **(b) Demote to schema-derived**: if no composing form exists for
     that typographic mark in this pulldown-cmark version, downgrade the
     anchor from "regression pin" to "schema-derived defensive anchor
     (documented, untested pre-fix)" in the anchor matrix and file a
     follow-up gotcha in the F4 PR description. The typographic mark is
     still stripped by the filter's allowlist (defense-in-depth), just
     not empirically pre-fix-observed on this markdown input.

     **Phase-perimeter clause (R13-LOW-3, DECISION LOCKED 2026-07-07)**:
     the anchor-matrix row is an F2 spec artifact. If option (b)
     triggers during F4, the F4 story does NOT leave the F2 artifact
     stale. Concretely: (i) the F4 PR description records the demotion
     outcome (which anchor was demoted, why the composing form could
     not be found, what schema clause justifies the defensive framing);
     (ii) the F4 story includes a companion spec-delta commit updating
     both (α) this VP-571-002 anchor-matrix row in
     verification-delta-571.md and (β) the matching Empirical-check
     propagation note in `.factory/specs/prd/holdout-scenarios.md`
     H-NEW-ADF-010 for the corresponding Call B and/or Call E; (iii)
     both edits land in the SAME PR as the F4 code change — this is
     the same-PR spec companion pattern (precedent: Story B's two-tier
     shape-guard spec amendment landed in PR #592), not a follow-up
     PR. The demotion is authorized to cross the F2/F4 phase perimeter
     under R13-LOW-3 specifically for this artifact-integrity purpose;
     it does NOT open a general license to edit F2 specs from F4. Any
     other F2 edit still routes back through the orchestrator.

**Integration-test scope binding (H-NEW-ADF-010 Calls B and E)**: the EC-4
empirical-check outcome BINDS the framing of two holdout call bodies —
**Call B (platform-path subsup+code)** and **Call E (JSM-path subsup+code
parity)** in `.factory/specs/prd/holdout-scenarios.md` H-NEW-ADF-010 both
use the `` ^`code`^ `` input for the "primary regression target, issue
#571" framing. If the EC-4 empirical check resolves to option (b)
(schema-derived demotion — the `^…^` wrapper does not open around
`Event::Code` in this pulldown-cmark version and no composing form
exists), then Calls B and E are similarly downgraded from
"regression-pin" to "schema-derived defensive" framing and their
"primary regression target" language must be reworded. If the EC-4
empirical check resolves to option (a) (input adjustment to a composing
form), the anchor's `` ^`code`^ `` input MAY need mirroring into Calls B
and E for consistency between the unit-level regression pin and the
integration-level assertion. In either case, the F4 story-writer /
implementer MUST propagate the resolution across all three sites (EC-4
anchor + Call B + Call E) — the holdout file is gaining a matching
"**Empirical-check propagation**" note in parallel that cross-references
this checklist; do not resolve the anchor and the holdout independently.

**STATE.md EC-4 carry-forward (folded here)**: the existing session-state
carry-forward obligation for EC-4 (`^…^` subsup wrapping inline code —
the primary #571 regression target from BC-7.2.007 EC-2 follow-up) now
lives in this checklist. The F4 test-writer reads THIS artifact
(verification-delta-571.md) and story acceptance criteria — not STATE.md
— so the empirical-check obligation must live in the artifact the
test-writer actually consults. STATE.md can drop the EC-4 carry-forward
line once F4 lands.

**Authoritative F4 task ordering (SUPERSEDES F1 delta §10)**: the Red-Gate
empirical-check checklist above is only enforceable if F4 executes tasks in
an order that preserves the pre-fix observation window. The F1 delta §10
proposed a 5-step order that applies the `push_code` filter BEFORE authoring
new anchors — that ordering **destroys the pre-fix RED observation window**
and makes the R6-F-DELTA-1 empirical check structurally impossible (once
the filter lands, every anchor is green whether it was a valid regression
pin or a vacuous one, and the two are no longer distinguishable). F2 R9
therefore locks the following ordering as authoritative for F4; it
SUPERSEDES the F1 §10 5-step order.

Full F4 sequence:

1. **Author existing-test rewrite + all forward anchors + helpers**:
   rewrite the `test_markdown_inline_code_mark_and_composition` assertion
   (per VP-571-002 §"Existing test to update" content-anchored grep target)
   and write all EC-1..EC-6 anchors + the control anchor + the two F3-story
   helpers (`assert_marks_eq`, `assert_link_mark_with_href`) exactly as
   specified in VP-571-002.
2. **Run pre-fix**: run every anchor from step 1 against `HEAD` on the
   story branch BEFORE any `push_code` change. Capture per-anchor RED/GREEN
   evidence — for each of EC-2, EC-3, EC-4 (×2), record the actual emitted
   `marks` array on the code text node in the F4 PR description or a story
   burst-log entry. This is the pre-fix observation window; it exists only
   in this step and is destroyed by step 4.
3. **Resolve unexpectedly-GREEN regression-pin anchors**: for any anchor
   authored as a Red-Gate regression pin (EC-1..EC-4, EC-6's code node)
   that comes back GREEN pre-fix in step 2, apply the Red-Gate
   empirical-check checklist resolution above: (a) adjust the anchor's
   input to a composing form and re-run step 2, or (b) demote the anchor
   from regression pin to "schema-derived defensive anchor (documented,
   untested pre-fix)" in the anchor matrix and record the demotion in the
   F4 PR description.
4. **Apply the `push_code` typographic-mark filter**: implement the
   allowlist-filter change in `src/adf.rs::push_code` per the F1 delta
   §3 implementation shape (`link`/`annotation` retained from
   `active_marks`; all typographic marks stripped before appending
   `code`).
5. **Confirm forward anchors GREEN + reverse-path / CR/LF MUST-STAY-GREEN
   still green**: re-run step 1's anchor set — every anchor MUST pass
   post-fix. Re-run VP-571-004's `test_render_marks_code_and_strong`
   and `test_render_strong_with_code_applies_code_innermost` (reverse-path
   read-tolerance) and the BC-7.2.011 CR/LF regression baseline tests
   (`test_push_code_normalizes_lone_cr_in_inline_code`,
   `test_push_code_normalizes_bare_lf_to_space` — see F1 §7 MUST-STAY-GREEN
   list) — all MUST stay green.
6. **Refresh `apply_marks` docstring + `test_render_marks_code_and_strong`
   inline comment**: per VP-571-004 §"Docstring pin" (apply_marks
   docstring reworded to describe code-innermost as read-tolerance, not
   write-path mirror) and §"Stale-comment refresh" (the test's inline
   commentary reworded from "the write path emits `[strong, code]`" to
   "externally-produced or legacy ADF that we must render tolerantly").
7. **CLAUDE.md clause-(b) splice**: apply the CLAUDE.md gotcha update
   inside the "Markdown minor constructs → ADF (`adf.rs`, issue #474)"
   entry in CLAUDE.md (~line 293). Target: the tail of clause (b),
   which currently reads (verbatim, from `, so` to the closing paren):

   `` , so `` ^`x`^ `` would be invalid — not guarded here (pre-existing class: `` **`x`** `` has the same issue; tracked as a follow-up). ``

   Replace that entire tail (from the leading `, so` through the
   `follow-up).` including the closing paren) with the following
   plain-text splice, applied byte-for-byte:

   ```
    — enforced at emission time since #571: `push_code` strips typographic marks from code spans (see BC-7.2.015); `` ^`x`^ `` and `` **`x`** `` now emit schema-valid ADF with the `code` mark only.
   ```

   Keep boundary: the sentence before the splice ends at
   `code_inline_node`) — do NOT alter anything to the left of `, so`.
   The splice inlines the closure narrative (issue #571 resolved the
   "tracked as a follow-up" clause via emit-site typographic-mark
   stripping in `push_code`) and adds the BC-7.2.015 back-pointer.

   Deferred to F4 by orchestrator adjudication: CLAUDE.md is a product
   file, rides the F4 story worktree/PR per LESSON-F2-WORKTREE-FIRST.
   The F3 story spec MUST include `CLAUDE.md` in its `files_modified`
   list. This step is self-contained; F1 delta §10 cross-resolution is
   NOT required — the splice-template pointer inlined above (mirrored
   from `.factory/phase-f2-spec-evolution/prd-delta-571.md` §"Scope
   boundary note — CLAUDE.md update deferred to F4") is authoritative
   for F4.
8. **Proptest**: land the VP-571-001 proptest strategy
   (`prop_bc_7_2_015_no_code_marked_text_node_carries_typographic_marks`)
   in `src/adf.rs::tests`, wired to the `assert_code_mark_exclusivity`
   tree-walk helper. Property runs post-fix only (its purpose is
   universal-quantifier evidence, not a pre-fix observation).
9. **Integration tests (H-NEW-ADF-010 Calls A–E)**: land the wiremock
   integration tests for H-NEW-ADF-010's Calls A–D (platform path, `POST
   /rest/api/3/issue`) and Call E (JSM path, `POST
   /rest/servicedeskapi/request` — VP-571-005 parity anchor). **Test file
   placement is PRESCRIPTIVE — the holdout scenario H-NEW-ADF-010 in
   `.factory/specs/prd/holdout-scenarios.md` fixes the following
   locations (mirrors the established per-BC ADF test-file pattern
   documented on H-NEW-ADF-009 for BC-7.2.013); do NOT consolidate or
   relocate**:
   - **Calls A–D → `tests/adf_code_mark_exclusivity.rs`** (new
     integration-test file, platform-path platform-path). This mirrors
     the "one test file per ADF BC" pattern already established by
     `tests/adf_footnote_empty_container.rs` (H-NEW-ADF-009, BC-7.2.013)
     and `tests/adf_recursion_depth.rs` (BC-7.2.012). Consolidating into
     an existing file would violate that pattern and hurt failure
     locality when a diff scoped to `src/adf.rs::push_code` regresses.
   - **Call E → `tests/issue_create_jsm.rs`** (extend the existing JSM
     create test file). This mirrors the JSM-path integration-test
     placement already established by that file for the JSM
     `handle_jsm_create` path; adding Call E co-locates the JSM POST-body
     assertion with the other JSM create assertions for that call site.

   The former "story-writer may consolidate" allowance from an earlier
   draft is RESCINDED (R13-LOW-2, 2026-07-07) — placement is
   prescriptive, not advisory.

   **Calls B and E are BOUND by the EC-4 empirical-check outcome from
   step 3**: if EC-4 was resolved via option (a) input adjustment,
   mirror the adjusted input into Calls B and E; if EC-4 was demoted to
   schema-derived, downgrade the "primary regression target" framing in
   Calls B and E in lockstep — see the Integration-test scope binding
   note in the Red-Gate empirical-check checklist above and the matching
   "Empirical-check propagation" note in
   `.factory/specs/prd/holdout-scenarios.md` H-NEW-ADF-010.

**Rationale for the reordering vs F1 §10**: F1 §10's step 1 says "update
`test_markdown_inline_code_mark_and_composition` to assert `code` only on
the code node (fails immediately against current code)" — this IS in the
authoritative order (step 1 above), but F1 §10's step 2 applies the filter
BEFORE authoring the new EC-2/EC-3/EC-4 anchors (F1 §10's step 3), so
those new anchors never see the pre-fix behavior. R6-F-DELTA-1's
empirical-check obligation requires the pre-fix observation for the new
anchors, so the new anchors MUST be authored BEFORE the filter lands. The
existing-test rewrite from step 1 continues to serve as the primary
Red-Gate for `strong+code` (proven pre-fix RED by the paired
`&"code"`/`&"strong"` `assert!` predicate); the new EC-2/EC-3/EC-4 anchors
extend Red-Gate coverage to em/strike/subsup contingent on the
empirical-check outcome.

**Assertion shape**: each test calls `markdown_to_adf(input).unwrap()`, walks
to the relevant text node, and asserts the marks are the expected unordered
set (order-agnostic for the EC-5 `{code, link}` case — the test MUST use a
set/vec-contains comparison, not `assert_eq!` on an ordered array, to remain
robust against a reordering refactor that keeps the invariant intact).
Rationale for order-agnostic: the current `push_code` implementation appends
`{"type":"code"}` AFTER `active_marks.clone()`, so a `link` mark already in
`active_marks` produces emission order `[link, code]`. That order is an
incidental artifact of the emit-site implementation, not part of the
BC-7.2.015 invariant — the invariant is on the mark **set**, not the
sequence. A future refactor that emits `[code, link]` (e.g., by prepending
`code` for schema-alphabetization) MUST still pass EC-5 unchanged.

**F3-story helper requirements** (test-writer MUST introduce these
`#[cfg(test)]` helpers in `src/adf.rs::tests` before authoring anchors —
they do NOT exist in the codebase today, so their contracts are locked
here rather than left as "suggested" polish):

1. `fn assert_marks_eq(marks: &serde_json::Value, expected: &[&str])`
   — asserts the JSON `marks` array (typically `code_node["marks"]`)
   contains **exactly** the mark type names in `expected`, treated as an
   **unordered set**: same length, same multiset of `"type"` string
   values. Order-agnostic. Panics with a formatted message including the
   actual mark-types vector on mismatch. Placement: `#[cfg(test)] mod
   tests` block of `src/adf.rs`, adjacent to the existing mark-extraction
   idiom used by `test_markdown_inline_code_mark_and_composition` (grep
   for `mark_types: Vec<&str>` inside that module and place the helper
   near the nearest neighbor).

2. `fn assert_link_mark_with_href(marks: &serde_json::Value, expected_href: &str)`
   — asserts the JSON `marks` array contains a mark object of type
   `"link"` whose `attrs["href"]` field equals `expected_href` character-for-character. **Field-by-field access ONLY** — the helper MUST use
   `mark["attrs"]["href"].as_str() == Some(expected_href)` (or an
   equivalent field lookup). It MUST NOT do `assert_eq!` on the full
   `attrs` object — the link-attrs map varies with the input and the
   emitter's shape: `attrs["title"]` is **present only when the input
   markdown supplies a title** (e.g. `` [text](url "title") ``); for a
   bare `[text](url)` autolink like the EC-5 input, the `title` key is
   **absent entirely** from `attrs`. The suppression is enforced in
   `src/adf.rs::AdfBuilder::start`'s `Tag::Link` branch by the
   `if !title.is_empty()` guard, so `attrs` for a no-title link is
   `{"href": "..."}` with no `title` key at all. Future emitter changes
   (a new attribute added by pulldown-cmark or a schema-driven attr
   passthrough) may add or remove other keys. Full-attrs-object equality
   would over-pin the current emitter shape and break on any of those
   variations. Field-by-field access on `href` is robust to attrs the
   emitter may add or omit. `attrs["title"]` is **explicitly NOT asserted**
   by this helper (absent for no-title links; present only when the
   markdown supplies a title). Placement: same `#[cfg(test)]` module as
   `assert_marks_eq`. Empirical grounding: the existing tests
   `assert!(mark["attrs"]["title"].is_null())` (for a no-title link) and
   `assert_eq!(mark["attrs"]["title"], "JR docs")` (for a titled link) in
   `src/adf.rs::tests` document the two shapes; grep the module for
   `["attrs"]["title"]` to locate the nearest neighbors.

Both helpers are consumed by the EC-1..EC-6 anchors; the pattern is:
`assert_marks_eq(&code_node["marks"], &["code"])` for EC-1..EC-4 and
EC-6's code node, `assert_marks_eq(&code_node["marks"], &["code",
"link"])` + `assert_link_mark_with_href(&code_node["marks"],
"https://ex/")` for EC-5, and `assert_marks_eq(&code_node["marks"],
&["code"])` for the control row.

**EC-5 additional assertion — link `attrs["href"]` value pin (retention /
mutation-catcher; GREEN pre-fix AND post-fix)**: the mark-types assertion
above catches only "did the `link` mark survive?" (yes/no). It does NOT
catch an href-stripping regression where the `link` mark is retained on the
code node but its `attrs["href"]` is emptied or corrupted (e.g., a naive
filter that clones marks but drops the `attrs` object during the allowlist
walk). **Pre-fix status: this assertion is green today** — pre-fix
`push_code` clones `active_marks` unchanged, so a `link` mark's `attrs`
survives verbatim; post-fix, the allowlist filter retains the whole `link`
mark object (both `type` and `attrs`) by design. This is therefore a
**retention / mutation-catcher anchor, not a Red-Gate regression pin** —
same disclosure class as the mark-type EC-5 row above. Its job is to
catch a future mutant that filters `link` by type but drops or empties
`attrs`, not to pin a pre-fix→post-fix behavior change. The EC-5 test MUST
extend the assertion: after confirming the `link` mark is present in the
marks array, locate that mark object and perform a **field-by-field access**
on `attrs["href"]`, asserting it is present and equals the input URL
character-for-character (`"https://ex/"` for the anchor input above) — use
the `assert_link_mark_with_href` helper contract locked above. Test authors
MUST NOT `assert_eq!` on the entire `attrs` object: the link-attrs map
varies with the input and the emitter's shape — `attrs["title"]` is present
only when the input markdown supplies a title, and absent entirely for a
bare `[text](url)` autolink (`src/adf.rs::AdfBuilder::start`'s `Tag::Link`
branch elides the `title` key via `if !title.is_empty()`). Full-attrs-object
equality would over-pin the current emitter shape and break on any future
attr the emitter may add or omit; field-by-field access on `href` is robust
to that variation. `attrs["title"]` (absent for no-title links; present
only when the markdown supplies a title) is **explicitly NOT asserted** by
this VP — the pin is on `href` value only. This assertion pair (mark-type
retention + `attrs["href"]` field-level equality) is what protects the
"link preserved" invariant (BC-7.2.015 EC-5) against the two distinct
mutant classes documented in the Mutation-Testing Note §item 2 below
("Drop `link`" and "Retain `link` mark type but strip its `attrs`").

**EC-6 also asserts the surrounding-nodes invariant** (see VP-571-003 below):
`"a "` retains `[strong]`, `" c"` retains `[strong]`. This is the primary
example anchor for VP-571-003.

**Existing test to update**: `test_markdown_inline_code_mark_and_composition`
in `src/adf.rs::tests`. The actual assertion shape today is NOT a JSON-blob
literal — it is a `Vec<&str>` mark-type extraction followed by an `assert!`
predicate that checks *both* `"code"` and `"strong"` are present in the
extracted vector. Concretely, the test extracts:

```rust
let mark_types: Vec<&str> = code_node["marks"]
    .as_array()
    .unwrap()
    .iter()
    .filter_map(|m| m["type"].as_str())
    .collect();
assert!(
    mark_types.contains(&"code") && mark_types.contains(&"strong"),
    "expected code + strong on the inline-code inside bold, got: {mark_types:?}"
);
```

**Locate the assertion** by grepping for the paired `&"code"` + `&"strong"`
string literals inside the `assert!(mark_types.contains(...) && mark_types.contains(...))` predicate in that test — that grep is a stable anchor
regardless of the test's line offset in the growing file. Do NOT rely on
"the second assertion" positional wording (the test also asserts single-mark
composition earlier, and the file has grown since original authoring).

**Post-fix rewrite**: replace the `assert!(mark_types.contains(&"code") &&
mark_types.contains(&"strong"), …)` predicate with an assertion that
pins `mark_types == vec!["code"]` (exact-equality, single element,
`"strong"` absent) — equivalently `assert_marks_eq(&code_node["marks"],
&["code"])` using the helper contract locked in the F3-story helper
requirements block above. The failure message MUST be updated accordingly
(e.g., "expected code only on the inline-code inside bold — strong stripped
by push_code allowlist filter, got: {mark_types:?}"). The surrounding
non-code text nodes in the same test MUST still carry `strong` (unchanged
— VP-571-003 mixed-range invariant); grep the same test for the sibling
text-node assertions and leave them alone.

This test update is documented as an F4 implementation acceptance criterion
in `.factory/phase-f1-delta-analysis/adf-code-mark-2026-07-07-delta.md` §10;
the F2 spec does not repeat that detail beyond this pointer.

---

### VP-571-003: Node-scoped stripping — surrounding non-code text retains typographic marks

**Description**: The typographic-mark filter is scoped to the **code text
node only**. Sibling text nodes in the same inline span — text produced from
`Event::Text` inside the outer typographic wrapper, before or after the
`Event::Code` boundary — retain their typographic marks unchanged. This
distinguishes the emit-site filter (correct) from a hypothetical
span-wide-stripping bug that removed marks from all children of the outer
wrapper.

**Applies to**: BC-7.2.015 EC-6 (mixed-range case).

**Test strategy** (example-based; anchored by VP-571-002 EC-6 row):

1. Input: `` **a `b` c** `` → `markdown_to_adf` output MUST contain three text
   nodes in order:
   - `"a "` with marks `[{"type":"strong"}]`
   - `"b"` with marks `[{"type":"code"}]` — strong stripped
   - `" c"` with marks `[{"type":"strong"}]`
2. Additional (broader) shape: `` _a **b `c` d** e_ ``:
   - The code text node `"c"` carries `[code]` only (both `em` and `strong`
     stripped, since both are in `active_marks` at push_code time).
   - Sibling text nodes `"a "`, `"b "`, `" d"`, `" e"` retain their full
     typographic mark stack (`[em]`, `[em, strong]`, `[em, strong]`, `[em]`
     respectively — mark order MAY be adf.rs-emitted order; test uses
     order-agnostic mark-set comparison).
3. Property extension: VP-571-001's proptest generator already covers this
   class via the mixed-range templates; failure minimization produces this
   shape automatically. VP-571-003 is redundant with VP-571-001 as a property,
   but its example anchor MUST remain in place — it is the load-bearing
   regression pin against future refactors that mistakenly widen the strip
   scope from `push_code`-emitted node to the enclosing span.

**Mutant-catcher note**: this VP catches a plausible-but-wrong refactor where
a maintainer, seeing the filter in `push_code`, decides to "cleanly" strip
typographic marks from `active_marks` itself on entry to `push_code` and
never restore them on exit. That mutation would leave sibling text nodes
after the code span carrying `[code]`-stripped marks (empty or partial).
VP-571-003's EC-6 anchor and the multi-mark shape #2 above both catch it.

**Suggested test name**:
`test_bc_7_2_015_ec_6_strong_retained_on_sibling_text_nodes_of_code_span`,
plus `test_bc_7_2_015_multi_mark_wrapper_only_code_node_stripped` for the
`em+strong` widening variant.

---

### VP-571-004: Reverse-path read-tolerance retained (write-strict / read-lenient asymmetry pin)

**Description**: `adf_to_text` MUST render an **externally-produced** text
node carrying marks `[strong, code]` (or any typographic+code combination) as
`` **`x`** `` — code applied innermost regardless of mark-array position, via
the existing `apply_marks` behavior. This is intentional read-lenience for
ADF produced by other tools (pre-fix `jr` versions, other CLIs, the Jira web
editor's auto-correction pass, custom scripts). The write-strict / read-lenient
asymmetry is deliberate and IS load-bearing — do NOT "fix" the reverse path
to also strip typographic marks.

**Applies to**: BC-7.2.015 EC-7.

**Test strategy** (example-based; retains existing tests, does not add new ones):

The following `src/adf.rs::tests` unit tests already assert this behavior and
MUST remain green through the F4 implementation and beyond:
- `test_render_marks_code_and_strong` (existing) — `[code, strong]` renders as
  `` **`x`** ``.
- `test_render_strong_with_code_applies_code_innermost` (existing) —
  `[strong, code]` also renders as `` **`x`** `` (order-agnostic).

**Do NOT delete or rewrite these tests during F4**. The F1 regression baseline
(`.factory/phase-f1-delta-analysis/adf-code-mark-2026-07-07-delta.md` §7)
explicitly lists them as MUST-STAY-GREEN. Their retention is what implements
the write-strict / read-lenient asymmetry pin.

**Docstring pin**: F4 will update `apply_marks`'s docstring (per F1 §8) to
describe the code-innermost behavior as read-tolerance, not as a write-path
mirror. VP-571-004 does not enforce docstring content; that's an F5
adversarial-review concern.

**Stale-comment refresh (F4 obligation) — TWO tests, not one**: F4 MUST
refresh the stale explanatory comments inside **both** reverse-path
sibling tests in `src/adf.rs::tests`. Both carry the same class of
historically-accurate-but-post-fix-inaccurate write-path claim; both
`assert!`/`assert_eq!` bodies remain green (they feed
hand-constructed ADF into the reverse-path renderer, bypassing
`markdown_to_adf` entirely) — but the surrounding comments describing
"what the write path emits / why this input shape is realistic" become
wrong once the fix lands. The assertion bodies are **untouched —
MUST-STAY-GREEN**; only the surrounding explanatory comments are
refreshed to read-tolerance framing.

Enumerated targets (both under `#[cfg(test)] mod tests` in `src/adf.rs`):

1. **`test_render_marks_code_and_strong`** — inline commentary today
   claims the write path emits `[strong, code]` (or an equivalent
   phrasing of "what the write path emits"). Post-fix this is FALSE:
   the write path strips `strong` at the emit site in `push_code`;
   `[code, strong]` is only reachable from externally-produced or
   legacy ADF. Rewrite the comment to describe the input as
   "externally-produced or legacy ADF that we must render tolerantly"
   instead of "what the write path emits".

2. **`test_render_strong_with_code_applies_code_innermost`**
   (`src/adf.rs` ~line 6666) — inline commentary today reads
   `// Matches the write-path's marks ordering: strong + code produces`
   `// marks = [strong, code]. Output must be **``code``** not **`` `` `` code `` `` ``**.`
   Same falsehood class as (1): post-fix the write path emits neither
   `[strong, code]` nor `[code, strong]` on any code text node, so the
   "matches the write-path's marks ordering" claim is historically
   inaccurate. Rewrite to the same read-tolerance framing — the input
   is "externally-produced or legacy ADF with `strong+code` on the
   same node; `adf_to_text` renders it tolerantly with `code` applied
   innermost via `apply_marks`, regardless of mark-array position"
   — and preserve the operative rendering-shape statement ("output
   must be `` **`code`** `` not `**code**`"), since that IS what the
   test asserts and remains true post-fix.

Do NOT touch the `let adf = json!({...})` hand-constructed input, the
`marks: [{"type": "strong"}, {"type": "code"}]` shape, or the
`assert_eq!` call in either test — those are the reverse-path
read-tolerance evidence the VP-571-004 retention checkpoint depends on.
The refresh is a documentation-only edit inside the two tests'
comment/docstring lines.

**No new VP-scoped test is required for this VP** — it is a "keep existing
tests green" checkpoint, not a new-assertion checkpoint. It appears in the
verification set for completeness and to prevent an F4 implementer from
"cleaning up" the reverse-path tests as stale.

---

### VP-571-005: JSM path parity — code-mark exclusivity holds on the JSM request body too

**Description**: `markdown_to_adf` is the shared conversion engine for both
the platform path (`POST /rest/api/3/issue`) and the JSM path (`POST
/rest/servicedeskapi/request`, dispatched via `handle_jsm_create` — see
ADR-0014). Concretely on the JSM path, the code-level invocation site is
`src/api/jsm/requests.rs::JsmRequestBuilder::build` — inside the
`Optional description → ADF (BC-3.8.006)` block it calls
`adf::markdown_to_adf(desc_text)?` when `self.markdown` is set (and
`adf::text_to_adf(desc_text)` otherwise, which is out of scope for BC-7.2.015
because inline code marks are only produced by the markdown pipeline). The
by-construction argument therefore rests on a single symbol: any invariant
enforced inside `push_code` inside `markdown_to_adf` is enforced on both
POST bodies because `JsmRequestBuilder::build` is the only JSM-side caller of
`markdown_to_adf` and the platform-side call in `handle_create` goes through
the same function. The BC-7.2.015 invariant MUST hold on both endpoints;
there is no endpoint-specific ADF leniency (research Claim D INCONCLUSIVE for
`/rest/servicedeskapi/request` divergence, but the write path is a single
codepath — divergence at the endpoint validator does not translate into a
divergence at the emission site).

**Applies to**: BC-7.2.015 (all ECs, JSM invocation surface).

**Test strategy** (integration, wiremock): holdout H-NEW-ADF-010 (see
`.factory/specs/prd/holdout-scenarios.md`, Group 12) is the black-box
assertion. As of adversarial pass 1 resolution (RESOLVED 2026-07-07,
option (a) landed), H-NEW-ADF-010 is a **single holdout with Call E — JSM path
parity via `handle_jsm_create` / `POST /rest/servicedeskapi/request`**,
asserting the code-mark exclusivity invariant on the captured JSM POST body's
`requestFieldValues.description` field. Calls A–D cover the platform path
(EC-1 strong / EC-4 subsup / EC-5 link preserved / EC-6 mixed range); Call E
covers the JSM path with the identical code-mark exclusivity assertion.
VP-571-005 is therefore enforced end-to-end by H-NEW-ADF-010 Call E; no
separate integration test is required. If the F3 story author decides to add
a dedicated JSM-path unit test at the `markdown_to_adf` level, its assertion
is identical to VP-571-001's `assert_code_mark_exclusivity` helper applied
to the JSM POST body's `requestFieldValues.description` field.

**Split alternative — RESOLVED 2026-07-07 as option (a)**: an earlier pass
considered splitting into H-NEW-ADF-010a (platform, MUST-PASS) +
H-NEW-ADF-010b (JSM, MUST-PASS). This split was **not adopted**. Option (a)
— single holdout H-NEW-ADF-010 with an added Call E — was chosen and has
landed in `.factory/specs/prd/holdout-scenarios.md` (Group 12). The
enforcement claim above is now accurate; the deferral is closed.

---

## Existing Verification Properties Reviewed

**No existing VP is invalidated by BC-7.2.015 or the BC-7.2.007 EC-2
amendment.**

Reviewed set: all VPs currently inlined in `.factory/specs/prd/bc-*.md`
Verification Properties subsections (currently VP-331-001..003, VP-396-001..012,
VP-398-001..006, VP-BOARD-VIEW-001..005, VP-DRY-RUN-001..003,
VP-LABEL-FORK-001..002 — grepped 2026-07-07). None reference `code` marks,
`push_code`, `active_marks`, `dedup_marks_by_type`, `code_inline_node`, or
`formatted_text_inline_node`. BC-7.2.007 currently has no inline VP subsection
(no bc-7 BC does — see "Registration surface" note above), so there is no VP
tied to the pre-#571 EC-2 wording to retract.

**No updated VPs**. The `updated_vps: []` frontmatter field is empty.

The closest neighbor is the existing `src/adf.rs::tests` unit test
`test_markdown_inline_code_mark_and_composition` — flagged in F1 §7 for
update in F4, its now-wrong assertion is the one whose expected value carries
both `{"type":"strong"}` and `{"type":"code"}` on the same code text node
(content anchor; see VP-571-002 §"Existing test to update" for the rewrite
target) — plus the two reverse-path tests listed in VP-571-004. Neither is a
formally-registered VP. The F4 implementation story is where the test update
lives; F2 does not modify tests.

---

## Proof Strategy Summary (per property)

| VP | Kind | Toolchain | Trigger surface | Failure minimization |
|----|------|-----------|-----------------|----------------------|
| VP-571-001 | Property-based | proptest (`src/adf.rs::tests`) | `markdown_to_adf` — whole-document invariant over generated markdown | proptest default; minimized shapes match VP-571-002 anchors |
| VP-571-002 | Example-based | `#[test]` unit tests (`src/adf.rs::tests`) | `markdown_to_adf` — one test per EC | N/A (deterministic anchors) |
| VP-571-003 | Example-based | `#[test]` unit tests (`src/adf.rs::tests`) | Node-scoped stripping — EC-6 mixed-range + multi-mark wrapper | N/A |
| VP-571-004 | Example-based (retention) | Existing `#[test]` unit tests (`src/adf.rs::tests`) | `adf_to_text` / `apply_marks` — reverse path read-tolerance | N/A (retention) |
| VP-571-005 | Integration | wiremock via H-NEW-ADF-010 Call E (holdout-scenarios.md Group 12) | `handle_jsm_create` POST-body assertion on `requestFieldValues.description` | N/A |

**Coverage of BC-7.2.015 ECs**:

| EC | Anchored by |
|----|-------------|
| EC-1 (strong stripped) | VP-571-002 row EC-1 + VP-571-001 template `**\`x\`**` |
| EC-2 (em stripped) | VP-571-002 row EC-2 + VP-571-001 template `_\`x\`_` |
| EC-3 (strike stripped) | VP-571-002 row EC-3 + VP-571-001 template `~~\`x\`~~` |
| EC-4 (subsup stripped — primary #571 regression) | VP-571-002 row EC-4 + VP-571-001 template `` ^\`x\`^ `` (and `~\`x\`~`) |
| EC-5 (link preserved) | VP-571-002 row EC-5 + VP-571-001 template `[\`x\`](url)` |
| EC-6 (mixed range) | VP-571-002 row EC-6 + VP-571-003 (primary) + VP-571-001 template `**a \`b\` c**` |
| EC-7 (reverse-path read-tolerance) | VP-571-004 (retention of existing tests) |
| JSM parity | VP-571-005 (via H-NEW-ADF-010 Call E) |

---

## Mutation-Testing Note (cargo-mutants scope)

`src/adf.rs` is registered in `.cargo/mutants.toml` §examine_globs. The F4
diff will touch `src/adf.rs::push_code` (the sole `{"type":"code"}` emit
site), which places the emit-site filter directly in the mutation-tested
surface. Story-writer / F4 implementer
MUST expect the following surviving-mutant classes if the test suite is
under-specified — the VPs above are designed to catch each class, but the
implementer should verify with a live `cargo mutants --in-diff` run per the
`docs/specs/cargo-mutants-policy.md` gate:

1. **Filter deletion**: mutant deletes the typographic-mark filter entirely,
   restoring the pre-#571 `let mut marks = self.active_marks.clone();
   marks.push(json!({ "type": "code" }));`.
   - **Caught by**: VP-571-002 rows EC-1..EC-4 (each strips one class);
     VP-571-001 property (universal quantifier).

2. **Filter allowlist membership mutations** — the allowlist is
   `{"code", "link", "annotation"}`. Plausible mutations:
   - **Drop `link`** from the allowlist → EC-5 test fails. **Caught by**:
     VP-571-002 row EC-5 (mark-type check).
   - **Retain `link` mark type but strip its `attrs`** (e.g., a mutant that
     clones the mark object but replaces `attrs` with `null`/`{}`, or a
     copy-fields loop that omits `attrs`) → the `link` mark type survives in
     the marks array (so a mark-type-only assertion would PASS the mutant)
     but `attrs.href` is missing or empty, breaking the produced ADF's
     clickability. **Caught by**: VP-571-002 row EC-5 extended assertion —
     `mark.attrs.href` MUST equal the input URL character-for-character. This
     is a distinct mutant class from "drop `link`" and requires the EC-5
     assertion to pair mark-type presence with href-value equality (see
     VP-571-002 §"EC-5 additional assertion").
   - **Drop `annotation`** from the allowlist → no jr-emitted test catches
     this because `jr` does not emit annotation marks today (§F1 out-of-scope).
     This is an ACCEPTED surviving-mutant class; the F5 adversarial review or
     F6 hardening MAY add a synthetic test that hand-constructs `active_marks`
     containing `annotation` and asserts survival, but the F1 delta explicitly
     scoped this out. **Documented, accepted.**
   - **Add `strong` (or any typographic mark) to the allowlist** → EC-1 test
     fails. **Caught by**: VP-571-002 row EC-1.

3. **Filter scope widening — active_marks itself mutated**: mutant refactors
   the filter to mutate `self.active_marks` in-place (draining typographic
   marks) instead of filtering a clone, so subsequent sibling text nodes
   also lose their marks.
   - **Caught by**: VP-571-003 EC-6 (`"a "` / `" c"` must retain `[strong]`)
     and the multi-mark wrapper shape #2. Without VP-571-003, the mutant would
     survive because EC-1..EC-4 use code-only inputs.

4. **Filter position swap — filter after push instead of before**: mutant
   pushes `{"type":"code"}` first, then applies the allowlist filter to the
   whole marks array — a valid refactor if the filter is symmetric, but a
   subtle bug if the code mark's shape or the dedup pass changes.
   - **Caught by**: VP-571-002 rows EC-1..EC-5 (all assert final marks-set
     equality, which is invariant to filter position when the filter is
     symmetric and the code mark is always included). NOT expected to survive
     as a semantic mutant — recorded for completeness.

5. **Dedup-pass regression**: the final `dedup_marks_by_type(&marks)` call
   inside `src/adf.rs::push_code` is the existing final dedup step. A mutant
   that removes the dedup call could
   allow a duplicate `code` mark to appear on the same node (if
   `active_marks` somehow contained a stale code mark — not currently
   possible via `markdown_to_adf`, but a defensive check).
   - **Caught by**: no dedicated VP-571-* test. **Accepted**: this is
     BC-7.2.008 / #474 territory (subsup dedup), not #571 scope. If a mutant
     survives here, it is under the #474/BC-7.2.008 verification envelope.

6. **CR/LF normalization regression** (`push_code` also normalizes CR/LF per
   BC-7.2.011 EC-11 — the CRLF/lone-CR/bare-LF normalization block inside
   `src/adf.rs::push_code` that runs on `text` before the marks-array
   assembly). Adjacent to the filter site inside the same function.
   - **Caught by**: existing BC-7.2.011 tests (`test_push_code_normalizes_lone_cr_in_inline_code`, `test_push_code_normalizes_bare_lf_to_space`) —
     MUST-STAY-GREEN per F1 §7. Not a #571-scope VP.

**F4 verification gate**: run `cargo mutants --in-diff <pr-diff> --jobs 4
--timeout 240` per `docs/specs/cargo-mutants-policy.md`. Surviving mutants in
classes 1–3 above indicate under-coverage of BC-7.2.015 and MUST block the
gate. Surviving mutants in classes 5–6 are out-of-scope for #571 and route to
their respective BC owners.

---

## Registration Surface Sweep

Per the REGISTRATION-SURFACE-SWEEP discipline (DEC-155 pattern), this delta's
registration surfaces are:

| Surface | Action | File / Location |
|---------|--------|-----------------|
| Verification-delta document (this file) | CREATE | `.factory/phase-f2-spec-evolution/verification-delta-571.md` |
| VP inline registration | ADD subsection to BC-7.2.015 body | `.factory/specs/prd/bc-7-output-render.md` — new `**Verification Properties**:` subsection listing VP-571-001..005 |
| BC-7.2.007 cross-reference | none (existing EC-2 already points to BC-7.2.015 via "See BC-7.2.015 for the positive mark-coexistence invariant") | (no edit) |
| BC-INDEX.md VP counts | N/A — no VP count is tracked in BC-INDEX.md today | (no edit) |
| CANONICAL-COUNTS.md VP counts | N/A — no VP count is tracked in CANONICAL-COUNTS.md today | (no edit) |
| Frontmatter of bc-7-output-render.md | N/A — no VP-count field exists in bc-7 frontmatter | (no edit) |
| holdout-scenarios.md VP cross-references | H-NEW-ADF-010 (Group 12) already landed with Call E covering JSM parity (adversarial pass 1 resolution 2026-07-07, option (a)). Adding VP-571-001 / VP-571-005 to its `BC refs` / `NFR source` lines is optional polish for F3 holdout finalization — not required for VP enforcement | (deferred; optional) |
| CLAUDE.md gotcha for `code`-mark note in the subsup bullet | Deferred to F4 (orchestrator adjudication — CLAUDE.md is a product file, must ride the F4 story worktree/PR per LESSON-F2-WORKTREE-FIRST; the F3 story will carry CLAUDE.md in its file list). Original scoping reference: `.factory/phase-f1-delta-analysis/adf-code-mark-2026-07-07-delta.md` §10 F2 scope bullet — "Update CLAUDE.md gotcha for the `code` mark note in the subsup bullet: drop 'not guarded here, tracked as a follow-up' and add a pointer to BC-7.2.015." No VP entry in CLAUDE.md | (F4 update via story worktree) |

**Frontmatter sweep verdict**: no frontmatter counts are affected by
VP-571-001..005. `.factory/specs/prd/bc-7-output-render.md` frontmatter tracks
`total_bcs` and `definitional_count` (already bumped by prd-delta-571.md); no
`total_vps` field exists in any BC file's frontmatter as of 2026-07-07.

---

## VP → BC Mapping Summary

| VP ID | BC(s) Covered | Key Invariant |
|-------|---------------|---------------|
| VP-571-001 | BC-7.2.015 (all ECs), BC-7.2.007 EC-2 (closure) | Property: every code-marked text node carries marks ⊆ {code, link, annotation} |
| VP-571-002 | BC-7.2.015 EC-1..EC-6 | Example anchors per EC (strong/em/strike/subsup stripped; link preserved; mixed-range surrounding retained) |
| VP-571-003 | BC-7.2.015 EC-6 | Node-scoped stripping — sibling text nodes retain typographic marks |
| VP-571-004 | BC-7.2.015 EC-7 | Reverse-path read-tolerance retained (existing `adf_to_text` tests MUST-STAY-GREEN) |
| VP-571-005 | BC-7.2.015 (JSM parity) | Same invariant on `/rest/servicedeskapi/request` POST body (enforced by H-NEW-ADF-010 Call E) |

---

## Project Convention Note

This project inlines Verification Properties directly in BC body files rather
than maintaining separate VP-INDEX, verification-architecture.md, or
verification-coverage-matrix.md files (those files do not exist in this
repository). See §"Project Convention Note" in
`.factory/phase-f2-spec-evolution/verification-delta-398.md` for the same
convention statement — this delta follows it exactly.

VP-571-001 through VP-571-005 are recorded as **Verification Properties
subsections within the BC body** in
`.factory/specs/prd/bc-7-output-render.md` under BC-7.2.015. This is the first
inline `**Verification Properties**:` subsection in `bc-7-output-render.md`;
the subsection format mirrors the pattern used in `bc-3-issue-write.md`
(BC-3.4.012, BC-3.4.013, BC-3.4.014, etc.). No separate index propagation is
required.
