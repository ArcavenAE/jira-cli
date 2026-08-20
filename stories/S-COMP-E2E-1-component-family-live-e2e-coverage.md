---
document_type: story
level: ops
epic_id: "none"
story_id: "S-COMP-E2E-1"
title: "Live E2E coverage for the component command family"
wave: feature-followup
status: ready
intent: test
feature_type: test
mode: feature
scope: standard
severity: N/A
trivial_scope: false
issue: TBD
points: 8
priority: P2
tdd_mode: facade
estimated_effort: medium
producer: story-writer
timestamp: "2026-08-20T00:00:00"
phase: 2
cycle: cycle-component-mgmt
inputs:
  - ".factory/specs/prd/bc-8-components.md"
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
traces_to: ".factory/specs/prd/bc-8-components.md"
estimated_days: 3
target_module: tests/e2e_live.rs
subsystems: ["SS-02", "SS-04", "SS-07", "SS-08"]
depends_on: ["S-604-1", "S-604-2", "S-604-3", "S-605-1", "S-606-1", "S-608-1"]
blocks: []
behavioral_contracts:
  - "BC-8.1.001"
  - "BC-8.1.002"
  - "BC-8.1.005"
  - "BC-8.1.007"
  - "BC-8.2.001"
  - "BC-8.2.006"
  - "BC-8.2.008"
  - "BC-8.3.001"
  - "BC-3.4.022"
  - "BC-3.4.024"
  - "BC-3.4.025"
  - "BC-2.1.018"
  - "BC-2.1.019"
  - "BC-2.1.020"
bcs:
  - "BC-8.1.001"
  - "BC-8.1.002"
  - "BC-8.1.005"
  - "BC-8.1.007"
  - "BC-8.2.001"
  - "BC-8.2.006"
  - "BC-8.2.008"
  - "BC-8.3.001"
  - "BC-3.4.022"
  - "BC-3.4.024"
  - "BC-3.4.025"
  - "BC-2.1.018"
  - "BC-2.1.019"
  - "BC-2.1.020"
verification_properties: ["VP-COMPONENT-029", "VP-COMPONENT-030", "VP-COMPONENT-031", "VP-COMPONENT-032", "VP-COMPONENT-033"]
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0018"]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-8-components.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 17
assumption_validations: []
risk_mitigations: []
created: "2026-08-20"
version: "1.1"
last_updated: "2026-08-20"
breaking_change: false
retroactive: false
origin: >
  The COMPONENT-MGMT bundle (S-604-1/2/3, S-605-1/2, S-606-1, S-608-1) is fully merged
  and DONE as of 2026-08-19. Every surface it shipped has wiremock/unit coverage, and
  ONE live-Jira smoke test exists today — `test_e2e_issue_edit_component_multikey_bulk_roundtrip`
  (AC-010 of S-605-2), covering ONLY the bulk `issue edit --component` path
  (BC-3.4.023's `multiselectComponents` wire shape). Every other command in the family
  — `component create`/`list`/`edit`/`delete`/`rename`, `issue create --component`
  (single-key), `issue edit --component` (single-key native `update`-verb path,
  distinct code path from the bulk shape already covered), and `issue list --component`
  (bare/`not:`/`none` JQL-composition grammar) — has ZERO live-Jira verification. This
  story closes that gap with pure test-hardening: no new product behavior, no new BCs,
  every AC traces to a BC-S.SS.NNN clause already authored and shipped by the
  COMPONENT-MGMT bundle. Opened per the human's request following S-605-2's merge to
  cover "the surfaces that currently have NO dedicated live e2e test."
files_modified:
  - tests/e2e_live.rs
  - tests/e2e_cli_surface_guard.rs
  - docs/specs/e2e-live-jira-testing.md
  - CLAUDE.md
test_files:
  - tests/e2e_live.rs
input-hash: "658f5c4"
---

> **tdd_mode:** `facade`. This is a zero-`src/` test-hardening story: new live E2E test
> functions plus a `Drop`-guard teardown helper in `tests/e2e_live.rs`, a SURFACE-table
> update in `tests/e2e_cli_surface_guard.rs`, and doc-fallout in
> `docs/specs/e2e-live-jira-testing.md` + `CLAUDE.md`. No product code changes; no new
> BC is authored or modified. The Red Gate density check does not apply — mutation
> testing at the wave gate is the operative quality gate for this story, per BC-8.30.001.

# S-COMP-E2E-1: Live E2E Coverage for the Component Command Family

## Narrative

As a `jr` maintainer, I want live-Jira E2E coverage for every `component`-family command
and every `--component` issue-command surface that currently has NO dedicated live test,
so that the COMPONENT-MGMT bundle's documented wire shapes (native PUT verbs, JSON result
shapes, JQL grammar composition) are verified against real Jira Cloud — not merely
wiremock-mocked — before the next release, the same way `test_e2e_issue_edit_component_multikey_bulk_roundtrip`
already did for the bulk `--component` path.

