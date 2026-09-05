---
document_type: pipeline-state
level: ops
version: "3.68"
status: active
producer: state-manager
timestamp: 2026-09-05T13:16:51Z
phase: F4
pipeline: PAUSED
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "SESSION WRAP (human /wrap). D-chain cite D-453 latest brownfield (unchanged). trajectory-tail →1→3→0→2 (unchanged this burst). F4 Wave 1 COMPLETE + integration gate PASSED (DEC-338, Burst 15): S-cycle4-dpapi-storage-fix (PR #768 @ 9119b291) + S-cycle4-cloud-id-correctness (PR #769 @ c2074247) both squash-merged; REQUIRED F4 CI spike SUCCEEDED (VP-AUTHDX-010(b) CI-verified on windows-latest). F4 Wave 2 PARTIALLY DELIVERED (Burst 16, this burst): S-cycle4-windows-docs DELIVERED + MERGED (PR #770 @ abb283e8, current origin/develop tip); S-cycle4-honest-fail-message CONVERGED (3 clean adversarial passes, incl. a DEC-334 revoke-advice correction per Perplexity-validated research) but PR #771 (head b2a0c5d707a9daa8543f32acba6e718bcec77907) is OPEN, NOT merged — pr-reviewer + security-reviewer were dispatched and HALTED mid-review for this wrap, must be re-dispatched on resume. Pipeline ACTIVE→PAUSED. STORY-INDEX.md and sprint-state.yaml reconciled to this true state (both flip windows-docs→done, honest-fail-message→in-review; the pre-wrap uncommitted edits found at wrap time anticipated only a Wave-1-complete snapshot and were stale). Local develop is behind at c2074247 (not fast-forwarded — noted, not a durability issue; origin/develop @ abb283e8 is authoritative)."
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
cycle_004_status: "windows-correctness -- F1/F2/F3 APPROVED at their human gates (DEC-335/336/337). Phase F4 (delta implementation): Wave 1 COMPLETE + integration gate PASSED (DEC-338, 2026-09-05) -- S-cycle4-dpapi-storage-fix (PR #768 @ 9119b291) + S-cycle4-cloud-id-correctness (PR #769 @ c2074247) both merged; REQUIRED F4 CI spike SUCCEEDED, VP-AUTHDX-010(b) CI-verified on windows-latest. Wave 2 PARTIALLY DELIVERED (2026-09-05): S-cycle4-windows-docs merged (PR #770 @ abb283e8, current develop tip); S-cycle4-honest-fail-message CONVERGED but PR #771 (head b2a0c5d7) OPEN/unmerged, reviews halted mid-wrap for SESSION WRAP. Pipeline PAUSED. Next on resume: re-dispatch pr-reviewer + security-reviewer for PR #771, merge on clean review, run the Wave 2 integration gate, then F4 COMPLETE -> F5/F6/F7 (F7 includes the REQUIRED manual Windows-11 smoke gate) -> release."
activation_head: "42e92b46"
activation_version: "v0.7.0-dev.4"
---

<!-- STATE.md SIZE BUDGET (2026-09-05, cycle-004 SESSION WRAP / Burst 16):
     306 lines (wc-l) -- this burst is a human-requested `/wrap` checkpoint: reconciles
     STATE.md past two bursts of drift (Burst 15's Wave-1-complete delivery, which was
     narrated in burst-log.md and STORY-INDEX.md/sprint-state.yaml but never actually
     written to the live STATE.md file, plus this burst's own Wave-2-partial delivery),
     flips `pipeline` ACTIVE->PAUSED, updates the Phase Progress F4 row with the full
     delta, replaces Current Phase Steps with the true post-Wave-2-partial position, and
     replaces the Session Resume Checkpoint (v3.66 -> v3.68, skipping the
     never-materialized v3.67 -- see burst-log.md Burst 16 for why), archiving the
     superseded v3.66 checkpoint (already archived ahead of this burst, its forward
     "superseded" note corrected in place this burst) to
     `cycles/cycle-004/session-checkpoints.md`. No F1/F2/F3 spec/BC/VP content changed
     this burst except BC-1.4.039's F1-correction amendment (already made pre-burst,
     committed here). soft-target 200; hard cap 500; margin from soft-target = 104 lines
     OVER the soft target (documented, ongoing known deviation across cycles-002/003/004,
     not a blocker). margin from actual (hard cap) = 196 lines of headroom remain before
     the hard cap of 500. RECOVERY CONTEXT: no crash this burst -- this is a clean,
     human-requested pause mid-Wave-2, with two agent reviews (pr-reviewer-771-cycle1,
     security-reviewer-771) deliberately halted rather than force-completed, per the wrap
     instruction. Hygiene: the three pre-existing-dirty files unrelated to any cycle
     (`regression-state.json`, `sidecar-learning.md`, the modified `S-cycle3-env-tag`
     demo gif) remain explicitly NOT staged this burst, consistent with every prior
     burst. Factory lock: no `factory_lock` frontmatter block is present in this
     STATE.md and the lock-write/verify-sha-currency scripts are not provisioned in
     this repo -- the renew/unlock step this burst is therefore a no-op, noted rather
     than fabricated. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →1→3→0→2 (unchanged this burst) |
