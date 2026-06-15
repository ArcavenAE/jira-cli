---
document_type: story
story_id: "S-CIGATE-1"
title: "ci.yml `ci-gate` aggregator job as single required status check"
wave: feature-followup
status: draft
intent: enhancement
feature_type: ci
mode: feature
scope: xsmall
severity: LOW
trivial_scope: false
points: 3
priority: P2
tdd_mode: strict
estimated_effort: xsmall
estimated_days: 0.5
target_module: ci
subsystems: []
depends_on: []
blocks: []
bc_anchors: []
bcs: []
# BC status: no product BCs (CI pipeline change; trace ACs to drift item WIN-CI-GATE-AGGREGATOR + STATE.md DEC-096/DEC-097). BC catalog stays at 597. Do NOT add BCs.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs:
  - ADR-0016
sd_refs: []
parent_phase: F1-delta-analysis
spec_source: ".factory/phase-f1-delta-analysis/win-ci-gate-aggregator/delta-analysis.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 6
assumption_validations: []
risk_mitigations: []
created: "2026-06-15"
last_updated: "2026-06-15"
breaking_change: false
files_modified:
  - .github/workflows/ci.yml              # ADD ci-gate aggregator job (~20 lines)
  - CLAUDE.md                             # ADD bullet under "Key Decisions" or "Conventions" noting ci-gate convention
  - docs/adr/0016-windows-build-target.md  # ADD informational one-line note in §5 CI section
  - tests/ci_gate_completeness.rs         # CREATE hermetic drift-prevention test (~30 lines)
---

# S-CIGATE-1 — ci.yml `ci-gate` Aggregator Job as Single Required Status Check

## Source of Truth

F1 Delta Analysis: `.factory/phase-f1-delta-analysis/win-ci-gate-aggregator/delta-analysis.md`
Drift item: WIN-CI-GATE-AGGREGATOR (STATE.md DEC-096, DEC-097, DEC-101)
ADR-0016: `docs/adr/0016-windows-build-target.md §5 CI`

## Behavioral Contracts

No product BCs are added or modified by this story. The BC catalog remains at 597 BCs / 42 NFRs / 16 ADRs.

This story traces its ACs to the drift item WIN-CI-GATE-AGGREGATOR and STATE.md DEC-096/DEC-097/DEC-101, following the same convention used by S-WIN-5 for CI-config stories with no product BC surface.

## Story Narrative

As a contributor to `jr`,
I want a stable `ci-gate` aggregator job in `.github/workflows/ci.yml` that acts as the single required branch-protection status check,
so that the required-status-check surface area is decoupled from CI matrix expansion — adding a new OS target or CI job does not silently invalidate branch protection, and the next emergency `PATCH required_status_checks` (cf. DEC-096) becomes unnecessary.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~2,000 |
| `.github/workflows/ci.yml` (current, ~170 LOC) | ~1,800 |
| `tests/ci_gate_completeness.rs` (new, ~450 LOC) | ~5,500 |
| `CLAUDE.md` relevant section (Key Decisions) | ~300 |
| `docs/adr/0016-windows-build-target.md` §5 CI section | ~300 |
| F1 delta analysis (design reference) | ~800 |
| **Total** | **~10,700** |

Well within 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**No story dependencies.** This is a standalone CI-infra story with `depends_on: []`.

**Precedent story:** S-WIN-5 (`S-WIN-5-ci-yml-windows-job.md`) is the closest prior CI-config story. It demonstrates the AC-tracing pattern for CI changes with no product BC: ACs trace to BC-6.2.017 (its closest BC), NFR-P-W1, and architecture-delta.md. This story mirrors that pattern, substituting WIN-CI-GATE-AGGREGATOR / DEC-096/DEC-097 as the trace targets.

**Context from DEC-096/DEC-097:** The S-WIN-5 Windows matrix expansion added `Clippy (windows-latest)` and `Test (windows-latest)` to ci.yml. These new matrix legs produced new GitHub check context strings that were NOT in branch protection's required list, so Dependabot and bot PRs that skipped the Windows jobs were mergeable without the Windows checks being green. DEC-097 fixed this reactively by patching required_status_checks. The `ci-gate` aggregator converts that O(n-matrix-legs) surface into a single stable `CI Gate` context that never changes regardless of how the matrix evolves.