As a fork contributor running the nightly E2E workflow, I want these new tests to clean-skip
gracefully on any precondition gap (missing `JR_E2E_PROJECT`, zero components on the
configured project, insufficient permissions) and to leave the target Jira project exactly
as they found it — every component this story's tests create is deleted by the end of the
test run, on both the success path and the panic/assertion-failure path.

## Source of Truth

This story adds **zero new behavioral contracts**. Every AC below traces to a BC already
authored and shipped by the COMPONENT-MGMT bundle. Read the following BC bodies in full
before implementing — do not work from the summaries in this story alone:

- `bc-8-components.md`: BC-8.1.001, BC-8.1.002 (list — table + JSON), BC-8.1.005 (create),
  BC-8.1.007 (edit), BC-8.2.001 (delete disposition-required guard), BC-8.2.006 (`--orphan`
  non-interactive `--yes` gate), BC-8.2.008 (delete JSON result shape + idempotency
  taxonomy), BC-8.3.001 (rename, single-project, id-preservation).
- `bc-3-issue-write.md`: BC-3.4.022 (`issue edit --component`, single-key, native
  `update`-verb wire shape — **distinct from BC-3.4.023's bulk `multiselectComponents`
  shape, which the existing AC-010 live test already covers**), BC-3.4.024 (`issue create
  --component`, bare form, initial `components` array), BC-3.4.025 (`--component` name
  resolution mechanism — project component-list GET, not editmeta, on `create`/`list`).
- `bc-2-issue-read.md`: BC-2.1.018 (bare `--component` → OR-combined `component in (...)`),
  BC-2.1.019 (`not:` form), BC-2.1.020 (`none` form).

Also read `tests/e2e_live.rs`'s existing `test_e2e_issue_edit_component_multikey_bulk_roundtrip`
(~line 8958) in full — it is the closest structural precedent (component discovery via
`jr component list --project <proj> --output json`, clean-skip on empty/403/404, `poll_view`
read-back assertions) and this story's new tests MUST follow the same conventions. Also read
`AttachmentDropGuard` (~line 11174, introduced by S-576-6) — the `Drop`-guard teardown
pattern this story's `ComponentDropGuard` (AC-015) is modeled on verbatim.

## Behavioral Contracts

| BC ID | Title | Role in this story |
|-------|-------|---------------------|
| BC-8.1.001 | `jr component list [--project KEY]` GETs the project component list; table render | Verify a created/edited/renamed component appears/disappears in `list` output |
| BC-8.1.002 | `jr component list --output json` returns array of full component objects | JSON-shape assertions on `list` throughout the lifecycle round-trip |
| BC-8.1.005 | `jr component create` POSTs `/rest/api/3/component`; JSON result `{id,name,project}` | AC-001 |
| BC-8.1.007 | `jr component edit` PUTs `/rest/api/3/component/{id}`; only supplied fields sent; JSON result `{id,name,project}` | AC-003 |
| BC-8.2.001 | `jr component delete` refuses without `--move-to` or `--orphan` | Precondition satisfied by AC-005's explicit `--orphan` |
| BC-8.2.006 | `--orphan` requires `--yes` non-interactively; DELETEs with no `moveIssuesTo` | AC-005 (non-interactive `--yes` path) |
| BC-8.2.008 | `--output json` delete result `{deleted, movedIssuesTo, affectedIssueCount, affectedIssues}` | AC-005 |
| BC-8.3.001 | `jr component rename OLD NEW --project KEY` PUTs `{"name":NEW}`; id unchanged by rename | AC-007 |
| BC-3.4.022 | `issue edit KEY --component add:X --component remove:Y` (single-key) native `update`-verb wire shape | AC-010 |
| BC-3.4.024 | `issue create --component X` (bare) sets initial `components` array | AC-009 |
| BC-3.4.025 | `--component` name resolution — project component-list GET (not editmeta) on `create`/`list` | AC-009, AC-010, AC-011 discovery mechanism |
| BC-2.1.018 | `--component <NAME>` (bare, repeated) → OR-combined `component in (...)` | AC-011 |
| BC-2.1.019 | `--component not:<NAME>` → `(component not in (...) OR component is EMPTY)` | AC-012 |
| BC-2.1.020 | `--component none` → `component is EMPTY` | AC-013 |

