---
document_type: pipeline-state
level: ops
version: "2.0"
status: active
producer: state-manager
timestamp: 2026-07-07T23:59:59Z
phase: 3
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "ADF-CODE-MARK-EXCLUSIVITY (issue #571): F2 spec delta + 16 adv passes / 13 fix rounds. BC-INDEX v6.12, VP-INDEX v0.82, STORY-INDEX v1.02, ARCH-INDEX v0.16. D-chain cite D-27893 latest brownfield. BC 612. Holdouts 83. STREAK 0/3 STRICT (DEC-158). trajectory-tail →1→0→2→3. Pass 17 dispatched."
maintenance_run: CLOSED
current_cycle: "cycle-001"
feature_mode_bundle: ADF-CODE-MARK-EXCLUSIVITY
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: IN_PROGRESS
activation_head: "342987f"
activation_version: "v0.6.0-dev.7"
---

<!--
  STATE.md SIZE BUDGET (per D-421(c)):
  Hard cap (500 lines) margin from soft-target = 500 - 273 = 227; margin from actual = 500 - 273 = 227 (D-446(c) dual-margin form). 273 lines (wc-l).
  Hard cap: 500 lines.
-->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop → main |
| **Last Updated** | 2026-07-07: ADF-CODE-MARK-EXCLUSIVITY F2 checkpoint #2 — 16 adv passes / 13 fix rounds complete; STREAK 0/3 (STRICT, DEC-158); trajectory-tail →1→0→2→3; Pass 17 dispatched. DEC-158 ratified (Q1=STRICT/Q2=yes/Q3=yes). Process gaps banked: TWIN-ARTIFACT-SWEEP (×3), PHASE-DOC-RETRO-ANNOTATION. Pre-existing surfaced: H-NEW-JSM-RT-001-FIXTURE-NONDESERIALIZABLE, HOLDOUT-GROUP-8-DUPLICATE-HEADING. Prior: F2 passes 1-5/4 fix rounds STREAK 1/3; DEC-157; BC 612; Stories 102. |
| **Current Phase** | Phase 3 — **ADF-CODE-MARK-EXCLUSIVITY F2 IN PROGRESS** (issue #571). Spec delta: prd-delta-571.md (BC-7.2.015 ADD + BC-7.2.007 EC-2 MODIFY) + verification-delta-571.md; spec v1.3.25. 16 adversarial passes / 13 fix rounds complete. STREAK 0/3 (STRICT criterion, DEC-158). Pass 17 (verification-adequacy final) dispatched. BC **612**. NFR 42. ADR 16. Stories **102**. Holdouts **83**. |
| **Next Phase** | Pass 17 (verification-adequacy final) in progress. Under STRICT (DEC-158): any delta-attributable LOW resets. Core contract finding-free since pass 12; residual = instruction-layer polish. Target: 3 consecutive STRICT-clean passes. Then F3 story decomposition. |
| **Activation HEAD** | 342987f (v0.6.0-dev.7 tag); develop @ 0d8a8a5 (PR #592 squash-merged 2026-07-07 by human; CITATION-GUARDS CYCLE CLOSED DEC-156) |

## Phase Progress

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
<!-- archived: Phase 0–2 + Feature cycles 2026-05-04..2026-07-07 + CITATION-GUARDS rows + F1 GATE APPROVED row + F2 SPEC DELTA row (archived checkpoint #2 burst) -->
| Phase | Status | Completed | Gate | Notes |
|-------|--------|-----------|------|-------|
| **fix burst 4 (ADF-CODE-MARK-EXCLUSIVITY F2 — after pass-4, 2026-07-07)** | **COMPLETE** | **2026-07-07** | **4th fix round: BC-INDEX Coverage Statistics row updated (BC-INDEX-9TH-SURFACE RECURRENCE×2) + spec-changelog re-synced to v1.3.25. Pass-4 findings (2M+3L) all resolved. All 4 F2 fix rounds closed.** | BC 612. Holdouts 83. spec v1.3.25. develop @ 0d8a8a5 UNCHANGED. |
| **pass-5 adversary (ADF-CODE-MARK-EXCLUSIVITY F2 — evaluator-simulation/ground-truth lens, 2026-07-07)** | **COMPLETE** | **2026-07-07** | **CLEAN — 1 LOW-informational VA observation, non-resetting per DEC-153. STREAK 1/3.** | trajectory-tail →4→5→5→0. STREAK 1/3 (pre-DEC-158). |
| **DEC-158 recorded — F2 STRICT criterion + scope rulings ratified (2026-07-07)** | **COMPLETE** | **2026-07-07** | **Human ratified Q1=STRICT (any delta-attributable LOW resets; VA-informational exempt per DEC-153); Q2=yes opportunistic pre-existing repairs; Q3=yes consolidate unguarded-count-surface into BC-INDEX-9TH-SURFACE guard-extension candidate. DEC-158.** | Supersedes STANDARD criterion for this F2 loop. |
| **F2 passes 6-16 / fix rounds 5-13 complete — STREAK 0/3 STRICT (2026-07-07)** | **COMPLETE** | **2026-07-07** | **P6(1L-BC-INDEX-9TH-SURFACE×3): fixed. P7: CLEAN. P8(4M-test-writer): fixed+TWIN-ARTIFACT-SWEEP×1. P9(1M-implementer): fixed+TWIN-ARTIFACT-SWEEP×1. P10: CLEAN. P11(3M-story-writer): fixed+PHASE-DOC-RETRO-ANNOTATION+TWIN-ARTIFACT-SWEEP×1. P12(1M-security-final-MED): fixed. P13(1L): fixed. P14: CLEAN. P15(2L)+H-NEW-JSM-RT-001-FIXTURE-NONDESERIALIZABLE surfaced. P16(3L)+HOLDOUT-GROUP-8-DUPLICATE-HEADING surfaced. Core contract clean since p12.** | trajectory →3→4→5→5→0→1→0→4→1→0→3→1→1→0→2→3. STREAK 0/3 STRICT. |
| **Pass 17 (verification-adequacy final) dispatched — ADF-CODE-MARK-EXCLUSIVITY F2 (2026-07-07)** | **IN_PROGRESS** | **2026-07-07** | **Final verification-adequacy lens pass dispatched. If CLEAN → streak 1/3 STRICT; if findings → fix round 14.** | trajectory-tail →1→0→2→3. STREAK 0/3 STRICT. Pass 17 in flight. develop @ 0d8a8a5 UNCHANGED. |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
<!-- archived: CITATION-GUARDS rows + F1 GATE APPROVED + F1 DELTA ANALYSIS rows (archived checkpoint #2 burst) -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| **ADF-CODE-MARK-EXCLUSIVITY F2 SPEC DELTA AUTHORED (2026-07-07)** — prd-delta-571.md: BC-7.2.015 ADD (bandable BC-7.2.016..058) + BC-7.2.007 EC-2 MODIFY (allowlist framing: retain link/annotation; strip strong/em/strike/subsup/text). verification-delta-571.md. H-NEW-ADF-010 (calls A-E incl. JSM Call E). spec v1.3.25. BC-INDEX, CANONICAL-COUNTS, bc-7-output-render.md, bc-07-output-render.md updated. 3 guard scripts exit 0. | PO + spec-steward | COMPLETE | BC 612. Holdouts 83. spec v1.3.25. |
| **ADF-CODE-MARK-EXCLUSIVITY F2 ADV PASSES 1-5 / 4 FIX ROUNDS COMPLETE — STREAK 1/3 pre-DEC-158 (2026-07-07)** — P1(2M+1L): coherence/registration. P2(1CRIT+1M+2L): Call E fixture 3 sub-defects. P3(1M+4L): implementability, CLAUDE.md scope adjudicated. P4(2M+3L): BC-INDEX-9TH-SURFACE×2; spec-changelog. P5: CLEAN(evaluator-simulation). New drift: SPEC-CHANGELOG-RESYNC, ADVERSARY-WRITE-TOOL-MISMATCH, D-CHAIN-VALIDATOR-SUBSTRING-FALSE-POSITIVE. | state-manager | COMPLETE | trajectory-tail →4→5→5→0. STREAK 1/3. |
| **DEC-158 ratified — F2 STRICT criterion + Q1/Q2/Q3 scope rulings (2026-07-07)** — Human ratified: Q1=STRICT (any delta-attributable LOW resets streak; VA-informational exempt per DEC-153); Q2=yes (opportunistic pre-existing repairs ride the cycle); Q3=yes (consolidate unguarded-count-surface findings into BC-INDEX-9TH-SURFACE guard-extension candidate). Supersedes STANDARD for this F2 loop. | state-manager | COMPLETE | DEC-158. develop @ 0d8a8a5 UNCHANGED. |
| **ADF-CODE-MARK-EXCLUSIVITY F2 PASSES 6-16 / FIX ROUNDS 5-13 COMPLETE — STREAK 0/3 STRICT (2026-07-07)** — Passes 7/10/14 CLEAN; resets at p6(1L-BC-INDEX-9TH-SURFACE×3), p8(4M-test-writer+TWIN-ARTIFACT-SWEEP), p9(1M-implementer+TWIN-ARTIFACT-SWEEP), p11(3M-story-writer+PHASE-DOC-RETRO-ANNOTATION+TWIN-ARTIFACT-SWEEP), p12(1M-security), p13(1L), p15(2L), p16(3L). Core contract clean since p12; residual = instruction-layer polish. Pre-existing banked: H-NEW-JSM-RT-001-FIXTURE-NONDESERIALIZABLE, HOLDOUT-GROUP-8-DUPLICATE-HEADING. | state-manager | COMPLETE | trajectory-tail →1→0→2→3. STREAK 0/3 STRICT. |
| **Pass 17 (verification-adequacy final) dispatched — ADF-CODE-MARK-EXCLUSIVITY F2 (2026-07-07)** — Final adversarial pass dispatched under STRICT criterion. If CLEAN → streak 1/3; if findings → fix round 14 + pass 18. | orchestrator | IN_PROGRESS | Pass 17 in flight. develop @ 0d8a8a5 UNCHANGED. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-001..DEC-124 | Phase 0/1/2/3 + Wave + Feature Mode + #492 + #522 + S-TESTTOOL-1 + S-FORK-OPS-SIGN-1 + S-FORK-OPS-BACKFILL decisions. Pattern: full VSDD catches CRIT/HIGH on "trivial" infra changes (DEC-120/121/124). All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 0→3 / 2026-05-04..2026-06-19 | archived |
| DEC-125..DEC-145 | Phase 3 Feature Mode cycles: DEAD-CITATION-CI (DEC-125..130), maintenance sweep 2026-06-22 (DEC-131), SEC-001/Bundle-D (DEC-132), DEPENDABOT-ACTION-SOAK policy (DEC-133), D4 holdout refresh (DEC-134), cache-coverage audit (DEC-135), PRs #560/#561 retroactive rigor (DEC-136), E2E edge-case audit (DEC-137), BC-sub-clause pass (DEC-138), E2E offline-CLI tier (DEC-139), E2E wiremock tier (DEC-140), E2E G-ADF-FOOTNOTE holdout tier (DEC-141), cache P3+D2 PR #565 (DEC-142), cmdb/objtype warm-hit PR #566 (DEC-143), MUTATION-CI-TIMEOUT PR #567 (DEC-144), S-PG-MERGE-AUTH-BYPASS re-assessment (DEC-145). All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 3 / 2026-06-20..2026-06-28 | archived |
| DEC-156 | **CITATION-GUARDS CYCLE CLOSED — Story A (PR #572 @ ab78a2d) + Story B (PR #592 @ 0d8a8a5) both DELIVERED. Guard family complete: CLAUDE.md citations (BC-X.13.001..003) + mutants-policy/examine_globs (Guards 2+3, DEC-150) + BC-body Trace/Source citations (Guard 1, BC-X.13.004..006). Story B totals: F3 15 passes/9 rounds (DEC-155) + F4 4 passes/2 rounds; DEC-153 standard criterion validated. Task 0 hygiene fixed 12+ real dead citations; guard now enforces 309 citations in CI. BC-CITATION-CI-GUARD drift CLOSED.** | CITATION-GUARDS bundle complete — both stories delivered, guard family enforced in CI. | Feature Mode / CITATION-GUARDS | 2026-07-07 |
| DEC-157 | **ADF-CODE-MARK-EXCLUSIVITY F1 gate approved 2026-07-07 (human): 5-point scope ratified — (1) emit-site filter in `src/adf.rs::push_code` only; (2) no node-splitting; (3) `apply_marks` reverse-path read-tolerance retained; (4) standalone BC-7.2.015 approved (bandable BC-7.2.016..058); (5) STANDARD convergence criterion (DEC-153 precedent; 3 consecutive clean diverse-lens passes). H-NEW-ADF-010 authorized (F2, calls A-E incl. JSM Call E).** | Human gate cleared; F2 dispatch authorized. All 5 scope questions answered affirmatively. | Feature Mode / ADF-CODE-MARK-EXCLUSIVITY | 2026-07-07 |
| DEC-158 | **F2 convergence criterion STRICT + scope rulings (2026-07-07, human): Q1=STRICT — any delta-attributable LOW resets streak; VA-informational observations exempt per DEC-153 (same as DEC-153 precedent). Q2=yes — opportunistic pre-existing repairs ride the cycle. Q3=yes — consolidate unguarded-count-surface findings (BC-INDEX-9TH-SURFACE, holdout-total, subsection-sum) into BC-INDEX-9TH-SURFACE guard-extension candidate.** | Human ratified mid-cycle checkpoint #2 after 11 uncommitted F2 rounds (passes 6-16 + fix rounds 5-13). Supersedes STANDARD criterion for this F2 loop only. | Feature Mode / ADF-CODE-MARK-EXCLUSIVITY F2 | 2026-07-07 |

## Skip Log

All S-WIN-1..6 + #475 + S-FORK-OPS-BACKFILL-1 + S-FORK-OPS-GITLEAKS-DOC-1 + S-MAINT-DEAD-CITATION-CI per-AC demos: **Yes — adapted**. CI-config / infra / docs / test-only / platform-cfg stories. Guard's own green CI run (58 tests passing in ci-gate) is per-AC demo evidence. See `cycles/cycle-001/burst-log.md`.

## Blocking Issues

None open.

## Drift Items

<!-- OPEN/TRACKED items only. Resolved → cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Area | Description | Severity | Status |
|----|------|-------------|----------|--------|
| FORK-OPS-537-NITS | PR #537 optional nits | PR #537 carries 2 optional LOW nits: (a) tighten TeamIdentifier regex; (b) soften Bug-2 signed-DMG rationale. Inert in this repo. | LOW | OPEN |
| FORK-OPS-PHANTOM-RUNS | Phantom workflow runs | ~7 phantom runs/day from new triggers. Cosmetic; decide suppress or accept. | LOW | OPEN |
| WIN-CFG-TESTS-CHECK | Cross-compile | cargo check --lib excludes #[cfg(test)]; use --tests. | LOW | OPEN |
| WIN-DENY-FRAGILITY | deny.toml | Canonical-un-skipped-version has no CI guard. | LOW | OPEN |
| WIN-AUTH-ENVLOCK-POISON | ENV_LOCK poison | .lock().unwrap() in auth tests; use unwrap_or_else. | LOW | OPEN |
| E2E-PG-4 | E2E coverage gap | remote-link round-back (no jr remote-link read). | LOW | OPEN |
| PG-A / DRIFT-README | Count guards | check-bc-cumulative-counts.sh does not cover README.md; guard gap OPEN. README content resolved by factory commit e72bcb9. | LOW | OPEN (guard gap only) |
| WIN-PG-1 | No BC-count CI guard | 3rd recurrence of JR_* test-seam doc-fallout without CI parity check. | LOW | OPEN |
| WIN-PG-2 | Story template | Presence-only-test disclosure field missing from story template. | LOW | OPEN |
| WIN-RUNTIME-OAUTH-PROBE | Windows OAuth probe | Release OAuth verification is constants-file check only; no runtime jr auth status. | LOW | OPEN — accepted per ADR-0016 |
| WIN-AC004-DIRECTIONAL | XDG→JR seam-migration | Enforcement test has directional blind spot. | LOW | OPEN |
| F7-001..F7-003 | Minor precision gaps | CLAUDE.md symmetric label; F2-record archival note; BC-7.2.011 "13 tests". | LOW | ACCEPTED-DEFERRED |
| #492-TEST-HARNESS-COUPLING | process-gap | Handler-level block-HTML tests couple to push_text shape. | LOW | TRACKED DEFERRAL |
| #492-PG-TRACE-TESTS | process-gap | No CI check that BC Source/Trace-cited test symbols resolve to real #[test] fns. Reinforced 2026-06-22. | LOW | TRACKED DEFERRAL |
| LESSON-F2-WORKTREE-FIRST | process-gap C-1 | ALL story-scoped edits in worktree, even docs/. Codified in lessons.md. | LOW | DEFERRED |
| CITATION-FORM-DISCIPLINE | process-gap | Bare file:NN citations recur vs #408 symbol-form convention; no CI guard. | LOW | DEFERRED |
| F7-COSMETIC-ATTR-ORDER | cosmetic | Story Architecture Rule 3 says #[ignore] before #[test]; code uses #[test] first. | LOW | ACCEPTED-COSMETIC |
| FORK-OPS-COMPOSITE-ACTION-SCAN | sign-and-publish.yml | Injection guard does not follow local composite actions; none exist today. | LOW | OPEN — justified deferral |
| FORK-OPS-HEADBRANCH-EMPTY-GUARD | sign-and-publish.yml | Empty head_branch → TAG=""/VERSION="" (theoretical CWE-74). Future story. | LOW | OPEN |
| FORK-OPS-ALPHA-ORPHAN-CLEANUP | sign-and-publish.yml | Orphaned alpha tags from failed runs accumulate. Future housekeeping story. | LOW | OPEN |
| FORK-OPS-BACKFILL-ZIP-GLOB-COUPLING | backfill-release.yml | `gh release upload jr-*.zip` fails loud on zero-match glob (accepted; guarded). | LOW | OPEN — accepted |
| FORK-OPS-F5-SELFTEST-CHECKLIST | process-gap | F5 checklist conflates `--self-test` inline fixture with real-file scan; wording could mislead. | LOW | OPEN |
| MAINT-PG-CI-DOC-LINT | process-gap | CLAUDE.md src-file-tree drift recurring; add scripts/check-claude-md-tree.sh to CI. | LOW | DEFERRED |
| PERF-BASELINE-ABSENT | coverage-gap | Sweep 5 (perf) skipped 4× — baseline re-confirmed 2026-06-25: binary 7.09MB, `jr --help` p50 6.4ms. | LOW | OPEN (baseline confirmed; CI guard pending) |
| PERF-COST-TRACKING | instrumentation | No per-cycle token/cost tracking; `.factory/cost-summary.md` not initialized. | LOW | OPEN — draft story candidate |
| HOLDOUT-RESIDUAL-EDIT-FIELD-002-STDERR | accepted-residual | H-NEW-EDIT-FIELD-002 stderr criterion is looser than sibling scenarios (accepted per DEC-146). | LOW | ACCEPTED |
| MUTANTS-POLICY-CITATION-GUARD | process-gap | `docs/specs/cargo-mutants-policy.md §Scope` function-location table cites file paths/functions with no CI guard. DEC-150. | LOW | OPEN — draft-story candidate |
| MUTANTS-GLOB-EXISTENCE-GUARD | process-gap | `examine_globs` entries in `.cargo/mutants.toml` are not validated against the actual repo filesystem at CI time. DEC-150. | LOW | OPEN — draft-story candidate |
| F1-SWEEP-INCLUDES-CI-YML-COMMENTS | process-gap | F1 delta analysis missed stale scope comment at `ci.yml:195`; fresh-context F5 adversary caught it. DEC-150. | LOW | OPEN — justified deferral |
| CICD-SETUP-CLASSIFICATION | process-gap | `.factory/cicd-setup.md` governance classification is ambiguous. Human input required. DEC-150. | LOW | OPEN — justified deferral |
| DOC-LINK-SWEEP-CANDIDATE-1 | doc hygiene | `docs/specs/jsm-e2e-coverage.md:903` cites stale ADR-0014 filename. DEC-149. | LOW | OPEN — doc-link sweep candidate |
| DOC-LINE-DRIFT-CANDIDATE-1 | doc hygiene | `docs/specs/2026-05-13-search-issue-keys.md:7` cites stale line range. DEC-149. | LOW | OPEN — line-cite drift candidate |
| PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY | process-gap | F1 perimeter scan must include BC-INDEX.md + CANONICAL-COUNTS + traceability artifacts. | LOW | OPEN — process-gap codification pending |
| BC-CITATION-CI-GUARD | process-gap | No CI guard validates file::symbol citations in `.factory/specs/prd/*.md` BC bodies. | LOW | CLOSED — Guard 1 delivered (PR #592 @ 0d8a8a5, DEC-156). |
| BC-INDEX-9TH-SURFACE | process-gap | BC-INDEX.md coverage statistics not covered by `check-bc-cumulative-counts.sh`. **RECURRENCE COUNT: 3** (p1: holdout-total; p4: Coverage-Statistics count; p6: subsection-sum). | LOW | OPEN — guard-extension candidate |
| COMPANION-LINT-CHECK-BC-SINGLE-LINE-TRACE | process-gap | Guard 1 does not enforce single-line Trace/Source fields. Companion lint follow-up. | LOW | OPEN — follow-up story candidate |
| BC-X5008-STALE-LINE-CITE | BC metadata | BC-X.5.008 Source cites `src/duration.rs:38-42` (stale vs ~74-80). DEC-146. | LOW | OPEN — LOW BC-metadata fix candidate |
| PF-008-ASSET-ID-RESULT-HARDENING | code hygiene | Result-propagation hardening of asset.id panic→JrError at `src/api/assets/linked.rs` + `src/cli/issue/list.rs`. | LOW | OPEN — tracked deferral |
| RA-001-JRACLOUD-27893-DOC | risk | JRACLOUD-27893 (user pagination fixed-window) is load-bearing in users.rs but not cited in CLAUDE.md Gotchas. | LOW | OPEN |
| RA-002-ADR-0013-PKCE-REVALIDATE | risk | ADR-0013 PKCE deferral assumption ~50 days old as of 2026-06-25. Re-validate before any OAuth work. | LOW | OPEN |
| F1-CI-TOPOLOGY-CHECK | phase-f1 process | F1 delta analysis lacks CI-checkout-topology verification step. Update phase-f1 skill template. | LOW | OPEN — skill template update |
| PG-MERGE-AUTH-BYPASS | pr-manager delivery | pr-manager executed `gh pr merge` on PR #544 despite orchestrator hold. DEC-128. Audit 2026-06-28: Constraint 4 CODIFIED; Constraints 1–3 PARTIALLY-MITIGATED. | LOW | MITIGATED-WITH-RESIDUAL-GAPS — S-PG-MERGE-AUTH-BYPASS (story 91). DEC-145. |
| MUTANTS-ARBITER-OFFLINE-SELFTEST | process-gap | The kill-rate arbiter bash has no offline fixture self-test. | LOW | OPEN — justified deferral |
| MUTANTS-PARTIAL-SCHEMA-RESIDUAL | accepted-residual | Partial `outcomes.json` summary-key rename evades the all-zero schema-drift guard; mitigated by @27 pin. | LOW | ACCEPTED |
| MUTANTS-SHARDING-PATH-B | enhancement | Path B (shard across CI matrix + `--baseline=skip`) deferred when human chose Path A. | LOW | OPEN — deferred |
| MUTANTS-FIRST-SCOPED-PR-CALIBRATION | watch-item | **0-MUTANT PATH: CONFIRMED-GOOD ×4.** src/adf.rs in scope for F4 = first code-mutant path candidate. | LOW | OPEN — code-mutant path still unexercised |
| RETROACTIVE-STORY-FILES-MISSING | process-gap | Stories 98 + 99 counted in STATE.md but no story files ever created. | LOW | OPEN |
| PG-PR-MANAGER-OVERREACH | process-gap | pr-manager autonomously spawned sub-agents + pushed commits during PR #553. Covered by S-PG-MERGE-AUTH-BYPASS scope extension. | LOW | MITIGATED-WITH-RESIDUAL-GAPS — covered by story 91. DEC-145. |
| REFACTOR-ISSUE-CLI-SHARD | architecture | Seam A+B DONE (PRs #556+#558). Seam C DEFERRED indefinitely. | LOW | RESOLVED-PARTIAL |
| RELEASE-CI-NETWORK-FLAKE | release-infra | release.yml Windows build (v0.6.0-dev.7) hit transient crates.io failure; resolved by `gh run rerun`. | LOW | OPEN |
| TEST-ONLY-GATE-ELIGIBILITY | process-gap | Codify rule for whether/when test-only PRs run adversarial gate. | MEDIUM | TRACKED DEFERRAL |
| CACHE-COVERAGE-GAPS-2026-06-27 | test-coverage | P1/P2/P3/D2 DONE. Remaining: D5 write-error resilience at project_meta/workspace call-sites. | LOW | OPEN — narrowed; D5 tracked deferral |
| ADVERSARY-DISPATCH-IDENTITY-TUPLE | process-gap | Orchestrator adversary dispatches omit the formal Worktree-Identity tuple. | LOW | OPEN — justified deferral |
| BC-7.3.010-FORBIDDEN-PATTERN-CI-GUARD | process-gap | The #526 forbidden-compact-JSON invariant is review-only with no CI guard. | LOW | OPEN — draft-story candidate |
| ADF-RECURSION-TEST-NITS | code/doc hygiene | (1) imprecise "wiremock 501" comment in `tests/adf_recursion_depth.rs:~81`; (2) BC-7.2.014 Motivation-prose confidence-hedge. | LOW | OPEN — accepted cosmetic |
| POLICY-DOC-NON-SCOPE-CITATIONS | process-gap | Guard 2 scoped to §Scope only. Policy-doc fn citations outside §Scope remain driftable. | LOW | OPEN — cycle-close disposition pending |
| POLICY-DOC-ZERO-PAIR-OPT-OUT | process-gap | Guard 2: bullet with zero backticks passes check — effectively an opt-out path. | LOW | OPEN — cycle-close disposition pending |
| EXTRACTION-SET-PIN | process-gap | Guard 2 validates citation count but not the extracted (file, fn) SET. Mitigated by fresh-context F5. | LOW | OPEN — draft-story candidate |
| INTERNAL-PR-CITATION-RIGOR | process-gap | PR-number attributions in spec prose need verify-before-cite discipline. | LOW | OPEN — cycle-close disposition pending |
| ADVERSARY-META-LENS-REGRESS | process-gap | Verification-adequacy lens generates unbounded meta-level findings on guard-spec stories; engine needs convergence rule. | LOW | OPEN — engine-level rule needed |
| SCOPE-EMPTY-THREE-VS-TWO-CAUSE | story/spec | SCOPE_EMPTY message three-cause vs two-cause wording — adjudicate at cycle close. | LOW | OPEN — story-side adjudication at cycle close |
| SCOPE-EXAMINE-GLOBS-CROSS-SET-EDGE | coverage-gap | Guard 2 §Scope↔examine_globs cross-set edge is unguarded (pass-8 F-P8-01). | LOW | OPEN — follow-up story candidate |
| BACKTICK-RESERVATION-CONVENTION | doc-hygiene | Backtick-reservation convention in §Scope bullets is undocumented. | LOW | OPEN — doc-sentence candidate |
| ENGINE-BC-ID-INJECTION | process-gap | Stub-architect injected engine-internal BC-ID BC-5.38.001 into product source rustdoc (5 sites) during F4 Red Gate. | LOW | OPEN — engine prompt hygiene (justified deferral) |
| STORY-ENGINE-BC-CITATION | story/spec | Story S-MUTANTS-SCOPE-GUARDS-1 cites engine-internal BC reference. Adjudicate at cycle close. | LOW | OPEN — cycle-close adjudication |
| SEC-001-GUARD1-ERE-PREFLIGHT | security | Guard 1 bash script has no ERE-injection preflight guard on identifier-shaped CLI args. | LOW | OPEN — follow-up story candidate |
| SEC-002-GUARD1-BCDIR-DASH | security | Guard 1 bash script has no leading-dash flag-value guard on `--bc-dir` arg. | LOW | OPEN — follow-up story candidate |
| GUARD1-BCDIR-CWD-RELATIVE | coverage-gap | Guard 1 `--bc-dir` defaults to cwd-relative while file-path resolution uses REPO_ROOT-anchored paths. | LOW | OPEN — accepted residual / follow-up candidate |
| SPEC-CHANGELOG-RESYNC | process-gap | spec-changelog.md goes stale across F2 fix rounds; no mandatory final-round re-sync step in F2 skill template. ADF-CODE-MARK F2 pass-4. | LOW | OPEN — F2-skill template update candidate |
| ADVERSARY-WRITE-TOOL-MISMATCH | process-gap | F2 adversary agent has read-only tools but phase-f2 skill asks it to write review files; reviews returned inline. ADF-CODE-MARK F2. | LOW | OPEN — skill template / agent config fix candidate |
| D-CHAIN-VALIDATOR-SUBSTRING-FALSE-POSITIVE | process-gap | D-chain validator matched "D-27893" inside "JRACLOUD-27893" — substring false positive. Validator should require word-boundary matching. ADF-CODE-MARK F2 pass-4. | LOW | OPEN — validator regex hardening candidate |
| TWIN-ARTIFACT-SWEEP | process-gap | Fix rounds must propagate spec changes to ALL mirroring artifacts (prd-delta + domain-spec + BC-INDEX + CANONICAL-COUNTS). 3 instances in ADF-CODE-MARK F2 (passes 8/9/11). | LOW | OPEN — F2-skill template update candidate |
| PHASE-DOC-RETRO-ANNOTATION | process-gap | F1 delta analysis artifacts (impact-boundary, artifact-mapping) need retro-annotation when F2 decisions supersede F1 scope. Pattern: F1 superseding notes. ADF-CODE-MARK F2 pass-11. | LOW | OPEN — F2 skill template update candidate |
| H-NEW-JSM-RT-001-FIXTURE-NONDESERIALIZABLE | holdout pre-existing | H-NEW-JSM-RT-001 holdout fixture JSON uses `projectKey` field but Atlassian API returns `projectId` — deserialization failure. Same class as this cycle's Call E CRIT (pass 2). ADF-CODE-MARK F2 pass-15. | LOW | OPEN — future holdout sweep candidate |
| HOLDOUT-GROUP-8-DUPLICATE-HEADING | doc hygiene | Group 8 in holdout-scenarios.md has a duplicate heading label (two scenarios share the same heading text). ADF-CODE-MARK F2 pass-16. | LOW | OPEN — doc hygiene fix candidate |

## Convergence Status

Current project index versions: BC-INDEX v6.12 / VP-INDEX v0.82 / STORY-INDEX v1.02 / ARCH-INDEX v0.16

Trajectory (ADF-CODE-MARK-EXCLUSIVITY F2): →3→4→5→5→0→1→0→4→1→0→3→1→1→0→2→3 (passes 1-16; STREAK 0/3 STRICT, DEC-158)

ADF-CODE-MARK-EXCLUSIVITY: F2 IN PROGRESS — 16 passes / 13 fix rounds complete, STREAK 0/3 (STRICT DEC-158). Pass 17 (verification-adequacy final) dispatched. Core contract finding-free since pass 12; residual tier = instruction-layer polish. Convergence criterion: STRICT (DEC-158; any delta-attributable LOW resets; VA-informational exempt per DEC-153). Prior cycle (CITATION-GUARDS): Story B F4 CONVERGED (4 passes/2 fix rounds); Story B F3 CONVERGED (DEC-153 standard, DEC-155 — 15 passes/9 fix rounds). Full trajectories: `cycles/cycle-001/convergence-trajectory.md`.

## Concurrent Cycles

| Cycle | Status | Notes |
|-------|--------|-------|
| ADF-CODE-MARK-EXCLUSIVITY (issue #571) | ACTIVE — F2 IN PROGRESS | 16 passes/13 fix rounds; STREAK 0/3 STRICT (DEC-158); trajectory-tail →1→0→2→3; Pass 17 dispatched |

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-07-07 (ADF-CODE-MARK-EXCLUSIVITY F2 checkpoint #2 — 16 adv passes / 13 fix rounds; STREAK 0/3 STRICT DEC-158; pass 17 dispatched) trajectory-tail →1→0→2→3 |
| **Status** | **F2 IN PROGRESS — STREAK 0/3 STRICT (DEC-158).** prd-delta-571.md + verification-delta-571.md authored (spec v1.3.25). BC 612. 16 adv passes / 13 fix rounds. Pass 17 (verification-adequacy final) dispatched. Core contract finding-free since p12; residual = instruction-layer polish. |
| **Counters** | BC **612**. NFR **42**. ADR **16**. Stories **102** (both #101 + #102 delivered). Holdouts **83**. |
| **Convergence counter** | ADF-CODE-MARK-EXCLUSIVITY F2: STREAK 0/3 STRICT (DEC-158). trajectory-tail →1→0→2→3. Pass 17 in flight. Clean passes: 5/7/10/14. STRICT criterion: any delta-attributable LOW resets. Full trajectories: `cycles/cycle-001/convergence-trajectory.md`. |
| **In-flight work** | Pass 17 adversarial review (verification-adequacy final lens) dispatched. develop @ 0d8a8a5 UNCHANGED. factory-artifacts: this burst commit. No open PRs. No active feature worktrees. |
| **Pending decisions** | None — DEC-158 ratified. Pass 17 result pending; if CLEAN → streak 1/3 STRICT; if findings → fix round 14 + pass 18. |
| **develop branch** | 0d8a8a5 (PR #592 squash-merged 2026-07-07; CITATION-GUARDS CYCLE CLOSED DEC-156). ADF-CODE-MARK-EXCLUSIVITY not yet in develop (F3 story not yet written). |
| **Untracked local files** | Deliberately uncommitted, session-local tooling, harmless: `.claude/pr-reviews/`, `.claude/spec-config.json`. |
| **STATE.md size** | ~273 lines (OK band). |
| **Resume command** | Open a fresh session; read `.factory/STATE.md`; run `/vsdd-factory:next-step`. ADF-CODE-MARK F2 in progress — pass 17 dispatched; await result. MUTANTS-FIRST-SCOPED-PR-CALIBRATION: src/adf.rs in scope for F4 = first code-mutant path candidate. |

## RESUME PLAN (cold-start, self-contained)

<!-- State snapshot: ADF-CODE-MARK-EXCLUSIVITY F2 IN PROGRESS (2026-07-07); STREAK 0/3 STRICT (DEC-158). Pass 17 dispatched. develop @ 0d8a8a5. BC 612; Stories 102 both delivered. Holdouts 83. -->

### Steps (assume ZERO memory)

**Step 1 (BLOCKING):** Run `vsdd-factory:factory-worktree-health`. Then read `.factory/STATE.md` (this file).

**Step 2 — Verify position:**
- develop @ **0d8a8a5** (PR #592 squash-merged 2026-07-07; CITATION-GUARDS CYCLE FULLY CLOSED). Tag v0.6.0-dev.7 @ 342987f.
- factory-artifacts: see `git -C .factory log -1`.
- No active feature worktrees.
- **Open PRs: NONE.**
- Counters: BC **612**, NFR **42**, ADR **16**, Stories **102**. Holdouts **83**.

**Step 3 — ADF-CODE-MARK-EXCLUSIVITY F2 IN PROGRESS:**

> **CYCLE: ADF-CODE-MARK-EXCLUSIVITY** (issue #571 — `markdown_to_adf` emits `strong+code` ADF → Jira HTTP 400).
>
> **F2 STATUS: 16 passes / 13 fix rounds complete. STREAK 0/3 STRICT (DEC-158). Pass 17 (verification-adequacy final) dispatched.**
>
> **F2 CARRY-FORWARD FOR F3 STORY:**
> 1. CLAUDE.md gotcha update (`^`x`^` behavior) MUST be in story file list (F4 applies it).
> 2. Red Gate must empirically confirm pre-fix [subsup, code] emission for `^`x`^`; if vacuous, expand Call B scope or demote EC-4.

**Step 4 — STANDING CONSTRAINTS (ALL fixes via full VSDD Feature Mode):**
- All fixes through full VSDD Feature Mode. No exceptions without explicit human direction.
- DEC-128 (CRITICAL): delivery sub-agents must NOT self-authorize merges, spawn fix sub-agents, push commits, or enter unbounded poll loops.
- DEC-133 (DEPENDABOT-ACTION-SOAK): third-party GitHub Action bumps require ≥7-day soak + SHA-pin integrity check.
- F2-PIECEWISE-PROTOCOL: dispatch consistency-validator after EACH spec-author fix in F2.
- **Codified lessons (cycles/cycle-001/lessons.md):** UMBRELLA-BC-RE-ANCHOR-SWEEP, IMPLEMENTER-PARAPHRASE-BEYOND-SPEC, FILES-MODIFIED-BACK-WRITE, ORCHESTRATOR-EMPIRICAL-REFUTATION, REGISTRATION-SURFACE-SWEEP.

OPEN BACKLOG (after ADF-CODE-MARK-EXCLUSIVITY closes):

*MEDIUM:* S-PG-MERGE-AUTH-BYPASS (story 91, 3 engine-prompt residuals); TEST-ONLY-GATE-ELIGIBILITY; BC-7.3.010-FORBIDDEN-PATTERN-CI-GUARD; MUTANTS-SHARDING-PATH-B.

*LOW:* MUTANTS-POLICY-CITATION-GUARD; MUTANTS-GLOB-EXISTENCE-GUARD; RA-001; RA-002; PERF-BASELINE; RELEASE-CI-NETWORK-FLAKE; FORK-OPS cluster; CACHE-COVERAGE-GAPS D5.

- DO NOT close **#429** (DEC-029, human-deferred).

## Open Issues Tracker

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #429 | jr_isolated() crypto-random suffix | OPEN | LOW | DEC-029 deferred to human. Do NOT close autonomously. |
| #400 | Test-hardening + process-gap follow-ups | OPEN — Story A MERGED PR #431. Story B + engine items remain. | LOW | |
| #372 | cargo-mutants partial baseline | OPEN | LOW | Follow-up from #346 |
| #387/#368 | git history rewrite / open PR | OPEN | LOW | Force-push needed. Deferred. |
| #209 | (backlog) | OPEN | — | |

## Historical Content

| Content | Location |
|---------|----------|
| Burst history + archived decisions DEC-001..119 + archived phase rows + closed issues + F4 burst | `cycles/cycle-001/burst-log.md` |
| Convergence trajectory (full per-pass) | `cycles/cycle-001/convergence-trajectory.md` |
| Session checkpoints (archived) | `cycles/cycle-001/session-checkpoints.md` |
| Lessons learned | `cycles/cycle-001/lessons.md` |
| Resolved blockers + resolved drift items | `cycles/cycle-001/blocking-issues-resolved.md` |
| Closed issues (CLOSED/MERGED/DELIVERED) | `cycles/cycle-001/closed-issues-archive.md` |
| Phase 2→3 gate document | `cycles/cycle-001/gates/phase-2-to-3-gate.md` |
| Maintenance sweep 2026-06-22 session review | `maintenance/2026-06-22/sweep-report-2026-06-22.md` |
| Maintenance sweep 2026-06-25 report + findings | `maintenance/2026-06-25/` |
| Refactor analysis 2026-06-25 | `architecture/refactor-2026-06-25/` |
| E2E edge-case coverage audit 2026-06-27 | `research/e2e-edge-case-audit-2026-06-27-*.md` |
| HOLDOUT-COVERAGE-GAPS + BC-SUB-CLAUSE F1 delta analysis | `phase-f1-delta-analysis/holdout-coverage-gaps-2026-06-30-delta.md`, `bc-subclause-blocked-targets-2026-06-30-delta.md` |
| MUTANTS-EXAMINE-GLOBS F1 delta analysis 2026-07-02 | `phase-f1-delta-analysis/mutants-examine-globs-2026-07-02-delta.md` |
| CITATION-GUARDS F1 delta analysis 2026-07-02 | `phase-f1-delta-analysis/citation-guards-2026-07-02-delta.md` |
| CITATION-GUARDS Story B design open-questions research 2026-07-05 | `research/story-b-open-questions-2026-07-05.md` |
| CITATION-GUARDS session review (DEC-156 cycle close, 2026-07-07) | `cycles/cycle-001/CITATION-GUARDS-session-review.md` |
| ADF-CODE-MARK-EXCLUSIVITY research (issue #571, 2026-07-07) | `research/issue-571-adf-code-mark-exclusivity-2026-07-07.md` |
| ADF-CODE-MARK-EXCLUSIVITY F1 delta analysis (issue #571, 2026-07-07) | `phase-f1-delta-analysis/impact-boundary-571.md`, `artifact-mapping-571.md`, `adf-code-mark-2026-07-07-delta.md`, `affected-files-571.txt` |
| ADF-CODE-MARK-EXCLUSIVITY F2 spec delta (issue #571, 2026-07-07) | `phase-f2-spec-evolution/prd-delta-571.md`, `phase-f2-spec-evolution/verification-delta-571.md` |
