---
document_type: session-checkpoints
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-05-08T00:00:00
cycle: "cycle-001"
inputs: [STATE.md]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Archived Session Checkpoints — cycle-001

Superseded checkpoints are archived here when STATE.md is updated with a newer one.

---

## Checkpoint archived 2026-06-09 (#474 F6+F7 ALL COMPLETE — PR #486 OPEN awaiting CI + code-owner)

_Was the active checkpoint after #474 ADF minor constructs F6+F7 completed and PR #486 was opened on feat/adf-minor-constructs-474 → base develop. Superseded when PR #486 was squash-merged → develop @ 56226b4 and issue #474 was CLOSED._

| Field | Value |
|-------|-------|
| **Date** | 2026-06-09 |
| **Position** | **#474 ADF minor constructs F1–F7 ALL COMPLETE.** subsup (^x^/~x~→ADF subsup) + heading-attr stripping (BC-7.2.007/008). F5 HYBRID: 8 Claude + Gemini cross-model, 3 CLEAN (P6/P7/P8); Gemini CRITICAL mark-leak REFUTED. F6: mutation 100% effective kill, 796+ green, deny clean. F7: consistency-validator 5/5 PASS. Code delivery: PR #486 (https://github.com/Zious11/jira-cli/pull/486), commit 1270677 on feat/adf-minor-constructs-474 → base develop. Status: PR OPEN, awaiting CI + code-owner approval. |
| **Convergence counter** | BC: 592. NFR: 41. Stories: 64. develop HEAD on origin: be6b57b (unchanged — #474 code on feat branch). Branch: feat/adf-minor-constructs-474. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. |
| **Standing context** | JR_E2E_ENABLED=true repo var set. DEC-066 retained. DEC-065 closed. Do NOT close #429 (DEC-029). OQ-5 open. E2E-PG-4 remote-link round-back open. PG-A + DRIFT-README + PG-QUEUE-1 + PG-QUEUE-2 + DEFER-469 + 3 #474 process-gap lessons deferred (all with justified dispositions in lessons.md). DEFER-469: gitleaks-action MAJOR bump PR #469 held. Non-blocking #474 follow-ups in lessons.md: (a) doc-only #[mutants::skip]+justification on markdown_to_adf if adf.rs ever enters examine_globs; (b) optional proptest round-trip for subsup. |
| **Next step** | On CI green + code-owner approval: squash-merge PR #486 → develop, close issue #474, clean up feat/adf-minor-constructs-474 worktree/branch. Then dispatch next feature cycle. |
| **Resume prompt** | `Read .factory/STATE.md. #474 ADF minor constructs: F1–F7 ALL COMPLETE. PR #486 OPEN on feat/adf-minor-constructs-474 → base develop (commit 1270677). Awaiting CI + code-owner approval. BC: 592 (BC-7.2.007/008). NFR: 41. Stories: 64. develop HEAD on origin: be6b57b. DEC-066 retained. Do NOT close #429 (DEC-029). OQ-5 open. E2E-PG-4 remote-link round-back open. PG-A + DRIFT-README + PG-QUEUE-1 + PG-QUEUE-2 + DEFER-469 deferred. jira-e2e: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. On merge: squash-merge → develop, close #474, clean worktree/branch.` |

---

## Checkpoint archived 2026-06-09 (#474 F5 CONVERGED; awaiting F6 targeted hardening)

_Was the active checkpoint after #474 ADF minor constructs F5 CONVERGED (HYBRID: 8 Claude + Gemini cross-model, 3 CLEAN passes P6/P7/P8; Gemini CRITICAL mark-leak REFUTED). BC corpus: 592 (+2: BC-7.2.007/008). Superseded when F6+F7 completed and PR #486 was opened._

| Field | Value |
|-------|-------|
| **Date** | 2026-06-09 |
| **Position** | **#474 ADF minor constructs F5 CONVERGED.** HYBRID adversarial: 8 Claude passes + Gemini cross-model (`agy`). 3 consecutive CLEAN (P6/P7/P8). Gemini CRITICAL mark-leak finding REFUTED (diff-only blindness; generic `end()`/`pop_mark` dispatch confirmed). BC corpus: 592 (+2: BC-7.2.007/008). All 8 count surfaces reconciled. 3 process-gap lessons appended to lessons.md (#474 VP-anchor guidance, subsection-count guard gap, `agy` tooling notes). Convergence record: `.factory/phase-f5-adversarial/474/convergence.md`. |
| **Convergence counter** | BC: 592. NFR: 41. Stories: 64. develop HEAD on origin: be6b57b (unchanged — #474 spec-only so far). Branch: feat/adf-minor-constructs-474. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. |
| **Standing context** | JR_E2E_ENABLED=true repo var set. DEC-066 retained. DEC-065 closed. Do NOT close #429 (DEC-029). OQ-5 open. E2E-PG-4 remote-link round-back open. PG-A + DRIFT-README + PG-QUEUE-1 + PG-QUEUE-2 + DEFER-469 deferred. Post-merge e2e.yml run 27159962721 (BULK-TRANSITION FIX) in progress at archive time. |
| **Next step** | F6 targeted hardening for #474 (`vsdd-factory:phase-f6-targeted-hardening`), then F7 delta-convergence + code-delivery PR. |
| **Resume prompt** | `Read .factory/STATE.md. #474 ADF minor constructs: F5 CONVERGED (8 Claude passes + Gemini cross-model via agy; 3 CLEAN: P6/P7/P8). Gemini CRITICAL mark-leak REFUTED. BC: 592. All 8 surfaces reconciled. Next: F6 targeted hardening. DEC-066 retained. Do NOT close #429. OQ-5 open. PG-A + DRIFT-README + PG-QUEUE-1 + PG-QUEUE-2 + DEFER-469 deferred. jira-e2e: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ.` |

---

## Checkpoint archived 2026-06-02 (develop @ 04b6b2c; S-JSM-E2E-1 CYCLE CLOSED+MERGED; awaiting first full JSM live run on next nightly)

_Was the active checkpoint when S-JSM-E2E-1 had merged (PR #460 → develop @ 04b6b2c) and JR_E2E_JSM_PROJECT=EJ was activated. Post-merge e2e run 26828126605 validated clean-skip path and non-JSM guard; 6 JSM tests clean-skipped due to env var set AFTER run start. Superseded when post-merge e2e result was recorded._

| Field | Value |
|-------|-------|
| **Date** | 2026-06-02 |
| **Position** | **S-JSM-E2E-1 CYCLE CLOSED + MERGED.** PR #460 → develop @ 04b6b2c (14:55:50Z); 11 CI GREEN; 1571/0. JR_E2E_JSM_PROJECT=EJ in jira-e2e env (14:57:01Z). Nightly e2e.yml will exercise 7 JSM scenarios. No active worktrees. |
| **Convergence counter** | BC: 585. NFR: 41. Stories: 61. develop HEAD on origin: 04b6b2c. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. DRIFT-331-PAGINATION: log-only (deferred). |
| **Standing context** | JR_E2E_ENABLED=true repo var set. DEC-065: queue tests deliberately un-contracted (S-QUEUE-BC-1 draft). Do NOT close #429 (DEC-029). OQ-5 open. E2E-PG-4 remote-link round-back open (blocked: no `jr remote-link read`). Deferred sub-gaps: --on-behalf-of (2nd customer), 401 scope hint. |
| **Next step** | S-QUEUE-BC-1 (queue BC authorship + docstring→anchor cross-check process, DEC-065). Dispatch next feature cycle. |
| **Resume prompt** | `Read .factory/STATE.md. S-JSM-E2E-1 CYCLE CLOSED+MERGED: PR #460 → develop @ 04b6b2c; 11 CI GREEN; 1571/0; BC 585 / NFR 41 UNCHANGED. JR_E2E_JSM_PROJECT=EJ active in jira-e2e env. factory-artifacts HEAD = git -C .factory log -1 --format='%h'. DEC-065: queue tests deliberately un-contracted (S-QUEUE-BC-1 draft). jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug. 61 stories / 41 NFRs / 585 BCs. Do NOT close #429 (DEC-029). OQ-5 open. E2E-PG-4 remote-link round-back open. Next: S-QUEUE-BC-1 or next feature cycle.` |

---

## Checkpoint archived 2026-06-02 (develop @ cc187cc; S-JSM-E2E-1 F3–F7 CYCLE CONVERGED; PR #460 open awaiting merge)

_Was the active checkpoint when S-JSM-E2E-1 had converged (F3–F7 complete, 11 CI GREEN, 1571/0) but PR #460 was not yet merged. Superseded when PR #460 was squash-merged to develop @ 04b6b2c and JR_E2E_JSM_PROJECT=EJ was activated._

| Field | Value |
|-------|-------|
| **Date** | 2026-06-02 |
| **Position** | **S-JSM-E2E-1 F3–F7 ALL COMPLETE — CYCLE CONVERGED. PR #460 → develop @ cc187cc; 11 CI checks GREEN; 1571/0. Awaiting human merge.** 61 stories / 41 NFRs / 585 BCs. No active worktrees. |
| **Convergence counter** | BC: 585. NFR: 41. Stories: 61. develop HEAD: cc187cc (feature branch; develop = afa12570). jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug. DRIFT-331-PAGINATION: log-only (deferred). |
| **Key artifacts** | F2 spec: `docs/specs/jsm-e2e-coverage.md` (on feature branch). Story: `.factory/stories/S-JSM-E2E-1-jsm-e2e-coverage-expansion.md`. Follow-up: `.factory/stories/S-QUEUE-BC-1-contract-queue-commands.md`. Research: `.factory/research/jsm-e2e-queue-bc-anchoring-validation.md`. |
| **Post-merge admin** | Set `JR_E2E_JSM_PROJECT=EJ` as an **environment variable** in the `jira-e2e` GitHub Environment (not a repo variable — must be env-scoped for Rust binary; already wired in e2e.yml at the "Run live E2E tests" step env: block). |
| **Deferred sub-gaps** | `--on-behalf-of` (needs 2nd customer account); `write:servicedesk-request` 401 scope hint (needs scope-stripped token). |
| **Standing context** | S-E2E-FORK-1 #459 + assign-by-query #458 both CLOSED+LIVE-GREEN. JR_E2E_ENABLED=true repo var set. JR_E2E_ISSUE_TYPE_ALT=Bug in jira-e2e env. Do NOT close #429 (DEC-029). OQ-5 open. E2E-PG-4 remote-link round-back open (blocked: no `jr remote-link read`). S-QUEUE-BC-1 draft (queue BC authorship follow-up; DEC-065). |
| **Resume prompt** | `Read .factory/STATE.md. S-JSM-E2E-1 CYCLE CONVERGED: PR #460 → develop @ cc187cc; 11 CI GREEN; 1571/0; BC 585 / NFR 41 UNCHANGED. factory-artifacts HEAD = git -C .factory log -1 --format='%h'. DEC-065: queue tests deliberately un-contracted (research-validated; S-QUEUE-BC-1 draft). Post-merge: set JR_E2E_JSM_PROJECT=EJ in jira-e2e env (environment variable, NOT repo variable). Deferred: --on-behalf-of (2nd customer), 401 scope hint. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug. 61 stories / 41 NFRs / 585 BCs. Do NOT close #429 (DEC-029). OQ-5 open. E2E-PG-4 remote-link round-back open. Next: merge PR #460, then consider S-QUEUE-BC-1.` |

---

## Checkpoint archived 2026-06-02 (develop @ afa12570; JSM E2E expansion F2-COMPLETE / F3-PENDING; DEC-064; F2 spec snapshot preserved)

_Was the active checkpoint at JSM E2E expansion F2-complete / F3-pending. Superseded when F2 spec snapshot was committed to factory-artifacts and resume checkpoint was finalized for session clear (2026-06-02)._

| Field | Value |
|-------|-------|
| **Date** | 2026-06-02 |
| **Position** | **JSM E2E expansion at F2-complete / F3-pending.** Feature cycle "JSM E2E coverage expansion (project EJ / E2E-JSM)" opened. F1 APPROVED (DEC-064) + F2 spec complete (docs/specs/jsm-e2e-coverage.md; VER-JSM-E2E-1..7 defined; spec-changelog.md [1.3.2]). Brainstorming report: .factory/planning/brainstorming-report-jsm-e2e.md. F1 delta-analysis: .factory/planning/jsm-e2e-expansion/delta-analysis.md. develop @ afa12570 (no code merged). No active worktrees. Deferred sub-gaps: --on-behalf-of (needs 2nd customer account), write:servicedesk-request 401 scope hint (scope-stripped token needed). |
| **Convergence counter** | BC corpus: 585 BCs. NFR corpus: 41 NFRs. Story corpus: 59 stories. develop HEAD: afa12570. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug. DRIFT-331-PAGINATION tracked (deferred). |
| **Resume prompt** | `Read .factory/STATE.md. JSM E2E expansion feature at F2-complete/F3-pending (DEC-064). develop HEAD = afa12570 (PR #459, S-E2E-FORK-1 CYCLE CLOSED prior). No active worktrees. factory-artifacts HEAD = git -C .factory log -1 --format='%h'. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug; set JR_E2E_JSM_PROJECT=EJ to activate JSM tests. 59 stories / 41 NFRs / 585 BCs. Do NOT close #429 (human decision, DEC-029). OQ-5 open. DRIFT-331-PAGINATION: log-only (deferred). F4 touch-points: tests/e2e_live.rs (7 gated tests), tests/e2e_cli_surface_guard.rs (4 new SURFACE rows), docs/specs/e2e-live-jira-testing.md §4/§8, CLAUDE.md E2E note.` |

---

## Checkpoint archived 2026-06-02 (develop @ afa12570; S-E2E-FORK-1 CYCLE CLOSED + LIVE-GREEN; DEC-063)

_Was the active checkpoint at E2E fork-safe CI F2-complete / F3-pending. Superseded when S-E2E-FORK-1 completed F3–F7, PR #459 squash-merged to develop @ afa12570, and LIVE-GREEN confirmed (run 26793560680, 67/0)._

| Field | Value |
|-------|-------|
| **Date** | 2026-06-02 |
| **Position** | **E2E fork-safe CI enablement feature at F2-complete / F3-pending.** Brainstorming + F1 delta-analysis APPROVED (DEC-062); F2 spec written (docs/specs/e2e-fork-safe-ci-enablement.md; VER-E2E-FORK-1..4). develop HEAD: d45ec88 (no code merged for this feature yet). No active worktrees. |
| **Convergence counter** | BC corpus: 585 BCs. NFR corpus: 41 NFRs. Story corpus: 59 stories. develop HEAD: d45ec88. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug. DRIFT-331-PAGINATION tracked (deferred). |
| **Resume prompt** | `Read .factory/STATE.md. develop HEAD = d45ec88 (PR #458, assign-by-query E2E; DEC-061). E2E fork-safe CI feature: F1 APPROVED + F2 COMPLETE (DEC-062); F3 pending. Spec: docs/specs/e2e-fork-safe-ci-enablement.md. No active worktrees. factory-artifacts HEAD = git -C .factory log -1 --format='%h'. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug. 59 stories / 41 NFRs / 585 BCs. Do NOT close #429 (human decision, DEC-029). OQ-5 open. DRIFT-331-PAGINATION: log-only (deferred). E2E-PG-4 remaining sub-gap: remote-link round-back ONLY (blocked on jr remote-link read).` |

---

## Checkpoint archived 2026-06-02 (develop @ d45ec88; assign-by-query E2E LIVE-GREEN; DEC-061; feature mode opened for E2E fork-safe CI)

_Was the active checkpoint after assign-by-query E2E (PR #458 → develop @ d45ec88; live run 26790203429 67/0). Superseded when E2E fork-safe CI enablement feature cycle opened (F1 APPROVED + F2 COMPLETE)._

| Field | Value |
|-------|-------|
| **Date** | 2026-06-02 |
| **Position** | **assign-by-query E2E LIVE-GREEN.** PR #458 → develop @ d45ec88; live run 26790203429 = 67/0. E2E-PG-4 assign-specific-user sub-gap RESOLVED. No active worktrees. |
| **Convergence counter** | BC corpus: 585 BCs. NFR corpus: 41 NFRs. Story corpus: 59 stories. develop HEAD: d45ec88. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug. DRIFT-331-PAGINATION tracked (deferred). |
| **Resume prompt** | `Read .factory/STATE.md. develop HEAD = d45ec88 (PR #458, assign-by-query E2E; DEC-061). Live e2e run 26790203429 = 67/0. No active worktrees. factory-artifacts HEAD = git -C .factory log -1 --format='%h'. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug. 59 stories / 41 NFRs / 585 BCs. Do NOT close #429 (human decision, DEC-029). OQ-5 open. DRIFT-331-PAGINATION: log-only (deferred). E2E-PG-4 remaining sub-gap: remote-link round-back ONLY (blocked on jr remote-link read).` |

---

## Checkpoint archived 2026-06-02 (develop @ ec8f6be; dev release v0.5.0-dev.13 SHIPPED; DEC-060)

_Was the active checkpoint after dev.13 release (PR #457 @ ec8f6be). Superseded when assign-by-query E2E live-green updated STATE.md to d45ec88._

| Field | Value |
|-------|-------|
| **Date** | 2026-06-01 |
| **Position** | **Dev release v0.5.0-dev.13 SHIPPED.** Branch chore/release-v0.5.0-dev.13 → PR #457 → squash-merge develop @ ec8f6be; tag v0.5.0-dev.13; run 26785757910 SUCCESS; prerelease published 2026-06-01T22:29:16Z (8 assets). No active worktrees. |
| **Convergence counter** | BC corpus: 585 BCs. NFR corpus: 41 NFRs. Story corpus: 59 stories. develop HEAD: ec8f6be. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug. DRIFT-331-PAGINATION tracked (deferred). |
| **Resume prompt** | `Read .factory/STATE.md. develop HEAD = ec8f6be (PR #457, dev release v0.5.0-dev.13 squash-merge; published 2026-06-01T22:29:16Z, 8 assets; DEC-060). #331 CLOSED + LIVE-GREEN (run 26779732719 66/0). No active worktrees. factory-artifacts HEAD = git -C .factory log -1 --format='%h'. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug. 59 stories / 41 NFRs / 585 BCs. Do NOT close #429 (human decision, DEC-029). OQ-5 open. DRIFT-331-PAGINATION: log-only (deferred 2026-06-01). E2E-PG-4 open sub-gaps: assign-specific-user, remote-link round-back.` |

---

## Checkpoint archived 2026-06-01 (develop @ f418bf5; #331 issueType LIVE-GREEN; createmeta schema fix #454+#455; run 26779732719 66/0; DRIFT-E2E-ALT RESOLVED)

_Was the active checkpoint after #331 CYCLE CLOSED (PR #453 @ 6494e27). Superseded when live-validation cycle-close updated SESSION-HANDOFF to f418bf5._

| Field | Value |
|-------|-------|
| **Date** | 2026-06-01 |
| **Position** | **#331 CYCLE CLOSED.** PR #453 squash-merged → develop @ 6494e27. Issue #331 CLOSED. Worktree + branch removed. No active worktrees. Dev release v0.5.0-dev.12 @ 432f381 (PR #451). Last live e2e: 65/0 run 26767211620 (develop @ 4fd91f1). |
| **Convergence counter** | BC corpus: 585 BCs. NFR corpus: 41 NFRs. Story corpus: 59 stories. #331 F5 trajectory: P1 BLOCKED→fix affc33a→P2/P3 CLEAN→P4 BLOCKED→fix ee3dbeb→P5/P6/P7 CLEAN. develop HEAD: 6494e27. |
| **Resume prompt** | `Read .factory/STATE.md. develop HEAD = 6494e27 (PR #453, #331 issueType bulk merged). #331 CLOSED. No active worktrees. factory-artifacts HEAD = git -C .factory log -1 --format='%h'. Last live e2e: 65/0 (run 26767211620, develop @ 4fd91f1). Dev release v0.5.0-dev.12 @ 432f381. 59 stories / 41 NFRs / 585 BCs. Do NOT close #429 (human decision, DEC-029). Held Dependabot PRs #404/#422–#426. OQ-5 open. DRIFT-E2E-ALT: issueType E2E gated test awaits JR_E2E_ISSUE_TYPE_ALT in jira-e2e env.` |

---

## Checkpoint archived 2026-06-01 (develop @ 4fd91f1; E2E-PG-4 priority/worklog/unassign DONE; label chain DONE; dev.12 shipped)

_Was the active checkpoint after PR #452 merged (bulk-priority fix + priority/worklog/unassign E2E). Superseded when session-resume checkpoint refreshed at session close._

| Field | Value |
|-------|-------|
| **Date** | 2026-06-01 |
| **Position** | **[VERIFIED] Priority/worklog/unassign E2E + bulk-priority fix CLOSED. PR #452 squash-merged to develop @ 4fd91f1. Live run 26767211620 = 65/0; all 4 new gated tests green. Bulk `issue edit --priority` now uses priorityId schema (name→id via GET /rest/api/3/priority), validated live first-try. DEC-054 CLOSED. 58 stories / 41 NFRs / 583 BCs.** |
| **Convergence counter** | E2E-PG-4 priority/worklog/unassign complete. Live run 26767211620 = 65/0. BUG-LABEL-400 RESOLVED. Dev release v0.5.0-dev.12 @ 432f381 (DEC-053). Bulk priorityId schema live-green (DEC-054). BC corpus: 583 BCs (unchanged). NFR corpus: 41 NFRs. Story corpus: 58 stories. |
| **Resume prompt** | `Read .factory/STATE.md. PR #452 merged → develop @ 4fd91f1: priority/worklog/unassign E2E + bulk-priority fix. Live run 26767211620 = 65/0 (all 4 new tests green). Bulk issue edit --priority → {priorityId} schema validated live first-try. Remaining E2E-PG-4 sub-gaps: assign to specific other user, remote-link round-back (blocked on jr remote-link read), issueType bulk schema (#331 deferred). Dev release v0.5.0-dev.12 @ 432f381 (tag, DEC-053). Open backlog: #210, #331, #368, #372, #387, #400 (Story B), #429. Dependabot PRs #404/#422/#423/#424/#425/#426 held. DEC-029 deferred to human (do NOT close #429). OQ-5 open (NFR-O-N doc drift). 58 stories / 41 NFRs / 583 BCs.` |

---

## Checkpoint archived 2026-05-12 (PR #357 CONVERGED @ 144aaff, awaiting human merge)

_Was the active checkpoint after PR #357 R2 returned 0 new comments. Superseded when PR #357 merged @ d208a6d._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-12 |
| **Position** | **PR #356 MERGED** @ 9acf01d (closes #334; 2026-05-12T01:37:46Z; CWE-117 sanitize_for_stderr; 19 rounds; 36/36 threads resolved). **PR #357 CONVERGED** @ 144aaff (closes #335; chore/release-gate-jr-base-url-335; R2 review id 4268805775 @ 2026-05-12T02:52:59Z: 0 inline comments; Phase 8 stop condition; 2 rounds; trajectory 3→0; 3/3 threads resolved; 1248 tests passed; CI 8/8 green; awaiting human merge approval). **8 audit-followups remain after #335 closes: #331, #333, #336, #340, #343, #345, #346, #350.** Sub-lesson: "Perplexity validates APPROACH; grep validates SURFACE AREA." |
| **Convergence counter** | 3/3 CONVERGED Phase 2-adv; Phase 3-adv: Wave 2 gate CLOSED; Feature Mode #110-pr2 F5 CONVERGED; PRs #351–#356 MERGED; **PR #357 CONVERGED @ 144aaff (closes #335; trajectory 3→0; stop condition R2; awaiting merge)** |

---

## Checkpoint archived 2026-05-11 (PR #352 CONVERGED, awaiting human merge)

_Was the active checkpoint after PR #352 Round 2 returned 0 new comments. Superseded when PR #352 merged and PR #353 opened._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-11 |
| **Position** | **PR #352 CONVERGED (Round 2 returned 0 new comments at 2026-05-11T15:25:48Z), awaiting human merge.** Branch: chore/docs-cleanup-337-341-347 @ f42bfa5. PR state: OPEN, MERGEABLE/CLEAN, 8/8 CI green, 3/3 threads resolved (from R1), 0 new R2 comments. Closes #337+#341+#347 on merge. Convergence trajectory: 3→0. Next action: merge PR #352 (human merge required). 15 audit-followups remain after #337+#341+#347 close on merge: #331, #332, #333, #334, #335, #336, #338, #340, #342, #343, #345, #346, #350. |
| **Convergence counter** | 3/3 CONVERGED Phase 2-adv; Phase 3-adv: Wave 2 gate CLOSED; Feature Mode #110-pr2 F5 CONVERGED (12→5→0→0→0); PR #351 MERGED (2→1→0 / rebase / 0); PR #352 CONVERGED Round 2 (3→0) |

---

## Checkpoint archived 2026-05-11 (PR #351 paused mid-round-2)

_Was the active checkpoint from Wave 3 CLOSED (2026-05-09). Superseded when PR #351 mid-session pause state was recorded._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-09 |
| **Position** | **WAVE 3 CLOSED — 10/10 stories complete**. Final story S-3.03 v2 MERGED at PR #321 / 597dd23. All Wave 3 stories: S-3.10 (proptest rewrite + parse_duration deletion) + S-3.06 (spec-counts script) + S-3.07 (rate-limit cap + JRACLOUD-94632) + S-3.05 (asset enrichment concurrency cap) + S-3.09 (PKCE deferral closure) + S-3.08 (DOCUMENT-AS-IS LOW NFR closures) + S-3.02 (cli/assets shard split) + S-3.01 (cli/auth shard split) + S-3.04 (multi-cloudId disambiguation) + S-3.03 v2 (auto-refresh + single-flight). Phase 3 progress: **32/32 (100% v2 scope)**. develop @ 811fbc7 (v0.5.0-dev.9 bump PR #322; underlying Wave 3 closure code at 597dd23 / S-3.03 v2); factory-artifacts @ this commit. Notable Wave 3 deliverables: closed 11 LOW NFRs (S-3.08); closed H-018 + H-027 + H-047 KNOWN-GAP→MUST-PASS; resolved DRIFT-001 codification; refactored 1,055 + 2,245 LOC into 14 module files; verified canonical wording for 4 NFR docs against Atlassian sources (Perplexity-driven). 6 PRs merged (#313-#321) + 1 factory-only closure (S-3.09). |
| **Convergence counter** | 3/3 CONVERGED Phase 2-adv; Phase 3-adv: Wave 2 gate CLOSED (adversary pass-01 `ded2210` + consistency pass-01 `4918e6e` + pass-02 `8ae5511`) |

---

## Checkpoint archived 2026-05-08 (Wave 1 COMPLETE update)

_Was the active checkpoint when S-1.08 state-manager dispatch ran._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-08 |
| **Position** | S-1.07 merged (PR #301 at 5813059). Wave 1 progress: 7/8 (87.5%). Active story: S-1.08 (keychain round-trip holdout — final Wave 1 story). Wave 1 will complete on S-1.08 merge. Open deferred: R1-001, R1-002, S-0.03-S1, S-0.05-F1, S-0.05-F2 (TO_VERIFY), S-0.05-F3, S-1.02-DEFER, S-1.03-DEFER (body-tracing → Wave 2), S-1.04-DEFER-01/02/03, S-1.05-DEFER-01 (Node.js 24 deadline Jun 2026). Manual user action still pending: AC-001 repo Settings → Code security → Secret scanning. Wave 0 holdouts active: H-045, H-046, H-036, H-NEW-MP-001, H-NEW-VERBOSE-001/002; H-NEW-AUTH-002 gated behind JR_RUN_RELEASE_AUTH_GATE_TEST=1. |
| **Convergence counter** | 3/3 CONVERGED (Phase 2-adv; Pass 13 CLEAN-PASS — final trajectory: 14→5→5→5→4→5→4→4→4→1→0→1→0) |

---

_Archived 2026-05-20. Was the active checkpoint entering #388 Feature Mode._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-20 |
| **Position** | **Dependabot maintenance sweep COMPLETE.** 4 Dependabot PRs merged to develop after 7-day soak: #374 (cargo-deny-action 2.0.17→2.0.18 @ aac5ff4), #377 (open 5.3.4→5.3.5 @ cb3436a), #376 (assert_cmd 2.2.1→2.2.2 @ b2d066b), #375 (clap_complete 4.6.2→4.6.5 @ a66d664). All published 2026-05-11 (9-day soak), CI green. #327 (rand 0.9.4→0.10.1) DEFERRED — breaking 0.x major bump, failing CI, needs migration. Remaining open backlog issues: #210, #331, #372, #387. Open PRs: #327, #368. Previous state: #385 F1–F7 COMPLETE (PR #395 @ f7fc8c3, 2026-05-20). Next: next feature from open backlog or #327 migration (human directs). |
| **Convergence counter** | #385 F7 CONVERGED (prior). BC corpus: 575 BCs (spec v1.2.0). Story corpus: 43 stories. Maintenance-only burst — no BC/story changes. |

---

_Archived 2026-05-20. Was the active checkpoint entering #388 F2 (Spec Evolution)._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-20 |
| **Position** | **Issue #388 Feature Mode — F1 COMPLETE, entering F2 (Spec Evolution).** F1 gate APPROVED by human 2026-05-20. Delta: 2 new BCs (BC-3.4.010, BC-3.4.011) in bc-3-issue-write.md; BC-3.4.003 annotation-only update; BC-INDEX 575→577. 1 new story to be created in F3. New test file tests/issue_edit_type_errors.rs; T-06 in tests/issue_edit_no_parent.rs to be strengthened. Next: F2 Spec Evolution (product-owner updates bc-3-issue-write.md with BC-3.4.010/011 full bodies + BC-3.4.003 annotation; PRD delta document). Remaining open backlog: #210, #331, #372, #387, #388. Open PRs: #327, #368. |
| **Convergence counter** | #388 F1 COMPLETE (prior #385 F7 CONVERGED). BC corpus: 575 BCs (spec v1.2.0; will become 577 after F2). Story corpus: 43 stories. |

---

_Archived 2026-05-21. Was the active checkpoint entering #388 F4 (Delta Implementation)._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-20 |
| **Position** | **Issue #388 Feature Mode — F3 COMPLETE, entering F4 (Delta Implementation).** F3 gate APPROVED by human 2026-05-20. S-388 created: `.factory/stories/S-388-cross-hierarchy-type-change-error-and-fake-endpoint-fix.md` — 7 ACs, single story, single wave, no dependencies, implementation_strategy: tdd. STORY-INDEX 43→44 (v1.4.16). BC corpus: 577 BCs (spec v1.3.0). Test plan: 10 integration tests (tests/issue_edit_type_errors.rs) + T-06 strengthening (tests/issue_edit_no_parent.rs). F2 recap: 2 new BCs (BC-3.4.010 CROSS_HIERARCHY_HINT/JRACLOUD-27893, BC-3.4.011 typo-hint-or-raw); BC-3.4.003 annotated; BC-INDEX 575→577; spec v1.2.0→v1.3.0; adv CONVERGED 10 passes (3 CLEAN P8/P9/P10); CV PASS 6/6; 3 PG-388 process-gaps recorded. Next: F4 — per-story TDD delivery of S-388. Remaining open backlog: #210, #331, #372, #387, #388. Open PRs: #327, #368. |
| **Convergence counter** | #388 F3 COMPLETE. BC corpus: 577 BCs (spec v1.3.0). Story corpus: 44 stories (S-388 in F4 — implementation in progress). |

---

_Archived 2026-05-20. Was the active checkpoint entering #388 F3 (Incremental Story)._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-20 |
| **Position** | **Issue #388 Feature Mode — F2 COMPLETE, entering F3 (Incremental Story).** F2 gate APPROVED by human 2026-05-20. 2 new BCs authored: BC-3.4.010 (cross-hierarchy 400 → CROSS_HIERARCHY_HINT, JRACLOUD-27893) + BC-3.4.011 (same-hierarchy/unresolvable/indeterminate 400 → typo hint or raw error). BC-3.4.003 annotated with Errors cross-ref. BC-INDEX 575→577. Spec v1.2.0→v1.3.0 (MINOR; changelog written). Adversarial spec review CONVERGED: 10 passes total, 3 consecutive CLEAN (passes 8/9/10); 2 CRITICAL + ~15 MAJOR + many MINOR fixed in passes 1–7. Fresh-context consistency-validator PASS (6/6 checks). Inline proptest for `is_cross_hierarchy_type_error` pure classifier (no VP-NNN artifacts). Test plan: 10 integration tests (tests/issue_edit_type_errors.rs) + T-06 strengthening (tests/issue_edit_no_parent.rs). 3 F2 process-gaps (PG-388-1/2/3) logged to lessons.md. Next: F3 — Incremental Story decomposition (1 story covering BC-3.4.010/011 + test deliverables). Remaining open backlog: #210, #331, #372, #387, #388. Open PRs: #327, #368. |
| **Convergence counter** | #388 F2 COMPLETE. BC corpus: 577 BCs (spec v1.3.0). Story corpus: 43 stories (1 new story to be created in F3). |

---

_Archived 2026-05-21. Was the active checkpoint at issue #388 F4 COMPLETE. Superseded by F7 CONVERGED checkpoint._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-21 |
| **Position** | **Issue #388 Feature Mode — F4 COMPLETE. Issue #388 CLOSED.** PR #397 squash-merged @ e0ea24b (2026-05-21). Red Gate VERIFIED (9/10 integration tests + proptest + T-06 correctly red pre-impl; test #10 `.expect(0)` regression-guard exception documented). Per-story adversary CONVERGED: 4 passes (pass 1 found 1 MAJOR — `--no-parent` arm surfaced fabricated English error instead of real Jira error, fixed fd0cdd5; passes 2/3/4 CLEAN). 5 VHS demo scenarios + evidence-report.md at docs/demo-evidence/S-388/ covering all 7 ACs. CI: first run caught mutation-testing gap (85%, 1 surviving mutant at create.rs:898) — fixed by `test_no_parent_non_subtask_400_does_not_surface_cross_hierarchy_hint`; second run 10/10 green. pr-reviewer APPROVE cycle 1 (0 blocking). Security review CLEAN. Worktree `.worktrees/S-388` and branch removed. STORY-INDEX S-388 → completed. BC corpus: 577 BCs (spec v1.3.0). Remaining open backlog: #210, #331, #372, #387. Open PRs: #327, #368. Next: next feature from open backlog (human directs). |
| **Convergence counter** | #388 F4 COMPLETE (cycle CLOSED). BC corpus: 577 BCs (spec v1.3.0). Story corpus: 44 stories (all delivered). |

---

_Archived 2026-05-27. Was the active checkpoint at S-408 MERGED. Superseded by S-409 IN-PROGRESS checkpoint._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-27 |
| **Position** | **S-408 MERGED — cycle closed.** PR #417 merged 2026-05-27 (develop @ d53278a). 5 stale line-anchor citations re-anchored to symbol-form. 1 Copilot cycle (path-prefix inconsistency; fixed bfa333d; re-review clean). Issue #408 auto-closed. Symbol-form citation convention now active in CLAUDE.md. STORY-INDEX v1.4.24. Held Dependabot PRs #403/#404 due 2026-05-31. Open backlog: #210, #331, #368, #372, #387, #400, #409. |
| **Convergence counter** | S-408 MERGED (CYCLE CLOSED). BC corpus: 583 BCs (unchanged). Story corpus: 50 stories. All feature-mode cycles since Wave 3 CONVERGED. |

---

_Archived 2026-05-27. Was the active checkpoint at S-409 IN-PROGRESS. Superseded by S-409 MERGED checkpoint._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-27 |
| **Position** | **S-409 IN-PROGRESS — awaiting PR.** Worktree `refactor/S-409-extract-number-wire-helper` off develop @ d53278a. Implementation commit 71dc2d4: extract `parsed_number_to_wire_value` helper (field_resolve.rs) + 6 inline unit tests + delete tautological integration test 38 (tests/issue_edit_field.rs). 2 files, 82 ins / 59 del. No BC changes. STORY-INDEX v1.4.25 (50→51). Open backlog: #210, #331, #368, #372, #387, #400. Held Dependabot PRs #403/#404 due 2026-05-31. |
| **Convergence counter** | S-409 IN-PROGRESS (commit 71dc2d4; pre-PR). BC corpus: 583 BCs (unchanged). Story corpus: 51 stories. All feature-mode cycles through S-408 CONVERGED. |

---

_Archived 2026-05-28. Was the active checkpoint at S-428 F1+F2 COMPLETE / F3 PENDING. Superseded by S-428 MERGED checkpoint._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-28 |
| **Position** | **#428 mid-cycle (F1+F2 COMPLETE, F3 PENDING).** Story file at `.factory/stories/S-428-wiremock-only-disambiguation.md` (12 ACs, SMALL/3pt). Delta analysis at `.factory/phase-f1-delta-analysis/issue-428/delta-analysis.md` (v2 revised). 4 design decisions locked (DEC-027/DEC-028). Next was: worktree `fix/S-428-wiremock-only-disambiguation` off develop @ 9369d35-OR-newer, test-writer for failing in-process tests in `tests/multi_cloudid_disambiguation.rs` covering tests #4/#5/#6 with in-process `resolve_cloud_id` calls, then implementer for the refactor in `src/api/auth.rs` (extract `resolve_cloud_id`, lift `AccessibleResource`, update CLAUDE.md atomically). Open backlog: #210, #331, #368, #372, #387, #400, #428, #429. Held Dependabot PRs #404/#422/#423/#424/#425/#426 due 2026-05-31. |
| **Convergence counter** | S-428 F1+F2 complete; F3 pending. BC corpus: 583 BCs (unchanged — no new BCs in S-428). Story corpus: 53 stories (added S-428). |

---

_Archived 2026-05-28. Was the active checkpoint at S-428 MERGED. Superseded by S-400-A MERGED checkpoint._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-28 |
| **Position** | **S-428 COMPLETE. Develop @ e1706d4 (PR #430 squash-merged, issue #428 auto-closed).** No active mid-cycle story. Open backlog: #210, #331, #368, #372, #387, #400, #429. Held Dependabot PRs #404/#422/#423/#424/#425/#426 due 2026-05-31. #429 deferred-WONTFIX-pending (DEC-029) — do NOT close #429 autonomously. Next active work: either pick next backlog item or let Dependabot PRs land 2026-05-31. |
| **Convergence counter** | S-428 MERGED. BC corpus: 583 BCs (unchanged — no new BCs in S-428). Story corpus: 53 stories. No active story. |

---

_Archived 2026-05-28. Was the active checkpoint at S-400-A MERGED. Superseded by v0.5.0-dev.11 released checkpoint._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-28 |
| **Position** | **S-400-A COMPLETE. Develop @ 9d4a78b (PR #431 squash-merged, #400 stays OPEN).** No active mid-cycle story. Open backlog: #210, #331, #368, #372, #387, #400, #429. Held Dependabot PRs #404/#422/#423/#424/#425/#426 due 2026-05-31. #429 WONTFIX-pending (DEC-029) — do NOT close #429 autonomously. #400 Story B (PG-398-1) + engine items (PG-398-4/5) remain open. |
| **Convergence counter** | S-400-A MERGED (TEST-ONLY). BC corpus: 583 BCs (unchanged). Story corpus: 53 stories. No active story. |
| **Resume prompt** | `Read .factory/STATE.md latest checkpoint. S-400-A is closed (PR #431 @ 9d4a78b); #400 stays OPEN (Story B + PG-398-4/5). Open backlog: #210, #331, #368, #372, #387, #400, #429. Held Dependabot PRs #404/#422/#423/#424/#425/#426 due 2026-05-31. Issue #429 WONTFIX decision deferred to human (DEC-029). Next: pick #400 Story B, another backlog item, or advise on Dependabot strategy.` |

---

_Archived 2026-05-29. Was the active checkpoint at v0.5.0-dev.11 RELEASED. Superseded by E2E feature F1+F2 COMPLETE checkpoint._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-28 (UTC 2026-05-29) |
| **Position** | **Dev release v0.5.0-dev.11 SHIPPED. Develop @ 15bf305 (PR #432 squash-merged, annotated tag v0.5.0-dev.11 pushed).** No active mid-cycle story. Open backlog: #210, #331, #368, #372, #387, #400 (Story B), #429. Held Dependabot PRs #404/#422/#423/#424/#425/#426 due 2026-05-31. #429 WONTFIX-pending (DEC-029) — do NOT close #429 autonomously. #400 Story B (PG-398-1) + engine items (PG-398-4/5) remain open. |
| **Convergence counter** | v0.5.0-dev.11 released. BC corpus: 583 BCs (unchanged). Story corpus: 53 stories. No active story. |

---

_Archived 2026-05-29. Was the active checkpoint at E2E feature F1+F2+F3 COMPLETE. Superseded by E2E F5 CONVERGED checkpoint._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-29 |
| **Position** | **E2E Feature Mode: F1 APPROVED + F2 COMPLETE + F3 COMPLETE. Story S-E2E-1 created (12 ACs, MEDIUM/8SP, draft). Design spec on feat/e2e-live-jira-testing @ c3e967a. Next: F4 delta implementation (TDD).** 54 stories / 41 NFRs. Develop @ 15bf305 (v0.5.0-dev.11). Open backlog: #210, #331, #368, #372, #387, #400 (Story B), #429. Held Dependabot PRs #404/#422/#423/#424/#425/#426 due 2026-05-31. #429 WONTFIX-pending (DEC-029) — do NOT close #429 autonomously. File provisioning GitHub issue (R-NEW-1) before F4. |
| **Convergence counter** | E2E feature F1+F2+F3 complete. BC corpus: 583 BCs (unchanged). NFR corpus: 41 NFRs. Story corpus: 54 stories (+1 S-E2E-1). |
| **Resume prompt** | `Read .factory/STATE.md. E2E feature (Feature Mode, DEC-032): F1✓ F2✓ F3✓ (story S-E2E-1, 12 ACs, draft). Design spec: docs/specs/e2e-live-jira-testing.md on feat/e2e-live-jira-testing @ c3e967a. Next: F4 delta implementation (TDD). File provisioning GitHub issue (R-NEW-1) before F4. 54 stories / 41 NFRs. Develop @ 15bf305 (v0.5.0-dev.11). Dependabot PRs held until 2026-05-31. DEC-029 deferred to human (do NOT close #429).` |

---

_Archived 2026-05-29. Was the active checkpoint after E2E F5 CONVERGED. Superseded by S-E2E-1 MERGED (F7) checkpoint._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-29 |
| **Position** | **E2E Feature Mode: F1✓ F2✓ F3✓ F4✓ F5✓ (CONVERGED, 3 consecutive CLEAN). Next: F6 targeted hardening.** Branch feat/e2e-live-jira-testing; 10 commits (cdf4dcf..f78eed2); zero src/ changes. Story S-E2E-1 (12 ACs, MEDIUM/8SP). 54 stories / 41 NFRs. Develop @ 15bf305 (v0.5.0-dev.11). Open backlog: #210, #331, #368, #372, #387, #400 (Story B), #429. Held Dependabot PRs #404/#422/#423/#424/#425/#426 due 2026-05-31. #429 WONTFIX-pending (DEC-029) — do NOT close #429 autonomously. File provisioning GitHub issue (R-NEW-1) before F6/F7 merge. |
| **Convergence counter** | E2E F5 CONVERGED (7 passes, 3 consecutive CLEAN). BC corpus: 583 BCs. NFR corpus: 41 NFRs. Story corpus: 54 stories. |
| **Resume prompt** | `Read .factory/STATE.md. E2E feature (Feature Mode, DEC-032): F1✓ F2✓ F3✓ F4✓ F5✓ (CONVERGED, 3 consecutive CLEAN; DEC-033). Next: F6 targeted hardening on feat/e2e-live-jira-testing. 10 commits, zero src/ changes. 54 stories / 41 NFRs. Develop @ 15bf305 (v0.5.0-dev.11). Dependabot PRs held until 2026-05-31. DEC-029 deferred to human (do NOT close #429). File provisioning GitHub issue (R-NEW-1) before F6/F7 merge.` |

---

_Archived 2026-05-29. Was the active checkpoint after S-E2E-1 MERGED (F7 CONVERGED). Superseded by S-E2E-2 MERGED + live GREEN checkpoint._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-29 |
| **Position** | **S-E2E-1 MERGED (PR #433 @ d484f84) via full VSDD Feature Mode F1–F7.** E2E machinery on develop but INERT until jira-e2e secrets provisioned (R-NEW-1, manual). 54 stories / 41 NFRs / 583 BCs. Develop @ d484f84. Open backlog: #210, #331, #368, #372, #387, #400 (Story B), #429. Held Dependabot PRs #404/#422/#423/#424/#425/#426 due 2026-05-31. #429 WONTFIX-pending (DEC-029) — do NOT close #429 autonomously. Open follow-up: OQ-5 (NFR-O-N doc drift). |
| **Convergence counter** | S-E2E-1 F7 CONVERGED + MERGED. BC corpus: 583 BCs. NFR corpus: 41 NFRs. Story corpus: 54 stories. |
| **Resume prompt** | `Read .factory/STATE.md. S-E2E-1 MERGED (PR #433 @ d484f84) via full VSDD Feature Mode F1–F7 (DEC-032/033/034). E2E INERT until R-NEW-1 provisioned (jira-e2e GitHub Environment + secrets). Next: provisioning (R-NEW-1, ops), or next backlog item. Open: OQ-5 (NFR-O-N doc drift — file GitHub issue). DEC-029 deferred to human (do NOT close #429). Dependabot PRs #404/#422/#423/#424/#425/#426 held until 2026-05-31. 54 stories / 41 NFRs. Develop @ d484f84.` |

---

_Archived 2026-05-29. Was the active checkpoint after S-E2E-2 MERGED + live GREEN (run 26658705120, 20/0). Superseded by OQ-1 RESOLVED + board 3 + run 26659977426 checkpoint._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-29 |
| **Position** | **E2E feature DELIVERED + OPERATIONAL.** S-E2E-1 (PR #433 @ d484f84) + S-E2E-2 (PR #434 @ 2ca9fc1) MERGED. Live e2e.yml GREEN (run 26658705120, 20/0). Provisioning complete (e2e profile OAuth + jira-e2e GitHub env + ES project + board 1). 55 stories / 41 NFRs / 583 BCs. Develop @ 2ca9fc1. Open backlog: #210, #331, #368, #372, #387, #400 (Story B), #429. Held Dependabot PRs #404/#422/#423/#424/#425/#426 due 2026-05-31. #429 WONTFIX-pending (DEC-029) — do NOT close #429 autonomously. Open: OQ-1 (sprint coverage — team-managed board, LOW); OQ-5 (NFR-O-N doc drift). |
| **Convergence counter** | S-E2E-2 F7 CONVERGED + MERGED. BC corpus: 583 BCs. NFR corpus: 41 NFRs. Story corpus: 55 stories. |
| **Resume prompt** | `Read .factory/STATE.md. E2E feature DELIVERED + OPERATIONAL (run 26658705120, 20/0). S-E2E-1 (#433 @ d484f84) + S-E2E-2 (#434 @ 2ca9fc1) merged. Provisioning complete (e2e profile, jira-e2e env, ES project, board 1). OQ-1 open (sprint coverage on team-managed board — LOW, no code change needed). OQ-5 open (NFR-O-N doc drift — file GitHub issue). DEC-029 deferred to human (do NOT close #429). Dependabot PRs #404/#422/#423/#424/#425/#426 held until 2026-05-31. 55 stories / 41 NFRs / 583 BCs. Develop @ 2ca9fc1.` |

---

_Archived 2026-05-30. Was the active checkpoint after OQ-1 RESOLVED (DEC-036; board 3; run 26659977426 20/0). Superseded by E2E-enh F3 stories authored (S-E2E-3/4/5) checkpoint._

| Field | Value |
|-------|-------|
| **Date** | 2026-05-29 |
| **Position** | **E2E feature DELIVERED + FULLY OPERATIONAL (incl. sprint coverage).** S-E2E-1 (PR #433 @ d484f84) + S-E2E-2 (PR #434 @ 2ca9fc1) MERGED. Board recreated as company-managed Scrum (id 3); JR_E2E_BOARD_ID 1→3; live run 26659977426: 20/0, sprint tests RUN+PASS. OQ-1 RESOLVED (DEC-036). 55 stories / 41 NFRs / 583 BCs. Develop @ 2ca9fc1. Open backlog: #210, #331, #368, #372, #387, #400 (Story B), #429. Held Dependabot PRs #404/#422/#423/#424/#425/#426 due 2026-05-31. #429 WONTFIX-pending (DEC-029) — do NOT close #429 autonomously. OQ-5 open (NFR-O-N doc drift). |
| **Convergence counter** | E2E FULLY OPERATIONAL post-OQ-1 resolution. BC corpus: 583 BCs. NFR corpus: 41 NFRs. Story corpus: 55 stories. |
| **Resume prompt** | `Read .factory/STATE.md. E2E FULLY OPERATIONAL (run 26659977426, 20/0, sprint tests RUN+PASS on board 3). OQ-1 RESOLVED (DEC-036). S-E2E-1 (#433) + S-E2E-2 (#434) merged. OQ-5 open (NFR-O-N doc drift — file GitHub issue). DEC-029 deferred to human (do NOT close #429). Dependabot PRs #404/#422/#423/#424/#425/#426 held until 2026-05-31. 55 stories / 41 NFRs / 583 BCs. Develop @ 2ca9fc1.` |

---

_Archived 2026-06-01. Was the active checkpoint during #331 F5+F6+F7 (AWAITING HUMAN MERGE GATE). Superseded by #331 CYCLE CLOSED checkpoint._

| Field | Value |
|-------|-------|
| **Date** | 2026-06-01 |
| **Position** | #331 issueType bulk schema: F1-F6 ALL COMPLETE. F5 CONVERGED (3 clean: P5/P6/P7; 7 findings fixed across P1+P4). F6 PASS (mutation 11/12=91.7%, deny PASS, no-unsafe, regression 1568/0; Mutant B killed by 723ccd7). F7 convergence IN PROGRESS — AWAITING HUMAN MERGE GATE. Worktree fix/issue-331-issuetype-bulk @ 723ccd7 (base develop @ 4fd91f1). Prior: E2E-PG-4 + label/priority/worklog/unassign COMPLETE (live 65/0, run 26767211620). Dev release v0.5.0-dev.12 @ 432f381 (PR #451). |
| **Convergence counter** | Live e2e run 26767211620 = 65/0 (develop @ 4fd91f1). BC corpus: 585 BCs. NFR corpus: 41 NFRs. Story corpus: 59 stories. #331 F5 trajectory: P1→BLOCKED (1C+3I)→fix affc33a→P2-P3 CLEAN→P4→BLOCKED (3 findings)→fix ee3dbeb→P5/P6/P7 CLEAN. CONVERGED. |
| **Next step** | Human merge gate: create PR fix/issue-331-issuetype-bulk → develop (HEAD 723ccd7; 4 commits: 3cff3c7, affc33a, ee3dbeb, 723ccd7). Run full CI. Merge. Live e2e run to confirm issueType bulk live-green (requires JR_E2E_ISSUE_TYPE_ALT env var in jira-e2e environment). Then close #331. Other open backlog: #210, #368, #372, #387, #400 (Story B), #429 (human-decision-only, DEC-029). Dependabot PRs #404/#422–#426 held. OQ-5 open (NFR-O-N doc drift). |
| **Key lessons** | (a) PRE-RESEARCH exact Atlassian wire schema before implementation. (b) Adversary dispatch MUST include captured diff + HEAD self-check — wrong-tree misread occurred twice (P1 original + P5 original); DEC-056 codifies mitigation. (c) Orchestrator runs ALL git/gh ops itself (DEC-047). (d) Mutation testing catches test-gaps that code review misses: F6 identified Mutant B (`&&`→`||`) that code review and the adversary both missed. |
| **Resume prompt** | `Read .factory/STATE.md. develop HEAD = 4fd91f1 (PR #452). Active worktree: .worktrees/issue-331 (branch fix/issue-331-issuetype-bulk @ 723ccd7) — #331 F5 CONVERGED + F6 PASS + F7 IN PROGRESS. AWAITING HUMAN MERGE GATE (PR fix/issue-331-issuetype-bulk → develop). Live e2e = 65/0 (run 26767211620). BUG-LABEL-400 RESOLVED. Dev release v0.5.0-dev.12 @ 432f381. 59 stories / 41 NFRs / 585 BCs. Do NOT close #429 (human decision, DEC-029). Dependabot PRs #404/#422–#426 held. OQ-5 open (NFR-O-N doc drift).` |

---

## Checkpoint archived 2026-06-01 (develop @ f418bf5; #331 issueType LIVE-GREEN; DRIFT-E2E-ALT RESOLVED)

_Was the active checkpoint after #331 live-validation cycle-close (PR #455 @ f418bf5). Superseded when Dependabot 6-PR merge batch updated develop HEAD to 403582e7._

| Field | Value |
|-------|-------|
| **Date** | 2026-06-01 |
| **Position** | **#331 issueType LIVE-GREEN.** PR #455 (fix: createmeta issueTypes + offset pagination) → develop @ f418bf5. PR #454 (ci: wire JR_E2E_ISSUE_TYPE_ALT into e2e.yml) → develop @ 1ee7040 (parent of #455). Live run 26779732719 = 66/0: test_e2e_issue_edit_issuetype_multikey_bulk_roundtrip PASSES live. DRIFT-E2E-ALT RESOLVED. No active worktrees. |
| **Convergence counter** | BC corpus: 585 BCs. NFR corpus: 41 NFRs. Story corpus: 59 stories. develop HEAD: f418bf5. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug. DRIFT-331-PAGINATION tracked (deferred). |
| **Next step options** | (A) E2E-PG-4 remaining open sub-gaps: assign-to-specific-other-user, remote-link round-back (requires `jr remote-link read`). (B) Open backlog: #210, #368, #372, #387, #400 (Story B), #429 (human-decision-only, DEC-029). (C) Held Dependabot PRs #404/#422–#426 (review/merge). (D) Optional dev.13 release bundling #452–#455. (E) OQ-5 open (NFR-O-N doc drift, file GitHub issue). |
| **Key lessons** | (a) PRE-RESEARCH exact Atlassian RESPONSE schema (not just request schema) against the OpenAPI spec before implementing any deserializer — wiremock encoding our own assumed shape gives false confidence (L-331-LIVE-1). (b) Adversary dispatch MUST include captured diff + HEAD self-check (DEC-056). (c) Orchestrator runs ALL git/gh ops itself (DEC-047). (d) Live E2E is the backstop; a gated test caught a defect that 3 clean F5 passes + 91.7% mutation + green CI all missed. |
| **Resume prompt** | `Read .factory/STATE.md. develop HEAD = f418bf5 (PR #455, #331 issueType live-fix merged). #331 CLOSED + LIVE-GREEN (run 26779732719 66/0). No active worktrees. factory-artifacts HEAD = git -C .factory log -1 --format='%h'. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug. Dev release v0.5.0-dev.12 @ 432f381. 59 stories / 41 NFRs / 585 BCs. Do NOT close #429 (human decision, DEC-029). Held Dependabot PRs #404/#422–#426. OQ-5 open. DRIFT-331-PAGINATION: log-only (deferred 2026-06-01). E2E-PG-4 open sub-gaps: assign-specific-user, remote-link round-back.` |

---

## Checkpoint archived 2026-06-01 (develop @ 403582e7; Dependabot 6-PR batch COMPLETE; #331 LIVE-GREEN)

_Was the active checkpoint after Dependabot 6-PR merge batch. Superseded when dev release v0.5.0-dev.13 shipped (develop HEAD → ec8f6be)._

| Field | Value |
|-------|-------|
| **Date** | 2026-06-01 |
| **Position** | **Dependabot 6-PR merge batch COMPLETE.** PRs #404/#424/#422/#423/#426/#425 all merged to develop via code-owner approval after 7-day soak from version publish date. develop HEAD: 403582e7 (PR #425 actions/checkout 6.0.2). #331 CLOSED + LIVE-GREEN (run 26779732719 66/0). No active worktrees. |
| **Convergence counter** | BC corpus: 585 BCs. NFR corpus: 41 NFRs. Story corpus: 59 stories. develop HEAD: 403582e7. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug. DRIFT-331-PAGINATION tracked (deferred). |
| **Next step options** | (A) E2E-PG-4 remaining open sub-gaps: assign-to-specific-other-user, remote-link round-back (requires `jr remote-link read`). (B) Open backlog: #210, #368, #372, #387, #400 (Story B), #429 (human-decision-only, DEC-029). (C) Dependabot PRs #404/#422–#426 MERGED (DEC-059). (D) Optional dev.13 release bundling #452–#455. (E) OQ-5 open (NFR-O-N doc drift, file GitHub issue). |
| **Key lessons** | (a) Dependabot soak = 7 days from version PUBLISH DATE, not PR-open age (DEC-059). (b) PRE-RESEARCH exact Atlassian RESPONSE schema before implementing any deserializer — wiremock encoding assumed shape gives false confidence (L-331-LIVE-1). (c) Adversary dispatch MUST include captured diff + HEAD self-check (DEC-056). (d) Live E2E is the backstop; a gated test caught a defect that 3 clean F5 passes + 91.7% mutation + green CI all missed. |
| **Resume prompt** | `Read .factory/STATE.md. develop HEAD = 403582e7 (PR #425, Dependabot checkout 6.0.2, final of 6 Dependabot merges). Dependabot PRs #404/#422–#426 ALL MERGED (DEC-059, 7-day soak from publish date). #331 CLOSED + LIVE-GREEN (run 26779732719 66/0). No active worktrees. factory-artifacts HEAD = git -C .factory log -1 --format='%h'. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug. Dev release v0.5.0-dev.12 @ 432f381. 59 stories / 41 NFRs / 585 BCs. Do NOT close #429 (human decision, DEC-029). OQ-5 open. DRIFT-331-PAGINATION: log-only (deferred 2026-06-01). E2E-PG-4 open sub-gaps: assign-specific-user, remote-link round-back.` |

---

## Checkpoint archived 2026-06-03 (develop @ 8ec9527; S-JSM-RESOLUTION-REQUIRED MERGED + LIVE-GREEN)

_Was the active checkpoint after PR #465 squash-merged and post-merge e2e.yml run 26909701606 JSM suite 73/0. Superseded when JSM resolution-chain cycle-close + lessons codification completed._

| Field | Value |
|-------|-------|
| **Date** | 2026-06-03 |
| **Position** | **S-JSM-RESOLUTION-REQUIRED COMPLETE + MERGED + LIVE-GREEN.** The full JSM resolution-enforcement chain (S-JSM-E2E-1/2/3 + S-JSM-RESOLUTION-REQUIRED) is COMPLETE. PR #465 squash-merged → develop @ 8ec9527 (20:01:51Z). Post-merge e2e.yml run 26909701606 SUCCESS: JR_E2E_JSM_PROJECT=EJ ACTIVE; test_e2e_jsm_resolution_enforcement EXECUTED LIVE (not skipped) and PASSED; full JSM suite 73/0 (110.55s). First live proof BC-3.2.013 works against real Jira: positive path sets fields.resolution; enforcement path exits 64 + "--resolution" hint on done-category without --resolution. Write scenarios self-closed (S-JSM-E2E-2/3 teardown); no orphaned EJ tickets. Remote branch + local worktree cleaned up. Note: local develop checkout is behind origin — human to ff-only. |
| **Convergence counter** | BC: 586. NFR: 41. Stories: 64. develop HEAD on origin: 8ec9527. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. DRIFT-331-PAGINATION: log-only (deferred). |
| **Standing context** | JR_E2E_ENABLED=true repo var set. DEC-066 retained (trigger = done-category AND offers resolution field; --no-resolution opt-out; bulk excluded). DEC-065: queue tests deliberately un-contracted (S-QUEUE-BC-1 draft open). Do NOT close #429 (DEC-029). OQ-5 open. E2E-PG-4 remote-link round-back open (blocked: no `jr remote-link read`). Coverage runs nightly. |
| **Next step** | S-QUEUE-BC-1: author BC-X.8.008/009 (queue list/view contracts) + PG-JSM-E2E-1 guard (BC-trace cross-check). |
| **Resume prompt** | `Read .factory/STATE.md. S-JSM-RESOLUTION-REQUIRED COMPLETE: PR #465 squash-merged → develop @ 8ec9527; e2e.yml run 26909701606 JSM suite 73/0; test_e2e_jsm_resolution_enforcement PASSED LIVE. BC 586 / NFR 41 / Stories 64 UNCHANGED. DEC-066 retained (trigger=done-category AND offers resolution field; --no-resolution opt-out; bulk excluded). DEC-065: queue tests deliberately un-contracted (S-QUEUE-BC-1 draft). jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. Do NOT close #429 (DEC-029). OQ-5 open. E2E-PG-4 remote-link round-back open. Local develop behind origin (ff-only needed). Next: S-QUEUE-BC-1.` |

---

_Was the active checkpoint after #470/BC-7.2.006 MERGED + CLOSED (PR #477 → develop @ aa602a1, 2026-06-08T15:30:11Z). Superseded when S-QUEUE-BC-1 cycle converged._

| Field | Value |
|-------|-------|
| **Date** | 2026-06-08 |
| **Position** | **#470 BC-7.2.006 MERGED + CLOSED + IDLE.** PR #477 squash-merged → develop @ aa602a1 (2026-06-08T15:30:11Z); issue #470 CLOSED (15:30:12Z); adf-listitem worktree + branch cleaned up. BC-7.2.006 adversarially converged (3 clean fresh-context passes), factory artifacts @ 46b36b4. PG-A + DRIFT-README deferred. JSM resolution-chain CLOSED + LIVE-GREEN (8ec9527 → now superseded by aa602a1). |
| **Convergence counter** | BC: 587 (+1 from #470). NFR: 41. Stories: 64. develop HEAD on origin: aa602a1 (PR #477 squash-merged 2026-06-08). jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. |
| **Standing context** | JR_E2E_ENABLED=true repo var set. DEC-066 retained. DEC-065 queue un-contracted (S-QUEUE-BC-1 draft open). Do NOT close #429 (DEC-029). OQ-5 open. E2E-PG-4 remote-link round-back open. PG-A + DRIFT-README: deferred doc-reconciliation items (see Drift Items). Coverage runs nightly. |
| **Next step** | S-QUEUE-BC-1: author BC-X.8.008/009 (queue list/view contracts) + PG-JSM-E2E-1 guard (BC-trace cross-check). |
| **Resume prompt** | `Read .factory/STATE.md. #470/BC-7.2.006 MERGED + CLOSED (PR #477 → develop @ aa602a1, 2026-06-08). BC 587 / NFR 41 / Stories 64. adf-listitem worktree + branch cleaned up. DEC-066 retained. DEC-065 queue un-contracted (S-QUEUE-BC-1 draft). PG-A + DRIFT-README deferred (see Drift Items). jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. Do NOT close #429. OQ-5 open. E2E-PG-4 remote-link round-back open. Next: S-QUEUE-BC-1.` |

---

## Checkpoint archived 2026-06-09 (develop @ be6b57b; BULK-TRANSITION FIX MERGED; post-merge e2e.yml run 27159962721 was in progress)

| Field | Value |
|-------|-------|
| **Date** | 2026-06-08 |
| **Position** | **BULK-TRANSITION FIX MERGED.** PR #479 squash-merged → develop @ be6b57b (2026-06-08T18:55:51Z). BC-3.2.014 (multi-key `issue move --to` `bulkTransitionInputs` wrapper fix). Worktree .worktrees/FIX-BULK-TRANSITION removed; fix/bulk-transition-schema branch deleted local + remote. Post-merge e2e.yml run 27159962721 in progress. DEFER-469 recorded: Dependabot PR #469 (gitleaks-action MAJOR bump) held open — extended soak period, no target date. |
| **Convergence counter** | BC: 590. NFR: 41. Stories: 64. develop HEAD on origin: be6b57b. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. |
| **Standing context** | JR_E2E_ENABLED=true repo var set. DEC-066 retained. DEC-065 closed. Do NOT close #429 (DEC-029). OQ-5 open. E2E-PG-4 remote-link round-back open. PG-A + DRIFT-README + PG-QUEUE-1 + PG-QUEUE-2 + DEFER-469: deferred (see Drift Items). E2E nightly was RED on test_e2e_issue_move_multikey_bulk — fix MERGED @ be6b57b; post-merge run 27159962721 validating. |
| **Next step** | Await post-merge e2e.yml run 27159962721 completion to confirm E2E green. Then idle until next feature request. |
| **Resume prompt** | `Read .factory/STATE.md. BULK-TRANSITION FIX: PR #479 squash-merged → develop @ be6b57b (2026-06-08T18:55:51Z). BC-3.2.014 (bulkTransitionInputs wrapper). Post-merge e2e.yml run 27159962721 in progress. DEFER-469: gitleaks-action MAJOR bump PR #469 held open (soak period). DEC-066 retained. DEC-065 closed. PG-A + DRIFT-README + PG-QUEUE-1 + PG-QUEUE-2 + DEFER-469 deferred. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. Do NOT close #429. OQ-5 open. E2E-PG-4 remote-link round-back open.` |

---

## Checkpoint archived 2026-06-09 (#483 GFM alerts → ADF panel CYCLE CLOSED + MERGED)

| Field | Value |
|-------|-------|
| **Date** | 2026-06-09 |
| **Position** | **#483 GFM alerts → ADF panel CYCLE CLOSED + MERGED.** PR #487 squash-merged → develop @ 87a15ad; issue #483 CLOSED; branch deleted. 18 new unit tests; 132 adf::tests green. BC-7.2.009; BC 593. S-483 story; Stories 66. F1/F2/F3/F5/F6/F7 artifacts complete. S-7.02: F5 findings = CONTENT defects only; no follow-up required. Live-Jira sandbox verification deferred (needs-sandbox). |
| **Convergence counter** | BC: 593. NFR: 41. Stories: 66. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. No active worktrees. |
| **Standing context** | JR_E2E_ENABLED=true repo var set. DEC-066 retained. DEC-065 closed. Do NOT close #429 (DEC-029). OQ-5 open. E2E-PG-4 remote-link round-back open. PG-A + DRIFT-README + PG-QUEUE-1 + PG-QUEUE-2 + DEFER-469 deferred. 3 #474 F5 process-gap lessons [deferred] in lessons.md. |
| **Next step** | Dispatch next feature cycle. |
| **Resume prompt** | `Read .factory/STATE.md. #483 GFM alerts → ADF panel CYCLE CLOSED + MERGED: PR #487 squash-merged → develop @ 87a15ad; issue #483 CLOSED; branch deleted. BC: 593. NFR: 41. Stories: 66. BC-7.2.009 authored. S-7.02 satisfied. DEC-066 retained. Do NOT close #429 (DEC-029). OQ-5 open. E2E-PG-4 remote-link round-back open. PG-A + DRIFT-README + PG-QUEUE-1 + PG-QUEUE-2 + DEFER-469 deferred. jira-e2e: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. Live-sandbox verification deferred (needs-sandbox). Ready: next feature cycle.` |

---

## Checkpoint archived 2026-06-10 (#471 GFM task lists → ADF — pre-F4 gate awaiting human approval)

| Field | Value |
|-------|-------|
| **Date** | 2026-06-10 |
| **Position** | **#473 bare-URL autolink E2E coverage CYCLE CLOSED + MERGED.** PR #493 squash-merged → develop @ 8b639c1 (2026-06-10); issue #473 CLOSED (feature #491 + E2E #493 both merged); branch test/e2e-bare-url-autolink-473 deleted. `test_e2e_markdown_bare_url_produces_link_mark` + `adf_has_linked_url` helper added to `tests/e2e_live.rs`; documented in `docs/specs/e2e-live-jira-testing.md §4`. Proves Jira REST preserves autolink `link` mark on round-trip. F5: Claude adversary CLEAN → Gemini cross-model slice caught `href.contains` over-permissiveness (redirect-href false-positive) → fixed to trailing-slash-tolerant exact equality → Claude confirm CLEAN. CI 11/11 GREEN. No new CLI surface; no new env vars. BC 593 / NFR 41 / Stories 66 UNCHANGED. PG-REVIEW-1 + PG-E2E-1 codified in `cycles/cycle-001/lessons.md` (corrective-convention, no follow-up story). #492 OPEN (block-HTML raw-\n follow-up, needs-sandbox). |
| **Convergence counter** | BC: 593. NFR: 41. Stories: 66. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. No active worktrees. |
| **Standing context** | JR_E2E_ENABLED=true repo var set. DEC-066 retained. DEC-065 closed. Do NOT close #429 (DEC-029). OQ-5 open. #473 CLOSED (feature + E2E both merged). #492 OPEN (block-HTML raw-\n). E2E-PG-4 remote-link round-back open. PG-A + DRIFT-README + PG-QUEUE-1 + PG-QUEUE-2 + DEFER-469 deferred. PG-REVIEW-1 + PG-E2E-1 codified in lessons.md (corrective-convention; no follow-up story). 3 #474 F5 process-gap lessons [deferred] also in lessons.md. |
| **Next step** | Dispatch next feature cycle. |
| **Resume prompt** | `Read .factory/STATE.md. #473 bare-URL autolink CYCLE CLOSED + MERGED (feature PR #491 + E2E PR #493 → develop @ 8b639c1, 2026-06-10); issue #473 CLOSED; test_e2e_markdown_bare_url_produces_link_mark + adf_has_linked_url added to e2e_live.rs; Gemini cross-model caught href.contains over-permissiveness → fixed; F5 CLEAN. BC: 593. NFR: 41. Stories: 66 UNCHANGED. #492 OPEN (block-HTML raw-\n). PG-REVIEW-1 + PG-E2E-1 codified in lessons.md (F5+E2E pre-merge discipline; corrective-convention). DEC-066 retained. Do NOT close #429 (DEC-029). OQ-5 open. E2E-PG-4 remote-link round-back open. PG-A + DRIFT-README + PG-QUEUE-1 + PG-QUEUE-2 + DEFER-469 deferred. jira-e2e: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. Ready: next feature cycle.` |

---

## Checkpoint archived 2026-06-10 (#471 GFM task lists → ADF — F1/F2/F3 COMPLETE, awaiting F3 human gate)

| Field | Value |
|-------|-------|
| **Date** | 2026-06-10 |
| **Position** | **#471 GFM task lists → ADF — Feature Mode F1/F2/F3 COMPLETE, awaiting F3 human approval gate before F4 TDD.** BC-7.2.010 authored (corpus 593→594). Story S-471 created (Stories 66→67, 18 ACs, 19 named tests, net +18 adf::tests, baseline 155). F2 converged 8 passes (P5/6/7/8 clean); F3 story converged 8 passes (P6/7/8 clean). F4-conditional blockquote dependency RESOLVED at spec time via research (pulldown-cmark 0.13.3 emits blockquote>taskList → normalization arm unconditional). No code yet. develop HEAD remains 8b639c1. |
| **Convergence counter** | BC: 594. NFR: 41. Stories: 67. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. No active worktrees. |
| **Standing context** | JR_E2E_ENABLED=true repo var set. DEC-067/068/069 (F1/F2/F3 #471). DEC-066 retained. Do NOT close #429 (DEC-029). OQ-5 open. #492 OPEN (block-HTML raw-\n). E2E-PG-4 remote-link round-back open. PG-A + DRIFT-README + PG-QUEUE-1 + PG-QUEUE-2 + DEFER-469 deferred. PG-471-1 logged to lessons.md. PG-REVIEW-1 + PG-E2E-1 codified in lessons.md. |
| **Next step** | Await F3 human gate approval, then dispatch F4 TDD implementation for #471. |
| **Resume prompt** | `Read .factory/STATE.md. #471 GFM task lists → ADF Feature Mode F1/F2/F3 COMPLETE (2026-06-10), awaiting F3 human gate before F4 TDD. BC-7.2.010 authored (BC 593→594). S-471 story (Stories 66→67; 18 ACs, 19 named tests, baseline 155, net +18 adf::tests at impl time). F2 8-pass adversary convergence (P5/6/7/8 clean). F3 8-pass story convergence (P6/7/8 clean). Blockquote-taskList dependency resolved at spec time. No code yet; develop HEAD 8b639c1. DEC-067 (F1 gate), DEC-068 (F2 convergence), DEC-069 (F3 story). DEC-066 retained. Do NOT close #429 (DEC-029). OQ-5 open. #492 OPEN (block-HTML raw-\n). E2E-PG-4 remote-link round-back open. PG-471-1 in lessons.md. PG-A + DRIFT-README + PG-QUEUE-1 + PG-QUEUE-2 + DEFER-469 deferred. jira-e2e: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. Awaiting F3 human gate; upon approval dispatch F4.` |

---

## Checkpoint archived 2026-06-10 (#489 ADF block-level HTML preservation CYCLE CLOSED + MERGED)

| Field | Value |
|-------|-------|
| **Date** | 2026-06-09 |
| **Position** | **#476 ADF unit-test gap fill CYCLE CLOSED + MERGED.** PR #488 squash-merged → develop @ d0bbb70 (2026-06-09T21:37:22Z); issue #476 CLOSED; branch test/adf-untested-paths-476 deleted; worktree .worktrees/adf-476 removed. 3 new pinning tests (127→130 adf::tests); zero production code changed. Code review: CR-001+CR-002 fixed before PR; 0 PR-stage findings. CI 11/11 GREEN. FOLLOW-UP: #489 filed (fix(adf): block-level HTML silently dropped — inconsistent with inline HTML). |
| **Convergence counter** | BC: 593. NFR: 41. Stories: 66. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. No active worktrees. |
| **Standing context** | JR_E2E_ENABLED=true repo var set. DEC-066 retained. DEC-065 closed. Do NOT close #429 (DEC-029). OQ-5 open. #489 OPEN (block-level HTML silent drop — future fix cycle). E2E-PG-4 remote-link round-back open. PG-A + DRIFT-README + PG-QUEUE-1 + PG-QUEUE-2 + DEFER-469 deferred. 3 #474 F5 process-gap lessons [deferred] in lessons.md. |
| **Next step** | Dispatch next feature cycle. |
| **Resume prompt** | `Read .factory/STATE.md. #476 ADF unit-test gap fill CYCLE CLOSED + MERGED: PR #488 squash-merged → develop @ d0bbb70 (2026-06-09T21:37:22Z); issue #476 CLOSED; 3 pinning tests (127→130 adf::tests); zero src changed. BC: 593. NFR: 41. Stories: 66 UNCHANGED. #489 OPEN (block-level HTML silent drop; future fix cycle). DEC-066 retained. Do NOT close #429 (DEC-029). OQ-5 open. E2E-PG-4 remote-link round-back open. PG-A + DRIFT-README + PG-QUEUE-1 + PG-QUEUE-2 + DEFER-469 deferred. jira-e2e: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. Ready: next feature cycle.` |

---

## Checkpoint archived 2026-06-11 (pre-compact — #471 + #495 CYCLE CLOSED + MERGED, STATE.md at 200-line limit)

_Was the active checkpoint after PR #495 (ADF E2E loop-back) squash-merged → develop @ bfb723f. Superseded when STATE.md was compacted from 200→142 lines and the resume checkpoint was rewritten for durability._

| Field | Value |
|-------|-------|
| **Date** | 2026-06-11 |
| **Position** | ADF E2E coverage cycle (deferred-test loop-back) CLOSED + MERGED @ bfb723f. PR #495 → develop (2026-06-11T01:43:18Z). 5 gated live-Jira E2E tests added (#471 task-lists+EC-17, #474 subsup, #483 panel info/warning, #489 block-HTML). NO src change. BC 594. NFR 41. Stories 67. No active worktrees. Nightly e2e.yml = first live-verify pending. #475 partially addressed (Gap 1 + #470 listItem remain). |
| **Convergence counter** | BC: 594. NFR: 41. Stories: 67. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. No active worktrees. |
| **Standing context** | JR_E2E_ENABLED=true. DEC-067/068/069/070/071 (#471 F1→F7). DEC-066 retained. Do NOT close #429 (DEC-029). OQ-5 open. #492 OPEN. E2E-PG-4 remote-link round-back open. PG-A + DRIFT-README + PG-QUEUE-1 + PG-QUEUE-2 + DEFER-469 deferred. SEC-001 logged. DEFERRED-ADF-E2E PARTIALLY RESOLVED: remaining #470 listItem live-E2E + #475 Gap 1. |
| **Next step** | STATE.md compaction + durable resume checkpoint rewrite. |
| **Resume prompt** | `Read .factory/STATE.md. ADF E2E loop-back CLOSED + MERGED (2026-06-11). PR #495 → develop @ bfb723f. 5 gated E2E tests. BC 594 / NFR 41 / Stories 67. No active worktrees. develop HEAD bfb723f. Nightly e2e.yml = first live-verify pending. DEFERRED-ADF-E2E partially resolved: remaining #470 listItem live-E2E + #475 Gap 1. DEC-066 retained. Do NOT close #429 (DEC-029). OQ-5 open. #492 OPEN. E2E-PG-4 remote-link open. PG-A + DRIFT-README + PG-QUEUE-1 + PG-QUEUE-2 + DEFER-469 deferred. SEC-001 logged. jira-e2e: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ.` |

---

## Checkpoint archived 2026-06-11 (pre-#475-F2-close — Maintenance 4 Dependabot PRs, DEFER-469 resolved)

_Was the active checkpoint after 4 Dependabot PRs merged (#497/#498/#484/#469) → develop @ 18a6441. Superseded when #475 F2 converged and gate was approved 2026-06-11._

| Field | Value |
|-------|-------|
| **Date** | 2026-06-11 |
| **Position** | Maintenance: 4 Dependabot PRs merged, DEFER-469 hold resolved. PR #469 squash-merged → develop @ 18a6441 (2026-06-11): gitleaks/gitleaks-action 2.3.9 → 3.0.0 (MAJOR; runtime-only Node20→Node24, no behavior/licensing change, ahead of Node20 removal 2026-09-16). SHA 18a6441 verified vs v3.0.0 tag. Code-owner approved, full CI green (Secret Scan job ran v3 action successfully). DEFER-469 drift item CLOSED. Prior: #497 chrono 0.4.45 + #498 codeql-action 4.36.2 + #484 checkout 6.0.3 → 4478db5. All 4 Dependabot PRs soak-verified, CI green, code-owner approved. |
| **develop HEAD** | origin/develop = **18a6441**. BC 594. NFR 41. Stories 67. No active worktrees. |
| **Convergence counter** | BC: **594**. NFR: **41**. Stories: **67**. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. No active worktrees. |
| **Next / Pending** | (1) DONE — task-list E2E + PR #495 ADF E2E (EC-17/subsup/panel/block-HTML) VERIFIED GREEN — e2e run 27352373680 (89/0), 2026-06-11. (2) #475 OPEN: Gap 1 (ADF→text `issue view` human mode) + #470 listItem-normalization live test remain. (3) SEC-001 (CWE-674 deep-nesting recursion in adf.rs, LOW) deferred. (4) Deferred: #400 Story B + engine items; #372 cargo-mutants. (5) Standing: do NOT close #429 (DEC-029 human deferral); #492 OPEN; OQ-5 + E2E-PG-4 remote-link open. F-H1 deferred drift item logged. |
| **Resume prompt** | `Read .factory/STATE.md. DATE: 2026-06-11. POSITION: Maintenance complete — 4 Dependabot PRs merged (#497 chrono 0.4.45, #498 codeql-action 4.36.2, #484 checkout 6.0.3, #469 gitleaks-action v3.0.0 MAJOR) → develop @ 18a6441. DEFER-469 hold RESOLVED (v3.0.0 runtime-only Node24, ahead of Node20 removal 2026-09-16). Prior feature: description-leading-dash CLOSED + MERGED (PR #496 @ 45ceae6). BC 594 / NFR 41 / Stories 67 UNCHANGED. No active worktrees. DEC-072. F-H1 DEFERRED. F5-P5-01 RESOLVED. DEFERRED-ADF-E2E: task-list E2E VERIFIED GREEN (e2e run 27352373680, 89/0); PR #495 ADF E2E also live-verified (all 5 tests pass). #475 OPEN (Gap 1 + #470 remain). STANDING: do NOT close #429 (DEC-029); #492 OPEN; OQ-5 open; E2E-PG-4 remote-link open; SEC-001 LOW deferred. jira-e2e: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true.` |

---

## Checkpoint archived 2026-06-11 (#471+#495 CLOSED+MERGED — both cycles complete; nightly e2e live-verify pending)

_Was the active checkpoint after STATE.md was compacted and rewritten post-#495 merge. Superseded when description-leading-dash cycle (PR #496) CLOSED + MERGED → develop @ 45ceae6._

| Field | Value |
|-------|-------|
| **Date** | 2026-06-10/11 |
| **Position** | BOTH CYCLES COMPLETE + MERGED. (a) #471 GFM task lists → ADF: PR #494 squash-merged → develop @ 4c9b069 (2026-06-11T01:09:45Z); issue #471 CLOSED (auto). BC-7.2.010 + EC-17. Full F1–F7. 210 adf::tests; full suite 1746/0; clippy zero; fmt clean; 97.3% mutation kill (72/74). F5: 16-pass adversary convergence; 8 fix iterations; ~15 genuine bugs (CRITICAL invalid-ADF Jira-400). F6: proptest 512 cases found 17th bug (tuple-lead violation). AI PR review APPROVE 0 findings. 11/11 CI GREEN. (b) ADF E2E coverage loop-back: PR #495 squash-merged → develop @ bfb723f (2026-06-11T01:43:18Z). 5 gated live-Jira tests: task-lists + EC-17/orderedList-absence (#471), subsup (#474), GFM-alert panel info/warning (#483), block-HTML (#489). Pattern: poll_view → fields.description raw ADF → recursive matchers. [#ignore]+JR_RUN_E2E+e2e_enabled(). INERT ci.yml; nightly e2e.yml. NO src change. |
| **develop HEAD** | origin/develop = **bfb723f**. IMPORTANT: main repo's LOCAL develop is BEHIND at 8b639c1 (2 commits). Fresh session: `git fetch` and treat origin/develop @ bfb723f as truth; `git pull` on develop when ready. No active worktrees (.worktrees/ has only .factory + .reference). |
| **Convergence counter** | BC: **594**. NFR: **41**. Stories: **67**. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. No active worktrees. |
| **Next / Pending** | (1) NIGHTLY E2E LIVE-VERIFY PENDING: next e2e.yml run = FIRST live verify of 5 new ADF E2E tests. Medium-risk needs-sandbox: EC-17 (ordered→taskList), subsup-mark acceptance, panel editor-flag. Live failure = needs-sandbox signal; diagnostic asserts distinguish jr-bug vs site-config. (2) #475 OPEN: Gap 1 (ADF→text read path via `issue view` human mode) + #470 listItem-normalization live test. (3) SEC-001 (CWE-674 deep-nesting recursion in adf.rs, LOW) deferred to file-wide recursion-depth-guard sweep. (4) Deferred: #400 Story B + engine items; #372 cargo-mutants; STATE drift items. (5) Standing: do NOT close #429 (DEC-029 human deferral); #492 OPEN (block-HTML raw-\n needs-sandbox); OQ-5 + E2E-PG-4 remote-link documented-but-untracked; DEFER-469 Dependabot gitleaks 3.0 hold. |
| **Resume prompt** | `Read .factory/STATE.md. DATE: 2026-06-10/11. POSITION: Both cycles COMPLETE + MERGED. (a) #471 GFM task lists → ADF: PR #494 squash-merged → develop @ 4c9b069; issue #471 CLOSED; BC-7.2.010 + EC-17; full F1-F7; 210 adf::tests; 1746/0; 97.3% mutation kill; F5 16-pass adversary; F6 proptest 512 cases found 17th bug. (b) ADF E2E loop-back: PR #495 squash-merged → develop @ bfb723f; 5 gated live-Jira tests (task-lists+EC-17 [#471], subsup [#474], panel info/warning [#483], block-HTML [#489]); test-only; inert ci.yml; nightly e2e.yml. DEVELOP HEAD: origin/develop = bfb723f; LOCAL develop BEHIND at 8b639c1 (run git fetch + git pull). COUNTS: BC 594, NFR 41, Stories 67. jira-e2e: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. No active worktrees. NEXT: (1) NIGHTLY E2E LIVE-VERIFY PENDING — first live run of 5 new ADF tests; EC-17/subsup/panel medium-risk needs-sandbox; live failure = triage jr-bug vs site-config. (2) #475 OPEN: Gap 1 (ADF→text issue view human mode) + #470 listItem live-E2E remain. (3) SEC-001 (CWE-674 adf.rs deep-nesting recursion, LOW) deferred to file-wide sweep. (4) STANDING: do NOT close #429 (DEC-029 human); #492 OPEN (block-HTML raw-\n needs-sandbox); OQ-5 open; E2E-PG-4 remote-link open; DEFER-469 gitleaks 3.0 hold.` |

---

## Checkpoint — 2026-06-11 (#475 F2 CONVERGED + gate APPROVED)

| Field | Value |
|-------|-------|
| **Date** | 2026-06-11 |
| **Position** | **#475 ADF E2E read-path — F2 CONVERGED, gate APPROVED.** R1: 9→0 (Pass 1: 3H/4M/2L all fixed, spec 1.3.7) + 6→0 (Pass 2: 1C/1H/2M/2L all fixed, spec 1.3.8). R2: fresh-context adversary 0→0→0. Research-validated 5/5 Jira-API assumptions (developer.atlassian.com 2026-06-11): ADF returned raw; listItem forbids blockquote child; Jira silently normalizes stored ADF. Spec v1.3.9. DEC-073. Rename target confirmed: `test_e2e_markdown_description_produces_heading_node`. Prior: Maintenance 4 Dependabot PRs merged → develop @ 18a6441 (DEC-072, DEFER-469 resolved). |
| **develop HEAD** | origin/develop = **18a6441**. BC 594. NFR 41. Stories 67 (→68 at F3). No active worktrees. |
| **Convergence counter** | BC: **594**. NFR: **41**. Stories: **67**. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. No active worktrees. |
| **Next / Pending** | (1) #475 ACTIVE — F3 story decomposition next (S-475-adf-e2e-readpath; Stories 67→68). (2) #475 DEFERRED-ADF-E2E: #470 listItem live-E2E remains open. (3) SEC-001 (CWE-674 deep-nesting recursion in adf.rs, LOW) deferred. (4) Deferred: #400 Story B + engine items; #372 cargo-mutants. (5) Standing: do NOT close #429 (DEC-029 human deferral); #492 OPEN; OQ-5 + E2E-PG-4 remote-link open; F-H1 DEFERRED. |
| **Resume prompt** | `Read .factory/STATE.md. DATE: 2026-06-11. POSITION: #475 ADF E2E read-path — F2 CONVERGED + gate APPROVED (2026-06-11). R1: 9→0/6→0 (spec 1.3.8); R2 fresh-context 0→0→0; research-validated 5/5 (developer.atlassian.com). Spec v1.3.9. DEC-073. Rename target: test_e2e_markdown_description_produces_heading_node. develop HEAD: 18a6441. BC 594 / NFR 41 / Stories 67 (→68 at F3). No active worktrees. NEXT: F3 story decomposition (S-475-adf-e2e-readpath). DEFERRED-ADF-E2E: #470 listItem live-E2E remains. STANDING: do NOT close #429 (DEC-029); #492 OPEN; OQ-5 open; E2E-PG-4 remote-link open; SEC-001 LOW deferred; F-H1 DEFERRED. jira-e2e: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true.` |

---
