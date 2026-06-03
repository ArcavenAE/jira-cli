---
document_type: story
story_id: "S-JSM-E2E-3"
title: "JSM resolution enforcement E2E — positive + bypass-demo dual-path + teardown improvement"
wave: feature-followup
status: ready
intent: test
feature_type: test
scope: small
severity: small
trivial_scope: false
issue: TBD
points: 3
priority: P1
tdd_mode: facade
estimated_effort: small
mode: feature
depends_on:
  - S-JSM-E2E-1
  - S-JSM-E2E-2
blocks: []
bc_anchors:
  - BC-3.2.011
  - BC-3.2.010
  - BC-2.3.036
  - BC-3.2.009
bcs:
  - BC-3.2.011
  - BC-3.2.010
  - BC-2.3.036
  - BC-3.2.009
verification_properties:
  - VER-JSM-E2E-8
holdout_anchors: []
nfr_anchors: []
adr_refs:
  - ADR-0014
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: "docs/specs/jsm-e2e-coverage.md §5 (Scenario 8) + §6 (teardown improvement) + §8 (VER-JSM-E2E-8)"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 6
assumption_validations: []
risk_mitigations: []
created: "2026-06-02"
last_updated: "2026-06-02"
traceability_note: >
  This story exercises EXISTING product BCs via a new live E2E scenario — no BC is
  created or modified. BC corpus (585 BCs) and NFR corpus (41 NFRs) are EXPLICITLY
  UNCHANGED. No new BC file; no existing BC modified; BC-INDEX.md unchanged.
  The resolution enforcement scenario reveals a real JSM behavior gap: the JSM UI
  enforces a resolution field on close transitions, but the REST API permits bypass
  (transition succeeds with resolution=null). Both paths are valid observable outcomes
  and must be handled robustly by the test. AC-001 tests the positive (correct) path
  (BC-3.2.011 + BC-3.2.010 + BC-2.3.036); AC-002 tests the bypass-demo path
  (BC-2.3.036 + BC-3.2.009); AC-003 improves the existing jsm_self_close teardown
  to pass --resolution discovered dynamically.
files_modified:
  - tests/e2e_live.rs                     # MODIFIED — add test_e2e_jsm_resolution_enforcement + improve jsm_self_close
  - tests/e2e_cli_surface_guard.rs        # MODIFIED — add --resolution to issue move row; add issue resolutions row
  - docs/specs/jsm-e2e-coverage.md        # MODIFIED — §5 Scenario 8; §6 teardown improvement; §8 VER-JSM-E2E-8
  - docs/specs/e2e-live-jira-testing.md   # MODIFIED — new test function name; JR_E2E_JSM_RESOLUTION env note
  - CLAUDE.md                             # MODIFIED — teardown note updated for --resolution; JR_E2E_JSM_RESOLUTION
breaking_change: false
changelog:
  - date: "2026-06-02"
    phase: F3-story-decomposition
    author: story-writer
    summary: >
      Initial story creation. Zero-src E2E: JSM resolution enforcement scenario.
      Positive path (--resolution sets resolution atomically via BC-3.2.011);
      bypass-demo path (no --resolution → null or 400 per BC-2.3.036/BC-3.2.009);
      teardown improvement (jsm_self_close now discovers and passes --resolution via
      JR_E2E_JSM_RESOLUTION override or jr issue resolutions list). F1/F2/F3 folded.
      S-JSM-E2E-3 ready for F4 dispatch.
---

# S-JSM-E2E-3 — JSM Resolution Enforcement E2E

## Source of Truth

Design spec: `docs/specs/jsm-e2e-coverage.md` §5 Scenario 8 (new), §6 (teardown improvement),
§8 VER-JSM-E2E-8 (new).

**No new BCs. BC corpus (585) and NFR corpus (41) are EXPLICITLY UNCHANGED.
Changes touch `tests/e2e_live.rs`, `tests/e2e_cli_surface_guard.rs`,
`docs/specs/jsm-e2e-coverage.md`, `docs/specs/e2e-live-jira-testing.md`, and `CLAUDE.md`.
Zero `src/` changes.**

## Behavioral Contracts

| BC | Title | Role in this story |
|----|-------|-------------------|
| BC-3.2.011 | `transition_issue(key, id, Some(&fields))` body contains `{transition:{id}, fields:{resolution:{name}}}` | Positive path: --resolution atomically sets the resolution field in the transition body |
| BC-3.2.010 | `issue resolutions` reads cache-first (7d TTL); JSON: `[{name, id, description}]` | Resolution discovery: `jr issue resolutions --output json` returns the list used to pick a resolution name |
| BC-2.3.036 | `get_issue` deserializes nullable `resolution` field | Read-back assertion: `jr issue view --output json` exposes `fields.resolution` (non-null if set, null if bypass) |
| BC-3.2.009 | `issue move` 400 "resolution required" → `--resolution` hint + `jr issue resolutions` pointer | Enforcement path: if the EJ workflow validates resolution at the API level, the 400 body triggers the --resolution hint on stderr |

