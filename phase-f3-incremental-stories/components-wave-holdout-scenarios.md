---
document_type: f3-wave-holdout-scenarios
phase: phase-f3-incremental-stories
epic_id: "COMPONENT-MGMT"
producer: story-writer
timestamp: 2026-08-15
status: complete
---

# F3 Wave Holdout Scenarios — Component Management Bundle

Black-box, behavioral scenarios for the two-wave COMPONENT-MGMT schedule
(`components-wave-schedule.md`): Wave 1 (S-604-1 foundation) and Wave 2 (S-604-2,
S-604-3, S-605-1, S-605-2, S-606-1, S-608-1). Scenarios never reference internal
function names or implementation structure — only observable `jr` CLI behavior
(exit codes, stdout/stderr shape, `--output json` fields, and live-Jira-visible
side effects).

## Wave 1 Holdouts — S-604-1 Foundation

### H-COMPONENT-001 — `resolve_component` is deterministic under NAME collision within one project
Given a project with two components sharing a case-different name (e.g. `"Backend"`
and `"backend"`), `jr issue edit FOO-1 --component "Backend"` (or any other command
routing through the shared resolver) either (a) resolves unambiguously via exact-match
precedence when one candidate is an exact case-sensitive match, or (b) exits 64 with a
disambiguation message listing both candidate IDs, and repeating the identical command
in isolation a second time produces the identical exit code and identical candidate
ordering — no run-to-run nondeterminism in which candidate is preferred or how the
list is ordered.
**Pins:** BC-8.4.001 (S-604-1), BC-8.4.002.

### H-COMPONENT-002 — Component resolution does not leak across projects
Given `PROJ-A` has a component named `"Shared"` and `PROJ-B` also has a component
named `"Shared"` with a DIFFERENT component ID, `jr issue edit PROJA-1 --component
"Shared"` resolves to PROJ-A's component ID; `jr issue edit PROJB-1 --component
"Shared"` resolves to PROJ-B's component ID. Neither invocation returns the other
project's ID, and `jr component list --project PROJ-A` never lists PROJ-B's `"Shared"`
component or vice versa.
**Pins:** BC-8.4.001, BC-8.4.003, BC-8.4.004, BC-2.3.040 (project-scoped cache
partitioning).

### H-COMPONENT-003 — `jr component list --counts` returns accurate per-component issue counts
Given a project with components `A` (3 issues), `B` (0 issues), and `C` (issues split
across two components including `A`), `jr component list --project PROJ --counts`
returns a row per component with an integer count matching the number of issues
currently assigned to that component in Jira (independently verifiable via `jr issue
list --jql "project = PROJ AND component = A"` returning the same cardinality).
`--output json` emits the same counts as a `count` (or equivalently named) integer
field per component object, not a string.
**Pins:** BC-8.1.001, BC-8.1.002, BC-8.1.003, BC-8.1.004.

### H-COMPONENT-004 — Component cache warm-hit produces zero additional HTTP calls
After a first `jr component list --project PROJ` populates the per-profile components
cache, a second `jr component list --project PROJ` invocation within the cache's TTL
window (using `--verbose` to observe request URLs) issues NO additional
`GET .../project/PROJ/components`-shaped request — output is served entirely from the
warm cache and is byte-identical to the first invocation's data (modulo any
`--counts`-triggered live count lookups, which are documented as always-live in
S-604-1's own AC set and are exempt from this cache-hit expectation).
**Pins:** BC-8.4.005 (cache), BC-2.3.040.

## Wave 2 Holdouts — Cross-Story Integration

### H-COMPONENT-005 — `issue create --component` and `issue edit --component` round-trip through the shared resolver
`jr issue create --project PROJ --type Task --summary "X" --component "Backend"`
creates an issue whose `fields.components` (read back via `jr issue view <KEY>
--output json`) contains exactly the resolved component. A subsequent `jr issue edit
<KEY> --component "Frontend"` (S-605-1's single-key add/remove-aware flag) updates
`fields.components` to reflect the new state per S-605-1's documented add/replace
semantics — both commands resolve `"Backend"`/`"Frontend"` through the SAME resolver
S-604-1 established, so a component visible via `jr component list --project PROJ`
is name-resolvable identically from both `create` and `edit`.
**Pins:** BC-3.4.022, BC-3.4.024, BC-3.4.025, BC-3.4.012, BC-3.4.013, BC-3.4.017 (S-605-1); BC-8.4.001 (S-604-1 shared resolver).

### H-COMPONENT-006 — `issue edit --component` bulk path produces the same per-issue result as looping the single-key path
Given three issues in one project with no components set, `jr issue edit KEY1 KEY2
KEY3 --component add:"Backend"` (S-605-2 bulk path) leaves all three issues with
`fields.components` containing `"Backend"`, identical to the result of running `jr
issue edit KEY1 --component add:"Backend"` three times (once per key, S-605-1's
single-key path) — the bulk path is not a distinct code path with divergent
semantics, only a distinct dispatch mechanism per BC-3.4.023 Invariant 3 (fork on
`keys.len()`, same underlying parse).
**Pins:** BC-3.4.023 (S-605-2), BC-3.4.022 (S-605-1, shared parse).

### H-COMPONENT-007 — `issue list --component` filter round-trip
Given a project with 5 issues, 2 of which have `"Backend"` assigned (via prior
`--component` edits from H-COMPONENT-005/006), `jr issue list --project PROJ
--component "Backend"` returns exactly those 2 issues (by key), and `jr issue list
--project PROJ --component "Backend" --output json` returns a JSON array of exactly 2
issue objects. Running the equivalent raw `--jql "project = PROJ AND component =
Backend"` returns the identical key set, confirming the `--component` convenience
flag composes into JQL the same way manual JQL would.
**Pins:** BC-2.1.018, BC-2.1.019, BC-2.1.020, BC-2.1.021, BC-2.1.022 (S-606-1).

