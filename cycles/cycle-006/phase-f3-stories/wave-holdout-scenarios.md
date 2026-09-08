---
document_type: wave-holdout-scenarios
phase: phase-f3-incremental-stories
cycle: cycle-006
feature: mutants-ci-sharding
wave: 1
status: draft
producer: story-writer
created: 2026-09-07
inputs:
  - ".factory/cycles/cycle-006/phase-f3-stories/S-cycle6-mutants-ci-sharding.md"
  - ".factory/cycles/cycle-006/phase-f3-stories/wave-schedule.md"
traces_to: "INV-AGG; INV-COMPLETE; INV-ESCALATE; VP-MUTANTS-SHARD-001..030"
input-hash: "7f7db62"
---

# Wave 1 Holdout Scenarios — `S-cycle6-mutants-ci-sharding`

## Framing Note (read before the scenarios)

This is CI/CD infrastructure with no product-facing UI or API surface —
there is no `jr` command a holdout-evaluator agent could drive blind
against hidden acceptance criteria, the way product-feature cycles
(cycle-003 through cycle-005) use a holdout-evaluator subagent with
information asymmetry. The equivalent obligation for THIS cycle is
**cross-cutting integration and regression proof**: does the new
`mutants-plan` -> 8-shard `mutants` matrix -> `mutants-aggregate`
pipeline behave correctly as a WHOLE, end-to-end system (not just as 30
individually-passing unit-level VP tests), and does it leave every
OTHER already-hardened piece of `ci-gate`'s decision machinery
untouched? These scenarios are run by the implementer and formal-
verifier as part of the standard TDD + adversarial-review pipeline (F4,
F5/F6), not by a separate blind holdout-evaluator subagent — but they
are written here, at F3, with the SAME rigor and MUST-PASS/SHOULD-PASS
discipline the product-feature holdout-scenario documents use, per the
task brief's explicit request for "cross-cutting integration +
regression" coverage.

---

## 1. Cross-Cutting Integration Scenarios

### H-W1-INT-001 — A PR with real surviving mutants goes RED through the full sharded gate