## Domain Context

In JSM, resolving or canceling a ticket typically requires a resolution value. The Jira UI
enforces this on the transition screen. However, the REST API (`POST /rest/api/3/issue/{key}/transitions`)
allows the transition to succeed even when no resolution is provided — the issue transitions
to the done-category status but `fields.resolution` is left null.

`jr issue move` supports this feature via `--resolution <name>`:
- With `--resolution`: `transition_issue` sends `{transition:{id}, fields:{resolution:{name}}}` (BC-3.2.011).
- Without `--resolution`: `transition_issue` sends `{transition:{id}}` (no fields key — BC-3.2.012). If the
  workflow enforces resolution at the API level, Jira returns HTTP 400 with
  `{errors:{resolution:"Field 'resolution' is required"}}` → `jr issue move` exits non-zero and emits
  the `--resolution` hint on stderr (BC-3.2.009). If the workflow does NOT enforce at the API level (the
  common EJ behavior), the move succeeds but `fields.resolution` is null (BC-2.3.036).

`jr issue resolutions --output json` lists all instance resolutions as `[{name, id, description}]`
from the resolutions cache (BC-3.2.010). This enables the test to dynamically discover a valid
resolution name without hardcoding.

## Story Narrative

As a jr maintainer,
I want a live E2E scenario that exercises JSM resolution enforcement —
both the positive path (resolution provided → set, verified on read-back) and the bypass-demo
path (no resolution → null OR 400 with enforcement hint) — so that the `--resolution` flag on
`jr issue move` and the `jr issue resolutions` discovery command are covered by a live workflow
execution against real Jira.

As a fork contributor,
I want the teardown helper `jsm_self_close` to pass `--resolution` when closing EJ issues,
so that nightly runs produce properly resolved tickets rather than issues that are closed via
API bypass (resolution=null).

## Dependency Justification

**`depends_on: [S-JSM-E2E-1]`** — S-JSM-E2E-1 introduced the JSM E2E infrastructure
(`JR_E2E_JSM_PROJECT` gate, `jsm_self_close` helper skeleton, `tests/e2e_live.rs` JSM sections).

**`depends_on: [S-JSM-E2E-2]`** — S-JSM-E2E-2 introduced `jsm_self_close` with dynamic
transition discovery. This story extends that helper to also pass `--resolution`; the extension
must apply to the version delivered by S-JSM-E2E-2, not the original S-JSM-E2E-1 skeleton.
S-JSM-E2E-2 is ready (F3 complete, 2026-06-02); this story is written as its immediate successor.

**`blocks: []`** — no current story depends on resolution enforcement E2E to proceed.

## Goal

1. Add `test_e2e_jsm_resolution_enforcement` to `tests/e2e_live.rs`:
   - Create two EJ JSM requests (two fixture keys).
   - POSITIVE path: discover a resolution name via `jr issue resolutions --output json`
     (take first; honor `JR_E2E_JSM_RESOLUTION` override). Move the first issue to a
     done-category transition WITH `--resolution <R>`. Assert exit 0. Read back via
     `jr issue view --output json`. Assert `fields.resolution.name == R`.
   - BYPASS-DEMO path: move the second issue to the same done-category transition WITHOUT
     `--resolution`. Dual-path: if exit 0 → assert `fields.resolution` is null (API bypass).
     If exit non-zero AND stderr mentions "resolution" → assert the `--resolution` hint
     is present (enforcement path per BC-3.2.009). Both outcomes are acceptable; the test
     records the observed behavior via `eprintln!("[INFO] …")`.

2. Improve `jsm_self_close` to discover a resolution and pass `--resolution <R>` on the
   close move. Best-effort: if resolution discovery fails (empty list, non-zero exit,
   JSON parse error), fall back to closing without `--resolution` (existing behavior)
   and emit `eprintln!("[WARN] jsm_self_close: resolution discovery failed …")`.

3. Add SURFACE rows for `--resolution` on `issue move` and for the `issue resolutions` command.

4. Update spec and docs per AC-006.

## Acceptance Criteria

### AC-001 — POSITIVE: resolution provided → resolved, verified on read-back
(traces to BC-3.2.011 postcondition, BC-3.2.010 behavior, BC-2.3.036 behavior)

**Precondition:** `JR_E2E_JSM_PROJECT` is set. A done-category transition is discoverable on
the EJ issue via `jr issue transitions --output json` (same probe as `jsm_self_close`).
`jr issue resolutions --output json` returns a non-empty array.

