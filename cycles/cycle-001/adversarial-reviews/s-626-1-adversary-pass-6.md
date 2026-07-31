---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-07-31T02:00:00Z
phase: 5
inputs:
  - .factory/stories/S-626-1.md
  - .github/workflows/ci.yml
  - .github/workflows/sign-and-publish.yml
  - .github/workflows/backfill-release.yml
  - .github/workflows/release.yml
  - .github/workflows/e2e.yml
  - Cargo.toml
  - Cargo.lock
  - CHANGELOG.md
  - CLAUDE.md
  - src/cli/board.rs
  - src/cli/issue/list.rs
  - src/cli/auth/keychain.rs
  - tests/team_column_parity.rs
input-hash: "48f780c"
traces_to: .factory/stories/S-626-1.md
story: S-626-1
cycle: cycle-001
pass: 6
agent: adversary
basis: TRUE ADVERSARY AGENT
date: 2026-07-31
feature_head: 64e2a4bcde44ec20bc1f64d80eb402ca8aebc406
pr: 667
verdict: NOT CLEAN — 3 HIGH + 3 MEDIUM + 2 LOW + 2 INFO; zero code defects
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-5.md
isolation: CLEAN
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 6

## Provenance

This artifact is a **DIRECT CAPTURE** of adversary reviewer output relayed by the orchestrator, recorded same-session. It is NOT a post-hoc reconstruction like pass-5. The reviewer's findings were relayed verbatim; the orchestrator recorded them immediately after the pass completed.

**Policy rubric:** `.factory/policies.yaml` does not exist. Baseline applied.

---

## Preflight

Feature HEAD verified: `64e2a4bcde44ec20bc1f64d80eb402ca8aebc406` — 12 commits over merge-base `acdad17427a057d1e022669303cb80d5f48449c9`. Factory HEAD on factory-artifacts branch. Inputs read directly from the product tree and story file.

**Isolation: CLEAN.** No banned-path file read. No prior adversary pass artifacts accessed.

---

## H-001 HIGH — Story anchors zero BCs/VPs while rewriting BC-5.3.001/002 production code and extending their canonical test vehicle
**GAP · in-delta**

`S-626-1.md` frontmatter declares `bcs: []` and `verification_properties: []`. The story's F4 delivery rewrote three let-chain sites in production code including `src/cli/board.rs` and `src/cli/issue/list.rs`, which are the primary implementation vehicles for BC-5.3.001 (Board team-column display) and BC-5.3.002 (Issue list team-column display). It also extended `tests/team_column_parity.rs` with two new test functions `test_board_view_omits_team_column_when_field_unconfigured` and `test_issue_list_omits_team_column_when_field_unconfigured` that are explicitly the canonical test vehicle for BC-5.3.002.

A story that directly modifies the production implementation of named behavioral contracts and adds new tests for those contracts while declaring empty BC and VP anchors is a traceability gap. The VSDD traceability model requires story-to-contract anchoring so that a reader can traverse from story → contract → test.

**Severity rationale:** HIGH because it affects the formal traceability structure of a delivered story. The code is correct; the anchoring is absent.

---

## H-002 HIGH — `subsystems: ["SS-11"]` dangling — registry stops at SS-09; blast radius 5 story files
**GAP · in-delta (pre-existing anchor + newly-introduced instances)**

`S-626-1.md:subsystems: ["SS-11"]` references a subsystem ID that does not exist in the registry (`ARCH-INDEX.md`). The architecture registry defines subsystems through SS-09 only; SS-10 and SS-11 are unregistered. The blast radius extends to five story files: `S-626-1.md`, `S-627-1.md`, `S-640-1.md`, `S-641-1.md`, and `S-576-5.md` — all carry `"SS-11"` or reference it.

The real owning subsystems for S-626-1's deliverables are SS-09 (CI/CD pipeline infrastructure, which owns the msrv job and `.github/workflows/ci.yml`) and SS-02 (issue and board display layer, which owns `src/cli/board.rs` and `src/cli/issue/list.rs`). These are both registered in ARCH-INDEX.md. Using an unregistered phantom anchor leaves the story in a state where automation or tooling that validates subsystem anchors would reject it.

