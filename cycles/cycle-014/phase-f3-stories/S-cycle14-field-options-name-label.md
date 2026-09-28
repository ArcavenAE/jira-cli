---
document_type: story
level: ops
story_id: "S-cycle14-field-options-name-label"
epic_id: "ISSUE-TRIAGE-QUICKFIXES-1"
title: "jr field options: system-field label resolution falls back to name (read-side only)"
wave: 3
status: draft
intent: bug-fix
feature_type: correctness
mode: feature
scope: standard
severity: LOW
trivial_scope: false
producer: story-writer
timestamp: "2026-09-26T00:00:00"
phase: 3
inputs:
  - ".factory/cycles/cycle-014/phase-f2-spec-evolution/prd-delta.md"
  - ".factory/cycles/cycle-014/phase-f2-spec-evolution/verification-delta.md"
  - ".factory/specs/prd/cross-cutting.md"
  - "src/cli/field.rs"
  - "src/cli/mod.rs"
  - "src/types/jira/editmeta.rs"
  - "src/api/jira/issues.rs"
  - "tests/field_options.rs"
  - "README.md"
  - "CLAUDE.md"
input-hash: "1b0b27d"
traces_to: "BC-X.14.001, BC-X.14.003"
cycle: cycle-014-issue-triage-quickfixes
estimated_effort: small
estimated_days: 2
target_module: "src/cli/field.rs"
subsystems: ["SS-02"]
# SS-02 (CLI Layer, src/cli/) owns this story's scope because its sole
# behavior-changing edit (normalize_from_allowed_values_at_depth) lives in
# src/cli/field.rs per ARCH-INDEX's Subsystem Registry (SS-02 row: "CLI
# Layer | src/cli/"). The src/types/jira/editmeta.rs doc-comment fix and the
# src/api/jira/issues.rs doc-comment fix are documentation-only companion
# edits in the same subsystem's data-model and API layers, not a second
# subsystem's functional concern.
depends_on: ["S-cycle14-api-query-param"]
blocks: []
# Depends on S-cycle14-api-query-param because all three cycle-014 stories
# touch src/cli/mod.rs and README.md (this story's own touches: the
# FieldCommand::Options about-text/help-text at ~L128/~L1224/~L1231-1232,
# and the README.md field-options row at ~L346 -- different lines from
# STORY-A's and STORY-C's own edits to those same two files, but the human
# decision at F2 review (D-381, cycle-manifest.md) fixed the delivery order
# to the single chain A -> C -> B specifically because of this three-way
# file overlap, to keep rebases linear rather than requiring a 3-way merge
# reconciliation. No functional/content dependency exists between this
# story's read-side label-resolution fix and STORY-C's query-param feature
# -- the edge exists solely to honor the human-decided serial order.
behavioral_contracts:
  - BC-X.14.001
  - BC-X.14.003
bcs:
  - BC-X.14.001
  - BC-X.14.003
verification_properties:
  - VP-580-013
