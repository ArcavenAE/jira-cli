---
document_type: story
story_id: "S-JSM-E2E-2"
title: "JSM self-close teardown fix — dynamic close-transition discovery replaces status_done() for EJ"
wave: feature-followup
status: ready
intent: fix
feature_type: test
scope: xsmall
severity: small
trivial_scope: false
issue: TBD
points: 2
priority: P1
tdd_mode: facade
estimated_effort: xsmall
mode: feature
depends_on:
  - S-JSM-E2E-1
blocks: []
bc_anchors: []
# BC delta: EMPTY — this story fixes test teardown only. Zero product behavioral contracts
# are introduced or modified. BC corpus (585 BCs) and NFR corpus (41 NFRs) are EXPLICITLY
# UNCHANGED. No new BC file is created; no existing BC is modified; BC-INDEX.md is
# unchanged. The defect (orphaned EJ tickets) was a test teardown bug, not a product
# behavior violation — `jr issue move` is correct for ES Scrum but the JSM EJ workflow
# has no transition named "Done".
bcs: []
verification_properties:
  - VER-JSM-E2E-5
  - VER-JSM-E2E-6
holdout_anchors: []
nfr_anchors: []
adr_refs:
  - ADR-0014
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: "docs/specs/jsm-e2e-coverage.md §6 (revised by S-JSM-E2E-2)"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 6
assumption_validations: []
risk_mitigations: []
created: "2026-06-02"
last_updated: "2026-06-02"
traceability_note: >
  BC delta is EMPTY. This story is a zero-src, test+docs-only FIX to the teardown
  logic in the two JSM write scenarios introduced by S-JSM-E2E-1. The defect —
  "Done" is not a valid transition name on the EJ JSM workflow — was discovered
  via live run 26839267723 (post-S-JSM-E2E-1 merge), which passed green but left
  ~2 open EJ tickets. 11 offline adversarial passes could not catch a live
  workflow-name mismatch. The fix adds `jsm_self_close(key, &h)` which uses
  `jr issue transitions --output json` to discover a `statusCategory.key == "done"`
  transition dynamically, eliminating the hardcoded "Done" name assumption.
  VER-JSM-E2E-5 and VER-JSM-E2E-6 are re-verified by this fix.
files_modified:
  - tests/e2e_live.rs                     # MODIFIED — add jsm_self_close helper; rewire test_e2e_jsm_comment_visibility + test_e2e_jsm_create_request_roundtrip to call jsm_self_close
  - docs/specs/jsm-e2e-coverage.md        # MODIFIED — §6 revised: correct wrong assumption in §6.1; add dynamic close-transition discovery design; add Resolution-screen residual caveat; add S-JSM-E2E-2 revision note
  - CLAUDE.md                             # MODIFIED — update JSM E2E teardown convention note to document jsm_self_close + statusCategory==done pattern
breaking_change: false
changelog:
  - date: "2026-06-02"
    phase: F3-story-decomposition
    author: story-writer
    summary: >
      Initial story creation. Zero-src FIX: dynamic close-transition discovery for
      JSM self-close teardown. Replaces hardcoded "Done" with statusCategory==done
      probe via `jr issue transitions --output json`. Fixes live-run orphan defect
      discovered post-S-JSM-E2E-1 merge (run 26839267723). F1 root-cause confirmed.
      F2 spec §6 corrected. S-JSM-E2E-2 story ready for F4 dispatch.
---

# S-JSM-E2E-2 — JSM Self-Close Teardown Fix

## Source of Truth

Design spec: `docs/specs/jsm-e2e-coverage.md` §6 (revised by S-JSM-E2E-2)
Sections: §6.1 (Self-Close in Test Body — corrected design), §6.2 (sweeper cannot cover EJ),
          §6.3 (residual orphan risk — updated with Resolution-screen caveat).
F1 root-cause analysis: see Traceability Note above and §Root Cause below.

