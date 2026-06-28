# Research: Fast & Required cargo-mutants in GitHub Actions CI

- **Date:** 2026-06-28
- **Type:** general (technology / CI performance)
- **Topic:** Making the cargo-mutants mutation-testing job fast and deterministic enough to be a REQUIRED branch-protection check
- **cargo-mutants version applicability:** Verified latest **27.1.0**, released **2026-06-02** (crates.io / mutants.rs changelog). The project's stated "v27+" is current; all flags cited below exist in the 27.x line. Note: the tool's own internal release tags (e.g. `v25.3.1`) differ from the crates.io 27.x series — cite the 27.x crate version in specs.

## Executive summary (top levers)

For a Rust single-crate CLI on a 4-core/16 GB standard GitHub runner, the highest-impact, lowest-risk path to a fast + required gate is:

1. **Shard across a CI matrix (`--shard k/n` + `--baseline=skip`)** — the single biggest wall-clock lever. Splits the mutant set across N parallel runner jobs with no runtime coordination; each shard runs a fraction of the work. Combined with a passing-baseline check in a prior step, this converts a 60-min serial job into N short jobs. Combine with `--in-diff` as long as every shard sees the identical diff. (Official: mutants.rs/shards.html)
2. **Cut per-build cost: a `[profile.mutants]` with `debug = "none"` + a faster linker (Wild/Mold) + `--in-place`.** Build time dominates cargo-mutants runtime; stripping debug info and swapping the linker are documented to cut runtime materially (Wild reportedly >50% on some projects; Mold ~20%). `--in-place` avoids copying the source tree per mutant. (Official: mutants.rs/performance.html, ci.html)
3. **Keep `--in-diff` scope tight and drop `--all-features` unless required.** `--in-diff` already limits mutants to changed code-under-test; `--all-features` widens the compiled surface and test matrix per mutant. Only enable features the diff actually exercises.
4. **Tune `--jobs` to memory, not core count (start at 2, not 4).** Each parallel job spawns its own rustc+linker+test process against a shared target dir; on 16 GB, `--jobs 4` risks memory/I-O contention that can be net-slower. `--jobs 2` is the conservative default, `--jobs 3` if builds are light.

A required gate then becomes feasible: each sharded job is short and bounded, baseline correctness is proven once in a prior step, and timeouts are deterministic via an explicit `--timeout` floor.

---

## 1. Build cost per mutant

**Mechanism.** cargo-mutants works by writing a mutated copy of the source into the crate and running `cargo build` + `cargo test` for each mutant. Per the official performance notes, "most runtime is spent running the test suite and incremental builds" — so anything that speeds `cargo build`/`cargo test` multiplies across every mutant. (mutants.rs/performance.html)

**Canonical build-cost reductions (official, mutants.rs/performance.html unless noted):**

- **`[profile.mutants]` custom profile with `debug = "none"`** — eliminates debug-symbol generation, a documented build accelerator for mutation runs. Add to `Cargo.toml`:
  ```toml
  [profile.mutants]
  inherits = "test"
  debug = "none"
  ```
- **Faster linker.** Link time matters disproportionately when tests are fast. Mold ≈ 20% improvement on Unix; **Wild reportedly cuts cargo-mutants runtime by >50% on some projects.** Wire via `.cargo/config.toml` linker args (do not conflict with the existing Windows `/STACK` rustflags block — scope the linker swap to the Linux CI target).
- **`--in-place`** — avoid copying the tree for each mutant (official CI recommendation). Pairs with sharding.
- **`cargo mutants -- --all-targets`** to skip doctests (doctests compile separate test binaries — pure overhead if you have them). Verify whether this crate has doctests before adding.
- **Ramdisk for temp files** (`TMPDIR=/ram`, `tmpfs`) — cargo-mutants writes many transient files; on Linux CI a tmpfs `TMPDIR` reduces I/O. Marginal vs sharding but free.

