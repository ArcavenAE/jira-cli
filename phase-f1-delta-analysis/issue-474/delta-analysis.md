---
document_type: delta-analysis-report
feature_name: "Markdown minor constructs → ADF (superscript/subscript subsup mark + heading-attribute stripping)"
issue: 474
created: 2026-06-08
spec_version_at_analysis: "post-#472-footnotes"
status: complete
intent: "enhancement"
feature_type: "backend"
severity: "LOW"
trivial_scope: false
predecessor_cycles: "PR #477 (issue #470, BC-7.2.006 listItem normalization), PR #481 (issue #472, footnotes)"
research_source: "git diff src/adf.rs on branch feat/adf-minor-constructs-474"
---

# F1 Delta Analysis: Issue #474 — Markdown Minor Constructs → ADF

## Feature Request

- **Brief:** Issue #474 proposes three lower-priority Markdown→ADF mappings that
  pulldown-cmark 0.13 can enable but the converter did not previously handle:
  (1) `^x^`/`~x~` superscript/subscript → ADF `subsup` mark, (2) GFM alert
  blockquotes `> [!NOTE]` → ADF `panel`, (3) `## Title {#id}` heading-attribute
  syntax leaked `{#id}` as literal text in the heading output.
- **Requested by:** Issue #474 (grouped as small; each mapping independently implementable).
- **Date:** 2026-06-08

---

## Classifications

### Intent Classification

**Classified intent:** `enhancement`

**Rationale:** This is a net-new capability addition, not a bug fix. The converter
previously produced well-formed ADF; it simply did not recognise these three Markdown
constructs. Enabling them extends the fidelity of the Markdown→ADF pipeline without
breaking any existing output. The heading-attribute case (`{#id}` leaking into text)
could be argued as a bug, but the leak was never spec'd as a defect and no BC
explicitly prohibited it — it is corrected as part of the enhancement.

### Feature Type Classification

**Classified type:** `backend`

**Rationale:** All changes are confined to `src/adf.rs`. No new CLI flags, no new
API calls, no config changes, no HTTP request shape changes. The two new capabilities
(subsup marks + heading-attr stripping) are purely internal to the
Markdown→ADF→text pipeline; they only affect what ADF payload is submitted when a
user provides Markdown content in `--description` or `--comment`.

### Trivial Scope Classification

**Classified scope:** `standard` (not trivial)

**Rationale:** The trivial-scope bar requires that no new BCs are needed. This change
adds two distinct new behavioural contracts:
- BC-7.2.007: superscript/subscript → `subsup` mark (including forward path, reverse
  `adf_to_text` path, round-trip losslessness, tilde-collision safety, and mark
  deduplication for nested same-type spans).
- BC-7.2.008: heading-attribute stripping (ENABLE_HEADING_ATTRIBUTES consumed/dropped,
  `{#id}`/`{.cls}`/`{key=val}` forms do not leak into heading text).

---

## Scope Decision

### In Scope

**1. Superscript/subscript → ADF `subsup` mark**

Enabled by adding `Options::ENABLE_SUPERSCRIPT | Options::ENABLE_SUBSCRIPT` to the
pulldown-cmark parser options in `markdown_to_adf`. The `AdfBuilder` gains two new
`Tag` arms:
- `Tag::Superscript` → `push_mark(json!({"type":"subsup","attrs":{"type":"sup"}}))`
- `Tag::Subscript` → `push_mark(json!({"type":"subsup","attrs":{"type":"sub"}}))`

A new free function `dedup_marks_by_type` is introduced. ADF (ProseMirror) treats a
text node's marks as a set keyed by type; a text node cannot carry two marks of the
same `type`. Without deduplication, nested same-type spans (e.g., `^a ~b~ c^`) would
produce a text node with two `subsup` marks — one `sup`, one `sub` — which Jira rejects
with HTTP 400. `dedup_marks_by_type` keeps the first occurrence of each mark type,
applied at both call sites where marks are emitted: `push_text` and
`push_code`.

The reverse path (`apply_marks` in `adf_to_text`) gains a `"subsup"` arm:
- `attrs.type == "sub"` → wraps in `~{result}~`
- otherwise (sup or missing) → wraps in `^{result}^`

This makes the markdown→ADF→text round-trip lossless for subsup content.

**Tilde-collision behaviour (load-bearing):** `ENABLE_SUBSCRIPT` reassigns the
single-tilde `~x~` token from strikethrough to subscript. Double-tilde `~~x~~` remains
`strike`. This is verified by
`test_markdown_double_tilde_still_strikethrough_not_subscript` (pinning test) and
`test_markdown_strike_sub_sup_coexist` (all three marks in one sentence).

