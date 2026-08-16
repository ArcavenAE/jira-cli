---
document_type: story
level: ops
epic_id: "none"
story_id: "S-604-3"
title: "jr component delete — disposition-required, snapshot-before-delete safety"
wave: null
status: draft
intent: feature
feature_type: backend
mode: feature
scope: standard
severity: N/A
trivial_scope: false
issue: 604
points: 13
priority: P0
tdd_mode: strict
estimated_effort: large
producer: story-writer
timestamp: "2026-08-15T00:00:00"
phase: 2
cycle: cycle-component-mgmt
inputs:
  - ".factory/specs/prd/bc-8-components.md"
  - ".factory/specs/architecture/decisions/ADR-0018-component-resolution-caching-mutation-strategy.md"
  - ".factory/phase-f2-spec-evolution/verification-delta-components.md"
  - ".factory/research/component-delete-and-bulk-wire-2026-08-15.md"
traces_to: ".factory/specs/prd/bc-8-components.md"
estimated_days: 5
target_module: src/cli/component.rs
subsystems: ["SS-02", "SS-04", "SS-08"]
depends_on: ["S-604-1"]
blocks: []
behavioral_contracts:
  - "BC-8.2.001"
  - "BC-8.2.002"
  - "BC-8.2.003"
  - "BC-8.2.004"
  - "BC-8.2.005"
  - "BC-8.2.006"
  - "BC-8.2.007"
  - "BC-8.2.008"
bcs:
  - "BC-8.2.001"
  - "BC-8.2.002"
  - "BC-8.2.003"
  - "BC-8.2.004"
  - "BC-8.2.005"
  - "BC-8.2.006"
  - "BC-8.2.007"
  - "BC-8.2.008"
verification_properties: ["VP-COMPONENT-003", "VP-COMPONENT-004", "VP-COMPONENT-005", "VP-COMPONENT-006", "VP-COMPONENT-007", "VP-COMPONENT-017", "VP-COMPONENT-024"]
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0018", "ADR-0015"]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-8-components.md"
implementation_strategy: tdd
module_criticality: SAFETY-CRITICAL
acceptance_criteria_count: 22
assumption_validations: []
risk_mitigations: []
created: "2026-08-15"
version: "1.0"
last_updated: "2026-08-15"
breaking_change: false
retroactive: false
origin: >
  GitHub issue #604 (`jr component list/create/edit/delete`), delete-safety facet (DEC-279).
  Split from S-604-2 into its own story because `component delete` is irreversible (no
  trash/archive/undelete endpoint exists — research §Q1.2) with an unconfirmed audit trail
  (§Q1.3), demanding a dedicated disposition-required guard, a JQL pre-delete snapshot with
  mandatory full pagination, and a two-tier 404 taxonomy — materially more adversarial-review
  surface than create/edit's ordinary partial-update shape. Mirrors ADR-0015's
  `--resolution`/`--no-resolution` "never guess a destructive disposition" precedent.
files_modified:
  - src/api/jira/components.rs
  - src/cli/component.rs
  - src/cli/mod.rs
  - src/error.rs
test_files:
  - tests/component_commands.rs
  - tests/common/fixtures.rs
input-hash: "908b782"
---

> **tdd_mode:** `strict`. This is the SAFETY-CRITICAL story of the bundle — every ordering
> guarantee below (snapshot-before-DELETE, disposition-before-mutation, confirming-GET-
> before-DELETE) must be pinned by a mutation-resistant wiremock assertion, not merely a
> happy-path test.

# S-604-3: `jr component delete` — disposition-required, snapshot-before-delete safety (DEC-279)

## Narrative

As a `jr` user who might accidentally delete a component that hundreds of issues depend on, I
want `jr component delete` to REFUSE to run without an explicit disposition
(`--move-to`/`--orphan`), to snapshot every affected issue key via a fully-paginated read-only
JQL search before the irreversible `DELETE` fires, and to require an extra confirmation step
for the strictly-more-destructive `--orphan` path, so that I can never silently lose the
component-to-issue association for a component I didn't mean to delete, and always have a
reconstruction record if I did mean to.

## Source of Truth

