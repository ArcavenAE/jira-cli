---
document_type: story
story_id: "S-JSM-RESOLUTION-REQUIRED"
title: "jr issue move proactive resolution enforcement on done-category transitions"
wave: feature-followup
status: ready
intent: feature
feature_type: feature
mode: feature
scope: medium
severity: breaking-change
trivial_scope: false
issue: TBD
points: 5
priority: P0
tdd_mode: strict
estimated_effort: medium
estimated_days: 2
target_module: cli/issue/workflow
subsystems: []
depends_on:
  - S-JSM-E2E-2
blocks: []
bc_anchors:
  - BC-3.2.013
  - BC-3.2.009
  - BC-3.2.010
  - BC-3.2.011
  - BC-2.3.036
bcs:
  - BC-3.2.013
  - BC-3.2.009
  - BC-3.2.010
  - BC-3.2.011
  - BC-2.3.036
verification_properties:
  - VER-JSM-RES-1
  - VER-JSM-RES-2
holdout_anchors: []
nfr_anchors: []
adr_refs:
  - ADR-0015
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: "docs/specs/issue-move-resolution.md + docs/adr/0015-proactive-resolution-enforcement.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 8
assumption_validations: []
risk_mitigations: []
supersedes: S-JSM-E2E-3
created: "2026-06-03"
last_updated: "2026-06-03"
breaking_change: true
changelog:
  - date: "2026-06-03"
    phase: F3-story-decomposition
    author: story-writer
    summary: >
      Initial story creation. Feature (SRC + tests): proactive resolution enforcement on
      done-category transitions. Supersedes bypass-demo branch of S-JSM-E2E-3 (inverted to
      enforcement assertion). BC-3.2.013 primary; BC-3.2.009/010/011/BC-2.3.036 reused.
      New API method get_transitions_with_fields, Transition.fields + is_conditional, --no-resolution
      flag, single-key enforcement, E2E inversion from S-JSM-E2E-3 carried forward.
files_modified:
  - src/api/jira/issues.rs             # get_transitions_with_fields method (new)
  - src/types/jira/issue.rs            # Transition.fields + is_conditional (new fields)
  - src/cli/issue/workflow.rs          # handle_move enforcement + prompt block
  - src/cli/mod.rs                     # --no-resolution flag (new)
  - tests/issue_move_resolution_enforce.rs   # new integration test file (wiremock)
  - tests/e2e_live.rs                  # invert bypass-demo; carry forward jsm_discover_resolution + SURFACE
  - tests/e2e_cli_surface_guard.rs     # add --no-resolution to issue move SURFACE row
  - CHANGELOG.md                       # Breaking Changes entry
  - CLAUDE.md                          # gotcha: --no-resolution flag; proactive enforcement gate
---

# S-JSM-RESOLUTION-REQUIRED — jr issue move Proactive Resolution Enforcement

## Source of Truth

Design spec: `docs/specs/issue-move-resolution.md` (proactive enforcement section).
ADR: `docs/adr/0015-proactive-resolution-enforcement.md`.
API validation: `.factory/research/jsm-resolution-required-api-validation.md`.
Delta analysis: `.factory/phase-f1-delta-analysis/jsm-resolution-required/delta-analysis.md`.
Superseded story (E2E work carried forward): `.factory/stories/S-JSM-E2E-3-jsm-resolution-enforcement.md`.

**BC-3.2.013 is the primary behavioral contract. All other BCs are reused (not modified).**

## Behavioral Contracts

| BC | Title | Role in this story |
|----|-------|-------------------|
| BC-3.2.013 | `issue move` (single-key) proactively enforces resolution when target transition is done-category AND offers resolution field or is conditional | PRIMARY: enforces proactive gate, both REQUIRED and OPTIONAL branches, --no-resolution flag, conservative gate, read-command-stability contract |
| BC-3.2.009 | `issue move` 400 "resolution required" → `--resolution` hint + `jr issue resolutions` pointer | RETAINED as reactive backstop; BC-3.2.013 is first-line; BC-3.2.009 catches residual cases and validator-enforced workflows |
| BC-3.2.010 | `issue resolutions` reads cache-first (7d TTL); JSON `[{name, id, description}]` | REUSED: `load_resolutions(client, false)` used by both the interactive prompt path and the existing --resolution flag path |
| BC-3.2.011 | `transition_issue(key, id, Some(&fields))` body contains `{transition:{id}, fields:{resolution:{name}}}` | REUSED: resolution body shape unchanged whether set via --resolution flag or interactive prompt |
| BC-2.3.036 | `get_issue` deserializes nullable `resolution` field | REUSED: E2E read-back assertion (positive path: `fields.resolution.name == R`) |

## Domain Context

`jr issue move` calls `POST /rest/api/3/issue/{key}/transitions`. On JSM workflows
(and classic Jira workflows where resolution lives on the Done screen), the API previously
left issues in a half-resolved state when no `resolution` field was provided: status set,
but `resolution=null` and `resolutionDate=null`. JQL filter `resolution IS EMPTY` continued
to match, SLAs did not stop, and reporters saw the issue as open on the portal even though
agents saw it as done.

