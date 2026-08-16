---
document_type: story
level: ops
epic_id: "none"
story_id: "S-604-2"
title: "jr component create and jr component edit"
wave: null
status: draft
intent: feature
feature_type: backend
mode: feature
scope: standard
severity: N/A
trivial_scope: false
issue: 604
points: 8
priority: P0
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
  - "BC-8.1.005"
  - "BC-8.1.006"
  - "BC-8.1.007"
  - "BC-8.1.008"
  - "BC-8.1.004"
bcs:
  - "BC-8.1.005"
  - "BC-8.1.006"
  - "BC-8.1.007"
  - "BC-8.1.008"
  - "BC-8.1.004"
verification_properties: ["VP-COMPONENT-002", "VP-COMPONENT-004", "VP-COMPONENT-022", "VP-COMPONENT-023", "VP-COMPONENT-024"]
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
  GitHub issue #604 (`jr component list/create/edit/delete`). Second story in the
  component-management bundle — implements the two non-destructive mutating subcommands
  (`create`, `edit`) on top of S-604-1's types/API-client/cache/resolver foundation.
  `delete` is deliberately split into its own story (S-604-3) because it carries
  materially different safety obligations (DEC-279) that would overload this story's
  token budget and blur its adversarial-review focus.
files_modified:
  - src/api/jira/components.rs
  - src/cli/component.rs
  - src/cli/mod.rs
  - src/cache.rs
test_files:
  - tests/component_commands.rs
  - tests/common/fixtures.rs
input-hash: "8f1dcf8"
---

> **tdd_mode:** `strict`.

# S-604-2: `jr component create` and `jr component edit`

## Narrative

As a `jr` user, I want `jr component create` and `jr component edit` commands that mirror
this codebase's existing partial-update conventions (only-supplied fields are sent, `--lead`
resolves through the same assignable-user machinery `issue assign` uses), so that I can
manage component metadata from the CLI without ever risking a partial or wrong-project
mutation.

## Source of Truth

Read **BC-8.1.005, BC-8.1.006, BC-8.1.007, BC-8.1.008** in `bc-8-components.md` in full — this
story summarizes them but the BCs carry extensive adversarial-review correction history
(numeric-source project-confirmation mechanism, `--lead ""` semantics, exit-code class
fixes per DEC-188). Only the LATEST, non-superseded text in each BC is normative. Also read
**BC-8.1.004**'s NUMERIC-ID EXEMPTION clause (edit's no-`--project` numeric bypass) and
**ADR-0018 Decision §1** (the confirming-GET mechanism) and **§2** (cache invalidation).

## Behavioral Contracts

| BC ID | Title | Clause this story implements |
|-------|-------|-------------------------------|
| BC-8.1.005 | `jr component create --project KEY NAME [--description] [--lead] [--assignee-type]` POSTs `/rest/api/3/component` | Full command |
| BC-8.1.006 | `--lead <NAME>` resolves to `accountId`; ambiguous/no-match aborts BEFORE the mutating call | Lead resolver, numeric-`edit` project derivation |
| BC-8.1.007 | `jr component edit NAME\|ID [--project] [--name] [--description] [--lead]` PUTs `/rest/api/3/component/{id}`; only supplied fields sent | Full command, M1 numeric-source project confirmation |
| BC-8.1.008 | Unknown `NAME\|ID` → exit 64, taxonomy-consistent message; numeric bypass | Not-found/ambiguous message composition for `edit` |
| BC-8.1.004 | Numeric-ID exemption on `edit` (no `--project`/config required for a numeric target) | The `edit`-scoped exemption slice |

## Behavior Summary (verbatim per BC — do not deviate)

