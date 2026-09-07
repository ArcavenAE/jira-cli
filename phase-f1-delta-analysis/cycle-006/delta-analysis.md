---
document_type: delta-analysis-report
feature_name: "mutants-ci-sharding"
created: 2026-09-07
spec_version_at_analysis: "BC-INDEX total_bcs=754"
status: draft
intent: enhancement
feature_type: infrastructure
scope: standard
severity: N/A
analyst: architect (vsdd-factory)
cycle: cycle-006
origin: "PR #778 (cycle-005 Story A, S-cycle5-mention-pure-conversion) — 281 in-diff mutants
  exceeded the `mutants` job's 240-minute timeout at observed single-runner throughput
  (~17.5 mutants/hr with --jobs 4), job cancelled, merge blocked. Grounding research:
  .factory/research/mutation-testing-ci-large-changes-2026-09-07.md."
---

# Delta Analysis Report: mutants-ci-sharding

## Feature Request

- **Brief:** Replace the single required `mutants` CI job (currently `timeout-minutes: 240`,
  `cargo mutants --in-diff <diff> --jobs 4 --timeout 240`, sole pass/fail arbiter via a
  90%-kill-rate `Check kill rate` step) with a **sharded matrix + aggregator** design:
  1. A `fail-fast: false` GitHub Actions matrix of N shards (`cargo-mutants --shard k/N
     --sharding slice --jobs 2 --baseline skip --timeout 240`), each uploading its
     `mutants.out/outcomes.json` as a per-shard artifact.
  2. A new `mutants-aggregate` job that downloads every shard artifact, asserts all N are
     present, **sums** `caught`/`missed`/`timeout`/`unviable` across shards, computes ONE
     kill rate, enforces ≥90%, and **replaces `mutants` as the `ci-gate.needs` member**.
  3. A large-change escape hatch: pre-count via `cargo mutants --list --in-diff | wc -l`;
     over a threshold routes to a neutral "escalated" status (nightly/full run + human
     ack), not a red block.
  4. An advisory, non-`--in-diff`, scheduled full run on `develop`.
- **Requested by:** Human (session directive), triggered by PR #778's mutation-gate timeout.
- **Date:** 2026-09-07.
- **Grounding input:** `.factory/research/mutation-testing-ci-large-changes-2026-09-07.md`
  (CONFIRMED: `--shard k/n` combines with `--in-diff` and `--baseline skip`; no built-in
  shard-merge — CI must sum, never average; `--jobs 2` beats high `--jobs` on hosted
  runners; timeouts count as survived in v27; pin `cargo-mutants@27.1.0` exactly, not `@27`,
  since the gate parses `outcomes.json`; `--baseline=auto` does not exist).
- **Prior art in this repo:** `docs/specs/cargo-mutants-policy.md §Future Path: Job
  Sharding (Path B)` already sketched this exact design on 2026-06-28 and explicitly
  deferred it "until Path A's 240-minute budget proves insufficient in practice." PR #778
  is the proof point. This cycle formalizes Path B.

## Classifications

### Intent Classification

**Classified intent:** `enhancement`
**Rationale:** The mutation-gate CORRECTNESS INVARIANT (≥90% kill rate on the PR diff,
required, fail-closed) is unchanged. This is an enhancement to the job's *scaling
mechanism* (single-runner → sharded matrix + aggregator), not new gate behavior. No
"broken" behavior is being fixed — the 240-minute timeout is documented, deliberate
(Path A), and worked correctly for every PR until a 281-mutant diff exceeded its
designed envelope. `bug-fix` was considered and rejected: there is no defect in the
existing gate logic; it is a scale limit the policy doc already flagged as foreseeable.

### Feature Type Classification

**Classified type:** `infrastructure`
**Rationale:** Every touched file is CI/CD config, a policy doc, or a CI-testing-owned
test/script (`ci.yml`, `.cargo/mutants.toml`, `docs/specs/cargo-mutants-policy.md`,
`scripts/check-ci-gate.sh`, `tests/ci_gate_completeness.rs`, `tests/common/wf.rs`, a new
scheduled-workflow YAML). No `src/` product code changes.

### Trivial Scope Classification

- [ ] Impact boundary: single module, single file, or documentation only — **FALSE**, spans
  ≥7 files across 3 layers (CI YAML, policy doc, CI-gate test harness).
- [ ] No new BCs needed — **UNRESOLVED, see §Affected BCs** (leaning: no new PRD BC, but a
  NEW policy-doc-level contract + possibly a NEW guard-test obligation is warranted).
- [ ] No architecture change — **FALSE-ish**: no product architecture change, but the CI
  *topology* changes (one job → matrix + aggregator job), and every structural pin in
  `tests/ci_gate_completeness.rs` naming `mutants` (7+ named literals/consts) must move
  in lockstep or the gate silently stops enforcing anything.
- [ ] No new external dependencies — **mostly true**; no new crates, but the `cargo-mutants`
  install-action pin should tighten from `@27` to `@27.1.0` per the research brief's
  UNVERIFIED flag (schema stability), which is itself a small scope addition.
- [ ] Regression risk: LOW — **FALSE for the CI-gate machinery**, see §Regression Risk.

