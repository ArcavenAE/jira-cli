---
document_type: architecture-delta
feature_name: "mutants-ci-sharding"
cycle: cycle-006
created: 2026-09-07
status: draft
author: architect (vsdd-factory)
traces_to: .factory/phase-f1-delta-analysis/cycle-006/delta-analysis.md
companion_docs:
  - .factory/phase-f2-spec-evolution/cycle-006/mutants-sharding-invariants.md
  - .factory/phase-f2-spec-evolution/cycle-006/ci-yml-design.md
revision_note: "Round-9 adversarial fix (F2 fresh-context review, ninth
  pass / adversary pass 13) — ONE LOW loop-breaker closed (LOW-1) plus one
  bookkeeping correction (LOW-2). **LOW-1 (PRIMARY) — the round-8
  'declined env-value pin' rationale for `MUTANT_COUNT` was CIRCULAR
  under the very env-edit threat model F-H1 (round-8) itself adopted.**
  Since Step 4 reconciliation is keyed on `total_scored != MUTANT_COUNT`,
  a PR that simply hardcodes the eval step's `MUTANT_COUNT:` env value to
  equal whatever real total the pooled shards will produce makes
  reconciliation pass trivially — disabling sub-invariant 8 (the
  completeness guard) via the exact same class of attack F-H1 closed for
  `STATUS_DIR`/`SHARD_DIR` one round earlier: the pre-round-9 declination
  cited a RUNTIME backstop (reconciliation) as justification for skipping
  a STRUCTURAL pin, without noticing the runtime backstop itself reads a
  value the structural layer left unpinned. Bounded LOW (not HIGH like
  F-H1) only because `MUTANT_COUNT` is a single plaintext, PR-visible
  integer with no directory-redirect blast radius — but the reasoning gap
  is the SAME class, and this file's round-8 loop-breaker mandate was
  itself supposed to catch exactly this. **Fix — eliminate the 'declined
  env-value pin' class entirely, not just this one instance:** all THREE
  previously-declined eval-step env values (`MUTANT_COUNT`,
  `OVERALL_DIFF_LINES`, `PLAN_RESULT`) now carry byte-VALUE structural
  pins, via the SAME generic byte-exact env-child-value technique items
  10/12/23/24 already established (zero new `wf.rs` code): `PINNED_
  MUTANTS_AGGREGATE_MUTANT_COUNT_LINE` (`${{ needs.mutants-plan.outputs.
  mutant_count }}`), `PINNED_MUTANTS_AGGREGATE_OVERALL_DIFF_LINES_LINE`
  (`${{ needs.mutants-plan.outputs.overall_diff_lines }}`), and `PINNED_
  MUTANTS_AGGREGATE_PLAN_RESULT_LINE` (`${{ needs.mutants-plan.result
  }}`), enforced by three new tests (items 25-27, §6.2). ALL SEVEN of
  `mutants-aggregate`'s eval-step env values now carry BOTH a key-set pin
  (item 15, `PINNED_MUTANTS_AGGREGATE_ENV_KEYS`) AND an individual
  byte-VALUE pin — the 'declined env-value pin' row is retired from the
  §6.8 M2-n disposition, the Declination re-audit table, and the
  declined-additions bullet in §6.2a: those three rows move from DECLINED
  to MIRRORED, closed by construction rather than accepted as a residual.
  `EXPECTED_GUARD_TEST_COUNT: 62 -> 65`. **LOW-2 (bookkeeping)** — the
  round-3 history-log note ('Fixture 14 gains a message-substring
  assertion,' §6.5's 'Numbers after this round' paragraph) implicitly
  relied on Fixture 14 already existing, but that same paragraph's OWN
  `EXPECTED_FIXTURES` accounting mislabeled the round in which Fixture 14
  was actually CREATED: round-1 (§6.1's 'NEW Fixture 14' table row,
  `EXPECTED_FIXTURES` `13 -> 14`) is where the real baseline-13-to-14
  transition happens, but the round-1 'Numbers after this round' summary
  had described it as 'unchanged at 14' — as if Fixture 14 already
  existed before round-1 ran. Every LATER round's 'unchanged at 14'
  wording (rounds 2-8) is correct as written (no new fixture added in
  those rounds); only the round-1 summary paragraph itself was wrong,
  and is corrected in place (§6.5) to read `13 -> 14 (new Fixture 14,
  §6.1)`.
  Round-8 adversarial fix (F2 fresh-context review, eighth
  pass / adversary pass 11) — ONE HIGH false-green found and closed
  (F-H1), plus a systematic re-audit of every §6.8/§6.11 declined/N-A/
  accepted-residual row (the 'loop-breaker' pass this round's task brief
  required, given F-H1 itself originated as a declined row resting on
  faulty reasoning). **F-H1 (HIGH) — the §6.8 M2-n row's disposition for
  `STATUS_DIR`/`SHARD_DIR` rested on a faulty argument, not a sound one:**
  it claimed bash's `${VAR:?message}` operator (§6.2a) is 'stronger than
  any static pin could assert' — true only for the UNSET/EMPTY failure
  mode `:?` actually guards, and false for the failure mode that matters
  here, a maliciously-but-VALIDLY-SET redirect. `mutants-aggregate.sh`
  reads its ENTIRE evidence set — every shard status sentinel and every
  outcomes.json — through these two paths; a PR that edits the eval
  step's `env:` block to point `STATUS_DIR`/`SHARD_DIR` at attacker-
  supplied directories, then checks in fabricated sentinels + outcomes.json
  reporting `missed=0` and `caught=MUTANT_COUNT` (a deterministically
  knowable target since `MUTANT_COUNT` is itself a plaintext PR-visible
  env value), passes `:?` (both vars are non-empty), passes every existing
  key-set/run-line/node-property pin (none of them inspect env VALUES for
  these two keys), and produces a 100%-caught false PASS while every real
  shard result is silently ignored — the exact `NEEDS_JSON`-class
  vulnerability M2-n exists to close for `ci-gate`, left open here by a
  description of `:?` that overstated what it defends against. **Fix:**
  two new byte-VALUE structural pins, `PINNED_MUTANTS_AGGREGATE_STATUS_
  DIR_LINE` (`${{ runner.temp }}/shard-status`) and `PINNED_MUTANTS_
  AGGREGATE_SHARD_DIR_LINE` (`${{ runner.temp }}/shards`), enforced by two
  new tests (items 23-24, §6.2) reusing the SAME generic byte-exact env-
  value extractor items 10/12 already use for `ESCALATED`/`EVENT_NAME` —
  zero new `wf.rs` code. `EXPECTED_GUARD_TEST_COUNT: 60 -> 62`. The M2-n
  row (§6.8) and the declined-additions bullet (§6.2a) are corrected in
  place, not merely appended to — the FAULTY claim about `:?` is removed,
  not left alongside a contradicting fix. **Declination re-audit (the
  'loop-breaker' requirement) — every OTHER §6.8/§6.11 declined/N-A/
  accepted-residual row was independently re-verified against the SAME
  failure mode (a weaker guarantee described as stronger, or a claim that
  silently over-reaches its actual scope) and found SOUND, with two
  rationales STRENGTHENED (not merely re-confirmed) by this round's own
  fix:** `MUTANT_COUNT`'s reconciliation-based backstop (already declined
  as 'stronger than a string-match') is now verifiably true rather than
  merely asserted — its soundness was ITSELF silently conditional on
  `STATUS_DIR`/`SHARD_DIR` being trustworthy (an attacker who could
  redirect the evidence directories could fabricate the reconciliation
  data too), a dependency this round's fix now closes structurally rather
  than leaving implicit. `PLAN_RESULT`'s declined byte-pin is confirmed
  sound via a newly-traced interlock, not asserted: a hardcoded `PLAN_
  RESULT: \"success\"` literal cannot manufacture a false PASS on its own,
  because a genuinely-failed `mutants-plan` prevents the `mutants` shard
  matrix job from running at all under GitHub Actions' default `needs:`
  semantics (no `always()` override on that job) — Step 2's sentinel-
  presence check independently fails closed against the resulting
  genuinely-absent artifacts, and (post this round's fix) an attacker can
  no longer paper over that absence by also redirecting `STATUS_DIR`/
  `SHARD_DIR`. `OVERALL_DIFF_LINES`'s declined byte-pin is SOUND as
  narrowly worded (its 'inherently fail-closed' claim was always scoped to
  malformed/empty-value handling only, never claimed redirect-immunity,
  so it does not share F-H1's overclaim) but its wording is tightened in
  place (§6.2a) to state the scope explicitly rather than by omission, and
  a genuine, LOW-severity, EXPLICITLY-ACCEPTED residual is now named for
  the first time: a hardcoded nonzero value can only ever convert an
  already-reconciled-to-zero PR's base-ref-drift FAIL into a legitimate-
  zero-mutants OK (Step 5) — it can never influence Step 6's kill-rate
  computation or forge a PASS on a PR with real surviving mutants, so it
  is accepted on the same review-time-control precedent this document
  already applies to the `cargo-mutants@27.1.0` and `ESCALATION_
  THRESHOLD=120` literals, not silently declined. No other §6.8/§6.11 row
  rests on a faulty argument — the full per-row re-verification is
  recorded in §6.8's new 'Declination re-audit (round-8)' table. **Count-
  consistency fold-in (pass-10 LOW-1):** two stale running-total spots
  flagged by the immediately-prior pass are corrected in the SAME change
  as this round's own count bump — the §6.2 'NEW #[test] functions' header
  ('20 total... 38 -> 58') and item 5's history-log instruction (missing a
  round-7 entry) now both read through round-8 consistently; see §6.2/§6.8
  for the exact text.
  Round-7 adversarial fix (F2 fresh-context review, seventh
  pass) — the FALSE-GREEN mandate is again declared CLEAN (aggregator
  control flow confirmed fail-closed, no new false-green/false-red); one
  new MEDIUM found and closed, plus two bookkeeping corrections (LOW-1,
  LOW-2) forced by it. **MED-1 (the headline finding) — §6.8 mirrored
  `ci-gate`'s RUST STRUCTURAL pins onto `mutants-aggregate` (round-4) but
  NEVER mirrored `check-ci-gate.sh`'s SCRIPT-LEVEL RUNTIME hardening**
  (the PATH-shim-resistant `resolve_trusted_jq` machinery, `set -euo
  pipefail`, the pure-bash-dirname anti-shim fix, the fail-closed
  default-arm posture) — `mutants-aggregate.sh` called `jq` bare
  everywhere, meaning a `$GITHUB_PATH`-prepended jq shim could forge the
  mutation-gate decision the exact same way S-626-1 pass-59 fixed for
  `ci-gate` itself. Closed by NEW §6.11 (\"Runtime hardening parity with
  check-ci-gate.sh\"): every runtime defense on `check-ci-gate.sh`'s
  decision path is enumerated and given its exact `mutants-aggregate.sh`
  analog, via a NEW shared, sourced library file, `scripts/lib/
  trusted-jq.sh` (extracted from `check-ci-gate.sh`'s existing
  `resolve_trusted_jq`/`is_trusted_jq_dir`/`trusted_jq_dirs_for` — see
  ci-yml-design.md §3a for the extracted content and `check-ci-gate.sh`'s
  own required companion change), so a future jq-trust fix cannot land in
  one decision-path script and be forgotten in the other. Two NEW Rust
  guard tests (items 21-22, §6.2/§6.11) prove BOTH scripts source the
  shared file and contain no un-resolved bare `jq` invocation on their
  decision paths — `EXPECTED_GUARD_TEST_COUNT: 58 -> 60`.
  **LOW-1 (doc-obligation correction)**: the round-6 L-2 note's F4
  doc-obligation (CLAUDE.md's CI-Gate review-scope enumeration grows by
  one file, \"four\" -> \"five\") must now grow by TWO — `scripts/
  mutants-aggregate.sh` AND the new `scripts/lib/trusted-jq.sh` — both are
  PR-editable, on the decision path, and self-referential in exactly the
  sense CLAUDE.md's existing note already describes for the other four/
  five. Updated in place below (\"four\" -> \"six\"). **LOW-2
  (floor-arithmetic undercount)**: §6.2a's `EXPECTED_MUTANTS_AGG_FIXTURES`
  floor derivation (\"2 header + 1 per item among 1/2/3/6/7/8 + 2 for
  19/20 = 10\") undercounted on two independent grounds: (a) item 1
  (`test_mutants_aggregate_sums_not_averages_shard_kill_rates`) needs a
  STRADDLING PAIR of fixtures, not one — a single-direction construction
  cannot distinguish \"sums correctly\" from \"merely fails whenever
  shards are asymmetric\" (mutants-sharding-invariants.md's own round-7
  addendum adds fixture 1B for exactly this reason, matching
  verification-delta.md's independently-maintained VP-001, which already
  specified both directions); (b) the formula never counted the
  Step-0.5 `PLAN_RESULT != \"success\"` fixture (the `--list`
  tooling-error hardening's landing site, VP-013's companion) at all — it
  is a real, distinct, required fixture on this same harness that simply
  never appeared as a term in the old formula. Recomputed floor: `10 -> 12`
  (`+1` for fixture 1B, `+1` for the previously-uncounted Step-0.5
  fixture). Still a PROVISIONAL floor, F4-finalized against the
  fixed-denominator self-check pattern `EXPECTED_FIXTURES` already
  establishes — not a claim that 12 is exact, only that 10 was a KNOWN
  undercount and must not ship as the stated floor. (\"item 2 (VP-002)
  covers BOTH missing AND duplicate sentinel\" — raised alongside this
  finding — is confirmed to be ALREADY correctly counted: items 2 and 3
  in the pre-existing formula are the missing-shard and duplicate-shard
  fixtures respectively, already two separate terms in the \"6\" for
  items 1/2/3/6/7/8; no additional undercount there.) Neither LOW
  correction changes any invariant statement or decision-path LOGIC —
  both are bookkeeping/doc-fidelity fixes forced by the MED-1 finding and
  its own honest-accounting requirement. Round-6 adversarial fix (F2
  fresh-context review, sixth
  pass) — the FALSE-GREEN mandate is declared CLEAN this round (no new
  false-green or false-red found in round-5's reversal); two residual,
  non-false-green items are closed. **L-1 (LOW, stale doc)**: §6.2a
  carried a paragraph (\"Round-4 note on item 8's fixture specifically\")
  that was never updated when round-5 reverted the reconciliation
  hard-fail — it still described the round-4 warning-only fixture shapes
  (`rc=\"pass\"` + `::warning::`) as if operative. Rewritten in place to
  state the round-5 fixture shapes (all three `rc=\"fail:1\"`, per item
  8/9's restored fixture and items 19/20's re-scoped fixtures) — see
  §6.2a below. **M-1 (MEDIUM, false-RED risk on an unverified premise)**:
  the restored hard fail (§6.10) still rests on an empirically-unverified
  `--list`⇔pooled-`--shard --sharding slice` partition premise; round-6
  strengthens the mitigation from \"F4 should verify at some point\" to a
  NAMED, BLOCKING F4 precondition — a scratch-run verification performed
  DURING F4, BEFORE cycle-006's own PR merges (not deferred to discovery
  on PR #778, which remains the first REAL production-scale exercise, not
  the sole verification point). See the new \"F4 Blocking Preconditions\"
  list in §1 and the revised empirical-premise paragraph in §6.10.
  Neither change alters `EXPECTED_GUARD_TEST_COUNT` (`58`) or
  `EXPECTED_MUTANTS_AGG_FIXTURES` (`10`) — both are documentation-fidelity
  and mitigation-strengthening fixes, not new test/fixture slots.
  Round-5 adversarial fix (F2 fresh-context review, fifth
  pass) — REVERSES round-4's F2 rollout-policy finding; round-4's other
  finding (§6.8 structural-peer enumeration) is UNCHANGED and UNAFFECTED.
  A fifth fresh-context adversary confirmed round-4's structural-peer
  work and the aggregator's core arithmetic remain sound, but identified
  that round-4's OWN rollout-policy choice (Option A: downgrade INV-AGG
  sub-invariant 8's pooled-total <-> MUTANT_COUNT reconciliation from a
  hard `return 1` to a non-blocking `::warning::`) introduced a NEW
  MEDIUM false-green: it disables the only guard this cycle has for
  mutants silently vanishing between plan and shard execution — if the
  dropped mutants happen to be survivors, the pooled kill rate on the
  smaller, incomplete scored set can read `>= 90%` while the true,
  complete set would not have. Round-5 reverses round-4's Option A and
  adopts round-4's own previously-documented Option B (keep the hard
  fail; handle the empirical-premise risk via a mandatory F4
  determination task rather than a permissive rollout window) as the new
  default. Exact equality is retained (both `total_scored < MUTANT_COUNT`
  and `total_scored > MUTANT_COUNT` fail), not narrowed to a directional
  `>=` — see §6.10 for the full justification. The empirical-premise
  risk is handled by anchoring F4's mandatory verification on **PR #778**
  (281 mutants) as the natural first live exercise of a nonzero
  reconciliation, since cycle-006's own landing PR is CI/doc-only
  (~0 `src/` mutants) and structurally cannot exercise this path itself.
  This round also RE-SCOPES the two round-4 kill-rate/reconciliation
  'independence' tests (items 19-20 below, VP-022/023) — their original
  fixtures assumed Step 4 falls through to Step 6 on a mismatch, which is
  no longer true once Step 4 is a hard fail — into (19) an over-count
  regression proof for the exact-equality decision, and (20) the literal
  'invert to assert FAILS' the round-5 task brief calls for (a
  healthy-looking partial kill rate does not rescue a dropped-mutant
  mismatch). Item 8/9's rename is reverted back to its round-1 original.
  `EXPECTED_GUARD_TEST_COUNT` is UNCHANGED at `58` (assertion/fixture
  changes to three existing test slots, not new or removed tests);
  `EXPECTED_MUTANTS_AGG_FIXTURES` is UNCHANGED at `10`. See §6.10 for the
  full round-5 consolidated summary, which supersedes §6.9's F2 entry
  specifically (§6.9's PRIMARY/structural-peer entry and F3 entry are
  untouched and remain the operative record for those two findings).
  §6.9 itself is RETAINED below, unedited, as the historical record of
  round-4's Option A/B weighing — round-5 is a reversal of which option
  is DEFAULT, not new analysis from scratch. Round-4 adversarial fix (F2
  fresh-context review, fourth pass). A fourth fresh-context adversary
  again confirmed the aggregator's
  core decision LOGIC is sound (no new false-green in the summation/
  reconciliation arithmetic, four rounds running) but found that
  `mutants-aggregate` — now the SOLE `ci-gate.needs` member making the
  mutation-gate pass/fail decision — never inherited the anti-neutering
  guardrail CLASS built for `ci-gate`'s own decision step over 20+ review
  rounds (a run-line byte-pin, an env-key-set pin, an invocation
  assertion, a YAML-node-property scan, and — a genuinely NEW gap this
  round found, not previously named in rounds 1-3 — a per-step `if:`
  VALUE pin for the job's three legitimate `if: always()` steps). §6.8
  (NEW) documents `mutants-aggregate` as a deliberate STRUCTURAL PEER of
  `ci-gate`, enumerating every one of `ci-gate`'s own decision-step
  protections and specifying the exact analog on `mutants-aggregate`
  (or explaining, case by case, why a given protection is inherited
  transitively via an existing generic mechanism rather than needing its
  own dedicated test). Separately, this round revises INV-AGG
  sub-invariant 8's ROLLOUT POLICY (F2, MEDIUM): the pooled-total <->
  MUTANT_COUNT reconciliation check moves from an unconditional hard
  `return 1` to a NON-BLOCKING `::warning::` for cycle-006's initial
  rollout (Option A), because the `--list`<->`--shard --sharding slice`
  lossless-partition premise it depends on remains empirically unverified
  across four F2 rounds and `mutants-aggregate`'s single-decision-point
  role means a wrong premise would brick EVERY PR simultaneously, not
  degrade gracefully — see `mutants-sharding-invariants.md`'s round-4
  callout under sub-invariant 8 for the full account and the mandatory
  empirical tighten-trigger. Two new guard-tests make the primary
  kill-rate gate's independence from reconciliation's warn/pass state
  directly testable rather than merely asserted in prose. Finally (F3),
  this round completes the residual guardrail-lockstep enumeration one
  more layer (confirming which EXISTING generic mechanisms already cover
  `mutants-aggregate` incidentally via `always_run_needs_members`) and
  lists every stale `mutants`-era prose site (job-count literals,
  now-inverted skip-tolerance rationale comments) F4 must update in the
  same change. See §6.9 for the full round-4 consolidated summary
  (§6.9's F2/reconciliation entry is superseded by §6.10 — see this
  note's own opening paragraph above) and the §6.7-upgrade paragraph
  explaining why the structural-peer approach (§6.8), not the
  F4-runs-the-suite backstop alone, is what closes this particular class
  of gap. `EXPECTED_GUARD_TEST_COUNT` was revised `51 -> 58` at round-4
  (+7 net new tests: 5 structural-peer analogs, §6.8, plus 2
  reconciliation-independence proofs, F2 — see §6.2/§6.9) and stays `58`
  through round-5's reversal (§6.10 — same 7 test slots, different
  assertions/fixtures for 3 of them). Round-3 (previous revision) closed HIGH-1 (mutants-aggregate's Step 0 push-event no-op was
  FAIL-OPEN on a malformed/mistyped EVENT_NAME — GitHub Actions resolves a
  bad `${{ }}` expression to an EMPTY string, not an error, so a typo'd
  `env:` binding would make `\"\" != 'pull_request'` true and silently exit
  0 with ZERO shard inspection on a real PR), MEDIUM-1 (`is_allowed_skip`
  — unlike its sibling `print_allowed_skips`, round-2's own fix target —
  still expanded `\"${ALLOWED_SKIPS[@]}\"` unguarded; on macOS bash 3.2.57,
  the actual runtime backing this repo's `#[cfg(unix)]` subprocess-test
  `macos-latest` leg, expanding an empty array under `set -u` is a FATAL
  \"unbound variable\" error, not the graceful no-op round-1/2's own
  Fixture 14 write-up assumed without qualifying WHICH bash version it had
  verified), and MEDIUM-2 (the twice-revised §6.2 enumeration still
  omitted four more forced edits: `test_allowed_skips_has_exactly_three_
  code_level_references`'s pinned count, AC-006's step-level-`if:`
  cardinality inside item 3, two stale module-map doc-comment citations,
  and — the largest single addition this round — the fact that
  `mutants-aggregate`'s script body was never actually extracted out of
  inline `ci.yml` `run:` text into an invokable `scripts/mutants-
  aggregate.sh`, which every already-planned INV-AGG/INV-COMPLETE Rust
  guard-test (items 1/2/3/6/7/8, §6.2) implicitly requires in order to be
  a genuine behavioral subprocess proof against SHIPPED logic rather than
  a Rust-side re-implementation of it). See §6.7 for the consolidated
  round-3 summary. `EXPECTED_GUARD_TEST_COUNT` revised `49 -> 51` this
  round (+2 net new tests: the EVENT_NAME wiring pin and the spec-guard
  mutants-aggregate-self-test-step pin — see §6.2/§6.2a/§6.7).
  `EXPECTED_FIXTURES` (`scripts/check-ci-gate.sh --self-test`) stays at
  `14` in COUNT, but Fixture 14 itself gains a message-substring assertion
  (§6.1); `test_allowed_skips_has_exactly_three_code_level_references` is
  RENAMED (`...three...` -> `...four...`) and its pinned count moves
  `3 -> 4` (ONE new, SHARED local-override occurrence via a single wrapper
  function, not two independent ones — see §6.1). A new, SIBLING bash
  self-test counter is introduced in the new `scripts/mutants-aggregate.sh`
  itself: `EXPECTED_MUTANTS_AGG_FIXTURES` (see §6.2a). Round-2 (previous
  revision) closed HIGH-1 (the §6.2 guardrail-lockstep enumeration was
  incomplete — four forced test/pin edits omitted), MEDIUM-1
  (print_allowed_skips's empty-array output shape was unguarded and
  unpinned), and MEDIUM-2 (INV-AGG sub-invariant 8's reconciliation claim
  over-stated its coverage, and mutants-plan's --list invocation silently
  swallowed its own exit status) — see §6.6 for that summary. Round-1
  closed CRIT-1 (false-green: all shards crash, aggregator's old
  0-artifact branch passed anyway), HIGH-1-round-1 (false-red: small-PR
  legitimately-empty shards indistinguishable from missing ones — same
  root cause as CRIT-1, fixed together), MED-1 (no cross-check guard for
  the new PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS pin category), and
  MED-2-round-1 (no structural pin on the mutants-plan -> mutants-
  aggregate escalated-output wiring) — see §6.5 for that summary."
governance: policy-doc-only (docs/specs/cargo-mutants-policy.md) — NO new PRD BC (DEC-348)
purity_boundary: N/A — this delta is CI/CD infrastructure only (`.github/workflows/`,
  `scripts/`, `tests/ci_gate_completeness.rs`, `tests/common/wf.rs`,
  `docs/specs/cargo-mutants-policy.md`). No `src/` product code changes. There is no
  pure-core/effectful-shell boundary to draw for a GitHub Actions workflow topology.
scope_note: DESIGN ONLY. No in-repo file listed below has been edited by this
  document — architecture-delta.md, mutants-sharding-invariants.md, and
  ci-yml-design.md are the F2 output; F4 implements the changes specified here.
---

# Architecture Delta: mutants-ci-sharding (cycle-006)

## 1. Summary

Replaces the single required `mutants` CI job (timeout-minutes 240,
`cargo mutants --in-diff <diff> --jobs 4 --timeout 240`, sole pass/fail
arbiter via its own `Check kill rate` step) with a **three-job pipeline**:

```
mutants-plan  →  mutants (matrix, 8 shards)  →  mutants-aggregate
   (new)             (modified)                     (new)
```

plus a new, wholly-separate scheduled workflow (`mutants-nightly.yml`) for
advisory full-scope (non-`--in-diff`) coverage. `mutants-aggregate` replaces
`mutants` as the sole `ci-gate.needs` member for mutation testing. Full
pseudo-YAML: `ci-yml-design.md`. Full invariant specifications:
`mutants-sharding-invariants.md`. This document covers the topology, data
flow, guardrail lockstep plan, and the one genuinely novel structural finding
this cycle surfaces (§6.4).

**Sequencing precondition carried from F1 (Open Question 1, BLOCKING):**
PR #778 is open, paused, and blocked on the CURRENT single-job `mutants`
gate. This delta's `ci.yml` changes must not land while PR #778 is
unresolved against the OLD gate shape — **recommend resolving PR #778 first**
(merge/close under the existing gate, or explicitly re-target it for
re-validation once cycle-006 lands), per F1's own recommendation. This is
unchanged by anything in F2 and is restated here because F4 implementation
must not proceed without the human confirming this sequencing at the F2 gate.

**Extraction precondition (round-3, BLOCKING, independent of PR #778):**
`mutants-aggregate`'s aggregation logic MUST be extracted into an
invokable `scripts/mutants-aggregate.sh` (mirroring `scripts/check-ci-
gate.sh`'s own shape, including a `--self-test` mode wired into
`spec-guard`) rather than left as inline `ci.yml` `run:` text — full
rationale, exact script structure, and the `spec-guard`/Rust-pin wiring:
§6.2a. This is a second, independent precondition to the PR #778
sequencing note above; both require explicit human confirmation at the F2
gate before F4 begins, and neither substitutes for the other.

**Empirical-verification precondition (round-6, BLOCKING, independent of
the two preconditions above):** the restored INV-AGG sub-invariant 8 hard
fail (§6.10) rests on an empirically-unverified premise — that
`cargo mutants --list --in-diff <diff> | wc -l` and the pooled sum of 8
`--shard k/8 --sharding slice --baseline skip` runs against the SAME diff
are guaranteed to reconcile exactly. This is an **ACCEPTED RISK, not a
design guarantee**: the re-widening-to-warning-only failure mode is
already test-guarded (items 8/9/19/20, §6.2, all assert `rc == 1` —
nobody can silently re-introduce round-4's warning-only behavior without
those tests turning red), so the ONE genuinely unguarded obligation left
is the empirical diligence to confirm the premise itself holds. F4 MUST
perform a scratch-run verification of this premise BEFORE cycle-006's own
PR merges — not defer it to production discovery on PR #778 — per the
concrete task specified in `mutants-sharding-invariants.md`'s round-6
addendum to the round-5 callout (INV-AGG sub-invariant 8) and restated in
§6.10 below.

**F4 Blocking Preconditions — consolidated (all five below require
explicit human confirmation at the F2 gate; none substitutes for
another):**
1. **Sequencing** (F1, restated above) — PR #778 resolved (merged/closed/
   re-targeted) against the OLD single-job gate before this delta's
   `ci.yml` changes land.
2. **Extraction** (round-3, above, §6.2a) — `mutants-aggregate`'s
   aggregation logic extracted into invokable `scripts/mutants-
   aggregate.sh` with a `--self-test` mode wired into `spec-guard` — the
   mechanism every INV-AGG/INV-COMPLETE behavioral guard-test depends on
   to prove SHIPPED logic, not a Rust-side re-implementation of it.
3. **Empirical premise verification** (round-6, above/§6.10) — a
   scratch-run confirmation, performed DURING F4 and BEFORE cycle-006's
   own PR merges, that `cargo mutants --list --in-diff <diff>` and the
   pooled 8-shard `--shard k/8 --sharding slice --baseline skip` sum
   reconcile EXACTLY on a non-trivial, known-nonzero in-diff mutant set.
   See §6.10 and `mutants-sharding-invariants.md`'s round-6 addendum for
   the exact task and the two root-cause branches on a mismatch. Cycle-
   006's own PR (CI/doc-only, `MUTANT_COUNT==0`) cannot supply this
   evidence — hence the dedicated scratch run; PR #778 remains valuable as
   the first REAL, production-scale, at-CI exercise of the restored hard
   fail, but is no longer the SOLE point this premise gets checked.
4. **Full guard-test suite** — `cargo test`'s `ci_gate_completeness.rs`
   suite, `scripts/check-ci-gate.sh --self-test`, AND `scripts/mutants-
   aggregate.sh --self-test` must all pass locally and in CI before merge.
   Per this document's own "authoritative completeness backstop" note
   (§6.7/§6.9/§6.10; verification-delta.md §6 note 14): this document's
   enumeration is best-effort guidance across six adversarial rounds —
   the suite run, not this document's counts, is ground truth.
5. **Policy-doc drafting** (F2 consistency-audit closeout, MAJOR-1) —
   the SAME PR as the code/test changes above MUST ALSO land the
   corresponding update to `docs/specs/cargo-mutants-policy.md`, the
   governance artifact of record for this cycle under DEC-348's
   policy-doc-only decision (no PRD BC exists as a backstop for this
   cycle's scope — see `docs/specs/cargo-mutants-policy.md`'s own
   Scope/Deferral-Policy framing). The PR MUST NOT merge with code/
   tests landed but the policy doc left stale. Specifically, the PR
   must:
   - activate/expand the existing "Future Path: Job Sharding (Path B)"
     section into the live, shipped design (it currently reads as a
     future-looking proposal; post-merge it describes what actually
     runs);
   - update the existing "CI Gate: Required Check" section so it
     states that `mutants-aggregate` (not `mutants`) is the
     `ci-gate.needs` member per this document's §2 job-topology table,
     and that `mutants`/`mutants-plan` are excluded via
     `PINNED_GATE_EXCLUDED_JOBS`;
   - add a new "Escape Hatch" section documenting the >120 in-diff-
     mutant-count escalation path (ordinary CI failure + admin-bypass,
     not a silent skip);
   - add a new "Scheduled Full Run" section documenting
     `mutants-nightly.yml` (`mutants-full` / `mutants-nightly-report`,
     `schedule:` + `workflow_dispatch:`, advisory — outside
     `ci-gate`'s enforcement surface per this document's §2 table);
   - update the existing "CI Integration" and "Local Invocation"
     sections for the sharded topology (per-shard `--shard k/8
     --sharding slice --baseline skip` invocation, `DIFF_FILE`
     artifact reuse across shards, aggregator-side reconciliation);
   - transcribe the INV-AGG / INV-COMPLETE / INV-ESCALATE invariant
     substance from `mutants-sharding-invariants.md` into the policy
     doc itself, so the spec-of-record states the invariants directly
     rather than only by reference;
   - add ONE new row to the doc's existing `## Changelog` Date/Cycle/
     Change table (the table row IS this doc's changelog mechanism —
     see MINOR-3 below; do not add a semver field).
   This item exists because DEC-348 makes `cargo-mutants-policy.md`
   the spec of record for this cycle's mutation-CI design, and unlike
   every other artifact in this delta, no PRD behavioral contract
   exists to independently backstop drift between what `ci.yml` does
   and what the policy doc claims it does.

## 2. New job topology

| Job | Shape | `ci-gate.needs` member? | Reports `skipped` to GHA? |
|---|---|---|---|
| `mutants-plan` | single job, `if: github.event_name == 'pull_request'` | No — `PINNED_GATE_EXCLUDED_JOBS` | Yes, on push (unchanged pattern) |
| `mutants` | `strategy.matrix.shard: [0..7]`, `needs: [mutants-plan]` | No — `PINNED_GATE_EXCLUDED_JOBS` | Yes, on push OR when escalated |
| `mutants-aggregate` | single job, `needs: [mutants-plan, mutants]`, `if: always()` | **Yes — replaces `mutants`** | **Never** — always resolves internally to success/failure (see §6.4) |
| `mutants-nightly.yml :: mutants-full` / `mutants-nightly-report` | separate workflow file, `schedule:` + `workflow_dispatch:` | No — different workflow file entirely, outside `ci-gate`'s enforcement surface | N/A |

## 3. Data flow / artifact naming

1. `mutants-plan` computes `DIFF_FILE` ONCE (`git diff origin/<base_ref>...HEAD`,
   with the existing F-4 `|| true` empty-diff-safe handling), uploads it as
   artifact `mutants-diff-file`, and pre-counts in-diff mutants for the
   escape hatch. Outputs: `escalated` (`'true'`/`'false'` string),
   `mutant_count`, `overall_diff_lines`.
2. Every `mutants` shard (0-7) downloads the SAME `mutants-diff-file`
   artifact — satisfies the research grounding's "same diff or results are
   meaningless" invariant structurally (one upload, N downloads of the
   identical bytes) rather than by convention. Each shard then (a) ALWAYS
   writes and uploads a status sentinel, `mutants-shard-status-<k>`
   (round-1 adversarial fix — see `mutants-sharding-invariants.md
   §INV-COMPLETE Part A`; captures `steps.run-mutants.outcome`, which
   survives `continue-on-error: true` truthfully, unlike `.conclusion`),
   and (b) uploads its own `mutants.out/outcomes.json` as
   `mutants-shard-outcomes-<k>` (k = 0..7), `if: always()` so a crashed/
   timed-out shard still uploads whatever partial (possibly absent) output
   exists. The status sentinel — NOT the outcomes.json artifact — is now
   INV-COMPLETE's source of truth for shard completeness; outcomes.json is
   pure data, interpreted per the sentinel's fields.
3. `mutants-aggregate` downloads BOTH the `mutants-shard-status-*`
   sentinels and the `mutants-shard-outcomes-*` data artifacts (separate
   glob patterns), asserts the exact expected sentinel set is present
   (INV-COMPLETE Part B), interprets each shard's sentinel to decide
   whether its data is folded in, contributes zero, or fails the whole
   aggregation closed (INV-COMPLETE Part C), reconciles the pooled total
   against `mutants-plan`'s independent pre-count (INV-AGG sub-invariant
   8), and enforces the 90% pooled kill-rate threshold — identical
   arithmetic to today's single-job `Check kill rate` step, just fed
   pooled, sentinel-validated sums.

