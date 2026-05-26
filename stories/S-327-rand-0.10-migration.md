---
document_type: story
story_id: "S-327"
title: "rand 0.9.4 → 0.10.1: OsRng/TryRngCore symbol-rename migration + deny.toml dual-presence skip (closes #327)"
wave: feature-followup
status: ready
intent: enhancement
feature_type: infrastructure
scope: small
issue: 327
points: 1
priority: medium
tdd_mode: strict
estimated_effort: small
depends_on: []
bc_anchors:
  - BC-1.5.035
verification_properties: []
# No VP infrastructure exists in this project — no .factory/specs/verification-properties/
# directory and no VP-NNN identifiers in any .factory/**/*.md file. The 32-byte entropy
# invariant is implicitly captured by BC-1.5.035 and the three existing unit tests.
holdout_anchors: []
nfr_anchors: []
adr_refs:
  - ADR-0006
# ADR-0006: embedded OAuth app — the CSRF state generation function (generate_state) is
# in the same security path as the OAuth app; the ADR governs the surrounding context even
# though no new architectural decision is required for this symbol-rename migration.
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: ".factory/phase-f2-spec-evolution/prd-delta-327.md"
implementation_strategy: tdd
# TDD posture: the three unit tests at src/api/auth.rs:1185-1224 act as the red baseline
# (currently passing on develop). Symbol renames are the minimal green change. No new tests
# required (per F1 BA confirmation — existing coverage exercises the renamed code path
# identically). The tests must PASS before and AFTER the rename; any failure means STOP.
module_criticality: HIGH
# src/api/auth.rs is in the security-critical OAuth CSRF state-generation path. Even a
# trivial symbol rename there warrants HIGH review discipline. Classification is unchanged
# from the pre-migration state — this migration does not reclassify the module.
files_modified:
  - src/api/auth.rs       # MODIFIED — rename use rand::TryRngCore → use rand::TryRng (line 1094); rename rand::rngs::OsRng → rand::rngs::SysRng (line 1096); rename rustdoc "OsRng" → "SysRng" (lines 1077-1078); est. -3 / +3 LOC
  - Cargo.toml            # MODIFIED — bump rand = "0.9" → rand = "0.10" (line 34); est. -1 / +1 LOC
  - deny.toml             # MODIFIED — add [[bans.skip]] entries for rand 0.9 + rand 0.10 dual-presence (and rand_core 0.9 + rand_core 0.10 if cargo tree -d -i rand_core confirms dual-presence — verify at F4 start); est. +14 to +28 LOC
  - Cargo.lock            # MODIFIED — automatic resolution; Dependabot PR #327 lockfile already reflects expected state
files_created: []
breaking_change: false
assumption_validations: []
risk_mitigations: []
# BC status: BC-1.5.035 modified (title text only, OsRng → SysRng) in F2 spec-evolution
# pass (2026-05-26). Behavioral claim — 32 bytes, 64 hex chars, OS CSPRNG — unchanged.
# No new BCs introduced. BC count surfaces unchanged (583 total).
---

# S-327 — `rand` 0.9.4 → 0.10.1: OsRng/TryRngCore Symbol-Rename Migration + deny.toml Dual-Presence Skip

## Source of Truth

F1 delta analysis: `.factory/phase-f1-delta-analysis/issue-327/delta-analysis.md`
F1 business analyst input: `.factory/phase-f1-delta-analysis/issue-327/business-analyst-input.md`
F2 PRD delta: `.factory/phase-f2-spec-evolution/prd-delta-327.md` (BC-1.5.035 title text refresh; no new BCs)
F2 consistency audit: `.factory/phase-f2-spec-evolution/consistency-audit-327.md` (19/19 checks PASS)
Migration research: `.factory/research/rand-0.10-migration-assessment.md` (verdict: SMALL-MIGRATION-NEEDED)
Perplexity verification: `.factory/research/rand-0.10-perplexity-verification.md` (verdict: PERPLEXITY-CONFIRMS-PRIOR-ASSESSMENT)

