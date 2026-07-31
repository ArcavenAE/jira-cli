---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-07-31T03:00:00Z
phase: 5
inputs:
  - .factory/stories/S-626-1.md
  - .github/workflows/ci.yml
  - .github/workflows/sign-and-publish.yml
  - .github/workflows/backfill-release.yml
  - .github/workflows/release.yml
  - Cargo.toml
  - Cargo.lock
  - CHANGELOG.md
  - CLAUDE.md
  - src/cli/board.rs
  - src/cli/issue/list.rs
  - src/cli/auth/keychain.rs
  - tests/team_column_parity.rs
input-hash: "af6f563"
traces_to: .factory/stories/S-626-1.md
story: S-626-1
cycle: cycle-001
pass: 7
agent: adversary
basis: TRUE ADVERSARY AGENT
date: 2026-07-31
feature_head: 64e2a4bcde44ec20bc1f64d80eb402ca8aebc406
pr: 667
verdict: NOT CLEAN — 3 HIGH + 4 MEDIUM + 5 LOW + 1 INFO; zero code defects
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-6.md
isolation: PARTIAL
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 7

## Provenance

This artifact is a **DIRECT CAPTURE** of adversary reviewer output relayed by the orchestrator, recorded same-session. It is NOT a post-hoc reconstruction like pass-5. The reviewer's findings were relayed verbatim.

**Policy rubric:** `.factory/policies.yaml` does not exist. Baseline applied.

---

## Isolation Disclosure

**PARTIAL isolation.** A broad grep for `team_column_parity` scoped at `.factory/` returned approximately 8 one-line incidental matches. The **paths** of the matched files were visible (some were pass-1 through pass-5 artifacts, ADV-P1-INDEX, and spec-changelog). The reviewer:
- Did NOT open any of those files.
- Did NOT follow up on any content from those matches.
- Deliberately excluded findings those snippets might have referenced (test-file CREATE→MODIFY classification, missing unconfigured-field tests).

This is self-disclosed unprompted. The broad grep for `team_column_parity` across `.factory/` should have been scoped to exclude `adversarial-reviews/` — see REVIEW-ISOLATION-NOT-MECHANICALLY-ENFORCED drift item.

---

## Preflight

Feature HEAD verified: `64e2a4bcde44ec20bc1f64d80eb402ca8aebc406`. Factory HEAD on factory-artifacts branch verified. All input files read. Isolation partial per disclosure above.

---

## F-01 HIGH — `subsystems: ["SS-11"]` phantom anchor — registry stops at SS-09
**GAP · in-delta (5-story blast radius)**

Same class as pass-6 H-002. Independent verification: `ARCH-INDEX.md` enumerates subsystems through SS-09. `SS-11` is unregistered. Five stories carry it: `S-626-1.md`, `S-627-1.md`, `S-640-1.md`, `S-641-1.md`, `S-576-5.md`. The real owning subsystems are SS-09 (CI/CD) and SS-02 (issue/board display layer). Cross-verified against `S-576-5.md:32`, which uses `SS-09` alongside `SS-11` — confirming `SS-11` is not shorthand for an existing subsystem. Intended meaning of `SS-11` is unrecoverable from any in-scope artifact.

---

## F-02 HIGH [process-gap] — MSRV job has no positive-coverage assertion — deleting the toolchain env var exits 0 silently
**PROCESS-GAP · in-delta**

Same class as pass-6 H-003. Independent verification confirms the gap is real: the msrv job in `ci.yml` has no step that prints or asserts the active rustc version string before `cargo check` runs. If `RUSTUP_TOOLCHAIN: 1.85.0` were removed from the `env:` block, the job would run `cargo check` against whatever stable toolchain is available on the runner, and the job would exit 0 with no indication of toolchain regression.

**Proposed fix (F-02 specific):** Derive the expected version from `Cargo.toml::rust-version` rather than a 4th hardcoded literal. A shell step can: (1) parse `rust-version` from `Cargo.toml` using `grep` or `cargo metadata`; (2) assert `rustc --version | grep -q "^rustc ${RUST_VERSION} "`. This derives the assertion from the canonical source rather than duplicating a string, and inherits the same `env: RUSTUP_TOOLCHAIN: 1.85.0` environment as the `cargo check` step.