**Severity rationale:** HIGH because SS-11 is unresolvable from the registry; the blast radius is 5 story files; and the correct anchors (SS-02, SS-09) are both determinable from the story content.

---

## H-003 HIGH [process-gap] — MSRV job has no positive-coverage assertion
**PROCESS-GAP · in-delta**

The `msrv` job in `.github/workflows/ci.yml` runs `cargo check --all-targets --locked` under `RUSTUP_TOOLCHAIN: 1.85.0`. It exits 0 when the check passes. However: if someone deleted lines 85-86 (the `RUSTUP_TOOLCHAIN` environment injection), the job would still exit 0 — it would simply run `cargo check` under whatever stable toolchain the runner provides. There is no step in the msrv job that:
1. Prints the actual rustc version being used, or
2. Asserts that the version string matches `1.85.0` before proceeding, or
3. Would fail if `RUSTUP_TOOLCHAIN` were absent or pointed at the wrong toolchain.

Every sibling guard in this codebase emits runtime-computed coverage. The injection guard in `check-spec-counts.sh` has a negative-fixture `--self-test` path. The MSRV guard is uniquely among them a trust-but-never-verify design: the env-var is injected and assumed correct, never confirmed.

The **consequence** is a live false-green class: a CI maintainer could comment out the `env:` block or introduce a regression to the toolchain env injection, and the `msrv` job would continue to report SUCCESS while validating against stable (not 1.85.0).

**Severity rationale:** HIGH [process-gap] because this is a structural gap in the guard's self-validation, not just a style issue. The msrv job's correctness depends on an unverified assumption. Two other reviewers independently raised this in the same window.

---

## M-001 MEDIUM — CLAUDE.md:219 asserts the pinned action "validates `toolchain:` as a hard-required input"; GitHub Actions does not enforce required action inputs
**GAP · in-delta (introduced by ADV-P2-LOW-001 fix)**

