# Mutation Testing in CI for Large Changes — Research & Recommendations

**Date:** 2026-09-07
**Author:** research agent (Corverax)
**Scope:** How to run `cargo-mutants` (and mutation testing generally) as a CI gate when a single PR's diff produces a large mutant count, without blowing the wall-clock cap.
**Repo context:** single-crate Rust CLI `jr`, ~4,600 tests (~93s) + build ~195s baseline. `cargo-mutants@27`, invoked `cargo mutants --in-diff <pr.diff> --jobs 4 --timeout 240`, required PR-only gate on `ubuntu-latest`, `timeout-minutes: 240`, 90% kill-rate threshold parsed from `mutants.out/outcomes.json`.
**Trigger:** one story's diff generated **281 mutants**; at observed throughput (~70 mutants/4h with `--jobs 4`) the full set needed ~16h → the single job hit the 4h cap and was killed (`cancelled`/`fail`), blocking merge. Cost is dominated by *mutant count × per-mutant (incremental build + test)*, not by kill rate.

---

## Executive Summary

1. **The root cause is architectural, not a tuning problem.** A single-runner job's throughput (~17.5 mutants/hr here) cannot be meaningfully raised by `--jobs` on a 2–4 vCPU hosted runner — cargo-mutants explicitly warns that high `--jobs` thrashes memory/disk and that each job spawns a full `cargo test` that already parallelizes internally. The scalable lever is **horizontal sharding across a CI matrix** (`--shard k/n`), which cargo-mutants supports natively and combines with `--in-diff`. **[CONFIRMED — mutants.rs/shards.html, mutants.rs/parallelism.html]**

2. **Shard, then aggregate by summing outcomes — not by exit code.** cargo-mutants' native pass rule is "every mutant caught → exit 0"; the repo tolerates 90%. So the aggregation gate must **download every shard's `outcomes.json`, sum `caught`/`missed`/`timeout`, and compute one kill rate** — averaging shard percentages is wrong (a 90% tiny shard + 60% huge shard ≠ 75%). There is **no built-in shard-merge command**; CI owns aggregation. **[CONFIRMED]**

