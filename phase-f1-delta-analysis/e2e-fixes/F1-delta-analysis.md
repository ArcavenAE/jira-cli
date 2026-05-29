---
document_type: delta-analysis-report
feature_name: "E2E test suite — first-live-run bugfixes (follow-up to S-E2E-1)"
cycle_label: "S-E2E-2 (proposed)"
created: 2026-05-29
revised: 2026-05-29
revision: v1
parent_story: "S-E2E-1 (merged PR #433 @ d484f84)"
spec_version_at_analysis: "develop @ d484f84"
live_run_id: "26654916572"
live_run_result: "17 passed, 4 failed, teardown clean"
status: draft
intent: "bugfix"
feature_type: "infrastructure"
scope: "trivial"
regression_risk: "LOW"
issue: TBD
design_spec: "docs/specs/e2e-live-jira-testing.md"
parent_f1: ".factory/phase-f1-delta-analysis/e2e-live-jira-testing/F1-delta-analysis.md"
---

# F1 Delta Analysis — E2E First-Live-Run Bugfixes (S-E2E-2)

## 1. Context

S-E2E-1 (Live-Jira E2E testing in CI) was merged to develop at PR #433 (d484f84,
2026-05-29) and the E2E project was provisioned (R-NEW-1). The first live workflow
run (run ID 26654916572) produced **17 passed, 4 failed; teardown clean.** Three of
the four failures are code bugs in `tests/e2e_live.rs`; the fourth is a configuration/
environment question and is NOT a code fix. This follow-up cycle fixes the three code
bugs and records the open question as a risk item.

---

## 2. Impact Boundary

### Explicit claim: tests/e2e_live.rs ONLY — zero src/ changes

All three fixes are in `tests/e2e_live.rs`. No `src/` file is touched, no workflow
file changes, no CLAUDE.md changes, no spec changes, no new env var seams.

| File | Change type | Fix |
|------|-------------|-----|
| `tests/e2e_live.rs` | MODIFIED | FIX-A + FIX-B + FIX-C (see §3) |
| All other files | NOT CHANGED | Zero src/, workflow, spec, or docs delta |

Verification method: the three fixes are pure test-logic changes. The Rust compiler
enforces this boundary — any accidental `src/` edit will be surfaced by `cargo build`.

### Files NOT changed (regression baseline)

All of `src/**/*.rs`, `Cargo.toml`, `Cargo.lock`, `.github/workflows/ci.yml`,
`.github/workflows/e2e.yml`, `CLAUDE.md`, `docs/`, `.factory/specs/`,
`tests/common/`, `tests/snapshots/`, all other `tests/*.rs` files.

---

## 3. Root Cause Analysis — The Four Failures

### Failure 1: `test_e2e_sprint_current_returns_json` — SCRUM-BOARD ERROR (FIX-B)

**Observed stderr:**
```
{"code":1,"error":"Sprint commands are only available for scrum boards. Board 1 is a simple board."}
```

**Root cause:** The test's clean-skip logic (lines 732–736 in `tests/e2e_live.rs`) only
matches the `"No active sprint"` substring:
```rust
if stderr.contains("No active sprint") {
    return; // clean skip
}
panic!(...);  // everything else is a hard failure
```
Board 1 was identified by `jr` as a "simple board" (non-scrum). The `resolve_scrum_board`
function in `src/cli/sprint.rs` emits the error with these exact static strings:
```
"Sprint commands are only available for scrum boards. Board {id} is a {type} board."
```
The skip guard must be broadened to also match `"only available for scrum boards"` (the
reliable immutable substring from the static string in `bail!`).

**Verified error substring from `src/cli/sprint.rs::resolve_scrum_board` (lines 79–84):**
```rust
bail!(
    "Sprint commands are only available for scrum boards. Board {} is a {} board.",
    board_id,
    board_config.board_type
);
```
Reliable skip substring: **`"only available for scrum boards"`** — comes from the static
string literal in `bail!`, will not change with board ID or board type. The substring
`"simple board"` is also present in the observed error but is not in the static string;
it is board-type-dependent (a different non-scrum board type would produce a different
suffix). Use the static-string fragment.

