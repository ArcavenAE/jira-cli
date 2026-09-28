---
document_type: story
level: ops
story_id: "S-cycle14-api-query-param"
epic_id: "ISSUE-TRIAGE-QUICKFIXES-1"
title: "jr api --query-param/-q NAME=VALUE: percent-encoded query-string assembly and its error taxonomy"
wave: 2
status: draft
intent: bug-fix
feature_type: enhancement
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
  - "src/cli/mod.rs"
  - "src/main.rs"
  - "src/cli/api.rs"
  - "README.md"
input-hash: "76973f9"
traces_to: "BC-X.16.001, BC-X.16.002"
cycle: cycle-014-issue-triage-quickfixes
estimated_effort: medium
estimated_days: 2
target_module: "src/cli/api.rs, src/cli/mod.rs"
subsystems: ["SS-02"]
# SS-02 (CLI Layer, src/cli/) owns this story's scope because every modified
# file (src/cli/api.rs, src/cli/mod.rs) lives under src/cli/ per ARCH-INDEX's
# Subsystem Registry (SS-02 row: "CLI Layer | src/cli/"). No HTTP-client-core
# (SS-03) file is touched -- append_query_params/parse_query_param run
# strictly before client.request is built (BC-X.16.001 Invariants).
depends_on: ["S-cycle14-user-list-project-resolution"]
blocks: ["S-cycle14-field-options-name-label"]
# Depends on S-cycle14-user-list-project-resolution because both stories edit
# the SAME two files in the SAME numeric sequence: .cargo/mutants.toml's
# examine_globs array (STORY-A lands 32->33; this story's edit must start
# from that value to reach 33->34) and docs/specs/cargo-mutants-policy.md's
# single hard-coded "Current examine_globs count" line -- a real content
# dependency (sequential numeric edit), not mere file overlap. Both stories
# also touch src/cli/mod.rs and src/main.rs (different code regions: this
# story adds Command::Api's -q field and dispatch-arm wiring, STORY-A touches
# UserCommand::List and the User dispatch arm) and README.md (different
# rows). Blocks S-cycle14-field-options-name-label for the same reason in
# reverse: that story's own doc edits to shared src/cli/mod.rs/README.md
# must land after this one (D-381 ordering only -- STORY-B makes no
# .cargo/mutants.toml or docs/specs/cargo-mutants-policy.md edits of its
# own, so "mutants edits" no longer applies here; P7-007b).
# Serial order A -> C -> B is human decision D-381 (2026-09-25 F2 review).
behavioral_contracts:
  - BC-X.16.001
  - BC-X.16.002
bcs:
  - BC-X.16.001
  - BC-X.16.002
verification_properties:
  - VP-API-QP-001
  - VP-API-QP-002
  - VP-API-QP-003
  - VP-API-QP-004
  - VP-API-QP-005
  - VP-API-QP-006