holdout_anchors: ["H-CYCLE14-W3-INT-001", "H-CYCLE14-W3-INT-002", "H-CYCLE14-W3-INT-003", "H-CYCLE14-W3-REG-001", "H-CYCLE14-W3-REG-002", "H-CYCLE14-W3-REG-003"]
nfr_anchors: []
adr_refs: []
sd_refs: []
priority: P3
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-014/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: strict
module_criticality: "N/A -- no .factory/specs/module-criticality.md exists in this repo"
points: 5
acceptance_criteria_count: 9
assumption_validations: []
risk_mitigations: []
created: "2026-09-26"
version: "1.2"
last_updated: "2026-09-27"
breaking_change: false
retroactive: false
origin: >
  cycle-014 issue-triage-quickfixes (GitHub issue #861), Wave 3 of 3, third
  and final story in the human-decided SERIAL delivery order A -> C -> B
  (D-381, 2026-09-25 F2 review), rebased on STORY-C. READ-SIDE ONLY per the
  F1 human gate (D-378, 2026-09-24): the originally-proposed WRITE-side
  companion fix (find_option_match/resolve_option_value name-fallback in
  src/cli/issue/field_resolve.rs) was REMOVED from scope after a
  fresh-context audit REFUTED its reachability -- system-typed fields never
  reach that code path (schema.field_type is priority/resolution/issuetype/
  securitylevel, never "option"). That capability gap is tracked separately
  as drift item FIELD-SYSTEM-TYPES-UNSUPPORTED, out of scope here.
---

> **tdd_mode:** `strict` -- this story changes one line of real logic
> (`label: v.value.clone()` -> a presence-based `value.or(name)` fallback)
> plus a wide doc-accuracy sweep; the logic change is non-trivial enough
> (presence vs. emptiness semantics, EC-X.14.001-12) to warrant the full
> Iron Law rather than a facade waiver.

> **Execute:** `/vsdd-factory:deliver-story S-cycle14-field-options-name-label`

# S-cycle14-field-options-name-label -- `jr field options` system-field label fallback (#861, read-side only)

## Revision Note (F3 adversarial pass-3 fix, ADV-C14-F3-P3-004b, LOW)

VP-580-013(3) requires that the emitted node's key set be exactly `{"id","label","children"}`
**with `label` a JSON string or `null`**. AC-001's Test line cited the key-set clause only and
omitted the type assertion. Fixed by appending "with `label` a JSON string or `null`" (the VP's
exact wording) to AC-001's `(3)` citation. The other VP-580-013 sub-cells -- (1) the example
matrix (AC-001, AC-002), (2) the recursive proptest (AC-001), (4) the M3 regression fixture
(AC-004), and (5) the `--value`-filter downstream example (AC-003) -- were checked against
their respective AC Test lines and are already carried verbatim; no further omission of this
kind was found.

## Revision Note (F3 adversarial pass-4 fix, ADV-C14-F3-P4-001, MEDIUM; ADV-C14-F3-P4-009, LOW)

**ADV-C14-F3-P4-001 (Red Gate density below the 0.5 floor):** as originally enumerated in Tasks
1-5, this story's five new VP-580-013 test items split into 5 RED cells (name-only x2 levels,
`value: null`, the proptest, the `--value high` filter) against 9 pre-existing-behavior GREEN
cells counted per-cell (value-only/both/neither x2 levels, `value: ""`, the serde key set, M3) --
below 0.5 by the playbook's own counting unit (per-story-delivery.md's `RED_RATIO = RED_TESTS /
(TOTAL_NEW_TESTS - EXEMPT_TESTS)`, Red Gate Density Check). There is no stub for
`normalize_from_allowed_values_at_depth` (Task 6 already notes "No stub needed" -- the fn already
exists), so Option A (roll back the stub, re-dispatch stub-architect) does not apply, and Option B
(accept + `mutation_testing_required: true` + PR disclosure) was never pre-authorized in this
story's frontmatter. Fixed by pinning the COUNTING UNIT at the `#[test]` FUNCTION level (per the
playbook's own `RED_TESTS` = count of new test *functions* that fail, not cells) and restructuring
Task 1 into three functions, each bundling its RED cell together with its GREEN sibling
combinations so the whole function is RED pre-fix (a single failing `assert_eq!` fails the entire
function under `cargo test`, regardless of assertion order):

- **1a** -- top-level matrix (value-only, name-only, both, neither; EC-X.14.001-8..11) in ONE fn -- RED (name-only cell fails pre-fix)
- **1b** -- cascading-child-level matrix (same four combinations at depth >= 1) in ONE fn -- RED (name-only cell fails pre-fix)
- **1c** -- both EC-X.14.001-12 cells (`"value": ""` wins over `name`; `"value": null` falls through to `name`) in ONE fn -- RED (the null-falls-through cell fails pre-fix; the `""` cell is pre-existing-correct)

Combined with the pre-existing Tasks 2/3/4/5 (recursive proptest, serde key-set property, M3
regression, `--value`-filter), this story now introduces exactly **7** new test functions, each
classified against the playbook's `rationale_category` taxonomy (per-story-delivery.md's Red Gate
Log Format table):

