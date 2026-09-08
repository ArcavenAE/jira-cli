---
document_type: verification-delta
feature_name: "mutants-ci-sharding"
cycle: cycle-006
created: 2026-09-07
status: draft
author: formal-verifier (vsdd-factory)
phase: F2 Step 4 (Verification Property Extension) — SPEC/DESIGN ONLY, no test/proof code
traces_to:
  - .factory/phase-f2-spec-evolution/cycle-006/architecture-delta.md
  - .factory/phase-f2-spec-evolution/cycle-006/mutants-sharding-invariants.md
  - .factory/phase-f2-spec-evolution/cycle-006/ci-yml-design.md
governance: policy-doc-only (docs/specs/cargo-mutants-policy.md §Spec Anchor) — NO new PRD BC
  (DEC-348; precedent MUTATION-CI-TIMEOUT 2026-06-28). VPs live in this standalone F2 record,
  mirroring verification-delta-components.md's "VPs formalized in a standalone F2 doc" pattern.
scope_note: DESIGN ONLY. This document edits NO in-repo file (ci.yml, scripts/*,
  tests/*, .cargo/mutants.toml, docs/specs/*). It specifies WHAT F4 must assert and the
  RED proof each assertion must first demonstrate; F4 writes the bodies, F6 hardens.
revision_note: "Round-9 adversarial-fix UPDATE (ninth pass) — ELIMINATE THE
  'DECLINED ENV-VALUE PIN' CLASS ENTIRELY. The round-9 revised design
  (architecture-delta.md items 25-27 = MUTANT_COUNT/OVERALL_DIFF_LINES/PLAN_RESULT
  byte-VALUE pins; §6.8 M2-n row + Declination re-audit table updated so those three
  rows move DECLINED → MIRRORED; §6.2a declined-additions bullet retired; Round-9
  addendum) closes LOW-1: the round-8 'declined env-value pin' rationale for
  `MUTANT_COUNT` was CIRCULAR under the very env-edit threat model F-H1 (round-8)
  itself adopted. Because Step 4 reconciliation is keyed on
  `total_scored != MUTANT_COUNT`, a PR that simply HARDCODES the eval step's
  `MUTANT_COUNT:` env value to equal whatever real pooled total the shards will
  produce makes reconciliation pass TRIVIALLY — disabling sub-invariant 8 (the
  completeness guard, VP-008) via the EXACT class of attack F-H1 closed for
  `STATUS_DIR`/`SHARD_DIR` one round earlier: the pre-round-9 declination cited a
  RUNTIME backstop (reconciliation) as justification for skipping a STRUCTURAL pin,
  without noticing the runtime backstop itself reads a value the structural layer
  left unpinned. Bounded LOW (not HIGH like F-H1) only because `MUTANT_COUNT` is a
  single plaintext, PR-visible integer with no directory-redirect blast radius — but
  the reasoning gap is the SAME class, and round-8's own loop-breaker mandate was
  supposed to catch exactly this. **Fix — eliminate the 'declined env-value pin'
  class entirely, not just this one instance:** all THREE previously-declined
  eval-step env values now carry byte-VALUE structural pins, via the SAME generic
  byte-exact env-child-value technique items 10/12/23/24 already establish (zero new
  `wf.rs` code). This delta ADDS THREE VPs (all new Rust `#[test]`, all byte-VALUE
  structural pins mirroring VP-026/027's shape, no subprocess): VP-MUTANTS-SHARD-028
  (item 25 — test_mutants_aggregate_mutant_count_env_wired,
  PINNED_MUTANTS_AGGREGATE_MUTANT_COUNT_LINE ==
  ${{ needs.mutants-plan.outputs.mutant_count }}), VP-MUTANTS-SHARD-029 (item 26 —
  test_mutants_aggregate_overall_diff_lines_env_wired,
  PINNED_MUTANTS_AGGREGATE_OVERALL_DIFF_LINES_LINE ==
  ${{ needs.mutants-plan.outputs.overall_diff_lines }}), and VP-MUTANTS-SHARD-030
  (item 27 — test_mutants_aggregate_plan_result_env_wired,
  PINNED_MUTANTS_AGGREGATE_PLAN_RESULT_LINE == ${{ needs.mutants-plan.result }}).
  Each RED proof mirrors VP-026/027: a mutant hardcoding the env value (editable
  under the env-edit threat model) defeats the corresponding guard. For MUTANT_COUNT
  specifically the RED proof must show that hardcoding it to equal the real pooled
  total TRIVIALLY satisfies Step-4 reconciliation (disabling sub-invariant 8's
  completeness guard) → the byte-VALUE pin fails RED on the hardcoded value while
  the runtime reconciliation stays deceptively GREEN. These are defense-in-depth
  WIRING pins (structural), complementary to the runtime behavior, exactly like
  VP-010/015/026/027. **All SEVEN of `mutants-aggregate`'s eval-step env values now
  carry BOTH a key-set pin (VP-018) AND an individual byte-VALUE pin — NO
  value-pin declination remains.** VP-018's cross-references are updated accordingly
  (the 'three keys with key-set pin but no byte-VALUE pin' clause is retired — all
  seven now dual-pinned). `EXPECTED_GUARD_TEST_COUNT` revised **62 -> 65** (+3 net
  new `#[test]`: VP-028 + VP-029 + VP-030). `EXPECTED_MUTANTS_AGG_FIXTURES` UNCHANGED
  at floor `12` (items 25-27 are Rust-side structural pins on ci.yml's parsed YAML,
  not bash self-test fixtures). `EXPECTED_FIXTURES` is `13 -> 14` (new Fixture 14
  added by THIS cycle for the emptied-`ALLOWED_SKIPS` bash-3.2 nounset self-test),
  then stable at 14 through rounds 2-9 — NOT a pre-cycle baseline of 14 (LOW-2
  framing correction; architecture-delta round-9 LOW-2). `EXPECTED_JQ_TRUST_CHECKS`
  UNCHANGED at 17. **THIRTY VPs total (001..030, gapless).** §5A common-mode + §6.10
  mutants-plan + M-1 `--list`⇔pooled + sentinel_files / uses:-sudo documented
  residuals, the Kani/fuzz N/A note, and the 0-GAP-on-covered-surface note are all
  RETAINED. --- Round-8 adversarial-fix UPDATE (eighth pass) — EVIDENCE-SOURCE
  REDIRECT (the true M2-n analog). The round-8 revised design (architecture-delta.md
  items 23/24 STATUS_DIR/SHARD_DIR byte-VALUE pins, §6.8 M2-n row now MIRRORED not
  declined, the new 'Declination re-audit (round-8)' table, the Round-8 addendum, and
  the corrected §6.2a rationale; ci-yml-design.md's STATUS_DIR/SHARD_DIR env-line pin
  cross-ref) closes F-H1 (HIGH false-green): the pre-round-8 §6.8 M2-n disposition
  DECLINED a byte-VALUE pin on STATUS_DIR/SHARD_DIR on a FAULTY argument — it claimed
  bash's ${VAR:?message} operator was 'stronger than any static pin could assert'.
  ${VAR:?} proves ONLY abort-on-UNSET/EMPTY; it gives ZERO protection against a
  maliciously-but-VALIDLY-SET redirect. mutants-aggregate.sh reads its ENTIRE evidence
  set — every shard status sentinel AND every outcomes.json — through these two paths;
  a PR that edits the eval step's env: block to point STATUS_DIR/SHARD_DIR at
  attacker-supplied directories, then checks in fabricated sentinels + a fake
  outcomes.json reporting missed=0 / caught==MUTANT_COUNT (a deterministically knowable
  target, since MUTANT_COUNT is itself a plaintext PR-visible env value), passes ${VAR:?}
  (both vars non-empty), passes VP-018's key-set pin (which never inspects env VALUES
  for these two keys), and produces a 100%-caught FALSE PASS while every real shard
  result is silently bypassed — the exact NEEDS_JSON-class vector M2-n exists to close
  for ci-gate. This delta ADDS TWO VPs (both new Rust `#[test]`, both byte-VALUE
  structural pins mirroring VP-015's shape, no subprocess): VP-MUTANTS-SHARD-026 (item
  23 — test_mutants_aggregate_status_dir_env_wired,
  PINNED_MUTANTS_AGGREGATE_STATUS_DIR_LINE == ${{ runner.temp }}/shard-status) and
  VP-MUTANTS-SHARD-027 (item 24 — test_mutants_aggregate_shard_dir_env_wired,
  PINNED_MUTANTS_AGGREGATE_SHARD_DIR_LINE == ${{ runner.temp }}/shards). Each RED
  proof: a mutant redirecting the env value to an attacker-controlled dir (e.g.
  ${{ github.workspace }}/x) — where a PR commits fake sentinels + a fake outcomes.json
  with caught==MUTANT_COUNT — produces a FALSE-GREEN under the mutant (real shard
  results bypassed) but the byte-VALUE pin fails RED on the redirected value. These are
  the TRUE M2-n analog: STATUS_DIR/SHARD_DIR locate the ENTIRE evidence the aggregator
  reads, like ci-gate's single NEEDS_JSON input. **VP-018's rationale is CORRECTED
  accordingly** — it must NOT imply ${VAR:?} makes a byte-VALUE pin redundant. ${VAR:?}
  proves only abort-on-unset/empty and gives ZERO protection against a malicious-but-SET
  redirect; VP-018's env-KEY-SET pin (guards BASH_ENV-smuggling) and the new byte-VALUE
  pins VP-026/027 (guard evidence-source redirect) are COMPLEMENTARY proofs of DIFFERENT
  failure modes — exactly as VP-010/VP-015 coexist with their own value pins for
  ESCALATED/EVENT_NAME. §6.8's M2-n row is now MIRRORED (not declined); the round-8
  declination re-audit re-verified all other §6.8/§6.11 declined/N-A/accepted-residual
  rows SOUND (two — MUTANT_COUNT's and PLAN_RESULT's — STRENGTHENED, an OVERALL_DIFF_LINES
  LOW residual now named). `EXPECTED_GUARD_TEST_COUNT` revised **60 -> 62** (+2 net new
  `#[test]`: VP-026 + VP-027). `EXPECTED_MUTANTS_AGG_FIXTURES` UNCHANGED at floor `12`
  (items 23/24 are Rust-side structural pins on ci.yml's parsed YAML, not bash self-test
  fixtures); `EXPECTED_FIXTURES` UNCHANGED at 14; `EXPECTED_JQ_TRUST_CHECKS` UNCHANGED
  at 17. **TWENTY-SEVEN VPs total (001..027, gapless).** §5A common-mode + §6.10
  mutants-plan + M-1 `--list`⇔pooled + sentinel_files / uses:-sudo documented residuals,
  the Kani/fuzz N/A note, and the 0-GAP-on-covered-surface note are all RETAINED. ---
  Round-7 adversarial-fix UPDATE (seventh pass) — RUNTIME
  HARDENING PARITY. The round-7 revised design (architecture-delta.md NEW
  §6.11 'Runtime hardening parity with check-ci-gate.sh', §6.2 items 21-22,
  §6.8 round-7 cross-reference, §6.10 review-scope→SIX; ci-yml-design.md NEW
  §3a shared `scripts/lib/trusted-jq.sh` + revised §3 script body with
  `set -euo pipefail`, a `bash -n` self-check, and a once-resolved `jq_bin`
  routing every decision-path jq call; mutants-sharding-invariants.md INV-AGG
  straddling Fixture 1A+1B) closes MED-1: §6.8 (round-4) mirrored `ci-gate`'s
  RUST/YAML structural pins onto `mutants-aggregate` but NEVER mirrored
  `check-ci-gate.sh`'s SCRIPT-LEVEL RUNTIME hardening — `mutants-aggregate.sh`
  called `jq` bare everywhere, so a `$GITHUB_PATH`-prepended jq shim could
  forge the mutation-gate decision the exact way S-626-1 pass-59 fixed for
  `ci-gate` (ADV-P59-LOW-001). Round-7 makes `mutants-aggregate.sh` a
  STRUCTURAL PEER of `check-ci-gate.sh` at the RUNTIME layer, complementing
  §6.8's Rust-structural peering. This delta ADDS TWO VPs (both new Rust
  `#[test]`, both structural text-scans, no subprocess):
  VP-MUTANTS-SHARD-024 (item 21 — BOTH `scripts/check-ci-gate.sh` AND
  `scripts/mutants-aggregate.sh` SOURCE the shared `scripts/lib/trusted-jq.sh`
  helper, which itself exists and defines
  `resolve_trusted_jq`/`is_trusted_jq_dir`/`trusted_jq_dirs_for`; a wiring
  pin) and VP-MUTANTS-SHARD-025 (item 22, the load-bearing half — NEITHER gate
  script has a bare, un-resolved decision-path `jq` call: every jq invocation
  routes through `\"${jq_bin}\"`, the sole exception being `trusted-jq.sh`'s own
  single legitimate `command -v jq` in `resolve_trusted_jq`, excluded by
  line-anchor not blanket-file allowlist). VP-025 carries a RED proof against a
  bare `jq` (PATH-shim-forgeable) decision call in `mutants-aggregate.sh` that
  forges kill-rate inputs → false-green; VP-024 a RED proof against a mutant
  that drops the `source .../trusted-jq.sh` line. These two make the mutation
  gate a RUNTIME peer of `check-ci-gate.sh`, closing the pass-8 MED-1 jq-shim
  false-green vector. `EXPECTED_GUARD_TEST_COUNT` revised **58 -> 60** (+2 net
  new `#[test]`: VP-024 + VP-025). `EXPECTED_MUTANTS_AGG_FIXTURES` floor
  revised **10 -> 12** (+1 for INV-AGG item-1's straddling Fixture 1B, +1 for
  the previously-uncounted Step-0.5 `PLAN_RESULT != success` fixture — LOW-2
  floor-arithmetic correction, architecture-delta §6.2a round-7). VP-001's
  entry already specifies the explicit 1A+1B straddling fixture pair; the
  round-7 note is the floor-count reconciliation, not a fixture-shape change.
  `EXPECTED_FIXTURES` (`check-ci-gate.sh --self-test`) UNCHANGED at 14 (the
  extraction to `scripts/lib/trusted-jq.sh` is a pure relocation of already-
  tested functions; `EXPECTED_JQ_TRUST_CHECKS` stays 17). **TWENTY-FIVE VPs
  total (001..025, gapless).** NEW F4 obligation recorded (§6 note 19): apply
  the `[ \"${#arr[@]}\" -eq 0 ]` empty-array short-circuit to ALL array
  expansions in `mutants-aggregate.sh` (e.g. `sentinel_files`) under `set -u`,
  per the pass-3 MEDIUM-1 bash-3.2-macOS nounset precedent — a caught-at-CI
  false-red if any `#[cfg(unix)]` macos-leg subprocess test exercises it.
  §5A common-mode + §6.10 mutants-plan + the M-1 `--list`⇔pooled documented
  residuals, the Kani/fuzz N/A note, and the 0-GAP-on-covered-surface note are
  all RETAINED. --- Round-6 LIGHT SYNC (sixth pass) — CONSISTENCY ONLY, no VP
  assertion change, no count change. Round-6 strengthened the M-1 mitigation
  across the OTHER three cycle-006 design docs (architecture-delta.md,
  mutants-sharding-invariants.md, ci-yml-design.md): the empirical
  `--list`<->pooled-`--shard` reconciliation-premise verification is now a
  MANDATORY, BLOCKING scratch-run task performed during cycle-006 F4 BEFORE
  cycle-006's own PR merges — run `cargo mutants --list --in-diff <diff>` and
  the eight `--shard k/8 --sharding slice --baseline skip` runs against a
  known-nonzero diff, confirm exact reconciliation, and root-cause any mismatch
  as either a tooling-surface artifact (strip header/blank line in mutants-plan)
  or a counting-convention adjustment (encode in `scripts/mutants-aggregate.sh`);
  NEVER re-widen to warning-only. This F2 record is synced to match: the MANDATORY
  scratch-run-before-merge F4 task is now the PRIMARY verification of the
  `--list`<->pooled premise, and PR #778 (281 mutants) is reframed from 'the
  sole/first live exercise' to a CONFIRMING, production-scale exercise layered on
  top of that scratch-run — NOT the first or sole verification. M-1 is thereby an
  ACCEPTED, F4-GATED RESIDUAL, a peer to the §5A common-mode residual and the
  §6.10 mutants-plan residual. NO VP assertion changes (VP-008/022/023 stay
  rc==1), NO coverage-matrix change, NO count change: `EXPECTED_GUARD_TEST_COUNT`
  stays 58, `EXPECTED_MUTANTS_AGG_FIXTURES` stays 10, `EXPECTED_FIXTURES` stays 14.
  --- Round-5 adversarial-fix UPDATE (fifth pass) — REVERSES
  round-4's reconciliation rollout downgrade. The round-5 revised design
  (mutants-sharding-invariants.md §INV-AGG sub-invariant 8 round-5 callout,
  restoring HARD-FAIL exact-equality BOTH directions; architecture-delta.md
  §6.10 consolidated round-5 summary; ci-yml-design.md Step 4 `return 1` on
  mismatch) restores INV-AGG sub-invariant 8 (pooled-total <-> MUTANT_COUNT
  reconciliation) from round-4's NON-BLOCKING `::warning::` back to an
  unconditional HARD FAIL (`total_scored != MUTANT_COUNT` -> `return 1`,
  exact equality, both directions), effective on cycle-006's own landing PR
  — NOT gated behind a rollout window or tighten-trigger. Round-5 REVERSES
  round-4's Option A in favor of round-4's own documented Option B: for a
  security-relevant fail-closed gate, failing LOUD on an unverified premise
  is the correct default (bounded, visible false-RED cost) over silently
  accepting a dropped-survivor mutant (unbounded, invisible false-green
  cost) — round-4's warning-only policy disabled the ONLY guard this cycle
  has for 'mutants silently vanish between plan and shard execution', which,
  if the missing mutants are survivors, lets the pooled kill rate on the
  smaller scored set read >=90% while the true complete set would not. This
  round REVERTS THREE VPs' assertions (all now rc==1):
  (1) VP-008 name+assertion revert to the round-1 original —
  `test_mutants_aggregate_fails_closed_on_mutant_count_reconciliation_mismatch`,
  fixture `MUTANT_COUNT=101` vs pooled `100` (healthy partial kill rate),
  assert exit **1**;
  (2) VP-022 (item 19) RE-SCOPED to the OVER-count direction —
  `MUTANT_COUNT=100`, pooled `101`, healthy kill rate, assert exit **1**
  (proves exact-equality is symmetric; over-count is the same examined!=planned
  defect class);
  (3) VP-023 (item 20) INVERTED to assert a mismatch FAILS — same fixture as
  VP-008 (mismatch + healthy partial kill rate), assert exit **1**,
  reconciliation-mismatch message PRESENT, Step-6 pass message ABSENT.
  The empirical `--list`<->pooled partition-premise risk (round-4's stated
  reason for hesitating) is NO LONGER handled by a permissive rollout window;
  it is handled by a MANDATORY, BLOCKING F4 scratch-run task performed BEFORE
  cycle-006's own PR merges (round-6): run `cargo mutants --list --in-diff
  <diff>` and the eight `--shard k/8 --sharding slice --baseline skip` runs
  against a known-nonzero diff, confirm exact reconciliation, and root-cause any
  mismatch as a tooling-surface artifact (strip header/blank line in
  mutants-plan) or a counting-convention adjustment (encode in
  `scripts/mutants-aggregate.sh`) — NEVER re-widen to warning-only. This
  scratch-run is the PRIMARY verification of the premise. **PR #778** (281
  mutants) is a CONFIRMING, production-scale exercise layered on top of the
  scratch-run — NOT the first or sole verification (cycle-006's own PR is
  CI/doc-only, ~0 `src/` mutants, so it exercises only the trivial
  `MUTANT_COUNT==0` path). If PR #778 later trips reconciliation, that too is
  fail-loud-and-correct: root-cause it — a real dropped-mutant bug (fix it) or a
  counting-convention discrepancy (encode a documented, reasoned adjustment into
  `scripts/mutants-aggregate.sh`), NEVER silently re-widen back to warning-only.
  M-1 is an ACCEPTED, F4-GATED RESIDUAL, peer to the §5A common-mode residual and
  the §6.10 mutants-plan residual. Counts UNCHANGED — this round is
  assertion/fixture-body changes to three existing test slots only, NO new or
  removed tests: `EXPECTED_GUARD_TEST_COUNT` stays **58**,
  `EXPECTED_MUTANTS_AGG_FIXTURES` stays **10**, `EXPECTED_FIXTURES` stays 14.
  TWENTY-THREE VPs total (001..023, gapless), unchanged. §5A's common-mode
  documented residual, the reconciliation-restored strengthening of
  MUTANT_COUNT integrity, the §6.10 mutants-plan accepted-residual
  cross-reference, and the Kani/fuzz N/A + 0-GAP-on-covered-surface note are
  all retained. --- Round-4 adversarial-fix UPDATE (fourth pass). The round-4
  revised design (architecture-delta.md §6.8 NEW structural-peer enumeration
  + §6.7 upgrade + §6.2 additions; mutants-sharding-invariants.md §INV-AGG
  sub-invariant 8 round-4 callout; ci-yml-design.md) makes `mutants-aggregate`
  a documented STRUCTURAL PEER of `ci-gate`, adding the anti-neutering
  guardrail CLASS `ci-gate`'s own decision step carries over 20+ review rounds
  but that `mutants-aggregate` — now the SOLE `ci-gate.needs` member making the
  mutation-gate pass/fail decision — never inherited. This delta ADDS SEVEN
  VPs: VP-MUTANTS-SHARD-017 (decision-step run-line byte-pin, M2-i analog),
  -018 (decision-step env-key-set pin, M2-o analog), -019 (invocation
  assertion, AC-001 analog), -020 (job-block node-property scan, M2-q analog),
  -021 (per-step `if:`-VALUE pin for the three legitimate `if: always()` steps
  — genuinely new, no round-1/2/3 analog), -022 (reconciliation mismatch does
  NOT mask a kill-rate FAIL), and -023 (reconciliation mismatch does NOT block
  a passing PR). VP-017..021 are the five structural-peer pins (§6.8); each has
  a RED proof against its specific neutering (run-line pin RED against
  `|| true`/`| cat`/`; exit 0`; env-key-set pin RED against a smuggled
  `BASH_ENV:`; invocation assertion RED against a renamed script; node-property
  scan RED against `&x`/`!!str` on a pinned key; per-step-`if:` pin RED against
  an `if: false` on a download/eval step). VP-022/023 prove the >=90% pooled
  kill-rate gate is INDEPENDENT of sub-invariant 8's warn/pass state (a mutant
  coupling the kill-rate result to MUTANT_COUNT is caught). This delta also
  MODIFIED VP-008 (SUPERSEDED BY THE ROUND-5 REVERSAL ABOVE — retained as
  history): round-4 made INV-AGG sub-invariant 8 (reconciliation)
  `::warning::`-only (NON-BLOCKING, exit 0 on mismatch) for cycle-006's initial
  rollout, with a mandatory empirical tighten-trigger before promotion back to
  a hard fail, and RENAMED its test to
  `test_mutants_aggregate_reconciliation_mismatch_emits_non_blocking_warning`
  with an inverted assertion. Round-5 REVERTS all of that: the name reverts to
  `..._fails_closed_on_mutant_count_reconciliation_mismatch` and the assertion
  back to exit 1 (hard fail restored). VP-022/023 similarly re-scoped to rc==1.
  EXPECTED_GUARD_TEST_COUNT revised 51 -> 58 (+7 net new `#[test]`: all of
  VP-017..023). EXPECTED_MUTANTS_AGG_FIXTURES floor revised 8 -> 10;
  EXPECTED_FIXTURES unchanged at 14. TWENTY-THREE VPs total now (001..023,
  gapless). Under round-5's restored hard fail the `--list`<->pooled partition
  determination is retained as an explicitly-flagged F4-gated residual alongside
  the §5A documented residual (NOT a rollout/tighten window); round-6 makes its
  PRIMARY verification a mandatory, BLOCKING pre-merge scratch-run, with PR #778
  reframed as a later CONFIRMING production-scale exercise (see the round-6
  LIGHT SYNC entry above).
  --- Round-3 adversarial-fix UPDATE (third pass). The round-3
  revised design (architecture-delta.md §6.2a extraction + §6.7, ci-yml-design.md
  §3 Step-0 fail-closed `case` + STATUS_DIR/SHARD_DIR env templating + §5
  spec-guard wiring) closes HIGH-1 (mutants-aggregate's Step 0 push-event no-op
  was FAIL-OPEN on a malformed/empty EVENT_NAME — a mistyped `${{ }}` env key
  resolves to \"\", which the pre-fix `!= 'pull_request'` treated as \"not a PR,
  exit 0\" with ZERO shard inspection on a real PR; now a fail-CLOSED allowlist
  `case`), MEDIUM-1 (`is_allowed_skip` — the sibling round-2's print_allowed_skips
  fix never reached — gains a `${#ALLOWED_SKIPS[@]} -eq 0 && return 1` guard,
  return-1 NOT return-0, the documented asymmetry; a genuine macOS bash 3.2.57
  crash risk this cycle introduces by emptying ALLOWED_SKIPS in production;
  Fixture 14 gains a message-substring assertion and its safety claim now covers
  BOTH CI bash versions), and MEDIUM-2 (aggregator EXTRACTED to
  `scripts/mutants-aggregate.sh` with `--self-test` + EXPECTED_MUTANTS_AGG_FIXTURES
  wired into spec-guard; fixtures 4/5 unified into ONE shared
  `run_fixture_with_synthetic_skip_tolerant_job` wrapper;
  `test_allowed_skips_has_exactly_three_code_level_references` RENAMED `...four...`
  with count 3->4). This delta ADDS VP-MUTANTS-SHARD-014 (Step-0 fail-closed
  event guard, with a RED proof distinguishing it from the old fail-OPEN
  `!=`-exit-0 form — behavioral, rides EXPECTED_MUTANTS_AGG_FIXTURES), -015
  (`EVENT_NAME` env-wiring byte-pin, mirrors VP-010; a `#[test]`), and -016
  (spec-guard mutants-aggregate self-test-step pin; a `#[test]`); and adds a
  round-3 note to VP-012 recording the `is_allowed_skip` return-1 guard, Fixture
  14's macOS-leg message assertion, and the fixtures-4/5 shared-wrapper rename
  (count 3->4). EXPECTED_GUARD_TEST_COUNT revised 49 -> 51 (+2 net new `#[test]`:
  VP-015 + VP-016; VP-014 adds NO `#[test]`). SIXTEEN VPs total now (001..016,
  gapless). --- Round-2 adversarial-fix UPDATE (second pass). The round-2
  revised design (architecture-delta.md §6.6, mutants-sharding-invariants.md
  §INV-AGG sub-invariant 8 round-2 callout, ci-yml-design.md §§1,3 round-2
  notes) DOWN-SCOPES INV-AGG sub-invariant 8's reconciliation claim (catches
  per-shard plan<->execution divergence only; a common-mode corruption of the
  shared mutants-diff-file — incl. a genuine MUTANT_COUNT==0 from a base-ref/
  scoping quirk — is now a DOCUMENTED RESIDUAL, backstopped only by the nightly
  full run), hardens mutants-plan's `--list` step to fail closed on a genuine
  tooling failure (no longer swallowed into MUTANT_COUNT=0), adds an
  OVERALL_DIFF_LINES malformed-but-set regex guard, and adds ONE new test
  (test_skip_tolerant_surface_is_consistently_empty_by_design) plus a NEW
  sibling self-test (run_print_allowed_skips_self_test, EXPECTED_PRINT_ALLOWED_
  SKIPS_CHECKS = 1). EXPECTED_GUARD_TEST_COUNT revised 48 -> 49 (+1 net; two
  existing tests TRANSFORMED in-body, no count change). This delta ADDS
  VP-MUTANTS-SHARD-011 (skip-tolerant-surface empty-consistency), -012
  (print_allowed_skips empty-array self-test), and -013 (OVERALL_DIFF_LINES
  malformed-set guard); RE-FRAMES VP-010 (drop 'fail-OPEN maximally dangerous'
  — an empty/mistyped escalated key is fail-CLOSED/wasted-CI, NOT
  merge-unverified); DOWN-SCOPES VP-008; and records the common-mode
  MUTANT_COUNT==0 shared-source condition as an explicit Documented Residual
  (§5A), distinct from a GAP. THIRTEEN VPs total now (001..013, gapless).
  --- Round-1 (prior pass): redesigned INV-COMPLETE around a per-shard status
  SENTINEL (Part A write / Part B presence / Part C interpretation), added
  INV-AGG sub-invariant 8, and added two structural guards (WITH_IF cross-check
  MED-1, escalation-wiring pin MED-2); took EXPECTED_GUARD_TEST_COUNT 38 -> 48;
  added VP-MUTANTS-SHARD-006..010 and the HIGH-2 all-shards-crash false-green VP
  (VP-006) with an explicit RED proof. The three INV-COMPLETE sub-cases
  (infra-cancel / harness-crash / legit-empty) are each given a distinguishing
  RED proof (§3A, §5)."
---

# Verification Delta — mutants-ci-sharding (cycle-006)

Defines the verification properties for the three named invariants (INV-AGG,
INV-COMPLETE, INV-ESCALATE) as REVISED by the round-1, round-2, round-3,
round-4, and round-5 adversarial fixes, plus the structural pins the architect called out (the
`mutants-plan` job pin, the `EXPECTED_SHARDS`-literal ⇔ matrix-shard-count
cross-check, the round-1 `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS` cross-check, and
the `mutants-plan`→`mutants-aggregate` escalation-wiring pin), plus the round-2
additions (the skip-tolerant-surface empty-consistency test, the
`print_allowed_skips` empty-array self-test, and the `OVERALL_DIFF_LINES`
malformed-set guard), plus the round-3 additions (the Step-0 fail-closed
`EVENT_NAME` event guard, the `EVENT_NAME` env-wiring byte-pin, and the
`spec-guard` mutants-aggregate self-test-step pin), plus the round-4
additions (the five structural-peer pins making `mutants-aggregate` a
documented peer of `ci-gate` — a decision-step run-line byte-pin, an
env-key-set pin, an invocation assertion, a job-block node-property scan, and a
per-step `if:`-VALUE pin — plus the two reconciliation-related proofs VP-022/023),
plus the round-5 reversal (INV-AGG sub-invariant 8 reconciliation restored from
round-4's NON-BLOCKING `::warning::` back to an unconditional HARD FAIL,
`total_scored != MUTANT_COUNT` → exit 1, exact equality both directions; VP-008,
VP-022, and VP-023 all now assert rc==1, with the `--list`⇔pooled partition
premise's PRIMARY verification a mandatory, BLOCKING pre-merge F4 scratch-run
(round-6) and PR #778 a later CONFIRMING production-scale exercise, not a
rollout window), plus the round-7 runtime-hardening parity (INV-AGG's
`mutants-aggregate.sh` becomes a RUNTIME structural peer of `check-ci-gate.sh`
— a shared, sourced `scripts/lib/trusted-jq.sh` helper, `set -euo pipefail`,
and every decision-path jq call routed through a once-resolved `${jq_bin}` —
guarded by VP-024 (both scripts source the shared helper) and VP-025 (neither
has a bare, un-resolved decision-path `jq` call), closing the pass-8 MED-1
jq-shim false-green vector), plus the round-8 evidence-source-redirect closure
(F-H1: INV-AGG's `mutants-aggregate` eval-step `env:` mapping now byte-VALUE-pins
`STATUS_DIR`/`SHARD_DIR` — the two paths that locate the ENTIRE sentinel + outcomes
evidence set the decision reads — guarded by VP-026 (`STATUS_DIR` byte-value pin)
and VP-027 (`SHARD_DIR` byte-value pin), the TRUE M2-n analog for this job, closing
the `NEEDS_JSON`-class false-green where a PR redirects the evidence directories to
attacker-controlled dirs holding fabricated `caught==MUTANT_COUNT` data; VP-018's
rationale is corrected so `${VAR:?}` (abort-on-unset/empty only) is no longer implied
to make these byte-VALUE pins redundant — the key-set pin and the value pins are
complementary proofs of different failure modes), plus the round-9
declined-env-value-pin-class elimination (LOW-1: the round-8 declination of a
byte-VALUE pin on `MUTANT_COUNT` was CIRCULAR — hardcoding `MUTANT_COUNT` to the
real pooled total trivially satisfies Step-4 reconciliation, disabling
sub-invariant 8's completeness guard; the fix pins the byte-VALUE of ALL THREE
previously-declined eval-step env values — `MUTANT_COUNT`, `OVERALL_DIFF_LINES`,
`PLAN_RESULT` — guarded by VP-028/029/030, so all SEVEN of `mutants-aggregate`'s
eval-step env values now carry BOTH a key-set pin (VP-018) AND an individual
byte-VALUE pin, with NO value-pin declination remaining).
**Thirty VPs total** — `VP-MUTANTS-SHARD-001..030`, gapless. Each VP
states the property, names the invariant it enforces, specifies the verification
MECHANISM in this repo's established style, gives the CONCRETE assertion, and —
the load-bearing part — specifies the NEGATIVE/RED proof each test must
demonstrate before it is trustworthy: the exact false-green (or false-red)
failure mode it must distinguish correct behavior from. §5A records the one
KNOWN-uncovered condition (a documented residual, explicitly distinct from a
GAP).

---

## 0. VP-ID allocation — `VP-MUTANTS-SHARD-001..030`

**Namespace:** `VP-MUTANTS-SHARD-NNN`, 3-digit zero-padded, sequential from
`001`. Fresh feature-scoped namespace, continuing this repo's established
convention of per-feature VP namespaces rather than one global sequence.
Precedent for a fresh feature-scoped VP namespace: `VP-MUTANTS-SCOPE-1-*`,
`VP-CIGATE-*`, `VP-COMPONENT-*`, `VP-576-*`, `VP-577-*`, `VP-CITE-*`
(verification-delta-components.md §0 documents this scheme-in-use rationale).

**Collision check (grep-verified this session, round-9):** before this round's
edits, `grep -rohE 'VP-MUTANTS-SHARD-0[0-9][0-9]' .factory | sort -u` returned
only `001..027` (the pre-round-9 allocations — `001..025` in THIS file, `026..027`
added round-8) — **no prior use of `028..030` as a VP allocation**, so the round-9
extension is gapless and collision-free. (Re-running the grep AFTER this round's
edits surfaces `028..030` as well — those appear only in THIS file's own new
allocation in the frontmatter/tables/bodies below and in the round-9
architecture-delta items 25-27 that are their DESIGN SOURCE, not a foreign VP-namespace
collision.) Adjacent namespaces are unaffected and not extended:
`VP-MUTANTS-SCOPE-1-*` tops out at `-002`, `VP-CIGATE-*` at `-001`.
This delta deliberately does NOT reuse or extend `VP-MUTANTS-SCOPE-1-*` (that
namespace governs `examine_globs` scope drift — a different subject) nor
`VP-CIGATE-*` (that governs the pass/fail decision-function structural pins
already landed in S-CIGATE-1..3). The sharding invariants are a distinct subject
and get their own gapless run `001..030`.

| VP-ID | Subject | Invariant enforced | Round |
|---|---|---|---|
| VP-MUTANTS-SHARD-001 | Pooled-sum kill-rate contract (never averages shard %) | INV-AGG | orig F2 |
| VP-MUTANTS-SHARD-002 | Missing/duplicate SENTINEL fail-closed (exact expected-set) | INV-COMPLETE Part B | orig F2 (fixture revised) |
| VP-MUTANTS-SHARD-003 | Escalation encoded as ordinary `failure`, never silent pass/skip | INV-ESCALATE | orig F2 (fixture revised) |
| VP-MUTANTS-SHARD-004 | `mutants-plan` job exists, is PR-only, is `ci-gate`-excluded | structural pin (architect §6.2 T4) | orig F2 |
| VP-MUTANTS-SHARD-005 | `EXPECTED_SHARDS` literal ⇔ `matrix.shard` length cross-check | structural pin / drift-prevention (architect §6.2 T5) | orig F2 |
| VP-MUTANTS-SHARD-006 | **All-shards-crash fail-closed** (sentinel present, `run_outcome=failure`, no outcomes) | INV-COMPLETE Part C — harness-crash arm (**CRIT-1 regression / HIGH-2 was-missing VP**) | round-1 |
| VP-MUTANTS-SHARD-007 | Legitimately-empty shards PASS (sentinel present, `run_outcome=success`, no outcomes → contribute 0) | INV-COMPLETE Part C — legit-empty arm (HIGH-1 regression) | round-1 |
| VP-MUTANTS-SHARD-008 | Pooled-total ⇔ `MUTANT_COUNT` reconciliation mismatch → **HARD FAIL / fail-closed (exit 1), exact equality both directions** (round-5 RESTORED to round-1 original; round-4's warning-only downgrade REVERSED) | INV-AGG sub-invariant 8 | round-1 (warning-only round-4, hard fail RESTORED round-5) |
| VP-MUTANTS-SHARD-009 | `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS` disjoint + tautological (`always()`) | structural cross-check (MED-1) | round-1 |
| VP-MUTANTS-SHARD-010 | `mutants-plan.escalated` ⇒ `mutants-aggregate` `ESCALATED` env wiring pin (**re-framed round-2: fail-CLOSED/wasted-CI on a broken key, NOT fail-open**) | structural wiring-integrity pin (MED-2) | round-1 (reframed round-2) |
| VP-MUTANTS-SHARD-011 | Skip-tolerant surface is consistently EMPTY across all three lists (`ALLOWED_SKIPS`/`SKIP_TOLERANT_NEEDS_MEMBERS`/`PINNED_ALLOWED_SKIP_IF_EXPRESSIONS`) — by design | structural three-way empty-consistency (HIGH-1 a+b) | round-2 |
| VP-MUTANTS-SHARD-012 | `print_allowed_skips` yields `[]` (zero lines), never `[""]`, over the empty production array | behavioral bash self-test / new sibling counter (MEDIUM-1) | round-2 |
| VP-MUTANTS-SHARD-013 | `OVERALL_DIFF_LINES` malformed-but-SET value fails CLOSED (regex guard), never routes to the wrong base-ref-drift branch | behavioral bash-subprocess fixture (LOW — consumer-side wiring guard) | round-2 |
| VP-MUTANTS-SHARD-014 | Step-0 **fail-CLOSED** event guard — empty/unknown `EVENT_NAME` on a real PR FAILS (exit 1); known non-PR (`push`/`schedule`/`workflow_dispatch`) still exits 0 (**RED proof distinguishes the fixed allowlist `case` from the old fail-OPEN `!= 'pull_request' → exit 0` form**) | INV-ESCALATE-adjacent runtime guard (HIGH-1 — the one genuinely NEW false-green this round) | round-3 |
| VP-MUTANTS-SHARD-015 | `mutants-aggregate` eval-step `env.EVENT_NAME` binds byte-exactly to `${{ github.event_name }}` (input-side wiring pin, mirrors VP-010's output-side pin) | structural wiring-integrity pin (HIGH-1 defense-in-depth) | round-3 |
| VP-MUTANTS-SHARD-016 | `spec-guard` job runs `scripts/mutants-aggregate.sh --self-test` (step present + `run:` line byte-pinned) — proves the `EXPECTED_MUTANTS_AGG_FIXTURES` suite actually executes in CI | structural extraction-wiring pin (§6.2a) | round-3 |
| VP-MUTANTS-SHARD-017 | `mutants-aggregate` decision-step `run:` line byte-pinned (`bash scripts/mutants-aggregate.sh`) — no `\|\| true`/`\| cat`/`; exit 0` suffix can silently neuter the eval step (**structural peer of `ci-gate`'s M2-i**) | structural anti-neutering pin (§6.8, M2-i analog) | round-4 |
| VP-MUTANTS-SHARD-018 | `mutants-aggregate` decision-step `env:` COMPLETE key-set pinned (7 keys) — closes a `BASH_ENV:`-class smuggled-env-child vector + protects the 5 keys with no individual byte-VALUE pin (**structural peer of `ci-gate`'s M2-o**) | structural anti-neutering pin (§6.8, M2-o analog) | round-4 |
| VP-MUTANTS-SHARD-019 | `mutants-aggregate` step actually invokes `scripts/mutants-aggregate.sh` + job-level `if:` contains `always()` — presence/invocation layer (**structural peer of `ci-gate`'s AC-001**) | structural invocation assertion (§6.8, AC-001 analog) | round-4 |
| VP-MUTANTS-SHARD-020 | `mutants-aggregate` job block carries NO YAML node property (`&anchor`/`!tag`) on any key — the second job in this file's history scanned (**structural peer of `ci-gate`'s M2-q**) | structural node-property scan (§6.8, M2-q analog) | round-4 |
| VP-MUTANTS-SHARD-021 | `mutants-aggregate`'s THREE legitimate step-level `if:` occurrences each equal the exact tautology `always()` — a `if: false` on a download/eval step (false-RED correctness break) is caught (**genuinely NEW, no round-1/2/3 analog**) | structural per-step `if:`-VALUE pin (§6.8, new gap) | round-4 |
| VP-MUTANTS-SHARD-022 | Exact-equality reconciliation is SYMMETRIC — an OVER-count (`MUTANT_COUNT=100`, pooled `101`) at a healthy kill rate still exits 1 (proves the check is `!=`, not `<`-only; over-count is the same examined≠planned defect class) | INV-AGG sub-invariant 8 exact-equality symmetry (§6.10 item 19; round-5 RE-SCOPED from round-4's does-not-mask) | round-4 (re-scoped round-5) |
| VP-MUTANTS-SHARD-023 | A healthy-looking PARTIAL kill rate never rescues a dropped-mutant mismatch — mismatch (`MUTANT_COUNT=101`, pooled `100`) + pooled `>=90%` still exits 1, reconciliation-mismatch message PRESENT, Step-6 pass message ABSENT | INV-AGG sub-invariant 8 completeness-over-quality (§6.10 item 20; round-5 INVERTED from round-4's does-not-block) | round-4 (inverted round-5) |
| VP-MUTANTS-SHARD-024 | BOTH `scripts/check-ci-gate.sh` AND `scripts/mutants-aggregate.sh` SOURCE the shared `scripts/lib/trusted-jq.sh` helper, which itself exists and defines `resolve_trusted_jq`/`is_trusted_jq_dir`/`trusted_jq_dirs_for` (runtime-hardening WIRING pin — **structural RUNTIME peer of `check-ci-gate.sh`**) | INV-AGG runtime-hardening parity (§6.11 item 21, MED-1) | round-7 |
| VP-MUTANTS-SHARD-025 | NEITHER gate script has a bare, un-resolved decision-path `jq` call — every jq invocation routes through `${jq_bin}` (sole exception: `trusted-jq.sh`'s own `command -v jq` in `resolve_trusted_jq`, line-anchored not file-allowlisted). Closes the pass-8 MED-1 `$GITHUB_PATH`-jq-shim false-green (**load-bearing half; structural RUNTIME peer of `check-ci-gate.sh`**) | INV-AGG runtime-hardening parity (§6.11 item 22, MED-1) | round-7 |
| VP-MUTANTS-SHARD-026 | `mutants-aggregate` eval-step `env.STATUS_DIR` byte-VALUE-pinned to `${{ runner.temp }}/shard-status` (`PINNED_MUTANTS_AGGREGATE_STATUS_DIR_LINE`) — the path that locates the ENTIRE status-sentinel evidence set the decision reads; closes the F-H1 evidence-source-redirect false-green. Complements (does NOT replace) VP-018's key-set pin and the `${VAR:?}` runtime guard (**TRUE M2-n analog; mirrors VP-015's shape**) | INV-AGG evidence-source-integrity (§6.8 corrected M2-n row / item 23, F-H1 HIGH) | round-8 |
| VP-MUTANTS-SHARD-027 | `mutants-aggregate` eval-step `env.SHARD_DIR` byte-VALUE-pinned to `${{ runner.temp }}/shards` (`PINNED_MUTANTS_AGGREGATE_SHARD_DIR_LINE`) — the path that locates the ENTIRE outcomes.json evidence set; same F-H1 closure applied to the sibling path. Separate test from VP-026 (one-test-per-pinned-variable convention, items 10/12) (**TRUE M2-n analog; mirrors VP-015's shape**) | INV-AGG evidence-source-integrity (§6.8 corrected M2-n row / item 24, F-H1 HIGH) | round-8 |
| VP-MUTANTS-SHARD-028 | `mutants-aggregate` eval-step `env.MUTANT_COUNT` byte-VALUE-pinned to `${{ needs.mutants-plan.outputs.mutant_count }}` (`PINNED_MUTANTS_AGGREGATE_MUTANT_COUNT_LINE`) — closes the LOW-1 CIRCULAR declination: hardcoding this value to the real pooled total trivially satisfies Step-4 reconciliation, disabling sub-invariant 8's completeness guard (VP-008). Defense-in-depth WIRING pin complementing the runtime reconciliation (**structural; mirrors VP-026/027's shape**) | INV-AGG env-wiring integrity / reconciliation-completeness (§6.8 MIRRORED M2-n row / item 25, LOW-1) | round-9 |
| VP-MUTANTS-SHARD-029 | `mutants-aggregate` eval-step `env.OVERALL_DIFF_LINES` byte-VALUE-pinned to `${{ needs.mutants-plan.outputs.overall_diff_lines }}` (`PINNED_MUTANTS_AGGREGATE_OVERALL_DIFF_LINES_LINE`) — retires the last declined env-value pin for this key; the byte-VALUE pin guards the wiring where the runtime regex guard (VP-013) guards only malformed/empty handling (**structural; mirrors VP-026/027's shape**) | INV-AGG env-wiring integrity (§6.8 MIRRORED M2-n row / item 26, LOW-1) | round-9 |
| VP-MUTANTS-SHARD-030 | `mutants-aggregate` eval-step `env.PLAN_RESULT` byte-VALUE-pinned to `${{ needs.mutants-plan.result }}` (`PINNED_MUTANTS_AGGREGATE_PLAN_RESULT_LINE`) — retires the last declined env-value pin for this key; guards the Step-0.5 `PLAN_RESULT != "success"` wiring against a hardcoded `"success"` decoy (**structural; mirrors VP-026/027's shape**) | INV-AGG env-wiring integrity / Step-0.5 interlock (§6.8 MIRRORED M2-n row / item 27, LOW-1) | round-9 |

---

## 1. Substitution note (consistent with prior cycles)

**Kani, cargo-fuzz, and proptest do NOT apply to any VP in this delta — this is
by construction, not an omission.** These thirty invariants are properties of a
GitHub Actions workflow topology (`ci.yml`), a bash aggregation script
(`scripts/mutants-aggregate.sh`, extracted round-3), a shared bash library
(`scripts/lib/trusted-jq.sh`, extracted round-7), a bash self-test harness
(`scripts/check-ci-gate.sh`), and structural pins parsed from YAML or scanned
as script text — there is **no `src/` Rust function under test**, so:

- **Kani** (bounded model checking of Rust) — N/A: no Rust function, no
  arithmetic-overflow / array-bounds / state-machine invariant in product code.
- **cargo-fuzz** — N/A: no Rust entry point takes untrusted bytes here; the
  "input" is CI-produced `outcomes.json` files and per-shard status sentinels
  whose schema is guarded by the per-file jq/integer/H-1 guards INV-AGG carries
  forward plus the sentinel/data-desync defensive re-check (INV-COMPLETE Part
  C), not by fuzzing.
- **proptest** — N/A: there is no pure Rust function whose algebraic properties
  could be property-tested. (Contrast VP-COMPONENT-014's `resolve_component`
  proptest — that cycle DID have a pure Rust function; this one does not.)

These invariants are instead covered — with **explicit RED proofs** — by the
three mechanisms this repo's CI-gate history already uses and trusts:
**(a)** behavioral bash-subprocess tests over synthetic fixtures (the
`run_check_ci_gate_sh` / `check_fixture` pattern already in
`tests/ci_gate_completeness.rs` + `scripts/check-ci-gate.sh`), **(b)**
`--self-test` fixture suites with a fixed-denominator pin (the
`EXPECTED_FIXTURES` pattern in `check-ci-gate.sh`), and **(c)** Rust structural
pins parsed through `tests/common/wf.rs`'s `saphyr-parser` event-stream model.
**Coverage assessment: 0 GAP on the covered surface** — every invariant,
including every one of the three INV-COMPLETE sub-cases the sentinel redesign
introduced, has at least one mechanism with a defined RED proof that
distinguishes correct behavior from its specific false-green/false-red (§3, §3A,
§5). **There is exactly ONE KNOWN-uncovered condition — the common-mode
`MUTANT_COUNT==0` shared-`mutants-diff-file` residual (§5A) — and it is recorded
as an explicit Documented Residual, NOT as a GAP.** The distinction is
deliberate and load-bearing: a GAP is a coverable invariant left without a RED
proof (there are none here); a Documented Residual is a condition that is
STRUCTURALLY uncoverable by this pipeline's own signals (both derivations trust
the identical diff bytes), whose only backstop is the nightly full-scope run,
and which is explicitly flagged for F5/F6 re-examination rather than
implied-closed. §5A states it plainly so no downstream phase mistakes silence
for coverage.

---

## 2. Testability precondition (F4 obligation — the one genuinely new verification-design decision)

The invariants doc (`mutants-sharding-invariants.md §INV-AGG Guard-test`,
`§INV-COMPLETE Guard-tests`) requires the INV-AGG/INV-COMPLETE/INV-ESCALATE
guard-tests to "mirror `check-ci-gate.sh`'s `check_fixture` pattern, adapted to
jq/bash arithmetic over multiple files" and to "assert the aggregator FAILS
(exit 1 …)". A test that asserts a program's exit code **must be able to execute
that program**. The aggregator logic as drafted in `ci-yml-design.md §3` lives
**inline** in `mutants-aggregate`'s `run:` block — a YAML-embedded script cannot
be subprocess-invoked in isolation, so as-drafted there is nothing for a
behavioral RED proof to run against. The round-1 redesign makes this MORE
acute, not less: the aggregator's decision logic is now a six-stage pipeline
(Step 0 push no-op → Step 0.5 plan-result → Step 1 escalate → Step 2 sentinel
presence → Step 3 per-shard interpret+fold → Step 4 reconcile → Step 5
base-ref/zero → Step 6 kill-rate), and VP-002/006/007/008/013 (plus VP-003's
escalate fixture and the round-2 Step-0.5 `PLAN_RESULT` fixture) all need to
drive DIFFERENT stages of it to distinct exits — VP-013 specifically drives
Step 5's `OVERALL_DIFF_LINES` regex guard, reachable only when `total_scored==0`
carries through Steps 2–4 first.

**Resolution (REQUIRED for the RED proofs below to be real, not aspirational):**
F4 MUST extract the aggregator's fail-closed decision logic into a standalone,
subprocess-invocable script — **`scripts/mutants-aggregate.sh`** — that
`ci.yml`'s `mutants-aggregate` job calls (a thin `run:` that invokes the script
over the two download directories), **exactly** as `ci.yml`'s `ci-gate` job
already calls `scripts/check-ci-gate.sh` rather than inlining its logic. The
script takes the two shard directories via the env inputs the design's `env:`
block declares — `STATUS_DIR`/`SHARD_DIR` (NEW round-3: the extraction surfaced
that the inline design templated these two paths via `${{ runner.temp }}` INSIDE
the bash text, a substitution that only happens within YAML fields and never
inside a file merely invoked BY one, so they must become ordinary environment
variables; the script reads them via `${STATUS_DIR:?…}`/`${SHARD_DIR:?…}`,
failing loudly if unset) — plus the scalar env inputs `EVENT_NAME`, `ESCALATED`,
`OVERALL_DIFF_LINES`, `MUTANT_COUNT`, `PLAN_RESULT` and the internal
`EXPECTED_SHARDS` literal, and resolves every reachable state to an explicit
`exit 0`/`exit 1`.

**Round-3 status: the extraction is now a NAMED, confirmed BLOCKING F2-gate
precondition, not merely a recommendation.** architecture-delta §6.2a and
ci-yml-design.md §3/§5 land it into the DESIGN (the aggregator's Steps 0–6 become
an `evaluate_mutants_aggregate()` function with every `exit N` → `return N`, a
`main "$@"` dispatcher, a `--self-test` fixture harness carrying
`EXPECTED_MUTANTS_AGG_FIXTURES`, and a new `spec-guard` step
`run: bash scripts/mutants-aggregate.sh --self-test`). VP-014/015/016 below
formalize the runtime, input-wiring, and CI-invocation halves of that landing;
F4 still writes the bodies, F6 hardens.

- **Why not keep it inline + duplicate the arithmetic in a fixture?** REJECTED
  for the SAME reason this repo's own CI-gate history rejects it: a fixture that
  re-implements the arithmetic tests the fixture, not the shipped logic — the
  "tested tree ≠ merged tree" hazard already documented in CLAUDE.md. A RED
  proof against a duplicate is a RED proof against nothing that ships.
- The extracted script SHOULD carry its own `--self-test` and an
  `EXPECTED_MUTANTS_AGG_FIXTURES` fixed-denominator pin (mirroring
  `check-ci-gate.sh`'s `EXPECTED_FIXTURES=14`), so a silently-deleted fixture
  fails loudly — the round-10 fixture-count-pin precedent in CLAUDE.md.
- **Sentinel-fixture construction obligation (new, round-1):** the behavioral
  tests must build BOTH artifact trees the aggregator downloads — the
  per-index status-sentinel files (`.../mutants-shard-status-<k>/shard-status-<k>.json`
  carrying `{shard_index, run_outcome, has_outcomes}`) AND, only for shards whose
  sentinel claims `has_outcomes=true`, the corresponding
  `.../mutants-shard-outcomes-<k>/outcomes.json`. Getting the directory shape
  wrong would make a fixture pass/fail for the wrong reason; F4 must mirror
  `ci-yml-design.md §3`'s exact glob/subdir layout.

This is a verification-design requirement (testability), squarely in F2 Step 4's
remit; it does not change the invariant SEMANTICS the architect specified, only
where the logic physically lives so the RED proofs are executed against the real
thing. **F2-gate note:** if the human declines the extraction, INV-AGG /
INV-COMPLETE / INV-ESCALATE degrade from behavioral RED proofs to
duplicated-arithmetic fixtures (materially weaker; flagged here, not hidden).

---

## 3. The thirty verification properties

Notation for RED proofs below: a "mutant" is a one-line adversarial edit to the
aggregator or `ci.yml`; the test is **trustworthy iff it is RED (fails) against
that mutant and GREEN against the correct logic**. Where a RED proof needs a
mutated `ci.yml`, it is produced against a **temporary, untracked copy** (the
tracked file is never modified — the S-CIGATE-3 "temp-ci.yml RED proof"
precedent). Where a RED proof needs a mutated aggregator, it is produced against
a **temporary copy of `scripts/mutants-aggregate.sh`** (never the tracked
script), same precedent.

### VP-MUTANTS-SHARD-001 — Pooled-sum kill-rate contract (INV-AGG)

**Property.** `scripts/mutants-aggregate.sh` computes exactly ONE pooled kill
rate from the SUM of raw outcome counts across every shard's `outcomes.json`
(`kill_rate = caught_total*100 / (caught_total+missed_total+timeout_total)`,
integer division, multiply-first). It NEVER computes or averages a per-shard
percentage. The gate passes iff `killable == 0` or `kill_rate >= 90`. The six
INV-AGG per-file sub-guards (malformed-JSON, integer-validation, H-1
schema-drift, M-2 reconciliation warning, timeouts-count-as-survived,
unviable-excluded) are applied per shard file BEFORE summing, unchanged from the
single-job design. (Sub-invariant 8, the pooled↔pre-count reconciliation, is a
SEPARATE property — VP-008.)

**Mechanism.** Behavioral bash-subprocess test — a `#[cfg(unix)]` test in
`tests/ci_gate_completeness.rs` (architect's test T1,
`test_mutants_aggregate_sums_not_averages_shard_kill_rates`) that builds
synthetic per-shard status sentinels (all `run_outcome=success`,
`has_outcomes=true`) plus their `outcomes.json` files in a `TempDir` and invokes
`scripts/mutants-aggregate.sh`, asserting exit code + pooled-`kill_rate`
log substring. Kani/proptest N/A (§1).

**Concrete assertion (two fixtures, straddling the 90% line in OPPOSITE
directions — a one-directional fixture cannot distinguish sum from average).
Both fixtures set `MUTANT_COUNT` to the pooled total so VP-008's reconciliation
passes and does not mask this VP's own signal:**
- **Fixture 1A (average PASSES, pooled FAILS):** Shard 0 `caught=1, missed=0`
  (1 mutant, 100%); shard 1 `caught=80, missed=20` (100 mutants, 80%); shards
  2–7 sentinel `success`/`has_outcomes=false` (0 mutants each). `MUTANT_COUNT=101`.
  Naive average of the two non-empty shard rates = (100+80)/2 = **90% → would
  PASS under averaging**. Correct pooled = (1+80)/(1+100) = 81/101 = **80% →
  FAILS**. Assert: exit **1**, log contains `80%` and the "below the 90% target"
  FAIL line.
- **Fixture 1B (average FAILS, pooled PASSES):** Shard 0 `caught=1, missed=1`
  (2 mutants, 50%); shard 1 `caught=98, missed=2` (100 mutants, 98%); shards
  2–7 empty. `MUTANT_COUNT=102`. Naive average = (50+98)/2 = **74% → would FAIL
  under averaging**. Correct pooled = (1+98)/(2+100) = 99/102 = **97% →
  PASSES**. Assert: exit **0**, log contains `97%` and the "passed" OK line.

**RED proof.** Against a mutant that replaces the pooled computation with a
per-shard-percentage average (`(rate_0 + rate_1)/2`): Fixture 1A goes GREEN
(exit 0) under the mutant but MUST be RED (the test asserts exit 1) → the mutant
is caught. Fixture 1B goes RED (exit 1) under the mutant but MUST be GREEN → the
mutant is caught from the other side. The two fixtures together make sum and
average **provably distinguishable in both directions**, so no averaging
implementation — nor any threshold-on-averages variant — can survive. (Fixture
1A alone is the primary "false-green" guard: an averaging bug that silently
passes an 80%-pooled PR.)

---

### VP-MUTANTS-SHARD-002 — Missing/duplicate SENTINEL fail-closed (INV-COMPLETE Part B)

**Property.** Before any per-shard interpretation or pooled arithmetic,
`scripts/mutants-aggregate.sh` asserts (INV-COMPLETE **Part B**) that a status
SENTINEL is present for ALL `EXPECTED_SHARDS` declared shards, one per index
`{0..EXPECTED_SHARDS-1}`. It fails CLOSED (exit 1) naming the specific missing
index if the by-index presence loop finds a gap, AND fails closed on a count
mismatch (`actual_sentinel_count != EXPECTED_SHARDS`, catching a phantom EXTRA/
stray/duplicate too, not just a shortfall). **This is now the SOLE fail-closed
completeness gate and it reasons over the STATUS SENTINELS, not over
`outcomes.json` presence** (the round-1 redesign — the pre-fix `outcomes.json`-
count proxy is what CRIT-1 exploited; see VP-006). A missing sentinel is the
one signal only a dead/cancelled/never-scheduled runner (or a bug in the
always-run sentinel-write step itself) can produce — the "infra-cancel" INV-
COMPLETE sub-case (§3A row 1).

**Mechanism.** Behavioral bash-subprocess — two `#[cfg(unix)]` tests in
`tests/ci_gate_completeness.rs` (architect tests T2 + T3): T2
`test_mutants_aggregate_fails_closed_on_missing_shard`, T3
`test_mutants_aggregate_fails_closed_on_duplicate_shard_artifact`. **(Round-1:
both fixtures now operate on SENTINEL artifacts, not `outcomes.json`.)**
Kani/proptest N/A (§1).

**Concrete assertion.**
- **T2 (shortfall, mid-range index):** populate 7 of 8 status sentinels,
  **omitting the sentinel for shard index 3** (a mid-range index, not boundary
  0 or 7 — proves the check is not accidentally anchored to an edge). Construct
  the 7 PRESENT sentinels as healthy (`success`/`has_outcomes=true`) with
  `outcomes.json` pooling ≥90% and `MUTANT_COUNT` matching that pool, so the
  ONLY thing wrong is the missing sentinel. Assert: exit **1**, log names shard
  `3` as the missing index, and "Expected exactly 8 … found 7".
- **T3 (surplus/duplicate):** populate 9 status sentinels (a duplicate/stray,
  e.g. an extra `mutants-shard-status-3` subdir from a stale re-run). Assert:
  exit **1**, log names "expected exactly 8" / "duplicate or stray artifact".

**RED proof.**
- **T2** must be RED against a "missing sentinel → treat that shard as an empty
  zero-contribution shard and continue" mutant: because the 7 present sentinels
  are deliberately healthy (≥90% pooled) and reconcile against `MUTANT_COUNT`,
  such a mutant would compute a passing pooled rate over 7 shards and **exit 0
  (the exact false-green: a crashed/never-scheduled shard's unverified mutants
  silently excluded)**. The correct Part-B fail-closed logic exits 1 naming
  shard 3. The healthy-7 construction is what makes the two outcomes diverge — a
  low-rate-7 fixture could not distinguish "fail-closed on absence" from "failed
  on kill-rate".
- **T3** must be RED against a mutant that weakens the exact count check to a
  shortfall-only `-lt`/`<` (i.e. "≥ expected is fine") AND drops the by-index
  loop: 9 present satisfies `9 >= 8`, so the mutant proceeds and **exits 0**,
  while correct logic exits 1. Distinguishes the exact `!=`/`-ne` count check
  from a `<` — the specific over-count false-green (a stale re-run leaving a
  duplicate silently accepted).

---

### VP-MUTANTS-SHARD-003 — Escalation is an ordinary `failure`, never a silent pass/skip (INV-ESCALATE)

**Property.** When `mutants-plan` reports `escalated == 'true'` (in-diff
pre-count > `ESCALATION_THRESHOLD`, ~120), `scripts/mutants-aggregate.sh`
detects it as **Step 1** (after the Step 0 push-event no-op and the Step 0.5
`PLAN_RESULT != success` diagnostics short-circuit, but BEFORE any shard-sentinel
inspection) and **exits 1** with the actionable two-ways-forward message.
Escalation is encoded as an ordinary `failure` — never GitHub-Actions `skipped`,
never `success` — so `ci-gate` blocks the PR through `check-ci-gate.sh`'s
ordinary `failure` branch with ZERO `ALLOWED_SKIPS` involvement. The only merge
path for an escalated PR is GitHub's pre-existing, separately-audited
branch-protection admin bypass (the same channel policy §F-2 already prescribes
for a `cancelled` run) — no new CI mechanism, no new `evaluate_needs()` code
path.

**Mechanism.** Behavioral bash-subprocess. Per §4, the architect's fixed +10
does NOT allocate a dedicated Rust `#[test]` slot to INV-ESCALATE; its RED proof
therefore rides the SAME aggregator-subprocess harness as VP-001, as a
**distinct fixture case co-located in T1's harness** (and, if
`scripts/mutants-aggregate.sh` carries a `--self-test`, ALSO as a fixture there,
counted by `EXPECTED_MUTANTS_AGG_FIXTURES`, not by `EXPECTED_GUARD_TEST_COUNT`).
See §4 for the count bookkeeping. Kani/proptest N/A (§1).

**Concrete assertion (the fixture must isolate escalation from missing-shards
AND from a failed plan job — otherwise Step 0.5 or Step 2 would catch it first
and the test would not actually exercise INV-ESCALATE's Step 1):** invoke the
aggregator with `ESCALATED=true`, `EVENT_NAME=pull_request`,
`PLAN_RESULT=success`, **AND a FULL, HEALTHY set of all 8 status sentinels
(`success`/`has_outcomes=true`) whose `outcomes.json` pool ≥90% and reconcile
against `MUTANT_COUNT`** (e.g. every shard `caught=9, missed=1`,
`MUTANT_COUNT=80`). Assert: exit **1**; log contains the escalation FAIL line
(`"over the 120-mutant threshold"`) and the branch-protection-bypass guidance;
log does **NOT** contain the kill-rate "passed" OK line (proving Step 1
short-circuited BEFORE Step 6's summation ran).

**RED proof.** Against a mutant that removes the Step-1 escalation check (or
mis-compares the STRING `'true'`, e.g. bare truthy `if [ "$ESCALATED" ]`, which
is truthy even for the string `'false'` — INV-ESCALATE Residual Risk 2): the
aggregator falls through Step 0.5 (plan succeeded), Step 2 (all sentinels
present), Step 3 (all healthy), Step 4 (reconciles), Step 5 (non-zero), and Step
6 (≥90%), and **exits 0 — the exact false-green the task names: an escalated
(>120) pre-count silently treated as a merge-pass**. The correct logic exits 1
at Step 1. The healthy-full-shard-set construction is what forces this
divergence — with no/few sentinels, Step 2's exit-1 would mask a broken
escalation check and the test would falsely pass against the mutant. A second,
cheaper reinforcing fixture (`ESCALATED=true` + healthy shards, asserting the
escalation message *precedes*/replaces the OK message) pins the
Step-1-BEFORE-Step-6 **precedence** specifically. **Note the interaction with
VP-010:** VP-003 proves the aggregator ACTS correctly when `ESCALATED=true`
reaches it; VP-010 separately proves that value is actually WIRED to reach it
(a mistyped env key would make `ESCALATED` empty, silently disabling this
branch — the two VPs guard different halves of the same mechanism).

