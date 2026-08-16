---
document_type: story
level: ops
epic_id: "none"
story_id: "S-608-1"
title: "jr component rename — single-project and --all-projects fan-out, --dry-run"
wave: null
status: draft
intent: feature
feature_type: backend
mode: feature
scope: standard
severity: N/A
trivial_scope: false
issue: 608
points: 8
priority: P1
tdd_mode: strict
estimated_effort: medium
producer: story-writer
timestamp: "2026-08-15T00:00:00"
phase: 2
cycle: cycle-component-mgmt
inputs:
  - ".factory/specs/prd/bc-8-components.md"
  - ".factory/specs/architecture/decisions/ADR-0018-component-resolution-caching-mutation-strategy.md"
  - ".factory/phase-f2-spec-evolution/verification-delta-components.md"
traces_to: ".factory/specs/prd/bc-8-components.md"
estimated_days: 3
target_module: src/cli/component.rs
subsystems: ["SS-02", "SS-04"]
depends_on: ["S-604-1"]
blocks: []
behavioral_contracts:
  - "BC-8.3.001"
  - "BC-8.3.002"
  - "BC-8.3.003"
  - "BC-8.3.004"
  - "BC-8.3.005"
  - "BC-8.3.006"
  - "BC-8.3.007"
bcs:
  - "BC-8.3.001"
  - "BC-8.3.002"
  - "BC-8.3.003"
  - "BC-8.3.004"
  - "BC-8.3.005"
  - "BC-8.3.006"
  - "BC-8.3.007"
verification_properties: ["VP-COMPONENT-008", "VP-COMPONENT-018", "VP-COMPONENT-019", "VP-COMPONENT-024", "VP-COMPONENT-026"]
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0018"]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-8-components.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 18
assumption_validations: []
risk_mitigations: []
created: "2026-08-15"
version: "1.0"
last_updated: "2026-08-15"
breaking_change: false
retroactive: false
origin: >
  GitHub issue #608 (`jr component rename`). Last wave of the bundle, lowest risk relative
  to S-604-3's delete-safety story, but still state-changing (P1, not P0) — sequenced last
  because it depends only on S-604-1's foundation and has no other bundle story depending
  on it, so it does not block any other work if delayed. Reuses BC-8.1.007's PUT-based edit
  mechanics as a degenerate `--name`-only case at the implementation layer, but documents
  its own CLI surface and semantics (single-project `--project` form vs. the O(N)
  `--all-projects` fan-out) per this BC's own contract.
files_modified:
  - src/api/jira/components.rs
  - src/cli/component.rs
  - src/cli/mod.rs
test_files:
  - tests/component_commands.rs
  - tests/common/fixtures.rs
input-hash: "8f1dcf8"
---

> **tdd_mode:** `strict`.

# S-608-1: `jr component rename`

## Narrative

As a `jr` user who needs to rename a component consistently (possibly across every project
that happens to have a same-named one), I want `jr component rename OLD NEW --project KEY`
for the single-project case and `jr component rename OLD NEW --all-projects` for the
org-wide fan-out, with a `--dry-run` preview using the identical discovery logic as the live
run and correct handling of case-only renames, so that I never accidentally skip a legitimate
casing-only change or silently roll back a partially-successful fan-out.

## Source of Truth

Read **BC-8.3.001 through BC-8.3.007** in `bc-8-components.md` §8.3 in full. BC-8.3.001 in
particular carries a numeric-`OLD` project-confirmation mechanism (M1, mirroring
BC-8.2.002/BC-8.1.007's identical pattern) added across multiple fix-bursts — only the LATEST
non-superseded text is normative. BC-8.3.002's `--all-projects` matching semantics
DELIBERATELY DIVERGE from §8.4's `partial_match` (exact case-insensitive equality, not
substring matching) — do not assume the two forms share resolution logic beyond the numeric
bypass.

## Behavioral Contracts

