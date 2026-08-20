---
document_type: story
level: ops
epic_id: "none"
story_id: "S-COMP-E2E-SWEEP-1"
title: "Extend e2e-sweeper.yml to reap orphaned E2E component fixtures"
wave: feature-followup
status: ready
intent: process-codification
feature_type: ci-infra
mode: feature
scope: standard
severity: LOW
trivial_scope: true
issue: TBD
points: 2
priority: P3
tdd_mode: facade
estimated_effort: xsmall
producer: story-writer
timestamp: "2026-08-20T00:00:00"
phase: 2
cycle: cycle-component-mgmt
inputs:
  - ".github/workflows/e2e-sweeper.yml"
  - "tests/e2e_live.rs"
traces_to: ".factory/STATE.md §Drift Items COMPONENT-E2E-NO-SWEEPER-BACKSTOP"
estimated_days: 0.5
target_module: .github/workflows/e2e-sweeper.yml
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  # BC status: no product BCs — CI-infra story. This story changes ONLY a
  # GitHub Actions workflow file (.github/workflows/e2e-sweeper.yml). It adds
  # no jira-cli product behavior and touches no src/ file, so there is no
  # BC-S.SS.NNN surface to trace to. Precedent: S-PG-MERGE-AUTH-BYPASS and the
  # other SELF-IMPROVEMENT/process-gap follow-up stories in this index use the
  # identical no-BC shape for engine/CI-tooling-only scope.
  []
bcs: []
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/STATE.md §Drift Items COMPONENT-E2E-NO-SWEEPER-BACKSTOP"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 6
assumption_validations: []
risk_mitigations: []
created: "2026-08-20"
version: "1.0"
last_updated: "2026-08-20"
changelog:
  - "1.0 (2026-08-20): Initial draft — opened to close the tracked drift item COMPONENT-E2E-NO-SWEEPER-BACKSTOP (LOW), surfaced 2026-08-20 by S-COMP-E2E-1. Status set directly to ready: no product BCs exist for a CI-infra-only story (S-7.01 gate is satisfied vacuously — see the frontmatter comment above), the scope is small and well-defined, and the acceptance criteria are fully specified below."
breaking_change: false
lineage:
  - COMPONENT-E2E-NO-SWEEPER-BACKSTOP
  - S-COMP-E2E-1
drift_items:
  - COMPONENT-E2E-NO-SWEEPER-BACKSTOP
files_created: []
files_modified:
  - ".github/workflows/e2e-sweeper.yml"
test_files: []
input-hash: "aad0838"
---

> **tdd_mode:** `facade`. This is a zero-`src/`, zero-`tests/` CI-workflow-only
> story: one new step in `.github/workflows/e2e-sweeper.yml`, mirroring the
> shape of the existing "Sweep orphaned E2E issues" step in the same file. The
> Red Gate density check does not apply — there is no Rust code to red/green;
> the operative validation is YAML validity plus a manual `workflow_dispatch`
> run after merge (see AC-006).

# S-COMP-E2E-SWEEP-1: Extend the E2E sweeper to reap orphaned component fixtures

## Narrative

As a `jr` maintainer running the disposable E2E Jira project, I want the daily
`e2e-sweeper.yml` backstop to also reap orphaned **component** fixtures left by
a hard-killed E2E run — not just orphaned issues — so that a SIGKILL / lost
runner / force-cancel that skips `ComponentDropGuard`'s `Drop`-based teardown
does not leave permanent cruft in the E2E project's component list, achieving
the same cleanup parity for components that issues already have.

## Problem

`e2e-sweeper.yml` (added by S-E2E-FORK-1 / hardened since) is **issue-only**:
its one sweep step runs `jr issue list --jql "project=$JR_E2E_PROJECT AND
summary ~ \"e2e\" AND statusCategory != Done AND created <= -1d"` and closes
every match via `jr issue move KEY $STATUS_DONE`. Component fixtures created
by `test_e2e_component_lifecycle_roundtrip` (component name pattern
`{label}-lifecycle-{suffix}`) and `test_e2e_component_rename_roundtrip`
(component name patterns `{label}-rename-src-{suffix}` and
`{label}-rename-dst-{suffix}`) — both added by S-COMP-E2E-1 (PR #719,
`tests/e2e_live.rs`) — rely **solely** on the in-process `ComponentDropGuard`
(a `Drop` impl, modeled on `AttachmentDropGuard`, S-576-6) for cleanup.

