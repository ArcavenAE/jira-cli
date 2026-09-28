---
document_type: story-revision-history
story_id: "S-cycle14-user-list-project-resolution"
cycle: cycle-014
status: "historical — not normative"
---

# S-cycle14-user-list-project-resolution — Revision History

Historical record of F3 review-driven revisions. Not normative: where anything here differs
from the story body, the story body governs.

## Revision Note (F3 adversarial pass-12 fixes)

- **P12-001 (LOW):** AC-003's header cited Postcondition 3 (cross-cutting.md line 803) and
  EC-X.7.002-7 (lines 829-836) as owned, but no AC-003 test reaches either one: the VP(b)
  proptest's configured-default keys are all non-empty (line 860), and the spec itself marks
  EC-7 "informational, no VP cell" (line 829). Only the main clause of Postcondition 3 -- that a
  non-empty configured default is used -- is actually verified, by the VP(b)/VP(c) cells already
  cited in AC-003's Test body; the "Some(empty string) counts as present" sub-clause of
  Postcondition 3, and EC-7 in its entirety, have no dedicated cell. Fixed by adding a sentence
  to AC-003's Test body labeling both citations informational, inherited, and naming their
  concrete enforcement mechanism: reusing `Config::project_key` unchanged per the Invariants
  clause (lines 808-810) and Architecture Compliance Rules row 5, backstopped by PR code
  review. Both citation tags are kept in place, per the human's instruction not to remove
  coverage.

- **P12-002 (LOW):** AC-007's Test body cited "its non-`--all` contract" at cross-cutting.md
  line 894, but AC-007's own tests are both `--all` pagination cells -- neither exercises the
  non-`--all`, exactly-one-request path that line 894 actually describes. Fixed by replacing the
  bare citation with a sentence naming the cells that really verify it: the VP(c) EC-1,
  EC-3 "both", EC-5, and EC-6 cells' "exactly one request" assertions, owned respectively by
  AC-005, AC-003, AC-009, and AC-006 -- each of those cells' own (non-`--all`) invocation is what
  demonstrates the exactly-one-request property line 894 states. The citation tag is kept; the
  prose now says explicitly that AC-007's own tests do not cover it.

- **SYSTEMIC SWEEP (same defect class, additional findings):** every citation-tagged clause in
  every AC was re-checked against the two-part rule this pass's dispatch specified: either a
  test cell the AC owns verifies the cited text, or the citation is labeled
  informational/inherited with a named concrete enforcement mechanism. Two further citations
  satisfied neither and are fixed here:
  - AC-001's header cites Postcondition 1 (line 801, "local wins unconditionally"), but AC-001's
    Test body never mentions it, and the argv cell that actually demonstrates it -- the "both
    given" cell -- is physically part of AC-001's inline test function but is owned by AC-005
    (AC-005's own Test body already cites Postcondition 1 against that cell). Fixed by adding a
    sentence to AC-001's Test body pointing at AC-005's cell as the actual verifying test, rather
    than leaving Postcondition 1 as an unengaged header citation.
  - AC-009's header cites Invariants (lines 808-810), but AC-009's Test body never mentions it at
    all. The "no new Config/ProfileConfig accessor, no new cache file" structural half of
    Invariants is a code-review-only constraint (Architecture Compliance Rules row 5), not
    something a wiremock cell can observe; the failure-mechanism-vs-fact behavioral half is
    verified by AC-004's exit-64 path test, not by AC-009's own EC-5 cell. Fixed by adding a
    sentence to AC-009's Test body labeling Invariants informational, inherited, and naming both
    halves' actual enforcement. While editing this AC, also tightened Fix step 3 (line 776, the
    `&Config`-threading + no-reload requirement) to explicitly tie it to the fault-3 kill
    described immediately after it in the same paragraph -- both cite the same EC-5 cell, so
    this closes the last loose end in this AC's citations without changing which cell owns what.

  Every other citation in every AC (AC-002 through AC-008, and the remainder of AC-001, AC-003,
  AC-007, AC-009) was checked against the same rule and already satisfies it: either an
  AC-owned cell demonstrates the cited text, or the citation already carries an explicit
  "informational, inherited" label naming its enforcement mechanism (a reused unchanged
  function, a named sibling AC's cell, or code review). No further citations were found to
  violate the rule.

  No `input-hash` change; no SCOPE/EXCLUDE line in the Coverage Scope section was touched, and no
  coverage was lost -- every edit in this pass only adds explanatory prose around an existing
  citation tag, never removes one.

## Revision Note (F3 adversarial pass-11 fixes)

- **P11-005 (LOW, Red Gate classification):** Task 7(a) previously classified two hermetic
  wiremock cells as WIRING-EXEMPT -- the EC-X.7.002-1 cell (`jr --project GLOBAL user list
  --project LOCAL`, both flags given, expects one request with `projectKeys=LOCAL`) and the
  EC-X.7.002-6 cell (`jr user list --project ""`, expects one request with an empty-string
  `projectKeys`). WIRING-EXEMPT is only the correct label for a cell that would FAIL against the
  pre-story code and passes solely because Task 1's stub wiring exists (the `String` ->
  `Option<String>` type change plus its `Some(p)` short-circuit). These two cells do not meet
  that bar: checked directly against the pre-story `src/cli/mod.rs` (where
  `UserCommand::List.project` is still the clap-REQUIRED `String` it is today, not yet
  `Option<String>`) and `src/cli/user.rs`, both cells supply the local `--project` flag directly
  -- `--project LOCAL` and `--project ""` respectively -- which already satisfies a required
  `String` field on its own, with no dependence on global-value propagation or the resolver.
  Built the pre-story binary and ran both invocations directly to confirm: `jr --project GLOBAL
  user list --project LOCAL --no-input` and `jr user list --project "" --no-input` each clear
  clap parsing today and reach the HTTP/auth layer (`Error: Not authenticated...`), never
  clap's "required arguments were not provided" error. Both cells were already going to pass
  before this story existed; Task 1's stub is not why. Fixed by reclassifying both as GREEN
  non-exempt with `rationale_category: PRE-EXISTING-BEHAVIOR`, the same label and treatment
  `S-cycle14-api-query-param` uses for its own zero-flag wiremock examples that pass
  independently of that story's stub -- counted in `TOTAL_NEW_TESTS` and in the denominator, but
  never in `RED_TESTS` or in `EXEMPT_TESTS`.

  Every other WIRING-EXEMPT cell in Task 7(a) was re-checked the same way, running the pre-story
  binary against each: the bundled `Cli::try_parse_from` inline test (its zero-flag cell,
  `jr user list` with no flags at all, fails pre-story with clap's required-argument error, so
  the whole function correctly stays WIRING-EXEMPT -- it only passes once Task 1's `Option<String>`
  change lands), the EC-X.7.002-2 cell (`jr --project FOO user list`, global only, no local flag
  -- fails pre-story the same way, since a required local `String` field is never filled by the
  global flag alone pre-story) and AC-007's global-flag `--all` cell (`jr --project FOO user
  list --all`, global only, no local flag -- fails pre-story for the identical reason) both
  correctly stay WIRING-EXEMPT. A cell stays WIRING-EXEMPT only if it would fail pre-story and
  passes solely because of Task 1's stub; a cell that already passes pre-story is GREEN
  non-exempt (`PRE-EXISTING-BEHAVIOR`) instead. Task 7(a)/(b), the density tally table, and
  AC-005/AC-006's Classification sentences are updated below to match. Recomputed every tally
  occurrence in the file (grepped for `9/9`, `EXEMPT_TESTS=5`, `EXEMPT_TESTS = 5`, and
  `RED_RATIO=9/9`): `TOTAL_NEW_TESTS = 14` (unchanged -- nothing added or removed, only
  reclassified), `RED_TESTS = 9` (unchanged), `EXEMPT_TESTS = 3` (was 5), `GREEN-nonexempt = 2`
  (new), denominator (`TOTAL_NEW_TESTS - EXEMPT_TESTS`) `= 11` (was 9), `RED_RATIO = 9 / 11 ≈
  0.82` (was 9/9 = 1.0) -- still clears the BC-8.29.001 threshold `RED_RATIO >= 0.5` (integer-precise
  check: `9 * 2 = 18 >= 11` holds). Every historical Revision Note below that restates the old
  tally is annotated in place with a pointer to this correction; those notes' own claims about
  *what changed in their own pass* (no test added/removed/reclassified by pass-4 through D-387)
  remain accurate as history -- only the tally figures they quoted are superseded by this pass.

- **P11-006 (LOW, Token Budget):** the "This story spec" row under `## Token Budget Estimate`
  was derived via a `wc -c` / 4 character-count approximation (P10-010's method) and undercounted
  the file. The Read tool's own token count for this file, read in full, is ~37,000 tokens.
  Updated the row to ~37,000 (method: "Read-tool token count") and recomputed the total and
  budget-usage percentage against it; see the corrected table below.

- **P11-007a (COSMETIC):** AC-008's `--help` cell was specified as an
  `#[tokio::test]` function in `tests/user_list_project_resolution.rs`. The cell spawns `jr
  user list --help` as a plain subprocess and asserts on its stdout -- it makes no wiremock
  server call and needs no async runtime. Changed to `#[test]` at its one mention in the story
  (AC-008's Story-specific note); no other Task or section repeats the test-macro choice for
  this specific cell.

## Revision Note (D-387 mechanical-coverage restructure + pass-10 fixes)

**Human decision D-387 (2026-09-28) -- delete the hand-written Clause Coverage Map, bind by
machine-checkable citation instead:** across passes 3-9, the `## Clause Coverage Map (D-386)`
table itself kept drifting from the AC `**Test:**` lines it was meant to audit (see P9-005,
P9-008, P9-012b below) -- the map was hand-maintained prose describing citations that lived
elsewhere in the file, and every hand-maintained duplicate is a fresh place for the next pass
to find drift. The human's fix is structural, not another sweep:

1. **The `## Clause Coverage Map (D-386)` section (both tables) is DELETED.** It is replaced by
   `## Coverage Scope (D-387)` (after the Behavioral Contracts section), which declares only
   WHICH spans of `cross-cutting.md` are in scope for this story (a `SCOPE` line naming a start-end line range) and
   which lines within those spans need no owning AC (an `EXCLUDE` line naming a start-end line range plus a reason,
   e.g. blank separator lines, section-label headings, and pure rationale/metadata prose such
   as Confidence/Source/Root-cause). Ownership itself is no longer recorded in a table at all.
2. **Every `### AC-NNN` section now carries its own `CC` machine tags (each naming a start-end line range)**, inline,
   next to each BC-X.7.002/VP-USER-LIST-PROJECT-001 clause name it cites, in both the header's
   `(traces to ...)` list and the `**Test:**` body. Any leftover prose `~L` citation in an AC is
   replaced by a `CC` tag. Coverage is now checkable mechanically: every `SCOPE` line
   in `## Coverage Scope (D-387)`, minus every `EXCLUDE` line, must fall inside at least
   one AC's `CC` range -- a script can verify this without re-deriving the mapping by hand,
   closing the exact failure mode (a self-attested map going stale) that recurred across passes
   3-9.
3. **Pass-10 ownership gaps closed (P10-001, P10-004, P10-007, P10-011):** the deleted map
   omitted or under-cited several clauses that the new inline citations now cover explicitly:
   BC-X.7.002 Fix step 5 (line 780, informational/inherited, now cited by AC-009), Resolution
   order steps 1-3 (lines 782-783/784/785, now cited by AC-005/AC-002/AC-003
   respectively; step 4's preemption clause was already inherited/informational per P9-008 and
   remains so, now cited inline by AC-001/AC-002/AC-003/AC-004), and
   VP-USER-LIST-PROJECT-001's preamble (lines 839-843, informational/inherited, now cited by
   AC-001) and (c) intro (lines 869-871, informational/inherited, now cited by AC-002). Every
   BC-X.7.002 clause (Fix steps 1-5, Resolution order steps 1-4, Preconditions, Postconditions
   1-5, Invariants, EC-X.7.002-1..7) and every VP-USER-LIST-PROJECT-001 part (preamble, (a),
   (b), (c) intro and cells, (d), fault model) now has at least one owning `CC` citation.
   Ownership assignments are otherwise unchanged from the deleted map's (already
   adversarially-reviewed) choices -- e.g. Fix step 4 remains AC-003/AC-009, Postcondition 1
   remains (primarily) AC-005, Postcondition 2 and Fix step 2 remain (among their owners)
   AC-001, and Invariants remain (among their owners) AC-004 -- this pass only changed WHERE
   ownership is recorded, not which AC owns which clause, except where a gap required adding a
   new citation.
