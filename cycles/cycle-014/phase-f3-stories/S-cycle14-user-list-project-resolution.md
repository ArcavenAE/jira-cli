---
document_type: story
level: ops
story_id: "S-cycle14-user-list-project-resolution"
epic_id: "ISSUE-TRIAGE-QUICKFIXES-1"
title: "jr user list --project resolution order: local > global > configured default > exit 64"
wave: 1
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
  - "src/cli/mod.rs"
  - "src/main.rs"
  - "src/cli/user.rs"
  - "src/config.rs"
  - "src/cli/component.rs"
  - "src/cli/field.rs"
  - "src/cli/queue.rs"
  - "src/cli/requesttype.rs"
  - "src/jql.rs"
  - "tests/user_commands.rs"
  - "tests/all_flag_behavior.rs"
  - "tests/user_pagination.rs"
  - "tests/mutants_glob_existence.rs"
  - "README.md"
  - "CLAUDE.md"
  - ".cargo/mutants.toml"
  - "docs/specs/cargo-mutants-policy.md"
  - "scripts/check-cargo-mutants-policy-citations.sh"
  - "Cargo.toml"
  - "CHANGELOG.md"
input-hash: "836f870"
traces_to: "BC-X.7.002"
cycle: cycle-014-issue-triage-quickfixes
estimated_effort: small
estimated_days: 1
target_module: "src/cli/user.rs, src/cli/mod.rs, src/main.rs"
subsystems: ["SS-01", "SS-02"]
# SS-02 (CLI Layer, src/cli/) owns this story's core scope because most
# files this story modifies (src/cli/mod.rs, src/cli/user.rs) live under
# src/cli/ per ARCH-INDEX's Subsystem Registry (SS-02 row: "CLI Layer |
# src/cli/"). SS-01 (Entry Point & Runtime) is also listed because this
# story modifies src/main.rs's `Command::User` dispatch arm to thread the
# already-loaded `config` binding through (Task 9) -- src/main.rs is owned
# by SS-01 per ARCH-INDEX's Subsystem Registry (SS-01 row: "Entry Point &
# Runtime | src/main.rs"), not SS-02; it does not "live under src/cli/".
# This is a real, functional edit to main.rs's dispatch wiring (not a
# doc-only touch), so it is anchored, following the S-MUTANTS-SCOPE-1
# precedent of listing SS-01 whenever src/main.rs is functionally modified
# (STORY-INDEX ~L588: `subsystems:["SS-01","SS-08"]`).
depends_on: []
blocks: ["S-cycle14-api-query-param"]
# S-cycle14-api-query-param depends on this story because both stories edit
# the SAME two files in the same numeric sequence: .cargo/mutants.toml's
# examine_globs array (this story: 32->33) and
# docs/specs/cargo-mutants-policy.md's single hard-coded "Current
# examine_globs count" line (this story sets it to 33; STORY-C's edit must
# start from that already-landed value to reach 34) -- a real content
# dependency, not mere file overlap. Delivery order A -> C -> B is human
# decision D-381 (2026-09-25 F2 review), recorded in cycle-manifest.md.
behavioral_contracts:
  - BC-X.7.002
bcs:
  - BC-X.7.002
verification_properties:
  - VP-USER-LIST-PROJECT-001