Full step-by-step pseudo-YAML and the exact aggregator script: see
`ci-yml-design.md`.

## 4. `ci-gate.needs` retarget

```yaml
needs: [fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants-aggregate]
```

Only the LAST member changes (`mutants` → `mutants-aggregate`); everything
else in `ci-gate`'s own job block — its `if: ${{ always() }}`, its own
steps, its `Evaluate required job results` step — is byte-identical, no
change. Per DEC-096/DEC-097 (CLAUDE.md), this is the only place a new
required job is wired in; `mutants`/`mutants-plan` are never wired directly
into branch protection.

## 5. Escape hatch and scheduled full run

Both are specified in full in the companion docs (this section is a
pointer, not a duplicate):
- Escape hatch mechanism, encoding, and rejected alternatives:
  `mutants-sharding-invariants.md §INV-ESCALATE`.
- Scheduled full-run job/workflow design: `ci-yml-design.md §4`.

**Scheduled Full Run: Separate File vs New `ci.yml` Job — recommendation and
rationale.** Recommend a **separate workflow file**
(`.github/workflows/mutants-nightly.yml`), not a new `schedule:`-triggered
job appended to `ci.yml`, for three reasons:

1. **Avoids `ci.yml`'s job-partition invariant entirely.**
   `test_ci_gate_needs_partitions_all_ci_yml_jobs` (S-626-1 U1) requires
   EVERY job literally defined in `ci.yml` to be in either `ci-gate.needs`
   or the pinned `PINNED_GATE_EXCLUDED_JOBS` allowlist. A separate workflow
   file is invisible to `read_ci_yml()`/`list_all_ci_yml_job_names` (both
   scoped to `.github/workflows/ci.yml` by name), so it needs **zero**
   `PINNED_GATE_EXCLUDED_JOBS` additions — a new job inside `ci.yml` would
   need two more entries there (its own `mutants-full`-equivalent AND a
   `mutants-nightly-report`-equivalent), growing that already-changing list
   further for a job that has nothing to do with `ci-gate` at all.
2. **Existing precedent in this exact repo.** `.github/workflows/e2e.yml`
   already establishes the "separate scheduled workflow, `if:
   github.event_name != 'pull_request'` belt-and-suspenders guard,
   `workflow_dispatch` for manual triggers" pattern this design reuses
   nearly verbatim (see `ci-yml-design.md §4`'s pseudo-YAML, modeled
   directly on `e2e.yml`'s structure).
3. **Independent failure/retention/scheduling tuning without touching the
   required-gate file.** A tuning change to the nightly job's cron,
   timeout, or shard count never touches `ci.yml`, so it can never
   accidentally perturb any `ci-gate`-adjacent pin — a strictly smaller
   blast radius for a purely advisory workflow.

The one guard this new file DOES need to satisfy: `test_no_sibling_workflow_
declares_a_job_named_ci_gate` (confirmed by direct read — it iterates every
workflow file OTHER than `ci.yml` and forbids a job literally named
`ci-gate`). Neither `mutants-full` nor `mutants-nightly-report` collides
with that name — trivially satisfied, no test change needed.

## 6. Guardrail Lockstep Plan (COMPLETE enumeration)

This is the exhaustive list F4 must apply as ONE atomic change (`ci.yml` +
`scripts/check-ci-gate.sh` + `tests/ci_gate_completeness.rs` in the same
commit) — per the F1 delta analysis's own Risk #3 ("if these pins are not
ALL retargeted... in the same change, at least one of two failure shapes
results"). `tests/common/wf.rs` requires **zero changes** — justified in
§6.3.

### 6.1 `scripts/check-ci-gate.sh`

| Change | From | To |
|---|---|---|
| `ALLOWED_SKIPS` declaration | `ALLOWED_SKIPS=("mutants")` | `ALLOWED_SKIPS=()` — see §6.4 for why this becomes empty, not retargeted |
| Doc comment above `ALLOWED_SKIPS` | "It currently contains `mutants` only..." | Rewritten: mechanism retained as load-bearing infrastructure for any FUTURE `ci-gate.needs` member that legitimately needs skip-tolerance; currently empty because `mutants-aggregate` (cycle-006) is deliberately designed to never report `skipped` — see the "S-CIGATE-2 vs always()" rationale cross-referenced to `tests/ci_gate_completeness.rs`'s new `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS` |
| Fixture 4 (`mutants-skipped-allowlisted`) | Tests production `ALLOWED_SKIPS=("mutants")` directly | REPURPOSED: temporarily overrides `ALLOWED_SKIPS` to a synthetic `("example-skip-tolerant-job")` array inside the fixture harness (save/restore around the call), asserting `is_allowed_skip`/`evaluate_needs`'s positive `skipped`-tolerance branch remains genuinely exercised even though production's array is empty. Same PASS expectation, different mechanism under test. |
| Fixture 5 (`mutants-failure-allowlist-is-restrictive`) | Same production-array dependency | REPURPOSED identically to fixture 4 — same local-override technique, proving an allowlisted job's `failure` result still fails (allowlist tolerates `skipped` ONLY). |
| Fixture 12 (`realistic-multiline-toJSON-needs-payload`) | 8-job payload with `"mutants": {"result": "skipped", ...}` | Rekeyed to `"mutants-aggregate": {"result": "success", ...}` — under the new design, a legitimate push-event run has `mutants-aggregate` reporting **success** (its internal push-event no-op exits 0), not `skipped`. This is a real, deliberate semantic change to what "the realistic push-event shape" looks like, not a cosmetic rename. |
| Fixture 13 (unlisted-job-skipped-alongside-allowlisted) | `fmt` skipped alongside `mutants` legitimately skipped | Simplified: `fmt` skipped is now the ONLY skip in the payload (no companion legitimately-skipped job exists in the production shape anymore) — still `FAIL closed`, now a strictly simpler fixture. |
| **NEW Fixture 14** | — | `empty-allowed-skips-any-skip-fails-closed`: exercises the TRUE production `ALLOWED_SKIPS=()` end-to-end (no local override) with a job reporting `skipped` — asserts FAIL, AND (this is the point of the fixture) proves bash's `"${ALLOWED_SKIPS[@]}"` expansion over a genuinely empty array does not itself crash under `set -euo pipefail`/`nounset` on the actual bash version this repo's CI runs (GitHub `ubuntu-latest` ships bash ≥5.x, where this is safe, but this repo's own culture — per the round-14 non-LF-byte-scan precedent — treats "a never-before-exercised code shape" as needing an explicit RED/GREEN proof, not an assumption). |
| `EXPECTED_FIXTURES` | `13` | `14` |

**(NEW, round-2, MEDIUM-1) `print_allowed_skips` empty-array guard + new sibling self-test suite.** A fresh-context F2 adversary flagged that `print_allowed_skips` (`printf '%s\n' "${ALLOWED_SKIPS[@]}"`) had never been exercised against a genuinely empty `ALLOWED_SKIPS` in production before this cycle — round-1 makes that the FIRST cycle where it is (§6.4's "ALLOWED_SKIPS returns to being empty in production"). Per this file's own "an unexercised-until-now code shape needs an explicit RED/GREEN proof, not an assumption" convention (S-CIGATE-3/round-14 precedent), this shape now gets one:

- **Guard.** `print_allowed_skips` gains an explicit empty-array short-circuit:
  ```bash
  print_allowed_skips() {
      if [ "${#ALLOWED_SKIPS[@]}" -eq 0 ]; then
          return 0
      fi
      printf '%s\n' "${ALLOWED_SKIPS[@]}"
  }
  ```
  This guarantees `--print-allowed-skips` emits zero lines (not a phantom blank line) for the empty case, independent of which bash version's `"${ALLOWED_SKIPS[@]}"`-under-`nounset` empty-array expansion semantics happen to be in play on the runner (verified empirically safe on the bash exercised this session, but per the same "don't assume, prove" convention this guard makes the behavior independent of that question entirely — it short-circuits before the expansion is ever attempted). **Note on `${#ALLOWED_SKIPS[@]}`**: this new line does NOT add a fourth occurrence to `test_allowed_skips_has_exactly_three_code_level_references`'s pinned count of 3 — `count_allowed_skips_code_occurrences` matches the literal substrings `ALLOWED_SKIPS=`, `ALLOWED_SKIPS+=`, and `${ALLOWED_SKIPS`; `${#ALLOWED_SKIPS[@]}` contains `${#ALLOWED_SKIPS`, which does not contain `${ALLOWED_SKIPS` as a contiguous substring (the `#` sits between `{` and `A`). Verified by direct string inspection, not assumed — F4 should still re-run `test_allowed_skips_has_exactly_three_code_level_references` after this edit as its own cheap confirmation.
- **New self-test suite, NOT folded into `EXPECTED_FIXTURES`/`check_fixture`.** `check_fixture`/`EXPECTED_FIXTURES` test `evaluate_needs()`'s JSON-payload pass/fail decision specifically (see that pair's own doc comments) — `print_allowed_skips`'s output SHAPE is a different function's behavior entirely, exactly the same category distinction this file already draws between `EXPECTED_FIXTURES` (decision fixtures) and `EXPECTED_JQ_TRUST_CHECKS` (`is_trusted_jq_dir`/`resolve_trusted_jq` checks, its own sibling counter + its own `run_jq_trust_self_test` function). Folding this into `EXPECTED_FIXTURES` would be the same category error that precedent already avoided. **Resolves the "(14→15?)" open question in the round-2 task brief: the answer is neither — `EXPECTED_FIXTURES` stays at `14`, unchanged by this finding.** New file-scope constant `EXPECTED_PRINT_ALLOWED_SKIPS_CHECKS = 1` (same `readonly`-at-file-scope pattern as its two siblings, same ADV-P61-INFO-006 rationale), new function `run_print_allowed_skips_self_test()` (mirrors `run_jq_trust_self_test`'s shape: local `pas_total`/`pas_mismatches` counters, one `check_print_allowed_skips_output` helper, a fixed-denominator self-check against `EXPECTED_PRINT_ALLOWED_SKIPS_CHECKS` at the end), wired into `main --self-test` as a THIRD suite alongside the existing two (`decision_rc`/`jq_trust_rc`/new `print_allowed_skips_rc`, combined exit reflects any of the three failing — same "both suites always run, never short-circuited" discipline `run_jq_trust_self_test`'s own module comment documents, now "all three").
- **Exactly ONE check, not two — and why a "populated array still prints correctly" regression check is deliberately NOT added here.** The obvious defense-in-depth pairing (empty-array case + a locally-overridden non-empty-array case, mirroring the local-override technique already used for repurposed fixtures 4/5) was considered and declined: a `local ALLOWED_SKIPS=("example-skip-tolerant-job")` override inside the new self-test function would itself be a textual `ALLOWED_SKIPS=` occurrence in `scripts/check-ci-gate.sh`, pushing `count_allowed_skips_code_occurrences` from 3 to 4 and requiring `test_allowed_skips_has_exactly_three_code_level_references`'s pinned expectation to change in the SAME commit for no real safety gain — because the mutation this second check would guard against (an unconditional early `return 0` that defeats a FUTURE populated `ALLOWED_SKIPS`) is ALREADY caught, transitively, the moment `ALLOWED_SKIPS` next becomes non-empty: `test_allowed_skips_members_require_job_level_conditional_in_ci_yml`'s existing final block independently probes `evaluate_needs()`'s OWN behavioral skip-tolerance (not `print_allowed_skips`'s report) and cross-checks it against `--print-allowed-skips`'s reported set (CLAUDE.md's own description of that block, S-626-1 pass-9) — a `print_allowed_skips` that always reports empty while `evaluate_needs()` genuinely tolerates a skip would desync those two and fail that EXISTING guard loudly. The one check this round-2 fix DOES add proves the shape that is reachable TODAY (the true, current, empty production state) and needed a first proof; the populated-array shape is not reachable today and is already covered by an existing guard once it becomes reachable — adding a redundant local-override check now would only cost a pinned-count churn with no coverage gain.
- **The check itself** (`check_print_allowed_skips_output "production-allowed-skips-is-empty" ...`): calls `print_allowed_skips` with NO override (the true, current, file-scope `ALLOWED_SKIPS=()`), asserts the captured output is the empty string / zero lines.

