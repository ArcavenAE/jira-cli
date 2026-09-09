---
document_type: pipeline-state
level: ops
version: "3.90"
status: active
producer: state-manager
timestamp: 2026-09-09T14:47:29Z
phase: "cycle-006 (mutants-ci-sharding) Phase F4 (delta implementation) COMPLETE + MERGED -- PR #791 (story S-cycle6-mutants-ci-sharding) human-APPROVED at the merge gate and squash-merged into develop, merge commit a9168212 ('ci(mutants): shard mutation-testing CI gate -- 8-way matrix + pooled aggregate (cycle-006) (#791)'), merged 2026-09-09T14:15:13Z; develop advanced 569d85a8->a9168212. All 24 CI checks passed, including the required CI Gate and -- for the first time in production -- the full NEW sharded pipeline itself: Mutation Test Plan, Mutation Testing (Shard) 0-7 (all 8), Mutation Testing (Aggregate). pr-reviewer APPROVE; security-reviewer near-clean (1 LOW + 1 INFO, non-blocking, tracked). Post-merge cleanup done (devops-engineer): remote branch ci/mutants-ci-sharding deleted, local worktree .worktrees/mutants-ci-sharding removed, local branch deleted, stale refs pruned (cycle-005 worktree/branch untouched). Step-4.5 per-story adversarial convergence (recorded v3.89) stands unmodified -- 3-consecutive-clean via 7 trios / 21 fresh passes / 6 fix rounds; F-PI-CRITICAL-001/F-PF-HIGH-001/F-PG-MED-001 remain RESOLVED in cycles/cycle-006/blocking-issues-resolved.md; Blocking Issues table stays EMPTY. Session-tooling note (not a code/gate defect): the github-ops gh-delegation layer hung in-session during merge execution (2 pr-manager attempts stalled on delegated gh calls, incl. a non-terminating 'gh pr checks --watch'); the orchestrator verified PR state green/mergeable via direct read-only gh before the human merged directly via the GitHub UI -- tracked as the new GITHUB-OPS-WATCH-HANG follow-up item. NEXT: cycle-006 Phase F5 (scoped adversarial refinement) -> F6 (targeted hardening) -> F7 (delta convergence) -- F5/F6 expected light since Step-4.5's 21-pass adversarial + security + reconciliation + guard-completeness convergence already front-loaded most of that surface (delta touches no src/, so scoped mutation/fuzz hardening is ~0-mutant / N/A); F7 remains the substantive remaining gate. cycle-005 PR #778 is now UNBLOCKED (cycle-006's sharded gate + >120 escape hatch is live on develop) -- its >120-mutant escalation decision (split-below-120 vs admin-bypass) remains pending at cycle-005 resume, not resumed this burst."
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
last_amended: "2026-09-09, v3.90, state-manager -- recorded cycle-006 Phase F4 delivery COMPLETE + MERGED: PR #791 (story S-cycle6-mutants-ci-sharding) squash-merged to develop @ a9168212 (569d85a8->a9168212, 2026-09-09T14:15:13Z); all 24 CI checks passed incl. the sharded mutation-testing gate's first live production run; pr-reviewer APPROVE, security-reviewer near-clean; post-merge cleanup done; Step-4.5 convergence (v3.89) stands unmodified, Blocking Issues table remains EMPTY; recorded GITHUB-OPS-WATCH-HANG as a new session-tooling follow-up item (not actioned); counts unchanged, no DEC minted (delivery/merge is not itself a gate decision -- the F4->F5 and eventual cycle-close gate decisions come later)."
current_step: "D-chain cite D-053 latest brownfield. BURST-12-F4-MERGED-2026-09-09: state-manager recorded that PR #791 (story S-cycle6-mutants-ci-sharding) was human-approved and squash-merged to develop @ a9168212 (569d85a8->a9168212, 2026-09-09T14:15:13Z); all 24 CI checks passed incl. the sharded mutation gate's first live production run; pr-reviewer APPROVE, security-reviewer near-clean (1 LOW+1 INFO); post-merge cleanup done (branch/worktree removed, refs pruned); recorded the github-ops gh-delegation-hang session-tooling observation as GITHUB-OPS-WATCH-HANG (not actioned); archived the v3.89 Session Resume Checkpoint; appended Burst 12 to cycles/cycle-006/burst-log.md; committed this checkpoint in one atomic commit; trajectory-tail unchanged →1→3→0→2"
trajectory_tail: "→1→3→0→2"
maintenance_run:
  status: COMPLETE
  date: 2026-08-25
  findings_count: 10
  fixes_applied: 6
  fixes_pending: 4
  pr: 737
current_cycle: "cycle-006"
feature_mode_bundle: mutants-ci-sharding
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: SOH-ATTACHMENTS-1 F5 SCOPED ADVERSARIAL CONVERGED 2026-07-24 STRICT (14 rounds; window pass-12/pass-13/pass-14 CLEANx3; spec v1.3.99 to v1.3.106; BC-INDEX v6.38 to v6.44; develop @ db207b81) + F7 DELTA CONVERGENCE APPROVED 2026-07-25 (DEC-186; 5-dim PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED) + CYCLE FULLY CLOSED 2026-07-25
cycle_001_status: "list-read-ergonomics -- CLOSED (DEC-309), historical; see cycles/cycle-001/"
cycle_002_status: "field-dx -- CLOSED + RELEASED 2026-09-01 (DEC-311 close; v0.7.0-dev.3 tagged @ 87f17aff, release.yml run 33459579699 triggered). All 5 stories delivered/merged (F4); F5 CONVERGED (FIX-F5-001, PR #747); F6 COMPLETE (FIX-F6-001, PR #749); F7 COMPLETE (5-dim convergence PASS + full regression PASS 4660/0/106, FIX-F7-001, PR #750 @ 2000c455); RELEASED (version bump PR #751 @ 87f17aff, tag v0.7.0-dev.3 pushed, release.yml triggered). Pipeline SHIPPED."
cycle_003_status: "auth-profile-dx -- CLOSED + RELEASED 2026-09-03 (v0.7.0-dev.4 @ 42e92b46, PR #767; release.yml run 33769389700 SUCCESS; GitHub prerelease published, 10 assets/5 targets). F1-F7 complete + released. Pipeline shipped."
cycle_004_status: "windows-correctness -- CLOSED + RELEASED 2026-09-06 (DEC-343; v0.7.0-dev.5 @ 569d85a8, PR #777; release.yml run 34046676423 SUCCESS; GitHub prerelease published, 10 assets/5 targets). F1-F7 complete + released. Pipeline shipped."
cycle_005_status: "adf-mentions -- OPEN; UNBLOCKED as of 2026-09-09 -- cycle-006's sharded mutation-testing CI gate + >120-mutant escape hatch landed on develop @ a9168212 this burst (PR #791). Phase F1 delta analysis APPROVED (DEC-344); Phase F2 spec evolution APPROVED (DEC-345 tightening + DEC-346 approval); Phase F3 story decomposition APPROVED (DEC-347); Phase F4 (delta implementation) IN PROGRESS -- Wave 1 (S-cycle5-mention-pure-conversion) implemented, per-story adversarial convergence COMPLETE (3 clean passes), PR #778 OPEN -- may now rebase onto the new develop and re-run CI under the sharded gate; the >120-mutant escalation decision (split-below-120 vs admin-bypass) remains pending at cycle-005 resume, NOT actioned this burst (this burst's focus was cycle-006 bookkeeping only). Wave 2 (S-cycle5-mention-resolution-wiring) blocked-on-wave-1. See phase-f1-delta-analysis/cycle-005/ + phase-f2-spec-evolution/{prd,verification,architecture}-delta-674.md + cycles/cycle-005/phase-f3-stories/ + .factory/sprint-state.yaml cycle_005_adf_mentions + cycles/cycle-005/burst-log.md Bursts 1-4."
cycle_006_status: "mutants-ci-sharding -- OPEN, Phase F1 delta analysis APPROVED (DEC-348) 2026-09-07 [unchanged this burst -- see prior revisions for full F1 text]. Phase F2 (spec evolution) reached ADVERSARIAL CONVERGENCE 2026-09-07 (16 adversarial passes, 9 fix rounds, 3 consecutive clean passes 14/15/16) + a PASSED pre-gate consistency audit, and was human-APPROVED at the F2 gate in full (DEC-349, 2026-09-07) [unchanged this burst -- see prior revisions for full F2 text]. Phase F3 (incremental story decomposition): story S-cycle6-mutants-ci-sharding authored 2026-09-07 (39 ACs / 30 VPs / 13 holdouts / 30 tasks) into cycles/cycle-006/phase-f3-stories/; adversarial STORY convergence REACHED 3 consecutive clean passes (32/33/34); pre-gate consistency audit PASSED after fixes; human APPROVED the F3 human gate in full (DEC-350, Burst 8) -- phase advanced F3->F4; the 5 F4 blocking preconditions became BINDING [unchanged this burst -- see prior revisions for full F3 text]. Bursts 9-11 (2026-09-08/09, condensed -- full detail in cycles/cycle-006/session-checkpoints.md v3.86/v3.88/v3.89 archives and cycles/cycle-006/blocking-issues-resolved.md): F4 (delta implementation) was dispatched and driven to CODE COMPLETE on branch ci/mutants-ci-sharding (Burst 9, @ ceeedbf1, 8 commits, pushed, all-green; Preconditions 2/3/5 satisfied). Step-4.5 per-story adversarial convergence ran 2 trios (Burst 9), was corrected after an independently-verified defeat of the round-2 fix reopened F-PF-HIGH-001 and opened F-PI-CRITICAL-001 (CRITICAL, CWE-358) + F-PG-MED-001 (MED) (Burst 10), then ran 5 further trios (rounds 3-7, 15 fresh-context passes) + 6 fix rounds (Burst 11), advancing HEAD ceeedbf1->8f46648f (13 local commits, test/script/doc only, tracked ci.yml byte-for-byte unchanged). Round 4's comprehensive byte-pin closure (a new extract_and_normalize_run_scalar_for_step helper applied to every run-bearing step across all three mutation jobs) resolved all three findings together; round 7 (S/T/U) reached 3-CONSECUTIVE-CLEAN -- Step-4.5 CONVERGED (Burst 11). EXPECTED_GUARD_TEST_COUNT 57->75; EXPECTED_MUTANTS_AGG_FIXTURES 24->25; all green at 8f46648f. Blocking Issues table EMPTY as of Burst 11. **BURST 12 (DELIVERY COMPLETE + MERGED, 2026-09-09, this burst, resume-session continuation):** the branch was pushed to origin and PR #791 opened for S-cycle6-mutants-ci-sharding; pr-reviewer APPROVE, security-reviewer near-clean (1 LOW + 1 INFO non-blocking); all 24 CI checks passed, including the required CI Gate and the new sharded pipeline's first live production run (Mutation Test Plan, Mutation Testing Shard 0-7, Mutation Testing Aggregate). The github-ops gh-delegation layer hung in-session during merge execution (session-tooling observation, not a code/gate defect, tracked as GITHUB-OPS-WATCH-HANG); the orchestrator verified green/mergeable via direct read-only gh, and the human merged PR #791 directly via the GitHub UI: squash-merge commit a9168212, merged 2026-09-09T14:15:13Z, develop advanced 569d85a8->a9168212. Post-merge cleanup done (remote/local branch + worktree removed, refs pruned; cycle-005 untouched). Step-4.5 convergence stands unmodified; all 3 Blocking Issues remain RESOLVED, table stays EMPTY. cycle-006 Phase F4 is now COMPLETE + MERGED to develop. NEXT: Phase F5 (scoped adversarial refinement) -> F6 (targeted hardening) -> F7 (delta convergence); F5/F6 expected light (delta touches no src/, Step-4.5 already front-loaded most of that surface). cycle-005 PR #778 is now UNBLOCKED. No DEC minted this burst (delivery/merge is not itself a gate decision). See phase-f1-delta-analysis/cycle-006/ + phase-f2-spec-evolution/cycle-006/ + cycles/cycle-006/phase-f3-stories/ + Decisions Log DEC-350/DEC-349 + cycles/cycle-006/blocking-issues-resolved.md + cycles/cycle-006/session-checkpoints.md (v3.89 archived this burst) + cycles/cycle-006/burst-log.md Bursts 1-2, 12."
activation_head: "a9168212"
activation_version: "v0.7.0-dev.5"
---