| # | Test function | Result | `rationale_category` | Formula treatment |
|---|----------------|--------|-----------------------|--------------------|
| 1a | top-level matrix (AC-001, AC-002) | RED | -- (fails, not logged as unexpectedly-GREEN) | counts in denominator, counts as RED |
| 1b | cascading-child-level matrix (AC-001) | RED | -- | counts in denominator, counts as RED |
| 1c | EC-X.14.001-12 both cells (AC-002) | RED | -- | counts in denominator, counts as RED |
| 2 | recursive `AllowedValue` proptest (AC-001) | RED | -- | counts in denominator, counts as RED |
| 3 | serde key-set property (AC-001 cell 3) | GREEN | `FRAMEWORK-WIRING` -- asserts the FIXED `{"id","label","children"}` wire shape from `FieldOption`'s `#[derive(Serialize)]`, unchanged by this story's fallback logic; verifies type/wire structure, not the business rule under test | **WIRING-EXEMPT** -- excluded from `EXEMPT_TESTS` denominator subtraction |
| 4 | M3 regression fixture (AC-004) | GREEN | `PRE-EXISTING-BEHAVIOR` -- `normalize_from_valid_values` is untouched by this story (Architecture Compliance Rules row 2); this fn proves the fallback does NOT leak into it, which is a real (if unchanged) behavioral assertion, not a type-level tautology | justified, non-blocking, but **NOT exempt** -- remains in the denominator as a non-RED test |
| 5 | `--value` filter system-field cell (AC-003) | RED | -- | counts in denominator, counts as RED |

**Explicit tally:** `TOTAL_NEW_TESTS = 7`. `EXEMPT_TESTS = 1` (test 3, `FRAMEWORK-WIRING` ->
WIRING-EXEMPT). Denominator = `7 - 1 = 6`. `RED_TESTS = 5` (1a, 1b, 1c, 2, 5). `RED_RATIO = 5 / 6
~= 0.833 >= 0.5` -- integer-precise check `RED_TESTS * 2 >= (TOTAL_NEW_TESTS - EXEMPT_TESTS)` ->
`10 >= 6` TRUE. **The Red Gate Density Check PASSES honestly on this restructured tally.** Test 4
(M3 regression) is the only non-exempt GREEN in the denominator, and it is a single, individually
justified `PRE-EXISTING-BEHAVIOR` entry (not `UNJUSTIFIED`), so it does not block Step 4 dispatch
on its own even before the ratio arithmetic above is applied.

**Route taken:** neither Option A nor Option B. The formula reaches >= 0.5 honestly once the
counting unit is pinned at the function level per Tasks 1a/1b/1c above, so no stub rollback and no
`mutation_testing_required: true` pre-authorization is needed. `mutation_testing_required` is
therefore deliberately NOT added to this story's frontmatter (no sibling story in
`phase-f3-stories/` sets that field either, per a repo-wide grep). See the revised Task 1 (split
into 1a/1b/1c) and Task 6 (density-check confirmation referencing this exact tally) below, and the
revised AC-001/AC-002 Test lines that now name the three functions explicitly.

**ADV-C14-F3-P4-009 (`holdout_anchors` omitted 4 of 6 Wave-3 scenario IDs):** the frontmatter
`holdout_anchors` field listed only `H-CYCLE14-W3-INT-001` and `H-CYCLE14-W3-REG-001`, omitting
`H-CYCLE14-W3-INT-002`, `H-CYCLE14-W3-INT-003`, `H-CYCLE14-W3-REG-002`, and `H-CYCLE14-W3-REG-003`
-- the full set of six Wave-3 scenario IDs enumerated in
`.factory/cycles/cycle-014/phase-f3-stories/wave-holdout-scenarios.md` (`H-CYCLE14-W3-*`, as
opposed to the Wave-1/Wave-2/`H-CYCLE14-REG-FULL` scenarios, which are out of scope for this
story). Fixed by setting `holdout_anchors` to the complete six-ID Wave-3 set in frontmatter above.
This is an anchor-list correction only; no scenario body was edited (per the concurrent-edit note
on `H-CYCLE14-W3-INT-003`, its body is untouched here).

## Narrative

- **As a** `jr field options <field>` user enumerating a system field's allowed values (e.g. `priority`, `components`, `versions`, `issuetype`)
- **I want to** see the field's real display name instead of `"(unnamed)"` (table) / `null` (JSON)
- **So that** `jr field options` is usable for system-typed fields, not just custom select fields, without changing the rendering contract for genuinely-nameless entries

## Behavioral Contracts

| BC | Role | Clauses this story implements |
|----|------|-------------------------------|
| BC-X.14.001 | PRIMARY (amended, cycle-014 F2) | The `value`-else-`name` presence-based label-resolution fallback (Behavior), the "Scope boundary -- READ-SIDE ONLY" paragraph, the "M3 is UNCHANGED and ALREADY CORRECT" paragraph, Edge Cases EC-X.14.001-8..13 |
| BC-X.14.003 | CROSS-REF (amended, cycle-014 F2, COUNT-NEUTRAL) | The UPDATED blockquote clarifying the rendering contract (`(unnamed)`/`null` for `None`) is unchanged -- only the upstream normalizer produces fewer `None` labels |

