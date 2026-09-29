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
  - "src/cache.rs"
  - "src/cli/issue/field_resolve.rs"
  - "tests/field_options.rs"
  - "tests/issue_edit_field.rs"
  - "README.md"
  - "CLAUDE.md"
  - "CHANGELOG.md"
  - ".cargo/mutants.toml"
  - "docs/specs/cargo-mutants-policy.md"
  - "Cargo.toml"
input-hash: "f8c217d"
traces_to: "BC-X.14.001, BC-X.14.003, BC-X.14.004"
cycle: cycle-014-issue-triage-quickfixes
estimated_effort: medium
estimated_days: 2
target_module: "src/cli/field.rs"
subsystems: ["SS-02"]
# SS-02 (CLI Layer, src/cli/) owns this story's scope because its sole
# behavior-changing edit (normalize_from_allowed_values_at_depth) lives in
# src/cli/field.rs per ARCH-INDEX's Subsystem Registry (SS-02 row: "CLI
# Layer | src/cli/"). The src/types/jira/editmeta.rs doc-comment fix (owned
# by SS-07, Type Layer, per ARCH-INDEX's Subsystem Registry: "src/types/")
# and the src/api/jira/issues.rs doc-comment fix (owned by SS-04, Jira API
# Resources, per ARCH-INDEX's Subsystem Registry: "src/api/jira/") are both
# doc-comment-only edits with zero functional/behavioral change (see AC-006)
# -- they are NOT the same subsystem as SS-02, but are deliberately not
# added to `subsystems:` because neither edit functionally touches its
# owning subsystem, only corrects stale prose in it. Neither ARCH-INDEX nor
# `story-template.md`'s `subsystems:` frontmatter comment ("which
# subsystems this story touches") mandates listing every file a story
# merely touches with a doc-only edit, so rewording this justification is
# applied here rather than widening `subsystems:` to `["SS-02", "SS-04",
# "SS-07"]`.
depends_on: ["S-cycle14-api-query-param"]
blocks: []
# Depends on S-cycle14-api-query-param because all three cycle-014 stories
# touch src/cli/mod.rs and README.md (this story's own touches: the
# `Command::Field` about-text (~L128) / `FieldCommand::Options` about-text
# and field doc comment (~L1224, ~L1231-1232), and the README.md
# field-options row at ~L346 -- different lines from
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
version: "5.7"
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

## Revision History

Full pass-by-pass record moved to
[`S-cycle14-field-options-name-label.revision-history.md`](./S-cycle14-field-options-name-label.revision-history.md)
-- historical and non-normative; where anything there differs from this story body, this body
governs.