**Assertion sequence:**
1. A fresh EJ JSM request is created; `key_positive` is captured from stdout.
2. `jr issue resolutions --output json` exits 0; response is a non-empty JSON array with
   at least one item having a non-null `"name"` field. Pick `resolution_name =
   env("JR_E2E_JSM_RESOLUTION").unwrap_or_else(|| resolutions[0]["name"].as_str())`.
3. A short-lived PROBE EJ JSM request is created; `jr issue transitions <probe_key> --output json`
   is run to find a transition where `to.statusCategory.key == "done"`; the probe is immediately
   self-closed via `jsm_self_close` before any further action. The discovered done-category status
   name is used for steps 4 and 6. (This is a dedicated probe ticket distinct from `key_positive`
   and `key_bypass` — up to 3 EJ tickets are created per run, all best-effort self-closed.)
4. `jr issue move <key_positive> <transition_name> --resolution <resolution_name>` exits 0.
5. `jr issue view <key_positive> --output json` exits 0; response parses as JSON;
   `response["fields"]["resolution"]["name"]` equals `resolution_name`.

**Clean-skip conditions:**
- `JR_E2E_JSM_PROJECT` unset → skip.
- Resolutions list empty → `eprintln!("[SKIP] …")` + return (cannot run positive test).
- Probe create fails (including 403) → `eprintln!("[SKIP] …")` + return.
- Done-category transition not found on probe → `eprintln!("[SKIP] …")` + return (probe already self-closed).
- `key_positive` or `key_bypass` create fails → `eprintln!("[SKIP] …")` + return; self-close any already-captured key.
- 403 on any other step → `eprintln!("[SKIP] …")` + return.

**No split on read-back lag:** `jr issue view` read-back is attempted with a bounded retry
loop (max 5 attempts, 250 ms → 2 000 ms backoff); on budget exhaustion, `[WARN]` and skip
the view assertion (consistent with S-JSM-E2E-1 Scenario 6 pattern).

---

### AC-002 — BYPASS-DEMO: no resolution → null or 400-enforcement, dual-path robust
(traces to BC-2.3.036 behavior — nullable resolution; BC-3.2.009 postcondition — enforcement hint)

**Precondition:** Same gate as AC-001. A second fresh EJ JSM request is created; `key_bypass`
is captured.

**Assertion sequence:**
1. A fresh EJ JSM request is created; `key_bypass` is captured.
2. `jr issue move <key_bypass> <transition_name>` (same transition, WITHOUT `--resolution`)
   is run.
3. **DUAL-PATH:**
   - **Branch A — API bypass (expected EJ behavior):** exit 0. Then
     `jr issue view <key_bypass> --output json` exits 0; `response["fields"]["resolution"]`
     is JSON null. Emit `eprintln!("[INFO] BYPASS: EJ workflow permits resolution=null")`.
   - **Branch B — API enforcement (if EJ workflow validates resolution):** exit non-zero AND
     stderr contains `"resolution"`. Assert that stderr also contains `"--resolution"` (the
     `jr issue move` hint from BC-3.2.009). Emit
     `eprintln!("[INFO] ENFORCE: EJ workflow rejects no-resolution via API 400")`.
4. Neither branch fails the test — both are valid observable outcomes.

**Teardown:** Both `key_positive` and `key_bypass` are self-closed via `jsm_self_close`
regardless of bypass/enforcement outcome. If `key_bypass` already transitioned (Branch A),
`jsm_self_close` is a no-op (issue already in done-category). Best-effort: close failure
emits `[WARN]` and continues.

**Clean-skip conditions:** same as AC-001 (any create failure → skip entire function before
creating a second issue; after first key captured, proceed with dual-path regardless).

---

### AC-003 — jsm_self_close improved: discovers resolution and passes --resolution
(traces to BC-3.2.010 behavior — resolutions list; BC-3.2.011 postcondition — field in body)

`jsm_self_close(key, h)` (introduced by S-JSM-E2E-2) is extended with a resolution
discovery step:

**Extended behavior asserted:**
1. After selecting the done-category transition (existing behavior), the helper runs
   `jr issue resolutions --output json`.
2. If the command exits 0 and the response is a non-empty JSON array with at least one
   item having a `"name"` string field:
   a. Pick `resolution_name = env("JR_E2E_JSM_RESOLUTION").unwrap_or_else(|| first_name)`.
   b. Run `jr issue move <key> <transition_name> --resolution <resolution_name>`.
3. If resolution discovery fails for any reason (non-zero exit, JSON parse error, empty
   list, no `"name"` field), fall back to `jr issue move <key> <transition_name>` (no
   `--resolution`) — the existing S-JSM-E2E-2 behavior.
