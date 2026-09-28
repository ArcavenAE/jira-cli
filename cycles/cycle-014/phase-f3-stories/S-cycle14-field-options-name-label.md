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
traces_to: "BC-X.14.001, BC-X.14.003, BC-X.14.004"
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
  - BC-X.14.004
bcs:
  - BC-X.14.001
  - BC-X.14.003
  - BC-X.14.004
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
version: "3.0"
last_updated: "2026-09-28"
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

> **SUPERSEDED IN PART (pass-6, ADV-C14-F3-P6-007):** this section originally classified test 3
> (the serde key-set property) as `rationale_category: FRAMEWORK-WIRING` -> `WIRING-EXEMPT` and
> tallied `EXEMPT_TESTS = 1` / denominator `6` / `RED_RATIO = 5/6 ~= 0.833`. That classification
> contradicted the playbook's own `WIRING-EXEMPT` definition (a test passing "as soon as the
> correct type signature exists in the stub") -- this story has no stub. The classification and
> tally are corrected below (test 3 is now `PRE-EXISTING-BEHAVIOR`, non-exempt, `EXEMPT_TESTS = 0`
> / denominator `7` / `RED_RATIO = 5/7 ~= 0.71`) -- see the pass-6 Revision Note following this
> section for the fix rationale. The table and tally text immediately below reflect the corrected
> values, not the original pass-4 claim.

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
| 3 | serde key-set property (AC-001 cell 3) | GREEN | `PRE-EXISTING-BEHAVIOR` -- asserts the ALREADY-CORRECT `{"id","label","children"}` wire shape from `FieldOption`'s `#[derive(Serialize)]`, which predates this story and is unchanged by the fallback fix; this fn proves the wire shape does not regress as a side effect of the fallback fix, which is a real (if unchanged) behavioral assertion, not a pure type-level tautology (reclassified pass-6, ADV-C14-F3-P6-007; was previously misclassified `FRAMEWORK-WIRING` -- see the superseded marker and pass-6 Revision Note below) | justified, non-blocking, but **NOT exempt** -- remains in the denominator as a non-RED test |
| 4 | M3 regression fixture (AC-004) | GREEN | `PRE-EXISTING-BEHAVIOR` -- `normalize_from_valid_values` is untouched by this story (Architecture Compliance Rules row 2); this fn proves the fallback does NOT leak into it, which is a real (if unchanged) behavioral assertion, not a type-level tautology | justified, non-blocking, but **NOT exempt** -- remains in the denominator as a non-RED test |
| 5 | `--value` filter system-field cell (AC-003) | RED | -- | counts in denominator, counts as RED |

**Explicit tally (corrected pass-6, ADV-C14-F3-P6-007 -- see below):** `TOTAL_NEW_TESTS = 7`.
`EXEMPT_TESTS = 0` (test 3 is reclassified `PRE-EXISTING-BEHAVIOR`, non-exempt -- it is NOT
`WIRING-EXEMPT`, since this story has no stub for `WIRING-EXEMPT` to apply to). Denominator =
`7 - 0 = 7`. `RED_TESTS = 5` (1a, 1b, 1c, 2, 5). `RED_RATIO = 5 / 7 ~= 0.71 >= 0.5` -- integer-precise
check `RED_TESTS * 2 >= (TOTAL_NEW_TESTS - EXEMPT_TESTS)` -> `10 >= 7` TRUE. **The Red Gate Density
Check PASSES honestly on this corrected tally.** Tests 3 and 4 are the only non-exempt GREENs in
the denominator, and each is a single, individually justified `PRE-EXISTING-BEHAVIOR` entry (not
`UNJUSTIFIED`), so neither blocks Step 4 dispatch on its own even before the ratio arithmetic above
is applied.

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

## Revision Note (F3 adversarial pass-6 fix, ADV-C14-F3-P6-007, LOW; mechanical pin sweep)

**ADV-C14-F3-P6-007 (LOW, test-3 misclassification):** the pass-4 Red Gate tally (above)
classified test 3 (the serde key-set property, VP-580-013(3)) as `rationale_category:
FRAMEWORK-WIRING` -> `WIRING-EXEMPT`, excluded from the `EXEMPT_TESTS` denominator subtraction.
Per per-story-delivery.md's own definition of `WIRING-EXEMPT`
(`~/.claude/plugins/cache/claude-mp/vsdd-factory/1.0.0-rc.25/workflows/phases/per-story-delivery.md`
~L58), that category applies to a test passing "as soon as the correct type signature exists in
the stub." This story has **no stub** -- Task 6 already notes "No stub needed" because
`normalize_from_allowed_values_at_depth` and its siblings already exist -- so there is no stub
type signature for test 3 to be exempted against, and test 3 asserts pre-existing `FieldOption`
serde behavior, not a stub's shape. The table's own Formula-treatment cell for test 3 ("excluded
from `EXEMPT_TESTS` denominator subtraction") directly contradicted the surrounding tally's
`EXEMPT_TESTS = 1`, since nothing in this story is stub-shaped for `WIRING-EXEMPT` to apply to.

**Fix:** test 3 is reclassified as non-exempt GREEN with `rationale_category:
PRE-EXISTING-BEHAVIOR` -- consistent with test 4's own classification (both assert pre-existing,
unchanged behavior as a regression guard against this story's fallback fix) and with STORY-C's
rule for this same taxonomy. Test 3 therefore stays in the denominator, exactly like test 4.

**Recomputed tally:** `TOTAL_NEW_TESTS = 7` (unchanged). `EXEMPT_TESTS = 0` (was `1` -- test 3 is
no longer exempt). Denominator = `7 - 0 = 7` (was `6`). `RED_TESTS = 5` (1a, 1b, 1c, 2, 5;
unchanged). `RED_RATIO = 5 / 7 ~= 0.71 >= 0.5` -- integer-precise check `RED_TESTS * 2 >=
(TOTAL_NEW_TESTS - EXEMPT_TESTS)` -> `10 >= 7` TRUE. **The Red Gate Density Check still PASSES
honestly on this corrected tally.** The conclusion is unchanged from pass-4 (neither Option A nor
Option B is invoked), reached on a corrected denominator.

**Propagation:** the pass-4 Revision Note's table (test 3's row), "Explicit tally" paragraph, and
Task 6 below have all been corrected in place to this recomputed tally, with a superseded marker
inserted at the top of the pass-4 section recording the original (now-superseded) claim
(`EXEMPT_TESTS = 1`, `RED_RATIO = 5/6 ~= 0.833`) for audit purposes. AC-001/AC-002's Test lines are
unaffected by this reclassification (they name test functions, not `EXEMPT_TESTS` accounting).

**Mechanical pin sweep (VP-580-013(1)-(5) and BC-X.14.001 EC-8..15 / BC-X.14.003 / BC-X.14.004
empty-field-row text against `.factory/specs/prd/cross-cutting.md`):** every pinned example,
fixture, and expected value from those sources was enumerated and checked against this story's AC
Test lines and enumerated test functions. Two gaps were found and fixed:

