# Delta Analysis — Resolution-Required Enforcement on Done-Category Transitions

**Feature:** `jr issue move` requires `--resolution` when transitioning to a done-category status that offers a resolution field
**Date:** 2026-06-03
**Mode:** BROWNFIELD / Feature Mode (F1–F7)
**Base ref:** develop @ 176215e
**Replaces/folds:** S-JSM-E2E-3 (held test-only story, now inverted to enforcement assertion)

---

## Classification

| Dimension | Value |
|-----------|-------|
| Feature type | SRC behavior change |
| Intent | enforcement / correctness |
| Trivial scope? | NO — new BC, new API call shape, UX fork (prompt vs error), existing test breakage |
| BC delta | ONE new BC (BC-3.2.013, proposed) |
| src/ delta | NON-ZERO — types, API client, workflow handler |
| Architecture change | YES — new method on `JiraClient`; `Transition` type gains optional `fields` map; new read-command-stability constraint |
| ADR warranted | YES — one new ADR (proactive expand-based enforcement; BC read-command stability decision) |

---

## Section A: Detection Mechanism

### A.1 Current State

`get_transitions` (`src/api/client.rs::get_transitions`) calls:

```
GET /rest/api/3/issue/{key}/transitions
```

with NO query parameters. The `Transition` struct in `src/types/jira/issue.rs` is:

```rust
pub struct Transition {
    pub id: String,
    pub name: String,
    pub to: Option<Status>,
}
```

`Status` already carries `status_category: Option<StatusCategory>` which has a `key: String` field. So the `to.statusCategory.key == "done"` check is ALREADY supported once `to` is populated. The gap is that the vanilla GET does not return the `fields` map on each transition — that requires `?expand=transitions.fields`.

### A.2 Atlassian API Shape for Expanded Transitions

`GET /rest/api/3/issue/{key}/transitions?expand=transitions.fields`

Returns each transition with an additional `fields` map (field ID → field metadata):

```json
{
  "transitions": [
    {
      "id": "31",
      "name": "Done",
      "to": { "name": "Done", "statusCategory": { "key": "done", "name": "Done" } },
      "fields": {
        "resolution": {
          "required": false,
          "name": "Resolution",
          "schema": { "type": "resolution", "system": "resolution" },
          "allowedValues": [ { "name": "Done", "id": "10000" }, ... ]
        }
      }
    }
  ]
}
```

When the transition has no resolution field on its screen, `"resolution"` is absent from `fields`. When the transition is not a done-category transition, `to.statusCategory.key` will be `"new"` or `"indeterminate"`. The enforcement trigger condition is:

```
to.statusCategory.key == "done"  AND  transition.fields contains key "resolution"
```

This is the EJ "API-bypass" case: the API marks resolution as `required: false` on the transition screen but the UI enforces it. jr proactively enforces what the UI enforces.

### A.3 Recommended Approach: New Method, Not Mutating `get_transitions`

**Decision: add `get_transitions_with_fields(key) -> Result<TransitionsWithFieldsResponse>`** as a new method on `JiraClient`. Do NOT change `get_transitions`.

**Justification:**

The `jr issue transitions` read command (`handle_transitions` in `workflow.rs`) calls `get_transitions` and serializes `&resp.transitions` via `print_output`. The `Transition` struct is serialized directly to JSON for `--output json`. If `fields` were added as a `pub fields: Option<HashMap<String, Value>>` on the shared `Transition` struct without `#[serde(skip_serializing)]`, the JSON output of `jr issue transitions --output json` would change — a BC break to BC-3.2's read surface.

Two safe options:

**Option 1 (preferred): `#[serde(skip_serializing)]` on `Transition.fields`**

Add to `Transition`:
```rust
#[serde(default, skip_serializing)]
pub fields: Option<std::collections::HashMap<String, serde_json::Value>>,
```

`skip_serializing` means the field is present for deserialization (populated when the API returns it) but is never emitted in JSON output. The `jr issue transitions --output json` output is IDENTICAL to today. No BC break. `get_transitions` and `get_transitions_with_fields` can share the same `Transition` struct — the former URL returns transitions without `fields` populated (Atlassian simply omits the key, serde defaults to `None`); the latter URL returns transitions with `fields` populated.

