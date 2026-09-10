---
document_type: pipeline-state
level: ops
version: "3.97"
status: active
producer: state-manager
timestamp: 2026-09-10T00:17:11Z
phase: "cycle-005 (adf-mentions) Phase F5 (scoped adversarial refinement) -- CONVERGED: 3 consecutive clean-tier passes on the combined Wave 1+Wave 2 adf-mentions delta (Pass 2 CLEAN, Pass 3 NITPICK_ONLY, Pass 4 NITPICK_ONLY). Pass 1 was SUBSTANTIVE -- F-M1 [MED] (`@Name` mention detection wrongly treated `]` as a boundary char -> write-breaking exit-64 regression on ordinary prose like `config[env]@home`) + F-L1 [LOW] (stale dead_code allows) -- both FIXED and merged via FIX-F5-001, PR #795 @ cef4a021 (squash; CI 24/24 green incl. clean in-line mutation gate; pr-reviewer APPROVE; security-reviewer 0 findings). develop advanced 0eaf4268->befa72e6 (unrelated Dependabot merge, PR #780)->cef4a021. Zero CRITICAL/HIGH/MEDIUM remain across the delta. Next: cycle-005 Phase F6 (targeted hardening) -> Phase F7 (delta convergence, human gate) -> release decision (would ride cycle-005 + cycle-006)."
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
last_amended: "2026-09-10, v3.97, state-manager -- F5-CONVERGED-2026-09-09: recorded cycle-005 Phase F5 (scoped adversarial refinement) CONVERGENCE for the combined Wave 1+Wave 2 adf-mentions delta -- 3 consecutive clean-tier passes (Pass 2 CLEAN, Pass 3 NITPICK_ONLY, Pass 4 NITPICK_ONLY); Pass 1 was SUBSTANTIVE (F-M1 [MED] `@Name` mention-boundary false-positive admitting `]` as a start boundary, a write-breaking exit-64 regression risk on ordinary prose containing an unrelated `]` immediately before a live `@token`; F-L1 [LOW] four stale `#[allow(dead_code)]` attributes on the now-live mention API), both FIXED via fix-PR FIX-F5-001, squash-merged as PR #795 @ merge commit cef4a021 (develop advanced 0eaf4268 -> befa72e6 (unrelated intervening Dependabot merge, PR #780, not a cycle-005 event) -> cef4a021), CI 24/24 green including a clean in-line (non-escalated) mutation gate, pr-reviewer APPROVE, security-reviewer 0 findings; zero CRITICAL/HIGH/MEDIUM findings remain across the delta; added sprint-state.yaml cycle_005_adf_mentions.f5_status; recorded two new non-blocking Drift/Standing Items deferrals (CYCLE5-F5-L2-IDONLY-BRACKET-VP674005, CYCLE5-F5-P3-01-STDIN-NOINPUT); appended a Phase Progress row F5-CONVERGED-2026-09-09; archived the v3.96 Session Resume Checkpoint to cycles/cycle-005/session-checkpoints.md BEFORE writing the new v3.97 checkpoint (resume point = Phase F6 targeted hardening); recomputed wc -l and refreshed the SIZE BUDGET banner; swept the pre-existing, verified-legitimate FIX-F5-001/PR #795 delivery artifacts (code-delivery/FIX-F5-001/{pr-description,review-findings}.md, new code-delivery/FIX-F5-cycle5-mention-boundary/pr-review.md, regression-state.json, sidecar-learning.md) into this same atomic commit to factory-artifacts, pushed to origin; no DEC minted -- F5 convergence is an automated quality gate, not a gated human decision; trajectory-tail unchanged ->1->3->0->2"
current_step: "D-chain cite D-053 latest brownfield. F5-CONVERGED-2026-09-09: state-manager recorded cycle-005 Phase F5 (scoped adversarial refinement) CONVERGENCE for the combined Wave 1+Wave 2 adf-mentions delta -- Pass 1 SUBSTANTIVE (F-M1 [MED] `@Name` mention-boundary false-positive on adjacent `]`, F-L1 [LOW] stale dead_code allows) fixed via FIX-F5-001/PR #795 @ cef4a021; Passes 2/3/4 CLEAN/NITPICK_ONLY/NITPICK_ONLY -- 3 consecutive clean-tier passes, convergence criterion met; added sprint-state.yaml's cycle_005_adf_mentions.f5_status field recording the outcome and the develop tip advance (0eaf4268->befa72e6->cef4a021); recorded two new non-blocking standing items CYCLE5-F5-L2-IDONLY-BRACKET-VP674005 (LOW, id-only bracket-mention path unreachable from any wired write path) and CYCLE5-F5-P3-01-STDIN-NOINPUT (LOW, ambient no_input threading asymmetry vs handle_comment_edit, debug-only reachable); appended a Phase Progress row F5-CONVERGED-2026-09-09; archived the v3.96 Session Resume Checkpoint to cycles/cycle-005/session-checkpoints.md BEFORE writing the new v3.97 checkpoint; recomputed wc -l and refreshed the SIZE BUDGET banner; swept in the concurrently-modified, pre-existing FIX-F5-001/PR #795 delivery artifacts (pr-description.md, review-findings.md, the new code-delivery/FIX-F5-cycle5-mention-boundary/pr-review.md fresh-eyes APPROVE verdict, regression-state.json test-run scratch record, sidecar-learning.md append-only session-end markers) in this same atomic commit to factory-artifacts, pushed to origin; no DEC minted -- F5 is an automated quality gate (3-consecutive-clean-tier convergence), not a gated human decision; trajectory-tail unchanged →1→3→0→2"
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
cycle_005_status: "adf-mentions -- OPEN, active cycle, pipeline ACTIVE. Phase F1 delta analysis APPROVED (DEC-344); Phase F2 spec evolution APPROVED (DEC-345 tightening + DEC-346 approval); Phase F3 story decomposition APPROVED (DEC-347); Phase F4 (delta implementation) COMPLETE 2026-09-09 -- both waves MERGED: Wave 1 (S-cycle5-mention-pure-conversion) MERGED via the >120-mutant escape-hatch ADMIN-BYPASS, human-authorized (DEC-352): PR #778 squash-merged to develop @ 708c8b32 (develop a9168212->708c8b32); Wave 2 (S-cycle5-mention-resolution-wiring, 13 pts, HIGH) MERGED via PR #794 (squash) @ 0eaf4268 -- a NORMAL merge (develop 5b00b31e->0eaf4268, main checkout fast-forwarded): CI fully green including the cycle-006 sharded mutation gate running to completion end-to-end, NO escape-hatch, NO admin-bypass (explicit contrast to Wave 1); security-review 0 findings; pr-reviewer APPROVE (converged 1 cycle); dependency (Wave 1, PR #778) satisfied. Closes GitHub #674 (parts 1+2, in full). A standalone maintenance/enhancement PR (#793, ci/mutation-nightly-visibility, NOT a cycle-005 story, no DEC minted) squash-merged to develop as 5b00b31e between the two waves. Phase F5 (scoped adversarial refinement) of the combined Wave 1+Wave 2 delta CONVERGED 2026-09-09 -- 3 consecutive clean-tier passes (Pass 2 CLEAN, Pass 3 NITPICK_ONLY, Pass 4 NITPICK_ONLY); Pass 1 SUBSTANTIVE (F-M1 [MED] `@Name` mention-boundary false-positive on adjacent `]`, write-breaking exit-64 regression; F-L1 [LOW] stale dead_code allows), both FIXED via FIX-F5-001, squash-merged as PR #795 @ cef4a021 (develop 0eaf4268->befa72e6 (unrelated Dependabot PR #780)->cef4a021); CI 24/24 green incl. clean in-line mutation gate; pr-reviewer APPROVE; security-reviewer 0 findings. Zero CRITICAL/HIGH/MEDIUM remain across the delta. The DEC-347 interim-shippability-window tradeoff is RESOLVED/CLOSED (since Wave 2's merge). Live-Jira E2E round-trip acceptance (H-NEW-MENTION-009, AC-017) is DEFERRED to post-merge by human decision -- written and clean-skip in CI, tracked as a standing follow-up, not a required-gate skip. Next: Phase F6 (targeted hardening) -> Phase F7 (delta convergence, human gate) -> release decision (would ride cycle-005 + cycle-006). See phase-f1-delta-analysis/cycle-005/ + phase-f2-spec-evolution/{prd,verification,architecture}-delta-674.md + cycles/cycle-005/phase-f3-stories/ + .factory/sprint-state.yaml cycle_005_adf_mentions + cycles/cycle-005/burst-log.md Bursts 1-11."
cycle_006_status: "mutants-ci-sharding -- CLOSED (DEC-348/349/350/351), NO RELEASE (CI-infrastructure-only; shipped binary byte-identical; next release rides cycle-005). F1 APPROVED 2026-09-07 (DEC-348); F2 APPROVED at the gate 2026-09-07 (DEC-349, 16-pass adversarial convergence); F3 APPROVED at the gate 2026-09-08 (DEC-350, story convergence 32/33/34); F4 (delta implementation) COMPLETE + MERGED 2026-09-09 -- PR #791 squash-merged to develop @ a9168212 (Step-4.5 3-consecutive-clean via 7 trios/21 passes/6 fix rounds; pr-reviewer APPROVE; security-reviewer near-clean; all 24 CI checks passed incl. the sharded pipeline's first live production run); F5 (scoped adversarial refinement) and F6 (targeted hardening) completed with no separate human gate (feature-mode convention -- results folded into F7's evidence); F7 (delta convergence, Burst 13) reached a 5-dimensional PASS and was human-APPROVED at the gate (DEC-351), 2026-09-09, cycle CLOSED with NO release cut. S-7.02 cycle-closing checklist executed: 6 items recorded as justified deferrals at close (STALE-RED-NARRATIVE-PATTERN, EXAMINE-GLOBS-SHRINK-RESIDUAL, BARE-JQ-TOKENIZER-RESIDUAL, GITHUB-OPS-WATCH-HANG, F-PC-MED-001, CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS); F-PE-MED-001 and R-F2 marked RESOLVED/CLOSED (not deferrals). CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS was itself subsequently RESOLVED 2026-09-09 by the standalone PR #793 (@ 5b00b31e) -- see Drift/Standing Items. This cycle's mutation-gate machinery (mutants-plan/8-shard-matrix/mutants-aggregate) has now been proven three times in real production PRs: once via the >120-mutant escape hatch (PR #778, DEC-352), once running to full completion with zero escalation (PR #794, cycle-005 Wave 2), and once again running to full completion with zero escalation on a small fix diff (PR #795, cycle-005 F5). Full detail: phase-f1-delta-analysis/cycle-006/ + phase-f2-spec-evolution/cycle-006/ + cycles/cycle-006/phase-f3-stories/ + cycles/cycle-006/blocking-issues-resolved.md + cycles/cycle-006/session-checkpoints.md + cycles/cycle-006/burst-log.md Bursts 1-13 + Decisions Log DEC-348/349/350/351."
activation_head: "a9168212"
activation_version: "v0.7.0-dev.5"
---

