---
document_type: pipeline-state
level: ops
version: "3.69"
status: active
producer: state-manager
timestamp: 2026-09-05T16:06:37Z
phase: F5
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-31 latest brownfield (unchanged). trajectory-tail →1→3→0→2 (unchanged this burst). Burst 17: resumed from the Burst-16 wrap halt. PR #771 review re-dispatched fresh: 2 BLOCKING + NB-1/NB-2 found and fixed (b2a0c5d7->17dcccb7); fix-delta re-review found 1 LOW NEW-1, fixed (17dcccb7->29912390); confirmation re-review CLEAN, all 15 CI checks green. PR #771 squash-merged @ 281ba272. F4 Wave 2 integration gate (adversary review of combined diff c2074247..281ba272) verdict CLEAN of emergent cross-story defects; surfaced 3 non-emergent README doc-consistency findings (W2-INT-MED-001/LOW-001/LOW-002) + 1 process-gap, report persisted to code-delivery/wave2-integration-gate-adversary.md. Human decided to fix all 3 README findings in-cycle now: delivered as PR #772 (FIX-W2-INT-README, docs-only), pr-reviewer CLEAN, merged @ e5a18fe0 (current develop tip). F4-DELTA-IMPLEMENTATION (cycle-004) is now COMPLETE (DEC-339): all 4 stories merged (PR #768/#769/#770/#771), both wave integration gates PASSED, Wave 2 README findings resolved. Pipeline PAUSED→ACTIVE, phase F4→F5. PR-771-REVIEW-HALTED closed. Next: F5 scoped adversarial review of the full cycle-004 delta."
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
cycle_004_status: "windows-correctness -- F1/F2/F3 APPROVED at their human gates (DEC-335/336/337). Phase F4 (delta implementation) is COMPLETE (DEC-339, 2026-09-05): Wave 1 (S-cycle4-dpapi-storage-fix PR #768 @ 9119b291 + S-cycle4-cloud-id-correctness PR #769 @ c2074247) and Wave 2 (S-cycle4-windows-docs PR #770 @ abb283e8 + S-cycle4-honest-fail-message PR #771 @ 281ba272, incl. 2 BLOCKING + 1 LOW fix rounds) both merged; both wave integration gates PASSED; Wave 2 gate's 3 README doc-consistency findings fixed in-cycle via PR #772 @ e5a18fe0 (current develop tip). Pipeline ACTIVE, phase F5. Next: F5 scoped adversarial review of the full cycle-004 delta -> F6 targeted hardening -> F7 delta convergence (incl. REQUIRED manual Windows-11 smoke gate) -> release."
activation_head: "42e92b46"
activation_version: "v0.7.0-dev.4"
---