---

### VP-MUTANTS-SHARD-004 — `mutants-plan` job structural pin (architect §6.2 test 4)

**Property.** `ci.yml` declares a job `mutants-plan` that (a) carries a
job-level `if:` whose normalized value is EXACTLY `github.event_name ==
'pull_request'`, and (b) is a member of `PINNED_GATE_EXCLUDED_JOBS` and NOT a
member of `ci-gate.needs` (it is a helper job, never a required gate). This
mirrors the dedicated existence/PR-only pin the OLD single `mutants` job carried
before this cycle.

**Mechanism.** Rust structural pin parsed through `tests/common/wf.rs`
(`saphyr-parser` event stream) — architect's test T4,
`test_mutants_plan_job_exists_and_is_pr_only`, in
`tests/ci_gate_completeness.rs`. Reads the `mutants-plan` job block, extracts
its job-level `if:` via the EXISTING `extract_and_normalize_if_expr` (exact
plain-scalar equality, `ScalarStyle::Plain` asserted), and cross-checks
membership against `PINNED_GATE_EXCLUDED_JOBS` and `ci-gate.needs`. No new
`wf.rs` primitive (architecture-delta §6.3 confirms zero `wf.rs` changes).
Kani/proptest/fuzz N/A (§1).

**Concrete assertion.** `mutants-plan` job block exists;
`extract_and_normalize_if_expr(mutants_plan_block) == "github.event_name ==
'pull_request'"`; `PINNED_GATE_EXCLUDED_JOBS` contains `"mutants-plan"`;
`ci_gate_needs` does NOT contain `"mutants-plan"`. (The partition test
`test_ci_gate_needs_partitions_all_ci_yml_jobs` independently requires every
`ci.yml` job to be in exactly one of `ci-gate.needs` / `PINNED_GATE_EXCLUDED_JOBS`
— this VP asserts `mutants-plan` lands on the excluded side.)

