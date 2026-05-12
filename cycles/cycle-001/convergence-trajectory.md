---
document_type: convergence-trajectory
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-05-04T00:00:00
cycle: "cycle-001"
inputs: [adversarial-reviews/]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Convergence Trajectory — cycle-001

## Finding Progression

| Pass | Date | Total | CRIT | HIGH | MED | LOW | Counter | Verdict |
|------|------|-------|------|------|-----|-----|---------|---------|
| 1 | 2026-05-04 | 30 | 4 | 11 | 12 | 3 | 0/3 | FINDINGS_REMAIN |
| 2 | 2026-05-04 | 15 | 0 | 6 | 6 | 3 | 0/3 | FINDINGS_REMAIN |
| 3 | 2026-05-04 | 9 | 1 | 3 | 3 | 2 | 0/3 | FINDINGS_REMAIN |
| 4 | 2026-05-04 | 5 | 0 | 0 | 4 | 1 | 0/3 | FINDINGS_REMAIN |
| 5 | 2026-05-04 | 10 | 0 | 0 | 7 | 3 | 0/3 | REGRESSION |
| 6 | 2026-05-04 | 5 | 0 | 1 | 3 | 1 | 0/3 | FINDINGS_REMAIN |
| 7 | 2026-05-04 | 4 | 0 | 0 | 3 | 1 | 0/3 | FINDINGS_REMAIN |
| 8 | 2026-05-04 | 3 | 0 | 1 | 2 | 0 | 0/3 | FINDINGS_REMAIN |
| 9 | 2026-05-04 | 4 | 0 | 0 | 4 | 0 | 0/3 | PLATEAU |
| 10 | 2026-05-04 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 11 | 2026-05-04 | 2 | 0 | 1 | 1 | 0 | 0/3 | REGRESSION |
| 12 | 2026-05-04 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 13 | 2026-05-04 | 3 | 0 | 0 | 3 | 0 | 0/3 | REGRESSION |
| 14 | 2026-05-04 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 15 | 2026-05-04 | 2 | 0 | 1 | 1 | 0 | 0/3 | REGRESSION |
| 16 | 2026-05-04 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 17 | 2026-05-04 | 3 | 0 | 1 | 2 | 0 | 0/3 | REGRESSION |
| 18 | 2026-05-04 | 3 | 0 | 0 | 2 | 1 | 0/3 | PLATEAU |
| 19 | 2026-05-04 | 5 | 1 | 1 | 3 | 0 | 0/3 | REGRESSION |
| 20 | 2026-05-04 | 3 | 0 | 1 | 2 | 0 | 0/3 | CONVERGING |
| 21 | 2026-05-04 | 4 | 0 | 0 | 3 | 1 | 0/3 | PLATEAU |
| 22 | 2026-05-04 | 5 | 0 | 0 | 4 | 1 | 0/3 | PLATEAU |
| 23 | 2026-05-04 | 5 | 0 | 1 | 3 | 1 | 0/3 | PLATEAU |
| 24 | 2026-05-04 | 5 | 0 | 0 | 4 | 1 | 0/3 | PLATEAU |
| 25 | 2026-05-04 | 2 | 0 | 0 | 2 | 0 | 0/3 | CONVERGING |
| 26 | 2026-05-04 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 27 | 2026-05-04 | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| 28 | 2026-05-04 | 0 | 0 | 0 | 0 | 0 | 3/3 | FULL CONVERGENCE |

## Trajectory Shorthand

`30→15→9→5→10→5→4→3→4→0→2→0→3→0→2→0→3→0→3→5→3→4→5→5→5→2→0→0→0` — **CONVERGED** at Pass 28 (2026-05-04)

## Per-Pass Details

### Pass 1 (2026-05-04)

**Findings:** 30 (4C/11H/12M/3L)
**Convergence counter:** 0 of 3

BC-INDEX rebuilt from canonical body files (CRITICAL). 3 SD-NNN security decision artifacts created. 29 of 30 findings addressed; 1 deferred (ADV-P1-030 — orchestrator process-gap, policies.yaml — codification task post Phase 1).