4. **P9-008's "every clause heading now appears in the map" claim is SUPERSEDED by this
   restructure** -- there is no longer a map for a clause heading to "appear in"; see the
   SUPERSEDED marker added at that bullet, below.
5. **P10-010 (LOW): Token Budget corrected.** The `## Token Budget Estimate`'s "This story
   spec" row previously estimated ~2,600 tokens -- roughly 10x too low for a file this size.
   Recomputed honestly via `wc -w` x 1.3 (a standard words-to-tokens approximation) against the
   file's actual word count as of this pass; see the updated table for the corrected figures and
   budget-usage percentage.
6. **Independent coverage-check fixes (2026-09-28, same pass):** an independent coverage check
   found two EXCLUDE ranges that actually hid normative BC-X.7.002 text, violating D-387's own
   rule that normative text belongs in SCOPE and must be cited. Fixed: (a) the Behavior statement
   at line 753-754 ("jr user list needs a resolved project key before it can call
   .../multiProjectSearch?projectKeys=P") is moved out of the former line 753-757 EXCLUDE entry
   into its own SCOPE entry for line 753-754, cited from AC-004's header and Test body (the AC
   that enforces this premise on the exit-64 path). The remainder of the old entry stays
   excluded as rationale/context prose, split into three separate EXCLUDE entries: line 755
   (blank separator), line 756 (the Root-cause paragraph), and line 757 (blank separator) -- so
   the Root-cause paragraph is no longer bundled together with the now-scoped Behavior line.
   (b) The precedent paragraph at line 788-793 (documenting that local-wins matches `component
   create`'s explicit merge code and that BC-8.1.004 scopes only the no-project-configured
   exit-64 condition, not local-over-global precedence) is moved from EXCLUDE to SCOPE, cited
   from AC-005's header and Test body. Every remaining EXCLUDE line was re-checked against the
   rule (no requirement, behavior statement, or pinned value) and each still qualifies: heading
   labels, blank separator lines, the superseded pre-cycle-014 note, the Confidence/Source/
   Subject metadata block, the Root-cause paragraph at line 756, and the Trace field. (c) AC-004's
   two citations of the Preconditions clause (its header and its Test body) previously pinned
   line 795-798, which includes line 795, the "**Preconditions**:" label heading itself, not
   Preconditions content -- both are narrowed to line 796-798. The Coverage Scope section's
   SCOPE/EXCLUDE lines remain sorted, gapless, and non-overlapping across line 746-919 after
   these changes. No `input-hash` change; no other section of this story is affected.

Task 7's Red Gate density tally (`RED_TESTS=9`, `EXEMPT_TESTS=5`, `TOTAL_NEW_TESTS=14`,
denominator=9, `RED_RATIO=9/9=1.0`) is unchanged by this restructure -- no test was added,
removed, or reclassified; only how ownership is recorded changed, and Task 7's own
classification is independent of the (now-deleted) map. Re-verified against the corrected
per-AC citations above and still holds.

