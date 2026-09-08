---
document_type: spec-evolution-design-appendix
feature_name: "mutants-ci-sharding"
cycle: cycle-006
created: 2026-09-07
status: draft
author: architect (vsdd-factory)
traces_to: .factory/phase-f2-spec-evolution/cycle-006/mutants-sharding-invariants.md
purpose: Pseudo-YAML F4 implements near-verbatim. Not itself a ci.yml edit —
  design appendix only.
revision_note: "Round-7 adversarial fix (F2 fresh-context review, seventh
  pass) — FALSE-GREEN mandate again CLEAN; MEDIUM finding closed
  (architecture-delta.md §6.11 for the full rationale, VP-catalog
  additions in verification-delta.md): `scripts/mutants-aggregate.sh`
  (§3 below) never mirrored `scripts/check-ci-gate.sh`'s SCRIPT-LEVEL
  RUNTIME hardening (the PATH-shim-resistant `resolve_trusted_jq`
  machinery, `set -euo pipefail`, the pure-bash-dirname anti-shim fix) —
  only its Rust-side STRUCTURAL pins (§6.8) were mirrored, in round-4. This
  round (1) extracts `trusted_jq_dirs_for`/`is_trusted_jq_dir`/
  `resolve_trusted_jq` out of `check-ci-gate.sh` into a NEW shared,
  sourced library file, `scripts/lib/trusted-jq.sh` (new §3a below), so a
  future jq-trust fix cannot land in one decision-path script and miss the
  other; (2) `scripts/mutants-aggregate.sh`'s script body (§3) is revised
  to source that library, resolve `jq_bin` ONCE via `resolve_trusted_jq`
  before Step 0 (mirroring `check-ci-gate.sh::evaluate_needs`'s own
  resolve-once-reuse-everywhere discipline), and route every jq
  invocation through `\"${jq_bin}\"` instead of a bare `jq`; (3)
  `set -uo pipefail` is upgraded to `set -euo pipefail` (matching
  `check-ci-gate.sh`'s strict-mode posture — the prior omission of `-e`
  had no documented rationale); (4) a `bash -n \"${BASH_SOURCE[0]}\"`
  explicit syntax self-check is added, matching `check-ci-gate.sh`'s own
  convention. No Step 0-6 DECISION LOGIC changes this round — every
  behavioral branch (INV-AGG/INV-COMPLETE/INV-ESCALATE) is byte-identical
  to round-6; this is exclusively a runtime-hardening / supply-chain-trust
  change to HOW the script resolves and invokes jq, not WHAT it decides.
  Round-6 adversarial fix (F2 fresh-context review, sixth
  pass) — FALSE-GREEN mandate declared CLEAN this round; the round-5 Step
  4 design itself is UNCHANGED (no new finding in the pseudo-YAML). Only
  the Step 4 in-line comment's characterization of the empirical-premise
  mitigation is updated (M-1), to match the strengthened, BLOCKING F4
  precondition now specified in mutants-sharding-invariants.md's round-6
  addendum and architecture-delta.md §1/§6.10: a scratch-run verification
  performed DURING F4, BEFORE cycle-006's own PR merges — not deferred to
  discovery on PR #778, which is now a CONFIRMING, production-scale
  exercise rather than the sole verification point. No pseudo-YAML script
  BODY changes from round-6 — this is a comment-accuracy fix only.
  Round-5 adversarial fix (F2 fresh-context review, fifth
  pass) — REVERSES round-4's Step 4 downgrade. Round-4 had changed Step 4
  (INV-AGG sub-invariant 8, pooled-total <-> `MUTANT_COUNT` reconciliation)
  from `return 1` on mismatch to a non-blocking `::warning::` that falls
  through to Steps 5/6. Round-5 restores the hard `return 1` (both
  directions of the comparison, `total_scored != MUTANT_COUNT` — see
  mutants-sharding-invariants.md's round-5 callout for the full
  exact-equality-vs-directional decision and the mandatory F4
  empirical-determination task, anchored on PR #778 as the first real
  nonzero-`MUTANT_COUNT` exercise since cycle-006's own PR is CI/doc-only
  and cannot exercise this path). Because Step 4 now returns before Step 5
  can ever run when `MUTANT_COUNT > 0` and a mismatch exists, Step 5's
  `total_scored == 0` branch is corrected below: with reconciliation
  restored, that branch is reachable ONLY when `total_scored == MUTANT_
  COUNT == 0` (both trivially zero and already reconciled) — it can no
  longer be reached via a nonzero `MUTANT_COUNT` that happened to reconcile
  to a zero pooled total through a masked mismatch, since a mismatch of any
  kind now fails at Step 4 first. Step 5's `total_scored == 0` success
  message is corrected to state this precisely (see that step below).
  Round-3 adversarial fix (F2 fresh-context review, third
  pass; HIGH-1 + extraction precondition — full rationale:
  architecture-delta.md §6.2a/§6.7). Section 3 (`mutants-aggregate`)'s
  'Evaluate sharded mutation gate' step's ENTIRE script body is EXTRACTED
  out of inline `run: |` YAML text into a new invokable file,
  `scripts/mutants-aggregate.sh` (mirroring `scripts/check-ci-gate.sh`'s
  own shape, including a `--self-test` mode wired into `spec-guard` — new
  §5 below) — a BLOCKING F2-gate precondition, since the already-planned
  INV-AGG/INV-COMPLETE behavioral guard-tests require a genuinely
  invokable script to test, not inline YAML text. The step's `env:`
  mapping gains two new keys, `STATUS_DIR`/`SHARD_DIR`, which the inline
  design had templated directly via `${{ runner.temp }}` inside the bash
  text itself — a substitution that only happens within YAML fields, never
  inside a file merely invoked BY one, so the extraction forces these two
  paths to become ordinary environment variables. Step 0 (push-event
  no-op) is rewritten from a fail-OPEN `!=` comparison (any EVENT_NAME
  other than the literal `pull_request` string, including an empty one
  produced by a mistyped `${{ }}` expression, silently exited 0 with ZERO
  shard inspection) to a fail-CLOSED allowlist `case` statement (only a
  KNOWN non-PR event exits 0 early; anything else, including empty, is a
  hard FAIL). Round-2 (previous revision) hardened Section 1
  (`mutants-plan`)'s 'Compute diff and mutation plan' step so it no longer
  swallows `cargo mutants --list --in-diff`'s own exit status into a
  `2>/dev/null | wc -l` pipeline under this step's deliberate `set -uo
  pipefail` (no `-e`) — it now captures `--list`'s exit status explicitly
  and fails the job closed on a genuine `--list` failure instead of
  silently coercing it to `MUTANT_COUNT=0`. Section 3's Step 5
  base-ref-drift guard gained a matching `^[0-9]+$` regex guard on
  `OVERALL_DIFF_LINES` (previously only its UNSET case was handled via
  `:-0`; a malformed-but-SET value silently routed to the wrong branch —
  see mutants-sharding-invariants.md §INV-AGG sub-invariant 8's round-2
  callout and architecture-delta.md §6.6 LOWs). Round-1 added Section 2's
  two new sentinel steps ('Write shard status sentinel', 'Upload shard
  status sentinel') between the existing run-mutants and
  Upload-shard-outcomes steps, and Section 3 gained a second
  download-artifact step for the sentinels plus a substantially rewritten
  'Evaluate sharded mutation gate' script around the sentinel mechanism —
  see mutants-sharding-invariants.md §INV-COMPLETE for that rationale
  (CRIT-1 false-green + HIGH-1 false-red, closed together)."
---

# CI YAML Design Appendix (cycle-006)

Pseudo-YAML for the three new/changed `ci.yml` jobs and the new scheduled
workflow file. Comments explain WHY, matching this repo's existing dense
in-YAML documentation convention (see the current `mutants` job for the
style bar to match). F4 should treat this as near-verbatim — the exact
`uses:` pins (SHA + version comment) must be copied from the CURRENT
`ci.yml` at implementation time (`step-security/harden-runner`,
`actions/checkout`, `taiki-e/install-action`, `Swatinem/rust-cache`), not
re-typed from memory, since this document was written without re-verifying
those pins are still current at F4's implementation time.

---

## 1. `mutants-plan` job (NEW, replaces the diff-computation portion of
today's `mutants` job)

```yaml
  mutants-plan:
    name: Mutation Test Plan
    runs-on: ubuntu-latest
    # Conservative, independent of the shard/aggregate budgets — this job
    # does a `git diff` + a `cargo mutants --list` pre-count, not a full
    # mutation run. If this ever approaches its own budget, the --list
    # invocation itself has become a timeout risk distinct from the shard
    # runs (see mutants-sharding-invariants.md §INV-ESCALATE Residual Risk 1).
    timeout-minutes: 15
    if: github.event_name == 'pull_request'
    outputs:
      escalated: ${{ steps.plan.outputs.escalated }}
      mutant_count: ${{ steps.plan.outputs.mutant_count }}
      overall_diff_lines: ${{ steps.plan.outputs.overall_diff_lines }}
    steps:
      - name: Harden the runner (Audit all outbound calls)
        uses: step-security/harden-runner@<CURRENT_SHA>  # v2.21.0 — copy exact pin from ci.yml at implementation time
        with:
          egress-policy: audit

      - uses: actions/checkout@<CURRENT_SHA>  # v7.0.1 — copy exact pin
        with:
          fetch-depth: 0  # needed for `git diff origin/<base_ref>...HEAD`

      - uses: taiki-e/install-action@<CURRENT_SHA>  # copy exact pin + full comment block from today's mutants job
        with:
          # cycle-006: tightened from major-only @27 to the exact release
          # @27.1.0 (research-recommended: the aggregator now depends on
          # outcomes.json's schema being stable across N invocations
          # instead of 1, strengthening the case for an exact pin).
          tool: cargo-mutants@27.1.0
      - uses: Swatinem/rust-cache@<CURRENT_SHA>  # v2 — copy exact pin

      - name: Compute diff and mutation plan
        id: plan
        run: |
          set -uo pipefail  # deliberately NOT -e here — see F-4 note below

          DIFF_FILE="${{ runner.temp }}/pr-${{ github.run_id }}.diff"
          # F-4 (carried from today's mutants job, unchanged rationale):
          # || true so a base-ref resolution failure does not abort before
          # OVERALL_DIFF_LINES is computed — an empty DIFF_FILE still
          # correctly routes through the base-ref-drift branch downstream
          # in mutants-aggregate, never a silent false-green.
          git diff origin/${{ github.base_ref }}...HEAD > "${DIFF_FILE}" || true

          OVERALL_DIFF_LINES=$(wc -l < "${DIFF_FILE}" | tr -d ' ')
          echo "Overall diff lines: ${OVERALL_DIFF_LINES}"

          # Pre-count in-diff mutants for the escape hatch (INV-ESCALATE)
          # AND for mutants-aggregate's pooled-total reconciliation
          # (INV-AGG sub-invariant 8). `cargo mutants --list` exits 0 even
          # on an empty diff (0 lines listed) — no special-casing needed
          # for THAT case.
          #
          # ROUND-2 ADVERSARIAL FIX (MEDIUM-2, mutants-sharding-
          # invariants.md §INV-AGG sub-invariant 8 "Round-2 adversarial
          # fix" callout). The original form here was
          # `MUTANT_COUNT=$(cargo mutants --list --in-diff "${DIFF_FILE}"
          # 2>/dev/null | wc -l | tr -d ' ')` — under this step's
          # deliberate `set -uo pipefail` (NO `-e`, see the design note
          # below), a non-zero exit from `cargo mutants --list` itself
          # does NOT abort the script: the pipeline's own exit status is
          # simply discarded the moment it is captured via `$(...)`
          # command substitution, `2>/dev/null` throws away whatever
          # diagnostic `--list` printed to explain the failure, and
          # `wc -l` reports however many lines WERE printed before the
          # failure (most often 0, but not necessarily). A genuine
          # `--list` tooling failure — a bad base-ref, an
          # `examine_globs`/`.cargo/mutants.toml` misconfiguration, a
          # `cargo-mutants@27.1.0` regression — is therefore
          # indistinguishable, downstream, from a legitimate zero-mutant
          # PR: both silently produce `MUTANT_COUNT=0` and let the plan
          # step exit 0 as if nothing were wrong. Fixed: capture
          # `--list`'s own exit status EXPLICITLY, separately from the
          # line count, and FAIL THIS JOB CLOSED on a non-zero exit
          # rather than silently coercing it to a count.
          LIST_OUTPUT="${{ runner.temp }}/mutant-list.txt"
          LIST_STDERR="${{ runner.temp }}/mutant-list.stderr"
          if ! cargo mutants --list --in-diff "${DIFF_FILE}" \
                 > "${LIST_OUTPUT}" 2> "${LIST_STDERR}"; then
            echo "FAIL: 'cargo mutants --list --in-diff' exited non-zero —"
            echo "      cannot reliably pre-count in-diff mutants. This is a"
            echo "      tooling failure (bad base-ref, examine_globs"
            echo "      misconfiguration, or a cargo-mutants regression),"
            echo "      NOT a legitimate zero-mutant result. Failing this"
            echo "      job closed rather than silently treating this as"
            echo "      MUTANT_COUNT=0 (see mutants-sharding-invariants.md"
            echo "      §INV-AGG sub-invariant 8's residual-risk note)."
            echo "      --- cargo mutants --list stderr ---"
            cat "${LIST_STDERR}"
            exit 1
          fi
          MUTANT_COUNT=$(wc -l < "${LIST_OUTPUT}" | tr -d ' ')
          echo "In-diff mutant count: ${MUTANT_COUNT}"

          # Human-reviewed literal (mutants-sharding-invariants.md
          # §Threshold Derivation) — update in the SAME commit as any
          # deliberate change to shard count N or per-shard --timeout.
          ESCALATION_THRESHOLD=120
          if [ "${MUTANT_COUNT}" -gt "${ESCALATION_THRESHOLD}" ]; then
            ESCALATED=true
            echo "::warning::PR generates ${MUTANT_COUNT} in-diff mutants (> ${ESCALATION_THRESHOLD}) — escalating (see mutants-aggregate's own log for the actionable message)."
          else
            ESCALATED=false
          fi

          echo "escalated=${ESCALATED}" >> "${GITHUB_OUTPUT}"
          echo "mutant_count=${MUTANT_COUNT}" >> "${GITHUB_OUTPUT}"
          echo "overall_diff_lines=${OVERALL_DIFF_LINES}" >> "${GITHUB_OUTPUT}"

      - name: Upload diff file (shared across all shards — INV-AGG sub-invariant "identical diff")
        uses: actions/upload-artifact@<CURRENT_SHA>  # pin per repo convention — this is a NEW uses: for this repo's ci.yml if not already used elsewhere; verify at implementation time and add the same Harden-the-runner egress consideration other jobs apply
        with:
          name: mutants-diff-file
          path: ${{ runner.temp }}/pr-${{ github.run_id }}.diff
          if-no-files-found: error  # a missing diff file here is itself a plan-job bug, not a legitimate empty-diff case (an empty diff still produces a zero-byte FILE, which satisfies "found")
          retention-days: 1