**Option 2: Separate `TransitionWithFields` type**

Parallel struct `TransitionWithFields { id, name, to, fields }` and a `TransitionsWithFieldsResponse`. More type-safe but introduces struct duplication for a single field difference.

**Recommendation: Option 1** — `#[serde(skip_serializing)]` on `Transition.fields`. Single struct, zero BC surface change, cleanest implementation.

**Method signature:**

```rust
/// Get available transitions for an issue, including field metadata per
/// transition (via `?expand=transitions.fields`). Used by `handle_move`
/// to detect whether a done-category transition offers a resolution field,
/// enabling proactive enforcement before the API call (BC-3.2.013).
///
/// The returned `TransitionsResponse` uses the same `Transition` type as
/// `get_transitions`. The `fields` map is populated when present; `None`
/// when Atlassian omits it (non-expanding endpoint or transition has no
/// screen fields). `jr issue transitions` read command uses `get_transitions`
/// (no expand) and never serializes `fields` due to `skip_serializing`.
pub async fn get_transitions_with_fields(&self, key: &str) -> Result<TransitionsResponse> {
    let path = format!(
        "/rest/api/3/issue/{}/transitions?expand=transitions.fields",
        urlencoding::encode(key)
    );
    self.get(&path).await
}
```

`handle_move` calls `get_transitions_with_fields`; `handle_transitions` (read command) keeps calling `get_transitions`. The distinction is invisible to the user.

### A.4 Detection Logic

After calling `get_transitions_with_fields` and resolving the selected transition via the existing match logic, insert:

```
let is_done_category = selected_transition.to
    .as_ref()
    .and_then(|s| s.status_category.as_ref())
    .is_some_and(|sc| sc.key == "done");

let offers_resolution_field = selected_transition.fields
    .as_ref()
    .is_some_and(|f| f.contains_key("resolution"));

let needs_resolution = is_done_category && offers_resolution_field;
```

This condition is the enforcement trigger. Note: if the API does not return `statusCategory` on the transition's `to` field (e.g., the plain `GET` was used or the data is incomplete), `is_done_category` is `false` and the enforcement is skipped silently — a conservative, backward-compatible fallback.

---

## Section B: Validation Flow in `handle_move`

### B.1 Insertion Point

The check is inserted AFTER the selected transition is resolved (the existing `partial_match` dispatch block) and BEFORE `client.transition_issue(...)` is called. Specifically, after the `resolution_fields` block that handles the existing `--resolution` flag.

Current flow (simplified):
```
1. get_transitions → resolve selected_transition
2. get_issue → idempotency check
3. resolve --resolution if provided
4. transition_issue(...)
5. error handler: 400 "resolution required" → hint (BC-3.2.009)
```

New flow:
```
1. get_transitions_with_fields → resolve selected_transition  [CHANGE: new method]
2. get_issue → idempotency check  [UNCHANGED]
3. detect needs_resolution  [NEW]
4a. if needs_resolution && --resolution not provided:
      if no_input → exit 64 + hint (NEW BC-3.2.013 path)
      else → prompt for resolution interactively (NEW)
4b. resolve --resolution if provided (existing path, unchanged)
5. transition_issue(...)  [UNCHANGED]
6. error handler: 400 "resolution required" → hint (BC-3.2.009)  [UNCHANGED, backstop]
```

### B.2 No-Input Detection

`handle_move` already receives `no_input: bool` as a parameter (line 144 of `workflow.rs`). No new plumbing required. The check is:

