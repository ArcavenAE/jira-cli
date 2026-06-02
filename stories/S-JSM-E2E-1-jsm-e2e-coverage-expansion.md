---
document_type: story
story_id: "S-JSM-E2E-1"
title: "JSM E2E Coverage Expansion — queue view, requesttype fields, comment visibility, create round-trip, non-JSM guard"
wave: feature-followup
status: ready
intent: enhancement
feature_type: test
scope: small
severity: small
trivial_scope: false
issue: TBD
points: 3
priority: P2
tdd_mode: facade
estimated_effort: small
mode: feature
depends_on: []
blocks: []
bc_anchors:
  - BC-X.8.004
  - BC-X.12.001
  - BC-X.12.005
  - BC-3.8.001
  - BC-3.8.004
  - BC-3.5.001
  - BC-2.4.041
# BC delta: EMPTY — this story adds live E2E tests and documentation only.
# No product behavioral contracts are introduced or modified.
# BC corpus (585 BCs) and NFR corpus (41 NFRs) are EXPLICITLY UNCHANGED.
# No new BC file is created; no existing BC is modified; BC-INDEX.md is unchanged.
#
# bc_anchors note: BC-X.12.001 is retained for AC-002 (requesttype list) and AC-003
# is an explicitly-logged orphan — queue commands shipped without behavioral contracts
# (pre-existing corpus gap, tracked in S-QUEUE-BC-1). BC-3.5.001 + BC-2.4.041 added
# for AC-005 comment-visibility round-trip.
bcs:
  - BC-X.8.004
  - BC-X.12.001
  - BC-X.12.005
  - BC-3.8.001
  - BC-3.8.004
  - BC-3.5.001
  - BC-2.4.041
verification_properties:
  - VER-JSM-E2E-1
  - VER-JSM-E2E-2
  - VER-JSM-E2E-3
  - VER-JSM-E2E-4
  - VER-JSM-E2E-5
  - VER-JSM-E2E-6
  - VER-JSM-E2E-7
holdout_anchors: []
nfr_anchors: []
adr_refs:
  - ADR-0014
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: "docs/specs/jsm-e2e-coverage.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 7
assumption_validations: []
risk_mitigations: []
created: "2026-06-01"
last_updated: "2026-06-01"
traceability_note: >
  BC delta is EMPTY for new BCs; this story exercises existing BCs via live
  E2E tests. All 7 ACs trace to VER-JSM-E2E-N verification properties defined
  in docs/specs/jsm-e2e-coverage.md §8. No BC-S.SS.NNN is modified. Files
  changed: tests/e2e_live.rs (7 test fns), tests/e2e_cli_surface_guard.rs
  (4 SURFACE rows), docs/specs/e2e-live-jira-testing.md (§4 + §8),
  CLAUDE.md (JSM E2E teardown convention). Zero src/ changes.
files_modified:
  - tests/e2e_live.rs                     # MODIFIED — add 7 #[ignore]-gated JSM test fns (Scenarios 1-7)
  - tests/e2e_cli_surface_guard.rs        # MODIFIED — add 4 SURFACE rows for queue view, requesttype fields, issue comment, issue create --request-type
  - docs/specs/e2e-live-jira-testing.md   # MODIFIED — §4 update test fn list; §8 update JR_E2E_JSM_PROJECT row
  - CLAUDE.md                             # MODIFIED — add JSM E2E teardown design note (self-close, not sweeper)
breaking_change: false
changelog:
  - date: "2026-06-01"
    phase: F3-story-decomposition
    author: story-writer
    summary: >
      Initial story creation. JSM E2E Coverage Expansion — 7 live test scenarios
      for queue view, requesttype fields, comment visibility, create round-trip,
      and non-JSM guard. Zero src/ delta. Extends existing live E2E suite.
---

# S-JSM-E2E-1 — JSM E2E Coverage Expansion

## Source of Truth

Design spec: `docs/specs/jsm-e2e-coverage.md`
Sections: §2 (Scope + Constraints), §3 (Clean-Skip Policy), §4 (Dynamic-Discovery Design),
          §5 (Test Scenarios 1-7), §6 (Teardown Design + Orphan Risk), §8 (Verification
          Properties VER-JSM-E2E-1..7), §9 (Rollout), §10 (F4 Touch-Point List).
F1 delta analysis: `.factory/phase-f1-delta-analysis/jsm-e2e-expansion/delta-analysis.md`

**No new BCs. BC corpus (585) and NFR corpus (41) are EXPLICITLY UNCHANGED.
Changes touch `tests/e2e_live.rs`, `tests/e2e_cli_surface_guard.rs`,
`docs/specs/e2e-live-jira-testing.md`, and `CLAUDE.md`. Zero `src/` changes.**

## Story Narrative

As a jr maintainer,
I want live E2E tests that exercise JSM-specific code paths (queue view, requesttype
fields, comment visibility, create round-trip, and the non-JSM guard) against a real
Jira Service Management project,
so that wire-shape regressions and API dispatch forks (ADR-0014) are caught before
they reach production — the same rigour already applied to platform commands.