`Drop` fires on a normal test return and on a panic-driven unwind, so it
already covers every ordinary failure mode. The gap is narrower: a SIGKILL,
a lost/evicted runner, or a force-cancelled workflow run skips `Drop`
entirely, leaving the throwaway component behind with nothing to reap it —
unlike issues, which get the daily sweeper as a backstop for the identical
failure class. Impact is LOW: an orphaned component is inert cruft (it has no
open-ended cost the way an open issue might), and the per-attempt-unique
`{suffix}` in every fixture name already prevents any re-run collision.
This story closes the parity gap, not a functional defect.

Origin: Drift Item `COMPONENT-E2E-NO-SWEEPER-BACKSTOP` (LOW), surfaced
2026-08-20 during S-COMP-E2E-1's delivery burst, carried forward DEFERRED
across multiple STATE.md bursts as a "candidate follow-up story, not opened"
until this story.

## Source of Truth

Read `.github/workflows/e2e-sweeper.yml` in full before implementing — do not
work from the excerpt in this story alone. Also read the `ComponentDropGuard`
struct and its `Drop` impl in `tests/e2e_live.rs` (added by S-COMP-E2E-1,
modeled on `AttachmentDropGuard`) to confirm the exact fixture-name patterns
this story's sweep step must match: `{label}-lifecycle-{suffix}` (from
`test_e2e_component_lifecycle_roundtrip`) and `{label}-rename-src-{suffix}` /
`{label}-rename-dst-{suffix}` (from `test_e2e_component_rename_roundtrip`).

**Hard safety constraint — read before touching the filter.** Per DEC-280/
DEC-293 and CLAUDE.md, the ES E2E project (`JR_E2E_PROJECT`) now has a
**PERMANENT** component that a human added specifically to satisfy the AC-010
live-smoke-test precondition (`jr issue edit --component` bulk round-trip
needs >= 1 pre-existing component to discover via `jr component list`). This
permanent component is NOT a throwaway fixture, carries none of the
`-lifecycle-`/`-rename-src-`/`-rename-dst-` markers, and **must never be
matched or deleted** by this story's sweep step. See AC-003 below — this is
the single most important acceptance criterion in this story.

## Behavioral Contracts

**None.** This story is entirely a GitHub Actions workflow-file change with
no jira-cli product-behavior surface — see the `behavioral_contracts:`
frontmatter comment. Every AC below is a direct, self-contained assertion
about the shape and safety of the new workflow step, not a trace to a
BC-S.SS.NNN clause.

## Acceptance Criteria

### AC-001 — new sweep step added, mirroring the existing issue-sweep step's structure

