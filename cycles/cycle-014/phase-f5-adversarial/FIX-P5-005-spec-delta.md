# FIX-P5-005 spec delta (cycle-014 F5 pass 4) — implementer hand-off

Human decision D-399 (state-manager records). Spec version 2.7.0. Spec-only: nothing here is implemented.
Spec sources: `.factory/specs/prd/bc-7-output-render.md` (BC-7.1.006 v1.6.0, EC-21/22/23, VP-SEC-001-003) and
`.factory/specs/prd/cross-cutting.md` (BC-X.14.001 / BC-X.14.004, EC-X.14.001-16..20, EC-X.14.004-8, VP-580-014).

## Part 1 — `classify_default_char` category rule (`src/output.rs`)

Pinned Unicode version: **17.0.0** (`char::UNICODE_VERSION == (17, 0, 0)` on rustc 1.98.1).
Source: https://www.unicode.org/Public/17.0.0/ucd/UnicodeData.txt, cross-checked (machine-compared, identical)
against https://www.unicode.org/Public/17.0.0/ucd/extracted/DerivedGeneralCategory.txt (2025-07-24).
170 `Cf` code points, 21 ranges.

### DROP set (all three sanitizers share it; `\n`/`\r`/`\t` still handled per-function before this default)

Unchanged explicit sets: `<= 0x1F`, `0x7F`, `0x80..=0x9F`, `0x202A..=0x202E`, `0x2066..=0x2069`, `0x2028`, `0x2029`, `0x0085`.
(The bidi arms overlap the Cf table; keep them.)

New: every Cf range (table below), plus CGJ, plus Hangul fillers, plus the tag block as a whole.

Copy-pasteable `Cf` table (sorted, non-overlapping):

```rust
/// Unicode 17.0.0 General_Category=Cf, inclusive ranges, sorted & non-overlapping.
const CF_RANGES: &[(u32, u32)] = &[
    (0x00AD, 0x00AD),
    (0x0600, 0x0605),
    (0x061C, 0x061C),
    (0x06DD, 0x06DD),
    (0x070F, 0x070F),
    (0x0890, 0x0891),
    (0x08E2, 0x08E2),
    (0x180E, 0x180E),
    (0x200B, 0x200F),
    (0x202A, 0x202E),
    (0x2060, 0x2064),
    (0x2066, 0x206F),
    (0xFEFF, 0xFEFF),
    (0xFFF9, 0xFFFB),
    (0x110BD, 0x110BD),
    (0x110CD, 0x110CD),
    (0x13430, 0x1343F),
    (0x1BCA0, 0x1BCA3),
    (0x1D173, 0x1D17A),
    (0xE0001, 0xE0001),
    (0xE0020, 0xE007F),
];
```

