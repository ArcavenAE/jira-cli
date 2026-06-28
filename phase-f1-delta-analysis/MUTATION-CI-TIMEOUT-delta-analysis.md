---
document_type: delta-analysis
cycle: MUTATION-CI-TIMEOUT
date: 2026-06-28
analyst: architect (vsdd-factory)
origin: MUTATION-CI-TIMEOUT drift item (STATE.md)
status: draft — awaiting human approval
intent: enhancement
feature_type: infrastructure
trivial_scope: no
---
# Delta Analysis: MUTATION-CI-TIMEOUT

**Cycle:** MUTATION-CI-TIMEOUT
**Date:** 2026-06-28
**Intent:** `enhancement` — make an existing CI job fast and deterministic enough to become a required check
**Feature type:** `infrastructure` (CI/CD configuration + policy, no product behavior change)
**Quick-dev eligible:** No — requires BC authorship (a new ci-budget BC), ci.yml change, policy doc amendment, and a ci-gate.needs wiring decision with flakiness analysis. Multi-artifact scope disqualifies quick-dev.

---

## 1. Background

DEC-132 recorded that the `mutants` CI job for PR #553 (SEC-001 ADF recursion guard) was cancelled at exactly 1 hour — the GitHub Actions job timeout — after evaluating 36 mutants from `src/adf.rs`. The job is currently NON-REQUIRED (absent from `ci-gate.needs`). Kill rate was proven locally (100%) via per-site flip verification rather than via CI.

The problem manifests as: a correctness guarantee (mutation kill-rate ≥ 90%) cannot be enforced by branch protection because the job that enforces it is too slow to be required.

---

## 2. Root-Cause Analysis

### 2.1 The Primary Driver: Real-Wall-Clock Tests in `bulk.rs` Scope

The most significant timeout driver is not `adf.rs` volume — it is the interaction between `src/api/jira/bulk.rs` being in `examine_globs` and `tests/bulk_deadline_propagation.rs` using **real wall-clock sleeps**.

