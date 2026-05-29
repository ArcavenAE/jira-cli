---
document_type: story
story_id: "S-E2E-2"
title: "E2E suite first-live-run fixes (FIX-A: empty-status, FIX-B: sprint clean-skip, FIX-C: remove noop test)"
wave: feature-followup
status: draft
intent: bugfix
feature_type: infrastructure
scope: trivial
severity: small
trivial_scope: true
issue: TBD
points: 2
priority: medium
tdd_mode: strict
estimated_effort: small
depends_on: [S-E2E-1]
bc_anchors: []
# BC delta: EMPTY — all three fixes are test-logic changes in tests/e2e_live.rs only.
# No product behavioral contracts are added, modified, or retired.
# BC status: no BC authorship required.
# Status=draft: no BCs anchor this story. The spec-first gate (S-7.01) does not
# block dispatch for infrastructure-only bugfix stories with explicit justification above.
verification_properties: []
holdout_anchors: []
nfr_anchors: [NFR-T-E2E-1]
adr_refs: []
sd_refs: []
parent_phase: F3-story-decomposition
parent_story: "S-E2E-1"
spec_source: "docs/specs/e2e-live-jira-testing.md"
f1_source: ".factory/phase-f1-delta-analysis/e2e-fixes/F1-delta-analysis.md"
implementation_strategy: tdd
module_criticality: LOW
traceability_note: >
  BC delta is EMPTY (test-only bugfix; no product behavioral contracts).
  ACs trace to NFR-T-E2E-1 and to the affected AC rows of S-E2E-1
  (AC-001/002 gate, AC-004 sprint rows, AC-005/006 write-flow helpers).
  Do not invent BC-S.SS.NNN identifiers — none exist for this story.
files_modified:
  - tests/e2e_live.rs   # MODIFIED — FIX-A: empty-status helpers; FIX-B: sprint skip logic; FIX-C: remove noop test
breaking_change: false
assumption_validations: []
risk_mitigations: []
last_updated: "2026-05-29"
changelog:
  - date: "2026-05-29"
    phase: F3-story-decomposition
    author: story-writer
    summary: >
      Initial story creation from F1 delta analysis
      (.factory/phase-f1-delta-analysis/e2e-fixes/F1-delta-analysis.md).
      Live run ID 26654916572 produced 17 passed / 4 failed; three failures are
      code bugs in tests/e2e_live.rs addressed here; the fourth (board type) is
      recorded as an open question (OQ-1).
---

# S-E2E-2 — E2E Suite First-Live-Run Fixes

## Source of Truth

