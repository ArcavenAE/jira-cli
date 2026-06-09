---
document_type: story
story_id: "S-474"
title: "Markdown minor constructs → ADF: superscript/subscript subsup mark + heading-attribute stripping"
wave: feature-followup
status: implemented
intent: enhancement
feature_type: backend
mode: feature
scope: small
severity: LOW
trivial_scope: false
issue: 474
points: 3
priority: P1
tdd_mode: strict
estimated_effort: small
estimated_days: 1
target_module: adf
subsystems: []
depends_on: []
blocks: []
bc_anchors:
  - BC-7.2.007
  - BC-7.2.008
bcs:
  - BC-7.2.007
  - BC-7.2.008
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: ".factory/phase-f1-delta-analysis/issue-474/delta-analysis.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 9
assumption_validations: []
risk_mitigations: []
created: "2026-06-08"
last_updated: "2026-06-08"
breaking_change: false
retroactive: true
predecessor_cycles: "PR #477 (issue #470, BC-7.2.006 listItem normalization), PR #481 (issue #472, footnotes)"
changelog:
  - date: "2026-06-08"
    phase: F3-story-decomposition
    author: story-writer
    summary: >
      Retroactive F3 wrapping for issue #474. Implementation already shipped on branch
      feat/adf-minor-constructs-474. Two new BCs authored by PO: BC-7.2.007 (subsup marks,
      forward + reverse + dedup + tilde-collision) and BC-7.2.008 (heading-attribute
      stripping). 13 inline unit tests green. GFM alert→panel deferred to issue #483.
files_modified:
  - src/adf.rs   # markdown_to_adf options (ENABLE_SUPERSCRIPT|ENABLE_SUBSCRIPT|ENABLE_HEADING_ATTRIBUTES); AdfBuilder Superscript/Subscript arms; dedup_marks_by_type; apply_marks subsup arm
  - CLAUDE.md    # Markdown minor constructs gotcha: subsup, tilde-collision, intraword limitation, heading-attr stripping, GFM-alert deferral
---

# S-474 — Markdown Minor Constructs → ADF: subsup + heading-attr stripping

## Source of Truth