**No new BCs. No new VPs. No new ADR.** BC count surfaces unchanged: 583 total. BC-1.5.035 received
a cosmetic title-text refresh in F2 (OsRng → SysRng) — behavioral claim unchanged.

## Problem Statement

Dependabot PR #327 bumps `rand` from 0.9.4 to 0.10.1. This is a semver-major bump; `rand` 0.10
renamed two symbols that appear exactly once in the production codebase:

- `TryRngCore` → `TryRng` (trait import)
- `OsRng` → `SysRng` (zero-sized struct in `rand::rngs`)

Both renames are in `src/api/auth.rs::generate_state` — the OAuth CSRF state generator. The
function behavior is byte-identical: same `try_fill_bytes` signature, same OS CSPRNG backend
(`getrandom(2)` / `BCryptGenRandom`), same 32-byte output encoded as 64 hex characters.

Additionally, `proptest` (dev-dep) and `quinn-proto` (via reqwest/rustls) still depend on
`rand 0.9.4`, causing `cargo deny check` to fail on `multiple-versions = "deny"` without
explicit `[[bans.skip]]` entries for the dual-version coexistence.

The PR has passed the 7-day Dependabot soak window (PR opened >7 days ago as of 2026-05-26).
MSRV is satisfied: project at Rust 1.85 / Edition 2024; rand 0.10 requires 1.85.

The security advisory GHSA-cq8v-f236-94qc (rand 0.10.1, severity Low) does NOT affect this
codebase: it requires `ThreadRng` + a custom `log` logger + reseed during a logger borrow.
`jr` never enables the `log` feature of `rand`, never installs a custom logger, and never
uses `ThreadRng`. The `generate_state` function uses only `SysRng` (the renamed `OsRng`),
which is explicitly not affected.

## Behavioral Contracts

| BC ID | File | Title | Clause(s) |
|-------|------|-------|-----------|
| BC-1.5.035 | `bc-1-auth-identity.md` | `generate_state()` produces 32 bytes from SysRng encoded as 64 hex chars | All postconditions; title text refreshed in F2 (OsRng → SysRng); behavioral claim — 32 bytes, 64 hex chars, OS CSPRNG — unchanged |

## Acceptance Criteria

### AC-1 — `cargo build` succeeds after symbol renames + version bump
(traces to BC-1.5.035 postcondition — observable output format preserved at compile time)

After applying edits to `src/api/auth.rs` (lines 1077-1078, 1094, 1096) and `Cargo.toml` (line 34):
- `cargo build` exits 0.
- No `error[E0432]` (unresolved import) for `TryRngCore` or `OsRng`.
- No `error[E0433]` (unresolved name) for `rand::rngs::OsRng`.

This is the foundational gate: if the symbol renames are incomplete or incorrect, `cargo build`
catches it immediately.

### AC-2 — Three existing unit tests pass without modification
(traces to BC-1.5.035 postcondition — 64-char lowercase hex string, OS CSPRNG, non-deterministic)

All three tests at `src/api/auth.rs:1185-1224` pass via `cargo test --lib api::auth::tests`:
- `test_generate_state_is_hex` — all 64 characters are `[0-9a-f]`
- `test_generate_state_is_64_hex_chars` — output is exactly 64 characters
- `test_generate_state_is_not_deterministic` — 8 distinct outputs from 8 calls

These tests exercise the renamed call site identically: `generate_state()` is the entry point;
the internal type rename (`OsRng → SysRng`, `TryRngCore → TryRng`) is transparent to them. They
act as the TDD red-baseline (verified passing on `develop` before rename) and the green
confirmation (still passing after rename). No test code is modified.

### AC-3 — `cargo clippy -- -D warnings` exits 0
(traces to BC-1.5.035 invariant — implementation must remain lint-clean and forward-compatible)

No deprecation lint for the old trait or type names. No new warnings introduced by the renames.
Zero warnings total (project convention). No `#[allow]` suppressions added.

### AC-4 — `cargo fmt --all -- --check` exits 0
(traces to BC-1.5.035 invariant — code style is part of the implementation contract)

