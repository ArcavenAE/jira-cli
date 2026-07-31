---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-07-30T22:45:00Z
phase: 5
inputs:
  - .factory/stories/S-626-1.md
  - .github/workflows/ci.yml
  - CLAUDE.md
  - src/cli/board.rs
  - src/cli/issue/list.rs
  - src/cli/auth/keychain.rs
input-hash: "c8e448b"
traces_to: .factory/stories/S-626-1.md
story: S-626-1
cycle: cycle-001
pass: 5
agent: adversary
basis: TRUE ADVERSARY AGENT
date: 2026-07-30
feature_head: 4223ea091ad2c295a086269357b2442399d3b3e8
pr: 667
verdict: NOT CLEAN — 2 LOW + 1 INFO; zero MEDIUM+; zero code defects; 3/3 residue
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-4.md
reconstruction: true
reconstruction_source: STATE.md pass-5 summary + git show 64e2a4bc diff
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 5

## RECONSTRUCTION DISCLOSURE

**This artifact is a POST-HOC RECONSTRUCTION.** The orchestrator did not execute Post-Adversary Persistence at the time of pass-5. This document is reconstructed from two authoritative sources:

1. **STATE.md** — the SESSION-WRAP-BURST recorded pass-5's verdict, finding count, severity breakdown, and disposition summary verbatim.
2. **`git show 64e2a4bc`** — the fix commit's message body named all three findings with their classifications, described the root cause and fix for each, and supplied the changed lines.

**What this reconstruction can faithfully reproduce:** finding IDs, severity levels, classifications (RESIDUE/GAP), finding titles, the code/text evidence from the diff (exact before/after lines), dispositions, and the "all-residue / self-feeding" convergence signature.

**What this reconstruction cannot reproduce:** the adversary's original preflight checks, its exact investigative narrative, any "Verified Clean" items it confirmed, and any framing beyond what the diff and STATE.md support. Where detail is unavailable, this document says so rather than fabricating.

The Drift Item `ORCHESTRATOR-SKIPPED-POST-ADVERSARY-PERSISTENCE` records the procedural gap. All 5 S-626-1 adversary passes are now captured.

---

## Preflight

*Not reconstructable.* The adversary's preflight checks (git rev-parse HEAD, factory HEAD verification) were not captured. At pass-5 dispatch time the feature HEAD was `4223ea091ad2c295a086269357b2442399d3b3e8` ("docs(ci): add No let-chains convention and fix ci.yml scope warning"), which is the commit that applied pass-4's round-4 dispositions (LOW-001 and LOW-002). Pass-5 ran against that head.

---

## ADV-P5-LOW-001 — CLAUDE.md `No let-chains` citation pointer introduced by pass-4 fix resolves to wrong gotcha
**RESIDUE · in-delta (introduced by fix-round commit `4223ea09`)**

The `No let-chains` convention added by `4223ea09` read:

```
**No let-chains.** `if let … && …` / `… && let …` syntax requires Rust ≥1.88
with edition 2024; MSRV is 1.85. Use nested `if` blocks instead. The `msrv` CI
job catches violations in lib + bins, but inline `#[cfg(test)]` modules in `src/`
sit outside its enforceable scope (see Gotchas — `rust-toolchain.toml` outranks
`rustup default`).
```

The parenthetical pointer `(see Gotchas — rust-toolchain.toml outranks rustup default)` resolves to the gotcha about rustup override precedence and the version-branch SHA details. That gotcha contains nothing about `--all-targets` scope, dev-dep exclusion, `#[cfg(test)]` modules, or the CI enforcement gap. It is the wrong pointer. The correct referent is the `ci.yml` msrv scope comment, which is where the enforcement gap is explained (and which was just corrected by pass-4's LOW-002 fix in the same commit).

Additionally, the scope description "inline `#[cfg(test)]` modules in `src/`" omitted integration tests in `tests/`, which are equally outside the msrv job's enforceable scope.

**Fix (commit `64e2a4bc`):** Replaced `(see Gotchas — rust-toolchain.toml outranks rustup default)` with `(see the ci.yml msrv scope comment)`. Widened "inline `#[cfg(test)]` modules in `src/`" to include "and integration tests in `tests/`".

---

## ADV-P5-LOW-002 — `No let-chains` convention has no expiry clause; will deadlock with `No lint suppression without refactoring` after MSRV raise
**GAP · in-delta (introduced by fix-round commit `4223ea09`)**

The `No let-chains` entry added to CLAUDE.md Conventions in `4223ea09` stated the rule and its MSRV basis but contained no clause stating when the rule should be removed. This is a deadlock hazard:

- `No let-chains` says: rewrite let-chains to nested-if blocks.
- `No lint suppression without refactoring` says: fix clippy warnings by refactoring, not suppressing.
- When S-640-1 raises MSRV to ≥1.88, clippy's `collapsible_if` lint will fire on the nested-if rewrites introduced to comply with `No let-chains`. At that point the two conventions directly contradict each other: refactoring means reverting the nested-if to let-chains; lint-suppression is forbidden without a refactoring reason.