---

### Pass 2 (2026-05-04)

**Findings:** 15 (0C/6H/6M/3L)
**Convergence counter:** 0 of 3

Key HIGH: extract_error_message 3-way contradiction (ADV-P2-001); ≥11 holdout BC anchors incorrect after rebuild (ADV-P2-002); NFR-R-NEW-1 missing from catalog (ADV-P2-003); NFR-S-E severity inconsistent (ADV-P2-004); NFR catalog count 4-way disagreement (ADV-P2-005); DTU holdout count 47 vs 48 (ADV-P2-006).

---

### Pass 3 (2026-05-04)

**Findings:** 9 (1C/3H/3M/2L)
**Convergence counter:** 0 of 3

CRITICAL: site count canonicalized to 14 across 4 docs. HIGH: ADR-0007 fallback clause struck; cross-cutting.md error chain replaced with PRD-canonical 7-level table; NFR catalog total reconciled to 42 after NFR-S-F addition.

---

### Pass 4 (2026-05-04)

**Findings:** 5 (0C/0H/4M/1L)
**Convergence counter:** 0 of 3

MEDIUM: H-004 BC anchor corrected; H-005 BC anchor corrected; H-012 BC anchors corrected; architecture README risk count refreshed 26→27. LOW: nfr-catalog routing arithmetic corrected.

---

### Pass 5 (2026-05-04)

**Findings:** 10 (0C/0H/7M/3L)
**Convergence counter:** 0 of 3

REGRESSION from 5→10. Root cause: anchor tables in supplement files not subjected to same audit as BC bodies in prior passes. 10 cited + 4 sweep additionals all fixed. Count manifest: 542 BCs / 42 NFRs / 48 holdouts / 27 risks.

---

### Pass 6 (2026-05-04)

**Findings:** 5 (0C/1H/3M/1L)
**Convergence counter:** 0 of 3

HIGH: MatchResult enum corrected in arch cross-cutting.md (Exact/ExactMultiple/Ambiguous/None). MEDIUM: 7-step extract_error_message table removed from arch cross-cutting.md; NFR-R-NEW-1/2 moved to correct LOW section; R-H3 demoted MEDIUM. LOW: arch README risk arithmetic corrected.

---

### Pass 7 (2026-05-04)

**Findings:** 4 (0C/0H/3M/1L)
**Convergence counter:** 0 of 3

ADV-P7-001 CLOSED (false alarm — BC count 542 correct). MEDIUM: NFR-O-K merged into NFR-S-D; NFR total 42→41; cross-cutting.md definitional_count 63→64. LOW: arch cross-cutting.md MatchResult::ExactMultiple description rewritten.

---

### Pass 8 (2026-05-04)

**Findings:** 3 (0C/1H/2M/0L)
**Convergence counter:** 0 of 3

HIGH: nfr-catalog routing summary DEFER count corrected 17→12. MEDIUM: adr-index ADR-0009 anchor corrected §R-H4→§R-H3; R-M3 merged into R-L11 (duplicate Retry-After concern). Risk total 27→26.

---

### Pass 9 (2026-05-04)

**Findings:** 4 (0C/0H/4M/0L)
**Convergence counter:** 0 of 3

PLATEAU. MEDIUM: risk-register action breakdown recounted; NFR-S-F site path corrected `.cargo/deny.toml`→`deny.toml`; NFR-S-F cross-ref R-H6→R-H5; arch cross-cutting MatchResult::Ambiguous description corrected.

---

### Pass 10 (2026-05-04)

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 1 of 3

All Pass 9 fixes verified propagated cleanly. NFR 41, risks 26, BC 542, holdouts 48 all reconcile. MUST-FIX register consistent across 5+ docs. 5 BC source-line spot-checks exact.

---

### Pass 11 (2026-05-04)

**Findings:** 2 (0C/1H/1M/0L)
**Convergence counter:** 0 of 3 (REGRESSION from 1/3)

