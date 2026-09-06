---
document_type: pipeline-state
level: ops
version: "3.74"
status: active
producer: state-manager
timestamp: 2026-09-06T17:10:44Z
phase: "cycle-004 CLOSED + RELEASED as v0.7.0-dev.5; no open cycle."
pipeline: RELEASED
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
last_amended: "2026-09-06, v3.74, state-manager — Burst 22: cycle-004 windows-correctness RELEASED as v0.7.0-dev.5 (PR #777 @ `569d85a8`; tag v0.7.0-dev.5; release.yml run 34046676423 SUCCESS; GitHub prerelease, 10 assets/5 targets) and CLOSED (DEC-343). All four tracked cycles (001-004) now CLOSED; no open cycle, no open work."
current_step: "D-chain cite D-31 latest brownfield (unchanged). trajectory-tail →1→3→0→2 (unchanged this burst). Burst 22 (2026-09-06): RELEASE + CYCLE CLOSE. Human authorized the cycle-004 dev release following the Burst-21 F7 CONVERGED gate (DEC-342). Version-bump PR #777 (`chore(release): v0.7.0-dev.5`) squash-merged to `develop` @ `569d85a8` (current tip; Cargo.toml/lock bumped to 0.7.0-dev.5, CHANGELOG [Unreleased] rolled to [0.7.0-dev.5]). Annotated tag `v0.7.0-dev.5` (tag object `41a880d5`) pushed, peeling to `569d85a8`. `release.yml` run `34046676423` concluded SUCCESS across all 5 build targets (x86_64/aarch64 apple-darwin, x86_64/aarch64 unknown-linux-gnu, x86_64-pc-windows-msvc) plus Create Release. GitHub prerelease published (isPrerelease=true, isDraft=false), 10 assets across 5 targets (5 archives + 5 .sha256), published 2026-09-06T16:55:46Z at https://github.com/Zious11/jira-cli/releases/tag/v0.7.0-dev.5. Note: the cycle's F7 Windows-verification closure landed first as PR #776 @ `135eb804` (Burst 21), ahead of this release cut. `activation_head`/`activation_version` advance `42e92b46`/`v0.7.0-dev.4` → `569d85a8`/`v0.7.0-dev.5`. `cycle_004_status` → CLOSED + RELEASED. New **DEC-343** records the human's release authorization and execution; cycle-004 (`windows-correctness`) is now CLOSED. S-7.02 cycle-closing checklist run this burst: the two process-gap follow-ups logged at Burst 21 (`JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION`, `PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP`) are confirmed still present and unresolved in Drift/Standing and Constraints Carried Forward, targeting a future maintenance/self-improvement cycle and a vsdd-factory engine fix respectively; all other pre-existing standing/non-blocking items (cycle-002/003 deferrals, the 165-artifact F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING pool, the 10-story S-PG-* backlog, the 5 held Dependabot PRs, etc.) carried forward verbatim, zero resolutions beyond this burst's own release/close bookkeeping. Counts unchanged: 742 BCs / 55 VPs / 106 holdouts / 172 stories. `pipeline` frontmatter set to RELEASED (mirrors the exact value cycle-003's own release-cut burst used, v3.52/commit `bcc90d01` — the repo's resting-state value once the sole open cycle ships and closes); `phase` frontmatter set to the literal cycle-close description per this burst's instruction. **All four tracked cycles (cycle-001, cycle-002, cycle-003, cycle-004) are now CLOSED — no cycle has open work.** One full-content Write, no Edit chain (BC-5.45.001/DEC-247 discipline). Hygiene: the three pre-existing dirty files unrelated to any cycle (regression-state.json, sidecar-learning.md, the modified S-cycle3-env-tag demo gif) plus the ephemeral phase-f6-hardening/cycle-004/{mutants-run*, delta.diff} scratch remain explicitly NOT staged this burst, consistent with every prior burst. NEXT: optional post-pipeline session review (`/vsdd-factory:session-review`); otherwise the pipeline is idle — no active cycle — awaiting the human's direction on the next feature bundle or maintenance cycle."
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
cycle_004_status: "windows-correctness -- CLOSED + RELEASED 2026-09-06 (DEC-343; v0.7.0-dev.5 @ 569d85a8, PR #777; release.yml run 34046676423 SUCCESS; GitHub prerelease published, 10 assets/5 targets). F1-F7 complete + released. Pipeline shipped."
activation_head: "569d85a8"
activation_version: "v0.7.0-dev.5"
---