**Anchor justification:** BC-X.14.001 is the sole BC governing `jr field options`'s M1/M2 label-resolution normalizer (`cross-cutting.md`). BC-X.14.003 is cited as a cross-reference only because this story's fix changes what feeds INTO its rendering contract, not the contract itself (AC-005 traces to it to make that boundary explicit and count-neutral).

## Acceptance Criteria

### AC-001 (traces to BC-X.14.001 Behavior -- M1/M2 label-resolution fallback, EC-X.14.001-8..11)
`src/cli/field.rs::normalize_from_allowed_values_at_depth` sets `label = v.value.clone().or_else(|| v.name.clone())` (presence-based, not emptiness-based) at every depth of the cascading-option tree, for the four combinations {value-only, name-only, both, neither} at both the top level and at least one cascading child level.
**Test:** VP-580-013's top-level example-matrix test (Task 1a: value-only, name-only, both, neither, all four cells in ONE `#[test]` fn) (1a); VP-580-013's cascading-child-level example-matrix test (Task 1b: the same four combinations at depth >= 1, in a second, separate `#[test]` fn) (1b); VP-580-013's recursive `proptest!` over a depth-<=3 `AllowedValue` strategy asserting `label == value.clone().or(name.clone())` at every node, `id` carried through unchanged, and the emitted tree the same shape (node count, child order) as the input up to the existing `MAX_FIELD_OPTION_DEPTH` cap (2); VP-580-013's companion serde key-set property asserting every emitted node's JSON key set is exactly `{"id","label","children"}`, with `label` a JSON string or `null` (3) -- see the Revision Note's Red Gate density tally (ADV-C14-F3-P4-001) for why (1) is split into 1a/1b as two functions rather than one.

### AC-002 (traces to BC-X.14.001 EC-X.14.001-12)
A wire `"value": ""` (present-but-empty string) wins over a populated `name` -- `label: Some(String::new())`, never falling through to `name` merely because the value string is empty. A wire `"value": null` deserializes to `AllowedValue.value: None`, which DOES fall through to `name`.
**Test:** VP-580-013's Task 1c function -- both the JSON-deserialized `"value": ""` and `"value": null` cells asserted in ONE `#[test]` fn (1c) -- see the Revision Note's Red Gate density tally (ADV-C14-F3-P4-001).

### AC-003 (traces to BC-X.14.001 EC-X.14.001-13)
`jr field options --value <substring>` (BC-X.14.002, its own contract unchanged) now also matches system-field option names via the fallback label, as a downstream consequence of AC-001 -- not a new filter rule.
**Test:** VP-580-013(5), a `priority`-shaped fixture (`[{"id":"1","name":"Highest"},{"id":"2","name":"High"},{"id":"3","name":"Low"}]`, no `value`) normalized via `normalize_from_allowed_values` then run through `src/cli/field.rs::filter_options`: `filter_options(&opts, Some("high"))` returns exactly the `Highest` and `High` entries (matched through their fallback `label`s); `filter_options(&opts, Some("3"))` returns exactly the `Low` entry (matched through its `id`).

### AC-004 (traces to BC-X.14.001 "M3 is UNCHANGED and ALREADY CORRECT" paragraph)
`src/cli/field.rs::normalize_from_valid_values` (M3, JSM requesttype-fields) is NOT modified by this story and does NOT acquire a `name`-fallback of its own -- it already reads `.value` for id and `.label` for display, which was already correct before this story.
**Test:** VP-580-013(4), an M3 regression against a hand-written expected output over three fixture entries: `{"value":"10","name":"N"}` (no `label`) -> `{id: Some("10"), label: None, children: []}` (proves the fallback does not leak into M3 -- a leak would turn this `label` into `Some("N")`); `{"value":"11","label":"L","name":"N"}` -> `{id: Some("11"), label: Some("L"), children: []}`; `{"value":"12","label":"Twelve"}` -> `{id: Some("12"), label: Some("Twelve"), children: []}`.

### AC-005 (traces to BC-X.14.003 UPDATED blockquote, COUNT-NEUTRAL)
The rendering contract for a `None` label (`"(unnamed)"` in table output, `null` in `--output json`) is byte-for-byte UNCHANGED by this story -- only the upstream normalizer (AC-001) now produces fewer `None` labels for system fields.
**Test:** existing BC-X.14.003 rendering tests pass unmodified (regression guard, no new test needed).