---

## F-03 HIGH — UNIQUE TO PASS-7 — S-626-1 demo evidence set is stale vs delivered HEAD and is itself a FALSE-GREEN GENERATOR
**GAP · in-delta (most consequential finding of this round)**

The demo evidence in `.factory/demos/S-626-1/` was generated prior to the final fix round. Specific stale items confirmed:

1. **`AC-009.txt:39`** records filter `board_view_kanban_omits_team_col_when_field_unconfigured` and `issue_list_omits_team_col_when_field_unconfigured`. These match **zero delivered tests**. The actual test names are `test_board_view_omits_team_column_when_field_unconfigured` and `test_issue_list_omits_team_column_when_field_unconfigured`. Re-running AC-009's filter as-recorded yields: **`running 0 tests; 9 filtered out; EXIT 0`** — a false-green.

2. **`INDEX.md:5`** records `Head: b51fc26a`. The delivered HEAD on PR #667 is `64e2a4bc`. The INDEX documents evidence for a 10-commit-ago state.

3. **`AC-003.txt`** captures pre-`--locked` state and references wrong line numbers in `ci.yml` for the msrv job.

4. **`AC-002.txt`** mislabels the coverage job (line 112) as the test job (line 106) in the workflow.

**Blast radius:** 5 files (`AC-002.txt`, `AC-003.txt`, `AC-009.txt`, `full-suite.txt`, `INDEX.md`).

**Why this is HIGH:** The demo evidence is the primary artifact a human reviewer would use to validate AC-8 and AC-9 at the F7 gate. Stale demo evidence for a CI guard story produces false confidence. The filter-name mismatch in AC-009 means a session-handoff reviewer running the documented filter command would get `0 tests; exit 0` and conclude "tests pass" when they have actually found zero tests.

---

## F-04 MEDIUM — Headline AC-8/AC-9 acceptance proof is a 0.19s no-op with zero `Compiling` lines
**GAP · in-delta**

The primary acceptance proof for AC-8 and AC-9 (verifying the MSRV guard actually runs at 1.85.0) is described as running `RUSTUP_TOOLCHAIN=1.85.0 cargo check`. In a warm cache environment this produces a 0.19-second exit-0 with zero `Compiling` lines — the cargo cache was reused from a prior stable run.

A 0-second cache reuse cannot discriminate "validated at 1.85.0" from "warm stable cache reused." The guard's correctness requires observing that rustc 1.85.0 actually compiled the crate — which requires either a cold cache or a `cargo clean -p jr` prior to the check. Without a `Compiling jr (version)` line in the output, the acceptance proof is unobservable.

---

## F-05 MEDIUM — `INV-READ-009` still prescribes the deleted let-chain verbatim and now directly contradicts the new CLAUDE.md convention
**GAP · pre-existing exacerbated by in-delta**

`.factory/specs/domain-spec/bc-02-issue-read.md:121` (or vicinity, INV-READ-009) prescribes the implementation using let-chain syntax: something like `if let Some(team) = issue.fields.team && let Some(team_name) = team.name`. This let-chain was the bug that S-626-1 fixed. The domain spec still contains the prescription.

An implementer following `bc-02-issue-read.md` for future team-column display work would encounter a spec that (a) prescribes the banned pattern and (b) directly contradicts the new `CLAUDE.md` Conventions entry "No let-chains." The spec and the convention are now in direct conflict.

**Severity rationale:** MEDIUM because it creates an actionable contradiction in authoritative reference material, not just stale prose.

---

## F-06 MEDIUM — Empty BC and VP anchors are a traceability gap (same as pass-6 H-001)
**GAP · in-delta**

Independent verification of pass-6 H-001. `S-626-1.md` `bcs: []` and `verification_properties: []`. The story modifies BC-5.3.001/002 production code and extends the canonical BC-5.3.002 test vehicle. VSDD traceability model requires story-to-contract anchoring. Grounded in the project's own `X.13 CI Guards` (6 BCs) and `X.11 Build-Time` (5 BCs) families, which prove CI/build artifacts ARE contract-bearing in this project — refuting a "empty is correct for infrastructure" rationale.

The consequence already materialized: because no BC captured "msrv job must demonstrably run at the declared floor," the guard had to be invented afterward as a separate story (S-641-1). BC anchoring is not retroactive obligation — it is the mechanism that would have caught the gap at F1.

