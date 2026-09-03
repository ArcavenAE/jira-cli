---
document_type: delta-convergence-report
level: ops
version: "1.0"
status: final
producer: spec-steward
phase: phase-f7-convergence
dimension: all
cycle: cycle-003
feature: auth-profile-dx
branch: develop
baseline_commit: 87f17aff
head_commit: 202414f2
input-hash: "a8aee06"
traces_to: ".factory/cycles/cycle-003/phase-f7-convergence/consistency-audit-delta.md; .factory/cycles/cycle-003/phase-f7-convergence/holdout-eval-delta.md; .factory/cycles/cycle-003/phase-f6-hardening/summary.md; .factory/cycles/cycle-003/phase-f3-stories/decomposition-manifest.md"
---

# Delta Convergence Report: `auth-profile-dx` (cycle-003)

Governance synthesis only — this report performs no test execution, no build, and no mutation
run of its own. Every metric below is reproduced verbatim from already-certified F5/F6/F7
sub-artifacts (cited inline) per this agent's governance-and-traceability scope.

## Feature Summary

| Field | Value |
|---|---|
| **Feature** | `auth-profile-dx` (cycle-003) — per-profile credential ownership, `env` tagging, OAuth-default-at-creation |
| **Baseline → HEAD** | `87f17aff` (v0.7.0-dev.3 tag) → `202414f2` (`develop` tip) |
| **Driving decisions** | DEC-313 through DEC-331 (see `traceability-chain-delta.md` for the full DEC→BC map) |
| **Stories implemented** | 7/7 — `S-cycle3-env-tag` (PR #752 @ `4d0ae2d5`), `S-cycle3-percred-storage` (PR #755 @ `d3ba2726`), `S-cycle3-credential-absence-guard` (PR #756 @ `5c568d0f`), `S-cycle3-remove-logout-semantics` (PR #757 @ `5e9dba8a`), `S-cycle3-adr0011-newtype` (PR #758 @ `b7e513f9`), `S-cycle3-oauth-default-creation` (PR #761 @ `b70dd6f4`), `S-cycle3-chosen-flow-reconcile` (PR #762 @ `1dfcd013`) — all merged to `develop` |
| **F5 fix PRs (adversarial refinement)** | PR #763 (`aafa9f9f`, login-switch relogin-then-replace MED) + PR #764 (`202414f2`, F5-refinement bundle: 1 MED + 3 LOW) |
| **Spec delta** | 24 BCs (14 new + 10 amended), 9 VP-AUTHDX-001..009, 0 new ASM/R (unchanged this cycle) |
| **Files changed** | 17 Rust `src/` files (cycle-003 delta), full regression scope = entire tree |
| **BC/VP/holdout totals (project-wide, unchanged this cycle)** | 733 BCs, 41 VPs, 106 holdout scenarios; `total_stories` 168 |

## Five-Dimensional Convergence (Delta)

| Dimension | Metric | Target | Actual | Status |
|---|---|---|---|---|
| 1. Spec | Adversary novelty score (F5 scoped adversarial) | < 0.15 | ~0 (3/3 clean re-run passes: lifecycle, error-concurrency, spec-contract — zero new CRITICAL/HIGH/material-MED on `develop` @ `202414f2`) | **PASS** |
| 2. Test | Mutation kill rate (F6, `--in-diff` over 87f17aff..202414f2) | ≥ 90% | 100% (28/28 caught, 0 missed, 0 timeout, 0 unviable) | **PASS** |
| 3. Implementation | Adversary finding disposition (F5) | No open CRITICAL/HIGH | Converged — no open CRITICAL/HIGH; residual findings cosmetic/resolved (2 fix PRs merged, then 3/3 clean re-verification) | **PASS** |
| 4. Verification | Proofs + fuzz + audit (F6) | All pass / justified | Kani→proptest substitution 0 GAP (VP-AUTHDX-001..009 all covered); fuzz justified-skip (no new byte-stream parser); `cargo audit` 0 CRIT/HIGH (1 LOW pre-existing yanked `chacha20`, not delta-introduced); `cargo deny check` clean; purity/release-gates (`JR_BASE_URL`/`JR_AUTH_HEADER`) intact | **PASS** |
| 5. Holdout | Mean satisfaction score | ≥ 0.85 | 0.895 (std dev 0.128; 30/30 scenarios; lowest must-pass score 0.60, meets floor) | **PASS** |

**5/5 dimensions PASS.**

### Dimension 5 detail (holdout)

One black-box observation, non-blocking: **H-W2-REG-003** (score 0.7) — `--verbose` shows a
legacy-`email` existence PROBE (`get_password` call) issued when namespaced credentials are
absent. This is the by-design DEC-326 `legacy_flat_pair_exists()` existence-check (never a
credential read/copy/use) — consistent with the keyring-gated VP-AUTHDX-005 coverage boundary
and the F5 MED-2 documented reconciliation. Flagged in the holdout report for source/keyring-gated
confirmation but does **not** breach the Dimension-5 gate. Full detail:
`.factory/cycles/cycle-003/phase-f7-convergence/holdout-eval-delta.md`.

## Regression Validation

Separate from the five-dimensional convergence check above — a binary pass/fail on the full
existing + new codebase, not a convergence metric.

| Metric | F4 Baseline (cycle-002) | Current (cycle-003 @ `202414f2`) | Status |
|---|---|---|---|
| Total tests (passed + ignored) | 4660 + 106 = 4766 | 4763 passed + 157 ignored = 4920 | — |
| Existing tests passing | 4660 | 4763 (0 failed) | **PASS** |
| New/delta-related tests passing | — | included in the 4763 | **PASS** |
| `cargo clippy -- -D warnings` | clean | exit 0 (clean) | **PASS** |
| `cargo fmt --all -- --check` | clean | clean | **PASS** |
| Regressions vs. F4 baseline | — | **zero** | **PASS** |

Full suite executed in segments this session (harness constraint on long-running background
jobs); every integration binary (112), both lib unittest sets, and doctests confirmed run with
0 failures. Source: `.factory/cycles/cycle-003/phase-f6-hardening/summary.md` §5.

## Consistency Audit Summary (fresh-context, pre-gate)

`.factory/cycles/cycle-003/phase-f7-convergence/consistency-audit-delta.md` — 6 independent
fresh-context sub-audits, 12 total findings (1 CRITICAL / 3 HIGH / 2 MEDIUM / 6 LOW), **all in
the documentation/index layer — zero shipped-code defects.**

| Severity | ID | Description | Disposition |
|---|---|---|---|
| CRITICAL | CRIT-1 | `STORY-INDEX.md`'s 7 `S-cycle3-*` rows stale (read "ready"/"F4 pending" against actual merged state) | **FIXED** (factory-artifacts `85315806`) |
| HIGH | HIGH-1 | BC-1.4.027 present in `S-cycle3-percred-storage.md` frontmatter/BC-table with no AC trace | **FIXED** |
| HIGH | HIGH-2 | BC-1.4.029 present in `S-cycle3-credential-absence-guard.md` frontmatter/BC-table with no AC trace | **FIXED** |
| HIGH | HIGH-3 | `docs/specs/multi-profile-auth.md` Keyring-Layout/CLI-Surface sections still describe the pre-cycle-003 flat/shared model | **OUTSTANDING** — needs a `develop`-branch doc PR (out of `.factory/` worktree scope) |
| MEDIUM | MED-1 | "41 total VPs" project-wide figure has no automated cross-check / single source of truth | **OUTSTANDING** — non-blocking for cycle-003's own VPs (all 9 independently verified) |
| MEDIUM | MED-2 | Stale 6-wave labels in 2 story files' prose (edges/schedule itself correct) | **FIXED** |
| LOW | LOW-1 | `chosen_flow_for_profile` "removed entirely" overclaim (function still exists, simplified) | **FIXED** |
| LOW | LOW-2 | Stale pre-DEC-315 comment in `logout.rs` | **OUTSTANDING** (doc nit) |
| LOW | LOW-3 | CLAUDE.md omits `auth logout` stderr-notice detail | **OUTSTANDING** (doc nit) |
| LOW | LOW-4 | BC-INDEX.md title paraphrase drift on BC-1.6.047 | **OUTSTANDING** (doc nit) |
| LOW | LOW-5 | STORY-INDEX.md stale "Total rows: 133" headline (actual 168) | **FIXED** |
| LOW | LOW-6 | No CLI flag sets `env` tag (config-file-only) — intentional but undocumented as a scope boundary | **OUTSTANDING** (doc nit) |

**6 of 12 fixed this burst** (CRIT-1, HIGH-1, HIGH-2, MED-2, LOW-1, LOW-5). **6 outstanding**
(HIGH-3, MED-1, LOW-2/3/4/6) — all documentation-layer, explicitly carried forward in
`.factory/STATE.md` for human disposition at this gate. A non-blocking story-template-compliance
gap (4 of 7 story files missing the template's `level` key + Architecture Mapping/Purity/Library
sections) was also surfaced and is tracked as a standing item, not a gate blocker.

All code-level BC↔implementation correspondence, all 9 VP↔test mappings, ADR-0011/ADR-0020
status and application, dependency acyclicity, story sizing, and priority consistency were
independently confirmed clean by the same audit.

## Cost-Benefit (DF-027, qualitative)

Convergence is strong and stable: F5 reached 3/3 clean adversarial passes, F6 reached 100%
mutation kill with 0 CRIT/HIGH security findings, and holdout scored 0.895 mean satisfaction
against a 0.85 target. P(material finding in a further convergence cycle) is assessed low, and
the remaining open items (HIGH-3 plus the LOW doc nits) are documentation-only, not
implementation or spec-correctness gaps. Expected value of an additional full convergence cycle
is below its cost.

**Assessment: MAXIMUM_VIABLE_REFINEMENT_REACHED** for the code delta. The one substantive open
item (HIGH-3, `docs/specs/multi-profile-auth.md` reconciliation) is addressable via a single
targeted documentation PR, not another convergence cycle.

## Traceability Chain

Full chain (24 BC rows × DEC → BC → VP → test → src → PR/commit → F5 → F6 links, plus
cross-reference rows) written separately to
`.factory/cycles/cycle-003/phase-f7-convergence/traceability-chain-delta.md`. No master
`.factory/cycles/cycle-003/convergence/traceability-chain.md` file exists yet for this cycle
(cycle-002's equivalent file exists at `.factory/cycles/cycle-002/convergence/traceability-chain.md`
but no cycle-003 counterpart has been created) — this is noted explicitly in the delta file
rather than silently working around it.

## Recommendation

**READY FOR MERGE.**

Basis: 5/5 convergence dimensions PASS, zero regressions against the F4/cycle-002 baseline, and
every *blocking-class* consistency-audit finding (CRIT-1, HIGH-1, HIGH-2) is fixed and verified.

**One explicit exception carried to this gate, not silently cleared:** HIGH-3
(`docs/specs/multi-profile-auth.md` stale Keyring-Layout/CLI-Surface sections) remains
outstanding. It is a documentation-reconciliation item with no bearing on shipped code
correctness or the five convergence dimensions above — but per this project's own severity
classification it is HIGH, not LOW, so it is surfaced here as an explicit **human
fix-now-vs-fast-follow decision at the gate**, not folded into "ready" by default. MED-1 and the
four remaining LOW items are non-blocking documentation nits carried forward per the project's
established residual-sweep convention (as at the F2 and F5 gates).

No FIX-F7-NNN candidates are generated by this report — the two paths available to the human at
this gate are (a) authorize merge/release now with HIGH-3 tracked as an immediate fast-follow doc
PR, or (b) require the doc PR to land before authorizing.