holdout_anchors: ["H-CYCLE14-W2-INT-001", "H-CYCLE14-W2-INT-002", "H-CYCLE14-W2-REG-001", "H-CYCLE14-W2-REG-002"]
nfr_anchors: []
adr_refs: []
sd_refs: []
priority: P2
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-014/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: strict
module_criticality: "N/A -- no .factory/specs/module-criticality.md exists in this repo"
points: 8
acceptance_criteria_count: 11
assumption_validations: []
risk_mitigations: []
created: "2026-09-26"
version: "2.0"
last_updated: "2026-09-28"
breaking_change: false
retroactive: false
origin: >
  cycle-014 issue-triage-quickfixes (GitHub issue #583), Wave 2 of 3, second
  story in the human-decided SERIAL delivery order A -> C -> B (D-381,
  2026-09-25 F2 review), rebased on STORY-A. F2 (prd-delta.md Item 3) added
  a wholly new BC family, BC-X.16.001/002, to cross-cutting.md -- no `jr api`
  BC existed before this cycle. This story implements that already-approved
  new BC family; the four design defaults (query merge, repeated names,
  encode-once, method-orthogonality) plus NAME/VALUE non-trimming,
  `--project ""` (STORY-A's own concern, not this one), and the `-q`
  no-override/no-dedup rule were all human-confirmed 2026-09-25 (D-380).
---

> **tdd_mode:** `strict` -- this story implements two new pure functions
> (`append_query_params`, `parse_query_param`) plus a new clap flag and
> handler wiring; the full TDD Iron Law applies.

> **Execute:** `/vsdd-factory:deliver-story S-cycle14-api-query-param`

# S-cycle14-api-query-param -- `jr api --query-param`/`-q` (#583)

## Revision Note (F3 adversarial pass-3 fixes, LOW/MEDIUM)

- **ADV-C14-F3-P3-002 (MEDIUM):** Task 10's Red Gate description previously listed EC-X.16.002-8
  (`-q -x=1`) and EC-X.16.002-10 (`-q` as the last argv token) as part of the RED test-cell set,
  but both are pure clap-contract outcomes -- clap rejects them with exit 2 before `handle_api`,
  `parse_query_param`, or `append_query_params` ever run, so both cells are already GREEN at the
  Task 1 stub. Fixed by reclassifying both as stub-stage GREEN clap-contract pins (mirroring
  STORY-A's `Cli::try_parse_from` cells) and excluding them from the Red Gate density numerator.
  A sweep of every other AC-009 cell (EC-X.16.002-5/6/7/9, all of which route through
  `parse_query_param`'s M1/M2 taxonomy) and every other AC-001..008 cell confirmed no other cell
  is clap-level or otherwise GREEN at stub.
- **ADV-C14-F3-P3-004a (LOW):** AC-001's trace and pinned-example list omitted EC-X.16.001-12,
  which VP-API-QP-001 (`cross-cutting.md` ~L4022-4025) pins with an exact-string example. Fixed
  by adding EC-X.16.001-12 to AC-001's trace header and appending the VP's exact-string example
  to AC-001's Test line.
- **ADV-C14-F3-P3-005 (LOW):** AC-011/Task 16 did not pin exactly where the new `src/cli/api.rs`
  §Scope bullet must land in `docs/specs/cargo-mutants-policy.md`, creating a risk that it could
  be appended after `### Sibling Candidates` (~L150) -- a heading
  `scripts/check-cargo-mutants-policy-citations.sh`'s §Scope-range extraction (~L41-46) treats as
  the end of the parsed range, silently exempting a bullet placed there from citation validation.
  Fixed by pinning the exact insertion point (directly after the `src/jql.rs` bullet, ~L81-89,
  and after STORY-A's already-landed `src/cli/user.rs` bullet appended at that same spot; before
  the blank line preceding the `**FIX-F7-001 deferred**` paragraph, ~L91; never at or below
  `### Sibling Candidates`, ~L150) in both AC-011 and Task 16, and adding an explicit
  post-edit check that the guard's parsed §Scope bullet-group count increases by exactly one.

## Revision Note (F3 adversarial pass-4 fixes, LOW/COSMETIC)

- **ADV-C14-F3-P4-002 (LOW):** Task 10 previously said to "exclude [EC-X.16.002-8/-10] from the
  Red Gate density numerator" -- a no-op, since a GREEN-at-stub cell is by definition never in
  the numerator (`RED_TESTS`); the playbook's density formula
  (`RED_RATIO = RED_TESTS / (TOTAL_NEW_TESTS - EXEMPT_TESTS)`, `EXEMPT_TESTS =
  GREEN-BY-DESIGN_count + WIRING-EXEMPT_count`, per-story-delivery.md ~L45-60) only has teeth if a
  GREEN cell is removed from the DENOMINATOR. Fixed by rewriting Task 10 to classify both
  EC-X.16.002-8 (`-q -x=1`) and EC-X.16.002-10 (`-q` as the last argv token) as **WIRING-EXEMPT**
  (rationale_category `FRAMEWORK-WIRING` in the unexpectedly-GREEN table) -- both pass at the
  Task 1 stub purely because clap's own argument parser (the `-q`/`--query-param: Vec<String>`
  field declaration itself, with no `allow_hyphen_values`) already rejects them with exit 2
  before `parse_query_param`/`append_query_params` are ever called, i.e. they pass because the
  correct clap wiring exists in the stub, not because of premature business-logic
  implementation -- and a sweep of the rest of this story's new test surface found ONE more
  GREEN-at-stub group requiring the same denominator treatment: AC-004's zero-flag WIREMOCK
  EXAMPLES (Task 5, VP-API-QP-004 layer (2)) supply NO `-q` flag at all, so Task 1's required
  short-circuit ("use the pre-existing `normalize_path` output unchanged" when zero `-q` flags
  are supplied) routes them around both stubs entirely -- these are classified
  **GREEN-BY-DESIGN** (rationale_category `PRE-EXISTING-BEHAVIOR`), distinct from the
  WIRING-EXEMPT pair: the zero-flag path exercises no clap-rejection at all, it exercises
  `normalize_path`'s existing, already-shipped behavior, which by this story's own design must
  never touch either new `todo!()` body. **Superseded in part by ADV-C14-F3-P5-001 (see the pass-5
  Revision Note below):** the GREEN-BY-DESIGN / `EXEMPT_TESTS` classification given to the AC-004
  zero-flag wiremock examples in this bullet was incorrect per the playbook's own definition of
  GREEN-BY-DESIGN (type-system-deterministic behavior only) -- PRE-EXISTING-BEHAVIOR is a
  rationale-category label for the red-gate-log table, not a distinct exemption category, and
  these two cells are reclassified as non-exempt GREEN that remain in the density-check
  denominator. The WIRING-EXEMPT classification of EC-X.16.002-8/-10 earlier in this same bullet
  is UNCHANGED and remains correct. Also pins the counting unit new Task 9 guidance
  requires -- one `#[test]` function per pinned EC id/scenario, not one function spanning
  multiple cells -- so the density arithmetic in Task 10 is auditable, and adds an explicit
  RED / EXEMPT / denominator tally (Task 10) showing `RED_RATIO == 1.0 >= 0.5` under that
  counting unit, with an explicit note that the true count must still be re-verified against
  the actual Step 3 dispatch output at the Red Gate Density Check (the tally below is a
  pre-implementation projection, not a substitute for that check).
- **ADV-C14-F3-P4-004 (LOW):** EC-X.16.002-11 (non-UTF-8 `-q` value, `cross-cutting.md`
  ~L4299-4305) had no owning AC -- AC-009's trace header cited only EC-X.16.002-5..10. Per the
  BC's own text, EC-X.16.002-11 is "informational -- inherited clap behavior, no VP cell (same
  treatment as EC-X.14.001-14)", i.e. it is deliberately NOT one of VP-API-QP-005's test cells.
  Fixed by adding EC-X.16.002-11 to AC-009's trace header as an explicit informational
  (non-VP) reference and adding a one-line note in AC-009's body, worded consistently with the
  Edge Cases table's own EC-X.16.002-11 row (~L245): "Clap exit 2 before `parse_query_param`
  runs (informational, no VP cell)".
- **ADV-C14-F3-P4-006 (LOW):** Task 10(a)'s stub-stage GREEN classification of the AC-003
  `--help` cell relied on the Task 1 stub NOT already containing the BC-X.16.001 Behavior 3
  pinned help-text substring `"do not pre-encode"` -- but Task 1 never said so, leaving a real
  risk that a stub-architect pass could pre-populate the final, correct help text (a natural
  thing to do when writing a clap field's doc comment) and accidentally make that cell GREEN at
  stub for the wrong reason (premature correct implementation, not a legitimate exemption
  category). Fixed by adding an explicit stub constraint to Task 1: the `-q`/`--query-param`
  field's doc comment/help string MUST NOT contain the pinned substring `"do not pre-encode"`
  at the Task 1 stub stage; Task 12 (clap field finalization) is what adds it.
- **ADV-C14-F3-P4-009 (LOW):** `holdout_anchors` omitted `H-CYCLE14-W2-REG-002` and
  `H-CYCLE14-W2-INT-002`, even though both are Wave-2 scenarios in
  `wave-holdout-scenarios.md` that name this story directly (`H-CYCLE14-W2-INT-002`: proves
  Story C's `cli/mod.rs`/`main.rs` edits don't perturb Story A's `UserCommand::List` wiring;
  `H-CYCLE14-W2-REG-002`: proves `-q` plus `--output json` leaves `jr api`'s raw-passthrough
  success-path output byte-identical, unaffected by both `-q` and `--output json`). Fixed by
  setting `holdout_anchors` to the full Wave 2 scenario-ID set from `wave-holdout-scenarios.md`:
  `["H-CYCLE14-W2-INT-001", "H-CYCLE14-W2-INT-002", "H-CYCLE14-W2-REG-001",
  "H-CYCLE14-W2-REG-002"]`. Per the finding's own note, a concurrent burst is replacing
  `H-CYCLE14-W2-INT-002`'s scenario body with a new A+C composition while KEEPING the same ID,
  so this ID set is stable across that change.
- **ADV-C14-F3-P4-011c (COSMETIC):** Task 10(c) named only `tests/cli_handler.rs` as the
  pre-existing `jr api` regression-guard suite that must stay GREEN both before and after this
  story. Verified against the repo: `tests/rate_limit_holdouts.rs::
  test_s_1_07_h_013_send_raw_gave_up_warning_in_stderr` (~L134, BC-X.1.005/BC-X.1.009) also
  drives `jr api /rest/api/3/myself` (zero `-q` flags) as a real subprocess and asserts on its
  stderr -- an existing `jr api` regression guard outside `tests/cli_handler.rs`. Fixed by
  adding `tests/rate_limit_holdouts.rs` to Task 10(c)'s regression-guard file list.

## Revision Note (F3 adversarial pass-5 fixes, LOW)

- **ADV-C14-F3-P5-001 (LOW):** Task 10(a) and the 10(d) table row for AC-004 classified the two
  AC-004 zero-flag wiremock examples as **GREEN-BY-DESIGN**, exempt from the density-check
  denominator. Per per-story-delivery.md's own definition (~L56), GREEN-BY-DESIGN is limited to
  "behavior deterministic from the type system alone" -- these two cells are not that; they are
  GREEN because Task 1's required short-circuit routes the zero-`-q` path around both `todo!()`
  bodies, which is a stub-wiring design choice, not a type-system fact. PRE-EXISTING-BEHAVIOR is
  one of the `rationale_category` labels the red-gate-log table itself enumerates
  (~L87: `PURE-DATA | FRAMEWORK-WIRING | STRUCTURAL-ASSERTION | PRE-EXISTING-BEHAVIOR |
  OTHER-JUSTIFIED | UNJUSTIFIED`) for explaining an unexpectedly-GREEN cell in the log -- it is
  not, by itself, one of the two categories (`GREEN-BY-DESIGN`, `WIRING-EXEMPT`) that reduce
  `EXEMPT_TESTS` and shrink the density-check denominator. Sibling STORY-B keeps its own
  PRE-EXISTING-BEHAVIOR GREENs in the denominator; this story must match that treatment. Fixed by
  reclassifying both AC-004 zero-flag wiremock examples as **non-exempt GREEN**
  (`rationale_category: PRE-EXISTING-BEHAVIOR`) that stay in `TOTAL_NEW_TESTS - EXEMPT_TESTS`
  (Task 10(a2), new), removing them from `EXEMPT_TESTS` (now `WIRING-EXEMPT_count` only --
  EC-X.16.002-8/-10, unchanged), recomputing the Task 10(d) tally (`TOTAL_NEW_TESTS = 41`,
  `RED_TESTS = 37`, `EXEMPT_TESTS = 2`, `RED_RATIO = 37 / 39 ≈ 0.949 >= 0.5`, still comfortably
  clears the gate), and appending a superseded-note to the pass-4 Revision Note bullet
  (ADV-C14-F3-P4-002) that originally introduced the incorrect classification.
- **ADV-C14-F3-P5-002 (LOW):** The Task 10(d) tally could not be reproduced from the task
  descriptions alone -- Task 2 (AC-001) and Task 4 (AC-003) described only their `proptest!`
  oracles, silently dropping the pinned examples their own AC Test lines require, and no task
  enumerated its new tests by name/cell, so the 10(d) counts could not be checked against the
  task list. Fixed:
  (a) Task 2 now reads "...+ pinned examples (AC-001 list)" and Task 4 now reads "...+ pinned
  examples (AC-003 list, including the two no-trim examples that also run through
  `parse_query_param`)", so every pinned example each AC's Test line requires is assigned to a
  task.
  (b) Adopted ONE counting rule, applied uniformly: **one `#[test]` (or `proptest!` block) per
  pinned example / EC id / scenario**, matching Task 9's own pre-existing rule for AC-009 and the
  pass-4 note's "one `#[test]` per pinned EC id/scenario." Task 10(d) now carries a full
  per-task/per-cell enumeration under this rule, including an explicit statement that AC-006's
  `--output json` envelope cell is ONE `#[test]` asserting both the M1 and M2 envelope shapes
  (not split into 2), consistent with the pre-existing count of 1 for that cell.
  (c) Task 10(d)'s table is rewritten to match the enumeration exactly:
  `TOTAL_NEW_TESTS = 41`, `RED_TESTS = 37`, non-exempt GREEN (PRE-EXISTING-BEHAVIOR, in
  denominator) `= 2`, `EXEMPT_TESTS = 2` (WIRING-EXEMPT only), denominator `= 41 - 2 = 39`,
  `RED_RATIO = 37 / 39 ≈ 0.949 >= 0.5`. Explicitly stated as a pre-implementation projection,
  to be reconciled against the actual Step 3 dispatch output at the Red Gate Density Check.
- **ADV-C14-F3-P5-004 (LOW, process-gap):** per-story-delivery.md (~L35) requires Step-3 failure
  messages to reference the behavior under test, not "not yet implemented" -- but this story's
  direct-call unit tests (the `append_query_params`/`parse_query_param` `proptest!`s and pinned
  examples living in `src/cli/api.rs`'s `#[cfg(test)] mod tests`) call a `todo!()` stub directly
  and can therefore only fail with a raw `todo!()` panic (message containing "not yet
  implemented"), not a produced-and-asserted-wrong-value assertion error. Fixed by adding Task
  10(f): an explicit list of which new tests fail via a `todo!()` panic (the 19 direct-call
  tests enumerated in 10(d)) versus which fail via a normal exit-code/stderr assertion in a
  spawned subprocess (the remaining 22 tests in `tests/api_query_param.rs` and the pre-existing
  regression-guard suites), with an explicit statement that the `todo!()`-panic failure mode is
  the EXPECTED Red signal for this story's strict-`tdd_mode` stub (Task 1 is a stub-architect
  `todo!()` stub per BC-5.38.001) -- the orchestrator must NOT re-dispatch the test-writer over a
  direct-call test failing with a bare panic instead of an assertion diff. Subprocess-level tests
  still fail via their own exit-code/stderr `assert_eq!`/`assert!` checks (the child process's
  underlying `todo!()` panic surfaces there as an unexpected exit code / panic text on stderr,
  but the top-level test function itself fails via a normal assertion, satisfying Step 3's Red
  Gate literally).

## Revision Note (F3 adversarial pass-6 fixes, MEDIUM/LOW/COSMETIC)

- **P6-001 (MEDIUM):** AC-001's Test line and the Task 10(d) enumeration conflated two distinct
  VP-API-QP-001 pins into one row: EC-X.16.001-5 (a query-less path whose fragment itself
  contains `?`) and the separate "empty query component directly followed by a fragment" case
  the VP's own proptest strategy pins as `/s?#f` + `k=v` -> `/s?k=v#f` (`cross-cutting.md`
  ~L4020, ~L4024-4025) -- these are two different pinned examples, not one. Fixed by (1)
  correcting the EC-X.16.001-5 row to its own actual pinned example -- `/x#a?b` + `k=v` ->
  `/x?k=v#a?b` (`pre` = `/x` has no `?`, so a fresh `?` is introduced before the `#a?b`
  fragment is reattached verbatim; VP text ~L4018-4019) -- and (2) adding a new, separate Task
  10(d) row for the `/s?#f` empty-query-plus-fragment pin (no EC id of its own; it is the
  example that specifically kills the "whole-path `find('?')`" fault, VP text ~L4028-4029). Also
  annotated the EC-X.16.001-8 row with both pinned forms the VP text bundles under "-8 (both
  forms)" (~L4023): bare `?` (e.g. `/s?` + `k=v` -> `/s?k=v`) and an existing pair already
  ending in `&` (e.g. `/s?a=1&` + `k=v` -> `/s?a=1&k=v`) -- one row/one test, both forms named,
  not split. While sweeping VP-API-QP-001 for other under-pinned rows, also added the
  EC-X.16.001-9 exact string (`/s?jql=why?` + `k=v` -> `/s?jql=why?&k=v`, VP text ~L4013-4014),
  previously present only as a paraphrase ("query ends in literal `?`"). AC-001's new-test count
  rises 7 -> 8 (one net-new row: the split-off `/s?#f` case; EC-8 stays one row/one test,
  annotated not split).
- **P6-003 (LOW):** A sweep of VP-API-QP-002/003/005 against AC-002/003/009's Test lines and the
  Task 10(d)/(e) tables found four more un-carried or mis-carried pins:
  (a) VP-API-QP-003(c)'s second encoder-identity pinned example, space -> `%20` (`cross-cutting.md`
  ~L4080), was present only in the VP's alphabet clause (b) paraphrase and never carried into
  AC-003's Test line or a Task 10(d) row alongside its sibling pin `*` -> `%2A`. Fixed by adding
  both to AC-003's Test line and Task 4, plus a new Task 10(d) row. AC-003's new-test count rises
  9 -> 10.
  (b) VP-API-QP-002's pinned decode example -- `/s?fields=summary` + `fields=status` decodes to
  `[("fields","summary"), ("fields","status")]` (~L4049-4050) -- had no owning AC-002 Test-line
  mention, Task 3 mention, or Task 10(d) row (only the general `proptest!` oracle and the three
  argv cells were present). Fixed by adding it to AC-002's Test line, Task 3, and a new Task
  10(d) row (direct-call, `src/cli/api.rs`'s `#[cfg(test)] mod tests`). AC-002's new-test count
  rises 4 -> 5.
  (c) AC-002's Test line and Task 10(d) rows for the two non-mixed argv cells were missing their
  pinned wire values and counter-mocks, and the repeated-flags row was pinned with the WRONG
  argv/values -- it named `-q b=2 -q b=3` (the MIXED cell's own values, VP text ~L4059) instead
  of the VP's own repeated-flags pin, `-q fields=summary -q fields=status` -> raw query exactly
  `fields=summary&fields=status` via `received_requests()` (~L4055-4058). Fixed by correcting
  the repeated-flags row's argv/expected value and adding both cells' pinned wire values and
  `.expect(0)` catch-alls to AC-002's Test line and Task 3: the comma cell
  (`fields=summary,status` -> raw query exactly `fields=summary%2Cstatus`, decoded pair count 1,
  catch-all `.expect(0)`) and the (corrected) repeated-flags cell (`fields=summary&fields=status`
  via `received_requests()`, catch-all `.expect(0)`).
  (d) VP-API-QP-005(3)'s EC-X.16.002-7 requirement that `--query-param==v`'s stderr be
  BYTE-IDENTICAL to the `-q==v` (EC-6) cell's stderr (~L4340) was reported as an isolated M2
  assertion, losing the comparative requirement -- which requires the single EC-7 test to run
  BOTH invocations (`-q==v` and `--query-param==v`) so it can compare their stderr byte-for-byte.
  Fixed by adding this to AC-009's Test line and the EC-7 row's label in Task 10(d).
- **P6-005 (LOW):** Task 7's singular "the multi-flag first-malformed wiremock cell" did not
  match the 4 rows Task 10(d) actually assigns to it, and those 4 rows' labels ("all-or-nothing
  cell (i)"/"(ii)", "first-malformed-reported cell 1"/"2") did not carry the VP-API-QP-006
  (i)/(ii) argv pins verbatim. Fixed by rewording Task 7 to "the four VP-API-QP-006 (i)/(ii)
  cells" and relabeling all 4 Task 10(d) rows with their exact argv, verified against the VP
  text (~L4366-4369): `-q a=1 -q bad` and `-q bad -q a=1` (all-or-nothing, (i), no request
  sent); `-q foo -q =v` -> M1 naming `foo`, D2 absent, and `-q =v -q foo` -> M2 naming `=v`, D1
  absent (first-malformed-reported, (ii)).
- **P6-006 (LOW):** Task 13 never said what becomes of Task 1's required zero-flag short-circuit
  once `append_query_params`/`parse_query_param` are implemented, leaving a real risk that the
  short-circuit would ship permanently -- which would leave an equivalent `delete !` mutant
  (removing the short-circuit's `if` condition) unkillable once `src/cli/api.rs` enters
  `examine_globs` (AC-011) for the `--in-diff` mutants gate, since `append_query_params(p, &[])
  == p` already holds as an identity (BC-X.16.001 Postcondition 5 / VP-API-QP-004 layer (1)),
  making the short-circuit and its unconditional-call replacement behaviorally indistinguishable
  by any test in this story -- unless the short-circuit itself is removed, mirroring STORY-A's
  own resolution of the identical class of finding at its own Task 9. Fixed by: (1) rewording
  Task 1 so the short-circuit is explicitly STUB-STAGE ONLY (temporary, present only until Task
  13); (2) rewording Task 13 to REMOVE the short-circuit and call
  `parse_query_param`/`append_query_params` unconditionally, on every invocation including zero
  `-q` flags. This does not change any Task 10 classification: the Red Gate check runs against
  the Task 1 STUB, where the short-circuit is still present, so AC-004's two zero-flag wiremock
  examples remain GREEN-nonexempt (`PRE-EXISTING-BEHAVIOR`, in the denominator) exactly as
  before; after Task 13 removes the short-circuit, those same two examples stay GREEN (now for a
  different, permanent reason: the identity property itself), so no reclassification is needed
  at either stage.
- **P6-009 (COSMETIC):** Task 10(f)'s subprocess-cell parenthetical incorrectly implied that some
  of the subprocess-level cells enumerated in (d) live in the pre-existing
  `tests/cli_handler.rs`/`tests/rate_limit_holdouts.rs` regression-guard suites -- those are Task
  10(c)'s separately-tracked pre-existing regression guards, never part of the (d) enumeration
  of this story's OWN new tests. Fixed by dropping the parenthetical; all of (d)'s subprocess
  cells are in `tests/api_query_param.rs`.

## Revision Note (D-386 bind-by-reference restructure + pass-7 fixes, MEDIUM)

- **D-386 (human decision, bind-by-reference restructure):** Across 4 adversarial passes (pass-3
  through pass-6 above), AC **Test:** lines paraphrased VP-API-QP-001..006 clauses from
  `.factory/specs/prd/cross-cutting.md` and repeatedly dropped sub-clauses, while self-attested
  pin->AC->row checklists claimed completeness the underlying Test lines didn't actually carry.
  The human decided stories must BIND to VP clauses by reference instead of copying them. Effective
  this revision: every AC's **Test:** line (1) names the exact VP clause(s) it implements
  (`VP-API-QP-NNN(x)`, with a `cross-cutting.md` `~line` range), (2) carries the normative sentence
  "Every cell, setup, argv, expected value/wire value, stderr substring (present AND absent),
  counter-mock (`.expect(0)`/zero-HTTP), oracle/generator constraint and anti-vacuity assertion in
  the cited clause(s) is binding and must be implemented exactly as written there; this story does
  not restate them, and nothing here narrows them.", and (3) retains ONLY story-specific
  information: the test file/module each cell lives in, how cells group into `#[test]`/
  `proptest!` functions (the counting unit), and each function's RED/GREEN-at-stub classification.
  The old pin->AC->row checklist is replaced below by a CLAUSE-level map (VP clause id -> owning
  AC -> owning Task 10(d) function(s), plus a BC-postcondition->AC table and an Edge-Case->AC
  table), built by walking every VP-API-QP-001..006 sub-clause, every BC-X.16.001/002
  postcondition, and every EC-X.16.001-*/EC-X.16.002-* in `cross-cutting.md` exactly once. Task
  10(d)'s row labels now read `<VP clause> <EC id or pin tag>` (e.g. `VP-API-QP-005(3)
  EC-X.16.002-7`) instead of restating pinned values, and AC bodies that stated a BC postcondition's
  content now cite the postcondition number instead of restating it. This restructure changes
  LABELS and CITATIONS only -- no test cell is added, removed, or reclassified, and the density
  tally (`TOTAL_NEW_TESTS = 44`, `RED_TESTS = 40`, `GREEN-nonexempt = 2`, `EXEMPT = 2`,
  `RED_RATIO = 40 / 42 ~= 0.952`) is unchanged from the pass-6 recomputation below.
- **P7-001 (verified covered):** VP-API-QP-005(3)'s negative-substring and zero-HTTP requirements
  are now bound by reference in AC-009's Test line (cites VP-API-QP-005(3), `cross-cutting.md`
  ~L4332-4356) together with the normative sentence above, which makes every `.expect(0)`
  counter-mock and every "stderr does NOT contain D1/D2/`Not authenticated`" negative assertion in
  that clause binding without restatement in this story.
- **P7-002 (verified covered):** VP-API-QP-006(iii)'s `-d @-` argv and D1 assertion, and the
  `.expect(0)` requirement spanning (i)/(ii)/(iv), are bound by reference in AC-007's Test line
  (cites VP-API-QP-006(i)/(ii), ~L4366-4369) and AC-008's Test line (cites VP-API-QP-006(iii)/(iv),
  ~L4370-4386), together with the clause's own "every mock `.expect(0)`" intro (~L4363-4365),
  which the normative sentence makes binding on every cell.
- **P7-003 (verified covered):** VP-API-QP-004's request-body assertion (the `-d` input equals the
  received body, and is never moved into the query) is bound by reference in AC-004's Test line
  (cites VP-API-QP-004 structural/(1)/(2), ~L4092-4108). VP-API-QP-003(e)'s `--help` exit-0-with-
  whitespace-collapse requirement is bound by reference in AC-003's Test line (cites
  VP-API-QP-003(e), ~L4084-4087).
- **P7-004 (verified covered, and additionally restated in the owning Task per this note's own
  instruction since these three constraints affect the RED classification):**
  - VP-API-QP-003(a)'s round-trip constraint requires `encode(v)` to be the NAME/VALUE segment
    extracted from `append_query_params`'s own output, NOT a direct `urlencoding::encode` call (a
    direct call would be tautological and GREEN at the Task 1 stub) -- cited in AC-003's Test line
    and restated in Task 4.
  - VP-API-QP-002's anti-vacuity generator constraint requires the second assertion
    `existing == generated_existing_pairs` to hold, so the generator cannot silently collapse to
    an empty `existing` -- cited in AC-002's Test line and restated in Task 3.
  - VP-API-QP-005(1)'s `prop_assume!`-filtered absence check requires each `Err` case's
    "other-substring-absent" assertion to be filtered with `prop_assume!` to `raw` values that do
    not themselves contain D1 or D2 -- cited in AC-005's Test line and restated in Task 6.
- **P7-007b (fixed):** the frontmatter dependency comment (~L49-50, pre-restructure numbering) said
  STORY-B's "own doc/mutants edits must land after this one" -- STORY-B
  (`S-cycle14-field-options-name-label`) makes no `.cargo/mutants.toml` or
  `docs/specs/cargo-mutants-policy.md` edits of its own. Reworded to "doc edits to shared
  `src/cli/mod.rs`/README.md (D-381 ordering only)".

**Recomputed after the sweep above (three net-new pinned-example tests: the split-off `/s?#f`
case, the VP-API-QP-002 decode example, and VP-API-QP-003's `space` -> `%20` pin -- all three are
direct-call, in-process tests):** `TOTAL_NEW_TESTS = 44`, `RED_TESTS = 40`, non-exempt GREEN
(PRE-EXISTING-BEHAVIOR) `= 2`, `EXEMPT_TESTS = 2` (WIRING-EXEMPT only), denominator `= 44 - 2 =
42`, `RED_RATIO = 40 / 42 ≈ 0.952 >= 0.5`. Direct-call cells rise 19 -> 22 (AC-001 8, AC-002 2,
AC-003 9, AC-004 1, AC-005 2); subprocess cells stay at 22. See Task 10(d)/(e)/(f) below for the
full recomputation.

## Clause-Level Map (D-386 bind-by-reference; supersedes the old pin -> AC -> row checklist)

This map replaces the pinned-value checklist. It is the single source of "what is covered
where" -- ACs and Tasks below bind to these clause ids and MUST NOT restate the clause
content. Built by walking every VP-API-QP-001..006 sub-clause, every BC-X.16.001/002
postcondition, and every EC-X.16.001-*/EC-X.16.002-* in `.factory/specs/prd/cross-cutting.md`
exactly once (71 rows total: 38 VP-clause + 8 BC-postcondition + 25 Edge-Case).

### VP Clause -> Owning AC -> Owning Task 10(d) function(s)

| VP Clause | cross-cutting.md ~line | Owning AC | Owning Task 10(d) function(s) |
|---|---|---|---|
| VP-API-QP-001(equation) | ~L4007-4015 | AC-001 | Task 2 / AC-001, separator-oracle `proptest!` |
| VP-API-QP-001(EC-4) | ~L4023 | AC-001 | Task 2 / AC-001, EC-4 row |
| VP-API-QP-001(EC-5) | ~L4018-4019, 4023 | AC-001 | Task 2 / AC-001, EC-5 row |
| VP-API-QP-001(empty-query-frag) | ~L4020, 4024-4025 | AC-001 | Task 2 / AC-001, empty-query-plus-fragment row |
| VP-API-QP-001(EC-8) | ~L4023 | AC-001 | Task 2 / AC-001, EC-8 row (both forms, one test) |
| VP-API-QP-001(EC-9) | ~L4013-4014, 4023 | AC-001 | Task 2 / AC-001, EC-9 row |
| VP-API-QP-001(EC-12) | ~L4021-4022, 4025 | AC-001 | Task 2 / AC-001, EC-12 row |
| VP-API-QP-001(EC-14) | ~L4012, 4025 | AC-001 | Task 2 / AC-001, EC-14 row |
| VP-API-QP-001(fault-models) | ~L4026-4031 | AC-001 | Task 2 / AC-001 (killed collectively by the 7 rows above) |
| VP-API-QP-002(oracle) | ~L4032-4041 | AC-002 | Task 3 / AC-002, repeated-names `proptest!` |
| VP-API-QP-002(generator-constraint) | ~L4042-4048 | AC-002 | Task 3 / AC-002, repeated-names `proptest!` (second, anti-vacuity assertion, same fn) |
| VP-API-QP-002(pinned-decode-example) | ~L4049-4050 | AC-002 | Task 3 / AC-002, decode-example row |
| VP-API-QP-002(argv-EC-13) | ~L4050-4054 | AC-002 | Task 3 / AC-002, EC-13 row |
| VP-API-QP-002(argv-repeated-flags) | ~L4055-4059 | AC-002 | Task 3 / AC-002, repeated-flags row |
| VP-API-QP-002(argv-mixed) | ~L4059-4062 | AC-002 | Task 3 / AC-002, mixed row |
| VP-API-QP-002(fault-models) | ~L4063-4069 | AC-002 | Task 3 / AC-002 (killed collectively by the 5 rows above) |
| VP-API-QP-003(intro) | ~L4070-4072 | AC-003 | Task 4 / AC-003, encoding `proptest!` |
| VP-API-QP-003(a) | ~L4073-4075 | AC-003 | Task 4 / AC-003, encoding `proptest!` (round-trip assertion) |
| VP-API-QP-003(b) | ~L4076-4077 | AC-003 | Task 4 / AC-003, encoding `proptest!` (alphabet assertion) |
| VP-API-QP-003(c) | ~L4078-4080 | AC-003 | Task 4 / AC-003, `*`->`%2A` row + space->`%20` row |
| VP-API-QP-003(d) | ~L4081-4083 | AC-003 | Task 4 / AC-003, no-trim rows (2) |
| VP-API-QP-003(e) | ~L4084-4087 | AC-003 | Task 4 / AC-003, `--help` row (`tests/api_query_param.rs`) |
| VP-API-QP-003(further-pinned) | ~L4087-4089 | AC-003 | Task 4 / AC-003, `%`/`+`/`é`/literal-`%25` rows (4) |
| VP-API-QP-003(fault-models) | ~L4089-4091 | AC-003 | Task 4 / AC-003 (killed collectively by the 8 rows above) |
| VP-API-QP-004(structural) | ~L4092-4094 | AC-004 | Task 5 / AC-004, table-driven method-orthogonality row |
| VP-API-QP-004(1) | ~L4098-4101 | AC-004 | Task 5 / AC-004, zero-flag identity `proptest!` |
| VP-API-QP-004(2) | ~L4101-4106 | AC-004 | Task 5 / AC-004, zero-flag wiremock examples (2 rows) |
| VP-API-QP-004(fault-models) | ~L4106-4108 | AC-004 | Task 5 / AC-004 (killed collectively by the 3 rows above) |
| VP-API-QP-005(intro) | ~L4307-4316 | AC-005 / AC-006 | Task 6 (pinned M1/M2 messages, D1/D2 substrings apply to both ACs) |
| VP-API-QP-005(1) | ~L4317-4326 | AC-005 | Task 6 / AC-005, partition `proptest!` + pinned `parse_query_param("")` example |
| VP-API-QP-005(2) | ~L4327-4331 | AC-005 / AC-006 | Task 6 / AC-005 wiremock `-q foo` row; AC-006 wiremock `-q =v` row + json-envelope row |
| VP-API-QP-005(3) | ~L4332-4356 | AC-009 | Task 9 / AC-009, EC-5..10 rows |
| VP-API-QP-005(fault-models) | ~L4357-4362 | AC-005 / AC-006 / AC-009 | Task 6 + Task 9 (killed collectively by the rows above) |
| VP-API-QP-006(i) | ~L4366-4367 | AC-007 | Task 7 / AC-007, all-or-nothing rows (2) |
| VP-API-QP-006(ii) | ~L4368-4369 | AC-007 | Task 7 / AC-007, first-malformed rows (2) |
| VP-API-QP-006(iii) | ~L4370-4384 | AC-008 | Task 8 / AC-008, held-open-stdin row |
| VP-API-QP-006(iv) | ~L4385-4386 | AC-008 | Task 8 / AC-008, before-`-H` row |
| VP-API-QP-006(fault-models) | ~L4387-4389 | AC-007 / AC-008 | Task 7 + Task 8 (killed collectively by the rows above) |

### BC Postcondition -> Owning AC

| BC Postcondition | cross-cutting.md ~line | Owning AC |
|---|---|---|
| BC-X.16.001 Postcondition 1 (zero-flag identity) | ~L3876-3879 | AC-004 |
| BC-X.16.001 Postcondition 2 (separator algorithm) | ~L3880-3891 | AC-001 |
| BC-X.16.001 Postcondition 3 (encode exactly once) | ~L3892-3895 | AC-003 |
| BC-X.16.001 Postcondition 4 (repeated params, flag order) | ~L3896-3897 | AC-002 |
| BC-X.16.001 Postcondition 5 (method/body independence) | ~L3898-3900 | AC-004 |
| BC-X.16.002 Postcondition 1 (pre-flight ordering) | ~L4178-4189 | AC-008 |
| BC-X.16.002 Postcondition 2 (`--output json` envelope) | ~L4190-4195 | AC-006 |
| BC-X.16.002 Postcondition 3 (all-or-nothing) | ~L4196-4199 | AC-007 |

### Edge Case -> Owning AC

| EC id | cross-cutting.md ~line | Owning AC |
|---|---|---|
| EC-X.16.001-1 | ~L3918-3920 | AC-006 |
| EC-X.16.001-2 | ~L3921-3923 | AC-005 |
| EC-X.16.001-3 | ~L3924-3930 | AC-003 |
| EC-X.16.001-4 | ~L3931-3932 | AC-001 |
| EC-X.16.001-5 | ~L3933-3942 | AC-001 |
| EC-X.16.001-6 | ~L3943-3945 | AC-004 |
| EC-X.16.001-7 | ~L3946-3949 | AC-004 |
| EC-X.16.001-8 | ~L3950-3959 | AC-001 |
| EC-X.16.001-9 | ~L3960-3968 | AC-001 |
| EC-X.16.001-10 | ~L3969-3973 | AC-003 |
| EC-X.16.001-11 | ~L3974-3977 | AC-003 |
| EC-X.16.001-12 | ~L3978-3988 | AC-001 |
| EC-X.16.001-13 | ~L3989-3994 | AC-002 |
| EC-X.16.001-14 | ~L3995-4000 | AC-001 |
| EC-X.16.002-1 | ~L4215-4216 | AC-005 |
| EC-X.16.002-2 | ~L4217-4218 | AC-006 |
| EC-X.16.002-3 | ~L4219-4222 | AC-007 |
| EC-X.16.002-4 | ~L4223-4230 | AC-008 |
| EC-X.16.002-5 | ~L4231-4238 | AC-009 |
| EC-X.16.002-6 | ~L4239-4243 | AC-009 |
| EC-X.16.002-7 | ~L4244-4251 | AC-009 |
| EC-X.16.002-8 | ~L4252-4275 | AC-009 (WIRING-EXEMPT) |
| EC-X.16.002-9 | ~L4276-4291 | AC-009 |
| EC-X.16.002-10 | ~L4292-4298 | AC-009 (WIRING-EXEMPT) |
| EC-X.16.002-11 | ~L4299-4305 | AC-009 (informational, no VP cell) |

Every VP clause, BC postcondition, and Edge Case above appears in exactly one map row and is
owned by exactly one AC. The **Test:** lines below cite these clause ids by reference (D-386) --
they do not restate clause content.

## Narrative

- **As a** `jr api` user who needs to pass query-string parameters to an arbitrary Jira REST endpoint
- **I want to** supply repeatable `--query-param`/`-q NAME=VALUE` flags that are percent-encoded and merged onto the path
- **So that** I no longer have to hand-encode and hand-append a query string onto `<path>` myself, matching the ergonomics of `gh api -f`/HTTPie `name==value`/`curl -G --data-urlencode`

## Behavioral Contracts

| BC | Role | Clauses this story implements |
|----|------|-------------------------------|
| BC-X.16.001 | PRIMARY (new, cycle-014 F2) | The `-q`/`--query-param` clap flag, `append_query_params`'s full assembly algorithm (Behavior 1-5, Postconditions 1-5), all Edge Cases EC-X.16.001-1..14 |
| BC-X.16.002 | PRIMARY (new, cycle-014 F2) | `parse_query_param`'s malformed-value error taxonomy (M1/M2), pre-flight ordering (Postcondition 1), all-or-nothing (Postcondition 3), Edge Cases EC-X.16.002-1..11 |

**Anchor justification:** BC-X.16.001/002 are the sole BCs governing `jr api --query-param` in this spec corpus (`cross-cutting.md`, new `## BC-X.16` subsection). Both were newly authored at cycle-014 F2 specifically to close issue #583; this story is the F4-bound implementation of that already-approved new BC family.

## Acceptance Criteria

### AC-001 (traces to BC-X.16.001 Behavior 1, Postcondition 2, EC-X.16.001-4/5/8/9/12/14)
`src/cli/api.rs::append_query_params(path: &str, pairs: &[(String, String)]) -> String` (new pure
function) implements BC-X.16.001 Behavior 1 (`cross-cutting.md` ~L3806-3822) and Postcondition 2
(~L3880-3891) in full -- see those clauses (and the VP-API-QP-001 clause map rows below) for the
separator algorithm; this AC does not restate it and does not narrow it.
**Test (D-386 bind-by-reference):** Implements VP-API-QP-001(equation), VP-API-QP-001(EC-4),
VP-API-QP-001(EC-5), VP-API-QP-001(empty-query-frag), VP-API-QP-001(EC-8),
VP-API-QP-001(EC-9), VP-API-QP-001(EC-12), VP-API-QP-001(EC-14), and VP-API-QP-001(fault-models)
(see the Clause-Level Map above for each clause's exact `cross-cutting.md` line range). Every
cell, setup, argv, expected value/wire value, stderr substring (present AND absent), counter-mock
(`.expect(0)`/zero-HTTP), oracle/generator constraint and anti-vacuity assertion in the cited
clause(s) is binding and must be implemented exactly as written there; this story does not
restate them, and nothing here narrows them. All cells live in `src/cli/api.rs`'s `#[cfg(test)]
mod tests`, grouped into ONE `proptest!` function (the separator oracle) plus 7 separate
`#[test]` functions -- one per pinned example, per Task 9's counting-unit rule (EC-4, EC-5,
empty-query-plus-fragment (no EC id of its own), EC-8 as ONE test covering both pinned forms,
EC-9, EC-12, EC-14). All 8 functions are RED at the Task 1 stub (`todo!()` panic).

### AC-002 (traces to BC-X.16.001 Behavior 2, Postcondition 4, EC-X.16.001-12/13)
The `-q`/`--query-param` clap field is a plain `Vec<String>` with NO `value_delimiter` (Behavior 1
intro, ~L3797-3802). This AC implements BC-X.16.001 Behavior 2 and Postcondition 4
(~L3823-3825, ~L3896-3897) in full -- see those clauses (and the VP-API-QP-002 clause map rows
below) for the repeated-names semantics; this AC does not restate them and does not narrow them.
**Test (D-386 bind-by-reference):** Implements VP-API-QP-002(oracle), including its
`existing == generated_existing_pairs` anti-vacuity generator constraint,
VP-API-QP-002(generator-constraint), VP-API-QP-002(pinned-decode-example),
VP-API-QP-002(argv-EC-13), VP-API-QP-002(argv-repeated-flags), VP-API-QP-002(argv-mixed), and
VP-API-QP-002(fault-models) (see the Clause-Level Map above for line ranges). Every cell, setup,
argv, expected value/wire value, stderr substring (present AND absent), counter-mock
(`.expect(0)`/zero-HTTP), oracle/generator constraint and anti-vacuity assertion in the cited
clause(s) is binding and must be implemented exactly as written there; this story does not
restate them, and nothing here narrows them. The `proptest!` oracle (including its
generator-constraint/anti-vacuity assertion) and the pinned decode example are ONE `proptest!`
plus ONE `#[test]` in `src/cli/api.rs`'s `#[cfg(test)] mod tests`; the three argv cells (EC-13,
repeated-flags, mixed) are three separate `#[test]` functions in `tests/api_query_param.rs`. All
5 functions are RED at the Task 1 stub.

### AC-003 (traces to BC-X.16.001 Behavior 3, Postcondition 3, EC-X.16.001-3/10/11)
`src/cli/api.rs::append_query_params` implements BC-X.16.001 Behavior 3 and Postcondition 3
(~L3826-3852, ~L3892-3895) in full, including the pinned `--help` substring requirement (D-380,
settled 2026-09-25) -- see those clauses (and the VP-API-QP-003 clause map rows below) for the
encoding/no-trim/help-text rules; this AC does not restate them and does not narrow them.
**Test (D-386 bind-by-reference):** Implements VP-API-QP-003(intro), VP-API-QP-003(a) -- whose
round-trip assertion requires `encode(v)` to be the NAME/VALUE segment extracted from
`append_query_params`'s own output, NOT a direct `urlencoding::encode` call (a direct call would
be tautological and GREEN at the Task 1 stub) -- VP-API-QP-003(b), VP-API-QP-003(c),
VP-API-QP-003(d) (whose no-trim examples also run through `parse_query_param`, VP-API-QP-005),
VP-API-QP-003(e), VP-API-QP-003(further-pinned), and VP-API-QP-003(fault-models) (see the
Clause-Level Map above for line ranges). Every cell, setup, argv, expected value/wire value,
stderr substring (present AND absent), counter-mock (`.expect(0)`/zero-HTTP), oracle/generator
constraint and anti-vacuity assertion in the cited clause(s) is binding and must be implemented
exactly as written there; this story does not restate them, and nothing here narrows them. The
biased `proptest!` ((a)/(b)/(c)/(d)) plus one `#[test]` per further-pinned/(c)/(d) example, per
Task 9's counting-unit rule ((c)'s `*`->`%2A` and space->`%20`; (d)'s two no-trim examples;
further-pinned `%`->`%25`, `+`->`%2B`, `é`->`%C3%A9`, literal `%25`->`%2525` -- 8 pinned-example
`#[test]`s total), live in `src/cli/api.rs`'s `#[cfg(test)] mod tests`; the (e) `--help` cell is
a separate `#[test]` in `tests/api_query_param.rs`. All 9 direct-call functions plus the 1
subprocess function are RED at the Task 1 stub.