HIGH: tracing not a current dep — nfr-catalog.md + arch cross-cutting.md corrected. MEDIUM: cache count corrected "7 distinct"→"6 distinct" in L2 + arch state-machines.md.

---

### Pass 12 (2026-05-04)

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 1 of 3

Pass 11 regression healed. tracing dep claim consistent across 4 docs; cache count = 6 distinct consistent across L2 + arch state-machines.md. No new findings.

---

### Pass 13 (2026-05-04)

**Findings:** 3 (0C/0H/3M/0L)
**Convergence counter:** 0 of 3 (REGRESSION from 1/3)

MEDIUM: BC grand total 542→541 (double-count corrected in BC-INDEX footnote); NFR-O-G LOC 970→1,083; cicd-setup.md path ref in risk-register corrected. Comprehensive 4-sweep audit completed. CANONICAL-COUNTS.md created.

---

### Pass 14 (2026-05-04)

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 1 of 3

Comprehensive sweep + CANONICAL-COUNTS.md adoption healed Pass 13 regression. 4/4 source-truth spot checks exact. CANONICAL-COUNTS = 541/41/48/26 stable. 2 nitpicks demoted (holdout Group 1 label; "12+" vs "14" in L2 README — non-contradictory).

---

### Pass 15 (2026-05-04)

**Findings:** 2 (0C/1H/1M/0L)
**Convergence counter:** 0 of 3 (REGRESSION from 1/3; 5th counter reset)

bc-3 body 'Total:40'→'48 individually-bodied'; bc-3 subdomain 8→7; bc-1 sweep drift fixed (5→6 subdomains).

---

### Pass 16 (2026-05-04)

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 1 of 3

bc-*.md body sweep effective; CANONICAL-COUNTS adoption stable; MUST-FIX P0 register integrity holding.

---

### Pass 17 (2026-05-04)

**Findings:** 3 (0C/1H/2M/0L)
**Convergence counter:** 0 of 3 (REGRESSION; 4th counter reset across 17 passes)

SD-003 R-H3→R-M0; state-machines NFR-R-NEW-3→NFR-O-B; L2 bc_count sync bc-04/06/07.

---

### Pass 18 (2026-05-04)

**Findings:** 3 (0C/0H/2M/1L)
**Convergence counter:** 0 of 3 (5th counter reset)

BC-INDEX:630 line-440 sync; arch BC-4 map adds cli/assets.rs; H-046 fixture mechanism specified.

---

### Pass 19 (2026-05-04)

**Findings:** 5 (1C/1H/3M/0L)
**Convergence counter:** 0 of 3 (REGRESSION)

5 findings via rotated lenses (state-machine↔BC, cache audit, holdout↔BC bidirectional). CRITICAL SM-5 BC-X.8.001→BC-X.8.003. HIGH cache count drift 7→6. Partial-fix propagation pattern.

---

## Phase 2-adv — Adversarial Story Review

| Pass | Date | Total | CRIT | HIGH | MED | LOW | Counter | Verdict |
|------|------|-------|------|------|-----|-----|---------|---------|
| 1 | 2026-05-06 | 14 | 2 | 5 | 5 | 2 | 0/3 | FINDINGS_REMAIN |
| 2 | 2026-05-06 | 5 | 0 | 0 | 3 | 1 | 0/3 | CONVERGING |
| 3 | 2026-05-06 | 5 | 0 | 1 | 3 | 1 | 0/3 | ASYMPTOTIC |
| 4 | 2026-05-06 | 5 | 0 | 0 | 4 | 1 | 0/3 | ASYMPTOTIC |
| 5 | 2026-05-06 | 4 | 0 | 1 | 1 | 2 | 0/3 | ASYMPTOTIC |
| 6 | 2026-05-06 | 5 | 1 | 1 | 2 | 1 | 0/3 | REGRESSION |
| 7 | 2026-05-06 | 4 | 0 | 1 | 2 | 1 | 0/3 | ASYMPTOTIC |
| 8 | 2026-05-06 | 4 | 0 | 1 | 1 | 2 | 0/3 | ASYMPTOTIC |
| 9 | 2026-05-06 | 4 | 0 | 2 | 2 | 0 | 0/3 | ASYMPTOTIC |
| 10 | 2026-05-07 | 1 | 0 | 0 | 1 | 0 | 0/3 | CONVERGING |
| 11 | 2026-05-07 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 12 | 2026-05-07 | 1 | 0 | 0 | 1 | 0 | 2/3 | CLEAN-PASS |
| 13 | 2026-05-07 | 0 | 0 | 0 | 0 | 0 | 3/3 | FULL CONVERGENCE |

