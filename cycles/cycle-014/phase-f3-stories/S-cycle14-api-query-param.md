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
# reverse: that story's own doc/mutants edits must land after this one.
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
version: "1.3"
last_updated: "2026-09-27"
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
`src/cli/api.rs::append_query_params(path: &str, pairs: &[(String, String)]) -> String` (new pure function) assembles the query string per the separator algorithm, evaluated in this order: (a) no `?` in the pre-`#` part -> a fresh leading `?`, regardless of a trailing `&` (EC-X.16.001-14); (b) a `?` is present and the query component (text after the first `?`) is empty or ends in `&` -> new pairs appended with NO separator (EC-X.16.001-8); (c) otherwise -> `&`-joined, even when the query component itself ends in a literal `?` (EC-X.16.001-9). Detection scans ONLY the part of `<path>` before its first `#`; a trailing `#fragment` is re-appended unchanged after the assembled query (EC-X.16.001-5). A pre-existing query pair is kept verbatim even when its NAME collides with a new pair's NAME -- neither deduplicated against nor overridden (EC-X.16.001-12).
**Test:** VP-API-QP-001's `proptest!` separator oracle + pinned examples for every listed EC, explicitly including the pinned example `/s?#f` + `k=v` -> `/s?k=v#f` (kills the "find('?') over the whole path" fault -- a whole-path scan would see the fragment `#f`'s trailing text as the query component and wrongly insert `&`), and the pinned EC-X.16.001-12 example `/s?fields=summary` + `fields=status` -> `/s?fields=summary&fields=status` (VP-API-QP-001's exact-string example, `cross-cutting.md` ~L4022-4025).

### AC-002 (traces to BC-X.16.001 Behavior 2, Postcondition 4, EC-X.16.001-12/13)
Repeated `--query-param NAME=...` occurrences are ALL sent, in flag order, with no deduplication or last/first-wins collapsing -- neither among themselves nor against a pre-existing same-NAME query pair (pre-existing pairs are kept verbatim and sent first). The `-q` clap field is a plain `Vec<String>` with NO `value_delimiter`, so a comma inside VALUE is never split into multiple pairs.
**Test:** VP-API-QP-002's `proptest!` oracle (`parse(out_query) == parse(in_query) ++ new_pairs`) + the `fields=summary,status` argv cell (EC-X.16.001-13) + the repeated-flags argv cell + the mixed cell (`jr api '/x?a=1' -q b=2 -q b=3` -> raw query exactly `a=1&b=2&b=3`).

### AC-003 (traces to BC-X.16.001 Behavior 3, Postcondition 3, EC-X.16.001-3/10/11)
NAME and VALUE are percent-encoded EXACTLY ONCE via `urlencoding::encode` (never `url::form_urlencoded::byte_serialize`), applied separately; every encoded byte is RFC 3986 unreserved (`A-Za-z0-9-._~`) or an uppercase `%HH` triplet; space encodes to `%20`, never `+`. NAME/VALUE are used exactly as typed -- NEITHER is trimmed (D-380, settled 2026-09-25). The `--query-param`/`-q` help text contains the literal substring `"do not pre-encode"`.
**Test:** VP-API-QP-003's biased `proptest!` (round-trip, alphabet, encoder-identity, no-trim) + the `--help` integration cell, explicitly including the pinned examples `*` -> `%2A`, `%` -> `%25`, `+` -> `%2B`, `é` -> `%C3%A9`, and literal `%25` -> `%2525`, and confirming the (d) no-trim examples (`" =v"` -> `%20=v`, `"k= v "` -> `k=%20v%20`) additionally run through `parse_query_param` (VP-API-QP-005) to prove a whitespace-only NAME is accepted, not rejected as empty.

### AC-004 (traces to BC-X.16.001 Behavior 4/5, Postconditions 1/5, EC-X.16.001-6/7)
The query assembly is identical regardless of `-X`/`--method` (GET/POST/PUT/PATCH/DELETE), and query-param content is never merged into, or sourced from, `-d`/`--data`'s request body. An invocation with zero `--query-param` flags produces a path byte-identical to `normalize_path`'s own output; `append_query_params(p, &[]) == p` for any `p` (identity function).
**Test:** VP-API-QP-004's structural check + table-driven hermetic wiremock over all five methods (with/without `-d`) + `proptest!` identity + layer-(2) zero-flag wiremock examples, EACH run for EVERY one of the five HTTP methods (GET/POST/PUT/PATCH/DELETE): `jr api rest/api/3/myself` -> received path `/rest/api/3/myself` with no bare `?`; `jr api "/rest/api/3/search?jql=a&"` -> received query exactly `jql=a&`.

### AC-005 (traces to BC-X.16.002 Behavior, Postcondition 1, EC-X.16.002-1, EC-X.16.001-2)
`src/cli/api.rs::parse_query_param(raw: &str) -> Result<(String, String)>` (new pure function, distinct from `append_query_params`) splits on the FIRST `=`; a raw value with no `=` at all (including the empty string, EC-X.16.002-9) exits 64 with the pinned message `"--query-param must be in NAME=VALUE format (got: {raw})"` (M1), zero HTTP calls. A VALUE containing further `=` characters (e.g. `jql=status=Done`, EC-X.16.001-2) is split on the FIRST `=` only, so `rest` keeps every later `=` verbatim.
**Test:** VP-API-QP-005's partition `proptest!` (including the `"jql=status=Done"` -> `Ok(("jql", "status=Done"))` cell) + pinned `parse_query_param("")` example + hermetic wiremock cell.

### AC-006 (traces to BC-X.16.002 Behavior, Postcondition 1, Postcondition 2, EC-X.16.002-2)
An empty NAME (nothing before the first `=`, e.g. `=v`) exits 64 with the pinned, DISTINCT message `"--query-param NAME cannot be empty (got: {raw}) — use NAME=VALUE, e.g. -q maxResults=50"` (M2). An empty VALUE (`k=`) is explicitly ALLOWED, not an error (BC-X.16.001 EC-X.16.001-1). In `--output json` mode (Postcondition 2), the same `{"error": "...", "code": 64}` envelope is written to STDERR (never stdout) for both the M1 and M2 cases: `"error"` equals the rendered message byte-for-byte, `"code"` is `64`, and stdout is empty.
**Test:** VP-API-QP-005 (M2 partition) + hermetic wiremock cell; both messages verified distinguishable by substring (D1 present/absent, D2 present/absent); VP-API-QP-005(2)'s `--output json` cell for the `{"error","code"}` envelope.

### AC-007 (traces to BC-X.16.002 Postcondition 3, Invariants, EC-X.16.002-3)
A single invocation with multiple `--query-param` flags where any one is malformed fails the WHOLE invocation before any HTTP call, reporting the FIRST malformed value in flag order (mirrors `parse_header`'s existing `.collect::<Result<Vec<_>>>()` all-or-nothing pattern).
**Test:** VP-API-QP-006(i)/(ii).

### AC-008 (traces to BC-X.16.002 Postcondition 1, D-188 pre-flight convention, EC-X.16.002-4)
In `handle_api` (`src/cli/api.rs`), `--query-param` parsing is inserted immediately after the existing `normalize_path(&path)?` call and BEFORE `resolve_body(...)` (which can block reading stdin for `-d @-`) and BEFORE `-H`/`--header` parsing. A held-open stdin pipe with a malformed `-q` value must not hang -- the child process exits 64 within ~5s.
**Test:** VP-API-QP-006(iii), spawned via `std::process::Command` (not `assert_cmd`, which closes stdin before waiting) with a held-open `ChildStdin` handle, polling `try_wait()` against a ~5s deadline; + VP-API-QP-006(iv) (`jr api /x -q bad -H "malformed-no-colon"` -> exit 64 reporting M1, NOT `parse_header`'s `"Header must be in 'Key: Value' format"` error, proving `-q` validation runs before `-H` parsing).

### AC-009 (traces to BC-X.16.002 Edge Cases EC-X.16.002-5..10; EC-X.16.002-11 informational, no VP cell)
Clap's own attached-form and missing-value parsing produces the documented `raw` values and outcomes: `-q=v` -> M1 `(got: v)`; `-q==v` and `--query-param==v` -> M2 `(got: =v)`; `-q -x=1` -> clap exit 2 (`unexpected argument`), not 64, neither D1 nor D2, stderr does NOT contain `Not authenticated` (`JrError::NotAuthenticated` also exits 2, so exit code alone cannot distinguish the two); `-q ""`/`-q=`/`--query-param=` -> M1 `(got: )` (EC-X.16.002-9); `-q` as the last argv token (no value at all) -> clap exit 2 (`a value is required for`), not 64, stderr does NOT contain `Not authenticated` (same rationale). The `-q`/`--query-param` flag is NOT declared with `allow_hyphen_values`. **Informational note (EC-X.16.002-11, no owning VP cell):** a non-UTF-8 `-q` argv value is likewise rejected by clap (the field's `String` `ValueParser`) with exit 2 before `parse_query_param` ever runs -- the same mechanism and outcome as a non-UTF-8 `-H` value today; this is inherited clap behavior, not a distinct `parse_query_param` M1/M2 outcome, so it is recorded here for traceability only and carries no test obligation of its own.
**Test:** VP-API-QP-005's attached-form argv cells (EC-X.16.002-11 has no VP cell -- informational only, per BC-X.16.002's own EC-X.16.002-11 text).

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

1. [ ] **STUB:** add `pub(crate) fn append_query_params(path: &str, pairs: &[(String, String)]) -> String` and `pub(crate) fn parse_query_param(raw: &str) -> Result<(String, String)>` to `src/cli/api.rs` with `todo!()` bodies (signatures per AC-001/AC-005); add the `-q`/`--query-param: Vec<String>` field to `Command::Api` (`src/cli/mod.rs`, no `value_delimiter`, no `allow_hyphen_values`) and wire the pre-flight call site into `handle_api` and `src/main.rs`'s `Command::Api` dispatch arm -- the `handle_api` wiring MUST short-circuit around both stubs when zero `-q` flags are supplied (use the pre-existing `normalize_path` output unchanged), so the crate compiles end-to-end and the zero-flag path never touches a `todo!()`. **No pinned help text at stub:** the `-q`/`--query-param` field's doc comment / clap `help`/`long_help` string MUST NOT contain the BC-X.16.001 Behavior 3 pinned substring `"do not pre-encode"` at this stage -- Task 12 (clap field finalization) is what adds it; this keeps AC-003's `--help` test cell genuinely RED at the Task 1 stub (Task 10(a)) rather than accidentally GREEN from a premature-but-correct doc comment -- `stub-architect`
2. [ ] Write the `proptest!` separator oracle for `append_query_params` + pinned examples (AC-001 list) (AC-001) in `src/cli/api.rs`'s `#[cfg(test)] mod tests` -- `test-writer`
3. [ ] Write the repeated-names `proptest!` oracle (`src/cli/api.rs`'s `#[cfg(test)] mod tests`) + argv cells including the mixed cell (`tests/api_query_param.rs`) (AC-002) -- `test-writer`
4. [ ] Write the encoding-exactly-once biased `proptest!` + pinned examples (AC-003 list, including the two no-trim examples that also run through `parse_query_param`) (`src/cli/api.rs`'s `#[cfg(test)] mod tests`) + `--help` cell (`tests/api_query_param.rs`) (AC-003) -- `test-writer`
5. [ ] Write the method-orthogonality table-driven wiremock test + zero-flag wiremock examples (`tests/api_query_param.rs`) + zero-flag identity `proptest!` (`src/cli/api.rs`'s `#[cfg(test)] mod tests`) (AC-004) -- `test-writer`
6. [ ] Write the `parse_query_param` partition `proptest!` + pinned examples (`src/cli/api.rs`'s `#[cfg(test)] mod tests`) + the wiremock/JSON-envelope cells (`tests/api_query_param.rs`) (AC-005, AC-006) -- `test-writer`
7. [ ] Write the multi-flag first-malformed wiremock cell (`tests/api_query_param.rs`) (AC-007) -- `test-writer`
8. [ ] Write the held-open-stdin `std::process::Command` test + the before-`-H`-parsing cell (`tests/api_query_param.rs`) (AC-008) -- `test-writer`
9. [ ] Write the attached-form argv cells (`tests/api_query_param.rs`) (AC-009) -- `test-writer`. **Counting-unit pin (feeds Task 10's density tally):** each of EC-X.16.002-5, -6, -7, -8, -9 (its three attached-empty variants `-q=`/`--query-param=`/`-q ""` count as ONE cell/test), and -10 is its OWN `#[test]` function (one function per EC id, not one function spanning multiple EC ids) -- this is the unit Task 10's `RED_TESTS`/`TOTAL_NEW_TESTS` counts are computed against, so EC-X.16.002-8 and EC-X.16.002-10's GREEN-at-stub status can be excluded/included per-test rather than ambiguously bundled with the RED EC-X.16.002-5/6/7/9 cells
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
        its own PRE-EXISTING-BEHAVIOR GREENs.
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

    | Task / AC (VP) | Cell | Tag |
    |---|---|---|
    | Task 2 / AC-001 (VP-API-QP-001) | separator-oracle `proptest!` | RED |
    | Task 2 / AC-001 | pinned example EC-X.16.001-4 (`?existing=1` -> `&`-joined) | RED |
    | Task 2 / AC-001 | pinned example EC-X.16.001-5 (`/s?#f` + `k=v` -> `/s?k=v#f`) | RED |
    | Task 2 / AC-001 | pinned example EC-X.16.001-8 (bare `?`/`&` -> no separator) | RED |
    | Task 2 / AC-001 | pinned example EC-X.16.001-9 (query ends in literal `?` -> still `&`-joined) | RED |
    | Task 2 / AC-001 | pinned example EC-X.16.001-12 (`/s?fields=summary` + `fields=status` -> `/s?fields=summary&fields=status`) | RED |
    | Task 2 / AC-001 | pinned example EC-X.16.001-14 (`/x&` + `k=v` -> `/x&?k=v`) | RED |
    | Task 3 / AC-002 (VP-API-QP-002) | repeated-names `proptest!` | RED |
    | Task 3 / AC-002 | argv cell EC-X.16.001-13 (`fields=summary,status`, one pair) | RED |
    | Task 3 / AC-002 | argv cell: repeated flags (`-q b=2 -q b=3`) | RED |
    | Task 3 / AC-002 | argv cell: mixed (`/x?a=1 -q b=2 -q b=3` -> `a=1&b=2&b=3`) | RED |
    | Task 4 / AC-003 (VP-API-QP-003) | encoding-exactly-once biased `proptest!` | RED |
    | Task 4 / AC-003 | pinned example `*` -> `%2A` | RED |
    | Task 4 / AC-003 | pinned example `%` -> `%25` | RED |
    | Task 4 / AC-003 | pinned example `+` -> `%2B` | RED |
    | Task 4 / AC-003 | pinned example `é` -> `%C3%A9` | RED |
    | Task 4 / AC-003 | pinned example literal `%25` -> `%2525` | RED |
    | Task 4 / AC-003 | no-trim pinned example `" =v"` -> `%20=v` (also asserts via `parse_query_param`) | RED |
    | Task 4 / AC-003 | no-trim pinned example `"k= v "` -> `k=%20v%20` (also asserts via `parse_query_param`) | RED |
    | Task 4 / AC-003 | `--help` cell (pinned substring `"do not pre-encode"` absent at stub) | RED |
    | Task 5 / AC-004 (VP-API-QP-004) | table-driven method-orthogonality wiremock test (5 methods x with/without `-d`) | RED |
    | Task 5 / AC-004 | zero-flag identity `proptest!` (`append_query_params(p, &[]) == p`) | RED |
    | Task 5 / AC-004 | zero-flag wiremock example: `jr api rest/api/3/myself` | GREEN-nonexempt (PRE-EXISTING-BEHAVIOR) |
    | Task 5 / AC-004 | zero-flag wiremock example: `jr api "/rest/api/3/search?jql=a&"` | GREEN-nonexempt (PRE-EXISTING-BEHAVIOR) |
    | Task 6 / AC-005 (VP-API-QP-005) | partition `proptest!` (incl. `"jql=status=Done"` -> `Ok(("jql","status=Done"))`) | RED |
    | Task 6 / AC-005 | pinned `parse_query_param("")` example | RED |
    | Task 6 / AC-005/006 | wiremock cell `-q foo` (no `=`) -> M1 | RED |
    | Task 6 / AC-006 | wiremock cell `-q =v` (empty NAME) -> M2 | RED |
    | Task 6 / AC-006 | `--output json` envelope cell -- ONE `#[test]` asserting BOTH the M1 and M2 envelope shapes (not split into 2) | RED |
    | Task 9 / AC-009 | attached-form cell EC-X.16.002-5 (`-q=v` -> M1, got: v) | RED |
    | Task 9 / AC-009 | attached-form cell EC-X.16.002-6 (`-q==v` -> M2, got: =v) | RED |
    | Task 9 / AC-009 | attached-form cell EC-X.16.002-7 (`--query-param==v` -> M2, got: =v) | RED |
    | Task 9 / AC-009 | attached-form cell EC-X.16.002-8 (`-q -x=1` -> clap exit 2) | EXEMPT (WIRING-EXEMPT / FRAMEWORK-WIRING) |
    | Task 9 / AC-009 | attached-form cell EC-X.16.002-9 (`-q ""`/`-q=`/`--query-param=`, merged into ONE test -> M1, got: empty) | RED |
    | Task 9 / AC-009 | attached-form cell EC-X.16.002-10 (`-q` as last argv token -> clap exit 2) | EXEMPT (WIRING-EXEMPT / FRAMEWORK-WIRING) |
    | Task 7 / AC-007 (VP-API-QP-006) | all-or-nothing cell (i) | RED |
    | Task 7 / AC-007 | all-or-nothing cell (ii) | RED |
    | Task 7 / AC-007 | first-malformed-reported cell 1 | RED |
    | Task 7 / AC-007 | first-malformed-reported cell 2 | RED |
    | Task 8 / AC-008 | held-open-stdin cell | RED |
    | Task 8 / AC-008 | before-`-H` cell | RED |

    (e) **Recomputed RED / EXEMPT / denominator tally** (ADV-C14-F3-P5-001, ADV-C14-F3-P5-002(c);
    matches the (d) enumeration exactly; re-verify against the actual Step 3 dispatch output
    before relying on it -- this is a pre-implementation projection, not a substitute for the
    real count):

    | AC / VP | New tests | RED | GREEN-nonexempt (category) | EXEMPT (category) |
    |---|---|---|---|---|
    | AC-001 (VP-API-QP-001) | 7 (separator oracle `proptest!` + 6 pinned examples) | 7 | 0 | 0 |
    | AC-002 (VP-API-QP-002) | 4 (repeated-names `proptest!` + 3 argv cells: EC-X.16.001-13, repeated-flags, mixed) | 4 | 0 | 0 |
    | AC-003 (VP-API-QP-003) | 9 (encoding `proptest!` + 5 encode pinned examples + 2 no-trim pinned examples + `--help` cell) | 9 | 0 | 0 |
    | AC-004 (VP-API-QP-004) | 4 (table-driven method-orthogonality wiremock test + zero-flag identity `proptest!` + 2 zero-flag wiremock examples) | 2 | 2 (PRE-EXISTING-BEHAVIOR) | 0 |
    | AC-005/006/009 (VP-API-QP-005) | 11 (partition `proptest!` + pinned `parse_query_param("")` example + 2 wiremock cells + 1 `--output json` envelope cell + 6 attached-form cells) | 9 | 0 | 2 (WIRING-EXEMPT / FRAMEWORK-WIRING -- EC-X.16.002-8, EC-X.16.002-10) |
    | AC-007/008 (VP-API-QP-006) | 6 (2 all-or-nothing cells + 2 first-malformed-reported cells + held-open-stdin cell + before-`-H` cell) | 6 | 0 | 0 |
    | **Total** | **41** | **37** | **2** | **2** |

    `TOTAL_NEW_TESTS = 41`, `EXEMPT_TESTS = 2` (0 GREEN-BY-DESIGN + 2 WIRING-EXEMPT), so the
    denominator is `41 - 2 = 39`; `RED_TESTS = 37` (the 2 non-exempt GREEN cells stay in the
    denominator but are not RED); `RED_RATIO = 37 / 39 ≈ 0.949 >= 0.5` -- comfortably clears the
    BC-8.29.001 gate under this counting unit, with no full-exception path (denominator > 0) and
    no UNJUSTIFIED GREEN cells. Record this tally, and the actual counts observed after Step 3
    dispatch, in `red-gate-log.md`.
    (f) **`todo!()`-panic vs. subprocess-assertion failure mode** (ADV-C14-F3-P5-004): the 19
    direct-call cells in (d) that invoke `append_query_params`/`parse_query_param` in-process
    (all of AC-001's 7 cells; AC-002's `proptest!` only, not its 3 argv cells; AC-003's
    `proptest!` + 5 encode pinned + 2 no-trim pinned, not its `--help` cell; AC-004's zero-flag
    identity `proptest!` only, not its wiremock cells; AC-005's `proptest!` + pinned `""`
    example) can only fail with a raw `todo!()` panic (message containing "not yet
    implemented"), never a produced-and-asserted-wrong-value diff -- **this is the EXPECTED Red
    signal for this story's strict-`tdd_mode` stub** (Task 1 is a stub-architect `todo!()` stub
    per BC-5.38.001); the orchestrator must NOT re-dispatch the test-writer for these 19 cells on
    the basis of panic-vs-assertion-error alone. The remaining 22 cells in (d) are subprocess-level
    (spawned via `std::process::Command`/the CLI binary in `tests/api_query_param.rs`, or the
    pre-existing `tests/cli_handler.rs`/`tests/rate_limit_holdouts.rs` regression guards) and fail
    (or pass) via their own exit-code/stderr `assert_eq!`/`assert!` checks in the test function
    itself -- the child process's underlying `todo!()` panic surfaces there as an unexpected exit
    code / panic text on stderr, but the top-level test function fails via a normal assertion,
    satisfying Step 3's Red Gate requirement (~L35) literally.
11. [ ] Implement `append_query_params` and `parse_query_param` in `src/cli/api.rs` (AC-001..003, AC-005..007) -- `implementer`
12. [ ] Finalize the `-q`/`--query-param` clap field on `Command::Api` (`src/cli/mod.rs`) with the pinned help text (AC-003, AC-009) -- `implementer`
13. [ ] Wire `handle_api` to call `-q` parsing immediately after `normalize_path` and before `resolve_body`/`-H` parsing (AC-008) -- `implementer`
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