Atlassian explicitly documents this gap (Claim 3 in API validation): "Issue transition API
is not expected to respect the screens." Screen-only resolution requirements are silently
bypassed — a 400 never fires unless a workflow validator backs the requirement. This is
instance-independent, documented Atlassian behavior.

This feature adds proactive enforcement to `handle_move` (single-key only) via
`GET .../transitions?expand=transitions.fields`. When the target transition is a done-category
transition AND offers a resolution field (or has `isConditional=true`), `jr` intercepts
BEFORE the POST and either prompts the user (interactive TTY) or exits 64 (non-interactive).

## Story Narrative

As a Jira user moving an issue to a done-category status on a JSM or classic Jira workflow,
I want `jr issue move` to require a resolution upfront when the transition offers one,
so that I do not accidentally create silently-unresolved done issues that pollute JQL
`resolution IS EMPTY` filters and keep SLAs running indefinitely.

As a script author who intentionally closes issues without a resolution (e.g., "Won't Do"
paths), I want a `--no-resolution` explicit opt-out flag on `jr issue move`,
so that I can acknowledge the no-resolution intent and maintain existing behavior without
silent bypass.

## Dependency Justification

**`depends_on: [S-JSM-E2E-2]`** — S-JSM-E2E-2 delivers the improved `jsm_self_close`
teardown helper with dynamic `statusCategory==done` discovery. This story's E2E inversion
extends that helper to also pass `--resolution`; the extension must apply to the
S-JSM-E2E-2 version (not the older S-JSM-E2E-1 skeleton). S-JSM-E2E-2 must be deployed
to the worktree branch before implementation begins.

**`blocks: []`** — no current story depends on this enforcement to proceed.

**Reuse plan:** The work happens in the existing worktree
`.worktrees/S-JSM-E2E-3` (branch to be renamed `feat/jsm-resolution-required`).
All E2E-3 positive-path test work, `jsm_discover_resolution`, `jsm_self_close` teardown,
and SURFACE rows are carried forward unchanged. The bypass-demo branch is inverted.

## Acceptance Criteria

### AC-001 — get_transitions_with_fields: new API method; Transition struct extended; read-command stability contract
(traces to BC-3.2.013 precondition — `get_transitions_with_fields` must populate `fields`)

`JiraClient::get_transitions_with_fields(key: &str) -> Result<TransitionsResponse>` is added
to `src/api/jira/issues.rs`. It calls
`GET /rest/api/3/issue/{key}/transitions?expand=transitions.fields`.

`Transition` in `src/types/jira/issue.rs` gains two new fields:

```rust
#[serde(default, skip_serializing)]
pub fields: Option<std::collections::HashMap<String, serde_json::Value>>,

#[serde(rename = "isConditional", default, skip_serializing)]
pub is_conditional: Option<bool>,
```

Both fields carry `#[serde(skip_serializing)]`. This is the governing type-level stability
contract for `jr issue transitions --output json`: the output is BYTE-IDENTICAL to today.
A dedicated test pins the exact output shape:

```
test_transitions_json_output_unchanged_after_fields_added
```

This test deserializes a mock transitions response WITH `fields` populated and then
re-serializes the `Transition` values; the resulting JSON must NOT contain a `fields` or
`isConditional` key (verifying `skip_serializing`). `handle_transitions` (the
`jr issue transitions` read command) continues to call `get_transitions` (no expand);
only `handle_move` uses `get_transitions_with_fields`.

(traces to BC-3.2.013 precondition — transition struct must decode expanded fields;
ADR-0015 §3 read-command stability decision)

---

### AC-002 — Enforcement gate fires on done-category transitions; skips on others
(traces to BC-3.2.013 trigger condition and conservative gate)

After `handle_move` resolves the selected transition via `get_transitions_with_fields`,
the enforcement gate evaluates:

```
is_done_category  = transition.to.statusCategory.key == "done"
offers_resolution = transition.fields.contains_key("resolution")
is_conditional    = transition.is_conditional == Some(true)
needs_resolution  = is_done_category && (offers_resolution || is_conditional)
```

**Conservative gate:** If `to.statusCategory` is absent (None), `is_done_category`
evaluates to `false` and `needs_resolution` is `false`. The transition is attempted
without enforcement; BC-3.2.009 backstop applies.

**Gate-skip when fields absent:** If `to.statusCategory.key == "done"` but the `fields`
map is entirely absent AND `is_conditional` is None/false, `needs_resolution` is `false`.
Conservative gate fires; BC-3.2.009 backstop applies.

The following test vectors MUST pass (wiremock):
- `statusCategory.key="done"` + `fields.resolution` + `--no-input` + no flags → exit 64 (gate fired; REQUIRED branch)
- `statusCategory.key="indeterminate"` + `fields.resolution` + `--no-input` → exit 0 (gate did not fire)
- No `statusCategory` on `to` + `--no-input` → exit 0 (conservative gate; POST fired)
- `statusCategory.key="done"` + NO `fields` key at all + `--no-input` → exit 0 (conservative gate; POST fired)