## Dependency Justification

- **`depends_on: [S-604-1]`** — S-604-1 shipped `jr component list` and the
  `resolve_component`/cache foundation every other component command (and this story's
  discovery calls) build on; this story's tests cannot run against a binary that lacks it.
- **`depends_on: [S-604-2]`** — S-604-2 shipped `jr component create`/`jr component edit`,
  exercised directly by AC-001/AC-003.
- **`depends_on: [S-604-3]`** — S-604-3 shipped `jr component delete` (disposition-required
  safety), exercised directly by AC-005.
- **`depends_on: [S-605-1]`** — S-605-1 shipped the single-key `issue create --component` /
  `issue edit --component` native wire shape (BC-3.4.022/024/025), exercised by AC-009/AC-010.
- **`depends_on: [S-606-1]`** — S-606-1 shipped `issue list --component` (BC-2.1.018-022),
  exercised by AC-011/AC-012/AC-013.
- **`depends_on: [S-608-1]`** — S-608-1 shipped `jr component rename`, exercised by AC-007.
- **`blocks: []`** — no story depends on this E2E-coverage story to proceed; it is pure
  test-hardening on top of already-merged product code.

## Anchor Justification

- **SS-02, SS-04** own the `issue create`/`issue edit`/`issue list --component` portion of
  this story's scope (AC-009 through AC-013) per ARCH-INDEX Subsystem Registry — the same
  subsystems S-605-1, S-605-2, and S-606-1 cite for the identical command surfaces.
- **SS-07, SS-08** own the `jr component *` portion of this story's scope (AC-001 through
  AC-008) per ARCH-INDEX Subsystem Registry — the same subsystems S-604-1 and S-608-1 cite
  for the identical command surfaces.

## Environment Variables — none new

This story introduces **zero new `JR_E2E_*` environment variables**. Every scenario uses
auto-discovery, mirroring the existing `test_e2e_issue_edit_component_multikey_bulk_roundtrip`
precedent:

- Component discovery for the `issue`-command scenarios (AC-009/AC-010/AC-011) runs
  `jr component list --project <proj> --output json` and takes the first result, exactly like
  the existing bulk test does — clean-skip if the project has zero components.
- The `component`-family lifecycle/rename scenarios (AC-001..AC-008) create their OWN
  throwaway component fixtures (name derived from `run_label()` for uniqueness and
  traceability) rather than depending on a pre-existing one, and delete them via
  `ComponentDropGuard` (AC-015) regardless of test outcome.
- `JR_E2E_PROJECT` (existing, required) is the only env var read by this story's new tests.

## Acceptance Criteria

### AC-001 (traces to BC-8.1.005 Postcondition — create JSON result shape)
`jr component create --project <proj> "<run-label-name>" --description "<d>" --output json`
exits 0; the response parses as JSON with exactly the keys `id`, `name`, `project`; `name`
equals the supplied name; `project` equals `<proj>`. A `ComponentDropGuard` is armed with the
returned `id` and `<proj>` IMMEDIATELY after this call succeeds, before any further assertion
in the test.

### AC-002 (traces to BC-8.1.001 Postcondition / BC-8.1.002 — list reflects the created component)
`jr component list --project <proj> --output json` exits 0; the response is a JSON array
containing an entry whose `id` equals the id captured in AC-001 and whose `name` equals the
created name.