```

**Design notes:**
- `set -uo pipefail` (no `-e`) on the plan step, deliberately: the `|| true`
  pattern on the `git diff` line already exists to survive a base-ref
  resolution failure; adding `-e` back would risk the SAME class of bug
  MUTATION-CI-TIMEOUT's F-4 fix originally closed, just relocated to this
  new job. Every other line in this step is expected to succeed under
  normal conditions; `set -u` still catches unset-variable typos.
  **(Round-2, MEDIUM-2) the `cargo mutants --list --in-diff` invocation is
  the ONE line in this step that is explicitly checked with `if ! ...;
  then exit 1; fi` rather than relying on ambient `-e`/`pipefail`
  behavior** — precisely because the step deliberately runs WITHOUT `-e`,
  a command whose failure must be fail-closed (unlike `git diff`, whose
  failure is deliberately absorbed by `|| true`) needs its own explicit
  check; do not assume `pipefail` alone catches this the way it would
  under `-e` (`pipefail` only affects a pipeline's REPORTED exit status,
  it does not itself abort the script without `-e`).
- `overall_diff_lines` output is threaded to `mutants-aggregate` for the
  base-ref-drift guard, which moves here from the single-job design per
  `docs/specs/cargo-mutants-policy.md §Future Path: Job Sharding (Path B)`
  item 5 (already anticipated in the pre-existing policy doc).

---

## 2. `mutants` job (MODIFIED — becomes the shard matrix)

```yaml
  mutants:
    name: Mutation Testing (Shard)
    runs-on: ubuntu-latest
    needs: [mutants-plan]
    strategy:
      fail-fast: false  # every shard's report must be produced regardless
                         # of another shard's outcome — INV-COMPLETE needs
                         # every shard's artifact, not just the first N-1
                         # that finish before one fails.
      matrix:
        shard: [0, 1, 2, 3, 4, 5, 6, 7]  # N=8 — the SOLE declaration of N;
                                          # mutants-aggregate's EXPECTED_SHARDS
                                          # literal must match this list's
                                          # length in the SAME commit
                                          # (see mutants-sharding-invariants.md
                                          # §INV-COMPLETE).
    # Explicitly re-derives the PR-only condition rather than relying on
    # implicit needs-success propagation from mutants-plan (defense in
    # depth — see architecture-delta.md §GHA if:/needs: Semantics Decision
    # for why this job does not lean on any assumption about how a custom
    # `if:` here interacts with mutants-plan's own success/failure).
    if: github.event_name == 'pull_request' && needs.mutants-plan.outputs.escalated != 'true'
    timeout-minutes: 60  # NOT 240 — a stuck SHARD fails fast; the
                          # aggregator (not a single shard) is the budget
                          # backstop. ~15 mutants/shard at ~140s/mutant
                          # median ≈ 35min; 60min gives headroom without
                          # reintroducing the original multi-hour risk.
    steps:
      - name: Harden the runner (Audit all outbound calls)
        uses: step-security/harden-runner@<CURRENT_SHA>  # copy exact pin
        with:
          egress-policy: audit

      - uses: actions/checkout@<CURRENT_SHA>  # copy exact pin
        # fetch-depth: 0 is NOT needed here — the diff was already computed
        # once in mutants-plan and is downloaded below, not recomputed.

      - uses: taiki-e/install-action@<CURRENT_SHA>  # copy exact pin + comment block
        with:
          tool: cargo-mutants@27.1.0  # same exact pin as mutants-plan
      - uses: Swatinem/rust-cache@<CURRENT_SHA>  # v2 — copy exact pin

      - name: Download shared diff file
        uses: actions/download-artifact@<CURRENT_SHA>  # pin per repo convention
        with:
          name: mutants-diff-file
          path: ${{ runner.temp }}/diff

      - name: Run mutation tests on this shard
        id: run-mutants
        # continue-on-error: true — same rationale as today's single-job
        # design: the aggregator (not this step's own exit code) is the
        # sole pass/fail arbiter. A shard reporting missed/timeout mutants
        # is expected, routine output, not a shard-job failure.
        continue-on-error: true
        run: |
          DIFF_FILE="${{ runner.temp }}/diff/pr-${{ github.run_id }}.diff"
          # --baseline skip: legitimate here because `test` (ci-gate.needs
          # member) already proves the suite green before mutants ever
          # runs; --timeout 240 is REQUIRED explicitly under skip (no
          # timeout_multiplier fallback — see docs/specs/cargo-mutants-
          # policy.md §--baseline=skip and Path B).
          cargo mutants --in-diff "${DIFF_FILE}" \
            --shard ${{ matrix.shard }}/8 --sharding slice \
            --jobs 2 --baseline skip --timeout 240

      - name: Write shard status sentinel
        # ROUND-1 ADVERSARIAL FIX (CRIT-1 + HIGH-1, see
        # mutants-sharding-invariants.md §INV-COMPLETE Part A). Runs
        # UNCONDITIONALLY (if: always()) after run-mutants, regardless of
        # that step's outcome or whether mutants.out/outcomes.json exists.
        # This is the ONLY source of truth mutants-aggregate has for
        # "did this shard's run-mutants step actually complete
        # successfully" — critically, it reads steps.run-mutants.outcome,
        # NOT .conclusion. `continue-on-error: true` on run-mutants forces
        # .conclusion to ALWAYS read 'success' at the job-status level;
        # .outcome is the one context value that still reflects what
        # genuinely happened inside the step. Reading .conclusion here
        # would silently reopen CRIT-1.
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
          if-no-files-found: error  # unlike the outcomes.json upload below,
                                     # the write step above ALWAYS produces
                                     # this file on every reachable path —
                                     # its absence here is a bug in this
                                     # step sequence itself (e.g. a runner
                                     # that died mid-job before reaching
                                     # even this always() step), which is
                                     # precisely the case
                                     # mutants-aggregate's Part B presence
                                     # check must be told about via a
                                     # missing artifact, not silently
                                     # warned about here and then hidden.
          retention-days: 1

      - name: Upload shard outcomes
        # if: always() — a shard that crashed or exceeded its own
        # timeout-minutes still uploads whatever partial mutants.out/
        # exists (possibly nothing). Unlike the pre-fix design, this
        # artifact's presence/absence is NO LONGER how mutants-aggregate
        # determines completeness (that is now the status-sentinel
        # artifact above, uploaded independently of this one) — this
        # remains purely a DATA artifact, interpreted per the status
        # sentinel's has_outcomes/run_outcome fields.
        if: always()
        uses: actions/upload-artifact@<CURRENT_SHA>  # pin per repo convention
        with:
          name: mutants-shard-outcomes-${{ matrix.shard }}
          path: mutants.out/outcomes.json
          if-no-files-found: warn  # still correct to warn-not-error: a
                                    # shard that genuinely produced 0
                                    # mutants (e.g. an uneven
                                    # `--sharding slice` split leaves one
                                    # shard with no lines — the routine
                                    # HIGH-1 case) legitimately has no
                                    # outcomes.json. The status sentinel
                                    # (uploaded above, unconditionally) is
                                    # what lets mutants-aggregate tell this
                                    # apart from a crash; this step's own
                                    # if-no-files-found policy no longer
                                    # needs to carry that distinction.
          retention-days: 1