(traces to BC-3.2.013 trigger condition, conservative gate, EC-3.2.013-4)

---

### AC-003 — REQUIRED branch: --resolution / --no-input / prompt behavior
(traces to BC-3.2.013 Resolution-REQUIRED branch postconditions)

When `needs_resolution` is `true` AND the branch is REQUIRED
(`fields.resolution.required == true` OR `is_conditional == true`):

- **`--resolution <name>` provided:** validate name against `transition.fields.resolution.allowedValues`
  when present; exit 64 with candidate list if not found (EC-3.2.013-3). When valid (or
  `allowedValues` absent), set `{resolution: {name: "<name>"}}` in the transition body and
  proceed. Body shape matches BC-3.2.011.

- **`--no-resolution` provided:** exit 64 (`UserError`) with stderr containing both
  `"requires a resolution"` and `"--no-resolution cannot be used here"` and
  `"jr issue resolutions"`.

- **Non-interactive (`--no-input` OR stdin not a TTY), neither flag:** exit 64 (`UserError`)
  with stderr containing `"--resolution"` and `"jr issue resolutions"`. POST must NOT be
  called (verified via wiremock `expect(0)` on the transition endpoint).

- **Interactive (TTY, `--no-input` absent), neither flag:** prompt via `dialoguer::Select`
  listing resolution names (from `allowedValues` when available, else `load_resolutions`
  instance-global cache). No `"(none — no resolution)"` option is offered in the REQUIRED
  branch. On Ctrl+C / prompt failure → exit 130 (EC-3.2.013-5).

(traces to BC-3.2.013 Resolution-REQUIRED branch; EC-3.2.013-1, -3, -5)

---

### AC-004 — OPTIONAL branch: --resolution / --no-resolution / prompt behavior
(traces to BC-3.2.013 Resolution-OPTIONAL branch postconditions)

When `needs_resolution` is `true` AND the branch is OPTIONAL
(`fields.resolution.required == false` AND NOT `is_conditional`):

- **`--resolution <name>` provided:** same validation logic as REQUIRED branch; proceed
  with resolution set in body.

- **`--no-resolution` provided:** transition WITHOUT a `resolution` field in the body
  (body shape matches BC-3.2.012 — no `"fields"` key). Proceeds normally; exit 0.

- **Non-interactive (`--no-input` OR stdin not a TTY), neither flag:** exit 64 (`UserError`)
  with stderr containing `"must explicitly choose"` and BOTH `"--resolution"` and
  `"--no-resolution"` in the hint message.

- **Interactive (TTY, `--no-input` absent), neither flag:** prompt via `dialoguer::Select`
  listing resolution names PLUS a final `"(none — no resolution)"` option. Selecting
  `"(none — no resolution)"` proceeds without a resolution body field. On Ctrl+C → exit 130.

(traces to BC-3.2.013 Resolution-OPTIONAL branch; EC-3.2.013-2)

---

### AC-005 — `--no-resolution` flag: new flag on `issue move`; mutually exclusive with `--resolution`
(traces to BC-3.2.013 Flag constraints)

`src/cli/mod.rs` (or the `issue move` subcommand definition) gains a new Clap flag:

```rust
#[arg(long, conflicts_with = "resolution")]
pub no_resolution: bool,
```

`--resolution` and `--no-resolution` are declared as mutually exclusive via `conflicts_with`.
Passing both on the same invocation → Clap exits with a usage error BEFORE any HTTP call
(exit code 2 per Clap convention — no custom error needed).

`--no-resolution` has no effect when the enforcement gate does not fire:
- On non-done-category transitions: silently ignored (EC-3.2.013-7).
- On the conservative gate fallback (no `statusCategory`): silently ignored.

`--no-resolution` is ONLY meaningful on single-key `handle_move`. The bulk path does not
receive the flag's enforcement semantics (EC-3.2.013-8).

A SURFACE row entry for `--no-resolution` on `issue move` is added to
`tests/e2e_cli_surface_guard.rs`.

(traces to BC-3.2.013 Flag constraints; EC-3.2.013-7, -8)

---

### AC-006 — BC-3.2.009 reactive backstop retained; bulk path excluded from proactive enforcement
(traces to BC-3.2.009 postcondition; BC-3.2.013 scope constraint)

The existing reactive 400 handler in `workflow.rs` (lines ~392–408) is NOT removed. It is
preserved as a backstop for:
- Workflows that enforce resolution via a server-side validator not reflected in the
  transition screen's `fields` map (conservative gate passes, POST fires, API returns 400).
- Any future Atlassian behavioral changes.

Bulk `issue move` (multi-key positional or `--to` set) is explicitly excluded from
proactive enforcement (EC-3.2.013-8). The bulk path retains only the reactive BC-3.2.009
error path. A wiremock test asserts: given a multi-key bulk move to a done-category target
with a resolution-offering transition, the proactive gate does NOT fire and the bulk POST
is attempted.

(traces to BC-3.2.009 postcondition — reactive 400 handler retained; BC-3.2.013 scope;
EC-3.2.013-8; ADR-0015 §6)

---