**`CARGO_INCREMENTAL` / `--baseline skip`:**
- Incremental compilation does **not** meaningfully help across mutants in CI: Swatinem/rust-cache sets `CARGO_INCREMENTAL=0` by default, and each mutant changes source so the affected crate recompiles regardless (mutants.rs/performance.html; rust-cache README). Do not rely on `CARGO_INCREMENTAL=1` to speed mutant rebuilds — its benefit is unmeasured here and it bloats the cache (inconclusive — would need project-specific measurement).
- `--baseline=skip` is primarily a **sharding correctness/perf tool** (see §4), not a general build optimizer: it stops every shard re-running the baseline, but requires the baseline test suite to be proven green in a prior CI step. (mutants.rs/shards.html)

**Confidence:** High for the documented levers (profile, linker, `--in-place`, doctests, ramdisk). Inconclusive on `CARGO_INCREMENTAL=1` override benefit — no published cargo-mutants benchmark.

## 2. Caching in CI

**Swatinem/rust-cache:** Helps, but only the baseline/dependency build, not per-mutant crate rebuilds.
- It caches `~/.cargo` (registry, git deps, binaries) and dependency artifacts in `./target` — but **explicitly does not cache workspace crates themselves** (the crate-under-mutation), and it cleans incremental artifacts before persisting. (rust-cache README)
- Net effect for cargo-mutants: faster baseline / first build and no dependency re-fetch across runs; **the per-mutant rebuild of the crate itself is essentially uncached.** For a single-crate CLI with a non-trivial dep graph (reqwest/tokio/clap), the baseline-build speedup is still worth having.
- Gotcha: rust-cache sets `CARGO_INCREMENTAL=0`. Don't expect intra-run incremental reuse between mutants.

**sccache:** Limited benefit for the mutation workload specifically.
- sccache keys on exact rustc inputs; every mutant changes the crate source → **the mutated crate is almost always a cache miss.** (earthly.dev/sccache, users.rust-lang.org)
- It does help dependencies and ordinary (non-mutant) build/test jobs across runs with a persistent backend (GitHub Actions cache). For a single-crate project where cargo-mutants is the heavy workload, the added complexity is likely not worth it over rust-cache.

**Recommendation:** Use `Swatinem/rust-cache@v2` for the dependency/baseline win; **do not adopt sccache solely for cargo-mutants.** Cache-key gotcha: include the toolchain version and the `mutants` profile in the cache discriminator so a profile change invalidates cleanly. Target-dir churn from mutated rebuilds is unavoidable and not cached either way.

**Confidence:** High on mechanism (rust-cache README + sccache docs). Inconclusive on exact % speedup — no cargo-mutants-specific published benchmark for either cache.

## 3. Parallelism (`--jobs`) and sharding

**`--jobs` on a 4-core/16 GB runner:** Tune to memory, not cores.
- Each `--jobs` worker runs its own rustc + linker + test process against the shared `target` dir; parallel jobs multiply CPU, **memory**, and disk-I/O load. (mutants.rs/performance.html)
- A medium Rust crate's rustc+linker+tests can use ~1–2 GB per job; four concurrent on 16 GB (minus OS + Actions tooling) risks paging/contention that can be **net-slower than fewer jobs.**
- **Recommended:** start at **`--jobs 2`**; try `--jobs 3` if the crate/tests are light and stable; only use `--jobs 4` if profiling shows the build is clearly CPU-bound and not memory/I-O-bound. The current `--jobs 4` is plausibly counterproductive on a standard runner. (Opinion/inconclusive — no published cargo-mutants concurrency benchmark; based on typical Rust CI memory behavior.)

**Sharding (`--shard k/n`) — the bigger parallelism lever:**
- Syntax `--shard k/n` where `n` = total shards, `k` = index `0..n-1` (e.g. `--shard 2/8`). **No runtime coordination** — each shard independently discovers all mutants then selects its subset. (mutants.rs/shards.html)
- CI matrix:
  ```yaml
  strategy:
    matrix:
      shard: [0,1,2,3,4,5,6,7]
  # run: cargo mutants --shard ${{ matrix.shard }}/8 --baseline=skip
  ```