```

**Design notes:**
- This job is **never** a `ci-gate.needs` member (DEC-096/097 compliance —
  only `mutants-aggregate` is). It is admitted into `ci.yml`'s job universe
  via `PINNED_GATE_EXCLUDED_JOBS`, not `ci-gate.needs` — see
  `architecture-delta.md §Guardrail Lockstep Plan`.
- `--sharding slice` (not `round-robin`) per the research grounding's
  default-since-v26 recommendation (better build locality; per-shard
  runtime unevenness is bounded by the 60-minute per-shard timeout).
- The job id is kept as `mutants` (not renamed to `mutants-shard`) to
  minimize churn on the many pre-existing `docs/specs/cargo-mutants-
  policy.md` / CLAUDE.md prose references to "the `mutants` job" that
  describe this exact PR-diff-scoped mutation-testing step — only its
  *shape* (single job → matrix) and its *relationship to `ci-gate.needs`*
  (member → excluded, since `mutants-aggregate` is now the member) change.
- **(Round-1)** Required step names for
  `test_mutants_shard_job_structure_matches_sharded_design`
  (`architecture-delta.md §6.2` item 3) now become `["Harden the runner
  (Audit all outbound calls)", "Run mutation tests on this shard", "Write
  shard status sentinel", "Upload shard status sentinel", "Upload shard
  outcomes"]` — the two new sentinel steps are inserted between the
  existing run and upload steps, matching this section's step ordering
  exactly.

---

## 3. `mutants-aggregate` job (NEW — the `ci-gate.needs` member)

```yaml
  mutants-aggregate:
    name: Mutation Testing (Aggregate)
    runs-on: ubuntu-latest
    needs: [mutants-plan, mutants]
    timeout-minutes: 15  # aggregation is jq/bash arithmetic over N small
                          # JSON files — not a build or test run; generous
                          # relative to expected sub-minute actual cost.
    # if: always() is LOAD-BEARING, mirroring ci-gate's own S-CIGATE-1
    # AC-002 rationale verbatim: without job-level always() here, a failed
    # or skipped upstream job (mutants-plan on a push event; `mutants`
    # skipped when escalated or on push) SKIPS this job entirely under
    # GitHub Actions' default needs behavior — and this job must ALWAYS
    # run to make its own internal pass/fail/no-op decision (INV-COMPLETE,
    # INV-ESCALATE). This job NEVER reports `skipped` to GitHub Actions —
    # see the first step below, which resolves push-event no-op via an
    # explicit `exit 0`, not via a job-level `if:` short-circuit. This is
    # the deliberate design choice documented in architecture-delta.md
    # §GHA if:/needs: Semantics Decision: rather than relying on an
    # unverified assumption about how a bare, non-always() custom `if:`
    # interacts with an upstream job's failure, this job reuses the ONE
    # mechanism already proven correct in THIS file for exactly this
    # purpose (ci-gate itself).
    #
    # ROUND-1 (LOW, style): write this bare — `always()`, NOT
    # `${{ always() }}`. PINNED_ALWAYS_RUN_WITH_IF_EXCEPTIONS pins the
    # bare literal "always()" for this job specifically (see
    # architecture-delta.md §6.2); `ci-gate`'s own job-level `if:` happens
    # to use the braced form (`${{ always() }}`, separately pinned as
    # PINNED_GATE_IF_EXPR) — the two pins are independent and NOT
    # byte-compatible with each other. Do not "match" ci-gate's style here.
    if: always()
    steps:
      - name: Harden the runner (Audit all outbound calls)
        uses: step-security/harden-runner@<CURRENT_SHA>  # copy exact pin
        with:
          egress-policy: audit

      - uses: actions/checkout@<CURRENT_SHA>  # copy exact pin
        # needed so this step can read docs/specs/cargo-mutants-policy.md's
        # exact wording for the escalation message if F4 chooses to source
        # it from the repo rather than duplicate it inline; not strictly
        # required if the message stays fully inline (F4's call).

      - name: Download all shard status sentinels
        # ROUND-1 ADVERSARIAL FIX. This is the artifact set Part B
        # (presence) and Part C (interpretation) of INV-COMPLETE actually
        # reason over — see mutants-sharding-invariants.md §INV-COMPLETE.
        # Runs even when `mutants` (the shard matrix) was entirely skipped
        # (push event, or escalated) — download-artifact on a nonexistent
        # artifact pattern simply finds nothing; the script step below
        # interprets "found nothing" correctly for each reachable case
        # (push no-op / escalated / genuinely missing shards), not this
        # step.
        if: always()
        uses: actions/download-artifact@<CURRENT_SHA>  # pin per repo convention
        with:
          pattern: mutants-shard-status-*
          path: ${{ runner.temp }}/shard-status
          merge-multiple: false  # own named subdirectory per shard —
                                  # required for the per-shard-index
                                  # presence check to name a SPECIFIC
                                  # missing index, not just a count.

      - name: Download all shard outcomes
        # Purely a DATA download now (see mutants job's Design Notes) —
        # completeness is decided from the status sentinels above, not
        # from this artifact's presence/absence.
        if: always()
        uses: actions/download-artifact@<CURRENT_SHA>  # pin per repo convention
        with:
          pattern: mutants-shard-outcomes-*
          path: ${{ runner.temp }}/shards
          merge-multiple: false  # keep each shard's outcomes.json in its
                                  # own named subdirectory — Part C reads
                                  # each by the SAME index it already
                                  # confirmed present via the sentinel.

      - name: Evaluate sharded mutation gate
        # if: always() at the STEP level too, mirroring `Check kill rate`'s
        # existing single-job convention — this step is this job's sole
        # pass/fail arbiter and must run regardless of the download step's
        # own outcome (a download failure for a genuinely-absent artifact
        # set is not itself a step failure under download-artifact's
        # default behavior, but always() here costs nothing and matches
        # the established local convention).
        if: always()
        env:
          EVENT_NAME: ${{ github.event_name }}
          ESCALATED: ${{ needs.mutants-plan.outputs.escalated }}
          OVERALL_DIFF_LINES: ${{ needs.mutants-plan.outputs.overall_diff_lines }}
          MUTANT_COUNT: ${{ needs.mutants-plan.outputs.mutant_count }}
          PLAN_RESULT: ${{ needs.mutants-plan.result }}
          # ROUND-3 ADVERSARIAL FIX (extraction, architecture-delta.md
          # §6.2a): these two are NEW. The pre-round-3 inline design
          # templated `${{ runner.temp }}/shard-status` / `.../shards`
          # directly inside the bash text below — that only works because
          # GitHub Actions substitutes `${{ }}` WITHIN this YAML field
          # itself. Once the script body moves to a separate file (below),
          # `${{ }}` inside THAT file's text would never be substituted at
          # all (it is invoked BY this `run:` step, not interpolated
          # THROUGH it) — so these two paths must be handed across as
          # ordinary environment variables instead.
          STATUS_DIR: ${{ runner.temp }}/shard-status
          SHARD_DIR: ${{ runner.temp }}/shards
        run: bash scripts/mutants-aggregate.sh
```

**Design notes (round-3 extraction):**
- **This is a BLOCKING F2-gate precondition, not a style preference.**
  `mutants-sharding-invariants.md`'s own Guard-test write-ups for items
  1/2/3/6/7/8 (`architecture-delta.md §6.2`) already describe themselves
  as "mirroring `check-ci-gate.sh`'s `check_fixture` pattern" — i.e. they
  assume an invokable script under test. Inline `run: |` YAML text cannot
  be invoked directly from a Rust subprocess test or a bash `--self-test`
  harness; without this extraction those six guard-tests could only
  become either a fragile YAML-text-reparsing shim (the exact "extraction
  under-reports" defect class this repo's entire multi-round CI-gate
  history — S-CIGATE-3 and its own seven follow-on fix-bursts — exists to
  retire) or a Rust-side re-implementation of the arithmetic that can pass
  while the real `ci.yml` script diverges. Full rationale, exact script
  structure (`evaluate_mutants_aggregate()` as a `return`-based function,
  a `main()` dispatcher, the `--self-test` harness, and the new
  `spec-guard` wiring step): `architecture-delta.md §6.2a`.
- **`scripts/mutants-aggregate.sh`'s content is the SAME logic below,
  restructured as a callable function.** Every top-level `exit N` in the
  Step 0 through Step 6 script text that follows becomes `return N` inside
  a function named `evaluate_mutants_aggregate()`; a short `main "$@"`
  dispatcher at the bottom of the file calls that function (and `exit`s
  with its return code) for a normal invocation, or runs the new
  `--self-test` fixture harness instead when invoked with that flag — see
  `architecture-delta.md §6.2a` for the dispatcher shape and the fixture
  harness itself; this document specifies only the evaluation logic
  (unchanged in substance from round-2 except Step 0, rewritten below, and
  `STATUS_DIR`/`SHARD_DIR` now read from the environment).
- **(round-8, F-H1) The `STATUS_DIR`/`SHARD_DIR` env values below are
  byte-VALUE structural-pinned, not just presence-checked.** A fresh-
  context F2 adversary found that this document's own `${VAR:?message}`
  guard (Step 2 of the script body below) had been cited elsewhere
  (architecture-delta.md §6.2a's declined-additions list, §6.8's M2-n row)
  as sufficient reason to decline a static pin on these two lines —
  wrongly: `:?` guards only an UNSET/EMPTY value, never a maliciously-but-
  validly-SET redirect to an attacker-controlled directory, and these two
  paths locate the ENTIRE evidence set (`STATUS_DIR` for every shard
  status sentinel, `SHARD_DIR` for every `outcomes.json`) the aggregation
  decision reads. `tests/ci_gate_completeness.rs` now byte-pins the exact
  RHS values below — `PINNED_MUTANTS_AGGREGATE_STATUS_DIR_LINE` /
  `PINNED_MUTANTS_AGGREGATE_SHARD_DIR_LINE` (architecture-delta.md §6.2,
  items 23-24) — so a future edit cannot silently retarget either path
  without a reviewed pin update. This is a Rust-side structural addition
  only; the env values themselves, the `:?` guard, and every other line of
  this script are unchanged by it.
- **(round-9, LOW-1) The remaining three env values below —
  `MUTANT_COUNT`, `OVERALL_DIFF_LINES`, `PLAN_RESULT` — are NOW ALSO
  byte-VALUE structural-pinned, closing out the class F-H1 started.** A
  fresh-context F2 adversary (pass-13) found the round-8 declination for
  these three circular specifically for `MUTANT_COUNT`: Step 4 below
  reconciles `total_scored != MUTANT_COUNT`, so a PR that simply
  hardcodes this env line's value to whatever the pooled shards will sum
  to defeats that reconciliation by construction — the runtime backstop
  cited as the reason a pin was unnecessary is the SAME mechanism the
  attack neutralizes, because it consumes `MUTANT_COUNT` rather than
  independently verifying how it is wired. `tests/ci_gate_completeness.rs`
  now byte-pins all three RHS values below — `PINNED_MUTANTS_AGGREGATE_
  MUTANT_COUNT_LINE` / `_OVERALL_DIFF_LINES_LINE` / `_PLAN_RESULT_LINE`
  (architecture-delta.md §6.2, items 25-27) — via the SAME generic
  byte-exact env-child-value technique as `ESCALATED`/`EVENT_NAME`/
  `STATUS_DIR`/`SHARD_DIR` above. As with those four, this is a Rust-side
  structural addition only: the env values themselves, the reconciliation
  arithmetic (Step 4), the `^[0-9]+$` regex guard (Step 5), the
  `PLAN_RESULT != "success"` check (Step 0.5), and every other line of
  this script are unchanged by it — the existing runtime checks remain in
  place as complementary, independent defenses, not superseded.

```bash
#!/usr/bin/env bash
# scripts/mutants-aggregate.sh — sharded mutation-test gate aggregator
# (cycle-006). See architecture-delta.md §6.2a for the extraction
# rationale and the --self-test harness; see
# mutants-sharding-invariants.md for the INV-AGG / INV-COMPLETE /
# INV-ESCALATE invariants this function enforces; see architecture-
# delta.md §6.11 (round-7) for the runtime-hardening parity with
# scripts/check-ci-gate.sh this file adopts below (trusted-jq resolution,
# strict mode, syntax self-check).
set -euo pipefail

# Explicit syntax self-check — same repo convention check-ci-gate.sh
# documents and relies on (see that file's own header comment for the
# full rationale); kept here for consistency even though, as there, every
# function below is fully defined before `main "$@"` ever runs.
bash -n "${BASH_SOURCE[0]}"

# Source the shared, PATH-shim-resistant jq resolver (architecture-
# delta.md §6.11, round-7) — pure-bash directory computation, no external
# `dirname` call, so there is nothing on PATH left to shim for the SOURCE
# path itself (ADV-P61-HIGH-001's fix, applied here identically).
_mutants_agg_self="${BASH_SOURCE[0]}"
if [ "${_mutants_agg_self}" = "${_mutants_agg_self#*/}" ]; then
    _mutants_agg_dir="."          # no slash at all -> invoked from cwd
else
    _mutants_agg_dir="${_mutants_agg_self%/*}"
    [ -z "${_mutants_agg_dir}" ] && _mutants_agg_dir="/"
fi
# shellcheck source=lib/trusted-jq.sh
source "${_mutants_agg_dir}/lib/trusted-jq.sh"
unset _mutants_agg_self _mutants_agg_dir

evaluate_mutants_aggregate() {
  # --- Step -1 (runtime-hardening, architecture-delta.md §6.11): resolve
  #     the trusted jq binary ONCE, before Step 0, and reuse it for every
  #     jq invocation below — mirrors check-ci-gate.sh::evaluate_needs's
  #     own resolve-once-reuse-everywhere discipline (a single TOCTOU-style
  #     PATH mutation mid-function cannot then make different invocations
  #     within this same decision see different binaries). Resolved BEFORE
  #     Step 0's push-event no-op, not lazily at first use in Step 3 — a
  #     compromised jq on PATH is a red flag regardless of which internal
  #     branch would otherwise run; check-ci-gate.sh applies the identical
  #     ordering for the same reason. ---
  local jq_bin
  if ! jq_bin=$(resolve_trusted_jq); then
    return 2
  fi

          # --- Step 0: push-event no-op (this job's only "skipped"-equivalent
          #     path — resolved as an ordinary success, NEVER a GHA `skipped`
          #     conclusion; see the job-level if: always() comment above).
          #
          #     ROUND-3 ADVERSARIAL FIX (HIGH-1). The pre-fix check
          #     (`if [ "${EVENT_NAME}" != "pull_request" ]; then exit 0;
          #     fi`) was FAIL-OPEN on a malformed EVENT_NAME: GitHub
          #     Actions resolves an invalid/mistyped `${{ }}` expression
          #     to an EMPTY string, not an error — the identical platform
          #     behavior MED-2/round-1's own escalation-wiring pin already
          #     guards for on the OUTPUT side, here on the INPUT side. A
          #     typo in this step's own `env:` block (e.g. `EVENT_NAME:
          #     ${{ github.event_nam }}`) would make EVENT_NAME="" on
          #     EVERY run, including a genuine pull_request run — and the
          #     pre-fix `!=` comparison treats "" as "not pull_request,"
          #     exiting 0 with ZERO shard inspection: a false-green on the
          #     one input this script trusts to even decide whether to run
          #     its own logic.
          #
          #     Fixed: only a KNOWN, explicitly-recognized non-PR event
          #     exits 0 early; anything else — including an empty string,
          #     and including any FUTURE ci.yml trigger event nobody has
          #     added to this case statement yet — falls through to a
          #     hard FAIL naming the unrecognized value. ---
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

          # --- Step 0.5 (diagnostics improvement, INV-ESCALATE Residual
          #     Risk 5): distinguish "mutants-plan itself crashed" from the
          #     generic missing-shards message, before falling through. ---
          if [ "${PLAN_RESULT}" != "success" ]; then
            echo "FAIL: mutants-plan (diff computation + escalation pre-count) reported '${PLAN_RESULT}', not 'success'. The shard matrix could not have received a valid diff file; treat this as a harness failure, not a kill-rate failure. Check the mutants-plan job's own logs."
            return 1
          fi

  # --- Step 1: INV-ESCALATE — escalation short-circuits before any
  #     shard-artifact inspection. ---
  if [ "${ESCALATED}" = "true" ]; then
    echo "FAIL: PR generates ${MUTANT_COUNT} in-diff mutants, over the 120-mutant threshold for the sharded per-PR gate."
    echo ""
    echo "Two ways forward:"
    echo "  1. PREFERRED: split this PR into smaller, more focused changes."
    echo "  2. If genuinely large and reviewed: a repo admin can merge via"
    echo "     GitHub's branch-protection 'Require approvals' bypass,"
    echo "     explicitly acknowledging the unverified mutation coverage in"
    echo "     the PR description (same audited mechanism already used for a"
    echo "     budget-exceeded cancelled mutants run — see"
    echo "     docs/specs/cargo-mutants-policy.md §F-2)."
    echo ""
    echo "A full, non-diff-scoped run will also occur in the next scheduled"
    echo "nightly full-mutation run regardless of how this PR is merged."
    return 1
  fi

  # ============================================================
  # ROUND-1 ADVERSARIAL FIX (CRIT-1 + HIGH-1). Steps 2-5 below
  # replace the pre-fix design's count-based
  # `#shard_json_files -eq 0 -> non-empty-diff -> exit 0` branch
  # entirely. See mutants-sharding-invariants.md §INV-COMPLETE for
  # the full rationale. Ordering is load-bearing: presence (Step 2)
  # -> interpretation (Step 3) -> reconciliation (Step 4) ->
  # base-ref-drift/zero-mutant check (Step 5) -> kill-rate (Step 6).
  # ============================================================

  # --- Step 2: INV-COMPLETE Part B — sentinel presence check.
  #     This is now the SOLE fail-closed completeness gate; it does
  #     NOT look at outcomes.json at all. ---
  #     ROUND-3 EXTRACTION FIX: STATUS_DIR/SHARD_DIR are now read from
  #     the environment (set by the ci.yml step's `env:` block, see the
  #     Design Notes above) rather than templated inline via `${{
  #     runner.temp }}` — that substitution only happens within YAML
  #     fields, never inside a file this step merely invokes. Fail
  #     loudly (`:?`) rather than silently operating on an empty path
  #     if either is somehow unset.
  STATUS_DIR="${STATUS_DIR:?STATUS_DIR must be set (see ci.yml's env: block)}"
  SHARD_DIR="${SHARD_DIR:?SHARD_DIR must be set (see ci.yml's env: block)}"
  EXPECTED_SHARDS=8  # MUST match ci.yml `mutants` job's
                      # strategy.matrix.shard list length — update
                      # both in the SAME commit
                      # (test_mutants_aggregate_expected_shards_matches_matrix_shard_count
                      # cross-checks this structurally).

  shopt -s nullglob
  sentinel_files=("${STATUS_DIR}"/mutants-shard-status-*/shard-status-*.json)

  missing=()
  for i in $(seq 0 $((EXPECTED_SHARDS - 1))); do
    f="${STATUS_DIR}/mutants-shard-status-${i}/shard-status-${i}.json"
    if [ ! -f "${f}" ]; then
      missing+=("${i}")
    fi
  done
  if [ "${#missing[@]}" -gt 0 ]; then
    echo "FAIL: missing shard status sentinel for shard index/indices: ${missing[*]}"
    echo "      Expected exactly ${EXPECTED_SHARDS} status sentinels; found $(( EXPECTED_SHARDS - ${#missing[@]} ))."
    echo "      A crashed, cancelled, or never-scheduled shard job means its"
    echo "      mutants were never verified — this gate FAILS CLOSED rather"
    echo "      than silently excluding them from the denominator."
    return 1
  fi
  actual_sentinel_count="${#sentinel_files[@]}"
  if [ "${actual_sentinel_count}" -ne "${EXPECTED_SHARDS}" ]; then
    echo "FAIL: ${actual_sentinel_count} shard status sentinel(s) found, expected exactly ${EXPECTED_SHARDS} (duplicate or stray artifact — investigate a re-run/name collision)."
    return 1
  fi

  # --- Step 3: INV-COMPLETE Part C — per-shard interpretation +
  #     per-shard guards (malformed-JSON, integer-validation, H-1
  #     schema-drift, M-2 reconciliation) THEN summation
  #     (INV-AGG). ---
  caught_total=0; missed_total=0; timeout_total=0; unviable_total=0
  for i in $(seq 0 $((EXPECTED_SHARDS - 1))); do
    sentinel="${STATUS_DIR}/mutants-shard-status-${i}/shard-status-${i}.json"
    run_outcome=$("${jq_bin}" -r '.run_outcome' "${sentinel}")
    has_outcomes=$("${jq_bin}" -r '.has_outcomes' "${sentinel}")
    f="${SHARD_DIR}/mutants-shard-outcomes-${i}/outcomes.json"

    if [ "${has_outcomes}" != "true" ]; then
      if [ "${run_outcome}" = "success" ]; then
        echo "OK: shard ${i} legitimately produced 0 mutants (run_outcome=success, has_outcomes=false) — contributes 0."
        continue
      fi
      echo "FAIL: shard ${i}'s run-mutants step did not complete successfully (run_outcome=${run_outcome}) and produced no outcomes.json. Treating as a harness crash, not a legitimate 0-mutant shard."
      return 1
    fi

    # has_outcomes == true: trust the data regardless of
    # run_outcome (a non-zero cargo-mutants exit code under
    # --baseline skip is routine, not evidence of untrustworthy
    # output) — but first defend against a sentinel/data desync.
    if [ ! -f "${f}" ]; then
      echo "FAIL: shard ${i}'s status sentinel claims has_outcomes=true but mutants-shard-outcomes-${i}/outcomes.json was not found in the download. Sentinel/data desync — treating as a failure, not silently skipping."
      return 1
    fi
    if ! "${jq_bin}" empty "${f}" 2>/dev/null; then
      echo "FAIL: shard ${i}'s outcomes.json exists but is malformed JSON."
      return 1
    fi

    caught=$("${jq_bin}" '.caught // 0' "${f}")
    missed=$("${jq_bin}" '.missed // 0' "${f}")
    timeout=$("${jq_bin}" '.timeout // 0' "${f}")
    unviable=$("${jq_bin}" '.unviable // 0' "${f}")
    total_mutants=$("${jq_bin}" '.total_mutants // 0' "${f}")

    [[ "${caught}"        =~ ^[0-9]+$ ]] || caught=0
    [[ "${missed}"        =~ ^[0-9]+$ ]] || missed=0
    [[ "${timeout}"       =~ ^[0-9]+$ ]] || timeout=0
    [[ "${unviable}"      =~ ^[0-9]+$ ]] || unviable=0
    [[ "${total_mutants}" =~ ^[0-9]+$ ]] || total_mutants=0

    _outcomes_len=$("${jq_bin}" '(.outcomes // []) | length' "${f}" 2>/dev/null || echo 0)
    [[ "${_outcomes_len}" =~ ^[0-9]+$ ]] || _outcomes_len=0
    _sum_check=$((caught + missed + timeout + unviable))
    if [ "${_sum_check}" -eq 0 ] && { [ "${_outcomes_len}" -gt 0 ] || [ "${total_mutants}" -ne 0 ]; }; then
      echo "FAIL: shard ${i}'s outcomes.json schema drift detected (non-empty outcomes/total_mutants but all summary keys sum to 0). Pin: cargo-mutants@27.1.0"
      return 1
    fi
    if [ "${total_mutants}" -ne 0 ] && [ "${_sum_check}" -ne "${total_mutants}" ]; then
      echo "::warning::Schema mismatch on shard ${i}: total_mutants=${total_mutants} but sum of known categories=${_sum_check}."
    fi

    caught_total=$((caught_total + caught))
    missed_total=$((missed_total + missed))
    timeout_total=$((timeout_total + timeout))
    unviable_total=$((unviable_total + unviable))
  done

  total_scored=$((caught_total + missed_total + timeout_total + unviable_total))
  echo "Pooled summary: ${caught_total} caught / ${missed_total} missed / ${timeout_total} timeout / ${unviable_total} unviable (across ${EXPECTED_SHARDS} shards)"

  # --- Step 4: INV-AGG sub-invariant 8 — pooled-total <-> pre-count
  #     reconciliation.
  #
  #     ROUND-5 ADVERSARIAL FIX (MEDIUM false-green, architecture-delta.md
  #     §6.10 / mutants-sharding-invariants.md §INV-AGG sub-invariant 8's
  #     round-5 callout) — REVERSES round-4's downgrade of this step.
  #     Round-4 had made a mismatch NON-BLOCKING (`::warning::`, fall
  #     through to Step 5/6) because the `--list` <-> pooled `--shard
  #     --sharding slice` lossless-partition premise this comparison
  #     depends on was still empirically unverified. Round-5 restores the
  #     unconditional `return 1` on ANY mismatch — for a fail-closed
  #     security gate, silently letting a dropped-mutant class through
  #     because a survivor might be among the missing set is a WORSE
  #     failure mode than a false-RED pending investigation. The
  #     empirical-premise risk round-4 raised is real and is handled by a
  #     mandatory, BLOCKING F4 task instead (ROUND-6 STRENGTHENING, M-1 —
  #     see mutants-sharding-invariants.md's round-6 addendum and
  #     architecture-delta.md §1/§6.10): a scratch-run verification of the
  #     `--list` <-> pooled-`--shard --sharding slice` reconciliation,
  #     performed DURING F4, BEFORE cycle-006's own PR merges — cycle-006's
  #     own PR is CI/doc-only and cannot exercise a nonzero MUTANT_COUNT,
  #     so this cannot be deferred to production discovery. PR #778 (the
  #     next substantial real PR) remains the first REAL,
  #     production-scale exercise of this hard fail and a CONFIRMING data
  #     point, but is no longer the sole point this premise gets checked.
  #     The comparison
  #     is EXACT EQUALITY, both directions (`total_scored != MUTANT_
  #     COUNT`, not a directional `total_scored >= MUTANT_COUNT`) — see
  #     that same callout for why an over-count is also treated as
  #     dangerous, not merely anomalous. The MALFORMED-INPUT guard
  #     immediately below (a non-numeric MUTANT_COUNT) was already a hard
  #     `return 1` under round-4 and is unchanged by round-5 — it is a
  #     distinct failure class (a wiring/tooling defect upstream, not a
  #     partition-premise question). ---
  [[ "${MUTANT_COUNT}" =~ ^[0-9]+$ ]] || { echo "FAIL: MUTANT_COUNT ('${MUTANT_COUNT}') from mutants-plan is not a valid non-negative integer — cannot reconcile."; return 1; }
  if [ "${total_scored}" -ne "${MUTANT_COUNT}" ]; then
    echo "FAIL: Pooled scored-mutant count (${total_scored}) does not reconcile with mutants-plan's pre-count (MUTANT_COUNT=${MUTANT_COUNT})."
    echo "      This means the mutant set actually examined by the shard matrix differs from the set mutants-plan counted as in-diff-scope — either mutants went missing between planning and shard execution (a dropped, possibly-surviving mutant would silently pass otherwise), or the shard matrix examined more than was planned. Failing closed rather than trusting a partial or over-scoped pooled total. See mutants-sharding-invariants.md §INV-AGG sub-invariant 8's round-5 callout if this fires on a legitimate PR — root-cause before assuming this check is wrong."
    return 1
  fi

  # --- Step 5: base-ref-drift guard (F-3, moved here per Path B
  #     item 5). `total_scored` (the shards' OWN pooled total, folded
  #     in Step 3 from their own outcomes.json data — NOT MUTANT_COUNT)
  #     is the discriminator for "legitimately nothing to gate on" —
  #     OVERALL_DIFF_LINES is consulted only to explain WHY it is zero,
  #     never as the primary completeness signal (that was the pre-fix
  #     design's mistake — see the removed branch note above).
  #
  #     ROUND-5 CORRECTION (F1.4, architecture-delta.md §6.10): with
  #     Step 4's hard fail restored, this branch is reachable ONLY when
  #     `total_scored == MUTANT_COUNT == 0` — Step 4 already returned 1
  #     above for ANY mismatch, including a `MUTANT_COUNT > 0` that
  #     reconciled down to a `total_scored` of 0 through a dropped-mutant
  #     defect. So by the time this line runs, `total_scored == 0`
  #     necessarily means `MUTANT_COUNT` was ALSO exactly 0 and the two
  #     already reconciled cleanly at Step 4 — this is no longer merely
  #     "reconciled if MUTANT_COUNT happens to also be 0," it is the ONLY
  #     way to reach this line with total_scored == 0. The success message
  #     below is corrected to state this as fact, not a parenthetical.
  #     (Round-4's inline comment here — since removed — no longer applied
  #     once Step 4 became non-blocking, and this round-5 revert restores
  #     the pre-round-4 relationship exactly, now stated precisely rather
  #     than assumed.)
  #
  #     ROUND-2 ADVERSARIAL FIX (LOW, architecture-delta.md §6.6
  #     LOWs): OVERALL_DIFF_LINES's ONLY prior guard was the
  #     `${OVERALL_DIFF_LINES:-0}` fallback below, which handles
  #     an UNSET/empty value correctly but NOT a malformed-but-SET
  #     one (bash `:-` substitution fires only on unset-or-empty).
  #     A non-numeric OVERALL_DIFF_LINES (reachable only via a
  #     GitHub Actions output-plumbing bug — a mistyped env: key,
  #     the same class MED-2-round-1's escalated-output pin
  #     already guards for `escalated` specifically) would make
  #     `[ "${OVERALL_DIFF_LINES:-0}" -eq 0 ]` itself error ("bash:
  #     [: <value>: integer expression expected", exit status 2),
  #     which `if` treats as FALSE — silently routing to the "OK:
  #     non-empty diff" branch below instead of the intended
  #     base-ref-drift FAIL branch. Mirrors MUTANT_COUNT's existing
  #     Step 4 regex guard for symmetry and genuine (not assumed)
  #     fail-closed behavior. ---
  [[ "${OVERALL_DIFF_LINES:-0}" =~ ^[0-9]+$ ]] || { echo "FAIL: OVERALL_DIFF_LINES ('${OVERALL_DIFF_LINES:-}') from mutants-plan is not a valid non-negative integer — cannot evaluate the base-ref-drift guard."; return 1; }
  if [ "${total_scored}" -eq 0 ]; then
    if [ "${OVERALL_DIFF_LINES:-0}" -eq 0 ]; then
      echo "FAIL: 0 mutants scored (MUTANT_COUNT=0, already reconciled at Step 4) AND overall diff is EMPTY."
      echo "      Possible base-ref drift — same F-3 signature as the"
      echo "      pre-sharding single-job design."
      return 1
    fi
    echo "OK: 0 mutants scored — MUTANT_COUNT=0 (reconciled at Step 4; this is the only way to reach 0 scored mutants under the restored hard fail) — non-empty diff produced no mutable lines in examine_globs files (comment-only, whitespace, docs-only, or non-scoped-file PR)."
    return 0
  fi

  # --- Step 6: kill-rate computation (INV-AGG).
  #     STRUCTURAL INDEPENDENCE (unaffected by round-4's Step 4 change or
  #     round-5's reversal of it, architecture-delta.md §6.10): this step
  #     reads only caught_total/missed_total/timeout_total/unviable_total,
  #     folded in Step 3 from the shards' own outcomes.json — it has
  #     NEVER read MUTANT_COUNT, in any round. What round-5 changes is
  #     REACHABILITY, not this step's own logic: under the restored hard
  #     fail, Step 6 is UNREACHABLE whenever Step 4 finds a mismatch (it
  #     already `return`ed 1 above) — an incomplete or unreconciled mutant
  #     set is never allowed to reach the kill-rate decision at all. There
  #     is no MUTANT_COUNT-shaped variable in scope here to reach for even
  #     when this step does run. ---
  killable=$((caught_total + missed_total + timeout_total))
  if [ "${killable}" -eq 0 ]; then
    echo "OK: ${total_scored} mutant(s) generated, all unviable."
    return 0
  fi

  kill_rate=$(( (caught_total * 100) / killable ))
  echo "Pooled kill rate: ${kill_rate}% (target >= 90%)"

  if [ "${kill_rate}" -lt 90 ]; then
    echo "FAIL: pooled kill rate ${kill_rate}% is below the 90% target."
    return 1
  fi

  echo "OK: sharded cargo-mutants gate passed (pooled kill rate ${kill_rate}% >= 90%)."
  return 0
}