- **Gap 1 (AC-002 / Task 1c):** VP-580-013(1)'s two EC-X.14.001-12 fixtures --
  `{"value": "", "name": "N"}` -> `Some("")` (value wins) and `{"value": null, "name": "N"}` ->
  `Some("N")` (falls through to `name`) -- were paraphrased in AC-002's body (`Some(String::new())`
  instead of the literal fixture) and not named at all in its Test line, and the VP's explicit
  methodological requirement ("built by deserializing JSON fixtures into `AllowedValue`, not by
  constructing the struct directly, so the explicit-null case exercises the real deserializer") was
  missing entirely. Fixed: AC-002's Test line now carries both fixtures verbatim plus the
  deserialization requirement; Task 1c is updated to match.
- **Gap 2 (AC-003):** VP-580-013(5)'s fixture and expected results were already verbatim in
  AC-003's Test line, but the mechanism detail "`filter_one`, matching `label` or `id`
  case-insensitively" was dropped, even though the fixture's own `Some("high")` -> `Highest`+`High`
  match depends on that case-insensitivity. Fixed: appended to AC-003's Test line.

All other pins were already carried verbatim and owned by an enumerated test function; see the
checklist below.

> **SUPERSEDED (D-386 bind-by-reference restructure, see the Revision Note below):** this
> self-attested "Pin -> AC -> Test checklist" table is superseded by the CLAUSE-level map in the
> "Revision Note (D-386 bind-by-reference restructure)" section following the Narrative below.
> Retained here only as an audit record of the pass-6 gap-fix described above; it is NOT the
> source of truth for AC/test coverage going forward, and AC-001 through AC-005's `**Test:**`
> lines no longer restate the fixture/value content this table paraphrases -- they bind to
> VP-580-013's sub-clauses in `cross-cutting.md` by reference instead.

**Pin -> AC -> Test checklist (historical, pass-6; superseded per D-386 above):**

| Pin (source) | AC | Owning test fn | Status |
|---|---|---|---|
| VP-580-013(1) top-level matrix: value-only/name-only/both/neither (EC-X.14.001-8..11) | AC-001 | 1a | verbatim, no gap |
| VP-580-013(1) cascading-child-level matrix: same 4 combos at depth >= 1 (EC-X.14.001-11) | AC-001 | 1b | verbatim, no gap |
| VP-580-013(1) EC-X.14.001-12: `{"value":"","name":"N"}` -> `Some("")`; `{"value":null,"name":"N"}` -> `Some("N")`; built via JSON deserialization, not direct struct construction | AC-002 | 1c | **gap fixed** (literal fixtures + deserialization note added) |
| VP-580-013(2): recursive `proptest!`, `label == value.or(name)`, `id` unchanged, tree shape unchanged, depth <= 3, `MAX_FIELD_OPTION_DEPTH` cap | AC-001 | 2 | verbatim, no gap |
| VP-580-013(3): serialized key set exactly `{"id","label","children"}`, `label` a JSON string or `null` | AC-001 | 3 | verbatim, no gap (pass-3 fix) |
| VP-580-013(4) / M3 fixture: `{"value":"10","name":"N"}` -> `{id:Some("10"),label:None,children:[]}`; `{"value":"11","label":"L","name":"N"}` -> `{id:Some("11"),label:Some("L"),children:[]}`; `{"value":"12","label":"Twelve"}` -> `{id:Some("12"),label:Some("Twelve"),children:[]}` | AC-004 | 4 | verbatim, no gap |
| VP-580-013(5) / EC-X.14.001-13 fixture: `[{"id":"1","name":"Highest"},{"id":"2","name":"High"},{"id":"3","name":"Low"}]`; `filter_options(Some("high"))` -> `Highest`+`High`; `filter_options(Some("3"))` -> `Low`; matched case-insensitively via `filter_one` | AC-003 | 5 | **gap fixed** (case-insensitivity mechanism note added) |
| BC-X.14.004 empty-`<field>` row / EC-X.14.001-15: exit 64 `Field '' not found. The field name must not be empty.`, zero HTTP/cache | AC-009 | existing `test_bc_x_14_001_empty_field_name_exits_64_zero_http` | verbatim, regression-only, no new test needed |
| EC-X.14.001-14 (informational, field-NAME resolution unaffected) | AC-008 | existing `search_field_list` unit tests | verbatim, informational, no new test needed |
| BC-X.14.003 rendering contract unchanged (`"(unnamed)"` table / `null` JSON) | AC-005 | existing BC-X.14.003 rendering tests | verbatim, regression-only, no new test needed |

## Revision Note (D-386 bind-by-reference restructure)

**Human decision D-386 ("bind by reference"):** across four adversarial passes (pass-3, pass-4,
pass-6, and the mechanical pin sweep folded into pass-6, all above), this story's `**Test:**`
lines repeatedly paraphrased VP-580-013's sub-clauses from `.factory/specs/prd/cross-cutting.md`,
dropped clauses on at least two occasions (the pass-6 "Gap 1"/"Gap 2" fixes above), and the story
carried a self-attested "Pin -> AC -> Test checklist" claiming completeness rather than deriving
coverage mechanically by walking the VP text itself. The human decided stories must BIND to VP
clauses BY REFERENCE instead of copying them.

**Fix applied:** AC-001 through AC-005's `**Test:**` lines (below, under Acceptance Criteria) are
rewritten so that each one (a) names the exact VP-580-013 sub-clause(s) it implements, with the
EC cells and the `cross-cutting.md` `~line` range; (b) carries the normative binding sentence,
verbatim (**[UPDATED pass-9, ADV-C14-F3-P9-002 -- category-free wording; see the pass-9 Revision
Note below]**): "Everything the cited clause(s) specify is binding in its entirety and must be
implemented exactly as written there; this story does not restate or narrow any of it."; (c)
keeps ONLY story-specific
information -- which test module each cell lives in (`src/cli/field.rs`'s `#[cfg(test)] mod
tests`), how cells group into the 7 test functions (1a/1b/1c/2/3/4/5, the counting unit fixed at
pass-4/pass-6), and each function's RED/GREEN classification. Paraphrased copies of pinned
fixtures and values are removed from the Test lines. A preamble note added directly above Task 1
in the Tasks section below applies this same binding instruction to all five test-writing tasks
(1-5). Task 6's Red Gate density tally (7 new test functions, 0 exempt,
`RED_TESTS = 5`, `RED_RATIO = 5/7 ~= 0.71 >= 0.5`) and every function's RED/GREEN classification
are UNCHANGED by this restructure -- re-checked below and still hold; this is a citation/binding
discipline fix, not a scope, test-count, or classification change.

## Coverage Scope (D-387)

**Human decision D-387 ("delete the clause maps"):** the hand-written VP-580-013 Clause Map and
BC-X.14.001/003/004 Edge-Case and Cross-Reference Map (D-386's restructure, previously here) kept
drifting out of sync with the AC `**Test:**` lines across passes 6, 8, and 9 -- three separate
map-completeness gaps were found and hand-fixed (pass-6's Gap 1/Gap 2, pass-8's missing
EC-7/fault-models rows, pass-9's missing Scope-boundary row). The human decided the maps
themselves are deleted. AC `**Test:**`/header `[CC:...]` citations are now the SOLE record of
which spec lines this story owns; a script checks coverage mechanically (every scope line below,
minus `EXCLUDE`d lines, must fall inside at least one AC's `[CC:...]` range) instead of a second,
hand-maintained table that can drift from the citations it is supposed to summarize.

**Scope lines** (exact spans in `cross-cutting.md` this story implements or amends): every span
amended or added in cycle-014 (per `prd-delta.md`) is in SCOPE and cited from an AC below --
including doc-only corrections (e.g. the `[CORRECTED cycle-014: ...]`-marked spans), not only the
#861 behavior-changing amendments. Pre-existing text this story does not touch is NOT listed. Six
cycle-014-marked spans are intentionally left unlisted, for the reasons given:
- L2717-2718 (the "Previous version (pre-cycle-014, spec 2.3.2)" blockquote) -- a historical
  metadata note recording the PRIOR wording, not itself binding spec text this story implements.
- L2670-2675 (the M2 project-resolution paragraph's "Known ordering drift" sentence, new this
  cycle, naming drift item `FIELD-OPTIONS-RESOLUTION-ORDER`) -- describes existing behavior /
  recorded drift item FIELD-OPTIONS-RESOLUTION-ORDER; no requirement.
- L2963 (the "EC-X.14.001-8 through EC-X.14.001-13 below are new Edge Cases added this cycle
  (#861)" sentence) -- a section-intro pointer to the EC-8..13 rows, which are already
  individually in SCOPE below; the intro sentence adds no separate binding content of its own.
- L3141-3142, L3144-3146, and L3154-3161 (Trace-field edits: the BC-3.4.015 cache-contract
  rewording, the `search_field_list`-replaces-`partial_match` citation swap, and the cycle-014
  citation additions) -- a cross-reference/citation list (per CLAUDE.md's "BC Trace and Source
  fields ... describe coverage qualitatively" convention), not normative spec text.
- L2530-2532 (the `## BC-X.14` subsection intro paragraph's "whose labels resolve correctly since
  cycle-014 #861" aside) -- scopes the whole four-BC `BC-X.14` subsection as a family, not
  BC-X.14.001 specifically; outside this story's own BC.
- L2720 (the "`jr` normalizes BOTH shapes into one internal model:" lead-in sentence) --
  pre-existing lead-in sentence displaced by the L2717-2718 blockquote insertion; wording
  unchanged.

[SCOPE:L2624-2652] BC-X.14.001 Behavior paragraph -- empty-`<field>` guard-ordering description
(L2624-2633) and the `search_field_list` exact-then-substring algorithm description (L2634-2652)
**[CORRECTED cycle-014: aligns with existing code and tests; no behavior change]**

[SCOPE:L2708-2715] BC-X.14.001 M1/M2-vs-M3 key-spelling paragraph's `.value`-falls-back-to-`name`
parenthetical (cycle-014, #861 -- the first #861 amendment named in prd-delta.md Item 2)

[SCOPE:L2728-2728] BC-X.14.001 `FieldOption` contract amendment (`id`/`label` -> `Option<String>`)
[EXCLUDE:L2729] blank line separating the contract-amendment paragraph (L2728) from the fallback
paragraph (L2730-2745)
[SCOPE:L2730-2745] BC-X.14.001 M1/M2 `value`-else-`name` label-resolution fallback paragraph

[SCOPE:L2747-2757] BC-X.14.001 F4 `editmeta.rs` stale-doc-comment correction paragraph
(`AllowedValue` struct-level + `name` field-level comments)

[SCOPE:L2759-2775] BC-X.14.001 "Scope boundary -- READ-SIDE ONLY, WRITE-side explicitly out of
scope [D-378]" paragraph

[SCOPE:L2777-2781] BC-X.14.001 "M3 (JSM requesttype-fields) is UNCHANGED and was ALREADY CORRECT"
paragraph

[SCOPE:L2807-2808] BC-X.14.001 Preconditions bullet -- field-name-resolution algorithm corrected to
`search_field_list`, NOT `partial_match`
**[CORRECTED cycle-014: aligns with existing code and tests; no behavior change]**

[SCOPE:L2812-2823] BC-X.14.001 Postconditions bullet -- `GET /rest/api/3/field` NOT called when
`<field>` is empty, a `customfield_NNNNN` literal, or resolves from a warm cache
**[CORRECTED cycle-014: aligns with existing code and tests; no behavior change]**

[SCOPE:L2889-2896] BC-X.14.001 Invariant 3 -- `customfield_NNNNN` bypass and `fields.json`
cache-first contract "mirrored, not shared" with `field_resolve.rs::resolve_edit_fields`
**[CORRECTED cycle-014: aligns with existing code; no behavior change]**

[SCOPE:L2897-2909] BC-X.14.001 Invariant 4 -- field-NAME resolution via `search_field_list`, NOT
`partial_match`, including the empty-`<field>` exit-64 ordering recap
**[CORRECTED cycle-014: aligns with existing code and tests; no behavior change]**

[SCOPE:L2912-2912] BC-X.14.001 EC-X.14.001-1 -- field-name-resolution algorithm corrected to
`search_field_list`, NOT `partial_match`
**[CORRECTED cycle-014: aligns with existing code and tests; no behavior change]**

[SCOPE:L2915-2915] BC-X.14.001 EC-X.14.001-2 -- field-name-resolution algorithm corrected to
`search_field_list`, NOT `partial_match`
**[CORRECTED cycle-014: aligns with existing code and tests; no behavior change]**

[SCOPE:L2935-2935] BC-X.14.001 EC-X.14.001-6 -- field-name-resolution algorithm corrected to
`search_field_list`, NOT `partial_match`
**[CORRECTED cycle-014: aligns with existing code and tests; no behavior change]**

[SCOPE:L2943-2961] BC-X.14.001 EC-X.14.001-7 (never-drop invariant)

[SCOPE:L2964-2968] BC-X.14.001 EC-X.14.001-8 (name-only fallback -- the #861 defect)

[SCOPE:L2969-2972] BC-X.14.001 EC-X.14.001-9 (`value` wins when both `value` and `name` present)

[SCOPE:L2973-2976] BC-X.14.001 EC-X.14.001-10 (neither present -> `None`, unchanged)

[SCOPE:L2977-2981] BC-X.14.001 EC-X.14.001-11 (cascading-child fallback applies recursively)

[SCOPE:L2982-2990] BC-X.14.001 EC-X.14.001-12 (presence-based, not emptiness-based, fallback)

[SCOPE:L2991-3003] BC-X.14.001 EC-X.14.001-13 (`--value` filter downstream consequence)

[SCOPE:L3004-3035] BC-X.14.001 EC-X.14.001-14 (field-NAME resolution unaffected, informational)

[SCOPE:L3036-3044] BC-X.14.001 EC-X.14.001-15 (empty `<field>` string, informational)

[SCOPE:L3093-3134] VP-580-013 (cycle-014, issue #861, READ-SIDE ONLY) -- the whole clause: "What
it proves" (L3093-3099), the five-part Strategy ((1)-(5), L3099-3128), and the Fault models
sentence (L3129-3134)

[SCOPE:L3247-3254] BC-X.14.003 UPDATED rendering-contract blockquote

[SCOPE:L3351-3351] BC-X.14.004 empty-`<field>` error-taxonomy row (cross-reference to
EC-X.14.001-15)

Ownership is recorded solely by the `[CC:...]` citations in each AC; coverage (every SCOPE line
minus EXCLUDE is inside some AC's `[CC:...]` range) is verified mechanically per D-387.

## Revision Note (F3 adversarial pass-8 fix, ADV-C14-F3-P8-005, LOW)

**ADV-C14-F3-P8-005 (LOW, both clause maps omit an item):**

1. **Edge-Case and Cross-Reference Map omitted EC-X.14.001-7.** EC-X.14.001-7 (never-drop
   invariant; cross-cutting.md ~L2943-2961) is amended in cycle-014 (the "**(cycle-014, #861)**"
   marker at ~L2947-2948, plus the `FieldOption` contract note at ~L2728 which cross-references it
   by name) but was missing from the map entirely, and AC-001's trace header cited only
   `EC-X.14.001-8..11`, not EC-7. Fixed by adding a map row and widening AC-001's header, both
   below.
2. **VP-580-013 Clause Map omitted the fault-model sentence.** The "Fault models (killed by
   example/proptest)" sentence at ~L3129-3134 is part of VP-580-013's text but was never given its
   own row, even though it names concrete failure modes distinct from clauses (1)-(5)'s positive
   assertions. Fixed by adding a row below.

**Fix 1 -- Edge-Case and Cross-Reference Map row added** (inserted before the EC-X.14.001-8 row,
so the table stays in EC-id order):

| Source | ID | cross-cutting.md ~line(s) | Owning AC | Coverage mechanism |
|---|---|---|---|---|
| BC-X.14.001 | EC-X.14.001-7 | ~L2943-2961 | AC-001 | never-drop invariant -- a source item missing `id` and/or its label source(s) degrades to `None` but is NEVER omitted from the output array; via test fns 1a and 1b's "neither" cell (entry-count-preserving assertion), plus the existing regression test `src/cli/field.rs::test_bc_x_14_001_normalizer_never_drops_degenerate_entries` (name verified present in `src/cli/field.rs`, L1135) |

The table's completeness claim is corrected from "Ten rows; every BC-X.14.001 EC-8..15 id..." to
"Eleven rows; every BC-X.14.001 EC-7..15 id..." (see the corrected sentence replacing the original
below the table).

**Fix 2 -- AC-001 trace header widened.** `### AC-001 (traces to BC-X.14.001 Behavior -- M1/M2
label-resolution fallback, EC-X.14.001-8..11)` is corrected to `EC-X.14.001-7..11` (AC-001's Test
line already names test fns 1a and 1b, which is where EC-7's "neither" cell lives -- no test-line
change needed, only the header's EC range).

**Fix 3 -- VP-580-013 Clause Map row added** (appended after clause (5)'s row):

| VP-580-013 clause | cross-cutting.md ~lines | EC cells embedded in this clause | Owning AC(s) | Owning test fn(s) |
|---|---|---|---|---|
| fault models (summary sentence naming concrete failure modes for clauses (1)-(5); not itself a separately-numbered clause) | ~L3129-3134 | references EC-X.14.001-8 by name; no new EC cells of its own | AC-001, AC-002, AC-003, AC-004 | 1a, 1b, 1c, 2, 4, 5 |

Verified against the fault-model sentence's own text, each named failure mode maps to the test
fn(s) that kill it: "the fallback removed entirely" -> 1a (EC-8 name-only cell fails outright) and,
redundantly, 5 (the `--value` filter's downstream match also fails if the fallback is gone); "`name`
preferred over `value`" -> 1a and 1b (the "both" cell at both tree levels asserts `value` wins);
"an emptiness-based fallback (`Some("")` falling through to `name`)" -> 1c (the `"value": ""`
cell); "explicit `null` treated as present" -> 1c (the `"value": null` cell); "the fallback applied
only at the top level" -> 1b (cascading-child-level matrix) and 2 (the recursive proptest
generalizes this across all depths <= 3); "the fallback leaking into the M3 normalizer" -> 4 (the
M3 regression guard). Every one of the six named failure modes is killed by at least one function
in `{1a, 1b, 1c, 2, 4, 5}`; no failure mode is left uncovered.

**Sweep performed (per the pass-8 finding's instruction) -- every BC-X.14.001 EC (1..15) checked
for a cycle-014/#861 marker in `cross-cutting.md` ~L2618-3134:** EC-X.14.001-1 through -6 carry no
`"cycle-014"` or `"#861"` marker in their own text (EC-6, dated 2026-08-26 "F2 adversary-convergence
pass," is the closest case and was checked specifically -- it has no such literal marker, unlike
EC-7's explicit `"(cycle-014, #861)"` tag) and are therefore pre-existing, out of this sweep's
scope. EC-X.14.001-7 through -15 all carry a marker (EC-7: `"(cycle-014, #861)"`; EC-8 through -13:
"new Edge Cases added this cycle (#861)"; EC-14 and EC-15: "added cycle-014"). Of these nine, EC-8
through -15 (eight ECs) were already present in the map before this pass; EC-7 was the sole gap,
now fixed above. No further gaps found.

**Binding-sentence check (per the pass-8 finding's instruction):**

> **SUPERSEDED (pass-9, ADV-C14-F3-P9-002):** the binding sentence quoted below is the pass-6/D-386
> wording, which enumerated a fixed category list ("fixture, cell, expected value, deserialization
> requirement, property and filter assertion"). Pass-9 replaced that enumerated-category wording,
> in every AC Test line and in the D-386 definition above, with a category-free sentence -- see the
> pass-9 Revision Note below for the fix and rationale. This paragraph is retained only as an audit
> record of the pass-8 consistency check performed against the (now-superseded) pass-6 wording; it
> is NOT the current wording of any AC's Test line.

AC-001 through AC-004's `**Test:**`
lines all carried the (superseded) D-386 binding sentence -- "Every fixture, cell, expected value, deserialization
requirement, property and filter assertion in the cited clause(s) is binding and must be
implemented exactly as written there; this story does not restate them, and nothing here narrows
them." AC-001 uses "clause(s)" (plural-capable, since it cites three clauses); AC-002/AC-003/AC-004
each use "clause" (singular, since each cites exactly one clause) -- a grammatical adaptation to
clause count, not a wording or scope change. AC-005 cites BC-X.14.003 (not a VP-580-013 clause) and
uses its own parallel sentence ("The cited blockquote is binding; this story does not restate its
wording, and nothing here narrows it."), consistent with the same non-narrowing intent. No AC
narrows the category of what it binds to; all five sentences were confirmed consistent as of pass-8.

## Revision Note (F3 adversarial pass-9 fix, ADV-C14-F3-P9-002/006a/007/012a/013)

**ADV-C14-F3-P9-002 (category-free binding sentence):** the pass-6/D-386 binding sentence
enumerated a fixed category list -- "fixture, cell, expected value, deserialization requirement,
property and filter assertion" -- which is itself a form of restatement/narrowing: any pinned
content added to a cited clause that doesn't fit one of those five nouns (e.g. a future strategy
description, a fault-model sentence, a methodological requirement) would fall outside the
sentence's own coverage, recreating the "category list omits X" defect class this story has
already hit twice (pass-6's Gap 1/Gap 2). Fixed by replacing the sentence, everywhere it appears
as the live/current wording -- the D-386 definition above and every AC-001..AC-005 `**Test:**`
line below -- with the category-free form: "Everything the cited clause(s) specify is binding in
its entirety and must be implemented exactly as written there; this story does not restate or
narrow any of it." AC-005's parallel (non-VP, BC-X.14.003-citing) sentence was adapted to the same
wording, substituting "blockquote" for "clause(s)". The pass-8 "Binding-sentence check" section,
which quoted the old wording as an audit record, is marked SUPERSEDED in place rather than
rewritten, since it documents a pass-8-era consistency check, not the current state.

**ADV-C14-F3-P9-006a (restatement sweep):** Task 2 restated VP-580-013(2) as "strategy (depth <=
3)" and Task 3 restated VP-580-013(3) as "{id,label,children} unchanged", dropping the clause's
"label a JSON string or null" type assertion entirely -- the same restatement-drift class the
D-386 restructure was meant to close, just relocated from the ACs' `**Test:**` lines (already
fixed by D-386) into the Tasks section (never swept). Fixed by rewriting Tasks 2 and 3 to cite
VP-580-013(2)/(3) by clause reference (`cross-cutting.md` line range + "binding") instead of
paraphrasing their content. A sweep of the rest of the Tasks section found one further instance of
the same class: Task 1c reproduced the two EC-X.14.001-12 fixture literals verbatim (`{"value":
"", "name": "N"}` / `{"value": null, "name": "N"}` and their resolved values) -- the exact content
D-386 already removed from AC-002's own Test line. Fixed by rewriting Task 1c to cite VP-580-013(1)
by reference too, retaining only the story-specific instruction (build via JSON deserialization,
not direct construction) and pointing to AC-002's Test line for the clause citation. Tasks 1a, 1b,
4, 5, and 6 were checked and use only combination labels (value-only/name-only/both/neither, RED/
GREEN classifications) and story-specific test-function bookkeeping, not reproductions of pinned
VP/BC literals -- no further Tasks-section changes made. The VP-580-013 Clause Map and Edge-Case/
Cross-Reference Map (both below) are themselves the intended reference-by-citation mechanism, not
restatements, and were left as-is except for the P9-007/P9-012a fixes below. **[SUPERSEDED by
D-387: both maps described as "below" in this sentence were later deleted; see the "## Coverage
Scope (D-387)" section earlier in this file, above.]**

**ADV-C14-F3-P9-007 (three map/trace gaps):**
(a) The BC-X.14.001 "Scope boundary -- READ-SIDE ONLY, WRITE-side explicitly out of scope [D-378]"
paragraph (cross-cutting.md ~L2759-2775) had no owning AC. Fixed by widening AC-004's trace header
and Test line to cite it, with a reviewable (not runtime-testable) check: at PR review, `git diff`
shows zero changes to `src/cli/issue/field_resolve.rs` -- verified against the paragraph's own
text, which names exactly that file's `find_option_match`/`resolve_option_value` functions as the
out-of-scope WRITE-side path. A corresponding row was added to the Edge-Case/Cross-Reference Map.
(b) The Behavioral Contracts table's BC-X.14.001 row claimed "Edge Cases EC-X.14.001-8..13",
undercounting what this story actually owns. Fixed by widening it to "EC-X.14.001-7..15" (EC-7 is
the never-drop invariant this story's fallback interacts with per pass-8's own fix; EC-14/EC-15 are
informational-but-owned per AC-008/AC-009).
(c) The Edge Cases table omitted an EC-X.14.001-7 row (present in the Edge-Case/Cross-Reference Map
since pass-8, but never added to this simpler table). Fixed by adding it, matching the Map's
description.

> **SUPERSEDED (D-387 mechanical-coverage restructure):** the completeness claim immediately below
> ("confirmed every paragraph/clause... appears in the Edge-Case/Cross-Reference Map") refers to
> the hand-maintained map tables, which D-387 deleted. Coverage is now checked mechanically
> against the AC `[CC:...]` citations in the "## Coverage Scope (D-387)" section earlier in this
> file, above; this paragraph is retained only as a pass-9-era audit record of the walk that
> was performed against the (now-deleted) tables at the time.

A subsequent paragraph-by-paragraph walk of BC-X.14.001/003/004 confirmed every paragraph/clause
the widened BC table row now claims is traced by an AC and appears in the Edge-Case/Cross-Reference
Map (12 rows after the fixes above: EC-7..15 (9), the Scope-boundary paragraph, BC-X.14.003's
blockquote, and BC-X.14.004's empty-field cross-reference row).

**ADV-C14-F3-P9-012a (map line-range accuracy):** the Edge-Case/Cross-Reference Map's EC-X.14.001-15
row cited `~L3036-3039`, but EC-X.14.001-15's text in `cross-cutting.md` runs through `~L3044`
(the test-name pin, the "zero cache reads" clause, and the `resolve_field_id`/~L451 ordering
citation all sit in the omitted `~L3040-3044` span). Fixed by widening the row to `~L3036-3044`.
Every other line range in both maps (the VP-580-013 Clause Map and the Edge-Case/Cross-Reference
Map) was checked against `cross-cutting.md` directly: all EC-7..15 rows, the BC-X.14.003 blockquote
row, and the BC-X.14.004 row are exact; the five VP-580-013 sub-clause rows and the fault-models
row each end 0-1 lines short of where their prose text technically spills into the next numbered
clause's opening words (an artifact of clause boundaries falling mid-line, consistent with every
row in that table, not a citation defect) and were left as-is -- only EC-X.14.001-15's row omitted
a materially distinct chunk of binding content (a whole trailing sentence plus a citation), which
is what made it a genuine defect rather than the same-line rounding the other rows share.

**ADV-C14-F3-P9-013 (Library & Framework Requirements table):** the section was prose ("No new
dependency is added. No version pins change.") instead of the mandatory `| Tool | Version |
Purpose |` shape required by `story-template.md`. Fixed by converting it to a table naming the two
existing, version-pinned dependencies this story's new tests actually exercise (`serde`/
`serde_json` for the VP-580-013 deserialization-fixture cells, `proptest` for the recursive
strategy), with versions read from `Cargo.toml` (not invented) and both pins marked unchanged; the
"no new dependency" prose sentence is retained beneath the table for continuity.

**Tally re-verification:** none of the above changes the test count, exemption count, or RED/GREEN
classification established at pass-4/pass-6. `TOTAL_NEW_TESTS = 7` (1a, 1b, 1c, 2, 3, 4, 5),
`EXEMPT_TESTS = 0`, denominator `= 7`, `RED_TESTS = 5` (1a, 1b, 1c, 2, 5), `RED_RATIO = 5/7 ~=
0.71 >= 0.5` -- unchanged, still PASSES honestly. This pass is citation/binding-discipline and
map-completeness only.

## Revision Note (D-387 mechanical-coverage restructure + pass-10 fixes)

**Human decision D-387:** the D-386 bind-by-reference restructure (above) replaced paraphrased
fixture/value copies in the ACs' `**Test:**` lines with clause-reference citations, but retained
TWO hand-written summary tables (the VP-580-013 Clause Map and the BC-X.14.001/003/004
Edge-Case and Cross-Reference Map) as a second, independent record of the same coverage. Those
tables themselves then drifted out of sync with the AC citations three more times (pass-6's Gap
1/Gap 2, pass-8's missing EC-7/fault-models rows, pass-9's missing Scope-boundary row) -- the
exact class of defect D-386 was meant to close, just relocated one layer up. The human decided:
delete the maps. AC `[CC:L<start>-<end>]` citations are now the ONLY place ownership is recorded;
a script verifies coverage mechanically (every line in the "## Coverage Scope (D-387)" section
earlier in this file, above, minus `EXCLUDE`d lines, must fall inside at least one AC's
`[CC:...]` range) instead of a hand-maintained table that requires a human to keep two
representations in sync.

**Fixes applied (adversarial pass-10 findings):**
- **P10-004/P10-005/P10-007 (ownership gaps):** both clause-map tables are deleted (see
  "## Coverage Scope (D-387)" earlier in this file, above) and replaced by explicit
  `[CC:L<start>-<end>]` citations added to every AC that owns cross-cutting.md content: AC-001
  (FieldOption contract/fallback paragraph, VP-580-013's "What it proves"/(1)/(2)/(3)/fault
  models, EC-X.14.001-7..11), AC-002 (VP-580-013(1)'s EC-12 fixtures, EC-X.14.001-12, fault
  models), AC-003 (VP-580-013(5), EC-X.14.001-13, fault models), AC-004 (VP-580-013(4), the "M3
  is UNCHANGED" paragraph, the "Scope boundary" paragraph, fault models), AC-005 (BC-X.14.003's
  blockquote), AC-006's header (the F4 editmeta doc-comment paragraph), AC-008's header
  (EC-X.14.001-14), and AC-009's header (EC-X.14.001-15 and BC-X.14.004's empty-field row). Every
  scope line in the Coverage Scope section is covered by at least one AC's `[CC:...]` range.
- **P10-006 (LOW, BC-X.14.004 missing from frontmatter):** AC-009 has always bound BC-X.14.004's
  empty-`<field>` error-taxonomy row, but `bcs:`/`behavioral_contracts:` and the Behavioral
  Contracts table omitted it. Fixed by adding `BC-X.14.004` to both frontmatter arrays, `traces_to:`,
  and a new CROSS-REF row in the Behavioral Contracts table below, mirroring exactly how
  BC-X.14.003 (the other CROSS-REF, COUNT-NEUTRAL BC) is already handled.
- **P10-010 (Token Budget honesty):** the "Token Budget Estimate" section's "This story spec" row
  claimed ~2,800 tokens against an actual file of hundreds of lines of adversarial-review history
  -- an order-of-magnitude undercount. Recomputed from the file's actual size (822 lines / ~70,700
  characters as of this restructure): ~31,500 tokens for the spec itself, ~36,500 total, ~18% of a
  200K context window -- still comfortably within the 20-30% per-story ceiling, so no split is
  triggered.
- **P10-012 (LOW, Task 10 site count):** Task 10 claimed `tests/field_options.rs` needed 1 comment
  fix; AC-006 and prd-delta.md both name two distinct sites. Verified against the actual file
  (`tests/field_options.rs`): a section-banner comment at ~L1436 (`// AC-011 — <field> resolution
  (customfield_NNNNN bypass / list_fields + partial_match)`) and an inline comment at ~L2050 (`//
  "labels" is a human/system field name, not a customfield_NNNNN literal, so it resolves via
  list_fields() + partial_match first.`) both carry the stale `partial_match` wording. Fixed by
  changing Task 10's count from x1 to x2 and naming both sites.
- **Map-completeness claims superseded:** the pass-9 P9-007 paragraph's completeness claim
  ("confirmed every paragraph/clause... appears in the Edge-Case/Cross-Reference Map") and the
  pass-9 P9-006a paragraph's "(both below)" reference to the two maps are both marked SUPERSEDED
  in place, above, since the maps they describe no longer exist. They are retained as audit
  records of the passes that produced them, not as current-state claims.
- **Independent coverage-check scope gaps (post-pass-10):** a mechanical D-387 coverage check
  found that several cross-cutting.md spans amended or added this cycle (per prd-delta.md) sat
  outside this story's Coverage Scope entirely, contradicting the orchestrator's rule that all
  text amended or added this cycle is in SCOPE and cited. Fixed by adding five new SCOPE entries
  in the "## Coverage Scope (D-387)" section (above): L2624-2652 (the Behavior paragraph's
  empty-`<field>` guard-ordering and `search_field_list` algorithm descriptions), L2708-2715 (the
  M1/M2-vs-M3 key-spelling paragraph's `.value`-falls-back-to-`name` parenthetical -- the first
  #861 amendment named in prd-delta.md Item 2), L2811-2822 (the Postconditions bullet on when
  `GET /rest/api/3/field` is NOT called), L2889-2896 (Invariant 3, "mirrored, not shared"), and
  L2897-2909 (Invariant 4, `search_field_list` vs `partial_match`) -- all five are
  `[CORRECTED cycle-014: ...]`-marked doc-only corrections except L2708-2715, which is the real
  #861 behavior-amendment text. Also split the L2728-2745 SCOPE entry into L2728-2728 and
  L2730-2745 around the pre-existing L2729 EXCLUDE (blank line), so SCOPE and EXCLUDE stay
  disjoint, matching sibling stories A and C's convention rather than nesting an EXCLUDE inside a
  SCOPE span. Ownership citations were added inside the Acceptance Criteria section only: AC-001
  (L2708-2715), AC-007 (L2634-2652, the `search_field_list` half of the Behavior paragraph,
  labelled informational -- doc-only correction, no behavior change, pinned by the existing
  `search_field_list` unit tests), AC-008 (L2889-2896 and L2897-2909, both labelled informational
  and pinned by the same existing tests), and AC-009 (L2624-2633, the empty-`<field>` guard-order
  half of the Behavior paragraph, and L2811-2822, both labelled informational and pinned by
  `test_bc_x_14_001_empty_field_name_exits_64_zero_http` and its sibling zero-HTTP tests). The
  Coverage Scope section's intro sentence was reworded to state this in-scope-by-default rule
  explicitly and to name the four cycle-014-marked spans that remain intentionally unlisted
  (L2717-2718, L2963, L3154-3161, L2529-2531) with their reasons, so their absence from SCOPE
  reads as a documented decision rather than a further gap. `input-hash` is left untouched by
  this fix, per this pass's scope (input files themselves did not change).
- **Second independent coverage-check gap-fill (post-pass-10, round 2):** a further mechanical
  check, this time walking the actual diff against the pre-cycle-014 commit line by line rather
  than re-deriving scope from prd-delta.md's own summary, found six more places where this
  story's Coverage Scope section still did not match what cycle-014 actually changed inside
  BC-X.14.001. Fixed: added the corrected Preconditions bullet (the field-name-resolution
  algorithm, corrected from `partial_match` to `search_field_list`) to scope, cited from AC-007;
  added the matching one-line `search_field_list` corrections buried inside Edge Cases
  EC-X.14.001-1, EC-X.14.001-2, and EC-X.14.001-6 to scope, also cited from AC-007 -- these three
  lines carry no inline cycle-014/#861 marker of their own, which is why the earlier EC sweep (the
  pass-8 Revision Note above) missed them even though they were genuinely changed; corrected the
  Postconditions scope range and AC-009's matching citation, which had drifted to start one line
  short of the actual corrected bullet and one line into the preceding, unrelated bullet; added the
  M2 project-resolution paragraph's new "known ordering drift" sentence (drift item
  `FIELD-OPTIONS-RESOLUTION-ORDER`) to the unlisted-and-reasoned list, since on inspection it
  documents an existing behavior and a recorded, explicitly out-of-scope-for-cycle-014 drift item
  rather than stating any requirement; widened the Trace-field unlisted entry to also cover two
  further Trace-paragraph edits (the BC-3.4.015 cache-contract rewording and the
  `search_field_list`-replaces-`partial_match` citation swap) alongside the citation-list rows
  already named there, since all of it is the same non-normative Trace-field content; and corrected
  the `## BC-X.14` subsection-intro unlisted entry's line numbers, which pointed one line higher
  than the text actually changed. Also split AC-001's single citation spanning both the
  `FieldOption` contract-amendment paragraph and the fallback paragraph into two separate
  citations, so it no longer reaches across the blank line that sits between them. `input-hash` is
  left untouched by this fix, per this pass's scope (input files themselves did not change).
- **Third independent coverage-check gap-fill (post-pass-10, round 3):** a further mechanical
  check found the intentionally-unlisted list itself omitted L2720 (the "`jr` normalizes BOTH
  shapes into one internal model:" lead-in sentence, immediately following the L2717-2718
  blockquote) -- a pre-existing lead-in sentence merely displaced downward by that blockquote's
  insertion, with its own wording unchanged this cycle. Fixed by adding it as a sixth reasoned
  entry to the unlisted list in the "## Coverage Scope (D-387)" section (above) and updating that
  section's intro count from "Five" to "Six". `input-hash` is left untouched by this fix, per
  this pass's scope (input files themselves did not change).

**Version bump:** this story's `version:` frontmatter field is bumped to `3.0` (from `2.2`) to
reflect the structural change (table deletion, section replacement, frontmatter BC addition) --
the D-386 restructure was itself a minor-version bump (2.1 -> 2.2); deleting a whole section and
introducing a new citation mechanism is a major structural change to how this story records
coverage. `input-hash` is intentionally left untouched per this pass's scope (input files
themselves did not change).

**Tally unaffected:** none of the above changes `TOTAL_NEW_TESTS = 7`, `EXEMPT_TESTS = 0`,
`RED_TESTS = 5`, or `RED_RATIO = 5/7 ~= 0.71 >= 0.5` (pass-4/pass-6, re-verified pass-9, unchanged
here). This pass is a citation-mechanism restructure plus five LOW-severity bookkeeping fixes, not
a scope, test-count, or classification change.

## Narrative

- **As a** `jr field options <field>` user enumerating a system field's allowed values (e.g. `priority`, `components`, `versions`, `issuetype`)
- **I want to** see the field's real display name instead of `"(unnamed)"` (table) / `null` (JSON)
- **So that** `jr field options` is usable for system-typed fields, not just custom select fields, without changing the rendering contract for genuinely-nameless entries

## Behavioral Contracts

| BC | Role | Clauses this story implements |
|----|------|-------------------------------|
| BC-X.14.001 | PRIMARY (amended, cycle-014 F2) | The `value`-else-`name` presence-based label-resolution fallback (Behavior), the "Scope boundary -- READ-SIDE ONLY" paragraph, the "M3 is UNCHANGED and ALREADY CORRECT" paragraph, Edge Cases EC-X.14.001-7..15 **[widened pass-9, ADV-C14-F3-P9-007b -- was "EC-X.14.001-8..13", which undercounted what this story actually owns]** |
| BC-X.14.003 | CROSS-REF (amended, cycle-014 F2, COUNT-NEUTRAL) | The UPDATED blockquote clarifying the rendering contract (`(unnamed)`/`null` for `None`) is unchanged -- only the upstream normalizer produces fewer `None` labels |
| BC-X.14.004 | CROSS-REF (amended, cycle-014, COUNT-NEUTRAL) **[ADDED pass-10, P10-006]** | The empty-`<field>` error-taxonomy row, which cross-references BC-X.14.001 EC-X.14.001-15 (same pre-existing condition, no new behavior) |

**Anchor justification:** BC-X.14.001 is the sole BC governing `jr field options`'s M1/M2 label-resolution normalizer (`cross-cutting.md`). BC-X.14.003 is cited as a cross-reference only because this story's fix changes what feeds INTO its rendering contract, not the contract itself (AC-005 traces to it to make that boundary explicit and count-neutral). BC-X.14.004 is cited as a cross-reference for the same reason: its empty-`<field>` error-taxonomy row documents the same pre-existing, unmodified condition as BC-X.14.001 EC-X.14.001-15 (AC-009 traces to it to make that cross-reference explicit and count-neutral) -- **[ADDED pass-10, P10-006]** this BC was bound by AC-009 since the story's original authoring but was missing from `bcs:`/`behavioral_contracts:` and this table; fixed here to close that gap, mirroring how BC-X.14.003 is handled.

## Acceptance Criteria

### AC-001 (traces to BC-X.14.001 Behavior -- M1/M2 label-resolution fallback, EC-X.14.001-7..11)
`src/cli/field.rs::normalize_from_allowed_values_at_depth` sets `label = v.value.clone().or_else(|| v.name.clone())` (presence-based, not emptiness-based) at every depth of the cascading-option tree, for the four combinations {value-only, name-only, both, neither} at both the top level and at least one cascading child level.
**Test:** Implements VP-580-013's "What it proves" statement [CC:L3093-3099] and sub-clauses (1)
(top-level and cascading-child-level example matrices) [CC:L3099-3105], (2) (recursive
`proptest!`) [CC:L3106-3110], and (3) (serde key-set property) [CC:L3110-3113], plus the fault
models this AC's tests kill [CC:L3129-3134]. Also implements BC-X.14.001's M1/M2-vs-M3
key-spelling paragraph's `.value`-falls-back-to-`name` parenthetical (the first #861 amendment
named in prd-delta.md Item 2) [CC:L2708-2715], the `FieldOption` contract
amendment [CC:L2728] and `value`-else-`name` fallback paragraph [CC:L2730-2745] and Edge Cases
EC-X.14.001-7 [CC:L2943-2961], EC-X.14.001-8 [CC:L2964-2968], EC-X.14.001-9 [CC:L2969-2972],
EC-X.14.001-10 [CC:L2973-2976], and EC-X.14.001-11 [CC:L2977-2981]. Everything each cited range
specifies is binding in its entirety and must be implemented exactly as written there; this story
does not restate or narrow any of it. Story-specific mapping: all three VP clauses land in
`src/cli/field.rs`'s `#[cfg(test)] mod tests`; clause (1)'s top-level matrix is function 1a (RED)
and its cascading-child-level matrix is function 1b (RED) -- split per the Revision Note's Red Gate
density tally (ADV-C14-F3-P4-001); clause (2) is function 2 (RED); clause (3) is function 3
(GREEN, `rationale_category: PRE-EXISTING-BEHAVIOR`, non-exempt -- pass-6, ADV-C14-F3-P6-007).

### AC-002 (traces to BC-X.14.001 EC-X.14.001-12)
A wire `"value": ""` (present-but-empty string) wins over a populated `name` -- `label: Some(String::new())`, never falling through to `name` merely because the value string is empty. A wire `"value": null` deserializes to `AllowedValue.value: None`, which DOES fall through to `name`.
**Test:** Implements VP-580-013 sub-clause (1)'s EC-X.14.001-12 fixtures [CC:L3099-3105] (the two
`{"value": ...}` cells embedded in clause (1)'s text), BC-X.14.001's EC-X.14.001-12 edge case
[CC:L2982-2990], and the fault models this AC's tests kill [CC:L3129-3134]. Everything each cited
range specifies is binding in its entirety and must be implemented exactly as written there;
this story does not restate or narrow any of it. Story-specific mapping: lands in
`src/cli/field.rs`'s `#[cfg(test)]
mod tests` as function 1c, bundled with its GREEN sibling cell per the Revision Note's Red Gate
density tally (ADV-C14-F3-P4-001, corrected pass-6 ADV-C14-F3-P6-007) -- RED.

### AC-003 (traces to BC-X.14.001 EC-X.14.001-13)
`jr field options --value <substring>` (BC-X.14.002, its own contract unchanged) now also matches system-field option names via the fallback label, as a downstream consequence of AC-001 -- not a new filter rule.
**Test:** Implements VP-580-013 sub-clause (5) [CC:L3123-3128], BC-X.14.001's EC-X.14.001-13 edge
case [CC:L2991-3003], and the fault models this AC's tests kill [CC:L3129-3134].
Everything each cited range specifies is binding in its entirety and must be implemented exactly
as written there; this story does not restate or narrow any of it. Story-specific mapping: lands in
`src/cli/field.rs`'s `#[cfg(test)] mod tests` as function 5 (`filter_one` is a private fn,
unreachable from the external `tests/field_options.rs` integration binary) -- RED.

### AC-004 (traces to BC-X.14.001 "M3 is UNCHANGED and ALREADY CORRECT" paragraph AND the "Scope boundary -- READ-SIDE ONLY" paragraph [D-378] **[widened pass-9, ADV-C14-F3-P9-007a]**)
`src/cli/field.rs::normalize_from_valid_values` (M3, JSM requesttype-fields) is NOT modified by this story and does NOT acquire a `name`-fallback of its own -- it already reads `.value` for id and `.label` for display, which was already correct before this story. Separately, per BC-X.14.001's "Scope boundary -- READ-SIDE ONLY, WRITE-side explicitly out of scope [D-378]" paragraph, the WRITE-side `--field` value-matching path (`src/cli/issue/field_resolve.rs::find_option_match`/`resolve_option_value`) MUST NOT be touched by this story.
**Test:** Implements VP-580-013 sub-clause (4) [CC:L3113-3123] and the fault models this AC's
tests kill [CC:L3129-3134]. Everything each cited range specifies is binding in its entirety and
must be implemented exactly as written there; this story does not restate or narrow any of it.
Story-specific mapping: lands in
`src/cli/field.rs`'s `#[cfg(test)] mod tests` as function 4 -- GREEN (`rationale_category:
PRE-EXISTING-BEHAVIOR`, non-exempt). Also implements BC-X.14.001's "M3 is UNCHANGED and was
ALREADY CORRECT" paragraph [CC:L2777-2781] via that same function 4, and the "Scope boundary --
READ-SIDE ONLY, WRITE-side explicitly out of scope [D-378]" paragraph [CC:L2759-2775] via a
reviewable check, not a runtime test: at PR review, `git diff`
shows zero changes to `src/cli/issue/field_resolve.rs`.

### AC-005 (traces to BC-X.14.003 UPDATED blockquote, COUNT-NEUTRAL)
The rendering contract for a `None` label (`"(unnamed)"` in table output, `null` in `--output json`) is byte-for-byte UNCHANGED by this story -- only the upstream normalizer (AC-001) now produces fewer `None` labels for system fields.
**Test:** Implements BC-X.14.003's UPDATED rendering-contract blockquote [CC:L3247-3254].
Everything the cited blockquote specifies is binding in its entirety and must be
implemented exactly as written there; this story does not restate or narrow any of it.
Story-specific mapping: regression guard only, no new test needed --
existing BC-X.14.003 rendering tests continue proving it, unmodified.

### AC-006 (traces to prd-delta.md F4 stale-wording obligation, PASS-9/13/33, P9-002/P13-002/P33-002; BC-X.14.001 F4 editmeta doc-comment paragraph [CC:L2747-2757])
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
**Test:** the renamed test itself, run green. Also implements BC-X.14.001's Behavior paragraph's
`search_field_list` exact-then-substring algorithm description [CC:L2634-2652], the Preconditions
bullet's matching `search_field_list`-NOT-`partial_match` correction [CC:L2807-2808], and the same
correction as it appears in Edge Cases EC-X.14.001-1 [CC:L2912-2912], EC-X.14.001-2 [CC:L2915-2915],
and EC-X.14.001-6 [CC:L2935-2935] (all informational --
doc-only correction, no behavior change; existing behavior pinned by
`src/cli/field.rs::test_bc_x_14_001_search_field_list_exact_single_match`, `_case_insensitive`,
`_substring_single_match`, `_zero_match_returns_none`, `_exact_multiple_is_err`, and
`_substring_multiple_is_err`).

### AC-008 (traces to BC-X.14.001 EC-X.14.001-14 [CC:L3004-3035], informational -- documented for completeness, no dedicated VP cell)
System-typed field NAME resolution (the step upstream of the label fallback, e.g. resolving the string `"Priority"` to a field id) is pre-existing `search_field_list`/`resolve_field_id` behavior, unaffected by this story's label-resolution fix. No new test is added for this AC; existing `search_field_list` unit tests already cover it as a regression guard.
**Test:** N/A (informational); existing `test_bc_x_14_001_search_field_list_*` unit tests continue
passing unmodified. Also implements BC-X.14.001 Invariant 3's `customfield_NNNNN` bypass /
`fields.json` cache-first "mirrored, not shared" description [CC:L2889-2896] and Invariant 4's
`search_field_list`-vs-`partial_match` description (including the empty-`<field>` exit-64
ordering recap) [CC:L2897-2909] (informational -- doc-only correction, no behavior change;
existing behavior pinned by
`src/cli/field.rs::test_bc_x_14_001_search_field_list_exact_single_match`, `_case_insensitive`,
`_substring_single_match`, `_zero_match_returns_none`, `_exact_multiple_is_err`,
`_substring_multiple_is_err`, and
`tests/field_options.rs::test_bc_x_14_001_customfield_bypass_skips_list_fields`).

### AC-009 (traces to BC-X.14.001 EC-X.14.001-15 [CC:L3036-3044] and BC-X.14.004's empty-`<field>` error-taxonomy row [CC:L3351], informational -- documented for completeness, no dedicated VP cell)
The empty-`<field>` guard (`jr field options ""` exits 64 with `Field '' not found. The field name must not be empty.`, zero HTTP calls, zero cache reads) is pre-existing `src/cli/field.rs::resolve_field_id` behavior, unaffected by this story's label-resolution fix. See BC-X.14.004's cross-reference row for the same condition. No new test is added for this AC.
**Test:** N/A (informational); existing `tests/field_options.rs::test_bc_x_14_001_empty_field_name_exits_64_zero_http` continues passing unmodified. Also implements BC-X.14.001's
Behavior paragraph's empty-`<field>` guard-ordering description [CC:L2624-2633] and the
Postconditions bullet describing when `GET /rest/api/3/field` is NOT called (empty `<field>`, a
`customfield_NNNNN` literal, or a warm-cache hit) [CC:L2812-2823] (informational -- doc-only
correction, no behavior change; existing behavior pinned by
`tests/field_options.rs::test_bc_x_14_001_empty_field_name_exits_64_zero_http`,
`test_bc_x_14_001_customfield_bypass_skips_list_fields`, and
`test_bc_x_14_001_warm_cache_resolves_without_list_fields_call`).

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
| EC-X.14.001-7 **[added pass-9, ADV-C14-F3-P9-007c]** | A source `allowedValues`/`validValues` entry missing `id` and/or its label-source field(s) (the GDPR-restricted or config-broken option case) | The entry is NEVER dropped -- both normalizers emit exactly one `FieldOption` per source item, degrading only the missing field(s) to `None` (never-drop invariant) |
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

**[RECOMPUTED pass-10, P10-010 -- the prior "~2,800" figure for "This story spec" was an
order-of-magnitude undercount.]** As of the D-387 mechanical-coverage restructure, this story
file is 822 lines / ~70,700 characters (`wc -l`/`wc -c` on
`.factory/cycles/cycle-014/phase-f3-stories/S-cycle14-field-options-name-label.md`) -- eight
Revision Note sections (pass-3 through pass-10) documenting adversarial-review history, plus the
Narrative, BC table, nine ACs, and the Coverage Scope (D-387) section, all of which an
implementing agent must read in full to follow the citation trail back to `cross-cutting.md`.

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec (full file, all Revision Notes + Coverage Scope section) | ~31,500 |
| Referenced code (`src/cli/field.rs` normalizer region + `handle`'s Step 2, `src/types/jira/editmeta.rs::AllowedValue`, `src/api/jira/issues.rs::get_createmeta_fields` doc comment) | ~2,200 |
| Test files (`tests/field_options.rs` -- grep-scoped to the renamed test + the new VP-580-013 cells) | ~1,800 |
| Tool output overhead | ~1,000 |
| **Total** | **~36,500** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~18%** |

~18% stays within the 20-30% per-story ceiling (story-writer Rules), so no further split is
required by this recompute.

## Tasks

> **D-386 binding instruction for all test-writing tasks below (1-5):** The test-writer MUST read
> the cited VP clause(s) in `cross-cutting.md` in full before writing; the VP text, not this
> story, is the source of truth for cell contents. AC-001 through AC-005's `**Test:**` lines above
> name the exact VP-580-013 sub-clause(s) and `cross-cutting.md` line range each task implements --
> follow those citations to the source text rather than relying on any fixture/value summary in
> this story.

1. [ ] Write the example-matrix tests for `normalize_from_allowed_values_at_depth` (AC-001, AC-002) as THREE separate pure unit tests (not one) in `src/cli/field.rs`'s `#[cfg(test)] mod tests`, per the Revision Note's Red Gate density fix (ADV-C14-F3-P4-001) -- each function bundles its RED cell with its GREEN sibling combinations so the whole function is RED pre-fix -- `test-writer`:
   - 1a. [ ] top-level matrix: value-only, name-only, both, neither (EC-X.14.001-8..11), all four cells asserted in ONE `#[test]` fn
   - 1b. [ ] cascading-child-level matrix: the same four combinations at depth >= 1, in a SECOND, separate `#[test]` fn
   - 1c. [ ] the two cells from VP-580-013(1)'s EC-X.14.001-12 fixtures (cross-cutting.md ~L3099-3105, binding -- see AC-002's Test line) asserted in a THIRD `#[test]` fn, per that clause's own deserialization requirement (each cell built by deserializing the JSON fixture into `AllowedValue`, not by constructing the struct directly)
2. [ ] Write the test function for VP-580-013(2) (cross-cutting.md ~L3106-3110, binding -- recursive `AllowedValue` proptest strategy; see AC-001's Test line), in `src/cli/field.rs`'s `#[cfg(test)] mod tests` (alongside its existing `proptest!` blocks) -- `test-writer`
3. [ ] Write the test function for VP-580-013(3) (cross-cutting.md ~L3110-3113, binding -- companion serde key-set property; see AC-001's Test line), in `src/cli/field.rs`'s `#[cfg(test)] mod tests` -- `test-writer`
4. [ ] Write the M3 regression against a hand-written expected output (AC-004), in `src/cli/field.rs`'s `#[cfg(test)] mod tests` -- `test-writer`
5. [ ] Write the `--value` filter system-field cell (AC-003), in `src/cli/field.rs`'s `#[cfg(test)] mod tests` (`filter_one` is a private fn, unreachable from the external `tests/field_options.rs` integration binary) -- `test-writer`
6. [ ] Confirm Red Gate density per the Revision Note's tally (ADV-C14-F3-P4-001, corrected pass-6 ADV-C14-F3-P6-007): 7 new test functions total (1a, 1b, 1c, 2-proptest, 3-key-set, 4-M3-regression, 5-`--value`-filter). RED = {1a, 1b, 1c, 2, 5} = 5 functions FAIL against current code (each contains at least one behavior-changing cell: name-only top-level, name-only cascading child, the `value: null` cell, the proptest's general case, `--value` system-field name match). GREEN = {3, 4} = 2 functions PASS unchanged before and after: test 3 (serde key-set property) and test 4 (M3 regression fixture) are BOTH `PRE-EXISTING-BEHAVIOR` -- justified but NOT exempt, both remain in the denominator as non-RED tests (test 3 was misclassified `FRAMEWORK-WIRING`/`WIRING-EXEMPT` at pass-4; corrected pass-6, ADV-C14-F3-P6-007, since this story has no stub for `WIRING-EXEMPT` to apply to). `TOTAL_NEW_TESTS = 7`, `EXEMPT_TESTS = 0`, denominator `= 7`, `RED_TESTS = 5`, `RED_RATIO = 5/7 ~= 0.71 >= 0.5` -- PASSES honestly; neither Option A (stub rollback) nor Option B (`mutation_testing_required: true` + PR disclosure) is invoked. Record this exact tally in `.factory/cycles/cycle-014/S-cycle14-field-options-name-label/implementation/red-gate-log.md` per per-story-delivery.md's Red Gate Log Format, with BOTH test 3's and test 4's rows tagged `rationale_category: PRE-EXISTING-BEHAVIOR`. No stub needed: `normalize_from_allowed_values_at_depth`, `normalize_from_allowed_values`, `normalize_from_valid_values`, `filter_options`, and `filter_one` all already exist in `src/cli/field.rs` -- this story modifies existing logic in place, so no new symbol requires a `todo!()` scaffold.
7. [ ] Change `label: v.value.clone()` to the presence-based `value.or(name)` fallback in `normalize_from_allowed_values_at_depth` (AC-001, AC-002) -- `implementer`
8. [ ] Confirm Green Gate: all tests pass
9. [ ] Rename `tests/field_options.rs::test_bc_x_14_001_field_name_human_name_resolves_via_partial_match` and correct its doc comment (AC-007)
10. [ ] Correct all stale-wording sites listed in AC-006 EXCEPT `src/types/jira/editmeta.rs` (`src/cli/mod.rs` x3, `src/cli/field.rs` x2, `src/api/jira/issues.rs` x1, `tests/field_options.rs` x2 (comments, verified pass-10: ~L1436 `// AC-011 — <field> resolution (customfield_NNNNN bypass / list_fields + partial_match)` section banner AND ~L2050 `// "labels" is a human/system field name, not a customfield_NNNNN literal, so it resolves via list_fields() + partial_match first.`), `README.md`, `CLAUDE.md`) -- see Task 11 for the `src/types/jira/editmeta.rs` edits
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

**[Converted to table pass-9, ADV-C14-F3-P9-013, per `story-template.md`'s mandatory `| Tool | Version | Purpose |` shape.]**

| Tool | Version | Purpose |
|------|---------|---------|
| `serde` / `serde_json` | `1` (pinned `Cargo.toml`, unchanged -- no new dependency, no version-pin change) | (De)serializing `AllowedValue`/`FieldOption` fixtures in the new VP-580-013 test cells, including Task 1c's deserialization requirement (build cells via JSON deserialization, not direct struct construction) |
| `proptest` | `1` (pinned `Cargo.toml`, unchanged -- no new dependency, no version-pin change) | The new recursive `AllowedValue` proptest strategy (VP-580-013(2), Task 2) |

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