3. **A hard, full, per-PR mutation gate is NOT the mature default.** The well-established pattern (Google's at-scale system, PIT/Stryker/mutmut guidance) is: diff-scoped + time-budgeted per PR, full/scheduled runs on `main`/nightly, and escalation for oversized changes. Keeping mutation testing *required* is defensible, but it should be paired with **a bounded budget + sharding + a large-change escape hatch**, not an unbounded 4h single job. **[CONFIRMED for the general pattern; the "required vs advisory" choice is a policy decision, not a verifiable fact]**

4. **`--baseline skip` in shards + a prerequisite `test` job** removes the per-shard baseline re-run (this repo already has a `test` job that proves the suite green). Requires an explicit `--timeout` (already set). **[CONFIRMED — mutants.rs/baseline.html, mutants.rs/shards.html]**

5. **Bound the mutant population** with `#[mutants::skip]`, `exclude_re`, and tightening `examine_globs`, and preview with `cargo mutants --list` before merging config. Note the **v27.0.0 precedence change**: CLI filters now *combine with* config values instead of replacing them. **[CONFIRMED — mutants.rs/changelog.html]**

6. **Recommended concrete change for this repo:** replace the single `mutants` job with a **prerequisite-gated matrix of 8–16 shards** (`--in-diff` + `--shard k/N` + `--baseline skip` + `--jobs 2`, `timeout-minutes: ~60` per shard), plus a **final aggregator job** that sums the shards' `outcomes.json` and enforces the 90% threshold. Add an **estimate/escalation guard** so a truly huge diff routes to a nightly/full run instead of blocking merge. Details in the final section.

---

## Q1 — cargo-mutants scaling features (verified against mutants.rs / sourcefrog/cargo-mutants)

### `--shard k/n` (sharding) — **CONFIRMED**
- Syntax `--shard k/n`: `n` = total shards, `k` = zero-based index `0..n-1`. Each shard independently discovers the **full** candidate mutant set and selects its slice — no runtime coordination. `--list --shard k/n` previews a shard's subset. (mutants.rs/shards.html)
- **Two algorithms:** `--sharding slice` (default since v26 — contiguous slices, better build locality, possibly uneven runtimes) and `--sharding round-robin` (mutant `i` → shard `i % n`, more even balance, worse locality). (mutants.rs/shards.html, changelog)
- **Invariant:** "All shards must be run with the same arguments, and the same sharding denominator `n`, or the results will be meaningless" — same source revision, filters, diff, ordering. (mutants.rs/shards.html)
- **Sizing:** the book recommends choosing `n` so each shard runs **"at least 10 mutants… 8 to 32 shards might be a good place to start."** Every shard pays checkout + clean-build startup, so over-sharding wastes CI. (mutants.rs/shards.html)
- **Combines with `--in-diff`:** "Sharding can also combine with `--in-diff`, again as long as all shards see the same diff." (mutants.rs/shards.html)
- **Combines with `--baseline skip`** — "you must ensure that the test suite is passing in the baseline, for example by checking it in a previous CI step." (mutants.rs/shards.html)
- **Aggregation:** the docs state only "If any shard fails then that would indicate that some mutants were missed" and provide **no built-in merge command**; `outcomes.json` format is explicitly unstable. CI must collect artifacts and decide pass/fail. (mutants.rs/shards.html, mutants.rs/mutants-out.html)
- **Exit codes** (for CI logic): `0` all caught / no mutants; `2` missed; `3` timeout; `4` baseline failed/hung; `5` diff new-side ≠ tree; `6` invalid diff; `70` internal error. (mutants.rs/exit-codes.html)

### `--test-tool nextest` — **CONFIRMED, benefit is workload-dependent**
- `--test-tool nextest` (or `test_tool = "nextest"` in config) runs each test in its own process, schedules test targets concurrently, and its fail-fast default helps because cargo-mutants only needs **one** failing test to mark a mutant caught. (mutants.rs/nextest.html)
- **Caveat:** not universally faster — slow integration "straggler" tests can leave it slower; the cargo-mutants project itself is cited as an example that can be *slower* under nextest. **nextest does not run doctests**, so doctest-only coverage shows as missed. **Benchmark both.** (mutants.rs/nextest.html)

### `--baseline run|skip` — **CONFIRMED; `auto` does NOT exist**
- Accepted values are `run` (default) and `skip`. `--baseline=auto` is **UNVERIFIED / does not appear in v27** — likely confusion with *automatic timeout calculation*. (mutants.rs/baseline.html)
- `run`: builds+tests unmutated scratch tree first (verifies tests pass, seeds incremental build, derives auto-timeout; failure → exit 4).
- `skip`: assumes unmutated tests pass; saves one full baseline test per shard; **requires explicit `--timeout`** (no baseline timing available; documented 300s fallback otherwise). Ideal for sharded CI where a prior job already ran the suite. There is **no config-file key** for baseline. (mutants.rs/baseline.html)

### `--in-diff <file.diff>` semantics + pitfalls — **CONFIRMED**
- Retains only mutants whose source ranges overlap changed diff regions; applied **after** package/file/regex filtering. Diff should use git's `b/` new-file prefix or no prefix. (mutants.rs/in-diff.html)
- **Pitfalls:** (1) diff new-side must match checkout (else exit 5; malformed → exit 6); (2) all shards must get **byte-identical** diffs; (3) **test-only changes select no production mutants** (diff is matched against code under test); (4) it is *not* dependency-impact analysis — weakened coverage of *unchanged* code elsewhere is not caught; (5) deletion-heavy diffs select little; (6) empty diffs accepted (v24.7.1+). The docs explicitly say `--in-diff` **is not a substitute for a full run** — schedule periodic full runs. (mutants.rs/in-diff.html, mutants.rs/pr-diff.html)

### Bounding mutant count — **CONFIRMED**
- **`#[mutants::skip]`** (requires the tiny `mutants` crate as a normal dependency): applies to functions, `impl`/trait blocks, inline `mod`, whole files via `#![mutants::skip]`, and attribute-bearing expressions; `#[cfg_attr(test, mutants::skip)]` is always honored (cfg not evaluated). **Version note:** honoring skip on `const`/`static` items is an **unreleased post-v27.1 fix** — do not assume v27 skips const/static-initializer mutations; verify via `--list`. (mutants.rs/attrs.html, changelog)
- **`exclude_re` / `examine_re`** (config) and `--exclude-re` / `--examine-re` / `--re` (CLI): regex (Rust `regex` crate) matched substring-wise against the full `--list` display name (path + fn + return type + mutation text); inclusion applied before exclusion. (mutants.rs/filter_mutants.html)
- **`exclude_globs` / `examine_globs`** (config) and `--exclude` / `--file` (CLI): globs with `/` are path-relative to source root; excluded files are still parsed for `mod` following. (mutants.rs/skip_files.html)
- **v27.0.0 precedence change (CONFIRMED, important):** CLI `--file`/`--exclude`/`--examine-re`/`--exclude-re` now **combine with** config values rather than replacing them (was "replace" pre-27.0.0). Use `--no-config`/`--config=OTHER` for an isolated one-off selection. (changelog)

### Incremental / caching — **PARTIALLY CONFIRMED; no cross-run result cache**
- **Supported:** within-run incremental Cargo builds (reused scratch dir), locality-aware deterministic ordering (v26+), `--in-diff` scope reduction, reflink/CoW scratch copies (v26; mtimes fixed v27.1), and `--in-place` (no source copy; **incompatible with `--jobs`**).
- **NOT present:** a verified v27 cross-run "this identical mutant was previously caught, skip it" cache analogous to Stryker `--incremental` / PIT `withHistory`. `--in-diff` is a scope filter, not a result cache. `mutants.out/previously_caught.txt` exists for `--iterate` but its CI-cache semantics are **UNVERIFIED** for this use. (mutants.rs/how-it-works.html, mutants.rs/in-place.html, mutants.rs/iterate.html, changelog)

### `--jobs` vs vCPU — **CONFIRMED: do NOT set jobs = vCPU**
- Official guidance: start at **`--jobs 2`** (maybe 3 after measuring); values >8 warn (v25.0.1+); high values useful only on very large machines (>100 cores / 256 GB). Each job runs a whole `cargo test` that already parallelizes; a GNU jobserver (v24.9+) limits compiler oversubscription but the **test harness does not participate**, so concurrent suites can still overload. Watch for OOM/swap, load average, linker contention, false timeouts, non-hermetic test contention, and per-job multi-GB `target` dirs. **For CI, prefer more shards at `--jobs 1–2` over one machine at high `--jobs`.** (mutants.rs/parallelism.html, mutants.rs/jobserver.html)
  - *Implication for this repo:* the current `--jobs 4` on a 2–4 vCPU hosted runner is likely at or past the useful ceiling and may be contributing to the low throughput / timeout risk. Sharding at `--jobs 2` is the higher-leverage change.

---

## Q2 — General CI mutation-testing strategy for large changes (ecosystem)

| Tool | Incremental/diff mechanism | Baseline artifact | Bounds per-PR cost | Key limitation |
|---|---|---|---|---|
| **PIT / pitest (JVM)** | History file (`historyInputFile`/`historyOutputFile`); `withHistory=true` convenience | PIT history file | Reuses unchanged class/test outcomes; combine with changed-package glob | Incremental is **experimental**; `withHistory` picks a temp path and **ignores explicit paths** → ineffective across ephemeral runners; run cold periodically. (pitest.org/quickstart/incremental_analysis, faq) |
| **StrykerJS (JS/TS)** | `stryker run --incremental`; `--force` ignores reuse | `reports/stryker-incremental.json` (`--incrementalFile`) | Reuses killed/undetected mutants when killing/relevant tests unchanged; full report preserved | First run full; must restore before + save after; key cache by version/config/runner/lockfile. (stryker-mutator.io/docs/stryker-js/incremental) |
| **Stryker.NET** | `--since:<ref>` (scope to changed) or `--with-baseline:<ref>` (execute-affected + full report); mutually exclusive | baseline report in storage | Bounds execution + reporting to changed code | Shallow checkout / wrong merge base → wrong scope. (stryker-mutator.io/docs/stryker-net/configuration) |
| **mutmut (Python)** | Remembers completed work, maps functions→tests, watches dependency files; `cache_invalidation_files`, `on_dependency_change` | `mutants/` (or legacy `.mutmut-cache`) | Skips resolved mutants; test-relevance selection | Cache ≠ git changed-line filter; set `on_dependency_change="rerun"` for correctness. (mutmut.readthedocs.io) |
| **cargo-mutants (Rust)** | `--in-diff` scope filter | none (no cross-run result cache) | Cost ∝ mutants on changed lines; combine with `--shard` | No incremental result cache; fetch full history for correct base diff. (mutants.rs/in-diff, shards) |
| **Google (internal, cross-language)** | Mutate **changed lines only** during review; drop uncovered/"arid" locations; historically-productive operators; **cap mutants per line and per review** | central operator-productivity data | Diff scope + sampling + operator filtering ⇒ hard ceiling even on a huge repo | Infra/operator-ranking not shipped by OSS tools. (research.google "Practical Mutation Testing at Scale"; testing.googleblog.com 2021) |

**What actually bounds a large PR** (no single mechanism suffices — a refactor-heavy diff can still touch thousands of mutable lines): combine **scope bound** (changed lines, exclude generated/low-value code) + **mutant bound** (operator/sampling caps) + **time bound** (fixed budget, record "incomplete" ≠ pass) + **parallel bound** (shards up to a cost ceiling) + **change-size bound** (above a mutant-count threshold, route to a merge-queue/nightly full run or split the PR) + **risk bound** (require completion for security/auth/finance code; allow advisory partial for low-risk bulk).

**Aggregation into one gate** (all sources agree): run the matrix with **`fail-fast: false`**, upload each shard's full report, and in a final job **sum statuses** (`detected = killed + timeout`, `valid = detected + survived + no-coverage`) — **do not average shard percentages**. A robust gate verifies commit SHA, tool/config fingerprint, **expected shard count present**, baseline green, no infra errors, and the aggregate metric. (Stryker mutant-states/metrics; pitest `pitest-aggregator`; mutants.rs/shards.html)

---

## Q3 — Blocking vs non-blocking gate design

**Established answer: a repository-wide full mutation campaign as a hard required per-PR check is *not* the mature default for a large codebase.** The scalable production shape:

| Stage | Scope | Blocking policy | Realistic threshold |
|---|---|---|---|
| **Adoption** | core/changed code | advisory; post survivors; fail only on infra errors | record baseline first |
| **Stable PR check** | diff-scoped + incremental + time-budgeted | block on regressions / new actionable survivors; **"incomplete" → retry/escalate, never silent pass** | practical floors ~50–60% → 60–70% app code, 70–80% well-tested logic |
| **Critical-code PR** | changed auth/authz/payments/safety | block; require disposition of every new survivor (not just a %) | 80%+ for narrowly-scoped critical code |
| **Nightly/scheduled** | whole repo | usually non-blocking per-PR; alerts + refreshes canonical baseline | ratchet vs full-run baseline |
| **Release / merge queue** | full campaign for large/high-risk change | hard gate acceptable when latency tolerable & capacity provisioned | require all shards complete |

**Why these are heuristics, not standards:** Stryker's high-80/low-60 defaults are **reporting bands** — StrykerJS defaults `break` to `null`, Stryker.NET to `0` (neither fails the build by default). PIT supports `mutationThreshold` but warns equivalent mutants make it brittle; PIT's maintainer says he doesn't personally use score-failure. Stryker's own threshold demo ran in a **nightly** build. Google's at-scale evidence is **changed-code** mutation with aggressive filtering, not exhaustive per-change mutation. **60–80% is a defensible band, not an industry standard.** For very small diffs, percentages are statistically unstable (one survivor swings 100%→50%) — prefer an **absolute survivor / regression policy** ("no reduction from baseline, no new undetected mutants in critical code") alongside the floor. (stryker-mutator.io/docs/*/configuration; pitest.org/faq; blog.pitest.org; research.google)

> **This repo's 90% threshold is *stricter* than the ecosystem's typical 60–80%.** That is a deliberate, legitimate choice, but it raises the bar for how much wall-clock the gate consumes. Keeping 90% is fine; the fix is to make the *compute* fit the gate via sharding + budget, and to add an escape hatch so a legitimately huge diff isn't blocked by wall-clock alone.

---

## Q4 — Timeouts, infinite-loop and flaky mutants

- **cargo-mutants:** `--timeout` is the per-mutant **test-command** ceiling (not per test case). A looping mutant is killed, recorded `timeout`, run continues; **any timeout → exit 3** (fails CI). Auto-timeout (baseline present, no explicit `--timeout`) = `max(5 × baseline test duration, 20s)`, floor tunable via `--minimum-test-timeout` / `CARGO_MUTANTS_MINIMUM_TEST_TIMEOUT`. `--timeout-multiplier` uses baseline timing and **cannot** be used with `--baseline=skip` or `--in-place` (fallback 300s if no explicit timeout). Build hangs are separate (`--build-timeout` / `--build-timeout-multiplier`; **no build timeout by default** in v27, because auto build-limits caused flaky failures under CPU contention). (mutants.rs/timeouts.html, exit-codes.html, changelog)
- **Best practice:** for a known-pathological function, **`#[mutants::skip]` or a narrow `exclude_re`** beats globally inflating every mutant's timeout — it bounds runtime *and* documents intent. (This repo already does exactly this for the `search_issues_with_fields` terminal-page `!`-deletion mutant in `.cargo/mutants.toml`.)
- **Ecosystem:** PIT/Stryker/mutmut all use adaptive `net-time × factor + constant`. **Stryker counts timeout as *detected*** (a real CI run would notice the hang); **cargo-mutants counts timeout as a distinct actionable failure (survived, exit 3)** — this repo's gate correctly treats timeout as *not caught*. Retry a timeout once in isolation to distinguish a flaky slow test from a genuine loop; quarantine flaky baseline tests rather than inflating every mutant. **Report timeout count separately** so a rising timeout count can't silently improve the score. Per-mutant timeout still allows `count × timeout` total, so an **outer wall-clock deadline + mutant-count cap** is still required. (pitest.org/faq; stryker mutant-states/metrics)

---

## Q5 — Runner sizing / cost tradeoffs

| Option | Best when | Pros | Cons |
|---|---|---|---|
| **Larger single runner, high tool concurrency** | CPU-bound tests, high build cost | one checkout/cache, simple report | memory/disk ceiling; nested test+compiler parallelism oversubscribes; **benchmark — speedup isn't linear** |
| **Multiple CI shards (recommended here)** | many independent mutants, PR latency matters | cuts critical-path wall time, isolates crashes | duplicates checkout/build/baseline per shard |
| **Hybrid: modest `--jobs 1–2` per shard** | large campaigns w/ enough RAM & CI concurrency | best latency/cost balance | tune two dims; N shards × NCPU test procs can overload shared services |
| **Self-hosted warm workers** | frequent runs, large builds, valuable caches | persistent caches, custom CPU/RAM/disk | fleet patching/security/autoscaling burden |
| **Managed larger GitHub runners** | bursty demand, ops simplicity | fast provisioning, no fleet mgmt | **faster ≠ cheaper** — billed by size × minutes; compare cost-per-completed-campaign |

For cargo-mutants specifically: **do not assume one worker per core** — each `cargo test` spawns many processes; high `--jobs` thrashes and each job needs its own multi-GB `target`. Favor **more isolated shards at `-j2`** over one high-`--jobs` machine. (mutants.rs/parallelism.html, build-dirs.html; docs.github.com/billing/reference/actions-runner-pricing)

---

## CONFIRMED vs UNVERIFIED (cargo-mutants version-specific)

**CONFIRMED against mutants.rs / changelog / repo (v27-applicable):** `--shard k/n` + `--sharding slice|round-robin` (slice default since v26); `--shard` combines with `--in-diff` and `--baseline skip`; 8–32 shards / ≥10 mutants-per-shard guidance; `--test-tool nextest` (no doctests, benchmark); `--baseline run|skip` (default `run`); `--in-diff` post-filter semantics + exit-5/6 pitfalls; `#[mutants::skip]` targets; `exclude_re`/`examine_re`/`exclude_globs`/`examine_globs`; **v27.0.0 CLI-filter combine-not-replace change**; `--jobs 2` default guidance + >8 warning + jobserver (test harness excluded); `--timeout` per-mutant, auto `max(5×baseline,20s)`, `--timeout-multiplier` incompatible with `skip`/`in-place`, no default build-timeout; exit codes 0/2/3/4/5/6/70; no built-in shard-merge; `outcomes.json` format unstable.

**UNVERIFIED / INCONCLUSIVE:** `--baseline=auto` (does **not** appear to exist — treat as non-existent); reliable skipping of `const`/`static` mutations in v27 (a fix is post-v27.1, unreleased); `previously_caught.txt`/`--iterate` as a general CI result cache; precise v27 handling of rename-only or combined/merge diffs; exact reflink-fallback behavior across filesystems. **Pinning `@27` (major only) permits behavior changes within 27.x** — for reproducible CI, pin an exact release (e.g. `@27.1.0`), especially since the gate parses `outcomes.json`.

---

## Recommended Approach for THIS Repo (ordered, concrete)

**Throughput math:** observed ~70 mutants/4h **with `--jobs 4`** ≈ **17.5 mutants/hr wall-clock**. 281 mutants ÷ 17.5 ≈ 16 h on one runner. To finish in ~1 h per shard: `N ≥ 281/17.5 ≈ 16`; in ~2 h: `N ≥ 8`. This matches the book's "8–32 shards" guidance. Each shard also pays a ~5-min startup (build ~195s + baseline), which `--baseline skip` + rust-cache mitigates.

### Step 1 — Shard the `mutants` job across a matrix (primary fix)
Replace the single `mutants` job with a matrix, keeping `--in-diff` and the existing `.cargo/mutants.toml` scope:

- `strategy: { fail-fast: false, matrix: { shard: [0..N-1] } }` — **start N=8**, raise to 12–16 if the 4h/story recurs. `fail-fast: false` is mandatory so every shard's report is produced.
- Per shard: compute the diff **identically** (`git diff origin/${{ github.base_ref }}...HEAD`, `fetch-depth: 0` — already present), then
  `cargo mutants --in-diff "$DIFF_FILE" --shard ${{ matrix.shard }}/N --sharding slice --jobs 2 --timeout 240 --baseline skip`
- **`--jobs 2`** (down from 4) — per Q1 guidance for 2–4 vCPU hosted runners; more shards beat higher `--jobs`.
- **`--baseline skip`** — legitimate because the required `test` job already proves the suite green; add `needs: [test]` to the shard job so a red suite blocks before mutation runs. Keeps `--timeout 240` explicit (required with `skip`).
- `timeout-minutes: ~60` per shard (not 240) — a stuck shard fails fast instead of tying up a required check for 4h.
- Keep `continue-on-error: true` on the run step; the aggregator is the arbiter.
- Upload each shard's `mutants.out` as a **uniquely-named artifact** (`mutants-shard-${{ matrix.shard }}`), `if: always()`.

### Step 2 — Add a final aggregator job (preserves the 90% threshold)
A new `mutants-aggregate` job, `needs: [<matrix job>]`, `if: always()`:
- Download all `mutants-shard-*` artifacts.
- **Assert all N artifacts are present** (missing shard = fail-closed; do not pass on partial data).
- **Sum** `caught`, `missed`, `timeout`, `unviable` across every shard's `outcomes.json` (reuse the existing jq logic — malformed-JSON guard, integer coercion, schema-drift guard, `total_mutants` reconciliation warning — all still apply per-file before summing).
- Compute one aggregate `kill_rate = caught*100 / (caught+missed+timeout)` and enforce **≥ 90%** exactly as today. **Sum, never average shard percentages.**
- Preserve the current zero-mutant / empty-diff / base-ref-drift handling: if *no* shard produced an `outcomes.json` and the overall diff was empty → fail (drift); non-empty diff, 0 mutants → pass.
- **Wire `ci-gate.needs` to the aggregator job, not the shard matrix** (the aggregator is the single pass/fail surface; matrix jobs are `continue-on-error`). This keeps the fail-closed `check-ci-gate.sh` contract intact — the aggregator replaces `mutants` in the `needs` list.

### Step 3 — Add a large-change escape hatch (removes the merge-blocking failure mode)
Before running shards, estimate the population with `cargo mutants --list --in-diff "$DIFF_FILE" | wc -l`:
- If ≤ a threshold (e.g. **~120 mutants** — comfortably fits N=8 shards in ~1h), run the blocking sharded gate as above.
- If **over** the threshold, either (a) auto-bump the shard count within a cost ceiling, or (b) emit a **neutral/"incomplete — escalated"** status (not a red fail) that directs the change to a **nightly full run** or merge-queue job, and require a human ack. This prevents "legitimately large diff" from being indistinguishable from "broken PR." Aligns with the ecosystem's change-size-bound + escalation pattern (Q2/Q3).

### Step 4 — Add a scheduled full (non-diff) run on `develop`
`--in-diff` is explicitly *not* a substitute for a full run (weakened coverage of *unchanged* code is invisible to it). Add a nightly/weekly `schedule:` job that runs the full `examine_globs` scope **without `--in-diff`**, heavily sharded, **non-blocking** (advisory), to catch coverage regressions the per-PR diff gate structurally cannot. (mutants.rs/in-diff.html)

### Step 5 — Bound the population (ongoing hygiene)
- Keep tightening `.cargo/mutants.toml` `examine_globs`/`exclude_re` and add `#[mutants::skip]` (with a documented reason) for any *new* pathological mutant, mirroring the existing terminal-page-`!` exclusion. Preview with `cargo mutants --list` in review.
- **Watch the v27.0.0 combine-not-replace precedence** if any invocation ever adds CLI `--exclude`/`--file` (it now *adds to* config, not *replaces*).

### Step 6 — Optional, measure-first
- **Pin `cargo-mutants@27.1.0`** exactly (not `@27`) since the gate parses `outcomes.json` — removes silent 27.x behavior/format drift risk.
- **Trial `--test-tool nextest`** on one shard and compare wall-clock; adopt only if faster for this suite (remember: no doctests under nextest).

### Tradeoffs
- **Sharding** cuts wall-clock ~N× but multiplies total billed CI minutes (each shard rebuilds; rust-cache + `--baseline skip` blunt this). For a 2–4 vCPU hosted fleet this is the right trade — latency/merge-throughput matters more than marginal minutes.
- **Aggregator complexity** — one more job + artifact plumbing, but it's the only way to keep the 90% *tolerance* (exit-code-only aggregation would force 100%-caught).
- **Escape hatch** — introduces a policy surface (neutral status + human ack) but removes the "huge legitimate diff blocks merge on wall-clock" failure that triggered this research.
- **Nightly full run** — extra scheduled compute, but restores the coverage guarantee `--in-diff` alone cannot provide.

---

## Sources (primary docs preferred)

- cargo-mutants book: shards.html, in-diff.html, pr-diff.html, nextest.html, baseline.html, timeouts.html, exit-codes.html, parallelism.html, jobserver.html, filter_mutants.html, skip_files.html, attrs.html, how-it-works.html, in-place.html, iterate.html, mutants-out.html, changelog.html — https://mutants.rs/
- sourcefrog/cargo-mutants (repo, releases, CI workflow `.github/workflows/tests.yml`) — https://github.com/sourcefrog/cargo-mutants
- pitest incremental analysis + faq — https://pitest.org/quickstart/incremental_analysis/ , https://pitest.org/faq/ ; blog.pitest.org "don't let your code dry"
- StrykerJS incremental — https://stryker-mutator.io/docs/stryker-js/incremental/ ; Stryker.NET config (`--since`/`--with-baseline`) — https://stryker-mutator.io/docs/stryker-net/configuration/ ; mutant states/metrics — https://stryker-mutator.io/docs/mutation-testing-elements/mutant-states-and-metrics/
- mutmut docs — https://mutmut.readthedocs.io/
- Google "Practical Mutation Testing at Scale" — https://research.google/pubs/practical-mutation-testing-at-scale-a-view-from-google/ ; testing.googleblog.com/2021/04/mutation-testing.html
- GitHub Actions runner pricing / caching / read-only cache for untrusted triggers — https://docs.github.com/en/billing/reference/actions-runner-pricing , https://docs.github.com/en/actions/reference/workflows-and-actions/dependency-caching

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 2 | (1) cargo-mutants v27 scaling features verified against mutants.rs/GitHub; (2) ecosystem-wide CI mutation strategy for large changes (PIT/Stryker/mutmut/Google), gate design, timeouts, runner sizing |
| WebFetch | 2 | Direct fetch of mutants.rs/shards.html to verify shard syntax, partitioning, aggregation, `--in-diff`/`--baseline skip` combination, and shard-sizing recommendation |
| Read | 2 | This repo's `.cargo/mutants.toml` and `.github/workflows/ci.yml` to ground recommendations in the actual current config/gate |

**Total MCP tool calls:** 2 (both `perplexity_research`)
**Training data reliance:** low — all cargo-mutants feature/version claims are sourced to mutants.rs / changelog / repo and cross-checked with a direct doc fetch; version-specific uncertainties are explicitly flagged CONFIRMED vs UNVERIFIED. Repo-specific recommendations are grounded in the actual `ci.yml`/`mutants.toml` read this session.