**No new BCs. BC corpus (585) and NFR corpus (41) are EXPLICITLY UNCHANGED.
Changes touch `tests/e2e_live.rs`, `docs/specs/jsm-e2e-coverage.md` §6, and `CLAUDE.md`.
Zero `src/` changes. No new SURFACE rows required.**

## Root Cause (F1)

Both JSM write scenarios (`test_e2e_jsm_comment_visibility`, `test_e2e_jsm_create_request_roundtrip`)
self-close via `jr issue move <key> <status_done()>`, where `status_done()` defaults to
`"Done"` (env `JR_E2E_STATUS_DONE`, fallback `"Done"`; see `tests/e2e_live.rs` helper ~174
and call sites ~2226, ~2570).

That works for the ES Scrum project — ES has a workflow transition literally named "Done".
The EJ JSM service-desk project does **not**. JSM workflows use transition names such as
Resolved, Closed, or Canceled. `jr issue move <EJ-key> Done` finds no matching transition
and fails. Because the close is best-effort (`let _ = ...` / `[WARN] Failed to close`), the
test still exits "ok" — but the created EJ ticket is left OPEN.

Confirmed live: run 26839267723 passed green but left ~2 open EJ tickets.

The spec §6.1 wrongly assumed `jr issue move <EJ-key> Done` is valid for JSM. The
label-sweeper does not cover EJ (spec §6.2), so orphans accumulate every nightly run.
11 offline adversarial passes could not catch a live workflow-name mismatch — the defect
class is fundamentally undetectable without executing against a real JSM project.

## Story Narrative

As a jr maintainer,
I want JSM write-scenario E2E tests to close EJ test issues reliably — using dynamic
transition discovery (statusCategory == done) rather than a hardcoded status name —
so that nightly runs do not accumulate orphaned open EJ tickets on the live site.

As a fork contributor,
I want the self-close to remain completely best-effort (never fails the test on close
failure), so that a transient JSM workflow permission or Resolution-screen guard never
turns a passing test into a failing one.

## Dependency Justification