```rust
if needs_resolution && resolution.is_none() {
    if no_input {
        let to_label = selected_transition.to.as_ref()
            .map(|s| s.name.as_str())
            .unwrap_or(&selected_transition.name);
        return Err(JrError::UserError(format!(
            "The \"{to_label}\" transition requires a resolution.\n\n\
             Try:\n    jr issue move {key} {to_label} --resolution <name>\n\n\
             Run `jr issue resolutions` to see available values."
        )).into());
    }
    // Interactive path: prompt for resolution.
    let resolutions = load_resolutions(client, false).await?;
    let resolution_names: Vec<String> = resolutions.iter().map(|r| r.name.clone()).collect();
    let selection = dialoguer::Select::new()
        .with_prompt("Select resolution")
        .items(&resolution_names)
        .interact()
        .context("failed to prompt for resolution")?;
    let chosen = &resolutions[selection];
    // Replace the None `resolution` with the chosen one for the fields block below.
    // (Implementation detail: refactor the resolution_fields block to accept
    //  either the flag value or the interactively chosen Resolution.)
}
```

The interactive prompt uses `dialoguer::Select` consistent with the existing team/user disambiguation prompts in `helpers.rs`. The resolution list comes from `load_resolutions(client, false)` — the same call made when `--resolution` is provided, with the same 7-day cache. `resolve_resolution_by_name` is NOT needed in the prompt path; the `Select` lets the user pick from a pre-listed set (no partial-match ambiguity).

### B.3 BC-3.2.009 Backstop Preserved

The existing reactive 400 handler (lines 392–408 of `workflow.rs`) is NOT removed. It remains as a backstop for workflows that:
- Enforce resolution at the API level (the `fields` map was absent or `statusCategory` was missing, so proactive detection fired false and the transition POST was attempted).
- Any future Atlassian behavior changes.

The proactive check (BC-3.2.013) is a first-line defense; the reactive check (BC-3.2.009) is the last-resort fallback. Both coexist.

---

## Section C: Backward-Compatibility / Breaking Surface

### C.1 Affected Tests That Transition to Done Without `--resolution`

The following tests move an issue to a done-category status and mock a 204 success. After this change, if the mock transitions response includes `to.statusCategory.key == "done"` AND the transitions response includes a `fields.resolution` entry, the test will hit the new enforcement path BEFORE the POST and either prompt (interactive) or exit 64 (no-input).

**Scan results:**

| Test | File | Lines (approx) | Done target? | Has `statusCategory`? | Has expanded `fields`? | Impact |
|------|------|------|------|------|------|------|
| `test_move_dedup_same_transition_and_status_name` | `tests/issue_commands.rs` | ~1337 | YES (`"Done"`) | NO (fixture uses `transitions_response_with_status` which has `to.name` but no `statusCategory`) | NO | SAFE — no `statusCategory` in fixture → `is_done_category=false` → no enforcement |
| `test_move_by_transition_name` | `tests/issue_commands.rs` | ~1219 | NO (→ `"Completed"`) | NO | NO | SAFE |
| `test_move_by_status_name` | `tests/issue_commands.rs` | ~1278 | NO (→ `"Completed"`) | NO | NO | SAFE |
| `test_e2e_jsm_resolution_enforcement` (worktree) | `tests/e2e_live.rs` | ~2908 | YES | via `statusCategory.key == "done"` (live data) | live data | AFFECTED — see §C.2 |
| `issue_move_surfaces_resolution_required_hint` | `tests/issue_resolution.rs` | ~88 | YES (`"Done"`) | NO | NO | SAFE — no `statusCategory` in mock fixture |

**Key insight:** The existing mock fixtures for `transitions_response_with_status` do NOT include `statusCategory` on `to`. The new enforcement only fires when `to.statusCategory.key == "done"`. All existing wiremock-based tests use the minimal fixture (`{id, name, to: {name}}` shape) which omits `statusCategory`. They will NOT be affected by the new enforcement path.

This means **zero existing integration tests need modification** for the non-E2E suite, because the enforcement gate is simply never triggered by the existing mock fixtures' data shape.

### C.2 S-JSM-E2E-3 Worktree — Inversion of Bypass Demo

The `test_e2e_jsm_resolution_enforcement` function in the E2E worktree (`.worktrees/S-JSM-E2E-3/tests/e2e_live.rs`) currently has a "BYPASS-DEMO" branch (step 6) that accepts exit 0 as Branch A (API bypass, resolution=null) without asserting enforcement. After this feature ships:

