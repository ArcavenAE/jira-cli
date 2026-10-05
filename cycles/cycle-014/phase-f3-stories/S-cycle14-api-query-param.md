---
document_type: story
level: ops
story_id: "S-cycle14-api-query-param"
epic_id: "ISSUE-TRIAGE-QUICKFIXES-1"
title: "jr api --query-param/-q NAME=VALUE: percent-encoded query-string assembly and its error taxonomy"
wave: 2
status: done
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
  - ".factory/specs/architecture/ARCH-INDEX.md"
  # dependency-graph-extended.md intentionally excluded here (D-389, F3 fix): that graph
  # lists this story as one of ITS OWN inputs, so listing it back here would create a
  # circular input reference. `spec_source:` below preserves the provenance link without
  # creating the cycle.
  - "src/cli/mod.rs"
  - "src/main.rs"
  - "src/cli/api.rs"
  - "src/cli/user.rs"
  - "src/jql.rs"
  - "README.md"
  - "CLAUDE.md"
  - "tests/cli_handler.rs"
  - "tests/rate_limit_holdouts.rs"
  - "tests/e2e_cli_surface_guard.rs"
  - "tests/e2e_live.rs"
  - "tests/mutants_glob_existence.rs"
  - ".cargo/mutants.toml"
  - "docs/specs/cargo-mutants-policy.md"
  - "CHANGELOG.md"
  - "Cargo.toml"
  - "scripts/check-cargo-mutants-policy-citations.sh"
input-hash: "e0e2f9e"
traces_to: "BC-X.16.001, BC-X.16.002"
cycle: cycle-014-issue-triage-quickfixes
estimated_effort: large
estimated_days: 2
target_module: "src/cli/api.rs, src/cli/mod.rs, src/main.rs"
subsystems: ["SS-01", "SS-02"]
# SS-02 (CLI Layer, src/cli/) owns this story's core scope because most
# modified files (src/cli/api.rs, src/cli/mod.rs) live under src/cli/ per
# ARCH-INDEX's Subsystem Registry (SS-02 row: "CLI Layer | src/cli/"). SS-01
# (Entry Point & Runtime) is also listed because this story modifies
# src/main.rs's `Command::Api` dispatch arm to wire the new `-q` field
# through to `handle_api` (Task 1/Task 13) -- src/main.rs is owned by SS-01
# per ARCH-INDEX's Subsystem Registry (SS-01 row: "Entry Point & Runtime |
# src/main.rs"), not SS-02; it does not "live under src/cli/". This is a
# real, functional edit to main.rs's dispatch wiring (not a doc-only touch),
# so it is anchored, following the S-MUTANTS-SCOPE-1 precedent of listing
# SS-01 whenever src/main.rs is functionally modified (STORY-INDEX ~L588:
# `subsystems:["SS-01","SS-08"]`). No HTTP-client-core (SS-03) file is
# touched -- append_query_params/parse_query_param run strictly before
# client.request is built (BC-X.16.001 Invariants).
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
version: "6.2"
last_updated: "2026-09-29"
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

## Revision History

**D-386** (bind-by-reference VP citations) and **D-387** (mechanical CC-tag coverage, checked
against Coverage Scope below) are both in force. Pass-31 (2026-09-28) replaced every AC's
"informational"/"informational cross-reference" label with the three-way O/N/U scheme (O =
observed by a named test; N = not runtime-observable, enforced by a mechanism; U =
runtime-observable, no cell by design) and collapsed this section to this pointer. Current Red
Gate tally (Task 10(e)): `TOTAL_NEW_TESTS = 45`, `RED_TESTS = 41`, non-exempt GREEN `= 3`,
`EXEMPT_TESTS = 1`, `RED_RATIO = 41 / 44 ~= 0.932 >= 0.5` (direct-call/subprocess split 23/22).
Pass-32 (2026-09-28) fixed a Token Budget row-1 double-count (the Read tool's truncation header
reports the whole-file token count, not a per-chunk count to be summed), a mislabeled AC-009
clause, two Task-level "informational"-label residues (Task 12, Task 13), and an unlabeled half of
AC-001's Invariant 4 first sentence, then followed up in the same pass on a coordinator finding
that "each AC's Test paragraph names VP clauses" is not itself an explicit label: every CC citation
in AC-001 through AC-009 that lacked an inline (O)/(N)/(U) tag naming its own observing
test/mechanism now carries one (107 of 107 CC citations in that range are labeled), split per
sentence wherever a clause's sentences are not uniformly observed. Pass-33 (2026-09-29, D-389
final F3 fixes) named the AC-001/Task 2 story-added P22-002 pinned example as a required Task 2
deliverable, removed `dependency-graph-extended.md` from this story's own `inputs:` (circular --
that graph lists this story as one of its own inputs), relabeled two (N) citations to (U)
(AC-008's config/client-construction-preemption sentence and AC-001's RFC 9112 fragment sentence),
reworded this paragraph's own two malformed literal CC-tag bracket occurrences to plain "CC
citation" wording, and added a Coverage Scope note that per D-389 the (O)/(N)/(U) labels are
non-blocking documentation. Story version
**6.2**. Full pass-3 through pass-33 history:
`S-cycle14-api-query-param.revision-history.md` -- historical and non-normative; where anything
there differs from this body, this body governs.

## Coverage Scope (D-387)

