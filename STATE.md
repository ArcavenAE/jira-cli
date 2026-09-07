---
document_type: pipeline-state
level: ops
version: "3.78"
status: active
producer: state-manager
timestamp: 2026-09-07T04:40:06Z
phase: "PAUSED 2026-09-07. cycle-005 (adf-mentions) Phase F4 delta implementation, Wave 1 (Story A, S-cycle5-mention-pure-conversion) — per-story adversarial convergence COMPLETE (3 clean passes); Story A PR #778 OPEN awaiting final CI + human merge approval."
pipeline: PAUSED
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
last_amended: "2026-09-07, v3.78, state-manager — SESSION WRAP: cycle-005 F4 Wave 1 paused at Story A PR #778 (awaiting CI+merge); committed the F4 ADR-0023 §4a addendum + architecture-delta §4.1a."
current_step: "trajectory-tail →1→3→0→2 (unchanged this burst). D-chain cite D-31 latest brownfield (unchanged). SESSION-WRAP-PAUSE-2026-09-07: cycle-005 F4 Wave 1 Story A PR #778 OPEN, 13/14 CI checks green (Mutation testing PENDING), pr-reviewer APPROVE, security-reviewer CLEAN. NEXT: await CI, merge PR #778, Wave-1 integration gate, then Story B (Wave 2, S-cycle5-mention-resolution-wiring)."
trajectory_tail: "→1→3→0→2"
maintenance_run:
  status: COMPLETE
  date: 2026-08-25
  findings_count: 10
  fixes_applied: 6
  fixes_pending: 4
  pr: 737
current_cycle: "cycle-005"
feature_mode_bundle: adf-mentions
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: SOH-ATTACHMENTS-1 F5 SCOPED ADVERSARIAL CONVERGED 2026-07-24 STRICT (14 rounds; window pass-12/pass-13/pass-14 CLEANx3; spec v1.3.99 to v1.3.106; BC-INDEX v6.38 to v6.44; develop @ db207b81) + F7 DELTA CONVERGENCE APPROVED 2026-07-25 (DEC-186; 5-dim PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED) + CYCLE FULLY CLOSED 2026-07-25
cycle_001_status: "list-read-ergonomics -- CLOSED (DEC-309), historical; see cycles/cycle-001/"
cycle_002_status: "field-dx -- CLOSED + RELEASED 2026-09-01 (DEC-311 close; v0.7.0-dev.3 tagged @ 87f17aff, release.yml run 33459579699 triggered). All 5 stories delivered/merged (F4); F5 CONVERGED (FIX-F5-001, PR #747); F6 COMPLETE (FIX-F6-001, PR #749); F7 COMPLETE (5-dim convergence PASS + full regression PASS 4660/0/106, FIX-F7-001, PR #750 @ 2000c455); RELEASED (version bump PR #751 @ 87f17aff, tag v0.7.0-dev.3 pushed, release.yml triggered). Pipeline SHIPPED."
cycle_003_status: "auth-profile-dx -- CLOSED + RELEASED 2026-09-03 (v0.7.0-dev.4 @ 42e92b46, PR #767; release.yml run 33769389700 SUCCESS; GitHub prerelease published, 10 assets/5 targets). F1-F7 complete + released. Pipeline shipped."
cycle_004_status: "windows-correctness -- CLOSED + RELEASED 2026-09-06 (DEC-343; v0.7.0-dev.5 @ 569d85a8, PR #777; release.yml run 34046676423 SUCCESS; GitHub prerelease published, 10 assets/5 targets). F1-F7 complete + released. Pipeline shipped."
cycle_005_status: "adf-mentions -- OPEN, PAUSED for session wrap 2026-09-07; Phase F1 delta analysis APPROVED (DEC-344); Phase F2 spec evolution APPROVED (DEC-345 tightening + DEC-346 approval); Phase F3 story decomposition APPROVED (DEC-347); Phase F4 (delta implementation) IN PROGRESS — Wave 1 (S-cycle5-mention-pure-conversion) implemented, per-story adversarial convergence COMPLETE (3 clean passes), PR #778 OPEN awaiting CI+merge; Wave 2 (S-cycle5-mention-resolution-wiring) blocked-on-wave-1. See phase-f1-delta-analysis/cycle-005/ + phase-f2-spec-evolution/{prd,verification,architecture}-delta-674.md + cycles/cycle-005/phase-f3-stories/ + .factory/sprint-state.yaml cycle_005_adf_mentions + cycles/cycle-005/burst-log.md Bursts 1-4."
activation_head: "569d85a8"
activation_version: "v0.7.0-dev.5"
---

<!-- STATE.md SIZE BUDGET (2026-09-07, cycle-005 Burst 4 -- SESSION WRAP PAUSE;
     line count refreshed after this burst's Write):
     Phase F4 (delta implementation) Wave 1 (Story A, S-cycle5-mention-pure-conversion) was
     dispatched, implemented via the standard per-story-delivery TDD pipeline, and reached
     per-story adversarial convergence (3 clean passes) with PR #778 opened, pr-reviewer
     APPROVE, and security-reviewer CLEAN. PR #778 was still mid-CI (13/14 checks green,
     Mutation testing PENDING) and unmerged when the human requested a session wrap. This
     burst pauses the pipeline (pipeline: ACTIVE->PAUSED) and commits the two outstanding
     cycle-005 F4 spec artifacts left uncommitted by the implementation work: the
     ADR-0023-markdown-mention-pure-effectful-conversion-seam.md file (full addendum,
     including new §4a bracket-form pre-parse protection) and the
     phase-f2-spec-evolution/architecture-delta.md §4.1a addendum documenting the same
     discovery (CommonMark destroys characters inside `[~accountid:X]` before any
     post-`finish()` tree-walk runs, requiring a second pre-parse protection mechanism,
     `protect_bracket_mentions`, alongside the existing `\@`-escape sentinel scheme).
     To make room within budget, the cycle-005 Burst 3 "Current Phase Steps" table (5 rows)
     was dropped from STATE.md -- its content is already fully covered in prose at
     cycles/cycle-005/burst-log.md Burst 3, so no re-archival write was needed (mirrors the
     compaction pattern used at every prior burst). The v3.77 Session Resume Checkpoint was
     archived to cycles/cycle-005/session-checkpoints.md (replacing the Burst-3 entry there)
     with a "Superseded at" note BEFORE this burst's new v3.78 checkpoint was written.
     Decisions Log is unchanged this burst (no new gate decision -- a session pause is not a
     DEC); the DEC-347/DEC-345-346/DEC-344 condensed-summary rows remain as previously
     compacted. Phase Progress table's F4-DELTA-IMPLEMENTATION row notes were updated in
     place (still IN PROGRESS -- Wave 1 implemented but not yet merged; table still 7 rows).
     The cycle-005 Burst 3 paragraph under Constraints Carried Forward / Drift-Standing-Items
     was condensed to a short pointer (full detail already lives at
     cycles/cycle-005/burst-log.md Burst 3) per the same one-burst-lag compaction rule
     applied every prior burst; a new Burst 4 paragraph was added in its place.
     soft target 200 lines; hard cap 500 lines. 343 lines (wc-l) (this file, this Write).
     margin from soft-target = 343 - 200 = 143 (OVER the soft target; documented, ongoing known
     deviation across cycles-002/003/004/005, not a blocker). margin from actual = 500 - 343 = 157
     (dual-margin form; headroom remains before the hard cap).
     RECOVERY CONTEXT: no crash this burst -- clean, human-requested session wrap from the
     cycle-005 Burst 3 (F3 APPROVED / F4 dispatched) resting state, after Wave 1 (Story A) was
     independently implemented, reviewed, and opened as PR #778 by the standard per-story-
     delivery pipeline in the interim. No sub-agent work was abandoned mid-step: an implementer
     that looped on a background test was recovered, and its pre-PR fixes were committed as
     `89b84a1f` before this burst began.
     Factory lock: no factory_lock frontmatter block is present in this STATE.md and the
     lock-write/verify-sha-currency scripts are not provisioned in this repo -- the renew/unlock
     step this burst is therefore a no-op, noted rather than fabricated. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →1→3→0→2 (unchanged this burst) |