**(NEW, round-3, MEDIUM-1) `is_allowed_skip` empty-array guard — the sibling round-2 missed.** A fresh-context F2 adversary found round-2's `print_allowed_skips` fix (above) was never applied to `is_allowed_skip` (`scripts/check-ci-gate.sh::is_allowed_skip`, the function `evaluate_needs()` actually calls per job to decide skip-tolerance — confirmed via `is_allowed_skip "${job}"` at `:663`) — it still loops `for allowed in "${ALLOWED_SKIPS[@]}"` with no guard. Grep-confirmed this session: `"${ALLOWED_SKIPS[@]}"` occurs at exactly two live sites in the file, `is_allowed_skip` (`:189`) and `print_allowed_skips` (`:204`) — no third site needs this guard. This is not merely an inconsistency: it is a LIVE production risk this cycle specifically introduces, because `ALLOWED_SKIPS` is about to become genuinely empty in production for the first time (§6.4) at the exact moment `#[cfg(unix)]`'s subprocess tests exercise this script on TWO CI runners with two DIFFERENT bash major versions — `ubuntu-latest` (bash ≥5.x, where `"${empty_array[@]}"` under `set -u` expands to nothing, harmlessly) and `macos-latest` (bash 3.2.57, Apple's frozen pre-GPLv3 build, where the IDENTICAL expansion is a FATAL "unbound variable" error under this script's own `set -euo pipefail` at file scope, line 72). Round-1/round-2's own Fixture 14 write-up ("GitHub `ubuntu-latest` ships bash ≥5.x, where this is safe") verified only the safe runner — never the one this repo's own test matrix ALSO runs this exact script on (per this script's own `trusted_jq_dirs_for` doc comment: the `#[cfg(unix)]` subprocess tests run on both `ubuntu-latest` AND `macos-latest`).

- **Guard, symmetric in FORM to `print_allowed_skips`'s round-2 fix but OPPOSITE in RETURN VALUE — this asymmetry is the one thing to get right:**
  ```bash
  is_allowed_skip() {
      local job="$1"
      local allowed
      if [ "${#ALLOWED_SKIPS[@]}" -eq 0 ]; then
          return 1  # NOT 0 — an empty allowlist means "nothing is allowed
                    # to skip," the same conclusion the unguarded loop
                    # below already reaches (a `for` over zero elements
                    # simply falls through to `return 1`); this guard only
                    # makes that conclusion reachable WITHOUT attempting
                    # the empty-array expansion at all, independent of
                    # which bash's `nounset` semantics happen to be in
                    # play. Returning 0 here (copy-pasting
                    # print_allowed_skips's `return 0`) would be a SEVERE
                    # regression — it would make every `skipped` result
                    # pass unconditionally the moment ALLOWED_SKIPS is
                    # empty, the exact opposite of fail-closed.
      fi
      for allowed in "${ALLOWED_SKIPS[@]}"; do
          if [ "${allowed}" = "${job}" ]; then
              return 0
          fi
      done
      return 1
  }
  ```
- **`${#ALLOWED_SKIPS[@]}` does not add a new textual occurrence, for the identical reason `print_allowed_skips`'s own guard didn't** — `${#ALLOWED_SKIPS` does not contain `${ALLOWED_SKIPS` as a contiguous substring (the `#` sits between `{` and `A`), per round-2's own already-established argument. This guard line contributes ZERO new occurrences to `count_allowed_skips_code_occurrences` on its own.
- **Fixture 14 gains a message-substring assertion (4th `check_fixture` argument) and its safety claim is re-scoped.** Previously specified only as "asserts FAIL"; now specified as asserting BOTH `"fail:1"` AND the exact substring `"FAIL  fmt = skipped"` (payload: `{"fmt":{"result":"skipped"},"clippy":{"result":"success"}}` — reuses fixture 3's job-name convention), per the pre-existing LOAD-BEARING LOG FORMAT convention this file already applies wherever a fixture must distinguish "reached the correct FAIL decision" from "produced rc=1 by some other, wrong mechanism." **This is the actual reason the substring matters here, not mere thoroughness:** on bash 3.2 PRE this round-3 fix, `is_allowed_skip`'s unguarded loop over an empty array aborts the enclosing subshell with `bash: ALLOWED_SKIPS[@]: unbound variable` and exits 1 — numerically INDISTINGUISHABLE from the intended `"fail:1"` outcome. A bare return-code check would therefore have reported Fixture 14 GREEN on macOS while silently proving the WRONG thing (a runtime crash, not `evaluate_needs()`'s own fail-closed decision reaching its FAIL branch through the intended code path). The message-substring check closes that gap: a crash's stderr text never contains `"FAIL  fmt = skipped"`, so it fails loudly instead of passing by coincidence. **The safety claim is re-scoped accordingly:** Fixture 14 (run via BOTH `scripts/check-ci-gate.sh --self-test` directly in `spec-guard`, which runs on `ubuntu-latest` only, AND via `tests/ci_gate_completeness.rs`'s `#[cfg(unix)]` subprocess tests, which run on the `test` job's `ubuntu-latest` AND `macos-latest` legs) now proves the empty-array behavior correct on **both CI bash versions this repository actually runs this script under**, not merely "ubuntu bash ≥5.x" as previously (and, per this finding, insufficiently) claimed. F4 must confirm Fixture 14 passes green on a real `macos-latest` CI run — not merely inferred from the ubuntu leg — before considering this finding closed; the guard fix makes it PASS by construction, but the whole point of this finding is "don't assume, prove," so the proof itself must run where it was previously silently unexercised.

**(NEW, round-3, MEDIUM-2 partial) Fixtures 4/5's local-override technique gets ONE shared helper, resolving the round-3 task brief's "pick one" instruction.** Round-2 (table above) already specifies fixtures 4/5 as "temporarily overrides `ALLOWED_SKIPS` to a synthetic `(\"example-skip-tolerant-job\")` array inside the fixture harness (save/restore around the call)" but never specified the exact mechanism — which matters, because `test_allowed_skips_has_exactly_three_code_level_references` (§6.2) counts textual `ALLOWED_SKIPS=` occurrences, and a naive implementation (each fixture writing its OWN `local ALLOWED_SKIPS=(...)` override line) would add TWO new occurrences, not one, pushing the count to `5`, not `4`. **Decided: ONE shared wrapper function, used by both fixtures, contributing exactly ONE new occurrence** — the alternative (repurpose Fixtures 4/5 to avoid ANY textual `ALLOWED_SKIPS=` reassignment via `read -a`) is explicitly declined below.
  ```bash
  # run_fixture_with_synthetic_skip_tolerant_job <fixture_name> <needs_json>
  #   <expected> [msg]
  # Wraps check_fixture with a LOCAL override of ALLOWED_SKIPS, exercising
  # is_allowed_skip's/evaluate_needs()'s positive skip-tolerance branch even
  # though production's array is empty (§6.4). `local ALLOWED_SKIPS=(...)`
  # shadows the file-scope array for the DURATION OF THIS FUNCTION CALL
  # ONLY (bash dynamic scoping) — no explicit save/restore needed, and the
  # override cannot leak into any OTHER fixture or into a production
  # evaluate_needs() call made outside this function.
  run_fixture_with_synthetic_skip_tolerant_job() {
      local ALLOWED_SKIPS=("example-skip-tolerant-job")
      check_fixture "$@"
  }
  ```
  Fixture 4 (`mutants-skipped-allowlisted`, payload rekeyed to job name `"example-skip-tolerant-job"` in place of `"mutants"`) and Fixture 5 (`mutants-failure-allowlist-is-restrictive`, same rekey) both call this wrapper instead of `check_fixture` directly — their expected outcomes (`"pass"` / `"fail:1"` respectively) are unchanged from round-2's spec. **Resulting count: `3 -> 4`, not `3 -> 5`.** `count_allowed_skips_code_occurrences`'s four sites, post-round-3: (1) the declaration `ALLOWED_SKIPS=()`; (2) `is_allowed_skip`'s loop expansion; (3) `print_allowed_skips`'s expansion; (4) `run_fixture_with_synthetic_skip_tolerant_job`'s local override. `test_allowed_skips_has_exactly_three_code_level_references` is RENAMED `test_allowed_skips_has_exactly_four_code_level_references` (the old name would assert a number its body no longer checks, which this repo's own test-naming convention — CLAUDE.md: "a name asserting a guarantee its body doesn't check is a defect, not a style deviation" — treats as a correction, not style churn); its `assert_eq!` target moves `3 -> 4`; its doc comment's site enumeration (`tests/ci_gate_completeness.rs :~7379-7383`) is rewritten to name all four sites above instead of three (see §6.2 item 8 for the "Tests MODIFIED in place" cross-reference). **Explicitly declined: a `read -a`-based override.** The round-3 task brief itself names this as the documented blind spot (`count_allowed_skips_code_occurrences` matches only `ALLOWED_SKIPS=`/`ALLOWED_SKIPS+=`/`${ALLOWED_SKIPS`, never `read -a ALLOWED_SKIPS <<< ...` or `mapfile -t`) — using it here to dodge the count bump would be actively defeating this file's own guard, not merely avoiding churn, and is rejected outright regardless of cost.

### 6.2 `tests/ci_gate_completeness.rs`

**Constants changed:**

| Const | From | To | Notes |
|---|---|---|---|
| `SKIP_TOLERANT_NEEDS_MEMBERS` | `&["mutants"]` | `&[]` | Doc comment rewritten — see §6.4 |
| `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS` (`#[cfg(unix)]`) | `&[("mutants", "github.event_name == 'pull_request'")]` | `&[]` | `test_skip_tolerant_needs_members_matches_pinned_if_expressions` still passes trivially (two empty vecs are equal) |
| `PINNED_GATE_EXCLUDED_JOBS` | `&["security", "coverage"]` | `&["security", "coverage", "mutants", "mutants-plan"]` | Doc comment gains two new bullets AND a generalizing sentence (see §6.4 — this is a genuinely different EXCLUSION RATIONALE class than "advisory by policy") |
| `PINNED_ALWAYS_RUN_JOB_KEY_SETS` | 7 entries | 8 entries, `+ ("mutants-aggregate", &["if", "name", "needs", "runs-on", "steps", "timeout-minutes"])` | First entry in this list with BOTH `needs` and `if` as job-level keys |
| `PINNED_ALWAYS_RUN_STEP_KEY_SETS` | 7 entries | 8 entries, `+ ("mutants-aggregate", &[...])` — exact per-step key sets depend on F4's final step list; see `ci-yml-design.md §3` for the 5-step shape (harden-runner / checkout / download-artifact status / download-artifact outcomes / evaluate-gate — round-1 adds the second download-artifact step for status sentinels) | F4 must derive the exact key arrays from the FINAL merged `uses:`/`with:` pins, not copy this document's illustrative shape blindly |
| **NEW** `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS` | does not exist | `&[("mutants-aggregate", "always()")]` | New pin category — see §6.4, the single most important novel finding in this delta |
| **NEW (round-1)** cross-check on `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS` | no cross-check exists | `test_always_run_with_if_exceptions_disjoint_and_tautological` asserts (a) `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS` keys are DISJOINT from `SKIP_TOLERANT_NEEDS_MEMBERS`, from `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS` keys, and from `check-ci-gate.sh --print-allowed-skips`'s reported set; and (b) every pinned `if:` value in the list is the exact tautology `always()` (never a compound expression like `always() && github.ref == 'x'` that would smuggle a conditional skip in under this exception category) | MED-1 (round-1 finding) — mirrors `test_skip_tolerant_needs_members_matches_pinned_if_expressions`'s sibling-list-sync discipline; without this, a future entry added to this list could both bypass the "no job-level if" rule AND fail to actually always-run, silently reintroducing the always()-vs-skip ambiguity this pin category exists to prevent |
| **NEW (round-1)** escalation-wiring pin | no pin exists | `test_mutants_plan_escalated_output_wired_to_aggregate_env` asserts `mutants-plan`'s job-level `outputs:` mapping declares an `escalated` key (byte-pinned value: `${{ steps.plan.outputs.escalated }}`), AND `mutants-aggregate`'s "Evaluate sharded mutation gate" step's `env:` mapping binds `ESCALATED:` to the exact value `${{ needs.mutants-plan.outputs.escalated }}` | MED-2 (round-1 finding) — a mistyped output name or env key degrades GRACEFULLY to an empty string at the consumer (GitHub Actions returns empty/null for a nonexistent `needs.<job>.outputs.<name>` reference, it does not error), which silently disables INV-ESCALATE forever (the `[ "${ESCALATED}" = "true" ]` check never fires) rather than failing loudly — exactly the fail-open shape this repo's CI-gate history treats as maximally dangerous |
| `PINNED_MATRIX_NEEDS_MEMBER_COUNT` | `2` | **UNCHANGED — still `2`** | Explicit non-change: `mutants` (the shard job) is NOT a `ci-gate.needs` member, so `matrix_needs_members()` (which filters strictly within `ci-gate.needs`) still returns exactly `[clippy, test]`. `test_matrix_os_lists_remain_static_literals`'s `os_path = ["strategy", "matrix", "os"]` literal is likewise untouched by this cycle — it never sees the `mutants` job's `strategy.matrix.shard` key at all, since that job is outside its candidate set. F4 should add a one-line comment at this const noting the non-change was verified, not merely assumed, per this repo's "silence is not evidence" convention. |
| **(round-2, HIGH-1(c))** `PINNED_GATE_NEEDS_LINE` | `"[fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants]"` | `"[fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants-aggregate]"` | Omitted from the round-1 table by oversight — round-2 finding. `M2-p` (`tests/ci_gate_completeness.rs :~2251-2264`) byte-pins the `ci-gate` job's `needs:` line against this literal; its own failure text already says to update BOTH this literal AND `test_ci_gate_needs_exactly_the_required_jobs`'s exact-set pin (item 1 of "Tests MODIFIED in place" below) in the same change — round-1 covered the latter but never listed this constant itself as changed. F4 must update both in the SAME commit, exactly as M2-p's own panic message already instructs. |
| **(round-3)** `PINNED_ALWAYS_RUN_STEP_KEY_SETS` (`spec-guard` entry only) | 12 ordered step-key-set entries (see the real file, `:1563-1575`) | 13 entries — append `&["name", "run"]` as the 13th, for the new "check-mutants-aggregate self-test (fixture suite, cycle-006)" step (§6.2a) | Forced by the same generic `test_always_run_jobs_have_pinned_complete_step_key_sets` this constant already drives — no new Rust test needed for THIS row alone, the existing loop-based test enforces it once the tuple grows; MUST land in the SAME commit as the `spec-guard` step addition in `ci.yml` (§6.2a) or that test fails, naming `spec-guard` and the mismatched step-key-set length |
| **NEW (round-3, HIGH-1)** `EVENT_NAME` wiring pin | no pin exists | `test_mutants_aggregate_event_name_env_wired` asserts `mutants-aggregate`'s "Evaluate sharded mutation gate" step's `env:` mapping binds `EVENT_NAME:` to the exact byte value `${{ github.event_name }}` — same byte-exact-comparison technique as the existing `ESCALATED`/round-1 escalation-wiring pin directly above, applied to the newly-identified fragile INPUT rather than an output | HIGH-1 (round-3 finding) — mirrors MED-2/round-1's own rationale verbatim but on the opposite side of the wire: a mistyped `env:` key here (e.g. `github.event_nam`) degrades GRACEFULLY to an empty string, which the FIXED Step 0 (§6.2a) now correctly treats as FAIL rather than the pre-fix design's silent `exit 0` — but a structural pin is still needed so a FUTURE edit that widens Step 0's `case` statement (e.g. carelessly adding a catch-all `*) exit 0 ;;` arm) is caught even before it reaches the runtime fail-closed behavior; this is defense-in-depth on the WIRING, not a substitute for §6.2a's runtime fix |
| **NEW (round-3, extraction wiring)** spec-guard self-test-step pin | no pin exists | `test_spec_guard_contains_mutants_aggregate_self_test_step` — mirrors the EXISTING `test_spec_guard_contains_check_ci_gate_self_test_step` (AC-008) exactly: asserts the `spec-guard` block contains a step running `scripts/mutants-aggregate.sh --self-test`, AND byte-pins that step's own `run:` line (anchored by step name "check-mutants-aggregate self-test (fixture suite, cycle-006)") via `extract_and_normalize_step_run_line_by_name`, closing the same "two unrelated `--self-test` substrings elsewhere in the job could satisfy a bare substring check" gap S-626-1 pass-54/56 already closed for the check-ci-gate.sh sibling | See §6.2a — this is the Rust-side half of confirming the new self-test fixture suite (`EXPECTED_MUTANTS_AGG_FIXTURES`) is actually wired into CI, not merely defined in the script |
| **NEW (round-4)** `PINNED_MUTANTS_AGGREGATE_RUN_LINE` | does not exist | `&str = "bash scripts/mutants-aggregate.sh"` — byte-pins `mutants-aggregate`'s "Evaluate sharded mutation gate" step's `run:` line via the EXISTING, already-generic `extract_and_normalize_sole_run_line(job_block)` (`tests/ci_gate_completeness.rs :~4969`) called against the `mutants-aggregate` job block instead of `ci-gate`'s — this job has exactly one step-level `run:` key (the eval step; every other step is `uses:`), satisfying that function's "exactly one `run:` in the whole block" precondition with zero new helper code | §6.8 M2-i analog. Blocks `\|\| true`, `\| cat`, `; exit 0`, and any suffix that would silently disable the eval step's pass/fail signal, mirroring exactly the CRITICAL class M2-i closed for `ci-gate` in PR #671 review round 10 |
| **NEW (round-4)** `PINNED_MUTANTS_AGGREGATE_ENV_KEYS` | does not exist | `&["ESCALATED", "EVENT_NAME", "MUTANT_COUNT", "OVERALL_DIFF_LINES", "PLAN_RESULT", "SHARD_DIR", "STATUS_DIR"]` (7 keys, sorted) — via the EXISTING, already-generic `extract_gate_env_key_set(job_block)` (`tests/ci_gate_completeness.rs :~5967`, itself `step_mapping_child_keys(job_block, "run", "env")`) called against the `mutants-aggregate` job block | §6.8 M2-o analog. Closes a `BASH_ENV:`-class smuggled-env-child vector in one stroke. **This row protects KEY PRESENCE only, never VALUES on its own — but as of round-9, ALL 7 of these 7 keys ALSO carry an INDIVIDUAL byte-VALUE pin on top of this key-set pin** (`ESCALATED`/`EVENT_NAME` from the round-1/round-3 pins above; `STATUS_DIR`/`SHARD_DIR` from round-8/F-H1, items 23/24; `MUTANT_COUNT`/`OVERALL_DIFF_LINES`/`PLAN_RESULT` from round-9/LOW-1, items 25/26/27, closing the last remaining "key-set pin only" gap and retiring the declined-env-value-pin class entirely — see the declined-additions entry below and §6.8's corrected M2-n row) — no key-set-pinned-but-value-unpinned env child remains on this job's decision path |
| **NEW (round-8, F-H1)** `PINNED_MUTANTS_AGGREGATE_STATUS_DIR_LINE` | does not exist | `&str = "${{ runner.temp }}/shard-status"` — byte-pins `mutants-aggregate`'s eval step's `env:` mapping to assert `STATUS_DIR:` is bound to exactly this value, via the SAME generic byte-exact env-child-value technique items 10/12 already use for `ESCALATED:`/`EVENT_NAME:` (zero new `wf.rs` code) | §6.8 M2-n analog for THIS job's evidence-location inputs. Corrects a faulty round-4/5 declination that cited bash's `${VAR:?message}` operator (§6.2a) as "stronger than any static pin could assert" — `:?` guards only UNSET/EMPTY, not a maliciously-but-validly-SET redirect to an attacker-controlled directory, which is the actual threat: `STATUS_DIR` locates the ENTIRE sentinel evidence set the decision reads |
| **NEW (round-8, F-H1)** `PINNED_MUTANTS_AGGREGATE_SHARD_DIR_LINE` | does not exist | `&str = "${{ runner.temp }}/shards"` — same technique, sibling path | Same rationale as the `STATUS_DIR` row above, applied to `SHARD_DIR`, which locates the ENTIRE outcomes.json evidence set |
| **NEW (round-9, LOW-1)** `PINNED_MUTANTS_AGGREGATE_MUTANT_COUNT_LINE` | does not exist | `&str = "${{ needs.mutants-plan.outputs.mutant_count }}"` — byte-pins the eval step's `env:` mapping to assert `MUTANT_COUNT:` is bound to exactly this value, via the SAME generic byte-exact env-child-value technique items 10/12/23/24 already use (zero new `wf.rs` code) | Closes the CIRCULAR declination F-H1's own round-8 loop-breaker mandate should have caught: Step 4's reconciliation is keyed on `total_scored != MUTANT_COUNT`, so a PR that hardcodes this env line to a value equal to whatever the pooled shards will produce makes reconciliation pass trivially, disabling INV-AGG sub-invariant 8 (the completeness guard) without touching any previously-pinned surface — the SAME `NEEDS_JSON`-class vector M2-n exists to close, applied to the one remaining env value whose runtime backstop itself CONSUMES the unpinned value |
| **NEW (round-9, LOW-1)** `PINNED_MUTANTS_AGGREGATE_OVERALL_DIFF_LINES_LINE` | does not exist | `&str = "${{ needs.mutants-plan.outputs.overall_diff_lines }}"` — same technique, sibling env child | Closes the same declination class for `OVERALL_DIFF_LINES` — previously accepted as a bounded LOW residual (its Step 5 blast radius is narrow: it can only flip an already-reconciled-to-zero PR's base-ref-drift FAIL into a legitimate-zero-mutants OK, never reach Step 6's kill-rate computation), but round-9 closes it structurally rather than continuing to carry it as an accepted gap, for consistency with `MUTANT_COUNT`/`PLAN_RESULT` now that the technique is zero-cost (no new `wf.rs` code, one more test) |
| **NEW (round-9, LOW-1)** `PINNED_MUTANTS_AGGREGATE_PLAN_RESULT_LINE` | does not exist | `&str = "${{ needs.mutants-plan.result }}"` — same technique, sibling env child | Closes the same declination class for `PLAN_RESULT` — previously accepted on the strength of a traced Step-2 sentinel-presence interlock (a hardcoded `PLAN_RESULT: "success"` literal cannot alone manufacture real shard artifacts), which remains true and is now defense-in-depth alongside, rather than a substitute for, this direct structural pin |
| `EXPECTED_GUARD_TEST_COUNT` | `38` | `65` (+27 total — +5 from the original F2 draft, +5 more from round-1, +1 more from round-2, +2 more from round-3, +7 more from round-4, **round-5/round-6 add none**, +2 more from round-7, +2 more from round-8, +3 more from round-9; see §6.5, §6.6, §6.7, §6.9, §6.10, §6.11, §6.8's round-8 addendum, and §6.8's round-9 addendum) | Append a new history-log doc-comment entry, per this file's own convention, naming all 7 new round-4 tests (5 structural-peer analogs, §6.8, plus 2 reconciliation-independence proofs, §6.9/F2), a round-5 entry noting items 8/9 (rename reverted) and 19/20 (re-scoped, §6.10) changed BODY/assertions only, a round-7 entry naming the 2 new jq-trust-parity tests (items 21-22, §6.11), a round-8 entry naming the 2 new evidence-location value pins (items 23-24, F-H1), AND a round-9 entry naming the 3 new remaining-env-value pins (items 25-27, LOW-1) — the count moves `58 -> 60 -> 62 -> 65` |

**Tests MODIFIED in place (body/rename edits — no net count change):**

1. `test_ci_gate_needs_exactly_the_required_jobs` (AC-003) — the `expected`
   `HashSet` literal's `"mutants"` member → `"mutants-aggregate"`.
2. `test_mutants_is_in_ci_gate_needs` → renamed
   `test_mutants_aggregate_is_in_ci_gate_needs`; body's
   `needs.contains("mutants")` → `needs.contains("mutants-aggregate")`; doc
   comment updated (still under a `MUTATION-CI-TIMEOUT` / cycle-006
   cross-reference header, both cited).
3. `test_mutants_job_structure_unchanged_by_cigate2_option_c` → renamed
   `test_mutants_shard_job_structure_matches_sharded_design` — this is the
   LARGEST single body rewrite in the whole delta (F1 correctly flagged
   this test as high-risk). New assertions: job-level `if:` equals the
   compound expression `github.event_name == 'pull_request' &&
   needs.mutants-plan.outputs.escalated != 'true'` (verify
   `extract_and_normalize_if_expr` accepts this as an opaque plain-scalar
   `&&`-compound value — it should, per its documented "treats the value as
   an opaque plain scalar" contract, but this is a never-before-exercised
   VALUE SHAPE for that function in this file and needs an explicit RED/
   GREEN proof during F4, not an assumption); `needs: [mutants-plan]`;
   `strategy.matrix.shard` sequence has exactly 8 entries (reuses the
   EXISTING generic `job_level_nested_sequence_items` helper from
   `tests/common/wf.rs` — no new wf.rs code needed, see §6.3); required
   step names become **(round-1: revised)**
   `["Harden the runner (Audit all outbound calls)", "Run mutation tests on
   this shard", "Write shard status sentinel", "Upload shard status
   sentinel", "Upload shard outcomes"]` (drops "Check kill rate" — that
   logic moved to `mutants-aggregate`; round-1 inserts the two new sentinel
   steps between the run and upload-outcomes steps, per
   `ci-yml-design.md §2`); `uses:` prefix list gains
   `actions/download-artifact@` and `actions/upload-artifact@` alongside
   the existing three (round-1: `actions/upload-artifact@` now appears
   TWICE in this job — once for the sentinel, once for outcomes.json — the
   prefix-list assertion is unaffected since it checks prefix membership,
   not per-`uses:` cardinality). **(round-3, MEDIUM-2 — forced edit never
   previously named)** This test's PRE-EXISTING AC-006 block (the ONE
   embedded in this same function body — see the real file at
   `:4489-4498`) asserts `steps_with_if.len() == 1` and then indexes
   `steps_with_if[0]` as the SOLE step-level `if:` in the job — under the
   sharded design this job now has THREE step-level `if: always()`
   occurrences ("Write shard status sentinel", "Upload shard status
   sentinel", "Upload shard outcomes" — all three per `ci-yml-design.md
   §2`), not one. This block must be rewritten: `steps_with_if.len() == 3`,
   and EACH of the three (not just index `[0]`) asserted to carry the
   plain-scalar value `always()` via `extract_and_normalize_if_expr`,
   iterating rather than indexing a single element. This is a genuine
   cardinality INVERSION (1 → 3), not a relocation — a fresh-context F2
   adversary found it never named in either of the first two rounds'
   otherwise-detailed rewrite of this same test.
4. `test_ci_gate_needs_jobs_have_no_job_level_if` — extended (not just
   retargeted): for each job in `always_run_needs_members(&ci)`, if the job
   name is a key in `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS`, assert its
   job-level `if:` value (via `extract_and_normalize_if_expr`) EXACTLY
   equals the pinned text instead of asserting no `if:` key exists at all;
   every other always-run job keeps today's unchanged "no job-level `if:`
   key, period" assertion. See §6.4 for why this exception category is
   necessary, not optional.
5. `test_this_file_test_count_matches_expected_denominator` — no logic
   change; `EXPECTED_GUARD_TEST_COUNT`'s doc-comment history log gains
   SEVEN new entries per this file's established convention — one for the
   original F2 draft's 5 tests (bump `38 -> 43`), one for round-1's 5 more
   (bump `43 -> 48`, see §6.5), one for round-2's 1 more (bump
   `48 -> 49`, see §6.2 item 11 below and §6.6), one for round-3's 2
   more (bump `49 -> 51`, see items 12/13 below and §6.7), one for
   round-4's 7 more (bump `51 -> 58`, see items 14-20 below and §6.9),
   one for round-7's 2 more (bump `58 -> 60`, see items 21-22 below and
   §6.11), and one for round-8's 2 more (bump `60 -> 62`, see items 23-24
   below and §6.8's corrected M2-n row / round-8 addendum, F-H1) —
   naming all 24 new tests below across all seven entries, matching the
   granularity every prior round's history-log convention already uses
   (one entry per adversarial pass, not one entry per feature).
6. **(NEW, round-2, HIGH-1(a))**
   `test_ci_gate_decision_matches_job_level_if_for_every_needs_member`
   (`tests/ci_gate_completeness.rs :~6695-6924`) — the hard
   `assert!(saw_positive_branch, ...)` (`:~6907-6916`) is TRANSFORMED, not
   deleted or weakened, into a conditional keyed on whether
   `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS` is populated:
   ```rust
   let expect_positive_branch = !PINNED_ALLOWED_SKIP_IF_EXPRESSIONS.is_empty();
   if expect_positive_branch {
       assert!(saw_positive_branch, /* original message, unchanged text */);
   } else {
       assert!(
           !saw_positive_branch,
           "FAIL: PINNED_ALLOWED_SKIP_IF_EXPRESSIONS is empty (cycle-006 \
            design — mutants-aggregate never reports `skipped`, see \
            architecture-delta.md §6.4), so no ci-gate.needs member should \
            match a pinned skip-tolerant `if:` expression. A positive match \
            here means either this pin desynced from \
            SKIP_TOLERANT_NEEDS_MEMBERS/ALLOWED_SKIPS, or a job was \
            re-admitted to the skip-tolerant category without updating \
            this list."
       );
   }
   ```
   `saw_negative_branch`'s existing hard assert (`:~6918-6925`) is
   UNCHANGED — with the pinned list empty, every job in `ci-gate.needs`
   necessarily fails to match, so the negative branch fires universally
   regardless; nothing about it needs to become conditional. This closes
   the round-2 finding that emptying `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS`
   (as round-1 already specifies, §6.2's constants table) makes
   `saw_positive_branch` permanently unreachable under the OLD hard assert,
   turning CI red the moment F4 lands the retarget — the transform makes
   emptiness itself the thing under test, rather than an assumed
   precondition the test can no longer satisfy. This is the SAME
   transformed test that also carries `all_skip_variants_for`'s signature
   change — see item 7's `all_skip_variants_for` note below; both edits
   land in the same test/helper, still ONE modified test, no net count
   change from this item alone.
7. **(NEW, round-2, HIGH-1(b)+(d))**
   `test_allowed_skips_members_require_job_level_conditional_in_ci_yml`
   (`:~7285-7320`) — the hard `assert!(!allowed_skips.is_empty(), ...)`
   (`:~7311-7317`) is TRANSFORMED into a consistency check, mirroring
   item 6's shape:
   ```rust
   if allowed_skips.is_empty() {
       assert!(
           SKIP_TOLERANT_NEEDS_MEMBERS.is_empty()
               && PINNED_ALLOWED_SKIP_IF_EXPRESSIONS.is_empty(),
           "FAIL: `--print-allowed-skips` printed no job names, but \
            SKIP_TOLERANT_NEEDS_MEMBERS or PINNED_ALLOWED_SKIP_IF_EXPRESSIONS \
            is non-empty — scripts/check-ci-gate.sh's ALLOWED_SKIPS and this \
            file's Rust-side pins have desynced. Either restore ALLOWED_SKIPS \
            in check-ci-gate.sh, or empty the Rust-side pins to match."
       );
   }
   ```
   The `for job in &allowed_skips { ... }` loop immediately below is
   UNCHANGED — it already tolerates zero elements gracefully (a `for` over
   an empty `Vec` is a documented no-op, not a special case needing new
   code) and remains the still-load-bearing check for whatever entries ARE
   present in a future non-empty state.
   Also in scope for THIS item, per HIGH-1(d) (same root cause — a
   hardcoded `"mutants"` companion that no longer names a `ci-gate.needs`
   member once round-1's retarget lands):
   `all_skip_variants_for` (`:~6528-6530`, currently
   `vec![vec![job], vec![job, "mutants"]]`) gains an `all_jobs: &[String]`
   parameter and replaces the hardcoded `"mutants"` companion with a
   dynamically-selected "first other job in `all_jobs`":
   ```rust
   #[cfg(unix)]
   fn all_skip_variants_for<'a>(job: &'a str, all_jobs: &'a [String]) -> Vec<Vec<&'a str>> {
       let companion = all_jobs
           .iter()
           .map(String::as_str)
           .find(|&j| j != job)
           .expect("ci-gate.needs must contain at least 2 members for a multi-skip variant");
       vec![vec![job], vec![job, companion]]
   }
   ```
   Call site (inside
   `test_ci_gate_decision_matches_job_level_if_for_every_needs_member`,
   item 6) becomes `all_skip_variants_for(job, &all_jobs)`. The doc comment
   and the `saw_positive_branch` panic-message narration of `mutants`'
   skip-tolerance (both currently reference the retired job by name) are
   rewritten to describe the general, cycle-006-current mechanism instead
   of a specific job that no longer occupies that role. **Why this
   companion-job change does not need its own regression test for the
   "populated `ALLOWED_SKIPS` still works" case:** identical reasoning to
   §6.1's MEDIUM-1 write-up — the day `SKIP_TOLERANT_NEEDS_MEMBERS`/
   `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS` are next populated, item 6's
   transformed assert flips back to requiring `saw_positive_branch`, which
   re-exercises this exact mechanism end-to-end.
   Both edits (the transformed assert and the `all_skip_variants_for`
   signature change) land in this ONE existing test/helper — no net count
   change from this item.
8. **(NEW, round-3, MEDIUM-2)** `test_allowed_skips_has_exactly_three_
   code_level_references` → renamed
   `test_allowed_skips_has_exactly_four_code_level_references` — see §6.1's
   Fixtures-4/5 write-up for the full mechanism (`run_fixture_with_
   synthetic_skip_tolerant_job`, ONE new shared-helper occurrence, count
   `3 -> 4`). `assert_eq!(count, 3, ...)` → `assert_eq!(count, 4, ...)`; the
   failure-message body's enumerated site list gains the fourth site.
   Additionally closes two stale module-map doc-comment citations found by
   the same fresh-context pass, both forced by round-1's already-specified
   renames but never propagated to this file's OWN top-of-file coverage
   map: (a) `:44`, `test_mutants_is_in_ci_gate_needs → MUTATION-CI-TIMEOUT
   / AC-003` → `test_mutants_aggregate_is_in_ci_gate_needs →
   MUTATION-CI-TIMEOUT / AC-003` (item 2's rename); (b) `:111`,
   `test_mutants_job_structure_unchanged_by_cigate2_option_c → AC-006` →
   `test_mutants_shard_job_structure_matches_sharded_design → AC-006`
   (item 3's rename). Neither (a) nor (b) is a test-body change — both are
   doc-comment text in this file's own module header — but leaving either
   stale means the NEXT reader greps the coverage map for a test name that
   no longer exists, exactly the "silent drift a future reader trusts"
   class this file's own module-map convention exists to prevent. No net
   test-count change from this item (one rename, two doc-comment fixes).
9. **(round-4: F2 MEDIUM reconciliation rollout-policy rename/inversion;
   round-5: REVERTED back to round-1's original — see §6.10)**
   Round-4 had renamed `test_mutants_aggregate_fails_closed_on_mutant_
   count_reconciliation_mismatch` to `test_mutants_aggregate_
   reconciliation_mismatch_emits_non_blocking_warning` and inverted its
   body from asserting `rc == 1` + a FAIL message naming both counts, to
   asserting `rc == 0` + a `::warning::`-prefixed message naming both
   counts. **Round-5 reverts BOTH the rename and the body change**, back
   to the round-1 original: name
   `test_mutants_aggregate_fails_closed_on_mutant_count_reconciliation_
   mismatch`; body asserts `rc == 1` + stdout naming both counts
   (`101`/`100`), with the fixture's 100 scored mutants' own
   `caught`/`missed`/`timeout` split still constructed to yield a pooled
   kill rate `>= 90%` — this now proves the OPPOSITE thing round-4's
   version proved: that a healthy-looking partial kill rate does NOT
   rescue a dropped-mutant mismatch, i.e. the fail is attributable ONLY
   to the reconciliation mismatch, not to an incidental kill-rate
   failure. See `mutants-sharding-invariants.md`'s round-5 callout under
   INV-AGG sub-invariant 8 for the full reversal rationale (restored hard
   fail + mandatory F4 empirical-determination task anchored on PR #778,
   in place of round-4's permissive rollout window) and §6.10 below for
   the consolidated round-5 summary. This is VP-008 in
   verification-delta.md. No net test-count change from this item (one
   name/body revert to an EXISTING test) — items 19/20 (VP-022/023),
   round-4's two companion "independence" tests, are RE-SCOPED (not
   deleted) by this same round — see items 19/20 below and §6.10.

**NEW `#[test]` functions — 27 total across all eight passes (original F2
draft, round-1, round-2, round-3, round-4, round-7, round-8, round-9 —
round-5/round-6 add none, see the constants-table `EXPECTED_GUARD_TEST_
COUNT` row above), drives `EXPECTED_GUARD_TEST_COUNT: 38 → 65`. (Stale
`20 total... 38 → 58` heading corrected round-8, pass-10 LOW-1 — this
heading previously went unbumped when round-7 appended items 21-22 below
it, the same class of running-total drift this document's own "count
consistency" convention exists to prevent; bumped again round-9 for
items 25-27, per that same convention.):**

*Original F2 draft (5, `38 → 43`):*

1. `test_mutants_aggregate_sums_not_averages_shard_kill_rates` — INV-AGG.
   Fixture shape specified in `mutants-sharding-invariants.md §INV-AGG
   Guard-test` (the asymmetric-shard-size construction where naive
   averaging passes and correct pooled summation fails). **(Round-7: this
   is a fixture PAIR, not a singleton — see §6.2a's round-7 correction and
   `mutants-sharding-invariants.md`'s round-7 addendum for Fixture 1B, the
   opposite-direction case where naive averaging fails and pooled summation
   passes. Both fixture CASES live inside this ONE `#[test]` function — no
   `EXPECTED_GUARD_TEST_COUNT` change from this item alone.)**
2. `test_mutants_aggregate_fails_closed_on_missing_shard` — INV-COMPLETE.
   **(Round-1: fixture revised — see §6.5 — now omits a status SENTINEL
   for shard index 3 of 8, not an `outcomes.json`.)** Mid-range missing
   index, not a boundary index.
3. `test_mutants_aggregate_fails_closed_on_duplicate_shard_artifact` —
   INV-COMPLETE. **(Round-1: fixture revised — duplicates a status
   SENTINEL, not an `outcomes.json`.)**
4. `test_mutants_plan_job_exists_and_is_pr_only` — new dedicated structural
   pin for `mutants-plan`'s job-level `if: github.event_name ==
   'pull_request'` and its absence from `ci-gate.needs` (cross-referencing
   `PINNED_GATE_EXCLUDED_JOBS`), mirroring the rigor already applied to the
   OLD `mutants` job's own dedicated existence test before this cycle.
5. `test_mutants_aggregate_expected_shards_matches_matrix_shard_count` —
   drift-prevention cross-check: reads `mutants`'s
   `strategy.matrix.shard` sequence length from `ci.yml` (via the existing
   generic `job_level_nested_sequence_items` helper) AND independently
   extracts the `EXPECTED_SHARDS=` integer literal. **(round-3 correction,
   forced by the §6.2a extraction)** The ORIGINAL two-round design read
   this literal from `mutants-aggregate`'s own inline `run:` step text via
   `Step::value_of("run")`; now that the aggregation logic is extracted
   into `scripts/mutants-aggregate.sh` (§6.2a), `EXPECTED_SHARDS=` lives in
   that FILE, not in `ci.yml`'s YAML at all — the extraction method
   changes to a plain `std::fs::read_to_string("scripts/mutants-
   aggregate.sh")` + a small regex/substring scan for the `EXPECTED_SHARDS=`
   line (simpler than the pre-extraction design, and no longer needs
   `Step::value_of` or any `tests/common/wf.rs` primitive at all for this
   half of the comparison), asserting the two numbers are equal. This is
   the guard that prevents
   the exact false-green class the F1 delta analysis's Risk #2 warned
   about one level deeper: not just "a shard artifact goes missing at
   runtime" (INV-COMPLETE's job), but "someone widens the matrix to 10
   shards and forgets to update the aggregator's own `EXPECTED_SHARDS`
   literal, silently leaving shards 8 and 9 permanently unchecked forever."

*Round-1 adversarial fix (5 more, `43 → 48`) — see §6.5 for the full
narrative:*

6. `test_mutants_aggregate_fails_closed_when_all_shards_crash_under_
   continue_on_error` — **CRIT-1 direct regression proof.** Fixture: all 8
   status sentinels present, every one reporting `run_outcome=failure`,
   `has_outcomes=false` (simulating every shard's `run-mutants` step
   crashing while `continue-on-error: true` masks it at the job level).
   Asserts the aggregator exits 1 and its message identifies a harness
   crash — proves the removed "0 artifacts + non-empty diff → exit 0"
   false-green path cannot be reached via this construction any more.
7. `test_mutants_aggregate_ok_when_shards_are_legitimately_empty` —
   **HIGH-1 direct regression proof.** Fixture: 3 of 8 sentinels report
   `run_outcome=success`, `has_outcomes=false` (legitimate empty
   `--sharding slice` result on a small PR), the other 5 report real data
   whose pooled sum equals a synthetic `MUTANT_COUNT`. Asserts the
   aggregator exits 0 and never names any shard as missing or failed —
   proves a routine small-PR shape does not trip the fail-closed
   machinery CRIT-1's fix introduces.
8. `test_mutants_aggregate_fails_closed_on_mutant_count_reconciliation_
   mismatch` — INV-AGG sub-invariant 8. Fixture: synthetic
   `MUTANT_COUNT=101`, pooled shard sums to `100`. **SUPERSEDED, round-4
   (F2 MEDIUM — reconciliation rollout policy): this test is RENAMED
   `test_mutants_aggregate_reconciliation_mismatch_emits_non_blocking_
   warning` and its assertion inverted from `exit 1` to `exit 0` +
   `::warning::` — see "Tests MODIFIED in place" item 9 above and §6.9
   below for the full account. The original round-1 description
   immediately above ("Asserts exit 1, message names both numbers") is
   kept here verbatim as the historical record of what round-1 through
   round-3 specified; it no longer describes this test's final body.**
9. `test_always_run_with_if_exceptions_disjoint_and_tautological` — MED-1.
   See the `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS` row in the constants
   table above for the exact two-part assertion.
10. `test_mutants_plan_escalated_output_wired_to_aggregate_env` — MED-2.
    See the "escalation-wiring pin" row in the constants table above for
    the exact assertion.

*Round-2 adversarial fix (1 more, `48 → 49`) — see §6.6 for the full
narrative:*

11. `test_skip_tolerant_surface_is_consistently_empty_by_design` — HIGH-1
    (a)+(b), the dedicated, primary consistency check for cycle-006's
    "zero skip-tolerant surface by design" state (items 6/7 above are the
    DEFENSE-IN-DEPTH transforms inside existing tests; this is the
    explicit, single-purpose test naming the invariant directly). Asserts,
    in one place: (1) `SKIP_TOLERANT_NEEDS_MEMBERS.is_empty()`; (2)
    `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS.is_empty()`; (3)
    `scripts/check-ci-gate.sh --print-allowed-skips` (shelled out exactly
    as `test_allowed_skips_members_require_job_level_conditional_in_ci_yml`
    already does) produces zero non-empty lines. Failure message explains
    WHY empty is the expected, by-design cycle-006 state (mutants-aggregate
    is engineered to never report `skipped` — every reachable internal
    state resolves to an explicit `exit 0`/`exit 1`, see architecture-
    delta.md §6.4) rather than reading as an oversight or a broken script,
    and names `architecture-delta.md §6.4`/`§6.6` for the rationale. This
    is the test that makes the invariant-shift from "≥1 legitimate skip
    path must exist" (pre-cycle-006) to "zero skip-tolerant surface by
    design, enforced as three-way consistency" (cycle-006) an explicit,
    intentional, separately-reviewable assertion rather than something
    implied only by the absence of a failure elsewhere. `#[cfg(unix)]`
    (shells out to `scripts/check-ci-gate.sh`, same gating rationale as
    every other bash-subprocess test in this file).

*Round-3 adversarial fix (2 more, `49 → 51`) — see §6.7 for the full
narrative:*

12. `test_mutants_aggregate_event_name_env_wired` — HIGH-1. Byte-pins
    `mutants-aggregate`'s "Evaluate sharded mutation gate" step's `env:`
    mapping to assert `EVENT_NAME:` is bound to the exact value
    `${{ github.event_name }}`, via the SAME `extract_and_normalize_...`
    byte-exact technique item 10 (`test_mutants_plan_escalated_output_
    wired_to_aggregate_env`) already uses for `ESCALATED:`. Structural
    defense-in-depth alongside — NOT a substitute for — the runtime
    fail-closed rewrite of Step 0 itself (§6.2a): the runtime fix makes an
    empty/unrecognized `EVENT_NAME` FAIL correctly; this pin makes the
    WIRING that produces `EVENT_NAME` in the first place independently
    verifiable, so a future edit cannot silently retarget or remove the
    `env:` binding without a structural test naming exactly that.
13. `test_spec_guard_contains_mutants_aggregate_self_test_step` —
    extraction-wiring confirmation (§6.2a). Mirrors the PRE-EXISTING
    `test_spec_guard_contains_check_ci_gate_self_test_step` (AC-008)
    exactly, retargeted at the new sibling script: asserts the
    `spec-guard` block contains a step invoking
    `scripts/mutants-aggregate.sh --self-test`, AND byte-pins that step's
    own `run:` line (anchored by step name "check-mutants-aggregate
    self-test (fixture suite, cycle-006)") via
    `extract_and_normalize_step_run_line_by_name` — closing the same
    "two unrelated `--self-test` substrings elsewhere in the job could
    satisfy a bare substring check" gap S-626-1 pass-54/56 already closed
    for its sibling. This is the test that makes
    `EXPECTED_MUTANTS_AGG_FIXTURES` (§6.2a) actually reachable from CI, not
    merely defined in a script nothing invokes.

*Round-4 adversarial fix (7 more, `51 → 58`) — see §6.8 (structural-peer
enumeration) and §6.9 (consolidated summary) for the full narrative:*

14. `test_mutants_aggregate_decision_step_run_line_is_pinned` — §6.8 M2-i
    analog. Extracts `mutants-aggregate`'s job block, calls the EXISTING
    `extract_and_normalize_sole_run_line(mutants_aggregate_block)` (no new
    helper — see the `PINNED_MUTANTS_AGGREGATE_RUN_LINE` constants-table
    row above), and asserts the result equals
    `PINNED_MUTANTS_AGGREGATE_RUN_LINE` byte-for-byte.
15. `test_mutants_aggregate_decision_step_env_key_set_is_pinned` — §6.8
    M2-o analog. Calls the EXISTING `extract_gate_env_key_set(mutants_
    aggregate_block)` (no new helper — see the `PINNED_MUTANTS_AGGREGATE_
    ENV_KEYS` constants-table row above) and asserts the result, after
    asserting it is non-empty (mirroring M2-o's own "this must not be
    silently treated as nothing to worry about" backstop), equals
    `PINNED_MUTANTS_AGGREGATE_ENV_KEYS`.
16. `test_mutants_aggregate_step_invokes_mutants_aggregate_script` — §6.8
    AC-001 analog, mirroring `test_ci_gate_step_invokes_check_ci_gate_
    script_with_needs_json` (`tests/ci_gate_completeness.rs :~4144`).
    Asserts: (a) the `mutants-aggregate` job block contains the substring
    `scripts/mutants-aggregate.sh`; (b) `WfDoc::parse_single_job`'s
    `job.value_of("if")` resolves to a `Value::Scalar` whose text contains
    `always()` (the presence-level counterpart to item 12's byte-exact
    `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS` check — kept as a SEPARATE,
    looser assertion the same way `ci-gate` itself carries both AC-001's
    substring check AND the M2-a/M2-m byte-exact checks, rather than
    relying on the byte-exact pin alone; see §6.8 for why this
    presence-level layer earns its keep here even with item 14's byte-pin
    already in place).
17. `test_mutants_aggregate_job_block_has_no_key_node_properties` — §6.8
    M2-q analog. Calls the EXISTING, already-generic
    `common::wf::find_key_node_properties(mutants_aggregate_block)` (no
    new `tests/common/wf.rs` code — the function already takes arbitrary
    YAML text, per its own doc comment; it is simply invoked a SECOND
    time, against a second job block) and asserts the returned `Vec` is
    empty, mirroring M2-q's exact assertion shape for `ci-gate`. This is
    the first job OTHER than `ci-gate` this scanner is run against —
    see §6.8 for why `mutants-aggregate` specifically earns this,
    deliberately not extended to every other job.
18. `test_mutants_aggregate_step_level_if_values_are_all_always` — §6.8,
    a genuinely NEW finding this round (no round-1/2/3 analog existed for
    this specific gap). `mutants-aggregate` has THREE steps carrying a
    legitimate step-level `if: always()` ("Download all shard status
    sentinels", "Download all shard outcomes", "Evaluate sharded mutation
    gate" — `ci-yml-design.md §3`) — unlike `ci-gate`, which has NONE
    (M2-d bans step-level `if:` outright there) and unlike the `mutants`
    shard job, whose OWN three step-level `if: always()` occurrences
    already got a dedicated per-step VALUE assertion via round-3's
    rewrite of `test_mutants_shard_job_structure_matches_sharded_design`'s
    AC-006 block (§6.2 "Tests MODIFIED in place" item 3). Before this
    test, `PINNED_ALWAYS_RUN_STEP_KEY_SETS`'s `mutants-aggregate` entry
    (§6.2 constants table) would confirm `if` is a KEY on each of these
    three steps but assert NOTHING about its VALUE — a future edit
    changing one download step's `if: always()` to `if: false` (silently
    skipping status-sentinel or outcome-artifact download, which
    INV-COMPLETE's Step 2/3 would then read as "genuinely missing," a
    FALSE-RED, not a false-green, but a real correctness break
    nonetheless) or to a `needs`-referencing conditional would satisfy
    every OTHER pin in this design while going undetected. Iterates the
    three named steps, resolves each one's `if:` value via
    `extract_and_normalize_if_expr`-equivalent step-scoped resolution
    (`Step::value_of("if")`), and asserts each equals the exact tautology
    `always()` — the SAME cardinality-1-→-3 shape round-3's item 3
    AC-006 rewrite already established as this file's precedent for a
    job with more than one legitimate step-level `if:`, applied here to
    `mutants-aggregate`'s own three instead of `mutants`'s.
19. `test_mutants_aggregate_reconciliation_mismatch_does_not_mask_kill_
    rate_fail` — F2 at round-4 (§6.9); **RE-SCOPED round-5 to the
    OVER-COUNT direction (§6.10)**, since round-4's original fixture
    (mismatch + kill rate BELOW 90%) can no longer reach Step 6 to
    produce a "kill-rate failure" message once Step 4 is a hard fail —
    Step 4 now returns 1 on ANY mismatch before Step 6 ever runs.
    Round-5 fixture: `MUTANT_COUNT=100` vs. pooled `101` (an OVER-count —
    the shard matrix examined and reported on MORE mutants than
    `mutants-plan` counted as in-diff-scope), with the 101 scored
    mutants' `caught`/`missed`/`timeout` split constructed to yield a
    pooled kill rate `>= 90%` (deliberately healthy-looking, so the fail
    is attributable ONLY to the reconciliation mismatch). Asserts
    `rc == 1` and the message names both `100` and `101` — proves the
    round-5 exact-equality decision (§6.10) genuinely covers BOTH
    directions of the comparison, not only the dangerous under-count one
    a naive `<`-only implementation might accidentally encode. This is
    VP-022 in verification-delta.md (re-scoped in place, same VP number).
20. `test_mutants_aggregate_reconciliation_mismatch_does_not_block_
    passing_pr` — F2 at round-4 (§6.9); **RE-SCOPED round-5 — the literal
    "invert to assert FAILS" the round-5 task brief calls for (§6.10)**.
    Fixture: IDENTICAL to item 9's restored fixture (`MUTANT_COUNT=101`,
    pooled `100`, the 100 scored mutants' split yielding a pooled kill
    rate `>= 90%` on the PARTIAL, incomplete set) — deliberately reused,
    same "healthy partial kill rate" shape as item 9, as a dedicated,
    explicitly-named regression pin against ever silently reintroducing
    round-4's warning-only behavior. Asserts `rc == 1`, stdout names the
    reconciliation mismatch (`101`/`100`), and stdout does **NOT**
    contain the Step 6 "gate passed" success message (proving Step 6 is
    genuinely unreachable, not merely that its message happens to be
    absent) — proves a healthy-looking kill rate on the scored SUBSET
    never rescues a dropped-mutant mismatch; completeness is required,
    not just quality of what was examined. This is the direct behavioral
    inverse of round-4's version of this same test (which asserted
    `rc == 0` + the pass message WAS present for this exact fixture).
    This is VP-023 in verification-delta.md (re-scoped in place, same VP
    number) — formal-verifier may rename the Rust fn if the existing
    name (`..._does_not_block_passing_pr`) is judged to no longer
    describe the body under CLAUDE.md's test-naming convention; either
    name is acceptable to this spec as long as the body asserts the three
    conditions above. (Item 9 and item 20 are now near-identical in
    fixture shape by design — item 9 is the primary detection proof,
    item 20 additionally asserts the ABSENCE of the pass message as an
    explicit anti-regression pin against round-4's specific prior
    behavior; this is intentional duplication, not oversight, the same
    "defense-in-depth" rationale round-4 originally used to justify these
    two tests sharing a fixture.)

*Round-7 adversarial fix (2 more, `58 → 60`) — see §6.11 for the full
narrative:*

21. `test_check_ci_gate_sh_and_mutants_aggregate_sh_source_shared_trusted_
    jq_helper` — MED-1. Asserts BOTH `scripts/check-ci-gate.sh` and
    `scripts/mutants-aggregate.sh` contain a `source` line resolving to
    `scripts/lib/trusted-jq.sh` (path-suffix match on the sourced
    argument, tolerant of the pure-bash `${BASH_SOURCE[0]}`-relative
    prefix each file computes — see ci-yml-design.md §3/§3a for the exact
    form), AND that `scripts/lib/trusted-jq.sh` itself exists and defines
    `resolve_trusted_jq`/`is_trusted_jq_dir`/`trusted_jq_dirs_for` (a
    simple substring/function-name presence check on the library file —
    this test proves the WIRING, not the resolver's own runtime
    correctness, which `check-ci-gate.sh`'s existing `run_jq_trust_self_
    test`/`EXPECTED_JQ_TRUST_CHECKS=17` already exhaustively proves and
    this round does not duplicate, per §6.11's "Considered and declined"
    note). Read-only text scan, `#[test]` (no subprocess needed — this is
    a static wiring check, not a runtime behavior proof).
22. `test_check_ci_gate_sh_and_mutants_aggregate_sh_have_no_bare_jq_
    invocations` — MED-1, the genuinely load-bearing half of this round's
    finding. For EACH of `scripts/check-ci-gate.sh` and `scripts/
    mutants-aggregate.sh`, scans every line for a `jq` COMMAND invocation
    (a line whose first non-whitespace token, or the token immediately
    after a `!`/`|`/`$(`/`if`/`while` etc., is literally `jq`) and asserts
    it is ALWAYS written as `"${jq_bin}"` (or, inside `scripts/lib/
    trusted-jq.sh` itself, the single legitimate `command -v jq` in
    `resolve_trusted_jq` — explicitly excluded by name/line-anchor, not by
    a blanket allowlist of the whole file, so a SECOND bare `jq` call
    accidentally added to `trusted-jq.sh` outside that one resolution line
    still fails this test) — never a bare `jq`. Default-deny: any bare
    `jq` invocation found anywhere else fails the test, naming the file
    and line. This is the check that actually closes MED-1 end to end —
    item 21 alone (sourcing the file) proves nothing about whether every
    call site actually USES the resolved binary; a script could source
    `trusted-jq.sh` and still, by carelessness, call bare `jq` at some
    call site, silently bypassing the whole resolver. Both scripts pass
    this test TODAY once the ci-yml-design.md §3/§3a changes land (grep-
    confirmed against the design text: every jq invocation in both files
    already routes through `${jq_bin}`), so this is a REGRESSION guard
    from day one, not a fixture proving a currently-broken state.
    `#[test]` (static text scan, no subprocess).

*Round-8 adversarial fix (2 more, `60 → 62`) — see §6.8's corrected M2-n
row for the full narrative (F-H1, the HIGH false-green a fresh adversary
found in the pre-round-8 declined disposition):*

23. `test_mutants_aggregate_status_dir_env_wired` — F-H1. Byte-pins
    `mutants-aggregate`'s "Evaluate sharded mutation gate" step's `env:`
    mapping to assert `STATUS_DIR:` is bound to the exact byte value
    `${{ runner.temp }}/shard-status`, via the SAME `extract_and_
    normalize_...` byte-exact env-child-value technique items 10/12
    already use for `ESCALATED:`/`EVENT_NAME:` — zero new `wf.rs` code.
    Constant: `PINNED_MUTANTS_AGGREGATE_STATUS_DIR_LINE`. Closes the
    `NEEDS_JSON`-class false-green where a PR redirects `STATUS_DIR` to an
    attacker-controlled directory and checks in a fabricated sentinel tree
    reporting whatever `run_outcome`/`has_outcomes` values are needed to
    make Step 2/3 pass — the `${VAR:?message}` runtime guard (§6.2a)
    catches only the UNSET/EMPTY case and provides no defense against this
    SET-but-malicious case; this pin is the complementary structural
    defense, not a substitute for `:?` (which remains in the script for
    the failure mode it DOES catch).
24. `test_mutants_aggregate_shard_dir_env_wired` — F-H1, the SAME finding
    and the SAME technique applied to the sibling path. Byte-pins
    `SHARD_DIR:` to the exact byte value `${{ runner.temp }}/shards`.
    Constant: `PINNED_MUTANTS_AGGREGATE_SHARD_DIR_LINE`. Two separate
    tests (mirroring the pre-existing one-test-per-pinned-variable
    convention items 10/12 already established for `ESCALATED`/
    `EVENT_NAME`, rather than one combined test), so a future edit that
    retargets only ONE of the two paths still fails a specifically-named
    test rather than a shared one whose failure message must disambiguate
    which path moved.

*Round-9 adversarial fix (3 more, `62 → 65`) — see §6.8's round-9
addendum for the full narrative (LOW-1, the circular-declination gap a
fresh pass-13 adversary found in the round-8 re-audit's own reasoning):*

25. `test_mutants_aggregate_mutant_count_env_wired` — LOW-1. Byte-pins
    `mutants-aggregate`'s "Evaluate sharded mutation gate" step's `env:`
    mapping to assert `MUTANT_COUNT:` is bound to the exact byte value
    `${{ needs.mutants-plan.outputs.mutant_count }}`, via the SAME
    `extract_and_normalize_...` byte-exact env-child-value technique
    items 10/12/23/24 already use — zero new `wf.rs` code. Constant:
    `PINNED_MUTANTS_AGGREGATE_MUTANT_COUNT_LINE`. Closes the class of
    false-green where a PR hardcodes `MUTANT_COUNT:` to a value equal to
    whatever the pooled shards will actually sum to, making Step 4's
    `total_scored != MUTANT_COUNT` reconciliation pass trivially and
    disabling INV-AGG sub-invariant 8 (the completeness guard) without
    touching any previously-pinned surface — the reconciliation check
    itself is a genuine, independent, still-valuable proof against
    per-shard PLAN↔EXECUTION divergence, but it CONSUMES `MUTANT_COUNT`
    rather than independently verifying its wiring, so it cannot also
    stand in for a structural pin on the value it reads. This pin is
    complementary defense-in-depth, not a substitute for reconciliation.
26. `test_mutants_aggregate_overall_diff_lines_env_wired` — LOW-1, same
    technique applied to the sibling env child. Byte-pins
    `OVERALL_DIFF_LINES:` to the exact byte value `${{ needs.mutants-plan.
    outputs.overall_diff_lines }}`. Constant: `PINNED_MUTANTS_AGGREGATE_
    OVERALL_DIFF_LINES_LINE`. Previously accepted as a bounded, disclosed
    LOW residual (its Step 5 blast radius is narrow — it can only flip an
    already-reconciled-to-zero PR's base-ref-drift FAIL into a
    legitimate-zero-mutants OK, never reach Step 6's kill-rate
    computation); round-9 closes it structurally anyway, since the same
    zero-cost technique that closes `MUTANT_COUNT`/`PLAN_RESULT` applies
    here for one more test, retiring the residual entirely rather than
    continuing to carry it as an accepted gap.
27. `test_mutants_aggregate_plan_result_env_wired` — LOW-1, same technique
    applied to the last remaining env child. Byte-pins `PLAN_RESULT:` to
    the exact byte value `${{ needs.mutants-plan.result }}`. Constant:
    `PINNED_MUTANTS_AGGREGATE_PLAN_RESULT_LINE`. Previously accepted on
    the strength of a traced Step-2 sentinel-presence interlock (a
    hardcoded `PLAN_RESULT: "success"` literal cannot alone manufacture
    real shard artifacts, because GHA's default `needs:` semantics skip
    the `mutants` shard matrix job entirely on a genuine `mutants-plan`
    failure) — that interlock remains true and is retained as an
    independent, traced mechanism; this pin is defense-in-depth alongside
    it, not a replacement for it.

With items 25-27 landed, ALL SEVEN of `mutants-aggregate`'s eval-step env
values (`ESCALATED`, `EVENT_NAME`, `MUTANT_COUNT`, `OVERALL_DIFF_LINES`,
`PLAN_RESULT`, `SHARD_DIR`, `STATUS_DIR`) carry an individual byte-VALUE
pin on top of the item-15 key-set pin — the "declined env-value pin"
category (§6.8's M2-n row, the declined-additions entry immediately
below) is retired entirely, not merely narrowed further.

**Considered and explicitly declined additions (documented for
transparency, not omitted by oversight):**

- **No new `run_jq_trust_self_test`-equivalent 17-check suite duplicated
  inside `mutants-aggregate.sh --self-test`.** See §6.11's own "Considered
  and declined" note — the shared library is the SAME code
  `check-ci-gate.sh`'s existing suite already exhaustively proves;
  duplicating it would inflate `EXPECTED_MUTANTS_AGG_FIXTURES` with zero
  incremental coverage, the same reasoning §6.8 already applies to M2-g/h.

- **No new structural pin for `cargo-mutants@27.1.0`.** Grep-confirmed: no
  existing test in this file byte-pins the `cargo-mutants@27` install-action
  version string today (the version pin is validated by the malformed-JSON/
  H-1 schema-drift/M-2 reconciliation guards + actual CI behavior, not a
  structural Rust-side pin). The `@27` → `@27.1.0` tightening follows the
  SAME precedent — no new test.
- **No new structural pin for the `ESCALATION_THRESHOLD=120` literal.**
  Same precedent as `--timeout 240`, which has never had a dedicated
  byte-pin in this file either (it is documented and policy-governed, not
  structurally pinned). Consistency over completeness here.
- **RETIRED round-9 (LOW-1) — no declination remains; see items 25-27
  above and §6.8's round-9 addendum for the full narrative.** Through
  round-8 this bullet declined a dedicated byte-VALUE wiring pin for
  `MUTANT_COUNT`, `OVERALL_DIFF_LINES`, and `PLAN_RESULT` — the 3 of 7
  `mutants-aggregate` env keys that remained key-set-pinned but
  value-unpinned after round-8's `STATUS_DIR`/`SHARD_DIR` fix (items
  23/24). A fresh-context pass-13 adversary found that rationale
  CIRCULAR for `MUTANT_COUNT` specifically, under the exact env-edit
  threat model F-H1 (round-8) itself adopted: Step 4 reconciliation is
  keyed on `total_scored != MUTANT_COUNT`, so a PR that hardcodes the
  eval step's `MUTANT_COUNT:` env value to whatever total the pooled
  shards will produce makes reconciliation pass trivially — the runtime
  backstop this bullet cited as "why a pin is unnecessary" itself
  CONSUMES the very value the bullet declined to pin. Bounded LOW (not
  HIGH like F-H1) because `MUTANT_COUNT` is a single plaintext,
  PR-visible integer with no directory-redirect blast radius — but the
  reasoning gap is the SAME class F-H1 closed one round earlier, and the
  round-8 loop-breaker re-audit (below) should have caught it. **Fix:**
  rather than continue litigating each of the three declinations
  individually (the historical per-variable reasoning is preserved
  below, superseded, for audit continuity), round-9 closes all three
  structurally: `PINNED_MUTANTS_AGGREGATE_MUTANT_COUNT_LINE`,
  `_OVERALL_DIFF_LINES_LINE`, and `_PLAN_RESULT_LINE` (items 25-27, §6.2)
  use the SAME zero-marginal-cost generic byte-exact env-child-value
  technique items 10/12/23/24 already established. This eliminates the
  "declined env-value pin" category for this job entirely — no
  `mutants-aggregate` eval-step env value is now key-set-pinned without
  also being individually value-pinned.

  **Historical per-variable reasoning (superseded by the fix above,
  retained for audit trail — this is no longer this document's operative
  position):** `MUTANT_COUNT` was behaviorally reconciled against the
  shards' own pooled total (INV-AGG sub-invariant 8) — that reconciliation
  remains a genuine, independent, still-valuable proof against per-shard
  PLAN↔EXECUTION divergence, and item 25's new pin is DEFENSE-IN-DEPTH
  alongside it, not a replacement for it (a wrong/mistyped `MUTANT_COUNT`
  is still caught two ways now: the reconciliation arithmetic AND the
  wiring pin). `PLAN_RESULT` was consumed via a comparison whose
  EMPTY-value behavior is inherently fail-closed, and a traced Step-2
  sentinel-presence interlock (a hardcoded `PLAN_RESULT: "success"`
  cannot alone manufacture real shard artifacts, since GHA's default
  `needs:` semantics skip the `mutants` shard-matrix job entirely on a
  genuine `mutants-plan` failure) — that interlock remains true and item
  27's pin is defense-in-depth alongside it. `OVERALL_DIFF_LINES` was
  consumed via a `^[0-9]+$` regex guard with correctly-scoped
  EMPTY/malformed-value fail-closed behavior and an explicitly-bounded,
  disclosed LOW residual (Step 5 only, cannot reach Step 6's kill-rate
  computation) — round-9 closes it anyway via item 26, for consistency
  with the other two now that the technique is zero-cost, retiring the
  residual rather than continuing to carry it as an accepted gap.
  `STATUS_DIR`/`SHARD_DIR` are READ via bash's
  own `${VAR:?message}` operator (§6.2a), which correctly aborts the
  script on UNSET/EMPTY — **but round-8 (F-H1) found this fact was
  previously mis-cited as justification for declining a byte-VALUE pin
  entirely ("stronger than any static pin could assert"), which
  conflates two different failure modes: `:?` guards only the UNSET/EMPTY
  case; it provides ZERO protection against a maliciously-but-VALIDLY-SET
  redirect to an attacker-controlled directory, which is the failure mode
  that actually matters here — `STATUS_DIR`/`SHARD_DIR` are the ENTIRE
  evidence-location mechanism this script's decision reads through (the
  `NEEDS_JSON`-class M2-n analog for this job), so a redirect forges not
  one value but the FULL evidence set every other check in this table
  (Step 2 sentinel presence, Step 3 malformed-JSON/schema-drift guards,
  Step 4 MUTANT_COUNT reconciliation) then faithfully validates as
  internally consistent, because the attacker controls all of it
  simultaneously. `:?` and a byte-VALUE pin are COMPLEMENTARY, not
  substitutes — `:?` still catches the accidental-unset case a pin cannot
  (a pin only proves the literal TEXT of the `env:` line; it says nothing
  about a runtime substitution failure), and the pin now catches the
  redirect case `:?` never could. Both are now present — see items 23/24,
  §6.2, and §6.8's corrected M2-n row.**
- **No change to `tests/mutants_glob_existence.rs`** — confirmed via
  `.cargo/mutants.toml` inspection that `examine_globs` requires no changes
  for this delta (sharding/baseline/timeout/escalation are all CLI-only
  flags or CI-script-only literals; nothing in this delta adds or removes
  an `examine_globs` entry).

### 6.2a `scripts/mutants-aggregate.sh` (NEW file — round-3, extraction
precondition)

**Why this subsection exists.** Rounds 1 and 2 specified the aggregation
logic (`ci-yml-design.md §3`, "Evaluate sharded mutation gate") as INLINE
`run: |` bash text embedded directly in `ci.yml`. A fresh-context round-3
adversary observed that `mutants-sharding-invariants.md`'s own Guard-test
write-ups for items 1/2/3/6/7/8 (§6.2 above) already describe themselves
as "mirroring `check-ci-gate.sh`'s `check_fixture` pattern" — i.e. they
assume a SHIPPED, INVOKABLE script under test, the same shape
`check-ci-gate.sh`'s own `#[cfg(unix)]` subprocess tests exercise. Inline
`run:` text cannot be invoked directly from a Rust test or a bash
`--self-test` harness — only re-parsed as YAML text and either
re-interpreted (fragile, and precisely the "extraction under-reports"
failure class this repo's entire CI-gate history exists to eliminate) or
duplicated into a second copy that can drift from what actually ships.
**This is a HARD F2-gate precondition, not an optional cleanup:** without
this extraction, items 1/2/3/6/7/8 cannot be genuine behavioral proofs
against shipped logic — F4 would either have to invent a fragile
YAML-text-reparsing shim (reintroducing the exact defect class S-CIGATE-3
was built to retire) or silently downgrade those six guard-tests to
Rust-side re-implementations of the arithmetic that could pass while the
real `ci.yml` script diverges. **Flagged here for explicit human
confirmation at the F2 gate**, the same way `architecture-delta.md §1`
already flags the PR #778 sequencing precondition — this is a second,
independent BLOCKING precondition, and both must be confirmed before F4
begins.

**The extraction itself.** `ci-yml-design.md §3`'s "Evaluate sharded
mutation gate" step's ENTIRE `run: |` body (Steps 0 through 6, unchanged
logic from round-2 plus round-3's Step 0 rewrite below) moves verbatim
into a new file, `scripts/mutants-aggregate.sh`, structured to mirror
`scripts/check-ci-gate.sh`'s own shape:

- A pure(ish) function, `evaluate_mutants_aggregate()`, containing Steps
  0–6 with every top-level `exit N` converted to `return N` (so it is
  callable as a subroutine from a self-test harness without terminating
  the whole process) — the function reads its inputs from environment
  variables and two directory paths, and writes its diagnostics to stdout,
  exactly as the inline version already did.
- A `main()` dispatcher: `main "$@"` — with no arguments, calls
  `evaluate_mutants_aggregate` and `exit`s with its return code (the real
  CI invocation); with `--self-test`, runs the new bash fixture harness
  below instead and never touches real `runner.temp` paths.
- The step in `ci.yml` becomes a one-line `run: bash scripts/mutants-
  aggregate.sh` (mirrors `check-ci-gate.sh`'s own `run: bash
  scripts/check-ci-gate.sh` invocation style — no `chmod +x`/shebang
  execute-bit dependency, since it is invoked via `bash`, not `./script`).

**A genuine finding the extraction surfaces (not present in the inline
version's own text, but real the moment the logic leaves YAML).** The
inline design read `STATUS_DIR="${{ runner.temp }}/shard-status"` and
`SHARD_DIR="${{ runner.temp }}/shards"` directly inside the bash text —
this relies on GitHub Actions' `${{ }}` expression substitution, which
ONLY happens at YAML-render time, within YAML fields (`run:`, `env:`,
`with:`, …). A `${{ }}` token inside a file invoked BY a `run:` step (as
opposed to inside the `run:` field's own text) is never substituted — it
would reach the script as the literal eight characters `${{ runner.temp
}}`. The step's `env:` mapping must therefore gain two new keys so the
script receives these paths as ordinary environment variables instead:
```yaml
        env:
          EVENT_NAME: ${{ github.event_name }}
          ESCALATED: ${{ needs.mutants-plan.outputs.escalated }}
          OVERALL_DIFF_LINES: ${{ needs.mutants-plan.outputs.overall_diff_lines }}
          MUTANT_COUNT: ${{ needs.mutants-plan.outputs.mutant_count }}
          PLAN_RESULT: ${{ needs.mutants-plan.result }}
          STATUS_DIR: ${{ runner.temp }}/shard-status   # NEW — round-3 extraction finding
          SHARD_DIR: ${{ runner.temp }}/shards           # NEW — round-3 extraction finding
        run: bash scripts/mutants-aggregate.sh
```
and the script body replaces the two inline `STATUS_DIR="${{ runner.temp
}}/shard-status"` / `SHARD_DIR="${{ runner.temp }}/shards"` assignments
with `STATUS_DIR="${STATUS_DIR:?STATUS_DIR must be set}"` / `SHARD_DIR="${SHARD_DIR:?SHARD_DIR must be set}"`
(fail loudly on an unset value rather than silently operating on an empty
path). This is exactly the kind of latent gap the extraction was worth
doing FOR — had F4 implemented the inline design verbatim and only
discovered this at the point of writing the (already-planned) behavioral
subprocess tests, it would have been a surprise mid-implementation rather
than a known, specified precondition.

**Step 0 rewrite (HIGH-1, the headline round-3 finding) — fail-closed
event-event recognition, replacing the round-1/round-2 fail-open check:**
```bash
  # --- Step 0: push-event no-op (this job's only "skipped"-equivalent
  #     path — resolved as an ordinary success, NEVER a GHA `skipped`
  #     conclusion; see ci-yml-design.md §3's job-level if: always() comment).
  #
  #     ROUND-3 ADVERSARIAL FIX (HIGH-1). The pre-fix check
  #     (`if [ "${EVENT_NAME}" != "pull_request" ]; then exit 0; fi`) was
  #     FAIL-OPEN on a malformed EVENT_NAME: GitHub Actions resolves an
  #     invalid/mistyped `${{ }}` expression to an EMPTY string, not an
  #     error (same platform behavior the pre-existing MED-2/round-1
  #     escalation-wiring pin already guards for on the OUTPUT side — this
  #     is the identical class on the INPUT side). A typo in this step's
  #     own `env:` block (e.g. `EVENT_NAME: ${{ github.event_nam }}`)
  #     would make EVENT_NAME="" on EVERY run, including a genuine
  #     pull_request run — and the pre-fix `!=` comparison treats "" as
  #     "not pull_request," exiting 0 with ZERO shard inspection: a
  #     false-green on the one input this script trusts to even decide
  #     whether to run its own logic.
  #
  #     Fixed: only a KNOWN, explicitly-recognized non-PR event exits 0
  #     early; anything else — including an empty string, and including
  #     any FUTURE trigger event nobody has added to this case statement
  #     yet — falls through to a hard FAIL naming the unrecognized value.
  case "${EVENT_NAME}" in
    pull_request)
      : # fall through — this is the one event this gate exists for
      ;;
    push|schedule|workflow_dispatch)
      echo "OK: not a pull_request event (${EVENT_NAME}) — mutation gate not applicable, same as the pre-sharding design's push-event skip."
      return 0
      ;;
    *)
      echo "FAIL: EVENT_NAME ('${EVENT_NAME}') is neither 'pull_request' nor a recognized non-PR event (push, schedule, workflow_dispatch). Treating an empty or unrecognized value as a FAIL, not a pass-through — a malformed EVENT_NAME must never be silently interpreted as 'nothing to do here.' If this is a legitimate new ci.yml trigger event, add it to this case statement's non-PR branch explicitly, in the SAME change that adds the trigger."
      return 1
      ;;
  esac
```
The three non-PR branches (`push`, `schedule`, `workflow_dispatch`) are
the only events `ci.yml`'s own top-level `on:` block can plausibly ever
fire this job under (`ci.yml` currently has no `schedule:`/
`workflow_dispatch:` trigger of its own, but the allowlist is written to
tolerate a future one without itself needing revision) — grounded in
GitHub Actions' actual documented event vocabulary, not an arbitrary
guess; F4 should re-verify this list against `ci.yml`'s current `on:`
block at implementation time and extend it (never remove from it) if a
new trigger has been added since this document was written.

**Rust structural pin for the wiring (not the runtime logic — see item
12, §6.2 table):** `test_mutants_aggregate_event_name_env_wired` confirms
the `env:` binding above stays intact; it does NOT re-verify the case
statement's own correctness (that is the self-test harness's job,
directly below), consistent with this file's own precedent that
CI-script-INTERNAL control flow is proven by the script's own
`--self-test`, while the YAML WIRING feeding it is proven by a Rust
structural pin — the same two-layer split `ESCALATED`'s MED-2/round-1 pin
already established.