**Known limitation:** pulldown-cmark does not open a superscript when `^` is tight
against a preceding word character. `mc^2^` stays literal; `mc ^2^` (space before `^`)
produces a `subsup` mark. Documented in CLAUDE.md and pinned by
`test_markdown_intraword_superscript_stays_literal`.

**2. Heading attribute stripping**

Enabled by adding `Options::ENABLE_HEADING_ATTRIBUTES` to the parser options. Once
enabled, pulldown-cmark parses and discards id (`{#id}`), class (`{.cls}`), and
key-value (`{key=val}`) attribute blocks from headings internally — they never appear
as `Event::Text` in the event stream. The `AdfBuilder` requires no code change for
this: the heading handler already ignores any non-text events inside a heading, and
attribute events are simply absent from the stream. The result is that `## Title {#id}`
produces a heading node whose text content is exactly `"Title"`.

Verified by `test_markdown_heading_attributes_stripped` covering four attribute forms:
`{#myid}`, `{.cls}`, `{#id .cls}`, `{key=val}`.

### Out of Scope (Deferred)

**GFM alert blockquotes (`> [!NOTE]`/`[!TIP]`/`[!IMPORTANT]`/`[!WARNING]`/`[!CAUTION]`) → ADF `panel`**

**Rationale for deferral:** ADF's `panel` node has a restricted content model:
`panel.content` forbids nested `panel`, `table`, and `blockquote`, and `listItem`
forbids `panel` entirely. A faithful GFM-alert→panel mapping therefore requires the
same content-model normalization logic that was built for `listItem` in issue #470
(BC-7.2.006). Without that normalization layer, a user's `> [!NOTE]` containing a
table or blockquote would produce ADF that Jira rejects with HTTP 400. Implementing the
normalization for `panel` is a distinct and non-trivial effort; grouping it with the
simpler subsup/heading-attr changes would obscure the risk boundary.

Until this is implemented, `> [!NOTE]` stays a plain `blockquote` node. The GFM alert
is tracked in a follow-up issue (referenced in code as `#483`). No `Options::ENABLE_GFM`
is added by this change.

---

## Impact Boundary

### Production Files

| File | Function / Element | Change Type | Description |
|------|--------------------|-------------|-------------|
| `src/adf.rs` | `markdown_to_adf` options block | MODIFY | Add `ENABLE_SUPERSCRIPT`, `ENABLE_SUBSCRIPT`, `ENABLE_HEADING_ATTRIBUTES`; document GFM-alert deferral in comment |
| `src/adf.rs` | `AdfBuilder::handle_tag_start` | MODIFY | Add `Tag::Superscript` and `Tag::Subscript` arms emitting `subsup` marks |
| `src/adf.rs` | `AdfBuilder::push_text` | MODIFY | Apply `dedup_marks_by_type` before emitting marks |
| `src/adf.rs` | `AdfBuilder::push_code` | MODIFY | Apply `dedup_marks_by_type` before emitting marks |
| `src/adf.rs` | `dedup_marks_by_type` | ADD | New free function: returns the first mark of each distinct `type`, preserving order |
| `src/adf.rs` | `apply_marks` (in `adf_to_text`) | MODIFY | Add `"subsup"` arm rendering `^x^` (sup) or `~x~` (sub) |
| `CLAUDE.md` | Markdown minor constructs gotcha | ADD | Documents subsup mapping, tilde-collision behaviour, intraword superscript limitation, heading-attr stripping, and GFM-alert deferral |

No other source files are modified. No new modules, structs, enums, or crates are
introduced. No CLI surface, API call shape, config, cache, or keychain layer is touched.

### Test Files

