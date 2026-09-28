---
document_type: story-revision-history
story_id: "S-cycle14-api-query-param"
cycle: cycle-014
status: historical — not normative
---

# S-cycle14-api-query-param -- Revision History

Historical record of F3 review-driven revisions. Not normative: where anything here differs from
the story body, the story body governs.

## Pass-15 fixes (2026-09-28, LOW/COSMETIC)

- Task 10(a2)'s first bullet justified the AC-004 zero-flag wiremock examples' PRE-EXISTING-
  BEHAVIOR classification by saying the pair was GREEN "because of a stub wiring/design choice" --
  that is the reasoning for a different classification (WIRING-EXEMPT), not this one. Reworded to
  the correct PRE-EXISTING reasoning: verified GREEN against the pre-story binary, since no `-q`
  field exists yet and the zero-flag invocation is unchanged pre-existing `jr api` behavior -- the
  Task 1 short-circuit merely preserves that behavior at the stub. Swept the rest of the story for
  the same pattern; no other PRE-EXISTING-BEHAVIOR cell used that reasoning.
- The Coverage Scope section listed the bare "Verification Properties" heading line above
  VP-API-QP-001..004 as in scope together with the paragraph beneath it, but the analogous heading
  above VP-API-QP-005/006 is correctly excluded on its own elsewhere in the same section. Split it
  the same way: the heading line is now excluded on its own, and the paragraph beneath it keeps its
  own scope entry. AC-001's existing coverage citation already spans both lines, so coverage is
  unaffected.
- dependency-graph-extended.md's file-overlap section pointed at `run`'s dispatch match at around
  line 212, but line 212 is actually where the `run` function itself starts -- the dispatch match
  is a little further down, at line 233. Reworded to cite both lines separately.
- Story version bumped to 4.2 to reflect this pass's fixes.

## Pass-14 fixes (2026-09-28, LOW/COSMETIC)

- AC-006 mentioned that an empty VALUE stays allowed, pointing at the same line range in
  cross-cutting.md that AC-005 already claims ownership of. Since AC-005 already owns that range,
  AC-006's mention is now written as plain prose (a line reference, no ownership tag) and labeled
  as an informational cross-reference to AC-005's own test coverage for that rule, instead of
  looking like AC-006 was claiming ownership too.
- AC-005 said Postcondition 1 (the pre-flight ordering rule) belongs solely to AC-008, but wrote
  it with the same kind of ownership tag AC-008 itself already uses for that same line range.
  Confirmed AC-008 does own it, so AC-005's mention is now plain prose (a line reference) rather
  than a second ownership tag for a clause AC-005 doesn't own.
- Swept every AC section for similar cases -- an AC referencing a clause "owned by" a different AC
  while still tagging it as if it owned that clause itself. No other cases were found; the two
  above were the only ones.
- The Token Budget section quoted exact line counts for the story file and for the history that
  was split out (912 lines, 797 lines, ~1,446 lines pre-split). Those counts were already stale,
  so they've been dropped -- the row now just gives the token estimate, which is what the budget
  section is actually for.
- The Coverage Scope intro used to say the old hand-written clause maps were "deleted by this
  revision." Reworded to point readers to this revision-history file instead, since that's where
  the old maps and the reasoning for removing them actually live now.
- Story version bumped to 4.1 to reflect this pass's fixes.

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
  is UNCHANGED and remains correct. **SUPERSEDED by pass-11 (P11-005): EC-8 is now
  GREEN-nonexempt; see Task 10(e).** (EC-10's WIRING-EXEMPT classification is unaffected and
  remains current.) Also pins the counting unit new Task 9 guidance
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
  (ADV-C14-F3-P4-002) that originally introduced the incorrect classification. **SUPERSEDED by
  pass-11 (P11-005): EC-8 is now GREEN-nonexempt, not WIRING-EXEMPT, and the recomputed tally
  above (`TOTAL_NEW_TESTS = 41`, `EXEMPT_TESTS = 2`) is likewise stale; see Task 10(e) for the
  current authoritative tally.**
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
  **SUPERSEDED by pass-11 (P11-005): EC-8 moved from WIRING-EXEMPT to GREEN-nonexempt, so
  `EXEMPT_TESTS` is no longer 2 (WIRING-EXEMPT-only); see Task 10(e) for the current
  authoritative tally.**
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
  "Everything the cited clause(s) specify is binding in its entirety and must be implemented exactly
  as written there; this story does not restate or narrow any of it." (category-free wording,
  pass-9 P9-001 -- supersedes the pass-8 category-enumerated wording; see the P8-006 bullet below,
  now marked SUPERSEDED), and (3) retains ONLY story-specific
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
  `RED_RATIO = 40 / 42 ~= 0.952`) is unchanged from the pass-6 recomputation below. **(Superseded
  by P11-005: EC-X.16.002-8 was later reclassified from EXEMPT to GREEN-nonexempt, changing these
  figures to `GREEN-nonexempt = 3`, `EXEMPT = 1`, `RED_RATIO = 40 / 43 ≈ 0.930` -- see the pass-11
  Revision Note and Task 10(e) for the current tally. `TOTAL_NEW_TESTS`/`RED_TESTS` are
  unaffected.)**
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
AC-003 9, AC-004 1, AC-005 2); subprocess cells stay at 22. **(Superseded by P11-005: non-exempt
GREEN is now `= 3`, `EXEMPT_TESTS = 1`, denominator `= 44 - 1 = 43`, `RED_RATIO = 40 / 43 ≈ 0.930
>= 0.5` -- EC-X.16.002-8 moved from exempt to non-exempt GREEN; the direct-call/subprocess split
of 22/22 is unaffected, since EC-X.16.002-8 is a subprocess cell either way.)** See Task 10(d)/(e)/(f)
below for the current recomputation.

## Revision Note (F3 adversarial pass-8 fixes, LOW/COSMETIC)

- **P8-003 (LOW):** AC-003's Test line and the Clause-Level Map disagreed on which
  VP-API-QP-003 clauses the biased `proptest!` carries: AC-003's Test line already said
  (a)/(b)/(c)/(d), but the Task 10(d) row label said only "(intro)+(a)+(b)", and the map's
  VP-API-QP-003(c)/(d) rows credited only the pinned-example rows, omitting the `proptest!`
  itself. Per VP-API-QP-003 (`cross-cutting.md` ~L4070-4091), the (c) encoder-identity and (d)
  no-trim assertions are both proptest-level assertions the biased `proptest!` itself makes
  (in addition to each having its own pinned examples) -- confirmed by rereading the clause.
  Fixed: (1) relabeled the Task 10(d) row to
  "VP-API-QP-003(intro)+(a)+(b)+(c)+(d) (one biased `proptest!`)"; (2) added
  "encoding `proptest!` (general assertion)" to the Clause-Level Map's VP-API-QP-003(c) and
  VP-API-QP-003(d) rows, alongside their existing pinned-example rows.
- **P8-004 (LOW):** The Edge Case -> Owning AC map assigned EC-X.16.001-1 (`k=`, empty VALUE)
  to AC-006, but AC-006's Test line cites only VP-API-QP-005(intro)/(2), neither of which has a
  `k=` cell. The owning clause is VP-API-QP-005(1)'s `Ok` case, whose `rest` "may be empty
  (EC-X.16.001-1)" (`cross-cutting.md` ~L4324), and VP-API-QP-005(1) is owned by AC-005 per the
  Clause-Level Map. Fixed: moved EC-X.16.001-1's Owning AC to AC-005 in the Edge Case map, and
  added `EC-X.16.001-1` to AC-005's trace header (now "traces to BC-X.16.002 Behavior,
  Postcondition 1, EC-X.16.002-1, EC-X.16.001-1, EC-X.16.001-2"). AC-006's own body note --
  "An empty VALUE (`k=`) remains ALLOWED per BC-X.16.001 EC-X.16.001-1, never M2" -- is
  unchanged and remains correct as a cross-reference, not a Test-line ownership claim.
- **P8-006 (COSMETIC):** The Clause-Level Map's closing sentence claimed every VP clause, BC
  postcondition, and Edge Case "is owned by exactly one AC," which is false -- several rows
  (e.g. VP-API-QP-005(intro), VP-API-QP-005(2), VP-API-QP-005(fault-models),
  VP-API-QP-006(fault-models)) list 2-3 owning ACs. Fixed the sentence to "owned by at least one
  owning AC." Also recounted every "(killed collectively by the N rows above)" tally in the VP
  Clause table against the actual row counts: VP-API-QP-001(fault-models) said "7 rows above"
  but 8 rows (equation, EC-4, EC-5, empty-query-frag, EC-8, EC-9, EC-12, EC-14) precede it --
  fixed to 8. VP-API-QP-003(fault-models) said "8 rows above" but 7 rows (intro, (a), (b), (c),
  (d), (e), further-pinned) precede it -- fixed to 7 (row count unchanged by the P8-003 edits
  above, which only changed cell text, not row count). While recounting, also found
  VP-API-QP-002(fault-models) said "5 rows above" but 6 rows (oracle, generator-constraint,
  pinned-decode-example, argv-EC-13, argv-repeated-flags, argv-mixed) precede it -- fixed to 6
  (not separately reported by pass-8 adversarial review, but the same class of error, caught by
  the recount pass this finding required).
- **Consistency sweep (pass-8):** Cross-checked every AC header's/Test line's VP-clause and EC
  citations against the Clause-Level Map and Edge Case -> Owning AC map (both directions) --
  no further mismatches found beyond P8-004's EC-X.16.001-1 case. Diffed all 9 AC **Test:**
  binding sentences (`grep`-style, whitespace-normalized) against each other: all 9 were
  textually identical except AC-009's (which correctly uses singular "clause" rather than
  "clause(s)," since AC-009 cites exactly one VP clause -- not a narrowing, a grammatical
  accommodation) -- **but all 9, plus the D-386 definition sentence that introduced the
  wording, omitted "exit code" from the category list, even though `handle_api`'s pre-flight
  exit-64-vs-exit-2 distinction is load-bearing throughout VP-API-QP-005/006 (e.g.
  EC-X.16.002-8/-10's exit 2 vs. EC-X.16.002-5/6/7/9's exit 64).** Fixed by inserting
  "exit code," into the canonical sentence (after "expected value/wire value," and before
  "stderr substring") at all 10 occurrences: the D-386 definition (Revision Note above) and
  all 9 AC Test lines (AC-001..AC-009) -- the sentence now reads "...expected value/wire value,
  exit code, stderr substring (present AND absent)...", and none of the 10 occurrences narrows
  by omitting any category. **SUPERSEDED by pass-9 (P9-001):** the category-enumerated sentence
  this bullet fixed and quotes above (both its pre-fix and post-fix forms) was itself replaced
  story-wide by a category-free binding sentence -- see the D-386 Revision Note above and every
  AC's current **Test:** line for the wording now in force. This bullet remains as a historical
  record of the pass-8 fix; its quoted sentence text is no longer the story's current wording.