### AC-003 (traces to BC-8.1.007 Postcondition — edit only-supplied-fields + JSON result shape)
`jr component edit <id-from-AC-001> --project <proj> --name "<new-name>" --description "<d2>"
--output json` exits 0; the response parses as JSON `{id, name, project}`; `id` is UNCHANGED
from AC-001; `name` equals `<new-name>`.

### AC-004 (traces to BC-8.1.001 Postcondition / BC-8.1.002 — list reflects the edit)
`jr component list --project <proj> --output json` exits 0; the array contains an entry with
the AC-001 `id` and the AC-003 `<new-name>`; NO entry has the AC-001 original name.

### AC-005 (traces to BC-8.2.001 Precondition, BC-8.2.006 Postcondition — non-interactive item 1, BC-8.2.008 Postcondition)
`jr component delete <id-from-AC-001> --project <proj> --orphan --yes --output json` exits 0;
the response parses as JSON with exactly the keys `deleted`, `movedIssuesTo`,
`affectedIssueCount`, `affectedIssues`; `deleted` equals the id; `movedIssuesTo` is JSON
`null` (orphan disposition, no replacement target). The `ComponentDropGuard` armed in AC-001
is disarmed (its tracked id cleared) immediately after this call succeeds, so its `Drop` does
not attempt a redundant second delete.

### AC-006 (traces to BC-8.1.001 Postcondition / BC-8.1.002 — list reflects the deletion)
`jr component list --project <proj> --output json` exits 0; the array contains NO entry with
the id deleted in AC-005.