The symbol renames are drop-in replacements; formatting is not expected to change. This gate
confirms no accidental whitespace or line-length drift in the edited lines.

### AC-5 — `cargo deny check` exits 0 after deny.toml skip entries
(traces to BC-1.5.035 postcondition — supply-chain hygiene gate passes; the dual-version
coexistence of rand 0.9 + rand 0.10 is explicitly documented and accepted)

After adding `[[bans.skip]]` entries for the dual `rand` presence:
- Entry for `rand` version `"0.9"` with reason documenting `proptest 1.x` and `quinn-proto`
  as the transitive roots that prevent unification.
- Entry for `rand` version `"0.10"` with reason documenting `jr` direct dep.
- If `cargo tree -d -i rand_core` (run at F4 start after Cargo.toml bump) confirms dual
  `rand_core` presence: add paired entries for `rand_core` version `"0.9"` and `"0.10"` with
  matching reasons. The F1 analysis anticipates this is very likely.

`cargo deny check` exits 0 after all necessary skip entries are added.

### AC-6 — Rustdoc references `SysRng`, not `OsRng`
(traces to BC-1.5.035 title — spec and implementation must agree on the type name post-migration)

`grep -n 'OsRng' src/api/auth.rs` returns zero matches. The rustdoc comment at lines 1077-1078
reads `rand::rngs::SysRng` (not `OsRng`). BC-1.5.035 and the implementation are consistent.

### AC-7 — No residual `OsRng` or `TryRngCore` references in production or test code
(traces to BC-1.5.035 postcondition — the migration is complete; no dead symbols remain)

`grep -rn 'OsRng\|TryRngCore' src/ tests/ Cargo.toml` returns zero matches.

This confirms:
- No missed use-site in any other source file (the migration assessment grep-verified this;
  AC-7 is the runtime confirmation at F4 completion).
- No stale integration test that expects the old type name in an error message or output.

### AC-8 — Full project test suite passes: `cargo test`
(traces to BC-1.5.035 postcondition — all behavioral contracts remain green; 6-story regression zone confirmed)

`cargo test` exits 0. The six stories in the regression zone (S-1.06, S-1.08, S-3.01, S-3.03,
S-3.04, issue-288-pr4-dispatch) exercise `src/api/auth.rs` or the OAuth login flow. Their tests
must remain green. If any test fails, STOP and investigate — do not suppress or bypass.

## Implementation Strategy

The implementation follows this ordered sequence:

1. **Create branch** `chore/rand-0.10-migration` from `develop`.
   Do NOT use Dependabot PR #327's branch (`dependabot/cargo/rand-0.10.1`) — that branch name
   does not follow the project's `type/short-description` convention (per F1 Open Question Q1,
   resolved at human gate). Dependabot PR #327 is closed in favor of this branch after the PR
   is created (noted for F7).

2. **Verify baseline.** Run `cargo test --lib api::auth::tests` on `develop` before making any
   edits. All three unit tests must be green before the rename. If they are not, stop and
   escalate — the pre-migration baseline is broken.

3. **Edit `Cargo.toml`** (line 34): `rand = "0.9"` → `rand = "0.10"`. This alone will cause
   `cargo build` to fail with symbol-resolution errors — that is expected (red phase of TDD).

4. **Edit `src/api/auth.rs`**: apply three renames:
   - Line 1094: `use rand::TryRngCore;` → `use rand::TryRng;`
   - Line 1096: `rand::rngs::OsRng` → `rand::rngs::SysRng`
   - Lines 1077-1078 (rustdoc): `rand::rngs::OsRng` → `rand::rngs::SysRng`

5. **Run `cargo build`** — expect exit 0 (green). Any remaining compile error means a missed
   rename; fix before proceeding.

6. **Run `cargo test --lib api::auth::tests`** — all three unit tests must pass (AC-2).

7. **Run `cargo deny check`** — expect failure with messages identifying `rand 0.9` and `rand 0.10`
   as the banned duplicate pair (and possibly `rand_core 0.9` + `rand_core 0.10`). Capture the
   exact error output. Run `cargo tree -d -i rand_core` to determine whether `rand_core` also
   has dual-version presence.

