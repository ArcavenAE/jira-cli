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
   - **Container wrappers** (chosen with `prop_oneof![...]`, to cover nested
     contexts): none / blockquote (`> `) / unordered list (`- `) / ordered list
     (`1. `) / GFM task list (`- [ ] ` / `- [x] `) / GFM alert
     (`> [!NOTE]\n> `) / heading (`## `) / **GFM table cell** (2-column,
     1-row header + 1-row body: `` `| {inline_template} | plain |\n|---|---|\n| plain | {inline_template} |` `` — exercises the `table` → `tableRow` → `tableHeader`/`tableCell` container chain so table-cell content flows through `active_marks` the same way as top-level paragraph content) / **footnote-definition body** (reference `` `Body.[^1]\n\n[^1]: {inline_template}` `` — the definition body is inline text collected by `push_footnote_marker`/`footnote_defs` and flushed at `finish()` into an appended paragraph section; typographic marks around inline code inside the definition body are exercised at emission time). This ensures the property is not accidentally-true only at the top-level paragraph — nested contexts route through the same `push_code` chokepoint. Every entry in this wrapper list corresponds one-to-one with an ADF container node type enumerated by the traversal helper below (`table.content` / `tableRow.content` / `tableCell.content` / `tableHeader.content` are covered by the GFM-table template; the footnote-definition body is emitted as a top-level `paragraph` in the appended footnote section, already covered by generic `content: [...]` descent).
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
   The helper `assert_code_mark_exclusivity` MUST recurse via `content` /
   `marks` arrays, visiting every ADF node in the document. For every `text`
   node whose `marks` array contains an object with `"type": "code"`, it MUST
   assert that no other mark object in that same array has a `"type"` outside
   `{"code", "link", "annotation"}`. Traversal MUST cover:
   `paragraph.content`, `heading.content`, `blockquote.content`,
   `listItem.content`, `bulletList.content`, `orderedList.content`,
   `taskList.content`, `taskItem.content`, `panel.content`, `table.content`,
   `tableRow.content`, `tableCell.content`, `tableHeader.content`. A generic
   recursive descent that treats any `content: [...]` and `marks: [...]` array
   uniformly is preferred over an enumerated match — new container types stay
   covered automatically.

3. **Cases required from proptest**: default (~256 cases) is sufficient given
   the small alphabet and bounded depth; the invariant is universal, not
   probabilistic. If flake pressure appears in CI, cap to 128 with
   `#![proptest_config(ProptestConfig { cases: 128, .. })]`.

4. **Shrinking**: proptest's default shrinking over the generator is adequate.
   The minimized case for any failure will be a small string like `` **`a`** ``
   or `` ^`a`^ ``, which is exactly the example-based EC test — a failure
   converts into a deterministic regression unit test at that shape.

5. **No panic invariant**: the property body already implicitly asserts no
   panic from `markdown_to_adf` on any generated input (same envelope as the
   existing task-list property at `src/adf.rs::tests::proptest!` ~line 8887).

