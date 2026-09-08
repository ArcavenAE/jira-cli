---
document_type: spec-evolution-invariants
feature_name: "mutants-ci-sharding"
cycle: cycle-006
created: 2026-09-07
status: draft
author: architect (vsdd-factory)
traces_to: .factory/phase-f1-delta-analysis/cycle-006/delta-analysis.md
governance: policy-doc-only (docs/specs/cargo-mutants-policy.md) — NO new PRD BC, per
  DEC-348 and the precedent set by MUTATION-CI-TIMEOUT (2026-06-28).
implements_for: .factory/phase-f2-spec-evolution/cycle-006/architecture-delta.md
revision_note: "Round-9 adversarial fix (F2 fresh-context review, ninth
  pass / adversary pass 13) — a LOW loop-breaker (LOW-1) plus a
  bookkeeping correction (LOW-2), both purely Rust-side/documentation
  matters with no home in THIS invariants file (same category round-7/
  round-8's structural-pin findings fell into) — full account in
  architecture-delta.md §6.8's round-9 addendum, not duplicated here.
  Summary for this file's own record: a fresh-context adversary found the
  round-8 declination for `MUTANT_COUNT`'s byte-VALUE pin circular under
  round-8's own threat model — Step 4's `total_scored != MUTANT_COUNT`
  reconciliation (this file's own INV-AGG sub-invariant 8, see below) is
  a genuine, independent completeness proof against per-shard
  PLAN↔EXECUTION divergence, but it CONSUMES `MUTANT_COUNT` rather than
  independently verifying how that env value is wired, so citing it as
  the reason a wiring pin was unnecessary missed that a PR hardcoding the
  env line to the pooled total defeats the reconciliation by
  construction. Fixed via three new Rust-side byte-VALUE pins in
  `tests/ci_gate_completeness.rs` (items 25-27, architecture-delta.md
  §6.2) for `MUTANT_COUNT`/`OVERALL_DIFF_LINES`/`PLAN_RESULT` — no change
  to `evaluate_mutants_aggregate()`'s own logic, no change to the
  reconciliation, regex-guard, or `PLAN_RESULT != \"success\"` runtime
  behavior this file's own guard-tests continue to rely on unmodified,
  and no change to any INV-AGG/INV-COMPLETE/INV-ESCALATE invariant
  STATEMENT. `EXPECTED_GUARD_TEST_COUNT: 62 -> 65`; `EXPECTED_MUTANTS_
  AGG_FIXTURES` unchanged at `12` (no new bash self-test fixture — items
  25-27, like items 23/24 before them, assert over `ci.yml`'s parsed YAML
  tree, not over `evaluate_mutants_aggregate()`'s own behavior, so they
  add no fixture to this file's own harness). Separately, a bookkeeping
  correction (LOW-2, same pass-13 review): `EXPECTED_FIXTURES`'s
  round-1 entry in architecture-delta.md §6.5 had mislabeled the round
  that actually introduces Fixture 14 as \"unchanged at 14\" rather than
  \"13 -> 14\" — corrected there; no change needed in this file, which
  does not itself narrate `EXPECTED_FIXTURES`'s round-by-round history.
  Round-8 adversarial fix (F2 fresh-context review, eighth
  pass / adversary pass 11) — a HIGH false-green (F-H1) plus a systematic
  declination re-audit, both purely Rust-side structural-pin matters with
  no home in THIS invariants file (same category round-7's jq-trust-parity
  tests fell into, per that round's own note below) — full account in
  architecture-delta.md §6.8's round-8 addendum, not duplicated here.
  Summary for this file's own record: a fresh-context adversary found the
  §6.8 M2-n row's disposition for `STATUS_DIR`/`SHARD_DIR` (the two env
  vars that locate every sentinel/outcomes.json this file's own INV-AGG/
  INV-COMPLETE guard-tests exercise via the synthetic tree layout
  referenced below) rested on a faulty argument — it cited the `${VAR:?
  message}` guard in `evaluate_mutants_aggregate()` (§6.2a) as adequate
  substitute for a byte-VALUE structural pin, which is wrong: `:?` proves
  only that the script aborts on UNSET/EMPTY, never that the value is the
  CORRECT path rather than an attacker-redirected one. Fixed via two new
  Rust-side byte-VALUE pins in `tests/ci_gate_completeness.rs` (items
  23-24, architecture-delta.md §6.2) — no change to `evaluate_mutants_
  aggregate()`'s own logic, no change to `:?`'s runtime behavior (which
  this file's own guard-tests continue to rely on unmodified), and no
  change to any INV-AGG/INV-COMPLETE/INV-ESCALATE invariant STATEMENT.
  `EXPECTED_GUARD_TEST_COUNT: 60 -> 62`; `EXPECTED_MUTANTS_AGG_FIXTURES`
  unchanged at `12` (no new bash self-test fixture — items 23/24 assert
  over `ci.yml`'s parsed YAML tree, not over `evaluate_mutants_
  aggregate()`'s behavior, so they add no fixture to this file's own
  harness). Round-7 adversarial fix (F2 fresh-context review, seventh
  pass) — FALSE-GREEN mandate again declared CLEAN (aggregator control
  flow confirmed fail-closed); one new MEDIUM found and closed, a doc-only
  correction to this file specifically. architecture-delta.md §6.8 mirrored
  ci-gate's RUST STRUCTURAL pins onto mutants-aggregate but never mirrored
  check-ci-gate.sh's SCRIPT-LEVEL RUNTIME hardening (the PATH-shim-resistant
  `resolve_trusted_jq` machinery, `set -euo pipefail`, the builtin-stdin-read
  defense, etc.) — closed in architecture-delta.md's new §6.11, via a shared
  `scripts/lib/trusted-jq.sh` sourced by BOTH `check-ci-gate.sh` and the new
  `mutants-aggregate.sh` (see that section for the full enumeration and the
  anti-drift rationale). **This file's own change (LOW-2, a floor-arithmetic
  correction, not a new invariant or guard-test class):** the INV-AGG
  Guard-test below previously specified only ONE fixture construction (naive
  average PASSES / pooled FAILS); a single-direction fixture cannot
  distinguish 'this aggregator sums correctly' from 'this aggregator merely
  fails whenever shards are asymmetric' — the Guard-test now specifies the
  STRADDLING PAIR (1A, unchanged from round-1 through round-6; 1B, NEW this
  round, the opposite-direction case where naive averaging FAILS and the
  correct pooled sum PASSES), matching `verification-delta.md`'s VP-001
  (maintained separately, already specified both directions). No invariant
  STATEMENT changes — INV-AGG's summation contract is unchanged; only its
  Guard-test's fixture count grows from 1 to 2. See architecture-delta.md
  §6.2a for the corrected `EXPECTED_MUTANTS_AGG_FIXTURES` floor arithmetic
  this drives (`10 -> 12`: +1 for fixture 1B here, +1 for a previously
  uncounted Step-0.5 `PLAN_RESULT != \"success\"` fixture the old floor
  formula omitted entirely). `EXPECTED_GUARD_TEST_COUNT` is UNCHANGED by
  THIS file's own change (fixture 1B is a second fixture CASE inside the
  existing T1 `#[test]` function, per this file's own 'the count pins
  #[test] FUNCTIONS, not fixtures' convention — see architecture-delta.md
  §4/§6.9) but DOES grow via §6.11's new runtime-hardening guard tests
  (`58 -> 60`) — see architecture-delta.md §6.11 for those two new tests,
  which are Rust-side jq-trust-parity pins with no INV-AGG/INV-COMPLETE/
  INV-ESCALATE content of their own and therefore no home in this
  invariants file. Round-6 adversarial fix (F2 fresh-context review, sixth
  pass) — FALSE-GREEN mandate declared CLEAN this round; two residual,
  non-false-green items closed. L-1 (LOW, stale doc, architecture-
  delta.md §6.2a): a paragraph never updated when round-5 reverted the
  reconciliation hard-fail, still describing round-4's warning-only
  fixture shapes as operative — rewritten in architecture-delta.md only
  (this file's own fixture write-up, below, was already round-5-correct).
  M-1 (MEDIUM, false-RED risk on an unverified premise): strengthens the
  mitigation for the still-unverified `--list`<->pooled `--shard
  --sharding slice` partition premise from open-ended F4 diligence to a
  NAMED, BLOCKING, ACCEPTED-RISK F4 precondition — a scratch-run
  verification performed DURING F4, BEFORE cycle-006's own PR merges (not
  deferred to discovery on PR #778, which is now a CONFIRMING,
  production-scale exercise rather than the sole verification point). See
  the round-6 addendum under sub-invariant 8's round-5 callout below, and
  architecture-delta.md §1 (new 'F4 Blocking Preconditions' list) / §6.10
  for the mirrored account. Test COUNT is unaffected
  (`EXPECTED_GUARD_TEST_COUNT` stays `58`, `EXPECTED_MUTANTS_AGG_FIXTURES`
  stays `10`) — round-6 is a mitigation-strengthening and documentation
  fix, not a new test/fixture slot. Round-5 adversarial fix (F2 fresh-context review, fifth
  pass) — REVERSES round-4's rollout-policy downgrade. Invariant NAMES
  (INV-AGG, INV-COMPLETE, INV-ESCALATE) are unchanged across every round,
  including this one. Round-4 downgraded INV-AGG sub-invariant 8
  (pooled-total <-> MUTANT_COUNT reconciliation) from an unconditional
  hard FAIL to a NON-BLOCKING `::warning::`, reasoning that the
  `--list`<->`--shard --sharding slice` lossless-partition premise it
  depends on was empirically unverified and that a hard fail on a wrong
  premise would brick every PR simultaneously (round-4's Option A). A
  fifth fresh-context F2 adversary confirmed round-4's own arithmetic/
  wiring findings were sound but identified round-4's ROLLOUT-POLICY
  choice itself as a new MEDIUM false-green: warning-only disables the
  ONLY guard this cycle has for 'mutants silently vanish between plan and
  shard execution' — if the dropped mutants happen to be survivors, the
  pooled kill rate on the remaining (smaller) scored set can read >=90%
  while the true, complete set would not have. Round-5 REVERSES round-4's
  Option A and adopts round-4's own previously-documented Option B: the
  hard fail is restored (`total_scored != MUTANT_COUNT` -> `return 1`,
  BOTH directions — see the round-5 callout under sub-invariant 8 for why
  exact equality, not a directional `>=`, is retained), and the
  empirical-premise risk is handled by a mandatory F4 empirical-
  determination task rather than by a permissive rollout period — see
  that same callout for the full mechanism, including why PR #778 (not
  cycle-006's own PR, which is CI/doc-only and touches ~0 `src/`
  mutants) is the natural first live exercise of a nonzero reconciliation.
  This round also RE-SCOPES the two round-4 kill-rate/reconciliation
  'independence' tests (VP-022/023, architecture-delta.md §6.2 items
  19-20): their original fixtures assumed Step 4 falls through to Step 6
  on a mismatch (true only under warning-only) — under a restored hard
  fail, Step 4 short-circuits BEFORE Step 6 ever runs on any mismatch, so
  their original assertions ('names the kill-rate failure specifically')
  are no longer reachable. Item 19/VP-022 is re-scoped to the OVER-count
  direction (`total_scored > MUTANT_COUNT`), the new, previously-untested
  half of the exact-equality decision; item 20/VP-023 is re-scoped to
  prove a healthy-looking PARTIAL kill rate on the scored subset does not
  rescue a dropped-mutant mismatch — the literal 'invert to assert FAILS'
  the round-5 task brief calls for. Test COUNT is unchanged
  (`EXPECTED_GUARD_TEST_COUNT` stays `58`) — this round is assertion/
  fixture changes to three existing test slots (items 8/9's rename
  reverts, items 19/20's fixtures/assertions change), not new or removed
  tests. Full account: architecture-delta.md §6.10 (round-5 consolidated
  summary, reversing §6.9's F2 entry) and mutants-sharding-invariants.md's
  own round-5 callout below. Round-4's own callout (Option A/B weighing)
  is RETAINED below, unedited, as the historical record that round-5's
  Option-B choice was already anticipated and documented as available —
  round-5 is a reversal of round-4's DEFAULT choice, not new analysis
  from scratch. Round-4 also landed §6.8's structural-peer enumeration
  (5 tests protecting `mutants-aggregate`'s own wiring, e.g. run-line
  byte-pin, env-key-set pin, invocation assertion, node-property scan,
  per-step `if:`-value pin) — that work is UNCHANGED and UNAFFECTED by
  this round's reconciliation-policy reversal; it is a separate, orthogonal
  finding. Round-3 (three rounds prior) — INV-AGG/INV-COMPLETE guard-tests
  were retargeted onto the
  newly-extracted `scripts/mutants-aggregate.sh` (a BLOCKING F2-gate
  precondition, architecture-delta.md §6.2a); no invariant statement
  changed. Round-2 — INV-AGG sub-invariant 8's reconciliation claim was
  DOWN-SCOPED to what it actually proves (per-shard plan<->execution
  divergence, not common-mode corruption of the shared mutants-diff-file
  artifact), with the residual false-green documented rather than implied
  closed; the TOOLING-ERROR half of that residual (a silent '--list'
  failure) was separately closed in mutants-plan's pre-count step (see
  ci-yml-design.md §1). Round-1 fully redesigned INV-COMPLETE around a
  per-shard status SENTINEL to close a CRITICAL false-green (CRIT-1: all
  shards crash under continue-on-error, aggregator took the old
  0-artifacts branch and passed) and a HIGH false-red (HIGH-1: a small
  PR's legitimately-empty shard slices had no way to be distinguished
  from missing ones), and introduced INV-AGG sub-invariant 8 itself — see
  the 'Round-1 adversarial fix' / 'Round-2 adversarial fix' / 'Round-4
  adversarial fix' / 'Round-5 adversarial fix' callouts inline under
  sub-invariant 8 for the full, layered history."
---

# Mutants CI Sharding — Named Invariants (cycle-006)

This document specifies the three correctness invariants the new
`mutants-plan` → `mutants` (shard matrix) → `mutants-aggregate` topology must
satisfy, as precise, testable statements. Each invariant names the guard-test
that enforces it; F4 implements the test bodies, this document specifies what
they must assert. **(round-3 note)** Every INV-AGG/INV-COMPLETE guard-test
below is a `#[cfg(unix)]` subprocess test invoking the extracted
`scripts/mutants-aggregate.sh` directly (`architecture-delta.md §6.2a`) —
this is a BLOCKING F2-gate precondition, not an implementation detail F4
is free to substitute a Rust-side re-implementation for; see that section
for the exact invocation shape (synthetic `STATUS_DIR`/`SHARD_DIR` trees,
env vars, captured exit code + stdout). All three invariants are **governed by
`docs/specs/cargo-mutants-policy.md`** (policy-doc-only, no PRD BC — see
`docs/specs/cargo-mutants-policy.md §Spec Anchor` for the established
precedent this cycle continues) and enforced structurally by
`tests/ci_gate_completeness.rs` guard tests, mirroring the rigor of every
existing `Check kill rate` guard (malformed-JSON, integer-validation, H-1
schema-drift, M-2 reconciliation).

## Job topology these invariants govern

```
mutants-plan  (PR-only; computes DIFF_FILE once, uploads it as an artifact,
               pre-counts in-diff mutants, sets outputs: escalated, mutant_count,
               overall_diff_lines)
     |
     +--> mutants  (matrix: shard 0..7; needs: [mutants-plan]; skipped unless
     |              PR event AND NOT escalated; each shard downloads the SAME
     |              DIFF_FILE artifact, runs `--shard k/8 --sharding slice
     |              --jobs 2 --baseline skip --timeout 240` (id: run-mutants,
     |              continue-on-error: true), then — ALWAYS, regardless of
     |              run-mutants' outcome or whether outcomes.json exists —
     |              writes and uploads a status SENTINEL
     |              (`mutants-shard-status-<k>`, round-1 adversarial fix, see
     |              INV-COMPLETE) capturing `steps.run-mutants.outcome` +
     |              whether `mutants.out/outcomes.json` exists, THEN uploads
     |              `mutants.out/outcomes.json` itself (unchanged,
     |              `if-no-files-found: warn`) as `mutants-shard-outcomes-<k>`)
     |
     +--> mutants-aggregate  (needs: [mutants-plan, mutants]; if: always();
                              NEVER reports `skipped` to GitHub Actions — always
                              resolves to success or failure internally; is the
                              sole `ci-gate.needs` member for mutation testing.
                              Downloads BOTH the status sentinels AND the
                              outcomes.json artifacts — sentinels drive
                              INV-COMPLETE's presence/interpretation logic,
                              outcomes.json drives INV-AGG's summation.)
```

`mutants-aggregate` replaces `mutants` as the `ci-gate.needs` member (DEC-096/
DEC-097: new required jobs are wired via `ci-gate.needs`, never directly into
branch protection). `mutants-plan` and `mutants` (the shard matrix) are never
`ci-gate.needs` members — see `architecture-delta.md §Guardrail Lockstep Plan`
for how each is instead admitted via `PINNED_GATE_EXCLUDED_JOBS`.

---

## INV-AGG — Sharded-Aggregation Kill-Rate Contract

**Statement.** `mutants-aggregate` computes exactly ONE pooled kill rate from
the SUM of raw outcome counts across every shard's `outcomes.json`. It never
computes or averages a per-shard percentage. Formally, for shards
`s ∈ {0..N-1}`:

```
caught_total   = Σ caught_s
missed_total   = Σ missed_s
timeout_total  = Σ timeout_s
unviable_total = Σ unviable_s

killable = caught_total + missed_total + timeout_total
kill_rate = (caught_total * 100) / killable      # integer division, multiply-first
```

The gate passes iff `killable == 0` (all-unviable — nothing to gate on, same
"OK" branch as today's single-job design) **or** `kill_rate >= 90`.

**Sub-invariants (carried forward verbatim from the single-job design, applied
per-shard-file BEFORE summing — do not relax any of these for the sharded
case):**

1. **Timeouts count as survived.** `timeout` is included in `killable` and
   excluded from `caught` — a shard-heavy async-hang PR can legitimately fall
   below 90% even with zero genuine `missed` mutants. This is unchanged from
   `docs/specs/cargo-mutants-policy.md §Timeout Semantics: Timeouts Count as
   Survived`.
2. **`unviable` is excluded from the denominator** (build errors that never
   ran) — unchanged.
3. **Per-file malformed-JSON guard.** Before any shard's counts are added to
   the running sums, that shard's `outcomes.json` must pass `jq empty`. A
   malformed file for ANY shard fails the whole aggregation closed — do not
   silently treat a malformed shard as "0 mutants" and continue summing the
   rest (that would silently understate `killable` and could inflate
   `kill_rate` past 90% on a partially-corrupt run).
4. **Per-file integer-validation guard.** Each of `caught`/`missed`/`timeout`/
   `unviable`/`total_mutants` extracted per shard is regex-validated
   `^[0-9]+$` before arithmetic; a non-integer coerces to 0 for THAT SHARD
   only (mirrors the existing single-job H-2 guard) — this does not
   short-circuit the whole aggregation, since a coerced-to-0 field still
   participates correctly in the schema-drift check below.
5. **Per-file H-1 schema-drift guard.** For each shard individually: if that
   shard's `outcomes.json` has a non-empty `.outcomes` array (or non-zero
   `total_mutants`) but all four summary keys parsed to 0, that is a
   per-shard schema-drift signal — fail the whole aggregation closed
   (identical trigger condition to the existing single-job H-1 guard, just
   evaluated once per shard file rather than once per run).
6. **Per-file M-2 `total_mutants` reconciliation.** For each shard: if
   `caught_s + missed_s + timeout_s + unviable_s != total_mutants_s` (and
   `total_mutants_s != 0`), emit a `::warning::` annotation naming the
   offending shard index — non-fatal, same warning-only rationale as the
   single-job design (a future cargo-mutants outcome category should not
   hard-fail every large PR).
7. **The `@27.1.0` exact pin protects every shard identically** — see
   INV-AGG's dependency on the cargo-mutants version pin tightening
   (`architecture-delta.md §Version Pin`); a schema drift across ALL N
   invocations rather than 1 is a strictly larger blast radius if the pin
   were left at the looser `@27` major-only form.
8. **(round-1 adversarial fix; ROLLOUT POLICY REVISED round-4, then
   REVERSED round-5 back to its round-1/2/3 original — see the round-5
   callout below) Pooled-total ⇔ pre-count reconciliation.** After
   per-shard folding completes (INV-COMPLETE Part C below),
   `mutants-aggregate` computes
   `total_scored = caught_total + missed_total + timeout_total +
   unviable_total` and compares it against `MUTANT_COUNT` —
   `mutants-plan`'s `cargo mutants --list --in-diff "$DIFF_FILE" | wc -l`
   pre-count, threaded via `needs.mutants-plan.outputs.mutant_count` (an
   output that existed in the pre-fix design but was never actually
   consumed downstream — this sub-invariant is what consumes it).
   **Exact-equality rule, HARD FAIL (BLOCKING) — see the round-5 callout
   for why this is restored, and for why the check remains symmetric
   (both directions) rather than a directional `total_scored >=
   MUTANT_COUNT`:** if `total_scored != MUTANT_COUNT`, the aggregation
   emits a diagnostic naming both numbers and `return 1` — the whole
   aggregation FAILS CLOSED on this condition alone; it does not fall
   through to Step 5/6. **This restores round-1/round-2/round-3's
   original design. Round-4 had downgraded this to a NON-BLOCKING
   `::warning::`; round-5 reverses that downgrade — see the round-5
   callout immediately below for the full account of why, and how the
   round-4-identified risk (an unverified partition premise) is now
   handled instead.** Sub-invariant 6 (per-shard `total_mutants`
   reconciliation) remains `::warning::`-only, for a different, permanent
   reason (it tolerates a FORWARD-COMPATIBLE new outcome-category name —
   a schema question, not a completeness question) — that sub-invariant
   is UNCHANGED by this round. Sub-invariant 8 is a CROSS-JOB
   COMPLETENESS question: does the mutant set `mutants-plan` counted as
   in-scope match the set the shard matrix actually examined and reported
   on? This is precisely the "mutants silently go missing between
   planning and execution" risk class this cycle exists to close, and it
   is structurally invisible to INV-COMPLETE's presence check alone —
   e.g. a shard whose `--sharding slice` computation somehow ran against
   a stale or different diff than the one `mutants-plan` counted against
   would still produce a present, well-formed, individually-valid
   `outcomes.json`; only comparing the POOLED total against the
   independently-computed pre-count catches that class. `unviable`
   participates in `total_scored` (unlike `killable`, which excludes it
   per sub-invariant 2) because `--list`'s pre-count enumerates every
   mutant `cargo mutants` would ATTEMPT, including ones that later turn
   out unviable during the real run — an unviable mutant is still an
   examined-and-accounted-for mutant, just one excluded from the kill-rate
   denominator. No tolerance/fuzz is applied to the comparison itself
   (exact equality, both numbers named on mismatch): `--list` and the
   actual run share the identical pinned `cargo-mutants@27.1.0` binary,
   the identical `DIFF_FILE` artifact (§ "one upload, N downloads of the
   identical bytes"), and the identical repo commit, so exact
   reproducibility is the design expectation, not an approximation.

   **Residual, empirically-unverified premise — this is WHY round-4
   revised the rollout policy, and why round-5's reversal pairs the
   restored hard fail with a mandatory empirical-determination task
   rather than simply re-imposing the risk round-4 flagged:** whether
   `cargo mutants --list --in-diff <diff>` and the pooled sum of
   `--shard k/8 --sharding slice --in-diff <same diff>` across all 8
   shards are GUARANTEED bit-identical in count by cargo-mutants' own
   implementation (i.e., that `--sharding slice` is a strict, lossless
   partition of exactly the `--list` set, no drops or duplicates,
   including its interaction with `--baseline skip` and unviable-mutant
   counting) is asserted here as a design premise, not independently
   verified against cargo-mutants' source across five F2 rounds. Rounds
   1-3 each proposed "ship with exact equality first, loosen later if it
   fires on legitimate PRs"; round-4 observed that a hard fail on a wrong
   premise bricks every PR on the sharded gate simultaneously (the
   aggregator is the SOLE mutation-gate decision job feeding `ci-gate`)
   and downgraded to warning-only as a result. Round-5's fresh-context
   adversary weighed that risk against the risk warning-only itself
   creates — a genuinely dropped survivor mutant silently passing because
   the remaining scored subset's kill rate looks healthy — and judged the
   silent-false-green risk the worse of the two for a security-relevant
   gate, per this repo's own "fail LOUD is correct; silent acceptance of
   dropped mutants is not" principle. See the round-5 callout immediately
   below for the resolved policy (hard fail restored + mandatory F4
   empirical-determination task, anchored on PR #778 as the first real
   nonzero-`MUTANT_COUNT` exercise).

   > **Round-2 adversarial fix (MEDIUM-2) — down-scoped claim + documented
   > residual, not implied closed.** A second fresh-context F2 adversary
   > confirmed the aggregator's overall decision logic is sound but found
   > this sub-invariant's coverage claim, as originally written, too broad.
   > **What reconciliation actually catches:** per-shard PLAN ↔ EXECUTION
   > DIVERGENCE only — i.e., cases where the mutant set the shard matrix
   > actually examined and reported on differs from the set `mutants-plan`
   > independently counted as in-scope. **What it structurally CANNOT
   > catch: a common-mode error in the single shared `mutants-diff-file`
   > artifact itself.** Both `MUTANT_COUNT` (`mutants-plan`'s `--list
   > --in-diff "$DIFF_FILE"` pre-count) and every shard's actual mutant set
   > (`--shard k/8 --in-diff "$DIFF_FILE"`) are derived from the SAME
   > uploaded `DIFF_FILE` bytes (§ "one upload, N downloads of the
   > identical bytes" — this is the very property that makes the
   > sharded design correct for its OWN stated purpose). If `DIFF_FILE`
   > itself is wrong at the source — a subtle base-ref resolution bug,
   > a `.cargo/mutants.toml` `examine_globs` scoping quirk that
   > `mutants-plan`'s `git diff` computation does not anticipate, or any
   > other defect that produces a diff other than "what this PR actually
   > changed" — then `--list` and every shard's `--shard` invocation
   > compute against the IDENTICAL wrong scope, agree with each other
   > exactly, reconcile `total_scored == MUTANT_COUNT` with a clean exact
   > match, and the gate passes GREEN having verified zero mutants outside
   > that wrong scope, with no signal anywhere in this pipeline that the
   > scope itself was wrong. **This is a genuine, accepted residual
   > false-green — documented here explicitly, not implied closed by
   > sub-invariant 8's exact-equality guarantee.** The reconciliation check
   > is still worth having: it closes the specific, more probable class of
   > defect (a shard-side execution bug, a plan/shard version skew, a
   > partial/corrupted artifact download) at zero false-negative rate for
   > THAT class — it just does not, and structurally cannot, extend to a
   > defect in the shared input both derivations trust identically.
   > **The documented backstop for this specific residual is the
   > nightly full-scope run** (`.github/workflows/mutants-nightly.yml`,
   > `architecture-delta.md §5`): it runs the FULL `examine_globs` scope
   > unconditionally, with NO dependency on `DIFF_FILE`/`git diff
   > origin/<base_ref>...HEAD` at all, so a systematic diff-scoping defect
   > that silently escapes every PR-gated run is still eventually examined
   > by the nightly run — with a lag (up to 24h) and advisory-only
   > severity (it does not block any specific PR retroactively). This
   > residual is explicitly tagged for F5/F6 re-examination as production
   > experience accumulates, not resolved here.
   >
   > **Separately, MEDIUM-2 also closed the TOOLING-ERROR half of a related
   > gap: `mutants-plan`'s `--list` step previously swallowed its own exit
   > status.** The original `MUTANT_COUNT=$(cargo mutants --list --in-diff
   > "${DIFF_FILE}" 2>/dev/null | wc -l | tr -d ' ')` pipeline runs under
   > this step's deliberate `set -uo pipefail` (no `-e` — see
   > `ci-yml-design.md §1`'s own design notes for why `-e` is intentionally
   > absent here). Under `pipefail` alone (without `-e`), a non-zero exit
   > from `cargo mutants --list` itself does not abort the script — the
   > pipeline's exit status is simply discarded once assigned via `$(...)`
   > command substitution, and `wc -l` reports whatever partial (possibly
   > empty) stdout was produced before the failure. A genuine `--list`
   > tooling failure (a bad base-ref, an `examine_globs` misconfiguration,
   > a `cargo-mutants@27.1.0` regression) would therefore silently produce
   > a wrong — most likely `0` — `MUTANT_COUNT`, which sub-invariant 8's
   > OWN reconciliation check cannot distinguish from a legitimate
   > zero-mutant PR (both reconcile cleanly against a correspondingly-zero
   > `total_scored` if the shard matrix also failed to receive a valid
   > diff, or, worse, against whatever partial total the shards DID
   > compute if the corruption is inconsistent between the plan step and
   > the shard runs). **This is a DISTINCT failure class from the
   > common-mode-diff-corruption residual above — it is a tool INVOCATION
   > failure, not a wrong-but-successful diff — and it IS fully closeable,
   > unlike the residual above.** Fixed in `ci-yml-design.md §1`: the
   > `--list` invocation now captures its own exit status explicitly
   > (separate from `wc -l`'s) and FAILS the `mutants-plan` job closed
   > (`exit 1`, naming the failure) on a non-zero `--list` exit, rather
   > than coercing it into a silently-wrong `MUTANT_COUNT=0`. No new
   > structural Rust-side pin is added for this — consistent with this
   > document's existing precedent that CI-script-internal control flow
   > (like `--timeout 240`, `ESCALATION_THRESHOLD=120`) is a code-review-
   > time obligation, not byte-pinned (`architecture-delta.md §6.2`
   > "Considered and explicitly declined additions").

   > **Round-4 adversarial fix (F2 fresh-context review, fourth pass) —
   > MEDIUM, false-RED risk: reconciliation demoted to non-blocking for
   > cycle-006's initial rollout (Option A), with a mandatory empirical
   > tighten-trigger. RETAINED VERBATIM BELOW AS HISTORY — SUPERSEDED BY
   > THE ROUND-5 CALLOUT THAT FOLLOWS IT.** Round-5 reverses this round's
   > DEFAULT choice (Option A) in favor of the Option B this round already
   > weighed and documented as an available fallback — see the round-5
   > callout immediately after this one for the current, operative policy.
   > This block is kept intact, not deleted or rewritten, because its
   > Option A/B analysis is exactly what round-5 draws on: round-5 is a
   > reversal of which option is DEFAULT, not new analysis from scratch.
   > A fourth fresh-context F2 adversary confirmed the
   > aggregator's core decision LOGIC remains sound (no new false-green in
   > the summation/reconciliation arithmetic itself, the fourth round
   > running to reach that conclusion) but pressed on the rollout
   > CONSEQUENCE of round-1's still-unverified partition premise (restated
   > immediately above): shipping sub-invariant 8 as an unconditional hard
   > fail on day one means the FIRST time this repository learns whether
   > `--list` and pooled `--shard --sharding slice` counts are actually
   > guaranteed to agree is via production PRs failing closed — and
   > because `mutants-aggregate` is the SOLE `ci-gate.needs` member making
   > the mutation-gate decision (architecture-delta.md §7 dependency
   > graph), a wrong premise does not degrade gracefully to "some PRs are
   > affected" — it bricks the sharded mutation gate for EVERY PR
   > simultaneously, indistinguishably from a real regression, until a
   > human intervenes. Two options were weighed:
   >
   > - **Option A (CHOSEN): non-blocking `::warning::` for the first
   >   rollout, with a REQUIRED F4 empirical check before tightening.**
   >   Sub-invariant 8 is implemented as specified above (exact-equality
   >   comparison, both numbers always named on mismatch) but a mismatch
   >   emits `::warning::` and the function CONTINUES to Steps 5/6 rather
   >   than returning 1. **Tighten-trigger (blocking on the tighten, not on
   >   initial merge):** before sub-invariant 8 may be promoted from
   >   `::warning::` to a hard `return 1`, F4 (or a dedicated fast-follow
   >   story) MUST run the sharded pipeline against at least 2 real PRs
   >   with non-trivial, differently-sized in-diff mutant counts (at least
   >   one PR small enough that at least one of the 8 shards' `--sharding
   >   slice` legitimately produces zero mutants, exercising the
   >   HIGH-1/round-1 empty-shard path alongside reconciliation) and
   >   confirm, from the aggregator's own `::warning::` log output (or its
   >   absence), that `total_scored == MUTANT_COUNT` holds with ZERO
   >   reconciliation warnings across both runs. If a run instead surfaces
   >   a genuine, reproducible mismatch, root-cause it (a `--sharding
   >   slice` bug, a `--baseline skip` interaction, an unviable-mutant
   >   double-count) and fix or document a small, reasoned tolerance before
   >   tightening — never tighten with an open, unexplained discrepancy.
   >   The tighten itself is a small, reviewable follow-up change (flip
   >   `::warning::` back to `return 1` in `scripts/mutants-aggregate.sh`,
   >   update the two round-4 guard-tests below accordingly) — it is NOT
   >   gated on a full new F1-F7 cycle.
   > - **Option B (considered, not chosen): keep the hard fail, but make
   >   the empirical verification a BLOCKING pre-merge precondition for
   >   cycle-006's own landing PR.** Rejected as the DEFAULT policy (not
   >   because it is unsound) for a narrower reason: it makes cycle-006's
   >   own merge conditional on a real PR's mutation-diff shape happening
   >   to be large and varied enough, on the first attempt, to exercise the
   >   premise meaningfully — a timing/luck dependency this document's own
   >   "ship with exact equality first" instinct (rounds 1-3) was trying to
   >   avoid turning into a hard blocker. Option B remains available as a
   >   fallback if Option A's rollout period is judged too permissive by a
   >   future reviewer at the F2 human gate — that is the human's call to
   >   make explicitly, not this document's to preempt.
   >
   > **The primary kill-rate gate (>=90% pooled kill rate) is
   > STRUCTURALLY independent of sub-invariant 8's warn/pass state, not
   > merely independent by convention.** `caught_total`/`missed_total`/
   > `timeout_total`/`unviable_total` (and therefore `killable`/
   > `kill_rate`, Step 6) are folded entirely from the shards' OWN
   > `outcomes.json` data during Step 3 (INV-COMPLETE Part C) — Step 6
   > never reads `MUTANT_COUNT` at all, with or without round-4's change.
   > Round-4 makes this independence explicit and separately
   > guard-tested (not merely true by accident of the existing code
   > shape): a reconciliation mismatch combined with a genuinely failing
   > pooled kill rate (<90%) must still FAIL the gate, for the kill-rate
   > reason, not silently pass because reconciliation was "only a
   > warning"; a reconciliation mismatch combined with a genuinely passing
   > pooled kill rate (>=90%) must still PASS the gate, not fail because
   > reconciliation warned. See the two new guard-tests below.
   >
   > **Why this is a MEDIUM, not a HIGH or CRITICAL, finding:** the
   > underlying decision logic was already sound (confirmed independently
   > four times); this is a rollout-safety/blast-radius concern about a
   > STILL-UNVERIFIED premise, not a proven defect in the aggregator's
   > arithmetic. Flagged as MEDIUM per the task brief's own framing, and
   > explicitly re-flagged for F5 re-examination once the tighten-trigger's
   > empirical evidence exists.

   > **Round-5 adversarial fix (F2 fresh-context review, fifth pass) —
   > MEDIUM false-green: round-4's own rollout-policy choice (Option A)
   > reopens the exact defect class sub-invariant 8 exists to close.
   > (Round-6 note: this round's F2 mitigation is STRENGTHENED, not
   > reversed, by round-6/M-1 below — see "The empirical-premise risk..."
   > paragraph further down for the current, operative F4 task.)**
   > A fifth fresh-context F2 adversary confirmed round-4's structural-peer
   > enumeration (§6.8) and the aggregator's arithmetic are both sound —
   > no new finding in either — but identified that round-4's Option A
   > (non-blocking `::warning::`) disables the ONLY guard this cycle has
   > for "mutants silently vanish between plan and shard execution": if
   > the mutants that go missing between `mutants-plan`'s `--list` count
   > and the shard matrix's actual output happen to be SURVIVORS (mutants
   > that would have scored `missed`), the pooled kill rate computed over
   > the smaller, INCOMPLETE scored set can read `>= 90%` while the true,
   > complete set would not have — a false-green on the primary gate this
   > entire cycle exists to protect, introduced by the very sub-invariant
   > meant to catch it. **Resolution: adopt round-4's own Option B
   > (previously documented as an available, not-unsound fallback, never
   > chosen as default) as the round-5 default.** Two changes, together:
   >
   > 1. **The hard fail is restored, unconditionally, effective on
   >    cycle-006's own landing PR — not gated behind a rollout period or
   >    a tighten-trigger threshold.** `total_scored != MUTANT_COUNT` ->
   >    `return 1`, exactly as specified in the main sub-invariant-8 text
   >    above (round-1/2/3's original design). This is a DELIBERATE
   >    reversal of round-4's "ship permissive, tighten later" instinct:
   >    for a security-relevant gate, failing LOUD on an unverified
   >    premise is the correct default — the cost of a false-RED (a PR
   >    blocked pending investigation) is bounded and visible, while the
   >    cost of round-4's false-green (a dropped survivor silently
   >    passing) is unbounded and invisible. This repo's own documented
   >    principle for exactly this tradeoff (CI-gate history, this
   >    project's CLAUDE.md: "For a fail-closed security gate, fail LOUD
   >    is correct; silent acceptance ... is not") applies here without
   >    modification — `mutants-aggregate` is a gate of the same kind.
   > 2. **Exact equality, not a directional `total_scored >=
   >    MUTANT_COUNT`, is retained.** The comparison fails on BOTH
   >    `total_scored < MUTANT_COUNT` (the dangerous, dropped-mutant
   >    direction — a survivor could be among the missing) AND
   >    `total_scored > MUTANT_COUNT` (an over-count). Considered and
   >    rejected: loosening to a directional `>=` check that tolerates an
   >    over-count as "merely anomalous, not dangerous." Rejected because
   >    (a) rounds 1-3 already validated the exact-equality arithmetic as
   >    sound across three independent adversarial passes — round-4's
   >    concern was rollout BLAST RADIUS of a hard fail, never a specific
   >    problem with the `>` direction, so there is no finding motivating
   >    narrowing the check's coverage; (b) an over-count is not obviously
   >    safe to wave through — it means the shard matrix examined MORE
   >    mutants than `mutants-plan`'s `--list` counted as in-diff-scope,
   >    which is itself an instance of the SAME "what was examined does
   >    not match what was planned" defect class this sub-invariant exists
   >    to catch (a stale/duplicate artifact folded twice, or a shard's
   >    `--sharding slice` computation drawing from a wider scope than the
   >    plan step used), and this cycle has exactly as little operational
   >    evidence ruling that out as it has for the under-count direction;
   >    (c) a directional-only check adds encoding complexity (two
   >    different pass/fail rules for the same comparison) with no
   >    demonstrated offsetting benefit — no evidence yet exists that
   >    over-counts are common or benign enough to warrant tolerating
   >    them by default. If F4's empirical-determination work (below) or a
   >    live PR later surfaces a REPRODUCIBLE, EXPLAINED reason why
   >    over-counts are a legitimate, expected cargo-mutants behavior
   >    (e.g. a documented counting convention under `--sharding slice`),
   >    F5/F6 should revisit narrowing the comparison at that time, with
   >    the reasoning recorded — the round-5 default is the symmetric,
   >    stricter form, not the directional one.
   >
   > **The empirical-premise risk (why round-4 hesitated) is real — round-6
   > (M-1) reframes it as a NAMED, BLOCKING, ACCEPTED-RISK F4 precondition,
   > verified BEFORE cycle-006's own PR merges, rather than an open-ended
   > "F4 should check this" instruction or a permissive rollout window.**
   > This is structurally unresolvable at the F2/spec level — confirming
   > whether `--list`'s count and the pooled `--shard --sharding slice`
   > sum are actually guaranteed to reconcile requires running cargo-mutants
   > for real, which is F4's job. Two things make this an ACCEPTED RISK
   > rather than an unguarded gap: (1) the re-widening-to-warning-only
   > failure mode is ALREADY test-guarded — the restored VP-008 test and
   > its two re-scoped siblings VP-022/VP-023 (below) all assert `rc == 1`,
   > so nobody can silently reintroduce round-4's permissive behavior
   > without those tests turning red; (2) the ONE thing those tests cannot
   > verify is whether the premise the restored hard fail depends on is
   > itself TRUE against real cargo-mutants output — that is what the F4
   > task below closes.
   >
   > **The concrete F4 task (BLOCKING, performed DURING F4, BEFORE
   > cycle-006's own PR merges — NOT deferred to discovery on PR #778):**
   > on a scratch branch carrying a known-nonzero in-diff mutant set (or
   > via direct, side-by-side comparison against an already-open diff), F4
   > runs (a) `cargo mutants --list --in-diff <diff> | wc -l` and (b) the 8
   > `--shard k/8 --sharding slice --baseline skip` runs against the
   > IDENTICAL diff, and confirms the two counts reconcile EXACTLY — the
   > same comparison `scripts/mutants-aggregate.sh` performs in production,
   > run by hand first. Inspecting cargo-mutants' own source/test suite for
   > its `--sharding`/`--baseline skip`/unviable-counting semantics is
   > useful supporting context but does NOT substitute for the scratch run
   > itself — only an actual run produces the two real numbers this
   > precondition needs compared. **Cycle-006's own landing PR cannot
   > supply this evidence — it is CI/doc-only and touches ~0 `src/`
   > mutants, so it can only exercise the trivial `MUTANT_COUNT == 0`
   > reconciliation path (both sides trivially agree at zero); it is NOT a
   > source of confidence for the nonzero case, and F4/F5 must not treat
   > cycle-006's own green run as such — hence the dedicated scratch run.**
   > If the scratch run's two counts differ, F4 must root-cause it — never
   > re-widen to warning-only as a shortcut — along one of two branches:
   > (a) a **tooling-surface artifact** (e.g. a header or blank line in
   > `--list`'s output inflating `wc -l` by one) — fix at the source,
   > stripping it in `mutants-plan`'s own `--list` invocation; or (b) a
   > genuine **counting-convention difference** (e.g. `--list` and the
   > pooled run enumerate `unviable` mutants differently, or a `--baseline
   > skip` interaction produces a small, explainable, reproducible offset)
   > — encode the CORRECT reconciliation relationship into `scripts/
   > mutants-aggregate.sh` itself, as a documented, reasoned adjustment.
   > Either way, the fix lands in the SAME F4 change, before merge.
   >
   > **PR #778's role is now CONFIRMING, not the sole verification point.**
   > **PR #778** (281 mutants) remains the natural, low-cost FIRST REAL,
   > production-scale, at-CI exercise of the restored hard fail — the next
   > substantial PR expected to flow through the sharded pipeline once
   > cycle-006 merges — but it is no longer where this premise gets checked
   > for the first time; the scratch run above is. Because the hard fail is
   > restored, PR #778 is still not a passive "nice to observe": it is the
   > first PR where sub-invariant 8 is ACTUALLY enforced for real at
   > production scale, and that is correct, intended, fail-closed behavior,
   > not a risk to be engineered around. Two outcomes, both actionable: (i)
   > PR #778 reconciles cleanly (`total_scored == MUTANT_COUNT`) — that is
   > corroborating evidence at production scale, additional to (not a
   > substitute for) the scratch run's closing evidence; (ii) PR #778 fails
   > reconciliation despite a clean scratch run — this is a FAIL-LOUD
   > signal, with both numbers named, not a silent problem, and per the
   > invariant this document pins ("no mutant may go unscored relative to
   > the plan"), a human MUST root-cause it before merging that PR: either
   > (a) it is a genuine dropped-mutant defect (a real bug this
   > sub-invariant exists to catch — fix the underlying cause), or (b) it
   > is a counting-convention discrepancy the scratch run's diff shape
   > didn't happen to exercise (e.g. `--list` and the pooled run enumerate
   > `unviable` mutants differently, or a `--baseline skip` interaction
   > produces a small, explainable, reproducible offset) — in which case
   > F4/F5 must encode the CORRECT reconciliation relationship into
   > `scripts/mutants-aggregate.sh` (a documented, reasoned adjustment to
   > the comparison), never silently suppress or re-widen the check back to
   > warning-only as a shortcut. For a genuine emergency where PR #778 is
   > blocked and the discrepancy cannot be root-caused quickly, this repo's
   > existing admin branch-protection bypass (CLAUDE.md: "Admins can
   > bypass" `develop`/`main`'s protection rules) is the documented escape
   > valve — no new pipeline-level override mechanism is introduced by this
   > design.
   >
   > **Re-scoping the two round-4 "independence" tests (VP-022/023, §6.2
   > items 19-20) — required by the reversal, not optional cleanup.** Both
   > tests' original fixtures assumed Step 4 falls through to Steps 5/6 on
   > a mismatch (true only under round-4's warning-only policy). Under the
   > restored hard fail, Step 4 `return 1`s BEFORE Step 6 ever executes on
   > ANY mismatch — so neither test's original assertion ("stdout names
   > the kill-rate failure specifically") is reachable any more; Step 6's
   > kill-rate arithmetic never runs when sub-invariant 8 fails. Rather
   > than deleting the two test slots (which would drop
   > `EXPECTED_GUARD_TEST_COUNT` below 58, understating this cycle's real
   > coverage), both are RE-SCOPED to genuinely new, non-redundant
   > assertions — see the "Guard-test (sub-invariant 8)" section
   > immediately below for the exact fixtures and assertions each is
   > re-scoped to. `EXPECTED_GUARD_TEST_COUNT` stays **58** — this is a
   > re-scope of two existing test slots plus a revert of a third
   > (item 8/9's rename), not a change in test count.
   >
   > **The primary kill-rate gate's structural independence claim survives
   > the reversal, restated for the hard-fail world:** `caught_total`/
   > `missed_total`/`timeout_total`/`unviable_total` (and therefore
   > `killable`/`kill_rate`, Step 6) are STILL folded entirely from the
   > shards' own `outcomes.json` data (Step 3) and Step 6 STILL never
   > reads `MUTANT_COUNT` — this was true before round-4, is unaffected by
   > round-4's downgrade, and is unaffected by round-5's reversal. What
   > CHANGES under round-5 is that Step 6 is simply UNREACHABLE whenever
   > sub-invariant 8 fails (by design — that is what "hard fail" means) —
   > the independence claim is no longer "these two signals can disagree
   > and the gate still decides correctly," it is the simpler and
   > stronger "an incomplete/unreconciled mutant set is never allowed to
   > reach the kill-rate decision at all."

**Guard-test (sub-invariant 8):**
`test_mutants_aggregate_fails_closed_on_mutant_count_reconciliation_mismatch`
(round-1 name RESTORED, round-5 — round-4 had renamed this to
`..._reconciliation_mismatch_emits_non_blocking_warning` and inverted its
assertion to `rc == 0`; round-5 reverts BOTH the name and the body back to
round-1's original, since "fails_closed" is once again an accurate
description of this test's behavior). F4 constructs a fixture where the
synthetic `mutants-plan` pre-count is `MUTANT_COUNT=101` but the 8 shard
sentinels' pooled `caught + missed + timeout + unviable` sums to `100`
(one mutant "went missing" between plan and shard execution), with the
100 scored mutants' own `caught`/`missed`/`timeout` split constructed to
yield a pooled kill rate >= 90% (deliberately healthy-looking, so a
passing outcome cannot be attributed to a coincidentally-low kill rate)
— asserts the aggregator's stdout names both `101` and `100`, AND the
aggregator exits **1** — this is VP-008 in verification-delta.md.

Two guard-tests originally added in round-4 (`test_mutants_aggregate_
reconciliation_mismatch_does_not_mask_kill_rate_fail` / VP-022 and
`test_mutants_aggregate_reconciliation_mismatch_does_not_block_passing_
pr` / VP-023, §6.2 items 19-20 of architecture-delta.md) are RE-SCOPED
by round-5, not deleted — their original premise (Step 4 falls through to
Step 6 on a mismatch) no longer holds once Step 4 is a hard fail; Step 6
is now unreachable whenever sub-invariant 8 fails, so neither test can
still assert "the message names the kill-rate failure specifically." The
re-scoped pair below preserves the test-count contribution (2 tests, same
slots, same names retained for continuity) while asserting genuinely new,
non-redundant claims:

- `test_mutants_aggregate_reconciliation_mismatch_does_not_mask_kill_rate_
  fail` (VP-022, RE-SCOPED round-5 to the OVER-COUNT direction — the
  previously-untested half of the round-5 "exact equality, both
  directions" decision above). Fixture: `MUTANT_COUNT=100` but the 8 shard
  sentinels' pooled total sums to `101` (an OVER-count — the shard matrix
  examined and reported on one MORE mutant than `mutants-plan` counted as
  in-diff-scope), with the 101 scored mutants' `caught`/`missed`/`timeout`
  split constructed to yield a pooled kill rate >= 90% (deliberately
  healthy-looking, for the same reason as VP-008's fixture — a fail here
  must be attributable ONLY to the reconciliation mismatch, not to an
  incidental kill-rate failure). Asserts the aggregator exits **1** and
  its message names both `100` and `101` — proves the comparison is
  genuinely `!=` (both directions), not an accidental `<`-only check that
  would silently let an over-count "mask" as a pass because nothing in a
  naive `<`-only implementation would ever trip on it. The name is
  retained from round-4 for continuity with architecture-delta.md's
  numbering (item 19), even though the direction being tested has
  changed — its DOES-NOT-MASK framing still applies: an over-count must
  not be masked by, or mistaken for, a legitimate pass.
- `test_mutants_aggregate_reconciliation_mismatch_does_not_block_passing_
  pr` (VP-023, RE-SCOPED round-5 — the literal "invert to assert FAILS"
  the round-5 task brief calls for). Fixture: IDENTICAL to VP-008's
  restored fixture (`MUTANT_COUNT=101`, pooled `100`, the 100 scored
  mutants' split yielding a pooled kill rate >= 90% on the PARTIAL,
  incomplete set). Asserts the aggregator exits **1**, its message names
  the reconciliation mismatch (both `101` and `100`), and its stdout does
  **NOT** contain the Step 6 "gate passed" success message — proves that
  a healthy-looking kill rate on the scored SUBSET never rescues a
  dropped-mutant mismatch; completeness is required, not just quality of
  what happened to be examined. This is the direct behavioral inverse of
  round-4's version of this same test (which asserted exit 0 + the pass
  message WAS present for this exact fixture) — the fixture is reused
  deliberately (same "healthy partial kill rate" shape as VP-008) so the
  test suite has an explicit, named regression pin against ever
  re-introducing round-4's warning-only behavior by accident. The test's
  NAME (`..._does_not_block_passing_pr`) is now read as "does not
  [wrongly] treat a healthy-partial-kill-rate PR as passing" — F4 may
  rename it to something clearer (e.g. `test_mutants_aggregate_
  reconciliation_mismatch_fails_closed_despite_healthy_partial_kill_rate`)
  at implementation time if architecture-delta.md's numbering/naming
  discipline (CLAUDE.md test-naming convention: "a name asserting a
  guarantee its body doesn't check is a defect") is judged to require it
  — either name is acceptable to this spec as long as the BODY asserts
  exit 1 + reconciliation message + absent pass message; formal-verifier
  should pick one and keep it consistent with VP-023's write-up in
  verification-delta.md.

**Non-goal:** INV-AGG does not require bit-identical per-shard mutant sets
across re-runs; it requires only that whatever set each shard actually
examined is counted exactly once, summed correctly, reconciled against the
independent pre-count (sub-invariant 8), and gated at 90% on the pooled
total.

**Guard-test:** `test_mutants_aggregate_sums_not_averages_shard_kill_rates`
(new, `tests/ci_gate_completeness.rs` or a sibling file — see
`architecture-delta.md §Test-File Placement`). F4 must construct a synthetic
multi-shard fixture (mirroring `check-ci-gate.sh`'s `check_fixture` pattern,
adapted to jq/bash arithmetic over multiple files) where:
- Shard A: `caught=9, missed=1, timeout=0` (90% shard-local).
- Shard B: `caught=54, missed=36, timeout=0` (60% shard-local).
- A naive AVERAGE of (90%, 60%) = 75%, which is `>= 90`? NO — pick values
  where the naive-average result and the correct pooled result straddle the
  90% line in OPPOSITE directions, e.g.: Shard A `caught=9, missed=1` (90%,
  10 mutants) and Shard B `caught=90, missed=10` (90%, 100 mutants) — average
  of two 90%-shards is trivially still 90%, so this does NOT distinguish
  sum-vs-average. Use instead: Shard A `caught=99, missed=1` (99%, 100
  mutants) and Shard B `caught=1, missed=1` (50%, 2 mutants) — naive
  AVERAGE = (99+50)/2 = 74.5% (correctly fails either way, not a
  distinguishing case). The distinguishing construction must make the
  POOLED rate fail while at least one INDIVIDUAL shard's rate looks healthy
  in isolation, and vice versa is not required — concretely: Shard A
  `caught=9, missed=1` (10 mutants, 90%) and Shard B `caught=855, missed=95`
  (950 mutants, 90%) — POOLED = (9+855)/(10+950) = 864/960 = 90.0% (passes,
  correctly, since both shards are genuinely 90%). The ACTUAL adversarial
  construction that catches an averaging bug is asymmetric shard SIZE with
  asymmetric shard RATE: Shard A `caught=1, missed=0` (1 mutant, 100%,
  average-input "100") and Shard B `caught=80, missed=20` (100 mutants,
  80%, average-input "80") — naive AVERAGE = (100+80)/2 = 90% (PASSES under
  averaging) while POOLED = (1+80)/(1+100) = 81/101 = 80.2% (FAILS under
  summing, correctly, since 100 of the 101 total mutants came from the
  80%-shard). F4 must use this exact shape (or an equivalent one satisfying
  "naive average >= 90% AND pooled sum < 90%") and assert the aggregator
  FAILS (exit 1 / `kill_rate < 90` in its log output). Remaining 6 shards
  (2-7) contribute 0 mutants each (legitimate empty `--sharding slice`
  result); `MUTANT_COUNT=101` (matching the pooled total) so INV-AGG
  sub-invariant 8's reconciliation (VP-008) passes and does not mask this
  Guard-test's own signal.

**Round-7 addendum (LOW-2, floor-arithmetic correction — a fresh-context F2
adversary observed a single-direction fixture cannot distinguish "sums
correctly" from "merely fails whenever shards are asymmetric"; matches
`verification-delta.md`'s independently-maintained VP-001, which already
specified both directions — this Guard-test is now brought into agreement
with it, not introducing new content of its own).** The construction above
(Fixture 1A) is the PRIMARY false-green guard and is retained unchanged. A
SECOND, STRADDLING fixture is required alongside it, in the OPPOSITE
direction — naive averaging FAILS while the correct pooled sum PASSES —
so the pair together prove sum-vs-average distinguishability from BOTH
sides, not merely bias the aggregator toward failing on any asymmetric
shard split:
- **Fixture 1B (average FAILS, pooled PASSES):** Shard A `caught=1,
  missed=1` (2 mutants, 50%) and Shard B `caught=98, missed=2` (100
  mutants, 98%); shards 2-7 contribute 0 mutants each. Naive AVERAGE =
  (50+98)/2 = 74% — would FAIL under averaging. Correct POOLED =
  (1+98)/(2+100) = 99/102 ≈ 97.06% — PASSES. `MUTANT_COUNT=102` (matching
  the pooled total, for the same VP-008-non-masking reason as 1A). Assert
  the aggregator PASSES (exit 0 / `kill_rate >= 90` in its log output,
  specifically ~97%).

Both fixtures are co-located in the SAME `test_mutants_aggregate_sums_not_
averages_shard_kill_rates` `#[test]` function as two fixture CASES (per
`architecture-delta.md`'s "the count pins `#[test]` FUNCTIONS, not
fixtures" convention) — this does NOT add a new `#[test]` function, so
`EXPECTED_GUARD_TEST_COUNT` is unaffected by 1B's addition; it DOES add one
fixture to `scripts/mutants-aggregate.sh --self-test`'s own
`EXPECTED_MUTANTS_AGG_FIXTURES` denominator if F4 also mirrors this
scenario there (see `architecture-delta.md §6.2a`'s corrected floor).

---

## INV-COMPLETE — Sentinel-Based Fail-Closed Shard Accounting

> **Round-1 adversarial fix (CRIT-1 + HIGH-1).** This invariant is
> substantially redesigned from the F2 draft. The pre-fix version derived
> completeness directly from the COUNT of `outcomes.json` files that
> happened to show up — that proxy is exactly what a fresh-context
> adversary exploited: **CRIT-1 (false-green)** — all 8 shards crash inside
> `run-mutants` (which carries `continue-on-error: true`, so the JOB itself
> still reports `success` to GitHub Actions), zero shards upload
> `outcomes.json`, `actual_count == 0`, and the pre-fix design's
> `#shard_json_files -eq 0 → non-empty-diff → exit 0` branch fired,
> producing a GREEN gate with zero mutation coverage verified. **HIGH-1
> (false-red)** — a small PR (fewer than 8 in-diff mutants) legitimately
> leaves some shards with an empty `--sharding slice` and correspondingly
> no `outcomes.json`; the pre-fix INV-COMPLETE could not distinguish this
> from a crash and failed closed on routine, healthy small PRs. Both
> defects trace to the SAME root cause — no independent signal existed for
> "did this shard's `run-mutants` step actually run and what happened,"
> only an ambiguous absence of a downstream artifact — and are fixed
> together, below, by ONE mechanism: an always-written per-shard status
> sentinel.

**Statement.** Every one of the `N` declared shards (`N = 8`) **always**
uploads a small status sentinel artifact, `mutants-shard-status-<k>.json`,
via a dedicated `if: always()` step in the `mutants` shard job —
independent of whether `run-mutants` succeeded, failed, timed out, or
examined zero mutants, and independent of whether `mutants.out/
outcomes.json` exists. `mutants-aggregate` first asserts (**Part B**) that
EXACTLY `N` sentinels are present, one per index `0..N-1`, FAILING CLOSED
otherwise — this is the true completeness gate, since only a dead/
cancelled runner, or a failure in the sentinel-write step sequence itself,
can leave a sentinel absent. It THEN interprets (**Part C**) each present
sentinel to decide, per shard, whether that shard's data participates in
the pooled sum, contributes zero, or fails the whole aggregation closed.
Only after every shard is accounted for does it reconcile the pooled total
against `mutants-plan`'s independent pre-count (**INV-AGG sub-invariant
8**) and finally compute the kill rate.

### Part A — the sentinel write (per shard, `mutants` job)

New step, `if: always()`, placed AFTER the existing `Run mutation tests on
this shard` step (`id: run-mutants`, `continue-on-error: true` unchanged)
and BEFORE the existing `Upload shard outcomes` step:

```yaml
- name: Write shard status sentinel
  if: always()
  run: |
    HAS_OUTCOMES=false
    [ -f mutants.out/outcomes.json ] && HAS_OUTCOMES=true
    cat > "${{ runner.temp }}/shard-status-${{ matrix.shard }}.json" <<EOF
    {"shard_index": ${{ matrix.shard }}, "run_outcome": "${{ steps.run-mutants.outcome }}", "has_outcomes": ${HAS_OUTCOMES}}
    EOF

- name: Upload shard status sentinel
  if: always()
  uses: actions/upload-artifact@<CURRENT_SHA>  # pin per repo convention
  with:
    name: mutants-shard-status-${{ matrix.shard }}
    path: ${{ runner.temp }}/shard-status-${{ matrix.shard }}.json
    if-no-files-found: error  # the write step above ALWAYS produces this
                               # file on every reachable path (it has its
                               # own if: always() and contains no command
                               # that can fail under normal shell
                               # semantics) — its absence here signals a
                               # bug in THIS step sequence, not a
                               # legitimate shard outcome, so `error` (not
                               # `warn`) is correct here, unlike the
                               # outcomes.json upload below.
    retention-days: 1
```

**Load-bearing detail — `outcome` vs `conclusion`.** The sentinel reads
`steps.run-mutants.outcome`, NOT `steps.run-mutants.conclusion`. GitHub
Actions exposes both, and they diverge exactly when `continue-on-error` is
in play: `outcome` is the step's result BEFORE `continue-on-error` is
applied; `conclusion` is the result AFTER. Because `run-mutants` carries
`continue-on-error: true`, `conclusion` is ALWAYS `success` regardless of
what actually happened inside the step — reading `conclusion` here would
silently reintroduce CRIT-1 in a new form (the sentinel would lie the same
way the old design's absent-artifact proxy did). `outcome` is the one
context value that survives `continue-on-error` intact, and capturing it
truthfully is the entire point of this mechanism.

The existing `Upload shard outcomes` step is **unchanged**: `if: always()`,
`if-no-files-found: warn`, uploads `mutants.out/outcomes.json` under
`mutants-shard-outcomes-<k>`. It remains legitimately absent for an
empty-slice shard — the sentinel is what makes that absence
*interpretable* rather than ambiguous, not a replacement for it.

### Part B — sentinel-presence check (`mutants-aggregate`)

```
download all `mutants-shard-status-*` artifacts (merge-multiple: false, own subdir per shard)
EXPECTED_SHARDS=8   # MUST match `mutants`'s strategy.matrix.shard length —
                     # same "update both in the same commit" discipline as
                     # the pre-fix design; cross-checked structurally by
                     # test_mutants_aggregate_expected_shards_matches_matrix_shard_count
missing=()
for i in 0..EXPECTED_SHARDS-1:
    if sentinel file for index i is absent -> missing += i
if missing is non-empty -> FAIL, name the missing indices
actual_sentinel_count = count of sentinel files found
if actual_sentinel_count != EXPECTED_SHARDS -> FAIL (duplicate/stray sentinel)
```

This is now the SOLE fail-closed completeness gate. It no longer depends on
`outcomes.json` existing anywhere, and — this is the specific fix for
CRIT-1 — it no longer branches on "how many `outcomes.json` files exist" as
a completeness signal at all. That number is now purely a DATA signal,
consumed only in Part C below, after completeness has already been
established independently.

### Part C — per-shard interpretation (`mutants-aggregate`)

For each of the `EXPECTED_SHARDS` sentinels (now known, per Part B, to all
be present):

| `run_outcome` | `has_outcomes` | Interpretation |
|---|---|---|
| `success` | `false` | Legitimate zero-mutant shard (small-PR / uneven `--sharding slice` split). Contributes 0 to every pooled counter. **OK — this is what resolves HIGH-1.** |
| `success` | `true` | Normal case. Parse `outcomes.json` under the existing malformed-JSON / integer-validation / H-1 schema-drift / M-2 reconciliation guards (INV-AGG sub-invariants 3–6, unchanged), then fold into the pooled sums. |
| anything other than `success` (`failure`, `cancelled`, `skipped`) | `false` | Harness crash for that shard — `run-mutants` genuinely did not complete successfully and produced no usable output, but `continue-on-error: true` prevented that from surfacing as a job-level failure. **FAIL CLOSED, naming the shard index — this is what resolves CRIT-1.** Mirrors the pre-sharding single-job design's own discrimination between "the mutation run itself errored" (fail) and "the mutation run legitimately found nothing" (pass) — this table is that same call, made per shard instead of once. |
| anything other than `success` | `true` | `run-mutants` reported non-success (e.g. cargo-mutants' own exit code reflects a heavily-unviable run under `--baseline skip`) but still produced a well-formed `outcomes.json`. Trust the data: parse and fold in exactly as the `success`/`true` row — a non-zero cargo-mutants exit code is routine, expected behavior, not evidence the data is untrustworthy. |

**Restated as the exact rule:** `has_outcomes == true` always wins — parse
and fold the data regardless of `run_outcome`. Only when
`has_outcomes == false` does `run_outcome` decide FAIL (anything but
`success`) vs. OK-zero-contribution (`success`).

**Defensive cross-check (sentinel/data desync):** a sentinel claiming
`has_outcomes == true` is not itself proof the downloaded
`outcomes.json` is present and parseable (e.g. a partial artifact-upload
race). Part C's script MUST re-verify `-f "${f}"` and `jq empty "${f}"`
before trusting the sentinel's claim — falling through to the existing
malformed-JSON FAIL if either check fails, never silently treating a
sentinel-claims-true-but-file-absent shard as zero-contribution (that
would reopen a narrow variant of CRIT-1).

### Removed: the old count-based branch

The pre-fix design's base-ref-drift guard used
`#shard_json_files -eq 0` (the COUNT of downloaded `outcomes.json` files)
as a proxy for "did anything run at all." That branch is **deleted
outright, not patched** — it is exactly the proxy CRIT-1 exploited. The
base-ref-drift signal is preserved, but re-derived from data that cannot
lie the same way: **`MUTANT_COUNT == 0`** — `mutants-plan`'s own pre-count,
established BEFORE any shard runs, immune to a shard-level crash — is now
the discriminator, consulted only AFTER Parts B/C and INV-AGG sub-invariant
8 have already ruled out a crash, a missing shard, or a plan/execution
mismatch:

```
after Part B (presence) + Part C (interpretation) + INV-AGG sub-invariant 8 (reconciliation) all pass:
  if total_scored == 0:
    if OVERALL_DIFF_LINES == 0:
      FAIL — likely base-ref drift (empty diff; same F-3 signature as the pre-sharding design)
    else:
      OK — non-empty diff, MUTANT_COUNT was legitimately 0 (comment-only/
      whitespace/docs-only/non-examine_globs-scoped PR); sub-invariant 8
      already confirmed total_scored == MUTANT_COUNT == 0, so this state
      is not reachable via a crash — a crash would have failed Part C or
      sub-invariant 8 first
  else:
    proceed to killable / kill_rate computation as before
```

This directly satisfies "retire the `OVERALL_DIFF_LINES`-only discriminator
in favor of `MUTANT_COUNT`": `OVERALL_DIFF_LINES` is now consulted only to
disambiguate WHY the already-reconciled, already-trusted `MUTANT_COUNT` is
zero — it is never again the primary signal for whether shard output
exists or is trustworthy.

**Ordering is load-bearing:** presence (Part B) → interpretation (Part C)
→ reconciliation (INV-AGG sub-invariant 8) → base-ref-drift/zero-mutant
check → kill-rate. Each stage rules out a distinct failure class before
the next stage's simpler logic is allowed to assume that class cannot be
the explanation.

**Failure taxonomy (all fail-closed, all before the kill-rate arithmetic):**

| Condition | Outcome |
|---|---|
| Fewer than `EXPECTED_SHARDS` status sentinels present | FAIL — "N of 8 shard status sentinels present; missing: {indices}" |
| More than `EXPECTED_SHARDS` status sentinels present | FAIL — "duplicate/stray sentinel artifact; investigate re-run/name collision" |
| A present sentinel: `run_outcome != success` AND `has_outcomes == false` | FAIL — named shard, harness crash (**closes CRIT-1**) |
| A present sentinel: `run_outcome == success` AND `has_outcomes == false` | OK, contributes 0 to every pooled counter (**closes HIGH-1**) |
| A present sentinel claims `has_outcomes == true` but the corresponding `outcomes.json` is absent or fails `jq empty` at download time | FAIL — named shard, sentinel/data desync (defensive; see Part C) |
| A present, sentinel-confirmed `outcomes.json` fails `jq empty` | FAIL — INV-AGG's per-file malformed guard |
| `total_scored != MUTANT_COUNT` (INV-AGG sub-invariant 8) | FAIL — reconciliation mismatch, both numbers named |
| All shards accounted for + reconciled, `total_scored == 0`, `OVERALL_DIFF_LINES == 0` | FAIL — base-ref drift |
| All shards accounted for + reconciled, `total_scored == 0`, diff non-empty | OK — zero in-scope mutants |
| All shards accounted for + reconciled, `killable == 0` (all unviable) | OK |
| All shards accounted for + reconciled, `kill_rate >= 90` | OK |
| All shards accounted for + reconciled, `kill_rate < 90` | FAIL |

**Guard-tests (revised & new, round-1 adversarial fix):**
- `test_mutants_aggregate_fails_closed_on_missing_shard` (MODIFIED — the
  fixture now omits a status SENTINEL for shard index 3 of 8, not an
  `outcomes.json`; unchanged mid-range-index rationale — not an edge like 0
  or 7, to prove the check isn't accidentally anchored to a boundary).
- `test_mutants_aggregate_fails_closed_on_duplicate_shard_artifact`
  (MODIFIED — duplicates a status SENTINEL, not an `outcomes.json`).
- `test_mutants_aggregate_fails_closed_when_all_shards_crash_under_
  continue_on_error` (NEW — the direct CRIT-1 regression proof: all 8
  sentinels present, ALL reporting `run_outcome=failure`,
  `has_outcomes=false`, simulating every shard's `run-mutants` step
  crashing while `continue-on-error: true` masks it at the job level;
  asserts the aggregator exits 1 and its message identifies a harness
  crash — never the removed "0 artifacts + non-empty diff" false-green
  path).
- `test_mutants_aggregate_ok_when_shards_are_legitimately_empty` (NEW — the
  direct HIGH-1 regression proof: e.g. 3 of 8 sentinels report
  `run_outcome=success`, `has_outcomes=false` [empty `--sharding slice`],
  the other 5 report real data whose pooled sum equals `MUTANT_COUNT`;
  asserts the aggregator exits 0 and never names any shard as missing or
  failed).
- `test_mutants_aggregate_fails_closed_on_mutant_count_reconciliation_
  mismatch` (NEW — INV-AGG sub-invariant 8; see that section for the exact
  fixture shape).

---

## INV-ESCALATE — Escape-Hatch Fail-Closed-Safe Encoding

**The crux problem.** `scripts/check-ci-gate.sh`'s `evaluate_needs()` has
exactly three outcomes for any `ci-gate.needs` member: `success` (pass),
`skipped` IF the job is in `ALLOWED_SKIPS` (pass), or anything else —
`failure`, `cancelled`, an unlisted `skipped`, or a future unknown value —
(fail, via the default arm). GitHub Actions itself has **no native "neutral,
not red" conclusion** for a job in this required-check sense (that concept
exists only for GitHub App check-runs, not plain `needs`-based required
jobs — confirmed in the F1 delta analysis, Risk #6). A "large diff, escalate
to human, don't hard-block" requirement therefore has no vocabulary slot to
occupy without either (a) silently degrading to `success` (indistinguishable
from a genuine 90%+ pass — the worst possible outcome, since it is a
false-green by construction) or (b) silently degrading to an allowlisted
`skipped` (which, per the same fail-closed design, means EVERY large-diff PR
skips the gate entirely with no verification at all — not "escalating with a
human ack," just quietly not gating).

### Recommended encoding — INV-ESCALATE

**Escalation is encoded as an ordinary `failure`, never `skipped` and never
`success`.** When `mutants-plan`'s pre-count (`cargo mutants --list --in-diff
"$DIFF_FILE" | wc -l`) exceeds the threshold (~120 mutants — see
`architecture-delta.md §Threshold Derivation`):

1. `mutants-plan` sets `escalated=true` as a job output but does **not**
   itself fail (it successfully determined the diff is oversized — that is
   correct, expected behavior for the planning step, not an error).
2. The `mutants` shard matrix is **skipped entirely** (`if:` includes
   `needs.mutants-plan.outputs.escalated != 'true'`) — no CI minutes spent on
   a run whose result will be discarded regardless.
3. `mutants-aggregate` (`if: always()`, so it runs regardless of the shard
   matrix having been skipped) detects `escalated == 'true'` as its FIRST
   check, before even looking for shard artifacts, and **exits 1** (failure)
   with an actionable message:

   ```
   FAIL: PR generates <N> in-diff mutants, over the 120-mutant threshold for
         the sharded per-PR gate (8 shards × --timeout 240 comfortably covers
         ~120 mutants in ~1h; more risks re-hitting the original wall-clock
         problem this sharding design exists to solve).

         Two ways forward:
         1. PREFERRED: split this PR into smaller, more focused changes so
            each generates fewer in-diff mutants (mirrors the existing
            Oversized-Diff Signal guidance for the pre-sharding single-job
            design — see docs/specs/cargo-mutants-policy.md).
         2. If this diff is genuinely large and reviewed, and mutation
            coverage cannot practically be verified per-PR, a repo admin can
            merge via GitHub's branch-protection "Require approvals" bypass,
            explicitly acknowledging the unverified mutation coverage in the
            PR description — the SAME documented, audited mechanism already
            used for a budget-exceeded `cancelled` mutants run (see
            docs/specs/cargo-mutants-policy.md §F-2). This is a human,
            out-of-band, GitHub-audited action — not something this CI job
            can grant itself.

         A full, non-diff-scoped run of this code will also occur in the
         next scheduled nightly full-mutation run (see
         .github/workflows/mutants-nightly.yml) regardless of how this PR is
         merged.
   ```

4. `ci-gate` therefore FAILS (via `check-ci-gate.sh`'s ordinary `failure`
   branch — no `ALLOWED_SKIPS` involvement at all), blocking the PR from
   merging through the normal required-check path.
5. The "human ack" is the **existing, already-documented, already-audited
   GitHub branch-protection admin bypass** (`Require approvals` override on
   a protected branch) — not a new CI mechanism. Using an override is itself
   visible in GitHub's PR timeline/audit log (who bypassed, when), and the
   PR description is expected to record the explicit acknowledgment, exactly
   as `docs/specs/cargo-mutants-policy.md §F-2` already prescribes for the
   `cancelled` case. **No new `ALLOWED_SKIPS` entry, no new PR-label
   listener workflow, and no new `ci-gate.needs` member is introduced by
   this mechanism.**

### Why this is fail-closed-safe

- **Default state is FAIL, not a new neutral status.** An escalated PR
  cannot merge through the ordinary required-check path under any
  circumstance this script controls — it can only merge through GitHub's own
  pre-existing, separately-audited bypass surface, which this design does
  not touch, weaken, or automate.
- **No vocabulary expansion of `evaluate_needs()`.** `scripts/check-ci-gate.sh`
  needs ZERO changes to support this encoding — `failure` was already a
  first-class, correctly-handled outcome before this cycle. This is the
  single biggest argument in its favor: it adds a new BEHAVIOR without
  adding a new CODE PATH to the fail-closed decision function, which is
  exactly the surface this repo's CI-gate history (16+ documented
  adversarial rounds, CLAUDE.md) treats as maximally dangerous to touch.
- **Indistinguishable-from-genuine-failure is the point, not a flaw.** A
  human reviewing a failed `ci-gate` check cannot tell, from the check alone,
  whether it failed because kill-rate genuinely dropped below 90% or because
  the diff was escalated — they must read the `mutants-aggregate` job's own
  log (linked directly from the failed check) to find out. This is
  acceptable because BOTH cases have the identical correct remedy shape
  ("this PR cannot auto-verify mutation coverage — either fix it or have a
  human explicitly accept the risk"), and conflating them costs nothing a
  human reading the log doesn't immediately resolve.

### Considered-and-rejected alternative encodings

**(b) — Run the full non-diff set inline across the shards under the same
≥90% gate, no neutral state at all (the alternative explicitly named in this
document's brief).** REJECTED. This recreates exactly the problem this whole
cycle exists to solve: the full `examine_globs` scope (22 files, several
individually at ~90-99 mutants each) is materially larger than the 281-mutant
PR that triggered this cycle — even at 8-way sharding and `--jobs 2`, a
full-scope run risks re-hitting a multi-hour wall-clock ceiling, now on a
`>120`-mutant PR instead of an unbounded one. It also does not actually
resolve the "neutral status" ambiguity the crux names — it is still a binary
pass/fail decision at a larger multiplier, with no human-ack step at all,
which was an explicit requirement in the F1 delta analysis's framing of the
escape hatch ("routes to a neutral status... not a red block").

**(a-bis) — A dedicated PR-label / re-run-dispatch "human-ack-required"
mechanism (a new `ci-gate.needs` member, e.g. `mutation-escalation-ack`, that
starts `failure`-by-default and flips to `success` only once a maintainer
applies a specific label and the job re-runs).** CONSIDERED, NOT
RECOMMENDED. This is a real, implementable alternative — and closer to a
literal reading of "human ack, recorded, auditable" than reusing the generic
branch-protection bypass — but it:
- Adds a NEW `ci-gate.needs` member, meaning it needs its own
  `PINNED_ALWAYS_RUN_JOB_KEY_SETS`/`PINNED_ALWAYS_RUN_STEP_KEY_SETS` (or
  skip-tolerant) pin, its own `ALLOWED_SKIPS`/`PINNED_ALLOWED_SKIP_IF_
  EXPRESSIONS` entry (since it must legitimately report something
  other than `success` before the label is applied — likely `skipped` if
  gated on `github.event.label.name == 'mutation-escalation-ack'` for a
  `labeled` event trigger), and its OWN adversarial-review surface — this is
  new attack surface on the fail-closed gate, the exact kind of thing this
  repo's CI-gate history treats as costly to introduce.
- Requires a SEPARATE `pull_request` event type (`labeled`) to be added to
  `ci.yml`'s `on:` block or a second workflow, with its own re-run semantics
  (GitHub Actions does not automatically re-evaluate an existing job's `if:`
  when a label is added — a genuinely NEW workflow run must be triggered),
  adding real design/implementation complexity for a capability the existing
  branch-protection bypass already provides.
- Provides marginal benefit over the recommended encoding: GitHub's own
  bypass mechanism is ALREADY auditable (PR timeline shows who bypassed
  branch protection and when) and ALREADY documented in this repo's policy
  for the structurally identical `cancelled`-at-240-minutes case. A second,
  parallel "ack" mechanism for a sibling failure mode invites the two to
  drift out of sync over time.

**Recommendation: use the primary encoding (ordinary `failure` + existing
branch-protection bypass as the human-ack channel).** Revisit (a-bis) only if
operational experience shows the branch-protection bypass is too coarse
(e.g., admins want to grant a specific PR an escalation waiver without
granting general "Require approvals" override power) — that is a genuine,
but currently hypothetical, gap.

### Threshold derivation (~120 mutants)

Carried from the F1 delta analysis / research grounding
(`.factory/research/mutation-testing-ci-large-changes-2026-09-07.md §
Recommended Approach, Step 3`): at `N=8` shards, `--jobs 2`, and the measured
~140s/mutant median (per `docs/specs/cargo-mutants-policy.md §CI Budget
Model`), 120 mutants ÷ 8 shards ≈ 15 mutants/shard ≈ 15 × 140s ≈ 35 minutes —
comfortably inside a `timeout-minutes: 60`-per-shard budget with headroom for
the ~5-minute per-shard startup cost. This value is a human-set, reviewed
literal in `mutants-plan`'s script (`ESCALATION_THRESHOLD=120`) — not derived
from any config file — and should be revisited empirically after this design
runs against a handful of real PRs (per-mutant throughput on the actual
sharded topology may differ from the extrapolation above, which is based on
single-job `--jobs 4` measurements).

### Residual risk flagged for F5 scoped adversarial review

1. **The pre-count step itself (`cargo mutants --list --in-diff | wc -l`) is
   a NEW, untested-at-this-repo invocation shape.** Verify it does not
   itself have a pathological runtime on a very large diff (the research
   brief did not measure `--list`'s own cost separately from a full run) —
   if `--list` is meaningfully slower than expected on the exact diff that
   would trigger escalation, the pre-count step could itself become a new
   timeout risk. Recommend `mutants-plan` carry its own conservative
   `timeout-minutes` (e.g. 15) independent of the shard/aggregate budgets,
   so a pathological `--list` invocation fails visibly rather than silently
   consuming the whole job's budget.
2. **`needs.mutants-plan.outputs.escalated` is a STRING `'true'`/`'false'`,
   not a boolace.** Every consuming `if:` must compare with `!=  'true'` /
   `== 'true'` string equality — a bare truthy/falsy GitHub Actions
   expression evaluation of an arbitrary string is a known footgun class
   (empty string is falsy, but the string `'false'` is TRUTHY in GitHub
   Actions expression semantics) — F4 must never write `if:
   needs.mutants-plan.outputs.escalated` bare; always the explicit string
   comparison. Flag this explicitly for adversarial review since it is
   exactly the shape of subtle bug this repo's CI-gate history keeps
   finding.
3. **(Round-1, LOW, style) `mutants-aggregate`'s job-level `if:` must be
   written bare — `if: always()` — never braced as `if: ${{ always() }}`.**
   `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS`'s pinned literal for this job is
   the bare text `"always()"` (`architecture-delta.md §6.2`), compared via
   `extract_and_normalize_if_expr`'s byte-for-byte, no-semantic-unwrapping
   contract. `ci-gate`'s own job-level `if:` happens to use the BRACED form
   (`if: ${{ always() }}`, itself separately pinned as `PINNED_GATE_IF_EXPR`
   with braces) — these are two different jobs with two independently
   pinned literals that are not required to match each other's style, but
   the two forms look interchangeable to a human copying one job's
   convention onto the other and are NOT byte-identical to the checker.
   F4 must write the bare form on `mutants-aggregate` specifically, exactly
   as shown throughout `ci-yml-design.md`'s pseudo-YAML (which already uses
   the bare form) — do not "fix" it to match `ci-gate`'s braced style, and
   do not assume the two are interchangeable just because they are
   semantically identical GitHub Actions expressions.
4. **(Round-1, LOW, documentation hygiene) The `ESCALATION_THRESHOLD=120`
   literal's derivation lives in exactly one place** —
   `mutants-sharding-invariants.md §Threshold derivation` (this document) —
   and `ci-yml-design.md`'s `mutants-plan` step comment intentionally only
   cross-references it rather than re-deriving the arithmetic inline. If
   this value is ever revisited (per the empirical-recheck note in
   §Threshold derivation), update the derivation prose in THIS document
   first, then update the `ESCALATION_THRESHOLD=120` literal in
   `ci-yml-design.md` in the SAME commit — mirroring the `EXPECTED_SHARDS`/
   matrix-length discipline used throughout this cycle, even though (per
   §6.2's "considered and declined" list) no structural Rust-side test
   pins this specific literal.
5. **What happens if `mutants-plan` itself fails outright** (not
   "escalated" — a genuine crash: checkout failure, cargo-mutants install
   failure) **is NOT specially detected by INV-ESCALATE — it falls through
   to INV-COMPLETE instead** (the shard job's `if:` still evaluates true on
   a PR event since `needs.mutants-plan.outputs.escalated` is unset/empty
   which is `!= 'true'`, shards attempt to download a diff-file artifact
   that was never uploaded, each shard's download step fails, zero valid
   shard artifacts materialize, and `mutants-aggregate`'s INV-COMPLETE guard
   correctly fails closed with a "missing shards" message rather than a more
   direct "upstream plan job failed" message). This is CORRECTNESS-SAFE
   (the gate still fails, never silently passes) but is a UX/diagnostics
   gap — recommend `mutants-aggregate` ALSO directly check
   `needs.mutants-plan.result != 'success'` as an earlier, clearer
   short-circuit before falling into the generic INV-COMPLETE path. F4
   should implement this as a diagnostics improvement; it is not required
   for fail-closed correctness, since INV-COMPLETE already covers it.
   **(Round-1 note, unchanged by round-2): this diagnostic short-circuit
   IS implemented in `ci-yml-design.md §3` Step 0.5 — `mutants-aggregate`
   checks `PLAN_RESULT != "success"` before touching any shard artifact.**
   Round-2's `--list`-exit-status hardening (item 6 below) means a
   genuine `--list` tooling failure now ALSO trips this exact Step 0.5
   short-circuit (via `mutants-plan`'s own job going to `failure`),
   rather than silently degrading `MUTANT_COUNT` to `0` and being caught
   only much later, if at all, by sub-invariant 8's reconciliation.
6. **(NEW, round-2, MEDIUM-2) INV-AGG sub-invariant 8's reconciliation
   coverage is narrower than "catches every mismatch" — see the "Round-2
   adversarial fix" callout under sub-invariant 8 above for the full
   account.** Two distinct residuals, only one of which is closeable:
   - **Closed this round:** `mutants-plan`'s `--list --in-diff` step no
     longer swallows its own exit status into a silently-wrong
     `MUTANT_COUNT=0` (`ci-yml-design.md §1`) — a genuine `--list` tooling
     failure now fails the `mutants-plan` job closed instead.
   - **NOT closed, explicitly accepted as residual, flagged for F5/F6
     re-examination:** reconciliation cannot detect a common-mode error in
     the single shared `mutants-diff-file` artifact itself (both
     `MUTANT_COUNT` and every shard's actual mutant set are derived from
     the identical bytes) — the nightly full-scope run (which does not
     depend on `DIFF_FILE` at all) is the only backstop for this specific
     class, with up-to-24h lag and advisory-only severity.
   Do not treat sub-invariant 8 as a complete substitute for periodic
   full-scope verification — it was never designed to be one, and this
   round's fix makes that explicit rather than assumed.