# main <args...> — real invocation runs the evaluator once and exits with
# its return code; `--self-test` instead runs the bash fixture harness
# (architecture-delta.md §6.2a) and never touches real runner.temp paths.
main() {
  if [ "${1:-}" = "--self-test" ]; then
    run_mutants_aggregate_self_test  # defined alongside EXPECTED_MUTANTS_AGG_FIXTURES,
                                      # architecture-delta.md §6.2a — F4 implements
                                      # the fixture bodies there, mirroring
                                      # check-ci-gate.sh's check_fixture harness.
    exit $?
  fi
  evaluate_mutants_aggregate
  exit $?
}

main "$@"
```

**`ci-gate.needs` retarget:**

```yaml
  ci-gate:
    ...
    needs: [fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants-aggregate]
```

(`mutants` → `mutants-aggregate`; everything else in `ci-gate`'s own block is
byte-identical — no other change.)

---

## 3a. `scripts/lib/trusted-jq.sh` (NEW file — round-7, runtime-hardening
parity, architecture-delta.md §6.11)

**Why this file exists.** `scripts/check-ci-gate.sh::resolve_trusted_jq`
(plus its two helpers, `trusted_jq_dirs_for` and `is_trusted_jq_dir`) is the
PATH-shim-resistant jq resolver that defeats a `$GITHUB_PATH`-prepended jq
shim forging every decision this repo's `ci-gate` job makes (S-626-1
pass-59, ADV-P59-LOW-001). `scripts/mutants-aggregate.sh` (§3 above) is now
a SECOND, equally load-bearing, PR-editable decision-path script that
resolves and invokes jq on every run — round-4 (architecture-delta.md §6.8)
already made it a documented structural peer of `ci-gate` for RUST-side
pins; round-7 closes the SAME peer relationship one layer down, at the
SCRIPT'S OWN runtime. **Anti-drift choice: ONE shared, sourced file, not
two independently-maintained copies.** A second hand-copied
`resolve_trusted_jq` inside `mutants-aggregate.sh` would immediately
reproduce this repo's own `strict: false` / "tested tree != merged tree"
drift class (CLAUDE.md) one level down: a future fix to the resolver (e.g.
a new `RUNNER_OS` value, a new trusted directory) could land in one
script's copy and be forgotten in the other, with nothing to catch the
divergence except a human noticing on review. Extracting to a shared
library file that BOTH scripts `source` makes that drift structurally
impossible — there is only one copy to fix.

**Contents — extracted VERBATIM (behavior-preserving) from
`scripts/check-ci-gate.sh`'s existing `trusted_jq_dirs_for`/
`is_trusted_jq_dir`/`resolve_trusted_jq`.** This is a refactor of
EXISTING, already-shipped, already-hardened logic (S-626-1 passes 59-61) —
F4 moves these three functions out of `check-ci-gate.sh` into this new
file, and `check-ci-gate.sh` gains a `source` line in their place (see the
"`check-ci-gate.sh`'s own required companion change" note below). No
behavior change to the resolver itself; only its physical location moves.
`check-ci-gate.sh`'s own extensive doc comments on these three functions
(the RUNNER_OS-vs-GITHUB_ACTIONS research trail, the pure-bash-dirname
anti-shim fix, the HONEST SCOPE / sudo-bound residual) travel WITH the
functions into this file — they are not re-narrated a second time in
`ci-yml-design.md`; F4 copies them verbatim as part of the move.

```bash
#!/usr/bin/env bash
# scripts/lib/trusted-jq.sh — shared, PATH-shim-resistant jq resolver
# (architecture-delta.md §6.11, round-7 extraction). Sourced by BOTH
# scripts/check-ci-gate.sh and scripts/mutants-aggregate.sh so a future
# fix to this logic cannot land in one decision-path script and be
# forgotten in the other.
#
# NOT executable on its own — declares functions only, no `main`/dispatch.
# Meant to be `source`d, never invoked directly. Does NOT call
# `set -euo pipefail` itself: both current callers already set their own
# strict mode before sourcing this file, and a library file silently
# changing a caller's shell options on `source` would be a surprising,
# hard-to-audit side effect — the caller owns its own strict-mode posture.
#
# Extracted verbatim from scripts/check-ci-gate.sh's own
# trusted_jq_dirs_for / is_trusted_jq_dir / resolve_trusted_jq
# (S-626-1 passes 59-61). See check-ci-gate.sh's git history / this
# extraction's own commit for the full multi-pass research trail this
# header does not re-narrate (WHY RUNNER_OS not GITHUB_ACTIONS, the
# pure-bash-dirname fix that closes a second PATH-shim vector on `dirname`
# itself, and the HONEST SCOPE paragraph on what this resolver can and
# cannot close — most importantly, GitHub-hosted runners' passwordless
# sudo means an attacker with EARLIER-STEP arbitrary execution in the SAME
# job does not need a PATH shim at all (`sudo cp /tmp/shim /usr/bin/jq`
# replaces the trusted binary in place) — this resolver closes the
# cheaper PATH-shim vector and is worth keeping, but "an attacker cannot
# forge the decision" is never an accurate description of what it
# achieves on its own; see architecture-delta.md §6.11's own restatement
# of this residual for the `mutants-aggregate` job specifically.