Current state, in brief: D-386 replaced paraphrased VP-580-013/BC-X.14.001 fixture copies in each
AC's `**Test:**` line with clause-reference citations ("bind by reference"). D-387 then deleted
the two hand-maintained clause-map tables those citations fed, replacing them with the
mechanically-checked `[CC:...]`/`[SCOPE:...]`/`[EXCLUDE:...]` citation system in "Coverage Scope
(D-387)" below. The Red Gate density tally was corrected once, from an original (pre-fix)
`EXEMPT_TESTS = 1` / `RED_RATIO = 5/6 ~= 0.833` to the current, honest `EXEMPT_TESTS = 0` /
`RED_RATIO = 5/7 ~= 0.71 >= 0.5`. Pass-14 then made three small fixes: it named the actual
enforcement mechanism (code citation + PR diff review) for the empty-`<field>`
guard-before-cache-read ordering and the Invariant 3 mirror obligation, corrected
`estimated_effort` to match STORY-INDEX/wave-schedule, and removed a stale exact-line-count claim
from the Token Budget section. Pass-17 then fixed a pattern of ACs citing `[CC:...]` clauses
without the binding sentence (AC-006/007/008/009), explicitly classified all four of AC-007's
`[CC:...]` citations instead of leaving two unclassified under a "both" label, and ran a full
sentence-level sweep of every `[CC:...]` tag in every AC, adding terse informational labels where
a cited sentence was not already covered by a named test this AC owns -- see the revision-history
file for the dated entry. Pass-18 then fixed a test mis-attachment in AC-007 (the ambiguous-name
regression test actually exercises the multiple-substring branch, not multiple-exact, so it was
re-attached and the multiple-exact branch was given its own, correct citation), filled a gap in
AC-007's coverage of the CC tag spanning L2634-2652 (three lead-in sentences -- the
`customfield_NNNNN` bypass, the shared cache-first contract, and the "mirrored, not shared"
relationship -- now each carry an inline label), corrected AC-005's description of BC-X.14.003's
rendering blockquote from two named cases to the three it actually names, and reworked the Token
Budget section to give a rounded, approximate estimate instead of exact counts. Pass-19 then
labeled AC-008's Invariant 3 citation's two remaining unlabelled sub-clauses (the shared
cache-file/functions sentence and the profile-scoped-isolation cross-reference) with their own
enforcement mechanisms -- see the revision-history file for the dated entry. Pass-21 then labeled
AC-008's and AC-009's Invariant 4 citations' after-arity half (the ordering between `handle`'s
Step 1 mode-selector arity check and Step 2 `resolve_field_id` call) with its own enforcement
mechanism -- see the revision-history file for the dated entry. Pass-22 then fixed a mis-scoped
test-attachment in AC-007 (the customfield-bypass label had claimed the integration-level test
`test_bc_x_14_001_customfield_bypass_skips_list_fields` pins the "same regex/case-sensitivity
convention as BC-3.4.015 Step 1" clause -- an integration test asserting `list_fields()` is
skipped cannot pin a regex/case-sensitivity rule; the regex half is now separately cited to the
unit test `src/cli/field.rs::test_bc_x_14_001_is_customfield_literal_accepts_and_rejects`, and the
case-sensitivity half is labeled informational, enforced by the unchanged
`is_customfield_literal`'s case-sensitive `starts_with` plus PR diff review) and a grammar fix in
AC-008/AC-009 ("the after-arity half enforced by" -> "the after-arity half is enforced by") -- see
the revision-history file for the dated entry. Pass-23 then fixed the Token Budget's stale
figures, attached the CLI-level "zero matches ... return 'not found'" sentence in AC-007 to its
actual pinning tests, and rescoped all four VP-580-013 fault-model citations (AC-001/002/003/004)
to name which fault(s) each AC's own tests kill -- see the revision-history file for the dated
entry. Pass-24 then fixed a fault-model exclusive-attribution defect in AC-001/AC-002/AC-004
(a non-exclusive-positive rewrite; see the revision-history file for the dated entry). Pass-25 then
widened Task 1c so each EC-X.14.001-12 fixture is asserted at both the top level and a
cascading-child level, rewrote AC-002's fault-(5) sentence to credit 1c's own child-level assertions
jointly with 1b instead of claiming 1c runs at a single tree level, pinned an empty-string
requirement on Task 2's `value`/`name` proptest strategies and softened AC-001's fault-(3) sentence
to rely on it, and replaced a near-verbatim quote in AC-009 with a paraphrase after one of its four
cited ranges turned out to use slightly different wording -- see the revision-history file for the
dated entry. Pass-26 then rewrote AC-003's fault-model attribution for function 5 as a
non-exclusive positive claim (it does kill fault (1), jointly with AC-001's EC-8 cell, rather than
killing none of the six faults), and pinned, in Task 1a/1b, the `neither` cell's output-length
assertion that AC-001 already claimed those cells make -- see the revision-history file for the
dated entry. Pass-27 (cross-story sweep, triggered by STORY-C's pass-27 findings) re-checked this
story for STORY-C's four pass-27 defect patterns and found none: this story has no wiremock or
subprocess cells in any fault-model attribution at all (every cell is a direct in-process call or
a `#[test]`/`proptest!` against a pure function, `normalize_from_allowed_values_at_depth`/
`normalize_from_valid_values`), so the fragment/fixture-mismatch pattern does not apply; this story
makes no "ONLY"/completeness claim about an external test suite; and this story's body never cites
`wave-holdout-scenarios.md` as an enforcement mechanism -- only its `holdout_anchors:` frontmatter
names its own holdout IDs. See the revision-history file for the dated entry.
Pass-28 (2026-09-28) fixed one cosmetic finding (P28-004) and ran the mechanical `inputs:` sweep
(P28-003), plus the same-pattern sweep dispatched by STORY-A's P28-001 finding. P28-004: the
Coverage Scope intro said "Six cycle-014-marked spans are intentionally left unlisted", but the
six bullets that follow enumerate eight spans in total (one bullet, the Trace-field-edits bullet,
covers three separate line ranges). The intro now reads "Six groups (eight spans)". P28-001
sweep: re-read the actual bodies of every named pre-existing test this story cites (the
`search_field_list`/`normalize_from_allowed_values_at_depth`/`normalize_from_valid_values`
unit tests in `src/cli/field.rs`, and the integration tests in `tests/field_options.rs` and
`tests/issue_edit_field.rs`) against their claimed line numbers and assertions; every citation
checked out (e.g. `test_bc_x_14_001_is_customfield_literal_accepts_and_rejects` at line 897,
`test_bc_x_14_001_normalizer_never_drops_degenerate_entries` at line 1135, and
`test_bc_x_14_001_normalizer_from_valid_values_never_drops_degenerate_entries` at line 1195,
matching this story's own pinned line numbers exactly) -- no overclaim of this shape was found in
this story. P28-003 (mechanical inputs sweep): grepped this story's body for every cited
repository file path, excluding files this story creates (including the future
`red-gate-log.md` implementation artifact Task 6 records into, and the sibling story and
holdout-scenario files), and compared the result against the frontmatter inputs list. Three cited
paths were missing and are added, each verified present on disk with ls: `.cargo/mutants.toml`
and `docs/specs/cargo-mutants-policy.md` (both cited in the STORY-C-dependency-rationale table's
negative claim that this story does NOT touch either file, which was itself verified against
`.cargo/mutants.toml`'s existing `src/cli/field.rs` entry), and `Cargo.toml` (cited for the pinned,
unchanged `serde`/`serde_json`/`proptest` dependency versions). No other cited path was found
missing. Story version bumped 5.4 -> 5.5 to record this pass.
Pass-29 (2026-09-28) fixed the Architecture Mapping section's "Reference:" line, which cited
`architecture/module-decomposition.md` and `architecture/dependency-graph.md` -- neither file
exists anywhere in this repository. The line now points at the real architecture index,
`.factory/specs/architecture/ARCH-INDEX.md`, and its Subsystem Registry section, which does exist
and does carry that exact heading. A follow-on sweep of every other `.factory/...`, `architecture/...`,
`specs/...`, and other non-`src/` file path cited anywhere in this story's body (15 distinct
citations, excluding the future `red-gate-log.md` implementation artifact Task 6 records into,
which this story creates rather than cites as pre-existing) found no other broken path -- all 15
resolve on disk, whether as full paths or as this story's established bare-filename shorthands
(`cross-cutting.md`, `prd-delta.md`, `wave-holdout-scenarios.md`, `story-template.md`). A second
sweep re-checked every PROSE reference to a numbered BC clause in this story's body -- every
"Invariant N" (Invariant 3, Invariant 4) and every "EC-X.14.001-N" and "VP-580-013(N)"/"sub-clause
(N)"/"clause (N)" citation (85 total instances) -- against the actual BC-X.14.001/003/004 text in
`cross-cutting.md`; this story cites no numbered "Postcondition N", "Precondition N", or "Fix step
N" clause at all (BC-X.14's own Postconditions/Preconditions are unnumbered bullets), and every
Invariant/EC/VP-sub-clause number checked matched the content it was attributed to. No mismatch was
found in this story. Story version bumped 5.5 -> 5.6 to record this pass.
Pass-30 (2026-09-28) fixed P30-001: AC-001's [CC:L2728] citation had blanket-labeled the whole
`FieldOption` contract-amendment paragraph "informational/inherited... SURVIVAL only", but that
paragraph contains testable sentences beyond the survival half. Re-read in full and relabeled
sentence by sentence: the type-change/degrade-to-`None` sentences keep the SURVIVAL label; the
"missing label-source field(s)" definition's M1/M2 half is now credited to this AC's own functions
1a/1b (name-only and neither cells); its M3 half is now a plain-prose cross-reference to AC-004's
function 4 (VP-580-013(4), cross-cutting.md ~L3113-3123); and the `children`
always-present-never-`Option` sentence is now credited to this AC's own function 3 key-set
assertion (VP-580-013(3)). A same-pattern sweep of every other "informational"/"inherited" label in
this story (23 labels checked across AC-001 through AC-009 and the Edge Cases table) found no
further defect of this shape -- every other multi-sentence citation in this story already carries
its own per-sentence attribution from earlier passes (P16 through P29), and every remaining
single-sentence "informational" label describes rationale, a structural/code-review fact, or
content the spec itself already marks informational (e.g. EC-X.7.002-style "no VP cell" rows) --
0 further labels changed. A companion sweep of every line-number citation into a `tests/` file
that also carries a symbol name (4 citations: `tests/field_options.rs` `~L1436`/`~L2050`
comments, `~L1487-1525` for `test_bc_x_14_001_field_name_ambiguous_exits_64`, and `~L1591` for
`test_bc_x_14_001_field_name_zero_match_exits_64`) verified each against the current file; all
four are accurate to within 1 line -- no fix required. Story version bumped 5.6 -> 5.7 to record
this pass.

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
groups (eight spans) of cycle-014-marked text are intentionally left unlisted, for the reasons
given:
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

## Narrative

- **As a** `jr field options <field>` user enumerating a system field's allowed values (e.g. `priority`, `components`, `versions`, `issuetype`)
- **I want to** see the field's real display name instead of `"(unnamed)"` (table) / `null` (JSON)
- **So that** `jr field options` is usable for system-typed fields, not just custom select fields, without changing the rendering contract for genuinely-nameless entries

## Behavioral Contracts

| BC | Role | Clauses this story implements |
|----|------|-------------------------------|
| BC-X.14.001 | PRIMARY (amended, cycle-014 F2) | Owned clauses: see `## Coverage Scope (D-387)`; the AC `[CC:...]` tags are authoritative |
| BC-X.14.003 | CROSS-REF (amended, cycle-014 F2, COUNT-NEUTRAL) | The UPDATED blockquote clarifying the rendering contract (`(unnamed)`/`null` for `None`) is unchanged -- only the upstream normalizer produces fewer `None` labels |
| BC-X.14.004 | CROSS-REF (amended, cycle-014, COUNT-NEUTRAL) **[ADDED pass-10, P10-006]** | The empty-`<field>` error-taxonomy row, which cross-references BC-X.14.001 EC-X.14.001-15 (same pre-existing condition, no new behavior) |

**Anchor justification:** BC-X.14.001 is the sole BC governing `jr field options`'s M1/M2 label-resolution normalizer (`cross-cutting.md`). BC-X.14.003 is cited as a cross-reference only because this story's fix changes what feeds INTO its rendering contract, not the contract itself (AC-005 traces to it to make that boundary explicit and count-neutral). BC-X.14.004 is cited as a cross-reference for the same reason: its empty-`<field>` error-taxonomy row documents the same pre-existing, unmodified condition as BC-X.14.001 EC-X.14.001-15 (AC-009 traces to it to make that cross-reference explicit and count-neutral) -- **[ADDED pass-10, P10-006]** this BC was bound by AC-009 since the story's original authoring but was missing from `bcs:`/`behavioral_contracts:` and this table; fixed here to close that gap, mirroring how BC-X.14.003 is handled.

## Acceptance Criteria

### AC-001 (traces to BC-X.14.001 Behavior -- M1/M2 label-resolution fallback, EC-X.14.001-7..11)
`src/cli/field.rs::normalize_from_allowed_values_at_depth` sets `label = v.value.clone().or_else(|| v.name.clone())` (presence-based, not emptiness-based) at every depth of the cascading-option tree, for the four combinations {value-only, name-only, both, neither} at both the top level and at least one cascading child level.
**Test:** Implements VP-580-013's "What it proves" statement [CC:L3093-3099] and sub-clauses (1)
(top-level and cascading-child-level example matrices) [CC:L3099-3105], (2) (recursive
`proptest!`) [CC:L3106-3110], and (3) (serde key-set property) [CC:L3110-3113], plus the fault
models this AC's own tests kill [CC:L3129-3134]: fault (1) (the fallback removed entirely,
pre-fix code `label: v.value.clone()` -- killed by the EC-X.14.001-8 name-only cell in function
1a), fault (2) (`name` preferred over `value` -- killed by the "both" cell, EC-X.14.001-9, in
function 1a), and fault (5) (the fallback applied only at the top level -- killed by function 1b,
the cascading-child-level matrix). Fault (3) (an emptiness-based fallback, `Some("")` falling
through to `name`) is also, non-exclusively, killed by this AC's own function 2, the recursive
`proptest!` over `Option<String>` [CC:L3106-3110]: relying on Task 2's requirement that the
`value`/`name` string strategies be able to produce the empty string, its generator constructs
`value`/`name` directly as `Option<String>` and will generate `value: Some("")` alongside a
populated `name` often enough to fail the `label == value.clone().or(name.clone())` assertion under
that fault -- AC-002's own `{"value": ""}` cell remains the primary, deterministic
(non-probabilistic) owner of this fault. Fault (4)
(explicit `null` treated as present) is primarily killed by AC-002's own `{"value": null}` cell
(verified: function 2's proptest constructs `AllowedValue` directly in Rust, never through
`serde_json` deserialization, so it cannot observe a deserializer-level null-handling defect).
Fault (6) (the fallback leaking into the M3 normalizer) is primarily killed by AC-004's own
function 4 cell (verified: neither of this AC's own functions calls
`normalize_from_valid_values`, so they cannot observe an M3-only regression). The
presence-based `Some("")`-wins and
explicit-null-falls-through sentences embedded in [CC:L3093-3099], and the two EC-X.14.001-12
cells embedded in [CC:L3099-3105] (the `{"value": ""}` and `{"value": null}` fixtures), are
AC-002's function 1c, not this AC's own cells -- see AC-002's Test line. Also implements
BC-X.14.001's M1/M2-vs-M3 key-spelling paragraph's `.value`-falls-back-to-`name` parenthetical
(the first #861 amendment named in prd-delta.md Item 2) [CC:L2708-2715] (this range's
id-vs-label key-spelling facts for M1/M2 vs. M3, and its JSM-value-key-naming-collision rationale
sentence, are informational -- structural/design-rationale, not independently tested beyond the
fallback rule itself, which functions 1a/1b/2 cover), the `FieldOption` contract
amendment [CC:L2728] and `value`-else-`name` fallback paragraph [CC:L2730-2745] (this range's
system-typed-field examples, pre-fix-defect history, and research-gap rationale sentences are
informational -- background/rationale, not distinct test obligations beyond the value-else-name
rule already covered by functions 1a/1b/2) and Edge Cases
EC-X.14.001-7 [CC:L2943-2961], EC-X.14.001-8 [CC:L2964-2968], EC-X.14.001-9 [CC:L2969-2972],
EC-X.14.001-10 [CC:L2973-2976], and EC-X.14.001-11 [CC:L2977-2981]. Everything each cited range
specifies is binding in its entirety and must be implemented exactly as written there; this story
does not restate or narrow any of it. Of these citations, EC-X.14.001-7 [CC:L2943-2961] is informational/inherited for THIS AC's own
test cells specifically: unlike clauses (1)-(3) and EC-8..11, which assert the resolved label
VALUE, this edge case describes a degenerate entry's SURVIVAL in the output array (never dropped,
`id`/`label` degrading to `None` instead) -- functions 1a and 1b's `neither` cell additionally
assert the output vector's entry count is unchanged for that cell, and the existing, unmodified
regression test `src/cli/field.rs::test_bc_x_14_001_normalizer_never_drops_degenerate_entries`
(present at `src/cli/field.rs` L1135) already proves the never-drop invariant for entries missing
both `id` and their label source(s) for M1/M2's `normalize_from_allowed_values`; since
EC-X.14.001-7 binds BOTH normalizers, not just M1/M2, the sibling M3 regression test
`src/cli/field.rs::test_bc_x_14_001_normalizer_from_valid_values_never_drops_degenerate_entries`
(present at `src/cli/field.rs` L1195) proves the same never-drop invariant for M3's
`normalize_from_valid_values`.
**[P30-001] [CC:L2728]'s own sentences are treated individually here rather than as one blanket
"informational/SURVIVAL only" citation, since L2728 contains testable sentences beyond the
survival half:** its type-change-and-degrade-to-`None` sentences (`id`/`label` changed from
`String` to `Option<String>`, and a genuinely-missing source field degrading to `None` rather than
being coerced to an empty string or dropped) remain the SURVIVAL half and keep the label above --
informational, for the same reason as EC-X.14.001-7: they describe survival, not the resolved
label VALUE, and are proven by the same two never-drop regression tests just cited, corroborated by
functions 1a/1b's `neither`-cell entry-count assertion. Its "'Missing label-source field(s)' means,
precisely" sentence carries two independently-owned halves, not one informational blob: the M1/M2
half (missing BOTH `value` AND `name`) is directly observed by THIS AC's own functions 1a and 1b --
the name-only cell (exactly one of the two present) and the `neither` cell (both absent), at both
tree levels, are exactly the boundary this definition draws -- so this half is NOT informational,
it is this AC's own tested content. The M3 half of that same sentence (no fallback -- M3's `label`
is read directly from the wire `.label` key) is NOT observed by any cell of this AC -- it is a
plain-prose cross-reference to AC-004's function 4, whose first fixture entry exercises M3's
direct-`.label`-read behavior (cross-reference: VP-580-013(4), cross-cutting.md ~L3113-3123). Its
closing `children`-invariant sentence ("always present, never `Option`") is likewise directly
observed by THIS AC's own function 3, not informational: the serde key-set assertion
(VP-580-013(3)) checks that `children` is present at every depth, never omitted or nulled.
Story-specific mapping: all three VP clauses land in
`src/cli/field.rs`'s `#[cfg(test)] mod tests`; clause (1)'s top-level matrix is function 1a (RED)
and its cascading-child-level matrix is function 1b (RED) -- split into separate functions so the
Red Gate density check (Task 6) counts RED/GREEN at the function level, not per-cell (tally: 7 new
test functions, 0 exempt, `RED_TESTS = 5`, `RED_RATIO = 5/7 ~= 0.71 >= 0.5`; full history in
`S-cycle14-field-options-name-label.revision-history.md`, ADV-C14-F3-P4-001); clause (2) is
function 2 (RED); clause (3) is function 3
(GREEN, `rationale_category: PRE-EXISTING-BEHAVIOR`, non-exempt -- pass-6, ADV-C14-F3-P6-007).