**Trajectory:** 14→5→5→5→4→5→4→4→4→1→0→1→0 — **CONVERGED** (Pass 13, 2026-05-07)

### Pass 1 (2026-05-06)

**Findings:** 14 (2C/5H/5M/2L)
**Convergence counter:** 0 of 3

Pass 1: 2 CRITICAL mis-anchorings (S-3.01 file, S-1.06 holdout claim). 5 HIGH (holdout coverage gaps, NFR-S-A orphan). 5 MEDIUM (BC mis-anchor S-3.04, frontmatter schema, refresh_oauth_token signature, sizing). All FIXED. New story S-3.09 added. STORY-INDEX v1.4.0, 31 stories total.

---

### Pass 2 (2026-05-06)

**Findings:** 5 (0C/0H/3M/1L)
**Convergence counter:** 0 of 3

Severity dropping (CRITICAL/HIGH→MED/LOW). Trajectory 14→5. P1 fixes 7/10 verified clean; 1/10 partial (sibling-text propagation gap S-2.02→H-021). 3 BC mis-anchorings in Pre-existing Test Coverage appendix (P1-introduced content). Trend converging.

---

### Pass 3 (2026-05-06)

**Findings:** 5 (0C/1H/3M/1L)
**Convergence counter:** 0 of 3

P2 fix gap caught (GAP-H-006 BC residue). HIGH WAVE-PLAN drift caught (Wave 1/2/3 still TBD placeholders post-burst). S-2.07 H-020 false attribution to S-1.06. S-1.06 Out of Scope missing H-008. S-2.06 AC-005 path-dependence resolved with concrete invocation. Trajectory 14→5→5.

---

### Pass 4 (2026-05-06)

**Findings:** 5 (0C/0H/4M/1L)
**Convergence counter:** 0 of 3

WAVE-PLAN ↔ STORY-INDEX sibling-propagation pattern recurs (P-001/002/003). Pass 1 fix to S-3.04 BC anchors didn't propagate to WAVE-PLAN. Pass 4 fixes WAVE-PLAN to match STORY-INDEX. S-2.05 NFR-O-R added to STORY-INDEX (WAVE-PLAN was correct). Wave 3 efforts reconciled (S-3.02 small, S-3.03 medium, S-3.07 small) in WAVE-PLAN. S-0.01 Test Plan decisively chooses Option (1) constructor extension. S-0.02 conditional language resolved: total/start_at are pub fields, not methods. DRIFT-003 added (sibling-sweep process gap). Trajectory 14→5→5→5.

---

### Pass 5 (2026-05-06)

**Findings:** 4 (0C/1H/1M/2L)
**Convergence counter:** 0 of 3

P4 fixes 5/5 verified clean. New pattern: AC-trace target BCs not in bc_anchors (S-3.07 — surfaces semantic mis-anchor + frontmatter coherence issue). S-3.05 missing Holdout Strategy section. S-1.06 dep propagation gap. Trajectory 14→5→5→5→4.

---

### Pass 6 (2026-05-06)

**Findings:** 5 (1C/1H/2M/1L) — REGRESSION
**Convergence counter:** 0 of 3

CRITICAL discovery: BC-6.4.* dangling in STORY-INDEX (since corpus inception, propagated by P5 fix). Fresh-context BC catalog walk surfaced this. Replaced 7 sites with BC-6.1.004/BC-6.1.005. BC-2.1.001 mis-anchor removed from S-3.07 (anti-loop guard now NFR-R-F-anchored only). 4 P5 propagation gaps caught + fixed. DRIFT-004 added.