### AC-006 (traces to prd-delta.md F4 stale-wording obligation, PASS-9/13/33, P9-002/P13-002/P33-002)
The following stale "custom field" / "`partial_match`" wording is corrected in the SAME commit as AC-001, since after this fix the command also serves system fields, not custom fields only, and field-name resolution has never actually gone through `partial_match` (a pre-existing, unrelated spec/code drift already corrected at cycle-014 F2 in `cross-cutting.md`, not re-litigated here):
- `src/cli/mod.rs`: the `Command::Field` about-text (~L128, "Discover custom-field allowed options"), the `FieldCommand::Options` about-text (~L1224, "Enumerate a custom field's allowed options"), and the `field` doc comment (~L1231-1232, "resolved via `list_fields()` + `partial_match`")
- `src/cli/field.rs`: the module doc comment (L1, "enumerate a custom field's allowed options") and the `handle` Step 2 comment (~L132, "resolved via the per-profile fields cache / `list_fields()` + `partial_match`")
- `src/api/jira/issues.rs::get_createmeta_fields`'s doc comment (~L1130, "Enumerate a custom field's allowed options...")
- `src/types/jira/editmeta.rs`'s `AllowedValue` struct-level doc comment (~L64-77) and its `name` field-level doc comment (~L83-85), both of which currently describe `name` as "unused in v1 resolution logic" / "Future: v2 cascade-select name matching" -- stale as of this story, since `jr field options`'s M1/M2 label-resolution fallback (AC-001) is now a real, shipped read-side consumer of `name`
- `tests/field_options.rs`'s comments (~L1436 section banner, ~L2050)
- `README.md`'s `jr field options <NAME>` row (~L346)
- `CLAUDE.md`'s `field.rs` file-tree line (~L61)
**Test:** N/A (doc-accuracy); presence checked at PR review. This changes `jr field options --help` output text -- cosmetic, not a behavior change.

### AC-007 (traces to prd-delta.md F4 obligation PASS-8, P8-002)
`tests/field_options.rs::test_bc_x_14_001_field_name_human_name_resolves_via_partial_match` is renamed to a name reflecting `search_field_list` (the actual resolution algorithm -- single exact match auto-resolves; multiple exact -> exit 64; else single substring auto-resolves; multiple substring -> exit 64), and its doc comment is corrected to match.
**Test:** the renamed test itself, run green.

### AC-008 (traces to BC-X.14.001 EC-X.14.001-14, informational -- documented for completeness, no dedicated VP cell)
System-typed field NAME resolution (the step upstream of the label fallback, e.g. resolving the string `"Priority"` to a field id) is pre-existing `search_field_list`/`resolve_field_id` behavior, unaffected by this story's label-resolution fix. No new test is added for this AC; existing `search_field_list` unit tests already cover it as a regression guard.
**Test:** N/A (informational); existing `test_bc_x_14_001_search_field_list_*` unit tests continue passing unmodified.

### AC-009 (traces to BC-X.14.001 EC-X.14.001-15, informational -- documented for completeness, no dedicated VP cell)
The empty-`<field>` guard (`jr field options ""` exits 64 with `Field '' not found. The field name must not be empty.`, zero HTTP calls, zero cache reads) is pre-existing `src/cli/field.rs::resolve_field_id` behavior, unaffected by this story's label-resolution fix. See BC-X.14.004's cross-reference row for the same condition. No new test is added for this AC.
**Test:** N/A (informational); existing `tests/field_options.rs::test_bc_x_14_001_empty_field_name_exits_64_zero_http` continues passing unmodified.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `normalize_from_allowed_values_at_depth` | `src/cli/field.rs` | Pure (no I/O; struct-to-struct transform) |
| `normalize_from_valid_values` (M3, unchanged) | `src/cli/field.rs` | Pure (regression guard only) |
| `filter_options` / `filter_one` | `src/cli/field.rs` | Pure (unchanged contract, new downstream matches) |
| `AllowedValue` doc comments | `src/types/jira/editmeta.rs` | N/A (documentation only) |