### AC-004 (traces to BC-X.16.001 Behavior 4/5, Postconditions 1/5, EC-X.16.001-6/7)
`src/cli/api.rs::append_query_params` implements BC-X.16.001 Behavior 4/5 and Postconditions 1/5
(~L3853-3863, ~L3876-3879, ~L3898-3900) in full -- see those clauses (and the VP-API-QP-004
clause map rows below) for the method-orthogonality and zero-flag-identity rules; this AC does
not restate them and does not narrow them.
**Test (D-386 bind-by-reference):** Implements VP-API-QP-004(structural) -- including its
request-body assertion (the `-d` input equals the received body, never moved into the query) --
VP-API-QP-004(1), VP-API-QP-004(2), and VP-API-QP-004(fault-models) (see the Clause-Level Map
above for line ranges). Every cell, setup, argv, expected value/wire value, stderr substring
(present AND absent), counter-mock (`.expect(0)`/zero-HTTP), oracle/generator constraint and
anti-vacuity assertion in the cited clause(s) is binding and must be implemented exactly as
written there; this story does not restate them, and nothing here narrows them. The structural
check plus the (1) zero-flag identity `proptest!` is ONE `proptest!` function in `src/cli/api.rs`'s
`#[cfg(test)] mod tests`; the table-driven method-orthogonality wiremock test (one `#[test]`
parameterized internally over all 5 methods x with/without `-d`, per Task 9's one-function-
per-scenario rule) and the two (2) zero-flag wiremock examples are `#[test]` functions in
`tests/api_query_param.rs`. RED/GREEN classification: table-driven test and the identity
`proptest!` are RED at the Task 1 stub; the 2 zero-flag wiremock examples are GREEN-nonexempt
(`PRE-EXISTING-BEHAVIOR`, Task 10(a2)).