**Suggested test placement**: within an existing `proptest!` block in
`src/adf.rs::tests` (co-located with the task-list property near line
~9020ff), or a new `proptest!` block adjacent to it. The
`assert_code_mark_exclusivity` helper is a free function in the same
`#[cfg(test)]` module.

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
| control | `` `x` `` | `[code]` | `test_bc_7_2_015_plain_code_baseline` |
| EC-1 | `` **\`x\`** `` | `[code]` — strong stripped | `test_bc_7_2_015_strong_stripped_from_code_node` |
| EC-2 | `` _\`x\`_ `` | `[code]` — em stripped | `test_bc_7_2_015_em_stripped_from_code_node` |
| EC-3 | `` ~~\`x\`~~ `` | `[code]` — strike stripped | `test_bc_7_2_015_strike_stripped_from_code_node` |
| EC-4 | `` ^\`x\`^ `` | `[code]` — subsup stripped | `test_bc_7_2_015_subsup_stripped_from_code_node` (primary regression target — closes BC-7.2.007 EC-2 follow-up; issue #474 → #571) |
| EC-5 | `` [\`x\`](https://ex/) `` | `{code, link{href:"https://ex/"}}` (unordered set — actual emission order is `[link, code]` because `link` is already in `active_marks` when `code` is appended by `push_code`; VP does NOT pin order, see order-agnostic assertion note below) — link preserved | `test_bc_7_2_015_link_preserved_on_code_node` |
| EC-6 | `` **a \`b\` c** `` | code node `b`: `[code]`; surrounding nodes `"a "` / `" c"`: `[strong]` | `test_bc_7_2_015_mixed_range_surrounding_marks_retained` |

**Assertion shape**: each test calls `markdown_to_adf(input).unwrap()`, walks
to the relevant text node, and asserts the marks are the expected unordered
set (order-agnostic for the EC-5 `{code, link}` case — the test MUST use a
set/vec-contains comparison, not `assert_eq!` on an ordered array, to remain
robust against a reordering refactor that keeps the invariant intact). Prefer
`assert_marks_eq(&marks, &["code"])` and `assert_marks_eq(&marks, &["code",
"link"])` helpers over JSON-blob comparison; `assert_marks_eq` MUST treat its
expected slice as an unordered set (its documented contract for this VP is
order-agnostic set equality, not element-wise vector equality). Rationale:
the current `push_code` implementation appends `{"type":"code"}` AFTER
`active_marks.clone()`, so a `link` mark already in `active_marks` produces
emission order `[link, code]`. That order is an incidental artifact of the
emit-site implementation, not part of the BC-7.2.015 invariant — the invariant
is on the mark **set**, not the sequence. A future refactor that emits
`[code, link]` (e.g., by prepending `code` for schema-alphabetization) MUST
still pass EC-5 unchanged.

**EC-5 additional assertion — link `attrs.href` value pin**: the mark-types
assertion above catches only "did the `link` mark survive?" (yes/no). It does
NOT catch an href-stripping regression where the `link` mark is retained on
the code node but its `attrs.href` is emptied or corrupted (e.g., a naive
filter that clones marks but drops the `attrs` object during the allowlist
walk). The EC-5 test MUST therefore extend the assertion: after confirming
the `link` mark is present in the marks array, locate that mark object and
assert `mark.attrs.href` is present and equals the input URL character-for-character (`"https://ex/"` for the anchor input above). If the test uses a
higher-level helper (e.g., `assert_link_mark_with_href(&marks,
"https://ex/")`), that helper MUST perform both the type-present check and
the href-equality check — the two are inseparable for this EC. This assertion
pair is what pins the "link preserved" invariant (BC-7.2.015 EC-5) end-to-end:
mark-type retention + `attrs` payload integrity.

**EC-6 also asserts the surrounding-nodes invariant** (see VP-571-003 below):
`"a "` retains `[strong]`, `" c"` retains `[strong]`. This is the primary
example anchor for VP-571-003.

**Existing test to update**: `test_markdown_inline_code_mark_and_composition`
in `src/adf.rs::tests`. Content anchor for the assertion that must change:
the assertion whose expected value contains **both** `{"type":"strong"}` and
`{"type":"code"}` in the same `marks` array on the same text node — i.e., the
pin that today asserts the code text node's marks look like `[{"type":"strong"},{"type":"code"}]` (or the `dedup_marks_by_type`-ordered equivalent). That
assertion MUST be rewritten to pin `marks: [{"type":"code"}]` **only** on the
code node — no `{"type":"strong"}` entry. Locate the assertion by grepping
for the paired `"strong"` + `"code"` marks literal in that test's expected
value, not by its ordinal position in the test body (which may drift as the
test grows). The surrounding non-code text nodes in the same test MUST still
assert `[{"type":"strong"}]` (unchanged — VP-571-003 mixed-range invariant).
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

`src/adf.rs` is registered in `.cargo/mutants.toml` §examine_globs (line 11).
The F4 diff will touch `push_code` (~line 1284 area), which places the emit-site
filter directly in the mutation-tested surface. Story-writer / F4 implementer
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

5. **Dedup-pass regression**: `dedup_marks_by_type(&marks)` at line ~1289 is
   the existing final dedup step. A mutant that removes the dedup call could
   allow a duplicate `code` mark to appear on the same node (if
   `active_marks` somehow contained a stale code mark — not currently
   possible via `markdown_to_adf`, but a defensive check).
   - **Caught by**: no dedicated VP-571-* test. **Accepted**: this is
     BC-7.2.008 / #474 territory (subsup dedup), not #571 scope. If a mutant
     survives here, it is under the #474/BC-7.2.008 verification envelope.

6. **CR/LF normalization regression** (`push_code` also normalizes CR/LF per
   BC-7.2.011 EC-11, lines ~1270–1283). Adjacent to the filter site.
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