| BC ID | Title |
|-------|-------|
| BC-8.3.001 | `rename OLD NEW --project KEY` resolves `OLD` scoped to the project, PUTs `{"name": NEW}` |
| BC-8.3.002 | `--all-projects` fans out: discovers every project containing a component named `OLD` |
| BC-8.3.003 | `--all-projects` fan-out is per-project atomic (no rollback, continue-on-error) |
| BC-8.3.004 | `--dry-run` previews with ZERO mutating HTTP, SAME discovery logic as live |
| BC-8.3.005 | `rename` without EITHER `--project` OR `--all-projects` → exit 64; both → exit 2 |
| BC-8.3.006 | Case-only rename (`Backend`→`backend`) is legitimate — resolver must NOT short-circuit it |
| BC-8.3.007 | `NEW` collision with existing name → Jira 400 verbatim, not pre-validated |

## Behavior Summary (verbatim per BC — do not deviate)

- **Single-project form (BC-8.3.001)**: `--project KEY` is UNCONDITIONALLY REQUIRED
  (Precondition 1) — no config-fallback, no numeric-ID exemption from SUPPLYING it (unlike
  `edit`/`delete`). `OLD` resolves via §8.4, scoped to `KEY` (never cross-project). `PUT
  /rest/api/3/component/{id}` body is EXACTLY `{"name": NEW}` — no other fields (this is a
  pure rename; `--description`/`--lead` are NOT available flags here, use `component edit`
  for those). Component `id` is unchanged by the rename. Success: `--output json` →
  `{"renamed": {"id": "<id>", "from": OLD, "to": NEW, "project": KEY}}`.
- **Numeric-`OLD` project confirmation (M1, BC-8.3.001)**: when `OLD` is numeric, `jr` fires
  ONE confirming `GET /rest/api/3/component/{id}` (the SAME GET BC-8.1.008's numeric bypass
  already requires) and compares its `project` field against the REQUIRED `--project KEY` —
  mismatch → exit 64 pre-flight, `"Component <id> belongs to project <actual>, not <KEY>."`,
  ZERO `PUT` calls. If the confirming GET itself 404s → ordinary not-found path (BC-8.1.008),
  ALWAYS the project-QUALIFIED message variant (never project-less — `rename` always has
  `--project` known by Precondition 1). This mechanism does NOT apply to `--all-projects`
  (no single `--project KEY` to compare against — each candidate is already correctly scoped
  by construction).
- **`--all-projects` fan-out (BC-8.3.002)**: iterates `list_projects` (paginated) and, per
  accessible project, `GET /rest/api/3/project/{key}/components` looking for a component whose
  name EXACTLY case-insensitively EQUALS `OLD` (`name.to_lowercase() == OLD.to_lowercase()`) —
  NOT §8.4's `partial_match` substring/disambiguation semantics (deliberate divergence: fan-out
  determinism + fan-out safety, per the BC's own two-part rationale). Every matching project
  gets its own `PUT` (BC-8.3.001's mechanics, applied N times). O(N) HTTP calls, N =
  accessible project count — no bulk-rename-across-projects endpoint exists. A NUMERIC `OLD`
  under `--all-projects` is REJECTED pre-flight (exit 64, zero HTTP) — a numeric fan-out
  selector is either degenerate (ids are globally unique, so it would match at most one
  project) or ambiguous (could be misread as "similarly-named" when `OLD` happens to look
  numeric) — see this BC's exact rejection message text.
- **Per-project atomicity (BC-8.3.003)**: no cross-project transaction — each project's `PUT`
  succeeds or fails independently; a failure in project B does NOT roll back project A's
  already-committed rename and does NOT prevent attempting project C. `--output json`:
  `{"renamed": [{"project":"A","id":"...","status":"ok"}], "failed":
  [{"project":"B","error":"<message>"}]}`. Exit 0 iff EVERY attempted project succeeded; exit
  1 if ≥1 failed (a partial-success batch must NOT look identical to a fully-successful one to
  a script).
- **`--dry-run` (BC-8.3.004)**: valid with EITHER `--project` or `--all-projects`. Performs
  every READ-ONLY step of the real run (target resolution; for `--all-projects`, the FULL
  per-project discovery loop) but issues ZERO `PUT` calls. `--output json`: `{"dryRun": true,
  "targets": [{"project":"A","id":"10001","from":OLD,"to":NEW}, ...]}`. Table: `DRY RUN — no
  changes will be made.` header, then `  A: <OLD> → <NEW> (id 10001)` per target. The
  discovery scope MUST be IDENTICAL to what the live run would use — a stale/differently-scoped
  dry-run preview is a correctness bug, not a UX nit. A numeric `OLD` under `--all-projects
  --dry-run` still hits BC-8.3.002's pre-flight rejection FIRST (exit 64, zero HTTP,
  including zero `list_projects` call) — the rejection and the dry-run preview are mutually
  exclusive outcomes for that input.
