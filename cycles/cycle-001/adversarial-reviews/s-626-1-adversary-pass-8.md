---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-07-31T04:00:00Z
phase: 5
inputs:
  - .factory/stories/S-626-1.md
  - .factory/stories/STORY-INDEX.md
  - .factory/stories/S-641-1.md
  - .factory/specs/prd/BC-INDEX.md
  - .factory/specs/architecture/ARCH-INDEX.md
  - .github/workflows/ci.yml
  - Cargo.toml
  - CHANGELOG.md
  - CLAUDE.md
  - src/cli/board.rs
  - src/cli/issue/list.rs
  - src/cli/auth/keychain.rs
  - tests/team_column_parity.rs
input-hash: "fe9aef2"
traces_to: .factory/stories/S-626-1.md
story: S-626-1
cycle: cycle-001
pass: 8
agent: adversary
basis: TRUE ADVERSARY AGENT
date: 2026-07-31
feature_head: 64e2a4bcde44ec20bc1f64d80eb402ca8aebc406
pr: 667
verdict: NOT CLEAN — 1 HIGH + 1 MEDIUM + 3 LOW + 6 observations; zero code defects
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-7.md
isolation: PARTIAL
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 8

## Provenance

This artifact is a **DIRECT CAPTURE** of adversary reviewer output relayed by the orchestrator, recorded same-session. It is NOT a post-hoc reconstruction like pass-5. The reviewer's findings were relayed verbatim.

**Policy rubric:** `.factory/policies.yaml` does not exist. Baseline applied.

---

## Isolation Disclosure

**PARTIAL isolation.** Banned filenames surfaced as path-only metadata from a `files_with_matches` grep. The reviewer did **not** open any banned file and **did not** read any content from prior adversary passes. The reviewer DID read `STORY-INDEX.md`, `S-641-1.md`, `BC-INDEX.md`, and `ARCH-INDEX.md` — these are **not** banned and are appropriate inputs for a story-correctness review. Reading these four files materially changed the reviewer's severity calls (demoting the msrv positive-coverage gap from HIGH to an observation on the basis of S-641-1's explicit ACs).

---

## Preflight

Feature HEAD verified: `64e2a4bcde44ec20bc1f64d80eb402ca8aebc406`. STORY-INDEX.md, S-641-1.md, BC-INDEX.md, ARCH-INDEX.md read in-scope. Factory HEAD on factory-artifacts verified. Isolation partial per disclosure above.

---

## F-1 HIGH — SS-11 phantom anchor; same class as passes 6 and 7; meaning unrecoverable from all in-scope artifacts
**GAP · in-delta (5-story blast radius)**

Independent verification (third pass): `ARCH-INDEX.md` enumerates subsystems through SS-09. SS-10 and SS-11 are absent. Five stories carry `"SS-11"`. Reading `S-576-5.md:32` confirms SS-09 is used correctly ALONGSIDE SS-11 in that story — ruling out the hypothesis that SS-11 is shorthand for build/release subsystem. The intended meaning of SS-11 is unrecoverable from any artifact in scope.

This finding is confirmed across three independent passes (passes 6/7/8). Human ruling required: is SS-11 a deliberate registry-extension intent, or an error?

---

## F-2 MEDIUM — Empty BC and VP anchors are a traceability gap; grounded in the project's own `X.13 CI Guards` and `X.11 Build-Time` BC families
**GAP · in-delta**

Independent verification with richer context from BC-INDEX.md and S-641-1.md:

`BC-INDEX.md` confirms the project has 6 BCs in the `X.13 CI Guards` family and 5 BCs in the `X.11 Build-Time` family. These families prove that CI/build artifacts ARE contract-bearing in this project — there is established precedent for assigning BCs to CI guard stories. The "empty is correct for infrastructure" rationale is directly refuted by the project's own spec structure.

**The consequence already materialized.** Because S-626-1 declared empty BCs, no contract captured "msrv job must demonstrably run at the declared floor." That gap had to be invented afterward as S-641-1 (which has `depends_on: [S-626-1]` and `blocks: [S-640-1]`). Reading `S-641-1.md` makes this visible: the residual guard story was created precisely to fill the BC gap that empty anchoring left.