- **P8-004 follow-up (LOW):** P8-004's own fix (above) carried forward a pre-existing
  "Postcondition 1" citation in AC-005's trace header/body that the BC Postcondition -> Owning AC
  map has always assigned solely to AC-008 (pre-flight ordering) -- AC-005's actual content is
  `parse_query_param`'s M1/M2 taxonomy, which is BC-X.16.002's Behavior clause, not a
  Postcondition. AC-006's trace header carried the identical spurious "Postcondition 1" citation
  (its body never claimed Postcondition 1 -- only Behavior's M2 row and Postcondition 2, matching
  the map). Fixed: removed "Postcondition 1" from AC-005's header and its body's clause list/line
  range (now cites only Behavior, ~L4131-4140, "see that clause"/"does not narrow it," singular),
  with an explicit body note that Postcondition 1 belongs to AC-008; removed "Postcondition 1"
  from AC-006's header (its body was already correct and unchanged). The BC Postcondition ->
  Owning AC table required no change -- it never listed AC-005 or AC-006 against Postcondition 1,
  so this fix makes the AC headers/bodies consistent with it rather than the reverse. Reswept
  every other AC's BC-postcondition citations against the table (AC-001 Postcondition 2,
  AC-002 Postcondition 4, AC-003 Postcondition 3, AC-004 Postconditions 1/5, AC-007
  Postcondition 3, AC-008 Postcondition 1) -- all match their sole table owner; no further
  mismatches found.

## Revision Note (F3 adversarial pass-9 fixes, LOW/MEDIUM/COSMETIC)

- **P9-001 (category-free binding sentence, MEDIUM):** The pass-8 canonical binding sentence
  enumerated a fixed category list ("cell, setup, argv, expected value/wire value, exit code,
  stderr substring (present AND absent), counter-mock (`.expect(0)`/zero-HTTP), oracle/generator
  constraint and anti-vacuity assertion") that, across passes 3-8, repeatedly proved incomplete --
  each pass found the enumeration silently omitting a category the cited clauses actually bind
  (most recently "exit code" at pass-8), and P9-001 itself was opened because "stdout" (the
  `--output json` empty-stdout requirement) was ALSO missing from the list. Rather than continue
  patching the enumeration one omission at a time, the category list is retired entirely. Fixed by
  replacing the canonical sentence, at all 10 occurrences (the D-386 definition and all 9 AC
  **Test:** lines, AC-001..AC-009), with the category-free wording: "Everything the cited
  clause(s) specify is binding in its entirety and must be implemented exactly as written there;
  this story does not restate or narrow any of it." This closes the whole defect class -- there is
  no longer a list for a future pass to find an omission in. The pass-8 P8-006 bullet (above),
  which quotes the now-superseded category-enumerated sentence as the record of its own fix, is
  marked SUPERSEDED in place rather than edited, preserving the historical record of what that fix
  actually changed at the time.
- **P9-003 (VP-API-QP-004(structural) ownership conflict, MEDIUM):** AC-004's **Test:** line
  assigned VP-API-QP-004(structural) to "ONE `proptest!` function" (bundled with the (1) zero-flag
  identity property), while the Clause-Level Map and Task 10(d)'s per-cell enumeration both
  already assigned it to the table-driven method-orthogonality wiremock test -- a real,
  cross-referenced disagreement about which test function is responsible for the structural
  clause. Rereading VP-API-QP-004 (`cross-cutting.md` ~L4092-4098): "Structural" is a signature
  fact (`append_query_params` takes no method/body parameter) immediately followed, in the same
  clause, by the table-driven wiremock test that is its only runtime check (including the
  request-body assertion). The table-driven test is therefore the correct sole owner -- matching
  the Map and Task 10(d), not AC-004's prior wording. Fixed by rewriting AC-004's **Test:** line to
  assign VP-API-QP-004(structural) to the table-driven wiremock test and VP-API-QP-004(1)
  (zero-flag identity) to its own separate `proptest!` function, agreeing with the Map and Task
  10(d) (which required no change to their own row assignments, only to AC-004). Also widened the
  Map's VP-API-QP-004(structural) row from `~L4092-4094` to `~L4092-4098` so its cited range
  actually covers the method x `-d` matrix and the request-body assertion sentence, not just the
  one-sentence structural fact. Walked all of VP-API-QP-004 (`~L4092-4108`) against the Map's four
  rows (structural `~L4092-4098`, (1) `~L4098-4101`, (2) `~L4101-4106`, fault-models
  `~L4106-4108`) -- the union covers the full clause with no gap.
- **P9-004 (VP-API-QP-005(intro) undercited, LOW):** VP-API-QP-005(intro) (`cross-cutting.md`
  ~L4307-4316) is where the M1/M2 pinned messages and their D1/D2 distinguishing substrings are
  DEFINED. AC-007's cited VP-API-QP-006(ii) reports outcomes as "M1 naming `foo`" / "M2 naming
  `=v`" (D2/D1 absent); AC-008's cited VP-API-QP-006(iii)/(iv) assert on D1 and report M1; AC-009's
  cited VP-API-QP-005(3) is built entirely out of M1/M2/D1/D2 cells -- all three ACs used these
  terms without citing the clause that defines them, so the D-386 bind-by-reference discipline
  (nothing is binding unless its defining clause is cited) left the definitions themselves
  technically uncited for those ACs. Fixed by adding VP-API-QP-005(intro) to AC-007's, AC-008's,
  and AC-009's **Test:** line citations (each with a one-line rationale naming which term each AC
  consumes), and by listing AC-007/008/009 as consumers in the Map's VP-API-QP-005(intro) row
  (previously AC-005/AC-006 only). AC-009 now cites two clauses, so its **Test:** line switches
  from the pass-8 singular-clause grammatical accommodation to the ordinary plural "clause(s)"
  form used by every other AC. **General check performed:** swept every other AC's cited clauses
  for a term defined elsewhere (an intro/definitions block) without that defining clause also
  being cited -- VP-API-QP-001/002/003/004 are each self-contained (no M1/M2/D1/D2 or other
  cross-clause terms), so no further citations were needed.