### AC-005 (traces to BC-X.16.002 Behavior, Postcondition 1, EC-X.16.002-1, EC-X.16.001-2)
`src/cli/api.rs::parse_query_param(raw: &str) -> Result<(String, String)>` (new pure function,
distinct from `append_query_params`) implements BC-X.16.002's Behavior and Postcondition 1
(~L4131-4140, ~L4178-4189) in full -- see those clauses (and the VP-API-QP-005 clause map rows
below) for the split-on-first-`=` / M1 rules; this AC does not restate them and does not narrow
them.
**Test (D-386 bind-by-reference):** Implements VP-API-QP-005(intro), VP-API-QP-005(1) -- whose
`Err`-case "other substring absent" assertion is filtered with `prop_assume!` to `raw` values
that do not themselves contain D1 or D2 -- and, for its `-q foo` wiremock cell, VP-API-QP-005(2)
(see the Clause-Level Map above for line ranges). Every cell, setup, argv, expected value/wire
value, stderr substring (present AND absent), counter-mock (`.expect(0)`/zero-HTTP),
oracle/generator constraint and anti-vacuity assertion in the cited clause(s) is binding and must
be implemented exactly as written there; this story does not restate them, and nothing here
narrows them. The partition `proptest!` plus the pinned `parse_query_param("")` example are
direct-call functions (one `proptest!` + one `#[test]`) in `src/cli/api.rs`'s `#[cfg(test)] mod
tests`; the `-q foo` wiremock cell is a separate `#[test]` in `tests/api_query_param.rs`. All
three are RED at the Task 1 stub.

