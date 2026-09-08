---
document_type: wave-schedule
level: ops
version: "1.0"
phase: phase-f3-incremental-stories
cycle: cycle-006
feature: mutants-ci-sharding
status: draft
producer: story-writer
created: 2026-09-07
timestamp: "2026-09-07T00:00:00"
inputs:
  - ".factory/cycles/cycle-006/phase-f3-stories/dependency-graph-extended.md"
traces_to: "dependency-graph-extended.md §4a"
input-hash: "e128332"
---

# F3 Wave Schedule — `mutants-ci-sharding` (cycle-006)

Wave grouping by Kahn-layering (BFS levels over the acyclic 1-node graph
proven in `dependency-graph-extended.md` §4a).

## Summary

| Metric | Value |
|--------|-------|
| Total stories (this cycle) | 1 |
| Total waves | 1 |
| Max parallelism (stories in one wave) | 1 (single story, no intra-wave parallelism possible) |
| Estimated agent spawns | 1 (one implementer dispatch for the sole story) |

---

## 1. Layering Derivation

| Round | Indegree-0 set at this round | Wave |
|---|---|---|
| 1 | {A (`mutants-ci-sharding`)} | **Wave 1** |

**Computed layering — 1 wave, trivial:** the sole story has `depends_on:
[]` and reaches indegree 0 immediately, so it occupies Wave 1 by itself.
There is no second round, no second wave, and no candidate split
considered — see the story's own "Why This Is ONE Atomic Story" section
for the exhaustive justification of why this cycle is a single story in
the first place (the matrix cannot land without the aggregator; the
aggregator cannot land without its 27 guard tests; the guard tests cannot
land without the extracted `scripts/mutants-aggregate.sh`; `ci-gate.needs`
cannot retarget without all of the above already existing).

---

## 2. File-Overlap Check

`S-cycle6-mutants-ci-sharding` touches: `.github/workflows/ci.yml`,
`.github/workflows/mutants-nightly.yml` (new), `scripts/mutants-
aggregate.sh` (new), `scripts/lib/trusted-jq.sh` (new), `scripts/check-
ci-gate.sh`, `tests/ci_gate_completeness.rs`, `docs/specs/cargo-mutants-
policy.md`, `CHANGELOG.md`.