Read **BC-8.2.001 through BC-8.2.008** in `bc-8-components.md` §8.2 in full — these eight BCs
carry the densest adversarial-review correction history in the entire bundle (17+ named
fix-bursts closing gaps across 16 review passes: numeric-source project confirmation broadened
from `--move-to`-only to both dispositions, JRACLOUD-95368 pagination-drift fail-closed
handling, exit-code taxonomy corrections). Only the LATEST, non-superseded prose in each BC is
normative — do not implement anything described in a "Previous version (superseded)" block.
Also read `research/component-delete-and-bulk-wire-2026-08-15.md` §Q1 and **ADR-0018 Decision
§1 (numeric-source confirming GET) and §3 (delete-safety policy)** in full.

## Behavioral Contracts

| BC ID | Title |
|-------|-------|
| BC-8.2.001 | `delete` refuses (exit 64) without EITHER `--move-to` OR `--orphan` |
| BC-8.2.002 | `--move-to` DELETEs with `moveIssuesTo`; target resolution completes BEFORE the DELETE; numeric source/target project confirmation |
| BC-8.2.003 | `--move-to` target must resolve within the SAME project as the source |
| BC-8.2.004 | `--move-to` target ambiguous/unknown → exit 64 before DELETE |
| BC-8.2.005 | `--move-to <SELF>` → exit 64 pre-flight, zero HTTP |
| BC-8.2.006 | `--orphan` DELETEs with no `moveIssuesTo`; requires `--yes` or interactive confirm naming affected-issue count |
| BC-8.2.007 | Affected issue keys snapshotted (JQL `component = <id> ORDER BY key ASC`, fully paginated) BEFORE the DELETE |
| BC-8.2.008 | `--output json` delete result shape; delete is NOT idempotent — source-not-found → exit 64, concurrent-delete race → exit 1 |

## Behavior Summary (verbatim per BC — do not deviate)