### AC-006 (traces to BC-X.16.002 Behavior, Postcondition 1, Postcondition 2, EC-X.16.002-2)
`src/cli/api.rs::parse_query_param` implements BC-X.16.002's M2 (empty-NAME) row and
Postcondition 2 (~L4142-4167, ~L4190-4195) in full -- see those clauses (and the VP-API-QP-005
clause map rows below) for the pinned M2 message and `--output json` envelope rules; this AC
does not restate them and does not narrow them. An empty VALUE (`k=`) remains ALLOWED per
BC-X.16.001 EC-X.16.001-1, never M2.
**Test (D-386 bind-by-reference):** Implements VP-API-QP-005(intro) and VP-API-QP-005(2) (see
the Clause-Level Map above for line ranges). Every cell, setup, argv, expected value/wire value,
stderr substring (present AND absent), counter-mock (`.expect(0)`/zero-HTTP), oracle/generator
constraint and anti-vacuity assertion in the cited clause(s) is binding and must be implemented
exactly as written there; this story does not restate them, and nothing here narrows them. The
wiremock `-q =v` cell, and the `--output json` envelope cell (ONE `#[test]` asserting both the M1
and M2 envelope shapes, per the pass-5 fix), are `#[test]` functions in `tests/api_query_param.rs`.
Both are RED at the Task 1 stub.

### AC-007 (traces to BC-X.16.002 Postcondition 3, Invariants, EC-X.16.002-3)
`handle_api`'s `-q` validation implements BC-X.16.002 Postcondition 3 and its Invariants
(~L4196-4199, ~L4201-4212) in full -- see those clauses (and the VP-API-QP-006(i)/(ii) clause map
rows below) for the all-or-nothing / first-malformed-reported rules; this AC does not restate
them and does not narrow them.
**Test (D-386 bind-by-reference):** Implements VP-API-QP-006(i), VP-API-QP-006(ii), and
VP-API-QP-006(fault-models) (see the Clause-Level Map above for line ranges, including the
clause's own "every mock `.expect(0)`" intro at ~L4363-4365). Every cell, setup, argv, expected
value/wire value, stderr substring (present AND absent), counter-mock (`.expect(0)`/zero-HTTP),
oracle/generator constraint and anti-vacuity assertion in the cited clause(s) is binding and must
be implemented exactly as written there; this story does not restate them, and nothing here
narrows them. All 4 cells (2 all-or-nothing, 2 first-malformed-reported) are separate `#[test]`
functions in `tests/api_query_param.rs`. All 4 are RED at the Task 1 stub.

### AC-008 (traces to BC-X.16.002 Postcondition 1, D-188 pre-flight convention, EC-X.16.002-4)
`handle_api` (`src/cli/api.rs`) implements BC-X.16.002 Postcondition 1 (~L4178-4189) in full --
see that clause (and the VP-API-QP-006(iii)/(iv) clause map rows below) for the exact pre-flight
insertion point and ordering; this AC does not restate it and does not narrow it.
**Test (D-386 bind-by-reference):** Implements VP-API-QP-006(iii) and VP-API-QP-006(iv) (see the
Clause-Level Map above for line ranges, including the clause's own "every mock `.expect(0)`"
intro at ~L4363-4365). Every cell, setup, argv, expected value/wire value, stderr substring
(present AND absent), counter-mock (`.expect(0)`/zero-HTTP), oracle/generator constraint and
anti-vacuity assertion in the cited clause(s) is binding and must be implemented exactly as
written there; this story does not restate them, and nothing here narrows them. The (iii)
held-open-stdin cell is a `#[test]` in `tests/api_query_param.rs` spawned via
`std::process::Command` (not `assert_cmd`, per the clause's own rationale for why that library
cannot be used here) with a held-open `ChildStdin` handle, polling `try_wait()` against the
clause's own deadline; the (iv) before-`-H` cell is a separate `#[test]` in the same file. Both
are RED at the Task 1 stub.

### AC-009 (traces to BC-X.16.002 Edge Cases EC-X.16.002-5..10; EC-X.16.002-11 informational, no VP cell)
Clap's own attached-form and missing-value parsing feeds `parse_query_param` per
EC-X.16.002-5..10 (`cross-cutting.md` ~L4231-4298; see the Edge Case -> Owning AC map above for
each one's exact line range) -- this AC does not restate those outcomes and does not narrow
them. The `-q`/`--query-param` flag is NOT declared with `allow_hyphen_values`. EC-X.16.002-11
(~L4299-4305) is informational only, inherited clap behavior with no owning VP cell (same
treatment as EC-X.14.001-14) -- recorded for traceability, no test obligation.
**Test (D-386 bind-by-reference):** Implements VP-API-QP-005(3) (see the Clause-Level Map above
for line range). Every cell, setup, argv, expected value/wire value, stderr substring (present
AND absent), counter-mock (`.expect(0)`/zero-HTTP), oracle/generator constraint and anti-vacuity
assertion in the cited clause is binding and must be implemented exactly as written there; this
story does not restate them, and nothing here narrows them. All 6 cells (EC-5, EC-6, EC-7, EC-8,
EC-9, EC-10) are separate `#[test]` functions in `tests/api_query_param.rs` (one per EC id, per
Task 9's counting rule; EC-9's three attached-empty variants count as ONE cell/test). RED/GREEN
classification: EC-5, EC-6, EC-7, EC-9 are RED at the Task 1 stub; EC-8 and EC-10 are
WIRING-EXEMPT (clap-level rejection, GREEN at stub -- Task 10(a)). The EC-7 function additionally
runs the EC-6 invocation, per the clause's own byte-identical-stderr bullet.

### AC-010 (traces to BC-X.16.001 Trace, prd-delta.md F4 doc-delta obligation PASS-13/P13-003)
`README.md`'s `jr api <PATH>` row (~L332) is updated to document `-q`/`--query-param NAME=VALUE`. (The same row's pre-existing, unrelated `--body` naming mismatch -- the actual flag is `-d`/`--data` -- is drift item `README-JR-API-BODY-FLAG` and is explicitly NOT corrected by this story.)
**Test:** N/A (doc artifact); presence checked at PR review.

### AC-011 (traces to verification-delta.md §2 "examine_globs" table, D-382)
`.cargo/mutants.toml`'s `examine_globs` array gains `"src/cli/api.rs"` (33 -> 34 entries, verified by actual count against STORY-A's already-landed 33). `docs/specs/cargo-mutants-policy.md` gains the EXACT §Scope bullet pinned verbatim by `verification-delta.md` §2 (do not paraphrase or drop the parenthetical descriptions):