trusted_jq_dirs_for() {
    case "$1" in
        Linux)
            printf '%s\n' "/usr/bin" "/bin"
            ;;
        macOS)
            printf '%s\n' "/usr/bin" "/bin" "/usr/local/bin" "/opt/homebrew/bin"
            ;;
        *)
            ;;
    esac
}

is_trusted_jq_dir() {
    local os="$1" dir="$2" candidate
    while IFS= read -r candidate; do
        [ -z "${candidate}" ] && continue
        [ "${dir}" = "${candidate}" ] && return 0
    done <<EOF
$(trusted_jq_dirs_for "${os}")
EOF
    return 1
}

resolve_trusted_jq() {
    local resolved
    if ! resolved=$(command -v jq 2>/dev/null); then
        echo "ERROR: jq is required but was not found on PATH." >&2
        return 2
    fi

    case "${resolved}" in
        /*) ;;
        *)
            echo "ERROR: jq resolved to a non-absolute path '${resolved}'." >&2
            echo "       Refusing to trust a jq found via a relative PATH" >&2
            echo "       entry (e.g. '.')." >&2
            return 2
            ;;
    esac
    if [ ! -x "${resolved}" ]; then
        echo "ERROR: jq resolved to '${resolved}', which is not an" >&2
        echo "       executable file." >&2
        return 2
    fi

    local os="${RUNNER_OS:-}"
    if [ -n "${os}" ]; then
        local dir
        # Pure-bash dirname (no external `dirname` call left on the
        # decision path to shim — see the module header above).
        if [ "${resolved}" = "${resolved#*/}" ]; then
            dir=""
        else
            dir="${resolved%/*}"
            [ -z "${dir}" ] && dir="/"
        fi
        if ! is_trusted_jq_dir "${os}" "${dir}"; then
            echo "ERROR: jq resolved to '${resolved}' (directory" >&2
            echo "       '${dir}') under RUNNER_OS='${os}', which is not" >&2
            echo "       one of the trusted system jq directories for" >&2
            echo "       that runner. Refusing to trust a jq binary found" >&2
            echo "       elsewhere on PATH inside a GitHub Actions job" >&2
            echo "       (possible PATH-prepend shim attack via" >&2
            echo "       \$GITHUB_PATH — see this file's module header)." >&2
            echo "       Trusted directories for RUNNER_OS='${os}':" >&2
            local trusted_line
            while IFS= read -r trusted_line; do
                [ -z "${trusted_line}" ] && continue
                echo "         ${trusted_line}" >&2
            done <<EOF