### AC-002 (traces to BC-X.14.001 EC-X.14.001-12)
A wire `"value": ""` (present-but-empty string) wins over a populated `name` -- `label: Some(String::new())`, never falling through to `name` merely because the value string is empty. A wire `"value": null` deserializes to `AllowedValue.value: None`, which DOES fall through to `name`.
**Test:** Implements VP-580-013 sub-clause (1)'s EC-X.14.001-12 fixtures [CC:L3099-3105] (the two
`{"value": ...}` cells embedded in clause (1)'s text), BC-X.14.001's EC-X.14.001-12 edge case
[CC:L2982-2990] (this range's "rendered as a blank cell (table) / `""` (JSON)" sentence is
informational -- `Some("")` renders via ordinary string/JSON serialization with no special-case
code path, unlike the `None` substitution BC-X.14.003/AC-005 covers, so no dedicated test is
needed for it), and the fault models this AC's own tests kill [CC:L3129-3134]: fault (3) (an
emptiness-based fallback, `Some("")` falling through to `name` -- killed by the `{"value": ""}`
cell) and fault (4) (explicit `null` treated as present, never falling through to `name` --
killed by the `{"value": null}` cell). This AC's own cells also kill fault (1) (the fallback
removed entirely): the `{"value": null}` cell expects `Some("N")`, but a `label: v.value.clone()`
implementation with no `.or(name)` fallback would return `None` for that cell's `value: None`
case. They also kill fault (2) (`name` preferred over `value`): the `{"value": ""}` cell expects
`Some("")`, but a `name.clone().or(value.clone())` implementation would return `Some("N")` for
that cell's populated `name`. AC-001's own function 1a/1b cells remain the primary owners of
faults (1) and (2) (they exercise both combinations at every EC-8..11 cell, not just these two
EC-12 fixtures). Fault (5) (the fallback applied only at the top level) is killed jointly by this
AC's own function 1c and AC-001's own function 1b: 1c's two EC-12 cells are each now asserted at
BOTH the top level and at least one cascading-child level (see Task 1c), so 1c's own child-level
assertions directly observe child-level behavior for the `Some("")`-wins and
explicit-null-falls-through cases specifically, while 1b's cascading-child-level matrix covers the
remaining EC-8..11 combinations (value-only, name-only, both, neither) at a cascading-child level --
together the two functions exercise every combination this story's fallback rule defines, at both
tree levels. Fault (6) (the fallback leaking into
the M3 normalizer) is primarily killed by AC-004's own function 4 cell (verified: neither of this
AC's cells calls `normalize_from_valid_values`, so they cannot observe an M3-only regression).
Everything each cited
range specifies is binding in its entirety and must be implemented exactly as written there;
this story does not restate or narrow any of it. Story-specific mapping: lands in
`src/cli/field.rs`'s `#[cfg(test)]
mod tests` as function 1c, bundled with its GREEN sibling cells so the Red Gate density check
(Task 6) counts RED/GREEN at the function level, not per-cell (ADV-C14-F3-P4-001, corrected
pass-6 ADV-C14-F3-P6-007; full history in
`S-cycle14-field-options-name-label.revision-history.md`) -- RED.

### AC-003 (traces to BC-X.14.001 EC-X.14.001-13)
`jr field options --value <substring>` (BC-X.14.002, its own contract unchanged) now also matches system-field option names via the fallback label, as a downstream consequence of AC-001 -- not a new filter rule.
**Test:** Implements VP-580-013 sub-clause (5) [CC:L3123-3128], BC-X.14.001's EC-X.14.001-13 edge
case [CC:L2991-3003], and the fault models VP-580-013 lists [CC:L3129-3134]: function 5 also
kills fault (1) (the fallback removed entirely, pre-fix code `label: v.value.clone()` -- RED
against that pre-fix code per Task 6), non-exclusively with AC-001's own EC-8 cell, which remains
the primary/owning kill vehicle for that fault; it cannot observe faults (2)-(6) (value-free flat
fixture, M1/M2 only -- its `priority`-shaped fixture carries no `value` key at all, so the
value-vs-name preference (2), emptiness-vs-presence (3), explicit-null (4), and top-level-only (5)
faults are all indistinguishable from correct behavior on this fixture, and it never calls
`normalize_from_valid_values` (M3), so it cannot observe fault (6) either) -- see AC-001's,
AC-002's, and AC-004's Test lines for the owning cells of faults (2)-(6).
Everything each cited range specifies is binding in its entirety and must be implemented exactly
as written there; this story does not restate or narrow any of it. Story-specific mapping: lands in
`src/cli/field.rs`'s `#[cfg(test)] mod tests` as function 5 (`filter_one` is a private fn,
unreachable from the external `tests/field_options.rs` integration binary) -- RED.

