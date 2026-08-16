---
document_type: story
level: ops
epic_id: "none"
story_id: "S-604-1"
title: "Component foundation: types, API client, cache family, resolver, CLI scaffold, and jr component list"
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
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/cross-cutting.md"
  - ".factory/specs/architecture/decisions/ADR-0018-component-resolution-caching-mutation-strategy.md"
  - ".factory/phase-f2-spec-evolution/architecture-delta-components.md"
  - ".factory/phase-f2-spec-evolution/verification-delta-components.md"
traces_to: ".factory/specs/prd/bc-8-components.md"
estimated_days: 5
target_module: src/cli/component.rs
subsystems: ["SS-02", "SS-04", "SS-07", "SS-08"]
depends_on: []
blocks: ["S-604-2", "S-604-3", "S-605-1", "S-606-1", "S-608-1"]
behavioral_contracts:
  - "BC-8.1.001"
  - "BC-8.1.002"
  - "BC-8.1.003"
  - "BC-8.1.004"
  - "BC-8.4.001"
  - "BC-8.4.002"
  - "BC-8.4.003"
  - "BC-8.4.004"
  - "BC-8.4.005"
  - "BC-2.3.040"
bcs:
  - "BC-8.1.001"
  - "BC-8.1.002"
  - "BC-8.1.003"
  - "BC-8.1.004"
  - "BC-8.4.001"
  - "BC-8.4.002"
  - "BC-8.4.003"
  - "BC-8.4.004"
  - "BC-8.4.005"
  - "BC-2.3.040"