8. **Edit `deny.toml`**: add `[[bans.skip]]` entries based on the exact error messages from step 7.
   Follow the established paired-entry pattern (one entry per version, each with a documented
   reason string attributing the transitive root). See the getrandom/toml/thiserror entries in
   `deny.toml` for the exact format to match.

9. **Run `cargo deny check`** — must exit 0 (AC-5).

10. **Run `cargo clippy -- -D warnings`** — must exit 0 (AC-3).

11. **Run `cargo fmt --all -- --check`** — must exit 0 (AC-4).

12. **Run `grep -rn 'OsRng\|TryRngCore' src/ tests/ Cargo.toml`** — must return zero matches (AC-7).

13. **Run `cargo test`** — full suite must be green (AC-8). If any test fails, stop and investigate.

14. Per-story adversary 3/3 CLEAN before push.

## Out of Scope

- **Updating stale line-anchor citations in BC bodies.** The BC-1.5.035 body references
  `src/api/auth.rs:882` in BC-INDEX.md. Line number drift in BC bodies is tracked separately
  (issue #408 territory). This story does not touch BC line anchors.
- **Updating semport historical snapshots.** The five `OsRng` references in
  `.factory/semport/jira-cli/jira-cli-pass-*.md` are intentionally preserved as point-in-time
  artifacts (pinned at SHA `dea16647...`, 2026-05-04). Updating them would falsify the
  historical record. Per F2 quality gate check 2: these are PASS-confirmed as intentionally intact.
- **Adding new BCs, VPs, or holdouts.** The rename is a pure implementation change; no new
  behavioral contracts, verification properties, or holdout scenarios are introduced.
- **Any behavioral change.** `generate_state` output characteristics (32 bytes, 64 hex chars,
  OS CSPRNG, non-deterministic) are identical before and after the migration.
- **Updating CLAUDE.md.** No new gotcha or AI agent note is introduced by this migration.
- **MSRV bump.** Not required — both the project (Rust 1.85 / Edition 2024) and rand 0.10 already
  share the same MSRV.
- **Closing Dependabot PR #327 directly.** Dependabot PR #327 is closed AFTER this story's PR
  is created and merged. The closure is part of F7 (Delta Convergence); F4 only creates the
  implementation branch.

## Regression Risk Mitigations

**Risk rating: LOW** (per F1 delta analysis — 2 symbol renames, no logic change, existing 3 unit tests cover post-migration path).

The 6-story regression zone identified by the F1 BA:

| Story ID | Relevance | Status |
|----------|-----------|--------|
| S-1.06 (OAuth flow holdouts) | Anchors BC-1.1.001, BC-1.1.002; test suite exercises `oauth_login` path that calls `generate_state` at line 577 | merged (PR #300) |
| S-1.08 (keychain per-profile layout holdout) | Tests token storage/retrieval in `src/api/auth.rs` | merged (PR #302) |
| S-3.01 (auth.rs shard-split) | Regression-tested against BC-1.1.001, BC-1.4.027, BC-7.4.013-016 | completed (PR #319) |
| S-3.03 (refresh_oauth_token wiring) | Anchors BC-1.4.026; edits refresh path in same file | completed (PR #321) |
| S-3.04 (multi-cloudId disambiguation) | Anchors BC-1.5.038, BC-1.1.007, BC-1.5.031; edits `oauth_login` directly | completed (PR #320) |
| issue-288-pr4-dispatch (JSM dispatch + OAuth scope addition) | Modifies `DEFAULT_OAUTH_SCOPES`; adds BC-1.3.023 scope pin | completed (PR #381) |

**Mitigations:**
1. The compiler catches symbol-rename failures at `cargo build` — no missed OsRng/TryRngCore
   reference can survive to runtime (AC-1).
2. The three unit tests catch CSPRNG behavioral regressions (AC-2) — particularly
   `test_generate_state_is_not_deterministic` which calls `generate_state` 8 times and
   asserts 8 distinct values, catching any catastrophic CSPRNG misconfiguration.
3. AC-8 (`cargo test` full suite) is the final gate: all 6 risk-zone stories' tests run
   in this pass.

## Test Strategy

This story follows the project's TDD discipline with the existing tests serving as the
red-baseline:

**Pre-migration baseline verification** (before any edits):
- Run `cargo test --lib api::auth::tests` on `develop` — all 3 tests must be green.
- This verifies the baseline is healthy before the rename; any pre-existing failure must
  be investigated and resolved before proceeding.

**Symbol renames introduce a compile error** (intentional red phase):
- After editing `Cargo.toml` only (step 3 above), `cargo build` fails with `E0432`/`E0433`
  on the old symbol names. This is the expected red state.

**After src/api/auth.rs edits** (green phase):
- `cargo build` exits 0.
- `cargo test --lib api::auth::tests` exits 0 — all 3 unit tests pass.

**No new tests are written.** Per F1 BA confirmation:
> "No new tests required. Three existing unit tests exercise the renamed call site identically."

The existing tests call `generate_state()` directly; the internal type rename is transparent to
them. Their passing confirms both:
1. The renamed symbols resolve and compile correctly.
2. The CSPRNG produces 32 OS-random bytes → 64 hex characters identically to before.

## Quality Gate Self-Check

| Criterion | Required | Notes |
|-----------|----------|-------|
| `cargo build` exits 0 | AC-1 | Must be green before any further steps |
| All 3 unit tests pass (`cargo test --lib api::auth::tests`) | AC-2 | Both pre-migration (baseline) and post-migration (green) |
| `cargo clippy -- -D warnings` exits 0 | AC-3 | Zero warnings; no `#[allow]` suppressions |
| `cargo fmt --all -- --check` exits 0 | AC-4 | Formatting unchanged |
| `cargo deny check` exits 0 | AC-5 | Requires deny.toml skip entries for dual rand/rand_core presence |
| Rustdoc uses `SysRng` (not `OsRng`) | AC-6 | `grep -n 'OsRng' src/api/auth.rs` → 0 matches |
| No `OsRng` or `TryRngCore` in src/ tests/ Cargo.toml | AC-7 | `grep -rn 'OsRng\|TryRngCore' src/ tests/ Cargo.toml` → 0 matches |
| Full `cargo test` exits 0 | AC-8 | 6-story regression zone must remain green |
| `bash scripts/check-spec-counts.sh` exits 0 | invariant | No BC count change (583 total unchanged) |
| `bash scripts/check-bc-cumulative-counts.sh` exits 0 | invariant | No cumulative count drift |
| `bash scripts/check-bc-no-numeric-test-counts.sh` exits 0 | invariant | No numeric test counts in BC fields |
| Per-story adversary 3/3 CLEAN | project convention | Required before push |

## Token Budget Estimate

| Item | Tokens (approx) |
|------|----------------|
| This story file | ~5 k |
| F2 PRD delta (`prd-delta-327.md`) | ~5 k |
| BC body — BC-1.5.035 section in `bc-1-auth-identity.md` | ~2 k |
| `src/api/auth.rs` (generate_state function ~1077-1106 + unit tests ~1185-1224) | ~5 k |
| `Cargo.toml` (line 34 context) | ~1 k |
| `deny.toml` (full file — existing skip entries as reference for new entries) | ~3 k |
| `Cargo.lock` (not read directly; resolved automatically) | 0 |
| Tool outputs (`cargo build`, `cargo test`, `cargo clippy`, `cargo deny check`) | ~4 k |
| **Total** | **~25 k** |

Well within a single-agent context window (~200 k). No split required.
LOC delta estimate: -3 / +3 in `src/api/auth.rs`; -1 / +1 in `Cargo.toml`;
+14 to +28 in `deny.toml` (depending on rand_core dual-presence confirmation);
automatic in `Cargo.lock`.

## Tasks

- [ ] Read `prd-delta-327.md` — confirm: 7 spec sites updated, BC-1.5.035 title uses SysRng, no new BCs
- [ ] Read `bc-1-auth-identity.md` §BC-1.5.035 — confirm: behavioral claim (32 bytes, 64 hex chars, OS CSPRNG);
      title now reads "SysRng" (F2 update); preconditions/postconditions unchanged
- [ ] Read `src/api/auth.rs` lines 1074-1106 — locate: rustdoc paragraph with OsRng reference (lines 1077-1078);
      `use rand::TryRngCore;` import (line 1094); `rand::rngs::OsRng` call site (line 1096)
- [ ] Read `src/api/auth.rs` lines 1185-1224 — confirm: three unit tests, their structure, that they call
      `generate_state()` directly (no mock or stub)
- [ ] Run baseline: `cargo test --lib api::auth::tests` on `develop` — all 3 tests must be green BEFORE edits
- [ ] Create branch `chore/rand-0.10-migration` from `develop`
- [ ] Edit `Cargo.toml` line 34: `rand = "0.9"` → `rand = "0.10"` (expect `cargo build` to fail after this step alone)
- [ ] Edit `src/api/auth.rs`:
      - Lines 1077-1078: `rand::rngs::OsRng` → `rand::rngs::SysRng` in rustdoc
      - Line 1094: `use rand::TryRngCore;` → `use rand::TryRng;`
      - Line 1096: `rand::rngs::OsRng` → `rand::rngs::SysRng`
- [ ] Run `cargo build` — must exit 0 (AC-1); any error means missed rename — fix before continuing
- [ ] Run `cargo test --lib api::auth::tests` — all 3 tests pass (AC-2)
- [ ] Run `cargo deny check` — expect failure; capture exact error messages; run `cargo tree -d -i rand_core`
      to determine whether rand_core also has dual-version presence
- [ ] Edit `deny.toml`: add `[[bans.skip]]` entries for `rand 0.9`, `rand 0.10`, and (if confirmed)
      `rand_core 0.9`, `rand_core 0.10` — follow the paired-entry pattern established by
      getrandom/toml/thiserror entries; document transitive roots (proptest 1.x, quinn-proto) in reason strings
- [ ] Run `cargo deny check` — must exit 0 (AC-5)
- [ ] Run `cargo clippy -- -D warnings` — must exit 0 (AC-3); no `#[allow]` suppressions
- [ ] Run `cargo fmt --all -- --check` — must exit 0 (AC-4)
- [ ] Run `grep -rn 'OsRng\|TryRngCore' src/ tests/ Cargo.toml` — must return zero matches (AC-7)
- [ ] Run `cargo test` — full suite must be green (AC-8); if any test fails, STOP and investigate
- [ ] Run `bash scripts/check-spec-counts.sh && bash scripts/check-bc-cumulative-counts.sh && bash scripts/check-bc-no-numeric-test-counts.sh` — all exit 0
- [ ] Per-story adversary 3/3 CLEAN before push

## Previous Story Intelligence

This is the first story in the `rand` 0.10 migration cycle. No predecessor story.

The closest structural precedent is S-1.02 (cargo-deny supply chain hardening, PR #296) — that
story established the `deny.toml` `[[bans.skip]]` pattern that this migration extends. Read the
existing `deny.toml` entries (especially the getrandom 0.2/0.3/0.4 triple-skip pattern) before
writing the new rand skip entries. The established format is:

```toml
[[bans.skip]]
name = "<crate>"
version = "<semver>"
reason = "<transitive root(s)> requires <version>; <other transitive root(s)> require <other version>. <Blocking reason; unification path or non-path>."
```

Key lessons for this migration cycle:
- **Verify baseline BEFORE editing.** The three unit tests must pass on `develop` before the
  rename. If they don't, the pre-migration baseline is broken — stop and escalate.
- **Cargo.toml bump first, then src/ renames.** This produces the correct red→green TDD arc:
  bump makes the build fail; renames make it pass. Reversing the order hides the red phase.
- **cargo deny check AFTER cargo build.** Never run `cargo deny check` on a broken build —
  the lockfile may not reflect the post-bump state until `cargo build` resolves it.
- **rand_core dual-presence is likely but unconfirmed.** Run `cargo tree -d -i rand_core`
  AFTER the bump to determine the actual state. Do not add rand_core skip entries
  speculatively — only add them if `cargo deny check` specifically reports them.

## Architecture Compliance Rules

1. **No logic change in `generate_state`.** The function body is structurally identical before
   and after the migration: `try_fill_bytes` call, same byte count (32), same hex encoding,
   same `anyhow::Context::context` error propagation. Do not refactor anything else while
   touching these lines.

2. **Purity boundary unchanged.** `generate_state` is and remains an effectful shell function
   (OS syscall via `getrandom(2)` / `BCryptGenRandom`). No reclassification is required or
   permitted by this story.

3. **`deny.toml` skip entries must follow the paired-entry pattern.** Each version of a
   multi-version crate requires its own `[[bans.skip]]` entry. Do not use a single entry
   to cover multiple versions — that is not how `cargo-deny` parses the TOML.

4. **No `#[allow]` suppressions.** Zero-warning policy. If `cargo clippy` warns after the
   rename, fix the root cause (almost certainly a trivial formatting issue in the edited lines).

5. **No count-surface edits.** BC count surfaces (bc-1-auth-identity.md frontmatter,
   BC-INDEX.md, CANONICAL-COUNTS.md) are all unchanged. Do NOT edit them.

6. **CLAUDE.md is NOT modified.** No new AI agent note is introduced by this migration.

7. **Dependabot PR #327 is NOT merged.** This story creates a new branch per project convention.
   The Dependabot branch is closed in F7. Do not cherry-pick from the Dependabot branch.

## Library & Framework Requirements

No new dependencies. No dependency removals. One version specifier bump:

| Crate | Before | After | Notes |
|-------|--------|-------|-------|
| `rand` | `"0.9"` | `"0.10"` | Direct dep in `[dependencies]`; `Cargo.toml` line 34 |

The bump uses the default feature set (no explicit `features = [...]` list). In rand 0.10 the
default set is `["std", "std_rng", "sys_rng", "thread_rng"]`. The `sys_rng` feature enables
`rand::rngs::SysRng`, which is the only type `jr` uses from this crate. The other features are
inert for `jr`'s single use site (no `StdRng`, no `ThreadRng`, no `rand::rng()` call).

## File Structure Requirements

| File | Action | Notes |
|------|--------|-------|
| `src/api/auth.rs` | Modify | 3 renames in generate_state: rustdoc (lines 1077-1078), use import (line 1094), type path (line 1096); ~-3 / +3 LOC |
| `Cargo.toml` | Modify | Line 34: `"0.9"` → `"0.10"`; -1 / +1 LOC |
| `deny.toml` | Modify | Add [[bans.skip]] pairs for rand 0.9 + rand 0.10 (and rand_core if confirmed); +14 to +28 LOC |
| `Cargo.lock` | Automatic | Cargo resolves on build; no manual edit required |
| `.factory/stories/STORY-INDEX.md` | Modify | Append S-327 row to Feature Followup table; update total_stories 47→48 and last_updated |

**Files NOT to create:** No new source files, no new spec files, no new VP documents, no new ADR.

**Files NOT to touch:** `src/api/auth.rs` tests (lines 1185-1224), all other `src/` files,
all `tests/` files, `.factory/specs/`, CLAUDE.md.

## Branch / PR Plan

- Branch: `chore/rand-0.10-migration`
- Target: `develop`
- Commit style: `chore(S-327): rand 0.9 → 0.10 — OsRng/TryRngCore symbol renames + deny.toml skip (closes #327)`
- PR closes #327 (the GitHub issue), and Dependabot PR #327 is separately closed (F7 action)
- CHANGELOG entry: not required for a pure dependency bump with no user-visible behavior change

**Why `breaking_change: false`:** Symbol renames are internal to `src/api/auth.rs`. The
`generate_state` function is not public API. No previously-passing invocation changes its
exit code, stdout shape, or stderr content. No user-visible behavior change of any kind.