**`--self-test` harness — new sibling to `scripts/check-ci-gate.sh
--self-test`, wired into `spec-guard`.** `scripts/mutants-aggregate.sh`
gains its OWN fixture harness (`EXPECTED_MUTANTS_AGG_FIXTURES`, a
`check_agg_fixture` helper mirroring `check_fixture`'s shape but building
a temporary `STATUS_DIR`/`SHARD_DIR` tree per fixture via `mktemp -d`
before invoking `evaluate_mutants_aggregate` in a subshell and capturing
its return code + stdout, then removing the temp tree). This is the
mechanism that finally makes items 1/2/3/6/7/8 (§6.2) genuine behavioral
proofs: each of those Rust guard-tests is retargeted (no name change, no
count change — this is a MECHANISM change to how they execute, exactly
parallel to how `check-ci-gate.sh`'s own fixtures complement its
`#[cfg(unix)]` Rust subprocess tests) to become a `#[cfg(unix)]`
subprocess test that shells out to `bash scripts/mutants-aggregate.sh`
directly with a synthetic `STATUS_DIR`/`SHARD_DIR` tree and env vars,
asserting real exit code + stdout content — not a Rust-side
re-implementation of the summation/reconciliation arithmetic. Two fully
specified illustrative fixtures (F4 constructs the rest, one per already-
enumerated guard-test, using the identical synthetic-tree-then-invoke
technique):
```bash
  # Fixture: event-name-empty-fails-closed — HIGH-1 direct regression
  # proof. EVENT_NAME unset/empty (simulating the mistyped-expression
  # class), PLAN_RESULT/ESCALATED/MUTANT_COUNT irrelevant (Step 0 must
  # short-circuit before touching them). Expect: rc=1, stdout contains
  # "FAIL: EVENT_NAME".
  check_agg_fixture \
      "event-name-empty-fails-closed" \
      --env EVENT_NAME="" \
      "fail:1" \
      "FAIL: EVENT_NAME"

  # Fixture: event-name-push-is-ok-noop — confirms the FIXED case
  # statement still correctly no-ops on a genuine push event (the
  # pre-fix behavior this round-3 change must NOT regress).
  # Expect: rc=0, stdout contains "OK: not a pull_request event".
  check_agg_fixture \
      "event-name-push-is-ok-noop" \
      --env EVENT_NAME="push" \
      "pass" \
      "OK: not a pull_request event"
```
**Round-4 note on item 8's fixture, SUPERSEDED by round-5's reconciliation
reversal (§6.10) — this paragraph now states the OPERATIVE round-5
fixture shapes, not round-4's warning-only ones.** (Round-4's original
text specified `rc="pass"` + a `"::warning::"` substring for item 8's
fixture and a sub-90%-kill-rate `rc="fail:1"` shape for item 19; both were
never updated when round-5 restored the hard fail, leaving this paragraph
internally contradicting §6.2's item 9/19/20 text, the INV-AGG
sub-invariant 8 round-5 callout in `mutants-sharding-invariants.md`, and
§6.10 below — corrected here, round-6, in lockstep with all three.) The
three self-test fixtures backing items 8/9, 19, and 20
(`EXPECTED_MUTANTS_AGG_FIXTURES`, unchanged at `10` post-round-5 — §6.10)
are, as of round-5 (unchanged by round-6's documentation-only fix):

- **Item 8/9's fixture** (`test_mutants_aggregate_fails_closed_on_mutant_
  count_reconciliation_mismatch`, the round-1 name restored by round-5) —
  synthetic `MUTANT_COUNT=101`, pooled shard sum `100`, the 100 scored
  mutants' `caught`/`missed`/`timeout` split constructed to yield a
  pooled kill rate `>= 90%` (a healthy-looking PARTIAL result, so the
  failure is attributable only to the reconciliation mismatch). Expect:
  `rc="fail:1"`, stdout names both `101` and `100`.
- **Item 19's fixture** (`test_mutants_aggregate_reconciliation_mismatch_
  does_not_mask_kill_rate_fail`, re-scoped by round-5 to the OVER-COUNT
  direction) — synthetic `MUTANT_COUNT=100`, pooled shard sum `101`, the
  101 scored mutants' split again constructed to yield a pooled kill rate
  `>= 90%`. Expect: `rc="fail:1"`, stdout names both `100` and `101` —
  proves the restored exact-equality check catches the over-count
  direction too, not only the dangerous under-count one.
- **Item 20's fixture** (`test_mutants_aggregate_reconciliation_mismatch_
  does_not_block_passing_pr`, re-scoped by round-5) — IDENTICAL
  construction to item 8/9's fixture (`MUTANT_COUNT=101`, pooled `100`,
  healthy partial kill rate), reused deliberately as a dedicated
  anti-regression pin against round-4's warning-only shape. Expect:
  `rc="fail:1"`, stdout names the mismatch (`101`/`100`), AND stdout does
  **NOT** contain the Step 6 "gate passed" success-message substring —
  proving Step 6 is genuinely unreachable on this fixture, not merely
  absent from the assertion.

This keeps the provisional floor established at round-4 (`10` total: the
pre-round-4 8 — 2 header fixtures + 1 per item among 1/2/3/6/7/8 — plus
the 2 round-4 sibling fixtures for items 19/20) unchanged at round-5 and
round-6: round-5 changed the BODY/expected-outcome of these same three
fixture slots in place (item 8/9's, item 19's, item 20's), adding and
removing no fixture slot — the identical "no net count change" shape
§6.10's closing numbers paragraph documents for the Rust-side test count;
round-6 changes only this paragraph's PROSE to match, not the fixtures
themselves.

**Round-7 correction (LOW-2) — the `10` floor above is a KNOWN undercount,
by two independent terms the formula never priced in.** A fresh-context F2
adversary observed the derivation quoted at the top of this paragraph ("2
header + 1 per item among 1/2/3/6/7/8 + 2 for 19/20") is composed of TWO
gaps:

1. **Item 1's fixture is a PAIR, not a singleton.**
   `test_mutants_aggregate_sums_not_averages_shard_kill_rates` (item 1)
   was counted as contributing exactly 1 fixture to this floor. A
   SINGLE-direction construction (naive average PASSES, pooled sum FAILS
   — the only shape mutants-sharding-invariants.md's INV-AGG Guard-test
   specified through round-6) cannot distinguish "this aggregator sums
   correctly" from "this aggregator merely fails whenever shard rates are
   asymmetric" — a mutant that replaced the summation with, say, "always
   fail on asymmetric shard sizes" would pass this single fixture's own
   assertion despite being wrong. `mutants-sharding-invariants.md`'s
   round-7 addendum adds the missing complementary Fixture 1B (naive
   average FAILS, pooled sum PASSES — Shard A `caught=1, missed=1`, Shard
   B `caught=98, missed=2`, pooled ≈97%), matching
   `verification-delta.md`'s independently-maintained VP-001, which
   already specified both directions ("two fixtures, straddling the 90%
   line in OPPOSITE directions — a one-directional fixture cannot
   distinguish sum from average"). Item 1 therefore contributes **2**
   fixtures to this floor, not 1.
2. **The Step-0.5 `PLAN_RESULT != "success"` fixture was never a term in
   this formula at all.** VP-013's own companion note (verification-
   delta.md, maintained separately) names it explicitly: "the adjacent
   `--list` tooling-error hardening... surfaces at the aggregator as
   `PLAN_RESULT != "success"` and is exercised by a co-located Step-0.5
   fixture on this same harness." This is a real, distinct, required
   fixture (`mutants-sharding-invariants.md`'s Step 0.5 diagnostics
   branch, added round-2) that this document's own "2 header + 6 items +
   2" arithmetic simply omitted as a term — not a disagreement about
   whether it belongs on this harness (it self-evidently does, per the
   companion note above), only an arithmetic gap in the prior tally.
   **+1.**

**Corrected floor: `10 -> 12`** (`+1` for item 1's fixture pair, `+1` for
the previously-uncounted Step-0.5 fixture). Restated for clarity, NOT a
new derivation: 2 header fixtures (event-name-empty / event-name-push) + 7
for items 1(×2)/2/3/6/7/8 + 2 for items 19/20 + 1 for Step-0.5 = 12.
**Confirmed NOT an additional gap, raised alongside this finding for
context**: "item 2 (missing-shard) and item 3 (duplicate-shard-artifact)
together cover both halves of INV-COMPLETE Part B" is already correctly
reflected in the pre-existing formula — items 2 and 3 are TWO separate
terms within the "6" for items 1/2/3/6/7/8, each already contributing 1
fixture (missing + duplicate = 2 total), so there is no additional
undercount to correct there. This remains a PROVISIONAL floor — F4
finalizes the exact number against the fixed-denominator self-check
pattern `EXPECTED_FIXTURES` already establishes in `check-ci-gate.sh`,
updating this document's number if the final count differs (per this
document's own established precedent, e.g. `--timeout 240`/
`ESCALATION_THRESHOLD=120`) — the correction here is that `10` was a
KNOWN undercount and must not ship as the stated floor, not a claim that
`12` is the final, exact number.

Per this document's own established precedent, the FIXTURE BODIES
themselves are a code-review-time obligation matched against the
Guard-test descriptions in `mutants-sharding-invariants.md` — not
individually byte-pinned by a Rust-side test beyond the two structural
pins (items 12/13, §6.2) that confirm the wiring and CI invocation exist.

**`spec-guard` wiring — new step, immediately after the existing
check-ci-gate self-test step:**
```yaml
      - name: check-mutants-aggregate self-test (fixture suite, cycle-006)
        run: bash scripts/mutants-aggregate.sh --self-test
```
This is the step `test_spec_guard_contains_mutants_aggregate_self_test_
step` (item 13, §6.2) structurally pins, and it is what makes
`EXPECTED_MUTANTS_AGG_FIXTURES` actually RUN in CI rather than merely
being defined in a script nothing invokes — the same "a self-test suite
nobody runs is not a guard, it's dead code with a comforting name"
concern this file's own history treats seriously (see `EXPECTED_WF_TEST_
COUNT`'s own tripwire rationale, fix-burst-6, cited in CLAUDE.md).
`PINNED_ALWAYS_RUN_STEP_KEY_SETS`'s `spec-guard` entry (§6.2 constants
table, this round) gains its 13th `&["name", "run"]` tuple for this new
step, in the SAME commit.

### 6.3 `tests/common/wf.rs` — ZERO changes required (verified, not assumed)

The F1 delta analysis flagged this as an open question ("F2 must confirm
whether `WfDoc`... already handle[s] a job with `strategy: {matrix:
{...}}` correctly, or whether a new accessor is needed"). Confirmed by
direct inspection this session:

- `job_level_nested_value`, `job_level_nested_keys`, and
  `job_level_nested_sequence_items` (the three functions
  `test_matrix_os_lists_remain_static_literals` already uses for `clippy`/
  `test`'s `strategy.matrix.os`) all take a generic `path: &[&str]` — none
  of them special-case the string `"os"`. `["strategy", "matrix", "shard"]`
  is read by exactly the same generic path-based tree lookup as
  `["strategy", "matrix", "os"]`, with zero new code.
- A grep for the literal string `"mutants"` across `tests/common/wf.rs`
  returns zero hits today — there is no `mutants`-specific logic in this
  file to retarget.
- The new `mutants` (shard) job never becomes a `ci-gate.needs` member, so
  it never enters `matrix_needs_members()`'s candidate set at all — the
  `os`-specific test that DOES consume `job_level_nested_sequence_items`
  (`test_matrix_os_lists_remain_static_literals`) simply never looks at
  it, sidestepping any question of whether that test's `os_path` literal
  needs generalizing.
- `EXPECTED_WF_TEST_COUNT` (`26`) is unaffected — no new `#[cfg(test)]`
  test is added to `wf.rs`'s own test module by this delta.

**Conclusion: `tests/common/wf.rs` requires no edits for cycle-006.** This
is a confirmed finding, not a placeholder for F4 to re-derive.

### 6.4 The one genuinely novel structural finding — `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS`

This is the single most important design decision in this delta and the
reason the guardrail plan above is larger than a mechanical
"rename mutants → mutants-aggregate everywhere" would suggest. It deserves
its own explanation, not just a table row.

**The problem.** `mutants-aggregate` MUST run regardless of whether
`mutants-plan`/`mutants` succeeded, failed, were cancelled, or were
skipped — exactly the same requirement `ci-gate` itself has for ALL of
ITS `needs:` members, which is why `ci-gate` carries `if: ${{ always()
}}` (S-CIGATE-1 AC-002, explicitly load-bearing per that job's own
in-YAML comment). Without `always()`, GitHub Actions' default `needs`
behavior SKIPS a dependent job when an upstream dependency fails —
and `mutants-aggregate` is the one job in this design that positively
MUST NOT be skipped under any upstream outcome, because its entire
job is to make the correct pass/fail decision even when — especially
when — something upstream went wrong (a missing shard, an escalated
diff, a crashed plan job). This is precisely INV-COMPLETE's and
INV-ESCALATE's job.

**Why not rely on `mutants-aggregate` keeping a bare custom `if:`
(`github.event_name == 'pull_request'`, no `always()`) instead — the
smaller, less invasive alternative?** This was seriously considered
(see below, "Option 1, rejected") and would have let `mutants-aggregate`
stay in the EXISTING `SKIP_TOLERANT_NEEDS_MEMBERS` category (a simple
`mutants` → `mutants-aggregate` rename across three existing pins,
**zero** new pin categories, **zero** new consts). It was rejected
because it requires assuming a specific, non-obvious GitHub Actions
semantic — that a job's own custom `if:` (one that does not reference
`success()`/`failure()`/`always()`/`cancelled()`) REPLACES rather than
supplements the implicit `success()`-of-needs check GitHub Actions
applies by default. **This session dispatched primary-source
verification of that exact semantic** (see the companion research task;
incorporate its finding into the F2 human-gate discussion — if it
returns CONFIRMED, Option 1 becomes a legitimate, smaller-diff
alternative worth reconsidering at the gate). Absent that confirmation,
the asymmetry is stark and decisive: if the assumption is TRUE,
Option 1 works exactly like the old `mutants` job did; if the
assumption is FALSE, `mutants-aggregate` would be silently SKIPPED
whenever `mutants-plan` genuinely fails, and — because it would still
be allowlisted for `skipped` under Option 1 — `check-ci-gate.sh` would
treat that skip as a PASS. **That is a real, reachable, S-CIGATE-1-class
false-green on the sole required mutation gate**, the exact defect
category this repository's entire CI-gate history (16+ documented
adversarial rounds) exists to eliminate. Per this repo's own documented
engineering culture, a required, fail-closed gate's correctness must
never depend on an unverified platform semantic when a
PROVEN-IN-THIS-EXACT-FILE alternative (`always()`, already exercised
and battle-tested for `ci-gate` itself) is available at a bounded,
knowable, purely-mechanical cost. **Recommendation: `always()`
(Option 2), specified throughout this delta.**