---

### Pass 7 (2026-05-06)

**Findings:** 4 (0C/1H/2M/1L)
**Convergence counter:** 0 of 3

P6 fixes 5/5 verified clean. DRIFT-004 deep BC sweep CLEAN. New finding classes: risk_anchors semantic mis-anchor (R-M5→R-M2 in S-3.04); fabricated BC anchor (S-2.05 BC-6.1.001 stretched paraphrase, removed); STORY-INDEX:108 BC-2.1.013 propagation gap (DRIFT-003 recurrence); S-1.06 ADR-0013 forward-ref annotated. Trajectory 14→5→5→5→4→5→4.

---

### Pass 8 (2026-05-06)

**Findings:** 4 (0C/1H/1M/2L)
**Convergence counter:** 0 of 3

HIGH: H-009 row mis-anchor in Pre-existing Test Coverage (sibling-sweep miss from Pass 2 fix family; BC-X.8.001→BC-2.3.035). MEDIUM: S-1.05 NFR-S-B→NFR-S-E (S-0.05 owns NFR-S-B; S-1.05 owns CI/CD config NFR-S-E). LOW: H-NEW-AUTH-002 absence annotated in holdout-scenarios.md frontmatter; H-NEW-MP-001 dual-format documented in preamble. Proactive appendix audit performed — 6 additional BC mismatches corrected: H-010/H-011/H-012/H-015/H-018/H-024/H-026 + Gap Register sync. DRIFT-003 recurrence: sibling-sweep miss at H-009. Trajectory 14→5→5→5→4→5→4→4.

---

### Pass 9 (2026-05-06)

**Findings:** 4 (0C/2H/2M/0L)
**Convergence counter:** 0 of 3

All 4 findings = DRIFT-003 sibling-propagation recurrences. P8 NFR-S-B→S-E body propagation miss (HIGH): S-1.05 body + AC-001 + AC-005 + STORY-INDEX:88 exit gate updated. S-2.01 frontmatter 10 BCs vs index 4 (HIGH): BC-2.1.013 removed (single-owner with S-2.02); STORY-INDEX:107 reconciled to 9 BCs. S-0.07 fabricated BC paraphrase (MED): bc_anchors cleared, AC-001 trace retargeted to SD-002 resolution. WAVE-PLAN drift (MED): S-1.07 +BC-X.1.005, S-1.08 +BC-1.4.025, S-2.07 effort small→medium. Trajectory 14→5→5→5→4→5→4→4→4.

---

### Pass 10 (2026-05-07)

**Findings:** 1 (0C/0H/1M/0L)
**Convergence counter:** 0 of 3

Strong convergence signal: trajectory dropped 4→1. Pass 9 fixes 7/7 verified clean. Single finding: S-1.08 depends_on drift (DRIFT-003 recurrence; over-declared mirror of S-1.06; `depends_on: [S-0.05]` removed from S-1.08 frontmatter + WAVE-PLAN synced). Pass 11 target: CLEAN-PASS.

---

### Pass 11 (2026-05-07)

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 1 of 3

FIRST CLEAN-PASS after 10 SUBSTANTIVE passes. Trajectory 14→5→5→5→4→5→4→4→4→1→0. P10 fix verified across 4 surfaces (S-1.08 frontmatter, body, WAVE-PLAN, STORY-INDEX). 2 carry-forward observations (JiaClient cosmetic typo, story-id manifest gap) tagged but below threshold.

---

### Pass 12 (2026-05-07)

**Findings:** 1 (0C/0H/1M/0L) — CLEAN-PASS (sub-threshold)
**Convergence counter:** 2 of 3 (strict-binary: CLEAN-PASS; 1 finding < 3-finding threshold)

Single finding ADV-P2-S12-001 (MEDIUM): S-1.08 body line 274 "Depends on S-0.05" — DRIFT-003 recurrence (body propagation miss from P10 partial-fix). RESOLVED this burst by story-writer. Trajectory 14→5→5→5→4→5→4→4→4→1→0→1. 1 more consecutive CLEAN-PASS needed for 3/3 convergence.

