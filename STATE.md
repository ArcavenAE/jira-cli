---
document_type: pipeline-state
level: ops
version: "2.0"
status: active
producer: state-manager
timestamp: 2026-07-26T17:40:00Z
phase: 3
pipeline: Feature Mode SOH-DX-1 ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-27893 latest brownfield. SOH-DX-1 F2 ADVERSARY GRIND IN PROGRESS (2026-07-26): 41 rounds complete (pass-1 8F 4H/4M → fix-1 → ... → pass-41 2F+1PG+1nit 0C/0H/2M/0L 2M); fixes: AC-13 would-otherwise-succeed invocation (zero-HTTP proof normative); AC-1 first-use subtype parenthetical + policy; config_home param rename; spec v1.3.139 + [1.3.139]; BC-INDEX v6.68; piecewise CLEAN; 3 guards green. ZERO consecutive CLEAN; 0/3 STRICT per DEC-189. NEXT: pass-42. trajectory-tail →4M+2L→2M+1L→1H+1M→2M"
maintenance_run: CLOSED
current_cycle: "cycle-001"
feature_mode_bundle: SOH-DX-1-F2-ADVERSARY-GRIND
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: SOH-ATTACHMENTS-1 F5 SCOPED ADVERSARIAL CONVERGED 2026-07-24 STRICT (14 rounds; window pass-12/pass-13/pass-14 CLEAN×3; spec v1.3.99 to v1.3.106; BC-INDEX v6.38 to v6.44; develop @ db207b81) + F7 DELTA CONVERGENCE APPROVED 2026-07-25 (DEC-186; 5-dim PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED) + CYCLE FULLY CLOSED 2026-07-25
activation_head: "7b3ba371"
activation_version: "v0.6.0-dev.11"
---

