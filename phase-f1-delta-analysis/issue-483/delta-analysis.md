---
document_type: delta-analysis-report
feature_name: "GFM alerts (> [!NOTE|TIP|IMPORTANT|WARNING|CAUTION]) → ADF panel with content-model normalization"
issue: 483
created: 2026-06-09
spec_version_at_analysis: "post-#474-minor-constructs"
status: complete
intent: "enhancement"
feature_type: "backend"
severity: "LOW"
trivial_scope: false
predecessor_cycles: "PR #477 (issue #470, BC-7.2.006 listItem normalization), PR #481 (issue #472, footnotes + empty-container pruning), PR #486 (issue #474, BC-7.2.007..008 subsup + heading-attr)"
research_source: "research-agent (pulldown-cmark 0.13 + @atlaskit/adf-schema 52.9.5 primary sources) + empirical parser probing on branch feat/adf-gfm-alerts-panel"
delivery_note: "Delivered via validated-feature-lifecycle (lightweight VSDD). This F1 artifact authored retroactively to complete the Feature-Mode artifact set; records actual work performed."
---

# F1 Delta Analysis: Issue #483 — GFM Alerts → ADF Panel

## Feature Request

Map GitHub-Flavored Markdown alert blockquotes
(`> [!NOTE]`, `> [!TIP]`, `> [!IMPORTANT]`, `> [!WARNING]`, `> [!CAUTION]`) to
ADF `panel` nodes in `markdown_to_adf`, instead of leaving them as plain
blockquotes with a literal `[!KIND]` marker. Split out from #474, which
explicitly deferred this because the panel mapping opens a content-model
normalization problem (the same class #470 solved for `listItem`).

---

## Classifications

### Intent Classification
**enhancement** — adds new output-fidelity capability (alert → panel). No bug
being fixed; existing markdown behavior is unchanged.

### Feature Type Classification
**backend** — pure `src/adf.rs` rendering logic (markdown→ADF and ADF→text). No
CLI surface, flags, or interactive behavior added; fully composable/scriptable.

### Trivial Scope Classification
**false** — not a one-line change. Adds a new `NodeKind`, two mapping helpers, a
recursive content-model normalization pass, a reverse-render arm, prune-set
membership, and 18 tests; plus a behavioral contract and spec.

---

## Scope Decision

### In Scope
1. Enable `Options::ENABLE_GFM` (in pulldown-cmark 0.13 this gates only alert
   blockquotes — verified no side effect on the individually-set tables/strike/
   footnotes/subsup/heading-attr flags).
2. `Tag::BlockQuote(Some(kind))` → `panel` with portable `panelType`
   (`panel_type_for`, exhaustive match). `BlockQuote(None)` stays `blockquote`.
3. Panel content-model normalization (`normalize_panel_content`): unwrap nested
   `panel`/`blockquote`, flatten `table` to per-row paragraphs, strip node-level
   marks from `heading`/`paragraph`.
4. Extend `normalize_list_item_content` with a `panel` arm (ADF `listItem`
   forbids `panel` → unwrap).
5. Body-less alert → empty content → pruned by `is_empty_block_container`
   (`panel` added to the prune set).
6. Reverse path: `adf_to_text` renders `panel` → `> [!KIND]` via
   `gfm_label_for_panel_type`; unmapped panelType → plain blockquote.

### Out of Scope (Deferred)
- `panelType: "custom"` / `"tip"` — editor-feature-gated, inconsistent on Jira
  Cloud; only the five portable types (info/note/warning/error/success) emitted.
- `mediaGroup`/`mediaSingle`/`blockCard`/`decisionList`/`taskList` inside panels
  — `markdown_to_adf` produces none of these from markdown today.
- GFM task lists (`- [ ]`) → `taskList` — separate issue #471.
- Live-Jira sandbox verification of produced shapes — needs-sandbox; documented
  as manual follow-up in the spec.

---

## Impact Boundary

### Production Files
- `src/adf.rs` — only production file touched:
  - `markdown_to_adf`: `| Options::ENABLE_GFM` + comment.
  - `NodeKind::Panel { panel_type }` variant.
  - `panel_type_for` / `gfm_label_for_panel_type` (forward/inverse maps).
  - `AdfBuilder::start` BlockQuote arm split on `Option<BlockQuoteKind>`.
  - `AdfBuilder::end` Panel arm (normalize + empty-prune handling).
  - `normalize_panel_content` (new); `normalize_list_item_content` panel arm.
  - `is_empty_block_container` REQUIRES_CONTENT += `"panel"` (7→8).
  - `adf_to_text` `panel` render arm.

### Test Files
- `src/adf.rs::tests` — 18 new unit tests (forward ×5 kinds, leniency ×2,
  literal-disqualifier ×2, plain-blockquote, nested-unwrap, table-flatten,
  listItem-unwrap, heading-mark-strip, empty-prune, invariant scan, reverse ×4,
  round-trip, paragraph-mark-strip unit); membership + empty-container helpers
  extended with `panel`.

### Documentation
- `docs/specs/adf-panel-content-model.md` (new feature spec).
- `CLAUDE.md` — new GFM-alerts gotcha note; #474 deferral note superseded.

---

## BC Delta

### Existing BC Coverage
BC-7.2.001..008 cover text/markdown→ADF, marks, round-trip, listItem
normalization (BC-7.2.006), subsup + heading-attr (BC-7.2.007..008). None cover
alert→panel.

### New BCs Required
- **BC-7.2.009** — GFM alerts → `panel` with content-model normalization +
  reverse render. (Authored in `bc-7-output-render.md`.)

### Revised Count Impact
- bc-7-output-render.md: `total_bcs` 87→88, `definitional_count` 41→42.
- Section 7.2: 8→9 individually-bodied (BC-7.2.001..009); range-collapsed row
  shifted `009..054`→`010..055` (size preserved, 232 range-collapsed unchanged).
- Grand total 592→593. All 8 count surfaces updated; both
  `check-bc-cumulative-counts.sh` and `check-spec-counts.sh` pass.

---

## Predecessor Cycles
- **#470 / PR #477** — `normalize_list_item_content` established the
  content-model normalization pattern this feature mirrors for `panel`.
- **#472 / PR #481** — `is_empty_block_container` empty-shell pruning; `panel`
  joins its prune set.
- **#474 / PR #486** — enabled subsup + heading-attr; explicitly deferred GFM
  alerts (this issue). Confirmed `ENABLE_GFM` independent of footnote parsing.

---

## Regression Risk
**LOW.** The change is additive: only `Tag::BlockQuote(Some(kind))` (a new
event, previously unreachable without `ENABLE_GFM`) takes the new path; plain
blockquotes (`BlockQuote(None)`) are byte-for-byte unchanged. Full regression:
lib 818/0, integration all green, clippy `-D warnings` clean, fmt clean,
`cargo deny` clean. The only behavioral shift for previously-parsed input is
that an alert-marker line that used to render as a literal-text blockquote now
becomes a panel — which is the intended improvement, and the literal fallback is
preserved for disqualified markers (trailing text, unknown kind).