---

## F-07 MEDIUM [process-gap] — "No let-chains" unenforced over `#[cfg(test)]` modules and `tests/`
**PROCESS-GAP · in-delta**

Same as pass-6 M-003. Independent verification confirms the gap: the msrv job's `cargo check --all-targets` excludes integration tests and inline `#[cfg(test)]` code due to dev-dep Rust edition requirements. The CLAUDE.md convention acknowledges this but provides no compensating enforcement (no grep, no secondary check, no linting step that would catch a let-chain introduced in test code).

---

## F-08 LOW — AC-9 mutation-detecting claim false — files not in examine_globs
**GAP · spec artifact**

Same class as pass-6 L-001. Independent verification: `board.rs`, `list.rs`, and `tests/team_column_parity.rs` are absent from `.cargo/mutants.toml` examine_globs. Zero mutants generated for these files. AC-9 mutation-detecting characterization is inaccurate.

---

## F-09 LOW — `comfy-table = "=7.2.1"` exact pin has no dependabot `ignore` entry
**GAP · pre-existing (exacerbated by pin)**

The `=7.2.1` exact pin is the headline deliverable of S-626-1 — an MSRV-protective exact-version pin. Without a matching dependabot `ignore` entry for `comfy-table`, a dependabot run targeting the project's `Cargo.toml` would attempt to update the dependency and potentially replace `=7.2.1` with a caret range — silently undoing the exact-pin protection that S-626-1 delivered.

The project operates a daily-cadence cargo updater. The exact pin is currently unprotected from automated updates.

---

## F-10 LOW — CLAUDE.md "validates as a hard-required input" claim is not independently verifiable from outside the action
**REFINEMENT · in-delta**

Same class as pass-6 M-001. The claim in CLAUDE.md about action input enforcement is a step-1-only claim — it can be verified by reading the action's `action.yml`, which the pass-4 adversary did. But CLAUDE.md presents it as platform behavior ("GitHub Actions validates…") when it is action-behavior ("this specific action's guard validates…"). Future readers of CLAUDE.md who don't read the action source cannot independently confirm the claim.

---

## F-11 LOW — SHA trailing comments now annotate toolchain name, not action version — 7 sites
**REFINEMENT · pre-existing pattern touched in-delta**

Same as pass-6 M-002. Seven SHA pin lines carry `# 1.85.0` or `# stable` where every other pin in the same files carries the action version (`# v7.0.1`, etc.). The inconsistency makes pin audits harder and contributed to the version-branch SHA masquerading through the F2 window.

---

## F-12 INFO — Three undeclared-but-beneficial deliverables (--locked, CHANGELOG user-impact, in-code comments)
**INFORMATIONAL**

Three deliverables in PR #667 are beneficial and correctly implemented but not declared in any AC:
1. `--locked` added to msrv `cargo check` (addresses ADV-P1-MEDIUM-003, not in ACs).
2. `CHANGELOG.md` user-impact sentence for the comfy-table downgrade (mandated by Delivery Checklist but not by a named AC).
3. In-code comments at the three let-chain rewrite sites explaining the MSRV basis (authoring-ergonomics improvement beyond what any AC required).

All three improve the delivery. None would be caught by a mechanical AC-checking pass.

---

## F-13 MEDIUM [process-gap] PRE-EXISTING — `security` (gitleaks) job absent from `ci-gate.needs` so a secret-scan failure cannot block merge
**PROCESS-GAP · pre-existing, confirmed in-delta**

The `security` job (gitleaks secret scan) is absent from `ci-gate.needs`. The ci-gate aggregator pattern (S-CIGATE-1, DEC-102/103) requires all blocking checks to be in `ci-gate.needs`. With `security` absent, a gitleaks finding that would catch a committed secret cannot block a merge to develop or main. Additionally, the security job is PR-only — pushes to protected branches get no scan at all.

This is pre-existing, untouched by S-626-1. It is confirmed here as a live gap visible in the in-scope `ci.yml`. Recommended routing: a dedicated CI-governance story, NOT folded into SOH-DX-1.

---

## F-14 LOW — `check-bc-no-numeric-test-counts.sh` has a hardcoded pass line with no computed count assertion
**REFINEMENT · pre-existing**