- **Branch A (API bypass)** — exit 0 without `--resolution` — will NO LONGER OCCUR if `jr` is built with the new enforcement. The move will be intercepted at the proactive check. If `no_input` is set, exit 64. If interactive, a prompt will fire.
- **Branch B (API enforcement)** — already tests the hint path.

The worktree's bypass demo must be INVERTED: the no-resolution move (`--no-input`) should now ASSERT exit 64 + `"--resolution"` hint in stderr, not accept exit 0 as a valid branch. The `[INFO] BYPASS: …` log becomes `[INFO] ENFORCE: jr proactively blocked no-resolution move (BC-3.2.013)`.

The reuse plan: rename branch `test/jsm-e2e-resolution` → `feat/jsm-resolution-required`, carry forward:
- The `jsm_discover_resolution` helper (unchanged).
- The positive path assertions (move WITH `--resolution` → exit 0 + `fields.resolution.name == R`).
- The `jsm_self_close` resolution-discovery improvement.
- The SURFACE guard rows (`--resolution` on `issue move`, `issue resolutions`).

Modify:
- The bypass-demo branch: `jr issue move <key_bypass> <transition_name> --no-input` (add `--no-input`) → assert exit 64 + stderr contains `"--resolution"`.
- The bypass-demo observation log: change from "[INFO] BYPASS" to "[INFO] ENFORCE: BC-3.2.013 proactive gate fired".

### C.3 Latency Note

The `get_transitions_with_fields` call replaces `get_transitions` in `handle_move` — it is NOT an additional request. The URL changes from `.../transitions` to `.../transitions?expand=transitions.fields`. The response payload is larger (field metadata per transition) but the round-trip count is unchanged (still 1 GET before 1 POST). Latency impact is payload size only: typical transitions responses with field metadata are in the 2–10 KB range for normal workflows. Not a concern for interactive use.

### C.4 CHANGELOG Implication

This is a breaking change to `jr issue move` default behavior: previously, moving to a done-category status that offers a resolution field was silently permitted with no resolution. Now, it either prompts interactively or exits 64 (non-interactive). Users who run `jr issue move KEY Done` in scripts with `--no-input` on JSM/resolution-requiring workflows MUST add `--resolution <name>`. A CHANGELOG entry is required under `Breaking Changes` for the next minor version.

---

## Section D: New BC Proposal

### BC-3.2.013 (proposed)

**ID:** BC-3.2.013
**Section:** 3.2 Move / Transition
**Title:** `issue move` proactively enforces `--resolution` when target transition is done-category AND offers a resolution field

**Behavior:**