### AC-007 — Unit test coverage (wiremock); E2E inversion from S-JSM-E2E-3
(traces to BC-3.2.013 Test vectors table; BC-2.3.036 behavior — read-back)

**Wiremock unit/integration tests** in `tests/issue_move_resolution_enforce.rs` (new file):

| Test name | Scenario | Expected |
|-----------|----------|----------|
| `test_move_refuses_required_done_category_no_input` | done-cat + `required=true` + `--no-input`, no flag | exit 64 + stderr contains `"--resolution"` + POST NOT called |
| `test_move_refuses_required_done_category_with_no_resolution_flag` | done-cat + `required=true` + `--no-resolution` | exit 64 + stderr contains `"cannot be used"` |
| `test_move_proceeds_required_with_resolution_flag` | done-cat + `required=true` + `--resolution Done` + `allowedValues` present | exit 0 + POST body contains `resolution.name="Done"` |
| `test_move_refuses_optional_done_category_no_input` | done-cat + `required=false` + `--no-input`, no flag | exit 64 + stderr contains `"must explicitly choose"` and `"--no-resolution"` |
| `test_move_proceeds_optional_with_no_resolution_flag` | done-cat + `required=false` + `--no-resolution --no-input` | exit 0 + POST body has no `fields` key |
| `test_move_proceeds_optional_with_resolution_flag` | done-cat + `required=false` + `--resolution Done --no-input` | exit 0 + POST body contains `resolution.name="Done"` |
| `test_move_isconditional_treated_as_required` | done-cat + `isConditional=true` + no `resolution` in fields + `--no-input` | exit 64 + stderr contains `"--resolution"` |
| `test_move_skips_gate_when_no_status_category` | no `statusCategory` on `to` + `--no-input` | exit 0 + POST fired (conservative gate) |
| `test_move_skips_gate_when_not_done_category` | `statusCategory.key="indeterminate"` + `--no-input` | exit 0 + POST fired |
| `test_move_skips_gate_when_fields_absent` | done-cat + no `fields` key + `--no-input` | exit 0 + POST fired (conservative gate) |
| `test_move_mutual_exclusion_both_flags` | `--resolution Done --no-resolution` | exit 2 (clap error before any HTTP) |
| `test_bulk_move_excludes_proactive_enforcement` | multi-key bulk done-cat target | no enforcement; bulk POST attempted |
| `test_transitions_json_output_unchanged_after_fields_added` | serialize `Transition` with populated `fields` | JSON does NOT contain `fields` or `isConditional` keys |

**E2E inversion** in `tests/e2e_live.rs` (carrying forward S-JSM-E2E-3 work):

The `test_e2e_jsm_resolution_enforcement` function's bypass-demo branch (step 6 in S-JSM-E2E-3
Scenario 8) is INVERTED from a dual-path observation to a single enforcement assertion:

```rust
// OLD (S-JSM-E2E-3 bypass-demo):
// Branch A: exit 0 → assert resolution.is_null()
// Branch B: exit != 0 → assert stderr.contains("--resolution")

// NEW (S-JSM-RESOLUTION-REQUIRED enforcement assertion):
let output = e2e_cmd(&["issue", "move", &key_bypass, &transition_name, "--no-input"], &h);
assert_eq!(output.status.code(), Some(64),
    "BC-3.2.013: proactive gate must exit 64 for no-resolution done-category move");
assert!(String::from_utf8_lossy(&output.stderr).contains("--resolution"),
    "BC-3.2.013: stderr must contain '--resolution' hint");
eprintln!("[INFO] ENFORCE: BC-3.2.013 proactive gate fired — jr refused no-resolution done-category move");
```

The positive path (step 5: `--resolution <R>` → exit 0 → read-back `fields.resolution.name == R`),
`jsm_discover_resolution` helper, `jsm_self_close` teardown (with `--resolution` discovery),
and all SURFACE rows from S-JSM-E2E-3 are carried forward unchanged.

(traces to BC-3.2.013 test vectors; BC-2.3.036 postcondition — read-back; ADR-0015 §7 consequence)

---

### AC-008 — BREAKING CHANGE: CHANGELOG entry; CLAUDE.md gotcha; migration note
(traces to BC-3.2.013 Breaking change clause)

**CHANGELOG.md** gains an entry under `[Unreleased] — Breaking Changes`:

```markdown
### Breaking Changes

- `jr issue move KEY <done-status>` now enforces a resolution when the target transition
  is done-category and offers a resolution field (or has `isConditional=true`). Previously
  this succeeded silently with `resolution=null`. In non-interactive mode (`--no-input` or
  no TTY), the command exits 64 unless `--resolution <name>` or `--no-resolution` is
  supplied. Interactive mode prompts for a resolution selection. Scripts that rely on the
  silent bypass must add `--resolution <name>` (recommended) or `--no-resolution` (explicit
  opt-out for intentional no-resolution closes). The `--no-resolution` flag is mutually
  exclusive with `--resolution`.

### Added

- `--no-resolution` flag on `jr issue move` — explicit opt-out from proactive resolution
  enforcement. Use when closing issues on done-category transitions where a null resolution
  is genuinely intentional (e.g., "Won't Do" automation paths). Mutually exclusive with
  `--resolution`. No effect on non-done-category transitions.
- `jr issue move` now uses `GET .../transitions?expand=transitions.fields` to detect
  whether the target transition offers a resolution field, enabling proactive enforcement
  with no additional round-trip (replaces plain `GET .../transitions` in `handle_move`).
  `jr issue transitions` read command is unchanged; `--output json` output is byte-identical.
```