**macOS dev host note (per Skip Log precedent S-WIN stories):** Demo evidence for this story = hermetic test green (`tests/ci_gate_completeness.rs`) + the actual `ci-gate` job green on the PR itself. No special macOS-specific constraints apply.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| `if: ${{ always() }}` is load-bearing | F1 delta analysis §4 (Skipped-Job Trap) | The `ci-gate` job MUST carry `if: ${{ always() }}`. Without it, a failed upstream causes `ci-gate` to be SKIPPED (not failed), which GitHub branch-protection evaluates as SUCCESS — the worst failure mode: a broken upstream silently permits merge. |
| Pass/fail step exits 1 on `failure` or `cancelled` | F1 delta analysis §4 | The gate step MUST exit 1 when `contains(needs.*.result, 'failure') || contains(needs.*.result, 'cancelled')`. It does NOT reject `skipped` — all six `needs` jobs run unconditionally on both push and PR events, so `skipped` is not possible for them. |
| PR-only jobs excluded from `needs` | F1 delta analysis §4 | `security` and `mutants` carry `if: github.event_name == 'pull_request'` and emit `skipped` on push events. Including them in `ci-gate.needs` would make every push-triggered `ci-gate` fail. They MUST NOT be in `needs`. |
| `spec-guard` IS included in `needs` | Human gate decision (DEC-101) | `spec-guard` has no `if:` guard and runs on both push and PR. The human gate decision promotes it to a blocking check via the aggregator. It MUST be in `ci-gate.needs`. |
| `name: CI Gate` in job definition | F1 delta analysis §5 | Setting `name: CI Gate` produces the human-readable branch-protection context string `"CI Gate"`. If `name:` is omitted, the context string would be `"ci-gate"`. The branch-protection migration PATCH must use `"CI Gate"` to match. |
| `coverage` excluded from `needs` | F1 delta analysis §4 | `coverage` uses `fail_ci_if_error: false` on the codecov upload; it is advisory by design. Must NOT be in `needs`. |
| `fmt` and `deny` stay ubuntu-only | S-WIN-5 AC-008 (existing) | The `fmt` and `deny` jobs are single-leg ubuntu-only. They ARE in `ci-gate.needs`, but their own `runs-on` configuration is untouched by this story. |

## Library and Framework Requirements

No library changes. This story modifies only YAML and Rust source-text-grep test code.

| Item | Version / Constraint |
|------|---------------------|
| serde_yaml / yaml parsing in test | Use `serde_yaml` (already in dev-deps via existing CI test precedent in `tests/ci_yml_windows_matrix.rs`) OR plain string parsing. Defer to F4 implementer's judgment — the `ci_yml_windows_matrix.rs` pattern is the reference. |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `.github/workflows/ci.yml` | MODIFY | Append `ci-gate` job at the end of the file. Job definition: `ci-gate:`, `name: CI Gate`, `runs-on: ubuntu-latest`, `needs: [fmt, clippy, test, msrv, deny, spec-guard]`, `if: ${{ always() }}`, one step `name: Fail if any required job failed or was cancelled` with `if: ${{ contains(needs.*.result, 'failure') || contains(needs.*.result, 'cancelled') }}` and `run: exit 1`. |
| `tests/ci_gate_completeness.rs` | CREATE | Hermetic drift-prevention test: parses `.github/workflows/ci.yml`, asserts a job named `ci-gate` exists, asserts `ci-gate.needs` contains exactly `[fmt, clippy, test, msrv, deny, spec-guard]` (order-insensitive). |
| `CLAUDE.md` | MODIFY | Add one bullet under "Key Decisions" or "Conventions": `ci-gate` is the single required branch-protection status check; new CI jobs that should be required must be added to `ci-gate.needs`, never to branch protection directly. |
| `docs/adr/0016-windows-build-target.md` | MODIFY | Add one informational sentence in §5 CI: "`ci-gate` is the required status check for `develop` and `main`; add new mandatory CI jobs to `ci-gate.needs`, not to branch protection directly." |

## Acceptance Criteria

### AC-001 — `ci-gate` job exists in ci.yml with correct structural properties
(traces to WIN-CI-GATE-AGGREGATOR / DEC-097 mitigation — stable single required check)

`.github/workflows/ci.yml` defines a job with key `ci-gate`, `name: CI Gate`, `runs-on: ubuntu-latest`, `needs: [fmt, clippy, test, msrv, deny, spec-guard]`, and `if: ${{ always() }}`.

Pinned by: `tests/ci_gate_completeness.rs::test_ci_gate_job_exists_with_correct_shell`

---

### AC-002 — `ci-gate` pass/fail semantics: exits 1 on failure or cancelled; passes when all six succeed
(traces to WIN-CI-GATE-AGGREGATOR / DEC-096 root-cause mitigation — skipped-job trap avoided)