$(trusted_jq_dirs_for "${os}")
EOF
            return 2
        fi
    fi
    printf '%s\n' "${resolved}"
}
```

**`check-ci-gate.sh`'s own required companion change (F4, same commit).**
`check-ci-gate.sh` deletes its own copies of `trusted_jq_dirs_for`/
`is_trusted_jq_dir`/`resolve_trusted_jq` and adds the identical
pure-bash-dirname `source` preamble §3's script now uses (adjusted for
`check-ci-gate.sh`'s own location — both files live directly in
`scripts/`, so both resolve `lib/trusted-jq.sh` relative to their own
`${BASH_SOURCE[0]}` the same way). **Zero behavior change to
`check-ci-gate.sh`'s existing self-test coverage:** `run_jq_trust_self_test`
(the existing 17-check suite, `EXPECTED_JQ_TRUST_CHECKS=17`) calls
`resolve_trusted_jq`/`is_trusted_jq_dir` exactly as it does today — sourced
functions are indistinguishable from locally-defined ones to the rest of
the sourcing script's shell, so every one of those 17 checks continues to
exercise the identical code, now physically relocated. `EXPECTED_
JQ_TRUST_CHECKS` is UNCHANGED at `17`.

**Not duplicated into `mutants-aggregate.sh`'s own `--self-test`: a second
17-check jq-trust suite.** Considered and declined — the shared library is
the SAME code as `check-ci-gate.sh` already exhaustively proves; a second,
byte-identical 17-check suite inside `mutants-aggregate.sh --self-test`
would inflate `EXPECTED_MUTANTS_AGG_FIXTURES` with zero incremental
coverage (the exact "redundant defense-in-depth is declined" reasoning
architecture-delta.md §6.8 already applies to M2-g/h). What DOES need a
new, dedicated guard — because it is NOT redundant with anything that
already exists — is a STRUCTURAL proof that both scripts actually SOURCE
the shared file and contain no bare, un-resolved `jq` invocation on their
own decision paths (a script could source the file and then still, by
carelessness, call a bare `jq` somewhere that bypasses `${jq_bin}`
entirely — sourcing the resolver proves nothing about whether every call
site actually USES it). See architecture-delta.md §6.11 for that new
guard test's exact shape and the `EXPECTED_GUARD_TEST_COUNT` bump it
drives.

---

## 4. Scheduled full-run workflow — `mutants-nightly.yml` (NEW file)

Recommendation: **separate workflow file**, not a new `schedule:`-triggered
job inside `ci.yml` — see `architecture-delta.md §Scheduled Full Run:
Separate File vs New ci.yml Job` for the full rationale. Modeled on
`.github/workflows/e2e.yml`'s existing schedule + `workflow_dispatch`
pattern in this repo.

```yaml
name: Mutants Nightly (Full Scope)