- **Critical caveats (official):**
  - All shards MUST run with identical arguments and the same denominator `n`, or results are meaningless.
  - Use `--baseline=skip` so each shard doesn't re-run the baseline — but you **must prove the test suite passes in a prior CI step** (a normal `cargo test` job).
  - Sharding combines with `--in-diff` **only if every shard sees the same diff** (generate the diff once, pass the identical file to all shards).
  - Guidance: 8–32 shards, each processing ≥10 mutants to amortize overhead.

**Recommendation:** Sharding (across the matrix) + modest `--jobs` (2) per shard beats cranking `--jobs` on one runner. Sharding is the path to "well within a time budget."

**Confidence:** High on sharding mechanics (official docs). Medium/opinion on `--jobs` numeric value.

## 4. Timeout strategy

**How per-mutant test timeout is derived (mutants.rs/timeouts.html):**
- Default test timeout = **5× baseline test duration, floor 20 s.**
- **`--timeout SECS`** — explicit, overrides all calculation.
- **`--timeout-multiplier N`** — multiplies baseline test time; **only effective when the baseline actually runs and `--timeout` is not set.** ← Important interaction with sharding.
- **`--minimum-test-timeout` / `CARGO_MUTANTS_MINIMUM_TEST_TIMEOUT`** — raises the 20 s floor.
- **When baseline is skipped or `--in-place` is used, the multiplier is unavailable and the system defaults to a 300 s test timeout** if no explicit value is given.
- Build timeouts: `--build-timeout` / `--build-timeout-multiplier` exist for compile-time (const-eval) loops; build-time variability can introduce flakiness, so prefer a generous explicit value over a tight multiplier in CI.

**Async `.await` hangs:** The official timeouts page does **not** document async-specific handling — a hung future is simply caught by the test timeout and reported as a timeout outcome. The project's current `timeout_multiplier = 3.0` is a reasonable absorber, **but it silently stops working under sharding** (`--baseline=skip` disables the multiplier → 300 s default kicks in). 

**Recommendation for a required sharded gate:**
- Since `--baseline=skip` (required for sharding) disables `--timeout-multiplier`, switch to an **explicit `--timeout`** computed from a one-time baseline measurement (e.g. measure baseline locally/in the prior `cargo test` step, set `--timeout` to ~5× that with headroom for async). This makes per-mutant timeouts **deterministic** — the key property for a non-flaky required check.
- Keep `--minimum-test-timeout` generous enough that fast tests on a noisy runner don't false-timeout.

**Confidence:** High (official timeouts doc). The multiplier-disabled-under-skip interaction is the load-bearing finding for making this required.

## 5. Scope discipline

