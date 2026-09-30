## Fresh-eyes review — PR #888 (closes #861)

**Checks I ran**
1. **Presence-based:** confirmed. `v.value.clone().or_else(|| v.name.clone())` falls through only on `None`. `test_bc_x_14_001_normalize_from_allowed_values_label_fallback_presence_based_ec12` deserializes real JSON and asserts that `"value": ""` resolves to `Some("")` and `"value": null` resolves to `name`. It checks both at the top level and at the child level. An emptiness-based mutant (`.filter(|s| !s.is_empty())`) would fail this test.
2. **Recursive:** confirmed. The fallback sits in the shared depth-tracked worker. `..._cascading_child_matrix` and the recursive `AllowedValue` proptest (depth ≤ 3, `label == value.or(name)` at every node) both prove it applies to children.
3. **Never-drop:** confirmed. The `neither` cell asserts `label: None` and an unchanged entry count, at the top level and at the child level.
4. **M3 untouched:** confirmed. The diff has no change to `normalize_from_valid_values*`. `..._m3_regression_no_name_fallback` is a hand-written expected-output guard.
5. **Write side untouched:** confirmed. `src/cli/issue/field_resolve.rs` is not in `git diff --stat origin/develop...HEAD`. `find_option_match` and `resolve_option_value` still match or echo `value` only.
6. **Doc comments:** accurate. `resolve_field_id` goes through `search_field_list` (exact match, then substring). `partial_match` is only used for `--request-type` resolution (`resolve_request_type_id`). The symbols named in the `editmeta.rs` rustdoc exist.
7. **CHANGELOG:** accurately limited to M1/M2 and read-side only. The `--` dash style matches the surrounding entries.
8. **Rename:** accurate. The fixture `["Story Points", "Sprint"]` with query `"Story Points"` hits `search_field_list`'s single-exact-match branch.
9. **Null mix at child level:** covered by the child cells in the EC-12 test and by the proptest, which generates `None`, `Some("")` and non-empty values at every depth.

Local runs: `cargo test --lib cli::field` passed 50/50, and `cargo test --test field_options` passed 51/51.

**Findings**
1. **NON-BLOCKING:** All new coverage is at the unit level. No wiremock test checks what the user sees from #861, which is the table not showing `(unnamed)` and JSON `label` not being `null` for a field whose options carry only `name`. *Fix:* add one `tests/field_options.rs` case per mode (M1 `--issue` and M2 `--type`) with a priority-shaped `allowedValues` fixture (`{"id":"1","name":"Highest"}`), asserting the table cell and the JSON `label`.
2. **NITPICK:** The doc comment on `test_bc_x_14_001_normalize_from_valid_values_m3_regression_no_name_fallback` ends by repeating itself ("M3 ... reads the label only from `.label` and never consults `name`" restates the first sentence). *Fix:* delete the last sentence.
3. **NITPICK (pre-existing, out of diff):** The "KNOWN GAP" rustdoc on `test_bc_x_14_001_cascading_children_round_trip_m1_m2` still says `AllowedValue` has no `children` field. It has had one since S-580-1. This PR fixes other stale docs, so it could fix this one too. *Fix:* replace it with a one-line note that `children` exists (ADR-0019 §D4), or open a follow-up.

**APPROVE: 0 blocking findings**
