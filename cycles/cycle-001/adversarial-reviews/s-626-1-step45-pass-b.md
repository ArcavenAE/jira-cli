---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: consistency-validator
timestamp: 2026-07-30T00:00:00
phase: 5
inputs:
  - .github/workflows/ci.yml
  - .github/workflows/release.yml
  - .github/workflows/e2e.yml
  - .github/workflows/e2e-sweeper.yml
  - .github/workflows/sign-and-publish.yml
  - .github/workflows/backfill-release.yml
  - rust-toolchain.toml
  - Cargo.toml
  - Cargo.lock
  - CHANGELOG.md
input-hash: "f443134"
traces_to: S-626-1.md
pass: B
previous_review: s-626-1-step45-pass-a.md
story: S-626-1
step: 4.5
aperture: ci-correctness / msrv-truth
date: 2026-07-30
basis: DEC-190 substitute (consistency-validator, not adversary agent)
isolation: sibling reviews not read
---

# Adversarial Review: S-626-1 CI Fix (Pass B — CI-Correctness / MSRV-Truth Aperture)

## Finding ID Convention

Finding IDs use the format: `ADV-P<PASS>-<SEV>-<SEQ>` (no cycle prefix — no current-cycle file present).

- `ADV`: Fixed prefix
- `<PASS>`: Pass identifier (PB for this pass B)
- `<SEV>`: Severity abbreviation (`CRIT`, `HIGH`, `MED`, `LOW`, `INFO`)
- `<SEQ>`: Three-digit sequence

## Aperture

Will the CI now actually verify what it claims, and is the declared MSRV genuinely true? Not "do the files look right" — will the job *fail* if the MSRV is violated again.

## Files Reviewed

- `.github/workflows/ci.yml`
- `.github/workflows/release.yml`
- `.github/workflows/e2e.yml`
- `.github/workflows/e2e-sweeper.yml`
- `.github/workflows/sign-and-publish.yml`
- `.github/workflows/backfill-release.yml`
- `rust-toolchain.toml`
- `Cargo.toml`
- `Cargo.lock`
- `CHANGELOG.md`
- `CLAUDE.md` (gotcha line 218)
- `.factory/stories/S-626-1.md` (scope / AC-9 documentation)

## SHA Enumeration Table (Item 4)

Old SHA (`c93f4f9c67595668add93d3d6895795ce52d8c2d`): **0 occurrences** (grep verified across `.github/`)

New SHA (`fa04a1451ff1842e2626ccb99004d0195b455a88`): **7 occurrences across 6 files**

| File | Count | Line(s) | Trailing comment |
|------|-------|---------|-----------------|
| `.github/workflows/ci.yml` | 2 | 70, 102 | `# 1.85.0`, `# stable` |
| `.github/workflows/release.yml` | 1 | 38 | `# stable` |
| `.github/workflows/e2e-sweeper.yml` | 1 | 74 | `# stable` |
| `.github/workflows/sign-and-publish.yml` | 1 | 53 | `# stable` |
| `.github/workflows/backfill-release.yml` | 1 | 68 | `# stable` |
| `.github/workflows/e2e.yml` | 1 | 80 | `# stable` |

Total: 7 across 6 files. Matches story claim exactly.

## Checklist Coverage

**Item 1 — Does the msrv job now genuinely bind 1.85.0?**

Both mechanisms are present: `with: {toolchain: "1.85.0"}` (action input) and `env: {RUSTUP_TOOLCHAIN: "1.85.0"}` (cargo check step).

Load-bearing analysis: `rust-toolchain.toml` (`channel = "stable"`) **overrides** what `dtolnay/rust-toolchain`'s `toolchain:` input installs at the shell/default level — this was the original false-green root cause. `RUSTUP_TOOLCHAIN` is the highest-precedence override in rustup's chain and outranks `rust-toolchain.toml`. Therefore: `with: {toolchain: "1.85.0"}` alone is **NOT load-bearing** (the toml wins). `env: {RUSTUP_TOOLCHAIN: "1.85.0"}` is the **load-bearing mechanism** — it forces the process. Both are required together: the action installs the 1.85.0 binary; the env var selects it over the toml's stable override. Omitting `RUSTUP_TOOLCHAIN` would silently restore false-green. (Documented at `CLAUDE.md`:218.)

**Item 2 — Would the job fail on a real MSRV violation?**

**Yes, demonstrably.** Commit `cc7f6da5` ("rewrite 3 in-tree let-chains") exists precisely because applying `RUSTUP_TOOLCHAIN=1.85.0` exposed E0658 errors on three in-tree let-chains during this story. The fix worked as intended on first application. Local verification: `RUSTUP_TOOLCHAIN=1.85.0 cargo check --all-features` exits 0 now; reintroducing a ≥1.88 construct would yield E0658 and fail the job.

**Item 3 — Declared-MSRV truth, end to end**

`RUSTUP_TOOLCHAIN=1.85.0 cargo check --all-features` → **Finished dev profile in 0.42s** (clean, exit 0).

| Location | Value |
|----------|-------|
| `Cargo.toml` `rust-version` | `"1.85"` |
| `ci.yml` job name | `MSRV (1.85.0)` |
| `ci.yml` action comment | `# 1.85.0` |
| `ci.yml` `toolchain:` input | `"1.85.0"` |
| `ci.yml` `RUSTUP_TOOLCHAIN` env | `"1.85.0"` |

All five agree. No disagreement.

**Item 4 — SHA replacement completeness**

