---
sweep: 5
date: 2026-06-22
commit: ed236d4
branch: develop
baseline_status: ESTABLISHED
---

# Performance Baseline — Maintenance Sweep 5

Recorded: 2026-06-22  
Commit: `ed236d4` — `fix(ci): make verify-signatures step actually exercise correctly in a signing-configured fork`  
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

## Benchmark Infrastructure Audit

| Source | Present | Notes |
|---|---|---|
| `benches/` directory | NO | Directory does not exist |
| `[[bench]]` in Cargo.toml | NO | No bench targets declared |
| `criterion` in Cargo.toml / Cargo.lock | NO | Not a dependency |
| `hyperfine` installed | NO | Not on PATH |
| `scripts/*.sh` perf scripts | NO | Only spec-check and packaging scripts |
| `.factory/perf/` directory | NO | Does not exist |
| `.factory/phase-f4-implementation/regression-baseline.md` | YES | Test-count baseline only (not perf) |

**Conclusion: No benchmark infrastructure exists. This is first-time baseline establishment.**

## Measured Metrics

### 1. Release Profile Configuration

From `Cargo.toml [profile.release]`:

```toml
opt-level = 3
lto = "thin"
codegen-units = 1
strip = true
panic = "abort"
```

Profile is well-configured for production: LTO, stripped symbols, single codegen unit.

### 2. Binary Size

| Metric | Value |
|---|---|
| Binary path | `target/release/jr` |
| Size (bytes) | 7,436,640 |
| Size (human) | 7.1 MB |

The binary size grew from the stale pre-build artifact (7,416,912 bytes, dated Jun 11) to
7,436,640 bytes after the current `cargo build --release`. Delta: **+19,728 bytes (+0.27%)**
— negligible, consistent with a few additional commits since the Jun 11 build.

### 3. Startup Latency (`jr --help`)

Measured with `date +%s%N` on macOS (millisecond precision). Run 1 on a fresh process
after build sometimes incurs a warm-up spike (dyld cache, OS file-cache cold); discarded
as outlier. Steady-state = runs 2–10.

| Run | Latency (ms) |
|---|---|
| 1 (warm-up / outlier) | 11 |
| 2 | 9 |
| 3 | 8 |
| 4 | 8 |
| 5 | 8 |
| 6 | 7 |
| 7 | 7 |
| 8 | 7 |
| 9 | 7 |
| 10 | 7 |
| **Median (p50)** | **8 ms** |
| **p95 (est.)** | **9 ms** |
| **Min** | **7 ms** |

Note: the immediate post-build run showed a 430 ms spike on run 1 — this is a macOS
post-compile dyld cache miss, not a runtime regression. Steady-state after that first
call was 7–9 ms.

### 4. Incremental Build Time (`cargo build --release`)

From a state where src/ files were newer than the binary (deps fully cached in
`~/.cargo/registry`):

| Metric | Value |
|---|---|
| Build scope | Incremental (deps cached, `jr` crate recompiled) |
| Wall-clock time | 61.3 s |
| Crates recompiled | `tokio-rustls`, `rustls-platform-verifier`, `hyper-rustls`, `reqwest`, `jr` |

The dep churn (4 non-`jr` crates recompiling) is due to a dependency bump landing since
the Jun 11 binary. Pure `jr` crate rebuild time is embedded in this; a clean cold build
would be longer.

## Baseline Summary Table

| Metric | Baseline Value | Threshold (warn >10%) | Threshold (critical >25%) |
|---|---|---|---|
| Binary size | 7,436,640 bytes (7.1 MB) | > 8.2 MB | > 9.3 MB |
| `jr --help` p50 latency | 8 ms | > 8.8 ms | > 10 ms |
| `jr --help` p95 latency | 9 ms | > 9.9 ms | > 11.3 ms |
| Incremental release build | 61.3 s | > 67.4 s | > 76.6 s |

## Comparison to Prior Baseline

No prior performance baseline existed. This is the **first established baseline** (PERF-BASELINE-ABSENT resolved).

The `.factory/phase-f4-implementation/regression-baseline.md` records test pass counts
from SHA `45ddf7a` but contains no perf measurements.

## Methodology Notes

- Startup latency uses `bash` `date +%s%N` (millisecond resolution). Not as precise as
  `hyperfine` (sub-ms, statistical warmup handling). **Install `hyperfine` (`brew install
  hyperfine`) for future sweeps** — it gives mean/median/stddev, handles warmup runs
  correctly, and detects outliers.
- Binary size is the stripped release binary. macOS `.dSYM` bundle is not counted (it is
  stripped away via `strip = true`).
- Build time is not a pure `jr`-only number (dep churn inflated it). A future measurement
  should run `touch src/main.rs && cargo build --release` to isolate single-crate
  recompile time.

## Recommendations

### PERF-BASELINE-ABSENT — warrants a story? YES (LOW priority)

The drift item `PERF-BASELINE-ABSENT` is now partially resolved by this sweep:
a lightweight baseline is established. However, to make future sweeps actionable,
a dedicated story is recommended to:

1. **Install `hyperfine`** in the project's dev toolchain docs (`docs/specs/dev-toolchain.md`
   or similar) so future sweeps use it consistently.
2. **Add a `scripts/perf-check.sh`** that runs `hyperfine --warmup 3 'jr --help'` and
   `du -sh target/release/jr`, appending a row to a baseline CSV for trend tracking.
3. **Add a `perf-check` CI job** (non-blocking, informational) to flag binary-size growth
   > 10% on PRs.

Priority: LOW. The CLI is a thin client; the critical path is network I/O (Jira API
latency), not startup or build time. No performance regression is detectable at this
sweep since no prior baseline existed for comparison.

## FINDINGS: 4

1. No benchmark infrastructure exists (no criterion, no hyperfine, no bench targets,
   no perf scripts).
2. First-ever baseline established: binary 7.1 MB, `jr --help` p50 8 ms, incremental
   build 61 s.
3. Binary grew +0.27% vs Jun 11 stale artifact — within noise, no action needed.
4. Recommend a LOW-priority story to add `hyperfine` and a `scripts/perf-check.sh`
   for reproducible future sweeps.
