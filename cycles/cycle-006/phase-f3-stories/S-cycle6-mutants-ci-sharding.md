---
document_type: story
level: ops
story_id: "S-cycle6-mutants-ci-sharding"
epic_id: "MUTANTS-CI-SHARDING-1"
title: "Sharded mutation-testing CI gate — mutants-plan / 8-shard mutants matrix / mutants-aggregate, escape hatch, nightly full run, and the runtime+structural guardrail lockstep"
wave: 1
status: draft
intent: enhancement
feature_type: infrastructure
mode: feature
scope: standard
severity: CRITICAL
trivial_scope: false
producer: story-writer
timestamp: "2026-09-07T00:00:00"
phase: 3
inputs:
  - ".factory/phase-f2-spec-evolution/cycle-006/architecture-delta.md"
  - ".factory/phase-f2-spec-evolution/cycle-006/mutants-sharding-invariants.md"
  - ".factory/phase-f2-spec-evolution/cycle-006/ci-yml-design.md"
  - ".factory/phase-f2-spec-evolution/cycle-006/verification-delta.md"
  - ".factory/phase-f1-delta-analysis/cycle-006/delta-analysis.md"
  - ".factory/phase-f1-delta-analysis/cycle-006/affected-files.txt"
  - "docs/specs/cargo-mutants-policy.md"
  - "scripts/check-ci-gate.sh"
  - "tests/ci_gate_completeness.rs"
input-hash: "bdf438d"
traces_to: ".factory/phase-f2-spec-evolution/cycle-006/architecture-delta.md"
cycle: cycle-006-mutants-ci-sharding
estimated_effort: large
estimated_days: 5
target_module: ".github/workflows/ci.yml; scripts/mutants-aggregate.sh; scripts/lib/trusted-jq.sh; .github/workflows/mutants-nightly.yml"
subsystems: ["SS-09"]
depends_on: []
blocks: []
behavioral_contracts: []
bcs: []
# BC status: N/A by design — DEC-348 governance is policy-doc-only
# (docs/specs/cargo-mutants-policy.md), NO new PRD BC. See "Governance
# Deviation Note" below for the explicit justification this constitutes
# a documented, approved exception to the story-writer's normal
# BC-traceability contract, not an omission.
verification_properties:
  - "VP-MUTANTS-SHARD-001"
  - "VP-MUTANTS-SHARD-002"
  - "VP-MUTANTS-SHARD-003"
  - "VP-MUTANTS-SHARD-004"
  - "VP-MUTANTS-SHARD-005"
  - "VP-MUTANTS-SHARD-006"
  - "VP-MUTANTS-SHARD-007"
  - "VP-MUTANTS-SHARD-008"
  - "VP-MUTANTS-SHARD-009"
  - "VP-MUTANTS-SHARD-010"
  - "VP-MUTANTS-SHARD-011"
  - "VP-MUTANTS-SHARD-012"
  - "VP-MUTANTS-SHARD-013"
  - "VP-MUTANTS-SHARD-014"
  - "VP-MUTANTS-SHARD-015"
  - "VP-MUTANTS-SHARD-016"
  - "VP-MUTANTS-SHARD-017"
  - "VP-MUTANTS-SHARD-018"
  - "VP-MUTANTS-SHARD-019"
  - "VP-MUTANTS-SHARD-020"
  - "VP-MUTANTS-SHARD-021"
  - "VP-MUTANTS-SHARD-022"
  - "VP-MUTANTS-SHARD-023"
  - "VP-MUTANTS-SHARD-024"
  - "VP-MUTANTS-SHARD-025"
  - "VP-MUTANTS-SHARD-026"
  - "VP-MUTANTS-SHARD-027"
  - "VP-MUTANTS-SHARD-028"
  - "VP-MUTANTS-SHARD-029"
  - "VP-MUTANTS-SHARD-030"
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
priority: P0
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-006/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: strict
module_criticality: CRITICAL
points: 13
acceptance_criteria_count: 39
assumption_validations: []
risk_mitigations: []
created: "2026-09-07"
version: "1.0"
last_updated: "2026-09-07"
breaking_change: false
retroactive: false
origin: >
  cycle-006 mutants-ci-sharding, Wave 1 of 1, no deps within this cycle.
  Replaces the single required `mutants` CI job (timeout-minutes 240,
  `cargo mutants --in-diff <diff> --jobs 4 --timeout 240`, the sole
  pass/fail arbiter for mutation testing on every PR) with a three-job
  pipeline (`mutants-plan` -> 8-shard `mutants` matrix -> `mutants-
  aggregate`) plus an advisory nightly full-scope workflow, because the
  single-job design was hitting the 240-minute wall-clock ceiling on
  large diffs and blocking PR #778 (281 mutants) from merging. This
  pipeline does NOT make PR #778's 281-mutant diff "pass mutation
  testing within budget" as-is: by the design's own arithmetic (8 shards
  x ~15 mutants ~= 120, `ESCALATION_THRESHOLD=120`), a diff that size
  still ESCALATES (AC-003) — the shard matrix is skipped entirely and
  `mutants-aggregate` exits 1 as an ordinary CI `failure`. What the new
  pipeline actually unblocks is two-fold: (a) any PR with <=120 in-diff
  mutants now shard-runs to completion within CI's wall-clock budget
  instead of hitting the old single-job wall, and (b) a PR that exceeds
  that threshold — including PR #778's 281 mutants, as-is — is routed
  through an auditable escape hatch to an ordinary, actionable CI
  `failure`, resolved either by a repo-admin branch-protection bypass
  with an explicit PR-description acknowledgment, or by splitting the
  diff below the 120-mutant threshold. F2 (`architecture-delta.md`/
  `mutants-sharding-invariants.md`/`ci-yml-design.md`/`verification-
  delta.md`) reached 16-pass adversarial convergence (9 fix rounds, 3
  consecutive clean passes) and was human-APPROVED as-is at the F2 gate
  (DEC-349, 2026-09-07). Governance is policy-doc-only per DEC-348 — no
  PRD BC exists for this cycle, mirroring the MUTATION-CI-TIMEOUT
  precedent (2026-06-28).
---

> **tdd_mode:** `strict` — full TDD Iron Law enforced. This is CI-gate
> decision-path machinery: the single most heavily adversarially-reviewed
> surface in this codebase (20+ documented `ci-gate` hardening rounds in
> CLAUDE.md; 16 F2 passes on THIS delta alone). Not a facade/DTU candidate
> — every guard test is a genuine RED-before-GREEN behavioral proof against
> either a real subprocess (`scripts/mutants-aggregate.sh`,
> `scripts/check-ci-gate.sh`) or `ci.yml`'s parsed YAML tree, never a
> Rust-side re-implementation of the shipped logic.

> **Execute:** `/vsdd-factory:deliver-story S-cycle6-mutants-ci-sharding`

# S-cycle6-mutants-ci-sharding — Sharded mutation-testing CI gate

## Governance Deviation Note (read before ACs)