The `ci-gate` job contains a step that exits 1 when `contains(needs.*.result, 'failure') || contains(needs.*.result, 'cancelled')`. The step carries `if: ${{ contains(needs.*.result, 'failure') || contains(needs.*.result, 'cancelled') }}` so it is skipped (and the job passes) when all `needs` results are `success`.

The `if: ${{ always() }}` at the job level is load-bearing: without it a failed upstream SKIPS `ci-gate` entirely, which GitHub branch-protection evaluates as SUCCESS — the worst failure mode (broken upstream silently permits merge). This rationale must appear as a comment in the `ci.yml` `ci-gate` job definition or in the step's `name:` field.

Pinned by: `tests/ci_gate_completeness.rs::test_ci_gate_fails_on_failed_or_cancelled_need` (source-text grep on `needs.*.result`, `'failure'`, `'cancelled'`) and `test_ci_gate_job_exists_with_correct_shell` (asserts job-level `if:` contains `always()`)
Integration gate: `ci-gate` job reports failure (not skip) when an upstream fails on the PR for this story — verified by observing a dry-run or the PR's own CI run.

---

### AC-003 — PR-only jobs (`security`, `mutants`) are NOT in `ci-gate.needs`; `spec-guard` IS included
(traces to WIN-CI-GATE-AGGREGATOR / DEC-101 — skipped-job trap + spec-guard promotion)

`security` and `mutants` MUST NOT appear in `ci-gate.needs` (they emit `skipped` on push events, which would poison push-triggered `ci-gate` runs).

`spec-guard` MUST appear in `ci-gate.needs` (it has no `if:` guard, runs on both push and PR, and is promoted to a blocking check by the human gate decision DEC-101).

`coverage` MUST NOT appear in `ci-gate.needs` (advisory by design; `fail_ci_if_error: false`).

Pinned by: `tests/ci_gate_completeness.rs::test_ci_gate_needs_exactly_the_required_jobs` (asserts `needs` is exactly `{fmt, clippy, test, msrv, deny, spec-guard}` — order-insensitive exact match, not a subset check) and `test_ci_gate_excludes_pr_only_jobs` (asserts `security`, `mutants`, `coverage` absent)

---

### AC-004 — Hermetic drift test: `tests/ci_gate_completeness.rs` exists and passes
(traces to WIN-CI-GATE-AGGREGATOR / DEC-096 repeat-prevention — catches next CI job added without wiring into aggregator)

`tests/ci_gate_completeness.rs` exists and contains the following six tests:

1. `test_ci_gate_job_exists_with_correct_shell` — asserts `ci-gate` job exists with `name: CI Gate`, `runs-on: ubuntu-latest`, and job-level `if:` containing `always()`
2. `test_ci_gate_needs_exactly_the_required_jobs` — asserts `ci-gate.needs` equals `{fmt, clippy, test, msrv, deny, spec-guard}` (order-insensitive exact match)
3. `test_ci_gate_excludes_pr_only_jobs` — asserts `security`, `mutants`, and `coverage` are absent from `ci-gate.needs`
4. `test_ci_gate_fails_on_failed_or_cancelled_need` — asserts the gate step references `needs.*.result`, `'failure'`, and `'cancelled'`
5. `test_ci_gate_needs_jobs_have_no_event_conditional_if` (M1 hardening) — asserts no job in `ci-gate.needs` carries a job-level `if:` that references `github.event_name`; pins the unconditional-execution invariant; closes the EC-002 drift vector
6. `test_ci_gate_pass_fail_semantics_are_structurally_placed` (M2 hardening) — asserts `always()` is the job-level `if:` and does NOT contain `contains(needs`; `contains(needs.*.result,'failure'/'cancelled')` is on a step-level `if:`; and a `run:` step exists; prevents always()/contains() transposition reopening the skipped-job trap

Test naming follows the project convention `test_<verb>_<subject>_<expected_outcome>`.

Rationale: this test is the only automated safeguard that catches "new required CI job added but not wired into `ci-gate.needs`." Without it, the next S-WIN-style matrix expansion could re-introduce the same fragility class.

Pinned by: `cargo test --test ci_gate_completeness` exits 0.

---

### AC-005 — Documentation: CLAUDE.md bullet + ADR-0016 §5 informational note
(traces to WIN-CI-GATE-AGGREGATOR — convention codified so future contributors do not bypass the aggregator)