| **Last Updated** | trajectory-tail →1→3→0→2 (unchanged this burst). Burst 4 of cycle-005 (2026-09-07) — **SESSION WRAP / PAUSE:** Phase F4 Wave 1 (Story A, `S-cycle5-mention-pure-conversion`) reached per-story adversarial convergence (3 clean passes) and opened PR #778 (branch `feat/cycle5-mention-pure-conversion` @ `89b84a1f`) — pr-reviewer APPROVE, security-reviewer CLEAN, CI 13/14 green with "Mutation testing" PENDING. Human requested a session wrap before PR #778's CI finished; pipeline **PAUSED**. Committed the two outstanding F4 spec artifacts (ADR-0023 §4a addendum + `architecture-delta.md` §4.1a) documenting the bracket-form pre-parse-protection discovery. `develop` unchanged this burst at `569d85a8` (PR #778 not yet merged). |
| **Current Phase** | Feature Mode cycle-005 (`adf-mentions`) — **PAUSED 2026-09-07.** Phase F4 (delta implementation) Wave 1 (Story A) convergence COMPLETE, PR #778 OPEN awaiting CI + merge. cycle-001 through cycle-004 remain CLOSED, historical. |
| **Activation HEAD** | `569d85a8` (`develop` tip; unchanged this burst — PR #778 not yet merged) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, cycles/cycle-003/burst-log.md, cycles/cycle-004/burst-log.md, cycles/cycle-005/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **RELEASE v0.7.0-dev.5 (cycle-004)** | **RELEASED — SHIPPED** | 2026-09-06 | human-authorized dev release; `release.yml` run `34046676423` SUCCESS | PR #777 squash-merged; tag `v0.7.0-dev.5` pushed; GitHub prerelease published (10 assets/5 targets). cycle-004 (`windows-correctness`) CLOSED (DEC-343). Full detail: `cycles/cycle-004/burst-log.md` Bursts 21-22. | counts unchanged; tag `v0.7.0-dev.5` |
| **F1-DELTA-ANALYSIS (cycle-005)** | **APPROVED** | 2026-09-06 | Human approved F1 delta analysis scope (DEC-344) | Feature: `adf-mentions` (GitHub #674), brownfield delta on the markdown→ADF write path. Full detail: `phase-f1-delta-analysis/cycle-005/`. | counts unchanged (742/55/106/172) |
| **F2-SPEC-EVOLUTION (cycle-005)** | **APPROVED** | 2026-09-06 | 10-pass scoped adversarial convergence (passes 7-10 all 0-CRIT/HIGH/MED) + pre-gate consistency audit + human gate PASSED with 1 TIGHTENING decision (DEC-345) + full approval (DEC-346) | 12 new BCs, new ADR-0023, 21 VPs, 12 holdout scenarios, 8 amended BCs. Spec 2.1.0→2.2.0. Full detail: `phase-f2-spec-evolution/{prd,verification,architecture}-delta-674.md` + `cycles/cycle-005/burst-log.md` Burst 2. | 742→754 BCs; 55→76 VPs; 106→118 holdouts |
| **F3-INCREMENTAL-STORIES (cycle-005)** | **APPROVED** | 2026-09-06 | 6-pass adversarial story convergence (passes 5-6 both CLEAN) + human gate PASSED (DEC-347) | 2 stories: `S-cycle5-mention-pure-conversion` (Wave 1, 13 pts, CRITICAL, 15 ACs, `depends_on:[]`) + `S-cycle5-mention-resolution-wiring` (Wave 2, 13 pts, HIGH, 17 ACs, `depends_on:[pure-conversion]`); acyclic A→B; 2 sequential waves; critical path 26 pts. Full detail: `cycles/cycle-005/phase-f3-stories/` + `cycles/cycle-005/burst-log.md` Burst 3. | 172→174 stories; F3 verdict **APPROVED (DEC-347)** |
| **F4-DELTA-IMPLEMENTATION (cycle-005)** | **IN PROGRESS** | — | Wave 1 (Story A) per-story adversarial convergence COMPLETE (3 clean passes); PR #778 awaiting CI + human merge approval | AC-007 `\@`-escape SPIKE came back FEASIBLE (ADR-0023 §4 sentinel scheme). New F4 discovery: CommonMark destroys characters inside `[~accountid:X]` pre-parse — closed via a second pre-parse protection mechanism, `protect_bracket_mentions` (ADR-0023 §4a + `architecture-delta.md` §4.1a). PR #778: branch `feat/cycle5-mention-pure-conversion` @ `89b84a1f`, 13/14 CI green (Mutation testing PENDING), pr-reviewer APPROVE, security-reviewer CLEAN (1 non-blocking LOW deferred to Story B). Wave 2 (`S-cycle5-mention-resolution-wiring`) remains blocked-on-wave-1. Session **PAUSED** here (Burst 4 SESSION WRAP) pending CI completion + merge. | counts unchanged pending F4 delivery (754/76/118/174) |

## Current Phase Steps (cycle-005, F4 Wave 1 Story A — Burst 4 SESSION WRAP)

| Step | Status | Notes |
|------|--------|-------|
| Wave 1 (Story A, `S-cycle5-mention-pure-conversion`) dispatched to per-story-delivery pipeline | **DONE** | test-writer → implementer → demo-recorder → pr-manager → devops-engineer. |
| AC-007 `\@`-escape spike | **FEASIBLE** | Implemented via ADR-0023 §4 sentinel scheme (`SENTINEL_ESCAPE`/`SENTINEL_GUARD` collision guard). |
| Bracket-form pre-parse protection discovery + fix | **DONE** | CommonMark destroys chars inside `[~accountid:X]` pre-parse; new `protect_bracket_mentions` mechanism documented in ADR-0023 §4a + `architecture-delta.md` §4.1a addendum (committed this burst). |
| Story A per-story adversarial convergence | **COMPLETE** | 3 clean passes (passes 3-5, all 0-CRIT/HIGH/MED). |
| Story A PR #778 opened + reviewed | **DONE** | pr-reviewer APPROVE (1 IMPORTANT doc finding fixed in the PR body); security-reviewer CLEAN (1 non-blocking LOW deferred to Story B). Branch `feat/cycle5-mention-pure-conversion` @ `89b84a1f`. |
| PR #778 CI | **IN PROGRESS** | 13/14 checks green; "Mutation testing" PENDING at wrap time. |
| SESSION-WRAP-PAUSE-2026-09-07 | **COMPLETE** | state-manager — pipeline PAUSED at Story A PR #778 (awaiting CI+merge); committed F4 ADR-0023 §4a addendum + architecture-delta §4.1a. |

(Prior cycle-005 Burst 3 steps — F3 adversarial convergence through F4 wave-tracking registration — archived in full prose to `cycles/cycle-005/burst-log.md` Burst 3. Prior cycle-005 Burst 1-2 steps archived to their own `cycles/cycle-005/burst-log.md` entries. Prior cycle-004 burst steps archived to `cycles/cycle-004/burst-log.md`. Prior cycle-001/002/003 steps archived to their own `cycles/<cycle>/burst-log.md`.)

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-347 | Human **APPROVED** cycle-005 (`adf-mentions`, GitHub #674) Phase F3 story decomposition in full. **2 stories:** **S-cycle5-mention-pure-conversion** (Wave 1, 13 pts, priority P0/module_criticality **CRITICAL**, target `src/adf.rs`, 15 ACs, `depends_on: []`, `blocks: [S-cycle5-mention-resolution-wiring]`; BC-7.2.016/017/018/019 + BC-7.2.004 amended; `find_mention_candidates`/`markdown_to_adf_with_mentions`/`markdown_to_adf_no_mentions`, the definitive 5-step post-`finish()` pass order, the `\@` escape mechanism — F4 SPIKE, infeasibility routes a scope-cut decision to the orchestrator — `attrs.text` population, reverse-path `"mention"` render arm) + **S-cycle5-mention-resolution-wiring** (Wave 2, 13 pts, priority P0/module_criticality **HIGH**, target `src/cli/issue/mentions.rs`, 17 ACs, `depends_on: [S-cycle5-mention-pure-conversion]`; BC-X.7.007..010, BC-3.3.012/BC-3.4.032/BC-3.5.013/BC-3.8.018, BC-7.2.016 cross-ref wiring half; new `resolve_mentions`/`filter_by_name_match`, wired into `issue create`/`issue edit` incl. `--dry-run` forced-non-interactive/`comment add`+`edit`/JSM `issue create --request-type`; `--no-mentions` opt-out; human-required live-Jira E2E round-trip H-NEW-MENTION-009). **A→B acyclic dependency** (Kahn-layering proof, `dependency-graph-extended.md`); **2 sequential waves**; **critical path 2 stories / 26 points** (100% of the cycle's points — every point lies on the critical path per `wave-schedule.md`). **Story count 172→174** (STORY-INDEX.md v1.6.16, both rows already present from prior F3 authoring/adversarial-fix bursts). Reached via **6 rounds of adversarial story convergence** (passes 5-6 both CLEAN); earlier-pass fixes included F-H-01 (moving H-NEW-MENTION-001 — an effectful MUST-PASS scenario unsatisfiable by pure Story A alone — to Story B's holdout_anchors), F-H-02 (orphaned VP-674-005 given a covering AC — Story A ACs 14→15, new §9 VP Coverage Matrix), and F-M-01/F-M-02/F-M-03 (Story A's "independently shippable" framing softened to "independently buildable/testable" plus a new Interim Shippability Note documenting the accepted, time-boxed unvalidated-bracket-conversion window between Wave 1's merge and Wave 2's BC-X.7.010 preflight landing; BC-7.2.016 cross-referenced into Story B as its wiring half). All 13 in-scope BCs / 21 VPs / 12 holdouts mapped across the two stories (three-surface EC reconciliation proof, `dependency-graph-extended.md` §8/§9). Phase advances F3→F4 | Human reviewed the complete F3 decomposition (both story files, `dependency-graph-extended.md`, `wave-schedule.md`, and the 6-pass adversarial-convergence record) and approved proceeding to delta implementation with the captured 2-wave split, including the documented interim-window tradeoff | F3 | 2026-09-06 | human (explicit approval) |
| DEC-345 / DEC-346 (condensed) | F2-gate **TIGHTENING** (`@Name` single-result `filter_by_name_match` hard-error, BC-X.7.007 in-place amendment + H-NEW-MENTION-012 + VP-674-021) plus full F2 **APPROVAL** (12 new BCs, ADR-0023, 21 VPs, 12 holdouts, 8 amended BCs total, spec 2.1.0→2.2.0 MINOR). Phase advanced F2→F3. Full text: `cycles/cycle-005/burst-log.md` Burst 2 | (condensed this burst per the one-burst-lag compaction rule — see Burst 2 for full rationale) | F2 (gate) | 2026-09-06 | human (explicit approval, both decisions) |
| DEC-344 | Human APPROVED cycle-005 Phase F1 delta analysis: two mention forms (bracket pure-conversion+preflight-validate; `@Name` effectful resolution), hard-error `@Name` no-match (exit 64) with `\@` escape + `--no-mentions` opt-out, ambiguous-match prompt/error-with-candidates, `attrs.text` from resolved display name, wiring incl. JSM `issue create --request-type`, reverse-path `adf_to_text` update, and a live-Jira E2E test requirement. Also approved reconciling a duplicate F1 artifact-mapping.md (orchestrator coordination error) by folding its distinct proposals into the canonical file as an "Alternative decomposition (F2 input)" note. Phase advanced F1→F2. Full text: `cycles/cycle-005/burst-log.md` Burst 1 | Human reviewed both F1 delta-analysis artifacts and approved proceeding to spec evolution | F1 | 2026-09-06 | human (explicit approval) |
| DEC-343 | Human authorized and executed the cycle-004 dev release **v0.7.0-dev.5** (PR #777 squash-merged to `develop` @ `569d85a8`, tag `v0.7.0-dev.5` pushed, `release.yml` run `34046676423` SUCCESS, GitHub prerelease published with 10 assets/5 targets). cycle-004 (`windows-correctness`) is now **CLOSED** | F7 reached human-authorized CONVERGENCE at DEC-342; the human then explicitly triggered the release action | RELEASE | 2026-09-06 | human (explicit authorization) |
| (346 older cycle-004/003/002/001 decisions) | DEC-342 through DEC-309 and earlier — unchanged this burst | — | F1-F7/historical | 2026-08-24…2026-09-06 | various — see `cycles/cycle-004/burst-log.md` Bursts 1-22 and `cycles/cycle-003/burst-log.md` Bursts 13-22 |

**cycle-004 note (historical, all bursts):** F1 APPROVED (DEC-335); F2 scoped adversarial convergence APPROVED (DEC-336); F3 story decomposition APPROVED (DEC-337); F4 COMPLETE (DEC-339); F5 CONVERGED (DEC-340); F6 COMPLETE (DEC-341); F7 CONVERGED (DEC-342); RELEASED + CLOSED (DEC-343). Full burst-by-burst decision detail: `cycles/cycle-004/burst-log.md` Bursts 1-22.

**cycle-005 note (Bursts 1-4):** **DEC-344** (F1 APPROVED, Burst 1); **DEC-345**/**DEC-346** (F2-gate TIGHTENING + APPROVED, Burst 2, condensed); **DEC-347** (F3 APPROVED, Burst 3, condensed). No new gate decision this burst — Burst 4 is a **SESSION WRAP pause**, not a phase gate. cycle-005 (`adf-mentions`, #674) is OPEN, Phase F4 (delta implementation) IN PROGRESS — Wave 1 (Story A) convergence COMPLETE, PR #778 OPEN; pipeline **PAUSED** 2026-09-07 for session wrap.

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
| DTU creation (cycle-005) | yes | `dtu_required: false` -- the feature targets Jira's own REST API user-search/mention surface (already-covered endpoints), not a cloned third-party service. |
| UX Spec (cycle-005) | yes | `jr` is CLI-only; F1/F2 both confirmed no new UI surface — `adf-mentions` is a write-path conversion feature only. |

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/<cycle>/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|

**No open blocking issues.**

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): historical, unchanged this burst.

`cycle-002` (`field-dx`) F2-F7 COMPLETE, human-authorized at the F7 gate (DEC-311). **RELEASED 2026-09-01 as `v0.7.0-dev.3`.** Historical, unchanged this burst.

`cycle-003` (`auth-profile-dx`) F1-F7 all COMPLETE, human-approved at every gate. **RELEASED 2026-09-03 as `v0.7.0-dev.4`** (DEC-333). **cycle-003 is CLOSED** — SHIPPED, historical, unchanged this burst.

`cycle-004` (`windows-correctness`) F1-F7 COMPLETE, human-authorized at every gate (DEC-335 through DEC-343). **RELEASED 2026-09-06 as `v0.7.0-dev.5`**; **CLOSED** — SHIPPED, historical. Full detail: `cycles/cycle-004/burst-log.md` Bursts 1-22.

`cycle-005` (`adf-mentions`) Phase **F1 APPROVED** (DEC-344); Phase **F2 APPROVED** (DEC-345 tightening + DEC-346 approval); Phase **F3 APPROVED** (DEC-347); Phase **F4 (delta implementation) IN PROGRESS** — Wave 1 (`S-cycle5-mention-pure-conversion`) per-story adversarial convergence **COMPLETE** (3 clean passes), PR #778 **OPEN** awaiting CI + human merge approval; Wave 2 (`S-cycle5-mention-resolution-wiring`) blocked-on-wave-1. **Pipeline PAUSED 2026-09-07** for a session wrap. Full detail: `cycles/cycle-005/phase-f3-stories/` + `.factory/sprint-state.yaml` `cycle_005_adf_mentions` + `cycles/cycle-005/burst-log.md` Bursts 1-4.

**cycle-005 is the sole OPEN cycle** (Phase F4 in progress, **PAUSED** for session wrap); cycle-001 through cycle-004 remain CLOSED, historical, unaltered this burst.

## Concurrent Cycles

Five tracked cycles. `cycle-001` is CLOSED, historical. `cycle-002` (`field-dx`) is **CLOSED + RELEASED** (2026-09-01), historical. `cycle-003` (`auth-profile-dx`) is **CLOSED + RELEASED** (2026-09-03, DEC-333) as **`v0.7.0-dev.4`** @ `42e92b46`, historical. `cycle-004` (`windows-correctness`) is **CLOSED + RELEASED** (2026-09-06, DEC-343) as **`v0.7.0-dev.5`** @ `569d85a8`, historical — F1-F7 all APPROVED/CONVERGED (DEC-335 through DEC-343); full detail `cycles/cycle-004/burst-log.md`. `cycle-005` (`adf-mentions`, GitHub #674) is **OPEN** — Phase F1 **APPROVED** (DEC-344), Phase F2 **APPROVED** (DEC-345/DEC-346), Phase F3 (incremental story decomposition) **APPROVED** (DEC-347), Phase F4 (delta implementation) **IN PROGRESS** — Wave 1 (`S-cycle5-mention-pure-conversion`, convergence **COMPLETE**, PR #778 **OPEN**) → Wave 2 (`S-cycle5-mention-resolution-wiring`, blocked-on-wave-1), tracked in `.factory/sprint-state.yaml`'s `cycle_005_adf_mentions` section. `develop` @ `569d85a8` (`activation_head`, unchanged this burst — PR #778 not yet merged). The standing auto-merge policy (DEC-330/DEC-331, fully autonomous when CI green + reviewer merge-recommendation + all HIGH/MED findings addressed) and the `gh pr merge`/push MAIN-session-only constraint both remain in effect for cycle-005's future story/fix PRs. **Pipeline is PAUSED** (2026-09-07, session wrap; cycle-005 remains open). **Next:** PR #778's CI must finish (Mutation testing was PENDING at wrap; other 13/14 green) → merge PR #778 (main-session-only, `gh pr merge 778 --squash --admin`, human-approved like #776/#777) → Wave-1 integration gate → dispatch Story B (Wave 2, `S-cycle5-mention-resolution-wiring`).

## Constraints Carried Forward

**cycle-005 (F4 Wave 1 Story A implemented, PR #778 open, Burst 4 SESSION WRAP, this burst):** Phase F4 Wave 1 (`S-cycle5-mention-pure-conversion`) was dispatched and delivered via the standard per-story-delivery TDD pipeline since Burst 3: the AC-007 `\@`-escape spike came back **FEASIBLE** (implemented via ADR-0023 §4's sentinel scheme); a further F4 implementation discovery — CommonMark destroys characters inside a bracket-form `[~accountid:<id>]` id before any post-`finish()` tree-walk runs — was closed via a new `protect_bracket_mentions` pre-parse mechanism, documented in a new ADR-0023 §4a addendum and a corresponding `phase-f2-spec-evolution/architecture-delta.md` §4.1a addendum (both committed this burst — they were the two outstanding uncommitted cycle-005 F4 artifacts at wrap time); `MentionResolutions` gained a public inserter API for Story B's later use. Story A reached per-story adversarial convergence over 3 clean passes (passes 3-5, all 0-CRIT/HIGH/MED). PR #778 opened (branch `feat/cycle5-mention-pure-conversion` @ `89b84a1f`, worktree still mounted at `.worktrees/cycle5-mention-pure-conversion`): pr-reviewer **APPROVE** (1 IMPORTANT doc finding fixed in the PR body), security-reviewer **CLEAN** (1 non-blocking LOW deferred to Story B); CI 13/14 checks green with "Mutation testing" **PENDING** at the moment of this wrap. No sub-agent work was abandoned mid-step — an implementer that looped on a background test was recovered, its pre-PR fixes committed as `89b84a1f`. The human then requested a session wrap before PR #778's CI finished or it was merged. This burst pauses the pipeline (`pipeline: ACTIVE`→`PAUSED`) and commits the two outstanding spec artifacts above; PR #778 itself, its CI, and its merge are unaffected by this burst (state-manager scope is bookkeeping only). Full detail: `cycles/cycle-005/burst-log.md` Burst 4.

**cycle-005 (F3 APPROVED + input-hash refresh + F4 wave tracking, Burst 3, condensed this burst):** Phase F3 story decomposition human-**APPROVED** (**DEC-347**) — 2 stories, acyclic A→B dependency, 26-point critical path, story count 172→174; deferred input-hash drift refreshed on 3 F3 artifacts; both stories registered in `.factory/sprint-state.yaml`'s F4 wave-tracking convention; both count-verification scripts re-verified (exit 0). Phase advanced F3→F4. Full text: `cycles/cycle-005/burst-log.md` Burst 3.

**cycle-005 (F2 APPROVED + F2-CLOSE INTEGRATE, Burst 2, historical this burst):** Phase F2 spec evolution human-**APPROVED** (**DEC-346**) with one F2-gate **TIGHTENING** decision (**DEC-345**) folded in; a 6-item F2-close INTEGRATE reconciliation sweep across cross-reference documents (`spec-changelog.md`, `CANONICAL-COUNTS.md` ADR-count, `adr-index.md`, `system-overview.md`, `specs/prd/README.md`, 2 F2 delta-file status flips) was completed and all 3 count-verification scripts re-verified (exit 0). Counts advanced 742→754 BCs / 55→76 VPs / 106→118 holdouts. Two process-gaps logged (`ADR-COUNT-CANONICAL-GUARD-GAP`, `FACTORY-HOOK-FUEL-EXHAUSTED`, both carried forward below). Full detail: `cycles/cycle-005/burst-log.md` Burst 2.

**cycle-005 (F1 APPROVED, Burst 1, historical this burst):** New feature-mode cycle opened: `adf-mentions` (GitHub #674), brownfield, `dtu_required: false`. F1 delta analysis reconciled a duplicate `artifact-mapping.md` run; human **APPROVED** the F1 scope. **Tracked follow-up (unchanged):** `VP-COUNT-RECONCILIATION`, non-blocking, target a future maintenance/self-improvement cycle.

**cycle-004 (RELEASE + CLOSE, historical):** Human authorized and executed the cycle-004 dev release (DEC-343): PR #777 squash-merged (`135eb804`→`569d85a8`), tag `v0.7.0-dev.5` pushed, `release.yml` run `34046676423` SUCCESS, GitHub prerelease published with 10 assets/5 targets. **cycle-004 is CLOSED.** F7 Windows-verification gate satisfied via `windows-latest` CI (PR #776, DEC-342, superseding a physical smoke test per human authorization). All prior outstanding non-blocking items carried forward verbatim (see "cycle-004 maintenance items" below); none block cycle-005; deferred to a future maintenance/self-improvement cycle.

**cycle-004 (earlier F1-F7 detail, historical):** F1 APPROVED (DEC-335); F2 scoped adversarial convergence, 25 passes across two attempts, HUMAN GATE APPROVED (DEC-336); F3 story decomposition CONVERGED + APPROVED (DEC-337); F4 Waves 1-2 delivered/merged (PRs #768-#772), COMPLETE (DEC-339); F5 CONVERGED (DEC-340, PR #773/#774); F6 COMPLETE (DEC-341, PR #775). Full detail: `cycles/cycle-004/burst-log.md` Bursts 1-22.

**cycle-003 (RELEASE + CLOSE, historical):** Human authorized and executed the cycle-003 dev release (DEC-333): PR #767 squash-merged (`c9bb74f4` → `42e92b46`), tag `v0.7.0-dev.4` pushed, `release.yml` run `33769389700` SUCCESS, GitHub prerelease published with 10 assets/5 targets. **cycle-003 is CLOSED.** Both S-7.02 process-gap deferral candidates codified in `cycles/cycle-003/lessons.md`. All prior outstanding, non-blocking items carried forward verbatim (MED-1 VP count unverified, LOW-4/LOW-6 doc nits, 4-story template-compliance gap, 6-file input-hash cascade) — none block cycle-004/cycle-005; deferred to a future maintenance/self-improvement cycle.

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
- **JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION** (Burst 21) — `src/cache.rs`, `src/config.rs`, and `src/api/auth_windows_store.rs` each carry a SEPARATE `ENV_MUTEX`/`CACHE_DIR_SEAM_MUTEX` guarding the SAME process-global `JR_CACHE_DIR` env var; they do not mutually exclude and `cargo test` runs multithreaded. Safe failure mode (a race yields a visible test failure, never a false pass). Unify into one shared crate-test env mutex. Target: a future SELF-IMPROVEMENT/maintenance cycle.
- **PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP** (Burst 21) — the vsdd-factory `pr-manager-completion-guard` hook (`plugins/vsdd-factory/hooks/dispatcher`) has no cross-turn memory; it parses only the current turn for `STEP_COMPLETE:` and loops after genuine 9-step completion. This is a FACTORY-ENGINE tooling bug (vsdd-factory plugin), NOT a jira-cli product defect. Target: vsdd-factory engine fix.
- **CYCLE-004-INPUT-HASH-HYGIENE** (Burst 19, RESOLVED @ `a038ac0d`) — the 9 cycle-004 F1-F3 delta artifacts flagged with a stale `input-hash` at the F7 pre-gate drift check have been recomputed (pure-recompute, no content change). Detail: `phase-f7-convergence/cycle-004/input-hash-drift.md`.
- **TD-031-BLOCKED-BC-6.2.016-CROSSREF** — deferred `bc-6-config-cache.md` cross-reference blocked by a pre-existing TD-031 hook violation, unrelated to cycle-004/005.
- **BC-1.4.035-PC5-VP-GAP** — production round-trip now CI-verified (VP-AUTHDX-010(b)); formal VP itself still deferred to maintenance.
- **S-410-KEYCHAIN-ISOLATION-FILE-OVERLAP** — shares `tests/oauth_refresh_integration.rs` with cycle-004; non-blocking.
- **W2-INT-PROCESS-GAP-README-PROSE-DRIFT** (Burst 17) — no CI guard cross-checks README prose against the code model. Target: a future maintenance cycle.

**PROCESS-GAP (Pass 14, cycle-004, historical, not a blocker):**
- `scripts/check-bc-cumulative-counts.sh` does not cover a per-file `bc-*.md` "## Summary Stats" closing "Note:" cumulative-prose line. Target: a future SELF-IMPROVEMENT/maintenance cycle.

**PROCESS-GAP (cycle-005 F2-close INTEGRATE, Burst 2, historical this burst):**
- **ADR-COUNT-CANONICAL-GUARD-GAP** — `CANONICAL-COUNTS.md`'s `## ADRs` "Canonical ADR count" line drifted across 4 cycles; no CI guard exists for this surface. Both this and `adr-index.md`'s parallel drift were fixed at Burst 2, but no guard prevents recurrence. Target: a future SELF-IMPROVEMENT/maintenance cycle — add an ADR-count check analogous to the existing BC-count scripts.
- **FACTORY-HOOK-FUEL-EXHAUSTED** — `validate-input-hash`/`validate-template-compliance`/`validate-factory-path-root`/`validate-count-propagation` hooks repeatedly returned `FUEL_EXHAUSTED` on large files during cycle-005 F2 work; edits applied + were grep/script-verified regardless, but hook validation was incomplete. vsdd-factory engine tooling issue, not a jira-cli product defect. Target: engine fix.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- 165 factory-wide stale `input-hash` artifacts confirmed via full scan (cycle-004 F7 pre-gate check, 2026-09-05; standing debt, **not** a cycle blocker). This burst's 3 F3-artifact refreshes (`S-cycle5-mention-resolution-wiring.md`, `dependency-graph-extended.md`, `wave-schedule.md`) were addressed because the orchestrator explicitly named them as this cycle's own deferred drift, not as a draw against this separately-tracked batch debt.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
- `VP-COUNT-RECONCILIATION` (cycle-005 F1, unresolved) — a raw grep found materially more VP ids across `bc-*.md` bodies than STATE's tracked running total; pre-existing bookkeeping-basis discrepancy, non-blocking. This cycle's own VP-674-001..021 additions are correctly and separately counted (see above) and do not resolve the underlying base-count gap. Target: a future maintenance/self-improvement cycle.

## Session Resume Checkpoint

**Date:** 2026-09-07. **Position:** cycle-005 (`adf-mentions`, GitHub #674) Phase F4 (delta implementation) Wave 1 (Story A, `S-cycle5-mention-pure-conversion`). **NEXT:** PR #778's CI must finish (Mutation testing was PENDING at wrap; other 13/14 green) → then merge PR #778 (main-session-only, `gh pr merge 778 --squash --admin`, human-approved like #776/#777) → Wave-1 integration gate → Story B (Wave 2, `S-cycle5-mention-resolution-wiring`).

**Convergence:** Story A per-story adversarial convergence **COMPLETE** — 3 clean passes (passes 3, 4, 5, all 0-CRIT/HIGH/MED); no active convergence loop at pause. Story B not started.

**In-flight work:** Story A PR #778 **OPEN** — 13/14 CI checks green, "Mutation testing" job **PENDING** at wrap time; pr-reviewer **APPROVE** (1 IMPORTANT doc finding fixed in the PR body); security-reviewer **CLEAN** (1 non-blocking LOW deferred to Story B). Story A code committed + pushed: branch `feat/cycle5-mention-pure-conversion` @ `89b84a1f`; worktree still mounted at `.worktrees/cycle5-mention-pure-conversion`. **NOT merged.** No sub-agent work abandoned mid-step (an implementer that looped on a background test was recovered — its pre-PR fixes were committed as `89b84a1f`). Key F4 design facts: the `\@`-escape spike came back **FEASIBLE** (implemented via ADR-0023 §4 sentinel scheme); a real discovery — CommonMark destroys characters inside `[~accountid:X]` pre-parse — was handled by a new `protect_bracket_mentions` pre-parse mechanism, documented in the ADR-0023 §4a addendum (committed this burst); `MentionResolutions` gained a public inserter API for Story B (closes the L-2 flag).

**Pending human decisions/blockers:** (1) approve merge of PR #778 once CI fully green; (2) Wave-1 integration gate after merge; (3) Story B delivery includes the human-required live-Jira E2E mention round-trip tests (`H-NEW-MENTION-009`, controlled test account, self-cleaning). No open blockers.

**WIP branches:** `feat/cycle5-mention-pure-conversion` @ `89b84a1f` (pushed; PR #778 open). No others.

**Resume command:** `/vsdd-factory:rehydrate-wave` then `/vsdd-factory:next-step`.

**Tracked non-blocking follow-ups (unchanged):** `VP-COUNT-RECONCILIATION` (pre-existing, base-count gap unrelated to this cycle's correctly-counted VP-674 additions); `ADR-COUNT-CANONICAL-GUARD-GAP` (Burst 2 — no CI guard for ADR-count drift); `FACTORY-HOOK-FUEL-EXHAUSTED` (Burst 2 — engine tooling issue on large-file hook validation).

**Counts: total_bcs 754; VP count 76 tracked running total; holdout scenarios 118; total_stories 174** (all unchanged this burst — F4 story implementation does not change spec/story counts).

**Superseded checkpoints:** the prior cycle-005 Burst-3 checkpoint (v3.77, 2026-09-06 — F3 APPROVED / F4 dispatched) is superseded in place by this checkpoint and archived to `cycles/cycle-005/session-checkpoints.md` ahead of this Write, with a "Superseded at" note. Earlier archives (cycle-005 v3.75 Burst-1, v3.76 Burst-2; cycle-004 v3.53-v3.74, cycle-003 v3.31-v3.52, cycle-002 v3.23-v3.29 and earlier, cycle-001 v3.05) remain at their respective `cycles/<cycle>/session-checkpoints.md` files, unchanged this burst.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-14 = F2/F3/F4; 15 = F5 CONVERGED + FIX-F5-001; 16 = F6 COMPLETE + FIX-F6-001; 17 = F7 delta-convergence PASS + FIX-F7-001; 18 = F7 human gate APPROVED + cycle-002 CLOSED; 19 = release v0.7.0-dev.3 SHIPPED; 20 = SESSION-WRAP) |
| cycle-003 burst history | `cycles/cycle-003/burst-log.md` (Burst 1 = cycle OPENED; Bursts 2-9 = F1 through F3 gates; Bursts 10-15 = F4 Waves 1-5, all 7 stories merged; Burst 16 = F5 findings fixed; Burst 17 = SESSION WRAP, F5 CONVERGED; Burst 18 = SESSION RESUMED, F6 DISPATCHED; Burst 19 = F6 COMPLETE — PASS; Burst 20 = F7 pre-gate consistency audit; Burst 21 = F7 human gate APPROVED — CONVERGED (DEC-332); Burst 22 = RELEASE v0.7.0-dev.4 SHIPPED, cycle-003 CLOSED (DEC-333)) |
| cycle-004 burst history | `cycles/cycle-004/burst-log.md` (Burst 1 = cycle OPENED; Burst 2 = F1 human gate APPROVED (DEC-335); Burst 3 = CRASH RECOVERY; Bursts 4-10 = F2 scoped adversarial convergence, 25 passes across two attempts + 2 consistency audits; Burst 11 = F2 HUMAN GATE APPROVED (DEC-336); Burst 12 = F3 story decomposition CONVERGED; Burst 13 = SESSION WRAP (F3 gate pending); Burst 14 = F3 HUMAN GATE APPROVED (DEC-337), phase F3→F4; Burst 15 = F4 Wave 1 DELIVERED + MERGED, integration gate PASSED (DEC-338), F4 CI spike SUCCEEDED; Burst 16 = F4 Wave 2 PARTIALLY DELIVERED + SESSION WRAP; Burst 17 = PR #771 merged, Wave 2 gate PASSED, F4 COMPLETE (DEC-339), phase F4→F5; Burst 18 = F5 scoped adversarial review CONVERGED (DEC-340) via PR #773/#774, phase F5→F6; Burst 19 = F6 targeted hardening COMPLETE (DEC-341) via PR #775, phase F6→F7; Burst 20 = F7 automated prep COMPLETE (commit `a038ac0d`) then SESSION WRAP — pipeline PAUSED at the F7 final human gate; Burst 21 = REQUIRED Windows-11 DPAPI verification SATISFIED VIA CI (PR #776 @ `135eb804`) and F7 human gate PASSED — CONVERGED (DEC-342); Burst 22 = **RELEASE v0.7.0-dev.5 SHIPPED** (PR #777 @ `569d85a8`, tag `v0.7.0-dev.5`, `release.yml` run `34046676423` SUCCESS), **cycle-004 CLOSED (DEC-343)**) |
| cycle-005 burst history | `cycles/cycle-005/burst-log.md` (Burst 1 = cycle OPENED, F1 delta analysis dispatched, duplicate artifact reconciled, F1 human gate APPROVED (DEC-344), phase F1→F2; Burst 2 = F2 spec evolution APPROVED (DEC-346) with F2-gate TIGHTENING decision (DEC-345), 6-item F2-close INTEGRATE reconciliation sweep, count scripts re-verified, phase F2→F3; Burst 3 = F3 story decomposition APPROVED (DEC-347), deferred input-hash drift refreshed on 3 F3 artifacts, F4 wave tracking registered in `.factory/sprint-state.yaml`, count scripts re-verified, phase F3→F4; Burst 4 = F4 Wave 1 (Story A) implemented + per-story adversarial convergence COMPLETE (3 clean passes) + PR #778 opened (pr-reviewer APPROVE, security-reviewer CLEAN, CI 13/14 green) + SESSION WRAP — pipeline PAUSED awaiting PR #778 CI + merge) |
| cycle-005 F1 delta-analysis artifacts | `phase-f1-delta-analysis/cycle-005/delta-analysis.md` + `affected-files.txt` + `artifact-mapping.md` (canonical, includes the "Alternative decomposition (F2 input)" note) |
| cycle-005 F2 spec-evolution artifacts | `phase-f2-spec-evolution/prd-delta-674.md`, `verification-delta-674.md`, `architecture-delta.md` (`status: complete`; §4.1a bracket-form pre-parse-protection addendum added Burst 4); `specs/architecture/decisions/ADR-0023-markdown-mention-pure-effectful-conversion-seam.md` (§4a addendum added Burst 4) |
| cycle-005 F3 story-decomposition artifacts | `cycles/cycle-005/phase-f3-stories/{S-cycle5-mention-pure-conversion.md, S-cycle5-mention-resolution-wiring.md, dependency-graph-extended.md, wave-schedule.md}` (all `input-hash` clean as of Burst 3) |
| cycle-005 F4 wave tracking | `.factory/sprint-state.yaml` `cycle_005_adf_mentions:` section (Wave 1 `ready`, Wave 2 `blocked`) |
| cycle-005 F4 Wave-1 (Story A) delivery evidence | GitHub PR #778 (branch `feat/cycle5-mention-pure-conversion` @ `89b84a1f`); worktree `.worktrees/cycle5-mention-pure-conversion` (still mounted, not yet merged) |
| cycle-005 session checkpoints | `cycles/cycle-005/session-checkpoints.md` (v3.75 Burst-1, v3.76 Burst-2, and v3.77 Burst-3 checkpoints archived, each with a "Superseded at" note) |
| cycle-004 F1 delta-analysis artifacts | `cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md` + `affected-files.txt` |
| cycle-004 F2 spec-evolution artifacts | `cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md`; `vp-delta.md`; `specs/architecture/decisions/ADR-0021-*.md`; `specs/architecture/decisions/ADR-0022-*.md` |
| cycle-004 F3 story-decomposition artifacts | `cycles/cycle-004/phase-f3-stories/` — `decomposition-manifest.md`, `S-cycle4-{dpapi-storage-fix,cloud-id-correctness,honest-fail-message,windows-docs}.md`, `dependency-graph-extended.md`, `wave-schedule.md`, `conflict-report.md`, `wave-holdout-scenarios/` |
| cycle-004 F4-F7 delivery + release evidence | `code-delivery/S-cycle4-*/`, `code-delivery/FIX-*`, `phase-f5-adversarial/cycle-004/`, `phase-f6-hardening/cycle-004/`, `phase-f7-convergence/cycle-004/`; GitHub PR #776 + #777; tag `v0.7.0-dev.5`; `release.yml` run `34046676423` |
| cycle-004 research | `research/atlassian-3lo-revoke-granularity-2026-09-05.md`, `research/edge-tenant-info-cloudid-2026-09-03.md` |
| cycle-004 session checkpoints | `cycles/cycle-004/session-checkpoints.md` (archives v3.53 through v3.74) |
| cycle-003 grounding + phase artifacts | `cycles/cycle-003/investigation/`, `cycles/cycle-003/phase-f1-delta-analysis/`, `phase-f2-spec-evolution/`, `phase-f3-stories/`, `phase-f4-implementation/`, `phase-f6-hardening/`, `phase-f7-convergence/` |
| cycle-003 release + F4/F5 delivery evidence | version-bump PR #767 (`develop` @ `42e92b46`); tag `v0.7.0-dev.4`; `release.yml` run `33769389700`; `code-delivery/FIX-F7-DOCS-1/`, `code-delivery/S-cycle3-*/`, `code-delivery/FIX-F5-*/` |
| cycle-002/cycle-001 historical artifacts | `cycles/cycle-002/`, `cycles/cycle-001/` (see per-cycle files) |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**cycle-005 (F4 Wave 1 Story A implemented, PR #778 open, Burst 4 SESSION WRAP, this burst):** Story A per-story adversarial convergence COMPLETE (3 clean passes); PR #778 OPEN awaiting CI + merge. Committed the two outstanding F4 spec artifacts (ADR-0023 §4a addendum + `architecture-delta.md` §4.1a addendum) documenting the bracket-form pre-parse-protection discovery. Pipeline **PAUSED** for session wrap — see `Constraints Carried Forward` above for full detail. No new tracked follow-ups this burst.

**cycle-005 (F3 APPROVED + input-hash refresh + F4 wave tracking, Burst 3, condensed this burst):** DEC-347 (F3 approval) recorded; phase advanced F3→F4. Full text: `cycles/cycle-005/burst-log.md` Burst 3.

**cycle-005 (F2 APPROVED + F2-CLOSE INTEGRATE, Burst 2, historical this burst):** DEC-345 (tightening) + DEC-346 (approval) recorded. Phase advanced F2→F3. **Tracked follow-ups:** `ADR-COUNT-CANONICAL-GUARD-GAP`, `FACTORY-HOOK-FUEL-EXHAUSTED` — both non-blocking, target future engine/maintenance work.

**cycle-005 (F1 APPROVED, DEC-344, Burst 1, historical this burst):** cycle-005 (`adf-mentions`, #674) OPENED. F1 delta analysis reconciled a duplicate artifact-mapping.md run; human **APPROVED** the F1 scope. **Tracked follow-up (unchanged):** `VP-COUNT-RECONCILIATION`, non-blocking, target a future maintenance/self-improvement cycle.

**cycle-004 (RELEASE + CLOSE, historical):** DEC-343: PR #777 squash-merged (`135eb804`→`569d85a8`), tag `v0.7.0-dev.5` pushed, `release.yml` SUCCESS, GitHub prerelease published. **cycle-004 is CLOSED.** F7 Windows-verification gate satisfied via CI (PR #776, DEC-342). All prior outstanding non-blocking items carried forward verbatim — see "cycle-004 maintenance items" under `Constraints Carried Forward` above; none block cycle-005.

**cycle-004 (earlier F1-F7 detail, historical):** F1 APPROVED (DEC-335); F2 25-pass scoped adversarial convergence APPROVED (DEC-336); F3 story decomposition APPROVED (DEC-337); F4 Waves 1-2 COMPLETE (DEC-339, PRs #768-#772); F5 CONVERGED (DEC-340, PR #773/#774); F6 COMPLETE (DEC-341, PR #775); F7 CONVERGED (DEC-342, PR #776). Full detail: `cycles/cycle-004/burst-log.md` Bursts 1-22.

**cycle-003 (RELEASE + CLOSE, historical):** DEC-333: PR #767 squash-merged, tag `v0.7.0-dev.4` pushed, `release.yml` SUCCESS, GitHub prerelease published. **cycle-003 is CLOSED.** Both S-7.02 process-gap deferrals codified in `cycles/cycle-003/lessons.md`. All prior outstanding items (MED-1, LOW-4/LOW-6, template-compliance gap, input-hash cascade) deferred to a future maintenance cycle.

**cycle-003 (earlier F4/F3/F2 resolutions, historical):** F1 (BYO-OAuth-cred over-delete) and ADR-0011 doc-drift CLOSED (Burst 15). ADR-0011-staged-not-applied CLOSED (Burst 14, `S-cycle3-adr0011-newtype` PR #758). DEC-NAMESPACE-COLLISION-RISK clean (max ID DEC-347, no collision).

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

**cycle-004 maintenance items (carried forward, not blockers):** see `Constraints Carried Forward` above for the full itemized list (`F6-MUTATION-EXAMINE-GLOBS-EXPANSION`, `JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION`, `PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP`, `CYCLE-004-INPUT-HASH-HYGIENE` resolved, `TD-031-BLOCKED-BC-6.2.016-CROSSREF`, `BC-1.4.035-PC5-VP-GAP`, `S-410-KEYCHAIN-ISOLATION-FILE-OVERLAP`, `W2-INT-PROCESS-GAP-README-PROSE-DRIFT`).

**PROCESS-GAP (Pass 14, cycle-004, historical, not a blocker):**
- `scripts/check-bc-cumulative-counts.sh` does not cover a per-file `bc-*.md` "## Summary Stats" closing "Note:" cumulative-prose line. Target a future maintenance cycle.

**PROCESS-GAP (cycle-005 F2-close INTEGRATE, Burst 2, historical this burst):** see `Constraints Carried Forward` above for `ADR-COUNT-CANONICAL-GUARD-GAP` and `FACTORY-HOOK-FUEL-EXHAUSTED` full detail.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- 165 historical stale `input-hash` artifacts factory-wide (confirmed cycle-004 F7); standing debt, **not** a cycle blocker. This burst's 3 F3-artifact refreshes were addressed as this cycle's own deferred drift, not a draw against the batch-tracked debt.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
- `VP-COUNT-RECONCILIATION` (cycle-005 F1, unresolved) — pre-existing base-count discrepancy, unrelated to this cycle's own correctly-counted VP-674 additions; non-blocking, target a future maintenance/self-improvement cycle.