4. All failure branches (resolution step or final move) emit `eprintln!("[WARN] jsm_self_close: …")`
   and return without panicking. Best-effort contract is PRESERVED.

**Verification:**
- `grep -n "resolutions" tests/e2e_live.rs | grep jsm_self_close` returns at least one match.
- `grep -n "JR_E2E_JSM_RESOLUTION" tests/e2e_live.rs` returns at least one match.

---

### AC-004 — Clean-skip policy: no JR_E2E_JSM_PROJECT, empty resolutions, 403 → loud skip, never fail
(traces to BC-2.3.036 invariant — nullable fields never panic; BC-3.2.009 — non-zero treated as clean)

`test_e2e_jsm_resolution_enforcement` correctly implements all clean-skip conditions:

1. `JR_E2E_JSM_PROJECT` unset → `eprintln!("[SKIP] …")` + return immediately.
2. `jr issue resolutions --output json` returns empty array → `eprintln!("[SKIP] …")` + return.
3. Either create call fails (non-zero exit) → `eprintln!("[SKIP] …")` + return; self-close any
   already-created keys before returning.
4. 403 on any step → `eprintln!("[SKIP] …")` + continue/return (best-effort).
5. Both created tickets are self-closed via `jsm_self_close` on all exit paths (including
   skip paths after first key was captured).
6. The function does NOT assert WHICH bypass branch fires (Branch A vs Branch B is a
   live-instance observation, not a required outcome). But WITHIN whichever branch is
   observed, the branch's documented invariant IS asserted:
   - **Branch A** (move exit 0): `assert!(fields.resolution.is_null())` — API bypass confirmed.
   - **Branch B** (move exit != 0 with stderr containing `"resolution"`): `assert!(stderr.contains("--resolution"))` — enforcement hint confirmed (BC-3.2.009).
   - **Unclassified non-zero** (exit != 0 but stderr does not mention `"resolution"`): `eprintln!("[WARN] …")`, no hard-fail.
   No `panic!`, `assert!`, or `unwrap()` may appear outside these two branches on the
   move exit code selection itself (i.e., the branch dispatch is observation-only).

---

### AC-005 — SURFACE rows updated
(traces to BC-3.2.010 postcondition — `issue resolutions` is a CLI surface; BC-3.2.011 — `--resolution` is a flag)

`tests/e2e_cli_surface_guard.rs` SURFACE static table is updated:

1. The existing `issue move` row `(&["issue", "move"], &[…])` gains `"--resolution"` in its
   flags slice. Exact existing row identified and updated — NOT a new row.
2. A NEW row is added: `(&["issue", "resolutions"], &["--output"])`.

**Verification:**
- `cargo test --test e2e_cli_surface_guard` exits 0.
- `grep -n "resolutions" tests/e2e_cli_surface_guard.rs` returns at least one match.
- `grep -n '"--resolution"' tests/e2e_cli_surface_guard.rs` returns at least one match.

---

### AC-006 — Docs updated: spec §5 Scenario 8, §6 teardown, §8 VER-JSM-E2E-8; CLAUDE.md; e2e-live-jira-testing.md
(traces to BC-3.2.010 behavior — discovery command documented; BC-3.2.011 — --resolution flag documented)

All documentation changes are applied. Zero `src/` changes confirmed.

**`docs/specs/jsm-e2e-coverage.md`:**
- §5 gains "Scenario 8 — Resolution enforcement" (positive + bypass-demo, dual-path robustness,
  clean-skip conditions, VER-JSM-E2E-8 trace, BC anchors BC-3.2.011/BC-3.2.010/BC-2.3.036/BC-3.2.009).
- §6.1 is updated with a note that `jsm_self_close` now discovers and passes `--resolution`
  (best-effort; falls back to no-resolution if discovery fails); `JR_E2E_JSM_RESOLUTION`
  override documented.
- §8 gains VER-JSM-E2E-8 (resolution enforcement: positive path assertion + bypass-demo
  dual-path robustness).
- §2.2 BC-map table gains rows for BC-3.2.011, BC-3.2.010, BC-2.3.036, and BC-3.2.009.

**`docs/specs/e2e-live-jira-testing.md`:**
- `JR_E2E_JSM_RESOLUTION` is added to the optional env-var table with description:
  "Resolution name for JSM move teardown; if unset, first result from `jr issue resolutions`
  is used. Used by `jsm_self_close` and `test_e2e_jsm_resolution_enforcement`."
- The JSM test function list is updated to include `test_e2e_jsm_resolution_enforcement`.