**CLAUDE.md** gains a gotcha entry in the Gotchas section:

```
- **`jr issue move` proactive resolution enforcement (BC-3.2.013):** As of this feature,
  `jr issue move KEY <done-status>` exits 64 in non-interactive mode when the target
  transition is done-category AND offers a resolution field (or `isConditional=true`).
  Use `--resolution <name>` to set a resolution, or `--no-resolution` to explicitly opt
  out (intentional null-resolution closes). Bulk `jr issue move` (multi-key) is EXCLUDED
  from proactive enforcement; only single-key move is affected. `jr issue transitions
  --output json` output is byte-identical to pre-feature (enforced by `skip_serializing`
  on `Transition.fields` and `Transition.is_conditional`). ADR-0015.
```

(traces to BC-3.2.013 Breaking change clause; ADR-0015 §7)

---

## Architecture Mapping

| Component | File | Type | Change |
|-----------|------|------|--------|
| `get_transitions_with_fields` | `src/api/jira/issues.rs` | Effectful (HTTP GET) | NEW method on `JiraClient`; calls `?expand=transitions.fields` |
| `Transition.fields` | `src/types/jira/issue.rs` | Pure (type) | NEW field with `#[serde(default, skip_serializing)]` |
| `Transition.is_conditional` | `src/types/jira/issue.rs` | Pure (type) | NEW field with `#[serde(rename="isConditional", default, skip_serializing)]` |
| `handle_move` enforcement block | `src/cli/issue/workflow.rs` | Mixed | Replaces `get_transitions` call with `get_transitions_with_fields`; inserts detection + enforcement block before transition POST |
| `--no-resolution` flag | `src/cli/mod.rs` | Pure (flag parse) | NEW Clap flag with `conflicts_with = "resolution"` |
| `tests/issue_move_resolution_enforce.rs` | `tests/` | Pure (test) | NEW integration test file (13 test vectors) |
| `tests/e2e_live.rs` | `tests/` | Effectful (live) | MODIFY: invert bypass-demo; carry forward positive path + helpers |
| `tests/e2e_cli_surface_guard.rs` | `tests/` | Pure (guard) | MODIFY: add `--no-resolution` to issue move SURFACE row |
| `CHANGELOG.md` | project root | Docs | MODIFY: Breaking Changes + Added entries |
| `CLAUDE.md` | project root | Docs | MODIFY: new gotcha entry |

**Architecture compliance:** `get_transitions_with_fields` must NOT replace `get_transitions`
as the method called by `handle_transitions` (the `jr issue transitions` read command). The
two methods are deliberately distinct: `handle_move` uses the expand variant; `handle_transitions`
uses the plain variant. This enforces the principle of least surprise per call-site intent
(ADR-0015 §4).

**Forbidden dependency:** The enforcement detection logic (`is_done_category`, `offers_resolution`,
`is_conditional`, `needs_resolution`) MUST reside in `workflow.rs`, NOT in
`src/api/jira/issues.rs`. The API layer returns data; the CLI layer enforces policy.

---

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-3.2.013-1 | BC-3.2.013 | `isConditional=true` with no `resolution` key in `fields` | Treated as REQUIRED branch — exit 64 / prompt with no "(none)" option |
| EC-3.2.013-2 | BC-3.2.013 | `fields.resolution.allowedValues` is empty or absent | Fall back to `load_resolutions(client, false)` instance-global list; validation skipped |
| EC-3.2.013-3 | BC-3.2.013 | `--resolution` value not in `allowedValues` (when present) | Exit 64 listing allowed values — same style as other name-resolution failures |
| EC-3.2.013-4 | BC-3.2.013 | done-cat `statusCategory.key="done"` but `fields` map entirely absent | Conservative gate fires; enforcement skipped; BC-3.2.009 backstop applies |
| EC-3.2.013-5 | BC-3.2.013 | Interactive prompt aborted via Ctrl+C | Exit 130 (`Interrupted`) |
| EC-3.2.013-6 | BC-3.2.013 | `--resolution` supplied on non-done-category transition | Gate does not fire; `--resolution` forwarded in body per BC-3.2.011 (unchanged behavior) |
| EC-3.2.013-7 | BC-3.2.013 | `--no-resolution` supplied on non-done-category transition | Flag silently ignored; transition body has no resolution field (BC-3.2.012) |
| EC-3.2.013-8 | BC-3.2.013 | Bulk `issue move` (multi-key) with done-category target | Proactive gate NOT invoked; bulk POST attempted; BC-3.2.009 reactive per-key error if API rejects |
| mutual-exclusion | ADR-0015 §7 | Both `--resolution` and `--no-resolution` supplied | Clap exits 2 before any HTTP call |
| idempotency | BC-3.2.001 | Already in target status | Idempotency check fires BEFORE enforcement gate; exits 0 without prompting |

