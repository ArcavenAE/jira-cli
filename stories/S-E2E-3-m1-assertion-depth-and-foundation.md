---
document_type: story
story_id: "S-E2E-3"
title: "E2E M1: shared test helpers + assertion depth on existing tests"
wave: feature-followup
status: draft
intent: enhancement
feature_type: infrastructure
scope: non-trivial
severity: medium
trivial_scope: false
issue: TBD
points: 5
priority: P2
tdd_mode: strict
estimated_effort: medium
mode: feature
depends_on: []
bc_anchors: []
# BC delta: EMPTY — this story adds test infrastructure and deepens assertions on existing
# test code only. No new product behavioral contracts are introduced.
# Every AC traces to an existing BC from the canonical BC-INDEX.md (verified in
# .factory/phase-f2-spec-evolution/prd-delta-e2e-enhancements.md §2).
# BC status: no BC authorship required.
# Status=draft: the spec-first gate (S-7.01) does not block dispatch for
# infrastructure-only stories with explicit justification above.
bcs:
  - BC-2.2.028
  - BC-2.3.032
  - BC-2.4.039
  - BC-3.2.001
  - BC-3.4.012
  - BC-3.4.013
  - BC-5.1.001
  - BC-5.2.005
  - BC-7.1.005
  - BC-X.5.001
verification_properties: []
holdout_anchors: []
nfr_anchors: [NFR-T-E2E-1]
adr_refs: []
sd_refs: [SD-002]
parent_phase: F3-story-decomposition
spec_source: "docs/specs/e2e-test-enhancements.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 17
created: "2026-05-30"
traceability_note: >
  BC delta is EMPTY (test-infrastructure enhancement; no new product behavioral contracts).
  ACs trace to existing BCs confirmed in prd-delta-e2e-enhancements.md §2.
  The always-run unit tests for pure helpers are HIGH regression risk because
  test_every_ignored_test_has_gate_guard runs in ci.yml and will catch any new
  gated test missing an e2e_enabled() guard.
files_modified:
  - tests/e2e_live.rs   # MODIFIED — add shared helpers + deepen existing 12 test assertions
  - CLAUDE.md           # MODIFIED — add JR_E2E_POLL_MAX_ATTEMPTS + JR_E2E_POLL_INITIAL_MS entries per doc-fallout rule
breaking_change: false
assumption_validations: []
risk_mitigations: []
last_updated: "2026-05-30"
changelog:
  - date: "2026-05-30"
    phase: F3-story-decomposition
    author: story-writer
    summary: Initial story creation.
---

# S-E2E-3 — E2E M1: Shared Test Helpers + Assertion Depth on Existing Tests

## Source of Truth