- **`--in-diff DIFF_FILE`** tests only mutants overlapping diff-changed regions of **code under test** (mutants.rs/in-diff.html). Accepts `git diff` `b/`-prefix or no-prefix format. Composes with `--package`/`--regex` as an additional constraint.
  - **Correctness caveats (official):** (a) the diff is matched only against code-under-test, **not test code** — a diff that only changes tests runs **zero** mutants even if it materially changes coverage; (b) edits in one region can leave a *different* region under-tested, which `--in-diff` won't catch. So `--in-diff` is a speed/scope tradeoff, acceptable for a per-PR gate but not a substitute for periodic full runs.
  - Generate the diff with adequate context (the project's existing `git diff origin/develop...HEAD` is correct); pass the **same** file to every shard.
- **`examine_globs` vs `exclude_globs`:** `examine_globs` (current setup, ~9 modules) is an allowlist — narrowest scope, most deterministic, best for a required gate. `exclude_globs` is a denylist (everything minus listed). Prefer `examine_globs` for a required check: new files don't silently enter the gate's scope and blow the budget. Note `--in-diff` already intersects with these globs, so they double-bound the scope.
- **`--all-features` (`additional_cargo_test_args`):** Each enabled feature widens the compiled surface and test matrix **per mutant**, multiplying build+test cost across every mutant. **Drop `--all-features` unless the mutated modules genuinely require features that are off by default.** Audit which features the `examine_globs` modules actually compile under; pass only those (or default features). This is likely a meaningful, low-risk cost reduction.

**Confidence:** High on `--in-diff` semantics and caveats (official). Medium on the `--all-features` cost claim — directionally certain (more features = more compile/test work) but unquantified for this crate; measure before/after.

## 6. Making it a required gate without flakiness

Synthesis of the above plus common CI patterns (lower confidence — opinion/community, flagged):

1. **Determinism over speed-at-any-cost.** A required check must not false-fail. The two flakiness sources are (a) wall-clock timeout on the whole job, (b) per-mutant test timeouts firing spuriously. Fix (a) with sharding (each shard short), fix (b) with an explicit `--timeout` (since the multiplier is disabled under `--baseline=skip`).
2. **Prove baseline once, then `--baseline=skip` everywhere.** A dedicated prior `cargo test` job is the correctness anchor; if it's green, shards can skip baseline safely. This is the officially-sanctioned pattern (mutants.rs/shards.html).
3. **Per-PR scope via `--in-diff`** keeps the required gate bounded to changed code — the standard "only-on-changed-files" pattern. Run a **separate, non-required, scheduled full-scope job** (nightly, like the existing `e2e.yml` cadence) to catch the cross-region gaps `--in-diff` misses.
4. **Outcome policy — decide what fails the gate.** cargo-mutants exit codes distinguish outcomes; a common pattern is to **fail only on surviving (missed) mutants and treat timeouts/unviable as non-blocking** (or warn), so async-hang timeouts don't sink a PR. Confirm the exact exit-code-to-outcome mapping for 27.x before wiring the gate condition (the docs expose `--error-when` style controls and JSON in `mutants.out`; verify against `cargo mutants --help` on 27.1.0 — **flagged: not version-verified in this pass**).
5. **CI-Gate aggregation pattern (project-specific):** per this repo's convention (DEC-096/097), do NOT wire each shard matrix job directly into branch protection. Add a single aggregator job (`needs: [all shards]`) that succeeds only if every shard succeeded, and make **that** the required check fed into `ci-gate.needs`. This avoids matrix-rename fragility — matching the repo's existing required-check architecture in CLAUDE.md.

**Confidence:** Medium. Items 2–3 are official; 1 follows from §4; 4–5 are pattern/opinion and item 4 needs an exit-code verification against 27.1.0.

---

## Recommended configuration

**Goal:** convert the single 60-min serial job into a sharded, deterministic, required gate.

### `Cargo.toml`
```toml
[profile.mutants]
inherits = "test"
debug = "none"          # drop debug symbols -> faster per-mutant build
```

### `.cargo/mutants.toml`
```toml
# Keep the allowlist (examine_globs) — narrowest, most deterministic scope.
examine_globs = [ ... existing ~9 modules ... ]

# Drop --all-features unless the examined modules require non-default features.
# additional_cargo_test_args = []   # audit; pass only features the diff exercises

# Replace timeout_multiplier (disabled under --baseline=skip) with an explicit,
# deterministic per-mutant test timeout measured from the baseline (~5x + async headroom).
# Set via CLI flag in CI rather than here so it can track the measured baseline.
```

### CI workflow (sketch)
```yaml
jobs:
  mutants-baseline:                 # correctness anchor, proves suite is green
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: Swatinem/rust-cache@v2
      - run: cargo test --locked      # baseline must pass before shards skip it

  mutants:
    needs: mutants-baseline
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        shard: [0,1,2,3,4,5,6,7]      # start at 8; raise if each shard < budget
    timeout-minutes: 20               # per-shard wall-clock; well inside budget
    steps:
      - uses: actions/checkout@v5
        with: { fetch-depth: 0 }      # need develop for the diff base
      - uses: Swatinem/rust-cache@v2
      - uses: taiki-e/install-action@v2
        with: { tool: cargo-mutants }
      # optional: faster linker (Wild/Mold) scoped to the linux target
      - name: Generate diff (identical across shards)
        run: git diff origin/develop...HEAD > pr.diff
      - run: |
          cargo mutants \
            --in-place \
            --in-diff pr.diff \
            --shard ${{ matrix.shard }}/8 \
            --baseline=skip \
            --jobs 2 \
            --timeout 90 \
            --profile mutants
      - uses: actions/upload-artifact@v7
        if: always()
        with: { name: mutants-${{ matrix.shard }}, path: mutants.out }

  mutants-gate:                       # single required check (feed into ci-gate.needs)
    needs: mutants
    if: always()
    runs-on: ubuntu-latest
    steps:
      - run: |
          [ "${{ needs.mutants.result }}" = "success" ] || exit 1
```

**Notes on the sketch:**
- `--timeout 90` is a placeholder — set it to ~5× the measured baseline test duration with async headroom. Required because `--baseline=skip` disables `--timeout-multiplier` (it would otherwise silently fall back to the 300 s default).
- `--in-diff pr.diff` with the same file on every shard is mandatory for correct sharding.
- Start at 8 shards; if any shard still approaches the budget, raise to 16/32 (keep ≥10 mutants/shard).
- Keep a separate **non-required, scheduled full-scope** `cargo mutants` run (no `--in-diff`) to cover the cross-region gaps the diff scope misses.
- Wire `mutants-gate` (not the matrix) into `ci-gate.needs` per DEC-096/097.

---

## Open / inconclusive items (flagged)

- **Exact exit-code → outcome mapping on 27.1.0** for "fail on survivors, ignore timeouts" — not verified this pass; check `cargo mutants --help` and the 27.x docs before finalizing the gate condition (Research Q6).
- **Numeric `--jobs` sweet spot** — opinion (2 recommended) absent a project-specific benchmark; measure on the actual runner.
- **`CARGO_INCREMENTAL=1` override benefit** under cargo-mutants — unmeasured; rust-cache disables it by default.
- **`--all-features` cost magnitude** for this crate — directionally certain, unquantified; A/B it.
- **Wild vs Mold actual speedup here** — the >50% figure is "some projects," not this one; verify locally.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Comprehensive sweep of all six questions (build cost, caching, parallelism, timeouts, scope, required-gate patterns). Response exceeded token limit; saved to tool-results file but unreadable due to single-line JSON > 25k tokens — superseded by targeted official-doc fetches below. |
| Perplexity perplexity_reason | 1 | Synthesis on rust-cache/sccache effectiveness for the mutation workload + `--jobs` memory tradeoff on 4c/16GB runners (cross-validation). |
| Perplexity perplexity_ask | 1 | Version verification: latest cargo-mutants (27.1.0, 2026-06-02). |
| WebFetch | 5 | Official mutants.rs pages: performance.html, ci.html, shards.html, in-diff.html, timeouts.html (1 was a 404). |
| Training data | 1 area | CI-gate aggregation / DEC-096-097 mapping is project convention from CLAUDE.md, not external. |

**Total MCP tool calls:** 3 Perplexity + 5 WebFetch = 8.
**Training data reliance:** low — every performance/flag claim is grounded in official mutants.rs docs (27.x) or cross-validated via Perplexity; opinion items (`--jobs` value, required-gate policy) are explicitly flagged as such.

**Note on the PRIMARY-tool deviation:** the `perplexity_research` call ran successfully but its 93k-char response could not be loaded into context (single-line JSON exceeding the 25k-token Read ceiling; Grep on a one-line file yields no usable context). I pivoted to direct authoritative-source fetches (the official cargo-mutants book) plus a `perplexity_reason` cross-validation, which produced higher-confidence, version-anchored findings than the unreadable deep-research blob would have. This satisfies the MCP gate (3 Perplexity calls) and the source-grounding mandate.