Delta analysis: `.factory/phase-f1-delta-analysis/issue-474/delta-analysis.md`
BC-7.2.007 body: `.factory/specs/prd/bc-7-output-render.md §7.2.007`
BC-7.2.008 body: `.factory/specs/prd/bc-7-output-render.md §7.2.008`
Predecessor issues: #470 (listItem normalization / BC-7.2.006), #472 (Markdown footnotes)
Follow-up deferred: GFM alerts → ADF `panel` (tracked as issue #483)

**Implementation status: COMPLETE.** All changes are on branch `feat/adf-minor-constructs-474`.
All 13 new inline unit tests pass. 105 total `adf::tests` green. No CLI/API regression.
This story is a retroactive F3 wrap matching the pattern used for sibling features #470 and #472.

## Behavioral Contracts

| BC | Title | Role in this story |
|----|-------|-------------------|
| BC-7.2.007 | `markdown_to_adf` maps `^x^`→subsup sup and `~x~`→subsup sub; double-tilde `~~x~~` stays `strike` | PRIMARY: forward path (Superscript/Subscript arms), mark dedup, tilde-collision safety, reverse path (adf_to_text subsup arm), round-trip losslessness |
| BC-7.2.008 | `markdown_to_adf` consumes heading attribute syntax `## Title {#id}` instead of leaking it into heading text | PRIMARY: ENABLE_HEADING_ATTRIBUTES parser option consumed; id/class/key-val forms dropped; no ADF field emitted |

## Story Narrative

As a Jira user writing issue descriptions or comments in Markdown,
I want `jr issue create/edit --description` to correctly render
superscript (`^x^`) and subscript (`~x~`) as ADF `subsup` marks,
and to silently strip heading attribute blocks (`## Title {#id}`)
rather than leaking `{#id}` as literal text in the heading,
so that my Markdown-formatted content is displayed faithfully
in the Jira UI without malformed ADF errors or visible noise.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~1,200 |
| src/adf.rs (full file — only modified file) | ~3,500 |
| BC files (2 BCs — bc-7-output-render.md delta) | ~400 |
| Test output (cargo test adf::tests) | ~500 |
| **Total** | **~5,600** |

Well within a 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**Predecessor: issue #470 (BC-7.2.006, PR #477)**
Introduced `normalize_list_item_content`, `is_empty_block_container`, and
`flatten_table_to_paragraphs` in `src/adf.rs`. The `is_empty_block_container`
free function is reused by the footnote pruning logic added in #472. The
pattern of a free function operating on `AdfNode` content vectors is reused
by `dedup_marks_by_type` in this story.

**Predecessor: issue #472 (PR #481)**
Added `Options::ENABLE_FOOTNOTES`, `push_footnote_marker`, footnote-definition
flushing at `finish()`, and `is_empty_block_container` pruning of empty shells.
The new #474 options block is added adjacent to the existing `ENABLE_FOOTNOTES`
flag in the same `Options::…` chain. Implementer must NOT disturb the footnotes
block when adding the new flags.

**Intraword superscript limitation (pinned):** pulldown-cmark does not open a
`Tag::Superscript` when `^` is immediately adjacent to a preceding word character.
`mc^2^` stays literal; `mc ^2^` (space before `^`) produces a subsup mark.
This limitation is pinned by `test_markdown_intraword_superscript_stays_literal`
and documented in CLAUDE.md.

**GFM alerts deferred to issue #483:** `> [!NOTE]` → ADF `panel` requires
content-model normalization analogous to the #470 listItem work. It is NOT part
of #474. The `markdown_to_adf` code comment documents the deferral explicitly.
Do not add `Options::ENABLE_GFM` or any panel emission in this scope.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Single modified file | delta-analysis.md §Impact Boundary | All production changes confined to `src/adf.rs`. No new modules, structs, enums, or crates. No CLI flags, API calls, config, cache, or keychain changes. |
| No ADF spec violations | BC-7.2.007 EC-2 | ADF forbids `code` mark alongside `subsup`/`em`/`strong`/`strike` on the same text node. This class of issue is a known pre-existing limitation; not guarded here. |
| Dedup at ALL text-emission call sites | BC-7.2.007 §Deduplication | `dedup_marks_by_type` must be applied at both `push_text` and `push_code`. Adding a new text-emission call site without dedup is a contract violation. |
| `skip_serializing` not applicable | N/A | This story adds no new struct fields with serialization concerns (unlike S-JSM-RESOLUTION-REQUIRED). The `dedup_marks_by_type` function is purely internal to the mark-emission path. |
| Heading-attr stripping is parser-level | BC-7.2.008 §Behavior | The stripping happens inside pulldown-cmark by enabling `ENABLE_HEADING_ATTRIBUTES`. No AdfBuilder code change is needed for heading text handling — the attribute events are simply absent from the stream. |

## Library and Framework Requirements

| Library | Version | Constraint |
|---------|---------|-----------|
| pulldown-cmark | 0.13.x (from Cargo.toml) | `Options::ENABLE_SUPERSCRIPT`, `Options::ENABLE_SUBSCRIPT`, `Options::ENABLE_HEADING_ATTRIBUTES` must all be present in 0.13.x. Tilde-collision behaviour (single `~x~` → subscript, double `~~x~~` → strike) is version-specific; pinned by tests. |
| serde_json | current (from Cargo.toml) | `json!({"type":"subsup","attrs":{"type":"sup"}})` mark construction — no version change. |

No new crate dependencies are added by this story.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `src/adf.rs` | MODIFY | Add `ENABLE_SUPERSCRIPT | ENABLE_SUBSCRIPT | ENABLE_HEADING_ATTRIBUTES` to Options block in `markdown_to_adf`; add `Tag::Superscript` and `Tag::Subscript` arms in `handle_tag_start`; add `dedup_marks_by_type` free function; apply dedup in `push_text` and `push_code`; add `"subsup"` arm in `apply_marks`; add 13 new inline unit tests |
| `CLAUDE.md` | MODIFY | Add markdown minor constructs gotcha block immediately after the existing #472 footnote gotcha entry |

No new files are created. No integration test files are added (all coverage is inline unit tests in `src/adf.rs`).

## Acceptance Criteria

### AC-001 — Superscript forward path: `^x^` → subsup sup mark
(traces to BC-7.2.007 postcondition — Tag::Superscript arm emits subsup mark with attrs.type="sup")

`markdown_to_adf("Hello ^sup^ world")` produces a paragraph node containing
text nodes. The text node for `"sup"` carries exactly one mark:
`{"type":"subsup","attrs":{"type":"sup"}}`.

Pinned by: `test_markdown_superscript_to_subsup_sup`

---

### AC-002 — Subscript forward path: `~x~` → subsup sub mark; double-tilde stays strike
(traces to BC-7.2.007 postcondition — Tag::Subscript arm emits subsup mark with attrs.type="sub"; tilde-collision safety)

`markdown_to_adf("Hello ~sub~ world")` produces a text node for `"sub"` with
mark `{"type":"subsup","attrs":{"type":"sub"}}`.

`markdown_to_adf("Hello ~~struck~~ world")` produces a text node for `"struck"`
with mark `{"type":"strike"}` — not a `subsup` mark. This pins the load-bearing
tilde disambiguation behaviour of pulldown-cmark 0.13 where single `~x~` →
`Tag::Subscript` and double `~~x~~` → `Tag::Strikethrough`.

Pinned by: `test_markdown_subscript_to_subsup_sub`, `test_markdown_double_tilde_still_strikethrough_not_subscript`

---

### AC-003 — Intraword caret stays literal (known limitation, pinned)
(traces to BC-7.2.007 edge case EC-1 — intraword caret stays literal)

`markdown_to_adf("mc^2^ eV")` produces text nodes that together contain the
literal string `"mc^2^ eV"` with no `subsup` mark. pulldown-cmark does not
open a `Tag::Superscript` when `^` is immediately adjacent to a preceding word
character. This is a documented limitation — use `mc ^2^` (space before `^`)
to produce a superscript.

Pinned by: `test_markdown_intraword_superscript_stays_literal`

---

### AC-004 — Subsup composes with strong (multi-mark text node)
(traces to BC-7.2.007 postcondition — subsup mark coexists with other mark types)

`markdown_to_adf("**^bold-sup^**")` produces a text node for `"bold-sup"` that
carries both a `strong` mark and a `subsup sup` mark. The two marks coexist on
the same text node (ADF allows this for distinct mark types). The reverse path
(`adf_to_text`) correctly renders the combined mark.

Pinned by: `test_subsup_composes_with_strong`

---

### AC-005 — Nested same-type spans: dedup keeps first subsup mark (first-wins rule)
(traces to BC-7.2.007 postcondition — dedup_marks_by_type; EC-3 dedup is first-wins)

`markdown_to_adf("^a ~b~ c^")` — the inner text node `"b"` would naively carry
two `subsup` marks (one `sup` from the outer `^…^`, one `sub` from the inner
`~…~`). After `dedup_marks_by_type`, the node carries exactly one `subsup` mark.
The first mark encountered in `active_marks` order wins.

Pinned by: `test_markdown_nested_sub_in_sup_dedupes_subsup_mark`

---

### AC-006 — All three marks (strike, sub, sup) coexist correctly in one sentence
(traces to BC-7.2.007 postcondition — ENABLE_SUBSCRIPT and ENABLE_STRIKETHROUGH are compatible)

`markdown_to_adf("~~s~~ ~b~ ^p^")` correctly assigns:
- text `"s"` → `strike` mark
- text `"b"` → `subsup sub` mark
- text `"p"` → `subsup sup` mark

The three marks are distinct and correctly routed after both flags are enabled simultaneously.

Pinned by: `test_markdown_strike_sub_sup_coexist`

---

### AC-007 — Round-trip losslessness: markdown → ADF → text preserves subsup
(traces to BC-7.2.007 postcondition — reverse path; adf_to_text apply_marks "subsup" arm)

`adf_to_text(markdown_to_adf("Hello ^sup^ and ~sub~"))` returns a string
containing `"^sup^"` and `"~sub~"` — the subsup marks survive the full round-trip.

The `apply_marks` function's new `"subsup"` arm renders:
- `attrs.type == "sub"` → wraps text as `~{text}~`
- `attrs.type == "sup"` (or missing) → wraps text as `^{text}^`

Pinned by: `test_render_subsup_mark_reverse_path`, `test_subsup_markdown_to_text_roundtrip`

---

### AC-008 — Heading attribute block is stripped; heading text is clean
(traces to BC-7.2.008 postcondition — ENABLE_HEADING_ATTRIBUTES consumed and dropped)

`markdown_to_adf("## Title {#myid}")` produces a heading node (level 2) whose
text content is exactly `"Title"`. The `{#myid}` attribute block does not appear
in the heading node's text. ADF headings have no `id` attribute; the parsed id
value is silently dropped with no ADF representation.

Four attribute forms are all consumed without leaking into heading text:
- `{#myid}` (id)
- `{.cls}` (class)
- `{#id .cls}` (combined)
- `{key=val}` (key-value)

Pinned by: `test_markdown_heading_attributes_stripped`

---

### AC-009 — Trailing `{...}` block is consumed/dropped regardless of attribute validity
(traces to BC-7.2.008 edge case EC-2 — corrected: all trailing brace blocks are stripped)

`markdown_to_adf("## Foo {bar}")` produces a heading node (level 2) whose text
content is exactly `"Foo"`. The `{bar}` block — despite containing no valid
attribute syntax (`#`, `.`, or `key=val`) — is consumed and dropped by
pulldown-cmark when `ENABLE_HEADING_ATTRIBUTES` is active.

pulldown-cmark parses any trailing `{...}` block at the end of an ATX heading as
an attribute block and silently discards tokens inside it that do not match valid
attribute syntax. There is no verbatim-preservation path for trailing braces.
This behavior applies only to trailing `{...}` blocks; mid-heading braces (e.g.,
`## Foo {bar} baz`) are untested and their behavior is not asserted here.

Pinned by: `test_markdown_heading_non_attribute_brace_stripped`

---

## Out of Scope (explicit)

**GFM alert blockquotes (`> [!NOTE]` / `[!TIP]` / `[!IMPORTANT]` / `[!WARNING]` / `[!CAUTION]`) → ADF `panel`**

Deferred to issue #483. Rationale: ADF `panel.content` forbids nested
`panel`, `table`, and `blockquote`, and `listItem` forbids `panel` entirely.
A faithful mapping requires content-model normalization analogous to the
`listItem` work in issue #470 (BC-7.2.006). Until that normalization layer is
implemented for `panel`, `> [!NOTE]` stays a plain `blockquote` node. The
code comment in `markdown_to_adf` documents this deferral explicitly.
`Options::ENABLE_GFM` is NOT added by this story.

---

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `dedup_marks_by_type` | `src/adf.rs` | Pure | Free function; takes `&[serde_json::Value]`, returns `Vec<serde_json::Value>`; no I/O, no side effects |
| `AdfBuilder::start` (Superscript/Subscript arms) | `src/adf.rs` | Effectful (mutates builder state) | Part of the event-driven builder; mutates `self.active_marks` |
| `AdfBuilder::push_text` (dedup applied) | `src/adf.rs` | Effectful (mutates builder state) | Emits a text node into the document tree |
| `AdfBuilder::push_code` (dedup applied) | `src/adf.rs` | Effectful (mutates builder state) | Emits a code node into the document tree |
| `apply_marks` subsup arm | `src/adf.rs` | Pure | Recursive text transformation; no I/O |
| `markdown_to_adf` options block | `src/adf.rs` | Pure (parser construction) | Adds three Options flags to the parser |

**Subsystem anchor justification:** No ARCH-INDEX subsystem applies — this is a single-file
pure transformation module (`src/adf.rs`) with no cross-subsystem interaction. The ADF
module is self-contained.

**Dependency anchor justification:** `depends_on: []` — no other story work is required
before implementing. The predecessor issues (#470, #472) are fully merged and their code
is present on branch. `blocks: []` — no story depends on #474 subsup support.

---

## Edge Cases

| ID | Source | Description | Expected Behavior | AC / BC |
|----|--------|-------------|-------------------|---------|
| EC-001 | BC-7.2.007 EC-1 | Intraword caret: `mc^2^` — `^` immediately adjacent to word char | Stays literal text; no `subsup` mark | AC-003 |
| EC-002 | BC-7.2.007 EC-2 | `code` mark cannot coexist with `subsup` on one text node | Accepted limitation (same class as `**\`x\`**`); Jira returns HTTP 400; not guarded here; tracked as follow-up | (none — known gap) |
| EC-003 | BC-7.2.007 EC-3 | Nested same-type spans `^a ~b~ c^` produce duplicate subsup marks | `dedup_marks_by_type` keeps first occurrence; deterministic first-wins rule | AC-005 |
| EC-004 | BC-7.2.007 EC-4 | `push_footnote_marker` interaction with dedup | `push_footnote_marker` appends an unmarked text node via `append_child` directly, bypassing `push_text` entirely — so `dedup_marks_by_type` is never called on that path; `active_marks` may be non-empty (e.g. `[strong]` active in `**bold[^1]**`) but is irrelevant because the dedup'd emission path is not taken at all | (no test needed) |
| EC-005 | BC-7.2.008 EC-1 | Four heading attribute forms: `{#id}`, `{.cls}`, `{#id .cls}`, `{key=val}` | All consumed; zero leakage into heading text | AC-008 |
| EC-006 | BC-7.2.008 EC-2 | Non-attribute brace text: `## Foo {bar}` | `{bar}` is consumed and dropped (same as valid attrs); heading text is `"Foo"` | AC-009 |
| EC-007 | BC-7.2.008 EC-3 | No ADF `id` field emitted | ADF heading nodes have no id attribute; parsed id consumed and dropped | AC-008 |
| EC-008 | delta-analysis Risk 1 | pulldown-cmark version change could reverse tilde disambiguation | Pinning tests `test_markdown_double_tilde_still_strikethrough_not_subscript` and `test_markdown_strike_sub_sup_coexist` will fail immediately at CI; no silent regression | AC-002 |

---

## Test Coverage Summary

All tests are inline unit tests in `src/adf.rs::tests`. No new integration test files.
No E2E test (both capabilities are pure transformation-layer with no observable HTTP shape
change visible to a live Jira instance — valid ADF accepted by Jira Cloud).

| Test name | BC | AC |
|-----------|----|----|
| `test_markdown_superscript_to_subsup_sup` | BC-7.2.007 | AC-001 |
| `test_markdown_subscript_to_subsup_sub` | BC-7.2.007 | AC-002 |
| `test_markdown_intraword_superscript_stays_literal` | BC-7.2.007 EC-1 | AC-003 |
| `test_markdown_double_tilde_still_strikethrough_not_subscript` | BC-7.2.007 | AC-002 |
| `test_render_subsup_mark_reverse_path` | BC-7.2.007 | AC-007 |
| `test_subsup_markdown_to_text_roundtrip` | BC-7.2.007 | AC-007 |
| `test_subsup_composes_with_strong` | BC-7.2.007 | AC-004 |
| `test_markdown_strike_sub_sup_coexist` | BC-7.2.007 | AC-006 |
| `test_markdown_nested_sub_in_sup_dedupes_subsup_mark` | BC-7.2.007 EC-3 | AC-005 |
| `test_markdown_nested_sub_in_sup_keeps_outer_sup` | BC-7.2.007 EC-3 | AC-005 |
| `test_markdown_heading_attributes_stripped` | BC-7.2.008 | AC-008 |
| `test_markdown_heading_non_attribute_brace_stripped` | BC-7.2.008 EC-2 | AC-009 |
| `test_markdown_superscript_no_mark_leak_to_trailing_text` | BC-7.2.007 | — (pins no-mark-leak guarantee: text after a closing `^` carries no subsup mark) |

Total: 13 new tests. All pass on branch `feat/adf-minor-constructs-474`.
Total `adf::tests` after addition: 105 (all green).

---

## Dependency Analysis

**No dependency cycle introduced.** This story has `depends_on: []` and `blocks: []`.
It is a leaf node in the dependency graph.

Topological sort validation:
- S-474 has no incoming edges (no depends_on).
- S-474 has no outgoing edges that cycle back.
- The dependency graph remains acyclic.

Wave placement: feature-followup (retroactive wrap of completed implementation).
No wave gate impact — story is already `implemented`.

---

## Story Points and Effort

**3 story points** (retroactive wrap + validation only; implementation already written).

Breakdown:
- F3 story authoring: 1 SP
- F4 validation (run tests, verify all 105 adf tests green, confirm no regression): 1 SP
- F5/F7 adversarial review + PR: 1 SP

From-scratch estimate would be ~5 SP (algorithm design + TDD). Reduction reflects
that the algorithm and tests are already written and proven on branch.