### AC-007 (traces to BC-8.3.001 Postcondition 1/2 — rename PUT shape + JSON result + id-preservation)
A fresh throwaway component `<old-name>` is created (own `ComponentDropGuard` instance,
armed on creation, tracked by numeric id so the guard's cleanup target survives the rename).
`jr component rename "<old-name>" "<new-name>" --project <proj> --output json` exits 0; the
response parses as JSON `{"renamed": {"id", "from", "to", "project"}}`; `renamed.id` equals
the id captured at creation (BC-8.3.001's id-preservation guarantee); `renamed.from` equals
`<old-name>`; `renamed.to` equals `<new-name>`; `renamed.project` equals `<proj>`.

### AC-008 (traces to BC-8.1.001 Postcondition / BC-8.1.002 — list reflects the rename)
`jr component list --project <proj> --output json` exits 0; the array contains an entry with
the id from AC-007 and the name `<new-name>`; NO entry has `<old-name>`. Teardown: the
`ComponentDropGuard` from AC-007 deletes the component (by its stable numeric id, `--orphan
--yes`) at end of test / on panic, per AC-015.

### AC-009 (traces to BC-3.4.024 Postcondition 1 / BC-3.4.025 resolution mechanism)
Component discovery: `jr component list --project <proj> --output json` exits 0; if the
resulting array is empty, `eprintln!("SKIP: ...")` and return (clean-skip, mirrors the
existing bulk test's precondition handling — no new component is created here so this
scenario stays independent of AC-001..AC-008's lifecycle fixtures). Otherwise take the first
component's `name` as `<comp>`. `jr issue create --project <proj> --type <itype> --summary
"<s>" --label <run-label> --component <comp> --output json` exits 0 and returns a `key`.
`jr issue view <key> --output json` (via `poll_view`) shows `fields.components[].name`
containing `<comp>`.

### AC-010 (traces to BC-3.4.022 Postcondition 1 — single-key native `update`-verb wire shape, distinct from the existing bulk-path live test)
Using the SAME discovered `<comp>` as AC-009 (or an independent discovery call — either is
acceptable; component discovery is a cheap read-only GET). A fresh, `<comp>`-free issue
`<key>` is created (labeled, `--component` NOT supplied at create time). Poll-view confirms
`<comp>` is ABSENT. `jr issue edit <key> --component add:<comp>` (exactly ONE key on the
command line — this is the load-bearing distinction from
`test_e2e_issue_edit_component_multikey_bulk_roundtrip`, which always supplies 2+ keys and
therefore only ever exercises BC-3.4.023's `multiselectComponents` bulk shape) exits 0;
poll-view confirms `<comp>` is PRESENT. `jr issue edit <key> --component remove:<comp>` exits
0; poll-view confirms `<comp>` is ABSENT again.

### AC-011 (traces to BC-2.1.018 — bare `--component` filter)
Component discovery as AC-009 (independent call; clean-skip on empty). A fresh issue `<key>`
is created WITH `--component <comp>` at create time (reuses the AC-009 create mechanism).
After a bounded poll/retry (JQL search indexing lag, mirrors existing `poll_jql` usage
elsewhere in the suite), `jr issue list --project <proj> --component <comp> --output json`
exits 0 and the resulting array contains an entry whose `key` equals `<key>`.

### AC-012 (traces to BC-2.1.019 — `not:` filter grammar composition)
Using the SAME `<key>`/`<comp>` fixture from AC-011: `jr issue list --project <proj>
--component "not:<comp>" --output json` exits 0; the resulting array does NOT contain an
entry whose `key` equals `<key>` (the issue has the component, so `not:` correctly excludes
it — confirms the `(component not in (...) OR component is EMPTY)` clause composes
correctly against a live JQL search, not just against wiremock's exact-string match).

### AC-013 (traces to BC-2.1.020 — `none` filter grammar composition)
Using the SAME fixture: `jr issue list --project <proj> --component none --output json` exits
0; the resulting array does NOT contain an entry whose `key` equals `<key>` (the issue HAS a
component, so `component is EMPTY` correctly excludes it).

### AC-014 (test gating and clean-skip discipline — S-410 pattern, mirrors every existing E2E test)
Every new test function added by this story (`test_e2e_component_lifecycle_roundtrip`,
`test_e2e_component_rename_roundtrip`, `test_e2e_issue_create_component_single_key_roundtrip`,
`test_e2e_issue_edit_component_single_key_roundtrip`,
`test_e2e_issue_list_component_filter_grammar`) is annotated `#[test]` +
`#[ignore = "set JR_RUN_E2E=1 and use --include-ignored to run against a live Jira site"]`
and begins with `if !e2e_enabled() { return; }`. Every clean-skip condition identified in
AC-001..AC-013 (missing `JR_E2E_PROJECT`, empty component-discovery result, a 403/404 on any
component or issue call attributable to a permission/plan gate) emits
`eprintln!("SKIP: ...")` and returns WITHOUT panicking or failing the test. Any OTHER failure
(a non-403/404 non-zero exit on a call the AC asserts must succeed) is a genuine test failure
— `panic!`/`assert!` fires with full stdout/stderr context, mirroring the existing bulk
test's `DEC-280 RELEASE GATE FAILURE`-style panic messages.

### AC-015 (best-effort `Drop`-guard teardown — mirrors `AttachmentDropGuard`, S-576-6 precedent)
A new `ComponentDropGuard` struct is added to `tests/e2e_live.rs`, holding
`project: Option<String>` and `component_id: Option<String>`. Its `Drop` impl: if
`component_id` is `Some`, spawns a FRESH `E2eHarness::new()` (guards must not borrow the
test's own harness across a potential panic-unwind) and runs `jr component delete <id>
--project <proj> --orphan --yes`; any failure (non-zero exit or spawn error) emits
`eprintln!("[WARN] ComponentDropGuard Drop: ...")` and does NOT panic — identical
best-effort contract to `AttachmentDropGuard`/`jsm_self_close`. AC-001's and AC-007's guard
instances are constructed empty (`component_id: None`), then immediately populated after
their respective `create` calls succeed — never before, and never skipping the population
step even on an early return, since an unpopulated guard performs no cleanup by design (no
component was created, so none needs deleting). AC-005's guard is explicitly disarmed
(`component_id = None`) after ITS intentional delete succeeds, so `Drop` does not attempt a
redundant second delete against an id that no longer exists.

### AC-016 (traces to BC-8.1.005/BC-8.1.007/BC-8.2.001/BC-8.3.001/BC-3.4.024/BC-2.1.018 as CLI-surface facts — SURFACE table coverage, E2E-PG-1/DRIFT-E2E-1)
`tests/e2e_cli_surface_guard.rs`'s `SURFACE` table gains rows for every new subcommand path
and flag this story's tests invoke that is not already present:
- `(&["component", "create"], &["--project", "--description", "--output"])`
- `(&["component", "edit"], &["--project", "--name", "--description", "--output"])`
- `(&["component", "delete"], &["--project", "--orphan", "--yes", "--output"])`
- `(&["component", "rename"], &["--project", "--output"])`
- The existing `(&["issue", "create"], &[...])` row gains `"--component"`.
- The existing `(&["issue", "list"], &["--jql", "--output"])` row gains `"--project"` and
  `"--component"`.
`--component` on `(&["issue", "edit"], &[...])` is ALREADY present (added by S-605-2 for
AC-010) — no change needed there. `cargo test --test e2e_cli_surface_guard` exits 0 after
the update.

### AC-017 (documentation fallout — env-var table unchanged, test roster updated)
`docs/specs/e2e-live-jira-testing.md` §8's configuration inventory table is UNCHANGED (no new
env var, per this story's "Environment Variables — none new" section) but §4's test-suite
description gains the five new test function names and a one-line note that
`ComponentDropGuard` is the teardown mechanism for component fixtures. `CLAUDE.md`'s AI Agent
Notes JSM/E2E env-var roster is UNCHANGED for the same reason; a new bullet documents the
`ComponentDropGuard` pattern (mirroring the existing `AttachmentDropGuard` bullet's level of
detail) so a future story reaches for the established Drop-guard idiom instead of
reinventing best-effort teardown. `git diff --name-only HEAD | grep -E "^src/"` returns
empty — zero product-code changes.

## Architecture Mapping

This story is pure `tests/` + docs test-hardening — it invokes the existing product
surfaces below as a black-box subprocess consumer (via `E2eHarness::cmd()`) and modifies
none of their `src/` implementations. Component mappings below reference
`architecture/module-decomposition.md`; see "Zero `src/` changes" in Architecture
Compliance Rules.

| Component | Module | Pure/Effectful |
|-----------|--------|---------------|
| `jr component` command family (list/create/edit/delete/rename) | `src/cli/component.rs` (SS-07, SS-08) — exercised as a subprocess, not modified | effectful-shell |
| `issue create`/`issue edit`/`issue list` `--component` surfaces | `src/cli/issue/{create,edit,list}.rs` (SS-02, SS-04) — exercised as a subprocess, not modified | effectful-shell |
| New live E2E test suite (`ComponentDropGuard` + 5 test fns) | `tests/e2e_live.rs` | effectful-shell (integration test, spawns `jr` subprocesses against live Jira) |
| CLI surface guard SURFACE table | `tests/e2e_cli_surface_guard.rs` | effectful-shell (spawns `jr --help` subprocesses, offline) |

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|--------------------|
| EC-COMP-E2E-1 | `JR_E2E_PROJECT` unset | Every new test's `e2e_enabled()`/gate check clean-skips before any HTTP call (AC-014) |
| EC-COMP-E2E-2 | Configured project has zero components at discovery time (AC-009/AC-010/AC-011) | `eprintln!("SKIP: ...")`, return — no component fixture is auto-created for these three scenarios, matching the existing bulk-test precedent |
| EC-COMP-E2E-3 | `component create`/`delete`/`rename`/`edit` returns 403 (insufficient permission on this Jira site/plan) | Clean-skip via `eprintln!("SKIP: ...")`, return — NOT a test failure (AC-014) |
| EC-COMP-E2E-4 | A component-lifecycle test panics mid-sequence (e.g. an unexpected assertion failure between create and delete) | `ComponentDropGuard::drop` still fires during unwind and deletes the orphaned component (AC-015) |
| EC-COMP-E2E-5 | JQL search indexing lag after tagging an issue with a component (AC-011/AC-012/AC-013) | A bounded poll/retry loop is used before the `issue list --component` assertions, mirroring the suite's existing `poll_jql`/`poll_view` backoff convention |

## Purity Classification

| Item | Classification | Justification |
|------|-----------------|-----------------|
| `tests/e2e_live.rs` (new test functions + `ComponentDropGuard`) | Effectful (integration test, spawns `jr` subprocesses against live Jira) | Same classification as every existing E2E test in this file |
| `tests/e2e_cli_surface_guard.rs` (SURFACE table rows) | Effectful (spawns `jr --help` subprocesses, offline) | Unchanged classification from the existing guard |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|--------------------|
| This story spec | ~7k |
| BC-8.1.001/002/005/007, BC-8.2.001/006/008, BC-8.3.001 bodies | ~10k |
| BC-3.4.022/024/025 bodies (already read once during S-605-1; re-read for citation accuracy) | ~5k |
| BC-2.1.018/019/020 bodies | ~3k |
| `tests/e2e_live.rs` relevant sections (existing bulk `--component` test, `AttachmentDropGuard`, `jsm_self_close`, harness helpers) | ~8k |
| `tests/e2e_cli_surface_guard.rs` (SURFACE table + guard logic) | ~2k |
| `docs/specs/e2e-live-jira-testing.md` §4/§8 (read + edit) | ~2k |
| `CLAUDE.md` relevant sections (AI Agent Notes JSM/E2E roster, `AttachmentDropGuard` precedent) | ~2k |
| Tool outputs (`cargo test --test e2e_cli_surface_guard`, `cargo build`, grep verifications) | ~3k |
| **Total** | **~42k** |
| Agent context window | 200K |
| **Budget usage** | **~21%** |

Well within the 20-30% single-agent budget; no split required.

## Tasks

1. [ ] Read `bc-8-components.md` BC-8.1.001/002/005/007, BC-8.2.001/006/008, BC-8.3.001 in full
2. [ ] Read `bc-3-issue-write.md` BC-3.4.022/024/025 in full (re-confirm the native single-key
   `update`-verb shape vs. the bulk `multiselectComponents` shape distinction)
3. [ ] Read `bc-2-issue-read.md` BC-2.1.018/019/020 in full
4. [ ] Read `tests/e2e_live.rs`'s `test_e2e_issue_edit_component_multikey_bulk_roundtrip`
   (~line 8958) and `AttachmentDropGuard` (~line 11174) as the two structural precedents
5. [ ] Add `ComponentDropGuard` struct + `Drop` impl to `tests/e2e_live.rs` (AC-015)
6. [ ] Add `test_e2e_component_lifecycle_roundtrip` (AC-001..AC-006)
7. [ ] Add `test_e2e_component_rename_roundtrip` (AC-007..AC-008)
8. [ ] Add `test_e2e_issue_create_component_single_key_roundtrip` (AC-009)
9. [ ] Add `test_e2e_issue_edit_component_single_key_roundtrip` (AC-010)
10. [ ] Add `test_e2e_issue_list_component_filter_grammar` (AC-011..AC-013)
11. [ ] Update `tests/e2e_cli_surface_guard.rs` SURFACE table per AC-016
12. [ ] Update `docs/specs/e2e-live-jira-testing.md` §4 test roster per AC-017 (no env-var
    table change)
13. [ ] Update `CLAUDE.md` with the `ComponentDropGuard` doc-fallout bullet per AC-017
14. [ ] Run `git diff --name-only HEAD | grep -E "^src/"` — must return empty
15. [ ] Run `cargo test --test e2e_cli_surface_guard` — must exit 0
16. [ ] Run `cargo test` (non-E2E) — must exit 0
17. [ ] Run `cargo fmt --all -- --check` — must exit 0
18. [ ] Run `cargo clippy --all-targets -- -D warnings` — must exit 0
19. [ ] Commit: `test(e2e): live coverage for component create/edit/delete/rename + issue --component single-key + list filter grammar (S-COMP-E2E-1)`

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|-----------------|-------------------------|-----------------------|
| S-605-2 (AC-010) | Component discovery via `jr component list --project <proj> --output json`, take first, clean-skip on empty/403/404 | This story's AC-009/AC-010/AC-011 discovery step reuses this exact pattern verbatim | Only 403/404 clean-skip; any OTHER non-zero exit is a genuine release-gate failure and must panic loudly, not silently skip |
| S-576-6 | `AttachmentDropGuard`: `Drop`-based best-effort teardown, spawns a FRESH `E2eHarness::new()` inside `drop()` rather than borrowing the outer harness | This story's `ComponentDropGuard` (AC-015) is the same idiom applied to components — first reuse of this pattern outside attachments | A guard's `Drop` must never panic; every failure path is `eprintln!("[WARN] ...")` only |
| S-JSM-E2E-2/3 | `jsm_self_close` discovers state dynamically (transition/resolution) rather than hardcoding names | Not directly reused here (components have no analogous "close" concept), but reinforces the suite-wide principle: probe live API state, don't hardcode | N/A |

## Architecture Compliance Rules

1. **Zero `src/` changes.** If any `src/` file appears in the diff, STOP and escalate — this
   story is entirely `tests/` + documentation (mirrors S-JSM-E2E-3's Rule 1).
2. **`ComponentDropGuard::drop` must never panic.** All failure branches emit
   `eprintln!("[WARN] ComponentDropGuard Drop: ...")` and return; no `unwrap()`/`expect()` on
   the cleanup delete call itself.
3. **AC-010 must use exactly ONE key** on the `issue edit --component` command line. Using
   2+ keys would silently re-exercise BC-3.4.023's bulk path (already covered by the existing
   test) instead of BC-3.4.022's single-key native path this AC targets — this is the
   load-bearing distinction the whole AC exists to close.
4. **No new `JR_E2E_*` environment variable.** Every discovery/fixture-creation need in this
   story is satisfiable via existing `JR_E2E_PROJECT` plus auto-discovery or self-created
   throwaway fixtures — do not introduce a new required or optional env var without first
   re-confirming auto-discovery is genuinely insufficient.
5. **BC corpus must remain unchanged.** Do NOT edit `BC-INDEX.md`, `CANONICAL-COUNTS.md`, or
   any `.factory/specs/prd/bc-*.md` file — every AC here traces to an EXISTING clause.
6. **SURFACE table update is required** for every new subcommand path/flag this story's tests
   invoke — omitting it fails `cargo test --test e2e_cli_surface_guard` at CI time for any
   future contributor who touches this file, per the guard's own stated purpose.

## Library & Framework Requirements

No new `Cargo.toml` dependencies. Zero Rust library additions.

| Tool/Crate | Already available | Usage in this story |
|------------|----------------------|--------------------------|
| `serde_json` | Yes (dev-dependency) | Parse `component`/`issue` JSON responses |
| `assert_cmd` | Yes (dev-dependency) | Spawn `jr` subprocess invocations via `E2eHarness::cmd()` |
| `std::process::Command` via `E2eHarness::cmd()` | Yes | All new test invocations |

## File Structure Requirements

| File | Action | Notes |
|------|--------|---------|
| `tests/e2e_live.rs` | MODIFY | `ComponentDropGuard` + 5 new test functions (AC-001..AC-013 across them) |
| `tests/e2e_cli_surface_guard.rs` | MODIFY | New SURFACE rows for `component create/edit/delete/rename`; `--component` on `issue create`; `--project`+`--component` on `issue list` |
| `docs/specs/e2e-live-jira-testing.md` | MODIFY | §4 test roster gains 5 new function names + `ComponentDropGuard` note; §8 env-var table UNCHANGED |
| `CLAUDE.md` | MODIFY | New `ComponentDropGuard` doc-fallout bullet near the existing `AttachmentDropGuard`/JSM-E2E notes |

**Files confirmed NOT changed:**
- `src/` (all files — zero Rust source changes)
- `.github/workflows/` (all workflow files — no new CI job, rides the existing `e2e:` job)
- `Cargo.toml`, `Cargo.lock`, `deny.toml`
- `BC-INDEX.md`, `CANONICAL-COUNTS.md`, any `.factory/specs/prd/bc-*.md` file

## Branch / PR Plan

- Branch: `test/component-family-live-e2e-coverage`
- Target: `develop`
- Commit: `test(e2e): live coverage for component create/edit/delete/rename + issue --component single-key + list filter grammar (S-COMP-E2E-1)`
- PR body: reference this story (S-COMP-E2E-1), the BC anchors (BC-8.1.001/002/005/007,
  BC-8.2.001/006/008, BC-8.3.001, BC-3.4.022/024/025, BC-2.1.018/019/020), and the
  `ComponentDropGuard` teardown pattern.
- CHANGELOG entry: none required (test-only change, not user-facing).