<!-- STATE.md SIZE BUDGET (2026-09-09, cycle-006 Burst 12 -- F4 DELIVERY COMPLETE + MERGED:
     line count refreshed after this burst's Write):
     This burst records that cycle-006 Phase F4 delivery is COMPLETE and MERGED: PR #791
     (story `S-cycle6-mutants-ci-sharding`) was human-APPROVED at the merge gate and
     squash-merged into `develop`, merge commit `a9168212` (2026-09-09T14:15:13Z); `develop`
     advanced `569d85a8`->`a9168212`. All 24 CI checks passed, including the required CI Gate
     and the full NEW sharded mutation-testing pipeline's first live production run
     (Mutation Test Plan, Mutation Testing Shard 0-7, Mutation Testing Aggregate).
     pr-reviewer APPROVE; security-reviewer near-clean (1 LOW + 1 INFO, non-blocking,
     tracked). Post-merge cleanup done (devops-engineer): remote branch, local branch, and
     local worktree removed, stale refs pruned. Step-4.5 per-story adversarial convergence
     (recorded v3.89: 3-consecutive-clean via 7 trios / 21 fresh passes / 6 fix rounds)
     stands unmodified this burst -- `F-PI-CRITICAL-001`/`F-PF-HIGH-001`/`F-PG-MED-001`
     remain RESOLVED; the Blocking Issues table stays EMPTY. One new follow-up item recorded
     (`GITHUB-OPS-WATCH-HANG`, session-tooling, NOT actioned) for a `gh pr checks --watch`
     hang encountered in the github-ops delegation layer during merge execution -- not a
     code or gate defect; the human merged directly via the GitHub UI after the orchestrator
     verified green/mergeable state via direct read-only `gh`.
     `pipeline:` transitions PAUSED -> ACTIVE this burst -- the specific condition that
     required the pause (awaiting the human's merge decision on the assembled cycle-006 PR)
     has been resolved by the human's explicit merge action; this reflects the standing
     "drive F4 autonomously, pause before merge" instruction resuming its autonomous half now
     that the merge gate has passed, not a new orchestration decision made by this
     bookkeeping burst. `activation_head` advances `569d85a8`->`a9168212` (first cycle-006
     landing to `develop`); `activation_version` unchanged (`v0.7.0-dev.5` -- no new release
     tag cut this burst). `version:` 3.89 -> 3.90; all running counts (754 BCs / 76 VPs / 118
     holdouts / 175 stories) are UNCHANGED this burst -- this was a delivery/merge bookkeeping
     event, not spec/story authorship, so no DEC was minted (F4 delivery/merge is not itself
     a gate decision; the F4->F5 and eventual cycle-close gate decisions come later).
     Phase Progress gained one new row (F4-DELIVERY-COMPLETE-MERGED-2026-09-09, COMPLETE);
     the existing F4-DELTA-IMPLEMENTATION row's Status is updated IN PLACE to COMPLETE
     (superseding "IN PROGRESS") rather than duplicated, since it names the same phase this
     burst's new row now closes out.
     Current Phase Steps replaced with a fresh Burst-12 table; Burst 11's table (already a
     pointer note as of that burst) is folded one level further into the same pointer note.
     Blocking Issues table remains EMPTY -- no findings opened or closed this burst; one new
     non-blocking follow-up item (`GITHUB-OPS-WATCH-HANG`) recorded alongside the unchanged
     carried-forward items.
     The v3.89 Session Resume Checkpoint was archived to
     `cycles/cycle-006/session-checkpoints.md` (with a "Superseded at" note) before this
     burst's new v3.90 checkpoint was written; a Burst 12 entry was appended to
     `cycles/cycle-006/burst-log.md`.
     `last_amended` is a full overwrite (BC-5.45.001 write-path discipline), not a
     concatenation of the prior entry.
     This burst's `cycle_006_status`/`Constraints Carried Forward`/`Drift / Standing Items`
     paragraphs CONDENSE Burst 11's now-superseded blow-by-blow round-3-through-7 detail into
     a shorter summary (full detail already preserved verbatim in
     `cycles/cycle-006/blocking-issues-resolved.md` and the `session-checkpoints.md` v3.89
     archive) to make room for this burst's own delivery/merge facts without materially
     growing the file -- the same one-burst-lag compaction rule already applied to prior
     DEC-345/346 and DEC-347 entries in the Decisions Log.
     soft target 200 lines; hard cap 500 lines. 447 lines (wc-l) (this file, this Write) --
     +10 lines vs. v3.89's 437; the Burst-11-detail condensation described above nets against
     this burst's new delivery/merge content, keeping growth modest despite a full new burst
     (Phase Progress row, Current Phase Steps table, Constraints/Drift paragraphs, Session
     Resume Checkpoint) being recorded. margin from soft-target = 447 - 200 = 247 (OVER the
     soft target; documented, ongoing known deviation across cycles-002/003/004/005/006, not
     a blocker). margin from actual = 500 - 447 = 53 (headroom remains before the hard cap).
     RECOVERY CONTEXT: no crash this burst -- a resume-session continuation of an
     already-PAUSED pipeline, recording the verified fact of PR #791's human-approved merge
     to `develop`, as instructed.
     Factory lock: no factory_lock frontmatter block is present in this STATE.md and the
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
| **Last Updated** | trajectory-tail →1→3→0→2; unchanged this burst. Burst 12 (2026-09-09) -- F4 DELIVERY COMPLETE + MERGED: PR #791 (story `S-cycle6-mutants-ci-sharding`) human-APPROVED at the merge gate and squash-merged into `develop` @ `a9168212` (`569d85a8`->`a9168212`, 2026-09-09T14:15:13Z); all 24 CI checks passed incl. the sharded mutation-testing gate's first live production run; Step-4.5 convergence (v3.89) stands unmodified, Blocking Issues table remains EMPTY. `pipeline:` PAUSED -> ACTIVE (merge gate resolved). See Session Resume Checkpoint below for full detail. |
| **Current Phase** | Feature Mode cycle-006 (`mutants-ci-sharding`) -- Phase F1 (delta analysis) **APPROVED** (DEC-348); Phase F2 (spec evolution) **APPROVED at the gate** (DEC-349); Phase F3 (incremental story decomposition) **APPROVED at the gate** (**DEC-350**); Phase **F4 (delta implementation) COMPLETE + MERGED to `develop` @ `a9168212`** (PR #791). **NEXT = Phase F5 (scoped adversarial refinement).** cycle-005 (`adf-mentions`) remains OPEN, now **UNBLOCKED** at Phase F4 (Wave 1, PR #778 OPEN, may rebase onto the new `develop`). cycle-001 through cycle-004 remain CLOSED, historical. |
| **Activation HEAD** | `a9168212` (`develop` tip; advanced this burst -- PR #791 squash-merged, the first cycle-006 landing to `develop`) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, cycles/cycle-003/burst-log.md, cycles/cycle-004/burst-log.md, cycles/cycle-005/burst-log.md, cycles/cycle-006/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **F1-DELTA-ANALYSIS (cycle-006)** | **APPROVED** | 2026-09-07 | Human approved F1 delta analysis: scope, sequencing, escape-hatch inclusion, params (DEC-348) | Feature: `mutants-ci-sharding` -- sharded `cargo-mutants --shard k/n` matrix + `mutants-aggregate` job + escape hatch + advisory scheduled full run. Unblocks cycle-005's PR #778. Full detail: `phase-f1-delta-analysis/cycle-006/` + `cycles/cycle-006/burst-log.md` Burst 1. | counts unchanged (754/76/118/174) |
| **F2-SPEC-EVOLUTION (cycle-006)** | **APPROVED** | 2026-09-07 | 16-pass adversarial convergence + pre-gate consistency audit PASSED + human F2 gate **APPROVED as-is** (**DEC-349**) | Design: `mutants-plan`-> 8-shard `mutants` matrix->`mutants-aggregate`; pooled sum-not-average kill-rate >=90% fail-closed reconciliation; >120-mutant escape hatch; advisory `mutants-nightly.yml`; `cargo-mutants@27`->`@27.1.0` pin. 30 new `VP-MUTANTS-SHARD-001..030`. 5 F4 blocking preconditions now BINDING. Full detail: `phase-f2-spec-evolution/cycle-006/` + Decisions Log DEC-349. | 16 passes, clean x3 (14/15/16); counts unchanged (754/76/118/174) |
| **F3-INCREMENTAL-STORIES (cycle-006)** | **APPROVED** | 2026-09-08 | Adversarial STORY convergence ACHIEVED 3 consecutive clean passes (32/33/34) + PASSED pre-gate consistency audit + human F3 gate **APPROVED as-is** (**DEC-350**) | Story `S-cycle6-mutants-ci-sharding` authored (39 ACs / 30 VPs / 13 holdouts / 30 tasks, Wave 1) into `cycles/cycle-006/phase-f3-stories/`. Phase advanced F3->F4; the 5 F4 blocking preconditions became BINDING. | 174->175 stories; counts otherwise unchanged (754/76/118) |
| **F4-DELTA-IMPLEMENTATION (cycle-006)** | **COMPLETE** | 2026-09-09 | Gated on the 5 F4 blocking preconditions (BINDING per DEC-350); all 5 satisfied; Step-4.5 per-story adversarial convergence reached 3-consecutive-clean (Burst 11); PR #791 human-approved and merged (Burst 12) | Wave 1 (`S-cycle6-mutants-ci-sharding`, 13 pts) implemented on branch `ci/mutants-ci-sharding`, converged via 7 adversarial trios / 21 fresh passes / 6 fix rounds (Bursts 9-11; see the STEP-4.5-CONVERGENCE row below), then delivered via PR #791 and squash-merged to `develop` @ `a9168212` (Burst 12; see the F4-DELIVERY-COMPLETE-MERGED row below). PR #778's >120-mutant escalation decision remains pending at cycle-005 resume. | 754/76/118/175, unchanged (delivery event, no spec/story authorship) |
| **SESSION-WRAP-PAUSE-2026-09-08 (cycle-006, Burst 9)** | **COMPLETE** | 2026-09-08 | state-manager paused the pipeline (ACTIVE->PAUSED) at cycle-006 Phase F4 mid Step-4.5 per-story adversarial convergence | F4 dispatched, driven to CODE COMPLETE on `ci/mutants-ci-sharding` @ `ceeedbf1` (8 commits, pushed, all-green); Preconditions 2/3/5 satisfied. Step-4.5 ran 2 trios + fix rounds, streak reset to 0 after each fix round. Full detail: `cycles/cycle-006/session-checkpoints.md` v3.86 archive ("What actually happened next"). | counts unchanged (754/76/118/175) |
| **SESSION-WRAP-CORRECTION-2026-09-08 (cycle-006, Burst 10)** | **COMPLETE** | 2026-09-08 | state-manager corrected Burst 9's F-PF-HIGH-001 "CLOSED" bookkeeping after independently verifying a newly-reported CRITICAL defeat against the actual code | Verified `F-PI-CRITICAL-001` (CRITICAL, CWE-358) and `F-PG-MED-001` (MED) against the real source; recorded 5 LOW resume-TODOs; preserved (annotated) Burst 9's prompt-injection integrity note. No DEC minted. Full detail: `cycles/cycle-006/session-checkpoints.md` v3.88 archive. | counts unchanged (754/76/118/175) |
| **STEP-4.5-CONVERGENCE-2026-09-09 (cycle-006, Burst 11)** | **COMPLETE** | 2026-09-09 | Step-4.5 per-story adversarial convergence REACHED 3-consecutive-clean (round 7, passes S/T/U, all CLEAN) at frozen feature-branch HEAD `8f46648f` on `ci/mutants-ci-sharding` | 7 adversarial trios (21 fresh-context passes) + 6 fix rounds resolved `F-PI-CRITICAL-001` (CRITICAL, CWE-358), `F-PF-HIGH-001` (HIGH), and `F-PG-MED-001` (MED) together via a round-4 comprehensive byte-pin closure. `EXPECTED_GUARD_TEST_COUNT` 57->75; `EXPECTED_MUTANTS_AGG_FIXTURES` 24->25; all verification green. Full detail: `cycles/cycle-006/blocking-issues-resolved.md` + `cycles/cycle-006/session-checkpoints.md` v3.89 archive. | counts unchanged (754/76/118/175) |
| **F4-DELIVERY-COMPLETE-MERGED-2026-09-09 (cycle-006, Burst 12)** | **COMPLETE** | 2026-09-09 | PR #791 (`S-cycle6-mutants-ci-sharding`) human-APPROVED at the merge gate; pr-reviewer APPROVE, security-reviewer near-clean (1 LOW + 1 INFO non-blocking); all 24 CI checks passed incl. the required CI Gate and the new sharded pipeline's first live production run | Squash-merged into `develop`, commit `a9168212` (2026-09-09T14:15:13Z; `develop` `569d85a8`->`a9168212`). Merge executed directly via the GitHub UI by the human after a github-ops gh-delegation hang during automated merge execution (session-tooling only, tracked as `GITHUB-OPS-WATCH-HANG`, not a code/gate defect); orchestrator pre-verified green/mergeable via direct read-only `gh`. Post-merge cleanup done: remote branch, local branch, and local worktree removed; stale refs pruned. Step-4.5 convergence stands unmodified -- ZERO Blocking Issues remain open. `pipeline:` PAUSED->ACTIVE. **NEXT:** Phase F5 (scoped adversarial refinement). | counts unchanged (754/76/118/175); no DEC minted |

## Current Phase Steps (cycle-006, F4 DELIVERY COMPLETE + MERGED -- Burst 12)

| Step | Status | Notes |
|------|--------|-------|
| Record the verified merge facts for this session (PR #791 human-approved, merge commit SHA, CI results, review verdicts) | **DONE** | Recorded from this session's own resume-task instruction, which described this session's own completed delivery/merge event. |
| Archive prior Session Resume Checkpoint (v3.89) | **DONE** | Archived to `cycles/cycle-006/session-checkpoints.md` with a "Superseded at" note, before this Write. |
| Append Burst 12 narrative to `cycles/cycle-006/burst-log.md` | **DONE** | Full burst entry with Dim-1/2/5/6/7 attestations + Adversary verdict block appended. |
| Confirm Blocking Issues table remains EMPTY; record 1 new follow-up item | **DONE** | No findings opened or closed this burst. `GITHUB-OPS-WATCH-HANG` [process-gap] recorded, NOT actioned, per standing "record, do not action" convention for session-tooling observations. |
| Frontmatter correction | **DONE** | `phase:`/`current_step:`/`last_amended:`/`activation_head:` updated to reflect F4 COMPLETE + MERGED; `version:` 3.89->3.90; `pipeline:` PAUSED->ACTIVE. |
| Write new Session Resume Checkpoint (v3.90) + single atomic commit + push | **DONE** | `factory(cycle-006):` commit on `factory-artifacts`; worktree ends clean. |

(Burst 11's Current Phase Steps -- record verified convergence facts, archive v3.88, move 3 findings to blocking-issues-resolved.md, frontmatter correction, record 5 follow-up items, write v3.89 checkpoint -- folded into this pointer note; see `cycles/cycle-006/session-checkpoints.md` v3.88/v3.89 archives for the full account. Burst 10's Current Phase Steps -- verify the reported CRITICAL/MED findings against the real code, archive v3.87, frontmatter correction, record 2 Blocking Issues + 5 LOW resume-TODOs, preserve+annotate Burst 9's integrity note, write v3.88 checkpoint -- folded into a pointer note; see `cycles/cycle-006/session-checkpoints.md` v3.88 archive. Prior cycle-006 Burst 9 steps -- archive v3.87 checkpoint, frontmatter pause transition, F4 Phase Progress row update, write v3.87 checkpoint, reconcile+commit -- folded into a pointer note; see `cycles/cycle-006/session-checkpoints.md` v3.86 archive (note: v3.87 itself was corrected in place at Burst 10 rather than separately archived -- a pre-existing minor bookkeeping gap from that burst, not corrected retroactively here). Prior cycle-006 Burst 8 steps -- mint DEC-350, record the F3->F4 phase transition, register the 5 F4 blocking preconditions, refresh the Session Resume Checkpoint (v3.85->v3.86), log cycle-closing lessons -- folded into a pointer note; see `cycles/cycle-006/session-checkpoints.md` v3.86 for the archived checkpoint. Prior cycle-006 Bursts 1-7 steps -- cycle opened through F1/F2/F3 gates and input-hash cascade resolution -- archived to `cycles/cycle-006/burst-log.md` Bursts 1-2 and `cycles/cycle-006/session-checkpoints.md` v3.79 through v3.85. Prior cycle-005 burst steps archived to `cycles/cycle-005/burst-log.md`/`session-checkpoints.md`. Prior cycle-004/003/002/001 steps archived to their own `cycles/<cycle>/burst-log.md`.)

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-350 | cycle-006 (`mutants-ci-sharding`) Phase F3 (incremental story decomposition) **HUMAN GATE APPROVED** 2026-09-08. Story `S-cycle6-mutants-ci-sharding` (39 ACs / 30 VPs / 13 holdouts / 30 tasks / 13 pts, Wave 1) reached F3 adversarial STORY convergence (3 consecutive clean passes 32/33/34); fresh-context pre-gate consistency audit PASSED after fixes; count-check scripts exit 0. Human approved as-is. The 5 F4 blocking preconditions are now BINDING. Phase advances F3->F4 | Human reviewed the complete, converged F3 story-decomposition package plus the pre-gate consistency audit and its fixes, and approved proceeding to delta implementation with the story as-is | F3 (gate) | 2026-09-08 | human (explicit approval) |
| DEC-349 | Human **APPROVED** cycle-006 (`mutants-ci-sharding`) Phase F2 (spec evolution) at the gate, in full -- 16-pass adversarial convergence (9 fix rounds, 3 consecutive clean passes 14/15/16), PASSED pre-gate consistency audit, the 5 F4 blocking preconditions, and the documented residuals (including §6.10 mutants-plan/shard-run-line tier -- CLOSED, `F-PI-CRITICAL-001` RESOLVED at Burst 11, before that residual was actually closed). Phase advances F2->F3 | Human reviewed the complete F2 spec-evolution artifact package plus the 16-pass convergence record and the pre-gate consistency audit, and approved proceeding to incremental story decomposition with the design unchanged | F2 (gate) | 2026-09-07 | human (explicit approval) |
| DEC-348 | Human **APPROVED** cycle-006 (`mutants-ci-sharding`) Phase F1 delta analysis in full -- scope (policy-doc-only + 2 new named invariants), sequencing (cycle-006 lands first), escape-hatch inclusion (HIGH-risk flagged for F2), params (8 shards, ~120-mutant threshold, `cargo-mutants@27.1.0`). **HIGH regression risk** flagged on the CI-gate machinery -- **substantially addressed by the F4 delta's byte-pin closure work and NOW LIVE IN PRODUCTION as of PR #791's merge this burst.** Phase advances F1->F2 | Human reviewed the F1 delta-analysis artifacts and the grounding research, and approved proceeding to spec evolution with the captured scope/sequencing/escape-hatch/params decisions | F1 | 2026-09-07 | human (explicit approval) |
| DEC-347 | Human **APPROVED** cycle-005 (`adf-mentions`, GitHub #674) Phase F3 story decomposition in full -- 2 stories (`S-cycle5-mention-pure-conversion` Wave 1, `S-cycle5-mention-resolution-wiring` Wave 2), acyclic A->B dependency, 2 sequential waves, critical path 26 pts. Story count 172->174. Phase advances F3->F4 | Human reviewed the complete F3 decomposition and the adversarial-convergence record and approved proceeding to delta implementation with the captured 2-wave split | F3 | 2026-09-06 | human (explicit approval) |
| DEC-345 / DEC-346 (condensed) | F2-gate **TIGHTENING** (`@Name` single-result `filter_by_name_match` hard-error) plus full F2 **APPROVAL** (12 new BCs, ADR-0023, 21 VPs, 12 holdouts, spec 2.1.0->2.2.0). Phase advanced F2->F3. Full text: `cycles/cycle-005/burst-log.md` Burst 2 | (condensed this burst per the one-burst-lag compaction rule) | F2 (gate) | 2026-09-06 | human (explicit approval, both decisions) |
| DEC-344 | Human APPROVED cycle-005 Phase F1 delta analysis: two mention forms, hard-error `@Name` no-match with `\@` escape + `--no-mentions` opt-out, ambiguous-match handling, wiring incl. JSM, reverse-path update, live-Jira E2E requirement. Phase advanced F1->F2. Full text: `cycles/cycle-005/burst-log.md` Burst 1 | Human reviewed both F1 delta-analysis artifacts and approved proceeding to spec evolution | F1 | 2026-09-06 | human (explicit approval) |
| DEC-343 | Human authorized and executed the cycle-004 dev release **v0.7.0-dev.5** (PR #777 squash-merged to `develop` @ `569d85a8`, tag `v0.7.0-dev.5` pushed, `release.yml` run `34046676423` SUCCESS). cycle-004 (`windows-correctness`) is now **CLOSED** | F7 reached human-authorized CONVERGENCE at DEC-342; the human then explicitly triggered the release action | RELEASE | 2026-09-06 | human (explicit authorization) |
| (349 older cycle-004/003/002/001 decisions) | DEC-342 through DEC-309 and earlier -- unchanged this burst | -- | F1-F7/historical | 2026-08-24...2026-09-06 | various -- see `cycles/cycle-004/burst-log.md` Bursts 1-22 and `cycles/cycle-003/burst-log.md` Bursts 13-22 |

**cycle-006 note (Bursts 1-12):** **DEC-348** (F1 APPROVED, Burst 1). **DEC-349** (F2 gate **APPROVED as-is**, Burst 3). **DEC-350** (F3 gate **APPROVED as-is**, Burst 8) -- phase advanced F3->F4; the 5 F4 blocking preconditions became BINDING. **Bursts 9-11 (2026-09-08/09, condensed; full detail in `cycles/cycle-006/blocking-issues-resolved.md` + `session-checkpoints.md` v3.86/v3.88/v3.89 archives):** F4 dispatched and driven to code complete on `ci/mutants-ci-sharding` (Burst 9, @ `ceeedbf1`); Step-4.5 per-story adversarial convergence corrected after a defeat was independently verified (Burst 10, opening `F-PI-CRITICAL-001` CRITICAL + `F-PG-MED-001` MED, reopening `F-PF-HIGH-001`); then driven through 5 further trios + 6 fix rounds to **3-CONSECUTIVE-CLEAN** (Burst 11, HEAD `ceeedbf1`->`8f46648f`), resolving all 3 findings together via a comprehensive byte-pin closure. No new DEC minted across Bursts 9-11. **Burst 12 (2026-09-09, THIS BURST, resume-session continuation):** the converged branch was pushed, PR #791 opened, pr-reviewer **APPROVE** + security-reviewer near-clean (1 LOW + 1 INFO non-blocking), all 24 CI checks passed incl. the sharded pipeline's first live production run, and the human **APPROVED and MERGED PR #791** directly via the GitHub UI (a github-ops gh-delegation hang during automated merge execution is recorded as a session-tooling observation, `GITHUB-OPS-WATCH-HANG`, not a code/gate defect) -- squash-merge commit **`a9168212`** (`develop` `569d85a8`->`a9168212`), merged 2026-09-09T14:15:13Z. Post-merge cleanup done. **cycle-006 Phase F4 is now COMPLETE + MERGED.** No new DEC minted this burst (delivery/merge is not itself a gate decision). The DEC-namespace check remains clean (max ID DEC-350, no collision). cycle-006 (`mutants-ci-sharding`) is OPEN, Phase F4 **COMPLETE + MERGED** to `develop` @ `a9168212` -- **NEXT = Phase F5 (scoped adversarial refinement)**. Pipeline **ACTIVE** (merge gate resolved; F5/F6 expected light, F7 remains the substantive remaining gate).

**cycle-004 note (historical, all bursts):** F1 APPROVED (DEC-335); F2 scoped adversarial convergence APPROVED (DEC-336); F3 story decomposition APPROVED (DEC-337); F4 COMPLETE (DEC-339); F5 CONVERGED (DEC-340); F6 COMPLETE (DEC-341); F7 CONVERGED (DEC-342); RELEASED + CLOSED (DEC-343). Full burst-by-burst decision detail: `cycles/cycle-004/burst-log.md` Bursts 1-22.

**cycle-005 note (Bursts 1-4, UNBLOCKED as of this burst pending its own resume):** **DEC-344** (F1 APPROVED, Burst 1); **DEC-345**/**DEC-346** (F2-gate TIGHTENING + APPROVED, Burst 2, condensed); **DEC-347** (F3 APPROVED, Burst 3, condensed). No new gate decision recorded for cycle-005 this burst. cycle-005 (`adf-mentions`, #674) is OPEN, Phase F4 (delta implementation) IN PROGRESS -- Wave 1 (Story A) convergence COMPLETE, PR #778 OPEN; **now UNBLOCKED** (cycle-006's sharded gate landed on `develop` this burst), but its own resume (rebase, CI re-run, >120-mutant escalation decision) is **NOT actioned this burst** -- this burst's scope was cycle-006 delivery/merge bookkeeping only.

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
| F6 Kani formal verification (cycle-003) | yes | Not set up in repo; proptest substitution justified -- VP-AUTHDX-001..009 all covered, 0 GAP. |
| F6 cargo-fuzz (cycle-003) | yes | Not set up in repo; proptest arbitrary-input substitution justified, same precedent as cycle-002. |
| UX Spec (cycle-004) | yes | `jr` is CLI-only; F1 delta-analysis explicitly confirmed `feature_type: backend (infrastructure; no UI)` across all 4 stories. |
| Demo recording (cycle-004, all 4 stories) | yes | Human decision this session: demos skipped for all cycle-004 stories (backend/Windows, no UI surface). |
| DTU creation (cycle-004) | yes | `dtu_required: false` -- #759's DPAPI-file fallback targets the OS keychain/filesystem, not a third-party service being cloned. |
| F6 Kani formal verification (cycle-004) | yes | Not set up in repo; proptest/unit substitution justified -- VP-AUTHDX-010..023 (all 14 new cycle-004 VPs) covered, 0 GAP. |
| F6 cargo-fuzz (cycle-004) | yes | Not set up in repo; proptest arbitrary-input substitution justified -- 0 uncovered input surface. |
| F6 DTU adversarial testing / accessibility re-check (cycle-004) | yes | `dtu_required: false`; `tenant_info` is a real endpoint, not a cloned DTU; `feature_type: backend`, no UI surface. |
| REQUIRED manual Windows-11 physical smoke test (cycle-004, Burst 21) | superseded, not skipped | Human explicitly authorized the `windows-latest` CI runner (PR #776) as the verification path instead of a physical machine -- see DEC-342. |
| DTU creation (cycle-005) | yes | `dtu_required: false` -- the feature targets Jira's own REST API user-search/mention surface, not a cloned third-party service. |
| UX Spec (cycle-005) | yes | `jr` is CLI-only; F1/F2 both confirmed no new UI surface -- `adf-mentions` is a write-path conversion feature only. |
| DTU creation (cycle-006) | yes | `dtu_required: no` -- `mutants-ci-sharding` is CI-tooling only; no third-party service is being cloned. |
| UX Spec (cycle-006) | yes | `jr` is CLI-only; `mutants-ci-sharding` is a CI-workflow/policy-doc change with no product UI surface. |

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/<cycle>/blocking-issues-resolved.md. -->

**NONE OPEN.** All 3 findings that were open at the start of cycle-006's Step-4.5 convergence arc (`F-PI-CRITICAL-001` CRITICAL, `F-PF-HIGH-001` HIGH, `F-PG-MED-001` MED) were RESOLVED at Burst 11 (2026-09-08/09) and remain resolved this burst -- see `cycles/cycle-006/blocking-issues-resolved.md`. No new finding was opened or closed this burst (Burst 12); PR #791's own review passes (pr-reviewer APPROVE, security-reviewer near-clean) surfaced nothing blocking. The Blocking Issues table itself is intentionally empty.

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| *(none open)* | | | | | |

**Recorded LOW resume-TODOs from Burst 10 (not blocking; unchanged this burst):**
- `F-PH-LOW-001` -- add a `jq -e 'type=="object"'` shape check after each `jq empty` call in `scripts/mutants-aggregate.sh` / its self-test path.
- `F-PH-LOW-002` [process-gap] -- add a Rust subprocess test that runs `bash scripts/mutants-aggregate.sh --self-test` so the self-test is exercised by `cargo test`, not only invoked manually.
- `F-PH-LOW-003` -- tighten fixture 23's assertion substring to the exact phrase `"is malformed JSON"` (currently a looser match).
- `F-PG-LOW-002` [process-gap] -- `tests/ci_gate_completeness.rs`'s "seven always-run jobs" prose is stale vs. the actual eight `ci-gate.needs` members; enforcement itself is unaffected (derived dynamically), only the prose comment is stale.
- `F-PI-LOW-002` -- now that `F-PI-CRITICAL-001` is fixed (Burst 11), re-correct any remaining place in `docs/specs/cargo-mutants-policy.md`/this file that still characterizes `F-PF-HIGH-001` as closed by the round-2 fix alone rather than by the round-4 comprehensive closure.

**Follow-up items carried from Burst 11 (NOT actioned -- no stories opened, no artifacts written):**
- `[process-gap]` **STALE-RED-NARRATIVE-PATTERN** -- TDD RED-phase doc comments recurrently survive into the GREEN tree. Recurring class -> candidate self-improvement follow-up.
- `[process-gap]` **EXAMINE-GLOBS-SHRINK-RESIDUAL** -- a plaintext `.cargo/mutants.toml` `examine_globs` removal drops a file from mutation scope; the pre-existing coarse floor guard `FLOOR=11` is acknowledged too coarse. Candidate follow-up: tighten floor / named-membership guard.
- `[process-gap]` **BARE-JQ-TOKENIZER-RESIDUAL** -- `contains_bare_jq_invocation` is a hand-rolled tokenizer, not a real parser; documented wrapper-with-flags / general-indirection out-of-scope residual.
- `F-PE-MED-001` (carried from Burst 9, still NOT actioned) -- persist the Precondition-3 M-1 empirical `--list`<=>pooled partition evidence (N=1532) into a durable factory artifact -- **now captured in PR #791's merged body this burst; a standalone durable-artifact capture is still not done.**
- `F-PC-MED-001` (carried from Burst 9, still NOT actioned) -- open a DRAFT self-improvement story for untrusted-outcomes.json hardening (per-mutant-ID set re-derivation / sandboxed shard execution).
- `R-F2` (Burst 11, a planning-estimate truing-up, NOT a defect) -- the factory-artifact story `S-cycle6-mutants-ci-sharding.md`'s planning estimate "`EXPECTED_GUARD_TEST_COUNT` 38->65 / AC-031" is stale vs. the shipped 75; AC-031 explicitly mandated F4 re-verification, so this is a planning-estimate truing-up at cycle-close, not a defect.

**New follow-up item recorded this burst (Burst 12, NOT actioned):**
- `[process-gap]` **GITHUB-OPS-WATCH-HANG** -- the github-ops gh-delegation layer hung in-session during PR #791's merge execution (two `pr-manager` attempts stalled on delegated `gh` calls, including a non-terminating `gh pr checks --watch`); the orchestrator worked around it by verifying PR state green/mergeable via direct read-only `gh` and the human merged directly via the GitHub UI. This is a session-tooling / delegation-reliability observation, not a code or gate defect in the `jr` product. Candidate follow-up: investigate `gh pr checks --watch` hang conditions and github-ops delegation reliability (vsdd-factory engine tooling, not this repo).

**Provenance note (historical, condensed; full text preserved in `cycles/cycle-006/session-checkpoints.md` v3.88 archive):** Burst 9 received out-of-band messages relaying claims later shown, at Burst 10, to contain a real underlying technical defect (independently re-derived by state-manager against the actual code, not taken on the message's word) alongside an unverifiable claim of human authorization for retracting Burst 9's prompt-injection determination. Burst 9's integrity note was preserved rather than retracted at Burst 10 for that reason. The underlying technical defect was fully RESOLVED at Burst 11 via the normal adversarial-convergence process, independent of how it first surfaced, and the fix shipped to `develop` this burst (Burst 12) as part of PR #791. No further action on the provenance question is needed for the finding itself; the question of whether Burst 9's note should ever be formally retracted remains a matter for direct human instruction, unchanged from Burst 10.

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): historical, unchanged this burst.

`cycle-002` (`field-dx`) F2-F7 COMPLETE, human-authorized at the F7 gate (DEC-311). **RELEASED 2026-09-01 as `v0.7.0-dev.3`.** Historical, unchanged this burst.

`cycle-003` (`auth-profile-dx`) F1-F7 all COMPLETE, human-approved at every gate. **RELEASED 2026-09-03 as `v0.7.0-dev.4`** (DEC-333). **cycle-003 is CLOSED** -- SHIPPED, historical, unchanged this burst.

`cycle-004` (`windows-correctness`) F1-F7 COMPLETE, human-authorized at every gate (DEC-335 through DEC-343). **RELEASED 2026-09-06 as `v0.7.0-dev.5`**; **CLOSED** -- SHIPPED, historical. Full detail: `cycles/cycle-004/burst-log.md` Bursts 1-22.

`cycle-005` (`adf-mentions`) Phase **F1 APPROVED** (DEC-344); Phase **F2 APPROVED** (DEC-345 tightening + DEC-346 approval); Phase **F3 APPROVED** (DEC-347); Phase **F4 (delta implementation) IN PROGRESS** -- Wave 1 (`S-cycle5-mention-pure-conversion`) per-story adversarial convergence **COMPLETE** (3 clean passes), PR #778 **OPEN**, **now UNBLOCKED** as of this burst (cycle-006's sharded gate + >120 escape hatch landed on `develop`); Wave 2 (`S-cycle5-mention-resolution-wiring`) blocked-on-wave-1. cycle-005's own resume (rebase PR #778, re-run CI, decide the >120-mutant escalation) is **NOT actioned this burst**. Full detail: `cycles/cycle-005/phase-f3-stories/` + `.factory/sprint-state.yaml` `cycle_005_adf_mentions` + `cycles/cycle-005/burst-log.md` Bursts 1-4.

`cycle-006` (`mutants-ci-sharding`) Phase **F1 APPROVED** (DEC-348); Phase **F2 APPROVED at the gate** (**DEC-349**); Phase **F3 APPROVED at the gate** (**DEC-350**); Phase **F4 (delta implementation) COMPLETE + MERGED**: Step-4.5 per-story adversarial convergence reached 3-consecutive-clean at Burst 11 (7 trios / 21 passes / 6 fix rounds; `F-PI-CRITICAL-001`/`F-PF-HIGH-001`/`F-PG-MED-001` all RESOLVED), then PR #791 was human-approved and squash-merged into `develop` @ `a9168212` this burst (Burst 12) -- **ZERO Blocking Issues remain open.** Opened to fix the mutation-testing CI gate for large diffs and unblock PR #778; that gate is now live in production on `develop`. **NEXT = Phase F5 (scoped adversarial refinement)** -> F6 -> F7; F5/F6 expected light since Step-4.5 already front-loaded most of that surface (delta touches no `src/`). Full detail: `phase-f1-delta-analysis/cycle-006/` + `phase-f2-spec-evolution/cycle-006/` + `cycles/cycle-006/phase-f3-stories/` + `cycles/cycle-006/blocking-issues-resolved.md` + `cycles/cycle-006/session-checkpoints.md` + Decisions Log DEC-350/DEC-349.

**cycle-005 and cycle-006 are the two OPEN cycles** (cycle-005 Phase F4 is now UNBLOCKED, own resume not yet actioned; cycle-006 Phase F4 is COMPLETE + MERGED, ZERO open Blocking Issues, NEXT = F5); cycle-001 through cycle-004 remain CLOSED, historical, unaltered this burst.

## Concurrent Cycles

Six tracked cycles. `cycle-001` is CLOSED, historical. `cycle-002` (`field-dx`) is **CLOSED + RELEASED** (2026-09-01), historical. `cycle-003` (`auth-profile-dx`) is **CLOSED + RELEASED** (2026-09-03, DEC-333) as **`v0.7.0-dev.4`** @ `42e92b46`, historical. `cycle-004` (`windows-correctness`) is **CLOSED + RELEASED** (2026-09-06, DEC-343) as **`v0.7.0-dev.5`** @ `569d85a8`, historical. `cycle-005` (`adf-mentions`, GitHub #674) is **OPEN, now UNBLOCKED** -- Phase F1 **APPROVED** (DEC-344), Phase F2 **APPROVED** (DEC-345/DEC-346), Phase F3 **APPROVED** (DEC-347), Phase F4 (delta implementation) **IN PROGRESS** -- Wave 1 (`S-cycle5-mention-pure-conversion`, convergence **COMPLETE**, PR #778 **OPEN**, may now rebase onto `develop`) -> Wave 2 (blocked-on-wave-1), tracked in `.factory/sprint-state.yaml`'s `cycle_005_adf_mentions` section -- unblocked this burst but not itself resumed. `cycle-006` (`mutants-ci-sharding`) is **OPEN** -- Phase F1 **APPROVED** (DEC-348), Phase F2 **APPROVED at the gate** (**DEC-349**), Phase **F3 APPROVED at the gate** (**DEC-350**), Phase **F4 (delta implementation) COMPLETE + MERGED** this burst: PR #791 squash-merged to `develop` @ `a9168212` (2026-09-09T14:15:13Z), all 24 CI checks passed incl. the sharded pipeline's first live production run, Step-4.5 convergence (3-consecutive-clean, Burst 11) stands unmodified -- ZERO Blocking Issues remain open. `develop` @ **`a9168212`** (`activation_head`, advanced this burst from `569d85a8` -- cycle-006's first `develop` landing; cycle-005 has not yet merged). The standing auto-merge policy (DEC-330/DEC-331) and the `gh pr merge`/push MAIN-session-only constraint both remain in effect for both cycles' future story/fix PRs. **Pipeline is ACTIVE** (the merge-gate pause resolved this burst). **Next:** cycle-006 Phase F5 (scoped adversarial refinement) -> F6 (targeted hardening) -> F7 (delta convergence) -> cycle-006 closes; separately, at cycle-005 resume: rebase PR #778 onto the new `develop` -> CI re-run under the sharded gate -> the still-pending >120-mutant escalation decision (split-below-120 vs admin-bypass) -> merge PR #778 (main-session-only, human-approved) -> Wave-1 integration gate -> dispatch Story B (Wave 2, `S-cycle5-mention-resolution-wiring`).

## Constraints Carried Forward

**cycle-006 (F4 COMPLETE + MERGED, Burst 12, resume-session continuation):** PR #791 (story `S-cycle6-mutants-ci-sharding`, branch `ci/mutants-ci-sharding` @ `8f46648f`) was pushed to `origin`, opened as a PR, reviewed (pr-reviewer **APPROVE**; security-reviewer near-clean, 1 LOW + 1 INFO non-blocking, tracked), and passed all 24 CI checks -- including the required CI Gate and, for the first time in production, the full NEW sharded mutation-testing pipeline itself (Mutation Test Plan, Mutation Testing Shard 0-7 all 8, Mutation Testing Aggregate). During merge execution the github-ops gh-delegation layer hung in-session (two `pr-manager` attempts stalled on delegated `gh` calls, incl. a non-terminating `gh pr checks --watch`) -- recorded as `GITHUB-OPS-WATCH-HANG`, a session-tooling observation, not a code or gate defect; the orchestrator verified PR state green/mergeable via direct read-only `gh` before the human merged PR #791 directly via the GitHub UI. **Merge commit `a9168212`** ("ci(mutants): shard mutation-testing CI gate -- 8-way matrix + pooled aggregate (cycle-006) (#791)"), merged 2026-09-09T14:15:13Z; `develop` advanced `569d85a8`->`a9168212`. Post-merge cleanup done (devops-engineer): remote branch `ci/mutants-ci-sharding` deleted, local worktree `.worktrees/mutants-ci-sharding` removed, local branch deleted, stale refs pruned (cycle-005 worktree/branch untouched). Step-4.5 per-story adversarial convergence (recorded at Burst 11, v3.89: 7 trios / 21 passes / 6 fix rounds, 3-consecutive-clean) **stands unmodified this burst** -- `F-PI-CRITICAL-001`, `F-PF-HIGH-001`, `F-PG-MED-001` remain RESOLVED (full detail: `cycles/cycle-006/blocking-issues-resolved.md`); do not re-litigate those findings here. **cycle-006 Phase F4 (delta implementation) is now COMPLETE + MERGED to `develop`.** **NEXT:** Phase F5 (scoped adversarial refinement) -> F6 (targeted hardening) -> F7 (delta convergence); F5/F6 expected light since Step-4.5's convergence already front-loaded most of that surface (delta touches no `src/`, so scoped mutation/fuzz hardening is ~0-mutant / N/A) -- F7 remains the substantive remaining gate. **Also unblocked, not yet resumed this burst:** cycle-005's PR #778 (281 in-diff mutants) can now rebase onto the new `develop`; its >120-mutant escalation decision (split-below-120 vs admin-bypass) is still pending at cycle-005's own resume. **1 new follow-up item recorded this burst, NOT actioned:** `GITHUB-OPS-WATCH-HANG` [process-gap]. All prior follow-up items (5 from Burst 11, 5 LOW resume-TODOs from Burst 10) remain recorded, unchanged, not actioned -- see Blocking Issues above for full text. WIP: `ci/mutants-ci-sharding` -- branch deleted post-merge (work is now on `develop` @ `a9168212`); `feat/cycle5-mention-pure-conversion` @ `89b84a1f` (PR #778, untouched this burst). **Pipeline is ACTIVE** (merge-gate pause resolved).

**cycle-006 (F4 Step-4.5 CONVERGED, Bursts 9-11, condensed, historical; full per-round finding detail in `cycles/cycle-006/blocking-issues-resolved.md` + `session-checkpoints.md` v3.86/v3.88/v3.89 archives):** Burst 9 dispatched F4 for the sole Wave-1 story `S-cycle6-mutants-ci-sharding`, honoring the 5 BINDING F4 blocking preconditions, reaching code-complete on `ci/mutants-ci-sharding` @ `ceeedbf1` (8 commits, all-green). **Preconditions 2/3/5 DONE.** Step-4.5 per-story adversarial convergence ran a total of 7 trios / 21 fresh-context passes / 6 fix rounds across Bursts 9-11: round 1 (1 HIGH + 4 MED + 1 LOW, fixed), round 2 (2 HIGH, fixed; later shown DEFEATABLE at Burst 10, reopening `F-PF-HIGH-001` and opening `F-PI-CRITICAL-001` CRITICAL + `F-PG-MED-001` MED), round 3 (1 HIGH + 2 MED, fixed), **round 4 (J-CRITICAL: `mutants-plan` compute step only fragment-pinned, not byte-pinned -> diff-truncation-insertion forgery -- fixed via a new `extract_and_normalize_run_scalar_for_step` helper applied to every run-bearing step across all three mutation jobs, resolving all 3 open findings together)**, round 5 (1 MED + 2 LOW, fixed), round 6 (2 LOW, fixed), **round 7 (S/T/U all CLEAN -> 3-CONSECUTIVE-CLEAN, Step-4.5 CONVERGED)**. `EXPECTED_GUARD_TEST_COUNT` 57->75; `EXPECTED_MUTANTS_AGG_FIXTURES` 24->25; all verification green at HEAD `8f46648f` (tracked `ci.yml` byte-for-byte unchanged from `ceeedbf1` -- all fixes test/script/doc only). **This entire arc is now superseded by Burst 12's delivery/merge above** -- the branch built at `8f46648f` is what PR #791 delivered and merged as `a9168212`.

**cycle-006 (F3 APPROVED -- DEC-350, Bursts 4-8, historical):** F3 story decomposition dispatched at Burst 4; adversarial STORY convergence reached 3-consecutive-clean (32/33/34) via fix rounds 10-13 (Burst 5); pre-gate consistency audit fixes (Burst 5); `wave-schedule.md`/`wave-holdout-scenarios.md` input-hash cascade fully resolved (Bursts 6-7); human **APPROVED the F3 gate in full (DEC-350, Burst 8)** -- phase advanced F3->F4, 5 F4 blocking preconditions became BINDING. Full text: `cycles/cycle-006/session-checkpoints.md` v3.82-v3.86 archives.

**cycle-006 (F2 gate APPROVED -- DEC-349, Burst 3, historical):** Human **APPROVED** the F2 gate in full -- 8-shard `mutants-plan`->matrix->`mutants-aggregate` topology; pooled sum-not-average kill-rate >=90% reconciliation; >120-mutant escape hatch; advisory `mutants-nightly.yml`; `cargo-mutants@27.1.0`; 5 F4 blocking preconditions BINDING; documented residuals accepted (§6.10 mutants-plan/shard-run-line tier -- **CLOSED**, `F-PI-CRITICAL-001` resolved Burst 11, live in production Burst 12). Phase advances F2->F3. Full detail: `phase-f2-spec-evolution/cycle-006/{architecture-delta.md,mutants-sharding-invariants.md,ci-yml-design.md,verification-delta.md}` + Decisions Log DEC-349.

**cycle-006 (F2 CONVERGED, Burst 2, condensed):** 16-pass adversarial convergence (9 fix rounds; 3 consecutive clean passes 14/15/16); 4 genuine findings fixed. Pre-gate consistency audit PASSED. Superseded by the Burst-3 gate approval above. Full text: `cycles/cycle-006/burst-log.md` Burst 2.

**cycle-006 (F1 APPROVED, Burst 1, condensed):** DEC-348 recorded -- scope, sequencing, escape-hatch inclusion, params. HIGH regression risk flagged on CI-gate machinery (7 guardrails) -- **now live in production on `develop` as of this burst's PR #791 merge, for the mutation-gate guardrail family the F4 delta targeted** (the remaining guardrails outside that family are unaffected). Phase advanced F1->F2. Full text: `cycles/cycle-006/burst-log.md` Burst 1.

**cycle-005 (F4 Wave 1 Story A implemented, PR #778 open, now UNBLOCKED, own resume not yet actioned this burst):** Phase F4 Wave 1 (`S-cycle5-mention-pure-conversion`) delivered via the standard per-story-delivery TDD pipeline; AC-007 `\@`-escape SPIKE FEASIBLE (ADR-0023 §4); `protect_bracket_mentions` pre-parse mechanism closed a CommonMark-destroys-bracket-content discovery (ADR-0023 §4a). Story A reached per-story adversarial convergence (3 clean passes). PR #778 opened (branch `feat/cycle5-mention-pure-conversion` @ `89b84a1f`): pr-reviewer **APPROVE**, security-reviewer **CLEAN** (1 non-blocking LOW deferred to Story B); CI 13/14 green, "Mutation testing" was PENDING as of that burst -- now that cycle-006's sharded gate is live, PR #778's CI will re-run under the new pipeline once it rebases. Full detail: `cycles/cycle-005/burst-log.md` Burst 4.

**cycle-005 (F3 APPROVED + input-hash refresh + F4 wave tracking, Burst 3, condensed):** Phase F3 story decomposition human-**APPROVED** (**DEC-347**) -- 2 stories, acyclic A->B dependency, 26-point critical path, story count 172->174. Phase advanced F3->F4. Full text: `cycles/cycle-005/burst-log.md` Burst 3.

**cycle-005 (F2 APPROVED + F2-CLOSE INTEGRATE, Burst 2, historical):** Phase F2 spec evolution human-**APPROVED** (**DEC-346**) with one F2-gate **TIGHTENING** decision (**DEC-345**) folded in. Counts advanced 742->754 BCs / 55->76 VPs / 106->118 holdouts. Two process-gaps logged (`ADR-COUNT-CANONICAL-GUARD-GAP`, `FACTORY-HOOK-FUEL-EXHAUSTED`, both carried forward below). Full detail: `cycles/cycle-005/burst-log.md` Burst 2.

**cycle-005 (F1 APPROVED, Burst 1, historical):** New feature-mode cycle opened: `adf-mentions` (GitHub #674), brownfield, `dtu_required: false`. Human **APPROVED** the F1 scope. **Tracked follow-up (unchanged):** `VP-COUNT-RECONCILIATION`, non-blocking, target a future maintenance/self-improvement cycle.

**cycle-004 (RELEASE + CLOSE, historical):** Human authorized and executed the cycle-004 dev release (DEC-343): PR #777 squash-merged (`135eb804`->`569d85a8`), tag `v0.7.0-dev.5` pushed, `release.yml` run `34046676423` SUCCESS. **cycle-004 is CLOSED.** All prior outstanding non-blocking items carried forward verbatim (see "cycle-004 maintenance items" below); none block cycle-005/cycle-006.

**cycle-004 (earlier F1-F7 detail, historical):** F1 APPROVED (DEC-335); F2 scoped adversarial convergence, 25 passes, HUMAN GATE APPROVED (DEC-336); F3 story decomposition CONVERGED + APPROVED (DEC-337); F4 Waves 1-2 delivered/merged, COMPLETE (DEC-339); F5 CONVERGED (DEC-340); F6 COMPLETE (DEC-341). Full detail: `cycles/cycle-004/burst-log.md` Bursts 1-22.

**cycle-003 (RELEASE + CLOSE, historical):** Human authorized and executed the cycle-003 dev release (DEC-333). **cycle-003 is CLOSED.** All prior outstanding, non-blocking items carried forward verbatim -- none block cycle-004/cycle-005/cycle-006; deferred to a future maintenance/self-improvement cycle.

**cycle-003 (earlier F4/F3/F2 resolutions, historical):** F1 (BYO-OAuth-cred over-delete) and ADR-0011 doc-drift CLOSED. DEC-NAMESPACE-COLLISION-RISK clean (max ID DEC-350, no collision).

**Still open (2026-09-02, cycle-003 Wave 1 adversary, standing drift, not a cycle blocker):** `auth status` can transitively trigger the OAuth `"default"`-profile lazy-migration WRITE via `load_oauth_tokens` -- pre-existing behavior. Tracked for future maintenance-cycle attention.

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
- **A-PA-LOW-001** -- CLOSED, implemented by `S-cycle4-cloud-id-correctness` (merged PR #769 @ `c2074247`).
- **OBS-PB-1** (`auth status` credential probe `.is_ok()` swallows a genuine keyring backend error into "not found").
- `auth.rs:~1160` stale doc comment; `remove.rs` step-enumeration doc nit; `chacha20` 0.10.0 yanked-crate advisory (routine `cargo update -p chacha20` at next maintenance sweep).

**cycle-004 maintenance items (carried forward, not blockers):**
- **F6-MUTATION-EXAMINE-GLOBS-EXPANSION** -- add `src/api/auth.rs`, `src/cli/auth/login.rs`, `src/api/auth_windows_store.rs` to `.cargo/mutants.toml` examine_globs. Target: a future SELF-IMPROVEMENT/maintenance cycle.
- **JR_CACHE_DIR-TEST-ENV-MUTEX-UNIFICATION** -- `src/cache.rs`, `src/config.rs`, and `src/api/auth_windows_store.rs` each carry a SEPARATE mutex guarding the SAME process-global `JR_CACHE_DIR` env var. Target: a future SELF-IMPROVEMENT/maintenance cycle.
- **PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP** -- vsdd-factory engine tooling bug, not a jira-cli product defect. Target: vsdd-factory engine fix.
- **CYCLE-004-INPUT-HASH-HYGIENE** -- RESOLVED @ `a038ac0d`.
- **TD-031-BLOCKED-BC-6.2.016-CROSSREF** -- deferred, blocked by a pre-existing TD-031 hook violation, unrelated to cycle-004/005/006.
- **BC-1.4.035-PC5-VP-GAP** -- production round-trip now CI-verified; formal VP itself still deferred to maintenance.
- **S-410-KEYCHAIN-ISOLATION-FILE-OVERLAP** -- shares `tests/oauth_refresh_integration.rs` with cycle-004; non-blocking.
- **W2-INT-PROCESS-GAP-README-PROSE-DRIFT** -- no CI guard cross-checks README prose against the code model. Target: a future maintenance cycle.

**PROCESS-GAP (Pass 14, cycle-004, historical, not a blocker):**
- `scripts/check-bc-cumulative-counts.sh` does not cover a per-file `bc-*.md` "## Summary Stats" closing "Note:" cumulative-prose line. Target: a future SELF-IMPROVEMENT/maintenance cycle.

**PROCESS-GAP (cycle-005 F2-close INTEGRATE, Burst 2, historical):**
- **ADR-COUNT-CANONICAL-GUARD-GAP** -- `CANONICAL-COUNTS.md`'s "Canonical ADR count" line drifted across 4 cycles; no CI guard exists for this surface. Target: a future SELF-IMPROVEMENT/maintenance cycle.
- **FACTORY-HOOK-FUEL-EXHAUSTED** -- vsdd-factory engine tooling issue, not a jira-cli product defect. Target: engine fix.

**PROCESS-GAP (cycle-006 F4, carried forward across Bursts 9-12, NOT actioned, INV-3 halt):**
- **F-PE-MED-001** -- the Precondition-3 M-1 empirical partition-proof evidence (N=1532 exact; `--in-diff` mirror N=18 exact) is now captured in PR #791's merged body (Burst 12); a standalone durable-artifact capture is still not done. Target: capture into a durable factory artifact.
- **F-PC-MED-001** -- security-reviewer recommendation to harden `outcomes.json` shard-artifact handling (provenance-bound artifact download / sandboxed shard execution). Target: open a DRAFT self-improvement follow-up story (not opened yet).
- `F-PH-LOW-001`, `F-PH-LOW-002` [process-gap], `F-PH-LOW-003`, `F-PG-LOW-002` [process-gap], `F-PI-LOW-002` -- see Blocking Issues above for full text.

**PROCESS-GAP (cycle-006 F4 Burst 11, historical):**
- `STALE-RED-NARRATIVE-PATTERN` [process-gap], `EXAMINE-GLOBS-SHRINK-RESIDUAL` [process-gap], `BARE-JQ-TOKENIZER-RESIDUAL` [process-gap], `R-F2` (planning-estimate truing-up, not a defect) -- see Blocking Issues above for full text.

**PROCESS-GAP (cycle-006 F4 Burst 12, this burst, NOT actioned):**
- `GITHUB-OPS-WATCH-HANG` [process-gap] -- see Blocking Issues above for full text.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- 165 factory-wide stale `input-hash` artifacts confirmed via full scan (cycle-004 F7 pre-gate check, 2026-09-05; standing debt, **not** a cycle blocker).
- 11-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`; unchanged this burst at 11).
- `VP-COUNT-RECONCILIATION` (cycle-005 F1, unresolved) -- a raw grep found materially more VP ids across `bc-*.md` bodies than STATE's tracked running total; pre-existing bookkeeping-basis discrepancy, non-blocking. Target: a future maintenance/self-improvement cycle.

## Session Resume Checkpoint

**Date:** 2026-09-09. **Position:** cycle-006 (`mutants-ci-sharding`) Phase **F4** (delta implementation) is **COMPLETE + MERGED**. PR #791 (story `S-cycle6-mutants-ci-sharding`) was human-approved at the merge gate and squash-merged into `develop`, merge commit **`a9168212`** (2026-09-09T14:15:13Z); `develop` advanced `569d85a8`->`a9168212`. **NEXT:** cycle-006 Phase F5 (scoped adversarial refinement) -> F6 (targeted hardening) -> F7 (delta convergence); separately, cycle-005's PR #778 is now unblocked and can rebase onto the new `develop`, but its own resume is not yet actioned.

**Convergence counter:** Step-4.5 per-story adversarial convergence -- 3-consecutive-clean, **ACHIEVED at Burst 11 (streak 3/3)** and unmodified since. Full 7-trio / 21-pass / 6-fix-round arc recorded in `cycles/cycle-006/blocking-issues-resolved.md` and `cycles/cycle-006/session-checkpoints.md` (v3.89 archive) -- not repeated verbatim here. PR #791's own review passes (pr-reviewer APPROVE, security-reviewer near-clean) and 24/24 green CI checks are the delivery-side convergence evidence for this burst.

**In-flight work:** None durable outstanding for cycle-006 Phase F4 -- delivery is complete and merged. `ci/mutants-ci-sharding` branch has been deleted post-merge (work now lives on `develop` @ `a9168212`). Cycle-006's next phase (F5) has not yet been dispatched.

**Pending human decisions/blockers:** (1) None outstanding for cycle-006's merge -- resolved this burst. (2) At cycle-005 resume, PR #778 (281 in-diff mutants) will ESCALATE under the new >120 gate once it rebases and re-runs CI -- human chooses split-below-120 or admin-bypass; not actioned this burst. (3) F4-Precondition-1 is now satisfied: cycle-006 has landed on `develop` before PR #778 rebases. (4) Zero Blocking Issues remain open for cycle-006.

**WIP branches:** `ci/mutants-ci-sharding` -- deleted post-merge (cycle-006 F4 delivered to `develop` @ `a9168212`). `feat/cycle5-mention-pure-conversion` @ `89b84a1f` (cycle-005 PR #778, pushed, untouched this session; now eligible to rebase onto the new `develop`).

**Resume command:** `/vsdd-factory:rehydrate-wave` then `/vsdd-factory:next-step`.

**Tracked non-blocking follow-ups:** `VP-COUNT-RECONCILIATION`, `ADR-COUNT-CANONICAL-GUARD-GAP`, `FACTORY-HOOK-FUEL-EXHAUSTED` (all pre-existing, unchanged). `WAVE-SCHEDULE-INPUT-HASH-DRIFT` and `WAVE-HOLDOUT-SCENARIOS-INPUT-HASH-CASCADE` remain RESOLVED (Bursts 6-7). `S-PG-CROSSREF-SCOPE-DISCIPLINE` remains in the `S-PG-*` backlog (11 stories, unchanged this burst). **Carried from Burst 9 (still NOT actioned):** `F-PE-MED-001` (M-1 evidence now captured in PR #791's body; standalone durable-artifact capture still pending); `F-PC-MED-001` (open a DRAFT self-improvement story for untrusted-outcomes.json hardening). **Carried from Burst 10 (still NOT actioned):** `F-PH-LOW-001`, `F-PH-LOW-002` [process-gap], `F-PH-LOW-003`, `F-PG-LOW-002` [process-gap], `F-PI-LOW-002`. **Carried from Burst 11 (still NOT actioned):** `STALE-RED-NARRATIVE-PATTERN` [process-gap], `EXAMINE-GLOBS-SHRINK-RESIDUAL` [process-gap], `BARE-JQ-TOKENIZER-RESIDUAL` [process-gap], `R-F2` (planning-estimate truing-up). **New this burst (Burst 12, NOT actioned):** `GITHUB-OPS-WATCH-HANG` [process-gap] -- github-ops gh-delegation hang (`gh pr checks --watch` non-terminating) during PR #791's merge execution, session-tooling only, candidate follow-up for the vsdd-factory engine. Full text for all of the above: Blocking Issues section above. **On the Burst 9/10 out-of-band injection episode:** the underlying technical defect it partially anticipated was fully RESOLVED at Burst 11 and shipped to `develop` this burst; full provenance account preserved in `cycles/cycle-006/session-checkpoints.md` v3.88 archive.

**Counts: total_bcs 754; VP count 76 tracked running total; holdout scenarios 118; total_stories 175** (all counts unchanged this burst -- no BC/VP/holdout/story authorship occurred; this was a delivery/merge bookkeeping event, not spec or story authorship).

**Superseded checkpoints:** the prior cycle-006 Burst-11 checkpoint (v3.89, 2026-09-08/09 -- F4 Step-4.5 CONVERGENCE, 3-consecutive-clean, all 3 findings RESOLVED, branch not yet pushed/PR not yet assembled) is superseded in place by this checkpoint and archived to `cycles/cycle-006/session-checkpoints.md` ahead of this Write, with a "Superseded at" note explaining the delivery/merge completed this burst. Earlier archives (cycle-006 v3.79 Burst-1 through v3.88 Burst-10; cycle-005 v3.75-v3.78; cycle-004 v3.53-v3.74, cycle-003 v3.31-v3.52, cycle-002 v3.23-v3.29 and earlier, cycle-001 v3.05) remain at their respective `cycles/<cycle>/session-checkpoints.md` files, unchanged this burst.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-14 = F2/F3/F4; 15 = F5 CONVERGED + FIX-F5-001; 16 = F6 COMPLETE + FIX-F6-001; 17 = F7 delta-convergence PASS + FIX-F7-001; 18 = F7 human gate APPROVED + cycle-002 CLOSED; 19 = release v0.7.0-dev.3 SHIPPED; 20 = SESSION-WRAP) |
| cycle-003 burst history | `cycles/cycle-003/burst-log.md` (Burst 1 = cycle OPENED; Bursts 2-9 = F1 through F3 gates; Bursts 10-15 = F4 Waves 1-5, all 7 stories merged; Burst 16 = F5 findings fixed; Burst 17 = SESSION WRAP, F5 CONVERGED; Burst 18 = SESSION RESUMED, F6 DISPATCHED; Burst 19 = F6 COMPLETE -- PASS; Burst 20 = F7 pre-gate consistency audit; Burst 21 = F7 human gate APPROVED -- CONVERGED (DEC-332); Burst 22 = RELEASE v0.7.0-dev.4 SHIPPED, cycle-003 CLOSED (DEC-333)) |
| cycle-004 burst history | `cycles/cycle-004/burst-log.md` (Burst 1 = cycle OPENED; Burst 2 = F1 human gate APPROVED (DEC-335); Burst 3 = CRASH RECOVERY; Bursts 4-10 = F2 scoped adversarial convergence; Burst 11 = F2 HUMAN GATE APPROVED (DEC-336); Burst 12 = F3 story decomposition CONVERGED; Burst 13 = SESSION WRAP; Burst 14 = F3 HUMAN GATE APPROVED (DEC-337); Burst 15 = F4 Wave 1 DELIVERED + MERGED (DEC-338); Burst 16 = F4 Wave 2 PARTIALLY DELIVERED + SESSION WRAP; Burst 17 = Wave 2 gate PASSED, F4 COMPLETE (DEC-339); Burst 18 = F5 CONVERGED (DEC-340); Burst 19 = F6 COMPLETE (DEC-341); Burst 20 = F7 automated prep + SESSION WRAP; Burst 21 = F7 human gate PASSED -- CONVERGED (DEC-342); Burst 22 = **RELEASE v0.7.0-dev.5 SHIPPED**, **cycle-004 CLOSED (DEC-343)**) |
| cycle-005 burst history | `cycles/cycle-005/burst-log.md` (Burst 1 = cycle OPENED, F1 APPROVED (DEC-344); Burst 2 = F2 APPROVED (DEC-346) with TIGHTENING (DEC-345); Burst 3 = F3 APPROVED (DEC-347); Burst 4 = F4 Wave 1 implemented + convergence COMPLETE + PR #778 opened + SESSION WRAP -- pipeline focus reassigned to cycle-006 at that cycle's Burst 1; UNBLOCKED as of cycle-006 Burst 12) |
| cycle-006 burst history | `cycles/cycle-006/burst-log.md` (Burst 1 = cycle OPENED, F1 APPROVED (DEC-348); Burst 2 = F2 CONVERGED -- AWAITING gate). This STATE.md's Burst 3 = F2 gate APPROVED (DEC-349). Burst 4 = F3 dispatched, story authored, convergence in progress -- SESSION WRAP. Burst 5 = resumed, fix rounds 10-13, 3-consecutive-clean (32/33/34), pre-gate audit fixed -- AWAITING F3 GATE. Burst 6 = `wave-schedule.md` input-hash RESOLVED, cascade surfaced. Burst 7 = `wave-holdout-scenarios.md` cascade RESOLVED, ZERO drift. Burst 8 = **F3 GATE APPROVED (DEC-350)**, phase F3->F4. Burst 9 = **F4 dispatched, CODE COMPLETE** on `ci/mutants-ci-sharding` @ `ceeedbf1`; Step-4.5 rounds 1-2 run, streak 0 -- SESSION WRAP. Burst 10 = **SESSION-WRAP CORRECTION** -- `F-PI-CRITICAL-001`/`F-PG-MED-001` opened, F-PF-HIGH-001 reopened, 5 LOW resume-TODOs recorded, Burst-9 integrity note preserved+annotated. Burst 11 (2026-09-08/09, no separate burst-log entry authored) = **STEP-4.5 CONVERGENCE** -- 5 further adversarial trios (rounds 3-7, 15 passes) + 6 fix rounds ran; HEAD `ceeedbf1`->`8f46648f`; round 4's comprehensive byte-pin closure resolved all 3 open findings together; round 7 (S/T/U) reached 3-consecutive-clean -- Step-4.5 CONVERGED; Blocking Issues table EMPTY; Session Resume Checkpoint refreshed v3.88->v3.89. **Burst 12 (2026-09-09, this Write) = F4 DELIVERY COMPLETE + MERGED** -- PR #791 opened, pr-reviewer APPROVE + security-reviewer near-clean, all 24 CI checks passed (incl. the sharded pipeline's first live production run), human-approved and squash-merged to `develop` @ `a9168212` (`569d85a8`->`a9168212`); post-merge cleanup done; `GITHUB-OPS-WATCH-HANG` recorded as a new session-tooling follow-up; Session Resume Checkpoint refreshed v3.89->v3.90. |
| cycle-006 F3 story-decomposition artifacts | `cycles/cycle-006/phase-f3-stories/{S-cycle6-mutants-ci-sharding.md,dependency-graph-extended.md,wave-schedule.md,wave-holdout-scenarios.md}` (all 4 artifacts verified clean via `compute-input-hash --check` as of Burst 7) |
| cycle-006 F4 delivery artifacts | `develop` @ `a9168212` (PR #791 squash-merge; `scripts/mutants-aggregate.sh` + `scripts/lib/trusted-jq.sh`; `docs/specs/cargo-mutants-policy.md` + CHANGELOG; `tests/ci_gate_completeness.rs` `EXPECTED_GUARD_TEST_COUNT` now 75; `.github/workflows/ci.yml` sharded gate live); **all 3 Step-4.5 findings RESOLVED -- see `cycles/cycle-006/blocking-issues-resolved.md`** |
| cycle-006 F1 delta-analysis artifacts | `phase-f1-delta-analysis/cycle-006/delta-analysis.md` + `affected-files.txt`; grounding research `research/mutation-testing-ci-large-changes-2026-09-07.md` |
| cycle-006 F2 spec-evolution artifacts | `phase-f2-spec-evolution/cycle-006/{architecture-delta.md,mutants-sharding-invariants.md,ci-yml-design.md,verification-delta.md}` (adversarially converged, 16 passes; human-APPROVED at the F2 gate, DEC-349) |
| cycle-005 F1 delta-analysis artifacts | `phase-f1-delta-analysis/cycle-005/delta-analysis.md` + `affected-files.txt` + `artifact-mapping.md` |
| cycle-005 F2 spec-evolution artifacts | `phase-f2-spec-evolution/prd-delta-674.md`, `verification-delta-674.md`, `architecture-delta.md`; `specs/architecture/decisions/ADR-0023-markdown-mention-pure-effectful-conversion-seam.md` |
| cycle-005 F3 story-decomposition artifacts | `cycles/cycle-005/phase-f3-stories/{S-cycle5-mention-pure-conversion.md, S-cycle5-mention-resolution-wiring.md, dependency-graph-extended.md, wave-schedule.md}` |
| cycle-005 F4 wave tracking | `.factory/sprint-state.yaml` `cycle_005_adf_mentions:` section (Wave 1 `ready`, Wave 2 `blocked`) |
| cycle-005 F4 Wave-1 (Story A) delivery evidence | GitHub PR #778 (branch `feat/cycle5-mention-pure-conversion` @ `89b84a1f`); worktree `.worktrees/cycle5-mention-pure-conversion` (still mounted, not yet merged) |
| cycle-005 session checkpoints | `cycles/cycle-005/session-checkpoints.md` (v3.75-v3.78 archived) |
| cycle-006 session checkpoints | `cycles/cycle-006/session-checkpoints.md` (v3.79-v3.86, v3.88, and v3.89 archived -- v3.87 was corrected in place at Burst 10 rather than separately archived) |
| cycle-006 blocking issues resolved | `cycles/cycle-006/blocking-issues-resolved.md` (`F-PI-CRITICAL-001`, `F-PF-HIGH-001`, `F-PG-MED-001`, full per-finding resolution + 7-trio convergence arc summary) |
| cycle-006 lessons | `cycles/cycle-006/lessons.md` (2 process lessons logged at Burst 8; unchanged this burst) |
| cycle-004 F1 delta-analysis artifacts | `cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md` + `affected-files.txt` |
| cycle-004 F2 spec-evolution artifacts | `cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md`; `vp-delta.md`; ADR-0021/ADR-0022 |
| cycle-004 F3 story-decomposition artifacts | `cycles/cycle-004/phase-f3-stories/` |
| cycle-004 F4-F7 delivery + release evidence | `code-delivery/S-cycle4-*/`, `code-delivery/FIX-*`, `phase-f5-adversarial/cycle-004/`, `phase-f6-hardening/cycle-004/`, `phase-f7-convergence/cycle-004/`; GitHub PR #776 + #777; tag `v0.7.0-dev.5`; `release.yml` run `34046676423` |
| cycle-004 research | `research/atlassian-3lo-revoke-granularity-2026-09-05.md`, `research/edge-tenant-info-cloudid-2026-09-03.md` |
| cycle-004 session checkpoints | `cycles/cycle-004/session-checkpoints.md` (archives v3.53 through v3.74) |
| cycle-003 grounding + phase artifacts | `cycles/cycle-003/investigation/`, `cycles/cycle-003/phase-f1-delta-analysis/`, `phase-f2-spec-evolution/`, `phase-f3-stories/`, `phase-f4-implementation/`, `phase-f6-hardening/`, `phase-f7-convergence/` |
| cycle-003 release + F4/F5 delivery evidence | version-bump PR #767 (`develop` @ `42e92b46`); tag `v0.7.0-dev.4`; `release.yml` run `33769389700`; `code-delivery/FIX-F7-DOCS-1/`, `code-delivery/S-cycle3-*/`, `code-delivery/FIX-F5-*/` |
| cycle-002/cycle-001 historical artifacts | `cycles/cycle-002/`, `cycles/cycle-001/` (see per-cycle files) |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**cycle-006 (F4 COMPLETE + MERGED, Burst 12, resume-session continuation):** PR #791 human-approved and squash-merged into `develop` @ `a9168212` (`569d85a8`->`a9168212`, 2026-09-09T14:15:13Z); all 24 CI checks passed incl. the sharded mutation-testing pipeline's first live production run; pr-reviewer APPROVE, security-reviewer near-clean. Post-merge cleanup done. Step-4.5 convergence (Burst 11) stands unmodified -- `F-PI-CRITICAL-001`, `F-PF-HIGH-001`, `F-PG-MED-001` remain RESOLVED; **ZERO Blocking Issues remain open.** 1 new follow-up item recorded this burst (`GITHUB-OPS-WATCH-HANG`, process-gap, NOT actioned) for a github-ops gh-delegation hang encountered during merge execution (session-tooling, not a code/gate defect). Pipeline **ACTIVE** (merge-gate pause resolved) -- NEXT is cycle-006 Phase F5. See `Constraints Carried Forward` above for full detail.

**cycle-006 (F4 Step-4.5 CONVERGED, Bursts 9-11, condensed, historical):** F4 code reached 3-CONSECUTIVE-CLEAN via 7 trios (21 passes) + 6 fix rounds; the round-4 comprehensive byte-pin closure resolved `F-PI-CRITICAL-001` (CRITICAL), `F-PF-HIGH-001` (HIGH), and `F-PG-MED-001` (MED) together. **Now superseded by Burst 12's delivery/merge above** -- the converged branch (`8f46648f`) is what PR #791 delivered as `a9168212`. See `Constraints Carried Forward` above for full detail.

**cycle-006 (F3 APPROVED -- DEC-350, Bursts 4-8, historical):** F3 story decomposition reached 3-consecutive-clean (32/33/34), pre-gate audit fixed, input-hash cascade fully resolved; human **APPROVED the F3 gate in full (DEC-350, Burst 8)** -- phase advanced F3->F4, 5 F4 blocking preconditions became BINDING. See `Constraints Carried Forward` above for full detail.

**WAVE-SCHEDULE-INPUT-HASH-DRIFT (cycle-006, RESOLVED Burst 6, reconfirmed clean Burst 7):** `cycles/cycle-006/phase-f3-stories/wave-schedule.md`'s `input-hash` recomputed and verified clean.

**WAVE-HOLDOUT-SCENARIOS-INPUT-HASH-CASCADE (cycle-006, RESOLVED Burst 7):** `cycles/cycle-006/phase-f3-stories/wave-holdout-scenarios.md`'s cascade drift refreshed; all 4 cycle-006 F3 artifacts re-verified clean. Terminal leaf in the drift DAG -- cascade fully terminated.

**cycle-006 (F2 gate APPROVED -- DEC-349, Burst 3):** Human **APPROVED** the F2 gate in full. Phase advanced F2->F3. The 5 F4 blocking preconditions became BINDING gates on F4's start. See `Constraints Carried Forward` above for full detail.

**cycle-006 (F2 CONVERGED, Burst 2, condensed):** 16-pass adversarial convergence (9 fix rounds, 3 consecutive clean passes 14/15/16) plus a PASSED pre-gate consistency audit. Superseded by the Burst-3 gate approval above. Documented residuals remain bounded/accepted -- **§6.10 (mutants-plan/shard-run-line tier) is CLOSED, `F-PI-CRITICAL-001`'s resolution now live in production (Burst 12).**

**cycle-006 (F1 APPROVED, Burst 1, condensed):** New cycle opened, `mutants-ci-sharding`. DEC-348 recorded; phase advanced F1->F2. **HIGH regression-risk flag:** the 7 CI-gate guardrails enumerated in `phase-f1-delta-analysis/cycle-006/delta-analysis.md` -- **now live in production on `develop` as of Burst 12's PR #791 merge**, for the mutation-gate guardrail family specifically (the remaining 6 guardrails outside that family are unaffected by this burst).

**cycle-005 (F4 Wave 1 Story A implemented, PR #778 open, now UNBLOCKED, historical this burst):** Story A per-story adversarial convergence COMPLETE (3 clean passes); PR #778 OPEN, merge was sequenced behind cycle-006's landing on `develop` -- **that landing occurred this burst (Burst 12)**, so PR #778 may now rebase; its own resume is not yet actioned. See `Constraints Carried Forward` above for full detail.

**cycle-005 (F3 APPROVED + input-hash refresh + F4 wave tracking, Burst 3, condensed):** DEC-347 recorded; phase advanced F3->F4. Full text: `cycles/cycle-005/burst-log.md` Burst 3.

**cycle-005 (F2 APPROVED + F2-CLOSE INTEGRATE, Burst 2, historical):** DEC-345 (tightening) + DEC-346 (approval) recorded. Phase advanced F2->F3. **Tracked follow-ups:** `ADR-COUNT-CANONICAL-GUARD-GAP`, `FACTORY-HOOK-FUEL-EXHAUSTED` -- both non-blocking, target future engine/maintenance work.

**cycle-005 (F1 APPROVED, DEC-344, Burst 1, historical):** cycle-005 (`adf-mentions`, #674) OPENED. Human **APPROVED** the F1 scope. **Tracked follow-up (unchanged):** `VP-COUNT-RECONCILIATION`, non-blocking, target a future maintenance/self-improvement cycle.

**cycle-004 (RELEASE + CLOSE, historical):** DEC-343: PR #777 squash-merged, tag `v0.7.0-dev.5` pushed, `release.yml` SUCCESS. **cycle-004 is CLOSED.** All prior outstanding non-blocking items carried forward verbatim -- see "cycle-004 maintenance items" under `Constraints Carried Forward` above; none block cycle-005/cycle-006.

**cycle-004 (earlier F1-F7 detail, historical):** F1 APPROVED (DEC-335); F2 25-pass scoped adversarial convergence APPROVED (DEC-336); F3 story decomposition APPROVED (DEC-337); F4 Waves 1-2 COMPLETE (DEC-339); F5 CONVERGED (DEC-340); F6 COMPLETE (DEC-341); F7 CONVERGED (DEC-342). Full detail: `cycles/cycle-004/burst-log.md` Bursts 1-22.

**cycle-003 (RELEASE + CLOSE, historical):** DEC-333: PR #767 squash-merged, tag `v0.7.0-dev.4` pushed, `release.yml` SUCCESS. **cycle-003 is CLOSED.** All prior outstanding items deferred to a future maintenance cycle.

**Still open (2026-09-02, cycle-003 Wave 1 adversary, standing drift, not a cycle blocker):** `auth status` can transitively trigger the OAuth `"default"`-profile lazy-migration WRITE via `load_oauth_tokens` -- pre-existing behavior. Tracked for future maintenance-cycle attention.

**Still open (2026-09-01, cycle-002 F7 human gate + S-7.02 checklist -- justified deferral, unchanged):**
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
- **A-PA-LOW-001** -- CLOSED, implemented by `S-cycle4-cloud-id-correctness` (merged).
- **OBS-PB-1** (`auth status` credential probe `.is_ok()` swallows a genuine keyring backend error into "not found").
- `auth.rs:~1160` stale doc comment; `remove.rs` step-enumeration doc nit; `chacha20` 0.10.0 yanked-crate advisory.

**cycle-004 maintenance items (carried forward, not blockers):** see `Constraints Carried Forward` above for the full itemized list.

**PROCESS-GAP (Pass 14, cycle-004, historical, not a blocker):**
- `scripts/check-bc-cumulative-counts.sh` does not cover a per-file `bc-*.md` "## Summary Stats" closing "Note:" cumulative-prose line. Target a future maintenance cycle.

**PROCESS-GAP (cycle-005 F2-close INTEGRATE, Burst 2, historical):** see `Constraints Carried Forward` above for `ADR-COUNT-CANONICAL-GUARD-GAP` and `FACTORY-HOOK-FUEL-EXHAUSTED` full detail.

**PROCESS-GAP (cycle-006 F4, carried across Bursts 9-12):** see `Constraints Carried Forward` above for `F-PE-MED-001`, `F-PC-MED-001`, the 5 Burst-10 LOW resume-TODOs, and `GITHUB-OPS-WATCH-HANG` -- all recorded, none actioned.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- 165 historical stale `input-hash` artifacts factory-wide (confirmed cycle-004 F7); standing debt, **not** a cycle blocker.
- 11-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`; unchanged this burst at 11).
- `VP-COUNT-RECONCILIATION` (cycle-005 F1, unresolved) -- pre-existing base-count discrepancy, unrelated to this cycle's own correctly-counted VP-674 additions; non-blocking, target a future maintenance/self-improvement cycle.