As `match`/`contains` arms (merge into `classify_default_char`'s `||` chain, or a `matches!(code, ...)`):

```rust
0x00AD
| 0x0600..=0x0605
| 0x061C
| 0x06DD
| 0x070F
| 0x0890..=0x0891
| 0x08E2
| 0x180E
| 0x200B..=0x200F
| 0x202A..=0x202E
| 0x2060..=0x2064
| 0x2066..=0x206F
| 0xFEFF
| 0xFFF9..=0xFFFB
| 0x110BD
| 0x110CD
| 0x13430..=0x1343F
| 0x1BCA0..=0x1BCA3
| 0x1D173..=0x1D17A
| 0xE0001
| 0xE0020..=0xE007F
```

Extras (non-Cf, still DROP):

```rust
| 0x034F                                   // COMBINING GRAPHEME JOINER (Mn)
| 0x115F | 0x1160 | 0x3164 | 0xFFA0          // Hangul fillers (Lo, render blank)
| 0xE0000..=0xE007F                         // tag block as a WHOLE (superset: E0000 and E0002..=E001F are Cn)
```

Implementation note: `0x2066..=0x206F` supersedes the old `0x2066..=0x2069` arm for the isolates; keep the old
explicit arm or fold it, either is fine. `0xE0000..=0xE007F` subsumes the table's tag rows; the table stays
pure-Cf for the conformance test.

### KEEP list (deliberate; do NOT strip)

- Variation selectors `U+FE00..=U+FE0F` and `U+E0100..=U+E01EF` (Mn) — accepted risk, EC-23 (emoji VS16; smuggling residual).
- Also KEPT as a consequence: Mongolian FVS `U+180B..=U+180D`, `U+180F` (Mn).
- Everything not in the DROP set (ASCII printable, letters, emoji, `U+200A`, `U+205F`, `U+202F`, ...).

### Boundary pins (all KEEP unless marked) — category in brackets

Cf-range neighbors, KEEP: `U+00AC`[Sm] `U+00AE`[So] `U+05FF`[Cn] `U+0606`[Sm] `U+061B`[Po] `U+061D`[Po] `U+06DC`[Mn]
`U+06DE`[So] `U+070E`[Cn] `U+0710`[Lo] `U+088F`[Lo] `U+0892`[Cn] `U+08E1`[Mn] `U+08E3`[Mn] `U+180D`[Mn] `U+180F`[Mn]
`U+200A`[Zs] `U+2010`[Pd] `U+202F`[Zs] `U+205F`[Zs] `U+2065`[Cn] `U+2070`[No] `U+FEFE`[Cn] `U+FF00`[Cn] `U+FFF8`[Cn]
`U+FFFC`[So] `U+110BC`[Po] `U+110BE`[Po] `U+110CC`[Cn] `U+110CE`[Cn] `U+1342F`[Lo] `U+13440`[Mn] `U+1BC9F`[Po]
`U+1BCA4`[Cn] `U+1D172`[Mc] `U+1D17B`[Mn] `U+E0080`[Cn] `U+1F600`[So].
Filler/CGJ neighbors, KEEP: `U+034E` `U+0350` `U+115E` `U+1161` `U+3163` `U+3165` `U+FF9F` `U+FFA1`.
Variation-selector pins, KEEP: `U+FE00` `U+FE0F` `U+E0100` `U+E01EF` (and `U+FE10`[Po], `U+FDFF`[So]).
DROP pins: every range endpoint in the table; `U+034F`, `U+115F`, `U+1160`, `U+3164`, `U+FFA0`; `U+E0000`, `U+E007F`.

Accepted trade-off to document in rustdoc: visible-ish prepended Cf marks (`U+0600..=U+0605`, `U+06DD`,
`U+0890..=U+0891`, `U+08E2`, `U+110BD`, `U+110CD`) and `U+00AD` are stripped. JSON output stays raw.

### Target tests (VP-SEC-001-003, all in `src/output.rs`; none exist yet)

- `prop_bc_7_1_006_classify_default_char_matches_spec_cf_table` — property: `Drop` iff in table ∪ explicit sets ∪ `{034F,115F,1160,3164,FFA0}` ∪ `E0000..=E007F`; embed `CF_RANGES` verbatim.
- `test_bc_7_1_006_cf_range_table_is_sorted_and_non_overlapping` — sorted, `start <= end`, strictly non-touching, within `0..=0x10FFFF`, no surrogates.
- `test_bc_7_1_006_sanitize_strips_all_cf_format_characters` (EC-21 positives, three sanitizers)
- `test_bc_7_1_006_sanitize_cf_range_neighbors_kept` (EC-21 neighbors, table-driven)
- `test_bc_7_1_006_sanitize_strips_cgj_and_hangul_fillers` (EC-22)
- `test_bc_7_1_006_sanitize_keeps_variation_selectors` (EC-23)
- `test_bc_7_1_006_sanitize_terminal_line_cf_identity_collapse`
- `test_bc_7_1_006_cf_table_pinned_unicode_version_is_17` — `assert_eq!(char::UNICODE_VERSION, (17, 0, 0))`.

Also update `classify_default_char`'s rustdoc to state the category rule, the pin and the KEEP decision; keep the
`.cargo/mutants.toml` `examine_globs` coverage; add/refresh spec citations.

## Part 2 — `jr field options <NAME>` accepts system field IDs (`src/cli/field.rs`, #861 / CR4-002)

Resolution order in `resolve_field_id` / `search_field_list`:

1. `customfield_NNNNN` literal (case-sensitive) -> return as-is, zero HTTP (unchanged).
2. Empty string -> exit 64 `Field '' not found. The field name must not be empty.` (unchanged).
3. Over the cache-first `(id, name)` list (same `fields.json`, same `list_fields()` fallback; no new HTTP, no new cache):
   a. NEW: entries whose `id` equals `<field>` ASCII-case-insensitively. Exactly one -> return THAT entry's id
      (list casing; `IssueType` -> `issuetype`). More than one (defensive) -> exit 64 ambiguous, candidates `<name> (<id>)`.
   b. Otherwise the existing name algorithm, unchanged: exact case-insensitive name (1 -> resolve, >1 -> exit 64),
      then substring (1 -> resolve, >1 -> exit 64), else `Ok(None)`.
4. `Ok(None)` from a warm cache -> one `list_fields()`, rewrite cache, search again (3a then 3b). An ID match or ambiguity
   found within the warm cache never refetches (unchanged refresh contract).

Rules: ID match is exact only (no substring on IDs). **Collision: the ID match WINS**, silently and
deterministically (e.g. `priority` -> system `priority` even if `customfield_10050` is named "priority"; the custom
field stays reachable via its `customfield_` id). Resolution only locates the id; whether it is enumerable in the
M1/M2/M3 context is governed by the existing BC-X.14.001/004 logic (graceful degrade unchanged).

Ambiguity hints (both branches) must contain the literal `the field ID (e.g. customfield_NNNNN or a system id like issuetype)`:
- exact: `Field name '{query}' matches multiple fields: {candidates}. Use the field ID (e.g. customfield_NNNNN or a system id like issuetype) to disambiguate.`
- substring: `Field name '{query}' is ambiguous — matches: {candidates}. Use a more specific name or the field ID (e.g. customfield_NNNNN or a system id like issuetype).`

The zero-match hint (`jr project fields --output json`, drift FIELD-OPTIONS-NOTFOUND-HINT) is OUT of scope; do not change it.
Also check the `jr field options` help text / README wording stays accurate ("custom or system fields").

Target tests (none exist yet): `src/cli/field.rs::prop_bc_x_14_001_search_field_list_id_match_precedes_name_match`;
`tests/field_options.rs::` `test_bc_x_14_001_system_field_id_issuetype_resolves_via_id_match`,
`test_bc_x_14_001_system_field_id_match_is_case_insensitive_and_returns_canonical_id`,
`test_bc_x_14_001_field_id_match_wins_over_name_collision`, `test_bc_x_14_001_field_id_match_is_exact_not_substring`,
`test_bc_x_14_001_field_id_match_warm_cache_zero_http`, `test_bc_x_14_001_field_id_absent_from_cache_refetches_once`,
`test_bc_x_14_004_ambiguous_field_name_hint_names_system_id_form`. Existing VP-580-001 (literal bypass, zero HTTP) must still pass.

---

## Post-merge (spec v2.7.1, 2026-10-01) — PR #897 merged to `develop` as `0a4dc062`

Mechanical citation conversion; no human decision required except where noted.

- **BC-7.1.006 v1.6.1:** all "NOT YET IMPLEMENTED / target" qualifiers converted to live citations
  (`src/output.rs::CF_RANGES`, `::classify_default_char`, `::is_cf`; tests for EC-21/22/23 and
  VP-SEC-001-003 verified present at `0a4dc062`). EC-17's stale FIX-P5-002 "targets, not yet present"
  wording converted too (merged `cc19c2f9`).
- **Target removed:** `test_bc_7_1_006_cf_table_pinned_unicode_version_is_17` (Part 1 target-test list,
  item (e)) was deliberately NOT implemented (orchestrator decision, D-399(c)) — it would assert
  `char::UNICODE_VERSION` against the unpinned stable toolchain and fail CI on every Rust Unicode bump.
  Replaced by a written upgrade policy in BC-7.1.006: `CF_RANGES` is pinned to Unicode 17.0.0 and is
  re-derived deliberately when the project chooses to bump; drift is not auto-detected (known,
  accepted gap; see `.factory/cycles/OPEN-STANDING-ITEMS.md`).
- **Shipped-vs-spec deltas recorded in the BC:** the identity-collapse test uses `"Bob Admin"` (not
  `"Alice"`); the sorted-table test additionally asserts `CF_RANGES == SPEC_CF_RANGES`.
- **BC-X.14.001/004:** EC-X.14.001-16..20, EC-X.14.004-8, VP-580-014 converted to live citations in
  `src/cli/field.rs` / `tests/field_options.rs`. Added **EC-X.14.001-21** for the
  duplicate-case-insensitive-field-ID ambiguity branch
  (`src/cli/field.rs::test_bc_x_14_001_search_field_list_duplicate_case_insensitive_ids_is_ambiguous`,
  added in PR #897's review round). Fixture note: the unit exact-not-substring test probes `issue`
  (resolves via NAME substring) and `issuet` (not found); the integration test uses `issuet`.
- Counts unchanged (98/54 bc-7; 162/96 cross-cutting; 773 cumulative). [CORRECTED 2026-10-05, F7C1-001: BC counts stand, but VP count was NOT unchanged: VP-SEC-001-003 raised the VP total 99 -> 100.]