**`depends_on: [S-JSM-E2E-1]`** — S-JSM-E2E-1 introduced the two JSM write scenarios
(`test_e2e_jsm_comment_visibility`, `test_e2e_jsm_create_request_roundtrip`) and the
`status_done()` teardown pattern that this story fixes. S-JSM-E2E-1 is already MERGED
(PR #460 → develop @ 04b6b2c, 2026-06-02). This story amends its teardown design.

**`blocks: []`** — no current story depends on the corrected JSM teardown to proceed.

## Goal

1. Add a `jsm_self_close(key: &str, h: &E2EHarness)` helper to `tests/e2e_live.rs` that:
   a. Runs `jr issue transitions <key> --output json` and parses the transitions array.
   b. Selects a transition whose `to.statusCategory.key == "done"` (the stable machine
      signal for a closing/green status — covers Resolved/Closed/Done/Canceled regardless
      of name). If multiple done-category transitions exist, any is acceptable (optionally
      prefer name in `["Resolved", "Closed", "Done"]` for determinism).
   c. Runs `jr issue move <key> <to.name>` using the discovered transition name.
   d. On any failure — no transitions array, no done-category transition, 403, non-zero
      exit from transitions or move, JSON parse error — emits `eprintln!("[WARN] …")` and
      returns without panicking. Best-effort contract is PRESERVED: close failure never
      fails the test.

2. Rewire `test_e2e_jsm_comment_visibility` and `test_e2e_jsm_create_request_roundtrip`
   to call `jsm_self_close(key, &h)` at the appropriate teardown point (per the spec §6.1
   ordering: close runs before post-create assertions in Scenario 6; close runs before
   read-back assertions in Scenario 5).

3. Keep `test_e2e_jsm_create_request_roundtrip` and all ES-project self-close calls
   (which use `status_done()` = `"Done"`) **unchanged** — the ES Scrum workflow has a
   real "Done" transition; the fix targets only the EJ JSM scenarios.

4. Update `docs/specs/jsm-e2e-coverage.md` §6.1 to replace the wrong `jr issue move
   <EJ-key> Done` assumption with the dynamic close-transition discovery design.

5. Update `CLAUDE.md` AI Agent Notes E2E section with the corrected teardown convention.

## Behavioral Contracts

No new BCs. This story traces teardown behavior to existing contracts only for the
purpose of maintaining test fidelity — the fix is infrastructure, not product behavior.

| BC | Relevance |
|----|-----------|
| VER-JSM-E2E-5 | `test_e2e_jsm_comment_visibility` now closes EJ issue reliably — re-verification confirms the test leaves no orphan |
| VER-JSM-E2E-6 | `test_e2e_jsm_create_request_roundtrip` now closes EJ issue reliably — re-verification confirms the same |

The `issue transitions` command (`jr issue transitions <key> --output json`) used in the
new helper is an existing CLI surface entry. No new SURFACE rows are required.

## Acceptance Criteria

### AC-001 — jsm_self_close discovers a statusCategory==done transition and closes the issue

`jsm_self_close(key, &h)` is added to `tests/e2e_live.rs` as a helper function.

**Behavior asserted:**
1. Calls `jr issue transitions <key> --output json`; exit 0 expected.
2. Parses stdout as a JSON array of transition objects, each with structure:
   `{id, name, to: {name, statusCategory: {name, key}}}` (per `src/types/jira/issue.rs`
   `Transition` / `Status` / `StatusCategory` types).
3. Selects the first transition where `to.statusCategory.key == "done"`.
   Preference order (optional, for determinism): name in `["Resolved", "Closed", "Done"]`
   over other done-category names.
4. Calls `jr issue move <key> <to.name>` using the discovered name.
5. Returns after the move attempt (regardless of success).

**Best-effort contract:** If ANY step fails (transitions command non-zero, JSON parse
error, no done-category transition found, move command non-zero), emit
`eprintln!("[WARN] jsm_self_close: …")` and return. NEVER `panic!` or `assert!`
inside `jsm_self_close`. The calling test MUST NOT fail due to close failure.

**No BC trace** — this is test infrastructure, not a product behavior assertion.

---

### AC-002 — Both JSM write scenarios use jsm_self_close

`test_e2e_jsm_comment_visibility` and `test_e2e_jsm_create_request_roundtrip` are
updated to call `jsm_self_close(key, &h)` instead of the `jr issue move <key> <status_done()>`
pattern.

**Behavior asserted:**
1. `grep -n "jsm_self_close" tests/e2e_live.rs` returns at least 3 matches:
   the function definition and 2 call sites (one per JSM write scenario).
2. `grep -n "status_done()" tests/e2e_live.rs` within the JSM write scenario bodies
   does NOT appear for teardown — the `status_done()` call is replaced by `jsm_self_close`.
   (The `status_done()` helper itself and its use in ES-project tests remain untouched.)

**No BC trace** — this is test wiring.

---

### AC-003 — Close remains best-effort: never fails the test on close failure

The `jsm_self_close` implementation and its two call sites preserve the existing
best-effort teardown contract established in S-JSM-E2E-1.

**Behavior asserted:**
1. The function signature and body contain no `assert!`, `unwrap()`, `expect()`, or
   `panic!` on the transitions-fetch or move steps.
2. Every failure branch emits `eprintln!("[WARN] jsm_self_close: …")` and returns `()`.
3. The calling test functions do not assert on the return value or any side-effect of
   `jsm_self_close`.

**No BC trace** — this is a test safety contract.

---

### AC-004 — ES write-flow self-close unchanged

The ES Scrum project self-close pattern (`jr issue move <key> <status_done()>` where
`status_done()` = `"Done"` or `JR_E2E_STATUS_DONE`) is NOT changed by this story.
Only the two EJ JSM write scenarios are rewired.

**Behavior asserted:**
1. `git diff --name-only` for this story's commit shows `tests/e2e_live.rs` modified.
2. Non-JSM self-close call sites in `tests/e2e_live.rs` (all tests targeting ES project)
   continue to use `status_done()` as before.

**No BC trace** — scope guard.

---

### AC-005 — docs/specs/jsm-e2e-coverage.md §6 updated

`docs/specs/jsm-e2e-coverage.md` §6 (Teardown Design and Orphan-Risk Documentation) is
updated to reflect the corrected design.

**Changes required:**
1. **§6.1** heading note: add `"Revised by S-JSM-E2E-2"`.
2. **§6.1** body: replace the wrong assumption (`jr issue move <EJ-key> Done` / hardcoded
   status name) with the dynamic close-transition discovery design:
   - Call `jr issue transitions <key> --output json`.
   - Parse the array; select a transition where `to.statusCategory.key == "done"`.
   - Call `jr issue move <key> <to.name>`.
   - Best-effort contract preserved (warn on failure, never fail the test).
3. **§6.1** residual caveat: document that a JSM "Resolve" transition requiring a mandatory
   Resolution field on its transition screen may still fail via `jr issue move` (which has
   no `--field-on-transition` path in scope). This is a documented LOW residual orphan risk.
4. **§6.3** retains the existing orphan-risk classification (LOW) — the dynamic discovery
   reduces but does not eliminate orphan risk (transition screen guards remain).
5. A short note is added to the spec preamble or §6 opening: "§6 revised by S-JSM-E2E-2
   (dynamic close-transition discovery; filed 2026-06-02)."

**CLAUDE.md** is also updated: the JSM teardown design note in AI Agent Notes → E2E section
is revised to describe `jsm_self_close` + `statusCategory==done` pattern.

**No BC trace** — documentation correctness.

---

### AC-006 — Zero src/ changes; no new SURFACE rows

**Behavior asserted:**
1. `git diff --name-only` for this story's commit contains NO paths starting with `src/`.
2. `tests/e2e_cli_surface_guard.rs` is NOT modified (the `issue transitions` command
   and `--output` flag are already in the SURFACE table from the existing E2E infrastructure;
   if not present, verify before modifying — see Implementation Strategy note).
3. `BC-INDEX.md`, `CANONICAL-COUNTS.md`, and all `.factory/specs/prd/bc-*.md` files are
   NOT modified.
4. `Cargo.toml`, `Cargo.lock`, `deny.toml` are NOT modified.

**No BC trace** — scope invariant.

---

## Rollout Note

No new GitHub Environment variable is required. The fix is entirely test-infrastructure.
After the F4 PR is merged and `JR_E2E_JSM_PROJECT=EJ` is active (set in `jira-e2e`
GitHub Environment by S-JSM-E2E-1's rollout), the corrected `jsm_self_close` will execute
on the next nightly run and close EJ issues correctly.

## Out of Scope

- Any `src/` change.
- Extending the e2e.yml sweeper to cover EJ — this remains an accepted gap (spec §6.2).
  If orphan accumulation from the residual Resolution-screen risk becomes a problem,
  extending the sweeper is a separate maintenance task.
- Adding a `--field-on-transition` flag to `jr issue move` — that is a product feature
  scope, not a test-teardown scope.
- BC-INDEX.md, CANONICAL-COUNTS.md — explicitly not changed.

## Implementation Strategy

**Zero-src delivery order (no Red Gate, no failing-test-first, no demo phase):**

1. **Read `tests/e2e_live.rs`** — locate `test_e2e_jsm_comment_visibility` (~L2226),
   `test_e2e_jsm_create_request_roundtrip` (~L2570), `status_done()` helper (~L174),
   and the existing `e2e_cmd()` / harness pattern before any edits.
2. **Check `tests/e2e_cli_surface_guard.rs`** — verify whether `issue transitions` with
   `--output` is already in the SURFACE table. If already present: no edit needed (AC-006).
   If missing: add the row `(&["issue", "transitions"], &["--output"])` in the same commit.
3. **Edit `tests/e2e_live.rs`:**
   a. Add `jsm_self_close(key: &str, h: &/* harness type */)` function per AC-001.
   b. Rewire `test_e2e_jsm_comment_visibility` teardown call to `jsm_self_close`.
   c. Rewire `test_e2e_jsm_create_request_roundtrip` teardown call to `jsm_self_close`.
   d. Leave all ES-project teardown calls (`status_done()`) intact.
4. **Edit `docs/specs/jsm-e2e-coverage.md`** §6 per AC-005.
5. **Edit `CLAUDE.md`** — update JSM teardown convention note per AC-005.
6. **Verify AC boundaries:**
   ```
   git diff --name-only HEAD | grep -E "^src/"
   ```
   Must return empty output.
7. **Run `cargo test --test e2e_cli_surface_guard`** — must exit 0.
8. **Run `cargo test` (non-E2E)** — must exit 0.
9. **Run spec-count guards:**
   ```
   bash scripts/check-spec-counts.sh
   bash scripts/check-bc-cumulative-counts.sh
   bash scripts/check-bc-no-numeric-test-counts.sh
   ```
   All must exit 0.
10. **Commit and push.**

**Branch:** `fix/jsm-e2e-self-close-teardown`
**Target:** `develop`
**Commit message:**
```
fix(e2e): dynamic close-transition discovery for JSM self-close teardown (S-JSM-E2E-2)
```

## Quality Gate Self-Check

| Criterion | AC | Verification Command |
|-----------|----|---------------------|
| `jsm_self_close` function present | AC-001 | `grep -n "jsm_self_close" tests/e2e_live.rs` → ≥3 matches (def + 2 call sites) |
| `jsm_self_close` uses `statusCategory` key `"done"` | AC-001 | `grep -n "statusCategory\|done" tests/e2e_live.rs` → matches in `jsm_self_close` body |
| No `assert!`/`unwrap()`/`expect()` on transitions or move steps in helper | AC-003 | Code review: only `eprintln!("[WARN] …")` + `return` on failure |
| `test_e2e_jsm_comment_visibility` calls `jsm_self_close` | AC-002 | `grep -A5 "test_e2e_jsm_comment_visibility" tests/e2e_live.rs \| grep jsm_self_close` |
| `test_e2e_jsm_create_request_roundtrip` calls `jsm_self_close` | AC-002 | `grep -A5 "test_e2e_jsm_create_request_roundtrip" tests/e2e_live.rs \| grep jsm_self_close` |
| ES-project teardown unmodified | AC-004 | `git diff HEAD tests/e2e_live.rs \| grep "status_done()"` → no removals in ES tests |
| `docs/specs/jsm-e2e-coverage.md` §6 updated | AC-005 | `grep -n "S-JSM-E2E-2\|statusCategory\|dynamic" docs/specs/jsm-e2e-coverage.md` → matches |
| Zero `src/` changes | AC-006 | `git diff --name-only HEAD \| grep -E "^src/"` → empty |
| `cargo test --test e2e_cli_surface_guard` exits 0 | AC-006 | confirms no broken SURFACE entries |
| `cargo test` exits 0 | smoke | no accidental Rust source changes |
| `cargo fmt --all -- --check` exits 0 | lint | no format drift |
| `cargo clippy --all-targets -- -D warnings` exits 0 | lint | zero warnings |
| `bash scripts/check-spec-counts.sh` exits 0 | invariant | BC frontmatter unchanged |
| `bash scripts/check-bc-cumulative-counts.sh` exits 0 | invariant | BC-INDEX.md unchanged |
| `bash scripts/check-bc-no-numeric-test-counts.sh` exits 0 | invariant | no BC body numeric count drift |

## Token Budget Estimate

| Item | Tokens (approx) |
|------|----------------|
| This story file | ~5 k |
| `docs/specs/jsm-e2e-coverage.md` §6 section (~80 LOC relevant) | ~2 k |
| `tests/e2e_live.rs` relevant sections (~400 LOC: two write tests + helper area) | ~5 k |
| `CLAUDE.md` JSM E2E section (~60 LOC relevant) | ~2 k |
| BC files (0 BCs modified — corpus unchanged) | 0 |
| Tool outputs (`cargo test`, `cargo clippy`, grep verifications, script exits) | ~2 k |
| **Total** | **~16 k** |

Well within a single-agent context window (~200 k). No split required.
LOC delta: `tests/e2e_live.rs` +~25 LOC (jsm_self_close helper) + ~4 LOC (2 call-site
rewires); `docs/specs/jsm-e2e-coverage.md` ~20 LOC churn in §6; `CLAUDE.md` ~5 LOC churn.
Zero `src/` LOC changes.

## Tasks

- [ ] Read `tests/e2e_live.rs` — locate `status_done()` helper, `test_e2e_jsm_comment_visibility`, `test_e2e_jsm_create_request_roundtrip`, and the harness/helper patterns (`e2e_cmd`, `E2EHarness` or equivalent) used for issuing commands
- [ ] Check `tests/e2e_cli_surface_guard.rs` — confirm whether `(&["issue", "transitions"], &["--output"])` is already present; add it only if missing
- [ ] Add `jsm_self_close(key: &str, h: …)` to `tests/e2e_live.rs` per AC-001: transitions fetch → parse → select done-category → move → warn-on-failure; no panics/asserts inside the helper
- [ ] Rewire teardown in `test_e2e_jsm_comment_visibility`: replace `jr issue move <key> <status_done()>` call with `jsm_self_close(&key, &h)`
- [ ] Rewire teardown in `test_e2e_jsm_create_request_roundtrip`: replace `jr issue move <key> <status_done()>` call with `jsm_self_close(&key, &h)`
- [ ] Confirm all ES-project teardown calls are untouched (AC-004): `status_done()` still used for ES tests
- [ ] Edit `docs/specs/jsm-e2e-coverage.md` §6 per AC-005: add revision note, replace §6.1 hardcoded-name assumption with dynamic discovery design, add Resolution-screen residual caveat
- [ ] Edit `CLAUDE.md` JSM teardown convention note: update to describe `jsm_self_close` + `statusCategory==done` pattern
- [ ] Run `git diff --name-only HEAD | grep -E "^src/"` — must return empty
- [ ] Run `cargo test --test e2e_cli_surface_guard` — must exit 0
- [ ] Run `cargo test` — must exit 0
- [ ] Run `cargo fmt --all -- --check` — must exit 0
- [ ] Run `cargo clippy --all-targets -- -D warnings` — must exit 0
- [ ] Run `bash scripts/check-spec-counts.sh && bash scripts/check-bc-cumulative-counts.sh && bash scripts/check-bc-no-numeric-test-counts.sh` — all must exit 0
- [ ] Commit: `fix(e2e): dynamic close-transition discovery for JSM self-close teardown (S-JSM-E2E-2)`

## Previous Story Intelligence

**Predecessor: S-JSM-E2E-1 (PR #460 → develop @ 04b6b2c, merged 2026-06-02)** — introduced
the 7 JSM E2E scenarios. Scenarios 5 and 6 (`test_e2e_jsm_comment_visibility`,
`test_e2e_jsm_create_request_roundtrip`) used `jr issue move <key> <status_done()>` for
teardown. This assumed the JSM project (EJ) has a transition named "Done". It does not.
Live run 26839267723 confirmed the failure: tests passed green, ~2 EJ tickets left open.

**Key lesson:** Hardcoded status names are fragile across Jira project types. The
`statusCategory.key` field (values: `"todo"`, `"indeterminate"`, `"done"`) is the stable,
project-type-agnostic signal. Always use category key for cross-project teardown.

**Predecessor: S-E2E-3/4/5** — established the dynamic-discovery pattern for queue/RT
fixtures. This story applies the same "probe live API, don't hardcode" principle to the
teardown/transition step.

**Architecture constraint maintained from S-JSM-E2E-1:** `jsm_self_close` uses
`jr issue transitions` + `jr issue move` — both existing platform commands. No `src/`
change. The teardown uses standard platform transitions (not servicedeskapi transitions),
which is correct: JSM issues are standard Jira issues under the service management layer,
and `POST /rest/api/3/issue/{key}/transitions` is valid for them.

## Architecture Compliance Rules

1. **Zero `src/` changes.** If any `src/` file appears in the diff, STOP and escalate.
   This story is entirely `tests/` + documentation.

2. **`jsm_self_close` must be pure best-effort.** No `panic!`, `assert!`, `unwrap()`, or
   `expect()` on the transitions-fetch or move path. All failure branches emit
   `eprintln!("[WARN] jsm_self_close: …")` and return `()`.

3. **Use `statusCategory.key == "done"` — not the status name.** Status names vary per
   workflow; `statusCategory.key` is a fixed Jira constant (`"todo"`, `"indeterminate"`,
   `"done"`) across all project types and workflow configurations.

4. **Do NOT change ES-project teardown.** The `status_done()` helper and its call sites in
   ES-targeting tests are correct and must not be touched.

5. **No new `JR_E2E_*` env vars.** Dynamic discovery reads from `jr issue transitions`
   output; no new configuration surface is introduced.

6. **BC corpus must remain unchanged.** Do NOT edit `BC-INDEX.md`, `CANONICAL-COUNTS.md`,
   or any `.factory/specs/prd/bc-*.md` file.

## Library & Framework Requirements

No new `Cargo.toml` dependencies. Zero Rust library additions.

| Tool/Crate | Already available | Usage in this story |
|------------|------------------|---------------------|
| `serde_json` | Yes (dev-dependency in tests) | Parse `jr issue transitions --output json` response in `jsm_self_close` |
| `std::process::Command` via `e2e_cmd()` | Yes (e2e_live.rs helper) | Invoke `jr issue transitions` and `jr issue move` |

## File Structure Requirements

| File | Action | Notes |
|------|--------|-------|
| `tests/e2e_live.rs` | MODIFY | Add `jsm_self_close` helper; rewire 2 JSM write-scenario teardown calls |
| `docs/specs/jsm-e2e-coverage.md` | MODIFY | §6 corrected: dynamic discovery design; revision note; Resolution-screen caveat |
| `CLAUDE.md` | MODIFY | JSM E2E teardown convention note updated for `jsm_self_close` pattern |

**Files confirmed NOT changed:**
- `src/` (all files — zero Rust source changes)
- `tests/e2e_cli_surface_guard.rs` (only if `issue transitions` already in SURFACE table)
- `.github/workflows/` (all workflow files)
- `Cargo.toml`, `Cargo.lock`, `deny.toml`
- `scripts/`, `.factory/specs/` (no BC, PRD, or architecture change)
- `BC-INDEX.md`, `CANONICAL-COUNTS.md`

## Branch / PR Plan

- Branch: `fix/jsm-e2e-self-close-teardown`
- Target: `develop`
- Commit: `fix(e2e): dynamic close-transition discovery for JSM self-close teardown (S-JSM-E2E-2)`
- PR body: reference this story (S-JSM-E2E-2), root cause (hardcoded "Done" fails EJ
  JSM workflow), fix design (statusCategory==done probe via `jr issue transitions --output
  json`), live run evidence (run 26839267723 — 2 orphaned EJ tickets).
- CHANGELOG entry: Add under `[Unreleased]` — "Fixed JSM write-scenario teardown: replaced
  hardcoded `jr issue move <key> Done` with dynamic `statusCategory==done` transition
  discovery via `jr issue transitions --output json` (`jsm_self_close` helper). Prevents
  orphaned EJ tickets on live runs. Fixes post-S-JSM-E2E-1 orphan defect (run 26839267723)."