Without an expiry clause, `No let-chains` outlives its cause (MSRV < 1.88) and becomes a permanent obstacle to the idiomatic Rust that `collapsible_if` is enforcing.

The entry also cited three in-code comments (`src/cli/board.rs`, `src/cli/issue/list.rs`, `src/cli/auth/keychain.rs`) that should be deleted at the same time as the convention.

**Fix (commit `64e2a4bc`):** Added trailing sentence: "Temporary — delete this entry and the three citing in-code comments when MSRV is raised to ≥1.88."

---

## ADV-P5-INFO-003 — ci.yml scope warning overstates impossibility; a downgrade-pin is an available remedy
**RESIDUE · in-delta (introduced by fix-round commit `4223ea09`)**

`4223ea09` rewrote the `ci.yml` msrv scope comment to:

```
# outside the MSRV floor's enforceable scope; this gap cannot be closed
# until dev-dependencies (wiremock 0.6.x) support 1.85.0.
```

The modal "cannot be closed" is too strong. A wiremock downgrade-pin (same class as the comfy-table `=7.2.1` exact pin that is the headline deliverable of S-626-1) is an available remedy — it was not evaluated. The framing "cannot be closed" implies there is no possible fix, when the accurate framing is that closing the gap is a cost/benefit decision, not an upstream-blocked impossibility.

**Fix (commit `64e2a4bc`):** Softened to: "closing this gap would require dev-dependencies that build at 1.85.0 — a wiremock downgrade-pin was not evaluated."

---

## Verified Clean

*Not reconstructable.* Items the adversary confirmed clean at this pass are not recorded in the surviving sources. Pass-4's Verified Clean section (AC-1 through AC-9, gates re-run, live CI proof) is the most recent confirmed clean verification; the code was not touched between `4223ea09` and `64e2a4bc` except for the three CLAUDE.md/ci.yml doc changes fixed above.

---

## Adversary's Assessment (reconstructed from STATE.md + diff)

*The following paraphrases what the adversary recorded. It is NOT a verbatim transcript.*

Three findings, all INFO or LOW, all RESIDUE of fix rounds. Zero MEDIUM+. Zero code defects — the code has been correct since `20d533e4`; this was the fifth consecutive pass with no code defect. All three findings were introduced by `4223ea09` itself — the pass-4 fix commit. This is the "all-residue / self-feeding" signature: each fix round is now its own primary defect source. The convergence window remains 0 of 3, but the pass-5 trajectory (3/3 residue, zero new substance) is a possible breakpoint: the implementation is sound; only the surrounding prose documentation is still self-correcting.

---

## Round-5 Dispositions (orchestrator)

- **Fixed pre-merge, commit `64e2a4bc` pushed to #667:** LOW-001 (citation pointer corrected: `Gotchas — rust-toolchain.toml outranks rustup default` → `ci.yml msrv scope comment`; scope widened to include `tests/`), LOW-002 (expiry clause added: "Temporary — delete this entry and the three citing in-code comments when MSRV is raised to ≥1.88"), INFO-003 (modal softened from "cannot be closed until…" to "closing this gap would require…; a wiremock downgrade-pin was not evaluated").
- **No additional routings.** All three findings were purely documentation/wording; no spec artifacts or story changes required.
- **Convergence: 0 of 3.** Five passes, five NOT CLEAN, but pass-5 = 3/3 all-residue, zero MEDIUM+ for two consecutive passes, zero code defects for four consecutive passes. Self-feeding residue signature — possible breakpoint. Human decides: pass-6 or merge #667.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 0 |
| LOW | 2 |
| INFO | 1 |

**Overall Assessment:** NOT CLEAN — 2 LOW + 1 INFO; zero MEDIUM+; zero code defects

**Convergence: 0 of 3.** Five passes, five NOT CLEAN — severity ceiling LOW; code defects zero for four rounds; pass-5 = 3/3 all-residue (self-feeding).

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 5 |
| **New findings** | 3 (2 LOW + 1 INFO) |
| **Residue findings** | 3 of 3 (100% residue — all introduced by `4223ea09` fix-round commit) |
| **Duplicate/variant findings** | 0 — all new |
| **Median severity** | LOW |
| **Trajectory** | pass 1 (5M+5L+3I) → pass 2 (3M+2L+2I) → pass 3 (3M+3L+2I) → pass 4 (0M+4L+1I) → pass 5 (0M+2L+1I) |
| **Verdict** | NOT CLEAN — 2 LOW + 1 INFO; zero MEDIUM+; zero code defects; round-5 dispositions committed to `64e2a4bc`; convergence 0/3; **all-residue signature** |
| **Reconstruction** | POST-HOC (no verbatim adversary transcript available; reconstructed from STATE.md + `git show 64e2a4bc`) |
