---
document_type: cycle-document
cycle: cycle-013-msrv-1.88-bump
phase: phase-f6-targeted-hardening
producer: formal-verifier
timestamp: 2026-09-16
status: complete
delta_ref: "git diff 7160a534..b960c305 (46 files, +1073/-1050)"
develop_at: b960c305
verdict: HARDENED_WITH_RESIDUALS
inputs:
  - .factory/cycles/cycle-013/phase-f2-spec-evolution/verification-delta.md
  - .factory/cycles/cycle-013/phase-f5-adversarial/f5-convergence.md
  - docs/specs/cargo-mutants-policy.md
  - CLAUDE.md
input-hash: "d68d682"
---

# Phase F6 Targeted Hardening — cycle-013 (`msrv-1.88-bump`)

## Nature of this assessment

This is a **hardening ASSESSMENT/JUSTIFICATION phase for a mechanical, behavior-preserving
delta** — NOT a from-scratch verification build. The cycle-013 delta is:

1. MSRV floor bump 1.85 → 1.88 (`Cargo.toml` `rust-version`, `msrv` CI job pin, comfy-table
   unpin) — build/toolchain metadata, zero runtime surface.
2. ~73-site clippy `collapsible_if` → let-chain retrofit — compiler-verified-equivalent
   syntax rewrites of existing control flow, no new logic.
3. Documentation reconciliation (CLAUDE.md, README, CHANGELOG, design spec,
   `ci-gate-completeness.md`) — prose only.

F2 (`verification-delta.md`) independently re-derived and declared: **ZERO new VP-NNN,
ZERO modified VP-NNN, ZERO new Kani proofs / proptest strategies / fuzz targets, architecture
unchanged, ZERO BC content/count edits.** F5 CONVERGED (adversary 3/3 CLEAN + code-review
APPROVE + security CLEAN; zero CRIT/HIGH/MED across all five review artifacts). The delta is
confirmed mechanical and behavior-preserving.

Per the standing convention (cycle-007 F6 record and its cited precedent), a mechanical delta
is hardened by JUSTIFYING per-axis disposition against the delta's actual surface plus citing
the CI evidence for the axes that run in CI — not by re-running heavy local jobs (macOS host:
`cargo mutants` prohibitively slow AND policy-forbidden to re-run locally; full suite ~6.5h).

---

## Axis 1 — Formal verification / VP coverage: JUSTIFIED 0-GAP

**Disposition: 0-GAP (no new verifiable property introduced by the delta).**

The delta introduces no new capability, endpoint, state machine, arithmetic operation, or
security boundary — the three categories of change (toolchain metadata, let-chain syntax
collapses, prose) have no product-behavior surface to attach a new VP to. This is not asserted;
F2 §1–§2 re-derived it from first principles:

- The let-chain collapses are **semantics-preserving by construction**. Rust 1.88's let-chain
  stabilization deliberately sequenced the `if let` temporary-scope change so that the
  nested-`if` → let-chain collapse produces **matching, not diverging** drop order versus the
  nested form (F2 §2, citing `msrv-let-chains-comfy-table-2026-07-30.md` Q1). The compiler
  verifies equivalence.
- The three highest-complexity collapse sites (`auth/keychain.rs`, `board.rs`,
  `issue/list.rs`) directly implement `BC-5.3.001`/`BC-5.3.002`/`BC-5.3.003`, whose
  **outcome-level postconditions are already fully covered** by `tests/team_column_parity.rs`
  + `tests/cli_handler.rs` (F2 §2 enumerates the specific tests). These assert outcomes, not
  control-flow shape — they catch any accidental behavior change regardless of let-chain shape.
- `VP-CIGATE-001`'s assertion count/shape is unaffected; only the pinned literal `"1.85.0"` →
  `"1.88.0"` changed in `tests/ci_gate_completeness.rs` (a parameter of an existing self-test,
  not a new VP) — F2 §3.