### AC-004 (traces to BC-X.14.001 "M3 is UNCHANGED and ALREADY CORRECT" paragraph AND the "Scope boundary -- READ-SIDE ONLY" paragraph [D-378] **[widened pass-9, ADV-C14-F3-P9-007a]**)
`src/cli/field.rs::normalize_from_valid_values` (M3, JSM requesttype-fields) is NOT modified by this story and does NOT acquire a `name`-fallback of its own -- it already reads `.value` for id and `.label` for display, which was already correct before this story. Separately, per BC-X.14.001's "Scope boundary -- READ-SIDE ONLY, WRITE-side explicitly out of scope [D-378]" paragraph, the WRITE-side `--field` value-matching path (`src/cli/issue/field_resolve.rs::find_option_match`/`resolve_option_value`) MUST NOT be touched by this story.
**Test:** Implements VP-580-013 sub-clause (4) [CC:L3113-3123] and the fault models this AC's own
tests kill [CC:L3129-3134]: fault (6) (the fallback leaking into the M3 normalizer -- killed by
function 4's M3 regression-guard comparison against a hand-written expected output). Faults (1),
(2), and (5) are primarily killed by AC-001's own cells, and faults (3) and (4) are primarily
killed by AC-002's own cells (verified: function 4 exercises only `normalize_from_valid_values`
(M3) and never calls the M1/M2 normalizer these five faults live in, so it structurally cannot
observe any of them). Everything each cited range specifies is binding in its entirety and
must be implemented exactly as written there; this story does not restate or narrow any of it.
Story-specific mapping: lands in
`src/cli/field.rs`'s `#[cfg(test)] mod tests` as function 4 -- GREEN (`rationale_category:
PRE-EXISTING-BEHAVIOR`, non-exempt). Also implements BC-X.14.001's "M3 is UNCHANGED and was
ALREADY CORRECT" paragraph [CC:L2777-2781] via that same function 4, and the "Scope boundary --
READ-SIDE ONLY, WRITE-side explicitly out of scope [D-378]" paragraph [CC:L2759-2775] via a
reviewable check, not a runtime test: at PR review, `git diff`
shows zero changes to `src/cli/issue/field_resolve.rs`. That paragraph's own reachability
refutation is separately corroborated by the pre-existing, unmodified regression test
`tests/issue_edit_field.rs::test_bc_3_4_017_field_priority_without_flag_does_not_trigger_gate_b`
(verified present), which this story's diff does not touch.

### AC-005 (traces to BC-X.14.003 UPDATED blockquote, COUNT-NEUTRAL)
The rendering contract for a `None` label (`"(unnamed)"` in table output, `null` in `--output json`) is byte-for-byte UNCHANGED by this story -- only the upstream normalizer (AC-001) now produces fewer `None` labels for system fields.
**Test:** Implements BC-X.14.003's UPDATED rendering-contract blockquote [CC:L3247-3254].
Everything the cited blockquote specifies is binding in its entirety and must be
implemented exactly as written there; this story does not restate or narrow any of it.
Story-specific mapping: regression guard only, no new test needed -- the blockquote's three named
renderings (`NULL_GLYPH`/`"(unnamed)"` table, `null` JSON) are already proven, unmodified, by the existing tests
`src/cli/field.rs::test_bc_x_14_003_render_option_rows_degenerate_glyphs` (table) and
`src/cli/field.rs::test_bc_x_14_003_field_option_json_serializes_none_as_null_not_omitted` (JSON),
mirrored at the integration level by
`tests/field_options.rs::test_bc_x_14_003_degenerate_entry_table_glyphs` and
`tests/field_options.rs::test_bc_x_14_003_degenerate_entry_json_emits_null_not_glyph` (all four
verified present, none touched by this story).

### AC-006 (traces to prd-delta.md F4 stale-wording obligation, PASS-9/13/33, P9-002/P13-002/P33-002; BC-X.14.001 F4 editmeta doc-comment paragraph [CC:L2747-2757])
The following stale "custom field" / "`partial_match`" wording is corrected in the same PR as AC-001, since after this fix the command also serves system fields, not custom fields only, and field-name resolution has never actually gone through `partial_match` (a pre-existing, unrelated spec/code drift already corrected at cycle-014 F2 in `cross-cutting.md`, not re-litigated here):
- `src/cli/mod.rs`: the `Command::Field` about-text (~L128, "Discover custom-field allowed options"), the `FieldCommand::Options` about-text (~L1224, "Enumerate a custom field's allowed options"), and the `field` doc comment (~L1231-1232, "resolved via `list_fields()` + `partial_match`")
- `src/cli/field.rs`: the module doc comment (L1, "enumerate a custom field's allowed options") and the `handle` Step 2 comment (~L134, "resolved via the per-profile fields cache / `list_fields()` + `partial_match`")
- `src/api/jira/issues.rs::get_createmeta_fields`'s doc comment (~L1130, "Enumerate a custom field's allowed options...")
- `src/types/jira/editmeta.rs`'s `AllowedValue` struct-level doc comment (~L64-77) and its `name` field-level doc comment (~L83-85), both of which currently describe `name` as "unused in v1 resolution logic" / "Future: v2 cascade-select name matching" -- stale as of this story, since `jr field options`'s M1/M2 label-resolution fallback (AC-001) is now a real, shipped read-side consumer of `name`
- `tests/field_options.rs`'s comments (~L1436 section banner, ~L2050)
- `README.md`'s `jr field options <NAME>` row (~L346)
- `CLAUDE.md`'s `field.rs` file-tree line (~L61)
**Test:** N/A (doc-accuracy); presence checked at PR review. This changes `jr field options --help` output text -- cosmetic, not a behavior change. Everything the cited clause(s) specify is binding in its entirety and must be implemented exactly as written there; this story does not restate or narrow any of it.

### AC-007 (traces to prd-delta.md F4 obligation PASS-8, P8-002)
`tests/field_options.rs::test_bc_x_14_001_field_name_human_name_resolves_via_partial_match` is renamed to a name reflecting `search_field_list` (the actual resolution algorithm -- single exact match auto-resolves; multiple exact -> exit 64; else single substring auto-resolves; multiple substring -> exit 64), and its doc comment is corrected to match.
**Test:** the renamed test itself, run green. Also implements BC-X.14.001's Behavior paragraph's
`search_field_list` exact-then-substring algorithm description [CC:L2634-2652]. This range opens
with three lead-in sentences ahead of that algorithm, each now carrying its own label: the
`customfield_NNNNN` literal bypass sentence -- split into its two independently-tested halves
(P22-003): the BYPASS half (a `customfield_NNNNN` literal skips `list_fields()` entirely) is
pinned by `tests/field_options.rs::test_bc_x_14_001_customfield_bypass_skips_list_fields`; the
REGEX half (which strings count as a `customfield_NNNNN` literal at all) is a separate claim that
integration test cannot pin -- it is pinned instead by the unit test
`src/cli/field.rs::test_bc_x_14_001_is_customfield_literal_accepts_and_rejects` (verified present,
~L897); the CASE-SENSITIVITY half ("same ... convention as BC-3.4.015 Step 1") is (informational
-- enforced by the unchanged `is_customfield_literal` (case-sensitive `starts_with`, verified
present, ~L474-479) plus PR diff review; mirrored from `field_resolve.rs` per Invariant 3, not
independently re-tested here); the same
cache-first `fields.json` contract sentence (shared `list_fields`/`read_fields_cache`/
`write_fields_cache`), pinned by
`tests/field_options.rs::test_bc_x_14_001_warm_cache_resolves_without_list_fields_call`, with its
"no new cache family" clause enforced by PR review (no new cache-family module or file is added by
this story's diff); and the "the resolution logic itself is mirrored, not shared (Invariant 3)"
sentence, informational, enforced the same way AC-008 uses for this identical text -- at PR
review, `git diff` shows zero changes to `src/cli/issue/field_resolve.rs`. For the
exact-then-substring algorithm itself (the single-exact-match branch is owned by the renamed test
itself, per Task 9; the multiple-exact branch is pinned only by the unit test
`src/cli/field.rs::test_bc_x_14_001_search_field_list_exact_multiple_is_err` -- corrected here
(P18-001) after verification against both `search_field_list` (`src/cli/field.rs` ~L490-521) and
the test body (`tests/field_options.rs` ~L1487-1525) showed the integration-level regression cited
below was previously mis-attached to this branch: that test's fixture (`"SOC Client A"`/`"SOC
Client B"` against query `"SOC Client"`) has neither candidate name equal to the query exactly, so
`exact.len() == 0` and both candidates fall through to the substring check instead; the
single-substring and multiple-substring branches are informational -- doc-only correction, no
behavior change -- pinned by the six `search_field_list` unit tests named below, plus, for the
multiple-substring/ambiguous branch specifically, the integration-level regression
`tests/field_options.rs::test_bc_x_14_001_field_name_ambiguous_exits_64` (verified present, and
now correctly re-attached to the branch it actually exercises); the same range's closing "zero
matches of either kind return \"not found\"" sentence (cross-cutting.md ~L2643-2644) is a
separate, CLI-level claim the six `search_field_list` unit tests do not pin on their own -- it is
pinned by `tests/field_options.rs::test_bc_x_14_001_field_name_zero_match_exits_64` (~L1591,
verified present -- the integration-level exit-64 "not found" assertion) together with
`src/cli/field.rs::test_bc_x_14_001_search_field_list_zero_match_returns_none` (~L957, verified
present -- the pure resolver's `None` return for zero matches), both informational/pre-existing
regression pins (doc-only correction, no behavior change); this
range's trailing "Exactly ONE of three MODE-SELECTOR flags... selects the enumeration" fragment is
pre-existing Invariant-1 mode-selector-arity text, not part of the `search_field_list` algorithm
description this AC traces to -- out of this AC's scope, covered instead by VP-580-006 elsewhere
in the spec), the Preconditions bullet's matching `search_field_list`-NOT-`partial_match`
correction [CC:L2807-2808] (informational -- doc-only correction, no behavior change; existing
behavior pinned by the same six `search_field_list` unit tests), and the same correction as it
appears in Edge Cases EC-X.14.001-2 [CC:L2915-2915] and EC-X.14.001-6
[CC:L2935-2935] (both informational --
doc-only correction, no behavior change; existing behavior pinned by
`src/cli/field.rs::test_bc_x_14_001_search_field_list_exact_single_match`, `_case_insensitive`,
`_substring_single_match`, `_zero_match_returns_none`, `_exact_multiple_is_err`, and
`_substring_multiple_is_err`). EC-X.14.001-1 [CC:L2912-2912] (informational -- doc-only
correction, no behavior change) is cited separately (P16-004): it describes the
`customfield_NNNNN` literal BYPASSING `list_fields()`/`search_field_list` entirely, so the six
`search_field_list` unit tests above cannot observe it -- existing behavior for this edge case is
instead pinned by `tests/field_options.rs::test_bc_x_14_001_customfield_bypass_skips_list_fields`
(~L1442, verified present). [CC:L2634-2652] additionally binds two warm-cache branches that
none of the above tests exercise -- a warm cache lacking `<field>` triggers exactly one refetch,
and a warm-cache ambiguity exits 64 without a refetch (no repository test covers either branch
directly) -- these two sub-clauses are enforced by the unchanged
`src/cli/field.rs::resolve_field_id` (~L451-462, verified against current code) plus PR diff
review (no change to `resolve_field_id` in this story's diff). Everything the cited clause(s)
specify is binding in its entirety and must be implemented exactly as written there; this story
does not restate or narrow any of it.

### AC-008 (traces to BC-X.14.001 EC-X.14.001-14 [CC:L3004-3035], informational -- documented for completeness, no dedicated VP cell)
System-typed field NAME resolution (the step upstream of the label fallback, e.g. resolving the string `"Priority"` to a field id) is pre-existing `search_field_list`/`resolve_field_id` behavior, unaffected by this story's label-resolution fix. No new test is added for this AC; existing `search_field_list` unit tests already cover it as a regression guard.
**Test:** N/A (informational); existing `test_bc_x_14_001_search_field_list_*` unit tests continue
passing unmodified. Also implements BC-X.14.001 Invariant 3's `customfield_NNNNN` bypass /
`fields.json` cache-first "mirrored, not shared" description [CC:L2889-2896] and Invariant 4's
`search_field_list`-vs-`partial_match` description (including the empty-`<field>` exit-64
ordering recap) [CC:L2897-2909]. Invariant 4's field-resolution-algorithm claim
(exact/substring/multiple-match) is informational (doc-only correction, no behavior change;
existing behavior pinned by
`src/cli/field.rs::test_bc_x_14_001_search_field_list_exact_single_match`, `_case_insensitive`,
`_substring_single_match`, `_zero_match_returns_none`, `_exact_multiple_is_err`,
`_substring_multiple_is_err`, and
`tests/field_options.rs::test_bc_x_14_001_customfield_bypass_skips_list_fields`); the
empty-`<field>` exit-64 ordering recap embedded in the same range is a SEPARATE sub-clause those
six tests do not exercise -- it is enforced by code citation plus PR diff review, the same
mechanism AC-009 uses for this identical clause: `src/cli/field.rs::resolve_field_id`'s
`query.is_empty()` guard precedes its only cache read (verified against current code), and PR
diff review confirms `resolve_field_id` is unchanged by this story's diff. That covers only the
before-cache-read half; the after-arity half is enforced by `src/cli/field.rs::handle`'s Step 1
(`resolve_field_context`, ~L125) preceding Step 2 (`resolve_field_id`, ~L136), unchanged by this
diff (AC-006 edits only the ~L134 comment) + PR diff review. Invariant 3's own
opening sentence -- that the `customfield_NNNNN` bypass and `fields.json` cache-first contract use
the SAME algorithm and the SAME cache file/functions (`read_fields_cache`/`write_fields_cache`/
`list_fields`) -- is enforced by the unchanged `src/cli/field.rs::resolve_field_id`
(`read_fields_cache` ~L451, `list_fields` ~L458, `write_fields_cache` ~L460; verified against
current code) plus PR diff review, plus
`tests/field_options.rs::test_bc_x_14_001_warm_cache_resolves_without_list_fields_call` (verified
present). Invariant 3's closing clause -- "same profile-scoped isolation as BC-3.4.015" -- is
informational and inherited: `resolve_field_id`'s `profile: &Profile` parameter is threaded
directly into both `cache::read_fields_cache(profile)` and `cache::write_fields_cache(profile,
&fresh)` (verified against both fns' signatures in `src/cache.rs`), so the profile-scoped
isolation is a structural consequence of that call, not a distinct behavior this story tests; no
dedicated cell exists for it, and none is added. Invariant 3's
"mirrored, not shared" relationship to `src/cli/issue/field_resolve.rs::resolve_edit_fields` is a
cross-file property those unit tests cannot enforce on their own (they only exercise this file's
own cache-first/bypass behavior, not the other file's). It is enforced the same way AC-004
already establishes for the adjacent Scope-boundary paragraph: at PR review, `git diff` shows
zero changes to `src/cli/issue/field_resolve.rs` (which necessarily includes its
`resolve_edit_fields` fn) -- see AC-004's Test line for that check. Everything the cited
clause(s) specify is binding in its entirety and must be implemented exactly as written there;
this story does not restate or narrow any of it.

### AC-009 (traces to BC-X.14.001 EC-X.14.001-15 [CC:L3036-3044] and BC-X.14.004's empty-`<field>` error-taxonomy row [CC:L3351], informational -- documented for completeness, no dedicated VP cell)
The empty-`<field>` guard (`jr field options ""` exits 64 with `Field '' not found. The field name must not be empty.`, zero HTTP calls, zero cache reads) is pre-existing `src/cli/field.rs::resolve_field_id` behavior, unaffected by this story's label-resolution fix. See BC-X.14.004's cross-reference row for the same condition. No new test is added for this AC.
**Test:** N/A (informational); existing `tests/field_options.rs::test_bc_x_14_001_empty_field_name_exits_64_zero_http` continues passing unmodified -- but that test itself only pins exit 64, the
`Field '' not found` / `must not be empty` message substrings, and zero HTTP calls on a cold
cache; it does not pin the guard-before-cache-read ordering or "zero cache reads" claim. The
cited spec text says the same thing about its own claim: [CC:L2624-2633]'s Behavior paragraph,
[CC:L2812-2816]'s Postconditions bullet, [CC:L2897-2904]'s Invariant 4, and [CC:L3041-3044]'s
EC-X.14.001-15 all describe the before-any-cache-read
ordering and zero-cache-reads outcome as a code-level fact/ordering verified by inspection (the
exact wording varies slightly by range -- e.g. ~L2813 says "a code-level ordering verified by
inspection" rather than "a code-level fact"), rather than
something the named test enforces (P16-009: [CC:L3351]'s error-taxonomy row does not itself
contain that phrase -- it cross-references EC-X.14.001-15, which is where that statement actually
appears). That ordering/zero-cache-reads sub-clause is instead enforced
by code citation plus PR diff review, the same mechanism this AC already uses for the two
warm-cache branches below: `src/cli/field.rs::resolve_field_id`'s `query.is_empty()` guard
(~L442-447) precedes its only cache read (`cache::read_fields_cache`, ~L451) -- verified against
current code -- and PR diff review confirms `resolve_field_id` is unchanged by this story's diff.
That covers only the before-cache-read half; the after-arity half is enforced by
`src/cli/field.rs::handle`'s Step 1 (`resolve_field_context`, ~L125) preceding Step 2
(`resolve_field_id`, ~L136), unchanged by this diff (AC-006 edits only the ~L134 comment) + PR
diff review.
Also implements BC-X.14.001's
Behavior paragraph's empty-`<field>` guard-ordering description [CC:L2624-2633] and the
Postconditions bullet describing when `GET /rest/api/3/field` is NOT called (empty `<field>`, a
`customfield_NNNNN` literal, or a warm-cache hit) [CC:L2812-2823] (informational -- doc-only
correction, no behavior change; existing behavior pinned by
`tests/field_options.rs::test_bc_x_14_001_empty_field_name_exits_64_zero_http`,
`test_bc_x_14_001_customfield_bypass_skips_list_fields`, and
`test_bc_x_14_001_warm_cache_resolves_without_list_fields_call`). [CC:L2812-2823] additionally
binds two warm-cache branches that none of the above tests exercise -- a warm cache lacking
`<field>` triggers exactly one refetch, and a warm-cache ambiguity exits 64 without a refetch (no
repository test covers either branch directly) -- these two sub-clauses are enforced by the
unchanged `src/cli/field.rs::resolve_field_id` (~L451-462, verified against current code) plus PR
diff review (no change to `resolve_field_id` in this story's diff). Everything the cited
clause(s) specify is binding in its entirety and must be implemented exactly as written there;
this story does not restate or narrow any of it.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `normalize_from_allowed_values_at_depth` | `src/cli/field.rs` | Pure (no I/O; struct-to-struct transform) |
| `normalize_from_valid_values` (M3, unchanged) | `src/cli/field.rs` | Pure (regression guard only) |
| `filter_options` / `filter_one` | `src/cli/field.rs` | Pure (unchanged contract, new downstream matches) |
| `AllowedValue` doc comments | `src/types/jira/editmeta.rs` | N/A (documentation only) |

Reference: `.factory/specs/architecture/ARCH-INDEX.md` Subsystem Registry (no module-boundary change; F1 confirmed no architecture delta)

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
| EC-X.14.001-15 | `<field>` is the empty string (informational, pre-existing, no behavior change) | Exit 64 `Field '' not found. The field name must not be empty.`, pinned (exit 64, message, zero HTTP on a cold cache) by `tests/field_options.rs::test_bc_x_14_001_empty_field_name_exits_64_zero_http`; zero cache reads / guard-before-cache-read ordering is a code-level fact (see AC-009); see BC-X.14.004's cross-reference row |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `normalize_from_allowed_values_at_depth` (`src/cli/field.rs`) | pure-core | No I/O; the sole behavior-changing site in this story |
| `normalize_from_valid_values` (`src/cli/field.rs`) | pure-core | Unchanged; regression-guarded only |
| `filter_options` / `filter_one` (`src/cli/field.rs`) | pure-core | Unchanged contract; new matches are a downstream effect |

## Token Budget Estimate

**[APPROXIMATE -- rounded to the nearest 5,000 tokens; drifts with edits]** supersedes the
pass-11 (P11-006) figure for "This story spec". The nine Revision Note sections (pass-3 through
pass-11 plus the later proactive sweep) have been moved to
`S-cycle14-field-options-name-label.revision-history.md` -- a separate, non-normative file an
implementing agent does not need to read to satisfy this story's own Tasks/ACs. The estimate below
is a rough budget-fit figure, not a precise count: it covers the portion kept in this file
(frontmatter/notes, Revision History pointer, Coverage Scope (D-387), Narrative, BC table, and
nine ACs -- all of which an implementing agent must still read in full to follow the citation
trail back to `cross-cutting.md`). It is intentionally rounded, and will drift out of date again
the next time this story's body is edited, as it has repeatedly across prior passes -- no claim
here is a precise, tool-measured count.

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec (full file: Revision History pointer + Coverage Scope + Narrative + BCs + ACs + Tasks etc.) | ~25,000 |
| Referenced code (`src/cli/field.rs` normalizer region + `handle`'s Step 2, `src/types/jira/editmeta.rs::AllowedValue`, `src/api/jira/issues.rs::get_createmeta_fields` doc comment) | ~2,200 |
| Test files (`tests/field_options.rs` -- grep-scoped to the renamed test + the new VP-580-013 cells) | ~1,800 |
| Tool output overhead | ~1,000 |
| **Total** | **~30,000** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~15%** |

~15% stays well within the 20-30% per-story ceiling (story-writer Rules), so no split is required.
`S-cycle14-field-options-name-label.revision-history.md` (approximate, non-normative -- also
drifts with edits) is available if an implementing agent wants the adversarial-review history for
context, but nothing in this story's own Tasks or ACs requires reading it.

## Tasks

> **D-386 binding instruction for all test-writing tasks below (1-5):** The test-writer MUST read
> the cited VP clause(s) in `cross-cutting.md` in full before writing; the VP text, not this
> story, is the source of truth for cell contents. AC-001 through AC-005's `**Test:**` lines above
> name the exact VP-580-013 sub-clause(s) and `cross-cutting.md` line range each task implements --
> follow those citations to the source text rather than relying on any fixture/value summary in
> this story.

1. [ ] Write the example-matrix tests for `normalize_from_allowed_values_at_depth` (AC-001, AC-002) as THREE separate pure unit tests (not one) in `src/cli/field.rs`'s `#[cfg(test)] mod tests`, so the Red Gate density check (Task 6) counts RED/GREEN at the `#[test]` function level, not per-cell (ADV-C14-F3-P4-001; full history in `S-cycle14-field-options-name-label.revision-history.md`) -- each function bundles its RED cell with its GREEN sibling combinations so the whole function is RED pre-fix -- `test-writer`:
   - 1a. [ ] top-level matrix: value-only, name-only, both, neither (EC-X.14.001-8..11), all four cells asserted in ONE `#[test]` fn; the `neither` cell MUST additionally assert the output `Vec`'s entry count equals the input entry count (never-drop invariant, EC-X.14.001-7)
   - 1b. [ ] cascading-child-level matrix: the same four combinations at depth >= 1, in a SECOND, separate `#[test]` fn; the `neither` cell MUST additionally assert the output `Vec`'s entry count equals the input entry count, same as 1a's requirement, at the cascading-child level
   - 1c. [ ] the two cells from VP-580-013(1)'s EC-X.14.001-12 fixtures (cross-cutting.md ~L3099-3105, binding -- see AC-002's Test line), each asserted at BOTH the top level AND at least one cascading-child level (four assertions total), in a THIRD `#[test]` fn, per that clause's own deserialization requirement (every cell built by deserializing a JSON fixture into `AllowedValue`, not by constructing the struct directly): the top-level assertions deserialize the fixture directly (e.g. `{"id":"1","value":"","name":"N"}` / `{"id":"1","value":null,"name":"N"}`); the child-level assertions deserialize a parent `AllowedValue` whose `children` array contains the fixture (e.g. `{"id":"P","value":"P","children":[{"id":"1","value":"","name":"N"}]}` / the `value: null` equivalent -- `AllowedValue.children: Vec<AllowedValue>` with `#[serde(default)]`, `src/types/jira/editmeta.rs`, accepts this shape), then assert the fallback rule against the normalized child entry
2. [ ] Write the test function for VP-580-013(2) (cross-cutting.md ~L3106-3110, binding -- recursive `AllowedValue` proptest strategy; see AC-001's Test line), in `src/cli/field.rs`'s `#[cfg(test)] mod tests` (alongside its existing `proptest!` blocks) -- `test-writer`. The `value`/`name` `Option<String>` strategies MUST be able to produce the empty string `""` (e.g. `prop_oneof![Just(String::new()), <the rest of the string strategy>]`, or a regex/`prop::string` pattern that allows a zero-length match) -- AC-001's Test line relies on this requirement to keep its non-exclusive fault-(3) claim (that this proptest will sometimes generate `value: Some("")` alongside a populated `name`) true; AC-002's deterministic `{"value": ""}` cell remains the primary, non-probabilistic owner of that fault
3. [ ] Write the test function for VP-580-013(3) (cross-cutting.md ~L3110-3113, binding -- companion serde key-set property; see AC-001's Test line), in `src/cli/field.rs`'s `#[cfg(test)] mod tests` -- `test-writer`
4. [ ] Write the M3 regression against a hand-written expected output (AC-004), in `src/cli/field.rs`'s `#[cfg(test)] mod tests` -- `test-writer`
5. [ ] Write the `--value` filter system-field cell (AC-003), in `src/cli/field.rs`'s `#[cfg(test)] mod tests` (`filter_one` is a private fn, unreachable from the external `tests/field_options.rs` integration binary) -- `test-writer`
6. [ ] Confirm Red Gate density against this tally (ADV-C14-F3-P4-001, corrected pass-6 ADV-C14-F3-P6-007; full history in `S-cycle14-field-options-name-label.revision-history.md`): 7 new test functions total (1a, 1b, 1c, 2-proptest, 3-key-set, 4-M3-regression, 5-`--value`-filter). RED = {1a, 1b, 1c, 2, 5} = 5 functions FAIL against current code (each contains at least one behavior-changing cell: name-only top-level, name-only cascading child, the `value: null` cell, the proptest's general case, `--value` system-field name match). GREEN = {3, 4} = 2 functions PASS unchanged before and after: test 3 (serde key-set property) and test 4 (M3 regression fixture) are BOTH `PRE-EXISTING-BEHAVIOR` -- justified but NOT exempt, both remain in the denominator as non-RED tests (test 3 was misclassified `FRAMEWORK-WIRING`/`WIRING-EXEMPT` at pass-4; corrected pass-6, ADV-C14-F3-P6-007, since this story has no stub for `WIRING-EXEMPT` to apply to). `TOTAL_NEW_TESTS = 7`, `EXEMPT_TESTS = 0`, denominator `= 7`, `RED_TESTS = 5`, `RED_RATIO = 5/7 ~= 0.71 >= 0.5` -- PASSES honestly; neither Option A (stub rollback) nor Option B (`mutation_testing_required: true` + PR disclosure) is invoked. Record this exact tally in `.factory/cycles/cycle-014/S-cycle14-field-options-name-label/implementation/red-gate-log.md` per per-story-delivery.md's Red Gate Log Format, with BOTH test 3's and test 4's rows tagged `rationale_category: PRE-EXISTING-BEHAVIOR`. No stub needed: `normalize_from_allowed_values_at_depth`, `normalize_from_allowed_values`, `normalize_from_valid_values`, `filter_options`, and `filter_one` all already exist in `src/cli/field.rs` -- this story modifies existing logic in place, so no new symbol requires a `todo!()` scaffold.
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