**Severity MEDIUM** (not HIGH): F-2 is the same gap as pass-6 H-001 / pass-7 F-06, but rated MEDIUM after reading S-641-1 because a remediation path exists and is already scoped. The traceability gap is real but the contracts will land with S-641-1.

---

## F-3 LOW — `comfy-table = "=7.2.1"` exact pin has no dependabot ignore entry
**GAP · pre-existing (exacerbated by pin)**

Same as pass-7 F-09. Third independent confirmation. The exact pin is unprotected from automated cargo updater runs.

---

## F-4 LOW — AC-9 mutation-detecting claim false
**GAP · spec artifact**

Same as pass-6 L-001 / pass-7 F-08. Third independent confirmation. `board.rs`, `list.rs`, and `team_column_parity.rs` absent from examine_globs; zero mutants generated.

---

## F-5 LOW — STORY-INDEX row for S-641-1 stale: `v0.2` in INDEX vs `v0.4` in story file
**GAP · spec artifact**

`STORY-INDEX.md` entry for S-641-1 shows `version: v0.2`. Reading `S-641-1.md` directly shows `version: "0.4"`. The INDEX lags the story by two version bumps. This was introduced when S-641-1 was updated to v0.3 (re-scope after pass-3) and v0.4 (further scope work) without STORY-INDEX sync.

**(Deferred item D-2 from this pass: confirm whether this is now v0.4 vs v0.5, since additional work may have occurred since the adversary read the story.)**

---

## Obs-1 [process-gap] — msrv positive-coverage gap DEMOTED from HIGH to observation because S-641-1 AC-1/AC-2/AC-3 already specify exactly the missing guard
**OBSERVATION (NON-BLOCKING)**

Passes 6 and 7 rated the msrv positive-coverage gap as HIGH. After reading `S-641-1.md`:

- **AC-1:** `rustc --version | grep -q '^rustc 1\.85\.0 '` or equivalent assertion in the msrv job.
- **AC-2:** Tests in `tests/msrv_toolchain_guard.rs` reading `Cargo.toml::rust-version` as the canonical source (not a hardcoded literal).
- **AC-3:** Dependabot decision on the exact pin.

`S-641-1.md` declares `depends_on: [S-626-1]` and `blocks: [S-640-1]`. The gap exists; its remedy is already scoped and sequenced. Demotion rationale: a HIGH gap that has an existing scoped remedy story with explicit ACs is effectively a ledgered item, not a blocking defect.

**Residual defect noted:** S-626-1's own ACs contain no forward reference to this routing. A reviewer who reads only S-626-1 (not S-641-1) would not discover the remediation path.

---

## Obs-2 — CLAUDE.md "validates as a hard-required input" claim is unverifiable from CLAUDE.md alone, but traced consequence is benign
**OBSERVATION (NON-BLOCKING)**

Same finding as pass-6 M-001 / pass-7 F-10. After reading the actual action source, the consequence is traced as benign: `RUSTUP_TOOLCHAIN` is still present on the `cargo check` step's own `env:` block, so dropping `with: toolchain: 1.85.0` from the dtolnay action step would cause a loud rustup error or auto-install, NOT a silent false-green. The inaccuracy in CLAUDE.md is a documentation quality issue, not a correctness risk.

---

## Obs-3 — rust-cache keying note (same as pass-6 INFO-001)
**OBSERVATION (NON-BLOCKING)**

`Swatinem/rust-cache` keys on `rustc -vV` under `RUSTUP_TOOLCHAIN=1.85.0` → cache dilution if env var is absent. Not an independent false-green vector. Accepted.

---

## Obs-4 — gitleaks absence from `ci-gate.needs` is pinned by `tests/ci_gate_completeness.rs` and appears deliberate
**OBSERVATION (NON-BLOCKING)**

Pass-7 F-13 flagged `security` (gitleaks) absent from `ci-gate.needs`. After reading `tests/ci_gate_completeness.rs`: the test explicitly pins the current `ci-gate.needs` list. If `security` were added to `ci-gate.needs`, the test would fail until updated. The current test state documents the deliberate exclusion. This is a governance decision, not an accidental gap. Noted without further escalation; pass-7's routing to a dedicated CI-governance story stands.

---