The guard script exits 0 with a hardcoded "OK" message without computing a count. This is the same POL-11 shape that motivated several prior fixes in this window. The script functions as a presence-check rather than a computed-assertion.

---

## F-15 LOW — BC-5.3.00x Source/Trace citations use line-number form rather than symbol form
**REFINEMENT · spec artifact**

Same class as pass-6 L-002. The four BC-5.3.00x entries in `bc-5-boards-sprints.md` carry line-number citations that are stale or will drift on next refactor. The project's #408 citation-form convention requires symbol-form (`::fn_name`) for stability.

---

## Verified Clean

**All three let-chain rewrites semantically equivalent.** Same verification as pass-6: short-circuit order preserved; `Option<&str>` Copy semantics unaffected; `keychain.rs` else-less fall-through preserved.

**Four-form let-chain pattern sweep.** Run against `src/`, `tests/`, `build.rs` with all four forms. Zero let-chain occurrences found. Non-vacuous: confirms against develop branch where the three known sites appear.

**MSRV exit 0 at 1.85.0.** `cargo check --all-targets --locked` exits 0 under `rustc 1.85.0`.

---

## Round-7 Dispositions (orchestrator, 2026-07-31)

- **Routed to `.factory/` fix round:** F-01 (SS-11 → SS-02+SS-09 across 5 stories); F-03 (demo regeneration — AC-002/003/009/full-suite.txt/INDEX.md at HEAD 64e2a4bc with correct filter and `cargo clean` evidence); F-05 (INV-READ-009 behavioral restatement, let-chain prescription removed, symbol-form citation); F-06 (S-626-1 bcs anchoring); F-08 (AC-9 wording: "regression-detecting integration coverage"); F-11/F-15 (symbol-form citations in bc-5).
- **Routed to S-641-1:** F-02 (positive-coverage assertion — AC-1/AC-2 scope); F-04 (cold-cache demo evidence — relates to S-641-1 AC-2); F-09 (dependabot ignore entry); F-10 (CLAUDE.md action-input claim — LOW-004 already in S-641-1); F-12 (noted).
- **Confirmed pre-existing / noted in Drift:** F-13 (GITLEAKS-NOT-IN-CI-GATE-NEEDS added to Drift — dedicated CI-governance story recommended); F-07 (enforcement gap already in Drift); F-14 (script hardcoded-line; accepted LOW).
- **Convergence: 0/3.** Passes 6+7 both NOT CLEAN. Window continues under DEC-199 (GRIND to 3/3 CLEAN).

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 3 |
| MEDIUM | 4 |
| LOW | 5 |
| INFO | 1 |

**Overall Assessment:** NOT CLEAN — 3 HIGH + 4 MEDIUM + 5 LOW + 1 INFO; zero code defects. Policy rubric ABSENT (`.factory/policies.yaml` does not exist) — baseline applied.

**F-03 is the most consequential finding of this round:** stale demo evidence is a FALSE-GREEN GENERATOR — a session-handoff reviewer running the documented test filter would observe `0 tests; exit 0` and falsely conclude the acceptance test passed.

**Convergence: 0/3.** Two passes post-fix (passes 6+7), both NOT CLEAN.

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 7 |
| **New findings** | 13 (3H+4M+5L+1I across F-01..F-15; F-13 PRE-EXISTING confirmed) |
| **Novel vs pass-6** | F-03 (stale demos, FALSE-GREEN), F-04 (cache no-op proof), F-05 (INV-READ-009 contradiction), F-09 (dependabot) are novel; F-01/F-02/F-06/F-07/F-08/F-10/F-11/F-14/F-15 corroborate pass-6 findings independently |
| **Median severity** | MEDIUM |
| **Trajectory** | …pass 5 (0M+2L+1I) → pass 6 (3H+3M+2L+2I) → pass 7 (3H+4M+5L+1I) |
| **Verdict** | NOT CLEAN — 3H+4M+5L+1I; zero code defects; F-03 UNIQUE AND MOST CONSEQUENTIAL (stale demo FALSE-GREEN GENERATOR); window 0/3 |
| **Isolation** | PARTIAL — broad grep surfaced banned path names (not content); self-disclosed unprompted |
