---
document_type: f7-delta-convergence-report
feature: issue-327 / S-327
title: "rand 0.9.4 → 0.10.1: OsRng/TryRngCore symbol-rename migration + deny.toml comment block"
pr: "#413"
pr_sha: 375c0f91
merge_date: 2026-05-26
spec_version: v1.5.0 (no bump — BC-1.5.035 title text refresh only; BC counts 583/103/74 unchanged)
verdict: CONVERGED
maximum_viable_refinement_reached: true
producer: state-manager
---

# Delta Convergence Report: Issue #327 — `rand` 0.9.4 → 0.10.1 Migration

## Feature Summary

- **Feature request / Dependabot PR:** https://github.com/Zious11/jira-cli/issues/327
- **Intent:** Dependency hygiene — track upstream `rand` 0.10 semver-major release. Two symbol
  renames in `src/api/auth.rs::generate_state` (`OsRng` → `SysRng`, `TryRngCore` → `TryRng`);
  Cargo.toml version bump; deny.toml comment block explaining why `cargo deny check` exits 0
  without skip entries for the rand 0.9 / 0.10 lockfile dual-presence.
- **Spec delta:** No version bump. BC-1.5.035 title text refreshed (OsRng → SysRng) — behavioral
  claim (32 bytes, 64 hex chars, OS CSPRNG) unchanged. BC counts unchanged: 583 total, bc-1 at
  83/27. 7 spec sites updated: 5 specs + 2 architecture files.
- **Story:** S-327 — 8 ACs, 3 existing unit tests (no new tests), 1 SP, MEDIUM priority
- **Files changed:** 4 modified (`Cargo.toml` +1/-1, `src/api/auth.rs` +3/-3, `deny.toml` +13/-0,
  `Cargo.lock` +50/-6). 0 new files. Total: ~67 lines changed.
- **Preceding cycle:** S-407 — `--label` conflict block test-hardening (PR #411 @ `6eb2535`,
  2026-05-25). Baseline test count: 1483 pass / 0 fail / 18 ignored.
- **Merge:** PR #413 squash-merged @ `375c0f91` on `develop`, 2026-05-26T18:59:45Z.
- **Dependabot PR #327:** Auto-closed by the PR #413 merge. Branch and local branch removed.
  Worktree cleaned up.

---

## Five-Dimensional Convergence (Delta)

| Dimension | Metric | Target | Actual | Status |
|-----------|--------|--------|--------|--------|
| **Behavioral** | All 8 ACs satisfied | 8/8 | **8/8** (AC-1 compile green, AC-2 3/3 unit tests, AC-3 clippy exit 0, AC-4 fmt exit 0, AC-5 deny exit 0, AC-6 SysRng rustdoc, AC-7 0 OsRng/TryRngCore refs, AC-8 full suite green) | **PASS** |
| **Test** | Mutation kill rate on `generate_state` (2/2 mutants) | ≥ 90% | **100% (2/2 caught)** | **PASS** |
| **Spec** | Adversary novelty score (F5: 3 passes; trajectory ??→0→0 CLEAN) | < 0.15 | **~0.00** (passes 2/3 CLEAN; zero novel findings at convergence) | **PASS** |
| **Architectural** | No architecture change; ADR-0006 governance unaffected; purity boundary preserved | no change | **Confirmed** — `generate_state` remains effectful shell function; module criticality HIGH unchanged | **PASS** |
| **Implementation** | Adversary verification rate on delta; open CRIT/HIGH | 0 CRIT/HIGH; 0 open | **0 CRIT / 0 HIGH** at all F5 passes; 3 commits on `chore/rand-0.10-migration` → squash-merged to develop @ `375c0f91` | **PASS** |

### Sixth Dimension (Project-specific)

| Dimension | Metric | Target | Actual | Status |
|-----------|--------|--------|--------|--------|
| **Regression** | Full test suite vs baseline (1483 baseline) | 0 regressions | **1,483 passed, 0 failed, 18 ignored** — byte-for-byte identical to issue-407 baseline | **PASS** |

---

## Dimension Notes