| File | Test | Change Type | Description |
|------|------|-------------|-------------|
| `src/adf.rs` (inline) | `test_markdown_superscript_to_subsup_sup` | ADD | `^sup^` → `subsup` mark with `attrs.type = "sup"` |
| `src/adf.rs` (inline) | `test_markdown_subscript_to_subsup_sub` | ADD | `~sub~` → `subsup` mark with `attrs.type = "sub"` |
| `src/adf.rs` (inline) | `test_markdown_intraword_superscript_stays_literal` | ADD | Pinning: `mc^2^` stays literal (no subsup); documents intraword limitation |
| `src/adf.rs` (inline) | `test_markdown_double_tilde_still_strikethrough_not_subscript` | ADD | Pinning: `~~struck~~` keeps `strike` mark after ENABLE_SUBSCRIPT; tilde-collision safety |
| `src/adf.rs` (inline) | `test_render_subsup_mark_reverse_path` | ADD | `adf_to_text` round-trip: ADF `subsup` sup → `^x^`; ADF `subsup` sub → `~y~` |
| `src/adf.rs` (inline) | `test_subsup_markdown_to_text_roundtrip` | ADD | End-to-end: `markdown_to_adf` → `adf_to_text` preserves `^sup^` and `~sub~` |
| `src/adf.rs` (inline) | `test_subsup_composes_with_strong` | ADD | `**^x^**` carries both `strong` and `subsup` marks; round-trip preserves both |
| `src/adf.rs` (inline) | `test_markdown_strike_sub_sup_coexist` | ADD | `~~s~~ ~b~ ^p^` correctly assigns `strike`/`subsup`/`subsup` marks |
| `src/adf.rs` (inline) | `test_markdown_nested_sub_in_sup_dedupes_subsup_mark` | ADD | `^a ~b~ c^` inner node has exactly one `subsup` mark; dedup logic verified |
| `src/adf.rs` (inline) | `test_markdown_heading_attributes_stripped` | ADD | `{#id}`, `{.cls}`, `{#id .cls}`, `{key=val}` — none leak into heading text |

All tests are inline unit tests in `src/adf.rs`. No new integration test files and no
changes to `tests/`. No E2E test is required: both capabilities are pure
transformation-layer logic with no observable HTTP shape change visible to a live Jira
instance (the ADF body containing subsup marks is valid ADF accepted by Jira Cloud).

### Documentation

| File | Change Type | Description |
|------|-------------|-------------|
| `CLAUDE.md` | ADD | Gotcha block for `adf.rs` issue #474: subsup mapping, tilde-collision, intraword `^` limitation, heading-attr stripping, and GFM-alert deferral rationale |
| `.factory/specs/prd/bc-7-output-render.md` | ADD (F2 scope) | BC-7.2.007 and BC-7.2.008 bodies; `total_bcs` and `definitional_count` incremented |

---

## BC Delta

### Existing BC Coverage

BC-7.2.001 through BC-7.2.006 govern the existing ADF pipeline. None of them cover
superscript/subscript marks or heading-attribute stripping. No existing BC is
contradicted or narrowed by this change; all existing contracts remain byte-for-byte
correct after the change.

### New BCs Required

**BC-7.2.007 (proposed): `markdown_to_adf("a ^sup^ b")` emits `subsup` mark with
`attrs.type = "sup"` on the superscript text node; `markdown_to_adf("a ~sub~ b")` emits
`subsup` mark with `attrs.type = "sub"` on the subscript text node. `adf_to_text`
renders `subsup` sup marks as `^x^` and sub marks as `~x~`, making the round-trip
lossless. Double-tilde `~~x~~` stays `strike`; single-tilde `~x~` becomes `sub`. Nested
same-type spans produce at most one `subsup` mark per text node (dedup-first-wins rule).
Intraword carets (`mc^2^`) stay literal — no `subsup` mark applied.**

**BC-7.2.008 (proposed): `markdown_to_adf("## Title {#id}")` produces a heading node
whose text content is exactly `"Title"` — the `{#id}` attribute block (and any
`{.cls}`, `{key=val}`, or combined form) does not appear in heading text. ADF headings
have no id attribute; the parsed id/class/key-value values are consumed and dropped.**

### Revised Count Impact

Section 7.2 currently has 6 contracts (BC-7.2.001..006). This change adds 2 BCs
(007, 008), bringing the section to 8. The `total_bcs` frontmatter in
`bc-7-output-render.md` must be updated from 85 to 87; the `definitional_count` from
39 to 41. Run `scripts/check-bc-cumulative-counts.sh` after editing.

---

## Predecessor Cycles

| Issue | PR | BC Added | Relationship |
|-------|----|----------|--------------|
| #470 | #477 | BC-7.2.006 | `listItem` content-model normalization; established the `normalize_list_item_content` + `is_empty_block_container` pattern used by #474's `dedup_marks_by_type` helper |
| #472 | #481 | none (retroactive CLAUDE.md + code) | Markdown footnotes → ADF; introduced `ENABLE_FOOTNOTES`, `push_footnote_marker`, footnote-definition flushing, and `is_empty_block_container` pruning. Directly adjacent code; implementer must not disturb the footnotes block |

Both predecessors are fully merged. No open PRs are in flight for `src/adf.rs`.

---

## Regression Risk

**Rating: LOW**