When `jr issue move KEY <target>` resolves to a transition where:
- `transition.to.statusCategory.key == "done"` (the target status is in the Done category), AND
- `transition.fields` contains the key `"resolution"` (the transition's screen offers a resolution field, populated via `?expand=transitions.fields`),

AND `--resolution` was NOT provided by the user:

- **Non-interactive** (`--no-input` OR stdin is not a TTY): exit 64 with stderr:
  ```
  error: the "<to_status_name>" transition requires a resolution.

  Try:
      jr issue move KEY <to_status_name> --resolution <name>

  Run `jr issue resolutions` to see available values.
  ```
- **Interactive** (TTY, not `--no-input`): prompt the user to select a resolution from the instance-global list via `dialoguer::Select`. On selection, proceed with the chosen resolution set atomically in the transition body (same body shape as BC-3.2.011). On Ctrl+C / prompt error, exit non-zero.

**Trigger condition:** `to.statusCategory.key == "done"` is the sole "done" signal — NOT the target status name. This is the stable Jira-wide machine constant regardless of workflow name.

**Conservative gate:** If `to.statusCategory` is absent from the API response (expanded fields not available, or transition has no `to` — defensive deserialization returns `None`), the enforcement is SKIPPED and the existing behavior (attempt transition, handle 400 reactively via BC-3.2.009) applies.

**Relationship to existing BCs:**
- BC-3.2.009 (reactive 400 handler): PRESERVED as backstop. BC-3.2.013 is proactive first-line; BC-3.2.009 catches residual cases.
- BC-3.2.011 (`--resolution` sets `fields.resolution` in body): UNCHANGED — the interactive prompt path in BC-3.2.013 also produces this same body shape.
- BC-3.2.012 (`transition_issue(None)` body has no `fields`): UNCHANGED — applies when transition is NOT done-category / does NOT offer resolution.
- BC-3.2.010 (`jr issue resolutions` cache): UNCHANGED — BC-3.2.013 calls `load_resolutions` internally.

**Confidence:** HIGH (well-scoped; backed by Atlassian API expand documentation and the existing `jsm_self_close` pattern which already relies on `to.statusCategory.key`)

**Source:** `tests/issue_resolution.rs` (new test), `tests/issue_commands.rs` (new test)

**Trace:** S-JSM-RESOLUTION-REQUIRED; supersedes bypass-demo branch of S-JSM-E2E-3

---

## Section E: ADR Recommendation

### Recommended: One New ADR — ADR-0015

**Title:** "Proactive resolution enforcement on done-category transitions"

**Covers:**

1. **Why proactive (expand-based) enforcement instead of reactive (400-based) only:**
   The reactive path (BC-3.2.009) fires only when Atlassian enforces at the API level. Many JSM workflows have resolution as a UI-only requirement — the API permits bypass and silently produces `resolution=null` issues, which breaks JQL `resolution IS EMPTY` filters, stops SLA timers from recording, and shows issues as open on the JSM portal. Proactive enforcement prevents this "silent limbo" state without requiring workflow-level API enforcement.

2. **Read-command stability decision (load-bearing):**
   Adding `fields: Option<HashMap<String, Value>>` to `Transition` with `#[serde(skip_serializing)]` keeps the `jr issue transitions --output json` output byte-for-byte identical to today while enabling `get_transitions_with_fields` to deserialize expanded field data. This is the governing constraint for the type design — any future extension of `Transition` that IS intended to be visible in the read-command output must explicitly remove `skip_serializing`.

3. **Single new API method (`get_transitions_with_fields`) rather than mutating `get_transitions`:**
   `get_transitions` is called by `handle_transitions` (read command) which explicitly must NOT add latency from expanded fields. Two distinct methods preserve the principle of least surprise per call-site intent.

4. **Scope limitation: single-key only:**
   The bulk transition path (`handle_move_bulk`) does NOT get proactive enforcement. The Atlassian bulk transitions endpoint does not support field metadata expansion in the same way, and bulk resolution enforcement adds significant complexity (one resolution for N keys across potentially multiple projects). This is explicitly out of scope. The bulk path retains BC-3.2.009-class reactive error (the endpoint will 400 per-key if needed). Document the limitation in the ADR.

This ADR is warranted because it crosses multiple concerns: a new Atlassian API capability (`expand`), a type-level stability contract (`skip_serializing`), and a breaking UX change (default behavior of a core command). It provides the canonical justification reference for F5 adversarial review and F6 hardening.

---

## Section F: Reuse Plan (E2E-3 Worktree)

**Worktree:** `/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-JSM-E2E-3`
**Current branch:** `test/jsm-e2e-resolution`
**Status:** 5 files modified (uncommitted), developing @ 176215e base

**Plan:**

1. **Rename branch** (in the worktree): `test/jsm-e2e-resolution` → `feat/jsm-resolution-required`. This signals the promotion from test-only to a feature-bearing story.

2. **Carry forward unchanged:**
   - `jsm_discover_resolution()` helper — already correct, used by both positive path and the inverted bypass demo.
   - `jsm_self_close()` with resolution discovery — already correct; adds `--resolution` to close moves.
   - Positive path assertions (step 5 in Scenario 8): `jr issue move KEY <T> --resolution R` → exit 0 → `fields.resolution.name == R`.
   - `issue resolutions` SURFACE row in `e2e_cli_surface_guard.rs`.
   - `--resolution` option in the `issue move` SURFACE row.
   - All doc updates to `docs/specs/jsm-e2e-coverage.md`, `docs/specs/e2e-live-jira-testing.md`, and CLAUDE.md.

3. **Invert bypass-demo (step 6):**
   - Remove the dual-branch (Branch A exit-0 / Branch B exit-non-0) from `test_e2e_jsm_resolution_enforcement`.
   - Replace with a single non-interactive path: `jr issue move <key_bypass> <transition_name> --no-input` (explicitly `--no-input`).
   - Assert: exit code == 64, stderr contains `"--resolution"`.
   - Emit: `eprintln!("[INFO] ENFORCE: BC-3.2.013 proactive gate fired — jr refused no-resolution done-category move")`
   - Preserve teardown: `jsm_self_close(&key_bypass, &h)` — because the bypass move will now FAIL before the POST, the issue remains in its pre-move status; `jsm_self_close` will successfully close it.

4. **New wiremock integration tests (F4 responsibility — listed here for F2/F3 handoff):**
   Required new tests in `tests/issue_resolution.rs` or a new file `tests/issue_move_resolution_enforce.rs`:
   - `test_move_refuses_done_category_with_resolution_field_no_input` — mock GET transitions with `?expand=transitions.fields` returning a done-category transition with `fields.resolution`; no `--resolution` flag; `--no-input`; assert exit 64 + `"--resolution"` in stderr; assert POST transitions was NOT called (expect(0)).
   - `test_move_proceeds_no_enforcement_when_no_status_category` — mock GET transitions WITHOUT `statusCategory` on `to`; assert no enforcement fires; assert 204 POST succeeds.
   - `test_move_proceeds_no_enforcement_when_not_done_category` — mock GET transitions with `statusCategory.key == "indeterminate"`; no enforcement; 204 POST succeeds.
   - `test_move_proceeds_no_enforcement_when_fields_absent` — done-category target, but `fields` map absent in the expanded response; no enforcement; 204 POST succeeds.
   - `test_move_interactive_prompts_resolution_when_done_category` — requires TTY simulation (may need `mockall` or a test-only bypass; assess in F4). If TTY simulation is impractical, cover this path with a unit test on the enforcement-detection logic only.

---

## F2/F4 Handoff Summary

**For Product Owner (F2):**
- Register BC-3.2.013 in `bc-3-issue-write.md` and `BC-INDEX.md` (section 3.2 now has 12 BCs; BC-3.2.013 is the 13th).
- Update `bc-3-issue-write.md` preamble BC count.
- Run `scripts/check-bc-cumulative-counts.sh` and `scripts/check-spec-counts.sh` after edits.
- Write feature spec at `docs/specs/issue-move-resolution-enforce.md` extending `docs/specs/issue-move-resolution.md` with the proactive enforcement design.
- Commission ADR-0015.

**For Architect:**
- Add `#[serde(default, skip_serializing)]` annotation decision to architecture notes (type-level stability contract).
- Add `get_transitions_with_fields` to the API surface in the ADR.

**For Story Writer (F3):**
- Story ID: S-JSM-RESOLUTION-REQUIRED
- Story: "As a Jira user moving an issue to a done-category status on a JSM workflow, I want `jr` to require a resolution upfront so that I do not accidentally create silently-unresolved done issues."
- Acceptance criteria map to BC-3.2.013 plus the inverted E2E bypass assertion.
- Source worktree: `.worktrees/S-JSM-E2E-3` (branch rename to `feat/jsm-resolution-required` recommended).

**For Implementer (F4):**
- Files to modify: see `affected-files.txt` alongside this document.
- TDD order (Red Gate):
  1. Add `test_move_refuses_done_category_with_resolution_field_no_input` — will fail (feature not yet implemented).
  2. Add `#[serde(default, skip_serializing)] fields` to `Transition`.
  3. Add `get_transitions_with_fields` to `JiraClient`.
  4. Change `handle_move`'s `get_transitions` call to `get_transitions_with_fields`.
  5. Insert the `needs_resolution` detection and enforcement block.
  6. Wire `load_resolutions` + `dialoguer::Select` for interactive path.
  7. Run all tests — existing tests stay green (no `statusCategory` in existing mock fixtures); new test goes green.
- The worktree's bypass-demo inversion follows in the same commit or a subsequent commit.