Key facts:
- `tests/bulk_deadline_propagation.rs` is a **subprocess test** (uses `assert_cmd::Command`) that drives `jr issue edit` against a wiremock server returning `HTTP 429 Retry-After: 60` indefinitely.
- It does this to test deadline propagation across process boundary. The test deliberately cannot use `tokio::time::pause` because `time::pause` is incompatible with subprocess + wiremock (tokio #4522, documented in the test file module-level comment).
- The test's wall-clock budget is `WALL_CLOCK_BUDGET_SECS ≈ 40s` (deadline 30s + one-poll RTT + tolerance). Each `bulk.rs` mutation that does not crash the binary before the deadline triggers this ~30–40s real-time sleep.
- With `timeout_multiplier = 3.0`, `cargo-mutants` auto-sets per-mutant test timeout = baseline × 3. The baseline for `cargo test --all-features` on ubuntu-latest includes this 30–40s test.
- Assuming baseline `cargo test` runs in ~90–120s (the `test` CI job has `timeout-minutes: 30` and completes well within that on ubuntu), the auto-timeout per mutant is approximately **270–360 seconds (~4.5–6 minutes)**.
- With `--jobs 4`, four mutants run in parallel. But each bulk.rs mutant that reaches the deadline test consumes a full 30–40s real slot.
- **36 mutants × ~100s average wall-clock each (mix of fast-fail + slow deadline tests) / 4 parallel jobs ≈ ~900s = ~15 minutes for a pure-adf.rs PR.** For a PR touching both `adf.rs` (many mutants, fast tests) and `bulk.rs` (fewer mutants, slow deadline tests), the slow bulk mutants dominate wall-clock time per parallel slot.

**The SEC-001 PR #553 scenario:** The PR touched `src/adf.rs` heavily (recursion depth guards, new `normalize_*` passes). `adf.rs` has ~362 fn occurrences and 11,435 LOC. Even with `--in-diff` narrowing to changed lines, 36 mutants were generated from the adf.rs diff. The recursion-guard functions (`normalize_list_item_content`, `normalize_blockquote_content`, `normalize_panel_content`, `assign_local_ids_walk`, `autolink_bare_urls`, `AdfRenderer::render_node`) each have depth-check conditionals — prime mutation targets.

### 2.2 The Compounding Driver: `--all-features` Build Cost Per Mutant

`additional_cargo_test_args = ["--all-features"]` means every mutant build and test run includes all features. For this crate there is no `[features]` section in Cargo.toml, so `--all-features` vs no-features produces an identical binary. However:
- Cargo does not know this without attempting the build. Each mutant triggers a fresh compile of the mutated source + link + test run.
- Swatinem/rust-cache IS present in the mutants job (line 179 of ci.yml), so the initial build is cached. But each mutated source file requires recompiling only the changed file and relinking — not a full rebuild. This means the per-mutant build cost is ~10–30 seconds (incremental recompile + relink), not minutes.
- The `--all-features` flag does not materially inflate cost here because there are no conditional features to toggle. This is a non-factor for this codebase.

### 2.3 The Scale Driver: `adf.rs` at 11,435 LOC

`src/adf.rs` is by far the largest examined file (11,435 LOC vs 2,341 for `cache.rs`, 881 for `bulk.rs`). It has:
- ~265 inline `#[test]` functions
- ~362 function occurrences
- ~228 operator-bearing lines (arithmetic/boolean/comparison operators that generate mutants)

A PR that touches a large fraction of `adf.rs` — like SEC-001, which added recursion guards across 6 recursive-descent sites — generates a large mutant count from `--in-diff`. The 36 mutants from SEC-001 came entirely from `adf.rs` changes. For a future PR that touches both `adf.rs` and `bulk.rs`, the count could be 50–80+ mutants.

### 2.4 Quantified Budget Model

Key knowns:
- SEC-001 PR: 36 mutants, 1 hour (cancelled). Implies ~1hr / 36 mutants = ~100s average per mutant at 4 jobs ≈ actual wall-clock per parallel slot was ~100s avg.
- The `test` CI job has `timeout-minutes: 30` and contains the 30–40s bulk_deadline_propagation tests plus ~265 adf.rs inline tests + 88 integration test files (67,084 total LOC across them). This suggests baseline `cargo test --all-features` takes roughly 60–90s on ubuntu-latest.
- With `timeout_multiplier = 3.0`: per-mutant timeout ceiling = ~270s. With `--jobs 4` the wall-clock per 4-mutant batch = max(individual test times). If one of 4 concurrent mutants hits the bulk deadline test, that batch takes 30–40s minimum.
- **Worst-case (bulk.rs mutation dominates):** 10 bulk.rs mutants × 40s each / 4 jobs = ~100s. Safe.
- **Worst-case (adf.rs at 100 mutants, bulk.rs at 20 mutants):** adf.rs tests are fast (inline unit tests, wiremock but no real sleeps). Probably ~15–30s per adf.rs mutant. 100 mutants / 4 jobs × 20s avg = ~500s ≈ 8 minutes for adf.rs alone. 20 bulk.rs mutants / 4 × 40s = ~200s = 3 more minutes. Total ~11 minutes. This is fine.
- **Worst-case (adf.rs at 200 mutants + bulk.rs at 20 mutants with 3× multiplier stacking):** 200 / 4 × 25s avg = 1,250s ≈ 21 minutes for adf.rs. Plus 5 minutes for bulk. Total ~26 minutes. Approaching the budget. If mutant count is 300+, this exceeds 30 minutes.

**Root cause summary:** The 1-hour timeout on PR #553 was caused by a combination of (a) high mutant count from the large adf.rs diff and (b) the `timeout_multiplier = 3.0` per-mutant ceiling being wide enough to let slow mutants dominate per-slot time. The bulk.rs deadline test is a structural slow-test risk for any PR that touches bulk.rs. The current setup has no absolute per-mutant timeout cap that would fail fast on hung mutants.

### 2.5 Note on Research File

The concurrent research agent file `.factory/research/mutation-ci-perf-2026-06-28.md` was not present at analysis time. The F2/design step must reconcile with it when available.

---

## 3. Design Options

### Option A — Add an Absolute Per-Mutant Timeout Cap (RECOMMENDED COMPONENT)

**What:** Add `--timeout 120` (or set `minimum_test_timeout` in `.cargo/mutants.toml`) to cap each mutant's test phase at 120s regardless of the 3× multiplier.

**Rationale:** The bulk_deadline_propagation test runs in ~30–40s real time. A 120s cap (3× the slow test) is generous for legitimate test runs while catching genuinely hung mutants quickly. Currently `timeout_multiplier = 3.0` scales with baseline; if baseline grows, the cap grows unboundedly. An absolute cap breaks the linear growth.

**Trade-off:** A cap that is too tight would count real slow tests as timeouts (which count as survived mutants per cargo-mutants v27). Setting 120s is safe: the slowest legitimate test (~40s) × 3 = 120s exactly. Any mutant exceeding 120s is a hang, not a slow test.

**Change:** `.cargo/mutants.toml`: add `minimum_test_timeout = 120` (sets a floor/ceiling). Or add `--timeout 120` to the CI step.

**Estimated savings:** Cuts worst-case per-mutant budget from ~270–360s to 120s. At 4 jobs and 36 mutants: 36/4 × 120s max = 1,080s = 18 minutes maximum. Well within 30 minutes.

### Option B — Reduce `timeout_multiplier` from 3.0 to 2.0

**What:** Drop `timeout_multiplier` in `.cargo/mutants.toml` from 3.0 to 2.0.

**Rationale:** The 3.0 multiplier was set to absorb `tokio::time::sleep` hangs in async mutations. With rust-cache in the mutants job, build times are short. A 2.0 multiplier still allows 2× baseline per mutant.

**Trade-off:** Lower multiplier increases risk of legitimate slow mutations timing out and being counted as survived (kill-rate denominator noise). The bulk_deadline_propagation test at ~40s real with a ~90s baseline means 2.0× = 180s — still adequate. But this alone does not solve the problem if mutant count is high; it only reduces per-mutant budget from ~270s to ~180s.

**Change:** `.cargo/mutants.toml`: `timeout_multiplier = 2.0`.

**Estimated savings:** ~33% reduction in worst-case per-mutant time. Helps but is not sufficient alone for large diffs.

### Option C — Narrow `examine_globs` to Exclude `adf.rs` from Automatic Mutation

**What:** Remove `src/adf.rs` from `examine_globs` and instead run it separately only on PRs that explicitly touch adf.rs (by adding a conditional step or splitting the job).

**Rationale:** `adf.rs` at 11,435 LOC is 66% of the total examined LOC and generates the majority of mutants on any ADF-touching PR. It already has 265 inline tests, 3 dedicated integration test files, and proptest strategies. Its mutation surface is vast.

**Trade-off:** Removing `adf.rs` from routine mutation scope weakens the kill-rate gate on the most behavior-dense module. The policy spec calls it a "high weak-assertion surface" module. This is the highest-value target in the scope. Removing it entirely would be a significant policy regression.

**Alternative:** Keep `adf.rs` in `examine_globs` but add a **path filter** in the CI step: only run cargo-mutants (including adf.rs mutations) when `src/adf.rs` appears in the PR diff. For PRs that don't touch adf.rs, the current `--in-diff` already handles this — no change needed there. For PRs that DO touch adf.rs, accept the longer runtime and set a higher job timeout (90min) for adf.rs-touching PRs while keeping the 30min ceiling for non-adf PRs. This requires conditional logic in CI YAML.

**Estimated savings:** Not applicable as a standalone option; this is a structural refactor, not a budget fix.

### Option D — Job Sharding

**What:** Split the mutants job into N parallel shards using `cargo mutants --shard 1/N`, running each shard as a separate parallel GitHub Actions job.

**Rationale:** cargo-mutants v27+ supports `--shard K/N` and `--sharding round-robin|slice`. With 4 shards, 36 mutants becomes ~9 per shard. At 4 parallel shards × 4 jobs each = 16 concurrent mutant runs. Wall-clock drops proportionally.

**Trade-off:**
- Sharding multiplies the cost to the GitHub Actions minutes budget (4 shards × 60 min = 240 minutes per PR, vs 60 now). Free-tier repos have 2,000 minutes/month.
- The `ci-gate.needs` list would need all shard jobs listed, or a shard-aggregator job, to become required. This adds YAML complexity.
- Sharding does not help if a single shard still exceeds the time limit (e.g., all adf.rs slow mutants land in one shard with round-robin).

**Estimated savings:** Halves wall-clock at cost of 4× minutes consumption. Good only if minutes budget is not a constraint.

### Option E — Accept Non-Required Status (Current State)

**What:** Keep the job advisory (non-required), rely on local kill-rate verification for critical PRs (as was done for SEC-001), and add a visible CI artifact (outcomes.json annotation or PR comment) so the kill rate is surfaced even when not required.

**Trade-off:** The kill-rate guarantee is not enforceable by branch protection. A contributor PR that reduces kill rate below 90% on `adf.rs` mutations will not be blocked. This is the current state per DEC-132.

**When this is the right choice:** If the human wants zero risk of flaky-required-job, this is safe. But it means the mutation gate is effectively advisory-only.

### Option F — Restructure Slow Tests Out of the Default Suite (REQUIRES SRC CHANGE)

**What:** Move `tests/bulk_deadline_propagation.rs` behind a feature flag or `#[ignore]` tag so it does not run during mutation testing baseline (cargo-mutants' baseline run). Mutation testing would then use the fast test suite, and the slow deadline tests would run separately in a named step.

**Trade-off:** This is an invasive change to test architecture. The deadline test is a critical correctness test (BC-3.X). Gating it behind `#[ignore]` creates a coverage regression. Not recommended without a dedicated story.

---

## 4. RECOMMENDED APPROACH

**Recommendation: Option A + Option B in combination, wired as required with a higher job timeout.**

### Specifics

1. **`.cargo/mutants.toml`:** Add `minimum_test_timeout = 120` (absolute ceiling per mutant's test phase). Drop `timeout_multiplier` from `3.0` to `2.0`.
   - With baseline ~90s, a 2.0× multiplier = 180s per-mutant ceiling before the absolute cap overrides it. The cap at 120s kicks in for any mutant exceeding that: bulk slow tests run ~40s (well under 120s), so no legitimate test is cut short. Hung async mutations are killed at 120s.

2. **`ci.yml` mutants job:** Raise `timeout-minutes` from `60` to `90`.
   - Worst-case budget with 120s cap and 4 jobs: 80 mutants / 4 × 120s = 2,400s = 40 minutes. 90 minute ceiling provides comfortable headroom for build overhead, cache misses, and any unusually large diffs.

3. **`ci-gate.needs` wiring:** Add `mutants` to `ci-gate.needs` per DEC-096/097.
   - The `mutants` job already has `if: github.event_name == 'pull_request'`. The `ci-gate` job has `if: ${{ always() }}`. When `mutants` is in `ci-gate.needs`, a skipped `mutants` job (push event, not PR) must not fail ci-gate. This requires adding a `skipped` result to the ci-gate pass condition. Current ci-gate only checks for `failure` or `cancelled` — a `skipped` result is treated as success, which is correct. **No ci-gate logic change required** — `contains(needs.*.result, 'failure') || contains(needs.*.result, 'cancelled')` already passes when `mutants` is `skipped` on push events.

4. **`docs/specs/cargo-mutants-policy.md`:** Update to reflect the new timeout parameters, the rationale for 120s absolute cap, and the promotion to required check.

### Budget model under recommendation

- 36 mutants (SEC-001 scale): 36 / 4 × (avg ~30s per mutant + ~15s build overhead) = 36/4 × 45s = ~405s ≈ 7 minutes. Well within 90min.
- 80 mutants (large adf.rs PR): 80/4 × 80s avg = 1,600s ≈ 27 minutes. Within 90min.
- 120 mutants (very large adf.rs + bulk PR): 120/4 × 80s avg = 2,400s ≈ 40 minutes. Within 90min.
- 200 mutants (extreme; touches every examine_globs file): 200/4 × 100s avg = 5,000s ≈ 83 minutes. Would exceed 90min in worst case. Safety valve: at 200+ mutants the PR is extremely large (likely a major refactor); a longer timeout or split PR is appropriate in that scenario.

**Target: completes in <40 minutes for typical PRs, <60 minutes for very large PRs. Required with 90min timeout.**

---

## 5. Required-Check Wiring Plan

Per CLAUDE.md and DEC-096/097: **new required jobs must be added to `ci-gate.needs`, never wired directly into branch protection.**

Current `ci-gate.needs`:
```yaml
needs: [fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection]
```

Proposed change:
```yaml
needs: [fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants]
```

**Behavioral analysis of the `if: always()` guard:**

The `mutants` job has `if: github.event_name == 'pull_request'`. On a push event to `develop`/`main`, `mutants` does not run and its result is `skipped`. The ci-gate condition is:

```yaml
if: >-
  ${{ contains(needs.*.result, 'failure') ||
      contains(needs.*.result, 'cancelled') }}
```

`skipped` is neither `failure` nor `cancelled`, so ci-gate passes on push events. This is the correct behavior — push-to-develop does not require mutation testing.

**Flakiness risk of making it required:**

The flakiness risk is moderate, not low. Sources of non-determinism:
1. **GitHub Actions runner performance variability:** ubuntu-latest runners vary in CPU speed. A mutant that runs in 80s on a fast runner may take 110s on a slow one. With the 120s absolute cap, a 10–20% runner speed variance is within budget.
2. **crates.io download reliability:** taiki-e/install-action downloads cargo-mutants; if the registry is slow, startup overhead increases. Mitigated by Swatinem/rust-cache which caches the mutants binary after first install (cargo tool caching is supported).
3. **Mutex/network contention in wiremock tests:** parallel mutant runs each start their own test processes, each starting their own wiremock servers. 4 concurrent test processes × N wiremock ports. This is already how the current setup works; no new risk.
4. **Genuine timeout at 90min from extremely large diff:** A 200+ mutant PR could exceed even 90min. This is the correct behavior (the job should fail on a PR that generates too many mutations without sharding) — it is not flakiness, it is a signal that the PR is too large for in-diff mutation testing.

**Recommendation:** Make required with `timeout-minutes: 90`. Accept that 200+ mutant PRs may timeout (treat as a forcing function to keep PR diffs focused, consistent with the existing `--in-diff` philosophy).

---

## 6. Impact Boundary

### Files That Change

| File | Change Type | Change |
|------|-------------|--------|
| `.github/workflows/ci.yml` | MODIFIED | `ci-gate.needs` adds `mutants`; `mutants` job `timeout-minutes: 60 → 90` |
| `.cargo/mutants.toml` | MODIFIED | Add `minimum_test_timeout = 120`; change `timeout_multiplier = 3.0 → 2.0` |
| `docs/specs/cargo-mutants-policy.md` | MODIFIED | Document new timeout parameters, required-check status, 120s rationale, flakiness risk |

### Files NOT Changed (Regression Baseline)

All `src/` files, all `tests/` files, all other CI workflows, all factory spec files, `Cargo.toml`, `deny.toml`.

### Spec Anchor

No dedicated BC exists for the mutation gate. It is governed by the policy spec at `docs/specs/cargo-mutants-policy.md` and the existing kill-rate enforcement in the CI YAML `Check kill rate` step. The MUTATION-CI-TIMEOUT drift item (STATE.md) is the current tracking anchor.

**For F2:** A new BC may be warranted — something like `BC-X.14.001: mutation-gate-required-check` — to formally anchor the invariant that the mutation gate is required and has a defined timeout budget. Alternatively, the policy spec amendment alone may be sufficient (the BC would be for the CI behavior contract itself, which is an unusual use). The human should decide whether to author a BC here or treat the policy spec as sufficient.

### No src/ test additions required

The existing test suite already drives the mutation gate. No new tests need to be added to `src/` or `tests/` as part of this cycle. This is a pure CI-config + policy change.

---

## 7. Open Questions for Human Decision

**Q1 (BLOCKING): Hard-required vs advisory-but-visible?**
Do you want the mutation gate to become a hard branch-protection requirement (added to `ci-gate.needs`), or should it remain advisory with better surfacing (e.g., a PR comment posting the kill-rate outcome)? The advisory path has zero flakiness risk; the required path has moderate flakiness risk from runner variance and very large diffs.

**Q2: Acceptable timeout for the required job?**
This analysis recommends `timeout-minutes: 90`. Is that acceptable for PR wait time? Alternatively, you could accept non-required status and instead surface the kill rate as a PR check annotation (non-blocking, but visible).

**Q3: New BC for the mutation gate?**
Should F2 author a BC (e.g., `BC-X.14.001`) formally contracting the mutation gate behavior (required, ≥90% kill rate, ≤90min budget), or is the policy spec amendment sufficient as the sole governance artifact?

**Q4: `timeout_multiplier` reduction risk?**
Dropping `timeout_multiplier` from 3.0 to 2.0 reduces the per-mutant budget for slow async mutations. The bulk_deadline_propagation test runs ~40s; with 2.0× baseline ~90s = 180s ceiling — adequate. But if a future bulk mutation produces a genuinely slow hang that requires >120s to detect (the proposed absolute cap), it will be classified as `timeout` (survived) rather than caught. Is that acceptable under the kill-rate policy?

**Q5: Scope of this cycle — is this trivial or standard?**
This analysis classifies the scope as **standard** (not trivial) because it requires a policy doc amendment, a ci.yml structural change (ci-gate.needs), and potentially a new BC. If you decide no new BC is needed and the change is `mutants.toml` + `ci.yml` only, it could qualify for quick-dev routing. Human judgment call.

---

## 8. Affected Artifact Mapping

| Artifact | Change | BC Anchor |
|----------|--------|-----------|
| `.github/workflows/ci.yml` | `ci-gate.needs` + timeout | No dedicated BC; DEC-096/097 governs wiring |
| `.cargo/mutants.toml` | Timeout parameters | `docs/specs/cargo-mutants-policy.md` §CI Integration |
| `docs/specs/cargo-mutants-policy.md` | Policy amendment | Self-governing policy doc |
| MUTATION-CI-TIMEOUT drift item (STATE.md) | Close on completion | STATE.md Drift Items table |

---

## 9. Regression Risk Assessment

| Component | Risk Level | Rationale |
|-----------|------------|-----------|
| `ci-gate` job | MEDIUM | Adding `mutants` to `ci-gate.needs` introduces a new required job; flaky runner performance could block PRs unexpectedly. Mitigated by 90min timeout and `skipped`-safe condition logic. |
| Existing CI jobs | LOW | No changes to fmt, clippy, test, msrv, deny, spec-guard, security, coverage, check-signing-workflow-injection. |
| Mutation kill-rate enforcement | LOW | Reducing `timeout_multiplier` to 2.0 slightly increases timeout-classified survivors; this is acceptable under the policy (timeouts count as survived). |
| PR merge flow | LOW | Pushing to develop/main: ci-gate still passes (mutants skipped, not failure). No change to push-event behavior. |

---

## 10. Summary

**Root cause:** 36 mutants from a large `src/adf.rs` diff (SEC-001), combined with the `timeout_multiplier = 3.0` producing per-mutant budgets of ~270–360s and the absence of an absolute timeout cap, consumed the full 60-minute job budget.

**Recommended fix:** Add `minimum_test_timeout = 120` + drop `timeout_multiplier` to 2.0 in `.cargo/mutants.toml`; raise job timeout to 90 minutes; add `mutants` to `ci-gate.needs`.

**Key human decision:** Q1 — hard-required vs advisory. Everything else is implementation detail.

**Research note:** `.factory/research/mutation-ci-perf-2026-06-28.md` was not present at analysis time. F2 must reconcile with it when available, particularly for any cargo-mutants v27+ configuration options not captured here.