---

## Tasks

### Red Gate (TDD — failing tests first)

- [ ] Read `src/types/jira/issue.rs` — locate `Transition` struct; confirm current fields (`id`, `name`, `to`)
- [ ] Read `src/api/jira/issues.rs` — locate `get_transitions`; understand `TransitionsResponse` type
- [ ] Read `src/cli/issue/workflow.rs` — locate `handle_move`; identify insertion point (after transition resolution, before POST); locate BC-3.2.009 reactive handler (lines ~392–408)
- [ ] Read `src/cli/mod.rs` — locate `issue move` subcommand Clap definition; confirm `--resolution` flag location
- [ ] Read `tests/issue_resolution.rs` (if exists) — understand existing resolution test fixtures
- [ ] **Write failing tests first** in `tests/issue_move_resolution_enforce.rs`:
  - `test_move_refuses_required_done_category_no_input` (expect exit 64; POST expect(0))
  - `test_move_proceeds_required_with_resolution_flag` (expect exit 0; POST body check)
  - `test_move_refuses_optional_done_category_no_input` (expect exit 64; different message)
  - `test_move_proceeds_optional_with_no_resolution_flag` (expect exit 0; no fields in body)
  - `test_move_skips_gate_when_no_status_category` (expect exit 0; POST fired)
  - `test_move_skips_gate_when_not_done_category` (expect exit 0; POST fired)
  - `test_move_isconditional_treated_as_required` (expect exit 64)
  - `test_move_mutual_exclusion_both_flags` (expect exit 2)
  - `test_transitions_json_output_unchanged_after_fields_added` (serialize check)
- [ ] Run `cargo test --test issue_move_resolution_enforce` — ALL new tests must FAIL (Red Gate confirmed)
- [ ] (Optional) `test_move_skips_gate_when_fields_absent`, `test_bulk_move_excludes_proactive_enforcement` — write and confirm RED

### Implementation (Green Gate)

- [ ] Edit `src/types/jira/issue.rs`: add `fields: Option<HashMap<String, serde_json::Value>>` and `is_conditional: Option<bool>` to `Transition` with `#[serde(default, skip_serializing)]`
- [ ] Edit `src/api/jira/issues.rs`: add `get_transitions_with_fields(key: &str) -> Result<TransitionsResponse>` calling `?expand=transitions.fields`
- [ ] Edit `src/cli/mod.rs`: add `--no-resolution` flag to `issue move` Clap definition with `conflicts_with = "resolution"`
- [ ] Edit `src/cli/issue/workflow.rs`:
  - Replace `get_transitions(key)` call in `handle_move` with `get_transitions_with_fields(key)`
  - After transition resolution, insert: `is_done_category`, `offers_resolution`, `is_conditional`, `needs_resolution` detection block
  - Insert REQUIRED branch enforcement (non-interactive → exit 64; `--no-resolution` → exit 64; interactive → `dialoguer::Select` without "(none)")
  - Insert OPTIONAL branch enforcement (non-interactive → exit 64; `--no-resolution` → proceed sans fields; interactive → `dialoguer::Select` with "(none)" option)
  - Verify BC-3.2.009 reactive handler remains untouched
- [ ] Run `cargo test --test issue_move_resolution_enforce` — ALL tests must PASS (Green Gate)
- [ ] Run `cargo test --lib` — no regressions
- [ ] Run `cargo test --test '*'` — no regressions

### E2E Inversion (carry forward S-JSM-E2E-3 work)

- [ ] Rename worktree branch: `test/jsm-e2e-resolution` → `feat/jsm-resolution-required`
- [ ] In `tests/e2e_live.rs`: invert bypass-demo branch of `test_e2e_jsm_resolution_enforcement` per AC-007 — replace dual-path with single `--no-input` → assert exit 64 + stderr contains `"--resolution"`; update log from `[INFO] BYPASS` to `[INFO] ENFORCE: BC-3.2.013 proactive gate fired`
- [ ] Verify positive path, `jsm_discover_resolution`, `jsm_self_close` teardown are unchanged
- [ ] In `tests/e2e_cli_surface_guard.rs`: add `"--no-resolution"` to `issue move` SURFACE row (in addition to `"--resolution"` added by S-JSM-E2E-3)
- [ ] Run `cargo test --test e2e_cli_surface_guard` — must exit 0

### Documentation and Quality Gates

- [ ] Edit `CHANGELOG.md`: add Breaking Changes + Added entries per AC-008
- [ ] Edit `CLAUDE.md`: add proactive enforcement gotcha entry per AC-008
- [ ] Run `cargo clippy --all-targets -- -D warnings` — zero warnings (includes `conflicts_with` and new fields)
- [ ] Run `cargo fmt --all -- --check` — zero format drift
- [ ] Run `bash scripts/check-spec-counts.sh` — exit 0 (BC counts unchanged)
- [ ] Run `bash scripts/check-bc-cumulative-counts.sh` — exit 0 (BC-INDEX unchanged)
- [ ] Run `bash scripts/check-bc-no-numeric-test-counts.sh` — exit 0 (no numeric test counts in BC bodies)
- [ ] Commit: `feat(issue-move): proactive resolution enforcement on done-category transitions (BC-3.2.013, ADR-0015) (S-JSM-RESOLUTION-REQUIRED)`