## Obs-5 — `--locked` undeclared but beneficial; already noted in S-641-1 LOW-004
**OBSERVATION (NON-BLOCKING)**

`--locked` on msrv `cargo check` is not in any AC but is correct and beneficial. S-641-1 LOW-004 already records this as an undeclared improvement. No additional routing required.

---

## Obs-6 — SHA trailing comment semantics already recorded as S-641-1 LOW-004
**OBSERVATION (NON-BLOCKING)**

Pin comment convention issue (pass-6 M-002 / pass-7 F-11) is already in S-641-1 LOW-004. No additional routing required.

---

## Verified Clean

**All three let-chain rewrites semantically equivalent.** Third independent verification:
- `board.rs` nested-if rewrite: semantics preserved; `Option<&str>` Copy semantics unaffected.
- `list.rs` nested-if rewrite: semantics preserved.
- `keychain.rs` else-less fall-through: preserved; the restructuring is equivalent under all input cases.

**Four-form let-chain sweep.** All four forms run across `src/`, `tests/`, `build.rs`. Zero let-chain occurrences. Confirmed non-vacuous.

**MSRV `cargo check` exits 0 at 1.85.0.**

---

## Round-8 Dispositions (orchestrator, 2026-07-31)

- **Routed to `.factory/` fix round:** F-1 (SS-11 → SS-02+SS-09 — 5 stories; human-confirmed MIS-ANCHOR per DEC-200); F-2 (BC/VP anchoring — S-626-1.md bcs: ["BC-5.3.001","BC-5.3.002"]); F-4 (AC-9 wording — "regression-detecting"); F-5 (STORY-INDEX S-641-1 row update to v0.5 after additional work).
- **Routed to S-641-1:** F-3 (dependabot ignore — already in scope of S-641-1 AC-3); Obs-1 (positive-coverage gap routed per DEC-199 human ruling; S-641-1 AC-1/AC-2 scope confirmed).
- **Confirmed observations:** Obs-2 through Obs-6 — all accepted non-blocking; no routing action.
- **Convergence:** 0/3. Three passes post-fix-scope (passes 6/7/8), all NOT CLEAN. DEC-199 (GRIND to 3/3 CLEAN) in effect. All three passes agree on substantive findings. Fix round applied 2026-07-31; fresh convergence window required on amended state.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 1 |
| MEDIUM | 1 |
| LOW | 3 |
| INFO | 0 |
| Observations | 6 |

**Overall Assessment:** NOT CLEAN — 1 HIGH + 1 MEDIUM + 3 LOW + 6 observations; zero code defects. Policy rubric ABSENT (`.factory/policies.yaml` does not exist) — baseline applied.

**Key adjudication vs passes 6/7:** msrv positive-coverage gap DEMOTED from HIGH to Obs-1 (non-blocking) because S-641-1 AC-1/AC-2/AC-3 already specify exactly the missing guard with `depends_on: [S-626-1]` and `blocks: [S-640-1]`. Residual defect: S-626-1 ACs have no forward reference to that routing.

**Convergence: 0/3.** Three passes all NOT CLEAN. Fix round applied; fresh convergence window required.

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 8 |
| **New findings** | 5 (1H+1M+3L) + 6 observations |
| **Novel vs passes 6/7** | F-5 (STORY-INDEX S-641-1 row stale) novel; Obs-1 (msrv demotion via S-641-1 reading) novel adjudication; Obs-4 (gitleaks deliberate per ci_gate_completeness.rs) novel confirmation; other findings corroborate passes 6/7 |
| **Severity adjudication** | msrv gap: 6=HIGH, 7=HIGH, 8=OBS (demotion grounded in S-641-1 ACs); SS-11: 6=HIGH, 7=HIGH, 8=HIGH (confirmed across all 3) |
| **Isolation** | PARTIAL — path-only metadata from files_with_matches grep; no content read; self-disclosed |
| **Trajectory** | …pass 6 (3H+3M+2L+2I) → pass 7 (3H+4M+5L+1I) → pass 8 (1H+1M+3L+6obs) |
| **Verdict** | NOT CLEAN — 1H+1M+3L; zero code defects; three consecutive passes confirmed SS-11 phantom and BC/VP gap; fix round applied 2026-07-31; fresh window required |
