---
document_type: blocking-issues-resolved
level: ops
version: "1.0"
status: archive
producer: state-manager
timestamp: 2026-09-09T06:30:00Z
cycle: "cycle-006"
inputs: [STATE.md]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Blocking Issues Resolved — cycle-006 (mutants-ci-sharding)

<!-- Closed Blocking Issues are moved here from STATE.md's Blocking Issues table when resolved.
     Append-only; maintain chronological order by resolution burst. -->

## Resolved at Burst 11 (2026-09-08/09) — Step-4.5 comprehensive byte-pin closure

All three findings below are resolved by the SAME fix: the round-4 comprehensive byte-pin closure
(fixing round-4 adversarial finding J-CRITICAL, part of the 7-trio Step-4.5 convergence arc that
reached 3-consecutive-clean at round 7, passes S/T/U). Feature branch `ci/mutants-ci-sharding`,
HEAD advanced `ceeedbf1`→`8f46648f` (13 local commits, test/script/doc only — the tracked
`.github/workflows/ci.yml` is byte-for-byte unchanged from `ceeedbf1`). Branch **not yet pushed to
`origin`** as of this resolution record — origin remains at `ceeedbf1`; pushing is part of the
pending PR-assembly step.

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| F-PI-CRITICAL-001 | The `mutants-plan` compute-step content pin (`tests/ci_gate_completeness.rs::test_mutants_plan_compute_step_content_is_pinned`) did an ordered-substring search (`plan_block[last_offset..].find(fragment)`) over `extract_job_block`'s RAW, comment-including block text (`tests/common/yaml.rs`) rather than a parsed, comment-stripped `run:` scalar. A `ci.yml` diff that comments out the real script — while leaving the pinned fragments present as comment text — plus real `echo mutant_count=N`/`escalated=false` lines, could forge the required mutation gate with zero code execution (CWE-358, improperly-implemented security check). Originally opened at Burst 10 (2026-09-08) as a re-verified reopening of Burst 9's F-PF-HIGH-001 "CLOSED" bookkeeping — the round-2 fix (commits `1bc13cc7`/`ceeedbf1`) closed a narrower gap but left this class of defeat open, and the round-3 (J-CRITICAL) and earlier round-3 (G-HIGH) findings each independently reproduced a member of the same defeat class before the comprehensive fix below finally closed it. | CRITICAL | F4 (Step-4.5 per-story adversarial convergence) | orchestrator (fix) / state-manager (recorded) | **RESOLVED (Burst 11).** Every run-bearing step across all three mutation jobs (`mutants-plan` "Compute diff and mutation plan", shard "run-mutants", shard "Write shard status sentinel", `mutants-aggregate` "Evaluate sharded mutation gate") is now exact-byte-pinned via a new `extract_and_normalize_run_scalar_for_step` helper that parses a `Value::Scalar` (rejecting anchor/tag/non-Literal style) rather than substring-searching raw comment-including text — mirroring the sentinel test's pre-existing robust idiom (`value_of("run")` → `Value::Scalar` → `.contains(...)`), now applied uniformly. Fix landed as round-4's response to finding J-CRITICAL; verified via the full 7-trio Step-4.5 convergence arc (rounds 4-7) with zero further defeats found against the same class. Verified green at HEAD `8f46648f`: `cargo test --test ci_gate_completeness` 101 passed, full `cargo test` green, clippy/fmt/actionlint clean. |
| F-PF-HIGH-001 | The `mutants-plan` compute step (mutation-plan / diff computation) was found unpinned at Burst 9, permitting a gate-bypass; a round-2 fix was applied (commits `1bc13cc7`/`ceeedbf1`) but Burst 10 independently verified that fix was DEFEATABLE (see F-PI-CRITICAL-001 above, same underlying defeat class). | HIGH | F4 (Step-4.5 per-story adversarial convergence) | orchestrator (fix) / state-manager (recorded) | **RESOLVED (Burst 11).** Superseded by, and closed together with, F-PI-CRITICAL-001's comprehensive byte-pin fix above — the same `extract_and_normalize_run_scalar_for_step` closure covers the `mutants-plan` compute step this finding originally named. No separate fix was needed once the comprehensive pin landed. |
| F-PG-MED-001 | The `mutants` (shard) job's `run-mutants` step was excluded from the always-run job/step key-set pins (`PINNED_GATE_EXCLUDED_JOBS` explicitly listed `mutants` and `mutants-plan`; no `PINNED_MUTANTS_*` step-key-set existed for the shard job), so its step list was open. A `ci.yml` diff could append a step after `run-mutants` that rewrites `mutants.out/outcomes.json` (e.g. zeroing `missed`/`timeout`, inflating `caught`) before the per-shard artifact upload, forging a 100% kill rate for that shard while preserving per-shard totals so the pooled sum-not-average reconciliation in `mutants-aggregate` still passes. Opened at Burst 10 (2026-09-08). | MED | F4 (Step-4.5 per-story adversarial convergence) | orchestrator (fix) / state-manager (recorded) | **RESOLVED (Burst 11).** Closed in the same round-4 comprehensive pass: the shard job's "Write shard status sentinel" step's `run:` scalar is now byte-pinned (via the same `extract_and_normalize_run_scalar_for_step` mechanism) and the shard upload step's `with.path`/`with.name` are byte-pinned, closing the open step-list gap between `run-mutants` and the artifact upload. Verified via rounds 5-7 with no further defeats found against this class. |

