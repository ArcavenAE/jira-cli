---
document_type: pipeline-state
level: ops
version: "3.71"
status: active
producer: state-manager
timestamp: 2026-09-05T22:37:54Z
phase: F7
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-31 latest brownfield (unchanged). trajectory-tail →1→3→0→2 (unchanged this burst). Burst 19: F6 targeted hardening (cycle-004, windows-correctness) COMPLETE (DEC-341). Scope: cycle-004 delta (baseline 42e92b46 → develop 024de4d8); info-asymmetry wall honored (formal-verifier + security-reviewer did not read F5 findings). Kani: JUSTIFIED SKIP (not provisioned in-repo, cycle-002/003 precedent; proptest/unit substitution; 0 GAP across all 14 new VPs VP-AUTHDX-010..023). Fuzz: JUSTIFIED SKIP (not provisioned; proptest arbitrary-input substitution; 0 uncovered input surface across DPAPI envelope, tenant_info parse+body-cap, profile-name guard, cloud_id plausibility). Mutation: PROCESS GAP FOUND + PARTIALLY CLOSED — none of the cycle-004 files were in .cargo/mutants.toml examine_globs, so CI mutation had zero signal on the delta; an explicit --file override killed 97-100% on the default-CI-testable surface (meets the >=95% credential-module bar), with sub-90% raw rates traced to spec-declared keyring-gated (VP-005/006/007) and Windows-#[cfg] (VP-010) boundaries; the 5 genuine tenant.rs body-cap-boundary survivors were KILLED via FIX-F6-1 (PR #775 @ 024de4d8) and tenant.rs (now 21/21, 100%) was added to examine_globs; the remaining 4 delta files' examine_globs gap is deferred, tracked as F6-MUTATION-EXAMINE-GLOBS-EXPANSION. Security (Touchpoint #3): CLEAN, no CRIT/HIGH (cargo audit + cargo deny clean bar the pre-existing accepted chacha20 skip DEC-185; new windows-sys 0.60 dep is cfg(windows)-scoped, zero new graph nodes; manual CWE pass clean; DEC-334 reconfirmed accurate). Regression: full suite GREEN (CI 3-OS matrix + local 4900+/0). DTU adversarial / accessibility: SKIPPED (dtu_required:false; no UI surface). Verdict: F6 COMPLETE — all hardening checks pass or justified-skip; the one genuine test-quality gap (tenant.rs body-cap) fixed in-cycle; the examine_globs process gap partially closed (tenant.rs) with the remainder deferred. Full narrative: phase-f6-hardening/cycle-004/summary.md (cites kani-results.md/fuzz-results.md/mutation-results.md/security-scan-results.md/code-delivery/FIX-F6-1-pr-review.md). develop tip now 024de4d8. Pipeline stays ACTIVE, phase F6→F7. Next: F7 pre-gate fresh-context consistency audit + input-hash drift check, 5-dimensional delta convergence check, the REQUIRED manual Windows-11 smoke gate (human reproduces #759 on real Windows 11), the final human F7 convergence gate, then release."
trajectory_tail: "→1→3→0→2"
maintenance_run:
  status: COMPLETE
  date: 2026-08-25
  findings_count: 10
  fixes_applied: 6
  fixes_pending: 4
  pr: 737
current_cycle: "cycle-004"
feature_mode_bundle: windows-correctness
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: SOH-ATTACHMENTS-1 F5 SCOPED ADVERSARIAL CONVERGED 2026-07-24 STRICT (14 rounds; window pass-12/pass-13/pass-14 CLEANx3; spec v1.3.99 to v1.3.106; BC-INDEX v6.38 to v6.44; develop @ db207b81) + F7 DELTA CONVERGENCE APPROVED 2026-07-25 (DEC-186; 5-dim PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED) + CYCLE FULLY CLOSED 2026-07-25
cycle_001_status: "list-read-ergonomics -- CLOSED (DEC-309), historical; see cycles/cycle-001/"
cycle_002_status: "field-dx -- CLOSED + RELEASED 2026-09-01 (DEC-311 close; v0.7.0-dev.3 tagged @ 87f17aff, release.yml run 33459579699 triggered). All 5 stories delivered/merged (F4); F5 CONVERGED (FIX-F5-001, PR #747); F6 COMPLETE (FIX-F6-001, PR #749); F7 COMPLETE (5-dim convergence PASS + full regression PASS 4660/0/106, FIX-F7-001, PR #750 @ 2000c455); RELEASED (version bump PR #751 @ 87f17aff, tag v0.7.0-dev.3 pushed, release.yml triggered). Pipeline SHIPPED."
cycle_003_status: "auth-profile-dx -- CLOSED + RELEASED 2026-09-03 (v0.7.0-dev.4 @ 42e92b46, PR #767; release.yml run 33769389700 SUCCESS; GitHub prerelease published, 10 assets/5 targets). F1-F7 complete + released. Pipeline shipped."
cycle_004_status: "windows-correctness -- F1/F2/F3 APPROVED at their human gates (DEC-335/336/337). Phase F4 (delta implementation) COMPLETE (DEC-339). Phase F5 (scoped adversarial review) CONVERGED (DEC-340). Phase F6 (targeted hardening) COMPLETE (DEC-341, 2026-09-05): Kani/fuzz JUSTIFIED SKIP (proptest substitution, 0 GAP); mutation examine_globs process gap found + partially closed (tenant.rs 100% via FIX-F6-1, PR #775 @ 024de4d8); security CLEAN (no CRIT/HIGH); regression GREEN. Pipeline ACTIVE, phase F7. Next: F7 pre-gate consistency audit + input-hash drift check, 5-dimensional delta convergence check, REQUIRED manual Windows-11 smoke gate, final human F7 gate -> release."
activation_head: "42e92b46"
activation_version: "v0.7.0-dev.4"
---