<!-- STATE.md SIZE BUDGET (2026-09-06, cycle-004 Burst 22 -- RELEASE + CYCLE CLOSE;
     line count refreshed after this burst's Write):
     Human authorized and executed the cycle-004 dev release: version-bump PR #777
     squash-merged to develop (135eb804 -> 569d85a8); annotated tag v0.7.0-dev.5
     (tag object 41a880d5) pushed; release.yml run 34046676423 concluded SUCCESS
     across all 5 build targets; GitHub prerelease published (10 assets/5 targets,
     2026-09-06T16:55:46Z). DEC-343 recorded; cycle-004 (windows-correctness) is now
     CLOSED. All four tracked cycles (001-004) are now CLOSED -- no open cycle, no
     open work. `pipeline` frontmatter set to RELEASED (mirrors the exact value
     cycle-003's own release-cut burst used, v3.52/commit bcc90d01 -- the repo's
     documented resting-state value once the sole open cycle ships and closes);
     `phase` frontmatter set to the literal "cycle-004 CLOSED + RELEASED as
     v0.7.0-dev.5; no open cycle." string per this burst's explicit instruction.
     This burst archives the prior Burst-21 F7-CONVERGED Session Resume Checkpoint
     (v3.73) to cycles/cycle-004/session-checkpoints.md with a "Superseded at" note
     and replaces it with a new v3.74 resting-state checkpoint (no pending human
     decisions, no in-flight work, no active cycle). Phase Progress table's cycle-004
     F4 row dropped (keep-recent rule, same precedent as cycle-003's release burst);
     a new RELEASE v0.7.0-dev.5 row added. Current Phase Steps table trimmed to the
     last 5 steps culminating in "cycle-004 CLOSED". Decisions Log gained DEC-343;
     DEC-341 and older folded into the collapsed-older bucket (DEC-342 kept in full
     as the direct F7 predecessor). Convergence Status / Concurrent Cycles /
     Constraints Carried Forward / Drift-Standing-Items sections updated to record
     RELEASED + CLOSED and "no cycle currently has open work." S-7.02 cycle-closing
     checklist run: the two process-gap follow-ups logged at Burst 21
     (JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION, PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP)
     confirmed still present as tracked deferrals -- no new lessons.md created this
     burst (not requested this time, unlike cycle-003's precedent). All other
     Drift/Standing items and the full Decisions Log/Skip Log carried forward
     verbatim; zero resolutions to prior open items in this burst beyond the
     release/close bookkeeping itself. Counts unchanged: 742 BCs / 55 VPs / 106
     holdouts / 172 stories. One full-content Write, no Edit chain, no Bash cp
     (BC-5.45.001/DEC-247 discipline). Hygiene: the three pre-existing-dirty files
     unrelated to any cycle (regression-state.json, sidecar-learning.md, the
     modified S-cycle3-env-tag demo gif) plus the ephemeral
     phase-f6-hardening/cycle-004/{mutants-run*, delta.diff} scratch remain
     explicitly NOT staged this burst, consistent with every prior burst.
     soft target 200 lines; hard cap 500 lines. 332 lines (wc-l) pre-burst. 360 lines (wc-l) post-burst (this file, this Write). margin from soft-target = 360 - 200 = 160 (OVER the soft target; documented, ongoing known deviation across cycles-002/003/004, not a blocker). margin from actual = 500 - 360 = 140 (dual-margin form; headroom remains before the hard cap). Growth this
     burst is attributable to the new RELEASE Phase Progress row, the new DEC-343
     row + Burst-22 decision note, and two new Constraints-Carried-Forward/Drift
     bullets, only partly offset by the shortened cycle-004 Convergence Status
     paragraph, the one-row-shorter Decisions Log, and the shorter resting-state
     Session Resume Checkpoint. RECOVERY CONTEXT: no crash this burst --
     clean, immediate continuation from the Burst-21 F7-CONVERGED position within the
     same session; no in-flight work of any kind remains after PR #777 merged and the
     release published (no live sub-agents, no open PRs, no story worktrees, no open
     cycle at all across cycle-001 through cycle-004).
     Factory lock: no factory_lock frontmatter block is present in this STATE.md and
     the lock-write/verify-sha-currency scripts are not provisioned in this repo --
     the renew/unlock step this burst is therefore a no-op, noted rather than
     fabricated. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →1→3→0→2 (unchanged this burst) |
| **Last Updated** | trajectory-tail →1→3→0→2 (unchanged this burst). Burst 22 (2026-09-06) — **RELEASE + CYCLE CLOSE:** cycle-004 (`windows-correctness`) RELEASED as **v0.7.0-dev.5** (version-bump PR #777 @ `569d85a8`, tag `v0.7.0-dev.5` pushed, `release.yml` run `34046676423` SUCCESS, GitHub prerelease published with 10 assets/5 targets) and CLOSED (**DEC-343**). `develop` HEAD advanced `135eb804` → `569d85a8`. **All four tracked cycles (cycle-001 through cycle-004) are now CLOSED — no cycle has open work.** |
| **Current Phase** | Feature Mode cycle-004 (`windows-correctness`) — **CLOSED + RELEASED as v0.7.0-dev.5.** F7 (delta convergence) remains the terminal phase value reached (release-cut does not advance the phase field, same precedent as cycle-002/cycle-003). cycle-001, cycle-002, and cycle-003 remain CLOSED, historical. **No cycle currently has open work.** |
| **Activation HEAD** | `569d85a8` (`develop` tip; advanced from `42e92b46` this burst via version-bump PR #777 — `activation_head` and `develop`'s current tip are now back in sync post-release) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, cycles/cycle-003/burst-log.md, cycles/cycle-004/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| F5-SCOPED-ADVERSARIAL (cycle-004) | **CONVERGED** | 2026-09-05 | 3 fresh adversary passes + 1 cross-model secondary; 0 CRIT/HIGH/MED (DEC-340) | Scope: cycle-004 delta (PRs #768/#769/#771 code + #770/#772 docs) on `develop`. Round 1 found 3 actionable LOWs, fixed via PR #773 @ `f3863f07`. Round 2 (2 adversary + 1 cross-model secondary) found several corroborated actionable LOWs, all fixed per human "fix everything actionable" decision via PR #774 @ `3b62cefa`. Residuals documented as by-design/convention/unreachable. Full detail: `phase-f5-adversarial/cycle-004/convergence-summary.md`. | counts unchanged (742/55/106/172); trajectory 3→several(corroborated)→0, **CONVERGED (DEC-340)** |
| F6-TARGETED-HARDENING (cycle-004) | **COMPLETE** | 2026-09-05 | Kani/fuzz JUSTIFIED SKIP; mutation 97-100% on testable surface + tenant.rs 100%; security CLEAN; regression GREEN (DEC-341) | Scope: cycle-004 delta (`42e92b46`→`024de4d8`), info-asymmetry wall honored. Kani/fuzz: proptest substitution, 0 GAP. Mutation: examine_globs gap found + partially closed (`tenant.rs` now 100% via PR #775 @ `024de4d8`); remaining 4 delta files' gap deferred. Security: CLEAN, no CRIT/HIGH. Regression: full suite GREEN (CI 3-OS + local 4900+/0). Full detail: `phase-f6-hardening/cycle-004/summary.md`. | counts unchanged (742/55/106/172); F6 verdict **COMPLETE (DEC-341)** |
| F7-DELTA-CONVERGENCE (cycle-004) | **CONVERGED** | 2026-09-06 | 5-dimensional convergence check on the delta + full regression + Windows-verification gate satisfied via CI + final human gate PASSED (DEC-342) | All 5 automated dimensions PASS (Spec, Test, Impl, Verification, Holdout — convergence report + traceability delta + input-hash recompute @ `a038ac0d`); full regression GREEN. Human authorized satisfying the REQUIRED Windows-11 DPAPI verification via the `windows-latest` CI runner (PR #776 @ `135eb804`) rather than a physical smoke test — the DPAPI-encrypted-file round-trip is CI-verified end-to-end on real Windows (`Test (windows-latest)` run `34040856196`), satisfying H-W1-WIN-001 + the DPAPI legs of H-W1-INT-001/002 & H-W2-INT-001. Descoped residuals: (a) natural `TooLong` trigger, (b) live OAuth browser-consent flow — both human-accepted out of scope. Final human F7 gate PASSED (**DEC-342**). Full detail: `cycles/cycle-004/burst-log.md` Burst 21. | counts unchanged (742/55/106/172); F7 verdict **CONVERGED (DEC-342)** |
| **RELEASE v0.7.0-dev.5 (cycle-004)** | **RELEASED — SHIPPED** | **2026-09-06** | human-authorized dev release; `release.yml` run `34046676423` SUCCESS | Human authorized the dev release. Version-bump PR #777 squash-merged to `develop` (`135eb804` → `569d85a8`); annotated tag `v0.7.0-dev.5` (tag object `41a880d5`) pushed at `569d85a8`; `release.yml` run `34046676423` concluded SUCCESS across all 5 build targets (x86_64/aarch64 apple-darwin, x86_64/aarch64 unknown-linux-gnu, x86_64-pc-windows-msvc) plus Create Release. GitHub prerelease published 2026-09-06T16:55:46Z with 10 assets (5 targets × archive + sha256). cycle-004 `windows-correctness` is now CLOSED. | PR #777 @ `569d85a8`; tag `v0.7.0-dev.5`; GitHub prerelease, 10 assets/5 targets — counts unchanged |

## Current Phase Steps (cycle-004, RELEASED + CLOSED; last 5)

| Step | Status | Notes |
|------|--------|-------|
| REQUIRED Windows-11 DPAPI verification | **DONE — SATISFIED VIA CI (Burst 21)** | PR #776 @ `135eb804` added a `#[cfg(windows)]` CI test; `Test (windows-latest)` run `34040856196`; code-reviewer/pr-reviewer/security-reviewer gates all green. |
| Final human F7 convergence gate | **DONE — PASSED (DEC-342, Burst 21)** | Human sign-off received on the F7 convergence verdict; Phase F7 declared CONVERGED. |
| Release v0.7.0-dev.5 cut | **DONE** | Human authorized the release; version-bump PR #777 squash-merged to `develop` @ `569d85a8`; annotated tag `v0.7.0-dev.5` pushed |
| `release.yml` run `34046676423` | **DONE — SUCCESS** | All 5 build targets green + Create Release; GitHub prerelease published (10 assets/5 targets, 2026-09-06T16:55:46Z) |
| cycle-004 CLOSED | **DONE** | All phases F1–F7 complete + released; pipeline shipped; no open work remains on cycle-004 |

(Prior cycle-004 Burst-1 through Burst-20 steps — human triage, DEC-334, F1/F2/F3 dispatch and human gates, crash recovery, formal-verifier VP delta, 25 adversarial passes across two convergence attempts, F3 story decomposition + 4-round review convergence, two SESSION WRAPs, F4 Wave 1/Wave 2 delivery+merge+gates (DEC-338/DEC-339), the Wave 2 README-fix PR #772, the F5 scoped adversarial review (2 fix rounds, PR #773 + PR #774, DEC-340), and F6 targeted hardening (1 fix round, PR #775, DEC-341) — archived to `cycles/cycle-004/burst-log.md` Bursts 1-20. Burst 21's PR #776 Windows-CI-verification delivery and DEC-342 authorization, and Burst 22's release execution (PR #777, tag `v0.7.0-dev.5`, `release.yml` run `34046676423`) and cycle close (DEC-343) — archived in full to `cycles/cycle-004/burst-log.md` Bursts 21-22.)

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-343 | Human authorized and executed the cycle-004 dev release **v0.7.0-dev.5** (version-bump PR #777 squash-merged to `develop` @ `569d85a8`, annotated tag `v0.7.0-dev.5` pushed, `release.yml` run `34046676423` concluded SUCCESS, GitHub prerelease published with 10 assets/5 targets). cycle-004 (`windows-correctness`) is now **CLOSED** | F7 (delta convergence) reached human-authorized CONVERGENCE at DEC-342, with the Windows-verification gate already satisfied via CI (PR #776) and the final human gate passed; the human then explicitly triggered the release action, completing the cycle's final gate and closing it. Full release | RELEASE | 2026-09-06 | human (explicit authorization) |
| DEC-342 | cycle-004 F7 delta convergence HUMAN-AUTHORIZED via the windows-latest CI verification path — the REQUIRED Windows-11 DPAPI verification is satisfied by PR #776 @ `135eb804` (adds a `#[cfg(windows)]` CI test for the oversized-token DPAPI-file round-trip) rather than a physical/manual smoke test; the manual smoke test is superseded for this mechanism; residuals (a) the natural `keyring::Error::TooLong` trigger and (b) the live OAuth browser-consent flow are explicitly descoped. Phase F7 declared CONVERGED. Advance to release execution | Human explicitly authorized substituting the existing `windows-latest` GitHub Actions CI runner for the REQUIRED physical Windows-11 smoke test ("add CI test → verify green → converge & release"). PR #776 is test-only/doc-only (no production code changed), passed independent code-reviewer/pr-reviewer/security-reviewer review plus 14/14 CI green including the new Windows test leg, and closes the DPAPI-encrypted-file mechanism's end-to-end verification gap on real Windows (combined with the pre-existing raw-FFI test). The two residuals were judged to require a physical machine or a much larger mocked-OAuth CI investment and were accepted as explicitly out of scope rather than blocking convergence | F7 | 2026-09-06 | human (explicit authorization) |
| (343 older cycle-004/003/002/001 decisions) | DEC-341 through DEC-309 and earlier — unchanged this burst | — | F1-F7/historical | 2026-08-24…2026-09-05 | various — see `cycles/cycle-004/burst-log.md` Bursts 1-19 and `cycles/cycle-003/burst-log.md` Bursts 13-22 |

**cycle-004 note (Burst 19):** DEC-341 (F6 COMPLETE) recorded above. The F7 pre-gate input-hash drift check ran that burst with no gate-blocking result (detail `phase-f7-convergence/cycle-004/input-hash-drift.md`).

**cycle-004 note (Burst 20, SESSION WRAP):** F7 automated prep completed post-Burst-19 (convergence report + traceability delta + input-hash recompute, commit `a038ac0d`) — all five delta-convergence dimensions PASS. The pipeline was then **PAUSED** at the FINAL HUMAN GATE per human `/wrap` request; no new DEC was recorded that burst (DEC-341 remained the most recent).

**cycle-004 note (Burst 21):** **DEC-342** (F7 CONVERGED, human-authorized via the windows-latest CI verification path) recorded above. The REQUIRED Windows-11 smoke gate was satisfied for the DPAPI-file round-trip mechanism via PR #776's new `windows-latest` CI test; the natural `TooLong`-trigger and live-OAuth-flow residuals remained explicitly descoped, not gaps. Two new non-blocking process-gap follow-ups tracked: `JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION`, `PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP` (both detailed under Constraints Carried Forward).

**cycle-004 note (Burst 22, this burst):** **DEC-343** (RELEASE + CLOSE) recorded above. Human authorized and executed the cycle-004 dev release **v0.7.0-dev.5** (version-bump PR #777 @ `569d85a8`; tag `v0.7.0-dev.5` pushed; `release.yml` run `34046676423` SUCCESS; GitHub prerelease, 10 assets/5 targets). cycle-004 (`windows-correctness`) is now **CLOSED**. S-7.02 cycle-closing checklist run: the two process-gap follow-ups tracked at Burst 21 (`JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION`, `PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP`) confirmed still logged as tracked deferrals; all other pre-existing standing/non-blocking items carried forward unchanged. **All four tracked cycles (cycle-001, cycle-002, cycle-003, cycle-004) are now CLOSED — no open cycle, no open work.**

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
| REQUIRED manual Windows-11 physical smoke test (cycle-004, Burst 21) | superseded, not skipped | Human explicitly authorized the `windows-latest` CI runner (PR #776) as the verification path for the DPAPI-file round-trip mechanism instead of a physical machine — see DEC-342. Two residuals ((a) natural `TooLong` trigger, (b) live OAuth browser-consent flow) remain genuinely un-exercised and are recorded as explicitly descoped, not silently dropped. |

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/<cycle>/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|

**No open blocking issues.**

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): historical, unchanged this burst.

`cycle-002` (`field-dx`) F2-F7 COMPLETE, human-authorized at the F7 gate (DEC-311). **RELEASED 2026-09-01 as `v0.7.0-dev.3`.** Historical, unchanged this burst.

`cycle-003` (`auth-profile-dx`) F1-F7 all COMPLETE, human-approved at every gate. **RELEASED 2026-09-03 as `v0.7.0-dev.4`** (DEC-333). **cycle-003 is CLOSED** — SHIPPED, historical, unchanged this burst.

`cycle-004` (`windows-correctness`) F1-F7 all COMPLETE, human-authorized at every gate (DEC-335/336/337/339/340/341/342). **RELEASED 2026-09-06 as `v0.7.0-dev.5`** (DEC-343; version-bump PR #777 @ `569d85a8`; tag `v0.7.0-dev.5`; `release.yml` run `34046676423` SUCCESS; GitHub prerelease, 10 assets/5 targets). **cycle-004 is CLOSED** — SHIPPED, historical. All 4 stories merged (PR #768/#769/#770/#771); F5 scoped adversarial review CONVERGED (PR #773/#774); F6 targeted hardening COMPLETE (PR #775); F7 Windows-verification gate satisfied via CI (PR #776); full detail in `cycles/cycle-004/burst-log.md` Bursts 1-22.

**All four tracked cycles (cycle-001, cycle-002, cycle-003, cycle-004) are now CLOSED — no open cycle, no open work.**

## Concurrent Cycles

Four tracked cycles, **all CLOSED — no open cycle, no open work.** `cycle-001` is CLOSED, historical. `cycle-002` (`field-dx`) is **CLOSED + RELEASED** (2026-09-01), historical. `cycle-003` (`auth-profile-dx`) is **CLOSED + RELEASED** (2026-09-03, DEC-333) as **`v0.7.0-dev.4`** @ `42e92b46`, historical. `cycle-004` (`windows-correctness`) is **CLOSED + RELEASED** (2026-09-06, DEC-343) as **`v0.7.0-dev.5`** @ `569d85a8`, historical (F1/F2/F3 all APPROVED — DEC-335/336/337; F4 COMPLETE — DEC-339; F5 CONVERGED — DEC-340; F6 COMPLETE — DEC-341; F7 CONVERGED — DEC-342; RELEASED + CLOSED — DEC-343): all 4 stories merged (PR #768/#769/#770/#771); both wave integration gates PASSED; F5 delta review converged via PR #773 + PR #774; F6 hardening completed via PR #775; F7 Windows-verification satisfied via `windows-latest` CI (PR #776); the version-bump release PR #777 squash-merged, tag `v0.7.0-dev.5` pushed, `release.yml` run `34046676423` SUCCESS, GitHub prerelease published. `develop` @ `569d85a8` (current tip — now in sync with `activation_head`). The standing auto-merge policy (DEC-330/DEC-331, fully autonomous when CI green + reviewer merge-recommendation + all HIGH/MED findings addressed) and the `gh pr merge`/push MAIN-session-only constraint both remain in effect for any future cycle-004 (or later) fix PRs. **Pipeline is RELEASED** (resting state, Burst 22, mirroring the exact value cycle-003's own release-cut burst used at commit `bcc90d01`); `phase` frontmatter records cycle-004 CLOSED + RELEASED, no open cycle. **Next:** no active cycle — start a new feature/maintenance cycle per human direction, or run the optional post-pipeline session review (`/vsdd-factory:session-review`).

## Constraints Carried Forward

**cycle-004 (RELEASE + CLOSE, DEC-343, Burst 22, this burst):** resumed immediately from the Burst-21 F7-CONVERGED position (DEC-342). Human authorized and executed the cycle-004 dev release. Version-bump PR **#777** (`chore(release): v0.7.0-dev.5`) squash-merged to `develop` (`135eb804` → **`569d85a8`**, current tip): `Cargo.toml`/`Cargo.lock` bumped to `0.7.0-dev.5`; `CHANGELOG.md` `[Unreleased]` rolled to `[0.7.0-dev.5]`. Annotated tag **`v0.7.0-dev.5`** (tag object `41a880d5`) pushed, peeling to `569d85a8`. GitHub Actions `release.yml` run **`34046676423`** concluded **SUCCESS** across all 5 build targets (x86_64/aarch64 apple-darwin, x86_64/aarch64 unknown-linux-gnu, x86_64-pc-windows-msvc) plus Create Release. GitHub prerelease published (isPrerelease=true, isDraft=false) 2026-09-06T16:55:46Z with 10 assets across 5 targets (5 archives + 5 `.sha256`) at https://github.com/Zious11/jira-cli/releases/tag/v0.7.0-dev.5. **DEC-343 recorded:** human-authorized full release; cycle-004 (`windows-correctness`) is now **CLOSED**. `activation_head`/`activation_version` advance `42e92b46`/`v0.7.0-dev.4` → **`569d85a8`**/**`v0.7.0-dev.5`** — `develop`'s current tip and the activation head are now back in sync. **S-7.02 cycle-closing checklist run this burst:** the two process-gap follow-ups logged at Burst 21 — `JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION` (target: a future SELF-IMPROVEMENT/maintenance cycle) and `PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP` (target: a vsdd-factory engine fix) — are confirmed still present and unresolved under "cycle-004 maintenance items" below and in `Drift / Standing Items`; no new deferral file was created this burst (not requested this time, unlike cycle-003's `lessons.md` precedent). All other pre-existing standing/non-blocking items (cycle-002/cycle-003 deferrals, the 165-artifact `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` standing pool, the 10-story `S-PG-*` SELF-IMPROVEMENT backlog, the 5 held Dependabot PRs, and every other item listed under `Standing` below) carried forward **verbatim** — zero resolutions to prior open items beyond this burst's own release/close bookkeeping. **PRD/VP/BC counts: 742 BCs / 55 VPs / 106 holdout / 172 stories** (all unchanged this burst — pure release + bookkeeping burst, no spec content changed; `scripts/check-bc-cumulative-counts.sh`/`scripts/check-spec-counts.sh` not re-run). `pipeline` frontmatter set to **RELEASED** (mirrors the exact value cycle-003's own release-cut burst used, v3.52/commit `bcc90d01` — the repo's documented resting-state value once the sole open cycle ships and closes); `phase` frontmatter set to the literal cycle-close description per this burst's explicit instruction. **All four tracked cycles (cycle-001, cycle-002, cycle-003, cycle-004) are now CLOSED — no cycle has open work.** **Next:** optional post-pipeline session review (`/vsdd-factory:session-review`); otherwise the pipeline is idle awaiting the human's direction on the next feature bundle or maintenance cycle.

**cycle-004 (F7 CONVERGED via CI verification path, DEC-342, Burst 21, historical):** resumed from the Burst-20 SESSION-WRAP-PAUSE at the F7 final human gate. Human authorized satisfying the REQUIRED Windows-11 DPAPI verification via the existing `windows-latest` GitHub Actions CI runner rather than a physical/manual smoke test ("add CI test → verify green → converge & release"). Delivered **PR #776** (branch `test/cycle4-dpapi-file-roundtrip-win-ci`), squash-merged to `develop` @ **`135eb804`** — TEST-ONLY + DOC-ONLY, no production code changed, counts unchanged (742/55/106/172). Adds one `#[cfg(windows)]`, non-`#[ignore]`d test `test_store_pair_then_load_pair_oversized_token_round_trips_via_dpapi_file` in `src/api/auth_windows_store.rs`: stores an oversized (>2560-byte) OAuth pair via `store_pair`, asserts the DPAPI-encrypted file exists at `%LOCALAPPDATA%\jr\secrets\<profile>\oauth-tokens.dat` (via the `JR_CACHE_DIR` debug test seam), asserts on-disk bytes ≠ plaintext, and asserts `load_pair` round-trips both tokens exactly — runs automatically on `Test (windows-latest)`. Gates: local code-reviewer MERGE-READY, pr-reviewer APPROVE, independent security-reviewer CLEAN, CI 14/14 green incl. `Test (windows-latest)` (run `34040856196`) and `CI Gate`. This closed the F7 Windows-verification gate for the DPAPI-encrypted-file mechanism end-to-end on real Windows in CI — combined with the pre-existing raw-FFI `test_dpapi_protect_unprotect_real_round_trip` test — satisfying holdout H-W1-WIN-001 and the DPAPI legs of H-W1-INT-001/002 & H-W2-INT-001, without a physical Windows-11 machine. **Explicit descoped residuals (human-accepted, NOT covered):** (a) the natural `keyring::Error::TooLong` trigger from a real Windows Credential Manager `set_password` on an oversized token (routing itself already unit-tested via `JR_S759_FORCE_TOOLONG`/`JR_FORCE_DPAPI_FALLBACK`); (b) the live `jr auth login --oauth` browser-consent flow. Both would need a physical/manual Windows session or a much larger mocked-OAuth CI investment — explicitly out of scope per human decision. F7 5-dimensional convergence reconfirmed all-PASS (Test/Verification/Holdout strengthened by PR #776). Full regression GREEN (CI 14/14, all three OS legs). **DEC-342 recorded: F7 CONVERGED, human-authorized.** **Two new tracked process-gap follow-ups (non-blocking, detailed below under "cycle-004 maintenance items"):** `JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION` and `PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP`.

**cycle-004 (F6 COMPLETE, F7 automated prep COMPLETE, pipeline PAUSED→ACTIVE→CONVERGED→RELEASED, Bursts 19-22, historical):** Burst 19 resumed from the Burst-18 F5-CONVERGED position. F6 targeted hardening dispatched: Kani/fuzz JUSTIFIED SKIP (proptest substitution, 0 GAP); mutation testing found an examine_globs process gap (zero CI signal on the delta) worked around via `--file` override to 97-100%, with 5 genuine `tenant.rs` survivors fixed via PR #775 @ `024de4d8`; security scan CLEAN; full regression GREEN. F6-TARGETED-HARDENING declared COMPLETE (DEC-341); phase advanced F6→F7. Between Burst 19 and Burst 20, F7 automated prep (pre-gate consistency audit + 5-dimensional delta convergence check + input-hash recompute) ran to completion at commit `a038ac0d`, with all 5 dimensions PASS. Burst 20 executed a human-requested SESSION WRAP: pipeline transitioned ACTIVE → PAUSED at the F7 FINAL HUMAN GATE. Burst 21 resumed the pipeline (PAUSED → ACTIVE) on explicit human authorization to satisfy the REQUIRED Windows-11 DPAPI verification via the `windows-latest` CI runner instead of a physical smoke test; PR #776 delivered that CI test and merged to `develop` @ `135eb804`; the final human F7 gate PASSED (DEC-342); phase F7 declared CONVERGED. Burst 22 (this burst) executed the human-authorized release: PR #777 squash-merged to `develop` @ `569d85a8`, tag `v0.7.0-dev.5` pushed, `release.yml` run `34046676423` SUCCESS, GitHub prerelease published; DEC-343 recorded; **cycle-004 CLOSED.** **Tracked items carried forward, all non-blocking:** `F6-MUTATION-EXAMINE-GLOBS-EXPANSION`, `JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION`, `PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP`, BC-1.4.035-PC5-VP-GAP (production path CI-verified, formal VP still deferred), S-410-KEYCHAIN-ISOLATION-FILE-OVERLAP, TD-031-BLOCKED-BC-6.2.016-CROSSREF, W2-INT-PROCESS-GAP-README-PROSE-DRIFT. `SEC-WCM-DOC-DPAPI-GAP` remains CLOSED (via PR #770, Burst 16). **Hygiene note:** the three pre-existing unrelated dirty files (`regression-state.json`, `sidecar-learning.md`, `S-cycle3-env-tag` demo gif) plus the ephemeral `phase-f6-hardening/cycle-004/{mutants-run*,delta.diff}` scratch remain explicitly NOT staged this burst, per standing instruction. **PRD/VP/BC counts: 742 BCs / 55 VPs / 106 holdout / 172 stories** (unchanged).

**cycle-004 (F4 Wave 1/Wave 2 delivery + F5 convergence + F6 hardening, Bursts 15-19, historical):** `S-cycle4-dpapi-storage-fix` (PR #768 @ `9119b291`) + `S-cycle4-cloud-id-correctness` (PR #769 @ `c2074247`) delivered and merged; F4 CI spike SUCCEEDED; Wave 1 integration gate PASSED (DEC-338). `S-cycle4-windows-docs` (PR #770 @ `abb283e8`) delivered and merged; `S-cycle4-honest-fail-message` (PR #771 @ `281ba272`) converged and merged with a DEC-334 revoke-advice correction, Wave 2 gate PASSED, README findings fixed via PR #772 @ `e5a18fe0`. F5 scoped adversarial review converged via PR #773 @ `f3863f07` + PR #774 @ `3b62cefa`. F6 targeted hardening completed via PR #775 @ `024de4d8`. Full detail `cycles/cycle-004/burst-log.md` Bursts 15-19.

**cycle-004 (F3 APPROVED, F3→F4 transition, Bursts 13-14, historical):** Burst 13 was a pure human-requested pause. Burst 14: human APPROVED the F3 gate (DEC-337); `STORY-INDEX.md` registered (168→172); phase advanced F3→F4, pipeline PAUSED→ACTIVE. Full detail `cycles/cycle-004/burst-log.md` Bursts 13-14.

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
- **F6-MUTATION-EXAMINE-GLOBS-EXPANSION** (Burst 19) — add `src/api/auth.rs`, `src/cli/auth/login.rs`, `src/api/auth_windows_store.rs` to `.cargo/mutants.toml` examine_globs so CI mutation-tests the credential-critical modules. Needs a keychain-injection seam OR a documented exclude_re allowlist for the keyring-gated (VP-005/006/007) + Windows-`#[cfg]` (VP-010) boundary survivors, else CI floods/times-out. Test quality already verified 97-100% via the manual F6 run; only CI enforcement is missing. Target: a future SELF-IMPROVEMENT/maintenance cycle.
- **JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION** (Burst 21, confirmed still open at Burst 22's S-7.02 checklist) — `src/cache.rs`, `src/config.rs`, and `src/api/auth_windows_store.rs` each carry a SEPARATE `ENV_MUTEX`/`CACHE_DIR_SEAM_MUTEX` guarding the SAME process-global `JR_CACHE_DIR` env var; they do not mutually exclude and `cargo test` runs multithreaded. Safe failure mode (a race yields a visible test failure, never a false pass). Unify into one shared crate-test env mutex. Target: a future SELF-IMPROVEMENT/maintenance cycle.
- **PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP** (Burst 21, confirmed still open at Burst 22's S-7.02 checklist) — the vsdd-factory `pr-manager-completion-guard` hook (`plugins/vsdd-factory/hooks/dispatcher`) has no cross-turn memory; it parses only the current turn for `STEP_COMPLETE:` and loops after genuine 9-step completion (alternating between demanding a nonexistent "step 10" and resetting to step 1). This is a FACTORY-ENGINE tooling bug (vsdd-factory plugin), NOT a jira-cli product defect; it did not affect PR #776's correctness. Target: vsdd-factory engine fix.
- **CYCLE-004-INPUT-HASH-HYGIENE** (Burst 19, RESOLVED @ `a038ac0d`) — the 9 cycle-004 F1-F3 delta artifacts flagged with a stale `input-hash` at the F7 pre-gate drift check have been recomputed (pure-recompute, no content change), owned by business-analyst/architect/story-writer respectively. Detail: `phase-f7-convergence/cycle-004/input-hash-drift.md`.
- **TD-031-BLOCKED-BC-6.2.016-CROSSREF** (first recorded Burst 9) — deferred `bc-6-config-cache.md` cross-reference blocked by a pre-existing TD-031 hook violation, unrelated to cycle-004.
- **BC-1.4.035-PC5-VP-GAP** (first recorded Burst 12, UPDATED Burst 15) — production round-trip now CI-verified (VP-AUTHDX-010(b)); formal VP itself still deferred to maintenance.
- **S-410-KEYCHAIN-ISOLATION-FILE-OVERLAP** (first recorded Burst 12) — shares `tests/oauth_refresh_integration.rs` with cycle-004; non-blocking.
- **W2-INT-PROCESS-GAP-README-PROSE-DRIFT** (Burst 17) — no CI guard cross-checks README auth/storage PROSE against the code model (contrast `tests/claude_md_citations.rs`, which checks only path *existence*). Repeated README-vs-code drift across cycles (W2-INT-MED-001, W2-INT-LOW-002 this cycle). Target: a future SELF-IMPROVEMENT/maintenance cycle. Full detail: `code-delivery/wave2-integration-gate-adversary.md`.
- **Windows-verification descoped residuals (Burst 21, not blockers, not gaps):** (a) the natural `keyring::Error::TooLong` trigger from a real Windows Credential Manager `set_password` on an oversized token — routing itself is unit-tested via `JR_S759_FORCE_TOOLONG`/`JR_FORCE_DPAPI_FALLBACK`, only the natural trigger is unexercised. (b) the live `jr auth login --oauth` browser-consent flow. Both require a physical Windows session or a much larger mocked-OAuth CI investment; explicitly out of scope per DEC-342.
- **By-design, not defects (reconfirmed at the F7 gate, Burst 20):** the api-token profile's stored `cloud_id` is unused by `base_url()`; `--cloud-id` is accepted unvalidated.

**PROCESS-GAP (Pass 14, cycle-004, historical, not a blocker):**
- `scripts/check-bc-cumulative-counts.sh` does not cover a per-file `bc-*.md` "## Summary Stats" closing "Note:" cumulative-prose line. Target: a future SELF-IMPROVEMENT/maintenance cycle.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- 165 factory-wide stale `input-hash` artifacts confirmed via full scan (cycle-004 F7 pre-gate check, 2026-09-05; previously estimated ~142 -- growth is ordinary burst churn against the `[live-state]`-sentinel `burst-log.md`/`session-checkpoints.md`/`lessons.md` files across cycles-002/003/004 plus routine STATE.md-referencing artifacts); standing debt, **not** a cycle blocker.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).

## Session Resume Checkpoint

**Date:** 2026-09-06. **Position:** cycle-004 (`windows-correctness`) **CLOSED + RELEASED as `v0.7.0-dev.5`** (DEC-343). **All four tracked cycles (cycle-001 through cycle-004) are now CLOSED — no open cycle, no open work.**

**Release:** version-bump PR #777 (`chore(release): v0.7.0-dev.5`) squash-merged to `develop` @ `569d85a8`; annotated tag `v0.7.0-dev.5` (tag object `41a880d5`) pushed, peeling to `569d85a8`; `release.yml` run `34046676423` concluded SUCCESS across all 5 build targets (x86_64/aarch64 apple-darwin, x86_64/aarch64 unknown-linux-gnu, x86_64-pc-windows-msvc) plus Create Release; GitHub prerelease published (isPrerelease=true, isDraft=false), 10 assets across 5 targets, 2026-09-06T16:55:46Z, at https://github.com/Zious11/jira-cli/releases/tag/v0.7.0-dev.5.

**Convergence:** F5 CONVERGED (DEC-340). F6 COMPLETE (DEC-341). F7 CONVERGED (DEC-342). **RELEASED + CLOSED (DEC-343).** cycle-004's F1-F7 pipeline is fully converged and shipped; no further phase work remains on this cycle.

**In-flight work:** **NONE.** No live sub-agents, no open PRs, no story worktrees. All cycle-004 PRs (#768 through #777) are MERGED.

**Pending human decisions / blockers:** **NONE.** cycle-004 is fully closed; no gate is pending. No cycle currently has open work.

**Accepted non-blocking residuals carried forward (documented, not gating anything):**
- `F6-MUTATION-EXAMINE-GLOBS-EXPANSION`, `W2-INT-PROCESS-GAP-README-PROSE-DRIFT`, `CYCLE-004-INPUT-HASH-HYGIENE` (resolved @ `a038ac0d`), `JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION`, `PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP` — all confirmed still logged (S-7.02 cycle-closing checklist, this burst), targeting a future maintenance/self-improvement cycle or a vsdd-factory engine fix as applicable.
- Windows-verification descoped residuals: (a) the natural `keyring::Error::TooLong` trigger from a real Windows Credential Manager; (b) the live `jr auth login --oauth` browser-consent flow. Both explicitly out of scope per DEC-342 — not gaps in the delivered release.
- By-design items: the api-token profile's stored `cloud_id` is unused by `base_url()` (documented, not a defect); `--cloud-id` is accepted unvalidated (documented, not a defect).

**WIP branches:** **None.** All cycle-004 story branches, all F4-F6 fix branches, PR #776's Windows-CI-verification branch, and PR #777's version-bump branch are merged/deleted. The main checkout is on `develop` @ **`569d85a8`** — the current tip, now in sync with `activation_head`.

**Counts: total_bcs 742; VP count 55; holdout scenarios 106; total_stories 172** (all unchanged this burst — pure release + bookkeeping burst).

**EXACT RESUME COMMAND:** none required — no active cycle. To begin the next unit of work: `/vsdd-factory:mode-decision-guide` or `/vsdd-factory:artifact-detection` to scope a new feature/maintenance cycle, or `/vsdd-factory:session-review` for the optional post-pipeline review.

**Superseded checkpoints:** the prior cycle-004 checkpoint (v3.73, 2026-09-06 — F7 CONVERGED (DEC-342), release execution pending) is superseded in place by this checkpoint and archived to `cycles/cycle-004/session-checkpoints.md` ahead of this Write, with its forward "Superseded at" note pointing to this v3.74 checkpoint. Earlier archives (v3.72 SESSION-WRAP-PAUSE, v3.71 F6→F7 transition, v3.70 F5→F6 transition, v3.69 F4→F5 transition, v3.68 SESSION WRAP/PAUSED, v3.66 F3→F4 transition, v3.65 SESSION-WRAP/PAUSED, v3.64 F3-CONVERGED, v3.62 Passes 20-25, v3.61 gate-audit/Pass-20, v3.60 Passes 12-14, v3.59 Passes 9-11, v3.58 Passes 7-8, v3.57 Passes 5-6, v3.56 Passes 1-4, v3.55 crash-recovery, v3.54 F1-APPROVED, v3.53 F1-IN-PROGRESS) remain at `cycles/cycle-004/session-checkpoints.md`; the cycle-003 checkpoints (v3.52 through v3.31) remain at `cycles/cycle-003/session-checkpoints.md`; cycle-002 checkpoints (v3.29 through v3.23 and earlier) remain at `cycles/cycle-002/session-checkpoints.md`; the cycle-001 CLOSED-position checkpoint (v3.05) remains at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-14 = F2/F3/F4; 15 = F5 CONVERGED + FIX-F5-001; 16 = F6 COMPLETE + FIX-F6-001; 17 = F7 delta-convergence PASS + FIX-F7-001; 18 = F7 human gate APPROVED + cycle-002 CLOSED; 19 = release v0.7.0-dev.3 SHIPPED; 20 = SESSION-WRAP) |
| cycle-003 burst history | `cycles/cycle-003/burst-log.md` (Burst 1 = cycle OPENED; Bursts 2-9 = F1 through F3 gates; Bursts 10-15 = F4 Waves 1-5, all 7 stories merged; Burst 16 = F5 findings fixed; Burst 17 = SESSION WRAP, F5 CONVERGED; Burst 18 = SESSION RESUMED, F6 DISPATCHED; Burst 19 = F6 COMPLETE — PASS; Burst 20 = F7 pre-gate consistency audit; Burst 21 = F7 human gate APPROVED — CONVERGED (DEC-332); Burst 22 = RELEASE v0.7.0-dev.4 SHIPPED, cycle-003 CLOSED (DEC-333)) |
| cycle-004 burst history | `cycles/cycle-004/burst-log.md` (Burst 1 = cycle OPENED; Burst 2 = F1 human gate APPROVED (DEC-335); Burst 3 = CRASH RECOVERY; Bursts 4-10 = F2 scoped adversarial convergence, 25 passes across two attempts + 2 consistency audits; Burst 11 = F2 HUMAN GATE APPROVED (DEC-336); Burst 12 = F3 story decomposition CONVERGED; Burst 13 = SESSION WRAP (F3 gate pending); Burst 14 = F3 HUMAN GATE APPROVED (DEC-337), phase F3→F4; Burst 15 = F4 Wave 1 DELIVERED + MERGED, integration gate PASSED (DEC-338), F4 CI spike SUCCEEDED; Burst 16 = F4 Wave 2 PARTIALLY DELIVERED (`windows-docs` merged, `honest-fail-message` converged/PR-open/reviews-halted) + SESSION WRAP; Burst 17 = PR #771 review resumed + merged @ `281ba272`, Wave 2 integration gate PASSED, README findings fixed via PR #772 @ `e5a18fe0`, F4 COMPLETE (DEC-339), phase F4→F5; Burst 18 = F5 scoped adversarial review CONVERGED (DEC-340) via 2 fix rounds — PR #773 @ `f3863f07`, PR #774 @ `3b62cefa` — phase F5→F6; Burst 19 = F6 targeted hardening COMPLETE (DEC-341) via 1 fix round — PR #775 @ `024de4d8` — phase F6→F7, then the F7 pre-gate input-hash drift check ran (no gate-blocking drift); Burst 20 = F7 automated prep COMPLETE (consistency audit + 5-dimensional convergence check + input-hash recompute @ `a038ac0d`, all 5 dimensions PASS) then SESSION WRAP — pipeline PAUSED at the F7 final human gate; Burst 21 = REQUIRED Windows-11 DPAPI verification SATISFIED VIA CI (PR #776 @ `135eb804`, `Test (windows-latest)` run `34040856196`) and F7 human gate PASSED — CONVERGED (DEC-342); Burst 22 = **RELEASE v0.7.0-dev.5 SHIPPED** (PR #777 @ `569d85a8`, tag `v0.7.0-dev.5`, `release.yml` run `34046676423` SUCCESS, GitHub prerelease 10 assets/5 targets), **cycle-004 CLOSED (DEC-343)**) |
| cycle-004 F1 delta-analysis artifacts | `cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md` + `affected-files.txt` |
| cycle-004 F2 spec-evolution artifacts | `cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md`; `vp-delta.md`; `specs/architecture/decisions/ADR-0021-*.md` (amended Burst 16 with the §6 revoke-advice correction); `specs/architecture/decisions/ADR-0022-*.md` |
| cycle-004 F3 story-decomposition artifacts | `cycles/cycle-004/phase-f3-stories/` — `decomposition-manifest.md`, `S-cycle4-{dpapi-storage-fix,cloud-id-correctness,honest-fail-message,windows-docs}.md`, `dependency-graph-extended.md`, `wave-schedule.md`, `conflict-report.md`, `wave-holdout-scenarios/` |
| cycle-004 F4 implementation delivery evidence | `code-delivery/S-cycle4-{dpapi-storage-fix,cloud-id-correctness,windows-docs}/pr-review.md`; `code-delivery/S-cycle4-honest-fail-message/{pr-review.md,pr-approve-body.md,pr-rereview-new1.md,pr-rereview-pr-reviewer.md,pr-rereview-security.md}` (PR #771, all 4 stories now merged) |
| cycle-004 F4 Wave 2 integration gate + README fix evidence | `code-delivery/wave2-integration-gate-adversary.md` (gate report); `code-delivery/FIX-W2-INT-README-pr-review.md` (PR #772) |
| cycle-004 F5 scoped adversarial review evidence | `phase-f5-adversarial/cycle-004/convergence-summary.md` (summary); `code-delivery/FIX-F5-CYCLE4-1-pr-review.md` (PR #773 review); `code-delivery/FIX-F5-CYCLE4-2-pr-review.md` (PR #774 review) |
| cycle-004 F6 targeted hardening evidence | `phase-f6-hardening/cycle-004/summary.md` (summary); `phase-f6-hardening/cycle-004/{kani-results.md,fuzz-results.md,mutation-results.md,security-scan-results.md}`; `code-delivery/FIX-F6-1-pr-review.md` (PR #775 review) |
| cycle-004 F7 pre-gate input-hash drift check | `phase-f7-convergence/cycle-004/input-hash-drift.md` |
| cycle-004 F7 automated convergence prep (consistency audit + 5-dim check + input-hash recompute) | factory-artifacts commit `a038ac0d` |
| cycle-004 F7 Windows-verification-via-CI evidence (Burst 21) | GitHub PR #776 (`test/cycle4-dpapi-file-roundtrip-win-ci`, merge commit `135eb804`) + CI run `34040856196` (`Test (windows-latest)`); no separate local `.factory/code-delivery/` review artifact was produced for this fix |
| cycle-004 release evidence (Burst 22) | GitHub PR #777 (`chore(release): v0.7.0-dev.5`, merge commit `569d85a8`); tag `v0.7.0-dev.5` (tag object `41a880d5`); `release.yml` run `34046676423`; GitHub Release https://github.com/Zious11/jira-cli/releases/tag/v0.7.0-dev.5 (10 assets/5 targets) |
| cycle-004 revoke-granularity research | `research/atlassian-3lo-revoke-granularity-2026-09-05.md` (Perplexity-validated; grounds the DEC-334 amendment) |
| cycle-004 session checkpoints | `cycles/cycle-004/session-checkpoints.md` (archives v3.64 through v3.73; this burst writes the live v3.74 into STATE.md directly) |
| cycle-004 cloud_id research | `research/edge-tenant-info-cloudid-2026-09-03.md` |
| cycle-003 grounding + phase artifacts | `cycles/cycle-003/investigation/`, `cycles/cycle-003/phase-f1-delta-analysis/`, `phase-f2-spec-evolution/`, `phase-f3-stories/`, `phase-f4-implementation/`, `phase-f6-hardening/`, `phase-f7-convergence/` |
| cycle-003 release + F4/F5 delivery evidence | version-bump PR #767 (`develop` @ `42e92b46`); tag `v0.7.0-dev.4`; `release.yml` run `33769389700`; `code-delivery/FIX-F7-DOCS-1/`, `code-delivery/S-cycle3-*/`, `code-delivery/FIX-F5-*/` |
| cycle-002/cycle-001 historical artifacts | `cycles/cycle-002/`, `cycles/cycle-001/` (see per-cycle files) |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**cycle-004 (RELEASE + CLOSE, DEC-343, Burst 22):** Human authorized and executed the cycle-004 dev release: PR #777 squash-merged (`135eb804` → `569d85a8`), tag `v0.7.0-dev.5` pushed, `release.yml` run `34046676423` SUCCESS, GitHub prerelease published with 10 assets/5 targets. **cycle-004 is CLOSED.** S-7.02 cycle-closing checklist: both process-gap deferrals (`JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION`, `PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP`) confirmed present in `Constraints Carried Forward` → "cycle-004 maintenance items" as justified deferrals; all other outstanding items carried forward verbatim. **All four tracked cycles (cycle-001, cycle-002, cycle-003, cycle-004) are now CLOSED — no open cycle, no open work.**

**cycle-004 (F7 CONVERGED, DEC-342, Burst 21, historical):** the REQUIRED Windows-11 DPAPI verification gap noted below (Bursts 19-20) was closed for the production DPAPI-encrypted-file round-trip via PR #776's `windows-latest` CI test (see `Constraints Carried Forward` above for full detail). Two process-gap items were logged that burst: `JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION` and `PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP` (both detailed under `Constraints Carried Forward` → "cycle-004 maintenance items", both reconfirmed still open at this burst's S-7.02 checklist). The two residuals — (a) the natural `keyring::Error::TooLong` trigger, (b) the live OAuth browser-consent flow — remain genuinely un-exercised and are recorded as explicitly descoped per DEC-342, not silent gaps.

**cycle-004 (F7 pre-gate input-hash drift check DONE, Burst 19; recomputed @ `a038ac0d`):** Factory-wide `compute-input-hash --scan .factory` (+ `--resolve`) ran across 215 tracked artifacts. **No gate-blocking drift for cycle-004:** the 2 `cycles/cycle-004/{burst-log,session-checkpoints}.md` files use the standard `[STATE.md]`-input / `"[live-state]"`-hash sentinel (by-design, always recomputes different from the literal sentinel string — same convention as cycles 001-003); the 9 real-hash F1-F3 delta artifacts (`delta-analysis.md`, `architecture-delta.md`, `decomposition-manifest.md`, `S-cycle4-windows-docs.md`, `conflict-report.md`, `dependency-graph-extended.md`, `wave-schedule.md`, both `wave-*-holdout-scenarios.md`) drifted as a single traceable cascade: `delta-analysis.md`/`architecture-delta.md` declare `.factory/STATE.md` and/or `src/api/{auth,client,refresh_coordinator}.rs`, `src/cli/auth/*.rs`, `src/config.rs`, `src/cache.rs`, `Cargo.{toml,lock}`, `deny.toml`, `README.md`, `CLAUDE.md` as inputs, and `git log` confirmed every one of those (except `refresh_coordinator.rs`) was modified by the cycle-004 F4-F6 delivery PRs (#768/#769/#771/#772/#773/#774/#775) already merged to `develop`; the other 7 artifacts cascaded purely by referencing those two (or each other) as their own inputs. **RESOLVED @ `a038ac0d`:** all 9 flagged artifacts were pure-recomputed (no content change) by their respective owning agents (business-analyst/architect/story-writer). The pre-existing factory-wide standing pool remains confirmed at **165 STALE artifacts** (previously estimated ~142) and left untouched — see `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` above. Full report: `phase-f7-convergence/cycle-004/input-hash-drift.md`.

**cycle-004 (F6 COMPLETE, F7 automated prep COMPLETE, pipeline PAUSED→ACTIVE→CONVERGED→RELEASED, Bursts 19-22):** Burst 19 resumed from the Burst-18 F5-CONVERGED position. F6 targeted hardening dispatched: Kani/fuzz JUSTIFIED SKIP (proptest substitution, 0 GAP); mutation testing found an examine_globs process gap (zero CI signal on the delta) worked around via `--file` override to 97-100%, with 5 genuine `tenant.rs` survivors fixed via PR #775 @ `024de4d8`; security scan CLEAN; full regression GREEN. F6-TARGETED-HARDENING declared COMPLETE (DEC-341); phase advanced F6→F7. Between Burst 19 and Burst 20, F7 automated prep ran to completion at commit `a038ac0d`, with all 5 dimensions PASS. Burst 20 executed a human-requested SESSION WRAP: pipeline transitioned ACTIVE → PAUSED at the F7 FINAL HUMAN GATE. Burst 21 resumed the pipeline (PAUSED → ACTIVE) on explicit human authorization to satisfy the REQUIRED Windows-11 DPAPI verification via the `windows-latest` CI runner instead of a physical smoke test; PR #776 delivered that CI test and merged to `develop` @ `135eb804`; the final human F7 gate PASSED (DEC-342); phase F7 declared CONVERGED. Burst 22 executed the human-authorized release: PR #777 squash-merged to `develop` @ `569d85a8`, tag `v0.7.0-dev.5` pushed, `release.yml` run `34046676423` SUCCESS, GitHub prerelease published (10 assets/5 targets); DEC-343 recorded; **cycle-004 CLOSED, RELEASED. pipeline: RELEASED (resting state).** **Tracked items carried forward, all non-blocking:** `F6-MUTATION-EXAMINE-GLOBS-EXPANSION`, `JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION`, `PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP`, BC-1.4.035-PC5-VP-GAP (production path CI-verified, formal VP still deferred), S-410-KEYCHAIN-ISOLATION-FILE-OVERLAP, TD-031-BLOCKED-BC-6.2.016-CROSSREF, W2-INT-PROCESS-GAP-README-PROSE-DRIFT. `SEC-WCM-DOC-DPAPI-GAP` remains CLOSED (via PR #770, Burst 16). **Hygiene note:** the three pre-existing unrelated dirty files (`regression-state.json`, `sidecar-learning.md`, `S-cycle3-env-tag` demo gif) plus the ephemeral `phase-f6-hardening/cycle-004/{mutants-run*,delta.diff}` scratch remain explicitly NOT staged this burst, per standing instruction. **Next:** no active cycle — all four tracked cycles CLOSED.

**cycle-004 (F4 Wave 1/Wave 2 delivery + F5 convergence + F6 hardening, Bursts 15-19, historical):** `S-cycle4-dpapi-storage-fix` (PR #768 @ `9119b291`) + `S-cycle4-cloud-id-correctness` (PR #769 @ `c2074247`) delivered and merged; F4 CI spike SUCCEEDED; Wave 1 integration gate PASSED (DEC-338). `S-cycle4-windows-docs` (PR #770 @ `abb283e8`) delivered and merged; `S-cycle4-honest-fail-message` (PR #771 @ `281ba272`) converged and merged with a DEC-334 revoke-advice correction, Wave 2 gate PASSED, README findings fixed via PR #772 @ `e5a18fe0`. F5 scoped adversarial review converged via PR #773 @ `f3863f07` + PR #774 @ `3b62cefa`. F6 targeted hardening completed via PR #775 @ `024de4d8`. Full detail `cycles/cycle-004/burst-log.md` Bursts 15-19.

**cycle-004 (F3 APPROVED, F3→F4 transition, Bursts 13-14, historical):** Burst 13 was a pure human-requested pause. Burst 14: human APPROVED the F3 gate (DEC-337); `STORY-INDEX.md` registered (168→172); phase advanced F3→F4, pipeline PAUSED→ACTIVE. Full detail `cycles/cycle-004/burst-log.md` Bursts 13-14.

**cycle-004 (F2, scoped adversarial convergence + human gate, Bursts 3-11, historical):** the full 25-pass trajectory, the post-Pass-6 consistency sweep, and both pre-gate consistency audits are fully resolved and closed as of DEC-336. **PROCESS-GAP (Pass 14, still open):** `scripts/check-bc-cumulative-counts.sh` coverage gap on per-file Summary-Stats-Note prose, target a future maintenance cycle. Full detail: `cycles/cycle-004/burst-log.md` Bursts 4-11.

**cycle-003 (RELEASE + CLOSE, historical):** DEC-333: PR #767 squash-merged, tag `v0.7.0-dev.4` pushed, `release.yml` SUCCESS, GitHub prerelease published. **cycle-003 is CLOSED.** Both S-7.02 process-gap deferrals codified in `cycles/cycle-003/lessons.md`. All prior outstanding items (MED-1, LOW-4/LOW-6, template-compliance gap, input-hash cascade) deferred to a future maintenance cycle.

**cycle-003 (F7 pre-gate audit + F5/F6 detail, historical):** 12-finding pre-gate consistency audit, CRIT/HIGH/most-MED FIXED, MED-1/LOW-4/LOW-6 carried forward. F5 findings RESOLVED via PR #763/#764; F6 GATE VERDICT PASS (mutation 100%, security clean, regression 4763/0/157). Full detail: `cycles/cycle-003/burst-log.md` Bursts 16-20.

**cycle-003 (earlier F4/F3/F2 resolutions, historical):** F1 (BYO-OAuth-cred over-delete) and ADR-0011 doc-drift CLOSED (Burst 15). ADR-0011-staged-not-applied CLOSED (Burst 14, `S-cycle3-adr0011-newtype` PR #758). DEC-NAMESPACE-COLLISION-RISK clean (max ID DEC-343, no collision). Wave 1/2 integration gates PASSED; all 7 cycle-003 stories squash-merged.

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
- **F6-MUTATION-EXAMINE-GLOBS-EXPANSION** (Burst 19) — expand `.cargo/mutants.toml` examine_globs to the 4 remaining cycle-004 credential-critical files; needs a keychain-injection seam or documented exclude_re allowlist. Target a future SELF-IMPROVEMENT/maintenance cycle.
- **JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION** (Burst 21, reconfirmed open Burst 22) — unify the 3 separate `JR_CACHE_DIR` test env-mutexes (`cache.rs`, `config.rs`, `auth_windows_store.rs`) into one shared crate-test mutex; safe failure mode today. Target a future SELF-IMPROVEMENT/maintenance cycle.
- **PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP** (Burst 21, reconfirmed open Burst 22) — vsdd-factory `pr-manager-completion-guard` hook loops after genuine 9-step completion (no cross-turn memory); factory-engine bug, not a jira-cli defect. Target a vsdd-factory engine fix.
- **CYCLE-004-INPUT-HASH-HYGIENE** (Burst 19, RESOLVED @ `a038ac0d`) — 9 cycle-004 F1-F3 delta artifacts had their `input-hash` refreshed (pure recompute, no content change) after the F4-F6 implementation cascade; see `Constraints Carried Forward` above and `phase-f7-convergence/cycle-004/input-hash-drift.md`.
- **TD-031-BLOCKED-BC-6.2.016-CROSSREF** — blocked by pre-existing TD-031 hook violation, unrelated to cycle-004.
- **BC-1.4.035-PC5-VP-GAP** — production round-trip now CI-verified (VP-AUTHDX-010(b)); formal VP deferred.
- **S-410-KEYCHAIN-ISOLATION-FILE-OVERLAP** — shares `tests/oauth_refresh_integration.rs` with cycle-004; non-blocking.
- **W2-INT-PROCESS-GAP-README-PROSE-DRIFT** (Burst 17) — no CI guard cross-checks README prose against the code model. Target a future maintenance cycle.

**PROCESS-GAP (Pass 14, cycle-004, historical, not a blocker):**
- `scripts/check-bc-cumulative-counts.sh` coverage gap on per-file Summary-Stats-Note prose. Target a future maintenance cycle.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- 165 historical stale `input-hash` artifacts factory-wide (confirmed this burst; previously ~142); standing debt, **not** a cycle blocker.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
