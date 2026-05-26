---
document_type: f1-delta-analysis
phase: phase-f1-delta-analysis
producer: architect
issue: 327
status: ready-for-human-review
created: 2026-05-26
project: jira-cli
mode: BROWNFIELD
intent: enhancement
bundled_fix: false
feature_type: infrastructure
trivial_scope: true
scope: small
regression_risk: low
severity: N/A
inputs:
  - ".factory/research/rand-0.10-migration-assessment.md"
  - "https://github.com/Zious11/jira-cli/pull/327"
  - ".factory/phase-f1-delta-analysis/issue-407/delta-analysis.md"
  - ".factory/phase-f1-delta-analysis/issue-327/business-analyst-input.md"
---

# F1 Delta Analysis — Issue #327

## Feature

- **Name:** Dependency bump — `rand` 0.9.4 → 0.10.1 (Dependabot PR #327)
- **Issue link:** https://github.com/Zious11/jira-cli/issues/327
- **Research source:** `.factory/research/rand-0.10-migration-assessment.md` (SMALL-MIGRATION-NEEDED,
  high confidence, fully sourced to docs.rs/rand/0.10.1 + upstream CHANGELOG + Rand Book +
  GHSA-cq8v-f236-94qc)
- **Closest precedent:** Issue #407 delta analysis (test-hardening, same small/trivial profile)

---

## Intent Classification

**`enhancement`** — dependency-stack improvement: upgrading to the latest major version of `rand`
for correctness (resolving CI failure from breaking symbol renames), security hygiene (0.10.1 is
the patched release for GHSA-cq8v-f236-94qc, though our code path is unaffected), and ecosystem
alignment.

**Project-convention rationale (from BA):** All four prior F1 analyses use `enhancement` for
non-bug-fix dependency or capability improvements (`issue-396`, `issue-398`, `issue-388`,
`issue-382`). The `test-hardening` intent (`issue-407`) is specifically for test-only stories
with no production code change — not applicable here. Consistency with the established convention
takes precedence over an argument for a new `maintenance` label.

---

## Problem Statement

Dependabot opened PR #327 to bump `rand` from 0.9.4 to 0.10.1. The bump is a semver-major
change: `rand 0.10` renamed two symbols that appear exactly once in the production codebase
(`TryRngCore → TryRng`, `OsRng → SysRng`) and requires parallel `[[bans.skip]]` entries in
`deny.toml` because `proptest` (dev-dep) and `quinn-proto` (via reqwest/rustls) still pull
`rand 0.9.4`, causing `cargo deny check` to fail on the `multiple-versions = "deny"` rule
without explicit skip declarations.

The bump has been in Dependabot's queue past the 7-day soak window (PR opened >7 days ago as
of 2026-05-26), satisfies MSRV (project at Rust 1.85 / Edition 2024, rand 0.10 requires 1.85),
and is unblocked by any upstream incompatibility in `jr`'s direct code.

---

## Scope

### In scope

- Two symbol renames in `src/api/auth.rs::generate_state` body:
  - `use rand::TryRngCore;` → `use rand::TryRng;`
  - `rand::rngs::OsRng` → `rand::rngs::SysRng`
- One rustdoc paragraph rename in `src/api/auth.rs` (lines 1077-1078):
  - `rand::rngs::OsRng` → `rand::rngs::SysRng`
- Version bump in `Cargo.toml` line 34: `rand = "0.9"` → `rand = "0.10"`
- Two (possibly four) `[[bans.skip]]` additions to `deny.toml` for the dual rand/rand_core
  presence caused by proptest + quinn-proto still depending on rand 0.9.

### Out of scope

- Any behavioral change: `try_fill_bytes` signature is unchanged; OS CSPRNG path is identical;
  error handling via `anyhow::Context` is identical (error type renamed `OsError → SysError`
  but both are `std::error::Error + Send + Sync + 'static`).
- New tests: three existing unit tests at `src/api/auth.rs:1185-1224`
  (`test_generate_state_is_hex`, `test_generate_state_is_64_hex_chars`,
  `test_generate_state_is_not_deterministic`) cover the post-migration code path identically.