**`CLAUDE.md`:**
- The JSM E2E teardown convention note (added by S-JSM-E2E-2) is updated to mention that
  `jsm_self_close` now also discovers a resolution via `jr issue resolutions --output json`
  and passes `--resolution <R>` atomically; `JR_E2E_JSM_RESOLUTION` override documented.

**Zero `src/` changes:**
- `git diff --name-only HEAD | grep -E "^src/"` → empty output.
- `BC-INDEX.md`, `CANONICAL-COUNTS.md`, `.factory/specs/prd/bc-*.md` — NOT modified.

---

## Behavioral Contracts Body Table

| BC | Relevance |
|----|-----------|
| BC-3.2.011 | Positive path: `jr issue move ... --resolution R` sends `{fields:{resolution:{name:R}}}` in the transition body, producing a resolved issue on read-back (AC-001) |
| BC-3.2.010 | Resolution discovery: `jr issue resolutions --output json` returns `[{name, id, description}]`; first `name` is used unless overridden by `JR_E2E_JSM_RESOLUTION` (AC-001, AC-003) |
| BC-2.3.036 | Read-back: `get_issue` deserializes nullable `resolution` — non-null when set (AC-001), null when API bypass succeeds (AC-002 Branch A) |
| BC-3.2.009 | Enforcement: if EJ workflow validates resolution at API level, 400 body triggers `--resolution` hint on stderr (AC-002 Branch B) |

---

## Rollout Note

No new GitHub Environment variable is required in the CI environment to run the test. The test
gracefully discovers a resolution from `jr issue resolutions --output json`. If a specific
resolution is preferred for the teardown (e.g., "Done" vs "Fixed"), set
`JR_E2E_JSM_RESOLUTION` as an environment variable in the `jira-e2e` GitHub Environment.
This is optional — the test works with any resolution from the live instance's list.

## Out of Scope

- Any `src/` change.
- Adding `--field-on-transition` to `jr issue move` — that is a separate product feature.
- Extending the e2e.yml sweeper to cover EJ — remains an accepted gap (spec §6.2).
- Adding a required-resolution workflow enforcement gate to the EJ project — that is a
  Jira admin action outside the jr codebase scope.
- BC-INDEX.md, CANONICAL-COUNTS.md — explicitly not changed.

## Implementation Strategy

**Zero-src delivery order (no Red Gate, no failing-test-first, no demo phase):**

1. **Read `tests/e2e_live.rs`** — locate `jsm_self_close` (added by S-JSM-E2E-2), the
   harness pattern (`e2e_cmd`, any `E2EHarness` or helper), and the last JSM test function
   (Scenario 7 = `test_e2e_jsm_non_jsm_guard`) to determine insertion point.
2. **Read `tests/e2e_cli_surface_guard.rs`** — locate the `issue move` SURFACE row and
   confirm whether `--resolution` is already present; locate `issue resolutions` or confirm
   it is absent.
3. **Edit `tests/e2e_live.rs`:**
   a. Extend `jsm_self_close`: add resolution discovery after transition discovery; run
      `jr issue resolutions --output json`; pick first name (or env override); pass
      `--resolution <R>` to `jr issue move`; fall back on any failure.
   b. Add `test_e2e_jsm_resolution_enforcement` per AC-001/AC-002/AC-004 design.
4. **Edit `tests/e2e_cli_surface_guard.rs`:**
   a. Add `"--resolution"` to the `issue move` row.
   b. Add new row `(&["issue", "resolutions"], &["--output"])`.
5. **Edit `docs/specs/jsm-e2e-coverage.md`** per AC-006 (§5 Scenario 8, §6.1 teardown note,
   §8 VER-JSM-E2E-8, §2.2 BC-map rows).
6. **Edit `docs/specs/e2e-live-jira-testing.md`** per AC-006.
7. **Edit `CLAUDE.md`** per AC-006.
8. **Verify AC boundaries:**
   ```
   git diff --name-only HEAD | grep -E "^src/"
   ```
   Must return empty output.
9. **Run `cargo test --test e2e_cli_surface_guard`** — must exit 0.
10. **Run `cargo test` (non-E2E)** — must exit 0.
11. **Run spec-count guards:**
    ```
    bash scripts/check-spec-counts.sh
    bash scripts/check-bc-cumulative-counts.sh
    bash scripts/check-bc-no-numeric-test-counts.sh
    ```
    All must exit 0.
12. **Commit and push.**

**Branch:** `feat/jsm-e2e-resolution-enforcement`
**Target:** `develop`
**Commit message:**
```
test(e2e): JSM resolution enforcement scenario + jsm_self_close --resolution (S-JSM-E2E-3)
```

## Quality Gate Self-Check