See SHA Enumeration Table above. Old SHA: 0. New SHA: 7 across 6 files. Complete.

**Item 5 — New SHA correctness and toolchain inputs per job**

Every site: msrv (`# 1.85.0`, `toolchain: "1.85.0"`); all other 6 sites (`# stable`, `toolchain: stable`). No mismatch.

**Item 6 — Pin enforceability**

`Cargo.toml`: `comfy-table = "=7.2.1"` (exact pin). `Cargo.lock`: version `7.2.1`, checksum `b03b7db8...` (confirmed). `cargo update` with an exact `=` pin cannot change the version. The combination of exact-pin plus now-working msrv job adequately prevents recurrence for this dep vector.

**Item 7 — Do-not-remove rustup target add steps**

`sign-and-publish.yml` lines 58–65: present with explanatory comment. `backfill-release.yml` lines 73–82: present with explanatory comment. Both survive unchanged.

**Item 8 — YAML and workflow integrity**

`ci-gate` `needs` at line 443 includes `msrv`. No unrelated steps, triggers, `needs:` lists, or permission blocks altered. All edited workflows parse cleanly.

**Item 9 — Residual MSRV exposure**

`RUSTUP_TOOLCHAIN=1.85.0 cargo check --all-targets` **FAILS** — `wiremock 0.6.5` (dev-dep) uses let-chains in `matchers.rs:214-215` (E0658). The msrv job uses `cargo check --all-features` (lib+bins only, not dev-deps). This is accepted: `rust-version` in `Cargo.toml` documents the minimum for shipping code, not test harness tooling. Standard Rust MSRV practice. The ci.yml msrv step has no inline comment explaining the scope exclusion. Flagged as REFINEMENT (see B-001).

**Item 10 — CHANGELOG accuracy**

Entry under `[Unreleased] ### Changed` describes the comfy-table pin, motivation, and S-640-1 follow-on. Not mislabelled as breaking. The three in-tree let-chain rewrites (AC-9, ~98 src/ lines) are not mentioned. Pure compatibility maintenance with no user-visible behavior change — omission is defensible but noted (see B-002).

## Part A — Fix Verification (pass B reviews pass A findings)

Pass A findings are not read per isolation rules. This table is not populated.

## Part B — New Findings (or all findings for pass 1)

### CRITICAL

None.

### HIGH

None.

### MEDIUM

None.

### LOW

#### ADV-PB-LOW-001: msrv job lacks inline scope comment for --all-features vs --all-targets

- **Severity:** LOW
- **Category:** verification-gaps
- **Location:** `.github/workflows/ci.yml` msrv job, `cargo check` step
- **Description:** `cargo check --all-features` checks lib+bins but not dev-dependencies. `wiremock 0.6.5` (a dev-dep) requires ≥1.88 due to let-chains and would cause `--all-targets` to fail at MSRV 1.85. There is no inline comment explaining this scope decision, creating a future-maintainer hazard: someone may add `--all-targets` expecting it to extend coverage, breaking the job without understanding why.
- **Evidence:** `RUSTUP_TOOLCHAIN=1.85.0 cargo check --all-targets` exits non-zero with E0658 in `wiremock-0.6.5/src/matchers.rs:214-215`. The msrv job uses `--all-features` only (ci.yml:74).
- **Proposed Fix:** Add a one-line comment above the cargo check step: `# --all-features: checks lib+bins only; --all-targets fails (wiremock 0.6.5 requires >=1.88, tracked S-640-1)`. This is a REFINEMENT — the scope is correctly implemented; only the documentation is missing.
- **GAP or REFINEMENT:** REFINEMENT

#### ADV-PB-LOW-002: CHANGELOG missing AC-9 in-tree let-chain rewrite entry

- **Severity:** LOW
- **Category:** spec-fidelity
- **Location:** `CHANGELOG.md` `[Unreleased]` section
- **Description:** The story's AC-9 scope addition rewrites let-chains in `src/cli/auth/keychain.rs`, `src/cli/board.rs`, and `src/cli/issue/list.rs` (~98 lines across 3 files). The CHANGELOG documents only the comfy-table pin. While no user-visible behavior changes, the src/ scope change is relevant to future S-640-1 authors who will need to re-introduce let-chains when raising MSRV to 1.88 — a CHANGELOG entry aids discoverability.
- **Evidence:** `CHANGELOG.md [Unreleased] ### Changed` contains one bullet (comfy-table pin). Commit `cc7f6da5` stats: 3 src/ files, 51 insertions, 47 deletions.
- **Proposed Fix:** Add a bullet under `### Changed` noting the 3-file let-chain rewrite: e.g., "Rewrote 3 in-tree let-chain patterns (board.rs, issue/list.rs, auth/keychain.rs) to nested if-blocks for MSRV 1.85 compatibility (S-626-1 AC-9); S-640-1 will revert when MSRV raises to 1.88."
- **GAP or REFINEMENT:** REFINEMENT

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 0 |
| LOW | 2 |

**Overall Assessment:** pass-with-findings (2 REFINEMENTs only, no GAPs)
**Convergence:** findings remain (2 low-severity REFINEMENTs) — documentation gaps, not correctness gaps
**Readiness:** ready for next phase; REFINEMENTs are non-blocking

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | B |
| **New findings** | 2 |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 2 / (2 + 0) = 1.0 |
| **Median severity** | LOW (2.0) |
| **Trajectory** | B: 2 new findings |
| **Verdict** | FINDINGS_REMAIN (2 LOW REFINEMENTs; no GAPs; ready to proceed) |