**Full convergence arc (for context, not part of the resolution itself):** 7 adversarial trios
(21 fresh-context passes) + 6 fix rounds ran this session against `ci/mutants-ci-sharding`:
Round 1 (A/B/C @ `b935747f`) NOT CLEAN — 1 HIGH + 4 MED + 1 LOW (a distinct, non-CWE-358 shard
run-mutants trailing-append launder plus policy-doc dead-cross-ref/undocumented-algorithm gaps).
Round 2 (D/E/F @ `9857332c`) NOT CLEAN — 2 HIGH (substring-ban insufficiency; missing mandated
VP-MUTANTS-SHARD-024/025 guard tests). Round 3 (G/H/I @ `a03d3b1a`) NOT CLEAN — 1 HIGH (sentinel
step unpinned, same launder class) + 2 MED. Round 4 (J/K/L @ `d840ece5`) NOT CLEAN — **J-CRITICAL**
(the comprehensive-fix trigger described above) + 1 LOW. Round 5 (M/N/O @ `ce4d37e5`) NOT CLEAN —
1 MED (stale test-count ledger) + 2 LOW. Round 6 (P/Q/R @ `e506bcbb`) — P/Q CLEAN, R 2 LOW. Round 7
(S/T/U @ `8f46648f`) — **ALL THREE CLEAN, streak 3/3, CONVERGED.** Full narrative: `STATE.md`
Session Resume Checkpoint (v3.89) and `cycles/cycle-006/session-checkpoints.md` v3.88 archive entry
("What actually happened next").

## Resolved at Burst 13 (2026-09-09) — cycle-close resolutions (NOT the S-7.02 deferrals)

These two items were tracked as follow-up items (not table-listed Blocking Issues, which stayed
empty from Burst 11 onward) and were explicitly RESOLVED/CLOSED at the cycle-006 F7 close-out
(DEC-351), distinct from the 6 items the human chose to record as justified deferrals in that same
burst (see `STATE.md` Drift / Standing Items for the deferral table).

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| F-PE-MED-001 | Precondition-3's M-1 empirical `--list`↔pooled partition-proof evidence (N=1532 exact; `--in-diff` mirror N=18 exact) had been verified but not yet persisted into a durable, standalone factory artifact — carried forward from Burst 9 through Burst 12 as a NOT-actioned follow-up. | MED | F4 (Step-4.5 per-story adversarial convergence, carried to cycle-close) | orchestrator (evidence capture) / state-manager (recorded) | **CLOSED (Burst 13).** The M-1 evidence is now captured durably in PR #791's merged body on `develop` (permanent GitHub PR record) — the standalone-durable-artifact concern this item tracked is satisfied by that record. No further action needed; a separate `.factory/`-local artifact was judged unnecessary given the PR body's permanence. |
| R-F2 | The story `S-cycle6-mutants-ci-sharding.md`'s planning-stage estimate for `EXPECTED_GUARD_TEST_COUNT` (38→65, AC-031) diverged from the shipped value (75) discovered during F4 implementation. Flagged at Burst 11 as a planning-estimate truing-up item pending cycle-close disposition. | LOW (planning-estimate, not a defect) | F4 (Step-4.5 per-story adversarial convergence, carried to cycle-close) | state-manager (disposition recorded) | **CLOSED, not a defect (Burst 13).** AC-031 explicitly mandated F4 re-verification of this count — the shipped value 75 is the reconciled, correct truth; the original 65 was a planning-stage estimate, not a commitment the implementation was required to match exactly. No fix needed; the STORY-INDEX and story file were corrected to the shipped 75 as part of ordinary F4 delivery (see `develop` @ `a9168212`, PR #791). |

**cycle-006 F7 close-out (DEC-351):** F7 delta convergence reached a 5-dimensional PASS and the
human APPROVED closing cycle-006 with NO release cut. Full rationale: `STATE.md` Decisions Log,
`DEC-351`. This is the final resolution entry for cycle-006 — the cycle is now CLOSED.

<!-- Repeat for each archived resolution burst. Maintain chronological order. -->