**RED proof** (against a temporary, untracked mutated `ci.yml`):
- Remove `mutants-plan`'s `if:` key → exact-value extraction yields absence →
  test RED. Distinguishes "PR-only" from "runs on every event" (a `mutants-plan`
  that runs on push would compute a diff/pre-count on a non-PR event).
- Change the `if:` to any other expression (e.g. `always()` or a different
  event) → exact-equality RED. Distinguishes the pinned expression from a
  look-alike.
- Add `mutants-plan` to `ci-gate.needs` (making it a required gate) WITHOUT
  removing it from `PINNED_GATE_EXCLUDED_JOBS` → the partition test's
  "in-both" branch RED; removing it from excluded and NOT adding to needs →
  this VP's membership assertion RED. Either mis-wiring is caught.

---

### VP-MUTANTS-SHARD-005 — `EXPECTED_SHARDS` ⇔ `matrix.shard` cross-check (architect §6.2 test 5)

**Property.** The shard count is declared in exactly ONE place — the `mutants`
job's `strategy.matrix.shard` sequence — and the aggregator's own
`EXPECTED_SHARDS` denominator literal MUST equal that sequence's length. The two
independently-typed numbers are asserted equal so that widening the matrix (e.g.
to 10 shards) without updating `EXPECTED_SHARDS` (or vice-versa) fails CI in the
same commit, rather than silently leaving the extra shards permanently unchecked.

**Mechanism.** Rust structural cross-check — architect's test T5,
`test_mutants_aggregate_expected_shards_matches_matrix_shard_count`, in
`tests/ci_gate_completeness.rs`. Reads `mutants`'s `strategy.matrix.shard`
sequence length via the EXISTING generic `common::wf::job_level_nested_sequence_items(block,
&["strategy","matrix","shard"])` (the SAME path-based accessor
`test_matrix_os_lists_remain_static_literals` uses for `strategy.matrix.os` —
architecture-delta §6.3 confirms it is not `os`-special-cased, so `["strategy",
"matrix","shard"]` needs zero new `wf.rs` code) AND independently extracts the
`EXPECTED_SHARDS=<int>` literal from the aggregator host (per §2, from
`scripts/mutants-aggregate.sh`; if the human declines extraction, from
`mutants-aggregate`'s inline `run:` text via the existing `Step::value_of("run")`
accessor — a small local substring/regex helper, NOT a new `wf.rs` primitive).
Asserts the two integers are equal. Kani/proptest/fuzz N/A (§1).

**Concrete assertion.** `len(matrix.shard) == parse_int(EXPECTED_SHARDS literal)`;
both currently `8`. (A one-line comment at `PINNED_MATRIX_NEEDS_MEMBER_COUNT`
per architecture-delta §6.2 records that that separate const stays `2` — the
shard job is not a `ci-gate.needs` member — a verified non-change, not this VP's
subject.)

**RED proof** (against a temporary, untracked mutated `ci.yml`/script):
- Widen `matrix.shard` to `[0..9]` (length 10) while leaving `EXPECTED_SHARDS=8`
  → `10 != 8` → test RED. This is the exact false-green the F1 delta analysis
  Risk #2 named one level deeper than INV-COMPLETE: not "a shard artifact goes
  missing at runtime" (INV-COMPLETE), but "the matrix is widened and the
  aggregator's denominator is forgotten, so shards 8 and 9 are **permanently,
  silently unchecked forever**" — at runtime `actual_sentinel_count` would be
  10, but Part B's own count check uses `EXPECTED_SHARDS=8`, so 10≠8 would in
  fact fail-closed at runtime too; this static cross-check catches the drift at
  PR-review time with a clear "update both in the same commit" message rather
  than as a confusing every-PR runtime red.
- Conversely, set `EXPECTED_SHARDS=10` while `matrix.shard` stays length 8 →
  `8 != 10` → RED. Distinguishes an aggregator that over-counts the denominator
  (which at runtime would demand 10 sentinels from an 8-way matrix and fail
  every PR) — caught statically here.

---

### VP-MUTANTS-SHARD-006 — All-shards-crash fail-closed (INV-COMPLETE Part C, harness-crash arm) — **CRIT-1 regression / the HIGH-2 was-missing VP**

**Property.** When all `EXPECTED_SHARDS` status sentinels ARE present (Part B
passes) but every present sentinel reports `run_outcome != success` AND
`has_outcomes == false`, `scripts/mutants-aggregate.sh` fails CLOSED (exit 1) at
INV-COMPLETE **Part C**, naming a shard index and identifying a harness crash.
It MUST NOT reach any downstream "0 mutants scored + non-empty diff ⇒ exit 0"
path (Step 5) — a genuine crash of every shard's `run-mutants` step, masked at
the job level by `continue-on-error: true`, must never resolve to a GREEN gate
with zero mutation coverage verified. This is the "harness-crash" INV-COMPLETE
sub-case (§3A row 2).

**Mechanism.** Behavioral bash-subprocess — a NEW `#[cfg(unix)]` test in
`tests/ci_gate_completeness.rs` (round-1 test #1,
`test_mutants_aggregate_fails_closed_when_all_shards_crash_under_continue_on_error`).
Builds all 8 status sentinels each `{run_outcome:"failure", has_outcomes:false}`,
NO `outcomes.json` files, invokes the aggregator with `EVENT_NAME=pull_request`,
`PLAN_RESULT=success`, `ESCALATED=false`, `OVERALL_DIFF_LINES` non-zero,
`MUTANT_COUNT` non-zero (e.g. `40`). Asserts exit code + harness-crash log
substring. Kani/proptest N/A (§1).

**Concrete assertion.** Exit **1**; log names shard `0` (the first-iterated
failing shard) and contains the harness-crash message (`"did not complete
successfully"` / `"harness crash"`); log does **NOT** contain any OK/pass line
(neither the Step-5 "0 mutants scored … non-empty diff" OK line nor the Step-6
"gate passed" line).

**RED proof (explicit — this is the HIGH-2 false-green the adversary said was
missing a VP).** Construct the mutant the task names precisely: a
`mutants-aggregate.sh` variant that reintroduces the **pre-fix count-based
branch** — completeness derived from the number of `outcomes.json` files that
materialized, with the rule *"0 outcomes.json artifacts + non-empty
`OVERALL_DIFF_LINES` ⇒ `exit 0`"* inserted ahead of the sentinel logic (exactly
the `#shard_json_files -eq 0 -> non-empty-diff -> exit 0` branch the round-1 fix
deleted). Under this mutant, the all-crash fixture (zero `outcomes.json` files,
non-empty diff) hits that branch and **exits 0 — GREEN — a false-green
verifying zero mutants**. The correct sentinel-based Part C exits **1** at shard
0 (`run_outcome=failure`, `has_outcomes=false`). Because the test asserts exit
1, it is **RED against the mutant and GREEN against the correct logic** — the
distinguishing proof. The all-8-`failure` + non-empty-diff construction is
load-bearing: it is the ONE shard-outcome shape under which the deleted
count-based branch and the sentinel-based branch DISAGREE (a partial crash, or a
crash on an empty diff, would not reach that specific false-green branch), so
only this construction proves the specific CRIT-1 regression is closed. Second
reinforcing mutant: a Part-C variant that keys the harness-crash decision on
`.conclusion` instead of `.outcome` — since `continue-on-error: true` forces
`.conclusion == success`, a `.conclusion`-keyed check would read every crashed
shard as "success/empty" and fall through to a pass; a fixture whose sentinels
carry `run_outcome:"failure"` (the truthful `.outcome`) exits 1 under correct
logic but 0 under the `.conclusion` mutant → RED, pinning the
`outcome`-not-`conclusion` load-bearing detail.

---

### VP-MUTANTS-SHARD-007 — Legitimately-empty shards PASS (INV-COMPLETE Part C, legit-empty arm) — HIGH-1 regression

**Property.** When status sentinels are all present (Part B passes) and SOME
report `run_outcome == success` AND `has_outcomes == false` (a legitimate
empty-`--sharding slice` shard on a small PR — contributes 0 to every pooled
counter), while the remaining shards report real data whose pooled sum
reconciles against `MUTANT_COUNT` at ≥90%, `scripts/mutants-aggregate.sh` exits
**0** and never names any shard as missing or failed. This is the "legit-empty"
INV-COMPLETE sub-case (§3A row 3) — the false-RED the round-1 redesign had to
avoid while closing CRIT-1.

**Mechanism.** Behavioral bash-subprocess — a NEW `#[cfg(unix)]` test in
`tests/ci_gate_completeness.rs` (round-1 test #2,
`test_mutants_aggregate_ok_when_shards_are_legitimately_empty`). Builds 3
sentinels `{run_outcome:"success", has_outcomes:false}` (no `outcomes.json`) and
5 sentinels `{run_outcome:"success", has_outcomes:true}` with `outcomes.json`
pooling to a healthy rate; `MUTANT_COUNT` set to the pooled `total_scored`.
Kani/proptest N/A (§1).

**Concrete assertion.** 5 data shards each `caught=9, missed=1` → pooled
`caught_total=45, missed_total=5`, `total_scored=50`, `MUTANT_COUNT=50`, pooled
kill rate 45/50 = 90%. Exit **0**; log shows "contributes 0" (or equivalent) for
the 3 empty shards; log contains the Step-6 pass line; log does **NOT** contain
"FAIL", does NOT name any shard as missing, does NOT name any shard as a crash.

**RED proof.** Against a mutant that treats `has_outcomes == false` as a FAIL
**regardless of** `run_outcome` (i.e. the pre-fix "no outcomes.json ⇒ fail
closed" behavior that could not tell an empty slice from a crash): the 3
legitimately-empty shards → **exit 1 (the exact false-red HIGH-1: routine small
PRs blocked)**. The correct Part-C logic distinguishes on `run_outcome` and
exits 0. The test asserts exit 0 → **RED against the mutant, GREEN against
correct logic**. Paired with VP-006, this pins the `run_outcome` discrimination
in BOTH directions: VP-006 proves `has_outcomes=false ∧ run_outcome=failure ⇒
FAIL`, VP-007 proves `has_outcomes=false ∧ run_outcome=success ⇒ OK-zero` — a
mutant that ignores `run_outcome` and collapses both `has_outcomes=false` cases
to one verdict is caught by exactly one of the two VPs whichever verdict it
picks.

---

### VP-MUTANTS-SHARD-008 — Pooled-total ⇔ `MUTANT_COUNT` reconciliation, HARD FAIL / fail-closed (INV-AGG sub-invariant 8, ROUND-5 RESTORED to round-1 original)

**Round-5 reversal (MEDIUM, false-GREEN risk in round-4's own rollout policy)
— read this FIRST; it REVERTS VP-008's ASSERTION back to the round-1 original.**
Rounds 1–3 specified this reconciliation as a HARD FAIL (`exit 1` on mismatch).
Round-4 downgraded it to a NON-BLOCKING `::warning::` for an initial rollout
(Option A), reasoning that the `--list` ⇔ pooled `--shard --sharding slice`
lossless-partition premise was empirically unverified and a hard fail on a wrong
premise would brick every PR at once. **Round-5's fresh-context F2 adversary
identified round-4's warning-only policy itself as a new false-green: it disables
the ONLY guard this cycle has for "mutants silently vanish between plan and shard
execution." If the vanished mutants happen to be SURVIVORS (would have scored
`missed`), the pooled kill rate on the smaller, incomplete scored set can read
`>=90%` while the true complete set would not — a false-green on the primary gate
this entire cycle exists to protect, introduced by the very sub-invariant meant
to catch it.** Round-5 therefore RESTORES the hard fail (round-4's own documented,
never-chosen Option B), unconditionally, effective on cycle-006's own landing PR
— NOT gated behind a rollout window or a tighten-trigger. For a security-relevant
fail-closed gate, failing LOUD on an unverified premise is the correct default:
the false-RED cost (a PR blocked pending investigation) is bounded and visible;
round-4's false-green cost (a dropped survivor silently passing) is unbounded and
invisible. This repo's own principle applies without modification — "for a
fail-closed security gate, fail LOUD is correct; silent acceptance is not."
mutants-sharding-invariants.md §INV-AGG sub-invariant 8 round-5 callout /
architecture-delta §6.10 carry the full reversal rationale.

**Exact equality, BOTH directions (round-5, retained not narrowed).** The
comparison fails on both `total_scored < MUTANT_COUNT` (the dangerous
dropped-mutant direction — a survivor could be among the missing) AND
`total_scored > MUTANT_COUNT` (an over-count — the shard matrix examined more
than the plan counted as in-scope, itself an instance of the same examined≠planned
defect class). A directional `>=`-only check was considered and rejected: rounds
1–3 already validated the exact-equality arithmetic across three passes, round-4's
concern was rollout blast radius (never the `>` direction specifically), and an
over-count is not obviously safe to wave through. VP-022 is the dedicated
over-count-direction proof.

**The empirical premise is handled by a mandatory, BLOCKING F4 scratch-run
BEFORE cycle-006 merges (round-6), NOT waved away.** Restoring the hard fail
does not resolve the unverified `--list`⇔pooled partition premise; the PRIMARY
verification (round-6) is a MANDATORY, BLOCKING scratch-run task F4 MUST perform
BEFORE cycle-006's own PR merges: run `cargo mutants --list --in-diff <diff>` and
the eight `--shard k/8 --sharding slice --baseline skip` runs against a
known-nonzero diff, confirm exact reconciliation, and root-cause any mismatch as
either a tooling-surface artifact (e.g. a header/blank line to strip in
mutants-plan) or a counting-convention adjustment (encode in
`scripts/mutants-aggregate.sh`) — NEVER re-widen to warning-only. Inspecting
cargo-mutants' own `--sharding`/`--baseline skip`/unviable-counting semantics
supports that root-causing. **Cycle-006's own landing PR cannot supply this
evidence — it is CI/doc-only, ~0 `src/` mutants, so it exercises only the trivial
`MUTANT_COUNT == 0` reconciliation path (both sides trivially agree at zero);
that is exactly why the scratch-run, not the landing PR, is the primary
verification.** **PR #778** (281 mutants) is a CONFIRMING, production-scale
exercise of a nonzero reconciliation layered ON TOP OF the scratch-run — NOT the
first or sole verification. Because the hard fail is in force, if PR #778 later
trips reconciliation, that is correct, intended, fail-closed behavior, not a risk
to engineer around: a human MUST root-cause it before merging — either (a) a
genuine dropped-mutant defect (fix the underlying cause), or (b) a
counting-convention discrepancy in the premise (e.g. `--list` and the pooled run
enumerate `unviable` differently, or a small explainable `--baseline skip`
offset), in which case F4/F5 encode the CORRECT reconciliation relationship into
`scripts/mutants-aggregate.sh` as a documented, reasoned adjustment — NEVER
silently suppress or re-widen to warning-only as a shortcut. This is an
explicitly-flagged, F4-gated residual (§5A tail), NOT a rollout/tighten window,
and a peer to the §5A common-mode residual and the §6.10 mutants-plan residual.
The existing admin branch-protection bypass is the documented escape valve for a
genuine emergency; no new pipeline-level override is introduced.

**Property.** After per-shard folding completes (Part C), before the base-ref/
zero check and kill-rate,`scripts/mutants-aggregate.sh` computes
`total_scored = caught_total + missed_total + timeout_total + unviable_total`
(note: `unviable` IS included here, unlike in `killable`) and compares it against
`MUTANT_COUNT` — `mutants-plan`'s independent `cargo mutants --list --in-diff |
wc -l` pre-count, threaded via `needs.mutants-plan.outputs.mutant_count`. **On any
mismatch (`total_scored != MUTANT_COUNT`, exact equality, both directions) it
emits a diagnostic naming both numbers and `return 1` — the whole aggregation
FAILS CLOSED on this condition alone; it does NOT fall through to Step 5/6.**
Sub-invariant 6 (per-shard `total_mutants` reconciliation) remains `::warning::`-only
for a different, permanent reason (a forward-compatible new outcome-category name
— a schema question), and is unaffected by this VP. This is a CROSS-JOB
COMPLETENESS check: it catches the "mutants silently go missing between planning
and shard execution" class that is structurally invisible to Part B's presence
check (a shard that ran against a stale/different diff still uploads a present,
well-formed sentinel + `outcomes.json`). Because Step 6 is now UNREACHABLE
whenever sub-invariant 8 fails, an incomplete/unreconciled mutant set is never
allowed to reach the kill-rate decision at all — a strictly stronger guarantee
than round-4's "the two signals can disagree and the gate still decides
correctly."

**Down-scoped claim (round-2, MEDIUM-2 — do NOT over-state this VP's reach).**
Reconciliation catches **per-shard PLAN↔EXECUTION divergence only**. It
structurally CANNOT catch a **common-mode** error in the single shared
`mutants-diff-file` artifact: both `MUTANT_COUNT` (`mutants-plan`'s `--list
--in-diff "$DIFF_FILE"`) and every shard's `--shard k/8 --in-diff "$DIFF_FILE"`
derive from the IDENTICAL bytes, so a wrong-at-source diff makes both
derivations agree exactly, reconcile cleanly (`total_scored == MUTANT_COUNT`,
possibly both `0`), and pass GREEN having verified zero mutants outside the
wrong scope. That is a genuine, accepted residual false-green — recorded as
**§5A (Documented residual)**, backstopped only by the nightly full run, and it
is NOT what this VP proves. What IS additionally closed this round is the
adjacent TOOLING-ERROR half: `mutants-plan`'s `--list` step no longer swallows
its own non-zero exit into a silently-wrong `MUTANT_COUNT=0` (ci-yml-design.md
§1) — a genuine `--list` failure now fails the `mutants-plan` job closed, which
routes into the aggregator's Step 0.5 `PLAN_RESULT != "success"` short-circuit
(covered as a co-located fixture — see §4's coverage note). This VP's own
fixture assumes a well-formed, tool-successful pre-count and a shard set that
genuinely diverges from it — the class it proves, at zero false-negative rate
for THAT class.

**Mechanism.** Behavioral bash-subprocess — a `#[cfg(unix)]` test in
`tests/ci_gate_completeness.rs`, name RESTORED round-5 to the round-1 original
`test_mutants_aggregate_fails_closed_on_mutant_count_reconciliation_mismatch`
(round-4 had renamed it to
`..._reconciliation_mismatch_emits_non_blocking_warning` and inverted its body;
round-5 reverts BOTH — "fails_closed" is once again an accurate description, so
under this repo's own test-naming convention the revert is a correction, not
style churn). Builds 8 healthy sentinels (`success`/`has_outcomes=true`) whose
pooled `total_scored` deliberately differs from the supplied `MUTANT_COUNT` by
exactly one, with the scored mutants' `caught`/`missed`/`timeout` split
constructed to yield a pooled kill rate `>=90%` (deliberately healthy-looking, so
a fail cannot be attributed to a coincidentally-low kill rate — the mismatch is
the ONLY anomaly, and it MUST fail closed). Kani/proptest N/A (§1).

**Concrete assertion.** 8 shards pooling `caught_total=95, missed_total=5,
timeout_total=0, unviable_total=0` → `total_scored=100`; `MUTANT_COUNT=101` (one
mutant "went missing" between plan and shard execution). The pooled kill rate on
the PARTIAL scored set is 95/100 = 95% (`>=90`) — deliberately healthy-looking.
Assert: the aggregator's stdout names both `101` and `100` (the reconciliation-
mismatch text), AND the aggregator exits **1** (HARD FAIL — round-5 restored),
AND stdout does **NOT** contain the Step-6 "gate passed" success line (proving the
aggregation short-circuited at Step 4 BEFORE Step 6's summation ran). This is the
exact fixture VP-023 reuses as its own dedicated regression pin against ever
re-introducing round-4's warning-only behavior; VP-008 and VP-023 share this
fixture by construction (defense-in-depth, not oversight).

**RED proof.** Against the mutant that drops the reconciliation `return 1`
(reverting to round-4's warn-and-continue, or otherwise letting Step 4 fall
through to Steps 5/6 on a mismatch): the fixture's dropped-survivor set produces a
healthy-looking 95% pooled rate on the incomplete scored set and **exits 0 —
GREEN — the exact false-green round-5 exists to close: a dropped survivor silently
passing because the remaining, smaller scored subset reads `>=90%`**. The correct
hard-fail logic exits **1** at Step 4. Because the test asserts exit 1 AND the
mismatch message AND the ABSENCE of the pass line, it is RED against the
drop-`return-1` mutant (wrong exit + pass line present) and against a mutant that
drops the diagnostic entirely (a silent mismatch — both numbers would be absent),
and GREEN only against the correct fail-closed-naming-both-numbers logic. Second
reinforcing mutant: one that excludes `unviable` from `total_scored` (using
`killable` instead) — since `--list` pre-counts unviable mutants too, a fixture
with non-zero `unviable_total` and a `MUTANT_COUNT` including them would then
mismatch under the mutant (spuriously failing) where correct logic reconciles
cleanly (exit 0, no mismatch), pinning the "`unviable` participates in
`total_scored`" detail. **Note the exact-equality symmetry (VP-022) and the
completeness-over-quality inverse (VP-023):** VP-008 proves the under-count
direction fails closed at a healthy partial kill rate; VP-022 proves the
over-count direction (`total_scored > MUTANT_COUNT`) also fails closed (the check
is genuinely `!=`, not `<`-only); VP-023 reuses VP-008's exact fixture to pin, by
name, that a healthy PARTIAL kill rate never rescues a dropped-mutant mismatch —
the three together pin that completeness is required, not merely quality of what
happened to be examined, and that Step 6 is unreachable on any mismatch.

---

### VP-MUTANTS-SHARD-009 — `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS` disjoint + tautological (MED-1)

**Property.** The NEW pin category `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS`
(architecture-delta §6.4 — the sole legitimate exception to the otherwise-blanket
"no job-level `if:` on an always-run `ci-gate.needs` member" rule, currently the
single member `("mutants-aggregate", "always()")`) satisfies two structural
guards so a future entry cannot both bypass the no-`if:` rule AND fail to
actually always-run: **(a) DISJOINTNESS** — its key set is disjoint from
`SKIP_TOLERANT_NEEDS_MEMBERS`, from `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS`'s keys,
and from `check-ci-gate.sh --print-allowed-skips`'s reported set (a job cannot
be simultaneously "always-run under a pinned `if:`" AND "skip-tolerant" — those
are contradictory categories); **(b) TAUTOLOGY** — every pinned `if:` value in
the list is the exact tautology `always()`, never a compound like `always() &&
github.ref == 'x'` that would smuggle a conditional skip in under the exception
category.

**Mechanism.** Rust structural + a `#[cfg(unix)]` subprocess leg — architect's
round-1 test #4, `test_always_run_with_if_exceptions_disjoint_and_tautological`,
in `tests/ci_gate_completeness.rs`. (a) is pure in-Rust set-intersection over
the three constant lists plus, for the third disjointness target, a shell-out to
`scripts/check-ci-gate.sh --print-allowed-skips`. (b) is exact string equality
of each pinned value against the literal `"always()"`. Mirrors
`test_skip_tolerant_needs_members_matches_pinned_if_expressions`'s
sibling-list-sync discipline. Kani/proptest/fuzz N/A (§1).

**Concrete assertion.** `keys(PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS) ∩
SKIP_TOLERANT_NEEDS_MEMBERS == ∅`; `∩ keys(PINNED_ALLOWED_SKIP_IF_EXPRESSIONS)
== ∅`; `∩ print_allowed_skips_set == ∅`; and `∀ (job, expr) ∈
PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS: expr == "always()"`.

**RED proof.**
- **Disjointness** — against a mutant that adds `"mutants-aggregate"` (or any
  job) to BOTH `PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS` and
  `SKIP_TOLERANT_NEEDS_MEMBERS` (the contradictory-category ambiguity this
  guards — a job treated as always-run-with-pinned-`if:` in one place and
  skip-tolerant in another, reopening the `always()`-vs-skip ambiguity): the
  intersection is non-empty → test RED. Correct config keeps them disjoint →
  GREEN.
- **Tautology** — against a mutant that changes the pinned value from
  `"always()"` to a compound such as `"always() && github.ref ==
  'refs/heads/main'"` (which CONTAINS `always()` as a substring, so a naive
  substring check would still pass, but is NOT a tautology — it would let
  `mutants-aggregate` be SKIPPED on non-`main` branches while still being
  exempted from the no-`if:` rule): exact-equality assertion RED. Distinguishes
  the exact tautology from an `always()`-containing look-alike — the same
  substring-vs-exact class the CI-gate history's M2-a/b/c findings turned on.

---

### VP-MUTANTS-SHARD-010 — `mutants-plan.escalated` ⇒ `mutants-aggregate` `ESCALATED` env wiring pin (MED-2)

**Property.** The escalation signal is wired end-to-end with byte-exact pins on
BOTH sides so a mistyped key cannot silently disable INV-ESCALATE:
`mutants-plan`'s job-level `outputs:` mapping declares an `escalated` key whose
value is exactly `${{ steps.plan.outputs.escalated }}`, AND `mutants-aggregate`'s
"Evaluate sharded mutation gate" step's `env:` mapping binds `ESCALATED:` to
exactly `${{ needs.mutants-plan.outputs.escalated }}`. This is a
wiring-INTEGRITY pin — it protects the escalation mechanism from a silent
plumbing break in either direction.

**Framing correction (round-2, architecture-delta §6.6 LOWs — the earlier
"fail-OPEN, maximally dangerous" characterization was WRONG and is dropped).**
A mistyped/empty consumer key makes GitHub Actions resolve `ESCALATED` to the
empty string, so the aggregator's Step-1 `[ "${ESCALATED}" = "true" ]` check
never fires. The consequence on a genuinely-escalated (>120-mutant) PR is NOT
"merge unverified" / a false-green: the `mutants` shard matrix's OWN `if:`
(`needs.mutants-plan.outputs.escalated != 'true'`) reads the same broken/empty
value, so it ALSO evaluates true and the full oversized gate RUNS at `--timeout
240`/shard. That is **fail-CLOSED** — mutation coverage is still evaluated and
the PR is not silently passed — but it wastes CI minutes and re-exposes the
exact multi-hour wall-clock ceiling this whole cycle exists to avoid. So an
absent/empty-wiring bug is a fail-closed / wasted-CI defect, not a
merge-unverified one. The genuinely dangerous VALUE direction is the OPPOSITE — 
`ESCALATED` resolving to the literal string `true` when it should NOT (a
presence-of-wrong-value bug, not an absence-of-wiring bug) — which this same
byte-exact producer+consumer pin also guards, since a producer emitting the
wrong literal or a consumer bound to the wrong source expression both fail the
equality assertion. The pin therefore remains justified on wiring-integrity
grounds regardless of which direction the plumbing breaks; only its false
"fail-open" rationale is corrected.

**Mechanism.** Rust structural pin parsed through `tests/common/wf.rs`
(`saphyr-parser` event stream) — architect's round-1 test #5,
`test_mutants_plan_escalated_output_wired_to_aggregate_env`, in
`tests/ci_gate_completeness.rs`. Reads the `mutants-plan` job's `outputs:`
child mapping and the `mutants-aggregate` eval-step's `env:` child mapping via
the existing job/step nested-mapping accessors (no new `wf.rs` primitive —
architecture-delta §6.3), asserting each value byte-for-byte (plain-scalar,
`ScalarStyle::Plain`). Kani/proptest/fuzz N/A (§1).

**Concrete assertion.** `mutants-plan.outputs.escalated == "${{
steps.plan.outputs.escalated }}"`; `mutants-aggregate`'s eval-step
`env.ESCALATED == "${{ needs.mutants-plan.outputs.escalated }}"`.