<!-- STATE.md SIZE BUDGET (2026-09-05, cycle-004 Burst 17 -- F4 COMPLETE close-out, F4->F5 transition):
     299 lines (wc-l) -- this burst compacts the prior burst's (Burst 16) verbose
     Wave-1/Wave-2-partial narrative into a single COMPLETE summary now that F4 has fully
     closed -- the per-wave blow-by-blow detail (PR fix rounds, adversary verdicts, README
     findings) lives in cycles/cycle-004/burst-log.md Burst 17, and the superseded v3.68
     Session Resume Checkpoint is archived to cycles/cycle-004/session-checkpoints.md.
     soft-target 200; hard cap 500; margin from soft-target = 99 lines OVER the soft target
     (documented, ongoing known deviation across cycles-002/003/004, not a blocker), but this
     file is meaningfully shorter than the pre-compaction v3.68 content. margin from actual
     (hard cap) = 201 lines of headroom remain before the hard cap of 500. RECOVERY CONTEXT:
     no crash this burst -- clean resume from the Burst-16 wrap, PR #771 review re-dispatched
     and concluded, Wave 2 integration gate run, 3 README findings fixed via a follow-up PR,
     F4 declared COMPLETE. Hygiene: the three pre-existing dirty files unrelated to any cycle
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
| **Last Updated** | trajectory-tail →1→3→0→2 (unchanged this burst). Burst 17 (2026-09-05) — PR #771 review resumed + merged @ `281ba272` (2 BLOCKING + NB-1/NB-2 + fix-delta NEW-1, all fixed); F4 Wave 2 integration gate PASSED (CLEAN of emergent defects; 3 non-emergent README findings surfaced); PR #772 fixed all 3 README findings in-cycle, merged @ `e5a18fe0` (current `develop` tip). **F4-DELTA-IMPLEMENTATION (cycle-004) is COMPLETE (DEC-339).** Pipeline flipped PAUSED→ACTIVE; phase F4→F5. |
| **Current Phase** | Feature Mode cycle-004 (`windows-correctness`) -- **Phase F5 (scoped adversarial review), NOT YET DISPATCHED** -- F4 fully complete: all 4 stories merged, both wave integration gates PASSED, Wave 2's README findings resolved. cycle-001, cycle-002, and cycle-003 remain CLOSED, historical. |
| **Activation HEAD** | `42e92b46` (last-RELEASED `develop` tip, `v0.7.0-dev.4` — unchanged this burst; NOT the current `develop` tip, which has advanced to `e5a18fe0` via cycle-004's Wave-1/Wave-2/README-fix merges ahead of the next release cut) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, cycles/cycle-003/burst-log.md, cycles/cycle-004/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| F2-SPEC-EVOLUTION (cycle-004) | APPROVED | 2026-09-04 | human-approved F2 gate (DEC-336) | ADR-0021, ADR-0022, architecture-delta.md; +9 BCs/1 amended (733→742); +14 VPs (41→55). Full detail: `cycles/cycle-004/phase-f2-spec-evolution/`. | counts: 742/55/106/168; trajectory converged to **APPROVED (DEC-336)** |
| F3-INCREMENTAL-STORIES (cycle-004) | APPROVED | 2026-09-04 | human-approved F3 gate (DEC-337) | 4 stories, 41 ACs, 10 BCs + 14 VPs each covered by exactly one story, acyclic dependency graph. Registered in `STORY-INDEX.md` (168→172). Full detail: `cycles/cycle-004/phase-f3-stories/`. | counts: 742/55/106/172; trajectory converged to **APPROVED (DEC-337)** |
| F4-DELTA-IMPLEMENTATION (cycle-004) | **COMPLETE** | 2026-09-05 | Wave 1 + Wave 2 integration gates PASSED; Wave 2's 3 README findings fixed in-cycle | **All 4 stories delivered + merged:** `S-cycle4-dpapi-storage-fix` (PR #768 @ `9119b291`), `S-cycle4-cloud-id-correctness` (PR #769 @ `c2074247`), `S-cycle4-windows-docs` (PR #770 @ `abb283e8`), `S-cycle4-honest-fail-message` (PR #771 @ `281ba272`, incl. a 2-BLOCKING + 1-LOW fix-round chain on re-review). **REQUIRED F4 CI spike SUCCEEDED**: VP-AUTHDX-010(b) CI-verified on windows-latest (real `CryptProtectData` round-trip). **Wave 1 integration gate PASSED (DEC-338):** combined-wave review CLEAN (file-disjoint, mutually-exclusive auth branches). **Wave 2 integration gate PASSED:** combined diff `c2074247..281ba272` verdict CLEAN of emergent cross-story defects (the chartered DEC-334-contradiction hazard does not exist); surfaced 3 non-emergent README doc-consistency findings + 1 process-gap, all 3 findings fixed in-cycle via follow-up PR #772 @ `e5a18fe0` (current `develop` tip), pr-reviewer CLEAN. Demo recording SKIPPED for all 4 cycle-004 stories (Skip Log; backend/Windows, no UI surface). Full detail: `cycles/cycle-004/burst-log.md` Bursts 15-17; gate report `code-delivery/wave2-integration-gate-adversary.md`. | counts: 742/55/106/172 (unchanged); no adversarial passes yet at the F4 phase level — F5 scoped-adversarial review follows |
| F5-SCOPED-ADVERSARIAL (cycle-004) | **PENDING** | — | fresh-context adversarial review, scoped to the cycle-004 delta | Next phase: adversarial review scoped to all 4 stories' merged code (`c2074247`..`e5a18fe0` on `develop`, plus PR #768/#769's already-merged content), different model family from implementation, per feature-mode F5 convention. Not yet dispatched. | counts unchanged (742/55/106/172); F5 clean-streak not yet started |

## Current Phase Steps (cycle-004, Phase F5 scoped adversarial — not yet dispatched)