on:
  schedule:
    - cron: "0 8 * * *"  # 08:00 UTC nightly — offset from e2e.yml's 06:00
                          # cron to avoid runner-queue contention between
                          # the two scheduled jobs.
  workflow_dispatch: {}   # manual trigger for on-demand full runs

jobs:
  mutants-full:
    name: Mutation Testing (Full, Advisory)
    runs-on: ubuntu-latest
    # No pull_request trigger at all in `on:` above; this belt-and-suspenders
    # if: mirrors e2e.yml's own convention (never run this against a PR
    # even if `on:` is later edited).
    if: github.event_name != 'pull_request'
    timeout-minutes: 240  # full, non-diff-scoped scope; advisory, not
                           # required, so a long/occasionally-timing-out run
                           # here is acceptable (does not block any merge).
    strategy:
      fail-fast: false
      matrix:
        shard: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]  # N=16
        # heavier sharding than the per-PR N=8 — full examine_globs scope
        # is materially larger than a typical --in-diff PR slice.
    steps:
      - name: Harden the runner (Audit all outbound calls)
        uses: step-security/harden-runner@<CURRENT_SHA>  # copy exact pin
        with:
          egress-policy: audit
      - uses: actions/checkout@<CURRENT_SHA>  # copy exact pin
      - uses: taiki-e/install-action@<CURRENT_SHA>  # copy exact pin
        with:
          tool: cargo-mutants@27.1.0
      - uses: Swatinem/rust-cache@<CURRENT_SHA>  # copy exact pin
      - name: Run full mutation scope on this shard
        continue-on-error: true
        run: |
          # NO --in-diff — full examine_globs scope, per docs/specs/
          # cargo-mutants-policy.md's own note that --in-diff is
          # "not a substitute for a full run" (weakened coverage of
          # UNCHANGED code is invisible to the per-PR diff-scoped gate).
          cargo mutants --shard ${{ matrix.shard }}/16 --sharding slice \
            --jobs 2 --baseline skip --timeout 240
      - name: Upload shard outcomes
        if: always()
        uses: actions/upload-artifact@<CURRENT_SHA>  # pin per repo convention
        with:
          name: mutants-nightly-shard-outcomes-${{ matrix.shard }}
          path: mutants.out/outcomes.json
          if-no-files-found: warn
          retention-days: 7  # longer retention than the per-PR shards —
                              # useful for trend analysis across nightly runs.

  mutants-nightly-report:
    name: Mutation Testing (Full, Report)
    runs-on: ubuntu-latest
    needs: [mutants-full]
    if: always()
    timeout-minutes: 15
    steps:
      - uses: actions/download-artifact@<CURRENT_SHA>  # pin per repo convention
        with:
          pattern: mutants-nightly-shard-outcomes-*
          path: ${{ runner.temp }}/shards
      - name: Summarize pooled kill rate (advisory — never fails the workflow)
        run: |
          # Same INV-AGG summation logic as mutants-aggregate's "Evaluate
          # sharded mutation gate" step, MINUS the exit-1 branches — this
          # job is advisory. It prints the pooled kill rate and any
          # coverage regression vs. the last known baseline to the job
          # summary/log for a human to review; it deliberately never
          # exits non-zero, since this workflow is not wired into
          # ci-gate.needs and must never block a merge.
          # (F4 implements the same jq/bash summation shape as
          # mutants-aggregate, with an explicit `exit 0` at the end
          # regardless of the computed kill rate — advisory only.)
          echo "See mutants-aggregate's per-shard-guard logic in ci.yml for the summation algorithm this step mirrors, minus the fail-closed exits."