**SUPERSEDED by pass-11 (P11-005):** the tally quoted above was later found to misclassify two
cells (EC-X.7.002-1 and EC-X.7.002-6's wiremock cells) as WIRING-EXEMPT when they actually pass
pre-story and belong in GREEN-nonexempt instead -- this D-387 pass's own claim ("no test was
added, removed, or reclassified") is still accurate about what D-387 itself did; the
reclassification happened at pass-11, not here. Current figures: `RED_TESTS=9`,
`EXEMPT_TESTS=3`, `GREEN-nonexempt=2`, `TOTAL_NEW_TESTS=14`, denominator=11,
`RED_RATIO=9/11≈0.82`. See the "Revision Note (F3 adversarial pass-11 fixes)" above.

## Revision Note (F3 adversarial pass-9 fixes)

- **P9-002 (MEDIUM, spec-fidelity, recurring):** every AC's `**Test:**` line binding sentence
  (landed pass-8, P8-001) still enumerated a fixed category list (`cell, setup, argv, expected
  value, exit code, request-count assertion, counter-mock (`.expect(0)`), and stderr/help
  substring`) -- the exact defect shape D-386 was meant to close, since any category the human
  or a future spec addition introduces (e.g. a new mock-matcher kind, a new generator shape)
  that isn't already named in the list is, by the list's own wording, arguably NOT covered,
  reopening the "category list omits X" class each time `cross-cutting.md` gains a new kind of
  pinned assertion. Fixed by replacing the category-enumerating sentence in EVERY AC's
  `**Test:**` line, and in the D-386 Revision Note's own definition of that sentence (P9-009
  below), with a category-FREE sentence that binds by totality rather than by list membership:
  *"Everything the cited clause(s) specify is binding in its entirety and must be implemented
  exactly as written there; this story does not restate or narrow any of it."* This sentence
  cannot omit a category, because it does not enumerate any -- there is no longer a list for a
  future pass to find a gap in. The pass-8 canonical sentence is retired; see P9-009 for the
  D-386 note fix and the SUPERSEDED marker added to the pass-8 note's own quote of it.
- **P9-005 (LOW, spec-fidelity):** the `## Clause Coverage Map (D-386)` VP-cell table's `Cell`
  column copied argv vectors, expected values, and `.expect()` counter-mock detail BY VALUE from
  `cross-cutting.md` -- the same "copy, not reference" anti-pattern D-386 eliminated from the AC
  Test lines, just relocated to the map. A value copied into the map can drift from the source
  exactly as a value copied into a Test line could. Fixed by replacing every `Cell` column entry
  with a bare clause/cell identifier (e.g. `VP(a) cell 3`, `VP(c) EC-2`, `VP(c) \`--all\`
  global-flag`) that names WHICH cell the row is about without restating what that cell asserts;
  the `~line` column (already present) is sufficient to locate the binding text. The owning-AC,
  test-function, and classification columns are unchanged.