As a fork contributor,
I want all JSM tests to clean-skip loudly when `JR_E2E_JSM_PROJECT` is unset,
so that my CI runs are never red because of missing JSM project configuration.

## Dependency Justification

**S-JSM-E2E-1 has `depends_on: []`** — it extends the existing live E2E suite which
landed in S-E2E-1 (PR #433). All JSM commands already exist in `src/`. No `src/`
change is required; no new Cargo dependency is introduced.

**`blocks: []`** — no current story depends on JSM E2E coverage to proceed.

## Goal

1. Add 7 `#[ignore]`-gated test functions to `tests/e2e_live.rs` covering Scenarios 1-7
   from the spec (§5). Scenarios 1-2 deepen existing shallow JSM tests. Scenarios 3-7 are
   entirely new coverage paths.
2. Add 4 SURFACE rows to `tests/e2e_cli_surface_guard.rs` for the CLI paths exercised by
   the new tests (queue view, requesttype fields, issue comment --internal, issue create
   --request-type).
3. Update `docs/specs/e2e-live-jira-testing.md` §4 (test function list) and §8
   (`JR_E2E_JSM_PROJECT` row notes).
4. Update `CLAUDE.md` AI Agent Notes E2E section with the JSM teardown design convention:
   self-close in test body (not label-sweeper) because labels do not propagate through
   `servicedeskapi` to Jira issue labels.
5. Document the rollout step: set `JR_E2E_JSM_PROJECT=EJ` as an environment variable in
   the `jira-e2e` GitHub Environment post-merge.

## Behavioral Contracts

All new tests trace to existing BCs — no BCs are created or modified.

| BC | What the new tests exercise |
|----|----------------------------|
| BC-X.12.001 | `jr requesttype list` — deepened to assert per-item `id` + `name` fields (AC-002). **Note:** AC-001 (`jr queue list`) and AC-003 (`jr queue view`) do NOT trace to BC-X.12.001 — queue commands shipped in an earlier cycle with no behavioral contracts (pre-existing corpus gap). See orphan note below. |
| BC-X.12.005 | `jr requesttype fields <numeric_id>` — asserts top-level `"fields"` key in response (AC-004) |
| BC-3.8.001 | `jr issue create --request-type` write round-trip — `POST /rest/servicedeskapi/request`; asserts `{"key": "EJ-N"}` on stdout (AC-006) |
| BC-3.8.004 | Numeric-bypass path: all-ASCII-digit RT id skips name resolution in both `requesttype fields` and `issue create --request-type` (AC-004, AC-006) |
| BC-X.8.004 | `require_service_desk` guard: `jr queue list --project <non-JSM>` exits 64; stderr contains `"Jira Service Management project"` (AC-007) |
| BC-3.5.001 | `jr issue comment <key> --internal` write side: adds `sd.public.comment` property on the comment (AC-005) |
| BC-2.4.041 | `jr issue comments --output json` read side: exposes `properties[]` array including `sd.public.comment` for JSM-aware comment display (AC-005) |

**Orphan note — AC-001 and AC-003 (queue list / queue view):** The queue commands
(`jr queue list`, `jr queue view`) shipped in an earlier delivery cycle without any
behavioral contracts in the BC corpus. Anchoring the queue E2E tests to BC-X.12.001
(a `requesttype` contract) would be a semantically-invalid traceability link — false
coverage. Instead, AC-001 and AC-003 are explicitly logged as un-contracted (orphan)
acceptance criteria. This is a tracked, pre-existing corpus gap; the resolution is a
dedicated follow-up story (S-QUEUE-BC-1) that will author document-as-is BCs for the
queue command family. Research justification: `.factory/research/jsm-e2e-queue-bc-anchoring-validation.md`.

## Acceptance Criteria

### AC-001 — Queue list shape assertions (VER-JSM-E2E-1 → un-contracted; orphan, tracked)

`test_e2e_jsm_queue_list_shape` is added to `tests/e2e_live.rs` as an `#[ignore]`-gated
function with an `e2e_enabled()` check and the JSM project gate per spec §3.1.

**BC trace: NONE (explicitly logged orphan).** `jr queue list` shipped in an earlier cycle
without a behavioral contract. BC-X.12.001 is a `requesttype` contract — reusing it to
cover queue behavior is a semantically-invalid traceability link (false coverage). The gap is
tracked in follow-up story S-QUEUE-BC-1, which will author document-as-is BCs (BC-X.8.008 /
BC-X.8.009) for the queue command family. Research: `.factory/research/jsm-e2e-queue-bc-anchoring-validation.md`.

**Behavior asserted:**
1. `jr queue list --project <EJ> --output json` exits 0.
2. Stdout parses as a JSON array.
3. If the array is non-empty, every item has a non-null `"id"` field and a non-null,
   non-empty `"name"` string field.
4. An empty array is a valid state (no assertion fires; test passes).

**Clean-skip:** None — empty array passes. If `JR_E2E_JSM_PROJECT` is unset: loud
`eprintln!("[SKIP] …")` and `return` per spec §3.1.

**Verification (VER-JSM-E2E-1, F6):** CI E2E run log for `test_e2e_jsm_queue_list_shape`
shows PASS; no shape assertion fires. (verifies queue list output shape — currently
un-contracted; behavior is empirically verified; contract authoring tracked in S-QUEUE-BC-1)

---

### AC-002 — Requesttype list shape assertions (VER-JSM-E2E-2 → BC-X.12.001)

`test_e2e_jsm_requesttype_list_shape` is added to `tests/e2e_live.rs` as an `#[ignore]`-gated
function.

**Behavior asserted:**
1. `jr requesttype list --project <EJ> --output json` exits 0.
2. Stdout parses as a JSON array.
3. If the array is non-empty, every item has a non-null `"id"` field and a non-null,
   non-empty `"name"` string field.
4. An empty array is a valid state (test passes).

**Clean-skip:** JSM project gate per §3.1.

**Verification (VER-JSM-E2E-2, F6):** CI E2E run log for
`test_e2e_jsm_requesttype_list_shape` shows PASS. (traces to BC-X.12.001 — requesttype
read command output shape)

---

### AC-003 — Queue view by name AND by --id (VER-JSM-E2E-3 → un-contracted; orphan, tracked)

`test_e2e_jsm_queue_view` is added to `tests/e2e_live.rs` as an `#[ignore]`-gated function.

**Output model (F5 correction):** `jr queue view --output json` returns the queue's ISSUES
as a JSON array of issue objects (`"key"` + `"fields"` per element) — NOT a queue identity
object. `handle_view` in `src/cli/queue.rs` outputs `&issues` (`Vec<Issue>`). The routing
value (by-name vs by-id) is validated by both paths succeeding and producing parseable
issue arrays, not by comparing queue `id`/`name` fields in the response.

**Behavior asserted:**
1. Runs `jr queue list --project <EJ> --output json`; parses array.
2. If array is empty → clean-skip with `eprintln!("[SKIP] …")` per spec §3.2.
3. Extracts `first_id` (stringified) and `first_name` (exact string) from `queues[0]`.
4. **By-name path:** `jr queue view "<first_name>" --project <EJ> --output json` exits 0;
   stdout parses as a JSON array; if non-empty, each element has `"key"` and `"fields"`.
   An empty array is a valid pass (queue exists but has zero open issues).
5. **By-id path:** `jr queue view --id <first_id> --project <EJ> --output json` exits 0;
   same issue-array shape assertion. An empty array is valid.
6. 403 responses → clean-skip per spec §3.3.

**DO NOT** assert `"id"` or `"name"` matching in the view response (those fields are
present in `queue list` output, not in `queue view` output).

**BC trace: NONE (explicitly logged orphan).** `jr queue view` shipped in an earlier cycle
without a behavioral contract. See AC-001 orphan note and S-QUEUE-BC-1 follow-up.

**SURFACE guard row added to `tests/e2e_cli_surface_guard.rs`:**
```
(&["queue", "view"], &["--project", "--output", "--id"])
```

**Verification (VER-JSM-E2E-3, F6):** CI log for `test_e2e_jsm_queue_view` shows both
by-name and by-id sub-paths exercised and passing with issue-array shape assertions.
(verifies queue view output shape + `--id` routing branch — currently un-contracted;
contract authoring tracked in S-QUEUE-BC-1)

---

### AC-004 — Requesttype fields shape + numeric-bypass pin (VER-JSM-E2E-4 → BC-X.12.005, BC-3.8.004)

`test_e2e_jsm_requesttype_fields` is added to `tests/e2e_live.rs` as an `#[ignore]`-gated
function.

**Behavior asserted:**
1. Runs `jr requesttype list --project <EJ> --output json`; parses array.
2. If array is empty → clean-skip per spec §3.2.
3. Extracts `first_rt_id` from `rts[0]["id"]`; confirms it is all-ASCII-digit.
4. `jr requesttype fields <first_rt_id> --project <EJ> --output json` exits 0.
5. Response contains a top-level `"fields"` key (array, possibly empty).
6. Because `first_rt_id` is all-ASCII-digit, `src/cli/requesttype.rs` takes the
   numeric-bypass path — no `partial_match` or cache name resolution. This pin validates
   the numeric path end-to-end against real Jira.
7. 403 → clean-skip per spec §3.3.

**SURFACE guard row added:**
```
(&["requesttype", "fields"], &["--project", "--output"])
```

**Verification (VER-JSM-E2E-4, F6):** CI log for `test_e2e_jsm_requesttype_fields`
shows PASS; `"fields"` key present; numeric-bypass path confirmed. (traces to BC-X.12.005
— requesttype fields output shape; BC-3.8.004 — numeric-bypass)

---

### AC-005 — Internal vs external comment visibility round-trip (VER-JSM-E2E-5 → BC-3.5.001, BC-2.4.041)

`test_e2e_jsm_comment_visibility` is added to `tests/e2e_live.rs` as an `#[ignore]`-gated
function.

**Behavior asserted:**
1. Runs `jr requesttype list --project <EJ> --output json`; if empty → clean-skip.
2. Creates a fresh JSM request:
   `jr issue create --project <EJ> --request-type <first_rt_id> --summary "[e2e-jsm-comment <run_id>] visibility round-trip" --output json`.
   Captures `key` from `{"key": "EJ-N"}`.
3. Adds a **public** comment (no flag): `jr issue comment <key> "public comment …"`. Exit 0.
4. Adds an **internal** comment: `jr issue comment <key> "internal comment …" --internal`. Exit 0.
5. Reads back: `jr issue comments <key> --output json`. Exit 0. Parses as JSON array.
6. Asserts at least one comment has `properties[].key == "sd.public.comment"` with
   `value.internal == true` (the internal comment).
7. Asserts at least one comment does NOT have that property as true (the public comment).
   An absent or empty `properties` array on the public comment is acceptable.
8. Self-closes: `jr issue move <key> <JR_E2E_STATUS_DONE:-Done>`. Warning on failure;
   test does NOT fail if close fails (best-effort teardown per spec §6.1).

**Orphan risk:** LOW and accepted — labels do not propagate through `servicedeskapi` to
Jira issue labels; the sweeper cannot cover EJ. Documented explicitly in spec §6.3.
If a test panics between create and close, the EJ issue stays open but is inert.

**SURFACE guard row added:**
```
(&["issue", "comment"], &["--internal", "--output"])
```

**Verification (VER-JSM-E2E-5, F6):** CI log for `test_e2e_jsm_comment_visibility`
shows PASS; EJ issue created and closed; both visibility assertions succeed.
(traces to BC-3.5.001 — `jr issue comment --internal` adds `sd.public.comment` property
write side; BC-2.4.041 — `jr issue comments --output json` exposes `properties[]` array
including `sd.public.comment` for JSM-aware comment display, read side)

---

### AC-006 — issue create --request-type write round-trip (VER-JSM-E2E-6 → BC-3.8.001, BC-3.8.004)

`test_e2e_jsm_create_request_roundtrip` is added to `tests/e2e_live.rs` as an
`#[ignore]`-gated function.

**Behavior asserted:**
1. Runs `jr requesttype list --project <EJ> --output json`; if empty → clean-skip.
2. Extracts `first_rt_id`; confirms all-ASCII-digit.
3. `jr issue create --project <EJ> --request-type <first_rt_id> --summary "[e2e-jsm <run_id>] create round-trip" --output json` exits 0.
4. Stdout parses as JSON; `"key"` field is present, non-empty, starts with `"EJ-"`.
5. `poll_view(key)` — bounded retry of `jr issue view <key> --output json` until exit 0
   (confirms GET-by-key consistency). Response contains `"key"` field equal to `key`.
6. Self-closes: `jr issue move <key> <JR_E2E_STATUS_DONE:-Done>`. Warning on failure;
   test does NOT fail if close fails (best-effort teardown per spec §6.1).
7. 403 on any step → clean-skip per spec §3.3.

**ADR-0014 fork pin:** this test exercises `handle_jsm_create` which dispatches to
`POST /rest/servicedeskapi/request` (NOT `/rest/api/3/issue`). The response type
`JsmRequestCreated` deserializes `issue_key: String`; `handle_jsm_create` emits
`{"key": issue_key}` on stdout. This end-to-end path cannot be validated by mocks.

**SURFACE guard row added:**
```
(&["issue", "create"], &["--request-type", "--project", "--output", "--summary"])
```

**Orphan risk:** same as AC-005 — LOW and accepted (spec §6.3).

**Verification (VER-JSM-E2E-6, F6):** CI log for `test_e2e_jsm_create_request_roundtrip`
shows PASS; ADR-0014 dispatch fork exercised; key captured; `poll_view` resolves;
self-close succeeds. (traces to BC-3.8.001 — `issue create --request-type` write path;
BC-3.8.004 — numeric-bypass used implicitly)

---

### AC-007 — Non-JSM guard exits 64 (VER-JSM-E2E-7 → BC-X.8.004)

`test_e2e_jsm_non_jsm_guard` is added to `tests/e2e_live.rs` as an `#[ignore]`-gated
function. This test does NOT require `JR_E2E_JSM_PROJECT` — it targets the standard
project `JR_E2E_PROJECT` (e.g., `ES`, a Jira Software project).

**Behavior asserted:**
1. `jr queue list --project <ES> --output json` exits with a non-zero exit code.
2. Exit code is specifically 64 (`UserError` per `JrError::exit_code()`).
3. Stderr contains the substring `"Jira Service Management project"` — the
   locale-stable substring of the `require_service_desk` error message per BC-X.8.004.
   The full call-site-labeled phrase depends on the handler; the stable substring is
   asserted rather than the verbatim string to remain resilient to call-site-label
   wording changes.

**No JSM project gate** — this test runs whenever the primary E2E gate is active
(`JR_RUN_E2E=1`), regardless of `JR_E2E_JSM_PROJECT`.

**Verification (VER-JSM-E2E-7, F6):** CI log for `test_e2e_jsm_non_jsm_guard` shows
PASS; exit 64 confirmed; `require_service_desk` error message substring confirmed.
(traces to BC-X.8.004 — `require_service_desk` guard error message shape + exit code)

---

## Rollout Note (Required Post-Merge Operational Step)

**This is a required release/rollout task — document in the PR description.**

After the F4 PR is merged, the 7 new JSM tests will clean-skip on every CI run until
`JR_E2E_JSM_PROJECT=EJ` is set. This is the intended behavior — the variable is the
explicit activation signal.

**Activation steps:**
1. Navigate to `https://github.com/Zious11/jira-cli/settings/environments/jira-e2e`.
2. Under "Environment variables", click "Add variable".
3. Name: `JR_E2E_JSM_PROJECT`, Value: `EJ`.
4. Save. (This is an **environment variable**, NOT a repository variable. `JR_E2E_JSM_PROJECT`
   is consumed inside the running Rust test binary, not in a `jobs.<id>.if:` expression —
   environment-scoping is correct for this use case.)
5. Trigger a `workflow_dispatch` run on `develop`. Confirm the JSM tests appear in the run
   log as executing (not as `[SKIP]`) and all 7 new test functions are present.

**Note:** `JR_E2E_JSM_PROJECT` is already wired in `e2e.yml` (line ~100) as
`JR_E2E_JSM_PROJECT: ${{ vars.JR_E2E_JSM_PROJECT }}` inside the "Run live E2E tests"
step `env:` block. No workflow code change is needed.

## Out of Scope

Per spec §7 (deferred sub-gaps):

- `--on-behalf-of` flag on `issue create --request-type` — requires a second customer
  account on the EJ site; prerequisite not met for this feature.
- `write:servicedesk-request` 401 scope hint (BC-3.8.015) — requires a scope-stripped
  OAuth token; E2E suite authenticates via Basic auth.
- JSM queue/requesttype pagination — EJ has a small number of queues/RTs at free-tier scale.
- `jr requesttype create/delete` — no such command exists (separate feature scope).
- Extending the e2e.yml sweeper to cover EJ — labels do not propagate through
  `servicedeskapi`; sweeper cannot be used for EJ cleanup (spec §6.2, accepted gap).
- Any `Cargo.toml`, `Cargo.lock`, or `deny.toml` changes.
- Any `src/` change.
- BC-INDEX.md, CANONICAL-COUNTS.md — explicitly not changed (BC corpus unchanged).

## Implementation Strategy

**Zero-src delivery order (no Red Gate, no failing-test-first, no demo phase):**

1. **Read `tests/e2e_live.rs` in full** — understand existing JSM test structure
   (`test_e2e_jsm_queue_list_exits_ok`, `test_e2e_jsm_requesttype_list_exits_ok`) and
   `e2e_enabled()` + `e2e_cmd()` helper patterns before any edits.
2. **Read `tests/e2e_cli_surface_guard.rs`** — understand SURFACE table format before
   adding 4 new rows.
3. **Edit `tests/e2e_live.rs`:** Add (or replace) 7 test functions per spec §5.
   - Each function: `#[test]`, `#[ignore]`, opens with `if !e2e_enabled() { return; }`,
     then `JR_E2E_JSM_PROJECT` gate per §3.1 (except Scenario 7).
   - Scenarios 5 and 6: self-close teardown per spec §6.1.
4. **Edit `tests/e2e_cli_surface_guard.rs`:** Add 4 SURFACE rows per spec §10.
5. **Edit `docs/specs/e2e-live-jira-testing.md`** §4 and §8 per spec §10.
6. **Edit `CLAUDE.md`** — add JSM teardown design note per spec §10 and §6.2.
7. **Verify AC boundaries:**
   ```
   git diff --name-only HEAD | grep -E "^src/"
   ```
   Must return empty output.
8. **Run `cargo test --test e2e_cli_surface_guard`** — must exit 0 (new SURFACE rows
   must pass the `test_parser_paths_are_subset_of_surface_table` guard).
9. **Run `cargo test` (non-E2E)** — must exit 0 (no accidental Rust source changes).
10. **Run spec-count guards:**
    ```
    bash scripts/check-spec-counts.sh
    bash scripts/check-bc-cumulative-counts.sh
    bash scripts/check-bc-no-numeric-test-counts.sh
    ```
    All must exit 0 (BC/NFR corpus unchanged).
11. **Commit and push.**

**Branch:** `test/jsm-e2e-coverage` (or `feat/jsm-e2e-coverage-expansion`)
**Target:** `develop`
**Commit message:**
```
test(e2e): add JSM live E2E coverage — queue view, RT fields, comment visibility, create round-trip, non-JSM guard
```

## Quality Gate Self-Check

| Criterion | AC | Verification Command |
|-----------|----|---------------------|
| `test_e2e_jsm_queue_list_shape` present with JSM gate | AC-001 | `grep -n "test_e2e_jsm_queue_list_shape" tests/e2e_live.rs` → ≥1 match |
| `test_e2e_jsm_requesttype_list_shape` present | AC-002 | `grep -n "test_e2e_jsm_requesttype_list_shape" tests/e2e_live.rs` → ≥1 match |
| `test_e2e_jsm_queue_view` present with by-name + by-id paths | AC-003 | `grep -n "test_e2e_jsm_queue_view" tests/e2e_live.rs` → ≥1 match |
| queue view SURFACE row added | AC-003 | `grep -n '"queue", "view"' tests/e2e_cli_surface_guard.rs` → ≥1 match |
| `test_e2e_jsm_requesttype_fields` present with numeric-bypass | AC-004 | `grep -n "test_e2e_jsm_requesttype_fields" tests/e2e_live.rs` → ≥1 match |
| requesttype fields SURFACE row added | AC-004 | `grep -n '"requesttype", "fields"' tests/e2e_cli_surface_guard.rs` → ≥1 match |
| `test_e2e_jsm_comment_visibility` present with self-close | AC-005 | `grep -n "test_e2e_jsm_comment_visibility" tests/e2e_live.rs` → ≥1 match |
| issue comment SURFACE row added with --internal | AC-005 | `grep -n '"issue", "comment"' tests/e2e_cli_surface_guard.rs` → ≥1 match |
| `test_e2e_jsm_create_request_roundtrip` present with ADR-0014 dispatch | AC-006 | `grep -n "test_e2e_jsm_create_request_roundtrip" tests/e2e_live.rs` → ≥1 match |
| issue create --request-type SURFACE row added | AC-006 | `grep -n '"issue", "create"' tests/e2e_cli_surface_guard.rs` → ≥1 match |
| `test_e2e_jsm_non_jsm_guard` present targeting JR_E2E_PROJECT | AC-007 | `grep -n "test_e2e_jsm_non_jsm_guard" tests/e2e_live.rs` → ≥1 match |
| Non-JSM guard asserts exit 64 | AC-007 | `grep -n "64\|UserError" tests/e2e_live.rs` → ≥1 match in guard test |
| Zero `src/` changes | all | `git diff --name-only HEAD \| grep -E "^src/"` → empty |
| `cargo test --test e2e_cli_surface_guard` exits 0 | AC-003/4/5/6 | confirms new SURFACE rows are parseable by guard |
| `cargo test` exits 0 | smoke | no accidental Rust source changes |
| `cargo fmt --all -- --check` exits 0 | lint | no format drift |
| `cargo clippy --all-targets -- -D warnings` exits 0 | lint | zero warnings |
| `bash scripts/check-spec-counts.sh` exits 0 | invariant | BC frontmatter unchanged |
| `bash scripts/check-bc-cumulative-counts.sh` exits 0 | invariant | BC-INDEX.md unchanged |
| `bash scripts/check-bc-no-numeric-test-counts.sh` exits 0 | invariant | no BC body numeric count drift |
| Rollout note in PR description | rollout | maintainer sets JR_E2E_JSM_PROJECT=EJ in jira-e2e env post-merge |

## Token Budget Estimate

| Item | Tokens (approx) |
|------|----------------|
| This story file | ~6 k |
| Design spec `docs/specs/jsm-e2e-coverage.md` (full, ~630 LOC) | ~8 k |
| `tests/e2e_live.rs` current state (read in full before editing) | ~12 k |
| `tests/e2e_cli_surface_guard.rs` relevant section (~80 LOC) | ~2 k |
| `docs/specs/e2e-live-jira-testing.md` §4 + §8 (~60 LOC relevant) | ~2 k |
| `CLAUDE.md` E2E section (~80 LOC relevant) | ~2 k |
| BC files (7 BCs referenced; corpus unchanged — no BC file modified) | 0 |
| Tool outputs (`cargo test`, `cargo clippy`, grep verifications, script exits) | ~3 k |
| **Total** | **~35 k** |

Well within a single-agent context window (~200 k). No split required.
LOC delta: `tests/e2e_live.rs` +~200 LOC (7 test fns); `tests/e2e_cli_surface_guard.rs`
+~12 LOC (4 SURFACE rows); `docs/specs/e2e-live-jira-testing.md` +~15 LOC;
`CLAUDE.md` +~10 LOC. Zero `src/` LOC changes.

## Tasks

- [ ] Read `tests/e2e_live.rs` in full — understand `e2e_enabled()`, `e2e_cmd()`, existing JSM test structure (`test_e2e_jsm_queue_list_exits_ok`, `test_e2e_jsm_requesttype_list_exits_ok`), and `poll_view` helper pattern before any edits
- [ ] Read `tests/e2e_cli_surface_guard.rs` — understand SURFACE table format (`(&["subcommand", "sub"], &["--flag1", "--flag2"])`) and `test_parser_paths_are_subset_of_surface_table` before adding rows
- [ ] Read `docs/specs/jsm-e2e-coverage.md` §3 (clean-skip policy), §4 (dynamic discovery), §5 (all 7 scenarios) and §6 (teardown) — normative source for test logic
- [ ] Add `test_e2e_jsm_queue_list_shape` to `tests/e2e_live.rs` — `#[test]`+`#[ignore]`, `e2e_enabled()` check, `JR_E2E_JSM_PROJECT` gate, queue list + per-item field assertions (AC-001)
- [ ] Add `test_e2e_jsm_requesttype_list_shape` to `tests/e2e_live.rs` — same gates; requesttype list + per-item field assertions (AC-002)
- [ ] Add `test_e2e_jsm_queue_view` to `tests/e2e_live.rs` — same gates; dynamic discovery from queue list; by-name + by-id assertions; empty-list skip; 403 skip (AC-003)
- [ ] Add `test_e2e_jsm_requesttype_fields` to `tests/e2e_live.rs` — same gates; dynamic RT id from RT list; confirm all-ASCII-digit; `requesttype fields <id>`; `"fields"` key assertion; 403 skip (AC-004)
- [ ] Add `test_e2e_jsm_comment_visibility` to `tests/e2e_live.rs` — same gates; create EJ request; add public + internal comments; read back `jr issue comments --output json`; assert `sd.public.comment` property; self-close teardown with warning-on-failure (AC-005)
- [ ] Add `test_e2e_jsm_create_request_roundtrip` to `tests/e2e_live.rs` — same gates; create EJ request via `--request-type`; assert `{"key": "EJ-N"}`; `poll_view(key)`; assert key prefix; self-close teardown (AC-006)
- [ ] Add `test_e2e_jsm_non_jsm_guard` to `tests/e2e_live.rs` — `e2e_enabled()` check ONLY (no JSM project gate); `jr queue list --project <JR_E2E_PROJECT> --output json`; assert exit 64; assert stderr contains `"Jira Service Management project"` (AC-007)
- [ ] Verify all 7 new test functions use `#[test]` + `#[ignore]` decorators
- [ ] Verify `test_e2e_jsm_non_jsm_guard` does NOT include the `JR_E2E_JSM_PROJECT` gate (it runs whenever E2E is active)
- [ ] Add 4 SURFACE rows to `tests/e2e_cli_surface_guard.rs`: `queue view`, `requesttype fields`, `issue comment`, `issue create` with their flags per spec §10 (AC-003, AC-004, AC-005, AC-006)
- [ ] Run `cargo test --test e2e_cli_surface_guard` — must exit 0 to confirm new SURFACE rows are valid
- [ ] Update `docs/specs/e2e-live-jira-testing.md` §4 — add all 7 new test function names to the JSM "Optional / feature-flagged" entry; note that queue view, requesttype fields, comment visibility, and create round-trip are now covered
- [ ] Update `docs/specs/e2e-live-jira-testing.md` §8 — update `JR_E2E_JSM_PROJECT` row notes: value is `EJ`; teardown is self-close in test body (not sweeper); labels do not propagate from servicedeskapi
- [ ] Update `CLAUDE.md` AI Agent Notes E2E section — add JSM teardown design convention: self-close in test body, not label-sweeper, because labels do not propagate through servicedeskapi to Jira issue labels; cite spec §6.2
- [ ] Verify `git diff --name-only HEAD | grep -E "^src/"` → empty output (zero src/ changes)
- [ ] Run `cargo test` — exits 0 (confirms no accidental Rust source changes)
- [ ] Run `cargo fmt --all -- --check` — exits 0
- [ ] Run `cargo clippy --all-targets -- -D warnings` — exits 0
- [ ] Run `bash scripts/check-spec-counts.sh && bash scripts/check-bc-cumulative-counts.sh && bash scripts/check-bc-no-numeric-test-counts.sh` — all exit 0
- [ ] Confirm PR description includes rollout note: maintainer must set `JR_E2E_JSM_PROJECT=EJ` as environment variable in `jira-e2e` GitHub Environment post-merge
- [ ] Commit: `test(e2e): add JSM live E2E coverage — queue view, RT fields, comment visibility, create round-trip, non-JSM guard`

## Previous Story Intelligence

**Predecessor: S-E2E-1 (PR #433)** — established the live E2E framework: `tests/e2e_live.rs`,
`e2e_enabled()`, `e2e_cmd()`, `poll_view()` helpers, and `.github/workflows/e2e.yml`. The
`JR_E2E_JSM_PROJECT` env var was wired in `e2e.yml` from the start (but not yet activated
with a project value). The two existing shallow JSM tests (`test_e2e_jsm_queue_list_exits_ok`,
`test_e2e_jsm_requesttype_list_exits_ok`) were added in S-E2E-1 as stubs — this story
deepens or replaces them.

**Predecessor: S-E2E-FORK-1 (PR #459)** — added the `JR_E2E_ENABLED` repo-var gate and the
two-layer E2E model. `JR_E2E_JSM_PROJECT` (environment-scoped variable) is distinct from
`JR_E2E_ENABLED` (repository-level variable). The JSM variable is consumed inside the Rust
test binary, not in `jobs.<id>.if:`, so environment-scoping is correct.

**Key lessons from S-E2E-3/4/5 (M1-M3 assertion depth):** dynamic discovery from list output
is the proven pattern — extract `queues[0]` or `rts[0]` and use exact values. Always include
an explicit `if <list>.is_empty() { eprintln!("[SKIP]…"); return; }` guard immediately after
parsing the list. Self-close teardown must be unconditional (always runs at end of function)
with `eprintln!("[WARN]…")` on failure — never `panic!` or `assert!` on the close step.

**Architecture constraint (spec §6.2):** labels inserted via `JsmRequestBuilder::build()`
in `src/api/jsm/requests.rs` do NOT reliably propagate to the Jira issue's `labels` field.
Do NOT attempt to use the label-based sweeper for EJ cleanup. Self-close is the only
reliable teardown mechanism for JSM write tests.

## Architecture Compliance Rules

1. **Zero `src/` changes.** If any `src/` file is added to the diff, STOP and escalate.
   This story is entirely `tests/` + documentation changes.

2. **`JR_E2E_JSM_PROJECT` gate per §3.1 is mandatory in every JSM test except Scenario 7.**
   Omitting the gate means JSM tests run in environments without the variable and immediately
   fail (cannot find EJ project). The gate must be the FIRST thing in the test body after
   `e2e_enabled()`.

3. **Self-close is best-effort — never `assert!` on teardown step.** If `jr issue move <key> Done`
   fails, emit `eprintln!("[WARN]…")` and return. The test MUST NOT fail on close failure.
   The assertion is on create/comment/read behavior, not teardown.

4. **Dynamic discovery over hardcoded fixtures.** Do not introduce new `JR_E2E_*` env vars for
   queue IDs or RT IDs. Parse them from live list output per spec §4.1 and §4.2.

5. **SURFACE guard rows must use the correct flag set.** The SURFACE table in
   `tests/e2e_cli_surface_guard.rs` validates that the flags used in `e2e_live.rs` exist on
   the CLI surface. Use the minimum correct set — do not add flags that aren't exercised by
   the corresponding test functions.

6. **BC corpus must remain unchanged.** Do NOT edit `BC-INDEX.md`, `CANONICAL-COUNTS.md`,
   or any `.factory/specs/prd/bc-*.md` file. Run the three spec-count guards to confirm.

7. **`docs/specs/jsm-e2e-coverage.md` is NOT modified.** It is the F2 spec (source of truth);
   implementation (F4) only modifies the 4 files listed in `files_modified`. The spec is an
   input artifact, not an output.

## Library & Framework Requirements

No new `Cargo.toml` dependencies. Zero Rust library additions.

| Tool/Crate | Already available | Usage in this story |
|------------|------------------|---------------------|
| `serde_json` | Yes (dev-dependency in tests) | Parse `--output json` responses in new test fns |
| `std::process::Command` via `e2e_cmd()` | Yes (e2e_live.rs helper) | Invoke `jr` binary in each test |
| `std::env::var("JR_E2E_JSM_PROJECT")` | Yes (stdlib) | JSM project gate per §3.1 |

## File Structure Requirements

| File | Action | Notes |
|------|--------|-------|
| `tests/e2e_live.rs` | MODIFY | Add 7 `#[ignore]`-gated test functions (Scenarios 1-7); replace or supplement existing 2 shallow JSM tests |
| `tests/e2e_cli_surface_guard.rs` | MODIFY | Add 4 SURFACE rows: `queue view`, `requesttype fields`, `issue comment`, `issue create` |
| `docs/specs/e2e-live-jira-testing.md` | MODIFY | §4 update JSM test fn list; §8 update `JR_E2E_JSM_PROJECT` row notes |
| `CLAUDE.md` | MODIFY | Add JSM teardown design convention in AI Agent Notes E2E section |

**Files confirmed NOT changed:**
- `src/` (all files — zero Rust source changes confirmed in F1)
- `.github/workflows/e2e.yml` (wiring already exists; `JR_E2E_JSM_PROJECT` already mapped at line ~100)
- `.github/workflows/ci.yml`, `.github/workflows/release.yml`, `.github/workflows/e2e-sweeper.yml`
- `Cargo.toml`, `Cargo.lock`, `deny.toml`, `.cargo/mutants.toml`
- `scripts/`, `.factory/specs/` (no BC, PRD, or architecture change)
- `BC-INDEX.md`, `CANONICAL-COUNTS.md`
- `docs/specs/jsm-e2e-coverage.md` (input artifact — not modified by F4)

## Branch / PR Plan

- Branch: `test/jsm-e2e-coverage` (or `feat/jsm-e2e-coverage-expansion`)
- Target: `develop`
- Commit: `test(e2e): add JSM live E2E coverage — queue view, RT fields, comment visibility, create round-trip, non-JSM guard`
- PR body: reference this story (S-JSM-E2E-1), design spec §5 (7 scenarios) and §10
  (F4 touch-point list), and the rollout note (maintainer must set `JR_E2E_JSM_PROJECT=EJ`
  in the `jira-e2e` GitHub Environment post-merge)
- CHANGELOG entry: Add under `[Unreleased]` — "Added 7 JSM live E2E tests (`test_e2e_jsm_queue_list_shape`,
  `test_e2e_jsm_requesttype_list_shape`, `test_e2e_jsm_queue_view`, `test_e2e_jsm_requesttype_fields`,
  `test_e2e_jsm_comment_visibility`, `test_e2e_jsm_create_request_roundtrip`,
  `test_e2e_jsm_non_jsm_guard`) and 4 CLI SURFACE guard rows. All JSM tests gate on
  `JR_E2E_JSM_PROJECT` and clean-skip when unset. Maintainer: set `JR_E2E_JSM_PROJECT=EJ`
  in the `jira-e2e` GitHub Environment to activate."
- **PR description MUST include the rollout note**: set `JR_E2E_JSM_PROJECT=EJ` in the
  `jira-e2e` GitHub Environment (environment variable, not repository variable).