- **Scope-selection guard (BC-8.3.005)**: `--project` and `--all-projects` are clap
  `conflicts_with`-paired — BOTH supplied → clap exit 2. NEITHER supplied → an
  APPLICATION-LEVEL guard (`JrError::UserError`, exit 64, DEC-188 mechanism — NOT a clap
  `ArgGroup::required(true)`, which would wrongly exit 2), naming both flags. Mechanically
  IDENTICAL two-guard shape to BC-8.2.001's `--move-to`/`--orphan` split.
- **Case-only rename (BC-8.3.006)**: `partial_match`'s case-insensitive lookup is used to FIND
  the component named `OLD` — it MUST NOT be used to decide `OLD`/`NEW` are "the same" and skip
  the PUT. `rename Backend backend --project FOO` still issues the PUT — NOT short-circuited.
  This applies IDENTICALLY under `--all-projects` (its own exact-equality match finds each
  project's component; the found component's PUT is never skipped for casing reasons either).
- **Name collision (BC-8.3.007)**: no client-side pre-check for `NEW` already existing — the
  server validates authoritatively; a 400 name-collision is surfaced verbatim, exit 1
  (`ApiError(400,...)`) — same posture as create/edit collisions.

## Acceptance Criteria

### AC-001 (traces to BC-8.3.001 postcondition 1 — single-project PUT body)
`jr component rename Backend NewName --project FOO` → resolves `Backend` scoped to FOO, then
`PUT /rest/api/3/component/{id}` body is exactly `{"name":"NewName"}`.
**Test:** `test_bc_8_3_001_component_rename_single_project_put_body()`

### AC-002 (traces to BC-8.3.001 Postcondition 2 — JSON success shape)
Success → `--output json` returns `{"renamed":{"id":"<id>","from":"Backend",
"to":"NewName","project":"FOO"}}`.
**Test:** `test_bc_8_3_001_component_rename_success_json_shape()`

### AC-003 (traces to BC-8.3.001 M1 / EC-8.3.001-1 — numeric project mismatch)
`jr component rename 10042 NewName --project A` where `10042` belongs to project B →
confirming GET returns `"project":"B"`, mismatching `--project A` → exit 64 pre-flight,
`"Component 10042 belongs to project B, not A."`, ZERO `PUT` calls.
**Test:** `test_bc_8_3_001_component_rename_numeric_old_project_mismatch()`

### AC-004 (traces to BC-8.3.001 EC-8.3.001-2 — numeric not-found, always project-qualified)
`jr component rename 999999999 NewName --project A` (numeric, nonexistent) → confirming GET
404s → exit 64, ALWAYS the project-QUALIFIED message (`"Component '999999999' not found in
project A. Run: jr component list"`) — never the project-less variant, since `--project` is
Precondition-1-required and thus always known.
**Test:** `test_bc_8_3_001_component_rename_numeric_notfound_always_project_qualified()`