---

## Previous Story Intelligence

**Predecessor: S-JSM-E2E-3 (SUPERSEDED by this story)** — wrote the positive-path
`test_e2e_jsm_resolution_enforcement` test (move WITH `--resolution` → read-back asserts
`fields.resolution.name == R`), `jsm_discover_resolution` helper, improved `jsm_self_close`
with `--resolution` discovery, and dual-path bypass-demo. This story carries all of that
forward and INVERTS the bypass-demo into a hard enforcement assertion. The worktree
(`.worktrees/S-JSM-E2E-3`) and its branch are reused — no new worktree needed.

**Predecessor: S-JSM-E2E-2 (ready, F3 complete 2026-06-02)** — delivered dynamic
`statusCategory==done` transition discovery in `jsm_self_close`. This story depends on that
being deployed first (hence `depends_on: [S-JSM-E2E-2]`). The category-key-not-status-name
principle (`"done"` not `"Done"`) is already established; this story uses the same pattern
for the proactive enforcement gate.

**S-396 lesson (`issue edit --field`):** The `editmeta` round-trip pattern for field
validation was thoroughly adversary-reviewed. The resolution `allowedValues` validation
in this story follows the same idiom: resolve against the transition-specific list first,
fall back to the instance-global list if absent. The `resolve_resolution_by_name` partial-
match helper is already present (from the base `--resolution` flag work) — this story's
interactive prompt does NOT use `partial_match` (user selects from a pre-listed set via
`dialoguer::Select`), which was a key design decision to avoid ambiguity.

**S-427 (`--label` mutual exclusion lesson):** The `conflicts_with` Clap attribute was
established as the canonical mutual-exclusion mechanism. `--no-resolution` and `--resolution`
use the same approach. Clap's exit code on conflict is 2, not 64 — this distinction matters
for tests (AC-007 mutual-exclusion test must assert exit 2, not 64).

**ADR-0015 key constraint for implementers:** `get_transitions_with_fields` and
`get_transitions` are DISTINCT methods with DISTINCT call sites. Do NOT modify
`handle_transitions` (the `jr issue transitions` read command) to use the expand variant.
The read-command-stability contract pins the output byte-for-byte via `skip_serializing` —
the CI test `test_transitions_json_output_unchanged_after_fields_added` is the mechanical
enforcement of this contract. If this test is skipped or weakened, the ADR constraint is
violated.

---

## Architecture Compliance Rules

1. **`get_transitions` in `handle_transitions` MUST NOT change.** The read command
   (`jr issue transitions`) must continue to call `get_transitions` (no expand). Only
   `handle_move` uses `get_transitions_with_fields`. Mixing the two methods at either
   call site is a correctness violation. Enforced by `test_transitions_json_output_unchanged_after_fields_added`.

2. **`#[serde(skip_serializing)]` on `Transition.fields` and `Transition.is_conditional`
   is LOAD-BEARING.** These annotations must not be removed or changed to `skip_serializing_if`.
   If a future `Transition` field IS intended to appear in `jr issue transitions --output json`,
   it must NOT carry `skip_serializing` — and that intent must be explicit in the PR. See
   ADR-0015 §3 future-extension rule.

3. **Enforcement detection logic belongs in `workflow.rs`, not `issues.rs`.** The API layer
   returns data; the CLI layer enforces policy. Do not push the `needs_resolution` decision
   tree into `get_transitions_with_fields` or any API-layer function.

4. **Idempotency check MUST run before enforcement gate.** The existing BC-3.2.001 /
   BC-3.2.002 idempotency check (already in target status → exit 0) must execute before
   the `needs_resolution` detection. This preserves backward-compatible behavior: a no-op
   move never prompts for a resolution.

5. **BC-3.2.009 reactive handler MUST remain.** Do NOT remove the 400 "resolution required"
   handler. It is the backstop for validator-enforced workflows and future Atlassian
   behavioral changes. The proactive gate is first-line; the reactive handler is last-resort.

6. **Single-key scope enforcement.** The `needs_resolution` detection and enforcement block
   must be guarded to only execute in `handle_move` (single-key path), NOT `handle_move_bulk`.
   If `handle_move_bulk` accidentally calls `get_transitions_with_fields` or the enforcement
   block, it is a scope violation per ADR-0015 §6.

7. **Resolution body shape.** Resolution is always set as an object (`{resolution: {name:
   "<name>"}}`), never as a bare string. This matches the Atlassian API requirement confirmed
   by the OpenAPI FieldMetadata schema (API validation Claim 1) and BC-3.2.011.

8. **No new `Cargo.toml` runtime dependencies.** `dialoguer` is already a dependency for
   existing interactive prompts. `HashMap` from `std::collections` is already available.
   `serde_json::Value` is already a dependency. No new crates should be added.