- **`create`**: `--project KEY` is clap-REQUIRED (no config-fallback — BC-8.1.004 exclusion
  case 1; an absent `--project` is clap exit 2, never this command's own exit 64). `NAME` is a
  required positional. `POST /rest/api/3/component` body: `{"name": NAME, "project": KEY,
  "description": D (if supplied), "leadAccountId": <resolved> (if --lead supplied),
  "assigneeType": TYPE (if supplied)}` — absent optional flags are OMITTED from the body
  entirely, never sent as `null` (VP-COMPONENT-022). `--assignee-type` is a clap `ValueEnum`
  (`PROJECT_LEAD`, `COMPONENT_LEAD`, `UNASSIGNED`, `PROJECT_DEFAULT`) — an out-of-enum value is
  a clap exit-2 rejection, NOT this codebase's own exit 64 (DEC-188 exit-code class — do NOT
  add an app-level guard for this). On success (201): `--output json` →
  `{"id": "<id>", "name": "<name>", "project": "<key>"}`; table mode → stderr `Created
  component "<name>" (id <id>) in project <key>.`. A name-collision 400 is surfaced verbatim
  (not pre-validated client-side, EC-8.1.005-1). `create --lead ""` is rejected by an
  APPLICATION-LEVEL guard (`JrError::UserError`, exit 64 — clap does NOT reject an empty
  `String`), `"--lead \"\" has no effect on create — there is no existing lead to clear. Omit
  --lead, or supply a name."`, before any POST.
- **`--lead <NAME>`** (create AND edit): resolves via `search_assignable_users_by_project`
  scoped to the target project (same resolver `issue assign --to` uses) to a single
  `accountId`, sent as `leadAccountId`. Resolution happens BEFORE the mutating HTTP call. Zero
  or 2+ matches → exit 64 listing candidate emails/accountIds, zero POST/PUT
  (VP-COMPONENT-002). On `edit` with a NUMERIC `NAME|ID` and no `--project`/config, "the target
  project" for this search is derived from the SAME confirming GET BC-8.1.007 M1 fires for
  existence — see below.
- **`edit NAME|ID [--project KEY] [--name N] [--description D] [--lead NAME]`**: `PUT
  /rest/api/3/component/{id}` body contains ONLY the explicitly-supplied fields — `--name`,
  `--description`, `--lead` each independently gate their own key. At least one of
  `--name`/`--description`/`--lead` MUST be supplied or exit 64 ("no fields specified to
  update") BEFORE resolution (Precondition 1 fires before §8.4 resolution AND before the
  numeric-source confirming GET — this ordering is load-bearing, per BC-8.1.007's P16
  fix-burst correction: a numeric `NAME|ID` with no field flags fires ZERO HTTP, not even the
  confirming GET). `--lead ""` sends `"leadAccountId": null` (explicit clear) — DISTINCT from
  omitting `--lead` (leaves lead untouched, no key in body).
- **Numeric-source project derivation (M1, BC-8.1.007)**: when `NAME|ID` is numeric, `jr` fires
  ONE confirming `GET /rest/api/3/component/{id}` (the same GET BC-8.1.008's numeric bypass
  already requires for existence) and reads its `project` field. This derived project scopes
  `--lead` resolution (when `--lead` is supplied) and becomes the `project_key` argument to
  `invalidate_components_cache(profile, project_key)` (ADR-0018 §2). A supplied `--project KEY`
  that MISMATCHES the derived project → exit 64 pre-flight, `"Component <id> belongs to
  project <actual>, not <KEY>."`, ZERO mutating HTTP. A NAME `NAME|ID` is unaffected (already
  scoped by `--project`/config). This confirming GET only fires AFTER Precondition 1's
  no-fields check passes (see ordering note above).