### AC-005 (traces to BC-8.3.002 Behavior — fan-out discovery + exact-equality matching)
`--all-projects` with Project A having a component named exactly `"Back"` and Project B
having `"Backend"` (substring, not equal) → Project A renames; Project B is SKIPPED (not
ambiguous, not an error) — exact-equality, NOT `partial_match`'s substring semantics.
**Test:** `test_bc_8_3_002_component_rename_all_projects_exact_equality_not_substring()`

### AC-006 (traces to BC-8.3.002 Edge Case EC-8.3.002-1 — zero matches)
Zero projects contain a component named `OLD` → exit 0 (not an error), summary reports `0
renamed`.
**Test:** `test_bc_8_3_002_component_rename_all_projects_zero_matches_exits_zero()`

### AC-007 (traces to BC-8.3.002 Precondition 2 / EC-8.3.002-2 — numeric OLD rejected)
`jr component rename 10042 NewName --all-projects` (all-digit `OLD`) → exit 64 pre-flight,
zero HTTP (no `list_projects`, no per-project GETs). Contrast the SAME `OLD` with
`--project FOO` (single-project form) → numeric bypass fires normally, unaffected.
**Test:** `test_bc_8_3_002_component_rename_all_projects_numeric_old_rejected_zero_http()`

### AC-008 (traces to BC-8.3.003 postcondition 1/2 — per-project atomicity)
2 of 5 matched projects fail (one name-collision 400) → the other 3 STILL rename; exit 1;
JSON `failed[]` names both failures with raw error messages; `renamed[]` lists the 3
successes — the 2 successes among the 3 already committed are NOT rolled back by the 2
failures.
**Test:** `test_bc_8_3_003_component_rename_all_projects_partial_failure_no_rollback()`

### AC-009 (traces to BC-8.3.003 postcondition 2 — exit code)
All matched projects succeed → exit 0, `failed: []`. ≥1 failure → exit 1 (partial success is
NOT reported as exit 0).
**Test:** `test_bc_8_3_003_component_rename_all_projects_exit_code_reflects_any_failure()`

### AC-010 (traces to BC-8.3.004 postcondition — dry-run JSON/table, zero mutation)
`--dry-run --all-projects` → `{"dryRun":true,"targets":[...]}`; table: `DRY RUN — no changes
will be made.` header + one line per target; ZERO `PUT` calls (`.expect(0)`,
VP-COMPONENT-008).
**Test:** `test_bc_8_3_004_component_rename_dry_run_zero_mutation_both_scopes()`

### AC-011 (traces to BC-8.3.004 Invariant 1 — discovery-scope parity)
The `--dry-run --all-projects` discovery scope (which projects are checked, which match) is
IDENTICAL to what the corresponding live `--all-projects` run would discover — same
`list_projects` filter, same per-project matching.
**Test:** `test_bc_8_3_004_component_rename_dry_run_discovery_scope_matches_live()`

### AC-012 (traces to BC-8.3.004 Edge Case EC-8.3.004-2 — numeric rejection precedes dry-run)
`--dry-run --all-projects` with an all-digit `OLD` → BC-8.3.002 Precondition 2's rejection
fires FIRST, exit 64, ZERO HTTP of any kind (no `list_projects` call even under `--dry-run`)
— the rejection and the dry-run preview are mutually exclusive.
**Test:** `test_bc_8_3_004_component_rename_dry_run_numeric_old_rejection_precedes_preview()`

### AC-013 (traces to BC-8.3.005 Behavior — clap conflict + app-level neither-guard)
`--project X --all-projects` together → clap exit 2. NEITHER supplied → application-level
exit 64 (NOT clap `ArgGroup::required(true)`, which would wrongly exit 2), naming both flags.
**Test:** `test_bc_8_3_005_component_rename_scope_selection_clap_conflict_and_app_guard()`

### AC-014 (traces to BC-8.3.006 Edge Case EC-8.3.006-1 — case-only, single-project)
`jr component rename Backend backend --project FOO` → PUT fires with body
`{"name":"backend"}`, exit 0 — NOT treated as "OLD == NEW, nothing to do" (VP-COMPONENT-019).
**Test:** `test_bc_8_3_006_component_rename_case_only_single_project_not_skipped()`