**The consequence.** `mutants-aggregate` is the FIRST job in this file's
history to be simultaneously (a) a `ci-gate.needs` member, (b) NOT
skip-tolerant (it must never report `skipped` — see below), and (c) in
possession of a job-level `if:` key. Every existing pin assumed these
three properties never co-occurred: `always_run_needs_members()`'s two
consumers — `test_ci_gate_needs_jobs_have_no_job_level_if` and
`test_always_run_jobs_have_no_continue_on_error` — the first of which
currently asserts, for EVERY job in that set, that it has **no job-level
`if:` key at all, full stop**. Applied blindly to `mutants-aggregate`,
that assertion would immediately and correctly fail the moment
`mutants-aggregate`'s `if: always()` lands — not a bug in the existing
test, a genuine, previously-impossible-to-need exception that must be
added deliberately, mirroring the EXACT design pattern
`PINNED_ALLOWED_SKIP_IF_EXPRESSIONS` already established for the
skip-tolerant category: **a small, pinned, human-reviewed literal list
of (job name, exact `if:` text) pairs that are the ONLY legitimate
exceptions to an otherwise-blanket rule**, checked by exact string
equality (`extract_and_normalize_if_expr`), never by pattern or
substring. `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS` is that list, with
its first (and today, only) member `("mutants-aggregate", "always()")`.

**Why `mutants-aggregate` is deliberately designed to NEVER report
`skipped`** (closing the loop on why it is NOT simply added to
`SKIP_TOLERANT_NEEDS_MEMBERS`/`ALLOWED_SKIPS` instead of getting this new
exception category): its own internal script resolves EVERY reachable
state — push event, escalated diff, missing shards, malformed JSON,
passing kill rate, failing kill rate — to an explicit `exit 0` or
`exit 1`, never leaving GitHub Actions to derive a `skipped` conclusion
on its behalf. This is a deliberate simplification with a real payoff:
`ALLOWED_SKIPS` returns to being **empty** in production (§6.1), meaning
the fail-closed `evaluate_needs()` decision function currently has ZERO
special-cased job names to reason about — the smallest possible trusted
surface for that function, even though the MECHANISM (and its own
positive-path test coverage, preserved via the local-override technique
in repurposed fixtures 4/5) remains intact for a future job that
legitimately needs it.

### 6.5 Round-1 adversarial fix — consolidated summary

A fresh-context F2 adversarial review found one CRITICAL, two HIGH, and two
MED findings against the design as drafted above. All are now folded into
the sections above; this subsection is the single place to see the whole
picture at once (mirrors this repo's convention, per CLAUDE.md's own
round-by-round CI-gate history, of narrating WHAT changed and WHY at each
adversarial pass rather than silently rewriting prior text).

**CRIT-1 (false-green) + HIGH-1 (false-red) — fixed together by ONE
mechanism.** Both trace to the same root cause: the pre-fix INV-COMPLETE
derived shard completeness from the COUNT of `outcomes.json` files that
happened to show up, an ambiguous proxy that cannot distinguish "nothing
ran" from "nothing to run." CRIT-1: all 8 shards crash inside `run-mutants`
(masked at the job level by `continue-on-error: true`), zero
`outcomes.json` files exist, and the pre-fix `#shard_json_files -eq 0 →
non-empty-diff → exit 0` branch fired — a GREEN gate verifying zero
mutants. HIGH-1: a small PR's legitimately-uneven `--sharding slice` split
leaves some shards with zero mutants and correspondingly no
`outcomes.json`, and the pre-fix design had no way to tell that apart from
a crash, so it failed closed on routine, healthy PRs. **Fix:** every shard
now ALWAYS uploads a status sentinel (`mutants-shard-status-<k>`,
independent of mutant count or `run-mutants` outcome) capturing
`steps.run-mutants.outcome` (which survives `continue-on-error` truthfully,
unlike `.conclusion`) and whether `outcomes.json` exists. `mutants-
aggregate`'s redesigned INV-COMPLETE (i) requires all `N` sentinels present
by index — the true fail-closed completeness gate, now immune to CRIT-1
since a genuine harness crash still uploads a sentinel truthfully reporting
`run_outcome=failure` — then (ii) interprets each present sentinel:
`has_outcomes==true` always wins (parse and fold the data); otherwise
`run_outcome==success` means a legitimate zero-contribution shard (resolves
HIGH-1) and anything else means a harness crash (resolves CRIT-1, fails
closed and names the shard). Full mechanism:
`mutants-sharding-invariants.md §INV-COMPLETE`; pseudo-YAML/script:
`ci-yml-design.md §§2-3`.

**New: pooled-total ⇔ `MUTANT_COUNT` reconciliation (INV-AGG sub-invariant
8).** Previously `mutants-plan`'s pre-count output (`mutant_count`) was
computed and threaded through but never consumed downstream. It is now the
PRIMARY discriminator for "legitimately nothing to gate on" — retiring the
old `OVERALL_DIFF_LINES`-only discriminator, which is now consulted only to
explain why the (already-reconciled) mutant count is zero, never as the
completeness signal itself. Any mismatch between the pooled sum of scored
mutants and `MUTANT_COUNT` FAILS CLOSED (unlike the per-shard, warning-only
M-2 `total_mutants` check, which tolerates schema drift — this is a
completeness check, not a schema check). Detail:
`mutants-sharding-invariants.md §INV-AGG` sub-invariant 8.

**MED-1 — `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS` had no cross-check
guard.** Fixed by `test_always_run_with_if_exceptions_disjoint_and_
tautological` (§6.2 table). Prevents a future entry in this list from both
bypassing the "no job-level `if:`" rule and failing to actually always-run.

**MED-2 — the `mutants-plan` → `mutants-aggregate` escalation wiring had no
structural pin.** Fixed by `test_mutants_plan_escalated_output_wired_to_
aggregate_env` (§6.2 table). A mistyped output/env key degrades gracefully
to an empty string (GitHub Actions does not error on a nonexistent
`needs.<job>.outputs.<name>` reference), which would silently disable
INV-ESCALATE forever rather than failing loudly.

**Two LOW findings, addressed as documentation/discipline notes (no
mechanism change):** (1) `mutants-aggregate`'s job-level `if:` must be
written bare — `if: always()` — not braced like `ci-gate`'s own
`if: ${{ always() }}`; the two pins are independent and not
byte-compatible (`mutants-sharding-invariants.md §INV-ESCALATE Residual
Risk 3`). (2) The `ESCALATION_THRESHOLD=120` derivation has exactly one
source of truth (`mutants-sharding-invariants.md §Threshold derivation`);
`ci-yml-design.md` cross-references rather than re-derives it, and both
must update together if the value changes (same document, Residual Risk
4).

**Numbers after this round:** `EXPECTED_GUARD_TEST_COUNT`: `38 → 48`
(+10 net new tests across both rounds — see the full list above).
`EXPECTED_FIXTURES` (`scripts/check-ci-gate.sh --self-test`):
**`13 → 14` (new Fixture 14, §6.1)** — **corrected round-9, LOW-2:**
this paragraph previously read "unchanged at `14`," which was wrong —
this IS the round that introduces Fixture 14 (§6.1's "NEW Fixture 14"
table row, `empty-allowed-skips-any-skip-fails-closed`), moving the real
repo baseline of `EXPECTED_FIXTURES=13` to `14` for the first time. Every
LATER round's "unchanged at `14`" wording (rounds 2 through 8) is correct
as written — none of them add a further fixture, they only revise
Fixture 14's own body/assertions or add SIBLING counters
(`EXPECTED_PRINT_ALLOWED_SKIPS_CHECKS`, `EXPECTED_MUTANTS_AGG_FIXTURES`)
that are not `EXPECTED_FIXTURES` itself; only this round-1 paragraph was
mislabeled. The mechanism (Fixture 4/5 repurposing, Fixture 12 rekeying,
Fixture 13 simplification, new Fixture 14 itself) otherwise lives entirely
inside `mutants-aggregate`'s own script (in `ci.yml`) and its structural
pins (in `tests/ci_gate_completeness.rs`), as originally stated.

### 6.6 Round-2 adversarial fix — consolidated summary

A second, fresh-context F2 adversarial review confirmed the round-1
aggregator DECISION LOGIC itself is sound (no CRITICAL false-green
surfaced) but found the round-1 guardrail-lockstep enumeration (§6.2)
incomplete, one over-claimed invariant (INV-AGG sub-invariant 8), and one
unguarded output shape (`print_allowed_skips`). Same convention as §6.5:
this subsection is the single place to see the whole round-2 picture at
once.

**HIGH-1 — §6.2's "exhaustive" enumeration was provably incomplete.** Four
forced test/pin edits, all consequences of round-1's own already-specified
`mutants` → `mutants-aggregate` retarget and `ALLOWED_SKIPS`/
`SKIP_TOLERANT_NEEDS_MEMBERS`/`PINNED_ALLOWED_SKIP_IF_EXPRESSIONS` emptying,
were never listed:
- **(a)** `test_ci_gate_decision_matches_job_level_if_for_every_needs_member`'s
  hard `saw_positive_branch` assert would become permanently unreachable
  the moment `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS` is emptied — turning CI
  red on a correct, intentional design, not a defect.
- **(b)** `test_allowed_skips_members_require_job_level_conditional_in_ci_yml`'s
  hard `!allowed_skips.is_empty()` assert would fail the same way the
  moment `ALLOWED_SKIPS=()` lands in `scripts/check-ci-gate.sh`.
- **(c)** `PINNED_GATE_NEEDS_LINE`'s byte-literal (M2-p) still ends
  `…mutants]` and was never listed as a changed constant, despite M2-p's
  own failure text already instructing both this literal and
  `test_ci_gate_needs_exactly_the_required_jobs` to be updated together.
- **(d)** `all_skip_variants_for`'s hardcoded `vec![job, "mutants"]`
  companion no longer names a real, skip-tolerant job once `mutants` is
  retired from `ci-gate.needs`.

**Both (a) and (b) are TRANSFORMED, not deleted or weakened** — this is
the load-bearing distinction the round-2 task brief insisted on, and it is
why item 11 (`test_skip_tolerant_surface_is_consistently_empty_by_design`)
exists as a NEW, dedicated test rather than these two existing tests
simply losing an assertion. The invariant these two tests enforce
genuinely SHIFTS with cycle-006: pre-cycle-006, "≥1 legitimate skip path
exists" was itself a meaningful thing to prove (it demonstrated the
`ALLOWED_SKIPS` mechanism's positive branch was reachable, not vacuously
dead code). Post-cycle-006, the mechanism's positive branch is
DELIBERATELY dead — `mutants-aggregate` never reports `skipped` by design
(§6.4) — so the meaningful thing to prove inverts: not "a skip path
exists" but "the skip-tolerant surface is EMPTY, and consistently so
across all three lists that are each independently capable of
representing it" (`ALLOWED_SKIPS` in bash, `SKIP_TOLERANT_NEEDS_MEMBERS`
and `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS` in Rust). A silent partial-empty
(e.g. `ALLOWED_SKIPS` emptied in bash but `SKIP_TOLERANT_NEEDS_MEMBERS`
left stale in Rust) is exactly the kind of guardrail desync this file's
entire history exists to catch — see §6.2 items 6/7/11 for the full
transformed-assertion text and the new dedicated test.

**MEDIUM-1 — `print_allowed_skips`'s empty-array output shape was
unguarded and unpinned.** Fixed via an explicit `[ "${#ALLOWED_SKIPS[@]}"
-eq 0 ] && return 0` short-circuit plus a new, SIBLING self-test suite
(`run_print_allowed_skips_self_test`, `EXPECTED_PRINT_ALLOWED_SKIPS_CHECKS
= 1`) — deliberately NOT folded into `EXPECTED_FIXTURES`/`check_fixture`,
which test a different function (`evaluate_needs()`'s JSON-payload
decision) entirely. See §6.1 for the full write-up, including why a
second "populated array" regression check was considered and declined
(the mutation it would guard against is already caught transitively by an
existing guard the day `ALLOWED_SKIPS` next becomes non-empty).

**MEDIUM-2 — the reconciliation claim (INV-AGG sub-invariant 8) was
over-stated, and `mutants-plan`'s `--list` step swallowed its own exit
status.** Both are fixed in the companion documents, not here (this
document only summarizes):
- `mutants-sharding-invariants.md §INV-AGG sub-invariant 8` gains an
  explicit, HONEST residual-false-green statement: pooled-total ⇔
  `MUTANT_COUNT` reconciliation catches per-shard PLAN↔EXECUTION
  divergence only — it structurally CANNOT catch a common-mode error in
  the single shared `mutants-diff-file` artifact, since both numbers are
  derived from the same bytes. The documented backstop is the nightly
  full-scope (non-`--in-diff`) run, which does not depend on `DIFF_FILE`
  at all.