### Behavioral Convergence

All 8 ACs verified via PR #413 (`375c0f91`) and the story file at
`.factory/stories/S-327-rand-0.10-migration.md`:

- **AC-1** (cargo build exits 0): confirmed — PR #413 CI green at merge.
- **AC-2** (3 existing unit tests pass): `test_generate_state_is_hex`, `test_generate_state_is_64_hex_chars`,
  `test_generate_state_is_not_deterministic` all green pre-migration (baseline) and post-migration (green).
  No test code modified.
- **AC-3** (clippy exit 0): confirmed — zero warnings; no `#[allow]` suppressions added.
- **AC-4** (fmt exit 0): confirmed — symbol renames are drop-in replacements; no whitespace drift.
- **AC-5** (`cargo deny check` exit 0): empirically-green WITHOUT `[[bans.skip]]` entries for rand
  0.9/0.10 — `cargo-deny` does not flag dev-dep-only-transitive duplicates via the `proptest` /
  `quinn-proto` path. The +13 lines added to `deny.toml:57-69` are a comment block only (no TOML
  directives). This was the key empirical finding of the cycle (see OBS-327-P4-001 / PG-327-4 below).
- **AC-6** (SysRng in rustdoc): `grep -n 'OsRng' src/api/auth.rs` → 0 matches.
- **AC-7** (no OsRng/TryRngCore in src/ tests/ Cargo.toml): confirmed.
- **AC-8** (full cargo test): 1483 / 0 / 18 — clean.

### Test Convergence

Mutation testing on `generate_state` (augmented direct-file run per `.cargo/mutants.toml`
exclude of `src/api/auth.rs`):

- **2 mutants found, 2 caught (100%)**
- `Ok(String::new())` caught by `test_generate_state_is_64_hex_chars` + `test_generate_state_is_not_deterministic`
- `Ok("xyzzy".into())` caught by `test_generate_state_is_hex` + `test_generate_state_is_64_hex_chars`