| Criterion | AC | Verification Command |
|-----------|----|---------------------|
| `test_e2e_jsm_resolution_enforcement` added | AC-001/AC-002 | `grep -n "test_e2e_jsm_resolution_enforcement" tests/e2e_live.rs` → ≥1 match |
| Positive path asserts `fields.resolution.name == R` | AC-001 | Code review: `fields["resolution"]["name"]` equality check |
| Bypass-demo path dual-branch (exit-0 → null; exit-non-zero + "resolution" → hint) | AC-002 | Code review: both branches present; neither `panic!`s |
| `jsm_self_close` calls `jr issue resolutions` | AC-003 | `grep -n "resolutions" tests/e2e_live.rs \| grep jsm_self_close` → ≥1 match |
| `jsm_self_close` uses `JR_E2E_JSM_RESOLUTION` env var | AC-003 | `grep -n "JR_E2E_JSM_RESOLUTION" tests/e2e_live.rs` → ≥1 match |
| `jsm_self_close` falls back without `--resolution` on discovery failure | AC-003 | Code review: eprintln warn + fallback path present |
| No `panic!`/`assert!`/`unwrap()` on move/view in bypass branch | AC-004 | Code review: only `eprintln!`/`return` on failure |
| `--resolution` added to `issue move` SURFACE row | AC-005 | `grep -n '"--resolution"' tests/e2e_cli_surface_guard.rs` → ≥1 match |
| `issue resolutions` row added to SURFACE | AC-005 | `grep -n "resolutions" tests/e2e_cli_surface_guard.rs` → ≥1 match |
| `cargo test --test e2e_cli_surface_guard` exits 0 | AC-005 | confirms no broken SURFACE entries |
| `docs/specs/jsm-e2e-coverage.md` §5 Scenario 8 added | AC-006 | `grep -n "Scenario 8\|resolution_enforcement" docs/specs/jsm-e2e-coverage.md` → ≥1 match |
| `docs/specs/jsm-e2e-coverage.md` §6.1 teardown note updated | AC-006 | `grep -n "JR_E2E_JSM_RESOLUTION" docs/specs/jsm-e2e-coverage.md` → ≥1 match |
| `docs/specs/jsm-e2e-coverage.md` §8 VER-JSM-E2E-8 added | AC-006 | `grep -n "VER-JSM-E2E-8" docs/specs/jsm-e2e-coverage.md` → ≥1 match |
| `docs/specs/e2e-live-jira-testing.md` updated | AC-006 | `grep -n "JR_E2E_JSM_RESOLUTION" docs/specs/e2e-live-jira-testing.md` → ≥1 match |
| `CLAUDE.md` updated | AC-006 | `grep -n "JR_E2E_JSM_RESOLUTION\|--resolution" CLAUDE.md` → ≥1 match |
| Zero `src/` changes | AC-006 | `git diff --name-only HEAD \| grep -E "^src/"` → empty |
| `cargo test` exits 0 | smoke | no accidental Rust source changes |
| `cargo fmt --all -- --check` exits 0 | lint | no format drift |
| `cargo clippy --all-targets -- -D warnings` exits 0 | lint | zero warnings |
| `bash scripts/check-spec-counts.sh` exits 0 | invariant | BC frontmatter unchanged |
| `bash scripts/check-bc-cumulative-counts.sh` exits 0 | invariant | BC-INDEX.md unchanged |
| `bash scripts/check-bc-no-numeric-test-counts.sh` exits 0 | invariant | no BC body numeric count drift |

## Token Budget Estimate

| Item | Tokens (approx) |
|------|----------------|
| This story file | ~6 k |
| `docs/specs/jsm-e2e-coverage.md` (§5 Scenario 8 + §6.1 update + §8 VER-JSM-E2E-8 + §2.2 rows; ~120 LOC relevant) | ~3 k |
| `tests/e2e_live.rs` relevant sections (~500 LOC: jsm_self_close + new test + helper area) | ~7 k |
| `tests/e2e_cli_surface_guard.rs` (~20 LOC relevant) | ~1 k |
| `docs/specs/e2e-live-jira-testing.md` (~40 LOC relevant) | ~1 k |
| `CLAUDE.md` JSM E2E section (~60 LOC relevant) | ~2 k |
| BC files (BC-3.2.009, BC-3.2.010, BC-3.2.011, BC-2.3.036 — read-only; 4 BCs, not modified) | ~2 k |
| Tool outputs (`cargo test`, `cargo clippy`, grep verifications, script exits) | ~2 k |
| **Total** | **~24 k** |

Well within a single-agent context window (~200 k). No split required.
LOC delta: `tests/e2e_live.rs` +~60 LOC (new test function ~45 + jsm_self_close extension ~15);
`tests/e2e_cli_surface_guard.rs` +~2 LOC; `docs/specs/jsm-e2e-coverage.md` +~80 LOC;
`docs/specs/e2e-live-jira-testing.md` +~10 LOC; `CLAUDE.md` +~8 LOC.
Zero `src/` LOC changes.