Design spec: `/Users/zious/Documents/GITHUB/jira-cli/docs/specs/e2e-live-jira-testing.md`
F1 delta analysis: `/Users/zious/Documents/GITHUB/jira-cli/.factory/phase-f1-delta-analysis/e2e-fixes/F1-delta-analysis.md`
NFR anchor: `NFR-T-E2E-1` (shared with S-E2E-1; this story keeps it green after live-run failures)
Parent story: `S-E2E-1` (merged PR #433 @ d484f84; the live run ID 26654916572 exposed these bugs)
GitHub issue: TBD

**No new BCs. Only file modified: `tests/e2e_live.rs`.**

## F2 Note

F2 is essentially empty for this cycle: no BC or NFR text changes are warranted. The only
F2-equivalent work is that drift item DI-E2E-F5-2 ("sprint current clean-skip only matches
`'No active sprint'` — kanban board would panic") is resolved by AC-2 (FIX-B). DI-E2E-F5-2
is fully addressed by the FIX-B implementation and requires no spec amendments.

## Goal

Fix three test-logic bugs in `tests/e2e_live.rs` that caused failures in the first live
workflow run (run ID 26654916572) of the E2E suite delivered by S-E2E-1.

All three fixes are pure test changes. Zero `src/` changes. The Rust compiler enforces
this boundary — any accidental `src/` edit will be surfaced by `cargo build`.

**Fixes:**

| ID | Name | Root cause | Affected AC (S-E2E-1) |
|----|------|------------|----------------------|
| FIX-A | Empty-status fall-back | `env::var` returns `Ok("")` for unset GitHub vars; `unwrap_or_else` never fires | AC-005/006 write-flow helpers |
| FIX-B | Sprint clean-skip broadened | Skip guard only matched `"No active sprint"` — non-scrum boards produce a different error | AC-004 sprint rows |
| FIX-C | Remove self-contradictory noop test | `test_suite_is_noop_without_jr_run_e2e` asserts `JR_RUN_E2E != "1"` unconditionally, but `e2e.yml` legitimately sets `JR_RUN_E2E=1` | AC-001/002 gate |

## Traceability

| Traceability target | Type | Description |
|--------------------|------|-------------|
| NFR-T-E2E-1 | NFR (MEDIUM) | Obligation to keep the E2E suite runnable and wired into CI |
| S-E2E-1 AC-001 | Parent AC | Gate no-op invariant — coverage remains via `test_e2e_gate_disabled_when_env_unset` + `test_every_ignored_test_has_gate_guard` + `#[ignore]` mechanism after FIX-C removes the flawed test |
| S-E2E-1 AC-002 | Parent AC | `--include-ignored` without gate returns early — coverage unchanged by this story |
| S-E2E-1 AC-004 (sprint rows) | Parent AC | Sprint tests now clean-skip on scrum-only error in addition to no-active-sprint |
| S-E2E-1 AC-005/AC-006 | Parent AC | Write flow + helpers — `status_done()`/`status_in_progress()` now fall back to defaults on empty env value |

## Behavioral Contracts

None — test-only bugfix. BC delta is EMPTY. See F1 delta analysis §5.

## Acceptance Criteria

### AC-1 (FIX-A — empty-status fall-back; traces to NFR-T-E2E-1; restores S-E2E-1 AC-005/006)

`status_done()` and `status_in_progress()` in `tests/e2e_live.rs` treat an empty or
whitespace-only env value as absent and fall back to their respective defaults (`"Done"`
and `"In Progress"`).

The corrected implementations use a match-guard pattern rather than `unwrap_or_else`:

```rust
fn status_done() -> String {
    match std::env::var("JR_E2E_STATUS_DONE") {
        Ok(v) if !v.trim().is_empty() => v,
        _ => "Done".to_string(),
    }
}
fn status_in_progress() -> String {
    match std::env::var("JR_E2E_STATUS_IN_PROGRESS") {
        Ok(v) if !v.trim().is_empty() => v,
        _ => "In Progress".to_string(),
    }
}
```

**Regression assertion:** a write-flow run with `JR_E2E_STATUS_IN_PROGRESS` set to `""`
(empty string, as GitHub Actions produces for an unconfigured `vars.*` expression) must
cause `status_in_progress()` to return `"In Progress"`, not `""`. When `""` was used as
the `jr issue move` target, the CLI reported `Ambiguous transition "". Matches: To Do, In
Progress, Done` (observed in live run 26654916572).

Verification: `grep -A4 "fn status_done\|fn status_in_progress" tests/e2e_live.rs` shows
the `match` + `trim().is_empty()` guard pattern in both helpers.

### AC-2 (FIX-B — sprint clean-skip broadened; traces to NFR-T-E2E-1; restores S-E2E-1 AC-004 sprint rows; resolves DI-E2E-F5-2)

`test_e2e_sprint_list_returns_array` and `test_e2e_sprint_current_returns_json` in
`tests/e2e_live.rs` clean-skip (return early with no panic) when the `jr` process exits
non-zero AND stderr contains either:

- `"only available for scrum boards"` — the board-type-independent substring from the
  static `bail!` string in `src/cli/sprint.rs::resolve_scrum_board`; covers simple boards,
  kanban boards, and team-managed boards regardless of the `{board_type}` suffix value; OR
- `"No active sprint"` — the existing skip condition for scrum boards without a live sprint

The combined skip condition for both sprint tests:

```rust
if stderr.contains("No active sprint") || stderr.contains("only available for scrum boards") {
    return; // clean skip — board is not a scrum board or has no active sprint
}
```

**Do NOT use** `"simple board"` as the match substring — it is board-type-dependent (a
kanban board would produce `"Board X is a kanban board."`, producing a different suffix).
The static-string fragment `"only available for scrum boards"` is the reliable,
type-agnostic anchor from the immutable `bail!` literal in `src/cli/sprint.rs`.

Verification: `grep -n "only available for scrum boards" tests/e2e_live.rs` returns at
least 2 matches (one in each sprint test's clean-skip guard).

### AC-3 (FIX-C — remove self-contradictory noop test; traces to NFR-T-E2E-1; restores S-E2E-1 AC-001/002)

`test_suite_is_noop_without_jr_run_e2e` is removed from `tests/e2e_live.rs`.

**Rationale:** The test asserts `JR_RUN_E2E != "1"` unconditionally. The `e2e.yml` workflow
legitimately sets `JR_RUN_E2E=1` and executes `cargo test --test e2e_live -- --include-ignored
--test-threads=1`, which includes all always-run (non-`#[ignore]`) tests. When the e2e
workflow ran for the first time (live run 26654916572), the always-run test found
`JR_RUN_E2E=1` and failed — exactly the condition it was designed to flag as a bug.

The test is also redundant: `ci.yml` never passes `--include-ignored`, so the `#[ignore]`-gated
tests are inert in normal CI regardless of `JR_RUN_E2E`.

**Gate-correctness coverage after removal:** The AC-001/AC-002 invariant is still fully covered by:

1. `test_e2e_gate_disabled_when_env_unset` — pure function over literal inputs; tests
   `e2e_enabled_from()` over `None`, `Some("1")`, `Some("0")`, `Some("")`, `Some("1 ")`.
   Runs always (not `#[ignore]`), no env mutation, no race risk.
2. `test_every_ignored_test_has_gate_guard` — source meta-guard; verifies every
   `#[ignore]`-annotated test in the file has `e2e_enabled()` before any live-call token.
   Runs always (not `#[ignore]`).
3. The `#[ignore]` mechanism itself — `ci.yml`'s `cargo test` does not pass
   `--include-ignored`, so gated tests never run in normal CI regardless.

Verification: `grep -n "test_suite_is_noop_without_jr_run_e2e" tests/e2e_live.rs` returns
ZERO matches. `grep -n "test_e2e_gate_disabled_when_env_unset\|test_every_ignored_test_has_gate_guard"
tests/e2e_live.rs` returns at least 2 matches (both gate-coverage tests still present).

## Out of Scope

- **Board 1 classification fix** — the "simple board" result is a Jira configuration/project-type
  question, not a code bug (see Open Items OQ-1 below). FIX-B makes the suite skip gracefully
  regardless of the answer; no code change is needed here.
- **Any `src/` changes** — confirmed zero. The F1 delta analysis §2 explicitly bounds this story
  to `tests/e2e_live.rs` only.
- **New env vars** — no new `JR_*` test-seam env vars are introduced; no CLAUDE.md doc-fallout
  update is needed.
- **Spec changes** — `docs/specs/e2e-live-jira-testing.md` is not modified; the fixes align with
  the existing spec intent.
- **Workflow changes** — `.github/workflows/e2e.yml` is not modified.

## Open Items

| # | Item | Risk | Resolution path |
|---|------|------|----------------|
| OQ-1 | **Team-managed board type (NOT a code fix):** The ES project may be team-managed (next-gen). Atlassian's Agile API reports team-managed scrum boards with a board type that may differ from `"scrum"` — the value `resolve_scrum_board` in `src/cli/sprint.rs` requires. If team-managed, real sprint coverage against the ES project is not achievable until `jr` adds team-managed board support. FIX-B makes the suite skip gracefully meanwhile (AC-2). **To check:** `Project settings → Project type` in the Jira UI. If team-managed, file a separate `jr` enhancement issue for team-managed sprint support. Neither outcome requires a code change in this cycle. | LOW | Check ES project type in Jira UI; file enhancement issue if team-managed; FIX-B mitigates regardless |

## Implementation Strategy

All three fixes are in `tests/e2e_live.rs` only. Suggested edit order:

1. **FIX-C first** — remove `test_suite_is_noop_without_jr_run_e2e`. This makes the test
   file compile + pass in `cargo test --test e2e_live` even when run inside `e2e.yml` with
   `JR_RUN_E2E=1`. Run `cargo test --test e2e_live` to confirm green.

2. **FIX-A** — update `status_done()` and `status_in_progress()` to use the match-guard
   pattern. Verify the grep check in AC-1 passes.

3. **FIX-B** — broaden the sprint clean-skip condition in both `test_e2e_sprint_list_returns_array`
   and `test_e2e_sprint_current_returns_json`. Verify the grep check in AC-2 passes.

4. Run full quality gate: `cargo test`, `cargo fmt --check`, `cargo clippy`, scripts.

**Branch:** `fix/S-E2E-2-e2e-first-live-run-fixes` from `develop` (develop already has S-E2E-1 merged).

**Commit message:**
```
fix(e2e): first-live-run fixes — empty-status fallback, sprint skip, remove noop test
```

**PR target:** `develop`.

## Test Coverage Strategy

| Test type | Count | Location | What it tests |
|-----------|-------|----------|---------------|
| Always-run gate tests (unchanged) | 2 | `tests/e2e_live.rs` | `test_e2e_gate_disabled_when_env_unset` + `test_every_ignored_test_has_gate_guard` (both retained; stronger gate coverage than the removed test) |
| FIX-A: `status_done()`/`status_in_progress()` | 2 helpers modified | `tests/e2e_live.rs` | Empty/whitespace env value treated as absent; default returned |
| FIX-B: sprint skip guards | 2 tests modified | `tests/e2e_live.rs` | Both sprint tests clean-skip on `"only available for scrum boards"` OR `"No active sprint"` |
| FIX-C: noop test removed | 1 test deleted | `tests/e2e_live.rs` | Removes the self-contradictory always-run assertion that fails in e2e.yml |

**Test command (after fixes):**
```bash
# Normal CI path — gate tests run, gated tests skip:
cargo test --test e2e_live

# E2E path (when site is provisioned):
JR_RUN_E2E=1 \
JR_BASE_URL=https://<site>.atlassian.net \
JR_AUTH_HEADER="Basic $(printf '%s:%s' "$EMAIL" "$TOKEN" | base64 -w0)" \
JR_E2E_PROJECT=ES \
cargo test --test e2e_live -- --include-ignored --test-threads=1
```

## Quality Gate Self-Check

| Criterion | AC | Notes |
|-----------|-----|-------|
| `cargo test --test e2e_live` (no env) exits 0 | AC-3 | Gate tests pass; no `test_suite_is_noop_without_jr_run_e2e` failure |
| `grep -n "test_suite_is_noop_without_jr_run_e2e" tests/e2e_live.rs` → 0 matches | AC-3 | Noop test removed |
| `grep -n "test_e2e_gate_disabled_when_env_unset\|test_every_ignored_test_has_gate_guard" tests/e2e_live.rs` → ≥2 matches | AC-3 | Gate coverage tests still present |
| `grep -A4 "fn status_done\|fn status_in_progress" tests/e2e_live.rs` shows `trim().is_empty()` guard | AC-1 | Match-guard pattern in both helpers |
| `grep -n "only available for scrum boards" tests/e2e_live.rs` → ≥2 matches | AC-2 | Sprint skip guard broadened in both sprint tests |
| `cargo test` exits 0 | smoke | Rust codebase unaffected; all existing tests green |
| `cargo fmt --all -- --check` exits 0 | lint | No format drift |
| `cargo clippy --all-targets -- -D warnings` exits 0 | lint | No warnings |
| `bash scripts/check-spec-counts.sh` exits 0 | invariant | No BC frontmatter changed |
| `bash scripts/check-bc-cumulative-counts.sh` exits 0 | invariant | No count surfaces touched |
| `bash scripts/check-bc-no-numeric-test-counts.sh` exits 0 | invariant | No BC bodies with numeric counts |

## Token Budget Estimate

| Item | Tokens (approx) |
|------|----------------|
| This story file | ~4 k |
| F1 delta analysis (§3–§4 root causes + §7 recommended ACs) | ~3 k |
| S-E2E-1 story (AC-001/002/004/005/006 context) | ~6 k |
| `tests/e2e_live.rs` (to read and modify: ~450 LOC) | ~6 k |
| `src/cli/sprint.rs` (lines ~79–84, bail! string verification) | ~1 k |
| Tool outputs (`cargo test`, `cargo clippy`, grep verifications, script exits) | ~3 k |
| BC files: 0 (none loaded — BC delta empty) | 0 |
| **Total** | **~23 k** |

Well within a single-agent context window (~200 k). No split required.
LOC delta: `tests/e2e_live.rs` −~15 LOC (remove noop test) + ~8 LOC net change (helper
rewrites + sprint guard additions). Net change: approximately −7 LOC.

## Tasks

- [ ] Create branch `fix/S-E2E-2-e2e-first-live-run-fixes` from `develop`
- [ ] Read `tests/e2e_live.rs` in full — understand current state of the three affected areas
- [ ] Read `src/cli/sprint.rs::resolve_scrum_board` — verify the static `bail!` string to
  confirm the reliable skip substring (`"only available for scrum boards"`)
- [ ] **FIX-C:** Remove `test_suite_is_noop_without_jr_run_e2e` function from `tests/e2e_live.rs`
- [ ] `cargo test --test e2e_live` — exits 0 (gate tests pass; no noop test failure)
- [ ] **FIX-A:** Update `status_done()` to use `match env::var(...) { Ok(v) if !v.trim().is_empty() => v, _ => "Done".to_string() }`
- [ ] **FIX-A:** Update `status_in_progress()` to use matching pattern with default `"In Progress"`
- [ ] Verify: `grep -A4 "fn status_done\|fn status_in_progress" tests/e2e_live.rs` shows `trim().is_empty()` guard in both helpers
- [ ] **FIX-B:** In `test_e2e_sprint_list_returns_array` — add `|| stderr.contains("only available for scrum boards")` to the existing clean-skip condition (or add the condition if the test has no clean-skip)
- [ ] **FIX-B:** In `test_e2e_sprint_current_returns_json` — broaden existing `"No active sprint"` skip to also match `"only available for scrum boards"`
- [ ] Verify: `grep -n "only available for scrum boards" tests/e2e_live.rs` → ≥2 matches
- [ ] `cargo test --test e2e_live` — exits 0
- [ ] `cargo test` — exits 0 (full suite; no regressions)
- [ ] `cargo fmt --all -- --check` — exits 0
- [ ] `cargo clippy --all-targets -- -D warnings` — exits 0
- [ ] `bash scripts/check-spec-counts.sh && bash scripts/check-bc-cumulative-counts.sh && bash scripts/check-bc-no-numeric-test-counts.sh` — all exit 0
- [ ] Commit: `fix(e2e): first-live-run fixes — empty-status fallback, sprint skip, remove noop test`
- [ ] Open PR targeting `develop`; body references this story, S-E2E-1, and live run ID 26654916572

## Previous Story Intelligence

**Direct predecessor: S-E2E-1** (PR #433 @ d484f84). The three bugs fixed here were
latent in the S-E2E-1 delivery — they could not have been detected without a live run
against a real Jira site. Key lesson: GitHub Actions `vars.*` expressions evaluate to
empty string (not absence) when the variable is unconfigured; Rust `env::var` returns
`Ok("")` for an empty var, so `unwrap_or_else` never fires. Always use a trim-guard for
optional env vars with non-empty semantics.

**FIX-C lesson:** A test that asserts environmental state (`JR_RUN_E2E != "1"`) is
always-run is structurally fragile — the test cannot know in which workflow context it
will be invoked. Gate-correctness tests must be formulated as pure-function checks over
literal inputs (e.g., `test_e2e_gate_disabled_when_env_unset` calling `e2e_enabled_from(None)`)
rather than env-var assertions.

**FIX-B lesson (from DI-E2E-F5-2):** When writing clean-skip guards in live-call tests,
enumerate ALL plausible non-fatal error classes, not just the ones observed in the design
environment. A skip guard written for one board type will fail on another board type. Use
the board-type-independent substring from the static `bail!` literal in `src/cli/sprint.rs`
rather than a board-type-specific error string.

## Architecture Compliance Rules

1. **Zero `src/` changes.** If any `src/` edit is needed, STOP and escalate — this is a
   scope violation per F1 §2. The F1 delta analysis explicitly confirmed `tests/e2e_live.rs`
   ONLY.

2. **`"only available for scrum boards"` is the reliable sprint skip substring.** Do NOT
   use `"simple board"` — it contains the board-type suffix which varies. The immutable
   fragment from the static `bail!` string in `src/cli/sprint.rs::resolve_scrum_board`
   is the correct anchor.

3. **Match-guard pattern for empty-env fallback.** The `unwrap_or_else` pattern is
   incorrect for optional GitHub vars because `env::var` returns `Ok("")` (not `Err`)
   for unset `vars.*` expressions. The `match ... if !v.trim().is_empty()` pattern is
   the project-standard fix (mirrors the teardown shell step's `${VAR:-default}` idiom).

4. **Gate tests must be pure-function assertions.** After FIX-C, gate correctness is
   covered by `test_e2e_gate_disabled_when_env_unset` (calls `e2e_enabled_from()` with
   literal inputs — no env reads) and `test_every_ignored_test_has_gate_guard` (source
   meta-analysis). Do not reintroduce an env-reading always-run test.

## Library & Framework Requirements

No `Cargo.toml` changes. This story modifies only `tests/e2e_live.rs`. All crates used
are already present from S-E2E-1.

| Crate | Usage in this story |
|-------|---------------------|
| `std::env` | Already used; match-guard pattern replaces `unwrap_or_else` |
| No new crates | Zero dependency changes |

## File Structure Requirements

| File | Action | Notes |
|------|--------|-------|
| `tests/e2e_live.rs` | MODIFY | FIX-A: two helper rewrites; FIX-B: two skip-guard edits; FIX-C: one test function removed |

**Files NOT to create:** No new `src/` files, no new spec files, no new ADR, no new BC files,
no new workflow files.

**Files NOT to touch:** All of `src/`, `Cargo.toml`, `deny.toml`, `.github/workflows/ci.yml`,
`.github/workflows/e2e.yml`, `CLAUDE.md`, `tests/common/`, all snapshot files
(`tests/snapshots/`), all other `tests/*.rs` files, `STORY-INDEX.md` (state-manager updates
that), all BC count surfaces (frontmatter, `BC-INDEX.md`, `CANONICAL-COUNTS.md`).

## Branch / PR Plan

- Branch: `fix/S-E2E-2-e2e-first-live-run-fixes` (from `develop`)
- Target: `develop`
- Commit: `fix(e2e): first-live-run fixes — empty-status fallback, sprint skip, remove noop test`
- PR body: reference this story (S-E2E-2), parent story S-E2E-1 (PR #433), and live run ID 26654916572
- CHANGELOG entry: Add under `[Unreleased]` — "Fixed three E2E test-suite bugs exposed in first live run (#433): empty-status env fallback, sprint clean-skip for non-scrum boards, and removal of self-contradictory gate test."