- New feature flags: default feature set change is net-neutral (see migration assessment Q4).
- New ADR: the bump is an implementation detail, not an architectural decision. The Dependabot
  cooldown governance (PR #412) is the new policy; an ADR for a one-shot semver rename migration
  is not warranted.
- Changing CLAUDE.md: no new gotchas introduced; the migration is complete after the three edits.
- MSRV bump: not required (both project and rand 0.10 are already at 1.85 / Edition 2024).

---

## Impact Boundary Map (Step 3 Deliverable)

### Component classification

| Component | Class | Reason |
|-----------|-------|--------|
| `src/api/auth.rs::generate_state` (lines 1093-1106) | MODIFIED | 2 symbol renames in function body (`TryRngCore → TryRng`, `OsRng → SysRng`) |
| `src/api/auth.rs` rustdoc (lines 1077-1078) | MODIFIED | 1 symbol name in prose (`OsRng → SysRng`) |
| `Cargo.toml` (line 34) | MODIFIED | Version specifier `"0.9"` → `"0.10"` |
| `deny.toml` | MODIFIED | Add `[[bans.skip]]` entries for dual rand 0.9 + rand 0.10 presence; likely also `rand_core 0.9` + `rand_core 0.10` (verify with `cargo tree -d` after bump) |
| `Cargo.lock` | MODIFIED | Resolved automatically by Cargo on bump; PR #327 lockfile already reflects this |
| `src/api/auth.rs` tests (lines 1185-1224) | DEPENDENT | No code change; existing 3 tests exercise the renamed API path identically post-migration |
| All other `src/*` files | UNCHANGED | No `rand` imports or call sites outside `auth.rs` (grep-verified by migration assessment) |
| All `tests/*` integration test files | UNCHANGED | No direct `rand` usage in integration tests |
| `.github/`, `scripts/`, `.factory/specs/` | UNCHANGED | Out of implementation scope |

### Affected-file count: 4 modified (auth.rs, Cargo.toml, deny.toml, Cargo.lock) + 1 dependent

---

## Architecture Change Assessment

**NONE.** This is a pure API-rename migration within a single module. The architectural elements
are fully preserved:

- Same crate (`rand`): the dependency relationship is unchanged.
- Same OS CSPRNG path: `SysRng` is a hard rename of `OsRng`, both being zero-sized structs
  delegating to `getrandom::getrandom(2)` / `BCryptGenRandom`.
- Same error-propagation pattern: `try_fill_bytes → anyhow::Context::context → ?`.
- Same entropy strength: 256 bits, rendered as 64 hex characters.
- Same CSRF protection guarantee for the OAuth 2.0 authorization-code flow.
- Purity boundary: `generate_state` was and remains an effectful shell function (OS syscall),
  correctly placed outside any pure core. No reclassification needed.
- Module criticality classification unchanged: `src/api/auth.rs` is already classified for the
  OAuth/security path; this migration does not change that classification.

**No new ADR required.** ADR-0002/ADR-0006 cover the OAuth approach. The `rand` library is an
implementation detail of the CSRF state generation, not an architectural decision. The
Dependabot cooldown governance policy (merged in PR #412's `dependabot.yml` changes) is the
governing policy for when bumps like this are accepted; recording it again in an ADR would be
redundant.

---

## Interaction Analysis: deny.toml Scope

The migration assessment (Q6) establishes that after the bump, two versions of `rand` will
coexist in the lockfile:

- `rand 0.10.x` — pulled by `jr` directly
- `rand 0.9.4` — pulled transitively by `proptest 1.x` (dev-dep) and `quinn-proto` (via
  reqwest/rustls)

`deny.toml` currently enforces `multiple-versions = "deny"` (line 21). Without `[[bans.skip]]`
entries, `cargo deny check` fails. The existing skip-list pattern (pairs of entries, one per
version, each with a documented root cause and blocking upstream) applies directly. The
migration assessment provides draft `[[bans.skip]]` text for `rand 0.9` and `rand 0.10`.

Additionally, `rand_core 0.9` (used by rand 0.9 internals) and `rand_core 0.10` (used by rand
0.10 internals) may also require paired skip entries — this must be confirmed with
`cargo tree -d -i rand_core` after the bump. The migration assessment anticipates this.

The existing `getrandom` skip entries (0.2, 0.3, 0.4 — three-way split, already documented) are
unaffected by this bump.

---

## Security Assessment

**The 0.10.1 soundness issue (GHSA-cq8v-f236-94qc / RUSTSEC-2026-0097) does NOT affect this
codebase.** The vulnerability requires all four of: `log` feature enabled, a custom log logger
installed, that logger invoking `rand::rng()` (ThreadRng), and a reseed during the borrow.
`jr` never enables the `log` feature of `rand`, never installs a custom logger that calls
`rand::rng()`, and never uses `ThreadRng`. The `generate_state` function uses only `SysRng`
(the renamed `OsRng`), which is explicitly not affected. GitHub Advisory severity is Low; no
CVE was assigned. This bump is motivated by dependency hygiene and the 7-day soak passage, not
by a security obligation to patch GHSA-cq8v-f236-94qc.

---

## Regression Risk Assessment

**LOW.** Three dimensions:

1. **Code change surface:** 2 symbol renames + 1 rustdoc update across 6 lines. No logic change,
   no new branch, no new error path.
2. **Existing test coverage:** The three `generate_state` unit tests at lines 1185-1224 exercise
   the renamed API path identically post-migration. `test_generate_state_is_not_deterministic`
   in particular catches any catastrophic CSPRNG misconfiguration (8 distinct outputs from 8
   calls with 256-bit entropy).
3. **Build verification:** `cargo build` confirms symbol resolution; `cargo clippy -- -D warnings`
   confirms no deprecation leakage; `cargo deny check` confirms the skip entries are correct.

**No new tests required.** The existing coverage is complete for the renamed path.

---

## BC Mapping (from BA)

BA reviewed 5 BCs in `.factory/specs/prd/bc-1-auth-identity.md` that touch the OAuth login /
`generate_state` path. All are `unchanged`.

| BC ID | Summary | File | Disposition |
|-------|---------|------|-------------|
| BC-1.5.035 | `generate_state()` produces 32 bytes from OsRng encoded as 64 hex chars | `bc-1-auth-identity.md` line 395 | **unchanged** — behavioral claim (32 bytes, 64 hex chars, OS CSPRNG) is preserved; only the Rust type name underneath changes |
| BC-1.5.040 | OAuth callback validates state (CSRF check) before token exchange | `bc-1-auth-identity.md` line 445 | **unchanged** — CSRF check logic at `src/api/auth.rs:898` does not depend on which RNG generated the state |
| BC-1.5.031 | Embedded OAuth callback URL is exactly `http://127.0.0.1:53682/callback` | `bc-1-auth-identity.md` line 355 | **unchanged** — not touched by migration |
| BC-1.5.039 | OAuth token stored post-login under per-profile keychain keys | `bc-1-auth-identity.md` line 435 | **unchanged** — token storage path is distinct from `generate_state` |
| BC-1.3.023 | `DEFAULT_OAUTH_SCOPES` includes `offline_access`, CMDB scopes, write scopes | `bc-1-auth-identity.md` line 264 | **unchanged** — scope constant at lines 34-63, migration only edits lines 1074-1106 |

BA's exhaustive search of `.factory/specs/` for `OsRng`, `SysRng`, `TryRngCore`, `TryRng`,
`generate_state`, `CSRF`, `rand`, and `entropy` found no additional behavioral contracts in any
other BC file.

**Cosmetic description drift — flagged for F2:** BC-1.5.035 reads "produces 32 bytes from OsRng
encoded as 64 hex chars." Post-migration the Rust type is `SysRng`. This is an implementation-
detail reference in a behavioral description — the BC claim itself (32 bytes, 64 hex chars) is
accurate under either type name. BA recommends leaving it as-is (Option A); updating to
"`SysRng` (formerly `OsRng`)" is optional. Either way the BC disposition is `unchanged`. F2
spec-evolution pass should record the explicit decision.

**No new BCs.** No BC count drift. `scripts/check-spec-counts.sh` and
`scripts/check-bc-cumulative-counts.sh` are unaffected; no spec file is modified.

## VP Extension Assessment (from BA)

**None — VP infrastructure does not exist in this project.** BA confirmed:

- `.factory/specs/verification-properties/` directory does not exist.
- No `VP-` identifiers appear in any `.factory/**/*.md` file.
- No NFR catalog entries for entropy or CSPRNG.
- The closest related holdout (H-047, multi-cloudId disambiguation / CSRF state validation path)
  is MUST-PASS and unaffected.

The 32-byte entropy invariant is implicitly captured by BC-1.5.035 and the three unit tests.
No formal VP artifact exists that governs `generate_state`; there is nothing to extend.

---

## Story Risk Zone (from BA)

BA identified 6 completed/merged stories whose tests touch `src/api/auth.rs` or exercise
`oauth_login` (which calls `generate_state` at line 577). All are currently green on `develop`;
their tests must remain green post-migration.

| Story ID | Relevance | Status |
|----------|-----------|--------|
| S-1.06 (OAuth flow holdouts) | Anchors BC-1.1.001, BC-1.1.002; test suite exercises `oauth_login` path that calls `generate_state` | merged (PR #300) |
| S-1.08 (keychain per-profile layout holdout) | Tests token storage/retrieval in `src/api/auth.rs` | merged (PR #302) |
| S-3.01 (auth.rs shard-split) | Regression-tested against BC-1.1.001, BC-1.4.027, BC-7.4.013-016 | completed (PR #319) |
| S-3.03 (refresh_oauth_token wiring) | Anchors BC-1.4.026; edits refresh path in same file | completed (PR #321) |
| S-3.04 (multi-cloudId disambiguation) | Anchors BC-1.5.038, BC-1.1.007, BC-1.5.031; edits `oauth_login` directly | completed (PR #320) |
| issue-288-pr4-dispatch (JSM dispatch + OAuth scope addition) | Modifies `DEFAULT_OAUTH_SCOPES`; adds BC-1.3.023 scope pin | completed (PR #381) |

All remain in the regression zone. The compiler catches symbol-rename failures at `cargo build`;
the unit tests catch CSPRNG behavioral regressions. Aligns with LOW regression risk rating.

---

## Estimation

| Dimension | Value |
|-----------|-------|
| Story points | 1 (sub-sprint: 4 edits across 3 files; no test authoring) |
| Module criticality | HIGH (auth.rs is security-path; `generate_state` is directly in OAuth CSRF protection) |
| Estimated LOC | +4 / -2 in `src/api/auth.rs`; +1 / -1 in `Cargo.toml`; +14 to +28 in `deny.toml` |
| Strategy | Direct migration — no TDD phase (no behavioral change to drive; existing tests cover post-migration path) |

---

## Recommended Scope for Subsequent Phases

The user explicitly requested the full F1-F7 VSDD feature-mode cycle. Follow it. However, several
phases have reduced or near-zero workload for this delta:

| Phase | Workload | Notes |
|-------|----------|-------|
| **F1** (this document) | Done | Delta analysis complete |
| **F2 — Spec Evolution** | Near-zero | No new BCs. Artifacts: (1) explicit "no ADR required" decision record; (2) BC-1.5.035 cosmetic drift decision — record whether to update "OsRng" → "SysRng" in BC body (Option A = leave as-is; Option B = update). Either choice is one line; the BC disposition is `unchanged` under both. F2 is otherwise a no-op. |
| **F3 — Incremental Stories** | Minimal | One story: "Bump rand 0.9 → 0.10: rename OsRng/TryRngCore in auth.rs + deny.toml skip entries." Single-point story. Decompose produces a single implementation task, not multiple parallel stories. |
| **F4 — Delta Implementation (TDD)** | Small | 4 file edits. Verification: `cargo build`, `cargo test --lib api::auth::tests`, `cargo clippy`, `cargo deny check`. No new tests written (existing 3 tests cover post-migration path). Implementation should take <30 min. |
| **F5 — Scoped Adversarial Review** | Minimal | Review surface is 4 edits. Adversarial checks: (a) confirm `SysRng` is not a deprecated alias for something else in 0.10.1, (b) confirm `TryRng` trait is fully in scope without a `use` statement conflict, (c) confirm `deny.toml` skip reasons correctly attribute the transitive roots. Likely a 10-15 min review pass. |
| **F6 — Targeted Hardening** | Likely no-op | No production logic changed. No new error paths. No new concurrency surface. If F5 surfaces a finding, F6 addresses it; otherwise, F6 records "no hardening required." |
| **F7 — Delta Convergence + PR Merge** | Standard | Merge the feature branch into develop, then develop → main for release. Use a new `feat/rand-0.10-migration` branch per project convention — the Dependabot PR #327 branch (`dependabot/cargo/rand-0.10.1`) does not follow the `type/short-description` format (see Q1 in Open Questions). |

---

## Open Questions for Human Gate

| # | Question | Recommendation | Blocking? |
|---|----------|---------------|-----------|
| Q1 | Use Dependabot PR #327 branch directly, or create a new `maintenance/rand-0.10-migration` branch per project convention? | Create new branch per convention — the Dependabot PR branch name (`dependabot/cargo/rand-0.10.1`) does not follow the project's `type/short-description` format | YES — F4 branch setup |
| Q2 | Should `deny.toml` skip entries also cover `rand_core 0.9` + `rand_core 0.10`? | Yes, if `cargo tree -d -i rand_core` shows dual presence post-bump (very likely — verify at F4 start) | No — self-resolving at F4 |
| Q3 | Confirm no ADR required for this bump? | Confirmed — see Architecture Change Assessment above | No (recommendation clear) |

---

## Quality Gate Self-Check

| Criterion | Status | Evidence |
|-----------|--------|----------|
| Every touched component has a class (MODIFIED / DEPENDENT / UNCHANGED) | ✅ | Impact Boundary Map table above — 4 MODIFIED + 1 DEPENDENT + remainder UNCHANGED |
| Scope is bounded (no scope creep into unrelated files) | ✅ | 4 files maximum; no tests need authoring; no CLAUDE.md change |
| Architecture change assessment is explicit | ✅ | "NONE" — same crate, same OS CSPRNG path, same error propagation; purity boundary unchanged |
| ADR requirement assessed | ✅ | No new ADR — migration is implementation detail; governance covered by PR #412 cooldown policy |
| Regression risk is rated with supporting evidence | ✅ | LOW — 2 symbol renames, existing 3 unit tests cover post-migration path identically |
| Security assessment is explicit | ✅ | GHSA-cq8v-f236-94qc: not applicable to our code path (no ThreadRng, no log feature, no custom logger) |
| New BC / VP count is explicit | ✅ | None — pure API rename, no behavioral contract change |
| Estimation is provided | ✅ | 1 story point; <30 LOC; HIGH module criticality (auth/security path) |
| BA input integrated | ✅ | BA input received and fully integrated: BC mapping (BC-1.5.035 unchanged + 4 adjacent BCs), story risk zone (6 stories), VP extension (N/A — no VP infrastructure), intent reconciled to `enhancement`, deny.toml posture confirmed |
| Recommended phase scope is explicit | ✅ | Full F1-F7 per user request; near-no-op phases identified (F2, F6) |
| No source code modified by this F1 document | ✅ | This is analysis only; `src/`, `tests/`, `Cargo.toml`, `deny.toml` untouched |

---

## Reconciliation Log

Integrated from `business-analyst-input.md` (received 2026-05-26, same session):

| # | Item | Action taken |
|---|------|-------------|
| 1 | **BC mapping** — BA found BC-1.5.035 as the single directly covering BC; reviewed 4 adjacent BCs (1.5.040, 1.5.031, 1.5.039, 1.3.023). All `unchanged`. | Added full "BC Mapping (from BA)" section with 5-row table; replaced prior placeholder text in "New BCs / VPs Required." |
| 2 | **Cosmetic drift in BC-1.5.035** — "OsRng" text in BC body is an implementation-detail reference; behavioral claim unchanged. | Flagged for F2 decision (Option A = leave as-is recommended; Option B = update to `SysRng`). Updated F2 phase workload description accordingly. |
| 3 | **Story risk zone** — 6 completed stories in regression zone: S-1.06, S-1.08, S-3.01, S-3.03, S-3.04, issue-288-pr4-dispatch. | Added "Story Risk Zone (from BA)" section with full 6-row table. Confirmed alignment with LOW regression risk. |
| 4 | **Test coverage map** — BA confirmed exactly 3 unit tests; `tests/oauth_embedded_login.rs` is `#[ignore]`'d / `unimplemented!()`; no new tests required. | Existing "Regression Risk Assessment" section already covered this; no text change needed (BA confirmation noted in Reconciliation Log only). |
| 5 | **VP extension — N/A** — no `.factory/specs/verification-properties/` directory and no `VP-` identifiers exist in this project. | Added "VP Extension Assessment (from BA)" section explicitly stating no VP infrastructure exists; removed generic "VP-or-test" hedge from prior draft. |
| 6 | **Intent reconciled to `enhancement`** — project convention: all 4 prior F1s use `enhancement`; BA's convention argument wins over a new `maintenance` label. | Changed frontmatter `intent: maintenance` → `intent: enhancement`; rewrote "Intent Classification" body to reflect the convention rationale. |
| 7 | **deny.toml posture confirmed** — `chacha20` and `cpufeatures` (new rand 0.10 transitives) are single-version, no skip entry needed; `rand_core 0.9` + `rand_core 0.10` still need confirmation with `cargo tree -d -i rand_core` at F4 start. | No change to prior analysis; BA confirmation noted here. Open Question Q2 preserved. |