holdout_anchors: ["H-CYCLE14-W1-INT-001", "H-CYCLE14-W1-REG-001", "H-CYCLE14-W1-REG-002"]
nfr_anchors: []
adr_refs: []
sd_refs: []
priority: P2
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-014/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: strict
module_criticality: "N/A -- no .factory/specs/module-criticality.md exists in this repo"
points: 3
acceptance_criteria_count: 11
assumption_validations: []
risk_mitigations: []
created: "2026-09-26"
version: "5.5"
last_updated: "2026-09-28"
breaking_change: true
retroactive: false
origin: >
  cycle-014 issue-triage-quickfixes (GitHub issue #862), Wave 1 of 3, first
  story in the human-decided SERIAL delivery order A -> C -> B (D-381,
  2026-09-25 F2 review). F1 delta-analysis (.factory/cycles/cycle-014/
  phase-f1-delta-analysis/delta-analysis.md) confirmed the root cause as
  UserCommand::List.project's clap-REQUIRED String typing, which rejects a
  global --project before clap's own propagation step ever runs. F2
  (prd-delta.md Item 1) amended BC-X.7.002 with the four-step resolution
  order this story implements. This story implements that already-approved
  spec amendment -- it does not re-litigate the resolution-order design.
---

> **tdd_mode:** `strict` -- this story adds new runtime logic (a pure
> resolver function, a type change, and config-threading through two call
> sites) that is not a config/constant-only edit, so the full TDD Iron Law
> applies: non-trivial function bodies start as `todo!()`, Red Gate density
> check >= 0.5 required before Step 4 dispatch.

> **Execute:** `/vsdd-factory:deliver-story S-cycle14-user-list-project-resolution`

# S-cycle14-user-list-project-resolution -- `jr user list --project` resolution order (#862)

## Revision History

The full F3 adversarial-review history for this story (passes 3 through 12, plus the D-386
"bind by reference" and D-387 "Coverage Scope" restructuring decisions) lives in
`S-cycle14-user-list-project-resolution.revision-history.md`, alongside this file. That file is
historical and non-normative -- wherever it appears to differ from this story body, this body
governs.

Current structure, in brief: **D-386** (2026-09-27/28) requires every AC's `**Test:**` line to
bind to its BC-X.7.002/VP-USER-LIST-PROJECT-001 clause(s) by reference (a citation plus a
"binding in its entirety, not restated" sentence) rather than copying pinned values into this
story. **D-387** (2026-09-28) replaced the hand-written Clause Coverage Map with the
`## Coverage Scope (D-387)` section below: inline `[CC:L<start>-<end>]` tags on each AC, plus
the `[SCOPE:...]`/`[EXCLUDE:...]` lines there, are verified mechanically rather than
hand-audited. Current Red Gate density tally (Task 7): `RED_TESTS=9`, `EXEMPT_TESTS=3`,
`GREEN-nonexempt=2`, `TOTAL_NEW_TESTS=14`, denominator=11, `RED_RATIO=9/11≈0.82` (clears the
BC-8.29.001 `>= 0.5` threshold; unchanged by the pass-14 cosmetic fixes, the pass-22 citation
fixes (P22-004, P22-005), the pass-23 fix (P23-003) and fault-model/multi-sided-clause sweep, or
the pass-26 sweep below, recorded in
`S-cycle14-user-list-project-resolution.revision-history.md`). Pass-26 (F3 cross-story sweep,
triggered by STORY-C's pass-26 findings) checked this story for the same three defect patterns
found in its siblings and found none: VP-USER-LIST-PROJECT-001(b)'s "distinct arbitrary non-empty
keys `C`, `J`, `P`" generator constraint is already pinned directly in the binding VP text
(`cross-cutting.md` L858-860), so no Task-level pin is needed to back AC-003's/AC-006's
fault-kill claims (unlike STORY-C's AC-005, P26-001); no AC in this story makes an unbacked
"asserts X" claim the way STORY-B's AC-001 did (P26-003); and Task 7's "Excluded entirely (not
new tests)" list is scoped to Red Gate density-tally bookkeeping (which pre-existing tests never
enter `TOTAL_NEW_TESTS`), not a global "ONLY regression guards required GREEN" completeness claim
the way STORY-C's Task 10(c) is, so it is not analogous to that gap (P26-004) -- see the
revision-history file for the dated entry. No content defect was found; no fix was required.
Pass-27 (cross-story sweep, triggered by STORY-C's pass-27 findings) re-checked this story for
STORY-C's four pass-27 defect patterns and again found none: this story's wiremock fault-model
attributions all fix an input state whose disturbance their own assertions can actually observe;
this story makes no "ONLY"/completeness claim about an external test suite anywhere in its body;
and this story's body never cites `wave-holdout-scenarios.md` as an enforcement mechanism -- only
its `holdout_anchors:` frontmatter names its own holdout IDs, a plain cross-reference, not a body
claim relying on that file. See the revision-history file for the dated entry. No content defect
was found; no fix was required.
Pass-28 (2026-09-28) fixed two findings against this story (P28-001, P28-002) and ran the
mechanical `inputs:` sweep (P28-003). P28-001: AC-004 had claimed
`tests/user_commands.rs::user_list_requires_project_flag` "directly tests" the
exit-64-before-any-HTTP-call behavior; re-reading that test's actual body (~L122-139) shows its
only assertions are `!output.status.success()` and a stderr substring match on `--project`/
`required` -- it does not itself observe exit code 64 or the before-any-HTTP-call ordering. AC-004
now credits the EC-X.7.002-4 cell as the sole owner of that clause and describes the pre-existing
test only as corroborating non-success, the pinned substring, and the absence of a successful HTTP
call (via its unreachable `JR_BASE_URL`), per verification-delta.md §2; the test itself was left
unchanged, since cross-cutting.md's own Invariant (line 810) pins that loose assertion as the
intended, settled form. A same-pattern sweep of this story's other named pre-existing-test
citations (`user_list_by_project_returns_users` in tests/user_commands.rs;
`user_list_all_cli_paginates` and its cap-hitting sibling in tests/user_pagination.rs;
`user_list_default_caps_at_thirty` in tests/all_flag_behavior.rs) against their actual bodies found
no further overclaim -- each supplies `--project` explicitly and is described only as bypassing the
resolver, which their bodies confirm. P28-002: AC-003's citation of Fix step 4's second sentence
(cross-cutting.md line 779) previously left its two halves unattributed; it now labels the
"exits 64 on `None`" half as observed by AC-004's EC-X.7.002-4 cell, and the "`handle_list` calls
this resolver with the post-clap value" (unconditional-call) half as informational/structural,
enforced by Task 9's removal of the stub short-circuit plus PR review, and not independently
observable at runtime because `config.project_key(Some(p)) == Some(p)`. P28-003 (mechanical
`inputs:` sweep): grepped this story's body for every cited repository path, excluding this
story's own new files and the sibling story/holdout files, and compared the result against the
frontmatter `inputs:` list. Three cited paths were missing and are added, each verified present on
disk with `ls`: `CLAUDE.md` (cited for the `cargo mutants --in-diff` command and the `fix/`-prefix
branch-naming convention), `src/jql.rs` (cited as the anchor bullet the new
`docs/specs/cargo-mutants-policy.md` §Scope entry is inserted directly after), and
`tests/mutants_glob_existence.rs` (cited in AC-011's Test line). No other cited path was found
missing. Story version: 5.5.

## Narrative

- **As a** `jr` user who has a global `--project` flag or a configured default project
- **I want to** `jr user list` to resolve `--project` the same way `jr component list`/`jr queue`/`jr field options --type` already do (local flag > global flag > configured default)
- **So that** `jr --project FOO user list` and a bare `jr user list` (with a configured default) work instead of failing with clap's own "required argument" error before `jr`'s own logic ever runs

## Behavioral Contracts

| BC | Role | Clauses this story implements |
|----|------|-------------------------------|
| BC-X.7.002 | PRIMARY (amended, cycle-014 F2) | The four-step resolution order (Behavior, Postconditions 1-5), the pure `resolve_user_list_project` resolver (Fix step 4), the `&Config`-threading requirement (Fix step 3, Invariants), the pinned exit-64 message (Postcondition 4), the pinned `--help` text (Fix step 1), and Edge Cases EC-X.7.002-1..7 |

**Anchor justification:** BC-X.7.002 is the sole BC governing `jr user list`'s project resolution in this spec corpus (`cross-cutting.md`). It was amended at cycle-014 F2 specifically to fix issue #862; this story is the F4-bound implementation of that already-approved amendment.

## Acceptance Criteria

### AC-001 (traces to BC-X.7.002 Fix step 1 [CC:L759-774] / Postcondition 1 (line 801, cross-reference; owned by AC-005))
`src/cli/mod.rs::UserCommand::List.project` (~L1148) changes from clap-REQUIRED `String` to `Option<String>`. The `#[arg(long, short = 'p')]` attribute, including `short = 'p'`, is unchanged. When a local `--project` is supplied, `Cli::try_parse_from` resolves it to `Some(value)` regardless of whether a global `--project` or a configured default is also present (local wins unconditionally).
**Test:** Implements VP-USER-LIST-PROJECT-001 preamble [CC:L839-843] (informational, inherited
-- describes the VP's overall structure; not itself an independently-tested clause) and (a)
Clap propagation pin [CC:L844-857]: three base cells (the fourth, "both given", is shared
with AC-005) plus two `-p` short-alias cells, and the "no global `-p` cell" note. Also carries
BC-X.7.002 Fix step 2 [CC:L775]: the global-fills-local half is demonstrated by this AC's
global-only argv cell at the parse level, alongside AC-002's wiring-level test of the same
postcondition; the local-wins half (when both local and global are given, the local value wins)
is verified by AC-005's "both given" cell; that same value's propagation back up to the shared
global-position arg is (informational, inherited -- clap `fill_in_global_values` mechanism, not
observable by handle_list; enforced by clap's own behavior and ACR row 2 code review); and the
"no `jr`-level merge code" half is (informational -- enforced by
Architecture Compliance Rules row 2 via code review). Also carries Postcondition 2
[CC:L802] (global fills local when absent; its own "regardless of whether a configured default
is also present" half is observed by AC-003's VP(b) `Some(C)` cells -- `cli_project = Some(C)`
-> `Some(C)` in every configured cell, cross-cutting.md line 863 -- not by this AC's own cells)
as a secondary citation, and Resolution order step 4 [CC:L786]
(informational, inherited -- every hermetic test in this story inherits `main.rs`'s earlier
preemption ordering by virtue of supplying valid auth and a known profile). Fix step 1
[CC:L759-774]'s design-rationale sentences (the new help text is "modeled on
`ComponentSubcommand::List`'s wording"; why it cannot reuse that string byte-for-byte, since
`component list`'s own help text understates its `Config::project_key` fallback) are
(informational, inherited -- rationale for the VP(d) test substrings AC-008 asserts, not
independently tested by this AC or AC-008). This AC's header
also cites BC-X.7.002 Postcondition 1 (line 801; local wins unconditionally) -- as plain prose,
not a CC tag, since AC-005 already carries that citation below; the argv cell
that demonstrates it -- the "both given" cell described below -- is physically part of this
AC's inline test function but is owned by AC-005 (see AC-005's own citation of Postcondition 1
and its EC-X.7.002-1 cell) -- verified there, not by a separate AC-001 assertion. Postcondition
1's own "regardless of whether a configured default is also present" half is likewise not
verified by any AC-001 cell -- see AC-005's Test line for the cross-reference to AC-003's VP(b)
`Some(C)` cells. Everything the
cited clause(s) specify is binding in its entirety and must be implemented exactly as written
there; this story does not restate or narrow any of it.
Story-specific: these five cells live in ONE inline `#[test]` function in
`src/cli/mod.rs`'s existing `#[cfg(test)] mod tests` block (Task 3) -- VP(a) is a single
inline test asserting multiple argv vectors in its body, not one test per cell (the
EC-X.7.002-6 empty-string cells and the EC-X.7.002-1 "both given" cell live in the same
physical function but are owned by AC-006 and AC-005 respectively, below). Classification:
WIRING-EXEMPT / GREEN-at-stub (Task 7(a)) -- parser-only, never calls
`resolve_user_list_project`.

### AC-002 (traces to BC-X.7.002 Postcondition 2 [CC:L802], EC-X.7.002-2 [CC:L814])
`jr --project FOO user list` (global only, no local flag, no configured default) resolves the local field to `Some("FOO")` via clap's own `fill_in_global_values` propagation -- no `jr`-level local-vs-global merge code is written. This is the exact invocation issue #862 reported as broken (previously clap exit 2).
**Test:** Implements BC-X.7.002 Resolution order step 2 [CC:L784] (global fills the local field
via clap propagation whenever local is absent). This AC's header citation of Postcondition 2
[CC:L802]'s own "regardless of whether a configured default is also present" half is not
observed by this AC's own cell, which fixes the configured-default state at "absent" -- cross-
reference: that half is observed by AC-003's VP(b) `Some(C)` cells (`cli_project = Some(C)` ->
`Some(C)` in every configured cell, cross-cutting.md line 863). Also implements VP-USER-LIST-PROJECT-001(c) intro
[CC:L869-871] (informational, inherited -- describes the hermetic wiring-layer methodology all
(c) cells share, not itself an independently-tested clause), plus VP(c)'s EC-X.7.002-2 cell
[CC:L872-873]. Everything the cited clause(s) specify is binding in its entirety and must be
implemented exactly as written there; this story does not restate or narrow any of it.
Story-specific: one hermetic wiremock
`#[tokio::test]` function (`test_bc_x_7_002_...global_project_only...`) in the new
`tests/user_list_project_resolution.rs` (Task 5), built per `verification-delta.md` §2's
hermetic setup. Classification: WIRING-EXEMPT / GREEN-at-stub (Task 7(a)) -- resolves to
`Some(...)` via clap propagation alone and short-circuits straight to HTTP; this is the #862
bug fix itself, delivered by Task 1's `String` -> `Option<String>` type change, not by the
resolver.

### AC-003 (traces to BC-X.7.002 Postcondition 3 [CC:L803], EC-X.7.002-3 [CC:L815], EC-X.7.002-5 [CC:L817], EC-X.7.002-7 [CC:L829-836])
When both local and global `--project` are absent, `resolve_user_list_project(cli_project: Option<&str>, config: &Config) -> Option<String>` (new `pub(crate)` function in `src/cli/user.rs`) falls back to `Config::project_key`'s existing chain: `.jr.toml` project first, then the active profile's configured `project` default (including a non-default `--profile`'s own default, and including an empty-string configured default, EC-X.7.002-7). `handle_list` calls this resolver with the post-clap field value.
**Test:** Implements BC-X.7.002 Fix step 4 [CC:L777-779] (the pure resolver itself, L777-778),
with L779's two halves given their own plain-prose labels: "exits 64 on `None`" is not observed
by this AC's own cells -- it is observed by AC-004's EC-X.7.002-4 cell; "`handle_list` calls this
resolver with the post-clap value" (the unconditional call) is informational/structural, enforced
by Task 9's removal of the stub short-circuit plus PR review, and is not independently observable
at runtime because `project_key(Some(p)) == Some(p)`. Also implements
Resolution order step 3 [CC:L785] (configured default consulted only when local and global are
both absent). Implements VP-USER-LIST-PROJECT-001(b) in full [CC:L858-868],
VP-USER-LIST-PROJECT-001(c)'s EC-X.7.002-3 three sub-cells [CC:L873-877], and
VP-USER-LIST-PROJECT-001(c)'s EC-X.7.002-5 cell [CC:L881-884] (shared ownership
with AC-009 below -- one physical test satisfies both ACs). Also implements the fault models
this AC's tests kill [CC:L902-909]: fault (1) (resolver body replaced) and, jointly with AC-007,
fault (2) (`handle_list` bypassing the resolver). This AC's header also cites BC-X.7.002 Postcondition 3's `Some("")`-counts-as-present
sub-clause [CC:L803] and EC-X.7.002-7 [CC:L829-836] (both informational, inherited -- enforced
by reusing `Config::project_key` unchanged per Invariants [CC:L808-810] / Architecture
Compliance Rules row 5, and by PR code review; no dedicated cell -- the VP(b) proptest's
configured-default keys are all non-empty per [CC:L860] and the spec itself marks EC-7
"informational, no VP cell" at [CC:L829]; the rest of Postcondition 3 -- that a non-empty
configured default is used -- is actively tested by the VP(b)/VP(c) cells cited above). Everything the cited clause(s)
specify is binding in its entirety and must be implemented exactly as written there; this story
does not restate or narrow any of it. Story-specific: the VP(b) presence-space lives in ONE
`proptest!` block in `src/cli/user.rs`'s `#[cfg(test)]` module (Task 4) -- classification
RED-at-stub (fails via a direct in-process `todo!()` panic, Task 7(b)). The three
EC-X.7.002-3 sub-cells and the EC-X.7.002-5 cell are four separate hermetic wiremock
`#[tokio::test]` functions in the new `tests/user_list_project_resolution.rs` (Task 5) --
classification RED-at-stub for all four (each hits the `None` arm and fails via the child
`jr` subprocess's `todo!()` panic/exit 101, Task 7(b)).

### AC-004 (traces to BC-X.7.002 Behavior [CC:L753-754], Postcondition 4 [CC:L804], Preconditions [CC:L796-798], EC-X.7.002-4 [CC:L816])
When none of {local `--project`, global `--project`, configured default} resolve, `handle_list` exits 64 (`JrError::UserError`) with the byte-identical message `"No project configured. Run \"jr init\" or pass --project. Run \"jr project list\" to see available projects."`, before any HTTP call.
**Test:** Implements BC-X.7.002 Behavior [CC:L753-754] (informational, inherited -- states the
general premise that `jr user list` needs a resolved project key before it can call
`/rest/api/3/user/assignable/multiProjectSearch?projectKeys=P`; this AC is the enforcement path
for that premise on the no-project case, where the call never happens at all), Postcondition 4
(the pinned exit-64 message, stated verbatim
in this AC's own body above -- this is a BC postcondition text, not a VP-cell paraphrase, per
the D-386 carve-out), BC-X.7.002's Preconditions [CC:L796-798] (the
config-isolation and valid-auth/valid-profile requirements this AC's hermetic tests satisfy),
BC-X.7.002's Invariants [CC:L808-810]: the L808 "config-merge-only resolution, no new
accessor/cache" clause is (informational -- enforced by Architecture Compliance Rules row 5 via
code review, mirroring AC-009); the L809 failure-MECHANISM-vs-FACT distinction is what this
AC's exit-64 path actually preserves and tests; the L810 sentence
(`user_list_requires_project_flag` passes once hermetically isolated, no rename) is tested by
this AC's own Task 6 test update described below, except its "stale comment must be updated"
clause, which is (informational -- enforced by PR code review, not by any test assertion).
Resolution order step 4 [CC:L786], split into its two sentences: (a) its first sentence
("Exit 64 -- `JrError::UserError`, when none of (1)-(3) resolve a project, before any HTTP
call.") is exactly what this AC's own EC-X.7.002-4 cell asserts, and that cell is its sole
owner. `tests/user_commands.rs::user_list_requires_project_flag` (~L122-139) does not itself
assert this clause -- its own assertions are `!output.status.success()` plus a stderr substring
match on `--project` or `required`; per verification-delta.md §2, this loose assertion is the
spec-pinned form and is not being tightened here. That test only corroborates non-success, the
pinned substring, and the absence of a successful HTTP call (via its unreachable
`JR_BASE_URL=http://127.0.0.1:1`) -- it does not independently observe exit code 64 or the
before-any-HTTP-call ordering, both of which are owned exclusively by the EC-X.7.002-4 cell; (b)
its second sentence (the `config::validate_profile_name`/`Config::load_with`/
`JiraClient::from_config` preemption clause) is informational, inherited -- this AC's hermetic
tests must clear those preemption points (by supplying valid auth and a known profile, per
Preconditions above) to reach BC-X.7.002's own exit-64 path, but do not themselves test the
preemption behavior. Also carries
VP-USER-LIST-PROJECT-001(c)'s EC-X.7.002-4 cell [CC:L877-880]. Everything
the cited clause(s) specify is binding in its entirety and must be implemented exactly as
written there; this story does not restate or narrow any of it.
Story-specific: `tests/user_commands.rs::user_list_requires_project_flag` (no rename, per
F1-gate Open Question 8; made hermetic per `verification-delta.md` §2, keeping its existing
unreachable `JR_BASE_URL=http://127.0.0.1:1`, Task 6) plus a new, separate hermetic
`#[tokio::test]` function in the same file (Task 6). Classification: both RED-at-stub (each
hits the `None` arm and fails via the child `jr` subprocess's `todo!()` panic/exit 101, Task
7(b)) -- `user_list_requires_project_flag` is substantively modified by Task 6, not an
unmodified regression guard.

### AC-005 (traces to BC-X.7.002 EC-X.7.002-1 [CC:L813], precedent paragraph [CC:L788-793])
`jr --project GLOBAL user list --project LOCAL` resolves to `LOCAL` (local wins over global when both are supplied), via clap propagation, producing the same observable result as `component create`'s explicit local-over-global merge code.
**Test:** Implements BC-X.7.002 Postcondition 1 [CC:L801] (local wins unconditionally; this AC's
own EC-1 cell fixes the configured-default state at "neither" and does not itself vary it, so
PC1's own "regardless of whether a configured default is also present" half is not observed by
this AC's cell alone -- cross-reference: that half is observed by AC-003's VP(b) `Some(C)` cells
(`cli_project = Some(C)` -> `Some(C)` in every configured cell, cross-cutting.md line 863), and
the local, empty-string case of this same "regardless" property is also observed by AC-006's
EC-X.7.002-6 wiring cell (`jr user list --project ""` against a configured profile default,
`.expect(0)` on the configured-default mock, per VP(c)'s EC-X.7.002-6 cell)),
Resolution order step 1 [CC:L782-783] (local `--project` fills the field directly; L782's own
lead-in sentence -- "evaluated entirely in-process before any HTTP call" -- is (P22-004,
informational, inherited) observed by AC-004's EC-X.7.002-4 `.expect(0)` (zero HTTP calls on the
no-project exit-64 path) and by the exactly-one-request assertions of the EC-X.7.002-1, EC-X.7.002-3
"both", EC-X.7.002-5 and EC-X.7.002-6 wiring cells, owned respectively by AC-005 (this AC, its own EC-1 cell)/AC-003/AC-009/AC-006; no
dedicated AC-005 cell verifies this lead-in on its own, and none is added), and the
precedent paragraph [CC:L788-793] (informational, inherited -- states that local-wins-over-global
produces the same observable result as `component create`'s explicit local-over-global merge
code, and that BC-8.1.004 covers only the no-project-configured exit-64 condition, not
local-over-global precedence; this AC's own body above already states the local-wins outcome and
the `component create` precedent this paragraph describes). Implements
VP-USER-LIST-PROJECT-001(a)'s "both given" argv cell [CC:L849] (shared ownership with AC-001's
inline test -- it is one of the four base cells asserted there) and
VP-USER-LIST-PROJECT-001(c)'s EC-X.7.002-1 cell [CC:L872-873].
Everything the cited clause(s) specify is binding in its entirety and must be implemented
exactly as written there; this story does not restate or narrow any of it. Story-specific: the
argv cell is part of AC-001's
single inline `#[test]` function (no separate test); the EC-1 wiremock cell is its own
hermetic `#[tokio::test]` function in `tests/user_list_project_resolution.rs` (Task 5).
Classification (fixed in F3 review; see revision history): the argv cell is WIRING-EXEMPT / GREEN-at-stub
(Task 7(a)) -- bundled into AC-001's inline test, whose zero-flag cell would fail pre-story, so
the whole function depends on Task 1's stub. The EC-1 wiremock cell is GREEN-nonexempt
(`rationale_category: PRE-EXISTING-BEHAVIOR`, Task 7(a-ii)) -- it resolves to `Some(...)` via
clap propagation alone, but it already passes against the pre-story code (the local
`--project LOCAL` flag alone satisfies today's required `String` field), so it is not
WIRING-EXEMPT and stays in the Red Gate denominator.

### AC-006 (traces to BC-X.7.002 EC-X.7.002-6 [CC:L818-828], D-380)
`--project ""` (empty string), whether local or global, passes through as `Some(String::new())` and resolves the project key to the empty string without consulting the configured default -- settled behavior, human-confirmed 2026-09-25 (D-380), matching `jr queue`/`jr requesttype`'s existing empty-string pass-through.
**Test:** Implements VP-USER-LIST-PROJECT-001(a)'s two EC-X.7.002-6 argv cells
[CC:L850-851], VP-USER-LIST-PROJECT-001(b)'s EC-X.7.002-6 cell
[CC:L866-867], and VP-USER-LIST-PROJECT-001(c)'s EC-X.7.002-6 cell
[CC:L884-886]. Also implements the fault models this AC's tests kill [CC:L902-909]: fault (5)
(an empty-string special case treating `Some("")` as absent). EC-X.7.002-6's own comparison to `jr queue`/`jr
requesttype`'s existing empty-string pass-through, and its "Jira's response, not `jr`, decides
whether that is an error" clause, are (informational, inherited -- precedent/rationale for the
pass-through choice; not independently tested by this story). Everything the cited clause(s) specify is binding in its
entirety and must be implemented exactly as written there; this story does not restate or
narrow any of it. Story-specific: the
two argv cells are part of AC-001's single inline `#[test]` function (no separate test); the
VP(b) cell is part of AC-003's `proptest!` block (no separate test); the VP(c) cell is its own
hermetic `#[tokio::test]` function in `tests/user_list_project_resolution.rs` (Task 5).
Classification (fixed in F3 review; see revision history): the argv cells are WIRING-EXEMPT / GREEN-at-stub
(Task 7(a)) -- bundled into AC-001's inline test, which depends on Task 1's stub for its
zero-flag `None` cell. The VP(c) wiremock cell is GREEN-nonexempt (`rationale_category:
PRE-EXISTING-BEHAVIOR`, Task 7(a-ii)) -- it resolves via clap propagation alone and
short-circuits straight to HTTP, but it already passes against the pre-story code (the local
`--project ""` flag alone satisfies today's required `String` field with an empty value), so it
is not WIRING-EXEMPT and stays in the Red Gate denominator. The VP(b) proptest cell shares
AC-003's RED-at-stub classification (Task 7(b)) since it is part of the same
unconditional-`todo!()` proptest block -- unaffected by this correction.

### AC-007 (traces to BC-X.7.002 Postcondition 5 [CC:L805])
Once resolved (by any of steps 1-3), every request carries `projectKeys=<resolved-key>`: exactly one `GET /rest/api/3/user/assignable/multiProjectSearch` on the default (non-`--all`) path (BC-X.7.003's unchanged single-call contract); `--all` paginates one-or-more offset pages of the same endpoint, every page carrying the same `projectKeys` value.
**Test:** Implements VP-USER-LIST-PROJECT-001(c)'s `--all` pagination cells
[CC:L886-894]. Its non-`--all` contract sentence [CC:L894] is informational here -- kept as a
CC tag only because no other AC cites L894, not because this AC's own tests verify it:
"The non-`--all` path keeps BC-X.7.003's single-request contract" is NOT verified by this AC's
own tests, which are both `--all` cells -- it is verified by the VP(c) EC-X.7.002-1, EC-X.7.002-3 "both", EC-X.7.002-5,
and EC-X.7.002-6 cells' "exactly one request" assertions, owned respectively by AC-005, AC-003,
AC-009, and AC-006 (each of those cells' own non-`--all` invocation is what demonstrates the
exactly-one-request property this citation states). Also implements the fault models this AC's
tests kill [CC:L902-909]: fault (4) (the resolved key applied to page 1 only) and, jointly with
AC-003, fault (2) (`handle_list` bypassing the resolver -- this AC's configured-default `--all`
cell is one of the tests that kills it). Everything the cited clause(s) specify is binding in its
entirety and must be implemented exactly as written there; this story does not restate or
narrow any of it.
Story-specific: two `--all` pagination `#[tokio::test]` functions in `tests/user_pagination.rs`
(Task 5), modeled on the file's existing `tests/user_pagination.rs::user_list_all_cli_paginates`
three-page pattern -- one with the global flag, one with the configured default. Both build
their own `Command`, hermetic per `verification-delta.md` §2 (all steps, binding) -- NOT the
file's existing non-hermetic `tests/user_pagination.rs::jr_cmd_json` helper, which sets only
`JR_BASE_URL`/`JR_AUTH_HEADER` with no config/cache isolation. Classification: the
global-flag variant is WIRING-EXEMPT / GREEN-at-stub (resolves via clap propagation alone);
the configured-default variant is RED-at-stub (hits the `None` arm, Task 7(b)).

### AC-008 (traces to BC-X.7.002 Fix step 1 [CC:L759-774] (pinned help text portion), VP-USER-LIST-PROJECT-001(d) [CC:L895-901])
`jr user list --help` exits 0 and its stdout (whitespace-collapsed) contains the VP(d) test substrings: `"Project key (overrides the configured default project). Required when no project is configured in"` and `"or the active profile"`. These two substrings are the test's own pin, not the full pinned wording -- the exact full-string match (BC-X.7.002 Fix step 1's pinned exact string, `cross-cutting.md` ~L772-773) is enforced at PR review, not by this AC's automated test.
**Test:** Implements VP-USER-LIST-PROJECT-001(d) in full [CC:L895-901]; this
AC's own body above states BC-X.7.002 Fix step 1's pinned help text, not a VP-cell paraphrase,
per the D-386 carve-out. Everything the cited clause(s) specify is binding in its entirety and
must be implemented exactly as written there; this story does not restate or narrow any of it.
Story-specific: one `--help` `#[test]` function (fixed in F3 review, see revision history -- this cell spawns
`jr user list --help` as a plain subprocess and asserts on its stdout; it makes no wiremock
server call and needs no async runtime) in
`tests/user_list_project_resolution.rs` (Task 5). Classification: RED-at-stub (Task 7(b)) --
the only bucket-(b) cell that never reaches the `None` arm or any `todo!()`; it is RED only
because the pinned help wording isn't added until Task 8.

### AC-009 (traces to BC-X.7.002 Fix step 3 [CC:L776], Invariants [CC:L808-810], EC-X.7.002-5 [CC:L817])
`cli::user::handle` gains a `&Config` parameter, threaded from `src/main.rs`'s already-loaded `config` binding (`Config::load_with(cli.profile.as_deref())`) -- `handle`/`handle_list` MUST NOT call `Config::load`/`Config::load_with` themselves, or `--profile`/`JR_PROFILE` selection would be silently ignored.
**Test:** Implements BC-X.7.002 Fix step 3 [CC:L776] (the `&Config`-threading + no-reload
requirement) jointly with Fix step 4 [CC:L777-779] (shared ownership with AC-003 above -- the
resolver this AC's `&Config` threading feeds) and Fix step 5 [CC:L780] (informational,
inherited -- explains why no separate `cli.project` fallback parameter is added, since clap has
already resolved local-or-global onto `UserCommand::List.project` by the time this AC's handler
runs; enforced by code review -- no `cli.project` parameter is added to the `Command::User` arm
in `src/main.rs`, unlike the `Project`/`Issue`/`Board`/`Sprint`/`Queue`/`RequestType`/`Field`/
`Component` arms Fix step 5 itself names as the pattern this story deliberately does not
replicate; the sibling "don't pass it" group Fix step 5 also names -- `Worklog`, `Team`, `User`,
`Api`, `Assets`, `Me` -- already includes `User`, confirming this story's chosen no-fallback-
parameter design matches the group `Command::User` already belongs to, rather than requiring a
new deviation). Implements VP-USER-LIST-PROJECT-001(c)'s EC-X.7.002-5 cell [CC:L881-884] (shared ownership
with AC-003 above -- one physical test satisfies both ACs) -- this same cell is what verifies
Fix step 3's no-reload requirement, via the fault (3) kill described next. Also implements the
fault models this AC's tests kill [CC:L902-909]: fault (3) (the handler reloading config instead
of using the passed `&Config`). This AC's header also cites BC-X.7.002 Invariants [CC:L808-810]: the "no new
Config/ProfileConfig accessor, no new cache file" structural constraint is informational,
inherited -- enforced by Architecture Compliance Rules row 5 via code review, not by a
dedicated test; the failure-mechanism-vs-fact behavioral portion is verified by AC-004's
exit-64 path test, not by this AC's EC-5 cell. Everything the cited clause(s) specify is
binding in its entirety and must be implemented exactly as written there; this story does not
restate or narrow any of it. Story-specific:
this is the same hermetic `#[tokio::test]` function
AC-003 cites for its EC-X.7.002-5 cell, in `tests/user_list_project_resolution.rs` (Task 5) --
this cell fails if the handler reloads config instead of using the passed `&Config`.
Classification: RED-at-stub (Task 7(b)).

### AC-010 (traces to BC-X.7.002 Trace, prd-delta.md F4 doc-delta obligation PASS-13/P13-003)
`README.md`'s `jr user list --project FOO` row (~L335) is reworded to show `--project` as optional, reflecting the new fallback to the configured default project rather than implying the flag is required.
**Test:** N/A (doc artifact); presence checked at PR review.

### AC-011 (traces to verification-delta.md §2 "examine_globs" table, D-382)
`.cargo/mutants.toml`'s `examine_globs` array gains `"src/cli/user.rs"` (32 -> 33 entries, verified by actual count, not the policy doc's prose number). `docs/specs/cargo-mutants-policy.md` gains the exact §Scope bullet specified in `verification-delta.md` §2:
`` - `src/cli/user.rs` — `resolve_user_list_project` (configured-default fallback for user list's post-clap project value via Config::project_key; local-vs-global precedence is clap global-value propagation) (added cycle-014) ``,
inserted directly after the existing `src/jql.rs` bullet (verified: that bullet ends at line 89, immediately followed by a blank line at line 90 and the `**FIX-F7-001 deferred, not added:**` paragraph at line 91 -- both still inside `## Scope`, which runs through line 149; `### Sibling Candidates Considered and Deferred` starts at line 150). The new bullet MUST land before that blank line/paragraph and therefore before line 150 -- `scripts/check-cargo-mutants-policy-citations.sh`'s §Scope extraction (`awk` range `/^## Scope$/` through the first `^## ` or `^### Sibling Candidates`, ~L41-46) stops parsing at line 150 and would silently false-green a bullet placed at or after it. Its "Current `examine_globs` count" line (line 113) changes 32 -> 33, and a new newest-first row is added to the `## Changelog` table (`## Changelog` header at line 1583, top data row at line 1587). Per `scripts/check-cargo-mutants-policy-citations.sh` (~L137-153), the bullet's parenthetical description must not backtick any other lowercase identifier -- e.g. do not write `` (wraps `Config::project_key`) `` -- because every backtick token matching `^[a-z_][a-z0-9_]*$` is treated as a function-name citation requiring its own definition line in the cited file. Running `scripts/check-cargo-mutants-policy-citations.sh` before this story's edit reports `Check passed: 29 bullets parsed, 98 (file, fn) pairs validated` (verified); after the edit it must report exactly 30 bullets parsed (one more, not two, and not zero) -- a bullet count that doesn't move by exactly +1 means the insertion landed in the wrong place or was malformed. Because inserting the new §Scope bullet shifts every subsequent line in the file down by one, verify the current line numbers for the count line (nominally 113) and the `## Changelog` header/top data row (nominally 1583/1587) immediately before each of those edits -- in file order (bullet insert first, then the count-line edit, then the Changelog row) -- rather than relying on this story's pinned numbers once an earlier edit in this same sequence has already landed.
**Test:** N/A (config/doc); `tests/mutants_glob_existence.rs` passes automatically since the file already exists; `scripts/check-cargo-mutants-policy-citations.sh` passes since `resolve_user_list_project` is defined in the same PR, AND its "N bullets parsed" success line reads 30 (was 29 pre-edit).

## Coverage Scope (D-387)

Per human decision D-387 (2026-09-28), the hand-written `## Clause Coverage Map (D-386)` table
is deleted -- its hand-maintained rows kept drifting from the AC `[CC:...]` citations that are
now the single source of truth (see the story's `## Revision History` section and
`S-cycle14-user-list-project-resolution.revision-history.md` for the full account). This section
instead declares which spans of
`.factory/specs/prd/cross-cutting.md` are in scope for this story, and which lines within those
spans are excluded from requiring an owning AC. Ownership itself is recorded only in each
`### AC-NNN` section's `[CC:L<start>-<end>]` tags, not here.

[SCOPE:L753-754] BC-X.7.002 Behavior statement
[SCOPE:L759-780] BC-X.7.002 Fix steps 1-5
[SCOPE:L782-786] BC-X.7.002 Resolution order (steps 1-4)
[SCOPE:L788-793] BC-X.7.002 precedent paragraph (local-over-global precedent parity with `component create`; scopes what BC-8.1.004 covers)
[SCOPE:L796-798] BC-X.7.002 Preconditions
[SCOPE:L801-805] BC-X.7.002 Postconditions 1-5
[SCOPE:L808-810] BC-X.7.002 Invariants
[SCOPE:L813-836] BC-X.7.002 Edge Cases (EC-X.7.002-1..7)
[SCOPE:L839-843] VP-USER-LIST-PROJECT-001 preamble
[SCOPE:L844-857] VP-USER-LIST-PROJECT-001 (a) Clap propagation pin
[SCOPE:L858-868] VP-USER-LIST-PROJECT-001 (b) Pure resolver proptest
[SCOPE:L869-871] VP-USER-LIST-PROJECT-001 (c) intro (wiring layer)
[SCOPE:L872-894] VP-USER-LIST-PROJECT-001 (c) cells (EC-X.7.002-1..6 wiring + `--all` pagination + non-`--all` contract)
[SCOPE:L895-901] VP-USER-LIST-PROJECT-001 (d) Help-text pin
[SCOPE:L902-909] VP-USER-LIST-PROJECT-001 fault model

[EXCLUDE:L746] BC-X.7.002 H1 heading -- section title, no independent clause content
[EXCLUDE:L747-749] superseded pre-cycle-014 "Previous version" note -- historical/informational context, not a current requirement
[EXCLUDE:L750-752] Confidence/Source/Subject -- pure metadata prose
[EXCLUDE:L755] blank separator line
[EXCLUDE:L756] Root-cause paragraph -- pure rationale/context prose (D-387's own named example: Root-cause)
[EXCLUDE:L757] blank separator line
[EXCLUDE:L758] "Fix:" section label heading
[EXCLUDE:L781] blank separator line
[EXCLUDE:L787] blank separator line
[EXCLUDE:L794] blank separator line
[EXCLUDE:L795] "**Preconditions**:" section label heading
[EXCLUDE:L799] blank separator line
[EXCLUDE:L800] "**Postconditions**:" section label heading
[EXCLUDE:L806] blank separator line
[EXCLUDE:L807] "**Invariants**:" section label heading
[EXCLUDE:L811] blank separator line
[EXCLUDE:L812] "**Edge Cases**:" section label heading
[EXCLUDE:L837] blank separator line
[EXCLUDE:L838] "**Verification Properties**:" section label heading
[EXCLUDE:L910] blank separator line
[EXCLUDE:L911-919] Trace field -- traceability metadata (issue/file references), not a behavioral clause

Ownership is recorded solely by the `[CC:...]` citations in each AC's header and `**Test:**`
body; coverage (every SCOPE line minus EXCLUDE is inside some AC's `[CC:...]` range) is
verified mechanically per D-387.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `resolve_user_list_project` | `src/cli/user.rs` | Pure (no I/O; wraps `Config::project_key`) |
| `UserCommand::List.project` type change | `src/cli/mod.rs` | Pure (clap derive declaration) |
| `handle` / `handle_list` `&Config` threading | `src/cli/user.rs` | Effectful-shell (HTTP call site; the resolver itself is pure) |
| `Command::User` dispatch arm | `src/main.rs` | Effectful-shell (wiring only, no new logic) |

Reference: `architecture/module-decomposition.md`, `architecture/dependency-graph.md` (no module-boundary change; F1 confirmed no architecture delta for this cycle).

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-X.7.002-1 | Both local AND global `--project` supplied | LOCAL wins, via clap propagation |
| EC-X.7.002-2 | Global `--project` only | Resolves via clap propagation (the reported #862 bug) |
| EC-X.7.002-3 | Configured default only (`.jr.toml` or profile) | Resolves via `Config::project_key`'s fallback chain |
| EC-X.7.002-4 | None of the three present | Exit 64, pinned message, zero HTTP |
| EC-X.7.002-5 | No local/global flag, non-default `--profile` with its own configured default, no `.jr.toml` ancestor | That profile's own default resolves (requires passing `&Config` without reload) |
| EC-X.7.002-6 | `--project ""` (local or global) | Passes through as `Some("")`, configured default NOT consulted (D-380) |
| EC-X.7.002-7 | Configured empty project default (`.jr.toml`/profile `project = ""`), no local/global flag | Resolves to `Some("")` via `Config::project_key`; no exit 64 (informational, no dedicated VP cell) |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `resolve_user_list_project` (`src/cli/user.rs`) | pure-core | No I/O; wraps `Config::project_key` |
| `UserCommand::List` clap declaration (`src/cli/mod.rs`) | pure-core | Derive-macro declaration, no I/O |
| `handle` / `handle_list` (`src/cli/user.rs`) | effectful-shell | Performs the HTTP request once the project key is resolved |
| `main.rs`'s `Command::User` dispatch arm | effectful-shell | Constructs `Config`/`JiraClient` and dispatches |

## Token Budget Estimate

**Re-measured after the F3 revision-history split (2026-09-28):** the pre-split file required
paging on a full Read-tool call, reporting ~43,589 tokens for the whole file. Moving the ten
historical Revision Note sections out to
`S-cycle14-user-list-project-resolution.revision-history.md` reduced the story spec's size
substantially. Applying the pre-split file's own measured chars-per-token ratio to the
post-split file gives ~25,000 tokens for this row (approximate; drifts with edits). The other
three rows are unchanged from the prior estimate. (Exact line/character counts are intentionally
omitted here -- they drift with every edit; only the token estimates are load-bearing for the
budget-usage row below.)

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~25,000 (approximate; drifts with edits) |
| Referenced code (`src/cli/mod.rs` `UserCommand::List` region, `src/cli/user.rs` full file, `src/main.rs`'s `Command::User` arm, `src/config.rs::project_key`, `src/cli/component.rs::handle` List/Create arms as precedent, `src/cli/field.rs::resolve_m2_project` as signature precedent) | ~3,000 |
| Test files (`tests/user_commands.rs`, `tests/all_flag_behavior.rs:~260-`, `tests/user_pagination.rs` -- grep-scoped) | ~2,000 |
| Tool output overhead | ~1,000 |
| **Total** | **~31,000** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~16%** |

## Tasks

1. [ ] **STUB (compile-only; no behavior change yet):** change `UserCommand::List.project`
   (`src/cli/mod.rs`, ~L1148) from clap-REQUIRED `String` to `Option<String>`, keeping
   `#[arg(long, short = 'p')]` (including `short = 'p'`) unchanged; add
   `pub(crate) fn resolve_user_list_project(cli_project: Option<&str>, config: &Config) ->
   Option<String>` to `src/cli/user.rs` with a `todo!()` body; add a `&Config` parameter to
   `handle`/`handle_list`; thread the already-loaded `config` binding from `src/main.rs`'s
   `Command::User` dispatch arm. `handle_list`'s stub wiring MUST short-circuit around the
   `todo!()`: when the post-clap `project` field is already `Some(p)` (local flag, global
   flag, or both -- clap propagation has already resolved local-vs-global precedence by this
   point), send `p` straight into the existing HTTP path unchanged; call the still-stubbed
   `resolve_user_list_project` ONLY on the `None` arm (approach (a), mirroring
   `S-cycle14-api-query-param`'s Task 1 zero-flag short-circuit around its two stubs). No
   pinned help text, exit-64 message, or real resolution logic yet -- the only bar is
   `cargo build` succeeding -- `stub-architect`
2. [ ] Grep `tests/` for any literal assertion tied to `UserCommand::List.project`'s clap-required behavior beyond `tests/user_commands.rs::user_list_requires_project_flag` -- `test-writer`

   **D-386/D-387 binding instruction (applies to Tasks 3-6):** before writing any cell, the
   test-writer MUST read VP-USER-LIST-PROJECT-001's cited clause(s) (`.factory/specs/prd/cross-cutting.md`
   ~L838-909) in full, per the AC each task implements (see each `### AC-NNN` section's
   `[CC:L<start>-<end>]` tags -- header and `**Test:**` body -- for the exact clause/cell each AC
   owns; per D-387, ownership is no longer recorded in a separate map). The VP text in
   `cross-cutting.md`, not this story, is the source of truth for cell contents -- this story's
   AC Test lines bind to that text by reference and do not restate it.
3. [ ] Write the inline `Cli::try_parse_from` unit test in `src/cli/mod.rs`'s existing
   `#[cfg(test)] mod tests` block (AC-001, AC-005, AC-006) -- `test-writer`
4. [ ] Write the `proptest!` on `resolve_user_list_project` in `src/cli/user.rs`'s
   `#[cfg(test)]` module (AC-003, AC-006) -- `test-writer`
5. [ ] Write the hermetic wiremock integration cells in a new file,
   `tests/user_list_project_resolution.rs`: EC-X.7.002-1/2/3 (x3 sub-cells)/5/6, and the
   `--help` cell (AC-002, AC-003, AC-005, AC-006, AC-008); write the two `--all` pagination
   cells (AC-007) in `tests/user_pagination.rs`, modeled on (not reusing) the existing
   `tests/user_pagination.rs::user_list_all_cli_paginates` three-page pattern, each built with
   its own `verification-delta.md` §2 hermetic setup rather than the file's non-hermetic
   `tests/user_pagination.rs::jr_cmd_json` helper -- `test-writer`
6. [ ] Make `tests/user_commands.rs::user_list_requires_project_flag` hermetic per
   `verification-delta.md` §2 (no rename); update its stale
   `// No server needed — clap should fail before any HTTP call.` comment (note: the file uses
   an em dash, not a double-hyphen); add a new, separate hermetic EC-X.7.002-4 wiremock cell in
   the same file per VP-USER-LIST-PROJECT-001(c) EC-4 (`cross-cutting.md`, binding) asserting
   the byte-identical pinned exit-64 message (AC-004) -- `test-writer`
7. [ ] Confirm Red Gate against the Task 1 stub, reclassified for the corrected stub shape
   (Task 1's `Some(p)` short-circuit means any cell that resolves `project` to `Some(...)` at
   the CLI-parse level bypasses `resolve_user_list_project` entirely and hits the unchanged
   HTTP path -- it is GREEN at stub, not a Red Gate signal, even though it is new test code).
   Classify against the orchestrator playbook's actual formula
   (`workflows/phases/per-story-delivery.md` Red Gate Density Check, ~L45-64):
   `RED_RATIO = RED_TESTS / (TOTAL_NEW_TESTS - EXEMPT_TESTS)`, where
   `EXEMPT_TESTS = GREEN-BY-DESIGN_count + WIRING-EXEMPT_count` is subtracted from the
   DENOMINATOR (not the numerator -- a GREEN cell is never counted in `RED_TESTS` to begin
   with, so "excluding it from the numerator" is a no-op; each cell below that is GREEN only
   because Task 1's stub wiring makes it so must be mapped to a category that removes it from
   the denominator, while a cell that is GREEN independently of the stub -- because it already
   passes pre-story -- stays in the denominator as GREEN-nonexempt (fixed in F3 review; see revision history),
   per the (a-ii) bucket below):

   (a) **GREEN at stub -> WIRING-EXEMPT (red-gate-log.md table label `FRAMEWORK-WIRING`),
   removed from the DENOMINATOR per BC-5.38.003:** each cell below passes as soon as Task 1's
   stub wiring (the `String` -> `Option<String>` type change plus its `Some(p)` short-circuit)
   exists, not because of any premature implementation of `resolve_user_list_project` (which
   stays an unconditional `todo!()` throughout this bucket's cells) -- this is exactly
   BC-5.38.003's "passes as soon as the correct type signature exists in the stub" test:
   - the clap-propagation `Cli::try_parse_from` cells (AC-001, AC-005, AC-006) -> parser-only,
     never call `resolve_user_list_project`/`handle_list`. All four flag-presence cells plus
     the `-p` short-alias cells live in ONE `#[test]` function (VP-USER-LIST-PROJECT-001(a) is
     a single inline test asserting multiple argv-vector cells in its body) -- count this as
     **1 test**, not one per cell;
   - EC-X.7.002-2's wiremock cell (AC-002, global only -> FOO) -> resolves to `Some(...)` via
     clap propagation alone and short-circuits straight to HTTP; this is in fact the #862 bug
     fix itself, delivered by Task 1's `String` -> `Option<String>` type change, not by the
     resolver (**1 test**);
   - AC-007's global-flag `--all` pagination cell (`jr --project FOO user list --all`) ->
     same short-circuit reasoning (**1 test**);
   - the pre-existing tests that always pass `--project` explicitly and therefore never reach
     the resolver, at stub or after: `tests/user_commands.rs::user_list_by_project_returns_users`,
     `tests/user_pagination.rs::user_list_all_cli_paginates` and its sibling cap-hitting test
     `tests/user_pagination.rs::user_list_all_cli_emits_safety_cap_warning`, and
     `tests/all_flag_behavior.rs::user_list_default_caps_at_thirty` -> these are the file's
     genuine, UNMODIFIED before/after regression guards, GREEN unconditionally throughout.
     **These are NOT counted at all**, in either bucket and not as
     `EXEMPT_TESTS` either: per the formula's own definition, `TOTAL_NEW_TESTS` is "the count of
     all tests introduced in this story's delivery" -- these four were never introduced by this
     story, so they never enter `TOTAL_NEW_TESTS` in the first place. This is a distinct
     exclusion path from `EXEMPT_TESTS` (which subtracts *new* tests that are structurally
     GREEN-by-design from an otherwise-counted denominator).

   (a-ii) **GREEN, but not because of Task 1's stub -- GREEN-nonexempt
   (`rationale_category: PRE-EXISTING-BEHAVIOR`), counted in `TOTAL_NEW_TESTS` and in the
   denominator, never in `RED_TESTS` or `EXEMPT_TESTS` (fixed in F3 review; see revision
   history):** each cell below
   already passes against the PRE-STORY code -- before Task 1's `String` -> `Option<String>`
   change exists at all -- because it supplies the local `--project` flag directly, which
   already satisfies today's clap-REQUIRED `String` field on its own. Unlike the
   WIRING-EXEMPT cells above, these do not depend on Task 1's stub wiring for their GREEN
   status; they were verified GREEN by running the pre-story binary directly:
   - EC-X.7.002-1's wiremock cell (AC-005, `jr --project GLOBAL user list --project LOCAL`,
     both flags -> LOCAL) -> the local `--project LOCAL` flag alone already satisfies the
     pre-story required `String` field; verified pre-story via
     `jr --project GLOBAL user list --project LOCAL --no-input`, which clears clap parsing and
     reaches the HTTP/auth layer today, not clap's required-argument error (**1 test**);
   - EC-X.7.002-6's wiremock cell (AC-006, `jr user list --project ""`, empty string) -> the
     local `--project ""` flag alone already satisfies the pre-story required `String` field
     with an empty value; verified pre-story via `jr user list --project "" --no-input`, which
     likewise clears clap parsing and reaches the HTTP/auth layer today (**1 test**).

   (b) **RED at stub -- genuine Red Gate signal (`todo!()` panic or missing pinned
   behavior/text), counted in `RED_TESTS`:**

   **Failure mechanism, stated explicitly per cell (ADV-C14-F3-P5-004):** Task 1's stub is a
   stub-architect `todo!()` stub per BC-5.38.001, so a `todo!()` panic reached via the `None`
   arm IS the expected Red signal for every cell below that hits it -- not a defect requiring a
   test-writer re-dispatch. The `resolve_user_list_project` proptest calls the stub directly
   in-process, so `cargo test` reports the raw panic message ("not yet implemented", plus
   file/line) as that test's own failure. Every wiremock/integration cell below instead spawns
   `jr` as a subprocess: the child process panics on the `None` arm and exits 101 (Rust's
   default panic exit code) with the `todo!()` message on its stderr -- it is THAT mismatch
   (actual exit 101 / raw panic text vs. the cell's real assertion, e.g. an expected exit 64 or
   a pinned stderr/request pattern) that fails the test, never the literal panic text being
   asserted on directly. AC-008's `--help` cell is the one exception in this bucket: it never
   reaches the `None` arm or any `todo!()` at all -- it fails on a behavioral assertion (the
   pinned help wording is simply absent until Task 8). The orchestrator MUST NOT re-dispatch
   the test-writer for any of the `todo!()`-panic/exit-101 cells listed below; AC-008 is the
   only cell in bucket (b) whose RED status could indicate a genuine test-writer gap.

   - the `resolve_user_list_project` proptest (AC-003, AC-006) -- **fails via a direct
     in-process `todo!()` panic**: every direct call panics regardless of its arguments, since
     the stub body is unconditional `todo!()` (**1 test**, one `proptest!` block);
   - EC-X.7.002-3's three wiremock sub-cells (AC-003: `.jr.toml`-only, profile-only, both) --
     **fail via the child `jr` subprocess's `todo!()` panic (exit 101)**: `project` is `None` at
     `handle_list`'s entry, so the `None` arm reaches the stub (**3 tests**);
   - EC-X.7.002-4's new wiremock cell (AC-004) and EC-X.7.002-5's wiremock cell (AC-009) --
     **fail via the same subprocess `todo!()` panic / exit-101 mechanism**, same `None`-arm
     reasoning (**2 tests**);
   - AC-007's configured-default `--all` pagination cell (`jr user list --all`, no flag) --
     **fails via the same subprocess `todo!()` panic / exit-101 mechanism**, same `None`-arm
     reasoning (**1 test**);
   - AC-008's `--help` cell -- **fails on a behavioral assertion, not a `todo!()` panic**:
     `--help` exits 0 before `handle_list`/the resolver ever runs, so this cell is independently
     RED only because the pinned help wording isn't added until Task 8; unaffected by the
     resolver's stub shape either way (**1 test**);
   - `tests/user_commands.rs::user_list_requires_project_flag` (hermetic, per Task 6) --
     **fails via the same subprocess `todo!()` panic / exit-101 mechanism as the cells above**:
     this is NOT a before/after regression guard, unlike the four unmodified tests excluded
     in (a) above -- it IS substantively modified by this story's Task 6 hermeticity rewrite, so
     it counts as **1 test** in this story's tally rather than as an out-of-scope pre-existing
     test. Pre-story it is GREEN (clap's own "required" rejection). At the Task 1 stub it goes
     RED: its no-`--project` invocation now reaches the `None` arm, the child process panics via
     `todo!()` and exits 101, and its stderr ("not yet implemented", plus file/line) satisfies
     neither half of the test's existing `stderr.contains("--project") || stderr.contains
     ("required")` assertion. It returns to GREEN only once Tasks 9-10 land the real resolver and
     the pinned exit-64 message (which does contain the literal substring `--project`,
     satisfying the same loose assertion). Count it among the RED-at-stub cells, alongside
     AC-004's new cell.

   **Density tally:**

   | Category | Count | Tests |
   |----------|-------|-------|
   | `RED_TESTS` | 9 | proptest (1) + EC-X.7.002-3 subcells (3) + EC-X.7.002-4 (1) + EC-X.7.002-5/AC-009 (1) + AC-007 configured-default `--all` (1) + `--help`/AC-008 (1) + `user_list_requires_project_flag` reclassified (1) |
   | `EXEMPT_TESTS` (all `WIRING-EXEMPT`) | 3 | `Cli::try_parse_from` (1 function) + EC-X.7.002-2 (1) + AC-007 global-flag `--all` (1) |
   | `GREEN-nonexempt` (all `PRE-EXISTING-BEHAVIOR`; fixed in F3 review, see revision history) | 2 | EC-X.7.002-1 (1) + EC-X.7.002-6 (1) -- pass pre-story already, counted in `TOTAL_NEW_TESTS` and the denominator, never in `RED_TESTS` or `EXEMPT_TESTS` |
   | Excluded entirely (not new tests) | 4 | `user_list_by_project_returns_users`, `user_list_all_cli_paginates`, its cap-hitting sibling, `user_list_default_caps_at_thirty` -- never enter `TOTAL_NEW_TESTS` |
   | `TOTAL_NEW_TESTS` | 14 | `RED_TESTS` (9) + `EXEMPT_TESTS` (3) + `GREEN-nonexempt` (2); the 4 excluded-entirely tests are NOT added here |
   | Denominator (`TOTAL_NEW_TESTS - EXEMPT_TESTS`) | 11 | 14 - 3 |
   | **`RED_RATIO`** | **9 / 11 ≈ 0.82** | Clears the BC-8.29.001 threshold `RED_RATIO >= 0.5` (integer-precise check: `9 * 2 = 18 >= 11` holds) |

   Denominator is nonzero (11), so this is not the Full-Exception Path, and RED_RATIO clears the
   threshold without invoking either Remediation Option A or B.
8. [ ] Finalize the `help` text to BC-X.7.002 Fix step 1's pinned exact string
   (cross-cutting.md ~L772-773), byte-for-byte; AC-008's two substrings are the test pin, not
   the full wording (the `String` -> `Option<String>` type change already landed in Task 1)
   (AC-008) -- `implementer`
9. [ ] Replace `resolve_user_list_project`'s `todo!()` with its real body
   (`config.project_key(cli_project)`). Remove Task 1's stub-stage `Some(p)` short-circuit in
   `handle_list`: per BC-X.7.002 Fix step 4, `handle_list` now calls
   `resolve_user_list_project(project.as_deref(), config)` unconditionally with the post-clap
   field value (not only on the `None` arm), using its already-threaded (Task 1) `&Config`
   (AC-003, AC-009) -- `implementer`
10. [ ] Implement the exit-64 path with the pinned message (AC-004) -- `implementer`
11. [ ] Confirm Green Gate: all tests pass
12. [ ] Update `README.md`'s `jr user list --project FOO` row (~L335) (AC-010)
13. [ ] Add `src/cli/user.rs` to `.cargo/mutants.toml` `examine_globs`; in
    `docs/specs/cargo-mutants-policy.md`, insert the new §Scope bullet directly after the
    existing `src/jql.rs` bullet (ends line 89) and before the blank line at 90 /
    `**FIX-F7-001 deferred, not added:**` paragraph at 91 -- NOT below `### Sibling Candidates`
    at line 150, which `scripts/check-cargo-mutants-policy-citations.sh`'s §Scope-range `awk`
    (~L41-46) stops parsing at; bump the "Current `examine_globs` count" line (113) 32->33; add
    a newest-first `## Changelog` row (table starts line 1583); then run
    `scripts/check-cargo-mutants-policy-citations.sh` and confirm its reported bullet count
    goes up by exactly one (29 -> 30) (AC-011). Verify current line numbers immediately before
    each edit (they shift by +1 after the bullet insert): re-check the count-line location
    (nominally 113) and the `## Changelog` header/top-row locations (nominally 1583/1587)
    after the bullet insert lands, rather than relying on this story's pinned numbers
14. [ ] Add a CHANGELOG entry under `[Unreleased] > Fixed` describing the shipped behavior,
    before creating the PR. Per precedent (CHANGELOG.md ~L125's `--recent`/`--updated-recent`
    entry and ~L543's `load_api_token` entry), flag the failure-mode change inline as a
    breaking change: an invocation with no local/global `--project` and no configured default --
    previously a clap exit-2 "required argument" error -- now fails with `jr`'s exit-64
    `JrError::UserError`; global-only and configured-default invocations (previously exit 2) now
    succeed. E.g. `` **Breaking: `jr user list` with no project resolvable now exits 64, not
    clap's exit 2** (issue #862) ``, followed by the four-step resolution order and the pinned
    exit-64 message
15. [ ] Run `cargo fmt --all -- --check`, `cargo clippy -- -D warnings`, `cargo test`, and the scoped `cargo mutants --in-diff`

## Previous Story Intelligence

N/A -- first story in cycle-014's serial delivery chain (A -> C -> B, D-381); no cycle-014
predecessor exists yet. Cross-cycle precedent is captured in the table below.

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|-----------------|--------------------------|------------------------|
| S-580-1 (delivered, `src/cli/field.rs::resolve_m2_project`, BC-X.14.001's M2 project-resolution step) | Established the pure-resolver-plus-`&Config`-threading pattern this story mirrors; `resolve_user_list_project`'s signature is deliberately styled after it | `src/cli/component.rs::handle`'s `List`/`Create` arms are the codebase's other local-over-global precedent (explicit `.or()`/`or_else()` merge code, for a variant that does NOT rely on clap propagation) | This story's variant DOES rely on clap propagation instead of an explicit merge, so no equivalent merge code is written; do not copy `component.rs`'s explicit merge pattern here |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| `handle`/`handle_list` MUST NOT call `Config::load`/`Config::load_with` -- only the `&Config` passed from `main.rs` may be consulted | BC-X.7.002 Fix step 3, EC-X.7.002-5 | AC-009's EC-X.7.002-5 test fails if the handler reloads config |
| Local-vs-global precedence is clap's own `fill_in_global_values` propagation -- no hand-written `jr`-level merge/`.or()` call is added for this half of the resolution | BC-X.7.002 Fix step 2, precedent paragraph, EC-X.7.002-1 (P22-005: corrected from "Behavior, Fix step 2" -- verified against L775 (Fix step 2), L788-793 (precedent paragraph), and L813 (EC-X.7.002-1); the general Behavior statement at L753-754 doesn't itself name the local-vs-global mechanism) | Code review; AC-001/AC-005 tests pass without any merge code in `handle_list` |
| The canonical no-project exit-64 message MUST be byte-identical to `queue.rs`/`requesttype.rs`'s existing wording | BC-X.7.002 Postcondition 4 | AC-004 |
| `--project ""` MUST NOT be special-cased to `None` (treated as absent) | BC-X.7.002 EC-X.7.002-6, D-380 | AC-006 |
| No new `Config`/`ProfileConfig` accessor and no new cache file -- reuse `Config::project_key` exactly | BC-X.7.002 Invariants | Code review |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| `clap` (`features = ["derive"]`, existing pin in `Cargo.toml`: `version = "4"`) | `4.6.7` (resolved via the existing pin, per the lockfile cited throughout `cross-cutting.md`; no new dependency, no version change) | Global-value propagation (`fill_in_global_values`) fills the local `--project` field from the global flag when the local flag is absent -- the mechanism this story's local-over-global and global-fallback resolution steps rely on |

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/cli/mod.rs` | modify | `UserCommand::List.project: String -> Option<String>`; help text update (AC-001, AC-008); inline `Cli::try_parse_from` unit test added to the existing `#[cfg(test)] mod tests` block |
| `src/main.rs` | modify | `Command::User` dispatch arm threads the already-loaded `config` binding through (AC-009) |
| `src/cli/user.rs` | modify | `handle`/`handle_list` gain `&Config`; new `resolve_user_list_project`; exit-64 message (AC-003, AC-004, AC-009); `proptest!` on `resolve_user_list_project` added to its `#[cfg(test)]` module |
| `tests/user_commands.rs` | modify | Hermetic isolation for `user_list_requires_project_flag` (no rename); new EC-X.7.002-4 regression cell; stale comment fix (AC-004) |
| `tests/user_list_project_resolution.rs` | create | New hermetic wiremock file for EC-X.7.002-1/2/3 (x3)/5/6 and the `--help` cell (AC-002, AC-003, AC-005, AC-006, AC-008) |
| `tests/user_pagination.rs` | modify | Two new `--all` pagination cells (AC-007) |
| `tests/all_flag_behavior.rs` | modify (conditional, only if Task 2's grep finds a stale assertion) | Update any literal assertion tied to the old clap-required behavior |
| `README.md` | modify | `jr user list --project FOO` row (~L335) reworded (AC-010) |
| `.cargo/mutants.toml` | modify | Add `src/cli/user.rs` to `examine_globs` (32->33) (AC-011) |
| `docs/specs/cargo-mutants-policy.md` | modify | §Scope bullet inserted directly after the `src/jql.rs` bullet, line 89, before line 150's `### Sibling Candidates` heading + count line (113) 32->33 + `## Changelog` row (table starts line 1583) (AC-011) |
| `CHANGELOG.md` | modify | `[Unreleased] > Fixed` entry |

## Definition of Done

- [ ] All 11 ACs pass their listed tests
- [ ] `cargo fmt --all -- --check` clean
- [ ] `cargo clippy -- -D warnings` clean
- [ ] `cargo test` green (full suite, not just this story's new tests)
- [ ] Scoped `cargo mutants --in-diff` (per CLAUDE.md's `DIFF_FILE=$(mktemp -t pr.diff.XXXXXX) && ... cargo mutants --in-diff "$DIFF_FILE" --jobs 4 --timeout 240`) run against the PR diff, with `src/cli/user.rs` now in `examine_globs` scope
- [ ] `.cargo/mutants.toml` / `docs/specs/cargo-mutants-policy.md` edits verified against `scripts/check-cargo-mutants-policy-citations.sh` and `tests/mutants_glob_existence.rs`
- [ ] CHANGELOG entry present under `[Unreleased] > Fixed`, inline-flagging the clap-exit-2 -> `jr`-exit-64 no-project-resolvable failure mode as a breaking change (Task 14)
- [ ] PR opened against `develop`, following commitizen branch/commit conventions

## Suggested Branch Name

`fix/user-list-project-resolution` (Conventional Commits, per CLAUDE.md's `type/short-description` convention; this is a bug fix, so `fix/`).