---

## Library & Framework Requirements

| Crate/Tool | Version (already in Cargo.toml) | Usage in this story |
|------------|----------------------------------|---------------------|
| `clap` | existing | `#[arg(long, conflicts_with = "resolution")] no_resolution: bool` |
| `dialoguer` | existing | `dialoguer::Select` for interactive resolution prompt (REQUIRED and OPTIONAL branches) |
| `serde` | existing | `#[serde(default, skip_serializing)]` on `Transition.fields`; `#[serde(rename = "isConditional", default, skip_serializing)]` on `Transition.is_conditional` |
| `serde_json` | existing | `serde_json::Value` as the map value type for `Transition.fields: Option<HashMap<String, serde_json::Value>>` |
| `wiremock` | existing (dev-dep) | Mock `GET .../transitions?expand=transitions.fields` endpoint for all unit/integration tests |
| `std::collections::HashMap` | stdlib | `Transition.fields: Option<HashMap<String, serde_json::Value>>` |

**No new runtime or dev dependencies.** Version pins are from the existing `Cargo.lock`.
Do NOT upgrade any crate version as part of this story.

---

## File Structure Requirements

| File | Action | Notes |
|------|--------|-------|
| `src/types/jira/issue.rs` | MODIFY | Add `fields` + `is_conditional` to `Transition` struct with `skip_serializing` |
| `src/api/jira/issues.rs` | MODIFY | Add `get_transitions_with_fields` method |
| `src/cli/mod.rs` | MODIFY | Add `--no-resolution` flag to issue move Clap definition with `conflicts_with = "resolution"` |
| `src/cli/issue/workflow.rs` | MODIFY | Replace `get_transitions` with `get_transitions_with_fields` in `handle_move`; insert detection + enforcement block; pass `no_resolution: bool` through to enforcement |
| `tests/issue_move_resolution_enforce.rs` | CREATE | New wiremock integration test file — all 13 test vectors from AC-007 |
| `tests/e2e_live.rs` | MODIFY | Invert bypass-demo branch; carry forward positive path + `jsm_discover_resolution` + teardown |
| `tests/e2e_cli_surface_guard.rs` | MODIFY | Add `--no-resolution` to issue move SURFACE row |
| `CHANGELOG.md` | MODIFY | Breaking Changes + Added entries per AC-008 |
| `CLAUDE.md` | MODIFY | New gotcha entry (proactive enforcement + `--no-resolution` flag) |

**Files confirmed NOT changed:**
- `.factory/specs/prd/bc-*.md` — BC authorship complete (PO did this in F2)
- `BC-INDEX.md`, `CANONICAL-COUNTS.md` — counts already updated by PO
- `.github/workflows/` — no CI changes needed
- `Cargo.toml`, `Cargo.lock`, `deny.toml` — no new dependencies

---

## Token Budget Estimate

| Item | Tokens (approx) |
|------|----------------|
| This story file | ~10 k |
| `src/cli/issue/workflow.rs` (full file — ~500+ LOC; must read fully for insertion point + idempotency check location + BC-3.2.009 handler) | ~8 k |
| `src/types/jira/issue.rs` (Transition struct; ~50 LOC relevant) | ~2 k |
| `src/api/jira/issues.rs` (get_transitions signature + TransitionsResponse; ~80 LOC relevant) | ~2 k |
| `src/cli/mod.rs` (issue move Clap definition; ~60 LOC relevant) | ~2 k |
| BC files (BC-3.2.013 primary + BC-3.2.009/010/011/BC-2.3.036 — read-only; ~5 BCs) | ~4 k |
| `docs/adr/0015-proactive-resolution-enforcement.md` (key design decisions) | ~3 k |
| `tests/issue_move_resolution_enforce.rs` (new file; ~300 LOC estimated) | ~5 k |
| `tests/e2e_live.rs` relevant sections (~jsm_discover_resolution + test_e2e_jsm_resolution_enforcement + jsm_self_close extension; ~200 LOC) | ~4 k |
| `tests/e2e_cli_surface_guard.rs` (~20 LOC relevant) | ~1 k |
| Tool outputs (`cargo test`, `cargo clippy`, `grep`, script checks) | ~3 k |
| **Total** | **~44 k** |

Well within a single-agent context window (~200 k). No split required.

**LOC delta estimate:**
- `src/types/jira/issue.rs` +~8 LOC (two new fields)
- `src/api/jira/issues.rs` +~15 LOC (new method with rustdoc)
- `src/cli/mod.rs` +~4 LOC (new flag)
- `src/cli/issue/workflow.rs` +~60 LOC (detection block + REQUIRED + OPTIONAL branches)
- `tests/issue_move_resolution_enforce.rs` +~300 LOC (new file; 13 tests)
- `tests/e2e_live.rs` +~10 LOC net (bypass-demo inversion; positive path unchanged)
- `tests/e2e_cli_surface_guard.rs` +~1 LOC
- `CHANGELOG.md` +~20 LOC
- `CLAUDE.md` +~12 LOC

Total estimated new LOC: ~430 LOC.