D-387 (human decision): the former hand-written clause maps (see
`S-cycle14-api-query-param.revision-history.md`) kept drifting from the AC CC-tag citations they
were meant to summarize, so they are deleted. AC
citations become the single source of ownership. This section enumerates the entire
BC-X.16.001/BC-X.16.002/VP-API-QP-001..006 region of `.factory/specs/prd/cross-cutting.md`
(L3783-4394) as either in scope, needing at least one owning AC CC-tag citation (recorded below as
a `SCOPE` entry giving the clause's line range and name), or excluded, needing none because it is
heading, blank-line, or non-normative provenance/bibliographic prose (recorded below as an
`EXCLUDE` entry giving the line range and reason). Ownership is recorded solely by the CC-tag
citations in each AC; coverage (every SCOPE line minus EXCLUDE is inside some AC's CC-tag range)
is verified mechanically per D-387. Per D-389 the (O)/(N)/(U) annotations on citations are
non-blocking documentation; convergence is judged on clause-level traceability and
behavior/test-affecting findings.

One further span, L3772-3779 (the `## BC-X.16: API Query Parameters` subsection intro
paragraph -- new in the same cycle-014 hunk as the L3783-4394 region above), is intentionally
left unlisted: it is subsection context for both BCs below, not a testable clause of either, and
its "no new dependency" statement is restated in BC-X.16.001's Source field and, as a binding
requirement, in Invariant 3, which is in scope and cited (by AC-003). This mirrors how STORY-B
(`S-cycle14-field-options-name-label`) names its own `## BC-X.14` subsection intro as
intentionally unlisted.

Alongside that intro paragraph, the structural lines immediately around it are also intentionally
left unlisted, for the same non-normative reason: L3770 (the `## BC-X.16: API Query Parameters`
subsection heading itself), L3781 and L4396 (the `---` section separators bracketing the
subsection), and the blank lines surrounding them (L3771, L3780, L3782, L4395, L4397) -- heading,
separator, and blank-line structure, not testable clause content, matching this section's own
EXCLUDE treatment of comparable heading/blank/separator lines within the SCOPE/EXCLUDE lists
below.

### BC-X.16.001

- `[EXCLUDE:L3783]` heading line ("#### BC-X.16.001: ..."), no normative content
- `[EXCLUDE:L3784]` blank line
- `[EXCLUDE:L3785-3796]` Confidence/Subject/Source provenance metadata, not testable clause content
- `[SCOPE:L3797-3805]` Behavior intro (the `-q`/`--query-param` clap flag declaration: plain
  `Vec<String>`, no `value_delimiter`, no `allow_hyphen_values`)
- `[SCOPE:L3806-3822]` Behavior 1 (query-string detection and merge / separator algorithm)
- `[SCOPE:L3823-3825]` Behavior 2 (repeated same-name params all sent, in order)
- `[SCOPE:L3826-3852]` Behavior 3 (encode NAME/VALUE exactly once; no-trim design default;
  `--help` pinned substring)
- `[SCOPE:L3853-3857]` Behavior 4 (method-orthogonal)
- `[SCOPE:L3858-3863]` Behavior 5 (zero effect when the flag is absent)
- `[EXCLUDE:L3864]` blank line
- `[SCOPE:L3865-3866]` no-regression guarantee: existing `jr api` behavior for BC-X.1.007
  (raw-passthrough of the response) and BC-X.1.011 (`-X`/`--method` case-insensitivity) is
  unaffected by this BC -- normative, owned by AC-004
- `[EXCLUDE:L3867]` blank line
- `[EXCLUDE:L3868]` "**Preconditions**:" heading line
- `[SCOPE:L3869-3871]` Precondition 1 (`<path>` already `normalize_path`-normalized)
- `[SCOPE:L3872-3873]` Precondition 2 (every `--query-param` value well-formed `NAME=VALUE`,
  malformed values deferred to BC-X.16.002)
- `[EXCLUDE:L3874]` blank line
- `[EXCLUDE:L3875]` "**Postconditions**:" heading line
- `[SCOPE:L3876-3879]` Postcondition 1 (zero-flag identity)
- `[SCOPE:L3880-3891]` Postcondition 2 (separator algorithm; `?`-presence evaluated before
  `&`-termination)
- `[SCOPE:L3892-3895]` Postcondition 3 (encode exactly once)
- `[SCOPE:L3896-3897]` Postcondition 4 (repeated params, flag order)
- `[SCOPE:L3898-3900]` Postcondition 5 (method/body independence)
- `[EXCLUDE:L3901]` blank line
- `[EXCLUDE:L3902]` "**Invariants**:" heading line
- `[SCOPE:L3903-3904]` Invariant 1 (`append_query_params` is pure, side-effect-free)
- `[SCOPE:L3905-3906]` Invariant 2 (runs strictly before the `RequestBuilder` is built)
- `[SCOPE:L3907-3911]` Invariant 3 (`urlencoding::encode` is the intended encoder; `byte_serialize`
  forbidden)
- `[SCOPE:L3912-3915]` Invariant 4 (guarantee scope: never a second `?`, never `&` after an
  empty/`&`-terminated query component; no blanket `?&`/`??` substring ban)
- `[EXCLUDE:L3916]` blank line
- `[EXCLUDE:L3917]` "**Edge Cases**:" heading line
- `[SCOPE:L3918-3920]` EC-X.16.001-1 (`k=`, empty VALUE, allowed)
- `[SCOPE:L3921-3923]` EC-X.16.001-2 (VALUE contains `=`, splits on first only)
- `[SCOPE:L3924-3930]` EC-X.16.001-3 (non-ASCII VALUE, UTF-8 percent-encoded)
- `[SCOPE:L3931-3932]` EC-X.16.001-4 (path already ends `?existing=1`)
- `[SCOPE:L3933-3942]` EC-X.16.001-5 (path contains `#fragment`)
- `[SCOPE:L3943-3945]` EC-X.16.001-6 (combined with `-X` method flags)
- `[SCOPE:L3946-3949]` EC-X.16.001-7 (`--query-param` entirely absent)
- `[SCOPE:L3950-3959]` EC-X.16.001-8 (path ends in bare `?` or `&`)
- `[SCOPE:L3960-3968]` EC-X.16.001-9 (query component ends in literal `?`)
- `[SCOPE:L3969-3973]` EC-X.16.001-10 (NAME is whitespace-only)
- `[SCOPE:L3974-3977]` EC-X.16.001-11 (VALUE has leading/trailing whitespace)
- `[SCOPE:L3978-3988]` EC-X.16.001-12 (NAME collides with existing query NAME, no dedup/override)
- `[SCOPE:L3989-3994]` EC-X.16.001-13 (comma inside VALUE)
- `[SCOPE:L3995-4000]` EC-X.16.001-14 (no query, pre-fragment part ends in `&`)
- `[EXCLUDE:L4001]` blank line
- `[EXCLUDE:L4002]` "**Verification Properties**:" heading line, shared by VP-API-QP-001..004
- `[SCOPE:L4003-4006]` VP-API-QP-001..004 shared preamble (purity statement;
  `url::form_urlencoded::parse` test-oracle-only note)
- `[SCOPE:L4007-4023]` VP-API-QP-001 equation + strategy (pinned examples: EC-4, EC-5, EC-8 (both
  forms), EC-9)
- `[SCOPE:L4024-4031]` VP-API-QP-001 pinned-examples tail (the empty-query-plus-fragment case
  (verified: `cross-cutting.md` L4024-4025), EC-14, EC-12) + fault-models
- `[SCOPE:L4032-4041]` VP-API-QP-002 oracle
- `[SCOPE:L4042-4048]` VP-API-QP-002 generator-constraint
- `[SCOPE:L4049-4050]` VP-API-QP-002 pinned-decode-example
- `[SCOPE:L4050-4054]` VP-API-QP-002 argv cell (EC-X.16.001-13)
- `[SCOPE:L4055-4059]` VP-API-QP-002 argv cell (repeated flags)
- `[SCOPE:L4059-4062]` VP-API-QP-002 argv cell (mixed)
- `[SCOPE:L4063-4069]` VP-API-QP-002 fault-models
- `[SCOPE:L4070-4072]` VP-API-QP-003 intro
- `[SCOPE:L4073-4075]` VP-API-QP-003(a) round-trip
- `[SCOPE:L4076-4077]` VP-API-QP-003(b) alphabet
- `[SCOPE:L4078-4080]` VP-API-QP-003(c) encoder identity
- `[SCOPE:L4081-4083]` VP-API-QP-003(d) no trimming
- `[SCOPE:L4084-4087]` VP-API-QP-003(e) help-text pin
- `[SCOPE:L4087-4089]` VP-API-QP-003 further-pinned examples
- `[SCOPE:L4089-4091]` VP-API-QP-003 fault-models
- `[SCOPE:L4092-4098]` VP-API-QP-004 structural
- `[SCOPE:L4098-4101]` VP-API-QP-004(1) zero-flag identity
- `[SCOPE:L4101-4106]` VP-API-QP-004(2) zero-flag wiremock examples
- `[SCOPE:L4106-4108]` VP-API-QP-004 fault-models
- `[EXCLUDE:L4109]` blank line
- `[EXCLUDE:L4110-4118]` Trace section: bibliographic references, not itself a testable clause
- `[EXCLUDE:L4119]` blank line

### Separator

- `[EXCLUDE:L4120]` "---" section separator
- `[EXCLUDE:L4121]` blank line

### BC-X.16.002

- `[EXCLUDE:L4122]` heading line ("#### BC-X.16.002: ..."), no normative content
- `[EXCLUDE:L4123]` blank line
- `[EXCLUDE:L4124-4130]` Confidence/Subject/Source provenance metadata
- `[SCOPE:L4131-4140]` Behavior (split on first `=`; M1/M2 defined; EC-X.16.001-1 contrast)
- `[EXCLUDE:L4141]` blank line
- `[SCOPE:L4142-4145]` Condition/Behavior table: exit 64, `JrError::UserError` for both M1 (no `=`
  at all) and M2 (empty NAME), with M2's message required to be DISTINCT from M1's -- normative,
  owned by AC-005 (M1 row) and AC-006 (M2 row)
- `[EXCLUDE:L4146]` blank line
- `[SCOPE:L4147-4154]` pinned error messages: intro + M1 ("must be in NAME=VALUE format")
- `[SCOPE:L4155-4157]` pinned error messages: M2 ("NAME cannot be empty")
- `[SCOPE:L4158-4168]` distinguishing-substring invariant + clap attached-value delivery mechanics
  (the `{raw}` clap delivers to `parse_query_param`)
- `[SCOPE:L4169-4176]` Preconditions (one or more `-q` flags supplied; runs after
  `Config::load_with`/`JiraClient::from_config`; after `normalize_path`'s own errors)
- `[EXCLUDE:L4177]` blank line
- `[SCOPE:L4178-4189]` Postcondition 1 (pre-flight ordering)
- `[SCOPE:L4190-4195]` Postcondition 2 (`--output json` envelope, stderr-only)
- `[SCOPE:L4196-4199]` Postcondition 3 (all-or-nothing)
- `[EXCLUDE:L4200]` blank line
- `[EXCLUDE:L4201]` "**Invariants**:" heading line (P11-003: split from the prior merged
  L4201-4212 SCOPE entry so each invariant carries its own owning-AC citation)
- `[SCOPE:L4202-4205]` Invariant 1 (distinct M1/M2 messages) -- owned by AC-005 and AC-006
- `[SCOPE:L4206-4207]` Invariant 2 (empty VALUE never an error) -- owned by AC-005
- `[SCOPE:L4208-4212]` Invariant 3 (flag-order short-circuiting) -- owned by AC-007
- `[EXCLUDE:L4213]` blank line
- `[EXCLUDE:L4214]` "**Edge Cases**:" heading line
- `[SCOPE:L4215-4216]` EC-X.16.002-1 (`--query-param foo`, M1)
- `[SCOPE:L4217-4218]` EC-X.16.002-2 (`--query-param =v`, M2)
- `[SCOPE:L4219-4222]` EC-X.16.002-3 (second of two flags malformed)
- `[SCOPE:L4223-4230]` EC-X.16.002-4 (`-d @-` with `-q bad`, held-open stdin)
- `[SCOPE:L4231-4238]` EC-X.16.002-5 (`-q=v`)
- `[SCOPE:L4239-4243]` EC-X.16.002-6 (`-q==v`)
- `[SCOPE:L4244-4251]` EC-X.16.002-7 (`--query-param==v`)
- `[SCOPE:L4252-4275]` EC-X.16.002-8 (`-q -x=1`, clap exit 2)
- `[SCOPE:L4276-4291]` EC-X.16.002-9 (empty raw value, three forms)
- `[SCOPE:L4292-4298]` EC-X.16.002-10 (`-q` as last argv token, clap exit 2)
- `[SCOPE:L4299-4305]` EC-X.16.002-11 (non-UTF-8 `-q` value, clap exit 2, (U), no VP cell)
- `[EXCLUDE:L4306]` blank line
- `[EXCLUDE:L4307]` "**Verification Properties**:" heading line, shared by VP-API-QP-005/006; the
  intro that immediately follows (VP-API-QP-005(intro)) begins the next line and is in scope
- `[SCOPE:L4308-4316]` VP-API-QP-005(intro) (M1/M2 pinned messages, D1/D2 distinguishing substrings)
- `[SCOPE:L4317-4326]` VP-API-QP-005(1) (partition `proptest!`)
- `[SCOPE:L4327-4331]` VP-API-QP-005(2) (wiremock `-q foo`/`-q =v` cells + `--output json` envelope)
- `[SCOPE:L4332-4356]` VP-API-QP-005(3) (attached-form example cells, EC-5..10)
- `[SCOPE:L4357-4362]` VP-API-QP-005 fault-models
- `[SCOPE:L4363-4365]` VP-API-QP-006 intro (pre-flight ordering and all-or-nothing; "every mock
  `.expect(0)`")
- `[SCOPE:L4366-4367]` VP-API-QP-006(i) all-or-nothing
- `[SCOPE:L4368-4369]` VP-API-QP-006(ii) first-malformed-reported
- `[SCOPE:L4370-4384]` VP-API-QP-006(iii) before `resolve_body`
- `[SCOPE:L4385-4386]` VP-API-QP-006(iv) before `-H` parsing
- `[SCOPE:L4387-4389]` VP-API-QP-006 fault-models
- `[EXCLUDE:L4390]` blank line
- `[EXCLUDE:L4391-4394]` Trace section: bibliographic references, not itself a testable clause

Ownership is recorded solely by the CC-tag citations in each AC; coverage (every SCOPE line minus
EXCLUDE is inside some AC's CC-tag range) is verified mechanically per D-387.

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

### AC-001 (traces to BC-X.16.001 Behavior 1, Postcondition 2, EC-X.16.001-1/4/5/8/9/12/14)
`src/cli/api.rs::append_query_params(path: &str, pairs: &[(String, String)]) -> String` (new pure
function) implements BC-X.16.001 Behavior 1 `[CC:L3806-3822]` -- (P32-follow-up) (O) all sentences
observed by the separator-oracle `proptest!` (VP-API-QP-001(equation)) plus every AC-001 pinned
example below, all of which exercise this same assembly algorithm -- and Postcondition 2
`[CC:L3880-3891]` -- (O) all sentences observed by the same separator-oracle `proptest!` and pinned
examples, since Postcondition 2 is the formal restatement of the algorithm Behavior 1 describes --
in full; it also depends on Precondition 1 `[CC:L3869-3871]` (`<path>` is
already `normalize_path`-normalized) -- (systemic-sweep: this precondition is (N) not
runtime-observable -- enforced by `handle_api`'s existing, unmodified `normalize_path(&path)?`
call site preceding all `-q` handling, and by PR code review; no AC-001 cell can verify it, since
it is a caller obligation on the input, not a postcondition of `append_query_params` itself; no
dedicated test cell exists for it, and none is added) -- and Invariants 1
`[CC:L3903-3904]` (purity -- (N) not runtime-observable -- enforced by the signature stated
above, a synchronous fn with no `Result`/I/O-typed params, and structurally confirmed by every
AC-001 cell calling it directly with no `JiraClient`/wiremock; no dedicated assertion, and none is
added) and 4
`[CC:L3912-3915]` (guarantee scope: never a second `?`, never `&` after an empty/`&`-terminated
query component -- (P32-006) (O) observed by the separator-oracle `proptest!` and the EC-8 pinned
examples below; the "no blanket `?&`/`??` ban" half is (O) observed by the EC-9 pinned example
below, whose output legitimately contains `?&`), and owns Edge Cases EC-X.16.001-1 `[CC:L3918-3920]`
-- (O) all sentences observed by the P22-002 wire-half pinned example below (the only cell in this
story that checks `append_query_params`'s own assembly of an empty VALUE) --
(the wire half -- `append_query_params`'s own assembly of an empty VALUE; AC-005 owns the parse
half, via `parse_query_param`, see AC-005's own citation of this same clause), -4 `[CC:L3931-3932]`
-- (O) all sentences observed by the VP-API-QP-001(EC-4) pinned example --, -5 `[CC:L3933-3942]`
-- (O) the main sentence (query inserted before `#`, fragment reattached verbatim) is observed by
the VP-API-QP-001(EC-5) pinned example --
(the closing RFC 9112 §3.2 sentence -- fragments are never transmitted to the server -- is
(U) runtime-observable; no cell by design -- inherited reqwest/http request-target behavior; this
story's string-only function does not affect transmission; confirmed at PR code review; not
independently tested), -8
`[CC:L3950-3959]` -- (O) observed by the VP-API-QP-001(EC-8) pinned example (one test, both pinned
forms) --, -9 `[CC:L3960-3968]` -- (O) observed by the VP-API-QP-001(EC-9) pinned example --, -12
`[CC:L3978-3988]` -- (O) observed by the VP-API-QP-001(EC-12) pinned example --, and -14
`[CC:L3995-4000]` -- (O) observed by the VP-API-QP-001(EC-14) pinned example -- see
those clauses for the separator algorithm; this AC does not restate them and does not narrow them.
**Test (D-386 bind-by-reference):** Implements the VP-API-QP-001..004 shared preamble
`[CC:L4003-4006]` (purity statement -- (N) not runtime-observable -- same mechanism as Invariant 1
above; the middle sentence
naming VP-API-QP-002's argv cells as targeting the clap field declaration and `handle_api`'s
parsed-Vec hand-off to `append_query_params`, and VP-API-QP-003(e) as targeting the `--help`
text -- (O) observed by AC-002's argv cells and AC-003's `--help`
cell; `url::form_urlencoded::parse`
test-oracle-only note -- (N) not runtime-observable -- enforced by which module each test calls
it from (`#[cfg(test)] mod tests` vs. production code), confirmed at PR code review, no dedicated
assertion),
VP-API-QP-001's equation and strategy `[CC:L4007-4023]` -- (O) all sentences observed by the
separator-oracle `proptest!` plus the VP-API-QP-001(EC-4)/(EC-5)/(EC-8)/(EC-9) pinned examples this
clause itself names -- (pinned examples EC-X.16.001-4, -5, and
-8 (both forms) and -9), and VP-API-QP-001's pinned-examples
tail and fault-models `[CC:L4024-4031]` -- (O) all sentences observed collectively by the
VP-API-QP-001(empty-query-frag), VP-API-QP-001(EC-14), and VP-API-QP-001(EC-12) pinned examples
named below, plus the separator-oracle `proptest!` for the general fault-model coverage -- (pinned examples the empty-query-plus-fragment case
(verified: `cross-cutting.md` L4024-4025), -14, and -12; the fault models this AC's
own tests kill: the separator oracle `proptest!` kills the general `?`/`&`-swapped and
`ends_with`-boundary faults over its whole generated space, while the `/s?#f`
empty-query-plus-fragment pinned example specifically kills `find('?')` evaluated over the whole
path instead of `pre`, and the `/x&` + `k=v` (EC-X.16.001-14) pinned example specifically kills
the `&`-terminated test applied to the whole `pre` before the `?`-presence check; the fragment-
dropped-or-misplaced fault is killed by every pinned example carrying a `#fragment`, e.g. EC-5 and
the empty-query-plus-fragment case -- AC-001 is the sole owner of VP-API-QP-001, so no cross-AC
split applies here). Everything the cited
clause(s) specify is binding in its entirety and must be implemented exactly as written there;
this story does not restate or narrow any of it. **New direct-call pinned example (P22-002, closes
a real test gap):** `append_query_params("/x", &[("k".into(), "".into())]) == "/x?k="` -- the wire
half of Edge Case EC-X.16.001-1 `[CC:L3918-3920]` -- (O) observed by this very example, the AC's own
new P22-002 pinned-example test, same clause and mechanism already cited above -- (`k=`, empty
VALUE, allowed), computed directly
against Behavior 1's separator algorithm (path `/x` has no `?` in its pre-fragment part, so a
fresh leading `?` introduces the assembled query, per Postcondition 2(a)) and Postcondition
3/Behavior 3's exactly-once encoding (NAME and VALUE are each `urlencoding::encode`d once and
joined by a literal `=`, even when VALUE encodes to the empty string -- the `=` is never omitted
for an empty VALUE). This example is NOT one of VP-API-QP-001's own pinned examples (see
`[CC:L4007-4031]` above -- (O), already labeled above -- which does not include EC-X.16.001-1) --
it is a new cell this AC adds
directly against `append_query_params`, since no other owned cell in this story previously checked
EC-X.16.001-1's wire-assembly result (AC-005's own EC-X.16.001-1 citation covers only
`parse_query_param`'s parse half, not the wire output). All cells live in `src/cli/api.rs`'s
`#[cfg(test)]
mod tests`, grouped into ONE `proptest!` function (the separator oracle) plus 8 separate
`#[test]` functions -- one per pinned example, per Task 9's counting-unit rule (EC-1 (P22-002, new),
EC-4, EC-5,
empty-query-plus-fragment (no EC id of its own), EC-8 as ONE test covering both pinned forms,
EC-9, EC-12, EC-14). All 9 functions are RED at the Task 1 stub (`todo!()` panic).

### AC-002 (traces to BC-X.16.001 Behavior 2, Postcondition 4, EC-X.16.001-12/13)
The `-q`/`--query-param` clap field is a plain `Vec<String>` with `ArgAction::Append` and NO
`value_delimiter` (Behavior intro `[CC:L3797-3805]`) -- (O) this sentence observed by this AC's own
repeated-flags argv cell
(below), which is the runtime verification that each occurrence accumulates via `ArgAction::Append`
rather than overwriting. The same Behavior-intro clause also binds NO `allow_hyphen_values`
(P13-004: (O) observed by AC-009's EC-X.16.002-8 cell, not by this AC) and the ordering
requirement that assembly runs after `normalize_path` (P16-003: (N) not runtime-observable --
enforced by AC-001's Precondition 1 mechanism (the `normalize_path` call site preceding all `-q`
handling) plus Task 13's placement and PR code review, not by this AC) and before
`client.request(...)` (P13-004/P16-003: (N) not runtime-observable -- enforced by the
structural-placement mechanism AC-004 cites for BC-X.16.001 Invariant 2's ordering half, not by
this AC) -- all three are cross-references to their actual owning cells/mechanisms, not restated
or narrowed by this AC.
This AC implements BC-X.16.001 Behavior 2 `[CC:L3823-3825]` -- (O) all sentences observed by the
repeated-names `proptest!` oracle below -- and
Postcondition 4 `[CC:L3896-3897]` -- (O) all sentences observed by the same `proptest!` oracle,
corroborated by the repeated-flags argv cell -- in full, and owns Edge Case EC-X.16.001-13
`[CC:L3989-3994]` -- (O) observed by the EC-X.16.001-13 argv cell below --
see those clauses for the repeated-names semantics; this AC does not restate them and does not
narrow them.
**Test (D-386 bind-by-reference):** Implements VP-API-QP-002's oracle `[CC:L4032-4041]` -- (O) all
sentences observed by the repeated-names `proptest!` oracle --,
including its `existing == generated_existing_pairs` anti-vacuity generator constraint
`[CC:L4042-4048]` -- (O) observed by the same `proptest!` oracle's second, anti-vacuity assertion
--, its pinned decode example `[CC:L4049-4050]` -- (O) observed by the pinned decode example test
--, its argv cells for EC-X.16.001-13
`[CC:L4050-4054]` -- (O) observed by the EC-X.16.001-13 argv cell --, repeated flags
`[CC:L4055-4059]` -- (O) observed by the repeated-flags argv cell --, and mixed `[CC:L4059-4062]`
-- (O) observed by the mixed argv cell --, and its
fault-models `[CC:L4063-4069]` -- (O) all sentences observed collectively by the `proptest!` oracle
and the three argv cells named above, per the fault-kill discussion that follows -- (the fault models this AC's own tests kill: dedup-into-a-map and
last-wins/first-wins collapsing, a same-NAME override of the pre-existing pair, and reordering --
all killed by the repeated-names `proptest!` oracle's exact-equality assertion over its generated
space; `value_delimiter = ','` on the `-q` clap field -- killed by the EC-X.16.001-13 argv cell,
since that delimiter would split `fields=summary,status` into two args and fail the cell's
one-pair assertion; and `handle_api` forwarding only the first or last parsed pair, or
deduplicating the parsed `Vec` before the call -- killed by the repeated-flags argv cell, per the
clause's own attribution; AC-002 is the sole owner of VP-API-QP-002, so no cross-AC split applies
here). Everything the cited clause(s) specify is binding in its entirety
and must be implemented exactly as written there; this story does not restate or narrow any of
it. The `proptest!` oracle (including its generator-constraint/anti-vacuity assertion) and the
pinned decode example are ONE `proptest!` plus ONE `#[test]` in `src/cli/api.rs`'s
`#[cfg(test)] mod tests`; the three argv cells (EC-13, repeated-flags, mixed) are three separate
`#[tokio::test]` functions in `tests/api_query_param.rs`. All 5 functions are RED at the Task 1
stub.

### AC-003 (traces to BC-X.16.001 Behavior 3, Postcondition 3, EC-X.16.001-3/10/11)
`src/cli/api.rs::append_query_params` implements BC-X.16.001 Behavior 3 `[CC:L3826-3852]` -- (O)
the core encoding-exactly-once content of this clause is observed by the biased `proptest!`
((a)/(b)/(c)/(d)) below and by the `%20`/no-trim pinned examples; its rationale/comparison
sentences are separately labeled inline below -- and
Postcondition 3 `[CC:L3892-3895]` -- (O) observed by the same biased `proptest!` and pinned
examples, since Postcondition 3 is the formal restatement of Behavior 3's algorithm -- in full,
including the pinned `--help` substring requirement
`[CC:L3845-3852]` (P31-008, merged: Behavior 3's "Rationale, encoder-agnostic" sentence and its
comparisons to `gh api -f` and to `parse_header`'s trimming behavior are (N) not
runtime-observable -- enforced by PR code review, rationale/comparison prose, not independently
testable claims; the actual encoded-output behavior they explain is instead (O) observed by the
`%20` pinned example and the no-trim pinned examples below; no dedicated cell exists for the
comparisons themselves, and none is added. The L3845-3850 sentence -- that the clap help text for
`--query-param`/`-q` states plainly that values are passed raw and must not be pre-encoded by the
caller -- is (U) runtime-observable; no cell by design -- observable via `--help`;
VP-API-QP-003(e) pins only the literal substring `do not pre-encode` (the L3850-3852
pinned-substring sentence, which is (O) observed by AC-003's own `--help` cell below), so the
"values are passed raw" wording itself is not independently pinned by any test cell, and none is
added; the exact help text beyond that pinned substring is enforced at PR review); it also
depends on Invariant 3 `[CC:L3907-3911]` -- (O) observed by the (c) encoder-identity assertion
inside the biased `proptest!` below and its `*`->`%2A`/space->`%20` pinned examples -- (`urlencoding::encode` is the
intended encoder; `byte_serialize` forbidden), and owns Edge Cases EC-X.16.001-3
`[CC:L3924-3930]` -- (O) the main non-ASCII/UTF-8-percent-encoding content is observed by the
further-pinned `é`->`%C3%A9` example below --
(this range's closing sentence -- `url::form_urlencoded::parse` plays no role in
production encoding, used ONLY as a test-oracle decoder -- is (N) not runtime-observable --
enforced by test-module placement + PR code review, same mechanism as AC-001's preamble label), -10
`[CC:L3969-3973]` -- (O) observed by the (d) no-trim pinned examples below (NAME whitespace-only is
allowed, not empty) --, and -11 `[CC:L3974-3977]` -- (O) observed by the (d) no-trim pinned
examples below (VALUE leading/trailing whitespace not trimmed) -- see those clauses for the
encoding/no-trim/help-text rules; this AC does not restate them and does not narrow them.
**Test (D-386 bind-by-reference):** Implements VP-API-QP-003(intro) `[CC:L4070-4072]` -- (O) all
sentences observed by the biased `proptest!` (a)/(b)/(c)/(d) below --,
VP-API-QP-003(a) `[CC:L4073-4075]` -- (O) observed by the (a) round-trip assertion inside the
biased `proptest!` -- whose round-trip assertion requires `encode(v)` to be the
NAME/VALUE segment extracted from `append_query_params`'s own output, NOT a direct
`urlencoding::encode` call (a direct call would be tautological and GREEN at the Task 1 stub) --
VP-API-QP-003(b) `[CC:L4076-4077]` -- (O) observed by the (b) alphabet assertion --,
VP-API-QP-003(c) `[CC:L4078-4080]` -- (O) observed by the (c) encoder-identity assertion and its
two pinned examples --, VP-API-QP-003(d)
`[CC:L4081-4083]` -- (O) observed by the (d) no-trim assertion and its two pinned examples -- (whose no-trim examples also run through `parse_query_param`, VP-API-QP-005),
VP-API-QP-003(e) `[CC:L4084-4087]` -- (O) observed by the (e) `--help` cell below --,
VP-API-QP-003(further-pinned) `[CC:L4087-4089]` -- (O) observed by the four further-pinned
examples (`%`->`%25`, `+`->`%2B`, `é`->`%C3%A9`, literal `%25`->`%2525`) --, and
VP-API-QP-003(fault-models) `[CC:L4089-4091]` -- (O) all sentences observed collectively by the
biased `proptest!` and its pinned examples, per the fault-kill discussion that follows -- (the fault models this AC's own tests kill: no
encoding and double encoding -- both killed by the (a) round-trip assertion (and no encoding also
by the (b) alphabet assertion); `byte_serialize` substituted for `urlencoding::encode` -- killed
by the (c) encoder-identity assertion and its `*`->`%2A`/space->`%20` pinned examples (both of
which `byte_serialize` gets wrong); the `=` joiner itself encoded -- killed by the same (c)
encoder-identity assertion, whose `format!("{}={}", ...)` shape pins a literal, unencoded `=`; NAME
or VALUE trimmed -- killed by the (d) no-trim pinned examples; and the "do not pre-encode" help
phrase dropped or reworded -- killed by the (e) `--help` cell; AC-003 is the sole owner of
VP-API-QP-003, so no cross-AC split applies here). Everything the cited clause(s) specify is binding
in its entirety and must be implemented exactly as written there; this story does not restate or
narrow any of it. The
biased `proptest!` ((a)/(b)/(c)/(d)) plus one `#[test]` per further-pinned/(c)/(d) example, per
Task 9's counting-unit rule ((c)'s `*`->`%2A` and space->`%20`; (d)'s two no-trim examples;
further-pinned `%`->`%25`, `+`->`%2B`, `é`->`%C3%A9`, literal `%25`->`%2525` -- 8 pinned-example
`#[test]`s total), live in `src/cli/api.rs`'s `#[cfg(test)] mod tests`; the (e) `--help` cell is
a separate `#[test]` in `tests/api_query_param.rs` (a `--help` cell needs no async runtime -- no
wiremock -- so it is a plain sync `#[test]`). All
9 direct-call functions plus the 1 subprocess function are RED at the Task 1 stub.

### AC-004 (traces to BC-X.16.001 Behavior 4/5, Postconditions 1/5, EC-X.16.001-6/7)
`src/cli/api.rs::append_query_params` implements BC-X.16.001 Behavior 4 `[CC:L3853-3857]` -- (O)
observed by the table-driven method-orthogonality wiremock test below -- and
Behavior 5 `[CC:L3858-3863]` -- (O) observed by the zero-flag identity `proptest!` and the two
zero-flag wiremock examples below --, and Postconditions 1 `[CC:L3876-3879]` -- (O) observed by
the same zero-flag identity `proptest!` and wiremock examples, since Postcondition 1 is Behavior
5's formal restatement -- and 5 `[CC:L3898-3900]` -- (O) observed by the table-driven
method-orthogonality wiremock test's request-body/query-pair assertions -- in
full; it also depends on Precondition 2 `[CC:L3872-3873]` (systemic-sweep: (N) not
runtime-observable -- no AC-004 cell verifies this precondition directly; its well-formed-value
half is a test-fixture-construction assumption (AC-004's own cells supply only well-formed
pairs), enforced by test-fixture construction plus PR code review). **(P17-001
correction:** its "evaluated BEFORE this BC's assembly step runs" ordering half is (N) not
runtime-observable, NOT verified by AC-008's tests -- AC-008's VP-API-QP-006(iii)/(iv) cells (O)
observe ordering only relative to `resolve_body`/`-H` parsing, not relative to
`append_query_params` internally, so they cannot observe this half. The actual mechanism:
`append_query_params`'s own signature (`pairs: &[(String, String)]`, already-parsed pairs, no
`raw: &str` input of its own) forces `parse_query_param`'s `.collect::<Result<Vec<_>>>()?` over
every `-q` flag to finish first and short-circuit on the first error before
`append_query_params` is ever called (Task 11/13 design) -- a signature/type-flow fact, enforced
by PR code review; reinforced by AC-007's all-or-nothing cells, which prove no request is ever
sent when any value is malformed, though those cells likewise do not observe internal call
ordering directly. No dedicated AC-004 test cell exists for this ordering half, and none is
added.) and Invariant 2 `[CC:L3905-3906]` (runs strictly before the `RequestBuilder` is built) --
**(P16-003 classification:** (a) the table-driven method-orthogonality wiremock test (this AC's
own **Test:** cell) is (O) the observing cell that verifies the assembled query is independent
of the request body and that the body itself is left unmutated by query assembly; (b) the
"before the `RequestBuilder`/headers are built" ordering half is (N) not runtime-observable --
enforced by structural placement (Task 13's call-site ordering, immediately after
`normalize_path` and before `resolve_body`/`-H` parsing) plus PR code review, not by a dedicated
runtime assertion; (c) **(P17-001)** the "never mutates ... headers" half is (N) not
runtime-observable -- it has its own mechanism, distinct from (a)'s body check:
`append_query_params`'s signature takes no header parameter at all (only `path: &str`
and `pairs: &[(String, String)]`), so it structurally cannot touch headers -- confirmed at PR code
review, which is this AC's own enforcement mechanism for this sub-clause (see also holdout
`H-CYCLE14-W2-INT-001` in `wave-holdout-scenarios.md`, which independently asserts the received
request retains its `X-Custom: 1` header unaffected by `-q` -- provenance only, cited for
cross-reference; `wave-holdout-scenarios.md` is not one of this story's `inputs:` and this AC does
not rely on it),
and owns Edge Cases EC-X.16.001-6
`[CC:L3943-3945]` -- (O) observed by the table-driven method-orthogonality wiremock test's `-X`
parameterization -- and -7 `[CC:L3946-3949]` -- (O) observed by the zero-flag identity `proptest!`
and the two zero-flag wiremock examples -- see those clauses for the method-orthogonality and
zero-flag-identity rules; this AC does not restate them and does not narrow them. This AC also
owns the no-regression guarantee that existing `jr api` behavior for BC-X.1.007 (raw-passthrough
of the response) and BC-X.1.011 (`-X`/`--method` case-insensitivity) is unaffected by this BC
`[CC:L3865-3866]` -- (O) all sentences observed by the pre-existing, unmodified tests named just
below, not by this AC's own new cells -- **(P11-002 correction: the table-driven method-orthogonality wiremock test
below is NOT this guarantee's verification vehicle -- it exercises only canonical-case methods and
never asserts stdout.)** The actual verification vehicle is the unmodified, pre-existing
`tests/cli_handler.rs` suite this story's Task 10(c)/Task 14 already require to stay green both
before and after this story (see also holdout anchor `H-CYCLE14-W2-REG-001`, which independently
names the same suite as MUST-PASS in `wave-holdout-scenarios.md` -- provenance only; that file is
not one of this story's `inputs:` and this AC does not rely on it):
`test_handler_api_stdout_byte_exact` (byte-exact raw-passthrough, BC-X.1.007) and
`test_parse_api_method_uppercase_delete_dispatches_http_delete`,
`test_parse_api_method_lowercase_delete_dispatches_http_delete`, and
`test_parse_api_method_mixedcase_delete_dispatches_http_delete` (`-X`/`--method` case-insensitivity,
BC-X.1.011). This AC does not restate BC-X.1.007/BC-X.1.011 themselves, only cites that they
remain unaffected, and adds no new test cell for this guarantee.
**Test (D-386 bind-by-reference):** Implements VP-API-QP-004(structural) `[CC:L4092-4098]` -- (O)
observed by the table-driven method-orthogonality wiremock test, per the Ownership paragraph below
--,
VP-API-QP-004(1) `[CC:L4098-4101]` -- (O) observed by the zero-flag identity `proptest!` --,
VP-API-QP-004(2) `[CC:L4101-4106]` -- (O) observed by the two zero-flag wiremock examples --, and
VP-API-QP-004(fault-models) `[CC:L4106-4108]` -- (O) all sentences observed collectively by the
table-driven wiremock test, the zero-flag identity `proptest!`, and the two zero-flag wiremock
examples, per the fault-kill discussion that follows -- (the fault models this AC's own tests kill: a `?`
(or `&`) appended on zero pairs, and the path re-encoded on zero pairs -- all three killed jointly
by the zero-flag identity `proptest!` (1) and the zero-flag wiremock examples (2); the fragment
dropped on zero pairs -- killed by (1) ONLY, not jointly: (1)'s own generator is pinned
(`[CC:L4099-4101]` -- (O) this generator-pin sentence is itself observed by the same zero-flag
identity `proptest!` --) to include paths carrying a `#fragment` ("including paths with an existing
query, a trailing `?` or `&`, and a `#fragment`"), so it can and does exercise this fault; (2)'s
two zero-flag wiremock examples (`[CC:L4102-4106]` -- (O) this argv-pin sentence is itself observed
by the same two zero-flag wiremock examples --, `jr api rest/api/3/myself` and `jr api
"/rest/api/3/search?jql=a&"`) carry no `#fragment` at all -- verified against `cross-cutting.md`
L4103-4105 -- so neither could observe a dropped fragment even if the fault were present; a
fragment is in any case never transmitted to the server (RFC 9112 §3.2), so this is not a gap in
(2)'s coverage, merely a fixture that cannot exercise this particular fault; query assembly gated
on the method, and `-d` content merged into the query -- both killed by
the table-driven method-orthogonality wiremock test's per-method query-pair and request-body
assertions; AC-004 is the sole owner of VP-API-QP-004, so no cross-AC split applies here).
Everything the cited clause(s) specify is binding
in its entirety and must be implemented exactly as written there; this story does not restate or
narrow any of it.
**Ownership (P9-003; P10-003 -- clause cited by reference only, not restated):**
VP-API-QP-004(structural) `[CC:L4092-4098]` -- (O), already labeled above -- a signature fact (`append_query_params` takes no
method/body parameter) -- is owned by the table-driven method-orthogonality wiremock test (one
`#[tokio::test]` parameterized internally over all 5 methods x with/without `-d`, per Task 9's
one-function-per-scenario rule), a `#[tokio::test]` function in `tests/api_query_param.rs`; see
that clause for its full runtime-check requirements (the request-body assertion, the
identical-received-query-pairs-per-method assertion, and the query-never-in-body assertion) --
this AC does not restate or narrow any of them. VP-API-QP-004(1) (zero-flag identity) is a
SEPARATE `proptest!` function in `src/cli/api.rs`'s `#[cfg(test)] mod tests`; VP-API-QP-004(2)
(the two zero-flag wiremock examples) are `#[tokio::test]` functions in `tests/api_query_param.rs`.
RED/GREEN classification: the table-driven test and the identity `proptest!` are RED at the Task
1 stub; the 2 zero-flag wiremock examples are GREEN-nonexempt (`PRE-EXISTING-BEHAVIOR`, Task
10(a2)).

### AC-005 (traces to BC-X.16.002 Behavior, EC-X.16.002-1, EC-X.16.001-1, EC-X.16.001-2)
`src/cli/api.rs::parse_query_param(raw: &str) -> Result<(String, String)>` (new pure function,
distinct from `append_query_params`) implements BC-X.16.002's Behavior `[CC:L4131-4140]` -- (O)
observed by the partition `proptest!` below -- and its
Condition/Behavior table's M1 row `[CC:L4142-4145]` -- (O) observed by the same partition
`proptest!`'s M1 case and by AC-009's own `-q foo`-equivalent attached-form cells -- in full,
including the pinned M1 error message
`[CC:L4147-4154]` -- (O) the pinned message text itself is observed by the partition `proptest!`'s
per-case exact-message assertion and by this AC's own `-q foo` wiremock cell below -- (Behavior's closing "structurally mirrors `parse_header`'s existing `Key: Value`
pre-flight validator" sentence is (N) not runtime-observable -- enforced by PR code review, a
design-precedent comparison, not an independently testable claim; `parse_header`'s own behavior is
pre-existing and unmodified by this story, and is not re-verified by any AC-005 cell; no dedicated
cell exists for it, and none is added), and owns Edge Cases EC-X.16.002-1
`[CC:L4215-4216]` -- (O) observed by this AC's own `-q foo` wiremock cell below --,
EC-X.16.001-1 `[CC:L3918-3920]` -- (O) the parse half is observed by VP-API-QP-005(1)'s
`Ok((NAME, rest))` partition case below, where `rest` may be empty; AC-001 owns the wire half --,
and EC-X.16.001-2 `[CC:L3921-3923]` -- (O) observed by the partition `proptest!`'s
`=`-containing-VALUE cell -- see
those clauses for the split-on-first-`=` / M1 rules; this AC does not restate them and does not
narrow them. Postcondition 1 (pre-flight ordering) is NOT this AC's -- it is owned solely by
AC-008 (lines 4178-4189) (see AC-008's citations below); this AC's concern is the taxonomy
`parse_query_param` produces, not when it runs. This AC also owns BC-X.16.002 Invariant 1
(distinct M1/M2 messages) `[CC:L4202-4205]` -- (O) observed by the partition `proptest!`'s
per-case exact-message/distinguishing-substring assertions -- and Invariant 2 (empty VALUE never an error)
`[CC:L4206-4207]` -- (O) observed by VP-API-QP-005(1)'s `Ok((NAME, rest))` partition case, where
`rest` may be empty -- (P11-003) -- see those clauses for the exact message-distinctness and
empty-VALUE rules; this AC does not restate them and does not narrow them.
**Test (D-386 bind-by-reference):** Implements VP-API-QP-005(intro) `[CC:L4308-4316]` -- (O) all
sentences observed by the partition `proptest!` and this AC's own `-q foo` wiremock cell below,
which consume the M1/D1 terms this clause defines --,
VP-API-QP-005(1) `[CC:L4317-4326]` -- (O) observed by the partition `proptest!` itself -- whose `Err`-case "other substring absent" assertion is
filtered with `prop_assume!` to `raw` values that do not themselves contain D1 or D2 -- and, for
its `-q foo` wiremock cell, VP-API-QP-005(2) `[CC:L4327-4331]` -- (O) observed by this AC's own `-q
foo` wiremock cell --. Also implements VP-API-QP-005(fault-models)
`[CC:L4357-4362]` -- (O) all sentences observed collectively by the partition `proptest!` and this
AC's own `-q foo` wiremock cell, per the fault-kill discussion that follows -- (P22-001: the fault models this AC's own tests kill: swapped M1/M2 and the
one-shared-generic-message fault -- both killed by the partition `proptest!`'s per-case
exact-message/distinguishing-substring assertions, corroborated by this AC's own `-q foo`
wiremock cell; `{raw}` replaced by a trimmed or re-split value -- killed by the proptest's
byte-for-byte `raw` assertion, relying on Task 6's requirement that the M1/M2 `raw` strategy be
able to produce leading/trailing whitespace (without that pin, the generator could omit a
whitespace-padded `raw` entirely and never exercise a trimming fault); split on the last `=`
instead of the first -- killed by the proptest's `=`-containing-VALUE cell (EC-X.16.001-2),
relying on Task 6's requirement that the VALUE/`rest` strategy be able to produce strings
containing one or more `=` characters, whose `rest` keeps every later `=`; NAME
trimmed before the empty check -- killed by the proptest's whitespace-only-NAME cell
(EC-X.16.001-10); and an empty-NAME check evaluated before the missing-`=` check -- killed by the
pinned `parse_query_param("")` example. This AC's tests kill at least the six faults enumerated
above. The remaining two faults in this clause -- the JSON envelope written to stdout instead of
stderr, and `allow_hyphen_values` set on `-q` -- are primarily killed by AC-006's `--output json`
envelope cell and AC-009's EC-X.16.002-8 cell respectively (verified: none of this AC's own cells
invoke `--output json`, and none supply a hyphen-leading argv token, so this AC's own cells cannot
observe either fault). Everything the cited clause(s)
specify is binding in its entirety and must be implemented exactly as written there; this story
does not restate or narrow any of it. The partition `proptest!` plus the pinned
`parse_query_param("")` example are direct-call functions (one `proptest!` + one `#[test]`) in
`src/cli/api.rs`'s `#[cfg(test)] mod tests`; the `-q foo` wiremock cell is a separate
`#[tokio::test]` in `tests/api_query_param.rs`. All three are RED at the Task 1 stub.

### AC-006 (traces to BC-X.16.002 Behavior, Postcondition 2, EC-X.16.002-2)
`src/cli/api.rs::parse_query_param` implements BC-X.16.002's Behavior paragraph (M2 empty-NAME
case) `[CC:L4131-4140]` -- (O) observed by this AC's own `-q =v` (M2) wiremock cell below -- and its
Condition/Behavior table's M2 row `[CC:L4142-4145]` -- (O) observed by the same `-q =v` (M2)
wiremock cell --, the pinned
M2 error message `[CC:L4155-4157]` -- (O) observed by the M2 wiremock cell's exact-message
assertion --, and Postcondition 2 `[CC:L4190-4195]` in full (Postcondition 2's
"Per `src/main.rs`'s top-level error handler (~lines 132-140), this envelope is written via
`eprintln!`" sentence is (N) not runtime-observable -- enforced by PR code review, an
implementation-location citation; the observable stdout-empty/stderr-JSON split this sentence
describes IS (O) observed by this AC's own envelope cell, below; and Postcondition 2's closing
"same channel every other `jr` pre-flight/runtime error uses... not a taxonomy-specific choice"
sentence is likewise (N) not runtime-observable -- enforced by PR code review, a
repo-wide-convention citation outside this story's own test scope; no dedicated cell exists for
either citation sentence beyond the envelope cell already noted, and none is added), and owns Edge
Case
EC-X.16.002-2 `[CC:L4217-4218]` -- (O) observed by this AC's own `-q =v` (M2) wiremock cell -- see those clauses for the pinned M2 message and
`--output json` envelope rules; this AC does not restate them and does not narrow them. This AC
also owns BC-X.16.002 Invariant 1 (distinct M1/M2 messages) `[CC:L4202-4205]` -- (O) observed by
AC-005's partition `proptest!`, corroborated by this AC's own M2 wiremock cell -- (P11-003) -- see
that clause for the exact message-distinctness rule; this AC does not restate or narrow it. An
empty VALUE (`k=`) remains ALLOWED per BC-X.16.001 EC-X.16.001-1 (lines 3918-3920), never M2 --
(O) observed by AC-005's VP-API-QP-005(1) `Ok((NAME, rest))` partition where rest may be empty.
**Test (D-386 bind-by-reference):** Implements VP-API-QP-005(intro) `[CC:L4308-4316]` -- (O) all
sentences observed by this AC's own M2 wiremock cell and `--output json` envelope cell below,
which consume the M2/D2 terms this clause defines -- and
VP-API-QP-005(2) `[CC:L4327-4331]` -- (O) observed by the M2 wiremock cell and the `--output json`
envelope cell --. Also implements VP-API-QP-005(fault-models) `[CC:L4357-4362]` -- (O) all
sentences observed collectively by this AC's own M2 wiremock cell and `--output json` envelope
cell, per the fault-kill discussion that follows --
(P22-001, corrected P24-001: the fault models this AC's own tests kill at least: the JSON envelope
written to stdout instead of stderr -- killed by this AC's `--output json` envelope cell, which
asserts the `{"error","code"}` payload appears on stderr and stdout is empty; and, also killed by
this AC's own `-q =v` (M2) wiremock cell (not exclusively by AC-005's cells): swapped M1/M2 and the
one-shared-generic-message fault -- the M2 cell's exact-message/distinguishing-substring assertion
(D2 present, D1 absent) fails under either fault, corroborating AC-005's `-q foo` (M1) cell and
partition `proptest!`, which remain the primary owners of these two faults. The remaining five
faults in this clause -- `{raw}` replaced by a trimmed or re-split value, split on the last `=`
instead of the first, NAME trimmed before the empty check, and an empty-NAME check evaluated
before the missing-`=` check -- are primarily killed by AC-005's proptest and pinned example, and
`allow_hyphen_values` set on `-q` is primarily killed by AC-009's EC-X.16.002-8 cell; see their
Test lines). Everything the cited clause(s) specify is binding in its
entirety and must be implemented exactly as written there; this story does not restate or narrow
any of it. The
wiremock `-q =v` cell, and the `--output json` envelope cell (ONE `#[tokio::test]` asserting both
the M1 and M2 envelope shapes, per the pass-5 fix), are `#[tokio::test]` functions in
`tests/api_query_param.rs`. Both are RED at the Task 1 stub.

### AC-007 (traces to BC-X.16.002 Postcondition 3, Invariant 3, EC-X.16.002-3)
`handle_api`'s `-q` validation implements BC-X.16.002 Postcondition 3 `[CC:L4196-4199]` -- (O) the
main all-or-nothing content is observed by the all-or-nothing cells below (VP-API-QP-006(i)) --
(its
closing "consistent with `parse_header`'s existing `.collect::<Result<Vec<_>>>()` all-or-nothing
pattern" sentence is (N) not runtime-observable -- enforced by PR code review, a
design-precedent comparison, not independently tested by this AC's cells; `parse_header`'s own
pattern is pre-existing and unmodified) and its
Invariant 3 (flag-order short-circuiting) `[CC:L4208-4212]` -- (O) the main first-malformed-reported
content is observed by the first-malformed-reported cells below (VP-API-QP-006(ii)) -- (P11-003: narrowed from the prior
merged L4201-4212 range -- Invariants 1 and 2 are (O) observed by AC-005's/AC-006's tests,
not this AC's; Invariant 3's own closing "applied at an EARLIER point in `handle_api`'s pipeline
(before `resolve_body`, not after)" sentence is (O) observed by AC-008's
VP-API-QP-006(iii) held-open-stdin cell, not by this AC's own all-or-nothing/first-malformed-reported
cells) in full, and owns Edge Case EC-X.16.002-3 `[CC:L4219-4222]` -- (O) observed by the
first-malformed-reported cells below -- see those clauses
for the all-or-nothing / first-malformed-reported rules; this AC does not restate them and does
not narrow them.
**Test (D-386 bind-by-reference):** Implements VP-API-QP-006(i) `[CC:L4366-4367]` -- (O) observed
by the two all-or-nothing cells below --,
VP-API-QP-006(ii) `[CC:L4368-4369]` -- (O) observed by the two first-malformed-reported cells below
--, VP-API-QP-006(fault-models) `[CC:L4387-4389]` -- (O) all sentences observed collectively by
these four cells, per the fault-kill discussion that follows -- (P23-002: the
fault models this AC's tests kill: per-flag filtering that drops bad values instead of failing --
killed by the all-or-nothing cells' zero-request assertion, and last-vs-first reporting -- killed
by the first-malformed-reported cells' flag-order assertion; the remaining ordering fault, `-q`
parsing moved after `resolve_body` or after `parse_header`, is primarily killed by AC-008's (iii)/(iv)
cells (verified: none of this AC's own four cells hold stdin open or supply a `-H` flag, so they
cannot observe an ordering fault relative to `resolve_body`/`-H` parsing)), the
VP-API-QP-006 intro `[CC:L4363-4365]` -- (O) observed by this AC's own four cells, each of which
asserts zero-HTTP via a `.expect(0)` counter-mock -- (its own "every mock `.expect(0)`" requirement), and
VP-API-QP-005(intro) `[CC:L4308-4316]` -- (O) observed by this AC's own first-malformed-reported
cells, which report outcomes in the M1/M2/D1/D2 terms this clause defines -- (P9-004: VP-API-QP-006(ii) reports outcomes in terms of
M1/M2 and D1/D2, which VP-API-QP-005(intro) defines; cited here so that definition is binding for
this AC too). Everything the cited clause(s) specify is binding in its entirety and must be
implemented exactly as written there; this story does not restate or narrow any of it. All 4
cells (2 all-or-nothing, 2 first-malformed-reported) are separate `#[tokio::test]`
functions in `tests/api_query_param.rs`. All 4 are RED at the Task 1 stub.

### AC-008 (traces to BC-X.16.002 Postcondition 1, D-188 pre-flight convention, EC-X.16.002-4)
`handle_api` (`src/cli/api.rs`) implements BC-X.16.002 Preconditions `[CC:L4169-4176]` and
Postcondition 1 `[CC:L4178-4189]` in full, and owns Edge Case EC-X.16.002-4 `[CC:L4223-4230]` --
(O) observed by the (iii) held-open-stdin cell below --
see those clauses for the exact pre-flight insertion point and ordering; this AC does not restate
them and does not narrow them. **(P17-001: Postcondition 1's own lead sub-clause -- that a
malformed value is caught by `parse_query_param` BEFORE `append_query_params` touches
`normalize_path`'s output, BEFORE any query string is assembled -- is (N) not
runtime-observable, NOT verified by this AC's own VP-API-QP-006(iii)/(iv) cells, which (O)
observe ordering only relative to `resolve_body`/`-H` parsing (the clause's own "AND -- per
D-188's convention -- BEFORE `resolve_body` ... and BEFORE `-H`/`--header` parsing" half, which
those two cells DO observe), not relative to `append_query_params` internally. The actual
mechanism for the `append_query_params`-ordering half: `append_query_params`'s signature takes
already-parsed `pairs: &[(String, String)]`, so `parse_query_param`'s
`.collect::<Result<Vec<_>>>()?` over every `-q` flag (Task 11/13 design) must finish, error-free,
before `append_query_params` can be called at all -- a signature/type-flow fact, enforced by PR
code review; reinforced by AC-007's all-or-nothing cells proving no request is ever sent when
any value is malformed. No dedicated AC-008 test cell exists for this sub-clause, and none is
added.)** (P13-004: the Preconditions clause's first sentence -- that zero
`-q` flags means no parsing occurs at all, nothing to validate -- is (O) observed by AC-004's
VP-API-QP-004(2) zero-flag wiremock examples, not by an AC-008 cell; that sentence itself cites
BC-X.16.001 Postcondition 1, which AC-004 owns. No dedicated AC-008 test cell exists for it, and
none is added.) (P11-004, relabeled P32-004: the Preconditions clause's final sentence -- that
`src/cli/api.rs::normalize_path`'s own errors (empty path, absolute URL) run BEFORE `-q`
validation -- is (U) runtime-observable; no cell by design -- it is observable via which error
message reaches stderr (the pre-existing path error vs. an M1/M2 taxonomy message) when a
malformed path and a malformed `-q` value are supplied together; no test in this story constructs
that combined input, so no dedicated test cell exists for it, and none is added; the correct
ordering is instead achieved by Task 13's placement of the `-q` pre-flight step immediately after
`normalize_path`, confirmed at PR code review.) (P12-003, relabeled D-389: the Preconditions clause's middle sentence -- that
`-q` validation runs only after `Config::load_with` and `JiraClient::from_config` succeed in
`src/main.rs`'s `Command::Api` dispatch arm, and that those two calls plus
`config::validate_profile_name` all preempt this BC's exit-64 -- is (U) runtime-observable; no
cell by design -- structurally forced by `src/main.rs`'s `Command::Api` arm running config/client
construction before `handle_api`; verified against `src/main.rs` ~L499-501, where
`Config::load_with` and `JiraClient::from_config` both execute before the
`cli::api::handle_api(...)` call on the next line; no AC-008 cell verifies this directly, since
every AC-008 cell supplies valid auth and never exercises a config/client-construction failure
path, so no dedicated test cell exists for it, and none is added.)
**Test (D-386 bind-by-reference):** Implements VP-API-QP-006(iii) `[CC:L4370-4384]` -- (O) observed
by the (iii) held-open-stdin cell itself, below --,
VP-API-QP-006(iv) `[CC:L4385-4386]` -- (O) observed by the (iv) before-`-H` cell below --,
VP-API-QP-006(fault-models) `[CC:L4387-4389]` -- (O) all sentences observed collectively by the
(iii) and (iv) cells, per the fault-kill discussion that follows -- (P23-002: the
fault models this AC's tests kill: the ordering fault -- `-q` parsing moved after `resolve_body`
or after `parse_header` -- killed jointly by the (iii) held-open-stdin cell and the (iv)
before-`-H` cell, and per-flag filtering that drops bad values instead of failing -- also killed
by the (iii) cell, since a single malformed `-q bad` value silently filtered rather than failing
would let control flow reach `resolve_body`'s blocking stdin read instead of exiting promptly; the
remaining last-vs-first-reporting fault is primarily killed by AC-007's first-malformed-reported
cells (verified: this AC's own two cells each supply exactly one malformed `-q` value, never two,
so neither can observe a last-vs-first preference)), the
VP-API-QP-006 intro `[CC:L4363-4365]` -- (O) observed by this AC's own two cells, each of which
asserts zero-HTTP via a `.expect(0)` counter-mock -- (its own "every mock `.expect(0)`" requirement), and
VP-API-QP-005(intro) `[CC:L4308-4316]` -- (O) observed by the (iii) cell (asserts on D1) and the
(iv) cell (reports M1), both of which consume the terms this clause defines -- (P9-004: VP-API-QP-006(iii) asserts on D1, and (iv) reports
M1 -- both terms VP-API-QP-005(intro) defines; cited here so that definition is binding for this
AC too). Everything the cited clause(s) specify is binding in its entirety and must be
implemented exactly as written there; this story does not restate or narrow any of it. The (iii)
held-open-stdin cell is a `#[tokio::test]` in `tests/api_query_param.rs` spawned via
`std::process::Command` (not `assert_cmd`, per the clause's own rationale for why that library
cannot be used here) with a held-open `ChildStdin` handle, polling `try_wait()` against the
clause's own deadline; the (iv) before-`-H` cell is a separate `#[tokio::test]` in the same file.
Both are RED at the Task 1 stub.

### AC-009 (traces to BC-X.16.002 Edge Cases EC-X.16.002-5..10; EC-X.16.002-11 (U), no VP cell)
Clap's own attached-form and missing-value parsing governs EC-X.16.002-5..10: EC-5
`[CC:L4231-4238]` -- (O) observed by this AC's own EC-5 attached-form cell --, EC-6 `[CC:L4239-4243]`
-- (O) observed by this AC's own EC-6 attached-form cell --, EC-7 `[CC:L4244-4251]` -- (O) observed
by this AC's own EC-7 attached-form cell --, and EC-9 `[CC:L4276-4291]` -- (O) observed by this
AC's own EC-9 attached-form cell -- are
fed through to `parse_query_param`, while EC-8 `[CC:L4252-4275]` -- (O) the main clap-rejection
content is observed by this AC's own EC-8 attached-form cell -- and EC-10 `[CC:L4292-4298]` -- (O)
observed by this AC's own EC-10 attached-form cell -- are
rejected by clap itself before `parse_query_param` ever runs -- this AC does not restate those
outcomes and does not narrow them. (EC-8's own text also describes three hyphen-leading-NAME
workaround forms -- `-q=-x=1`, `-q-x=1`, `--query-param=-x=1` -- and a contrasting
hyphen-leading-VALUE case, `-q startAt=-1`/`-q jql=-x`, that "works as-is": neither is exercised by
a dedicated cell -- this AC's own EC-8 cell tests only the failing `-q -x=1` form. Both are (U)
runtime-observable; no cell by design -- a structural consequence of the same clap attached-value
mechanics EC-5/EC-6/EC-7's cells already exercise, confirmed at PR code review; no dedicated cell
exists for either, and none is added. The same EC-8 range's `-H`/`--header` precedent sentence
(~L4259-4262) -- that a hyphen-leading `-H` value (e.g. `-H -x: 1`) fails identically at the clap
level -- is (P32-003 correction) (U) runtime-observable; no cell by design -- it is observable as
clap exit 2, the same class of rejection this AC's own EC-8 cell observes for `-q`, applied instead
to the pre-existing, unmodified `-H` field; no test in this story or the pre-existing suite
exercises it (grep-verified: no `tests/` cell passes a hyphen-leading `-H` value), so no dedicated
cell exists for it, and none is added. Its closing "no quoting workaround, shell strips quotes"
sentence (~L4270-4272) is (N) not runtime-observable -- enforced by the
pre-existing `-H` declaration (`src/cli/mod.rs`'s `header` field, `#[arg(short = 'H', long =
"header")]` / `header: Vec<String>` at lines 147-148, verified to have no `allow_hyphen_values`)
plus shell semantics, confirmed at PR code review; no dedicated cell exists or is added.) This AC also owns the distinguishing-substring invariant and
clap attached-value delivery mechanics `[CC:L4158-4168]` -- (O) all sentences observed collectively
by the EC-5/EC-6/EC-7/EC-9 attached-form cells above, all of which exercise exactly this `{raw}`
delivery mechanism -- (the `{raw}` value clap delivers to
`parse_query_param`). The `-q`/`--query-param` flag is NOT declared with `allow_hyphen_values`.
EC-X.16.002-11 `[CC:L4299-4305]` is (U) runtime-observable; no cell by design -- inherited clap
behavior with no owning VP cell (same treatment as EC-X.14.001-14); constructing a non-UTF-8 `-q`
argv value in a portable, testable way is impractical, so no dedicated cell exists for it --
recorded for traceability, no test obligation.
**Test (D-386 bind-by-reference):** Implements VP-API-QP-005(3) `[CC:L4332-4356]` -- (O) all
sentences observed collectively by the EC-5/EC-6/EC-7/EC-8/EC-9/EC-10 attached-form cells --,
VP-API-QP-005(fault-models) `[CC:L4357-4362]` -- (O) all sentences observed collectively by these
same six cells, per the fault-kill discussion that follows -- (P22-001, corrected P24-001: the fault models THIS
AC's own attached-form cells kill at least: `allow_hyphen_values` set on `-q` -- killed by the
EC-X.16.002-8 cell (`-q -x=1`), whose pass requires clap to reject the hyphen-leading value rather
than accept it as `-q`'s VALUE -- and, jointly with AC-005's proptest, `{raw}` replaced by a
trimmed or re-split value -- these cells feed `{raw}` through real argv (e.g. `-q=v` -> raw `v`,
`-q==v` -> raw `=v`), corroborating the proptest's byte-for-byte assertion with the attached-value
forms clap actually produces. The EC-5/EC-6/EC-7 cells also kill swapped M1/M2 and the
one-shared-generic-message fault (not exclusively AC-005's/AC-006's cells): each asserts its own
distinguishing substring is present and the other absent (EC-5 expects D1 present/D2 absent; EC-6
and EC-7 expect D2 present/D1 absent), which fails under either fault, corroborating AC-005's
partition `proptest!` and AC-006's `-q =v` cell, which remain the primary owners. The EC-9 cell
also kills the empty-NAME check evaluated before the missing-`=` check (per cross-cutting.md
~L4360, "killed by the `""` cells" -- plural, covering both AC-005's pinned
`parse_query_param("")` example and this AC's own EC-9 argv variants, all of which feed
`raw = ""`). The remaining two faults in this clause -- split on the last `=` instead of the
first, and NAME trimmed before the empty check -- are primarily killed by AC-005's proptest
(verified: none of the clap-delivered `raw` values these cells feed `parse_query_param` (`v`,
`=v`, `""`) contains a second `=` or a non-empty whitespace-only NAME, so they cannot observe
either fault), and the stdout/stderr envelope fault is
primarily killed by AC-006's `--output json` envelope cell (verified: none of this AC's own cells
invoke `--output json`, so they cannot observe it); see their Test lines), and VP-API-QP-005(intro)
`[CC:L4308-4316]` -- (O) observed by this AC's own six attached-form cells, which assert on the
M1/M2/D1/D2 terms this clause defines -- (P9-004:
VP-API-QP-005(3)'s cells assert on M1/M2 and D1/D2, which VP-API-QP-005(intro) defines; cited
here so that definition is binding for this AC too -- AC-009 now cites three clauses, so the
plural "clause(s)" form below applies, not the pass-8 singular-clause grammatical accommodation).
Everything the cited clause(s) specify is binding in its entirety and must be implemented exactly
as written there; this story does not restate or narrow any of it. All 6 cells (EC-5, EC-6, EC-7,
EC-8, EC-9, EC-10) are separate `#[tokio::test]` functions in `tests/api_query_param.rs` (one per
EC id, per Task 9's counting rule; EC-X.16.002-9's three empty-raw-value variants (per that
clause) count as ONE cell/test).
RED/GREEN classification: EC-5, EC-6, EC-7, EC-9 are RED at the Task 1 stub; EC-10 is
WIRING-EXEMPT (clap-level rejection, GREEN at stub -- Task 10(a)); EC-8 is GREEN-nonexempt
(`rationale_category: PRE-EXISTING-BEHAVIOR`, Task 10(a2)) -- **(P11-005 correction:** EC-8
(`-q -x=1`) already exits 2 with clap's generic "unexpected argument" rejection before this story
exists at all (verified: `-q` itself is unrecognized pre-story), so it is GREEN independent of the
Task 1 stub's `-q` wiring, unlike EC-10 (`jr api /x -q` with `-q` as the last token), which is
verified to genuinely depend on Task 1's stub correctly declaring `-q` as a value-taking flag --
pre-story it fails to produce the pinned "a value is required for" substring at all, since `-q`
does not yet exist as a recognized option). The EC-7 function additionally runs the EC-6
invocation, per the clause's own byte-identical-stderr bullet.

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

Reference: `.factory/specs/architecture/ARCH-INDEX.md` Subsystem Registry (no module-boundary change; F1 confirmed no architecture delta)

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
| EC-X.16.002-11 | Non-UTF-8 `-q` value | Clap exit 2 before `parse_query_param` runs (U, no VP cell) |

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
| This story spec (re-measured pass-32 follow-up, same measurement rule: Read-tool header whole-file count, not summed across chunks; the CC-tag labeling sweep grew the file to ~49,000 tokens, rounded to ~50,000) | ~50,000 |
| Referenced code (`src/cli/api.rs` full file including `normalize_path`/`parse_header`/`resolve_body` precedent, `src/cli/mod.rs::Command::Api`, `src/main.rs`'s `Command::Api` arm) | ~2,800 |
| Test files (existing `jr api` integration tests, grep-scoped) | ~1,500 |
| Tool output overhead | ~1,200 |
| **Total** | **~55,500** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~28%** |

## Tasks

1. [ ] **STUB:** add `pub(crate) fn append_query_params(path: &str, pairs: &[(String, String)]) -> String` and `pub(crate) fn parse_query_param(raw: &str) -> Result<(String, String)>` to `src/cli/api.rs` with `todo!()` bodies (signatures per AC-001/AC-005); add the `-q`/`--query-param: Vec<String>` field to `Command::Api` (`src/cli/mod.rs`, no `value_delimiter`, no `allow_hyphen_values`) and wire the pre-flight call site into `handle_api` and `src/main.rs`'s `Command::Api` dispatch arm -- the `handle_api` wiring MUST short-circuit around both stubs when zero `-q` flags are supplied (use the pre-existing `normalize_path` output unchanged), so the crate compiles end-to-end and the zero-flag path never touches a `todo!()`. **Short-circuit is STUB-STAGE ONLY (P6-006):** this short-circuit is a temporary stub-stage measure, present only so the Red Gate can run before either function is implemented -- Task 13 REMOVES it and calls both functions unconditionally, since `append_query_params(p, &[]) == p` is an identity (BC-X.16.001 Postcondition 1 / Behavior 5) that makes the short-circuit and its removal behaviorally indistinguishable once implemented, and leaving it in place would leave an equivalent `delete !` mutant unkillable under the `--in-diff` mutants gate once `src/cli/api.rs` enters `examine_globs` (AC-011). **No pinned help text at stub:** the `-q`/`--query-param` field's doc comment / clap `help`/`long_help` string MUST NOT contain the BC-X.16.001 Behavior 3 pinned substring `"do not pre-encode"` at this stage -- Task 12 (clap field finalization) is what adds it; this keeps AC-003's `--help` test cell genuinely RED at the Task 1 stub (Task 10(b)/(d)) rather than accidentally GREEN from a premature-but-correct doc comment -- `stub-architect`
2. [ ] Write the `proptest!` separator oracle for `append_query_params` + pinned examples (AC-001's cited VP-API-QP-001 clauses) (AC-001) in `src/cli/api.rs`'s `#[cfg(test)] mod tests`. **The test-writer MUST read the cited VP clause(s) in `cross-cutting.md` in full before writing; the VP text, not this story, is the source of truth for cell contents.** **This task ALSO requires ONE story-added pinned example that is NOT itself one of VP-API-QP-001's own pinned examples: `append_query_params("/x", &[("k".into(), "".into())]) == "/x?k="` (P22-002, the wire half of EC-X.16.001-1) -- see AC-001's own citation of this example for its full rationale. This cell is a required deliverable of this task alongside the VP-sourced cells above and MUST NOT be omitted merely because it does not appear in the cited VP text.** -- `test-writer`
3. [ ] Write the repeated-names `proptest!` oracle (AC-002's cited VP-API-QP-002 clauses) in `src/cli/api.rs`'s `#[cfg(test)] mod tests`, plus the three argv cells in `tests/api_query_param.rs` (AC-002). **The `proptest!` oracle MUST assert the generator-constraint/anti-vacuity check `existing == generated_existing_pairs` (VP-API-QP-002(generator-constraint)) as a second assertion alongside the main oracle equality -- omitting it lets the generator silently collapse to an empty `existing` and pass vacuously (stated for emphasis; the clause governs).** **The test-writer MUST read the cited VP clause(s) in `cross-cutting.md` in full before writing; the VP text, not this story, is the source of truth for cell contents.** -- `test-writer`
4. [ ] Write the encoding-exactly-once biased `proptest!` + pinned examples (AC-003's cited VP-API-QP-003 clauses) in `src/cli/api.rs`'s `#[cfg(test)] mod tests`, plus the `--help` cell in `tests/api_query_param.rs` (AC-003). **The round-trip assertion (VP-API-QP-003(a)) MUST extract `encode(v)` from `append_query_params`'s own output, NOT call `urlencoding::encode` directly -- a direct call would be tautological and GREEN at the Task 1 stub, defeating the Red Gate (stated for emphasis; the clause governs).** **The test-writer MUST read the cited VP clause(s) in `cross-cutting.md` in full before writing; the VP text, not this story, is the source of truth for cell contents.** -- `test-writer`
5. [ ] Write the method-orthogonality table-driven wiremock test + zero-flag wiremock examples in `tests/api_query_param.rs`, and the zero-flag identity `proptest!` in `src/cli/api.rs`'s `#[cfg(test)] mod tests` (AC-004's cited VP-API-QP-004 clauses). **The test-writer MUST read the cited VP clause(s) in `cross-cutting.md` in full before writing; the VP text, not this story, is the source of truth for cell contents.** -- `test-writer`
6. [ ] Write the `parse_query_param` partition `proptest!` + pinned example (AC-005's cited VP-API-QP-005 clauses) in `src/cli/api.rs`'s `#[cfg(test)] mod tests`, plus the wiremock/JSON-envelope cells in `tests/api_query_param.rs` (AC-005, AC-006). **Each `Err`-case's "other distinguishing substring absent" assertion (VP-API-QP-005(1)) MUST be filtered with `prop_assume!` to `raw` values that do not themselves contain D1 or D2 -- omitting the filter lets the property vacuously fail to exercise the absence check (stated for emphasis; the clause governs).** **The VALUE/`rest` string strategy feeding the `Ok((NAME, rest))` case MUST be able to produce strings containing one or more `=` characters (not merely `=`-free strings) -- AC-005's Test line relies on this requirement to keep its "split on the last `=` instead of the first" fault-kill claim true. The M1/M2 `raw` strategy (covering both the no-`=` and `=`-prefixed partitions) MUST also be able to produce a `raw` with leading and/or trailing whitespace -- AC-005's Test line relies on this requirement to keep its "`{raw}` replaced by a trimmed or re-split value" fault-kill claim true (mirroring STORY-B's Task 2 pinning style).** **The test-writer MUST read the cited VP clause(s) in `cross-cutting.md` in full before writing; the VP text, not this story, is the source of truth for cell contents.** -- `test-writer`
7. [ ] Write the four VP-API-QP-006(i)/(ii) cells (AC-007's cited clauses) in `tests/api_query_param.rs`. **The test-writer MUST read the cited VP clause(s) in `cross-cutting.md` in full before writing; the VP text, not this story, is the source of truth for cell contents.** -- `test-writer`
8. [ ] Write the held-open-stdin `std::process::Command` test + the before-`-H`-parsing cell (AC-008's cited VP-API-QP-006(iii)/(iv) clauses) in `tests/api_query_param.rs`. **The test-writer MUST read the cited VP clause(s) in `cross-cutting.md` in full before writing; the VP text, not this story, is the source of truth for cell contents.** -- `test-writer`
9. [ ] Write the attached-form argv cells (AC-009's cited VP-API-QP-005(3) clause) in `tests/api_query_param.rs` -- `test-writer`. **The test-writer MUST read the cited VP clause (VP-API-QP-005(3)) in `cross-cutting.md` in full before writing; the VP text, not this story, is the source of truth for cell contents.** **Counting-unit pin (feeds Task 10's density tally):** each of EC-X.16.002-5, -6, -7, -8, -9
(EC-9's several attached-empty argv variants per VP-API-QP-005(3) -- see that clause for the
exact forms, not restated here -- count as ONE cell/test), and -10 is its OWN `#[tokio::test]`
function (one function per EC id, not one function spanning multiple EC ids) -- this is the unit
Task 10's `RED_TESTS`/`TOTAL_NEW_TESTS` counts are computed against, so EC-X.16.002-8 and
EC-X.16.002-10's GREEN-at-stub status can be excluded/included per-test rather than ambiguously
bundled with the RED EC-X.16.002-5/6/7/9 cells. The EC-X.16.002-7 test additionally runs the
EC-X.16.002-6 invocation (per VP-API-QP-005(3) -- see that clause for the exact argv, not
restated here) to assert byte-identical stderr between the two (P6-003(d)) -- this does not
change its status as ONE `#[tokio::test]` (P10-017: both cells are part of AC-009's already
wiremock-backed set, per that AC's **Test:** line)
10. [ ] Confirm Red Gate against the Task 1 stub, applying the per-story-delivery.md density
    formula (`RED_RATIO = RED_TESTS / (TOTAL_NEW_TESTS - EXEMPT_TESTS)`, `EXEMPT_TESTS =
    GREEN-BY-DESIGN_count + WIRING-EXEMPT_count`, ~L45-60) using the Task 9 counting unit, applied
    story-wide (ADV-C14-F3-P5-002(b)): **one `#[test]` (or `proptest!` block) per pinned
    example / EC id / scenario.**
    (a) **Denominator-exempt cells (removed from `TOTAL_NEW_TESTS - EXEMPT_TESTS`, not merely
    "excluded from the numerator" -- a GREEN cell is never in `RED_TESTS` to begin with).
    `EXEMPT_TESTS = WIRING-EXEMPT_count` only in this story (`GREEN-BY-DESIGN_count = 0` --
    see (a2)):**
      - EC-X.16.002-10 (`-q` as the last argv token -> clap exit 2 `a value is required for`),
        part of AC-009's test cells, is GREEN at the Task 1 stub -- clap's own missing-value
        parsing (the `-q`/`--query-param: Vec<String>` field declared with no
        `allow_hyphen_values`) rejects it before `parse_query_param` or `append_query_params`
        ever runs (mirrors STORY-A's `Cli::try_parse_from` cells). Category: **WIRING-EXEMPT**
        (`rationale_category: FRAMEWORK-WIRING` in the red-gate-log table) -- it passes because
        the correct clap field/flag wiring already exists in the Task 1 stub (verified: pre-story,
        with no `-q` field declared at all, this same argv does NOT produce the pinned "a value
        is required for" substring -- it produces the generic "unexpected argument '-q' found"
        instead -- so this cell's GREEN status genuinely depends on the stub's `-q` wiring, not
        merely on clap's baseline unknown-flag rejection), not because either new function was
        implemented early.
      **(P11-005 correction, ADV-C14-F3-P11-005):** EC-X.16.002-8 (`-q -x=1`) was previously
      listed here as WIRING-EXEMPT alongside EC-X.16.002-10. It is reclassified below in (a2) as
      non-exempt GREEN: verified that `jr api /x -q -x=1` already exits 2 with clap's generic
      "unexpected argument '-q' found" rejection BEFORE this story exists at all (no `-q` field
      declared), so its GREEN status at the Task 1 stub is not attributable to the stub's `-q`
      wiring -- unlike EC-X.16.002-10 above, whose GREEN status is verified to genuinely require
      that wiring.
      No other cell qualifies for `EXEMPT_TESTS`; a full sweep confirmed EC-X.16.002-10 is the
      complete exempt set (ADV-C14-F3-P5-001: AC-004's zero-flag wiremock examples, previously
      listed here as GREEN-BY-DESIGN, are reclassified in (a2) below and no longer reduce the
      denominator; ADV-C14-F3-P11-005: EC-X.16.002-8 likewise reclassified into (a2)).
    (a2) **Non-exempt GREEN-at-stub cells (stay in `TOTAL_NEW_TESTS - EXEMPT_TESTS`; GREEN but
    NOT `RED_TESTS` and NOT `EXEMPT_TESTS`) -- per ADV-C14-F3-P5-001 and ADV-C14-F3-P11-005:**
      - AC-004's zero-flag WIREMOCK EXAMPLES (Task 5, VP-API-QP-004(2) -- see that clause for the
        exact argv, expected path/query values, and the per-method scope; not restated here) are
        GREEN at the Task 1 stub -- Task 1's required short-circuit routes the zero-`-q` path
        around both `todo!()` bodies entirely, onto the pre-existing, unmodified `normalize_path`
        output. `rationale_category: PRE-EXISTING-BEHAVIOR` in the red-gate-log table: verified
        GREEN against the pre-story binary (no `-q` field exists; the zero-flag invocation is
        unchanged pre-existing `jr api` behavior); the Task 1 short-circuit merely preserves that
        behavior at the stub. This is NOT `GREEN-BY-DESIGN`: per-story-delivery.md (~L56) limits
        `GREEN-BY-DESIGN` to behavior "deterministic from the type system alone," and this pair's
        GREEN status reflects unchanged pre-existing behavior, not a type-system fact.
        PRE-EXISTING-BEHAVIOR is a `rationale_category` label for the log table, not one of the
        two categories (`GREEN-BY-DESIGN`, `WIRING-EXEMPT`) that reduce `EXEMPT_TESTS` -- these
        two cells therefore remain in the denominator, matching sibling STORY-B's treatment of
        its own PRE-EXISTING-BEHAVIOR GREENs. (P6-006: Task 13 later REMOVES the Task 1
        short-circuit itself, but since `append_query_params(p, &[]) == p` is an identity, these
        two cells remain GREEN post-removal too -- for a different, permanent reason -- so this
        classification is unaffected by that later change.)
      - **(New, P11-005/ADV-C14-F3-P11-005):** EC-X.16.002-8 (`-q -x=1`, part of AC-009's test
        cells) is GREEN at the Task 1 stub, but NOT because of the stub's `-q` wiring: verified
        that `jr api /x -q -x=1` already exits 2 with clap's generic "unexpected argument '-q'
        found" rejection when NO `-q` field is declared at all (pre-story baseline) -- the same
        clap behavior that rejects any unrecognized flag. `rationale_category:
        PRE-EXISTING-BEHAVIOR` in the red-gate-log table. This is distinct from EC-X.16.002-10
        in (a) above, which is verified to genuinely require the Task 1 stub's correct `-q`
        wiring to reach its pinned "a value is required for" substring. This cell stays in the
        denominator, matching the AC-004 pair's treatment above.
    (b) every other new test cell -- i.e. every cell NOT listed in (a) or (a2) -- fails
    (`todo!()` panic / behavior absent) and is `RED_TESTS`. This explicitly INCLUDES the AC-004
    zero-flag identity `proptest!` (direct calls to `append_query_params(p, &[])` hit the
    `todo!()` body -- this is RED, it calls the stub directly and is NOT the same cell as the
    non-exempt GREEN wiremock examples in (a2)) and the `-q` method-orthogonality wiremock table's
    `-q`-bearing cells (RED for the same reason);
    (c) regression guards specifically relevant to this story include (this list is NOT
    exhaustive -- the full `cargo test` suite must also stay GREEN both before and after this
    story): the AC-004
    zero-flag WIREMOCK EXAMPLES from (a2), EC-X.16.002-8 from (a2) (part of AC-009's test cells --
    P12-005: already GREEN pre-story per P11-005's verification, so it too is a regression guard,
    not merely a RED-at-stub cell), every pre-existing `jr api` test in
    `tests/cli_handler.rs` (unmodified, pre-existing behavior -- must never regress), the
    pre-existing, unmodified `src/cli/api.rs` `#[cfg(test)] mod tests` unit-test suite (~L185-354:
    the `normalize_path` trimming/slash/URL-rejection cells, `parse_header` cells, and
    `resolve_body` `@file`/`@-`/inline-JSON cells) -- included here in its own right, as
    pre-existing tests of the same file this story modifies, which must never regress (P26-004
    corrects this list's prior omission of it; see also `H-CYCLE14-W2-REG-001`'s own Setup
    section in `wave-holdout-scenarios.md`, which independently names this same suite as
    MUST-PASS -- provenance only; that file is not one of this story's `inputs:` and this list's
    own justification for including the suite does not rely on it), AND
    `tests/rate_limit_holdouts.rs::test_s_1_07_h_013_send_raw_gave_up_warning_in_stderr` (~L134,
    BC-X.1.005/BC-X.1.009 -- drives `jr api /rest/api/3/myself` with zero `-q` flags as a real
    subprocess and asserts on stderr; must remain byte-for-byte unaffected by this story's
    pre-flight `-q` step), AND
    `tests/e2e_cli_surface_guard.rs::test_e2e_cli_surface_all_paths_and_flags_exist` (verified;
    always-run, offline, no `JR_RUN_E2E` needed -- its `SURFACE` table carries the entry `(&["api"],
    &["--output"])`, so it runs `jr api --help` and would fail if this story's clap wiring broke
    the `api` subcommand's flag surface). The gated `#[ignore]` `jr api` callers in
    `tests/e2e_live.rs` (e.g. `discover_story_points_field`, which spawns `jr api
    /rest/api/3/field`) are likewise relevant regression surface for this story's change, but are
    out of scope for the Red Gate tally below since they require `JR_RUN_E2E=1` and live network
    access and are not part of the offline `cargo test` run this tally covers.
    (d) **Full per-cell enumeration** (ADV-C14-F3-P5-002(b); reproduces every pinned example /
    EC id / scenario each AC's Test line requires, tagged RED / GREEN-nonexempt / EXEMPT, so the
    (e) tally below is checkable against this list rather than asserted):

    Row labels below (D-386) are `<VP clause> <EC id>` (or a descriptive tag where no EC id
    exists) -- these labels are test bookkeeping, not ownership citations (D-387: they may keep
    their clause IDs but do not carry CC tags); see the matching AC's **Test:** line above
    for what each cited clause binds. No pinned value is restated here.

    | Task / AC | Row label | Tag |
    |---|---|---|
    | Task 2 / AC-001 | AC-001(EC-1, wire half, P22-002 new direct-call example) EC-X.16.001-1 | RED |
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
    | Task 4 / AC-003 | VP-API-QP-003(intro)+(a)+(b)+(c)+(d) (one biased `proptest!`) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(c) pinned example 1 of 2 (per that clause, not restated here) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(c) pinned example 2 of 2 (per that clause, not restated here) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(further-pinned) pinned example 1 of 4 (per that clause, not restated here) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(further-pinned) pinned example 2 of 4 (per that clause, not restated here) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(further-pinned) pinned example 3 of 4 (per that clause, not restated here) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(further-pinned) pinned example 4 of 4 (per that clause, not restated here) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(d) no-trim pinned example 1 (also runs through `parse_query_param`) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(d) no-trim pinned example 2 (also runs through `parse_query_param`) | RED |
    | Task 4 / AC-003 | VP-API-QP-003(e) `--help` cell | RED |
    | Task 5 / AC-004 | VP-API-QP-004(structural) table-driven wiremock test | RED |
    | Task 5 / AC-004 | VP-API-QP-004(1) zero-flag identity `proptest!` | RED |
    | Task 5 / AC-004 | VP-API-QP-004(2) zero-flag wiremock example 1 | GREEN-nonexempt (PRE-EXISTING-BEHAVIOR) |
    | Task 5 / AC-004 | VP-API-QP-004(2) zero-flag wiremock example 2 | GREEN-nonexempt (PRE-EXISTING-BEHAVIOR) |
    | Task 6 / AC-005 | VP-API-QP-005(1) partition `proptest!` | RED |
    | Task 6 / AC-005 | VP-API-QP-005(1) pinned `parse_query_param("")` example | RED |
    | Task 6 / AC-005 | VP-API-QP-005(2) wiremock cell (M1 cell, per that clause) | RED |
    | Task 6 / AC-006 | VP-API-QP-005(2) wiremock cell (M2 cell, per that clause) | RED |
    | Task 6 / AC-006 | VP-API-QP-005(2) `--output json` envelope cell -- ONE `#[tokio::test]` asserting BOTH the M1 and M2 envelope shapes (not split into 2) | RED |
    | Task 9 / AC-009 | VP-API-QP-005(3) EC-X.16.002-5 | RED |
    | Task 9 / AC-009 | VP-API-QP-005(3) EC-X.16.002-6 | RED |
    | Task 9 / AC-009 | VP-API-QP-005(3) EC-X.16.002-7 (additionally runs the EC-6 invocation and asserts byte-identical stderr) | RED |
    | Task 9 / AC-009 | VP-API-QP-005(3) EC-X.16.002-8 | GREEN-nonexempt (PRE-EXISTING-BEHAVIOR) (P11-005) |
    | Task 9 / AC-009 | VP-API-QP-005(3) EC-X.16.002-9 (its three empty-raw-value variants, per that clause, merged into ONE test) | RED |
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
    | AC-001 (VP-API-QP-001) | 9 (separator oracle `proptest!` + 8 pinned examples, including the P22-002 new EC-X.16.001-1 wire-half cell) | 9 | 0 | 0 |
    | AC-002 (VP-API-QP-002) | 5 (repeated-names `proptest!` + pinned decode example + 3 argv cells: EC-X.16.001-13, repeated-flags, mixed) | 5 | 0 | 0 |
    | AC-003 (VP-API-QP-003) | 10 (encoding `proptest!` + 6 encode pinned examples + 2 no-trim pinned examples + `--help` cell) | 10 | 0 | 0 |
    | AC-004 (VP-API-QP-004) | 4 (table-driven method-orthogonality wiremock test + zero-flag identity `proptest!` + 2 zero-flag wiremock examples) | 2 | 2 (PRE-EXISTING-BEHAVIOR) | 0 |
    | AC-005/006/009 (VP-API-QP-005) | 11 (partition `proptest!` + pinned `parse_query_param("")` example + 2 wiremock cells + 1 `--output json` envelope cell + 6 attached-form cells) | 9 | 1 (PRE-EXISTING-BEHAVIOR -- EC-X.16.002-8, P11-005) | 1 (WIRING-EXEMPT / FRAMEWORK-WIRING -- EC-X.16.002-10) |
    | AC-007/008 (VP-API-QP-006) | 6 (2 all-or-nothing cells + 2 first-malformed-reported cells + held-open-stdin cell + before-`-H` cell) | 6 | 0 | 0 |
    | **Total** | **45** | **41** | **3** | **1** |

    `TOTAL_NEW_TESTS = 45`, `EXEMPT_TESTS = 1` (0 GREEN-BY-DESIGN + 1 WIRING-EXEMPT -- P11-005
    reclassified EC-X.16.002-8 out of `EXEMPT_TESTS` and into non-exempt GREEN, leaving only
    EC-X.16.002-10 exempt), so the denominator is `45 - 1 = 44`; `RED_TESTS = 41` (the 3
    non-exempt GREEN cells stay in the denominator but are not RED; the P22-002 addition to AC-001
    is RED); `RED_RATIO = 41 / 44 ≈ 0.932
    >= 0.5` -- comfortably clears the BC-8.29.001 gate under this counting unit, with no
    full-exception path (denominator > 0) and no UNJUSTIFIED GREEN cells. Record this tally, and
    the actual counts observed after Step 3 dispatch, in `red-gate-log.md`.
    (f) **`todo!()`-panic vs. subprocess-assertion failure mode** (ADV-C14-F3-P5-004, recomputed
    at P6, recomputed pass-22 P22-002): the 23 direct-call cells in (d) that invoke
    `append_query_params`/`parse_query_param`
    in-process (all of AC-001's 9 cells, including the P22-002 EC-X.16.001-1 wire-half example;
    AC-002's `proptest!` and pinned decode example, not its
    3 argv cells; AC-003's `proptest!` + 6 encode pinned (including the space -> `%20` pin) + 2
    no-trim pinned, not its `--help` cell; AC-004's zero-flag identity `proptest!` only, not its
    wiremock cells; AC-005's `proptest!` + pinned `""` example) can only fail with a raw
    `todo!()` panic (message containing "not yet implemented"), never a
    produced-and-asserted-wrong-value diff -- **this is the EXPECTED Red signal for this story's
    strict-`tdd_mode` stub** (Task 1 is a stub-architect `todo!()` stub per BC-5.38.001); the
    orchestrator must NOT re-dispatch the test-writer for these 23 cells on the basis of
    panic-vs-assertion-error alone. The remaining 22 cells in (d) are subprocess-level, all in
    `tests/api_query_param.rs` (spawned via `std::process::Command`/the CLI binary), and fail (or
    pass) via their own exit-code/stderr `assert_eq!`/`assert!` checks in the test function
    itself -- the child process's underlying `todo!()` panic surfaces there as an unexpected exit
    code / panic text on stderr, but the top-level test function fails via a normal assertion,
    satisfying Step 3's Red Gate requirement (~L35) literally.
11. [ ] Implement `append_query_params` and `parse_query_param` in `src/cli/api.rs` (AC-001..AC-007) -- `implementer`
12. [ ] Finalize the `-q`/`--query-param` clap field on `Command::Api` (`src/cli/mod.rs`) with
    the pinned help text -- the literal substring `"do not pre-encode"` is the automated test
    pin (VP-API-QP-003(e)), but the full BC-X.16.001 Behavior 3 requirement (spec L3826-3852) /
    verification-delta.md §2 wording is that the text must also state values are passed raw
    (U) -- see AC-003 (AC-003,
    AC-009) -- `implementer`
13. [ ] Wire `handle_api` to call `-q` parsing immediately after `normalize_path` and before `resolve_body`/`-H` parsing (AC-008); REMOVE Task 1's zero-flag short-circuit and call `parse_query_param`/`append_query_params` unconditionally on every invocation, including zero `-q` flags -- `append_query_params(p, &[]) == p` is an identity (BC-X.16.001 Postcondition 1 / Behavior 5), so this is behavior-preserving and closes the equivalent-mutant risk noted in Task 1 (P6-006, mirrors STORY-A Task 9). **(P11-004: this exact placement -- immediately after `normalize_path` -- is also the sole enforcement mechanism for BC-X.16.002 Preconditions' requirement that `normalize_path`'s own path errors run BEFORE `-q` validation (AC-008); (U) — see AC-008.)** -- `implementer`
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
| S-cycle14-user-list-project-resolution (Wave 1, predecessor in the serial chain) | `.cargo/mutants.toml` `examine_globs` bumped 32->33; `docs/specs/cargo-mutants-policy.md`'s count line and §Scope table follow the same per-story pattern this story reuses (33->34) | Reuses the policy's pre-existing `` `file` — `symbol` `` bullet form (verification-delta §2), not `file::symbol`, required by `scripts/check-cargo-mutants-policy-citations.sh` | The policy's hard-coded count line has no CI check comparing it against the real `.cargo/mutants.toml` count -- re-count the actual array entries before writing 34, don't trust the prior story's stated number blindly |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| `append_query_params` and `parse_query_param` MUST be pure -- no `JiraClient`, no network, no config parameter | BC-X.16.001 Invariants, BC-X.16.002 Source | AC-001..AC-005 tests need no wiremock for their proptest layers (P12-006: AC-006..AC-009 have no proptest layer -- all their cells are `#[tokio::test]` wiremock/subprocess cells in `tests/api_query_param.rs`) |
| `url::form_urlencoded::byte_serialize` MUST NOT be used for this assembly (space -> `+`, wrong semantics) | BC-X.16.001 Invariants | AC-003's encoder-identity assertion |
| `-q` validation MUST run strictly between `normalize_path` and `resolve_body`, before `-H` parsing | BC-X.16.002 Postcondition 1, D-188 | AC-008 |
| `-q`/`--query-param` MUST NOT be declared with `allow_hyphen_values` | BC-X.16.002 EC-X.16.002-8 | AC-009 |
| Query-param content MUST NEVER be merged into, or sourced from, `-d`/`--data` | BC-X.16.001 Behavior 4 | AC-004 |
| The two error messages MUST be pinned verbatim and mutually distinguishable by substring | BC-X.16.002 Pinned error messages, Invariants | AC-005, AC-006 |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| `urlencoding` | `"2"` (existing pin, `Cargo.toml`; verified 2.1.3 behavior against source) | PRODUCTION encoder for `append_query_params` (no new dependency) |
| `url` | `"2"` (existing pin, `Cargo.toml`) | Provides `url::form_urlencoded::parse`, used ONLY as a test-oracle decoder in VP-API-QP-002/003's proptests -- never in production code |

No new dependency is added. `url::form_urlencoded::byte_serialize` is explicitly forbidden for this story's production code.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/cli/mod.rs` | modify | New `-q`/`--query-param: Vec<String>` field on `Command::Api`, pinned help text (traces to AC-002 -- no `value_delimiter`, AC-003, and AC-009 -- no `allow_hyphen_values`) |
| `src/main.rs` | modify | `Command::Api` dispatch arm passes the new field through to `handle_api` |
| `src/cli/api.rs` | modify | New `append_query_params`, `parse_query_param`; `handle_api` pre-flight wiring; new pure-unit and `proptest!` cases (separator oracle, repeated-names oracle, encoding proptest, zero-flag identity, `parse_query_param` partition) added to the existing `#[cfg(test)] mod tests` block (AC-001..AC-008 -- P12-006: corrected from "AC-001..003, AC-005..007," which omitted AC-004's zero-flag identity `proptest!` (also in this file's test module) and AC-008's `handle_api` pre-flight-wiring implementation (also in this file, though AC-008's own test cells live in `tests/api_query_param.rs`)) |
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

## Close-Out (2026-09-30, CYCLE-014-STORY-C-MERGED)

Delivered and squash-merged to `develop` as **PR #887** ("feat(api): add
repeatable -q/--query-param NAME=VALUE to jr api (#583) (#887)"), merge
commit `e54be670cf77cb9220e1aad7e3826c66de908923`, mergedAt
2026-09-30T03:57:04Z, closing **#583**. `develop` moved
`2d8467c4 -> e54be670`. pr-manager's gates: security review APPROVE (0
CRITICAL/HIGH/MEDIUM, 2 LOW informational notes — unbounded `-q` count/length
is local-arg-only, repeated-NAME non-dedup is by design); `pr-reviewer` 1
cycle, APPROVE with 0 blocking findings (2 suggestions + 3 nits — secret-in-
query-value guidance, a `--help` workaround mention for `-q=-x=1`, README
`--body`/`-d` wording drift, tracked as the pre-existing `README-JR-API-BODY-
FLAG` item); CI 24/24 green including Windows (the known 5s held-stdin flake
did not trigger). All four `D-391` autonomous-merge conditions HELD.

**Merge was performed manually by the human (`Zious11`), not by
`pr-manager`.** pr-manager's dispatch of the merge action was DENIED by the
Claude Code auto-mode permission classifier — a harness-level permission
gate, separate from and unrelated to `D-391`'s content-based
autonomous-merge policy. pr-manager correctly stopped at merge-ready without
attempting to work around the denial, and the human merged by hand.
Operating note recorded in `STATE.md`: until the human adds a permission
rule for the merge action, `pr-manager` must STOP at merge-ready (all four
`D-391` gates green) and hand off to the human for the merge click, rather
than attempt the merge action itself.

Feature branch `feat/api-query-param` and its worktree
`.worktrees/S-cycle14-api-query-param` are deleted (remote + local).
`blocks:[S-cycle14-field-options-name-label]` **UNBLOCKED** — STORY-B may
now be rebased on `develop`'s new tip `e54be670`. `status: done`.