- **404 taxonomy (Idempotency section, BC-8.1.007)**: resolver/confirming-GET 404 (bad
  `NAME|ID`) → exit 64 (BC-8.1.008's ordinary not-found path). A `PUT` that itself races and
  404s AFTER a successful resolution (component deleted concurrently) → `ApiError(404)`, exit 1
  — the two are DISTINGUISHABLE by exit code and must never be collapsed (VP-COMPONENT-024,
  extended to `edit` from its canonical `delete`-side definition at BC-8.2.008).
- **Not-found message composition (BC-8.1.008)**: NAME input defers entirely to
  BC-8.4.002/003's messages (no `edit`-specific wording). Numeric input: if a project is KNOWN
  from ANY source (flag/config/prior-derived-in-this-invocation) → project-qualified message,
  REGARDLESS of whether the confirming GET is the call that 404s. If NO project is known by any
  source → the project-less variant.

## Acceptance Criteria

### AC-001 (traces to BC-8.1.005 postcondition — required body)
`jr component create --project FOO Backend` → `POST /rest/api/3/component` body is exactly
`{"name":"Backend","project":"FOO"}` — no other keys.
**Test:** `test_bc_8_1_005_component_create_minimal_body()`

### AC-002 (traces to BC-8.1.005 postcondition — optional fields)
`jr component create --project FOO Backend --description "d" --lead alice --assignee-type
PROJECT_LEAD` → body contains exactly `name`, `project`, `description`, `leadAccountId`,
`assigneeType` — all five keys, no others (VP-COMPONENT-022).
**Test:** `test_bc_8_1_005_component_create_all_optional_fields_present()`

### AC-003 (traces to BC-8.1.005 postcondition — omit-if-absent)
`jr component create --project FOO Backend` (no optional flags) → body has NO
`description`/`leadAccountId`/`assigneeType` keys (never sent as `null`).
**Test:** `test_bc_8_1_005_component_create_omits_absent_optional_keys()`

### AC-004 (traces to BC-8.1.005 postcondition — success output)
201 response → `--output json` returns `{"id":"<id>","name":"<name>","project":"<key>"}`;
table mode emits stderr `Created component "<name>" (id <id>) in project <key>.`.
**Test:** `test_bc_8_1_005_component_create_success_output_both_modes()`

### AC-005 (traces to BC-8.1.005 Edge Case EC-8.1.005-2 / DEC-188)
`--assignee-type BOGUS` → clap exit 2 (`ValueEnum` rejection), zero HTTP — NOT this
codebase's exit 64.
**Test:** `test_bc_8_1_005_component_create_bad_assignee_type_exits_2()`

### AC-006 (traces to BC-8.1.006 Edge Case EC-8.1.006-3)
`jr component create --project FOO Backend --lead ""` → exit 64 via the app-level
empty-lead-on-create guard, zero POST calls.
**Test:** `test_bc_8_1_006_component_create_empty_lead_exits_64_zero_post()`

### AC-007 (traces to BC-8.1.006 postcondition — ambiguous/no-match lead)
`--lead "Ambiguous"` (2+ matches) → exit 64 listing candidates, zero POST; `--lead "Nobody"`
(zero matches) → exit 64 `"No user matching 'Nobody'"`, zero POST (VP-COMPONENT-002).
**Test:** `test_bc_8_1_006_component_create_lead_ambiguous_and_no_match_zero_post()`

### AC-008 (traces to BC-8.1.007 postcondition 1 — partial PUT)
`jr component edit Backend --project FOO --name NewName` → `PUT
/rest/api/3/component/{id}` body is exactly `{"name":"NewName"}` — no `description`/
`leadAccountId` keys.
**Test:** `test_bc_8_1_007_component_edit_put_contains_only_supplied_fields()`

### AC-009 (traces to BC-8.1.007 postcondition 2 — lead clear vs omit)
`--lead ""` → body contains `"leadAccountId": null`; omitted `--lead` → body has no
`leadAccountId` key at all.
**Test:** `test_bc_8_1_007_component_edit_lead_empty_string_clears_vs_omitted()`

### AC-010 (traces to BC-8.1.007 Precondition 1 — no-fields guard, NAME input)
`jr component edit Backend --project FOO` (no field flags) → exit 64 "no fields specified",
ZERO HTTP calls, including zero §8.4 resolution GET.
**Test:** `test_bc_8_1_007_component_edit_name_input_no_fields_zero_http()`

### AC-011 (traces to BC-8.1.007 Edge Case EC-8.1.007-7 — no-fields guard, numeric input)
`jr component edit 10042` (no field flags, numeric) → exit 64 "no fields specified", ZERO
HTTP calls, including zero confirming GET.
**Test:** `test_bc_8_1_007_component_edit_numeric_input_no_fields_zero_http()`

### AC-012 (traces to BC-8.1.007 M1 / EC-8.1.007-3 — numeric project derivation)
`jr component edit 10042 --lead "Alice"` (numeric, no `--project`/config) → confirming `GET
/rest/api/3/component/10042` derives `"project":"ENG"`; `--lead "Alice"` resolves against
ENG's assignable users; `PUT` fires with `{"leadAccountId":"<resolved>"}`.
**Test:** `test_bc_8_1_007_component_edit_numeric_derives_project_for_lead_resolution()`

### AC-013 (traces to BC-8.1.007 Postcondition 3 / EC-8.1.007-4 — project mismatch)
`jr component edit 10042 --project WRONG --name Foo` where `10042` belongs to `ENG` → exit
64 pre-flight `"Component 10042 belongs to project ENG, not WRONG."`, ZERO `PUT` calls.
**Test:** `test_bc_8_1_007_component_edit_numeric_project_mismatch_zero_put()`

### AC-014 (traces to BC-8.1.008 Edge Case EC-8.1.007-5/EC-8.1.007-6 — not-found message)
`jr component edit 999999999 --name Foo` (numeric, nonexistent, no `--project`/config) →
confirming GET 404s → exit 64, project-less message. Same command WITH `--project ENG`
supplied → exit 64, project-QUALIFIED message `"Component '999999999' not found in project
ENG. Run: jr component list"`.
**Test:** `test_bc_8_1_008_component_edit_numeric_notfound_message_variants()`

### AC-015 (traces to BC-8.1.008 Behavior branch 0 — NAME not-found/ambiguous)
`jr component edit BadName --project ENG --name Foo` (zero matches) → exit 64, BC-8.4.002's
verbatim message. `jr component edit Amb --project ENG --name Foo` (2+ matches) → exit 64,
BC-8.4.003's verbatim message.
**Test:** `test_bc_8_1_008_component_edit_name_notfound_and_ambiguous_messages()`

### AC-016 (traces to BC-8.1.007 Idempotency section — 404 taxonomy)
A wiremock fixture where the confirming GET/resolver succeeds but the follow-up `PUT` races
to 404 (concurrent delete) → `ApiError(404)`, exit 1 — DISTINCT from AC-014's exit-64
not-found path (VP-COMPONENT-024).
**Test:** `test_bc_8_1_007_component_edit_put_race_404_exits_1_distinct_from_resolver_404()`

### AC-017 (traces to BC-8.1.004 NUMERIC-ID EXEMPTION — edit)
`jr component edit 10042 --name Foo` with NO `--project` and no configured project →
proceeds normally (guard does not fire) — contrast `jr component edit BadName --name Foo`
(NAME, non-numeric) under the same no-`--project`-no-config condition → exit 64.
**Test:** `test_bc_8_1_004_component_edit_numeric_id_exemption_vs_name_requires_project()`

### AC-018 (traces to ADR-0018 Decision §2 — cache invalidation)
A successful `component edit`/`component create` call invalidates the components cache entry
for the affected project (`invalidate_components_cache(profile, project_key)`) — a
subsequent `component list` in the same test does not read a stale cached entry.
**Test:** `test_adr_0018_component_create_and_edit_invalidate_cache()`

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `create_component`, `edit_component`, `get_component` (confirming GET) | `src/api/jira/components.rs` (additive) | Effectful shell |
| `handle_create`, `handle_edit` | `src/cli/component.rs` (additive) | Effectful shell |
| `ComponentSubcommand::Create`/`Edit` | `src/cli/mod.rs` (additive) | N/A (clap derive) |
| `--lead` resolution reuse | `src/api/jira/users.rs::search_assignable_users_by_project` (existing, unmodified) | Effectful shell |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-8.1.005-1 | `NAME` collides with existing component | Jira 400 surfaced verbatim |
| EC-8.1.006-1/2 | `--lead` ambiguous/no-match | exit 64, candidate list / "No user matching", zero HTTP |
| EC-8.1.007-1 | `edit foo` (NAME, no field flags) | exit 64 "no fields", zero HTTP incl. zero §8.4 GET |
| EC-8.1.007-2 | `--name` collides with existing name | Jira 400 verbatim |
| EC-8.1.007-3/4 | numeric edit, project derivation/mismatch | see AC-012/AC-013 |
| EC-8.1.008-3 | numeric, nonexistent, no project known | project-less not-found message |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `api/jira/components.rs` (create/edit/get) | Effectful shell | HTTP |
| `cli/component.rs` (`handle_create`/`handle_edit`) | Effectful shell | HTTP + cache invalidation + stdout/stderr |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|--------------------|
| This story spec | ~6k |
| BC-8.1.004-008 bodies (read in full) | ~14k |
| ADR-0018 Decision §1/§2 | ~3k |
| S-604-1 foundation code (types/cache/resolver) | ~4k |
| `--lead` resolver precedent (`issue assign --to`) | ~2k |
| Test files + fixtures | ~6k |
| Tool outputs | ~5k |
| **Total** | **~40k** |
| Agent context window | 200K |
| **Budget usage** | **~20%** |

## Tasks (MANDATORY)

1. [ ] Write failing tests for `create` (body composition, omit-if-absent, success output,
   assignee-type enum exit-2, empty-lead guard)
2. [ ] Write failing tests for `--lead` resolution (ambiguous/no-match, zero mutating HTTP)
3. [ ] Write failing tests for `edit` (partial PUT, no-fields guard ordering, lead clear-vs-omit)
4. [ ] Write failing tests for `edit`'s numeric-source project derivation/mismatch/404 taxonomy
5. [ ] Verify Red Gate
6. [ ] Implement `create_component`/`edit_component`/confirming `get_component` in
   `api/jira/components.rs`
7. [ ] Implement `handle_create`/`handle_edit` in `cli/component.rs`
8. [ ] Wire cache invalidation calls
9. [ ] Wire CLI flags/subcommands into `cli/mod.rs`
10. [ ] Refactor; full suite green

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|----------------|------------------------|-----------------------|
| S-604-1 | `resolve_component` numeric-bypass/project-scoped resolver; components cache family (`ProjectMeta` shape); `Component` full-resource type with required `id: String` | This story's numeric-source confirming GET reuses the SAME single-resource GET BC-8.1.008's bypass already requires — do not introduce a second GET | The full-resource `Component.id` is required `String` (not `Option`) — do not confuse with the embedded `issue.rs::Component.id: Option<String>` when parsing the confirming GET's response |

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|--------------|
| `--assignee-type` invalid value is clap exit 2, NEVER this codebase's own exit 64 | BC-8.1.005 EC-8.1.005-2, DEC-188 | AC-005; code review — no app-level guard added for this flag |
| `create --lead ""` and `edit`'s no-fields guard are APPLICATION-LEVEL `JrError::UserError` checks, not clap mechanisms | BC-8.1.006, BC-8.1.007 Precondition 1, DEC-188 | AC-006, AC-010, AC-011 |
| `edit`'s Precondition 1 (no-fields check) is evaluated BEFORE §8.4 resolution AND before the numeric-source confirming GET | BC-8.1.007 Preconditions ordering note (P16 fix-burst) | AC-010, AC-011 |
| Numeric-source confirming GET reuses the SAME single-resource GET the numeric bypass already requires — never a second, separate GET | ADR-0018 Decision §1 | Code review; wiremock `.expect(1)` on the confirming-GET route |
| Resolver/confirming-GET 404 → exit 64; mutating-call 404 after successful resolution → exit 1 | BC-8.1.007 Idempotency section, VP-COMPONENT-024 | AC-014 vs AC-016 |
| `--lead` resolution reuses `search_assignable_users_by_project` — no new user-search code path | BC-8.1.006 Known limitation | Code review |

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|----------|
| clap (existing) | as in `Cargo.lock` | `ValueEnum` for `--assignee-type` |
| reqwest / serde (existing) | as in `Cargo.lock` | HTTP + body composition |
| wiremock (existing) | as in `Cargo.lock` | Integration tests |

No new crate dependencies.

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|----------|
| `src/api/jira/components.rs` | MODIFY | `create_component`, `edit_component`, `get_component` |
| `src/cli/component.rs` | MODIFY | `handle_create`, `handle_edit` |
| `src/cli/mod.rs` | MODIFY | `ComponentSubcommand::Create`/`Edit` flags |
| `src/cache.rs` | MODIFY (call sites only) | Invoke `invalidate_components_cache` after success |
| `tests/component_commands.rs` | MODIFY | New test cases |
| `tests/common/fixtures.rs` | MODIFY | create/edit response fixtures |

**MUST NOT change**: `src/cli/component.rs::handle_list` (S-604-1, unrelated); `delete`
(S-604-3, separate story); `src/api/jira/users.rs` (reused unmodified).