> **Scope note:** These documentation edits were classified as "optional" in the F1 delta analysis but are promoted to required ACs here for traceability — they are the codified convention that prevents the DEC-096/DEC-097 fragility class from recurring. A future contributor who skips them cannot know the `ci-gate` convention exists.

(a) `CLAUDE.md` contains a bullet (under "Key Decisions" or "Conventions") stating that `ci-gate` is the single required branch-protection status check and that new CI jobs requiring blocking must be added to `ci-gate.needs`, never to branch protection directly.

(b) `docs/adr/0016-windows-build-target.md` §5 CI contains a one-line informational note with equivalent content.

These documentation changes do not affect `cargo test` but are verifiable by source-text inspection.

Pinned by: source-text inspection on the PR diff (no automated test — documentation-only assertion).

---

### AC-006 — Branch-protection migration: manual post-merge step (documented, NOT code-gated)
(traces to WIN-CI-GATE-AGGREGATOR / DEC-097 — transition safety; human action, out of harness scope)

The following ORDERED repo-admin action is required AFTER this PR merges and `ci-gate` is observed green on at least one push/PR run. This is a HUMAN action the harness cannot perform:

**Step 1:** Verify `ci-gate` is reporting `success` on `develop`.

**Step 2 (develop):**
```bash
gh api --method PATCH \
  repos/{owner}/jira-cli/branches/develop/protection/required_status_checks \
  -f 'checks[][context]=CI Gate' \
  -F 'checks[][app_id]=15368'
```

> **Note on `app_id: 15368`:** This is the GitHub Actions app ID on github.com (the app that reports CI check contexts). Before applying the PATCH, confirm it matches an existing Actions-reported context's `app_id` by inspecting the GET response: `gh api repos/{owner}/jira-cli/branches/develop/protection/required_status_checks`. Use the `app_id` value shown for any existing CI check context (e.g., `test`) — if it differs from 15368, use the value from the GET response instead.

**Step 2b — post-PATCH verification (develop):**
```bash
gh api repos/{owner}/jira-cli/branches/develop/protection/required_status_checks
```
Confirm `"CI Gate"` appears in the `checks` array. Also confirm `strict: false` was preserved (the PATCH payload omits `strict`, which keeps the existing value — do not add `strict: true` to the payload).

**Step 3 (main):**
```bash
gh api --method PATCH \
  repos/{owner}/jira-cli/branches/main/protection/required_status_checks \
  -f 'checks[][context]=CI Gate' \
  -F 'checks[][app_id]=15368'
```

**Step 3b — post-PATCH verification (main):**
```bash
gh api repos/{owner}/jira-cli/branches/main/protection/required_status_checks
```
Confirm `"CI Gate"` appears in the `checks` array and `strict: false` is preserved.

**CRITICAL ordering constraint:** NEVER remove the old required contexts BEFORE `ci-gate` is confirmed green. If you remove them first and `ci-gate` is broken or missing, there is no gating check and merges become unprotected. Add the new `CI Gate` context first; old contexts can be removed after the swap is verified.

This AC is marked INFORMATIONAL — it is not a code-gated acceptance criterion but must be executed by a repo-admin to complete the drift item resolution.

---

## Out of Scope (explicit)

- **`security` and `mutants` joining `ci-gate.needs`**: these are PR-only jobs. If they are ever promoted to required, that is a separate story — keep this one minimal.
- **`coverage` joining `ci-gate.needs`**: advisory by design (`fail_ci_if_error: false`).
- **Any change to the existing `fmt`, `clippy`, `test`, `msrv`, `deny`, `spec-guard` job definitions**: this story only adds the aggregator job.
- **Removing old required_status_check contexts** before `ci-gate` is confirmed green on develop.

---

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `ci-gate` job | `.github/workflows/ci.yml` | N/A (CI config) | Aggregates upstream job results; reports single stable context to branch protection |
| `tests/ci_gate_completeness.rs` | `tests/` | Pure (source-text grep) | Hermetic drift-prevention; reads YAML file, makes structural assertions |