Design spec: `/Users/zious/Documents/GITHUB/jira-cli/docs/specs/e2e-test-enhancements.md`
Sections: §4 (Foundation helpers), §5 (Milestone M1)
PRD delta: `.factory/phase-f2-spec-evolution/prd-delta-e2e-enhancements.md` (BC delta = EMPTY)
Parent stories: S-E2E-1 (PR #433), S-E2E-2 (PR #434)

**No new BCs. Zero `src/` changes. All edits in `tests/e2e_live.rs` and `CLAUDE.md`.**

## Goal

Build the shared helper foundation (`poll_jql`, shape matchers, transient classifier, poll-budget
env seam) with always-run unit tests for every pure helper. Then deepen the existing 12 gated tests
from exit-code-only / shape-only assertions into **contract + round-trip** assertions as specified
in §5.1 (read tests — element shape) and §5.2 (write flow — round-trip every mutation).

The foundation helpers are the prerequisite for S-E2E-4 (M2 new tests use `poll_jql` and the shape
matchers) and for eliminating the latent flake in the create-then-search assertion (§7.1, addressed
by S-E2E-5).

## Traceability

Because the BC delta for this feature is EMPTY (infrastructure only), ACs trace to **existing BCs**
from BC-INDEX.md (all confirmed in prd-delta-e2e-enhancements.md §2) and to design spec sections.

| Traceability target | Type | Description |
|--------------------|------|-------------|
| BC-2.2.028 | Existing BC | `search_issues` default fields — list tests verify JSON shape |
| BC-2.3.032 | Existing BC | `issue view --output json` returns raw JSON — view tests verify key/shape contract |
| BC-2.4.039 | Existing BC | `issue comments` paginates — comments read-back in write flow |
| BC-3.2.001 | Existing BC | Single-key `issue move` idempotency — write flow step 5 re-issue |
| BC-3.4.012 | Existing BC | `description → (updated)` marker in table/human channel |
| BC-3.4.013 | Existing BC | `changed_fields.description` carries raw input string in JSON channel |
| BC-5.1.001 | Existing BC | `client.list_boards()` GETs with query params |
| BC-5.2.005 | Existing BC | `sprint current` truncates to 30 by default; `--all` returns full set |
| BC-7.1.005 | Existing BC | `--output json` error shape on stderr |
| BC-X.5.001 | Existing BC | `client.add_worklog()` POSTs and returns Worklog; accepts 201 |
| NFR-T-E2E-1 | NFR (MEDIUM) | Obligation to keep the E2E suite runnable and wired into CI |
| Design spec §4 | Foundation | `poll_jql`, shape matchers, transient classifier, poll-budget env seam |
| Design spec §5.1 | M1 reads | Element-shape assertions on existing read tests |
| Design spec §5.2 | M1 writes | Round-trip assertions on existing write flow |

## Behavioral Contracts

None new — all tests verify existing contracts. BC delta is EMPTY.

| BC | Title (from BC-INDEX) | AC |
|----|----------------------|----|
| BC-2.2.028 | `search_issues` 16-field default | AC-005, AC-006 |
| BC-2.3.032 | `issue view --output json` raw JSON | AC-005, AC-010 |
| BC-2.4.039 | `issue comments` paginates at 100/page | AC-013 |
| BC-3.2.001 | Single-key `issue move` idempotency | AC-015 |
| BC-3.4.012 | `description → (updated)` table marker | AC-012 |
| BC-3.4.013 | `changed_fields.description` raw input string | AC-012 |
| BC-5.1.001 | `list_boards()` GETs with query params | AC-006 |
| BC-5.2.005 | `sprint current` truncates to 30; `--all` full | AC-007 |
| BC-7.1.005 | `--output json` error shape to stderr | AC-001 through AC-004 (unit tests validate helper plumbing) |
| BC-X.5.001 | `add_worklog()` POSTs 201 | AC-014 |

## Acceptance Criteria

### AC-001 — `poll_jql` helper: skip-on-empty mode (traces to design spec §4; NFR-T-E2E-1)

`poll_jql(jql: &str, predicate: impl Fn(&Value) -> bool, mode: PollJqlMode) -> Option<Value>` is
defined in `tests/e2e_live.rs`. In `SkipOnEmpty` mode:

- Retries bounded by `JR_E2E_POLL_MAX_ATTEMPTS` (default 5 if unset or empty) iterations.
- Uses backoff derived from `JR_E2E_POLL_INITIAL_MS` (default 250ms if unset or empty); doubles
  each attempt (250 → 500 → 1000 → 2000 → 4000ms or similar schedule).
- Treats a 0-result response as retryable (pure index lag), not a failure.
- On budget exhaustion with 0 results: returns `None` + `eprintln!` a skip notice with elapsed
  time in milliseconds.
- On predicate satisfied: returns `Some(value)`.
- Emits elapsed poll time on every exit path so CI log readers can distinguish lag from bugs.
- NEVER retries a non-zero result set that fails the predicate in skip-on-empty mode (only 0
  results trigger retry).

Always-run unit test `test_poll_jql_skip_on_empty_returns_none_on_zero_results` verifies this
logic by calling a pure extraction of the mode-decision logic (or via dependency injection)
without any live Jira call.

### AC-002 — `poll_jql` helper: fail-on-short mode (traces to design spec §4; NFR-T-E2E-1)

`poll_jql` in `FailOnShort(min: usize)` mode:

- Retries on a 0-result response (pure lag, same as SkipOnEmpty mode).
- On budget exhaustion with result count between 1 and `min - 1` inclusive: panics with a clear
  "REGRESSION: expected at least N results after full poll budget" message — this is a real
  regression (some-but-not-all is not lag).
- On budget exhaustion with 0 results: behaves identically to SkipOnEmpty (clean-skip, returns
  `None`) — a 0-result state after full budget is treated as pure index lag, not a regression.
- On predicate satisfied with `count >= min`: returns `Some(value)`.

Always-run unit test `test_poll_jql_fail_on_short_panics_on_partial_results` verifies the
panic branch; `test_poll_jql_fail_on_short_skips_on_zero` verifies the 0-result clean-skip.

### AC-003 — Shape matchers: always-run unit tests (traces to design spec §4; NFR-T-E2E-1)

These four pure helper functions are defined and have always-run unit tests verifying their
pure logic over synthetic `serde_json::Value` literals (no live calls):

1. `assert_key_format(key: &str)` — panics if `key` does not match `^[A-Z][A-Z0-9]+-\d+$`.
   Unit test: `test_assert_key_format_accepts_valid` (e.g., `"E2E-1"`, `"PROJ-999"`) and
   `test_assert_key_format_rejects_invalid` (e.g., `"e2e-1"`, `"123"`, `"ABC"`).

2. `assert_status_category(v: &Value, expected: StatusCategory)` — asserts
   `v["statusCategory"]["key"]` equals the stable locale-invariant enum string. `StatusCategory`
   is `{ToDo, InProgress, Done}` mapping to `"new"`, `"indeterminate"`, `"done"` respectively.
   Unit test: `test_assert_status_category_matches_key_not_name` asserts each enum variant maps
   to the correct key string and panics if `v["statusCategory"]["key"]` is wrong.

3. `assert_issue_shape(v: &Value)` — asserts `v["key"]` matches key format, `v["fields"]` is an
   object, `v["fields"]["summary"]` is present (string or null), and `v["fields"]["status"]`
   contains a `statusCategory` object. Unit test: `test_assert_issue_shape_valid` and
   `test_assert_issue_shape_rejects_missing_fields`.

4. `assert_array_of_objects_with_keys(v: &Value, keys: &[&str])` — asserts `v` is an array and,
   for every element in the array (if non-empty), each element has all the given `keys` present.
   An empty array passes (portable "if non-empty" contract). Unit test:
   `test_assert_array_of_objects_with_keys_empty_passes`,
   `test_assert_array_of_objects_with_keys_all_present`,
   `test_assert_array_of_objects_with_keys_missing_key_panics`.

### AC-004 — Transient classifier: always-run unit test (traces to design spec §4; NFR-T-E2E-1)

`is_transient_error(status_code: u16, stderr: &str) -> bool` is defined as a pure helper:
- Returns `true` for `429`, `503`, `0` (connection reset / empty stderr).
- Returns `false` for any `4xx` in the range `400..=499` other than `429`.
- Returns `false` for `5xx` other than `503`.
- NEVER causes a retry to mask a 4xx in a positive test.

Unit tests: `test_transient_classifier_retries_429_and_503`,
`test_transient_classifier_does_not_retry_400_404_401`.

### AC-005 — M1 read: `issue list` element shape (traces to BC-2.2.028; spec §5.1)

`test_e2e_issue_list_returns_array` (and the summary-filter variant) deepened: when the array
is non-empty, `assert_array_of_objects_with_keys` is called with `&["key", "fields"]`, then
for each element `v["fields"]["status"]["statusCategory"]` is asserted to be an object (not null).
`assert_key_format` is called on each element's `"key"` field.

Spec reference: §5.1 — "if non-empty, assert every element has `key` (format) + a `status`
object with a `statusCategory`."

### AC-006 — M1 read: `board list` and `project fields` element shapes (traces to BC-5.1.001; spec §5.1)

`test_e2e_board_list_returns_array` deepened: when the array is non-empty, each element has
`id` + `name` + `type` keys (verified via `assert_array_of_objects_with_keys`).

`test_e2e_project_fields_returns_object` deepened: asserts all 5 documented keys are present
in the JSON object: `project`, `issue_types`, `priorities`, `statuses_by_issue_type`,
`asset_fields`. Key-presence only — does NOT assert any key is non-empty (trap F-08:
`asset_fields` is `[]` on non-CMDB instances; `priorities`/`statuses_by_issue_type` may be empty).

Spec reference: §5.1 — "assert **all 5** documented keys are **present** (never non-empty)."

### AC-007 — M1 read: sprint shape assertions (traces to BC-5.2.005; spec §5.1)

`test_e2e_sprint_list_returns_array` deepened: when non-empty, each element has `id` and, if
the `state` key is present, it is a string (not null). Uses `assert_array_of_objects_with_keys`
with `&["id"]`.

`test_e2e_sprint_current_returns_json` deepened: asserts the top-level object has `"sprint"`
key, `v["sprint"]["id"]` is present, `v["sprint"]["state"]` is a string if present, and
`v["issues"]` is an array. When `v["issues"]` is non-empty, `assert_issue_shape` is called on
each element. The three existing clean-skip conditions (unset `JR_E2E_BOARD_ID`, non-scrum board,
no active sprint) are PRESERVED unchanged (per spec §5.1: "preserve all three existing clean-skip
conditions").

Spec reference: §5.1 — "sprint current JSON is an **object** `{sprint, issues, sprint_summary?}`
— `v["sprint"]["id"]` / `v["sprint"]["state"]`."

### AC-008 — M1 read: `user search` and `worklog list` shape (traces to BC-2.2.028, BC-X.5.001; spec §5.1)

`test_e2e_user_search_returns_array` deepened: when non-empty, each element has `accountId` +
`displayName` keys (presence + type; NOT value equality). Uses
`assert_array_of_objects_with_keys`.

**DI-E2E-F2-2 (implementation note):** Confirm Rust `User` serde renames `accountId` and
`displayName` match the expected JSON key names before writing this assertion. Verify by
reading `src/types/jira/users.rs` serde field attributes.

`test_e2e_worklog_list_returns_array` deepened: when non-empty, each entry's
`timeSpentSeconds` **if present** is numeric (the field is `Option<u64>` in the `Worklog` type
— do NOT require it non-null). The exact `== 300` value assertion is reserved for the
write-flow step 4 (AC-014) only.

Spec reference: §5.1 — "if non-empty, each element has `accountId` + `displayName`" and
"`timeSpentSeconds` **if present is numeric** … Reserve the exact `== 300` value check for
the just-written entry only."

### AC-009 — Poll-budget env seam + CLAUDE.md doc entry (traces to design spec §4; NFR-T-E2E-1)

`poll_jql` reads `JR_E2E_POLL_MAX_ATTEMPTS` and `JR_E2E_POLL_INITIAL_MS` from the environment
using a trim-guard pattern (same as `status_done()` in S-E2E-2 AC-1 — `Ok(v) if !v.trim().is_empty()`).
Defaults: max attempts = 5; initial backoff = 250ms.

The existing `poll_view` SHOULD share the same backoff schedule. If `poll_view`'s hardcoded
`[250, 500, 1000, 2000]` schedule is refactored to read the same seam, document the change; if
kept separate, add an implementation note explaining why only `poll_jql` is configurable.

`CLAUDE.md` AI Agent Notes section is updated in the same commit as the test changes to add:

- `JR_E2E_POLL_MAX_ATTEMPTS` — max poll iterations for `poll_jql` / `poll_view` (default 5);
  read by test code only (no `#[cfg(debug_assertions)]` src/ read site needed).
- `JR_E2E_POLL_INITIAL_MS` — initial backoff in milliseconds (default 250); same scope.

Verification: `grep -n "JR_E2E_POLL_MAX_ATTEMPTS\|JR_E2E_POLL_INITIAL_MS" CLAUDE.md` returns
at least 2 matches.

### AC-010 — M1 write: create step — key format + url presence (traces to BC-2.3.032; spec §5.2 step 1)

The write flow step 1 is deepened from exit-code-only to:

- Assert `output` is valid JSON.
- Assert `output["key"]` is present and passes `assert_key_format`.
- Assert `output["url"]` is present and is a string (not null).
- Then `poll_view(key)` and assert `v["fields"]["summary"]` equals the seed summary.
- Assert the issue type name (`v["fields"]["issuetype"]["name"]`) equals the value passed to
  `--type` (env-parametric via a `issue_type()` helper that reads an env var with default `"Task"`
  — NOT a hardcoded `"Task"` literal in the assertion; F-12).
- Assert `run_label()` value appears in `v["fields"]["labels"]` array.

**Create-JSON contract (F-05):** `issue create --output json` emits the full `Issue` object plus
a top-level `url`. On GET failure it degrades to `{key, url, fetch_error}`. The `url` presence
assertion is itself a regression-worthy contract.

Spec reference: §5.2 step 1 — "assert `key` format **and `url` present**; then `poll_view` and
assert echoed `summary`, issue type name (env-parametric), and run label in `labels`."

### AC-011 — M1 write: edit summary round-trip (traces to BC-2.2.028; spec §5.2 step 2)

Write flow step 2 deepened:

- Run `issue edit <key> --summary <summary_edit> --output json`.
- Assert exit 0.
- Assert `edit_output["changed_fields"]["summary"]` is present (the field was changed).
- Assert `edit_output["changed_fields"]["updated"]` equals `true` (or is a truthy value).
- `poll_view(key)` and assert `v["fields"]["summary"]` equals `summary_edit`.

The `--summary` edit echoes its value in both channels (no asymmetry — the #398 asymmetry is
description-specific). Do NOT conflate this step with the description sub-step (AC-012).

Spec reference: §5.2 step 2 — "assert `changed_fields` containing `summary` + `updated: true`."

### AC-012 — M1 write: edit description — #398 asymmetry (traces to BC-3.4.012, BC-3.4.013; spec §5.2 step 2)

An **edit-description sub-step** is added immediately after the summary edit:

- Run `issue edit <key> --description <desc_text> --output json`.
- Assert exit 0.
- Assert JSON stdout `changed_fields.description == <desc_text>` (raw input string, NOT `"(updated)"`).
  This validates BC-3.4.013.
- Capture the command's stderr (human/table channel output). Assert stderr contains the literal
  marker `"(updated)"` (not the raw description text). This validates BC-3.4.012.

**DI-E2E-F2-1 (implementation note):** The edit `(updated)` table marker is emitted to STDERR,
not stdout. Assert on `cmd.get_output().stderr` (the human channel), not on stdout. The JSON
channel is on stdout. Keep channels strictly separate.

Spec reference: §5.2 step 2 — "add an **edit-description sub-step**: assert JSON
`changed_fields.description == <raw text>` and the human/table channel prints the `(updated)`
marker — assert each channel **distinctly**."

### AC-013 — M1 write: comment read-back (traces to BC-2.4.039; spec §5.2 step 3)

Write flow step 3 deepened:

- Run `issue comment <key> <comment_text> --output json`. Assert exit 0.
- Read back: `issue comments <key> --output json`. Assert exit 0; output is a JSON array.
- Assert the comment text appears as a substring of the serialized comment JSON (the body is ADF,
  not a flat string — `Comment.body` is `Option<Value>`; do NOT assert `body == comment_text`).
  Acceptable assertion: `serde_json::to_string(&output).unwrap().contains(&comment_text)`.
- Assert at least one element in the array exists (we just wrote one).

Spec reference: §5.2 step 3 — "ADF caveat: `Comment.body` is an ADF object, NOT a flat string —
Assert the posted text appears as a **substring of the serialized comment JSON**."

### AC-014 — M1 write: worklog exact value assertion (traces to BC-X.5.001; spec §5.2 step 4)

Write flow step 4 deepened:

- Run `worklog add <key> 5m --output json`. Assert exit 0.
- Run `worklog list <key> --output json`. Assert exit 0; output is a JSON array.
- Find an entry where `entry["timeSpentSeconds"] == 300` (5 minutes = 300 seconds).
  Assert at least one such entry exists.

This pins BC-X.5.001 (POST 201 and returns Worklog with the correct `timeSpentSeconds`). This is
the ONLY place where `== 300` is asserted; the read-only worklog test (AC-008) does NOT assert
an exact value.

Spec reference: §5.2 step 4 — "assert an entry with `timeSpentSeconds == 300`."

### AC-015 — M1 write: move transitions + idempotency (traces to BC-3.2.001; spec §5.2 steps 5–6)

Write flow steps 5–6 deepened:

**Step 5 — move to In Progress:**
- Run `issue move <key> <status_in_progress()> --output json`. Assert exit 0.
- `poll_view(key)`: assert `v["fields"]["status"]["statusCategory"]["key"]` equals
  `"indeterminate"` (the locale-invariant key for In Progress; via `assert_status_category` with
  `StatusCategory::InProgress`). Do NOT assert the status name string — that is instance-specific.
- Re-issue the same `issue move <key> <status_in_progress()> --output json` and assert exit 0.
  Assert the idempotent response has `move_output["changed"] == false` (single-key move JSON is
  `{key, status, changed}`; BC-3.2.001).

**Step 6 — move to Done:**
- Run `issue move <key> <status_done()> --output json`. Assert exit 0.
- `poll_view(key)`: assert `statusCategory["key"]` equals `"done"`.

Spec reference: §5.2 steps 5–6 — "assert `statusCategory` is the In-Progress category (**by
category, not name**); then **re-issue the same move and assert exit 0** (single-key idempotency
contract). Single-key move JSON is `{key, status, changed}` — the idempotent re-issue returns
`changed: false`."

### AC-016 — `test_every_ignored_test_has_gate_guard` still passes (traces to NFR-T-E2E-1; spec §9)

After all additions, the always-run source meta-guard test
`test_every_ignored_test_has_gate_guard` in `tests/e2e_live.rs` continues to exit 0 in
`cargo test --test e2e_live`. This test verifies that every `#[ignore]`-annotated test in the
file has an `e2e_enabled()` call before any live-call token. All new pure helper unit tests in
this story are NOT `#[ignore]`-annotated (they are always-run), so they do not require
`e2e_enabled()` guards — the meta-guard is automatically satisfied.

Verification: `cargo test --test e2e_live` (without `JR_RUN_E2E=1`) exits 0. All new unit tests
for pure helpers run and pass.

### AC-017 — No `src/` changes (architecture boundary; spec §4)

`git diff --name-only HEAD` does NOT include any file under `src/`. The helpers are defined in
`tests/e2e_live.rs` (test code). `CLAUDE.md` is the only non-test file modified.

Zero new Cargo.toml dependencies are required.

Verification: `grep -rn "poll_jql\|assert_key_format\|assert_status_category\|assert_issue_shape\|assert_array_of_objects" src/` returns ZERO matches.

## Implementation Notes

**DI-E2E-F2-1:** The `issue edit --description` table marker `(updated)` is emitted to STDERR
(the human channel), not stdout. Assertions on this marker MUST use `cmd.get_output().stderr`,
not stdout. The JSON `changed_fields.description` is on stdout. Keep channels separate.

**DI-E2E-F2-2:** Before writing the `user search` element-shape assertion in AC-008, read
`src/types/jira/users.rs` to confirm the serde field rename attributes for `accountId` and
`displayName`. The JSON key names in `--output json` output are determined by the serde
`rename` attribute, not the Rust field name.

## Out of Scope

- New gated tests for `issue transitions`, `issue changelog`, `issue assign`, `issue link`,
  `bulk move`, `pagination dedup`, and error paths — those are S-E2E-4.
- CI workflow changes (`e2e.yml`, `e2e-sweeper.yml`) — those are S-E2E-5.
- Secret-leak guard test — S-E2E-5.
- Leak-detection log at suite start — S-E2E-5.
- Any JSM expansion — declared non-goal in spec §2.

## Implementation Strategy

**TDD order:**

1. **Pure helpers first with always-run unit tests (AC-001–AC-004)** — implement `poll_jql`
   (both modes), the four shape matchers, and the transient classifier. Write always-run unit
   tests. Run `cargo test --test e2e_live` to confirm all unit tests pass without `JR_RUN_E2E=1`.

2. **Poll-budget env seam + CLAUDE.md (AC-009)** — wire up `JR_E2E_POLL_MAX_ATTEMPTS` and
   `JR_E2E_POLL_INITIAL_MS` reads into `poll_jql`. Update `CLAUDE.md` in the same commit.

3. **Deepen M1 read tests (AC-005–AC-008)** — one test at a time, deepening existing gated
   tests with shape assertions. Compile-check after each. Run `cargo test --test e2e_live` to
   verify the always-run unit tests still pass.

4. **Deepen M1 write flow (AC-010–AC-015)** — deepen the existing write flow test, adding the
   create round-trip, edit round-trip, description sub-step (AC-012), comment read-back, worklog
   exact value, and move idempotency. The write flow test is a single gated function — all
   sub-step deepenings happen inside it.

5. **Final verification (AC-016–AC-017)** — `cargo test --test e2e_live` exits 0 (gate tests +
   new unit tests pass); grep verifications from quality gate self-check below.

**Branch:** `test/e2e-enhancements` (the feature branch for this cycle).

**Commit message:**
```
test(e2e): M1 shared helpers + assertion depth (poll_jql, shape matchers, round-trips)
```

**PR target:** `develop`.

## Quality Gate Self-Check

| Criterion | AC | Notes |
|-----------|----|-------|
| `cargo test --test e2e_live` (no env) exits 0 | AC-016 | All new unit tests pass; meta-guard passes |
| `grep -n "fn poll_jql" tests/e2e_live.rs` → ≥1 match | AC-001/002 | `poll_jql` defined |
| `grep -n "fn assert_key_format\|fn assert_status_category\|fn assert_issue_shape\|fn assert_array_of_objects_with_keys" tests/e2e_live.rs` → 4 matches | AC-003 | All four matchers defined |
| `grep -n "fn is_transient_error" tests/e2e_live.rs` → 1 match | AC-004 | Classifier defined |
| `grep -n "JR_E2E_POLL_MAX_ATTEMPTS\|JR_E2E_POLL_INITIAL_MS" CLAUDE.md` → ≥2 matches | AC-009 | CLAUDE.md updated |
| `grep -rn "poll_jql\|assert_key_format" src/` → 0 matches | AC-017 | No src/ contamination |
| `cargo test` exits 0 | smoke | Full test suite green |
| `cargo fmt --all -- --check` exits 0 | lint | No format drift |
| `cargo clippy --all-targets -- -D warnings` exits 0 | lint | Zero warnings |
| `bash scripts/check-spec-counts.sh` exits 0 | invariant | No BC frontmatter changed |
| `bash scripts/check-bc-cumulative-counts.sh` exits 0 | invariant | No count surfaces touched |
| `bash scripts/check-bc-no-numeric-test-counts.sh` exits 0 | invariant | No BC bodies with numeric counts |

## Token Budget Estimate

| Item | Tokens (approx) |
|------|----------------|
| This story file | ~7 k |
| Design spec §4 + §5 (foundation + M1) | ~5 k |
| S-E2E-1 (AC-003/005/007 helper patterns to match) | ~5 k |
| S-E2E-2 (AC-1 trim-guard pattern to reuse) | ~3 k |
| `tests/e2e_live.rs` current state (~500 LOC to read + modify) | ~7 k |
| `src/types/jira/users.rs` (DI-E2E-F2-2 serde verification, ~50 LOC) | ~1 k |
| `CLAUDE.md` AI Agent Notes section (insertion point) | ~3 k |
| Tool outputs (`cargo test`, `cargo clippy`, grep verifications, script exits) | ~4 k |
| BC files: 0 (none loaded — BC delta empty) | 0 |
| **Total** | **~35 k** |

Well within a single-agent context window (~200 k). No split required.
LOC delta: `tests/e2e_live.rs` +~200 LOC (helpers + deeper assertions);
`CLAUDE.md` +~5 LOC. Zero `src/` LOC changes.

## Tasks

- [ ] Create or check out branch `test/e2e-enhancements`
- [ ] Read `tests/e2e_live.rs` in full — understand current state and existing helper patterns
- [ ] Read `src/types/jira/users.rs` — verify serde rename for `accountId`/`displayName` (DI-E2E-F2-2)
- [ ] Read S-E2E-2 AC-1 — understand trim-guard pattern for env var reading
- [ ] Implement `PollJqlMode` enum (`SkipOnEmpty`, `FailOnShort(usize)`)
- [ ] Implement `poll_jql(jql, predicate, mode)` with bounded retry + env seam reads + elapsed logging
- [ ] Write always-run unit tests: `test_poll_jql_skip_on_empty_*` and `test_poll_jql_fail_on_short_*` (AC-001/002)
- [ ] `cargo test --test e2e_live` — exits 0 (unit tests pass; meta-guard passes)
- [ ] Implement `StatusCategory` enum + `assert_status_category`
- [ ] Implement `assert_key_format`, `assert_issue_shape`, `assert_array_of_objects_with_keys`
- [ ] Write always-run unit tests for all four shape matchers (AC-003)
- [ ] Implement `is_transient_error` + always-run unit tests (AC-004)
- [ ] `cargo test --test e2e_live` — exits 0
- [ ] Wire `JR_E2E_POLL_MAX_ATTEMPTS` / `JR_E2E_POLL_INITIAL_MS` into `poll_jql` using trim-guard pattern (AC-009)
- [ ] Update `CLAUDE.md` with both env var entries in same commit (AC-009)
- [ ] Deepen `test_e2e_issue_list_returns_array` + summary-filter variant with key-format + statusCategory shape (AC-005)
- [ ] Deepen `test_e2e_board_list_returns_array` with `id`+`name`+`type` keys (AC-006)
- [ ] Deepen `test_e2e_project_fields_returns_object` with all 5 key assertions (AC-006)
- [ ] Deepen `test_e2e_sprint_list_returns_array` with `id` key assertion, `state` type check (AC-007)
- [ ] Deepen `test_e2e_sprint_current_returns_json` with `sprint.id`, `sprint.state`, `issues` array + per-element `assert_issue_shape` (AC-007)
- [ ] Deepen `test_e2e_user_search_returns_array` with `accountId`+`displayName` key assertions (AC-008)
- [ ] Deepen `test_e2e_worklog_list_returns_array` with optional `timeSpentSeconds` numeric check (AC-008)
- [ ] Deepen write flow step 1: key format + url presence + `poll_view` round-trip (summary, type, label) (AC-010)
- [ ] Deepen write flow step 2 (summary edit): `changed_fields.summary` + `updated: true` + `poll_view` round-trip (AC-011)
- [ ] Add write flow description sub-step: `--description` edit, assert JSON `changed_fields.description == raw_text`, assert stderr contains `(updated)` marker (AC-012)
- [ ] Deepen write flow step 3 (comment): `issue comments` read-back + ADF substring assertion (AC-013)
- [ ] Deepen write flow step 4 (worklog): `worklog list` + `timeSpentSeconds == 300` assertion (AC-014)
- [ ] Deepen write flow step 5 (move In Progress): `assert_status_category(indeterminate)` + idempotent re-issue `changed: false` (AC-015)
- [ ] Deepen write flow step 6 (move Done): `assert_status_category(done)` (AC-015)
- [ ] `cargo test --test e2e_live` — exits 0 (all unit tests + meta-guard pass)
- [ ] Verify `grep -rn "poll_jql\|assert_key_format" src/` → 0 matches (AC-017)
- [ ] `cargo test` — exits 0
- [ ] `cargo fmt --all -- --check` — exits 0
- [ ] `cargo clippy --all-targets -- -D warnings` — exits 0
- [ ] `bash scripts/check-spec-counts.sh && bash scripts/check-bc-cumulative-counts.sh && bash scripts/check-bc-no-numeric-test-counts.sh` — all exit 0
- [ ] Commit: `test(e2e): M1 shared helpers + assertion depth (poll_jql, shape matchers, round-trips)`

## Previous Story Intelligence

**Direct predecessors: S-E2E-1 (PR #433) and S-E2E-2 (PR #434).** The foundation helpers in
this story extend the helper suite (`e2e_cmd`, `poll_view`, `run_label`, `project`,
`status_done`, `status_in_progress`) established there.

**Key lesson from S-E2E-2 (FIX-A):** Use the trim-guard match pattern for optional env vars —
`Ok(v) if !v.trim().is_empty()` — because GitHub Actions `vars.*` expressions evaluate to
empty string (`Ok("")`) when unconfigured, so `unwrap_or_else` never fires. Apply this pattern
to `JR_E2E_POLL_MAX_ATTEMPTS` and `JR_E2E_POLL_INITIAL_MS`.

**Key lesson from S-E2E-1 (architecture rule #2):** Every `#[ignore]`-annotated gated test MUST
have an `e2e_enabled()` early-return guard. New pure-helper unit tests are always-run (NOT
`#[ignore]`-annotated) and do not need the guard — but the meta-guard
`test_every_ignored_test_has_gate_guard` will fail loudly in `ci.yml` if any new gated test
omits the guard.

**Key lesson from S-398 (description echo asymmetry):** The `(updated)` marker in the human
channel and the raw string in the JSON channel are intentionally different. DI-E2E-F2-1 codifies
this: assert stderr for the marker, assert stdout JSON for the raw value. Do NOT compare them
to each other.

**Portability rule (spec §3):** All assertions must be contract/invariant-level, never
instance-specific. Use `statusCategory.key` (`new`/`indeterminate`/`done`) not status name
strings. Use `assert_key_format` not a specific key value.

## Architecture Compliance Rules

1. **Zero `src/` changes (hard boundary).** All new code lives in `tests/e2e_live.rs`. If any
   `src/` change is needed, STOP and escalate.

2. **Pure helpers MUST have always-run unit tests.** This is the spec §9 requirement: "new
   always-run unit tests cover any pure helper added." Always-run = not `#[ignore]`, not behind
   `e2e_enabled()`. They run in `ci.yml`'s normal `cargo test`.

3. **New `#[ignore]`-gated code MUST have `e2e_enabled()` before any live call.** The source
   meta-guard `test_every_ignored_test_has_gate_guard` enforces this automatically and runs in
   `ci.yml`.

4. **`statusCategory.key` is the portable assertion anchor, not `statusCategory.name`.** Jira
   provides three fixed locale-invariant category keys: `"new"` (To Do), `"indeterminate"` (In
   Progress), `"done"` (Done). NEVER assert `statusCategory.name` — that string is localized.

5. **`poll_jql` skip-on-empty vs fail-on-short is a caller-specified mode, not a global setting.**
   The `PollJqlMode` parameter is required at every call site. Do NOT add a global mutable.

6. **`assert_array_of_objects_with_keys` with an empty array MUST pass** (portable "if non-empty"
   contract per spec §3). An assertion that requires a non-empty array over-fits to seed data.

## Library & Framework Requirements

No new `Cargo.toml` dependencies. All helpers use crates already present:

| Crate | Already in Cargo.toml | Usage in this story |
|-------|----------------------|---------------------|
| `serde_json` | Yes (dev-dep) | `Value` parsing in helpers and assertions |
| `assert_cmd` | Yes (dev-dep) | Subprocess invocation (unchanged) |
| `tempfile` | Yes (dev-dep) | `TempDir` (unchanged) |
| `std::env` | stdlib | `JR_E2E_POLL_MAX_ATTEMPTS` / `JR_E2E_POLL_INITIAL_MS` reads |
| `std::thread::sleep` + `std::time` | stdlib | Backoff implementation in `poll_jql` |
| `regex` (if needed for `assert_key_format`) | Yes (dev-dep or indirect) | `^[A-Z][A-Z0-9]+-\d+$` — alternative: use a pure string check without regex |

If `regex` is not already a dev-dep, implement `assert_key_format` with a character-by-character
check rather than adding a new dependency.

## File Structure Requirements

| File | Action | Notes |
|------|--------|-------|
| `tests/e2e_live.rs` | MODIFY | Add foundation helpers (+~150 LOC) + deepen 12 existing tests (+~50 LOC net) |
| `CLAUDE.md` | MODIFY | Add `JR_E2E_POLL_MAX_ATTEMPTS` + `JR_E2E_POLL_INITIAL_MS` entries (+~5 LOC) |

**Files NOT to create:** No new `src/` files, no new spec files, no new ADR, no new BC files,
no new workflow files.

**Files NOT to touch:** All of `src/`, `Cargo.toml`, `deny.toml`, `.github/workflows/ci.yml`,
`.github/workflows/e2e.yml`, `tests/common/`, all snapshot files (`tests/snapshots/`), all
other `tests/*.rs` files, `STORY-INDEX.md` (state-manager updates that), all BC count surfaces.

## Branch / PR Plan

- Branch: `test/e2e-enhancements`
- Target: `develop`
- Commit: `test(e2e): M1 shared helpers + assertion depth (poll_jql, shape matchers, round-trips)`
- PR body: reference this story (S-E2E-3), design spec §4/§5, and NFR-T-E2E-1
- CHANGELOG entry: Add under `[Unreleased]` — "Hardened E2E suite (M1): shared `poll_jql` /
  shape matchers / transient classifier helpers with always-run unit tests; deepened existing
  12 tests to contract + round-trip assertions."