This story's `behavioral_contracts:`/`bcs:` frontmatter is intentionally
`[]`. Per DEC-348 (F1, human-approved) and DEC-349 (F2 gate, human-approved
as-is), this cycle's governance is **policy-doc-only**: the spec of record
is `docs/specs/cargo-mutants-policy.md`, not a new PRD BC family, mirroring
the established `MUTATION-CI-TIMEOUT` (2026-06-28) precedent for the exact
same reason — this is CI/CD infrastructure with no product-facing
behavioral contract to anchor (no `src/` product code changes; see
`architecture-delta.md`'s own `purity_boundary: N/A` framing). Every
acceptance criterion below therefore traces to a **named invariant**
(`INV-AGG` / `INV-COMPLETE` / `INV-ESCALATE`, `mutants-sharding-
invariants.md`) and a **verification property**
(`VP-MUTANTS-SHARD-001..030`, `verification-delta.md`) instead of a BC
clause. This is the documented, human-approved exception to the
story-writer's normal AC-to-BC bidirectional-trace gate (S-7.01) — the
Spec-First Gate does not apply here because no BC exists to gate against;
the equivalent gate for this story is "every AC cites a VP, and every VP
in the frontmatter `verification_properties:` array is cited by at least
one AC," which the AC list below satisfies 1:1 for all 30 VPs plus nine
non-VP-numbered structural/process ACs (031-035, 036-039) covering the
fixed-denominator counters, the `ci-gate.needs` retarget, the shard
invocation shape, the nightly workflow's isolation, F4 Blocking
Precondition 3's empirical verification gate, INV-COMPLETE Part C's two
sharding-INTRODUCED arms (the `has_outcomes`-wins FOLD rule and the
sentinel/data-desync fail-closed check), Step 0.5's `PLAN_RESULT`
diagnostic short-circuit (AC-038), and Step 5's base-ref-drift FAIL/OK
decision (AC-039) — none of the four (036-039) has a dedicated VP number
in F2's VP-ID allocation, per the same "no VP assigned at F2" rationale
as 031-035. See the "Aggregator Step -> AC/Task Coverage Audit" table
below the Acceptance Criteria section for the complete, per-step
accounting that produced this final AC set, and the "AC -> Task Coverage
Audit" table immediately after it (added Phase F3 round 7) for the
complete, per-AC accounting across all 39 ACs confirming every one maps
to a write-test task and an implement task (or an explicit process-gate/
structural-pin disposition).

**Holdout traceability (`holdout_anchors: []` is intentional, not an
omission):** this story's frontmatter carries an empty `holdout_anchors:`
array because this is a CI-infrastructure cycle, not a product feature —
there is no user-facing behavior for a blind holdout-evaluator to exercise
against a running product, so the product-feature blind-holdout-evaluator
pattern (an isolated evaluator agent probing a live app/API against hidden
acceptance scenarios) does not apply here. In its place, this story is
covered by 12 wave-level holdout scenarios in
`.factory/cycles/cycle-006/phase-f3-stories/wave-holdout-scenarios.md` —
6 cross-cutting integration scenarios (H-W1-INT-001..006) and 6 regression
scenarios (H-W1-REG-001..006) — run by the implementer/formal-verifier as
subprocess-driven proofs against the real `ci.yml`/gate scripts rather than
by a blind evaluator. See that file for the full scenario definitions and
MUST-PASS/SHOULD-PASS dispositions.

## Why This Is ONE Atomic Story

This is a single, indivisible CI/infra change. `mutants-plan` + the
8-shard `mutants` matrix + `mutants-aggregate` + `scripts/mutants-
aggregate.sh` + `scripts/lib/trusted-jq.sh` + the 27 new guard tests in
`tests/ci_gate_completeness.rs` + `mutants-nightly.yml` + the
`docs/specs/cargo-mutants-policy.md` update **must land together in ONE
PR** for gate consistency:

- The matrix cannot land without the aggregator (nothing would consume
  the shard artifacts and `ci-gate` would have no mutation-testing
  member at all).
- The aggregator cannot land without the 27 guard tests (an unguarded
  aggregator reintroduces every false-green class 16 F2 adversarial
  passes found and closed — CRIT-1 all-shards-crash, F-H1 evidence-
  directory redirect, the circular `MUTANT_COUNT` self-satisfaction, the
  `jq`-shim vector, etc.).
- The guard tests cannot land without the extracted `scripts/mutants-
  aggregate.sh` (every INV-AGG/INV-COMPLETE test is a `#[cfg(unix)]`
  subprocess proof against the real script — F2's own Extraction
  Precondition, `architecture-delta.md §1`, is BLOCKING for exactly this
  reason: a test suite proving Rust-side re-implemented logic instead of
  shipped logic is not a real proof).
- `ci-gate.needs` cannot retarget from `mutants` to `mutants-aggregate`
  without ALL of the above already existing, or the required check
  points at a job that doesn't produce a meaningful decision yet.

A partial split was considered (e.g., "land the scripts first, wire the
workflow second") and rejected: a partially-landed state either leaves
`ci-gate` pointed at the OLD single `mutants` job (no benefit realized,
wasted PR) or points at a `mutants-aggregate` job whose guard tests don't
yet exist (exactly the "guardrails must move in lockstep or the gate
breaks" risk `delta-analysis.md`'s own Risk #3 names). This mirrors the
`MUTATION-CI-TIMEOUT` precedent's own single-PR delivery shape. **One
story, one PR, all-or-nothing.**

A narrower, more surgical split was also considered and rejected: landing
`scripts/lib/trusted-jq.sh` (the extraction of `resolve_trusted_jq`/
`is_trusted_jq_dir`/`trusted_jq_dirs_for` out of `check-ci-gate.sh`) plus
`check-ci-gate.sh`'s refactor to source it, as a standalone, pure-refactor
prep PR ahead of this story. Rejected for the same reason as the broader
split, one level down: the shared lib's SECOND consumer,
`scripts/mutants-aggregate.sh` (AC-024), does not exist until this story
lands, so a prep PR delivers zero functional change on its own and adds
pure cycle/review overhead for no benefit realized — there is nothing
for the extraction to *do* until the second caller exists. This option
IS, however, provably behavior-identical in isolation — H-W1-REG-003
(`check-ci-gate.sh --self-test`'s pre-existing 14 fixtures still pass
post-refactor) and the unchanged `EXPECTED_JQ_TRUST_CHECKS=17` both
confirm the extraction alone changes no observable behavior of
`check-ci-gate.sh` — so it is a defensible, OPTIONAL de-risking split the
implementer MAY choose to land as an earlier commit (or even an earlier
small PR) purely to isolate review of the mechanical extraction from
review of the new aggregation logic, at their discretion. It is not the
recommended default: this story's Tasks list (Task 2) still treats the
extraction as step one of ONE PR, not a prerequisite PR, and the
implementer should not feel obligated to split it out.

## Source of Truth

- `.factory/phase-f2-spec-evolution/cycle-006/architecture-delta.md`
  (full — topology §1-2, data flow §3, `ci-gate.needs` retarget §4,
  escape hatch/nightly §5, the complete Guardrail Lockstep Plan §6
  including §6.2/§6.2a/§6.4/§6.8/§6.11, dependency graph §7, version pin
  §8).
- `.factory/phase-f2-spec-evolution/cycle-006/mutants-sharding-
  invariants.md` (full — INV-AGG, INV-COMPLETE, INV-ESCALATE statements
  and their sub-invariants, all nine rounds of adversarial refinement).
- `.factory/phase-f2-spec-evolution/cycle-006/ci-yml-design.md` (full —
  the sharded topology pseudo-YAML, the aggregator script structure, the
  `mutants-nightly.yml` design).
- `.factory/phase-f2-spec-evolution/cycle-006/verification-delta.md`
  (full — VP-MUTANTS-SHARD-001..030, the coverage matrix §4, the RED-proof
  confirmation §5, the §5A documented residual).
- `docs/specs/cargo-mutants-policy.md` (existing, to be updated in place
  per F4 Blocking Precondition 5 — sections: Scope, CI Gate: Required
  Check, Local Invocation, CI Integration, Future Path: Job Sharding
  (Path B), Changelog).
- `scripts/check-ci-gate.sh` (existing, to be refactored to source the
  new shared `scripts/lib/trusted-jq.sh`).
- `tests/ci_gate_completeness.rs` (existing, `EXPECTED_GUARD_TEST_COUNT`
  currently `38`, to grow to `65`).
- `.factory/phase-f1-delta-analysis/cycle-006/{delta-analysis.md,
  affected-files.txt}` (F1 scope/sequencing/regression-risk grounding).
- Decisions Log: DEC-348 (F1 approval), DEC-349 (F2 gate approval, full
  design + spec surface + 5 F4 blocking preconditions accepted as-is).

## Narrative

As a `jr` maintainer, I want the mutation-testing CI gate to run as an
8-shard parallel matrix instead of a single 240-minute job, with a
pooled, sum-not-average kill-rate decision that fails closed on any
missing/crashed/redirected shard evidence, an escape hatch for
oversized diffs that never silently skips verification, and every
runtime and structural protection `ci-gate` itself already carries
mirrored onto the new `mutants-aggregate` job, so that (a) any PR with
<=120 in-diff mutants shard-runs to completion within CI's wall-clock
budget instead of hitting the old single-job 240-minute wall, and (b) a
PR that exceeds that threshold — including PR #778's 281 mutants, as-is
— is routed through an auditable escape hatch to an ordinary, actionable
CI `failure` (resolved by a repo-admin branch-protection bypass with an
explicit PR-description acknowledgment, or by splitting the diff below
120 mutants) rather than silently hanging or timing out, all without
weakening the gate's fail-closed guarantees that 20+ prior adversarial
rounds already hardened into `ci-gate`. PR #778 itself does not "pass
within budget" unmodified — see the `origin:` frontmatter above for the
exact mechanism.

## Behavioral Contracts

**N/A by design — see "Governance Deviation Note" above.** No PRD BC
exists or is created for this cycle (DEC-348/DEC-349, policy-doc-only
governance). The table below lists the **named invariants** this story
implements in place of BCs, each with its Statement source and the VPs
that verify it — this table is the BC-array-propagation-policy analog
for this story's actual traceability unit (invariant, not BC).

| Invariant | Status | What this story delivers | VPs |
|---|---|---|---|
| INV-AGG | NEW | Pooled sum-not-average kill-rate contract (8 sub-invariants incl. the exact-equality `MUTANT_COUNT` reconciliation hard fail) | VP-001, VP-008, VP-022, VP-023 |
| INV-COMPLETE | NEW | Sentinel-based fail-closed shard-completeness accounting (Parts A/B/C) | VP-002, VP-006, VP-007 |
| INV-ESCALATE | NEW | >120-mutant escape hatch encoded as an ordinary CI `failure`, never `skipped`/`success` | VP-003 |
| (structural/runtime peer-parity, no dedicated invariant name — §6.8/§6.11) | NEW | `mutants-aggregate` inherits every anti-neutering/anti-redirect protection `ci-gate`'s own decision step carries | VP-004, VP-005, VP-009 through VP-021, VP-024 through VP-030 |

## Acceptance Criteria

Every AC below is a **behavioral assertion**, numbered, traced to a named
invariant clause and a VP — the AC-to-VP analog of this story-writer's
normal AC-to-BC trace requirement (Governance Deviation Note above).

### AC-001 — Pooled sum-not-average kill-rate contract
`mutants-aggregate` computes exactly ONE pooled kill rate from the SUM of
`caught`/`missed`/`timeout`/`unviable` across all 8 shards' `outcomes.json`
files — it never computes or averages a per-shard percentage. Integer
division, multiply-first (`(caught_total * 100) / killable`). The gate
passes iff `killable == 0` OR `kill_rate >= 90`.
(traces to INV-AGG statement + sub-invariants 1-2, 7; VP-MUTANTS-SHARD-001)

### AC-002 — Missing/duplicate shard sentinel fails closed
`mutants-aggregate` asserts the exact expected sentinel set
(`mutants-shard-status-0` through `-7`) is present before folding any
shard's data. A missing sentinel OR a duplicate sentinel artifact fails
the whole aggregation closed — never silently treated as "0 mutants for
that shard."
(traces to INV-COMPLETE Part B; VP-MUTANTS-SHARD-002)

### AC-003 — Escalation is an ordinary failure, never a silent skip
When `mutants-plan`'s pre-count exceeds the ~120-mutant threshold, the
shard matrix is skipped entirely, and `mutants-aggregate` (running
`if: always()`) detects `ESCALATED == 'true'` at Step 1 — reached after
Step -1's trusted-`jq` resolution, Step 0's fail-closed event-allowlist
guard (AC-014), and Step 0.5's `PLAN_RESULT` diagnostic short-circuit
(AC-038), but BEFORE any shard-artifact or sentinel inspection (Step 2
onward) — and exits 1 with an actionable message naming both remediation
paths (split the PR; or a repo-admin branch-protection bypass with an
explicit PR-description acknowledgment) — never `skipped`, never
`success`.
(traces to INV-ESCALATE statement; VP-MUTANTS-SHARD-003)

### AC-004 — `mutants-plan` job structural pin
`mutants-plan` is `if: github.event_name == 'pull_request'` only,
computes `DIFF_FILE` exactly once (`git diff origin/<base_ref>...HEAD`,
`|| true` empty-diff-safe), uploads it as artifact `mutants-diff-file`,
and sets outputs `escalated`/`mutant_count`/`overall_diff_lines`.
(traces to architect §6.2 test 4; VP-MUTANTS-SHARD-004 — the
`ci-gate`-excluded half of VP-004's subject is covered by AC-032's
`PINNED_GATE_EXCLUDED_JOBS` admission of `mutants`/`mutants-plan`; see
AC-032 for the 1:1 trace)

### AC-005 — `EXPECTED_SHARDS` cross-check
A pinned `EXPECTED_SHARDS` constant is cross-checked against the `mutants`
job's `strategy.matrix.shard` sequence, which has exactly 8 entries
(reuses the existing generic `job_level_nested_sequence_items` helper —
zero new `tests/common/wf.rs` code).
(traces to architect §6.2 test 5; VP-MUTANTS-SHARD-005)

### AC-006 — All-shards-crash fails closed (CRIT-1 regression guard)
If every one of the 8 shards crashes under `continue-on-error: true`,
`mutants-aggregate` FAILS the aggregation (never the old design's
false-green "0 artifacts -> pass" branch). The sentinel captures
`steps.run-mutants.outcome` — which survives `continue-on-error: true`
truthfully — never `.conclusion` (which `continue-on-error` forces to
`success`, silently reopening CRIT-1 if ever substituted).
(traces to INV-COMPLETE Part C, harness-crash arm; VP-MUTANTS-SHARD-006)

### AC-007 — Legitimately-empty shards PASS (HIGH-1 regression guard)
A small PR whose `--sharding slice` computation legitimately produces
zero mutants for one or more shards is distinguished, via the sentinel's
explicit fields, from a missing/crashed shard — the aggregation PASSES on
this shape, not fails.
(traces to INV-COMPLETE Part C, legit-empty arm; VP-MUTANTS-SHARD-007)

### AC-008 — Pooled-total <-> `MUTANT_COUNT` reconciliation: exact-equality hard fail
After per-shard folding, `mutants-aggregate` computes `total_scored =
caught_total + missed_total + timeout_total + unviable_total` and
compares it against `MUTANT_COUNT` (`mutants-plan`'s independent
`--list`-based pre-count). If `total_scored != MUTANT_COUNT` (either
direction), the aggregation emits a diagnostic naming both numbers and
returns 1 — it does NOT fall through to the kill-rate step. This is a
HARD FAIL, not a `::warning::` (round-5's restoration of round-1's
original design — the round-4 non-blocking downgrade is explicitly NOT
shipped).
(traces to INV-AGG sub-invariant 8; VP-MUTANTS-SHARD-008)

### AC-009 — `if:`-exception list is disjoint and tautological
`PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS` (containing exactly
`("mutants-aggregate", "always()")`) is asserted disjoint from
`SKIP_TOLERANT_NEEDS_MEMBERS`, from `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS`
keys, and from `check-ci-gate.sh --print-allowed-skips`'s reported set —
AND every pinned `if:` value in the list is the exact tautology
`always()`, never a compound expression that could smuggle a conditional
skip in under this exception category.
(traces to MED-1, §6.4; VP-MUTANTS-SHARD-009)

### AC-010 — `escalated` output is byte-wired to `ESCALATED` env
`mutants-plan`'s `outputs:` mapping declares `escalated:` bound to the
exact byte value `${{ steps.plan.outputs.escalated }}`, AND
`mutants-aggregate`'s eval step's `env:` mapping binds `ESCALATED:` to
the exact byte value `${{ needs.mutants-plan.outputs.escalated }}` — a
mistyped output/env name degrades gracefully to empty at the consumer,
so a structural byte-pin (not just runtime behavior) is required.
(traces to MED-2, §6.2; VP-MUTANTS-SHARD-010)

### AC-011 — Skip-tolerant surface is consistently EMPTY
`SKIP_TOLERANT_NEEDS_MEMBERS`, `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS`, and
`scripts/check-ci-gate.sh`'s `ALLOWED_SKIPS` array are all asserted
empty, consistently, across all three representations — because
`mutants-aggregate` (unlike the old `mutants` job) is designed to NEVER
report `skipped` to GitHub Actions; it always internally resolves to
success or failure.
(traces to round-2 HIGH-1 a+b; VP-MUTANTS-SHARD-011)

### AC-012 — `print_allowed_skips` on empty `ALLOWED_SKIPS` emits zero lines
With `ALLOWED_SKIPS=()` (the true production state), `print_allowed_skips`
emits exactly zero lines — never a phantom blank line from an unguarded
empty-array expansion — verified with NO local override, exercising the
genuine production shape end-to-end.
(traces to round-2 MEDIUM-1; VP-MUTANTS-SHARD-012)

### AC-013 — `OVERALL_DIFF_LINES` malformed-but-set value fails closed
A malformed (non-`^[0-9]+$`) but non-empty `OVERALL_DIFF_LINES` value is
regex-guarded and fails closed — symmetric with `MUTANT_COUNT`'s Step-4
guard, applied to the Step-5 base-ref-drift check.
(traces to round-2 LOW, consumer-side wiring guard; VP-MUTANTS-SHARD-013)

### AC-014 — Step-0 fail-closed event guard (allowlist, not blacklist)
`mutants-aggregate.sh`'s Step 0 uses a fail-CLOSED allowlist `case`
statement: only `pull_request` falls through to real evaluation;
`push`/`schedule`/`workflow_dispatch` exit 0 (legitimate no-op); the
DEFAULT arm (including empty/unknown `EVENT_NAME`) FAILS (exit 1) — never
the old fail-open `[ "$EVENT_NAME" != "pull_request" ] -> exit 0` shape,
which resolves an empty/mistyped value to a silent, zero-shard-inspection
pass on a real PR.
(traces to round-3 HIGH-1; VP-MUTANTS-SHARD-014)

### AC-015 — `EVENT_NAME` env-wiring byte-pin
The eval step's `env:` mapping binds `EVENT_NAME:` to the exact byte
value `${{ github.event_name }}` — defense-in-depth on the wiring,
independent of and in addition to AC-014's runtime `case` fix.
(traces to round-3 HIGH-1 defense-in-depth; VP-MUTANTS-SHARD-015)

### AC-016 — `spec-guard` runs the aggregator's own `--self-test`
The `spec-guard` job contains a step, anchored by name, whose `run:`
line is byte-pinned to `bash scripts/mutants-aggregate.sh --self-test` —
without this, `EXPECTED_MUTANTS_AGG_FIXTURES` would be "a self-test suite
nobody runs."
(traces to round-3 extraction-wiring pin, §6.2a; VP-MUTANTS-SHARD-016)

### AC-017 — Decision-step `run:` line byte-pin
`mutants-aggregate`'s eval step's `run:` line is byte-pinned to
`bash scripts/mutants-aggregate.sh` — blocks `|| true`, `| cat`,
`; exit 0`, or any suffix that would silently disable the pass/fail
signal, mirroring `ci-gate`'s own M2-i protection.
(traces to §6.8 M2-i analog; VP-MUTANTS-SHARD-017)

### AC-018 — Decision-step `env:` complete key-set pin
The eval step's `env:` mapping's COMPLETE key set is pinned to exactly
7 keys (`ESCALATED`, `EVENT_NAME`, `MUTANT_COUNT`, `OVERALL_DIFF_LINES`,
`PLAN_RESULT`, `SHARD_DIR`, `STATUS_DIR`) — closes a `BASH_ENV:`-class
smuggled-env-child vector in one stroke, mirroring `ci-gate`'s M2-o.
(traces to §6.8 M2-o analog; VP-MUTANTS-SHARD-018)

### AC-019 — Decision-step invocation assertion
The eval step is confirmed to genuinely invoke
`scripts/mutants-aggregate.sh` (not a decoy substring elsewhere in the
job satisfying a bare presence check), mirroring `ci-gate`'s AC-001.
(traces to §6.8 AC-001 analog; VP-MUTANTS-SHARD-019)

### AC-020 — Job-block YAML node-property scan
`mutants-aggregate`'s entire job block is scanned for a mapping key
carrying a YAML anchor (`&x`) or tag (`!!str`) node property — the exact
node-property bypass class (round-16 `ci-gate` finding) that defeats
line-based/naive key-set extraction; the parser-based scan structurally
closes it for this job from day one.
(traces to §6.8 M2-q analog; VP-MUTANTS-SHARD-020)

### AC-021 — Every legitimate step-level `if:` is exactly `always()`
`mutants-aggregate`'s own three step-level `if: always()` occurrences
("Download all shard status sentinels", "Download all shard outcomes",
"Evaluate sharded mutation gate") are each individually asserted to
carry the plain-scalar value `always()`, iterated (not indexed at
`[0]`), never a compound expression. (The `mutants` shard job's own
three step-level `if: always()` occurrences — "Write shard status
sentinel", "Upload shard status sentinel", "Upload shard outcomes" —
are a separate, already-covered gap: Task 8's rewrite of
`test_mutants_shard_job_structure_matches_sharded_design`'s 3-count
`steps_with_if` cardinality inversion.)
(traces to §6.8, genuinely new gap no round-1/2/3 analog closed; VP-MUTANTS-SHARD-021)

### AC-022 — Reconciliation mismatch fails closed in the OVER-count direction too
A fixture where `total_scored > MUTANT_COUNT` (the shard matrix examined
MORE mutants than `mutants-plan` counted) also fails the aggregation
closed (exit 1, both numbers named) — proving the comparison is
genuinely `!=` in both directions, not an accidental `<`-only check that
would let an over-count silently mask as a pass.
(traces to INV-AGG sub-invariant 8, round-5 re-scoped, §6.10 item 19; VP-MUTANTS-SHARD-022)

### AC-023 — A healthy partial kill rate never rescues a dropped-mutant mismatch
A fixture with `MUTANT_COUNT=101`, pooled total `100`, and the 100 scored
mutants' own split constructed to yield a pooled kill rate `>= 90%`
(deliberately healthy-looking) still exits 1 with the reconciliation
message — and its stdout does NOT contain the Step-6 "gate passed"
success message. Completeness is required before quality of the scored
subset is even considered.
(traces to INV-AGG sub-invariant 8, round-5 inverted, §6.10 item 20; VP-MUTANTS-SHARD-023)

### AC-024 — Both gate scripts source the shared `trusted-jq.sh` helper
`scripts/check-ci-gate.sh` AND the new `scripts/mutants-aggregate.sh`
both `source` the new `scripts/lib/trusted-jq.sh` (extracted from
`check-ci-gate.sh`'s existing `resolve_trusted_jq`/`is_trusted_jq_dir`/
`trusted_jq_dirs_for`) — a future jq-trust fix cannot land in one
decision-path script and be forgotten in the other.
(traces to INV-AGG runtime-hardening parity, §6.11 item 21; VP-MUTANTS-SHARD-024)

### AC-025 — No bare, unresolved decision-path `jq` in either gate script
Neither `scripts/check-ci-gate.sh` nor `scripts/mutants-aggregate.sh`
calls `jq` bare anywhere on its decision path — every invocation resolves
through `resolve_trusted_jq`. This is the load-bearing half: it closes
the `$GITHUB_PATH`-prepended-jq-shim vector for `mutants-aggregate.sh`
identically to how S-626-1 pass-59 already closed it for `check-ci-gate.sh`.
(traces to INV-AGG runtime-hardening parity, §6.11 item 22; VP-MUTANTS-SHARD-025)

### AC-026 — `STATUS_DIR` env-wiring byte-VALUE pin
The eval step's `env:` mapping binds `STATUS_DIR:` to the exact byte
value `${{ runner.temp }}/shard-status` — closes the F-H1 false-green
(bash's `${VAR:?message}` guards only unset/empty, never a maliciously-
but-validly-SET redirect to an attacker-controlled directory; `STATUS_DIR`
locates the ENTIRE sentinel evidence set the decision reads).
(traces to §6.8 corrected M2-n analog, round-8 F-H1; VP-MUTANTS-SHARD-026)

### AC-027 — `SHARD_DIR` env-wiring byte-VALUE pin
Same mechanism and rationale as AC-026, applied to `SHARD_DIR`, pinned
to the exact byte value `${{ runner.temp }}/shards` — locates the ENTIRE
`outcomes.json` evidence set.
(traces to §6.8 corrected M2-n analog, round-8 F-H1; VP-MUTANTS-SHARD-027)

### AC-028 — `MUTANT_COUNT` env-wiring byte-VALUE pin
The eval step's `env:` mapping binds `MUTANT_COUNT:` to the exact byte
value `${{ needs.mutants-plan.outputs.mutant_count }}` — closes the
CIRCULAR reconciliation-disable: without this pin, a PR could hardcode
the env line to equal whatever the pooled shards will produce, making
AC-008's reconciliation pass trivially even though the runtime check
itself is unmodified.
(traces to §6.8 MIRRORED M2-n analog, round-9 LOW-1; VP-MUTANTS-SHARD-028)

### AC-029 — `OVERALL_DIFF_LINES` env-wiring byte-VALUE pin
The eval step's `env:` mapping binds `OVERALL_DIFF_LINES:` to the exact
byte value `${{ needs.mutants-plan.outputs.overall_diff_lines }}` —
retires the last declined env-value pin for this key.
(traces to §6.8 MIRRORED M2-n analog, round-9 LOW-1; VP-MUTANTS-SHARD-029)

### AC-030 — `PLAN_RESULT` env-wiring byte-VALUE pin
The eval step's `env:` mapping binds `PLAN_RESULT:` to the exact byte
value `${{ needs.mutants-plan.result }}` — retires the last declined
env-value pin, so ALL SEVEN eval-step env values now carry BOTH a
key-set pin (AC-018) AND an individual byte-VALUE pin.
(traces to §6.8 MIRRORED M2-n analog, round-9 LOW-1; VP-MUTANTS-SHARD-030)

### AC-031 — Fixed-denominator self-check counters land at their final values
`EXPECTED_GUARD_TEST_COUNT` (`tests/ci_gate_completeness.rs`) moves
`38 -> 65` (27 net new `#[test]` functions — the history-log doc-comment
gains entries for every round per this file's own convention). **This
figure, like `EXPECTED_MUTANTS_AGG_FIXTURES` below, must be RE-VERIFIED
by the implementer at F4 against the live tree, not copied blindly from
this document** — count the actual new/modified `#[test]` functions the
shipped Task-list work produces (Tasks 6-8, 10, 12, 14, 17-23 each add or
transform tests — **round 8 (F-L-003): range extended from 17-21 to
17-23 to include Task 22's AC-024/AC-025 tests and Task 23's AC-034
nightly-workflow test, previously omitted from this enumeration**) and
confirm the total genuinely lands at 65; the
Rust-side `test_this_file_test_count_matches_expected_denominator`
self-check (H-W1-REG-005) is the backstop that catches a miscount, not a
substitute for the implementer's own verification.
`EXPECTED_FIXTURES` (`scripts/check-ci-gate.sh --self-test`) moves
`13 -> 14` (new Fixture 14, `empty-allowed-skips-any-skip-fails-closed`).
**Same caveat: re-verify against the live `check-ci-gate.sh --self-test`
fixture list at F4** — the `--self-test` mode's own summary line
(`EXPECTED_FIXTURES`-pinned per Round 10's fixture-count-pin hardening,
CLAUDE.md's CI-Gate history) is the backstop, not a substitute for
confirming 14 is still correct after Task 21's Fixture 4/5/12/13
repurposing lands.
`EXPECTED_MUTANTS_AGG_FIXTURES` (`scripts/mutants-aggregate.sh
--self-test`, new sibling counter) is **>= 12**, computed MECHANICALLY
by the implementer at F4 by actually counting the fixtures the shipped
script requires (per the F2 LOW doc-fix item below — 12 is a provisional
floor from hand-derivation across 9 adversarial rounds, not a value to
copy blindly — and now covers AC-038's and AC-039's fixtures too, added
this pass, so the true F4 count may exceed 12 by more than the pre-round-5
estimate assumed). **Round 9 addition (F-P18-MED-001):** the F4 mechanical
recount MUST also include the three per-shard fatal/warning fixtures
named this pass in Task 10's "INV-AGG/INV-COMPLETE Sub-Invariant -> Named
RED Fixture" mini-table — the per-shard malformed-`outcomes.json` fixture
(sub-invariant 3), the per-shard H-1 schema-drift fixture (sub-invariant
5), and the per-shard `total_mutants` warning-only fixture (sub-invariant
6) — none of which previously had an explicitly-named fixture despite
each being a real IMPLEMENT obligation in Task 11 and (for the first two)
a FATAL fail-closed behavioral path; omitting them from the F4 count would
under-report the true fixture set the same way AC-038/AC-039's fixtures
would have been omitted before the prior round caught that gap.
`EXPECTED_JQ_TRUST_CHECKS` stays **17, unchanged** —
the shared `trusted-jq.sh` extraction reuses the existing jq-trust
self-test machinery rather than duplicating it.
(traces to architect §6.2/§6.2a "Numbers after this round" convention;
no single VP — this is the cross-cutting self-check-denominator
obligation every VP-00X test above ultimately registers against)

### AC-032 — `ci-gate.needs` retargets its LAST member only
`ci-gate`'s `needs:` array changes exactly one element: `mutants` ->
`mutants-aggregate`; every other member (`fmt`, `clippy`, `test`, `msrv`,
`deny`, `spec-guard`, `check-signing-workflow-injection`) and `ci-gate`'s
own `if: ${{ always() }}`/steps/`Evaluate required job results` step are
byte-identical, unchanged. `mutants` and `mutants-plan` are admitted via
`PINNED_GATE_EXCLUDED_JOBS`, never wired directly into branch protection
(DEC-096/DEC-097). `PINNED_GATE_NEEDS_LINE` and
`test_ci_gate_needs_exactly_the_required_jobs`'s expected-set literal are
both updated in the SAME commit.
(traces to architecture-delta §4; part of the guardrail lockstep, no
dedicated VP number — covered structurally by the existing `ci-gate`
guard-test family this story extends, not a new VP)

### AC-033 — Shard invocation shape and shared-artifact reuse
Each of the 8 `mutants` shard jobs runs
`cargo mutants --shard k/8 --sharding slice --jobs 2 --baseline skip
--timeout 240` against the SAME downloaded `mutants-diff-file` artifact
(one upload from `mutants-plan`, 8 downloads of identical bytes) using
the exact pin `cargo-mutants@27.1.0` (also on `mutants-plan`; NOT
installed on `mutants-aggregate`, which needs only `jq`/bash over
already-produced `outcomes.json` files).
(traces to architecture-delta §3/§8; VP-MUTANTS-SHARD-004/005 exercise
the structural half of this shape)

### AC-034 — Nightly full-run workflow is isolated from `ci-gate`
`.github/workflows/mutants-nightly.yml` is a wholly separate workflow
file (`schedule:` + `workflow_dispatch:`), requiring ZERO
`PINNED_GATE_EXCLUDED_JOBS` additions (invisible to `ci.yml`-scoped job
enumeration by construction) and satisfies
`test_no_sibling_workflow_declares_a_job_named_ci_gate` (neither
`mutants-full` nor `mutants-nightly-report` collides with the reserved
name).
Note: the nightly full-scope run's shard matrix uses `N=16` (`shard:
[0..15]`, `--shard k/16`), NOT the per-PR `mutants` job's `N=8` — see
`ci-yml-design.md` § `mutants-full` job (matrix `shard:` list, the
`cargo mutants --shard … 16` invocation, and the accompanying "N=16
(not 8)" design note); do not default to `N=8` here.
(traces to architecture-delta §5; no dedicated VP — this AC is the
regression guard the existing `e2e.yml`-precedent test already covers,
extended to the new file)

### AC-035 — F4 Blocking Precondition 3: empirical `--list`<->pooled reconciliation verified before merge
Before this story's PR merges, a scratch-run verification is performed
(NOT deferred to PR #778): `cargo mutants --list --in-diff <diff> | wc -l`
and the pooled sum of 8 `--shard k/8 --sharding slice --baseline skip`
runs against the IDENTICAL diff reconcile EXACTLY on a non-trivial,
known-nonzero in-diff mutant set. If they mismatch, the implementer
root-causes it (a tooling-surface artifact fixed at the source in
`mutants-plan`'s `--list` invocation, OR a genuine counting-convention
difference encoded as a documented, reasoned adjustment in `scripts/
mutants-aggregate.sh`) BEFORE merge — never re-widened to warning-only as
a shortcut. This AC is a PROCESS gate (Task 3 below), not a shipped code
behavior with its own `#[test]` — its evidence is the scratch-run
transcript attached to the PR, not a new Rust test.
(traces to INV-AGG sub-invariant 8's residual empirical premise,
mutants-sharding-invariants.md round-6 addendum; F4 Blocking Precondition
3, architecture-delta §1)

### AC-036 — `has_outcomes == true` always wins over `run_outcome` (FOLD, not fail-closed)
When a shard's sentinel reports `has_outcomes == true`, that shard's
`outcomes.json` is parsed and folded into the pooled sums regardless of
`run_outcome`'s value — including when `run_outcome != success` (e.g. a
heavily-unviable `--baseline skip` shard that legitimately exits
non-zero while still producing a valid `outcomes.json`). Such a shard
MUST be folded, not treated as a harness crash and excluded — excluding
it would undercount the pooled total against `MUTANT_COUNT` and produce
a false RED via AC-008's reconciliation check, even though the shard's
own evidence was genuinely complete. This arm is NEW to the sharded
redesign (INV-COMPLETE Part C was fully redesigned around a sentinel;
the single-job predecessor had no per-shard `run_outcome`/`has_outcomes`
distinction to reconcile) — it is not a carried-forward sub-case.
(traces to INV-COMPLETE Part C, fold-wins arm, `mutants-sharding-
invariants.md` § "Restated as the exact rule" (~1002-1005); no dedicated
VP — rides the aggregator `--self-test` fixtures/`EXPECTED_MUTANTS_AGG_
FIXTURES` floor, same pattern as AC-031/AC-032; RED-proof obligation: a
fixture where a shard carries `run_outcome=failure` AND `has_outcomes=
true` with a valid `outcomes.json` must FOLD that shard's counts into
the pooled sums, not exclude them)

### AC-037 — Sentinel/data desync (`has_outcomes` claims true, evidence absent or invalid) fails closed
When a shard's sentinel reports `has_outcomes == true` but that shard's
`outcomes.json` artifact is absent, or is present but fails `jq empty`,
the aggregation FAILS closed — distinct from both the harness-crash arm
(AC-006) and the legitimately-empty-shard arm (AC-007). A naive
"sentinel says `has_outcomes` so trust it" implementation would silently
treat this desync as 0 mutants for that shard instead of failing the
whole aggregation. This arm is NEW to the sharded redesign, for the same
reason as AC-036 above — it has no single-job predecessor to carry
forward from.
(traces to INV-COMPLETE Part C, sentinel/data-desync arm, `mutants-
sharding-invariants.md` § "Defensive cross-check (sentinel/data desync)"
(~1007-1014); no dedicated VP — rides the aggregator `--self-test`
fixtures/`EXPECTED_MUTANTS_AGG_FIXTURES` floor, same pattern as AC-031/
AC-032; RED-proof obligation: a fixture where a shard carries
`has_outcomes=true` but its `outcomes.json` artifact is missing (or
present-but-malformed) must FAIL the aggregation closed, distinct from
both the AC-006 crash fixture and the AC-007 legit-empty fixture)

### AC-038 — Step-0.5 `PLAN_RESULT != 'success'` fails closed with a mutants-plan-specific diagnostic
Before any shard sentinel is inspected (i.e. before Step 2), `mutants-
aggregate.sh` checks `PLAN_RESULT` (wired via AC-030's byte-VALUE pin to
`${{ needs.mutants-plan.result }}`): when it is any value other than the
literal string `"success"`, Step 0.5 returns 1 immediately with a
message naming `mutants-plan` itself as the failure point ("The shard
matrix could not have received a valid diff file; treat this as a
harness failure, not a kill-rate failure") — distinct from, and reached
BEFORE, Step 2's generic "missing shard sentinel" message a `mutants-
plan` crash would otherwise surface as. This is a diagnostics
improvement, not a new correctness class: INV-COMPLETE's Part B already
fails closed on the same underlying scenario (no diff artifact exists
for a shard to consume, so every sentinel is missing) — Step 0.5 exists
so the operator sees "mutants-plan failed" instead of a less direct
"8 shard sentinels missing" message for the identical root cause.
(traces to INV-ESCALATE Residual Risk 5 (`mutants-sharding-invariants.md`
§ "Residual risk flagged for F5 scoped adversarial review", item 5,
~1316-1339), implemented at `ci-yml-design.md §3` Step 0.5; no dedicated
VP — rides the aggregator `--self-test` fixtures/`EXPECTED_MUTANTS_AGG_
FIXTURES` floor, same pattern as AC-031/AC-036/AC-037; RED-proof
obligation: a fixture with `PLAN_RESULT=failure` (or any non-`"success"`
string) and zero shard status sentinels present must exit 1 with the
mutants-plan-specific message, and that message must be distinguishable
in the fixture's assertion from Step 2's missing-sentinel message text —
proving Step 0.5 actually short-circuited ahead of Step 2 rather than
merely happening to also fail there)

### AC-039 — Step-5 base-ref-drift FAIL/OK decision (distinct from AC-013's malformed-value guard)
AC-013 pins only the defensive `^[0-9]+$` regex guard on a malformed-but-
SET `OVERALL_DIFF_LINES`. This AC pins the actual decision behavior of
Step 5's base-ref-drift branch for well-formed values, which is reachable
ONLY after Step 4 has already reconciled `total_scored == MUTANT_COUNT
== 0` (any nonzero mismatch already returned 1 at Step 4): when
`total_scored == 0` and `OVERALL_DIFF_LINES == 0`, the aggregation FAILS
closed with a base-ref-drift message ("same F-3 signature as the
pre-sharding design"); when `total_scored == 0` and `OVERALL_DIFF_LINES >
0`, the aggregation PASSES with the "0 mutants scored — MUTANT_COUNT=0
(reconciled at Step 4)" message and control proceeds past Step 6 (which
is unreachable in this branch, mirroring AC-023's completeness-over-
quality proof one step further down the pipeline).
(traces to INV-COMPLETE § "Removed: the old count-based branch",
`mutants-sharding-invariants.md` ~1016-1042; implemented at `ci-yml-
design.md §3` Step 5; no dedicated VP — rides the aggregator `--self-test`
fixtures/`EXPECTED_MUTANTS_AGG_FIXTURES` floor, same pattern as AC-031/
AC-036/AC-037/AC-038; RED-proof obligation: two fixtures — (a)
`total_scored=0`, `MUTANT_COUNT=0`, `OVERALL_DIFF_LINES=0` -> exit 1 with
the base-ref-drift message; (b) `total_scored=0`, `MUTANT_COUNT=0`,
`OVERALL_DIFF_LINES=42` -> exit 0 with the "0 mutants scored" OK message
— proving the branch discriminates correctly in both directions, not
merely that SOME exit code is produced)

## Aggregator Step -> AC/Task Coverage Audit

Systematic audit (Phase F3 round 5 loop-breaker) of every aggregator
step/behavioral arm in `ci-yml-design.md §3`'s `evaluate_mutants_
aggregate()` against this story's ACs, so a reviewer can see every step
is covered without hunting across the document. Three prior passes each
elevated exactly one previously-unelevated arm (AC-036 in one pass,
AC-037 in the next, Step-0.5/Step-5 in a later pass) — this table was
already the terminal state for STEP coverage.

**Root-cause fix (Phase F3 round 8 loop-breaker):** this table previously
also carried `Task(s)` and `RED-proof?` columns, which duplicated — and
repeatedly drifted from — the dedicated "AC -> Task Coverage Audit" table
below. Three independent review passes each found a different cell where
the two tables disagreed. Rather than keep reconciling them by hand every
round, this table is now reduced to **STEP -> AC mapping only**: it maps
each aggregator step/arm to its governing AC(s) and nothing else.
**Task/proof attribution for each AC is in the authoritative "AC -> Task
Coverage Audit" table below; this table maps aggregator STEPS to their
governing AC(s) only.**

| Step | What it does | AC(s) |
|---|---|---|
| Step -1 | Resolve trusted `jq` once, before Step 0 | AC-024, AC-025 |
| Step 0 | Fail-closed event allowlist `case` | AC-014, AC-015 |
| Step 0.5 | `PLAN_RESULT != "success"` diagnostic short-circuit | AC-038 |
| Step 1 | `ESCALATED == 'true'` escalation short-circuit | AC-003, AC-010 |
| Step 2 | Sentinel presence (missing/duplicate) | AC-002 |
| Step 3 (crash arm) | Harness-crash shard excluded, fails closed | AC-006 |
| Step 3 (legit-empty arm) | Legitimately-empty shard, contributes 0 | AC-007 |
| Step 3 (fold-wins arm) | `has_outcomes==true` always wins over `run_outcome` | AC-036 |
| Step 3 (desync arm) | `has_outcomes==true` but evidence absent/invalid | AC-037 |
| Step 3 (per-shard guards) | Malformed-JSON/integer-validation/schema-drift/`total_mutants` warning-only reconciliation (INV-AGG sub-invariants 3-6) | rides AC-001 (carried forward verbatim from the single-job `Check kill rate` step per Architecture Compliance Rules — no dedicated new AC, per `dependency-graph-extended.md`'s Edge Case Coverage Matrix EC-007 row) |
| Step 4 (under-count) | `total_scored < MUTANT_COUNT` hard fail | AC-008 |
| Step 4 (over-count) | `total_scored > MUTANT_COUNT` hard fail, symmetric | AC-022 |
| Step 4 (completeness-over-quality) | A healthy partial kill rate never rescues a mismatch | AC-023 |
| Step 5 (malformed-value guard) | `OVERALL_DIFF_LINES` malformed-but-set regex guard | AC-013 |
| Step 5 (FAIL/OK decision) | `total_scored==0 && OVERALL_DIFF_LINES==0` -> FAIL; else -> OK | AC-039 |
| Step 6 | Pooled kill-rate >= 90 gate | AC-001 |

**Result: every step/arm in `evaluate_mutants_aggregate()` now has either
a dedicated AC or an explicit "rides AC-001, carried-forward, no dedicated
AC needed per Architecture Compliance Rules" disposition — zero
unaccounted-for arms remain.** The Governance Deviation Note, the AC-031
Gap Register cross-reference, and `dependency-graph-extended.md`'s
Invariant/VP Coverage Matrix are all updated in this same pass to reflect
AC-038/AC-039's addition.

## AC -> Task Coverage Audit

**New this pass (Phase F3 round 7 loop-breaker).** The table above audits
`evaluate_mutants_aggregate()`'s internal STEPS — a subset of this
story's scope (it does not cover `mutants-plan`'s own structural pins,
the `ci-gate` peer-parity pins, the env-wiring byte-VALUE pins, the
skip-tolerant-surface emptying, the nightly workflow, or the process-gate
ACs). Two rounds of "spot the next gap" review (rounds 5 and 6) each
elevated exactly one previously-unelevated item, which is itself a signal
that spot-checking does not terminate reliably. This table instead walks
ALL 39 ACs (AC-001 through AC-039) once, systematically, against the
Tasks list, so no future round has to rediscover a coverage gap by
inspection. It found and this pass fixed four gaps: AC-009 and AC-016
had NO task obligation at all (F-H1, fixed by extending Task 18 and
adding new Task 17 respectively — see the Tasks list above); AC-013 was
implement-only, missing from Task 12's write-failing-test enumeration
(LOW, fixed by extending Task 12); and AC-033 had no explicit task
CITATION despite being implemented by Task 9 (loop-breaker finding, not
individually named in the dispatch, fixed by adding the citation to
Tasks 8/9). AC-003 was also rewritten this pass (F-M1) to remove the
"FIRST check" framing that contradicted Step -1/Step 0/Step 0.5 preceding
it — that fix is a wording correction to AC-003 itself, not a
task-coverage gap, and is not re-listed as a row-level finding below.

**Round 8 (this pass) additions — this table is now the SINGLE
authoritative source for AC-to-task/proof attribution** (the sibling
"Aggregator Step -> AC/Task Coverage Audit" table above was reduced to a
STEP -> AC mapping only, to stop the two tables from drifting apart —
see that table's round-8 note). Two rows were corrected this pass:
AC-005's implement-task citation was "Task 7," which is wrong (Task 7
only implements `mutants-plan`, which carries no `strategy.matrix.shard`)
— corrected to Task 9 (which actually builds the 8-shard matrix the
`EXPECTED_SHARDS` constant cross-checks against), plus Task 11/Task 2 for
context (F-M-001). AC-010's write-test and implement columns were
missing a Task 16 citation for the `ESCALATED` consumer env line, which
is authored in Task 16, not Task 6/Task 7 alone — both columns now cite
Task 16 alongside their existing citations (F-L-005).

| AC | Write-Test Task | Implement Task | Disposition |
|---|---|---|---|
| AC-001 | Task 10 | Task 11 (core sub-invariants), Task 13 (Step 6 gate), Task 16 (job wiring) | Pooled kill-rate contract; rides across three tasks by design |
| AC-002 | Task 10 | Task 9 (sentinel produced), Task 11 (sentinel-presence interpretation) | |
| AC-003 | Task 14 | Task 15 | Escalation short-circuit, Step 1; AC text reworded this pass (F-M1) |
| AC-004 | Task 6 | Task 7 | `mutants-plan` structural pin |
| AC-005 | Task 6 | Task 9 (builds the 8-shard `strategy.matrix.shard` sequence the cross-check runs against) | `EXPECTED_SHARDS` cross-check — **corrected round 8 (F-M-001): implement column was "Task 7," wrong, since Task 7 only implements `mutants-plan`, which has no `strategy.matrix.shard`. Round 9 (LOW polish): trimmed the orphaned "Task 11 (+ Task 2, extraction context)" tail — Task 11/Task 2 are orthogonal to a matrix-length pin and misled readers; Task 9 alone is the correct citation.** |
| AC-006 | Task 10 | Task 9 (sentinel produced), Task 11 (crash-arm interpretation) | CRIT-1 regression guard |
| AC-007 | Task 10 | Task 9 (sentinel produced), Task 11 (legit-empty interpretation) | HIGH-1 regression guard |
| AC-008 | Task 12 | Task 13 | Exact-equality reconciliation, under-count direction |
| AC-009 | Task 18 | Task 16 (`mutants-aggregate`'s job-level `if: always()` — the disjointness assertion's `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS` subject), Task 18 (structural pin authoring), Task 21 (empties `SKIP_TOLERANT_NEEDS_MEMBERS` — without which the disjointness assertion has nothing empty to check) | **structural pin — Task 18 (F-H1 fix, round 7: Task 18 extended this pass from "5 structural-peer pins" to "6 structural-peer pins" to add AC-009 alongside AC-017 through AC-021). Round 9 (LOW polish): implement column previously cited only Task 18; added Task 16 and Task 21, both of which AC-009's GREEN state actually depends on.** |
| AC-010 | Task 6 (output-wiring test), Task 16 (consumer env-line wiring, F-L-005), Task 19 (byte-VALUE pin) | Task 7 (output wiring), Task 16 (consumer env-line wiring), Task 19 (pin) | Dual: functional output wiring + structural byte pin — **round 8: Task 16 added to both columns (F-L-005) since the `ESCALATED` consumer env line is authored there** |
| AC-011 | Task 21 | Task 21 | structural pin — Task 21 (skip-tolerant surface emptying); verified by Task 24 |
| AC-012 | Task 21 | Task 21 | structural pin — Task 21; verified by Task 24 |
| AC-013 | Task 12 | Task 13 | **LOW fix, round 7: AC-013 added to Task 12's write-failing-test enumeration (previously implement-only via Task 13)** |
| AC-014 | Task 14 | Task 15 | Step 0 fail-closed event-allowlist `case` |
| AC-015 | Task 19 | Task 16 (job wiring writes the env line), Task 19 (pin) | |
| AC-016 | Task 17 | Task 17 | **structural pin — Task 17 (F-H1 fix, round 7: new task added — did not exist before this pass)** |
| AC-017 | Task 18 | Task 16 (job wiring) | structural pin — Task 18 |
| AC-018 | Task 18 | Task 16 | structural pin — Task 18 |
| AC-019 | Task 18 | Task 16 | structural pin — Task 18 |
| AC-020 | Task 18 | Task 16 | structural pin — Task 18 |
| AC-021 | Task 18 | Task 16 | structural pin — Task 18 |
| AC-022 | Task 12 | Task 13 | Exact-equality reconciliation, over-count direction (symmetric with AC-008) |
| AC-023 | Task 12 | Task 13 | Completeness-over-quality proof |
| AC-024 | Task 22 | Task 2 (extraction) | Runtime-hardening parity — shared `trusted-jq.sh` sourcing |
| AC-025 | Task 22 | Task 2 (extraction) | Runtime-hardening parity — no bare decision-path `jq` |
| AC-026 | Task 19 | Task 16 | structural pin — Task 19 |
| AC-027 | Task 19 | Task 16 | structural pin — Task 19 |
| AC-028 | Task 19 | Task 16 | structural pin — Task 19 |
| AC-029 | Task 19 | Task 16 | structural pin — Task 19 |
| AC-030 | Task 19 | Task 16 | structural pin — Task 19 |
| AC-031 | process gate — Task 25 | Task 25 | Fixed-denominator self-check counters (RE-VERIFY-at-F4 caveat applies) |
| AC-032 | Task 20 (updates the existing `test_ci_gate_needs_exactly_the_required_jobs` expected set in the same commit) | Task 20 | `ci-gate.needs` retarget — test-update and implementation land together |
| AC-033 | Task 8 | Task 9 | **citation gap closed round 7: Task 8/9 now explicitly cite AC-033 (previously implemented by Task 9 with no AC-number citation anywhere)** |
| AC-034 | Task 23 (the regression test is written as part of the same task) | Task 23 | Nightly workflow isolation — test+implement combined in one task |
| AC-035 | process gate — Task 3 | Task 3 | F4 Blocking Precondition 3, empirical premise verification; PROCESS gate, no `#[test]` of its own |
| AC-036 | Task 10 | Task 11 | Fold-wins arm — NEW to the sharded redesign, no single-job predecessor |
| AC-037 | Task 10 | Task 11 | Sentinel/data-desync arm — NEW to the sharded redesign, no single-job predecessor |
| AC-038 | Task 14 | Task 15 | Step 0.5 diagnostic short-circuit |
| AC-039 | Task 12 | Task 13 | Step 5 base-ref-drift FAIL/OK decision |

**Result: all 39 ACs now have an explicit write-test-task and
implement-task citation (or an explicit "process gate"/"structural pin"
disposition for the ACs that are process obligations or pure structural
pins rather than paired RED/GREEN behavior) — zero orphaned or
test-unassigned ACs remain as of round 7.** Any future round that adds or
edits an AC MUST add or update the corresponding row in this table in the
same pass, per the same discipline this round applied to close AC-009/
AC-016/AC-013/AC-033.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|---|---|---|
| `mutants-plan` job | `.github/workflows/ci.yml` (NEW job) | Effectful (CI orchestration) |
| `mutants` shard matrix job (8 shards) | `.github/workflows/ci.yml` (MODIFIED — was single job, now `strategy.matrix.shard: [0..7]`) | Effectful (CI orchestration) |
| `mutants-aggregate` job | `.github/workflows/ci.yml` (NEW job, replaces `mutants` as `ci-gate.needs` member) | Effectful (CI orchestration) |
| `ci-gate` job | `.github/workflows/ci.yml` (MODIFIED — `needs:` array, ONE element changed) | Effectful (CI orchestration) |
| `mutants-aggregate.sh` aggregation logic | `scripts/mutants-aggregate.sh` (NEW file, extracted per F4 Blocking Precondition 2) | Effectful (bash/jq over CI artifacts) |
| Shared jq-trust helper | `scripts/lib/trusted-jq.sh` (NEW file, extracted from `check-ci-gate.sh`) | Effectful (bash) |
| `check-ci-gate.sh` refactor to source shared lib | `scripts/check-ci-gate.sh` (MODIFIED) | Effectful (bash) |
| 27 new guard tests + constant updates | `tests/ci_gate_completeness.rs` (MODIFIED) | Test-only (Rust, subprocess + parsed-YAML assertions) |
| Nightly full-scope workflow | `.github/workflows/mutants-nightly.yml` (NEW file) | Effectful (CI orchestration, advisory) |
| Policy doc update (spec of record) | `docs/specs/cargo-mutants-policy.md` (MODIFIED) | Documentation |
| CHANGELOG entry | `CHANGELOG.md` (MODIFIED) | Documentation |

## UX Screens

N/A — CI/CD infrastructure, no UI surface.

## Design System Components

N/A — not a UI story.

## Edge Cases

| ID | Description | Expected Behavior |
|---|---|---|
| EC-001 | All 8 shards crash under `continue-on-error: true` | Aggregation FAILS closed (AC-006, CRIT-1 regression guard) |
| EC-002 | A small PR's shard slices are legitimately empty (not crashed) | Aggregation PASSES, distinguished via sentinel (AC-007) |
| EC-003 | A shard's sentinel is missing entirely | Aggregation FAILS closed (AC-002) |
| EC-004 | A shard's sentinel or outcomes.json artifact is duplicated | Aggregation FAILS closed (AC-002) |
| EC-005 | `total_scored < MUTANT_COUNT` (mutants silently dropped between plan and execution) | HARD FAIL, exact-equality (AC-008) — the dangerous direction, since a dropped mutant could be a survivor |
| EC-006 | `total_scored > MUTANT_COUNT` (shard matrix examined more than planned) | HARD FAIL, exact-equality, symmetric (AC-022) |
| EC-007 | A shard's `outcomes.json` is malformed JSON | Fails the whole aggregation closed (per-file malformed-JSON guard, INV-AGG sub-invariant 3), not silently treated as 0 |
| EC-008 | `EVENT_NAME` is empty or an unrecognized value (typo, future GHA trigger) | Step 0 FAILS closed via the allowlist `case` (AC-014) — never a silent exit-0 no-op on a real PR |
| EC-009 | `>120` in-diff mutants (escalation threshold exceeded) | Ordinary CI `failure` with actionable remediation message; shard matrix skipped entirely (AC-003) |
| EC-010 | A PR edits the eval step's `env:` block to redirect `STATUS_DIR`/`SHARD_DIR` to attacker-supplied directories with fabricated sentinels/outcomes.json | Structurally caught by AC-026/AC-027's byte-VALUE pins — cannot land as a silent PR diff |
| EC-011 | A PR hardcodes the `MUTANT_COUNT`/`OVERALL_DIFF_LINES`/`PLAN_RESULT` env lines to defeat reconciliation | Structurally caught by AC-028/AC-029/AC-030's byte-VALUE pins |
| EC-012 | A PR appends `\|\| true`/`\| cat`/`; exit 0` to the eval step's `run:` line | Structurally caught by AC-017's byte-pin |
| EC-013 | A PR smuggles a key via a YAML anchor/tag node property (`&x shell: cat {0}`) | Structurally caught by AC-020's node-property scan |
| EC-014 | A `$GITHUB_PATH`-prepended `jq` shim on an earlier `uses:` step | Structurally caught by AC-024/AC-025's shared trusted-jq sourcing + no-bare-jq scan |
| EC-015 | `--list`<->pooled reconciliation premise does not hold empirically for a real, non-trivial diff | F4 Blocking Precondition 3 (AC-035) catches this BEFORE merge, root-caused per the two documented branches (tooling artifact vs. counting-convention difference) |
| EC-016 | Common-mode corruption of the shared `mutants-diff-file` artifact itself (a wrong-but-internally-consistent diff) | **Documented, accepted residual (§5A of `verification-delta.md`) — NOT closeable in-pipeline.** Both `--list` and every shard derive from the same artifact, so a wrong-at-the-source diff reconciles cleanly with itself. Backstopped only by the nightly full-scope run (up to 24h lag, advisory-only). This story does NOT attempt to close this residual — it is explicitly out of scope, flagged for F5/F6 re-examination as production experience accumulates. |
| EC-017 | A shard reports `run_outcome != success` (e.g. a heavily-unviable `--baseline skip` shard exits non-zero) but its sentinel also reports `has_outcomes == true` with a valid `outcomes.json` | Aggregation FOLDS that shard's counts into the pooled sums — `has_outcomes == true` always wins over `run_outcome` (AC-036); NOT treated as a harness crash and excluded (would false-RED via AC-008) |
| EC-018 | A shard's sentinel reports `has_outcomes == true` but that shard's `outcomes.json` artifact is absent, or present but fails `jq empty` | Aggregation FAILS closed — the sentinel/data-desync arm (AC-037), distinct from both the crash arm (AC-006) and the legit-empty arm (AC-007) |
| EC-019 | `mutants-plan` itself fails outright (checkout failure, cargo-mutants install failure, `--list` tooling crash) so `PLAN_RESULT != "success"` | Step 0.5 FAILS closed BEFORE Step 2, with a mutants-plan-specific diagnostic distinct from Step 2's generic missing-sentinel message (AC-038) — correctness-safe either way, since Step 2 would independently catch the same root cause |
| EC-020 | `total_scored == 0` (already reconciled at Step 4 to also mean `MUTANT_COUNT == 0`) and `OVERALL_DIFF_LINES == 0` | Step 5 FAILS closed as a likely base-ref-drift signal (AC-039); the mirror case (`OVERALL_DIFF_LINES > 0`) PASSES with the "0 mutants scored" OK message |

## Purity Classification

N/A — this story is entirely CI/CD infrastructure (`.github/workflows/`,
`scripts/`, `tests/ci_gate_completeness.rs`, `docs/specs/`). No `src/`
product code changes; no pure-core/effectful-shell boundary to draw for a
GitHub Actions workflow topology (per `architecture-delta.md`'s own
`purity_boundary: N/A` framing).

## Token Budget Estimate

| Context Source | Estimated Tokens |
|---|---|
| This story spec | ~7,500 |
| `architecture-delta.md` (full, 3,094 lines) | ~50,000 |
| `mutants-sharding-invariants.md` (full, 1,357 lines) | ~22,000 |
| `ci-yml-design.md` (full, 1,343 lines) | ~21,000 |
| `verification-delta.md` (full, 3,113 lines) | ~50,000 |
| `docs/specs/cargo-mutants-policy.md` (existing, 834 lines, full read for the update task) | ~13,000 |
| `scripts/check-ci-gate.sh` (existing, 1,509 lines, full read for the extraction task) | ~24,000 |
| `tests/ci_gate_completeness.rs` (existing, partial read of relevant sections + full write of 27 new tests) | ~15,000 |
| New/modified `ci.yml`, `mutants-nightly.yml`, `mutants-aggregate.sh`, `trusted-jq.sh` (est. combined ~800-1,200 LOC) | ~12,000 |
| **Total** | **~214,500** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **exceeds a single 200K window if all four F2 docs are loaded in full simultaneously** |

**This story exceeds the 20-30% single-load guidance if the implementer
attempts to read all four F2 spec documents cover-to-cover in one
context.** Mitigation, mandatory for the implementer (not optional): load
`architecture-delta.md` and `mutants-sharding-invariants.md` together for
the topology/invariant-implementation phase (~72K tokens, ~36% — still
over budget alone, so within THAT phase, load section-by-section per
Task, not the whole file at once — e.g. `architecture-delta.md §6.2`
alone for the constants table, not the full file); load
`verification-delta.md` only for the specific VP being test-written at
that moment (grep the VP number, read that VP's ~50-80 line section, not
the full 3,113-line file); load `ci-yml-design.md` only for the exact
job/step pseudo-YAML being transcribed into the real `ci.yml`. This
mirrors how this story-writer agent itself worked (targeted `sed`/`grep`
extraction against these same four files, never a single full read of
all four) — the same discipline is REQUIRED of the implementer, not
merely advisory, given the token budget above.

## Tasks

**Fold-in of the 5 F4 Blocking Preconditions (architecture-delta.md §1) —
these are explicit, ordered tasks, not background prose:**

1. [ ] **F4 Blocking Precondition 1 (sequencing):** confirm PR #778 is
   resolved (merged/closed/re-targeted) against the OLD single-job
   `mutants` gate BEFORE this story's `ci.yml` changes land. This is a
   cross-cycle sequencing check, not a graph dependency (cycle-005 is
   PAUSED, not a `depends_on:` edge — see `dependency-graph-extended.md`
   §2 for why this is recorded as a note, not an edge). If PR #778 has
   NOT resolved by the time this story is ready to merge, escalate to
   the orchestrator before proceeding — do not merge this story's `ci.yml`
   changes while PR #778 is open against the old gate shape.
2. [ ] **F4 Blocking Precondition 2 (extraction):** extract
   `scripts/mutants-aggregate.sh` (the aggregation logic — INV-AGG/
   INV-COMPLETE/INV-ESCALATE decision code — as an invokable script with
   a `--self-test` mode) AND `scripts/lib/trusted-jq.sh` (extracted from
   `check-ci-gate.sh`'s existing `resolve_trusted_jq`/`is_trusted_jq_dir`/
   `trusted_jq_dirs_for`). Refactor `scripts/check-ci-gate.sh` to
   `source` the new shared lib file rather than keeping its own copy.
   BLOCKING — every INV-AGG/INV-COMPLETE guard test depends on this
   existing first (`architecture-delta.md §6.2a`).
3. [ ] **F4 Blocking Precondition 3 (empirical premise verification,
   AC-035):** on a scratch branch (or via direct comparison against an
   already-open diff) with a known-nonzero in-diff mutant set, run (a)
   `cargo mutants --list --in-diff <diff> | wc -l` and (b) the 8
   `--shard k/8 --sharding slice --baseline skip` runs against the
   IDENTICAL diff, and confirm the two counts reconcile EXACTLY. Do this
   BEFORE this story's own PR merges — this story's own PR is CI/doc-only
   (`MUTANT_COUNT == 0`) and cannot supply this evidence itself. On a
   mismatch, root-cause via the two documented branches (tooling-surface
   artifact vs. counting-convention difference) and fix/encode BEFORE
   merge — never re-widen to warning-only as a shortcut.
4. [ ] **F4 Blocking Precondition 4 (full guard-test suite):**
   `cargo test`'s `ci_gate_completeness.rs` suite (65/65), `scripts/
   check-ci-gate.sh --self-test` (14/14 fixtures + the jq-trust +
   print-allowed-skips self-tests), AND `scripts/mutants-aggregate.sh
   --self-test` (>=12 fixtures) must all pass locally AND in CI before
   merge.
5. [ ] **F4 Blocking Precondition 5 (policy-doc drafting, same PR):**
   update `docs/specs/cargo-mutants-policy.md` in the SAME PR as the
   code/test changes — activate/expand the "Future Path: Job Sharding
   (Path B)" section into the live design; update "CI Gate: Required
   Check" to name `mutants-aggregate` (not `mutants`) as the
   `ci-gate.needs` member, with `mutants`/`mutants-plan` excluded via
   `PINNED_GATE_EXCLUDED_JOBS`; add a new "Escape Hatch" section (the
   >120-mutant path); add a new "Scheduled Full Run" section
   (`mutants-nightly.yml`); update "CI Integration"/"Local Invocation"
   for the sharded topology; transcribe the INV-AGG/INV-COMPLETE/
   INV-ESCALATE invariant substance directly into the policy doc (not
   only by reference); add ONE new `## Changelog` table row.
6. [ ] Write failing tests for `mutants-plan`'s structural shape
   (AC-004), `EXPECTED_SHARDS` cross-check (AC-005), and the escalated-
   output wiring pin (AC-010) before implementing the job.
7. [ ] Implement `mutants-plan` in `ci.yml` (DIFF_FILE computation,
   artifact upload, pre-count, escalated/mutant_count/overall_diff_lines
   outputs).
8. [ ] Write failing tests for the `mutants` shard job's structural shape
   (AC-033: the `--shard k/8 --sharding slice --jobs 2 --baseline skip
   --timeout 240` invocation shape, the shared-`mutants-diff-file`-
   artifact-reuse wiring, and the `cargo-mutants@27.1.0` exact pin) — the
   renamed `test_mutants_shard_job_structure_matches_sharded_design`,
   including the 3-count `steps_with_if` cardinality inversion — before
   modifying the job.
9. [ ] Implement AC-033: modify the `mutants` job into an 8-shard
   `strategy.matrix.shard` job: `--shard k/8 --sharding slice --jobs 2
   --baseline skip --timeout 240`, downloading the shared
   `mutants-diff-file` artifact, writing + uploading the status sentinel
   (AC-002/AC-006/AC-007's evidence source), then uploading
   `outcomes.json`.
10. [ ] Write failing subprocess-harness tests for INV-COMPLETE (AC-002,
    AC-006, AC-007, AC-036, AC-037), INV-AGG's core summation contract
    (AC-001), AND three previously-unnamed FATAL/warning per-shard arms
    this pass's F-P18-MED-001 loop-breaker audit surfaced — each needs its
    OWN named `--self-test` fixture in `scripts/mutants-aggregate.sh`,
    distinct from AC-001's baseline pooled-summation fixture and from
    AC-037's desync fixture:
    - **INV-AGG sub-invariant 3 (per-file malformed-JSON guard, FATAL):**
      a fixture where ONE shard's downloaded `outcomes.json` DOES exist
      (passes Part B presence and the AC-037 desync pre-check) but its
      content fails `jq empty` at fold time — the whole aggregation FAILS
      CLOSED, naming the offending shard, never coerced to "0 mutants for
      that shard." Distinct from AC-037: AC-037 exercises the sentinel
      claiming `has_outcomes==true` while the artifact is ABSENT or fails
      the desync pre-check before trusting the sentinel; this fixture
      exercises the fold-time `jq empty` parse guard itself on a
      genuinely-downloaded-but-corrupt file.
    - **INV-AGG sub-invariant 5 / H-1 (per-file schema-drift guard,
      FATAL):** a fixture where one shard's `outcomes.json` is
      syntactically valid JSON with a non-empty `.outcomes` array (or
      non-zero `total_mutants`) but all four summary keys
      (`caught`/`missed`/`timeout`/`unviable`) parse to 0 — the whole
      aggregation FAILS CLOSED, naming the offending shard (per-shard
      instantiation of the existing single-job H-1 guard).
    - **INV-AGG sub-invariant 6 / M-2 (per-file `total_mutants`
      reconciliation, NON-FATAL):** a fixture where one shard's
      `caught_s + missed_s + timeout_s + unviable_s != total_mutants_s`
      (and `total_mutants_s != 0`) — the aggregation emits a
      `::warning::` annotation naming the offending shard index AND
      STILL PROCEEDS to Step 4/5/6 and can still PASS if otherwise
      healthy. This fixture must assert BOTH the warning is emitted AND
      the job's exit code/pass-fail decision is unaffected by it —
      distinguishing it from every fail-closed fixture above and below.
    These three ride AC-001's core summation contract per the
    Architecture Compliance Rules disposition (no dedicated AC number,
    per `dependency-graph-extended.md`'s EC-007 row) but must not be
    treated as "covered by AC-001's baseline fixture" without their own
    dedicated fixture — see the "INV-AGG/INV-COMPLETE Sub-Invariant ->
    Named RED Fixture" mini-table immediately below for the full,
    systematic per-sub-invariant/per-Part audit this task's expansion is
    drawn from. AC-036/AC-037 are the two sharding-introduced Part C arms
    (fold-wins, sentinel/data desync) — do not skip them as "covered by
    AC-006/AC-007" — they are distinct fixtures.

### INV-AGG/INV-COMPLETE Sub-Invariant -> Named RED Fixture Mini-Table

**Added Phase F3 round 9 (F-P18-MED-001, loop-breaker).** A fresh pass
found Task 10's enumeration named a RED fixture for every AC-numbered arm
but silently left THREE fatal/warning per-shard arms — real obligations
already present in Task 11's implement text and EC-007's edge-case row —
with no corresponding named fixture, the same asymmetry this story
already fixed once before for AC-036/AC-037. This table walks EVERY
INV-AGG sub-invariant (1-8) and EVERY INV-COMPLETE Part (A/B/C) once,
systematically, so no future round has to rediscover this class of gap by
spot-checking.

| Invariant clause | Fatal? | Named RED fixture | Task |
|---|---|---|---|
| INV-AGG sub-invariant 1 (timeouts count as survived) | N/A — arithmetic rule of the pooled-summation contract, not an independent fail-closed arm | rides AC-001's core summation fixture | Task 10 |
| INV-AGG sub-invariant 2 (`unviable` excluded from `killable` denominator) | N/A — arithmetic rule | rides AC-001's core summation fixture | Task 10 |
| INV-AGG sub-invariant 3 (per-file malformed-JSON guard) | **FATAL** | **NEW this pass** — per-shard malformed `outcomes.json` fixture (above) | Task 10 |
| INV-AGG sub-invariant 4 (per-file integer-validation guard, non-integer coerces to 0 for that shard) | Non-fatal (per-shard coercion, does not short-circuit the aggregation) | rides AC-001's core summation fixture (a non-integer field exercised as part of the pooled-summation proof) | Task 10 |
| INV-AGG sub-invariant 5 / H-1 (per-file schema-drift guard) | **FATAL** | **NEW this pass** — per-shard H-1 schema-drift fixture (above) | Task 10 |
| INV-AGG sub-invariant 6 / M-2 (per-file `total_mutants` reconciliation) | Non-fatal, `::warning::`-only | **NEW this pass** — warning-emitted-job-still-proceeds fixture (above) | Task 10 |
| INV-AGG sub-invariant 7 (`@27.1.0` exact pin protects every shard identically) | Not a runtime/fixture-testable behavior — a code-review-time version-pin obligation | Architecture Compliance Rules table's existing "Code-review-time obligation" row — no `#[test]`/fixture applicable | N/A |
| INV-AGG sub-invariant 8 (pooled-total <-> `MUTANT_COUNT` reconciliation, exact-equality hard fail both directions) | **FATAL** | AC-008 (under-count), AC-022 (over-count), AC-023 (completeness-over-quality) — already named | Task 12 |
| INV-COMPLETE Part A (sentinel write, producer side in the `mutants` shard job) | N/A at the aggregator — a producer-side structural shape, not itself an aggregator fail-closed arm | AC-033 (shard invocation/sentinel-write structural pin); verified indirectly via every consumer (AC-002/006/007/036/037) that reads the sentinel it writes | Task 8/9 |
| INV-COMPLETE Part B (sentinel-presence check — missing or duplicate) | **FATAL** | AC-002 — already named | Task 10 |
| INV-COMPLETE Part C — harness-crash arm | **FATAL** | AC-006 — already named | Task 10 |
| INV-COMPLETE Part C — legitimately-empty arm | PASS (0 contribution) | AC-007 — already named | Task 10 |
| INV-COMPLETE Part C — fold-wins arm | PASS (folds despite non-success `run_outcome`) | AC-036 — already named | Task 10 |
| INV-COMPLETE Part C — sentinel/data-desync arm | **FATAL** | AC-037 — already named | Task 10 |

**Result: every FATAL fail-closed arm and every non-fatal warning-only
arm in INV-AGG/INV-COMPLETE now has an explicitly-named RED fixture (or,
for sub-invariant 7, an explicit "not fixture-testable, code-review-time
obligation" disposition) — zero unaccounted-for arms remain as of round
9.** AC-031's `EXPECTED_MUTANTS_AGG_FIXTURES` floor (`>=12`) MUST include
the three fixtures newly named this pass (sub-invariant 3, sub-invariant
5/H-1, sub-invariant 6-warning) — the F4 mechanical recount must not omit
them; see AC-031 below, updated in the same pass to say so explicitly.

**Clarification (LOW polish item L-5) — reconciling this story's "four
arms" with F2's own Part C table:** `mutants-sharding-invariants.md`'s
Part C interpretation table (`§ "Part C — per-shard interpretation"`,
~990-1000) has FOUR ROWS, but they are not a 1:1 match to this story's
"four arms" language below. The F2 table's `success`/`true` row (the
ordinary, healthy case) is the "normal" case and is covered by AC-001's
pooled-summation contract, not by a dedicated Part-C-arm AC of its own.
This story's "four arms" (used throughout Task 11, AC-036, and AC-037)
refers specifically to the four arms that DO get a dedicated AC:
harness-crash (AC-006), legitimately-empty (AC-007), fold-wins (AC-036),
and sentinel/data-desync (AC-037) — a reader diffing this story against
F2's table should not be misled into expecting a fifth AC for the
"normal" row; it rides AC-001 by design.

11. [ ] Implement `scripts/mutants-aggregate.sh`'s core: sentinel
    presence/interpretation (INV-COMPLETE Parts A/B/C — Part C explicitly
    covers FOUR distinct arms, not two: the harness-crash arm (AC-006,
    `steps.run-mutants.outcome` != success), the legitimately-empty-shard
    arm (AC-007, a healthy shard whose `--sharding slice` computation
    produced zero mutants), the fold-wins arm (AC-036: a shard whose
    `run_outcome != success` but whose sentinel also reports
    `has_outcomes == true` with a valid `outcomes.json` — that shard's
    counts MUST be folded, not excluded), AND the sentinel/data desync
    arm (AC-037, EC-018: a shard's sentinel claims `has_outcomes==true`
    but that shard's `outcomes.json` artifact is absent, or is present
    but fails `jq empty` — this desync case FAILS the aggregation closed,
    exactly like the missing/malformed cases below, and must be
    distinguished in the implementation and its tests from both the
    crash arm and the legit-empty arm, since a naive "sentinel says
    has_outcomes so trust it" implementation would silently treat this
    as 0 mutants instead of failing closed). AC-036 and AC-037 are both
    NEW to the sharded redesign (no single-job predecessor to carry
    forward from) and each requires its own dedicated `--self-test`
    fixture — see Task 12 below. Load-bearing fold rule for all four arms
    (`mutants-sharding-invariants.md` § "Restated as the exact rule",
    ~1002-1005): `has_outcomes == true`
    ALWAYS wins over `run_outcome` — whenever a shard's sentinel reports
    `has_outcomes == true`, that shard's `outcomes.json` MUST be parsed
    and folded into the pooled sums regardless of `run_outcome`'s value.
    A heavily-unviable `--baseline skip` shard can legitimately exit
    non-zero (`run_outcome != success`) while still producing a valid
    `outcomes.json` — such a shard must be FOLDED, not treated as a
    harness-crash and excluded, else the aggregation produces a false
    RED (an undercounted pooled total that never matches `MUTANT_COUNT`).
    Do not naively fail-closed on any non-success `run_outcome` when
    `has_outcomes == true` is present.), pooled summation (INV-AGG
    sub-invariants 1-2, 7),
    per-shard malformed-JSON/integer-validation/schema-drift guards
    (INV-AGG sub-invariants 3-5 — sub-invariant 3 specifically: EVERY
    shard's `outcomes.json` MUST be validated with `jq empty` before that
    shard's counts are folded into the running sums; a malformed/
    unparseable file for ANY shard is a FATAL, per-shard fail-closed
    condition for the WHOLE aggregation — never coerced to "0 mutants for
    that shard" and never merely warned-about), AND the per-shard
    `total_mutants` reconciliation (INV-AGG sub-invariant 6, distinct from
    sub-invariant 8's pooled-total reconciliation in Task 12/13 below):
    for each shard, if `caught_s + missed_s + timeout_s + unviable_s !=
    total_mutants_s` (and `total_mutants_s != 0`), emit a `::warning::`
    annotation naming the offending shard index — this check is NON-FATAL
    and does NOT affect the aggregation's pass/fail decision (mirrors the
    existing single-job design's M-2 warning-only guard, per
    `mutants-sharding-invariants.md`'s sub-invariant 6 statement).
    Sub-invariants 1-7 are therefore ALL represented by a concrete
    implementation obligation in this task, not merely by the generic
    "carried forward verbatim" cross-reference in Previous Story
    Intelligence below.
12. [ ] Write failing tests for the exact-equality `MUTANT_COUNT`
    reconciliation, BOTH directions (AC-008, AC-022, AC-023); for Step
    5's malformed-value guard (AC-013: a non-empty, malformed
    (non-`^[0-9]+$`) `OVERALL_DIFF_LINES` value must fail closed,
    symmetric with `MUTANT_COUNT`'s Step-4 guard); AND for Step 5's
    base-ref-drift FAIL/OK decision, both directions (AC-039:
    `total_scored==0 && OVERALL_DIFF_LINES==0` -> FAIL;
    `total_scored==0 && OVERALL_DIFF_LINES>0` -> OK) — before
    implementing Step 4/5.
13. [ ] Implement Step 4 (reconciliation, hard fail both directions) and
    Step 5/6 (base-ref-drift malformed-value guard, AC-013; base-ref-drift
    FAIL/OK decision, AC-039; final kill-rate gate, AC-001) — confirm
    Step 6 is structurally unreachable whenever Step 4 fails (AC-023's
    completeness-over-quality proof) or Step 5 fails (AC-039's mirror of
    that same proof one step further down the pipeline).
14. [ ] Write failing tests for Step 0's fail-closed event-allowlist
    guard (AC-014), Step 0.5's `PLAN_RESULT != "success"` diagnostic
    short-circuit (AC-038), and the escalation short-circuit (AC-003)
    before implementing.
15. [ ] Implement Step 0 (fail-closed `case` allowlist), Step 0.5
    (`PLAN_RESULT != 'success'` -> exit 1 with the mutants-plan-specific
    diagnostic message, AC-038 — implemented between Step 0 and Step 1,
    matching `ci-yml-design.md §3`'s ordering), and the escalation check
    (Step 1, `ESCALATED == 'true'` -> exit 1 with the two-path
    remediation message).
16. [ ] Add `mutants-aggregate` to `ci.yml` (`needs: [mutants-plan,
    mutants]`, `if: always()`) wiring the extracted script as the sole
    `run:` line of its eval step.
17. [ ] **Implement AC-016 (F-H1 fix, round 7):** add a step to the
    `spec-guard` job whose `run:` line is byte-pinned to
    `bash scripts/mutants-aggregate.sh --self-test` — mirroring the
    existing `spec-guard` step that runs `check-ci-gate.sh --self-test`
    — anchored by a stable step name; then write the AC-016 structural
    pin test in `tests/ci_gate_completeness.rs` asserting (a) that step
    exists in the `spec-guard` job by name, and (b) its `run:` line is
    byte-identical to the pinned invocation. Without this step and its
    pin, `EXPECTED_MUTANTS_AGG_FIXTURES` would be a self-test suite
    nobody runs in CI — the exact failure AC-016 exists to prevent.
18. [ ] Write the 6 structural-peer pins (AC-009, AC-017 through AC-021)
    against `tests/common/wf.rs`'s existing generic accessors (byte-pin
    the `run:` line, the `env:` key set, the invocation, the
    node-property scan, the per-step `if:` values, AND — for AC-009 —
    assert the new `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS` constant
    (containing exactly `("mutants-aggregate", "always()")`) is disjoint
    from `SKIP_TOLERANT_NEEDS_MEMBERS`, from
    `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS` keys, and from
    `check-ci-gate.sh --print-allowed-skips`'s reported set, and that
    every pinned `if:` value in the list is the exact tautology
    `always()`) — confirm zero new `wf.rs` code is needed
    (`architecture-delta.md §6.3`).
19. [ ] Write the 7 env-wiring byte-VALUE pins (AC-010, AC-015, AC-026
    through AC-030) — all via the existing generic byte-exact env-child-
    value technique, zero new `wf.rs` code.
20. [ ] Retarget `ci-gate.needs` (AC-032): change `mutants` ->
    `mutants-aggregate`, update `PINNED_GATE_NEEDS_LINE` AND
    `test_ci_gate_needs_exactly_the_required_jobs`'s expected set in the
    SAME commit. Add `mutants`/`mutants-plan` to
    `PINNED_GATE_EXCLUDED_JOBS`.
21. [ ] Empty the skip-tolerant surface (AC-011/AC-012): `ALLOWED_SKIPS`
    -> `()`, `SKIP_TOLERANT_NEEDS_MEMBERS` -> `&[]`,
    `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS` -> `&[]`; add the
    `is_allowed_skip`/`print_allowed_skips` empty-array guards (return 1
    vs. return 0 — get this asymmetry right, see architecture-delta.md
    §6.1's explicit warning); repurpose Fixtures 4/5/12/13, add new
    Fixture 14.
22. [ ] Write the two runtime-hardening-parity tests (AC-024, AC-025)
    confirming both gate scripts source `scripts/lib/trusted-jq.sh` and
    contain no bare decision-path `jq` call.
23. [ ] Create `.github/workflows/mutants-nightly.yml` (separate file,
    `schedule:` + `workflow_dispatch:`, modeled on `e2e.yml`'s existing
    pattern) — write the regression test confirming it declares no job
    named `ci-gate` (AC-034). **Shard-count note: the nightly full-scope
    run uses `strategy.matrix.shard: N=16` (`shard: [0..15]`,
    `--shard ${{ matrix.shard }}/16`), NOT `N=8`** — per
    `ci-yml-design.md` § `mutants-full` job (same three anchors as
    AC-034's citation above), the full-scope nightly run doubles
    the per-PR shard count because it examines the whole tree
    (`examine_globs`), not just an in-diff subset. Do not copy the
    per-PR `mutants` job's `N=8`/`k/8` shape verbatim onto
    `mutants-nightly.yml`'s shard matrix.
24. [ ] Run the full transformed-assert suite (architecture-delta.md
    §6.2 items 6-9) confirming emptied skip-tolerance doesn't turn CI red
    on a correct design.
25. [ ] Update `EXPECTED_GUARD_TEST_COUNT` to `65`, `EXPECTED_FIXTURES`
    to `14`, add and compute `EXPECTED_MUTANTS_AGG_FIXTURES` (>=12,
    mechanically counted — AC-031), confirm `EXPECTED_JQ_TRUST_CHECKS`
    stays `17`.
26. [ ] **LOW F4 doc-fix cleanup tasks (non-blocking, carried forward
    from the F2 gate, DEC-349) — land in the SAME PR, not deferred:**
    - [ ] §5A honest-bound rewrite: propagate the round-9 circular-
      reasoning-closure fix (the `MUTANT_COUNT`/`OVERALL_DIFF_LINES`/
      `PLAN_RESULT` byte-VALUE pins, AC-028/029/030) into `verification-
      delta.md`'s §5A common-mode-residual write-up, which still frames
      the mutants-plan-tier justification in its pre-round-9 form.
    - [ ] Frontmatter revision-note consolidation: the four F2 spec
      documents' `revision_note:` frontmatter fields have each grown to
      a full 9-round adversarial history inline; consolidate each into a
      terser "current state + pointer to full history" form now that F2
      is gated and approved, so future readers aren't forced through the
      entire round-by-round narrative to find the operative statement.
    - [ ] `examine_globs`-narrowing-vs-nightly-backstop clarification:
      clarify in `docs/specs/cargo-mutants-policy.md` (and/or
      `verification-delta.md` note 6) that `scripts/mutants-aggregate.sh`
      is bash, outside `.cargo/mutants.toml`'s `examine_globs` Rust
      scope, and that this is DISTINCT from the nightly full-scope run's
      relationship to `examine_globs` (which DOES apply to the nightly
      job's own `cargo mutants` invocation) — the two "full scope" ideas
      are easy to conflate and should be stated side-by-side, not left
      implicit across two documents.
    - [ ] Bare-vs-braced `if: always()` style note: add an explicit code
      comment (or `ci.yml` inline note) at every `if: always()`
      occurrence introduced by this story stating it must be written
      BARE (`if: always()`), never braced (`if: ${{ always() }}`) like
      `ci-gate`'s own style — per `mutants-sharding-invariants.md`'s
      documented footgun (INV-ESCALATE Residual Risk 3) — do not "fix"
      this stylistic inconsistency to match `ci-gate`, it is deliberate.
27. [ ] Add a CHANGELOG entry under `[Unreleased] > Changed` describing
    the sharded mutation-testing CI gate (8-shard matrix, pooled
    kill-rate, escape hatch, nightly full run), before creating the PR.
28. [ ] Update STATE.md (state-manager, not this story's implementer).
29. [ ] Verify Red Gate (all new `#[test]` functions — including the
    AC-009 and AC-016 tests added by Tasks 17/18 this pass — all new
    bash fixtures, and the F2-specified assertion/fixture rewrites for
    the 9 modified-in-place tests fail before the corresponding
    implementation exists). **Clarification (F-L-004, round 8):** this
    "fail before implementation exists" framing is precise for behavioral
    tests, but imprecise for the ~12 STRUCTURAL/env-wiring pins (AC-009,
    AC-010, AC-015, AC-017 through AC-021, AC-026 through AC-030) — those
    are RED-proven against a mutated/untracked copy of `ci.yml` (inserting
    the exact defect the pin exists to catch, e.g. a smuggled `env:` key
    or a re-quoted `if:` value), the same established `ci-gate` guard-test
    pattern documented in CLAUDE.md's CI-Gate history, NOT proven by mere
    pre-implementation absence of the pinned job/step (which does not yet
    exist to mutate at the moment the test is written). Confirm each such
    pin's RED proof was actually run against a deliberately-mutated `ci.yml`
    fixture, not skipped as "obviously red because the job doesn't exist yet."
30. [ ] Refactor.

## Previous Story Intelligence

N/A — first (and only) story in the `MUTANTS-CI-SHARDING-1` epic; no
completed cycle-006 stories exist yet. Cross-reference for the
implementer: the `MUTATION-CI-TIMEOUT` policy (2026-06-28,
`docs/specs/cargo-mutants-policy.md`) is the closest prior precedent for
a policy-doc-only-governed CI change with no PRD BC — read its
`Timeout Parameters`/`Schema-Drift and False-Green Guards` sections
first, since this story's INV-AGG sub-invariants 1-7 are carried forward
VERBATIM from that single-job design's own `Check kill rate` step, just
evaluated per-shard-file before summing rather than once per run. The
`ci-gate` job's own 20+-round adversarial-hardening history (CLAUDE.md's
"CI Gate — SCOPE SUMMARY" section) is the direct structural template
`architecture-delta.md §6.8` mirrors onto `mutants-aggregate` — read that
CLAUDE.md section (M2-i/M2-o/M2-q/AC-001/AC-006/AC-008 in particular)
before implementing AC-017 through AC-021, since those ACs are literal
analogs of specific, named `ci-gate` protections, not novel designs.

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|---|---|---|
| `mutants-aggregate` NEVER reports `skipped` to GitHub Actions — always resolves internally to success or failure | architecture-delta §2, §6.4 | AC-011 (skip-tolerant surface consistently empty), `if: always()` on the job |
| Every new job's step-level `if: always()` is written BARE, never braced `${{ always() }}` | mutants-sharding-invariants.md, INV-ESCALATE Residual Risk 3 | Task 26's bare-vs-braced style note; AC-021's byte-VALUE pin literally asserts the bare plain-scalar form |
| New required jobs are wired via `ci-gate.needs` only, never directly into branch protection | CLAUDE.md DEC-096/DEC-097 | AC-032; `mutants`/`mutants-plan` admitted only via `PINNED_GATE_EXCLUDED_JOBS` |
| Exact-equality (not directional `>=`) on the `MUTANT_COUNT` reconciliation | mutants-sharding-invariants.md round-5 callout | AC-008, AC-022 |
| `scripts/mutants-aggregate.sh`'s aggregation logic MUST be an invokable script with `--self-test`, never inline `ci.yml` `run:` text | architecture-delta §1 Extraction Precondition (BLOCKING) | Task 2; every INV-AGG/INV-COMPLETE guard test is a `#[cfg(unix)]` subprocess proof against the real file |
| Both `check-ci-gate.sh` and `mutants-aggregate.sh` source ONE shared `scripts/lib/trusted-jq.sh`, never independently-maintained copies | architecture-delta §6.11 | AC-024; a future jq-trust fix landing in one script only would fail AC-024 |
| `cargo-mutants@27.1.0` exact pin, byte-identical across `mutants-plan`/`mutants`/`mutants-nightly.yml :: mutants-full` | architecture-delta §8 | Code-review-time obligation (no structural Rust-side pin exists for this — consistent with the `--timeout 240`/`ESCALATION_THRESHOLD=120` precedent) |
| Zero-warnings policy | CLAUDE.md | `cargo clippy -- -D warnings` |
| No lint suppression without refactoring | CLAUDE.md | Code review |

## Forbidden Dependencies

- **`mutants-aggregate`'s `taiki-e/install-action` step for `cargo-mutants`
  MUST be omitted entirely** — the job only runs `jq`/bash over
  already-produced `outcomes.json` files; installing `cargo-mutants` on
  this job wastes a download and is a build-time signal something is
  architecturally wrong (this job should never invoke `cargo mutants`
  itself).
- **`scripts/mutants-aggregate.sh` MUST NOT duplicate `resolve_trusted_jq`/
  `is_trusted_jq_dir`/`trusted_jq_dirs_for`** — these MUST be sourced from
  `scripts/lib/trusted-jq.sh`, never copy-pasted or re-implemented. If
  this module gains its own independent jq-trust implementation, the
  build/test MUST fail (AC-024 exists to enforce this).
- **`tests/common/wf.rs` MUST NOT gain new code for this story** — every
  structural pin (AC-005, AC-009, AC-010, AC-015, AC-017 through AC-021,
  AC-026 through AC-030) reuses existing generic accessors
  (`extract_and_normalize_if_expr`, `job_level_nested_sequence_items`,
  the byte-exact env-child-value technique, the step-name-anchored
  `run:`-line extractor). If implementation requires new `wf.rs` code,
  STOP and escalate — this was independently verified zero-change in F2
  (`architecture-delta.md §6.3`) and a new-code requirement signals a
  design drift from the approved F2 spec.
- **`.cargo/mutants.toml`'s `examine_globs` MUST NOT be modified by this
  story** — `scripts/mutants-aggregate.sh` is bash, outside the Rust
  `examine_globs` scope; its correctness is guarded by the behavioral RED
  proofs in `tests/ci_gate_completeness.rs`, not by `cargo-mutants`
  itself (verification-delta.md note 6).

## Library & Framework Requirements

| Tool | Version | Purpose |
|---|---|---|
| `cargo-mutants` | `27.1.0` (exact pin, up from the looser `@27` major-only form) | Mutation testing binary, installed on `mutants-plan` and the `mutants` shard matrix only |
| `taiki-e/install-action` | existing pinned SHA, unchanged | Installs `cargo-mutants@27.1.0` |
| `actions/upload-artifact` / `actions/download-artifact` | existing pinned versions, unchanged | `mutants-diff-file` (one upload, 8 downloads), shard status sentinels, shard outcomes.json |
| `jq` | system-provided, resolved via `resolve_trusted_jq` (never bare) | JSON parsing in both `check-ci-gate.sh` and `mutants-aggregate.sh` |
| `saphyr-parser` | `=0.0.11` (existing exact pin, `[dev-dependencies]` only) | `tests/common/wf.rs`'s parsed-YAML-tree structural assertions — no version change needed by this story |

No new external dependency is introduced by this story (the two new
`.sh` files use only bash/jq, already-present tooling).

## File Structure Requirements

| File | Action | Purpose |
|---|---|---|
| `.github/workflows/ci.yml` | MODIFY | New `mutants-plan` job; `mutants` job converted to 8-shard matrix; new `mutants-aggregate` job; `ci-gate.needs` retarget (ONE element) |
| `.github/workflows/mutants-nightly.yml` | CREATE | Advisory full-scope scheduled workflow, `schedule:` + `workflow_dispatch:`, modeled on `e2e.yml` |
| `scripts/mutants-aggregate.sh` | CREATE | Extracted aggregation logic (INV-AGG/INV-COMPLETE/INV-ESCALATE decision code), `--self-test` mode |
| `scripts/lib/trusted-jq.sh` | CREATE | Shared jq-trust helper, extracted from `check-ci-gate.sh` |
| `scripts/check-ci-gate.sh` | MODIFY | Source the new shared lib; empty `ALLOWED_SKIPS`; `is_allowed_skip`/`print_allowed_skips` empty-array guards; repurposed/new fixtures |
| `tests/ci_gate_completeness.rs` | MODIFY | 27 new `#[test]` functions; 9 tests modified in place; constants table updates (`EXPECTED_GUARD_TEST_COUNT`, `PINNED_GATE_EXCLUDED_JOBS`, `PINNED_GATE_NEEDS_LINE`, the 7 new byte-VALUE pins, etc.) |
| `docs/specs/cargo-mutants-policy.md` | MODIFY | Activate "Future Path: Job Sharding (Path B)"; update "CI Gate: Required Check"; new "Escape Hatch" + "Scheduled Full Run" sections; update "CI Integration"/"Local Invocation"; transcribe invariants; one new `## Changelog` row |
| `CHANGELOG.md` | MODIFY | `[Unreleased] > Changed` entry per Task 27 |

**Files NOT to touch:** `tests/common/wf.rs` (zero changes required, see
Forbidden Dependencies), `.cargo/mutants.toml` (`examine_globs` unchanged,
see Forbidden Dependencies), any `src/` file (this is CI/doc-only — F4
Blocking Precondition 3's scratch-run branch happens on a throwaway
scratch branch/diff, not committed to this story's own PR).

## Out of Scope

- Closing the §5A common-mode shared-`mutants-diff-file`-corruption
  residual — accepted, documented, backstopped only by the nightly full
  run; explicitly flagged for F5/F6 re-examination, not this story.
- Closing the `uses:`-VALUES / passwordless-sudo residual on
  `mutants-aggregate`'s pre-eval-step `uses:` calls (harden-runner,
  checkout, download-artifact ×2) — carried forward as an accepted
  residual identical in kind to `ci-gate`'s own documented residual
  (§6.8/§6.11).
- Tightening the `cargo-mutants@27.1.0` version pin beyond exact-match
  (e.g. lockfile/hash pinning) — out of scope for this cycle.
- Any product-facing (`src/`) behavior change — this is CI/CD
  infrastructure only.
- Flipping `strict: true` on branch-protection required-status-checks
  (the separate, human-sign-off-gated `strict: false` note in CLAUDE.md)
  — unrelated to this story, not touched.
- A GitHub App check-run "neutral" status for escalation — considered and
  rejected at F2 (INV-ESCALATE's crux problem write-up); escalation is
  encoded as an ordinary `failure`, not attempted as a new status type.
- **F5 hand-off note — INV-ESCALATE Residual Risk 2 (shard-matrix `if:`
  string-comparison footgun) is deferred to F5 scoped adversarial review,
  not F3-structurally-pinned here.** The `mutants` shard job's `if:`
  guard (`github.event_name == 'pull_request' && needs.mutants-plan.
  outputs.escalated != 'true'`) MUST use this exact, explicit `!= 'true'`
  string comparison — never a bare-truthy form (e.g. `if [ "$ESCALATED" ]`
  or an equivalent bare-truthy GHA expression), because in GitHub Actions
  expression semantics the STRING `'false'` is itself truthy, so a
  bare-truthy check would fail to short-circuit the shard matrix even
  when `escalated` correctly resolves to the literal string `'false'`.
  This story's VP-MUTANTS-SHARD-003 RED proof (per `verification-
  delta.md`) exercises this exact mutant class at the AGGREGATOR's Step-1
  escalation check, but the SAME footgun shape also applies to the shard
  MATRIX's own gating `if:` — F3 does not add a dedicated structural pin
  for the shard-matrix `if:` value beyond AC-009's disjointness check, so
  this residual is explicitly carried forward onto F5's scoped
  adversarial-review radar rather than assumed closed by this story.
  Keeping this note here ensures F5 does not lose the thread on a footgun
  this story's own design docs (`mutants-sharding-invariants.md`,
  INV-ESCALATE Residual Risk 2) already flagged.
- **F5 hand-off note (added Phase F3 round 9) — VP-MUTANTS-SHARD-006's
  bash-subprocess RED proof cannot catch a `.outcome`->`.conclusion`
  swap in the `mutants` shard job's sentinel-writing step (Task 9),
  inherited F2/DEC-349 residual, not fixed here.** AC-006's RED proof
  (Task 10, VP-006) constructs its fixtures directly as bash-subprocess
  proofs against `scripts/mutants-aggregate.sh` — it exercises the
  AGGREGATOR's interpretation of a sentinel file's `run_outcome`/
  `has_outcomes` fields, but it does not, and cannot, exercise whether the
  `mutants` shard job's own sentinel-WRITING step in `ci.yml` (Task 9)
  actually captures `steps.run-mutants.outcome` (which survives
  `continue-on-error: true` truthfully) as opposed to
  `steps.run-mutants.conclusion` (which `continue-on-error` forces to
  `success`, silently reopening CRIT-1 — AC-006's own body text already
  names this as load-bearing). A `.outcome`-for-`.conclusion` swap in that
  ONE `ci.yml` expression would make every crashed shard report
  `run_outcome=success`/`has_outcomes=false`, misrouting it to AC-007's
  legitimately-empty "contribute 0" arm instead of AC-006's fail-closed
  arm — silently reopening CRIT-1 through a single-token `ci.yml` edit no
  bash-subprocess fixture can see, because such a fixture supplies its OWN
  sentinel content and never re-derives it from a live
  `${{ steps.run-mutants.outcome }}` vs. `.conclusion` expression
  evaluation. No parsed-YAML structural byte-pin currently guards this
  expression either: Task 8's `tests/common/wf.rs`-based structural pins
  cover `steps_with_if` CARDINALITY (the 3-count `if: always()` inversion)
  but not the VALUE of the `${{ steps.run-mutants.outcome }}` expression
  feeding the sentinel-write step's body. This is an inherited F2/DEC-349
  residual — F2 did not add a dedicated structural pin for it, and this F3
  pass does not re-litigate that F2 scope decision — flagged here,
  alongside the existing INV-ESCALATE Residual Risk 2/5 hand-offs above,
  for F5 scoped adversarial review to decide whether a structural byte-pin
  on the sentinel-writing step's `${{ steps.run-mutants.outcome }}`
  expression is warranted.

## Dependency Analysis

**depends_on: []** — this is the ONLY story in this cycle (see "Why This
Is ONE Atomic Story" above); there is no other cycle-006 story to depend
on.

**blocks: []** — no other cycle-006 story exists to block. The
cross-cycle sequencing relationship to PR #778 (cycle-005) is
INTENTIONALLY NOT encoded as a `blocks:`/`depends_on:` graph edge — see
`dependency-graph-extended.md` §2 for the full justification (cycle-005
is PAUSED, not part of this cycle's graph; the relationship is a
scheduling/process note, Task 1 above, not a dependency-graph
relationship).

## Subsystem Anchor Justification

**Subsystem anchor:** `SS-09` (per CLAUDE.md's `subsystems:`-field
convention citing SS-09 as covering `.github/workflows/*.yml` +
`dependabot.yml` — see `S-641-1`'s existing frontmatter, the prior
CI-workflow story in this repo's history, which anchors the same way) —
this story's entire scope is `.github/workflows/*.yml` (two files:
`ci.yml`, new `mutants-nightly.yml`) plus `scripts/*.sh` and
`tests/ci_gate_completeness.rs`, which have no separate subsystem
registration of their own and travel with the CI-workflow subsystem by
established precedent (the same file, `S-641-1`, anchors
`tests/msrv_toolchain_guard.rs` to SS-09 on identical "no dedicated
subsystem, best-fit with the workflow files it guards" reasoning).

## Story Points and Effort

**13 story points** (large — capped at the story-writer's own 13-point
ceiling; this is the largest single unit of work this rule permits, and
this story's true scope likely exceeds a from-scratch 13-point story's
typical size, but it cannot be split further without breaking gate
consistency — see "Why This Is ONE Atomic Story"). Breakdown:

- `mutants-plan` job + `mutants` shard-matrix conversion + shared
  `DIFF_FILE`/sentinel/outcomes.json artifact wiring: 2 SP
- `scripts/mutants-aggregate.sh` extraction + INV-AGG/INV-COMPLETE core
  logic (sentinel Parts A/B/C, pooled summation, per-shard guards,
  exact-equality reconciliation both directions): 3 SP
- `scripts/lib/trusted-jq.sh` extraction + `check-ci-gate.sh` refactor +
  runtime-hardening-parity tests (AC-024/025): 1.5 SP
- INV-ESCALATE (Step 0 fail-closed allowlist + escalation short-circuit +
  `mutants-nightly.yml`): 1.5 SP
- The 6 structural-peer pins (AC-009, AC-017 through AC-021) + 7
  env-wiring byte-VALUE pins (AC-010/015/026-030) — all zero-`wf.rs`-code
  but a large number of individually-authored `#[test]` functions: 2.5 SP
- Skip-tolerant-surface emptying + the 4 transformed-in-place tests
  (§6.2 items 6-9) + Fixture repurposing/Fixture 14: 1 SP
- `ci-gate.needs` retarget + fixed-denominator counter updates +
  `docs/specs/cargo-mutants-policy.md` drafting (F4 Blocking Precondition
  5) + CHANGELOG: 1.5 SP

**Risk: CRITICAL** (module criticality CRITICAL — see the Module
Criticality Justification below). F4 Blocking Precondition 3's empirical
scratch-run is this story's dominant schedule/correctness risk: if
`--list` and pooled `--shard --sharding slice` counts do NOT reconcile
exactly on a real diff, the implementer must root-cause and fix/encode
the discrepancy BEFORE merge, which is open-ended work not fully
budgeted above. Budget schedule slack for this task specifically and do
not treat the point estimate as a hard ceiling on Task 3 alone (mirrors
`S-cycle5-mention-pure-conversion`'s own treatment of its F4-spike risk,
AC-007).

## Module Criticality Justification

**CRITICAL.** `mutants-aggregate` becomes the SOLE `ci-gate.needs` member
making the mutation-testing pass/fail decision for every PR merged to
`develop`/`main` going forward — a false-green here silently ships
un-mutation-tested code past the one CI gate that exists specifically to
catch weak test coverage. This mirrors exactly the reasoning that makes
`ci-gate` itself the single most heavily adversarially-reviewed surface
in this codebase (CLAUDE.md's 20+-round documented hardening history) —
`mutants-aggregate` is a documented STRUCTURAL PEER of `ci-gate`
(`architecture-delta.md §6.8`), inheriting the identical threat model:
any PR can edit `.github/workflows/ci.yml`, `scripts/mutants-
aggregate.sh`, and `tests/ci_gate_completeness.rs` in the same change
(the same "review scope is N files, not one" self-referential risk
CLAUDE.md's CI-Gate section already documents for `ci-gate` proper, now
extended to a fifth/sixth file by this cycle). 16 F2 adversarial passes
across 9 fix rounds found and closed one CRITICAL (all-shards-crash
false-green), two HIGH (structural-pin peer parity; the F-H1 evidence-
source-redirect false-green), and one MEDIUM (runtime jq-shim parity)
finding on this exact surface before this story was even written — the
CRITICAL classification is not precautionary, it reflects findings
already made.
