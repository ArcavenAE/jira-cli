---
document_type: story
level: ops
story_id: "S-CIGATE-1"
epic_id: "none"
title: "ci.yml `ci-gate` aggregator job as single required status check"
version: "1.3"
producer: story-writer
timestamp: "2026-06-15T00:00:00"
phase: 3
cycle: WIN-CI-GATE-AGGREGATOR
inputs:
  - ".github/workflows/ci.yml"
  - "docs/adr/0016-windows-build-target.md"
input-hash: "e9094ab"
traces_to: "STATE.md DEC-096/DEC-097/DEC-101"
wave: feature-followup
status: done
# status set to `done` 2026-08-07 (S-CIGATE-1 class-level correction sweep,
# 30-occurrence pass): deliverables shipped in PR #518 (2026-06); `ci-gate`
# has been the sole required branch-protection status check on develop/main
# for ~2 months as of this sweep (verified: `ci-gate.needs` present and
# green-gating at branch head 3ad496eb). Matches sibling `S-CIGATE-4`'s
# `status: done` convention for shipped, no-further-action stories.
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
behavioral_contracts: []
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
last_updated: "2026-08-07"
breaking_change: false
files_modified:
  - .github/workflows/ci.yml              # ADD ci-gate aggregator job (~20 lines original estimate; actual ci.yml is 675 LOC total as of 2026-08-07, grown across follow-up stories, not this story's own scope)
  - CLAUDE.md                             # ADD bullet under "Key Decisions" or "Conventions" noting ci-gate convention
  - docs/adr/0016-windows-build-target.md  # ADD informational one-line note in Decision 3 (CI) section
  - tests/ci_gate_completeness.rs         # CREATE hermetic drift-prevention test (~30 lines original estimate; actual file is 5,214 LOC / 22 #[test] fns as of 2026-08-07, grown across follow-up stories S-CIGATE-2 et al.)
---

# S-CIGATE-1 — ci.yml `ci-gate` Aggregator Job as Single Required Status Check

## Source of Truth

F1 Delta Analysis: `.factory/phase-f1-delta-analysis/win-ci-gate-aggregator/delta-analysis.md`
Drift item: WIN-CI-GATE-AGGREGATOR (STATE.md DEC-096, DEC-097, DEC-101)
ADR-0016: `docs/adr/0016-windows-build-target.md` Decision 3 (Add Windows job to `ci.yml`)

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
| `docs/adr/0016-windows-build-target.md` Decision 3 (CI) section | ~300 |
| F1 delta analysis (design reference) | ~800 |
| **Total** | **~10,700** |

Well within 20% agent context window budget. No splitting required.

**[ESTIMATE DRIFT NOTE — added 2026-08-07, S-CIGATE-1 sweep]:** The row values
above are authoring-time (2026-06-15) sizing *estimates* for planning
purposes, not measurements of the shipped artifacts — left unchanged rather
than corrected in place, since a wrong estimate isn't a false claim, only a
stale prediction. For reference, actual current sizes at head `3ad496eb` are
substantially larger than estimated: `.github/workflows/ci.yml` is 675 LOC
(vs. ~170 estimated) and `tests/ci_gate_completeness.rs` is 5,214 LOC across
22 `#[test]` functions (vs. ~450 LOC estimated) — both grew across multiple
follow-up stories (`S-FORK-OPS-SIGN-1`, `S-MUTATION-CI-TIMEOUT-1`,
`S-CIGATE-2`, and CI-hygiene hardening rounds), not because this story's
own scope grew. The "well within budget" conclusion still held at
authoring time and is not being retroactively re-evaluated against the
grown files, since this story's own deliverable was never re-opened to
consume that budget.

## Previous Story Intelligence

**No story dependencies.** This is a standalone CI-infra story with `depends_on: []`.

**Precedent story:** S-WIN-5 (`S-WIN-5-ci-yml-windows-job.md`) is the closest prior CI-config story. It demonstrates the AC-tracing pattern for CI changes with no product BC: ACs trace to BC-6.2.017 (its closest BC), NFR-P-W1, and architecture-delta.md. This story mirrors that pattern, substituting WIN-CI-GATE-AGGREGATOR / DEC-096/DEC-097 as the trace targets.

**Context from DEC-096/DEC-097:** The S-WIN-5 Windows matrix expansion added `Clippy (windows-latest)` and `Test (windows-latest)` to ci.yml. These new matrix legs produced new GitHub check context strings that were NOT in branch protection's required list, so Dependabot and bot PRs that skipped the Windows jobs were mergeable without the Windows checks being green. DEC-097 fixed this reactively by patching required_status_checks. The `ci-gate` aggregator converts that O(n-matrix-legs) surface into a single stable `CI Gate` context that never changes regardless of how the matrix evolves.