**N/A — no second story exists in this cycle to overlap with.** This
check is retained as a section (matching the cycle-003/004/005 template
shape) purely for structural consistency; there is nothing to compute
here for a 1-story cycle. The only file-overlap question worth recording
is against OTHER concurrent cycles: cycle-005's `S-cycle5-mention-*`
stories (PAUSED, Wave 2 not yet dispatched) touch `src/adf.rs`,
`src/cli/issue/*.rs`, `src/api/jsm/requests.rs`, `src/cli/mod.rs`,
`.cargo/mutants.toml`, `tests/mention_resolution.rs`,
`tests/e2e_live.rs`, `tests/e2e_cli_surface_guard.rs`, and `CHANGELOG.md`
— **zero file overlap** with this story's footprint except `CHANGELOG.md`
(the one shared file across essentially every cycle in this repo's
history, per the established convention of each story appending its own
`[Unreleased]` line rather than editing another cycle's line). Since
cycle-005 is PAUSED at Phase F4 (not actively dispatching stories
concurrently with this cycle's F4), there is no live merge-conflict risk
today, only the trivial append-only `CHANGELOG.md` convention already in
place.

---

## Wave Plan

### Wave 1 — `S-cycle6-mutants-ci-sharding`

- **Stories:** 1, solo.
- **Points:** 13.
- **File footprint:** `.github/workflows/ci.yml`, `.github/workflows/
  mutants-nightly.yml` (new), `scripts/mutants-aggregate.sh` (new),
  `scripts/lib/trusted-jq.sh` (new), `scripts/check-ci-gate.sh`,
  `tests/ci_gate_completeness.rs`, `docs/specs/cargo-mutants-policy.md`,
  `CHANGELOG.md`.
- **Gate:** standard wave-gate (full regression on `develop` — including
  `cargo test`'s complete suite, not scoped to this story's files, since
  a CI-gate change can regress unrelated jobs; adversarial review of the
  wave diff, with special attention to the CI-Gate review-scope discipline
  CLAUDE.md already documents — this wave adds TWO more files to that
  review-scope enumeration, `scripts/mutants-aggregate.sh` and `scripts/
  lib/trusted-jq.sh`, growing it from "four" to "six" per the story's LOW
  F4 doc-fix cleanup task). This wave's gate is ALSO where the 5 F4
  Blocking Preconditions are checked as literal go/no-go criteria, not
  merely tasks completed at some point during implementation:
  1. PR #778 resolved against the OLD gate BEFORE this wave's `ci.yml`
     changes land (sequencing).
  2. `scripts/mutants-aggregate.sh` + `scripts/lib/trusted-jq.sh` exist as
     standalone, `--self-test`-capable scripts (extraction).
  3. The empirical `--list`<->pooled scratch-run reconciled exactly,
     documented in the PR (empirical premise verification).
  4. `cargo test`'s `ci_gate_completeness.rs` suite (65/65), `scripts/
     check-ci-gate.sh --self-test` (14/14 + jq-trust + print-allowed-
     skips self-tests), AND `scripts/mutants-aggregate.sh --self-test`
     (>=12/>=12) all pass locally AND in CI (full guard-test suite).
  5. `docs/specs/cargo-mutants-policy.md` updated in the SAME PR
     (policy-doc drafting) — this wave's gate explicitly checks the diff
     contains BOTH the code/test changes AND the policy-doc sections
     listed in the story's Task 5, not code alone.
  This wave's gate does NOT include a holdout-evaluation pass against
  hidden acceptance scenarios in the usual product-feature sense (see
  `wave-holdout-scenarios.md`'s own framing note — this is CI/CD
  infrastructure with no product-facing UI/API surface for a holdout
  evaluator to exercise blind; the "holdout" scenarios for this cycle are
  cross-cutting integration/regression proofs instead, run by the
  implementer/formal-verifier as part of the standard TDD+adversarial-
  review pipeline, not a separate blind-evaluator pass).
- **Sequencing note (process-level, NOT a wave-gate blocker in the usual
  sense — see `dependency-graph-extended.md` §2):** this wave is intended
  to land to `develop` BEFORE PR #778 (cycle-005) rebases onto the new
  sharded gate (F4 Blocking Precondition 1). Because this story is
  CI/doc-only (`MUTANT_COUNT == 0` on its own diff), it is
  self-validating — the sharded gate exercises itself trivially (zero
  in-diff mutants reconcile with zero) on this wave's own PR, with the
  REAL, non-trivial exercise deferred to F4 Blocking Precondition 3's
  scratch run (before merge) and then to PR #778 itself (after merge, as
  the first real production-scale exercise, per `mutants-sharding-
  invariants.md`'s round-5/round-6 framing).
  **PR #778 will ESCALATE under this gate, not run pooled reconciliation,
  unless its diff is split below the 120-mutant threshold:** PR #778 has
  281 in-diff mutants — by the design's own arithmetic (8 shards x ~15
  mutants ~= 120, `ESCALATION_THRESHOLD=120`), 281 exceeds that threshold,
  so rebasing PR #778 onto this wave's new gate does NOT yield a shard-run
  pass; it yields an ordinary CI `failure` (AC-003) with the shard matrix
  skipped entirely. This wave's Blocking Precondition 1 sequencing
  therefore does not resolve to an automatic green for PR #778 — the
  human decision after this wave lands is either (a) split PR #778's diff
  below 120 in-diff mutants so it shard-runs normally, or (b) invoke the
  repo-admin branch-protection bypass with an explicit PR-description
  acknowledgment of the escalation.

---

## 3. Pipeline Overlap Plan

**N/A — single story, single wave, no intra-cycle overlap opportunity.**
The one legitimate CROSS-cycle overlap already in place (not created by
this document): cycle-005's Wave 2 (`S-cycle5-mention-resolution-wiring`)
remains PAUSED regardless of this wave's progress — it is blocked on PR
#778's merge, which is itself blocked on THIS wave landing first (F4
Blocking Precondition 1). There is no useful parallel activity to stage
between this wave and cycle-005's paused work; the two cycles are
strictly sequenced by the sequencing note above, not overlapped.

---

## 4. Critical Path

A single node, trivially the entire critical path:

```
S-cycle6-mutants-ci-sharding (Wave 1, 13 pts)
```

**Critical path length: 1 story / 1 wave, 13 points.** This IS the
cycle's total point count.

---

## 5. Total Feature Points

| Story | Wave | Points |
|---|---|---|
| `S-cycle6-mutants-ci-sharding` | 1 | 13 |
| **Total** | — | **13** |

---

## 6. Conflict-Report Summary

No existing `STORY-INDEX.md` story shares a `depends_on:`/`blocks:` edge
with the new story (per `dependency-graph-extended.md` §2), and no
in-progress story (checked against `STORY-INDEX.md`'s status column at
authoring time) touches `.github/workflows/ci.yml`, `.github/workflows/
mutants-nightly.yml`, `scripts/mutants-aggregate.sh`, `scripts/lib/
trusted-jq.sh`, `scripts/check-ci-gate.sh`, or `tests/ci_gate_
completeness.rs`. No cycle-006 stories were previously registered in
`STORY-INDEX.md` before this F3 pass — no reconciliation with an
earlier-drafted cycle-006 story set is needed. No blocking conflict
identified. The one cross-cycle scheduling relationship (PR #778,
cycle-005) is a process-level sequencing note, not a graph-level or
file-level conflict — see §2 and §3 above.