### Risk 1: Tilde-Collision — ENABLE_SUBSCRIPT Steals Single-Tilde from Strikethrough (HIGHEST probability; MITIGATED)

**Description:** pulldown-cmark's `ENABLE_STRIKETHROUGH` and `ENABLE_SUBSCRIPT` both
consume tilde tokens. When `ENABLE_SUBSCRIPT` is added alongside the pre-existing
`ENABLE_STRIKETHROUGH`, the tokeniser must disambiguate single-tilde `~x~` from
double-tilde `~~x~~`. The resolved behaviour in pulldown-cmark 0.13: single `~x~` →
`Tag::Subscript`, double `~~x~~` → `Tag::Strikethrough`. This is the desired outcome,
but it is a subtle tokeniser precedence rule that is not obvious from the flag names.

**Mitigation:** Two pinning tests lock this behaviour permanently:
- `test_markdown_double_tilde_still_strikethrough_not_subscript`: asserts `~~struck~~`
  has `marks[0].type = "strike"` — will fail immediately if a pulldown-cmark version
  change reverses the precedence.
- `test_markdown_strike_sub_sup_coexist`: asserts all three marks (`strike`, `subsup`,
  `subsup`) are correctly assigned in a sentence containing `~~s~~ ~b~ ^p^`.

These tests are the primary safety net for the tilde-collision. If pulldown-cmark
ever reverses the disambiguation, both tests will fail at CI time before any code is
shipped.

**Additional note from CLAUDE.md gotcha:** this is explicitly documented under the
`adf.rs` #474 entry; the `ENABLE_SUBSCRIPT` tilde-reassignment behaviour is named as
a load-bearing gotcha to alert future readers.

### Risk 2: dedup_marks_by_type Applied at Wrong Call Sites (MEDIUM probability if new call sites added)

**Description:** `dedup_marks_by_type` is called inside `push_text` and
`push_code`. If a future PR adds a third call site that builds a text
node with `self.active_marks` but does not call `dedup_marks_by_type`, nested
same-type spans will again produce duplicate marks on that code path.

**Mitigation:** The current change applies dedup at all existing text-emission call
sites. The `dedup_marks_by_type` function is a free function (not a method) and its
name is self-documenting. A future implementer adding a text-emission call site should
follow the pattern established here. No further mitigation is practical without
restructuring the mark-emission API.

### Risk 3: Footnote-Definition Flushing Interaction (#472 Adjacent Code)

**Description:** The footnote-definition flushing logic added in #472 uses
`push_text` internally (indirectly, via `push_footnote_marker` calling
`self.append_child`). If `dedup_marks_by_type` is called on a path where
`self.active_marks` contains marks from an outer context (e.g., a footnote reference
inside a bold span), the dedup could silently discard a mark that was valid for that
node.

