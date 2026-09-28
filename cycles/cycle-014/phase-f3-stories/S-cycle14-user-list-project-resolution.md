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
  - "tests/user_commands.rs"
  - "tests/all_flag_behavior.rs"
  - "README.md"
input-hash: "eb5b8a1"
traces_to: "BC-X.7.002"
cycle: cycle-014-issue-triage-quickfixes
estimated_effort: small
estimated_days: 1
target_module: "src/cli/user.rs, src/cli/mod.rs, src/main.rs"
subsystems: ["SS-02"]
# SS-02 (CLI Layer, src/cli/) owns this story's scope because every file this
# story modifies (src/cli/mod.rs, src/cli/user.rs) lives under src/cli/ per
# ARCH-INDEX's Subsystem Registry (SS-02 row: "CLI Layer | src/cli/"). The
# src/main.rs dispatch-arm edit is a thin threading change into the same
# SS-02-owned handler, not a second subsystem's concern.
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
version: "1.3"
last_updated: "2026-09-27"
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
- **ADV-C14-F3-P4-003 (LOW):** AC-009's Test line and AC-003's `--profile alt` cell mention
  (EC-X.7.002-5) now carry VP-USER-LIST-PROJECT-001(c)'s pinned sub-assertions verbatim from
  `cross-cutting.md` ~L881-884: temp `config.toml` with profile `default` -> `project = "DEF"`
  and profile `alt` -> `project = "ALT"`, both URLs at the mock server, no `.jr.toml`; exactly
  one request with `projectKeys=ALT`, `.expect(0)` on a `projectKeys=DEF` mock. Swept every
  other VP(c) cell (AC-002, AC-003's three subcells, AC-004, AC-005, AC-006, AC-007) -- each
  already carries its VP(c) pin verbatim from the pass-3 fix (ADV-C14-F3-P3-003); no further
  changes needed there.
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

### AC-001 (traces to BC-X.7.002 Fix step 1 / Postcondition 1)
`src/cli/mod.rs::UserCommand::List.project` (~L1148) changes from clap-REQUIRED `String` to `Option<String>`. The `#[arg(long, short = 'p')]` attribute, including `short = 'p'`, is unchanged. When a local `--project` is supplied, `Cli::try_parse_from` resolves it to `Some(value)` regardless of whether a global `--project` or a configured default is also present (local wins unconditionally).
**Test:** inline `Cli::try_parse_from` unit test (one `#[test]` function, VP-USER-LIST-PROJECT-001(a)) asserting all four flag-presence cells plus the retained local `-p` short-alias, using the exact argv vectors from `cross-cutting.md` ~L852-856: `["jr","user","list","-p","L"]` -> `Some("L")`, and `["jr","--project","G","user","list","-p","L"]` -> `Some("L")` (local `-p` wins over the global long form). There is no global `-p` cell -- the global `--project` (`src/cli/mod.rs::Cli.project`, `#[arg(long, global = true)]`) has no short form.

### AC-002 (traces to BC-X.7.002 Postcondition 2, EC-X.7.002-2)
`jr --project FOO user list` (global only, no local flag, no configured default) resolves the local field to `Some("FOO")` via clap's own `fill_in_global_values` propagation -- no `jr`-level local-vs-global merge code is written. This is the exact invocation issue #862 reported as broken (previously clap exit 2).
**Test:** `test_bc_x_7_002_...global_project_only...` wiremock cell, hermetic per `verification-delta.md` §2, asserting exactly one request with `projectKeys=FOO`.

### AC-003 (traces to BC-X.7.002 Postcondition 3, EC-X.7.002-3, EC-X.7.002-5, EC-X.7.002-7)
When both local and global `--project` are absent, `resolve_user_list_project(cli_project: Option<&str>, config: &Config) -> Option<String>` (new `pub(crate)` function in `src/cli/user.rs`) falls back to `Config::project_key`'s existing chain: `.jr.toml` project first, then the active profile's configured `project` default (including a non-default `--profile`'s own default, and including an empty-string configured default, EC-X.7.002-7). `handle_list` calls this resolver with the post-clap field value.
**Test:** `proptest!` over the 2x4 presence-space (VP-USER-LIST-PROJECT-001(b)) + three wiremock cells (`.jr.toml`-only, profile-only, both) + the `--profile alt` cell (EC-X.7.002-5). Per VP-USER-LIST-PROJECT-001(c), the "both" cell configures `.jr.toml` `project = "JRT"` plus profile `project = "FOO"`, asserts exactly one request carrying `projectKeys=JRT`, and mounts a `.expect(0)` counter-mock on `projectKeys=FOO`. The `--profile alt` cell carries VP-USER-LIST-PROJECT-001(c)'s EC-X.7.002-5 pin verbatim (`cross-cutting.md` ~L881-884): temp `config.toml` with profile `default` -> `project = "DEF"` and profile `alt` -> `project = "ALT"`, both URLs at the mock server, no `.jr.toml`; `jr --profile alt user list` with no `--project` -> exactly one request with `projectKeys=ALT`, `.expect(0)` on a `projectKeys=DEF` mock.

### AC-004 (traces to BC-X.7.002 Postcondition 4, EC-X.7.002-4)
When none of {local `--project`, global `--project`, configured default} resolve, `handle_list` exits 64 (`JrError::UserError`) with the byte-identical message `"No project configured. Run \"jr init\" or pass --project. Run \"jr project list\" to see available projects."`, before any HTTP call.
**Test:** `tests/user_commands.rs::user_list_requires_project_flag` (no rename, per F1-gate Open Question 8; made hermetic per `verification-delta.md` §2, keeping its existing unreachable `JR_BASE_URL=http://127.0.0.1:1`) + a new hermetic EC-X.7.002-4 wiremock cell with `.expect(0)` on `multiProjectSearch`.

### AC-005 (traces to BC-X.7.002 EC-X.7.002-1)
`jr --project GLOBAL user list --project LOCAL` resolves to `LOCAL` (local wins over global when both are supplied), via clap propagation, producing the same observable result as `component create`'s explicit local-over-global merge code.
**Test:** `Cli::try_parse_from` cell (part of AC-001's test) + a wiremock cell asserting `projectKeys=LOCAL`. Per VP-USER-LIST-PROJECT-001(c), EC-X.7.002-1's cell asserts exactly one request (with `projectKeys=LOCAL`).

### AC-006 (traces to BC-X.7.002 EC-X.7.002-6, D-380)
`--project ""` (empty string), whether local or global, passes through as `Some(String::new())` and resolves the project key to the empty string without consulting the configured default -- settled behavior, human-confirmed 2026-09-25 (D-380), matching `jr queue`/`jr requesttype`'s existing empty-string pass-through.
**Test:** two `Cli::try_parse_from` cells + a `proptest!` cell (`cli_project = Some("")` -> `Some(String::new())` in every configured cell) + a wiremock cell. Per VP-USER-LIST-PROJECT-001(c), the wiremock cell configures profile `project = "FOO"`, runs `jr user list --project ""`, asserts exactly one request whose `projectKeys` value is the empty string, and mounts a `.expect(0)` counter-mock on `projectKeys=FOO`.

### AC-007 (traces to BC-X.7.002 Postcondition 5)
Once resolved (by any of steps 1-3), every request carries `projectKeys=<resolved-key>`: exactly one `GET /rest/api/3/user/assignable/multiProjectSearch` on the default (non-`--all`) path (BC-X.7.003's unchanged single-call contract); `--all` paginates one-or-more offset pages of the same endpoint, every page carrying the same `projectKeys` value.
**Test:** two `--all` pagination wiremock tests in `tests/user_pagination.rs`, modeled on `user_list_all_cli_paginates`'s three-page pattern (one with the global flag, one with the configured default), each with a `query_param_is_missing("projectKeys")` catch-all `.expect(0)`. Both cells build their own `Command` using `verification-delta.md` §2's hermetic setup (per-test `JR_CONFIG_DIR`/`JR_CACHE_DIR` `TempDir`, a `.jr.toml`-free `cwd`, `JR_BASE_URL`/`JR_AUTH_HEADER`, and every other ambient `JR_`-prefixed var cleared) -- NOT the file's existing non-hermetic `jr_cmd_json` helper (~L19-25), which sets only `JR_BASE_URL`/`JR_AUTH_HEADER` with no config/cache isolation. Per VP-USER-LIST-PROJECT-001(c), each page's mock is matched on `query_param("projectKeys", "FOO")` with `.expect(1)`, and each test additionally asserts every received request carries exactly one `projectKeys=FOO` pair.

### AC-008 (traces to BC-X.7.002 Fix step 1, VP-USER-LIST-PROJECT-001(d))
`jr user list --help` exits 0 and its stdout (whitespace-collapsed) contains the pinned help string: `"Project key (overrides the configured default project). Required when no project is configured in"` and `"or the active profile"`.
**Test:** `--help` integration cell.

### AC-009 (traces to BC-X.7.002 Fix step 3, Invariants, EC-X.7.002-5)
`cli::user::handle` gains a `&Config` parameter, threaded from `src/main.rs`'s already-loaded `config` binding (`Config::load_with(cli.profile.as_deref())`) -- `handle`/`handle_list` MUST NOT call `Config::load`/`Config::load_with` themselves, or `--profile`/`JR_PROFILE` selection would be silently ignored.
**Test:** the EC-X.7.002-5 wiremock cell, carrying VP-USER-LIST-PROJECT-001(c)'s pinned sub-assertions verbatim (`cross-cutting.md` ~L881-884): temp `config.toml` with profile `default` -> `project = "DEF"` and profile `alt` -> `project = "ALT"`, both URLs at the mock server, no `.jr.toml`; `jr --profile alt user list` with no `--project` asserts exactly one request with `projectKeys=ALT` and mounts a `.expect(0)` counter-mock on a `projectKeys=DEF` mock -- this cell fails if the handler reloads config instead of using the passed value.

### AC-010 (traces to BC-X.7.002 Trace, prd-delta.md F4 doc-delta obligation PASS-13/P13-003)
`README.md`'s `jr user list --project FOO` row (~L335) is reworded to show `--project` as optional, reflecting the new fallback to the configured default project rather than implying the flag is required.
**Test:** N/A (doc artifact); presence checked at PR review.

### AC-011 (traces to verification-delta.md §2 "examine_globs" table, D-382)
`.cargo/mutants.toml`'s `examine_globs` array gains `"src/cli/user.rs"` (32 -> 33 entries, verified by actual count, not the policy doc's prose number). `docs/specs/cargo-mutants-policy.md` gains the exact §Scope bullet specified in `verification-delta.md` §2:
`` - `src/cli/user.rs` — `resolve_user_list_project` (configured-default fallback for user list's post-clap project value via Config::project_key; local-vs-global precedence is clap global-value propagation) (added cycle-014) ``,
inserted directly after the existing `src/jql.rs` bullet (verified: that bullet ends at line 89, immediately followed by a blank line at line 90 and the `**FIX-F7-001 deferred, not added:**` paragraph at line 91 -- both still inside `## Scope`, which runs through line 149; `### Sibling Candidates Considered and Deferred` starts at line 150). The new bullet MUST land before that blank line/paragraph and therefore before line 150 -- `scripts/check-cargo-mutants-policy-citations.sh`'s §Scope extraction (`awk` range `/^## Scope$/` through the first `^## ` or `^### Sibling Candidates`, ~L37-46) stops parsing at line 150 and would silently false-green a bullet placed at or after it. Its "Current `examine_globs` count" line (line 113) changes 32 -> 33, and a new newest-first row is added to the `## Changelog` table (`## Changelog` header at line 1583, top data row at line 1587). Per `scripts/check-cargo-mutants-policy-citations.sh` (~L137-153), the bullet's parenthetical description must not backtick any other lowercase identifier -- e.g. do not write `` (wraps `Config::project_key`) `` -- because every backtick token matching `^[a-z_][a-z0-9_]*$` is treated as a function-name citation requiring its own definition line in the cited file. Running `scripts/check-cargo-mutants-policy-citations.sh` before this story's edit reports `Check passed: 29 bullets parsed, 98 (file, fn) pairs validated` (verified); after the edit it must report exactly 30 bullets parsed (one more, not two, and not zero) -- a bullet count that doesn't move by exactly +1 means the insertion landed in the wrong place or was malformed. Because inserting the new §Scope bullet shifts every subsequent line in the file down by one, verify the current line numbers for the count line (nominally 113) and the `## Changelog` header/top data row (nominally 1583/1587) immediately before each of those edits -- in file order (bullet insert first, then the count-line edit, then the Changelog row) -- rather than relying on this story's pinned numbers once an earlier edit in this same sequence has already landed.
**Test:** N/A (config/doc); `tests/mutants_glob_existence.rs` passes automatically since the file already exists; `scripts/check-cargo-mutants-policy-citations.sh` passes since `resolve_user_list_project` is defined in the same PR, AND its "N bullets parsed" success line reads 30 (was 29 pre-edit).

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

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~2,600 |
| Referenced code (`src/cli/mod.rs` `UserCommand::List` region, `src/cli/user.rs` full file, `src/main.rs`'s `Command::User` arm, `src/config.rs::project_key`, `src/cli/component.rs::handle` List/Create arms as precedent, `src/cli/field.rs::resolve_m2_project` as signature precedent) | ~3,000 |
| Test files (`tests/user_commands.rs`, `tests/all_flag_behavior.rs:~260-`, `tests/user_pagination.rs` -- grep-scoped) | ~2,000 |
| Tool output overhead | ~1,000 |
| **Total** | **~8,600** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~4%** |

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
3. [ ] Write the inline `Cli::try_parse_from` unit test in `src/cli/mod.rs`'s existing
   `#[cfg(test)] mod tests` block (~L1435) (AC-001, AC-005, AC-006) -- `test-writer`
4. [ ] Write the `proptest!` on `resolve_user_list_project` in `src/cli/user.rs`'s
   `#[cfg(test)]` module (AC-003, AC-006) -- `test-writer`
5. [ ] Write the hermetic wiremock integration cells in a new file,
   `tests/user_list_project_resolution.rs`: EC-X.7.002-1/2/3 (x3 sub-cells)/5/6, and the
   `--help` cell (AC-002, AC-003, AC-005, AC-006, AC-008); write the two `--all` pagination
   cells (AC-007) in `tests/user_pagination.rs`, modeled on (not reusing) the existing
   `user_list_all_cli_paginates` three-page pattern, each built with its own
   `verification-delta.md` §2 hermetic setup rather than the file's non-hermetic
   `jr_cmd_json` helper (~L19-25) -- `test-writer`
6. [ ] Make `tests/user_commands.rs::user_list_requires_project_flag` hermetic per
   `verification-delta.md` §2 (no rename); update its stale
   `// No server needed — clap should fail before any HTTP call.` comment (note: the file uses
   an em dash, not a double-hyphen); add a new, separate hermetic EC-X.7.002-4 wiremock cell in
   the same file with `.expect(0)` on `multiProjectSearch` asserting the byte-identical pinned
   exit-64 message (AC-004) -- `test-writer`
7. [ ] Confirm Red Gate against the Task 1 stub, reclassified for the corrected stub shape
   (Task 1's `Some(p)` short-circuit means any cell that resolves `project` to `Some(...)` at
   the CLI-parse level bypasses `resolve_user_list_project` entirely and hits the unchanged
   HTTP path -- it is GREEN at stub, not a Red Gate signal, even though it is new test code).
   Classify against the orchestrator playbook's actual formula
   (`workflows/phases/per-story-delivery.md` Red Gate Density Check, ~L45-64):
   `RED_RATIO = RED_TESTS / (TOTAL_NEW_TESTS - EXEMPT_TESTS)`, where
   `EXEMPT_TESTS = GREEN-BY-DESIGN_count + WIRING-EXEMPT_count` is subtracted from the
   DENOMINATOR (not the numerator -- a GREEN cell is never counted in `RED_TESTS` to begin
   with, so "excluding it from the numerator" is a no-op; every bucket-(a) cell below must
   instead be mapped to a category that removes it from the denominator):

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
   - EC-X.7.002-1's wiremock cell (AC-005, both flags -> LOCAL) and EC-X.7.002-2's wiremock
     cell (AC-002, global only -> FOO) -> both resolve to `Some(...)` via clap propagation
     alone and short-circuit straight to HTTP; EC-X.7.002-2 is in fact the #862 bug fix itself,
     delivered by Task 1's `String` -> `Option<String>` type change, not by the resolver
     (**2 tests**);
   - EC-X.7.002-6's wiremock cell (AC-006, `--project ""` local or global) -> resolves to
     `Some(String::new())` via clap and short-circuits straight to HTTP (**1 test**);
   - AC-007's global-flag `--all` pagination cell (`jr --project FOO user list --all`) ->
     same short-circuit reasoning (**1 test**);
   - the pre-existing tests that always pass `--project` explicitly and therefore never reach
     the resolver, at stub or after: `tests/user_commands.rs::user_list_by_project_returns_users`
     (~L142), `tests/user_pagination.rs::user_list_all_cli_paginates` (~L385) and its sibling
     cap-hitting test (~L506), and `tests/all_flag_behavior.rs::user_list_default_caps_at_thirty`
     (~L288) -> these are the file's genuine, UNMODIFIED before/after regression guards, GREEN
     unconditionally throughout. **These are NOT counted at all**, in either bucket and not as
     `EXEMPT_TESTS` either: per the formula's own definition, `TOTAL_NEW_TESTS` is "the count of
     all tests introduced in this story's delivery" -- these four were never introduced by this
     story, so they never enter `TOTAL_NEW_TESTS` in the first place. This is a distinct
     exclusion path from `EXEMPT_TESTS` (which subtracts *new* tests that are structurally
     GREEN-by-design from an otherwise-counted denominator).

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
   | `EXEMPT_TESTS` (all `WIRING-EXEMPT`) | 5 | `Cli::try_parse_from` (1 function) + EC-X.7.002-1 (1) + EC-X.7.002-2 (1) + EC-X.7.002-6 (1) + AC-007 global-flag `--all` (1) |
   | Excluded entirely (not new tests) | 4 | `user_list_by_project_returns_users`, `user_list_all_cli_paginates`, its cap-hitting sibling, `user_list_default_caps_at_thirty` -- never enter `TOTAL_NEW_TESTS` |
   | `TOTAL_NEW_TESTS` | 14 | `RED_TESTS` (9) + `EXEMPT_TESTS` (5); the 4 excluded-entirely tests are NOT added here |
   | Denominator (`TOTAL_NEW_TESTS - EXEMPT_TESTS`) | 9 | 14 - 5 |
   | **`RED_RATIO`** | **9 / 9 = 1.0** | Clears the BC-8.29.001 threshold `RED_RATIO >= 0.5` (integer-precise check: `9 * 2 >= 9` holds) |

   Denominator is nonzero (9), so this is not the Full-Exception Path, and RED_RATIO clears the
   threshold without invoking either Remediation Option A or B.
8. [ ] Finalize `UserCommand::List.project`'s help text to the pinned AC-008 wording (the
   `String` -> `Option<String>` type change already landed in Task 1) (AC-008) -- `implementer`
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
    (~L37-46) stops parsing at; bump the "Current `examine_globs` count" line (113) 32->33; add
    a newest-first `## Changelog` row (table starts line 1583); then run
    `scripts/check-cargo-mutants-policy-citations.sh` and confirm its reported bullet count
    goes up by exactly one (29 -> 30) (AC-011). Verify current line numbers immediately before
    each edit (they shift by +1 after the bullet insert): re-check the count-line location
    (nominally 113) and the `## Changelog` header/top-row locations (nominally 1583/1587)
    after the bullet insert lands, rather than relying on this story's pinned numbers
14. [ ] Add a CHANGELOG entry under `[Unreleased] > Fixed` describing the shipped behavior,
    before creating the PR. Per precedent (CHANGELOG.md ~L125's `--recent`/`--updated-recent`
    entry and ~L543's `load_api_token` entry), flag the failure-mode change inline as a
    breaking change: a global-only or config-default-only `jr user list` invocation that
    previously failed via clap's exit-2 "required argument" error now fails (only when no
    project resolves at all) via `jr`'s own exit-64 `JrError::UserError`, e.g. `` **Breaking:
    `jr user list` with no project resolvable now exits 64, not clap's exit 2** (issue #862)
    ``, followed by the four-step resolution order and the pinned exit-64 message
15. [ ] Run `cargo fmt --all -- --check`, `cargo clippy -- -D warnings`, `cargo test`, and the scoped `cargo mutants --in-diff`

## Previous Story Intelligence

N/A -- first story in cycle-014's serial delivery chain (A -> C -> B, D-381); no cycle-014 predecessor exists yet.

**Pattern to follow (cross-cycle precedent):** `src/cli/field.rs::resolve_m2_project` (S-580-1, BC-X.14.001's M2 project-resolution step) already establishes the pure-resolver-plus-`&Config`-threading pattern this story mirrors; `resolve_user_list_project`'s signature is deliberately styled after it. `src/cli/component.rs::handle`'s `List`/`Create` arms are the codebase's other local-over-global precedent (explicit `.or()`/`or_else()` merge code, for a variant that does NOT rely on clap propagation) -- this story's variant DOES rely on clap propagation instead, so no equivalent merge code is written; do not copy `component.rs`'s explicit merge pattern here.

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| `handle`/`handle_list` MUST NOT call `Config::load`/`Config::load_with` -- only the `&Config` passed from `main.rs` may be consulted | BC-X.7.002 Fix step 3, Invariants | AC-009's EC-X.7.002-5 test fails if the handler reloads config |
| Local-vs-global precedence is clap's own `fill_in_global_values` propagation -- no hand-written `jr`-level merge/`.or()` call is added for this half of the resolution | BC-X.7.002 Behavior, Fix step 2 | Code review; AC-001/AC-005 tests pass without any merge code in `handle_list` |
| The canonical no-project exit-64 message MUST be byte-identical to `queue.rs`/`requesttype.rs`'s existing wording | BC-X.7.002 Postcondition 4 | AC-004 |
| `--project ""` MUST NOT be special-cased to `None` (treated as absent) | BC-X.7.002 EC-X.7.002-6, D-380 | AC-006 |
| No new `Config`/`ProfileConfig` accessor and no new cache file -- reuse `Config::project_key` exactly | BC-X.7.002 Invariants | Code review |

## Library & Framework Requirements

No new dependency is added. `clap = { version = "4", features = ["derive"] }` (existing pin, `Cargo.toml`; resolves to 4.6.7 per the lockfile cited throughout `cross-cutting.md`) is relied upon for global-value propagation via `fill_in_global_values` -- no version change required.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/cli/mod.rs` | modify | `UserCommand::List.project: String -> Option<String>`; help text update (AC-001, AC-008); inline `Cli::try_parse_from` unit test added to the existing `#[cfg(test)] mod tests` block (~L1435) |
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