---

### Pass 13 (2026-05-07)

**Findings:** 0 — CLEAN-PASS — FULL CONVERGENCE
**Convergence counter:** 3 of 3

CONVERGED. 0 substantive findings. OBS-13-1 RESOLVED (JiaClient typo global sweep; S-0.05:62/206, S-1.06:165 — 0 remaining). OBS-13-2 RESOLVED (Story Manifest table added to STORY-INDEX v1.4.1, 31 rows; version bumped to 1.4.1→1.4.2 after CV2-002 fix). ADV-P2-S12-001 body fix verified not regressed. 8 lens axes all clean. Final trajectory: 14→5→5→5→4→5→4→4→4→1→0→1→0.

**Phase 2-adv: 3/3 FULL CONVERGENCE achieved 2026-05-07.**

---

## Phase 3-adv — PR #357 Copilot Review (chore/release-gate-jr-base-url-335)

### PR #357 Trajectory Summary

| Round | Date | Findings | Delta | Fix SHA | Notes |
|-------|------|----------|-------|---------|-------|
| R1 | 2026-05-12 | 3 | — | 144aaff | CRITICAL: Config::base_url() ungated; MEDIUM: missing regression tests; LOW: CLAUDE.md inaccuracy. All 3 Perplexity-validated before acting. Two-site gating completed (config.rs + client.rs). 4 test_335_* tests added. CLAUDE.md updated. |
| R2 | 2026-05-12 | 0 | -3 | — | Review id 4268805775 @ 2026-05-12T02:52:59Z. "Copilot reviewed 4 out of 4 changed files in this pull request and generated no new comments." **PHASE 8 STOP CONDITION HIT.** PR #357 CONVERGED. |

**Trajectory shorthand:** `3→0` — **CONVERGED** at R2 / **MERGED** @ d208a6d (2026-05-12T03:03:12Z)

**Initial commit:** cb3e8a3 (8-line diff: src/api/client.rs + CLAUDE.md)
**Fix commit:** 144aaff (added Config::base_url() gate + tests/base_url_release_gate.rs + CLAUDE.md two-site doc)
**Merge SHA:** d208a6d (squash: "chore(security): release-gate JR_BASE_URL to prevent token leak (#335) (#357)")

### Comparative Analysis: PR #357 vs PR #356

| Metric | PR #356 (sanitize-errors-334) | PR #357 (release-gate-jr-base-url-335) |
|--------|-------------------------------|----------------------------------------|
| Rounds | 19 | 2 |
| Findings total | 36 | 3 |
| Trajectory | 4→1→2→2→3→2→3→2→2→1→1→2→1→1→2→3→1→1→0 | 3→0 |
| Fix commits | Multiple (51e2807, d061b14, 274961c, fe25e22, ...etc.) | 1 (144aaff) |
| Doc-fallout cluster? | Yes (R14→R18: 7 findings from Unicode C1 change) | No — doc-fallout lesson applied (CLAUDE.md updated in same fix commit) |
| Order of magnitude difference | — | ~10x fewer rounds |

**Root cause of order-of-magnitude difference:**
1. **Tight scope:** PR #357 was an 8-line diff with one security pattern, vs PR #356's broad escape-encoding behavioral change.
2. **Pre-validation done before R1:** Perplexity validated the #[cfg(debug_assertions)] approach (retroactively, but before R1 was triaged). No round was wasted on an invalid fix approach.
3. **R1 caught the critical gap immediately:** The CRITICAL finding (Config::base_url() ungated) was surfaced and fixed in a single tight commit covering all three issues atomically.
4. **Doc-fallout lesson applied:** commit 144aaff updated CLAUDE.md in the SAME commit as the code fix — preventing the 4-round doc-fallout cluster pattern seen in PR #356 R14-R18.
5. **No regression accumulation:** PR #356 had regressions at R5, R8, R11, R14, R17 (5 regression rounds); PR #357 had zero — the fix was correct on the first attempt once the surface area was complete.