| Step | Status | Notes |
|------|--------|-------|
| F4 Wave 2 PR #771 review resumed + concluded | **DONE — MERGED (Burst 17)** | Fresh pr-reviewer + security-reviewer found 2 BLOCKING + NB-1/NB-2 (fixed `b2a0c5d7`→`17dcccb7`); fix-delta re-review found 1 LOW NEW-1 (fixed `17dcccb7`→`29912390`); confirmation CLEAN, 15/15 CI green. Squash-merged @ `281ba272`. |
| F4 Wave 2 integration gate | **DONE — PASSED (Burst 17)** | Combined diff `c2074247..281ba272` verdict CLEAN of emergent cross-story defects; 3 non-emergent README findings + 1 process-gap surfaced. Report: `code-delivery/wave2-integration-gate-adversary.md`. |
| Wave 2 README findings fix (human decision: in-cycle now) | **DONE — MERGED (Burst 17)** | PR #772 (`FIX-W2-INT-README`, docs-only) fixed W2-INT-MED-001/LOW-001/LOW-002; pr-reviewer CLEAN; merged @ `e5a18fe0`. |
| F4 phase completion | **DONE — COMPLETE (DEC-339, Burst 17)** | All 4 stories merged, both wave gates PASSED, Wave 2 findings resolved. |
| F5 scoped adversarial review dispatch | **PENDING — NEXT** | Fresh-context adversary review scoped to the cycle-004 delta (all 4 stories' merged code), different model family. |
| F6 targeted hardening | **PENDING** | Follows F5 convergence (3 consecutive clean passes or human gate decision). |
| F7 delta convergence + manual Windows-11 smoke gate | **PENDING** | REQUIRED per DEC-335/DEC-337's Windows-validation plan; the manual smoke gate occurs at F7, not F4. |

(Prior cycle-004 Burst-1 through Burst-16 steps — human triage, DEC-334, F1/F2/F3 dispatch and human gates, crash recovery, formal-verifier VP delta, 25 adversarial passes across two convergence attempts, F3 story decomposition + 4-round review convergence, two SESSION WRAPs, F4 Wave 1 delivery+merge+gate (DEC-338), and F4 Wave 2 partial delivery — archived to `cycles/cycle-004/burst-log.md` Bursts 1-16. Burst-17's PR #771 review conclusion, Wave 2 integration gate, README-fix PR #772, and F4 COMPLETE close-out — archived to `cycles/cycle-004/burst-log.md` Burst 17.)

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-339 | cycle-004 F4 COMPLETE — Wave 2 delivered+merged (#771 honest-fail-message incl. B-1/B-2/NB-1/NB-2/NEW-1 review fixes @ `281ba272`; #770 windows-docs already merged), Wave 2 integration gate PASSED (emergent-defect charter CLEAN), and the 3 README doc-consistency gate findings fixed in-cycle per human decision via PR #772 @ `e5a18fe0`. Advance to F5 scoped adversarial | Both Wave-2 stories reached clean fresh-context review (PR #771 after two fix rounds: 2 BLOCKING+NB-1/NB-2, then 1 LOW NEW-1, both resolved) and green CI; the Wave 2 integration gate found no emergent cross-story defects against its chartered hazard (a doc contradicting DEC-334's revoke-granularity correction); the 3 non-emergent README findings the gate did surface were judged worth fixing immediately rather than deferring, since they were directly related to this cycle's own subject matter (auth credential storage/revoke UX) | F4 | 2026-09-05 | autonomous (DEC-330/331 auto-merge policy) + human session authorization (merge approvals + fix-all-3-in-cycle decision) |
| DEC-338 | cycle-004 F4 Wave 1 delivered + integration gate PASSED. `S-cycle4-dpapi-storage-fix` (PR #768 @ `9119b291`) + `S-cycle4-cloud-id-correctness` (PR #769 @ `c2074247`) both squash-merged autonomously per the standing DEC-330/331 auto-merge policy, with the human's explicit push/PR/merge authorization this session. REQUIRED F4 CI spike SUCCEEDED — VP-AUTHDX-010(b) CI-verified on windows-latest. Demo recording SKIPPED for all cycle-004 stories (Skip Log) | Both stories reached 3-clean per-story adversarial convergence, security-reviewer MERGE-CLEAR/clear, and pr-reviewer APPROVE; the combined-wave integration review found the two stories file-disjoint with mutually-exclusive auth branches (no emergent integration defects); the windows-latest CI leg's real `CryptProtectData` execution resolved the prior Windows-verification residual and caught 2 real pre-merge defects | F4 | 2026-09-05 | autonomous (DEC-330/331 policy) + human session authorization |
| DEC-337 | cycle-004 F3 incremental story decomposition APPROVED at the human gate — advance to F4 (delta implementation). Human confirmed: (1) scope = exactly DEC-335's 4 stories, nothing added or dropped; (2) release-bundling of #759 items 1+2 via the `depends_on` edge kept as two independently-traceable stories, accepted; (3) two-tier Windows validation accepted — REQUIRED F4 CI spike + REQUIRED F7 manual Windows-11 smoke gate; (4) three carried-forward non-blockers accepted as deferred | Human reviewed the F3 decomposition (4 stories / 41 ACs / 10 BCs + 14 VPs, one story each; acyclic dependency graph; template-compliant; converged 6→4→3→CLEAN over 4 fresh-context review rounds) and approved advancing to F4 Wave 1 | F3 gate | 2026-09-04 | human |
| DEC-336 | cycle-004 F2 spec-evolution delta APPROVED at the human gate — advance to F3. 4-story DEC-335 scope fully covered (no gap/creep); path-traversal guard + clear-path adapter KEPT as defense-in-depth; classic-vs-scoped-token Assets honesty caveat accepted. F2 delta: ADR-0021 + ADR-0022 + architecture-delta; 9 new BCs (BC-1.4.035..040, BC-1.2.052..054) + amended BC-1.4.028; 14 new VPs. Counts 733→742 BCs, 41→55 VPs | Human reviewed the F2 spec delta at the gate (converged: two 3-consecutive-clean adversarial runs; consistent: 2nd gate consistency audit CONSISTENT) and approved advancing to F3 | F2 gate | 2026-09-04 | human |
| DEC-335 | cycle-004 F1 delta-analysis APPROVED at human gate — standard F1→F7 route, 4 stories (`dpapi-storage-fix` + `honest-fail-message` bundled, `windows-docs`, `cloud_id-correctness` incl. `A-PA-LOW-001`). Windows-validation plan: F4 CI spike + required F7 manual Windows smoke gate | Human reviewed the architect's F1 report and answered all six open questions — scope EXPANDED to fold in the `cloud_id` fix; `honest-fail-message` bundled with `dpapi-storage-fix`; Windows-validation plan accepted; `windows`-vs-`windows-sys` deferred to F2; `clear_all_credentials` untouched | F1 | 2026-09-03 | human |
| DEC-334 | Human authorized a new Feature-Mode cycle (cycle-004 `windows-correctness`) bundling GitHub issues #759 + #760. #759 fix strategy = keyring-first + user-scope DPAPI-encrypted file fallback (%LOCALAPPDATA%) for oversized OAuth tokens + honest-fail backstop. **Amendment (Burst 16, 2026-09-05, no new DEC ID):** adversarial review found CONFIRMED-harmful account-wide-revoke advice in the originally-bundled #759 messaging design; fixed via BC-1.4.039 + ADR-0021 §6 amendment (Perplexity-validated research), then hardened further via PR #771's own review (2 BLOCKING findings on the fix itself, Burst 17) before merge | #759 is a live, high-impact defect on `v0.7.0-dev.4`; the amendment closes a genuine user-harm risk discovered mid-delivery before any release shipped the flawed advice | F1 / F4-amendment | 2026-09-03 / 2026-09-05 | human / adversarial-review-driven correction |
| (333 older cycle-003/002/001 decisions) | DEC-333 through DEC-309 and earlier — unchanged this burst | — | F1-F7/historical | 2026-08-24…2026-09-03 | various — see `cycles/cycle-003/burst-log.md` Bursts 13-22 |

**cycle-004 note (Burst 17, this burst):** DEC-339 (F4 COMPLETE) recorded above. The next open decision points are: (1) the F5 scoped-adversarial-review dispatch and its convergence trajectory, then (2) the F5 human gate (or 3-consecutive-clean auto-advance, per feature-mode convention), then F6/F7.

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

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/<cycle>/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|

**No open blocking issues.** `PR-771-REVIEW-HALTED` (tracked in Burst 16) is CLOSED this burst — resolved via re-dispatched review + merge (Burst 17).

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): historical, unchanged this burst.

`cycle-002` (`field-dx`) F2-F7 COMPLETE, human-authorized at the F7 gate (DEC-311). **RELEASED 2026-09-01 as `v0.7.0-dev.3`.** Historical, unchanged this burst.

`cycle-003` (`auth-profile-dx`) F1-F7 all COMPLETE, human-approved at every gate. **RELEASED 2026-09-03 as `v0.7.0-dev.4`** (DEC-333). **cycle-003 is CLOSED** — SHIPPED, historical, unchanged this burst.

`cycle-004` (`windows-correctness`) **F1/F2/F3 all APPROVED. Phase F4 (delta implementation) is COMPLETE (DEC-339).** All 4 stories merged: `S-cycle4-dpapi-storage-fix` (PR #768 @ `9119b291`), `S-cycle4-cloud-id-correctness` (PR #769 @ `c2074247`), `S-cycle4-windows-docs` (PR #770 @ `abb283e8`), `S-cycle4-honest-fail-message` (PR #771 @ `281ba272`). Both wave integration gates PASSED; Wave 2's 3 README doc-consistency findings fixed in-cycle via PR #772 @ `e5a18fe0` (current `develop` tip). **Pipeline ACTIVE, phase F5** (scoped adversarial review, not yet dispatched). **Counts: total_bcs 742; VPs 55; holdout scenarios 106; stories 172** (all unchanged this burst — the two follow-up PRs in Wave 2/README-fix added no BCs/stories). Reserved Windows device-name set finalized at 30 (ADR-0021 §9, unchanged). **Next:** dispatch F5 scoped adversarial review of the full cycle-004 delta → F6 targeted hardening → F7 delta convergence (incl. the REQUIRED manual Windows-11 smoke gate) → release.

**cycle-004 is the sole cycle with open work, currently in Phase F5 (not yet dispatched).** cycle-001, cycle-002, and cycle-003 are all CLOSED.

## Concurrent Cycles

Four tracked cycles, **cycle-004 is the sole OPEN cycle (Phase F5, not yet dispatched) — cycle-001, cycle-002, and cycle-003 are all CLOSED, no open work.** `cycle-001` is CLOSED, historical. `cycle-002` (`field-dx`) is **CLOSED + RELEASED** (2026-09-01), historical. `cycle-003` (`auth-profile-dx`) is **CLOSED + RELEASED** (2026-09-03, DEC-333) as **`v0.7.0-dev.4`** @ `42e92b46`, historical. `cycle-004` (`windows-correctness`) is **OPEN, Phase F4 COMPLETE (DEC-339), Phase F5 not yet dispatched** (F1/F2/F3 all APPROVED — DEC-335/336/337): all 4 stories merged (PR #768/#769/#770/#771); both wave integration gates PASSED; Wave 2's 3 README findings fixed via PR #772. `develop` @ `e5a18fe0` (current tip). The standing auto-merge policy (DEC-330/DEC-331, fully autonomous when CI green + reviewer merge-recommendation + all HIGH/MED findings addressed) and the `gh pr merge`/push MAIN-session-only constraint both remain in effect for any future cycle-004 fix PRs. **Pipeline is ACTIVE**; `phase` frontmatter is **F5**. **Next:** dispatch F5 scoped adversarial review.

## Constraints Carried Forward

**cycle-004 (windows-correctness, OPEN, Phase F5, Burst 17, this burst):** resumed from the Burst-16 wrap halt. PR #771's review was re-dispatched fresh, found 2 BLOCKING (B-1: Site-1 cleanup-advice command misled in the brand-new-profile case; B-2: `CHANGELOG.md` denied a cross-platform message change) + NB-1 (source-scan guard defeated by line-wrapping) + NB-2 (CLAUDE.md lockstep) — all fixed. Fix-delta re-review found 1 LOW WARNING NEW-1 (`auth_method.is_none()` unsafe proxy for "brand-new profile") — fixed via a `profile_has_stored_credentials` existence-probe. Confirmation re-review CLEAN, 15/15 CI green, PR #771 squash-merged @ `281ba272`. The F4 Wave 2 integration gate (combined diff `c2074247..281ba272`) verdict CLEAN of emergent cross-story defects, but surfaced 3 non-emergent README doc-consistency findings (W2-INT-MED-001, W2-INT-LOW-001, W2-INT-LOW-002) + 1 process-gap; human decided to fix all 3 in-cycle now via PR #772 (docs-only), pr-reviewer CLEAN, merged @ `e5a18fe0`. F4-DELTA-IMPLEMENTATION declared COMPLETE (DEC-339); phase advanced F4→F5, pipeline PAUSED→ACTIVE. **New tracked item this burst:** `W2-INT-PROCESS-GAP-README-PROSE-DRIFT` (see Drift/Standing Items below) — a justified deferral to a future maintenance cycle, not a blocker. **Closed this burst:** `PR-771-REVIEW-HALTED`. The three items carried from Burst 12/15/16 continue forward unchanged: **(a)** BC-1.4.035 PC5 production-path VP gap — CI-verified (VP-AUTHDX-010(b)); formal VP itself remains deferred to F6/maintenance, non-blocking. **(b)** `S-410-keychain-test-isolation` same-file overlap on `tests/oauth_refresh_integration.rs` — non-blocking, backlog-unscheduled. **(c)** ADR-0016/ADR-0021 architectural lineage unchanged; BC-1.4.040's path-traversal guard remains DEFENSE-IN-DEPTH; the deferred bc-6 BC-6.2.016 cross-reference remains blocked by the pre-existing TD-031 hook violation, unrelated to cycle-004. **PRD/VP/BC counts: 742 BCs / 55 VPs / 106 holdout / 172 stories** (all unchanged this burst). Reserved Windows device-name set unchanged at 30 (ADR-0021 §9). **Next:** dispatch F5 scoped adversarial review.

**cycle-004 (F3 APPROVED → F4 Wave 1/Wave 2/COMPLETE, Bursts 14-17, historical detail):** Burst 14 recorded DEC-337 (F3 human gate) and registered the 4 stories. Burst 15 delivered and merged both Wave-1 stories (DEC-338) with the REQUIRED F4 CI spike SUCCEEDING. Burst 16 delivered `windows-docs` to merge and converged (but did not merge) `honest-fail-message`, then executed a session wrap. Burst 17 (this burst) resumed, concluded and merged PR #771, ran the Wave 2 integration gate, fixed the gate's 3 README findings via PR #772, and declared F4 COMPLETE (DEC-339). Full per-burst detail: `cycles/cycle-004/burst-log.md` Bursts 14-17.

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
- **TD-031-BLOCKED-BC-6.2.016-CROSSREF** (first recorded Burst 9) — deferred `bc-6-config-cache.md` cross-reference blocked by a pre-existing TD-031 hook violation, unrelated to cycle-004.
- **BC-1.4.035-PC5-VP-GAP** (first recorded Burst 12, UPDATED Burst 15) — production round-trip now CI-verified (VP-AUTHDX-010(b)); formal VP itself still deferred to F6/maintenance.
- **S-410-KEYCHAIN-ISOLATION-FILE-OVERLAP** (first recorded Burst 12) — shares `tests/oauth_refresh_integration.rs` with cycle-004; non-blocking.
- **W2-INT-PROCESS-GAP-README-PROSE-DRIFT** (new, Burst 17) — no CI guard cross-checks README auth/storage PROSE against the code model (contrast `tests/claude_md_citations.rs`, which checks only path *existence*). Repeated README-vs-code drift across cycles (W2-INT-MED-001, W2-INT-LOW-002 this cycle). Target: a future SELF-IMPROVEMENT/maintenance cycle. Full detail: `code-delivery/wave2-integration-gate-adversary.md`.

**PROCESS-GAP (Pass 14, cycle-004, historical, not a blocker):**
- `scripts/check-bc-cumulative-counts.sh` does not cover a per-file `bc-*.md` "## Summary Stats" closing "Note:" cumulative-prose line. Target: a future SELF-IMPROVEMENT/maintenance cycle.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- ~142 historical stale `input-hash` artifacts factory-wide; standing debt, **not** a cycle blocker.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).

## Session Resume Checkpoint

**Date:** 2026-09-05. **Position:** cycle-004 (`windows-correctness`), **Phase F5 (scoped adversarial review), IN PROGRESS — NOT YET DISPATCHED.** F4 (delta implementation) is COMPLETE (DEC-339): all 4 stories merged (PR #768 @ `9119b291`, PR #769 @ `c2074247`, PR #770 @ `abb283e8`, PR #771 @ `281ba272`); both wave integration gates PASSED; Wave 2's 3 README findings fixed via PR #772 @ `e5a18fe0` (current `develop` tip). cycle-001, cycle-002, and cycle-003 remain CLOSED, historical, unaltered by this burst.

**Convergence:** cycle-004 F2 convergence CLOSED at DEC-336. F3 review convergence COMPLETE, gate APPROVED (DEC-337). All 4 stories individually 3-clean adversarially/consistency converged and merged. **F4-phase-level outcome:** both wave integration gates PASSED (Wave 1 CLEAN; Wave 2 CLEAN-of-emergent, with 3 non-emergent README findings fixed in-cycle). **No F5-phase-level convergence loop is active yet** — F5 scoped adversarial review has not been dispatched.

**In-flight work:** **NONE running.** No live sub-agents at the moment of this checkpoint. No open cycle-004 PRs.

**What changed this burst (Burst 17):**
1. **PR #771 review resumed + concluded + merged** @ `281ba272` — 2 BLOCKING + NB-1/NB-2 found and fixed; fix-delta re-review found 1 LOW NEW-1, fixed; confirmation CLEAN, 15/15 CI green.
2. **F4 Wave 2 integration gate PASSED** — combined diff `c2074247..281ba272` CLEAN of emergent cross-story defects; surfaced 3 non-emergent README findings + 1 process-gap. Report: `code-delivery/wave2-integration-gate-adversary.md`.
3. **PR #772 (`FIX-W2-INT-README`, docs-only) delivered + merged** @ `e5a18fe0` — fixed all 3 README findings per human decision to resolve in-cycle now; pr-reviewer CLEAN.
4. **F4-DELTA-IMPLEMENTATION declared COMPLETE (DEC-339)** — all 4 stories merged, both wave gates PASSED, Wave 2 findings resolved. `PR-771-REVIEW-HALTED` CLOSED.
5. **STATE.md transitioned** `phase: F4→F5`, `pipeline: PAUSED→ACTIVE`; version v3.68→v3.69 in one atomic Write; the superseded v3.68 checkpoint archived to `cycles/cycle-004/session-checkpoints.md`; Burst 15-16 historical detail compacted (this file is meaningfully shorter than the pre-compaction v3.68 content).

**NEXT ACTION on resume (exact, in order):**
1. Dispatch **F5 scoped adversarial review** — fresh-context adversary review scoped to the full cycle-004 delta (all 4 stories' merged code on `develop`, `c2074247..e5a18fe0` plus the two Wave-1 PRs' already-merged content), different model family from the implementer per feature-mode F5 convention.
2. Drive the F5 convergence loop toward 3 consecutive clean passes (or a human decision to gate earlier, per cycle-002/cycle-003 precedent).
3. **F6 targeted hardening** — formal verification / fuzz / mutation testing scoped to the delta, full regression + security scans on the full tree.
4. **F7 delta convergence** — 5-dimensional convergence check on the delta + full-codebase regression, **including the REQUIRED manual Windows-11 smoke gate** (human reproduces #759 on real Windows 11) + the final human F7 gate.
5. **Release** on human authorization.

**Carried-forward non-blocking items:** REQUIRED F7 manual Windows-11 smoke gate; the 2 pr-review follow-up nits from #768/#769; `init.rs` double `cloud_id` writer (LOW); BC-1.4.035 PC5 `store_pair`-failure→`DpapiFallbackFailed` production-path is CI-verified (VP-010b), formal VP still AC-only; **new this burst:** `W2-INT-PROCESS-GAP-README-PROSE-DRIFT` (no CI guard cross-checks README prose against the code model — target a future maintenance cycle). Per the S-7.02 cycle-closing checklist these are for cycle-close, not this burst.

**Counts: total_bcs 742; VP count 55; holdout scenarios 106; total_stories 172** (all unchanged this burst — no BC/VP/story added by either PR #771's honest-fail-message code or PR #772's docs-only README fix).

**EXACT RESUME COMMAND:** `/vsdd-factory:next-step` (reads STATE.md, resumes by dispatching the F5 scoped adversarial review).

**Superseded checkpoints:** the prior cycle-004 checkpoint (v3.68, 2026-09-05 — recorded the SESSION WRAP mid-Wave-2) is superseded in place by this checkpoint and archived to `cycles/cycle-004/session-checkpoints.md` ahead of this Write, with its forward "superseded at" note pointing to this v3.69 checkpoint. Earlier archives (v3.66 F3→F4 transition, v3.65 SESSION-WRAP/PAUSED, v3.64 F3-CONVERGED, v3.62 Passes 20-25, v3.61 gate-audit/Pass-20, v3.60 Passes 12-14, v3.59 Passes 9-11, v3.58 Passes 7-8, v3.57 Passes 5-6, v3.56 Passes 1-4, v3.55 crash-recovery, v3.54 F1-APPROVED, v3.53 F1-IN-PROGRESS) remain at `cycles/cycle-004/session-checkpoints.md`; the cycle-003 checkpoints (v3.52 through v3.31) remain at `cycles/cycle-003/session-checkpoints.md`; cycle-002 checkpoints (v3.29 through v3.23 and earlier) remain at `cycles/cycle-002/session-checkpoints.md`; the cycle-001 CLOSED-position checkpoint (v3.05) remains at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-14 = F2/F3/F4; 15 = F5 CONVERGED + FIX-F5-001; 16 = F6 COMPLETE + FIX-F6-001; 17 = F7 delta-convergence PASS + FIX-F7-001; 18 = F7 human gate APPROVED + cycle-002 CLOSED; 19 = release v0.7.0-dev.3 SHIPPED; 20 = SESSION-WRAP) |
| cycle-003 burst history | `cycles/cycle-003/burst-log.md` (Burst 1 = cycle OPENED; Bursts 2-9 = F1 through F3 gates; Bursts 10-15 = F4 Waves 1-5, all 7 stories merged; Burst 16 = F5 findings fixed; Burst 17 = SESSION WRAP, F5 CONVERGED; Burst 18 = SESSION RESUMED, F6 DISPATCHED; Burst 19 = F6 COMPLETE — PASS; Burst 20 = F7 pre-gate consistency audit; Burst 21 = F7 human gate APPROVED — CONVERGED (DEC-332); Burst 22 = RELEASE v0.7.0-dev.4 SHIPPED, cycle-003 CLOSED (DEC-333)) |
| cycle-004 burst history | `cycles/cycle-004/burst-log.md` (Burst 1 = cycle OPENED; Burst 2 = F1 human gate APPROVED (DEC-335); Burst 3 = CRASH RECOVERY; Bursts 4-10 = F2 scoped adversarial convergence, 25 passes across two attempts + 2 consistency audits; Burst 11 = F2 HUMAN GATE APPROVED (DEC-336); Burst 12 = F3 story decomposition CONVERGED; Burst 13 = SESSION WRAP (F3 gate pending); Burst 14 = F3 HUMAN GATE APPROVED (DEC-337), phase F3→F4; Burst 15 = F4 Wave 1 DELIVERED + MERGED, integration gate PASSED (DEC-338), F4 CI spike SUCCEEDED; Burst 16 = F4 Wave 2 PARTIALLY DELIVERED (`windows-docs` merged, `honest-fail-message` converged/PR-open/reviews-halted) + SESSION WRAP; Burst 17 = PR #771 review resumed + merged @ `281ba272`, Wave 2 integration gate PASSED, README findings fixed via PR #772 @ `e5a18fe0`, **F4 COMPLETE (DEC-339)**, phase F4→F5) |
| cycle-004 F1 delta-analysis artifacts | `cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md` + `affected-files.txt` |
| cycle-004 F2 spec-evolution artifacts | `cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md`; `vp-delta.md`; `specs/architecture/decisions/ADR-0021-*.md` (amended Burst 16 with the §6 revoke-advice correction); `specs/architecture/decisions/ADR-0022-*.md` |
| cycle-004 F3 story-decomposition artifacts | `cycles/cycle-004/phase-f3-stories/` — `decomposition-manifest.md`, `S-cycle4-{dpapi-storage-fix,cloud-id-correctness,honest-fail-message,windows-docs}.md`, `dependency-graph-extended.md`, `wave-schedule.md`, `conflict-report.md`, `wave-holdout-scenarios/` |
| cycle-004 F4 implementation delivery evidence | `code-delivery/S-cycle4-{dpapi-storage-fix,cloud-id-correctness,windows-docs}/pr-review.md`; `code-delivery/S-cycle4-honest-fail-message/{pr-review.md,pr-approve-body.md,pr-rereview-new1.md,pr-rereview-pr-reviewer.md,pr-rereview-security.md}` (PR #771, all 4 stories now merged) |
| cycle-004 F4 Wave 2 integration gate + README fix evidence | `code-delivery/wave2-integration-gate-adversary.md` (gate report); `code-delivery/FIX-W2-INT-README-pr-review.md` (PR #772) |
| cycle-004 revoke-granularity research | `research/atlassian-3lo-revoke-granularity-2026-09-05.md` (Perplexity-validated; grounds the DEC-334 amendment) |
| cycle-004 session checkpoints | `cycles/cycle-004/session-checkpoints.md` (archives v3.64 through v3.68; this burst writes the live v3.69 into STATE.md directly) |
| cycle-004 cloud_id research | `research/edge-tenant-info-cloudid-2026-09-03.md` |
| cycle-003 grounding + phase artifacts | `cycles/cycle-003/investigation/`, `cycles/cycle-003/phase-f1-delta-analysis/`, `phase-f2-spec-evolution/`, `phase-f3-stories/`, `phase-f4-implementation/`, `phase-f6-hardening/`, `phase-f7-convergence/` |
| cycle-003 release + F4/F5 delivery evidence | version-bump PR #767 (`develop` @ `42e92b46`); tag `v0.7.0-dev.4`; `release.yml` run `33769389700`; `code-delivery/FIX-F7-DOCS-1/`, `code-delivery/S-cycle3-*/`, `code-delivery/FIX-F5-*/` |
| cycle-002/cycle-001 historical artifacts | `cycles/cycle-002/`, `cycles/cycle-001/` (see per-cycle files) |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**cycle-004 (F4 COMPLETE, Phase F5 not yet dispatched, Burst 17, this burst):** resumed from the Burst-16 wrap. PR #771's review concluded (2 BLOCKING + NB-1/NB-2 fixed, then 1 LOW NEW-1 fixed on re-review), merged @ `281ba272`. F4 Wave 2 integration gate PASSED (CLEAN of emergent defects; 3 non-emergent README findings + 1 process-gap surfaced). Human decided to fix all 3 README findings in-cycle now, delivered via PR #772, merged @ `e5a18fe0`. F4-DELTA-IMPLEMENTATION declared COMPLETE (DEC-339); phase advanced F4→F5, pipeline PAUSED→ACTIVE. **New tracked item:** `W2-INT-PROCESS-GAP-README-PROSE-DRIFT` (no CI guard cross-checks README auth/storage prose against the code model; deferred to a future maintenance cycle). **Closed:** `PR-771-REVIEW-HALTED`. **Tracked items carried forward, all non-blocking:** BC-1.4.035-PC5-VP-GAP (production path CI-verified, formal VP still deferred), S-410-KEYCHAIN-ISOLATION-FILE-OVERLAP, TD-031-BLOCKED-BC-6.2.016-CROSSREF. `SEC-WCM-DOC-DPAPI-GAP` remains CLOSED (via PR #770, Burst 16). **Hygiene note:** the three pre-existing unrelated dirty files (`regression-state.json`, `sidecar-learning.md`, `S-cycle3-env-tag` demo gif) remain explicitly NOT staged this burst, per standing instruction. **Next:** dispatch F5 scoped adversarial review.

**cycle-004 (F4 Wave 1/Wave 2 delivery, Bursts 15-16, historical):** `S-cycle4-dpapi-storage-fix` (PR #768 @ `9119b291`) + `S-cycle4-cloud-id-correctness` (PR #769 @ `c2074247`) delivered and merged; F4 CI spike SUCCEEDED; Wave 1 integration gate PASSED (DEC-338). `S-cycle4-windows-docs` (PR #770 @ `abb283e8`) delivered and merged; `S-cycle4-honest-fail-message` converged pre-merge with a DEC-334 revoke-advice correction. Full detail `cycles/cycle-004/burst-log.md` Bursts 15-16.

**cycle-004 (F3 APPROVED, F3→F4 transition, Bursts 13-14, historical):** Burst 13 was a pure human-requested pause. Burst 14: human APPROVED the F3 gate (DEC-337); `STORY-INDEX.md` registered (168→172); phase advanced F3→F4, pipeline PAUSED→ACTIVE. Full detail `cycles/cycle-004/burst-log.md` Bursts 13-14.

**cycle-004 (F2, scoped adversarial convergence + human gate, Bursts 3-11, historical):** the full 25-pass trajectory, the post-Pass-6 consistency sweep, and both pre-gate consistency audits are fully resolved and closed as of DEC-336. **PROCESS-GAP (Pass 14, still open):** `scripts/check-bc-cumulative-counts.sh` coverage gap on per-file Summary-Stats-Note prose, target a future maintenance cycle. Full detail: `cycles/cycle-004/burst-log.md` Bursts 4-11.

**cycle-003 (RELEASE + CLOSE, historical):** DEC-333: PR #767 squash-merged, tag `v0.7.0-dev.4` pushed, `release.yml` SUCCESS, GitHub prerelease published. **cycle-003 is CLOSED.** Both S-7.02 process-gap deferrals codified in `cycles/cycle-003/lessons.md`. All prior outstanding items (MED-1, LOW-4/LOW-6, template-compliance gap, input-hash cascade) deferred to a future maintenance cycle.

**cycle-003 (F7 pre-gate audit + F5/F6 detail, historical):** 12-finding pre-gate consistency audit, CRIT/HIGH/most-MED FIXED, MED-1/LOW-4/LOW-6 carried forward. F5 findings RESOLVED via PR #763/#764; F6 GATE VERDICT PASS (mutation 100%, security clean, regression 4763/0/157). Full detail: `cycles/cycle-003/burst-log.md` Bursts 16-20.

**cycle-003 (earlier F4/F3/F2 resolutions, historical):** F1 (BYO-OAuth-cred over-delete) and ADR-0011 doc-drift CLOSED (Burst 15). ADR-0011-staged-not-applied CLOSED (Burst 14, `S-cycle3-adr0011-newtype` PR #758). DEC-NAMESPACE-COLLISION-RISK clean (max ID DEC-339, no collision). Wave 1/2 integration gates PASSED; all 7 cycle-003 stories squash-merged.

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
- **TD-031-BLOCKED-BC-6.2.016-CROSSREF** — blocked by pre-existing TD-031 hook violation, unrelated to cycle-004.
- **BC-1.4.035-PC5-VP-GAP** — production round-trip now CI-verified (VP-AUTHDX-010(b)); formal VP deferred.
- **S-410-KEYCHAIN-ISOLATION-FILE-OVERLAP** — shares `tests/oauth_refresh_integration.rs` with cycle-004; non-blocking.
- **W2-INT-PROCESS-GAP-README-PROSE-DRIFT** (new, Burst 17) — no CI guard cross-checks README prose against the code model. Target a future maintenance cycle.

**PROCESS-GAP (Pass 14, cycle-004, historical, not a blocker):**
- `scripts/check-bc-cumulative-counts.sh` coverage gap on per-file Summary-Stats-Note prose. Target a future maintenance cycle.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- ~142 historical stale `input-hash` artifacts factory-wide; standing debt, **not** a cycle blocker.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
