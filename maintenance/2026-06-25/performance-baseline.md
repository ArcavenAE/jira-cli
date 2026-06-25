---
sweep: 6
date: 2026-06-25
commit: b856f9f
branch: develop
baseline_status: ESTABLISHED
prior_baseline: .factory/maintenance/2026-06-22/performance-baseline.md
---

# Performance Baseline — Maintenance Sweep 6

Recorded: 2026-06-25
Commit: `b856f9f` — `chore(deps): bump actions/checkout from 6.0.3 to 7.0.0 (#550)`
Branch: `develop`

## Hardware / Toolchain Context

| Property | Value |
|---|---|
| CPU | Apple M3 Max |
| Logical cores | 16 |
| RAM | 128 GB |
| OS | macOS (Darwin 25.5.0) |
| Rust | 1.96.0 (ac68faa20 2026-05-25) |
| Cargo | 1.96.0 (30a34c682 2026-05-25) |

## Measurement Infrastructure

| Tool | Available | Notes |
|---|---|---|
| `hyperfine` | NO | Not on PATH — using Python `time.perf_counter` loop |
| Python timing loop | YES | 20 runs + 3 warmup runs, sub-ms precision via `time.perf_counter` |

## Measured Metrics

### 1. Binary Size

| Metric | Value |
|---|---|
| Binary path | `target/release/jr` |
| Size (bytes) | 7,436,640 |
| Size (human) | 7.09 MB |

### 2. Startup Latency (`jr --help`)

Method: Python `subprocess` + `time.perf_counter`, 3 warmup runs discarded, 20 measurement runs, results sorted.

| Stat | Value |
|---|---|
| mean | 6.4 ms |
| p50 (median) | 6.4 ms |
| p95 | 7.8 ms |
| p99 | 7.8 ms |
| min | 5.5 ms |
| max | 7.8 ms |

### 3. Startup Latency (`jr --version`)

| Stat | Value |
|---|---|
| mean | 6.0 ms |
| p50 (median) | 6.1 ms |
| p95 | 7.0 ms |
| p99 | 7.0 ms |
| min | 5.2 ms |
| max | 7.0 ms |

### 4. Incremental Release Build Time

Method: `touch src/main.rs && cargo build --release` (single-crate recompile with deps cached).

| Metric | Value |
|---|---|
| Wall-clock time | 36.1 s |
| Crates recompiled | `jr` only |

This isolates pure `jr`-crate compile time. The 2026-06-22 baseline (61.3 s) included dep churn
(4 non-`jr` crates recompiling), so these figures are not directly comparable. The pure-`jr`
single-crate time was not measured on 2026-06-22, so it is recorded here as a new baseline datapoint.

---

## Regression Comparison Table

Thresholds: WARNING = >10% regression, CRITICAL = >25% regression.

| Metric | 2026-06-22 Baseline | 2026-06-25 Measured | Delta % | Status |
|---|---|---|---|---|
| Binary size (bytes) | 7,436,640 | 7,436,640 | **0.0%** | PASS |
| `jr --help` p50 latency | 8 ms | 6.4 ms | **-20.0%** | PASS (improvement) |
| `jr --help` p95 latency | 9 ms | 7.8 ms | **-13.3%** | PASS (improvement) |
| `jr --version` p50 latency | — (not measured) | 6.1 ms | — | NEW DATAPOINT |
| Incremental build (jr-only) | — (not isolated) | 36.1 s | — | NEW DATAPOINT |

**Notes on latency delta:**

The 2026-06-22 baseline was measured using `bash date +%s%N` (millisecond precision, single runs
with one warmup discarded). The 2026-06-25 measurement used Python `time.perf_counter` with 20
runs and 3 warmup runs, which is a more statistically robust method. The apparent improvement
(8 ms → 6.4 ms p50) is likely attributable to:

1. Better measurement methodology (20-run statistics vs single-run estimates)
2. OS file-cache and dyld cache already warm from the build step
3. The 2026-06-22 measurement explicitly discarded the first "warm-up" run which was 11 ms,
   elevating the median

There is **no regression signal** — both methods agree startup is in the 6–9 ms range on this
hardware. The new p50 of 6.4 ms is the better-characterized reference figure going forward.

---

## Regression Flags

None. No regressions detected.

- Binary size: **identical** byte-for-byte (7,436,640 bytes, 0.0% delta).
- Startup latency: **improved** under the more robust measurement method.
- No WARNING or CRITICAL flags triggered.

---

## VERDICT

**PASS — No performance regressions detected.**

Binary size is stable at 7.1 MB (0% change from the 2026-06-22 baseline). Startup latency is
6.4 ms p50 / 7.8 ms p95 for `jr --help`, within the established 8 ms p50 baseline and well
below the 10% warning threshold (8.8 ms). The CLI remains fast for a thin-client Rust binary
of this scope.

Updated baseline thresholds for next sweep:

| Metric | New Baseline | Warn (>10%) | Critical (>25%) |
|---|---|---|---|
| Binary size | 7,436,640 bytes | > 8.18 MB | > 9.30 MB |
| `jr --help` p50 latency | 6.4 ms | > 7.0 ms | > 8.0 ms |
| `jr --help` p95 latency | 7.8 ms | > 8.6 ms | > 9.8 ms |
| `jr --version` p50 latency | 6.1 ms | > 6.7 ms | > 7.6 ms |
| Incremental build (jr-only) | 36.1 s | > 39.7 s | > 45.1 s |

---

## Methodology Notes

- Startup latency: Python `time.perf_counter` in a subprocess loop, 3 warmup runs, 20 measured
  runs, sorted for percentile extraction. Sub-ms precision. Preferred over `date +%s%N` (ms
  resolution) and bash loops. **Install `hyperfine` (`brew install hyperfine`) for future
  sweeps** to get automated outlier detection, mean/stddev, and cross-run reproducibility
  reporting.
- Binary size: stripped release binary (`strip = true` in `[profile.release]`).
- Incremental build: `touch src/main.rs && cargo build --release` — forces `jr` crate recompile
  with all deps cached. Previous sweep measured full build with dep churn (not comparable).
- Measurement machine: Apple M3 Max, 128 GB RAM. Results are machine-specific; absolute values
  are only meaningful for regression detection on the same hardware.