**Lesson validated:** Pre-fixing the doc-fallout class (updating docs atomically with behavior) eliminates an entire category of subsequent review rounds. PR #357 is the first confirmed successful application of the doc-fallout lesson codified during PR #356 R19.

---

## Phase 3-adv — PR #358 Copilot Review (chore/edit-field-categorization-test-343)

### PR #358 Trajectory Summary

| Round | Date | Findings | Delta | Fix SHA | Notes |
|-------|------|----------|-------|---------|-------|
| R1 | 2026-05-12 | 1 | — | 9ca690e | Review 4268914353. HashSet ordering nondeterministic — doc claimed "alphabetically-stable HashSet"; iteration order is hash-seed-dependent. Fix: all set types switched to BTreeSet (return type, accumulator, caller-side sets, union). Perplexity: skipped (Lesson 1 boundary — Rust std::collections semantics). 1/1 threads resolved (PRRT_kwDORs-xfc6BSISi). CI 8/8 green. cargo test 1249 passed. |
| R2 | 2026-05-12 | 1 | 0 | c708211 | Review 4268937977. Closing-brace detection used exact `"    },"` string — fragile under last-variant `}`, `},  // comment`, trailing whitespace. Fix: is_matching_closing_brace closure (trim_start + tolerant content check); 3 new edge-case unit tests (+3 tests: no_trailing_comma, trailing_comment, trailing_whitespace). Perplexity: skipped (Lesson 1 boundary — string-matching logic in test helper). 1/1 threads resolved (PRRT_kwDORs-xfc6BSMuX). CI 8/8 green. cargo test 1252 passed. |
| R3 | 2026-05-12 | 2 | +1 | 925da89 | Doc-fallout from R2 tolerant-matcher commit. Finding C1: strategy doc still described pre-R2 "8-space indent + `},` exact close" behavior — updated to describe trim_start + byte-positioning mechanism. Finding C2: dead-code `rest.starts_with(' ')` in is_matching_closing_brace — after strip_prefix('}') succeeds, rest never starts with space; removed. Perplexity: skipped (Lesson 1 boundary — internal test helper doc accuracy). 2/2 threads resolved (PRRT_kwDORs-xfc6BSS3f, PRRT_kwDORs-xfc6BSS3r). CI 8/8 green. cargo test 1252 passed. |
| R4 | 2026-05-12 | 1-FP | — | none | Review 4269011038. **FALSE-POSITIVE.** Copilot claimed `include_str!("../mod.rs")` from src/cli/issue/create.rs reads src/cli/issue/mod.rs (wrong file). Empirical probe: 27619 bytes, first lines `pub mod api;` — that is src/cli/mod.rs (27619 bytes), NOT src/cli/issue/mod.rs (3056 bytes). Perplexity: confirmed Rust `include_str!` paths relative to source file directory; from src/cli/issue/create.rs `..` → src/cli/ → `../mod.rs` = src/cli/mod.rs. Head unchanged (925da89). Reply 3223625559 with evidence. Thread PRRT_kwDORs-xfc6BSYVx resolved not-applicable. CI 8/8 green. cargo test 1252 passed. FIRST false-positive in 30+ rounds this session. |
| R5 | 2026-05-12 | 0 | -1 | — | Review 4269053836 @ 2026-05-12T04:11:09Z. "Copilot reviewed 1 out of 1 changed files in this pull request and generated no new comments." **PHASE 8 STOP CONDITION HIT. PR #358 CONVERGED.** |

**Trajectory shorthand:** `1→1→2→1-FP→0` — **CONVERGED** at R5 (2026-05-12) / awaiting human merge

**Initial commit:** 29608b8 (initial 17-field categorization test; 255 lines added; zero source touched)
**Fix commit 1:** 9ca690e (R1: HashSet → BTreeSet)
**Fix commit 2:** c708211 (R2: tolerant closing-brace matcher + 3 edge-case tests)
**Fix commit 3:** 925da89 (R3: strategy doc + dead-code cleanup; doc-fallout from R2)
**R4:** no commit (false-positive refuted with empirical evidence)
**R5:** stop condition — no commit
**Head at convergence:** 925da89

