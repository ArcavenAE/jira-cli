# FIX-P5-006 Spec Delta (cycle-014 F5 pass-5) — spec v2.7.2, human decision D-400

Spec-only. Product code unchanged at develop 0a4dc062. Count-neutral.

## 1. Required help wording (P5-001) — BC-X.14.001 EC-X.14.001-22
`jr field options <FIELD>` help must contain, verbatim:
`a customfield_NNNNN literal, a field ID such as issuetype or priority (exact, case-insensitive), or a field name`
Test (NOT YET IMPLEMENTED): `tests/field_options.rs::test_bc_x_14_001_field_options_help_mentions_system_field_ids`
(exit 0; stdout contains `customfield_NNNNN`, `issuetype`, `case-insensitive`, and the full substring; zero HTTP).

## 2. Sanitization requirement (SEC5-002) — BC-X.14.004 EC-X.14.004-9
In `src/cli/field.rs::search_field_list`, all three ambiguity branches (duplicate-ID, exact-name, substring) must pass every
server-supplied candidate `name` and `id` through `output::sanitize_terminal_line` before interpolation. Format, order, exit 64 and
`FIELD_ID_HINT` unchanged. The UserError Display feeds stderr AND the JSON `"error"` field (same as `disambiguate_user`), so one
sanitization covers both. Tests (NOT YET IMPLEMENTED):
- `src/cli/field.rs::test_bc_x_14_004_ambiguity_candidates_are_sanitized` (names with ESC/CSI and `\n`, all three branches)
- `tests/field_options.rs::test_bc_x_14_004_ambiguity_candidates_are_sanitized_in_stderr_and_json`
Once fixed, field.rs ambiguity errors are not a NONTABLE-SERVER-TEXT-SANITIZE residual (note added to BC-7.1.006 residual list).

## 3. Accepted residual (SEC5-001) — BC-7.1.006 v1.6.2 EC-24
KEPT by design (no code change): U+2800, U+17B4/U+17B5, U+FFFC, Zs spaces (U+00A0, U+1680, U+2000..=200A, U+202F, U+205F, U+3000).
Policy stays category-based (Cf + named extras); visible-width spaces are legitimate text; human stopped extending the list per pass (D-400).
Optional KEEP pin (NOT YET IMPLEMENTED): `src/output.rs::test_bc_7_1_006_sanitize_keeps_blank_rendering_non_cf_characters`.

## 4. Citation hygiene (P5-004)
EC-X.14.001-15's `~L442-447`/`~L451` refs replaced with symbol-form `src/cli/field.rs::resolve_field_id` § guard/cache-read citations.

## Files
specs/prd/bc-7-output-render.md, specs/prd/cross-cutting.md, spec-changelog.md ([2.7.2]).