verification_properties: ["VP-COMPONENT-001", "VP-COMPONENT-009", "VP-COMPONENT-010", "VP-COMPONENT-014", "VP-COMPONENT-020", "VP-COMPONENT-021"]
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0018", "ADR-0007", "ADR-0012"]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-8-components.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 19
assumption_validations: []
risk_mitigations: []
created: "2026-08-15"
version: "1.0"
last_updated: "2026-08-15"
breaking_change: false
retroactive: false
origin: >
  GitHub issue #604 (`jr component list/create/edit/delete`). This is the FOUNDATION story
  of the four-issue component-management bundle (#604/#605/#606/#608) — every other story
  in the bundle depends on the types, API client, cache family, and shared resolver this
  story establishes. Routed through full F1-F7 Feature Mode per DEC-278 umbrella decision.
  See ADR-0018 for the consolidated architecture rationale and
  .factory/phase-f1-delta-analysis/impact-boundary-components.md for the F1 delta.
files_modified:
  - src/types/jira/component.rs
  - src/types/jira/mod.rs
  - src/types/jira/issue.rs
  - src/api/jira/components.rs
  - src/api/jira/mod.rs
  - src/cache.rs
  - src/cli/issue/helpers.rs
  - src/cli/component.rs
  - src/cli/mod.rs
  - src/lib.rs
test_files:
  - tests/component_commands.rs
  - tests/common/fixtures.rs
  - src/partial_match.rs
input-hash: "304dda4"
---

> **tdd_mode:** `strict` — full TDD Iron Law enforced. This is a new command group; every
> function body starts as `todo!()` per Red Gate discipline.

# S-604-1: Component foundation — types, API client, cache, resolver, `jr component list`

## Narrative

As a `jr` user managing Jira Cloud project components, I want a new `jr component` command
group with a working `list` subcommand, backed by a correctly-typed component resource, a
project-scoped resolver that never confuses same-named components across projects, and a
warm cache, so that every subsequent component command (create/edit/delete/rename, and
`issue`-side `--component` support) can build on a single, tested foundation rather than
each reinventing project-scoping and disambiguation.

## Source of Truth

Read **BC-8.1.001-004** and **BC-8.4.001-005** in `bc-8-components.md` in full before
implementing — this story summarizes them but the BC bodies are the source of exact wire
shapes, message text, and edge-case scoping (the file carries extensive adversarial-review
correction history; only the LATEST, non-superseded text in each BC is normative). Also read
**BC-2.3.040** in `bc-2-issue-read.md` (the embedded `Component.id: Option<String>` field —
DISTINCT from this story's own `types/jira/component.rs::Component` full resource type, which
keeps `id: String` required) and **ADR-0018** in full (consolidated architecture decision:
resolution strategy, cache layout, model-b writer convention).

## Behavioral Contracts

| BC ID | Title | Clause this story implements |
|-------|-------|-------------------------------|
| BC-8.1.001 | `jr component list [--project KEY]` GETs `/rest/api/3/project/{key}/components`; renders table | Full command, table columns, empty-list handling |
| BC-8.1.002 | `jr component list --output json` returns array of full component objects | JSON mode, `output::render_json` |
| BC-8.1.003 | `jr component list --counts` enriches with `relatedIssueCounts` | N+1 enrichment, fail-soft per-component |
| BC-8.1.004 | `list`/`edit`/`delete` no-`--project`-no-config guard (numeric exemption on edit/delete) | The `list`-scoped slice of this guard only (edit/delete exemptions land in S-604-2/S-604-3) |
| BC-8.4.001 | `resolve_component(input, project, candidates)` — numeric-ID bypass; project-scoped `partial_match` | The shared resolver primitive itself |
| BC-8.4.002 | Unknown component name → exit 64 listing valid names | Resolver not-found message |
| BC-8.4.003 | Ambiguous component name → exit 64 listing candidates | Resolver ambiguous message |
| BC-8.4.004 | Component resolution is ALWAYS single-project-scoped | Core cross-project-safety invariant |
| BC-8.4.005 | Client-side resolver case-insensitivity agrees with JQL | `ExactMultiple` handling |
| BC-2.3.040 | Embedded `Component` struct gains `id: Option<String>` | `src/types/jira/issue.rs::Component` amendment |

## Behavior Summary (verbatim per BC — do not deviate)

- **Two DISTINCT `Component` types** (BC-2.3.040 Precondition 1 — do not conflate):
  1. `src/types/jira/issue.rs::Component` (existing, embedded on `Issue.fields.components[]`):
     gains `id: Option<String>` alongside the existing `name: String`. A fixture omitting `id`
     deserializes successfully with `id: None` — NOT a breaking change.
  2. `src/types/jira/component.rs::Component` (NEW, this story): the full component RESOURCE
     shape returned by `GET /rest/api/3/component/*` and
     `GET /rest/api/3/project/{key}/components` — `id: String` (REQUIRED, non-`Option` —
     §8.4's resolver depends on a real id), `name: String`, `description: Option<String>`,
     `lead: Option<ComponentLead>` (nested `accountId`/`displayName` or equivalent — model
     after Jira's documented component resource), `assigneeType: Option<String>`,
     `project: Option<String>` (present on some endpoints, absent on others — treat as
     optional; `relatedIssueCount`/`isAssigneeTypeValid` may also appear — capture what the
     research file/Jira docs confirm, tolerate unknown fields via `#[serde(flatten)]` extra if
     the codebase's existing type convention uses that pattern elsewhere, e.g.
     `types/jira/issue.rs::IssueFields`).
- **`src/api/jira/components.rs`** (NEW): `JiraClient` methods for `list_components(project_key)`
  (`GET /rest/api/3/project/{key}/components` — assumed non-paginated per BC-8.1.001, confirm
  at F4 live-verification time; if paginated, extend to the standard offset-loop this codebase
  already uses elsewhere) and `get_related_issue_counts(component_id)` (`GET
  /rest/api/3/component/{id}/relatedIssueCounts`, BC-8.1.003). This story does NOT implement
  create/edit/delete/rename API calls — those land in S-604-2/S-604-3/S-608-1 — but the file
  and module structure should anticipate them (mirrors `api/jira/teams.rs`'s shape).
- **Components cache family** (`src/cache.rs`, ADR-0018 Decision §2): `components_<profile>.json`
  → `HashMap<project_key, ComponentsCacheEntry>`, `ComponentsCacheEntry { components:
  Vec<CachedComponent>, fetched_at: DateTime<Utc> }`, `CachedComponent { id: String, name:
  String }`. Mirrors `ProjectMeta`'s reader/writer/invalidator shape EXACTLY (`read_project_meta`/
  `write_project_meta`/`invalidate_project_meta_cache` precedent) — `profile: &str` is the
  first argument on every function (ADR-0007 multi-profile invariant). 7-day TTL. Writer is
  model-b (swallow + `eprintln!("warning: …")`, matching `write_cmdb_fields_cache`) — a failed
  cache write must never break a successful `component list`. This story implements
  `read_components_cache`/`write_components_cache`; `invalidate_components_cache` is ALSO
  added here (the function itself), even though this story has no mutating command to call it
  from yet — S-604-2/S-604-3/S-608-1 call it, this story only defines it and unit-tests it in
  isolation, per ADR-0018 Decision §2.
- **`resolve_component(input: &str, project: &str, candidates: &[String]) -> MatchResult`**
  (`src/cli/issue/helpers.rs`, NEW fn, structural clone of `resolve_team_field` — BC-8.4.001):
  all-ASCII-digit `input` short-circuits to the numeric id directly, ZERO `partial_match` call,
  ZERO candidate-list HTTP fetch. Non-digit input calls the EXISTING pure `partial_match(input,
  candidates)` primitive (`src/partial_match.rs`, BC-X.10.001-003, unmodified) scoped to
  `candidates` — which the CALLER (this story's `list` handler, and every later story's
  edit/delete/rename/`--move-to`/`issue --component` call sites) is responsible for populating
  from EXACTLY ONE project's component-name list, never a cross-project union (BC-8.4.004 — the
  resolver itself has no project-awareness; scoping is enforced entirely by which candidate list
  the caller passes in).
- **`jr component list [--project KEY] [--output json] [--counts]`** (`src/cli/component.rs`,
  NEW file, NEW `Command::Component` variant in `src/cli/mod.rs`): `--project` resolves per the
  standard flag > `.jr.toml` config > exit-64 precedence (BC-8.1.004, the `list`-only slice —
  `list` has no numeric-id exemption to worry about, since it has no `NAME|ID` positional at
  all). Table columns: `ID`, `Name`, `Description`, `Lead`, `Assignee Type` (description/lead
  render `-` when null/absent). `--output json` returns the full array of component objects
  (all fields, no `-` placeholder convention) via `output::render_json`. `--counts` issues one
  `relatedIssueCounts` GET per component (N+1); a single component's enrichment failure (5xx)
  renders `?`/`null` for that row and a stderr warning, WITHOUT aborting the whole listing
  (fail-soft, exit 0). Empty component list → exit 0, empty table/`[]`, not an error.

## Acceptance Criteria

### AC-001 (traces to BC-8.1.001 postcondition — table columns)
`jr component list --project FOO` against a fixture with ≥1 component renders a table with
columns `ID, Name, Description, Lead, Assignee Type` in that order; `description`/`lead`
render `-` when null/absent (EC-8.1.001-2).
**Test:** `test_bc_8_1_001_component_list_table_columns_and_dash_for_absent()`

### AC-002 (traces to BC-8.1.001 postcondition — empty list)
`jr component list --project FOO` against a fixture with zero components → exit 0, empty
table (header row only), no error (EC-8.1.001-1).
**Test:** `test_bc_8_1_001_component_list_empty_project_exits_zero()`

### AC-003 (traces to BC-8.1.001 Behavior — config fallback)
`jr component list` with no `--project` flag but a configured default project in `.jr.toml`
resolves against the configured project (same precedence as every other `jr` command).
**Test:** `test_bc_8_1_001_component_list_falls_back_to_configured_project()`

### AC-004 (traces to BC-8.1.004 postcondition — no-project exit 64)
`jr component list` with no `--project` and no configured project → exit 64 before any HTTP
call, stderr names `--project`.
**Test:** `test_bc_8_1_004_component_list_no_project_no_config_exits_64()`

### AC-005 (traces to BC-8.1.002 postcondition)
`jr component list --project FOO --output json` returns a JSON array on stdout, one object
per component, with ALL fields the API returned (no `-` placeholder convention); routes
through `output::render_json`.
**Test:** `test_bc_8_1_002_component_list_json_full_object_array()`

### AC-006 (traces to BC-8.1.002 postcondition — empty JSON)
`jr component list --project FOO --output json` on a zero-component project → `[]` on
stdout, exit 0.
**Test:** `test_bc_8_1_002_component_list_json_empty_array()`

### AC-007 (traces to BC-8.1.003 Behavior — counts enrichment)
`jr component list --project FOO --counts` issues one `GET
/rest/api/3/component/{id}/relatedIssueCounts` per component returned by the list GET; table
gains an `Issues` column; JSON gains an `issueCount` integer field per object.
**Test:** `test_bc_8_1_003_component_list_counts_issues_one_get_per_component()`

### AC-008 (traces to BC-8.1.003 Edge Case EC-8.1.003-1)
`--counts` on a zero-component project → zero extra HTTP calls beyond the list GET.
**Test:** `test_bc_8_1_003_component_list_counts_noop_on_empty_project()`

### AC-009 (traces to BC-8.1.003 Edge Case EC-8.1.003-2)
One component's `relatedIssueCounts` call returns 5xx → that row's `Issues` cell renders `?`
(table)/`issueCount: null` (JSON), a stderr warning names the component, exit 0, other
components' counts still render.
**Test:** `test_bc_8_1_003_component_list_counts_fail_soft_on_one_5xx()`

### AC-010 (traces to BC-8.4.001 Behavior step 1 — numeric bypass)
`resolve_component("10042", project, candidates)` returns the numeric id directly with ZERO
calls to `partial_match` and ZERO candidate-list HTTP fetch, regardless of whether `10042`
appears in `candidates`.
**Test:** `test_bc_8_4_001_resolve_component_numeric_bypass_zero_partial_match_calls()`

### AC-011 (traces to BC-8.4.001 Behavior step 2 — name resolution)
`resolve_component("Back", project, &["Backend".into()])` delegates to
`partial_match("Back", &["Backend"])` and returns its `MatchResult` unmodified.
**Test:** `test_bc_8_4_001_resolve_component_delegates_to_partial_match_for_names()`

### AC-012 (traces to BC-8.4.001 Invariant 1 / BC-8.4.004)
`resolve_component` never fetches or unions more than one project's candidate list itself —
a wiremock fixture with two projects each having a component named `"Backend"` (different
ids) resolves Project A's `--component Backend` to Project A's id only; Project B's
component-list endpoint is never called (`.expect(0)`).
**Test:** `test_bc_8_4_004_resolve_component_never_spans_projects()`

### AC-013 (traces to BC-8.4.002 postcondition)
Zero-match name → exit 64, `"Component '<input>' not found in project <key>. Available:
<comma-joined alphabetical list>."`; zero additional HTTP beyond the candidate-populating GET.
**Test:** `test_bc_8_4_002_resolve_component_unknown_name_message_and_zero_http()`

### AC-014 (traces to BC-8.4.003 postcondition)
2+ matches → exit 64, `"Ambiguous component '<input>'. Matches: <candidates>."`; zero
additional HTTP.
**Test:** `test_bc_8_4_003_resolve_component_ambiguous_name_message_and_zero_http()`

### AC-015 (traces to BC-8.4.005 Behavior)
Two components differing only by case within one project (`"Backend"`/`"backend"`) both
resolve as valid exact matches via `partial_match`'s `ExactMultiple` path — no false
`Ambiguous`.
**Test:** `test_bc_8_4_005_resolve_component_case_only_duplicates_exact_multiple()`

### AC-016 (traces to BC-2.3.040 postcondition 1 — id present)
A fixture with `components: [{"id": "10001", "name": "Backend"}]` inside `fields.components[]`
deserializes `IssueFields.components[0].id == Some("10001".to_string())`.
**Test:** `test_bc_2_3_040_embedded_component_id_present_deserializes_some()`

### AC-017 (traces to BC-2.3.040 postcondition 2 — id absent)
A fixture with `components: [{"name": "Backend"}]` (no `id` key) deserializes successfully
with `id: None` — no serde failure, not a breaking change.
**Test:** `test_bc_2_3_040_embedded_component_id_absent_deserializes_none()`

### AC-018 (traces to BC-2.3.040 Precondition 1 — type distinctness)
`src/types/jira/component.rs::Component.id` is a required, non-`Option` `String` — a fixture
for `GET /rest/api/3/project/{key}/components` omitting `id` on any element FAILS to
deserialize (this is the full resource type, distinct from the embedded `issue.rs::Component`
covered by AC-016/AC-017).
**Test:** `test_bc_2_3_040_full_resource_component_id_required_not_optional()`

### AC-019 (traces to ADR-0018 Decision §2 — cache round-trip)
`write_components_cache(profile, project_key, components)` followed by
`read_components_cache(profile, project_key)` returns the same component set within the
7-day TTL; a write failure (e.g. read-only cache dir) is swallowed with an `eprintln!`
warning and does not propagate an `Err` to the caller (model-b writer).
**Test:** `test_adr_0018_components_cache_round_trip_and_model_b_writer()`

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `Component` (full resource) | `src/types/jira/component.rs` (NEW) | Pure core |
| `Component.id: Option<String>` amendment | `src/types/jira/issue.rs::Component` (existing) | Pure core (data) |
| `list_components`, `get_related_issue_counts` | `src/api/jira/components.rs` (NEW) | Effectful shell (HTTP via `JiraClient`) |
| `ComponentsCacheEntry`, `CachedComponent`, `{read,write,invalidate}_components_cache` | `src/cache.rs` (additive) | Effectful shell (filesystem I/O) |
| `resolve_component` | `src/cli/issue/helpers.rs` (additive) | Effectful shell (cache-or-fetch wrapper; delegates to the pure `partial_match::partial_match`) |
| `handle_list` (table/JSON/`--counts`) | `src/cli/component.rs` (NEW) | Effectful shell |
| `Command::Component` + `ComponentSubcommand::List` | `src/cli/mod.rs` (additive) | N/A (clap derive) |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-8.1.001-1 | Project has zero components | exit 0, empty table (header only) |
| EC-8.1.001-2 | `description`/`lead` absent on a component | render `-`, not `null`/empty cell |
| EC-8.1.003-1 | `--counts` on zero-component project | zero extra HTTP calls |
| EC-8.1.003-2 | One component's `relatedIssueCounts` 5xxs | that row `?`/`null`, stderr warning, exit 0, other rows still render |
| EC-8.1.004 (list slice) | `list` with no `--project` and no configured project | exit 64 before any HTTP, names `--project` |
| — | Component named literally `"100"` | unreachable via `resolve_component`'s numeric bypass (documented gap, same as `requesttype fields`) — not exercised by `list` itself (no positional), but the resolver's unit tests must cover it |
| — | Two projects each have a component named `"Backend"` (different ids) | resolver scoped to Project A never considers Project B's id (BC-8.4.004; VP-COMPONENT-010) |
| — | Two components differing only by case in one project (`"Backend"`/`"backend"`) | `partial_match`'s `ExactMultiple` path treats both as valid exact matches, no false `Ambiguous` (BC-8.4.005) |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `types/jira/component.rs` | Pure core | Serde struct family, no I/O |
| `types/jira/issue.rs::Component` | Pure core (data) | Additive `Option<String>` field |
| `api/jira/components.rs` | Effectful shell | HTTP via `JiraClient` |
| `cache.rs` components family | Effectful shell | Filesystem I/O |
| `cli/issue/helpers.rs::resolve_component` | Effectful shell wrapper around a pure primitive | Cache-or-fetch, then delegates to unmodified `partial_match::partial_match` |
| `cli/component.rs` | Effectful shell | HTTP + cache + stdout/stderr |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|--------------------|
| This story spec | ~7k |
| BC-8.1.001-004 + BC-8.4.001-005 + BC-2.3.040 bodies (read in full) | ~12k |
| ADR-0018 (read in full) | ~5k |
| `src/cache.rs` (ProjectMeta window for pattern-matching) | ~3k |
| `src/cli/team.rs` + `src/api/jira/teams.rs` (structural precedent) | ~4k |
| `src/partial_match.rs` (existing pure primitive, unmodified) | ~2k |
| `src/cli/issue/helpers.rs` (resolve_team_field window) | ~2k |
| `src/cli/mod.rs` (existing Command enum for the new variant) | ~2k |
| Test files + fixtures | ~6k |
| Tool outputs (`cargo test`/`clippy`) | ~5k |
| **Total** | **~48k** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~24%** |

Within the 20-30% target.

## Tasks (MANDATORY)

1. [ ] Write failing tests for `Component` (full resource) deserialization and `IssueFields`/
   `Component` (embedded) `id: Option<String>` (test-writer)
2. [ ] Write failing tests for `resolve_component` (numeric bypass, project-scoped
   `partial_match` delegation, not-found/ambiguous messages) — proptest + unit
3. [ ] Write failing tests for cache read/write/invalidate round-trip (mirror `ProjectMeta`
   test shape)
4. [ ] Write failing wiremock integration tests for `jr component list` (table, `--output
   json`, `--counts`, no-project exit-64, cross-project non-collision fixture)
5. [ ] Verify Red Gate (all new tests fail — `todo!()` bodies)
6. [ ] Implement `types/jira/component.rs`
7. [ ] Implement `IssueFields`/`Component` embedded-struct amendment
8. [ ] Implement `api/jira/components.rs` (`list_components`, `get_related_issue_counts`)
9. [ ] Implement cache family in `cache.rs`
10. [ ] Implement `resolve_component` in `cli/issue/helpers.rs`
11. [ ] Implement `cli/component.rs` scaffold + `handle_list`
12. [ ] Wire `Command::Component`/`ComponentSubcommand::List` into `cli/mod.rs`
13. [ ] Verify purity boundaries (no HTTP in `types/`, no `cli::*` imports in `api::*`/`cache.rs`)
14. [ ] Refactor
15. [ ] Full suite green (`cargo test`, `cargo clippy -- -D warnings`, `cargo fmt --all -- --check`)

## Previous Story Intelligence (MANDATORY)

N/A — first story in this epic/bundle. No prior component-management story exists to carry
lessons forward. The closest cross-epic precedent is the `team.rs`/`api/jira/teams.rs`/
`resolve_team_field`/`TeamCache` quadruple (F1 delta analysis §3, ADR-0018 Rationale) — read
those files for STRUCTURAL pattern only; do NOT generalize a shared resolver between teams
(org-global) and components (project-scoped) — ADR-0018 explicitly rejected that as an
alternative (leaks project-scoping bugs into team resolution for little code savings).

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|--------------|
| `profile: &str` is the FIRST argument on every components-cache reader/writer/invalidator | ADR-0007; ADR-0018 Decision §2 | Code review; cross-profile cache-leakage is a correctness bug per CLAUDE.md's "Multi-profile boundary" gotcha |
| Components cache is a keyed-map-per-profile file (`ProjectMeta` shape), NOT a whole-file `TeamCache` shape | ADR-0018 Decision §2 | Code review against `cache.rs::ProjectMeta`/`read_project_meta` |
| Cache writer is model-b (swallow + warn) — a failed disk write must never break `component list` | ADR-0018 Decision §2; CLAUDE.md "Cache-write error handling" gotcha | `.ok()` at the call site, `eprintln!("warning: …")` inside the writer |
| `resolve_component` is a STRUCTURAL CLONE of `resolve_team_field`, not a shared generic abstraction | ADR-0018 Rationale (rejected alternative) | Code review — no new trait/generic introduced spanning teams and components |
| `resolve_component` is ALWAYS scoped to exactly one project's candidate list; never fetches or unions multiple projects itself | BC-8.4.001 Invariant 1, BC-8.4.004 | VP-COMPONENT-010 wiremock fixture (two same-named components in different projects); code review of call sites |
| Numeric-ID bypass fires ZERO `partial_match` calls and ZERO candidate-list HTTP | BC-8.4.001 Behavior step 1 | VP-COMPONENT-014 |
| Every `--output json` path routes through `output::render_json`/`output::print_output` | CLAUDE.md "JSON render invariant" (#526) | Code review; no direct `serde_json::to_string_pretty` |
| `types/jira/component.rs::Component.id` stays required `String` (NOT `Option`) — do not conflate with the embedded `issue.rs::Component.id: Option<String>` | BC-2.3.040 Precondition 1 | Code review; two distinct type names in two distinct files |

## Forbidden Dependencies

- `src/types/jira/component.rs` MUST NOT depend on `src/api/`, `src/cli/`, or `src/cache.rs` —
  if this module gains such a dependency, the build MUST fail (purity-boundary violation).
- `src/api/jira/components.rs` MUST NOT depend on `src/cli/` (L4 must not import L2).
- `src/cache.rs` MUST NOT depend on `src/cli/` or `src/api/jira/*` (L6 must not import L2/L4).

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|----------|
| serde / serde_json (existing) | as in `Cargo.lock` | `Component` (both shapes) deserialization |
| reqwest (existing) | as in `Cargo.lock` | `api/jira/components.rs` HTTP calls |
| chrono (existing) | as in `Cargo.lock` | `ComponentsCacheEntry.fetched_at: DateTime<Utc>` (matches `ProjectMeta`) |
| comfy-table (existing) | as in `Cargo.lock` | `jr component list` table rendering |
| wiremock (existing) | as in `Cargo.lock` | Integration test HTTP mocking |
| proptest (existing) | as in `Cargo.lock` | `resolve_component`/`partial_match` determinism proptest (VP-COMPONENT-014) |

No new crate dependencies. This story adds nothing to `Cargo.toml`.

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|----------|
| `src/types/jira/component.rs` | CREATE | Full component resource type |
| `src/types/jira/mod.rs` | MODIFY | Re-export new `component` module |
| `src/types/jira/issue.rs` | MODIFY | `Component.id: Option<String>` amendment (BC-2.3.040) |
| `src/api/jira/components.rs` | CREATE | `list_components`, `get_related_issue_counts` |
| `src/api/jira/mod.rs` | MODIFY | Re-export new `components` module |
| `src/cache.rs` | MODIFY | `ComponentsCacheEntry`, `CachedComponent`, `{read,write,invalidate}_components_cache` |
| `src/cli/issue/helpers.rs` | MODIFY | `resolve_component` fn |
| `src/cli/component.rs` | CREATE | `handle_list` + module scaffold for future subcommands |
| `src/cli/mod.rs` | MODIFY | `Command::Component`, `ComponentSubcommand::List` |
| `src/lib.rs` | MODIFY | Re-export for integration test access, if required by the existing crate-root pattern |
| `tests/component_commands.rs` | CREATE | Integration tests for `jr component list` |
| `tests/common/fixtures.rs` | MODIFY | Component list/relatedIssueCounts JSON fixtures |

**MUST NOT change**: `src/partial_match.rs` (the pure primitive is reused unmodified —
BC-X.10.001-003 stay exactly as documented); `src/cli/team.rs`/`src/api/jira/teams.rs` (cited
for pattern only, never generalized); any other existing command's behavior.