Three existing unit tests form a complete kill harness for the function. No new tests added
(confirmed by F1 BA input: "No new tests required. Three existing unit tests exercise the renamed
call site identically.").

**Note on canonical `--in-diff` run:** `.cargo/mutants.toml::examine_globs` excludes
`src/api/auth.rs`, so the canonical CLAUDE.md `--in-diff` command reports "No mutants to filter"
for this PR. The augmented `--regex 'generate_state'` run provides the equivalent kill-rate
evidence. This exclusion is tracked as PG-327-3 below.

### Spec Convergence

F2 ran adversarial passes and found zero novel BC-level findings. BC-1.5.035 title text refreshed
(OsRng → SysRng) — behavioral claim (32 bytes, 64 hex chars, OS CSPRNG) unchanged. Seven spec
sites updated (5 specs + 2 architecture files). BC count surfaces unchanged: 583 total. All 3
guard scripts exit 0:
- `scripts/check-spec-counts.sh` — exit 0
- `scripts/check-bc-cumulative-counts.sh` — exit 0
- `scripts/check-bc-no-numeric-test-counts.sh` — exit 0

Consistency-validator CLEAN at F2 + F3 (19/19 checks PASS per
`.factory/phase-f2-spec-evolution/consistency-audit-327.md`).

F5 trajectory: passes 2/3 CLEAN (no novel findings requiring fixes). Adversary novelty score
effectively 0.00 at convergence.

### Architectural Convergence

- No architecture change. The function `generate_state` is and remains an effectful shell function
  (OS syscall via `getrandom(2)` / `BCryptGenRandom`). No purity reclassification.
- ADR-0006 (embedded OAuth app) governance: unaffected. The CSRF state generator's security
  posture is identical before and after the rename.
- Module criticality for `src/api/auth.rs`: unchanged (HIGH).
- `deny.toml` governance: +13 comment-only lines document the empirical finding that
  `cargo-deny` does not require skip entries for this transitive dual-presence pattern.

### Implementation Convergence

3 commits on `chore/rand-0.10-migration` → squash-merged to develop at `375c0f91`:

| File | Change |
|------|--------|
| `Cargo.toml` | `rand = "0.9"` → `rand = "0.10"` (+1/-1) |
| `src/api/auth.rs` | 3 symbol renames at generate_state (+3/-3) |
| `deny.toml` | +13 comment lines explaining empirical cargo-deny behavior |
| `Cargo.lock` | Auto-resolved by cargo (+50/-6) |

0 stale `OsRng` / `TryRngCore` references in source, specs, or architecture files.
0 new dependencies, 0 new unsafe blocks, 0 `#[allow]` suppressions.

### Regression Convergence

| Metric | Baseline (pre-S-327 @ `6eb2535`) | Current (post-S-327 @ `375c0f91`) | Status |
|--------|-----------------------------------|-------------------------------------|--------|
| Total tests passing | 1,483 | **1,483** | -- |
| Existing tests passing | 1,483 | 1,483 | **PASS** |
| New tests passing (S-327) | — | 0 (no new tests) | **N/A** |
| Unexpected failures | 0 | **0** | **PASS** |
| Gated-ignored (pre-existing) | 18 | 18 | **PASS** |

Zero regressions. 6-story regression zone (S-1.06, S-1.08, S-3.01, S-3.03, S-3.04,
issue-288-pr4-dispatch) all green. The 18 gated-ignored tests unchanged from baseline.

---

## Cost-Benefit Analysis

### Refinement Iterations

| Phase | Passes | Quality |
|-------|--------|---------|
| F1 delta analysis | 1 pass | BA grep scope gap found post-hoc (PG-327-1) |
| F2 spec adversarial | 2+ passes | CLEAN at passes 2/3; BC-1.5.035 title refresh only |
| F5 scoped adversarial | 3 passes | Trajectory: HIGH false-positive (F-327-P1-001) → 0 → 0 after orchestrator live-tool resolution |
| F6 hardening | 1 run | Mutation 100% (2/2); audit/deny PASS; regression 1483/0 |
| Perplexity verification | 1 pass | `PERPLEXITY-CONFIRMS-PRIOR-ASSESSMENT` — zero divergences |

### Trajectory Assessment

Finding trajectory at F5:
- Pass 1: 1 HIGH (F-327-P1-001 — `deny.toml` static-analysis inference of a defect that didn't
  exist); 1 MEDIUM concern (F-327-P1-002 — F5 adversary tooling access); 3 LOW informational.
- Pass 2: 0 findings.
- Pass 3: 0 findings.

The pass-1 HIGH was a static-analysis false positive: F5 adversary inferred that `cargo deny
check` would fail based on visible `rand 0.9` / `rand 0.10` lockfile dual-presence. The
orchestrator ran `cargo deny check` live and observed exit 0 — empirically refuting the finding.
Passes 2/3 followed CLEAN once the resolution was communicated. Cost: ~2 hours of
investigation; root cause: F5 adversary profile cannot run live tool commands (PG-327-2).

MAXIMUM_VIABLE_REFINEMENT_REACHED. Additional adversarial iterations would not change the
outcome.

---

## Traceability Chain

```
BC-1.5.035 (generate_state — 32 bytes from SysRng encoded as 64 hex chars)
  → S-327 (8 ACs — rename OsRng→SysRng, TryRngCore→TryRng; deny.toml documentation)
  → src/api/auth.rs (3 renames at generate_state; 3 existing unit tests unchanged)
  → Cargo.toml (rand "0.9" → "0.10")
  → deny.toml (+13 comment lines documenting empirical cargo-deny behavior)
  → F2: prd-delta-327.md (BC-1.5.035 title refresh; 7 spec sites updated; 19/19 consistency PASS)
  → F5 adversarial: 3 passes (HIGH FP resolved live → 0 → 0)
  → Mutation: 2/2 caught (100%)
  → Regression: 1,483/0
  → PR #413 @ 375c0f91 (develop, 2026-05-26T18:59:45Z)
  → Dependabot PR #327 auto-closed
```

---

## Cycle-Close: Process-Gap Findings (S-7.02)

Four process-gap findings collected from F1-F6. Routing decisions below.

| ID | Source | Description | Routing | Blocks F7? |
|----|--------|-------------|---------|-----------|
| PG-327-1 | F1 reconciliation | BA grep scope covered only `.factory/specs/prd/` — missed `.factory/specs/domain-spec/` AND `.factory/architecture/`. Two extra OsRng sites had to be added to F2 scope mid-cycle. Fix: expand BA grep target to `.factory/{specs,architecture}/**/*.md` (with `.factory/semport/` excluded as historical snapshots). | JUSTIFIED DEFERRAL — process improvement for F1 template; no story required; note in lessons. | NO |
| PG-327-2 | F5 pass 1 (F-327-P1-002, F-327-P1-005) | F5 adversary `read-only` profile cannot run `cargo build/test/deny/clippy/fmt` to reproduce live tool claims. Recurring pattern affecting every code-implementation-review F5. Fix: either grant Bash access scoped to read-only cargo subcommands, or embed cargo-deny verbose output in F5 dispatch packets by default. | JUSTIFIED DEFERRAL — tooling improvement; codified in lessons (L-327-3). | NO |
| PG-327-3 | F6 surprise | `.cargo/mutants.toml::examine_globs` excludes `src/api/auth.rs` — a security-critical OAuth module. The canonical CLAUDE.md `--in-diff` cargo-mutants command therefore reports zero mutants for any auth.rs-only PR. Recommendation: add `src/api/auth.rs` to `examine_globs`. | JUSTIFIED DEFERRAL — scope change to mutants.toml; worth a separate small story or batch with the next mutants.toml touch. Noted in lessons. | NO |
| PG-327-4 | F5 pass 4 (OBS-327-P4-001) | Story spec AC-5 narrative described an F1-anticipated path (`[[bans.skip]]` entries) that wasn't taken (empirical-green: cargo-deny doesn't flag dev-dep-only-transitive duplicates). Story is a point-in-time artifact, so amending retroactively isn't required — the deny.toml comment block at lines 57-69 is the operative forward-documentation. | JUSTIFIED DEFERRAL — story spec narrative describes an anticipated path that empirical observation superseded. The comment block in deny.toml is the canonical forward-documentation. No story required. | NO |