### H-COMPONENT-008 — Delete-safety end-to-end: `--move-to` reassigns issues before delete
Given a component `"Legacy"` with 2 issues assigned,
`jr component delete "Legacy" --project PROJ --move-to "Current"` (S-604-3) first
reassigns both issues' `fields.components` from `"Legacy"` to `"Current"` (verifiable
via `jr issue view` on each affected key before the delete completes, or via the
command's own dry-run/confirmation preview), THEN deletes the `"Legacy"` component.
Post-delete, `jr component list --project PROJ` no longer lists `"Legacy"`, and both
previously-affected issues show `"Current"` in their `fields.components`, not an
empty/orphaned state.
**Pins:** BC-8.2.001, BC-8.2.002, BC-8.2.003, BC-8.2.004 (move-to reassignment
ordering).

### H-COMPONENT-009 — Delete-safety end-to-end: orphan handling when no `--move-to` is given
Given a component `"Deprecated"` with 1 issue assigned, `jr component delete
"Deprecated" --project PROJ` WITHOUT `--move-to` either (a) blocks non-interactively
with an exit-64 error naming the affected issue count and requiring `--move-to` or
explicit `--force`/equivalent opt-out per S-604-3's own AC set, or (b) proceeds and
leaves the affected issue with `"Deprecated"` simply removed from its
`fields.components` (Jira's native orphan behavior — the component reference is
dropped, not replaced) — whichever S-604-3 specifies as the documented default is the
one observed; the holdout's pass condition is that the OBSERVED behavior matches
S-604-3's own AC text exactly, with no silent third behavior (e.g., a partial delete
leaving the component undeleted but the issue already unlinked).
**Pins:** BC-8.2.005, BC-8.2.006, BC-8.2.007, BC-8.2.008 (idempotency / 404 taxonomy,
also VP-COMPONENT-024 per S-608-1's AC-017 cross-reference).

### H-COMPONENT-010 — Rename round-trip, single project and `--all-projects` fan-out
`jr component rename "OldName" "NewName" --project PROJ` (S-608-1) causes
`jr component list --project PROJ` to show `"NewName"` (not `"OldName"`) with the SAME
component ID as before the rename (rename mutates the existing resource, it does not
create a new one — verifiable by ID stability). Separately, given `"OldName"` exists
identically-named in 3 projects, `jr component rename "OldName" "NewName"
--all-projects` renames the component in all 3 projects (one `PUT` per matching
project per S-604-3's O(N) fan-out pattern reused by S-608-1's own AC-018), and
`jr component list --project <each>` shows `"NewName"` in all 3, with zero effect on
a 4th project that has no `"OldName"` component.
**Pins:** BC-8.3.001, BC-8.3.002, BC-8.3.003, BC-8.3.004, BC-8.3.005, BC-8.3.006,
BC-8.3.007.

## Regression Holdouts — Existing Behavior Unbroken

### H-COMPONENT-011 — `jr issue edit` with no `--component` flag is byte-identical to pre-bundle behavior
`jr issue edit FOO-1 --summary "New summary"` (no `--component`, no other
component-bundle flag) produces the identical stdout/stderr/exit-code/`--output json`
shape as before S-605-1/S-605-2 landed — no new required field, no new prompt, no
altered `changed_fields` JSON shape for non-component edits. Confirms S-605-1/S-605-2
are additive on `edit.rs`, not a rewrite of its existing dispatch.
**Pins:** BC-3.4.012, BC-3.4.013 (pre-existing changed-fields echo contract,
unaffected).

### H-COMPONENT-012 — `jr issue create` with no `--component` flag is byte-identical to pre-bundle behavior
`jr issue create --project PROJ --type Task --summary "X"` (no `--component`) creates
an issue with no `fields.components` entries (or an empty array, matching Jira's own
default), identical to pre-S-605-1 behavior — the JSM dispatch fork
(`--request-type`) and all pre-existing `create` flags are unaffected by the new
`--component` flag's addition.
**Pins:** ADR-0014 (JSM dispatch fork, unaffected — regression-pin only, no BC
directly covers "flag addition doesn't perturb an unrelated flag").

### H-COMPONENT-013 — `jr issue list` with no `--component` filter is byte-identical to pre-bundle behavior
`jr issue list --project PROJ` (no `--component`) returns the same issue set and same
column set as before S-606-1 landed — confirms the new `--component` filter composes
into JQL only when explicitly supplied and does not alter default list behavior or
default JQL composition.
**Pins:** BC-2.1.018 Invariant (filter is opt-in, additive to existing JQL
composition — regression-pin only).

### H-COMPONENT-014 — `jr component` subcommand group does not perturb any pre-existing top-level CLI surface
`jr --help` and every pre-existing subcommand's own `--help` output (`jr issue
--help`, `jr project --help`, etc.) are unchanged apart from the new `component`
entry appearing in `jr --help`'s subcommand list — no pre-existing flag, subcommand
name, or help text for `issue`/`project`/`board`/`sprint`/`worklog`/`team`/`user`/
`queue`/`requesttype`/`assets`/`auth`/`api` is altered by this bundle's additions to
`src/cli/mod.rs`.
**Pins:** compile-level + clap-surface regression only — no BC directly covers "adding
a new subcommand doesn't rewrite an existing one's help text"; `cargo build` +
`cargo clippy -- -D warnings` succeeding plus an unchanged `--help` snapshot for every
pre-existing subcommand is the discriminating proof (same class of regression pin as
BUCKET1-DEFECTS' H-BUCKET1-002).

### H-COMPONENT-015 — Full `cargo test` regression suite green after the bundle merges
Every pre-existing test in the suite (unit, integration, proptest, snapshot) remains
green after all seven Wave 1 + Wave 2 stories merge to `develop` — no test written for
a prior feature is modified or deleted by this bundle except where a story's own AC
set explicitly documents a superseding change (none currently declared by any of the
seven stories).
**Pins:** wave-level regression gate, no single BC (mirrors BUCKET1-DEFECTS'
full-suite regression convention).

## MUST-PASS Status

All fifteen holdouts (H-COMPONENT-001..015) are MUST-PASS at the post-Wave-2
integration gate (`vsdd-factory:wave-gate`) before this bundle is considered
converged. H-COMPONENT-001..004 additionally gate Wave 1 closure before Wave 2 work is
dispatched — a Wave 1 failure on any of the four foundation holdouts blocks S-604-2,
S-604-3, S-605-1, S-605-2, S-606-1, and S-608-1 from starting, consistent with
`components-wave-schedule.md`'s hard-gate framing of S-604-1.