- `ci-yml-design.md §1` (`mutants-plan`'s "Compute diff and mutation
  plan" step) is hardened: `cargo mutants --list --in-diff` no longer
  runs through a `2>/dev/null | wc -l` pipeline whose exit status is
  silently discarded under this step's deliberate `set -uo pipefail`
  (no `-e`). The step now captures `--list`'s own exit status explicitly
  and fails the `mutants-plan` job closed (`exit 1`) on a `--list`
  failure, rather than silently coercing a tooling failure into
  `MUTANT_COUNT=0`. This closes the TOOLING-ERROR half of the residual;
  the base-ref-genuine-corruption half is irreducible by construction
  (see the sub-invariant 8 write-up) and remains covered only by the
  nightly backstop — explicitly flagged there for F5/F6 re-examination,
  not implied closed.

**LOWs.**
- **`MUTANT_COUNT`/`OVERALL_DIFF_LINES` env-consumer fail-closed status,
  corrected (not just restated).** `MUTANT_COUNT` IS properly fail-closed:
  `ci-yml-design.md §3` Step 4 regex-validates it (`^[0-9]+$`) and exits 1
  on a bad value before reconciliation runs. `OVERALL_DIFF_LINES`,
  however, was found to be ONLY partially guarded — its `${OVERALL_DIFF_
  LINES:-0}` fallback (Step 5) handles the UNSET/empty case correctly
  (defaults cleanly to `0`) but does NOT handle a malformed-but-SET value
  (bash's `:-` substitution only fires on unset-or-empty): a non-numeric
  `OVERALL_DIFF_LINES` would make `[ "${OVERALL_DIFF_LINES:-0}" -eq 0 ]`
  itself error (bash "integer expression expected", exit status 2), which
  `if` treats as FALSE — silently routing to the "OK: non-empty diff"
  branch instead of the intended base-ref-drift FAIL branch. This is a
  narrower, more precise finding than the round-2 task brief's own framing
  (which assumed both variables were already symmetric) — `ci-yml-
  design.md §3` Step 4/5 is updated to add the same `^[0-9]+$` regex
  guard to `OVERALL_DIFF_LINES`, closing the asymmetry rather than merely
  documenting it. In practice this value can only become malformed via a
  GitHub Actions output-plumbing bug (a mistyped `env:` key, mirroring the
  exact MED-2-round-1 class `test_mutants_plan_escalated_output_wired_to_
  aggregate_env` already guards for `escalated` specifically) — this LOW
  closes the analogous gap for `overall_diff_lines`'s wiring at the
  CONSUMPTION side, complementing rather than duplicating that pin.
- **VP-010 framing flagged for the formal-verifier, `verification-delta.md`
  NOT edited here** (per the round-2 task brief's explicit instruction —
  invariant names kept stable for the formal-verifier's own pass): VP-010's
  "fail-OPEN, maximally dangerous" characterization is overstated in one
  direction — a MISTYPED `escalated` key that disables escalation entirely
  makes a >120-mutant PR silently RUN the full shard gate at `--timeout
  240`/shard instead of short-circuiting to the escalation message (fail-
  CLOSED / wasted CI minutes / the exact multi-hour-wall-clock risk this
  cycle exists to avoid recurring), not "merge unverified." The genuinely
  dangerous direction is the OPPOSITE value error — `ESCALATED` resolving
  to the literal string `true` when it should not (a presence-of-wrong-
  value bug, not an absence-of-wiring bug) — which is a different failure
  mode from what VP-010 as currently framed describes. Flagged here for
  the formal-verifier to reconcile in `verification-delta.md` directly;
  this document does not resolve it.

**Numbers after round-2:** `EXPECTED_GUARD_TEST_COUNT`: `48 → 49` (+1 net
new test — item 11, §6.2 — on top of round-1's 48; **49 total across all
three passes** from the original `38`). `EXPECTED_FIXTURES`: **unchanged
at `14`** — round-2's `print_allowed_skips` fix uses a NEW, SIBLING
counter (`EXPECTED_PRINT_ALLOWED_SKIPS_CHECKS = 1`, §6.1), not a change to
`EXPECTED_FIXTURES` itself. No `mutants-sharding-invariants.md` or
`ci-yml-design.md` change in this round adds a NEW structural Rust-side
pin (the `--list` hardening and the `OVERALL_DIFF_LINES` guard are both
CI-script-only behavior changes, consistent with the existing precedent
that `--timeout 240`/`ESCALATION_THRESHOLD=120`-class literals are
code-review-time obligations, not byte-pinned — see §6.2's "Considered and
explicitly declined additions").

### 6.7 Round-3 adversarial fix — consolidated summary

A third, fresh-context F2 adversarial review again confirmed the
aggregator's core DECISION LOGIC is sound (no CRITICAL false-green
surfaced, for the third round running) but found every remaining finding
sitting in the WIRING/GUARDRAIL perimeter around that logic — the same
pattern round-2 described for itself, one layer further out. Same
convention as §6.5/§6.6: this subsection is the single place to see the
whole round-3 picture at once.

**HIGH-1 — `EVENT_NAME`'s Step 0 was FAIL-OPEN, the one genuinely new
false-green class this round found.** `mutants-aggregate`'s push-event
no-op compared `EVENT_NAME` against the literal `pull_request` with `!=`
and exited 0 on any mismatch — including the mismatch produced by a
mistyped `${{ }}` expression resolving to an empty string (GitHub Actions
returns "" for a bad expression rather than erroring the workflow). Fixed
by inverting the check to an explicit allowlist of KNOWN non-PR events
(`push`/`schedule`/`workflow_dispatch`) with a hard-FAIL default arm for
anything else, including empty — §6.2a. Closed with defense-in-depth on
both layers: the runtime `case` statement (script) and a new structural
`env:`-wiring pin, `test_mutants_aggregate_event_name_env_wired` (item
12, §6.2), mirroring exactly how MED-2/round-1 already double-covers
`ESCALATED` (a structural pin on the wiring, a runtime guard on the
value).

**MEDIUM-1 — `is_allowed_skip`'s empty-array expansion was the ONE sibling
site round-2's own `print_allowed_skips` fix never reached, and it is not
merely inconsistent — it is a genuine macOS bash 3.2.57 crash risk THIS
CYCLE specifically introduces** (by emptying `ALLOWED_SKIPS` in production
for the first time, at the exact moment the `#[cfg(unix)]` subprocess
tests exercise this script on both `ubuntu-latest` bash ≥5.x AND
`macos-latest` bash 3.2.57). Fixed via the SAME `${#ALLOWED_SKIPS[@]} -eq
0` short-circuit shape as `print_allowed_skips`, but returning 1 (not 0
— the two functions' empty-array semantics are opposite, and getting this
backwards would have been a severe fail-open regression, not a fix).
Fixture 14 (already specified by round-1/round-2 to exercise exactly this
path) gains a message-substring assertion so a bash-version crash cannot
coincidentally report the same return code as the intended FAIL decision
and pass unnoticed — and its own safety claim is corrected from "ubuntu
bash ≥5.x" (the runner it was actually verified against) to "both CI bash
versions this repo runs this script under" (§6.1).

**MEDIUM-2 — the twice-revised §6.2 enumeration was STILL incomplete, and
the largest single gap was structural rather than a missed line-item: the
whole `mutants-aggregate` script had never actually been extracted out of
`ci.yml`'s YAML text, which every already-planned INV-AGG/INV-COMPLETE
behavioral guard-test (items 1/2/3/6/7/8) implicitly depends on in order
to test SHIPPED logic rather than a Rust-side re-implementation of it.**
Closed via §6.2a (new `scripts/mutants-aggregate.sh`, its own
`--self-test` fixture harness, `spec-guard` wiring, and the resulting
`env:`-templating finding this extraction surfaced for free — `STATUS_
DIR`/`SHARD_DIR` needed promoting from inline `${{ runner.temp }}`
substitution to real `env:`-supplied variables, since `${{ }}` is never
substituted inside a file a `run:` step merely invokes). Flagged as a
second, independent BLOCKING F2-gate precondition (§1), alongside the
smaller, previously-unlisted forced edits the same pass found: (a)
`test_allowed_skips_has_exactly_three_code_level_references`'s pinned
count needed a resolution for HOW fixtures 4/5's local-override technique
is implemented, not just a description of what it does — resolved via one
shared wrapper function, `3 -> 4` (not `3 -> 5`), with the test itself
renamed to match (§6.1, §6.2 item 8); (b) AC-006's step-level-`if:`
cardinality assertion, embedded inside the already-large item-3 test
rewrite, needed its own explicit 1→3 inversion named (three sentinel/
upload steps under the sharded design now carry `if: always()`, not one)
— easy to miss precisely because it was one assertion buried inside an
already-extensively-rewritten test, not because the surrounding rewrite
was wrong; (c) two module-map doc-comment citations (`:44`, `:111`) had
gone stale from round-1's own already-specified renames and were never
propagated to this file's own top-of-file coverage map (§6.2 item 8).

**Observations, addressed as design notes (no mechanism change beyond
what's already covered above):** the `saw_positive_branch` transform
(item 6, §6.2) remains correct and is explicitly non-load-bearing on its
own in the empty-`ALLOWED_SKIPS` steady state — a desync there is caught
transitively by item 11's dedicated three-way consistency check, not by
item 6 in isolation; this was already true after round-2 and round-3
confirmed it rather than changing it. **Reframe, recorded per the round-3
task brief's own instruction:** the §6.1/§6.2/§6.2a enumeration in this
document is BEST-EFFORT GUIDANCE, not a substitute for running the actual
guard suite — the AUTHORITATIVE completeness backstop is that F4 MUST run
the full `cargo test` guard-test suite, `scripts/check-ci-gate.sh
--self-test`, AND the new `scripts/mutants-aggregate.sh --self-test`
locally and in CI before merge; any pin this document's enumeration missed
(and three consecutive rounds have each found something the prior two
missed) fails one of those suites loudly. This document is the map, the
suites are the territory, and the map has already been wrong three times
running — treat the next implementer's own suite run, not this document's
count, as ground truth.

**§6.7 upgrade (round-4) — what the "F4 runs the suite" backstop actually
covers, and what it structurally cannot.** The reframe above is true and
remains load-bearing, but stated alone it invites a specific
misreading this round's own history makes worth heading off explicitly:
"F4 running the guard suite before merge" is a backstop against this
DOCUMENT's enumeration missing something about a pin that ALREADY EXISTS
in spec form somewhere in §6.1/§6.2/§6.2a — a wrong count, a stale
literal, a forgotten cross-reference — because a missed UPDATE to an
EXISTING assertion shows up as that assertion going red (or, for a
newly-introduced structural gap in the SCRIPT itself, as a fixture in
`scripts/mutants-aggregate.sh --self-test` failing). **It is NOT a
backstop against this document never having specified a pin at all for a
genuinely new attack surface.** A test suite can only fail an assertion
that exists; it cannot notice the ABSENCE of an assertion category nobody
wrote down as needed. Round-4's own headline finding — that
`mutants-aggregate` had inherited none of `ci-gate`'s anti-neutering
guardrail CLASS (a run-line byte-pin, an env-key-set pin, a node-property
scan, a per-step if-value pin) — is precisely an instance of this: three
prior F2 rounds ran mentally against the SAME "F4 will run the suite"
backstop and none of them would have caught it, because the gap was never
a wrong assertion, it was a MISSING one, on a job (`mutants-aggregate`)
whose very existence as a new, first-class decision surface this document
itself introduced. **This is exactly why §6.8's structural-peer approach
exists as a SEPARATE mechanism, not a restatement of this backstop:**
instead of enumerating individual pins bottom-up and hoping the
enumeration is complete (the method that has now needed a fourth round to
converge even for `ci-gate`'s existing, 20-round-mature protection set),
§6.8 works top-down from an already-converged reference (`ci-gate`'s own
protection set, closed after 20+ rounds) and asks, protection by
protection, "does the new job get this too, and if not, why not" — a
completeness method that does not depend on a reviewer independently
re-deriving the same list a fourth or fifth time from first principles.
The map is still not proven complete by this — §6.8 is itself now a NEW
map, subject to the same "F4 runs the suite" caveat for whatever IT
misses — but it converts an open-ended "what pins are missing" question
into a bounded, checklist-shaped one, which is the correction this round
actually makes to the process, not merely to the pin count.

**Numbers after round-3:** `EXPECTED_GUARD_TEST_COUNT`: `49 → 51` (+2 net
new tests — items 12/13, §6.2 — on top of round-2's 49; **51 total across
all four passes** from the original `38`). `EXPECTED_FIXTURES`
(`scripts/check-ci-gate.sh --self-test`): **unchanged in COUNT at `14`**,
but Fixture 14's own body gains a 4th `check_fixture` argument (§6.1) and
`test_allowed_skips_has_exactly_three_code_level_references`'s SEPARATE
pinned count moves `3 -> 4` under its new name (§6.1, §6.2 item 8) — two
different counters, neither of which is `EXPECTED_FIXTURES` itself. A
NEW, SIBLING bash self-test counter, `EXPECTED_MUTANTS_AGG_FIXTURES`
(provisional floor `8`, F4 finalizes), is introduced in the new
`scripts/mutants-aggregate.sh` (§6.2a) — the fourth counter of this shape
in the repository, after `EXPECTED_FIXTURES`, `EXPECTED_JQ_TRUST_CHECKS`,
and `EXPECTED_PRINT_ALLOWED_SKIPS_CHECKS`, all in `check-ci-gate.sh`.

### 6.8 `mutants-aggregate` as a documented structural peer of `ci-gate`

**Why this section exists.** A fourth fresh-context F2 adversary confirmed
(again) that the aggregator's own decision LOGIC is sound, but observed
that `mutants-aggregate` occupies a role no job in this file has occupied
before: it is the SOLE arbiter of the mutation-gate pass/fail decision,
feeding that decision into `ci-gate` as one opaque `success`/`failure`
result (§7 dependency graph). `ci-gate`'s OWN decision step earned its
20+-round, byte-pinned, key-set-pinned, node-property-scanned protection
surface precisely because it occupies that same role for the WHOLE gate
one level up. `mutants-aggregate` had, through round-3, inherited only
the protections that fall out of GENERIC mechanisms already iterating
every `ci-gate.needs` member (the job/step complete-key-set pins, the
blanket `continue-on-error` ban, the `PINNED_ALWAYS_RUN_WITH_IF_
EXCEPTIONS` carve-out) — it had NONE of the protections `ci-gate` carries
that are specific to being a single, uniquely-load-bearing decision step:
a byte-pinned run line, a byte-pinned/key-set-pinned `env:` block, an
explicit invocation assertion, and a YAML-node-property scan. This
section makes that comparison systematic rather than leaving it to be
rediscovered by a fifth adversary: for EVERY protection `ci-gate`'s own
decision step carries (per `tests/ci_gate_completeness.rs`'s
`test_ci_gate_pass_fail_semantics_are_structurally_placed`, assertions
M2-a through M2-q, plus the standalone AC-001 invocation test), this
table states the exact `mutants-aggregate` analog — or states, by name,
why that specific protection is inherited transitively via an existing
generic mechanism, or is deliberately not replicated, with the reasoning
made explicit rather than left implicit.

**Scope correction (round-7) — this section covers RUST STRUCTURAL pins
only; SCRIPT-LEVEL RUNTIME hardening is a separate, sibling enumeration.**
A fresh-context round-7 F2 adversary observed that the table below
mirrors every protection `test_ci_gate_pass_fail_semantics_are_
structurally_placed` asserts ABOUT `ci-gate`'s YAML block (M2-a..M2-q,
AC-001) — but says nothing about the RUNTIME hardening `check-ci-gate.sh`
itself carries once execution actually reaches its `run:` line
(`resolve_trusted_jq`'s PATH-shim resistance, `set -euo pipefail`, the
builtin-stdin-read defense, etc.) — a layer this table's own title
("structural peer of `ci-gate`") implicitly promised but never delivered.
That gap is closed by NEW §6.11 ("Runtime hardening parity with
check-ci-gate.sh"), immediately following §6.10, using the SAME
disposition-table methodology this section established: for every runtime
defense on `check-ci-gate.sh`'s decision path, §6.11 states the exact
`mutants-aggregate.sh` analog or names, explicitly, why it does not apply.
Read this section's "complete enumeration" claim as scoped to the RUST
STRUCTURAL layer (what a PR reviewer sees in `ci.yml`'s parsed YAML tree)
— §6.11 is what makes the enumeration complete across BOTH layers
(structural YAML pins here, script-runtime hardening there).

**Table: `ci-gate` protection → `mutants-aggregate` disposition.**

| `ci-gate` protection (source) | What it guards | `mutants-aggregate` disposition |
|---|---|---|
| M2-a — job-level `if:` key exists | The gate has SOME job-level condition, not none | **Inherited, generic.** `test_always_run_with_if_exceptions_disjoint_and_tautological` (item 9, round-1) exact-matches `mutants-aggregate`'s `if:` value against `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS`'s pinned `"always()"` — a STRONGER check than mere presence, since it also fixes the value. |
| M2-b/M2-c — job-level `if:` contains `always()`, does not contain `contains(needs` | The condition is a real tautology, not a needs-based conditional smuggled in under the `always()` category | **Inherited, generic, stronger.** Same test as M2-a's row: exact-string-equality to the literal `"always()"` subsumes both a substring-contains check for `always()` (trivially true for the exact string) and a substring-absence check for `contains(needs` (trivially true — the exact string contains no such substring). No separate assertion needed. |
| M2-d — NO step-level `if:` key anywhere in the job | `ci-gate` has no legitimate step-level condition at all | **Deliberately NOT replicated — inverted by design.** `mutants-aggregate` LEGITIMATELY carries three step-level `if: always()` occurrences (the two `download-artifact` steps and the eval step itself — `ci-yml-design.md §3`), for the identical reason the `mutants` shard job's own three step-level `if: always()` occurrences are legitimate (round-3, item 3's AC-006 rewrite): a download step must run even when an upstream artifact is genuinely absent, so its own OUTCOME can be correctly interpreted rather than silently skipped. The correct protection for THIS shape is not "ban step-level `if:`" but "pin each step-level `if:`'s VALUE" — item 18 (`test_mutants_aggregate_step_level_if_values_are_all_always`, §6.2), the genuinely new gap this round found (no round-1/2/3 analog existed). |
| M2-g/M2-h — a `run:` step exists, its text mentions the gate script | Presence + coarse substring sanity, the layer BEFORE a byte-pin existed historically for `ci-gate` | **Covered by item 16's AC-001 analog, not independently replicated.** `ci-gate` carries M2-g/h as leftover incremental-hardening history (they predate M2-i's byte-pin, PR #671 round 10) — for a job designed fresh with the byte-pin from day one, a THIRD redundant presence/substring layer beyond items 14 (byte-pin) and 16 (AC-001 analog) would be pure duplication with no incremental coverage. Declined per this document's own "Considered and explicitly declined additions" precedent. |
| M2-i — byte-pinned `run:` line VALUE | The gate script is invoked exactly, no `\|\| true`/`\| cat`/`; exit 0` suffix can silently neuter it | **NEW, item 14** — `PINNED_MUTANTS_AGGREGATE_RUN_LINE`, via the EXISTING generic `extract_and_normalize_sole_run_line` (zero new `wf.rs` code — see the constants-table row above). |
| M2-j — no `continue-on-error` anywhere in the job | A failing step cannot report `success` and silently satisfy `ci-gate.needs` | **Inherited, generic, backstopped.** `test_always_run_jobs_have_no_continue_on_error` (`:3339`) already iterates `always_run_needs_members(&ci)`, which — once `SKIP_TOLERANT_NEEDS_MEMBERS` is emptied (§6.2 table row 1) — includes `mutants-aggregate` automatically; no code change to that test is needed, only its stale "seven jobs" doc/panic text (§6.9 F3 below). This test's own check is a raw `job_block.contains("continue-on-error")` — NOT tree-based, so it shares the SAME node-property-bypass class M2-q closes for `ci-gate` specifically (a `&x continue-on-error: true` key would defeat the substring scan). It is backstopped, not merely assumed safe: `PINNED_ALWAYS_RUN_JOB_KEY_SETS`/`_STEP_KEY_SETS`'s `mutants-aggregate` entries (§6.2, round-1) are TREE-based complete-key-set pins — the real parser resolves `&x continue-on-error: true` to a genuine `continue-on-error` key regardless of the anchor, so the key-set pin still sees it as an unexpected extra key and still fails. This is the EXACT relationship the `find_key_node_properties` doc comment (`tests/ci_gate_completeness.rs :~5566`) already documents for every non-`ci-gate` job today — `mutants-aggregate` inherits that same backstop by construction, no new code required. |
| M2-k/M2-l — COMPLETE job-level and step-level key-SET pins (default-deny) | No key can be added, removed, or renamed on the job or any step without a reviewed pin update | **Inherited, generic, CONFIRMED complete (not presence-only).** `PINNED_ALWAYS_RUN_JOB_KEY_SETS`/`PINNED_ALWAYS_RUN_STEP_KEY_SETS` (§6.2 constants table, round-1) gained a `mutants-aggregate` entry each from the start of this delta's design — both are consumed by the EXISTING, already-default-deny `test_always_run_jobs_have_pinned_complete_job_key_sets`/`_step_key_sets` (the same functions that pin `msrv`/`fmt`/`deny`/etc.'s key sets), which assert SET EQUALITY against the pinned array, not mere presence of a subset. Verified by reading both test bodies (`:1374`, `:1598`) directly, not assumed from the constant's name. |
| M2-m — byte-pinned job-level `if:` VALUE | `ci-gate`'s own `if:` is the exact literal `${{ always() }}`, not a decoy tautology like `always() && github.ref == 'refs/heads/nonexistent'` | **Inherited, item 9 (round-1), already covers this precisely** — `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS`'s exact-match requirement IS the M2-m analog; see the M2-a/b/c row above for why one test covers all three ci-gate-side concerns here. |
| M2-n — byte-pinned SINGLE critical input line (`NEEDS_JSON:`) | `ci-gate`'s ENTIRE input is one line; a hand-written decoy JSON literal would be invisible to a key-set pin alone | **CLOSED round-9 (LOW-1) — this row's remaining "3 of 7 keys declined" tail is now retired, not merely re-verified.** `mutants-aggregate` has SEVEN inputs, not one, so there is no single "the input" to canonically byte-pin the way `NEEDS_JSON:` is for `ci-gate` — that structural-shape observation still stands. Round-8 (F-H1) closed `STATUS_DIR`/`SHARD_DIR` (items 23/24), joining `ESCALATED`/`EVENT_NAME` (items 10/12) as four of seven with an individual byte-VALUE pin, but left `MUTANT_COUNT`/`OVERALL_DIFF_LINES`/`PLAN_RESULT` declined on a re-verified-but-still-declined basis. A fresh-context pass-13 adversary found that declination CIRCULAR for `MUTANT_COUNT` under F-H1's own threat model: Step 4 reconciliation is keyed on `total_scored != MUTANT_COUNT`, so a PR that hardcodes `MUTANT_COUNT:`'s env value to whatever the pooled shards will produce makes reconciliation pass trivially, disabling INV-AGG sub-invariant 8 without touching any previously-pinned surface — the runtime backstop cited as justification for skipping a pin itself consumes the unpinned value. **Fixed round-9:** `MUTANT_COUNT`/`OVERALL_DIFF_LINES`/`PLAN_RESULT` now ALSO carry byte-VALUE pins (items 25-27, `PINNED_MUTANTS_AGGREGATE_MUTANT_COUNT_LINE`/`_OVERALL_DIFF_LINES_LINE`/`_PLAN_RESULT_LINE`), via the SAME zero-marginal-cost technique. ALL SEVEN of seven `mutants-aggregate` eval-step env values now carry an individual byte-VALUE pin on top of the item-15 key-set pin — the "declined env-value pin" category for this job is retired entirely; see the declined-additions entry above and the Declination re-audit table below for the closed-out per-variable history. |

**Declination re-audit (round-8) — every §6.8/§6.11 declined/N-A/
accepted-residual row, re-verified against the SAME failure mode F-H1
exposed (a weaker guarantee described as stronger, or a claim that
silently over-reaches its actual scope).** Required by this round's task
brief as a "loop-breaker": since F-H1 itself was a declined row resting on
faulty reasoning, every other declined/N-A/accepted row in both tables is
re-checked here rather than assumed sound by association. Only F-H1 (the
M2-n row above) was found faulty; every other row below re-verifies
sound, two with a materially strengthened rationale.

| Row | Section | Pre-round-8 disposition | Round-8 re-check | Verdict |
|---|---|---|---|---|
| M2-d (no step-level `if:` ban) | §6.8 | Deliberately inverted — `mutants-aggregate` legitimately carries 3 step-level `if: always()`, value-pinned instead (item 18) | Genuine design-shape difference from `ci-gate` (which bans step-level `if:` outright); not a "weaker guard called stronger" claim — it is a documented, correctly-reasoned INVERSION, and the substitute protection (item 18's per-step value pin) is itself a byte-VALUE pin, not a weaker mechanism | SOUND, unchanged |
| M2-g/M2-h (presence/substring layer) | §6.8 | Declined as redundant given items 14 (byte-pin) + 16 (AC-001 analog) | A third presence/substring layer would prove strictly less than the byte-pin already proves (byte-equality implies presence); no conflation of a narrower guard as broader | SOUND, unchanged |
| M2-j (`continue-on-error` ban) | §6.8 | "Inherited, generic, backstopped" via `PINNED_ALWAYS_RUN_*_KEY_SETS` | Re-verified against `find_key_node_properties`'s documented behavior (`tests/ci_gate_completeness.rs :~5566`): the real parser resolves `&x continue-on-error: true` to a genuine key regardless of the anchor, so the TREE-based key-set pin genuinely sees it as an unexpected extra key — this is a factual claim about parser behavior, not a `:?`-style scope overclaim | SOUND, unchanged |
| M2-n (`STATUS_DIR`/`SHARD_DIR` sub-claim) | §6.8 | "`:?` — stronger than any static pin could assert" | **FAULTY — this round's F-H1 finding** | **FIXED — see corrected row above, items 23/24** |
| M2-n (`MUTANT_COUNT` sub-claim) | §6.8 / §6.2a | Reconciliation against pooled shard data, "stronger than a string-match" | **Round-8 verdict ("SOUND, STRENGTHENED") ITSELF FOUND FAULTY at round-9 (pass-13, LOW-1) — this is the exact loop-breaker failure mode the round-8 re-audit existed to catch, applied one level up.** Reconciliation being TRUE and STRENGTHENED does not make a dedicated wiring pin unnecessary — round-8 conflated "the runtime backstop is sound" with "therefore no structural pin is needed," missing that the backstop CONSUMES `MUTANT_COUNT` rather than independently verifying its wiring: a PR hardcoding `MUTANT_COUNT:` to match the pooled total defeats reconciliation by construction, no redirect required | **CLOSED round-9 — `MUTANT_COUNT` now carries a byte-VALUE pin (item 25); reconciliation retained as complementary defense-in-depth, no longer asked to carry the declination alone** |
| M2-n (`PLAN_RESULT` sub-claim) | §6.8 / §6.2a | "Consumed via a comparison whose EMPTY-value behavior is inherently fail-closed" | Traced a NEW interlock this round: a hardcoded `PLAN_RESULT: "success"` literal cannot manufacture a false PASS alone, because GHA's default `needs:` semantics skip the `mutants` shard-matrix job entirely on a real `mutants-plan` failure (no `always()` on that job) — Step 2's sentinel-presence check independently fails closed against the resulting genuinely-absent artifacts, and (post-F-H1) the attacker can no longer paper over that absence via a redirected `STATUS_DIR`/`SHARD_DIR` either. This particular claim was not itself circular the way `MUTANT_COUNT`'s was — the interlock is a genuinely independent mechanism, not a backstop that consumes the unpinned value — but round-9 closes it structurally anyway for consistency, now that the technique is zero-marginal-cost | **CLOSED round-9 — `PLAN_RESULT` now ALSO carries a byte-VALUE pin (item 27); the traced interlock is retained as independent, complementary defense-in-depth** |
| M2-n (`OVERALL_DIFF_LINES` sub-claim) | §6.8 / §6.2a | Same "EMPTY-value fail-closed" framing as `PLAN_RESULT` | Confirmed the claim was always correctly SCOPED to malformed/empty input (never claimed redirect-immunity, unlike the pre-fix `STATUS_DIR`/`SHARD_DIR` text) — not a repeat of F-H1, and not circular the way `MUTANT_COUNT`'s was. A genuine but LOW-severity residual was named for the first time at round-8: a hardcoded nonzero value can only flip an already-reconciled-to-zero PR's base-ref-drift FAIL into a legitimate-zero-mutants OK (Step 5); it cannot reach Step 6's kill-rate computation or forge a PASS with real surviving mutants | **CLOSED round-9 — `OVERALL_DIFF_LINES` now ALSO carries a byte-VALUE pin (item 26), retiring the accepted-residual framing rather than continuing to carry it** |
| M2-q scope (`ci-gate` + `mutants-aggregate` only, not every job) | §6.8 | Declined to widen to every job — node-property residual "only matters where the pass/fail decision itself concentrates" | Re-verified: for every OTHER job, a node property on a NEW key is still caught by that job's own ordinary key-set pin (tree-based, per S-CIGATE-3); only a node property on an ALREADY-pinned key evades a pure key-set diff, and that narrow residual is priced explicitly, not hidden — this is a decision-concentration argument, not a guarantee-strength conflation | SOUND, unchanged |
| No `cargo-mutants@27.1.0` version pin | §6.8 (declined-additions) | Consistency precedent — no existing test byte-pins this literal today either | Precedent-based, not a guarantee-strength claim; unaffected by F-H1's failure mode | SOUND, unchanged |
| No `ESCALATION_THRESHOLD=120` pin | §6.8 (declined-additions) | Same precedent as `--timeout 240`, also unpinned | Same as above | SOUND, unchanged |
| No `mutants_glob_existence.rs` change | §6.8 (declined-additions) | Factual — nothing in this delta adds/removes an `examine_globs` entry | Factual claim, independently re-confirmed against `.cargo/mutants.toml`'s described scope; not a guarantee claim at all | SOUND, unchanged |
| No duplicate 17-check `run_jq_trust_self_test` suite | §6.8 / §6.11 | Same shared-library code already exhaustively proven by the existing suite; a duplicate would add zero incremental coverage | Genuine duplication argument (same function bodies post-extraction) — not a scope overclaim | SOUND, unchanged |
| `resolve_trusted_jq` / RUNNER_OS-keyed PATH resolution | §6.11 | Not declined — NEW, fully mirrored via the shared sourced library | Re-checked for completeness of this audit; not a decline at all | N/A (not a declined row) |
| Pure-bash `dirname` (no external call) | §6.11 | "Inherited by construction — same shared function" | Verified: `mutants-aggregate.sh` sources the identical implementation, and its own new `source` preamble independently uses the same pure-bash technique for the identical reason | SOUND, unchanged |
| Builtin `json="$(</dev/stdin)"` vs `cat` | §6.11 | "Considered and confirmed NOT APPLICABLE" — no stdin input exists in this script | Re-verified: every jq call reads a FILE path argument (`"${jq_bin}" -r '.run_outcome' "${sentinel}"` — the path is a shell argument, not piped stdin); this is orthogonal to F-H1 (F-H1 is about the PATH pointing somewhere attacker-controlled, not about a `cat`-shim intercepting a pipe that doesn't exist here) | SOUND, unchanged |
| Fail-closed default `case`/`*)` arm parity (`EVENT_NAME`) | §6.11 | "ALREADY MIRRORED — not a new round-7 gap" | Re-verified against Step 0's actual `case` statement (§6.2a) — one recognized-good arm, an explicit non-PR allowlist, a `*)` arm that fails closed; matches the `evaluate_needs` peer shape exactly | SOUND, unchanged |
| `--arg`-based jq / injection-safety | §6.11 | "Considered and confirmed NOT APPLICABLE" — no untrusted string reaches a jq PROGRAM body | Re-verified: every dynamic value (loop index `${i}`, or `${STATUS_DIR}`/`${SHARD_DIR}` themselves) is shell-interpolated into a FILE PATH argument, never into the jq FILTER text; this holds regardless of F-H1, since jq-injection and evidence-redirection are different vectors entirely | SOUND, unchanged |
| nounset-safe array expansion (macOS bash 3.2.57) | §6.11 | "NEW finding this round, closing the same class proactively" + F4 must empirically verify | Not a declined row — an open, explicitly-tracked F4 verification obligation; unaffected by F-H1 | N/A (not a declined row) |
| `ALLOWED_SKIPS`-style trust-boundary array | §6.11 | "Not applicable — no analog" — `mutants-aggregate.sh` has no skip-tolerance concept | Re-verified against §6.4's trichotomy design: every reachable state resolves to an explicit `exit 0`/`exit 1`, never `skipped` | SOUND, unchanged |
| `uses:`-VALUES / passwordless-sudo residual | §6.8 / §6.11 | "Considered and explicitly declined to 'fix' — carried forward as accepted residual," identical in kind to `ci-gate`'s own documented residual | Re-verified: this is an EARLIER-step compromise (harden-runner/checkout/download-artifact `uses:` steps, which run before the eval step) that could replace the trusted `jq` binary itself via passwordless sudo — orthogonal to F-H1 (a compromised `jq` could lie regardless of which paths point where) and honestly labeled as unclosed, not claimed as closed | SOUND, unchanged (honest, disclosed residual — not a faulty claim of protection) |
| M2-o — COMPLETE env-block key-SET pin | No env child (e.g. a smuggled `BASH_ENV:`) can be added without a reviewed pin update, even under an already-pinned `env:` KEY | **NEW, item 15** — `PINNED_MUTANTS_AGGREGATE_ENV_KEYS` (7 keys), via the EXISTING generic `extract_gate_env_key_set` (zero new `wf.rs` code). |
| M2-p — byte-pinned `needs:` line | `ci-gate`'s OWN membership list cannot be silently narrowed or widened | **Inherited, already specified.** The round-2 table row (`PINNED_GATE_NEEDS_LINE`, §6.2) already updates this literal's `mutants` member to `mutants-aggregate` — this is a `ci-gate`-side pin, not a `mutants-aggregate`-side one, so there is no separate "does `mutants-aggregate` need this" question; it is `ci-gate`'s existing M2-p protecting exactly the edge this delta retargets. |
| M2-q — YAML node-property scan (`find_key_node_properties`) on the job block | An anchor/tag (`&x key:` / `!!str key:`) prefixing an ALREADY-pinned key resolves to a real key under the real parser but is invisible to a pure key-SET diff | **NEW, item 17** — `test_mutants_aggregate_job_block_has_no_key_node_properties`, calling the EXISTING generic `find_key_node_properties` a SECOND time (zero new `wf.rs` code) against `mutants-aggregate`'s job block. This is the first job other than `ci-gate` this scanner is run against — a deliberate, narrow widening (see "Scope of the M2-q widening" below), not a general extension to every job. |
| AC-001 — invocation assertion (`gate_block.contains(script)`, job-level `if:` contains `always()`) | The gate step actually calls the real script, and the job's `always()` condition is intact, checked at the coarse presence layer `ci-gate` has carried since before the byte-pin era | **NEW, item 16** — `test_mutants_aggregate_step_invokes_mutants_aggregate_script`, direct structural mirror of `test_ci_gate_step_invokes_check_ci_gate_script_with_needs_json`. |
| AC-008 — spec-guard self-test-step pin | The self-test fixture SUITE is actually wired into CI, not merely defined in a script nothing invokes | **NEW, already specified round-3** — item 13, `test_spec_guard_contains_mutants_aggregate_self_test_step`. Listed here for completeness of the peer comparison, not a round-4 addition. |

**Scope of the M2-q widening — deliberately `ci-gate` + `mutants-aggregate`
only, not every job.** The `find_key_node_properties` doc comment
(`tests/ci_gate_completeness.rs :~5566`) explains why `ci-gate` alone
warranted this scan pre-round-4: "it is the sole required branch-
protection check... the narrower, harder-to-detect case... is closed
exactly where the pass/fail decision actually lives." `mutants-aggregate`
now shares that exact property one level down the dependency graph — it
is the sole job DECIDING the mutation-gate result that `ci-gate` then
merely relays. No other `ci-gate.needs` member occupies this role: `fmt`/
`clippy`/`test`/`msrv`/`deny`/`spec-guard`/`check-signing-workflow-
injection` each independently gate their OWN check (their `success`/
`failure` IS the meaningful signal, with no aggregation step interposed),
and `mutants-plan` computes diagnostic OUTPUTS (`escalated`, `mutant_
count`, `overall_diff_lines`) that are separately wiring-pinned at their
OWN consumption sites (items 10/12) rather than needing a whole-block
node-property scan. Widening `find_key_node_properties` to every job in
`ci.yml` was considered and explicitly declined: per the function's own
documented scope note, a node property on an ALREADY-pinned key at a
lower-stakes job is backstopped the same way M2-j's `continue-on-error`
ban is backstopped for `mutants-aggregate` above (a NEW anchored/tagged
key is still caught by that job's own ordinary ADD-side key-set pin) —
the narrower, harder-to-detect residual (an anchor on a key that is
ALREADY a legitimate pinned member) only matters where the pass/fail
decision itself concentrates, which is precisely `ci-gate` and now
`mutants-aggregate`, and nowhere else in this graph.

**What is NOT replicated, stated plainly (summary of the table's own
"declined" rows, gathered in one place per this document's own
"Considered and explicitly declined additions" convention — CORRECTED
round-9, LOW-1):** M2-d (banned outright for `ci-gate`; legitimately
present and value-pinned instead for `mutants-aggregate`, item 18);
M2-g/M2-h (redundant given items 14 + 16); M2-n's SINGLE-input byte-pin
*shape* (no single input exists to pin the way `NEEDS_JSON:` does for
`ci-gate` — this structural-shape observation stands, but as of round-9
ALL SEVEN of seven inputs get an individual byte-VALUE pin: `ESCALATED`/
`EVENT_NAME` from rounds 1/3 for control-flow-criticality; `STATUS_DIR`/
`SHARD_DIR` from round-8, items 23/24, as the evidence-location
`NEEDS_JSON:` analog this job actually has; and `MUTANT_COUNT`/
`OVERALL_DIFF_LINES`/`PLAN_RESULT` from round-9, items 25-27, closing a
declination that pass-13 found circular for `MUTANT_COUNT` under F-H1's
own threat model — the declined-env-value-pin category is retired
entirely, not merely narrowed); the M2-q scan is not extended past
`mutants-aggregate` to every other job (scope argument above, re-verified
sound in the re-audit table, unaffected by round-9). Every remaining
declination in this list is a reasoned, named choice, not a silent gap —
consistent with this document's `EXPECTED_GUARD_TEST_COUNT` history of
treating "considered and declined" as a first-class category alongside
"added," and, as of round-8/round-9, a category that is itself periodically
re-audited rather than assumed permanently settled once written down.

**Round-7 addition — the SAME "declined, not a silent gap" discipline
applied one layer down, at the RUNTIME.** §6.11 (new) enumerates
`check-ci-gate.sh`'s script-level runtime defenses and mirrors each onto
`mutants-aggregate.sh` — but, mirroring THIS section's own honesty about
what does not transfer, one `check-ci-gate.sh` residual is explicitly
CARRIED FORWARD as accepted-not-fixed for the `mutants-aggregate` peer
too, not silently dropped: the `uses:`-VALUES / passwordless-sudo
residual (`resolve_trusted_jq`'s own "HONEST SCOPE" paragraph,
ci-yml-design.md §3a) — an attacker with arbitrary execution in an
EARLIER step of the SAME job (for `mutants-aggregate`: the harden-runner,
checkout, or either download-artifact `uses:` step, all of which run
before the eval step) does not need a PATH shim at all; GitHub-hosted
runners grant passwordless sudo, so `sudo cp /tmp/shim /usr/bin/jq`
replaces the trusted binary in place, which no directory allowlist can
detect. This is IDENTICAL in kind to `ci-gate`'s own accepted residual —
`mutants-aggregate` inherits it because it has the identical shape (a job
with `uses:` steps preceding a single `run:` decision step), not because
this round introduced anything new. See §6.11 for the full restatement.

**Round-8 addendum — F-H1 fix + declination re-audit (fresh-context
adversary pass 11).** A fresh-context F2 adversary found that the M2-n
row's disposition for `STATUS_DIR`/`SHARD_DIR` (immediately above, now
corrected in place) rested on a faulty argument: it cited bash's
`${VAR:?message}` operator as justification for declining a byte-VALUE
pin, describing it as "stronger than any static pin could assert" — true
only for the UNSET/EMPTY case `:?` actually guards, false for a
maliciously-but-validly-SET redirect, which is the failure mode that
matters for two paths that locate this job's ENTIRE evidence set. Fixed
via two new byte-VALUE pins (items 23/24, §6.2): `PINNED_MUTANTS_
AGGREGATE_STATUS_DIR_LINE` (`${{ runner.temp }}/shard-status`) and
`PINNED_MUTANTS_AGGREGATE_SHARD_DIR_LINE` (`${{ runner.temp }}/shards`),
each via the SAME generic byte-exact env-value technique items 10/12
already established — zero new `wf.rs` code, zero new extraction
machinery, purely a new application of an already-proven pattern to two
previously-unpinned values. `:?` is RETAINED in `mutants-aggregate.sh`
unchanged (§6.2a) — it and the new pins are complementary, not
redundant: `:?` catches an accidental unset/empty binding a pin cannot
(a pin only proves the literal TEXT of the `env:` line matches; it says
nothing about a GitHub Actions substitution failure at runtime), and the
new pins catch a deliberate redirect `:?` never could.

Per this round's own "loop-breaker" mandate — since F-H1 itself
originated as a declined row resting on faulty reasoning, no other
declined/N-A/accepted-residual row in §6.8 or §6.11 is assumed sound by
association — every such row was independently re-verified; the full
per-row account is the "Declination re-audit (round-8)" table above. Only
F-H1 was found faulty. Two adjacent rows (`MUTANT_COUNT`'s reconciliation
backstop and `PLAN_RESULT`'s empty-value fail-closed claim) were found
sound but had their soundness materially STRENGTHENED by tracing a
dependency/interlock that the pre-round-8 text left implicit: `MUTANT_
COUNT`'s "stronger than a string-match" claim was silently conditional on
`STATUS_DIR`/`SHARD_DIR` being trustworthy, a conditional this round's fix
now closes structurally; `PLAN_RESULT`'s declination is confirmed sound
via a newly-traced Step-2 sentinel-presence interlock (a hardcoded
`PLAN_RESULT: "success"` cannot manufacture real shard artifacts, because
GHA's default `needs:` semantics skip the `mutants` matrix job entirely on
a genuine `mutants-plan` failure). One row (`OVERALL_DIFF_LINES`) was
found sound-as-worded but is now more precisely scoped, with a genuine,
LOW-severity, previously-unnamed residual disclosed explicitly rather than
left implicit (bounded to converting an already-reconciled-to-zero PR's
base-ref-drift FAIL into a legitimate-zero-mutants OK — it cannot reach
Step 6's kill-rate computation or forge a PASS on any PR with real
surviving mutants).

**Corrected rationale for coordination with formal-verifier (VP-018).**
`verification-delta.md`'s VP-018 (maintained separately) documents the
`STATUS_DIR`/`SHARD_DIR` `${VAR:?message}` runtime guard. Its rationale
must be corrected in the same spirit as this section's M2-n fix: VP-018
should state that `:?` proves the script aborts on an UNSET or EMPTY
`STATUS_DIR`/`SHARD_DIR` — a genuine, narrow guarantee worth its own RED/
GREEN proof — and must NOT claim or imply this makes a byte-VALUE
structural pin on the same two variables redundant or unnecessary; the
two are complementary proofs of two different failure modes (runtime
absence vs. structural wiring-tampering), exactly as VP-010/VP-015
(the `ESCALATED`/`EVENT_NAME` pins) already coexist with, rather than
substitute for, their own runtime-side proofs. Two new VP entries are
needed for items 23/24 — proposed IDs `VP-MUTANTS-SHARD-026`
(`STATUS_DIR` env-wiring byte-pin) and `VP-MUTANTS-SHARD-027`
(`SHARD_DIR` env-wiring byte-pin), mirroring VP-015's exact shape
(structural wiring-integrity pin, defense-in-depth alongside — not a
substitute for — VP-018's runtime `:?` proof) — final numbering and
wording remain formal-verifier's, `verification-delta.md` is maintained
separately from this document per this cycle's own file-ownership split.

**Numbers after round-8:** `EXPECTED_GUARD_TEST_COUNT: 60 -> 62` (+2,
items 23-24). `EXPECTED_FIXTURES` (`scripts/check-ci-gate.sh
--self-test`): unchanged at `14` — this round adds no new fixtures to
that suite. `EXPECTED_MUTANTS_AGG_FIXTURES` (`scripts/mutants-
aggregate.sh --self-test`, §6.2a): unchanged at the round-7 provisional
floor `12` — items 23/24 are Rust-side structural pins on `ci.yml`'s
parsed YAML tree, not bash fixtures exercising `mutants-aggregate.sh`'s
own `evaluate_mutants_aggregate()` function, so they add no new bash
self-test fixture. No invariant STATEMENT in `mutants-sharding-
invariants.md` (INV-AGG/INV-COMPLETE/INV-ESCALATE) changes — this round
is purely a Rust-side structural-pin correction plus documentation
re-audit, the same category round-7's jq-trust-parity tests fell into
("no home in that file," per its own round-7 addendum).

**Round-9 addendum — LOW-1 fix: eliminate the declined-env-value-pin
class entirely (fresh-context adversary pass 13).** A fresh-context F2
adversary re-examined round-8's own "Declination re-audit" table — the
loop-breaker mechanism round-8 introduced specifically because F-H1
itself originated as a declined row resting on faulty reasoning — and
found that mechanism had not gone far enough for `MUTANT_COUNT`: the
round-8 verdict ("SOUND, STRENGTHENED") for the `MUTANT_COUNT`
reconciliation backstop was itself circular. Step 4's reconciliation
check is `total_scored != MUTANT_COUNT`; a PR that hardcodes the eval
step's `MUTANT_COUNT:` env value to whatever total the pooled shards will
actually produce makes that comparison pass trivially, disabling INV-AGG
sub-invariant 8 (the completeness guard) without needing to touch
`STATUS_DIR`/`SHARD_DIR` or any other previously-pinned surface — the
runtime backstop round-8 cited as sufficient justification for declining
a structural pin is the SAME mechanism the attack defeats, because it
consumes `MUTANT_COUNT` rather than independently verifying how
`MUTANT_COUNT` itself is wired. This is bounded LOW, not HIGH like F-H1
— `MUTANT_COUNT` is a single plaintext, PR-visible integer with no
directory-redirect blast radius, and a reviewer diffing `ci.yml` would
see the literal hardcoded value in the diff — but it is the identical
REASONING-gap class F-H1 closed one round earlier (a runtime backstop
described as adequate substitute for a structural pin, without checking
whether the backstop itself reads the unpinned value), which is exactly
what the round-8 loop-breaker mandate existed to catch and did not, for
this one row.

**Fix — eliminate the class, not just the instance.** Rather than patch
`MUTANT_COUNT` alone and leave `OVERALL_DIFF_LINES`/`PLAN_RESULT` as the
last two "declined, re-verified sound" rows (inviting a fourteenth or
fifteenth adversary to re-litigate those two individually the same way
F-H1 and this round each re-litigated one row at a time), all THREE
previously-declined env values are pinned in the SAME round, using the
SAME zero-marginal-cost technique items 10/12/23/24 already established
(one new `#[test]` function and one new `&'static str` constant per
variable, zero new `wf.rs` code): `PINNED_MUTANTS_AGGREGATE_MUTANT_
COUNT_LINE` (`${{ needs.mutants-plan.outputs.mutant_count }}`), `PINNED_
MUTANTS_AGGREGATE_OVERALL_DIFF_LINES_LINE` (`${{ needs.mutants-plan.
outputs.overall_diff_lines }}`), and `PINNED_MUTANTS_AGGREGATE_PLAN_
RESULT_LINE` (`${{ needs.mutants-plan.result }}`) — items 25/26/27, §6.2.
Each existing runtime backstop is RETAINED and reframed as
defense-in-depth alongside its new structural pin, not superseded by it:
`MUTANT_COUNT`'s reconciliation still independently catches genuine
per-shard PLAN↔EXECUTION divergence; `PLAN_RESULT`'s traced Step-2
sentinel-presence interlock still independently prevents a hardcoded
literal from manufacturing real shard artifacts; `OVERALL_DIFF_LINES`'s
`^[0-9]+$` guard still independently catches malformed/empty input. The
difference is that NONE of the three now ALSO has to carry, alone, the
job of proving its own env-line wiring cannot be silently retargeted —
that job now belongs to a pin, the same division of labor `STATUS_DIR`/
`SHARD_DIR`'s `${VAR:?message}` guard and byte-VALUE pin already
established at round-8.

**Result: with items 25-27 landed, ALL SEVEN of `mutants-aggregate`'s
eval-step env values carry BOTH the item-15 key-set pin AND an individual
byte-VALUE pin.** No `mutants-aggregate` env child is any longer
key-set-pinned-but-value-unpinned. `EXPECTED_GUARD_TEST_COUNT: 62 -> 65`.
The §6.8 M2-n row, the three affected rows of the round-8 Declination
re-audit table, the "What is NOT replicated" summary, and the §6.2a
declined-additions bullet are all corrected in place (not merely
appended to) — the retired declination is marked CLOSED with a pointer
to the historical reasoning, not left standing alongside a contradicting
fix, matching this document's own round-8 precedent for how a corrected
row is presented.

**LOW-2 (bookkeeping, same pass-13 review) — `EXPECTED_FIXTURES`
round-1 mislabeling.** The same pass-13 review separately found that
§6.5's "Numbers after this round" paragraph (the FIRST round to
introduce Fixture 14, per §6.1's "NEW Fixture 14" table row) had
described `EXPECTED_FIXTURES` as "unchanged at `14`" — as if Fixture 14
already existed before that round ran, when in fact that round IS where
the real repo baseline (`EXPECTED_FIXTURES=13`, no Fixture 14, per
`scripts/check-ci-gate.sh`'s current state) transitions to `14` for the
first time. Every later round's "unchanged/stays at `14`" wording
(rounds 2 through 8, including the round-3 note this pass-13 review
initially flagged, "Fixture 14 gains a message-substring assertion") is
correct as written — Fixture 14 already exists by then, and none of
those rounds add a further fixture. Only the round-1 paragraph itself
was mislabeled; it is corrected in place (§6.5) to read `13 → 14 (new
Fixture 14, §6.1)`, matching the §6.1 table row it was always meant to
summarize.

**Coordination note for formal-verifier.** Three new VP entries are
needed for items 25/26/27 — proposed IDs `VP-MUTANTS-SHARD-028`
(`MUTANT_COUNT` env-wiring byte-pin), `VP-MUTANTS-SHARD-029`
(`OVERALL_DIFF_LINES` env-wiring byte-pin), and `VP-MUTANTS-SHARD-030`
(`PLAN_RESULT` env-wiring byte-pin) — mirroring VP-015/VP-026/VP-027's
exact shape (structural wiring-integrity pin, defense-in-depth alongside
— not a substitute for — the corresponding runtime proof: VP-018's
`:?`-guard proof has no direct analog for these three since none of them
are read via `${VAR:?message}`, but each has its own existing
runtime-behavior VP the new pin sits alongside: reconciliation for
`MUTANT_COUNT`, the empty-value fail-closed proofs for `PLAN_RESULT`/
`OVERALL_DIFF_LINES`). Final numbering and wording remain
formal-verifier's; `verification-delta.md` is maintained separately from
this document per this cycle's own file-ownership split.

### 6.9 Round-4 adversarial fix — consolidated summary

A fourth, fresh-context F2 adversarial review again confirmed the
aggregator's core decision LOGIC is sound (no new false-green surfaced in
the summation/reconciliation arithmetic, four rounds running) but, for the
fourth round running, found every remaining finding sitting in the
WIRING/GUARDRAIL perimeter — this round one layer further out than any
before it: not "does `mutants-aggregate` have the RIGHT pins" (rounds 1-3's
question) but "does `mutants-aggregate` have the pins a job of ITS KIND
should have at all, by comparison to the one proven reference this repo
already has for that kind of job." Same convention as §6.5/§6.6/§6.7: this
subsection is the single place to see the whole round-4 picture at once.

**PRIMARY (structural-peer enumeration, §6.8) — the headline finding.**
`mutants-aggregate` is now the SOLE `ci-gate.needs` member making the
mutation-gate pass/fail decision (§7 dependency graph), a role only
`ci-gate` itself has occupied before in this file — yet through round-3 it
had inherited only the protections that fall out of GENERIC mechanisms
already iterating every `ci-gate.needs` member, none of the protections
specific to being a uniquely-load-bearing decision step. §6.8 closes this
systematically rather than piecemeal: for every M2-* assertion and the
AC-001/AC-008 checks `ci-gate`'s own decision step carries, §6.8 states the
exact `mutants-aggregate` analog, or explains — by name, with reasoning —
why a given protection is inherited transitively or deliberately declined.
Five new tests result (items 14-18, §6.2): a run-line byte-pin (M2-i
analog), an env-key-set pin (M2-o analog), an invocation assertion (AC-001
analog), a node-property scan (M2-q analog, the second job in this file's
history to get one), and — the one genuinely NEW gap not previously named
in rounds 1-3 — a per-step `if:` VALUE pin for the job's three legitimate
`if: always()` steps (no M2-d analog exists for `mutants-aggregate` because
M2-d's OWN rule, "no step-level `if:` at all," does not hold there; the gap
was that nothing checked the VALUE of those three legitimate `if:`s).

**F2 (MEDIUM) — INV-AGG sub-invariant 8's rollout policy revised to
non-blocking (Option A). REVERSED BY ROUND-5 — SEE §6.10. Retained below
verbatim as the historical record of the Option A/B weighing; §6.10 is
the operative policy.** The pooled-total ⇔ `MUTANT_COUNT` reconciliation
check (round-1) has, across four F2 rounds, never had its core premise —
that `cargo mutants --list` and the pooled sum of 8 `--shard --sharding
slice` invocations are guaranteed bit-identical in count — independently
verified against real cargo-mutants behavior. Rounds 1-3 each proposed
"ship with exact equality first, loosen if it fires on legitimate PRs
later"; round-4 observed that because `mutants-aggregate` is the SOLE
decision point for this gate, "later" means "after every PR on the sharded
gate has already failed closed simultaneously the moment the premise turns
out wrong" — a materially worse failure mode than the defect sub-invariant
8 exists to catch, not a smaller version of it. Resolved via **Option A**:
sub-invariant 8 becomes a NON-BLOCKING `::warning::` for cycle-006's
initial rollout, with a mandatory, explicitly-specified tighten-trigger
(≥2 real PRs, differently-sized in-diff mutant counts, zero reconciliation
warnings, before promotion back to a hard fail — full write-up:
`mutants-sharding-invariants.md`'s round-4 callout under INV-AGG
sub-invariant 8). **Option B** (keep the hard fail, make empirical
verification a blocking precondition for cycle-006's own landing PR) was
considered and is documented as an available fallback, not chosen as the
default, because it makes this cycle's own merge conditional on a single
real PR's diff shape happening to exercise the premise meaningfully on the
first attempt — see that same callout for the full justification of both
options. **The primary kill-rate gate (>=90% pooled kill rate) is
STRUCTURALLY independent of this change, verified by inspection of
`ci-yml-design.md §3` Step 6, not merely asserted:** `killable`/`kill_rate`
are folded entirely from the shards' own `outcomes.json` data (Step 3) and
Step 6 never reads `MUTANT_COUNT` at all, with or without round-4's
change — there is no `MUTANT_COUNT`-shaped variable in scope for it to
reach for even by accident. Two new tests make this independence directly
testable rather than merely true by inspection: item 19 proves a
reconciliation mismatch cannot mask a genuine kill-rate failure (still
`rc == 1`, for the kill-rate reason); item 20 proves a reconciliation
mismatch cannot, by itself, block a genuinely passing PR (still `rc == 0`).
The existing reconciliation guard-test (item 8) is renamed and its
assertion inverted to match (`exit 1` → `exit 0` + `::warning::` — "Tests
MODIFIED in place" item 9, §6.2).

**F3 (process gap) — residual enumeration completed, incidental coverage
confirmed, stale prose catalogued.**

- **Incidental generic coverage, confirmed by reading the real test
  bodies, not assumed from a constant's name:** `test_always_run_jobs_
  have_no_continue_on_error` (`tests/ci_gate_completeness.rs :3339`) and
  `test_ci_gate_needs_jobs_have_no_job_level_if` (`:1196`) both derive
  their iteration set from `always_run_needs_members(&ci)` (`:326`), which
  filters `ci-gate.needs` by `SKIP_TOLERANT_NEEDS_MEMBERS` — once that
  constant is emptied (§6.2 table row 1), BOTH tests automatically iterate
  `mutants-aggregate` with ZERO code change to either test. This is
  exactly the "derive from the live set, not a hand-maintained literal"
  discipline `always_run_needs_members`'s own doc comment (`:306`)
  describes as its reason for existing (the S-626-1 sweep-to-class fix) —
  round-4 confirms it delivers the coverage it promises for a job that
  did not exist when it was written, not merely for the seven it was
  written against.
- **Stale prose F4 must update in the SAME commit as the retarget (grep-
  verified against the real, current `tests/ci_gate_completeness.rs`, not
  inferred):**
  - `:73` — module-map: `test_always_run_jobs_have_no_continue_on_error
    (class sweep, 7 jobs)` → `8 jobs`.
  - `:619`, `:655`, `:720` — `test_ci_gate_needs_exactly_the_required_
    jobs`'s own doc comment and TWO panic-message literal enumerations
    (`[fmt, ..., mutants]` / `{{fmt, ..., mutants}}`) — these are
    INDEPENDENT hardcoded strings, not derived from the `expected`
    `HashSet` literal §6.2 "Tests MODIFIED in place" item 1 already
    updates; each must ALSO get `mutants` → `mutants-aggregate`
    separately, or the panic message shown on a genuine future mismatch
    will name the wrong job.
  - `:625-654` (approx.) — the SAME test's `expected` `HashSet` literal
    carries an inline comment block explaining WHY `mutants` is
    skip-tolerant (`"Carries if: github.event_name == 'pull_request'...
    emits skipped on push events... safe ONLY because mutants is named in
    ALLOWED_SKIPS..."`). This is not merely stale under cycle-006 — it is
    now AFFIRMATIVELY WRONG: `mutants-aggregate` carries NO such `if:`,
    never emits `skipped` (§6.4), and is not in `ALLOWED_SKIPS` (which is
    empty, §6.2 table row 1/item 11). F4 must replace this comment
    entirely with cycle-006's actual rationale (always-run via `if:
    always()`, never skipped by design), not merely swap the job name
    inside the old rationale — swapping the name alone would leave a
    comment asserting something false about `mutants-aggregate`.
  - `:1202-1204` — `test_ci_gate_needs_jobs_have_no_job_level_if`'s own
    leading comment: `"mutants is excluded — it is PR-only by design and
    emits skipped on push events (ci-gate-safe...)"`. Under cycle-006,
    `SKIP_TOLERANT_NEEDS_MEMBERS` is empty, so NOTHING is excluded from
    this test's iteration any more — the sentence's premise (an
    exclusion exists) is gone. Rewrite to describe the new state: every
    `ci-gate.needs` member is iterated, and `mutants-aggregate`
    specifically is handled via the `PINNED_ALWAYS_RUN_WITH_IF_
    EXCEPTIONS` carve-out (§6.2 "Tests MODIFIED in place" item 4), not an
    exclusion from the loop.
  - `:1268` — `PINNED_ALWAYS_RUN_JOB_KEY_SETS`'s own doc comment:
    `"every ci-gate.needs member that must run unconditionally (every
    member except mutants, per always_run_needs_members)"` — same
    "except mutants" premise, same fix (no exception exists post-cycle-
    006; `mutants-aggregate` IS a member of this set, with its own
    `if: always()` carve-out layered on top, not an exclusion from it).
  - `:1313-1314`, `:1328` (approx.) — `"why ALL seven always-run jobs..."`
    / `"of the seven, only fmt, clippy, msrv, spec-guard, and
    check-signing-workflow-injection are concretely exposed to the
    defaults.run.shell vector"` — becomes "ALL EIGHT," and
    `mutants-aggregate` joins the concretely-exposed list (six, not
    five): its "Evaluate sharded mutation gate" step declares no
    step-level `shell:` of its own, so a job-level `defaults.run.shell:
    cat {0}` would silently no-op it exactly as described for the other
    five.
  - `:1228`, `:3319`, `:3328`, `:3368` — four more "seven [always-run]
    jobs" occurrences (doc comments and a panic-message literal inside
    `test_always_run_jobs_have_no_continue_on_error`) — same "seven" →
    "eight" fix, no other content change needed at these four sites.
  - `:6170` — `PINNED_GATE_NEEDS_LINE`'s own literal — already covered by
    the round-2 table row (§6.2, "(round-2, HIGH-1(c))"), cross-referenced
    here only so this checklist is genuinely exhaustive against the grep,
    not because it is a NEW round-4 finding.
  - **Mandatory final sweep, not a substitute for the list above:** F4
    must run `grep -n '"mutants"' tests/ci_gate_completeness.rs` (the
    exact quoted job-name literal, not the substring `mutants` — which
    also matches `mutants-plan`/`mutants-aggregate`/`mutants.toml`/etc.
    legitimately) as the closing step before committing the retarget, and
    resolve every hit not already covered above. This list is
    grep-derived and believed complete as of this document's own review
    of the current, pre-cycle-006 file — but per the §6.7 upgrade
    immediately above, this document's enumeration has been wrong, or
    incomplete, in every round so far; the grep, run against the file
    F4 is ACTUALLY editing, is the authoritative check, not this list.

**Numbers after round-4:** `EXPECTED_GUARD_TEST_COUNT`: `51 → 58` (+7 net
new tests — items 14-18, §6.8's structural-peer analogs, plus items 19-20,
F2's kill-rate/reconciliation independence proofs — on top of round-3's
51; **58 total across all five passes** from the original `38`).
`EXPECTED_FIXTURES` (`scripts/check-ci-gate.sh --self-test`): **unchanged
at `14`**, untouched by this round (round-4's findings are entirely within
`mutants-aggregate`'s own protection surface and reconciliation policy,
not `check-ci-gate.sh` itself). `EXPECTED_MUTANTS_AGG_FIXTURES`
(`scripts/mutants-aggregate.sh --self-test`, §6.2a): provisional floor
revised `8 → 10` (item 8's existing fixture body changes in place per the
§6.2a round-4 note; 2 new sibling fixtures back items 19/20) — F4 still
finalizes the exact number, per §6.2a's own established precedent.

### 6.10 Round-5 adversarial fix — consolidated summary (REVERSES §6.9's F2 entry; STRENGTHENED round-6, see M-1/L-2 inline below)

A fifth, fresh-context F2 adversarial review confirmed round-4's §6.8
structural-peer enumeration and the aggregator's core summation/
reconciliation arithmetic remain sound — no new finding in either, five
rounds running — but identified that round-4's OWN §6.9 F2 finding
introduced a new problem rather than only fixing one: downgrading INV-AGG
sub-invariant 8's reconciliation check from a hard `return 1` to a
non-blocking `::warning::` (round-4's Option A) disables the ONLY guard
this cycle has for "mutants silently vanish between plan and shard
execution." If the dropped mutants happen to be survivors, the pooled
kill rate computed over the smaller, INCOMPLETE scored set can read
`>= 90%` while the true, complete set would not have — a MEDIUM
false-green, on the exact defect class sub-invariant 8 exists to catch,
introduced by round-4's own rollout-policy choice.

**F1 (MEDIUM false-green, REVERSES §6.9's F2 finding) — restore the hard
fail; adopt round-4's own previously-documented Option B as the round-5
default.** Round-4 had weighed two options (§6.9 above, retained
verbatim) and chosen Option A (non-blocking, permissive rollout) as
DEFAULT while explicitly documenting Option B (keep the hard fail, make
empirical verification a precondition instead of a rollout grace period)
as an available, not-unsound fallback "if Option A's rollout period is
judged too permissive by a future reviewer at the F2 human gate." Round-5
IS that judgment: for a fail-closed security gate, a false-RED (a PR
blocked pending investigation, bounded and visible cost) is preferable
to round-4's false-green (a dropped survivor mutant silently passing,
unbounded and invisible cost) — this repo's own CI-gate history states
the identical principle verbatim ("For a fail-closed security gate, fail
LOUD is correct; silent acceptance ... is not," CLAUDE.md CI Gate scope
summary). Two concrete changes, both specified in full in
`mutants-sharding-invariants.md`'s round-5 callout under INV-AGG
sub-invariant 8 and mirrored in `ci-yml-design.md §3`'s Step 4/5:

1. **The hard fail is restored, effective on cycle-006's own landing PR
   — not gated behind a rollout period or a tighten-trigger threshold.**
   `total_scored != MUTANT_COUNT` → `return 1`, both numbers named,
   falling through to nothing (Step 5/6 never execute on a mismatch).
   This is round-1/2/3's original design, restored byte-for-byte.
2. **Exact equality is retained — both directions fail — rather than
   narrowing to a directional `total_scored >= MUTANT_COUNT`.** Rounds
   1-3 already validated the exact-equality arithmetic as sound; round-4's
   concern was rollout BLAST RADIUS, never a specific problem with the
   over-count (`>`) direction, so there is no finding motivating a
   narrower check. An over-count is not obviously safe: it means the
   shard matrix examined MORE mutants than `mutants-plan` counted as
   in-diff-scope, itself an instance of the same "examined does not match
   planned" defect class, with exactly as little operational evidence
   ruling it out as the under-count direction has. See the invariants
   doc's round-5 callout for the full four-point justification.

**M-1 (round-6 strengthening) — the empirical-premise risk round-4 raised
is real; it is now a named, BLOCKING, ACCEPTED-RISK F4 precondition,
verified BEFORE cycle-006's own PR merges, not a permissive rollout
window and not merely "F4 should check this at some point."** This is
structurally unresolvable at the F2/spec level — confirming the `--list`
⇔ pooled `--shard --sharding slice` partition premise actually holds
requires running cargo-mutants for real, which is F4's job, not this
document's — so the mitigation here is to bound and schedule that
diligence precisely rather than leave it open-ended. Two things make this
an ACCEPTED RISK rather than an unguarded gap: (1) the re-widening-to-
warning-only failure mode is ALREADY test-guarded — items 8/9/19/20
(§6.2) all assert `rc == 1`, so nobody can silently reintroduce round-4's
permissive behavior without those tests turning red; (2) the ONE thing
those tests cannot verify is whether the premise the restored hard fail
depends on is itself TRUE against real cargo-mutants output — that is
what the F4 task below closes.

**The concrete F4 task (BLOCKING, performed DURING F4, BEFORE cycle-006's
own PR merges — NOT deferred to discovery on PR #778):** on a scratch
branch carrying a known-nonzero in-diff mutant set (or via direct,
side-by-side comparison against an already-open diff), F4 runs (a)
`cargo mutants --list --in-diff <diff> | wc -l` and (b) the 8 `--shard
k/8 --sharding slice --baseline skip` runs against the IDENTICAL diff,
and confirms the two counts reconcile EXACTLY — the same comparison
`scripts/mutants-aggregate.sh` performs in production, just run by hand
first. **Cycle-006's own landing PR cannot supply this evidence** — it is
CI/doc-only, touching ~0 `src/`-scoped mutants, so it can only exercise
the trivial `MUTANT_COUNT == 0` reconciliation path; F4/F5 must not treat
cycle-006's own green run as validating confidence for the nonzero case.
If the scratch run's two counts differ, F4 must root-cause it — never
re-widen to warning-only as a shortcut — along one of two branches: (a) a
**tooling-surface artifact** (e.g. a header or blank line in `--list`'s
output inflating `wc -l` by one) — fix at the source, stripping it in
`mutants-plan`'s own `--list` invocation; or (b) a genuine **counting-
convention difference** (e.g. `--list` and the pooled run enumerate
`unviable` mutants differently, or a `--baseline skip` interaction
produces a small, explainable, reproducible offset) — encode the CORRECT
reconciliation relationship into `scripts/mutants-aggregate.sh` itself, as
a documented, reasoned adjustment. Either way, the fix lands in the SAME
F4 change, before merge — this is a precondition to trusting the restored
hard fail in production, not a follow-up.

**PR #778's role is now CONFIRMING, not the sole verification point.**
**PR #778** (281 mutants) remains identified as the natural, low-cost
FIRST REAL, production-scale, at-CI exercise of the restored hard fail —
the next substantial PR expected to flow through the sharded pipeline
once cycle-006 merges — but it is no longer where this premise gets
checked for the first time; the scratch run above is. If PR #778
reconciles cleanly, that is corroborating evidence at production scale,
additional to (not a substitute for) the scratch run's closing evidence.
If it fails reconciliation despite a clean scratch run, that is a
FAIL-LOUD signal (both numbers named), not a silent problem, and a human
must root-cause it the same two ways as above — either a genuine
dropped-mutant defect (fix the underlying cause) or a counting-convention
discrepancy the scratch run's diff shape didn't happen to exercise (encode
the CORRECT reconciliation relationship into `scripts/mutants-
aggregate.sh`, documented and reasoned) — never silently suppress or
re-widen the check back to warning-only as a shortcut. This repo's
existing admin branch-protection bypass remains the documented escape
valve for a genuine, time-critical emergency; no new pipeline-level
override mechanism is introduced by this design.

**F2 (contradiction closed) — the §6.2 declined-additions M2-n
rationale for `MUTANT_COUNT` is TRUE again, without qualification.** The
declined-additions entry (§6.2, "Considered and explicitly declined
additions") justifies NOT byte-pinning `MUTANT_COUNT` because it is
"behaviorally reconciled ... stronger than a string-match." Round-4's
downgrade to warning-only had silently broken that claim (a wrong or
mistyped `MUTANT_COUNT` would then only WARN, not fail, on a mismatch —
weaker than "stronger than a string-match" implies); this was never
corrected in round-4's own text, an internal contradiction this round
closes rather than merely notices — `mutants-sharding-invariants.md`'s
INV-COMPLETE Failure Taxonomy table (the "`total_scored != MUTANT_COUNT`"
row) had, in fact, continued to say "FAIL" throughout round-4's draft,
an inconsistency round-5's revert resolves for free rather than by
special-casing. Restoring the hard fail (F1 above) makes the
declined-additions rationale accurate again without qualification: a
wrong or mistyped `MUTANT_COUNT` is caught by the same mechanism that
catches a genuine dropped-mutant defect, once more a strictly stronger
backstop than a static string-match pin would provide. The
declined-additions entry (§6.2) is annotated in place with this
round's correction rather than restated separately here.

**F3 (process-gap, accepted residual) — `mutants-plan`'s weaker
protection tier, documented rather than closed.** `mutants-plan` is a
gate decision-input (it computes `MUTANT_COUNT`/`escalated`/
`OVERALL_DIFF_LINES` and threads them to `mutants-aggregate`) but carries
weaker structural protection than `mutants-aggregate` itself: its
`--list`/threshold logic stays INLINE `run:` YAML text in `ci.yml` (never
extracted into a self-testable script the way `scripts/mutants-
aggregate.sh` was in round-3, §6.2a), and it is NOT a member of
`always_run_needs_members`'s iteration set backing the complete
job/step-key-set pins `mutants-aggregate` inherited at round-4 (§6.8) —
so `mutants-plan`'s own job/step shape has no dedicated key-set pin of
its own beyond the round-4 item-4 existence/`if:`-value test
(`test_mutants_plan_job_exists_and_is_pr_only`). This is an ACCEPTED
RESIDUAL, not a gap this round closes, for three reasons: (a) neutering
`mutants-plan` is mostly fail-closed already by CONSTRUCTION, not by a
dedicated pin — an empty/tampered diff computation routes into the
base-ref-drift FAIL branch (Step 5, `OVERALL_DIFF_LINES == 0` +
`total_scored == 0`), and a crashed/tampered plan step routes into
`PLAN_RESULT != "success"` (Step 0.5), or otherwise collapses into the
already-documented common-mode diff-scoping residual (§5A of
verification-delta.md — the nightly full-scope run is the backstop for
that class regardless of which job produced the bad diff); (b) **with F1
above restoring the hard fail, a wrong or FORCED `MUTANT_COUNT` (e.g. a
tampered `mutants-plan` step deliberately reporting a low count to make
a dropped-mutant scenario reconcile falsely) now trips reconciliation and
hard-fails the gate** — this materially strengthens `MUTANT_COUNT`'s
integrity as a side effect of F1, independent of whether `mutants-plan`
itself gets a dedicated structural pin; (c) extracting `mutants-plan`'s
`--list`/threshold logic to a self-testable script (mirroring §6.2a's
`mutants-aggregate.sh` extraction) is flagged as an OPTIONAL future
symmetry improvement — not required for this cycle, since (a) and (b)
above already bound the practical risk. Tagged `[process-gap]` for the
lessons log, per this document's own convention for residuals recorded
rather than resolved.

**L-2 (round-6, process-gap, doc obligation) — CLAUDE.md's CI-Gate review
scope must grow by one file once `scripts/mutants-aggregate.sh` exists.**
CLAUDE.md's CI-Gate "SCOPE SUMMARY" section states the review scope for a
`ci-gate`-touching PR is a fixed set of PR-editable, decision-path files
(`.github/workflows/ci.yml`, `scripts/check-ci-gate.sh`,
`tests/ci_gate_completeness.rs`, and — added by S-CIGATE-3 —
`tests/common/wf.rs`) that "no repository check compares... against an
outside-the-tree reference definition," i.e. a self-referential review
surface where code review is the only control. `scripts/mutants-
aggregate.sh` (§6.2a) is exactly this same category of file for the
mutation-gate decision specifically: it is PR-editable, it is on the
decision path (`mutants-aggregate`'s gate step invokes it directly), and
its own `--self-test` fixtures are as self-referential as `check-ci-
gate.sh`'s (a malicious or careless PR could edit the script AND its own
fixtures in the same change, exactly the class CLAUDE.md's existing note
already names for the other four files). **This document does NOT edit
CLAUDE.md** — recorded here as an F4 doc-update obligation: F4 adds
`scripts/mutants-aggregate.sh` (and its `EXPECTED_MUTANTS_AGG_FIXTURES`
self-test pins) as a FIFTH file to that review-scope enumeration, in the
same change that lands the script, updating the "four files" language to
"five" and the accompanying prose accordingly. Tagged `[process-gap]`,
same lessons-log convention as F3 above.

**Round-7 correction to L-2 (LOW-1) — the obligation above is now
SUPERSEDED: "five" was itself already stale before F4 ever lands it,
because §6.11 (new, round-7) introduces a SIXTH PR-editable decision-path
file.** `scripts/lib/trusted-jq.sh` (ci-yml-design.md §3a) is exactly the
same category of file as the other five: it is PR-editable, it is on the
decision path for BOTH `check-ci-gate.sh` and `mutants-aggregate.sh` (both
scripts source it and call its functions directly), and a malicious or
careless PR could edit it — or either script's use of it — in the same
change, identically to CLAUDE.md's existing note for the other five.
**F4's doc-update obligation is revised: update CLAUDE.md's "four files"
language directly to "six" (naming `.github/workflows/ci.yml`,
`scripts/check-ci-gate.sh`, `scripts/mutants-aggregate.sh`, `scripts/lib/
trusted-jq.sh`, `tests/ci_gate_completeness.rs`, and `tests/common/
wf.rs`)** — F4 does the round-6 L-2 obligation and this round-7 correction
together, in ONE doc-update pass, rather than landing "five" first and
immediately superseding it in a second pass. This document still does NOT
edit CLAUDE.md — recorded here, same `[process-gap]` lessons-log
convention as L-2/F3 above.

**Numbers after round-5:** `EXPECTED_GUARD_TEST_COUNT`: **UNCHANGED at
`58`** — this round changes assertions/fixtures on three existing test
slots (item 9's rename/body revert; items 19/20's re-scope), it adds and
removes no test. `EXPECTED_FIXTURES` (`scripts/check-ci-gate.sh
--self-test`): unchanged at `14`, untouched (round-5's changes are
entirely within `mutants-aggregate.sh`'s own reconciliation logic and its
own fixtures). `EXPECTED_MUTANTS_AGG_FIXTURES`
(`scripts/mutants-aggregate.sh --self-test`, §6.2a): **UNCHANGED at
`10`** — round-4 already landed 10 fixtures backing items 8/9's rename
and the two new items 19/20; round-5 changes those SAME three fixtures'
bodies/expected values in place (item 8/9's fixture reverts to
`rc="fail"` naming both counts; items 19/20's fixtures change to the
over-count and healthy-partial-kill-rate shapes respectively), it adds no
new fixture slot.

### 6.11 Runtime hardening parity with `check-ci-gate.sh` (round-7)

**Why this section exists.** §6.8 (round-4) made `mutants-aggregate` a
documented structural peer of `ci-gate` at the RUST/YAML layer — every
protection `test_ci_gate_pass_fail_semantics_are_structurally_placed`
asserts about `ci-gate`'s job block now has a named `mutants-aggregate`
analog or a named reason it doesn't apply. A fresh-context round-7
adversary confirmed that table is genuinely complete for its own scope,
but observed the scope itself was too narrow: `check-ci-gate.sh` is not
just a job block with pinned keys — it is a SCRIPT, and the script ITSELF
carries a second, independent layer of hardening, proven over 20+ rounds
(S-CIGATE-2/3, S-626-1 passes 59-61), that has nothing to do with `ci.yml`
parsing and everything to do with what happens once the `run:` line
actually executes: PATH-shim-resistant jq resolution, strict shell mode,
and a builtin-stdin-read defense against a `cat` shim. None of that had
been mirrored onto `mutants-aggregate.sh` — it called `jq` bare
everywhere. This section closes that gap, using the same disposition-table
method §6.8 established: for every runtime defense on `check-ci-gate.sh`'s
decision path, state the exact `mutants-aggregate.sh` analog, or state,
explicitly, why it does not apply or is already achieved by construction.

**Table: `check-ci-gate.sh` runtime defense → `mutants-aggregate.sh`
disposition.**

| `check-ci-gate.sh` runtime defense (source) | What it guards | `mutants-aggregate.sh` disposition |
|---|---|---|
| `resolve_trusted_jq` / RUNNER_OS-keyed trusted-PATH jq resolution (`:~486`) | Every decision-path jq call resolves to a real system jq, not a `$GITHUB_PATH`-prepended shim that could forge every OK/FAIL line | **NEW, headline finding.** Extracted into a SHARED, sourced library, `scripts/lib/trusted-jq.sh` (ci-yml-design.md §3a), sourced by BOTH scripts — not a second hand-copy (anti-drift; see §3a's own rationale). `mutants-aggregate.sh` resolves `jq_bin` ONCE, before Step 0, and routes every jq call (`.run_outcome`/`.has_outcomes` on each sentinel, `jq empty`, `.caught`/`.missed`/`.timeout`/`.unviable`/`.total_mutants`/`(.outcomes\|length)` on each shard's `outcomes.json`) through `"${jq_bin}"` instead of a bare `jq` — see ci-yml-design.md §3's revised script body. Structural pins: items 21-22, §6.2. |
| Pure-bash `dirname` inside `resolve_trusted_jq` (no external `dirname` call — ADV-P61-HIGH-001) | A SECOND PATH-shim vector (a `dirname` shim always printing a trusted directory, defeating the directory allowlist even with a genuinely-shimmed jq) | **Inherited by construction — same shared function.** `mutants-aggregate.sh` never calls `resolve_trusted_jq` itself; it sources the identical implementation `check-ci-gate.sh` already hardened. Additionally, `mutants-aggregate.sh`'s OWN new `source` preamble (resolving its `scripts/lib/` sibling path) uses the SAME pure-bash parameter-expansion technique, not an external `dirname` call, for the identical reason — see ci-yml-design.md §3's revised header. |
| `set -euo pipefail` | Command failures, unset variables, and failures inside a pipeline all abort loudly by default rather than silently continuing on stale/partial state | **NEW.** `mutants-aggregate.sh`'s prior `set -uo pipefail` (missing `-e`, no documented rationale for the omission) is upgraded to `set -euo pipefail`, matching `check-ci-gate.sh`'s posture exactly. Every existing failure branch is already an explicit `return 1`/`return 2` (Steps 0 through 6 never relied on errexit for control flow), so this is pure defense-in-depth against an UNANTICIPATED command failure (e.g. a future edit that adds a command whose failure isn't explicitly checked) — not a behavior change to any currently-specified decision path. |
| `bash -n "${BASH_SOURCE[0]}"` explicit syntax self-check | One clear syntax-error message up front, rather than relying on incidental function-definition-before-use ordering | **NEW.** Added verbatim (same repo convention, same acknowledgment that it is not strictly load-bearing given every function is fully defined before `main "$@"` runs) — consistency with `check-ci-gate.sh`, not a new failure mode being closed. |
| Builtin `json="$(</dev/stdin)"` instead of `cat` (ADV-P61-INFO-005) | A `cat` shim on `$GITHUB_PATH` could fabricate the ENTIRE decision input regardless of the real `toJSON(needs)` piped in | **Considered and confirmed NOT APPLICABLE — no analog needed.** `mutants-aggregate.sh` takes no stdin input at all; its inputs are environment variables (`EVENT_NAME`/`ESCALATED`/`MUTANT_COUNT`/`OVERALL_DIFF_LINES`/`PLAN_RESULT`/`STATUS_DIR`/`SHARD_DIR`, already individually validated/regex-guarded per-consumer — VP-010/VP-013/VP-015) and JSON FILES read directly BY `jq` itself (`"${jq_bin}" -r '.run_outcome' "${sentinel}"` — `jq` opens the file itself; no intermediate `cat`/pipe exists on this path to shim). There is no bare-`cat`-equivalent vector here because there is no bare-`cat` call in the design to begin with — this is a genuine structural difference between the two scripts' input shapes, not an oversight. |
| Fail-closed default (`*)` arm on `evaluate_needs`'s per-job result) — no allowlist-of-known-bad shape | An unrecognized/malformed value fails closed by construction, not by enumerating every bad value in advance | **ALREADY MIRRORED — not a new round-7 gap.** `mutants-aggregate.sh`'s Step 0 `case "${EVENT_NAME}"` already has this exact shape (round-3, HIGH-1): one recognized-good arm (`pull_request`), an explicit allowlist of recognized non-PR events, and a default `*)` arm that FAILS CLOSED on anything else — including an empty string and any future unrecognized trigger. Listed here for completeness of the peer comparison, not a round-7 addition. |
| `--arg`-based jq invocation (job name never string-interpolated into the jq PROGRAM text — jq-injection-safe) | A crafted job name cannot break out of the jq filter string | **Considered and confirmed NOT APPLICABLE.** Every dynamic value `mutants-aggregate.sh` feeds to jq is a FILE PATH built from a fixed integer loop index (`seq 0 $((EXPECTED_SHARDS - 1))`), never a string embedded inside a jq filter program — there is no analog of `check-ci-gate.sh`'s `--arg j "${job}"` pattern to mirror because `mutants-aggregate.sh` has no untrusted string flowing INTO a jq filter body at all; every jq PROGRAM in this script (`.run_outcome`, `.caught // 0`, etc.) is a static literal. |
| `nounset`-safe array expansion (`ALLOWED_SKIPS[@]`, round-3 MEDIUM-1 — fails on macOS bash 3.2.57 for a declared-but-empty array under `set -u`) | A `#[cfg(unix)]` subprocess test on the `macos-latest` leg does not crash on bash 3.2's stricter nounset-array behavior | **NEW finding this round, closing the same class proactively.** `mutants-aggregate.sh` builds `sentinel_files=("${STATUS_DIR}"/mutants-shard-status-*/shard-status-*.json)` under `shopt -s nullglob` and reads `"${#sentinel_files[@]}"` (count only — the script never expands `"${sentinel_files[@]}"` for element iteration, so the ELEMENT-expansion form of the round-3 bug class is not directly reachable today). **F4 must still empirically verify** (mirroring `check-ci-gate.sh`'s own round-3 proof methodology exactly — construct the zero-match case and run it under real bash 3.2.57, not just reason about it) whether the COUNT form `"${#empty_array[@]}"` is ALSO affected on macOS bash 3.2.57 under `set -u`, since the two scripts' `#[cfg(unix)]` subprocess tests run on the identical `macos-latest` leg. If verified affected, apply the same fix pattern `check-ci-gate.sh` uses for `ALLOWED_SKIPS` (an explicit non-empty guard before the array expansion). Tracked as an F4 verification item, not resolved by this design pass — see the F4 obligations note below. |
| `ALLOWED_SKIPS`-style trust-boundary array declared at file scope, restrictive by design | (Not a `mutants-aggregate.sh` concept — no skip-tolerance array exists there) | **Not applicable — no analog.** `mutants-aggregate.sh` has no `ALLOWED_SKIPS`-shaped concept; INV-ESCALATE/INV-COMPLETE's pass/fail/no-op trichotomy is a different mechanism entirely (§6.4). Listed only to state explicitly that this defense class was considered and found to have no counterpart, not silently skipped. |
| The `uses:`-VALUES / passwordless-sudo HONEST SCOPE residual (`resolve_trusted_jq`'s own module comment) — an attacker with earlier-step arbitrary execution in the SAME job does not need a PATH shim at all | States plainly what this resolver CANNOT close, so it is never mis-described as closing more than it does | **Considered and explicitly declined to "fix" — carried forward as an accepted residual, restated for the peer, not silently dropped.** `mutants-aggregate`'s job has four steps preceding the eval step (harden-runner, checkout, download-artifact ×2, all `uses:`) — the identical shape `ci-gate`'s own residual describes. This resolver closes the cheaper PATH-shim vector for BOTH scripts and is worth keeping, but "an attacker cannot forge the decision" is not an accurate description of what it achieves on its own, for `mutants-aggregate` any more than for `ci-gate`. See §6.8's own round-7 addition for the cross-reference from the structural-peer table. |

**Anti-drift choice, stated explicitly (per the task's own framing):
shared sourced helper, not a replicated copy.** `scripts/lib/trusted-jq.sh`
(ci-yml-design.md §3a) is sourced by BOTH `check-ci-gate.sh` and
`mutants-aggregate.sh`. Rejected alternative: hand-copying
`resolve_trusted_jq`/`is_trusted_jq_dir`/`trusted_jq_dirs_for` into
`mutants-aggregate.sh` as a second, independent implementation — declined
because it reproduces, one layer down, the exact "tested tree != merged
tree" / drift-between-copies class this repo's own `strict: false` note
(CLAUDE.md) already documents for a different mechanism: a future fix to
the resolver could land in one copy and be forgotten in the other, with
nothing but human review to catch the divergence. The shared-file approach
makes that drift structurally impossible (one copy, both callers), at the
cost of a new PR-editable file entering the decision-path review surface
— priced explicitly via the LOW-1 CLAUDE.md review-scope correction below,
not left as an unstated tradeoff.

**New guard tests (items 21-22, §6.2) — `EXPECTED_GUARD_TEST_COUNT: 58 ->
60`.** Item 21 proves both scripts SOURCE the shared file (wiring); item
22 proves neither script contains a bare, un-resolved `jq` invocation
anywhere on its decision path (usage) — item 21 alone cannot catch a
script that sources the helper and then still calls bare `jq` at some
call site by carelessness, so both are needed, and neither subsumes the
other. See §6.2's item 21/22 entries for the exact assertion shape.

**Considered and declined: duplicating `check-ci-gate.sh`'s existing
17-check `run_jq_trust_self_test` suite inside `mutants-aggregate.sh
--self-test`.** The shared library is the SAME code `check-ci-gate.sh`'s
existing suite (`EXPECTED_JQ_TRUST_CHECKS = 17`, unchanged by this round)
already exhaustively proves — `resolve_trusted_jq`/`is_trusted_jq_dir`
behave identically regardless of which sourcing script calls them, since
they are the literal same function bodies post-extraction. A second,
byte-identical 17-check suite inside `mutants-aggregate.sh`'s own
`--self-test` would inflate `EXPECTED_MUTANTS_AGG_FIXTURES` with zero
incremental coverage — the same "redundant defense-in-depth is declined"
reasoning §6.8 already applies to M2-g/h, and the same reasoning §6.1's
own round-3 note applies to declining a second local-override fixture for
`ALLOWED_SKIPS`. What DOES need — and gets — new coverage is items 21-22
above: a static proof that both scripts actually USE the shared resolver
on every call site, which is a genuinely different question from "does
the resolver itself work," already answered.

**F4 obligations this section adds (collected here for visibility, each
already stated in its own table row above):**
1. Extract `trusted_jq_dirs_for`/`is_trusted_jq_dir`/`resolve_trusted_jq`
   out of `check-ci-gate.sh` into `scripts/lib/trusted-jq.sh`; add the
   `source` preamble to `check-ci-gate.sh` in place of the deleted
   functions. Zero behavior change; `EXPECTED_JQ_TRUST_CHECKS` stays `17`.
2. Land `scripts/mutants-aggregate.sh` per ci-yml-design.md §3's revised
   body (sources the shared library, `set -euo pipefail`, `bash -n`
   self-check, `jq_bin` resolved once before Step 0, every jq call routed
   through `"${jq_bin}"`).
3. Add items 21-22 (§6.2) to `tests/ci_gate_completeness.rs`.
   `EXPECTED_GUARD_TEST_COUNT: 58 -> 60`.
4. Empirically verify (real bash 3.2.57, `macos-latest`) whether
   `"${#sentinel_files[@]}"` is affected by the round-3 nounset-array
   class; apply the `ALLOWED_SKIPS`-style guard if so. Not blocking F4
   completion of items 1-3 above, but must land before this cycle's PR
   merges if the empirical check finds it IS affected (same "fail-closed
   by default, verify before shipping an assumption" discipline this
   document applies to the `--list`⇔pooled reconciliation premise, §1's
   "F4 Blocking Preconditions" list).
5. Update CLAUDE.md's CI-Gate review-scope enumeration to SIX files (LOW-1
   correction to the round-6 L-2 note, above) — `.github/workflows/
   ci.yml`, `scripts/check-ci-gate.sh`, `scripts/mutants-aggregate.sh`,
   `scripts/lib/trusted-jq.sh`, `tests/ci_gate_completeness.rs`,
   `tests/common/wf.rs`.

**Numbers after round-7:** `EXPECTED_GUARD_TEST_COUNT: 58 -> 60` (+2,
items 21-22). `EXPECTED_FIXTURES` (`scripts/check-ci-gate.sh --self-test`):
unchanged at `14` — the extraction to `scripts/lib/trusted-jq.sh` is a
pure relocation of existing, already-tested functions; `run_jq_trust_
self_test`/`EXPECTED_JQ_TRUST_CHECKS` (unchanged at `17`) continues to
exercise them identically post-move. `EXPECTED_MUTANTS_AGG_FIXTURES`
(`scripts/mutants-aggregate.sh --self-test`, §6.2a): **provisional floor
`10 -> 12`** — see §6.2a's own round-7 correction for the full derivation
(LOW-2: item 1's fixture pair, +1; the previously-uncounted Step-0.5
fixture, +1).

## 7. Dependency graph

```
mutants-plan
     |
     +---> mutants (matrix ×8)
     |            |
     +------------+---> mutants-aggregate ---> ci-gate
```

Acyclic. `mutants-nightly.yml` is a wholly separate workflow file with no
edge into or out of `ci.yml`'s graph at all (not even via artifacts —
separate workflow runs do not share `runner.temp`/artifact namespaces
across workflow files by default, and this design does not attempt to
share any). No cycle is introduced or possible: every new edge points
strictly "downstream" toward `mutants-aggregate`, which itself has exactly
one outbound edge into `ci-gate` (the same shape the old single `mutants`
job already had).

## 8. Version pin: `cargo-mutants@27` → `cargo-mutants@27.1.0`

Two `uses: taiki-e/install-action` sites now carry this exact pin:
`mutants-plan` and `mutants` (both need cargo-mutants installed;
`mutants-aggregate` does NOT need it installed — it only runs `jq`/bash
over already-produced `outcomes.json` files, so its `taiki-e/install-
action` step should be OMITTED from `mutants-aggregate` entirely, saving a
download on the aggregation job). `mutants-nightly.yml`'s `mutants-full`
job also carries the same exact pin, independently, since it is a
separate workflow file with its own install step. All three (`mutants-
plan`, `mutants`, `mutants-nightly.yml :: mutants-full`) MUST use the
byte-identical `cargo-mutants@27.1.0` string — a drift between them (e.g.
`mutants-plan` on `27.1.0` but `mutants` shards still on `27`) would
reintroduce exactly the cross-invocation schema-instability risk the
research grounding flagged as the reason to tighten the pin in the first
place. No structural Rust-side test enforces this three-way consistency
(per §6.2's "considered and declined" list) — it is a code-review-time
obligation, consistent with how the pre-existing single `@27` pin has
always been enforced (by review, not by a byte-pin test).

## 9. Note for the F2 human gate: the open GHA semantics question

This document's Option 2 recommendation (§6.4) does not DEPEND on the
answer to "does a job's custom `if:` override the implicit needs-success
check" — that is precisely its design point. But the answer is still
useful context for the human gate: if CONFIRMED true, Option 1 (simple
rename, no new pin category, smaller diff) becomes a legitimate,
lower-cost alternative that trades a small amount of platform-semantic
reliance for materially less guardrail churn — the human may reasonably
prefer that tradeoff once the semantic is confirmed rather than
unverified. If the confirmation has not landed by the time this document
reaches the gate, proceed with Option 2 (this document's default) rather
than block the gate on it — Option 2 is correct regardless of the
answer, only its guardrail-simplicity is at stake, not its correctness.