**Assessment:** Low risk in practice. `push_footnote_marker` was designed in #472 to
be called with `active_marks` forcibly cleared (it deliberately does NOT inherit active
marks — see CLAUDE.md: "deliberately does NOT inherit active marks, so a ref inside
`**bold**` is not bolded"). Therefore `active_marks` is always empty at the point
`push_footnote_marker` is called, and `dedup_marks_by_type([])` returns `[]`. The
interaction is inert.

### Risk 4: Heading-Attribute Option Interferes with Other Heading Parsing

**Description:** `ENABLE_HEADING_ATTRIBUTES` is a parser-level option that changes
how pulldown-cmark tokenises `##` headings. If any heading text legitimately ends with
a `{…}` pattern that is not an attribute block, enabling this option could silently
consume it.

**Assessment:** Very low risk. pulldown-cmark only treats `{…}` as an attribute block
when it appears at the very end of a heading line and matches the attribute syntax
grammar (leading `#` for id, `.` for class, or `key=value` form). A heading ending
with e.g. `## Foo {bar}` (no `#`, `.`, or `=`) would not be parsed as an attribute
block. The test `test_markdown_heading_attributes_stripped` covers four distinct forms;
no regression is expected for normal heading text.

### Risk 5: Code Mark + Subsup Coexistence (KNOWN LIMITATION, NOT MITIGATED)

**Description:** ADF schema forbids `code` mark coexistence with `subsup`, `em`,
`strong`, or `strike` on one text node. `` ^`x`^ `` (superscript wrapping a code
span) would produce a text node with both `code` and `subsup` marks, which Jira
rejects. This is the same class of issue as `` **`x`** `` (bold + code), which is a
pre-existing known limitation.

**Assessment:** Not mitigated in this change. The issue is tracked as a follow-up
class in CLAUDE.md: "pre-existing class: `` **`x`** `` has the same issue; tracked
as a follow-up." The risk is accepted as LOW because Markdown authors rarely nest
code spans inside superscript/subscript, and the failure mode is a Jira 400 (visible
immediately), not silent data loss.

---

## Story Count Recommendation

**Recommended: 0 new stories (retroactive wrap only)**

The implementation and tests for #474 are ALREADY WRITTEN and uncommitted on branch
`feat/adf-minor-constructs-474`. This delta analysis is the F1 layer of a retroactive
VSDD wrap, matching the handling of sibling features #470 and #472. The required
phases are:

| Phase | Scope |
|-------|-------|
| F2 | Author BC-7.2.007 and BC-7.2.008 in `bc-7-output-render.md`; update `total_bcs` (85→87) and `definitional_count` (39→41); run `scripts/check-bc-cumulative-counts.sh` |
| F4 | Validate implementation on branch against F2 BCs; verify all 10 inline tests pass; confirm no CLI/API regression |
| F5 | Scoped adversarial review of `src/adf.rs` delta |
| F7 | Delta-convergence + count reconciliation + code-delivery PR |

No F3 story decomposition is needed because no implementation work remains. F6
(targeted hardening) is optional — if adversarial review surfaces a gap, a targeted
fix can be applied in the same PR.

### Effort Estimate (remaining VSDD wrap work only)

| Task | LOC estimate |
|------|-------------|
| BC-7.2.007 body in `bc-7-output-render.md` | ~25–35 LOC (spec prose) |
| BC-7.2.008 body in `bc-7-output-render.md` | ~15–20 LOC (spec prose) |
| Frontmatter count updates + script check | ~5 LOC |
| CLAUDE.md gotcha block | ~20–25 LOC |
| F4 validation (run tests, review) | no LOC |
| PR creation and CI pass | no LOC |

**Total remaining spec prose:** ~65–85 LOC.

---

## Open Questions

_All questions resolved as of F2/F3/F5 progression. Section retained for audit trail._

**Q1 — GFM alert deferral issue number:**

RESOLVED (F5 confirmation). Issue #483 exists and is titled
"feat(adf): map GFM alerts (> [!NOTE]) to ADF panel with content-model normalization".
The `#483` reference in code comments and the deferral rationale in this document are
correct. No tracker correction required.

**Q2 — CLAUDE.md gotcha placement:**

RESOLVED (F2/F4 proceeded). The #474 gotcha was inserted immediately after the #472
footnote block. Separate adjacent blocks per issue were used (not a consolidated block).
Decided by F2 author proceeding without objection.

**Q3 — BC-7.2.007 scope: intraword superscript limitation as an EC or separate BC:**

RESOLVED (F2 proceeded). Intraword caret limitation treated as an edge case within
BC-7.2.007. BC count increase remains 2 (BC-7.2.007 + BC-7.2.008). No BC-7.2.009 was
created.

**Q4 — Heading-attribute option and pulldown-cmark version lock:**

RESOLVED (F2 proceeded). The pinning test (`test_markdown_heading_attributes_stripped`)
is treated as sufficient. BC-7.2.008 does not include a spec-level pulldown-cmark
version note; version specificity is captured in CLAUDE.md instead.

---

## Pre-Implementation Checklist (F2 author)

Before writing BC-7.2.007/008 bodies:

- [ ] Re-read `BC-7.2.006` body structure in `bc-7-output-render.md` — match the
  `**Confidence**`, `**Source**`, `**Subject**`, `**Behavior**`, `**Edge cases**`,
  `**Trace**` field layout exactly.
- [ ] Verify the pulldown-cmark version in `Cargo.toml` (must be 0.13.x) and confirm
  `ENABLE_SUPERSCRIPT`, `ENABLE_SUBSCRIPT`, `ENABLE_HEADING_ATTRIBUTES` are all
  present in the `Options` flags for that version.
- [ ] Run `cargo test --lib -- adf::tests::test_markdown_double_tilde` and confirm the
  pinning test passes on the current branch before writing the BC.
- [ ] After editing `bc-7-output-render.md`, run
  `scripts/check-bc-cumulative-counts.sh` — exits 0 required before F4.
- [ ] After editing `bc-7-output-render.md`, run
  `scripts/check-spec-counts.sh` — exits 0 required before F4.

---

_Created 2026-06-08. Source diff: `git diff src/adf.rs` on branch `feat/adf-minor-constructs-474`._
_Status updated to complete 2026-06-09: Q1–Q4 all resolved; F2/F3/F4 complete; F5 in progress._
