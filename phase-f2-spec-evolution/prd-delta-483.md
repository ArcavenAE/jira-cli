---
document_type: prd-delta
issue: 483
feature: "GFM alerts → ADF panel with content-model normalization"
created: 2026-06-09
status: complete
bc_added: ["BC-7.2.009"]
bc_modified: []
bc_retired: []
count_impact: "bc-7-output-render.md 87→88 total / 41→42 definitional; grand total 592→593"
pr: 487
---

# F2 Spec Evolution (PRD Delta) — Issue #483

## New Behavioral Contract

### BC-7.2.009 — GFM alerts → ADF `panel` with content-model normalization + reverse render

Authored in `.factory/specs/prd/bc-7-output-render.md` §7.2. Behavior summary:

- `markdown_to_adf` enables `Options::ENABLE_GFM`. `Tag::BlockQuote(Some(kind))`
  → `panel`; `BlockQuote(None)` → `blockquote`.
- Kind → portable panelType (`panel_type_for`): Note→info, Tip→success,
  Important→note, Warning→warning, Caution→error. (`tip`/`custom` avoided.)
- `normalize_panel_content` enforces `panel.content` (forbids nested
  panel/table/blockquote): unwrap nested panel/blockquote, flatten table to
  per-row paragraphs, strip node-level marks from heading/paragraph.
- `normalize_list_item_content` gains a `panel` arm (listItem forbids panel).
- Empty alert → empty content → pruned by `is_empty_block_container`
  (`panel` added to prune set).
- Reverse: `adf_to_text` renders `panel` → `> [!KIND]` via
  `gfm_label_for_panel_type`; unmapped panelType → plain blockquote.

Edge cases EC-1..EC-5 (parser leniency, nested unwrap, table flatten,
listItem unwrap, empty prune) documented in the BC body.

## Count Surfaces Updated (8)

All updated to keep the 8-surface invariant (verified by both check scripts):

1. `bc-7-output-render.md` frontmatter `total_bcs` 87→88, `definitional_count` 41→42
2. `bc-7-output-render.md` §7.2 header "8…BC-7.2.001..008; 54" → "9…BC-7.2.001..009; 55"
3. `bc-7-output-render.md` body preamble prose 87→88
4. `BC-INDEX.md` frontmatter `total_bcs` 592→593
5. `BC-INDEX.md` `sections:` line for bc-7 (87/41 → 88/42)
6. `BC-INDEX.md` §7 header + §7.2 header + BC row + range row `009..054`→`010..055` + Coverage table (592/360 → 593/361)
7. `CANONICAL-COUNTS.md` per-file tables (42 / 88), Sum 592→593, grand-total prose, L2/L3 row
8. Grand-total prose in both BC-INDEX and CANONICAL-COUNTS → 593

## Architecture / Verification Delta
- No new ADR (mapping is a localized rendering decision within the existing
  thin-client/ADF boundary; ADR-0001 unaffected).
- No new verification properties (covered by unit tests; mutation testing scope
  for adf.rs governed by `docs/specs/cargo-mutants-policy.md` — see F6 report).

## Spec Document
`docs/specs/adf-panel-content-model.md` — full feature spec (problem, validated
Atlassian/pulldown constraints, design §1–6, edge cases, test plan, out-of-scope).