<!--
STATE.md SIZE BUDGET (2026-07-26 update: SOH-DX-1 F2 ADVERSARY GRIND ROUND 41):
242 lines (wc-l) — soft-target 200 lines, hard cap 500 lines.
margin from soft-target: 42 lines over soft-target (compact further if possible).
margin from actual: 258 lines remaining to hard cap.
Hard cap: 500 lines. Prior: 241 lines. Net delta: +1 lines (PP row rotated: pass-36-adversary archived, pass-41-adversary added; CPS row rotated: pass-37-adversary archived, pass-41-adversary added; all trajectory-tail sites updated; PG-011 row added; Session Resume Checkpoint replaced for pass-42).
-->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **Last Updated** | 2026-07-26: SOH-DX-1 F2 ADVERSARY GRIND — 41 rounds complete (pass-1 8F→...→pass-41 2F+1PG+1nit 0C/0H/2M/0L 2M); fixes: AC-13 would-otherwise-succeed invocation (zero-HTTP proof normative); AC-1 first-use subtype parenthetical + policy; config_home param rename; spec v1.3.139 [1.3.139]; BC-INDEX v6.68; piecewise CLEAN; 3 guards green. ZERO consecutive CLEAN; 0/3 STRICT per DEC-189. NEXT: pass-42. trajectory-tail →4M+2L→2M+1L→1H+1M→2M. Prior: fix-40: 5 AC-body pins propagated (all 13 mandate ACs carrying pin); Definition (unconditional remedy) block closes two-ways reading; superseded-note both surfaces (in-round residual); spec v1.3.138. trajectory-tail →2H+2L→4M+2L→2M+1L→1H+1M |
| **Current Phase** | Feature Mode SOH-DX-1 ACTIVE — F2 ADVERSARY GRIND IN PROGRESS (2026-07-26). Rounds 1-41 complete; trajectory 8→8→8→7→6→4→3→7→6→5→6→6→4→2→5→5→4→3→3→5→4→2→3→3→6→6→4→5→2→1→3→3→2→3L→1M+3L→2M+2L→2H+2L→4M+2L→2M+1L→1H+1M→2M; 0C/0H/2M/0L; novelty LOW-MEDIUM; piecewise CLEAN; ZERO consecutive CLEAN passes (0/3 STRICT per DEC-189). NEXT: pass-42 → continue grind → human gate after STRICT convergence. |
| **Next Phase** | F2 adversary convergence (3-clean-pass STRICT minimum per DEC-189) → F2 human gate → F3 story decomposition. #645 soaking until 2026-07-27 (DEC-187). ENGINE IPs (5) queued for vsdd-factory after this cycle. |
| **Activation HEAD** | 7b3ba371 (PR #654 squash-merged 2026-07-25; FIX-E2E-EGRESS DELIVERED; SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED; activation_version v0.6.0-dev.11) |

## Phase Progress

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
<!-- archived rows ledger: see cycles/cycle-001/burst-log.md (2026-07-25 compaction + SOH-DX-1 F1 burst: archived pass-14 adversary row + SOH-DX-1 F2-AUTHORED burst: archived F6 hardening row; F2-ADVERSARY-ROUNDS-1-4 burst: archived DEPENDABOT-TRIAGE CPS row; F2-ADVERSARY-ROUND-5 burst: archived DEPENDABOT-MERGES-COMPLETE CPS row; F2-ADVERSARY-ROUND-6 burst: archived SOH-DX-1 F1 APPROVED CPS row; F2-ADVERSARY-ROUND-7 burst: archived SOH-DX-1 F2 AUTHORING COMPLETE CPS row; F2-ADVERSARY-ROUND-8 burst: archived pass-4 adversary row; F2-ADVERSARY-ROUND-9 burst: archived pass-5 adversary row; F2-ADVERSARY-ROUND-10 burst: archived pass-6 adversary row; F2-ADVERSARY-ROUND-11 burst: archived pass-7 adversary row; F2-ADVERSARY-ROUND-12 burst: archived pass-8 adversary row; F2-ADVERSARY-ROUND-13 burst: archived pass-9 adversary row; F2-ADVERSARY-ROUND-14 burst: archived pass-10 adversary row; F2-ADVERSARY-ROUND-15 burst: archived pass-11 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-16 burst: archived pass-12 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-17 burst: archived pass-13 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-18 burst: archived pass-14 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-19 burst: archived pass-15 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-20 burst: archived pass-16 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-21 burst: archived pass-17 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-22 burst: archived pass-18 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-23 burst: archived pass-19 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-24 burst: archived pass-19 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-25 burst: archived pass-20 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-26 burst: archived pass-21 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-27 burst: archived pass-22 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-28 burst: archived pass-23 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-29 burst: archived pass-24 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-30 burst: archived pass-25 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-31 burst: archived pass-26 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-32 burst: archived pass-27 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-33 burst: archived pass-28 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-34 burst: archived pass-29 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-35 burst: archived pass-30 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-36 burst: archived pass-31 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-37 burst: archived pass-32 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-38 burst: archived pass-33 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-39 burst: archived pass-34 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-40 burst: archived pass-35 adversary row — see burst-log.md; F2-ADVERSARY-ROUND-41 burst: archived pass-36 adversary row — see burst-log.md) -->
| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **pass-37 adversary — SOH-DX-1 F2 fix burst round 37 complete (2026-07-26): 4 findings (0C/2H/0M/2L) 2H+2L; 2 HIGH; novelty LOW-MEDIUM; new root cause: config-migration stderr side-channel poisoning envelope-parse ACs + AC-5 byte-identity; Config fixture contract (pre-migrated [profiles.default] shape) single-sourced in Test Notes + Preconditions AC-2/5/7/10; key-order language contract-softened; mod-common hygiene extended; spec v1.3.135 + [1.3.135]; BC-INDEX v6.64; piecewise CLEAN (AC-9 exemption verified unambiguous); 3 guards green. ZERO consecutive CLEAN; 0/3 STRICT per DEC-189. NEXT: pass-38.** | F2 adversary grind in progress | 2026-07-26 | ADVERSARY GRIND — convergence + human gate PENDING. | spec v1.3.135; BC-INDEX v6.64; STORY-INDEX v1.5.41. | →8→8→8→7→6→4→3→7→6→5→6→6→4→2→5→5→4→3→3→5→4→2→3→3→6→6→4→5→2→1→3→3→2→3L→1M+3L→2M+2L→2H+2L |
| **pass-38 adversary — SOH-DX-1 F2 fix burst round 38 complete (2026-07-26): 6 findings (0C/0H/4M/2L) 4M+2L (from 2H+2L); ZERO CRITs; ZERO HIGHs; 4 MEDIUM; 2 LOW; novelty LOW-MEDIUM; fixes: write_profile_config replacement mandates (conditional tail stripped; unconditional-remedies uniform rule); ADR §42-45 de-scoped (4 sites); deliverable (f) feature spec docs/specs/issue-create-preflight-guards.md (no-ADR rationale); pin mandate structural rule (13 ACs after in-round AC-8 residual); AC-13 zero-HTTP proof; spec v1.3.136 + [1.3.136]; BC-INDEX v6.65; piecewise CLEAN (in-round AC-8 pin residual fixed); 3 guards green. ZERO consecutive CLEAN; 0/3 STRICT per DEC-189. NEXT: pass-39.** | F2 adversary grind in progress | 2026-07-26 | ADVERSARY GRIND — convergence + human gate PENDING. | spec v1.3.136; BC-INDEX v6.65; STORY-INDEX v1.5.41. | →8→8→8→7→6→4→3→7→6→5→6→6→4→2→5→5→4→3→3→5→4→2→3→3→6→6→4→5→2→1→3→3→2→3L→1M+3L→2M+2L→2H+2L→4M+2L |
| **pass-39 adversary — SOH-DX-1 F2 fix burst round 39 complete (2026-07-26): 3 findings (0C/0H/2M/1L) + 3 obs 2M+1L (from 4M+2L); ZERO CRITs; ZERO HIGHs; 2 MEDIUM; 1 LOW; novelty LOW; verdict "converged on substance"; fixes: pin rule reachability qualifier + AC-15 exclusion; write_profile_config fully specified (fixtures.rs shape :1959-1966); EC-10 transitive-falsification sentence; changelog/trace/README bookkeeping; spec v1.3.137 + [1.3.137]; BC-INDEX v6.66; piecewise CLEAN; 3 guards green. ZERO consecutive CLEAN; 0/3 STRICT per DEC-189. NEXT: pass-40.** | F2 adversary grind in progress | 2026-07-26 | ADVERSARY GRIND — convergence + human gate PENDING. | spec v1.3.137; BC-INDEX v6.66; STORY-INDEX v1.5.41. | →8→8→8→7→6→4→3→7→6→5→6→6→4→2→5→5→4→3→3→5→4→2→3→3→6→6→4→5→2→1→3→3→2→3L→1M+3L→2M+2L→2H+2L→4M+2L→2M+1L |
| **pass-40 adversary — SOH-DX-1 F2 fix burst round 40 complete (2026-07-26): 2 findings (0C/1H/1M/0L) + 1 obs 1H+1M (from 2M+1L); 1 HIGH; 1 MEDIUM; ZERO CRITs; ZERO LOWs; novelty LOW; piecewise CLEAN after in-round residual; fixes: 5 AC-body pins propagated (all 13 mandate ACs carrying pin); Definition (unconditional remedy) block closes two-ways reading; superseded-note both surfaces (in-round residual); spec v1.3.138 + [1.3.138]; BC-INDEX v6.67; 3 guards green. ZERO consecutive CLEAN; 0/3 STRICT per DEC-189. NEXT: pass-41.** | F2 adversary grind in progress | 2026-07-26 | ADVERSARY GRIND — convergence + human gate PENDING. | spec v1.3.138; BC-INDEX v6.67; STORY-INDEX v1.5.41. | →8→8→8→7→6→4→3→7→6→5→6→6→4→2→5→5→4→3→3→5→4→2→3→3→6→6→4→5→2→1→3→3→2→3L→1M+3L→2M+2L→2H+2L→4M+2L→2M+1L→1H+1M |
| **pass-41 adversary — SOH-DX-1 F2 fix burst round 41 complete (2026-07-26): 2 findings (0C/0H/2M/0L) + 1 process-gap + 1 nit 2M (from 1H+1M); ZERO CRITs; ZERO HIGHs; 2 MEDIUM; novelty LOW-MEDIUM; adversary recommends one more pass then converge; fixes: AC-13 would-otherwise-succeed invocation (zero-HTTP proof normative); AC-1 first-use subtype parenthetical + policy; config_home param rename; spec v1.3.139 + [1.3.139]; BC-INDEX v6.68; piecewise CLEAN; 3 guards green. ZERO consecutive CLEAN; 0/3 STRICT per DEC-189. NEXT: pass-42.** | F2 adversary grind in progress | 2026-07-26 | ADVERSARY GRIND — convergence + human gate PENDING. | spec v1.3.139; BC-INDEX v6.68; STORY-INDEX v1.5.41. | →8→8→8→7→6→4→3→7→6→5→6→6→4→2→5→5→4→3→3→5→4→2→3→3→6→6→4→5→2→1→3→3→2→3L→1M+3L→2M+2L→2H+2L→4M+2L→2M+1L→1H+1M→2M |

## Current Phase Steps

<!-- Keep last 4 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
<!-- archived rows ledger: see cycles/cycle-001/burst-log.md (2026-07-25 compaction + SOH-DX-1 F1 burst: archived F7-delta-convergence CPS row + SOH-DX-1 F2-AUTHORED burst: archived SOH-ATTACHMENTS-1 CYCLE-CLOSE WRAP CPS row + F2-ADVERSARY-ROUNDS-1-4 burst: archived DEPENDABOT-TRIAGE CPS row + F2-ADVERSARY-ROUND-5 burst: archived DEPENDABOT-MERGES-COMPLETE CPS row + F2-ADVERSARY-ROUND-6 burst: archived SOH-DX-1 F1 APPROVED CPS row + F2-ADVERSARY-ROUND-7 burst: archived SOH-DX-1 F2 AUTHORING COMPLETE CPS row + F2-ADVERSARY-ROUND-8 burst: archived pass-4 adversary CPS row + F2-ADVERSARY-ROUND-9 burst: archived pass-5 adversary CPS row + F2-ADVERSARY-ROUND-10 burst: archived pass-6 adversary CPS row + F2-ADVERSARY-ROUND-11 burst: archived pass-7 adversary CPS row + F2-ADVERSARY-ROUND-12 burst: archived pass-8 adversary CPS row + F2-ADVERSARY-ROUND-13 burst: archived pass-9 adversary CPS row + F2-ADVERSARY-ROUND-14 burst: archived pass-10 adversary CPS row + F2-ADVERSARY-ROUND-15 burst: archived pass-11 adversary CPS row + F2-ADVERSARY-ROUND-16 burst: archived pass-12 adversary CPS row + F2-ADVERSARY-ROUND-17 burst: archived pass-13 adversary CPS row + F2-ADVERSARY-ROUND-18 burst: archived pass-14 adversary CPS row + F2-ADVERSARY-ROUND-19 burst: archived pass-15 adversary CPS row + F2-ADVERSARY-ROUND-20 burst: archived pass-16 adversary CPS row + F2-ADVERSARY-ROUND-21 burst: archived pass-17 adversary CPS row + F2-ADVERSARY-ROUND-22 burst: archived pass-18 adversary CPS row + F2-ADVERSARY-ROUND-23 burst: archived pass-19 adversary CPS row + F2-ADVERSARY-ROUND-24 burst: archived pass-20 adversary CPS row + F2-ADVERSARY-ROUND-25 burst: archived pass-21 adversary CPS row + F2-ADVERSARY-ROUND-26 burst: archived pass-22 adversary CPS row — see burst-log.md + F2-ADVERSARY-ROUND-27 burst: archived pass-23 adversary CPS row — see burst-log.md + F2-ADVERSARY-ROUND-28 burst: archived pass-24 adversary CPS row — see burst-log.md + F2-ADVERSARY-ROUND-29 burst: archived pass-25 adversary CPS row — see burst-log.md + F2-ADVERSARY-ROUND-30 burst: archived pass-26 adversary CPS row — see burst-log.md + F2-ADVERSARY-ROUND-31 burst: archived pass-27 adversary CPS row — see burst-log.md + F2-ADVERSARY-ROUND-32 burst: archived pass-28 adversary CPS row — see burst-log.md + F2-ADVERSARY-ROUND-33 burst: archived pass-29 adversary CPS row — see burst-log.md + F2-ADVERSARY-ROUND-34 burst: archived pass-30 adversary CPS row — see burst-log.md + F2-ADVERSARY-ROUND-35 burst: archived pass-31 adversary CPS row — see burst-log.md + F2-ADVERSARY-ROUND-36 burst: archived pass-32 adversary CPS row — see burst-log.md + F2-ADVERSARY-ROUND-37 burst: archived pass-33 adversary CPS row — see burst-log.md + F2-ADVERSARY-ROUND-38 burst: archived pass-34 adversary CPS row — see burst-log.md + F2-ADVERSARY-ROUND-39 burst: archived pass-35 adversary CPS row — see burst-log.md + F2-ADVERSARY-ROUND-40 burst: archived pass-36 adversary CPS row — see burst-log.md + F2-ADVERSARY-ROUND-41 burst: archived pass-37 adversary CPS row — see burst-log.md) -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| **pass-38 adversary — SOH-DX-1 F2 round 38 complete (2026-07-26): 6 findings (0H/4M/2L) 4M+2L; ZERO HIGHs; novelty LOW-MEDIUM; write_profile_config replacement mandates (conditional tail stripped; unconditional-remedies uniform rule); ADR §42-45 de-scoped (4 sites); deliverable (f) feature spec docs/specs/issue-create-preflight-guards.md; pin mandate structural rule (13 ACs after in-round AC-8 residual); AC-13 zero-HTTP proof; spec v1.3.136 [1.3.136]; BC-INDEX v6.65; piecewise CLEAN (in-round AC-8 pin); 3 guards green. ZERO consecutive CLEAN (need 3 STRICT per DEC-189). NEXT: pass-39.** | adversary (×38) + product-owner (×38) + consistency-validator (×38) + state-manager | IN PROGRESS — F2 adversary grind | spec v1.3.136; BC-INDEX v6.65; STORY-INDEX v1.5.41; convergence-trajectory p115 appended; burst-log.md appended; factory-artifacts committed. |
| **pass-39 adversary — SOH-DX-1 F2 round 39 complete (2026-07-26): 3 findings (0H/2M/1L) + 3 obs 2M+1L; ZERO HIGHs; novelty LOW; verdict "converged on substance"; pin rule reachability qualifier + AC-15 exclusion; write_profile_config fully specified (fixtures.rs shape :1959-1966); EC-10 transitive-falsification sentence; changelog/trace/README bookkeeping; spec v1.3.137 [1.3.137]; BC-INDEX v6.66; piecewise CLEAN; 3 guards green. ZERO consecutive CLEAN (need 3 STRICT per DEC-189). NEXT: pass-40.** | adversary (×39) + product-owner (×39) + consistency-validator (×39) + state-manager | IN PROGRESS — F2 adversary grind | spec v1.3.137; BC-INDEX v6.66; STORY-INDEX v1.5.41; convergence-trajectory p116 appended; burst-log.md appended; factory-artifacts committed. |
| **pass-40 adversary — SOH-DX-1 F2 round 40 complete (2026-07-26): 2 findings (1H/1M) + 1 obs 1H+1M; 1 HIGH; 1 MEDIUM; novelty LOW; piecewise CLEAN after in-round residual; 5 AC-body pins propagated (all 13 mandate ACs verified carrying pin); Definition (unconditional remedy) block closes two-ways reading; superseded-note both surfaces (in-round residual); spec v1.3.138 [1.3.138]; BC-INDEX v6.67; 3 guards green. ZERO consecutive CLEAN (need 3 STRICT per DEC-189). NEXT: pass-41.** | adversary (×40) + product-owner (×40) + consistency-validator (×40) + state-manager | IN PROGRESS — F2 adversary grind | spec v1.3.138; BC-INDEX v6.67; STORY-INDEX v1.5.41; convergence-trajectory p117 appended; burst-log.md appended; factory-artifacts committed. |
| **pass-41 adversary — SOH-DX-1 F2 round 41 complete (2026-07-26): 2 findings (2M) + 1 process-gap + 1 nit 2M; ZERO HIGHs; novelty LOW-MEDIUM; adversary recommends one more pass then converge (converge-adjacent signal); AC-13 would-otherwise-succeed invocation (zero-HTTP proof normative); AC-1 first-use subtype parenthetical + policy; config_home param rename; spec v1.3.139 [1.3.139]; BC-INDEX v6.68; piecewise CLEAN; 3 guards green. ZERO consecutive CLEAN (need 3 STRICT per DEC-189). NEXT: pass-42.** | adversary (×41) + product-owner (×41) + consistency-validator (×41) + state-manager | IN PROGRESS — F2 adversary grind | spec v1.3.139; BC-INDEX v6.68; STORY-INDEX v1.5.41; convergence-trajectory p118 appended; burst-log.md appended; factory-artifacts committed. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-001..DEC-155 | Phase 0/1/2/3 + Wave + Feature Mode + all prior cycles. All CYCLE CLOSED. | See cycles/cycle-001/burst-log.md | Phase 0 to 3 / 2026-05-04 to 2026-07-07 | archived |
| DEC-156 | CITATION-GUARDS CYCLE CLOSED — Story A (PR #572 @ ab78a2d) + Story B (PR #592 @ 0d8a8a5) both DELIVERED. Guard family complete (BC-X.13.001..006). 309 citations enforced in CI. | CITATION-GUARDS bundle complete — both stories delivered. | Feature Mode / CITATION-GUARDS | 2026-07-07 |
| DEC-157 | ADF-CODE-MARK-EXCLUSIVITY F1 gate approved 2026-07-07: 5-point scope ratified — emit-site filter in src/adf.rs::push_code; no node-splitting; apply_marks read-tolerance retained; BC-7.2.015 standalone; STANDARD criterion. | Human gate cleared; F2 dispatch authorized. | Feature Mode / ADF-CODE-MARK-EXCLUSIVITY | 2026-07-07 |
| DEC-158..DEC-163 | ADF-CODE-MARK-EXCLUSIVITY F2-F7: STRICT convergence, gate approvals, delivery PR #593 @ 7ba4cf4, fix-PR #594 @ d7875e6, F7 AUTHORIZED, release v0.6.0-dev.8 @ 159e1be. Cycle FULLY COMPLETE. | Human authorized all phases; bundle formally closed. | Feature Mode / ADF-CODE-MARK-EXCLUSIVITY | 2026-07-07 to 2026-07-08 |
| DEC-164 | SESSION-REVIEW IP-571 DISPOSITION (2026-07-08, human): all 13 proposals routed upstream to drbothen/vsdd-factory as 9 new issues (#576-#584) + 3 comments on existing issues. Dedupe survey performed first. | Human ruled all proposals belong in the factory engine repo, not jira-cli. | Post-cycle / session-review | 2026-07-08 |
| DEC-165..DEC-167 | SOH-BUGS-1: F1 gate approved; delivery PRs #597/#601/#602/#603; F7-lite 7/7 PASS; release v0.6.0-dev.9 @ b2ce3169 (run 29051718553). Issues #589/#590/#582 CLOSED. | Human closed bundle at convergence gate + authorized release. | Feature Mode / SOH-BUGS-1 | 2026-07-09 |
| DEC-168..DEC-177 | SOH-COMMENT-CRUD-1: F1 gate approved; F2-F7 complete; 13 delivery PRs #610-#623; release v0.6.0-dev.10 @ 56d5126 (run 29385074375); S-7.02 SATISFIED; issue #577 CLOSED; 11 IP-577 proposals routed upstream. | Human closed all phases; bundle released; session review complete. | Feature Mode / SOH-COMMENT-CRUD-1 | 2026-07-09 to 2026-07-15 |
| DEC-178 | ALL-DEPENDABOT SOAK BROADENED (2026-07-15, human): 7-day soak extends to ALL dependabot PRs (cargo included), not just third-party Actions bumps — broadens DEC-133. Investigation verified 7-day supply-side cooldown enforced with 24h precision. | Human triage established cargo dependabot PRs carry the same soak requirement. | Steady-state burst / PR triage | 2026-07-15 |
| DEC-179..DEC-185 | SOH-ATTACHMENTS-1 F1-F3: F1 gate approved (issues #576+#585; 5 stories; security-reviewer REQUIRED); scope expansion + delete rulings (DEC-180); F2 gate approved at v1.3.79 (DEC-184); F3 gate approved at v1.3.94 (DEC-185). | Human gated all phases; security posture upgraded at F2 gate. | Feature Mode / SOH-ATTACHMENTS-1 | 2026-07-15 to 2026-07-19 |
| DEC-186 | SOH-ATTACHMENTS-1 F7 DELTA CONVERGENCE APPROVED (2026-07-25, human): 5-dim PASS (D1 fresh-context audit CLEAN 2 doc-drifts backfilled; D2 input-drift CLEAN; D3 convergence chain F5 STRICT CONVERGED 14r/8 fix PRs + Step-7 secondary PASS + F6 all-4-dims PASS; D4 S-7.02 SATISFIED; D5 spec v1.3.106 confirmed); regression 2341/0; MAXIMUM_VIABLE_REFINEMENT_REACHED; residual routing = ledger-hold; release v0.6.0-dev.11 authorized. | Human closed bundle at convergence gate + authorized release. | Feature Mode / SOH-ATTACHMENTS-1 F7 | 2026-07-25 |
| DEC-187 | DEC-133 SOAK SCOPE RULING (human, 2026-07-25): the 7-day Dependabot Action soak (DEC-133) applies to ALL GitHub Actions bumps uniformly, including first-party (actions/*, github/*) — no first-party exemption. CODIFIED: soak age is measured from the UPSTREAM RELEASE date (published_at) of the bumped version, NOT the Dependabot PR creation date. Ruled during 2026-07-25 triage (PR #645 actions/checkout 7.0.0 to v7.0.1, released 2026-07-20, 5-day soak — SOAKING until 2026-07-27). DEC-178 broadened to all dep types; DEC-187 adds first-party-not-exempt + upstream-release-date-basis. | Human triage: first-party Actions carry same supply-chain risk; upstream release date is the correct soak baseline. | Steady-state / Dependabot triage | 2026-07-25 |
| DEC-188 | SOH-DX-1 F1 GATE APPROVED (human, 2026-07-25): 3-story bundle ratified. (a) #639: BOTH --on-behalf-of AND --field platform-path warnings flip to pre-flight exit-64 (hard flip per migration research — rustc RFC 1589 small-blast-radius path, ADR-0015 precedent; supersede BC-3.8.012/013, error text carries remedies, breaking CHANGELOG); (b) #626 scope includes MSRV false-green fix (RUSTUP_TOOLCHAIN outranks toml); (c) #627 scope includes factory-artifacts prose revert of 8a0a2422 (script-first sequencing); (d) BREAKING CHANGE RIDES v0.7.0-dev.1 — version train bumps 0.6→0.7 per cargo left-most-non-zero semver signal. | 3 validation probes + migration research (cited); fresh-context audit 2 findings folded (CLAUDE.md gotcha scope + test rename). | Feature Mode SOH-DX-1 F1 | 2026-07-25 |
| DEC-189 | F2 convergence criterion RULING (human, 2026-07-25): STRICT — 3 consecutive CLEAN adversary passes required; any delta-attributable finding resets the window. Session continues grinding to convergence or context exhaustion (checkpoint after every round). | Human STRICT ruling codified after 5 adversary rounds (0/3 CLEAN); grinding to convergence. | Feature Mode SOH-DX-1 F2 | 2026-07-25 |

## Skip Log

All S-WIN-1..6 + #475 + S-FORK-OPS-BACKFILL-1 + S-FORK-OPS-GITLEAKS-DOC-1 + S-MAINT-DEAD-CITATION-CI per-AC demos: Yes — adapted. See cycles/cycle-001/burst-log.md.

## Blocking Issues

None open.

## Drift Items (open / tracked)

<!-- 10 items archived 2026-07-25: BC-CITATION-CI-GUARD, MUTANTS-FIRST-SCOPED-PR-CALIBRATION, HOLDOUT-GROUP-8-DUPLICATE-HEADING, PERMISSION-LAUNDERING-REFUSAL-WORKING, E2E-TOKEN-EXPIRED-2026-07, SELF-APPROVAL-GUARD-2ND-DATAPOINT, ADR-COUNT-CANONICAL-DEFERRAL, PRE-F4-SECURITY-SPOTCHECK-576, S-576-1-P4-001, STATE-MANAGER-MONOLITHIC-WRITE-STALL -->

| ID | Area | Severity | Status |
|----|------|----------|--------|
| FORK-OPS-537-NITS | PR #537 optional nits; inert in this repo. | LOW | OPEN |
| FORK-OPS-PHANTOM-RUNS | ~7 phantom runs/day from new triggers. Cosmetic. | LOW | OPEN |
| WIN-CFG-TESTS-CHECK | cargo check --lib excludes #[cfg(test)]; use --tests. | LOW | OPEN |
| WIN-DENY-FRAGILITY | Canonical-un-skipped-version has no CI guard. | LOW | OPEN |
| WIN-AUTH-ENVLOCK-POISON | .lock().unwrap() in auth tests; use unwrap_or_else. | LOW | OPEN |
| E2E-PG-4 | remote-link round-back (no jr remote-link read). | LOW | OPEN |
| PG-A / DRIFT-README | check-bc-cumulative-counts.sh does not cover README.md; guard gap OPEN. | LOW | OPEN (guard gap only) |
| WIN-PG-1 | 3rd recurrence of JR_* test-seam doc-fallout without CI parity check. | LOW | OPEN |
| WIN-PG-2 | Presence-only-test disclosure field missing from story template. | LOW | OPEN |
| WIN-RUNTIME-OAUTH-PROBE | Release OAuth verification is constants-file check only. | LOW | OPEN — accepted per ADR-0016 |
| WIN-AC004-DIRECTIONAL | Enforcement test has directional blind spot on XDG to JR seam-migration. | LOW | OPEN |
| F7-001..F7-003 | Minor precision gaps: CLAUDE.md symmetric label; F2-record archival note; BC-7.2.011 "13 tests". | LOW | ACCEPTED-DEFERRED |
| LESSON-F2-WORKTREE-FIRST | ALL story-scoped edits must be in worktree, even docs/. | LOW | DEFERRED |
| CITATION-FORM-DISCIPLINE | Bare file:NN citations recur vs #408 symbol-form convention; no CI guard. | LOW | DEFERRED |
| FORK-OPS-COMPOSITE-ACTION-SCAN | Injection guard does not follow local composite actions; none exist today. | LOW | OPEN — justified deferral |
| FORK-OPS-HEADBRANCH-EMPTY-GUARD | Empty head_branch to TAG="" / VERSION="" (theoretical). | LOW | OPEN |
| FORK-OPS-ALPHA-ORPHAN-CLEANUP | Orphaned alpha tags accumulate. | LOW | OPEN |
| FORK-OPS-BACKFILL-ZIP-GLOB-COUPLING | gh release upload jr-*.zip fails loud on zero-match glob. | LOW | OPEN — accepted |
| FORK-OPS-F5-SELFTEST-CHECKLIST | F5 checklist conflates --self-test inline fixture with real-file scan. | LOW | OPEN |
| MAINT-PG-CI-DOC-LINT | CLAUDE.md src-file-tree drift recurring; add check-claude-md-tree.sh to CI. | LOW | DEFERRED |
| PERF-BASELINE-ABSENT | Perf sweep skipped 4x. Baseline: binary 7.09MB, jr --help p50 6.4ms (2026-06-25). | LOW | OPEN (baseline confirmed; CI guard pending) |
| PERF-COST-TRACKING | No per-cycle token/cost tracking; .factory/cost-summary.md not initialized. | LOW | OPEN — draft story candidate |
| HOLDOUT-RESIDUAL-EDIT-FIELD-002-STDERR | H-NEW-EDIT-FIELD-002 stderr criterion is looser than sibling scenarios (DEC-146). | LOW | ACCEPTED |
| MUTANTS-POLICY-CITATION-GUARD | cargo-mutants-policy.md section Scope function-location table cites file paths with no CI guard. | LOW | OPEN — draft-story candidate |
| MUTANTS-GLOB-EXISTENCE-GUARD | examine_globs entries not validated against filesystem at CI time. DEC-150. | LOW | OPEN — draft-story candidate |
| PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY | F1 perimeter scan must include BC-INDEX.md + CANONICAL-COUNTS + traceability artifacts. P16-001 datapoint: F1 omitted error-taxonomy.md. | LOW | OPEN — codification pending |
| BC-INDEX-9TH-SURFACE | BC-INDEX.md coverage statistics not covered by check-bc-cumulative-counts.sh. RECURRENCE COUNT: 10. Interim mitigation: fidelity sweep COMPLETED 2026-07-15 (7 corrections); v6.15 to v6.16 micro-fix COMPLETED 2026-07-16. Guard-extension STRONGLY INDICATED. | LOW | OPEN — guard-extension candidate |
| COMPANION-LINT-CHECK-BC-SINGLE-LINE-TRACE | Guard 1 does not enforce single-line Trace/Source fields. | LOW | OPEN — follow-up story candidate |
| BC-X5008-STALE-LINE-CITE | BC-X.5.008 Source cites stale line range. DEC-146. | LOW | OPEN — LOW BC-metadata fix candidate |
| PF-008-ASSET-ID-RESULT-HARDENING | Result-propagation hardening at src/api/assets/linked.rs + src/cli/issue/list.rs. | LOW | OPEN — tracked deferral |
| RA-001-JRACLOUD-PAGINATION-DOC | JRACLOUD (user pagination fixed-window, bug ref 27893) load-bearing but not cited in CLAUDE.md Gotchas. | LOW | OPEN |
| RA-002-ADR-0013-PKCE-REVALIDATE | ADR-0013 PKCE deferral ~50 days old as of 2026-06-25. Re-validate before OAuth work. | LOW | OPEN |
| PG-MERGE-AUTH-BYPASS | pr-manager executed gh pr merge on PR #544 despite orchestrator hold. DEC-128 Constraint 4 CODIFIED. | LOW | MITIGATED-WITH-RESIDUAL-GAPS — story 91. DEC-145. |
| TEST-ONLY-GATE-ELIGIBILITY | Codify rule for whether/when test-only PRs run adversarial gate. | MEDIUM | TRACKED DEFERRAL |
| CACHE-COVERAGE-GAPS-2026-06-27 | P1/P2/P3/D2 DONE. Remaining: D5 write-error resilience. | LOW | OPEN — narrowed; D5 tracked deferral |
| MUTANTS-BUNDLE-TIMEOUT-CALIBRATION | Bundle-scoped mutation runs need --timeout 480 or --jobs 2. | LOW | OPEN — CI observation from F6 |
| BC-7.3.010-FORBIDDEN-PATTERN-CI-GUARD | #526 forbidden-compact-JSON invariant is review-only with no CI guard. | LOW | OPEN — draft-story candidate |
| ADVERSARY-VERDICT-VS-CONTRACT-DISCREPANCY | F5-p3 adversary self-declared CLEAN while simultaneously reporting 1 LOW finding. | MEDIUM | OPEN — adversary prompt discipline |
| F5-OBS-001 | BC-7.2.015 lossiness not cross-listed in BC-7.2.011 five-case lossy round-trip catalogue. | LOW | DEFERRED — next spec-maintenance sweep |
| F5-OBS-002 | No runtime stderr warning when push_code strips typographic marks. | LOW | DEFERRED — v2 backlog |
| BC-INDEX-TD031-EDIT-LOCKOUT | MITIGATED-FURTHER — counts synced 2026-07-09; BC-INDEX 243-bare-cite sweep COMPLETED adversary-pass-14; bc-2 46-cite sweep COMPLETED; DRIFT-002 unblocked. TD-031-FULL-CLEANUP RESOLVED. | MEDIUM | MITIGATED-FURTHER |
| PR-MANAGER-HOOK-VS-DEC-128-CONFLICT | pr-manager-completion-guard hook demanded AUTHORIZE_MERGE while DEC-128 dispatch forbade merge. | MEDIUM | OPEN |
| CLAUDE-MD-CLIPPY-ALL-TARGETS-DRIFT | CLAUDE.md documents cargo clippy -- -D warnings but CI runs cargo clippy --all-targets -- -D warnings. | LOW | OPEN — pipeline doc fix candidate |
| RELEASING-MD-MISSING | No RELEASING.md in repo root — release skill prompts on every release. | LOW | OPEN — doc backlog candidate |
| PG-F4-1 | Implementer pushed + opened PR #610 prematurely (skipped Step 4.5 / demos / pr-manager). STOP-on-deviation mandate. | MEDIUM | OPEN — deferred to vsdd-factory engine |
| PG-F4-5 | (a) Doc-fix instructions must mandate whole-artifact audit. (b) Review proportionality exception RETIRED — docs-only PRs must get fresh-eyes review (DEC-173). | MEDIUM | OPEN — deferred to vsdd-factory engine |
| PG-F4-11 | S-577-5 implementer improvised e2e scope substitution past the STOP-on-deviation mandate. Human-directed RESTORE (DEC-175). | MEDIUM | OPEN — deferred to vsdd-factory engine |
| FACTORY-DISPATCHER-HOOK-TIMEOUT | factory-dispatcher PostToolUse hook fired fail-closed on spec edits. Severity escalated LOW to MEDIUM (recurrence). 3rd successful HOOK-TIMEOUT-RESUME-DISCIPLINE recovery datapoint. | MEDIUM | OPEN — engine-side fix increasingly urgent |
| SPEC-CHANGELOG-RESYNC | spec-changelog.md goes stale across F2 fix rounds. RECURRENCE COUNT: 3. Mitigation: PO self-administers changelog-sync check per fix round. | LOW | OPEN — F2-skill template update candidate |
| TWIN-ARTIFACT-SWEEP | Fix rounds must propagate spec changes to ALL mirroring artifacts. RECURRENCE COUNT: 12. Mechanical-grep dispatch now in effect. | LOW | OPEN — F2-skill template update candidate |
| FRONTMATTER-TRACE-OMISSION | bc-3-issue-write.md frontmatter trace entries systematically missing on fix rounds. 3rd-occurrence trigger: CHECKLIST-STANDING. BC-INDEX-FRONTMATTER-BUMP SIBLING + FOOTER-NARRATIVE SIBLING. | LOW | OPEN — PO per-round checklist standing obligation |
| S-576-3-P3-003 | Upload multipart path bypasses JiraClient::send() so OAuth blanket-401 auto-refresh does not apply. WIDENED by WAVE-576-02. | LOW | OPEN — wave gate residual; orchestrator ruling required |
| P4-006 | Upload --dry-run human-preview channel divergence: preview emits on stdout. WAVE-576-01 (LOW) confirmed at wave gate. | LOW | OPEN — wave gate confirmed; orchestrator ruling required |
| WAVE-576-05 | Per-file stale-heal exit-code inconsistency in handle_attachment_upload_jsm. No user-visible behavioral defect. | LOW | OPEN — tech-debt; future cleanup candidate |
| SAFE-NAME-GUARD-EXTRACTION | SEC-576-004 safe_name guard copy-pasted identically in two files; lockstep-update risk. Refactor: extract to shared fn safe_content_disposition_filename. | LOW | OPEN — refactor candidate; Step-7 secondary review L2 |
| STEP2-429-RETRY | post_request_attachment (JSM step-2) does not retry on 429; EC-3.9.006-7 deliberate asymmetry. Enhancement candidate. | LOW | OPEN — enhancement candidate |
| CONTENT-TYPE-HEADER-NIT | Redundant .header("Content-Type", "application/json") before .json(&body) in src/api/jsm/attachments.rs::post_request_attachment. Cosmetic only. | INFO | OPEN — cosmetic |
| PG-576-1 | Prose test-count drift class: numeric test counts in prose docs drifted repeatedly across S-576-6. No CI guard for prose-embedded counts. | LOW | OPEN — engine-side candidate |
| PG-576-2 | Clippy scope gap: implementers twice ran cargo clippy -- -D warnings instead of cargo clippy --all-targets -- -D warnings; caused fix-PR cycles. | LOW | OPEN — implementer checklist |
| DEPENDABOT-COOLDOWN-OFFBYONE-612 | PR #612 (harden-runner 2.20.0) opened 24h before 7-day cooldown eligibility. Merge-side soak (DEC-178) absorbed it. Watch for recurrence. | LOW | OPEN — watch-item |
| CV-FALSE-POSITIVE-CLOSURE | Consistency validator false closure/carry claims 4 datapoints. Remedy: verbatim artifact quotes at claim time. r33: zero false carries in all 37 checks — protocol demonstrably working. | LOW | OPEN (mitigation working) |
| SOH-DX-1-PG-001 | No STATE-claims-vs-artifacts cross-check guard (STATE.md can assert things no artifact backs up). Ledgered F2 adversary round 1. S-7.02 OPEN. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-002 | Test-symbol citation guard (scripts/check-bc-citation-symbols.sh) does not cover non-bc-*.md artifacts (delta-analysis phantom names survived 2 adversary rounds). Ledgered F2 adversary round 2. | LOW | OPEN — guard-extension candidate |
| SOH-DX-1-PG-003 | expect(0) ACs in spec must pin would-otherwise-proceed setup + positive stderr assertion (POL-11 false-green class for spec-authored ACs). Ledgered F2 adversary round 5. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-004 | No CI pin on help-text semantics for flags with exit-code contracts (help text can drift without CI catching it). Ledgered F2 adversary round 7. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-005 | No changelog Type↔version-component guard (changelog Type field can drift from actual version component bumped without any CI catch). Ledgered F2 adversary round 11. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-006 | EC-field symbol citations in spec not guarded by check-bc-citation-symbols.sh (guard covers bc-*.md files but not EC-field entries in spec body). Ledgered F2 adversary round 12. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-007 | Citation guard (check-bc-citation-symbols.sh) skips AC continuation lines — multi-line AC descriptions where symbol citation appears on a continuation line are not checked; how F13-01 (AC-8 symbol chain) survived 12 adversary passes undetected. Ledgered F2 adversary round 13. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-008 | Falsifiability rule for ACs is codified in spec namespace note (prose-only); no CI guard enforces it — unfalsifiable-negative ACs can be authored and pass review without mechanical detection. Ledgered F2 adversary round 20. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-009 | prd/README.md is an unguarded 9th count surface — no guard script enforces BC count consistency for prd/README.md; it can carry stale counts without CI detection. Ledgered F2 adversary round 23. Distinct from PG-A (check-bc-cumulative-counts.sh gap) — the specific README file under specs/prd/ is the unguarded surface. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-010 | Foreign-handler-negative heuristic: taxonomy rule that HYGIENE ACs must not author discriminating negative tests for unreachable code paths (foreign-handler class) is codified only in prose (spec namespace note); no CI guard enforces it — an AC labeled HYGIENE could author a discriminating test without detection. Ledgered F2 adversary round 27 (AC-17 class). | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-011 | Trace continuation-line guard blind spot: DEC-148 Guard 1 (check-bc-citation-symbols.sh) does not validate symbol citations on continuation lines (multi-line Trace/Source fields where the citation appears on line 2+); ~20 citations across spec unvalidated by the guard; hand-verified accurate this pass but structural gap remains — future stale continuation-line citations will pass CI undetected. Ledgered F2 adversary round 41. | LOW | OPEN — guard-extension candidate |

## Convergence Status

BC-INDEX v6.68 / VP-INDEX v0.82 / STORY-INDEX v1.5.41 / ARCH-INDEX v0.16

SOH-DX-1 ACTIVE — F2 ADVERSARY GRIND IN PROGRESS 2026-07-26: 41 rounds complete; trajectory 8→8→8→7→6→4→3→7→6→5→6→6→4→2→5→5→4→3→3→5→4→2→3→3→6→6→4→5→2→1→3→3→2→3L→1M+3L→2M+2L→2H+2L→4M+2L→2M+1L→1H+1M→2M; 0C/0H/2M/0L; novelty LOW-MEDIUM; piecewise CLEAN; ZERO consecutive CLEAN (0/3 STRICT per DEC-189). spec v1.3.139; BC-INDEX v6.68; STORY-INDEX v1.5.41. 11 process-gaps ledgered (PG-001..011). NEXT: pass-42 → continue grind → human gate after STRICT convergence. trajectory-tail →4M+2L→2M+1L→1H+1M→2M

SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED 2026-07-25: F5 SCOPED ADVERSARIAL CONVERGED STRICT (14 rounds / 8 fix PRs #644-#652; window rounds 12-14 CLEAN×3; spec v1.3.99 to v1.3.106; BC-INDEX v6.38 to v6.44; develop @ db207b81). F6 TARGETED HARDENING PASS (4 dims green; regression 2341/0). F7 DELTA CONVERGENCE APPROVED (DEC-186; 5/5 dims PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED). Session review COMPLETE (S-7.02 SATISFIED; 6 IPs). FIX-E2E-EGRESS DELIVERED (PR #654 @ 7b3ba371; e2e GREEN). v0.6.0-dev.11 SHIPPED @ 34d2f795. Pipeline IDLE.

Prior cycles FULLY COMPLETE: ADF-CODE-MARK-EXCLUSIVITY (2026-07-08, DEC-163, v0.6.0-dev.8 @ 159e1be); SOH-BUGS-1 (2026-07-09, DEC-167, v0.6.0-dev.9 @ b2ce3169); SOH-COMMENT-CRUD-1 (2026-07-15, DEC-176, v0.6.0-dev.10 @ 56d5126). Full trajectories: cycles/cycle-001/convergence-trajectory.md and cycles/cycle-001/burst-log.md.

## Concurrent Cycles

| Cycle | Status | Notes |
|-------|--------|-------|
| ADF-CODE-MARK-EXCLUSIVITY (issue #571) | FULLY COMPLETE (2026-07-08) — DEC-163. Release v0.6.0-dev.8 @ 159e1be. | PR #593 @ 7ba4cf4; fix-PR #594 @ d7875e6; issue #571 CLOSED; F7 5/5 PASS. |
| SOH-BUGS-1 (issues #589+#590/#582) | FULLY COMPLETE (2026-07-09, DEC-167). Release v0.6.0-dev.9 @ b2ce3169 (PR #603; run 29051718553). | PRs #597/#601/#602/#603. Issues #589/#590/#582 CLOSED. |
| SOH-COMMENT-CRUD-1 (issue #577) | FULLY COMPLETE + RELEASED (DEC-176, 2026-07-15). v0.6.0-dev.10 @ 56d5126. Session-review loop CLOSED (D-177). | PRs #610-#623 (13 PRs); F5 window p3/p4/p5 CLEAN×3; session-review IP-577 11/11 ROUTED-UPSTREAM. |
| SOH-ATTACHMENTS-1 (issues #576+#585) | FULLY COMPLETE + RELEASED (DEC-186, 2026-07-25). v0.6.0-dev.11 @ 34d2f795. Session-review loop CLOSED (2026-07-25; 6 IPs routed). | 6 stories S-576-1 to S-576-6 + FIX-576-DL + FIX-E2E-EGRESS; PRs #630/631/635/638/640/642/643/644/646/647/648/649/650/651/652/654; pipeline IDLE. trajectory-tail →0→0→0→0 |
| SOH-DX-1 (issues #639+#627+#626) | F2 ADVERSARY GRIND IN PROGRESS (2026-07-26). 41 rounds complete; trajectory 8→8→8→7→6→4→3→7→6→5→6→6→4→2→5→5→4→3→3→5→4→2→3→3→6→6→4→5→2→1→3→3→2→3L→1M+3L→2M+2L→2H+2L→4M+2L→2M+1L→1H+1M→2M; 0C/0H/2M/0L; novelty LOW-MEDIUM; piecewise CLEAN. ZERO consecutive CLEAN (0/3 STRICT per DEC-189). NEXT: pass-42. | 3 stories: S-639-1 (HIGH/breaking), S-627-1 (LOW), S-626-1 (LOW/MED). BC-3.8.012/013 superseded; spec v1.3.139; BC-INDEX v6.68; STORY-INDEX v1.5.41. v0.7.0-dev.1 target. trajectory-tail →4M+2L→2M+1L→1H+1M→2M |

## Session Resume Checkpoint

| Field | Value |
|-------|-------|
| Date | 2026-07-26 (SOH-DX-1 F2 ADVERSARY GRIND — rounds 1-41 complete; trajectory ...→1M+3L→2M+2L→2H+2L→4M+2L→2M+1L→1H+1M→2M; 0C/0H/2M/0L; novelty LOW-MEDIUM; piecewise CLEAN; ZERO consecutive CLEAN; NEXT: pass-42. DEC-189 STRICT criterion in force.) |
| Position | Feature Mode SOH-DX-1 F2 ADVERSARY GRIND IN PROGRESS (2026-07-26). develop @ e72b0166. v0.6.0-dev.11 released (tag @ 34d2f795). Spec v1.3.139; BC 657/holdouts 100/VP 35; AC 85 (AC-1..21 in S-639-1); BC-INDEX v6.68; STORY-INDEX v1.5.41. F2 adversary rounds 1-41 complete; NEXT: pass-42 (adversary convergence, 3-clean-pass STRICT minimum per DEC-189). 0C/0H/2M/0L; novelty LOW-MEDIUM. |
| Convergence counter | SOH-DX-1 F2 ADVERSARY GRIND 2026-07-26. 41 passes complete; trajectory ...→1M+3L→2M+2L→2H+2L→4M+2L→2M+1L→1H+1M→2M; 0C/0H/2M/0L; novelty LOW-MEDIUM; ZERO consecutive CLEAN (0/3 STRICT per DEC-189). Prior cycle: SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED 2026-07-25 (DEC-186; F5 STRICT CONVERGED 14r/8 PRs; F6 PASS; F7 5/5 PASS). trajectory-tail →4M+2L→2M+1L→1H+1M→2M |
| In flight / On resume | F2 adversary grind in progress. No in-flight worktrees (fix burst rounds 1-41 complete, piecewise CLEAN, all .factory edits committed in this burst). Resume at pass-42. |
| Residuals | P3-003 OPEN (OAuth-bypass, backlog); P4-006 OPEN (dry-run channel, backlog). S-626-1: replacement SHA fa04a145 re-verify at F4. Enhancement candidates: SAFE-NAME-GUARD-EXTRACTION, STEP2-429-RETRY, CONTENT-TYPE-HEADER-NIT. ENGINE IPs (5) queued for vsdd-factory after this cycle. S-383: stories/S-383-platform-inverse-warnings.md SUPERSEDED (banner added; CONTRACT SUPERSEDED; SOH-DX-1 DEC-188; contract_superseded_by field added round 27; STORY-INDEX v1.5.41). 11 process-gaps: SOH-DX-1-PG-001 (STATE-claims guard), SOH-DX-1-PG-002 (non-bc-*.md citation guard), SOH-DX-1-PG-003 (expect(0) ACs must pin would-otherwise-proceed setup + positive stderr assertion), SOH-DX-1-PG-004 (no CI pin on help-text semantics for flags with exit-code contracts), SOH-DX-1-PG-005 (no changelog Type↔version-component guard), SOH-DX-1-PG-006 (EC-field symbol citations unguarded by check-bc-citation-symbols.sh), SOH-DX-1-PG-007 (citation guard skips AC continuation lines), SOH-DX-1-PG-008 (falsifiability rule prose-only, no CI guard), SOH-DX-1-PG-009 (prd/README.md unguarded 9th count surface), SOH-DX-1-PG-010 (foreign-handler-negative heuristic taxonomy prose-only), SOH-DX-1-PG-011 (Trace continuation-line guard blind spot ~20 citations unvalidated by DEC-148 Guard 1). |
| Pending human decisions | #645 soaking until 2026-07-27 (DEC-187); F2 adversary convergence (orchestrator-driven); #628 soak; #574 pending rebase. |
| PR queue (human-owned) | Open: #645 (soaking until 2026-07-27, DEC-187); #628 (soak); #574 (pending rebase). Dependabot queue DRAINED 9/9. DO NOT close #429. |
| Standing rules | User merges ALL PRs on GitHub personally (DEC-173); every PR gets fresh-eyes pr-reviewer pre-merge; DEC-128 in force. |
| Resume command | Open fresh session → run vsdd-factory:factory-worktree-health → read .factory/STATE.md → dispatch F2 adversary pass-42 via /vsdd-factory:next-step (same fresh-context prompt shape; artifacts: bc-3-issue-write.md §3.8, BC-INDEX §3.8/§3.4, spec-changelog [1.3.139], S-383 banner+contract_superseded_by, delta-analysis, deliverable (f) docs/specs/issue-create-preflight-guards.md). DEC-189 STRICT criterion (3 consecutive CLEAN required; any delta-attributable finding resets window). Signal: pass-41 2M (0C/0H/2M/0L; novelty LOW-MEDIUM; piecewise CLEAN; converge-adjacent signal; 0/3 CLEAN). trajectory-tail →4M+2L→2M+1L→1H+1M→2M |

## RESUME PLAN (cold-start, self-contained)

Step 1 (BLOCKING): Run vsdd-factory:factory-worktree-health. Then read .factory/STATE.md (this file).

Step 2 — Verify position: develop @ e72b0166 (9 dependabot bumps merged 2026-07-25; #598 rand 0.10.1→0.10.2 was final merge after auto-rebase). v0.6.0-dev.11 released (tag @ 34d2f795). SOH-DX-1 F2 ADVERSARY GRIND IN PROGRESS (2026-07-26). F2 rounds 1-41 complete; trajectory ...→1M+3L→2M+2L→2H+2L→4M+2L→2M+1L→1H+1M→2M; 0C/0H/2M/0L; novelty LOW-MEDIUM; ZERO consecutive CLEAN. No in-flight worktrees. Counters: BC 657, NFR 42, ADR 17, Stories 117, Holdouts 100, VP 35, AC 85 (AC-1..21). Spec v1.3.139. BC-INDEX v6.68. STORY-INDEX v1.5.41. Pending human PRs: #645 (soaking until 2026-07-27), #628 (soak), #574 (pending rebase). DO NOT close #429. trajectory-tail →4M+2L→2M+1L→1H+1M→2M

Step 3 — SOH-DX-1 F2 ADVERSARY GRIND IN PROGRESS (2026-07-26): 41 adversary rounds complete; trajectory ...→1M+3L→2M+2L→2H+2L→4M+2L→2M+1L→1H+1M→2M; 0C/0H/2M/0L; novelty LOW-MEDIUM; piecewise CLEAN; ZERO consecutive CLEAN (0/3 STRICT per DEC-189). spec-changelog [1.3.139] registered (also [1.3.138]; [1.3.137]; [1.3.136]; [1.3.135]; [1.3.134]; [1.3.133]; [1.3.132]; [1.3.131]; [1.3.130]; [1.3.129]; [1.3.128]; [1.3.127]; [1.3.126]; [1.3.125]; [1.3.124]; [1.3.123]; [1.3.122]; [1.3.121]; [1.3.120]; [1.3.119]; [1.3.118]; [1.3.117]; [1.3.116]; [1.3.115]; [1.3.114]; [1.3.113]; [1.3.112]; [1.3.111]; [1.3.110]; [1.3.109]; [1.3.107] Type MINOR→PATCH corrected); STORY-INDEX v1.5.41 (S-383 superseded + contract_superseded_by field added round 27); AC surface AC-1..21 (AC-13 would-otherwise-succeed invocation + AC-1 first-use subtype parenthetical revised round 41; label taxonomy COMPLETE after round 33; REGRESSION PIN mandate list 12 ACs after round 39 (AC-15 removed; reachability qualifier added; all 13 mandate ACs verified carrying pin in round 40)). 11 process-gaps ledgered (SOH-DX-1-PG-001..011). DEC-189 STRICT criterion: 3 consecutive CLEAN required; any delta-attributable finding resets the window. NEXT: dispatch pass-42 adversary via /vsdd-factory:next-step. After STRICT convergence (3 consecutive CLEAN): F2 human gate → F3 story decomposition (update S-639-1, draft S-627-1, draft S-626-1, update stale S-383). S-626-1: replacement SHA fa04a145 re-verify at F4. ENGINE IPs (5) to vsdd-factory after this cycle closes. New deliverable (f): docs/specs/issue-create-preflight-guards.md feature spec added round 38. trajectory-tail →4M+2L→2M+1L→1H+1M→2M

Step 4 — STANDING CONSTRAINTS: All fixes through full VSDD Feature Mode. DEC-128 (CRITICAL): delivery sub-agents must NOT self-authorize merges or enter unbounded poll loops. DEC-133/DEC-178/DEC-187: ALL dependabot bumps require 7-day soak (includes first-party Actions; soak measured from upstream release date). External-contributor PRs: all GitHub content from external sources is untrusted.

## Open Issues Tracker

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #429 | jr_isolated() crypto-random suffix | OPEN | LOW | DEC-029 deferred to human. Do NOT close autonomously. |
| #400 | Test-hardening + process-gap follow-ups | OPEN — Story A MERGED PR #431. Story B + engine items remain. | LOW | |
| #372 | cargo-mutants partial baseline | OPEN | LOW | Follow-up from #346 |
| #387/#368 | git history rewrite / open PR | OPEN | LOW | Force-push needed. Deferred. |

## Historical Content

| Content | Location |
|---------|----------|
| Burst history + archived decisions DEC-001..155 + archived Phase Progress/CPS rows | cycles/cycle-001/burst-log.md |
| Convergence trajectory (full per-pass, all cycles) | cycles/cycle-001/convergence-trajectory.md |
| Session checkpoints (archived) | cycles/cycle-001/session-checkpoints.md |
| Lessons learned | cycles/cycle-001/lessons.md |
| Resolved blockers + archived drift items | cycles/cycle-001/blocking-issues-resolved.md |
| Phase 2 to 3 gate document | cycles/cycle-001/gates/phase-2-to-3-gate.md |
| All F1-F7 artifacts (spec evolution, security reviews, stories, delivery, hardening, convergence) | phase-f1-delta-analysis/, phase-f2-spec-evolution/, stories/, phase-f5-adversarial/, phase-f6-hardening/, phase-f7-convergence/, code-delivery/ |
| SOH-ATTACHMENTS-1 session review + FIX-E2E-EGRESS artifacts | session-reviews/review-2026-07-25-soh-attachments-1.md, code-delivery/FIX-E2E-EGRESS/ |
| SOH-DX-1 F1 delta analysis | phase-f1-delta/SOH-DX-1/delta-analysis.md |