- **P9-006b + restatement sweep (LOW/COSMETIC):** Task 10(a2)'s AC-004 zero-flag-exemption bullet
  restated VP-API-QP-004(2)'s pinned argv (`jr api rest/api/3/myself`, `jr api
  "/rest/api/3/search?jql=a&"`) and, in doing so, dropped the clause's own "for each HTTP method"
  qualifier -- a restatement that had already gone stale relative to its source. Fixed by
  replacing the restated argv with a citation to VP-API-QP-004(2). A sweep of the rest of the
  Tasks section, the Clause-Level Map, and Task 10(d)'s per-cell enumeration table for the same
  defect class (inline restatement of VP/BC argv, expected values, mock setups, or oracle
  descriptions) found and fixed five more spots: Task 9's EC-9 attached-empty-variant argv list
  and its EC-7/EC-6 byte-identical-stderr argv, both replaced with clause citations; the Map rows
  for VP-API-QP-003(c) (`*`->`%2A`/space->`%20`), VP-API-QP-003(further-pinned)
  (`%`/`+`/`é`/literal-`%25`), and VP-API-QP-005(2) (`-q foo`/`-q =v`), all reworded to cite the
  clause instead of quoting the pinned characters/argv; and Task 10(d)'s own VP-API-QP-003(c) and
  VP-API-QP-003(further-pinned) rows, which quoted the same pinned characters and are now
  numbered ("pinned example 1 of 2", etc.) without restating them, plus its VP-API-QP-005(2)
  wiremock-cell rows, reworded from `-q foo`/`-q =v` to "M1 cell"/"M2 cell" (terms
  VP-API-QP-005(intro) defines, not a restatement of argv). Two exceptions were preserved, per
  instruction: (1) the BC-pinned help-text substring `"do not pre-encode"` in Task 1 (a literal
  the stub-architect needs verbatim to know what NOT to write, not a restatement of test content);
  (2) the three explicit P7-004 proptest constraints in Tasks 3/4/6 (VP-API-QP-002
  (generator-constraint), VP-API-QP-003(a) round-trip, VP-API-QP-005(1) `prop_assume!` filter),
  each of which already cited its clause and now additionally ends "(stated for emphasis; the
  clause governs)" to mark it as reinforcement, not an independent restatement. No test cell,
  count, or tally changed -- this is a labels-and-citations-only sweep, symmetric with the
  D-386 restructure's own scope note.
- **P9-011 (Task 1 cross-reference, LOW):** Task 1's stub constraint for the `--help` cell's
  pinned substring cited "(Task 10(a))" as the section proving that cell is RED at stub -- but
  Task 10(a) is the denominator-exempt (WIRING-EXEMPT) section, and the `--help` cell is not
  exempt; it is RED-at-stub, classified in Task 10(b) ("every other new test cell... fails") and
  enumerated in Task 10(d)'s per-cell table. Fixed by changing the cross-reference to "(Task
  10(b)/(d))". AC-009's own, unrelated reference to "Task 10(a)" (for its genuinely WIRING-EXEMPT
  EC-8/EC-10 cells) was left unchanged -- that one is correct as written.
- **P9-013 (Library & Framework Requirements table format, COSMETIC):** The "Library & Framework
  Requirements" section was prose, not the `| Tool | Version | Purpose |` table the story template
  (`templates/story-template.md`) requires. Fixed by converting it to that table (one row for
  `urlencoding`, one row for `url`), retaining the "no new dependency" and
  `url::form_urlencoded::byte_serialize`-forbidden notes as trailing prose.
- **Tallies re-verified unchanged (post-sweep):** `TOTAL_NEW_TESTS = 44`, `RED_TESTS = 40`,
  `GREEN-nonexempt = 2`, `EXEMPT_TESTS = 2` (Task 10(e)); direct-call cells `22`, subprocess cells
  `22` (the "Recomputed after the sweep" note above and Task 10(f)) -- **(superseded by P11-005:
  `GREEN-nonexempt = 3`, `EXEMPT_TESTS = 1`, `RED_RATIO = 40 / 43 ≈ 0.930`; see Task 10(e) for the
  current tally; the direct-call/subprocess split is unaffected)**; every Clause-Level Map
  "killed collectively by the N rows above" count re-checked against its row group: VP-API-QP-001
  8 rows, VP-API-QP-002 6 rows, VP-API-QP-003 7 rows, VP-API-QP-004 3 rows -- all unchanged, since
  this pass only edited row TEXT (line ranges, ownership, citation wording), never added, removed,
  or reclassified a row or a test cell.

## Revision Note (D-387 mechanical-coverage restructure + pass-10 fixes, MEDIUM/LOW/COSMETIC)

- **D-387 (human decision, mechanical-coverage restructure):** The D-386 restructure above (pass-7)
  replaced the pinned-value checklist with a hand-written "Clause-Level Map" (VP Clause -> Owning AC
  -> Owning Task 10(d) function(s), plus a BC Postcondition -> Owning AC table and an Edge Case ->
  Owning AC table), closing with the claim that "every VP clause, BC postcondition, and Edge Case
  above appears in exactly one map row... and is owned by at least one owning AC" (formerly ~L673 in
  this document's pre-D-387 line numbering). That map itself then repeatedly drifted from the AC
  **Test:** lines it was meant to summarize across passes 8 and 9 (see P8-003, P8-004, P8-006,
  P9-003, P9-004, and P9-006b above) -- the same self-attested-completeness problem the D-386
  restructure was originally meant to solve for the pre-D-386 pinned-value checklist. The human
  decided the map itself must be deleted, not merely re-corrected again: **SUPERSEDED BY D-387** --
  the "Clause-Level Map" section (VP Clause -> Owning AC -> Owning Task 10(d) table, BC Postcondition
  -> Owning AC table, Edge Case -> Owning AC table) and its closing "exactly one map row... owned by
  at least one owning AC" claim no longer exist in this document and must not be relied upon; every
  reference to "the Clause-Level Map" in the pass-3 through pass-9 Revision Notes above is a
  historical record of a fix made to a section that has since been deleted, not a live pointer. AC
  citations are now the SOLE source of ownership, recorded inline as CC tags (each citing a
  `cross-cutting.md` line range) on every `cross-cutting.md` citation inside every `### AC-NNN`
  section; coverage (every line of the BC-X.16.001/BC-X.16.002/VP-API-QP-001..006 region minus
  non-normative headings/blanks/metadata is inside some AC's CC-tag range) is intended to be
  verified mechanically against those tags, per the new "Coverage Scope (D-387)" section below
  (which enumerates the region as SCOPE/EXCLUDE spans) -- replacing the hand-maintained map with a
  format a script can check.
  This restructure changes LABELS and CITATION FORMAT only -- no test cell is added, removed, or
  reclassified, and the density tally (`TOTAL_NEW_TESTS = 44`, `RED_TESTS = 40`,
  `GREEN-nonexempt = 2`, `EXEMPT_TESTS = 2`, `RED_RATIO = 40 / 42 ~= 0.952`) and the direct-call/
  subprocess split (22/22) are unchanged from the pass-9 recomputation above; re-verified below.
  **(Superseded by P11-005: `GREEN-nonexempt = 3`, `EXEMPT_TESTS = 1`, `RED_RATIO = 40 / 43 ≈
  0.930` -- see Task 10(e) for the current tally; the direct-call/subprocess split is
  unaffected.)**
- **P10-002/P10-007/P10-008 (ownership gaps, MEDIUM):** The pre-D-387 map covered only VP clauses,
  BC postconditions, and Edge Cases -- it never assigned an owning AC to BC-X.16.001's Preconditions
  (~L3868-3873) or Invariants (~L3902-3915), to BC-X.16.002's Preconditions (~L4169-4176), or to the
  VP-API-QP-001..004 shared preamble (~L4002-4006) / VP-API-QP-005(intro) (~L4308-4316) /
  VP-API-QP-006 intro (~L4363-4365), leaving these clauses uncited by any AC despite being binding
  BC/VP content. Fixed by adding CC-tag citations for all of these to the owning AC bodies/Test
  lines below: BC-X.16.001 Precondition 1 (normalize_path assumption) and Invariants 1 (purity) and
  4 (guarantee scope: "strictly before the RequestBuilder" is Invariant 2, owned by AC-004; "never a
  second `?`, never `&` after empty/&-terminated" is Invariant 4, owned by AC-001) -> AC-001;
  BC-X.16.001 Precondition 2 (well-formed values deferred) and Invariant 2 (before RequestBuilder)
  -> AC-004; BC-X.16.001 Invariant 3 (encoder identity, `byte_serialize` forbidden) -> AC-003 (best
  content fit; the encoding-forbidden invariant is AC-003's domain, not AC-001's/AC-004's);
  BC-X.16.002 Preconditions -> AC-008; the shared VP preamble (~L4002-4006) -> AC-001; the
  VP-API-QP-006 intro (~L4363-4365) -> AC-007 and AC-008 (both already reference it informally; now
  tagged).
- **VP-API-QP-001 strategy-range fix (part of the D-387 restructure):** the pre-D-387 map cited
  AC-001's separator-oracle clauses as a fragmented set of discontinuous line references (e.g.
  `~L4018-4019, 4023` for EC-5, `~L4013-4014, 4023` for EC-9), one of the drift sources P8-006's
  recount caught. AC-001's citation range for the equation-plus-strategy paragraph is now ONE
  contiguous span, line 4007-4023 (equation through the start of the pinned-examples list),
  paired with a second contiguous span, line 4024-4031 (the rest of the pinned examples plus
  fault-models) -- together spanning the clause with no gap, replacing the fragmented per-EC ranges.
- **P10-003 (MEDIUM):** AC-004's Ownership (P9-003) paragraph said VP-API-QP-004(structural)'s "only
  runtime check is the request-body assertion (the `-d` input equals the received body, never moved
  into the query)" -- this narrows the clause, which ALSO asserts identical received query pairs for
  every method (not just the body-vs-query independence). Fixed by deleting that restating clause;
  AC-004 now cites VP-API-QP-004(structural) by CC-tag reference only and says "see that clause
  for its full runtime-check requirements... this AC does not restate or narrow any of them," and
  the redundant restatement in AC-004's **Test:** line intro (which repeated the same request-body
  clause fragment) is removed for the same reason.
- **P10-009 (verified, no change):** AC-002 traces EC-X.16.001-12 in its header
  (`EC-X.16.001-12/13`) alongside AC-001 (`EC-X.16.001-4/5/8/9/12/14`). Both header citations are
  deliberate, not a duplicate-ownership bug: EC-12 (NAME collision, no dedup/override) is relevant
  both to AC-001's separator algorithm (the pre-existing pair is kept verbatim) and to AC-002's
  repeated-names semantics (the new pair is neither deduped nor overridden). Line 3978-3988's
  ownership for coverage purposes stays with AC-001 (matching the pre-D-387 map's assignment);
  AC-002's header mention remains a cross-reference, not a second ownership claim -- the same
  pattern P8-004 already established for EC-X.16.001-1's AC-006 cross-reference vs. AC-005 ownership.
- **P10-014 (COSMETIC):**
  - AC-003 attributed the `--help` pin to "(D-380, settled 2026-09-25)"; fixed to cite BC-X.16.001
    Behavior 3's own pinned-substring sentence, line 3845-3852, instead.
  - AC-002's "Behavior 1 intro, ~L3797-3802" is corrected to "Behavior intro" citing line
    3797-3805 -- the flag-declaration paragraph is the shared intro before Behavior 1-5, not part
    of Behavior 1 itself, and its full extent runs through L3805, not L3802.
  - AC-009 said clap "feeds `parse_query_param` per EC-X.16.002-5..10" -- but EC-8 and EC-10 are
    clap-level exit-2 rejections that never reach `parse_query_param`. Reworded to say EC-5/6/7/9
    are fed through to `parse_query_param` while EC-8/EC-10 are rejected by clap itself first.
- **P10-016 (COSMETIC):** Every wiremock-backed and held-open-stdin-with-hermetic-mocks cell in
  `tests/api_query_param.rs` was labeled `#[test]`; per this repo's convention (verified against
  `tests/rate_limit_holdouts.rs`, `tests/attachment_download.rs`, `tests/api_client.rs`, etc.), any
  test function that calls `MockServer::start().await` (wiremock) must be an async `#[tokio::test]`,
  not a sync `#[test]` -- plain `#[test]` is reserved for cells with no async runtime need (e.g.
  AC-003's `--help` cell, which needs no wiremock, and AC-005's/AC-006's direct-call
  `parse_query_param` unit tests in `src/cli/api.rs`, which are pure function calls). Fixed by
  relabeling every wiremock/hermetic-mock cell across AC-002 (3 argv cells), AC-004 (table-driven
  method-orthogonality test + 2 zero-flag wiremock examples), AC-005 (`-q foo` wiremock cell), AC-006
  (`-q =v` wiremock cell + `--output json` envelope cell), AC-007 (4 cells), AC-008 (held-open-stdin
  cell + before-`-H` cell, both of which run inside the same hermetic wiremock environment per
  VP-API-QP-006(iii)/(iv)'s own text), and AC-009 (6 cells, per VP-API-QP-005(3)'s "every mock
  `.expect(0)`" requirement) to `#[tokio::test]`. This is a label-only fix -- no cell, count, RED/
  GREEN classification, or density tally changes; Task 10(d)/(e)/(f) and the Tasks section (which
  already say "wiremock test"/"wiremock cell" in prose without committing to a specific attribute)
  are unaffected. **CORRECTED by P10-017 below:** this "unaffected" claim was itself wrong -- Task
  9's prose and one Task 10(d) table row DID commit to the `#[test]` attribute for AC-009 and
  AC-006 wiremock cells respectively; see P10-017.
- **P10-010 (token budget, MEDIUM):** The Token Budget Estimate table's "This story spec" row said
  `~3,600`, understating this file's actual size by more than an order of magnitude -- the file is
  ~1,170 lines and measures at ~45,200 tokens via the project's own file-read tooling. Fixed by
  recomputing the table honestly: `~45,200` for the story spec, `~50,700` total, `~25%` of a 200K
  context window -- still within this agent's own 20-30% ceiling for a single story, but no longer a
  roughly 5x understatement of it. See the Token Budget Estimate section below.
- **Tallies re-verified unchanged (post-D-387):** `TOTAL_NEW_TESTS = 44`, `RED_TESTS = 40`,
  `GREEN-nonexempt = 2`, `EXEMPT_TESTS = 2` (Task 10(e)); direct-call cells `22`, subprocess cells
  `22` (Task 10(f)). **(Superseded by P11-005: `GREEN-nonexempt = 3`, `EXEMPT_TESTS = 1`,
  `RED_RATIO = 40 / 43 ≈ 0.930` -- see Task 10(e) for the current tally; the direct-call/
  subprocess split is unaffected.)** None of the D-387/pass-10 fixes above (map deletion, CC-tag citation
  format, ownership-gap fixes, `#[tokio::test]` relabeling, token-budget recompute) add, remove, or
  reclassify a test cell; Task 10(d)/(e)/(f) are unchanged from the pass-9 recomputation.
- **P10-017 (independent coverage-check follow-through, MEDIUM/LOW/COSMETIC):** an independent
  coverage check of this D-387 restructure found four residual defects, all fixed below, in the
  same label-only/citation-only spirit as the rest of this pass -- no test cell, count, RED/GREEN
  classification, or density tally changes anywhere in this bullet:
  1. **Misplaced CC tags (LOW):** the CC-tag bracket-colon citation syntax is reserved for real,
     mechanically-checkable citations inside `### AC-NNN` sections (and, symmetrically, the SCOPE/
     EXCLUDE bracket-colon syntax is reserved for the real per-clause line-range entries in the
     Coverage Scope section below); several bullets in this Revision Note and the Coverage Scope
     section's own intro paragraph used that same bracket-colon syntax as descriptive/placeholder
     prose instead, which a mechanical scanner could misread as additional (bogus) citations or
     SCOPE/EXCLUDE entries. Reworded every such placeholder occurrence in this Revision Note and in
     the Coverage Scope intro/closing prose to plain "CC tags" / "line NNN-MMM" / "SCOPE"/"EXCLUDE"
     wording with no brackets; the real, mechanically-checked CC-tag citations inside the
     `### AC-NNN` sections below and the real SCOPE/EXCLUDE line-range entries in the Coverage
     Scope per-clause lists are untouched.
  2. **Two suspect EXCLUDE entries were actually normative SCOPE content (MEDIUM):** the EXCLUDE
     entries for line 3865-3866 (the BC-X.1.007/BC-X.1.011 no-regression cross-reference) and line
     4142-4145 (the BC-X.16.002 M1/M2 Condition/Behavior table) both stated binding requirements,
     not non-normative provenance/heading/blank-line filler -- the EXCLUDE reason given for each
     ("describes pre-existing behavior, not a new clause" / "non-normative restatement, not new
     content") does not meet the EXCLUDE bar. Both are reclassified to SCOPE in the Coverage Scope
     section below and each now carries an owning AC citation: line 3865-3866 is cited by AC-004
     (the AC whose table-driven method-orthogonality test is this story's existing verification
     vehicle for that no-regression guarantee), and line 4142-4145 is cited by both AC-005 and
     AC-006 (the two ACs that already own BC-X.16.002's M1 and M2 rows respectively).
  3. **"35 exclusions" recount (LOW):** a naive whole-file search for the EXCLUDE-tag pattern
     returned 35, but 2 of those 35 hits were the placeholder-prose occurrences fixed in fix 1
     above, not real per-clause EXCLUDE entries -- the Coverage Scope section's real per-clause
     EXCLUDE-entry count was already 33, not 35, before this pass. Fix 2 above then reclassifies 2
     of those 33 real entries to SCOPE, so 31 is the correct, re-verified count of real EXCLUDE
     entries in the Coverage Scope section after this pass.
  4. **P10-016 label follow-through was incomplete (MEDIUM):** P10-016 above relabeled every
     wiremock/hermetic-mock cell's **AC Test:** line to `#[tokio::test]` and claimed "Task 10(d)/(e)/(f)
     and the Tasks section ... are unaffected" -- that claim was wrong for two spots that DO commit
     to a specific attribute rather than generic "wiremock test"/"wiremock cell" prose: Task 9's
     counting-unit pin said EC-X.16.002-10 "is its OWN `#[test]` function" and said the EC-X.16.002-7
     cell "does not change its status as ONE `#[test]`" -- both are AC-009 cells, part of P10-016's
     already-relabeled 6-cell set, so both are corrected to `#[tokio::test]`. The Task 10(d)
     per-cell table's `VP-API-QP-005(2)` `--output json` envelope row (Task 6 / AC-006) likewise
     said "ONE `#[test]`" where AC-006's own **Test:** line (P10-016) says `#[tokio::test]`; that
     table cell is corrected to `#[tokio::test]` too. All three are label-only corrections; the RED
     tag on each row and the Task 10(e) tally are unchanged.
- **P10-018 (LOW, review pass):** Two more label/citation-only fixes found in a follow-up review
  of this restructure. First, the declared region below (lines 3783-4394) left the new subsection
  intro paragraph directly above it (lines 3772-3779, added in the same cycle-014 edit) unaccounted
  for; a sentence was added noting that this paragraph is deliberately left out of the declared
  region because it is shared context for both BCs, not a testable clause of either, and the
  dependency fact it states is restated where it matters -- in BC-X.16.001's Source field, and,
  bindingly, in Invariant 3, which AC-003 already cites. Second, AC-006 described its citation to
  the BC-X.16.002 Behavior paragraph as "the M2 (empty-NAME) row," but that wording actually
  describes the Condition/Behavior table, which AC-006 already cites separately right after it; the
  Behavior-paragraph citation is reworded to describe the paragraph itself (its M2 empty-NAME
  case), removing the duplicated "row" wording. Neither fix changes any test cell, count, or line
  range this story cites -- both are wording corrections only. A follow-up sweep re-confirmed that
  every cycle-014-added line in the BC-X.16.001/BC-X.16.002/VP-API-QP-001..006 region is still
  either listed or excluded below, and that every listed line remains cited by at least one AC,
  unchanged by these two fixes.
- **P10-019 (COSMETIC, review pass):** the P10-018 unlisted-paragraph note named only the
  L3772-3779 intro paragraph, leaving the structural lines around it (the `## BC-X.16: API Query
  Parameters` subsection heading and the `---` separators/blank lines bracketing it) unaccounted
  for, even though none of them fall inside the declared L3783-4394 region either. Fixed by
  naming them explicitly, alongside the existing L3772-3779 note, as intentionally unlisted
  structural lines: L3770 (the subsection heading), L3781 and L4396 (the bracketing `---`
  separators), and the blank lines around them (L3771, L3780, L3782, L4395, L4397) -- heading/
  separator/blank-line structure, no testable clause content, no test cell, count, or line-range
  change.

## Revision Note (F3 adversarial pass-11 fixes, MEDIUM/LOW/COSMETIC)

- **P11-002 (MEDIUM):** AC-004's citation to the BC-X.1.007/BC-X.1.011 no-regression guarantee
  (line 3865-3866) named the table-driven method-orthogonality wiremock test as its verification
  vehicle -- wrong, since that test drives only canonical-case HTTP methods and never asserts on
  stdout, so it cannot verify either guarantee. Fixed by rewriting AC-004's citation to point to
  the actual verification vehicle: the unmodified, pre-existing `tests/cli_handler.rs` tests
  `test_handler_api_stdout_byte_exact` (raw-passthrough, BC-X.1.007) and
  `test_parse_api_method_uppercase_delete_dispatches_http_delete`,
  `test_parse_api_method_lowercase_delete_dispatches_http_delete`, and
  `test_parse_api_method_mixedcase_delete_dispatches_http_delete` (case-insensitivity,
  BC-X.1.011), found by grepping the file for their exact function names. These are already
  required to stay green both before and after this story by Task 10(c) and Task 14, and by
  holdout anchor `H-CYCLE14-W2-REG-001` -- this fix adds no new test cell.
- **P11-003 (LOW):** AC-007 cited the whole BC-X.16.002 Invariants block in full, but its test
  cells verify only Invariant 3 (the flag-order short-circuit); Invariant 1 (distinct M1/M2
  messages) is actually verified by AC-005's and AC-006's tests, and Invariant 2 (empty VALUE
  never an error) by AC-005's tests. Fixed: split the merged Invariants entry in the Coverage
  Scope section into its own heading line plus one entry per invariant, added Invariant 1's and
  Invariant 2's citations to AC-005 (and Invariant 1's to AC-006), and narrowed AC-007's citation
  and header to Invariant 3 only. The Invariants block's own label line ("**Invariants**:") is now
  an excluded heading line, matching the sibling treatment already used for BC-X.16.001's own
  Invariants heading.
- **P11-004 (LOW):** AC-008 cited the BC-X.16.002 Preconditions block in full, but the clause
  stating that `normalize_path`'s own errors (empty path, absolute URL) run before `-q` validation
  has no dedicated test. Fixed by labeling that part of the citation informational -- ordering is
  enforced by Task 13's placement of the `-q` pre-flight step immediately after `normalize_path`,
  and by PR code review -- and adding the same enforcement note to Task 13. No test was added.
- **P11-005 (LOW):** Task 10(a) classified EC-X.16.002-8 (`jr api /x -q -x=1` -> clap exit 2
  "unexpected argument") as WIRING-EXEMPT, but verification shows it already exits 2 with that
  same generic clap rejection before this story exists at all (no `-q` field declared), so it is
  not GREEN because of the Task 1 stub's wiring. Reclassified to GREEN-nonexempt
  (`rationale_category: PRE-EXISTING-BEHAVIOR`), consistent with this story's own treatment of the
  AC-004 zero-flag cells (see the P5-001 note). EC-X.16.002-10 was separately verified and remains
  WIRING-EXEMPT: pre-story, `-q` as the last argv token gives the same generic "unexpected
  argument" rejection and does NOT contain the pinned "a value is required for" substring, so it
  genuinely depends on the Task 1 stub's correct `-q` wiring to pass. Every tally occurrence in
  this document that stated the pre-P11-005 numbers (`TOTAL_NEW_TESTS = 44`, `RED_TESTS = 40`,
  `GREEN-nonexempt = 2`, `EXEMPT_TESTS = 2`, `RED_RATIO = 40 / 42 ~= 0.952`) has been recomputed:
  `TOTAL_NEW_TESTS = 44` (unchanged), `RED_TESTS = 40` (unchanged), `GREEN-nonexempt = 3`,
  `EXEMPT_TESTS = 1`, denominator `= 44 - 1 = 43`, `RED_RATIO = 40 / 43 ≈ 0.930 >= 0.5` -- still
  comfortably clears the BC-8.29.001 gate. Task 10(a)/(a2)/(d)/(e), AC-009's own RED/GREEN
  classification sentence, and every other restatement of the prior tally elsewhere in this
  document (each now marked superseded in place, pointing to Task 10(e) as the current
  authoritative tally) have been updated to match.
- **P11-006 (LOW):** the Token Budget Estimate's "This story spec" row understated the file's
  actual size again -- the file is now about 1,446 lines, and the project's Read tooling reports
  about 55,000 tokens for it, not the pass-10 figure of about 45,200 (itself measured against a
  smaller, pre-pass-10/pass-11 snapshot of the file). Fixed by recomputing the table honestly
  using the Read-tool token count as the measurement method: about 55,000 for the story spec,
  about 60,500 total, about 30% of a 200K context window. Since this sits at, and marginally over,
  this agent's own 20-30% budget ceiling, a note was added explaining that the overage is
  attributable to this spec-phase artifact's accumulated Revision Note history, not to the
  underlying two-function, one-BC-family implementation scope, and that no split is triggered
  per the story template's own "if over budget, split the story" rule, since there is no natural
  seam to split the implementation along.
- **P11-007b (COSMETIC):** AC-003's `--help` cell citation said "see P10-016 below," but the
  P10-016 fix appears earlier in this document (in the pass-10 Revision Note, above AC-003).
  Fixed by changing "below" to "above."

## Revision Note (F3 adversarial pass-12 fixes, LOW/COSMETIC)

- **Stray citation (coverage re-run, COSMETIC):** AC-007's prose said its narrowed Invariant 3
  citation was "narrowed from the prior merged" citation and then quoted the old, now-superseded
  line range in the same bracketed tag syntax the story's real citations use -- the coverage
  script reads that quoted range as a live citation, not as history. Fixed by rewording it to
  name the old line range in plain prose (no brackets), matching how every other historical
  citation in this document's Revision Notes is quoted. A sweep of every other AC section for the
  same pattern (an old citation quoted in bracketed tag syntax inside prose, rather than named in
  plain words) found no other occurrence.
- **P12-003 (LOW):** AC-008 said it implements BC-X.16.002 Preconditions "in full," but only the
  citation's final sentence (the `normalize_path`-ordering sentence, fixed at P11-004) was labeled
  informational. The citation's middle sentence -- that `-q` validation runs only after
  `Config::load_with` and `JiraClient::from_config` succeed, and that those two calls plus
  `config::validate_profile_name` preempt this BC's exit-64 -- has no owning AC-008 cell, because
  every AC-008 cell supplies valid auth. Verified against `src/main.rs`: `Command::Api`'s dispatch
  arm calls `Config::load_with` and `JiraClient::from_config` (lines ~499-501) before
  `cli::api::handle_api` is invoked. Fixed by labeling that sentence informational, inherited, and
  enforced structurally -- `main.rs`'s `Command::Api` arm runs both calls before `handle_api`; PR
  code review -- with no dedicated test cell, none added.
- **P12-004 (LOW, partial-fix propagation of P11-005):** Three earlier Revision Note restatements
  of the pre-P11-005 tally/classification numbers lacked a superseded marker, even though P11-005
  (pass-11) reclassified EC-X.16.002-8 from WIRING-EXEMPT to GREEN-nonexempt and changed the
  numbers they restate: the pass-4 P4-002 bullet's "is UNCHANGED and remains correct" sentence
  about the EC-X.16.002-8/-10 WIRING-EXEMPT pairing; the pass-5 P5-001 bullet's "now
  WIRING-EXEMPT_count only -- EC-X.16.002-8/-10, unchanged" recomputation
  (`EXEMPT_TESTS = 2`); and the pass-5 P5-002 bullet's "`EXEMPT_TESTS = 2` (WIRING-EXEMPT only)"
  recomputation. Fixed by adding an inline superseded-by-P11-005 marker to each of the three,
  pointing at Task 10(e) as the current authoritative tally. A whole-file sweep for
  "EXEMPT_TESTS = 2", "EXEMPT_TESTS=2", "8/-10", "WIRING-EXEMPT: EC-X.16.002-8", "40/42", "0.952",
  and "41/37" (and near-variants) found every other occurrence already current or already carrying
  a superseded marker from the pass-11 Revision Note or Task 10(e) itself -- no further fix needed.
- **P12-005 (COSMETIC):** Task 10(c)'s list of "the ONLY regression guards required GREEN both
  before and after this story" named the AC-004 zero-flag wiremock examples from (a2) but omitted
  EC-X.16.002-8, which P11-005 also reclassified into (a2) as GREEN-nonexempt -- it too was
  already GREEN before this story exists (per P11-005's own verification) and so is equally a
  regression guard, not merely a RED-at-stub cell. Fixed by adding EC-X.16.002-8 to the (c) list.
- **P12-006 (COSMETIC):**
  - Architecture Compliance Rules row 1 said "AC-001..003, AC-005..007 tests need no wiremock for
    their proptest layers," but AC-007 has no proptest layer (all 4 of its cells are
    `#[tokio::test]` wiremock cells in `tests/api_query_param.rs`). Verified against every AC's
    Test paragraph and Task 10(d): only AC-001, AC-002, AC-003, AC-004, and AC-005 have a
    `proptest!` layer; AC-006 through AC-009 do not. Fixed to "AC-001..AC-005," with a note
    explaining AC-006..AC-009 have no proptest layer.
  - The File Structure row for `src/cli/api.rs` traced "(AC-001..003, AC-005..007)," omitting
    AC-004 (whose zero-flag identity `proptest!` also lives in this file's test module) and AC-008
    (whose `handle_api` pre-flight-wiring implementation also lives in this file, even though
    AC-008's own test cells live in `tests/api_query_param.rs`). Fixed to "AC-001..AC-008" with an
    explanatory note.
- **Systemic sweep (per pass-12 review instruction, LOW):** walked every CC-tag citation in every
  AC section and confirmed each is either (a) verified by at least one test cell owned by that AC,
  or (b) labeled informational/inherited with a named concrete enforcement (a reused unchanged
  function, a structural code placement, a test owned by a named other AC, or code review). Two
  further citations met neither, beyond P12-003's AC-008 fix above:
  - AC-001's dependency on Precondition 1 (`<path>` already `normalize_path`-normalized) has no
    owning AC-001 cell -- it is a caller obligation on the input, not something
    `append_query_params` itself produces or that any of AC-001's 8 tests exercise. Labeled
    informational, enforced structurally by `handle_api`'s existing, unmodified
    `normalize_path(&path)?` call site preceding all `-q` handling, and by PR code review; no
    dedicated test cell added.
  - AC-004's dependency on Precondition 2 (well-formed values assumed; malformed values deferred
    to BC-X.16.002, evaluated before assembly) has no owning AC-004 cell -- AC-004's own tests
    simply construct well-formed pairs, and the ordering half of this precondition is what
    AC-008's tests (BC-X.16.002 Postcondition 1) actually verify. Labeled informational, naming
    AC-008's tests as the ordering enforcement and test-fixture construction as the
    well-formedness half; no dedicated AC-004 test cell added.
  Every other citation checked (all "owns Edge Case"/"owns Invariant" claims across AC-001..009,
  and every "in full" Behavior/Postcondition claim) already resolves to a real, owned Task 10(d)
  test cell, or -- for BC-X.16.002 Invariant 1 (message distinctness), jointly owned by AC-005 and
  AC-006 -- to the combination of both ACs' own pinned-message tests, which together demonstrate
  the two messages are distinct. No further citations required a fix.

## 2026-09-28 -- F3 adversarial pass-16 fixes (P16-001, P16-003, P16-008)

Findings fixed directly in the story body (version bumped 4.2 -> 4.3; input-hash left untouched):

- P16-001 (medium): same subsystem-anchoring gap as the sibling user-list-project-resolution
  story -- this story also makes a real, functional edit to the entry-point/runtime file's
  dispatch arm (wiring the new query-param flag through to its handler). Added that subsystem to
  the subsystems list, added the entry-point file to the target-module list to match its
  story-index row and its sibling story, and rewrote the frontmatter comment so it no longer
  claims every modified file lives under the CLI layer's own directory.
- P16-003 (low): two acceptance criteria cited an ordering guarantee (query assembly running
  after path normalization and before the request is built) without saying which half of that
  ordering each is actually verified by -- a runtime test versus call-site placement plus code
  review. Split both citations to say so explicitly, naming the table-driven test's actual
  assertions for the "before the request is built" half and the placement/review mechanism for
  the structural half.
- P16-008 (cosmetic): one clause citation's line range included the section's heading line by
  mistake; narrowed it to the actual clause text below the heading.

## 2026-09-28 -- F3 adversarial pass-17 fix (P17-001) plus a full sentence-level sweep

Finding fixed directly in the story body (version bumped 4.3 -> 4.4; input-hash left untouched):

- P17-001 (low): AC-004's claim that AC-008's tests verify the "malformed values are caught
  before assembly runs" half of a precondition turned out not to hold up -- AC-008's own cells
  only observe ordering relative to reading the request body and parsing headers, not relative to
  the query-assembly function itself, so they can't actually see that ordering. Same gap existed
  on AC-008's side of the same claim. Reworded both to say plainly that this half is a
  design/structural fact instead of something a test observes, and named the real reason it holds:
  the assembly function only accepts already-parsed pairs, so the parsing step has to finish
  first by construction, backed up by code review and by the fact that the all-or-nothing tests
  prove no request goes out when a value is bad. Also added a named reason for a header-related
  claim in AC-004 that had none before -- the assembly function's own signature has no place to
  put a header, and a holdout scenario already checks the header comes through untouched.

  After that fix, did a full pass reading every cited spec line range behind every acceptance
  criterion in this story, sentence by sentence, to check each one is either tied to a test that
  can actually see it or explicitly marked as a design fact instead. Found several more sentences
  that were rationale, external-tool comparisons, or documentation asides with no test tied to
  them -- a purity claim with nothing pointing at how it's shown true, a note comparing this
  behavior to another command's flag that isn't re-tested here, a couple of sentences about which
  file writes an error message rather than what a caller can observe, and a description of some
  command-line variants that aren't exercised by any test. Added a short, plain-language note next
  to each one explaining why it doesn't need its own test -- most come down to the code's own
  shape, or to a test elsewhere in the story that already covers the same ground. Nothing was
  removed: every line range that was already tied to an acceptance criterion still is.

## 2026-09-28 -- F3 adversarial pass-18 fix (P18-006)

Finding fixed directly in the story body (version bumped 4.4 -> 4.5; input-hash left untouched):

- P18-006 (cosmetic): the Token Budget section's story-spec row estimated ~35,000 tokens, which
  understated the actual count of roughly 38,000. Rounded the estimate to the nearest 5,000
  (~40,000), marked it approximate and noted it drifts with edits, and recomputed the total and
  budget-usage percentage against the new figure (~45,500 total, ~23% of the agent's context
  window). No exact-count or truncation claim was present beyond the stale ~35,000 figure itself.


## 2026-09-28 -- F3 adversarial pass-19 fixes (P19-002, P19-005, P19-006)

Findings fixed directly in the story body (version bumped 4.5 -> 4.6; input-hash left untouched):

- P19-002 (low): two CC tag citations each had one sentence inside their cited range that carried
  no label. AC-001's shared-preamble CC tag left its middle sentence unlabelled -- the one naming
  where the query-string repeated-flags argv cells and the `--help`-text cell actually live.
  Labeled it as an informational cross-reference, pointing at AC-002's argv cells and AC-003's
  `--help` cell. AC-003's non-ASCII edge-case CC tag left its closing sentence unlabelled -- the
  one saying the test-oracle decoder plays no role in production encoding. Labeled it the same way
  AC-001's own preamble sentence already is: informational, enforced by test-module placement plus
  PR code review. Re-read every sentence in both cited ranges afterward; each now carries exactly
  one cell or one label.
- P19-005 (low): added the five files this story actually edits or pins -- the mutants config, the
  mutants policy doc, the changelog, `Cargo.toml`, and the citation-check script -- to the
  frontmatter inputs list. All five were already cited in the story body (AC-011, Task 17, the
  Library table, and the File Structure table); this only closes the gap between what the story
  touches and what its inputs list declares.
- P19-006 (cosmetic): "three attached-empty variants" was vague about which edge case it referred
  to. Reworded it, in both the AC-009 body sentence and the Task 10(d) tally-table row, to name the
  edge case explicitly and point back at its own clause for the details.

Drift note: adding the five files above to `inputs:` changes what the stored `input-hash` should
hash to. Per this pass's explicit instruction not to touch `input-hash`, it was left as-is -- the
resulting drift is expected, the same as the sibling story's own pass-17 note on this point, and is
for state-manager/orchestrator to reconcile, not something this pass tried to paper over.

## 2026-09-28 -- F3 adversarial pass-20 fixes (P20-001, P20-002)

Findings fixed directly in the story body (version bumped 4.6 -> 4.7; input-hash left untouched):

- P20-001 (low): AC-003's citation of Behavior 3's pinned `--help` substring requirement labeled
  the encoder rationale/comparison sentences informational, but said nothing about the separate
  requirement, also inside Behavior 3, that the help text state that values are passed raw --
  VP-API-QP-003(e) only pins the `do not pre-encode` substring, not the "passed raw" half.
  Verified the underlying text (cross-cutting.md's Behavior 3, ~L3845-3850) before quoting it: it
  requires the clap help text to state plainly that values are passed raw and must not be
  pre-encoded, and separately pins only the `do not pre-encode` substring as what the automated
  test asserts. Added a sentence to AC-003's citation labeling the "passed raw" half informational
  too, enforced at PR review, and pointing at `verification-delta.md` §2's own wording (verified
  at its ~L106: `Help text for --query-param: "pass raw values; do not pre-encode"`) as the
  concrete target. Added the same requirement to Task 12, which previously just said "with the
  pinned help text" with no distinction between the test's substring pin and the spec's fuller
  requirement -- it now names both explicitly, citing the same BC-X.16.001 Behavior 3 range. Then
  checked every other task in both stories that finalizes user-facing text or a pinned value:
  this story's Task 12 was the only offender; STORY-A's Task 8 (help text) already points at
  BC-X.7.002 Fix step 1's pinned exact string by source location, and its Task 10 (exit-64
  message) implements AC-004, whose own body already states the full pinned message verbatim, not
  a VP-cell paraphrase -- neither needed a change.
- P20-002 (low): AC-009's citation of EC-X.16.002-8 left two of that edge case's sentences
  unlabelled -- the one comparing to the existing `-H`/`--header` flag's own missing
  `allow_hyphen_values` (cross-cutting.md ~L4259-4262), and the closing one explaining there is no
  quoting workaround because the shell strips quotes before clap ever sees the argument
  (~L4270-4272). Verified `src/cli/mod.rs`: the `header` field (`Command::Api`, lines 147-148) is
  declared `#[arg(short = 'H', long = "header")]` / `header: Vec<String>` with no
  `allow_hyphen_values`, confirming the spec's precedent claim. Re-read the entire EC-X.16.002-8
  cited range (L4252-4275) once more afterward. Extended AC-009's existing informational
  parenthetical to also cover both sentences -- labeling them informational, pre-existing `-H`
  declaration plus shell semantics, confirmed at PR code review -- rather than adding a second,
  separate parenthetical. Each sentence in the cited range now carries exactly one label.

## 2026-09-28 -- F3 adversarial pass-21 fixes (P21-003, coverage-check finding)

Findings fixed directly in the story body (version bumped 4.7 -> 4.8; input-hash left untouched):

- Coverage-check finding: Task 12 (~story line 948) contained a real CC tag citation with a
  concrete spec line range, sitting inside the Tasks section rather than inside any AC's header
  or Test body. The mechanical coverage script only recognizes CC tag citations inside
  `### AC-NNN` sections, so this misplaced citation was invisible to it -- a coverage gap by
  omission, not a wrong line range. Rewrote it as plain text, replacing the bracketed citation
  with the wording "spec L3826-3852" (matching this story's own established convention of citing
  spec line ranges as plain prose outside AC sections, as already used throughout the Coverage
  Scope (D-387) section and the Revision History). Then grepped all three cycle-014 stories
  (this one, the sibling `S-cycle14-user-list-project-resolution.md`, and
  `S-cycle14-field-options-name-label.md`) for any CC tag with a real, concrete spec line range
  outside a `### AC-NNN` section; the Task 12 citation above was the only offender found across
  all three files. The other generic CC tag mentions outside AC sections in all
  three stories are generic descriptions of the citation mechanism itself (no concrete line
  numbers), not real misplaced citations, so none needed changing.
- P21-003 (low): the File Structure Requirements row for `src/cli/mod.rs` listed AC-001 in its
  trace list, but AC-001 is entirely about `src/cli/api.rs::append_query_params` -- its own Test
  line places every one of its cells in `src/cli/api.rs`'s `#[cfg(test)] mod tests`, none in
  `src/cli/mod.rs` or `tests/api_query_param.rs`. Removed AC-001 from that row's trace list,
  leaving AC-002 (the clap field's `Vec<String>`/no-`value_delimiter` declaration), AC-003 (the
  pinned `--help` substring, finalized on this same clap field per Task 12), and AC-009 (the
  no-`allow_hyphen_values` requirement, per the Architecture Compliance Rules table's matching
  row) -- all three do trace to `src/cli/mod.rs`. Then re-verified every other row in the File
  Structure Requirements table against what its cited ACs' Test lines and bodies actually say:
  the `src/cli/api.rs` row's AC-001..AC-008 list, the `tests/api_query_param.rs` row's
  AC-002..AC-009 list, the `README.md` row's AC-010, and the `.cargo/mutants.toml`/
  `docs/specs/cargo-mutants-policy.md` rows' AC-011 all check out against the ACs' own Test lines
  and bodies -- no further changes were needed.

Inputs sweep: grepped this story's body for every `src/`-prefixed file citation. All of them
(`src/cli/api.rs`, `src/cli/mod.rs`, `src/main.rs`) already appear in the frontmatter `inputs:`
list. The body's other two `src/`-prefixed mentions (`src/cli/user.rs`, `src/jql.rs`) are both
purely positional -- they name where the sibling story's already-landed
`docs/specs/cargo-mutants-policy.md` bullet sits, or where this story's own new bullet must be
inserted relative to a pre-existing bullet group -- neither is a file this story actually reads
for its own AC/Architecture content, so neither was added.

## 2026-09-28 -- F3 adversarial pass-22 fixes (P22-001, P22-002)

Findings fixed directly in the story body (version bumped 4.8 -> 4.9; input-hash left untouched):

- P22-002 (low, a real test gap): EC-X.16.001-1 (the `k=` empty-VALUE-allowed edge case, spec
  region cited via a CC tag on lines 3918-3920) says an empty VALUE is sent as-is. No cell owned
  by this story previously checked that claim's wire result directly -- AC-005 cited the same
  edge case, but only for `parse_query_param`'s parse half (that an empty VALUE is `Ok`, not an
  error); nothing exercised `append_query_params`'s assembly of it. Added one new direct-call
  pinned example to AC-001 -- `append_query_params("/x", &[("k".into(), "".into())]) == "/x?k="`
  -- verified against Behavior 1's separator algorithm (path `/x` has no `?`, so a fresh leading
  `?` is introduced) and Postcondition 3/Behavior 3's exactly-once-encoding rule (NAME and VALUE
  are each encoded once and joined by a literal `=`, even when VALUE encodes to the empty
  string -- the `=` is never dropped for an empty VALUE). Added the same CC tag citation to
  AC-001 for the wire half, alongside AC-005's existing citation for the parse half, and labeled
  each half explicitly in both ACs so a reader can tell which function each AC's cells actually
  exercise. Updated every tally occurrence this addition touches: Task 10(d)'s full per-cell
  enumeration table (new row), Task 10(e)'s recomputed tally (`TOTAL_NEW_TESTS` 44 -> 45,
  `RED_TESTS` 40 -> 41, GREEN-nonexempt unchanged at 3, EXEMPT unchanged at 1, denominator 43 ->
  44, `RED_RATIO` 40/43 -> 41/44), Task 10(f)'s direct-call/subprocess split (22/22 -> 23/22),
  the AC-001 per-AC row in the (e) tally table (8 -> 9 new tests), and the Revision History
  summary's Current Red Gate tally paragraph. Grepped the story body for every other occurrence of
  the stale counts ("40 / 43", "44", "22 direct") and confirmed each remaining occurrence found
  was either already updated or belonged to an unrelated count (the `.cargo/mutants.toml`
  `examine_globs` 33 -> 34 bump in AC-011, which uses different numbers entirely and was not
  touched).