| **Last Updated** | SESSION WRAP (human `/wrap`, 2026-09-05, Burst 16) — reconciled STATE.md to the true post-Wave-2-partial state: F4 Wave 1 COMPLETE + integration gate PASSED (DEC-338); F4 Wave 2 partially delivered (`S-cycle4-windows-docs` merged PR #770 @ `abb283e8`; `S-cycle4-honest-fail-message` converged, PR #771 open/unmerged, reviews halted). Pipeline flipped ACTIVE→PAUSED. `STORY-INDEX.md`/`sprint-state.yaml` reconciled to match. cycle-001/002/003 remain CLOSED. trajectory-tail →1→3→0→2 (unchanged this burst). |
| **Current Phase** | Feature Mode cycle-004 (`windows-correctness`) -- **Phase F4 (delta implementation), IN PROGRESS, PAUSED (session wrap)** -- Wave 1 COMPLETE (both stories merged, gate PASSED); Wave 2 partially complete (`windows-docs` merged; `honest-fail-message` converged, PR #771 open, reviews halted). cycle-001, cycle-002, and cycle-003 remain CLOSED, historical. |
| **Activation HEAD** | `42e92b46` (last-RELEASED `develop` tip, `v0.7.0-dev.4` — unchanged this burst; NOT the current `develop` tip, which has advanced to `abb283e8` via cycle-004's Wave-1/Wave-2 merges ahead of the next release cut) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, cycles/cycle-003/burst-log.md, cycles/cycle-004/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| F1-DELTA-ANALYSIS (cycle-004) | APPROVED | 2026-09-03 | human-approved F1 gate (DEC-335) | 4-story scope: `dpapi-storage-fix` + `honest-fail-message` (bundled) + `windows-docs` + `cloud_id-correctness` (closes `A-PA-LOW-001`). Windows-validation plan: F4 CI spike + REQUIRED F7 manual Windows smoke gate. Full detail: `cycles/cycle-004/phase-f1-delta-analysis/`. | counts unchanged (733/41/106/168) |
| F2-SPEC-EVOLUTION (cycle-004) | APPROVED | 2026-09-04 | human-approved F2 gate (DEC-336) | ADR-0021, ADR-0022, architecture-delta.md; +9 BCs/1 amended (733→742); +14 VPs (41→55). 25 fresh-context adversarial passes across two attempts, both consistency-audited CONSISTENT. Full detail: `cycles/cycle-004/phase-f2-spec-evolution/`. | counts: 742/55/106/168; trajectory converged to **APPROVED (DEC-336)** |
| F3-INCREMENTAL-STORIES (cycle-004) | APPROVED | 2026-09-04 | human-approved F3 gate (DEC-337) | 4 stories, 41 ACs, 10 BCs + 14 VPs each covered by exactly one story, acyclic dependency graph. 4 review rounds (6→4→3→CLEAN). Registered in `STORY-INDEX.md` (168→172); 9/10 BC Story Anchor backlinks written in `bc-1-auth-identity.md` (`BC-1.4.028` amended has no such field, skipped). Full detail: `cycles/cycle-004/phase-f3-stories/`. | counts: 742/55/106/172; trajectory converged to **APPROVED (DEC-337)** |
| F4-DELTA-IMPLEMENTATION (cycle-004) | **IN PROGRESS, PAUSED** | Wave 1: 2026-09-05 | (per-story TDD; no phase gate until F5) | **Wave 1 COMPLETE, integration gate PASSED (DEC-338, Burst 15):** `S-cycle4-dpapi-storage-fix` (PR #768 @ `9119b291`) + `S-cycle4-cloud-id-correctness` (PR #769 @ `c2074247`) both squash-merged; 3-clean adversarial convergence each; security-reviewer clear both; pr-reviewer APPROVE both; combined-wave integration review CLEAN (file-disjoint, mutually-exclusive auth branches). **REQUIRED F4 CI spike SUCCEEDED**: windows-latest CI leg executed+passed the real `CryptProtectData` round-trip + LOCAL_MACHINE-bit-clear tests — **VP-AUTHDX-010(b) is CI-verified** (2 real defects caught pre-merge). **Wave 2 PARTIALLY DELIVERED (Burst 16, 2026-09-05):** `S-cycle4-windows-docs` DELIVERED + MERGED (PR #770 @ `abb283e8`, current `develop` tip; consistency-validated CONSISTENT, pr-reviewer APPROVE; also fixed the `SEC-WCM-DOC-DPAPI-GAP` CLAUDE.md note). `S-cycle4-honest-fail-message` CONVERGED (3 clean adversarial passes, incl. a DEC-334 correction to CONFIRMED-harmful revoke advice per Perplexity-validated `research/atlassian-3lo-revoke-granularity-2026-09-05.md`) but **PR #771 (head `b2a0c5d707a9daa8543f32acba6e718bcec77907`) is OPEN, NOT merged** — pr-reviewer-771-cycle1 + security-reviewer-771 dispatched but **HALTED mid-review for SESSION WRAP**; must be re-dispatched fresh on resume. **Wave 2 integration gate NOT YET RUN** (gated on PR #771 merging). Demo recording SKIPPED for all 4 cycle-004 stories (Skip Log; backend/Windows, no UI surface). | counts: 742/55/106/172 (unchanged); no adversarial passes yet at the F4 phase level — F5 scoped-adversarial review follows F4 completion |

## Current Phase Steps (cycle-004, Phase F4 delta implementation — PAUSED)

| Step | Status | Notes |
|------|--------|-------|
| F4 Wave 1 dispatch + delivery (`S-cycle4-dpapi-storage-fix` + `S-cycle4-cloud-id-correctness`) | **DONE — MERGED (Burst 15)** | PR #768 @ `9119b291` + PR #769 @ `c2074247`. Both 3-clean adversarial convergence; security-reviewer clear; pr-reviewer APPROVE. |
| F4 CI spike (CryptProtectData headless viability) | **DONE — SUCCEEDED (Burst 15)** | Real `CryptProtectData` round-trip + LOCAL_MACHINE-bit-clear tests ran and passed on windows-latest CI. VP-AUTHDX-010(b) CI-verified. |
| F4 Wave 1 integration gate | **DONE — PASSED (DEC-338, Burst 15)** | Combined-wave adversary review CLEAN; regression satisfied by PR #769's 3-OS CI matrix; demo-of-integration skipped (backend/Windows, Skip Log). |
| F4 Wave 2 dispatch + delivery (`S-cycle4-windows-docs`) | **DONE — MERGED (Burst 16)** | PR #770 @ `abb283e8`, current `develop` tip. Consistency-validated CONSISTENT, pr-reviewer APPROVE. |
| F4 Wave 2 dispatch + delivery (`S-cycle4-honest-fail-message`) | **CONVERGED, PR OPEN — REVIEWS HALTED (Burst 16)** | 3-clean adversarial convergence incl. a DEC-334 revoke-advice correction. PR #771 (head `b2a0c5d7`) open against `abb283e8`. pr-reviewer + security-reviewer dispatched, HALTED mid-review for this wrap — **re-dispatch both fresh on resume**, then merge on clean review + green CI. |
| F4 Wave 2 integration gate | **PENDING** | Gated on PR #771 merging. Combined honest-fail-message + windows-docs wave-diff adversary review + regression, same shape as Wave 1's gate. |
| F4 phase completion → F5 scoped adversarial | **PENDING** | Occurs once both Wave 2 stories are merged and the Wave 2 integration gate passes. |
| F7 manual Windows-11 smoke gate | **PENDING** | REQUIRED per DEC-335/DEC-337's Windows-validation plan; occurs at F7, not F4. |

(Prior cycle-004 Burst-1 through Burst-14 steps — human triage, DEC-334, F1/F2/F3 dispatch and human gates, crash recovery, formal-verifier VP delta, 25 adversarial passes across two convergence attempts, F3 story decomposition + 4-round review convergence, the Burst-13 SESSION WRAP, and the Burst-14 F3 human gate approval (DEC-337) + `STORY-INDEX.md`/BC-backlink registration + F3→F4 transition — archived to `cycles/cycle-004/burst-log.md` Bursts 1-14. Burst-15 F4 Wave-1 delivery+merge+gate (DEC-338) and Burst-16 F4 Wave-2 partial delivery + this SESSION WRAP — archived to `cycles/cycle-004/burst-log.md` Bursts 15-16.)

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-338 | cycle-004 F4 Wave 1 delivered + integration gate PASSED. `S-cycle4-dpapi-storage-fix` (PR #768 @ `9119b291`) + `S-cycle4-cloud-id-correctness` (PR #769 @ `c2074247`) both squash-merged autonomously per the standing DEC-330/331 auto-merge policy, with the human's explicit push/PR/merge authorization this session. REQUIRED F4 CI spike SUCCEEDED — VP-AUTHDX-010(b) CI-verified on windows-latest. Demo recording SKIPPED for all cycle-004 stories (Skip Log) | Both stories reached 3-clean per-story adversarial convergence, security-reviewer MERGE-CLEAR/clear, and pr-reviewer APPROVE; the combined-wave integration review found the two stories file-disjoint with mutually-exclusive auth branches (no emergent integration defects); the windows-latest CI leg's real `CryptProtectData` execution resolved the prior Windows-verification residual and caught 2 real pre-merge defects | F4 | 2026-09-05 | autonomous (DEC-330/331 policy) + human session authorization |
| DEC-337 | cycle-004 F3 incremental story decomposition APPROVED at the human gate — advance to F4 (delta implementation). Human confirmed: (1) scope = exactly DEC-335's 4 stories, nothing added or dropped; (2) release-bundling of #759 items 1+2 via the `depends_on` edge kept as two independently-traceable stories, accepted; (3) two-tier Windows validation accepted — REQUIRED F4 CI spike + REQUIRED F7 manual Windows-11 smoke gate; (4) three carried-forward non-blockers accepted as deferred | Human reviewed the F3 decomposition (4 stories / 41 ACs / 10 BCs + 14 VPs, one story each; acyclic dependency graph; template-compliant; converged 6→4→3→CLEAN over 4 fresh-context review rounds) and approved advancing to F4 Wave 1 | F3 gate | 2026-09-04 | human |
| DEC-336 | cycle-004 F2 spec-evolution delta APPROVED at the human gate — advance to F3. 4-story DEC-335 scope fully covered (no gap/creep); path-traversal guard + clear-path adapter KEPT as defense-in-depth; classic-vs-scoped-token Assets honesty caveat accepted. F2 delta: ADR-0021 + ADR-0022 + architecture-delta; 9 new BCs (BC-1.4.035..040, BC-1.2.052..054) + amended BC-1.4.028; 14 new VPs. Counts 733→742 BCs, 41→55 VPs | Human reviewed the F2 spec delta at the gate (converged: two 3-consecutive-clean adversarial runs; consistent: 2nd gate consistency audit CONSISTENT) and approved advancing to F3 | F2 gate | 2026-09-04 | human |
| DEC-335 | cycle-004 F1 delta-analysis APPROVED at human gate — standard F1→F7 route, 4 stories (`dpapi-storage-fix` + `honest-fail-message` bundled, `windows-docs`, `cloud_id-correctness` incl. `A-PA-LOW-001`). Windows-validation plan: F4 CI spike + required F7 manual Windows smoke gate | Human reviewed the architect's F1 report and answered all six open questions — scope EXPANDED to fold in the `cloud_id` fix; `honest-fail-message` bundled with `dpapi-storage-fix`; Windows-validation plan accepted; `windows`-vs-`windows-sys` deferred to F2; `clear_all_credentials` untouched | F1 | 2026-09-03 | human |
| DEC-334 | Human authorized a new Feature-Mode cycle (cycle-004 `windows-correctness`) bundling GitHub issues #759 + #760. #759 fix strategy = keyring-first + user-scope DPAPI-encrypted file fallback (%LOCALAPPDATA%) for oversized OAuth tokens + honest-fail backstop. **Amendment (Burst 16, 2026-09-05, no new DEC ID — corrects this decision's own bundled downstream messaging, not a fresh gate):** adversarial review of the honest-fail-message story found CONFIRMED-harmful advice in the originally-bundled #759 messaging design — instructing users to revoke `jr`'s Atlassian OAuth grant as "safe cleanup, no other consumer" is FALSE per Perplexity-validated research (`research/atlassian-3lo-revoke-granularity-2026-09-05.md`): revoke is ACCOUNT-WIDE, signing out every `jr` profile. Fixed via BC-1.4.039 + ADR-0021 §6 amendment to scoped-cleanup-default + optional account-wide-warned revoke; a source-scan regression guard was added | #759 is a live, high-impact defect on `v0.7.0-dev.4`; the amendment closes a genuine user-harm risk discovered mid-delivery before any release shipped the flawed advice | F1 / F4-amendment | 2026-09-03 / 2026-09-05 | human / adversarial-review-driven correction |
| DEC-333 | Human authorized and executed the cycle-003 dev release **v0.7.0-dev.4** (PR #767 @ `42e92b46`, tag pushed, `release.yml` run `33769389700` SUCCESS). cycle-003 is CLOSED | F7 delta convergence reached human-approved CONVERGENCE; the human then triggered the release | RELEASE | 2026-09-03 | human |
| (332 older cycle-003/002/001 decisions) | DEC-332 through DEC-309 and earlier — unchanged this burst | — | F1-F7/historical | 2026-08-24…2026-09-03 | various — see `cycles/cycle-003/burst-log.md` Bursts 13-22 |

**cycle-004 note (Burst 16, this burst):** DEC-338 (Wave 1 complete) recorded above, and the DEC-334 revoke-advice amendment is noted in place rather than allocated a fresh DEC ID (it corrects DEC-334's own bundled messaging, discovered via adversarial review, not a new gate decision). The next open decision points are: (1) the PR #771 review conclusion (re-dispatch pr-reviewer + security-reviewer), then (2) the F5 scoped-adversarial-review gate, after F4 Wave 2 completes.

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
| Demo recording (cycle-004, all 4 stories) | yes | Human decision this session: demos skipped for all cycle-004 stories (backend/Windows, no UI surface) — recorded at Burst 15, applies to both Wave 1 stories and, by the same justification, both Wave 2 stories. |
| DTU creation (cycle-004) | yes | `dtu_required: false` — #759's DPAPI-file fallback targets the OS keychain/filesystem, not a third-party service being cloned; confirmed at F4, no reversal. |

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/<cycle>/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| PR-771-REVIEW-HALTED | `S-cycle4-honest-fail-message`'s PR #771 review (pr-reviewer-771-cycle1 + security-reviewer-771) was dispatched but halted mid-review for this session's `/wrap` — not a defect, a deliberate pause | none (process state, not a defect) | F4 Wave 2 completion | state-manager (recorded); orchestrator (re-dispatch owner) | Re-dispatch both reviewers fresh on resume; merge on clean review + green CI |

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): historical, unchanged this burst.

`cycle-002` (`field-dx`) F2-F7 COMPLETE, human-authorized at the F7 gate (DEC-311). **RELEASED 2026-09-01 as `v0.7.0-dev.3`.** Historical, unchanged this burst.

`cycle-003` (`auth-profile-dx`) F1-F7 all COMPLETE, human-approved at every gate. **RELEASED 2026-09-03 as `v0.7.0-dev.4`** (DEC-333). **cycle-003 is CLOSED** — SHIPPED, historical, unchanged this burst.

`cycle-004` (`windows-correctness`) **F1/F2/F3 all APPROVED. Phase F4 (delta implementation): Wave 1 COMPLETE + integration gate PASSED (DEC-338). Wave 2 PARTIALLY COMPLETE** — `S-cycle4-windows-docs` merged (PR #770 @ `abb283e8`); `S-cycle4-honest-fail-message` converged but PR #771 open/unmerged, reviews halted. **Pipeline PAUSED** (human `/wrap`, Burst 16). No active convergence loop — F4 is per-story TDD delivery, not a convergence-pass phase; F5 (scoped adversarial review) follows once F4 fully completes. **Counts: total_bcs 742; VPs 55; holdout scenarios 106; stories 172** (all unchanged this burst — BC-1.4.039 amended in place, not added). Reserved Windows device-name set finalized at 30 (ADR-0021 §9, unchanged). **Next on resume:** re-dispatch pr-reviewer + security-reviewer for PR #771; on clean review + green CI, merge; run the Wave 2 integration gate; then F4 COMPLETE → F5 scoped adversarial → F6 targeted hardening → F7 delta convergence (incl. the REQUIRED manual Windows-11 smoke gate) → release.

**cycle-004 is the sole cycle with open work, currently PAUSED mid-F4.** cycle-001, cycle-002, and cycle-003 are all CLOSED.

## Concurrent Cycles

Four tracked cycles, **cycle-004 is the sole OPEN cycle (currently PAUSED mid-F4) — cycle-001, cycle-002, and cycle-003 are all CLOSED, no open work.** `cycle-001` is CLOSED, historical. `cycle-002` (`field-dx`) is **CLOSED + RELEASED** (2026-09-01), historical. `cycle-003` (`auth-profile-dx`) is **CLOSED + RELEASED** (2026-09-03, DEC-333) as **`v0.7.0-dev.4`** @ `42e92b46`, historical. `cycle-004` (`windows-correctness`) is **OPEN, Phase F4 (delta implementation), PAUSED** (F1/F2/F3 all APPROVED — DEC-335/336/337): Wave 1 COMPLETE + integration gate PASSED (DEC-338) — `S-cycle4-dpapi-storage-fix` (PR #768 @ `9119b291`) + `S-cycle4-cloud-id-correctness` (PR #769 @ `c2074247`) both merged. Wave 2 partially complete — `S-cycle4-windows-docs` merged (PR #770 @ `abb283e8`, current `origin/develop` tip); `S-cycle4-honest-fail-message` converged, PR #771 (head `b2a0c5d7`) open/unmerged, pr-reviewer + security-reviewer HALTED mid-review for this session's `/wrap`. Local `develop` is behind at `c2074247` (not fast-forwarded — noted, not a durability concern, `origin/develop` @ `abb283e8` is authoritative). The standing auto-merge policy (DEC-330/DEC-331, fully autonomous when CI green + reviewer merge-recommendation + all HIGH/MED findings addressed) and the `gh pr merge`/push MAIN-session-only constraint both remain in effect for cycle-004's remaining PR. **Pipeline is PAUSED** (human `/wrap`, Burst 16, 2026-09-05); `phase` frontmatter is **F4**. **Next on resume:** re-dispatch PR #771's reviews, merge, run the Wave 2 integration gate, then proceed to F5.

## Constraints Carried Forward

**cycle-004 (windows-correctness, OPEN, PAUSED mid-F4, Burst 16, this burst):** the human called `/wrap` mid-Wave-2. This burst reconciled STATE.md, `STORY-INDEX.md`, and `sprint-state.yaml` to the true state: Wave 1 COMPLETE (DEC-338, Burst 15, both stories merged, gate PASSED, F4 CI spike SUCCEEDED); Wave 2 partially complete (`windows-docs` merged PR #770 @ `abb283e8`; `honest-fail-message` converged, PR #771 open @ head `b2a0c5d7`, reviews halted). A DEC-334 amendment (Burst 16, no new DEC ID) corrected a CONFIRMED-harmful revoke-advice defect in the honest-fail-message design, found via adversarial review and Perplexity-validated research. Re-ran `compute-input-hash --update` on the 6 cycle-004 artifacts whose `inputs:` cite the amended `bc-1-auth-identity.md` (`vp-delta.md`, `decomposition-manifest.md`, `delta-analysis.md`, and all 3 affected story files). The three tracked items from Burst 12 continue to carry forward, updated where Wave 1 resolved them: **(a)** BC-1.4.035 PC5 production-path VP gap — the production round-trip is now CI-verified (VP-AUTHDX-010(b)); the formal VP itself remains deferred to F6/maintenance, non-blocking. **(b)** `S-410-keychain-test-isolation` same-file overlap on `tests/oauth_refresh_integration.rs` — non-blocking, backlog-unscheduled. **(c)** `CHANGELOG.md [Unreleased]` parallel-edit hotspot — RESOLVED for Wave 1 (keep-both on PR #769); Wave 2's two stories also used keep-both (PR #770, and PR #771's rebase). ADR-0016/ADR-0021 architectural lineage unchanged. BC-1.4.040's path-traversal guard remains DEFENSE-IN-DEPTH. The deferred bc-6 BC-6.2.016 cross-reference remains blocked by the pre-existing TD-031 hook violation, unrelated to cycle-004. **New this burst:** `SEC-WCM-DOC-DPAPI-GAP` (Burst 15) CLOSED via PR #770. **PR-771-REVIEW-HALTED** (see Blocking Issues) is the sole new tracked item — a deliberate pause, not a defect. **PRD/VP/BC counts: 742 BCs / 55 VPs / 106 holdout / 172 stories** (all unchanged this burst). Reserved Windows device-name set unchanged at 30 (ADR-0021 §9). **Next:** re-dispatch PR #771 reviews on resume; merge; Wave 2 integration gate; F5.

**cycle-004 (F3 APPROVED → F4 Wave 1/Wave 2, Bursts 14-16, historical detail):** Burst 14 recorded DEC-337 (F3 human gate), registered the 4 stories in `STORY-INDEX.md` (168→172), and wrote 9/10 BC Story Anchor backlinks (`BC-1.4.028` skipped, no such field). Burst 15 delivered and merged both Wave-1 stories (DEC-338) with the REQUIRED F4 CI spike SUCCEEDING. Burst 16 (this burst) delivered `windows-docs` to merge and converged (but did not merge) `honest-fail-message`, then executed the session wrap. Full per-burst detail: `cycles/cycle-004/burst-log.md` Bursts 14-16.

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
- **PR-771-REVIEW-HALTED** (Burst 16, this burst) — PR #771's review deliberately paused for session wrap; re-dispatch on resume.

**PROCESS-GAP (Pass 14, cycle-004, historical, not a blocker):**
- `scripts/check-bc-cumulative-counts.sh` does not cover a per-file `bc-*.md` "## Summary Stats" closing "Note:" cumulative-prose line. Target: a future SELF-IMPROVEMENT/maintenance cycle.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- ~142 historical stale `input-hash` artifacts factory-wide; standing debt, **not** a cycle blocker. (`dependency-graph-extended.md`'s drift, newly re-surfaced this burst by the story-file input-hash updates, is part of this same standing pool — not separately fixed.)
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).

## Session Resume Checkpoint

**Date:** 2026-09-05. **Position:** cycle-004 (`windows-correctness`), **Phase F4 (delta implementation), IN PROGRESS — PAUSED mid-Wave-2 (SESSION WRAP).** Wave 1 COMPLETE + integration gate PASSED (DEC-338). Wave 2: `S-cycle4-windows-docs` merged (PR #770 @ `abb283e8`, current `origin/develop` tip); `S-cycle4-honest-fail-message` converged, PR #771 (head `b2a0c5d707a9daa8543f32acba6e718bcec77907`) OPEN/unmerged, reviews halted. Local `develop` behind at `c2074247` (not fast-forwarded, not a durability issue). cycle-001, cycle-002, and cycle-003 remain CLOSED, historical, unaltered by this burst.

**Convergence:** cycle-004 F2 convergence CLOSED at DEC-336. F3 review convergence COMPLETE, gate APPROVED (DEC-337). `S-cycle4-dpapi-storage-fix` and `S-cycle4-cloud-id-correctness` each individually 3-clean adversarially converged (merged). `S-cycle4-windows-docs` consistency-validated CONSISTENT (merged). `S-cycle4-honest-fail-message` individually 3-clean adversarially converged (PR open, NOT yet merged — pr-reviewer/security-reviewer review still outstanding). **No F4-phase-level convergence loop is active** — F5 (scoped adversarial review) is the next convergence-loop phase, after F4 fully completes.

**In-flight work:** **NONE running.** No live sub-agents at the moment of this checkpoint. PR #771 is open and its two reviews (pr-reviewer-771-cycle1, security-reviewer-771) were dispatched but explicitly HALTED (not killed mid-tool-call, but not concluded) for this wrap — their prior partial output exists at `code-delivery/S-cycle4-honest-fail-message/pr-review.md` but is PROVISIONAL, not a completed gate verdict.

**What changed this burst (Burst 16):**
1. **`S-cycle4-windows-docs` DELIVERED + MERGED** — PR #770 @ `abb283e8` (current `develop` tip). Consistency-validated CONSISTENT; pr-reviewer APPROVE; fixed `SEC-WCM-DOC-DPAPI-GAP`.
2. **`S-cycle4-honest-fail-message` CONVERGED, PR #771 OPEN, reviews HALTED** — includes a DEC-334 correction to a CONFIRMED-harmful revoke-advice defect (BC-1.4.039 + ADR-0021 §6 amended; source-scan regression guard added).
3. **`STORY-INDEX.md` + `sprint-state.yaml` reconciled** to the true Wave-1/Wave-2 state (both had stale, partially-superseded uncommitted edits at wrap time).
4. **`compute-input-hash --update`** re-run on 6 cycle-004 artifacts citing the amended `bc-1-auth-identity.md`.
5. **STATE.md transitioned** `pipeline: ACTIVE→PAUSED`; version jumped v3.66→v3.68 in one atomic Write, folding in Burst 15's Wave-1 delta (never actually written to the live file — see burst-log.md Burst 16 for why) together with this burst's Wave-2-partial delta.

**NEXT ACTION on resume (exact, in order):**
1. Re-dispatch **pr-reviewer** + **security-reviewer** fresh for PR #771 (auth/credential module — verify no secret leakage, Site-3 proactive-clear safety, the corrected revoke advice is genuinely non-harmful, not just reworded).
2. On clean review + green CI (re-check CI freshness first — `develop` has moved since #771 was last rebased; `strict: false` branch-protection caveat applies), merge PR #771.
3. Run the **F4 Wave 2 integration gate** (combined `honest-fail-message` + `windows-docs` wave-diff adversary review; regression).
4. **F4 COMPLETE** → F5 scoped adversarial → F6 targeted hardening → F7 delta convergence.
5. **F7 includes the REQUIRED manual Windows-11 smoke gate** (human reproduces #759 on real Windows 11) + the final human F7 gate → release.

**Carried-forward non-blocking items:** REQUIRED F7 manual Windows-11 smoke gate; honest-fail source-guard rustdoc reflow-fragility (LOW, false-red risk); ADR-0021 §6 illustrative-example wording divergence from BC-1.4.039 (`jr auth remove --profile` vs positional) + the ADR/BC Site-1/Site-3 structural-grouping drift (architect-flagged, LOW); the 2 pr-review follow-up nits from #768/#769; `init.rs` double `cloud_id` writer (LOW); [process-gap] the message-honesty test guards emitted strings + `auth.rs` source, but not `CHANGELOG.md` prose (review-guarded); BC-1.4.035 PC5 `store_pair`-failure→`DpapiFallbackFailed` production-path is now CI-verified (VP-010b), formal VP still AC-only. Per the S-7.02 cycle-closing checklist these are for cycle-close, not this wrap.

**Counts: total_bcs 742; VP count 55; holdout scenarios 106; total_stories 172** (all unchanged this burst — BC-1.4.039 amended in place, not added).

**EXACT RESUME COMMAND:** `/vsdd-factory:next-step` (reads STATE.md, resumes by re-dispatching PR #771's reviews).

**Superseded checkpoints:** the prior cycle-004 checkpoint (v3.66, 2026-09-04 — recorded the F3→F4 transition after Burst 14) is superseded in place by this checkpoint and was already archived to `cycles/cycle-004/session-checkpoints.md` ahead of this burst; its forward "superseded at" note is corrected in place this burst to describe the true wrap outcome (Wave 1 + Wave 2-partial) rather than the narrower Wave-1-only state it originally anticipated. No separate v3.67 checkpoint was ever committed to the live STATE.md file — see burst-log.md Burst 16 for why the version jumps v3.66→v3.68. Earlier archives (v3.65 SESSION-WRAP/PAUSED, v3.64 F3-CONVERGED, v3.62 Passes 20-25, v3.61 gate-audit/Pass-20, v3.60 Passes 12-14, v3.59 Passes 9-11, v3.58 Passes 7-8, v3.57 Passes 5-6, v3.56 Passes 1-4, v3.55 crash-recovery, v3.54 F1-APPROVED, v3.53 F1-IN-PROGRESS) remain at `cycles/cycle-004/session-checkpoints.md`; the cycle-003 checkpoints (v3.52 through v3.31) remain at `cycles/cycle-003/session-checkpoints.md`; cycle-002 checkpoints (v3.29 through v3.23 and earlier) remain at `cycles/cycle-002/session-checkpoints.md`; the cycle-001 CLOSED-position checkpoint (v3.05) remains at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-14 = F2/F3/F4; 15 = F5 CONVERGED + FIX-F5-001; 16 = F6 COMPLETE + FIX-F6-001; 17 = F7 delta-convergence PASS + FIX-F7-001; 18 = F7 human gate APPROVED + cycle-002 CLOSED; 19 = release v0.7.0-dev.3 SHIPPED; 20 = SESSION-WRAP) |
| cycle-003 burst history | `cycles/cycle-003/burst-log.md` (Burst 1 = cycle OPENED; Bursts 2-9 = F1 through F3 gates; Bursts 10-15 = F4 Waves 1-5, all 7 stories merged; Burst 16 = F5 findings fixed; Burst 17 = SESSION WRAP, F5 CONVERGED; Burst 18 = SESSION RESUMED, F6 DISPATCHED; Burst 19 = F6 COMPLETE — PASS; Burst 20 = F7 pre-gate consistency audit; Burst 21 = F7 human gate APPROVED — CONVERGED (DEC-332); Burst 22 = RELEASE v0.7.0-dev.4 SHIPPED, cycle-003 CLOSED (DEC-333)) |
| cycle-004 burst history | `cycles/cycle-004/burst-log.md` (Burst 1 = cycle OPENED; Burst 2 = F1 human gate APPROVED (DEC-335); Burst 3 = CRASH RECOVERY of F2 architect/product-owner deliverables; Bursts 4-10 = F2 scoped adversarial convergence, 25 passes across two attempts + 2 consistency audits; Burst 11 = F2 HUMAN GATE APPROVED (DEC-336); Burst 12 = F3 story decomposition CONVERGED (6→4→3→CLEAN); Burst 13 = SESSION WRAP (F3 gate pending); Burst 14 = F3 HUMAN GATE APPROVED (DEC-337), `STORY-INDEX.md` registered (168→172), phase F3→F4; Burst 15 = F4 Wave 1 DELIVERED + MERGED, integration gate PASSED (DEC-338), F4 CI spike SUCCEEDED; Burst 16 = F4 Wave 2 PARTIALLY DELIVERED (`windows-docs` merged, `honest-fail-message` converged/PR-open/reviews-halted) + SESSION WRAP, pipeline PAUSED) |
| cycle-004 F1 delta-analysis artifacts | `cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md` + `affected-files.txt` |
| cycle-004 F2 spec-evolution artifacts | `cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md`; `vp-delta.md`; `specs/architecture/decisions/ADR-0021-*.md` (amended Burst 16 with the §6 revoke-advice correction); `specs/architecture/decisions/ADR-0022-*.md` |
| cycle-004 F3 story-decomposition artifacts | `cycles/cycle-004/phase-f3-stories/` — `decomposition-manifest.md`, `S-cycle4-{dpapi-storage-fix,cloud-id-correctness,honest-fail-message,windows-docs}.md` (the latter amended Burst 16 with the F1 AC correction), `dependency-graph-extended.md`, `wave-schedule.md`, `conflict-report.md`, `wave-holdout-scenarios/` |
| cycle-004 F4 implementation delivery evidence | `code-delivery/S-cycle4-{dpapi-storage-fix,cloud-id-correctness,windows-docs}/pr-review.md` (merged stories); `code-delivery/S-cycle4-honest-fail-message/{pr-review.md,pr-approve-body.md}` (PR #771, provisional — review halted, not concluded) |
| cycle-004 revoke-granularity research | `research/atlassian-3lo-revoke-granularity-2026-09-05.md` (Perplexity-validated; grounds the DEC-334 amendment) |
| cycle-004 session checkpoints | `cycles/cycle-004/session-checkpoints.md` (archives v3.64, v3.65, v3.66; this burst writes the live v3.68 into STATE.md directly, no separate v3.67 was ever committed) |
| cycle-004 cloud_id research | `research/edge-tenant-info-cloudid-2026-09-03.md` |
| cycle-003 grounding + phase artifacts | `cycles/cycle-003/investigation/`, `cycles/cycle-003/phase-f1-delta-analysis/`, `phase-f2-spec-evolution/`, `phase-f3-stories/`, `phase-f4-implementation/`, `phase-f6-hardening/`, `phase-f7-convergence/` |
| cycle-003 release + F4/F5 delivery evidence | version-bump PR #767 (`develop` @ `42e92b46`); tag `v0.7.0-dev.4`; `release.yml` run `33769389700`; `code-delivery/FIX-F7-DOCS-1/`, `code-delivery/S-cycle3-*/`, `code-delivery/FIX-F5-*/` |
| cycle-002/cycle-001 historical artifacts | `cycles/cycle-002/`, `cycles/cycle-001/` (see per-cycle files) |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**cycle-004 (F4 Wave 1 COMPLETE, Wave 2 PARTIAL, PAUSED, Burst 16, this burst):** SESSION WRAP mid-Wave-2. `S-cycle4-windows-docs` merged (PR #770 @ `abb283e8`); `S-cycle4-honest-fail-message` converged but unmerged (PR #771, reviews halted). `STORY-INDEX.md`/`sprint-state.yaml` reconciled from stale stood-down-Wave-1 snapshots to this true state. A DEC-334 amendment corrected a CONFIRMED-harmful revoke-advice defect (BC-1.4.039, ADR-0021 §6) found via adversarial review, grounded in Perplexity-validated research. `compute-input-hash --update` re-run on 6 artifacts citing the amended `bc-1-auth-identity.md`; `dependency-graph-extended.md`'s resulting drift is left to the standing `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` pool (out of this burst's narrow declared scope). **Tracked items, all non-blocking:** BC-1.4.035-PC5-VP-GAP (production path now CI-verified, formal VP still deferred), S-410-KEYCHAIN-ISOLATION-FILE-OVERLAP, TD-031-BLOCKED-BC-6.2.016-CROSSREF, and the new PR-771-REVIEW-HALTED (a deliberate pause). `SEC-WCM-DOC-DPAPI-GAP` CLOSED via PR #770. **Hygiene note:** the three pre-existing unrelated dirty files (`regression-state.json`, `sidecar-learning.md`, `S-cycle3-env-tag` demo gif) remain explicitly NOT staged this burst, per standing instruction. **Next:** re-dispatch PR #771's reviews on resume.

**cycle-004 (F4 Wave 1 delivery, Burst 15, historical):** `S-cycle4-dpapi-storage-fix` (PR #768 @ `9119b291`) + `S-cycle4-cloud-id-correctness` (PR #769 @ `c2074247`) delivered and merged; F4 CI spike SUCCEEDED (VP-AUTHDX-010(b) CI-verified); Wave 1 integration gate PASSED (DEC-338). Full detail `cycles/cycle-004/burst-log.md` Burst 15.

**cycle-004 (F3 APPROVED, F3→F4 transition, Bursts 13-14, historical):** Burst 13 was a pure human-requested pause (F3 gate PENDING, zero substantive change). Burst 14: human APPROVED the F3 gate (DEC-337); `STORY-INDEX.md` registered (168→172); 9/10 BC Story Anchor backlinks written in `bc-1-auth-identity.md` (`BC-1.4.028` skipped, no such field); phase advanced F3→F4, pipeline PAUSED→ACTIVE. Full detail `cycles/cycle-004/burst-log.md` Bursts 13-14.

**cycle-004 (F2, scoped adversarial convergence + human gate, Bursts 3-11, historical):** the full 25-pass trajectory, the post-Pass-6 consistency sweep, and both pre-gate consistency audits are fully resolved and closed as of DEC-336. **PROCESS-GAP (Pass 14, still open):** `scripts/check-bc-cumulative-counts.sh` coverage gap on per-file Summary-Stats-Note prose, target a future maintenance cycle. Full detail: `cycles/cycle-004/burst-log.md` Bursts 4-11.

**cycle-003 (RELEASE + CLOSE, historical):** DEC-333: PR #767 squash-merged, tag `v0.7.0-dev.4` pushed, `release.yml` SUCCESS, GitHub prerelease published. **cycle-003 is CLOSED.** Both S-7.02 process-gap deferrals codified in `cycles/cycle-003/lessons.md`. All prior outstanding items (MED-1, LOW-4/LOW-6, template-compliance gap, input-hash cascade) deferred to a future maintenance cycle.

**cycle-003 (F7 pre-gate audit + F5/F6 detail, historical):** 12-finding pre-gate consistency audit, CRIT/HIGH/most-MED FIXED, MED-1/LOW-4/LOW-6 carried forward. F5 findings RESOLVED via PR #763/#764; F6 GATE VERDICT PASS (mutation 100%, security clean, regression 4763/0/157). Full detail: `cycles/cycle-003/burst-log.md` Bursts 16-20.

**cycle-003 (earlier F4/F3/F2 resolutions, historical):** F1 (BYO-OAuth-cred over-delete) and ADR-0011 doc-drift CLOSED (Burst 15). ADR-0011-staged-not-applied CLOSED (Burst 14, `S-cycle3-adr0011-newtype` PR #758). DEC-NAMESPACE-COLLISION-RISK clean (max ID DEC-338, no collision). Wave 1/2 integration gates PASSED; all 7 cycle-003 stories squash-merged.

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
- **PR-771-REVIEW-HALTED** (new, Burst 16) — re-dispatch reviews on resume.

**PROCESS-GAP (Pass 14, cycle-004, historical, not a blocker):**
- `scripts/check-bc-cumulative-counts.sh` coverage gap on per-file Summary-Stats-Note prose. Target a future maintenance cycle.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- ~142 historical stale `input-hash` artifacts factory-wide; standing debt, **not** a cycle blocker.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