`` - `src/cli/api.rs` — `append_query_params` (pure path + query-pair assembler, encodes each NAME/VALUE exactly once), `parse_query_param` (NAME=VALUE split and validation for -q) (added cycle-014) ``

its "Current `examine_globs` count" line changes 33 -> 34, and a new newest-first row is added to the `## Changelog` table. Per `scripts/check-cargo-mutants-policy-citations.sh`, every backtick token in the bullet after the file token that matches `^[a-z_][a-z0-9_]*$` is treated as a function-name citation requiring a matching `fn` definition in that file -- the parenthetical descriptions above intentionally backtick nothing else, and must not be edited to backtick any other lowercase identifier (e.g. a type or module name), or the guard will misclassify it as an undefined-function citation and fail CI (CI-MUTANTS-CITE-001).

**Pinned bullet placement:** the new `src/cli/api.rs` bullet MUST be inserted inside `## Scope`
directly after the existing `src/jql.rs` bullet's group (`docs/specs/cargo-mutants-policy.md`
~L81-89, ending `cycle-009 F7)`) -- and, since STORY-A (delivered first, D-381) has already
appended its own `src/cli/user.rs` bullet at that same spot, directly after STORY-A's bullet --
and BEFORE the blank line that precedes the `**FIX-F7-001 deferred**` paragraph (~L91). Verify
these line numbers against the file's CURRENT (post-STORY-A) state before editing; do not trust
this story's stated numbers blindly. The new bullet MUST NOT land at or below the
`### Sibling Candidates` heading (~L150 pre-STORY-A) -- `scripts/check-cargo-mutants-policy-citations.sh`'s
§Scope-range `awk` extraction (~L41-46) stops parsing at the first `^### Sibling Candidates` or
next `^## ` heading, so a bullet placed there would be silently excluded from citation validation,
defeating the guard. After editing, verify the guard's parsed §Scope bullet-group count increased
by exactly one relative to its pre-edit (STORY-A-landed) count.
**Test:** N/A (config/doc); `tests/mutants_glob_existence.rs` passes automatically; `scripts/check-cargo-mutants-policy-citations.sh` passes since both functions are defined in the same PR, and its parsed §Scope bullet-group count increases by exactly one.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `append_query_params` | `src/cli/api.rs` | Pure (no I/O, no `JiraClient`) |
| `parse_query_param` | `src/cli/api.rs` | Pure (no I/O) |
| `Command::Api`'s `-q`/`--query-param` field | `src/cli/mod.rs` | Pure (clap derive declaration) |
| `handle_api`'s pre-flight wiring | `src/cli/api.rs` | Effectful-shell (calls the pure functions before building the request) |

