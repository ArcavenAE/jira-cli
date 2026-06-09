---
document_type: story
story_id: "S-483"
title: "GFM alerts (> [!NOTE|TIP|IMPORTANT|WARNING|CAUTION]) → ADF panel with content-model normalization"
wave: feature-followup
status: implemented
intent: enhancement
feature_type: backend
mode: feature
scope: small
severity: LOW
trivial_scope: false
issue: 483
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
  - BC-7.2.009
bcs:
  - BC-7.2.009
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: ".factory/phase-f1-delta-analysis/issue-483/delta-analysis.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 10
assumption_validations: []
risk_mitigations: []
created: "2026-06-09"
last_updated: "2026-06-09"
breaking_change: false
retroactive: true
pr: 487
---

# S-483 — GFM Alerts → ADF Panel

## Summary

Map GitHub-Flavored Markdown alert blockquotes to ADF `panel` nodes in
`markdown_to_adf`, with a panel content-model normalization pass (mirroring
#470's `listItem` pass) and a reverse `adf_to_text` render path. Split out from
#474, which deferred it.

## Behavioral Contracts

| BC | Statement |
|----|-----------|
| BC-7.2.009 | `markdown_to_adf` maps GFM alerts to ADF `panel` (info/success/note/warning/error) with content-model normalization; `adf_to_text` renders `panel` back to a `> [!KIND]` alert. |

## Acceptance Criteria

1. **AC-1** — `> [!NOTE]\n> x` → `panel` `info` with one paragraph; the `[!NOTE]`
   marker does not survive as literal text.
   (`test_markdown_alert_note_maps_to_panel_info`)
2. **AC-2** — Tip→`success`, Important→`note`, Warning→`warning`, Caution→`error`.
   (`test_markdown_alert_{tip,important,warning,caution}_maps_to_panel_*`)
3. **AC-3** — A plain `> quote` stays a `blockquote` (unchanged).
   (`test_markdown_plain_blockquote_unchanged`)
4. **AC-4** — Marker disqualifiers stay literal blockquotes: trailing text on the
   marker line (`> [!NOTE] extra`) and unknown kind (`> [!FOO]`).
   (`test_markdown_alert_marker_with_trailing_text_stays_literal_blockquote`,
   `test_markdown_unknown_alert_kind_stays_literal_blockquote`)
5. **AC-5** — Parser leniency pinned: `>[!NOTE]` (no space) and any-case
   (`[!note]`/`[!Note]`) still map to a panel.
   (`test_markdown_alert_marker_without_leading_space_still_panel`,
   `test_markdown_alert_marker_case_insensitive_still_panel`)
6. **AC-6** — Nested alert (`panel > panel`) → inner panel unwrapped; no panel
   contains a nested panel anywhere.
   (`test_markdown_nested_alert_unwraps_inner_panel`)
7. **AC-7** — Alert wrapping a table → table flattened to per-row paragraphs;
   cell data survives.
   (`test_markdown_alert_with_table_flattens_to_paragraphs`)
8. **AC-8** — Alert inside a list item → panel unwrapped (no `listItem > panel`).
   (`test_markdown_alert_in_listitem_unwraps_panel`)
9. **AC-9** — Panel `heading`/`paragraph` children carry no node-level marks;
   empty alert is pruned entirely (no empty panel shell).
   (`test_markdown_alert_heading_child_has_no_marks`,
   `test_normalize_panel_content_strips_paragraph_marks`,
   `test_markdown_empty_alert_pruned`); invariant scan
   (`test_panel_content_only_permitted_node_types`).
10. **AC-10** — Reverse path: `panel` → `> [!KIND]` (quoted marker, per-line
    quoting); unmapped panelType (`tip`/`custom`) → plain blockquote, no marker;
    round-trip stable for the five kinds.
    (`test_render_panel_info_to_note_alert`,
    `test_render_panel_multiline_body_quotes_every_line`,
    `test_render_panel_unknown_type_to_plain_blockquote`,
    `test_render_panel_tip_type_renders_no_marker`,
    `test_alert_markdown_to_text_roundtrip_all_kinds`)

## Implementation Notes

- `markdown_to_adf`: `| Options::ENABLE_GFM` (gates only alert blockquotes in 0.13).
- `panel_type_for(BlockQuoteKind) -> &'static str` (exhaustive, no `_` arm).
- `gfm_label_for_panel_type(&str) -> Option<&'static str>` (inverse).
- `normalize_panel_content` (new) + `normalize_list_item_content` panel arm.
- Empty-alert → empty `content` → `is_empty_block_container` prune (`panel` added).
- `adf_to_text` `panel` arm (line-prefixing shared with the `blockquote` arm).

## Architecture Compliance

- No `unsafe`. No clippy `#[allow]`. Idiomatic Rust. New tests follow
  `test_<verb>_<subject>_<outcome>` naming.
- Output-channel profile unchanged (ADF is wire data; no stderr/stdout change).

## Definition of Done

- [x] All 10 ACs covered by passing unit tests (18 new; adf module 132 total).
- [x] `cargo test` full tree green; clippy `-D warnings` clean; fmt clean.
- [x] BC-7.2.009 authored; 8 count surfaces consistent (both check scripts pass).
- [x] Spec `docs/specs/adf-panel-content-model.md`; CLAUDE.md note.
- [x] Fresh-context multi-agent review → clean (see F5 record).
- [x] PR #487 → develop; CI green; Copilot comment addressed + thread resolved.
- [ ] Live-Jira sandbox verification of produced shapes (needs-sandbox; deferred).