**Also resolves:** drift item DI-E2E-F5-2 ("sprint current clean-skip only matches
'No active sprint' — kanban board would panic").

### Failure 2: `test_e2e_sprint_list_returns_array` — NO SKIP PATH (FIX-B)

**Observed stderr:** Same "simple board" error as Failure 1.

**Root cause:** `test_e2e_sprint_list_returns_array` has no failure-path clean-skip at all
(lines 681–693). It asserts `output.status.success()` unconditionally; any exit-non-zero
from `jr sprint list` is a hard failure. The test must add the same scrum-only clean-skip
logic as `test_e2e_sprint_current_returns_json`.

### Failure 3: `test_e2e_write_flow_create_edit_comment_worklog_close` — EMPTY STATUS (FIX-A)

**Observed stderr:**
```
Error: Ambiguous transition "". Matches: To Do, In Progress, Done
```

**Root cause:** The optional GitHub variable `JR_E2E_STATUS_IN_PROGRESS` was not
configured on the `jira-e2e` Environment, so the workflow passes it as an empty string
(`""`) to the test process via:
```yaml
JR_E2E_STATUS_IN_PROGRESS: ${{ vars.JR_E2E_STATUS_IN_PROGRESS }}
```
In GitHub Actions, an unset `vars.*` expression evaluates to an empty string (not the
absence of the env var). The test helper `status_in_progress()` uses:
```rust
env::var("JR_E2E_STATUS_IN_PROGRESS").unwrap_or_else(|_| "In Progress".to_string())
```
`env::var` returns `Ok("")` for a set-but-empty var (not `Err`), so `unwrap_or_else`
never fires. The move target becomes `""` → jr reports an ambiguous transition.

The same latent bug exists in `status_done()` for `JR_E2E_STATUS_DONE`.

**Fix:** Both helpers must treat an empty or whitespace-only env value as absent, falling
back to the default. The teardown shell step already handles this correctly via
`${VAR:-default}`; only the Rust helpers missed it.

The corrected logic:
```rust
fn status_done() -> String {
    match env::var("JR_E2E_STATUS_DONE") {
        Ok(v) if !v.trim().is_empty() => v,
        _ => "Done".to_string(),
    }
}
fn status_in_progress() -> String {
    match env::var("JR_E2E_STATUS_IN_PROGRESS") {
        Ok(v) if !v.trim().is_empty() => v,
        _ => "In Progress".to_string(),
    }
}
```

### Failure 4: `test_suite_is_noop_without_jr_run_e2e` — SELF-CONTRADICTORY (FIX-C)

**Observed:** The test asserts `JR_RUN_E2E != "1"` unconditionally, but the `e2e.yml`
workflow legitimately sets `JR_RUN_E2E=1`. When the e2e.yml workflow runs, it executes
`cargo test --test e2e_live -- --include-ignored --test-threads=1`, which includes
the always-run (non-`#[ignore]`) tests. `test_suite_is_noop_without_jr_run_e2e` is
always-run, so it executes in the e2e workflow and finds `JR_RUN_E2E=1` — exactly the
condition it was designed to flag as a bug.

The test is also redundant: `ci.yml` never passes `--include-ignored`, so the `#[ignore]`-
gated tests are inert there regardless of `JR_RUN_E2E`. The gate-correctness property
the test was meant to protect (AC-001/AC-002) is already covered by:

1. `test_e2e_gate_disabled_when_env_unset` — pure function over literal inputs; tests
   `e2e_enabled_from()` over `None`, `Some("1")`, `Some("0")`, `Some("")`, `Some("1 ")`.
   Runs always, no env mutation, no race risk.
2. `test_every_ignored_test_has_gate_guard` — source meta-guard; verifies every
   `#[ignore]`-annotated test has `e2e_enabled()` BEFORE any live-call token. Runs always.
3. The `#[ignore]` mechanism itself — `ci.yml`'s `cargo test` does not pass
   `--include-ignored`, so gated tests never run there regardless.

**Fix:** Remove `test_suite_is_noop_without_jr_run_e2e` entirely.

---

## 4. Affected ACs (AC Delta)

No new ACs are added and no AC text changes are needed. The three code fixes are
implementation corrections that make the existing ACs behave as specified:

| AC | Status | Effect of fix |
|----|--------|---------------|
| AC-001 | CORRECTED | `test_suite_is_noop_without_jr_run_e2e` (the test that was *meant* to verify this) is removed; AC-001 gate invariant is still fully covered by `test_e2e_gate_disabled_when_env_unset` + `test_every_ignored_test_has_gate_guard` + `#[ignore]` mechanism |
| AC-002 | NO CHANGE | Covered by `test_every_ignored_test_has_gate_guard`; no change needed |
| AC-004 (sprint rows) | CORRECTED | Sprint skip logic now handles scrum-only error in addition to no-active-sprint; sprint tests CLEAN-SKIP on non-scrum board |
| AC-005/AC-006 | CORRECTED | `status_done()`/`status_in_progress()` helpers now fall back to defaults when env var is set but empty; write flow test will run correctly when status vars are unset |
| AC-007 | NO CHANGE | Write flow structure unchanged; only the status-resolution helpers fixed |
| AC-008 through AC-012 | NO CHANGE | Workflow, CLAUDE.md, teardown unaffected |

---

## 5. BC/NFR Delta

**BC delta: EMPTY.**

These are test-only fixes. No product behavioral contract is added, modified, or retired.
The 583 existing BCs remain unchanged.

**NFR delta: EMPTY.**

NFR-T-E2E-1 (added in F2 of the S-E2E-1 cycle) already covers the E2E suite's health
obligation. No new NFR is warranted for a test-logic bugfix. NFR count stays at 41.

---

## 6. Regression Risk Assessment

**Overall regression risk: LOW**

| Dimension | Assessment | Justification |
|-----------|-----------|---------------|
| src/ changes | ZERO | No production code paths affected |
| Existing tests in ci.yml | NONE | `tests/e2e_live.rs` compiles clean; ci.yml runs only always-run tests (not `#[ignore]`) |
| Gate correctness (AC-001/002) | IMPROVED | FIX-C removes the self-contradictory test; `test_e2e_gate_disabled_when_env_unset` and `test_every_ignored_test_has_gate_guard` provide stronger, race-free coverage |
| Sprint skip logic (AC-004) | IMPROVED | Broader skip condition means more boards handled gracefully (not just "no sprint" scenarios) |
| Write flow (AC-005/006) | IMPROVED | Empty-string env fix makes write flow reliable on first run for any site that doesn't configure optional status vars |
| Hermetic CI regression | ZERO | The always-run tests that run in ci.yml (`test_e2e_gate_disabled_when_env_unset`, `test_every_ignored_test_has_gate_guard`, `test_extract_fn_body_*`) are not touched by any of the three fixes |

---

## 7. Recommended Story: New (S-E2E-2) vs Amend (S-E2E-1)

**Recommendation: NEW story, ID `S-E2E-2`.**

**Rationale:**

1. S-E2E-1 is MERGED (PR #433 @ d484f84). Post-merge amendments to a delivered story
   create ambiguous audit trails. The VSDD convention for post-merge fixes is a new
   Feature Mode cycle, not retroactive amendment.
2. The root causes are all post-provisioning first-live-run discoveries — they could not
   have been found without running against a real site. This is a valid, distinct cycle.
3. The story is small (3 targeted edits in one file) and entirely test-infra: no BC
   authorship needed, no new specs, one short implementation pass. Amending S-E2E-1
   to carry this would bloat the original story's audit trail.

**Proposed story:** `S-E2E-2 — E2E first-live-run bugfixes (FIX-A/B/C)`

| Field | Value |
|-------|-------|
| Story ID | S-E2E-2 |
| Title | E2E first-live-run bugfixes (FIX-A/B/C) |
| Parent story | S-E2E-1 |
| Wave | feature-followup |
| Effort | SMALL (< 1 dev-day; 3 targeted edits in one file) |
| BC anchors | None (test-infra; BC delta EMPTY) |
| NFR anchors | NFR-T-E2E-1 (existing; this story keeps it green) |
| ACs affected | AC-001 (FIX-C), AC-004 (FIX-B), AC-005/006 (FIX-A) |
| Files modified | `tests/e2e_live.rs` only |
| src/ changes | ZERO |

**Recommended AC list for S-E2E-2:**

| AC | Fix | Verification |
|----|-----|-------------|
| AC-001 | FIX-C | Remove `test_suite_is_noop_without_jr_run_e2e`; verify `test_e2e_gate_disabled_when_env_unset` + `test_every_ignored_test_has_gate_guard` remain and pass in `cargo test --test e2e_live` |
| AC-002 | FIX-A | `status_done()` and `status_in_progress()` treat empty/whitespace env value as absent; write flow test passes with `JR_E2E_STATUS_*` unset |
| AC-003 | FIX-B | `test_e2e_sprint_list_returns_array` and `test_e2e_sprint_current_returns_json` clean-skip on `"only available for scrum boards"` stderr in addition to `"No active sprint"` |

---

## 8. Open Question: Team-Managed Board Type (NOT a code fix)

**Failure 4 context (sprint "simple board" classification):**

Board 1 on the E2E site is classified by `jr` as a "simple board" via the Jira Boards
API response (`board.type != "scrum"`). The user states board 1 is the intended sprint
board.

**Open question:** Is the ES (E2E-SCRUM) project **team-managed (next-gen)**? Atlassian's
Agile API reports team-managed scrum boards with a board type that may differ from
`"scrum"` (the value `resolve_scrum_board` in `src/cli/sprint.rs` requires). If the
project is team-managed, `jr sprint list/current` cannot work against it regardless of
the board ID, because the underlying sprint APIs behave differently for team-managed
vs company-managed projects.

**Impact of FIX-B:** Regardless of the answer, FIX-B makes the test suite skip
gracefully. The sprint tests become "skip on unsupported board type" rather than "hard
fail." This is the correct behavior for an optional, environment-dependent feature.

**If the answer is YES (team-managed):** Real sprint coverage on the ES project is
not achievable until `jr` adds team-managed board support. This is a potential separate
jr enhancement issue. Sprint tests will always clean-skip against this board until
that support is added.

**If the answer is NO (company-managed scrum):** The board ID or project setup may
be misconfigured. A different board ID (or a board explicitly created as "Scrum" in
project settings) may return `board.type == "scrum"` and unblock sprint tests.

**Resolution path:** Check the ES project settings in the Jira UI under "Project
settings → Project type" to determine company-managed vs team-managed. If team-managed,
file a separate `jr` enhancement issue for team-managed sprint support. Neither
outcome requires a code change in this cycle — FIX-B ensures clean-skip in both cases.

**Risk register entry:** This open question is tracked as a LOW-severity config risk.
It does not block FIX-B or S-E2E-2 delivery.

---

## 9. Sprint Error Substrings Verified from src/ (for FIX-B)

**Source:** `src/cli/sprint.rs::resolve_scrum_board` (static `bail!` string, lines 80–84):

```rust
bail!(
    "Sprint commands are only available for scrum boards. Board {} is a {} board.",
    board_id,
    board_config.board_type
);
```

**Also relevant** (active sprint check in `handle_current` and `handle_add`):
```rust
bail!("No active sprint found for board {}.", board_id);
```

**Recommended skip substrings for FIX-B:**

| Substring | Source | Stable? | Covers |
|-----------|--------|---------|--------|
| `"only available for scrum boards"` | Static `bail!` string in `resolve_scrum_board` | YES — immutable static string | Any non-scrum board type (simple, kanban, next-gen) |
| `"No active sprint"` | Static `bail!` string in `handle_current` | YES — immutable static string | Scrum board with no active sprint |

The skip condition for both sprint tests should be:
```rust
if stderr.contains("No active sprint") || stderr.contains("only available for scrum boards") {
    return; // clean skip
}
```

Do NOT use `"simple board"` as the match substring — it is board-type-dependent (a
kanban board would produce `"Board X is a kanban board."`, a team-managed board might
produce a different type string entirely). The static fragment `"only available for scrum boards"`
is the reliable, type-agnostic anchor.

---

## 10. Intent, Scope, and Routing Summary

| Field | Value |
|-------|-------|
| **Intent** | `bugfix` — first-live-run test failures in tests/e2e_live.rs |
| **Feature type** | `infrastructure` — test-only; no product surface |
| **Scope** | `trivial` — 3 targeted edits in one file; no new files |
| **BC delta** | EMPTY — zero product BCs affected |
| **NFR delta** | EMPTY — NFR-T-E2E-1 (41 total) unchanged |
| **src/ changes** | ZERO — confirmed |
| **Regression risk** | LOW — hermetic CI tests unaffected; always-run gate tests improved by FIX-C |
| **Recommended story** | NEW: `S-E2E-2` (not amend S-E2E-1); SMALL effort; 3 ACs |
| **Fixes** | FIX-A (empty-status), FIX-B (sprint skip), FIX-C (remove noop test) |
| **Not fixed** | Board 1 "simple board" classification (config, not code; see §8) |
| **Open question** | Is ES project team-managed? (see §8; LOW risk; FIX-B mitigates regardless) |