**RED proof** (against a temporary, untracked mutated `ci.yml`):
- Mutate the consumer key — e.g. `ESCALATED: ${{ needs.mutants-plan.outputs.escalatd
  }}` (typo) or reference a nonexistent output name → byte-equality assertion
  RED. **The specific failure this guards (round-2 framing):** GitHub Actions
  returns an EMPTY string (not an error) for a nonexistent
  `needs.<job>.outputs.<name>` reference, so `ESCALATED=""` makes the
  aggregator's `[ "${ESCALATED}" = "true" ]` Step-1 check never fire — silently
  DISABLING escalation. As corrected above, that is fail-CLOSED / wasted-CI on a
  >120-mutant PR (the oversized gate runs instead of short-circuiting), NOT a
  false-green merge-unverified — so the pin is justified as a wiring-integrity
  guard against a silent plumbing break, not as a fail-open backstop. It earns a
  dedicated structural pin (rather than relying on VP-003's behavioral proof
  alone) because VP-003 proves the aggregator ACTS correctly on `ESCALATED=true`;
  only VP-010 proves the value is actually WIRED to arrive with its intended
  content in the first place.
- Mutate the producer side — drop `mutants-plan.outputs.escalated` or change its
  value → the producer-side byte-equality RED. Either half of the wiring being
  wrong is caught.

---

### VP-MUTANTS-SHARD-011 — Skip-tolerant surface is consistently EMPTY by design (round-2, HIGH-1 a+b)

**Property.** Cycle-006 deliberately reduces the mutation gate's skip-tolerant
surface to ZERO: `mutants-aggregate` never reports `skipped` (every reachable
internal state resolves to an explicit `exit 0`/`exit 1` — architecture-delta
§6.4), so the three lists that can each independently represent skip-tolerance
must ALL be empty AND agree: (1) `SKIP_TOLERANT_NEEDS_MEMBERS` (Rust) is empty;
(2) `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS` (Rust) is empty; (3)
`scripts/check-ci-gate.sh --print-allowed-skips` (the bash `ALLOWED_SKIPS=()`
production state) prints zero non-empty lines. A silent PARTIAL empty — e.g.
`ALLOWED_SKIPS` emptied in bash but `SKIP_TOLERANT_NEEDS_MEMBERS` left stale in
Rust — is exactly the guardrail-desync class this file's history exists to
catch, and post-cycle-006 the meaningful invariant INVERTS from "≥1 legitimate
skip path must exist" (pre-cycle-006) to "the skip-tolerant surface is empty,
and consistently so across all three representations."

**Mechanism.** A NEW dedicated `#[cfg(unix)]` test in
`tests/ci_gate_completeness.rs` — round-2 test #1,
`test_skip_tolerant_surface_is_consistently_empty_by_design` (architecture-delta
§6.2 item 11). Pure in-Rust `.is_empty()` on the two Rust consts PLUS a shell-out
to `scripts/check-ci-gate.sh --print-allowed-skips` (same invocation
`test_allowed_skips_members_require_job_level_conditional_in_ci_yml` already
uses), asserting zero non-empty lines. This is the PRIMARY, single-purpose
consistency assertion; the two in-body transforms of existing tests (items 6/7
in architecture-delta §6.2 — `test_ci_gate_decision_matches_job_level_if_for_
every_needs_member`'s `saw_positive_branch` now conditional on the empty list,
and `test_allowed_skips_members_require_job_level_conditional_in_ci_yml`'s
three-way empty-consistency check) are the DEFENSE-IN-DEPTH transforms, not
count-incrementing new tests. Kani/proptest/fuzz N/A (§1).

**Concrete assertion.** `SKIP_TOLERANT_NEEDS_MEMBERS.is_empty()` ∧
`PINNED_ALLOWED_SKIP_IF_EXPRESSIONS.is_empty()` ∧
`--print-allowed-skips` output is empty (zero non-empty lines). The failure
message explains WHY empty is the by-design cycle-006 state (naming
architecture-delta §6.4/§6.6) so a future reader does not misread it as an
oversight or broken script.

**RED proof.**
- Against a mutant that re-adds any job to `SKIP_TOLERANT_NEEDS_MEMBERS` (or
  `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS`) WITHOUT restoring `ALLOWED_SKIPS` in
  bash (the exact silent-partial-empty desync): the non-empty Rust list makes
  the `.is_empty()` assertion RED, while the correct all-empty config is GREEN.
- Against the mirror mutant — restoring a bash `ALLOWED_SKIPS=("x")` entry while
  both Rust lists stay empty: `--print-allowed-skips` now prints `x`, the
  zero-lines assertion goes RED. Distinguishes a genuinely-consistent empty
  surface from any one-sided drift among the three representations. (This is the
  round-2 finding that emptying the pins under round-1's retarget would, under
  the OLD hard `saw_positive_branch`/`!allowed_skips.is_empty()` asserts, turn
  CI red on a CORRECT design — items 6/7's transforms make emptiness the thing
  under test; this VP makes it a named, single-purpose, separately-reviewable
  assertion rather than an assumed precondition.)

---

### VP-MUTANTS-SHARD-012 — `print_allowed_skips` empty-array output is `[]`, never `[""]` (round-2, MEDIUM-1)

**Property.** `scripts/check-ci-gate.sh`'s `print_allowed_skips` — now exercised
for the FIRST time against a genuinely empty production `ALLOWED_SKIPS=()`
(cycle-006, §6.4) — emits ZERO lines for the empty case, never a phantom blank
line (`[""]`). It gains an explicit `[ "${#ALLOWED_SKIPS[@]}" -eq 0 ] && return
0` short-circuit so the behavior is independent of any bash-version
`"${ALLOWED_SKIPS[@]}"`-under-`nounset` empty-array-expansion semantics. Per this
repo's "an unexercised-until-now code shape needs an explicit RED/GREEN proof,
not an assumption" convention (S-CIGATE-3/round-14 precedent), this shape earns
its own proof.

**Mechanism.** Behavioral bash self-test — a NEW **sibling** self-test suite
`run_print_allowed_skips_self_test()` inside `scripts/check-ci-gate.sh`
(mirroring `run_jq_trust_self_test`'s shape: local `pas_total`/`pas_mismatches`
counters, one `check_print_allowed_skips_output` helper, a fixed-denominator
self-check), wired into `main --self-test` as a THIRD suite alongside
`decision_rc`/`jq_trust_rc`. It carries its OWN new fixed-denominator pin,
`EXPECTED_PRINT_ALLOWED_SKIPS_CHECKS = 1` (same `readonly`-at-file-scope pattern
as its two siblings). **Deliberately NOT folded into `EXPECTED_FIXTURES`/
`check_fixture`** — those test `evaluate_needs()`'s JSON-payload pass/fail
decision, a different function's behavior entirely; folding would be the same
category error precedent already avoids (cf. `EXPECTED_JQ_TRUST_CHECKS`). So
`EXPECTED_FIXTURES` stays `14`, unchanged. This is a `check-ci-gate.sh`
self-test counter, ORTHOGONAL to `EXPECTED_GUARD_TEST_COUNT` (it adds NO Rust
`#[test]`). Kani/proptest/fuzz N/A (§1).

**Concrete assertion.** `check_print_allowed_skips_output
"production-allowed-skips-is-empty"` calls `print_allowed_skips` with NO
override (the true, current file-scope `ALLOWED_SKIPS=()`) and asserts the
captured output is the empty string / zero lines; the suite's terminal
fixed-denominator self-check asserts exactly `EXPECTED_PRINT_ALLOWED_SKIPS_CHECKS
= 1` checks ran (a silently-deleted check fails loudly — the round-10
fixture-count-pin precedent).

**RED proof.**
- Against a mutant that DROPS the empty-array short-circuit and lets
  `printf '%s\n' "${ALLOWED_SKIPS[@]}"` run over the empty array on a bash
  version where that expansion yields a single empty argument: the output is one
  blank line (`[""]`), not zero lines → the "empty output" assertion RED.
  Correct short-circuited logic prints nothing → GREEN.
- Against a mutant that silently deletes the sole check (shrinking the
  denominator): the fixed-denominator self-check (`ran != 1`) fires RED — the
  same "shrunken-denominator reads as success" false-green the `EXPECTED_*`
  fixed-denominator pins across this repo exist to close. **Explicitly declined
  (documented, not an omission):** a second "populated array still prints
  correctly" check is NOT added — it would introduce a fourth textual
  `ALLOWED_SKIPS=` occurrence and desync `test_allowed_skips_has_exactly_three_
  code_level_references`'s pinned count of 3 for no coverage gain, since the
  mutation it would guard is already caught transitively the day `ALLOWED_SKIPS`
  next becomes non-empty (architecture-delta §6.1).