<!-- STATE.md SIZE BUDGET (2026-09-10, cycle-005 Burst 11 -- F5 SCOPED ADVERSARIAL CONVERGED;
     line count refreshed after this burst's Write):
     cycle-005 Phase F5 (scoped adversarial refinement) of the combined Wave 1+Wave 2
     `adf-mentions` delta reached CONVERGENCE: 3 consecutive clean-tier passes (Pass 2
     CLEAN, Pass 3 NITPICK_ONLY, Pass 4 NITPICK_ONLY). Pass 1 was SUBSTANTIVE -- F-M1
     [MED] (`@Name` mention detection wrongly treated `]` as a boundary character,
     causing a write-breaking exit-64 false-positive mention-candidate detection on
     ordinary prose such as `config[env]@home`/`array[i]@ts`) + F-L1 [LOW] (four stale
     `#[allow(dead_code)]` attributes on the now-live mention API) -- both FIXED and
     delivered via fix-PR `FIX-F5-001`, squash-merged as PR #795 @ merge commit
     `cef4a021` (`develop` advanced `0eaf4268` -> `befa72e6` (unrelated intervening
     Dependabot merge, PR #780, NOT a cycle-005 event) -> `cef4a021`). CI 24/24 green
     including a clean in-line (non-escalated) mutation gate; pr-reviewer APPROVE;
     security-reviewer 0 findings. Zero CRITICAL/HIGH/MEDIUM findings remain across the
     delta.
     `pipeline:` stays ACTIVE. `phase:`/`current_step:`/`last_amended:` rewritten via
     the verbatim-strict chain, preserving `D-chain cite D-053 latest brownfield.` and
     trajectory-tail `→1→3→0→2`. `version:` 3.96 -> 3.97 (exactly one bump).
     `sprint-state.yaml`: added `cycle_005_adf_mentions.f5_status` (sibling to the
     existing `f4_status`) recording the 3-pass-clean outcome, the F-M1/F-L1 fix-PR
     evidence, the `develop` tip advance, and the two new deferrals. No story-file
     status flip needed -- F5 is a delta-scoped quality gate on already-merged code,
     not a story lifecycle transition; counts unchanged (754 BCs / 76 VPs / 118
     holdouts / 175 stories).
     Drift/Standing Items: two new non-blocking deferrals added --
     `CYCLE5-F5-L2-IDONLY-BRACKET-VP674005` (LOW, id-only bracket-mention path
     unverified vs VP-674-005, UNREACHABLE from any wired write path) and
     `CYCLE5-F5-P3-01-STDIN-NOINPUT` (LOW, `handle_comment_add`/`handle_create`/
     `handle_edit`'s live single-key path pass the AMBIENT `no_input` to
     `mentions::resolve_mentions` after a blocking stdin read, unlike
     `handle_comment_edit` which forces `no_input=true`; DEBUG-ONLY reachable --
     release-build piped stdin is non-TTY so main.rs auto-flips `no_input=true`, and
     `JR_STDIN_IS_TTY` is compiled out of release; not release-facing).
     Skip Log: no new entries this burst (F5 is an automated quality gate on an
     already-delivered delta, no optional pipeline step was skipped). Blocking Issues:
     no new open item -- F-M1/F-L1 were Pass-1 findings fixed within this same F5 pass
     (fix-PR FIX-F5-001/PR #795), the same convention as Wave 2's own Step-4.5 Pass-1
     findings, which were likewise fixed inline rather than tracked as standing
     Blocking Issues.
     `activation_head` (`a9168212`) and `activation_version` (`v0.7.0-dev.5`) are
     UNCHANGED -- no release tag was cut (the next release rides cycle-005 + cycle-006).
     `last_amended` is a full overwrite (BC-5.45.001 write-path discipline), not a
     concatenation of the prior entry.
     This Write supersedes the pre-existing, benign `stamp-state-timestamp` hook
     timestamp-only diff found on STATE.md ahead of this burst (`22:45:53Z`->
     `00:05:12Z`, unrelated to this burst's substantive content) in place -- no
     separate commit for it. This burst also SWEEPS IN, verified as legitimate and
     in-scope, the concurrently-modified/added FIX-F5-001/PR #795 delivery artifacts
     that were already staged in the working tree ahead of this burst:
     `code-delivery/FIX-F5-001/pr-description.md` and `review-findings.md` (rewritten
     to describe the F-M1/F-L1 fix, superseding stale content from an earlier,
     unrelated field-dx fix that had reused this directory name), the new
     `code-delivery/FIX-F5-cycle5-mention-boundary/pr-review.md` (fresh-eyes
     pr-reviewer APPROVE verdict for PR #795), `regression-state.json` (a fresh
     `cargo test --lib` scratch record for the F-M1 fix's regression tests), and
     `sidecar-learning.md` (further append-only `Session ended at …` markers,
     consistent with its existing pattern) -- all verified legitimate and included in
     this same atomic commit, so the factory-artifacts working tree ends CLEAN (PC-12).
     soft target 200 lines; hard cap 500 lines. 440 lines (wc-l) (this file, this
     Write). margin from soft-target = 440 - 200 = 240 (OVER the soft target;
     documented, ongoing known deviation across cycles-002/003/004/005/006, not a
     blocker). margin from actual = 500 - 440 = 60 (headroom remains before the hard
     cap).
     RECOVERY CONTEXT: no crash this burst -- a routine, fully-converged scoped
     adversarial refinement pass recorded as a normal quality-gate event. No DEC
     minted -- F5 convergence is an automated quality gate, not a gated human decision
     (unlike Wave 1's DEC-352 admin-bypass or a phase-gate approval).
     Factory lock: no `factory_lock` frontmatter block is present in this STATE.md and
     the lock-write/verify-sha-currency scripts are not provisioned in this repo -- the
     renew/unlock step this burst is therefore a no-op, noted rather than fabricated. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **Pipeline Status** | **ACTIVE** -- cycle-005 Phase F5 (scoped adversarial refinement) CONVERGED; see Session Resume Checkpoint below for detail |
| **trajectory-tail** | →1→3→0→2 (unchanged this burst) |
| **Last Updated** | trajectory-tail →1→3→0→2; unchanged this burst. Burst 11 (2026-09-09/10, cycle-005) -- F5 SCOPED ADVERSARIAL CONVERGED: 3 consecutive clean-tier passes on the combined Wave 1+Wave 2 `adf-mentions` delta; Pass 1's F-M1 [MED]/F-L1 [LOW] findings FIXED via FIX-F5-001/PR #795 @ `cef4a021`. Next: Phase F6 targeted hardening. See Session Resume Checkpoint below for full detail. |
| **Current Phase** | cycle-005 (`adf-mentions`) Phase F4 (delta implementation) **COMPLETE** (both waves merged); Phase **F5 (scoped adversarial refinement) CONVERGED** 2026-09-09 -- 3 consecutive clean-tier passes (Pass 2 CLEAN, Pass 3 NITPICK_ONLY, Pass 4 NITPICK_ONLY); Pass 1 SUBSTANTIVE (F-M1 [MED], F-L1 [LOW]) fixed via **FIX-F5-001**, PR #795 @ `cef4a021` (squash; CI 24/24 green incl. clean in-line mutation gate; pr-reviewer APPROVE; security-reviewer 0 findings). Zero CRITICAL/HIGH/MEDIUM remain. Next: Phase F6 (targeted hardening) -> Phase F7 (delta convergence, human gate). cycle-006 (`mutants-ci-sharding`) remains **CLOSED**, historical. cycle-001 through cycle-004 remain CLOSED, historical. |
| **Activation HEAD** | `a9168212` (unchanged this burst -- no release tag cut; `develop`'s real tip is `cef4a021`) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, cycles/cycle-003/burst-log.md, cycles/cycle-004/burst-log.md, cycles/cycle-005/burst-log.md, cycles/cycle-006/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **F4-WAVE1-MERGED (cycle-005, Burst 5)** | **COMPLETE / MERGED** | 2026-09-09 | >120-mutant escape hatch invoked; human **ADMIN-BYPASS** merge, explicit authorization (**DEC-352**) | Story `S-cycle5-mention-pure-conversion` (Wave 1, 13 pts) squash-merged to `develop` @ `708c8b32` via PR #778. 281 in-diff mutants (>120 threshold) correctly ESCALATED the sharded gate; all 14 other checks passed. 3-clean per-story adversarial convergence pre-merge. Wave 2 dependency SATISFIED -- UNBLOCKED. | counts unchanged (754/76/118/175); DEC-namespace clean (max ID DEC-352 as of this row) |
| **MAINTENANCE-PR-793-MERGED (standalone, Burst 6)** | **COMPLETE / MERGED** | 2026-09-09 | Normal merge (clean CI, pr-reviewer APPROVE, no escalation/admin-bypass needed) | PR #793 (`ci/mutation-nightly-visibility`) squash-merged to `develop` @ `5b00b31e`. Closes cycle-006 S-7.02 deferral `CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS`. **NOT a cycle-005 story.** | counts unchanged (754/76/118/175); no DEC minted |
| **F4-WAVE2-DISPATCH-2026-09-09 (cycle-005, Burst 8)** | **DISPATCHED** | 2026-09-09 | Human-authorized resume + dispatch, state-manager bookkeeping only | `pipeline:` PAUSED->ACTIVE; Wave 2 (`S-cycle5-mention-resolution-wiring`) dispatched to per-story delivery via worktree `feat/cycle5-mention-resolution-wiring` (created from `develop` @ `5b00b31e`); STORY-INDEX.md flipped draft->in-progress on both rows. | counts unchanged (754/76/118/175); no DEC minted |
| **F4-WAVE2-STEP45-CONVERGED (cycle-005, Burst 9)** | **CONVERGED** | 2026-09-09 | Per-story Step-4.5 (BC-5.39.001) adversarial convergence loop, no STATE.md-visible version bump (sub-phase record, not a phase transition) | 4 passes on branch `feat/cycle5-mention-resolution-wiring` (base `develop` @ `5b00b31e`, final HEAD `9dc0b098`): P1 SUBSTANTIVE (1 MEDIUM F1 non-ASCII case-fold, 1 LOW F2 discarded interactive answer) -> fixed via `7c9a52f6`/`12eb5d18`; P2/P3/P4 NITPICK_ONLY (window 3/3, LOW-3 fixed via `9dc0b098`). 2 accepted LOW deferrals (LOW-1, LOW-2). Full record: `cycles/cycle-005/S-cycle5-mention-resolution-wiring/adversary-convergence-state.json`. | counts unchanged (754/76/118/175); no DEC minted |
| **F4-WAVE2-MERGED-2026-09-09 (cycle-005, Burst 10)** | **COMPLETE / MERGED** | 2026-09-09 | Normal merge -- CI fully green incl. the cycle-006 sharded mutation gate running to completion, NO escape-hatch, NO admin-bypass (explicit contrast to Wave 1); security-review 0 findings; pr-reviewer APPROVE (converged 1 cycle) | Story `S-cycle5-mention-resolution-wiring` (Wave 2, terminal, 13 pts) squash-merged to `develop` @ `0eaf4268` (`5b00b31e`->`0eaf4268`, main fast-forwarded) via PR #794. Closes GitHub #674 (part 2, in full). Cycle-005 Phase **F4 (delta implementation) is now COMPLETE** -- both waves merged. `INTERIM-SHIPPABILITY-WINDOW-CYCLE5-W1` RESOLVED/CLOSED. | counts unchanged (754/76/118/175); no DEC minted -- a routine green merge, not a gated human decision |
| **F5-CONVERGED-2026-09-09 (cycle-005, Burst 11)** | **CONVERGED** | 2026-09-09 | Scoped adversarial refinement, 3-consecutive-clean-tier convergence, no separate human gate (feature-mode convention); F-M1/F-L1 delivered via fix-PR, no escalation needed | 4 passes on the combined Wave 1+Wave 2 `adf-mentions` delta: Pass 1 SUBSTANTIVE (F-M1 [MED] `@Name` boundary false-positive on adjacent `]`; F-L1 [LOW] stale dead_code allows) -> both FIXED via `FIX-F5-001`, squash-merged as PR #795 @ `cef4a021` (`develop` `0eaf4268`->`befa72e6`(unrelated PR #780)->`cef4a021`; CI 24/24 green incl. clean in-line mutation gate); Pass 2 CLEAN, Pass 3 NITPICK_ONLY, Pass 4 NITPICK_ONLY. Zero CRITICAL/HIGH/MEDIUM remain. Two new LOW deferrals recorded. Next: Phase F6 targeted hardening. | counts unchanged (754/76/118/175); no DEC minted -- F5 convergence is an automated quality gate |

## Current Phase Steps (cycle-005 Burst 11 -- F5 SCOPED ADVERSARIAL CONVERGED)

| Step | Status | Notes |
|------|--------|-------|
| Frontmatter: `phase:`/`current_step:`/`last_amended:` verbatim-strict chain update | **DONE** | D-chain cite `D-053 latest brownfield.` and trajectory-tail `→1→3→0→2` preserved; no meta-commentary/clause-reordering/justification-suffix added. |
| Refresh `timestamp:` to the convergence-recording instant | **DONE** | `2026-09-10T00:15:00Z`. |
| Bump `version:` exactly one: 3.96->3.97 | **DONE** | No double-bump. |
| Record F5 convergence fact: 3 consecutive clean-tier passes (2/3/4); Pass 1's F-M1/F-L1 fixed via FIX-F5-001/PR #795 @ `cef4a021` | **DONE** | `develop` advanced `0eaf4268`->`befa72e6` (unrelated Dependabot PR #780)->`cef4a021`; CI 24/24 green incl. clean in-line (non-escalated) mutation gate; pr-reviewer APPROVE; security-reviewer 0 findings. |
| `sprint-state.yaml`: add `cycle_005_adf_mentions.f5_status` (sibling to existing `f4_status`) | **DONE** | Records the 3-pass-clean outcome, F-M1/F-L1 fix-PR evidence, `develop` tip advance, two new deferrals. No count change (754/76/118/175). |
| Drift/Standing Items: add `CYCLE5-F5-L2-IDONLY-BRACKET-VP674005`/`CYCLE5-F5-P3-01-STDIN-NOINPUT` | **DONE** | Both LOW, non-blocking; carried verbatim from the orchestrator-supplied deferral facts. |
| Skip Log / Blocking Issues: no new entries | **DONE** | F5 is an automated quality gate on an already-merged delta; Pass-1 findings fixed inline via fix-PR, same convention as Wave 2's own Step-4.5 Pass-1 findings. |
| Archive v3.96 Session Resume Checkpoint to `cycles/cycle-005/session-checkpoints.md` | **DONE** | "Superseded at" note, done BEFORE writing the new checkpoint. |
| Write exactly one new v3.97 Session Resume Checkpoint | **DONE** | Reflects F5 CONVERGED, next step Phase F6 targeted hardening. |
| Append Phase Progress row `F5-CONVERGED-2026-09-09` | **DONE** | CONVERGED, agent state-manager. |
| Recompute `wc -l` and refresh SIZE BUDGET banner | **DONE** | Line-count claim + dual-margin figures updated to match exactly. |
| Sweep pre-existing FIX-F5-001/PR #795 delivery artifacts into this atomic commit | **DONE** | `code-delivery/FIX-F5-001/{pr-description,review-findings}.md` (rewritten), new `code-delivery/FIX-F5-cycle5-mention-boundary/pr-review.md`, `regression-state.json`, `sidecar-learning.md` -- all verified legitimate. |
| Single atomic commit (`factory(phase-5):`) + push to `factory-artifacts` | **DONE** | Worktree ends clean (PC-12). |

(Burst 10's cycle-005 Current Phase Steps -- F4 WAVE 2 MERGE checkpoint (frontmatter verbatim-strict chain, PR #794 merge-fact recording, STORY-INDEX/sprint-state flips, Drift/Standing Items resolution, v3.95 checkpoint archive+write, Phase Progress row, SIZE BUDGET refresh, concurrent-diff reconciliation) -- folded into this pointer note; see `cycles/cycle-005/burst-log.md` Burst 10. Burst 9's cycle-005 Current Phase Steps -- Step-4.5 per-story adversarial convergence record for `S-cycle5-mention-resolution-wiring` (write `adversary-convergence-state.json`, evaluate-and-skip the STATE.md edit that burst, update `sprint-state.yaml` status-note; deliberately no STATE.md version bump) -- folded into this pointer note; see `cycles/cycle-005/burst-log.md` Burst 9. Burst 8's cycle-005 Current Phase Steps -- F4 WAVE 2 DISPATCH checkpoint -- folded into this pointer note; see `cycles/cycle-005/burst-log.md` Burst 8. Burst 7's cycle-005 Current Phase Steps -- SESSION-WRAP PAUSE checkpoint -- similarly folded; see `cycles/cycle-005/burst-log.md` Burst 7. Burst 6's cycle-005 Current Phase Steps -- record PR #793 merge fact -- similarly folded; see `cycles/cycle-005/burst-log.md` Burst 6. Burst 5's cycle-005 Current Phase Steps -- mint DEC-352, flip STORY-INDEX.md rows, update sprint-state.yaml wave tracking -- similarly folded; see `cycles/cycle-005/burst-log.md` Burst 5. Burst 13's cycle-006 Current Phase Steps and earlier cycle-006 step history remain folded into pointer notes across the v3.79-v3.91 archives in `cycles/cycle-006/session-checkpoints.md`. Prior cycle-005/004/003/002/001 steps archived to their own `cycles/<cycle>/burst-log.md`.)

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-352 | cycle-005 (`adf-mentions`) Wave-1 story `S-cycle5-mention-pure-conversion` (PR #778) **MERGED to `develop` via the >120-mutation escape-hatch ADMIN-BYPASS**, human-authorized, 2026-09-09. Squash-merge commit `708c8b32`. `develop` advanced `a9168212`->`708c8b32`. PR #778's `src/adf.rs` diff generated **281 in-diff mutants** (> the 120-mutant escalation threshold), so the cycle-006 sharded mutation gate correctly **ESCALATED** -- the FIRST real production exercise of the cycle-006 escape hatch. All 14 other checks passed. Human reviewed split-below-120/defer/admin-bypass and chose **admin-bypass** on: (a) #778 already per-story adversarially converged (3 clean passes), pr-reviewer APPROVE, security-reviewer CLEAN (1 LOW deferred to Wave 2); (b) a local `cargo mutants --in-diff` safety-net run showed 66 caught / **0 missed** / 21 timeout (environmental) / 9 unviable; (c) the advisory nightly full-scope run remains the ongoing net. Wave 2's own PR #794 and cycle-005 F5's own PR #795 subsequently ran this SAME sharded gate to full completion with zero escalation, providing two further real production data points for the gate's calibration | Human reviewed the complete evidence package and judged the risk of merging a >120-mutant diff acceptable via admin-bypass rather than splitting the story below the threshold or deferring the merge | F4 (delivery) | 2026-09-09 | human (explicit admin-bypass authorization) |
| DEC-351 | cycle-006 (`mutants-ci-sharding`) Phase F7 (delta convergence) **HUMAN GATE APPROVED / cycle CLOSED**, 2026-09-09, **NO RELEASE**. 5-dimensional delta convergence PASS. **NO RELEASE CUT** -- cycle-006 is CI-infrastructure-only; next release rides cycle-005. Human explicitly approved closing cycle-006 with no release at the F7 gate | Human reviewed the complete 5-dimensional delta-convergence evidence package and explicitly approved closing the cycle without cutting a release | F7 (gate) | 2026-09-09 | human (explicit approval) |
| DEC-350 | cycle-006 (`mutants-ci-sharding`) Phase F3 (incremental story decomposition) **HUMAN GATE APPROVED** 2026-09-08. Story `S-cycle6-mutants-ci-sharding` reached F3 adversarial STORY convergence (3 consecutive clean passes 32/33/34). Human approved as-is. Phase advances F3->F4 | Human reviewed the complete, converged F3 story-decomposition package and approved proceeding to delta implementation with the story as-is | F3 (gate) | 2026-09-08 | human (explicit approval) |
| DEC-349 | Human **APPROVED** cycle-006 (`mutants-ci-sharding`) Phase F2 (spec evolution) at the gate, in full -- 16-pass adversarial convergence. Phase advances F2->F3 | Human reviewed the complete F2 spec-evolution artifact package and approved proceeding to incremental story decomposition with the design unchanged | F2 (gate) | 2026-09-07 | human (explicit approval) |
| DEC-348 | Human **APPROVED** cycle-006 (`mutants-ci-sharding`) Phase F1 delta analysis in full -- scope, sequencing, escape-hatch inclusion, params (8 shards, ~120-mutant threshold). **HIGH regression risk** flagged on the CI-gate machinery -- RESOLVED and live in production per DEC-351's F7 close, and exercised for real by DEC-352 above (and, at zero escalation, by PR #794 and PR #795 below). Phase advances F1->F2 | Human reviewed the F1 delta-analysis artifacts and approved proceeding to spec evolution with the captured scope/sequencing/escape-hatch/params decisions | F1 | 2026-09-07 | human (explicit approval) |
| DEC-347 | Human **APPROVED** cycle-005 (`adf-mentions`, GitHub #674) Phase F3 story decomposition in full -- 2 stories (`S-cycle5-mention-pure-conversion` Wave 1, `S-cycle5-mention-resolution-wiring` Wave 2), acyclic A->B dependency, 2 sequential waves, critical path 26 pts. Story count 172->174. Phase advances F3->F4. The accepted, time-boxed interim-shippability-window tradeoff this decision approved is now **RESOLVED/CLOSED** as of Burst 10's Wave-2 merge -- see Drift/Standing Items | Human reviewed the complete F3 decomposition and the adversarial-convergence record and approved proceeding to delta implementation with the captured 2-wave split | F3 | 2026-09-06 | human (explicit approval) |
| DEC-345 / DEC-346 (condensed) | F2-gate **TIGHTENING** (`@Name` single-result `filter_by_name_match` hard-error) plus full F2 **APPROVAL** (12 new BCs, ADR-0023, 21 VPs, 12 holdouts, spec 2.1.0->2.2.0). Phase advanced F2->F3. Full text: `cycles/cycle-005/burst-log.md` Burst 2 | (condensed this burst per the one-burst-lag compaction rule) | F2 (gate) | 2026-09-06 | human (explicit approval, both decisions) |
| DEC-344 | Human APPROVED cycle-005 Phase F1 delta analysis: two mention forms, hard-error `@Name` no-match with `\@` escape + `--no-mentions` opt-out, ambiguous-match handling, wiring incl. JSM, reverse-path update, live-Jira E2E requirement. Phase advanced F1->F2. Full text: `cycles/cycle-005/burst-log.md` Burst 1 | Human reviewed both F1 delta-analysis artifacts and approved proceeding to spec evolution | F1 | 2026-09-06 | human (explicit approval) |
| DEC-343 | Human authorized and executed the cycle-004 dev release **v0.7.0-dev.5** (PR #777 squash-merged to `develop` @ `569d85a8`, tag `v0.7.0-dev.5` pushed, `release.yml` run `34046676423` SUCCESS). cycle-004 (`windows-correctness`) is now **CLOSED** | F7 reached human-authorized CONVERGENCE at DEC-342; the human then explicitly triggered the release action | RELEASE | 2026-09-06 | human (explicit authorization) |
| (351 older cycle-004/003/002/001 decisions) | DEC-342 through DEC-309 and earlier -- unchanged this burst | -- | F1-F7/historical | 2026-08-24...2026-09-06 | various -- see `cycles/cycle-004/burst-log.md` Bursts 1-22 and `cycles/cycle-003/burst-log.md` Bursts 13-22 |

**cycle-005 note (Bursts 1-11, sole active OPEN cycle, pipeline ACTIVE, DEC-namespace clean, max ID DEC-352 -- Bursts 6/7/8/9/10/11 minted no new DEC):** **DEC-344** (F1 APPROVED, Burst 1). **DEC-345**/**DEC-346** (F2-gate TIGHTENING + APPROVED, Burst 2, condensed). **DEC-347** (F3 APPROVED, Burst 3, condensed) -- 2-wave decomposition, accepted interim-shippability-window tradeoff (now RESOLVED, see below). Wave 1 implemented + PR #778 opened, per-story adversarial convergence COMPLETE (Burst 4). **DEC-352 (Burst 5):** Wave 1 **MERGED** via the >120-mutant escape-hatch **ADMIN-BYPASS** -- PR #778 squash-merged @ `708c8b32`; Wave 2 dependency **SATISFIED**. **Burst 6 (no DEC minted):** standalone maintenance PR **#793** squash-merged @ `5b00b31e`. **Burst 7 (no DEC minted):** SESSION-WRAP PAUSE checkpoint -- `pipeline:` ACTIVE->PAUSED. **Burst 8 (no DEC minted):** human-authorized resume -- `pipeline:` PAUSED->ACTIVE; Wave 2 **DISPATCHED**. **Burst 9 (no DEC minted, no STATE.md version bump):** Wave 2's Step-4.5 per-story adversarial convergence **ACHIEVED** (4 passes, 3 consecutive clean/nitpick, HEAD `9dc0b098`). **Burst 10 (no DEC minted):** Wave 2 (`S-cycle5-mention-resolution-wiring`) **MERGED** via PR #794 (squash) @ `0eaf4268` -- a **NORMAL** merge, no escape-hatch/admin-bypass; **cycle-005 Phase F4 (delta implementation) is now COMPLETE** -- both waves merged; the DEC-347 interim-shippability-window tradeoff **RESOLVED/CLOSED**. **Burst 11 (THIS BURST, no DEC minted):** cycle-005 Phase **F5 (scoped adversarial refinement) CONVERGED** -- 3 consecutive clean-tier passes (Pass 2 CLEAN, Pass 3 NITPICK_ONLY, Pass 4 NITPICK_ONLY) on the combined Wave 1+Wave 2 `adf-mentions` delta; Pass 1 SUBSTANTIVE (F-M1 [MED] `@Name` mention-boundary false-positive on adjacent `]`, write-breaking exit-64 regression; F-L1 [LOW] stale dead_code allows), both **FIXED** and squash-merged via fix-PR `FIX-F5-001`/PR #795 @ merge commit `cef4a021` (`develop` `0eaf4268`->`befa72e6` (unrelated intervening Dependabot merge, PR #780)->`cef4a021`); CI 24/24 green incl. a clean in-line (non-escalated) mutation gate; pr-reviewer APPROVE; security-reviewer 0 findings. Zero CRITICAL/HIGH/MEDIUM findings remain across the delta. cycle-005 (`adf-mentions`, #674) remains OPEN, pipeline ACTIVE, advancing to Phase F6 (targeted hardening) -> Phase F7 (delta convergence, human gate) -> release decision (would ride cycle-005 + cycle-006).

**cycle-006 note (Bursts 1-13, CLOSED, DEC-namespace clean at close, max ID DEC-351 as of cycle-close; superseded by DEC-352 above as the factory's prior max ID):** **DEC-348** (F1 APPROVED, Burst 1). **DEC-349** (F2 gate APPROVED as-is, Burst 3). **DEC-350** (F3 gate APPROVED as-is, Burst 8) -- phase advanced F3->F4. F4 (delta implementation) reached Step-4.5 3-consecutive-clean (7 trios / 21 fresh passes / 6 fix rounds, Bursts 9-11), then was delivered and squash-merged into `develop` @ `a9168212` via PR #791 (Burst 12). **DEC-351 (Burst 13):** F5/F6 completed with no separate human gate; F7 reached a 5-dimensional PASS and the human **APPROVED cycle-006's CLOSE at the F7 gate, with NO release cut**. The S-7.02 cycle-closing checklist was executed: **RECORD DEFERRALS ONLY** -- 6 items recorded as justified deferrals (see Drift / Standing Items; 1 of the 6 subsequently RESOLVED at cycle-005 Burst 6); `F-PE-MED-001` and `R-F2` marked **RESOLVED/CLOSED**. **cycle-006 (`mutants-ci-sharding`) is CLOSED.** Full burst-by-burst detail: `cycles/cycle-006/burst-log.md` Bursts 1-13.

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
| Demo recording (cycle-005, Wave 2) | yes | Human decision this burst: demos skipped for `S-cycle5-mention-resolution-wiring` (backend/no-UI CLI), consistent with the cycle-003/cycle-004 precedent above. |
| DTU creation (cycle-006) | yes | `dtu_required: no` -- `mutants-ci-sharding` is CI-tooling only; no third-party service is being cloned. |
| UX Spec (cycle-006) | yes | `jr` is CLI-only; `mutants-ci-sharding` is a CI-workflow/policy-doc change with no product UI surface. |
| F5/F6 dedicated artifact subdirectory (cycle-006) | not skipped, folded | Feature-mode F5/F6 have no separate human gate under the feature-mode convention; their evidence was folded directly into F7's 5-dimensional convergence record (DEC-351). |

**NOT a skip (tracked standing follow-up, cycle-005 Wave 2, Burst 10):** Live-Jira E2E round-trip acceptance (`H-NEW-MENTION-009`, AC-017) is **DEFERRED to post-merge by human decision**, not skipped -- the 4 `JR_RUN_E2E`-gated scenarios are written and clean-skip in CI (inert without the gate env vars); the human will run them against their own Jira instance with `JR_E2E_MENTION_ACCOUNT_ID` set. This is a required-gate deferral, tracked here and in Drift/Standing Items, distinct from every row above (all of which are genuine, justified skips of an optional step).

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/<cycle>/blocking-issues-resolved.md. -->

**NONE OPEN.** Zero Blocking Issues remain open anywhere in the factory as of this burst. cycle-006 is **CLOSED** (DEC-351) with zero open Blocking Issues; cycle-005's Wave 1 admin-bypass merge (DEC-352), Wave 2's normal green merge (Burst 10), and Phase F5's convergence (Burst 11, F-M1/F-L1 fixed inline via FIX-F5-001/PR #795) introduce no new Blocking Issue.

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| *(none open)* | | | | | |

**RESOLVED/CLOSED at cycle-006 close (Burst 13, NOT deferrals):**
- `F-PE-MED-001` -- **CLOSED.** The Precondition-3 M-1 empirical `--list`<=>pooled partition evidence is now captured durably in PR #791's merged body.
- `R-F2` -- **CLOSED, not a defect.** The story's planning estimate `EXPECTED_GUARD_TEST_COUNT` 38->65 (AC-031) was explicitly subject to F4 re-verification; the shipped value 75 is the reconciled truth.

**RESOLVED subsequently at cycle-005 Burst 6 (2026-09-09, NOT a deferral -- one of the S-7.02 deferrals itself closed):**
- `CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS` -- **RESOLVED.** Both stale inline comments citing the retired "Check kill rate" step were fixed by standalone PR #793's diff, squash-merged to `develop` @ `5b00b31e`. See Drift / Standing Items.

Full resolution detail (including the earlier 3-finding Step-4.5 arc): `cycles/cycle-006/blocking-issues-resolved.md`.

**Still open (cycle-006, Burst 10, LOW, non-blocking, unchanged -- NOT part of the S-7.02 checklist's named 6-item deferral list; pre-existing standing debt carried forward verbatim):**
- `F-PH-LOW-001` -- add a `jq -e 'type=="object"'` shape check after each `jq empty` call in `scripts/mutants-aggregate.sh` / its self-test path.
- `F-PH-LOW-002` [process-gap] -- add a Rust subprocess test that runs `bash scripts/mutants-aggregate.sh --self-test`.
- `F-PH-LOW-003` -- tighten fixture 23's assertion substring to the exact phrase `"is malformed JSON"`.
- `F-PG-LOW-002` [process-gap] -- `tests/ci_gate_completeness.rs`'s "seven always-run jobs" prose is stale vs. the actual eight `ci-gate.needs` members.
- `F-PI-LOW-002` -- re-correct any remaining place that still characterizes `F-PF-HIGH-001` as closed by the round-2 fix alone.

**S-7.02 CYCLE-CLOSING CHECKLIST DEFERRALS (cycle-006 close, Burst 13, DEC-351):** originally 6 items; 1 (`CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS`) RESOLVED at cycle-005 Burst 6 -- 5 remain open. Full itemized table: see **Drift / Standing Items** below.

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): historical, unchanged this burst.

`cycle-002` (`field-dx`) F2-F7 COMPLETE, human-authorized at the F7 gate (DEC-311). **RELEASED 2026-09-01 as `v0.7.0-dev.3`.** Historical, unchanged this burst.

`cycle-003` (`auth-profile-dx`) F1-F7 all COMPLETE, human-approved at every gate. **RELEASED 2026-09-03 as `v0.7.0-dev.4`** (DEC-333). **cycle-003 is CLOSED** -- SHIPPED, historical, unchanged this burst.

`cycle-004` (`windows-correctness`) F1-F7 COMPLETE, human-authorized at every gate (DEC-335 through DEC-343). **RELEASED 2026-09-06 as `v0.7.0-dev.5`**; **CLOSED** -- SHIPPED, historical. Full detail: `cycles/cycle-004/burst-log.md` Bursts 1-22.

`cycle-005` (`adf-mentions`) Phase **F1 APPROVED** (DEC-344); Phase **F2 APPROVED** (DEC-345 tightening + DEC-346 approval); Phase **F3 APPROVED** (DEC-347); Phase **F4 (delta implementation) COMPLETE** 2026-09-09 -- both waves MERGED (Wave 1 PR #778 @ `708c8b32` via DEC-352 admin-bypass; Wave 2 PR #794 @ `0eaf4268` via a normal merge); Phase **F5 (scoped adversarial refinement) CONVERGED** 2026-09-09 -- 3 consecutive clean-tier passes (Pass 2 CLEAN, Pass 3 NITPICK_ONLY, Pass 4 NITPICK_ONLY) on the combined Wave 1+Wave 2 delta; Pass 1 SUBSTANTIVE (F-M1 [MED] `@Name` mention-boundary false-positive on adjacent `]`; F-L1 [LOW] stale dead_code allows), both FIXED via fix-PR `FIX-F5-001`, squash-merged as PR #795 @ `cef4a021` (`develop` `0eaf4268`->`befa72e6`(unrelated Dependabot PR #780)->`cef4a021`); CI 24/24 green incl. clean in-line mutation gate; pr-reviewer APPROVE; security-reviewer 0 findings. Zero CRITICAL/HIGH/MEDIUM remain across the delta. Closes GitHub #674 in full (via Wave 1+Wave 2). The DEC-347 interim-shippability-window tradeoff is **RESOLVED/CLOSED**. `develop`'s real tip is now `cef4a021`. Pipeline is **ACTIVE**. **cycle-005 is the sole OPEN cycle.** **Next:** Phase F6 (targeted hardening) -> Phase F7 (delta convergence, human gate) -> release decision (would ride cycle-005 + cycle-006). Full detail: `cycles/cycle-005/phase-f3-stories/` + `.factory/sprint-state.yaml` `cycle_005_adf_mentions` + `cycles/cycle-005/burst-log.md` Bursts 1-11.

`cycle-006` (`mutants-ci-sharding`) F1-F7 all **COMPLETE**, human-approved at every gate (**DEC-348 through DEC-351**). **NO RELEASE CUT** -- CI-infrastructure-only; the shipped `jr` binary is byte-identical; the next release rides cycle-005. **cycle-006 is CLOSED** -- historical. One of its 6 S-7.02 deferrals (`CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS`) was subsequently RESOLVED at cycle-005 Burst 6. Its mutation-gate machinery has now been proven three times in real production PRs (PR #778 via escape hatch; PR #794 and PR #795 each running to full completion with zero escalation). Full detail: `cycles/cycle-006/burst-log.md` Bursts 1-13 + `cycles/cycle-006/blocking-issues-resolved.md`.

**cycle-005 is the sole OPEN cycle** (Phase F4 COMPLETE, Phase F5 CONVERGED, pipeline ACTIVE); cycle-001 through cycle-004 and cycle-006 are all CLOSED, historical.

## Concurrent Cycles

Six tracked cycles. `cycle-001` is CLOSED, historical. `cycle-002` (`field-dx`) is **CLOSED + RELEASED** (2026-09-01), historical. `cycle-003` (`auth-profile-dx`) is **CLOSED + RELEASED** (2026-09-03, DEC-333) as **`v0.7.0-dev.4`** @ `42e92b46`, historical. `cycle-004` (`windows-correctness`) is **CLOSED + RELEASED** (2026-09-06, DEC-343) as **`v0.7.0-dev.5`** @ `569d85a8`, historical. `cycle-006` (`mutants-ci-sharding`) is **CLOSED, NO RELEASE** (2026-09-09, DEC-348/349/350/351) -- F1-F7 all complete; PR #791 merged to `develop` @ `a9168212`; CI-infrastructure-only, shipped binary byte-identical, next release rides cycle-005; historical. `cycle-005` (`adf-mentions`, GitHub #674) is **OPEN -- the sole active cycle** -- Phase F1 **APPROVED** (DEC-344), Phase F2 **APPROVED** (DEC-345/DEC-346), Phase F3 **APPROVED** (DEC-347), Phase F4 (delta implementation) **COMPLETE** -- both waves merged to `develop`; Phase **F5 (scoped adversarial refinement) CONVERGED** 2026-09-09 -- 3 consecutive clean-tier passes on the combined delta, Pass 1's F-M1 [MED]/F-L1 [LOW] fixed via fix-PR `FIX-F5-001`/PR #795 @ `cef4a021` (squash; CI 24/24 green incl. clean in-line mutation gate; pr-reviewer APPROVE; security-reviewer 0 findings). `develop`'s real tip is now **`cef4a021`** (`0eaf4268`->`befa72e6`(unrelated Dependabot PR #780, not a cycle-005 event)->`cef4a021`); `activation_head` frontmatter stays **`a9168212`** -- no release tag was cut. The standing auto-merge policy (DEC-330/DEC-331) and the `gh pr merge`/push MAIN-session-only constraint remain in effect for cycle-005's future fix PRs. **Pipeline is ACTIVE.** **Next:** Phase F6 (targeted hardening) -> Phase F7 (delta convergence, human gate) -> release decision (would ride both cycle-005 and cycle-006). Live-Jira E2E round-trip (`H-NEW-MENTION-009`, AC-017) DEFERRED to post-merge by human decision.

## Constraints Carried Forward

**cycle-005 (F5 SCOPED ADVERSARIAL CONVERGED, Burst 11, THIS BURST, no DEC minted):** cycle-005 Phase F5 (scoped adversarial refinement) of the combined Wave 1+Wave 2 `adf-mentions` delta reached CONVERGENCE: 4 passes total. Pass 1 SUBSTANTIVE -- F-M1 [MED] (`@Name` mention detection wrongly treated `]` as a boundary character, admitted for adjacent bracket-form mentions but with no EC backing for the `@Name` branch, causing a write-breaking exit-64 false-positive mention-candidate detection on ordinary prose such as `config[env]@home`/`array[i]@ts`, triggering an unwanted `GET /user/search` and, under the BC-X.7.009 zero-match hard-error policy, failing the entire write) + F-L1 [LOW] (four now-stale `#[allow(dead_code)]` attributes on the mention API, live since Wave 2's wiring). Both FIXED via fix-PR `FIX-F5-001`: introduces `is_at_name_boundary` (`is_mention_boundary`'s char set minus `]`), used only by the `@Name` branch of `scan_mention_spans`; the bracket-form call site in `protect_bracket_mentions` keeps `is_mention_boundary` unchanged, so adjacent bracket mentions (`[~accountid:a][~accountid:b]`) still both convert; removes the four stale dead_code allows; documents the hard-fail footgun in `CLAUDE.md`. Squash-merged as PR #795, merge commit `cef4a021` (`develop` advanced `0eaf4268` -> `befa72e6` (unrelated intervening Dependabot merge, PR #780, NOT a cycle-005 event) -> `cef4a021`). CI 24/24 green including a clean in-line (non-escalated) mutation gate; pr-reviewer APPROVE (fresh-eyes review, `code-delivery/FIX-F5-cycle5-mention-boundary/pr-review.md`); security-reviewer 0 findings. Passes 2/3/4 (reviewing the fix in place against the full combined delta) were CLEAN/NITPICK_ONLY/NITPICK_ONLY -- 3 consecutive clean-tier passes, convergence criterion met. Zero CRITICAL/HIGH/MEDIUM findings remain across the delta. `pipeline:` stays ACTIVE; `phase:`/`current_step:`/`last_amended:` refreshed via the verbatim-strict chain (D-chain cite `D-053 latest brownfield.` and trajectory-tail `→1→3→0→2` preserved); `version:` 3.96->3.97. `sprint-state.yaml`'s `cycle_005_adf_mentions.f5_status` field added (sibling to `f4_status`) recording the outcome. Drift/Standing Items: two new non-blocking deferrals added -- `CYCLE5-F5-L2-IDONLY-BRACKET-VP674005` (LOW, id-only bracket-mention path with no `attrs.text` unverified vs VP-674-005; UNREACHABLE from any wired write path, since a bracket mention always gets the BC-X.7.010 preflight -> `attrs.text` is always populated) and `CYCLE5-F5-P3-01-STDIN-NOINPUT` (LOW, pending intent verification; `handle_comment_add`/`handle_create`/`handle_edit`'s live single-key path pass the AMBIENT `no_input` to `mentions::resolve_mentions` after a `--stdin`/`--description-stdin` blocking read, unlike `handle_comment_edit` which forces `no_input=true` per EC-3.5.008-3; DEBUG-ONLY reachable -- in release builds piped `--stdin` is non-TTY so `main.rs` auto-flips `no_input=true`, and `JR_STDIN_IS_TTY` is compiled out of release, so this is NOT a release-facing bug; blast radius `interactions.rs`(comment add) + `create.rs` + `edit.rs` live path; candidate quick follow-up: mirror `handle_comment_edit`'s `if stdin { no_input = true; }` guard at the three sites). No new Blocking Issue and no new Skip Log entry -- F5 Pass-1 findings were fixed inline via the fix-PR, the same convention Wave 2's own Step-4.5 Pass-1 findings followed. The v3.96 Session Resume Checkpoint was archived to `cycles/cycle-005/session-checkpoints.md` with a "Superseded at" note ahead of this Write; exactly one new v3.97 checkpoint was written reflecting F5 CONVERGED and the next resume point (Phase F6 targeted hardening). A Burst 11 entry was appended to `cycles/cycle-005/burst-log.md`. This Write also swept, verified legitimate and in-scope, the pre-existing FIX-F5-001/PR #795 delivery artifacts staged ahead of this burst: `code-delivery/FIX-F5-001/pr-description.md` and `review-findings.md` (rewritten to describe the F-M1/F-L1 fix, superseding stale content from an earlier, unrelated field-dx fix that had reused this directory name), the new `code-delivery/FIX-F5-cycle5-mention-boundary/pr-review.md` (fresh-eyes pr-reviewer APPROVE), `regression-state.json` (fresh `cargo test --lib` scratch record for the F-M1 regression tests), and `sidecar-learning.md` (further append-only session-end markers). `activation_head`/`activation_version` unchanged (`a9168212`/`v0.7.0-dev.5`) -- no release tag cut. No DEC minted -- F5 convergence is an automated quality gate, not a gated human decision. **Pipeline is ACTIVE, cycle-005 Phase F5 CONVERGED.**

**cycle-005 (F4 WAVE 2 MERGE, Burst 10, historical, superseded in recency by the F5 convergence above):** Story `S-cycle5-mention-resolution-wiring` (Wave 2 of 2, 13 pts, HIGH) MERGED via PR #794 (squash) @ merge commit `0eaf4268`; `develop` advanced `5b00b31e`->`0eaf4268` (main checkout fast-forwarded). NORMAL merge -- CI FULLY GREEN, the cycle-006 sharded mutation gate ran COMPLETELY, NO escape-hatch, NO admin-bypass (explicit contrast to Wave 1's PR #778/DEC-352 which needed admin-bypass at 281 in-diff mutants); security-review 0 findings; pr-reviewer APPROVE (converged 1 cycle); dependency (Wave 1, PR #778) satisfied. Step-4.5 per-story adversarial convergence for Wave 2 was ACHIEVED pre-merge at Burst 9 (3 consecutive clean/nitpick — Passes 2/3/4 NITPICK_ONLY; Pass 1 SUBSTANTIVE F1 [MED non-ASCII case-fold, fixed `7c9a52f6`] + F2 [LOW interactive prompt, fixed `12eb5d18`]; LOW-3 stale citation fixed `9dc0b098`). Record: `.factory/cycles/cycle-005/S-cycle5-mention-resolution-wiring/adversary-convergence-state.json`. Closes GitHub #674 (part 2). Wave 2 is the TERMINAL story of cycle-005 Phase F4 -> **F4 (delta implementation) is now COMPLETE** (both waves merged). STORY-INDEX.md flipped `S-cycle5-mention-resolution-wiring` status in-progress->done/merged on both the registry row (~L1235) and detail row (~L1652); no count change. `sprint-state.yaml`'s `cycle_005_adf_mentions` wave_2_status/f4_status and the story entry updated to done/merged (pr:794, merge_sha:`0eaf4268`, merged_at:2026-09-09). `INTERIM-SHIPPABILITY-WINDOW-CYCLE5-W1` (DEC-347 accepted tradeoff) flipped **RESOLVED/CLOSED**. Two new non-blocking standing items added at that burst: `CYCLE5-W2-LOW-1-SPEC-PROSE` and `CYCLE5-W2-LOW-2-INTERACTIVE-TEST-GAP` (carried from Burst 9's adversarial-convergence record). No DEC minted -- a routine green merge, not a gated human decision.

**cycle-005 (Step-4.5 convergence record, Burst 9, historical):** Orchestrator recorded the completed Step-4.5 (BC-5.39.001) per-story adversarial convergence loop for `S-cycle5-mention-resolution-wiring` on branch `feat/cycle5-mention-resolution-wiring` (base `develop` @ `5b00b31e`, final HEAD `9dc0b098`) -- a sub-phase record, not a phase transition, so deliberately **no STATE.md version bump** was made that burst. 4 passes: P1 SUBSTANTIVE (1 MEDIUM F1 non-ASCII case-fold in `filter_by_name_match`, 1 LOW F2 discarded interactive answer) -> fixed via `7c9a52f6`/`12eb5d18`; P2/P3/P4 NITPICK_ONLY (window 3/3, LOW-3 stale citation fixed via `9dc0b098`). Two accepted LOW deferrals recorded (LOW-1 spec-prose, LOW-2 interactive-test-gap), folded into STATE.md's Drift/Standing Items at Burst 10. `sprint-state.yaml`'s wave/story status-note updated. Full record: `cycles/cycle-005/S-cycle5-mention-resolution-wiring/adversary-convergence-state.json`; `cycles/cycle-005/burst-log.md` Burst 9.

**cycle-005 (F4 WAVE 2 DISPATCH, Burst 8, historical):** Human authorized resuming the SESSION-WRAP pause and dispatching cycle-005 Phase F4 Wave 2 (`S-cycle5-mention-resolution-wiring`) to per-story delivery. `pipeline:` PAUSED->ACTIVE; `version:` 3.94->3.95. Worktree `feat/cycle5-mention-resolution-wiring` confirmed created from `develop` @ `5b00b31e`. STORY-INDEX.md flipped draft->in-progress on both rows. `sprint-state.yaml` updated to in-progress/dispatched. No DEC minted. Full detail: `cycles/cycle-005/burst-log.md` Burst 8.

**cycle-005 (SESSION-WRAP PAUSE, Burst 7, historical):** Human directed a wrap skill Step 4 PAUSE checkpoint. `pipeline:` ACTIVE->PAUSED; `version:` 3.93->3.94. No pipeline work occurred this burst. Full detail: `cycles/cycle-005/burst-log.md` Burst 7.

**cycle-005 (standalone maintenance PR #793 MERGED, Burst 6, historical):** A standalone maintenance/enhancement PR (`#793`, NOT a cycle-005 story) squash-merged to `develop` as `5b00b31e`, 2026-09-09T18:35Z; `develop` advanced `708c8b32`->`5b00b31e`. Closes the cycle-006 S-7.02 deferral `CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS`. No DEC minted. Full detail: `cycles/cycle-005/burst-log.md` Burst 6.

**cycle-005 (Wave 1 MERGED via >120-mutant escape-hatch ADMIN-BYPASS, DEC-352, Burst 5, historical):** Story `S-cycle5-mention-pure-conversion` (13 pts, Wave 1) reached per-story adversarial convergence (3 clean passes) pre-merge; PR #778's `src/adf.rs` diff generated 281 in-diff mutants, correctly ESCALATING the sharded mutation gate. Human chose **ADMIN-BYPASS**. PR #778 squash-merged into `develop`, merge commit `708c8b32` (`a9168212`->`708c8b32`). Wave 2 dependency **SATISFIED**. Full detail: `cycles/cycle-005/burst-log.md` Burst 5.

**cycle-006 (CLOSE + NO RELEASE, DEC-351, Burst 13, historical):** F7 (delta convergence) reached a 5-dimensional PASS and the human **APPROVED cycle-006's CLOSE at the F7 gate, with NO release cut**. **cycle-006 (`mutants-ci-sharding`) is CLOSED.** Full detail: `cycles/cycle-006/burst-log.md` Bursts 1-13.

**cycle-006 (earlier F1-F4 detail, historical):** F1 **APPROVED** (DEC-348, Burst 1); F2 **APPROVED at the gate** (DEC-349, Burst 3); F3 **APPROVED at the gate** (DEC-350, Bursts 4-8); F4 (Bursts 9-12) reached Step-4.5 3-consecutive-clean, then delivered + merged via PR #791 to `develop` @ `a9168212`. Full per-round/per-burst detail preserved verbatim in `cycles/cycle-006/burst-log.md` (Bursts 1-13) and `cycles/cycle-006/session-checkpoints.md` (v3.79 through v3.91 archives).

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

**PROCESS-GAP (cycle-005 Burst 10, historical -- factory tooling, not a jira-cli product defect):**
- **VALIDATE-COUNT-PROPAGATION-FALSE-POSITIVE** -- the `validate-count-propagation` PostToolUse hook flagged a spurious "COUNT DRIFT DETECTED: '19 BCs' in STORY-INDEX.md but '754 BCs' in STATE.md" on a plain status-field edit to `STORY-INDEX.md` that touched neither number; the `19 BCs` substring is unrelated pre-existing prose elsewhere in the file (a per-bundle BC count in a different story's summary, not a running total). The Edit persisted correctly despite the hook's `block_intent=true` report. Target: a future vsdd-factory engine fix to the hook's count-extraction heuristic (same family as `PR-MANAGER-COMPLETION-GUARD-HOOK-LOOP`/`FACTORY-HOOK-FUEL-EXHAUSTED` above).

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- 165 factory-wide stale `input-hash` artifacts confirmed via full scan (cycle-004 F7 pre-gate check, 2026-09-05; standing debt, **not** a cycle blocker).
- 11-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`; unchanged this burst at 11).
- `VP-COUNT-RECONCILIATION` (cycle-005 F1, unresolved) -- a raw grep found materially more VP ids across `bc-*.md` bodies than STATE's tracked running total; pre-existing bookkeeping-basis discrepancy, non-blocking. Target: a future maintenance/self-improvement cycle.

## Session Resume Checkpoint

**Date:** 2026-09-09/10. **Pipeline: ACTIVE.** **Position:** cycle-005 (`adf-mentions`) Phase F4 (delta implementation) is **COMPLETE** (both waves merged); Phase **F5 (scoped adversarial refinement) is CONVERGED** -- 3 consecutive clean-tier passes (Pass 2 CLEAN, Pass 3 NITPICK_ONLY, Pass 4 NITPICK_ONLY) reviewing the combined Wave 1+Wave 2 `adf-mentions` delta. Pass 1 was SUBSTANTIVE: F-M1 [MED] (`@Name` mention detection wrongly treated `]` as a boundary character, a write-breaking exit-64 regression risk on ordinary prose such as `config[env]@home`) and F-L1 [LOW] (four stale `#[allow(dead_code)]` attributes), both FIXED and delivered via fix-PR `FIX-F5-001`, squash-merged as PR #795 @ merge commit `cef4a021` (`develop` advanced `0eaf4268` -> `befa72e6` (unrelated intervening Dependabot merge, PR #780) -> `cef4a021`). CI 24/24 green including a clean in-line (non-escalated) mutation gate; pr-reviewer APPROVE; security-reviewer 0 findings. Zero CRITICAL/HIGH/MEDIUM findings remain across the delta. **NEXT action** = cycle-005 Phase F6 (targeted hardening -- formal verification/fuzz/mutation testing scoped to the delta, full regression + security scans on the full tree) -> Phase F7 (delta convergence, human gate) -> release decision (would ride both cycle-005 and cycle-006).

**Convergence counter:** cycle-005 Phase F5 (scoped adversarial refinement) is CONVERGED -- 4 passes total, 3 consecutive clean-tier (Pass 2 CLEAN, Pass 3 NITPICK_ONLY, Pass 4 NITPICK_ONLY), Pass 1's F-M1/F-L1 findings fixed via FIX-F5-001/PR #795 @ `cef4a021`. Wave 1's per-story convergence (3-clean, Burst 4) and Wave 2's per-story convergence (4 passes, 3 consecutive clean/nitpick, Burst 9, HEAD `9dc0b098`) both stand unmodified, historical. Phase F6 (targeted hardening) has not yet begun.

**In-flight work:** None -- Phase F5 is converged, no open PRs, no story mid-TDD. Phase F6 has not yet been dispatched.

**Pending human decisions / unresolved:** (1) the live-Jira E2E round-trip (`H-NEW-MENTION-009`, AC-017) is DEFERRED to post-merge by human decision -- the human will run the 4 `JR_RUN_E2E`-gated scenarios against their own Jira instance with `JR_E2E_MENTION_ACCOUNT_ID` set, at a time of their choosing; (2) `CYCLE5-F5-P3-01-STDIN-NOINPUT` is marked "pending intent verification" -- a human/product-owner call on whether the ambient-`no_input` threading asymmetry vs. `handle_comment_edit` is intentional or should be mirrored; (3) an OPEN offer to manually trigger `mutants-nightly.yml` (workflow_dispatch), unanswered; (4) the dynamic-shields kill-rate README badge remains DEFERRED (settled, do not re-open); (5) the `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` settings.json advisory. No blockers on proceeding to Phase F6.

**WIP branches:** None -- `fix/cycle5-mention-boundary-f5` merged and eligible for post-merge deletion (branch/worktree cleanup is devops-engineer's normal post-merge housekeeping, not tracked as a blocker here).

**Resume command:** `/vsdd-factory:phase-f6-targeted-hardening` (cycle-005 F6), or `/vsdd-factory:next-step` to let the orchestrator propose the next step.

**Tracked non-blocking follow-ups:** `VP-COUNT-RECONCILIATION`, `ADR-COUNT-CANONICAL-GUARD-GAP`, `FACTORY-HOOK-FUEL-EXHAUSTED`, `VALIDATE-COUNT-PROPAGATION-FALSE-POSITIVE` (all pre-existing factory-tooling items, see Drift/Standing Items). cycle-006's S-7.02 close-out deferrals: 5 remain open (unchanged, historical); the 6th, `CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS`, was RESOLVED at Burst 6 by PR #793. `INTERIM-SHIPPABILITY-WINDOW-CYCLE5-W1` remains **RESOLVED/CLOSED**; `CYCLE5-W2-LOW-1-SPEC-PROSE`/`CYCLE5-W2-LOW-2-INTERACTIVE-TEST-GAP` remain open (LOW, non-blocking). Two new items added this burst: `CYCLE5-F5-L2-IDONLY-BRACKET-VP674005` and `CYCLE5-F5-P3-01-STDIN-NOINPUT` (both LOW, non-blocking) -- see **Drift / Standing Items**. The live-Jira E2E deferral (`H-NEW-MENTION-009`/AC-017) is tracked as a standing follow-up, not a skip.

**Counts: total_bcs 754; VP count 76 tracked running total; holdout scenarios 118; total_stories 175** (all counts unchanged this burst -- an adversarial-refinement convergence event, no spec/story authorship).

**Superseded checkpoints:** the prior cycle-005 Burst-10 checkpoint (v3.96, 2026-09-09 -- F4 WAVE 2 MERGE) is superseded in place by this checkpoint and archived to `cycles/cycle-005/session-checkpoints.md` ahead of this Write, with a "Superseded at" note explaining this is the F5 convergence that followed the Wave 2 merge. Earlier archives (cycle-006 v3.79 Burst-1 through v3.91 Burst-13; cycle-005 v3.75-v3.78, v3.92 through v3.96; cycle-004 v3.53-v3.74, cycle-003 v3.31-v3.52, cycle-002 v3.23-v3.29 and earlier, cycle-001 v3.05) remain at their respective `cycles/<cycle>/session-checkpoints.md` files, unchanged this burst except for the new v3.96 archive entry.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-14 = F2/F3/F4; 15 = F5 CONVERGED + FIX-F5-001; 16 = F6 COMPLETE + FIX-F6-001; 17 = F7 delta-convergence PASS + FIX-F7-001; 18 = F7 human gate APPROVED + cycle-002 CLOSED; 19 = release v0.7.0-dev.3 SHIPPED; 20 = SESSION-WRAP) |
| cycle-003 burst history | `cycles/cycle-003/burst-log.md` (Burst 1 = cycle OPENED; Bursts 2-9 = F1 through F3 gates; Bursts 10-15 = F4 Waves 1-5, all 7 stories merged; Burst 16 = F5 findings fixed; Burst 17 = SESSION WRAP, F5 CONVERGED; Burst 18 = SESSION RESUMED, F6 DISPATCHED; Burst 19 = F6 COMPLETE -- PASS; Burst 20 = F7 pre-gate consistency audit; Burst 21 = F7 human gate APPROVED -- CONVERGED (DEC-332); Burst 22 = RELEASE v0.7.0-dev.4 SHIPPED, cycle-003 CLOSED (DEC-333)) |
| cycle-004 burst history | `cycles/cycle-004/burst-log.md` (Burst 1 = cycle OPENED; Burst 2 = F1 human gate APPROVED (DEC-335); Burst 3 = CRASH RECOVERY; Bursts 4-10 = F2 scoped adversarial convergence; Burst 11 = F2 HUMAN GATE APPROVED (DEC-336); Burst 12 = F3 story decomposition CONVERGED; Burst 13 = SESSION WRAP; Burst 14 = F3 HUMAN GATE APPROVED (DEC-337); Burst 15 = F4 Wave 1 DELIVERED + MERGED (DEC-338); Burst 16 = F4 Wave 2 PARTIALLY DELIVERED + SESSION WRAP; Burst 17 = Wave 2 gate PASSED, F4 COMPLETE (DEC-339); Burst 18 = F5 CONVERGED (DEC-340); Burst 19 = F6 COMPLETE (DEC-341); Burst 20 = F7 automated prep + SESSION WRAP; Burst 21 = F7 human gate PASSED -- CONVERGED (DEC-342); Burst 22 = **RELEASE v0.7.0-dev.5 SHIPPED**, **cycle-004 CLOSED (DEC-343)**) |
| cycle-005 burst history | `cycles/cycle-005/burst-log.md` (Burst 1 = cycle OPENED, F1 APPROVED (DEC-344); Burst 2 = F2 APPROVED (DEC-346) with TIGHTENING (DEC-345); Burst 3 = F3 APPROVED (DEC-347); Burst 4 = F4 Wave 1 implemented + convergence COMPLETE + PR #778 opened + SESSION WRAP; Burst 5 = F4 Wave 1 MERGED via the >120-mutant escape-hatch ADMIN-BYPASS (DEC-352), PR #778 @ `708c8b32`, Wave 2 UNBLOCKED; Burst 6 = standalone maintenance PR #793 MERGED @ `5b00b31e`, closes cycle-006 S-7.02 deferral, no DEC minted; Burst 7 = SESSION-WRAP PAUSE checkpoint, `pipeline:` ACTIVE->PAUSED, no DEC minted; Burst 8 = F4 WAVE 2 DISPATCH, `pipeline:` PAUSED->ACTIVE, Wave 2 dispatched via worktree `feat/cycle5-mention-resolution-wiring`, no DEC minted; Burst 9 = Wave 2 Step-4.5 per-story adversarial CONVERGENCE achieved (4 passes, HEAD `9dc0b098`), no DEC minted, no STATE.md version bump; Burst 10 = F4 WAVE 2 MERGE, Wave 2 (`S-cycle5-mention-resolution-wiring`) MERGED via PR #794 (squash) @ `0eaf4268` -- a NORMAL merge, no escape-hatch/admin-bypass; cycle-005 Phase F4 (delta implementation) now COMPLETE, both waves merged; no DEC minted; **Burst 11 (2026-09-09/10, this Write) = F5 SCOPED ADVERSARIAL CONVERGED, 3 consecutive clean-tier passes on the combined Wave 1+Wave 2 delta; Pass 1's F-M1 [MED]/F-L1 [LOW] FIXED via FIX-F5-001/PR #795 @ `cef4a021`; no DEC minted**) |
| cycle-006 burst history | `cycles/cycle-006/burst-log.md` (Burst 1 = cycle OPENED, F1 APPROVED (DEC-348); Burst 2 = F2 CONVERGED; Burst 3 = F2 gate APPROVED (DEC-349); Burst 4 = F3 dispatched; Burst 5 = F3 3-consecutive-clean; Bursts 6-7 = input-hash cascade RESOLVED; Burst 8 = F3 GATE APPROVED (DEC-350); Burst 9 = F4 CODE COMPLETE, Step-4.5 rounds 1-2; Burst 10 = SESSION-WRAP CORRECTION; Burst 11 = STEP-4.5 CONVERGENCE, 3-consecutive-clean; Burst 12 = F4 DELIVERY COMPLETE + MERGED, PR #791 -> `develop` @ `a9168212`; Burst 13 = F7 DELTA CONVERGENCE HUMAN GATE APPROVED (DEC-351), cycle-006 CLOSED with NO release cut) |
| cycle-006 F3 story-decomposition artifacts | `cycles/cycle-006/phase-f3-stories/{S-cycle6-mutants-ci-sharding.md,dependency-graph-extended.md,wave-schedule.md,wave-holdout-scenarios.md}` |
| cycle-006 F4 delivery artifacts | `develop` @ `a9168212` (PR #791 squash-merge); **all 3 Step-4.5 findings + `F-PE-MED-001` + `R-F2` RESOLVED -- see `cycles/cycle-006/blocking-issues-resolved.md`** |
| cycle-006 F1/F2 spec artifacts | `phase-f1-delta-analysis/cycle-006/delta-analysis.md` + `affected-files.txt`; `research/mutation-testing-ci-large-changes-2026-09-07.md`; `phase-f2-spec-evolution/cycle-006/{architecture-delta.md,mutants-sharding-invariants.md,ci-yml-design.md,verification-delta.md}` |
| cycle-006 F7 close-out evidence | Decisions Log `DEC-351` row; PR #791's merged body; `cycles/cycle-006/burst-log.md` Burst 13 |
| cycle-005 F1 delta-analysis artifacts | `phase-f1-delta-analysis/cycle-005/delta-analysis.md` + `affected-files.txt` + `artifact-mapping.md` |
| cycle-005 F2 spec-evolution artifacts | `phase-f2-spec-evolution/prd-delta-674.md`, `verification-delta-674.md`, `architecture-delta.md`; `specs/architecture/decisions/ADR-0023-markdown-mention-pure-effectful-conversion-seam.md` |
| cycle-005 F3 story-decomposition artifacts | `cycles/cycle-005/phase-f3-stories/{S-cycle5-mention-pure-conversion.md, S-cycle5-mention-resolution-wiring.md, dependency-graph-extended.md, wave-schedule.md}` |
| cycle-005 F4 wave tracking | `.factory/sprint-state.yaml` `cycle_005_adf_mentions:` section (Wave 1 `done`, Wave 2 `done`, `f4_status: COMPLETE`, `f5_status: CONVERGED`) |
| cycle-005 F4 Wave-1 (Story A) delivery evidence | GitHub PR #778 (squash-merged 2026-09-09, branch `feat/cycle5-mention-pure-conversion` @ `89b84a1f` -> `develop` @ `708c8b32`, DEC-352 admin-bypass); branch/worktree deleted post-merge |
| cycle-005 Wave-1 merge admin-bypass evidence | Decisions Log `DEC-352` row; `cycles/cycle-005/burst-log.md` Burst 5 |
| cycle-005 standalone maintenance PR #793 evidence (Burst 6) | GitHub PR #793 (squash-merged 2026-09-09T18:35Z, branch `ci/mutation-nightly-visibility` -> `develop` @ `5b00b31e`); `cycles/cycle-005/burst-log.md` Burst 6 |
| cycle-005 SESSION-WRAP PAUSE evidence (Burst 7) | `cycles/cycle-005/burst-log.md` Burst 7; `cycles/cycle-005/session-checkpoints.md` (v3.93 archived) |
| cycle-005 F4 Wave 2 dispatch evidence (Burst 8) | `cycles/cycle-005/burst-log.md` Burst 8; `cycles/cycle-005/session-checkpoints.md` (v3.94 archived) |
| cycle-005 F4 Wave 2 Step-4.5 convergence evidence (Burst 9) | `cycles/cycle-005/S-cycle5-mention-resolution-wiring/adversary-convergence-state.json`; `cycles/cycle-005/burst-log.md` Burst 9 |
| cycle-005 F4 Wave-2 (terminal story) delivery evidence (Burst 10) | GitHub PR #794 (squash-merged 2026-09-09, branch `feat/cycle5-mention-resolution-wiring` -> `develop` @ `0eaf4268`, normal merge, no DEC); `cycles/cycle-005/burst-log.md` Burst 10; `cycles/cycle-005/session-checkpoints.md` (v3.95 archived with "Superseded at" note) |
| cycle-005 F5 scoped adversarial convergence evidence (Burst 11, NEW this burst) | GitHub PR #795 (squash-merged 2026-09-09, branch `fix/cycle5-mention-boundary-f5` -> `develop` @ `cef4a021`, fix-PR `FIX-F5-001`, no DEC); `code-delivery/FIX-F5-001/{pr-description,review-findings}.md`; `code-delivery/FIX-F5-cycle5-mention-boundary/pr-review.md`; `cycles/cycle-005/burst-log.md` Burst 11; `cycles/cycle-005/session-checkpoints.md` (v3.96 archived with "Superseded at" note) |
| cycle-005 session checkpoints | `cycles/cycle-005/session-checkpoints.md` (v3.75-v3.78, v3.92 through v3.96 archived) |
| cycle-006 session checkpoints | `cycles/cycle-006/session-checkpoints.md` (v3.79-v3.86, v3.88, v3.89, v3.90, v3.91 archived) |
| cycle-006 blocking issues resolved | `cycles/cycle-006/blocking-issues-resolved.md` |
| cycle-006 lessons | `cycles/cycle-006/lessons.md` |
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

**cycle-005 Phase F5 scoped adversarial -- standing items (Burst 11, CONVERGED, this burst):**

| Item | Class | Target | Reason |
|------|-------|--------|--------|
| `CYCLE5-F5-L2-IDONLY-BRACKET-VP674005` | coverage, LOW, non-blocking, unreachable | none tracked — accepted | The id-only bracket-mention path (no `attrs.text`) is unverified against VP-674-005. UNREACHABLE from any wired write path: a bracket mention always receives the BC-X.7.010 mandatory preflight, which always populates `attrs.text` before conversion. |
| `CYCLE5-F5-P3-01-STDIN-NOINPUT` | correctness/coverage, LOW, non-blocking, pending intent verification | product-owner / future maintenance | `handle_comment_add`, `handle_create`, and `handle_edit`'s live single-key path all pass the AMBIENT `no_input` to `mentions::resolve_mentions` after a `--stdin`/`--description-stdin` blocking read, unlike `handle_comment_edit` which forces `no_input=true` (EC-3.5.008-3). DEBUG-ONLY reachable — in release builds piped `--stdin` is non-TTY so `main.rs` auto-flips `no_input=true`, and `JR_STDIN_IS_TTY` is compiled out of release; NOT a release-facing bug. Blast radius: `interactions.rs` (comment add) + `create.rs` + `edit.rs` live path. Candidate quick follow-up: mirror `handle_comment_edit`'s `if stdin { no_input = true; }` guard at the three sites. |

**cycle-005 Wave 2 delivery -- standing items (Burst 10, MERGE, unchanged this burst):**

| Item | Class | Target | Reason |
|------|-------|--------|--------|
| `CYCLE5-W2-LOW-1-SPEC-PROSE` | doc-hygiene, LOW, non-blocking | doc-hygiene / product-owner | BC-X.7.007 point 2 exact-match-precedence prose clarification — the implementation is correct and faithful to the mandated `partial_match` reuse; the spec wording describing the fallback order is merely unclear, not the code. Carried from Burst 9's Step-4.5 adversarial-convergence record (LOW-1). |
| `CYCLE5-W2-LOW-2-INTERACTIVE-TEST-GAP` | coverage, LOW, non-blocking, accepted limitation | none tracked — accepted | No automated test covers the interactive `dialoguer::Select` answered-then-resolves path — no TTY seam exists to drive this deterministically in the test harness. Matches the pre-existing accepted posture of `duplicate_user_disambiguation.rs`, which has the identical limitation. Carried from Burst 9's Step-4.5 adversarial-convergence record (LOW-2). |
| Live-Jira E2E round-trip (`H-NEW-MENTION-009`, AC-017) | tracked standing follow-up, NOT a skip | human, post-merge | DEFERRED to post-merge by human decision. The 4 `JR_RUN_E2E`-gated scenarios are written and clean-skip in CI (inert without `JR_RUN_E2E=1`/`JR_E2E_MENTION_ACCOUNT_ID`); the human will run them against their own Jira instance at a time of their choosing. |

**cycle-005 Wave 1 delivery -- standing items (Burst 5, DEC-352; `INTERIM-SHIPPABILITY-WINDOW-CYCLE5-W1` RESOLVED at Burst 10):**

| Item | Class | Target | Reason |
|------|-------|--------|--------|
| `INTERIM-SHIPPABILITY-WINDOW-CYCLE5-W1` | accepted tradeoff (DEC-347) | **RESOLVED/CLOSED at Burst 10 (2026-09-09)** | Wave 1 shipped the pure bracket-mention conversion WITHOUT the effectful preflight/resolution wiring (per DEC-347's accepted, time-boxed tradeoff). Wave 2's BC-X.7.010 mandatory bracket-accountId preflight + effectful resolution wiring MERGED to `develop` via PR #794 @ `0eaf4268` (Burst 10), closing the unvalidated-bracket-conversion window. **No further action.** |
| `CYCLE5-W1-LOCAL-MUTATION-VERIFY-PARTIAL` | LOW, informational | optional -- covered by the nightly net (now with visible kill-rate per PR #793) | The local in-diff mutation safety-net run for PR #778 was only partial (~96/281 mutants, environment-contention timeouts). DEC-352's admin-bypass rests on the partial-but-zero-missed local signal plus the advisory nightly full-scope net, not a completed local run. Wave 2's own mutation gate and cycle-005 F5's own PR #795 both subsequently ran to full completion with zero escalation, providing two further, cleaner production data points. |

**S-7.02 CYCLE-CLOSING CHECKLIST DEFERRALS (cycle-006 close, Burst 13, DEC-351) -- human chose RECORD DEFERRALS ONLY, NO follow-up stories opened; originally 6 items, now 5 open (1 RESOLVED, see Blocking Issues above):**

| Item | Class | Target | Reason |
|------|-------|--------|--------|
| `STALE-RED-NARRATIVE-PATTERN` | process-gap | Future self-improvement/maintenance sweep | TDD RED-phase doc comments recurrently survive into the GREEN tree -- recurring but low-severity doc hygiene; not worth a dedicated story now. |
| `EXAMINE-GLOBS-SHRINK-RESIDUAL` | process-gap | Future CI-hardening | A plaintext `examine_globs` removal drops a file from mutation scope; the existing floor guard `FLOOR=11` is too coarse -- pre-existing whitelist-model property, code-review-controlled, documented. |
| `BARE-JQ-TOKENIZER-RESIDUAL` | process-gap | Future CI-hardening (or when the scripts grow materially) | `contains_bare_jq_invocation` is a hand-rolled tokenizer, not a real parser -- verified complete against current scripts; wrapper-with-flags/general-indirection documented out-of-scope. |
| `GITHUB-OPS-WATCH-HANG` | process-gap, tooling | Factory tooling improvement (avoid `--watch` in github-ops; add a timeout) | The github-ops gh-delegation layer hung on a non-terminating `gh pr checks --watch` during PR #791's merge execution -- session-tooling reliability, not a product defect. |
| `F-PC-MED-001` | security, process-gap | Future security-hardening cycle | Deep mitigation for `untrusted-outcomes.json`'s documented code-execution / spoofed-sibling-artifact / canceling-errors trust-boundary residual -- accepted, code-review-controlled residual; deep fix is a substantial separate effort. |

**RESOLVED/CLOSED at cycle-006 close (Burst 13, NOT deferrals -- see Blocking Issues above for full text):** `F-PE-MED-001`, `R-F2`.

**RESOLVED subsequently (cycle-005 Burst 6, NOT a deferral -- see Blocking Issues above for full text):** `CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS`.

**Still open (cycle-006, Burst 10, LOW, non-blocking, unchanged -- NOT part of the S-7.02 checklist's named 6-item deferral list; pre-existing standing debt):** `F-PH-LOW-001`, `F-PH-LOW-002` [process-gap], `F-PH-LOW-003`, `F-PG-LOW-002` [process-gap], `F-PI-LOW-002` -- see **Blocking Issues** above for full text.

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

**PROCESS-GAP (cycle-005 Burst 10, historical):** see `Constraints Carried Forward` above for `VALIDATE-COUNT-PROPAGATION-FALSE-POSITIVE` full detail.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- 165 historical stale `input-hash` artifacts factory-wide (confirmed cycle-004 F7); standing debt, **not** a cycle blocker.
- 11-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`; unchanged this burst at 11).
- `VP-COUNT-RECONCILIATION` (cycle-005 F1, unresolved) -- pre-existing base-count discrepancy, unrelated to this cycle's own correctly-counted VP-674 additions; non-blocking, target a future maintenance/self-improvement cycle.