A new step, "Sweep orphaned E2E components", is added to the `sweep` job in
`.github/workflows/e2e-sweeper.yml`, positioned AFTER the existing "Sweep
orphaned E2E issues" step. It reuses the SAME `env:` inputs already available
to that job (`JR_BASE_URL: ${{ secrets.JR_E2E_BASE_URL }}`,
`JR_E2E_PROJECT: ${{ vars.JR_E2E_PROJECT }}`) and the already-composed
`JR_AUTH_HEADER` (set into `$GITHUB_ENV` by the existing "Compose auth
header" step — no new secret composition). The step's `run:` block is
best-effort end to end: the whole block is guarded so that acquisition
failure (401, connection error, empty project) never fails the workflow
(mirrors the existing issue-sweep step's `|| true` / `2>/dev/null || true`
convention), and each per-component delete is isolated so one failure never
aborts the sweep loop (mirrors the existing step's per-key `|| true` /
`echo "WARN: ..."` pattern) — the workflow's overall exit status is
unaffected by any individual component's sweep outcome.

### AC-002 — mechanism: list, filter by fixture-marker name, delete

The step runs `jr component list --project "$JR_E2E_PROJECT" --output json`,
filters the resulting array by name using the fixture-marker predicate in
AC-003, and for every match runs `jr component delete <name> --project
"$JR_E2E_PROJECT" --orphan --yes` (component `delete` accepts a name or
numeric id per `jr component delete`'s existing CLI surface; `--orphan --yes`
is the same non-interactive disposition-required path `ComponentDropGuard`
itself already uses, so the sweeper's delete semantics are IDENTICAL to the
in-test teardown path it backstops — no new delete code path is introduced).

### AC-003 — CRITICAL SAFETY: match ONLY throwaway fixture markers, never the permanent AC-010 component

The filter predicate matches a component **if and only if** its `name`
contains at least one of the three literal substrings: `-lifecycle-`,
`-rename-src-`, `-rename-dst-`. No other matching heuristic (age, prefix-only,
label-only, "starts with e2e") is acceptable — those patterns are looser than
necessary and risk matching the permanent AC-010 component or a future
non-fixture component by accident. The jq filter implementing this predicate
MUST be expressible as (or equivalent to):

```
jq -r '.[] | select(.name | test("-lifecycle-|-rename-src-|-rename-dst-")) | .name'
```

**Assertion the implementer must verify by hand before merge** (this story's
scope excludes writing an automated test for the workflow — see "Out of
Scope" — so this check is a manual, recorded verification step): construct a
small representative JSON array containing (a) at least one name matching
each of the three markers, (b) a plausible permanent-component name with NO
marker substring (e.g. the literal name of ES's actual AC-010 component, or
a stand-in such as `"Platform"` / `"Core"` if the real name should not be
hardcoded into a public workflow file), and (c) an unrelated non-fixture
component name. Run the jq filter locally against that fixture and confirm
group (a) is selected and groups (b) and (c) are NOT. Record the command and
its output in the PR description as evidence.

### AC-004 — safety rationale for name-only matching (no age filter) documented in the step comment

The step comment explains, in the workflow file itself (not only in this
story), why no `created`/age-based filter is used: Jira components carry no
queryable creation timestamp (unlike issues, which expose `created` to JQL),
so an age filter is not mechanically available the way it is for the issue
sweep. The comment further states the safety argument that makes name-only
matching sufficient: this sweeper shares the `jira-e2e` concurrency group
with `e2e.yml` (`concurrency: group: jira-e2e, cancel-in-progress: false`),
so the sweeper never runs while a live E2E run holds the group — a currently
in-flight test's fixture cannot be mid-creation when the sweeper's list/match
step executes, because the sweeper cannot start until the live run (or a
prior sweep) releases the group. Matching by fixture-marker name alone
therefore cannot delete an in-flight fixture; the "no age filter" gap that
would otherwise be a real race is closed by workflow-level serialization
instead.

### AC-005 — no new secret, no egress change, no new action; reuses existing harden-runner allowlist

The new step introduces: zero new GitHub Actions secrets (reuses
`JR_AUTH_HEADER` already composed into `$GITHUB_ENV` by the existing "Compose
auth header" step); zero new repository variables beyond the ones the issue
sweep already reads (`JR_E2E_PROJECT`); zero new `uses:` actions (the step is
a `run:` block using the already-built `./target/debug/jr` binary and `jq`,
both already available to the job); zero egress-allowlist changes (the
`step-security/harden-runner` `allowed-endpoints` block already includes
`*.atlassian.net:443`, which covers `jr component list`/`jr component
delete`'s HTTP calls — no new host is contacted). This AC is satisfied by a
diff review confirming the `harden-runner` step, `permissions:` block,
`environment:` block, and `concurrency:` block are byte-identical to their
pre-change state — only the new step body itself is new content.

### AC-006 — validation note: offline YAML/jq-pattern check now, live `workflow_dispatch` after merge

Because `e2e-sweeper.yml` only runs on a daily `schedule:` cron plus
`workflow_dispatch` (never on normal PR CI), this story's PR cannot exercise
the new step end-to-end before merge. The AC for pre-merge validation is
narrower and explicit: (a) the YAML parses (`actionlint` clean, or an
equivalent local YAML-validity check, on the full file); (b) the jq-filter
correctness check from AC-003 is run locally and its output recorded in the
PR description. Full end-to-end validation — confirming the step actually
lists, filters, and deletes real throwaway components on the live ES project
without touching the permanent AC-010 component — is deferred to a
`workflow_dispatch` run of `e2e-sweeper.yml` performed by a human AFTER
merge, mirroring how `S-E2E-FORK-1`/`S-COMP-E2E-1` validated other
sweeper/E2E changes post-merge via a real Actions run. This story's Task list
(below) includes recording that post-merge validation run's outcome once it
happens, but does NOT block merge on it — the sweeper is best-effort
infrastructure, not a release gate.

## Architecture Mapping

This story is pure CI-workflow-file editing — it invokes the existing `jr
component list` / `jr component delete` product surfaces as a black-box
subprocess consumer (identical to how the existing issue-sweep step invokes
`jr issue list` / `jr issue move`) and modifies no `src/` implementation.

| Component | Module | Pure/Effectful |
|-----------|--------|---------------|
| `jr component list` / `jr component delete` | `src/cli/component.rs` (SS-07, SS-08) — exercised as a subprocess, not modified | effectful-shell |
| New "Sweep orphaned E2E components" step | `.github/workflows/e2e-sweeper.yml` | effectful-shell (CI workflow step, spawns `jr` subprocesses against live Jira) |

## Dependency Justification

- **`depends_on: []`** — This story only reads the already-shipped `jr
  component list`/`jr component delete` CLI surfaces (S-604-1/S-604-3, both
  `done`) and the already-shipped `ComponentDropGuard` fixture-name
  conventions (S-COMP-E2E-1, `done`). It requires no code from an
  in-flight story and adds no product code of its own, so there is no
  build-order dependency to declare. The prerequisite product surfaces are
  already merged to `develop`.
- **`blocks: []`** — No story depends on this sweeper-hardening story to
  proceed; it is pure operational-cleanup infrastructure layered on top of
  already-merged, already-DONE work.

## Anchor Justification

- **`subsystems: []`** — No SS-ID from the ARCH-INDEX Subsystem Registry owns
  this story's scope: it is a `.github/workflows/` CI-operations change, not
  a `src/` module change, and the Subsystem Registry scopes product source
  modules, not CI workflow files. Flagging this explicitly rather than
  force-fitting a subsystem: if a future ARCH-INDEX revision adds a
  CI-infrastructure subsystem, this story should be re-anchored to it.
- **`epic_id: "none"`** — Matches the sibling `S-COMP-E2E-1`, `S-E2E-*`, and
  `S-JSM-E2E-*` test/CI-infra stories in this index, NOT the
  `SELF-IMPROVEMENT` epic (which is reserved for Dark Factory
  engine/process-gap stories with no jira-cli product surface at all — this
  story, by contrast, touches this repository's own CI configuration for a
  jira-cli product-testing concern).

## Edge Cases

| ID | Description | Expected Behavior |
|----|--------------|--------------------|
| EC-SWEEP-COMP-1 | `jr component list` returns a 401/empty/error | Step-level `|| true` / `2>/dev/null || true` guard absorbs it; workflow does not fail (AC-001) |
| EC-SWEEP-COMP-2 | Zero components match the fixture-marker filter | The delete loop iterates zero times; step succeeds trivially |
| EC-SWEEP-COMP-3 | A single `jr component delete` call fails (e.g. component already gone, 404) | Per-item `|| true` isolates the failure; loop continues to the next match; a `WARN:` line is echoed (mirrors the issue-sweep step's per-key pattern) |
| EC-SWEEP-COMP-4 | The permanent AC-010 component's name happens to contain one of the marker substrings by coincidence | Not expected in practice (the marker substrings are deliberately specific, hyphen-delimited fixture idioms unlikely to appear in a human-chosen component name) but if it ever did, AC-003's manual verification step is the intended catch — the implementer must confirm the REAL permanent component's name at the target project does not match before enabling the step live |
| EC-SWEEP-COMP-5 | Sweeper and a live `e2e.yml` run are both queued around the same time | `concurrency: group: jira-e2e, cancel-in-progress: false` serializes them — the sweeper cannot start mid-run, closing the race the "no age filter" design otherwise depends on (AC-004) |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|--------------------|
| This story spec | ~4k |
| `.github/workflows/e2e-sweeper.yml` (read + edit) | ~2k |
| `tests/e2e_live.rs` `ComponentDropGuard` + fixture-name sections (read for pattern confirmation) | ~2k |
| CLAUDE.md AC-010/permanent-component context (read) | ~1k |
| Local jq-filter verification + `actionlint` run | ~1k |
| **Total** | **~10k** |
| Agent context window | 200K |
| **Budget usage** | **~5%** |

Well within the 20-30% single-agent budget; no split required.

## Tasks

1. [ ] Read `.github/workflows/e2e-sweeper.yml` in full (both the header
   comment block and the existing "Sweep orphaned E2E issues" step) to
   confirm the exact structural pattern to mirror.
2. [ ] Read `ComponentDropGuard` and the fixture-name construction in the two
   component-fixture tests (`test_e2e_component_lifecycle_roundtrip`,
   `test_e2e_component_rename_roundtrip`) in `tests/e2e_live.rs` to confirm
   the three marker substrings (`-lifecycle-`, `-rename-src-`,
   `-rename-dst-`) exactly.
3. [ ] Add the new "Sweep orphaned E2E components" step per AC-001/AC-002,
   positioned after the existing issue-sweep step.
4. [ ] Write the jq filter per AC-003; run the manual verification described
   in AC-003 locally against a representative fixture JSON array; record the
   command + output in the PR description.
5. [ ] Add the step comment documenting the no-age-filter safety rationale
   per AC-004.
6. [ ] Diff-review the `harden-runner`/`permissions`/`environment`/
   `concurrency` blocks to confirm byte-identical (AC-005).
7. [ ] Run `actionlint` (or equivalent) against `.github/workflows/
   e2e-sweeper.yml` — must be clean.
8. [ ] Open the PR; note in the description that live validation is deferred
   to a post-merge `workflow_dispatch` run (AC-006).
9. [ ] After merge, when the human triggers the `workflow_dispatch` run,
   record the run URL/outcome as a follow-up note (not a merge blocker).

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|-----------------|-------------------------|-----------------------|
| S-E2E-FORK-1 | `e2e-sweeper.yml`'s original issue-sweep step shape: `|| true` acquisition guard, per-key `|| true` delete-loop isolation, `JR_E2E_ENABLED` repo-var gate mirrored from `e2e.yml` | This story's new component-sweep step reuses the identical best-effort/per-item-isolation idiom verbatim — do not invent a different error-handling shape | The sweeper shares `harden-runner`'s exact allowlist with `e2e.yml`; any new host contacted by a sweep step must be added there — but this story adds none |
| S-COMP-E2E-1 | `ComponentDropGuard` (`Drop`-based, modeled on `AttachmentDropGuard`) is the primary teardown; fixture names are constructed as `{label}-lifecycle-{suffix}` / `{label}-rename-src-{suffix}` / `{label}-rename-dst-{suffix}` for per-attempt uniqueness | This story's sweeper filter keys directly off those three marker substrings — the naming convention IS the sweep predicate, so any future rename-pattern change in `tests/e2e_live.rs` must be mirrored here | `ComponentDropGuard`'s `Drop` already covers panic-unwind; the sweeper backstop is scoped ONLY to the SIGKILL/lost-runner/force-cancel class that `Drop` cannot observe |
| DEC-280/DEC-293 (AC-010) | ES E2E project has a PERMANENT component a human added for the AC-010 live smoke test | This story's AC-003 exists specifically to guarantee that permanent component is never matched | Any looser filter (age, prefix-only, "contains e2e") risks catching the permanent component — rejected explicitly in AC-003 |

## Architecture Compliance Rules

1. **Zero `src/` changes, zero `tests/` changes.** This story touches
   exactly one file: `.github/workflows/e2e-sweeper.yml`. If any other file
   appears in the diff, STOP and escalate.
2. **Filter predicate MUST be marker-substring-only** (`-lifecycle-`,
   `-rename-src-`, `-rename-dst-`) — no age/prefix/label-based matching, per
   AC-003. This is the single non-negotiable rule in this story.
3. **No new secrets, no new `uses:` actions, no egress-allowlist change.**
   The step must be additive-only within the job's existing trust boundary
   (AC-005).
4. **Best-effort, never workflow-failing.** Every acquisition and every
   per-item delete must be independently `|| true`-guarded, matching the
   existing issue-sweep step's convention — the sweeper as a whole must never
   go red because of a single stale/missing/permission-denied component.

## Library & Framework Requirements

No new dependencies of any kind — no new GitHub Action, no new CLI tool
beyond `jq` (already used by the existing issue-sweep step in this same
file), no `Cargo.toml` change.

| Tool | Already available in the job | Usage in this story |
|------|-------------------------------|--------------------------|
| `jq` | Yes (used by the existing issue-sweep step) | Filter `jr component list --output json` by fixture-marker name |
| `./target/debug/jr` | Yes (built earlier in the job by the existing "Build jr (debug)" step) | `component list` / `component delete` invocations |

## File Structure Requirements

| File | Action | Notes |
|------|--------|---------|
| `.github/workflows/e2e-sweeper.yml` | MODIFY | Add one new step, "Sweep orphaned E2E components", after the existing "Sweep orphaned E2E issues" step |

**Files confirmed NOT changed:**
- `src/` (all files)
- `tests/` (all files)
- `.github/workflows/e2e.yml` (unrelated workflow; not touched)
- `CLAUDE.md`, `STATE.md` (out of scope for this story's implementer — index/state bookkeeping is handled separately)

## Branch / PR Plan

- Branch: `ci/e2e-sweeper-components`
- Target: `develop`
- Commit: `ci(e2e): extend e2e-sweeper.yml to reap orphaned component fixtures (closes COMPONENT-E2E-NO-SWEEPER-BACKSTOP)`
- PR body: reference this story (S-COMP-E2E-SWEEP-1), the drift item
  (COMPONENT-E2E-NO-SWEEPER-BACKSTOP), the AC-003 jq-filter verification
  command + output, and a note that live validation is deferred to a
  post-merge `workflow_dispatch` run.
- CHANGELOG entry: none required (CI-infra-only change, not user-facing).

## Out of Scope

- Any `src/` product-code change — `jr component list`/`jr component delete`
  are used as-is, unmodified.
- Any automated Rust test for the new workflow step — GitHub Actions
  workflow YAML has no unit-test harness in this repo comparable to
  `tests/backfill_matrix_parity.rs` for this specific sweeper file; the
  validation is offline YAML/jq-pattern verification (AC-006) plus a
  post-merge live run, not a new `tests/*.rs` file.
- Adding an analogous sweeper mechanism for any OTHER fixture type beyond
  components (e.g. a hypothetical future project-level or field-level
  fixture) — scoped strictly to the component-fixture gap this story exists
  to close.
- Changing `ComponentDropGuard` itself, or any other part of
  `tests/e2e_live.rs` — the sweeper is a backstop layered on top of, not a
  replacement for, the existing Drop-based teardown.
- Adding an age-based filter mechanism (e.g. reading a Jira field that could
  be repurposed as a creation-time proxy) — explicitly rejected in AC-004;
  workflow-level concurrency serialization is the chosen safety mechanism
  instead.