```

**Design notes:**
- This workflow declares NO job named `ci-gate` (satisfies the existing
  `test_no_sibling_workflow_declares_a_job_named_ci_gate` guard trivially)
  and is entirely outside `ci.yml`, so it needs **zero** changes to
  `PINNED_GATE_EXCLUDED_JOBS`, `ci-gate.needs`, or any other
  `tests/ci_gate_completeness.rs` pin — those all scope to `ci.yml`
  specifically (confirmed via `read_ci_yml()`/`list_all_ci_yml_job_names`
  reading `.github/workflows/ci.yml` by name, not every workflow file).
- N=16 (not 8) for the full scope, per the research brief's own guidance
  that a wider `examine_globs` surface than a typical `--in-diff` PR slice
  warrants more shards; this value is independent of the per-PR N=8 and has
  no guardrail-pin implications since this workflow is entirely outside
  `ci-gate`'s enforcement surface.
- `mutants-nightly-report`'s summation step is explicitly advisory-only
  (never exits non-zero) — F4 must not accidentally copy
  `mutants-aggregate`'s fail-closed `exit 1` branches into this job; doing
  so would not break correctness (this workflow isn't required) but would
  defeat the "advisory, never blocks" design intent and could produce
  confusing red X's on `develop`'s commit history unrelated to any actual
  merge gate.

---

## 5. `spec-guard` job — new self-test step (round-3, extraction wiring)

`.github/workflows/ci.yml`'s pre-existing `spec-guard` job already runs
`scripts/check-ci-gate.sh --self-test` as its final step (`run: bash
scripts/check-ci-gate.sh --self-test`, immediately after "check-bc-
citation-symbols"). This section adds a new, immediately-following sibling
step for the new `scripts/mutants-aggregate.sh --self-test` harness
(§3, "`scripts/mutants-aggregate.sh`" content above), completing the
extraction described there — without this wiring, the new script's
`EXPECTED_MUTANTS_AGG_FIXTURES` self-test suite is defined but never
actually run by CI, which `architecture-delta.md §6.2a` flags as
insufficient on its own (a self-test nothing invokes is not a guard).

```yaml
  spec-guard:
    name: Spec Guards (BC counts, numeric-count lint, citation checks, mutants policy scope)
    runs-on: ubuntu-latest
    timeout-minutes: 5
    steps:
      # ... every existing step, byte-identical, through ...
      - name: check-ci-gate self-test (fixture suite, S-CIGATE-2)
        run: bash scripts/check-ci-gate.sh --self-test

      # NEW (round-3, cycle-006):
      - name: check-mutants-aggregate self-test (fixture suite, cycle-006)
        run: bash scripts/mutants-aggregate.sh --self-test
```

**Design notes:**
- Placed LAST, immediately after the existing check-ci-gate self-test step
  — no other step in `spec-guard` is reordered, added, or removed. This
  keeps the diff to `ci.yml` minimal and mirrors the existing convention
  of pairing each script's self-test step directly with (immediately
  before or after) that script's own real-invocation step where one
  exists; `mutants-aggregate.sh` has no separate "real invocation" step in
  `spec-guard` (its real invocation is the `mutants-aggregate` job itself,
  a different job entirely), so it is appended at the end of the existing
  self-test cluster instead.
- `timeout-minutes: 5` on `spec-guard` is UNCHANGED — the new self-test
  step runs jq/bash arithmetic over small, synthetic, locally-generated
  fixture files (no network, no real `cargo mutants` invocation), so it
  adds negligible wall-clock cost, consistent with every other self-test
  step already in this job.
- `PINNED_ALWAYS_RUN_STEP_KEY_SETS`'s `spec-guard` entry
  (`tests/ci_gate_completeness.rs`, `architecture-delta.md §6.2` this
  round) gains a 13th `&["name", "run"]` tuple for this new step, in the
  SAME commit as this YAML addition — `test_always_run_jobs_have_pinned_
  complete_step_key_sets` (the pre-existing generic loop-based test this
  constant already drives) fails loudly, naming `spec-guard` and the
  mismatched step count, if the two are not updated together.
- The new Rust structural pin `test_spec_guard_contains_mutants_
  aggregate_self_test_step` (item 13, `architecture-delta.md §6.2`)
  confirms both that this step exists AND that its own `run:` line is
  byte-pinned — mirroring the PRE-EXISTING `test_spec_guard_contains_
  check_ci_gate_self_test_step`'s (AC-008) exact technique, retargeted at
  the new sibling script.