### AC-015 (traces to BC-8.3.006 Edge Case EC-8.3.006-2 — case-only, all-projects)
`jr component rename Backend backend --all-projects` where Projects A and B both have a
component named exactly `"Backend"` → BOTH get `PUT {"name":"backend"}` (2 total calls) — not
skipped for either.
**Test:** `test_bc_8_3_006_component_rename_case_only_all_projects_both_renamed()`

### AC-016 (traces to BC-8.3.007 Behavior — collision surfaced verbatim)
`NEW` collides with an existing component name in the target project → Jira 400 surfaced
verbatim (`ApiError(400,...)`, exit 1) — NOT pre-validated client-side (no pre-flight
existence-check GET fired before the PUT).
**Test:** `test_bc_8_3_007_component_rename_name_collision_verbatim_400()`

### AC-017 (traces to BC-8.3.001 Idempotency section — 404 taxonomy)
A fixture where the resolver/confirming-GET succeeds but the follow-up `PUT` races to 404
(concurrent delete) → `ApiError(404)`, exit 1 — DISTINCT from AC-004's exit-64 not-found path
(VP-COMPONENT-024, extended here from its canonical BC-8.2.008 definition).
**Test:** `test_bc_8_3_001_component_rename_put_race_404_exits_1_distinct_from_resolver_404()`

