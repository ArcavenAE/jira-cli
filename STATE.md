---
document_type: pipeline-state
level: ops
version: "3.91"
status: active
producer: state-manager
timestamp: 2026-09-09T15:31:38Z
phase: "cycle-006 (mutants-ci-sharding) Phase F7 (delta convergence) HUMAN GATE APPROVED (DEC-351) -- cycle-006 CLOSED, NO RELEASE CUT (CI-infrastructure-only; shipped jr binary byte-identical; next release rides cycle-005). 5-dimensional delta convergence PASS: (1) Spec -- cargo-mutants-policy.md converged (DEC-349), F5 audit confirmed spec<->impl match; (2) Story/Test -- S-cycle6-mutants-ci-sharding F3-approved (DEC-350), 39 AC/30 VP/13 holdout all realized, STORY-INDEX corrected; (3) Implementation -- merged to develop @ a9168212, Step-4.5 3-consecutive-clean (7 trios/21 passes/6 fix rounds), F5 integration/regression clean; (4) Verification -- 30 VP-MUTANTS-SHARD guards passing, ci_gate_completeness 101/101, mutants-aggregate self-test 25/25, check-ci-gate jq-trust 17/17; (5) Regression -- full CI SUCCESS on merged develop tip a9168212 (Test/Coverage/Deny/clippy/fmt/MSRV/spec-guards/gitleaks/dependency-review + the new mutation gate) plus Scorecard supply-chain + E2E green. Human explicitly approved closing cycle-006 with no release at the F7 gate. S-7.02 cycle-closing checklist executed: human chose RECORD DEFERRALS ONLY -- 6 items recorded as justified deferrals with explicit target+reason in Drift/Standing Items, no follow-up stories opened; F-PE-MED-001 and R-F2 marked RESOLVED/CLOSED (not deferrals). PIPELINE POSITION: cycle-006 CLOSED; cycle-005 (adf-mentions) is now the active OPEN cycle, at Phase F4 (Wave 1, PR #778) -- UNBLOCKED since 2026-09-09 (cycle-006's sharded gate + >120 escape hatch is live on develop); the split-below-120-vs-admin-bypass escalation decision remains pending at cycle-005's own resume, not actioned this burst. activation_head stays a9168212, activation_version stays v0.7.0-dev.5 (no release this burst). Counts unchanged (754 BCs / 76 VPs / 118 holdouts / 175 stories)."
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
last_amended: "2026-09-09, v3.91, state-manager -- recorded DEC-351: cycle-006 (mutants-ci-sharding) Phase F7 delta convergence HUMAN GATE APPROVED, cycle-006 CLOSED, NO release cut (CI-infra-only, next release rides cycle-005); 5-dimensional convergence PASS across Spec/Story-Test/Implementation/Verification/Regression; S-7.02 cycle-closing checklist executed (human chose record-deferrals-only -- 6 items recorded as justified deferrals with target+reason in Drift/Standing Items, no follow-up stories opened); F-PE-MED-001 and R-F2 marked RESOLVED/CLOSED (not deferrals); pipeline position updated -- cycle-005 (adf-mentions) is now the active OPEN cycle, own resume still not actioned this burst; activation_head/activation_version unchanged, counts unchanged; DEC-namespace clean (max prior DEC-350, DEC-351 collision-free)."
current_step: "D-chain cite D-053 latest brownfield. BURST-13-F7-CYCLE6-CLOSED-2026-09-09: state-manager recorded DEC-351 (F7 delta convergence HUMAN GATE APPROVED, cycle-006 CLOSED, no release); set cycle_006_status to CLOSED; executed the S-7.02 cycle-closing checklist (human chose record-deferrals-only) -- 6 items recorded as justified deferrals with explicit target+reason in Drift/Standing Items, F-PE-MED-001 and R-F2 marked RESOLVED/CLOSED; updated pipeline position (cycle-005 now the active OPEN cycle); compacted historical cycle-006 multi-burst paragraphs into 2 condensed paragraphs (mirrors the cycle-004 pattern) to control STATE.md growth at cycle-close; archived the v3.90 Session Resume Checkpoint; appended Burst 13 to cycles/cycle-006/burst-log.md; committed this checkpoint in one atomic commit; trajectory-tail unchanged →1→3→0→2"
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
cycle_005_status: "adf-mentions -- OPEN, now the ACTIVE cycle (cycle-006 CLOSED this burst). Phase F1 delta analysis APPROVED (DEC-344); Phase F2 spec evolution APPROVED (DEC-345 tightening + DEC-346 approval); Phase F3 story decomposition APPROVED (DEC-347); Phase F4 (delta implementation) IN PROGRESS -- Wave 1 (S-cycle5-mention-pure-conversion) implemented, per-story adversarial convergence COMPLETE (3 clean passes), PR #778 OPEN, UNBLOCKED since 2026-09-09 (cycle-006's sharded mutation-testing CI gate + >120-mutant escape hatch landed on develop @ a9168212) -- own resume (rebase onto develop, CI re-run under the sharded gate, the split-below-120-vs-admin-bypass escalation decision) remains PENDING, not actioned this burst (this burst's focus was cycle-006 F7 close-out). Wave 2 (S-cycle5-mention-resolution-wiring) blocked-on-wave-1. See phase-f1-delta-analysis/cycle-005/ + phase-f2-spec-evolution/{prd,verification,architecture}-delta-674.md + cycles/cycle-005/phase-f3-stories/ + .factory/sprint-state.yaml cycle_005_adf_mentions + cycles/cycle-005/burst-log.md Bursts 1-4."
cycle_006_status: "mutants-ci-sharding -- CLOSED (DEC-348/349/350/351), NO RELEASE (CI-infrastructure-only; shipped binary byte-identical; next release rides cycle-005). F1 APPROVED 2026-09-07 (DEC-348); F2 APPROVED at the gate 2026-09-07 (DEC-349, 16-pass adversarial convergence); F3 APPROVED at the gate 2026-09-08 (DEC-350, story convergence 32/33/34); F4 (delta implementation) COMPLETE + MERGED 2026-09-09 -- PR #791 squash-merged to develop @ a9168212 (Step-4.5 3-consecutive-clean via 7 trios/21 passes/6 fix rounds; pr-reviewer APPROVE; security-reviewer near-clean; all 24 CI checks passed incl. the sharded pipeline's first live production run); F5 (scoped adversarial refinement) and F6 (targeted hardening) completed with no separate human gate (feature-mode convention -- results folded into F7's evidence); F7 (delta convergence, Burst 13, THIS RECORD) reached a 5-dimensional PASS and was human-APPROVED at the gate (DEC-351), 2026-09-09, cycle CLOSED with NO release cut. S-7.02 cycle-closing checklist executed: 6 items recorded as justified deferrals (STALE-RED-NARRATIVE-PATTERN, EXAMINE-GLOBS-SHRINK-RESIDUAL, BARE-JQ-TOKENIZER-RESIDUAL, GITHUB-OPS-WATCH-HANG, F-PC-MED-001, CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS -- see Drift/Standing Items); F-PE-MED-001 and R-F2 marked RESOLVED/CLOSED (not deferrals). Full detail: phase-f1-delta-analysis/cycle-006/ + phase-f2-spec-evolution/cycle-006/ + cycles/cycle-006/phase-f3-stories/ + cycles/cycle-006/blocking-issues-resolved.md + cycles/cycle-006/session-checkpoints.md + cycles/cycle-006/burst-log.md Bursts 1-13 + Decisions Log DEC-348/349/350/351."
activation_head: "a9168212"
activation_version: "v0.7.0-dev.5"
---