## Tasks

- [ ] Read `tests/e2e_live.rs` — locate `jsm_self_close` (from S-JSM-E2E-2), all JSM test functions, and the helper/harness pattern used
- [ ] Read `tests/e2e_cli_surface_guard.rs` — locate the `issue move` SURFACE row; confirm `--resolution` is absent; confirm `issue resolutions` row is absent
- [ ] Extend `jsm_self_close` in `tests/e2e_live.rs` per AC-003: after transition discovery, call `jr issue resolutions --output json`; pick first name or `JR_E2E_JSM_RESOLUTION` override; pass `--resolution <R>` to `jr issue move`; fall back silently on any failure
- [ ] Add `test_e2e_jsm_resolution_enforcement` to `tests/e2e_live.rs` per AC-001/AC-002/AC-004:
  - JSM_PROJECT gate
  - Positive: create key_positive, discover resolution, move WITH --resolution, assert exit 0, read-back `fields.resolution.name == R`
  - Bypass-demo: create key_bypass, move WITHOUT --resolution, dual-branch (exit 0 → null; exit non-zero + "resolution" → hint check)
  - Both keys self-closed via `jsm_self_close` on all exit paths
- [ ] Edit `tests/e2e_cli_surface_guard.rs`: add `"--resolution"` to `issue move` row; add `(&["issue", "resolutions"], &["--output"])` row
- [ ] Edit `docs/specs/jsm-e2e-coverage.md`: add §5 Scenario 8; update §6.1 teardown note; add §8 VER-JSM-E2E-8; add §2.2 BC-map rows
- [ ] Edit `docs/specs/e2e-live-jira-testing.md`: add `JR_E2E_JSM_RESOLUTION` to env table; add `test_e2e_jsm_resolution_enforcement` to JSM test list
- [ ] Edit `CLAUDE.md`: update JSM teardown convention note for --resolution discovery
- [ ] Run `git diff --name-only HEAD | grep -E "^src/"` — must return empty
- [ ] Run `cargo test --test e2e_cli_surface_guard` — must exit 0
- [ ] Run `cargo test` — must exit 0
- [ ] Run `cargo fmt --all -- --check` — must exit 0
- [ ] Run `cargo clippy --all-targets -- -D warnings` — must exit 0
- [ ] Run `bash scripts/check-spec-counts.sh && bash scripts/check-bc-cumulative-counts.sh && bash scripts/check-bc-no-numeric-test-counts.sh` — all must exit 0
- [ ] Commit: `test(e2e): JSM resolution enforcement scenario + jsm_self_close --resolution (S-JSM-E2E-3)`

## Previous Story Intelligence

**Predecessor: S-JSM-E2E-2 (F3 complete, 2026-06-02; awaiting F4)** — introduced `jsm_self_close`
with dynamic `statusCategory==done` transition discovery. Key lesson: use category key (`"done"`)
not status name for cross-project resilience. This story extends that helper with resolution
discovery — the same "probe live API, don't hardcode" principle, applied to the resolution field.