- P22-001 (low): VP-API-QP-005's fault-models CC tag (spec lines 4357-4362) was cited only by
  AC-009, as if AC-009's own attached-form cells (EC-X.16.002-5..10) killed all eight faults that
  clause lists. Verified against the actual cell design that three of those faults are instead
  killed by other ACs' tests: the JSON-envelope-on-stdout-instead-of-stderr fault is killed by
  AC-006's `--output json` envelope cell, not by anything AC-009 owns; the split-on-the-last-`=`
  fault and the NAME-trimmed-before-the-empty-check fault are both killed by AC-005's partition
  `proptest!` (its EC-X.16.001-2 and EC-X.16.001-10 cells respectively), not by AC-009's
  attached-form cells. Added the same CC tag to AC-005 and AC-006, each scoped with an explicit
  "the fault models this AC's tests kill: ..." label naming exactly which faults its own cells
  kill (AC-005: swapped M1/M2, one shared generic message, `{raw}` replaced by a trimmed/re-split
  value, split-on-the-last-`=`, NAME-trimmed-before-empty-check, and an empty-NAME-check-before-
  missing-`=`-check fault; AC-006: the stdout/stderr envelope fault only), and narrowed AC-009's
  own citation to state it owns only the `allow_hyphen_values` fault (via its EC-X.16.002-8 cell)
  and, jointly with AC-005, the `{raw}`-replaced-by-a-trimmed-or-re-split-value fault (via its
  real-argv attached-value cells) -- explicitly disclaiming ownership of the other five faults,
  which are AC-005's/AC-006's.