**macOS dev host note (per Skip Log precedent S-WIN stories):** Demo evidence for this story = hermetic test green (`tests/ci_gate_completeness.rs`) + the actual `ci-gate` job green on the PR itself. No special macOS-specific constraints apply.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| `if: ${{ always() }}` is load-bearing | F1 delta analysis §4 (Skipped-Job Trap) | The `ci-gate` job MUST carry `if: ${{ always() }}`. Without it, a failed upstream causes `ci-gate` to be SKIPPED (not failed), which GitHub branch-protection evaluates as SUCCESS — the worst failure mode: a broken upstream silently permits merge. |
| Pass/fail step exits 1 on `failure` or `cancelled` **[MECHANISM RETIRED — corrected 2026-08-07, S-CIGATE-1 sweep: this title and the constraint sentence below describe the original inline `contains()` step-`if:` design. That design was retired since `S-CIGATE-2` (PR #671) in favor of `scripts/check-ci-gate.sh::evaluate_needs`; see the FALSE PREMISE CORRECTED block later in this cell for the full current-mechanism explanation — not duplicated here.]** | F1 delta analysis §4 | The gate step MUST exit 1 when `contains(needs.*.result, 'failure')` is true OR `contains(needs.*.result, 'cancelled')` is true. It does NOT reject `skipped` — at authoring time, all six `needs` jobs ran unconditionally on both push and PR events, so `skipped` was not possible for them. **[STALE COUNT — corrected 2026-08-06, S-CIGATE-4]:** `ci-gate.needs` has grown to **eight** jobs (`check-signing-workflow-injection` per `S-FORK-OPS-SIGN-1`; `mutants` per `S-MUTATION-CI-TIMEOUT-1`, added since this story was authored), and `mutants` now DOES report `skipped` on every push by design. **[FALSE PREMISE CORRECTED — 2026-08-07, ADV-P49-LOW-001]:** the sentence above is kept verbatim as the historical record of what was true at authoring time (2026-06-15) — it is now FALSE as a claim about the current job set, not merely stale: `mutants` is a member of `needs` and carries a job-level `if: github.event_name == 'pull_request'`, so it genuinely DOES report `skipped` on every push, exactly the condition the sentence above says cannot happen. The pass/fail design still holds today, but for a different, current reason that the sentence above never stated: it does not hold because `skipped` cannot occur — it holds because the mechanism that decides the gate is no longer the inline `contains()` condition described in this row's own title at all. Since `S-CIGATE-2` (PR #671), the `ci-gate` job's step runs `scripts/check-ci-gate.sh::evaluate_needs` (verified against the shipped `.github/workflows/ci.yml :: ci-gate` job on `develop`), a fail-closed evaluator: a job result of `success` passes; `skipped` passes ONLY for a job named in the restrictive `ALLOWED_SKIPS` allowlist declared in that script (currently `mutants` alone); every other value — `failure`, `cancelled`, an unlisted `skipped`, or any result string the evaluator has never seen before — fails via a default `case` arm, not an enumerated list of known-bad values. `mutants` reporting `skipped` on every push is therefore a deliberately tolerated, explicitly named exception (`scripts/check-ci-gate.sh::is_allowed_skip`), not an accidental gap the original reasoning happened to get away with. See AC-003's correction blockquote below for the companion `needs`-membership history, and `scripts/check-ci-gate.sh` directly for the evaluator itself. |
| PR-only jobs excluded from `needs` | F1 delta analysis §4 | `security` and `mutants` carry `if: github.event_name == 'pull_request'` and emit `skipped` on push events. Including them in `ci-gate.needs` would make every push-triggered `ci-gate` fail. They MUST NOT be in `needs`. **[CORRECTION — 2026-08-06, S-CIGATE-4]:** This row is superseded for `mutants`; see the AC-003 blockquote below for the full correction and rationale. `security` is unaffected — it remains correctly excluded from `needs`. |
| `spec-guard` IS included in `needs` | Human gate decision (DEC-101) | `spec-guard` has no `if:` guard and runs on both push and PR. The human gate decision promotes it to a blocking check via the aggregator. It MUST be in `ci-gate.needs`. |
| `name: CI Gate` in job definition | F1 delta analysis §5 | Setting `name: CI Gate` produces the human-readable branch-protection context string `"CI Gate"`. If `name:` is omitted, the context string would be `"ci-gate"`. The branch-protection migration PATCH must use `"CI Gate"` to match. |
| `coverage` excluded from `needs` | F1 delta analysis §4 | `coverage` uses `fail_ci_if_error: false` on the codecov upload; it is advisory by design. Must NOT be in `needs`. |
| `fmt` and `deny` stay ubuntu-only | S-WIN-5 AC-008 (existing) | The `fmt` and `deny` jobs are single-leg ubuntu-only. They ARE in `ci-gate.needs`, but their own `runs-on` configuration is untouched by this story. |

## Library & Framework Requirements (MANDATORY)

No library changes. This story modifies only YAML and Rust source-text-grep test code.

| Item | Version / Constraint |
|------|---------------------|
| serde_yaml / yaml parsing in test | Use `serde_yaml` (already in dev-deps via existing CI test precedent in `tests/ci_yml_windows_matrix.rs`) OR plain string parsing. Defer to F4 implementer's judgment — the `ci_yml_windows_matrix.rs` pattern is the reference. |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `.github/workflows/ci.yml` | MODIFY | **[RETIRED SHAPE — corrected 2026-08-07, S-CIGATE-1 sweep: the instruction below is preserved verbatim as the authoring-time (2026-06-15) build recipe. It is NOT the shape to follow today — `needs` is now an eight-member list, and the `contains(needs.*.result, …)` step-`if:` mechanism was retired by `S-CIGATE-2` (PR #671) in favor of `scripts/check-ci-gate.sh`. Do not use this cell to reintroduce either; see the shipped shape in the Tasks section's step 2 correction below.]** Append `ci-gate` job at the end of the file. Job definition: `ci-gate:`, `name: CI Gate`, `runs-on: ubuntu-latest`, `needs: [fmt, clippy, test, msrv, deny, spec-guard]`, `if: ${{ always() }}`, one step `name: Fail if any required job failed or was cancelled` with an `if:` that is true when `contains(needs.*.result, 'failure')` OR `contains(needs.*.result, 'cancelled')`, and `run: exit 1`. |
| `tests/ci_gate_completeness.rs` | CREATE | Hermetic drift-prevention test: parses `.github/workflows/ci.yml`, asserts a job named `ci-gate` exists, asserts `ci-gate.needs` contains exactly `[fmt, clippy, test, msrv, deny, spec-guard]` (order-insensitive). **[STALE COUNT — corrected 2026-08-07, S-CIGATE-1 sweep]:** at head `3ad496eb` the shipped test (`test_ci_gate_needs_exactly_the_required_jobs`) asserts the eight-member set `{fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants}`, not the six named here. |
| `CLAUDE.md` | MODIFY | Add one bullet under "Key Decisions" or "Conventions": `ci-gate` is the single required branch-protection status check; new CI jobs that should be required must be added to `ci-gate.needs`, never to branch protection directly. |
| `docs/adr/0016-windows-build-target.md` | MODIFY | Add one informational sentence in Decision 3 (Add Windows job to `ci.yml`): "`ci-gate` is the required status check for `develop` and `main`; add new mandatory CI jobs to `ci-gate.needs`, not to branch protection directly." |

## Acceptance Criteria

### AC-001 — `ci-gate` job exists in ci.yml with correct structural properties
(traces to WIN-CI-GATE-AGGREGATOR / DEC-097 mitigation — stable single required check)

`.github/workflows/ci.yml` defines a job with key `ci-gate`, `name: CI Gate`, `runs-on: ubuntu-latest`, `needs: [fmt, clippy, test, msrv, deny, spec-guard]`, and `if: ${{ always() }}`.

**[STALE COUNT — corrected 2026-08-07, S-CIGATE-1 sweep]:** at head `3ad496eb`, `ci-gate.needs` is the eight-member superset `{fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants}`. The six jobs named above remain members but no longer form the exhaustive list — see AC-003's correction for how `check-signing-workflow-injection` and `mutants` were added.

Pinned by: `tests/ci_gate_completeness.rs::test_ci_gate_job_exists_with_required_metadata`
(formerly `test_ci_gate_job_exists_with_correct_shell` through PR #518; renamed S-626-1 round 19,
commit `e076e96b` — the old name asserted a `shell:` guarantee the body never checked, only
name/runs-on/`if:`)

---

### AC-002 — `ci-gate` pass/fail semantics: exits 1 on failure or cancelled; passes when all six succeed
(traces to WIN-CI-GATE-AGGREGATOR / DEC-096 root-cause mitigation — skipped-job trap avoided)

> **[STALE COUNT — corrected 2026-08-06, S-CIGATE-4]:** "all six succeed" reflects the
> six-job `needs` list at authoring time. `ci-gate.needs` has since grown to **eight** jobs
> (`check-signing-workflow-injection` per `S-FORK-OPS-SIGN-1`; `mutants` per
> `S-MUTATION-CI-TIMEOUT-1`). The title is left as historical record rather than rewritten;
> see the AC-003 correction below for the substantive change (`mutants` now deliberately
> tolerates `skipped`, not just `success`, under `S-CIGATE-2`'s fix).
>
> **[FALSE PREMISE CORRECTED — 2026-08-07, ADV-P49-LOW-001]:** the Architecture Compliance
> Rules table's companion row ("Pass/fail step exits 1 on `failure` or `cancelled`") gave, as
> its reason `skipped` needed no explicit handling, the claim that "all six `needs` jobs ran
> unconditionally on both push and PR events, so `skipped` was not possible for them." That
> claim is FALSE at this head — `mutants` is in `needs` and carries `if:
> github.event_name == 'pull_request'`, so it DOES report `skipped` on every push, by design.
> The pass/fail design nonetheless still holds, for a reason not previously stated at either
> site: since `S-CIGATE-2` (PR #671), the gate no longer decides pass/fail via the inline
> `contains(needs.*.result, 'failure'/'cancelled')` condition this AC describes — that
> condition was retired in favor of `scripts/check-ci-gate.sh::evaluate_needs`, a fail-closed
> evaluator verified against the shipped `.github/workflows/ci.yml :: ci-gate` job on
> `develop`. It treats `success` as pass; `skipped` as pass ONLY for a job named in its
> restrictive `ALLOWED_SKIPS` allowlist (`mutants` alone today); and every other value —
> `failure`, `cancelled`, an unlisted `skipped`, or an unrecognized result string — as fail,
> via a default arm rather than an enumerated list of known-bad values. See the Architecture
> Compliance Rules table's matching correction above for the same fix at its origin site.

**[MECHANISM RETIRED — corrected 2026-08-07, S-CIGATE-1 sweep]:** the paragraph immediately below (originally present tense, describing the design as current) is preserved as the authoring-time (2026-06-15) mechanism description. It is FALSE as a claim about current head `3ad496eb`: since `S-CIGATE-2` (PR #671), the `ci-gate` job runs `scripts/check-ci-gate.sh::evaluate_needs` unconditionally via a `run:` step with no step-level `if:` at all — the script's own exit code is the pass/fail signal. See the STALE COUNT / FALSE PREMISE CORRECTED blocks above this AC for the full current-mechanism explanation.

~~The `ci-gate` job contains a step that exits 1 when `contains(needs.*.result, 'failure') || contains(needs.*.result, 'cancelled')`. The step carries `if: ${{ contains(needs.*.result, 'failure') || contains(needs.*.result, 'cancelled') }}` so it is skipped (and the job passes) when all `needs` results are `success`.~~ (historical, authoring-time only — do not reimplement)

The `if: ${{ always() }}` at the job level is load-bearing: without it a failed upstream SKIPS `ci-gate` entirely, which GitHub branch-protection evaluates as SUCCESS — the worst failure mode (broken upstream silently permits merge). This rationale must appear as a comment in the `ci.yml` `ci-gate` job definition or in the step's `name:` field.

**[STATUS AS OF SWEEP — 2026-08-07, S-CIGATE-1 sweep]:** verified NOT satisfied at head `3ad496eb` — the `ci-gate` job block contains a comment (ADV-P50-LOW-003) explaining `timeout-minutes: 5`, but no comment or step `name:` carrying the `always()` load-bearing rationale. This AC is intentionally left standing (not retired, not weakened) — a fix is in flight in parallel to add the missing comment to `ci.yml`. Do not treat this note as satisfying the requirement; it records status only.

Pinned by: `tests/ci_gate_completeness.rs::test_ci_gate_fails_on_failed_or_cancelled_need` and `test_ci_gate_job_exists_with_required_metadata` (asserts job-level `if:` contains `always()`; formerly `test_ci_gate_job_exists_with_correct_shell` through PR #518, renamed S-626-1 round 19, commit `e076e96b`)

**[INVERTED — corrected 2026-08-07, S-CIGATE-1 sweep]:** `test_ci_gate_fails_on_failed_or_cancelled_need` was originally (and is still) described here as "source-text grep on `needs.*.result`, `'failure'`, `'cancelled'`" — a *positive* grep for those substrings. At head `3ad496eb` the test asserts the exact opposite: `!gate_block.contains("contains(needs.*.result")` (the retired condition must be ABSENT) AND `gate_block.contains("check-ci-gate.sh")` (the replacement script invocation must be PRESENT). The retired positive-grep description above is kept as authoring-time record; do not use it to predict the test's current pass/fail behavior.
Integration gate: `ci-gate` job reports failure (not skip) when an upstream fails on the PR for this story — verified by observing a dry-run or the PR's own CI run.

---

### AC-003 — PR-only jobs (`security`, `mutants`) are NOT in `ci-gate.needs`; `spec-guard` IS included
(traces to WIN-CI-GATE-AGGREGATOR / DEC-101 — skipped-job trap + spec-guard promotion)

> **CORRECTION (2026-08-06, S-CIGATE-4):** the "`mutants` MUST NOT appear in `ci-gate.needs`"
> clause below is **superseded by shipped reality and is now obsolete** — not deleted, kept
> as the historical record of what was believed correct at authoring time (2026-06-15).
> `mutants` **is required** to remain in `ci-gate.needs`, per `S-MUTATION-CI-TIMEOUT-1`
> (PR #567, 2026-06-28), which added it to enforce a 90% mutation kill-rate gate on every PR;
> `tests/ci_gate_completeness.rs::test_mutants_is_in_ci_gate_needs` asserts the literal
> opposite of this AC's original clause. `S-CIGATE-2-skipped-status-false-green.md`'s
> approved fix (Option C, PR #671, in-flight on the frozen `fix/ci-gate-skipped-false-green`
> branch at authoring time of this correction) goes further: it requires `mutants` to keep
> its job-level `if: github.event_name == 'pull_request'` guard entirely unchanged, and names
> `mutants` as the sole entry in a new, restrictive `ALLOWED_SKIPS` allowlist inside
> `scripts/check-ci-gate.sh` — a `skipped` result from `mutants` on push is now a
> *deliberately tolerated, explicitly named* exception, not an accidental gap.
>
> **Why the prohibition is obsolete, not merely overridden:** the original reasoning was
> correct when written — under the pre-`S-CIGATE-2` inline
> `contains(needs.*.result, 'failure')`/`contains(needs.*.result, 'cancelled')` condition,
> there was no mechanism to distinguish a trusted, expected `skipped` (a PR-only job on a
> push event) from an untrusted one, so including any job that could report `skipped` really
> would have "poisoned" push-triggered `ci-gate` runs by letting them pass unverified. What
> changed is not the reasoning but the underlying hazard: `S-CIGATE-2`'s fail-closed evaluator
> with a restrictive, explicit, per-job allowlist closed exactly that gap, making
> `mutants`-reports-`skipped` a safe, named, auditable exception instead of an accidental one.
> `security` is unaffected by this correction and remains correctly excluded from
> `ci-gate.needs` — only the `mutants` half of this AC's prohibition is obsolete.
>
> Full detail: `.factory/stories/S-CIGATE-4-reconcile-ac003-mutants-prohibition.md`.

`security` and `mutants` MUST NOT appear in `ci-gate.needs` (they emit `skipped` on push events, which would poison push-triggered `ci-gate` runs).

`spec-guard` MUST appear in `ci-gate.needs` (it has no `if:` guard, runs on both push and PR, and is promoted to a blocking check by the human gate decision DEC-101).

`coverage` MUST NOT appear in `ci-gate.needs` (advisory by design; `fail_ci_if_error: false`).

Pinned by: `tests/ci_gate_completeness.rs::test_ci_gate_needs_exactly_the_required_jobs` (**[STALE COUNT — corrected 2026-08-07, S-CIGATE-1 sweep]:** at head `3ad496eb` this test asserts `needs` is exactly the eight-member set `{fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants}`, not the six-member set `{fmt, clippy, test, msrv, deny, spec-guard}` named here at authoring time — order-insensitive exact match, not a subset check) and `test_ci_gate_excludes_advisory_and_secret_scan_jobs` (renamed from `test_ci_gate_excludes_pr_only_jobs` by PR #567, commit `3b122a8f`, S-MUTATION-CI-TIMEOUT-1; asserts `security`, `coverage` absent — `mutants` is no longer in this test's exclusion set, per the CORRECTION above)

---

### AC-004 — Hermetic drift test: `tests/ci_gate_completeness.rs` exists and passes
(traces to WIN-CI-GATE-AGGREGATOR / DEC-096 repeat-prevention — catches next CI job added without wiring into aggregator)

`tests/ci_gate_completeness.rs` exists and contains the following six tests:

**[STALE COUNT — corrected 2026-08-07, S-CIGATE-1 sweep]:** "the following six tests" describes the AC-004 authoring-time scope only. At head `3ad496eb`, `tests/ci_gate_completeness.rs` contains 22 `#[test]` functions total — the six enumerated below (with corrections applied) plus 16 more added by later, unrelated CI-hardening stories (`S-CIGATE-2`'s own `test_mutants_is_in_ci_gate_needs` plus M2-family structural-placement tests, MSRV/pipefail/shell-override hygiene tests, etc.) that are out of this story's scope. "The following six" therefore still correctly identifies AC-004's own coverage set — it is not a claim that the file contains only six tests.

1. `test_ci_gate_job_exists_with_required_metadata` (formerly `test_ci_gate_job_exists_with_correct_shell` through PR #518; renamed S-626-1 round 19, commit `e076e96b`) — asserts `ci-gate` job exists with `name: CI Gate`, `runs-on: ubuntu-latest`, and job-level `if:` containing `always()`
2. `test_ci_gate_needs_exactly_the_required_jobs` — asserts `ci-gate.needs` equals `{fmt, clippy, test, msrv, deny, spec-guard}` (order-insensitive exact match). **[STALE COUNT — corrected 2026-08-07, S-CIGATE-1 sweep]:** at head `3ad496eb` this test asserts the eight-member set `{fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants}` instead — see AC-003's correction.
3. `test_ci_gate_excludes_advisory_and_secret_scan_jobs` (renamed from `test_ci_gate_excludes_pr_only_jobs` by PR #567, commit `3b122a8f`, S-MUTATION-CI-TIMEOUT-1) — asserts `security` and `coverage` are absent from `ci-gate.needs`. **[CORRECTION — 2026-08-06, S-CIGATE-4]:** `mutants` is no longer part of this test's exclusion set — see the AC-003 correction above.
4. `test_ci_gate_fails_on_failed_or_cancelled_need` — asserts the gate step references `needs.*.result`, `'failure'`, and `'cancelled'`. **[INVERTED — corrected 2026-08-07, S-CIGATE-1 sweep]:** at head `3ad496eb` this test asserts the opposite — that the `ci-gate` block does NOT contain `contains(needs.*.result` and DOES contain `check-ci-gate.sh` — see the AC-002 correction above.
5. `test_ci_gate_needs_jobs_have_no_event_conditional_if` (M1 hardening) — asserts no job in `ci-gate.needs` carries a job-level `if:` that references `github.event_name`; pins the unconditional-execution invariant; closes the EC-002 drift vector. **[DEAD SYMBOL + NARROWED PREDICATE — corrected 2026-08-07, S-CIGATE-1 sweep]:** this function no longer exists under this name. Renamed to `test_ci_gate_needs_jobs_have_no_job_level_if` (ADV-P48-LOW-001, round 20), and its predicate was broadened by round-19 fix F-03 from "no job-level `if:` referencing `github.event_name`" to "no job-level `if:` key at all" (any condition — a folded/block scalar or a non-event condition like `github.ref == …` is equally hazardous, since either produces a `skipped` result). It also no longer checks all of `ci-gate.needs`; `mutants` is deliberately excluded from its per-job check list (it legitimately carries a job-level `if:` and is instead pinned present via `test_mutants_is_in_ci_gate_needs`).
6. `test_ci_gate_pass_fail_semantics_are_structurally_placed` (M2 hardening) — asserts `always()` is the job-level `if:` and does NOT contain `contains(needs`; `contains(needs.*.result,'failure'/'cancelled')` is on a step-level `if:`; and a `run:` step exists; prevents always()/contains() transposition reopening the skipped-job trap. **[INVERTED — corrected 2026-08-07, S-CIGATE-1 sweep]:** the middle claim is the opposite of the shipped test's M2-d assertion. Since `S-CIGATE-2`, the test asserts there is NO step-level `if:` in the `ci-gate` block at all (`!has_step_level_if`) — the failure/cancelled decision no longer lives in a step-level `if:` anywhere; it lives inside `scripts/check-ci-gate.sh`, invoked unconditionally by a bare `run:` step.

Test naming follows the project convention `test_<verb>_<subject>_<expected_outcome>`.

Rationale: this test is the only automated safeguard that catches "new required CI job added but not wired into `ci-gate.needs`." Without it, the next S-WIN-style matrix expansion could re-introduce the same fragility class.

Pinned by: `cargo test --test ci_gate_completeness` exits 0.

---

### AC-005 — Documentation: CLAUDE.md bullet + ADR-0016 Decision 3 informational note
(traces to WIN-CI-GATE-AGGREGATOR — convention codified so future contributors do not bypass the aggregator)

> **Scope note:** These documentation edits were classified as "optional" in the F1 delta analysis but are promoted to required ACs here for traceability — they are the codified convention that prevents the DEC-096/DEC-097 fragility class from recurring. A future contributor who skips them cannot know the `ci-gate` convention exists.

(a) `CLAUDE.md` contains a bullet (under "Key Decisions" or "Conventions") stating that `ci-gate` is the single required branch-protection status check and that new CI jobs requiring blocking must be added to `ci-gate.needs`, never to branch protection directly.

(b) `docs/adr/0016-windows-build-target.md` Decision 3 (Add Windows job to `ci.yml`) contains a one-line informational note with equivalent content.

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

- **`security` and `mutants` joining `ci-gate.needs`**: these are PR-only jobs. If they are ever promoted to required, that is a separate story — keep this one minimal. **[CORRECTION — 2026-08-06, S-CIGATE-4]:** for `mutants`, this already happened — `S-MUTATION-CI-TIMEOUT-1` (PR #567) promoted it into `ci-gate.needs`, and `S-CIGATE-2` (PR #671, in-flight) builds its fail-closed fix around `mutants` remaining there. `security` remains out of `ci-gate.needs` and this bullet is accurate for it. See the AC-003 correction above for full detail.
- **`coverage` joining `ci-gate.needs`**: advisory by design (`fail_ci_if_error: false`).
- **Any change to the existing `fmt`, `clippy`, `test`, `msrv`, `deny`, `spec-guard` job definitions**: this story only adds the aggregator job. **[STALE ENUMERATION — corrected 2026-08-07, S-CIGATE-1 sweep]:** this bullet's job list reflects `ci-gate.needs` membership at authoring time (2026-06-15) only, not the current eight-member set. It should not be read as implying the current `needs` list is exhaustively these six — `check-signing-workflow-injection` and `mutants` were added since (see AC-003's correction). The bullet's substantive point — this story does not modify any pre-existing job's own definition — still holds unchanged.
- **Removing old required_status_check contexts** before `ci-gate` is confirmed green on develop.

---

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `ci-gate` job | `.github/workflows/ci.yml` | N/A (CI config) | Aggregates upstream job results; reports single stable context to branch protection |
| `tests/ci_gate_completeness.rs` | `tests/` | Pure (source-text grep) **[PARTIALLY STALE — corrected 2026-08-07, S-CIGATE-1 sweep: true for the tests this story authored; no longer true file-wide — see the Purity Classification correction below]** | Hermetic drift-prevention; reads YAML file, makes structural assertions |

---

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `.github/workflows/ci.yml` `ci-gate` job | effectful-shell (CI config, not Rust) | GitHub Actions YAML — declarative but not pure in the Rust-purity sense; drives real CI side effects (job scheduling, exit codes feeding branch protection) |
| `tests/ci_gate_completeness.rs` | pure-core, with a documented `#[cfg(unix)]` exception | Reads `ci.yml` as a string and asserts on its text content only; no network calls, no filesystem writes. **[STALE — corrected 2026-08-07, S-CIGATE-1 sweep]:** "no script execution … fully hermetic" no longer holds file-wide. Since `S-CIGATE-2` (PR #671), the helper `run_check_ci_gate_sh` (and its three `#[cfg(unix)]`-gated caller tests, e.g. `test_ci_gate_decision_matches_job_level_if_for_every_needs_member`) spawns `bash` as a subprocess via `std::process::Command::new("bash")` to exercise `scripts/check-ci-gate.sh` directly. This story's own six tests (AC-004) remain pure source-text-grep; the subprocess-spawning tests were added by `S-CIGATE-2`, out of this story's scope, in the same file. |

---

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-001 | F1 delta analysis §4 (Skipped-Job Trap) | Failed upstream without `if: always()` on `ci-gate` | `ci-gate` is SKIPPED (not failed); GitHub evaluates skip as success → unprotected merge. Mitigation: `if: ${{ always() }}` is REQUIRED at job level. |
| EC-002 | F1 delta analysis §4 | Future CI job added to `needs` that has `if: github.event_name == 'pull_request'` | That job emits `skipped` on push → `ci-gate` would pass on push even when that job is broken. Mitigation: `test_ci_gate_needs_jobs_have_no_event_conditional_if` (M1) asserts no job in `ci-gate.needs` carries a job-level `if:` referencing `github.event_name`; this test fails when a PR-only job is mistakenly added to `needs`; doc (AC-005) warns contributors. **[DEAD SYMBOL + NARROWED PREDICATE — corrected 2026-08-07, S-CIGATE-1 sweep]:** renamed to `test_ci_gate_needs_jobs_have_no_job_level_if` (ADV-P48-LOW-001, round 20); predicate broadened (round 19, F-03) to "no job-level `if:` key at all," not merely one referencing `github.event_name` — see AC-004 item 5's correction for detail. This mitigation's substance is also now secondary defense-in-depth: since `S-CIGATE-2`, `scripts/check-ci-gate.sh`'s fail-closed evaluator already rejects an unlisted job's `skipped` result at gate-decision time, so this test's real job is catching the drift at review time, before it surprises a maintainer as a newly-red gate. |
| EC-003 | F1 delta analysis §5 | `name: CI Gate` omitted from job definition | Branch-protection context becomes `ci-gate` (kebab) instead of `CI Gate` (human-readable). The PATCH payload in AC-006 must match exactly. Mitigation: `name: CI Gate` is specified in AC-001. |
| EC-004 | DEC-097 precedent | Old required contexts removed before `ci-gate` is green | No gating check; unprotected merges. Mitigation: AC-006 ordering constraint (add first, verify, then swap). |
| EC-005 | AC-004 test design | `ci_gate_completeness.rs` exact-set check fails after a legitimate CI job is added to `needs` | Expected outcome — the test fails intentionally, prompting the author to (a) confirm the new job has no PR-only `if:` guard and (b) update the expected set in the test. |

---

## Test Coverage Summary

| # | Test name | File | AC |
|---|-----------|------|-----|
| 1 | `test_ci_gate_job_exists_with_required_metadata` (formerly `test_ci_gate_job_exists_with_correct_shell` through PR #518; renamed S-626-1 round 19, commit `e076e96b`) | `tests/ci_gate_completeness.rs` | AC-001, AC-002 (`always()` presence) |
| 2 | `test_ci_gate_fails_on_failed_or_cancelled_need` | `tests/ci_gate_completeness.rs` | AC-002 |
| 3 | `test_ci_gate_needs_exactly_the_required_jobs` | `tests/ci_gate_completeness.rs` | AC-003 (exact-set) |
| 4 | `test_ci_gate_excludes_advisory_and_secret_scan_jobs` (renamed from `test_ci_gate_excludes_pr_only_jobs` by PR #567, S-MUTATION-CI-TIMEOUT-1) | `tests/ci_gate_completeness.rs` | AC-003 (exclusion of `security`/`coverage`; `mutants` exclusion superseded — see CORRECTION) |
| 5 | `test_ci_gate_needs_jobs_have_no_event_conditional_if` **[DEAD SYMBOL — corrected 2026-08-07, S-CIGATE-1 sweep: renamed `test_ci_gate_needs_jobs_have_no_job_level_if` (ADV-P48-LOW-001, round 20); predicate broadened (F-03) from "no `github.event_name`-referencing job-level `if:`" to "no job-level `if:` key at all" — see AC-004 item 5's correction]** | `tests/ci_gate_completeness.rs` | AC-003 / EC-002 hardening (M1) — asserts no job in `ci-gate.needs` carries a job-level `if:` referencing `github.event_name`; pins the unconditional-execution invariant |
| 6 | `test_ci_gate_pass_fail_semantics_are_structurally_placed` | `tests/ci_gate_completeness.rs` | AC-002 hardening (M2) — asserts `always()` is on the job-level `if:` and does NOT contain `contains(needs`; `contains(needs.*.result,'failure'/'cancelled')` is on a step-level `if:`; a `run:` step exists; prevents always()/contains() transposition reopening the skipped-job trap. **[INVERTED — corrected 2026-08-07, S-CIGATE-1 sweep]:** the shipped M2-d assertion is the opposite — it asserts NO step-level `if:` exists in the `ci-gate` block at all; the failure/cancelled decision moved inside `scripts/check-ci-gate.sh`, invoked unconditionally. See AC-004 item 6's correction. |

AC-004 is covered by the six tests above (they ARE the hermetic test AC-004 requires — see the STALE COUNT note at the top of AC-004 for how these six relate to the file's current 22-test total).
AC-005 and AC-006 are verified by source-text inspection and human action respectively — no automated test.

---

## Dependency Analysis

**depends_on: []** — No story dependencies. This is a standalone CI-infra story.

**blocks: []** — No story depends on this.

Topological order: standalone (Wave 1 in any wave-scheduling pass that honors the empty `depends_on`).

---

## Tasks

1. Read `.github/workflows/ci.yml` to understand the current job list and structure.
2. **[RETIRED SHAPE, REPLACED — corrected 2026-08-07, S-CIGATE-1 sweep. Discovery flagged the copy-pasteable YAML block below as the single most actionable reintroduction hazard in this file: an implementer following it verbatim today would ship the exact retired mechanism `S-CIGATE-2` (PR #671) removed. The block is struck through and kept only as the authoring-time (2026-06-15) historical record — do NOT copy it. The shipped shape at head `3ad496eb` follows immediately after.]**

   ~~Append the `ci-gate` job at the end of `ci.yml`:~~
   ```yaml
   # HISTORICAL — DO NOT USE. Retired since S-CIGATE-2 (PR #671).
   # ci-gate:
   #   name: CI Gate
   #   runs-on: ubuntu-latest
   #   needs: [fmt, clippy, test, msrv, deny, spec-guard]
   #   if: ${{ always() }}
   #   steps:
   #     - name: Fail if any required job failed or was cancelled
   #       if: >-
   #         ${{ contains(needs.*.result, 'failure') ||
   #             contains(needs.*.result, 'cancelled') }}
   #       run: exit 1
   ```

   **Current shipped shape** (`.github/workflows/ci.yml :: ci-gate`, verified at head `3ad496eb`):
   ```yaml
   ci-gate:
     name: CI Gate
     runs-on: ubuntu-latest
     timeout-minutes: 5
     needs: [fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants]
     if: ${{ always() }}
     steps:
       - name: Evaluate required job results (S-CIGATE-2, fail-closed)
         env:
           NEEDS_JSON: ${{ toJSON(needs) }}
         run: echo "${NEEDS_JSON}" | bash scripts/check-ci-gate.sh
   ```
   The `contains(needs.*.result, …)` decision moved out of `ci.yml` entirely and into `scripts/check-ci-gate.sh::evaluate_needs` — a fail-closed evaluator where `success` passes, `skipped` passes only for jobs named in its `ALLOWED_SKIPS` allowlist (`mutants` alone today), and every other result fails via a default arm. There is no step-level `if:` on `ci-gate` — the `run:` step is unconditional and its own exit code is the signal. Full detail: `S-CIGATE-2-skipped-status-false-green.md`.
3. Create `tests/ci_gate_completeness.rs` with the six test functions enumerated in AC-004 (this story's own scope — the shipped file has since grown to 22 tests total across later, unrelated stories; see AC-004's STALE COUNT note). Reference `tests/ci_yml_windows_matrix.rs` as the pattern for YAML source-text parsing in this repo.
4. Add the `ci-gate` convention bullet to `CLAUDE.md`.
5. Add the one-line informational note to `docs/adr/0016-windows-build-target.md` Decision 3 (Add Windows job to `ci.yml`).
6. Run `cargo test --test ci_gate_completeness` — this story's six AC-004 tests pass (**[STALE COUNT — corrected 2026-08-07, S-CIGATE-1 sweep]:** the full file now contains 22 `#[test]` functions at head `3ad496eb`; all of them must pass, not just the six this story added — the other 16 belong to later, unrelated stories sharing the same file).
7. Run `cargo test` — full suite green (no regression).
8. Run `cargo clippy -- -D warnings` — zero warnings.

## Story Points and Effort

**3 story points** (xsmall). Breakdown:
- F4 TDD (`ci.yml` addition + `tests/ci_gate_completeness.rs` + CLAUDE.md + `docs/adr/0016-windows-build-target.md`): 2 SP
- F5/F7 review + CI gate verification (confirm `ci-gate` job green on PR): 1 SP

The implementation is ~20 lines of YAML + ~30 lines of test + ~5 lines of documentation.
No Rust src/ changes. No product behavior changes. Risk: LOW (see F1 analysis §6).

**[ESTIMATE DRIFT NOTE — added 2026-08-07, S-CIGATE-1 sweep]:** the line-count figures above are the original authoring-time (2026-06-15) sizing for THIS story's own delivery and are left unchanged as an estimate, not corrected — this story's actual delivered diff was in that range. They are not a claim about the current file sizes: `.github/workflows/ci.yml` (675 LOC) and `tests/ci_gate_completeness.rs` (5,214 LOC) grew far beyond these figures through later, unrelated stories (`S-FORK-OPS-SIGN-1`, `S-MUTATION-CI-TIMEOUT-1`, `S-CIGATE-2`, CI-hygiene hardening rounds) — see the Token Budget table's correction note above for the same distinction.