All four PG items are justified deferrals. None blocks convergence.

---

## Recommendation

**PR #413 is already merged at `375c0f91` on `develop` (2026-05-26T18:59:45Z).**

All six convergence dimensions PASS. Regression suite clean at 1,483/0. MAXIMUM_VIABLE_REFINEMENT_REACHED.

**Status: CONVERGED — cycle close authorized.**

Release disposition: S-327 is a dependency-hygiene maintenance change with no user-visible behavior
change. Ships with the next batched `develop → main` release (no standalone release warranted).
No CHANGELOG entry required (pure symbol rename tracking upstream crate).

---

## Cycle Summary

| Phase | Result | Date |
|-------|--------|------|
| F1 Delta Analysis | PASSED (human-approved; branch `chore/rand-0.10-migration` confirmed; Dependabot branch not used) | 2026-05-26 |
| F2 Spec Evolution | CONVERGED (BC-1.5.035 title refresh; 7 spec sites; 19/19 consistency PASS; no new BCs) | 2026-05-26 |
| F3 Story Decomposition | PASSED (S-327 created; 8 ACs; 3 existing unit tests; 1 SP; MEDIUM priority) | 2026-05-26 |
| F4 TDD Delivery | DELIVERED (PR #413 @ 375c0f91; 3 per-story adversarial passes; CI green) | 2026-05-26 |
| F5 Scoped Adversarial | CONVERGED (3 passes; trajectory HIGH-FP→0→0; no fix-PRs; empirical-first resolved the FP) | 2026-05-26 |
| F6 Targeted Hardening | PASS (mutation 100% 2/2; audit 0 vulns; deny exit 0; regression 1483/0; CI green) | 2026-05-26 |
| **F7 Delta Convergence** | **CONVERGED — ALL 6 DIMENSIONS** | **2026-05-26** |