- **Disposition-required guard (BC-8.2.001)**: neither `--move-to` nor `--orphan` → exit 64,
  names BOTH flags, ZERO `DELETE`/snapshot-search calls. Both supplied → clap
  `conflicts_with` mutual exclusion, exit 2 — implemented as a clap mechanism for the
  both-case, but the NEITHER-case MUST be an application-level `JrError::UserError` check
  (NOT a clap `ArgGroup::required(true)`, which would wrongly produce exit 2 — DEC-188 class,
  mechanically identical to BC-8.3.005's `--project`/`--all-projects` split). The `NAME|ID`
  not-found check (§8.4) fires and is reported BEFORE this disposition guard for a NAME input
  — but for a NUMERIC `NAME|ID` with neither flag supplied, there is NO HTTP call available in
  that path to discover non-existence (the numeric-source confirming GET only fires once a
  disposition is chosen), so the disposition-guard message fires INSTEAD of "not found" — a
  genuine, accepted asymmetry (Invariant 1's documented exception, EC-8.2.001-4).
- **`--move-to <NAME|ID>` (BC-8.2.002/003/004/005)**: target resolves via §8.4, SCOPED TO THE
  SOURCE'S PROJECT ONLY (never a cross-project search — BC-8.2.003). A cross-project match is
  treated identically to "no match in scope" (exit 64, zero DELETE). A NUMERIC `--move-to`
  value fires ONE extra confirming `GET /rest/api/3/component/{targetId}` (target-side) to
  validate its project matches the source's — mismatch/404 → exit 64, zero DELETE. Self-move
  (`--move-to` resolves to the SAME id as the source, by ID equality not name-string equality)
  → exit 64 pre-flight, `"--move-to target is the same component being deleted. Choose a
  different component, or use --orphan."` On success: `DELETE
  /rest/api/3/component/{sourceId}?moveIssuesTo=<targetId>`.
- **Numeric-SOURCE project confirmation (BC-8.2.002 M1, broadened to BOTH dispositions)**: when
  the SOURCE `NAME|ID` is numeric, `jr` fires ONE confirming `GET
  /rest/api/3/component/{sourceId}` (the SAME GET BC-8.1.008's numeric bypass already requires
  for existence) and reads its `project` field — for BOTH `--move-to` AND `--orphan` (NOT
  `--move-to`-only; this is the P4 fix-burst broadening, closing a silent-orphan gap). This
  fires ONCE a disposition has been CHOSEN (i.e. it does NOT fire in the no-disposition exit-64
  path — mirrors BC-8.2.007's own "no read-only work before a disposition is chosen" boundary).
  A supplied `--project KEY` mismatching this field → exit 64 pre-flight, `"Component
  <sourceId> belongs to project <actual>, not <KEY>."`, ZERO snapshot-search calls, ZERO
  `DELETE` calls, and (interactive mode) no confirmation prompt ever shown.
- **`--orphan` confirmation gate (BC-8.2.006)**: interactive (TTY, no `--no-input`) →
  `dialoguer` confirm: `"Delete component '<name>' and remove it from <N> issue(s)? This
  cannot be undone. [y/N]"` — decline/Enter → exit 0, zero DELETE. Non-interactive (`--no-input`
  or non-TTY): `--yes` present → proceed; `--yes` absent → exit 64, `"--orphan requires --yes
  when running non-interactively. This permanently removes the component from <N> issue(s)
  with no replacement."` The affected-issue snapshot (BC-8.2.007) is taken BEFORE EITHER the
  prompt OR the `--yes`-absent exit-64 check, so `<N>` is always a real count, never a
  placeholder — this ordering is load-bearing (Invariant 2). `--move-to` NEVER requires this
  gate.
- **Pre-delete JQL snapshot (BC-8.2.007) — the safety-critical core**: fires exactly once per
  invocation that reaches a chosen, guard-cleared disposition (NOT in the no-disposition
  exit-64 path). Composed JQL is ALWAYS `component = <resolvedId> ORDER BY key ASC` — the
  resolved NUMERIC id, NEVER `component = "<name>"` (a bare-name clause is not project-scoped
  by Jira and would inflate the count with same-named components in other projects — the exact
  cross-project collision BC-8.4.004 exists to prevent). `ORDER BY key ASC` is MANDATORY
  (JRACLOUD-95368 pagination-stability precedent). MUST iterate ALL cursor pages via the SAME
  `search_issue_keys`-style pagination loop used elsewhere in this codebase — a single-page
  fetch that truncates would corrupt a safety-critical count. **Fail-closed on ANY
  non-normal-completion outcome**, including the JRACLOUD-95368 anti-loop guard's SUCCESSFUL
  `has_more=true` partial return (NOT an `Err` — this codebase's existing anti-loop guard does
  not raise an error, so `component delete`'s own drift-check must synthesize one): on
  detecting `has_more=true`, exit 1 with a NEW `JrError::SnapshotIncomplete(String)` variant
  (add to `src/error.rs`, falling to the `_ => 1` exit-code default), message containing
  `"could not reliably enumerate affected issues — aborting delete"`. A genuine fetch error
  (5xx/network) during the snapshot also aborts before DELETE (fail-closed).
- **`--output json` result shape / idempotency (BC-8.2.008)**: success →
  `{"deleted": "<sourceId>", "movedIssuesTo": "<targetId>"|null, "affectedIssueCount": N,
  "affectedIssues": ["<KEY-1>", ...]}`. Component delete is NOT idempotent: SOURCE resolution
  itself returning not-found (BC-8.1.008) is the ORDINARY not-found exit-64 path — NEVER
  treated as "already deleted, exit 0." A `DELETE` that itself races and returns 404 (deleted
  by a concurrent actor AFTER a successful resolution) → `ApiError(404)`, exit 1 — the two are
  DISTINGUISHABLE by exit code (64 vs 1) and MUST NOT be collapsed (VP-COMPONENT-024, this
  BC's CANONICAL definition — S-604-2's `edit` story and S-608-1's `rename` story both extend
  this same property to their own mutating call).

## Acceptance Criteria

### AC-001 (traces to BC-8.2.001 postcondition 1)
`jr component delete Backend --project FOO` (neither flag) → exit 64, stderr names BOTH
`--move-to <NAME|ID>` and `--orphan`, ZERO `DELETE`/snapshot-search calls (VP-COMPONENT-003).
**Test:** `test_bc_8_2_001_component_delete_neither_flag_exits_64_zero_http()`

### AC-002 (traces to BC-8.2.001 postcondition 2 / DEC-188 mechanism)
`--move-to X --orphan` together → clap exit 2 (mutual exclusion), before any resolution or
HTTP. The neither-flag case (AC-001) is produced by an application-level guard, NOT a clap
`ArgGroup::required(true)` (which would wrongly exit 2).
**Test:** `test_bc_8_2_001_component_delete_both_flags_clap_exit_2()`

### AC-003 (traces to BC-8.2.001 Invariant 1 / EC-8.2.001-3)
`jr component delete Nonexistent --orphan` (NAME, unresolvable) → exit 64 "not found"
(Invariant 1 ordering), NOT the disposition-guard message.
**Test:** `test_bc_8_2_001_component_delete_name_notfound_before_disposition_guard()`

### AC-004 (traces to BC-8.2.001 Invariant 1 documented exception / EC-8.2.001-4)
`jr component delete 999999999` (numeric, nonexistent, NEITHER flag) → exit 64
disposition-guard message, NOT "not found" — the inverse of AC-003, per the documented
numeric/no-disposition asymmetry.
**Test:** `test_bc_8_2_001_component_delete_numeric_no_disposition_asymmetry()`

### AC-005 (traces to BC-8.2.002 postcondition 2 — move-to success)
`jr component delete Backend --project FOO --move-to Frontend` → target resolves BEFORE
`DELETE`; `DELETE /rest/api/3/component/{sourceId}?moveIssuesTo=<targetId>` fires exactly
once on success.
**Test:** `test_bc_8_2_002_component_delete_move_to_success_delete_after_resolution()`

### AC-006 (traces to BC-8.2.003 Behavior / EC-8.2.003-1)
`--move-to Backend` where the SAME-named component exists in a different project → resolves
ONLY within the source's project; the other project's component-list endpoint is never
called (`.expect(0)`).
**Test:** `test_bc_8_2_003_component_delete_move_to_never_spans_projects()`

### AC-007 (traces to BC-8.2.002 numeric-target confirmation / EC-8.2.003-2)
`--move-to 20007` (numeric, belonging to a DIFFERENT project than the source) → confirming
`GET /rest/api/3/component/20007` returns the mismatching project → exit 64, ZERO `DELETE`.
**Test:** `test_bc_8_2_002_component_delete_move_to_numeric_target_project_mismatch()`

### AC-008 (traces to BC-8.2.004 postcondition)
`--move-to BadName`/`--move-to Amb` (unknown/ambiguous target) → exit 64 via §8.4's
BC-8.4.002/003 messages, ZERO `DELETE` calls (VP-COMPONENT-004).
**Test:** `test_bc_8_2_004_component_delete_move_to_unknown_ambiguous_zero_delete()`

### AC-009 (traces to BC-8.2.005 postcondition / VP-COMPONENT-005)
`jr component delete Backend --move-to Backend` (self-move, same name) → exit 64, zero
`DELETE`. `jr component delete Backend --move-to 10001` where `Backend` IS id `10001`
(mixed name/numeric self-reference) → exit 64 identically (ID-equality catches both).
**Test:** `test_bc_8_2_005_component_delete_self_move_guard_name_and_numeric()`

### AC-010 (traces to BC-8.2.002 M1 numeric-SOURCE confirmation, broadened both dispositions)
`jr component delete 20007 --project A --move-to Frontend` where `20007` actually belongs to
project B → source-confirmation GET returns `"project":"B"`, mismatching `--project A` →
exit 64 pre-flight, ZERO HTTP beyond the one confirming GET (no `--move-to` resolution GET,
no `DELETE`).
**Test:** `test_bc_8_2_002_component_delete_numeric_source_project_mismatch_move_to()`

### AC-011 (traces to BC-8.2.002 M1, P4-broadened to `--orphan`)
`jr component delete 20007 --project A --orphan --yes` where `20007` belongs to project B →
identical mismatch check fires under `--orphan` too → exit 64 pre-flight, ZERO snapshot
search, ZERO confirmation prompt, ZERO `DELETE`.
**Test:** `test_bc_8_2_002_component_delete_numeric_source_project_mismatch_orphan()`

### AC-012 (traces to BC-8.2.006 Postconditions — interactive)
`--orphan` on a TTY (no `--yes`) → `dialoguer` confirm names the component and the
snapshot-derived affected-issue count; decline/Enter default → exit 0, ZERO `DELETE`;
confirm → proceeds to `DELETE` (VP-COMPONENT-007).
**Test:** `test_bc_8_2_006_component_delete_orphan_interactive_prompt_decline_and_confirm()`

### AC-013 (traces to BC-8.2.006 Postconditions — non-interactive / VP-COMPONENT-006)
Non-interactive `--orphan` without `--yes` → exit 64, message contains the REAL,
snapshot-derived affected-issue count `<N>` (not a placeholder), ZERO `DELETE`. `--yes`
present → proceeds without a prompt, on a TTY or not.
**Test:** `test_bc_8_2_006_component_delete_orphan_noninteractive_requires_yes_real_count()`

### AC-014 (traces to BC-8.2.006 Invariant 1)
`--move-to` NEVER shows a confirmation prompt or requires `--yes`, regardless of TTY/
`--no-input` state — only `--orphan` carries this gate.
**Test:** `test_bc_8_2_006_component_delete_move_to_never_prompts()`

### AC-015 (traces to BC-8.2.006 Edge Case EC-8.2.006-2)
`--orphan` on a component with ZERO affected issues → prompt/message STILL fires, showing
`0 issue(s)` — deleting the component itself is still permanent regardless of current usage.
**Test:** `test_bc_8_2_006_component_delete_orphan_zero_affected_issues_still_prompts()`

### AC-016 (traces to BC-8.2.007 Postcondition 1 — firing boundary)
The snapshot search fires exactly once for a chosen, guard-cleared disposition and does NOT
fire in the no-disposition exit-64 path (BC-8.2.001) or any pre-flight exit-64 path before a
disposition is confirmed (unknown/ambiguous target, self-reference).
**Test:** `test_bc_8_2_007_component_delete_snapshot_fires_only_after_disposition_cleared()`

### AC-017 (traces to BC-8.2.007 Postcondition 4 — JQL clause shape)
The composed snapshot JQL is ALWAYS `component = <resolvedId> ORDER BY key ASC` — a fixture
with two projects sharing a same-named component asserts the snapshot body contains the
resolved NUMERIC id, never the shared name string.
**Test:** `test_bc_8_2_007_component_delete_snapshot_jql_uses_resolved_id_not_name()`

### AC-018 (traces to BC-8.2.007 Postcondition 5 — full pagination)
A wiremock fixture returning ≥2 pages via `nextPageToken` → every page is fetched;
`affectedIssueCount`/`affectedIssues` reflect the FULL multi-page result, not just page one.
**Test:** `test_bc_8_2_007_component_delete_snapshot_paginates_to_completion()`

### AC-019 (traces to BC-8.2.007 Postcondition 5 — fail-closed on drift/error)
A fixture simulating the JRACLOUD-95368 anti-loop drift condition (`has_more=true` partial
return) → `.expect(0)` on `DELETE`, process exits 1, stderr contains "could not reliably
enumerate affected issues — aborting delete" (VP-COMPONENT-017). A genuine snapshot-search
5xx/network failure produces the same fail-closed outcome (zero DELETE).
**Test:** `test_bc_8_2_007_component_delete_snapshot_drift_and_fetch_error_fail_closed()`

### AC-020 (traces to BC-8.2.008 Behavior — success shape)
On success: `--output json` returns `{"deleted": "<id>", "movedIssuesTo": "<targetId>"|null,
"affectedIssueCount": N, "affectedIssues": [...]}` matching the snapshot exactly; table mode
echoes a one-line confirmation naming disposition and count.
**Test:** `test_bc_8_2_008_component_delete_success_json_shape_matches_snapshot()`

### AC-021 (traces to BC-8.2.008 Idempotency — not-found vs race, VP-COMPONENT-024 canonical)
SOURCE resolution returning not-found (BC-8.1.008) → ordinary exit-64 not-found path, NEVER
exit-0/idempotent-skip, ZERO `DELETE` calls. A wiremock fixture where the `DELETE` itself
races to 404 AFTER a successful resolution/confirming-GET → `ApiError(404)`, exit 1 —
DISTINGUISHABLE by exit code from the resolver-layer not-found.
**Test:** `test_bc_8_2_008_component_delete_resolver_notfound_vs_delete_race_exit_code_divergence()`

### AC-022 (traces to BC-8.2.008 Edge Case EC-8.2.008-1)
`--move-to` target deleted by a concurrent actor between resolution and the `DELETE` → the
`DELETE` itself 404s on the `moveIssuesTo` id → `ApiError(404)`, exit 1 (a genuine race, not
a resolver-layer not-found).
**Test:** `test_bc_8_2_008_component_delete_move_to_target_race_404_exits_1()`

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `delete_component` (with `moveIssuesTo` query param) | `src/api/jira/components.rs` (additive) | Effectful shell |
| Pre-delete JQL snapshot (reuses `search_issue_keys`-style pagination) | `src/api/jira/issues.rs` (call site only, existing pagination loop reused) | Effectful shell |
| `handle_delete` (disposition guard, confirmation gate, snapshot, DELETE) | `src/cli/component.rs` (additive) | Effectful shell |
| `JrError::SnapshotIncomplete(String)` (NEW variant) | `src/error.rs` (additive) | Pure (error type) |
| `ComponentSubcommand::Delete` + `--move-to`/`--orphan`/`--yes` flags | `src/cli/mod.rs` (additive) | N/A (clap derive) |

## Edge Cases

Fully enumerated in the BC-8.2.001-008 Edge Cases tables; the ones with dedicated ACs above
are EC-8.2.001-3/4, EC-8.2.003-1/2, EC-8.2.005-1/2, EC-8.2.006-2, EC-8.2.007 (drift/pagination),
EC-8.2.008-1. Additional ECs to cover in test-writer's expanded suite (not separately
AC-numbered here to keep this story's AC count proportionate — trace to the parent BC
directly): EC-8.2.001-1/2 (basic disposition-guard cases), EC-8.2.006-1/3/4/5 (`--yes`
bypass, `--no-input` parity, real-count message text, numeric-source `--orphan` mismatch).

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `api/jira/components.rs::delete_component` | Effectful shell | HTTP |
| `cli/component.rs::handle_delete` | Effectful shell | HTTP + JQL snapshot + `dialoguer` prompt + stdout/stderr |
| `src/error.rs::JrError::SnapshotIncomplete` | Pure (data) | New enum variant, no I/O |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|--------------------|
| This story spec | ~9k |
| BC-8.2.001-008 bodies (read in full — the densest section of the file) | ~22k |
| Research file §Q1 | ~3k |
| ADR-0018 Decision §1/§3 | ~4k |
| `search_issue_keys` pagination precedent (`api/jira/issues.rs`) | ~3k |
| `error.rs` (existing `JrError` enum + `exit_code()`) | ~2k |
| Test files + fixtures | ~8k |
| Tool outputs | ~6k |
| **Total** | **~57k** |
| Agent context window | 200K |
| **Budget usage** | **~29%** |

Near the top of the 20-30% target — if implementation reveals further splitting is needed
(e.g. `--move-to` mechanics vs. `--orphan` mechanics as separate sub-stories), flag at F4
dispatch rather than force-fitting.

## Tasks (MANDATORY)

1. [ ] Write failing tests for the disposition-required guard (neither/both/NAME-not-found-
   ordering/numeric-asymmetry)
2. [ ] Write failing tests for `--move-to` resolution, cross-project rejection, numeric target
   confirmation, self-move guard
3. [ ] Write failing tests for numeric-SOURCE project confirmation under BOTH dispositions
4. [ ] Write failing tests for the `--orphan` confirmation gate (interactive decline/confirm,
   non-interactive `--yes` required, zero-affected-issues case)
5. [ ] Write failing tests for the snapshot (JQL shape, full pagination, drift fail-closed,
   fetch-error fail-closed)
6. [ ] Write failing tests for the JSON output shape and the not-found-vs-race idempotency
   taxonomy
7. [ ] Verify Red Gate
8. [ ] Add `JrError::SnapshotIncomplete` variant to `src/error.rs`
9. [ ] Implement `delete_component` in `api/jira/components.rs`
10. [ ] Implement `handle_delete` in `cli/component.rs` (guard → resolve source → resolve
    target if `--move-to` → self-move check → snapshot → confirm if `--orphan` → DELETE)
11. [ ] Wire CLI flags into `cli/mod.rs`
12. [ ] Refactor; full suite green

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|----------------|------------------------|-----------------------|
| S-604-1 | `resolve_component`, components cache, full-resource `Component` type | This story's numeric-source/target confirming GETs reuse the SAME single-resource GET the resolver's numeric bypass already requires — never a second, separate GET | — |
| S-604-2 | Numeric-source project confirmation established for `edit` (BC-8.1.007 M1), reusing the identical confirming-GET mechanism this story's BC-8.2.002 M1 originates | The confirming-GET/mismatch-message shape (`"Component <id> belongs to project <actual>, not <KEY>."`) is now shared verbatim across `edit`/`delete`/(later)`rename` — reuse the SAME formatting helper, do not reimplement per-command | `edit`'s Precondition-1-fires-first ordering does NOT apply here — `delete`'s Invariant 1 has the OPPOSITE default (NAME resolution fires before the disposition guard); read BC-8.2.001 Invariant 1 carefully before assuming edit's ordering generalizes |

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|--------------|
| Disposition-required NEITHER-case is an application-level `JrError::UserError` (exit 64), NEVER a clap `ArgGroup::required(true)` (which produces exit 2) | BC-8.2.001 Postcondition 3, DEC-188 | AC-001, AC-002 |
| Snapshot JQL is ALWAYS `component = <resolvedId> ORDER BY key ASC`, NEVER a bare-name clause | BC-8.2.007 Postcondition 4 | AC-017 |
| Snapshot pagination MUST run to full completion; ANY non-normal-completion outcome (including the anti-loop guard's successful partial return) is fail-closed | BC-8.2.007 Postcondition 5 | AC-018, AC-019 |
| Numeric-source/target confirming GET is a SINGLE-object GET, never a name-list GET — reuses the existing numeric-bypass confirming call, not a new HTTP shape | ADR-0018 Decision §1 | Code review; wiremock route assertions |
| Resolver-layer 404 → exit 64; mutating-call-layer 404 after successful resolution → exit 1 — this is the CANONICAL definition later extended by `edit`/`rename` | BC-8.2.008 VP-COMPONENT-024 | AC-021 |
| `--move-to` NEVER requires `--yes`/confirmation; only `--orphan` does | BC-8.2.006 Invariant 1 | AC-014 |

## Forbidden Dependencies

- `src/cli/component.rs::handle_delete` MUST NOT call `DELETE /rest/api/3/component/{id}`
  before the snapshot search completes successfully — if this ordering is violated, the
  build's own wiremock ordering assertions (AC-016 through AC-019) MUST fail.

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|----------|
| dialoguer (existing) | as in `Cargo.lock` | `--orphan` interactive confirm prompt |
| reqwest / serde (existing) | as in `Cargo.lock` | HTTP + JSON body |
| wiremock (existing) | as in `Cargo.lock` | Integration tests, including multi-page `nextPageToken` fixtures |

No new crate dependencies.

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|----------|
| `src/api/jira/components.rs` | MODIFY | `delete_component` |
| `src/cli/component.rs` | MODIFY | `handle_delete` |
| `src/cli/mod.rs` | MODIFY | `ComponentSubcommand::Delete` + `--move-to`/`--orphan`/`--yes` flags |
| `src/error.rs` | MODIFY | `JrError::SnapshotIncomplete(String)` variant |
| `tests/component_commands.rs` | MODIFY | New test cases (22 ACs) |
| `tests/common/fixtures.rs` | MODIFY | Multi-page snapshot fixtures, drift-simulation fixtures |

**MUST NOT change**: `src/cli/component.rs::handle_list`/`handle_create`/`handle_edit`
(S-604-1/S-604-2, unrelated); `src/api/jira/issues.rs::search_issue_keys`'s own pagination
loop (reused as-is, not modified).