<!-- STATE.md SIZE BUDGET (2026-09-09, cycle-006 Burst 13 -- F7 DELTA CONVERGENCE APPROVED (DEC-351), CYCLE CLOSED, NO RELEASE:
     line count refreshed after this burst's Write):
     This burst records DEC-351: cycle-006 (`mutants-ci-sharding`) Phase F7 (delta convergence)
     reached a 5-dimensional PASS (Spec / Story-Test / Implementation / Verification /
     Regression) and was human-**APPROVED** at the gate. The human explicitly approved
     closing cycle-006 **with NO release cut** -- the cycle is CI-infrastructure-only, the
     shipped `jr` binary is byte-identical, and the next release rides cycle-005. The S-7.02
     cycle-closing checklist was executed per explicit human instruction: **RECORD DEFERRALS
     ONLY** -- 6 items (`STALE-RED-NARRATIVE-PATTERN`, `EXAMINE-GLOBS-SHRINK-RESIDUAL`,
     `BARE-JQ-TOKENIZER-RESIDUAL`, `GITHUB-OPS-WATCH-HANG`, `F-PC-MED-001`,
     `CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS`) were recorded as justified deferrals with
     an explicit target and reason each in **Drift / Standing Items**; NO follow-up stories
     were opened. `F-PE-MED-001` and `R-F2` were marked **RESOLVED/CLOSED** (not deferrals)
     and moved out of open follow-up tracking into `cycles/cycle-006/blocking-issues-resolved.md`.
     `pipeline:` stays ACTIVE. `current_cycle`/`feature_mode_bundle` switch from
     `cycle-006`/`mutants-ci-sharding` to `cycle-005`/`adf-mentions` -- cycle-006 is CLOSED,
     cycle-005 is now the sole OPEN cycle. `activation_head` (`a9168212`) and
     `activation_version` (`v0.7.0-dev.5`) are UNCHANGED this burst -- no release tag was cut;
     the DEC-351 rationale is explicit that NO_RELEASE is the human's deliberate choice, not
     an oversight. `version:` 3.90 -> 3.91; all running counts (754 BCs / 76 VPs / 118
     holdouts / 175 stories) are UNCHANGED this burst -- cycle close is a gate/bookkeeping
     event, not spec/story authorship.
     DEC-namespace check: max prior ID was DEC-350; **DEC-351 is collision-free** (grep-verified
     against `STATE.md` and `.factory/` before minting).
     Phase Progress gained one new row (F5-F6-F7-CONVERGENCE-CYCLE-CLOSE-2026-09-09, COMPLETE)
     summarizing F5/F6 completion (no separate human gate under the feature-mode convention --
     their evidence folds into F7's 5-dimensional convergence record) and F7's own gate outcome.
     No dedicated `phase-f5-adversarial/cycle-006/` or `phase-f6-hardening/cycle-006/` artifact
     subdirectory exists for this feature-mode cycle -- verified by directory listing before
     this Write; the evidence for those two phases lives in the DEC-351 rationale itself and in
     PR #791's already-recorded review/CI evidence, not in a separate artifact tree. This is
     stated plainly rather than fabricating a citation to a nonexistent path.
     Current Phase Steps replaced with a fresh Burst-13 table; Burst 12's table (already a
     pointer note as of that burst) is folded one level further into the same pointer note.
     **Aggressive historical compaction, THIS BURST ONLY (cycle-close discipline):** now that
     cycle-006 is fully CLOSED, its many per-burst `Constraints Carried Forward` / `Drift /
     Standing Items` paragraphs (previously one paragraph per burst: F1 Burst 1, F2 Bursts 2-3,
     F3 Bursts 4-8, F4 Step-4.5 Bursts 9-11, F4 delivery Burst 12) are condensed into exactly
     TWO paragraphs per section -- mirroring the existing `cycle-004` pattern
     ("RELEASE + CLOSE, historical" + "earlier F1-F7 detail, historical"). Full blow-by-blow
     detail for every condensed burst remains intact, unmodified, in
     `cycles/cycle-006/burst-log.md` (Bursts 1-13), `cycles/cycle-006/session-checkpoints.md`
     (v3.79 through v3.90 archives), and `cycles/cycle-006/blocking-issues-resolved.md` -- this
     compaction removes nothing from the historical record, it only stops re-stating already-
     archived detail in the size-budgeted live file. The standalone `WAVE-SCHEDULE-INPUT-HASH-
     DRIFT` / `WAVE-HOLDOUT-SCENARIOS-INPUT-HASH-CASCADE` RESOLVED headers and the Burst-9/10
     provenance note are folded into the same condensed paragraphs for the same reason (both
     are fully resolved, historical, and already preserved verbatim in
     `cycles/cycle-006/session-checkpoints.md`'s v3.88 archive).
     The 5 LOW resume-TODOs from Burst 10 (`F-PH-LOW-001/002/003`, `F-PG-LOW-002`,
     `F-PI-LOW-002`) were **not** part of the human's named 6-item S-7.02 deferral list this
     burst -- they are carried forward verbatim as pre-existing standing debt in a separate,
     clearly-labeled bucket, not silently merged into the 6 named deferrals.
     The v3.90 Session Resume Checkpoint was archived to
     `cycles/cycle-006/session-checkpoints.md` (with a "Superseded at" note) before this
     burst's new v3.91 checkpoint was written; a Burst 13 entry was appended to
     `cycles/cycle-006/burst-log.md`.
     `last_amended` is a full overwrite (BC-5.45.001 write-path discipline), not a
     concatenation of the prior entry.
     soft target 200 lines; hard cap 500 lines. 434 lines (wc-l) (this file, this
     Write) -- despite this burst adding DEC-351, a new Phase Progress row, a Current Phase
     Steps table, a 6-item deferral table, and a new Session Resume Checkpoint, the aggressive
     cycle-close historical compaction described above nets the file to roughly its v3.90 size
     or smaller. margin from soft-target = 434 - 200 = 234 (OVER the soft target; documented,
     ongoing known deviation across cycles-002/003/004/005/006, not a blocker). margin from actual
     = 500 - 434 = 66 (headroom remains before the hard cap).
     RECOVERY CONTEXT: no crash this burst -- a same-session continuation recording the
     verified fact of cycle-006's human-approved F7 gate and cycle close, as instructed.
     Factory lock: no `factory_lock` frontmatter block is present in this STATE.md and the
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
| **Last Updated** | trajectory-tail →1→3→0→2; unchanged this burst. Burst 13 (2026-09-09) -- cycle-006 Phase F7 (delta convergence) HUMAN GATE **APPROVED** (**DEC-351**); cycle-006 **CLOSED**, **NO RELEASE CUT** (CI-infrastructure-only; next release rides cycle-005). S-7.02 cycle-closing checklist executed (record-deferrals-only, 6 items, no stories opened); `F-PE-MED-001` + `R-F2` marked RESOLVED/CLOSED. Pipeline position: **cycle-005 (`adf-mentions`) is now the active OPEN cycle.** See Session Resume Checkpoint below for full detail. |
| **Current Phase** | cycle-006 (`mutants-ci-sharding`) is **CLOSED** -- F1-F7 all COMPLETE, human-approved at every gate (DEC-348/349/350/351), **NO release cut**. **cycle-005 (`adf-mentions`) is now the active OPEN cycle** -- Phase F1 **APPROVED** (DEC-344), F2 **APPROVED** (DEC-345/346), F3 **APPROVED** (DEC-347), Phase **F4 (delta implementation) IN PROGRESS**, Wave 1 (PR #778) UNBLOCKED, own resume still pending. cycle-001 through cycle-004 remain CLOSED, historical. |
| **Activation HEAD** | `a9168212` (`develop` tip; unchanged this burst -- no new `develop` landing, no release cut) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, cycles/cycle-003/burst-log.md, cycles/cycle-004/burst-log.md, cycles/cycle-005/burst-log.md, cycles/cycle-006/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **F1-DELTA-ANALYSIS (cycle-006)** | **APPROVED** | 2026-09-07 | Human approved F1 delta analysis: scope, sequencing, escape-hatch inclusion, params (DEC-348) | Feature: `mutants-ci-sharding` -- sharded `cargo-mutants --shard k/n` matrix + `mutants-aggregate` job + escape hatch + advisory scheduled full run. Full detail: `phase-f1-delta-analysis/cycle-006/` + `cycles/cycle-006/burst-log.md` Burst 1. | counts unchanged (754/76/118/174) |
| **F2-SPEC-EVOLUTION (cycle-006)** | **APPROVED** | 2026-09-07 | 16-pass adversarial convergence + pre-gate consistency audit PASSED + human F2 gate **APPROVED as-is** (**DEC-349**) | Design: `mutants-plan`-> 8-shard `mutants` matrix->`mutants-aggregate`; pooled sum-not-average kill-rate >=90% fail-closed reconciliation; >120-mutant escape hatch. 30 new `VP-MUTANTS-SHARD-001..030`. Full detail: `phase-f2-spec-evolution/cycle-006/` + Decisions Log DEC-349. | 16 passes, clean x3 (14/15/16); counts unchanged (754/76/118/174) |
| **F3-INCREMENTAL-STORIES (cycle-006)** | **APPROVED** | 2026-09-08 | Adversarial STORY convergence ACHIEVED 3 consecutive clean passes (32/33/34) + PASSED pre-gate consistency audit + human F3 gate **APPROVED as-is** (**DEC-350**) | Story `S-cycle6-mutants-ci-sharding` authored (39 ACs / 30 VPs / 13 holdouts / 30 tasks, Wave 1). Phase advanced F3->F4; the 5 F4 blocking preconditions became BINDING. | 174->175 stories; counts otherwise unchanged (754/76/118) |
| **F4-DELTA-IMPLEMENTATION (cycle-006)** | **COMPLETE** | 2026-09-09 | Gated on the 5 F4 blocking preconditions (BINDING per DEC-350); all 5 satisfied; Step-4.5 per-story adversarial convergence reached 3-consecutive-clean; PR #791 human-approved and merged | Wave 1 (`S-cycle6-mutants-ci-sharding`, 13 pts) implemented on branch `ci/mutants-ci-sharding`, converged via 7 adversarial trios / 21 fresh passes / 6 fix rounds, delivered via PR #791 and squash-merged to `develop` @ `a9168212`. | 754/76/118/175, unchanged (delivery event, no spec/story authorship) |
| **F5-F6-F7-CONVERGENCE-CYCLE-CLOSE-2026-09-09 (cycle-006, Burst 13)** | **COMPLETE / CLOSED** | 2026-09-09 | F5 (scoped adversarial refinement) and F6 (targeted hardening) completed with no separate human gate under the feature-mode convention -- their evidence folds into F7's 5-dimensional convergence record; F7 (delta convergence) reached a 5-dim **PASS** and was human-**APPROVED** at the gate (**DEC-351**) | 5-dim PASS: (1) Spec -- `cargo-mutants-policy.md` converged (DEC-349), F5 audit confirmed spec<->impl match; (2) Story/Test -- S-cycle6-mutants-ci-sharding F3-approved (DEC-350), 39 AC/30 VP/13 holdout all realized, STORY-INDEX corrected; (3) Implementation -- merged to `develop` @ `a9168212`, Step-4.5 3-consecutive-clean; (4) Verification -- 30 VP-MUTANTS-SHARD guards passing, `ci_gate_completeness` 101/101, `mutants-aggregate` self-test 25/25, `check-ci-gate` jq-trust 17/17; (5) Regression -- full CI SUCCESS on `develop` tip `a9168212` (Test/Coverage/Deny/clippy/fmt/MSRV/spec-guards/gitleaks/dependency-review + the mutation gate) + Scorecard + E2E green. Human explicitly approved closing cycle-006 **with NO release cut** (CI-infra-only; binary byte-identical; next release rides cycle-005). S-7.02 checklist executed (record-deferrals-only, 6 items, no stories opened); `F-PE-MED-001`/`R-F2` marked RESOLVED/CLOSED. **cycle-006 CLOSED.** No dedicated F5/F6 artifact subdirectory exists for this feature-mode cycle (verified before this Write) -- evidence lives in this row + PR #791's prior review/CI record. | counts unchanged (754/76/118/175); DEC-namespace clean (max ID DEC-351 as of this row) |

## Current Phase Steps (cycle-006 CLOSED -- Burst 13)

| Step | Status | Notes |
|------|--------|-------|
| Mint DEC-351 (F7 delta convergence APPROVED, cycle-006 CLOSED, no release) | **DONE** | Verified DEC-namespace clean (max prior DEC-350; grep-checked). |
| Set `cycle_006_status` to CLOSED | **DONE** | F1-F7 complete; DEC-348/349/350/351; merged PR #791 @ `a9168212`; NO release. |
| Execute S-7.02 cycle-closing checklist (human chose record-deferrals-only) | **DONE** | 6 items recorded as justified deferrals with explicit target + reason in Drift / Standing Items; NO follow-up stories opened. |
| Mark `F-PE-MED-001` and `R-F2` RESOLVED/CLOSED (not deferrals) | **DONE** | Moved out of open follow-up tracking into Blocking Issues resolution note + `cycles/cycle-006/blocking-issues-resolved.md`. |
| Update pipeline position -- cycle-005 now the active OPEN cycle | **DONE** | `current_cycle`/`feature_mode_bundle` switched `cycle-006`/`mutants-ci-sharding` -> `cycle-005`/`adf-mentions`; `activation_head`/`activation_version` unchanged (no release this burst). |
| Compact historical cycle-006 multi-burst paragraphs (Constraints/Drift) | **DONE** | Condensed into 2 paragraphs each, mirroring the `cycle-004` closed-cycle pattern; full detail preserved unmodified in `cycles/cycle-006/burst-log.md`/`session-checkpoints.md`/`blocking-issues-resolved.md`. |
| Archive prior Session Resume Checkpoint (v3.90) | **DONE** | Archived to `cycles/cycle-006/session-checkpoints.md` with a "Superseded at" note, before this Write. |
| Append Burst 13 narrative to `cycles/cycle-006/burst-log.md` | **DONE** | Full burst entry with Dim-1/2/5/6/7 attestations. |
| Frontmatter correction | **DONE** | `phase:`/`current_step:`/`last_amended:`/`current_cycle:`/`feature_mode_bundle:`/`cycle_005_status:`/`cycle_006_status:` updated; `version:` 3.90->3.91. |
| Write new Session Resume Checkpoint (v3.91) + single atomic commit + push | **DONE** | `factory(cycle-006):` commit on `factory-artifacts`; worktree ends clean. |

(Burst 12's Current Phase Steps -- record verified merge facts, archive v3.89, append Burst 12 narrative, confirm Blocking Issues EMPTY + record 1 follow-up item, frontmatter correction, write v3.90 checkpoint -- folded into this pointer note; see `cycles/cycle-006/session-checkpoints.md` v3.89 archive. Bursts 9-11 and earlier cycle-006 step history similarly folded into pointer notes across the v3.79-v3.89 archives in `cycles/cycle-006/session-checkpoints.md`. Prior cycle-005/004/003/002/001 steps archived to their own `cycles/<cycle>/burst-log.md`.)

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-351 | cycle-006 (`mutants-ci-sharding`) Phase F7 (delta convergence) **HUMAN GATE APPROVED / cycle CLOSED**, 2026-09-09, **NO RELEASE**. 5-dimensional delta convergence PASS -- (1) Spec: `cargo-mutants-policy.md` converged (DEC-349), F5 audit confirmed spec<->impl match; (2) Story/Test: S-cycle6-mutants-ci-sharding F3-approved (DEC-350), 39 AC/30 VP/13 holdout all realized, STORY-INDEX corrected; (3) Implementation: merged to `develop` @ `a9168212`, Step-4.5 3-consecutive-clean (7 trios/21 passes/6 fix rounds), F5 integration/regression clean; (4) Verification: 30 VP-MUTANTS-SHARD guards passing, `ci_gate_completeness` 101/101, `mutants-aggregate` self-test 25/25, `check-ci-gate` jq-trust 17/17; (5) Regression: full CI SUCCESS on the merged `develop` tip `a9168212` (all Test/Coverage/Deny/clippy/fmt/MSRV/spec-guards/gitleaks/dependency-review + the new mutation gate), plus Scorecard supply-chain + E2E green. **NO RELEASE CUT** -- cycle-006 is CI-infrastructure-only (no `src/` change; shipped binary byte-identical); next release rides cycle-005. Human explicitly approved closing cycle-006 with no release at the F7 gate | Human reviewed the complete 5-dimensional delta-convergence evidence package (spec, story/test, implementation, verification, regression) and explicitly approved closing the cycle without cutting a release, since the delta is CI-tooling-only and produces no shippable product change | F7 (gate) | 2026-09-09 | human (explicit approval) |
| DEC-350 | cycle-006 (`mutants-ci-sharding`) Phase F3 (incremental story decomposition) **HUMAN GATE APPROVED** 2026-09-08. Story `S-cycle6-mutants-ci-sharding` (39 ACs / 30 VPs / 13 holdouts / 30 tasks / 13 pts, Wave 1) reached F3 adversarial STORY convergence (3 consecutive clean passes 32/33/34); fresh-context pre-gate consistency audit PASSED after fixes; count-check scripts exit 0. Human approved as-is. The 5 F4 blocking preconditions are now BINDING. Phase advances F3->F4 | Human reviewed the complete, converged F3 story-decomposition package plus the pre-gate consistency audit and its fixes, and approved proceeding to delta implementation with the story as-is | F3 (gate) | 2026-09-08 | human (explicit approval) |
| DEC-349 | Human **APPROVED** cycle-006 (`mutants-ci-sharding`) Phase F2 (spec evolution) at the gate, in full -- 16-pass adversarial convergence (9 fix rounds, 3 consecutive clean passes 14/15/16), PASSED pre-gate consistency audit, the 5 F4 blocking preconditions, and the documented residuals (including §6.10 mutants-plan/shard-run-line tier -- CLOSED, `F-PI-CRITICAL-001` RESOLVED at Burst 11). Phase advances F2->F3 | Human reviewed the complete F2 spec-evolution artifact package plus the 16-pass convergence record and the pre-gate consistency audit, and approved proceeding to incremental story decomposition with the design unchanged | F2 (gate) | 2026-09-07 | human (explicit approval) |
| DEC-348 | Human **APPROVED** cycle-006 (`mutants-ci-sharding`) Phase F1 delta analysis in full -- scope (policy-doc-only + 2 new named invariants), sequencing (cycle-006 lands first), escape-hatch inclusion (HIGH-risk flagged for F2), params (8 shards, ~120-mutant threshold, `cargo-mutants@27.1.0`). **HIGH regression risk** flagged on the CI-gate machinery -- now RESOLVED and live in production, per DEC-351's F7 close. Phase advances F1->F2 | Human reviewed the F1 delta-analysis artifacts and the grounding research, and approved proceeding to spec evolution with the captured scope/sequencing/escape-hatch/params decisions | F1 | 2026-09-07 | human (explicit approval) |
| DEC-347 | Human **APPROVED** cycle-005 (`adf-mentions`, GitHub #674) Phase F3 story decomposition in full -- 2 stories (`S-cycle5-mention-pure-conversion` Wave 1, `S-cycle5-mention-resolution-wiring` Wave 2), acyclic A->B dependency, 2 sequential waves, critical path 26 pts. Story count 172->174. Phase advances F3->F4 | Human reviewed the complete F3 decomposition and the adversarial-convergence record and approved proceeding to delta implementation with the captured 2-wave split | F3 | 2026-09-06 | human (explicit approval) |
| DEC-345 / DEC-346 (condensed) | F2-gate **TIGHTENING** (`@Name` single-result `filter_by_name_match` hard-error) plus full F2 **APPROVAL** (12 new BCs, ADR-0023, 21 VPs, 12 holdouts, spec 2.1.0->2.2.0). Phase advanced F2->F3. Full text: `cycles/cycle-005/burst-log.md` Burst 2 | (condensed this burst per the one-burst-lag compaction rule) | F2 (gate) | 2026-09-06 | human (explicit approval, both decisions) |
| DEC-344 | Human APPROVED cycle-005 Phase F1 delta analysis: two mention forms, hard-error `@Name` no-match with `\@` escape + `--no-mentions` opt-out, ambiguous-match handling, wiring incl. JSM, reverse-path update, live-Jira E2E requirement. Phase advanced F1->F2. Full text: `cycles/cycle-005/burst-log.md` Burst 1 | Human reviewed both F1 delta-analysis artifacts and approved proceeding to spec evolution | F1 | 2026-09-06 | human (explicit approval) |
| DEC-343 | Human authorized and executed the cycle-004 dev release **v0.7.0-dev.5** (PR #777 squash-merged to `develop` @ `569d85a8`, tag `v0.7.0-dev.5` pushed, `release.yml` run `34046676423` SUCCESS). cycle-004 (`windows-correctness`) is now **CLOSED** | F7 reached human-authorized CONVERGENCE at DEC-342; the human then explicitly triggered the release action | RELEASE | 2026-09-06 | human (explicit authorization) |
| (350 older cycle-004/003/002/001 decisions) | DEC-342 through DEC-309 and earlier -- unchanged this burst | -- | F1-F7/historical | 2026-08-24...2026-09-06 | various -- see `cycles/cycle-004/burst-log.md` Bursts 1-22 and `cycles/cycle-003/burst-log.md` Bursts 13-22 |

**cycle-006 note (Bursts 1-13, CLOSED, DEC-namespace clean, max ID DEC-351):** **DEC-348** (F1 APPROVED, Burst 1). **DEC-349** (F2 gate APPROVED as-is, Burst 3). **DEC-350** (F3 gate APPROVED as-is, Burst 8) -- phase advanced F3->F4. F4 (delta implementation) reached Step-4.5 3-consecutive-clean (7 trios / 21 fresh passes / 6 fix rounds, Bursts 9-11), then was delivered and squash-merged into `develop` @ `a9168212` via PR #791 (Burst 12; pr-reviewer APPROVE, security-reviewer near-clean, all 24 CI checks passed incl. the sharded pipeline's first live production run). **DEC-351 (Burst 13, THIS BURST):** F5 (scoped adversarial refinement) and F6 (targeted hardening) completed with no separate human gate under the feature-mode convention; F7 (delta convergence) reached a 5-dimensional PASS (Spec / Story-Test / Implementation / Verification / Regression -- full rationale in the Decisions Log row above) and the human **APPROVED cycle-006's CLOSE at the F7 gate, with NO release cut** (CI-infrastructure-only; the shipped `jr` binary is byte-identical; the next release rides cycle-005). The S-7.02 cycle-closing checklist was executed per explicit human instruction: **RECORD DEFERRALS ONLY** -- 6 items recorded as justified deferrals with explicit target + reason in Drift / Standing Items, NO follow-up stories opened; `F-PE-MED-001` and `R-F2` marked **RESOLVED/CLOSED** (not deferrals) -- see Blocking Issues above. **cycle-006 (`mutants-ci-sharding`) is now CLOSED.** Full burst-by-burst detail: `cycles/cycle-006/burst-log.md` Bursts 1-13.

**cycle-005 note (Bursts 1-4, now the ACTIVE OPEN cycle as of this burst, own resume still pending):** **DEC-344** (F1 APPROVED, Burst 1); **DEC-345**/**DEC-346** (F2-gate TIGHTENING + APPROVED, Burst 2, condensed); **DEC-347** (F3 APPROVED, Burst 3, condensed). No new gate decision recorded for cycle-005 this burst. cycle-005 (`adf-mentions`, #674) is OPEN, Phase F4 (delta implementation) IN PROGRESS -- Wave 1 (Story A) convergence COMPLETE, PR #778 OPEN, UNBLOCKED (cycle-006's sharded gate landed on `develop`); own resume (rebase, CI re-run, >120-mutant escalation decision) is **NOT actioned this burst** -- this burst's scope was cycle-006 F7 close-out.

**cycle-004 note (historical, all bursts):** F1 APPROVED (DEC-335); F2 scoped adversarial convergence APPROVED (DEC-336); F3 story decomposition APPROVED (DEC-337); F4 COMPLETE (DEC-339); F5 CONVERGED (DEC-340); F6 COMPLETE (DEC-341); F7 CONVERGED (DEC-342); RELEASED + CLOSED (DEC-343). Full burst-by-burst decision detail: `cycles/cycle-004/burst-log.md` Bursts 1-22.

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
| F5/F6 dedicated artifact subdirectory (cycle-006) | not skipped, folded | Feature-mode F5 (scoped adversarial refinement) and F6 (targeted hardening) have no separate human gate under the feature-mode convention; their evidence was folded directly into F7's 5-dimensional convergence record (DEC-351) rather than written to a standalone `phase-f5-adversarial/cycle-006/`/`phase-f6-hardening/cycle-006/` tree. |

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/<cycle>/blocking-issues-resolved.md. -->

**NONE OPEN.** cycle-006 is **CLOSED** (DEC-351) with **zero** open Blocking Issues. All Step-4.5 convergence-arc findings (`F-PI-CRITICAL-001`, `F-PF-HIGH-001`, `F-PG-MED-001`) were RESOLVED at Burst 11 and remain resolved. At cycle-close (Burst 13, this burst), `F-PE-MED-001` and `R-F2` were additionally marked **RESOLVED/CLOSED** (see below); every OTHER previously-tracked cycle-006 follow-up item was **RECORDED AS A JUSTIFIED DEFERRAL** per the S-7.02 cycle-closing checklist (human chose record-deferrals-only, no follow-up stories opened) -- see **Drift / Standing Items** for the full itemized list with target + reason. The Blocking Issues table itself is intentionally empty.

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| *(none open)* | | | | | |

**RESOLVED/CLOSED at cycle-close (Burst 13, NOT deferrals):**
- `F-PE-MED-001` -- **CLOSED.** The Precondition-3 M-1 empirical `--list`<=>pooled partition evidence (N=1532 exact; `--in-diff` mirror N=18 exact) is now captured durably in PR #791's merged body -- the standalone-durable-artifact concern this item tracked is satisfied by that record; no further action needed.
- `R-F2` -- **CLOSED, not a defect.** The story's planning estimate `EXPECTED_GUARD_TEST_COUNT` 38->65 (AC-031) was explicitly subject to F4 re-verification; the shipped value 75 is the reconciled truth -- a planning-estimate truing-up, not a defect.

Full resolution detail (including the earlier 3-finding Step-4.5 arc): `cycles/cycle-006/blocking-issues-resolved.md`.

**Still open (cycle-006, Burst 10, LOW, non-blocking, unchanged -- NOT part of the S-7.02 checklist's named 6-item deferral list this burst; pre-existing standing debt carried forward verbatim):**
- `F-PH-LOW-001` -- add a `jq -e 'type=="object"'` shape check after each `jq empty` call in `scripts/mutants-aggregate.sh` / its self-test path.
- `F-PH-LOW-002` [process-gap] -- add a Rust subprocess test that runs `bash scripts/mutants-aggregate.sh --self-test` so the self-test is exercised by `cargo test`, not only invoked manually.
- `F-PH-LOW-003` -- tighten fixture 23's assertion substring to the exact phrase `"is malformed JSON"` (currently a looser match).
- `F-PG-LOW-002` [process-gap] -- `tests/ci_gate_completeness.rs`'s "seven always-run jobs" prose is stale vs. the actual eight `ci-gate.needs` members; enforcement itself is unaffected (derived dynamically), only the prose comment is stale.
- `F-PI-LOW-002` -- re-correct any remaining place in `docs/specs/cargo-mutants-policy.md`/this file that still characterizes `F-PF-HIGH-001` as closed by the round-2 fix alone rather than by the round-4 comprehensive closure.

**S-7.02 CYCLE-CLOSING CHECKLIST DEFERRALS (Burst 13, cycle-006 close, DEC-351) -- human chose RECORD DEFERRALS ONLY, no follow-up stories opened. Full itemized table with target + reason: see Drift / Standing Items below.**

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): historical, unchanged this burst.

`cycle-002` (`field-dx`) F2-F7 COMPLETE, human-authorized at the F7 gate (DEC-311). **RELEASED 2026-09-01 as `v0.7.0-dev.3`.** Historical, unchanged this burst.

`cycle-003` (`auth-profile-dx`) F1-F7 all COMPLETE, human-approved at every gate. **RELEASED 2026-09-03 as `v0.7.0-dev.4`** (DEC-333). **cycle-003 is CLOSED** -- SHIPPED, historical, unchanged this burst.

`cycle-004` (`windows-correctness`) F1-F7 COMPLETE, human-authorized at every gate (DEC-335 through DEC-343). **RELEASED 2026-09-06 as `v0.7.0-dev.5`**; **CLOSED** -- SHIPPED, historical. Full detail: `cycles/cycle-004/burst-log.md` Bursts 1-22.

`cycle-005` (`adf-mentions`) Phase **F1 APPROVED** (DEC-344); Phase **F2 APPROVED** (DEC-345 tightening + DEC-346 approval); Phase **F3 APPROVED** (DEC-347); Phase **F4 (delta implementation) IN PROGRESS** -- Wave 1 (`S-cycle5-mention-pure-conversion`) per-story adversarial convergence **COMPLETE** (3 clean passes), PR #778 **OPEN**, **UNBLOCKED** (cycle-006's sharded gate + >120 escape hatch landed on `develop`); Wave 2 (`S-cycle5-mention-resolution-wiring`) blocked-on-wave-1. **cycle-005 is now the sole OPEN cycle as of this burst** -- own resume (rebase PR #778, re-run CI, decide the >120-mutant escalation) is **NOT actioned this burst**. Full detail: `cycles/cycle-005/phase-f3-stories/` + `.factory/sprint-state.yaml` `cycle_005_adf_mentions` + `cycles/cycle-005/burst-log.md` Bursts 1-4.

`cycle-006` (`mutants-ci-sharding`) F1-F7 all **COMPLETE**, human-approved at every gate (**DEC-348 through DEC-351**). **NO RELEASE CUT** -- CI-infrastructure-only; the shipped `jr` binary is byte-identical; the next release rides cycle-005. **cycle-006 is CLOSED** -- historical as of this burst. Full detail: `cycles/cycle-006/burst-log.md` Bursts 1-13 + `cycles/cycle-006/blocking-issues-resolved.md`.

**cycle-005 is the sole OPEN cycle** (Phase F4, now UNBLOCKED, own resume not yet actioned); cycle-001 through cycle-004 and cycle-006 are all CLOSED, historical, unaltered/newly-closed as noted above.

## Concurrent Cycles

Six tracked cycles. `cycle-001` is CLOSED, historical. `cycle-002` (`field-dx`) is **CLOSED + RELEASED** (2026-09-01), historical. `cycle-003` (`auth-profile-dx`) is **CLOSED + RELEASED** (2026-09-03, DEC-333) as **`v0.7.0-dev.4`** @ `42e92b46`, historical. `cycle-004` (`windows-correctness`) is **CLOSED + RELEASED** (2026-09-06, DEC-343) as **`v0.7.0-dev.5`** @ `569d85a8`, historical. `cycle-006` (`mutants-ci-sharding`) is **CLOSED, NO RELEASE** (2026-09-09, DEC-348/349/350/351) -- F1-F7 all complete; PR #791 merged to `develop` @ `a9168212`; CI-infrastructure-only, shipped binary byte-identical, next release rides cycle-005; historical as of this burst. `cycle-005` (`adf-mentions`, GitHub #674) is **OPEN -- the sole active cycle as of this burst** -- Phase F1 **APPROVED** (DEC-344), Phase F2 **APPROVED** (DEC-345/DEC-346), Phase F3 **APPROVED** (DEC-347), Phase F4 (delta implementation) **IN PROGRESS** -- Wave 1 (`S-cycle5-mention-pure-conversion`, convergence **COMPLETE**, PR #778 **OPEN**, UNBLOCKED) -> Wave 2 (blocked-on-wave-1), tracked in `.factory/sprint-state.yaml`'s `cycle_005_adf_mentions` section -- **its own resume is NOT actioned this burst.** `develop` @ **`a9168212`** (`activation_head`, unchanged this burst -- no new `develop` landing, no release cut). The standing auto-merge policy (DEC-330/DEC-331) and the `gh pr merge`/push MAIN-session-only constraint remain in effect for cycle-005's future story/fix PRs. **Pipeline is ACTIVE.** **Next:** at cycle-005 resume -- rebase PR #778 onto the current `develop` -> CI re-run under the sharded gate -> the still-pending >120-mutant escalation decision (split-below-120 vs admin-bypass) -> merge PR #778 (main-session-only, human-approved) -> Wave-1 integration gate -> dispatch Story B (Wave 2, `S-cycle5-mention-resolution-wiring`).

## Constraints Carried Forward

**cycle-006 (CLOSE + NO RELEASE, DEC-351, Burst 13, THIS BURST):** F7 (delta convergence) reached a 5-dimensional PASS -- Spec, Story/Test, Implementation, Verification, Regression (full rationale: Decisions Log DEC-351 above) -- and the human **APPROVED cycle-006's CLOSE at the F7 gate, with NO release cut** (CI-infrastructure-only; the shipped `jr` binary is byte-identical; the next release rides cycle-005). The S-7.02 cycle-closing checklist was executed per explicit human instruction: **RECORD DEFERRALS ONLY** -- 6 items (`STALE-RED-NARRATIVE-PATTERN`, `EXAMINE-GLOBS-SHRINK-RESIDUAL`, `BARE-JQ-TOKENIZER-RESIDUAL`, `GITHUB-OPS-WATCH-HANG`, `F-PC-MED-001`, `CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS`) recorded as justified deferrals with explicit target + reason (see **Drift / Standing Items**); NO follow-up stories opened. `F-PE-MED-001` and `R-F2` marked **RESOLVED/CLOSED** (not deferrals) -- see **Blocking Issues** above. F5 (scoped adversarial refinement) and F6 (targeted hardening) completed with no separate human gate under the feature-mode convention; no dedicated `phase-f5-adversarial/cycle-006/`/`phase-f6-hardening/cycle-006/` artifact subdirectory exists (verified before this Write) -- their evidence is folded directly into F7's convergence record. **cycle-006 (`mutants-ci-sharding`) is now CLOSED.** Pipeline position updated: **cycle-005 (`adf-mentions`) is now the sole active OPEN cycle** (`current_cycle`/`feature_mode_bundle` switched this burst); its own resume (rebase PR #778, CI re-run, >120-mutant escalation decision) remains **NOT actioned this burst**. `activation_head` (`a9168212`) and `activation_version` (`v0.7.0-dev.5`) are unchanged -- no release tag cut. WIP: `ci/mutants-ci-sharding` -- deleted post-merge (work lives on `develop` @ `a9168212`); `feat/cycle5-mention-pure-conversion` @ `89b84a1f` (PR #778, untouched this burst). **Pipeline is ACTIVE.**

**cycle-006 (earlier F1-F4 detail, historical, now fully superseded by the CLOSE above):** F1 **APPROVED** (DEC-348, Burst 1) -- scope/sequencing/escape-hatch/params, HIGH regression-risk flag on CI-gate machinery, now RESOLVED per DEC-351. F2 **APPROVED at the gate** (DEC-349, Burst 3) -- 16-pass adversarial convergence (9 fix rounds, 3-consecutive-clean 14/15/16), 8-shard `mutants-plan`->matrix->`mutants-aggregate` topology, pooled sum-not-average kill-rate >=90% reconciliation, >120-mutant escape hatch, `cargo-mutants@27.1.0`. F3 **APPROVED at the gate** (DEC-350, Bursts 4-8) -- story `S-cycle6-mutants-ci-sharding` (39 ACs/30 VPs/13 holdouts/30 tasks) reached 3-consecutive-clean (32/33/34); 5 F4 blocking preconditions became BINDING; `wave-schedule.md`/`wave-holdout-scenarios.md` input-hash cascade fully resolved. F4 (delta implementation, Bursts 9-12) -- dispatched, reached code-complete on `ci/mutants-ci-sharding` @ `ceeedbf1`; Step-4.5 per-story adversarial convergence ran 7 trios / 21 fresh-context passes / 6 fix rounds (round 1: 1 HIGH+4 MED+1 LOW; round 2: 2 HIGH, later shown defeatable, reopening `F-PF-HIGH-001` + opening `F-PI-CRITICAL-001` CRITICAL/CWE-358 + `F-PG-MED-001` MED; round 3: 1 HIGH+2 MED; **round 4: comprehensive byte-pin closure via a new `extract_and_normalize_run_scalar_for_step` helper, resolving all 3 open findings together**; round 5: 1 MED+2 LOW; round 6: 2 LOW; **round 7 (S/T/U): 3-CONSECUTIVE-CLEAN**), advancing HEAD `ceeedbf1`->`8f46648f` (13 commits, test/script/doc only, tracked `ci.yml` byte-for-byte unchanged); `EXPECTED_GUARD_TEST_COUNT` 57->75, `EXPECTED_MUTANTS_AGG_FIXTURES` 24->25. The converged branch was then pushed, PR #791 opened, reviewed (pr-reviewer APPROVE; security-reviewer near-clean, 1 LOW+1 INFO non-blocking), all 24 CI checks passed (incl. the sharded pipeline's first live production run), and human-approved/squash-merged into `develop` @ `a9168212` (`569d85a8`->`a9168212`, 2026-09-09T14:15:13Z) -- during merge execution the github-ops gh-delegation layer hung on a non-terminating `gh pr checks --watch` (recorded as `GITHUB-OPS-WATCH-HANG`, now a deferral, see above); post-merge cleanup done (branch/worktree removed, refs pruned). Full per-round/per-burst detail preserved verbatim, unmodified, in `cycles/cycle-006/burst-log.md` (Bursts 1-13) and `cycles/cycle-006/session-checkpoints.md` (v3.79 through v3.90 archives).

**cycle-005 (F4 Wave 1 Story A implemented, PR #778 open, sole active cycle as of this burst, own resume not yet actioned):** Phase F4 Wave 1 (`S-cycle5-mention-pure-conversion`) delivered via the standard per-story-delivery TDD pipeline; AC-007 `\@`-escape SPIKE FEASIBLE (ADR-0023 §4); `protect_bracket_mentions` pre-parse mechanism closed a CommonMark-destroys-bracket-content discovery (ADR-0023 §4a). Story A reached per-story adversarial convergence (3 clean passes). PR #778 opened (branch `feat/cycle5-mention-pure-conversion` @ `89b84a1f`): pr-reviewer **APPROVE**, security-reviewer **CLEAN** (1 non-blocking LOW deferred to Story B); CI green apart from "Mutation testing", now re-runnable under cycle-006's live sharded gate once rebased. Full detail: `cycles/cycle-005/burst-log.md` Burst 4.

**cycle-005 (F3 APPROVED + input-hash refresh + F4 wave tracking, Burst 3, condensed):** Phase F3 story decomposition human-**APPROVED** (**DEC-347**) -- 2 stories, acyclic A->B dependency, 26-point critical path, story count 172->174. Phase advanced F3->F4. Full text: `cycles/cycle-005/burst-log.md` Burst 3.

**cycle-005 (F2 APPROVED + F2-CLOSE INTEGRATE, Burst 2, historical):** Phase F2 spec evolution human-**APPROVED** (**DEC-346**) with one F2-gate **TIGHTENING** decision (**DEC-345**) folded in. Counts advanced 742->754 BCs / 55->76 VPs / 106->118 holdouts. Two process-gaps logged (`ADR-COUNT-CANONICAL-GUARD-GAP`, `FACTORY-HOOK-FUEL-EXHAUSTED`, both carried forward below). Full detail: `cycles/cycle-005/burst-log.md` Burst 2.

**cycle-005 (F1 APPROVED, Burst 1, historical):** New feature-mode cycle opened: `adf-mentions` (GitHub #674), brownfield, `dtu_required: false`. Human **APPROVED** the F1 scope. **Tracked follow-up (unchanged):** `VP-COUNT-RECONCILIATION`, non-blocking, target a future maintenance/self-improvement cycle.

**cycle-004 (RELEASE + CLOSE, historical):** Human authorized and executed the cycle-004 dev release (DEC-343): PR #777 squash-merged (`135eb804`->`569d85a8`), tag `v0.7.0-dev.5` pushed, `release.yml` run `34046676423` SUCCESS. **cycle-004 is CLOSED.** All prior outstanding non-blocking items carried forward verbatim (see "cycle-004 maintenance items" below); none block cycle-005.

**cycle-004 (earlier F1-F7 detail, historical):** F1 APPROVED (DEC-335); F2 scoped adversarial convergence, 25 passes, HUMAN GATE APPROVED (DEC-336); F3 story decomposition CONVERGED + APPROVED (DEC-337); F4 Waves 1-2 delivered/merged, COMPLETE (DEC-339); F5 CONVERGED (DEC-340); F6 COMPLETE (DEC-341). Full detail: `cycles/cycle-004/burst-log.md` Bursts 1-22.

**cycle-003 (RELEASE + CLOSE, historical):** Human authorized and executed the cycle-003 dev release (DEC-333). **cycle-003 is CLOSED.** All prior outstanding, non-blocking items carried forward verbatim -- none block cycle-005; deferred to a future maintenance/self-improvement cycle.

**cycle-003 (earlier F4/F3/F2 resolutions, historical):** F1 (BYO-OAuth-cred over-delete) and ADR-0011 doc-drift CLOSED. DEC-NAMESPACE-COLLISION-RISK clean (max ID DEC-351, no collision).

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
- **TD-031-BLOCKED-BC-6.2.016-CROSSREF** -- deferred, blocked by a pre-existing TD-031 hook violation, unrelated to cycle-005/006.
- **BC-1.4.035-PC5-VP-GAP** -- production round-trip now CI-verified; formal VP itself still deferred to maintenance.
- **S-410-KEYCHAIN-ISOLATION-FILE-OVERLAP** -- shares `tests/oauth_refresh_integration.rs` with cycle-004; non-blocking.
- **W2-INT-PROCESS-GAP-README-PROSE-DRIFT** -- no CI guard cross-checks README prose against the code model. Target: a future maintenance cycle.

**PROCESS-GAP (Pass 14, cycle-004, historical, not a blocker):**
- `scripts/check-bc-cumulative-counts.sh` does not cover a per-file `bc-*.md` "## Summary Stats" closing "Note:" cumulative-prose line. Target: a future SELF-IMPROVEMENT/maintenance cycle.

**PROCESS-GAP (cycle-005 F2-close INTEGRATE, Burst 2, historical):**
- **ADR-COUNT-CANONICAL-GUARD-GAP** -- `CANONICAL-COUNTS.md`'s "Canonical ADR count" line drifted across 4 cycles; no CI guard exists for this surface. Target: a future SELF-IMPROVEMENT/maintenance cycle.
- **FACTORY-HOOK-FUEL-EXHAUSTED** -- vsdd-factory engine tooling issue, not a jira-cli product defect. Target: engine fix.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- 165 factory-wide stale `input-hash` artifacts confirmed via full scan (cycle-004 F7 pre-gate check, 2026-09-05; standing debt, **not** a cycle blocker).
- 11-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`; unchanged this burst at 11).
- `VP-COUNT-RECONCILIATION` (cycle-005 F1, unresolved) -- a raw grep found materially more VP ids across `bc-*.md` bodies than STATE's tracked running total; pre-existing bookkeeping-basis discrepancy, non-blocking. Target: a future maintenance/self-improvement cycle.

## Session Resume Checkpoint

**Date:** 2026-09-09. **Position:** cycle-006 (`mutants-ci-sharding`) Phase **F7** (delta convergence) reached a 5-dimensional PASS and was human-**APPROVED** at the gate (**DEC-351**). **cycle-006 is CLOSED, with NO release cut** (CI-infrastructure-only; shipped binary byte-identical; next release rides cycle-005). **NEXT:** cycle-005 (`adf-mentions`) is now the sole active OPEN cycle, at Phase F4 (delta implementation) -- PR #778 is UNBLOCKED and can rebase onto the current `develop`, but its own resume (rebase, CI re-run, the >120-mutant escalation decision) is not yet actioned.

**Convergence counter:** cycle-006's Step-4.5 per-story adversarial convergence reached 3-consecutive-clean at Burst 11 and stands unmodified. F7's own 5-dimensional convergence (Spec/Story-Test/Implementation/Verification/Regression) reached a full PASS this burst, recorded in DEC-351 above -- this IS the terminal convergence event for cycle-006; no further convergence loop is pending for this cycle.

**In-flight work:** None outstanding for cycle-006 -- the cycle is fully closed. cycle-005's Phase F4 Wave 1 (PR #778) is the only in-flight work in the factory, and it is not being actively driven this burst (this burst's scope was cycle-006's close-out only).

**Pending human decisions/blockers:** (1) None outstanding for cycle-006 -- fully resolved and closed this burst. (2) At cycle-005 resume, PR #778 (281 in-diff mutants) will ESCALATE under the now-live >120 gate once it rebases and re-runs CI -- human chooses split-below-120 or admin-bypass; not actioned this burst. (3) Zero Blocking Issues remain open anywhere in the factory as of this checkpoint.

**WIP branches:** `ci/mutants-ci-sharding` -- deleted post-merge (cycle-006 F4 delivered to `develop` @ `a9168212`; cycle-006 itself now fully closed). `feat/cycle5-mention-pure-conversion` @ `89b84a1f` (cycle-005 PR #778, pushed, untouched this session; eligible to rebase onto the current `develop`).

**Resume command:** `/vsdd-factory:rehydrate-wave` then `/vsdd-factory:next-step`.

**Tracked non-blocking follow-ups:** `VP-COUNT-RECONCILIATION`, `ADR-COUNT-CANONICAL-GUARD-GAP`, `FACTORY-HOOK-FUEL-EXHAUSTED` (all pre-existing, unchanged). **cycle-006 close-out deferrals recorded this burst (S-7.02 checklist, human chose record-deferrals-only, no stories opened):** `STALE-RED-NARRATIVE-PATTERN`, `EXAMINE-GLOBS-SHRINK-RESIDUAL`, `BARE-JQ-TOKENIZER-RESIDUAL`, `GITHUB-OPS-WATCH-HANG`, `F-PC-MED-001`, `CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS` -- full itemized table with target + reason: **Drift / Standing Items** section. `F-PE-MED-001` and `R-F2` marked RESOLVED/CLOSED this burst (not deferrals). 5 pre-existing LOW resume-TODOs from Burst 10 (`F-PH-LOW-001/002/003`, `F-PG-LOW-002`, `F-PI-LOW-002`) remain carried forward, unchanged, NOT part of this burst's named 6-item deferral list -- see **Blocking Issues** above. `S-PG-CROSSREF-SCOPE-DISCIPLINE` remains in the `S-PG-*` backlog (11 stories, unchanged this burst).

**Counts: total_bcs 754; VP count 76 tracked running total; holdout scenarios 118; total_stories 175** (all counts unchanged this burst -- no BC/VP/holdout/story authorship occurred; this was a gate/cycle-close bookkeeping event).

**Superseded checkpoints:** the prior cycle-006 Burst-12 checkpoint (v3.90, 2026-09-09 -- F4 DELIVERY COMPLETE + MERGED, PR #791 squash-merged to `develop` @ `a9168212`) is superseded in place by this checkpoint and archived to `cycles/cycle-006/session-checkpoints.md` ahead of this Write, with a "Superseded at" note explaining the F7 gate and cycle close completed this burst. Earlier archives (cycle-006 v3.79 Burst-1 through v3.89 Burst-11; cycle-005 v3.75-v3.78; cycle-004 v3.53-v3.74, cycle-003 v3.31-v3.52, cycle-002 v3.23-v3.29 and earlier, cycle-001 v3.05) remain at their respective `cycles/<cycle>/session-checkpoints.md` files, unchanged this burst.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-14 = F2/F3/F4; 15 = F5 CONVERGED + FIX-F5-001; 16 = F6 COMPLETE + FIX-F6-001; 17 = F7 delta-convergence PASS + FIX-F7-001; 18 = F7 human gate APPROVED + cycle-002 CLOSED; 19 = release v0.7.0-dev.3 SHIPPED; 20 = SESSION-WRAP) |
| cycle-003 burst history | `cycles/cycle-003/burst-log.md` (Burst 1 = cycle OPENED; Bursts 2-9 = F1 through F3 gates; Bursts 10-15 = F4 Waves 1-5, all 7 stories merged; Burst 16 = F5 findings fixed; Burst 17 = SESSION WRAP, F5 CONVERGED; Burst 18 = SESSION RESUMED, F6 DISPATCHED; Burst 19 = F6 COMPLETE -- PASS; Burst 20 = F7 pre-gate consistency audit; Burst 21 = F7 human gate APPROVED -- CONVERGED (DEC-332); Burst 22 = RELEASE v0.7.0-dev.4 SHIPPED, cycle-003 CLOSED (DEC-333)) |
| cycle-004 burst history | `cycles/cycle-004/burst-log.md` (Burst 1 = cycle OPENED; Burst 2 = F1 human gate APPROVED (DEC-335); Burst 3 = CRASH RECOVERY; Bursts 4-10 = F2 scoped adversarial convergence; Burst 11 = F2 HUMAN GATE APPROVED (DEC-336); Burst 12 = F3 story decomposition CONVERGED; Burst 13 = SESSION WRAP; Burst 14 = F3 HUMAN GATE APPROVED (DEC-337); Burst 15 = F4 Wave 1 DELIVERED + MERGED (DEC-338); Burst 16 = F4 Wave 2 PARTIALLY DELIVERED + SESSION WRAP; Burst 17 = Wave 2 gate PASSED, F4 COMPLETE (DEC-339); Burst 18 = F5 CONVERGED (DEC-340); Burst 19 = F6 COMPLETE (DEC-341); Burst 20 = F7 automated prep + SESSION WRAP; Burst 21 = F7 human gate PASSED -- CONVERGED (DEC-342); Burst 22 = **RELEASE v0.7.0-dev.5 SHIPPED**, **cycle-004 CLOSED (DEC-343)**) |
| cycle-005 burst history | `cycles/cycle-005/burst-log.md` (Burst 1 = cycle OPENED, F1 APPROVED (DEC-344); Burst 2 = F2 APPROVED (DEC-346) with TIGHTENING (DEC-345); Burst 3 = F3 APPROVED (DEC-347); Burst 4 = F4 Wave 1 implemented + convergence COMPLETE + PR #778 opened + SESSION WRAP -- UNBLOCKED as of cycle-006's close; **now the sole active OPEN cycle, own resume pending**) |
| cycle-006 burst history | `cycles/cycle-006/burst-log.md` (Burst 1 = cycle OPENED, F1 APPROVED (DEC-348); Burst 2 = F2 CONVERGED; Burst 3 = F2 gate APPROVED (DEC-349); Burst 4 = F3 dispatched; Burst 5 = F3 3-consecutive-clean; Bursts 6-7 = input-hash cascade RESOLVED; Burst 8 = F3 GATE APPROVED (DEC-350); Burst 9 = F4 CODE COMPLETE, Step-4.5 rounds 1-2; Burst 10 = SESSION-WRAP CORRECTION (3 findings opened/reopened); Burst 11 = STEP-4.5 CONVERGENCE, 3-consecutive-clean; Burst 12 = F4 DELIVERY COMPLETE + MERGED, PR #791 -> `develop` @ `a9168212`; **Burst 13 (2026-09-09, this Write) = F7 DELTA CONVERGENCE HUMAN GATE APPROVED (DEC-351), cycle-006 CLOSED with NO release cut, S-7.02 cycle-closing checklist executed (6 deferrals recorded, `F-PE-MED-001`/`R-F2` RESOLVED/CLOSED), pipeline position updated to cycle-005 active, Session Resume Checkpoint refreshed v3.90->v3.91**.) |
| cycle-006 F3 story-decomposition artifacts | `cycles/cycle-006/phase-f3-stories/{S-cycle6-mutants-ci-sharding.md,dependency-graph-extended.md,wave-schedule.md,wave-holdout-scenarios.md}` (all 4 artifacts verified clean via `compute-input-hash --check` as of Burst 7) |
| cycle-006 F4 delivery artifacts | `develop` @ `a9168212` (PR #791 squash-merge; `scripts/mutants-aggregate.sh` + `scripts/lib/trusted-jq.sh`; `docs/specs/cargo-mutants-policy.md` + CHANGELOG; `tests/ci_gate_completeness.rs` `EXPECTED_GUARD_TEST_COUNT` now 75; `.github/workflows/ci.yml` sharded gate live); **all 3 Step-4.5 findings + `F-PE-MED-001` + `R-F2` RESOLVED -- see `cycles/cycle-006/blocking-issues-resolved.md`** |
| cycle-006 F1/F2 spec artifacts | `phase-f1-delta-analysis/cycle-006/delta-analysis.md` + `affected-files.txt`; `research/mutation-testing-ci-large-changes-2026-09-07.md`; `phase-f2-spec-evolution/cycle-006/{architecture-delta.md,mutants-sharding-invariants.md,ci-yml-design.md,verification-delta.md}` (adversarially converged, 16 passes; human-APPROVED at the F2 gate, DEC-349) |
| cycle-006 F7 close-out evidence | This Decisions Log's `DEC-351` row (5-dimensional convergence rationale); PR #791's merged body (M-1 empirical partition evidence); `cycles/cycle-006/burst-log.md` Burst 13 |
| cycle-005 F1 delta-analysis artifacts | `phase-f1-delta-analysis/cycle-005/delta-analysis.md` + `affected-files.txt` + `artifact-mapping.md` |
| cycle-005 F2 spec-evolution artifacts | `phase-f2-spec-evolution/prd-delta-674.md`, `verification-delta-674.md`, `architecture-delta.md`; `specs/architecture/decisions/ADR-0023-markdown-mention-pure-effectful-conversion-seam.md` |
| cycle-005 F3 story-decomposition artifacts | `cycles/cycle-005/phase-f3-stories/{S-cycle5-mention-pure-conversion.md, S-cycle5-mention-resolution-wiring.md, dependency-graph-extended.md, wave-schedule.md}` |
| cycle-005 F4 wave tracking | `.factory/sprint-state.yaml` `cycle_005_adf_mentions:` section (Wave 1 `ready`, Wave 2 `blocked`) |
| cycle-005 F4 Wave-1 (Story A) delivery evidence | GitHub PR #778 (branch `feat/cycle5-mention-pure-conversion` @ `89b84a1f`); worktree `.worktrees/cycle5-mention-pure-conversion` (still mounted, not yet merged) |
| cycle-005 session checkpoints | `cycles/cycle-005/session-checkpoints.md` (v3.75-v3.78 archived) |
| cycle-006 session checkpoints | `cycles/cycle-006/session-checkpoints.md` (v3.79-v3.86, v3.88, v3.89, v3.90 archived -- v3.87 was corrected in place at Burst 10 rather than separately archived) |
| cycle-006 blocking issues resolved | `cycles/cycle-006/blocking-issues-resolved.md` (`F-PI-CRITICAL-001`, `F-PF-HIGH-001`, `F-PG-MED-001`, `F-PE-MED-001`, `R-F2`, full per-finding resolution + 7-trio convergence arc summary + cycle-close resolutions) |
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

**S-7.02 CYCLE-CLOSING CHECKLIST DEFERRALS (cycle-006 close, Burst 13, DEC-351) -- human chose RECORD DEFERRALS ONLY, NO follow-up stories opened:**

| Item | Class | Target | Reason |
|------|-------|--------|--------|
| `STALE-RED-NARRATIVE-PATTERN` | process-gap | Future self-improvement/maintenance sweep | TDD RED-phase doc comments recurrently survive into the GREEN tree -- recurring but low-severity doc hygiene; not worth a dedicated story now. |
| `EXAMINE-GLOBS-SHRINK-RESIDUAL` | process-gap | Future CI-hardening | A plaintext `examine_globs` removal drops a file from mutation scope; the existing floor guard `FLOOR=11` is too coarse -- pre-existing whitelist-model property, code-review-controlled, documented. |
| `BARE-JQ-TOKENIZER-RESIDUAL` | process-gap | Future CI-hardening (or when the scripts grow materially) | `contains_bare_jq_invocation` is a hand-rolled tokenizer, not a real parser -- verified complete against current scripts; wrapper-with-flags/general-indirection documented out-of-scope. |
| `GITHUB-OPS-WATCH-HANG` | process-gap, tooling | Factory tooling improvement (avoid `--watch` in github-ops; add a timeout) | The github-ops gh-delegation layer hung on a non-terminating `gh pr checks --watch` during PR #791's merge execution (both `pr-manager` attempts stalled; the human merged directly after the orchestrator verified state read-only) -- session-tooling reliability, not a product defect. |
| `F-PC-MED-001` | security, process-gap | Future security-hardening cycle | Deep mitigation for `untrusted-outcomes.json`'s documented code-execution / spoofed-sibling-artifact / canceling-errors trust-boundary residual (per-mutant-ID set re-derivation / sandboxed shard execution) -- accepted, code-review-controlled residual; deep fix is a substantial separate effort. |
| `CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS` | doc-hygiene | Next CI-touching PR (e.g. cycle-005 or a tiny `docs(ci)` PR) | 2 LOW stale inline comments on `develop` citing the retired "Check kill rate" step (`scripts/check-ci-gate.sh` ~L43-45, `.github/workflows/ci.yml` ~L100-101) -- stale locators only, no behavioral impact. |

**RESOLVED/CLOSED at cycle-close (Burst 13, NOT deferrals -- see Blocking Issues above for full text):** `F-PE-MED-001` (M-1 evidence now captured durably in PR #791's merged body), `R-F2` (planning-estimate truing-up, not a defect).

**cycle-006 (CLOSE + NO RELEASE, DEC-351, Burst 13, THIS BURST):** F7 5-dimensional convergence PASS; human APPROVED cycle-006's CLOSE with NO release cut. S-7.02 checklist executed (record-deferrals-only, above). `F-PE-MED-001`/`R-F2` RESOLVED/CLOSED. **cycle-006 is CLOSED.** Pipeline position: cycle-005 now the sole active OPEN cycle. See `Constraints Carried Forward` above for full detail.

**cycle-006 (earlier F1-F4 detail, historical, superseded by the CLOSE above):** F1 APPROVED (DEC-348); F2 16-pass adversarial convergence APPROVED at the gate (DEC-349); F3 story convergence (32/33/34) APPROVED at the gate (DEC-350), 5 F4 blocking preconditions BINDING, input-hash cascade (`WAVE-SCHEDULE-INPUT-HASH-DRIFT`, `WAVE-HOLDOUT-SCENARIOS-INPUT-HASH-CASCADE`) fully RESOLVED; F4 Step-4.5 reached 3-CONSECUTIVE-CLEAN via 7 trios/21 passes/6 fix rounds (round 4's comprehensive byte-pin closure resolved `F-PI-CRITICAL-001`/`F-PF-HIGH-001`/`F-PG-MED-001` together), then delivered + merged via PR #791 to `develop` @ `a9168212`. See `Constraints Carried Forward` above for full detail, including the Burst 9/10 provenance episode (fully resolved; account preserved verbatim in `cycles/cycle-006/session-checkpoints.md` v3.88 archive).

**cycle-005 (F4 Wave 1 Story A implemented, PR #778 open, now the sole active OPEN cycle, historical this burst):** Story A per-story adversarial convergence COMPLETE (3 clean passes); PR #778 OPEN, UNBLOCKED since cycle-006's close (this burst); own resume not yet actioned. See `Constraints Carried Forward` above for full detail.

**cycle-005 (F3 APPROVED + input-hash refresh + F4 wave tracking, Burst 3, condensed):** DEC-347 recorded; phase advanced F3->F4. Full text: `cycles/cycle-005/burst-log.md` Burst 3.

**cycle-005 (F2 APPROVED + F2-CLOSE INTEGRATE, Burst 2, historical):** DEC-345 (tightening) + DEC-346 (approval) recorded. Phase advanced F2->F3. **Tracked follow-ups:** `ADR-COUNT-CANONICAL-GUARD-GAP`, `FACTORY-HOOK-FUEL-EXHAUSTED` -- both non-blocking, target future engine/maintenance work.

**cycle-005 (F1 APPROVED, DEC-344, Burst 1, historical):** cycle-005 (`adf-mentions`, #674) OPENED. Human **APPROVED** the F1 scope. **Tracked follow-up (unchanged):** `VP-COUNT-RECONCILIATION`, non-blocking, target a future maintenance/self-improvement cycle.

**cycle-004 (RELEASE + CLOSE, historical):** DEC-343: PR #777 squash-merged, tag `v0.7.0-dev.5` pushed, `release.yml` SUCCESS. **cycle-004 is CLOSED.** All prior outstanding non-blocking items carried forward verbatim -- see "cycle-004 maintenance items" under `Constraints Carried Forward` above; none block cycle-005.

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

**Still open (cycle-006, Burst 10, LOW, non-blocking, unchanged -- NOT part of this burst's named 6-item S-7.02 deferral list; pre-existing standing debt):** `F-PH-LOW-001`, `F-PH-LOW-002` [process-gap], `F-PH-LOW-003`, `F-PG-LOW-002` [process-gap], `F-PI-LOW-002` -- see **Blocking Issues** above for full text.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- 165 historical stale `input-hash` artifacts factory-wide (confirmed cycle-004 F7); standing debt, **not** a cycle blocker.
- 11-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`; unchanged this burst at 11).
- `VP-COUNT-RECONCILIATION` (cycle-005 F1, unresolved) -- pre-existing base-count discrepancy, unrelated to this cycle's own correctly-counted VP-674 additions; non-blocking, target a future maintenance/self-improvement cycle.