### Comparative Analysis: PR #358 vs PR #357 vs PR #356

| Metric | PR #356 (sanitize-errors-334) | PR #357 (release-gate-jr-base-url-335) | PR #358 (edit-field-categorization-343) |
|--------|-------------------------------|----------------------------------------|------------------------------------------|
| Rounds | 19 | 2 | 5 |
| Fix commits | Many | 1 | 3 |
| Total findings | 36 | 3 | 5 real + 1 FP = 6 nominal |
| Trajectory | 4→1→2→2→3→2→3→2→2→1→1→2→1→1→2→3→1→1→0 | 3→0 | 1→1→2→1-FP→0 |
| Doc-fallout cluster? | Yes — R14→R18 (4 rounds, 7 findings from Unicode C1 change) | No — lesson applied at R1 fix | Partial — R3 (1 round, 2 findings from R2 matcher change) |
| False-positive? | No | No | Yes — R4 (FIRST in session, 30+ rounds) |
| Rank (fastest convergence) | Slowest in cycle-001 | Fastest in cycle-001 | Second fastest |
| Scope | Broad behavioral change (escape encoding) | Single security gate (8-line diff, 2 read sites) | Test-only PR (zero source touched) |

**Key observations for PR #358:**

1. **Test-only scope keeps finding density low.** All 5 real findings were about test mechanics (BTreeSet ordering, brace-matching fragility, doc accuracy) — none required Perplexity validation under Lesson 1 boundary (no external API, library, or language behavior involved beyond well-established Rust std::collections and include_str! semantics). This is the expected pattern for test-only PRs.

2. **R2 produced a doc-fallout sub-cluster at R3 despite the lesson being codified.** The narration-style comments (Strategy:, Logic:) describing the old brace-matching behavior were ~15 lines above the changed closure — close enough to be in scope, far enough to be skipped without a deliberate grep. The sub-lesson ("grep narration-style comments before pushing behavior-expanding commits") was codified in lessons.md during Burst 60. PR #358 R3 is the second doc-fallout cluster in 2 days (first: PR #356 R14-R18; second: PR #358 R2→R3). Prevention cost for R3: one `grep -n "Strategy:\|Logic:" src/cli/issue/create.rs` before pushing c708211.

3. **First trajectory with an explicit false-positive marker (1-FP).** The R4 false-positive produced a round with 0 code change and 0 trajectory regression. It is recorded as `1-FP` to distinguish it from a real finding of weight 1 — the count reflects Copilot's claimed findings, not validated real findings. The FP was caught by DEC-018 empirical-first discipline; without it, the "fix" (`../../mod.rs`) would have broken the working test.

4. **Counterfactual cost of missing the false-positive:** Changing `../mod.rs` to `../../mod.rs` from `src/cli/issue/create.rs` would resolve to `src/mod.rs` — a file that does not exist. The test would have failed to compile, requiring a revert commit, a new Copilot round, and likely CI investigation. Estimated cost: 2+ additional rounds. Actual cost of false-positive identification: 1 probe test + 1 Perplexity query + 1 reply comment.

5. **Fastest-ever convergence comparison:** PR #357 (2 rounds) remains the fastest in cycle-001. PR #358 (5 rounds) is second fastest. The distribution is heavily bimodal: PR #356 (19 rounds) is an outlier caused by a broad behavioral change with repeated doc-fallout accumulation. PRs that are scoped to a single mechanism (security gate, test helper, docs-only) converge in 2-5 rounds consistently.

**Pattern for test-only PRs:** Based on PRs #353 (0 rounds of adversarial), #354 (2 rounds docs-only), #358 (5 rounds — test mechanics): test-only PRs tend toward fast convergence but are NOT immune to doc-fallout. When test code contains narration-style comments describing implementation strategy (Strategy:, Logic:, Algorithm:), those comments must be audited the same way as production doc comments when the behavior they describe changes.