---

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-001 | F1 delta analysis §4 (Skipped-Job Trap) | Failed upstream without `if: always()` on `ci-gate` | `ci-gate` is SKIPPED (not failed); GitHub evaluates skip as success → unprotected merge. Mitigation: `if: ${{ always() }}` is REQUIRED at job level. |
| EC-002 | F1 delta analysis §4 | Future CI job added to `needs` that has `if: github.event_name == 'pull_request'` | That job emits `skipped` on push → `ci-gate` would pass on push even when that job is broken. Mitigation: `test_ci_gate_needs_jobs_have_no_event_conditional_if` (M1) asserts no job in `ci-gate.needs` carries a job-level `if:` referencing `github.event_name`; this test fails when a PR-only job is mistakenly added to `needs`; doc (AC-005) warns contributors. |
| EC-003 | F1 delta analysis §5 | `name: CI Gate` omitted from job definition | Branch-protection context becomes `ci-gate` (kebab) instead of `CI Gate` (human-readable). The PATCH payload in AC-006 must match exactly. Mitigation: `name: CI Gate` is specified in AC-001. |
| EC-004 | DEC-097 precedent | Old required contexts removed before `ci-gate` is green | No gating check; unprotected merges. Mitigation: AC-006 ordering constraint (add first, verify, then swap). |
| EC-005 | AC-004 test design | `ci_gate_completeness.rs` exact-set check fails after a legitimate CI job is added to `needs` | Expected outcome — the test fails intentionally, prompting the author to (a) confirm the new job has no PR-only `if:` guard and (b) update the expected set in the test. |

---

## Test Coverage Summary

| # | Test name | File | AC |
|---|-----------|------|-----|
| 1 | `test_ci_gate_job_exists_with_correct_shell` | `tests/ci_gate_completeness.rs` | AC-001, AC-002 (`always()` presence) |
| 2 | `test_ci_gate_fails_on_failed_or_cancelled_need` | `tests/ci_gate_completeness.rs` | AC-002 |
| 3 | `test_ci_gate_needs_exactly_the_required_jobs` | `tests/ci_gate_completeness.rs` | AC-003 (exact-set) |
| 4 | `test_ci_gate_excludes_pr_only_jobs` | `tests/ci_gate_completeness.rs` | AC-003 (exclusion) |
| 5 | `test_ci_gate_needs_jobs_have_no_event_conditional_if` | `tests/ci_gate_completeness.rs` | AC-003 / EC-002 hardening (M1) — asserts no job in `ci-gate.needs` carries a job-level `if:` referencing `github.event_name`; pins the unconditional-execution invariant |
| 6 | `test_ci_gate_pass_fail_semantics_are_structurally_placed` | `tests/ci_gate_completeness.rs` | AC-002 hardening (M2) — asserts `always()` is on the job-level `if:` and does NOT contain `contains(needs`; `contains(needs.*.result,'failure'/'cancelled')` is on a step-level `if:`; a `run:` step exists; prevents always()/contains() transposition reopening the skipped-job trap |

AC-004 is covered by the six tests above (they ARE the hermetic test).
AC-005 and AC-006 are verified by source-text inspection and human action respectively — no automated test.

---

## Dependency Analysis

**depends_on: []** — No story dependencies. This is a standalone CI-infra story.

**blocks: []** — No story depends on this.

Topological order: standalone (Wave 1 in any wave-scheduling pass that honors the empty `depends_on`).

---

## Tasks

1. Read `.github/workflows/ci.yml` to understand the current job list and structure.
2. Append the `ci-gate` job at the end of `ci.yml`:
   ```yaml
   ci-gate:
     name: CI Gate
     runs-on: ubuntu-latest
     needs: [fmt, clippy, test, msrv, deny, spec-guard]
     if: ${{ always() }}
     steps:
       - name: Fail if any required job failed or was cancelled
         if: >-
           ${{ contains(needs.*.result, 'failure') ||
               contains(needs.*.result, 'cancelled') }}
         run: exit 1
   ```
3. Create `tests/ci_gate_completeness.rs` with six test functions (see AC-004). Reference `tests/ci_yml_windows_matrix.rs` as the pattern for YAML source-text parsing in this repo.
4. Add the `ci-gate` convention bullet to `CLAUDE.md`.
5. Add the one-line informational note to `docs/adr/0016-windows-build-target.md` §5 CI.
6. Run `cargo test --test ci_gate_completeness` — all six tests pass.
7. Run `cargo test` — full suite green (no regression).
8. Run `cargo clippy -- -D warnings` — zero warnings.

## Story Points and Effort

**3 story points** (xsmall). Breakdown:
- F4 TDD (`ci.yml` addition + `tests/ci_gate_completeness.rs` + CLAUDE.md + `docs/adr/0016-windows-build-target.md`): 2 SP
- F5/F7 review + CI gate verification (confirm `ci-gate` job green on PR): 1 SP

The implementation is ~20 lines of YAML + ~30 lines of test + ~5 lines of documentation.
No Rust src/ changes. No product behavior changes. Risk: LOW (see F1 analysis §6).