**Round-3 additions folded under this empty-array VP (MEDIUM-1 sibling +
Fixture-14 + count reconciliation — architecture-delta §6.1, §6.7):**
- **`is_allowed_skip` gains the SAME empty-array short-circuit as
  `print_allowed_skips`, but returning `1`, NOT `0` — the documented asymmetry
  that is the one thing to get right.** Round-2 fixed `print_allowed_skips`'s
  empty-array expansion but never applied it to `is_allowed_skip`, the function
  `evaluate_needs()` actually calls per job to decide skip-tolerance. That gap is
  not merely cosmetic: `ALLOWED_SKIPS` becomes genuinely empty in production for
  the first time THIS cycle (§6.4) at the exact moment the `#[cfg(unix)]`
  subprocess tests exercise this script on TWO CI bash versions — `ubuntu-latest`
  (bash ≥5.x, empty-array expansion under `set -u` is a harmless no-op) AND
  `macos-latest` (bash 3.2.57, where the IDENTICAL expansion is a FATAL "unbound
  variable" error under this script's file-scope `set -euo pipefail`).
  `is_allowed_skip` now short-circuits `[ "${#ALLOWED_SKIPS[@]}" -eq 0 ] && return
  1` — **`return 1`** (an empty allowlist means "nothing may skip," fail-closed),
  where `print_allowed_skips`'s guard is `return 0` (nothing to print). Copying
  the `return 0` here would be a SEVERE fail-open regression (every `skipped`
  result would pass unconditionally). `${#ALLOWED_SKIPS[@]}` adds NO fourth
  textual `ALLOWED_SKIPS=` occurrence (`${#ALLOWED_SKIPS` ≠ `${ALLOWED_SKIPS`).
- **Fixture 14 gains a message-substring assertion (`"FAIL  fmt = skipped"`), not
  just `"fail:1"`, and its safety claim is re-scoped to BOTH CI bash versions.**
  On bash 3.2 PRE this fix, `is_allowed_skip`'s unguarded loop over the empty
  array aborts with `bash: ALLOWED_SKIPS[@]: unbound variable` and exits 1 —
  numerically INDISTINGUISHABLE from the intended `"fail:1"`. A bare return-code
  check would have reported Fixture 14 GREEN on macOS while silently proving a
  runtime CRASH, not `evaluate_needs()`'s fail-closed decision reaching its FAIL
  branch. The substring check closes that: a crash's stderr never contains
  `"FAIL  fmt = skipped"`. Fixture 14 (run via `check-ci-gate.sh --self-test` in
  `spec-guard`/`ubuntu-latest` AND via the `#[cfg(unix)]` subprocess tests on
  `ubuntu-latest` + `macos-latest`) now proves the empty-array behavior correct
  on **both bash versions this repo runs this script under** — not merely "ubuntu
  bash ≥5.x" as round-1/2 claimed. F4 must confirm Fixture 14 passes green on a
  real `macos-latest` run, not merely infer it from the ubuntu leg.
  `EXPECTED_FIXTURES` stays `14` in COUNT (Fixture 14's body changes, the count
  does not).
- **Count reconciliation supersedes this VP's own "would desync count of 3"
  caveat above.** The "Explicitly declined" note above reasons that a second
  `print_allowed_skips` check is declined partly because it "would… desync
  `test_allowed_skips_has_exactly_three_code_level_references`'s pinned count of
  3." Round-3 INDEPENDENTLY moves that count `3 → 4` for a DIFFERENT reason
  (MEDIUM-2): fixtures 4/5's local-`ALLOWED_SKIPS`-override technique is unified
  into ONE shared wrapper `run_fixture_with_synthetic_skip_tolerant_job()`
  (`local ALLOWED_SKIPS=("example-skip-tolerant-job"); check_fixture "$@"`),
  contributing exactly ONE new occurrence (the 4th, not a 5th — both fixtures
  share the one wrapper). The test is RENAMED
  `test_allowed_skips_has_exactly_four_code_level_references` and its `assert_eq!`
  target moves `3 → 4`; the four sites are (1) the `ALLOWED_SKIPS=()` declaration,
  (2) `is_allowed_skip`'s loop expansion, (3) `print_allowed_skips`'s expansion,
  (4) the wrapper's local override. VP-012's own guard still adds ZERO occurrences;
  the declined-second-check reasoning still holds (that mutation is caught
  transitively). A `read -a`-based override to dodge the bump is explicitly
  REJECTED (it would defeat this file's own guard, per architecture-delta §6.1).

---

### VP-MUTANTS-SHARD-013 — `OVERALL_DIFF_LINES` malformed-but-SET value fails CLOSED (round-2, LOW — consumer-side wiring guard)

**Property.** In `scripts/mutants-aggregate.sh` Step 5 (base-ref-drift guard),
`OVERALL_DIFF_LINES` is regex-validated `^[0-9]+$` BEFORE it is used in the
integer `-eq 0` comparison, and a malformed-but-SET value fails the aggregation
CLOSED (exit 1, naming the bad value) rather than routing to the wrong branch.
The pre-fix guard was ONLY the `${OVERALL_DIFF_LINES:-0}` fallback, which handles
UNSET/empty correctly (bash `:-` fires on unset-or-empty) but NOT a
malformed-but-set value: a non-numeric `OVERALL_DIFF_LINES` makes `[
"${OVERALL_DIFF_LINES:-0}" -eq 0 ]` itself error ("integer expression
expected", exit 2), which `if` treats as FALSE — silently routing to the "OK:
non-empty diff" pass branch instead of the intended base-ref-drift FAIL branch.
This mirrors `MUTANT_COUNT`'s existing Step-4 regex guard (VP-008 fixture path),
closing the asymmetry between the two consumer-side integer inputs. Reachable
only via a GHA output-plumbing bug (a mistyped `env:` key — the same class VP-010
guards for `escalated` at the WIRING layer); VP-013 complements that by guarding
the CONSUMPTION side of `overall_diff_lines` specifically.

**Mechanism.** Behavioral bash-subprocess fixture on the aggregator harness —
NOT a new Rust `#[test]`. It rides the SAME `scripts/mutants-aggregate.sh`
subprocess harness as VP-001/003 (per §2's extraction precondition), placed as a
distinct fixture case and — recommended — as a `--self-test` fixture counted by
that script's own `EXPECTED_MUTANTS_AGG_FIXTURES` denominator, ORTHOGONAL to
`EXPECTED_GUARD_TEST_COUNT`. It does not add a `#[test]` FUNCTION, so it drives
NO change to the `EXPECTED_GUARD_TEST_COUNT` (now 58). Kani/proptest/fuzz N/A (§1).

**Concrete assertion.** Invoke the aggregator with a full healthy 8-sentinel set
that reconciles to `total_scored=0` and `MUTANT_COUNT=0` (so Step 5 is reached),
but with `OVERALL_DIFF_LINES="abc"` (malformed-but-SET). Assert exit **1**; log
names the bad value and the "not a valid non-negative integer — cannot evaluate
the base-ref-drift guard" message; log does **NOT** contain the "OK: non-empty
diff" pass line.

**RED proof.** Against a mutant that removes the `^[0-9]+$` guard on
`OVERALL_DIFF_LINES` (reverting to the `:-0`-only form): the malformed `"abc"`
makes `[ "abc" -eq 0 ]` error → `if` treats it as false → the aggregator falls
through to `echo "OK: … non-empty diff …"; exit 0` — **the exact false-green: a
base-ref-drift condition silently accepted as a legitimate non-empty-diff pass.**
The correct guarded logic exits 1 at Step 5. Because the fixture is constructed
so `total_scored==0` (the only path that reaches Step 5's `OVERALL_DIFF_LINES`
comparison), the malformed value is the sole cause of the divergence — RED
against the mutant, GREEN against correct logic. (Companion note, NOT a separate
VP: the adjacent `--list` tooling-error hardening — a genuine `cargo mutants
--list` failure now fails `mutants-plan` closed instead of coercing
`MUTANT_COUNT=0` — surfaces at the aggregator as `PLAN_RESULT != "success"` and
is exercised by a co-located Step-0.5 fixture on this same harness; see §4's
coverage note.)

---

### VP-MUTANTS-SHARD-014 — Step-0 fail-CLOSED event guard (round-3, HIGH-1 — the one genuinely NEW false-green this round)

**Property.** `scripts/mutants-aggregate.sh`'s Step 0 (the push-event no-op —
this job's only "skipped"-equivalent path, resolved as an ordinary success,
NEVER a GHA `skipped` conclusion) recognizes the event via a **fail-CLOSED
allowlist `case` statement**, NOT the pre-fix fail-OPEN `!=` comparison. Exactly
one arm falls through to run the real gate logic (`pull_request`); an explicit
allowlist of KNOWN non-PR events (`push`/`schedule`/`workflow_dispatch`) exits 0
early with an OK no-op message; and the default `*)` arm — reached by an EMPTY
string, an unrecognized value, or any FUTURE `ci.yml` trigger nobody has added to
the allowlist — **FAILS CLOSED (exit 1)** naming the unrecognized value. This
matters because GitHub Actions resolves a mistyped `${{ }}` expression (e.g. a
typo in this step's own `env:` `EVENT_NAME: ${{ github.event_nam }}`) to an
EMPTY string, not an error — so on a genuine `pull_request` run the pre-fix
`[ "${EVENT_NAME}" != "pull_request" ]` treated `""` as "not a PR" and exited 0
with ZERO shard inspection: a false-green on the one input the script trusts to
even decide whether to run its own logic. The same empty-string-from-bad-`${{ }}`
platform behavior that VP-010 guards on the OUTPUT (`escalated`) side, here on
the INPUT (`event_name`) side.

**Mechanism.** Behavioral bash-subprocess fixture on the extracted
`scripts/mutants-aggregate.sh --self-test` harness (§2) — the runtime `case`
statement's own correctness is proven by the script's OWN self-test, consistent
with this file's precedent that CI-script-INTERNAL control flow is proven by the
script's `--self-test` while the YAML WIRING feeding it is proven by a Rust
structural pin (VP-015 is that pin). Two fully-specified fixtures already appear
in architecture-delta §6.2a: `event-name-empty-fails-closed`
(`--env EVENT_NAME=""`, expect `fail:1` + stdout `"FAIL: EVENT_NAME"`) and
`event-name-push-is-ok-noop` (`--env EVENT_NAME="push"`, expect `pass` + stdout
`"OK: not a pull_request event"`). **This VP adds NO Rust `#[test]` function** —
it is counted by the NEW `EXPECTED_MUTANTS_AGG_FIXTURES` denominator, ORTHOGONAL
to `EXPECTED_GUARD_TEST_COUNT` (same bookkeeping as VP-003/013). Kani/proptest/fuzz
N/A (§1).

**Concrete assertion.**
- **Empty-EVENT_NAME (the direct HIGH-1 regression):** invoke with
  `EVENT_NAME=""` on a context that is otherwise a real PR (`PLAN_RESULT`/
  `ESCALATED`/`MUTANT_COUNT` irrelevant — Step 0 must short-circuit before
  touching them). Assert exit **1**; stdout contains `"FAIL: EVENT_NAME"` (the
  default-arm message); stdout does NOT contain any OK/pass line.
- **Known non-PR `push` still legitimately no-ops:** invoke with
  `EVENT_NAME="push"`. Assert exit **0**; stdout contains `"OK: not a
  pull_request event"`. (Proves the fix did NOT regress the legitimate push-event
  skip the pre-sharding design also had — a fail-closed rewrite that broke `push`
  would be an over-correction.)
- **(Recommended reinforcing case) unrecognized value fails closed:** invoke with
  `EVENT_NAME="release"` (a real GHA event, deliberately absent from the
  allowlist). Assert exit **1** — proves the default arm catches an unrecognized
  KNOWN event, not just the empty string, so a future trigger added to `ci.yml`
  without updating this `case` fails loudly rather than silently no-op'ing.

**RED proof (explicit — distinguishes the fixed allowlist `case` from the old
fail-OPEN `!=`-exit-0 form).** Construct the mutant that reverts Step 0 to the
pre-fix form: `if [ "${EVENT_NAME}" != "pull_request" ]; then echo "…skip…";
return 0; fi`. Under this mutant, the `EVENT_NAME=""` fixture takes the
`"" != "pull_request"` → true branch and **returns 0 — GREEN — the exact
false-green: a real PR whose `EVENT_NAME` was emptied by a mistyped `env:` key is
silently passed with zero shard inspection**. The correct allowlist `case` hits
the default `*)` arm and returns 1. Because the fixture asserts exit 1, it is
**RED against the fail-open mutant and GREEN against the fixed fail-closed
logic** — the distinguishing proof the task requires. The paired `push` fixture
(asserting exit 0) simultaneously proves the fix is not a blanket "anything but
`pull_request` fails" over-correction: a mutant that dropped the
`push|schedule|workflow_dispatch)` arm would turn that fixture RED, so the two
fixtures together pin BOTH edges of the allowlist. A second reinforcing mutant —
a catch-all `*) return 0 ;;` carelessly added to the `case` (the future-widening
footgun architecture-delta §6.2a warns about) — makes the empty-EVENT_NAME
fixture return 0 again → RED, pinning that the default arm must FAIL, not pass.

---

### VP-MUTANTS-SHARD-015 — `EVENT_NAME` env-wiring byte-pin (round-3, HIGH-1 defense-in-depth; mirrors VP-010)

**Property.** `mutants-aggregate`'s "Evaluate sharded mutation gate" step's `env:`
mapping binds `EVENT_NAME:` to exactly `${{ github.event_name }}` — a byte-exact
structural pin on the INPUT wiring, the mirror image of VP-010's byte-exact pin
on the `ESCALATED`/`escalated` OUTPUT wiring. This is defense-in-depth on the
WIRING, distinct from and complementary to VP-014's runtime `case`-statement
proof: VP-014 proves the script ACTS fail-closed on a bad `EVENT_NAME`; VP-015
proves the value is actually WIRED to arrive from `github.event_name` in the
first place, so a FUTURE edit that widens Step 0's `case` (e.g. a careless
catch-all `*) return 0`) is still caught at the wiring layer even before the
runtime behavior is exercised. A mistyped `env:` key here (`github.event_nam`)
degrades GRACEFULLY to an empty string — which the FIXED Step 0 (VP-014) now
correctly treats as FAIL, but the pin still earns its place because it names the
plumbing break directly rather than relying on a downstream runtime symptom.

**Mechanism.** Rust structural pin parsed through `tests/common/wf.rs`
(`saphyr-parser` event stream) — architect's round-3 test #1 (§6.2 item 12),
`test_mutants_aggregate_event_name_env_wired`, in `tests/ci_gate_completeness.rs`.
Reads the `mutants-aggregate` eval-step's `env:` child mapping via the EXISTING
job/step nested-mapping accessors (no new `wf.rs` primitive — architecture-delta
§6.3), asserting the value byte-for-byte (plain-scalar, `ScalarStyle::Plain`),
the SAME technique as VP-010's `ESCALATED` pin directly. **This IS a Rust
`#[test]`** — one of the two that drive `EXPECTED_GUARD_TEST_COUNT` 49 → 51.
Kani/proptest/fuzz N/A (§1).

**Concrete assertion.** `mutants-aggregate` eval-step
`env.EVENT_NAME == "${{ github.event_name }}"`.

**RED proof** (against a temporary, untracked mutated `ci.yml`):
- Mutate the key/value — e.g. `EVENT_NAME: ${{ github.event_nam }}` (typo) or
  reference a different context → byte-equality assertion RED. Distinguishes the
  exact `github.event_name` source from any look-alike; correct wiring → GREEN.
- Drop the `EVENT_NAME:` key entirely → the pin's presence lookup fails → RED.
  Distinguishes "wired to the right source" from "not wired at all" (which at
  runtime would make `EVENT_NAME` unset, tripping VP-014's default-arm FAIL — the
  two VPs guard the two halves of the same mechanism).

---

### VP-MUTANTS-SHARD-016 — `spec-guard` runs `mutants-aggregate.sh --self-test` (round-3, extraction-wiring pin)

**Property.** The `spec-guard` job contains a step that runs
`scripts/mutants-aggregate.sh --self-test`, and that step's own `run:` line is
byte-pinned — so the NEW `EXPECTED_MUTANTS_AGG_FIXTURES` fixture suite is actually
EXECUTED in CI, not merely defined in a script nothing invokes. Without this
wiring, the extracted aggregator's self-test harness (which is what makes
VP-001/002/003/006/007/008/013/014's behavioral RED proofs run against SHIPPED
logic) would be "a self-test suite nobody runs — dead code with a comforting
name," the exact concern architecture-delta §6.2a and this repo's own
`EXPECTED_WF_TEST_COUNT` tripwire history (fix-burst-6) treat seriously.

**Mechanism.** Rust structural pin parsed through `tests/common/wf.rs` —
architect's round-3 test #2 (§6.2 item 13),
`test_spec_guard_contains_mutants_aggregate_self_test_step`, in
`tests/ci_gate_completeness.rs`. Mirrors the PRE-EXISTING
`test_spec_guard_contains_check_ci_gate_self_test_step` (AC-008) exactly: asserts
the `spec-guard` block contains a step (anchored by step name "check-mutants-
aggregate self-test (fixture suite, cycle-006)") whose `run:` line is byte-pinned
via `extract_and_normalize_step_run_line_by_name` to `bash
scripts/mutants-aggregate.sh --self-test` — closing the same "two unrelated
`--self-test` substrings elsewhere in the job could satisfy a bare substring
check" gap S-626-1 pass-54/56 already closed for the check-ci-gate.sh sibling.
Companion forced edit (no separate VP): `PINNED_ALWAYS_RUN_STEP_KEY_SETS`'s
`spec-guard` entry grows from 12 → 13 ordered step-key-set tuples (append
`&["name", "run"]`), enforced by the EXISTING generic
`test_always_run_jobs_have_pinned_complete_step_key_sets` in the SAME commit.
**This IS a Rust `#[test]`** — the second of the two driving
`EXPECTED_GUARD_TEST_COUNT` 49 → 51. Kani/proptest/fuzz N/A (§1).

**Concrete assertion.** `spec-guard` job contains a step named `"check-mutants-
aggregate self-test (fixture suite, cycle-006)"`; that step's normalized `run:`
line equals `bash scripts/mutants-aggregate.sh --self-test`; and the same job's
`PINNED_ALWAYS_RUN_STEP_KEY_SETS` tuple count is 13.

**RED proof** (against a temporary, untracked mutated `ci.yml`):
- Remove the self-test step → the step-name anchor lookup fails → RED.
  Distinguishes "the self-test actually runs in CI" from "defined but never
  invoked" (the dead-code-guard false-green).
- Corrupt the `run:` line — e.g. `bash scripts/mutants-aggregate.sh` (drop
  `--self-test`), or `bash scripts/check-ci-gate.sh --self-test` (wrong script) →
  byte-pin RED. A bare substring check would accept the wrong-script form (it
  still contains `--self-test`); the byte-pin does not.
- Add the step to `ci.yml` WITHOUT growing `PINNED_ALWAYS_RUN_STEP_KEY_SETS`'s
  `spec-guard` tuple to 13 (or vice-versa) → the generic step-key-set test fires
  RED, naming `spec-guard` and the mismatched count — the same-commit lockstep
  enforcement.

---

### Round-4 note — VP-017..021 make `mutants-aggregate` a documented STRUCTURAL PEER of `ci-gate`

VP-017..021 are not five unrelated pins: together they port the anti-neutering
guardrail CLASS `ci-gate`'s OWN decision step earned over 20+ review rounds
(`tests/ci_gate_completeness.rs`'s `test_ci_gate_pass_fail_semantics_are_
structurally_placed`, assertions M2-a..M2-q, plus the standalone AC-001
invocation test) onto `mutants-aggregate`, which — as of cycle-006 — is the SOLE
`ci-gate.needs` member making the mutation-gate pass/fail decision and the only
job besides `ci-gate` in this file occupying that "sole load-bearing arbiter"
role. Through round-3 it had inherited only the protections that fall out of
GENERIC mechanisms already iterating every `ci-gate.needs` member (the job/step
complete-key-set pins, the blanket `continue-on-error` ban, the
`PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS` carve-out) — NONE of the decision-step-
specific ones. The mapping: VP-017 = M2-i (run-line byte-pin), VP-018 = M2-o
(env-key-set pin), VP-019 = AC-001 (invocation assertion), VP-020 = M2-q
(node-property scan), VP-021 = the genuinely NEW gap (per-step `if:`-VALUE pin —
no M2-d analog, because M2-d's own "no step-level `if:` at all" rule does not
hold for `mutants-aggregate`, which legitimately carries three `if: always()`
steps). **Full systematic enumeration — including every `ci-gate` protection
that is inherited transitively rather than getting its own new test, and every
one deliberately declined — is architecture-delta §6.8** (the `ci-gate`
protection → `mutants-aggregate` disposition table). These five VPs cross-ref
that section; each carries its own RED proof against the specific neutering it
blocks, below.

---

### VP-MUTANTS-SHARD-017 — decision-step `run:` line byte-pin (round-4, §6.8 M2-i analog)

**Property.** `mutants-aggregate`'s "Evaluate sharded mutation gate" step's
`run:` line is byte-pinned to exactly `bash scripts/mutants-aggregate.sh`
(`PINNED_MUTANTS_AGGREGATE_RUN_LINE`), so no suffix — `|| true`, `| cat`,
`; exit 0`, `&& true`, a redirect swallowing the exit code — can silently neuter
the one step whose exit code IS the mutation-gate pass/fail signal `ci-gate` then
relays. This is the exact CRITICAL class M2-i closed for `ci-gate`'s own gate
step in PR #671 review round 10 (four one-line edits each left the suite green
while making the gate tolerate every upstream failure), ported to the job that
now holds the equivalent role one level down.

**Mechanism.** Rust structural pin parsed through `tests/common/wf.rs`
(`saphyr-parser` event stream) — architect's round-4 test #1 (§6.2 item 14),
`test_mutants_aggregate_decision_step_run_line_is_pinned`, in
`tests/ci_gate_completeness.rs`. Calls the EXISTING, already-generic
`extract_and_normalize_sole_run_line(mutants_aggregate_block)` (the SAME function
that byte-pins `ci-gate`'s run line — this job has exactly one step-level `run:`
key, the eval step, so its "exactly one `run:` in the whole block" precondition
holds with zero new `wf.rs` code) and asserts the normalized result equals
`PINNED_MUTANTS_AGGREGATE_RUN_LINE` byte-for-byte, plain-scalar
(`ScalarStyle::Plain` asserted). Kani/proptest/fuzz N/A (§1).

**Concrete assertion.** `extract_and_normalize_sole_run_line(mutants_aggregate_
block) == "bash scripts/mutants-aggregate.sh"`.

**RED proof** (against a temporary, untracked mutated `ci.yml`):
- Append `|| true` (or `; exit 0`, or `| cat`) to the eval step's `run:` line →
  the normalized value no longer equals the pin → test RED. This is the exact
  neutering the task names: a one-line edit that makes the gate step's exit code
  meaningless while the job still reports `success`. Correct pinned line → GREEN.
- Change the invoked script path (e.g. `bash scripts/check-ci-gate.sh`) → byte
  inequality RED. Distinguishes "invokes the real aggregator" from a look-alike.

---

### VP-MUTANTS-SHARD-018 — decision-step `env:` complete key-set pin (round-4, §6.8 M2-o analog)

**Property.** The `mutants-aggregate` eval-step's `env:` mapping has EXACTLY the
seven keys `PINNED_MUTANTS_AGGREGATE_ENV_KEYS = &["ESCALATED", "EVENT_NAME",
"MUTANT_COUNT", "OVERALL_DIFF_LINES", "PLAN_RESULT", "SHARD_DIR", "STATUS_DIR"]`
(sorted) — set equality, default-deny. This closes a `BASH_ENV:`-class
smuggled-env-child vector in one stroke (an added `env:` child under the
already-pinned `env:` KEY would source an attacker-controlled shim before the
script runs — the exact CRITICAL M2-o closed for `ci-gate` in PR #671 round 12),
AND it is the structural protection covering add/remove/rename of ALL seven keys.

**Rationale corrected round-8 (F-H1) — the env-KEY-SET pin does NOT make a
byte-VALUE pin redundant for any key; the two guard DIFFERENT failure modes.**
This VP's earlier rationale wrongly implied that the five keys without an
individual byte-VALUE pin (`MUTANT_COUNT`/`OVERALL_DIFF_LINES`/`PLAN_RESULT`/
`STATUS_DIR`/`SHARD_DIR`) needed none because each had "an independent runtime
backstop" — for `STATUS_DIR`/`SHARD_DIR` that backstop was bash's
`${VAR:?message}` operator, and treating it as a substitute for a value pin was
the FAULTY argument F-H1 fixes. **`${VAR:?}` proves ONLY that the script aborts
on an UNSET or EMPTY value — a genuine but narrow guarantee. It gives ZERO
protection against a maliciously-but-VALIDLY-SET redirect** of those two paths to
an attacker-controlled directory (the value is non-empty, so `:?` passes), and
`STATUS_DIR`/`SHARD_DIR` locate the ENTIRE evidence set the whole decision reads
(every status sentinel, every `outcomes.json`), so a redirect forges everything
downstream at once. As of round-8, `STATUS_DIR`/`SHARD_DIR` therefore ALSO carry
byte-VALUE pins — **VP-026** (`STATUS_DIR`) and **VP-027** (`SHARD_DIR`) — which
coexist with THIS key-set pin exactly as VP-010/VP-015's byte-VALUE pins coexist
with it for `ESCALATED`/`EVENT_NAME`: VP-018's key-set pin guards the
`BASH_ENV:`-class smuggled-env-child vector (add/remove/rename of KEYS), while
VP-026/027 guard the evidence-source-redirect vector (tampering with the VALUE of
a legitimately-present key). Neither subsumes the other.

**Updated round-9 (LOW-1) — NO value-pin declination remains; ALL SEVEN keys are
now dual-pinned.** The earlier revision of this rationale left THREE keys
(`MUTANT_COUNT`/`OVERALL_DIFF_LINES`/`PLAN_RESULT`) with a key-set pin but no
individual byte-VALUE pin, each "declined on a RE-VERIFIED per-variable ground."
Round-9 found that declination CIRCULAR for `MUTANT_COUNT` specifically: its cited
backstop — reconciliation against pooled data (VP-008) — is keyed on
`total_scored != MUTANT_COUNT`, so a hardcoded `MUTANT_COUNT` equal to the real
pooled total makes reconciliation pass TRIVIALLY, disabling the very completeness
guard the declination leaned on, while the runtime backstop stays deceptively GREEN
(it reads the forged value against itself). This is the SAME class of gap as F-H1 (a
runtime backstop cited to justify skipping a structural pin, where the backstop reads
the value the structural layer left unpinned). Round-9 therefore pins the byte-VALUE
of ALL THREE previously-declined keys — **VP-028** (`MUTANT_COUNT`), **VP-029**
(`OVERALL_DIFF_LINES`), **VP-030** (`PLAN_RESULT`) — so that ALL SEVEN of this
step's env values now carry BOTH this key-set pin AND an individual byte-VALUE pin,
exactly as `ESCALATED`/`EVENT_NAME` (VP-010/VP-015) and `STATUS_DIR`/`SHARD_DIR`
(VP-026/027) already did. The runtime backstops (VP-008 reconciliation, VP-013's
`^[0-9]+$` regex guard, the Step-2 sentinel-presence interlock) are RETAINED as
complementary proofs of different failure modes — they are not replaced by the new
pins, and the new pins are not made redundant by them. §6.8's M2-n disposition rows
for these three keys move from DECLINED to MIRRORED (architecture-delta round-9 items
25-27 + updated Declination re-audit table).

**Mechanism.** Rust structural pin parsed through `tests/common/wf.rs` —
architect's round-4 test #2 (§6.2 item 15),
`test_mutants_aggregate_decision_step_env_key_set_is_pinned`, in
`tests/ci_gate_completeness.rs`. Calls the EXISTING, already-generic
`extract_gate_env_key_set(mutants_aggregate_block)` (itself
`step_mapping_child_keys(block, "run", "env")` — the SAME accessor M2-o uses for
`ci-gate`, zero new `wf.rs` code), asserts the result is NON-EMPTY first
(mirroring M2-o's own "a mis-anchored empty result must not silently read as
'nothing to worry about'" backstop), then asserts set-equality against
`PINNED_MUTANTS_AGGREGATE_ENV_KEYS`. Kani/proptest/fuzz N/A (§1).

**Concrete assertion.** `extract_gate_env_key_set(mutants_aggregate_block)` is
non-empty AND, sorted, equals `PINNED_MUTANTS_AGGREGATE_ENV_KEYS` exactly.

**RED proof** (against a temporary, untracked mutated `ci.yml`):
- Add a smuggled `BASH_ENV: /tmp/shim` (or any eighth key) to the eval step's
  `env:` block → the extracted key set gains `BASH_ENV`, no longer equals the
  7-key pin → test RED. This is the exact smuggled-env-child vector: `BASH_ENV`
  is sourced by non-interactive bash regardless of `--norc`/`--noprofile`, so a
  shim ending `exit 0` would end the shell before the pinned run line's body ran.
  Correct 7-key set → GREEN.
- Remove or rename any of the seven pinned keys → set inequality RED
  (default-deny in both directions, not merely on additions).

---

### VP-MUTANTS-SHARD-019 — decision-step invocation assertion (round-4, §6.8 AC-001 analog)

**Property.** The `mutants-aggregate` job block CONTAINS the substring
`scripts/mutants-aggregate.sh` (the gate step actually calls the real script),
AND the job's job-level `if:` resolves to a scalar whose text contains
`always()` (the job's always-run condition is intact) — the coarse
presence/invocation layer `ci-gate` has carried since before its byte-pin era
(`test_ci_gate_step_invokes_check_ci_gate_script_with_needs_json`). Kept as a
SEPARATE, looser assertion ALONGSIDE VP-017's byte-pin and VP-016's
`if: always()` byte-pin (VP-009's exact-`always()` match), exactly as `ci-gate`
carries both AC-001's substring check AND the M2-a/M2-m byte-exact checks rather
than relying on the byte-exact pin alone — a byte-pin that a refactor accidentally
retargets at the wrong step would still satisfy nothing here if the script were
no longer invoked at all.

**Mechanism.** Rust structural assertion parsed through `tests/common/wf.rs` —
architect's round-4 test #3 (§6.2 item 16),
`test_mutants_aggregate_step_invokes_mutants_aggregate_script`, in
`tests/ci_gate_completeness.rs`, a direct structural mirror of
`test_ci_gate_step_invokes_check_ci_gate_script_with_needs_json`. Asserts (a) the
job block contains `scripts/mutants-aggregate.sh`; (b) `job.value_of("if")`
resolves to a `Value::Scalar` whose text contains `always()`. Kani/proptest/fuzz
N/A (§1).

**Concrete assertion.** `mutants_aggregate_block.contains("scripts/mutants-
aggregate.sh")` ∧ `job.value_of("if")` is a scalar containing `always()`.

**RED proof** (against a temporary, untracked mutated `ci.yml`):
- Rename the invoked script everywhere in the job (e.g. to `scripts/agg.sh`) so
  the substring is absent → assertion (a) RED. Distinguishes "the real
  aggregator is invoked" from "no aggregator is invoked" (the case a byte-pin on
  a since-removed step could miss). Correct block → GREEN.
- Drop or mangle the job-level `if:` so it no longer contains `always()` →
  assertion (b) RED — the presence-level counterpart to VP-009's exact match.

---

### VP-MUTANTS-SHARD-020 — job-block YAML node-property scan (round-4, §6.8 M2-q analog)

**Property.** No mapping key anywhere in the `mutants-aggregate` job block
carries a YAML node property — an anchor (`&name`) or a tag (`!tag`/`!!tag`)
prefixing the key on the same physical line. Such a property resolves to a real
key under the real parser (`&x shell: cat {0}` adds a genuine `shell` key) but is
invisible to a pure key-SET diff whose line-based extraction stops at the space
after `&x`, and it is invisible with ZERO line breaks involved (orthogonal to the
non-LF-byte scan). This is the CRITICAL M2-q closed for `ci-gate` in S-CIGATE-3;
`mutants-aggregate` is the FIRST job OTHER than `ci-gate` this scanner is run
against — a deliberate, narrow widening (architecture-delta §6.8 "Scope of the
M2-q widening"), justified because it now shares `ci-gate`'s exact "sole
pass/fail decision" property one level down, and explicitly NOT extended to every
other job (whose ordinary ADD-side key-set pins already backstop a new
anchored/tagged key).

**Mechanism.** Rust structural scan parsed through `tests/common/wf.rs` —
architect's round-4 test #4 (§6.2 item 17),
`test_mutants_aggregate_job_block_has_no_key_node_properties`, in
`tests/ci_gate_completeness.rs`. Calls the EXISTING, already-generic
`common::wf::find_key_node_properties(mutants_aggregate_block)` (the function
already takes arbitrary YAML text — it is simply invoked a SECOND time against a
second job block, zero new `wf.rs` code) and asserts the returned `Vec` is empty,
the SAME assertion shape M2-q uses for `ci-gate`. Kani/proptest/fuzz N/A (§1).

**Concrete assertion.** `find_key_node_properties(mutants_aggregate_block) ==
[]` (empty vec).

**RED proof** (against a temporary, untracked mutated `ci.yml`):
- Prefix the eval step's `run:` (or any pinned key) with an anchor —
  `&x run: bash scripts/mutants-aggregate.sh || true` — where the anchor lets a
  node property ride on an ALREADY-pinned key: the key-SET pin (VP-018-class)
  can NEVER catch this because the key text is unchanged, but
  `find_key_node_properties` reports `[{key:"run", has_anchor:true}]` → test RED.
  Correct block (no node properties) → empty vec → GREEN. This is the precise
  gap the task names for the M2-q analog — a `&x`/`!!str` on a pinned key.
- A tag form `!!str shell: cat {0}` smuggling a NEW `shell` key: caught two ways
  — the key-set pin sees an unexpected `shell` key AND `find_key_node_properties`
  reports the tag; this VP owns the second, node-property-specific detection.

---

### VP-MUTANTS-SHARD-021 — the three legitimate step-level `if:` values are all `always()` (round-4, §6.8 — genuinely new, no round-1/2/3 analog)

**Property.** `mutants-aggregate` legitimately carries THREE step-level
`if: always()` occurrences — "Download all shard status sentinels", "Download all
shard outcomes", and "Evaluate sharded mutation gate" (`ci-yml-design.md §3`) —
and EACH one's `if:` value equals the exact tautology `always()`. This is
`mutants-aggregate`'s INVERSION of `ci-gate`'s M2-d ("no step-level `if:` at
all"): a download step MUST run even when its upstream artifact is genuinely
absent, so its own outcome can be interpreted rather than silently skipped, so
the correct protection is not "ban step-level `if:`" but "pin each step-level
`if:`'s VALUE." Before this pin, `PINNED_ALWAYS_RUN_STEP_KEY_SETS`'s
`mutants-aggregate` entry confirmed `if` is a KEY on each of these three steps
but asserted NOTHING about its VALUE — a future edit changing one download step's
`if: always()` to `if: false` (silently skipping status-sentinel or
outcome-artifact download, which INV-COMPLETE's Part B/C would then read as
"genuinely missing" — a FALSE-RED correctness break) or to a `needs`-referencing
conditional would satisfy every OTHER pin in this design while going undetected.
This is the one round-4 finding with no round-1/2/3 analog.

**Mechanism.** Rust structural assertion parsed through `tests/common/wf.rs` —
architect's round-4 test #5 (§6.2 item 18),
`test_mutants_aggregate_step_level_if_values_are_all_always`, in
`tests/ci_gate_completeness.rs`. Iterates the three named steps, resolves each
step's `if:` value via step-scoped resolution (`Step::value_of("if")` /
`extract_and_normalize_if_expr`-equivalent), and asserts each equals the exact
plain-scalar tautology `always()` — the SAME cardinality-`1→3` iterating (not
indexing `[0]`) shape round-3's AC-006 rewrite of
`test_mutants_shard_job_structure_matches_sharded_design` already established for
the `mutants` shard job's own three `if: always()` steps. Kani/proptest/fuzz N/A
(§1).

**Concrete assertion.** For each of the three named steps: `Step::value_of("if")`
== the exact plain-scalar `"always()"`.

**RED proof** (against a temporary, untracked mutated `ci.yml`):
- Change any one of the three download/eval steps' `if: always()` to `if: false`
  → that step's value no longer equals `always()` → test RED. This is the exact
  false-RED correctness break the task names: a download step silently skipped,
  making INV-COMPLETE misread a present artifact as missing. Correct
  three-`always()` config → GREEN.
- Change one to a compound conditional (`always() && needs.mutants.result ==
  'success'` — which would skip the eval on a skipped shard matrix, defeating the
  `if: always()` design premise) → exact-equality RED (the `always()`-substring
  look-alike defeated by exact match, the same class as VP-009's tautology check).
- Reinforcing: dropping the `if:` key on one of the three (so the step no longer
  always-runs) is caught by the companion `PINNED_ALWAYS_RUN_STEP_KEY_SETS`
  key-set pin (a missing `if` key ≠ the pinned per-step key set) — the two pins
  together guard both the PRESENCE and the VALUE of each step-level `if:`.

---

### VP-MUTANTS-SHARD-022 — exact-equality reconciliation is SYMMETRIC (over-count direction also fails closed) (round-5 RE-SCOPED, §6.10 item 19)

**Property.** Sub-invariant 8's reconciliation is genuine exact equality
(`total_scored != MUTANT_COUNT`), not an accidental `<`-only check — so an
OVER-count (`total_scored > MUTANT_COUNT`: the shard matrix examined and reported
on MORE mutants than `mutants-plan`'s `--list` counted as in-diff-scope) fails
closed (exit 1) exactly as an under-count does. An over-count is the same
"examined ≠ planned" defect class this sub-invariant exists to catch (a
stale/duplicate artifact folded twice, or a shard's `--sharding slice`
computation drawing from a wider scope than the plan step used), and this cycle
has as little operational evidence ruling it out as it has for the under-count
direction. This VP is the previously-untested half of the round-5 "exact
equality, both directions" decision — round-4's version of this slot tested a
warning-only does-not-mask claim that is no longer reachable once Step 4 is a
hard fail (Step 6 never runs on a mismatch).

**Mechanism.** Behavioral bash-subprocess — a `#[cfg(unix)]` test in
`tests/ci_gate_completeness.rs` (architect's §6.10 item 19),
`test_mutants_aggregate_reconciliation_mismatch_does_not_mask_kill_rate_fail`
(name retained from round-4 for numbering continuity — its DOES-NOT-MASK framing
still applies: an over-count must not be masked by, or mistaken for, a legitimate
pass; F4 may rename if the test-naming convention is judged to require it),
invoking the extracted `scripts/mutants-aggregate.sh`. Fixture: `MUTANT_COUNT=100`
but the 8 shard sentinels' pooled total sums to `101` (an over-count), with the
101 scored mutants' `caught`/`missed`/`timeout` split constructed to yield a
pooled kill rate `>=90%` (deliberately healthy-looking, so a fail here is
attributable ONLY to the reconciliation mismatch, not to an incidental kill-rate
failure). Kani/proptest N/A (§1).

**Concrete assertion.** 8 healthy sentinels pooling `total_scored=101` with
`MUTANT_COUNT=100` (over-count mismatch), split yielding e.g. `caught_total=96,
missed_total=5` → 96/101 ≈ 95% (`>=90`). Assert: exit **1**; stdout names both
`100` and `101` (the reconciliation-mismatch text) — proving the comparison is
genuinely `!=` (both directions), not a `<`-only check that a naive implementation
would never trip on for an over-count. (There is no Step-6 pass line to check for
absence here — but its absence is implied by the exit-1 short-circuit; VP-023
carries the explicit pass-line-absent assertion for the under-count fixture.)

**RED proof.** Against a mutant that weakens the exact `!=` to a `<`-only /
`-lt` check (tolerating an over-count as "merely anomalous, not dangerous"): the
`total_scored=101 > MUTANT_COUNT=100` over-count satisfies `101 < 100 == false`,
so the mutant does NOT trip and the healthy-looking 95% PR **exits 0 — the exact
false-green: an over-count silently waved through**. The correct symmetric `!=`
logic exits **1**. Because the test asserts exit 1 and both numbers named, it is
RED against the `<`-only mutant (and against a mutant dropping the check
entirely — both numbers would be absent), GREEN only against exact equality.
Paired with VP-008 (under-count direction) this pins the comparison as symmetric
in both directions.

---

### VP-MUTANTS-SHARD-023 — a healthy PARTIAL kill rate never rescues a dropped-mutant mismatch (round-5 INVERTED, §6.10 item 20)

**Property.** Completeness is required, not merely quality of what happened to be
examined: a reconciliation mismatch combined with a genuinely healthy-looking
pooled kill rate on the PARTIAL (incomplete) scored set (`>=90%`) still FAILS the
gate (exit 1). A dropped survivor cannot buy its way past the gate by leaving
behind a scored subset that happens to read `>=90%` — this is the direct
behavioral inverse of round-4's version of this test (which asserted exit 0 + a
pass message for this exact fixture), reused as an explicit, named REGRESSION PIN
against ever re-introducing round-4's warning-only behavior by accident.

**Mechanism.** Behavioral bash-subprocess — a `#[cfg(unix)]` test in
`tests/ci_gate_completeness.rs` (architect's §6.10 item 20),
`test_mutants_aggregate_reconciliation_mismatch_does_not_block_passing_pr`
(name retained from round-4 for numbering continuity, now read as "does not
[wrongly] treat a healthy-partial-kill-rate PR as passing"; F4 MAY rename to
e.g. `test_mutants_aggregate_reconciliation_mismatch_fails_closed_despite_
healthy_partial_kill_rate` per the test-naming convention — either name is
acceptable as long as the BODY asserts exit 1 + reconciliation message + absent
pass message; formal-verifier keeps this write-up consistent with whichever F4
chooses), invoking `scripts/mutants-aggregate.sh`. Fixture: IDENTICAL to VP-008's
restored fixture (`MUTANT_COUNT=101`, pooled `100`, the 100 scored mutants' split
yielding a pooled kill rate `>=90%` on the partial set) — reused deliberately so
the suite has a named pin on this exact "healthy partial kill rate" shape.
Kani/proptest N/A (§1).

**Concrete assertion.** 8 healthy sentinels pooling `total_scored=100`,
`MUTANT_COUNT=101` (under-count mismatch), split yielding 95/100 = 95% (`>=90`).
Assert: exit **1**; stdout names the reconciliation mismatch (both `101` and
`100`); AND stdout does **NOT** contain the Step-6 "gate passed" success message
— proving a healthy-looking kill rate on the scored SUBSET never rescues a
dropped-mutant mismatch, and that Step 6 is unreachable once sub-invariant 8
fails.

**RED proof.** Against a mutant that drops the reconciliation `return 1`
(round-4's warn-and-continue, or any Step-4 fall-through): the healthy 95% partial
rate carries the incomplete set past Step 6 and it **exits 0 with the pass line
present — the exact false-green: a dropped survivor silently passing behind a
healthy-looking partial kill rate**. The correct hard-fail logic exits **1** at
Step 4 with the pass line ABSENT. Because the test asserts exit 1 AND the mismatch
message AND the ABSENCE of the pass line, it is RED against the drop-`return-1`
mutant (wrong exit + pass line present), against a mutant that drops the mismatch
diagnostic (silent mismatch), and GREEN only against fail-closed-before-Step-6.
Paired with VP-008 (which shares this fixture) and VP-022 (over-count direction),
the three together pin exact-equality reconciliation as a hard, symmetric,
completeness-first gate.

---

### VP-MUTANTS-SHARD-024 — Both gate scripts SOURCE the shared `trusted-jq.sh` helper (INV-AGG runtime-hardening parity)

**Property.** Both `scripts/check-ci-gate.sh` AND `scripts/mutants-aggregate.sh`
contain a `source` line resolving to the shared library
`scripts/lib/trusted-jq.sh` (extracted round-7 from `check-ci-gate.sh`'s
existing `resolve_trusted_jq`/`is_trusted_jq_dir`/`trusted_jq_dirs_for`), and
that library file EXISTS and defines those three functions. This is the WIRING
half of round-7's runtime-hardening parity (§6.11 item 21): the shared, sourced
helper — rather than a hand-copied second implementation in
`mutants-aggregate.sh` — is what makes a future jq-trust fix structurally
impossible to land in one decision-path script and forget in the other (the
"tested tree ≠ merged tree" / drift-between-copies class CLAUDE.md's own
`strict: false` note documents for a different mechanism). This proves the
wiring only, NOT the resolver's own runtime correctness, which
`check-ci-gate.sh`'s existing `run_jq_trust_self_test` /
`EXPECTED_JQ_TRUST_CHECKS = 17` already exhaustively proves and round-7
deliberately does NOT duplicate (§6.11 "Considered and declined").

**Mechanism.** Rust `#[test]` in `tests/ci_gate_completeness.rs`
(architect's §6.2 item 21,
`test_check_ci_gate_sh_and_mutants_aggregate_sh_source_shared_trusted_jq_helper`)
— a read-only TEXT SCAN, no subprocess: assert each of the two scripts contains
a `source` argument whose path-suffix is `scripts/lib/trusted-jq.sh` (tolerant
of the pure-bash `${BASH_SOURCE[0]}`-relative prefix each file computes, per
ci-yml-design.md §3/§3a), and that `scripts/lib/trusted-jq.sh` itself exists and
contains the three function-name definitions (substring/presence check).
Kani/proptest/fuzz N/A (§1). A `#[test]` — one of the two that drive
`EXPECTED_GUARD_TEST_COUNT` 58 → 60.

**Concrete assertion.** `check-ci-gate.sh` text contains a `source …
scripts/lib/trusted-jq.sh` line; `mutants-aggregate.sh` text contains a `source
… scripts/lib/trusted-jq.sh` line; `scripts/lib/trusted-jq.sh` exists and
defines `resolve_trusted_jq`, `is_trusted_jq_dir`, and `trusted_jq_dirs_for`.

**RED proof** (against a temporary, untracked mutated `scripts/mutants-aggregate.sh`):
against a mutant that DROPS the `source .../trusted-jq.sh` line from
`mutants-aggregate.sh` (or repoints it at a non-existent/wrong path) → the
suffix-match finds no sourcing line → test RED. Against a mutant that deletes
`scripts/lib/trusted-jq.sh` or removes one of its three function definitions →
the library-presence half → test RED. GREEN only when both scripts source the
real shared file and the file defines all three functions. This distinguishes
"the resolver is wired into BOTH decision-path scripts" from "one script quietly
reverted to bare-`jq` / a private copy" — the specific drift round-7's
shared-file choice exists to prevent. **Interaction with VP-025:** VP-024 proves
the helper is SOURCED; VP-025 proves every call site actually USES it — a script
can source `trusted-jq.sh` and still, by carelessness, call bare `jq` somewhere,
so neither VP subsumes the other (§6.11).

---

### VP-MUTANTS-SHARD-025 — No bare, un-resolved decision-path `jq` in either gate script (INV-AGG runtime-hardening parity) — **the load-bearing half; closes the pass-8 MED-1 jq-shim false-green**

**Property.** For EACH of `scripts/check-ci-gate.sh` and
`scripts/mutants-aggregate.sh`, every `jq` COMMAND invocation on the decision
path is written as `"${jq_bin}"` (the once-resolved, PATH-shim-resistant binary
from the shared `resolve_trusted_jq`), NEVER a bare `jq`. The SOLE permitted
exception is the single legitimate `command -v jq` inside
`scripts/lib/trusted-jq.sh`'s own `resolve_trusted_jq` — excluded by
name/line-anchor, NOT by a blanket allowlist of that whole file, so a SECOND
bare `jq` accidentally added to `trusted-jq.sh` outside that one resolution line
still fails. This is the RUNTIME half of §6.11 and the genuinely load-bearing
one: item 21 (VP-024) proves the resolver is sourced, but sourcing proves
nothing about whether each `jq` call site actually uses the resolved binary — a
bare `jq` anywhere on the decision path silently bypasses the whole resolver, so
a `$GITHUB_PATH`-prepended jq shim could forge every OK/FAIL line and, in
`mutants-aggregate.sh` specifically, fabricate the per-shard
`.caught`/`.missed`/`.timeout` counts feeding the pooled kill-rate → a
false-green mutation gate. This is the exact vector S-626-1 pass-59
(ADV-P59-LOW-001) fixed for `ci-gate` itself, now closed for the mutation gate.

**Mechanism.** Rust `#[test]` in `tests/ci_gate_completeness.rs`
(architect's §6.2 item 22,
`test_check_ci_gate_sh_and_mutants_aggregate_sh_have_no_bare_jq_invocations`)
— a static TEXT SCAN, no subprocess: for each script, scan every line for a `jq`
COMMAND invocation (first non-whitespace token, or the token immediately after a
`!`/`|`/`$(`/`if`/`while`/etc. is literally `jq`) and assert it is ALWAYS
`"${jq_bin}"`; default-deny — ANY bare `jq` found anywhere else fails, naming the
file and line; the one `command -v jq` in `resolve_trusted_jq` is excluded by
line-anchor. Kani/proptest/fuzz N/A (§1). A `#[test]` — the second of the two
that drive `EXPECTED_GUARD_TEST_COUNT` 58 → 60. Both scripts pass TODAY once the
ci-yml-design.md §3/§3a body lands (grep-confirmed against the design text:
every jq invocation already routes through `${jq_bin}`), so this is a REGRESSION
guard from day one, not a fixture proving a currently-broken state.

**Concrete assertion.** For `mutants-aggregate.sh`: every jq call
(`.run_outcome`/`.has_outcomes` on each sentinel, `jq empty`,
`.caught`/`.missed`/`.timeout`/`.unviable`/`.total_mutants`/`(.outcomes|length)`
on each shard's `outcomes.json`) is written `"${jq_bin}" …`. For
`check-ci-gate.sh`: same, all decision-path jq calls resolved. For
`trusted-jq.sh`: exactly one `command -v jq` (the resolver's own probe), no
other bare `jq`.

**RED proof** (against a temporary, untracked mutated `scripts/mutants-aggregate.sh`):
against a mutant that replaces a decision-path `"${jq_bin}" -r '.caught // 0'
"${shard}"` with a bare `jq -r '.caught // 0' "${shard}"` (the
PATH-shim-forgeable form — a `$GITHUB_PATH`-prepended `jq` shim would then
supply attacker-chosen `caught`/`missed`/`timeout` counts, forging a pooled
kill-rate `>= 90%` over a set that truly fails → **false-green mutation gate,
the exact pass-8 MED-1 vector**) → the scan finds a bare `jq` on the decision
path → test RED, naming the file and line. GREEN only when every call site
routes through the resolved binary. A second reinforcing mutant — a bare `jq`
added to `trusted-jq.sh` OUTSIDE the excluded `command -v jq` line — is also
RED, proving the exclusion is line-anchored, not a whole-file allowlist. This
makes `mutants-aggregate.sh` a RUNTIME structural peer of `check-ci-gate.sh`
(§6.11), complementing §6.8's Rust/YAML structural peering and closing the
mutation gate's jq-shim false-green end to end.

---

### Round-8 note — VP-026/027 are the TRUE M2-n analog for this job (evidence-source integrity)

`ci-gate`'s M2-n byte-pins its SINGLE decision input, `NEEDS_JSON:`, because a
hand-written decoy JSON literal would be invisible to a key-set pin alone.
`mutants-aggregate` has seven env inputs, so there is no one line to canonically
byte-pin the way `NEEDS_JSON:` is — but `STATUS_DIR`/`SHARD_DIR` are the closest
this job comes to a single-input `NEEDS_JSON:` analog: between them they locate the
ENTIRE evidence set (every status sentinel, every `outcomes.json`) the whole
decision reads. A PR that redirects them forges not one field but everything
downstream at once (Step 2 presence, Step 3 schema guards, Step 4 reconciliation
then all validate self-consistently against attacker-supplied data). The
pre-round-8 §6.8 M2-n disposition DECLINED a value pin here on the FAULTY claim
that `${VAR:?}` was "stronger than any static pin could assert"; F-H1 (HIGH)
corrected that — see architecture-delta §6.8's corrected M2-n row and its
"Declination re-audit (round-8)" table (which re-verified every OTHER
declined/N-A/accepted-residual §6.8/§6.11 row SOUND, two STRENGTHENED). VP-026/027
below are the two byte-VALUE pins that close it, mirroring VP-015's exact shape.

---

### VP-MUTANTS-SHARD-026 — `STATUS_DIR` env-wiring byte-VALUE pin (round-8, F-H1; the TRUE M2-n analog; mirrors VP-015)

**Property.** `mutants-aggregate`'s "Evaluate sharded mutation gate" step's `env:`
mapping binds `STATUS_DIR:` to exactly `${{ runner.temp }}/shard-status` — a
byte-exact structural pin on the value that LOCATES the entire status-sentinel
evidence set the decision reads. This is the evidence-source-integrity half of
F-H1's closure, distinct from and complementary to VP-018's env-KEY-SET pin
(which guards KEY add/remove/rename — the `BASH_ENV:`-class smuggled-child vector —
but never inspects this key's VALUE) and distinct from the script's own
`${STATUS_DIR:?…}` runtime guard (which proves abort-on-UNSET/EMPTY only, and gives
ZERO protection against a maliciously-but-validly-SET redirect). All three coexist
for `STATUS_DIR` exactly as VP-010's byte-VALUE pin, VP-018's key-set pin, and the
`ESCALATED` runtime comparison coexist for `ESCALATED`.

**Mechanism.** Rust structural pin parsed through `tests/common/wf.rs`
(`saphyr-parser` event stream) — architect's round-8 test (§6.2 item 23),
`test_mutants_aggregate_status_dir_env_wired`, in `tests/ci_gate_completeness.rs`.
Reads the `mutants-aggregate` eval-step's `env:` child mapping via the EXISTING
byte-exact env-child-value technique items 10/12 already use for
`ESCALATED:`/`EVENT_NAME:` (no new `wf.rs` primitive — architecture-delta §6.3),
asserting the value byte-for-byte (plain-scalar, `ScalarStyle::Plain`) against
`PINNED_MUTANTS_AGGREGATE_STATUS_DIR_LINE = "${{ runner.temp }}/shard-status"`.
**This IS a Rust `#[test]`** — one of the two that drive
`EXPECTED_GUARD_TEST_COUNT` 60 → 62. Kani/proptest/fuzz N/A (§1).

**Concrete assertion.** `mutants-aggregate` eval-step
`env.STATUS_DIR == "${{ runner.temp }}/shard-status"`.

**RED proof** (against a temporary, untracked mutated `ci.yml`):
- Redirect the value — e.g. `STATUS_DIR: ${{ github.workspace }}/x` — so the eval
  step reads sentinels from an attacker-controlled directory. A PR combining this
  redirect with a checked-in fake sentinel tree (fabricated `run_outcome`/
  `has_outcomes` values) and a fake `outcomes.json` reporting `missed=0` and
  `caught == MUTANT_COUNT` (a deterministically knowable target, since
  `MUTANT_COUNT` is itself a plaintext PR-visible env value) would produce a
  100%-caught **FALSE PASS** (exit 0) under the mutant while every real shard
  result is silently bypassed — the exact `NEEDS_JSON`-class false-green. The
  byte-VALUE pin sees the redirected value ≠ pin → test **RED**; the `${VAR:?}`
  runtime guard would NOT catch this (the value is non-empty). Correct value →
  GREEN.
- Drop the `STATUS_DIR:` key entirely → the pin's presence lookup fails → RED.
  Distinguishes "wired to the right evidence directory" from "not wired at all"
  (which at runtime would trip `${STATUS_DIR:?…}` — VP-018's key-set pin and the
  runtime guard cover THAT half; this VP covers the wired-but-redirected half).

---

### VP-MUTANTS-SHARD-027 — `SHARD_DIR` env-wiring byte-VALUE pin (round-8, F-H1; the TRUE M2-n analog; mirrors VP-015)

**Property.** `mutants-aggregate`'s "Evaluate sharded mutation gate" step's `env:`
mapping binds `SHARD_DIR:` to exactly `${{ runner.temp }}/shards` — the byte-exact
structural pin on the value that LOCATES the entire `outcomes.json` evidence set
the pooled kill-rate is computed from. Same F-H1 closure as VP-026, applied to the
sibling path; a SEPARATE test from VP-026 (the one-test-per-pinned-variable
convention items 10/12 established for `ESCALATED`/`EVENT_NAME`), so a future edit
that retargets only ONE of the two paths still fails a specifically-named test
rather than a shared one whose failure message must disambiguate which path moved.
Complementary to — never a substitute for — VP-018's key-set pin and the
`${SHARD_DIR:?…}` runtime guard, for the same reasons stated in VP-026.

**Mechanism.** Rust structural pin parsed through `tests/common/wf.rs` —
architect's round-8 test (§6.2 item 24), `test_mutants_aggregate_shard_dir_env_wired`,
in `tests/ci_gate_completeness.rs`, the direct sibling of VP-026's test. Reuses the
SAME byte-exact env-child-value technique (no new `wf.rs` code), asserting
plain-scalar (`ScalarStyle::Plain`) byte-equality against
`PINNED_MUTANTS_AGGREGATE_SHARD_DIR_LINE = "${{ runner.temp }}/shards"`. **This IS
a Rust `#[test]`** — the second of the two that drive `EXPECTED_GUARD_TEST_COUNT`
60 → 62. Kani/proptest/fuzz N/A (§1).

**Concrete assertion.** `mutants-aggregate` eval-step
`env.SHARD_DIR == "${{ runner.temp }}/shards"`.

**RED proof** (against a temporary, untracked mutated `ci.yml`):
- Redirect the value — e.g. `SHARD_DIR: ${{ github.workspace }}/x` — so the eval
  step pools `outcomes.json` from an attacker-controlled directory. A PR combining
  this with a checked-in fake `outcomes.json` reporting `missed=0` and
  `caught == MUTANT_COUNT` forges a pooled kill-rate of 100% over fabricated data
  while the real shard outcomes are silently bypassed → **FALSE PASS** (exit 0)
  under the mutant. The byte-VALUE pin sees the redirected value ≠ pin → test
  **RED**; `${VAR:?}` (non-empty value) would not catch it. Correct value → GREEN.
- Drop the `SHARD_DIR:` key entirely → presence lookup fails → RED (the
  not-wired-at-all half, covered here rather than left to the runtime guard alone).

---

### VP-MUTANTS-SHARD-028 — `MUTANT_COUNT` env-wiring byte-VALUE pin (round-9, LOW-1; closes the CIRCULAR reconciliation-disable; mirrors VP-026/027)

**Property.** `mutants-aggregate`'s "Evaluate sharded mutation gate" step's `env:`
mapping binds `MUTANT_COUNT:` to exactly `${{ needs.mutants-plan.outputs.mutant_count }}`
— a byte-exact structural pin on the value that feeds Step-4 reconciliation
(`total_scored != MUTANT_COUNT` → exit 1). This is the wiring-integrity half of the
round-9 LOW-1 closure, distinct from and complementary to VP-018's env-KEY-SET pin
(which guards KEY add/remove/rename but never inspects this key's VALUE) and distinct
from the runtime reconciliation itself (VP-008), whose correctness DEPENDS on
`MUTANT_COUNT` carrying `mutants-plan`'s independently-derived pre-count rather than a
hardcoded literal. All coexist for `MUTANT_COUNT` exactly as VP-026's byte-VALUE pin,
VP-018's key-set pin, and the runtime evidence-read coexist for `STATUS_DIR`.

**Why this pin is NOT redundant with reconciliation — the round-8 declination was
CIRCULAR.** Round-8's §6.8 M2-n disposition DECLINED a byte-VALUE pin on
`MUTANT_COUNT`, arguing its runtime reconciliation backstop (VP-008) was "stronger
than a string match." That reasoning is circular under the env-edit threat model
F-H1 itself adopted: reconciliation is keyed on `total_scored != MUTANT_COUNT`, so a
PR that simply HARDCODES `MUTANT_COUNT: 100` (a plaintext, PR-visible integer, and
the real pooled total is deterministically knowable) makes reconciliation pass
TRIVIALLY — the runtime backstop reads the very value the structural layer left
unpinned, so it validates the attacker's own number against itself. The result
disables sub-invariant 8's completeness guard: a dropped SURVIVOR would then pass
behind the forged reconciliation. The byte-VALUE pin closes this by requiring
`MUTANT_COUNT` to remain wired to `mutants-plan`'s independent output.

**Mechanism.** Rust structural pin parsed through `tests/common/wf.rs`
(`saphyr-parser` event stream) — architect's round-9 test (§6.2 item 25),
`test_mutants_aggregate_mutant_count_env_wired`, in `tests/ci_gate_completeness.rs`.
Reads the eval-step's `env:` child mapping via the EXISTING byte-exact
env-child-value technique items 10/12/23/24 already use (no new `wf.rs` primitive —
architecture-delta §6.3), asserting plain-scalar (`ScalarStyle::Plain`) byte-equality
against `PINNED_MUTANTS_AGGREGATE_MUTANT_COUNT_LINE = "${{ needs.mutants-plan.outputs.mutant_count }}"`.
**This IS a Rust `#[test]`** — one of the three that drive `EXPECTED_GUARD_TEST_COUNT`
62 → 65. Kani/proptest/fuzz N/A (§1).

**Concrete assertion.** `mutants-aggregate` eval-step
`env.MUTANT_COUNT == "${{ needs.mutants-plan.outputs.mutant_count }}"`.

**RED proof** (against a temporary, untracked mutated `ci.yml`):
- Hardcode the value — e.g. `MUTANT_COUNT: 100` (or `${{ github.run_number }}`, any
  editable-under-the-threat-model constant) — so the eval step reconciles against a
  PR-chosen number instead of `mutants-plan`'s independent pre-count. A PR setting
  this to equal the real pooled total the shards will produce makes Step-4
  reconciliation pass TRIVIALLY (`total_scored == MUTANT_COUNT` holds by
  construction), silently disabling sub-invariant 8's completeness guard — a dropped
  survivor would then pass the gate. Crucially, the runtime reconciliation stays
  deceptively GREEN under this mutant (it reads the hardcoded value and finds it
  self-consistent); ONLY the byte-VALUE pin sees the hardcoded value ≠ pin → test
  **RED**. This is the exact demonstration that the pin catches a false-green the
  runtime backstop cannot. Correct value → GREEN.
- Drop the `MUTANT_COUNT:` key entirely → presence lookup fails → RED (distinguishes
  "wired to the independent pre-count" from "not wired at all"; VP-018's key-set pin
  covers the KEY-removal half, this VP covers the wired-but-forged half).

---

### VP-MUTANTS-SHARD-029 — `OVERALL_DIFF_LINES` env-wiring byte-VALUE pin (round-9, LOW-1; retires the last declined env-value pin for this key; mirrors VP-026/027)

**Property.** `mutants-aggregate`'s eval-step `env:` mapping binds
`OVERALL_DIFF_LINES:` to exactly `${{ needs.mutants-plan.outputs.overall_diff_lines }}`
— the byte-exact structural pin on the value Step 5's base-ref-drift guard consumes.
Complementary to — never a substitute for — VP-018's key-set pin and VP-013's runtime
`^[0-9]+$` regex guard: VP-013 guards only the malformed/empty-VALUE handling of
whatever value arrives, while THIS pin guards that the value is actually wired to
`mutants-plan`'s output rather than a hardcoded constant. The round-8 declination of
this pin was narrowly SOUND (VP-013 never claimed redirect-immunity) but left the
wiring itself unpinned; round-9 retires the declination so no eval-step env value is
left value-unpinned — closing the class, not just the individual key.

**Mechanism.** Rust structural pin parsed through `tests/common/wf.rs` —
architect's round-9 test (§6.2 item 26),
`test_mutants_aggregate_overall_diff_lines_env_wired`, in
`tests/ci_gate_completeness.rs`. Reuses the SAME byte-exact env-child-value technique
(no new `wf.rs` code), asserting plain-scalar (`ScalarStyle::Plain`) byte-equality
against `PINNED_MUTANTS_AGGREGATE_OVERALL_DIFF_LINES_LINE = "${{ needs.mutants-plan.outputs.overall_diff_lines }}"`.
**This IS a Rust `#[test]`** — the second of the three that drive
`EXPECTED_GUARD_TEST_COUNT` 62 → 65. Kani/proptest/fuzz N/A (§1).

**Concrete assertion.** `mutants-aggregate` eval-step
`env.OVERALL_DIFF_LINES == "${{ needs.mutants-plan.outputs.overall_diff_lines }}"`.

**RED proof** (against a temporary, untracked mutated `ci.yml`):
- Hardcode the value — e.g. `OVERALL_DIFF_LINES: 500` — so Step 5's base-ref-drift
  guard evaluates a PR-chosen constant instead of the real diff line count. Combined
  with an already-reconciled-to-zero PR, a hardcoded nonzero value can convert a
  legitimate base-ref-drift FAIL into a "legitimate-zero-mutants OK" — the bounded
  LOW residual round-8 named. The byte-VALUE pin sees the hardcoded value ≠ pin →
  test **RED** (VP-013's regex guard passes a well-formed hardcoded integer, so it
  does NOT catch this — the pin is the load-bearing check for the wiring). Correct
  value → GREEN.
- Drop the `OVERALL_DIFF_LINES:` key entirely → presence lookup fails → RED.

---

### VP-MUTANTS-SHARD-030 — `PLAN_RESULT` env-wiring byte-VALUE pin (round-9, LOW-1; retires the last declined env-value pin for this key; mirrors VP-026/027)

**Property.** `mutants-aggregate`'s eval-step `env:` mapping binds `PLAN_RESULT:` to
exactly `${{ needs.mutants-plan.result }}` — the byte-exact structural pin on the
value Step 0.5 consumes (`PLAN_RESULT != "success"` → diagnostics short-circuit).
Complementary to VP-018's key-set pin and to the round-8 newly-traced Step-2
sentinel-presence interlock (a genuinely-failed `mutants-plan` prevents the shard
matrix from running, so Step 2 fails closed against genuinely-absent artifacts). The
round-8 declination of this pin was SOUND (a hardcoded `PLAN_RESULT: "success"`
cannot manufacture a false PASS on its own, because Step 2's presence check
independently fails closed), but round-9 retires it to eliminate the declined class
entirely: the byte-VALUE pin makes the wiring itself defended rather than relying
solely on a downstream interlock.

**Mechanism.** Rust structural pin parsed through `tests/common/wf.rs` —
architect's round-9 test (§6.2 item 27),
`test_mutants_aggregate_plan_result_env_wired`, in `tests/ci_gate_completeness.rs`.
Reuses the SAME byte-exact env-child-value technique (no new `wf.rs` code), asserting
plain-scalar (`ScalarStyle::Plain`) byte-equality against
`PINNED_MUTANTS_AGGREGATE_PLAN_RESULT_LINE = "${{ needs.mutants-plan.result }}"`.
**This IS a Rust `#[test]`** — the third of the three that drive
`EXPECTED_GUARD_TEST_COUNT` 62 → 65. Kani/proptest/fuzz N/A (§1).

**Concrete assertion.** `mutants-aggregate` eval-step
`env.PLAN_RESULT == "${{ needs.mutants-plan.result }}"`.

**RED proof** (against a temporary, untracked mutated `ci.yml`):
- Hardcode the value — e.g. `PLAN_RESULT: success` — a decoy that papers over a
  genuinely-failed `mutants-plan` by making Step 0.5 read `"success"` regardless of
  the plan job's real result. On its own this cannot forge a full PASS (Step 2's
  sentinel-presence interlock fails closed against the absent shard artifacts, and —
  post round-8 — an attacker cannot redirect `STATUS_DIR`/`SHARD_DIR` to paper over
  that absence), but it defeats Step 0.5's fail-fast diagnostics wiring. The
  byte-VALUE pin sees the hardcoded value ≠ pin → test **RED**. Correct value →
  GREEN. This is a defense-in-depth WIRING pin: it makes the Step-0.5 interlock's
  input explicit rather than trusting the downstream sentinel-presence check alone.
- Drop the `PLAN_RESULT:` key entirely → presence lookup fails → RED.

---

## 3A. The three INV-COMPLETE sub-cases — each distinguished by a dedicated RED proof

The round-1 sentinel redesign turned INV-COMPLETE from a single ambiguous
`outcomes.json`-count check into a presence gate (Part B) + a
`(run_outcome, has_outcomes)` interpretation table (Part C). The task requires
that the THREE reachable "did this shard's work happen?" states each have a
distinguishing RED proof. They do, spread across VP-002/006/007:

| # | INV-COMPLETE sub-case | Sentinel/data shape | Correct verdict | Owning VP | Distinguishing RED proof (mutant → wrong verdict) |
|---|---|---|---|---|---|
| 1 | **infra-cancel / never-scheduled** | sentinel **ABSENT** for some index (dead runner, cancelled job, or a bug in the always-run sentinel-write step) | **FAIL** (Part B), naming the index | VP-002 (T2) | "missing sentinel ⇒ treat shard as empty/zero and continue" mutant → exit 0 over the healthy remainder; correct Part B → exit 1 naming index 3 |
| 2 | **harness-crash** | sentinel PRESENT, `run_outcome != success` (e.g. `failure`), `has_outcomes == false` | **FAIL** (Part C), naming the index — harness crash | VP-006 | pre-fix "0 outcomes.json + non-empty diff ⇒ exit 0" count-based mutant → false-green exit 0; correct Part C → exit 1 (also: `.conclusion`-keyed mutant reads crash as success) |
| 3 | **legit-empty** | sentinel PRESENT, `run_outcome == success`, `has_outcomes == false` | **OK**, contributes 0 | VP-007 | "any `has_outcomes==false` ⇒ FAIL" mutant → false-red exit 1 on a routine small PR; correct Part C → exit 0 |

**Why the three are genuinely distinguished, not merely enumerated:** cases 2
and 3 share the SAME `has_outcomes == false` and differ ONLY in `run_outcome`
(`failure` vs `success`); VP-006 and VP-007 together force the aggregator to
branch on `run_outcome` in that state — a mutant that collapses the two into one
verdict is RED under exactly one of the pair. Case 1 is orthogonal (the sentinel
never arrives at all), caught one stage earlier by Part B's presence loop
(VP-002), before Part C's interpretation table is ever consulted. No single
mutant can satisfy all three VPs, and each VP's fixture is constructed so its
sole point of failure is the sub-case it owns (the "other" shards in each
fixture are healthy and reconciling, so they cannot mask or manufacture the
signal under test).

---

## 4. Coverage matrix — VPs → the +27 `EXPECTED_GUARD_TEST_COUNT` delta (38 → 65)

Current-baseline `EXPECTED_GUARD_TEST_COUNT = 38` (verified this session:
`tests/ci_gate_completeness.rs:8156`). Across all NINE F2 passes the delta is
**+27 → 65** (orig F2 `38→43`, round-1 `43→48`, round-2 `48→49`, round-3
`49→51`, round-4 `51→58`, round-5/round-6 add none, round-7 `58→60`, round-8
`60→62`, round-9 `62→65`; architecture-delta §6.2/§6.5/§6.6/§6.7/§6.9/§6.11 +
§6.8 round-8 addendum + round-9 items 25-27), naming exactly twenty-seven new
`#[test]` functions. The mapping is NOT 1 VP = 1 test:
- INV-COMPLETE Part B owns two tests (T2+T3 → VP-002).
- INV-ESCALATE (VP-003) owns ZERO of the twenty — its mechanism is a fixture on
  the aggregator-subprocess harness, counted by a SEPARATE denominator.
- VP-012 (`print_allowed_skips` self-test), VP-013 (`OVERALL_DIFF_LINES`
  malformed guard), and VP-014 (Step-0 fail-closed event guard) also own ZERO
  `#[test]` functions — VP-012 is a `check-ci-gate.sh` self-test check counted by
  the sibling `EXPECTED_PRINT_ALLOWED_SKIPS_CHECKS = 1`, while VP-013 and VP-014
  are aggregator-harness fixtures counted by `EXPECTED_MUTANTS_AGG_FIXTURES` — all
  orthogonal to `EXPECTED_GUARD_TEST_COUNT`.
- **Round-3's two NEW `#[test]` functions are VP-015 (`EVENT_NAME` env-wiring
  byte-pin) and VP-016 (`spec-guard` self-test-step pin)** — the +2 that takes
  the count 49 → 51.
- **Round-4's SEVEN NEW `#[test]` functions are VP-017..023** — the five
  structural-peer pins (VP-017 M2-i / VP-018 M2-o / VP-019 AC-001 / VP-020 M2-q /
  VP-021 per-step `if:`, §6.8) plus the two reconciliation-independence proofs
  (VP-022 exact-equality-symmetry / over-count, VP-023 completeness-over-quality,
  §6.10) — the +7 that takes the count 51 → 58.
- **Round-7's two NEW `#[test]` functions are VP-024 (both scripts source the
  shared `scripts/lib/trusted-jq.sh` helper) and VP-025 (neither gate script has
  a bare, un-resolved decision-path `jq` call), §6.11** — the +2 that takes the
  count 58 → 60. Both are static script-text scans (no subprocess), the
  RUNTIME-hardening-parity peers of `check-ci-gate.sh` (complementing §6.8's
  Rust/YAML structural peers), closing the pass-8 MED-1 jq-shim false-green.
- **Round-8's two NEW `#[test]` functions are VP-026
  (`test_mutants_aggregate_status_dir_env_wired`) and VP-027
  (`test_mutants_aggregate_shard_dir_env_wired`), §6.8 corrected M2-n row / items
  23-24 (F-H1)** — the +2 that takes the count 60 → 62. Both are byte-VALUE
  structural pins on `ci.yml`'s parsed YAML (no subprocess, no bash fixture),
  mirroring VP-015's shape, closing the F-H1 evidence-source-redirect false-green.
- **Round-9's three NEW `#[test]` functions are VP-028
  (`test_mutants_aggregate_mutant_count_env_wired`), VP-029
  (`test_mutants_aggregate_overall_diff_lines_env_wired`), and VP-030
  (`test_mutants_aggregate_plan_result_env_wired`), §6.8 MIRRORED M2-n row / items
  25-27 (LOW-1)** — the +3 that takes the count 62 → 65. All three are byte-VALUE
  structural pins on `ci.yml`'s parsed YAML (no subprocess, no bash fixture),
  mirroring VP-026/027's shape, retiring the last three declined env-value pins so
  ALL SEVEN eval-step env values carry BOTH a key-set pin (VP-018) AND an individual
  byte-VALUE pin. VP-028 is the load-bearing one: it closes the CIRCULAR
  reconciliation-disable (hardcoding `MUTANT_COUNT` to the real pooled total
  trivially satisfies Step-4 reconciliation, and only the byte-VALUE pin — not the
  runtime backstop — catches it).
  **VP-008's test name is RESTORED
  round-5 to the round-1 original
  `..._fails_closed_on_mutant_count_reconciliation_mismatch` (round-4 had renamed
  it to `..._emits_non_blocking_warning`; round-5 reverts name + assertion back to
  exit 1) — an in-body rename + assertion revert of an EXISTING `#[test]` (still
  R3), NOT a new/removed function, so it drives NO count change. VP-022/023's test
  slots are likewise re-scoped in-body (same names/slots, new fixtures +
  assertions, all now rc==1), NO count change.**

Twenty-seven `#[test]` functions map to VP-001..011 + VP-015..030 (one-to-one
except T2/T3→VP-002); VP-003/012/013/014 are the four non-`#[test]` coverages.
This is the clean matrix F6 needs:

| New `#[test]` (drives +1 to `EXPECTED_GUARD_TEST_COUNT`) | VP | Invariant | Mechanism | Round |
|---|---|---|---|---|
| T1 `test_mutants_aggregate_sums_not_averages_shard_kill_rates` | VP-001 (+ VP-003 rides this harness) | INV-AGG (+ INV-ESCALATE fixture) | bash subprocess (2+ fixtures) | orig |
| T2 `test_mutants_aggregate_fails_closed_on_missing_shard` | VP-002 | INV-COMPLETE Part B | bash subprocess (sentinel) | orig |
| T3 `test_mutants_aggregate_fails_closed_on_duplicate_shard_artifact` | VP-002 | INV-COMPLETE Part B | bash subprocess (sentinel) | orig |
| T4 `test_mutants_plan_job_exists_and_is_pr_only` | VP-004 | structural pin | Rust structural (wf.rs) | orig |
| T5 `test_mutants_aggregate_expected_shards_matches_matrix_shard_count` | VP-005 | structural pin | Rust structural (wf.rs) | orig |
| R1 `test_mutants_aggregate_fails_closed_when_all_shards_crash_under_continue_on_error` | VP-006 | INV-COMPLETE Part C (crash) | bash subprocess (sentinel) | round-1 |
| R2 `test_mutants_aggregate_ok_when_shards_are_legitimately_empty` | VP-007 | INV-COMPLETE Part C (empty) | bash subprocess (sentinel) | round-1 |
| R3 `test_mutants_aggregate_fails_closed_on_mutant_count_reconciliation_mismatch` (name+assertion RESTORED round-5 to round-1 original; round-4 had temporarily renamed to `..._emits_non_blocking_warning`) | VP-008 | INV-AGG sub-inv 8 (HARD FAIL, exact equality both directions) | bash subprocess (sentinel) | round-1 (warning-only round-4, restored round-5) |
| R4 `test_always_run_with_if_exceptions_disjoint_and_tautological` | VP-009 | structural cross-check (MED-1) | Rust structural + subprocess | round-1 |
| R5 `test_mutants_plan_escalated_output_wired_to_aggregate_env` | VP-010 | structural pin (MED-2, reframed round-2) | Rust structural (wf.rs) | round-1 |
| R6 `test_skip_tolerant_surface_is_consistently_empty_by_design` | VP-011 | three-way empty-consistency (HIGH-1 a+b) | Rust `.is_empty()` + subprocess | round-2 |
| R7 `test_mutants_aggregate_event_name_env_wired` | VP-015 | structural wiring pin (HIGH-1 defense-in-depth) | Rust structural (wf.rs) | round-3 |
| R8 `test_spec_guard_contains_mutants_aggregate_self_test_step` | VP-016 | structural extraction-wiring pin (§6.2a) | Rust structural (wf.rs) | round-3 |
| R9 `test_mutants_aggregate_decision_step_run_line_is_pinned` | VP-017 | structural anti-neutering (M2-i analog, §6.8) | Rust structural (wf.rs) | round-4 |
| R10 `test_mutants_aggregate_decision_step_env_key_set_is_pinned` | VP-018 | structural anti-neutering (M2-o analog, §6.8) | Rust structural (wf.rs) | round-4 |
| R11 `test_mutants_aggregate_step_invokes_mutants_aggregate_script` | VP-019 | structural invocation assertion (AC-001 analog, §6.8) | Rust structural (wf.rs) | round-4 |
| R12 `test_mutants_aggregate_job_block_has_no_key_node_properties` | VP-020 | structural node-property scan (M2-q analog, §6.8) | Rust structural (wf.rs) | round-4 |
| R13 `test_mutants_aggregate_step_level_if_values_are_all_always` | VP-021 | structural per-step `if:`-VALUE pin (new gap, §6.8) | Rust structural (wf.rs) | round-4 |
| R14 `test_mutants_aggregate_reconciliation_mismatch_does_not_mask_kill_rate_fail` | VP-022 | INV-AGG sub-inv 8 exact-equality symmetry / over-count (§6.10, re-scoped round-5) | bash subprocess (sentinel) | round-4 (re-scoped round-5) |
| R15 `test_mutants_aggregate_reconciliation_mismatch_does_not_block_passing_pr` | VP-023 | INV-AGG sub-inv 8 completeness-over-quality (§6.10, inverted round-5) | bash subprocess (sentinel) | round-4 (inverted round-5) |
| R16 `test_check_ci_gate_sh_and_mutants_aggregate_sh_source_shared_trusted_jq_helper` | VP-024 | INV-AGG runtime-hardening parity — SOURCE wiring (§6.11 item 21) | Rust static script-text scan | round-7 |
| R17 `test_check_ci_gate_sh_and_mutants_aggregate_sh_have_no_bare_jq_invocations` | VP-025 | INV-AGG runtime-hardening parity — no-bare-`jq` usage (§6.11 item 22) | Rust static script-text scan | round-7 |
| R18 `test_mutants_aggregate_status_dir_env_wired` | VP-026 | INV-AGG evidence-source integrity — `STATUS_DIR` byte-VALUE pin (§6.8 corrected M2-n / item 23, F-H1) | Rust structural (wf.rs) | round-8 |
| R19 `test_mutants_aggregate_shard_dir_env_wired` | VP-027 | INV-AGG evidence-source integrity — `SHARD_DIR` byte-VALUE pin (§6.8 corrected M2-n / item 24, F-H1) | Rust structural (wf.rs) | round-8 |
| R20 `test_mutants_aggregate_mutant_count_env_wired` | VP-028 | INV-AGG env-wiring integrity — `MUTANT_COUNT` byte-VALUE pin (§6.8 MIRRORED M2-n / item 25, LOW-1; closes CIRCULAR reconciliation-disable) | Rust structural (wf.rs) | round-9 |
| R21 `test_mutants_aggregate_overall_diff_lines_env_wired` | VP-029 | INV-AGG env-wiring integrity — `OVERALL_DIFF_LINES` byte-VALUE pin (§6.8 MIRRORED M2-n / item 26, LOW-1) | Rust structural (wf.rs) | round-9 |
| R22 `test_mutants_aggregate_plan_result_env_wired` | VP-030 | INV-AGG env-wiring integrity — `PLAN_RESULT` byte-VALUE pin (§6.8 MIRRORED M2-n / item 27, LOW-1) | Rust structural (wf.rs) | round-9 |
| **Σ = 27** → `EXPECTED_GUARD_TEST_COUNT: 38 → 65` | | | | |

**Two existing tests TRANSFORMED in-body this round (NO count change, per the
round-2 task brief's load-bearing "transformed, not deleted/weakened"
distinction):** `test_ci_gate_decision_matches_job_level_if_for_every_needs_
member` (its `saw_positive_branch` hard assert becomes conditional on
`PINNED_ALLOWED_SKIP_IF_EXPRESSIONS` being populated — empty ⇒ assert
`!saw_positive_branch`) and `test_allowed_skips_members_require_job_level_
conditional_in_ci_yml` (its `!allowed_skips.is_empty()` hard assert becomes a
three-way empty-consistency check across the bash + two Rust lists). These are
the DEFENSE-IN-DEPTH transforms behind VP-011's PRIMARY dedicated test (R6); they
do not increment the count.

**Round-3 also transforms Fixture 14 in-body (NO `EXPECTED_FIXTURES` count
change) and adds the `is_allowed_skip` return-1 guard** — folded under VP-012 (see
that VP's round-3 note); neither adds a `#[test]`, so `EXPECTED_GUARD_TEST_COUNT`
is unaffected by them. Separately, round-3 renames
`test_allowed_skips_has_exactly_three_code_level_references` →
`...four...` and moves its pinned count `3 → 4` (fixtures 4/5 unified into ONE
shared `run_fixture_with_synthetic_skip_tolerant_job` wrapper) — an in-body
rename of an EXISTING test, NOT a new `#[test]`, so likewise no count change.

**Non-`#[test]` fixture counters (orthogonal to the 58):**
- **VP-012** → `EXPECTED_PRINT_ALLOWED_SKIPS_CHECKS = 1` (sibling self-test suite
  `run_print_allowed_skips_self_test` in `scripts/check-ci-gate.sh`, §6.1). NOT
  folded into `EXPECTED_FIXTURES` (which stays `14`).
- **VP-013 + VP-014 + VP-003 + VP-008 + VP-022 + VP-023** →
  `EXPECTED_MUTANTS_AGG_FIXTURES` fixtures on the extracted
  `scripts/mutants-aggregate.sh --self-test` (§2/§6.2a), alongside the Step-0.5
  `PLAN_RESULT != "success"` fixture (the `--list` tooling-error hardening's
  landing site). **Round-4 raised the provisional floor `8 → 10`; round-5/round-6
  kept it at `10`; round-7 raises it `10 → 12`** (architecture-delta §6.2a
  round-7, LOW-2 floor-arithmetic correction): the old floor derivation ("2
  header + 1 per item among 1/2/3/6/7/8 + 2 for 19/20 = 10") undercounted on TWO
  independent grounds — **(a)** item 1
  (`test_mutants_aggregate_sums_not_averages_shard_kill_rates` / VP-001) needs a
  STRADDLING PAIR of fixtures (1A average-passes-pooled-fails AND 1B
  average-fails-pooled-passes), not one, since a single-direction construction
  cannot distinguish "sums correctly" from "merely fails whenever shards are
  asymmetric" (`+1` for fixture 1B); and **(b)** the formula never counted the
  Step-0.5 `PLAN_RESULT != "success"` fixture at all (`+1`). VP-001's own entry
  already specifies both 1A and 1B — round-7 is the floor-count reconciliation to
  match, not a fixture-shape change. The reconciliation fixtures on this same
  aggregator harness are unchanged in COUNT — the under-count mismatch case
  (VP-008 = VP-023's shared fixture: `MUTANT_COUNT=101`, pooled `100`, healthy
  partial `>=90%` → exit **1** + mismatch message + NO pass line) and the
  over-count case (VP-022: `MUTANT_COUNT=100`, pooled `101`, healthy `>=90%` →
  exit **1** + both numbers named). Note VP-022/023 ALSO drive `#[cfg(unix)]` Rust
  `#[test]` functions (R14/R15, counted in `EXPECTED_GUARD_TEST_COUNT`) — those
  Rust tests are the subprocess DRIVERS that invoke
  `scripts/mutants-aggregate.sh`; the aggregator's OWN `--self-test` additionally
  exercises the same reconciliation scenarios as script-internal fixtures.
  `EXPECTED_FIXTURES` (the SEPARATE `scripts/check-ci-gate.sh --self-test`
  denominator) is UNCHANGED at `14` (round-7's extraction to
  `scripts/lib/trusted-jq.sh` is a pure relocation of already-tested functions;
  `EXPECTED_JQ_TRUST_CHECKS` stays `17`). `12` remains a FLOOR, not a claim of
  exactness (10 was a KNOWN undercount that must not ship as the stated floor);
  **F4 finalizes the exact `EXPECTED_MUTANTS_AGG_FIXTURES` value** against the
  fixed-denominator self-check pattern `EXPECTED_FIXTURES` already establishes.

**INV-ESCALATE / VP-003 — where its count lives (explicit, not hidden):** no F2
pass promoted INV-ESCALATE to a dedicated `#[test]` slot — the twenty new tests
are the structural-pin + behavioral/structural tests above, none named for
escalation. VP-003's RED proof rides the SAME aggregator-subprocess mechanism as
T1, placed as a **distinct fixture case inside T1's harness** (an added
fixture/assertion within an existing `#[test]` fn does NOT increment
`EXPECTED_GUARD_TEST_COUNT` — the count pins `#[test]` FUNCTIONS, not fixtures),
AND — per §2/§6.2a — as a fixture in `scripts/mutants-aggregate.sh --self-test`,
counted by `EXPECTED_MUTANTS_AGG_FIXTURES`, orthogonal to
`EXPECTED_GUARD_TEST_COUNT`. The prior F2 draft's "+6 promote-to-dedicated-test"
alternative is **withdrawn**. F6's `EXPECTED_GUARD_TEST_COUNT` denominator must
be **65** (the architect's nine-pass history log: `38→43` orig, `43→48`
round-1, `48→49` round-2, `49→51` round-3, `51→58` round-4, round-5/round-6 add
none, `58→60` round-7, `60→62` round-8, `62→65` round-9), and the sibling denominators `EXPECTED_FIXTURES = 14`,
`EXPECTED_PRINT_ALLOWED_SKIPS_CHECKS = 1`, `EXPECTED_JQ_TRUST_CHECKS = 17`
(unchanged by round-7's pure relocation into `scripts/lib/trusted-jq.sh`), and
`EXPECTED_MUTANTS_AGG_FIXTURES` (F4-set, provisional floor `12`) each
independently.

**`EXPECTED_FIXTURES` — this cycle's effect is `13 → 14`, NOT a pre-cycle
baseline of 14 (LOW-2 framing correction, restated for the F6 matrix, not new
VPs):** `scripts/check-ci-gate.sh`'s `EXPECTED_FIXTURES: 13 → 14 (new Fixture 14
added by THIS cycle for the emptied-ALLOWED_SKIPS bash-3.2 nounset self-test)`
— Fixture 14 `empty-allowed-skips-any-skip-fails-closed` proves the now-empty
production `ALLOWED_SKIPS=()` fails closed on any skip and does not crash under
`nounset`; also the repurposed/rekeyed fixtures 4/5/12/13 (architecture-delta
§6.1). Those are `check-ci-gate.sh` decision-function fixtures (the S-CIGATE
lineage), governed by their own `EXPECTED_FIXTURES` pin. The 13→14 transition
happens in round-1 (Fixture 14's creation); `EXPECTED_FIXTURES` is then stable at
**14** through rounds 2-9 (round-3 changes Fixture 14's BODY — a 4th
`check_fixture` message-substring argument, VP-012 note — but not the COUNT). Do
NOT describe the cycle as leaving `EXPECTED_FIXTURES` "unchanged at 14": the cycle
creates Fixture 14 (13→14); only the individual post-round-1 rounds add none. Round-2's `print_allowed_skips` fix
does NOT touch `EXPECTED_FIXTURES`:
it adds the SEPARATE sibling `EXPECTED_PRINT_ALLOWED_SKIPS_CHECKS = 1` (VP-012),
because `check_fixture`/`EXPECTED_FIXTURES` test `evaluate_needs()`'s
JSON-payload decision while `print_allowed_skips`'s output shape is a different
function's behavior — the same category distinction this file already draws
between `EXPECTED_FIXTURES` and `EXPECTED_JQ_TRUST_CHECKS`. Listed here only so
F6's overall denominator accounting is complete.

---

## 5. RED-proof confirmation (every VP distinguishes correct from its specific false-green/false-red)

| VP | Correct behavior | The specific false-green/false-red it must catch | RED proof mechanism |
|---|---|---|---|
| 001 (INV-AGG) | pooled sum, 80% → exit 1 | averaging shard % → 90% → exit 0 (silent pass of an 80% PR) | Fixture 1A: average≥90 ∧ pooled<90 → assert exit 1. Reinforced by 1B (opposite direction). |
| 002 (INV-COMPLETE Part B) | missing/extra SENTINEL → exit 1 naming index | missing→treat-empty (shrink denom) or `<`-only accepts extras → exit 0 | T2: 7 healthy sentinels, omit #3 → assert exit 1 names 3. T3: 9 sentinels → assert exit 1 (`-ne`, not `<`). |
| 003 (INV-ESCALATE) | escalated → exit 1 at Step 1 | escalation check dropped / bare-truthy string bug → falls through healthy shards → exit 0 (escalated PR merges) | `ESCALATED=true` + full healthy 8-sentinel set reconciling ≥90% → assert exit 1 + escalation msg, no OK msg. |
| 004 (plan pin) | PR-only `if:`, `ci-gate`-excluded | plan runs on push, or is silently wired required/unexcluded | temp-ci.yml: drop/alter `if:` → RED; mis-wire needs/excluded → partition RED. |
| 005 (cross-check) | `len(matrix.shard) == EXPECTED_SHARDS` | matrix widened, denominator forgotten → extra shards permanently unchecked | temp-ci.yml: matrix→10, EXPECTED_SHARDS=8 → assert RED (and vice-versa). |
| **006 (Part C crash / HIGH-2)** | all sentinels present, all `failure`+no-outcomes → exit 1 (harness crash) | **pre-fix "0 outcomes.json + non-empty diff ⇒ exit 0" mutant → exit 0 (GREEN gate, zero mutants verified)** | R1: 8 sentinels `failure`/`has_outcomes=false`, non-empty diff, MUTANT_COUNT>0 → assert exit 1 + crash msg, no OK line. Second mutant: `.conclusion`-keyed check → RED. |
| 007 (Part C empty / HIGH-1) | some sentinels `success`+no-outcomes → contribute 0 → exit 0 | "any has_outcomes=false ⇒ FAIL" mutant → exit 1 (routine small PR blocked) | R2: 3 empty(success)+5 data reconciling 90% → assert exit 0, no FAIL/missing/crash. |
| 008 (INV-AGG sub-8, **HARD FAIL, round-5 restored**) | `total_scored != MUTANT_COUNT` (exact eq, both directions) → name both + **exit 1**, do NOT reach Step 6 | **drop-`return-1` mutant (round-4 warn-and-continue / any Step-4 fall-through) → dropped survivor passes behind healthy 95% partial set → exit 0 (false-green)**; or a mutant dropping the diagnostic → silent mismatch | R3 (restored): total_scored=100, MUTANT_COUNT=101, partial kill-rate 95% → assert exit 1 + mismatch names 101&100 + NO "gate passed" line. |
| 009 (WITH_IF cross-check) | keys disjoint from skip-lists; value == exact `always()` | dual-listed job (contradictory categories) or `always() && …` compound smuggles a conditional skip | R4: add job to both lists → intersection RED; value→`always() && github.ref==…` → tautology RED (substring look-alike defeated by exact eq). |
| 010 (escalation wiring — reframed round-2) | both sides byte-exact `${{ … escalated }}` | typo'd output/env key → GHA returns "" → `[ ""="true" ]` never fires → escalation silently disabled → on a >120 PR the oversized gate RUNS (**fail-CLOSED / wasted-CI, NOT merge-unverified**); opposite value error (`ESCALATED` = literal `true` when it should not) also caught | R5: temp-ci.yml typo either side → byte-equality RED (wiring-integrity pin). |
| 011 (skip-tolerant empty-consistency) | all three lists empty AND agree | silent partial-empty (one list emptied, another left stale) → desync | R6: re-add a job to a Rust list w/o restoring bash `ALLOWED_SKIPS` → `.is_empty()` RED; restore a bash entry w/ Rust empty → `--print-allowed-skips` non-empty → zero-lines RED. |
| 012 (`print_allowed_skips` empty) | `[]` (zero lines) over empty `ALLOWED_SKIPS=()` | drop the empty-array short-circuit → `[""]` phantom blank line; or delete the sole check → shrunken-denominator false-green | self-test: assert empty output; fixed-denominator `EXPECTED_PRINT_ALLOWED_SKIPS_CHECKS=1` catches a deleted check. |
| 013 (`OVERALL_DIFF_LINES` malformed) | malformed-but-SET → exit 1 (base-ref-drift guard cannot evaluate) | drop `^[0-9]+$` guard → `[ "abc" -eq 0 ]` errors → `if` false → falls to "OK: non-empty diff" exit 0 (base-ref drift silently passed) | aggregator fixture: `total_scored=0`, `MUTANT_COUNT=0`, `OVERALL_DIFF_LINES="abc"` → assert exit 1, no OK line. |
| **014 (Step-0 fail-CLOSED event guard / HIGH-1)** | empty/unknown `EVENT_NAME` → exit 1 (default arm); `push` → exit 0 (known no-op) | **revert to fail-OPEN `[ "$EVENT_NAME" != "pull_request" ] → exit 0` mutant → empty EVENT_NAME on a real PR exits 0 with ZERO shard inspection (false-green)**; or a careless `*) return 0` catch-all reopens it | agg fixture `event-name-empty-fails-closed` (`EVENT_NAME=""` → assert exit 1 + `"FAIL: EVENT_NAME"`) vs `event-name-push-is-ok-noop` (`EVENT_NAME="push"` → assert exit 0 + `"OK: not a pull_request event"`) — the two edges together pin the allowlist. |
| 015 (`EVENT_NAME` env wiring) | eval-step `env.EVENT_NAME == ${{ github.event_name }}` | typo'd/dropped env key → GHA returns "" → (fixed Step 0 FAILs, but wiring break unnamed) | R7: temp-ci.yml alter/drop the key → byte-equality/presence RED (input-side mirror of VP-010). |
| 016 (`spec-guard` self-test step) | `spec-guard` runs `bash scripts/mutants-aggregate.sh --self-test`, `run:` byte-pinned | remove step → self-test suite defined but never run (dead-code false-green); wrong script/flag satisfies a bare substring check | R8: temp-ci.yml drop step → anchor RED; corrupt `run:` (drop `--self-test` / wrong script) → byte-pin RED; step-key-set 12↛13 mismatch → generic key-set test RED. |
| **017 (decision-step run-line, §6.8 M2-i)** | eval-step `run:` == `bash scripts/mutants-aggregate.sh` byte-exact | **`\|\| true`/`; exit 0`/`\| cat` suffix silently neuters the gate step (exit code meaningless, job still `success`)** | R9: temp-ci.yml append `\|\| true` → normalized ≠ pin → RED; wrong script path → byte inequality RED. |
| **018 (decision-step env key-set, §6.8 M2-o)** | eval-step `env:` == exactly the 7 pinned keys (set equality) | **smuggled `BASH_ENV:` (or any 8th key) sourced before the script runs — shim ends shell with `exit 0`** | R10: temp-ci.yml add `BASH_ENV:` → key set ≠ 7-key pin → RED; remove/rename any pinned key → RED (default-deny both ways). |
| **019 (invocation assertion, §6.8 AC-001)** | job block contains `scripts/mutants-aggregate.sh` ∧ job `if:` contains `always()` | script no longer invoked (a byte-pin retargeted at a removed step misses this); `if:` no longer always-runs | R11: temp-ci.yml rename script everywhere → substring absent RED; mangle job `if:` → `always()`-contains RED. |
| **020 (node-property scan, §6.8 M2-q)** | `find_key_node_properties(mutants-aggregate block) == []` | **`&x run: … \|\| true` / `!!str shell: cat {0}` — a node property on an ALREADY-pinned key resolves to a real key but is invisible to a key-SET diff** | R12: temp-ci.yml prefix a pinned key with `&anchor`/`!!tag` → scan returns non-empty → RED; empty (no properties) → GREEN. |
| **021 (per-step `if:`-VALUE, §6.8 new gap)** | each of the 3 download/eval steps' `if:` == exact `always()` | **`if: false` (or a `needs`-conditional) on a download step → INV-COMPLETE misreads a present artifact as missing (false-RED correctness break)** | R13: temp-ci.yml change one step's `if: always()` → `if: false` → value ≠ `always()` RED; compound `always() && …` → exact-eq RED (substring look-alike defeated). |
| **022 (exact-equality symmetry — over-count, §6.10)** | over-count (`total_scored > MUTANT_COUNT`) at healthy `>=90%` → exit 1 (mismatch) | **`<`-only / `-lt` mutant tolerating an over-count → `101 < 100 == false` never trips → healthy 95% PR silently passed (false-green)** | R14: total_scored=101, MUTANT_COUNT=100, split 96/101≈95% → assert exit 1 + mismatch names 100&101. |
| **023 (completeness-over-quality — under-count, §6.10)** | under-count mismatch + healthy PARTIAL `>=90%` → exit 1, NO pass line | **drop-`return-1` mutant (round-4 warn-and-continue) → dropped survivor passes behind 95% partial set → exit 0 + pass line (false-green)** | R15: total_scored=100, MUTANT_COUNT=101, split 95/100=95% → assert exit 1 + mismatch names 101&100 + NO "gate passed" line. |
| **024 (runtime-hardening SOURCE wiring, §6.11 item 21)** | both gate scripts `source scripts/lib/trusted-jq.sh`; the library exists + defines the 3 resolver fns | drop the `source` line (or a private hand-copy) → resolver not wired → drift-between-copies class reopens | R16: temp-`mutants-aggregate.sh` drop/repoint the `source` line → suffix-match absent RED; delete the library / a fn def → presence RED. GREEN only when both sourced + all 3 fns present. |
| **025 (no bare decision-path `jq`, §6.11 item 22 — load-bearing)** | every jq call is `"${jq_bin}"` (sole exception: `trusted-jq.sh`'s `command -v jq`, line-anchored) | **bare `jq -r '.caught // 0' "$shard"` → `$GITHUB_PATH` jq shim forges kill-rate counts → pooled `>=90%` over a failing set → exit 0 (false-green mutation gate; the pass-8 MED-1 vector)** | R17: temp-`mutants-aggregate.sh` revert one `"${jq_bin}"` to bare `jq` → default-deny scan RED naming file+line; 2nd mutant: bare `jq` in `trusted-jq.sh` outside the excluded line → RED (exclusion is line-anchored). |
| **026 (`STATUS_DIR` evidence-source pin, §6.8 corrected M2-n / item 23 — F-H1)** | eval-step `env.STATUS_DIR` == `${{ runner.temp }}/shard-status` byte-exact | **redirect `STATUS_DIR: ${{ github.workspace }}/x` + checked-in fake sentinels ⇒ Step 2/3 validate self-consistently against attacker data ⇒ exit 0 (false PASS; `${VAR:?}` passes on the non-empty value, VP-018's key-set pin never inspects VALUES)** | R18: temp-ci.yml redirect the value → byte-value ≠ pin → RED; drop the key → presence RED. Correct value → GREEN. |
| **027 (`SHARD_DIR` evidence-source pin, §6.8 corrected M2-n / item 24 — F-H1)** | eval-step `env.SHARD_DIR` == `${{ runner.temp }}/shards` byte-exact | **redirect `SHARD_DIR: ${{ github.workspace }}/x` + fake `outcomes.json` (`missed=0`, `caught==MUTANT_COUNT`) ⇒ pooled 100% over fabricated data ⇒ exit 0 (false PASS; real shard outcomes bypassed)** | R19: temp-ci.yml redirect the value → byte-value ≠ pin → RED; drop the key → presence RED. Correct value → GREEN. |
| **028 (`MUTANT_COUNT` env-wiring pin, §6.8 MIRRORED M2-n / item 25 — LOW-1, load-bearing)** | eval-step `env.MUTANT_COUNT` == `${{ needs.mutants-plan.outputs.mutant_count }}` byte-exact | **hardcode `MUTANT_COUNT: 100` to the real pooled total ⇒ Step-4 reconciliation (`total_scored != MUTANT_COUNT`) passes TRIVIALLY ⇒ sub-invariant 8's completeness guard disabled ⇒ a dropped survivor passes (false-green the RUNTIME backstop cannot catch — it reads the forged value and finds it self-consistent)** | R20: temp-ci.yml hardcode the value → byte-value ≠ pin → RED (runtime reconciliation stays deceptively GREEN; ONLY the pin catches it); drop the key → presence RED. Correct value → GREEN. |
| **029 (`OVERALL_DIFF_LINES` env-wiring pin, §6.8 MIRRORED M2-n / item 26 — LOW-1)** | eval-step `env.OVERALL_DIFF_LINES` == `${{ needs.mutants-plan.outputs.overall_diff_lines }}` byte-exact | **hardcode `OVERALL_DIFF_LINES: 500` ⇒ Step 5 base-ref-drift guard evaluates a PR-chosen constant; on an already-reconciled-to-zero PR converts a legitimate base-ref-drift FAIL into a "legitimate-zero-mutants OK" (bounded LOW residual)** | R21: temp-ci.yml hardcode the value → byte-value ≠ pin → RED (VP-013's regex guard passes a well-formed integer, so the pin is the load-bearing check); drop the key → presence RED. Correct value → GREEN. |
| **030 (`PLAN_RESULT` env-wiring pin, §6.8 MIRRORED M2-n / item 27 — LOW-1)** | eval-step `env.PLAN_RESULT` == `${{ needs.mutants-plan.result }}` byte-exact | **hardcode `PLAN_RESULT: success` decoy ⇒ Step 0.5 reads `"success"` regardless of the plan job's real result, defeating the fail-fast diagnostics wiring (cannot forge a full PASS alone — Step 2's sentinel-presence interlock fails closed — but defeats the Step-0.5 interlock's input)** | R22: temp-ci.yml hardcode the value → byte-value ≠ pin → RED; drop the key → presence RED. Correct value → GREEN. |

Every row has a RED proof that is GREEN against correct logic and RED against a
concretely-named one-line mutant. **0 GAP on the covered surface** (the one
KNOWN-uncovered condition is the §5A documented residual, explicitly NOT a GAP).
The HIGH-2 all-shards-crash false-green (row 006) has its own VP with an explicit
RED proof; the three INV-COMPLETE sub-cases (rows 002 infra-cancel, 006
harness-crash, 007 legit-empty) are each distinguished (§3A); VP-010's fail-open
mischaracterization is corrected to fail-closed/wasted-CI (round-2). **The
round-3 HIGH-1 Step-0 fail-open (row 014) — the one genuinely NEW false-green
this round — has its own VP with a RED proof that distinguishes the fixed
allowlist `case` from the old `!= 'pull_request' → exit 0` form** (empty
`EVENT_NAME` on a real PR: exit 1 fixed vs exit 0 mutant), double-covered by the
row-015 input-wiring pin exactly as VP-003/VP-010 double-cover the `escalated`
mechanism. **Round-4 (rows 017–021) ports `ci-gate`'s own decision-step
anti-neutering guardrail CLASS onto `mutants-aggregate` — the five structural
peers (M2-i run-line, M2-o env-key-set, AC-001 invocation, M2-q node-property,
and the genuinely-new per-step `if:`-VALUE pin), each with a RED proof against
its SPECIFIC neutering (run-line suffix, smuggled `BASH_ENV:`, renamed script,
anchor/tag on a pinned key, `if: false` on a download step). **Round-5 RESTORES
VP-008's HARD-FAIL assertion (rows 008/022/023) — reversing round-4's warning-only
downgrade:** reconciliation is once again `total_scored != MUTANT_COUNT` → exit 1
(exact equality, both directions), so the dangerous mutant class is back to "drop
the check → false-green" (a dropped survivor passing behind a healthy-looking
partial kill rate). VP-022 proves the OVER-count direction also fails closed
(the check is genuinely `!=`, not `<`-only), and VP-023 reuses VP-008's fixture
to pin, by name, that a healthy PARTIAL kill rate never rescues a dropped-mutant
under-count mismatch (Step 6 is unreachable on any mismatch). The three together
pin exact-equality reconciliation as a hard, symmetric, completeness-first gate.**
**Round-7 (rows 024–025) ports `check-ci-gate.sh`'s SCRIPT-LEVEL RUNTIME
hardening onto `mutants-aggregate.sh`** — the layer §6.8's Rust/YAML
structural-peer work (rounds 4) never reached: a shared, sourced
`scripts/lib/trusted-jq.sh` (VP-024 wiring), `set -euo pipefail`, and every
decision-path jq call routed through a once-resolved `${jq_bin}` (VP-025 usage,
the load-bearing half). VP-025's RED proof is against a bare
`jq`-on-the-decision-path that a `$GITHUB_PATH` shim could forge into
attacker-chosen kill-rate counts → a false-green mutation gate — the exact
pass-8 MED-1 / S-626-1 pass-59 (ADV-P59-LOW-001) vector, now closed for the
mutation gate too. Together they make `mutants-aggregate.sh` a RUNTIME structural
peer of `check-ci-gate.sh`, completing the peer relationship across BOTH the
Rust/YAML (§6.8) and script-runtime (§6.11) layers.
**Round-8 (rows 026–027) closes F-H1, the true M2-n analog for this job:** the
`mutants-aggregate` eval-step `env:` mapping now byte-VALUE-pins
`STATUS_DIR`/`SHARD_DIR` — the two paths that between them locate the ENTIRE
evidence set (every status sentinel, every `outcomes.json`) the decision reads.
The pre-round-8 §6.8 M2-n disposition had DECLINED these value pins on the FAULTY
claim that bash's `${VAR:?}` was "stronger than any static pin could assert";
`${VAR:?}` proves abort-on-UNSET/EMPTY only and gives ZERO protection against a
maliciously-but-validly-SET redirect to an attacker-controlled directory holding
fabricated `caught==MUTANT_COUNT` data — the exact `NEEDS_JSON`-class false-green.
VP-026/027's RED proof is against that redirect; the byte-VALUE pin fails RED on
the redirected value where `${VAR:?}` (non-empty) and VP-018's key-set pin (never
inspects VALUES) both pass. VP-018's rationale is corrected in the same spirit:
the env-KEY-SET pin and the byte-VALUE pins are COMPLEMENTARY proofs of DIFFERENT
failure modes (KEY smuggling vs. VALUE redirect), exactly as VP-010/VP-015 coexist
with the key-set pin for `ESCALATED`/`EVENT_NAME`. §6.8's M2-n row is now MIRRORED
(not declined), and the round-8 declination re-audit re-verified all OTHER
declined/N-A/accepted-residual §6.8/§6.11 rows SOUND (`MUTANT_COUNT`'s and
`PLAN_RESULT`'s dispositions STRENGTHENED — the former's soundness had been silently
conditional on `STATUS_DIR`/`SHARD_DIR` being trustworthy, a dependency VP-026/027
now close; an `OVERALL_DIFF_LINES` LOW residual is named explicitly for the first
time).
**Round-9 (rows 028–030) eliminates the 'declined env-value pin' class entirely,
closing LOW-1:** the round-8 declination of a byte-VALUE pin on `MUTANT_COUNT` was
CIRCULAR — Step-4 reconciliation is keyed on `total_scored != MUTANT_COUNT`, so a PR
that hardcodes `MUTANT_COUNT` to the real pooled total makes reconciliation pass
TRIVIALLY, disabling sub-invariant 8's completeness guard (VP-008) while the runtime
backstop stays deceptively GREEN (it reads the forged value against itself). The
declination cited a RUNTIME backstop (reconciliation) as justification for skipping a
STRUCTURAL pin, without noticing the backstop reads the very value the structural
layer left unpinned — the SAME reasoning gap as F-H1, one round on; bounded LOW only
because `MUTANT_COUNT` is a single plaintext integer with no directory-redirect blast
radius. VP-028's byte-VALUE pin is the ONLY check that catches this false-green (the
reconciliation cannot). VP-029 (`OVERALL_DIFF_LINES`) and VP-030 (`PLAN_RESULT`)
retire the other two declined value pins so ALL SEVEN of `mutants-aggregate`'s
eval-step env values now carry BOTH a key-set pin (VP-018) AND an individual
byte-VALUE pin — no value-pin declination remains. All three are defense-in-depth
WIRING pins (structural), complementary to the runtime behavior, exactly like
VP-010/015/026/027. §6.8's M2-n disposition rows for
`MUTANT_COUNT`/`OVERALL_DIFF_LINES`/`PLAN_RESULT` move from DECLINED to MIRRORED
(architecture-delta round-9 items 25-27); VP-018's earlier "three keys with no
byte-VALUE pin" clause is retired accordingly.

---

## 5A. Documented residual (KNOWN-uncovered, NOT a VP, NOT a GAP)

**The one condition no VP in this delta covers — recorded explicitly so it is
not implied-closed.** INV-AGG sub-invariant 8's reconciliation (VP-008) catches
per-shard PLAN↔EXECUTION divergence at a zero false-negative rate for THAT
class, but a **common-mode corruption of the single shared `mutants-diff-file`
artifact** is structurally beyond its reach — including a genuine
`MUTANT_COUNT == 0` produced by a base-ref-resolution or `examine_globs`-scoping
quirk. Both `MUTANT_COUNT` (`mutants-plan`'s `--list --in-diff "$DIFF_FILE"`) and
every shard's `--shard k/8 --in-diff "$DIFF_FILE"` derive from the IDENTICAL
bytes (the "one upload, N downloads" property that makes the sharded design
correct for its own purpose), so a wrong-at-source diff makes both derivations
agree exactly, reconcile cleanly (`total_scored == MUTANT_COUNT`, possibly both
`0`), and pass the gate GREEN having verified zero mutants outside the wrong
scope — with no signal anywhere in the PR pipeline that the scope itself was
wrong.

- **Why it is a RESIDUAL, not a GAP.** A GAP is a coverable invariant left
  without a RED proof; this condition is STRUCTURALLY uncoverable by any signal
  internal to this pipeline, because every internal derivation trusts the same
  diff bytes. No fixture or structural pin can distinguish "correct diff, zero
  mutants" from "wrong diff, zero mutants" using only the artifacts this
  topology produces. Adding a VP here would be a false claim of coverage.
- **What IS closed (so the residual is stated at its true, narrow size).** The
  ADJACENT tooling-error half is closed this round: `mutants-plan`'s `--list`
  step no longer swallows a genuine `cargo mutants --list` failure into a
  silently-wrong `MUTANT_COUNT=0` — it now captures `--list`'s own exit status
  and fails the `mutants-plan` job closed (ci-yml-design.md §1), surfacing at the
  aggregator as `PLAN_RESULT != "success"` (Step 0.5). That is a tool-INVOCATION
  failure, distinct from and NOT the same as this residual (a wrong-but-
  successful diff). VP-013 separately closes the `OVERALL_DIFF_LINES`
  malformed-but-set consumer-side gap. What remains is ONLY the wrong-but-
  successful common-mode diff.
- **The only backstop.** The nightly full-scope run
  (`.github/workflows/mutants-nightly.yml`, architecture-delta §5) runs the FULL
  `examine_globs` scope with NO dependency on `DIFF_FILE`/`git diff` at all, so a
  systematic diff-scoping defect that silently escapes every PR-gated run is
  still eventually examined — with up to ~24h lag and advisory-only severity (it
  does not retroactively block the offending PR).
- **Flagged for F5/F6 re-examination.** As production experience accumulates,
  F5/F6 should re-examine whether this residual warrants an additional,
  out-of-pipeline signal (e.g. an independent diff-scope sanity check not
  derived from `DIFF_FILE`) or remains acceptable under the nightly backstop.
  It is documented here, not resolved here.

**Related accepted residual — `mutants-plan`'s weaker protection tier (round-5,
architecture-delta §6.10 F3 cross-reference).** `mutants-plan` computes
`MUTANT_COUNT`/`escalated`/`OVERALL_DIFF_LINES` but keeps its `--list`/threshold
logic INLINE in `ci.yml` (not extracted to a self-testable script like
`scripts/mutants-aggregate.sh`) and has no dedicated job/step-key-set pin beyond
VP-004's existence/`if:`-value test — an ACCEPTED RESIDUAL, not closed this
cycle, because (a) neutering `mutants-plan` is mostly fail-closed by construction
(a bad diff routes into Step 5's base-ref-drift FAIL or Step 0.5's
`PLAN_RESULT != "success"`, or collapses into the common-mode diff residual
above), and (b) **round-5's restored reconciliation hard fail materially
strengthens `MUTANT_COUNT` integrity as a side effect** — a wrong or FORCED
`MUTANT_COUNT` (e.g. a tampered `mutants-plan` step reporting a low count to make
a dropped-mutant scenario reconcile falsely) now trips VP-008's exact-equality
check and hard-fails the gate, where round-4's warning-only would only have
warned-and-continued. Extracting `mutants-plan`'s logic to a self-testable
script is an OPTIONAL future symmetry improvement (§6.10 F3(c)), not required
this cycle. Cross-reference: architecture-delta §6.10 F3.

**ADDITIONAL explicitly-flagged, F4-gated residual (round-5, STRENGTHENED
round-6) — the `--list`⇔pooled partition-premise determination, whose PRIMARY
verification is a mandatory, BLOCKING F4 scratch-run BEFORE cycle-006 merges (NOT
a rollout/tighten window, and NOT gated on PR #778).** Distinct from the
common-mode residual above (this is a premise-validation item, not an
uncoverable-condition item), and recorded here so it is not implied-closed:
round-5 RESTORES VP-008's reconciliation to an unconditional HARD FAIL
(`total_scored != MUTANT_COUNT` → exit 1, exact equality both directions),
effective on cycle-006's own landing PR — reversing round-4's NON-BLOCKING
warning-only rollout, because warning-only disabled the ONLY guard this cycle has
for a dropped SURVIVOR silently passing behind a healthy-looking partial kill
rate. Restoring the hard fail does NOT resolve the unverified `--list` ⇔ pooled
`--shard --sharding slice` lossless-partition premise; round-6 makes that
premise's PRIMARY verification a **mandatory, BLOCKING F4 scratch-run task
performed BEFORE cycle-006's own PR merges**, NOT a permissive rollout period and
NOT deferred onto PR #778. F4 MUST run `cargo mutants --list --in-diff <diff>`
and the eight `--shard k/8 --sharding slice --baseline skip` runs against a
known-nonzero diff, confirm exact reconciliation, and root-cause any mismatch as
either a tooling-surface artifact (e.g. a header/blank line to strip in
mutants-plan) or a counting-convention adjustment (encode in
`scripts/mutants-aggregate.sh`) — NEVER re-widen to warning-only; inspecting
cargo-mutants' own `--sharding`/`--baseline skip`/unviable-counting semantics
supports that root-causing. **Cycle-006's own PR cannot supply this evidence — it
is CI/doc-only, ~0 `src/` mutants, exercising only the trivial `MUTANT_COUNT == 0`
path; F4/F5 must NOT treat its green run as confidence for the nonzero case — and
that is exactly why the scratch-run, not the landing PR, is the primary
verification.** **PR #778** (281 mutants) is a CONFIRMING, production-scale
exercise of a nonzero reconciliation layered ON TOP OF the scratch-run — NOT the
first or sole verification. If PR #778 later trips reconciliation, that is
fail-loud-and-correct (both numbers named), not a silent problem: a human MUST
root-cause it before merging that PR — either (a) a genuine dropped-mutant defect
(fix the underlying cause), or (b) a counting-convention discrepancy in the
premise (e.g. `--list` vs the pooled run enumerate `unviable` differently, or a
small explainable `--baseline skip` offset), in which case F4/F5 encode the
CORRECT reconciliation relationship into `scripts/mutants-aggregate.sh` as a
documented, reasoned adjustment — NEVER silently suppress or re-widen the check
back to warning-only as a shortcut. The existing admin branch-protection bypass
is the documented escape valve for a genuine emergency where a PR is blocked and
the discrepancy cannot be root-caused quickly. F4 owns both the pre-merge
scratch-run and the determination; F5 owns confirming the evidence exists (or
explicitly deferring, with the hard fail still in force). Restored reconciliation
also strengthens `MUTANT_COUNT` integrity as a side effect (a tool-invocation or
wiring defect that corrupts the pre-count now fails the gate loudly rather than
warning-and-continuing). This is a peer to the §5A common-mode residual above and
the §6.10 mutants-plan residual. mutants-sharding-invariants.md §INV-AGG
sub-invariant 8 round-5/round-6 callouts / architecture-delta §6.10 carry the
full reversal rationale (drawing on round-4's own Option-A-vs-Option-B weighing).

---

## 6. Notes for F4 / F6

1. **F4 testability precondition (§2) is a hard prerequisite** for
   VP-001/002/003/006/007/008/013/014 RED proofs to be real: extract
   `scripts/mutants-aggregate.sh` first; the behavioral tests subprocess it,
   they do not re-implement it. Round-1 makes this stricter — the fixtures must
   build the two-tree sentinel+outcomes artifact layout exactly per
   `ci-yml-design.md §3`. **Round-3 makes it a NAMED, confirmed BLOCKING F2-gate
   precondition** (architecture-delta §6.2a, alongside the round-6 mandatory
   pre-merge scratch-run premise-validation precondition — the `--list`⇔pooled
   reconciliation scratch-run F4 MUST perform BEFORE cycle-006's own PR merges,
   with PR #778 a later CONFIRMING exercise, not the sequencing gate — both need
   explicit human confirmation at the F2 gate). The
   extraction surfaced that `STATUS_DIR`/`SHARD_DIR` must move from inline
   `${{ runner.temp }}` templating to real `env:` variables (read via
   `${…:?…}`), and that the script's `--self-test` harness must be wired into
   `spec-guard` (VP-016) or its fixtures never run in CI.
2. **`EXPECTED_GUARD_TEST_COUNT` is `65` after round-9** (+27, NINE history-log
   entries: `38 → 43` original F2, `43 → 48` round-1, `48 → 49` round-2,
   `49 → 51` round-3, `51 → 58` round-4, round-5/round-6 add none, `58 → 60`
   round-7, `60 → 62` round-8, `62 → 65` round-9). **Round-9 adds THREE `#[test]`
   (R20/R21/R22): VP-028 (`..._mutant_count_env_wired`), VP-029
   (`..._overall_diff_lines_env_wired`), and VP-030 (`..._plan_result_env_wired`),
   §6.8 MIRRORED M2-n row / items 25-27 (LOW-1) — all three byte-VALUE structural
   pins on `ci.yml`'s parsed YAML (no subprocess, no bash fixture), mirroring
   VP-026/027's shape, retiring the last three declined env-value pins so ALL SEVEN
   eval-step env values are dual-pinned (key-set VP-018 + byte-value); VP-028 is the
   load-bearing one, closing the CIRCULAR reconciliation-disable; see note 21.**
   **Round-8 adds TWO `#[test]` (R18/R19): VP-026
   (`..._status_dir_env_wired`) and VP-027 (`..._shard_dir_env_wired`), §6.8
   corrected M2-n row / items 23-24 (F-H1) — both byte-VALUE structural pins on
   `ci.yml`'s parsed YAML (no subprocess, no bash fixture), mirroring VP-015's
   shape, closing the evidence-source-redirect false-green; see note 20.**
   **Round-7 adds TWO `#[test]` (R16/R17): VP-024
   (`..._source_shared_trusted_jq_helper`) and VP-025
   (`..._have_no_bare_jq_invocations`), §6.11 — both static script-text scans, the
   RUNTIME-hardening-parity peers of `check-ci-gate.sh`.** **Round-5 added/removed
   NO test — assertion/fixture-body changes to three existing slots only, so the
   count was unchanged at 58 through round-6.** Round-4 added SEVEN `#[test]` (R9..R15): VP-017 run-line
   byte-pin, VP-018 env-key-set pin, VP-019 invocation assertion, VP-020
   node-property scan, VP-021 per-step `if:`-VALUE pin (the five structural-peer
   pins, §6.8), plus VP-022 and VP-023 (the two reconciliation slots, re-scoped by
   round-5 to over-count symmetry / completeness-over-quality, §6.10). **Round-5
   RESTORES VP-008's test name to the round-1 original
   `..._fails_closed_on_mutant_count_reconciliation_mismatch` and reverts its
   assertion to exit 1** (round-4 had temporarily renamed it to
   `..._emits_non_blocking_warning` with an inverted body) — an in-body rename +
   revert of an EXISTING `#[test]` (still R3), no count change; VP-022/023's slots
   are likewise re-scoped in-body (same names, all rc==1), no count change.
   Round-3 added TWO `#[test]`
   (R7/R8, VP-015/016); round-2 added ONE (R6, VP-011) and TRANSFORMED two tests
   in-body; round-3 renamed `..._three_code_level_references` → `...four...` (in
   body, no count change) and grew Fixture 14's body. INV-ESCALATE (VP-003) and
   the Step-0 event guard (VP-014) remain co-located aggregator-harness fixtures;
   the prior draft's "+6 alternative" is withdrawn (§4). F6's denominator must be
   **65**. Sibling denominators (all independent): `EXPECTED_FIXTURES = 14`
   (`13 → 14` this cycle — new Fixture 14 in round-1 — then stable at 14 through
   rounds 2-9, NOT a pre-cycle baseline of 14; LOW-2 framing);
   `EXPECTED_PRINT_ALLOWED_SKIPS_CHECKS = 1` (VP-012);
   `EXPECTED_JQ_TRUST_CHECKS = 17` (unchanged by round-7's pure relocation of the
   resolver into `scripts/lib/trusted-jq.sh`); and F4-set
   `EXPECTED_MUTANTS_AGG_FIXTURES` (**provisional floor `12`, raised `10 → 12` in
   round-7** — `+1` for VP-001's straddling Fixture 1B, `+1` for the
   previously-uncounted Step-0.5 `PLAN_RESULT != "success"` fixture, LOW-2
   floor-arithmetic correction; architecture-delta §6.2a round-7) on the extracted
   `mutants-aggregate.sh --self-test` (VP-003/008/013/014/022/023 + the Step-0.5
   `PLAN_RESULT != "success"` fixture + VP-001's fixture pair 1A/1B).
3. **`extract_and_normalize_if_expr` never-before-exercised value shapes:** the
   `mutants` shard job's compound `github.event_name == 'pull_request' &&
   needs.mutants-plan.outputs.escalated != 'true'` and `mutants-aggregate`'s
   bare `always()` are new VALUE shapes for that function in this file. Per
   architecture-delta §6.2/§6.4, F4 must supply an explicit RED/GREEN proof that
   the function accepts each as an opaque plain scalar. These are the architect's
   `PINNED_GATE_IF_EXPR`-style pins (`PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS` for
   `mutants-aggregate`, cross-checked by VP-009) — the `mutants-aggregate` bare-
   vs-braced `always()` footgun (INV-ESCALATE Residual Risk 3) is a real trap:
   write it bare, never `${{ always() }}`.
4. **INV-ESCALATE string-comparison footgun (invariants doc Residual Risk 2):**
   VP-003's RED proof explicitly includes the bare-truthy `'false'`-is-truthy
   mutant, so F5/F6 mutation testing on the aggregator's escalation branch has a
   defined kill target. VP-010 (round-2-reframed) separately guards the WIRING
   INTEGRITY that a mistyped output/env key would break — a different failure
   mode from a mis-written comparison. **Framing correction (round-2):** an
   empty/mistyped `escalated` key is fail-CLOSED / wasted-CI (a >120 PR runs the
   oversized shard gate instead of short-circuiting), NOT the "fail-open,
   maximally dangerous, merge-unverified" shape the round-1 draft claimed — the
   dangerous VALUE direction is the opposite (`ESCALATED` resolving to literal
   `true` when it should not), which the same byte-exact producer+consumer pin
   also catches. Do not carry the retired fail-open language forward.
5. **`outcome`-not-`conclusion` is load-bearing (INV-COMPLETE Part A):** VP-006's
   second reinforcing mutant pins that the sentinel captures
   `steps.run-mutants.outcome`, not `.conclusion` (which `continue-on-error:
   true` forces to `success`). F4/F6 must keep this as an explicit kill target —
   a `.conclusion`-keyed sentinel silently reopens CRIT-1.
6. **Mutation-testing scope:** `scripts/mutants-aggregate.sh` is bash, outside
   `.cargo/mutants.toml`'s Rust `examine_globs` — architecture-delta §6.2
   confirms no `examine_globs` change. The aggregator's own correctness is
   guarded by the behavioral RED proofs here, not by `cargo-mutants`; the Rust
   guard tests are within `ci_gate_completeness.rs` (a test file, not a mutants
   target). No `tests/mutants_glob_existence.rs` change.
7. **`tests/common/wf.rs` requires ZERO changes** (architecture-delta §6.3,
   verified) — VP-004/005/009/010/015/016/026/027/028/029/030's structural
   mechanisms all reuse
   existing generic accessors (`extract_and_normalize_if_expr`,
   `job_level_nested_sequence_items`, job/step nested-mapping lookups, the
   byte-exact env-child-value technique items 10/12 already use for
   `ESCALATED`/`EVENT_NAME` — VP-026/027 reuse it verbatim for
   `STATUS_DIR`/`SHARD_DIR` and VP-028/029/030 for
   `MUTANT_COUNT`/`OVERALL_DIFF_LINES`/`PLAN_RESULT`, no new primitive — and the
   step-name-anchored `run:`-line extractor AC-008 already uses); VP-011 is pure
   Rust `.is_empty()` + a `check-ci-gate.sh` shell-out, no `wf.rs` accessor at
   all. `EXPECTED_WF_TEST_COUNT` (26) is unaffected.
8. **Round-2 skip-tolerant empty-consistency (VP-011) — the transform, not just
   the addition, is load-bearing.** F4 must TRANSFORM (not delete/weaken) the two
   existing hard asserts named in architecture-delta §6.2 items 6/7 in the SAME
   commit as landing R6, and update `PINNED_GATE_NEEDS_LINE` (M2-p literal, still
   ending `…mutants]`) alongside `test_ci_gate_needs_exactly_the_required_jobs` —
   HIGH-1(c), the constant round-1 forgot. Emptying
   `SKIP_TOLERANT_NEEDS_MEMBERS`/`PINNED_ALLOWED_SKIP_IF_EXPRESSIONS`/
   `ALLOWED_SKIPS` under the OLD hard asserts turns CI red on a CORRECT design;
   the transforms make emptiness itself the thing under test.
9. **Round-2 `print_allowed_skips` (VP-012) is a NEW SIBLING self-test, not a
   `check_fixture`.** `EXPECTED_PRINT_ALLOWED_SKIPS_CHECKS = 1` is its own
   fixed-denominator pin; do NOT fold it into `EXPECTED_FIXTURES` (stays 14). Its
   `[ "${#ALLOWED_SKIPS[@]}" -eq 0 ] && return 0` short-circuit adds NO
   `ALLOWED_SKIPS=` occurrence (verified: `${#ALLOWED_SKIPS` ≠ `${ALLOWED_SKIPS`).
   **Round-3 correction:** the `code_level_references` pinned count nevertheless
   moves `3 → 4` for a DIFFERENT reason (note 11 below) — the fixtures-4/5 shared
   wrapper — and the test is renamed `...four...`. Do NOT expect it to "stay at 3"
   post-round-3.
10. **Round-2 `OVERALL_DIFF_LINES` malformed-set guard (VP-013) + `--list`
    hardening.** F4 adds the `^[0-9]+$` regex guard to `OVERALL_DIFF_LINES` in
    the aggregator Step 5 (symmetry with `MUTANT_COUNT`'s Step-4 guard), and
    hardens `mutants-plan`'s `--list` step to capture its own exit status and
    fail closed (ci-yml-design.md §§1,3). Neither adds a structural Rust-side pin
    (consistent with the `--timeout 240`/`ESCALATION_THRESHOLD=120` code-review-
    time precedent); VP-013 rides the aggregator `--self-test` harness, and the
    `--list` failure is exercised via the aggregator's Step-0.5 `PLAN_RESULT`
    fixture. The wrong-but-successful common-mode diff residual behind both is
    §5A — NOT closeable in-pipeline, backstopped by the nightly run, flagged for
    F5/F6.
11. **Round-3 Step-0 fail-closed event guard (VP-014) — the genuine false-green
    fix, with a RED proof that distinguishes it from the old fail-open form.** F4
    rewrites `mutants-aggregate.sh` Step 0 from `[ "$EVENT_NAME" != "pull_request"
    ] → exit 0` to a fail-CLOSED allowlist `case` (only `pull_request` falls
    through; `push`/`schedule`/`workflow_dispatch` exit 0; DEFAULT `*)` — including
    empty/unknown — FAILS exit 1). The RED proof is an
    `EXPECTED_MUTANTS_AGG_FIXTURES` pair: `EVENT_NAME=""` → exit 1 (GREEN against
    the fix, RED against a mutant reverting to `!=`-exit-0, which would exit 0 on
    a real PR) AND `EVENT_NAME="push"` → exit 0 (proves the fix did NOT over-correct
    the legitimate no-op). F4 must re-verify the allowlist against `ci.yml`'s
    current `on:` block and EXTEND it (never remove) if a new trigger was added.
    Companion: MEDIUM-1's `is_allowed_skip` `${#ALLOWED_SKIPS[@]} -eq 0 && return
    1` guard (**return 1, NOT 0** — the documented asymmetry vs `print_allowed_skips`'s
    `return 0`; copying the 0 would be a severe fail-open regression) and Fixture
    14's `"FAIL  fmt = skipped"` message-substring assertion (a bash-3.2 crash
    exits 1 too — a bare rc check would pass by coincidence). F4 must confirm
    Fixture 14 green on a REAL `macos-latest` run, not infer it from ubuntu.
12. **Round-3 `EVENT_NAME` env-wiring byte-pin (VP-015) mirrors VP-010's
    structure.** `test_mutants_aggregate_event_name_env_wired` byte-pins the
    eval-step `env.EVENT_NAME == ${{ github.event_name }}` — same technique as the
    round-1 `ESCALATED` pin, input side rather than output side. A Rust `#[test]`,
    +1 of the round-3 `49 → 51`. Defense-in-depth on the wiring, NOT a substitute
    for VP-014's runtime `case`.
13. **Round-3 `spec-guard` self-test-step pin (VP-016) makes the aggregator
    `--self-test` actually run in CI.** `test_spec_guard_contains_mutants_aggregate_
    self_test_step` asserts the `spec-guard` step exists (anchored by name) AND
    byte-pins its `run: bash scripts/mutants-aggregate.sh --self-test` line —
    mirroring the existing `test_spec_guard_contains_check_ci_gate_self_test_step`
    (AC-008). Same-commit lockstep: `PINNED_ALWAYS_RUN_STEP_KEY_SETS`'s `spec-guard`
    tuple grows 12 → 13 (`+ &["name","run"]`), enforced by the existing generic
    `test_always_run_jobs_have_pinned_complete_step_key_sets`. A Rust `#[test]`,
    the second +1 of `49 → 51`. Without VP-016, `EXPECTED_MUTANTS_AGG_FIXTURES`
    would be "a self-test suite nobody runs — dead code with a comforting name."
14. **AUTHORITATIVE completeness backstop (round-3..round-7,
    architecture-delta §6.7/§6.9/§6.10/§6.11):** this document's enumeration is
    BEST-EFFORT GUIDANCE — SEVEN consecutive adversarial rounds have EACH found
    something the prior rounds missed (round-5 caught round-4's own rollout-policy
    choice as a false-green; round-7 caught that §6.8's Rust/YAML structural
    peering never reached `check-ci-gate.sh`'s SCRIPT-LEVEL RUNTIME hardening —
    `mutants-aggregate.sh` called `jq` bare everywhere), so the map has been
    revised seven times running. The
    ground truth is that F4 MUST run the full `cargo test`
    guard suite, `scripts/check-ci-gate.sh --self-test`, AND the new
    `scripts/mutants-aggregate.sh --self-test` locally and in CI before merge; any
    pin this enumeration missed fails one of those suites loudly. Treat the next
    implementer's own suite run, not this document's counts, as ground truth.
15. **Round-4 structural-peer pins (VP-017..021, §6.8) — `mutants-aggregate` is
    now a documented STRUCTURAL PEER of `ci-gate`.** F4 adds the five decision-
    step protections `ci-gate`'s own gate step carries but `mutants-aggregate`
    never inherited: `PINNED_MUTANTS_AGGREGATE_RUN_LINE` (VP-017, via existing
    `extract_and_normalize_sole_run_line`), `PINNED_MUTANTS_AGGREGATE_ENV_KEYS`
    (VP-018, 7 keys, via existing `extract_gate_env_key_set`), the invocation
    assertion (VP-019, mirror of `test_ci_gate_step_invokes_check_ci_gate_
    script_with_needs_json`), the node-property scan (VP-020, existing
    `find_key_node_properties` run a SECOND time — the first job besides `ci-gate`
    it scans), and the per-step `if:`-VALUE pin (VP-021, the genuinely-new gap —
    `mutants-aggregate`'s three legitimate `if: always()` steps get their VALUES
    pinned, the inversion of `ci-gate`'s M2-d ban). ALL reuse existing generic
    accessors — `tests/common/wf.rs` still needs ZERO changes (note 7). The full
    `ci-gate`-protection → disposition table (including every protection inherited
    transitively or deliberately declined) is architecture-delta §6.8; do not
    re-derive it here.
16. **Round-5 VP-008 HARD FAIL restored (§6.10 / F2), reversing round-4's
    warning-only downgrade + the two re-scoped reconciliation proofs (VP-022/023).**
    F4 implements sub-invariant 8's reconciliation as an exact-equality comparison
    that emits a diagnostic naming both numbers and `return 1` on mismatch (BOTH
    directions), NOT a `::warning::`+continue — the RESTORED VP-008 test
    (`..._fails_closed_on_mutant_count_reconciliation_mismatch`) asserts exit 1 +
    mismatch message + NO Step-6 pass line, and Step 6 is UNREACHABLE on any
    mismatch (it never reads `MUTANT_COUNT`). VP-022 (over-count: `MUTANT_COUNT=100`,
    pooled `101`, healthy `>=90%` → exit 1) proves the check is genuinely `!=`, not
    `<`-only; VP-023 (under-count: same fixture as VP-008, healthy PARTIAL `>=90%`
    → exit 1 + NO pass line) pins by name that a healthy partial kill rate never
    rescues a dropped-mutant mismatch. **There is NO tighten-trigger/rollout
    window** — the hard fail is in force on cycle-006's own landing PR. The
    remaining `--list`⇔pooled partition-premise validation's PRIMARY verification
    (round-6) is a **mandatory, BLOCKING F4 scratch-run task performed BEFORE
    cycle-006's own PR merges** — run `cargo mutants --list --in-diff <diff>` and
    the eight `--shard k/8 --sharding slice --baseline skip` runs against a
    known-nonzero diff, confirm exact reconciliation, root-cause any mismatch as a
    tooling-surface artifact or a counting-convention adjustment encoded in
    `scripts/mutants-aggregate.sh`, NEVER re-widen to warning-only. Cycle-006's own
    PR only exercises the trivial `MUTANT_COUNT==0` path, which is why the
    scratch-run (not the landing PR) is the primary verification. **PR #778** (281
    mutants, the first nonzero-`MUTANT_COUNT` production-scale exercise) is a
    CONFIRMING exercise layered ON TOP OF the scratch-run — NOT the first or sole
    verification — an explicitly-flagged, F4-gated residual (§5A tail), peer to the
    §5A common-mode residual and the §6.10 mutants-plan residual. If PR #778 later
    trips reconciliation, that is fail-loud-and-correct: root-cause it (real
    dropped-mutant bug → fix; counting-convention discrepancy → encode a documented
    adjustment into `scripts/mutants-aggregate.sh`), NEVER silently re-widen to
    warning-only.
17. **Round-7 runtime-hardening parity (VP-024/025, §6.11) — `mutants-aggregate.sh`
    is now a RUNTIME structural peer of `check-ci-gate.sh`, complementing §6.8's
    Rust/YAML peering.** F4 (a) EXTRACTS
    `trusted_jq_dirs_for`/`is_trusted_jq_dir`/`resolve_trusted_jq` out of
    `check-ci-gate.sh` into a SHARED, sourced `scripts/lib/trusted-jq.sh` and adds
    the `source` preamble to `check-ci-gate.sh` in place of the deleted functions
    (zero behavior change; `EXPECTED_JQ_TRUST_CHECKS` stays `17`); (b) lands
    `scripts/mutants-aggregate.sh` per ci-yml-design.md §3's revised body —
    sources the shared library, `set -euo pipefail` (upgraded from `set -uo
    pipefail`), a `bash -n` self-check, `jq_bin` resolved ONCE before Step 0, and
    every decision-path jq call routed through `"${jq_bin}"`; (c) adds VP-024
    (`test_check_ci_gate_sh_and_mutants_aggregate_sh_source_shared_trusted_jq_helper`,
    R16 — SOURCE wiring) and VP-025
    (`test_check_ci_gate_sh_and_mutants_aggregate_sh_have_no_bare_jq_invocations`,
    R17 — no bare decision-path `jq`, the load-bearing half), driving
    `EXPECTED_GUARD_TEST_COUNT` 58 → 60. Both are static script-text scans, no
    subprocess. The shared-file choice (NOT a hand-copied second resolver in
    `mutants-aggregate.sh`) is deliberate anti-drift: one copy, both callers, so a
    future jq-trust fix cannot land in one decision-path script and be forgotten in
    the other. The `command -v jq` in `resolve_trusted_jq` is VP-025's ONLY
    exclusion — line-anchored, not a whole-file allowlist. Round-7 does NOT
    duplicate `check-ci-gate.sh`'s existing 17-check `run_jq_trust_self_test` inside
    `mutants-aggregate.sh --self-test` (the shared library is the SAME code that
    suite already proves — declined per §6.11 "Considered and declined"). F4 also
    updates CLAUDE.md's CI-Gate review-scope enumeration to SIX files
    (`.github/workflows/ci.yml`, `scripts/check-ci-gate.sh`,
    `scripts/mutants-aggregate.sh`, `scripts/lib/trusted-jq.sh`,
    `tests/ci_gate_completeness.rs`, `tests/common/wf.rs`) — LOW-1, architecture-delta
    §6.11 F4-obligation 5.
18. **Round-7 `EXPECTED_MUTANTS_AGG_FIXTURES` floor `10 → 12` (LOW-2,
    architecture-delta §6.2a round-7) — floor-arithmetic correction, no invariant
    change.** The old derivation undercounted on two independent grounds: `+1` for
    VP-001's STRADDLING Fixture 1B (1A average-passes/pooled-fails + 1B
    average-fails/pooled-passes — a single direction cannot distinguish sum from
    average), and `+1` for the never-counted Step-0.5 `PLAN_RESULT != "success"`
    fixture. VP-001's entry already specifies both 1A/1B; this is the floor-count
    reconciliation. `12` is a FLOOR (not exact — 10 was a KNOWN undercount);
    F4 finalizes the exact value against the `EXPECTED_FIXTURES` fixed-denominator
    self-check pattern. Do NOT confuse with `EXPECTED_GUARD_TEST_COUNT` (65, Rust
    `#[test]` fns) or `EXPECTED_FIXTURES` (14, `check-ci-gate.sh --self-test`,
    `13 → 14` this cycle then stable).
19. **F4 OBLIGATION / BLOCKING PRECONDITION — `sentinel_files` (and every other)
    array expansion in `mutants-aggregate.sh` needs the
    `[ "${#arr[@]}" -eq 0 ]` empty-array short-circuit under `set -u`
    (architecture-delta §6.11 F4-obligation 4, the pass-3 MEDIUM-1
    bash-3.2-macOS nounset precedent).** `mutants-aggregate.sh` builds
    `sentinel_files=("${STATUS_DIR}"/mutants-shard-status-*/shard-status-*.json)`
    under `shopt -s nullglob` and reads `"${#sentinel_files[@]}"`. On macOS bash
    3.2.57 — the runtime backing this repo's `#[cfg(unix)]` subprocess tests'
    `macos-latest` leg — expanding a declared-but-empty array under `set -u` is a
    FATAL "unbound variable" error, exactly the class round-3 MEDIUM-1 fixed for
    `check-ci-gate.sh`'s `ALLOWED_SKIPS`. F4 MUST empirically verify (real bash
    3.2.57, not inferred from ubuntu — mirroring `check-ci-gate.sh`'s own round-3
    proof methodology) whether the COUNT form `"${#empty_array[@]}"` is affected,
    and if so apply the same `ALLOWED_SKIPS`-style non-empty guard before the
    expansion, to `sentinel_files` AND any other array `mutants-aggregate.sh`
    expands. Not blocking F4 completion of note-17's items 1–3, but MUST land
    before this cycle's PR merges if the empirical check finds it IS affected —
    a caught-at-CI false-red otherwise (the `macos-latest` leg would crash on a
    legitimately-empty shard set), same "fail-closed by default, verify before
    shipping an assumption" discipline the §1 F4 Blocking Preconditions apply to
    the `--list`⇔pooled reconciliation premise.
20. **Round-8 evidence-source-integrity pins (VP-026/027, §6.8 corrected M2-n
    row / items 23-24, F-H1 HIGH) — the TRUE M2-n analog for this job.** F4 adds
    two byte-VALUE structural pins on `mutants-aggregate`'s eval-step `env:`
    mapping: `PINNED_MUTANTS_AGGREGATE_STATUS_DIR_LINE == "${{ runner.temp
    }}/shard-status"` (VP-026, `test_mutants_aggregate_status_dir_env_wired`) and
    `PINNED_MUTANTS_AGGREGATE_SHARD_DIR_LINE == "${{ runner.temp }}/shards"`
    (VP-027, `test_mutants_aggregate_shard_dir_env_wired`), both via the EXISTING
    byte-exact env-child-value technique items 10/12 already use for
    `ESCALATED`/`EVENT_NAME` — zero new `wf.rs` code (note 7). Two SEPARATE tests
    (one-test-per-pinned-variable), driving `EXPECTED_GUARD_TEST_COUNT` 60 → 62.
    These close F-H1: `STATUS_DIR`/`SHARD_DIR` locate the ENTIRE evidence set the
    decision reads, so a PR redirecting them to attacker-controlled directories +
    checked-in fabricated sentinels/`outcomes.json` (`caught==MUTANT_COUNT`)
    forges a 100%-caught FALSE PASS while real shard results are bypassed. The
    pre-round-8 §6.8 M2-n disposition wrongly DECLINED these pins, treating bash's
    `${VAR:?}` as "stronger than any static pin could assert" — `${VAR:?}` proves
    abort-on-UNSET/EMPTY only and gives ZERO protection against a malicious-but-SET
    redirect. **VP-018's rationale is CORRECTED accordingly** (see VP-018 body):
    the env-KEY-SET pin (guards `BASH_ENV:`-class KEY smuggling) and the byte-VALUE
    pins VP-026/027 (guard evidence-source VALUE redirect) are COMPLEMENTARY proofs
    of DIFFERENT failure modes — never redundant — exactly as VP-010/VP-015 coexist
    with the key-set pin for `ESCALATED`/`EVENT_NAME`. **§6.8's M2-n row is now
    MIRRORED, not declined** (architecture-delta §6.8 corrected M2-n row); the
    round-8 declination re-audit re-verified every OTHER §6.8/§6.11
    declined/N-A/accepted-residual row SOUND — two STRENGTHENED (`MUTANT_COUNT`'s
    reconciliation backstop, whose soundness had been silently conditional on
    `STATUS_DIR`/`SHARD_DIR` being trustworthy — a dependency VP-026/027 now close
    structurally; and `PLAN_RESULT`'s newly-traced Step-2 sentinel-presence
    interlock), with an `OVERALL_DIFF_LINES` LOW residual named explicitly for the
    first time. No invariant STATEMENT changes; no fixture change
    (`EXPECTED_MUTANTS_AGG_FIXTURES` stays at floor `12`, `EXPECTED_FIXTURES` at
    `14`, `EXPECTED_JQ_TRUST_CHECKS` at `17`) — items 23/24 are Rust-side
    structural pins on `ci.yml`'s parsed YAML, not bash self-test fixtures.
21. **Round-9 declined-env-value-pin-class elimination (VP-028/029/030, §6.8
    MIRRORED M2-n row / items 25-27, LOW-1) — the CIRCULAR reconciliation-disable
    closed; ALL SEVEN eval-step env values now dual-pinned.** F4 adds three
    byte-VALUE structural pins on `mutants-aggregate`'s eval-step `env:` mapping:
    `PINNED_MUTANTS_AGGREGATE_MUTANT_COUNT_LINE == "${{ needs.mutants-plan.outputs.mutant_count }}"`
    (VP-028, `test_mutants_aggregate_mutant_count_env_wired`),
    `PINNED_MUTANTS_AGGREGATE_OVERALL_DIFF_LINES_LINE == "${{ needs.mutants-plan.outputs.overall_diff_lines }}"`
    (VP-029, `test_mutants_aggregate_overall_diff_lines_env_wired`), and
    `PINNED_MUTANTS_AGGREGATE_PLAN_RESULT_LINE == "${{ needs.mutants-plan.result }}"`
    (VP-030, `test_mutants_aggregate_plan_result_env_wired`), all via the EXISTING
    byte-exact env-child-value technique items 10/12/23/24 already use — zero new
    `wf.rs` code (note 7). Three SEPARATE tests (one-test-per-pinned-variable),
    driving `EXPECTED_GUARD_TEST_COUNT` 62 → 65. **VP-028 is the load-bearing one:**
    the round-8 declination of its byte-VALUE pin was CIRCULAR — Step-4
    reconciliation is keyed on `total_scored != MUTANT_COUNT`, so a PR hardcoding
    `MUTANT_COUNT` to the real pooled total makes reconciliation pass TRIVIALLY,
    disabling sub-invariant 8's completeness guard (VP-008) while the runtime
    backstop stays deceptively GREEN (it reads the forged value against itself). The
    byte-VALUE pin is the ONLY check that catches this false-green — the SAME class
    of gap as F-H1, one round on. VP-029/030 retire the other two declined value
    pins (the runtime `^[0-9]+$` regex guard, VP-013, and the Step-2
    sentinel-presence interlock are RETAINED as complementary proofs of different
    failure modes, not replaced). After round-9, ALL SEVEN of `mutants-aggregate`'s
    eval-step env values carry BOTH a key-set pin (VP-018) AND an individual
    byte-VALUE pin — NO value-pin declination remains. **VP-018's rationale is
    updated accordingly** (see VP-018 body): the earlier "three keys with no
    byte-VALUE pin" clause is retired. **§6.8's M2-n disposition rows for
    `MUTANT_COUNT`/`OVERALL_DIFF_LINES`/`PLAN_RESULT` move from DECLINED to
    MIRRORED** (architecture-delta round-9 items 25-27 + updated Declination re-audit
    table). No invariant STATEMENT changes; no fixture change
    (`EXPECTED_MUTANTS_AGG_FIXTURES` stays at floor `12`, `EXPECTED_FIXTURES` at
    `14` — `13 → 14` this cycle, then stable, LOW-2 framing, `EXPECTED_JQ_TRUST_CHECKS`
    at `17`) — items 25-27 are Rust-side structural pins on `ci.yml`'s parsed YAML,
    not bash self-test fixtures.