`CLAUDE.md:219` (in the CI gotcha added by commit `15597e84`) reads: *"The pinned `dtolnay/rust-toolchain` action validates `toolchain:` as a hard-required input…"*. This is a statement about GitHub Actions input validation. GitHub Actions does NOT enforce `required: true` on action inputs — this is a known platform limitation (GitHub runner issue #1070). The action's `action.yml` implements its own guard (an explicit shell check that exits 1 when `toolchain` is empty), but this is an action-level guard, not a platform enforcement.

The claim as written implies GitHub performs the validation; the correct claim is that the action performs it. An implementer reading this and relying on platform-level enforcement for other actions in the future would be misled. This is the same shape as the unverified claim finding — per the story's own provenance rule, a claim about mechanism must survive a reading of the source artifact.

**Severity rationale:** MEDIUM because it's an inaccurate claim in an authoritative reference document, not merely cosmetic.

---

## M-002 MEDIUM — `# 1.85.0` / `# stable` trailing comments now denote the toolchain input, not the pinned action version — ambiguous semantics at 7 sites
**REFINEMENT · in-delta**

Seven sites in `ci.yml`, `release.yml`, `backfill-release.yml`, `sign-and-publish.yml` carry trailing comments of the form `# 1.85.0` or `# stable` on the dtolnay/rust-toolchain SHA pin line. Every other 40-char SHA pin in these workflows carries a comment that names the **action** version: `# v7.0.1`, `# v2`, `# v2.20.0`, `# v6`, `# v3.0.0`. The dtolnay pin is now the only one whose comment names the toolchain input rather than the action version — the comment answered a different question (what toolchain is configured) rather than the canonical question (which action release is this SHA).

The opacity that let a version-branch SHA masquerade as a master pin for 84+ F2 passes was rooted in this exact annotation pattern. ADV-P4-LOW-004 noted this; it was routed to S-641-1 but S-641-1's ACs do not explicitly require fixing the comment semantics. The convention remains inconsistent at 7 sites.

**Severity rationale:** MEDIUM because the inconsistency is load-bearing to the understanding that enables pin-audit, and the number of sites (7) means the pattern is entrenched.

---

## M-003 MEDIUM [process-gap] — "No let-chains" declared with no enforcement over inline `#[cfg(test)]` modules in `src/` or any of `tests/`
**PROCESS-GAP · in-delta**

CLAUDE.md Conventions now states "No let-chains" and correctly notes that "inline `#[cfg(test)]` modules in `src/` and integration tests in `tests/`" are outside the msrv job's enforceable scope. However, this gap is acknowledged without providing any alternative enforcement mechanism for those code regions. An implementer working on a test in `tests/` or writing an inline `#[cfg(test)]` block in a source file could introduce a let-chain without any CI check catching it.

The `msrv` job runs `cargo check --all-targets --locked` which, because `wiremock 0.6.x` dev-deps require Rust ≥1.88, cannot compile `tests/` or `#[cfg(test)]` blocks at 1.85.0. This is an acknowledged gap, but no compensating control was introduced (e.g., `grep -E '(if|while) let .* &&|&& let'` in `tests/` as a clippy-adjacent check, or a note in the `test`/`check --tests` steps).

**Severity rationale:** MEDIUM [process-gap] because the convention is stated without any enforcement backstop for the portions it cannot cover.

---

## L-001 LOW — AC-9's "only mutation-detecting coverage" claim is false — none of the 3 files appear in `.cargo/mutants.toml` examine_globs
**GAP · spec artifact**

`S-626-1.md AC-9` describes the two new tests as providing "mutation-detecting regression-detecting integration coverage" (after v1.7 amendment). However, `src/cli/board.rs`, `src/cli/issue/list.rs`, and `tests/team_column_parity.rs` are not present in `.cargo/mutants.toml` examine_globs. Under the project's cargo-mutants policy, files must be explicitly in examine_globs to generate mutants. With zero examine_globs entries for these files, the mutation testing run would generate **0 mutants** for the changed code — making the "mutation-detecting" characterization false.

**Severity rationale:** LOW because it's a characterization error in a spec artifact, not a code defect. The tests are correct; the label is inaccurate.

---

## L-002 LOW — BC-5.3.004 Source citation displaced +108 lines by the S-626-1 insertion; `:380` was already stale on develop
**REFINEMENT · spec artifact**

`bc-5-boards-sprints.md` BC-5.3.004's `Source:` field cites `src/cli/issue/list.rs:380`. The S-626-1 delivery added a full team-column rendering block (~108 LOC) to `list.rs`, pushing all subsequent line numbers down by at least that amount. The citation `:380` was already stale on the `develop` branch before S-626-1 — it points at `fn handle_list` body code that has drifted over prior cycles. The insertion makes the displacement definite and measurable.

Per the project's citation-form convention (#408), citations should use symbol-form (`fn handle_list` or `list.rs::handle_list`) rather than line numbers. All four BC-5.3.00x Source/Trace fields should be updated to symbol-form to eliminate citation drift.

**Severity rationale:** LOW because it's a documentation/citation form issue. The code is correct.

---

## INFO-001 — `Swatinem/rust-cache` in msrv job keys on toml-resolved stable `rustc -vV` → cache dilution only, not a false-green vector
**INFORMATIONAL**

The msrv job uses `Swatinem/rust-cache` without a custom key. `rust-cache` auto-key derivation calls `rustc -vV` under the active toolchain to obtain the version hash. Since `RUSTUP_TOOLCHAIN=1.85.0` is set, this should key on 1.85.0, not stable — however if the `env:` block is ever removed (see H-003), the cache key would silently shift to the stable toolchain version. This is a cache-dilution hazard under the H-003 false-green scenario, not an independent false-green vector: cargo's fingerprint includes the rustc version, so an incorrect-toolchain cache hit would produce a rebuild, not a silent reuse.

**Informational only.** No fix action required unless H-003 is addressed.

---

## INFO-002 — `--locked` added to msrv `cargo check` is undeclared by any AC but correct
**INFORMATIONAL**

Commit `20d533e4` added `--locked` to the msrv job's `cargo check` invocation. No AC in `S-626-1.md` requires this. The addition is strictly correct (it ensures the check validates the committed `Cargo.lock` rather than resolving deps at runtime, which was ADV-P1-MEDIUM-003), but its absence from the ACs means the story's acceptance evidence does not cover it.

**Informational only.** No fix action required; the addition is beneficial and should be noted in S-641-1 or future AC coverage.

---

## Verified Clean — Claims Checked and Found Accurate

**All three let-chain rewrites semantically equivalent.** The adversary independently verified:
- `board.rs` nested-if rewrite: `if A && let Some(x) = B { I } else { E }` → `if A { if let Some(x) = B { I } else { E } } else { E }`. Short-circuit order preserved; `E = Vec::new()` in both arms.
- `list.rs` nested-if rewrite: same pattern. `Option<&str>` Copy semantics not affected — the binding `x` is a `&str` copy, not a reference to a moved value, so the restructuring does not change lifetime constraints.
- `keychain.rs` else-less fall-through: `if let Ok(v) = std::env::var(env_name) && !v.is_empty() { return Ok(v); }` → `if let Ok(v) = std::env::var(env_name) { if !v.is_empty() { return Ok(v); } }`. Fall-through behavior preserved; no else branch existed; semantics identical.

**Four-form let-chain pattern sweep.** The complete four-form set (`&& let`; `^\s*&&`; `(if|while) let .*=.*&&`; `^\s*||`) was run across `src/`, `tests/`, and `build.rs`. Zero let-chain occurrences found. Cross-validated as non-vacuous: on `develop` branch the three known sites (`board.rs`, `list.rs`, `keychain.rs`) appear in the pattern output, confirming the grep is not silent on a true positive.

**MSRV check exit 0 at 1.85.0.** `RUSTUP_TOOLCHAIN=1.85.0 cargo check --all-targets --locked` exits 0. `rustc 1.85.0 (4d91de4e4 2025-02-17)` confirmed active.

---

## Round-6 Dispositions (orchestrator, 2026-07-31)

- **Routed to `.factory/` fix round:** H-001 (story BC/VP anchoring — S-626-1.md bcs: ["BC-5.3.001","BC-5.3.002"]); H-002 (SS-11 → SS-02+SS-09 across 5 story files); L-001 (AC-9 wording: "mutation-detecting" → "regression-detecting integration coverage"); L-002 (BC-5.3.00x Source/Trace → symbol-form).
- **Routed to S-641-1:** H-003 (msrv positive-coverage assertion — matches S-641-1 AC-1/AC-2 scope per DEC-199..DEC-202 adjudication).
- **Noted / accepted:** M-001 (CLAUDE.md action-input claim — accepted as low-consequence inaccuracy; noted in Drift); M-002 (pin comment semantics — routed to S-641-1 LOW-004 already); M-003 (enforcement gap acknowledged per existing drift item); INFO-001 (cache dilution; accepted); INFO-002 (--locked undeclared; noted in S-641-1).
- **Convergence: Step 4.5 window RESET.** Pass-6 has H-class findings and non-trivial spec-artifact gaps. Window 0/3 (counting from pass-6).

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 3 |
| MEDIUM | 3 |
| LOW | 2 |
| INFO | 2 |

**Overall Assessment:** NOT CLEAN — 3 HIGH + 3 MEDIUM + 2 LOW + 2 INFO; zero code defects. Policy rubric ABSENT (`.factory/policies.yaml` does not exist) — baseline applied.

**Convergence: 0/3.** Step 4.5 window reset. DEC-199 (human ruling 2026-07-31): GRIND TO A LITERAL 3/3 CLEAN WINDOW per DEC-191(b).

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 6 |
| **New findings** | 10 (3 HIGH + 3 MEDIUM + 2 LOW + 2 INFO) |
| **Duplicate/variant findings** | H-002 subsumes ADV-P4-LOW-004 ss-anchor framing; H-003 subsumes ADV-P1-MEDIUM-004/ADV-P2-MEDIUM-003 msrv-coverage framing at sharper severity |
| **Median severity** | MEDIUM |
| **Trajectory** | pass 1 (5M+5L+3I) → pass 2 (3M+2L+2I) → pass 3 (3M+3L+2I) → pass 4 (0M+4L+1I) → pass 5 (0M+2L+1I) → pass 6 (3H+3M+2L+2I) |
| **Verdict** | NOT CLEAN — 3 HIGH + 3 MEDIUM + 2 LOW + 2 INFO; zero code defects; severity REGRESSED from pass-5 LOW ceiling; step 4.5 window RESET |