**Setup:** Construct (or use a real scratch branch, reusing F4 Blocking
Precondition 3's own scratch-run artifact where possible) a diff whose
in-diff mutant set is non-trivial (well under the 120-mutant escalation
threshold, say 20-40 mutants) and DELIBERATELY includes at least one
genuine, uncaught (`missed`) mutant such that the pooled kill rate across
all 8 shards falls below 90%. Run the full pipeline: `mutants-plan` ->
8-shard `mutants` matrix -> `mutants-aggregate` -> `ci-gate`.

**Expectation:** `mutants-aggregate` exits 1 with a message naming the
computed pooled kill rate and the 90% threshold; `ci-gate` FAILS
(required-check red); the PR cannot merge through the normal path. This
is the single most important end-to-end proof this wave delivers — every
one of the 30 VP-level unit tests can pass while this end-to-end
behavior is broken by a wiring defect between the shard matrix's
artifact uploads and the aggregator's downloads, which no per-VP test in
isolation would catch.

**MUST-PASS.**

### H-W1-INT-002 — An all-shards-crash scenario fails closed end-to-end

**Setup:** Simulate (via a deliberately broken `cargo mutants` invocation
on a scratch branch, or a controlled fault injection in a test harness
run of the REAL `mutants-aggregate.sh`, not a Rust-side re-implementation)
every one of the 8 shards crashing under `continue-on-error: true` — the
job-level step still "succeeds" per GitHub Actions' own reporting
(`continue-on-error` masks the step conclusion), but `steps.run-mutants.
outcome` records `failure` for all 8, and no `outcomes.json` exists for
any shard.

**Expectation:** `mutants-aggregate` FAILS the aggregation (never the
pre-cycle-006 false-green "0 artifacts -> pass" branch, CRIT-1) —
end-to-end, through the real GitHub Actions artifact-upload/-download
mechanism, not just AC-006's isolated bash-subprocess unit proof. This is
the end-to-end analog of AC-006/VP-MUTANTS-SHARD-006; it is listed
separately here because CRIT-1's original defect was specifically an
ARTIFACT-COUNT-based false-green that only manifests when the real
upload/download machinery is exercised, not when a synthetic sentinel
tree is fed directly to the extracted script (which AC-006's own unit
test does, correctly, as its FIRST line of defense — this scenario is
the SECOND line, proving the real CI wiring around it is also correct).

**MUST-PASS.**

### H-W1-INT-003 — A clean, high-kill-rate PR passes end-to-end

**Setup:** The mirror image of H-W1-INT-001: a non-trivial, non-zero
in-diff mutant set (well under 120) where every shard's mutants are
either caught or unviable, yielding a pooled kill rate >= 90%. This is
also the vehicle for F4 Blocking Precondition 3's own empirical
verification task (AC-035) — the SAME scratch run that confirms `--list`
<-> pooled reconciliation should also be constructed to have a genuinely
healthy kill rate, so this scenario and that precondition can share one
scratch-run artifact rather than requiring two separate runs.

**Expectation:** `mutants-plan` computes the diff and pre-count; all 8
shards run and upload sentinels + outcomes; `mutants-aggregate` reconciles
`total_scored == MUTANT_COUNT` exactly, computes a pooled kill rate >=
90%, and exits 0 with a "gate passed" message; `ci-gate` PASSES.

**MUST-PASS.**

### H-W1-INT-004 — The escape hatch fires correctly for an oversized diff

**Setup:** A diff whose `mutants-plan` pre-count exceeds 120 mutants
(construct via a synthetic large diff on a scratch branch, or a targeted
`.cargo/mutants.toml` `examine_globs` widening on a throwaway branch if a
naturally-occurring >120-mutant diff isn't readily available — the point
is exercising `mutants-plan`'s real `--list`-based pre-count crossing the
real threshold, not a hand-set `ESCALATED=true` env override, which would
only prove the DOWNSTREAM half of this scenario).

**Expectation:** `mutants-plan` sets `escalated=true` and does NOT itself
fail; the `mutants` shard matrix is SKIPPED entirely (`if:` condition
correctly evaluates false — zero CI minutes spent on shards whose result
will be discarded); `mutants-aggregate` (`if: always()`, so it runs
despite the shard matrix being skipped) detects `ESCALATED == 'true'` at
its Step-1 escalation check (after the Step -1/0/0.5 preflight), before
any shard-artifact/sentinel inspection, and exits 1 with the two-path
remediation message (split the PR / admin bypass with PR-description
acknowledgment); `ci-gate` FAILS as an ordinary required-check failure — critically, NOT as a
`skipped` check (verify this by inspecting the actual GitHub Actions run
UI/API for the job's reported `conclusion`, not just the aggregator
script's local exit code — the end-to-end proof must confirm GitHub
Actions itself reports `failure`, not `skipped`, for `mutants-aggregate`).

**MUST-PASS.**

### H-W1-INT-005 — The nightly full-run workflow is genuinely isolated from `ci-gate`

**Setup:** Manually trigger `mutants-nightly.yml` via `workflow_dispatch`
(or wait for/simulate its `schedule:` trigger) on a branch with the new
workflow file present, independent of any open PR.

**Expectation:** The nightly workflow runs its `mutants-full` job (full
`examine_globs` scope, no `--in-diff`) and `mutants-nightly-report` job
to completion, entirely independent of `ci-gate` — no PR's required-check
status is affected by this run, `ci-gate`'s own job list on any
concurrently-open PR shows no new/renamed job, and
`test_no_sibling_workflow_declares_a_job_named_ci_gate` (a Rust-side
structural guard, but exercised here against the REAL, dispatched
workflow run rather than only the static YAML) is confirmed to hold in
practice — the nightly run produces its own separate check-run entries
under its own job names, never colliding with or blocking `ci-gate`.

**SHOULD-PASS** (downgraded from MUST-PASS only because a full nightly
run's wall-clock cost — the entire, unscoped `examine_globs` set — makes
it impractical to run repeatedly during F4 iteration; the implementer
should exercise this AT LEAST ONCE via `workflow_dispatch` before this
wave's gate closes, not skip it entirely).

### H-W1-INT-006 — A legitimately non-success shard with valid `outcomes.json` is FOLDED, not false-RED-blocked

**Setup:** Construct a scratch-run diff where at least one shard's
`cargo mutants --shard k/8 --sharding slice --baseline skip --timeout
240` invocation is heavily unviable (e.g. every mutant in that shard's
slice is unviable), causing cargo-mutants' own process exit code to be
non-zero (`steps.run-mutants.outcome != success`) while the shard's
`outcomes.json` is still written out completely and validly and its
sentinel correctly reports `has_outcomes=true`. Run the full pipeline
end-to-end.

**Expectation:** `mutants-aggregate` FOLDS that shard's counts into the
pooled sums per AC-036's fold-wins rule (`has_outcomes == true` always
wins over `run_outcome`) rather than treating it as a harness crash
(AC-006) and excluding it; the pooled reconciliation
(`total_scored == MUTANT_COUNT`) succeeds; the PR is not false-RED-
blocked by a shard that was genuinely healthy but merely reported a
non-zero cargo-mutants exit code. This is the real production risk
`mutants-sharding-invariants.md`'s "Defensive cross-check" section
names — a heavily-unviable `--baseline skip` shard is a realistic, not
merely theoretical, occurrence.

**SHOULD-PASS** (this is the harder-to-construct end-to-end proof of
AC-036's fold-wins arm — the dedicated `--self-test` fixture in
`scripts/mutants-aggregate.sh` is the MUST-PASS unit-level proof; this
scenario is the end-to-end confirmation against a real, deliberately-
constructed shard, downgraded to SHOULD-PASS for the same practicality
reason as H-W1-INT-005 — reliably engineering a real heavily-unviable
shard on a scratch run is comparatively awkward, though the implementer
should attempt it at least once before this wave's gate closes).

### H-W1-INT-007 — A missing shard sentinel fails closed end-to-end (INV-COMPLETE Part B)

**Setup:** On a scratch-run pipeline, deliberately suppress ONE shard's
"Upload shard status sentinel" step (e.g., edit a throwaway copy of the
workflow on a scratch branch to skip/no-op that one step for a single
shard index, or delete that one sentinel artifact from a completed run
before `mutants-aggregate` executes). This is trivially constructible —
unlike AC-037's sentinel/data-desync arm below, it requires only ONE
artifact to be absent, not a present-but-corrupt evidence pair.

**Expectation:** `mutants-aggregate` FAILS the aggregation closed at
Step 2 (INV-COMPLETE Part B — the missing/duplicate sentinel check),
through the REAL GitHub Actions artifact-download/glob machinery, not
just AC-002/VP-MUTANTS-SHARD-002's isolated bash-subprocess unit proof.
This is the same "second line of defense" relationship H-W1-INT-002
already establishes for AC-006/CRIT-1: the unit fixture proves the
DECISION logic is correct when fed a synthetic sentinel tree; this
scenario proves the real upload/download WIRING around that decision is
also correct. `ci-gate` FAILS as an ordinary required-check failure.

**MUST-PASS.**

**Asymmetry note (deliberate, not an oversight — LOW polish item L-3;
extended Phase F3 round 10/FIX-5):** Two arms in this story's coverage
still rely on `scripts/mutants-aggregate.sh --self-test` unit fixtures
ALONE, with no dedicated end-to-end holdout scenario: AC-037's
sentinel/data-desync arm, and AC-008/AC-022/AC-023's pooled-total
<-> `MUTANT_COUNT` reconciliation exact-equality hard fail (INV-AGG
sub-invariant 8). (AC-002's missing-sentinel half was previously in
this same "unit-only" category — it is now closed end-to-end by
H-W1-INT-007 above, added this round precisely because it WAS trivially
constructible, unlike the two arms below. AC-002's DUPLICATE-sentinel
half — EC-004, the other half of INV-COMPLETE Part B — remains
unit-fixture-only for the same contrivance reason as AC-037 below:
engineering a genuine duplicate artifact upload on a real scratch run (a
re-run colliding with a stale artifact, or a name collision) is not
naturally reproducible the way suppressing one upload step is. If a
future review disagrees, the fix is a dedicated holdout scenario with a
duplicated sentinel artifact in place of a missing one — not a
re-scoping of this note.) This is intentional, for two distinct
reasons:

- **AC-037 (sentinel/data-desync):** its fail-closed behavior is already
  fully exercised by its `--self-test` fixture (a straightforward "assert
  exit 1" proof — there is no plausible "looks like it passed but the
  underlying decision was wrong" failure mode for a desync case the way
  there is for AC-036's fold-wins case). Constructing a real desync
  end-to-end (an artifact-upload race, or a deliberately-corrupted
  download) is comparatively contrived to engineer on a scratch run
  compared to both AC-036's naturally-occurring heavily-unviable-shard
  setup and this scenario's trivially-constructible missing-sentinel
  setup. If a future review disagrees with this call, the fix is
  a new H-W1-INT-008 SHOULD-PASS scenario mirroring H-W1-INT-006's
  structure with a corrupted/missing `outcomes.json` in place of the
  non-zero exit code — not a re-scoping of this note.

- **AC-008/AC-022/AC-023 (reconciliation hard fail, both directions,
  plus the completeness-over-quality proof):** a genuine end-to-end
  mismatch between `mutants-plan`'s independent `--list`-based pre-count
  and the shard matrix's pooled total is not naturally constructible on a
  real scratch run without deliberately sabotaging one side of the
  pipeline after the fact (e.g., hand-editing an uploaded
  `outcomes.json`'s counts, or hand-editing the `MUTANT_COUNT` output
  value) — an artificial mutation of CI-produced evidence, not a
  naturally-occurring shard-job condition the way a missing sentinel
  (H-W1-INT-007) or a heavily-unviable shard (H-W1-INT-006) are. F4
  Blocking Precondition 3 (AC-035, this story's own empirical
  `--list`<->pooled premise-verification gate) is the closest real-world
  proxy this story has for surfacing a genuine reconciliation drift in
  practice, and it already runs as a separate MUST-PASS process
  obligation before merge. **Scope of that proxy, precisely stated
  (FIX-E, round 12):** AC-035/Task 3 verifies the two counts reconcile EXACTLY on a
  known-nonzero diff — it exercises the reconcile-SUCCEEDS direction only
  (a PASS-direction scratch run) and does not, and cannot, exercise the
  aggregator's exit-1 hard-fail branch itself; the fail-closed behavior of
  that branch (both the under-count and over-count directions, plus the
  healthy-partial-kill-rate-doesn't-rescue-it case) is proven solely by
  the Task 12/13 `--self-test` unit fixtures (AC-008/AC-022/AC-023), not
  by AC-035's scratch run. Given that gate's existence, and given the
  reconciliation logic itself (both the under-count and over-count
  directions, plus the healthy-partial-kill-rate-doesn't-rescue-it case)
  is fully exercised by dedicated `--self-test` fixtures (Task 12/13),
  this story accepts unit-fixture-only coverage for AC-008/AC-022/AC-023
  rather than fabricating an artificial fault-injection scenario whose
  setup would not resemble any real failure mode. If a future review
  disagrees with this call, the fix is a new H-W1-INT-009 SHOULD-PASS
  scenario that hand-corrupts one shard's uploaded `outcomes.json` counts
  after upload but before `mutants-aggregate` runs — not a re-scoping of
  this note.

---

## 2. Regression Scenarios — Existing `ci-gate` Behavior Unchanged

### H-W1-REG-001 — The other 7 always-run `ci-gate.needs` jobs are byte-identical

**Setup:** Diff `ci.yml`'s `fmt`, `clippy`, `test`, `msrv`, `deny`,
`spec-guard` (minus the ONE new self-test step, AC-016), and
`check-signing-workflow-injection` job blocks between the pre-cycle-006
`develop` tip and this wave's PR branch.

**Expectation:** Every job block is byte-identical EXCEPT `spec-guard`,
which gains exactly one new step (the `mutants-aggregate.sh --self-test`
step, AC-016) and nothing else — no other job's `if:`, `env:`, `steps:`,
or `runs-on:` changes. `ci-gate`'s own job block changes in exactly ONE
place: the `needs:` array's last element (AC-032). This is the direct
regression guard for the delta-analysis.md's own Risk #3 concern (a
partial guardrail migration breaking the gate for jobs that were never
supposed to change).

**MUST-PASS. Regression-critical.**

### H-W1-REG-002 — `test_ci_gate_needs_partitions_all_ci_yml_jobs` still holds

**Setup:** Run the existing (pre-cycle-006, unmodified in logic)
`test_ci_gate_needs_partitions_all_ci_yml_jobs` (S-626-1 U1) against the
post-cycle-006 `ci.yml`.

**Expectation:** PASSES — every job literally defined in `ci.yml`
(including the three new ones, `mutants-plan`/`mutants`/`mutants-
aggregate`) is in either `ci-gate.needs` (`mutants-aggregate` only) or
the updated `PINNED_GATE_EXCLUDED_JOBS` allowlist (`mutants`/`mutants-
plan` added). This is the direct proof that AC-032's `PINNED_GATE_
EXCLUDED_JOBS` update is not merely present but actually satisfies this
pre-existing, unmodified structural invariant — a partition gap here
would mean a new job exists that `ci-gate`'s own bookkeeping doesn't
account for at all.

**MUST-PASS. Regression-critical.**

### H-W1-REG-003 — `check-ci-gate.sh --self-test`'s 14 fixtures (13 pre-existing + 1 new) still pass post-refactor

**Setup:** Run `scripts/check-ci-gate.sh --self-test` after (a) the
`ALLOWED_SKIPS`-emptying change, (b) the `is_allowed_skip`/
`print_allowed_skips` empty-array guards, (c) the Fixture 4/5/12/13
repurposing, (d) the new Fixture 14, AND (e) the `scripts/lib/trusted-
jq.sh` extraction/sourcing refactor.

**Expectation:** All 14 fixtures pass (the repurposed ones under their
NEW mechanism — local-override synthetic arrays for 4/5, the rekeyed
`mutants-aggregate` payload for 12, the simplified single-skip payload
for 13 — and the genuinely new Fixture 14 for the true empty-array
production shape). The `trusted-jq.sh` extraction is a pure refactor —
`resolve_trusted_jq`'s OWN behavior (verified by the pre-existing
`EXPECTED_JQ_TRUST_CHECKS = 17` self-test, unchanged) must be
byte-for-byte identical before and after the extraction; this scenario
exists specifically to catch an extraction that accidentally changes
behavior while moving code, which a pure diff review might miss if the
reviewer trusts "it's just a refactor."

**MUST-PASS. Regression-critical — `EXPECTED_JQ_TRUST_CHECKS` stays 17,
unchanged, is the direct numeric pin for this scenario's core claim.**

### H-W1-REG-004 — The 4 transformed-in-place tests correctly flip on `ALLOWED_SKIPS` emptiness

**Setup:** Run `test_ci_gate_decision_matches_job_level_if_for_every_
needs_member` and `test_allowed_skips_members_require_job_level_
conditional_in_ci_yml` (architecture-delta.md §6.2 items 6-7) against
the post-cycle-006 state, where `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS` and
`ALLOWED_SKIPS` are BOTH genuinely empty (not merely retargeted).

**Expectation:** Both tests PASS via their NEGATIVE branch (asserting
`!saw_positive_branch` / the `SKIP_TOLERANT_NEEDS_MEMBERS.is_empty()`
consistency check) — proving the transform (not deletion, not a
weakened assert) correctly handles the "the pinned skip-tolerant set is
now empty" case this cycle introduces for the first time in this
script's history. A regression here would mean either (a) the transform
was implemented as a silent skip/deletion instead of a genuine
conditional assert (masking a future desync between `ALLOWED_SKIPS` and
the Rust-side pins), or (b) `ALLOWED_SKIPS` wasn't actually emptied
despite the story claiming it was.

**MUST-PASS. Regression-critical.**

### H-W1-REG-005 — `EXPECTED_GUARD_TEST_COUNT`'s self-check denominator matches the real test count

**Setup:** Run `test_this_file_test_count_matches_expected_denominator`
against the final `tests/ci_gate_completeness.rs` after all 27 new
`#[test]` functions are added and the 9 modified-in-place tests are
updated.

**Expectation:** PASSES at `65` — this is the cheapest, most direct
regression guard against a silent under/over-count: if the implementer
adds 26 tests instead of 27 (or accidentally deletes one of the 9
"modified in place" tests instead of transforming it), this self-check
fails LOUD rather than silently understating coverage. Per this file's
own convention (cited throughout `architecture-delta.md`), this
denominator is the "ground truth" backstop — the story's own AC-031 and
this scenario are two independent expressions of the same guarantee (AC
= design-time obligation; this scenario = the literal test-suite proof
that runs in CI).

**MUST-PASS. Regression-critical.**

### H-W1-REG-006 — The other CLAUDE.md-documented CI-gate residuals remain exactly as documented, not silently widened

**Setup:** Re-read CLAUDE.md's CI-Gate history section's documented,
accepted residuals (the two unpinned `uses:` VALUES on the `ci-gate`
decision path; the passwordless-sudo bound) alongside `mutants-
aggregate`'s own §6.8/§6.11 structural-peer table, AFTER this wave's
implementation lands.

**Expectation:** `mutants-aggregate`'s own equivalent residuals (its four
pre-eval-step `uses:` calls — harden-runner, checkout, download-artifact
×2 — and the same passwordless-sudo bound) are documented in this
story's Out of Scope section EXACTLY as accepted/carried-forward, not
silently "fixed" in a way that creates an inconsistency with `ci-gate`'s
own still-open residual (which would be a scope-creep red flag, not a
correctness improvement, since it would mean the two structural peers
diverge in a way F2's own §6.8 enumeration didn't anticipate), AND not
silently left undocumented (which would be a doc-fidelity regression).

**SHOULD-PASS** (a documentation-consistency check, not a runtime
behavioral proof — downgraded from MUST-PASS accordingly, but still
worth an explicit pass/fail determination before this wave's gate
closes).

---

## 3. Summary

| Scenario | Priority | Type |
|---|---|---|
| H-W1-INT-001 | MUST-PASS | Cross-cutting integration (real survivors -> RED) |
| H-W1-INT-002 | MUST-PASS | Cross-cutting integration (all-crash -> fail closed) |
| H-W1-INT-003 | MUST-PASS | Cross-cutting integration (clean PR -> GREEN) |
| H-W1-INT-004 | MUST-PASS | Cross-cutting integration (escape hatch -> failure, not skip) |
| H-W1-INT-005 | SHOULD-PASS | Cross-cutting integration (nightly isolation) |
| H-W1-INT-006 | SHOULD-PASS | Cross-cutting integration (fold-wins arm, end-to-end) |
| H-W1-INT-007 | MUST-PASS | Cross-cutting integration (missing shard sentinel -> fail closed, end-to-end) |
| H-W1-REG-001 | MUST-PASS | Regression (other 7 always-run jobs unchanged) |
| H-W1-REG-002 | MUST-PASS | Regression (job-partition invariant holds) |
| H-W1-REG-003 | MUST-PASS | Regression (check-ci-gate.sh's 14 fixtures + trusted-jq extraction) |
| H-W1-REG-004 | MUST-PASS | Regression (transformed-in-place tests flip correctly) |
| H-W1-REG-005 | MUST-PASS | Regression (fixed-denominator self-check) |
| H-W1-REG-006 | SHOULD-PASS | Regression (documented residuals stay consistent) |

**13 scenarios total (10 MUST-PASS, 3 SHOULD-PASS)** — 7 cross-cutting
integration scenarios (H-W1-INT-001..007, extended round 10/FIX-5 with
H-W1-INT-007) + 6 regression scenarios (H-W1-REG-001..006). This wave's gate cannot close
with any MUST-PASS scenario failing; SHOULD-PASS scenarios failing must
be explicitly acknowledged (not silently skipped) before the gate closes,
per this document's own framing note that this cycle substitutes
cross-cutting integration/regression rigor for the product-feature
holdout-evaluator pattern.