Reworded this file's own generic bracketed-format-mention (originally
~L987, now shifted by the P21-003 entry's growth) to plain "CC tag" wording with no bracket
syntax, per the same convention this dated entry itself uses throughout.

## 2026-09-28 -- F3 adversarial pass-23 fixes (P23-002, P23-005) plus fault-model citation sweep

Findings fixed directly in the story body (version bumped 4.9 -> 5.0; input-hash left untouched):

- P23-002 (low): AC-007 and AC-008 each cited VP-API-QP-006's fault-models CC tag (spec lines
  4387-4389, listing three faults: the ordering fault -- `-q` parsing moved after `resolve_body`
  or after `parse_header` -- per-flag filtering that drops bad values instead of failing, and
  reporting the last malformed value instead of the first) without scoping which of the three
  faults each AC's own tests actually kill. Verified against each AC's owned cells before writing
  anything: AC-007 owns the all-or-nothing cells (assert zero requests sent when any `-q` value is
  malformed) and the first-malformed-reported cells (assert the FIRST malformed value in flag
  order is reported); AC-008 owns the (iii) held-open-stdin cell (`-d @- -q bad`, asserts the
  child exits 64 before ever touching stdin) and the (iv) before-`-H` cell (`-q bad -H
  "malformed-no-colon"`, asserts the `-q` error is reported, not `parse_header`'s). Added a scoped
  parenthetical to each AC's fault-models citation: AC-007 now states its tests kill per-flag
  filtering (via the all-or-nothing cells' zero-request assertion) and last-vs-first reporting
  (via the first-malformed-reported cells' flag-order assertion), cross-referencing the remaining
  ordering fault to AC-008. AC-008 now states its tests kill the ordering fault (jointly, via
  (iii) and (iv)) and ALSO per-flag filtering -- reasoned out explicitly: EC-4's single malformed
  `-q bad` value, if silently filtered instead of failing, would let control flow reach
  `resolve_body`'s blocking stdin read instead of exiting promptly, so the (iii) cell
  independently kills that fault too -- cross-referencing the remaining last-vs-first-reporting
  fault to AC-007.

Pattern sweep (a), fault-model citations, applied across this whole story: beyond VP-API-QP-005
(already scoped by the pass-22 P22-001 fix) and VP-API-QP-006 (fixed above), four more
fault-model CC tags were bare, unscoped range citations with no "(the fault models this AC's own
tests kill: ...)" framing -- AC-001's citation of VP-API-QP-001's fault-models (spec lines
4024-4031, part of the pinned-examples-tail CC tag), AC-002's citation of VP-API-QP-002's
fault-models (lines 4063-4069), AC-003's citation of VP-API-QP-003's fault-models (lines
4089-4091), and AC-004's citation of VP-API-QP-004's fault-models (lines 4106-4108). Each of these
four VPs is owned by a single AC (no cross-AC split needed, unlike VP-API-QP-005/006), so each fix
was a same-AC scoping addition naming which of that AC's own cells kills which named fault, verified
against the actual fault list read directly from cross-cutting.md before writing: AC-001 (5 faults:
`?`/`&` swapped, `ends_with` boundary faults, `find('?')` over the whole path, the
`&`-terminated-test-on-whole-`pre` fault, and the fragment dropped/misplaced -- killed by the
separator-oracle `proptest!` plus the `/s?#f` and `/x&`+`k=v` pinned examples specifically for the
two named-boundary faults); AC-002 (5 faults: dedup/last-wins/first-wins collapsing, a same-NAME
override, reordering -- all killed by the repeated-names proptest oracle; `value_delimiter=','` --
killed by the EC-X.16.001-13 argv cell; `handle_api` forwarding only first/last or deduplicating
before the call -- killed by the repeated-flags argv cell, per the clause's own attribution);
AC-003 (6 faults: no encoding/double encoding -- killed by the (a) round-trip assertion;
`byte_serialize` substituted -- killed by the (c) encoder-identity assertion and its pinned
examples; the `=` joiner encoded -- killed by the same (c) assertion; NAME/VALUE trimmed -- killed
by the (d) no-trim pinned examples; the help phrase dropped/reworded -- killed by the (e) `--help`
cell); AC-004 (4 faults: a `?`/`&` appended on zero pairs and the path re-encoded/fragment dropped
on zero pairs -- killed jointly by the zero-flag identity `proptest!` and the zero-flag wiremock
examples; query assembly gated on the method and `-d` content merged into the query -- killed by
the table-driven method-orthogonality wiremock test). Total: 6 fault-model CC tags exist in this
story (VP-API-QP-001 through -006); all 6 are now scoped (2 were already scoped from the pass-22
P22-001 fix; 4 needed the same-AC scoping fix above; the VP-API-QP-006 pair needed the cross-AC
scoping fix in P23-002 above).

Pattern sweep (b), multi-sided clauses, applied across this whole story: checked every CC citation
against its cited cross-cutting.md text for "regardless of"/"and"/"both"/"before ... and
after"/"either ... or"/lists of conditions. Specifically re-verified: BC-X.16.001 Postcondition 2's
`?`-presence-evaluated-before-`&`-termination ordering (AC-001's "in full" citation is accurate --
the separator-oracle `proptest!` asserts the whole case-split, ordering included); BC-X.16.001
Invariant 4's two guarantees plus its explicit "no blanket ban" non-guarantee (already labeled,
AC-001); BC-X.16.002's Condition/Behavior table's M1-and-M2-both-exit-64 plus the
message-distinctness requirement (already split across AC-005's M1-row citation and AC-006's
M2-row citation, per the Coverage Scope section's own note); BC-X.16.002 Postcondition 1's
chained before-`append_query_params`/before-`resolve_body`/before-`-H`-parsing ordering (already
extensively labeled under the P17-001 correction, with the `resolve_body`/`-H` halves attributed to
AC-008's (iii)/(iv) cells); and EC-X.16.002-8's failing form plus its three hyphen-leading-NAME
workaround forms plus its contrasting hyphen-leading-VALUE case (already labeled informational,
AC-009). All five checked clauses were already correctly scoped from prior passes; no further edit
was needed for sweep (b) beyond confirming coverage.

- P23-005 (cosmetic): the "## Previous Story Intelligence" table's `S-cycle14-user-list-project-resolution`
  row claimed, in its "Patterns Established" cell, that STORY-A "Established the exact §Scope
  bullet form (`` `file` — `symbol` ``, not `file::symbol`) required by
  `scripts/check-cargo-mutants-policy-citations.sh`" -- but that bullet form was not STORY-A's own
  invention; it was already specified by `verification-delta.md` §2, which STORY-A (and this
  story) both simply followed. Reworded the cell to "Reuses the policy's pre-existing
  `` `file` — `symbol` `` bullet form (verification-delta §2), not `file::symbol`, required by
  `scripts/check-cargo-mutants-policy-citations.sh`" so the credit is placed correctly.

Whenever this entry refers to the citation mechanism, it uses the plain phrase "CC tag" with no
bracket syntax, per this file's own established convention.

## 2026-09-28 -- F3 pass-24 fixes (P24-001, P24-002) plus cycle-wide exclusive-attribution and stray-marker sweep

Findings fixed directly in the story body (version bumped 5.0 -> 5.1; input-hash left untouched):

- P24-001 (low): two of this story's fault-model CC citations made an exclusive attribution claim
  that turned out to be factually wrong once checked against the cell design each AC actually owns.
  AC-006's citation said "the other seven faults in this clause are not killed by this AC's own
  tests" -- but AC-006 also owns the `-q =v` (M2) wiremock cell, and that cell's exact-message/
  distinguishing-substring assertion fails under both the swapped-M1/M2 fault and the
  one-shared-generic-message fault, exactly as AC-005's own M1 cell and partition proptest do.
  Reworded AC-006's citation to credit the M2 cell for also killing those two faults, while keeping
  AC-005's cells as the primary owners, and kept a narrowed negative claim -- with the verification
  stated inline -- for the remaining five faults that AC-006's cells genuinely cannot observe (no
  `--output json` invocation on the M2 cell, so the stdout/stderr-envelope fault stays with AC-006
  itself; the other four remain AC-005's). AC-009's citation said the remaining faults, including
  "an empty-NAME check evaluated before the missing-`=` check," were "owned by AC-005 and AC-006,
  not by this AC's own cells." Checked cross-cutting.md's own fault-model sentence (~L4360): it
  attributes that fault to "the `""` cells," plural, and AC-009's own EC-9 cell is one of the `""`
  cells (its three argv variants all feed an empty raw value), alongside AC-005's pinned
  `parse_query_param("")` example. Also checked whether AC-009's EC-5/EC-6/EC-7 cells kill the
  swapped-M1/M2 and one-shared-generic-message faults claimed exclusive to AC-005/AC-006: each of
  those three cells asserts its own distinguishing substring present and the other absent, which
  fails under either fault, so they do kill both, non-exclusively. Reworded AC-009's citation to
  credit its own EC-5/EC-6/EC-7 and EC-9 cells for these three faults while keeping AC-005's
  proptest and AC-006's envelope cell as the primary owners, and kept a narrowed negative claim --
  with the verification stated inline -- for the two faults AC-009's own attached-form cells
  genuinely cannot observe (none of its EC-5..10 argv values carries a second `=` character or a
  non-empty whitespace-only NAME, so the split-on-last-`=` and NAME-trimmed-before-empty-check
  faults stay with AC-005's proptest).
- P24-002 (cosmetic): two stray, unmatched double-asterisk bold markers -- one after "...unaffected
  by `-q`" in AC-004's P17-001 correction, one after "...does not yet exist as a recognized option"
  in AC-009's Task 9 red/green classification -- were removed. Both were leftover closing markers
  with no matching opener; the short, self-contained bold labels around them ("(P16-003
  classification:", "(P17-001)", "(P11-005 correction:") were already correctly self-closed.

Cycle-wide sweep (this story was the origin of the P24-001 finding): grepped this story for every
"fault model"/"not killed by"/"only by"/"owned by ... not"/"solely" phrase. Beyond the two fixes
above, found two further kept negative claims (AC-005's citation of the two faults AC-006/AC-009
own, and AC-007's/AC-008's citations of each other's ordering/reporting faults) that were already
accurate but lacked an inline verification sentence explaining why this AC's own cells cannot
observe the fault in question; added one to each (e.g. AC-005's cells never invoke `--output json`
and never supply a hyphen-leading argv token; AC-007's four cells never hold stdin open or supply a
`-H` flag; AC-008's two cells each supply exactly one malformed value, never two). No exclusive
claim in this story was found to be both false and left unfixed after this sweep. Also swept for
stray unmatched double-asterisk bold markers and unbalanced backticks story-wide beyond the two
P24-002 instances: none found (double-asterisk and backtick counts are both even after the P24-002
fix, and the one remaining long bold span -- the P17-001 Postcondition-1-ordering correction --
was verified to open and close within the same parenthetical).

Drift note: this pass's edits change what the stored `input-hash` should hash to. Per this pass's
explicit instruction not to touch `input-hash`, it was left as-is -- the resulting drift is
expected, matching this story's own and the sibling stories' prior-pass convention on this point,
and is for state-manager/orchestrator to reconcile, not something this pass tried to paper over.

## 2026-09-28 -- F3 pass-26 fixes (P26-001 medium, P26-004 low, P26-005 cosmetic, P26-006 cosmetic)

- P26-001 (MEDIUM): AC-005's fault-models paragraph claimed two of its own tests' fault kills --
  "split on the last `=` instead of the first" and "`{raw}` replaced by a trimmed or re-split
  value" -- without Task 6 ever pinning the generator properties those claims depend on: the
  VALUE/`rest` strategy's ability to produce a string containing one or more `=` characters, and
  the M1/M2 `raw` strategy's ability to produce leading/trailing whitespace. Without those pins, a
  compliant generator could omit both shapes entirely and the proptest would never exercise either
  fault. Fixed by adding both requirements to Task 6 (mirroring STORY-B's own Task 2 pinning
  style, which pins an empty-string requirement on its `value`/`name` strategies for the same
  reason), and by rewording AC-005's fault-models sentence so each claim states it relies on its
  matching Task 6 requirement.
- P26-004 (LOW): Task 10(c)'s "ONLY regression guards required GREEN both before and after this
  story" list omitted the pre-existing `src/cli/api.rs` `#[cfg(test)] mod tests` unit-test suite
  (the `normalize_path` trimming/slash/URL-rejection cells, `parse_header` cells, `resolve_body`
  cells), which `wave-holdout-scenarios.md`'s H-CYCLE14-W2-REG-001 explicitly names by line range
  as MUST-PASS alongside `tests/cli_handler.rs`. Verified against the actual file: the `mod tests`
  block in `src/cli/api.rs` starts at line 182 and ends at line 354, matching the holdout's own
  `~L185-354` citation. Fixed by adding this suite to Task 10(c)'s list.
- P26-005 (COSMETIC): AC-009 claimed "none of this AC's own EC-5..10 argv values contain a second
  `=` or a non-empty whitespace-only NAME," to explain why its own cells cannot kill two faults
  AC-005's proptest owns -- but the EC-6/EC-7 argv tokens themselves (`-q==v`,
  `--query-param==v`) do contain a second `=`; it is the `raw` value clap actually delivers to
  `parse_query_param` (`v`, `=v`, or the empty string) that never does. Reworded to describe the
  clap-delivered `raw` values instead of the argv tokens.
- P26-006 (COSMETIC): AC-003 claimed "this repo's convention reserves `#[tokio::test]` for cells
  that call `MockServer::start().await`." Verified against `tests/user_commands.rs`:
  `user_list_requires_project_flag` (STORY-A) is `#[tokio::test]` and calls no `MockServer` at
  all, so the claimed convention is false. Reworded to the accurate, narrower rationale already
  used elsewhere in this cycle's stories: a `--help` cell needs no async runtime (no wiremock), so
  it is a plain `#[test]`.

**Sweep** (per the pass-26 dispatch instruction, run across all three cycle-014 stories for each
finding's pattern):
- P26-001 sweep: checked every proptest fault-kill claim in all three stories for a matching
  generator-property pin. STORY-A's pure-resolver proptest's "distinct arbitrary non-empty keys
  `C`, `J`, `P`" constraint is already pinned directly in the binding VP text
  (`cross-cutting.md` L858-860), needing no story-level Task pin. STORY-B's own recursive
  `AllowedValue` proptest already has its empty-string generator requirement pinned in Task 2
  (added pass-25). This story's own VP-API-QP-001/002/003 proptests' generator properties (the
  separator oracle's path-shape coverage, VP-002's own "generator constraint" anti-vacuity
  assertion, VP-003's biased-alphabet strategy) are all pinned directly in their binding VP text in
  `cross-cutting.md`, with Task 3/4 already restating the load-bearing assertion requirements (the
  anti-vacuity assertion, the output-extraction requirement for the round-trip check). Only
  VP-API-QP-005's two faults named in P26-001 were unpinned; fixed above. No other gap found.
- P26-002-pattern sweep: checked every "informational"/"does not kill" fault-model label in all
  three stories against the story's own RED classification. Found no instance of that pattern in
  this story (the defect this sweep pattern targets was in STORY-B's AC-003, fixed there).
- P26-003-pattern sweep: checked every AC claim that a test "asserts X" in this story against its
  corresponding Task/VP requirement. Every such claim in this story traces to a cited binding VP
  clause or an existing Task-level pin (e.g. Task 3's generator-constraint assertion, Task 4's
  round-trip-extraction requirement, Task 6's `prop_assume!` filter requirement, Task 9's
  byte-identical-stderr requirement at EC-7). No unbacked claim found in this story (the one found
  cycle-wide was STORY-B's AC-001, fixed there).
- P26-006-pattern sweep: checked every `#[tokio::test]`-vs-`#[test]` convention claim in all three
  stories. STORY-A's own AC-008 Story-specific mapping already uses the correct, narrower phrasing
  ("it makes no wiremock server call and needs no async runtime"). This story's AC-003 was the
  only incorrect instance, fixed above.

No new test cell was added by any pass-26 fix in this story: both fixes pin generator properties
and regression-list membership on already-counted cells/functions. The Task 10(e) tally
(`TOTAL_NEW_TESTS = 45`, `RED_TESTS = 41`, `RED_RATIO = 41/44 ~= 0.932`) is unchanged.

Drift note: this pass's edits change what the stored `input-hash` should hash to. Per this pass's
explicit instruction not to touch `input-hash`, it was left as-is -- the resulting drift is
expected, matching this story's own and the sibling stories' prior-pass convention on this point,
and is for state-manager/orchestrator to reconcile, not something this pass tried to paper over.
