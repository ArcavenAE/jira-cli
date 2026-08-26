# Demo Evidence — S-580-1: `jr field options <field>` — M1/M2/M3 Context-Mechanism Resolution

Story: `S-580-1` — new top-level `jr field options <field>` command family (issue #580,
field-dx bundle part 1 of 5). BCs: BC-X.14.001 (resolution + normalized model), BC-X.14.002
(`--value` filter), BC-X.14.003 (table/JSON output shape), BC-X.14.004 (error taxonomy +
graceful degradation). 14 acceptance criteria, all covered below.

## Scope note

`jr field options` is a strictly read-only command (BC-X.14.001 Invariant 2) with three
enumeration mechanisms (M1 `--issue` editmeta, M2 `--type` createmeta, M3 `--request-type`
JSM request-type fields). All three mechanisms feed the SAME shared normalize/filter/render
pipeline (`normalize_from_allowed_values`/`normalize_from_valid_values` → `filter_options` →
`render_option_rows`/`output::print_output`), so the M1 path — the cheapest to mock (a
single `GET /issue/{key}/editmeta` call, no project/service-desk/issue-type resolution
round-trips) — is used to demonstrate the full shared pipeline: cascading children,
degenerate-entry rendering, the `--value` filter, and graceful degradation. The M2
(createmeta, project + issue-type resolution) and M3 (JSM request-type fields, service-desk
resolution) paths reuse that identical downstream pipeline over a different upstream fetch;
their own mode-specific resolution steps (issue-type name→id, service-desk discovery,
project 404 handling) are covered by the existing wiremock integration suite in
`tests/field_options.rs`, cited per-AC below rather than re-recorded, per the task's
proportionality guidance ("capture the representative modes + errors, don't exhaustively
record every taxonomy row").

## Recordings

All recordings run the actual worktree debug binary (`cargo build`, `target/debug/jr`) via
VHS terminal recording, from an isolated fake profile (`JR_CONFIG_DIR`/`JR_CACHE_DIR`
pointed at throwaway temp dirs, `JR_AUTH_HEADER` set to a fake Basic auth value — none of
this repo's real config/cache/keychain state is touched).

### Server-free (arity + empty-name errors — zero HTTP by construction)

| Recording | Command demonstrated | Result |
|---|---|---|
| `AC-002-zero-mode-selectors.{gif,webm}` | `jr field options customfield_10084 --no-input` | exit 64, `"You must specify exactly one of --type, --request-type, --issue."` — `resolve_field_context`'s pure arity check (Step 1 of `handle()`) rejects before any HTTP call |
| `AC-003-multiple-mode-selectors.{gif,webm}` | `jr field options customfield_10084 --type Bug --issue FOO-1 --no-input` | exit 64, same message — two-or-more mode selectors also rejected by the same pure arity check |
| `AC-011-empty-field-name.{gif,webm}` | `jr field options '' --issue FOO-1 --no-input` | exit 64, `"Field '' not found. The field name must not be empty."` — `resolve_field_id`'s empty-string guard fires before the `customfield_` bypass check or any HTTP call |

### Mocked (M1 `--issue` path, against `mock_editmeta_server.py`)

| Recording | Command demonstrated | Result |
|---|---|---|
| `AC-013-table-cascading-degenerate.{gif,webm}` | `jr field options customfield_10084 --issue DEMO-1 --no-input` | table output: ID/Label columns, `Silver`'s child `Silver Plus` indented under it, and a fully degenerate entry (missing id AND label) rendered as `—` / `(unnamed)` rather than dropped |
| `AC-013-json-array-shape.{gif,webm}` | `jr field options customfield_10084 --issue DEMO-1 --output json --no-input` | pretty-printed JSON array; the SAME degenerate entry emits raw `null` for both `id` and `label` (no glyph substitution in JSON mode); nested `children[]` preserved verbatim under `Silver`, not flattened |
| `AC-012-value-filter-narrowing.{gif,webm}` | `jr field options customfield_10084 --issue DEMO-1 --value silver --no-input` | narrows to `Silver` + its `Silver Plus` child (a self-matching parent retains ALL its children unfiltered); `Gold` and the degenerate entry are excluded |
| `AC-014-graceful-degrade.{gif,webm}` | `jr field options customfield_20000 --issue DEMO-1 --no-input` | exit 0 (never an error): stderr hint `"no enumerable options for 'Internal Notes' — this field type has no fixed value set."`, stdout `"No results found."` (empty table) |

Supporting files in this directory:
- `*.tape` — VHS scripts (source of truth for each recording; re-run with `vhs <file>.tape`
  from the worktree root to reproduce; the four mocked tapes additionally require
  `mock_editmeta_server.py` running on port 18766 — see "Reproducing" below)
- `setup.sh` — shared hidden setup (fake profile config + auth header + `PATH`, optionally
  `JR_BASE_URL` pointed at the mock server) sourced inside each tape's `Hide` block
- `fixtures/config.toml` — the fake `jr` profile config used by `setup.sh`
- `mock_editmeta_server.py` — minimal GET-only Jira mock serving
  `GET /rest/api/3/issue/DEMO-1/editmeta` with two fields (`customfield_10084`, a cascading
  option field with a degenerate entry; `customfield_20000`, a free-text field with no
  `allowedValues`) — used only by the four mocked recordings above

### Reproducing the mocked recordings

```bash
cd .worktrees/S-580-1
python3 docs/demo-evidence/S-580-1/mock_editmeta_server.py 18766 &
vhs docs/demo-evidence/S-580-1/AC-013-table-cascading-degenerate.tape
vhs docs/demo-evidence/S-580-1/AC-013-json-array-shape.tape
vhs docs/demo-evidence/S-580-1/AC-012-value-filter-narrowing.tape
vhs docs/demo-evidence/S-580-1/AC-014-graceful-degrade.tape
kill %1
```

## AC → Evidence mapping

| AC | Summary | Evidence |
|---|---|---|
| AC-001 | Mode-selector mutual exclusion is a pure function, evaluated before any HTTP | Tests: `test_bc_x_14_001_resolve_field_context_arity_proptest` (inline proptest, `src/cli/field.rs::tests`), `test_bc_x_14_001_zero_mode_selectors_exits_64_zero_http` (`tests/field_options.rs`) — PASS. **Also demonstrated live**: `AC-002-zero-mode-selectors` and `AC-003-multiple-mode-selectors` both show the arity check rejecting before any HTTP call reaches the (fake, unreachable-without-`JR_BASE_URL`) profile host |
| AC-002 | Zero mode selectors → exit 64 with canonical message | Recording: `AC-002-zero-mode-selectors.{gif,webm}`. Tests: `test_bc_x_14_004_zero_mode_selectors_message`, `test_bc_x_14_004_bare_project_no_mode_selector_is_zero_mode_error` (`tests/field_options.rs`) — PASS |
| AC-003 | Two-or-more mode selectors → exit 64, same message | Recording: `AC-003-multiple-mode-selectors.{gif,webm}`. Test: `test_bc_x_14_001_two_mode_selectors_exits_64` (`tests/field_options.rs`) — PASS. Also `test_bc_x_14_004_all_three_mode_selectors_exits_64_precedence` for the three-selectors-at-once variant |
| AC-004 | M2 post-arity project resolution (flag OR profile default; neither → exit 64) | Tests: `test_bc_x_14_001_resolve_m2_project_flag_wins`, `test_bc_x_14_001_resolve_m2_project_falls_back_to_config_default` (`src/cli/field.rs::tests`), `test_bc_x_14_001_m2_resolves_via_profile_default_project`, `test_bc_x_14_004_m2_no_resolvable_project_exits_64_widened_message` (`tests/field_options.rs`) — PASS. Not recorded — M2's createmeta mock (project + issue-type endpoints) would duplicate the pipeline already demonstrated by the M1 recordings above for marginal additional evidence value |
| AC-005 | M2 `--type` name→id resolution reuses `get_issue_types_for_project` (S-331), fires before `get_createmeta_fields` | Tests: `test_bc_x_14_001_m2_type_resolution_reused_from_s331`, `test_bc_x_14_004_ec_x_14_004_4_unknown_type_exits_64_before_createmeta` (`tests/field_options.rs`) — PASS |
| AC-006 | M3 `--request-type [--project]` reuses JSM request-type-fields plumbing verbatim; `--project` + `--request-type` together is valid | Tests: `test_bc_x_14_001_m3_project_request_type_together_is_valid`, `test_bc_x_14_001_m3_non_jsm_project_exits_64_require_service_desk`, `test_bc_x_14_001_m3_request_type_name_exact_match_resolves` (`tests/field_options.rs`) — PASS |
| AC-007 | M1 `--issue <KEY>` reuses `get_editmeta` verbatim; `--project` not consulted | Recordings: all four mocked recordings above exercise the M1 `get_editmeta` path end-to-end. Tests: `test_bc_x_14_001_m1_issue_reuses_get_editmeta`, `test_bc_x_14_001_m1_stray_project_harmlessly_ignored`, `test_bc_x_14_004_m1_issue_not_found_exits_64` (`tests/field_options.rs`) — PASS |
| AC-008 | `get_createmeta_fields` offset-paginates internally; a field on page ≥2 still resolves | Tests: `test_bc_x_14_001_get_createmeta_fields_paginates_all_pages`, `test_bc_x_14_001_get_createmeta_fields_continues_pagination_when_total_absent`, `test_bc_x_14_001_get_createmeta_fields_empty_page_terminates_not_infinite_loop` (`tests/field_options.rs`) — PASS |
| AC-009 | Normalized `FieldOption{id,label,children}` model — degenerate entries never dropped | Recordings: `AC-013-table-cascading-degenerate.{gif,webm}` and `AC-013-json-array-shape.{gif,webm}` both show the fully-degenerate `{id:None, label:None}` entry rendered (not dropped) — table mode `—`/`(unnamed)`, JSON mode raw `null`/`null`. Tests: `test_bc_x_14_001_normalizer_never_drops_degenerate_entries`, `test_bc_x_14_001_normalizer_from_valid_values_never_drops_degenerate_entries` (`src/cli/field.rs::tests`) — PASS |
| AC-010 | Cascading `children[]` — M1/M2 and M3 wire shapes normalize identically | Recordings: `AC-013-table-cascading-degenerate.{gif,webm}` (indented `Silver Plus` under `Silver`) and `AC-013-json-array-shape.{gif,webm}` (nested `children[]` array). Tests: `test_bc_x_14_001_cascading_children_round_trip_m3` (`src/cli/field.rs::tests`), `test_bc_x_14_001_non_cascading_m3_entry_has_empty_children` — PASS |
| AC-011 | `<field>` resolution: `customfield_NNNNN` bypass + `fields.json` cache-first + `partial_match` disambiguation | Recording: `AC-011-empty-field-name.{gif,webm}` (empty-name guard) — plus every mocked recording uses the `customfield_10084`/`customfield_20000` literal bypass (zero `list_fields()` HTTP call, confirmed by the mock server exposing no `GET /field` route at all). Tests: `test_bc_x_14_001_customfield_bypass_skips_list_fields`, `test_bc_x_14_001_field_name_ambiguous_exits_64`, `test_bc_x_14_001_field_name_human_name_resolves_via_partial_match`, `test_bc_x_14_001_empty_field_name_exits_64_zero_http` (`tests/field_options.rs`) — PASS |
| AC-012 | `--value <substring>` client-side filter correctness | Recording: `AC-012-value-filter-narrowing.{gif,webm}` (case-insensitive substring match, self-matching parent retains all children unfiltered). Tests: `test_bc_x_14_002_value_narrows_json_output_against_nonempty_enumeration`, `test_bc_x_14_002_value_empty_string_identical_to_value_absent`, `test_bc_x_14_002_value_with_graceful_degrade_still_hints` (`tests/field_options.rs`) — PASS |
| AC-013 | Output shape — table (ID/Label, cascading indent) / `--output json`; degenerate-entry rendering | Recordings: `AC-013-table-cascading-degenerate.{gif,webm}`, `AC-013-json-array-shape.{gif,webm}`. Tests: `test_bc_x_14_003_table_two_columns_cascading_indent`, `test_bc_x_14_003_json_array_shape_render_json_invariant`, `test_bc_x_14_003_degenerate_entry_table_glyphs`, `test_bc_x_14_003_degenerate_entry_json_emits_null_not_glyph`, `test_bc_x_14_003_zero_stderr_on_ordinary_enumeration_success` (`tests/field_options.rs`) — PASS |
| AC-014 | Error taxonomy + graceful degradation | Recordings: `AC-002-zero-mode-selectors.{gif,webm}`, `AC-003-multiple-mode-selectors.{gif,webm}`, `AC-011-empty-field-name.{gif,webm}` (taxonomy rows) and `AC-014-graceful-degrade.{gif,webm}` (free-text-field graceful degrade — exit 0, stderr hint, empty stdout). Remaining taxonomy rows (project 404, unknown `--type`, field-absent-from-context, Assets/CMDB degrade, user-picker degrade, JSON-mode degrade, M3 Assets empty-`validValues`) are exercised by the full table-driven suite: `test_bc_x_14_004_each_taxonomy_row_exit_64_zero_http`, `test_bc_x_14_004_project_404_exits_64_message`, `test_bc_x_14_004_graceful_degrade_assets_field`, `test_bc_x_14_004_graceful_degrade_userpicker_field`, `test_bc_x_14_004_graceful_degrade_array_typed_cmdb_field`, `test_bc_x_14_004_graceful_degrade_labels_field`, `test_bc_x_14_004_graceful_degrade_group_picker_classified_by_autocompleteurl`, `test_bc_x_14_004_graceful_degrade_approvers_field`, `test_bc_x_14_004_graceful_degrade_freetext_field`, `test_bc_x_14_004_graceful_degrade_json_mode_empty_array_stderr_hint`, `test_bc_x_14_004_m3_assets_empty_validvalues_is_degrade_not_misconfig`, `test_bc_x_14_004_field_absent_from_createmeta_context_exits_64`, `test_bc_x_14_004_field_absent_from_request_type_context_exits_64`, `test_bc_x_14_004_field_absent_from_editmeta_context_exits_64` (all `tests/field_options.rs`) — PASS |

## Test run confirmation

```
$ cargo build
   Compiling jr v0.7.0-dev.2 (.../jira-cli/.worktrees/S-580-1)
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 2.73s

$ cargo test --test field_options
running 50 tests
test result: ok. 50 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.80s
```

## Manual server-free verification (pre-recording sanity check)

```
$ jr field options FOO --no-input
Error: You must specify exactly one of --type, --request-type, --issue.
EXIT=64

$ jr field options FOO --type X --issue Y --no-input
Error: You must specify exactly one of --type, --request-type, --issue.
EXIT=64

$ jr field options "" --issue FOO-1 --no-input
Error: Field '' not found. The field name must not be empty.
EXIT=64
```

## Coverage confirmation

All 14 story ACs have at least one evidence reference (a recorded demo, a named passing
test, or both). No AC is left without evidence. 50/50 tests in `tests/field_options.rs`
pass; `cargo build` succeeds cleanly.