**Kani / cargo-fuzz — JUSTIFIED-SKIP, 0-GAP.** Neither is provisioned in this repo (no
`kani`/`kani-verifier` in `Cargo.toml`, no `fuzz/` directory). The proptest-substitution
justification is applied per the established **cycle-002/003/004/005/006/012 precedent**
(STATE.md Skip Log), re-affirmed in the **cycle-007 F6 hardening record** for an equivalent
non-arithmetic, effectful-CLI-boundary delta. Here the case is even stronger than cycle-007's:
this delta adds NO new logic at all — it is compiler-verified-equivalent rewrites of existing,
already-tested code. Skipping Kani/fuzz introduces no coverage gap relative to the delta's
surface: there is no new arithmetic/bounds/state-machine surface Kani would strengthen, and no
new untrusted-byte parser fuzz would exercise (see Axis 2). Substitution, not omission.

---

## Axis 2 — Fuzz testing: N/A (no new input surface) — JUSTIFIED

**Disposition: N/A — existing coverage unchanged.**

The delta adds **no new input-parsing or untrusted-input surface**. Every let-chain rewrite
targets existing control flow (env-var read guards, team-column render gating); no new parser,
deserializer, byte-consuming path, or externally-controlled-input boundary is introduced. The
MSRV bump and doc edits have no input surface whatsoever. Fuzzing's value (crash-finding on
untrusted bytes) has nothing new to bite on. Existing fuzz posture (none provisioned; ADF /
filename-sanitization surfaces covered by their existing proptests, unchanged this cycle) is
untouched by the delta. No gap.

---

## Axis 3 — Mutation testing: GREEN in CI (diff-scoped sharded gate) — CITED, not re-run

**Disposition: PASS — diff-scoped cargo-mutants gate GREEN in CI on both cycle-013 PRs.**

Per `docs/specs/cargo-mutants-policy.md` and CLAUDE.md, the sharded cargo-mutants gate runs on
**PR-diff scope IN CI** and is **not re-run locally** (policy-forbidden; macOS host
prohibitively slow). `cargo mutants` was NOT run locally. CI evidence observed via
`gh pr checks`:

**PR #818** (the code change: MSRV bump + let-chain retrofit) — run `35035863974`:
- `Mutation Testing (Shard) (0..7)` — all 8 shards **pass** (build/test loops 18m–39m each,
  confirming real mutant execution, not a no-op)
- `Mutation Testing (Aggregate)` — **pass** (`ci-gate.needs` proxy, `mutants-aggregate.sh`)
- `Mutation Test Plan` — **pass**
- `CI Gate` — **pass** (fail-closed aggregation of all `needs`)

**PR #822** (Wave-2-gate F-2 doc fix) — run `35149165790`:
- `Mutation Testing (Shard) (0..7)` — all 8 shards **pass** (24s–56s each; short because the
  diff is doc-only, so the diff-scoped mutant set is minimal/empty — correct behavior)
- `Mutation Testing (Aggregate)` — **pass**; `Mutation Test Plan` — **pass**; `CI Gate` — **pass**

The diff-scoped mutation gate is GREEN for the cycle-013 delta. Residual trust boundary
(untrusted `outcomes.json` within the same shard job; artifact-name-pattern provenance) is the
pre-existing, documented `cargo-mutants-policy.md` "Sharded Gate: Residual Trust Boundary" item
— unchanged by this cycle, not a new residual.

---

## Axis 4 — Full regression: GREEN — CITED, not re-run

**Disposition: PASS — full suite GREEN in CI across both merged PRs.**

The local full suite (~6.5h on this macOS host) was NOT re-run per instruction. CI evidence:

- **PR #818** run `35035863974`: `Test (ubuntu-latest)` pass, `Test (macos-latest)` pass,
  `Test (windows-latest)` pass; `Clippy (ubuntu/windows)` pass (0-warn policy);
  `Format` pass; `MSRV (1.88.0)` pass; `Coverage` pass; `Spec Guards` pass.