Reference: `architecture/module-decomposition.md`, `architecture/dependency-graph.md` (no module-boundary change; F1 confirmed no architecture delta; this story is entirely within `src/cli/field.rs`'s existing pure-core normalizer).

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-X.14.001-8 | System field `allowedValues` entry `{id: "1", name: "Highest"}` with NO `value` (the real-world `priority` shape) | `label` resolves to `Some("Highest")` via the `name` fallback -- the exact #861 defect, now closed |
| EC-X.14.001-9 | An `allowedValues` entry carrying BOTH `value` and `name` populated | `label` = `value` -- `value` WINS (fallback activates only on `value`'s absence; never a "prefer more complete field" rule) |
| EC-X.14.001-10 | An `allowedValues` entry carrying NEITHER `value` NOR `name` | `label: None` (unchanged degenerate behavior; still renders `"(unnamed)"`/`null`) |
| EC-X.14.001-11 | A cascading parent's CHILD entry carrying `name` but no `value` | The same `value`-else-`name` fallback applies recursively -- cascading children are not exempt |
| EC-X.14.001-12 | `{value: Some(""), name: Some(n)}` (presence, not emptiness) | `label: Some("")`, never `Some(n)`; a wire `"value": null` still falls through to `name` |
| EC-X.14.001-13 | `--value` filter against a system field | Matches via the fallback label as a downstream consequence, not a new filter rule |
| EC-X.14.001-14 | System-field NAME resolution (informational) | Pre-existing `search_field_list` behavior, unaffected |
| EC-X.14.001-15 | `<field>` is the empty string (informational, pre-existing, no behavior change) | Exit 64 `Field '' not found. The field name must not be empty.`, zero HTTP/cache reads; see BC-X.14.004's cross-reference row; pinned by `tests/field_options.rs::test_bc_x_14_001_empty_field_name_exits_64_zero_http` |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `normalize_from_allowed_values_at_depth` (`src/cli/field.rs`) | pure-core | No I/O; the sole behavior-changing site in this story |
| `normalize_from_valid_values` (`src/cli/field.rs`) | pure-core | Unchanged; regression-guarded only |
| `filter_options` / `filter_one` (`src/cli/field.rs`) | pure-core | Unchanged contract; new matches are a downstream effect |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~2,800 |
| Referenced code (`src/cli/field.rs` normalizer region + `handle`'s Step 2, `src/types/jira/editmeta.rs::AllowedValue`, `src/api/jira/issues.rs::get_createmeta_fields` doc comment) | ~2,200 |
| Test files (`tests/field_options.rs` -- grep-scoped to the renamed test + the new VP-580-013 cells) | ~1,800 |
| Tool output overhead | ~1,000 |
| **Total** | **~7,800** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~4%** |

## Tasks

1. [ ] Write the example-matrix tests for `normalize_from_allowed_values_at_depth` (AC-001, AC-002) as THREE separate pure unit tests (not one) in `src/cli/field.rs`'s `#[cfg(test)] mod tests`, per the Revision Note's Red Gate density fix (ADV-C14-F3-P4-001) -- each function bundles its RED cell with its GREEN sibling combinations so the whole function is RED pre-fix -- `test-writer`:
   - 1a. [ ] top-level matrix: value-only, name-only, both, neither (EC-X.14.001-8..11), all four cells asserted in ONE `#[test]` fn
   - 1b. [ ] cascading-child-level matrix: the same four combinations at depth >= 1, in a SECOND, separate `#[test]` fn
   - 1c. [ ] both EC-X.14.001-12 cells (`"value": ""` wins over `name`; `"value": null` falls through to `name`) asserted in a THIRD `#[test]` fn
2. [ ] Write the recursive `AllowedValue` `proptest!` strategy (depth <= 3), in `src/cli/field.rs`'s `#[cfg(test)] mod tests` (alongside its existing `proptest!` blocks) -- `test-writer`
3. [ ] Write the serde key-set property test (`{"id","label","children"}` unchanged), in `src/cli/field.rs`'s `#[cfg(test)] mod tests` -- `test-writer`
4. [ ] Write the M3 regression against a hand-written expected output (AC-004), in `src/cli/field.rs`'s `#[cfg(test)] mod tests` -- `test-writer`
5. [ ] Write the `--value` filter system-field cell (AC-003), in `src/cli/field.rs`'s `#[cfg(test)] mod tests` (`filter_one` is a private fn, unreachable from the external `tests/field_options.rs` integration binary) -- `test-writer`
6. [ ] Confirm Red Gate density per the Revision Note's tally (ADV-C14-F3-P4-001): 7 new test functions total (1a, 1b, 1c, 2-proptest, 3-key-set, 4-M3-regression, 5-`--value`-filter). RED = {1a, 1b, 1c, 2, 5} = 5 functions FAIL against current code (each contains at least one behavior-changing cell: name-only top-level, name-only cascading child, the `value: null` cell, the proptest's general case, `--value` system-field name match). GREEN = {3, 4} = 2 functions PASS unchanged before and after: test 3 (serde key-set property) is `FRAMEWORK-WIRING` -> WIRING-EXEMPT, excluded from the denominator; test 4 (M3 regression fixture) is `PRE-EXISTING-BEHAVIOR`, justified but NOT exempt, remains in the denominator as a non-RED test. `TOTAL_NEW_TESTS = 7`, `EXEMPT_TESTS = 1`, denominator `= 6`, `RED_TESTS = 5`, `RED_RATIO = 5/6 ~= 0.833 >= 0.5` -- PASSES honestly; neither Option A (stub rollback) nor Option B (`mutation_testing_required: true` + PR disclosure) is invoked. Record this exact tally in `.factory/cycles/cycle-014/S-cycle14-field-options-name-label/implementation/red-gate-log.md` per per-story-delivery.md's Red Gate Log Format, with test 3's row tagged `rationale_category: FRAMEWORK-WIRING` and test 4's row tagged `rationale_category: PRE-EXISTING-BEHAVIOR`. No stub needed: `normalize_from_allowed_values_at_depth`, `normalize_from_allowed_values`, `normalize_from_valid_values`, `filter_options`, and `filter_one` all already exist in `src/cli/field.rs` -- this story modifies existing logic in place, so no new symbol requires a `todo!()` scaffold.
7. [ ] Change `label: v.value.clone()` to the presence-based `value.or(name)` fallback in `normalize_from_allowed_values_at_depth` (AC-001, AC-002) -- `implementer`
8. [ ] Confirm Green Gate: all tests pass
9. [ ] Rename `tests/field_options.rs::test_bc_x_14_001_field_name_human_name_resolves_via_partial_match` and correct its doc comment (AC-007)
10. [ ] Correct all stale-wording sites listed in AC-006 EXCEPT `src/types/jira/editmeta.rs` (`src/cli/mod.rs` x3, `src/cli/field.rs` x2, `src/api/jira/issues.rs` x1, `tests/field_options.rs` x1 (comments), `README.md`, `CLAUDE.md`) -- see Task 11 for the `src/types/jira/editmeta.rs` edits
11. [ ] Correct `src/types/jira/editmeta.rs`'s two stale `AllowedValue`/`name` doc comments (struct-level `~L64-77`, field-level `~L83-85`) to describe the new read-side consumer (see AC-006) -- this is the sole task covering `src/types/jira/editmeta.rs`; Task 10 excludes it to avoid duplication
12. [ ] Add a CHANGELOG entry under `[Unreleased] > Fixed` describing the shipped behavior, before creating the PR
13. [ ] Run `cargo fmt --all -- --check`, `cargo clippy -- -D warnings`, `cargo test`, then the scoped mutation gate per CLAUDE.md: `DIFF_FILE=$(mktemp -t pr.diff.XXXXXX) && trap 'rm -f "$DIFF_FILE"' EXIT && git diff origin/develop...HEAD > "$DIFF_FILE" && cargo mutants --in-diff "$DIFF_FILE" --jobs 4 --timeout 240`

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|-----------------|--------------------------|------------------------|
| S-cycle14-api-query-param (Wave 2, predecessor in the serial chain) | Rebase-before-PR discipline for a story sharing `src/cli/mod.rs`/README.md with earlier cycle-014 stories | Both stories touch `src/cli/mod.rs` in unrelated code regions -- confirm no merge conflict beyond line-adjacency before opening the PR | This story does NOT touch `.cargo/mutants.toml`/`docs/specs/cargo-mutants-policy.md` (no new function is added -- `normalize_from_allowed_values_at_depth` already exists and is already in `examine_globs` via `src/cli/field.rs`, FIX-F6-MUTANTS-SCOPE) -- do not add a redundant examine_globs entry |
| S-580-1 (delivered, cycle "field-dx" bundle, PR #740) | Original author of `normalize_from_allowed_values`/`_at_depth`, `filter_options`/`filter_one`, and the `FieldOption{id, label, children}` model this story amends | The `value`-only label read this story fixes was S-580-1's own original implementation; VP-580-005..012 already cover the rest of the M1/M2/M3 dispatch this story does not touch | S-580-1's own AC-011/architecture/EC text predates this cycle's BC-X.14.001 corrections (`search_field_list`, mirrored-not-shared with `field_resolve.rs`) -- it is NOT rewritten (delivered historical story); this story's AC-006/AC-007/AC-008 carry the corrected wording forward instead |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| The fallback is READ-SIDE ONLY -- `src/cli/issue/field_resolve.rs::find_option_match`/`resolve_option_value` MUST NOT be touched by this story (write-side, out of scope per D-378) | BC-X.14.001 "Scope boundary -- READ-SIDE ONLY" paragraph | Code review; `src/cli/issue/field_resolve.rs` is not in this story's File Structure Requirements |
| M3 (`normalize_from_valid_values`) MUST NOT acquire a `name`-fallback of its own | BC-X.14.001 "M3 is UNCHANGED and ALREADY CORRECT" paragraph | AC-004's regression test |
| The fallback is presence-based (`Option::is_some`), never emptiness-based (`str::is_empty`) | BC-X.14.001 EC-X.14.001-12 | AC-002 |
| BC-X.14.002's `--value` filter contract itself is NOT modified -- only its INPUT (the label) changes | BC-X.14.002 (unaffected), BC-X.14.001 EC-X.14.001-13 | AC-003; no edit to `filter_options`'s matching logic itself |
| VP-580-013(1)-(5) pure unit/proptest cells MUST live in `src/cli/field.rs`'s `#[cfg(test)] mod tests`, NOT in `tests/field_options.rs` -- `normalize_from_allowed_values_at_depth` and `filter_one` are private fns (and even the `pub(crate)` siblings are unreachable from `tests/field_options.rs`, a separate-crate `assert_cmd` subprocess-driven integration test). NO visibility changes (no `pub`/`pub(crate)` widening) may be made to reach these fns from an external test file. | Finding F3-002; `src/cli/field.rs` L638 (`normalize_from_allowed_values_at_depth`, private), L738 (`filter_one`, private) | Code review; `tests/field_options.rs` is scoped to the rename (AC-007) and comment edits (AC-006) only |

## Library & Framework Requirements

No new dependency is added. No version pins change.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/cli/field.rs` | modify | `normalize_from_allowed_values_at_depth`'s label fallback (AC-001, AC-002); module doc + Step 2 comment correction (AC-006); NEW VP-580-013(1)-(5) pure unit/proptest cells added to its own `#[cfg(test)] mod tests` (AC-001..004) -- see Architecture Compliance Rules |
| `src/types/jira/editmeta.rs` | modify | `AllowedValue` struct-level and `name` field-level doc comments corrected (AC-006; no functional change) |
| `src/api/jira/issues.rs` | modify | `get_createmeta_fields` doc comment correction (AC-006) |
| `src/cli/mod.rs` | modify | `Command::Field`/`FieldCommand::Options` about-text and help-text correction (AC-006) |
| `tests/field_options.rs` | modify | Rename + doc-comment fix (AC-007); comment corrections (AC-006) ONLY -- the VP-580-013 pure unit/proptest cells do NOT go here (see Architecture Compliance Rules) |
| `README.md` | modify | `jr field options <NAME>` row (~L346) wording correction (AC-006) |
| `CLAUDE.md` | modify | `field.rs` file-tree line (~L61) wording correction (AC-006) |
| `CHANGELOG.md` | modify | `[Unreleased] > Fixed` entry |

## Definition of Done

- [ ] All 9 ACs pass their listed tests (or are confirmed informational/doc-only per their own Test note)
- [ ] `cargo fmt --all -- --check` clean
- [ ] `cargo clippy -- -D warnings` clean
- [ ] `cargo test` green (full suite)
- [ ] Scoped `cargo mutants --in-diff` run against the PR diff (`src/cli/field.rs` is already in `examine_globs` per FIX-F6-MUTANTS-SCOPE -- no new entry needed)
- [ ] CHANGELOG entry present under `[Unreleased] > Fixed`
- [ ] Rebased onto STORY-C's merged `develop` tip before opening the PR (serial delivery, D-381)
- [ ] PR opened against `develop`, following commitizen branch/commit conventions

## Suggested Branch Name

`fix/field-options-system-label-fallback` (Conventional Commits, per CLAUDE.md's `type/short-description` convention; this is a bug fix, so `fix/`).
