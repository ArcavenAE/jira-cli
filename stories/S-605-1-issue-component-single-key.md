---
document_type: story
level: ops
epic_id: "none"
story_id: "S-605-1"
title: "issue create/edit --component (single-key path)"
wave: null
status: draft
intent: feature
feature_type: backend
mode: feature
scope: standard
severity: N/A
trivial_scope: false
issue: 605
points: 8
priority: P0
tdd_mode: strict
estimated_effort: medium
producer: story-writer
timestamp: "2026-08-15T00:00:00"
phase: 2
cycle: cycle-component-mgmt
inputs:
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/bc-8-components.md"
  - ".factory/specs/architecture/decisions/ADR-0018-component-resolution-caching-mutation-strategy.md"
  - ".factory/phase-f2-spec-evolution/verification-delta-components.md"
traces_to: ".factory/specs/prd/bc-3-issue-write.md"
estimated_days: 3
target_module: src/cli/issue/
subsystems: ["SS-02", "SS-04"]
depends_on: ["S-604-1"]
blocks: ["S-605-2"]
behavioral_contracts:
  - "BC-3.4.022"
  - "BC-3.4.024"
  - "BC-3.4.025"
  - "BC-3.4.012"
  - "BC-3.4.013"
  - "BC-3.4.017"
  - "BC-3.4.020"
  - "BC-3.4.021"
bcs:
  - "BC-3.4.022"
  - "BC-3.4.024"
  - "BC-3.4.025"
  - "BC-3.4.012"
  - "BC-3.4.013"
  - "BC-3.4.017"
  - "BC-3.4.020"
  - "BC-3.4.021"