**Predecessor: S-JSM-E2E-1 (PR #460 → develop @ 04b6b2c, merged 2026-06-02)** — introduced all
7 JSM scenarios. Scenario 6 (`test_e2e_jsm_create_request_roundtrip`) is the closest analog to
this story: create → self-close → assertions. The Scenario 8 test follows the same structural
pattern (create → operate → assert → self-close), adapted for the resolution enforcement domain.

**Dual-path robustness lesson from S-JSM-E2E design:** Live JSM workflows vary by instance
configuration. Hardcoding expected outcomes (e.g., "the move must return 400") fails across
instances. The bypass-demo pattern in AC-002 directly applies this lesson: the test observes
both possible outcomes and documents the observed path without asserting which one the EJ
instance will produce.

**JR_E2E_JSM_RESOLUTION override pattern** mirrors `JR_E2E_STATUS_DONE` and `JR_E2E_JSM_PROJECT`:
always prefer env override > dynamic discovery > fallback. This pattern is consistent across all
JSM E2E fixtures and teardown helpers.

## Architecture Compliance Rules

1. **Zero `src/` changes.** If any `src/` file appears in the diff, STOP and escalate.
   This story is entirely `tests/` + documentation.

2. **`jsm_self_close` extension must preserve best-effort contract.** No `panic!`, `assert!`,
   `unwrap()`, or `expect()` on the resolutions-fetch path. All failure branches emit
   `eprintln!("[WARN] jsm_self_close: …")` and fall back to the existing no-resolution path.

3. **`test_e2e_jsm_resolution_enforcement` bypass-demo branch must NOT assert WHICH branch
   fires.** The branch dispatch (exit 0 vs exit != 0) is an observation-only choice — the test
   must not require one specific outcome. However, WITHIN whichever branch is entered, the
   branch's documented invariant MUST be asserted:
   - **Branch A** (move exit 0): `assert!(fields.resolution.is_null())` — confirms API bypass
     (BC-2.3.036 nullable resolution invariant).
   - **Branch B** (move exit != 0 with stderr containing `"resolution"`): `assert!(stderr.contains("--resolution"))` — confirms enforcement hint (BC-3.2.009 postcondition).
   - **Unclassified non-zero**: `eprintln!("[WARN] …")`, no assert, no panic.
   No `assert_eq!`, `assert!`, or `panic!` may appear on the branch-selection logic itself.

4. **Use `JR_E2E_JSM_RESOLUTION` env var pattern.** Mirrors `JR_E2E_STATUS_DONE`: env override >
   dynamic discovery > omit. Never hardcode a resolution name.

5. **Numeric-bypass-safe resolution list.** `jr issue resolutions --output json` returns
   `[{name, id, description}]` per BC-3.2.010. The `name` field is used (not `id`) because
   `jr issue move --resolution` accepts a name, not an ID.

6. **BC corpus must remain unchanged.** Do NOT edit `BC-INDEX.md`, `CANONICAL-COUNTS.md`,
   or any `.factory/specs/prd/bc-*.md` file.

7. **SURFACE table update is required.** `--resolution` on `issue move` and the
   `issue resolutions` command are new SURFACE entries relative to S-JSM-E2E-1's additions.
   Failure to add them causes `cargo test --test e2e_cli_surface_guard` to fail if the test
   references these paths.

## Library & Framework Requirements

No new `Cargo.toml` dependencies. Zero Rust library additions.

| Tool/Crate | Already available | Usage in this story |
|------------|------------------|---------------------|
| `serde_json` | Yes (dev-dependency in tests) | Parse `jr issue resolutions --output json` and `jr issue view --output json` responses |
| `std::process::Command` via `e2e_cmd()` | Yes (e2e_live.rs helper) | Invoke `jr issue resolutions`, `jr issue move --resolution`, `jr issue view` |

## File Structure Requirements

| File | Action | Notes |
|------|--------|-------|
| `tests/e2e_live.rs` | MODIFY | Extend `jsm_self_close` with resolution discovery; add `test_e2e_jsm_resolution_enforcement` |
| `tests/e2e_cli_surface_guard.rs` | MODIFY | Add `--resolution` to `issue move` row; add `issue resolutions` row |
| `docs/specs/jsm-e2e-coverage.md` | MODIFY | §5 Scenario 8; §6.1 teardown note; §8 VER-JSM-E2E-8; §2.2 BC-map rows |
| `docs/specs/e2e-live-jira-testing.md` | MODIFY | `JR_E2E_JSM_RESOLUTION` env var; test function name |
| `CLAUDE.md` | MODIFY | JSM teardown convention note updated for --resolution + `JR_E2E_JSM_RESOLUTION` |

**Files confirmed NOT changed:**
- `src/` (all files — zero Rust source changes)
- `.github/workflows/` (all workflow files)
- `Cargo.toml`, `Cargo.lock`, `deny.toml`
- `scripts/`, `.factory/specs/` (no BC, PRD, or architecture change)
- `BC-INDEX.md`, `CANONICAL-COUNTS.md`

## Branch / PR Plan

- Branch: `feat/jsm-e2e-resolution-enforcement`
- Target: `develop`
- Commit: `test(e2e): JSM resolution enforcement scenario + jsm_self_close --resolution (S-JSM-E2E-3)`
- PR body: reference this story (S-JSM-E2E-3), the dual-path robustness design (bypass vs
  enforcement), BC anchors (BC-3.2.011, BC-3.2.010, BC-2.3.036, BC-3.2.009), and the
  `jsm_self_close` improvement.
- CHANGELOG entry: Add under `[Unreleased]` — "Added JSM resolution enforcement E2E scenario
  (`test_e2e_jsm_resolution_enforcement`): positive path verifies `--resolution` sets
  `fields.resolution.name` on read-back (BC-3.2.011 + BC-2.3.036); bypass-demo path observes
  API bypass (null resolution) or enforcement 400 hint (BC-3.2.009). `jsm_self_close` improved
  to discover a resolution via `jr issue resolutions --output json` and pass `--resolution <R>`
  atomically (best-effort; fallback to no-resolution on discovery failure; `JR_E2E_JSM_RESOLUTION`
  override supported)."