Reference: `architecture/module-decomposition.md`, `architecture/dependency-graph.md` (no module-boundary change; F1 confirmed no architecture delta).

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-X.16.001-1 | `k=` (empty VALUE) | Allowed, sent as-is |
| EC-X.16.001-2 | `jql=status=Done` (VALUE contains `=`) | Splits on FIRST `=` only |
| EC-X.16.001-3 | Non-ASCII VALUE (e.g. `café`) | UTF-8 bytes percent-encoded (`é` -> `%C3%A9`) |
| EC-X.16.001-4 | Path already ends `?existing=1` | `&`-joined, existing text unchanged |
| EC-X.16.001-5 | Path contains `#fragment` | Query inserted before `#`; fragment passed through verbatim, never transmitted (RFC 9112 §3.2) |
| EC-X.16.001-6 | Combined with `-X POST/PUT/DELETE/PATCH` | Identical assembly regardless of method |
| EC-X.16.001-7 | `--query-param` entirely absent | Byte-identical to `normalize_path`'s output |
| EC-X.16.001-8 | Path ends in bare `?` or `&` | No separator inserted |
| EC-X.16.001-9 | Query component ends in literal `?` (e.g. `?jql=why?`) | Still `&`-joined, never confused with EC-8 |
| EC-X.16.001-10 | NAME is whitespace-only (e.g. `" =v"`) | Allowed (not empty), percent-encoded |
| EC-X.16.001-11 | VALUE has leading/trailing whitespace | Not trimmed, percent-encoded as-is |
| EC-X.16.001-12 | `-q` NAME collides with existing query NAME | Neither deduped nor overridden; both sent, existing first (D-380) |
| EC-X.16.001-13 | `-q fields=summary,status` | ONE pair, comma is ordinary VALUE content |
| EC-X.16.001-14 | Path has no query, ends in `&` (e.g. `/x&`) | Fresh `?` introduced: `/x&?k=v` |
| EC-X.16.002-1 | `--query-param foo` (no `=`) | Exit 64, M1 |
| EC-X.16.002-2 | `--query-param =v` (empty NAME) | Exit 64, M2 |
| EC-X.16.002-3 | Second of two flags malformed | Whole invocation fails, first malformed value reported |
| EC-X.16.002-4 | `-d @- -q bad` with stdin held open | Exits 64 on M1 without ever blocking on stdin |
| EC-X.16.002-5..7 | `-q=v` / `-q==v` / `--query-param==v` | M1 `(got: v)` / M2 `(got: =v)` / M2 `(got: =v)` |
| EC-X.16.002-8 | `-q -x=1` (hyphen-leading token as value) | Clap exit 2 (`unexpected argument`), not this BC's taxonomy |
| EC-X.16.002-9 | `-q ""` / `-q=` / `--query-param=` | M1 `(got: )` |
| EC-X.16.002-10 | `-q` as the last argv token | Clap exit 2 (`a value is required for`) |
| EC-X.16.002-11 | Non-UTF-8 `-q` value | Clap exit 2 before `parse_query_param` runs (informational, no VP cell) |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `append_query_params` (`src/cli/api.rs`) | pure-core | No I/O, no `JiraClient`, string-in/string-out |
| `parse_query_param` (`src/cli/api.rs`) | pure-core | No I/O, `&str -> Result<(String, String)>` |
| `Command::Api` clap declaration (`src/cli/mod.rs`) | pure-core | Derive-macro declaration |
| `handle_api` (`src/cli/api.rs`) | effectful-shell | Builds and sends the HTTP request after the pure pre-flight steps |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~3,600 |
| Referenced code (`src/cli/api.rs` full file including `normalize_path`/`parse_header`/`resolve_body` precedent, `src/cli/mod.rs::Command::Api`, `src/main.rs`'s `Command::Api` arm) | ~2,800 |
| Test files (existing `jr api` integration tests, grep-scoped) | ~1,500 |
| Tool output overhead | ~1,200 |
| **Total** | **~9,100** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~5%** |

## Tasks

1. [ ] **STUB:** add `pub(crate) fn append_query_params(path: &str, pairs: &[(String, String)]) -> String` and `pub(crate) fn parse_query_param(raw: &str) -> Result<(String, String)>` to `src/cli/api.rs` with `todo!()` bodies (signatures per AC-001/AC-005); add the `-q`/`--query-param: Vec<String>` field to `Command::Api` (`src/cli/mod.rs`, no `value_delimiter`, no `allow_hyphen_values`) and wire the pre-flight call site into `handle_api` and `src/main.rs`'s `Command::Api` dispatch arm -- the `handle_api` wiring MUST short-circuit around both stubs when zero `-q` flags are supplied (use the pre-existing `normalize_path` output unchanged), so the crate compiles end-to-end and the zero-flag path never touches a `todo!()`. **Short-circuit is STUB-STAGE ONLY (P6-006):** this short-circuit is a temporary stub-stage measure, present only so the Red Gate can run before either function is implemented -- Task 13 REMOVES it and calls both functions unconditionally, since `append_query_params(p, &[]) == p` is an identity (BC-X.16.001 Postcondition 5) that makes the short-circuit and its removal behaviorally indistinguishable once implemented, and leaving it in place would leave an equivalent `delete !` mutant unkillable under the `--in-diff` mutants gate once `src/cli/api.rs` enters `examine_globs` (AC-011). **No pinned help text at stub:** the `-q`/`--query-param` field's doc comment / clap `help`/`long_help` string MUST NOT contain the BC-X.16.001 Behavior 3 pinned substring `"do not pre-encode"` at this stage -- Task 12 (clap field finalization) is what adds it; this keeps AC-003's `--help` test cell genuinely RED at the Task 1 stub (Task 10(a)) rather than accidentally GREEN from a premature-but-correct doc comment -- `stub-architect`
2. [ ] Write the `proptest!` separator oracle for `append_query_params` + pinned examples (AC-001's cited VP-API-QP-001 clauses) (AC-001) in `src/cli/api.rs`'s `#[cfg(test)] mod tests`. **The test-writer MUST read the cited VP clause(s) in `cross-cutting.md` in full before writing; the VP text, not this story, is the source of truth for cell contents.** -- `test-writer`
3. [ ] Write the repeated-names `proptest!` oracle (AC-002's cited VP-API-QP-002 clauses) in `src/cli/api.rs`'s `#[cfg(test)] mod tests`, plus the three argv cells in `tests/api_query_param.rs` (AC-002). **The `proptest!` oracle MUST assert the generator-constraint/anti-vacuity check `existing == generated_existing_pairs` (VP-API-QP-002(generator-constraint)) as a second assertion alongside the main oracle equality -- omitting it lets the generator silently collapse to an empty `existing` and pass vacuously.** **The test-writer MUST read the cited VP clause(s) in `cross-cutting.md` in full before writing; the VP text, not this story, is the source of truth for cell contents.** -- `test-writer`
4. [ ] Write the encoding-exactly-once biased `proptest!` + pinned examples (AC-003's cited VP-API-QP-003 clauses) in `src/cli/api.rs`'s `#[cfg(test)] mod tests`, plus the `--help` cell in `tests/api_query_param.rs` (AC-003). **The round-trip assertion (VP-API-QP-003(a)) MUST extract `encode(v)` from `append_query_params`'s own output, NOT call `urlencoding::encode` directly -- a direct call would be tautological and GREEN at the Task 1 stub, defeating the Red Gate.** **The test-writer MUST read the cited VP clause(s) in `cross-cutting.md` in full before writing; the VP text, not this story, is the source of truth for cell contents.** -- `test-writer`
5. [ ] Write the method-orthogonality table-driven wiremock test + zero-flag wiremock examples in `tests/api_query_param.rs`, and the zero-flag identity `proptest!` in `src/cli/api.rs`'s `#[cfg(test)] mod tests` (AC-004's cited VP-API-QP-004 clauses). **The test-writer MUST read the cited VP clause(s) in `cross-cutting.md` in full before writing; the VP text, not this story, is the source of truth for cell contents.** -- `test-writer`
6. [ ] Write the `parse_query_param` partition `proptest!` + pinned example (AC-005's cited VP-API-QP-005 clauses) in `src/cli/api.rs`'s `#[cfg(test)] mod tests`, plus the wiremock/JSON-envelope cells in `tests/api_query_param.rs` (AC-005, AC-006). **Each `Err`-case's "other distinguishing substring absent" assertion (VP-API-QP-005(1)) MUST be filtered with `prop_assume!` to `raw` values that do not themselves contain D1 or D2 -- omitting the filter lets the property vacuously fail to exercise the absence check.** **The test-writer MUST read the cited VP clause(s) in `cross-cutting.md` in full before writing; the VP text, not this story, is the source of truth for cell contents.** -- `test-writer`
7. [ ] Write the four VP-API-QP-006(i)/(ii) cells (AC-007's cited clauses) in `tests/api_query_param.rs`. **The test-writer MUST read the cited VP clause(s) in `cross-cutting.md` in full before writing; the VP text, not this story, is the source of truth for cell contents.** -- `test-writer`
8. [ ] Write the held-open-stdin `std::process::Command` test + the before-`-H`-parsing cell (AC-008's cited VP-API-QP-006(iii)/(iv) clauses) in `tests/api_query_param.rs`. **The test-writer MUST read the cited VP clause(s) in `cross-cutting.md` in full before writing; the VP text, not this story, is the source of truth for cell contents.** -- `test-writer`
9. [ ] Write the attached-form argv cells (AC-009's cited VP-API-QP-005(3) clause) in `tests/api_query_param.rs` -- `test-writer`. **The test-writer MUST read the cited VP clause (VP-API-QP-005(3)) in `cross-cutting.md` in full before writing; the VP text, not this story, is the source of truth for cell contents.** **Counting-unit pin (feeds Task 10's density tally):** each of EC-X.16.002-5, -6, -7, -8, -9 (its three attached-empty variants `-q=`/`--query-param=`/`-q ""` count as ONE cell/test), and -10 is its OWN `#[test]` function (one function per EC id, not one function spanning multiple EC ids) -- this is the unit Task 10's `RED_TESTS`/`TOTAL_NEW_TESTS` counts are computed against, so EC-X.16.002-8 and EC-X.16.002-10's GREEN-at-stub status can be excluded/included per-test rather than ambiguously bundled with the RED EC-X.16.002-5/6/7/9 cells. The EC-X.16.002-7 test additionally runs the EC-X.16.002-6 invocation (`-q==v`) to assert byte-identical stderr between the two (P6-003(d)) -- this does not change its status as ONE `#[test]`
10. [ ] Confirm Red Gate against the Task 1 stub, applying the per-story-delivery.md density
    formula (`RED_RATIO = RED_TESTS / (TOTAL_NEW_TESTS - EXEMPT_TESTS)`, `EXEMPT_TESTS =
    GREEN-BY-DESIGN_count + WIRING-EXEMPT_count`, ~L45-60) using the Task 9 counting unit, applied
    story-wide (ADV-C14-F3-P5-002(b)): **one `#[test]` (or `proptest!` block) per pinned
    example / EC id / scenario.**
    (a) **Denominator-exempt cells (removed from `TOTAL_NEW_TESTS - EXEMPT_TESTS`, not merely
    "excluded from the numerator" -- a GREEN cell is never in `RED_TESTS` to begin with).
    `EXEMPT_TESTS = WIRING-EXEMPT_count` only in this story (`GREEN-BY-DESIGN_count = 0` --
    see (a2)):**
      - EC-X.16.002-8 (`-q -x=1` -> clap exit 2 `unexpected argument`) and EC-X.16.002-10 (`-q` as
        the last argv token -> clap exit 2 `a value is required for`), both part of AC-009's test
        cells, are GREEN at the Task 1 stub -- clap's own attached-form/missing-value parsing
        (the `-q`/`--query-param: Vec<String>` field declared with no `allow_hyphen_values`)
        rejects them before `parse_query_param` or `append_query_params` ever runs (mirrors
        STORY-A's `Cli::try_parse_from` cells). Category: **WIRING-EXEMPT**
        (`rationale_category: FRAMEWORK-WIRING` in the red-gate-log table) -- each passes because
        the correct clap field/flag wiring already exists in the Task 1 stub, not because either
        new function was implemented early.
      No other cell qualifies for `EXEMPT_TESTS`; a full sweep confirmed this pair is the complete
      exempt set (ADV-C14-F3-P5-001: AC-004's zero-flag wiremock examples, previously listed here
      as GREEN-BY-DESIGN, are reclassified in (a2) below and no longer reduce the denominator).
    (a2) **Non-exempt GREEN-at-stub cells (stay in `TOTAL_NEW_TESTS - EXEMPT_TESTS`; GREEN but
    NOT `RED_TESTS` and NOT `EXEMPT_TESTS`) -- new per ADV-C14-F3-P5-001:**
      - AC-004's zero-flag WIREMOCK EXAMPLES (Task 5, VP-API-QP-004 layer (2): `jr api
        rest/api/3/myself` and `jr api "/rest/api/3/search?jql=a&"`, no `-q` flag at all) are
        GREEN at the Task 1 stub -- Task 1's required short-circuit routes the zero-`-q` path
        around both `todo!()` bodies entirely, onto the pre-existing, unmodified `normalize_path`
        output. `rationale_category: PRE-EXISTING-BEHAVIOR` in the red-gate-log table. This is
        NOT `GREEN-BY-DESIGN`: per-story-delivery.md (~L56) limits `GREEN-BY-DESIGN` to behavior
        "deterministic from the type system alone," and this pair is GREEN because of a stub
        wiring/design choice (the required short-circuit), not a type-system fact.
        PRE-EXISTING-BEHAVIOR is a `rationale_category` label for the log table, not one of the
        two categories (`GREEN-BY-DESIGN`, `WIRING-EXEMPT`) that reduce `EXEMPT_TESTS` -- these
        two cells therefore remain in the denominator, matching sibling STORY-B's treatment of
        its own PRE-EXISTING-BEHAVIOR GREENs. (P6-006: Task 13 later REMOVES the Task 1
        short-circuit itself, but since `append_query_params(p, &[]) == p` is an identity, these
        two cells remain GREEN post-removal too -- for a different, permanent reason -- so this
        classification is unaffected by that later change.)
    (b) every other new test cell -- i.e. every cell NOT listed in (a) or (a2) -- fails
    (`todo!()` panic / behavior absent) and is `RED_TESTS`. This explicitly INCLUDES the AC-004
    zero-flag identity `proptest!` (direct calls to `append_query_params(p, &[])` hit the
    `todo!()` body -- this is RED, it calls the stub directly and is NOT the same cell as the
    non-exempt GREEN wiremock examples in (a2)) and the `-q` method-orthogonality wiremock table's
    `-q`-bearing cells (RED for the same reason);
    (c) the ONLY regression guards required GREEN both before and after this story: the AC-004
    zero-flag WIREMOCK EXAMPLES from (a2), every pre-existing `jr api` test in
    `tests/cli_handler.rs` (unmodified, pre-existing behavior -- must never regress), AND
    `tests/rate_limit_holdouts.rs::test_s_1_07_h_013_send_raw_gave_up_warning_in_stderr` (~L134,
    BC-X.1.005/BC-X.1.009 -- drives `jr api /rest/api/3/myself` with zero `-q` flags as a real
    subprocess and asserts on stderr; must remain byte-for-byte unaffected by this story's
    pre-flight `-q` step).
    (d) **Full per-cell enumeration** (ADV-C14-F3-P5-002(b); reproduces every pinned example /
    EC id / scenario each AC's Test line requires, tagged RED / GREEN-nonexempt / EXEMPT, so the
    (e) tally below is checkable against this list rather than asserted):

    Row labels below (D-386) are `<VP clause> <EC id>` (or the Clause-Level Map's descriptive tag
    where no EC id exists) -- see the Clause-Level Map above for what each cited clause binds; no
    pinned value is restated here.

    | Task / AC | Row label | Tag |
    |---|---|---|
    | Task 2 / AC-001 | VP-API-QP-001(equation) | RED |
    | Task 2 / AC-001 | VP-API-QP-001(EC-4) EC-X.16.001-4 | RED |
    | Task 2 / AC-001 | VP-API-QP-001(EC-5) EC-X.16.001-5 | RED |
    | Task 2 / AC-001 | VP-API-QP-001(empty-query-frag) | RED |
    | Task 2 / AC-001 | VP-API-QP-001(EC-8) EC-X.16.001-8 (one test, both pinned forms) | RED |
    | Task 2 / AC-001 | VP-API-QP-001(EC-9) EC-X.16.001-9 | RED |
    | Task 2 / AC-001 | VP-API-QP-001(EC-12) EC-X.16.001-12 | RED |
    | Task 2 / AC-001 | VP-API-QP-001(EC-14) EC-X.16.001-14 | RED |
    | Task 3 / AC-002 | VP-API-QP-002(oracle) + VP-API-QP-002(generator-constraint) (one `proptest!`, two assertions) | RED |
    | Task 3 / AC-002 | VP-API-QP-002(pinned-decode-example) | RED |
    | Task 3 / AC-002 | VP-API-QP-002(argv-EC-13) EC-X.16.001-13 | RED |
    | Task 3 / AC-002 | VP-API-QP-002(argv-repeated-flags) | RED |
    | Task 3 / AC-002 | VP-API-QP-002(argv-mixed) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(intro)+(a)+(b) (one biased `proptest!`) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(c) pinned example 1 (`*`) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(c) pinned example 2 (space) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(further-pinned) pinned example (`%`) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(further-pinned) pinned example (`+`) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(further-pinned) pinned example (`é`) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(further-pinned) pinned example (literal `%25`) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(d) no-trim pinned example 1 (also runs through `parse_query_param`) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(d) no-trim pinned example 2 (also runs through `parse_query_param`) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(e) `--help` cell | RED |
    | Task 5 / AC-004 | VP-API-QP-004(structural) table-driven wiremock test | RED |
    | Task 5 / AC-004 | VP-API-QP-004(1) zero-flag identity `proptest!` | RED |
    | Task 5 / AC-004 | VP-API-QP-004(2) zero-flag wiremock example 1 | GREEN-nonexempt (PRE-EXISTING-BEHAVIOR) |
    | Task 5 / AC-004 | VP-API-QP-004(2) zero-flag wiremock example 2 | GREEN-nonexempt (PRE-EXISTING-BEHAVIOR) |
    | Task 6 / AC-005 | VP-API-QP-005(1) partition `proptest!` | RED |
    | Task 6 / AC-005 | VP-API-QP-005(1) pinned `parse_query_param("")` example | RED |
    | Task 6 / AC-005 | VP-API-QP-005(2) wiremock cell (`-q foo` -> M1) | RED |
    | Task 6 / AC-006 | VP-API-QP-005(2) wiremock cell (`-q =v` -> M2) | RED |
    | Task 6 / AC-006 | VP-API-QP-005(2) `--output json` envelope cell -- ONE `#[test]` asserting BOTH the M1 and M2 envelope shapes (not split into 2) | RED |
    | Task 9 / AC-009 | VP-API-QP-005(3) EC-X.16.002-5 | RED |
    | Task 9 / AC-009 | VP-API-QP-005(3) EC-X.16.002-6 | RED |
    | Task 9 / AC-009 | VP-API-QP-005(3) EC-X.16.002-7 (additionally runs the EC-6 invocation and asserts byte-identical stderr) | RED |
    | Task 9 / AC-009 | VP-API-QP-005(3) EC-X.16.002-8 | EXEMPT (WIRING-EXEMPT / FRAMEWORK-WIRING) |
    | Task 9 / AC-009 | VP-API-QP-005(3) EC-X.16.002-9 (three attached-empty variants merged into ONE test) | RED |
    | Task 9 / AC-009 | VP-API-QP-005(3) EC-X.16.002-10 | EXEMPT (WIRING-EXEMPT / FRAMEWORK-WIRING) |
    | Task 7 / AC-007 | VP-API-QP-006(i) cell 1 | RED |
    | Task 7 / AC-007 | VP-API-QP-006(i) cell 2 | RED |
    | Task 7 / AC-007 | VP-API-QP-006(ii) cell 1 | RED |
    | Task 7 / AC-007 | VP-API-QP-006(ii) cell 2 | RED |
    | Task 8 / AC-008 | VP-API-QP-006(iii) held-open-stdin cell | RED |
    | Task 8 / AC-008 | VP-API-QP-006(iv) before-`-H` cell | RED |

    (e) **Recomputed RED / EXEMPT / denominator tally** (ADV-C14-F3-P5-001, ADV-C14-F3-P5-002(c),
    P6 pin sweep; matches the (d) enumeration exactly; re-verify against the actual Step 3
    dispatch output before relying on it -- this is a pre-implementation projection, not a
    substitute for the real count):

    | AC / VP | New tests | RED | GREEN-nonexempt (category) | EXEMPT (category) |
    |---|---|---|---|---|
    | AC-001 (VP-API-QP-001) | 8 (separator oracle `proptest!` + 7 pinned examples) | 8 | 0 | 0 |
    | AC-002 (VP-API-QP-002) | 5 (repeated-names `proptest!` + pinned decode example + 3 argv cells: EC-X.16.001-13, repeated-flags, mixed) | 5 | 0 | 0 |
    | AC-003 (VP-API-QP-003) | 10 (encoding `proptest!` + 6 encode pinned examples + 2 no-trim pinned examples + `--help` cell) | 10 | 0 | 0 |
    | AC-004 (VP-API-QP-004) | 4 (table-driven method-orthogonality wiremock test + zero-flag identity `proptest!` + 2 zero-flag wiremock examples) | 2 | 2 (PRE-EXISTING-BEHAVIOR) | 0 |
    | AC-005/006/009 (VP-API-QP-005) | 11 (partition `proptest!` + pinned `parse_query_param("")` example + 2 wiremock cells + 1 `--output json` envelope cell + 6 attached-form cells) | 9 | 0 | 2 (WIRING-EXEMPT / FRAMEWORK-WIRING -- EC-X.16.002-8, EC-X.16.002-10) |
    | AC-007/008 (VP-API-QP-006) | 6 (2 all-or-nothing cells + 2 first-malformed-reported cells + held-open-stdin cell + before-`-H` cell) | 6 | 0 | 0 |
    | **Total** | **44** | **40** | **2** | **2** |

    `TOTAL_NEW_TESTS = 44`, `EXEMPT_TESTS = 2` (0 GREEN-BY-DESIGN + 2 WIRING-EXEMPT), so the
    denominator is `44 - 2 = 42`; `RED_TESTS = 40` (the 2 non-exempt GREEN cells stay in the
    denominator but are not RED); `RED_RATIO = 40 / 42 ≈ 0.952 >= 0.5` -- comfortably clears the
    BC-8.29.001 gate under this counting unit, with no full-exception path (denominator > 0) and
    no UNJUSTIFIED GREEN cells. Record this tally, and the actual counts observed after Step 3
    dispatch, in `red-gate-log.md`.
    (f) **`todo!()`-panic vs. subprocess-assertion failure mode** (ADV-C14-F3-P5-004, recomputed
    at P6): the 22 direct-call cells in (d) that invoke `append_query_params`/`parse_query_param`
    in-process (all of AC-001's 8 cells; AC-002's `proptest!` and pinned decode example, not its
    3 argv cells; AC-003's `proptest!` + 6 encode pinned (including the space -> `%20` pin) + 2
    no-trim pinned, not its `--help` cell; AC-004's zero-flag identity `proptest!` only, not its
    wiremock cells; AC-005's `proptest!` + pinned `""` example) can only fail with a raw
    `todo!()` panic (message containing "not yet implemented"), never a
    produced-and-asserted-wrong-value diff -- **this is the EXPECTED Red signal for this story's
    strict-`tdd_mode` stub** (Task 1 is a stub-architect `todo!()` stub per BC-5.38.001); the
    orchestrator must NOT re-dispatch the test-writer for these 22 cells on the basis of
    panic-vs-assertion-error alone. The remaining 22 cells in (d) are subprocess-level, all in
    `tests/api_query_param.rs` (spawned via `std::process::Command`/the CLI binary), and fail (or
    pass) via their own exit-code/stderr `assert_eq!`/`assert!` checks in the test function
    itself -- the child process's underlying `todo!()` panic surfaces there as an unexpected exit
    code / panic text on stderr, but the top-level test function fails via a normal assertion,
    satisfying Step 3's Red Gate requirement (~L35) literally.
11. [ ] Implement `append_query_params` and `parse_query_param` in `src/cli/api.rs` (AC-001..003, AC-005..007) -- `implementer`
12. [ ] Finalize the `-q`/`--query-param` clap field on `Command::Api` (`src/cli/mod.rs`) with the pinned help text (AC-003, AC-009) -- `implementer`
13. [ ] Wire `handle_api` to call `-q` parsing immediately after `normalize_path` and before `resolve_body`/`-H` parsing (AC-008); REMOVE Task 1's zero-flag short-circuit and call `parse_query_param`/`append_query_params` unconditionally on every invocation, including zero `-q` flags -- `append_query_params(p, &[]) == p` is an identity (BC-X.16.001 Postcondition 5), so this is behavior-preserving and closes the equivalent-mutant risk noted in Task 1 (P6-006, mirrors STORY-A Task 9) -- `implementer`
14. [ ] Confirm Green Gate: all tests pass, including the unchanged `tests/cli_handler.rs` suite
15. [ ] Update `README.md`'s `jr api <PATH>` row (~L332) (AC-010)
16. [ ] Add `src/cli/api.rs` to `.cargo/mutants.toml` `examine_globs`; add the §Scope bullet
    (inserted directly after the `src/jql.rs` bullet's group, ~L81-89, and after STORY-A's
    already-landed `src/cli/user.rs` bullet at that same spot, before the blank line preceding
    the `**FIX-F7-001 deferred**` paragraph at ~L91 -- verify current line numbers first; never
    at or below `### Sibling Candidates`, ~L150, per AC-011's pinned-placement note), bump the
    count line 33->34, add a `## Changelog` row to `docs/specs/cargo-mutants-policy.md`, and
    confirm the guard's parsed §Scope bullet-group count increased by exactly one (AC-011)
17. [ ] Add a CHANGELOG entry under `[Unreleased] > Added` describing the shipped behavior, before creating the PR
18. [ ] Run `cargo fmt --all -- --check`, `cargo clippy -- -D warnings`, `cargo test`, and the scoped `cargo mutants --in-diff`

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|-----------------|--------------------------|------------------------|
| S-cycle14-user-list-project-resolution (Wave 1, predecessor in the serial chain) | `.cargo/mutants.toml` `examine_globs` bumped 32->33; `docs/specs/cargo-mutants-policy.md`'s count line and §Scope table follow the same per-story pattern this story reuses (33->34) | Established the exact §Scope bullet form (`` `file` — `symbol` ``, not `file::symbol`) required by `scripts/check-cargo-mutants-policy-citations.sh` | The policy's hard-coded count line has no CI check comparing it against the real `.cargo/mutants.toml` count -- re-count the actual array entries before writing 34, don't trust the prior story's stated number blindly |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| `append_query_params` and `parse_query_param` MUST be pure -- no `JiraClient`, no network, no config parameter | BC-X.16.001 Invariants, BC-X.16.002 Source | AC-001..003, AC-005..007 tests need no wiremock for their proptest layers |
| `url::form_urlencoded::byte_serialize` MUST NOT be used for this assembly (space -> `+`, wrong semantics) | BC-X.16.001 Invariants | AC-003's encoder-identity assertion |
| `-q` validation MUST run strictly between `normalize_path` and `resolve_body`, before `-H` parsing | BC-X.16.002 Postcondition 1, D-188 | AC-008 |
| `-q`/`--query-param` MUST NOT be declared with `allow_hyphen_values` | BC-X.16.002 EC-X.16.002-8 | AC-009 |
| Query-param content MUST NEVER be merged into, or sourced from, `-d`/`--data` | BC-X.16.001 Behavior 4 | AC-004 |
| The two error messages MUST be pinned verbatim and mutually distinguishable by substring | BC-X.16.002 Pinned error messages, Invariants | AC-005, AC-006 |

## Library & Framework Requirements

No new dependency is added. `urlencoding = "2"` (existing pin, `Cargo.toml`; verified 2.1.3 behavior against source) is the PRODUCTION encoder. `url = "2"` (existing pin) provides `url::form_urlencoded::parse`, used ONLY as a test-oracle decoder in VP-API-QP-002/003's proptests -- never in production code. `url::form_urlencoded::byte_serialize` is explicitly forbidden for this story's production code.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/cli/mod.rs` | modify | New `-q`/`--query-param: Vec<String>` field on `Command::Api`, pinned help text (traces to AC-001, AC-002 -- no `value_delimiter`, AC-003, and AC-009 -- no `allow_hyphen_values`) |
| `src/main.rs` | modify | `Command::Api` dispatch arm passes the new field through to `handle_api` |
| `src/cli/api.rs` | modify | New `append_query_params`, `parse_query_param`; `handle_api` pre-flight wiring; new pure-unit and `proptest!` cases (separator oracle, repeated-names oracle, encoding proptest, zero-flag identity, `parse_query_param` partition) added to the existing `#[cfg(test)] mod tests` block (AC-001..003, AC-005..007) |
| `tests/api_query_param.rs` | create | New dedicated integration-test file for all wiremock/argv/clap-driven cells: VP-API-QP-002's argv+mixed cells, VP-API-QP-003's `--help` cell, VP-API-QP-004's method-orthogonality table + zero-flag wiremock examples, VP-API-QP-005's wiremock/JSON-envelope/attached-form cells, VP-API-QP-006's all-or-nothing/ordering/held-open-stdin/before-`-H` cells (AC-002..009). Kept separate from the existing `tests/cli_handler.rs` (already ~2,200 LOC) rather than extending it. |
| `README.md` | modify | `jr api <PATH>` row (~L332) documents `-q`/`--query-param` (AC-010) |
| `.cargo/mutants.toml` | modify | Add `src/cli/api.rs` to `examine_globs` (33->34) (AC-011) |
| `docs/specs/cargo-mutants-policy.md` | modify | §Scope bullet + count line 33->34 + `## Changelog` row (AC-011) |
| `CHANGELOG.md` | modify | `[Unreleased] > Added` entry |

## Definition of Done

- [ ] All 11 ACs pass their listed tests
- [ ] `cargo fmt --all -- --check` clean
- [ ] `cargo clippy -- -D warnings` clean
- [ ] `cargo test` green (full suite)
- [ ] Scoped `cargo mutants --in-diff` run against the PR diff, with `src/cli/api.rs` now in `examine_globs` scope
- [ ] `.cargo/mutants.toml` / `docs/specs/cargo-mutants-policy.md` edits verified against `scripts/check-cargo-mutants-policy-citations.sh` and `tests/mutants_glob_existence.rs`
- [ ] CHANGELOG entry present under `[Unreleased] > Added`
- [ ] Rebased onto STORY-A's merged `develop` tip before opening the PR (serial delivery, D-381)
- [ ] PR opened against `develop`, following commitizen branch/commit conventions

## Suggested Branch Name

`feat/api-query-param` (Conventional Commits, per CLAUDE.md's `type/short-description` convention; this adds a new capability, so `feat/`).