verification_properties: ["VP-COMPONENT-011", "VP-COMPONENT-016", "VP-COMPONENT-025", "VP-COMPONENT-027", "VP-COMPONENT-028"]
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0018", "ADR-0014"]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-3-issue-write.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 17
assumption_validations: []
risk_mitigations: []
created: "2026-08-15"
version: "1.0"
last_updated: "2026-08-15"
breaking_change: false
retroactive: false
origin: >
  GitHub issue #605 (`issue create/edit --component`), single-issue facet (DEC-280). Depends
  on S-604-1 for the shared `resolve_component` resolver and the `Component` full-resource
  type (used to parse the project component-list GET this story's resolver call fires). The
  multi-key bulk facet (BC-3.4.023, integer `componentId`, LIVE-JIRA-gated) is split into its
  own story, S-605-2, because it carries a distinct wire shape and a live-smoke-test release
  gate that would otherwise block this story's simpler single-key path from shipping.
files_modified:
  - src/cli/issue/edit.rs
  - src/cli/issue/create.rs
  - src/cli/issue/format.rs
  - src/cli/mod.rs
  - src/api/jira/issues.rs
test_files:
  - tests/issue_commands.rs
  - tests/common/fixtures.rs
input-hash: "1fc9b9c"
---

> **tdd_mode:** `strict`.

# S-605-1: `issue create --component` / `issue edit --component` (single-key)

## Narrative

As a `jr` user, I want `--component` support on `issue create` (initial components array) and
single-key `issue edit` (add:/remove: prefix grammar, native Jira `update`-verb wire shape),
so that I can set and change an issue's components from the CLI the same way I already manage
labels, without a second round-trip to the web UI.

## Source of Truth

Read **BC-3.4.022, BC-3.4.024, BC-3.4.025** in `bc-3-issue-write.md` §3.4 in full — these are
the three component-specific BCs this story implements. Also read the COMPONENT-related
AMENDMENTS to four existing BCs (search for `components`/`--component` within each — the
amendment text is inline, not a separate BC number): **BC-3.4.012** (table echo gains a
`components` bullet + EC-3.4.012-17 bare-input normalization), **BC-3.4.013** (JSON
`changed_fields["components"]` + EC-3.4.013-14), **BC-3.4.017** (Gate B's flag-overlap set
grows to five fields including `components`, EC-3.4.017-15), **BC-3.4.020** (the `--label`
mutual-exclusion 13-flag list gains `--component`), **BC-3.4.021** (`--dry-run`'s
`plannedChanges` gains a `components` key + table preview item 6b). Also read **BC-8.4.001**
(the resolver this story's resolution calls delegate to — implemented in S-604-1).

## Behavioral Contracts

| BC ID | Title | Clause this story implements |
|-------|-------|-------------------------------|
| BC-3.4.022 | `issue edit KEY --component add:X --component remove:Y` (single-key) — native `update`-verb wire shape, editmeta-gated fallback | Full command |
| BC-3.4.024 | `issue create --component X --component Y` (bare, no prefix) sets initial components array | Full command |
| BC-3.4.025 | `--component` resolution mechanism: project component-list GET (not editmeta) for name validation | Resolver-mechanism pin shared by create/edit |
| BC-3.4.012 (amended) | Table-mode field echo gains `components → add:X, remove:Y` | Echo bullet |
| BC-3.4.013 (amended) | JSON-mode `changed_fields["components"]` | Echo field |
| BC-3.4.017 (amended) | Gate B flag-overlap: `--component` + `--field components=Y` on multi-key → exit 64 | 5th field member |
| BC-3.4.020 (amended) | `--label` + `--component` mutual exclusion (13-flag conflict list) | New conflict-list member |
| BC-3.4.021 (amended) | `--dry-run` `plannedChanges.components` + table preview | Dry-run parity |

## Behavior Summary (verbatim per BC — do not deviate)

- **`issue edit KEY --component add:X --component remove:Y` (single-key, BC-3.4.022)**:
  `PUT /rest/api/3/issue/{key}` body `{"update":{"components":[{"add":{"name":"X"}},
  {"remove":{"name":"Y"}}]}}` — `add:`/`remove:` prefix grammar (same as `--label`); a bare
  entry (no prefix) is treated as ADD. ADD elements precede REMOVE elements when both present.
  Component NAMES resolve via §8.4 (`resolve_component`, scoped to the issue's own project —
  extracted from KEY via the last-hyphen split) BEFORE the PUT. **Editmeta-gated fallback**:
  `GET /rest/api/3/issue/{key}/editmeta` checked for `fields.components.operations` containing
  `add`/`remove`; if present, use the native `update`-verb shape directly; if absent, fall back
  to read-modify-write (`GET` current `fields.components` → compute new full array → `PUT` via
  `set` verb `{"fields":{"components":[...]}}`). The editmeta gate is evaluated ONCE — no
  retry-with-different-shape on a subsequent 400. This is the single-key path ONLY —
  `keys.len() == 1` after `--jql` resolution; 2+ keys route to S-605-2's BC-3.4.023.
- **`issue create --component X --component Y` (BC-3.4.024)**: NO `add:`/`remove:` prefix
  grammar on `create` (an `add:X` literal on create is sent as-is and 400s as an unknown name —
  intentional, not a bug). `POST /rest/api/3/issue` body's `fields.components` array gets one
  `{"name": "<X>"}` object per supplied value, in CLI input order. Names resolve via §8.4
  BEFORE the POST. `--component` combined with `--request-type` (the JSM dispatch fork) → exit
  64 pre-flight (DEC-188 precedent, mirrors `--field`/`--on-behalf-of`'s S-639-1 guard), BEFORE
  project-key resolution/prompts/any HTTP — stderr names both flags and suggests a follow-up
  `jr issue edit --component`.
- **Resolution mechanism (BC-3.4.025)**: `create`'s `--component` resolution uses `GET
  /rest/api/3/project/{key}/components` (BC-8.1.001's endpoint, warm-cacheable via S-604-1's
  cache family) — NOT editmeta (create's editmeta call is differently-shaped and doesn't
  cleanly extend to a per-project component list). `edit`'s NAME→existence validation ALSO uses
  the project component-list GET; editmeta is consulted SEPARATELY, only for the wire-shape
  decision (native `update`-verb vs. read-modify-write fallback) — two different questions
  answered by two different calls, never duplicated within one invocation.
- **Table/JSON echo amendments**: table mode gains a `components` bullet:
  `  components → add:X, remove:Y` (comma-joined, prefix preserved; a BARE `--component X`
  entry is NORMALIZED to `add:X` in the echo — never rendered as bare `X`). JSON mode's
  `changed_fields["components"]` carries the SAME normalized comma-joined string (e.g.
  `"add:Backend"` for a bare `--component Backend`), NOT a JSON array. `--dry-run`'s
  `plannedChanges.components` uses a STRUCTURED array `[{"action":"ADD","name":"X"},
  {"action":"REMOVE","name":"Y"}]` (DIFFERENT shape from the live-echo string — see BC-3.4.021)
  and the dry-run TABLE preview line mirrors the live-echo normalization exactly:
  `"  components → add:X, remove:Y"`.
- **Gate B flag-overlap (BC-3.4.017 amendment)**: on a multi-key/`--jql` invocation, `--component
  add:X --field components=Y` (or `Components=Y`, case-insensitive) → exit 64, no HTTP —
  `components` joins the existing four-member overlap set (`summary`/`description`/`issuetype`/
  `priority`) as the fifth.
- **`--label` mutual exclusion (BC-3.4.020 amendment)**: `--component` is added to the 13-flag
  conflict list that `--label` cannot be combined with on ANY key count (single OR bulk) — this
  is a SEPARATE, earlier-firing guard from Gate B (which only applies at 2+ keys). Combining
  `--label add:foo --component add:bar` on a SINGLE key → exit 64 (without this guard, the
  `--label`-bulk-routing fork would silently drop the `--component` write — a data-loss
  hazard, VP-COMPONENT-027).

## Acceptance Criteria

### AC-001 (traces to BC-3.4.022 postcondition 1 — wire shape)
`jr issue edit FOO-1 --component add:Backend --component remove:Frontend` (single key) →
`PUT /rest/api/3/issue/FOO-1` body `{"update":{"components":[{"add":{"name":"Backend"}},
{"remove":{"name":"Frontend"}}]}}`.
**Test:** `test_bc_3_4_022_issue_edit_component_add_remove_native_wire_shape()`

### AC-002 (traces to BC-3.4.022 Edge Case EC-3.4.022-2 — bare treated as ADD)
`--component Backend` (bare, no prefix) → `{"add":{"name":"Backend"}}`.
**Test:** `test_bc_3_4_022_issue_edit_bare_component_treated_as_add()`

### AC-003 (traces to BC-3.4.022 Postcondition 2 — ADD-before-REMOVE ordering)
`--component remove:Y --component add:X` (remove specified first on the CLI) → the
`components` array still emits the ADD element before the REMOVE element.
**Test:** `test_bc_3_4_022_issue_edit_component_add_precedes_remove_regardless_of_cli_order()`

### AC-004 (traces to BC-3.4.022 Postcondition 3 — editmeta-gated fallback, native path)
editmeta advertises `fields.components.operations` containing `add`/`remove` → the native
`update`-verb PUT fires directly, zero extra `GET` for current components.
**Test:** `test_bc_3_4_022_issue_edit_component_editmeta_native_path()`

### AC-005 (traces to BC-3.4.022 Postcondition 3 — read-modify-write fallback)
editmeta does NOT advertise `add`/`remove` for `components` → `jr` GETs current
`fields.components`, computes the new full array client-side, `PUT`s via `set` verb
`{"fields":{"components":[...]}}`.
**Test:** `test_bc_3_4_022_issue_edit_component_editmeta_fallback_read_modify_write()`

### AC-006 (traces to BC-3.4.022 Edge Case EC-3.4.022-3)
Unknown component name → exit 64 via §8.4, zero `PUT` calls (the editmeta/list-components GET
used for resolution is the only HTTP that fires).
**Test:** `test_bc_3_4_022_issue_edit_unknown_component_zero_put()`

### AC-007 (traces to BC-3.4.024 postcondition 1 — create body composition)
`jr issue create --project FOO --component Backend --component Frontend` →
`fields.components = [{"name":"Backend"},{"name":"Frontend"}]`, CLI input order.
**Test:** `test_bc_3_4_024_issue_create_component_body_composition()`

### AC-008 (traces to BC-3.4.024 Edge Case EC-3.4.024-2 — no prefix interpretation on create)
`jr issue create --project FOO --component add:Backend` → resolver attempts to match a
component literally named `"add:Backend"` → unknown-name exit 64 (prefix grammar is
`edit`-only).
**Test:** `test_bc_3_4_024_issue_create_component_no_prefix_interpretation()`

### AC-009 (traces to BC-3.4.024 Postcondition 3 / EC-3.4.024-3 — request-type guard)
`jr issue create --request-type "IT Request" --component Backend` → exit 64, stderr names
both `--component` and `--request-type`, ZERO HTTP calls (no service-desk lookup, no RT-id
resolution, no component resolution).
**Test:** `test_bc_3_4_024_issue_create_component_request_type_guard_zero_http()`

### AC-010 (traces to BC-3.4.025 Invariant 1 — no duplicated HTTP)
Within one `issue create --component X`invocation, the project component-list GET fires
EXACTLY once — never duplicated with any editmeta GET.
**Test:** `test_bc_3_4_025_issue_create_component_resolution_one_get_not_duplicated()`

### AC-011 (traces to BC-3.4.012 amendment — table echo, prefixed)
Single-key success (table mode) with `--component add:X --component remove:Y` → stderr
contains `  components → add:X, remove:Y`.
**Test:** `test_bc_3_4_012_issue_edit_component_table_echo_prefixed()`

### AC-012 (traces to BC-3.4.012 Edge Case EC-3.4.012-17 — bare normalization)
`--component Backend` (bare) → stderr echo is `  components → add:Backend`, NOT `  components
→ Backend`.
**Test:** `test_bc_3_4_012_issue_edit_component_table_echo_bare_normalized_to_add()`

### AC-013 (traces to BC-3.4.013 amendment / EC-3.4.013-14 — JSON echo)
`--component Backend --output json` (bare) → `changed_fields["components"] == "add:Backend"`
— a STRING, not a JSON array.
**Test:** `test_bc_3_4_013_issue_edit_component_json_echo_normalized_string()`

### AC-014 (traces to BC-3.4.017 amendment / EC-3.4.017-15 — Gate B fifth field)
`jr issue edit KEY1 KEY2 --component add:X --field components=Y` → exit 64 (Gate B fires for
`components`, the fifth field), no HTTP. `--field Components=Y` (capitalized) triggers the
same guard.
**Test:** `test_bc_3_4_017_issue_edit_bulk_component_field_overlap_gate_b()`

### AC-015 (traces to BC-3.4.020 amendment — label/component mutual exclusion)
`jr issue edit KEY --label add:foo --component add:bar` (single key) → exit 64, stderr
contains both `"--label cannot be combined with"` and `"--component"` as separate
substrings; NEITHER the label-bulk path nor the component wire path fires — zero HTTP
(VP-COMPONENT-027).
**Test:** `test_bc_3_4_020_issue_edit_label_component_mutual_exclusion_zero_http()`

### AC-016 (traces to BC-3.4.021 amendment — dry-run JSON + table)
`--dry-run --output json FOO-1 --component add:X --component remove:Y` →
`plannedChanges.components == [{"action":"ADD","name":"X"},{"action":"REMOVE","name":"Y"}]`;
table mode → `"  components → add:X, remove:Y"`; ZERO `PUT`/editmeta-fallback `GET` calls
(VP-COMPONENT-028).
**Test:** `test_bc_3_4_021_issue_edit_component_dry_run_json_and_table_zero_mutation()`

### AC-017 (traces to BC-3.4.021 amendment — dry-run bare normalization parity)
`jr issue edit FOO-1 --component X --dry-run` (bare) → table preview renders `"  components →
add:X"` — IDENTICAL normalization to the live-edit echo (AC-012), not `"  components → X"`.
**Test:** `test_bc_3_4_021_issue_edit_component_dry_run_bare_normalization_matches_live()`

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `edit_issue_components` (native update-verb + read-modify-write fallback) | `src/cli/issue/edit.rs` (additive) | Effectful shell |
| `create`-path `--component` body composition | `src/cli/issue/create.rs` (additive) | Effectful shell |
| `components` echo formatting (table + JSON) | `src/cli/issue/format.rs` (additive, or co-located with existing echo helpers in `edit.rs`) | Pure (string formatting) |
| `--component` CLI flag | `src/cli/mod.rs` (additive on `Edit`/`Create` variants) | N/A (clap derive) |

## Edge Cases

Covered by dedicated ACs above: EC-3.4.022-2/3, EC-3.4.024-2/3, EC-3.4.012-17, EC-3.4.013-14,
EC-3.4.017-15. Additional ECs from the BC bodies to include in test-writer's expanded suite:
`--component` name resolution reuses the SAME resolver contract as `component edit`/`delete`
(no duplicated disambiguation logic) — a cross-project non-collision fixture (mirrors
VP-COMPONENT-010) should be included here too, scoped to the issue-write call sites.

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `cli/issue/edit.rs` (component additions) | Effectful shell (unchanged classification) | Already-effectful handler; additive call pattern |
| `cli/issue/create.rs` (component additions) | Effectful shell (unchanged classification) | Already-effectful handler |
| `cli/issue/format.rs` (echo helper, if added there) | Pure | String-in, string-out |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|--------------------|
| This story spec | ~7k |
| BC-3.4.022/024/025 bodies | ~9k |
| BC-3.4.012/013/017/020/021 amendment excerpts | ~4k |
| S-604-1 resolver/cache foundation | ~3k |
| `src/cli/issue/edit.rs` label-editing precedent (BC-3.4.006 window) | ~4k |
| `src/cli/issue/create.rs` (existing body-composition window) | ~2k |
| Test files + fixtures | ~7k |
| Tool outputs | ~5k |
| **Total** | **~41k** |
| Agent context window | 200K |
| **Budget usage** | **~21%** |

## Tasks (MANDATORY)

1. [ ] Write failing tests for single-key `edit --component` wire shape (add/remove, bare,
   ordering, editmeta-gated fallback, unknown name)
2. [ ] Write failing tests for `create --component` (body composition, no-prefix-
   interpretation, request-type guard)
3. [ ] Write failing tests for the resolution-mechanism invariant (one GET, not duplicated)
4. [ ] Write failing tests for table/JSON echo (prefixed + bare-normalized) and dry-run parity
5. [ ] Write failing tests for the Gate B fifth-field overlap and the `--label` mutual
   exclusion
6. [ ] Verify Red Gate
7. [ ] Implement single-key `edit --component` in `cli/issue/edit.rs`
8. [ ] Implement `create --component` in `cli/issue/create.rs`
9. [ ] Implement echo/dry-run formatting
10. [ ] Wire `--component` flag + Gate B/label-conflict-list updates
11. [ ] Refactor; full suite green

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|----------------|------------------------|-----------------------|
| S-604-1 | `resolve_component(input, project, candidates)`, components cache | This story's resolution calls ARE `resolve_component` calls, scoped to the issue's own project (extracted from KEY via the last-hyphen split, BC-3.4.018 Invariant 4) — reuse verbatim, do not reimplement | The full-resource `Component.id: String` (required) is what the project component-list GET deserializes into; do not confuse with the embedded `issue.rs::Component.id: Option<String>` when parsing an issue's OWN `fields.components` for the read-modify-write fallback |

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|--------------|
| The editmeta gate is evaluated ONCE per invocation — no retry-with-different-shape on a 400 | BC-3.4.022 Invariant 2 | AC-004/AC-005; code review |
| `create`'s `--component` resolution NEVER uses editmeta — only the project component-list GET | BC-3.4.025 Behavior | AC-010 |
| `selectedActions`/`editedFieldsInput` casing asymmetries do NOT apply to this story's single-key wire shape (that's S-605-2's bulk path) — do not import bulk-path field names here | BC-3.4.023 (contrast, out of scope) | Code review |
| Bare `--component X` normalizes to `add:X` in BOTH the live echo and the dry-run preview — identical string, one shared formatting function | BC-3.4.012/BC-3.4.021 amendments | AC-012, AC-017 |
| `--label` + `--component` conflict fires BEFORE the component wire-shape logic — no partial write | BC-3.4.020 amendment | AC-015 |

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|----------|
| reqwest / serde (existing) | as in `Cargo.lock` | HTTP + body composition |
| wiremock (existing) | as in `Cargo.lock` | Integration tests |

No new crate dependencies.

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|----------|
| `src/cli/issue/edit.rs` | MODIFY | Single-key `--component` wire shape, echo, dry-run |
| `src/cli/issue/create.rs` | MODIFY | `--component` body composition, request-type guard |
| `src/cli/issue/format.rs` | MODIFY | `components` echo/normalization helper (if not co-located in `edit.rs`) |
| `src/cli/mod.rs` | MODIFY | `--component` flag on `Edit`/`Create` variants |
| `src/api/jira/issues.rs` | MODIFY (call sites only) | editmeta-gated fallback GET/PUT reuse of existing patterns |
| `tests/issue_commands.rs` | MODIFY | New test cases (17 ACs) |
| `tests/common/fixtures.rs` | MODIFY | editmeta/component-list/issue-edit fixtures |

**MUST NOT change**: `src/cli/issue/edit.rs::handle_edit_bulk_fields` (multi-key path —
S-605-2's scope, BC-3.4.023); `src/cli/component.rs` (S-604-1/2/3, unrelated command group).