**Classified scope:** `standard`
**Rationale:** Multiple ALL-of conditions fail. This is exactly the class of change the
S-CIGATE story-line exists to guard against with maximum rigor (a false-GREEN mutation
gate is the specific hazard class that motivated `tests/ci_gate_completeness.rs`'s entire
existence). Quick-dev routing is explicitly disqualified — CLAUDE.md's own CI-gate section
documents 16+ adversarial review rounds finding real bypasses in exactly this kind of
"small, mechanical-looking" CI-YAML change. Standard F1-F7 Feature Mode applies.

### Severity Classification

**Classified severity:** N/A (not a bug-fix intent).

### DTU (Digital Twin Universe) Requirement

**dtu_required: NO.** No third-party service is being cloned or emulated. All external
touchpoints (GitHub Actions runners, `actions/upload-artifact`/`download-artifact`,
`cargo-mutants` itself) are either GitHub-native platform primitives already used
elsewhere in `ci.yml` (no new integration surface) or a CLI tool invoked identically to
today (only its flags change: `--shard`, `--baseline skip`, `--list`). No API contract
with an external service is introduced.

### Multi-Repo Assessment

**multi-repo: NO.** Single-crate `jr` repo; this change is entirely internal to
`.github/workflows/` + `.cargo/` + `docs/specs/` + `tests/` in this one repository. No
service-boundary or cross-repo contract is touched.

## Impact Assessment