<!-- STATE.md SIZE BUDGET (2026-09-05, cycle-004 Burst 19 -- F6 COMPLETE close-out, F6->F7 transition):
     307 lines (wc-l) -- this burst compacts the prior burst's (Burst 18) F5-convergence close-out
     narrative and records the F6 targeted-hardening outcome as a single COMPLETE summary now that
     the fix PR (PR #775) has landed clean -- the per-dimension hardening detail lives in
     cycles/cycle-004/burst-log.md Burst 19 and phase-f6-hardening/cycle-004/summary.md
     (which itself cites, rather than duplicates, kani-results.md, fuzz-results.md,
     mutation-results.md, security-scan-results.md, and code-delivery/FIX-F6-1-pr-review.md);
     the superseded v3.70 Session Resume Checkpoint is archived to
     cycles/cycle-004/session-checkpoints.md.
     soft-target 200; hard cap 500; margin from soft-target = 107 lines OVER the soft target
     (documented, ongoing known deviation across cycles-002/003/004, not a blocker); margin from actual
     (hard cap) = 193 lines of headroom remain before the hard cap of 500. RECOVERY CONTEXT:
     no crash this burst -- clean resume from the
     Burst-18 F5-CONVERGED position, F6 targeted hardening dispatched (formal-verifier +
     security-reviewer, info-asymmetry wall honored), one fix round (PR #775) delivered and
     merged clean. Hygiene: the three pre-existing dirty files unrelated to any cycle
     (regression-state.json, sidecar-learning.md, the modified S-cycle3-env-tag demo gif)
     remain explicitly NOT staged this burst, consistent with every prior burst. Factory
     lock: no factory_lock frontmatter block is present in this STATE.md and the
     lock-write/verify-sha-currency scripts are not provisioned in this repo -- the
     renew/unlock step this burst is therefore a no-op, noted rather than fabricated. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →1→3→0→2 (unchanged this burst) |
| **Last Updated** | trajectory-tail →1→3→0→2 (unchanged this burst). Burst 19 (2026-09-05) — F6 targeted hardening of the full cycle-004 delta COMPLETE (DEC-341): Kani/fuzz JUSTIFIED SKIP (proptest substitution, 0 GAP); mutation testing found an examine_globs process gap (zero CI signal on the delta) worked around via `--file` override to 97-100%, with 5 genuine `tenant.rs` survivors fixed via PR #775 @ `024de4d8` (current `develop` tip); security scan CLEAN; full regression GREEN. **F6-TARGETED-HARDENING (cycle-004) is COMPLETE.** Pipeline stays ACTIVE; phase F6→F7. |
| **Current Phase** | Feature Mode cycle-004 (`windows-correctness`) -- **Phase F7 (delta convergence), NOT YET DISPATCHED** -- F6 fully complete: Kani/fuzz justified-skip, mutation gap found+partially-closed, security CLEAN, regression GREEN. cycle-001, cycle-002, and cycle-003 remain CLOSED, historical. |
| **Activation HEAD** | `42e92b46` (last-RELEASED `develop` tip, `v0.7.0-dev.4` — unchanged this burst; NOT the current `develop` tip, which has advanced to `024de4d8` via cycle-004's Wave-1/Wave-2/README-fix/F5-fix/F6-fix merges ahead of the next release cut) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, cycles/cycle-003/burst-log.md, cycles/cycle-004/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| F4-DELTA-IMPLEMENTATION (cycle-004) | **COMPLETE** | 2026-09-05 | Wave 1 + Wave 2 integration gates PASSED; Wave 2's 3 README findings fixed in-cycle | **All 4 stories delivered + merged:** `S-cycle4-dpapi-storage-fix` (PR #768 @ `9119b291`), `S-cycle4-cloud-id-correctness` (PR #769 @ `c2074247`), `S-cycle4-windows-docs` (PR #770 @ `abb283e8`), `S-cycle4-honest-fail-message` (PR #771 @ `281ba272`). Both wave integration gates PASSED (DEC-338 + Wave 2 CLEAN-of-emergent); README findings fixed via PR #772 @ `e5a18fe0`. Full detail: `cycles/cycle-004/burst-log.md` Bursts 15-17. | counts: 742/55/106/172 (unchanged) |
| F5-SCOPED-ADVERSARIAL (cycle-004) | **CONVERGED** | 2026-09-05 | 3 fresh adversary passes + 1 cross-model secondary; 0 CRIT/HIGH/MED (DEC-340) | Scope: cycle-004 delta (PRs #768/#769/#771 code + #770/#772 docs) on `develop`. Round 1 found 3 actionable LOWs, fixed via **PR #773 @ `f3863f07`**. Round 2 (2 adversary + 1 cross-model secondary) found several corroborated actionable LOWs, all fixed per human "fix everything actionable" decision via **PR #774 @ `3b62cefa`**. Residuals documented as by-design/convention/unreachable. Full detail: `phase-f5-adversarial/cycle-004/convergence-summary.md`. | counts unchanged (742/55/106/172); trajectory 3→several(corroborated)→0, **CONVERGED (DEC-340)** |
| F6-TARGETED-HARDENING (cycle-004) | **COMPLETE** | 2026-09-05 | Kani/fuzz JUSTIFIED SKIP; mutation 97-100% on testable surface + tenant.rs 100%; security CLEAN; regression GREEN (DEC-341) | Scope: cycle-004 delta (`42e92b46`→`024de4d8`), info-asymmetry wall honored. Kani/fuzz: not provisioned in-repo, proptest substitution, 0 GAP/0 uncovered surface. Mutation: `.cargo/mutants.toml` examine_globs did not cover the delta (zero CI signal); `--file` override killed 97-100% on the default-CI-testable surface; sub-90% raw rates are spec-declared keyring-gated/Windows-`#[cfg]` boundaries; 5 genuine `tenant.rs` body-cap survivors KILLED via **FIX-F6-1 (PR #775 @ `024de4d8`)**, `tenant.rs` now 21/21 (100%) and added to examine_globs (remaining 4 delta files' gap deferred). Security: CLEAN, no CRIT/HIGH (cargo audit/deny clean bar the pre-existing chacha20 skip; new `windows-sys 0.60` dep cfg(windows)-scoped; manual CWE pass clean; DEC-334 reconfirmed). Regression: full suite GREEN (CI 3-OS + local 4900+/0). DTU/accessibility: SKIPPED (not applicable). Full detail: `phase-f6-hardening/cycle-004/summary.md`. | counts unchanged (742/55/106/172); F6 verdict **COMPLETE (DEC-341)** |
| F7-DELTA-CONVERGENCE (cycle-004) | **PENDING** | — | 5-dimensional convergence check on the delta + full regression + REQUIRED manual Windows-11 smoke gate + final human gate | Next phase: 5-dimensional delta convergence check on the F6-hardened delta (`develop` @ `024de4d8`), full-codebase regression, the REQUIRED manual Windows-11 smoke gate (human reproduces #759 on real Windows 11), and the final human F7 convergence gate, per feature-mode F7 convention. Not yet dispatched. | counts unchanged (742/55/106/172); F7 not yet started |

## Current Phase Steps (cycle-004, Phase F7 delta convergence — not yet dispatched)

| Step | Status | Notes |
|------|--------|-------|
| F6 targeted hardening dispatch | **DONE — COMPLETE (DEC-341, Burst 19)** | `formal-verifier` (Kani/fuzz/mutation) + `security-reviewer` (Touchpoint #3), info-asymmetry wall honored, scoped to the cycle-004 delta on `develop` @ `3b62cefa`. |
| Mutation examine_globs gap fix | **DONE — PARTIAL (Burst 19)** | 5 genuine `tenant.rs` body-cap mutation survivors fixed and `tenant.rs` added to `.cargo/mutants.toml` examine_globs via **PR #775 @ `024de4d8`** (current `develop` tip). Remaining 4 delta files' examine_globs gap deferred — tracked as `F6-MUTATION-EXAMINE-GLOBS-EXPANSION`. |
| F6 hardening verdict | **DONE — COMPLETE (DEC-341, Burst 19)** | All dimensions pass or justified-skip; regression GREEN; security CLEAN. Summary persisted to `phase-f6-hardening/cycle-004/summary.md`. |
| F7 pre-gate consistency audit + input-hash drift check | **PENDING — NEXT** | Fresh-context `consistency-validator` audit of the cycle-004 delta plus an input-hash drift scan, ahead of the 5-dimensional convergence check. |
| F7 5-dimensional delta convergence check | **PENDING** | Standard feature-mode F7 5-dim check (files touched, count reconciliation, doc consistency, build/artifact integrity, source-change attestation) on the F6-hardened delta. |
| REQUIRED manual Windows-11 smoke gate | **PENDING** | Human reproduces #759 on real Windows 11 — required per DEC-335/DEC-337's Windows-validation plan; occurs at F7, not F4. |
| Final human F7 convergence gate → release | **PENDING** | Human sign-off on the F7 convergence verdict, then release on authorization. |

(Prior cycle-004 Burst-1 through Burst-18 steps — human triage, DEC-334, F1/F2/F3 dispatch and human gates, crash recovery, formal-verifier VP delta, 25 adversarial passes across two convergence attempts, F3 story decomposition + 4-round review convergence, two SESSION WRAPs, F4 Wave 1/Wave 2 delivery+merge+gates (DEC-338/DEC-339), the Wave 2 README-fix PR #772, and the F5 scoped adversarial review (2 fix rounds, PR #773 + PR #774, DEC-340) — archived to `cycles/cycle-004/burst-log.md` Bursts 1-18. Burst-19's F6 targeted hardening (1 fix round, PR #775, DEC-341) — archived to `cycles/cycle-004/burst-log.md` Burst 19.)

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-341 | cycle-004 F6 targeted hardening COMPLETE — VP 0-GAP; Kani/fuzz justified-skip (proptest substitution); mutation 97-100% on default-CI-testable surface + tenant.rs 100% and the 5 body-cap survivors killed via FIX-F6-1 (PR #775 @ `024de4d8`); examine_globs process-gap partially closed (tenant.rs added, remainder deferred); security CLEAN (no CRIT/HIGH); regression green. Advance to F7 | `.cargo/mutants.toml` examine_globs did not cover any cycle-004 delta file, so CI mutation had zero signal on the diff; a manual `--file`-override run substituted for that gap and found the pure/decision-logic surface already at 97-100%, with 5 genuine `tenant.rs` body-cap survivors fixed in-cycle; Kani/fuzz absence was accepted per the cycle-002/003 precedent (proptest substitution, 0 VP gap); security scan and full regression both clean/green. The remaining examine_globs coverage gap (4 files) was judged non-blocking process debt, not a defect in the delivered code, and deferred to a future maintenance cycle rather than expanded in-cycle | F6 | 2026-09-05 | autonomous (DEC-330/331 auto-merge policy) + human session authorization (merge approvals) |
| DEC-340 | cycle-004 F5 scoped adversarial review CONVERGED — 0 CRIT/HIGH/MED across 3 fresh adversary passes + 1 cross-model secondary; actionable LOWs fixed in-cycle (human "fix everything actionable") via PR #773 (@ `f3863f07`) + PR #774 (@ `3b62cefa`); by-design/convention/unreachable residuals documented. Advance to F6 | Round 1 (1 adversary pass) found 3 actionable LOWs, fixed and re-reviewed CLEAN. Round 2 (2 adversary passes + 1 cross-model code-reviewer secondary, run in parallel for cognitive diversity) independently corroborated several further actionable LOWs and found 0 CRIT/HIGH/MED; human elected to fix every actionable finding rather than defer any, all resolved and re-reviewed CLEAN with full suite green (4920/0) and clean clippy/fmt. Novelty decayed to LOW across the trajectory — feature-mode F5 convergence bar met | F5 | 2026-09-05 | autonomous (DEC-330/331 auto-merge policy) + human session authorization (merge approvals + fix-everything-actionable decision) |
| DEC-339 | cycle-004 F4 COMPLETE — Wave 2 delivered+merged (#771 honest-fail-message incl. B-1/B-2/NB-1/NB-2/NEW-1 review fixes @ `281ba272`; #770 windows-docs already merged), Wave 2 integration gate PASSED (emergent-defect charter CLEAN), and the 3 README doc-consistency gate findings fixed in-cycle per human decision via PR #772 @ `e5a18fe0`. Advance to F5 scoped adversarial | Both Wave-2 stories reached clean fresh-context review (PR #771 after two fix rounds: 2 BLOCKING+NB-1/NB-2, then 1 LOW NEW-1, both resolved) and green CI; the Wave 2 integration gate found no emergent cross-story defects against its chartered hazard (a doc contradicting DEC-334's revoke-granularity correction); the 3 non-emergent README findings the gate did surface were judged worth fixing immediately rather than deferring, since they were directly related to this cycle's own subject matter (auth credential storage/revoke UX) | F4 | 2026-09-05 | autonomous (DEC-330/331 auto-merge policy) + human session authorization (merge approvals + fix-all-3-in-cycle decision) |
| (341 older cycle-004/003/002/001 decisions) | DEC-338 through DEC-309 and earlier — unchanged this burst | — | F1-F7/historical | 2026-08-24…2026-09-05 | various — see `cycles/cycle-004/burst-log.md` Bursts 1-18 and `cycles/cycle-003/burst-log.md` Bursts 13-22 |

**cycle-004 note (Burst 19, this burst):** DEC-341 (F6 COMPLETE) recorded above. The next open decision points are: (1) the F7 pre-gate consistency audit + 5-dimensional delta convergence check, then (2) the REQUIRED manual Windows-11 smoke gate, then (3) the final F7 human gate → release.

## Skip Log

| Step | Skipped? | Justification |
|------|----------|----------------|
| UX Spec (cycle-002) | yes | `jr` is a CLI-only product; field-dx bundle adds no UI surfaces. |
| DTU creation (cycle-002) | yes | `dtu_required: false` -- no external service behavior is being cloned by this bundle. |
| F5 secondary review-tier (Step 7, cycle-002) | yes | Every story already individually adversarially converged in F4; primary pass found only 1 low-likelihood MED + 4 LOW. |
| F6 Kani formal verification (cycle-002) | yes | Not set up in repo; proptest substitution justified (32/32 VPs covered, 0 GAP). |
| F6 cargo-fuzz (cycle-002) | yes | Not set up in repo; proptest arbitrary-input substitution justified (0 uncovered input surface). |
| F6 DTU adversarial testing / accessibility re-check (cycle-002) | yes | `dtu_required: false`; `feature_type: backend-cli`, no UI surface. |
| UX Spec (cycle-003) | yes | `jr` is CLI-only; auth-profile-dx confirmed no-UI-surface at F1/F2, same as cycle-002. |
| DTU creation (cycle-003) | yes | `dtu_required: false` -- auth flows target the real Atlassian OAuth/token endpoints already covered by existing DTU-not-required precedent. |
| Demo recording (cycle-003, Waves 4-5) | yes | Human decision (standing since post-PR#757): demos skipped for Wave 4's two stories and Wave 5's final story. |
| F6 Kani formal verification (cycle-003) | yes | Not set up in repo; proptest substitution justified — VP-AUTHDX-001..009 all covered, 0 GAP. |
| F6 cargo-fuzz (cycle-003) | yes | Not set up in repo; proptest arbitrary-input substitution justified, same precedent as cycle-002. |
| UX Spec (cycle-004) | yes | `jr` is CLI-only; F1 delta-analysis explicitly confirmed `feature_type: backend (infrastructure; no UI)` across all 4 stories. |
| Demo recording (cycle-004, all 4 stories) | yes | Human decision this session: demos skipped for all cycle-004 stories (backend/Windows, no UI surface) — recorded at Burst 15, applies to Wave 1 and Wave 2 stories alike. |
| DTU creation (cycle-004) | yes | `dtu_required: false` — #759's DPAPI-file fallback targets the OS keychain/filesystem, not a third-party service being cloned; confirmed at F4, no reversal. |
| F6 Kani formal verification (cycle-004) | yes | Not set up in repo; proptest/unit substitution justified — VP-AUTHDX-010..023 (all 14 new cycle-004 VPs) covered, 0 GAP. |
| F6 cargo-fuzz (cycle-004) | yes | Not set up in repo; proptest arbitrary-input substitution justified — 0 uncovered input surface (DPAPI envelope, tenant_info parse+body-cap, profile-name guard, cloud_id plausibility). |
| F6 DTU adversarial testing / accessibility re-check (cycle-004) | yes | `dtu_required: false`; `tenant_info` is a real endpoint, not a cloned DTU; `feature_type: backend`, no UI surface. |

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/<cycle>/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|

**No open blocking issues.**

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): historical, unchanged this burst.

`cycle-002` (`field-dx`) F2-F7 COMPLETE, human-authorized at the F7 gate (DEC-311). **RELEASED 2026-09-01 as `v0.7.0-dev.3`.** Historical, unchanged this burst.

`cycle-003` (`auth-profile-dx`) F1-F7 all COMPLETE, human-approved at every gate. **RELEASED 2026-09-03 as `v0.7.0-dev.4`** (DEC-333). **cycle-003 is CLOSED** — SHIPPED, historical, unchanged this burst.

`cycle-004` (`windows-correctness`) **F1/F2/F3 all APPROVED. Phase F4 COMPLETE (DEC-339). Phase F5 (scoped adversarial review) CONVERGED (DEC-340). Phase F6 (targeted hardening) COMPLETE (DEC-341).** All 4 stories merged: `S-cycle4-dpapi-storage-fix` (PR #768 @ `9119b291`), `S-cycle4-cloud-id-correctness` (PR #769 @ `c2074247`), `S-cycle4-windows-docs` (PR #770 @ `abb283e8`), `S-cycle4-honest-fail-message` (PR #771 @ `281ba272`). Both wave integration gates PASSED; Wave 2's README findings fixed via PR #772 @ `e5a18fe0`. F5 scoped adversarial review of the full delta CONVERGED via PR #773 @ `f3863f07` + PR #774 @ `3b62cefa`. F6 targeted hardening ran Kani/fuzz (JUSTIFIED SKIP, proptest substitution, 0 GAP), mutation testing (examine_globs process gap found + partially closed, tenant.rs 100% via **PR #775 @ `024de4d8`**), security scan (CLEAN, no CRIT/HIGH), and full regression (GREEN). **Pipeline ACTIVE, phase F7** (delta convergence, not yet dispatched). **Counts: total_bcs 742; VPs 55; holdout scenarios 106; stories 172** (all unchanged this burst — FIX-F6-1 added tests only). Reserved Windows device-name set finalized at 30 (ADR-0021 §9, unchanged). **Next:** dispatch F7 pre-gate consistency audit + 5-dimensional delta convergence check → REQUIRED manual Windows-11 smoke gate → final human F7 gate → release.

**cycle-004 is the sole cycle with open work, currently in Phase F7 (not yet dispatched).** cycle-001, cycle-002, and cycle-003 are all CLOSED.

## Concurrent Cycles

Four tracked cycles, **cycle-004 is the sole OPEN cycle (Phase F7, not yet dispatched) — cycle-001, cycle-002, and cycle-003 are all CLOSED, no open work.** `cycle-001` is CLOSED, historical. `cycle-002` (`field-dx`) is **CLOSED + RELEASED** (2026-09-01), historical. `cycle-003` (`auth-profile-dx`) is **CLOSED + RELEASED** (2026-09-03, DEC-333) as **`v0.7.0-dev.4`** @ `42e92b46`, historical. `cycle-004` (`windows-correctness`) is **OPEN, Phase F6 COMPLETE (DEC-341), Phase F7 not yet dispatched** (F1/F2/F3 all APPROVED — DEC-335/336/337; F4 COMPLETE — DEC-339; F5 CONVERGED — DEC-340): all 4 stories merged (PR #768/#769/#770/#771); both wave integration gates PASSED; Wave 2's README findings fixed via PR #772; F5 delta review converged via PR #773 + PR #774; F6 hardening completed via PR #775. `develop` @ `024de4d8` (current tip). The standing auto-merge policy (DEC-330/DEC-331, fully autonomous when CI green + reviewer merge-recommendation + all HIGH/MED findings addressed) and the `gh pr merge`/push MAIN-session-only constraint both remain in effect for any future cycle-004 fix PRs. **Pipeline is ACTIVE**; `phase` frontmatter is **F7**. **Next:** dispatch F7 pre-gate consistency audit + 5-dimensional delta convergence check.

## Constraints Carried Forward

**cycle-004 (windows-correctness, OPEN, Phase F7, Burst 19, this burst):** resumed from the Burst-18 F5-CONVERGED position. F6 targeted hardening dispatched: `formal-verifier` ran Kani/fuzz (both JUSTIFIED SKIP — not provisioned in-repo, proptest substitution, 0 VP-coverage gap across VP-AUTHDX-010..023) and mutation testing, which found the cycle-004 delta files entirely absent from `.cargo/mutants.toml` examine_globs (a real process gap — CI mutation had zero signal on the diff); a `--file`-override run substituted for that gap and found the pure/decision-logic surface already at 97-100%, with 5 genuine `tenant.rs` body-cap mutation survivors. `security-reviewer` ran Touchpoint #3 with the same info-asymmetry wall and found CLEAN — no CRIT/HIGH (cargo audit/deny clean, new `windows-sys 0.60` dep cfg(windows)-scoped, manual CWE pass clean, DEC-334 reconfirmed accurate). The 5 `tenant.rs` survivors were fixed via **PR #775 @ `024de4d8`** (current `develop` tip), which also added `tenant.rs` to examine_globs; fresh-context review CLEAN. Full regression stayed GREEN throughout (CI 3-OS matrix + local 4900+/0). F6-TARGETED-HARDENING declared COMPLETE (DEC-341); phase advanced F6→F7, pipeline stays ACTIVE. Summary persisted to `phase-f6-hardening/cycle-004/summary.md` (cites, does not duplicate, `kani-results.md`, `fuzz-results.md`, `mutation-results.md`, `security-scan-results.md`, `code-delivery/FIX-F6-1-pr-review.md`). **New tracked follow-up (non-blocking):** `F6-MUTATION-EXAMINE-GLOBS-EXPANSION` — the remaining 4 cycle-004 delta files (`src/api/auth.rs`, `src/cli/auth/login.rs`, `src/api/auth_windows_store.rs`, `src/cli/init.rs`) are still absent from examine_globs; test quality on them was manually verified at 97-100% this burst, but CI enforcement is missing pending a keychain-injection seam or a documented exclude_re allowlist for the keyring-gated/Windows-`#[cfg]` boundary survivors. Target: a future SELF-IMPROVEMENT/maintenance cycle. The four items carried from Burst 12/15/16/17/18 continue forward unchanged: **(a)** BC-1.4.035 PC5 production-path VP gap — CI-verified (VP-AUTHDX-010(b)); formal VP itself remains deferred to maintenance, non-blocking. **(b)** `S-410-keychain-test-isolation` same-file overlap on `tests/oauth_refresh_integration.rs` — non-blocking, backlog-unscheduled. **(c)** ADR-0016/ADR-0021 architectural lineage unchanged; BC-1.4.040's path-traversal guard remains DEFENSE-IN-DEPTH; the deferred bc-6 BC-6.2.016 cross-reference remains blocked by the pre-existing TD-031 hook violation, unrelated to cycle-004. **(d)** `W2-INT-PROCESS-GAP-README-PROSE-DRIFT` (from Burst 17) carried forward, justified deferral to a future maintenance cycle. **PRD/VP/BC counts: 742 BCs / 55 VPs / 106 holdout / 172 stories** (all unchanged this burst). Reserved Windows device-name set unchanged at 30 (ADR-0021 §9). **Next:** dispatch F7 pre-gate consistency audit + 5-dimensional delta convergence check.

**cycle-004 (F3 APPROVED → F4 Wave 1/Wave 2/COMPLETE → F5 CONVERGED → F6 COMPLETE, Bursts 14-19, historical detail):** Burst 14 recorded DEC-337 (F3 human gate) and registered the 4 stories. Burst 15 delivered and merged both Wave-1 stories (DEC-338) with the REQUIRED F4 CI spike SUCCEEDING. Burst 16 delivered `windows-docs` to merge and converged (but did not merge) `honest-fail-message`, then executed a session wrap. Burst 17 resumed, concluded and merged PR #771, ran the Wave 2 integration gate, fixed the gate's 3 README findings via PR #772, and declared F4 COMPLETE (DEC-339). Burst 18 dispatched and converged the F5 scoped adversarial review across 2 fix rounds (PR #773, PR #774), declaring F5 CONVERGED (DEC-340). Burst 19 (this burst) dispatched and completed F6 targeted hardening (1 fix round, PR #775), declaring F6 COMPLETE (DEC-341). Full per-burst detail: `cycles/cycle-004/burst-log.md` Bursts 14-19.

**cycle-004 (F2, scoped adversarial convergence + human gate, Bursts 3-11, historical):** the full 25-pass trajectory across two convergence attempts and both pre-gate consistency-validator audits are fully resolved and closed as of the F2 human gate (DEC-336, Burst 11). **PROCESS-GAP (Pass 14, still open, not a blocker):** `scripts/check-bc-cumulative-counts.sh` does not cover a per-file `bc-*.md` "## Summary Stats" closing "Note:" cumulative-prose line. Target: a future SELF-IMPROVEMENT/maintenance cycle. Full per-burst detail: `cycles/cycle-004/burst-log.md` Bursts 4-11.

**cycle-003 (RELEASE + CLOSE, historical):** Human authorized and executed the cycle-003 dev release (DEC-333): PR #767 squash-merged (`c9bb74f4` → `42e92b46`), tag `v0.7.0-dev.4` pushed, `release.yml` run `33769389700` SUCCESS, GitHub prerelease published with 10 assets/5 targets. **cycle-003 is CLOSED.** Both S-7.02 process-gap deferral candidates codified in `cycles/cycle-003/lessons.md`. All prior outstanding, non-blocking items carried forward verbatim (MED-1 VP count unverified, LOW-4/LOW-6 doc nits, 4-story template-compliance gap, 6-file input-hash cascade) — none block cycle-004; deferred to a future maintenance/self-improvement cycle.

**cycle-003 (earlier F1-F7 detail, historical):** F5 findings RESOLVED via PR #763/#764; F6 GATE VERDICT PASS (mutation 100%, security clean, regression GREEN 4763/0/157); F7 pre-gate consistency audit found 12 findings, CRIT/HIGH/most-MED FIXED, MED-1/LOW-4/LOW-6 carried to future maintenance. Full detail: `cycles/cycle-003/burst-log.md` Bursts 10-22.

**Still open (2026-09-02, cycle-003 Wave 1 adversary, standing drift, not a cycle blocker):** `auth status` can transitively trigger the OAuth `"default"`-profile lazy-migration WRITE via `load_oauth_tokens` — pre-existing behavior, unrelated to cycle-003's redesign. Tracked for future maintenance-cycle attention.

**Still open (2026-09-01, cycle-002 F7 human gate + S-7.02 cycle-closing checklist -- justified deferral, carried forward unchanged):**
- `CYCLE-002-PROCESS-GAP-DEFERRAL-1/2/3` (all LOW, justified deferral). Full detail: `cycles/cycle-002/lessons.md` Process-Level items 3/4/5.

**Still open (2026-08-31, cycle-002 F5/F6, unchanged):**
- `F5-EDIT-GATEB-SHARE`, `F5-ISSUETYPE-CASEFOLD-SPLIT`, `F5-VP578021-WEAK-NEGPIN` (all LOW).
- `SEC-F6-1`, `SEC-F6-2` (cross-refs `SEC-001-EDITMETA-RECURSION-GUARD`), `SEC-F6-3` (all LOW).
- `S-578-3-SHARED-ASSET-VALIDATOR`, `S-578-3-FIELDVALUESPEC-RELOCATION`, `S-578-3-PR742-RESIDUAL-NITS` (all LOW).
- `S-578-2-PR741-RESIDUAL-NITS` (LOW, 7 items; `code-delivery/S-578-2/pr-review.md`).

**Still open (unchanged, LOW doc-hygiene / process, non-blocking):**
- `S-580-1-PR740-S1/S2/S3/N1/N2`, `BC-3.3.010-CITATION-UPGRADE-ELIGIBLE`.
- `PRD-DELTA-ROUND2-STEP2A-STALE-NARRATION`, `PLATFORM-ASSET-WIRE-SHAPE-UNVERIFIED`, `M1-EDITMETA-STATUS-PERMISSION-CAVEAT`, `PRD-DELTA-SUMMARY-AMENDED-BC-COUNT-STALE`.
- `BC-INDEX-GUARD-GAP`, `GUARD-SCOPE-COPY-PASTE-PATTERN`, `COUNT-RECONCILIATION-FORCED-CONSISTENCY-PATTERN` -- logged in `cycles/cycle-002/lessons.md`.
- `HOLDOUT-COVERAGE-GAP-LIST-READ-ERGONOMICS-FLAGS`, `STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` (both LOW, pre-existing).
- **A-PA-LOW-001** — CLOSED, implemented by `S-cycle4-cloud-id-correctness` (merged PR #769 @ `c2074247`).
- **OBS-PB-1** (`auth status` credential probe `.is_ok()` swallows a genuine keyring backend error into "not found").
- `auth.rs:~1160` stale doc comment; `remove.rs` step-enumeration doc nit; `chacha20` 0.10.0 yanked-crate advisory (routine `cargo update -p chacha20` at next maintenance sweep).

**cycle-004 maintenance items (carried forward, not blockers):**
- **F6-MUTATION-EXAMINE-GLOBS-EXPANSION** (new, Burst 19) — add `src/api/auth.rs`, `src/cli/auth/login.rs`, `src/api/auth_windows_store.rs` to `.cargo/mutants.toml` examine_globs so CI mutation-tests the credential-critical modules. Needs a keychain-injection seam OR a documented exclude_re allowlist for the keyring-gated (VP-005/006/007) + Windows-`#[cfg]` (VP-010) boundary survivors, else CI floods/times-out. Test quality already verified 97-100% via the manual F6 run; only CI enforcement is missing. Target: a future SELF-IMPROVEMENT/maintenance cycle.
- **TD-031-BLOCKED-BC-6.2.016-CROSSREF** (first recorded Burst 9) — deferred `bc-6-config-cache.md` cross-reference blocked by a pre-existing TD-031 hook violation, unrelated to cycle-004.
- **BC-1.4.035-PC5-VP-GAP** (first recorded Burst 12, UPDATED Burst 15) — production round-trip now CI-verified (VP-AUTHDX-010(b)); formal VP itself still deferred to maintenance.
- **S-410-KEYCHAIN-ISOLATION-FILE-OVERLAP** (first recorded Burst 12) — shares `tests/oauth_refresh_integration.rs` with cycle-004; non-blocking.
- **W2-INT-PROCESS-GAP-README-PROSE-DRIFT** (Burst 17) — no CI guard cross-checks README auth/storage PROSE against the code model (contrast `tests/claude_md_citations.rs`, which checks only path *existence*). Repeated README-vs-code drift across cycles (W2-INT-MED-001, W2-INT-LOW-002 this cycle). Target: a future SELF-IMPROVEMENT/maintenance cycle. Full detail: `code-delivery/wave2-integration-gate-adversary.md`.

**PROCESS-GAP (Pass 14, cycle-004, historical, not a blocker):**
- `scripts/check-bc-cumulative-counts.sh` does not cover a per-file `bc-*.md` "## Summary Stats" closing "Note:" cumulative-prose line. Target: a future SELF-IMPROVEMENT/maintenance cycle.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- ~142 historical stale `input-hash` artifacts factory-wide; standing debt, **not** a cycle blocker.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).

## Session Resume Checkpoint

**Date:** 2026-09-05. **Position:** cycle-004 (`windows-correctness`), **Phase F7 (delta convergence), IN PROGRESS — NOT YET DISPATCHED.** F6 (targeted hardening) is COMPLETE (DEC-341): Kani/fuzz JUSTIFIED SKIP (proptest substitution, 0 GAP); mutation testing found and partially closed an examine_globs process gap (tenant.rs now 100% via PR #775 @ `024de4d8`, current `develop` tip); security scan CLEAN (no CRIT/HIGH); full regression GREEN. cycle-001, cycle-002, and cycle-003 remain CLOSED, historical, unaltered by this burst.

**Convergence:** cycle-004 F2 convergence CLOSED at DEC-336. F3 review convergence COMPLETE, gate APPROVED (DEC-337). All 4 stories individually 3-clean adversarially/consistency converged and merged. F4-phase-level outcome: both wave integration gates PASSED. F5-phase-level convergence loop CLOSED (DEC-340). **F6-phase-level outcome is CLOSED (DEC-341):** Kani/fuzz justified-skip, mutation gap found+partially-closed via 1 fix PR, security CLEAN, regression GREEN → COMPLETE. **No F7-phase-level convergence loop is active yet** — F7 delta convergence has not been dispatched.

**In-flight work:** **NONE running.** No live sub-agents at the moment of this checkpoint. No open cycle-004 PRs.

**What changed this burst (Burst 19):**
1. **F6 targeted hardening dispatched and completed.** `formal-verifier` ran Kani/fuzz (both JUSTIFIED SKIP, proptest substitution, 0 VP-coverage gap) and mutation testing on `develop` @ `3b62cefa`, info-asymmetry wall honored (no F5 findings visibility).
2. **Mutation examine_globs process gap found.** None of the cycle-004 delta files were in `.cargo/mutants.toml` examine_globs, so CI mutation had zero signal; a `--file`-override run substituted, finding 97-100% on the testable surface with 5 genuine `tenant.rs` body-cap survivors.
3. **Security scan CLEAN** — no CRIT/HIGH (cargo audit/deny clean, new `windows-sys 0.60` dep cfg(windows)-scoped, manual CWE pass clean, DEC-334 reconfirmed).
4. **Fix delivered.** `tenant.rs`'s 5 mutation survivors fixed and `tenant.rs` added to examine_globs via **PR #775 @ `024de4d8`** (current `develop` tip), fresh-context re-review CLEAN.
5. **F6-TARGETED-HARDENING declared COMPLETE (DEC-341)** — all dimensions pass or justified-skip; the examine_globs gap partially closed (tenant.rs) with the remainder deferred as `F6-MUTATION-EXAMINE-GLOBS-EXPANSION`.
6. **Summary persisted** to `phase-f6-hardening/cycle-004/summary.md`, citing (not duplicating) `kani-results.md`, `fuzz-results.md`, `mutation-results.md`, `security-scan-results.md`, and `code-delivery/FIX-F6-1-pr-review.md`.
7. **STATE.md transitioned** `phase: F6→F7` (pipeline stays ACTIVE); version v3.70→v3.71 in one atomic Write; the superseded v3.70 checkpoint archived to `cycles/cycle-004/session-checkpoints.md`; Burst 14-18 historical detail further compacted.

**NEXT ACTION on resume (exact, in order):**
1. Dispatch the **F7 pre-gate fresh-context consistency audit** (`consistency-validator`) plus an input-hash drift check on the cycle-004 delta.
2. Run the **5-dimensional delta convergence check** on the F6-hardened delta (`develop` @ `024de4d8`) plus full-codebase regression.
3. The **REQUIRED manual Windows-11 smoke gate** (human reproduces #759 on real Windows 11).
4. The **final human F7 convergence gate**, then release on human authorization.

**Carried-forward non-blocking items:** `F6-MUTATION-EXAMINE-GLOBS-EXPANSION` (new this burst); the REQUIRED F7 manual Windows-11 smoke gate; the 2 pr-review follow-up nits from #768/#769; `init.rs` double `cloud_id` writer (LOW, re-confirmed acceptable at F5 Round 2 as NIT-1); BC-1.4.035 PC5 `store_pair`-failure→`DpapiFallbackFailed` production-path is CI-verified (VP-010b), formal VP still AC-only; `W2-INT-PROCESS-GAP-README-PROSE-DRIFT` (no CI guard cross-checks README prose against the code model — target a future maintenance cycle). Per the S-7.02 cycle-closing checklist these are for cycle-close, not this burst.

**Counts: total_bcs 742; VP count 55; holdout scenarios 106; total_stories 172** (all unchanged this burst — FIX-F6-1 added tests only).

**EXACT RESUME COMMAND:** `/vsdd-factory:next-step` (reads STATE.md, resumes by dispatching the F7 pre-gate consistency audit).

**Superseded checkpoints:** the prior cycle-004 checkpoint (v3.70, 2026-09-05 — recorded the F5→F6 transition) is superseded in place by this checkpoint and archived to `cycles/cycle-004/session-checkpoints.md` ahead of this Write, with its forward "superseded at" note pointing to this v3.71 checkpoint. Earlier archives (v3.69 F4→F5 transition, v3.68 SESSION WRAP/PAUSED, v3.66 F3→F4 transition, v3.65 SESSION-WRAP/PAUSED, v3.64 F3-CONVERGED, v3.62 Passes 20-25, v3.61 gate-audit/Pass-20, v3.60 Passes 12-14, v3.59 Passes 9-11, v3.58 Passes 7-8, v3.57 Passes 5-6, v3.56 Passes 1-4, v3.55 crash-recovery, v3.54 F1-APPROVED, v3.53 F1-IN-PROGRESS) remain at `cycles/cycle-004/session-checkpoints.md`; the cycle-003 checkpoints (v3.52 through v3.31) remain at `cycles/cycle-003/session-checkpoints.md`; cycle-002 checkpoints (v3.29 through v3.23 and earlier) remain at `cycles/cycle-002/session-checkpoints.md`; the cycle-001 CLOSED-position checkpoint (v3.05) remains at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-14 = F2/F3/F4; 15 = F5 CONVERGED + FIX-F5-001; 16 = F6 COMPLETE + FIX-F6-001; 17 = F7 delta-convergence PASS + FIX-F7-001; 18 = F7 human gate APPROVED + cycle-002 CLOSED; 19 = release v0.7.0-dev.3 SHIPPED; 20 = SESSION-WRAP) |
| cycle-003 burst history | `cycles/cycle-003/burst-log.md` (Burst 1 = cycle OPENED; Bursts 2-9 = F1 through F3 gates; Bursts 10-15 = F4 Waves 1-5, all 7 stories merged; Burst 16 = F5 findings fixed; Burst 17 = SESSION WRAP, F5 CONVERGED; Burst 18 = SESSION RESUMED, F6 DISPATCHED; Burst 19 = F6 COMPLETE — PASS; Burst 20 = F7 pre-gate consistency audit; Burst 21 = F7 human gate APPROVED — CONVERGED (DEC-332); Burst 22 = RELEASE v0.7.0-dev.4 SHIPPED, cycle-003 CLOSED (DEC-333)) |
| cycle-004 burst history | `cycles/cycle-004/burst-log.md` (Burst 1 = cycle OPENED; Burst 2 = F1 human gate APPROVED (DEC-335); Burst 3 = CRASH RECOVERY; Bursts 4-10 = F2 scoped adversarial convergence, 25 passes across two attempts + 2 consistency audits; Burst 11 = F2 HUMAN GATE APPROVED (DEC-336); Burst 12 = F3 story decomposition CONVERGED; Burst 13 = SESSION WRAP (F3 gate pending); Burst 14 = F3 HUMAN GATE APPROVED (DEC-337), phase F3→F4; Burst 15 = F4 Wave 1 DELIVERED + MERGED, integration gate PASSED (DEC-338), F4 CI spike SUCCEEDED; Burst 16 = F4 Wave 2 PARTIALLY DELIVERED (`windows-docs` merged, `honest-fail-message` converged/PR-open/reviews-halted) + SESSION WRAP; Burst 17 = PR #771 review resumed + merged @ `281ba272`, Wave 2 integration gate PASSED, README findings fixed via PR #772 @ `e5a18fe0`, F4 COMPLETE (DEC-339), phase F4→F5; Burst 18 = F5 scoped adversarial review CONVERGED (DEC-340) via 2 fix rounds — PR #773 @ `f3863f07`, PR #774 @ `3b62cefa` — phase F5→F6; Burst 19 = **F6 targeted hardening COMPLETE (DEC-341)** via 1 fix round — PR #775 @ `024de4d8` — phase F6→F7) |
| cycle-004 F1 delta-analysis artifacts | `cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md` + `affected-files.txt` |
| cycle-004 F2 spec-evolution artifacts | `cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md`; `vp-delta.md`; `specs/architecture/decisions/ADR-0021-*.md` (amended Burst 16 with the §6 revoke-advice correction); `specs/architecture/decisions/ADR-0022-*.md` |
| cycle-004 F3 story-decomposition artifacts | `cycles/cycle-004/phase-f3-stories/` — `decomposition-manifest.md`, `S-cycle4-{dpapi-storage-fix,cloud-id-correctness,honest-fail-message,windows-docs}.md`, `dependency-graph-extended.md`, `wave-schedule.md`, `conflict-report.md`, `wave-holdout-scenarios/` |
| cycle-004 F4 implementation delivery evidence | `code-delivery/S-cycle4-{dpapi-storage-fix,cloud-id-correctness,windows-docs}/pr-review.md`; `code-delivery/S-cycle4-honest-fail-message/{pr-review.md,pr-approve-body.md,pr-rereview-new1.md,pr-rereview-pr-reviewer.md,pr-rereview-security.md}` (PR #771, all 4 stories now merged) |
| cycle-004 F4 Wave 2 integration gate + README fix evidence | `code-delivery/wave2-integration-gate-adversary.md` (gate report); `code-delivery/FIX-W2-INT-README-pr-review.md` (PR #772) |
| cycle-004 F5 scoped adversarial review evidence | `phase-f5-adversarial/cycle-004/convergence-summary.md` (summary); `code-delivery/FIX-F5-CYCLE4-1-pr-review.md` (PR #773 review); `code-delivery/FIX-F5-CYCLE4-2-pr-review.md` (PR #774 review) |
| cycle-004 F6 targeted hardening evidence | `phase-f6-hardening/cycle-004/summary.md` (summary); `phase-f6-hardening/cycle-004/{kani-results.md,fuzz-results.md,mutation-results.md,security-scan-results.md}`; `code-delivery/FIX-F6-1-pr-review.md` (PR #775 review) |
| cycle-004 revoke-granularity research | `research/atlassian-3lo-revoke-granularity-2026-09-05.md` (Perplexity-validated; grounds the DEC-334 amendment) |
| cycle-004 session checkpoints | `cycles/cycle-004/session-checkpoints.md` (archives v3.64 through v3.70; this burst writes the live v3.71 into STATE.md directly) |
| cycle-004 cloud_id research | `research/edge-tenant-info-cloudid-2026-09-03.md` |
| cycle-003 grounding + phase artifacts | `cycles/cycle-003/investigation/`, `cycles/cycle-003/phase-f1-delta-analysis/`, `phase-f2-spec-evolution/`, `phase-f3-stories/`, `phase-f4-implementation/`, `phase-f6-hardening/`, `phase-f7-convergence/` |
| cycle-003 release + F4/F5 delivery evidence | version-bump PR #767 (`develop` @ `42e92b46`); tag `v0.7.0-dev.4`; `release.yml` run `33769389700`; `code-delivery/FIX-F7-DOCS-1/`, `code-delivery/S-cycle3-*/`, `code-delivery/FIX-F5-*/` |
| cycle-002/cycle-001 historical artifacts | `cycles/cycle-002/`, `cycles/cycle-001/` (see per-cycle files) |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**cycle-004 (F6 COMPLETE, Phase F7 not yet dispatched, Burst 19, this burst):** resumed from the Burst-18 F5-CONVERGED position. F6 targeted hardening dispatched: Kani/fuzz JUSTIFIED SKIP (proptest substitution, 0 GAP); mutation testing found an examine_globs process gap (zero CI signal on the delta) worked around via `--file` override to 97-100%, with 5 genuine `tenant.rs` survivors fixed via PR #775 @ `024de4d8` (current `develop` tip); security scan CLEAN; full regression GREEN. F6-TARGETED-HARDENING declared COMPLETE (DEC-341); phase advanced F6→F7, pipeline stays ACTIVE. **New tracked item (non-blocking):** `F6-MUTATION-EXAMINE-GLOBS-EXPANSION` — the remaining 4 cycle-004 delta files still lack CI mutation enforcement; test quality manually verified 97-100%, only CI wiring is missing. **Tracked items carried forward, all non-blocking:** BC-1.4.035-PC5-VP-GAP (production path CI-verified, formal VP still deferred), S-410-KEYCHAIN-ISOLATION-FILE-OVERLAP, TD-031-BLOCKED-BC-6.2.016-CROSSREF, W2-INT-PROCESS-GAP-README-PROSE-DRIFT. `SEC-WCM-DOC-DPAPI-GAP` remains CLOSED (via PR #770, Burst 16). **Hygiene note:** the three pre-existing unrelated dirty files (`regression-state.json`, `sidecar-learning.md`, `S-cycle3-env-tag` demo gif) remain explicitly NOT staged this burst, per standing instruction. **Next:** dispatch F7 pre-gate consistency audit + 5-dimensional delta convergence check.

**cycle-004 (F4 Wave 1/Wave 2 delivery + F5 convergence + F6 hardening, Bursts 15-19, historical):** `S-cycle4-dpapi-storage-fix` (PR #768 @ `9119b291`) + `S-cycle4-cloud-id-correctness` (PR #769 @ `c2074247`) delivered and merged; F4 CI spike SUCCEEDED; Wave 1 integration gate PASSED (DEC-338). `S-cycle4-windows-docs` (PR #770 @ `abb283e8`) delivered and merged; `S-cycle4-honest-fail-message` (PR #771 @ `281ba272`) converged and merged with a DEC-334 revoke-advice correction, Wave 2 gate PASSED, README findings fixed via PR #772 @ `e5a18fe0`. F5 scoped adversarial review converged via PR #773 @ `f3863f07` + PR #774 @ `3b62cefa`. F6 targeted hardening completed via PR #775 @ `024de4d8`. Full detail `cycles/cycle-004/burst-log.md` Bursts 15-19.

**cycle-004 (F3 APPROVED, F3→F4 transition, Bursts 13-14, historical):** Burst 13 was a pure human-requested pause. Burst 14: human APPROVED the F3 gate (DEC-337); `STORY-INDEX.md` registered (168→172); phase advanced F3→F4, pipeline PAUSED→ACTIVE. Full detail `cycles/cycle-004/burst-log.md` Bursts 13-14.

**cycle-004 (F2, scoped adversarial convergence + human gate, Bursts 3-11, historical):** the full 25-pass trajectory, the post-Pass-6 consistency sweep, and both pre-gate consistency audits are fully resolved and closed as of DEC-336. **PROCESS-GAP (Pass 14, still open):** `scripts/check-bc-cumulative-counts.sh` coverage gap on per-file Summary-Stats-Note prose, target a future maintenance cycle. Full detail: `cycles/cycle-004/burst-log.md` Bursts 4-11.

**cycle-003 (RELEASE + CLOSE, historical):** DEC-333: PR #767 squash-merged, tag `v0.7.0-dev.4` pushed, `release.yml` SUCCESS, GitHub prerelease published. **cycle-003 is CLOSED.** Both S-7.02 process-gap deferrals codified in `cycles/cycle-003/lessons.md`. All prior outstanding items (MED-1, LOW-4/LOW-6, template-compliance gap, input-hash cascade) deferred to a future maintenance cycle.

**cycle-003 (F7 pre-gate audit + F5/F6 detail, historical):** 12-finding pre-gate consistency audit, CRIT/HIGH/most-MED FIXED, MED-1/LOW-4/LOW-6 carried forward. F5 findings RESOLVED via PR #763/#764; F6 GATE VERDICT PASS (mutation 100%, security clean, regression 4763/0/157). Full detail: `cycles/cycle-003/burst-log.md` Bursts 16-20.

**cycle-003 (earlier F4/F3/F2 resolutions, historical):** F1 (BYO-OAuth-cred over-delete) and ADR-0011 doc-drift CLOSED (Burst 15). ADR-0011-staged-not-applied CLOSED (Burst 14, `S-cycle3-adr0011-newtype` PR #758). DEC-NAMESPACE-COLLISION-RISK clean (max ID DEC-341, no collision). Wave 1/2 integration gates PASSED; all 7 cycle-003 stories squash-merged.

**Still open (2026-09-02, cycle-003 Wave 1 adversary, standing drift, not a cycle blocker):** `auth status` can transitively trigger the OAuth `"default"`-profile lazy-migration WRITE via `load_oauth_tokens` — pre-existing behavior. Tracked for future maintenance-cycle attention.

**Still open (2026-09-01, cycle-002 F7 human gate + S-7.02 checklist — justified deferral, unchanged):**
- `CYCLE-002-PROCESS-GAP-DEFERRAL-1/2/3` (all LOW). Full detail: `cycles/cycle-002/lessons.md` Process-Level items 3/4/5.

**Still open (2026-08-31, cycle-002 F5/F6, unchanged):**
- `F5-EDIT-GATEB-SHARE`, `F5-ISSUETYPE-CASEFOLD-SPLIT`, `F5-VP578021-WEAK-NEGPIN` (all LOW).
- `SEC-F6-1`, `SEC-F6-2` (cross-refs `SEC-001-EDITMETA-RECURSION-GUARD`), `SEC-F6-3` (all LOW).
- `S-578-3-SHARED-ASSET-VALIDATOR`, `S-578-3-FIELDVALUESPEC-RELOCATION`, `S-578-3-PR742-RESIDUAL-NITS` (all LOW).
- `S-578-2-PR741-RESIDUAL-NITS` (LOW, 7 items; `code-delivery/S-578-2/pr-review.md`).

**Still open (unchanged, LOW doc-hygiene / process, non-blocking):**
- `S-580-1-PR740-S1/S2/S3/N1/N2`, `BC-3.3.010-CITATION-UPGRADE-ELIGIBLE`.
- `PRD-DELTA-ROUND2-STEP2A-STALE-NARRATION`, `PLATFORM-ASSET-WIRE-SHAPE-UNVERIFIED`, `M1-EDITMETA-STATUS-PERMISSION-CAVEAT`, `PRD-DELTA-SUMMARY-AMENDED-BC-COUNT-STALE`.
- `BC-INDEX-GUARD-GAP`, `GUARD-SCOPE-COPY-PASTE-PATTERN`, `COUNT-RECONCILIATION-FORCED-CONSISTENCY-PATTERN` -- logged in `cycles/cycle-002/lessons.md`.
- `HOLDOUT-COVERAGE-GAP-LIST-READ-ERGONOMICS-FLAGS`, `STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` (both LOW, pre-existing).
- **A-PA-LOW-001** — CLOSED, implemented by `S-cycle4-cloud-id-correctness` (merged).
- **OBS-PB-1** (`auth status` credential probe `.is_ok()` swallows a genuine keyring backend error into "not found").
- `auth.rs:~1160` stale doc comment; `remove.rs` step-enumeration doc nit; `chacha20` 0.10.0 yanked-crate advisory.

**cycle-004 maintenance items (carried forward, not blockers):**
- **F6-MUTATION-EXAMINE-GLOBS-EXPANSION** (new, Burst 19) — expand `.cargo/mutants.toml` examine_globs to the 4 remaining cycle-004 credential-critical files; needs a keychain-injection seam or documented exclude_re allowlist. Target a future SELF-IMPROVEMENT/maintenance cycle.
- **TD-031-BLOCKED-BC-6.2.016-CROSSREF** — blocked by pre-existing TD-031 hook violation, unrelated to cycle-004.
- **BC-1.4.035-PC5-VP-GAP** — production round-trip now CI-verified (VP-AUTHDX-010(b)); formal VP deferred.
- **S-410-KEYCHAIN-ISOLATION-FILE-OVERLAP** — shares `tests/oauth_refresh_integration.rs` with cycle-004; non-blocking.
- **W2-INT-PROCESS-GAP-README-PROSE-DRIFT** (Burst 17) — no CI guard cross-checks README prose against the code model. Target a future maintenance cycle.

**PROCESS-GAP (Pass 14, cycle-004, historical, not a blocker):**
- `scripts/check-bc-cumulative-counts.sh` coverage gap on per-file Summary-Stats-Note prose. Target a future maintenance cycle.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- ~142 historical stale `input-hash` artifacts factory-wide; standing debt, **not** a cycle blocker.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