### AC-018 (traces to BC-8.3.002 Behavior — O(N) scale, no rate-limit budget beyond existing)
A fixture with N=20 accessible projects, all matching `OLD` → exactly 20 `PUT` calls (one per
match) plus N `list_projects`-derived per-project component-list GETs — no additional
page/rate-limit handling beyond `jr`'s existing 429-retry machinery is exercised or required
by this story.
**Test:** `test_bc_8_3_002_component_rename_all_projects_scale_no_new_rate_limit_logic()`

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `rename_component` (reuses `edit_component`'s PUT mechanics at the implementation layer, per BC-8.3.001) | `src/api/jira/components.rs` (additive) | Effectful shell |
| `handle_rename` (single-project + `--all-projects` fan-out + `--dry-run`) | `src/cli/component.rs` (additive) | Effectful shell |
| `ComponentSubcommand::Rename` + `--project`/`--all-projects`/`--dry-run` flags | `src/cli/mod.rs` (additive) | N/A (clap derive) |

## Edge Cases

Covered by dedicated ACs: EC-8.3.001-1/2, EC-8.3.002-1/2/3, EC-8.3.003-1/2, EC-8.3.004-1/2,
EC-8.3.006-1/2. EC-8.3.002-3 (`"Back"` vs `"Backend"` substring non-match, AC-005) and
EC-8.3.002-4/EC-8.3.004-2 (numeric+dry-run ordering, AC-012) are already covered above.

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `api/jira/components.rs::rename_component` | Effectful shell | HTTP |
| `cli/component.rs::handle_rename` | Effectful shell | HTTP (single or N-project fan-out) + stdout/stderr |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|--------------------|
| This story spec | ~8k |
| BC-8.3.001-007 bodies (read in full) | ~12k |
| ADR-0018 Decision §1 (confirming-GET reuse) | ~2k |
| `list_projects` pagination precedent (`api/jira/projects.rs`) | ~2k |
| S-604-2's numeric-source confirming-GET implementation (reused pattern) | ~2k |
| Test files + fixtures | ~7k |
| Tool outputs | ~5k |
| **Total** | **~38k** |
| Agent context window | 200K |
| **Budget usage** | **~19%** |

## Tasks (MANDATORY)

1. [ ] Write failing tests for single-project rename (PUT body, JSON shape, numeric project
   confirmation/mismatch/not-found)
2. [ ] Write failing tests for `--all-projects` fan-out (exact-equality matching, numeric
   rejection, zero-match)
3. [ ] Write failing tests for per-project atomicity (partial failure, exit-code semantics)
4. [ ] Write failing tests for `--dry-run` (both scopes, discovery-scope parity, numeric
   rejection ordering)
5. [ ] Write failing tests for the scope-selection guard (clap conflict + app-level neither
   check)
6. [ ] Write failing tests for case-only rename (both scopes, not short-circuited)
7. [ ] Write failing tests for name-collision passthrough and PUT-race 404 taxonomy
8. [ ] Verify Red Gate
9. [ ] Implement `rename_component` in `api/jira/components.rs`
10. [ ] Implement `handle_rename` (single-project path, `--all-projects` fan-out,
    `--dry-run` branch) in `cli/component.rs`
11. [ ] Wire CLI flags into `cli/mod.rs`
12. [ ] Refactor; full suite green

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|----------------|------------------------|-----------------------|
| S-604-1 | `resolve_component`, components cache, full-resource `Component` type | Single-project `rename` resolution IS a `resolve_component` call, identical to `edit`/`delete` | `--all-projects`'s matching is EXACT case-insensitive equality, deliberately NOT `resolve_component`/`partial_match` — do not accidentally reuse the substring resolver for the fan-out path |
| S-604-2 | Numeric-source confirming-GET mechanism established for `edit` (BC-8.1.007 M1) | This story's numeric-`OLD` confirmation (BC-8.3.001 M1) reuses the IDENTICAL confirming-GET call and mismatch-message format — reuse the same helper function, do not reimplement | Unlike `edit`, `rename`'s single-project form has NO numeric-ID exemption from supplying `--project` — `--project` is unconditionally required regardless of whether `OLD` is numeric or a name |
| S-604-3 | Per-project atomicity / continue-on-error shape established for `component delete`'s… (N/A — delete has no multi-target fan-out) | N/A | This story's `--all-projects` continue-on-error/exit-code-reflects-any-failure shape is a NEW pattern in this bundle, not reused from `delete` — do not assume `delete`'s all-or-nothing snapshot-then-mutate shape applies here |

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|--------------|
| `--all-projects` scope-selection NEITHER-case is an application-level exit-64 guard, NEVER a clap `ArgGroup::required(true)` | BC-8.3.005 Behavior, DEC-188 | AC-013 |
| `--all-projects` matching is EXACT case-insensitive equality — NEVER `partial_match`'s substring semantics | BC-8.3.002 Matching-semantics divergence | AC-005 |
| A numeric `OLD` is REJECTED under `--all-projects` (both live and `--dry-run`), unaffected under the single-project form | BC-8.3.002 Precondition 2 | AC-007, AC-012 |
| `rename`'s single-project form has NO numeric-ID exemption from supplying `--project` (unlike `edit`/`delete`) | BC-8.3.001 Precondition 1 | Code review; contrast with S-604-2's BC-8.1.004 exemption |
| Case-only rename is NEVER short-circuited, in either scope | BC-8.3.006 Behavior | AC-014, AC-015 |
| `--all-projects` fan-out is per-project atomic — no rollback, continue-on-error | BC-8.3.003 Behavior | AC-008, AC-009 |

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|----------|
| reqwest / serde (existing) | as in `Cargo.lock` | HTTP + body composition |
| wiremock (existing) | as in `Cargo.lock` | Integration tests, including multi-project fan-out fixtures |

No new crate dependencies.

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|----------|
| `src/api/jira/components.rs` | MODIFY | `rename_component` |
| `src/cli/component.rs` | MODIFY | `handle_rename` (single-project, fan-out, dry-run) |
| `src/cli/mod.rs` | MODIFY | `ComponentSubcommand::Rename` + flags |
| `tests/component_commands.rs` | MODIFY | New test cases (18 ACs) |
| `tests/common/fixtures.rs` | MODIFY | Multi-project fan-out fixtures |

**MUST NOT change**: `src/cli/component.rs::handle_list`/`handle_create`/`handle_edit`/
`handle_delete` (S-604-1/2/3, unrelated); `src/api/jira/projects.rs::list_projects`'s own
pagination (reused as-is).