| Component | Classification | Details |
|---|---|---|
| `.github/workflows/ci.yml` — `mutants` job (lines ~378-642) | **MODIFIED → REPLACED** | Single job becomes a `strategy: {fail-fast: false, matrix: {shard: [0..N-1]}}` job (`--shard k/N --sharding slice --jobs 2 --baseline skip --timeout 240`), each shard `if: github.event_name == 'pull_request'`, uploading `mutants-shard-${{ matrix.shard }}` artifacts `if: always()`. `--in-diff` diff-computation logic (the `git diff origin/<base_ref>...HEAD` step, the F-4 `\|\| true` empty-diff handling, `OVERALL_DIFF_LINES` export) must be computed ONCE and threaded to every shard identically (research brief invariant: "same diff or results are meaningless") — likely a small upstream `mutants-diff` job whose diff-file artifact every shard downloads, rather than N independent `git diff` invocations (which risk base-ref drift between shards on a long-running matrix). |
| NEW `mutants-aggregate` job | **NEW** | `needs: [<shard matrix job>]`, `if: always()`. Downloads all shard artifacts, asserts exactly N present (fail-closed on any missing), sums `caught`/`missed`/`timeout`/`unviable` across shards' `outcomes.json` (reusing the existing malformed-JSON guard, integer-validation guard, H-1 schema-drift guard, M-2 reconciliation warning — per-file, before summing), computes one `kill_rate = caught*100/(caught+missed+timeout)`, enforces ≥90%. Owns the F-3 base-ref-drift / empty-diff / zero-mutant logic (moves from per-shard to here per policy doc §Future Path Path B item 5). |
| `ci-gate.needs` (ci.yml line ~678) | **MODIFIED** | `mutants` → `mutants-aggregate` in the `needs:` array. Per DEC-096/097 (CLAUDE.md), this MUST NOT be wired directly into branch protection — only via `ci-gate.needs`, exactly as today. |
| `.cargo/mutants.toml` | **MODIFIED (small)** | No `examine_globs`/`exclude_re` changes expected. Two possible additions: (a) none required for sharding itself — `--shard`/`--baseline skip`/`--timeout` are CLI-only flags per the policy doc's own "Corrected Configuration" section (no toml key exists for the timeout ceiling); (b) if the escape-hatch pre-count step becomes a *third* CLI invocation (`cargo mutants --list --in-diff`), it reads the same config — no toml change needed there either. Net: likely **UNCHANGED**, included here only because F2 must positively confirm this, not assume it. |
| `docs/specs/cargo-mutants-policy.md` | **MODIFIED** | §Future Path: Job Sharding (Path B) is promoted from speculative "if a future cycle needs..." to the ACTUAL current design — needs a full rewrite/supersession, not an addendum: new §CI Gate: Required Check subsection describing the aggregator as the pass/fail arbiter, new §Escape Hatch section, new §Scheduled Full Run section, updated §CI Integration, updated §Local Invocation (shard-equivalent local repro command), §Changelog entry. The existing §Timeout Parameters `--timeout 240` derivation carries forward unchanged (per-mutant ceiling is orthogonal to sharding). |
| `scripts/check-ci-gate.sh` | **MODIFIED** | `ALLOWED_SKIPS=("mutants")` (line 182) → `ALLOWED_SKIPS=("mutants-aggregate")`. This is the SAME "job may legitimately report `skipped` on a push event" carve-out, just retargeted — the shard matrix jobs are NOT `ci-gate.needs` members (only the aggregator is, per the policy doc's Path B item 3), so shard jobs need no `ALLOWED_SKIPS` entry. `EXPECTED_FIXTURES=13` may need a new fixture if the aggregator's skip-tolerance is exercised by a dedicated self-test case (verify in F2/F4, not assumed here). |
| `tests/ci_gate_completeness.rs` | **MODIFIED (extensive)** | Every structural pin naming `mutants` literally must retarget to `mutants-aggregate`, and the shard matrix job needs its OWN new pin set (it is a *new* always-run-conditionally job, not a `ci-gate.needs` member, so it needs different treatment than `PINNED_ALWAYS_RUN_JOB_KEY_SETS`/`PINNED_ALWAYS_RUN_STEP_KEY_SETS`, which are scoped to non-matrix `ci-gate.needs` members). Concretely, at minimum: `SKIP_TOLERANT_NEEDS_MEMBERS = &["mutants"]` (line 304) → `&["mutants-aggregate"]`; the AC-003 exact-8-job-set literal (line ~678, includes `"mutants"`) → 8-job set with `"mutants-aggregate"`; `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS` (line 4667) mutants-keyed entry → re-keyed to `mutants-aggregate` (and its pinned `if:` expression re-derived — the aggregate job's `if:` is `always()`-shaped, not the shard `if: github.event_name == 'pull_request'` the OLD `mutants` job had, since the aggregator itself must run even when all PR-only shards are skipped on a push event, to correctly report itself skipped too); the dedicated `MUTATION-CI-TIMEOUT — "mutants" is in ci-gate.needs` test (line ~978-1023) needs a sibling/replacement test for `mutants-aggregate`; `EXPECTED_GUARD_TEST_COUNT` (currently 38, line 8156) increments for every new/retargeted test. **This is the single highest-risk file in the whole delta** — see §Regression Risk. |
| `tests/common/wf.rs` | **DEPENDENT** | No direct `mutants` string literal found in this file today (grep returned zero hits), so likely **no changes needed** UNLESS a new parsing helper is required for the matrix `strategy:`/`matrix:` YAML shape (the current `WfDoc` model has not needed to parse a `strategy:` block for any existing job — the shard job would be the first). F2 must confirm whether `find_key_node_properties`/`extract_job_block`/`Job::value_of` already handle a job with `strategy: {matrix: {...}}` correctly, or whether a new accessor is needed. `EXPECTED_WF_TEST_COUNT` (currently 26) increments only if new tests are added to `wf.rs`'s own `#[cfg(test)] mod tests`. |
| NEW scheduled-full-run workflow (`.github/workflows/mutants-nightly.yml` or a new `schedule:`-triggered job appended to `ci.yml`) | **NEW** | Advisory-only (never wired into `ci-gate.needs` — must land in `PINNED_GATE_EXCLUDED_JOBS`-equivalent reasoning, i.e. simply never added to the `needs:` array, mirroring how `security`/`coverage` are already excluded per `PINNED_GATE_EXCLUDED_JOBS = &["security", "coverage"]`, line 843). Runs the FULL `examine_globs` scope without `--in-diff`, heavily sharded, non-blocking. If implemented as a *new job in ci.yml* rather than a separate workflow file, `tests/ci_gate_completeness.rs`'s S-626-1 U1 "ci-gate.needs must PARTITION every job in ci.yml" guard (line ~823+) requires this new job to be added to EITHER `ci-gate.needs` OR `PINNED_GATE_EXCLUDED_JOBS` — there is no third option; a job present in neither makes that guard FAIL by design. |
| Escape-hatch logic (pre-count + escalation routing) | **NEW** | Where it lives matters for the impact boundary: (a) as a step inside the existing diff-computation job (cheapest, reuses the already-computed `$DIFF_FILE`), gating whether the shard matrix and aggregator run in blocking mode vs. an "escalated" neutral-status mode; or (b) as a new job. Recommend (a) for F2 to minimize new `ci-gate.needs`-partition surface. The "neutral status, not a red block" requirement has no existing precedent in this repo's CI-gate vocabulary (today: `success`/`failure`/`cancelled`/`skipped` only, per `scripts/check-ci-gate.sh`'s fail-closed default-deny) — GitHub Actions has no native "neutral" job conclusion for a required check in the same sense a GitHub *App* check-run can report `neutral`; the closest native equivalent is `skipped` (already in `ALLOWED_SKIPS`-style carve-outs) or a job that exits 0 while writing a distinguishing artifact/summary that a human notices out-of-band. **This is an OPEN DESIGN QUESTION for F2**, not a solved mechanism — see §Open Questions. |

## Affected BCs

**No existing BC-S.SS.NNN governs the mutation gate today.** Confirmed via
`docs/specs/cargo-mutants-policy.md §Spec Anchor`: *"There is no dedicated BC... The
human explicitly chose not to author a BC for this cycle (F1 §8, Q3 resolution:
policy-doc-only)."* This precedent (MUTATION-CI-TIMEOUT cycle, 2026-06-28) directly
informs this cycle's F1 recommendation below.

- **BCs modified:** none (none exist).
- **BCs unchanged:** none applicable.
- **New BCs — recommendation:** F1 recommends **against** authoring a new PRD BC-S.SS.NNN
  for the same reason the prior cycle gave (CI-only behavior, policy-doc governance is
  sufficient, and BC-S.SS.NNN is a *product* behavioral-contract namespace). However, this
  cycle introduces TWO new invariants that the prior cycle's policy-doc-only governance did
  not have to cover, and F2 should decide whether these need a NEW named contract inside
  the policy doc (not a PRD BC) plus corresponding NEW guard tests:
  1. **Sharded-aggregation kill-rate contract** ("sum-not-average; every shard must report
     or the gate FAILS closed; timeouts count as survived") — this is a genuinely new
     correctness surface (the single-job design never had a cross-artifact reconciliation
     step) and deserves an explicit, named policy-doc contract analogous to how §Timeout
     Parameters and §Schema-Drift and False-Green Guards are written today, PLUS a positive
     regression test (mirroring `tests/ci_gate_completeness.rs`'s existing rigor) proving
     the aggregator does NOT pass when a shard artifact is missing, malformed, or when
     summed values disagree with a shard's own `total_mutants`.
  2. **Escape-hatch / neutral-status contract** — a wholly new behavior class (routing
     instead of pass/fail) with no existing analog anywhere in this repo's CI-gate
     vocabulary. This needs explicit specification (what "neutral" means operationally,
     how a human ack is recorded, what "nightly/full run" resolution looks like) before F4
     can implement it, and should get its own named policy-doc subsection + guard test(s).
- **VPs needing extension:** none in the PRD verification-properties sense (VP-NNN is
  scoped to product code per the L2/L3 domain spec; this delta touches none of the
  `examine_globs`-listed `src/` files). The RELEVANT verification surface is
  `tests/ci_gate_completeness.rs`'s own guard-test suite (governed by `EXPECTED_GUARD_TEST_COUNT`
  / `EXPECTED_WF_TEST_COUNT` tripwires, not VP-NNN) — F3/F4 must grow that suite, not author
  VP-NNN documents.

## Files Changed

### New Files

| File Path | Purpose |
|---|---|
| `.github/workflows/mutants-nightly.yml` (or equivalent new job in `ci.yml`) | Advisory, non-`--in-diff`, scheduled full mutation run on `develop`. Exact location (separate workflow file vs. new job) is an F2 decision. |

### Modified Files

| File Path | Change Type | Risk |
|---|---|---|
| `.github/workflows/ci.yml` | `mutants` job → sharded matrix + `mutants-aggregate` job; `ci-gate.needs` retarget; new escape-hatch step(s) | **HIGH** |
| `docs/specs/cargo-mutants-policy.md` | Policy rewrite of §Future Path (Path B promoted to actual), new §Escape Hatch, new §Scheduled Full Run, §Changelog entry | MEDIUM |
| `scripts/check-ci-gate.sh` | `ALLOWED_SKIPS` retarget `mutants`→`mutants-aggregate` | **HIGH** (small diff, high blast radius — this is the fail-closed gate's own allowlist) |
| `tests/ci_gate_completeness.rs` | Retarget every `mutants`-naming pin; add new pins for the matrix job + aggregator; increment `EXPECTED_GUARD_TEST_COUNT` | **HIGH** (largest single file, most structural pins) |
| `.cargo/mutants.toml` | Possibly unchanged; confirm in F2 whether any new CLI-only flag needs a config-level counterpart | LOW |
| `tests/common/wf.rs` | Possibly unchanged; confirm whether `WfDoc` needs a `strategy:`/`matrix:` accessor | LOW-MEDIUM |
| `CLAUDE.md` | Local-invocation `cargo mutants ... --in-diff <diff>` reference command and CI-Gate SCOPE SUMMARY narrative should mention the shard/aggregate topology if materially different from today's single-job description (currently CLAUDE.md's CI Gate section is extremely detailed about `mutants` being the skip-tolerant `ci-gate.needs` member — this will read as stale/wrong post-change) | MEDIUM |

### Dependent Files (unchanged but depend on modified files)

| File Path | Depends On | Regression Risk |
|---|---|---|
| `scripts/check-cargo-mutants-policy-citations.sh` (Guard 2, CI-MUTANTS-CITE-001) | `docs/specs/cargo-mutants-policy.md §Scope` bulleted (file, fn) citations | LOW — this delta does not touch §Scope's `examine_globs` bullet list, only adds new sections elsewhere in the doc; Guard 2 parses §Scope specifically. Confirm in F2 that the doc restructuring does not accidentally perturb §Scope's exact heading/format that the guard's parser depends on. |
| `tests/mutants_glob_existence.rs` (Guard 3) | `.cargo/mutants.toml examine_globs` | LOW — unaffected if `.cargo/mutants.toml` is unchanged (see above); re-verify once F2 confirms. |
| `tests/claude_md_citations.rs` (CI-CITE-001) | Any new file-path citations added to CLAUDE.md as part of this delta | LOW — routine; new citations must resolve to real files (e.g. a new `mutants-nightly.yml` path must exist before CLAUDE.md cites it). |

## Files NOT Changed (Regression Baseline)

**No `src/` files are expected to change in this cycle.** This is a CI-topology-only
delta; the product binary (`jr`) is byte-identical before and after. Therefore the
**existing `cargo test` full suite (all ~4,600+ tests across `src/` inline tests and
`tests/*.rs` integration/property/snapshot tests) IS the regression baseline** — every
one of those tests must continue to pass unchanged, because none of their subject code
moves. Specifically NOT changed:

- All of `src/` (every module listed in `.cargo/mutants.toml examine_globs` and every
  module NOT listed) — no product behavior changes.
- All other CI jobs in `ci.yml`: `fmt`, `clippy`, `test`, `msrv`, `deny`, `spec-guard`,
  `check-signing-workflow-injection`, `security`, `coverage` — none of their job blocks,
  `if:` conditions, or step key-sets are touched by this delta, and their corresponding
  pins in `tests/ci_gate_completeness.rs` (e.g. `PINNED_ALWAYS_RUN_JOB_KEY_SETS` entries
  for `fmt`/`clippy`/`test`/`msrv`/`deny`/`spec-guard`/`check-signing-workflow-injection`)
  must remain byte-identical after this delta — any incidental diff there is a scope leak.
- `Cargo.toml`, `deny.toml`, `rust-toolchain.toml`, `.cargo/config.toml` — unaffected.
- All other `docs/specs/*.md` files besides `cargo-mutants-policy.md`.
- The PRD (`​.factory/specs/prd/`), architecture (`.factory/specs/architecture/`), and
  domain-spec (`.factory/specs/domain-spec/`) directories — no BC/VP/architecture artifact
  is touched (per §Affected BCs above).
- `scripts/check-bc-citation-symbols.sh`, `scripts/check-cargo-mutants-policy-citations.sh`,
  `scripts/check-spec-counts.sh`, `scripts/check-bc-cumulative-counts.sh` — these scripts'
  OWN logic is unaffected; only their INPUT (`cargo-mutants-policy.md`) changes, and only
  outside the sections they parse (see Dependent Files above).

## Risk Assessment

| Risk Type | Level | Rationale |
|---|---|---|
| Regression (CI-gate machinery) | **HIGH** | See detailed per-component breakdown below. This is the exact hazard class (`false-GREEN mutation gate`) the entire S-CIGATE story-line (16+ documented adversarial review rounds in CLAUDE.md) exists to prevent, now applied to a NEW aggregation mechanism that has never been reviewed at that intensity. |
| Regression (product code) | **NONE** | No `src/` changes; full existing test suite is an exact regression net (see §Files NOT Changed). |
| Architecture | LOW | No product architecture change. CI *topology* changes (1 job → matrix + aggregator), which is architecturally a CI-infrastructure decision already anticipated and pre-approved in principle by `docs/specs/cargo-mutants-policy.md §Future Path: Job Sharding (Path B)`. |
| Security | LOW-MEDIUM | No new secrets, no new external network egress class beyond `actions/upload-artifact`/`download-artifact` (GitHub-native, already used elsewhere in this org's CI patterns generally, though verify this is the first use in THIS repo's `ci.yml` — F2 should confirm and, if novel, apply the same `step-security/harden-runner` egress-policy audit convention already on every other job). The `cargo-mutants@27` → `@27.1.0` exact-pin tightening (recommended by the research brief) is a security/reproducibility IMPROVEMENT, not a new risk. |
| Performance (CI wall-clock / cost) | MEDIUM (intentional trade) | This is the entire POINT of the change: wall-clock drops ~N× (research: N=8 → ~281/8≈35 mutants/shard ≈ ~2h/shard at current ~17.5/hr single-runner throughput, well within a per-shard `timeout-minutes: ~60` budget per the research brief's Step 1) at the cost of ~N× more billed GitHub Actions minutes (each shard re-pays checkout + incremental build). Acceptable trade per the research brief's Q5 analysis; F2 should still record the concrete minutes-budget delta for the human's awareness (free-tier 2,000 min/month cap noted in the prior MUTATION-CI-TIMEOUT delta). |
| Coordination / in-flight work | **MEDIUM-HIGH, TIME-SENSITIVE** | Per `.factory/STATE.md` at analysis time, PR #778 (cycle-005, Story A) is **currently OPEN and PAUSED**, blocked specifically on the `mutants` job (last known state: 13/14 checks green, "Mutation testing" PENDING/killed). This cycle-006 change directly modifies the very job PR #778 depends on. **This delta analysis must NOT be construed as authorization to touch `develop`'s `ci.yml` while PR #778 is unresolved** — F2 onward must explicitly sequence: either (a) resolve/merge or close PR #778 first under the OLD single-job gate (possibly via a manual/local kill-rate verification path, mirroring the SEC-001/PR#553 precedent noted in the MUTATION-CI-TIMEOUT delta), THEN land cycle-006's sharded gate on top of a clean `develop`; or (b) explicitly re-target PR #778 to be re-validated under the NEW sharded gate once it lands. This is a human-facing sequencing decision, not an engineering one — flagged for the F1 human gate. |

### Regression Risk — HIGH, Per-Component Guardrail Enumeration (CI-Gate Machinery)

The specific hazard is a **false-GREEN mutation gate**: a PR ships with kill rate below
90% (or with a genuinely broken mutant-detection setup) while `ci-gate` reports success.
Concrete failure modes this delta must guard against, each mapped to the exact guardrail
that must move in lockstep:

1. **Aggregation-sums-wrong (average instead of sum).** A 90%-shard + 60%-shard averaged
   to 75% is WRONG when the correct pooled rate could be well below 90% (e.g. tiny 90%
   shard, huge 60% shard). Guardrail: the aggregator must sum raw `caught`/`missed`/
   `timeout`/`unviable` counts across shards BEFORE computing one ratio — reuse the
   existing `Check kill rate` step's arithmetic (`kill_rate = (caught*100)/(caught+missed+
   timeout)`) verbatim, just fed pooled sums instead of one file's values. A new positive
   test in `tests/ci_gate_completeness.rs` (or a new sibling test file) should construct a
   synthetic multi-shard fixture where per-shard percentages individually exceed 90% but
   the pooled rate does not, and assert the aggregator correctly FAILS.
2. **Missing-shard-treated-as-pass.** If shard 3 of 8 never uploads an artifact (crashed
   runner, cancelled matrix leg, artifact-upload transient failure) and the aggregator
   silently proceeds with 7/8 shards' data, the missing shard's mutants are invisibly
   excluded from the denominator — a structurally-identical bug to the H-1
   "runtime-schema-drift" false-green class already fixed once in the single-job design
   (ADV-P50-MED-001, round 20). Guardrail: the aggregator MUST assert the exact expected
   shard count (matching the matrix's `N`) is present among downloaded artifacts and FAIL
   CLOSED (non-zero exit) if any are missing — before attempting to sum anything.
3. **`ALLOWED_SKIPS` / skip-tolerance drift.** `scripts/check-ci-gate.sh`'s
   `ALLOWED_SKIPS=("mutants")` and `tests/ci_gate_completeness.rs`'s
   `SKIP_TOLERANT_NEEDS_MEMBERS = &["mutants"]` and `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS`'s
   `mutants` → `github.event_name == 'pull_request'` entry all currently encode "the
   `mutants` job may report `skipped` ONLY on a push event, never otherwise." If these
   three pins are not ALL retargeted to `mutants-aggregate` in the same change, at least
   one of two failure shapes results: (a) `mutants-aggregate` reporting `skipped` on a PR
   event (e.g. a bug in the escape-hatch routing) is silently tolerated because the OLD
   `mutants` name is still in the allowlist and the NEW name isn't checked — meaning a
   genuinely-skipped required gate passes ci-gate; or (b) the literal-`if:`-expression pin
   (`PINNED_ALLOWED_SKIP_IF_EXPRESSIONS`) no longer matches anything, and the round-6/7
   S-CIGATE machinery's "is this job's `if:` a pinned, human-reviewed literal" check starts
   failing the gate's OWN test suite (a loud, CI-visible failure — safer than (a), but
   still a lockstep-update obligation). Guardrail: update all three sites together in one
   commit.
4. **8-job exact-set literal drift (AC-003).** `tests/ci_gate_completeness.rs` pins
   `ci-gate.needs` to an EXACT 8-name set (line ~678, includes the literal `"mutants"`).
   If `ci.yml`'s `ci-gate.needs` is edited to say `mutants-aggregate` but this test's
   literal is not, the test fails LOUD (good — this is a deliberate default-deny design,
   not a silent gap) — but it means F4 cannot ship `ci.yml`'s change without the paired
   test-file change in the SAME commit, or CI immediately red-flags the drift. This is a
   guardrail, not a risk, but is called out because a naive "just edit ci.yml" approach
   will hard-fail `cargo test` until the pin is updated.
5. **`PINNED_ALWAYS_RUN_JOB_KEY_SETS` / `PINNED_ALWAYS_RUN_STEP_KEY_SETS` scope
   ambiguity.** These two consts currently pin the COMPLETE job/step key-sets for the
   *non-matrix* `ci-gate.needs` members. `mutants-aggregate` is non-matrix (it is a single
   job, `needs: [<shard job>]`) and IS a `ci-gate.needs` member — so it likely belongs in
   these two pins, analogous to how `fmt`/`clippy`/`test`/etc. are pinned today. The SHARD
   matrix job, by contrast, is matrix-shaped and NOT a `ci-gate.needs` member — it needs
   its OWN new pin shape (there is no existing precedent for pinning a `strategy: matrix`
   job's key-set in this file; `clippy` is the closest existing matrix-job precedent via
   `PINNED_CLIPPY_GUARD_STEP_KEYS`, but that pins only ONE lint-gate step's keys, not the
   whole job). F2/F4 must design this net-new pin shape, not assume an existing one covers
   it — a matrix job smuggling a `continue-on-error`/`shell: cat {0}`/`defaults:` override
   on one shard is exactly the S-CIGATE round-10/11 hazard class, now on a job shape this
   test file has never had to pin before.
6. **Escape-hatch "neutral status" ambiguity with `check-ci-gate.sh`'s fail-closed
   default-deny.** `check-ci-gate.sh`'s `evaluate_needs()` currently accepts exactly two
   outcomes for a `ci-gate.needs` member: `success`, or `skipped` IF in `ALLOWED_SKIPS`.
   Everything else (`failure`, `cancelled`, any future GitHub Actions conclusion type never
   seen before) fails CLOSED by design. A "neutral, not a red block" escape-hatch status
   has NO natural encoding in this vocabulary today — if F4 implements it as the aggregator
   job exiting 0 while writing an out-of-band notice, that is functionally identical to
   `success` from `ci-gate`'s perspective, meaning "escalated, needs human ack" is
   INDISTINGUISHABLE from "genuinely passed 90%" to the branch-protection mechanism. This
   is the single largest unresolved design gap in the escape-hatch requirement — flagged
   for F2 (see Open Questions). Whatever mechanism F2 chooses, it must not silently
   degrade the fail-closed guarantee `check-ci-gate.sh` currently provides for every other
   `ci-gate.needs` member.
7. **`EXPECTED_FIXTURES` / `EXPECTED_GUARD_TEST_COUNT` / `EXPECTED_WF_TEST_COUNT` tripwire
   staleness.** All three are hardcoded integer denominators (`13`, `38`, `26`
   respectively at analysis time) that self-check the surrounding test suite hasn't
   silently lost a fixture/test to a bad `#[cfg]`/`#[ignore]`/deletion. Every new guard
   test or fixture this delta adds MUST increment the corresponding constant in the SAME
   commit, or the self-test tripwire fires (loud, not silent — but still a required
   lockstep edit F4 must remember).

## Regression Baseline

- **Total existing tests:** ~4,600+ (per the research brief's repo-context line: "~4,600
  tests (~93s)"), spanning `src/` inline `#[test]` modules and `tests/*.rs`.
- **Tests in risk zone:** the `tests/ci_gate_completeness.rs` guard suite (currently 81
  `#[test]` functions per a raw grep of `fn test_`, cross-checked against the file's own
  `EXPECTED_GUARD_TEST_COUNT = 38` tripwire — note this constant counts a DIFFERENT,
  narrower denominator than the raw `fn test_` grep, likely a specific guard-category
  subset; F2 must read the constant's own doc comment to confirm exactly what it counts
  before incrementing it) + `tests/common/wf.rs`'s own `#[cfg(test)] mod tests`
  (`EXPECTED_WF_TEST_COUNT = 26`) + `tests/mutants_glob_existence.rs` (Guard 3) +
  `scripts/check-cargo-mutants-policy-citations.sh --self-test` (Guard 2, 12 offline
  fixtures) + `scripts/check-ci-gate.sh --self-test` (`EXPECTED_FIXTURES = 13`).
- **Risk zone test files:** `tests/ci_gate_completeness.rs`, `tests/common/wf.rs`,
  `tests/mutants_glob_existence.rs`, `tests/claude_md_citations.rs` (if CLAUDE.md gains new
  path citations), `scripts/check-ci-gate.sh` (its own `--self-test` fixtures),
  `scripts/check-cargo-mutants-policy-citations.sh` (its own `--self-test` fixtures).
- **Everything else (the ~4,500+ remaining tests) is unaffected** and serves purely as the
  "no `src/` regression" baseline per §Files NOT Changed.

## Scope Recommendation

- **Mode:** Feature Mode (standard F1-F7), NOT quick-dev, NOT Full Pipeline. The change is
  contained (CI + one policy doc + one test file + one script), but touches the
  highest-scrutiny surface in the repo (the CI-gate fail-closed machinery), which warrants
  full F1-F7 rigor including F5 scoped adversarial review specifically targeting
  `tests/ci_gate_completeness.rs`'s new/retargeted pins with the same intensity CLAUDE.md
  documents for the original S-CIGATE rounds.
- **Estimated new stories:** likely 2-4, e.g.: (1) shard the `mutants` job + upstream
  shared-diff computation; (2) `mutants-aggregate` job + retarget `ci-gate.needs` +
  retarget all `tests/ci_gate_completeness.rs`/`scripts/check-ci-gate.sh` pins (this is the
  highest-risk, likely-largest story — may itself warrant splitting into "aggregator logic"
  + "gate-machinery pin retargeting" if F3 finds it exceeds a reasonable single-story size);
  (3) large-change escape hatch + neutral-status routing design; (4) scheduled advisory
  full-run workflow. F3 should confirm exact story boundaries once F2 resolves the open
  design questions below (especially the escape-hatch mechanism, which materially affects
  story 2's scope if the aggregator itself must encode escalation state).
- **Estimated effort:** CI-infrastructure stories of this shape (per this repo's own
  history — e.g. the original S-CIGATE rounds, MUTATION-CI-TIMEOUT cycle) have
  historically required MULTIPLE adversarial-review rounds even for "small" YAML/bash
  diffs, because the blast radius (a silently-broken required gate) is disproportionate to
  the diff size. Budget accordingly — this is not a "quick CI tweak."
- **Can parallelize:** Story 1 (sharding the matrix, no `ci-gate` retargeting yet — can run
  with `mutants` job coexisting or replaced in a feature branch) is largely independent of
  Story 4 (scheduled full run, wholly additive, no interaction with `ci-gate.needs`).
  Story 2 (aggregator + gate-machinery retargeting) has a HARD dependency on Story 1
  (needs real shard artifacts to test against) and should be sequenced after it. Story 3
  (escape hatch) depends on Story 2's aggregator existing (the escalation decision likely
  lives adjacent to or inside the aggregator/diff-computation flow).

### Correctness Invariants the New Aggregation Logic MUST Satisfy (for F2/F4/F6)

1. **Sum-not-average.** Kill rate is computed from POOLED `caught`/`missed`/`timeout`
   counts across all shards, never from an average of per-shard percentages.
2. **Every shard must report, or the gate FAILS closed.** The aggregator asserts the
   exact expected shard count is present among downloaded artifacts before computing
   anything; a missing, corrupted, or unreadable shard artifact is a FAIL, never a
   silently-excluded shard.
3. **Timeouts count as survived** (carried forward unchanged from the existing single-job
   design's documented v27 convention — `killable = caught + missed + timeout`, `unviable`
   excluded from the denominator because it never ran).
4. **Identical diff across all shards.** Every shard must mutate against the byte-identical
   diff file (research brief: "same diff or results are meaningless") — compute the diff
   ONCE upstream and thread it to every shard as an artifact, never recompute per-shard.
5. **`--baseline skip` requires an explicit `--timeout` on every shard** (no config-file
   fallback exists for the ceiling under `skip`; the existing `--timeout 240` CLI flag
   must be passed to every shard invocation) and requires a prerequisite job (`test`)
   proving the suite is green BEFORE any shard runs skip-baseline mutation testing.
6. **The base-ref-drift / empty-diff / zero-mutant PASS-vs-FAIL branching (F-3/F-4/F-5
   logic in the current single-job `Check kill rate` step) moves to the aggregator, not
   per-shard** — only the pooled view can correctly distinguish "genuine 0-mutant PR" from
   "base-ref drift produced an empty diff" from "a shard silently produced nothing."
7. **Malformed-JSON / integer-validation / H-1 schema-drift / M-2 reconciliation guards
   apply per-shard-file BEFORE summing** (garbage-in-one-shard must not corrupt the pooled
   total silently) — reuse the existing single-job guards' logic per artifact, not just
   once on a naively-concatenated blob.
8. **`mutants-aggregate`'s own `if:`/skip-tolerance must be re-derived, not copy-pasted**
   from the old `mutants` job's `if: github.event_name == 'pull_request'` — the aggregator
   must itself run (or explicitly, correctly report `skipped`) in a way consistent with
   `always()`-style downstream aggregation patterns already used by `ci-gate` itself, so
   that a push event correctly produces a benign `skipped` aggregator result rather than an
   aggregator that hangs waiting on shard jobs that never ran.

## Open Questions

1. **PR #778 sequencing (BLOCKING, time-sensitive).** PR #778 is currently open, paused,
   and blocked on the exact job this cycle modifies. Should F2 onward proceed against
   `develop` HEAD as-is (risking a merge conflict / re-validation need for PR #778 once
   this lands), or should the human resolve PR #778 first (e.g. via a manual/local
   kill-rate verification, mirroring the SEC-001/PR#553 precedent) before cycle-006's
   `ci.yml` changes are merged? Recommend resolving PR #778 first.
2. **Escape-hatch mechanism (BLOCKING for F2 design).** GitHub Actions has no native
   "neutral, not red" conclusion for a required check in the branch-protection sense used
   here (that concept exists for GitHub App check-runs, not plain `needs`-based required
   jobs). What concrete mechanism should F2 specify: (a) the aggregator exits 0 but writes
   a distinguishing job-summary/artifact a human must separately notice (functionally
   `success` to `ci-gate` — may be an accepted trade, but must be stated explicitly, not
   discovered later); (b) the aggregator reports `skipped` with a documented reason
   (requires adding it to `ALLOWED_SKIPS`, which then means EVERY large-diff PR skips the
   gate entirely rather than "escalating with a human ack" — likely too permissive); (c)
   some out-of-band mechanism (a required PR label, a separate lightweight
   "human-ack-required" required check that starts failing until a maintainer applies a
   label/comment) — closer to the "human ack" requirement but adds a wholly new
   `ci-gate.needs` member and its own fail-closed design. This needs explicit human
   input before F2 can finalize the design.
3. **Shard count N.** The research brief recommends starting at N=8 (comfortably fits
   PR #778's 281-mutant scale at ~35 mutants/shard, ~2h at current throughput) with
   headroom to 12-16 if recurrence is observed. Confirm N=8 as the starting value, and
   confirm the large-change threshold (research brief suggests ~120 mutants as the
   escalation trigger, "comfortably fits N=8 shards in ~1h") — is ~120 the right number for
   THIS repo's actual `examine_globs` scope, or should it be derived empirically (e.g. from
   PR #778's own numbers) in F2?
4. **`cargo-mutants` version pin tightening.** Confirm whether to adopt the research
   brief's recommendation to pin `cargo-mutants@27.1.0` exactly (not `@27`) in this same
   cycle, given the aggregator now depends on `outcomes.json`'s schema being stable across
   MORE invocations (N shards instead of 1) — arguably strengthens the case for the exact
   pin. Low-risk, but a deliberate scope inclusion/exclusion decision for F2.
5. **Where does the scheduled full-run job live?** A new standalone workflow file
   (`mutants-nightly.yml`) is architecturally cleaner (keeps `ci.yml`'s job-partition
   invariant, avoids the S-626-1 U1 "every job in ci.yml must be in `ci-gate.needs` or
   `PINNED_GATE_EXCLUDED_JOBS`" guard needing a new exclusion entry) — confirm this is
   preferred over adding a `schedule:`-triggered job inside `ci.yml` itself.
6. **`.cargo/mutants.toml` — confirm no change needed.** F1's read suggests no toml-level
   change is required (sharding/baseline/timeout are all CLI flags), but F2 should
   positively verify this rather than carry it forward as an assumption, especially if the
   escape-hatch pre-count step (`cargo mutants --list --in-diff`) reveals any config
   interaction not covered by this analysis.
7. **Test-count tripwire ownership.** Should the new guard tests for the aggregation
   correctness invariants (§Correctness Invariants above) live inside
   `tests/ci_gate_completeness.rs` (growing an already-large file, keeping one canonical
   home for all CI-gate structural guards) or a new sibling file (e.g.
   `tests/mutants_aggregate_completeness.rs`)? Given `tests/ci_gate_completeness.rs`'s
   documented history of extreme adversarial scrutiny and its `EXPECTED_GUARD_TEST_COUNT`
   convention, recommend keeping it in the same file for consistency, but F2 should decide.