- **PR #822** run `35149165790`: same set all **pass** (Test ×3 platforms, Clippy ×2, Format,
  MSRV 1.88.0, Coverage, Spec Guards).

Consistent with the task-cited Wave-2 gate full-suite result (5271 pass / 0 fail, clippy
0-warn, fmt clean, MSRV 1.88 at cfe1dedc), CI re-ran green through #822 @ `b960c305`. Full
regression is GREEN at the delivered tip.

---

## Axis 5 — Security scan (full tree): CLEAN — CITED

**Disposition: PASS — F5 security-reviewer CLEAN + cargo-deny GREEN in CI.**

- F5 security-reviewer returned **CLEAN — 0 findings** (`f5-convergence.md`;
  `phase-f5-adversarial/security-review.md`).
- `Deny (licenses + vulnerabilities)` (cargo-deny) — **pass** on both merged PRs:
  PR #818 run `35035863974` (`104604722747`), PR #822 run `35149165790` (`104972780949`).
- Supporting supply-chain gates also green: `Secret Scan (gitleaks)` pass, `dependency-review`
  pass, `Signing Workflow Injection Guard` pass — both PRs.

The comfy-table unpin (Axis-6 residual below) was reviewed at F5 and found fail-safe; no
license/advisory regression. Security posture clean on the full tree.

---

## Axis 6 — DTU / accessibility: N/A — CONFIRMED

**Disposition: N/A.**

- **DTU: N/A** — `dtu_required: false` (per prior cycles' standing setting); no third-party
  behavioral clone in scope for this delta.
- **Accessibility / visual: N/A** — `jr` is CLI-only; no UI surface exists to audit. The delta
  touches no rendering/interaction surface (the `board.rs`/`list.rs` sites gate a text-table
  column, covered behaviorally by Axis-1's cited tests).

---

## Residuals (LOW only)

| ID | Severity | Description | Disposition |
|----|----------|-------------|-------------|
| `CYCLE-013-COMFY-TABLE-ZERO-HEADROOM-MSRV` | LOW | `comfy-table =7.2.2` sits at exactly the 1.88 MSRV floor with zero headroom. A future comfy-table bump requiring ≥1.89 would fail the now-widened (`--all-targets`) `msrv` CI job — i.e. **fail-safe** (loud CI failure, not a silent regression). | Already recorded as an F5 standing item (`phase-f5-adversarial/pass-03.md`). Forward-looking maintenance watch on the next comfy-table bump, NOT an action item now. |
| `CYCLE-013-F3-HISTORICAL-PLANDOC-MSRV-MENTIONS` | LOW/NIT | Historical plandoc MSRV-1.85 mentions in superseded planning docs. | Already covered by the pre-existing standing item; no defect. |

No CRIT/HIGH/MED residuals. Both residuals are pre-existing standing items carried from F5,
fail-safe/cosmetic in nature.

---

## Verdict: HARDENED_WITH_RESIDUALS

All six hardening axes are dispositioned with justification and CI evidence for the cycle-013
mechanical delta:

- **VP coverage: 0-GAP** — no new verifiable property; let-chain collapses compiler-verified
  equivalent; existing BC/test pairing covers the touched sites. Kani/fuzz justified-skip per
  standing cycle-002/003/004/005/006/012 + cycle-007-F6 proptest-substitution precedent.
- **Fuzz: N/A** — no new input/untrusted-byte surface.
- **Mutation: GREEN in CI** — diff-scoped sharded gate (8 shards + aggregate) pass on #818 and
  #822; not re-run locally per policy.
- **Full regression: GREEN in CI** — Test ×3 platforms, clippy 0-warn, fmt, MSRV 1.88, coverage
  pass on both PRs; not re-run locally.
- **Security: CLEAN** — F5 security-reviewer 0 findings; cargo-deny GREEN on both PRs.
- **DTU / accessibility: N/A** — CLI-only, `dtu_required:false`.

The two LOW residuals are pre-existing, fail-safe standing items. No source was modified in this
phase. Ready to proceed to F7 delta-convergence.
