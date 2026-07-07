---
document_type: pipeline-state
level: ops
version: "2.0"
status: active
producer: state-manager
timestamp: 2026-07-07T19:03:00Z
phase: 3
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "ADF-CODE-MARK-EXCLUSIVITY (issue #571): F1 HELD. BC-INDEX v6.11, VP-INDEX v0.82, STORY-INDEX v1.02, ARCH-INDEX v0.16. D-1..D-27893 (exhaustive). trajectory-tail →0→0→0→0."
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
  Hard cap (500 lines) margin from soft-target = 500 - 272 = 228; margin from actual = 500 - 272 = 228 (D-446(c) dual-margin form). 272 lines (wc-l).
  Hard cap: 500 lines.
-->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop → main |
| **Last Updated** | 2026-07-07: ADF-CODE-MARK-EXCLUSIVITY cycle opened (issue #571); F1 delta analysis COMPLETE; HELD at F1 human gate (5 scope questions). trajectory-tail →0→0→0→0. Prior: CITATION-GUARDS CYCLE FULLY CLOSED (DEC-156); session review complete; PR #592 @ 0d8a8a5; BC 611; Stories 102. |
| **Current Phase** | Phase 3 — **ADF-CODE-MARK-EXCLUSIVITY F1 COMPLETE / HELD AT HUMAN GATE** (issue #571). Mechanism: emit-site filter in `src/adf.rs::push_code`. BC delta: BC-7.2.007 EC-2 MODIFY + BC-7.2.015 ADD + H-NEW-ADF-010. HELD — 5 scope questions pending before F2 dispatch. BC **611**. NFR 42. ADR 16. Stories **102**. Holdouts **82**. |
| **Next Phase** | **HELD at F1 human gate — answer 5 scope questions before F2 dispatch:** (1) node-splitting exclusion; (2) `apply_marks` read-tolerance ratification; (3) standalone BC-7.2.015; (4) STANDARD convergence criterion; (5) H-NEW-ADF-010 timing (F2 or F3). |
| **Activation HEAD** | 342987f (v0.6.0-dev.7 tag); develop @ 0d8a8a5 (PR #592 squash-merged 2026-07-07 by human; CITATION-GUARDS CYCLE CLOSED DEC-156) |

## Phase Progress

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
<!-- archived: Phase 0–2 + Feature cycles 2026-05-04..2026-07-06 (STORY-A PR #572 @ ab78a2d + STORY-B F3 CONVERGED archived 2026-07-07; MUTANTS-EXAMINE-GLOBS PR #570 DEC-150 archived 2026-07-07; prior cycles archived earlier) -->
| Phase | Status | Completed | Gate | Notes |
|-------|--------|-----------|------|-------|
| **CITATION-GUARDS STORY B F4 DELIVERED — PR #592 merged @ 0d8a8a5 (2026-07-07)** | **COMPLETE** | **2026-07-07** | **F4 per-story adversarial CONVERGED (BC-5.39.001): 4 passes / 2 fix rounds / window p2/p3/p4 NITPICK/NITPICK/CLEAN. Two-tier shape guard spec amendment: EC-CITE-060, N=309 (304 .rs+5 .snap), FLOOR=231. All 7 ACs PASS. PR #592 squash-merged by human (DEC-128 honored).** | develop @ 0d8a8a5. PR #592 MERGED. BC 611. Stories 102. |
| **CITATION-GUARDS CYCLE CLOSED — BOTH STORIES DELIVERED (DEC-156, 2026-07-07)** | **COMPLETE** | **2026-07-07** | **Story A (PR #572 @ ab78a2d) + Story B (PR #592 @ 0d8a8a5) both merged. Guard family complete: CLAUDE.md citations (BC-X.13.001..003) + mutants-policy/examine_globs (DEC-150) + BC-body Trace/Source citations (BC-X.13.004..006). 309 citations enforced in CI. DEC-156.** | develop @ 0d8a8a5. BC 611. Stories 102 (both delivered). Holdouts 82. |
| **ADF-CODE-MARK-EXCLUSIVITY CYCLE OPENED — F1 COMPLETE, HELD (2026-07-07)** | **IN_PROGRESS** | **2026-07-07** | **Cycle opened for issue #571. Root cause `src/adf.rs::push_code`. Fix: emit-site allowlist filter. BC delta: BC-7.2.007 EC-2 MODIFY + BC-7.2.015 ADD + H-NEW-ADF-010. Convergence: STANDARD (DEC-153). HELD at F1 human gate — 5 scope questions. trajectory-tail →0→0→0→0.** | feature_mode_bundle: ADF-CODE-MARK-EXCLUSIVITY. develop @ 0d8a8a5 UNCHANGED. BC 611. Stories 102. |
| **pass-1 adversary (ADF-CODE-MARK-EXCLUSIVITY) — PENDING** | **PENDING** | — | Not yet dispatched. F1 human gate not cleared; 5 scope questions pending before F2 dispatch. trajectory-tail →0→0→0→0. | Dispatch: after F1 gate cleared + F2 spec-author complete. Finding count: TBD. |
| **fix burst 1 (ADF-CODE-MARK-EXCLUSIVITY) — PENDING** | **PENDING** | — | Not yet started. Awaiting pass-1 adversary findings and triage. | Will start after pass-1 dispatched and findings classified. |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
<!-- archived: CITATION-GUARDS STORY B DRAFT AUTHORED + CITATION-GUARDS STORY B F2 COMPLETE (archived 2026-07-07 burst) + prior steps -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| **CITATION-GUARDS STORY B F3 CONVERGED — story #102 v1.10 ready (2026-07-06)** — DEC-155 recorded. 15 fresh-context adversary passes (incl. 2 research adjudications: DEC-154 grammar extension), 9 fix rounds (v1.1→v1.9). Clean window: passes 13/14/15 CLEAN×3 (DEC-153 standard criterion). Story v1.10: status=ready. Finding classes: 2 CRIT, 3 HIGH, ~12 MED. Convergence trajectory appended to cycles/cycle-001/convergence-trajectory.md. | state-manager | COMPLETE | Stories #102 v1.10 ready. develop @ ab78a2d UNCHANGED. |
| **CITATION-GUARDS STORY B F4 DELIVERY COMPLETE — PR #592 OPEN/HELD (DEC-128)** — Task 0: 12+ dead citations rewritten (2b09313); Red Gate PASSED (stubs 0867823 + fixtures/self-assertions a440814; RED verified). Impl f3fc670. Two-tier shape guard spec amendment: F-01 MED resolved (EC-CITE-060; N=309=304 .rs+5 .snap; FLOOR=231; story v1.11 fd8e378; code 7706cc1). Pass-2 obs (NITPICK_ONLY): story v1.12 f353ab3. Step 4.5 CONVERGED: 4 passes / 2 fix rounds / window p2/p3/p4 NITPICK/NITPICK/CLEAN. All 7 ACs PASS. Demos b52be90 (21 files, 7/7 ACs, VHS). PR #592: CI 15/15, security 2 LOW, pr-reviewer APPROVE cycle 1. HELD per DEC-128. | state-manager | COMPLETE | PR #592 OPEN. develop UNCHANGED @ ab78a2d. |
| **CITATION-GUARDS CYCLE CLOSED (DEC-156, 2026-07-07)** — PR #592 squash-merged by human (DEC-128 honored); develop ab78a2d → 0d8a8a5. Story #102 S-BC-CITATION-GUARD-1 v1.13 status=delivered. Post-merge guard verification PASS (self-test 10/10; canonical 309 checked). DEC-156 recorded (guard family complete: BC-X.13.001..006; both stories delivered; 12+ hygiene citations fixed). 2 new lessons codified (ORCHESTRATOR-EMPIRICAL-REFUTATION, REGISTRATION-SURFACE-SWEEP). BC-CITATION-CI-GUARD drift CLOSED. BC-INDEX-9TH-SURFACE + COMPANION-LINT drift items added. S-7.02 dispositions recorded in DEC-156. Session review dispatched. | state-manager | COMPLETE | develop @ 0d8a8a5. BC 611. Stories 102 (both delivered). Holdouts 82. |
| **ADF-CODE-MARK-EXCLUSIVITY CYCLE OPENED (2026-07-07)** — Cycle opened for issue #571 (markdown_to_adf emits strong+code ADF → Jira HTTP 400; deferred follow-up from BC-7.2.007 EC-2). Research confirmed: mechanism `src/adf.rs::push_code` clones active_marks + appends code mark; post-finish-pass alternative rejected (S-522 CR/LF concern refuted). F1 artifacts: impact-boundary-571.md (architect) + artifact-mapping-571.md (BA) + adf-code-mark-2026-07-07-delta.md (assembled delta) + affected-files-571.txt. Research: research/issue-571-adf-code-mark-exclusivity-2026-07-07.md. | architect + BA + state-manager | COMPLETE | F1 artifacts committed. develop @ 0d8a8a5 UNCHANGED. |
| **ADF-CODE-MARK-EXCLUSIVITY F1 DELTA ANALYSIS COMPLETE — HELD AT F1 HUMAN GATE (2026-07-07)** — Mechanism reconciled: emit-site allowlist filter in push_code (retain link/annotation; strip strong/em/strike/subsup). Reverse path (apply_marks/adf_to_text) retained as read-tolerance. BC delta: BC-7.2.007 EC-2 MODIFY + BC-7.2.015 ADD + H-NEW-ADF-010 holdout candidate. Single file changed in F4: src/adf.rs. Convergence: STANDARD (DEC-153 precedent). HELD — 5 scope questions presented to human: (1) node-splitting exclusion confirmed? (2) apply_marks reverse-path retention ratified? (3) standalone BC-7.2.015 approved? (4) STANDARD convergence criterion ratified? (5) holdout H-NEW-ADF-010 authored in F2 or F3? | state-manager | HELD | Awaiting human answers before F2 dispatch. develop @ 0d8a8a5 UNCHANGED. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-001..DEC-124 | Phase 0/1/2/3 + Wave + Feature Mode + #492 + #522 + S-TESTTOOL-1 + S-FORK-OPS-SIGN-1 + S-FORK-OPS-BACKFILL decisions. Pattern: full VSDD catches CRIT/HIGH on "trivial" infra changes (DEC-120/121/124). All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 0→3 / 2026-05-04..2026-06-19 | archived |
| DEC-125..DEC-145 | Phase 3 Feature Mode cycles: DEAD-CITATION-CI (DEC-125..130), maintenance sweep 2026-06-22 (DEC-131), SEC-001/Bundle-D (DEC-132), DEPENDABOT-ACTION-SOAK policy (DEC-133), D4 holdout refresh (DEC-134), cache-coverage audit (DEC-135), PRs #560/#561 retroactive rigor (DEC-136), E2E edge-case audit (DEC-137), BC-sub-clause pass (DEC-138), E2E offline-CLI tier (DEC-139), E2E wiremock tier (DEC-140), E2E G-ADF-FOOTNOTE holdout tier (DEC-141), cache P3+D2 PR #565 (DEC-142), cmdb/objtype warm-hit PR #566 (DEC-143), MUTATION-CI-TIMEOUT PR #567 (DEC-144), S-PG-MERGE-AUTH-BYPASS re-assessment (DEC-145). All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 3 / 2026-06-20..2026-06-28 | archived |
| DEC-156 | **CITATION-GUARDS CYCLE CLOSED — Story A (PR #572 @ ab78a2d) + Story B (PR #592 @ 0d8a8a5) both DELIVERED. Guard family complete: CLAUDE.md citations (BC-X.13.001..003) + mutants-policy/examine_globs (Guards 2+3, DEC-150) + BC-body Trace/Source citations (Guard 1, BC-X.13.004..006). Story B totals: F3 15 passes/9 rounds (DEC-155) + F4 4 passes/2 rounds; DEC-153 standard criterion validated. Task 0 hygiene fixed 12+ real dead citations; guard now enforces 309 citations in CI. BC-CITATION-CI-GUARD drift CLOSED.** | CITATION-GUARDS bundle complete — both stories delivered, guard family enforced in CI. | Feature Mode / CITATION-GUARDS | 2026-07-07 |

## Skip Log

All S-WIN-1..6 + #475 + S-FORK-OPS-BACKFILL-1 + S-FORK-OPS-GITLEAKS-DOC-1 + S-MAINT-DEAD-CITATION-CI per-AC demos: **Yes — adapted**. CI-config / infra / docs / test-only / platform-cfg stories. Guard's own green CI run (58 tests passing in ci-gate) is per-AC demo evidence. See `cycles/cycle-001/burst-log.md`.

## Blocking Issues

None open.

## Drift Items

<!-- OPEN/TRACKED items only. Resolved → cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Area | Description | Severity | Status |
|----|------|-------------|----------|--------|
| FORK-OPS-537-NITS | PR #537 optional nits | PR #537 carries 2 optional LOW nits: (a) tighten TeamIdentifier regex; (b) soften Bug-2 'signed-DMG performance fast-path' rationale. Inert in this repo (SIGNING_ENABLED unset). | LOW | OPEN |
| FORK-OPS-PHANTOM-RUNS | Phantom workflow runs | ~7 phantom runs/day from new triggers. Cosmetic; decide suppress or accept. | LOW | OPEN |
| WIN-CFG-TESTS-CHECK | Cross-compile | cargo check --lib excludes #[cfg(test)]; use --tests. | LOW | OPEN |
| WIN-DENY-FRAGILITY | deny.toml | Canonical-un-skipped-version has no CI guard. | LOW | OPEN |
| WIN-AUTH-ENVLOCK-POISON | ENV_LOCK poison | .lock().unwrap() in auth tests; use unwrap_or_else. | LOW | OPEN |
| E2E-PG-4 | E2E coverage gap | remote-link round-back (no jr remote-link read). | LOW | OPEN |
| PG-A / DRIFT-README | Count guards | check-bc-cumulative-counts.sh does not cover README.md; guard gap OPEN. README Document Map staleness RESOLVED by factory commit e72bcb9. | LOW | OPEN (guard gap only; README content resolved) |
| WIN-PG-1 | No BC-count CI guard | 3rd recurrence of JR_* test-seam doc-fallout without CI parity check. | LOW | OPEN |
| WIN-PG-2 | Story template | Presence-only-test disclosure field missing from story template. | LOW | OPEN |
| WIN-RUNTIME-OAUTH-PROBE | Windows OAuth probe | Release OAuth verification is constants-file check only; no runtime jr auth status. | LOW | OPEN — accepted per ADR-0016 |
| WIN-AC004-DIRECTIONAL | XDG→JR seam-migration | Enforcement test has directional blind spot. | LOW | OPEN |
| F7-001..F7-003 | Minor precision gaps | CLAUDE.md symmetric label; F2-record archival note; BC-7.2.011 "13 tests". | LOW | ACCEPTED-DEFERRED |
| #492-TEST-HARNESS-COUPLING | process-gap | Handler-level block-HTML tests couple to push_text shape. | LOW | TRACKED DEFERRAL |
| #492-PG-TRACE-TESTS | process-gap | No CI check that BC Source/Trace-cited test symbols resolve to real #[test] fns. Reinforced 2026-06-22 — 2 phantom citations in promoted ADRs caught only by fresh-eyes pr-reviewer. | LOW | TRACKED DEFERRAL |
| LESSON-F2-WORKTREE-FIRST | process-gap C-1 | ALL story-scoped edits in worktree, even docs/. Codified in lessons.md. | LOW | DEFERRED |
| CITATION-FORM-DISCIPLINE | process-gap | Bare file:NN citations recur vs #408 symbol-form convention; no CI guard. | LOW | DEFERRED |
| F7-COSMETIC-ATTR-ORDER | cosmetic | Story Architecture Rule 3 says #[ignore] before #[test]; code uses #[test] first. | LOW | ACCEPTED-COSMETIC |
| FORK-OPS-COMPOSITE-ACTION-SCAN | sign-and-publish.yml | Injection guard does not follow local composite actions; none exist today. | LOW | OPEN — justified deferral |
| FORK-OPS-HEADBRANCH-EMPTY-GUARD | sign-and-publish.yml | Empty head_branch → TAG=""/VERSION="" (theoretical CWE-74). Future story. | LOW | OPEN |
| FORK-OPS-ALPHA-ORPHAN-CLEANUP | sign-and-publish.yml | Orphaned alpha tags from failed runs accumulate. Future housekeeping story. | LOW | OPEN |
| FORK-OPS-BACKFILL-ZIP-GLOB-COUPLING | backfill-release.yml | `gh release upload jr-*.zip` fails loud on zero-match glob (accepted; guarded by needs:build + matrix-parity test). | LOW | OPEN — accepted |
| FORK-OPS-F5-SELFTEST-CHECKLIST | process-gap | F5 checklist conflates `--self-test` inline fixture with real-file scan; wording could mislead. | LOW | OPEN |
| MAINT-PG-CI-DOC-LINT | process-gap | CLAUDE.md src-file-tree drift recurring; add scripts/check-claude-md-tree.sh to CI. | LOW | DEFERRED |
| PERF-BASELINE-ABSENT | coverage-gap | Sweep 5 (perf) skipped 4× — baseline re-confirmed 2026-06-25: binary 7.09MB, `jr --help` p50 6.4ms. No regression. | LOW | OPEN (baseline confirmed; CI guard pending) |
| PERF-COST-TRACKING | instrumentation | No per-cycle token/cost tracking; `.factory/cost-summary.md` not initialized. | LOW | OPEN — draft story candidate |
| HOLDOUT-RESIDUAL-EDIT-FIELD-002-STDERR | accepted-residual | H-NEW-EDIT-FIELD-002 stderr criterion is looser than sibling scenarios (accepted per DEC-146). | LOW | ACCEPTED |
| MUTANTS-POLICY-CITATION-GUARD | process-gap | `docs/specs/cargo-mutants-policy.md §Scope` function-location table cites file paths/functions with no CI guard. Proposed: `scripts/check-cargo-mutants-policy-citations.sh`. DEC-150. | LOW | OPEN — draft-story candidate |
| MUTANTS-GLOB-EXISTENCE-GUARD | process-gap | `examine_globs` entries in `.cargo/mutants.toml` are not validated against the actual repo filesystem at CI time. DEC-150. | LOW | OPEN — draft-story candidate |
| F1-SWEEP-INCLUDES-CI-YML-COMMENTS | process-gap | F1 delta analysis missed stale scope comment at `ci.yml:195`; fresh-context F5 adversary caught it. Fix: update phase-f1 skill template. DEC-150. | LOW | OPEN — justified deferral (engine skill-template update) |
| CICD-SETUP-CLASSIFICATION | process-gap | `.factory/cicd-setup.md` governance classification is ambiguous. Human input required. DEC-150. | LOW | OPEN — justified deferral (human governance decision needed) |
| DOC-LINK-SWEEP-CANDIDATE-1 | doc hygiene | `docs/specs/jsm-e2e-coverage.md:903` cites `docs/adr/0014-jsm-request-creation.md` but actual file is `docs/adr/0014-jsm-request-type-dispatch.md`. DEC-149. | LOW | OPEN — doc-link sweep candidate |
| DOC-LINE-DRIFT-CANDIDATE-1 | doc hygiene | `docs/specs/2026-05-13-search-issue-keys.md:7` cites `src/api/jira/issues.rs:12-29` but actual span is ~13-30. DEC-149. | LOW | OPEN — line-cite drift candidate |
| PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY | process-gap | F1 citation-debt perimeter scan grepped bc-1..bc-7 but omitted BC-INDEX.md and traceability/summary tables. Codify: perimeter scan MUST include BC-INDEX.md + CANONICAL-COUNTS + traceability artifacts. | LOW | OPEN — process-gap codification pending |
| BC-CITATION-CI-GUARD | process-gap | No CI guard validates file::symbol citations in `.factory/specs/prd/*.md` BC bodies. | LOW | CLOSED — Guard 1 delivered (PR #592 @ 0d8a8a5, DEC-156; check-bc-citation-symbols.sh + spec-guard CI step; 309 citations enforced). |
| BC-INDEX-9TH-SURFACE | process-gap | BC-INDEX.md contains coverage statistics not yet covered by `check-bc-cumulative-counts.sh` as a 9th validation surface. S-7.02 cycle-close disposition. | LOW | OPEN — guard-extension candidate |
| COMPANION-LINT-CHECK-BC-SINGLE-LINE-TRACE | process-gap | Guard 1 validates file::symbol citations but does NOT enforce single-line Trace/Source fields. Companion lint follow-up. S-7.02 new drift item. | LOW | OPEN — follow-up story candidate |
| BC-X5008-STALE-LINE-CITE | BC metadata | BC-X.5.008 Source field cites `src/duration.rs:38-42` (stale) vs actual shipped lines ~74-80 (DEC-146 observation). | LOW | OPEN — LOW BC-metadata fix candidate |
| PF-008-ASSET-ID-RESULT-HARDENING | code hygiene | Result-propagation hardening of asset.id panic→JrError on CMDB contract violation at `src/api/assets/linked.rs` + `src/cli/issue/list.rs`. | LOW | OPEN — tracked deferral |
| RA-001-JRACLOUD-27893-DOC | risk | JRACLOUD-27893 (user pagination fixed-window behavior) is load-bearing in src/api/jira/users.rs but not cited in CLAUDE.md Gotchas. | LOW | OPEN |
| RA-002-ADR-0013-PKCE-REVALIDATE | risk | ADR-0013 PKCE deferral assumption is ~50 days old as of 2026-06-25. Re-validate before any OAuth work in next feature cycle. | LOW | OPEN |
| F1-CI-TOPOLOGY-CHECK | phase-f1 process | F1 delta analysis lacks CI-checkout-topology verification step. Action: update phase-f1 skill template. | LOW | OPEN — skill template update (no new story) |
| PG-MERGE-AUTH-BYPASS | pr-manager delivery | pr-manager delivery sub-agent executed `gh pr merge` on PR #544 despite explicit orchestrator hold. DEC-128. Audit 2026-06-28: Constraint 4 CODIFIED; Constraints 1–3 PARTIALLY-MITIGATED. | LOW | MITIGATED-WITH-RESIDUAL-GAPS (audit 2026-06-28) — S-PG-MERGE-AUTH-BYPASS (story 91; scope extended 2026-06-25). DEC-145. |
| MUTANTS-ARBITER-OFFLINE-SELFTEST | process-gap | The kill-rate arbiter bash has no offline fixture self-test. | LOW | OPEN — justified deferral (candidate follow-up story) |
| MUTANTS-PARTIAL-SCHEMA-RESIDUAL | accepted-residual | Partial `outcomes.json` summary-key rename evades the all-zero schema-drift guard; mitigated by @27 pin. | LOW | ACCEPTED |
| MUTANTS-SHARDING-PATH-B | enhancement | Path B (shard across CI matrix + `--baseline=skip` + explicit `--timeout`, faster build profile) deferred when human chose Path A. | LOW | OPEN — deferred (human chose Path A) |
| MUTANTS-FIRST-SCOPED-PR-CALIBRATION | watch-item | **0-MUTANT PATH: CONFIRMED-GOOD ×4.** PR #568 + #570 + #572 + #592 all confirmed 0-mutant path. Code-mutant path still unexercised. `edit.rs`/`jsm_create.rs` are now in `examine_globs` since PR #570. | LOW | OPEN — 0-mutant path confirmed ×4; code-mutant path still unexercised (now higher-likelihood) |
| RETROACTIVE-STORY-FILES-MISSING | process-gap | Stories 98 (S-ANYHOW-RUSTSEC-2026-0190-1) + 99 (S-CITATION-DEBT-PRODUCT-FILES-1) were counted in STATE.md but no story files were ever created. | LOW | OPEN |
| PG-PR-MANAGER-OVERREACH | process-gap | During PR #553, pr-manager delivery agent autonomously spawned implementer sub-agents and pushed commits without orchestrator authorization. Covered by S-PG-MERGE-AUTH-BYPASS scope extension. | LOW | MITIGATED-WITH-RESIDUAL-GAPS (audit 2026-06-28) — covered by S-PG-MERGE-AUTH-BYPASS (story 91). DEC-145. |
| REFACTOR-ISSUE-CLI-SHARD | architecture | **Seam A DONE (PR #556):** JSM-create extracted → src/cli/issue/jsm_create.rs. **Seam B DONE (PR #558):** EDIT cluster extracted → src/cli/issue/edit.rs. **Seam C DEFERRED indefinitely.** | LOW | RESOLVED-PARTIAL — Seams A+B complete (active plan done); Seam C accepted-deferral |
| RELEASE-CI-NETWORK-FLAKE | release-infra | release.yml Windows build (v0.6.0-dev.7) hit transient crates.io download failure on first run; resolved by `gh run rerun`. | LOW | OPEN |
| TEST-ONLY-GATE-ELIGIBILITY | process-gap | Codify a documented rule for whether/when test-only PRs run the fresh-context adversarial gate vs a defined lighter tier. | MEDIUM | TRACKED DEFERRAL |
| CACHE-COVERAGE-GAPS-2026-06-27 | test-coverage | P1/P2/P3/D2 DONE. Remaining genuine gaps: (a) D5 write-error resilience at project_meta/workspace call-sites; (b) P6–P8 additional audit proposals. | LOW | OPEN — narrowed; D5 call-sites tracked deferral |
| ADVERSARY-DISPATCH-IDENTITY-TUPLE | process-gap | Orchestrator adversary/reviewer dispatches omit the formal Worktree-Identity tuple. No soundness impact on this cycle. | LOW | OPEN — justified deferral |
| BC-7.3.010-FORBIDDEN-PATTERN-CI-GUARD | process-gap | The #526 forbidden-compact-JSON invariant is review-only with no CI guard. A grep-based test parallel to the dead-citation guard is a candidate. | LOW | OPEN — draft-story candidate |
| ADF-RECURSION-TEST-NITS | code/doc hygiene | Two LOW nits from BC-sub-clause pass: (1) imprecise "wiremock 501" comment in `tests/adf_recursion_depth.rs:~81`; (2) BC-7.2.014 Motivation-prose confidence-hedge harmonization. | LOW | OPEN — accepted cosmetic |
| POLICY-DOC-NON-SCOPE-CITATIONS | process-gap | Guard 2 scoped to §Scope only. Policy-doc fn citations outside §Scope remain driftable. Deliberate residual. CITATION-GUARDS cycle. | LOW | OPEN — cycle-close disposition pending |
| POLICY-DOC-ZERO-PAIR-OPT-OUT | process-gap | Guard 2: bullet with zero backticks passes check — effectively an opt-out path. Current rows all have citations. CITATION-GUARDS cycle. | LOW | OPEN — cycle-close disposition pending |
| EXTRACTION-SET-PIN | process-gap | Guard 2 validates citation count but not the extracted (file, fn) SET. Count-preserving rename evades check. Mitigated by fresh-context F5. CITATION-GUARDS cycle. | LOW | OPEN — draft-story candidate |
| INTERNAL-PR-CITATION-RIGOR | process-gap | PR-number attributions in spec prose need verify-before-cite discipline (same class as JRACLOUD tickets). CITATION-GUARDS cycle. | LOW | OPEN — cycle-close disposition pending |
| ADVERSARY-META-LENS-REGRESS | process-gap | Verification-adequacy lens generates unbounded meta-level findings on guard-spec stories. Engine needs convergence rule: meta-level observations on spec stories are LOW informational and do not reset clean-streak counter. | LOW | OPEN — engine-level rule needed (human governance decision) |
| SCOPE-EMPTY-THREE-VS-TWO-CAUSE | story/spec | SCOPE_EMPTY message three-cause wording in delivered implementation vs story Task 2 two-cause prose — adjudicate at cycle close. | LOW | OPEN — story-side adjudication at cycle close |
| SCOPE-EXAMINE-GLOBS-CROSS-SET-EDGE | coverage-gap | Guard 2 §Scope↔examine_globs cross-set edge is unguarded (pass-8 F-P8-01). Follow-up story candidate. | LOW | OPEN — follow-up story candidate |
| BACKTICK-RESERVATION-CONVENTION | doc-hygiene | Backtick-reservation convention in §Scope bullets is undocumented. Doc-sentence candidate. | LOW | OPEN — doc-sentence candidate |
| ENGINE-BC-ID-INJECTION | process-gap | Stub-architect agent injected engine-internal BC-ID BC-5.38.001 into product source rustdoc (5 sites) during F4 Red Gate. Engine-side prompt hygiene: stub-architect must not emit engine-internal BC references into product files. | LOW | OPEN — engine prompt hygiene (justified deferral) |
| STORY-ENGINE-BC-CITATION | story/spec | Story S-MUTANTS-SCOPE-GUARDS-1 cites "Per BC-5.38.001 Red Gate discipline" — an engine-internal BC reference in a product-story body. Adjudicate at cycle close. | LOW | OPEN — cycle-close adjudication |
| SEC-001-GUARD1-ERE-PREFLIGHT | security | Guard 1 bash script has no ERE-injection preflight guard on identifier-shaped CLI args. Follow-up story candidate. | LOW | OPEN — follow-up story candidate |
| SEC-002-GUARD1-BCDIR-DASH | security | Guard 1 bash script has no leading-dash flag-value guard on `--bc-dir` arg. Follow-up story candidate. | LOW | OPEN — follow-up story candidate |
| GUARD1-BCDIR-CWD-RELATIVE | coverage-gap | Guard 1 bash script: `--bc-dir` defaults to cwd-relative while file-path resolution uses REPO_ROOT-anchored paths — asymmetry. PASS3-Obs-2. | LOW | OPEN — accepted residual / follow-up candidate |

## Convergence Status

Current project index versions: BC-INDEX v6.11 / VP-INDEX v0.82 / STORY-INDEX v1.02 / ARCH-INDEX v0.16

Trajectory: →0→0→0→0

ADF-CODE-MARK-EXCLUSIVITY: F1 HELD — no adversary passes yet. Convergence criterion: STANDARD (DEC-153 precedent; 3 consecutive clean diverse-lens passes). Prior cycle (CITATION-GUARDS): Story B F4 CONVERGED (4 passes/2 fix rounds); Story B F3 CONVERGED (DEC-153 standard, DEC-155 — 15 passes/9 fix rounds). Full trajectories: `cycles/cycle-001/convergence-trajectory.md`.

## Concurrent Cycles

| Cycle | Status | Notes |
|-------|--------|-------|
| ADF-CODE-MARK-EXCLUSIVITY (issue #571) | ACTIVE — F1 HELD at human gate | trajectory-tail →0→0→0→0; 5 scope questions pending before F2 dispatch |

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-07-07 (ADF-CODE-MARK-EXCLUSIVITY cycle opened — F1 delta analysis COMPLETE; HELD at F1 human approval gate) trajectory-tail →0→0→0→0 |
| **Status** | **F1 COMPLETE — HELD AT HUMAN GATE.** ADF-CODE-MARK-EXCLUSIVITY cycle open (issue #571). F1 artifacts produced: impact-boundary-571.md, artifact-mapping-571.md, adf-code-mark-2026-07-07-delta.md, affected-files-571.txt. Mechanism: emit-site allowlist filter in `src/adf.rs::push_code`. BC delta: BC-7.2.007 EC-2 MODIFY + BC-7.2.015 ADD + H-NEW-ADF-010 holdout candidate. Single file in F4: `src/adf.rs`. 5 scope questions presented to human before F2 dispatch. |
| **Counters** | BC **611**. NFR **42**. ADR **16**. Stories **102** (both #101 + #102 delivered). Holdouts **82**. |
| **Convergence counter** | ADF-CODE-MARK-EXCLUSIVITY: F1 complete, F2–F7 not started. STANDARD convergence criterion (DEC-153 precedent). trajectory-tail →0→0→0→0. Prior cycle trajectories: `cycles/cycle-001/convergence-trajectory.md`. |
| **In-flight work** | NONE. develop @ 0d8a8a5 UNCHANGED. factory-artifacts: this burst commit. No open PRs. No active feature worktrees. |
| **Pending decisions** | 5 F1 scope questions (human must answer before F2 dispatch): (1) node-splitting exclusion confirmed? (2) `apply_marks` reverse-path retention ratified? (3) standalone BC-7.2.015 approved? (4) STANDARD convergence criterion ratified? (5) holdout H-NEW-ADF-010 authored in F2 or F3? |
| **develop branch** | 0d8a8a5 (PR #592 squash-merged 2026-07-07 by human; CITATION-GUARDS CYCLE CLOSED DEC-156). ADF-CODE-MARK-EXCLUSIVITY not yet in develop. |
| **Untracked local files** | Deliberately uncommitted, session-local tooling, harmless: `.claude/pr-reviews/`, `.claude/spec-config.json`. |
| **STATE.md size** | ~272 lines (OK band). |
| **Resume command** | Open a fresh session; read `.factory/STATE.md`; run `/vsdd-factory:next-step`. HELD at F1 human gate — answer 5 scope questions before dispatching F2. MUTANTS-FIRST-SCOPED-PR-CALIBRATION watch: ×4 0-mutant confirmations; code-mutant path still unexercised. |

## RESUME PLAN (cold-start, self-contained)

<!-- State snapshot: ADF-CODE-MARK-EXCLUSIVITY F1 COMPLETE (2026-07-07); HELD at F1 human gate. Issue #571 fix planned. develop @ 0d8a8a5. BC 611; Stories 102 both delivered. Holdouts 82. -->

### Steps (assume ZERO memory)

**Step 1 (BLOCKING):** Run `vsdd-factory:factory-worktree-health`. Then read `.factory/STATE.md` (this file).

**Step 2 — Verify position:**
- develop @ **0d8a8a5** (PR #592 squash-merged 2026-07-07 by human; CITATION-GUARDS CYCLE FULLY CLOSED). Tag v0.6.0-dev.7 @ 342987f.
- factory-artifacts: see `git -C .factory log -1`.
- No active feature worktrees. Permanent infra: main checkout @ develop, `.factory` @ factory-artifacts, `.reference/jira-cli` detached.
- **Open PRs: NONE.**
- Counters: BC **611**, NFR **42**, ADR **16**, Stories **102** (both #101 + #102 delivered). Holdouts **82**.

**Step 3 — ADF-CODE-MARK-EXCLUSIVITY F1 HELD (current state):**

> **CYCLE: ADF-CODE-MARK-EXCLUSIVITY** (issue #571 — `markdown_to_adf` emits `strong+code` ADF → Jira HTTP 400).
>
> **HELD AT F1 HUMAN GATE — 5 scope questions pending before F2 dispatch:**
> 1. Confirm node-splitting excluded (drop-typographic-mark strategy only)?
> 2. Ratify `apply_marks` reverse-path retention (read-tolerance for legacy/external ADF)?
> 3. Approve standalone BC-7.2.015 (separate from BC-7.2.007 EC-2 amendment)?
> 4. Ratify STANDARD convergence criterion (DEC-153 precedent; 3 consecutive clean diverse-lens passes)?
> 5. Holdout H-NEW-ADF-010 to be authored in F2 or F3?
>
> **F1 ARTIFACTS** (all committed to factory-artifacts):
> - `phase-f1-delta-analysis/impact-boundary-571.md` — architect impact boundary analysis
> - `phase-f1-delta-analysis/artifact-mapping-571.md` — BA artifact mapping + BC delta
> - `phase-f1-delta-analysis/adf-code-mark-2026-07-07-delta.md` — assembled delta
> - `phase-f1-delta-analysis/affected-files-571.txt` — single file: `src/adf.rs`
> - `research/issue-571-adf-code-mark-exclusivity-2026-07-07.md` — research basis

**Step 4 — STANDING CONSTRAINTS (ALL fixes via full VSDD Feature Mode):**
- All fixes through full VSDD Feature Mode. No exceptions without explicit human direction.
- DEC-128 (CRITICAL): delivery sub-agents must NOT self-authorize merges, spawn fix sub-agents, push commits, or enter unbounded poll loops.
- DEC-133 (DEPENDABOT-ACTION-SOAK): third-party GitHub Action bumps require ≥7-day soak + SHA-pin integrity check.
- DEC-136/TEST-ONLY-GATE-ELIGIBILITY: test-only PRs must NOT silently skip the adversarial gate.
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
| Session checkpoints (archived, incl. PIPELINE IDLE 2026-07-07 checkpoint) | `cycles/cycle-001/session-checkpoints.md` |
| Lessons learned | `cycles/cycle-001/lessons.md` |
| Resolved blockers + resolved drift items | `cycles/cycle-001/blocking-issues-resolved.md` |
| Closed issues (CLOSED/MERGED/DELIVERED) | `cycles/cycle-001/closed-issues-archive.md` |
| Phase 2→3 gate document | `cycles/cycle-001/gates/phase-2-to-3-gate.md` |
| Maintenance sweep 2026-06-22 session review | `maintenance/2026-06-22/sweep-report-2026-06-22.md` |
| Maintenance sweep 2026-06-25 report + findings | `maintenance/2026-06-25/` |
| Refactor analysis 2026-06-25 (structural + proposal) | `architecture/refactor-2026-06-25/` |
| E2E edge-case coverage audit 2026-06-27 | `research/e2e-edge-case-audit-2026-06-27-*.md` |
| HOLDOUT-COVERAGE-GAPS + BC-SUB-CLAUSE F1 delta analysis | `phase-f1-delta-analysis/holdout-coverage-gaps-2026-06-30-delta.md`, `bc-subclause-blocked-targets-2026-06-30-delta.md` |
| MUTANTS-EXAMINE-GLOBS F1 delta analysis 2026-07-02 | `phase-f1-delta-analysis/mutants-examine-globs-2026-07-02-delta.md` |
| CITATION-GUARDS F1 delta analysis 2026-07-02 | `phase-f1-delta-analysis/citation-guards-2026-07-02-delta.md` |
| CITATION-GUARDS Story B design open-questions research 2026-07-05 | `research/story-b-open-questions-2026-07-05.md` |
| CITATION-GUARDS session review (DEC-156 cycle close, 2026-07-07) | `cycles/cycle-001/CITATION-GUARDS-session-review.md` |
| ADF-CODE-MARK-EXCLUSIVITY research (issue #571, 2026-07-07) | `research/issue-571-adf-code-mark-exclusivity-2026-07-07.md` |
| ADF-CODE-MARK-EXCLUSIVITY F1 delta analysis (issue #571, 2026-07-07) | `phase-f1-delta-analysis/impact-boundary-571.md`, `artifact-mapping-571.md`, `adf-code-mark-2026-07-07-delta.md`, `affected-files-571.txt` |