- **P9-008 (LOW, spec-fidelity, gap):** the BC-X.7.002 postcondition/Fix-step/edge-case map
  omitted two clauses that are present in the spec but have no AC citing them directly:
  **Preconditions** (`cross-cutting.md` ~L795-798 -- the config-isolation requirement for the
  EC-4 test and `user_list_requires_project_flag`, including clearing `JR_PROFILE`, and the
  requirement that a hermetic EC-4 test supply valid auth and a valid, known profile so it
  reaches this BC's own exit-64 path) and **Resolution order step 4's preemption clause**
  (`cross-cutting.md` ~L786 -- `validate_profile_name`/`Config::load_with`/
  `JiraClient::from_config` failures in `main.rs` preempt this BC's own exit-64 path and run
  before `cli::user::handle`/`handle_list` is ever invoked). Fixed by adding both as new map
  rows: Preconditions -> AC-004 (the test whose hermetic setup this precondition actually
  governs), and the Resolution-order step 4 preemption clause -> AC-001/AC-002/AC-003/AC-004,
  marked inherited/informational (every AC's hermetic wiremock test inherits this ordering by
  virtue of supplying valid auth and a known profile per Preconditions, rather than any AC
  asserting the preemption itself). AC-004's title now also cites `Preconditions` alongside
  `Postcondition 4` and `EC-X.7.002-4`. Walked BC-X.7.002 top to bottom against the resulting
  map: Confidence / Source / Subject / Behavior / Root-cause / the post-Resolution-order
  rationale paragraph are descriptive/rationale prose, not binding clauses, and are correctly
  left unmapped; every other paragraph and clause heading (Fix steps 1-5, Resolution order
  steps 1-4, Preconditions, Postconditions 1-5, Invariants, EC-X.7.002-1..7) now appears in the
  map.

  **SUPERSEDED by D-387:** the `## Clause Coverage Map (D-386)` this bullet describes is
  deleted. Ownership is now recorded by inline `CC` citations (each naming a start-end line range) in each AC's
  header and `**Test:**` body, per the `## Coverage Scope (D-387)` section and the "Revision
  Note (D-387 mechanical-coverage restructure + pass-10 fixes)" above -- there is no longer a
  map for a clause heading to "appear in."
- **P9-009 (LOW, spec-fidelity):** the D-386 Revision Note's own definition of the normative
  Test-line sentence (~L151-156, historical) quoted the pre-pass-8 wording (missing `exit code`)
  and, as of this pass, both the pre-pass-8 AND pass-8 wordings are superseded by P9-002's
  category-free sentence. Fixed by replacing the D-386 note's quoted definition with the new
  category-free sentence (same text as every AC's Test line, per P9-002) and adding a SUPERSEDED
  marker to the pass-8 note's own quote of the pass-8 sentence, so neither historical quote is
  mistaken for the current binding text.
- **P9-012b (COSMETIC):** the Clause Coverage Map's EC-X.7.002-5 row cited `cross-cutting.md`
  `~L880-884`, one line off from the `~L881-884` every AC's Test line already used. Verified
  against the spec (EC-X.7.002-5's sentence begins at line 881, "EC-X.7.002-5 (temp
  `config.toml`..."); the map row is corrected to `~L881-884` to match.
- **P9-013 (COSMETIC, template-compliance):** `## Library & Framework Requirements` was prose
  instead of the `| Tool | Version | Purpose |` table the story template
  (`templates/story-template.md`) specifies. Fixed by converting it into a one-row table,
  preserving the same content (no new dependency; `clap`'s existing `Cargo.toml` pin, resolved
  version, and why it's relied upon).
- **RESTATEMENT SWEEP (additional, same pass):** grepped the whole file for surviving
  parenthetical/inline restatements of VP/BC content (argv vectors, expected values, mock
  setups, generator descriptions) in the Tasks, maps, and ACs, outside the already-fixed
  category-list sentence. Found and fixed five: AC-002's Test line quoted VP(c)'s EC-2 expected
  value inline (`"global only -> \`projectKeys=FOO\`"`) instead of citing the cell by reference;
  AC-003's Test line described VP(b)'s generator shape and its `.jr.toml`-wins-over-profile
  outcome instead of citing VP(b) by reference; AC-005's Test line named the "both given -> local
  wins" outcome instead of just identifying the cell; AC-007's Test line restated the `--all`
  mock's three-page pattern and `.expect()` matchers; AC-008's Test line re-enumerated VP(d)'s
  assertion list (exit-0, whitespace-collapse, both substrings, the two exclusions) instead of
  citing VP(d) by reference. All five are replaced with bare clause/cell citations, keeping only
  the story-specific test-function/file/classification information the VP text cannot know, per
  D-386 rule 1. Task 6's `.expect(0)` on `multiProjectSearch` mock-setup detail is likewise
  replaced with a citation to VP-USER-LIST-PROJECT-001(c) EC-4. No other restatement was found
  in the Tasks, the Architecture Compliance Rules, or the File Structure Requirements sections.

## Revision Note (F3 adversarial pass-8 fixes)

- **P8-001 (MEDIUM, spec-fidelity):** the `**Test:**` line binding sentence in AC-005
  (`cross-cutting.md`-derived clauses ~L419-421), AC-006 (~L433-435), AC-007 (~L448-450),
  AC-008 (~L468-469), and AC-009 (~L479-481) each used a shortened binding sentence that
  listed only some of the D-386 categories (dropping, per AC, various combinations of
  `exit code`, `request-count assertion`, `counter-mock`, and `stderr/help substring`),
  narrowing the cited clauses' binding scope in violation of D-386's "bind by reference, not
  copy by value" rule (every category must be asserted binding, not a subset). Fixed by
  replacing EVERY AC's binding sentence -- all nine ACs (AC-001 through AC-009), not only the
  five flagged above -- with the SAME canonical sentence, now also covering exit-code
  assertions: *"Every cell, setup, argv, expected value, exit code, request-count assertion,
  counter-mock (`.expect(0)`), and stderr/help substring in the cited clause(s) is binding and
  must be implemented exactly as written there; this story does not restate them, and nothing
  here narrows them."* AC-001, AC-002, AC-003, AC-004, and AC-009 previously carried a close
  variant of this sentence missing only `exit code`; they are updated to the exact canonical
  wording too, so no two ACs' binding sentences diverge from each other or from what D-386
  requires. Verified by grepping the file: the canonical sentence (whitespace-normalized)
  occurs exactly nine times, once per AC, with no other variant remaining.

  **SUPERSEDED by pass-9 (P9-002):** the category-enumerating sentence quoted above is retired --
  it still listed a fixed set of categories, reopening the "category list omits X" class each
  time a new category of pinned assertion appears in the spec. Every AC's Test line, and the
  D-386 note's own definition of the sentence, now carry the category-free replacement quoted in
  the pass-9 note above. This bullet is left in place as the historical record of the pass-8 fix.
- **P8-002 (LOW, spec-fidelity):** AC-007's `**Test:**` line paraphrased
  `verification-delta.md` §2's hermetic setup as an itemized list ("per-test
  `JR_CONFIG_DIR`/`JR_CACHE_DIR` `TempDir`, a `.jr.toml`-free `cwd`, `JR_BASE_URL`/
  `JR_AUTH_HEADER`, and every other ambient `JR_`-prefixed var cleared"), which silently
  dropped §2 step 2's ancestor-directory check (no `.jr.toml` in any ANCESTOR of `cwd`, not
  just `cwd` itself) and its fail-loudly rule (no early-return skip on setup failure). Fixed by
  removing the itemized paraphrase and citing "hermetic per `verification-delta.md` §2 (all
  steps, binding)" instead, so every §2 step -- including the ancestor check and the
  fail-loudly rule -- is bound by reference rather than partially restated. Swept every other
  AC and Task for a similar itemized paraphrase of §2's steps; none was found -- every other
  hermetic-setup mention in this story already cites `verification-delta.md` §2 generically
  (e.g. AC-002, AC-004, AC-009, Tasks 5/6) without enumerating or narrowing its steps, so no
  further edits were needed.
- **P8-008 (COSMETIC):** the `## Previous Story Intelligence` section was prose instead of the
  `| Story | Key Decisions | Patterns Established | Gotchas Discovered |` table the story
  template (and sibling stories `S-cycle14-api-query-param.md`/`S-cycle14-field-options-name-label.md`)
  use. Fixed by converting it into a one-row table for S-580-1 (the
  `resolve_m2_project`/`component.rs` precedent), preserving the same prose content under the
  table's four columns; the "N/A -- first story in cycle-014's serial delivery chain" note is
  kept as the section's lead-in sentence, unchanged in meaning.

## Revision Note (D-386 bind-by-reference restructure + pass-7 fix)

**Human decision D-386 -- "bind by reference," not "copy by value" (2026-09-27/28):** across four
adversarial passes (pass-3 through pass-6, below), every recurrence of the same defect class --
an AC's `**Test:**` line paraphrasing a VP-USER-LIST-PROJECT-001 cell instead of quoting it
verbatim, a paraphrase silently dropping a sub-cell, and a self-attested "all other cells were
re-verified, no further gaps found" claim in one pass turning out to be wrong in the next -- was
fixed by adding the missing verbatim text back into the story. The human's diagnosis: copying
pinned VP content INTO the story is the root cause, not a fixable side effect of it -- every copy
is a fresh place for the next pass to find a paraphrase, a drop, or a transcription error, and a
self-attested "verbatim sweep complete" checklist has no mechanism to prove its own completeness
against the source. The fix applied this pass is structural, not another sweep:

1. **Every AC's `**Test:**` line now BINDS to its VP cell(s) by reference** -- it names the exact
   VP-USER-LIST-PROJECT-001 sub-clause(s) ((a)/(b)/(c)/(d)) and cell(s) it implements, with the
   `cross-cutting.md` ~line, and carries this normative sentence verbatim (updated pass-9,
   P9-002/P9-009 -- category-free, superseding the pass-6/pass-8 category-enumerating wording
   quoted in those passes' own historical notes below): *"Everything the cited clause(s) specify
   is binding in its entirety and must be implemented exactly as written there; this story does
   not restate or narrow any of it."* The Test line then carries
   ONLY story-specific information the VP text cannot know: which test file/module the cell lives
   in, how cells group into `#[test]`/`proptest!` functions (the counting unit Task 7 uses), and
   each function's RED-at-stub / GREEN-at-stub / WIRING-EXEMPT classification. No argv vector, no
   expected-value mapping, no pinned setup, and no counter-mock assertion is copied into an AC
   body or Test line anymore -- there is nothing left in this story for a future pass to find
   out-of-sync with `cross-cutting.md`, because nothing here restates it. The one exception,
   per the human's own carve-out: an AC body may still state a BC-X.7.002 postcondition's pinned
   string (AC-004's exit-64 message, AC-008's help text) because those are the BC's own
   postcondition text, not a VP-cell paraphrase -- each such AC's title already cites the
   postcondition number it states, per the human's "prefer referencing the postcondition number"
   instruction.
2. **The old "Pin -> AC -> Task-7-row checklist" (pass-6 note, below) is retired**, replaced by
   the `## Clause Coverage Map (D-386)` section (after Acceptance Criteria, below) -- a table
   built by walking VP-USER-LIST-PROJECT-001's own cells in `cross-cutting.md` top to bottom so
   each appears exactly once, plus a second table mapping every BC-X.7.002 postcondition, Fix
   step, and EC-X.7.002-1..7 to its owning AC. Unlike the retired checklist (a self-attested
   "V=verbatim-in-AC-Test-line" claim per row, disprovable only by re-deriving the whole sweep by
   hand, which is exactly what happened four times), the new map's correctness is checkable
   mechanically: for each AC, does its Test line cite the clause/cell this row claims it owns?
   The pass-6 note is left in place as historical record of why D-386 was made, but its checklist
   table is replaced with a pointer to the new section rather than carried forward stale.
3. **Task 3/4/5/6 (the test-writing tasks) gain an explicit instruction:** the test-writer MUST
   read the cited VP clause(s) in `cross-cutting.md` in full before writing a single cell --
   the VP text, not this story, is the source of truth for cell contents. This closes the
   mechanism by which a paraphrase could enter the codebase in the first place: a test-writer
   working from this story's Test lines alone now has no pinned values to (mis)transcribe from
   this story at all, only a pointer telling it where the binding text lives.
4. Task 7's Red Gate density tally (`RED_TESTS=9`, `EXEMPT_TESTS=5`, `TOTAL_NEW_TESTS=14`,
   denominator=9, `RED_RATIO=9/9=1.0`) is unchanged by this restructure -- no test was added,
   removed, or reclassified; only how each AC POINTS AT its owning test function changed. Every
   classification in Task 7(a)/(b) was re-checked against the new Clause Coverage Map's per-cell
   AC ownership and still holds (see the map's own "Task-7 function" column, which reproduces
   Task 7's classification per cell rather than a second, independently-derived one).

   **SUPERSEDED by pass-11 (P11-005):** two of the cells this pass re-checked (EC-X.7.002-1 and
   EC-X.7.002-6's wiremock cells) were misclassified as WIRING-EXEMPT; both actually pass
   pre-story and belong in GREEN-nonexempt. Current figures: `RED_TESTS=9`, `EXEMPT_TESTS=3`,
   `GREEN-nonexempt=2`, `TOTAL_NEW_TESTS=14`, denominator=11, `RED_RATIO=9/11≈0.82`. See the
   "Revision Note (F3 adversarial pass-11 fixes)" above.

**P7-008 (COSMETIC, pass-7):** Task 7(a)'s four pre-existing/unmodified regression-guard tests
were cited by approximate `.args`-line location (`tests/user_pagination.rs` `~L385`/`~L506`,
`tests/all_flag_behavior.rs` `~L288`, plus `tests/user_commands.rs` `~L142`) -- a citation form
CLAUDE.md's own "Citation form in spec/CLAUDE.md" convention deprecates in favor of symbol form,
since line numbers drift on refactor and a bare `<file>:NN-MM` citation is disallowed for new
citations. Verified against the current tree (`grep -n 'fn user_list_all_cli_paginates\|fn
user_list_all_cli_emits_safety_cap_warning\|fn user_list_default_caps_at_thirty\|fn
user_list_by_project_returns_users' tests/*.rs`) and switched to symbol form: `tests/user_commands.rs::user_list_by_project_returns_users`,
`tests/user_pagination.rs::user_list_all_cli_paginates`,
`tests/user_pagination.rs::user_list_all_cli_emits_safety_cap_warning` (the "sibling cap-hitting
test"), and `tests/all_flag_behavior.rs::user_list_default_caps_at_thirty`. The same fix is
applied to every other line-number citation of a test-file location in this story: Task 2/3's
`src/cli/mod.rs` `~L1435` insertion-point citations become `src/cli/mod.rs`'s existing
`#[cfg(test)] mod tests` block (symbol form, no line number -- the block is already named), and
Task 5/AC-007's `tests/user_pagination.rs` `~L19-25` citation of its non-hermetic helper becomes
`tests/user_pagination.rs::jr_cmd_json` (verified: `grep -n 'fn jr_cmd_json' tests/user_pagination.rs`
-> line 19). Citations of `cross-cutting.md`/`docs/specs/cargo-mutants-policy.md`/`README.md`/
`CHANGELOG.md`/`workflows/phases/per-story-delivery.md` line ranges are unaffected by this fix --
those are pins into non-test spec/doc/policy artifacts this story is required to cite by line
(the source-of-truth binding this whole restructure is built on, for `cross-cutting.md`), not
test-file citations.

## Revision Note (F3 adversarial pass-6 fixes)

- **ADV-C14-F3-P6-004 (LOW, spec-fidelity):** AC-003's Test line was missing
  VP-USER-LIST-PROJECT-001(c)'s pinned setup/expectation for two of EC-X.7.002-3's three
  sub-cells -- it named them (`".jr.toml`-only, profile-only, both") but only carried the
  "both" sub-cell's pin verbatim (landed in pass-3, ADV-C14-F3-P3-003). Fixed by adding the
  two missing sub-cells' pins verbatim from `cross-cutting.md` ~L873-877: the `.jr.toml`-only
  cell (temp `cwd` containing `.jr.toml` `project = "JRT"`, profile has NO `project` ->
  exactly one request with `projectKeys=JRT`) and the profile-only cell (temp `config.toml`
  profile `project = "FOO"`, no `.jr.toml` -> exactly one request with `projectKeys=FOO`).
  Neither of these two sub-cells carries a VP-pinned counter-mock (only the "both" sub-cell
  does) -- none was added, per the source text.

  **Root cause of the 4-pass recurrence:** ADV-C14-F3-P3-003 (pass-3) and ADV-C14-F3-P4-003
  (pass-4, below) each asserted this class of gap was fully closed for AC-003 without
  re-deriving the sub-cell-by-sub-cell pin list from `cross-cutting.md` -- both are corrected
  below (marked SUPERSEDED at their own bullets) rather than trusted as authoritative.

  **Mechanical exhaustive pin sweep performed this pass** (every cell, pinned setup, expected
  value, counter-mock, request-count assertion, and argv vector in VP-USER-LIST-PROJECT-001
  (a)-(d), `cross-cutting.md` ~L838-909), against every AC Test line and the Task 7 tally.
  Three further gaps of the *same* defect class (a VP-pinned sub-assertion narrated but not
  quoted verbatim in an AC Test line) were found and fixed in this pass:
  - AC-001's Test line named "all four flag-presence cells" without quoting their argv
    vectors -- fixed by adding VP(a)'s four base cells verbatim (`cross-cutting.md`
    ~L844-849): `["jr","user","list"]` -> `None`; `["jr","user","list","--project","L"]` ->
    `Some("L")`; `["jr","--project","G","user","list"]` -> `Some("G")`;
    `["jr","--project","G","user","list","--project","L"]` -> `Some("L")`.
  - AC-006's Test line named "two `Cli::try_parse_from` cells" without quoting their argv
    vectors -- fixed by adding VP(a)'s EC-X.7.002-6 argv pair verbatim (`cross-cutting.md`
    ~L850-851): `["jr","user","list","--project",""]` -> `Some("")` and
    `["jr","--project","","user","list"]` -> `Some("")`.
  - AC-003's Test line named "the 2x4 presence-space" for the `proptest!` without quoting
    VP(b)'s expected-value mapping -- fixed by adding it verbatim (`cross-cutting.md`
    ~L858-868): `cli_project = Some(C)` -> `Some(C)` in every configured cell; `cli_project =
    None` -> `Some(J)` (`.jr.toml`-only), `Some(P)` (profile-only), `Some(J)` (both --
    `.jr.toml` wins over the profile default, EC-X.7.002-5's caveat), `None` (neither, the
    only result mapping to exit 64).

  All other VP(a)/(b)/(c)/(d) cells and the fault-model's five kill-claims were re-verified
  cell-by-cell against the current AC Test lines and were already carried verbatim (pass-3/
  pass-4 landings) -- no further gaps found. Task 7's density tally is UNCHANGED by this pass
  (no test was added or removed, only Test-line prose was made verbatim): `RED_TESTS=9`,
  `EXEMPT_TESTS=5`, `TOTAL_NEW_TESTS=14`, denominator=9, `RED_RATIO=9/9=1.0` -- re-confirmed
  correct, matches every prior pass's tally.

  **SUPERSEDED by pass-11 (P11-005):** the "correct" tally re-confirmed above was later found to
  misclassify two cells; current figures: `RED_TESTS=9`, `EXEMPT_TESTS=3`, `GREEN-nonexempt=2`,
  `TOTAL_NEW_TESTS=14`, denominator=11, `RED_RATIO=9/11≈0.82`. See the "Revision Note (F3
  adversarial pass-11 fixes)" above.

  **SUPERSEDED by D-386 (pass-7):** the checklist that previously appeared here (a
  "V=verbatim-in-AC-Test-line" self-attestation per VP cell) is retired -- it was the mechanism
  that let this same defect class recur across four passes, since each pass's "V=OK" claim was
  only as good as that pass's own re-derivation and was never itself checked against
  `cross-cutting.md`. It is replaced by the `## Clause Coverage Map (D-386)` section below
  (after Acceptance Criteria), which every AC's `**Test:**` line now binds to BY REFERENCE
  instead of by copied/paraphrased value -- see the "Revision Note (D-386 bind-by-reference
  restructure + pass-7 fix)" note above for the full rationale. The pass-6 sweep results
  narrated above this checklist (the three additional gaps found and fixed, and the
  cell-by-cell re-verification of every other VP(a)/(b)/(c)/(d) cell) remain accurate as a
  historical record of pass-6's own findings; only the checklist table itself is superseded.

## Revision Note (F3 adversarial pass-5 fixes)

- **ADV-C14-F3-P5-004 (LOW, process-gap):** Task 7(b)'s cells were classified as RED
  ("`todo!()` panic or missing pinned behavior/text") without stating, per cell, which failure
  mechanism actually applies -- and the orchestrator playbook (`workflows/phases/per-story-delivery.md`
  ~L35) requires Step-3 failure messages to reference the behavior under test, not "not yet
  implemented". Fixed by adding an explicit failure-mechanism preface to bucket (b) and
  annotating every bullet in it: the `resolve_user_list_project` proptest fails via a direct
  in-process `todo!()` panic (its `cargo test` output literally is the panic message); every
  wiremock/integration cell that reaches the `None` arm (EC-X.7.002-3's three sub-cells,
  EC-X.7.002-4, EC-X.7.002-5/AC-009, AC-007's configured-default `--all` cell, and
  `user_list_requires_project_flag`) instead fails because the child `jr` subprocess panics on
  that same `todo!()` and exits 101 (Rust's default panic exit code), which mismatches the
  cell's own assertion (an expected exit 64, or a pinned stderr/request pattern) -- never
  because the test asserts on the literal panic text. AC-008's `--help` cell is called out as
  the one bucket-(b) exception: it never reaches the `None` arm or any `todo!()`, so it fails on
  a genuine behavioral assertion (the pinned help wording is simply absent until Task 8). The
  preface states explicitly, per BC-5.38.001 (Task 1 is a stub-architect `todo!()` stub), that
  the `todo!()`-panic/exit-101 failures are the EXPECTED Red signal for a strict-mode stub, so
  the orchestrator MUST NOT re-dispatch the test-writer for any of them; AC-008 is the only cell
  in this bucket whose RED status could indicate a genuine test-writer gap. The density tally
  (`RED_TESTS=9`, `EXEMPT_TESTS=5`, `TOTAL_NEW_TESTS=14`, denominator=9, `RED_RATIO=9/9=1.0`) was
  re-checked against this reclassification and found still correct -- the per-bullet test counts
  are unchanged (1+3+2+1+1+1=9), so the tally table is left as-is.

  **SUPERSEDED by pass-11 (P11-005):** `RED_TESTS` is unaffected by this bucket-(b) reclassification
  and is still `9`, but `EXEMPT_TESTS` was later found wrong (two bucket-(a) cells misclassified).
  Current figures: `RED_TESTS=9`, `EXEMPT_TESTS=3`, `GREEN-nonexempt=2`, `TOTAL_NEW_TESTS=14`,
  denominator=11, `RED_RATIO=9/11≈0.82`. See the "Revision Note (F3 adversarial pass-11 fixes)"
  above.

## Revision Note (F3 adversarial pass-4 fixes)

- **ADV-C14-F3-P4-002 (LOW):** Task 7's closing "Density (...) exclude every bucket-(a)
  GREEN-at-stub cell from the numerator" line was a no-op -- GREEN cells were never in
  `RED_TESTS` (the numerator) to begin with. Fixed per the orchestrator playbook's actual
  formula (`workflows/phases/per-story-delivery.md` Red Gate Density Check, ~L45-64):
  `RED_RATIO = RED_TESTS / (TOTAL_NEW_TESTS - EXEMPT_TESTS)`, where `EXEMPT_TESTS` (categories
  `GREEN-BY-DESIGN` / `WIRING-EXEMPT`) is removed from the DENOMINATOR. Every bucket-(a) cell is
  now individually mapped to `WIRING-EXEMPT` (red-gate-log.md table label `FRAMEWORK-WIRING`)
  with its rationale, and the `Cli::try_parse_from` cluster is pinned as ONE `#[test]` function
  (VP-USER-LIST-PROJECT-001(a) asserts multiple argv cells inside one inline test body), not one
  test per cell. The four genuinely-unmodified pre-existing regression guards
  (`user_list_by_project_returns_users`, `user_list_all_cli_paginates` + its cap-hitting sibling,
  `user_list_default_caps_at_thirty`) are now explicitly stated to never enter `TOTAL_NEW_TESTS`
  at all -- a different exclusion path than `EXEMPT_TESTS`, since the formula counts only tests
  "introduced in this story's delivery." `tests/user_commands.rs::user_list_requires_project_flag`
  is explicitly distinguished from those four: it IS substantively modified by this story's
  Task 6 hermeticity rewrite, so it counts as a RED-at-stub cell, not an out-of-scope
  pre-existing test. Task 7 now closes with an explicit RED / EXEMPT / denominator tally:
  RED_TESTS=9, EXEMPT_TESTS=5, TOTAL_NEW_TESTS=14, denominator=9, RED_RATIO=9/9=1.0 >= 0.5.

  **SUPERSEDED by pass-11 (P11-005):** "every bucket-(a) cell is ... mapped to `WIRING-EXEMPT`"
  is no longer accurate -- two bucket-(a) cells (EC-X.7.002-1 and EC-X.7.002-6's wiremock cells)
  pass pre-story and are reclassified to GREEN-nonexempt (`PRE-EXISTING-BEHAVIOR`). Current
  figures: RED_TESTS=9, EXEMPT_TESTS=3, GREEN-nonexempt=2, TOTAL_NEW_TESTS=14, denominator=11,
  RED_RATIO=9/11≈0.82 >= 0.5. See the "Revision Note (F3 adversarial pass-11 fixes)" above.
- **ADV-C14-F3-P4-003 (LOW):** AC-009's Test line and AC-003's `--profile alt` cell mention
  (EC-X.7.002-5) now carry VP-USER-LIST-PROJECT-001(c)'s pinned sub-assertions verbatim from
  `cross-cutting.md` ~L881-884: temp `config.toml` with profile `default` -> `project = "DEF"`
  and profile `alt` -> `project = "ALT"`, both URLs at the mock server, no `.jr.toml`; exactly
  one request with `projectKeys=ALT`, `.expect(0)` on a `projectKeys=DEF` mock. Swept every
  other VP(c) cell (AC-002, AC-003's three subcells, AC-004, AC-005, AC-006, AC-007) -- each
  already carries its VP(c) pin verbatim from the pass-3 fix (ADV-C14-F3-P3-003); no further
  changes needed there.
  **SUPERSEDED by pass-6 (ADV-C14-F3-P6-004):** the "AC-003's three subcells ... already
  carries its VP(c) pin verbatim" claim above was WRONG -- only the "both" subcell did;
  the `.jr.toml`-only and profile-only subcells' pins were still narrated, not quoted. See
  the pass-6 note above for the corrected sweep and fix.
- **ADV-C14-F3-P4-005 (LOW):** AC-001's Test line's vague "both local/global `-p` short-alias
  cells" is replaced with the exact argv vectors from `cross-cutting.md` ~L852-856:
  `["jr","user","list","-p","L"]` -> `Some("L")` and
  `["jr","--project","G","user","list","-p","L"]` -> `Some("L")`, with an explicit note that
  there is no global `-p` cell -- `Cli.project` (the global flag) has no short form.
- **ADV-C14-F3-P4-009 (LOW):** `holdout_anchors` gains `H-CYCLE14-W1-REG-002`
  (`--limit`/`--all` local-cap and pagination behavior unaffected), completing the full Wave 1
  scenario set from `wave-holdout-scenarios.md` (`H-CYCLE14-W1-INT-001`, `H-CYCLE14-W1-REG-001`,
  `H-CYCLE14-W1-REG-002` -- no other Wave 1 scenarios exist in that file as of this pass).
- **ADV-C14-F3-P4-010 (COSMETIC):** AC-011 and Task 13 now instruct the implementer to verify
  the current line numbers for the count line (nominally 113) and the `## Changelog`
  header/top-row locations (nominally 1583/1587) immediately before each of those edits, since
  inserting the new §Scope bullet first shifts every subsequent line down by one.

## Revision Note (F3 adversarial pass-3 fixes)

- **ADV-C14-F3-P3-001 (HIGH):** Task 1's stub was calling the still-`todo!()`
  `resolve_user_list_project` unconditionally from `handle_list`, which panics on every
  invocation and makes the Red Gate unexecutable -- while Task 7(c) claimed the file's
  existing `--project`-bearing tests stayed GREEN before and after. Fixed by rewriting Task 1
  to short-circuit around the stub whenever the post-clap `project` field is already `Some(p)`
  (approach (a), mirroring `S-cycle14-api-query-param`'s Task 1 zero-flag short-circuit): only
  the `None` arm reaches the stub. Task 9 (the GREEN task) now says explicitly that it removes
  that short-circuit and replaces it with the unconditional `resolve_user_list_project` call
  BC-X.7.002 Fix step 4 requires. Task 7 is rewritten to classify every Red Gate cell against
  this corrected stub shape -- including `user_list_requires_project_flag`, which dips RED at
  stub (its own no-`--project` invocation now hits the `todo!()` panic instead of clap's
  "required" error) and is not the before/after regression guard the original Task 7(c) claimed.
- **ADV-C14-F3-P3-003 (LOW):** AC-003, AC-005, AC-006, and AC-007's Test lines are updated to
  cite VP-USER-LIST-PROJECT-001(c) by name and to carry its pinned discriminating
  sub-assertions (exact request counts and `.expect(0)` counter-mocks) verbatim from
  `.factory/specs/prd/cross-cutting.md`.
  **SUPERSEDED in part by pass-6 (ADV-C14-F3-P6-004):** for AC-003, this landed the pin for
  the EC-X.7.002-3 "both" subcell only -- the `.jr.toml`-only and profile-only subcells were
  named but not carried verbatim, and remained a gap through passes 4 and 5. See the pass-6
  note above for the corrected sweep and fix.
- **ADV-C14-F3-P3-005 (LOW):** AC-011/Task 13 now pin the exact insertion point for the new
  `src/cli/user.rs` §Scope bullet in `docs/specs/cargo-mutants-policy.md` (verified directly
  against the file: the `src/jql.rs` bullet ends at line 89, followed by a blank line 90 and
  the `**FIX-F7-001 deferred, not added:**` paragraph at line 91 -- both before
  `### Sibling Candidates` at line 150, so the new bullet lands inside the range
  `scripts/check-cargo-mutants-policy-citations.sh` actually parses) and add a verification
  step for the guard's reported bullet count (29 -> 30, confirmed by running the script before
  this story's edit: `Check passed: 29 bullets parsed, 98 (file, fn) pairs validated`).
- **ADV-C14-F3-P3-006b (COSMETIC):** Task 6's quote of `tests/user_commands.rs`'s stale
  comment is corrected from a double-hyphen to the file's actual em dash (`--` -> `—`).

## 2026-09-28 -- F3 adversarial pass-14 fixes (cosmetic)

Two cosmetic findings fixed directly in the story body (version bumped 4.0 -> 4.1; input-hash
left untouched):

- P14-006: AC-001's Test paragraph claimed to implement VP-USER-LIST-PROJECT-001(a) "in full,"
  describing four base flag-presence cells as though AC-001 owned all of them, while the same
  paragraph already said the "both given" base cell is owned by AC-005. Reworded to say three
  base cells plus the two `-p` short-alias cells, noting the fourth base cell is shared with
  AC-005 rather than exclusively owned here. The same sweep caught two more instances of a
  citation tag sitting next to an "owned by AC-NNN" note: AC-001's second reference to
  Postcondition 1 (line 801) was changed from a bracketed citation tag to plain prose, since
  AC-005 already carries that tag in its own Test body; and AC-007's reference to the
  non-`--all` contract sentence (line 894) was relabeled informational, since no other AC cites
  that line and the tag needs to stay in place for coverage. No tally, cell count, or
  test-function grouping changed in any of these edits.
- P14-004: the Token Budget Estimate section cited an exact line count (700 lines) that was
  already stale relative to the file's actual length. Removed the exact line and character
  counts from that section's narrative and kept only the token estimates, since those are the
  only figures the budget-usage row actually depends on.

## 2026-09-28 -- F3 adversarial pass-15 fixes (cosmetic)

Two coverage-check leftovers and one cosmetic finding fixed directly in the story body (version
bumped 4.1 -> 4.2; input-hash left untouched):

- Coverage-check leftover: AC-001's heading still carried a real citation tag pointing at
  Postcondition 1 (line 801), even though the body already explains that citation is plain
  prose because AC-005 owns it. Confirmed AC-005 still carries the tag for that clause, then
  changed the AC-001 heading to spell out the same "cross-reference, owned by AC-005" wording
  instead of using a citation tag.
- Coverage-check leftover: two prose sentences referred to a citation tag by writing out its
  literal bracket form in backticks, which the coverage-checking script was reading as a
  malformed empty tag. Both were reworded to say "CC tag" in plain words instead of showing the
  bracket syntax: the sentence in AC-001 explaining why Postcondition 1 is plain prose, and the
  sentence in AC-007 explaining why the non-`--all` contract citation is kept only because no
  other AC cites that line. A story-wide check for the same pattern found no further
  occurrences in either this story or the field-options-name-label story.
- P15-002 (cosmetic): AC-001's closing paragraph said "these six cells" describing the cells in
  its single inline test function, but the count of cells actually described just above it
  (three base cells plus two `-p` short-alias cells) is five, not six. Corrected the wording to
  "these five cells" to match.

## 2026-09-28 -- F3 adversarial pass-16 fixes (P16-001, P16-010)

Two findings fixed directly in the story body (version bumped 4.2 -> 4.3; input-hash left
untouched):

- P16-001 (medium): the subsystems list named only the CLI layer subsystem, even though this
  story also makes a real, functional edit to the entry-point/runtime file's dispatch arm
  (threading the already-loaded config through), which belongs to a different subsystem per the
  architecture index. Added that subsystem to the subsystems list and rewrote the frontmatter
  comment so it no longer claims every modified file lives under the CLI layer's own directory,
  following the precedent an earlier mutants-scope story set for listing that subsystem whenever
  the entry-point file is genuinely, functionally touched.
- P16-010 (cosmetic): the acceptance criterion for the config-threading requirement cited a spec
  clause explaining why no separate project fallback parameter is added, but didn't say how that
  omission is actually checked. Added a note naming code review as the enforcement mechanism,
  pointing at the dispatch arm in the entry-point file where such a parameter would (and does
  not) appear.

## 2026-09-28 — F3 adversarial pass-17 fixes (P17-002, P17-005, P17-006) plus a sentence-level sweep

Version bumped 4.3 to 4.4; input-hash left untouched.

- P17-002 (low): two acceptance criteria cited a spec clause as something their own tests
  implement, when part of that clause is not actually observable by any test. The fourth
  acceptance criterion cited the invariants clause about reusing the existing config-merge
  resolution with no new accessor or cache, but its exit-64 tests cannot observe that structural
  fact; it is now marked informational, enforced by architecture compliance rule row 5 and code
  review, matching how the ninth acceptance criterion already treats the same clause. The first
  acceptance criterion cited the fix step about clap's own global-value propagation, including
  its "no jr-level merge code" half; that half is not something a test can observe either, so it
  is now marked informational, enforced by architecture compliance rule row 2 and code review
  (confirmed that rule's wording says exactly this) — the "global fills local" half stays a
  tested clause, unchanged.
- P17-005 (cosmetic): the revision history summary said the Red Gate density tally was
  "unchanged by the pass-14 cosmetic fixes below," but those fixes no longer live below that
  paragraph — they were moved into this sibling revision-history file in a later pass. Reworded
  to point at this file by name instead of "below."
- P17-006 (cosmetic): the frontmatter inputs list was missing `tests/user_pagination.rs`, which
  the fifth acceptance criterion's task explicitly modifies. Checked the rest of the File
  Structure Requirements table against the inputs list and found three more files the story
  modifies that were also missing: `.cargo/mutants.toml`, `docs/specs/cargo-mutants-policy.md`,
  and `CHANGELOG.md`. Added all four.
- Sentence-level sweep: went through every acceptance criterion's cited clause tags and checked
  each sentence or clause within them against the story's tests, following the same pattern the
  two P17-002 fixes above illustrate — a clause that is only partly testable needs its untestable
  half explicitly labeled, not left implied by the testable half's citation. Two more gaps of the
  same shape turned up and were fixed the same way:
  - The first acceptance criterion's citation of the help-text fix step covered the whole fix
    step, including two sentences that are pure design rationale (that the new help text is
    modeled on the component-list command's wording, and why it cannot reuse that wording
    byte-for-byte). Neither sentence is independently tested by this story or by the eighth
    acceptance criterion, which owns the pinned string itself. Labeled both sentences
    informational, as rationale for the pinned string.
  - The fourth acceptance criterion's citation of the invariants clause also covered a third
    sentence, about the existing regression test passing once hermetically isolated. That
    sentence's behavior is tested by the fourth acceptance criterion's own test update, but one
    piece of it — that a stale code comment must be updated — is not something any test asserts.
    Labeled that piece informational, enforced by PR code review.
  - The sixth acceptance criterion's citation of the empty-string edge case covered two more
    rationale sentences that are not independently tested by this story: the comparison to how
    two other commands already handle an empty `--project` value, and the point that Jira's own
    response, not `jr`, decides whether an empty project key is an error. Labeled both
    informational, as precedent/rationale for the pass-through choice.
  Everywhere else, the existing citations and their labels already held up under this sweep: no
  CC tag was removed, and no acceptance criterion lost coverage of any clause it already
  owned.

## 2026-09-28 -- F3 adversarial pass-18 fixes (P18-003, P18-004)

Two findings fixed directly in the story body (version bumped 4.4 -> 4.5; input-hash left
untouched):

- P18-003 (low): the fix step describing clap's own global-value propagation makes three
  points -- global fills local when only global is given, local wins and that value propagates
  back up to the shared global-position argument when both are given, and no jr-level merge code
  is written for any of it. The first acceptance criterion's citation of that fix step only
  covered the first and third points; the local-wins-and-propagates-back-up point was missing
  entirely. Added it as two labeled halves: the local-wins half is verified by the fifth
  acceptance criterion's "both given" cell (confirmed that cell still exists there), and the
  propagation back up to the shared global-position argument is labeled informational and
  inherited -- it is clap's own `fill_in_global_values` mechanism, not something `handle_list`
  can observe, enforced by clap's own behavior and by architecture compliance rule row 2's code
  review. No new test cell was added; the tally is unchanged.
- P18-004 (low): the Token Budget section claimed a full Read-tool call on the split file
  returns the whole file in one call with no truncation notice, and estimated the story-spec row
  at ~24,000 tokens. Both claims were wrong -- the actual count is closer to 25,200 tokens and
  the read does truncate. Removed the truncation claim entirely rather than restating it either
  way, rounded the story-spec row to the nearest 5,000 (~25,000), marked it approximate and
  noted it drifts with edits, and recomputed the total and budget-usage percentage against the
  new figure (~31,000 total, ~16% of the agent's context window).

## 2026-09-28 -- F3 adversarial pass-19 fixes (P19-001, P19-004, P19-005)

Three findings fixed directly in the story body (version bumped 4.5 -> 4.6; input-hash left
untouched):

- P19-001 (low): the fourth acceptance criterion labeled its citation of Resolution order step 4
  as informational and inherited across the board, even though that spec line is really two
  sentences doing two different jobs. The first sentence -- the exit-64-before-any-HTTP-call rule
  itself -- is exactly what that acceptance criterion's own edge-case test and the existing
  `user_list_requires_project_flag` test check directly, so it isn't informational at all. Split
  the citation in two: the first sentence is now credited to those two tests as the thing they
  actually verify, and only the second sentence (about earlier failures in profile validation,
  config loading, and client construction preempting this path) stays labeled informational and
  inherited, since the acceptance criterion's tests only need to get past those earlier checks
  rather than test them.
- P19-004 (low): the eighth acceptance criterion's body and its task both called the two quoted
  substrings "the pinned help string" / "the pinned AC-008 wording," which blurs the line between
  what the automated test actually checks (two substrings) and the full exact sentence the
  underlying contract pins. Reworded the acceptance criterion body to call them "the VP(d) test
  substrings" and added a sentence stating that the full exact string is enforced at PR review,
  since the automated test only pins the two substrings. Reworded the task to point at the
  underlying contract's own pinned exact string by its source location instead of calling it "the
  pinned AC-008 wording." Grepped the rest of the story for the same pattern: one more instance,
  in the first acceptance criterion's discussion of the help-text rationale, referred to "the
  pinned string AC-008 asserts" -- reworded it the same way, to "the VP(d) test substrings AC-008
  asserts," for consistency. The remaining mentions of "pinned help wording" elsewhere in the
  story (Task 7's density-tally discussion) refer to the real help text not yet existing in the
  code until the finalize task runs, not to what the test checks, so those were left as they were.
- P19-005 (low, partial): added the mutation-testing policy citation guard script and the
  project's `Cargo.toml` to the frontmatter's list of input files. Both were already cited in the
  story body -- the guard script is cited in the eleventh acceptance criterion, its task, and the
  Definition of Done, and `Cargo.toml` is cited as the source of the pinned clap version in the
  Library and Framework Requirements table -- so this only makes the frontmatter list match what
  the story already depends on and cites by line number and pinned value.

## 2026-09-28 -- F3 adversarial pass-20 fixes (P20-003, P20-004)

Findings fixed directly in the story body (version bumped 4.6 -> 4.7; input-hash left untouched):

- P20-003 (low): the CHANGELOG task's description of the failure-mode change had the direction
  backwards. It said a global-only or config-default-only `jr user list` invocation "previously
  failed via clap's exit-2 ... now fails ... via exit-64" -- but those two invocations are exactly
  the ones the #862 fix makes succeed; only an invocation with no local flag, no global flag, AND
  no configured default now fails, and it fails with `jr`'s own exit-64 `JrError::UserError`
  rather than clap's exit-2 "required argument" error. Reworded the task to state the correct
  direction plainly: no-project-resolvable invocations now fail via exit-64 (previously clap
  exit-2), while global-only and configured-default invocations (previously exit-2) now succeed.
  Kept the existing "Breaking: `jr user list` with no project resolvable now exits 64, not clap's
  exit 2" example string unchanged, since it was already correct and needed no fix. Grepped both
  stories for every other sentence describing this behavior change afterward -- the narrative's
  "So that" line, AC-002's "reported as broken (previously clap exit 2)" sentence, the Definition
  of Done's CHANGELOG bullet (which already scopes itself to "no-project-resolvable failure
  mode"), and the `user_list_requires_project_flag` discussion in the Red Gate section -- all
  already describe the correct direction, so none needed changing.
- P20-004 (low): added `src/cli/component.rs` and `src/cli/field.rs` to the frontmatter inputs
  list. Both were already cited in the story body -- `src/cli/component.rs::handle`'s `List`/
  `Create` arms and `src/cli/field.rs::resolve_m2_project` are both named as precedent in the
  Token Budget Estimate's "Referenced code" row and again in the Previous Story Intelligence
  table -- so this only makes the frontmatter inputs list match what the story already depends on
  and cites.

Drift note: adding these two files to `inputs:` changes what the stored `input-hash` should hash
to. Per this pass's explicit instruction not to touch `input-hash`, it was left as-is -- the
resulting drift is expected, the same as this story's own pass-19 note on this point, and is for
state-manager/orchestrator to reconcile, not something this pass tried to paper over.

## 2026-09-28 -- F3 adversarial pass-21 fix (P21-002)

Finding fixed directly in the story body (version bumped 4.7 -> 4.8; input-hash left untouched):

- P21-002 (low): the Architecture Compliance Rules table's first row named the "no reload
  config" rule's Source as "BC-X.7.002 Fix step 3, Invariants" -- but the rule's actual
  enforcement mechanism (AC-009's EC-X.7.002-5 test failing on a reload) is the same clause the
  spec itself cross-references for exactly this ordering, not the general Invariants section.
  Verified directly against cross-cutting.md before changing anything: line 776 is Fix step 3
  itself (the sentence "handle/handle_list MUST NOT call Config::load/Config::load_with
  themselves -- reloading would ignore the --profile/JR_PROFILE selection already resolved into
  that binding"), and line 817 is EC-X.7.002-5, whose own closing sentence restates and is the
  spec's chosen test vehicle for that identical no-reload requirement ("handle/handle_list never
  reload config -- the &Config passed through already reflects the --profile/JR_PROFILE
  selection"). Changed the row's Source cell from "BC-X.7.002 Fix step 3, Invariants" to
  "BC-X.7.002 Fix step 3, EC-X.7.002-5" to match. No other change was made to the row.

Coverage-check sweep: grepped this story for any CC tag citation with a real spec line range
outside a `### AC-NNN` section; none were found -- every genuine CC tag citation in this story
already lives inside an AC's header or Test body. The handful of `[CC:...]`/`[CC:L<start>-<end>]`
mentions outside AC sections (in the Revision History summary and the Coverage Scope (D-387)
intro paragraph) are generic references to the citation mechanism itself, not real citations with
concrete line numbers, so none needed changing.

Inputs sweep: grepped this story's body for every `src/`-prefixed file citation and confirmed each
one (`src/cli/mod.rs`, `src/cli/user.rs`, `src/main.rs`, `src/config.rs`, `src/cli/component.rs`,
`src/cli/field.rs`) already appears in the frontmatter `inputs:` list. No additions were needed.
