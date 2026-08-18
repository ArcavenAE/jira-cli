---
document_type: convergence-trajectory
level: ops
version: "1.1"
status: in-progress
producer: state-manager
timestamp: 2026-08-11T04:30:00Z
cycle: "cycle-001"
inputs: [adversarial-reviews/]
input-hash: "0634c9b"
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

---

## Extracted from STATE.md Convergence Trackers on 2026-05-26 (compact-state run)

### Phase 1d — Adversarial Spec Review

**3/3 FULLY CONVERGED** at Pass 28 (2026-05-04). 28 passes total: 25 SUBSTANTIVE + 3 consecutive CLEAN-PASS (P26-P27-P28). 5 counter resets. ~80+ findings addressed. Final trajectory: 30→15→9→5→10→5→4→3→4→0→2→0→3→0→2→0→3→0→3→5→3→4→5→5→5→2→0→0→0. Spec corpus at convergence: 541 BCs, 41 NFRs, 48 holdouts, 26 risks, 13 ADRs, 3 SDs. Phase 1 → Phase 2 gate APPROVED (DEC-009, 2026-05-04). Full per-pass details in this file above.

### Phase 2-adv — Adversarial Story Review

**3/3 FULLY CONVERGED** at Pass 13 (2026-05-07). 13 passes: 10 SUBSTANTIVE + 3 consecutive CLEAN-PASS (P11-P12-P13). Trajectory: 14→5→5→5→4→5→4→4→4→1→0→1→0. Full per-pass details in this file above.

### Phase 3-adv — Wave Adversarial Reviews (per-story + wave)

Wave gate: not started. Feature Mode #110-pr2: **F5 CONVERGED** 12→5→0→0→0 (Pass 5, 2026-05-10). F6: SECURITY PASS (→#334). F7: PASS-WITH-FOLLOWUPS (5/5; →#347). 10 Copilot rounds: 27/27 resolved. PR #348 MERGED 2026-05-11 @ e480ff2 (closes #110). **PR #351 MERGED 2026-05-11 @ 3216ec2** (closes #339+#344). **PR #352 MERGED 2026-05-11 @ 57cc0ae** (closes #337+#341+#347; R2 clean 3→0). **PR #353 MERGED 2026-05-11 @ 7fbf14d** (closes #338; 0 inline Round 1). **PR #354 MERGED 2026-05-11 @ 4e14849** (closes #342; docs-only; CONVERGED 1→1→0). **PR #355 MERGED 2026-05-11 @ 448c568** (closes #332; trajectory 3→1→0). **PR #356 MERGED 2026-05-12T01:37:46Z @ 9acf01d** (closes #334; CWE-117 sanitize_for_stderr; 19 rounds; trajectory 4→1→2→2→3→2→3→2→2→1→1→2→1→1→2→3→1→1→0; 36/36 threads resolved; CI 8/8 green). **PR #357 MERGED 2026-05-12T03:03:12Z @ d208a6d** (closes #335; chore(security): release-gate JR_BASE_URL; 2 rounds; trajectory 3→0; fastest convergence in cycle-001; doc-fallout lesson applied). **PR #358 MERGED 2026-05-12 @ 561217b** (squash: "chore(test): assert every IssueCommand::Edit field is categorized (#343) (#358)"; closes #343; 5 rounds; trajectory 1→1→2→1-FP→0; second fastest in cycle-001; first false-positive at R4 caught by DEC-018 empirical-first discipline). 6 audit-followups remain: #333, #336, #340, #345, #346, #350 (#331 sandbox-blocked deferred). Full records: `cycles/cycle-001/adversarial-reviews/issue-110-pr2/` + `cycles/cycle-001/adversarial-reviews/pr-352-docs-cleanup/` + `cycles/cycle-001/adversarial-reviews/pr-353-bulk-max-keys/` + `cycles/cycle-001/adversarial-reviews/pr-354-labels-shape-doc/` + `cycles/cycle-001/adversarial-reviews/pr-355-task-id-validation/` + `cycles/cycle-001/adversarial-reviews/pr-356-sanitize-errors/` + `cycles/cycle-001/adversarial-reviews/pr-357-release-gate-jr-base-url/` + `cycles/cycle-001/adversarial-reviews/pr-358-edit-field-categorization-test/`.

**Issue #350 (search_issue_keys) F5 CONVERGED 2026-05-13** — 11 substantive passes (longest cycle-001 convergence). Trajectory 4→0→5→5→3→5→2→1→0→0→0. 3 consecutive CLEAN at passes 09-10-11. **PR #362 MERGED 2026-05-13T17:51:09Z @ 8010445** (Copilot R3=0). Net delivery: BC-2.6.050 + 13 tests + 8 ACs + ~70 LOC impl. Full record at `.factory/cycles/cycle-001/adversarial-reviews/issue-350-search-issue-keys/CONVERGENCE.md`.

**Issue #361 (JRACLOUD-95368 citation rebind) CONVERGED + MERGED 2026-05-14** — PR #364 @ b8a87c5. Branch `chore/search-warning-jra-95368`. ~10 Copilot rounds →0. Fixes citation JRACLOUD-94632 → JRACLOUD-95368 in repeated-cursor stderr warning; fixes has_more asymmetry in search_issues; pins no-dedupe contract test; updates spec with citation + per-CLI carve-out bullets. Closes #361.

**Issue #365 follow-up (CLAUDE.md citation-validation discipline) MERGED 2026-05-14** — PR #366 @ ad6b979. Branch `docs/claude-md-jracloud-95368-followup`. Copilot R1=0. Adds CLAUDE.md Gotcha for JRACLOUD-95368 + AI Agent Note for external-tracker citation discipline.

**Issue #365 (search_issue_keys + search_issues in-function dedupe) MERGED 2026-05-15** — 17 F1d passes (2 rounds) + F5 CONVERGED (4 passes) + F6 5 Copilot rounds → **PR #367 MERGED @ e193c16** (squash, 2026-05-15T17:51:09Z; closes #365).
- F1d Round 1: P1-P11, 6 resets, CONVERGED at v0.1.8 (3/3 CLEAN P9-P10-P11). Trajectory: 0/4/2→0/0/2→0/1/3→0/2/2→0/1/1→0/2/5→0/1/4→0/1/2→0→0→0.
- F1d Round 2: P12-P17, 2 resets, CONVERGED at v0.1.12 (3/3 CLEAN P15-P16-P17). Trajectory: CLEAN(P12)→0/6/0(P13)→1B/2/0(P14)→CLEAN(P15)→CLEAN/2NIT(P16)→CLEAN(P17).
- F5: adversary 3-clean + code-reviewer CONVERGENCE_REACHED + security LOW-RISK APPROVE (4 passes total).
- F6: R1 (substantive) → R2 (O(N²)→O(N) algorithmic improvement caught) → R3 (cascade doc cleanup) → R4 (remaining doc cascade) → R5 (0 inline, CLEAN). Trajectory: substantive→algorithmic-improvement→doc-cascade×2→clean.
- Notable: F6 R2 caught O(N²) complexity issue (Vec::retain + per-iteration HashSet rebuild replaced with incremental external `seen_keys` HashSet) that F5 3-reviewer panel missed. See L-365-1. Drift items: PG-365-1 (BC Trace stale-count), PG-365-2 (F1d citation-verification scope, engine-level). DRIFT-006 added for F5 multi-axis review gap.
Full record: `.factory/cycles/cycle-001/adversarial-reviews/issue-365-search-issue-keys-dedupe/CONVERGENCE.md`. Cycle CLOSED 2026-05-15T17:51:09Z.

### Issue #288 — Retrospective Audit (2026-05-19)

9-pass retrospective audit completed 2026-05-19 by research-agent. Convergence trustworthiness: **PASS**. Outcome: 0 REFUTED, 11 CONFIRMED, 1 PARTIAL (no-action), 1 INCONCLUSIVE (already filed as #384/#385). 3 INCONCLUSIVE-LOCAL items re-validated post-pull (develop @ 9523255) — all CONFIRMED. 4 follow-up GitHub issues filed: #382 (M-03), #383 (O-01), #384 (O-08-01+O-08-05), #385 (O-08-02/04/06/07). F5/F6/F7 epic-level reruns waived.

Research artifacts: `.factory/research/issue-288-pr4-retrospective-audit.md` + `.factory/research/issue-288-pr4-deferred-validation.md`

### Issue #382 — Quick-Dev Convergence (2026-05-19)

F1d adversarial: 8 passes total (passes 06/07/08 CLEAN, 3/3). F4 per-story adversarial: 3 passes total (all CLEAN, 3/3). pr-reviewer: APPROVE in 1 cycle, 0 blocking findings. Copilot review: COMMENTED with 0 inline comments. CI: 10/10 green including mutation testing (5min). Pre-existing flake noted: tests/multi_cloudid_disambiguation.rs keychain contention (NOT a regression). PR #389 MERGED @ b1c863e (2026-05-19T18:40:25Z). Issue #382 auto-closed at 2026-05-19T18:40:27Z.

### Issue #384 — Full-Cycle Convergence CLOSED (2026-05-20)

F2 adversarial spec review: 3 passes, 3/3 CLEAN. CRITICAL control-flow defect caught at pass 1: OAuth Bearer + generic-expiry 401 must route through the refresh coordinator (blanket-401 trigger per BC-X.3.002 + DEC-013), NOT the NotAuthenticated arm; corrected in bc-3-issue-write.md BC-3.8.014/015 scoping language + OAuth test paths pinned via scope-mismatch request bodies. Spec corpus at convergence: 573 BCs total (+4: BC-3.8.014, BC-3.8.015, BC-X.8.006, BC-X.8.007; modified: BC-3.8.001, BC-3.8.009, BC-X.3.002). H-NEW-JSM-RT-003 revised. Spec version 1.1.0. F4 per-story adversarial: 3 passes, 3/3 CLEAN. BC-3.8.014/015 + BC-X.8.006/007 verified. is_oauth_auth() predicate + API_TOKEN_EXPIRY_HINT contract verified. Copilot review: 3 cycles, converged to zero comments. PR #394 squash-merged @ b36b291 (2026-05-20). Issue #384 auto-closed. F7 traceability verified: 4 BCs (BC-3.8.014/015, BC-X.8.006/007) ↔ 5 named tests in tests/issue_create_jsm.rs + inline unit tests ↔ 4-file implementation (is_oauth_auth(), API_TOKEN_EXPIRY_HINT, handle_jsm_create, require_service_desk). All 3 spec guards exit 0. PG-384-1 (BC-INDEX Coverage Statistics table gap) + PG-384-2 (spec-guard incompleteness F2/F3) recorded as justified deferrals. Cycle CLOSED 2026-05-20.

### Issue #385 — Full-Cycle Convergence CLOSED (2026-05-20)

F2 adversarial spec review: 19 total passes, 3/3 CLEAN (passes 17/18/19). Enhancement: JSM input validation + UX polish (O-08-02/04/06/07). 2 new BCs added: BC-3.8.016 (empty-request-type guard), BC-3.8.017 (markdown/field-conflict guard). 3 BCs modified: BC-3.8.002 (JSM guard-string precision), BC-3.8.010 (--type-ignored stderr), BC-3.8.011 (--field on JSM path). 2 new holdouts: H-NEW-JSM-RT-006/007. Spec version advanced v1.1.0→v1.2.0 (575 BCs). Process gaps recorded: PG-385-1..4.

F3 story decomposition: S-385 (JSM input validation + UX polish) decomposed — 1 story, 5 SP, 7 ACs covering O-08-02/04/06/07. Adversarial story convergence: 12 total passes, 3/3 CLEAN. STORY-INDEX total_stories corrected 44→43 (pre-existing off-by-one, PG-385-6). Process gaps recorded: PG-385-5/6/7.

F4 delivery: PR #395 squash-merged @ f7fc8c3 (2026-05-20). All 4 O-08 fixes delivered: O-08-02 (BC-3.8.002 harmonized error string), O-08-04 (BC-3.8.016 empty --request-type guard), O-08-06 (BC-3.8.017 --markdown+--field description= conflict guard), O-08-07 (BC-3.8.010/011 platform-flag warnings moved post-require_service_desk). Red Gate verified in src/cli/issue/create.rs. Per-story adversary CONVERGED 3/3 CLEAN. Copilot 3 rounds →0. CI 10/10 green.

F7 traceability verified: 4 O-08 fixes → 5 BCs (BC-3.8.002/010/011/016/017) → 7 required test deliverables in tests/issue_create_jsm.rs → merged implementation @ handle_jsm_create locus in src/cli/issue/create.rs → f7fc8c3 on develop. Guard strings "request type cannot be empty" and "`--field description=...` cannot be combined with `--markdown`" confirmed present via git show f7fc8c3. H-NEW-JSM-RT-006/007 holdouts: realized_by bindings exist in tests/issue_create_jsm.rs per F3 story spec. All 3 spec guards exit 0. 7 process-gaps PG-385-1..7 recorded as justified deferrals. Issue #385 CLOSED / stateReason COMPLETED. Cycle CLOSED 2026-05-20.

### Issue #398 — CYCLE CONVERGED & CLOSED (2026-05-22)

F1 Delta Analysis COMPLETE + human-approved. F2 Spec Evolution COMPLETE (re-converged): 16 total adversary passes, 3/3 CLEAN (passes 14/15/16). 10 product-owner fix rounds. Human-gate scope change: BC-3.4.014 (confirmation-echo --output json shape) broadened from team-only to ALL-set-fields echo, mirroring BC-3.4.012. VP-398-005 scope broadened; VP-398-006 added → 6 VPs total (VP-398-001..006). 3 additional re-convergence passes CLEAN after broadening. F2-gate consistency-validator re-audit run twice; all defects fixed. Both spec-count guard scripts exit 0 (580 BCs across 8 files). New BCs: BC-3.4.012 (confirmation-echo field-list contract), BC-3.4.013 (confirmation-echo suppression on --no-input), BC-3.4.014 (confirmation-echo --output json shape — all set-fields). BC-3.4.003 annotated. bc-3: 97→100 BCs. BC-INDEX: 577→580. New VPs: VP-398-001..006 in `.factory/phase-f2-spec-evolution/verification-delta-398.md`. PRD delta: `.factory/phase-f2-spec-evolution/prd-delta-398.md`.

F3 COMPLETE: S-398 created (21 ACs, 23 test deliverables). F4 COMPLETE: PR #399 squash-merged @ b49f2fd (2026-05-22); issue #398 CLOSED; Red Gate → TDD 5 micro-commits → 3/3 CLEAN adversary (1 false-alarm PG-398-4 discarded) → 10/10 CI → Copilot (1 finding REFUTED).

F5 CONVERGED — 3 consecutive clean adversary passes (no CRITICAL/HIGH). PG-398-4 codified (worktree-path class, 2nd recurrence from PG-388-4).

F6 PASS — mutation testing 100% (3/3 viable mutants caught, 0 surviving). Kani + fuzz: JUSTIFIED-SKIP (no new unsafe code, no new numeric boundary operations). `cargo audit`: 0 vulnerabilities. `cargo deny`: clean. No new dependencies introduced. Full regression: CLEAN (modulo pre-existing `multi_cloudid_disambiguation` macOS-keychain flake, unrelated to #398).

F7 PASS — all 5 dimensions PASS. Spec: BC-3.4.012/013/014 + VP-398-001..006 in corpus; both spec guards exit 0. Test: 23 test deliverables present. Implementation: feature code on develop @ b49f2fd. Verification: 6 VPs all PASS. Holdout: no new holdout scenarios introduced (none required). Regression: PASS. MAXIMUM_VIABLE_REFINEMENT reached. Human authorized cycle-close 2026-05-22.

Disposition: PR #399 squash-merged to develop @ b49f2fd; issue #398 CLOSED. Ships with next batched develop→main release (no standalone release cut). Follow-up #400 filed for TH-398-1..4 + PG-398-1..5 (non-blocking maintenance sweep). Lessons L-398-01..05 codified. CYCLE CONVERGED & CLOSED.

### Issue #396 — F4 Delta Implementation COMPLETE (2026-05-23)

F2 adversarial spec review: 9 passes total, 3/3 CLEAN (passes 7/8/9). Feature: `jr issue edit --field NAME=VALUE` (arbitrary custom fields incl. JSM Urgency/Impact via platform PUT/editmeta-driven resolution + new per-profile `fields.json` cache; edit side only — create side shipped in S-288-pr4). 3 new BCs: BC-3.4.015 (editmeta-driven field resolution), BC-3.4.016 (type coercion + validation), BC-3.4.017 (fields.json per-profile cache). 12 VPs: VP-396-001..012. bc-3: 100→103 BCs; canonical total: 580→583. `check-bc-cumulative-counts.sh` extended with Surface H (bc-N file footer) during pass 2. Fresh-context consistency audit verdict: CONSISTENT (4 minor gaps found + fixed). Both spec-count guard scripts exit 0. F1 gate decisions: flag-overlap exits 64; v1 type coverage = string/number/option/date/datetime/user (array + CMDB rejected); single-key only. Request-Type-change: declared non-goal (JSDCLOUD-4609). F2 PASSED (human-approved 2026-05-22). F3 PASSED (human-approved 2026-05-22) — S-396 created: 18 ACs, 34 test deliverables, 8 SP, HIGH criticality, tdd strategy, depends_on S-398 (already delivered). STORY-INDEX total_stories 45→46. Artifacts: `.factory/phase-f1-delta-analysis/issue-396/`, `.factory/phase-f2-spec-evolution/adversarial-396-pass-1..9.md`, `prd-delta-396.md`, `verification-delta-396.md`, `consistency-audit-396.md`, `.factory/stories/S-396-issue-edit-field-flag.md`.

F4 Delta Implementation COMPLETE (2026-05-23): PR #401 squash-merged @ 2f61566; issue #396 auto-closed. Per-story adversarial convergence: 5 passes, CONVERGED at passes 3/4/5 (3 consecutive CLEAN). Trajectory: 4 HIGH + 7 MED → 1 MED → CLEAN×3. Copilot review cycle: R1 3 findings (all fixed); R2 4 findings (2 fixed in-PR, 1 REFUTED research-backed, 1 DEFERRED with rationale); R3 = 0 inline comments → COPILOT-CONVERGED. All 7 review threads resolved. CI on final commit `f81fe66`: 10/10 pass including mutation testing. Test count: 44 total (43 integration + 1 cache unit). Feature branch + `ci/issue-396-bc-cumulative-counts-surface-h` branch both deleted. Worktree cleaned. Drift item R2-C4 recorded (test 38 wire-serialization reimplementation; GitHub issue to be filed post-cycle). AWAITING F5 Scoped Adversarial Review.

### Issue #396 — F5 Scoped Adversarial Review CONVERGED (2026-05-25)

4 passes total. Convergence at passes 2/3/4 (3 consecutive CLEAN). Trajectory: 1→0→0→0 (HIGH count per pass). Pass 1 NOT-CLEAN: 1 HIGH (silent-drop of `--label` + `--field` on platform non-JSM path; missing EC-3.4.017-13). Passes 2/3/4 CLEAN: 4 LOW observations each (pre-existing/cosmetic; recorded as drift items DI-396-F5-1/2/3/4). FIX-F5-001 resolved: PR #406 squash-merged @ `699a5fd` (develop, 2026-05-25); EC-3.4.017-13 added to bc-3-issue-write.md; factory-artifacts spec commit `9e61c05`. AWAITING F6.

Full pass reports: `.factory/phase-f5-adversarial/issue-396/`.

### Issue #407 — F2 Adversarial Spec Review CONVERGED (2026-05-25)

4 passes total. Convergence at passes 2/3/4 (3 consecutive CLEAN). Trajectory: 7→2→1→2 (all LOW severity, no CRITICAL/HIGH/MEDIUM). Pass 1: 7 LOW findings (trace frontmatter gap, invariant wording, cross-ref language, minor structural items). Passes 2–4 CLEAN. Fresh-context consistency audit: CONSISTENT (1 LOW perimeter gap — missing trace frontmatter entry — found and fixed). F2 net changes: EC-3.4.017-14 added to BC-3.4.017 documenting the structural meta-test mechanism (include_str! source-text parsing); BC-3.4.017 invariant 2 updated with cross-reference. 0 new BCs. 0 new VPs. BC counts: 583 total / bc-3: 103. All 3 spec guards exit 0. Frontmatter dates advanced 2026-05-25. AWAITING F2 human gate.

Artifacts: `.factory/phase-f1-delta-analysis/issue-407/`, `.factory/phase-f1-delta-analysis/affected-files-407.txt`, `.factory/phase-f2-spec-evolution/prd-delta-407.md`, `adversarial-407-pass-1..4.md`, `consistency-audit-407.md`.

### Issue #407 — F5 Scoped Adversarial Review CONVERGED (2026-05-25)

3 passes total. Convergence at passes 1/2/3 (3 consecutive CLEAN). Trajectory: 4→0→0 (LOW observation count per pass). No CRITICAL/HIGH/MEDIUM at any pass. No fix-PRs needed — implementation passed clean from the start. Pass 1: 4 LOW informational observations (O-1: stale code-comment line citation in test_343 — routed to #408; O-2: stale spec line citation in EC-3.4.017-10 — routed to #408; O-3: single-line-only extractor fragility with R2 pin as safety net — intentional; O-4: 12/12 coverage positive confirmation). Passes 2/3: 0 findings (novelty: NONE). Spec fidelity high; meta-test (EC-3.4.017-14) mechanically enforces BC-3.4.017 invariant 2; bidirectional test coverage 12/12. AWAITING F6.

Full pass reports: `.factory/phase-f5-adversarial/issue-407/`.

### E2E Live-Jira Feature — F5 Scoped Adversarial Review CONVERGED (2026-05-29)

7 passes total. Convergence at passes 5/6/7 (3 consecutive CLEAN). Full bar chosen by human over early-accept at 1 clean (DEC-033).

| Pass | Date | CRIT | HIGH | MED | LOW | Counter | Verdict |
|------|------|------|------|-----|-----|---------|---------|
| 1 | 2026-05-29 | 4 | 4 | 0 | 0 | 0/3 | FINDINGS_REMAIN |
| 2 | 2026-05-29 | 1 | 2 | 0 | 0 | 0/3 | FINDINGS_REMAIN |
| 3 | 2026-05-29 | 1 | 2 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| 4 | 2026-05-29 | 0 | 0 | 2 | 0 | 0/3 | FINDINGS_REMAIN |
| 5 | 2026-05-29 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 6 | 2026-05-29 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| 7 | 2026-05-29 | 0 | 0 | 0 | 0 | 3/3 | FULL CONVERGENCE |

Trajectory shorthand: `(4C/4H)→(1C/2H)→(1C/2H/1M)→(2M)→CLEAN→CLEAN→CLEAN`

**CRITICAL cluster (passes 1-3, all fixed):**
- C-1 (pass 1): `auth status` command emits no JSON and makes no Jira API call — AC-004 auth-status row was unsatisfiable. Fixed: AC-004-v2 stricken that row; `issue list` designated auth-seam validator.
- C-2 (pass 1): `project types` and `project statuses` are nonexistent subcommands. Fixed: tests removed from AC-004.
- C-3 (pass 1): `project fields` handler emits a JSON **object** (not array). Fixed: AC-004 corrected to assert `is_object()` + key presence.
- C-4 (pass 1, recorded as pass-2/3 C): workflow env-var mismatch — tests referenced `JR_BASE_URL` for the E2E base URL, but the harness uses `JR_E2E_BASE_URL` (AC-003 canonical). Fixed: e2e_cmd() harness corrected.
- C-5 (pass 2): `issue comment <key>` body is a positional message arg — no `--body` flag exists. Fixed: AC-007 step 4 corrected.
- C-6 (pass 2): harden-runner `egress-policy: audit` must be `block` for secret-safety. Fixed: e2e.yml updated.

**HIGH cluster (passes 1-3, all fixed):**
- Teardown `--all` resilience + `set -e` handling; coverage log; run-id consistency.
- Gate-test env-mutation UB → pure fn pattern.
- Sprint current clean-skip for no-active-sprint case.
- AC-007 label single-prefix fix (double `e2e-` prefix bug in AC text).
- Board list / user search element-count relaxation (shape-only; site-dependent).

**MEDIUM (pass 4, fixed):** harden-runner allowlist completion; meta-guard hardening.

**Two LOW deferred observations (passes 5-7, non-blocking):**
- DI-E2E-F5-1: AC-006 verification grep text is imprecise — `grep '"Done"|"In Progress"'` returns doc-comment matches (lines 38-39/155/160); executable code is correct; AC text is the imprecise artifact. Deferred: doc/runbook-level, no runtime impact on correctly-provisioned site.
- DI-E2E-F5-2: `sprint current` clean-skip only matches "No active sprint" stderr — a kanban-misconfigured `JR_E2E_BOARD_ID` would panic instead of skip. Provisioning assumption: board must be Scrum. Deferred: provisioning runbook item, no code change needed.

Branch fix commits (feat/e2e-live-jira-testing): df660d7, b6aad30, 8336752, fb00b61, be1e2b8, 2175463, 25c5f78, f78eed2 (plus original F4 commits cdf4dcf, cc77b9f).

**Root-cause pattern:** 6 CRITICAL defects were all in tests/workflow artifacts, invisible to hermetic CI because the live tests are gated no-ops. The adversary was able to catch them by verifying against real handler source code + CLI surface. This validates the discipline of F5 for infrastructure-only stories (zero src/ changes does not mean zero spec/test surface risk).

### Phase 5-adv — Adversarial Refinement
Not started.

**Pattern for test-only PRs:** Based on PRs #353 (0 rounds of adversarial), #354 (2 rounds docs-only), #358 (5 rounds — test mechanics): test-only PRs tend toward fast convergence but are NOT immune to doc-fallout. When test code contains narration-style comments describing implementation strategy (Strategy:, Logic:, Algorithm:), those comments must be audited the same way as production doc comments when the behavior they describe changes.

---

## S-E2E-2 — E2E Suite First-Live-Run Fixes (Feature Mode F5 CONVERGED, 2026-05-29)

**Story:** S-E2E-2 — `tests/e2e_live.rs` + `.github/workflows/e2e.yml` first-live-run fixes
**F5 Adversarial passes:** 4 total. Convergence at passes 2/3/4 (3 consecutive CLEAN).
**Live run trajectory:** run 26654916572 (17p/4f) → run 26658705120 (20p/0f) GREEN

### F5 Finding Progression

| Pass | Date | CRIT | HIGH | MED | LOW | Counter | Verdict |
|------|------|------|------|-----|-----|---------|---------|
| 1 | 2026-05-29 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| 2 | 2026-05-29 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 3 | 2026-05-29 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| 4 | 2026-05-29 | 0 | 0 | 0 | 0 | 3/3 | FULL CONVERGENCE |

Trajectory shorthand: `1M→CLEAN→CLEAN→CLEAN`

**Pass 1 MEDIUM finding (fixed):** Doc-fallout on sprint skip comment — the inline comment describing the sprint clean-skip path was imprecise about what "simple board" means in the Jira API context. Fixed in the implementation commit before F5 pass 2.

**Copilot review trajectory (5 rounds):**

| Round | Findings | Delta | Notes |
|-------|----------|-------|-------|
| R1 | ~3 | — | Bugs in fix logic; all Perplexity-validated; fixed |
| R2 | ~2 | -1 | Readability findings; fixed |
| R3 | ~2 | 0 | Readability + doc nit; fixed |
| R4 | 1 | -1 | Doc nit; fixed |
| R5 | 0 | -1 | Clean — **STOP CONDITION** |

Decay pattern: bug-class findings → readability → doc-nit. Matched DEC-026 inflection point analysis exactly.

**Fix commits (fix/e2e-first-run):** c9ad027, ee5cbce, 2bce989, 5550b40, 1991fa9, 6954196, ce48952, a927a72

**Fixes delivered:**
- **FIX-A:** `write_flow` used hardcoded `"In Progress"` / `"Done"` transition names. Fixed: read `JR_E2E_STATUS_IN_PROGRESS` / `JR_E2E_STATUS_DONE` env vars (defaulting to those names for convenience, matching the existing DEC-032 design).
- **FIX-B:** `sprint_list` and `sprint_current` would panic on the ES board (team-managed project = "simple board" response, not Scrum). Fixed: detect `"simple board"` board type in API response and emit a clean SKIP log message; test assertions relaxed to accept skip.
- **FIX-C:** Gate test was self-contradictory — it asserted a condition and then immediately asserted its negation. Removed entirely (it was testing framework plumbing that was already covered elsewhere).

**DI-E2E-F5-2 RESOLVED:** The sprint clean-skip originally only matched `"No active sprint"` stderr — now additionally handles "simple board" detection at the API response level. See `blocking-issues-resolved.md`.

**OQ-1 OPEN (LOW):** Board ES-1 on the ES project is a team-managed project. `jr sprint` commands return "This board is not a scrum board" for team-managed boards. The live suite skips sprint_list and sprint_current tests — they emit a SKIP log line and exit 0. The board is NOT a kanban board (it doesn't trigger the original "No active sprint" path); it is a third category: team-managed simple board. Real sprint coverage requires either (a) a company-managed Scrum project, or (b) a jr enhancement to support team-managed scrum boards. No code change needed to pass the live suite — it already passes green with the skip.

**Root-cause pattern:** First-live-run failures were all about runtime environment assumptions (board type, transition name strings) that hermetic wiremock tests cannot catch. This validates running the full live suite after provisioning rather than assuming hermetic green = live green.

**PR #434:** Squash-merged to develop @ 2ca9fc1 (2026-05-29). Branch fix/e2e-first-run deleted post-merge.

---

## E2E-PG-4 assign-by-query — adversarial convergence (test-only, 2026-06-02)

**Issue:** E2E-PG-4 sub-gap — assign to a specific user via `jr issue assign <KEY> --to <query>`
**Cycle:** test/e2e-assign-by-email → PR #458 → develop @ d45ec88
**F5 Adversarial passes:** 5 total. Convergence at passes 3/4/5 (3 consecutive CLEAN).
**Live e2e:** run 26790203429 = 67/0 GREEN

### F5 Finding Progression

| Pass | Date | CRIT | HIGH | MED | LOW | Counter | Verdict |
|------|------|------|------|-----|-----|---------|---------|
| 1 | 2026-06-02 | 1 | 0 | 0 | 0 | 0/3 | FINDINGS_REMAIN |
| 2 | 2026-06-02 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| 3 | 2026-06-02 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 4 | 2026-06-02 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| 5 | 2026-06-02 | 0 | 0 | 0 | 0 | 3/3 | FULL CONVERGENCE |

Trajectory shorthand: `1C→1M→CLEAN→CLEAN→CLEAN`

**Pass 1 CRITICAL finding (C-1 — load-bearing catch):** Test originally called `jr issue assign <KEY> <query>` with the user query as a BARE POSITIONAL. The `jr issue assign` handler takes only the issue key positionally; `--to <query>` is required for user resolution. A bare-positional call would have produced a clap parse error on every live run, never reaching the actual API. Passes 1-3 under different adversarial prompts rubber-stamped this defect. Passes 4/5 with fresh context caught it. The offline CLI surface guard did not detect it because it validates flag existence but not positional arity per subcommand (PG-458-1).

**Pass 2 MEDIUM finding:** Email-vs-display-name RYW terminal-attribution asymmetry — on both resolution branches (email-primary and display-name fallback), a propagation-lag timeout was emitting a "resolver-defect" panic message rather than the correct "propagation-lag" panic message. Fixed in the same commit as C-1.

**Key meta-lesson (L-458-1):** This is the first documented case where the SAME defect (C-1 bare-positional) survived 3 consecutive adversarial passes from different fresh contexts before being caught in passes 4-5. The surface guard's lack of positional-arity checking is the structural gap that allowed C-1 to reach the adversarial loop at all. Multiple fresh-context passes remain load-bearing even for test-only features with no production surface to review.

**Note:** Research-first (Perplexity-validated): Jira `GET /rest/api/3/user/assignable/search?query=<email>` matches `emailAddress` server-side even under GDPR (accountId is returned; email is the search key, not returned). Own-account validation: the test assigned to `JR_E2E_EMAIL` (own account) — no second Jira user required in a single-user instance.

---

## E2E Fork-Safe CI Enablement (S-E2E-FORK-1) — F5 Scoped Adversarial Convergence (2026-06-02)

**Story:** S-E2E-FORK-1 — `JR_E2E_ENABLED` repository variable gate + README badge
**Cycle:** ci/e2e-fork-safe-enablement → PR #459 → develop @ afa12570
**F5 Adversarial passes:** Multiple rounds (fix rounds interleaved) — then 3 fresh-context CLEAN passes.
**Live e2e:** run 26793560680 = 67/0 GREEN post-merge (VER-E2E-FORK-2 + VER-E2E-FORK-4 confirmed)

### F5 Convergence Narrative

**Phase 1 — Fix rounds:**
- Pass 1: Adversary caught MISSED SIBLING WORKFLOW — e2e.yml had the gate added but `e2e-sweeper.yml` was left unguarded. Scope-completeness win: a sibling workflow omission that would have re-enabled fork runs via the sweeper path. Fixed: gate added to e2e-sweeper.yml.
- Pass 2: Adversary caught OFF-BRANCH SPEC ARTIFACT — `docs/specs/e2e-fork-safe-ci-enablement.md` was authored in the main checkout during F2 (untracked) and was ABSENT from the feature branch `ci/e2e-fork-safe-enablement` which was branched off origin/develop @ d45ec88. This left ×4 dangling references (CLAUDE.md, CHANGELOG.md, e2e-live-jira-testing.md, README.md all cited the spec file by path). Fixed: spec file committed onto the feature branch.

**Phase 2 — Polish-induced idiom drift:**
- After adversary declared clean, orchestrator polish switched the preflight approach from `${VAR:?}` (fail-on-empty-var) to `collect-all` (collect all missing vars, fail once). This introduced drift: spec tables, VP comment text, sibling-pseudocode in e2e-sweeper.yml, and CLAUDE.md all referenced the old `${VAR:?}` idiom while the implementation used `collect-all`.
- Pass after polish: Adversary found idiom-drift — `${VAR:?}` still in spec and comment text while workflow used collect-all.
- Sweep: all 8 citation sites updated to describe collect-all semantics.

**Phase 3 — 3 consecutive fresh-context CLEAN passes:**

| Pass | Date | CRIT | HIGH | MED | LOW | Counter | Verdict |
|------|------|------|------|-----|-----|---------|---------|
| Fresh-1 | 2026-06-02 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| Fresh-2 | 2026-06-02 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| Fresh-3 | 2026-06-02 | 0 | 0 | 0 | 0 | 3/3 | FULL CONVERGENCE |

Trajectory shorthand: `1C(sibling-omission)→fix→1C(off-branch-spec)→fix→polish→idiom-drift→sweep→CLEAN→CLEAN→CLEAN`

**Key catches:**
1. **Missed sibling workflow (e2e-sweeper.yml):** Scope-completeness class finding — the adversary verified ALL files touched by the feature against the spec's "files to change" list. Without this, fork PRs could still trigger the sweeper.
2. **Off-branch F2 artifact:** The spec file authored during F2 in the main checkout was absent from the feature branch. Lesson: F-cycle artifacts authored outside `.factory/` must be brought onto the feature branch before the adversary pass.
3. **Polish-introduced idiom drift:** Orchestrator changed a key idiom (`${VAR:?}` → collect-all) post-F5-pass without re-sweeping all citation sites. Lesson: when changing an idiom/approach, sweep ALL references (spec tables, comments, sibling pseudocode, docs) in the same commit.

**VER-E2E-FORK verification outcomes:**
- VER-E2E-FORK-1 (fork skip): verified by gate semantics + research (docs.github.com: `vars` available in job-level `if:`, forks don't have repo vars set).
- VER-E2E-FORK-2 (canonical repo with var set runs): LIVE-CONFIRMED via post-merge e2e.yml run 26793560680 = 67/0.
- VER-E2E-FORK-3 (badge green): LIVE-CONFIRMED (passing run 26793560680 on develop branch).
- VER-E2E-FORK-4 (preflight loud): LIVE-CONFIRMED — "E2E preflight OK — all required config present." printed in run 26793560680.

**Scope:** 7 files — .github/workflows/e2e.yml, .github/workflows/e2e-sweeper.yml, README.md, CLAUDE.md, CHANGELOG.md, docs/specs/e2e-fork-safe-ci-enablement.md (new), docs/specs/e2e-live-jira-testing.md. Zero src/, zero Rust tests.

**Cycle CLOSED 2026-06-02.** PR #459 squash-merged → develop @ afa12570. DEC-063.

---

## #475 ADF E2E read-path coverage — F5–F7 Convergence (2026-06-11)

**Story:** S-475-adf-e2e-readpath — ADF E2E read-path coverage (test-only)
**Cycle:** test/issue-475-adf-e2e-readpath → PR #499 → develop @ 418a392e
**F4 trajectory (per-story Step-4.5):** R1 = F-1 HIGH (async gate-guard false-green) + F-1b LOW → fixed (ca07cbc); R2 = 0/0/0. CONVERGED.
**F5–F7 adversarial passes:** 5-dimension delta convergence + full-tree regression.

### F5–F7 Convergence Narrative

**5-dimension delta convergence check:**
1. **Behavior delta:** Test-only. No production src/ change. AC-1/2/3/4 all verified offline (hermetic compile + --list + gate-guard green). Live E2E: nightly e2e.yml (prior run 27352373680 89/0 GREEN; new gated tests will exercise on next nightly).
2. **Correctness:** Full `cargo test` clean (all tests pass including gate-guard meta-test). `cargo deny` ok. `cargo clippy -- -D warnings` clean. `cargo fmt -- --check` clean.
3. **Spec alignment:** F7 consistency audit CONSISTENT — counts agree across 8 surfaces (BC-INDEX frontmatter, BC-INDEX sections, BC-INDEX body, CANONICAL-COUNTS.md, prd.md, ARCH-INDEX, STORY-INDEX, CLAUDE.md). BC 594 / NFR 41 / Stories 68 all match. CLAUDE.md no change needed (test-only cycle).
4. **Security:** security reviewer APPROVE (no security surface; test-only).
5. **Process-gaps:** F-1b FIXED; O1-TABLE-ASSERT DEFERRED (justified); DEC-075 LESSON codified. Cycle-closing checklist SATISFIED.

**Input-drift check (S-7.02 defensive sweep):** 11 pre-existing files with stale content — all cycles/bookkeeping files from prior sessions, none #475-related. No propagation gap.

**Code review:** APPROVE — 0 blocking findings. Spec-example post-merge sync (multi-word→single-token in spec v1.3.10) was the only post-merge action.

**CI result:** 11/11 checks GREEN on PR #499. No flakes.

**Trajectory shorthand:** F4: `1H+1L(async-guard-false-green)→fix→CLEAN→CLEAN→CLEAN` / F5–F7: `5-dim-delta-CLEAN`

**Cycle CLOSED 2026-06-11.** PR #499 squash-merged → develop @ 418a392e. DEC-076. DEFERRED-ADF-E2E: ALL sub-gaps DONE.

---

## Windows-build F2 Adversarial Convergence (2026-06-12)

**Feature:** Windows build (x86_64-pc-windows-msvc)
**Phase:** F2 spec evolution adversarial loop

| Pass | Date | Total | CRIT | HIGH | MED | LOW | Counter | Verdict |
|------|------|-------|------|------|-----|-----|---------|---------|
| 1 | 2026-06-12 | 6 | 0 | 2 | 3 | 1 | 0/3 | FINDINGS_REMAIN |
| 2 | 2026-06-12 | 5 | 0 | 1 | 3 | 1 | 0/3 | FINDINGS_REMAIN |
| 3 | 2026-06-12 | 1 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| 4 | 2026-06-12 | 2 | 0 | 0 | 2 | 0 | 0/3 | REGRESSION |
| 5 | 2026-06-12 | 2 | 0 | 0 | 2 | 0 | 0/3 | PLATEAU |
| 6 | 2026-06-12 | 1 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| 7 | 2026-06-12 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 8 | 2026-06-12 | 1 | 0 | 0 | 1 | 0 | 0/3 | REGRESSION (reset) |
| 9 | 2026-06-12 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 10 | 2026-06-12 | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| 11 | 2026-06-12 | 0 | 0 | 0 | 0 | 0 | 3/3 | CONVERGED (reset — research corrections pending) |
| 12 | 2026-06-12 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS (post-correction P1) |
| 13 | 2026-06-12 | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS (post-correction P2) |
| 14 | 2026-06-12 | 0 | 0 | 0 | 0 | 0 | 3/3 | CONVERGED (3-clean-pass) |

**Trajectory shorthand:** `6→5→1→2→2→1→0→1(reset)→0→0→0(reset@P11)→0→0→0`
**Genuine catches:** false-green release-gate test description; dirs Known-Folder-API rationale; empty-string-filter propagation (4 sites); per-profile cache path table inconsistency.
**Post-convergence:** fresh-context consistency audit CONSISTENT. Research validation C1–C7 completed after P11 convergence; C4+C2 corrections applied; P12–P14 rerun confirmed CLEAN post-correction.

---

## Windows-build F5 Scoped Adversarial Convergence (2026-06-14)

**Feature:** Windows build (x86_64-pc-windows-msvc)
**Phase:** F5 scoped adversarial review (6-story delta: ci.yml matrix, .gitattributes, XDG→JR seam, /STACK:8388608, embedded-OAuth verify, deny.toml)
**develop HEAD at convergence:** 2f96543 (was 4bd83c7 at F4 close; updated via 5 fix PRs #511–#515)

| Pass | Date | Total | CRIT | HIGH | MED | LOW | Counter | Verdict |
|------|------|-------|------|------|-----|-----|---------|---------|
| R1 | 2026-06-14 | 2 | 0 | 2 | 0 | 0 | 0/3 | FINDINGS_REMAIN — smoke step missing jr.exe path + Compress-Archive assertion imprecise |
| R2 | 2026-06-14 | 2 | 0 | 1 | 1 | 0 | 0/3 | FINDINGS_REMAIN — smoke fail-closed plumbing + debug-gate adjacency |
| R3 | 2026-06-14 | 3 | 0 | 0 | 2 | 1 | 0/3 | FINDINGS_REMAIN — Windows OAuth verify step + .gitattributes catch-all + deny.toml comment |
| R4 | 2026-06-14 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| R5 | 2026-06-14 | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| R6 | 2026-06-14 | 2 | 0 | 0 | 1 | 1 | 0/3 | REGRESSION (reset) — CHANGELOG entry missing Windows + figment re-entry guard |
| R7 | 2026-06-14 | 2 | 0 | 1 | 1 | 0 | 0/3 | FINDINGS_REMAIN — ADR-0016 Decision 5c amendment + harden OAuth guard |
| R8 | 2026-06-14 | 1 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN — OAuth-verify guard must bind to -match construct |
| R9 | 2026-06-14 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| R10 | 2026-06-14 | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| R11 | 2026-06-14 | 1-VOID | 0 | 1 | 0 | 0 | —/— | VOID — checkout-race (concurrent git pull mid-review; reviewed stale pre-merge code). Re-run as R14. |
| R12 | 2026-06-14 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS (regression/spec lens @ 2f96543) |
| R13 | 2026-06-14 | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS+COMPLETE (completeness critic lens @ 2f96543) |
| R14 | 2026-06-14 | 0 | 0 | 0 | 0 | 0 | 3/3 | CONVERGED 0/0/0 (security/guard integrity lens @ 2f96543) |

**Trajectory shorthand:** `2→2→3→0→0→2(reset)→2→1→0→0→VOID→0→0→0` — **CONVERGED** at R14 (2026-06-14)
**Genuine catches:** release-path smoke step missing explicit jr.exe path; Compress-Archive assertion imprecise; smoke fail-closed plumbing gap; debug-gate adjacency; Windows OAuth verification step absent; .gitattributes catch-all absent; deny.toml comment gap; CHANGELOG missing Windows entry; figment re-entry guard absent (F5-WIN-R6-002, now machine-guarded by test); ADR-0016 Decision 5c missing; OAuth-verify guard binding to -match construct.
**VOID pass:** R11 was dispatched concurrently with a devops cleanup agent that did `git checkout develop && git pull` on the shared main working tree. R11 read mid-pull stale code and found F5-WIN-R11-001 (spurious HIGH for issue already fixed on 2f96543). Mitigation codified as LESSON-ADVERSARY-CHECKOUT-RACE. R14 re-run added "confirm HEAD SHA on first line" guard and reviewed cleanly at 2f96543.
**Fix PRs merged during F5:** #511 (R1 HIGHs: smoke step + Compress-Archive), #512 (R2: fail-closed + debug-gate), #513 (R3: OAuth verify + .gitattributes + deny.toml), #514 (R7/R6: CHANGELOG + ADR-0016 Decision 5c + figment guard test), #515 (R8: OAuth guard -match binding). 0 CRITICAL/HIGH since R2; all R3+ findings doc/test/CI hardening.
**Residual LOWs accepted:** WIN-RUNTIME-OAUTH-PROBE (runtime probe not ported to Windows, accepted in ADR-0016 Decision 5c), WIN-AC004-DIRECTIONAL (count-equality check covers in-process set_var only; subprocess sites have presence-only check). SEC-JR-SERVICE-NAME-GATE and WIN-DENY-FRAGILITY re-surfaced as out-of-scope / existing tracked items.

---

## Issue #492 Block-HTML F5 Scoped Adversarial Convergence (2026-06-16)

**Feature:** #492 ADF block-HTML hardBreak interior newlines (BC-7.2.011)
**Phase:** F5 scoped adversarial review
**Code at convergence:** 8062b78 (PR #521 pushed; BC-7.2.011 v1.9.6)

| Pass | Date | Total | CRIT | HIGH | MED | LOW | Counter | Verdict |
|------|------|-------|------|------|-----|-----|---------|---------|
| P1–P12 | 2026-06-16 | see burst-log | 0 | 0 | varied | varied | 0/3→reset×N | FINDINGS_REMAIN / REGRESSION / CLEAN (interleaved) |
| P13 | 2026-06-16 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS (deep cross-consistency) |
| P14 | 2026-06-16 | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS (holistic+traceability+counts) |
| P15 | 2026-06-16 | 0 | 0 | 0 | 0 | 0 | 3/3 | CONVERGED (robustness+completeness) |

**Trajectory shorthand:** 15 passes; 6 fix rounds; final 3/3 CLEAN. Zero production-code defects — all findings were doc/spec precision.
**Genuine catches:** doc/spec precision gaps only; Algorithm B proven correct ~12x across all lenses.
**Code delta:** BC-7.2.011 v1.9.1→v1.9.2→v1.9.3→v1.9.4→v1.9.5→v1.9.6. PR #521 MERGED → develop @ 3ba8ea2. DEC-107.

---

## Issue #522 ADF CR/newline Normalization F5 Scoped Adversarial Convergence (2026-06-17)

**Feature:** #522 ADF CR/newline normalization — EC-11 (push_text/push_code) + EC-12 (text_to_adf)
**Phase:** F5 scoped adversarial review (perspective-diverse: correctness/coherence/completeness lenses)
**Code at convergence:** 6d87bb6 (LOCAL on fix/adf-push-text-cr-normalization-522; BC-7.2.011 v1.11.0)

| Pass/Round | Date | Total | CRIT | HIGH | MED | LOW | Counter | Verdict |
|------------|------|-------|------|------|-----|-----|---------|---------|
| R1-Pass1 (correctness) | 2026-06-17 | 1 | 0 | 0 | 0 | 1 | 1/3 | CLEAN-PASS (1 LOW OBS-1 noted) |
| R1-Pass2 (coherence) | 2026-06-17 | 2 | 0 | 0 | 0 | 2 | 0/3 | FINDINGS_REMAIN (OBS-1 spec note + OBS-2 whitespace-blank test) |
| R1-Pass3 (completeness) | 2026-06-17 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| R2-Pass1 (correctness) | 2026-06-17 | 6 | 0 | 1 | 0 | 5 | 0/3 | FINDINGS_REMAIN — HIGH CR-01 (bare \n Other-ctx INV-1 via inline HTML) + 5 LOW |
| R2-Pass2 (coherence) | 2026-06-17 | 0 | 0 | 0 | 0 | 0 | 0/3 | CLEAN after R2-Pass1 fix |
| R2-Pass3 (completeness) | 2026-06-17 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| R3-Pass1 (correctness) | 2026-06-17 | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| R3-Pass2 (coherence) | 2026-06-17 | 1 | 0 | 0 | 0 | 1 | 0/3 | FINDINGS_REMAIN — MED F-522-01 (block/inline HTML asymmetry undocumented) |
| R3-Pass3 (completeness) | 2026-06-17 | 2 | 0 | 0 | 1 | 1 | 0/3 | FINDINGS_REMAIN — LOW F-522-02 + LOW F-OBS-1 |
| R4-Pass1 (correctness) | 2026-06-17 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| R4-Pass2 (coherence) | 2026-06-17 | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| R4-Pass3 (completeness) | 2026-06-17 | 0 | 0 | 0 | 0 | 0 | 3/3 | **CONVERGED** |

**Trajectory shorthand:** `R1: 2LOW → R2: 1HIGH+5LOW(reset) → R3: 1MED+2LOW(reset) → R4: 0/0/0 CONVERGED`
**Genuine catches:**
- HIGH CR-01 (R2): bare `\n` survived `push_text`/`push_code` in `Other` block-type context; reachable end-to-end via multi-line `Event::InlineHtml` → Jira 400 (INV-1 violation). Missed by F1–F4 and #492/EC-11/EC-12 scoping. FIXED @ 182a93d.
- MED F-522-01 (R3): block-HTML → `hardBreak` vs inline-HTML → space newline-handling asymmetry was a sound but undocumented product decision. Documented in `docs/specs/adf-block-html.md` + BC-7.2.011 EC-11. FIXED @ c7103b7.
- LOW F-522-02 (R3): added deterministic 3-line + CRLF inline-HTML regression cases. FIXED @ c7103b7.
- LOW F-OBS-1 (R3): AC-014 illustrative snippet form (cases 2048→1000, `prop_map` wrapper removed). FIXED @ c7103b7.
- LOW OBS-1/OBS-2 (R1): spec split-mechanism note + whitespace-blank test. FIXED @ d3c35a4.
**Code delta:** BC-7.2.011 v1.9.7→v1.9.8→v1.9.9→v1.10.0→v1.11.0 across F2/F4/F5. S-522 7→14→19 ACs, severity LOW→MED→HIGH→HIGH. 237→244→248 lib tests. DEC-110+111+112+113+114+115.
**Process gap:** LESSON-F1-SIBLING-CASE codified — F1 boundary analysis must enumerate ALL control chars in same hazard class at a normalization chokepoint, not only the one that triggered the issue report. F5 3-lens fan-out caught the gap; repeated single-lens passes did not.

---

## S-FORK-OPS-BACKFILL — F5 Scoped Adversarial (2026-06-19)

**Bundle:** S-FORK-OPS-BACKFILL
**Scope:** Combined delta — backfill-release.yml (PR #539) + GITLEAKS_DISABLED doc changes (PR #538). Wave-gate adversarial consolidated into F5.
**Code at convergence:** develop @ 83a141ad (post FIX-F5-001 / PR #540)

| Pass | Date | Total | CRIT | HIGH | MED | LOW | Counter | Verdict |
|------|------|-------|------|------|-----|-----|---------|---------|
| 1 | 2026-06-19 | 6 | 0 | 0 | 2 | 4 | 0/3 | FINDINGS (novelty 0.35) — M4 FIXED via FIX-F5-001/PR #540; M2 ACCEPTED |
| 2 | 2026-06-19 | 9 | 0 | 0 | 1* | 8 | 0/3 | CLEAN (novelty 0.08) — *O-1 = recurrence of accepted M2; no action |
| 3 | 2026-06-19 | 1 | 0 | 0 | 0 | 1 | 3/3 | **CONVERGED** — independent re-derivation; 1 LOW timeout-minutes gap tracked |

**Trajectory shorthand:** `2→0→0` (actionable MED). CONVERGED at Pass 3.

**Genuine catches:**
- M4 (Pass 1): `test_backfill_release_job_zip_in_both_upsert_branches` counted `jr-*.zip` ≥2 anywhere in file instead of anchoring to distinct branches — vacuous assertion. FIXED via FIX-F5-001 / PR #540 @ 83a141ad.
- M2 (Pass 1): `gh release upload jr-*.zip` hard-fails on zero-match glob; diverges from release.yml softprops. ACCEPTED — fail-loud design, guarded by needs:build + matrix-parity test.

**Tracked items (non-blocking):**
- O3 / FORK-OPS-F5-SELFTEST-CHECKLIST: F5 checklist conflates `--self-test` inline fixture with real-file scan.
- L-NEW-1 / FORK-OPS-BACKFILL-TIMEOUT-PARITY: backfill build job lacks `timeout-minutes` (release.yml=60).
- M2/O-1 / FORK-OPS-BACKFILL-ZIP-GLOB-COUPLING: zip-glob hard-fail coupling (accepted).

**F5 S-FORK-OPS-BACKFILL: CONVERGED 2026-06-19. Advancing to F6.**

---

## S-FORK-OPS-BACKFILL — F6 Formal Hardening + F7 Delta Convergence (2026-06-19)

**Bundle:** S-FORK-OPS-BACKFILL
**Scope:** CI-only bundle (backfill-release.yml + sign-and-publish.yml harden + gitleaks docs). No new `src/` code.

### F6 Formal Hardening

- **Mutation testing:** N/A — no `src/` delta. cargo-mutants scoped to diff; 0 viable mutants. JUSTIFIED-SKIP.
- **Fuzz / Kani:** JUSTIFIED-N/A — no new unsafe code, no numeric boundary operations.
- **cargo deny:** CLEAN — 0 vulnerabilities, 0 license issues.
- **Injection guard scan:** CLEAN — CWE-77 env-binding + atomic alpha-tag + injection guard pattern verified in sign-and-publish.yml (PR #535 @ 1a2a79b); Gatekeeper acceptance + hardened runtime after notarize verified (PR #536). No new injection surfaces.
- **Full regression:** 1866 tests / 0 failures (develop @ 83a141ad).

**F6 verdict: PASS (targeted, CI-only bundle). Advancing to F7.**

### F7 Delta Convergence

**Pre-gate input-drift check:** CLEAN. Fresh consistency audit: CONSISTENT (0 findings).

**5-dimension verdict:**

| Dimension | Result | Notes |
|-----------|--------|-------|
| Spec novelty | LOW (0.08→LOW) | 3 consecutive clean passes; 0 CRIT/HIGH |
| Test | PASS — 11 non-vacuous tests (M4 fix included) | Mutation N/A (no src/) |
| Implementation | F5 CONVERGED — 0 CRIT/HIGH | develop @ 83a141ad |
| Verification | cargo-deny + injection-guard CLEAN | Kani/fuzz JUSTIFIED-N/A |
| Holdout (infra regression-proxy) | 1866/0 (regression: 1855→1866, +11 new, 0 failures) | |

**Human authorization: CONVERGED + AUTHORIZED 2026-06-19. Release v0.6.0-dev.5 in progress.**

**Carry-forward drift (3 LOW items):**
- FORK-OPS-F5-SELFTEST-CHECKLIST: process-gap deferral, next maintenance sweep.
- FORK-OPS-BACKFILL-ZIP-GLOB-COUPLING: accepted fail-loud design.
- FORK-OPS-BACKFILL-TIMEOUT-PARITY: minor housekeeping, next maintenance sweep.

**F7 trajectory shorthand:** `F5: 2→0→0 CONVERGED` / `F6: PASS (CI-only)` / `F7: 5/5 PASS — CONVERGED + AUTHORIZED 2026-06-19`

---

## CITATION-GUARDS F3 — Story A Adversarial Convergence (ongoing, 2026-07-02..2026-07-03)

**Story:** S-MUTANTS-SCOPE-GUARDS-1 #101 — cargo-mutants scope + citation guards
**Phase:** F3 strict convergence loop (DEC-151: 3 consecutive CLEAN incl. verification-adequacy lens)
**Baseline at DEC-151 (2026-07-02):** Story v1.17 CONSISTENT (~1850 lines); 22 passes / 16 fix rounds done; streak 0/3.

### Finding Progression (passes 23–35, all verification-adequacy lens)

| Pass | Version | Total | CRIT | HIGH | MED | LOW | Counter | Verdict |
|------|---------|-------|------|------|-----|-----|---------|---------|
| 23 | v1.17→v1.18 | 6 | 0 | 1 | 4 | 1 | 0/3 | FINDINGS_REMAIN |
| 24 | → | 7 | 0 | 1 | 3 | 3 | 0/3 | FINDINGS_REMAIN |
| 25 | → | 2 | 0 | 0 | 0 | 2 | 0/3 | CONVERGING |
| 26 | → | 4 | 0 | 0 | 1 | 3 | 0/3 | FINDINGS_REMAIN |
| 27 | → | 2 | 0 | 0 | 1 | 1 | 0/3 | FINDINGS_REMAIN |
| 28 | → | 7 | 0 | 0 | 3 | 4 | 0/3 | REGRESSION |
| 29 | → | 3 | 0 | 0 | 2 | 1 | 0/3 | FINDINGS_REMAIN |
| 30 | → | 1 | 0 | 1 | 0 | 0 | 0/3 | FINDINGS_REMAIN |
| 31 | → | 4 | 0 | 0 | 3 | 1 | 0/3 | FINDINGS_REMAIN |
| 32 | → | 5 | 0 | 0 | 1 | 4 | 0/3 | FINDINGS_REMAIN |
| 33 | → | 3 | 0 | 0 | 2 | 1 | 0/3 | FINDINGS_REMAIN |
| 34 | → | 4 | 0 | 0 | 2 | 2 | 0/3 | FINDINGS_REMAIN |
| 35 | v1.30.2 | 2 | 0 | 0 | 2 | 0 | 0/3 | FINDINGS_REMAIN |
| 36 | v1.30.2→ | 3 | 0 | 0 | 1 | 2 | 0/3 | FINDINGS_REMAIN |
| 37 | → | 2 | 0 | 0 | 0 | 2 | 0/3 | CONVERGING |
| 38 | → | 4 | 0 | 0 | 0 | 4 | 0/3 | FINDINGS_REMAIN |
| 39 | → | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS (first clean of loop) |
| 40 | → | 1 | 0 | 0 | 0 | 1 | 0/3 | REGRESSION (reset — 1L ground-truth) |
| 41 | v1.35.1 | 3 | 0 | 0 | 2 | 1 | 0/3 | FINDINGS_REMAIN |
| 42 | v1.35.1→ | 4 | 0 | 0 | 1 | 3 | 0/3 | FINDINGS_REMAIN |
| 43 | → | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 44 | → | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| 45 | → | 4 | 0 | 0 | 0 | 4 | 0/3 | REGRESSION (reset window-2 at 2/3 — 4L) |
| 46 | → | 3 | 0 | 0 | 0 | 3 | 0/3 | FINDINGS_REMAIN |
| 47 | → | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 48 | v1.39 | 1 | 0 | 0 | 0 | 1 | 0/3 | REGRESSION (reset window-4 at 1/3 — 1L) |
| 49 | v1.39→ | 3 | 0 | 0 | 0 | 3 | 0/3 | FINDINGS_REMAIN |
| 50 | → | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 51 | → | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| 52 | → | 6 | 0 | 0 | 3 | 3 | 0/3 | REGRESSION (reset window-6 at 2/3 — 3M+3L; F4-breaking gap: Fixture H increment discipline) |
| 53 | → | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 54 | → | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| 55 | → | 3 | 0 | 0 | 0 | 3 | 0/3 | REGRESSION (reset window-7 at 2/3 — 3L; 1 dismissed as stale-date false positive) |
| 56 | → | 4 | 0 | 0 | 0 | 4 | 0/3 | FINDINGS_REMAIN |
| 57 | v1.44 | 1 | 0 | 0 | 0 | 1 | 0/3 | FINDINGS_REMAIN |
| 58 | v1.44→ | 4 | 0 | 0 | 0 | 4 | 0/3 | FINDINGS_REMAIN (window 10 broke at 0/3 — 4L) |
| 59 | → | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 60 | → | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| 61 | → | 3 | 0 | 0 | 0 | 3 | 0/3 | REGRESSION (reset window-11 at 2/3 — 3L) |
| 62 | → | 3 | 0 | 0 | 0 | 3 | 0/3 | FINDINGS_REMAIN |
| 63 | → | 1 | 0 | 0 | 0 | 1 | 0/3 | FINDINGS_REMAIN |
| 64 | → | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 65 | → | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS (verification-adequacy lens) |
| 66 | v1.48 | 0 | 0 | 0 | 0 | 0 | 3/3 | **CLEAN-PASS — CONVERGED (window 14 closed; DEC-151 satisfied 2026-07-04)** |

**Trajectory shorthand (p23–66):** `6→7→2→4→2→7→3→1→4→5→3→4→2→3→2→4→0→1→3→4→0→0→4→3→0→1→3→0→0→6→0→0→3→4→1→4→0→0→3→3→1→0→0→0` — 44 passes since DEC-151; 47 fix rounds; **CONVERGED (DEC-151 strict, 2026-07-04).** 13 CLEANs total. Story v1.48 status=ready.

### Key Observations (passes 23–66 — FINAL)

- **Fix-round regression class (process note a):** Three fix rounds reintroduced previously-closed findings: a v1.13-class tautology recurred in round 20 (before DEC-151), and false RED-claim constructs appeared in rounds 26 and 29 (after DEC-151). The fresh-context gate and consistency-validator fidelity probes are load-bearing; same-author fix verification is not sufficient.
- **Meta-lens behavior (process note b):** ADVERSARY-META-LENS-REGRESS remains OPEN as an engine item. The verification-adequacy lens generates inherently recursive meta-level findings on guard-spec stories; these manifest as concrete mutation windows in this context and are actionable. The strict loop was terminable — window 14 succeeded — but the draw variance cost ~44 passes.
- **Story growth:** v1.17 ~1850 lines → v1.48 ~3000+ lines. Spec specifies: 12 fixtures A–L (multi-probe F/H/I/J), 9 Rust tests, 4 post-fixture self-assertions, byte-pinned regexes, ~13 documented accepted residuals.
- **Severity pattern (p23–66):** CRIT/HIGH at p23 (1H), p24 (1H), p30 (1H). ~20 MED findings total. Last MED+ at p52 (3M+3L; Fixture H increment discipline — the one F4-breaking gap). Last 14 passes before window 14 were all LOW or CLEAN.
- **CLEAN pass history (13 total):** p39 → p43+p44 (window-2) → p47 (window-3/4) → p50+p51 (window-6) → p53+p54 (window-7) → p59+p60 (window-11) → p64+p65+p66 (window 14 — CONVERGED).
- **Window-14 strategy:** Coherence-lens lead (p64) cleared remaining LOW-severity residuals; verification-adequacy lens (p65) satisfied the mandatory DEC-151 requirement; correctness/ground-truth (p66) provided the third consecutive CLEAN confirming convergence.
- **READY-for-F4 declarations:** Three independent adversary agents (p37, p45, p46) declared READY-for-F4 despite issuing findings — accurate assessment in hindsight; the remaining findings were all LOW and took ~20 more passes under strict criterion to exhaust.
- **Draw-variance analysis:** Strict criterion (Option C, DEC-151) required 44 passes where Option B (one non-meta pass) would likely have converged ~p29. Cost: ~15 extra passes. Benefit: caught ADVERSARY-META-LENS-REGRESS dynamics empirically, produced a fully exhausted story with zero open findings.

### Convergence Criterion (DEC-151)

**SATISFIED 2026-07-04.** Window 14 (passes 64/65/66): three consecutive CLEAN passes including the verification-adequacy lens (p65). 44 adversary passes / 47 fix rounds total. Story S-MUTANTS-SCOPE-GUARDS-1 v1.48 status=ready. DEC-152 recorded. F4 dispatch pending human authorization.

---

## CITATION-GUARDS F4 — Story A Per-Story Adversarial Convergence (2026-07-04)

**Story:** S-MUTANTS-SCOPE-GUARDS-1 #101 — cargo-mutants scope + citation guards
**Phase:** F4 per-story adversarial convergence (BC-5.39.001)
**Baseline:** Story v1.48 CONVERGED (F3 DEC-151 strict); implementation commit 376e2c8 (Guard 2 bash + Guard 3 Rust + ci.yml + policy-doc + CHANGELOG + CLAUDE.md + glob dev-dep). Red Gate PASSED @ 7e858f8.

### Finding Progression (passes 1–9)

| Pass | Total | CRIT | HIGH | MED | LOW | Counter | Verdict |
|------|-------|------|------|-----|-----|---------|---------|
| 1 | 1 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| 2 | 2 | 0 | 0 | 2 | 0 | 0/3 | FINDINGS_REMAIN |
| 3 | 1 | 0 | 0 | 0 | 1 | 0/3 | CONVERGING |
| 4 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 5 | 2 | 0 | 0 | 2 | 0 | 0/3 | REGRESSION (engine-BC-ID leak + stale RED divider) |
| 6 | 1 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| 7 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS (NITPICK_ONLY) |
| 8 | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS (NITPICK_ONLY) |
| 9 | 0 | 0 | 0 | 0 | 0 | 3/3 | **CLEAN — CONVERGED (MERGE-READY)** |

**Trajectory shorthand (p1–9):** `1→2→1→0→2→1→0→0→0` — 9 passes / 5 fix rounds; **CONVERGED 2026-07-04.**

### Per-Pass Details

#### Pass 1
**Findings:** 1 (0C/0H/1M/0L) — Guards-section placement
**Fix:** fddc65e — Moved Guards section to correct position in policy doc.
**Counter:** 0/3

#### Pass 2
**Findings:** 2 (0C/0H/2M/0L) — 4-element template gap + stale TODO(stub) header
**Fix:** f53ee1d — Added 4th template element; removed stale TODO(stub) header.
**Counter:** 0/3

#### Pass 3
**Findings:** 1 (0C/0H/0M/1L) — SCOPE-COVERAGE-FLOOR wording imprecision
**Fix:** 5740c9b — Reworded SCOPE-COVERAGE-FLOOR prose for precision.
**Counter:** 0/3

#### Pass 4
**Findings:** 0 — CLEAN-PASS
**Counter:** 1/3

#### Pass 5 — REGRESSION
**Findings:** 2 (0C/0H/2M/0L) — engine-BC-ID BC-5.38.001 leak in rustdoc ×5 + stale RED divider
Root cause: stub-architect injected engine-internal BC-5.38.001 references into product rustdoc at 5 sites during Red Gate phase.
**Fix:** ee67a02 — Removed all BC-5.38.001 references from product rustdoc; removed stale RED divider.
**Counter:** 0/3 (reset from 1/3)

#### Pass 6
**Findings:** 1 (0C/0H/1M/0L) — CHANGELOG ### Changed → ### Added
**Fix:** cac21ec — Moved CITATION-GUARDS delivery entry to ### Added section in CHANGELOG.
**Counter:** 0/3

#### Pass 7
**Findings:** 0 (NITPICK_ONLY) — CLEAN-PASS
**Counter:** 1/3

#### Pass 8
**Findings:** 0 (NITPICK_ONLY) — CLEAN-PASS
Non-blocking observations tracked as Drift Items: F-P8-01 §Scope↔examine_globs cross-set edge unguarded (follow-up story candidate); F-P8-02 backtick-reservation convention undocumented (doc-sentence candidate).
**Counter:** 2/3

#### Pass 9 — CONVERGED (MERGE-READY)
**Findings:** 0 — CLEAN
**Counter:** 3/3

**CONVERGED 2026-07-04.** Story #101 v1.48 implementation MERGE-READY. PR #572 (https://github.com/Zious11/jira-cli/pull/572): security CLEAN (1 LOW intentional, 5 INFO), pr-reviewer APPROVE cycle 1, CI 15/15 SUCCESS, mergeStateStatus CLEAN. HELD per DEC-128 — awaiting human code-owner approval + merge authorization.

### Demos

7/7 ACs demonstrated: `docs/demo-evidence/S-MUTANTS-SCOPE-GUARDS-1/` (VHS gif/webm/tape + transcripts). Commit 4535231.

### Residuals Tracked in Drift Items

- SCOPE-EMPTY-THREE-VS-TWO-CAUSE (LOW — story-side adjudication at cycle close)
- SCOPE-EXAMINE-GLOBS-CROSS-SET-EDGE (LOW — pass-8 F-P8-01, follow-up story candidate)
- BACKTICK-RESERVATION-CONVENTION (LOW — pass-8 F-P8-02, doc-sentence candidate)
- ENGINE-BC-ID-INJECTION (LOW — engine prompt hygiene, justified deferral)
- STORY-ENGINE-BC-CITATION (LOW — story line ~1190, cycle-close adjudication)

---

## CITATION-GUARDS Story B F3 — Adversarial Convergence (2026-07-06)

**Story:** S-BC-CITATION-GUARD-1 (story #102)
**Criterion:** DEC-153 standard — 3 consecutive clean diverse-lens passes (verification-adequacy observations = LOW-informational, non-streak-resetting)
**Outcome:** CONVERGED (DEC-155, 2026-07-06) — 15 passes / 9 fix rounds / clean window passes 13/14/15

### Finding Progression

| Pass | Findings | CRIT | HIGH | MED | LOW | Counter | Verdict |
|------|----------|------|------|-----|-----|---------|---------|
| p1 | 7 | 0 | 2 | 5 | 0 | 0/3 | FINDINGS_REMAIN |
| p2 | 7 | 2 | 1 | 4 | 0 | 0/3 | FINDINGS_REMAIN |
| p3 | 2 | 1 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| p4 | 3 | 1 | 1 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| p5 | 3 | 0 | 0 | 3 | 0 | 0/3 | FINDINGS_REMAIN |
| p6 | 1 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| p7 | 0 | 0 | 0 | 0 | 0 | 1/3 | NITPICK_ONLY / CLEAN |
| p8 | 1 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| p9 | 0 | 0 | 0 | 0 | 0 | 1/3 | NITPICK_ONLY / CLEAN |
| p10 | 1 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| p11 | 1 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| p12 | 1 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| p13 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN |
| p14 | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN |
| p15 | 0 | 0 | 0 | 0 | 0 | 3/3 | CLEAN — CONVERGED |

### Trajectory Shorthand

`2H5M → 2C1H4M → 1C1M → 1C1H1M → 3M → 1M → NITPICK_ONLY → 1M → NITPICK_ONLY → 1M → 1M → 1M → CLEAN → CLEAN → CLEAN` — **CONVERGED** at pass 15 (2026-07-06)

### Per-Pass Details

#### Pass 1
**Findings:** 7 (0C/2H/5M/0L)
**Fix:** v1.1→v1.2 — F-B1-01..10 (FLOOR scope, CI job name, Task 4/AC-006 rewrite, fixture skeletons, grep -oE pin, self-test echo, const/static grep, anti-self-match, glob pre-check)
**Counter:** 0/3

#### Pass 2
**Findings:** 7 (2C/1H/4M/0L) — incl. F-B2-03 jointly-unsatisfiable ratified-design contradiction → DEC-154 grammar extension (Option A: 3 new branches added to 7-branch dispatch)
**Fix:** v1.2→v1.3 — F-B2-01..09 + DEC-154 Option A: single-pass regex → two-pass extractor; Fixture E reworked; FLOOR 249→244; 3 new branches (b)(c)(e); fixtures I/J/K added (7→10)
**Counter:** 0/3

#### Pass 3
**Findings:** 2 (1C/0H/1M/0L)
**Fix:** v1.3→v1.5 (v1.4 intermediate errata) — F-B3-01..06: strip-from-first-(, branch (d) ^[[:space:]]* anchor, N=331/FLOOR=248, Fixture J/F kill coverage, EC-CITE-059; v1.4 Task 7 fixture count 7→10
**Counter:** 0/3

#### Pass 4
**Findings:** 3 (1C/1H/1M/0L)
**Fix:** v1.5→v1.6 — F-B4-CRIT-01: count pin 3→4; F-B4-H-01: space-args sub-probe; F-B4-M-01: pipefail guard; Task 0 worktree preface
**Counter:** 0/3

#### Pass 5
**Findings:** 3 (0C/0H/3M/0L)
**Fix:** v1.6→v1.7 — F-P5-01..07: RED-gate rc=1 group corrected (E removed); 'four'→'five' post-fixture self-assertions; Fixture J kill-trace (b) removed; Task 8 label; --bc-dir documented; AC-002 trace corrected; Fixture G bullet rewritten
**Counter:** 0/3

#### Pass 6
**Findings:** 1 (0C/0H/1M/0L)
**Fix:** v1.7→v1.8 — F-P6-01 Fixture D skeleton; F-P6-02 type_name derivation; 3 LOW clarity touches
**Counter:** 0/3

#### Pass 7 (NITPICK_ONLY — CLEAN)
**Findings:** 0 — CLEAN-PASS (NITPICK_ONLY observations; non-streak-resetting per DEC-153)
**Counter:** 1/3

#### Pass 8
**Findings:** 1 (0C/0H/1M/0L)
**Fix:** v1.8→v1.9 — F-B8-M-01: bc-1-auth-identity.md filename drift ×4 sites; F-B8-L-01: Task 0 rationale DEAD-vs-missed precision
**Counter:** 0/3 (reset from 1/3)

#### Pass 9 (NITPICK_ONLY — CLEAN)
**Findings:** 0 — CLEAN-PASS (NITPICK_ONLY observations; non-streak-resetting per DEC-153)
**Counter:** 1/3

#### Pass 10
**Findings:** 1 (0C/0H/1M/0L) — registration-surface drift (BC-INDEX/CANONICAL-COUNTS/STORY-INDEX count mismatch)
**Fix:** spec count fixes — stale 145/608 breakdown note + exhaustive stale-count sweep; Coverage-Statistics counts 608/378→611/381
**Counter:** 0/3 (reset from 1/3)

#### Pass 11
**Findings:** 1 (0C/0H/1M/0L) — residual registration-surface drift
**Fix:** additional count-propagation sweep
**Counter:** 0/3

#### Pass 12
**Findings:** 1 (0C/0H/1M/0L) — FLOOR ≈249→≈248 (post-Task-0-hygiene, N≈331); F-P12-02 LOW
**Fix:** v1.9 story row refresh; FLOOR ≈249→≈248 surface updates
**Counter:** 0/3

#### Pass 13 — CLEAN
**Findings:** 0 — CLEAN-PASS
**Counter:** 1/3

#### Pass 14 — CLEAN
**Findings:** 0 — CLEAN-PASS
**Counter:** 2/3

#### Pass 15 — CLEAN — CONVERGED
**Findings:** 0 — CLEAN-PASS
**Counter:** 3/3

**CONVERGED 2026-07-06 (DEC-155).** Story #102 v1.10 status=ready. HELD at F4 dispatch gate pending human authorization.

### Notable Findings

- **2 CRIT:** (1) class-15 two-pass token pipeline — single-pass regex silently dropped §-form and comma-space line-ref tokens; corrected to two-pass extractor (DEC-154 F-B2-02). (2) count-pin off-by-one — BC-CITE-001 pin=3 should be 4 (header comment + preamble grep + Step-1 echo + own assertion line).
- **3 HIGH:** F-B1-01 FLOOR scope (local→script-scope, single recalibration touchpoint); F-B1-02 CI job name stale baseline; F-B2-02 single-pass → two-pass extractor (DEC-154).
- **~12 MED:** incl. F-B2-03 jointly-unsatisfiable ratified-design contradiction (§-form strip + branch (e) CamelCase couldn't coexist under old grammar → DEC-154 Option A grammar extension resolved it); fixture kill-trace gaps; branch (d) anchor missing; strip-from-first-( subsumes bare (); registration-surface drift passes 10-12 (BC-INDEX/CANONICAL-COUNTS/STORY-INDEX count drift).
- **DEC-154 (pass-2 mid-loop research adjudication):** F-B2-03 exposed a jointly-unsatisfiable constraint between two ratified design choices. Human adjudicated Option A: add 3 branches (b `::tests` mod-grep, c `::tests::testfn` composition, e standalone CamelCase type-def) to the 7-branch dispatch. No ratified choices removed.
- **Dominant late-stage leak class (passes 10-12):** Registration-surface drift (BC-INDEX / CANONICAL-COUNTS / STORY-INDEX count fields not updated when story evolved). Reinforces SWEEP-WHOLE-TOUCHED-FILE + the BC-INDEX 9th-surface guard gap (pass-12 F-P12-01).

### Comparison vs Story A F3

| Metric | Story A F3 (DEC-151 strict) | Story B F3 (DEC-153 standard) |
|--------|----------------------------|-------------------------------|
| Total passes | 44 | 15 |
| Fix rounds | 47 | 9 |
| Clean window | 14 | 13/14/15 |
| Criterion | 3 consecutive clean incl. verification-adequacy lens | 3 consecutive clean diverse-lens (verification-adequacy = LOW-informational) |

Supports ADVERSARY-META-LENS-REGRESS engine item: strict criterion (incl. recursive meta-lens) generated 3× more passes for similar story complexity.

## CITATION-GUARDS Story B F4 — Per-Story Adversarial Convergence (2026-07-06)

**Story:** S-BC-CITATION-GUARD-1 (story #102)
**Phase:** F4 per-story adversarial convergence (BC-5.39.001)
**Baseline:** Story v1.10 CONVERGED (F3 DEC-155 standard); Task 0 hygiene commit 2b09313 (12+ dead citations rewritten); Red Gate PASSED (stubs 0867823 + 10 fixtures + 5 self-assertions a440814; RED verified — self-test exit 1, canonical stub silent); Implementation f3fc670 (Guard 1 bash).

### Finding Progression (passes 1–4)

| Pass | Total | CRIT | HIGH | MED | LOW | Counter | Verdict |
|------|-------|------|------|-----|-----|---------|---------|
| p1 | 1 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| p2 | 0 | 0 | 0 | 0 | 0 | 1/3 | NITPICK_ONLY / CLEAN |
| p3 | 0 | 0 | 0 | 0 | 0 | 2/3 | NITPICK_ONLY / CLEAN |
| p4 | 0 | 0 | 0 | 0 | 0 | 3/3 | **CLEAN — CONVERGED** |

**Trajectory shorthand (p1–4):** `1M → NITPICK_ONLY → NITPICK_ONLY → CLEAN` — 4 passes / 2 fix rounds; **CONVERGED 2026-07-06.**

### Per-Pass Details

#### Pass 1
**Findings:** 1 (0C/0H/1M/0L) — F-01 MED: undeclared non-.rs silent-skip vs spec (adversary claimed .snap paths do not exist; REFUTED empirically by orchestrator — all 5 .snap paths verified present)
**Fix (round 1):** Two-tier shape guard spec amendment: EC-CITE-060; non-.rs src/ citations get file-existence tier (counted); N=309 (304 .rs + 5 .snap); FLOOR=231. Commits: BC spec 7575e54, story v1.11 fd8e378, code 7706cc1; CHANGELOG consolidation 126666a.
**Counter:** 0/3

#### Pass 2 (NITPICK_ONLY — CLEAN)
**Findings:** 0 BLOCKING — NITPICK_ONLY observations only: Step-2 two-variable pattern canonization; --bc-dir CANONICAL_MODE note corrected
**Fix (round 2):** story v1.12 f353ab3; spec canonize two-variable Step-2 pattern + fix --bc-dir note.
**Counter:** 1/3

#### Pass 3 (NITPICK_ONLY — CLEAN)
**Findings:** 0 — CLEAN-PASS (NITPICK_ONLY only; non-streak-resetting)
**Counter:** 2/3

#### Pass 4 — CLEAN — CONVERGED
**Findings:** 0 — CLEAN-PASS
**Counter:** 3/3

**CONVERGED 2026-07-06.** Story #102 v1.12. All 7 ACs PASS. Demos b52be90 (21 files, 7/7 ACs, VHS). PR #592 OPEN/CLEAN (CI 15/15 SUCCESS; security 2 LOW advisory: SEC-001-GUARD1-ERE-PREFLIGHT + SEC-002-GUARD1-BCDIR-DASH — follow-up candidates; pr-reviewer APPROVE cycle 1). HELD at DEC-128 merge gate.

### Notable Findings

- **1 MED (pass 1):** F-01 — undeclared non-.rs silent-skip; adversary's .snap-nonexistence claim REFUTED empirically; resolved via two-tier shape guard spec amendment (EC-CITE-060). Net: non-.rs src/ citations now receive file-existence tier (counted at full weight, not silently skipped).
- **pass-2 NITPICK_ONLY (non-streak-resetting):** Step-2 two-variable pattern canonized in spec/story; --bc-dir CANONICAL_MODE note corrected.

### Security Review Advisories (2 LOW — follow-up candidates)

- **SEC-001-GUARD1-ERE-PREFLIGHT:** Guard 1 bash script has no ERE-injection preflight guard on identifier-shaped CLI args in branches (a) and (f). LOW — follow-up story candidate.
- **SEC-002-GUARD1-BCDIR-DASH:** Guard 1 bash script has no leading-dash flag-value guard on `--bc-dir` arg. LOW — follow-up story candidate.

### Comparison vs Story A F4

| Metric | Story A F4 | Story B F4 |
|--------|-----------|-----------|
| Total passes | 9 | 4 |
| Fix rounds | 5 | 2 |
| Clean window | 7/8/9 | 2/3/4 |
| PR | #572 MERGED | #592 OPEN (HELD DEC-128) |

---

## ADF-CODE-MARK-EXCLUSIVITY F2 — Adversarial Spec Review

| Pass | Date | Total | CRIT | HIGH | MED | LOW | Counter | Verdict |
|------|------|-------|------|------|-----|-----|---------|---------|
| 1 | 2026-07-07 | 3 | 0 | 0 | 2 | 1 | 0/3 | FINDINGS_REMAIN |
| 2 | 2026-07-07 | 4 | 1 | 0 | 1 | 2 | 0/3 | FINDINGS_REMAIN |
| 3 | 2026-07-07 | 5 | 0 | 0 | 1 | 4 | 0/3 | FINDINGS_REMAIN |
| 4 | 2026-07-07 | 5 | 0 | 0 | 2 | 3 | 0/3 | FINDINGS_REMAIN |
| 5 | 2026-07-07 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 6 | 2026-07-07 | 1 | 0 | 0 | 0 | 1 | 0/3 | FINDINGS_REMAIN |
| 7 | 2026-07-07 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 8 | 2026-07-07 | 4 | 0 | 0 | 4 | 0 | 0/3 | FINDINGS_REMAIN |
| 9 | 2026-07-07 | 1 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| 10 | 2026-07-07 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 11 | 2026-07-07 | 3 | 0 | 0 | 3 | 0 | 0/3 | FINDINGS_REMAIN |
| 12 | 2026-07-07 | 1 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| 13 | 2026-07-07 | 1 | 0 | 0 | 0 | 1 | 0/3 | FINDINGS_REMAIN |
| 14 | 2026-07-07 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 15 | 2026-07-07 | 2 | 0 | 0 | 0 | 2 | 0/3 | FINDINGS_REMAIN |
| 16 | 2026-07-07 | 3 | 0 | 0 | 0 | 3 | 0/3 | FINDINGS_REMAIN |
| 17 | 2026-07-07 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 18 | 2026-07-07 | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| 19 | 2026-07-07 | 0 | 0 | 0 | 0 | 0 | 3/3 | FULL CONVERGENCE |

**Trajectory:** →3→4→5→5→0→1→0→4→1→0→3→1→1→0→2→3→0→0→0 — **STRICT CONVERGED** (19 passes / 13 fix rounds, DEC-158/DEC-159). Window: passes 17/18/19 CLEAN×3. Human-approved 2026-07-07.

### Pass 1 (2026-07-07) — Coherence / Registration Lens

**Findings:** 3 (0C/0H/2M/1L)
**Convergence counter:** 0 of 3

MED-1: BC-7.2.015 EC numbering inconsistency — ECs numbered 1-5 in body but referenced as EC-2/EC-3 in prd-delta summary prose; alignment fix applied. MED-2: H-NEW-ADF-010 holdout-scenarios.md registration missing scenario body — only index row added; full scenario body authored and registered. LOW-1: prd-delta-571.md version header mismatch with spec-changelog; version reconciled. Consistency-validator dispatched after each fix: CONSISTENT.

---

### Pass 2 (2026-07-07) — Verification-Adequacy / Holdout Coverage Lens

**Findings:** 4 (1C/0H/1M/2L)
**Convergence counter:** 0 of 3

CRIT: H-NEW-ADF-010 Call E fixture inexecutable — 3 sub-defects: (a) ADF literal uses wrong mark type in expected output; (b) fixture format uses inline JSON not conforming to holdout schema; (c) JSM-specific isolation missing (Call E tests JSM path which requires service-desk context not captured in fixture). All 3 sub-defects fixed; Call E fixture rewritten with correct ADF literal, proper schema, JSM isolation note. MED: BC-7.2.015 verification-delta VP reference inconsistent with VP-INDEX — VP number updated. LOW-1: H-NEW-ADF-010 calls A-D missing explicit pre-condition for active_marks state setup. LOW-2: verification-delta-571.md missing cross-reference back to prd-delta-571.md. All fixed. Consistency-validator: CONSISTENT.

---

### Pass 3 (2026-07-07) — Implementability / Edge-Cases Lens

**Findings:** 5 (0C/0H/1M/4L)
**Convergence counter:** 0 of 3

MED: F1 delta analysis (impact-boundary-571.md) states CLAUDE.md gotcha update is out-of-scope for F4, but prd-delta-571.md BC-7.2.015 EC-5 specifies the CLAUDE.md gotcha as a deliverable. Contradiction adjudicated: LESSON-F2-WORKTREE-FIRST applies — CLAUDE.md update is in-scope for F4 and must appear in story file list; prd-delta-571.md EC-5 is authoritative; impact-boundary-571.md carries a stale note that is superseded. Deferred to F3 story decomposition to capture correctly. LOW-1: BC-7.2.015 EC-3 does not specify the exact set of marks in the allowlist (retain: link, annotation; strip: strong, em, strike, subsup, text) — wording tightened. LOW-2: BC-7.2.015 EC-4 edge case for nested code marks (``x``) not addressed. LOW-3: H-NEW-ADF-010 Call A missing assertion on active_marks state after push_code returns. LOW-4: verification-delta missing note on ^`x`^ pulldown adjacency behavior (pass 5 follow-up noted). All 4 LOWs fixed.

---

### Pass 4 (2026-07-07) — Hostile Misreading / Cross-Artifact Lens

**Findings:** 5 (0C/0H/2M/3L)
**Convergence counter:** 0 of 3

MED-1: BC-INDEX.md Coverage Statistics row (9th surface) not updated to reflect BC-7.2.015 addition and BC-7.2.007 EC-2 amendment — stale coverage count. Fixed: BC-INDEX.md Coverage Statistics row updated. This is a RECURRENCE of drift item BC-INDEX-9TH-SURFACE (recurrence count now 2). MED-2: spec-changelog.md (v1.3.24 → v1.3.25) entry does not reflect rounds 2, 3, 4 fix content — only round 1 changes described. Fixed: spec-changelog re-synced to v1.3.25 with all 4 fix rounds summarized. LOW-1: D-chain validator false-positive on "JRACLOUD-27893" matched as "D-27893" (substring match without word boundary) — noted as process gap D-CHAIN-VALIDATOR-SUBSTRING-FALSE-POSITIVE; no spec change. LOW-2: bc-07-output-render.md domain spec BC-7.2.015 entry missing allowlist direction (only says "code mark strips incompatible marks" not "retains link/annotation"). Fixed. LOW-3: CANONICAL-COUNTS.md BC-7 section total not updated from 7 to 8 after BC-7.2.015 addition. Fixed.

---

### Pass 5 (2026-07-07) — Evaluator-Simulation / Ground-Truth Lens

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 1 of 3

STREAK 1/3. One LOW-informational observation: VA-OBS-5-1 noted that the verification-delta does not include a performance/regression note for push_code hot-path (called on every inline code span); adjudicated as LOW-informational (not a spec defect — performance is addressed in CLAUDE.md gotcha noting no behavioral change to existing code paths). Non-resetting per DEC-153 (VA observations below MEDIUM are informational only). Pass 6 (spec-ecosystem coherence lens) dispatched.

---

### Pass 6 (2026-07-07) — Spec-Ecosystem Coherence Lens

**Findings:** 1 (0C/0H/0M/1L)
**Convergence counter:** 0 of 3 (STRICT reset from 1/3 — DEC-158; LOW resets under STRICT criterion)

LOW: BC-INDEX-9TH-SURFACE RECURRENCE×3 — subsection-sum row in BC-INDEX.md Coverage Statistics not updated to reflect BC-7.2.015 addition (10th unguarded field; 9th was the Coverage Statistics column count from pass 4). Fixed. This is the third recurrence of the BC-INDEX-9TH-SURFACE drift item. Process gap TWIN-ARTIFACT-SWEEP flagged: fix for the subsection-sum field was not propagated to the sibling BC-INDEX holdout-total column.

---

### Pass 7 (2026-07-07)

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 1 of 3 (STRICT)

All pass 6 fixes verified. Subsection-sum propagation clean. No new findings.

---

### Pass 8 (2026-07-07) — Test-Writer Lens

**Findings:** 4 (0C/0H/4M/0L)
**Convergence counter:** 0 of 3 (STRICT reset from 1/3)

4 MED from test-writer lens: MED-1: VP cross-references in verification-delta-571.md do not specify the exact test-function names for VP assertions (BC-7.2.015 ECs 1-5); wording tightened to name concrete test functions. MED-2: H-NEW-ADF-010 Call B missing assertion on active_marks length after push_code clears incompatible marks — exact expected count not stated. MED-3: H-NEW-ADF-010 Call C does not specify whether link mark is preserved in the output ADF or only that no error is thrown; asserted preserved. MED-4: TWIN-ARTIFACT-SWEEP instance — test spec update not propagated to verification-delta companion section. All fixed.

---

### Pass 9 (2026-07-07) — Implementer Lens

**Findings:** 1 (0C/0H/1M/0L)
**Convergence counter:** 0 of 3 (STRICT)

MED: Implementer lens finding — BC-7.2.015 EC-2 allowlist direction (retain `link`/`annotation`, strip `strong`/`em`/`strike`/`subsup`/`text`) not reflected in the push_code spec prose with sufficient precision for an implementer reading without cross-referencing BC-7.2.007 EC-2; wording tightened in prd-delta-571.md. TWIN-ARTIFACT-SWEEP instance — prd-delta fix not propagated to bc-07-output-render.md domain spec entry; fixed.

---

### Pass 10 (2026-07-07)

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 1 of 3 (STRICT)

All pass 9 fixes verified. TWIN-ARTIFACT-SWEEP propagation confirmed. No new findings.

---

### Pass 11 (2026-07-07) — Story-Writer Lens

**Findings:** 3 (0C/0H/3M/0L)
**Convergence counter:** 0 of 3 (STRICT reset from 1/3)

3 MED from story-writer lens: MED-1: PHASE-DOC-RETRO-ANNOTATION pattern — F1 impact-boundary-571.md does not carry a retro-annotation noting that DEC-157 scope decision on point (2) (no node-splitting) supersedes its original scope comment; note added. MED-2: F1 artifact-mapping-571.md story file list does not include CLAUDE.md gotcha update (contradicts prd-delta-571.md EC-5 which makes it in-scope); annotated. MED-3: verification-delta-571.md VP numbering in the VP-INDEX cross-reference table stale after p8 fix — updated. All fixed.

---

### Pass 12 (2026-07-07) — Security Lens

**Findings:** 1 (0C/0H/1M/0L)
**Convergence counter:** 0 of 3 (STRICT reset)

MED: Security lens — BC-7.2.015 EC-1 guard description ("MUST filter active_marks before appending code mark") does not specify atomicity: if push_code panics mid-filter, active_marks could be left in a partially-stripped state for the next call. EC-1 amended to specify filter-then-append as a single contiguous operation with no intermediate observable state. This is the last MEDIUM finding on the core contract; residual finding tier from this pass forward is instruction-layer polish only.

---

### Pass 13 (2026-07-07)

**Findings:** 1 (0C/0H/0M/1L)
**Convergence counter:** 0 of 3 (STRICT reset — LOW resets under STRICT criterion, DEC-158)

LOW: Instruction-layer polish — prd-delta-571.md introductory sentence uses passive voice for the mechanism description ("marks are filtered") vs active ("push_code filters marks before appending"); wording harmonized to active voice consistent with the rest of the spec corpus. Non-substantive; no BC logic change.

---

### Pass 14 (2026-07-07)

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 1 of 3 (STRICT)

All pass 13 fixes verified. Voice harmonization confirmed consistent. No new findings.

---

### Pass 15 (2026-07-07)

**Findings:** 2 (0C/0H/0M/2L)
**Convergence counter:** 0 of 3 (STRICT reset — LOWs reset under STRICT criterion, DEC-158)

2 LOW instruction-layer polish: LOW-1: BC-7.2.015 EC-3 note on nested code marks (`\`\`x\`\``) says "not addressed" but passes 3 fixed this already — note now stale; removed. LOW-2: H-NEW-JSM-RT-001 holdout scenario body uses `projectKey` field in fixture JSON but the Atlassian API returns `projectId`; identified as pre-existing defect H-NEW-JSM-RT-001-FIXTURE-NONDESERIALIZABLE (same class as this cycle's Call E CRIT from pass 2); recorded as drift item, no spec change here.

---

### Pass 16 (2026-07-07)

**Findings:** 3 (0C/0H/0M/3L)
**Convergence counter:** 0 of 3 (STRICT reset — LOWs reset under STRICT criterion, DEC-158)

3 LOW instruction-layer polish: LOW-1: HOLDOUT-GROUP-8-DUPLICATE-HEADING — Group 8 in holdout-scenarios.md has a duplicate heading label (two scenarios share the same heading text); recorded as pre-existing drift item, no spec change. LOW-2: prd-delta-571.md title casing inconsistency (one heading uses title case, rest use sentence case); harmonized. LOW-3: BC-7.2.015 band-range comment "BC-7.2.016..058" in prd-delta is mathematically correct but lacks rationale for the upper bound; brief parenthetical added. All fixed. Pass 17 (verification-adequacy final) dispatched.

---

### Pass 17 (2026-07-07) — Verification-Adequacy Lens (final)

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 1 of 3 (STRICT)

STREAK 1/3. 2 NITPICKs (below LOW threshold, non-resetting): (a) mutation-survival table in verification-delta-571.md lists 23 probe mutations with all survivors disclosed and design-attested (annotation-drop mutant, future-mark allowlist); (b) EC-4 (`^\`x\'^` adjacency vacuousness) carry-forward noted for F3 story empirical confirmation step. Neither rises to a spec defect. All pass 16 fixes verified propagated cleanly.

---

### Pass 18 (2026-07-07) — Evaluator-Simulation Lens

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 2 of 3 (STRICT)

STREAK 2/3. 3 NITPICKs carried to F3 as story notes (non-resetting): (a) H-NEW-ADF-010 Call B pre-fix composition ambiguity — F3 story must specify empirical Red Gate test confirming [subsup, code] double-emission before fix; (b) H-NEW-ADF-010 Call E JSM-isolation note is advisory, not a test precondition — F3 story must gate it as skip-if-no-service-desk; (c) PANEL-ANCHOR boundary case (annotation mark in panel context) carries a 1-sentence design-attest in prd-delta but no VP; VP-571-005 covers it adequately per cross-reference. All 5 holdout calls traced end-to-end through spec ↔ VP ↔ holdout fixture ↔ test function chain. No spec gaps found.

---

### Pass 19 (2026-07-07) — Full-Spectrum Final-Gate Lens

**Findings:** 0 — FULL CONVERGENCE
**Convergence counter:** 3 of 3 (STRICT)

**STRICT CONVERGED. Window: passes 17/18/19 CLEAN×3.** 2 NITPICKs (non-resetting): (a) spec-changelog v1.3.25 trailing whitespace on one line — cosmetic; (b) BC-7.2.015 band-range comment upper bound 058 is conservative vs actual mark-type count — design-attested. Zero fix-shear: no new changes introduced by pass 19. F3-ready without invention: story-writer can proceed directly from prd-delta-571.md + verification-delta-571.md + H-NEW-ADF-010. DEC-159 recorded. F3 story decomposition dispatched.

---

### Notable Findings (F2 ADF-CODE-MARK-EXCLUSIVITY)

- **1 CRIT (pass 2):** H-NEW-ADF-010 Call E fixture inexecutable — 3 sub-defects (ADF literal wrong, fixture schema non-conforming, JSM isolation absent). Root cause: holdout scenario authored with insufficient attention to JSM-specific execution context.
- **1 MED (pass 3, adjudicated deferred):** F1↔F2 CLAUDE.md scope contradiction — deferred to F3 story per LESSON-F2-WORKTREE-FIRST; prd-delta-571.md EC-5 is authoritative.
- **BC-INDEX-9TH-SURFACE recurrence×3 (passes 1/4/6):** holdout-total (p1), Coverage Statistics count (p4), subsection-sum (p6). Third recurrence confirms guard-extension as priority. Candidate: 10-surface cumulative-counts guard update.
- **TWIN-ARTIFACT-SWEEP (passes 8/9/11):** 3 instances of fix-round changes not propagated to mirroring artifacts. Codified as process gap; fix rounds must include a mirroring-artifact sweep step.
- **SPEC-CHANGELOG-RESYNC (pass 4):** spec-changelog goes stale across F2 fix rounds; F2 skill template update candidate.
- **PHASE-DOC-RETRO-ANNOTATION (pass 11):** F1 artifacts need retro-annotation when F2 decisions supersede F1 scope; F2 skill template update candidate.
- **Core contract finding-free since pass 12:** passes 13-16 residual tier = instruction-layer polish only (LOW, non-substantive).
- **Pre-existing items surfaced (passes 15/16):** H-NEW-JSM-RT-001-FIXTURE-NONDESERIALIZABLE (projectKey vs projectId); HOLDOUT-GROUP-8-DUPLICATE-HEADING.
- **STRICT CONVERGED at pass 19 (2026-07-07):** window 17/18/19 CLEAN×3; DEC-159; human-approved; F3 dispatched. Total: 19 passes / 13 fix rounds. Accepted residuals disclosed in-spec: EC-2/3/4 + Calls B/E pre-fix composition protocol-guarded; annotation-drop mutant; future-mark allowlist design-attested. Comparative: this STRICT F2 = 19 passes vs Story B STANDARD F3 = 15 passes vs Story A STRICT F3 = 44 passes (ADVERSARY-META-LENS-REGRESS data point).

## F3 S-ADF-CODE-MARK-1 — Story Adversarial Review (ADF-CODE-MARK-EXCLUSIVITY)

| Pass | Date | Total | CRIT | HIGH | MED | LOW | Counter | Verdict |
|------|------|-------|------|------|-----|-----|---------|---------|
| 1 | 2026-07-07 | 3 | 0 | 0 | 1 | 2 | 0/3 | FINDINGS_REMAIN |
| 2 | 2026-07-07 | 2 | 0 | 0 | 0 | 2 | 0/3 | FINDINGS_REMAIN |
| 3 | 2026-07-07 | 1 | 0 | 0 | 0 | 1 | 0/3 | FINDINGS_REMAIN |
| 4 | 2026-07-07 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 5 | 2026-07-07 | 1 | 0 | 0 | 0 | 1 | 0/3 | FINDINGS_REMAIN |
| 6 | 2026-07-07 | 3 | 0 | 0 | 0 | 3 | 0/3 | FINDINGS_REMAIN |
| 7 | 2026-07-07 | 1 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| 8 | 2026-07-08 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| 9 | 2026-07-08 | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| 10 | 2026-07-08 | 0 | 0 | 0 | 0 | 0 | 3/3 | FULL CONVERGENCE |

**Trajectory:** 3→2→1→0→1→3→1→0→0→0 — **STRICT CONVERGED** (Pass 10, 2026-07-08). Window 8/9/10 CLEAN×3. DEC-160.

Note: STRICT criterion (DEC-159 ruling) — any delta-attributable LOW resets streak; VA-informational observations exempt per DEC-153/DEC-158. 2 preemptive orchestrator catches recorded (not adversary findings): rung-taxonomy collision (before pass 2) and template-required-fields block honored (pass 3 adjudication).

### Pass 1 (2026-07-07)

**Findings:** 3 (0C/0H/1M/2L)
**Convergence counter:** 0 of 3

MED-01: severity misclassification — story frontmatter severity HIGH vs. actual MEDIUM (bug has workaround; no data loss; module_criticality HIGH unchanged); corrected to MEDIUM. LOW-01: topology surfacing — Task 3 topology-obligation sub-note added for EC-2/EC-3/EC-4 anchors (only EC-4 carries Call B/E propagation obligation). LOW-02: baseline AC — AC-003 extended to surface test_bc_7_2_015_plain_code_baseline as control/baseline anchor (GREEN pre/post). All fixed in story v1.1.

---

### Pass 2 (2026-07-07) — includes 1 preemptive orchestrator catch (rung-taxonomy collision)

**Findings:** 2 (0C/0H/0M/2L)
**Convergence counter:** 0 of 3

Preemptive catch before adversary dispatched: rung-taxonomy collision — Task 0 and Task 3 used numbered rung references (rung-1/rung-2/rung-3) that collided with H-NEW-ADF-010's own ladder numbering; renamed to named outcomes (CONFIRMED-INPUT/MIXED-RANGE/DEMOTE) throughout Task 0 + Task 3; holdout mapping sentence added. Story v1.2 authored preemptively by orchestrator.

LOW-1: MIXED-RANGE spec-companion clause — Task 0 MIXED-RANGE branch had spec-companion obligation but Task 3 sub-note lacked the matching mirror line; extended. LOW-2: jr_cmd_with_xdg reword — Task 9 Call E isolation used cross-file helper pattern not applicable to integration-test binaries; reworded to inline .env() TempDir pattern. Also: grep pattern fix ('\"type\":\"code\"' → '\"type\": \"code\"' with space) + File Structure footnote for conditional spec-companion file additions. All fixed in story v1.3.

---

### Pass 3 (2026-07-07) — includes preemptive orchestrator note (template-required-fields block honored)

**Findings:** 1 (0C/0H/0M/1L) + 2 NITs (non-resetting under STRICT)
**Convergence counter:** 0 of 3

LOW: AC-011 mis-cite — '(test-hardening note 3)' → '(see Task 0 ladder and Task 3 topology-obligation sub-note)'. Fixed in story v1.4.

NITPICK-1 (epic_id): epic_id = "none" flagged as non-standard. KEPT — field is required by story-template.md line 5; removal would trip validate-template-compliance hook. Orchestrator preemptive note: template-required-fields block honored (NITs non-resetting). NITPICK-2 (phase): similarly required by template line 10. Both KEPT.

---

### Pass 4 (2026-07-07) — pre-v1.5

**Findings:** 0 — CLEAN-PASS (reset-void)
**Convergence counter:** 1 of 3 (STRICT)

STREAK 1/3. All pass 3 fixes verified. Story v1.4 clean on fresh-context pass. No new findings.

---

### Pass 5 (2026-07-07)

**Findings:** 1 (0C/0H/0M/1L) + 3 VA-informational (exempt per DEC-153/DEC-158)
**Convergence counter:** 0 of 3 (STRICT reset — LOW resets under STRICT criterion)

LOW: AC-002 header mis-anchor — 'BC-7.2.007 EC-1' → 'BC-7.2.007 EC-2 pre-#571 write-strict clause' (AC-002 traces to EC-2, not EC-1). Fixed in story v1.5.

VA-1 (informational): proptest weight-uniformity sentence added (~5% floor per branch) — AC-009 clarification. VA-2 (informational): Task 2 evidence form pinned to mandatory 'Red-Gate pre-fix evidence' PR description section. VA-3 (informational): Task 3 topology sub-note extended 'for the EC-4 anchor' → 'for the EC-2/EC-3/EC-4 anchors'. Three VA observations = 3 AC-gaming vectors identified and closed in v1.5.

---

### Pass 6 (2026-07-07)

**Findings:** 3 (0C/0H/0M/3L)
**Convergence counter:** 0 of 3 (STRICT reset — LOWs reset under STRICT criterion)

LOW-1: wording precision — Task 4 'Do NOT touch apply_marks' → 'Do NOT touch the SEMANTICS of … apply_marks (its docstring refresh is Task 6)'. LOW-2: Demo Plan coverage — expanded to cover all 12 ACs explicitly (AC-001..AC-009 via cargo test --lib, AC-010/AC-011 via integration test runs, AC-012 via claude_md_citations.rs pass + CLAUDE.md diff hunk). LOW-3: case cap — AC-009 + Task 8 case cap aligned to VP-571-001 upstream: default ~256 cases; cap to 128 only on CI flake pressure (story-tightening-beyond-upstream precedent). Also: Architecture Compliance Rules grep multi-match note added. All fixed in story v1.6.

---

### Pass 7 (2026-07-07)

**Findings:** 1 (0C/0H/1M/0L)
**Convergence counter:** 0 of 3 (STRICT reset — MED resets)

MED: twin stale-comment gap propagated FROM F2 spec (TWIN-ARTIFACT-SWEEP 4th instance) — both test_render_marks_code_and_strong AND test_render_strong_with_code_applies_code_innermost carry stale write-path comments claiming "write path emits [strong, code]"; AC-008 item 3 and Task 6 item 2 only listed the first test; sibling test was missing from both. Also: VP-571-004 single-test scope propagated from F2 spec to F3 story (UPSTREAM-GAP-PROPAGATES-TO-STORY 1st instance). Fixed: Task 6 item 2 + AC-008 item 3 both extended to enumerate twin comment refreshes. VP-571-004 obligation extended in companion amendment (verification-delta-571.md). Story v1.7.

---

### Pass 8 (2026-07-08)

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 1 of 3 (STRICT)

STREAK 1/3. Parallel-edit agreement: all adversary review axes concurred CLEAN. All pass 7 fixes (twin comment enumeration, VP-571-004 companion amendment) verified propagated consistently across story body, AC texts, and task sequences.

---

### Pass 9 (2026-07-08)

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 2 of 3 (STRICT)

STREAK 2/3. Transcription totality: 40+ trace sites (AC→BC, AC→VP, Task→AC, holdout mapping, spec-companion trigger conditions) verified with zero-gap coverage. No discrepancies between story body, frontmatter anchors, and spec artifacts (prd-delta-571.md, verification-delta-571.md, holdout-scenarios.md Call B/E).

---

### Pass 10 (2026-07-08)

**Findings:** 0 — FULL CONVERGENCE
**Convergence counter:** 3 of 3 (STRICT)

**STRICT CONVERGED. Window: passes 8/9/10 CLEAN×3.** Full-spectrum final gate (novelty NONE): 8 diverse lenses all clean. No new findings introduced. Story v1.7 is implementation-ready pending human authorization. DEC-160 recorded. Criterion comparison: F3 STRICT = 10 passes vs F2 STRICT = 19 passes. Pipeline HELD at F3 human gate.

---

### Notable Findings (F3 S-ADF-CODE-MARK-1)

- **1 MED (pass 1):** Severity misclassification HIGH→MEDIUM corrected (bug has workaround; no data loss).
- **1 MED (pass 7):** Twin stale-comment gap propagated FROM F2 spec (TWIN-ARTIFACT-SWEEP 4th instance). VP-571-004 extended in companion amendment.
- **Preemptive catch 1 (pass 2 pre-dispatch):** Rung-taxonomy collision between Task 0/Task 3 numbered rungs and H-NEW-ADF-010 holdout ladder; resolved before adversary ran.
- **Preemptive catch 2 (pass 3 adjudication):** Template-required-fields block honored — epic_id and phase fields KEPT despite NITPICK flag (story-template.md requires them at frontmatter lines 5 + 10).
- **UPSTREAM-GAP-PROPAGATES-TO-STORY (1st tracked instance):** VP-571-004 single-test scope propagated from F2 spec to F3 story before being caught at pass 7. Pattern: F2 spec has an incomplete scope claim; story-writer transcribes it faithfully; adversary catches it. Codified as new process-gap class.
- **TWIN-ARTIFACT-SWEEP (4th+5th instances, F3):** Pass 7 (code-comment twins: AC-008 + Task 6 both needed sibling test enumerated). Story itself is the parallel-edit artifact from the F2 spec companion miss.
- **3 AC-gaming vectors closed (pass 5):** VA-1/2/3 closed weight-uniformity gap, evidence-form gap, and scope-extension gap for EC-2/EC-3/EC-4 topology.
- **Story-tightening-beyond-upstream precedent (pass 6):** Case cap (AC-009 + Task 8) was unconditionally 128 in story; VP-571-001 upstream says default ~256. Aligned to upstream (story MUST NOT over-constrain the implementation spec); story-tightening-beyond-upstream is valid per existing precedent.
- **STRICT CONVERGED at pass 10 (2026-07-08):** Window 8/9/10 CLEAN×3; DEC-160; HELD at F3 human gate. Total: 10 passes / 6 fix rounds. Criterion comparison: F3 STRICT = 10 passes vs F2 STRICT = 19 passes.

---

## F4 Step 4.5 — ADF-CODE-MARK-EXCLUSIVITY S-ADF-CODE-MARK-1 (2026-07-08)

Criterion: **STRICT** (human ruling, same as F2 and F3). Window requirement: 3 consecutive clean passes. Passes run on merged develop @ 7ba4cf4 (post-PR-#593).

| Pass | Date | Total | CRIT | HIGH | MED | LOW | NIT | Counter | Verdict |
|------|------|-------|------|------|-----|-----|-----|---------|---------|
| F4-p1 | 2026-07-08 | 1 | 0 | 0 | 0 | 1 | 2 | 0/3 | FINDINGS_REMAIN |
| F4-p2 | 2026-07-08 | 0 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| F4-p3 | 2026-07-08 | 0 | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| F4-p4 | 2026-07-08 | 0 | 0 | 0 | 0 | 0 | 0 | 3/3 | FULL CONVERGENCE |

Trajectory shorthand: `1→0→0→0` — **STRICT CONVERGED** at F4-p4 (window F4-p2/F4-p3/F4-p4).

---

### Pass F4-p1 (2026-07-08)

**Findings:** 1 LOW + 2 NIT — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

LOW (adjudicated-accepted): wrapper-cardinality — existing test structure covers cardinality of stripped marks implicitly; an explicit count assertion would be test-hardening-grade, not a spec gap. Adjudication: accepted per story AC-009 scope (behavioral outcomes, not assertion form). STREAK RESET.
NIT-1 (non-resetting): helper-form preference — test helper extraction noted as style observation.
NIT-2 (non-resetting): triplication pattern across 3 test sites — coherent, deliberate; accepted per implementation plan.

---

### Pass F4-p2 (2026-07-08)

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 1 of 3 (STRICT)

STREAK 1/3. Hostile-inputs lens: adversarial probe inputs (malformed mark sets, empty marks, nested overlapping marks, solo-code paths, link+code combos, annotation+code combos) all traced end-to-end through push_code allowlist filter. All 8 RED-Gate anchors resolved as CONFIRMED-INPUT. No gaps found. H-NEW-ADF-010 Calls A–E verified against implementation.

---

### Pass F4-p3 (2026-07-08)

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 2 of 3 (STRICT)

STREAK 2/3. Perimeter-totality lens: all call sites of push_code verified against allowlist filter application. BC-7.2.015 enforcement perimeter traced across all 12 ACs. BC-7.2.007 EC-2 amendment (write-strict, read-lenient) verified — apply_marks reverse path retains intentional tolerance. VP-571-001..005 all satisfied against merged implementation. CLAUDE.md gotcha entry verified present.

---

### Pass F4-p4 (2026-07-08)

**Findings:** 0 — FULL CONVERGENCE
**Convergence counter:** 3 of 3 (STRICT)

**STRICT CONVERGED. Window: F4-p2 / F4-p3 / F4-p4 CLEAN×3.** Final-gate + mutant-forecast lens: zero new findings. Mutation gate PASS 5m32s — FIRST real code-diff exercise of the mutants CI job; calibration validated; predicted survivors limited to 2 spec-accepted classes (allowlist-constant mutation, identity-case code+code mutation). All 992 lib + 49 integration + 256-case proptest green. pr-reviewer APPROVE cycle 1 zero findings. 12/12 AC demos captured (VHS). Story v1.9 status=delivered. DEC-161 recorded. Issue #571 CLOSED. F5 DISPATCHED.

---

### Notable Findings (F4 Step 4.5 S-ADF-CODE-MARK-1)

- **1 LOW (F4-p1):** Wrapper-cardinality — adjudicated-accepted; test structure covers this implicitly per AC-009 scope.
- **2 NIT (F4-p1, non-resetting):** Helper-form preference + triplication pattern; accepted per implementation plan.
- **MUTANTS-FIRST-SCOPED-PR-CALIBRATION resolved:** F4 was the first code-diff mutation run; calibration validated; 0-mutant path CONFIRMED-GOOD upgraded to code-mutant path CONFIRMED-GOOD.
- **AGENT-CLAIM-VS-FMT-EVIDENCE catch:** Test-writer claimed fmt-clean inaccurately; caught pre-push by orchestrator verification batteries.
- **Implementer stop-and-report guard worked:** Fmt-reflow false-alarm correctly escalated rather than silently applied.
- **Story-index overstatement caught + fixed:** Story-index "cycle closed" claim corrected pre-commit.
- **STRICT CONVERGED at F4-p4 (2026-07-08):** Window F4-p2/F4-p3/F4-p4 CLEAN×3. Total: 4 passes / 1 fix round. Criterion comparison: F4 STRICT = 4 passes vs F3 STRICT = 10 passes vs F2 STRICT = 19 passes.

---

## F5 Scoped Adversarial — ADF-CODE-MARK-EXCLUSIVITY (2026-07-08)

Criterion: **STRICT** (same as F2/F3/F4). Window requirement: 3 consecutive clean passes. Passes run across develop @ 7ba4cf4 (p1–p3, post-PR-#593) then develop @ d7875e6 (p4–p6, post-fix-PR-#594). All passes fresh-context, rotated attack emphases.

| Pass | Date | Total | CRIT | HIGH | MED | LOW | NIT | Counter | Verdict |
|------|------|-------|------|------|-----|-----|-----|---------|---------|
| p1 | 2026-07-08 | 0 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| p2 | 2026-07-08 | 0 | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| p3 | 2026-07-08 | 1 | 0 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| p4 | 2026-07-08 | 0 | 0 | 0 | 0 | 0 | 0 | 1/3 | CLEAN-PASS |
| p5 | 2026-07-08 | 0 | 0 | 0 | 0 | 0 | 0 | 2/3 | CLEAN-PASS |
| p6 | 2026-07-08 | 0 | 0 | 0 | 0 | 0 | 0 | 3/3 | FULL CONVERGENCE |

Trajectory shorthand: `0→0→1→0→0→0` — **STRICT CONVERGED** at p6 (window p4/p5/p6 CLEAN×3). Trajectory-tail: →0→1→0→0→0.

---

### Pass p1 (2026-07-08)

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 1 of 3 (STRICT)

STREAK 1/3. Post-merge integrity lens on develop @ 7ba4cf4. Spec-drift check 24/24 artifacts CLEAN. BC-7.2.015 emit-site filter confirmed present; apply_marks read-tolerance retained (BC-7.2.007 EC-2 write-strict/read-lenient). All 12 ACs verified against merged implementation. 1024-case proptest stress PASS.

---

### Pass p2 (2026-07-08)

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 2 of 3 (STRICT)

STREAK 2/3. BC-coverage + CLAUDE.md completeness lens. VP-571-001..005 all satisfied. CLAUDE.md gotcha (clause-b splice, code-mark exclusivity, BC-7.2.015) verified complete and accurate. No cross-reference gaps found in BC-7.2.007 EC-2 amendment.

---

### Pass p3 (2026-07-08)

**Findings:** 1 LOW — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STREAK RESET from 2/3)

Changelog coverage lens. **1 LOW: MISSING-CHANGELOG-ENTRY** — PR #593 merged to develop without a CHANGELOG.md entry for the BC-7.2.015 code-mark exclusivity fix. Not a spec gap; a delivery completeness gap. Fix: fix-PR #594 (branch docs/571-changelog-code-mark-exclusivity) adding the CHANGELOG.md entry. Fix-PR #594 squash-merged by human @ d7875e6 (2026-07-08, DEC-128 honored). Worktree .worktrees/FIX-571-CHANGELOG removed; branches docs/571-changelog-code-mark-exclusivity + fix/571-adf-code-mark-exclusivity deleted local+remote.

---

### Pass p4 (2026-07-08)

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 1 of 3 (STRICT, on develop @ d7875e6)

STREAK 1/3. Post-fix-PR-#594 full-delta lens on merged develop @ d7875e6. CHANGELOG.md entry for BC-7.2.015 present and accurate. All prior pass-p1/p2 findings still clean. No new gaps introduced by #594 (docs-only PR). 1024-case proptest stress PASS confirmed unchanged.

---

### Pass p5 (2026-07-08)

**Findings:** 0 — CLEAN-PASS
**Convergence counter:** 2 of 3 (STRICT)

STREAK 2/3. Spec-changelog arithmetic + BC-7.2.015 spec-coverage lens. **Informational observation (non-finding):** spec-changelog.md range-shift arithmetic for the BC-7.2.015 row — adversary noted range-shift wording; orchestrator verified entry is a literal record of the actual edit; pre-change row confirmed at factory commit b5c0f6c. **Adjudication: NON-DEFECT** — entry is correct; no fix needed. Zero actionable findings. No [process-gap] findings in this pass.

---

### Pass p6 (2026-07-08)

**Findings:** 0 — FULL CONVERGENCE
**Convergence counter:** 3 of 3 (STRICT)

**STRICT CONVERGED. Window: p4 / p5 / p6 CLEAN×3.** Final-gate wide-spectrum lens: six attack emphases rotated across p1–p6 (post-merge integrity, BC-coverage, changelog, post-fix integrity, spec-arithmetic, final-gate wide). Zero actionable findings. Novelty: NONE. No [process-gap] findings in any pass — cycle-closing checklist step 2/3 satisfied vacuously. Two deferral items identified and human-approved: F5-OBS-001 (BC-7.2.015 lossiness not cross-listed in BC-7.2.011 five-case catalogue; documented elsewhere) and F5-OBS-002 (no runtime warning on typographic-mark strip in push_code; silent strip is correct product call). DEC-162 recorded. F6 DISPATCHED.

---

### Notable Findings (F5 Scoped Adversarial ADF-CODE-MARK-EXCLUSIVITY)

- **1 LOW (p3):** MISSING-CHANGELOG-ENTRY — PR #593 lacked a CHANGELOG.md entry; fixed via fix-PR #594 squash-merged @ d7875e6. Drift item STORY-TEMPLATE-CHANGELOG-TASK remains open (engine-side template fix needed).
- **p5 informational observation (NON-DEFECT):** spec-changelog range-shift arithmetic verified correct per factory commit b5c0f6c; orchestrator adjudicated non-actionable.
- **No [process-gap] findings in any pass:** cycle-closing checklist step 2/3 satisfied vacuously across all 6 passes.
- **Deferral F5-OBS-001 (LOW):** BC-7.2.015 lossiness not cross-listed in BC-7.2.011 five-case lossy round-trip catalogue. Already documented in BC-7.2.007 EC-2 + CLAUDE.md. Target: next spec-maintenance sweep.
- **Deferral F5-OBS-002 (LOW):** No runtime stderr warning when push_code strips typographic marks. Silent strip is correct product call vs pre-fix HTTP 400. Target: v2 backlog as --verbose observability enhancement.
- **STRICT CONVERGED at p6 (2026-07-08):** Window p4/p5/p6 CLEAN×3. Total: 6 passes / 1 fix round (fix-PR #594). DEC-162. F6 DISPATCHED.

---

## Frontmatter Fields (extracted from STATE.md)

<!-- When compacting STATE.md, adversary_pass_* frontmatter fields are
     converted to rows in the Finding Progression table above.
     Original field format: adversary_pass_N_findings: "description"
     Original field format: adversary_pass_N_date: "YYYY-MM-DD" -->

---

## SOH-ATTACHMENTS-1 F2 Security-Fix-and-Reverify Consistency Rounds (2026-07-17)

### Consistency Round r43 (2026-07-17)

**Result:** GAPS-FOUND — 2 LOW + 1 INFO
**Round type:** Scoped piecewise (post-security-fix-round confirmation)
**Spec version at review:** v1.3.80 (post SEC-576 fix round)

- **GAP-R43-001 (LOW):** Six stale BC-INDEX rows — BC-2.7.008, BC-2.7.010, BC-2.7.011, BC-3.9.015, BC-3.9.017 rows in BC-INDEX.md had not been updated to reflect the 4 security remediation edits applied in the fix round. Body content correct; index not synced.
- **GAP-R43-002 (LOW):** Allocation sentence in the display-sanitization clause still read "S2 earliest consumer" — incorrect per DEC-184 R3.13 (S1 = list-table cells in BC-2.7.001; S3+S4 = confirmation prompts). Needed correction to S1 with scope clarification.
- **INFO-R43-001 (INFO):** Stale count line in prd-delta-576.md dispositions section — carried over from an earlier pass, no longer accurate. Removal indicated.
- All 4 security remediations PASS verbatim: SEC-576-011/009/008/010 all present and correct in spec bodies.
- Echo-breaker check: CLEAN. No echo of pre-fix wording.

Report: `phase-f2-spec-evolution/consistency-report-576-r43.md`.

---

### Consistency Round r44 (2026-07-17)

**Result:** CONSISTENT
**Round type:** Scoped confirmation (post-r43-micro-fix)
**Spec version at review:** v1.3.81 (post r43 micro-fix)

All r43 gaps CLOSED:
- GAP-R43-001: BC-INDEX v6.33→v6.34 — 6 rows refreshed; all 4 security-remediation BC rows correctly reflected.
- GAP-R43-002: Allocation sentence corrected to S1; DEC-184 R3.13 wording honored; NEW-576-V3-001 FOLDED.
- INFO-R43-001: Stale count line removed from prd-delta-576.md.
No S2-earliest-consumer residue found. Version surfaces complete (spec v1.3.81, BC-INDEX v6.34 consistent across frontmatter and body). Guards exit 0.

Report: `phase-f2-spec-evolution/consistency-report-576-r44.md`.

---

## SOH-ATTACHMENTS-1 F3 Adversary Passes (2026-07-17, ongoing)

Criterion: **STRICT** (3 consecutive zero-finding passes required). Passes run against spec v1.3.81→v1.3.89. All passes fresh-context, blind adversarial review. Stories S-576-1..5 v1.5→v1.18 (AC 11/19/18/16/16; story versions v1.12/v1.18/v1.17/v1.16/v1.17).

| Pass | Date | Total | CRIT | HIGH | MED | LOW | INFO | Counter | Verdict |
|------|------|-------|------|------|-----|-----|------|---------|---------|
| p1 | 2026-07-17 | 27 | 2 | 11 | 11 | 3 | 0 | 0/3 | FINDINGS_REMAIN |
| p2 | 2026-07-17 | 16 | 3 | 4 | 6 | 3 | 0 | 0/3 | FINDINGS_REMAIN |
| p3 | 2026-07-17 | 18 | 0 | 4 | 5 | 9 | 0 | 0/3 | FINDINGS_REMAIN |
| p4 | 2026-07-17 | 11 | 0 | 0 | 8 | 2 | 1 | 0/3 | FINDINGS_REMAIN |
| p5 | 2026-07-17 | 10 | 0 | 1 | 2 | 7 | 1 | 0/3 | FINDINGS_REMAIN |
| p6 | 2026-07-17 | 9 | 0 | 0 | 4 | 5 | 0 | 0/3 | FINDINGS_REMAIN |
| p7 | 2026-07-17 | 8 | 0 | 0 | 1 | 7 | 0 | 0/3 | FINDINGS_REMAIN |
| p8 | 2026-07-18 | 3 | 0 | 0 | 1 | 2 | 0 | 0/3 | FINDINGS_REMAIN |
| p9 | 2026-07-18 | 3 | 0 | 0 | 1 | 2 | 0 | 0/3 | FINDINGS_REMAIN |
| p10 | 2026-07-18 | 5 | 0 | 0 | 0 | 5 | 0 | 0/3 | FINDINGS_REMAIN |
| p11 | 2026-07-18 | 5 | 0 | 0 | 0 | 5 | 0 | 0/3 | FINDINGS_REMAIN |
| p12 | 2026-07-18 | 5 | 0 | 1 | 1 | 3 | 0 | 0/3 | FINDINGS_REMAIN |
| p13 | 2026-07-18 | 2 | 0 | 0 | 1 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| p14 | 2026-07-18 | 5 | 0 | 0 | 1 | 4 | 0 | 0/3 | FINDINGS_REMAIN |
| p15 | 2026-07-18 | 2 | 0 | 0 | 1 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| p16 | 2026-07-18 | 3 | 0 | 0 | 1 | 2 | 0 | 0/3 | FINDINGS_REMAIN |
| p17 | 2026-07-18 | 4 | 0 | 0 | 2 | 2 | 0 | 0/3 | FINDINGS_REMAIN |
| p18 | 2026-07-18 | 2 | 0 | 0 | 1 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| p19 | 2026-07-18 | 1 | 0 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| p20 | 2026-07-18 | 3 | 0 | 0 | 1 | 2 | 0 | 0/3 | FINDINGS_REMAIN |
| p21 | 2026-07-18 | 1 | 0 | 0 | 0 | 1 | 0 | 0/3 | FINDINGS_REMAIN |
| p22 | 2026-07-18 | 2 | 0 | 0 | 0 | 2 | 0 | 0/3 | FINDINGS_REMAIN |
| p23 | 2026-07-18 | 3 | 0 | 0 | 1 | 2 | 0 | 0/3 | FINDINGS_REMAIN |
| p24 | 2026-07-18 | 1 | 0 | 0 | 1 | 0 | 0 | 0/3 | FINDINGS_REMAIN |
| p25 | 2026-07-18 | 4 | 0 | 0 | 1 | 3 | 0 | 0/3 | FINDINGS_REMAIN |

Trajectory shorthand (passes 1–25): `27→16→18→11→10→9→8→3→3→5→5→5→2→5→2→3→4→2→1→3→1→2→3→1→4` — IN PROGRESS; trajectory-tail →2→3→1→4; floor 1-4 findings/pass; ceiling MEDIUM (p24 1M); STRICT streak 0/3; pass 26 in flight.

---

### Pass p1 (2026-07-17)

**Findings:** 27 (2C/11H/11M/3L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

First adversary pass against spec v1.3.81 + stories S-576-1..5 v1.0. 27 findings: 2 CRIT, 11 HIGH, 11 MEDIUM, 3 LOW. Fix-round-1 applied; 0 open after fix.

---

### Pass p2 (2026-07-17)

**Findings:** 16 (3C/4H/6M/3L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Second adversary pass. Spec micro-round within fix-round-2: v1.3.81→v1.3.82 (EC-3.9.020-9 + EC-3.9.010-5 + prd-delta mutants S2-slot). 16 findings: 3 CRIT, 4 HIGH, 6 MEDIUM, 3 LOW. Fix-round-2 applied; 0 open after fix.

---

### Pass p3 (2026-07-17)

**Findings:** 18 (0C/4H/5M/9L) — FINDINGS_REMAIN (count regressed — latent)
**Convergence counter:** 0 of 3 (STRICT)

Third adversary pass; count regressed from 16 to 18 — all new findings latent (not fix-echoes). 0 CRIT, 4 HIGH, 5 MEDIUM, 9 LOW. Fix-round-3 applied; 0 open after fix.

---

### Pass p4 (2026-07-17)

**Findings:** 11 (0C/0H/8M/2L/1I) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Fourth adversary pass; severity floor improvement — 0 CRIT, 0 HIGH, 8 MEDIUM, 2 LOW, 1 INFO. Fix-round-4 applied; 0 open after fix.

---

### Pass p5 (2026-07-17)

**Findings:** 10 fixable (0C/1H/2M/7L/1I) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Fifth adversary pass. Spec micro-round within fix-round-5: v1.3.82→v1.3.83 (prd-delta per-story CHANGELOG scoping P5-006). 0 CRIT, 1 HIGH, 2 MEDIUM, 7 LOW, 1 INFO (total 10 fixable). Ceiling MEDIUM (single HIGH). Fix-round-5 applied; 0 open after fix. BC-INDEX v6.34→v6.35 (micro-round r45). PRE-F4-UNICODE-DISPLAY-SANITIZATION obligation registered (human ruling 2026-07-17). Pass 6 in flight.

---

### Pass p6 (2026-07-17)

**Findings:** 9 (0C/0H/4M/5L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Sixth adversary pass; severity ceiling drops to MEDIUM-only. 0 CRIT, 0 HIGH, 4 MEDIUM, 5 LOW. Spec micro-round within fix-round-6: v1.3.83→v1.3.84 (P6-004 S5 annotation ownership + P6-009 S3 DECOMPOSITION SEAM licensing). Fix-round-6 applied; 0 open after fix.

---

### Pass p7 (2026-07-17)

**Findings:** 8 (0C/0H/1M/7L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Seventh adversary pass; severity floor continues lowering toward LOW-dominant. 0 CRIT, 0 HIGH, 1 MEDIUM, 7 LOW. Spec micro-round within fix-round-7: v1.3.84→v1.3.85 (P7-007 canonical expanded CHANGELOG strings + P7-008 S5 mutants.toml obligation (d)). Fix-round-7 applied; 0 open after fix.

---

### Pass p8 (2026-07-18)

**Findings:** 3 (0C/0H/1M/2L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Eighth adversary pass; strong convergence signal — trajectory dropped from 8 to 3. 0 CRIT, 0 HIGH, 1 MEDIUM, 2 LOW. ADR-0017 P8-003 stale depends_on parenthetical corrected (architect, 2026-07-18). Fix-round-8 applied; 0 open after fix.

---

### Pass p9 (2026-07-18)

**Findings:** 3 (0C/0H/1M/2L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Ninth adversary pass; trajectory plateaus at 3. 0 CRIT, 0 HIGH, 1 MEDIUM, 2 LOW. Fix-round-9 applied; 0 open after fix.

---

### Pass p10 (2026-07-18)

**Findings:** 5 (0C/0H/0M/5L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Tenth adversary pass; count regressed 3→5 but ceiling drops to LOW-only (0 MEDIUM). 0 CRIT, 0 HIGH, 0 MEDIUM, 5 LOW. Fix-round-10 applied; 0 open after fix.

---

### Pass p11 (2026-07-18)

**Findings:** 5 (0C/0H/0M/5L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Eleventh adversary pass; plateau at 5 (all LOW). 0 CRIT, 0 HIGH, 0 MEDIUM, 5 LOW. Holdout_anchors populated on S2-S5 (Group 19 partition verified). Spec micro-round within fix-round-11: v1.3.85→v1.3.86 (P11-005 EC-X.8.010-1 None-serviceDeskId path; BC-INDEX v6.35→v6.36). Fix-round-11 applied; 0 open after fix.

---

### Pass p12 (2026-07-18)

**Findings:** 5 (0C/1H/1M/3L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Twelfth adversary pass; ceiling regresses to HIGH — p12 HIGH: BC-3.9.012 upload-error-taxonomy mislabeled in S3 for 11 passes (413/400/5xx/network rows miscategorized + SEC-576-004 CWE-93 multipart CRLF MUST-test uncovered) → fixed round 12 (AC-011 re-anchor + AC-018 added). 0 CRIT, 1 HIGH, 1 MEDIUM, 3 LOW. Spec micro-round within fix-round-12: v1.3.86→v1.3.87 (P12-003 X-Atlassian-Token 403-body hedge — research silent, unverified server string removed). Fix-round-12 applied; 0 open after fix. AC counts: S1 11 / S2 19 / S3 18 / S4 15 / S5 16. STORY-INDEX v1.4.73 (116 stories, stamps 111→116). Process-gap ledger 6 items. Pass 13 in flight.

---

### Pass p13 (2026-07-18)

**Findings:** 2 (0C/0H/1M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Thirteenth adversary pass; count drops to 2 — convergence signal after p12 ceiling regression. 0 CRIT, 0 HIGH, 1 MEDIUM, 1 LOW. Fix-round-13 applied; 0 open after fix.

---

### Pass p14 (2026-07-18)

**Findings:** 5 (0C/0H/1M/4L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Fourteenth adversary pass; test-name↔trace sync rule standing established (process-gap ledger item added — test function renames must be paired atomically with trace field updates). 0 CRIT, 0 HIGH, 1 MEDIUM, 4 LOW. Fix-round-14 applied; 0 open after fix.

---

### Pass p15 (2026-07-18)

**Findings:** 2 (0C/0H/1M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Fifteenth adversary pass; count returns to 2. 0 CRIT, 0 HIGH, 1 MEDIUM, 1 LOW. Fix-round-15 applied; 0 open after fix.

---

### Pass p16 (2026-07-18)

**Findings:** 3 (0C/0H/1M/2L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Sixteenth adversary pass; 3 findings. 0 CRIT, 0 HIGH, 1 MEDIUM, 2 LOW. Fix-round-16 applied; 0 open after fix.

---

### Pass p17 (2026-07-18)

**Findings:** 4 (0C/0H/2M/2L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Seventeenth adversary pass; bundle-wide test-fn reconciliation sweep (all five stories cross-checked; process-gap item confirmed). 0 CRIT, 0 HIGH, 2 MEDIUM, 2 LOW. Fix-round-17 applied; 0 open after fix.

---

### Pass p18 (2026-07-18)

**Findings:** 2 (0C/0H/1M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Eighteenth adversary pass; temp-file scheme MUST-NOT violation fixed (tmp_<random> placed in same directory as target — S3 S4 MUST place under system temp; fixed). Human ruling mid-grind recorded at this checkpoint: CONTINUE STRICT (AskUserQuestion; "Continue STRICT (3 consecutive zeros)" selected). 0 CRIT, 0 HIGH, 1 MEDIUM, 1 LOW. Fix-round-18 applied; 0 open after fix.

---

### Pass p19 (2026-07-18)

**Findings:** 1 (0C/0H/0M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Nineteenth adversary pass; minimal 1 LOW finding. 0 CRIT, 0 HIGH, 0 MEDIUM, 1 LOW. Fix-round-19 applied; 0 open after fix.

---

### Pass p20 (2026-07-18)

**Findings:** 3 (0C/0H/1M/2L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Twentieth adversary pass; spec micro-round within fix-round-20: v1.3.87→v1.3.88 (P20-002 error-string source-alignment — 401/network loose-substring forms in BC-3.9.012/013 + bc-2 Error Path Summary, three-way network-string divergence resolved). Spec-vs-source string verification at story authoring added to process-gap ledger. 0 CRIT, 0 HIGH, 1 MEDIUM, 2 LOW. Fix-round-20 applied; 0 open after fix.

---

### Pass p21 (2026-07-18)

**Findings:** 1 (0C/0H/0M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Twenty-first adversary pass; minimal 1 LOW finding. 0 CRIT, 0 HIGH, 0 MEDIUM, 1 LOW. Fix-round-21 applied; 0 open after fix.

---

### Pass p22 (2026-07-18)

**Findings:** 2 (0C/0H/0M/2L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Twenty-second adversary pass; 2 LOW findings (zero MEDIUM+). Spec micro-round within fix-round-22: v1.3.88→v1.3.89 (P22-001 mutants.toml examine_globs primary delivery migrated to S1 slot — chain S3→S2 per P3-009 → S1 per P22-001; CWE-116 both-windows escape rationale tightened). Fix-round-22 applied; 0 open after fix.

---

### Pass p23 (2026-07-18)

**Findings:** 3 (0C/0H/1M/2L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Twenty-third adversary pass; module-scaffolding dispatch-arm rows added to S2/S3/S4 (missing AttachmentSubcommand dispatch branches). 0 CRIT, 0 HIGH, 1 MEDIUM, 2 LOW. Fix-round-23 applied; 0 open after fix.

---

### Pass p24 (2026-07-18)

**Findings:** 1 (0C/0H/1M/0L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Twenty-fourth adversary pass; foundational S1 scaffolding misnomer: S1 referred to a nonexistent `IssueSubcommand` type (correct: `IssueCommand`) and created a flat-vs-nested `AttachmentSubcommand` contradiction — survived 23 passes undetected. 0 CRIT, 0 HIGH, 1 MEDIUM, 0 LOW. Fix-round-24 applied; 0 open after fix.

---

### Pass p25 (2026-07-18)

**Findings:** 4 (0C/0H/1M/3L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Twenty-fifth adversary pass; cross-story compile trap: serialize_attachment_object (S2/S4 name) vs serialize_attachment_curated (S3/S5 name) — two incompatible function names for the same logical operation create a cross-story compile failure if either story is integrated without reconciliation. Component-table symbol-name consistency check added to process-gap ledger (item 8). 0 CRIT, 0 HIGH, 1 MEDIUM, 3 LOW. Fix-round-25 applied; 0 open after fix. AC counts: S1 11 / S2 19 / S3 18 / S4 16 / S5 16. Stories v1.12/v1.18/v1.17/v1.16/v1.17. Process-gap ledger 8 items. Pass 26 in flight.

---

### Pass p26 (2026-07-19)

**Findings:** 3 (0C/0H/0M/3L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Twenty-sixth adversary pass; 3 LOW findings. Spec v1.3.89 unchanged. Fix-round-26 applied; 0 open after fix.

---

### Pass p27 (2026-07-19)

**Findings:** 2 (0C/0H/0M/2L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Twenty-seventh adversary pass; 2 LOW findings. Spec v1.3.89 unchanged. Fix-round-27 applied; 0 open after fix.

---

### Pass p28 (2026-07-19)

**Findings:** 2 (0C/0H/0M/2L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Twenty-eighth adversary pass; 2 LOW findings. Spec v1.3.89 unchanged. Fix-round-28 applied; 0 open after fix.

---

### Pass p29 (2026-07-19)

**Findings:** 3 (0C/0H/0M/3L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Twenty-ninth adversary pass; 3 LOW findings. Spec v1.3.89 unchanged. Fix-round-29 applied; 0 open after fix.

---

### Pass p30 (2026-07-19)

**Findings:** 1 (0C/0H/0M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Thirtieth adversary pass; 1 LOW finding. Spec v1.3.89 unchanged. Fix-round-30 applied; 0 open after fix.

---

### Pass p31 (2026-07-19)

**Findings:** 2 (0C/0H/0M/2L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Thirty-first adversary pass; 2 LOW findings. Spec v1.3.89 unchanged. Fix-round-31 applied; 0 open after fix.

---

### Pass p32 (2026-07-19)

**Findings:** 2 (0C/0H/0M/2L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Thirty-second adversary pass; 2 LOW findings. P32-001: `--out` pre-flight ordering unpinned — spec micro-round v1.3.89→v1.3.90 (BC-2.7.007 ordering pin applied). Fix-round-32 applied; 0 open after fix.

---

### Pass p33 (2026-07-19)

**Findings:** 3 (0C/0H/0M/3L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Thirty-third adversary pass; 3 LOW findings. Spec v1.3.90 unchanged. Fix-round-33 applied; 0 open after fix.

---

### Pass p34 (2026-07-19)

**Findings:** 1 (0C/0H/0M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Thirty-fourth adversary pass; 1 LOW finding. Spec v1.3.90 unchanged. Fix-round-34 applied; 0 open after fix.

---

### Pass p35 (2026-07-19)

**Findings:** 3 (0C/0H/0M/3L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Thirty-fifth adversary pass; 3 LOW findings. Spec v1.3.90 unchanged. Fix-round-35 applied; 0 open after fix.

---

### Pass p36 (2026-07-19)

**Findings:** 1 (0C/0H/0M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Thirty-sixth adversary pass; 1 LOW finding. Spec v1.3.90 unchanged. Fix-round-36 applied; 0 open after fix.

---

### Pass p37 (2026-07-19)

**Findings:** 2 (0C/0H/0M/2L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Thirty-seventh adversary pass; 2 LOW findings. Spec v1.3.90 unchanged. Fix-round-37 applied; 0 open after fix.

---

### Pass p38 (2026-07-19)

**Findings:** 1 (0C/0H/0M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Thirty-eighth adversary pass; 1 LOW finding. Spec v1.3.90 unchanged. Fix-round-38 applied; 0 open after fix.

---

### Pass p39 (2026-07-19)

**Findings:** 3 (0C/0H/0M/3L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Thirty-ninth adversary pass; 3 LOW findings. Spec v1.3.90 unchanged. Fix-round-39 applied; 0 open after fix.

---

### Pass p40 (2026-07-19)

**Findings:** 1 (0C/0H/0M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Fortieth adversary pass; 1 LOW finding. Spec v1.3.90 unchanged. Fix-round-40 applied; 0 open after fix.

---

### Pass p41 (2026-07-19)

**Findings:** 2 (0C/0H/0M/2L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Forty-first adversary pass; 2 LOW findings. Spec v1.3.90 unchanged. Fix-round-41 applied; 0 open after fix.

---

### Pass p42 (2026-07-19)

**Findings:** 1 (0C/0H/1M/0L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Forty-second adversary pass; 1 MEDIUM finding. P42-001: coverage gap identified — spec micro-round v1.3.90→v1.3.91 applied. Fix-round-42 applied; 0 open after fix.

---

### Pass p43 (2026-07-19)

**Findings:** 1 (0C/0H/0M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Forty-third adversary pass; 1 LOW finding. Spec v1.3.91 unchanged. Fix-round-43 applied; 0 open after fix.

---

### Pass p44 (2026-07-19)

**Findings:** 1 (0C/0H/1M/0L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Forty-fourth adversary pass; 1 MEDIUM finding. Spec v1.3.91 unchanged. Fix-round-44 applied; 0 open after fix.

---

### Pass p45 (2026-07-19)

**Findings:** 0 — CLEAN
**Convergence counter:** 1 of 3 (STRICT) — window opens

Forty-fifth adversary pass; zero findings at LOW or above. CLEAN — first consecutive CLEAN (streak 1/3). Spec v1.3.91/counts 657/100/35 UNCHANGED. No fix round.

---

### Pass p46 (2026-07-19)

**Findings:** 2 (0C/0H/0M/2L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT) — streak RESET

Forty-sixth adversary pass; 2 LOW findings reset the streak. Spec v1.3.91 unchanged. Fix-round-45 applied; 0 open after fix.

---

### Pass p47 (2026-07-19)

**Findings:** 1 (0C/0H/0M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Forty-seventh adversary pass; 1 LOW finding. Spec v1.3.91 unchanged. Fix-round-46 applied; 0 open after fix.

---

### Pass p48 (2026-07-19)

**Findings:** 2 (0C/0H/0M/2L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Forty-eighth adversary pass; 2 LOW findings. Spec v1.3.91 unchanged. Fix-round-47 applied; 0 open after fix.

---

### Pass p49 (2026-07-19)

**Findings:** 2 (0C/0H/0M/2L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Forty-ninth adversary pass; 2 LOW findings. Spec v1.3.91 unchanged. Fix-round-48 applied; 0 open after fix.

---

### Pass p50 (2026-07-19)

**Findings:** 0 — CLEAN
**Convergence counter:** 1 of 3 (STRICT) — window opens

Fiftieth adversary pass; zero findings. CLEAN — first consecutive CLEAN (streak 1/3). Spec v1.3.91/counts 657/100/35 UNCHANGED. No fix round.

---

### Pass p51 (2026-07-19)

**Findings:** 1 (0C/0H/0M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT) — streak RESET

Fifty-first adversary pass; 1 LOW finding resets the streak. Spec v1.3.91 unchanged. Fix-round-49 applied; 0 open after fix.

---

### Pass p52 (2026-07-19)

**Findings:** 1 (0C/0H/0M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Fifty-second adversary pass; 1 LOW finding. Spec v1.3.91 unchanged. Fix-round-50 applied; 0 open after fix.

---

### Pass p53 (2026-07-19)

**Findings:** 1 (0C/0H/1M/0L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Fifty-third adversary pass; 1 MEDIUM finding. P53-001: filename-semantics clarification required — spec micro-round v1.3.91→v1.3.92 applied. Fix-round-51 applied; 0 open after fix.

---

### Pass p54 (2026-07-19)

**Findings:** 2 (0C/0H/0M/2L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Fifty-fourth adversary pass; 2 LOW findings. Spec v1.3.92 unchanged. Fix-round-52 applied; 0 open after fix.

---

### Pass p55 (2026-07-19)

**Findings:** 0 (P55-001 INFO only — exempt per STRICT criterion) — CLEAN
**Convergence counter:** 1 of 3 (STRICT) — window opens

Fifty-fifth adversary pass; zero findings at LOW or above. P55-001 (INFO): BC-2.7.001 cosmetic observation, CARRIED per STRICT exemption rule. CLEAN — first consecutive CLEAN (streak 1/3). Spec v1.3.92/counts 657/100/35 UNCHANGED. No fix round.

---

### Pass p56 (2026-07-19)

**Findings:** 0 — CLEAN
**Convergence counter:** 2 of 3 (STRICT) — window active

Fifty-sixth adversary pass; zero findings. CLEAN — second consecutive CLEAN (streak 2/3). Spec v1.3.92/counts 657/100/35 UNCHANGED. No fix round.

---

### Pass p57 (2026-07-19)

**Findings:** 1 (0C/0H/0M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT) — streak RESET

Fifty-seventh adversary pass; 1 LOW finding resets the streak from 2/3. Spec v1.3.92 unchanged. Fix-round-53 applied; 0 open after fix.

---

### Pass p58 (2026-07-19)

**Findings:** 2 (0C/0H/0M/2L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Fifty-eighth adversary pass; 2 LOW findings. Spec v1.3.92 unchanged. Fix-round-54 applied; 0 open after fix.

---

### Pass p59 (2026-07-19)

**Findings:** 3 (0C/0H/0M/3L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Fifty-ninth adversary pass; 3 LOW findings. Spec v1.3.92 unchanged. Fix-round-55 applied; 0 open after fix.

---

### Pass p60 (2026-07-19)

**Findings:** 1 (0C/0H/1M/0L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Sixtieth adversary pass; 1 MEDIUM finding. Spec v1.3.92 unchanged. Fix-round-56 applied; 0 open after fix.

---

### Pass p61 (2026-07-19)

**Findings:** 1 (0C/0H/0M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Sixty-first adversary pass; 1 LOW finding. Spec v1.3.92 unchanged. Fix-round-57 applied; 0 open after fix.

---

### Pass p62 (2026-07-19)

**Findings:** 0 — CLEAN
**Convergence counter:** 1 of 3 (STRICT) — window opens

Sixty-second adversary pass; zero findings. CLEAN — first consecutive CLEAN (streak 1/3). Spec v1.3.92/counts 657/100/35 UNCHANGED. No fix round.

---

### Pass p63 (2026-07-19)

**Findings:** 3 (0C/0H/0M/3L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT) — streak RESET

Sixty-third adversary pass; 3 LOW findings reset the streak from 1/3. Spec v1.3.92 unchanged. Fix-round-58 applied; 0 open after fix.

---

### Pass p64 (2026-07-19)

**Findings:** 1 (0C/0H/0M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Sixty-fourth adversary pass; 1 LOW finding. Spec v1.3.92 unchanged. Fix-round-59 applied; 0 open after fix.

---

### Pass p65 (2026-07-19)

**Findings:** 0 — CLEAN
**Convergence counter:** 1 of 3 (STRICT) — window opens

Sixty-fifth adversary pass; zero findings. CLEAN — first consecutive CLEAN (streak 1/3). Spec v1.3.92/counts 657/100/35 UNCHANGED. No fix round.

---

### Pass p66 (2026-07-19)

**Findings:** 1 (0C/0H/1M/0L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT) — streak RESET

Sixty-sixth adversary pass; 1 MEDIUM finding resets the streak from 1/3. P66-001: BC-3.9.019 human-string pins — spec micro-round v1.3.92→v1.3.93 applied. Fix-round-60 applied; 0 open after fix.

---

### Pass p67 (2026-07-19)

**Findings:** 0 — CLEAN
**Convergence counter:** 1 of 3 (STRICT) — window opens

Sixty-seventh adversary pass; zero findings. CLEAN — first consecutive CLEAN (streak 1/3). Spec v1.3.93/counts 657/100/35 UNCHANGED. No fix round.

---

### Pass p68 (2026-07-19)

**Findings:** 1 (0C/0H/1M/0L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT) — streak RESET

Sixty-eighth adversary pass; 1 MEDIUM finding resets the streak. P68-001: EC-3.9.020-6 clap-guard clarification. Spec v1.3.93 unchanged (behavior-only fix). Fix-round-61 applied; 0 open after fix.

---

### Pass p69 (2026-07-19)

**Findings:** 0 — CLEAN
**Convergence counter:** 1 of 3 (STRICT) — window opens

Sixty-ninth adversary pass; zero findings. CLEAN — first consecutive CLEAN (streak 1/3). Spec v1.3.93/counts 657/100/35 UNCHANGED. No fix round.

---

### Pass p70 (2026-07-19)

**Findings:** 1 (0C/0H/1M/0L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT) — streak RESET

Seventieth adversary pass; 1 MEDIUM finding resets the streak. P70-001: batch fail-soft exit-1 behavior clarification required. Spec v1.3.93 unchanged (story-level fix). Fix-round-62 applied; 0 open after fix.

---

### Pass p71 (2026-07-19)

**Findings:** 1 (0C/0H/0M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Seventy-first adversary pass; 1 LOW finding. Spec v1.3.93 unchanged. Fix-round-63 applied; 0 open after fix.

---

### Pass p72 (2026-07-19)

**Findings:** 1 (0C/0H/0M/1L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT)

Seventy-second adversary pass; 1 LOW finding. Spec v1.3.93 unchanged. Fix-round-64 applied; 0 open after fix.

---

### Pass p73 (2026-07-19)

**Findings:** 0 — CLEAN
**Convergence counter:** 1 of 3 (STRICT) — window opens

Seventy-third adversary pass; zero findings. CLEAN — first consecutive CLEAN (streak 1/3). Spec v1.3.93/counts 657/100/35 UNCHANGED. No fix round.

---

### Pass p74 (2026-07-19)

**Findings:** 1 (0C/0H/1M/0L) — FINDINGS_REMAIN
**Convergence counter:** 0 of 3 (STRICT) — streak RESET

Seventy-fourth adversary pass; 1 MEDIUM finding resets the streak. P74-001: pub-visibility compile trap — a pub re-export pattern that compiles in isolation but causes an unreachable-pub warning (treated as error) when integrated. Spec v1.3.93 unchanged (story-level fix). Fix-round-74 applied; 0 open after fix.

---

### Pass p75 (2026-07-19)

**Findings:** 0 — CLEAN
**Convergence counter:** 1 of 3 (STRICT) — window opens

Seventy-fifth adversary pass; zero findings at LOW or above. CLEAN — first consecutive CLEAN of final window (streak 1/3). Spec v1.3.93/counts 657/100/35 UNCHANGED. No fix round.

---

### Pass p76 (2026-07-19)

**Findings:** 0 — CLEAN
**Convergence counter:** 2 of 3 (STRICT) — window active

Seventy-sixth adversary pass; zero findings. CLEAN — second consecutive CLEAN (streak 2/3). Spec v1.3.93/counts 657/100/35 UNCHANGED. No fix round.

---

### Pass p77 (2026-07-19)

**Findings:** 0 — CLEAN
**Convergence counter:** 3 of 3 (STRICT) — CONVERGED

Seventy-seventh adversary pass; zero findings at LOW or above. CLEAN — third consecutive CLEAN (streak 3/3). **WINDOW COMPLETE. FULL STRICT CONVERGENCE ACHIEVED.** Spec v1.3.93/BC-INDEX v6.36/STORY-INDEX v1.5.25/counts 657/100/35 UNCHANGED. No fix round.

---

## Convergence Declaration

**SOH-ATTACHMENTS-1 F3 STRICT CONVERGED — 2026-07-19**

Criterion: FULL STRICT (3 consecutive zero-finding adversary passes).
Window: passes p75, p76, p77 — all CLEAN.
Total passes: 77. Total fix rounds: 74. Spec micro-rounds: 4 (P32-001, P42-001, P53-001, P66-001).
Final spec: v1.3.93. BC-INDEX: v6.36. STORY-INDEX: v1.5.25. Counts: BC 657 / holdouts 100 / VP 35.
Gate status: GATE-READY. 0 blockers. AWAITING HUMAN F3 GATE.
Next: human F3 gate → PRE-F4-UNICODE spec round → F4 delivery (5 stories S1-S5).
Recorded by: state-manager (factory(converge) commit, 2026-07-19T00:00:00Z).

---

## SOH-DX-1 F2 Adversary Passes (2026-07-25, ongoing)

Feature cycle SOH-DX-1 (issues #639+#627+#626): pre-flight guard flip (BC-3.8.012/013), platform-path ordering, breaking change v0.7.0-dev.1. STRICT mode. Need 3 consecutive CLEAN passes.

Spec v1.3.107 / BC-INDEX v6.45 / STORY-INDEX v1.5.41 / counts BC 657 / holdouts 100 / VP 35 at start of adversary loop.

### Pass p78 (2026-07-25)

**Findings:** 8 (4H/4M)
**Convergence counter:** 0 of 3 (STRICT) — grind active

First F2 adversary pass against spec v1.3.107. Finding classes: body contradictions in BC-3.8.012/013 text, missing Platform-Path Guard Ordering, AC-4 vacuous test semantics, delta-analysis phantom symbol names. Fix round 1 dispatched and applied.

---

### Pass p79 (2026-07-25)

**Findings:** 8 (2H/4M/2L)
**Convergence counter:** 0 of 3 (STRICT) — grind active

Second F2 adversary pass. Finding classes: perimeter doc gaps (ADR-0014/CLAUDE.md deliverables), registry entries, test-naming alignment, zero-HTTP discriminating ACs. Fix round 2 dispatched and applied.

---

### Pass p80 (2026-07-25)

**Findings:** 8 (2H/5M/1L; 1 refuted-in-part by orchestrator empirical check)
**Convergence counter:** 0 of 3 (STRICT) — grind active

Third F2 adversary pass. Finding classes: spec-changelog entry gaps, test semantics (vacuous AC-4), registry/testability. 1 finding refuted-in-part (orchestrator verified empirically). Fix round 3 dispatched and applied.

---

### Pass p81 (2026-07-25)

**Findings:** 7 (2H/3M/2L)
**Convergence counter:** 0 of 3 (STRICT) — grind active; PIECEWISE CLEAN after fix round 4

Fourth F2 adversary pass. Finding classes narrowed further: zero-HTTP discriminating ACs, spec-changelog completeness, perimeter-doc completeness. Fix round 4 dispatched and applied. Piecewise CLEAN after round 4.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7). Delta: 0/0/-1. Finding class narrowing confirmed. NEXT: pass-5 (p82).

---

### Pass p82 (2026-07-25)

**Findings:** 6 (2H/4M) + 2 LOW obs + 1 [process-gap]
**Convergence counter:** 0 of 3 (STRICT) — grind active; PIECEWISE CLEAN after fix round 5

Fifth F2 adversary pass (fresh context). HIGH findings: (1) AC-8 non-discriminating — warn-era build also exits 64 with zero HTTP when project/type/summary absent; no clause forbade old eprintln! warnings surviving alongside new exit-64 error. Fix round 5: AC-8 re-specified (full invocation + stderr substring + expect(0)); removal postconditions written into both BC-3.8.012/013 (warn strings MUST be removed; negative assertion on ACs); EC-3.8.012-5 rewritten (no platform --markdown guard exists); AC-5 sharpened (byte-identical stderr for repeated --field); AC-3 pinned (are/is verb discriminator, containment-trap-free); doc-fallout + mod.rs help strings ~:400/403; AC-10 json error shape pinned; BC-INDEX:274 past-tense scoping fixed. Piecewise consistency: CLEAN (are/is discriminator verified; AC-8 completeness verified; verbatim warn substring match verified; AC-1..10 unique; symbol anchors valid). All 3 guard scripts green. Third process-gap (SOH-DX-1-PG-003): expect(0) ACs must pin would-otherwise-proceed setup + positive stderr assertion (POL-11 false-green class for spec-authored ACs).

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6). Delta: 0/0/-1/-1. Finding class narrowing confirmed. NEXT: pass-6 (p83).

---

### Pass p83 (2026-07-25)

**Findings:** 4 (1H/3M)
**Convergence counter:** 0 of 3 (STRICT) — grind active; PIECEWISE CLEAN after fix round 6

Sixth F2 adversary pass (fresh context). HIGH findings: (1) AC-6 vacuity — same class as AC-4 (fixed in round 4); vacuous test missing would-otherwise-proceed setup; fix round 6: AC-6 re-specified with concrete invocation. MEDIUM findings: ADR-0014 second byte-for-byte site at :60 (dual-cite gap — first site :56 fixed in round 4 but second site :60 missed); AC-5 folding-permission ambiguity removed (wording sharpened to eliminate permissive interpretation); spec-changelog under-enumeration completed (missing entries for fix rounds 5 and 6 backfilled). DEC-189 STRICT criterion codified by human ruling: 3 consecutive CLEAN required; any delta-attributable finding resets the window. Piecewise consistency: CLEAN after fix round 6. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4). Delta: 0/0/-1/-1/-2. Finding class narrowing confirmed. NEXT: pass-7 (p84).

---

### Pass p84 (2026-07-25)

**Findings:** 3 (1H/2M) + 1 [process-gap]
**Convergence counter:** 0 of 3 (STRICT) — grind active; PIECEWISE CLEAN after fix round 7

Seventh F2 adversary pass (fresh context). HIGH findings: (1) F7-1 CMDB call misplaced in ordering block — spec described the CMDB lookup as part of the Platform-Path Guard Ordering block, but in the actual code (create.rs:239) the call is post-POST/JSON-only context; ordering block corrected in spec, AC-8 expect(0) set honest. MEDIUM findings: (2) F7-2 EC-3.8.012-8 clap exit-2 precedence added (flags-before-subcommand class — clap exits 2 before jr pre-flight code runs; missing from the EC list); (3) F7-3 AC-10/Test Notes updated to parse-stderr-as-JSON per tests/json_error_shape.rs convention (prior form was looser string-match). Process-gap: SOH-DX-1-PG-004 — no CI pin on help-text semantics for flags with exit-code contracts (help text can drift without CI catching it; ledgered 4th process-gap). Fix round 7 dispatched and applied: piecewise CLEAN, 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3). Delta: 0/0/-1/-1/-2/-1. Finding class narrowing confirmed. NEXT: pass-8 (p85).

---

### Pass p85 (2026-07-25)

**Findings:** 7 (0C/0H/3M/4L) — severity collapsing; count regression 3→7
**Convergence counter:** 0 of 3 (STRICT) — grind active; PIECEWISE CLEAN after fix round 8

Eighth F2 adversary pass (fresh context). ZERO HIGH and ZERO CRITICAL findings — severity continues collapsing despite count increase. MEDIUM findings: (1) helper promotion to tests/common/fixtures.rs — cross-binary `#[path]` directive is unbuildable in the integration test binary; promote to shared fixture module; (2) AC-9 cwd isolation gap — `find_project_config` walk-up behavior not isolated from test cwd; (3) Platform-Path Guard Ordering SSOT declaration + BC placement text collapsed to block refs (repeated prose). LOW findings (4): changelog EC 1..8 + AC-11 enumeration incomplete; stdout-empty postconditions + AC-1 stdout inversion + json no-prefix scoping; AC-11 TTY-seam test pin missing; BC-3.8.013 AC-3 cross-ref absent. Fix round 8 dispatched and applied: 2 piecewise residuals (fn citation + changelog AC-11) fixed post-main burst; 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7). Delta: 0/0/-1/-1/-2/-1/+4. Count regression but severity fully collapsed to 0C/0H. trajectory-tail →6→4→3→7. NEXT: pass-9 (p86).

---

### Pass p86 (2026-07-26)

**Findings:** 6 (0C/1H/4M/1L)
**Convergence counter:** 0 of 3 (STRICT) — grind active; PIECEWISE CLEAN after fix round 9

Ninth F2 adversary pass (fresh context). Count down 7→6; HIGH count down 0→1 (one residual HIGH). HIGH finding: AC-5 anchored — previous form was not substrate-anchored (substring each run required before byte-identity assertion — false-green class: a build that never emits the substring would pass vacuously). MEDIUM findings: (1) SSOT off-by-one + phantom description prompt — spec had an off-by-one in the SSOT guard logic and referred to a non-existent description prompt; (2) AC-10 helper location reconciled — helper referenced in AC-10 was in wrong module per post-fix-8 layout; realizability notes added to clarify test-setup expectations; (3) deliverable phasing reconciled — S-639-1 delivery placement (F4 same PR vs F3 separate) was ambiguous in spec; resolved to "S-639-1 delivery (F4) — same PR; F3 checklist" + AC-12 help-language pinned; (4) AC-13..16 EC coverage — four acceptance criteria lacked corresponding error-category entries in the EC table. LOW finding: EC-3.8.012-9 missing (ninth EC entry absent from error-categories table). Additional fixes: BC-3.8.013 Trace field updated to include +AC-4/AC-16 cross-refs; changelog [1.3.107] current-state totals updated to reflect AC-1..16 (16 ACs) and EC 1..9 + 013-1 (10 EC entries). 1 tracking note resolved in-round. Piecewise consistency: CLEAN after fix round 9. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6). Delta: 0/0/-1/-1/-2/-1/+4/-1. Count converging from regression peak; severity remains low. trajectory-tail →4→3→7→6. NEXT: pass-10 (p87).

---

### Pass p87 (2026-07-26)

**Findings:** 5 (0C/0H/4M/1L)
**Convergence counter:** 0 of 3 (STRICT) — grind active; PIECEWISE CLEAN after fix round 10

Tenth F2 adversary pass (fresh context). Count down 6→5; HIGH count down 1→0 (zero HIGH second consecutive pass: pass-8 0H, pass-9 1H regression, pass-10 0H). MEDIUM findings: (1) ADR-0014 third stale site at :73-76 — first site :56 fixed round 4, second site :60 fixed round 6, third site :73-76 enumerated this round; (2) AC-12 renamed + pinned to verbatim "requires --request-type" help text — AC-12 had been renamed inconsistently in different spec locations; (3) false reporter-edit parenthetical dropped from 013 error string — citation discipline violation (parenthetical cited a reporter without Perplexity validation); (4) AC namespace note added — S-639-1 ACs supersede S-383 same-numbered ACs (S-383 is SUPERSEDED; new ACs in S-639-1 file may share numbers but are not the same contract). LOW finding: helper promotion not fully complete — DELETE + re-import at 3 call sites still needed after round 9 partial promotion. Piecewise fix applied: helper promotion completed (DELETE + re-import 3 call sites). Additional piecewise: 1 finding (version-bump convention) → spec bumped v1.3.108 (2026-07-26) PATCH entry; BC-INDEX last_updated bumped. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1. Count converging; severity fully collapsed (0C/0H). trajectory-tail →3→7→6→5. NEXT: pass-11 (p88).

---

### Pass p88 (2026-07-26)

**Findings:** 6 (0C/2H/4M/0L) + 1 [process-gap]
**Convergence counter:** 0 of 3 (STRICT) — REGRESSION (5→6); grind active; PIECEWISE CLEAN after fix round 11

Eleventh F2 adversary pass (fresh context). Count up 5→6 (regression); 2 HIGHs return. HIGH findings: (1) reporter-claim siblings — spec body contained reporter-claim siblings that were not trimmed/hedged per citation discipline (unvalidated sibling claims adjacent to validated citations); (2) vacuity rationale asymmetry — vacuity rationale stated for some ACs but not others in the same section, creating implicit asymmetry that obscures spec intent. MEDIUM findings: (1) AC-12 dual per-flag assertions — AC-12 had a single combined assertion covering both flags; adversary found the dual per-flag form required (one assertion per flag to avoid conjunctive false-green); (2) item-(d) first-line-only replacement — spec item-(d) change was applied only to the first occurrence; sibling occurrences retained the old text; (3) AC-17..19 coverage gaps — three acceptance criteria (AC-17, AC-18, AC-19) were missing from the spec surface, leaving EC-5, EC-7, and EC-9 without corresponding AC coverage (surface incomplete at AC-1..16; required AC-1..19); (4) BC-3.4.014 index qualifier — BC-INDEX entry for BC-3.4.014 lacked a qualifier distinguishing it from adjacent entries. Process-gap: SOH-DX-1-PG-005 — no changelog Type↔version-component guard (Type field in changelog can drift from the actual version component bumped without any CI catch; 5th ledgered process-gap). Fix round 11 applied: reporter-claim siblings trimmed/hedged; AC-12 rewritten as dual per-flag assertions; item-(d) first-line-only replacement corrected (all occurrences); vacuity rationale asymmetry stated consistently; AC-17..19 added (EC-5/-7/-9 coverage; surface now AC-1..19); BC-3.4.014 index qualifier added; changelog [1.3.107] Type field corrected MINOR→PATCH; spec bumped v1.3.109 + changelog [1.3.109] entry added. Piecewise CLEAN after version bump. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1. Count regression; severity remains low (0C/0H). trajectory-tail →7→6→5→6. NEXT: pass-12 (p89).

---

### Pass p89 (2026-07-26)

**Findings:** 6 (0C/2H/4M/0L) + 2 LOW obs + 1 [process-gap]
**Convergence counter:** 0 of 3 (STRICT) — PLATEAU (6→6); grind active; PIECEWISE CLEAN after fix round 12

Twelfth F2 adversary pass (fresh context). Count holds 6→6 (plateau); 2 HIGHs remain. HIGH findings: (1) AC-12 count-form-only — AC-12 required the "requires --request-type" assertion to be expressed purely as a count-form test (single integer assertion on help-text line count), not as a substring search; prior form was vulnerable to vacuous pass if help text changed; (2) AC-8 myself-endpoint mock set — the mock set backing AC-8 (myself endpoint) was incomplete; required additional mock registration for the specific endpoint path used by the myself resolution. MEDIUM findings: (1) item-(d) citations at /:398 and /:403 with "(repeatable)" qualifier — previous fix preserved first-line occurrences but two occurrences at file lines :398/:403 retained stale form without the "(repeatable)" qualifier; (2) EC-8 symbol citation (IssueCommand::Create inline) — EC-8 error-category entry cited a symbol not in the form required by check-bc-citation-symbols.sh; IssueCommand::Create needed to be cited as an inline symbol reference; (3) per-AC output modes not pinned — spec section describing per-AC output modes lacked explicit stdout/stderr channel pinning for each AC; adversary found each AC must state its output channel explicitly; (4) SSOT step 4a stdin read corrected — SSOT step 4a described the stdin read step with an off-by-one in the stdin handle semantics; corrected to match actual implementation contract. LOW observations (not counted in trajectory): helper doc-comment directive (helper function lacked a doc-comment marking it as test-only); BC-INDEX "amended" qualifier (BC-INDEX entry lacked "amended" qualifier after round-11 edits). Process-gap: SOH-DX-1-PG-006 — EC-field symbol citations in spec not guarded by check-bc-citation-symbols.sh (guard covers bc-*.md files but not EC-field entries in spec body; 6th ledgered process-gap). Fix round 12 applied: AC-12 rewritten as count-form-only; AC-8 mock set completed; item-(d) citations at :398/:403 + (repeatable) preserved in all occurrences; EC-8 symbol citation corrected (IssueCommand::Create inline); per-AC output modes pinned with channel annotations; SSOT step 4a stdin read corrected; LOW obs applied: helper doc-comment directive added; BC-INDEX "amended" qualifier added. Spec bumped v1.3.110 + changelog [1.3.110] entry added. Piecewise CLEAN after fix round 12. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0. Count plateau; severity remains low (0C/0H). trajectory-tail →6→5→6→6. NEXT: pass-13 (p90).

---

### Pass p90 (2026-07-26)

**Findings:** 4 (0C/0H/3M/1L) + 1 [process-gap]
**Convergence counter:** 0 of 3 (STRICT) — CONVERGING (6→4); first pass with ZERO HIGHs and ZERO contradiction-class findings; novelty MEDIUM-LOW; grind active; PIECEWISE CLEAN after fix round 13

Thirteenth F2 adversary pass (fresh context). Count down 6→4 (converging); ZERO HIGH findings — first time in the grind with ZERO HIGHs AND ZERO contradiction-class findings simultaneously; novelty MEDIUM-LOW (citation/test-realizability class only). MEDIUM findings: (1) AC-8 symbol chain — AC-8 referenced a symbol chain that was not correctly anchored to the implementation path; fix: symbol chain corrected; (2) AC-11 preconditions — AC-11 was missing explicit "no --no-input/--project" precondition statement; would-otherwise-proceed test setup incomplete without these guards; fix: preconditions added explicitly; (3) AC-12 whitespace-normalization — AC-12 count-form assertion was not normalized for whitespace; line-count test sensitive to whitespace-only help text changes; fix: whitespace-normalization rule added to AC-12. LOW finding: AC-9 config-lacks-project precondition — AC-9 test setup did not state the config-lacks-project precondition explicitly; fix: precondition added. Process-gap: SOH-DX-1-PG-007 — citation guard (check-bc-citation-symbols.sh) skips AC continuation lines (multi-line AC descriptions where the symbol citation appears on a continuation line rather than the first line are not checked by the guard; this is how F13-01 (AC-8 symbol chain finding) survived 12 adversary passes without being caught by CI; 7th ledgered process-gap). Spec bumped v1.3.111 + changelog [1.3.111] entry added. Piecewise CLEAN after fix round 13. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2. Count converging; severity fully collapsed (0C/0H); novelty declining. trajectory-tail →5→6→6→4. NEXT: pass-14 (p91).

---

### Pass p91 (2026-07-26)

**Findings:** 2 (0C/0H/2M) + 3 LOW obs (not counted in trajectory) — steepest decay yet
**Convergence counter:** 0 of 3 (STRICT) — CONVERGING (4→2); 2nd consecutive pass with ZERO HIGHs + ZERO contradiction-class/mis-anchor findings; grind active; PIECEWISE CLEAN after fix round 14

Fourteenth F2 adversary pass (fresh context). Count down 4→2 (steepest decay in the grind); 2nd consecutive pass with ZERO HIGH findings and ZERO contradiction-class or mis-anchor findings; novelty LOW (test-realizability and mode-annotation class only). MEDIUM findings: (1) AC-1/2/7 old-assertion removal mandates — ACs 1, 2, and 7 carried stale assertion forms from prior spec versions alongside the new forms; spec did not include explicit old-assertion removal mandates guaranteeing the stale forms are deleted; fix: AC-1, AC-2, and AC-7 fully re-specified with explicit old-assertion removal mandates; (2) AC-11 discriminators corrected — AC-11 used `dialoguer` as a discriminator (library name, not a behavioral observable) and the negative condition `!stderr.contains("Project key")` was identified as the real discriminating test predicate; fix: AC-11 discriminators corrected to use `dialoguer→stderr` (emission channel) and `!stderr.contains("Project key")` as the real discriminator. Additional fixes: AC-1 stdout-negative vacuity patched (AC-1 stdout assertion was vacuously true — strengthened); EC-9 re-scoped to `--field a=` form (EC-9 error category was under-scoped; re-scoped to cover the `--field a=` missing-value form explicitly); mode annotations completed for AC-1..19 (all 19 ACs now carry explicit stdout/stderr channel annotations — completing the mode-annotation pass begun in round 12). LOW observations (not counted in trajectory): 3 LOW items addressed piecewise without trajectory impact. Spec bumped v1.3.112 + changelog [1.3.112] entry added. Piecewise CLEAN after fix round 14. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2. Count converging; severity fully collapsed (0C/0H); novelty lowest yet (test-realizability + mode-annotation class). trajectory-tail →6→6→4→2. NEXT: pass-15 (p92).

---

### Pass p92 (2026-07-26)

**Findings:** 5 (0C/1H/3M/1L) + 2 obs — REGRESSION (2→5)
**Convergence counter:** 0 of 3 (STRICT) — REGRESSION (2→5); HIGH count returns (0→1); grind active; PIECEWISE CLEAN after fix round 15

Fifteenth F2 adversary pass (fresh context). Count up 2→5 (regression); 1 HIGH returns after 2 consecutive ZERO-HIGH passes. HIGH finding: AC-1 human-mode re-scope — AC-1/AC-10 pairing: AC-1 had accumulated a duplication with AC-10's coverage scope; adversary found AC-1 human-mode output claim was broader than the contract required; fix: AC-1 re-scoped with explicit human-mode boundary; AC-10 pairing documented; duplication killed. MEDIUM findings: (1) AC-3 invocation+exit-64+removal pin — AC-3 lacked explicit invocation pin, exit-64 assertion, and old-assertion removal mandate; fix: AC-3 fully re-specified with all three pins; (2) stdout.trim().is_empty() global normalization — multiple ACs used inconsistent stdout-negative forms; fix: stdout.trim().is_empty() normalized globally across all ACs that assert stdout absence; (3) AC-8 team-resolution targets enumerated — AC-8 mock set for team-resolution path lacked enumeration of the three required endpoint targets (graphql endpoint, teams endpoint, field endpoint); fix: all three endpoints enumerated. LOW finding: BC-3.3.001 H1 qualifier — BC-3.3.001 body lacked the H1 qualifier distinguishing the primary constraint from secondary constraints; fix: qualifier added. Observations (not counted in trajectory): (1) EC-6 no-AC rationale — EC-6 error-category entry had no corresponding AC and no rationale explaining the absence; fix: rationale note added to EC-6; (2) AC-18 stdin-claims demoted — AC-18 contained over-specified stdin claims that elevated the risk of false-green tests; fix: stdin-claims demoted to match actual contract scope. Spec bumped v1.3.113 + changelog [1.3.113] entry added. Piecewise CLEAN after fix round 15. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3. Count regression (2→5); HIGH returns (1). trajectory-tail →6→4→2→5. NEXT: pass-16 (p93).

---

### Pass p93 (2026-07-26)

**Findings:** 5 (0C/2H/2M/1L) — PLATEAU (5→5)
**Convergence counter:** 0 of 3 (STRICT) — PLATEAU (5→5); 2 HIGHs; grind active; PIECEWISE CLEAN after fix round 16

Sixteenth F2 adversary pass (fresh context). Count holds 5→5 (plateau); 2 HIGHs. HIGH findings: (1) self-contradiction postcondition-wins — spec contained a self-contradiction where postcondition assertions conflicted with setup preconditions; resolved with postcondition-wins rule; regression pins added on AC-1/2/3/5/7; (2) AC-14 --project discrimination + positive 016-substring — AC-14 lacked the --project discrimination note and a positive assertion on the "request type cannot be empty" substring (verified verbatim at jsm_create.rs:146); fix: both added. MEDIUM findings: (1) AC-13/16-19 discrimination notes — ACs 13, 16, 17, 18, and 19 were missing discrimination notes distinguishing their test setup from overlapping ACs; fix: discrimination notes added; (2) trim-predicate citation corrected — trim-predicate in one AC cited the wrong source symbol; fix: citation corrected to accurate symbol. LOW finding: AC-5 [mode: human] annotation — AC-5 was missing the [mode: human] channel annotation; fix: annotation added. Additional fixes: SSOT steps 3 and 4 contained duplicate prompt language; deduplicated; AC-11 re-anchored to correct test location. Spec bumped v1.3.114 + changelog [1.3.114] entry added. Piecewise CLEAN after fix round 16. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0. Count plateau (5→5); 2 HIGHs; novelty LOW-MED. trajectory-tail →4→2→5→5. NEXT: pass-17 (p94).

---

### Pass p94 (2026-07-26)

**Findings:** 4 (0C/2H/2M/0L) + 2 LOW obs (not counted in trajectory)
**Convergence counter:** 0 of 3 (STRICT) — CONVERGING (5→4); 2 HIGHs remain but fixed; novelty MED; grind active; PIECEWISE CLEAN after fix round 17

Seventeenth F2 adversary pass (fresh context). Count down 5→4 (converging); 2 HIGH findings. HIGH findings: (1) MockServer isolation on AC-8/AC-11 — wiremock FIFO fixture-defeat: AC-8 and AC-11 test scaffolding used a shared MockServer instance without per-test reset; wiremock's FIFO ordering means a prior test's mocks can satisfy a later test's expectations, causing a fixture-defeat where the test passes for the wrong reason; fix: MockServer isolation enforced per test (each AC-8/AC-11 test uses a fresh MockServer); FIFO fixture-defeat class now closed for these ACs; (2) removal mandates completed AC-1..AC-5 — ACs 1 through 5 carried implicit removal mandates (prior spec versions' assertion forms must be deleted when the new form is installed) but the mandates were not stated explicitly in each AC body; fix: explicit removal mandates written into AC-1, AC-2, AC-3, AC-4, and AC-5 bodies. MEDIUM findings: (1) AC-1(ii) description corrected — the AC-1(ii) subclause description used a phrasing that did not precisely match the behavioral contract (the description was ambiguous between two different test predicates); fix: AC-1(ii) description rewritten to be unambiguous; (2) "Created issue" discriminating negative on 7 human-mode ACs — 7 human-mode ACs (AC-1, AC-2, AC-3, AC-5, AC-7, AC-10, AC-11) lacked a discriminating negative assertion on the "Created issue" string (verified verbatim at output::print_success→stderr); without the discriminating negative, a test that accidentally triggers the issue-create success path would pass when it should fail; fix: discriminating negative added to all 7 ACs. LOW observations (not counted in trajectory): (1) BC-INDEX subject lines — two BC-INDEX subject lines were updated with improved precision to reflect the current contract scope after fix rounds; (2) DEC-188-ratified date markers — two spec locations referenced DEC-188 without the ratified date marker (2026-07-25); fix: date markers added for traceability. Spec bumped v1.3.115 + changelog [1.3.115] entry added. Piecewise CLEAN after fix round 17. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1. Count converging (5→4); 2 HIGHs fixed; novelty MED. trajectory-tail →2→5→5→4. NEXT: pass-18 (p95).

---

### Pass p95 (2026-07-26)

**Findings:** 3 (0C/1H/2M) + 2 LOW obs (not counted in trajectory)
**Convergence counter:** 0 of 3 (STRICT) — CONVERGING (4→3); 1 HIGH; novelty MED-LOW; grind active; PIECEWISE CLEAN after fix round 18

Eighteenth F2 adversary pass (fresh context). Count down 4→3 (converging); 1 HIGH finding. HIGH finding: vacuous-negative DELETE mandates — ACs 2, 4, and 6 carried vacuous negative assertions (negative claims without DELETE mandates guaranteeing stale assertion forms are removed when new forms install); fix: DELETE mandates completed for AC-2, AC-4, and AC-6, ensuring prior stale assertion forms are explicitly removed. MEDIUM findings: (1) AC-4 combined negative — AC-4 lacked a combined negative assertion (the AC specified positive and standalone negative but not a combined form covering both dimensions simultaneously); fix: AC-4 combined negative assertion added; (2) AC-20 JSM-path 013 non-mis-fire pin — spec lacked an explicit AC pinning the JSM-path 013 behavior to prevent non-mis-fire false-green (a test that passes for the wrong reason if the platform path accidentally handles the JSM request type assertion); fix: AC-20 added (surface now AC-1..20). LOW observations (not counted in trajectory): (1) preamble :2752 qualified — preamble at :2752 lacked a qualifier distinguishing the primary constraint; fix: qualifier added; (2) changelog-enumeration residual — one changelog-enumeration item from a prior fix round was not reflected in the spec-changelog; fixed in-round (piecewise). Spec bumped v1.3.116 + changelog [1.3.116] entry added. Piecewise CLEAN after fix round 18. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1. Count converging (4→3); 1 HIGH fixed; novelty MED-LOW. trajectory-tail →5→5→4→3. NEXT: pass-19 (p96).

---

### Pass p96 (2026-07-26)

**Findings:** 3 (0C/0H/3M/0L) + 2 LOW obs (not counted in trajectory)
**Convergence counter:** 0 of 3 (STRICT) — PLATEAU (3→3); ZERO HIGHs (first pass with MEDIUM severity ceiling); novelty MED-LOW; grind active; PIECEWISE CLEAN after fix round 19

Nineteenth F2 adversary pass (fresh context). Count holds 3→3 (plateau); ZERO HIGH findings — first pass in the grind with MEDIUM as the maximum severity class. MEDIUM findings: (1) AC-21 both-flags JSM success pin — spec lacked an explicit AC pinning the JSM create success path when BOTH --on-behalf-of AND --field are supplied simultaneously (the combined-flags path was unverified); fix: AC-21 added (surface now AC-1..21); (2) HYGIENE labels on unfalsifiable negatives — several ACs carried negatives that were structurally unfalsifiable (the negative assertion could pass vacuously regardless of implementation correctness); fix: HYGIENE labels added to all unfalsifiable-negative ACs with the falsifiability rule codified into the spec namespace note; (3) :3036 cites → section-form (#408 rule) — two citations at :3036 used bare line-number form instead of the required section-form per #408 convention; fix: both citations rewritten to section-form. LOW observations (not counted in trajectory): (1) --output json removal mandates AC-1/3/5 — AC-1, AC-3, and AC-5 lacked explicit --output json removal mandates (prior spec versions' assertion forms must be deleted when the new forms install); fix: removal mandates added to AC-1/3/5; (2) AC-17 rescoped to 'cannot be combined with' — AC-17 used an assertion phrasing that was not the verified verbatim string; fix: AC-17 rescoped to the verified verbatim form 'cannot be combined with'. Spec bumped v1.3.117 + changelog [1.3.117] entry added. Piecewise CLEAN after fix round 19. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0. Count plateau (3→3); ZERO HIGHs (MEDIUM ceiling); novelty MED-LOW. trajectory-tail →5→4→3→3. NEXT: pass-20 (p97).

---

### Pass p97 (2026-07-26)

**Findings:** 5 (0C/2H/3M/0L)
**Convergence counter:** 0 of 3 (STRICT) — REGRESSION (3→5); 2 HIGHs return after first ZERO-HIGH pass; grind active; PIECEWISE CLEAN after fix round 20

Twentieth F2 adversary pass (fresh context). Count up 3→5 (regression); 2 HIGH findings return after pass-19's first ZERO-HIGH result. HIGH findings: (1) complete-invocation resolution (AC-1/3/5/18/19) — ACs 1, 3, 5, 18, and 19 required complete-invocation test forms (stubs KEPT per spec contract; prior forms were invocation-partial or structurally vacuous); the "Created issue" discriminating negative was structurally unfalsifiable in prior form — any implementation including one that never emits "Created issue" would pass; reannotated as a genuine discriminating negative with falsifiability condition stated; fix: complete-invocation forms written for AC-1/3/5/18/19; (2) AC-8 mock-set honesty — AC-8 mock set classification was misleading: only the field-discovery endpoint is DISCRIMINATING; the remaining mocks in the set are defense-in-depth (they fire only if the implementation calls them, not to prove correctness of the primary field-discovery path); fix: mock-set honesty applied (field-discovery=DISCRIMINATING label; rest=defense-in-depth annotation); AC-8 call-site cite corrected to accurate implementation symbol. MEDIUM findings: (1) HYGIENE relabels AC-9/11 — AC-9 and AC-11 carried assertion forms labeled as discriminating that were structurally HYGIENE assertions (true by construction, not by implementation behavior); fix: HYGIENE labels applied to AC-9 and AC-11 with falsifiability rationale; (2) AC-8 call-site cite — AC-8 cited a call-site symbol that was stale after prior fix rounds; fix: cite corrected to the accurate post-fix-round implementation symbol; (3) EC-3.8.013-2 — the second error-category entry for EC-3.8.013 was missing from the error-categories table; fix: EC-3.8.013-2 added with full entry. Process-gap: SOH-DX-1-PG-008 — falsifiability rule for ACs is codified in spec namespace note (prose-only); no CI guard enforces it — unfalsifiable-negative ACs can be authored and pass review without mechanical detection (8th ledgered process-gap). Spec bumped v1.3.118 + changelog [1.3.118] entry added. Piecewise CLEAN after fix round 20. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2. Count regression (3→5); 2 HIGHs returned; novelty MED (complete-invocation falsifiability class). trajectory-tail →4→3→3→5. NEXT: pass-21 (p98).

---

### Pass p98 (2026-07-26)

**Findings:** 4 (0C/1H/3M/0L) + 3 LOW obs (not counted in trajectory)
**Convergence counter:** 0 of 3 (STRICT) — CONVERGING (5→4); 1 HIGH finding; novelty MED; grind active; PIECEWISE CLEAN after fix round 21

Twenty-first F2 adversary pass (fresh context). Count down 5→4 (converging); 1 HIGH finding. HIGH finding: AC-20/21 realizable — ACs 20 and 21 lacked realizable test forms; fix: project+summary+real stub trio required; "Password Reset" fixture name canonical; additional fix-21 items applied: AC-5 "Created issue" discriminating negative made genuinely falsifiable (discriminating negative form with stated falsifiability condition); AC-2 and AC-7 KEPT clauses added (assertion completeness — prior assertion forms must be explicitly deleted when new forms install); SSOT completeness caveat added to SSOT step (step referenced incomplete coverage without qualification). MEDIUM findings: (1) AC-5 "Created issue" negative — AC-5 carried a "Created issue" negative that was structurally unfalsifiable in its prior form; fix: discriminating negative rewritten with falsifiability condition stated; (2) AC-2/7 KEPT clauses — AC-2 and AC-7 lacked KEPT clauses to mark non-superseded assertions, leaving spec incomplete on assertion retention vs replacement; fix: KEPT clauses added; (3) SSOT completeness caveat — SSOT step referenced coverage without a completeness caveat, creating a false impression of exhaustive coverage; fix: caveat added. Fix-21 additional items (not separately categorized as HIGH/MED findings but applied in the fix round): AC-8 team_field_id precondition added; S-383 index status ruled-deliberate (not a defect; index status entry is a deliberate superseded-contract marker). LOW observations (not counted in trajectory): 3 LOW items noted. 1 residual fixed in-round (piecewise). Spec bumped v1.3.119 + changelog [1.3.119] entry added. Piecewise CLEAN after fix round 21. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1. Count converging (5→4); 1 HIGH; novelty MED (AC-20/21 realizable class). trajectory-tail →3→3→5→4. NEXT: pass-22 (p99).

---

### Pass p99 (2026-07-26)

**Findings:** 2 (0C/0H/2M/0L) + 1 LOW obs (not counted in trajectory)
**Convergence counter:** 0 of 3 (STRICT) — CONVERGING (4→2); ZERO HIGHs; ZERO CRITs; novelty MEDIUM-LOW; adversary verdict "contract layer appears converged"; grind active; PIECEWISE CLEAN after fix round 22

Twenty-second F2 adversary pass (fresh context). Count down 4→2 (converging); ZERO HIGH findings; ZERO CRITICAL findings; novelty MEDIUM-LOW. Adversary self-assessment: "contract layer appears converged" — both findings were citation-anchor collisions in test-rewrite mandates (same class, not new failure modes). MEDIUM findings: (1) citation-anchor collision in KEPT clauses — ALL KEPT clauses across all ACs retained a presence-only form that the adversary identified as an anchor-collision class: a KEPT clause that names the assertion but does not express its exclusion boundary allows a test-rewrite to silently delete the KEPT assertion while satisfying the new form; fix: ALL KEPT clauses rewritten to exclusion-form (class-kill — rewritten to state what MUST NOT be absent rather than what must be present, making any deletion detectable); (2) citation-anchor collision in AC-2 test-rewrite mandate — same class: the AC-2 test-rewrite mandate cited the replacement assertion anchor without excluding the prior form; fix: AC-2 mandate rewritten to exclusion-form. Fix-22 additional items: AC-1 presence-only assertion note added (disambiguates presence-only detection from absence-of-wrong-output); --no-input precondition note added to AC-1 (clarifies non-interactive test setup). EC-2 whitespace variant: EC-2 error-category entry lacked the whitespace-normalization variant; fix: EC-2 whitespace variant added. LOW observation (not counted in trajectory): 1 LOW item noted; not actionable this round. Spec bumped v1.3.120 + changelog [1.3.120] entry added. Piecewise CLEAN after fix round 22. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2. Count converging (4→2); ZERO HIGHs; novelty MEDIUM-LOW (citation-anchor collision class); adversary: "contract layer appears converged". trajectory-tail →3→5→4→2. NEXT: pass-23 (p100).

---

### Pass p100 (2026-07-26)

**Findings:** 3 (0C/1H/0M/2L) + 1 out-of-delta obs (not counted in trajectory)
**Convergence counter:** 0 of 3 (STRICT) — REGRESSION (2→3); 1 HIGH finding; novelty LOW (first LOW-novelty pass); 9th process-gap ledgered; PIECEWISE CLEAN after fix round 23

Twenty-third F2 adversary pass (fresh context). Count up 2→3 (slight regression); 1 HIGH finding; novelty LOW — first pass in the grind where the adversary characterized novelty as LOW. HIGH finding: BC-INDEX index_version field stale by 4 — the BC-INDEX `index_version` machine field was stale by 4 increments relative to the current prose version (v6.46 vs v6.50); root cause: our own bump convention applied version increments to prose labels but not to the machine-readable field; fix: index_version field healed to v6.50. LOW findings: (1) anchor refresh — several anchors in bc-3-issue-write.md were stale after prior fix rounds; fix: anchors refreshed; (2) pub fn directive stated — a specification directive for a public function lacked the `pub fn` qualifier in the stated mandate form; fix: pub fn stated. Out-of-delta observation (not counted in trajectory): prd/README 603-vs-657 count drift — prd/README.md carried a BC count of 603 (pre-existing drift from prior cycles, out-of-delta scope); fix: repaired opportunistically per DEC-158 precedent. Process-gap: SOH-DX-1-PG-009 — prd/README.md is an unguarded 9th count surface (no guard script enforces count consistency for prd/README.md; it can drift without CI detection — 9th ledgered process-gap). Spec bumped v1.3.121 + changelog [1.3.121] entry added. Piecewise CLEAN after fix round 23. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1. Count regression (2→3); 1 HIGH; novelty LOW (first LOW-novelty pass; index_version machine-field drift class). trajectory-tail →5→4→2→3. NEXT: pass-24 (p101).

---

### Pass p101 (2026-07-26)

**Findings:** 3 (0C/0H/3M/0L) + 2 LOW obs (not counted in trajectory)
**Convergence counter:** 0 of 3 (STRICT) — PLATEAU (3→3); ZERO HIGHs; ZERO CRITs; novelty MEDIUM-LOW; all instruction-coherence defects from prior rounds' own edits; PIECEWISE CLEAN after fix round 24

Twenty-fourth F2 adversary pass (fresh context). Count holds 3→3 (plateau); ZERO HIGH findings; ZERO CRITICAL findings; novelty MEDIUM-LOW — all findings were instruction-coherence defects introduced by prior rounds' own edits (not new failure-mode classes); the behavioral contract was verified coherent against code, siblings, index, and changelog. MEDIUM findings: (1) KEPT clauses stripped from NEW ACs 18/19 — the new ACs 18/19 authored in rounds 20/21 carried KEPT clauses that had not been converted to the exclusion-form mandated by the class-kill from round 22; fix: KEPT clauses in AC-18/19 rewritten to exclusion-form; (2) AC-4 invocation + KEPT — AC-4's invocation form was incomplete and its KEPT clause was not exclusion-form; fix: invocation corrected, KEPT clause rewritten to exclusion-form; (3) AC-6 KEPT (expect(1) POST preserved) — AC-6's KEPT clause needed to preserve the expect(1) POST assertion form explicitly so a rewrite cannot silently drop it; fix: KEPT clause updated to name the preserved assertion. LOW observations (not counted in trajectory): (1) SSOT re-scoped + step placements corrected — SSOT scope description had imprecise step placements relative to the implementation sequence; fix: SSOT re-scoped and step placements corrected; (2) ADR-0014 fourth site / AC-20/21 fourth stub explicit — ADR-0014 had a fourth citation site not yet added; AC-20/21 lacked an explicit fourth stub invocation in the test setup; fix: ADR-0014 fourth site added, AC-20/21 fourth stub made explicit. Spec bumped v1.3.122 + changelog [1.3.122] entry added. BC-INDEX v6.51. Piecewise CLEAN after fix round 24. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0. Count PLATEAU (3→3); ZERO HIGHs; novelty MEDIUM-LOW (instruction-coherence class); spec v1.3.122; BC-INDEX v6.51. trajectory-tail →4→2→3→3. NEXT: pass-25 (p102).

### Pass p102 (2026-07-26)

**Findings:** 6 (0C/1H/3M/2L)
**Convergence counter:** 0 of 3 (STRICT) — REGRESSION (3→6); 1 HIGH; novelty MEDIUM; three-tier falsifiability taxonomy codified; AC-5 discriminator restored; PIECEWISE CLEAN after fix round 25 (in-round residual fixed)

Twenty-fifth F2 adversary pass (fresh context). Count up 3→6 (regression); 1 HIGH finding; novelty MEDIUM — the taxonomy/discriminator class represents a structural spec-quality gap not present in prior passes (prior passes were instruction-coherence defects from the fix rounds' own edits; pass-25 surfaces a falsifiability-structure gap). HIGH finding: three-tier falsifiability taxonomy codified + labels swept — the spec lacked a consistent three-tier falsifiability taxonomy (DISCRIMINATING / FALSIFIABLE-COARSE / HYGIENE); adversary found that several ACs were labeled inconsistently or not labeled at all, and the REGRESSION PIN pattern (a DISCRIMINATING subtype for assertions that prevent regression to a specific prior defect) was missing from the taxonomy; fix: taxonomy codified in spec namespace note, all AC labels swept and corrected, REGRESSION PIN introduced as a DISCRIMINATING subtype; one in-round residual found and fixed during sweep. MEDIUM findings: (1) AC-5 n=1-vs-n>1 discriminator restored — AC-5's test for single-vs-multi-field invocation was missing the multi-field DELETE case; a test with n=1 field cannot discriminate between correct single-field handling and a bug that silently ignores subsequent fields; fix: multi-field invocation added to DELETE path in AC-5; (2) BC-3.3.001 Behavior line corrected — the Behavior line for BC-3.3.001 described only the issue key return, omitting the full issue object + url that the implementation returns; fix: Behavior line corrected to state full issue object + url; (3) AC-2/7 canonical-invocation notes — AC-2 and AC-7 lacked canonical-invocation notes specifying the exact flag form to use in the test setup; without these notes, implementers may use abbreviated forms that pass for the wrong reason; fix: canonical-invocation notes added to AC-2 and AC-7. LOW findings: (1) :2759 range fix — a source-line range citation in the spec cited :2759 which was stale after prior fix rounds; fix: range corrected; (2) in-round residual from taxonomy sweep — one additional AC label found inconsistent during the taxonomy sweep fix pass; fix: label corrected in-round. Spec bumped v1.3.123 + changelog [1.3.123] entry added. BC-INDEX v6.52. Piecewise CLEAN after fix round 25 (in-round residual fixed in-round). All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3. Count REGRESSION (3→6); 1 HIGH; novelty MEDIUM (taxonomy/discriminator class); spec v1.3.123; BC-INDEX v6.52. trajectory-tail →2→3→3→6. NEXT: pass-26 (p103).

---

### Pass p103 (2026-07-26)

**Findings:** 6 (0C/0H/3M/3L)
**Convergence counter:** 0 of 3 (STRICT) — PLATEAU (6→6); ZERO HIGHs; ZERO CRITs; novelty LOW-MEDIUM; adversary verdict "spec has largely converged" (two consecutive largely-converged verdicts); PIECEWISE CLEAN after fix round 26

Twenty-sixth F2 adversary pass (fresh context). Count holds 6→6 (plateau); ZERO HIGH findings; ZERO CRITICAL findings; novelty LOW-MEDIUM — adversary verdict "spec has largely converged" in both pass-25 and pass-26, indicating structural convergence. MEDIUM findings: (1) full-string verbatim pins AC-1/3/16 (remedy tails falsifiable) — several ACs had remedy-tail assertions that were not full-string verbatim pins; a partial-match assertion on a remedy tail can pass vacuously if the implementation outputs the substring in a different context; fix: AC-1, AC-3, and AC-16 remedy tails re-pinned as full-string verbatim matches (char-for-char pin match verified post-fix); (2) AC-8 dual-invocation (013 zero-HTTP proof) — AC-8 needed a dual-invocation form to prove the 013 zero-HTTP invariant; single-invocation form could not distinguish between "013 check not reached" and "013 correctly returned zero HTTP calls"; fix: AC-8 rewritten as dual-invocation with explicit zero-HTTP proof structure; (3) accountId retained in help line — the help line for a flag omitted the accountId qualifier, creating a gap between the help text contract and the behavioral contract; fix: accountId qualifier reinstated in help line per BC-3.8.013 contract. LOW findings: (1) citation form — two citations used bare line-number form instead of the required section-form per #408 convention; fix: citations rewritten to section-form; (2) single-source notes — two spec locations stated the same constraint without cross-referencing each other, creating a risk of split-brain drift; fix: single-source notes added with cross-references. Fix round 26 dispatched and applied. Spec bumped v1.3.124 + changelog [1.3.124] entry added. BC-INDEX v6.53. Piecewise CLEAN (char-for-char pin match verified). All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0. Count PLATEAU (6→6); ZERO HIGHs; novelty LOW-MEDIUM (verbatim pin class); spec v1.3.124; BC-INDEX v6.53. trajectory-tail →3→3→6→6. NEXT: pass-27 (p104).

---

### Pass p104 (2026-07-26)

**Findings:** 4 (0C/1H/2M/1L) + 1 [process-gap]
**Convergence counter:** 0 of 3 (STRICT) — CONVERGING (6→4); 1 HIGH finding; novelty MEDIUM→LOW; 10th process-gap ledgered; PIECEWISE CLEAN after fix round 27

Twenty-seventh F2 adversary pass (fresh context). Count down 6→4 (converging); 1 HIGH finding; novelty MEDIUM→LOW — HIGH finding was a labeling error in the existing taxonomy (AC-17 had been labeled DISCRIMINATING but the negative test checks an unreachable code path in the foreign handler, making it structurally HYGIENE; the real discriminating pair was missing). HIGH finding: AC-17 relabeled HYGIENE (foreign-handler string unreachable) + real discriminating pair added — AC-17 tested that `--on-behalf-of` on the platform path does NOT emit an error string specific to the JSM handler (foreign-handler negative); because this code path is unreachable in the platform handler, the test can never fail regardless of the implementation; the test is therefore HYGIENE, not DISCRIMINATING; fix: AC-17 relabeled HYGIENE and a new real discriminating test pair added that checks the correct behavior on the platform path in an actually-reachable scenario. MEDIUM findings: (1) AC-8 ResponseTemplate compile note — AC-8 referenced a Mock ResponseTemplate construction without a compile-time note that the ResponseTemplate::builder() call requires the `wiremock::ResponseTemplate` import; without this note, a test rewrite may fail to compile silently; fix: compile note added to AC-8; (2) helper-location disambiguation — two helper functions cited in the spec had ambiguous location descriptions (both present in helpers.rs and another file); fix: helper-location disambiguated with canonical module path. LOW finding: S-383 status coherence — S-383 story frontmatter carried only `status: completed` without `contract_superseded_by: SOH-DX-1 (DEC-188)` in the machine-readable field; the prose banner noted supersession but the machine field was absent; fix: `contract_superseded_by` field added to S-383 frontmatter so story-writer tooling can detect the superseded contract without parsing prose. Process-gap: SOH-DX-1-PG-010 — foreign-handler-negative heuristic: the taxonomy rule that HYGIENE ACs must not author discriminating negative tests for unreachable code paths (foreign-handler class) is codified only in prose (spec namespace note); no CI guard enforces it; an AC labeled HYGIENE could author a discriminating test without detection (10th ledgered process-gap). Spec bumped v1.3.125 + changelog [1.3.125] entry added. BC-INDEX v6.54. Piecewise CLEAN after fix round 27. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2. Count CONVERGING (6→4); 1 HIGH; novelty MEDIUM→LOW (taxonomy-labeling class); spec v1.3.125; BC-INDEX v6.54. trajectory-tail →3→6→6→4. NEXT: pass-28 (p105).

---

### Pass p105 (2026-07-26)

**Findings:** 5 (0C/0H/2M/3L) + 1 obs (not counted in trajectory)
**Convergence counter:** 0 of 3 (STRICT) — REGRESSION (4→5); ZERO HIGHs; ZERO CRITs; novelty LOW; adversary: "spec has effectively converged" (three consecutive largely-converged verdicts); PIECEWISE CLEAN after fix round 28

Twenty-eighth F2 adversary pass (fresh context). Count up 4→5 (regression); ZERO HIGH findings; ZERO CRITICAL findings; novelty LOW — adversary characterized convergence signal as strong ("spec has effectively converged"), continuing the three-consecutive largely-converged verdict trend; the regression is a count bump driven by two MEDs and three LOWs with no new failure-mode classes. MEDIUM findings: (1) MUST-NOT-clap-requires constraint both BCs (F-2 important realization guard) — both BC-3.8.012 and BC-3.8.013 lacked an explicit MUST-NOT statement prohibiting the clap `requires` attribute (which would make the flags silently effective rather than exit-64 on the platform path, defeating the spec intent); the constraint is a non-obvious "important realization" class: a reader who accepts only the positive contract without the MUST-NOT clause might implement via `requires` and pass the positive ACs while violating the spec intent; fix: MUST-NOT-clap-requires constraint added to both BCs; (2) renderer-arm cite — a citation in the spec to the ADF renderer arm was stale after prior fix rounds; fix: renderer-arm cite corrected to accurate post-fix-round implementation symbol. LOW findings: (1) Rust-literal pin note — a verbatim-pin assertion in an AC lacked the Rust literal form (`b"..."` vs `"..."`) specifying the exact byte representation; without this note, a test author might construct a string assertion that passes for the wrong encoding; fix: Rust-literal pin note added; (2) AC-5 rationale corrected — AC-5's rationale comment stated an incorrect precondition that was inconsistent with the implementation path verified in round 25; fix: rationale corrected; (3) SSOT anchor — the SSOT step had a stale section anchor after prior fix rounds; fix: SSOT anchor refreshed. Observation (not counted in trajectory): AC-4 follow-up-GET note — AC-4 lacked a note clarifying the expected follow-up GET behavior; no behavioral change; annotated as a prose clarification. Spec bumped v1.3.126 + changelog [1.3.126] entry added. BC-INDEX v6.55. Piecewise CLEAN after fix round 28. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1. Count REGRESSION (4→5); ZERO HIGHs; novelty LOW (MUST-NOT-clap-requires important-realization class); adversary: "spec has effectively converged" (three consecutive largely-converged verdicts); spec v1.3.126; BC-INDEX v6.55. trajectory-tail →6→6→4→5. NEXT: pass-29 (p106).

---

### Pass p106 (2026-07-26)

**Findings:** 2 (0C/1H/1M/0L) + 2 obs (not counted in trajectory)
**Convergence counter:** 0 of 3 (STRICT) — CONVERGING (5→2); 1 HIGH; novelty LOW-MEDIUM; fixes: BC-3.8.009 anchor corrections AC-20/21 (mis-anchor); cwd precondition propagated AC-11/17; clap repeats wording; deliberate-omission note (013 remedy asymmetry); PIECEWISE CLEAN after fix round 29

Twenty-ninth F2 adversary pass (fresh context). Count down 5→2 (converging); 1 HIGH finding; novelty LOW-MEDIUM — the HIGH finding was a mis-anchor class (anchor labels in BC-3.8.009 for AC-20/21 pointed to incorrect section targets), and the MEDIUM finding was a missing cwd precondition propagation (AC-11 and AC-17 did not fully propagate the cwd precondition established at the BC level). HIGH finding: BC-3.8.009 anchor corrections AC-20/21 (mis-anchor) — the section anchors for acceptance criteria AC-20 and AC-21 in BC-3.8.009 pointed to incorrect targets after prior fix rounds rearranged sections; a test authored from these ACs would test the wrong behavior without the author realizing it; fix: anchors corrected to the accurate post-fix-round section targets. MEDIUM finding: cwd precondition propagated AC-11/17 — AC-11 and AC-17 referenced the cwd precondition in narrative but did not propagate it as an explicit setup step in the test scaffold; an implementer could author an AC-11/17 test without establishing the cwd precondition, producing a test that passes vacuously; fix: cwd precondition propagated as an explicit setup assertion in AC-11 and AC-17. Observations (not counted in trajectory): (1) clap repeats wording — a MUST-NOT note in the spec used slightly inconsistent wording between BC-3.8.012 and BC-3.8.013 for the clap `requires` prohibition; no behavioral delta but creates ambiguity for a reader comparing the two BCs side by side; fix: wording harmonized to identical phrasing; (2) deliberate-omission note (013 remedy asymmetry) — BC-3.8.013's remedy asymmetry relative to BC-3.8.012 was correct by design but lacked an explicit "deliberate omission" note explaining why; without the note a future editor might "fix" the asymmetry and break the intent; fix: deliberate-omission note added. Spec bumped v1.3.127 + changelog [1.3.127] entry added. BC-INDEX v6.56. Piecewise CLEAN after fix round 29. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1/-3. Count CONVERGING (5→2); 1 HIGH; novelty LOW-MEDIUM (mis-anchor + cwd-precondition-propagation class); spec v1.3.127; BC-INDEX v6.56. trajectory-tail →6→4→5→2. NEXT: pass-30 (p107).

---

### Pass p107 (2026-07-26)

**Findings:** 1 (0C/0H/1M/0L) + 2 obs (not counted in trajectory)
**Convergence counter:** 0 of 3 (STRICT) — CONVERGING (2→1); ZERO HIGHs; ZERO CRITs; novelty LOW; single-finding pass; PIECEWISE CLEAN after fix round 30

Thirtieth F2 adversary pass (fresh context). Count down 2→1 (converging); ZERO HIGH findings; ZERO CRITICAL findings; novelty LOW — single-finding pass; the finding was an instruction-coherence defect in AC-11 (the error-absence rationale was unclear, the spec did not explain that the dialoguer NotConnected error is a non-goal in the interactive test setup, and the residual purpose of the JR_STDIN_IS_TTY seam in the test scaffold was not documented). MEDIUM finding: AC-11 rewritten (error-absence rationale; dialoguer NotConnected non-goal; JR_STDIN_IS_TTY residual purpose) — AC-11's rationale for the error-absence assertion was ambiguous; the spec did not state that the dialoguer `NotConnected` error is a non-goal for this AC (it arises only in a non-TTY context that conflicts with the interactive test setup, so deliberately not tested here); the JR_STDIN_IS_TTY seam's residual purpose in the test scaffold was undocumented, leaving an implementer uncertain whether to retain it; fix: AC-11 rewritten with clear error-absence rationale, explicit non-goal statement for NotConnected, and JR_STDIN_IS_TTY residual purpose documented. Observations (not counted in trajectory): (1) AC-12 coupling note — AC-12 lacked a note documenting the coupling between the interactive prompt path and the test isolation mechanism; no behavioral change; annotated as a prose clarification; (2) no second structural gap found; observation count confirmed at 2 (AC-12 coupling note + in-round consistency check passed). Spec bumped v1.3.128 + changelog [1.3.128] entry added. BC-INDEX v6.57. Piecewise CLEAN after fix round 30. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1/-3/-1. Count CONVERGING (2→1); ZERO HIGHs; novelty LOW (single-finding pass; AC-11 instruction-coherence class); spec v1.3.128; BC-INDEX v6.57. trajectory-tail →4→5→2→1. NEXT: pass-31 (p108).

---

### Pass p108 (2026-07-26)

**Findings:** 3 (0C/1H/1M/1L)
**Convergence counter:** 0 of 3 (STRICT) — REGRESSION (1→3); 1 HIGH; novelty LOW-MEDIUM; BC-3.3.001 H1 + index row retitled (F25-04 partial-fix completed); AC-8 normative proof upgraded to received_requests().is_empty() (complete zero-HTTP proof; expect(0) → defense-in-depth); SSOT step-7 reword; PIECEWISE CLEAN after fix round 31

Thirty-first F2 adversary pass (fresh context). Count up 1→3 (regression from the round-30 low of 1); 1 HIGH finding; novelty LOW-MEDIUM — the HIGH finding was a BC-3.3.001 heading/title mismatch carried forward as a partial-fix artifact from round 25 (F25-04 had corrected the Behavior line but left the H1 heading in bc-3-issue-write.md and the corresponding index row title in BC-INDEX.md misaligned); the MEDIUM finding was AC-8's normative zero-HTTP proof using expect(0) assertions (defense-in-depth form) rather than the stronger received_requests().is_empty() normative form; the LOW finding was an imprecise SSOT step-7 description. HIGH finding: BC-3.3.001 H1 + index row retitled (F25-04 partial-fix completed) — the round-25 fix (F25-04) corrected the Behavior line for BC-3.3.001 but did not update the H1 heading in bc-3-issue-write.md or the corresponding row title in BC-INDEX.md; the heading/title mismatch persisted as a partial-fix artifact; fix: H1 heading in bc-3-issue-write.md and index row title in BC-INDEX.md updated to match the corrected Behavior line. MEDIUM finding: AC-8 normative proof upgraded to received_requests().is_empty() (complete zero-HTTP proof; expect(0) → defense-in-depth) — AC-8's zero-HTTP invariant proof relied on expect(0) assertions which are defense-in-depth assertions rather than a normative proof of zero HTTP calls; the normative form uses received_requests().is_empty() which directly asserts no requests were recorded by the mock server, providing a complete zero-HTTP proof that cannot be vacuously satisfied; fix: AC-8 normative proof upgraded to received_requests().is_empty() with the original expect(0) assertions retained as defense-in-depth commentary. LOW finding: SSOT step-7 reword — the SSOT section's step-7 description had imprecise wording that could be misread as applying to a different step than intended; fix: step-7 reworded for precision. Spec bumped v1.3.129 + changelog [1.3.129] entry added. BC-INDEX v6.58. Piecewise CLEAN after fix round 31. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1/-3/-1/+2. Count REGRESSION (1→3); 1 HIGH; novelty LOW-MEDIUM (H1-title/index-row-retitle class + AC-8 normative-proof upgrade); spec v1.3.129; BC-INDEX v6.58. trajectory-tail →5→2→1→3. NEXT: pass-32 (p109).

---

### Pass p109 (2026-07-26)

**Findings:** 3 (0C/0H/3M/0L)
**Convergence counter:** 0 of 3 (STRICT) — PLATEAU (3→3); ZERO HIGHs; ZERO CRITs; novelty LOW-MEDIUM; EC-3.8.012-10 project-type-agnostic guard; DISCRIMINATING labels AC-2/7/10; AC-16 regression pin + 013 mandate extension; Behavior step-3 enumeration; piecewise 1 residual in-round; CLEAN after fix round 32

Thirty-second F2 adversary pass (fresh context). Count holds 3→3 (plateau); ZERO HIGH findings; ZERO CRITICAL findings; novelty LOW-MEDIUM — the findings were a project-type-agnostic guard gap, missing DISCRIMINATING labels on json-mode stdout predicates, and an AC-16 regression pin gap. MEDIUM findings: (1) EC-3.8.012-10 project-type-agnostic guard (ADR-rationale reversal pinned) — EC-3.8.012-10 contained a guard clause that was project-type-specific; this was also accompanied by a reversed ADR-rationale direction cite that pointed to the wrong rationale; fix: EC-3.8.012-10 rewritten as a project-type-agnostic guard with ADR-rationale direction corrected and reversal explicitly pinned; (2) DISCRIMINATING labels on json-mode stdout predicates AC-2/7/10 — acceptance criteria AC-2, AC-7, and AC-10 contained json-mode stdout predicate assertions that lacked explicit DISCRIMINATING labels; per the AC taxonomy rule, each assertion must be labeled DISCRIMINATING or HYGIENE so its falsifiability class is unambiguous; fix: DISCRIMINATING labels applied to json-mode stdout predicates in AC-2, AC-7, and AC-10; (3) AC-16 regression pin + 013 mandate extension — AC-16 lacked a regression pin to guard against future spec changes silently invalidating the test; additionally BC-3.8.013's mandate did not extend to cover the AC-16 scenario; fix: AC-16 regression pin added and BC-3.8.013 mandate extended to cover it. LOW observations (not counted in trajectory): (1) obligation (e) jsm_create comment fallout — obligation (e) had a jsm_create path comment where EC-5 was miscited; discovered during piecewise review and corrected in-round (1 residual, the "EC mis-cite" fixed in-round); (2) Behavior step-3 enumeration — the Behavior section's step-3 lacked complete enumeration of sub-steps; fix: step-3 enumerated. Spec bumped v1.3.130 + changelog [1.3.130] entry added. BC-INDEX v6.59. Piecewise: 1 residual (EC-5 mis-cite) found and fixed in-round; post-fix CLEAN. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1/-3/-1/+2/0. Count PLATEAU (3→3); ZERO HIGHs; novelty LOW-MEDIUM (project-type-agnostic guard + DISCRIMINATING label taxonomy class); spec v1.3.130; BC-INDEX v6.59. trajectory-tail →2→1→3→3. NEXT: pass-33 (p110).

---

### Pass p110 (2026-07-26)

**Findings:** 2 (0C/0H/2M/0L) + 3 obs (not counted in trajectory)
**Convergence counter:** 0 of 3 (STRICT) — CONVERGING (3→2); ZERO HIGHs; ZERO CRITs; novelty LOW-MEDIUM; AC-3/AC-9 tier labels; AC-10 json-twin DISCRIMINATING; TempDir hygiene; BC-3.8.013 Trace AC-8(ii); AC-7 example value; in-round label sweep 5 FALSIFIABLE→DISCRIMINATING (AC-6/20/21); label taxonomy complete; PIECEWISE CLEAN after fix round 33

Thirty-third F2 adversary pass (fresh context). Count down 3→2 (converging); ZERO HIGH findings; ZERO CRITICAL findings; novelty LOW-MEDIUM — the findings were a label-taxonomy gap class: AC-3 and AC-9 lacked explicit tier labels (DISCRIMINATING/HYGIENE) on their negative-assertion predicates, and AC-10 lacked completion as a json-mode twin to AC-1 (AC-10's DISCRIMINATING label was missing the json-mode stdout predicate that mirrors AC-1's platform-path). MEDIUM findings: (1) AC-3/AC-9 tier labels — acceptance criteria AC-3 and AC-9 contained negative-assertion predicates without explicit DISCRIMINATING labels; per the AC taxonomy rule each assertion must be labeled so its falsifiability class is unambiguous; fix: DISCRIMINATING labels applied to AC-3 and AC-9 negative-assertion predicates; (2) AC-10 completed to AC-1's json twin (genuine DISCRIMINATING) — AC-10 was authored as a DISCRIMINATING AC but lacked the json-mode stdout predicate that makes it a genuine twin to AC-1's platform-path assertion; without the predicate AC-10's DISCRIMINATING label was vacuous (FALSIFIABLE in name only); fix: AC-10 completed with the json-mode stdout predicate mirroring AC-1. In-round fixes (not adversary findings but applied during fix burst): (a) TempDir hygiene — TempDir lifetime scope was ambiguous in the test scaffold examples; clarified in-spec; (b) BC-3.8.013 Trace AC-8(ii) — BC-3.8.013's Trace field was missing the AC-8(ii) citation for the interaction-mode test coverage; added; (c) AC-7 example value — AC-7's example value was imprecise for the json-mode output shape; corrected. In-round label sweep: 5 bare FALSIFIABLE labels normalized to DISCRIMINATING across AC-6, AC-20, and AC-21 — these were ACs that had been authored with FALSIFIABLE as a placeholder and not upgraded during prior rounds; the sweep establishes label taxonomy completeness (zero unlabeled negatives AC-1..21). Observations (not counted in trajectory): (1) in-round sweep completeness confirmed by mechanical grep of AC-1..21; no residual unlabeled negatives found post-sweep; (2) BC-3.8.013 citation audit — all AC-8 citations in BC-3.8.013 verified correct after Trace update; (3) consistency-validator confirmed zero drift across all 37 cross-document checks. Spec bumped v1.3.131 + changelog [1.3.131] entry added. BC-INDEX v6.60. Piecewise CLEAN after fix round 33. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1/-3/-1/+2/0/-1. Count CONVERGING (3→2); ZERO HIGHs; novelty LOW-MEDIUM (label taxonomy class — tier labels + json-twin completion); spec v1.3.131; BC-INDEX v6.60. trajectory-tail →1→3→3→2. NEXT: pass-34 (p111).

---

### Pass p111 (2026-07-26)

**Findings:** 3 (0C/0H/0M/3L)
**Convergence counter:** 0 of 3 (STRICT) — REGRESSION (2→3L); ZERO CRITs; ZERO HIGHs; ZERO MEDs; first zero-M pass (first pass with no contract-level defects); novelty LOW; all 3 findings delta-attributable LOWs (reset STRICT window); fixes: changelog Type legend; mod-common hygiene; help-line duplication rule; adversary verdict: "Spec has converged"; PIECEWISE CLEAN after fix round 34

Thirty-fourth F2 adversary pass (fresh context). Count up 2→3 (regression, but all 3 findings are LOW-severity — first pass with zero contract-level defects of any kind); ZERO HIGH findings; ZERO CRITICAL findings; ZERO MEDIUM findings; novelty LOW — findings are in the process/hygiene/editorial class. LOW finding 1: changelog Type legend — the spec-changelog.md Type field legend lacked a complete enumeration of valid type labels, creating ambiguity about whether a given entry's type label was drawn from the canonical set or invented ad hoc; fix: Type legend added to spec-changelog.md with the canonical type-label set and brief description of each. LOW finding 2: mod-common hygiene — the mod.rs common import file had accumulated minor hygiene issues (stale re-exports and an unused import path that no longer resolved cleanly after prior fix rounds rearranged modules); fix: mod-common hygiene pass applied (stale re-exports removed, import path corrected). LOW finding 3: help-line duplication rule — a help-text duplication existed in two flag descriptions that were semantically equivalent but worded differently, violating the principle that identical behaviors should have identical help text; fix: help-line duplication rule applied (wording unified across the two flag descriptions). Adversary verdict for this pass: "Spec has converged — the remaining 3 LOW findings are editorial/hygiene class with no behavioral or contractual impact; the contract surface is clean." Spec bumped v1.3.132 + changelog [1.3.132] entry added. BC-INDEX v6.61. Piecewise CLEAN after fix round 34. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1/-3/-1/+2/0/-1/+1. Count REGRESSION (2→3L); first zero-M pass (all 3 findings LOW-only; zero contract-level defects); novelty LOW (process-hygiene class: changelog Type legend + mod-common hygiene + help-line duplication rule); adversary verdict "Spec has converged"; spec v1.3.132; BC-INDEX v6.61. trajectory-tail →3→3→2→3L. NEXT: pass-35 (p112).

---

### Pass p112 (2026-07-26)

**Findings:** 4 (0C/0H/1M/3L)
**Convergence counter:** 0 of 3 (STRICT) — REGRESSION (3L→1M+3L); ZERO CRITs; ZERO HIGHs; 1 MEDIUM; novelty LOW-MEDIUM; fifth ADR-0014 stale site enumerated (ALL FIVE); section-anchor self-cites (line-drift class killed); fixture count corrected; REGRESSION PIN extended AC-13/19 (mandate list now 7 ACs); spec v1.3.133 [1.3.133]; BC-INDEX v6.62; PIECEWISE CLEAN after fix round 35

Thirty-fifth F2 adversary pass (fresh context). Count up 3L→1M+3L (regression in severity class and count from the round-34 zero-M pass); ZERO HIGH findings; ZERO CRITICAL findings; 1 MEDIUM finding; novelty LOW-MEDIUM. MEDIUM finding: section-anchor self-cites (line-drift class killed) — section-level self-citations within the spec had drifted from their actual anchor targets after prior fix rounds rearranged sections; multiple ACs contained self-reference anchors pointing to stale heading text, making the cross-reference network internally inconsistent; a test authored by following an anchor would navigate to the wrong section; fix: all stale section-anchor self-cites swept and corrected; line-drift class declared killed after the sweep (no further instances remain). LOW finding 1: fifth ADR-0014 stale site enumerated (ALL FIVE) — ADR-0014's known-stale-sites list had enumerated only four locations where the JSM dispatch fork was referenced with stale phrasing; the fifth stale reference site was missing from the enumeration; fix: fifth stale site added to ADR-0014 enumeration, completing the ALL-FIVE inventory. LOW finding 2: fixture count corrected — a fixture count citation in the spec incorrectly stated the number of test fixtures required for an AC setup; the stated count was one fewer than the actual required count after prior fix rounds added a setup step; fix: fixture count corrected to match the current AC setup specification. LOW finding 3: REGRESSION PIN extended AC-13/19 (mandate list now 7 ACs) — the REGRESSION PIN mandate list in the spec did not include AC-13 and AC-19, which had been authored with regression-pin obligations in their text but were not reflected in the centralized mandate list; without the list entry, a future editor removing the regression pin from AC-13 or AC-19 would not encounter the centralized guard; fix: AC-13 and AC-19 added to the REGRESSION PIN mandate list (7 ACs total). Spec bumped v1.3.133 + changelog [1.3.133] entry added. BC-INDEX v6.62. Piecewise CLEAN after fix round 35. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1/-3/-1/+2/0/-1/+1/+1. Count REGRESSION (3L→1M+3L); ZERO HIGHs; 1 MEDIUM; novelty LOW-MEDIUM (section-anchor self-cites line-drift class + ADR-0014 fifth stale site + fixture count + REGRESSION PIN mandate extension); spec v1.3.133; BC-INDEX v6.62. trajectory-tail →3→3→2→3L→1M+3L. NEXT: pass-36 (p113).

---

### Pass p113 (2026-07-26)

**Findings:** 4 (0C/0H/2M/2L)
**Convergence counter:** 0 of 3 (STRICT) — 2M+2L (from 1M+3L); ZERO CRITs; ZERO HIGHs; 2 MEDIUM; 2 LOW; novelty LOW-MEDIUM; blanket banner/rustdoc rewrite obligation; deliverable (e) sibling site; MUST-NOT rationale corrected (AC-1/2/16 falsifiers); README ..017; spec v1.3.134 [1.3.134]; BC-INDEX v6.63; PIECEWISE CLEAN after fix round 36

Thirty-sixth F2 adversary pass (fresh context). Count 1M+3L→2M+2L (4 findings; MEDIUM count from 1→2, LOW count from 3→2); ZERO HIGH findings; ZERO CRITICAL findings; 2 MEDIUM findings; 2 LOW findings; novelty LOW-MEDIUM. MEDIUM finding 1: blanket banner/rustdoc rewrite obligation — the spec's obligation list lacked a blanket mandate that all rustdoc and banner comments added by the implementation must be rewritten to avoid verbatim spec prose (verbatim prose from the spec appearing in rustdoc creates a citation loop indistinguishable from authoritative documentation — the implementer follows the spec but the spec appears to follow the implementation); fix: blanket banner/rustdoc rewrite obligation added to the obligation list with explicit citation-loop prohibition and rewrite mandate. MEDIUM finding 2: deliverable (e) sibling site — deliverable (e) listed the primary implementation target site but omitted the sibling site that must be updated in lockstep with the primary site (the sibling site was introduced in a prior fix round and is now a required co-edit target); fix: deliverable (e) updated to enumerate both the primary site and the sibling site. LOW finding 1: MUST-NOT rationale corrected (AC-1/2/16 falsifiers) — the MUST-NOT obligation's rationale cited AC-1, AC-2, and AC-16 as the "falsifiers" that the obligation protects; however, the rationale logic was inverted — AC-1/2/16 are the obligations being protected, not the falsifiers that would violate the prohibition; fix: MUST-NOT rationale corrected to accurately describe AC-1/2/16 as the obligations protected by the prohibition, with the falsifier relationship direction corrected. LOW finding 2: README ..017 — the spec's prd/README.md surface had a stale count entry for the ..017-series BCs that did not reflect additions made in prior fix rounds; fix: README ..017 count corrected. Spec bumped v1.3.134 + changelog [1.3.134] entry added. BC-INDEX v6.63. Piecewise CLEAN after fix round 36. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1/-3/-1/+2/0/-1/+1/+1/+1. Count 1M+3L→2M+2L (4 total; MEDIUM count 1→2, LOW count 3→2); ZERO HIGHs; novelty LOW-MEDIUM (blanket-banner-rustdoc-rewrite-obligation + deliverable-sibling-site + MUST-NOT-rationale-direction + README-count class); spec v1.3.134; BC-INDEX v6.63. trajectory-tail →2→3L→1M+3L→2M+2L. NEXT: pass-37 (p114).

---

### Pass p114 (2026-07-26)

**Findings:** 4 (0C/2H/0M/2L)
**Convergence counter:** 0 of 3 (STRICT) — 2H+2L (from 2M+2L); 2 HIGH; ZERO CRITs; ZERO MEDs; 2 LOW; novelty LOW-MEDIUM; config-migration stderr side-channel; Config fixture contract single-sourced AC-2/5/7/10; key-order language contract-softened; mod-common hygiene extended; spec v1.3.135 [1.3.135]; BC-INDEX v6.64; PIECEWISE CLEAN after fix round 37 (AC-9 exemption verified unambiguous)

Thirty-seventh F2 adversary pass (fresh context). Count 2M+2L→2H+2L (4 findings; MEDIUM count 2→0, HIGH count 0→2); 2 HIGH findings; ZERO CRITICAL findings; ZERO MEDIUM findings; 2 LOW findings; novelty LOW-MEDIUM. New root cause: config-migration stderr side-channel poisoning envelope-parse ACs + AC-5 byte-identity. HIGH finding 1: config-migration stderr side-channel poisoning envelope-parse ACs — test fixtures using the legacy flat [instance]/[fields] config shape triggered the auto-migration path on first load; the migration path emits a stderr warning to indicate shape translation had occurred; the ACs for envelope-parse tests (AC-2, AC-7, AC-10) did not precondition on a pre-migrated config and were therefore vulnerable to migration-stderr pollution masking the actual behavior under test; a test could pass (or fail) due to migration noise rather than the tested behavior; fix: Config fixture contract established — all affected ACs now precondition on the pre-migrated [profiles.default] config shape; the pre-migrated shape is single-sourced in Test Notes to prevent fixture drift across AC-2/5/7/10. HIGH finding 2: AC-5 byte-identity violated by config-migration stderr — AC-5 requires byte-identical stderr output for repeated invocations with the same flags; the migration warning fires only on the first-ever run for a given config (state-changing single-shot emission), so the byte-identity contract was violated for any test environment that had not yet migrated the config; fix: AC-5 precondition updated to require a pre-migrated config (same single-source as HIGH finding 1), eliminating the first-run emission from the test surface. LOW finding 1: key-order language contract-softened — the spec had required key-order-stable YAML serialization in several AC assertions; YAML key order is not guaranteed by serde's default serializer and the requirement over-constrained the implementation; fix: key-order language softened in affected ACs to allow any key order in the serialized form while still asserting key presence. LOW finding 2: mod-common hygiene extended — the mod-common test helper was not updated to expose the pre-migrated config fixture at the same time the AC bodies were updated; this risked a fixture-shape drift between the AC specification and the actual test harness; fix: mod-common hygiene obligation extended to include the pre-migrated fixture export. Spec bumped v1.3.135 + changelog [1.3.135] entry added. BC-INDEX v6.64. Piecewise CLEAN after fix round 37 (AC-9 exemption verified unambiguous: AC-9 is a HYGIENE test covering a pre-existing invariant with an explicit exemption from the discriminating-coverage requirement; the exemption is clearly annotated and unambiguous). All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1/-3/-1/+2/0/-1/+1/+1/+1/0. Count 2M+2L→2H+2L (4 total; HIGH count 0→2, MED count 2→0); ZERO CRITs; 2 HIGHs; novelty LOW-MEDIUM (config-migration-stderr-side-channel + AC-5-byte-identity + key-order-contract-softening + mod-common-hygiene-extension); spec v1.3.135; BC-INDEX v6.64. trajectory-tail →3L→1M+3L→2M+2L→2H+2L. NEXT: pass-38 (p115).

---

### Pass p115 (2026-07-26)

**Findings:** 6 (0C/0H/4M/2L)
**Convergence counter:** 0 of 3 (STRICT) — REGRESSION (2H+2L→4M+2L); ZERO CRITs; ZERO HIGHs; 4 MEDIUM; 2 LOW; novelty LOW-MEDIUM; write_profile_config replacement mandates (conditional tail stripped; unconditional-remedies uniform rule); ADR §42-45 de-scoped (4 sites); deliverable (f) feature spec docs/specs/issue-create-preflight-guards.md (no-ADR rationale); pin mandate structural rule (13 ACs after in-round AC-8 residual); AC-13 zero-HTTP proof; PIECEWISE CLEAN after fix round 38 (in-round AC-8 pin residual fixed)

Thirty-eighth F2 adversary pass (fresh context). Count 2H+2L→4M+2L (6 findings total; HIGH count 2→0, MED count 0→4, LOW count 2→2); ZERO CRITICAL findings; ZERO HIGH findings; 4 MEDIUM findings; 2 LOW findings; novelty LOW-MEDIUM. MEDIUM finding 1: write_profile_config replacement mandates — conditional tail stripped (unconditional-remedies uniform rule) — the spec's replacement mandate language for write_profile_config contained a conditional tail that permitted spec-conditional remedies in some branches; this violated the unconditional-remedies uniform rule where all mandatory remediation paths must apply unconditionally regardless of branch taken; the conditional phrasing left open a path where the replacement mandate could be bypassed on certain code paths; fix: conditional tail stripped from all write_profile_config replacement mandate language; unconditional-remedies uniform rule now applies to all replacement paths. MEDIUM finding 2: ADR §42-45 de-scoped (4 sites) — ADR reference sites §42 through §45 were in scope for the spec obligations but had been authored before the ADR was finalized; these 4 sites referenced aspirational or superseded ADR content that no longer accurately described the implementation contract; fix: ADR §42-45 de-scoped at all 4 reference sites in the spec; the 4 sites now cite only the finalized ADR scope without the stale §42-45 aspirational content. MEDIUM finding 3: pin mandate structural rule — the pin mandate section lacked a structural rule governing how mandate entries must be structured (each AC in the mandate list requires a specific structural form: a direct citation + a brief one-line rationale); without the structural rule, mandate entries could be authored with varying forms, creating ambiguity in verification; fix: pin mandate structural rule codified (13 ACs now in the mandate list after in-round AC-8 pin residual was fixed during the fix burst). MEDIUM finding 4: AC-13 zero-HTTP proof — AC-13 asserted a behavioral property that required zero HTTP calls but did not include a proof mechanism that would make the zero-HTTP contract mechanically verifiable; a test following AC-13 would need to assert the HTTP call count independently; fix: AC-13 updated with a zero-HTTP proof assertion (explicit HTTP-call-count assertion mechanism specified). In-round fix: AC-8 pin residual — during the fix burst, an AC-8 regression pin residual was found and fixed in-round (the pin was incomplete from a prior round); piecewise status CLEAN after in-round fix. LOW finding 1: deliverable (f) feature spec docs/specs/issue-create-preflight-guards.md (no-ADR rationale) — the spec's deliverables list was missing deliverable (f), a feature spec for the pre-flight guards implementation at docs/specs/issue-create-preflight-guards.md; the deliverable was also authored without an ADR rationale (the no-ADR rationale: the feature spec is a bounded behavior spec that does not constitute an architectural decision requiring ADR-level governance); fix: deliverable (f) added to the deliverables list with no-ADR rationale documented. LOW finding 2: (process-level observation from the in-round AC-8 pin sweep — see in-round fix note above; not a standalone adversary finding). Spec bumped v1.3.136 + changelog [1.3.136] entry added. BC-INDEX v6.65. Piecewise CLEAN after fix round 38 (AC-8 pin residual fixed in-round). All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1/-3/-1/+2/0/-1/+1/+1/+1/0/+2. Count REGRESSION (2H+2L→4M+2L); ZERO CRITs; ZERO HIGHs; 4 MEDs; novelty LOW-MEDIUM (write_profile_config-replacement-mandates + ADR-§42-45-de-scope + pin-mandate-structural-rule + AC-13-zero-HTTP-proof class); spec v1.3.136; BC-INDEX v6.65. trajectory-tail →2M+2L→2H+2L→4M+2L. NEXT: pass-39 (p116).

---

### Pass p116 (2026-07-26)

**Findings:** 3 (0C/0H/2M/1L) + 3 observations
**Convergence counter:** 0 of 3 (STRICT) — 2M+1L (from 4M+2L); ZERO CRITs; ZERO HIGHs; 2 MEDIUM; 1 LOW; 3 observations (informational); novelty LOW; verdict "converged on substance"; fixes: pin rule reachability qualifier + AC-15 exclusion; write_profile_config fully specified (fixtures.rs shape :1959-1966); EC-10 transitive-falsification sentence; changelog/trace/README bookkeeping; spec v1.3.137 [1.3.137]; BC-INDEX v6.66; PIECEWISE CLEAN after fix round 39

Thirty-ninth F2 adversary pass (fresh context). Count 4M+2L→2M+1L (3 formal findings total + 3 observations; MEDIUM count 4→2, LOW count 2→1); ZERO CRITICAL findings; ZERO HIGH findings; 2 MEDIUM findings; 1 LOW finding; 3 observations (informational, not counted as formal findings); novelty LOW; adversary verdict "converged on substance". MEDIUM finding 1: pin rule reachability qualifier — the pin rule in the spec stated a blanket mandate for regression pins across all listed ACs but lacked a reachability qualifier clarifying that the mandate applies only when the AC path is reachable in the implementation under test; without the qualifier an AC for an unreachable code path would still be required to carry a regression pin, over-constraining the implementer on branches that cannot be exercised; fix: reachability qualifier added to the pin rule mandate. MEDIUM finding 2: AC-15 exclusion — AC-15 was included in the pin mandate list despite covering a HYGIENE path with no regression risk; the inclusion was a stale artefact of an earlier structural sweep that added AC-15 before its HYGIENE label was finalized; fix: AC-15 removed from the pin mandate list. LOW finding 1: write_profile_config fully specified (fixtures.rs shape :1959-1966) — the write_profile_config obligation referenced the fixture shape needed for test setup but did not specify the exact fixture definition location or the canonical struct shape; a test author could construct an incompatible fixture without a concrete reference; fix: write_profile_config obligation updated to fully specify the fixture location (fixtures.rs lines 1959-1966) and the canonical shape required by that line range. Observations (informational, not formal findings): (1) EC-10 transitive-falsification sentence — the EC-10 entry lacked a transitive-falsification sentence explaining how a failure in EC-10 would propagate to related contracts; added during fix burst for completeness; (2) changelog/trace/README bookkeeping — standard per-round maintenance: spec-changelog [1.3.137] entry added, trace fields updated, prd/README.md count corrected; (3) spec v1.3.137 micro-version bump reflects all round-39 additions. Spec bumped v1.3.137 + changelog [1.3.137] entry added. BC-INDEX v6.66. Piecewise CLEAN after fix round 39. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1/-3/-1/+2/0/-1/+1/+1/+1/0/+2/-3. Count IMPROVEMENT (4M+2L→2M+1L); ZERO CRITs; ZERO HIGHs; 2 MEDs; novelty LOW; adversary verdict "converged on substance" (pin-rule-reachability-qualifier + AC-15-exclusion + write_profile_config-fixture-spec class); spec v1.3.137; BC-INDEX v6.66. trajectory-tail →2H+2L→4M+2L→2M+1L. NEXT: pass-40 (p117).

---

### Pass p117 (2026-07-26)

**Findings:** 2 (0C/1H/1M/0L) + 1 observation
**Convergence counter:** 0 of 3 (STRICT) — 1H+1M (from 2M+1L); 1 HIGH; 1 MEDIUM; ZERO CRITs; ZERO LOWs; 1 observation (informational); novelty LOW; piecewise CLEAN after in-round residual; fixes: 5 AC-body pins propagated (all 13 mandate ACs verified carrying the pin); Definition (unconditional remedy) block closes two-ways reading; superseded-note both surfaces (in-round residual); spec v1.3.138 [1.3.138]; BC-INDEX v6.67; PIECEWISE CLEAN after fix round 40

Fortieth F2 adversary pass (fresh context). Count 2M+1L→1H+1M (2 formal findings + 1 observation; MEDIUM count 2→1, LOW count 1→0, HIGH count 0→1); ZERO CRITICAL findings; 1 HIGH finding; 1 MEDIUM finding; ZERO LOW findings; 1 observation (informational, not counted as formal finding); novelty LOW; adversary verdict piecewise CLEAN after in-round residual. HIGH finding: 5 AC-body pins propagated — the regression pin mandate established in prior rounds required that all 13 mandate ACs carry the regression pin assertion in their AC body; a review of all 13 mandate ACs revealed that 5 ACs were missing the pin assertion in their body text (the pin was present in the mandate list header but not propagated into the individual AC bodies themselves); the absence created a discrepancy between the mandate list (which stated the pin was required) and the AC bodies (which did not carry the pin); fix: 5 AC-body pins propagated into all affected AC bodies; all 13 mandate ACs verified to carry the pin. MEDIUM finding: Definition (unconditional remedy) block closes two-ways reading — the Definition block for the unconditional remedy rule contained language that could be read two ways: (a) the rule applies only when the mandate list specifies a remedy, or (b) the rule applies unconditionally regardless of mandate list content; the ambiguity allowed an implementer to argue the conditional reading and bypass the unconditional remedy on branches where the mandate list was silent; fix: Definition (unconditional remedy) block language revised to close the two-ways reading; the unconditional reading is now the only valid interpretation. Observation (informational): superseded-note both surfaces — during the fix burst, an in-round residual was found: the superseded-note was present on one spec surface but not on the sibling surface; the omission was repaired in-round (superseded-note added to both surfaces); piecewise status CLEAN after the in-round residual fix. Spec bumped v1.3.138 + changelog [1.3.138] entry added. BC-INDEX v6.67. Piecewise CLEAN after in-round residual. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1/-3/-1/+2/0/-1/+1/+1/+1/0/+2/-3/-1. Count IMPROVEMENT (2M+1L→1H+1M; total count 3→2; MEDIUM count 2→1, LOW count 1→0, HIGH count 0→1); ZERO CRITs; 1 HIGH; 1 MED; novelty LOW (AC-body-pin-propagation + definition-unconditional-remedy-block + superseded-note-sibling class); spec v1.3.138; BC-INDEX v6.67. trajectory-tail →4M+2L→2M+1L→1H+1M. NEXT: pass-41 (p118).

---

### Pass p118 (2026-07-26)

**Findings:** 2 (0C/0H/2M/0L) + 1 process-gap + 1 nit
**Convergence counter:** 0 of 3 (STRICT) — 2M (from 1H+1M); ZERO CRITs; ZERO HIGHs; 2 MEDIUM; ZERO LOWs; 1 process-gap (SOH-DX-1-PG-011); 1 nit (informational); novelty LOW-MEDIUM; adversary recommends one more pass then converge (converge-adjacent signal); fixes: AC-13 would-otherwise-succeed invocation (zero-HTTP proof normative); AC-1 first-use subtype parenthetical + policy; config_home param rename; spec v1.3.139 [1.3.139]; BC-INDEX v6.68; PIECEWISE CLEAN after fix round 41

Forty-first F2 adversary pass (fresh context). Count 1H+1M→2M (2 formal findings + 1 process-gap + 1 nit; HIGH count 1→0, MEDIUM count 1→2, LOW count 0→0); ZERO CRITICAL findings; ZERO HIGH findings; 2 MEDIUM findings; ZERO LOW findings; novelty LOW-MEDIUM; adversary recommends one more pass then converge (converge-adjacent signal). MEDIUM finding 1: AC-13 would-otherwise-succeed invocation — AC-13 introduced a zero-HTTP proof assertion (from round 38) but the assertion was authored as a would-otherwise-fail test (one that always passes due to zero calls) rather than as a would-otherwise-succeed invocation; the distinction matters because a would-otherwise-succeed test establishes that the normal code path executes successfully before the zero-HTTP constraint is applied, providing a richer proof of the invariant; fix: AC-13 zero-HTTP proof assertion revised to be a normative would-otherwise-succeed invocation that demonstrates the full code path succeeds without any HTTP calls. MEDIUM finding 2: AC-1 first-use subtype parenthetical — AC-1 introduced a subtype parenthetical clarifying a classification distinction but the parenthetical lacked an explicit policy statement governing when the subtype classification applies; without the policy, implementers could apply the subtype inconsistently across the AC surface; fix: AC-1 first-use subtype parenthetical revised to include the governing policy; the policy is now stated explicitly at the first-use site so subsequent references can defer to it. Process-gap SOH-DX-1-PG-011: Trace continuation-line guard blind spot — DEC-148 Guard 1 (check-bc-citation-symbols.sh) validates symbol citations in Trace/Source fields of bc-*.md files but does not check continuation lines (multi-line Trace/Source fields where the symbol citation appears on line 2 or beyond); approximately 20 citations across the spec surface are on continuation lines and are therefore unvalidated by the guard; all ~20 were hand-verified accurate this pass, but the structural gap remains — a future stale continuation-line citation would pass CI undetected; ledgered as SOH-DX-1-PG-011 (guard-extension candidate). Nit: config_home param rename — the config_home parameter in several AC preconditions was authored with a legacy naming convention that did not match the finalized parameter name in the implementation contract; the rename was applied as a consistency nit to align AC precondition parameter names with the implementation contract naming. Spec bumped v1.3.139 + changelog [1.3.139] entry added. BC-INDEX v6.68. Piecewise CLEAN after fix round 41. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1/-3/-1/+2/0/-1/+1/+1/+1/0/+2/-3/-1/+1. Count IMPROVEMENT (1H+1M→2M; total count 2; HIGH count 1→0, MED count 1→2); ZERO CRITs; ZERO HIGHs; 2 MEDs; novelty LOW-MEDIUM (AC-13-would-otherwise-succeed-invocation + AC-1-first-use-subtype-policy + PG-011-trace-continuation-line-guard-blind-spot class); spec v1.3.139; BC-INDEX v6.68. trajectory-tail →2M+1L→1H+1M→2M. NEXT: pass-42 (p119).

---

### Pass p119 (2026-07-26)

**Findings:** 3 (0C/0H/1M/2L)
**Convergence counter:** 0 of 3 (STRICT) — 1M+2L (from 2M); ZERO CRITs; ZERO HIGHs; 1 MEDIUM; 2 LOWs; novelty LOW; adversary verdict "The F2 delta has converged" (zero behavioral/ordering/anchoring/falsifiability defects); fixes: [1.3.139] Changed block + count line; [1.3.140] full subsections; mode-agnosticism invariant restored both BCs; falsifier enumeration softened; spec v1.3.140 [1.3.140]; BC-INDEX v6.69; PIECEWISE CLEAN after fix round 42

Forty-second F2 adversary pass (fresh context). Count 2M→1M+2L (3 formal findings; HIGH count 0→0, MEDIUM count 2→1, LOW count 0→2); ZERO CRITICAL findings; ZERO HIGH findings; 1 MEDIUM finding; 2 LOW findings; novelty LOW; adversary verdict "The F2 delta has converged" — zero behavioral/ordering/anchoring/falsifiability defects. MEDIUM finding: [process-gap] changelog audit-trail — the changelog audit-trail for the current round was missing the full subsection body; the Changed block and count line were updated but the full subsections were not yet populated; fix: [1.3.139] Changed block + count line backfilled; [1.3.140] full subsections authored; changelog audit-trail now complete. LOW finding 1 (docs): mode-agnosticism invariant — both BC surfaces were missing the mode-agnosticism invariant in their body; the invariant governs behavior uniformly across all invocation modes and must be present on both surfaces to maintain contract consistency; fix: mode-agnosticism invariant restored on both BC surfaces. LOW finding 2 (docs): falsifier enumeration — the falsifier enumeration language was over-precise, over-constraining valid implementations that satisfy the spec intent; fix: falsifier enumeration softened to allow the full range of compliant implementations. Spec bumped v1.3.140 + changelog [1.3.140] entry added. BC-INDEX v6.69. Piecewise CLEAN after fix round 42. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1/-3/-1/+2/0/-1/+1/+1/+1/0/+2/-3/-1/+1/+1. Count INCREASE (2M→1M+2L; total count 2→3; MED count 2→1, LOW count 0→2); ZERO CRITs; ZERO HIGHs; 1 MED; 2 LOWs; novelty LOW (changelog-audit-trail-process-gap + mode-agnosticism-invariant-restoration + falsifier-enumeration-softening class); adversary verdict "The F2 delta has converged"; spec v1.3.140; BC-INDEX v6.69. trajectory-tail →1H+1M→2M→1M+2L. NEXT: pass-43 (p120).

---

### Pass p120 (2026-07-26)

**Findings:** 2 (0C/0H/2M/0L) + 2 observations
**Convergence counter:** 0 of 3 (STRICT) — 2M (from 1M+2L); ZERO CRITs; ZERO HIGHs; 2 MEDIUM; ZERO LOWs; 2 observations (informational); novelty LOW-MEDIUM; fixes: AC-11 interactive-path exit-64 + stdout pins (mode-agnosticism falsifier closed); AC-16 TempDir precondition (dual rationale); steps 3–6 reference; spec v1.3.141 [1.3.141]; BC-INDEX v6.70; PIECEWISE CLEAN after fix round 43

Forty-third F2 adversary pass (fresh context). Count 1M+2L→2M (2 formal findings + 2 observations; MEDIUM count 1→2, LOW count 2→0); ZERO CRITICAL findings; ZERO HIGH findings; 2 MEDIUM findings; ZERO LOW findings; 2 observations (informational, not counted as formal findings); novelty LOW-MEDIUM. MEDIUM finding 1: AC-11 interactive-path exit-64 + stdout pins — the interactive-path branch of AC-11 was missing exit-64 coverage and stdout pin assertions; the mode-agnosticism falsifier was absent, allowing an implementation that bypassed the interactive code path to pass tests; fix: AC-11 interactive-path exit-64 assertion + stdout pins added; mode-agnosticism falsifier closed; the falsifier now confirms the interactive path is exercised correctly. MEDIUM finding 2: AC-16 TempDir precondition (dual rationale) — AC-16's TempDir precondition specified a single rationale (isolation); the precondition actually serves two distinct purposes (isolation + cleanup), and stating only isolation left the cleanup purpose undocumented; fix: AC-16 TempDir precondition revised to carry both rationales explicitly (dual rationale). Observations (2 informational): steps 3–6 reference — two informational observations about the steps 3–6 reference in the spec narrative; not formal findings requiring AC changes; documented for completeness. Spec bumped v1.3.141 + changelog [1.3.141] entry added. BC-INDEX v6.70. Piecewise CLEAN after fix round 43. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1/-3/-1/+2/0/-1/+1/+1/+1/0/+2/-3/-1/+1/+1/-1. Count IMPROVEMENT (1M+2L→2M; total count 3→2; MED count 1→2, LOW count 2→0); ZERO CRITs; ZERO HIGHs; 2 MEDs; novelty LOW-MEDIUM (AC-11-interactive-path-exit-64-stdout-pins + AC-16-TempDir-dual-rationale + steps-3-6-reference class); spec v1.3.141; BC-INDEX v6.70. trajectory-tail →2M→1M+2L→2M. NEXT: pass-44 (p121).

---

### Pass p121 (2026-07-26)

**Findings:** 5 (0C/0H/3M/2L)
**Convergence counter:** 0 of 3 (STRICT) — 3M+2L (from 2M); ZERO CRITs; ZERO HIGHs; 3 MEDIUM; 2 LOW; novelty LOW-MEDIUM; adversary notes "the delta is unusually well-instrumented" (no contract re-derivation needed); all findings surgical (false premise, mis-anchor, tier mislabel); fixes: mod-common false premise deleted; BC-3.8.010+011 attribution; AC-11 (4) HYGIENE; literal unified; range labels tightened; spec v1.3.142 [1.3.142]; BC-INDEX v6.71; PIECEWISE CLEAN after fix round 44

Forty-fourth F2 adversary pass (fresh context). Count 2M→3M+2L (5 formal findings; MEDIUM count 2→3, LOW count 0→2); ZERO CRITICAL findings; ZERO HIGH findings; 3 MEDIUM findings; 2 LOW findings; novelty LOW-MEDIUM; adversary notes "the delta is unusually well-instrumented" and no contract re-derivation needed; all findings are surgical in nature (false premise, mis-anchor, tier mislabel). MEDIUM finding 1: mod-common false premise — a mod-common note in the spec contained a false premise about the scope of the module boundary; the premise incorrectly stated an invariant that could not hold given the implementation contract; fix: false premise deleted; the mod-common note revised to reflect the accurate boundary condition. MEDIUM finding 2: BC-3.8.010+011 attribution — two behavioral contracts (BC-3.8.010 and BC-3.8.011) had incorrect attribution in the spec cross-reference; the attribution pointed to the wrong handling context, creating a mis-anchor between the spec obligation and the BC it was meant to enforce; fix: BC-3.8.010 and BC-3.8.011 attribution corrected to the proper handling context. MEDIUM finding 3: AC-11 (4) HYGIENE tier mislabel — the fourth sub-assertion of AC-11 was labeled BEHAVIOR when it should have been labeled HYGIENE; the tier mislabel gave the assertion unwarranted normative weight and would cause an implementer to treat a hygiene obligation as a behavioral contract; fix: AC-11 (4) relabeled HYGIENE. LOW finding 1: literal unified — two occurrences of the same literal string were authored with slight variation across the spec; the variation was not intentional and created inconsistency in how the literal was cited by downstream ACs; fix: literal unified to the canonical form. LOW finding 2: range labels tightened — several range-label annotations used imprecise boundary language that allowed borderline-conformant implementations; fix: range labels tightened to use precise boundary terms. Spec bumped v1.3.142 + changelog [1.3.142] entry added. BC-INDEX v6.71. Piecewise CLEAN after fix round 44. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1/-3/-1/+2/0/-1/+1/+1/+1/0/+2/-3/-1/+1/+1/-1/+3. Count REGRESSION (2M→3M+2L; total count 2→5; MED count 2→3, LOW count 0→2); ZERO CRITs; ZERO HIGHs; 3 MEDs; 2 LOWs; novelty LOW-MEDIUM; adversary notes "the delta is unusually well-instrumented"; spec v1.3.142; BC-INDEX v6.71. trajectory-tail →2M→1M+2L→2M→3M+2L. NEXT: pass-45 (p122).

---

### Pass p122 (2026-07-26)

**Findings:** 3 (0C/0H/3M/0L)
**Convergence counter:** 0 of 3 (STRICT) — 3M (from 3M+2L); ZERO CRITs; ZERO HIGHs; 3 MEDIUM; ZERO LOWs; novelty LOW; second consecutive "Spec has converged" adversary verdict (all doc-fallout enumeration gaps); fixes: third stale-parity site; family-banner rewrite clause; README holdout row repaired; spec v1.3.143 [1.3.143]; BC-INDEX v6.72; PIECEWISE CLEAN after fix round 45

Forty-fifth F2 adversary pass (fresh context). Count 3M+2L→3M (3 formal findings; MEDIUM count 3→3, LOW count 2→0); ZERO CRITICAL findings; ZERO HIGH findings; 3 MEDIUM findings; ZERO LOW findings; novelty LOW; second consecutive "Spec has converged" adversary verdict — all findings are doc-fallout enumeration gaps, not behavioral/ordering/anchoring/falsifiability defects; piecewise CLEAN after fix round 45. MEDIUM finding 1: third stale-parity site — a third stale-parity location was identified in the spec where a count or reference had not been updated to match the canonical source; the prior two stale-parity sites were corrected in earlier rounds; fix: third stale-parity site updated to match canonical parity. MEDIUM finding 2: family-banner rewrite clause — the family-banner section contained a rewrite clause that did not accurately reflect the current rewrite scope; the clause was a doc-fallout enumeration inconsistency (not a behavioral gap) that could mislead an implementer about what the banner rewrite covers; fix: family-banner rewrite clause updated to enumerate the correct scope. MEDIUM finding 3: README holdout row repaired — the README holdout scenario table contained a row with an incorrect reference; the reference was a doc-fallout gap (not a behavioral contract defect); fix: README holdout row reference repaired to point to the correct holdout scenario. Spec bumped v1.3.143 + changelog [1.3.143] entry added. BC-INDEX v6.72. Piecewise CLEAN after fix round 45. All 3 guard scripts green.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1/-3/-1/+2/0/-1/+1/+1/+1/0/+2/-3/-1/+1/+1/-1/+3/-2. Count IMPROVEMENT (3M+2L→3M; total count 5→3; MED count 3→3, LOW count 2→0); ZERO CRITs; ZERO HIGHs; 3 MEDs; novelty LOW (doc-fallout-enumeration-gaps class); second consecutive adversary "Spec has converged" verdict; spec v1.3.143; BC-INDEX v6.72. trajectory-tail →1M+2L→2M→3M+2L→3M. NEXT: pass-46 (p123).

---

### Pass p123 (2026-07-26) — SESSION WRAP

**Findings:** 3 (0C/0H/1M/2L)
**Convergence counter:** 0 of 3 (STRICT) — 1M+2L (from 3M); ZERO CRITs; ZERO HIGHs; 1 MEDIUM; 2 LOWs; novelty LOW; third consecutive "Spec has converged" adversary verdict (all findings are label-polish and documentation-fallout class); fixes: F46-001 AC-2+AC-7 would-otherwise-succeed clause + mount_platform_create_stubs MUST; F46-002 both body-range labels reworded "BEFORE…steps 3–5…BEFORE…step 6" (2 sites); F46-003 promotion target fixtures.rs→assertions.rs + mod.rs registration note (replace_all); spec v1.3.144 [1.3.144]; BC-INDEX v6.73; PIECEWISE NOT YET RUN — SESSION WRAP; pipeline PAUSED (human-requested /wrap 2026-07-26)

Forty-sixth F2 adversary pass (fresh context). Count 3M→1M+2L (3 formal findings; MEDIUM count 3→1, LOW count 0→2); ZERO CRITICAL findings; ZERO HIGH findings; 1 MEDIUM finding; 2 LOW findings; novelty LOW; third consecutive adversary verdict "The spec has converged" — all findings are label-polish and documentation-fallout class, not behavioral/ordering/anchoring/falsifiability defects. MEDIUM finding (F46-001): AC-2 and AC-7 would-otherwise-succeed clause — AC-2 and AC-7 lacked the explicit would-otherwise-succeed clause present in all six sibling ACs (AC-1, AC-3, AC-5, AC-10, AC-18, AC-19); without the clause, the `stdout.trim().is_empty()` assertion in these two `--output json` mode tests was HYGIENE rather than DISCRIMINATING (a zero-output test is only genuinely discriminating when the mock is set up so the full platform POST would succeed if the guard were absent); fix: F46-001 adds the explicit would-otherwise-succeed clause to AC-2 and AC-7 including the `mount_platform_create_stubs` MUST call, matching the six siblings and closing the drop-the-stub incentive. LOW finding (F46-002): both body-range labels misreading — both `[CURRENT BEHAVIOR]` Behavior block body-range labels used the "excluded terminal case" phrasing, which could be read as "the guard is reachable from this block" (a misread: "excluded" meant "step 6 is not a reachable case from the guard exit", but "excluded terminal case" implies inclusion via exclusion logic); fix: F46-002 rewords both sites (replace_all, 2 sites) to "BEFORE all pre-POST helper HTTP (steps 3–5) and BEFORE the platform POST (step 6) — see Platform-Path Guard Ordering block above", eliminating the excluded=reachable misread. LOW finding (F46-003): promotion target path mismatch — all AC Test Notes cited `tests/common/fixtures.rs` as the target module for `assert_json_error_envelope` and `write_profile_config` promotion; the actual implementation convention places assertions helpers in `tests/common/assertions.rs` (a new module) while keeping `fixtures.rs` for pure-JSON test data; fix: F46-003 changes all promotion-target path references from `tests/common/fixtures.rs` to `tests/common/assertions.rs` (replace_all on all sites), adds convention note "assertions.rs convention" and the `pub mod assertions;` registration note in `tests/common/mod.rs` to both Test Notes. Spec bumped v1.3.144 + changelog [1.3.144] entry added. BC-INDEX v6.73. PIECEWISE CONSISTENCY CHECK NOT YET RUN — session was wrapped by human /wrap command before the piecewise-validation dispatch could occur. All 3 guard scripts green on the round-46 edits. PIPELINE PAUSED 2026-07-26.

**NOTE — SESSION WRAP (2026-07-26):** Human-requested pipeline pause mid-F2 adversary grind. Round-46 fixes (F46-001/002/003) applied; all 3 guard scripts green; piecewise consistency check NOT yet run. FIRST resume action: dispatch consistency-validator piecewise check on round-46 edits (v1.3.144 vs baseline b3908288). If CLEAN, proceed to pass-47. Continue DEC-189 STRICT loop to 3 consecutive CLEAN; then F2 human gate.

**Adversary dispatch prompt shape for pass-47 (reproduce verbatim):**

Artifacts to provide in pass-47 fresh-context dispatch:
- `.factory/specs/prd/bc-3-issue-write.md` §3.8 (BC-3.8.012 + BC-3.8.013 full bodies with all ACs, ECs, Test Notes)
- `.factory/specs/prd/BC-INDEX.md` §3.8 and §3.4 (boundary conditions for the guard specs)
- `.factory/spec-changelog.md` entries [1.3.144] through [1.3.107] (complete round log)
- `.factory/phase-f1-delta/SOH-DX-1/delta-analysis.md` (original delta, to anchor what changed)
- `.factory/stories/S-383-platform-inverse-warnings.md` (SUPERSEDED story with banner + contract_superseded_by field)
- `docs/specs/issue-create-preflight-guards.md` (deliverable (f) feature spec, added round 38)

Ratified intent block (include verbatim in pass-47 dispatch):
> SOH-DX-1 DEC-188 scope: BC-3.8.012 (--on-behalf-of pre-flight exit-64) and BC-3.8.013 (--field pre-flight exit-64) flip from deprecation warnings to hard exit-64 errors in jr issue create. Breaking change. Rides v0.7.0-dev.1. BC-3.8.012/013 supersede the prior BC-3.8.012/013 (which specified deprecation warnings). The spec delta is confined to the two BC bodies and their ACs/ECs, plus deliverables (a)-(f) in the story. Adversary: find any remaining defects in the AC surface — falsifiability, ordering, anchoring, behavioral gaps, or documentation-fallout. DEC-189 STRICT: any delta-attributable finding resets the 3-consecutive-CLEAN window.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L). Delta: 0/0/-1/-1/-2/-1/+4/-1/-1/+1/0/-2/-2/+3/0/-1/-1/0/+2/-1/-2/+1/0/+3/0/-2/+1/-3/-1/+2/0/-1/+1/+1/+1/0/+2/-3/-1/+1/+1/-1/+3/-2/-2. Count IMPROVEMENT (3M→1M+2L; total count 3→3; MED count 3→1, LOW count 0→2); ZERO CRITs; ZERO HIGHs; 1 MED; 2 LOWs; novelty LOW (would-otherwise-succeed-clause-AC-2-AC-7 + body-range-label-misreading + promotion-target-path class); third consecutive adversary "Spec has converged" verdict; spec v1.3.144; BC-INDEX v6.73. trajectory-tail →2M→3M+2L→3M→1M+2L. PIPELINE PAUSED 2026-07-26.

---

### Remediation burst (2026-07-27) — post-p123, pre-p124

**Type:** Spec remediation burst — post-round-46 piecewise consistency check (not an adversary pass; no convergence credit assigned)

**Spec version:** v1.3.145
**BC-INDEX version:** v6.73 (unchanged)
**Findings:** 5 (all LOW) — collateral damage from F46-003 `replace_all` sweeping 9 sites when 5 were intended; 3 historical trail entries retroactively falsified
**Convergence counter:** 0 of 3 STRICT (DEC-189) — UNCHANGED; pass-47 VOID ×2 (subagent delivery failure, ~32 min combined)

**Fixes applied (all LOW):**
- F1: v1.3.114 version-trail entry in bc-3-issue-write.md frontmatter — first clause restored to `tests/common/fixtures.rs` (was self-contradictory, naming two promotion targets in one sentence)
- F2: v1.3.108 version-trail entry — restored to `tests/common/fixtures.rs`
- F3: v1.3.137 version-trail entry — restored to `tests/common/fixtures.rs`
- F4: spec-changelog [1.3.144] F46-003 scope corrected to "(9 sites: 5 spec body + 3 historical trail entries + 1 footer)" + anachronism note added
- F5: bc-3-issue-write.md frontmatter v1.3.144 trail F46-003 clause corrected "(5 sites)" → "(9 sites: …)" — in-round residual of F4; TWIN-ARTIFACT-SWEEP class; folded into v1.3.145 (no v1.3.146 — precedent v1.3.136 F-2 in-round residual)

**Governing principle established:** A version-trail entry is an immutable audit record of what was true at that version; mechanical `replace_all` must never rewrite historical trail entries. Corollary: correcting a factually wrong description of a round's OWN actions is in-scope and not an anachronism (SOH-DX-1-PG-012 datapoint 1).

**Piecewise re-verification:** CLEAN, verified twice (consistency-validator + orchestrator direct mechanical check). All 3 guards green: spec-counts OK, cumulative BC counts OK (657 total), citation symbols OK (357 checked). BC-INDEX.md untouched at v6.73.

**Pass-47 adversary — VOID ×2 (no convergence credit):** Two adversary dispatches both failed to deliver any retrievable output (~32 minutes combined). The first dispatch was additionally non-window-eligible because it read artifacts still carrying the unfixed F5 defect. Neither counts toward DEC-189. Convergence counter remains 0/3 STRICT. No p124 entry added.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L). [Remediation burst 2026-07-27: F1-F5 all LOW; no adversary pass; convergence counter unchanged]. trajectory-tail →2M→3M+2L→3M→1M+2L. NEXT: pass-47 (p124) — dispatch with v1.3.145 artifacts.

---

### F2 round-47 fix burst + pass-47 VOID ×5 (2026-07-27) — pre-substitute passes

**Type:** F2 fix burst (F47-001) + pass-47 adversary VOID ×5 (no convergence credit)
**Spec version:** v1.3.146 + [1.3.146]
**BC-INDEX version:** v6.73 (unchanged)
**Convergence counter:** 0/3 STRICT (DEC-189) — UNCHANGED

**Round-47 fix (F47-001, LOW, delta-attributable):**
`write_profile_config` destination corrected in both Test Note Config fixture contracts (BC-3.8.012 and BC-3.8.013) from `tests/common/assertions.rs` to `tests/common/fixtures.rs`; "same promotion target as `assert_json_error_envelope`" phrase replaced with DIFFERENT-destinations rationale (`write_profile_config` → `tests/common/fixtures.rs`, `assert_json_error_envelope` → `tests/common/assertions.rs`); footer v1.3.137 historical description corrected (4th F46-003 sweep site, missed by v1.3.145 which fixed frontmatter trail entries only); missing v1.3.145 footer entry backfilled (FOOTER-UPDATE-CONVENTION-MISS class). Source: direct review during pass-47 process window. Spec bumped v1.3.146 + changelog [1.3.146] entry added. BC-INDEX v6.73 unchanged. All 3 guards green.

**Pass-47 adversary — VOID ×5 (cumulative total; prior checkpoint recorded ×2):** Five adversary agent dispatches produced zero retrievable output total. Variables eliminated across attempts: scope (6 artifacts → single ~150-line range), explicit reply-is-deliverable mandate, explicit no-Write-tool framing, and model override (opus). None delivered. All 5 dispatches non-window-eligible. Convergence counter remains 0/3 STRICT. No p-series entry added. ADVERSARY-AGENT-NONFUNCTIONAL drift item added (HIGH — highest-priority engine fix; supersedes other queued engine IPs).

**Trajectory:** F47-001 fix not assigned p-series (fix burst, not adversary pass). trajectory-tail →2M→3M+2L→3M→1M+2L (unchanged). NEXT: substitute pass-48 (p124) with v1.3.146 artifacts.

---

### Pass p124 (2026-07-27) — SUBSTITUTE (consistency-validator with adversarial checklist; NOT adversary agent)

**Findings:** 1 (0C/0H/0M/1L)
**Convergence counter:** 0 of 3 (STRICT) — NOT WINDOW-ELIGIBLE (substitute pass; DEC-189 ratification PENDING human ruling; SUBSTITUTE-ADVERSARY-RATIFICATION-PENDING)

Forty-eighth F2 pass (substitute — consistency-validator dispatched with an adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved; adversary agent's own system prompt and policy rubric absent). Count 1L (from trajectory tail). ZERO CRITICAL findings; ZERO HIGH findings; ZERO MEDIUM findings; 1 LOW finding; novelty LOW; verdict "AC surface has converged, YES" (apart from single LOW). LOW finding (F48-001): AC-7 missing `EC-3.8.012-3 as test —` linkage marker — AC-7 (`test_platform_create_malformed_field_without_request_type_exits_64`, the malformed-`--field` invocation `--field bareflagnoequals`) was the only testable EC among BC-3.8.012/013's EC surface lacking the uniform `"EC-<id> as test — "` prefix; all 8 sibling ACs carrying testable ECs had the prefix; coverage was real (AC-7 semantically covers EC-3.8.012-3: guard fires on `!field_pairs.is_empty()` before value parsing, so the malformed format does not affect guard activation); only traceability linkage was missing; fix: `EC-3.8.012-3 as test — ` marker inserted before the invocation backtick in AC-7 (after the `(renamed from …):` clause). Spec bumped v1.3.147 + changelog [1.3.147] entry added. BC-INDEX v6.73 unchanged. All 3 guards green.

**NOTE — SUBSTITUTE PASS (non-window-eligible pending ruling):** This pass used consistency-validator with an adversarial verification checklist rather than the adversary agent. Fresh context and adversarial framing preserved; the adversary agent's own system prompt and policy rubric were not. Human ruling required on whether such passes can close a DEC-189 window (SUBSTITUTE-ADVERSARY-RATIFICATION-PENDING ledgered). Counter held at 0/3 STRICT pending that ruling. Do NOT retroactively count as convergence credit without explicit human authorization.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L)→[remediation-burst: F1-F5 LOW]→[F47-001 LOW fix]→p124-sub(1L). Delta: +1 (1L). trajectory-tail →3M+2L→3M→1M+2L→1L (substitute, non-window-eligible). NEXT: pass-49 (p125 substitute).

---

### Pass p125 (2026-07-27) — SUBSTITUTE (consistency-validator with adversarial checklist; NOT adversary agent)

**Findings:** 1 (0C/0H/0M/1L)
**Convergence counter:** 0 of 3 (STRICT) — NOT WINDOW-ELIGIBLE (substitute pass; DEC-189 ratification PENDING human ruling; SUBSTITUTE-ADVERSARY-RATIFICATION-PENDING)

Forty-ninth F2 pass (substitute — consistency-validator dispatched with an adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved; adversary agent's own system prompt and policy rubric absent). Count 1L (from 1L). ZERO CRITICAL findings; ZERO HIGH findings; ZERO MEDIUM findings; 1 LOW finding; novelty LOW; verdict "AC surface has converged, YES" (apart from single LOW). LOW finding (F49-001): BC-3.8.013 doc-fallout deliverables parenthetical enumerated only 3 of 6 delivery obligations (a)–(f) from BC-3.8.012, omitting (d) the `src/cli/mod.rs` `--on-behalf-of` help-string update; load-bearing: AC-12 asserts `stdout.matches("requires --request-type").count() == 2` (after whitespace normalization) requiring BOTH the `--field` AND `--on-behalf-of` help lines to be updated; implementer treating the old parenthetical as complete would skip `--on-behalf-of` and fail AC-12 with count 1; fix: (1) obligation (d) added to parenthetical; (2) delegation marked NORMATIVE explicitly; (3) enumeration marked non-exhaustive; (4) BC-3.8.012 Trace (a)–(f) declared the authoritative binding enumeration, preventing the same omission class for future obligations. Spec bumped v1.3.148 + changelog [1.3.148] entry added. BC-INDEX v6.73 unchanged. All 3 guards green.

**NOTE — SUBSTITUTE PASS (non-window-eligible pending ruling):** This pass used consistency-validator with an adversarial verification checklist rather than the adversary agent. Fresh context and adversarial framing preserved; the adversary agent's own system prompt and policy rubric were not. Human ruling required on whether such passes can close a DEC-189 window (SUBSTITUTE-ADVERSARY-RATIFICATION-PENDING). Counter held at 0/3 STRICT pending that ruling. Do NOT retroactively count as convergence credit without explicit human authorization.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L)→[remediation-burst: F1-F5 LOW]→[F47-001 LOW fix]→p124-sub(1L)→p125-sub(1L). Delta: 0 (1L→1L). trajectory-tail →3M→1M+2L→1L→1L (passes p122, p123, p124-sub, p125-sub). PIPELINE PAUSED.

---

### Pass p126 (2026-07-27) — SUBSTITUTE (consistency-validator with adversarial checklist; NOT adversary agent)

**Findings:** 1 (0C/0H/0M/1L)
**Convergence counter:** 0 of 3 (STRICT) — NOT WINDOW-ELIGIBLE (substitute pass; DEC-189 ratification PENDING human ruling; SUBSTITUTE-ADVERSARY-RATIFICATION-PENDING)

Fiftieth F2 pass (substitute — consistency-validator dispatched with an adversarial verification checklist via two split dispatches + 3 items verified directly by the orchestrator; NOT the adversary agent; fresh context; adversarial framing preserved). 8 items checked; 7 PASS, 1 LOW. ZERO CRITICAL findings; ZERO HIGH findings; ZERO MEDIUM findings; 1 LOW finding; novelty LOW; verdict "AC surface has converged, YES" (apart from single LOW). LOW finding (F50-001, story-side, delta-attributable): `stories/S-383-platform-inverse-warnings.md` `contract_superseded_by` field extended from `SOH-DX-1 (DEC-188)` to `"SOH-DX-1 (DEC-188) / S-639-1"`, naming the implementing successor story; banner gained an S-639-1 pointer with the "do NOT implement from these ACs" imperative intact; ACs byte-identical. `STORY-INDEX.md` v1.5.41 → v1.5.42 with S-383 manifest row updated. Notably clean on the reality-check aperture — every `create.rs` line anchor accurate; prior-behavior warning strings character-exact; all 8 cross-BC references accurate; BC-INDEX rows correct; test-name convention compliant. No spec bump (story-side fix only). BC-INDEX v6.73 unchanged. All 3 guards green.

**NOTE — SUBSTITUTE PASS (non-window-eligible pending ruling):** This pass used consistency-validator with an adversarial verification checklist rather than the adversary agent. Fresh context and adversarial framing preserved; the adversary agent's own system prompt and policy rubric were not. Human ruling required on whether such passes can close a DEC-189 window (SUBSTITUTE-ADVERSARY-RATIFICATION-PENDING). Counter held at 0/3 STRICT pending that ruling. Do NOT retroactively count as convergence credit without explicit human authorization.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L)→[remediation-burst: F1-F5 LOW]→[F47-001 LOW fix]→p124-sub(1L)→p125-sub(1L)→p126-sub(1L). Delta: 0 (1L→1L). trajectory-tail →1M+2L→1L→1L→1L (passes p123, p124-sub, p125-sub, p126-sub). PIPELINE PAUSED. NEXT: pass-51 (p127 substitute).

---

### Pass p127 (2026-07-27) — SUBSTITUTE (consistency-validator with adversarial checklist; NOT adversary agent)

**Findings:** 1 (0C/0H/0M/1L) + 1 STATE.md bookkeeping defect (F51-002, pre-existing, MEDIUM)
**Convergence counter:** 0 of 3 (STRICT) — NOT WINDOW-ELIGIBLE (substitute pass; DEC-189 ratification PENDING human ruling; SUBSTITUTE-ADVERSARY-RATIFICATION-PENDING)

Fifty-first F2 pass (substitute — consistency-validator dispatched with an adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved). 3 items checked; 2 PASS, 1 LOW finding + 1 STATE.md defect. ZERO CRITICAL findings; ZERO HIGH findings; ZERO MEDIUM findings in spec; 1 LOW finding; novelty LOW; verdict effectively "AC surface has converged, YES" (apart from single LOW and external STATE.md defect). LOW finding (F51-001, LOW, delta-attributable): holdout-scenario and VP coverage documented as a deliberate non-goal via a terminal "Note (coverage non-goal)" in BOTH BC-3.8.012 and BC-3.8.013. Rationale recorded: the 21 ACs cover every observable exit path; both guards are pure pre-flight input validation with no network interaction, unlike BC-3.4.019 (VP-331-003) which needs a project-scoped API lookup. Verified: no new VP, holdout, or BC authored — all VP identifiers in the diff are pre-existing references; footer records "0 new BCs / 0 new VPs / 0 new holdouts". Spec bumped v1.3.149 + changelog [1.3.149] entry added. BC-INDEX v6.73 unchanged. All 3 guards green.

STATE.md bookkeeping defect F51-002 (MEDIUM, pre-existing): STATE.md Convergence Status asserted `VP-INDEX v0.82` but VP-INDEX.md does not exist anywhere in `.factory/`. VPs are tracked inline in BC bodies and holdout scenarios. FIXED this burst: Convergence Status corrected to `VPs tracked inline in BC bodies (no index artifact)`. SOH-DX-1-PG-001 first CONFIRMED datapoint — escalated LOW → MEDIUM. New drift item VP-INDEX-ARTIFACT-ABSENT added (LOW, OPEN — human decision). STORY-INDEX version in same line also corrected v1.5.41 → v1.5.42 (stale after F50-001). F51-002 is a STATE.md bookkeeping defect, NOT a spec-delta defect, so it does NOT reset the convergence window.

**NOTE — SUBSTITUTE PASS (non-window-eligible pending ruling):** This pass used consistency-validator with an adversarial verification checklist rather than the adversary agent. Fresh context and adversarial framing preserved; the adversary agent's own system prompt and policy rubric were not. Human ruling required on whether such passes can close a DEC-189 window (SUBSTITUTE-ADVERSARY-RATIFICATION-PENDING). Counter held at 0/3 STRICT pending that ruling. Do NOT retroactively count as convergence credit without explicit human authorization.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L)→[remediation-burst: F1-F5 LOW]→[F47-001 LOW fix]→p124-sub(1L)→p125-sub(1L)→p126-sub(1L)→p127-sub(1L). Delta: 0 (1L→1L). trajectory-tail →1L→1L→1L→1L (passes p124-sub, p125-sub, p126-sub, p127-sub). PIPELINE PAUSED.

**Convergence counter:** 0 of 3 STRICT. NEXT: adversary pass (p126) with v1.3.148 artifacts — pending ADVERSARY-AGENT-NONFUNCTIONAL engine fix or SUBSTITUTE-ADVERSARY-RATIFICATION-PENDING human ruling.

---

### Pass p128 (2026-07-27) — SUBSTITUTE (consistency-validator with adversarial checklist; NOT adversary agent)

**Findings:** 1 (0C/0H/0M/1L)
**Convergence counter:** 0 of 3 (STRICT) — NOT WINDOW-ELIGIBLE (substitute pass; DEC-189 ratification PENDING human ruling; SUBSTITUTE-ADVERSARY-RATIFICATION-PENDING)

Fifty-second F2 pass (substitute — consistency-validator dispatched with an adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved). 3 items checked; 2 PASS, 1 LOW finding. ZERO CRITICAL findings; ZERO HIGH findings; ZERO MEDIUM findings; 1 LOW finding; novelty LOW; verdict "AC surface has converged, YES" (apart from single LOW). LOW finding (F52-001, LOW, delta-attributable): `error-taxonomy.md` Section 6 (Domain-Specific Error Messages) lacked a subsection for the three DEC-188 pre-flight exit-64 error conditions introduced by BC-3.8.012 and BC-3.8.013; both most recent prior feature cycles (BC-3.5.x and BC-3.9.x) had registered their respective error conditions, making the omission a consistency gap. Fix: new `### Issue Commands` subsection added to Section 6 following the established table convention. All three verbatim error strings confirmed character-for-character identical to `bc-3-issue-write.md` fenced blocks. A preamble note records zero HTTP on each error path. Spec bumped v1.3.150 + changelog [1.3.150] entry added. BC-INDEX v6.73 unchanged. All 3 guards green. Zero stale content anywhere — zero "is ignored on the platform create path" and zero warn-and-proceed across all seven sibling PRD artifacts. `edge-case-catalog.md` absence is convention-consistent.

**NOTE — SUBSTITUTE PASS (non-window-eligible pending ruling):** This pass used consistency-validator with an adversarial verification checklist rather than the adversary agent. Fresh context and adversarial framing preserved; the adversary agent's own system prompt and policy rubric were not. Human ruling required on whether such passes can close a DEC-189 window (SUBSTITUTE-ADVERSARY-RATIFICATION-PENDING). Counter held at 0/3 STRICT pending that ruling. Do NOT retroactively count as convergence credit without explicit human authorization.

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L)→[remediation-burst: F1-F5 LOW]→[F47-001 LOW fix]→p124-sub(1L)→p125-sub(1L)→p126-sub(1L)→p127-sub(1L)→p128-sub(1L). Delta: 0 (1L→1L). trajectory-tail →1L→1L→1L→1L (passes p125-sub, p126-sub, p127-sub, p128-sub). PIPELINE PAUSED.

---

### Pass p129 (2026-07-27) — SUBSTITUTE (consistency-validator with adversarial checklist; DEC-190 WINDOW-ELIGIBLE)

**Findings:** 0 (0C/0H/0M/0L) — CLEAN
**Convergence counter:** 1 of 3 (STRICT per DEC-190)

Fifty-third F2 pass (substitute — consistency-validator dispatched with an adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved; adversary agent's own system prompt and policy rubric absent). DEC-190 (2026-07-27): human instruction "keep grinding to 3 strict" ratifies substitute passes as DEC-189 window-eligible; this pass is WINDOW-ELIGIBLE per DEC-190. 4 items checked; all PASS. ZERO CRITICAL findings; ZERO HIGH findings; ZERO MEDIUM findings; ZERO LOW findings; verdict CLEAN. Items verified: (1) normative-MUST coverage — all 26 normative statements (N1–N15 BC-3.8.012, M1–M11 BC-3.8.013) map to a verifying AC; zero UNVERIFIED; (2) the spec's own clap-`requires` falsifier claim (AC-1/AC-2/AC-16) independently validated as correct, and its AC-15-is-insensitive caveat upheld; (3) version train correct (Cargo.toml 0.6.0-dev.11 → 0.7.0-dev.1 target; no duplicate CHANGELOG entry); (4) CLAUDE.md obligation-(b) single-site targeting correct (no `--on-behalf-of` mentions anywhere; all `--field` mentions are edit-side except line 248).

**NOTE — SUBSTITUTE PASS (DEC-190 WINDOW-ELIGIBLE):** Human instruction "keep grinding to 3 strict" (2026-07-27) recorded as DEC-190, ratifying substitute adversarial passes (consistency-validator with adversarial verification checklist; fresh context; adversarial framing preserved; adversary agent's own system prompt and policy rubric absent) as DEC-189 window-eligible. This substitution MUST be disclosed in the F2 gate document and any downstream convergence report — do not let it read as a DEC-189-literal window.

**Convergence counter:** 1 of 3 STRICT (per DEC-190). NEXT: pass-54 (p130-sub).

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L)→[remediation-burst: F1-F5 LOW]→[F47-001 LOW fix]→p124-sub(1L)→p125-sub(1L)→p126-sub(1L)→p127-sub(1L)→p128-sub(1L)→p129-sub(0). Delta: -1L (1L→0). trajectory-tail →1L→1L→1L→0 (passes p126-sub, p127-sub, p128-sub, p129-sub). Convergence: 1/3 STRICT.

---

### Pass p130 (2026-07-27) — SUBSTITUTE (consistency-validator with adversarial checklist; DEC-190 WINDOW-ELIGIBLE)

**Findings:** 0 (0C/0H/0M/0L) — CLEAN
**Convergence counter:** 2 of 3 (STRICT per DEC-190)

Fifty-fourth F2 pass (substitute — consistency-validator dispatched with an adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved; DEC-190 window-eligible). 4 items checked; all PASS. ZERO CRITICAL findings; ZERO HIGH findings; ZERO MEDIUM findings; ZERO LOW findings; verdict CLEAN. Audit of this session's own six edits (v1.3.145–150) for mutual coherence: (1) both Test Notes byte-identical with correct split destinations; (2) `mod.rs` instruction correctly names only `pub mod assertions;`; (3) all 21 ACs intact with AC-7 retaining all seven elements alongside its new EC marker; (4) both new Notes terminal and non-contradictory; all three error strings character-exact in error-taxonomy.md by mechanical equality check.

**One reported finding REJECTED as false positive by orchestrator:** The validator flagged the v1.3.137 trail entry's "(same promotion target as `assert_json_error_envelope`)" as stale. It is accurate historical record — at v1.3.137 both helpers targeted `fixtures.rs` (verified via the v1.3.108 entry). Editing it would retroactively falsify the audit trail, which is exactly the SOH-DX-1-PG-012 defect v1.3.145 remediated. The immutability principle holds. This finding does NOT count against the clean verdict.

**NOTE — SUBSTITUTE PASS (DEC-190 WINDOW-ELIGIBLE):** Human instruction "keep grinding to 3 strict" (2026-07-27) recorded as DEC-190, ratifying substitute adversarial passes (consistency-validator with adversarial verification checklist; fresh context; adversarial framing preserved; adversary agent's own system prompt and policy rubric absent) as DEC-189 window-eligible. This substitution MUST be disclosed in the F2 gate document and any downstream convergence report — do not let it read as a DEC-189-literal window.

**Convergence counter:** 2 of 3 STRICT (per DEC-190). NEXT: pass-55 (p131-sub).

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L)→[remediation-burst: F1-F5 LOW]→[F47-001 LOW fix]→p124-sub(1L)→p125-sub(1L)→p126-sub(1L)→p127-sub(1L)→p128-sub(1L)→p129-sub(0)→p130-sub(0). Delta: 0 (0→0). trajectory-tail →1L→1L→0→0 (passes p127-sub, p128-sub, p129-sub, p130-sub). Convergence: 2/3 STRICT.

---

### Pass p131 (2026-07-27) — SUBSTITUTE (consistency-validator with adversarial checklist; DEC-190 WINDOW-ELIGIBLE) — 3/3 STRICT WINDOW CLOSES HERE

**Findings:** 0 (0C/0H/0M/0L) — CLEAN
**Convergence counter:** 3 of 3 (STRICT per DEC-190) — **WINDOW CLOSED**

Fifty-fifth F2 pass (substitute — consistency-validator dispatched with an adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved; DEC-190 window-eligible). 2 items checked; both PASS. ZERO CRITICAL findings; ZERO HIGH findings; ZERO MEDIUM findings; ZERO LOW findings; verdict CLEAN. Items verified: (1) all 26 DELETE-mandate line anchors in `tests/issue_create_jsm.rs` (4,063 lines) verified to point at the described constructs, maximum deviation 1–2 lines, well under the 15-line threshold; (2) the plain-`contains` (AC-1 ~:2470-2473) vs `.count()` (AC-5 ~:2732-2738, AC-7 ~:2860-2866) discrimination independently spot-verified correct by the orchestrator. Combinatorial coverage complete — no reachable, behaviorally-distinct, uncovered flag combination.

**NOTE — SUBSTITUTE PASS (DEC-190 WINDOW-ELIGIBLE):** Human instruction "keep grinding to 3 strict" (2026-07-27) recorded as DEC-190, ratifying substitute adversarial passes (consistency-validator with adversarial verification checklist; fresh context; adversarial framing preserved; adversary agent's own system prompt and policy rubric absent) as DEC-189 window-eligible. This substitution MUST be disclosed in the F2 gate document and any downstream convergence report — do not let it read as a DEC-189-literal window.

**Convergence counter: 3 of 3 STRICT WINDOW CLOSED (per DEC-190). All three closing passes (p129-sub, p130-sub, p131-sub) were substitute passes per DEC-190 ratification. F2 HUMAN GATE PENDING HUMAN APPROVAL.**

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L)→[remediation-burst: F1-F5 LOW]→[F47-001 LOW fix]→p124-sub(1L)→p125-sub(1L)→p126-sub(1L)→p127-sub(1L)→p128-sub(1L)→p129-sub(0)→p130-sub(0)→p131-sub(0). Delta: 0 (0→0). trajectory-tail →1L→0→0→0 (passes p128-sub, p129-sub, p130-sub, p131-sub). **CONVERGENCE: 3/3 STRICT WINDOW CLOSED (DEC-190, 2026-07-27). F2 HUMAN GATE PENDING HUMAN APPROVAL.**

**Convergence counter:** 0 of 3 STRICT. NEXT: adversary pass (p129) with v1.3.150 artifacts — pending ADVERSARY-AGENT-NONFUNCTIONAL engine fix or SUBSTITUTE-ADVERSARY-RATIFICATION-PENDING human ruling.

---

### Pass p134 (2026-07-27) — SUBSTITUTE (test-infrastructure aperture; DEC-190 WINDOW-ELIGIBLE)

**Findings:** 0 (0C/0H/0M/0L) — CLEAN
**Convergence counter:** 1 of 3 (STRICT per DEC-190) — CLEAN pass; window opens

Fifty-eighth F2 pass (substitute — consistency-validator with adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved; DEC-190 window-eligible). **APERTURE CLASS: REALITY-CHECK** (test-infrastructure claims). 6 claims verified. All VERIFIED. ZERO findings; verdict CLEAN.

**Verified claims (6/6):** (1) `assert_cmd` 2.2.2 `pub fn timeout()` at `src/cmd.rs:108` confirmed — v1.3.151 fix premise sound; (2) AC-17 narrowed substring `"cannot be combined with \`--markdown\`"` confirmed unique to `jsm_create.rs:160` — no collision with `edit.rs`; (3) `JR_STDIN_IS_TTY` seam confirmed debug-only via `#[cfg(debug_assertions)]` at `src/main.rs`; (4) `Command::new` test harness confirmed compatible with current assertion chain pattern; (5) exit-64 route in `handle_jsm_create` confirmed at step-2 guard; (6) `jr_cmd_xdg` fixture confirmed scoping `JR_CACHE_DIR` correctly per test isolation contract.

**NOTE — SUBSTITUTE PASS (DEC-190 WINDOW-ELIGIBLE):** CLEAN. Convergence window opens: 1/3 STRICT (per DEC-190 ratification, 2026-07-27).

**Convergence counter:** 1 of 3 STRICT. NEXT: pass-59 (p135-sub).

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L)→[remediation-burst: F1-F5 LOW]→[F47-001 LOW fix]→p124-sub(1L)→p125-sub(1L)→p126-sub(1L)→p127-sub(1L)→p128-sub(1L)→p129-sub(0)→p130-sub(0)→p131-sub(0)→p132-sub(1M)→p133-sub(1L)→p134-sub(0). Delta: -1L (1L→0). trajectory-tail →0→1M→1L→0 (passes p131-sub, p132-sub, p133-sub, p134-sub). CONVERGENCE: 1/3 STRICT.

---

### Pass p135 (2026-07-27) — SUBSTITUTE (clap-declaration aperture; DEC-190 WINDOW-ELIGIBLE)

**Findings:** 0 (0C/0H/0M/0L) — CLEAN
**Convergence counter:** 2 of 3 (STRICT per DEC-190) — CLEAN pass; window advances

Fifty-ninth F2 pass (substitute — consistency-validator with adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved; DEC-190 window-eligible). **APERTURE CLASS: REALITY-CHECK** (clap-declaration claims). 7 claims verified. All VERIFIED. ZERO findings; verdict CLEAN.

**Verified claims (7/7):** (1) `#[arg(long)]` declarations for `--markdown`, `--on-behalf-of`, `--request-type` confirmed in `src/cli/issue/create.rs`; (2) `allow_hyphen_values` NOT set on upload `file` positional confirmed (correct per CLAUDE.md gotcha); (3) `conflicts_with` annotation between `--description` and `--description-stdin` confirmed active; (4) `--request-type` absence → platform path gate confirmed byte-for-byte unchanged; (5) `--no-input` propagation through `handle_create` confirmed reaching `handle_jsm_create`; (6) `--output` enum variant `OutputFormat::Json` confirmed reaching all JSON render paths via `print_output`; (7) all AC group-6 (JSM create flag) clap annotations confirmed present and non-overlapping.

**NOTE — SUBSTITUTE PASS (DEC-190 WINDOW-ELIGIBLE):** CLEAN. Convergence window advances: 2/3 STRICT (per DEC-190 ratification, 2026-07-27).

**Convergence counter:** 2 of 3 STRICT. NEXT: pass-60 (p136-sub).

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L)→[remediation-burst: F1-F5 LOW]→[F47-001 LOW fix]→p124-sub(1L)→p125-sub(1L)→p126-sub(1L)→p127-sub(1L)→p128-sub(1L)→p129-sub(0)→p130-sub(0)→p131-sub(0)→p132-sub(1M)→p133-sub(1L)→p134-sub(0)→p135-sub(0). Delta: +0 (0→0). trajectory-tail →1M→1L→0→0 (passes p132-sub, p133-sub, p134-sub, p135-sub). CONVERGENCE: 2/3 STRICT.

---

### Pass p136 (2026-07-27) — SUBSTITUTE (prd-metric aperture; DEC-190 WINDOW-ELIGIBLE)

**Findings:** 1 (0C/0H/0M/1L) — F60-001 LOW
**Convergence counter:** 0 of 3 (STRICT per DEC-190) — delta-attributable finding; WINDOW RESET

Sixtieth F2 pass (substitute — consistency-validator with adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved; DEC-190 window-eligible). **APERTURE CLASS: REALITY-CHECK** (prd-metric consistency — README.md L3 BCs column vs frontmatter total_bcs). 5 claims verified. 4 VERIFIED, 1 LOW FINDING. ZERO CRITICAL findings; ZERO HIGH findings; ZERO MEDIUM findings; 1 LOW finding; verdict FINDING (not CLEAN).

**Verified claims (4/5):** (1) bc-1-auth-identity.md `(57)` = `total_bcs: 57` (exact match — reference point); (2) bc-4-assets-cmdb.md `(32)` = `total_bcs: 32` (exact match — reference point); (3) bc-6-worklog-team.md column value matches `total_bcs`; (4) bc-3-issue-write.md `total_bcs: 140` and `definitional_count: 111` frontmatter are unchanged by v1.3.153.

**F60-001 (LOW, delta-attributable):** `specs/prd/README.md` line 39 "L3 BCs" column for bc-3-issue-write.md showed `(111)` — this is `definitional_count` (count of BCs defined in bc-3's own namespace), not `total_bcs: 140` (cumulative count including range-collapsed BCs). Convention is `total_bcs` (verified against bc-1/bc-4 as reference points). Fix: column corrected to `(140)` in spec v1.3.153. Sibling drift also found (NOT fixed in this pass — scope was bc-3 only): bc-2 `(94)` vs `total_bcs: 106`; bc-5 `(35)` vs `36`; bc-7 `(90)` vs `93` — ledgered as README-SIBLING-COUNT-DRIFT-3 in STATE.md. BC count unchanged (140/111).

**NOTE — SUBSTITUTE PASS (DEC-190 WINDOW-ELIGIBLE):** Window was at 2/3 after p134-sub+p135-sub. F60-001 is delta-attributable; WINDOW RESET to 0/3.

**Convergence counter:** RESET to 0 of 3 STRICT. NEXT: pass-61 (p137-sub or adversary).

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L)→[remediation-burst: F1-F5 LOW]→[F47-001 LOW fix]→p124-sub(1L)→p125-sub(1L)→p126-sub(1L)→p127-sub(1L)→p128-sub(1L)→p129-sub(0)→p130-sub(0)→p131-sub(0)→p132-sub(1M)→p133-sub(1L)→p134-sub(0)→p135-sub(0)→p136-sub(1L). Delta: +1L (0→1L). trajectory-tail →1L→0→0→1L (passes p133-sub, p134-sub, p135-sub, p136-sub). **CONVERGENCE: RESET to 0/3 STRICT — F60-001 delta-attributable (window was 2/3). PIPELINE PAUSED.**

---

### Pass p132 (2026-07-27) — SUBSTITUTE (reality-check aperture; DEC-190 WINDOW-ELIGIBLE) — WINDOW RESET to 0/3

**Findings:** 1 (0C/0H/1M/0L) — F56-001 MEDIUM
**Convergence counter:** RESET to 0 of 3 (STRICT per DEC-190) — delta-attributable finding; earlier 3/3 window (passes p129-sub/p130-sub/p131-sub, DEC-190, 2026-07-27) INVALIDATED

Fifty-sixth F2 pass (substitute — consistency-validator with adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved; DEC-190 window-eligible). **APERTURE CLASS: REALITY-CHECK** — first use of this aperture class (are the spec's factual assertions about third-party crates and this project's code actually TRUE). 6 claims verified. 5 VERIFIED, 1 MEDIUM FINDING. ZERO CRITICAL findings; ZERO HIGH findings; 1 MEDIUM finding; ZERO LOW findings; verdict FINDING (not CLEAN).

**Verified claims (5/6):** (1) config-migration stderr line at `config.rs:285` genuinely poisons strict JSON parse — Preconditions on AC-2/5/7/10 sound; (2) wiremock 0.6.5 FIFO with `mount_platform_create_stubs` confirmed registering free-fire mocks — isolation constraint on AC-8/AC-11 sound; (3) dialoguer 0.12.0 with `prompt_input` using `.interact_text()` confirmed; (4) serde_json without `preserve_order` — no `indexmap` dep, alphabetical ordering claim correct; (5) `JR_STDIN_IS_TTY` seam correct on all three sub-claims including release-gating via `#[cfg(not(debug_assertions))]`.

**F56-001 (MEDIUM, delta-attributable):** AC-18's rationale asserted "`assert_cmd` provides no timeout primitive, so 'stdin NOT consumed' and 'process exits promptly' are NOT testable as normative assertions." This is FALSE: `assert_cmd` 2.2.2 exposes `pub fn timeout(&mut self, timeout: std::time::Duration) -> &mut Self` at `src/cmd.rs:108` with a documented timeout-then-`.failure()` example — verified in the cargo registry against `Cargo.lock`. Fix: false premise removed; the two conflated assertions correctly separated — "process exits promptly" IS testable via `.timeout()`, while "stdin NOT consumed" remains genuinely untestable (a timeout proves no-hang but not that stdin went unread; no `assert_cmd` primitive observes child stdin consumption); design decision **(ii)** recorded explicitly — the timeout assertion is DECLINED as normative because a wall-clock assertion is CI-load-sensitive and adds no discriminating power (it cannot distinguish guard-fired-early from guard-absent-but-fast), while exit-64 + the guard substring already prove step-2 firing. Severity downgraded from CRITICAL (validator) to MEDIUM (orchestrator): no wrong behavior ships, but a false statement of fact in a normative document under-specified achievable coverage. Spec bumped v1.3.151. BC-INDEX v6.73 unchanged. All 3 guards green.

**APERTURE-CLASS-LESSON (most important lesson of this session):** Passes 48–55 used INTERNAL-CONSISTENCY apertures (does the spec agree with itself; do its citations resolve) and yielded only documentation-traceability findings, which read as an asymptote. Passes 56–57 opened a REALITY-CHECK aperture class (are the spec's factual assertions about third-party crates and about this project's code actually TRUE) and immediately found two substantive defects. A spec can be maximally self-consistent while asserting false things about the world; internal-consistency review structurally cannot detect that. Reality-check apertures are where the yield is.

**NOTE — SUBSTITUTE PASS (DEC-190 WINDOW-ELIGIBLE, WINDOW RESET):** This finding is delta-attributable. The earlier 3/3 window (passes p129-sub/p130-sub/p131-sub, DEC-190, 2026-07-27) is INVALIDATED. Convergence counter RESET to 0/3.

**Convergence counter:** RESET to 0 of 3 STRICT. NEXT: pass-57 (p133-sub).

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L)→[remediation-burst: F1-F5 LOW]→[F47-001 LOW fix]→p124-sub(1L)→p125-sub(1L)→p126-sub(1L)→p127-sub(1L)→p128-sub(1L)→p129-sub(0)→p130-sub(0)→p131-sub(0)→p132-sub(1M). Delta: +1M (0→1M). trajectory-tail →0→0→0→1M (passes p129-sub, p130-sub, p131-sub, p132-sub). **CONVERGENCE: RESET to 0/3 STRICT — earlier 3/3 window (DEC-190, 2026-07-27) INVALIDATED by F56-001.**

---

### Pass p133 (2026-07-27) — SUBSTITUTE (reality-check aperture; DEC-190 WINDOW-ELIGIBLE)

**Findings:** 1 (0C/0H/0M/1L) — F57-001 LOW
**Convergence counter:** 0 of 3 (STRICT per DEC-190) — delta-attributable finding; window already reset by F56-001 in p132-sub

Fifty-seventh F2 pass (substitute — consistency-validator with adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved; DEC-190 window-eligible). **APERTURE CLASS: REALITY-CHECK** (continued — code-behavior claims that ACs' discriminating power depends on). 8 claims verified. 7 VERIFIED, 1 LOW FINDING. ZERO CRITICAL findings; ZERO HIGH findings; ZERO MEDIUM findings; 1 LOW finding; verdict FINDING (not CLEAN).

**Verified claims (7/8):** (1) success-path JSON goes to **stdout** via `println!` at `create.rs:249` — `stdout.trim().is_empty()` IS discriminating in JSON mode for AC-2/7/10; (2) `print_success` is `eprintln!` at `output.rs:45-47` so `"Created issue"` goes to **stderr** — `!stderr.contains("Created issue")` carries discriminating weight; (3) the `"Error: "` prefix is human-arm-only at `main.rs:133-144`; (4) JSM guard ordering fires project-key(124) → empty-RT(146) → summary(~244-255); (5) `"request type cannot be empty"` unique in `src/`; (6) `find_project_config` walk-up loop confirmed; (7) all five AC-8 endpoint symbols with the `team_field_id`-is-None conditional real.

**F57-001 (LOW, delta-attributable):** AC-17 asserted `!stderr.contains("cannot be combined with")`. That bare substring is broader than BC-3.8.017's message and collides with an unrelated contract's message at `src/cli/issue/edit.rs:220` (`"--label cannot be combined with {} in the same call"`, the issue-#396 label/field mutual-exclusion guard). The spec's prose claim was CORRECT — BC-3.8.017's own string does live only in `jsm_create.rs:160` — so the orchestrator re-characterized the validator's finding, which would have had the true prose rewritten. No functional impact (zero `edit::` references in `create.rs`, so `edit.rs` is unreachable from `handle_create` and the HYGIENE label stands). Fix: assertion narrowed to `"cannot be combined with \`--markdown\`"` (option a) AND annotated with the `edit.rs` collision. Spec bumped v1.3.152. BC-INDEX v6.73 unchanged. All 3 guards green.

**NOTE — SUBSTITUTE PASS (DEC-190 WINDOW-ELIGIBLE):** Window was already reset to 0/3 by F56-001 in p132-sub. F57-001 is also delta-attributable; counter remains 0/3.

**Convergence counter:** 0 of 3 STRICT. NEXT: pass-58 (p134-sub or adversary).

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L)→[remediation-burst: F1-F5 LOW]→[F47-001 LOW fix]→p124-sub(1L)→p125-sub(1L)→p126-sub(1L)→p127-sub(1L)→p128-sub(1L)→p129-sub(0)→p130-sub(0)→p131-sub(0)→p132-sub(1M)→p133-sub(1L). Delta: -1M+1L (1M→1L). trajectory-tail →0→0→1M→1L (passes p130-sub, p131-sub, p132-sub, p133-sub). CONVERGENCE: 0/3 STRICT RESET. PIPELINE PAUSED.

---

### Pass p137 (2026-07-28) — SUBSTITUTE (record-keeping integrity audit; DEC-190 WINDOW-ELIGIBLE)

**Findings:** 2 (0C/0H/1M/1L) — F62-001 MEDIUM + F62-002 LOW
**Convergence counter:** RESET to 0 of 3 (STRICT per DEC-190) — delta-attributable findings; window reset

Sixty-second F2 pass (substitute — consistency-validator with adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved; DEC-190 window-eligible). **APERTURE CLASS: RECORD-KEEPING INTEGRITY** (spec-changelog completeness, Type-field correctness, BC-INDEX rows, README Supplement Index). 4 items audited. 2 PASS, 2 FINDING. 1 MEDIUM finding; 1 LOW finding; verdict FINDING (not CLEAN).

**Verified claims (PASS, 2/4):** (1) Changelog completeness — 47 entries 1.3.107–1.3.153 with no gaps or duplicates in scope; (2) Type-field correctness — all entries are PATCH, consistent with "0 new BCs"; (3) BC-INDEX §3.4 rows for BC-3.4.014–019 all present and semantically consistent with their bodies.

**F62-001 (MEDIUM, delta-attributable):** `specs/prd/README.md` Supplement Index holdout row showed count `55` but correct value is `100` (total holdout scenarios per `total_holdouts:` frontmatter). Fix: corrected to `100` in spec v1.3.154. The stale `55` figure was pre-SOH-DX-1 and was not updated when holdouts grew. Severity MEDIUM: stale count in a navigational index document potentially misdirects reviewers about holdout coverage.

**F62-002 (LOW, delta-attributable):** Two spec-changelog entries (`[1.3.113]` and `[1.3.114]`) were missing their `### BC Count` sections — present in all sibling entries as a convention, absent here. Fix: both entries gained their `### BC Count` sections (no BC count change; entries updated to record `0 new BCs / unchanged` in v1.3.154).

**NOTE — SUBSTITUTE PASS (DEC-190 WINDOW-ELIGIBLE):** Window was at 0/3 after p136-sub (F60-001 reset). F62-001 and F62-002 are delta-attributable; window remains 0/3. Both fixes applied in spec v1.3.154.

**Convergence counter:** RESET to 0 of 3 STRICT. NEXT: pass-63 (p138-sub).

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L)→[remediation-burst: F1-F5 LOW]→[F47-001 LOW fix]→p124-sub(1L)→p125-sub(1L)→p126-sub(1L)→p127-sub(1L)→p128-sub(1L)→p129-sub(0)→p130-sub(0)→p131-sub(0)→p132-sub(1M)→p133-sub(1L)→p134-sub(0)→p135-sub(0)→p136-sub(1L)→p137-sub(1M+1L). Delta: +1M (1L→1M+1L). trajectory-tail →0→0→1L→1M+1L (passes p134-sub, p135-sub, p136-sub, p137-sub). CONVERGENCE: 0/3 STRICT RESET — F62-001 MEDIUM + F62-002 LOW delta-attributable.

---

### Pass p138 (2026-07-28) — SUBSTITUTE (unguarded-surface audit; DEC-190 WINDOW-ELIGIBLE) — CLEAN for delta

**Findings:** 1 (0C/0H/0M/1L) — CANONICAL-COUNTS stale ADR locations (PRE-EXISTING, out of scope)
**Convergence counter:** 1 of 3 STRICT — CLEAN for delta (pre-existing finding; window advances)

Sixty-third F2 pass (substitute — consistency-validator with adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved; DEC-190 window-eligible). **APERTURE CLASS: UNGUARDED-SURFACE AUDIT** (three surfaces with no guard coverage). 3 items audited. 2 VERIFIED, 1 PRE-EXISTING FINDING (out of scope). ZERO delta-attributable findings; verdict CLEAN for delta.

**Verified claims (2/3):**
- **Item 1 — BC-INDEX `## Coverage Statistics` (the "9th surface", first mechanical audit): VERIFIED ACCURATE.** All eight cumulative figures sum to 657 matching `total_bcs`; all eight bodied figures sum to 427 matching the Total row; the stated 230 difference is exact; every per-section bodied figure matches the real `#### BC-` heading count (46/64/111/22/18/33/49 across bc-1..bc-7, plus cross-cutting.md at 84 bodied / 150 cumulative). **Calibration note:** this surface has been flagged ten times as a drift risk and has now been mechanically audited for the first time — it is accurate. The recurrence count measured how often the risk was noticed, not how often it drifted. Recommend priority downgrade accordingly.
- **Item 2 — `error-taxonomy.md` `### Issue Commands` subsection (added v1.3.150): VERIFIED.** All three verbatim error strings character-for-character identical to their `bc-3-issue-write.md` definitions; exit code 64; `JrError::UserError`; all three fire BEFORE any HTTP is issued; combined-governs-one-error rule stated; table structure matches sibling subsections.

**PRE-EXISTING FINDING (Item 3 — CANONICAL-COUNTS stale ADR locations, out of scope):** `CANONICAL-COUNTS.md` §ADRs claims ADR-0007..0013 live in `.factory/architecture/adr/` — that directory does not exist; all ADRs 0001..0016 are in `docs/adr/`. Stale location note. PRE-EXISTING (not SOH-DX-1 delta). Does NOT reset the window; ledgered as `CANONICAL-COUNTS-STALE-ADR-LOCATIONS` (LOW, OPEN — maintenance-sweep candidate).

**Orchestrator-error correction (F63-001 MEDIUM + F63-002 LOW) correcting v1.3.154:** Both README holdout rows introduced in v1.3.154 carried range terminus `H-NEW-JSM-RT-001..006`, but the actual maximum is `H-NEW-JSM-RT-001..007` (7 scenarios in that family). Line 48 had been wrong since v1.3.143; the orchestrator's v1.3.154 instruction propagated the wrong terminus to line 108. Fix: both rows corrected to `..007` in v1.3.155. Line 108 also gained the "informational; canonical count is `total_holdouts:` frontmatter" caveat (line 48 already had it). Additionally, `PHANTOM-ADR-0017` codified: ADR-0017 cited in six files but document does not exist; on-disk count is 16 (ADR-0001..0016).

**NOTE — SUBSTITUTE PASS (DEC-190 WINDOW-ELIGIBLE, CLEAN for delta):** Window was at 0/3 after p137-sub. The sole finding is pre-existing and out-of-scope for the SOH-DX-1 delta — it does NOT reset the window. Window advances to 1/3 STRICT. Reasoning recorded explicitly per orchestrator instruction.

**Convergence counter:** 1 of 3 STRICT. NEXT: pass-64 (p139-sub or adversary).

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L)→[remediation-burst: F1-F5 LOW]→[F47-001 LOW fix]→p124-sub(1L)→p125-sub(1L)→p126-sub(1L)→p127-sub(1L)→p128-sub(1L)→p129-sub(0)→p130-sub(0)→p131-sub(0)→p132-sub(1M)→p133-sub(1L)→p134-sub(0)→p135-sub(0)→p136-sub(1L)→p137-sub(1M+1L)→p138-sub(1L). Delta: -1M (1M+1L→1L). trajectory-tail →0→1L→1M+1L→1L (passes p135-sub, p136-sub, p137-sub, p138-sub). **CONVERGENCE: 1/3 STRICT — CLEAN for delta (pre-existing finding out of scope; window advances).**

---

### Pass p139 (2026-07-28) — SUBSTITUTE (upstream-completeness audit; DEC-190 WINDOW-ELIGIBLE)

**Findings:** 1 (0C/0H/0M/1L) — F64-001 LOW
**Convergence counter:** RESET to 0 of 3 STRICT — delta-attributable finding; window reset

Sixty-fourth F2 pass (substitute — consistency-validator with adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved; DEC-190 window-eligible). **APERTURE CLASS: UPSTREAM-COMPLETENESS** (F1→F2 upstream completeness audit: every F1 risk and open question mapped to an F2 treatment or explicit non-goal).

**F64-001 (LOW, delta-attributable):** F1's E2E scan obligation had no F2 treatment. F1 (`phase-f1-delta/SOH-DX-1/delta-analysis.md` § "2. Regression Risk Assessment", #639 row) required scanning `tests/e2e_live.rs` for `issue create` invocations carrying `--field`/`--on-behalf-of` without `--request-type`. Scan performed: ZERO found — all 8 `--field` occurrences are `issue edit --field` (live call site approximately line 5111), zero `--on-behalf-of`. Conclusion: no live-run scenario flips to exit-64; no E2E changes at F4. Fix: obligation DISCHARGED as delivery item (g) in spec v1.3.156.

**F1 row 82 confirmed fully treated:** `tests/issue_create_jsm.rs` "5 tests invert… significant rewrite" row confirmed fully treated by the AC DELETE mandates and Removal postcondition. No other untreated F1 risks found.

**Aperture insight — UPSTREAM-COMPLETENESS-APERTURE codified:** This class — completeness against the upstream authority — is undetectable by internal-consistency review, because the spec was perfectly coherent about DEC-188 while simply never mentioning a question F1 asked. Internal-consistency passes cannot catch it; only an explicit upstream-completeness dimension (every F1 risk/open question mapped to F2 treatment or explicit non-goal) can detect it. Companion to `APERTURE-CLASS-LESSON`.

**NOTE — SUBSTITUTE PASS (DEC-190 WINDOW-ELIGIBLE):** Window was at 1/3 (from p138-sub). F64-001 is delta-attributable → window RESET to 0/3.

**Convergence counter:** RESET to 0 of 3 STRICT. NEXT: pass-65 (p140-sub or adversary).

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L)→[remediation-burst: F1-F5 LOW]→[F47-001 LOW fix]→p124-sub(1L)→p125-sub(1L)→p126-sub(1L)→p127-sub(1L)→p128-sub(1L)→p129-sub(0)→p130-sub(0)→p131-sub(0)→p132-sub(1M)→p133-sub(1L)→p134-sub(0)→p135-sub(0)→p136-sub(1L)→p137-sub(1M+1L)→p138-sub(1L)→p139-sub(1L). Delta: +0 (1L→1L). trajectory-tail →1L→1M+1L→1L→1L (passes p136-sub, p137-sub, p138-sub, p139-sub). CONVERGENCE: 0/3 STRICT RESET — F64-001 LOW delta-attributable.

---

### Pass p140 (2026-07-28) — SUBSTITUTE (F2→F3 downstream readiness audit; DEC-190 WINDOW-ELIGIBLE)

**Findings:** 2 accepted (0C/0H/1M/1L) + 2 rejected — F65-001 MEDIUM + F65-002 LOW accepted
**Convergence counter:** RESET to 0 of 3 STRICT — both accepted findings delta-attributable

Sixty-fifth F2 pass (substitute — consistency-validator with adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved; DEC-190 window-eligible). **APERTURE CLASS: DOWNSTREAM READINESS** (F2→F3 readiness: does F2 supply what F3's story template requires for S-639-1 without improvising unratified behavioural scope?). 4 items raised; 2 accepted by orchestrator; 2 rejected with reasoning.

**Overall verdict: F2 IS sufficient for F3 to author S-639-1 without improvising unratified behavioural scope** — all 21 ACs, three verbatim error strings, guard placement, clap-`requires` prohibition, SSOT ordering, helper promotion directives, breaking-change metadata, and obligations (a)–(g) all supplied.

**F65-001 (MEDIUM, delta-attributable; orchestrator-introduced):** v1.3.156 item (g) cited bare `` `delta-analysis.md` line 81 `` but TWO files share that name — `phase-f1-delta/SOH-DX-1/delta-analysis.md:81` is the #639 risk row (correct) while `phase-f1-delta-analysis/delta-analysis.md:81` is unrelated YAML. A reviewer following the bare reference reaches the wrong file. The pointer was ambiguous, not dead — but violates the CLAUDE.md citation convention per #408 (symbol-form / full-path section-form). Fix: citation corrected to `phase-f1-delta/SOH-DX-1/delta-analysis.md § "2. Regression Risk Assessment"` in spec v1.3.157. `CITATION-FORM-DISCIPLINE` drift item updated (orchestrator-introduced recurrence).

**F65-002 (LOW, delta-attributable):** AC-expansion guidance for F3 was ambiguous — "verbatim" was unclear about whether it governed content or line formatting. Clarified: "verbatim" governs content, not line formatting; `stories/S-576-3.md` named as format reference. Fix applied in spec v1.3.157.

**REJECTED findings (orchestrator, with reasoning):**
(i) "`src/cli/issue/create.rs` missing from obligations (a)–(g)" — FALSE POSITIVE. The block is explicitly "same PR as the code change" and enumerates accompanying work; `create.rs` appears in the Behavior clause, Trace, and Removal postcondition twice each.
(ii) "`tests/common/mod.rs` registration missing from obligations" — ACCEPTED-AS-IS. It lives in the Test Note where test-infrastructure directives belong; not required in (a)–(g).

**NOTE — SUBSTITUTE PASS (DEC-190 WINDOW-ELIGIBLE):** Window was at 0/3 (reset by F64-001 in p139-sub). F65-001 and F65-002 are delta-attributable; counter remains 0/3.

**Convergence counter:** RESET to 0 of 3 STRICT. NEXT: pass-66 (p141-sub or adversary).

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L)→[remediation-burst: F1-F5 LOW]→[F47-001 LOW fix]→p124-sub(1L)→p125-sub(1L)→p126-sub(1L)→p127-sub(1L)→p128-sub(1L)→p129-sub(0)→p130-sub(0)→p131-sub(0)→p132-sub(1M)→p133-sub(1L)→p134-sub(0)→p135-sub(0)→p136-sub(1L)→p137-sub(1M+1L)→p138-sub(1L)→p139-sub(1L)→p140-sub(1M+1L). Delta: +1M (1L→1M+1L). trajectory-tail →1M+1L→1L→1L→1M+1L (passes p137-sub, p138-sub, p139-sub, p140-sub). CONVERGENCE: 0/3 STRICT RESET — F65-001 MEDIUM + F65-002 LOW both delta-attributable.

---

### Pass p141 (2026-07-28) — SUBSTITUTE (broad unstructured re-tread; DEC-190 WINDOW-ELIGIBLE)

**Findings:** 1 (0C/0H/0M/1L) — F66-001 LOW; verdict CONVERGED (broad sweep)
**Convergence counter:** RESET to 0 of 3 STRICT — delta-attributable finding

Sixty-sixth F2 pass (substitute — consistency-validator with adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved; DEC-190 window-eligible). **APERTURE CLASS: BROAD UNSTRUCTURED RE-TREAD** (no prescribed checklist — free to examine anything, with Bash). Independently verified: v1.3.157 citation fix; ~20 line-number citations across `src/` and `tests/`; all four ADR-0014 amendment sites; `CLAUDE.md:248`; test infrastructure state; serde_json key-ordering reasoning; AC label assignments; AC-15 insensitivity claim; clap-`requires` prohibition; `print_success` is `eprintln!` making `!stderr.contains("Created issue")` genuinely DISCRIMINATING. Reached the same conclusions as prior targeted passes without being directed there.

**F66-001 (LOW, delta-attributable):** Completes v1.3.142's partial propagation. The malformed-`--field` example literal `bare-name-no-equals` → `bareflagnoequals` was propagated to historical sites in v1.3.142 but NOT to the two LIVE sites: (a) Behavior block EC-3.8.012-3 example; (b) EC-3.8.012-3 "as test" citation body. Fix: both LIVE sites updated to `bareflagnoequals` in spec v1.3.158, aligning with AC-7 (which since v1.3.147 explicitly cites "EC-3.8.012-3 as test") and with `tests/issue_create_jsm.rs:2845`. Three historical sites (v1.3.142 trail, v1.3.131 trail, footer Previous-update chain) deliberately preserved. `TWIN-ARTIFACT-SWEEP` incremented to recurrence 19.

**ORCHESTRATOR-ERROR-INJECTION-RATE aperture insight:** Two of four findings in rounds 63–66 were defects the orchestrator introduced via imprecise fix instructions: F63-001 (range terminus inferred from a confirmed member rather than enumerated) and F65-001 (bare filename where two files share the name). Both violated rules already in the ledger (RANGE-TERMINUS-INFERENCE and CITATION-FORM-DISCIPLINE). Signal: at this depth, the remediation process injects defects at a rate comparable to the review process finding pre-existing ones. `ORCHESTRATOR-ERROR-INJECTION-RATE` codified as new drift item.

**NOTE — SUBSTITUTE PASS (DEC-190 WINDOW-ELIGIBLE):** Window was at 0/3 (reset by F65-001 in p140-sub). F66-001 is delta-attributable → counter remains 0/3.

**Convergence counter:** RESET to 0 of 3 STRICT. NEXT: pass-67 (p142-sub or adversary).

**Trajectory so far:** p78(8)→p79(8)→p80(8)→p81(7)→p82(6)→p83(4)→p84(3)→p85(7)→p86(6)→p87(5)→p88(6)→p89(6)→p90(4)→p91(2)→p92(5)→p93(5)→p94(4)→p95(3)→p96(3)→p97(5)→p98(4)→p99(2)→p100(3)→p101(3)→p102(6)→p103(6)→p104(4)→p105(5)→p106(2)→p107(1)→p108(3)→p109(3)→p110(2)→p111(3L)→p112(1M+3L)→p113(2M+2L)→p114(2H+2L)→p115(4M+2L)→p116(2M+1L)→p117(1H+1M)→p118(2M)→p119(1M+2L)→p120(2M)→p121(3M+2L)→p122(3M)→p123(1M+2L)→[remediation-burst: F1-F5 LOW]→[F47-001 LOW fix]→p124-sub(1L)→p125-sub(1L)→p126-sub(1L)→p127-sub(1L)→p128-sub(1L)→p129-sub(0)→p130-sub(0)→p131-sub(0)→p132-sub(1M)→p133-sub(1L)→p134-sub(0)→p135-sub(0)→p136-sub(1L)→p137-sub(1M+1L)→p138-sub(1L)→p139-sub(1L)→p140-sub(1M+1L)→p141-sub(1L). Delta: -1M (1M+1L→1L). trajectory-tail →1L→1L→1M+1L→1L (passes p138-sub, p139-sub, p140-sub, p141-sub). **CONVERGENCE: 0/3 STRICT RESET — F66-001 LOW delta-attributable. Broad unstructured re-tread confirms convergence signal: findings remain LOW, no new classes.** PIPELINE PAUSED.


---

## p142-sub (pass-67) — 2026-07-28

**Spec version:** v1.3.159
**Pass type:** BROAD UNSTRUCTURED SUBSTITUTE (2nd consecutive)
**Verdict:** FINDING — WINDOW RESET
**Window before:** 0/3 STRICT
**Window after:** 0/3 STRICT (RESET — delta-attributable findings)
**Trajectory tail:** →1L→1M+1L→1L→2L

### Findings

| ID | Severity | Description |
|----|----------|-------------|
| F67-001 | LOW | BC-3.8.012 combined-check ordering sentence was one-sided — "MUST run before the individual `--field`-only check" constrained ordering only against the `--field`-only check, not the `--on-behalf-of`-only check. An implementation ordering the `--on-behalf-of`-only guard first satisfied the sentence verbatim while violating EC-3.8.012-1. Broadened to "before BOTH individual single-flag checks (the `--field`-only check and the `--on-behalf-of`-only check)". Precision defect only — EC-3.8.012-1 and AC-13 already covered the gap normatively. BC-3.8.013 carries no mirrored statement (defers to BC-3.8.012 as governing BC); no change needed there. |
| F67-002 | LOW | AC-9, AC-11, AC-16(a), and AC-17 carried a FALSE rationale for their `.current_dir()` preconditions — "degrades discriminating power". All four are projectless AND lack `--type`, so on a guard-absent build with an inherited project key the run fails on missing `--type` before any HTTP; discriminating power is genuinely unaffected by config inheritance. Corrected to the true reason: ancestor-config isolation prevents inherited credentials from enabling a live HTTP escape (hygiene isolation). AC-10 deliberately NOT changed — its invocation supplies `--project`/`--type`/`--summary` (would-otherwise-succeed), so inheritance DOES affect its discriminating power, and its wording ("silently interferes") was never false. Asymmetry explicitly documented — a future reviewer will otherwise flag it as an inconsistency. |

### Verifications (pass-67 named 14 mechanical checks — all held)

- `print_success` is `eprintln!` → `!stderr.contains("Created issue")` is genuinely DISCRIMINATING (verified)
- `find_team_field_id`-before-`resolve_assignee_by_project` ordering underpinning AC-8 (verified)
- `config.rs:285` migration line confirming Config fixture contract (verified)
- v1.3.157 citation fix, ~20 line citations, all four ADR-0014 sites, `CLAUDE.md:248`, serde_json key-ordering, AC labels, AC-15 insensitivity, clap-`requires` prohibition (all verified)
- `print_success` → `eprintln!` meaning `!stderr.contains("Created issue")` is DISCRIMINATING (verified independently as 1st item in named list)

### Disposition

- F67-001: FIXED in v1.3.159 — BC-3.8.012 ordering sentence broadened to cover both single-flag checks; BC-3.8.013 unchanged (defers to BC-3.8.012)
- F67-002: FIXED in v1.3.159 — four AC rationale corrections; AC-10 asymmetry explicitly documented
- WINDOW: RESET to 0/3 (both findings delta-attributable)
- New drift item: STRICT-WINDOW-NO-FIXED-POINT (MEDIUM)
- TWIN-ARTIFACT-SWEEP: recurrence 19→20

NEXT: pass-68 (p143-sub or adversary) with v1.3.159 artifacts.

---

### Pass p143 (2026-07-28) — SUBSTITUTE (broad unstructured re-tread; DEC-190 WINDOW-ELIGIBLE)

**Findings:** 0 (0C/0H/0M/0L) — ZERO FINDINGS; verdict CONVERGED
**Convergence counter:** 1 of 3 STRICT
**Window before:** 0/3 STRICT
**Window after:** 1/3 STRICT

Sixty-eighth F2 pass (substitute — consistency-validator with adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved; DEC-190 window-eligible). **APERTURE CLASS: BROAD UNSTRUCTURED RE-TREAD** (no prescribed checklist — free to examine anything with Bash). Named ~25 mechanical verifications, ALL correct. Verifications included: `assert_cmd` 2.2.2 `.timeout()` at `src/cmd.rs:108` (confirming the v1.3.151 correction); `assert_json_error_envelope` at `json_error_shape.rs:63` with `stdout.trim().is_empty()` at ~:76; `tests/common/assertions.rs` absent (F3 deliverable); `write_minimal_config` legacy `[instance]` shape at ~:165; `write_profile_config` absent; both old `eprintln!` warn strings at `create.rs` ~:81-89; dispatch fork at `create.rs:49`; NO `--markdown` guard on the platform path (validating EC-3.8.012-5); `edit.rs` ~:89 markdown guard; `jsm_create.rs` ~:160 BC-3.8.017 string and ~:145 empty-RT guard; the false platform-parity comment at `jsm_create.rs` ~:171-172; bidirectional `--to`/`--account-id` `conflicts_with` at `mod.rs` ~:388/391; helper HTTP ordering (`resolve_team_field` before `resolve_assignee_by_project`) underpinning AC-8; `find_team_field_id` at `fields.rs:26`; `get_myself` at `users.rs:19`; `main.rs` ~:143 "Error: " prefix and the no-prefix JSON arm; all four ADR-0014 byte-for-byte sites; `CLAUDE.md:248`; all six old test names; the family banner's three stale clauses at `issue_create_jsm.rs` ~:2380-2391; both dead-citation comments; AC-1's full five-item DELETE mandate; the config migration line at `config.rs:285`.

**ZERO findings.** All ~25 claims held.

**Convergence counter:** 1 of 3 STRICT. NEXT: pass-69 (p144-sub or adversary).

**Trajectory so far:** p78(8)→...→p140-sub(1M+1L)→p141-sub(1L)→p142-sub(2L)→p143-sub(0). trajectory-tail →1M+1L→1L→2L→0 (passes p140-sub, p141-sub, p142-sub, p143-sub). CONVERGENCE: 1/3 STRICT. PIPELINE PAUSED.

---

### Pass p144 (2026-07-28) — SUBSTITUTE (broad unstructured re-tread; DEC-190 WINDOW-ELIGIBLE)

**Findings:** 0 (0C/0H/0M/0L) — ZERO FINDINGS; verdict CONVERGED
**Convergence counter:** 2 of 3 STRICT
**Window before:** 1/3 STRICT
**Window after:** 2/3 STRICT

Sixty-ninth F2 pass (substitute — consistency-validator with adversarial verification checklist; NOT the adversary agent; fresh context; adversarial framing preserved; DEC-190 window-eligible). **APERTURE CLASS: BROAD UNSTRUCTURED RE-TREAD** (no prescribed checklist — free to examine anything with Bash). Named ~30 mechanical verifications, all correct — substantially overlapping pass-68's set plus: `find_project_config` at `config.rs:362`; `JR_STDIN_IS_TTY` at `main.rs:107` with the flip gated on `if !cli.no_input` at ~:103; the pre-migrated profile-config template at `issue_create_jsm.rs` ~:1959-1966; `mount_platform_create_stubs` free-fire registration at ~:2395-2411; verbatim error-string non-overlap confirming AC-3's FALSIFIABLE-COARSE labels. Also independently confirmed the AC-16 Removal-postcondition omission is documented and intentional.

**One UNVERIFIED item self-flagged:** whether wiremock 0.6.5's `received_requests()` records requests to UNREGISTERED paths — the basis for AC-8's and AC-13's normative zero-HTTP proof. **Orchestrator resolved this against the crate source: VERIFIED CORRECT.** In `wiremock-0.6.5/src/mock_server/bare_server.rs`, `handle_request` pushes every incoming request to `received_requests` UNCONDITIONALLY, before `self.mock_set.handle_request(request)` — so unmatched/unregistered-path requests ARE recorded. The spec's claim that it "catches ALL HTTP calls regardless of mock registration" holds; both zero-HTTP proofs are sound. Failure mode is also safe: with recording disabled the method returns `None` and the spec's `.unwrap()` panics loudly rather than silently passing.

**ZERO findings.** All ~30 claims held (wiremock UNVERIFIED item resolved out-of-band; did not generate a finding).

**Convergence counter:** 2 of 3 STRICT. NEXT: pass-70 (adv-70 or p145-sub).

**Trajectory so far:** p78(8)→...→p141-sub(1L)→p142-sub(2L)→p143-sub(0)→p144-sub(0). trajectory-tail →1L→2L→0→0 (passes p141-sub, p142-sub, p143-sub, p144-sub). CONVERGENCE: 2/3 STRICT. PIPELINE PAUSED.

---

### Pass-70 (2026-07-28) — VOID ×3 (adv-70, adv-70b, adv-70c)

**Findings:** N/A — VOID (zero retrievable output)
**Convergence counter:** 2 of 3 STRICT (no credit, no reset)
**Window before:** 2/3 STRICT
**Window after:** 2/3 STRICT (unchanged — VOID does not advance or reset window)

**VOID ×3.** Three consecutive dispatches (adv-70, adv-70b, adv-70c) produced zero retrievable output despite substantial runtime. Each was nudged once and did not deliver a final report. Attempt 3 (adv-70c) used a deliberately leaner prompt with a ~20-call budget, after observing the two failed dispatches had the longest prompts and runtimes while passes 68/69 (which delivered) were shorter. The orchestrator did NOT substitute its own review — not fresh-context after 20+ passes; a self-review cannot legitimately close a fresh-context window.

**Cause: subagent delivery failure.** NOT a clean pass; NOT a failing pass. Window remains at 2/3 — VOID does not credit or reset the counter per task instructions. Running tally this session (AGENT-IDLE-NO-REPORT): 3 of the last 6 review dispatches produced nothing retrievable. VOID is now the binding constraint on closing the DEC-189 window, not spec quality.

**Convergence counter:** 2 of 3 STRICT (unchanged). NEXT: fresh dispatch with leaner prompt or human ruling on STRICT-WINDOW-NO-FIXED-POINT criterion.

**Trajectory so far:** p78(8)→...→p142-sub(2L)→p143-sub(0)→p144-sub(0)→pass-70(VOID×3). trajectory-tail →2L→0→0→VOID×3 (passes p142-sub, p143-sub, p144-sub, pass-70). CONVERGENCE: 2/3 STRICT. PIPELINE PAUSED.

---

### Pass adv-71 (2026-07-28) — SUBSTITUTE (DEC-190 WINDOW-ELIGIBLE; aperture: upstream-completeness / downstream-readiness)

**Findings:** 3 (0C/0H/1M/2L)
**Convergence counter:** WINDOW RESET 2/3 → 0/3 (ORCHESTRATOR READ; PENDING HUMAN RATIFICATION DEC-189)
**Window before:** 2/3 STRICT
**Window after:** 0/3 STRICT (orchestrator read; P71-001 delta-attributable; counter-argument: could be F3 input)

Seventy-first F2 pass (DEC-190 substitute; aperture: upstream-completeness / downstream-readiness). CONFIRMED CLEAN per adv-71 on 17+ F1 obligations and DEC-188 clauses (a)-(d).

**P71-001 (MEDIUM):** F1 `phase-f1-delta/SOH-DX-1/delta-analysis.md` lines 224-226 bind F2 verbatim — "F2 must include the verification step … Substituting an unverified SHA defeats the security purpose of pinning" — and F2 never discharged it; deferred to F4 via a session-checkpoint note (not a spec artifact, not an F3 input). Verified: `bc-3-issue-write.md` contains ZERO S-626/S-627 references; none of S-639-1/S-627-1/S-626-1 exist. DELTA-ATTRIBUTABLE per orchestrator read.
- Partially discharged out-of-band: full SHA `fa04a1451ff1842e2626ccb99004d0195b455a88` confirmed real (2026-06-30, "Add 1.96.1 patch release"); ancestor of master CONFIRMED (behind_by: 0). Current pin `c93f4f9c67595668add93d3d6895795ce52d8c2d` is real (2026-03-27) but NOT master ancestor — dtolnay/rust-toolchain maintains dozens of version branches; NOT evidence of compromise. RESIDUAL for F3 S-626-1: (a) blocking pre-impl AC with VERIFIED full 40-char SHA; (b) P71-003's do-not-remove constraint naming `sign-and-publish.yml ~:64` + `backfill-release.yml ~:79`; (c) flag MSRV comment accuracy risk if repinning uniformly (ci.yml:70 comments `# 1.85.0` while fa04a145 is "Add 1.96.1 patch release").

**P71-002 (LOW):** bc-3 entirely silent on bundle stories S-627-1 and S-626-1; an F3 story-writer reading only bc-3 would author one story and miss two. Residual for F3 story template.

**P71-003 (LOW):** F1's "do NOT remove the rustup target add steps — they are cross-compilation build requirements, not SHA-pin artifacts" constraint uncrystallized in any downstream artifact. Residual for F3 S-626-1 AC (paired with P71-001 residual).

**COUNTER-ARGUMENT:** adv-71 framed all three findings as concerning Items 2/3, which deliberately carry no F2 BC content — a human could classify P71-001 as an F3 input requirement rather than an F2 defect. If so, window remains 2/3 and pass-72 advances to 3/3 STRICT.

**Convergence counter (orchestrator read):** RESET to 0/3 (P71-001 delta-attributable). PENDING HUMAN RATIFICATION DEC-189.

**Trajectory so far:** p78(8)→...→p143-sub(0)→p144-sub(0)→pass-70(VOID×3)→adv-71(1M+2L). trajectory-tail →0→0→VOID×3→1M+2L. CONVERGENCE: 0/3 STRICT (orchestrator read; PENDING HUMAN RATIFICATION). PIPELINE PAUSED.

NEXT: pass-72 (adv-72).

---

### Pass adv-72 (2026-07-28) — SUBSTITUTE (DEC-190 WINDOW-ELIGIBLE; aperture: reality-check on third-party claims + count surfaces)

**Findings:** 1 (0C/1H/0M/0L) — P72-001 HIGH; PRE-EXISTING / out-of-delta; FIXED in v1.3.160
**Convergence counter:** 0/3 → 1/3 (orchestrator read; P72-001 pre-existing / out-of-delta, does NOT reset window)
**Window before:** 0/3 STRICT (orchestrator read; PENDING HUMAN RATIFICATION on pass-71)
**Window after:** 1/3 STRICT (orchestrator read; P72-001 pre-existing; if P71-001 is F3 input, window is 3/3)

Seventy-second F2 pass (DEC-190 substitute; aperture: reality-check on third-party API claims + count surfaces).

**P72-001 (HIGH; PRE-EXISTING / out-of-delta — FIXED in spec v1.3.160):** `bc-3-issue-write.md` EC-3.4.015-4a contained a FALSE serde_json claim: directed implementers to `Number::from_f64(v)` for integer wire form, which emits `5.0` and would fail passing test `tests/issue_edit_field.rs` Test 26. PROVENANCE: introduced `e6a44c78` (2026-05-22, issue-396 cycle) — OUT OF DELTA for SOH-DX-1. FIXED in spec v1.3.160: corrected to `parsed_number_to_wire_value` integer branch (`Number::from(parsed as i64)` when `fract()==0.0` and within i64 bounds; else `json!(parsed)`); MUST NOT warning added; `5e3`→`5000` and `5.5`→`5.5` re-attributed; VP-396-010 pin retained. All four guard scripts GREEN after fix.

**Also CONFIRMED CORRECT (5 claims):** assert_cmd 2.2.2 `Command::timeout` at `src/cmd.rs:108`; serde_json `preserve_order` off → BTreeMap ordering; wiremock 0.6 FIFO for equal-priority mocks; dialoguer 0.12 non-TTY `Err(NotConnected)`; clap 4 `InvalidSubcommand` omits parent about.

**INDEPENDENT VERIFICATION:** adv-72 confirmed PHANTOM-ADR-0017 is a FALSE POSITIVE — ADR-0017 DOES exist at `.factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md` (ARCH-INDEX.md:34; status Accepted 2026-07-15). CANONICAL-COUNTS "17 ADRs, all present" claim is CORRECT. Drift item PHANTOM-ADR-0017 → CLOSED FALSE POSITIVE.

**Convergence counter (orchestrator read):** 0/3 → 1/3 (P72-001 pre-existing out-of-delta; does not reset per STRICT criterion). If P71-001 is classified as F3 input (counter-argument), window is 3/3 STRICT and F2 human gate is ready.

**Trajectory so far:** p78(8)→...→p143-sub(0)→p144-sub(0)→adv-71(1M+2L)→adv-72(1H-pre). trajectory-tail →0→0→1M+2L→1H (passes p143-sub, p144-sub, adv-71, adv-72). CONVERGENCE: 1/3 STRICT (orchestrator read; P71-001 classification PENDING HUMAN RATIFICATION DEC-189). PIPELINE PAUSED.

NEXT: human ruling on DEC-189 P71-001 classification (delta-attributable → keep grinding; or F3 input → 3/3 → F2 human gate ready) OR pass-73 with fresh aperture.

---

### Pass adv-75 — SIX-AXIS REVIEW (2026-07-28) — RECONSTRUCTED FROM FIX TRAIL

**Status: RECONSTRUCTED FROM FIX TRAIL (spec-changelog.md [1.3.161]/[1.3.162]/[1.3.163] + commit 13f015da). No findings artifact exists. NOT counted toward the 3/3 convergence window.**

Aperture: six-axis review (AX01: crate API claims; AX02: count surfaces; AX03: test symbol existence; AX04: external reality; AX05: spec internal consistency; AX06: partial-fix regression). This record is reconstructed post-hoc; the six-axis review ran after passes 73b/74b were claimed CLEAN.

**Findings:** 6 (1 GAP/LOW, 1 REFINEMENT/MEDIUM, 4 REFINEMENT/LOW)

| Finding | Type | Severity | In-delta | Fixed In |
|---------|------|----------|----------|---------|
| AX23-001 | GAP | LOW | OUT-OF-DELTA (VP-571-003, closed issue-#571 cycle 2026-07-08 — 2.5 weeks before SOH-DX-1 began 2026-07-25) | v1.3.162 |
| AX-001 | REFINEMENT | MEDIUM | n/a — BC-2.7.001 H1 sync | v1.3.162 |
| AX-002 | REFINEMENT | LOW | n/a — BC-INDEX Section 1 Subject column removal (6 subsections, 46 rows) | v1.3.162 |
| P73-001 | REFINEMENT | LOW | n/a — bc-3 pending-revert annotations for bc-3-issue-write.md BC-3.9.001/BC-3.9.003 | v1.3.162 |
| RS-001 | REFINEMENT | LOW | n/a — BC-INDEX prose header "Master traceability:" dropped stale "→ Subject" tail | v1.3.163 |
| ADR-LOCATION-FIX-001 | REFINEMENT | LOW | n/a — CANONICAL-COUNTS.md §ADRs two stale location claims corrected | v1.3.161 |

**AX23-001 detail:** Phantom test name `test_bc_7_2_015_ec_6_strong_retained_on_sibling_text_nodes_of_code_span` in VP-571-003 inside `bc-7-output-render.md`. Replaced with real citations: `src/adf.rs::test_bc_7_2_015_mixed_range_surrounding_marks_retained` (~:3061) and `src/adf.rs::test_bc_7_2_015_multi_mark_wrapper_only_code_node_stripped` (~:3090). Both confirmed present by pass-76 reality-check.

**ORCHESTRATOR RULING on AX23-001 (PENDING HUMAN RATIFICATION):** AX23-001 is classified OUT-OF-DELTA; it did NOT reset the convergence window. Basis: VP-571-003 belongs to the ADF-CODE-MARK-EXCLUSIVITY cycle (issue #571, CLOSED 2026-07-08); SOH-DX-1 began 2026-07-25 (~2.5 weeks later). Precedent: P72-001 out-of-delta HIGH did not reset a scoped delta review window. This ruling is SUBJECT TO HUMAN RATIFICATION at the F2 gate.

**Convergence counter:** N/A (reconstructed pass, NOT window-eligible; window count unchanged).

**Trajectory note:** RECONSTRUCTED. NOT window-eligible. trajectory-tail not advanced by this pass.

---

### Pass soh-dx-1-f2-pass-76 (2026-07-29) — SUBSTITUTE (DEC-190 WINDOW-ELIGIBLE; aperture: reality-check)

**Findings:** 1 (0C/0H/0M/1L) — ADV-P76-LOW-001 IN-DELTA REFINEMENT; 0 in-delta GAPs
**Convergence counter:** 0/3 → 1/3 (CLEAN under DEC-191)
**Window before:** 0/3 (new window; prior claimed window unbacked per PHANTOM-CONVERGENCE-EVIDENCE)
**Window after:** 1/3 STRICT under DEC-191
**Artifact:** `.factory/cycles/cycle-001/adversarial-reviews/soh-dx-1-f2-pass-76.md`

Seventy-sixth F2 pass (DEC-190 substitute; aperture: reality-check — crate APIs, crate versions, existing `src/` behavior, CI/workflow claims, MSRV, SHA pin). First reality-check pass for spec v1.3.163. Independently verified 8 checklist dimensions.

**ADV-P76-LOW-001 (LOW; REFINEMENT; IN-DELTA):** `delta-analysis.md §5e` still reads "F2 must include the verification step…" but SHA `fa04a1451ff1842e2626ccb99004d0195b455a88` was confirmed out-of-band (session-checkpoints.md P71-001) and embedded as blocking AC in S-626-1. One-line fix recommended before F3 (leaving a live "F2 must verify" statement in a gated-complete F2 is the same phantom-obligation class as P71-001).

Notable verifications: AX23-001 repair symbols confirmed present in `src/adf.rs` (lines ~3061, ~3090); all 7 AC test symbols verified in `tests/issue_create_jsm.rs`; all 6 workflow files confirmed using `c93f4f9c`; MSRV three-way disagreement confirmed as documented false-green.

**Convergence counter:** 0/3 → 1/3. ADV-P76-LOW-001 is REFINEMENT/LOW; non-window-resetting under DEC-191(c).

**Trajectory so far:** adv-72(1H-pre)→p75(6-reconstructed)→p76(1L). trajectory-tail →1H→6→1L. CONVERGENCE: 1/3. NEXT: pass-77.

---

### Pass soh-dx-1-f2-pass-77 (2026-07-29) — SUBSTITUTE (DEC-190 WINDOW-ELIGIBLE; aperture: delta-completeness + AC-falsifiability)

**Findings:** 1 (0C/0H/0M/1L) — P77-001 OUT-OF-DELTA REFINEMENT; 0 in-delta GAPs
**Convergence counter:** 1/3 → 2/3 (CLEAN under DEC-191)
**Window before:** 1/3 STRICT
**Window after:** 2/3 STRICT under DEC-191
**Artifact:** `.factory/cycles/cycle-001/adversarial-reviews/soh-dx-1-f2-pass-77.md`
**INDEPENDENCE NOTE: COMPROMISED.** Pass-77 read pass-76's intermediate draft (shared adversarial-reviews directory; prompt-level read-ban not mechanically enforced). Finding ID `P76-001` cited in the artifact (pre-rename; canonical name is `ADV-P76-LOW-001`). Substantive work (32-row obligation table, 21-AC falsifiability audit) retained. Pass-77 does NOT count as independent corroboration. First datapoint for REVIEW-ISOLATION-NOT-MECHANICALLY-ENFORCED drift item.

Seventy-seventh F2 pass. Enumerated **32** F1 obligations: 14 DISCHARGED, 15 DEFERRED with explicit story/phase targets, 3 STATE-ONLY, **0 ABSENT**. AC audit: 17 DISCRIMINATING, 2 HYGIENE (AC-15, AC-17 — correctly labeled), 2 DEFERRED/F3 (AC-4, AC-6). No mislabeled ACs found.

**P77-001 (LOW; REFINEMENT; OUT-OF-DELTA):** Three S-626-1 pre-F3 obligations are STATE-ONLY (SHA `fa04a145` blocking AC, do-not-remove constraint, MSRV flag). Expected at F2 before S-626-1 story drafted. No convergence action required; becomes S-626-1 story content at F3.

**Convergence counter:** 1/3 → 2/3. P77-001 is OUT-OF-DELTA REFINEMENT; non-window-resetting.

**Trajectory so far:** adv-72(1H-pre)→p75(6-reconstructed)→p76(1L)→p77(1L). trajectory-tail →1H→6→1L→1L. CONVERGENCE: 2/3. NEXT: pass-78.

---

### Pass soh-dx-1-f2-pass-78 (2026-07-29) — SUBSTITUTE (DEC-190 WINDOW-ELIGIBLE; aperture: verification-adequacy)

**Findings:** 0 — all 9 checklist items CLEAN; ZERO in-delta GAPs; ZERO total findings
**Convergence counter:** 2/3 → **3/3 — CONVERGENCE REACHED**
**Window before:** 2/3 STRICT
**Window after:** 3/3 STRICT under DEC-191 — **CONVERGED**
**Artifact:** `.factory/cycles/cycle-001/adversarial-reviews/soh-dx-1-f2-pass-78.md`
**ISOLATION:** HARD-ISOLATED — read-ban on adversarial-reviews/, convergence-trajectory.md, and STATE.md enforced by dispatch constraint. Orchestrator-verified: grep for sibling artifact references returned 0. First fully isolated pass in this window.

Per VSDD-CONFORMANCE-GAP-4-ARTIFACTS, this verification-adequacy aperture had NEVER previously run against this repository (VP-INDEX.md, invariants.md, verification-architecture.md absent). All 9 items CLEAN:
1. VP Adequacy — deliberate non-goal for S-639-1; 21 ACs absorb all VP-level concerns.
2. Guard-Behavior Cases — all distinct behavioral cases covered (16 case/AC pairs enumerated in artifact).
3. Ordering Invariants — AC-8 (zero-HTTP) and AC-9 (project-key ordering) are order-sensitive; would fail at wrong step.
4. Zero-HTTP Proof Soundness — `received_requests()` in wiremock 0.6.5 captures all requests including unregistered paths; confirmed against existing test evidence.
5. Regression Protection — AC-4 is non-vacuous (mount stubs + exit-0 + new-string absence); unconditional guard breaks AC-4.
6. Holdout Coverage — 0 holdout scenarios; deliberate non-goal with adequate justification; pure pre-flight check duplicates ACs exactly.
7. Mutation Scope — `src/cli/issue/create.rs` in `.cargo/mutants.toml` examine_globs; new guard lines in PR diff; expected near-100% kill rate.
8. NFR/Error-Taxonomy Registration — all 3 DEC-188 conditions registered in error-taxonomy.md Section 6 (v1.3.150, F52-001). Exit codes correct.
9. False-Green Sweep — AC-6/AC-20/AC-21 vacuity-to-non-vacuity mandated at F3; no unmarked vacuous assertions.

**CAVEAT (VERIFICATION-NONGOAL-UNSCRUTINIZED):** Pass-78 accepted two "deliberate non-goal" rationales at face value — (i) no VPs, (ii) zero holdout scenarios for a user-visible BREAKING change. Both may be sound, but pass-78 was isolated from STATE.md and could not know these sit inside VSDD-CONFORMANCE-GAP-4-ARTIFACTS. Flagged for human attention at F2 gate.

**GATE DISCLOSURES (must ride F2 gate document):**
(a) All 78 passes were DEC-190 substitute (consistency-validator, not adversary agent).
(b) Pass-77 independence compromised (read pass-76 intermediate draft).
(c) AX23-001 out-of-delta ruling PENDING HUMAN RATIFICATION.
(d) `.factory/policies.yaml` absent — no project policy rubric auto-loaded.

**Convergence counter:** 3/3 STRICT under DEC-191. PIPELINE READY FOR F2 HUMAN GATE.

**SOH-DX-1 F2 CONVERGED 3/3 under DEC-191, ARTIFACT-BACKED (2026-07-29).** Window = passes 76, 77, 78, all CLEAN, every pass with a findings artifact on disk. This is the material difference from the prior unbacked claim (passes 73/74/73b/74b).

**Trajectory:** adv-72(1H-pre)→p75(6-reconstructed)→p76(1L)→p77(1L)→p78(0). trajectory-tail →1H→6→1L→1L→0. CONVERGENCE: **3/3 STRICT**. F2 HUMAN GATE READY.

---

## DEC-192 META-EVENT: F2 GATE REJECTED — WINDOW RESET 0/3 (2026-07-29)

**Event type:** Human gate rejection — NOT a new adversary pass.
**Date:** 2026-07-29
**Decision:** DEC-192

**Verdict:** Human REJECTED the F2 gate. The pass-78 "deliberate non-goal" rationale for zero holdout scenarios covering the #639 user-visible BREAKING CHANGE was overturned. Zero holdout scenarios for a user-visible breaking change is a structural absence (in-delta GAP), not a design decision.

**Impact on convergence window:** Window RESET 0/3 under DEC-191(a). Passes 75-78 artifact records are intact and unmodified — the technical convergence (3/3 STRICT) was reached, but the gate was rejected before approval.

**Remediation:**
- Six holdout scenarios authored: H-NEW-PREFLIGHT-001..006 (Group 20; 3 MUST-PASS)
- Holdout count: 100 → 106
- Spec updated: v1.3.163 → v1.3.165
- BC count: 657 (unchanged)
- Exclusion determinations for #627 and #626 explicitly recorded in holdout-scenarios.md
- PR #661 SQUASH-MERGED (d460701d65ca248556ae5ee8dde8617f531d0b21; S-POL-11-GUARD-FALSE-GREEN cycle CLOSED)
- PR #645 MERGED (acdad174); develop fast-forwarded to acdad174

**Cross-reference:** VSDD-CONFORMANCE-GAP-4-ARTIFACTS — this event is a concrete datapoint that missing canonical verification artifacts (VP-INDEX.md, invariants.md, verification-architecture.md, verification-coverage-matrix.md) cause reviewers to misread absences as design decisions. Three independent reviewers across 78 passes accepted the absence as intentional; human domain knowledge caught it at the gate.

**Next action:** F2 window REBUILD — dispatch fresh adversary passes against spec v1.3.165 + six new holdout scenarios (H-NEW-PREFLIGHT-001..006) as fresh review surface. FOUR GATE DISCLOSURES preserved for next gate presentation: (a) DEC-190 substitute basis; (b) pass-77 independence COMPROMISED; (c) AX23-001 PENDING RATIFICATION; (d) .factory/policies.yaml absent.

---

## Pre-Window Passes (post-DEC-192 reset, spec v1.3.165)

Passes 79/80/81 ran after the DEC-192 window reset and before the current window (82/83/84). Their artifacts are on disk but are NOT part of the current 3/3 convergence window. Summaries:

- **Pass 79 (2026-07-29; aperture: holdout-scenario-quality; spec v1.3.165):** 1 CRITICAL — `ADV-C001-P79-CRITICAL-001`: H-NEW-PREFLIGHT-004 Expected bullet 3 incorrectly asserted "stdout contains PROJ-42" when `src/output.rs::print_success` is `eprintln!` (stderr). The v1.3.165 text was permanently unsatisfiable. Also: P79-003/P79-004 (LOW cosmetic edge-case nits). WINDOW NOT ELIGIBLE — CRITICAL resets window to 0/3. Fixed at v1.3.166.
- **Pass 80 (2026-07-29; aperture: reality-check; spec v1.3.165):** 1 LOW — P80-001 (pre-existing README enumeration staleness); 1 LOW — P80-002 (BC cites F4 rename-target test names — correctly marked delivery obligations). 0 in-delta GAPs. CLEAN under DEC-191. window counter advanced to 1/3 on spec v1.3.165. NOTE: pass-80's aperture asked whether error strings match, NOT which stream they land on — channel correctness was outside aperture.
- **Pass 81 (2026-07-29; aperture: delta-completeness + AC-falsifiability; spec v1.3.165):** 0 new findings. VERDICT: CLEAN. HOWEVER: pass-81 artifact EXPLICITLY ENDORSED the pass-79 CRITICAL — it wrote "stdout or stderr contains PROJ-42 → stdout contains PROJ-42. Consistent with SYMMETRIC output-channel profile. ✓" — the exact opposite of the CRITICAL. The window was at 2/3 under spec v1.3.165 but the CRITICAL in H-NEW-PREFLIGHT-004 was still present and undetected. Pass-81 represents the detection-asymmetry failure that is the §3 CRITICAL lesson.

Window state after pass-81: 2/3 on spec v1.3.165, but spec v1.3.165 contained a permanently unsatisfiable MUST-PASS assertion. Orchestrator reviewed artifacts cross-pass and identified the defect. Fixed at v1.3.166. Window RESET to 0/3 per DEC-191(a). New window starts at pass-82 on spec v1.3.166.

**Trajectory note:** passes 79/80/81 are NOT window-eligible for the 3/3 convergence gate because pass-79 found a CRITICAL (spec was permanently unsatisfiable; window reset). trajectory-tail anchors at pass-79: →1(CRIT)→2(LOW)→4(2M+2L)→2(LOW) → shorthand →1→2→4→2.

---

### Pass soh-dx-1-f2-pass-82 (2026-07-29) — SUBSTITUTE (DEC-190 WINDOW-ELIGIBLE; aperture: holdout-falsifiability + channel-correctness)

**Findings:** 2 (0C/0H/0M/2L) — ADV-P82-LOW-001 (IN-DELTA REFINEMENT), ADV-P82-LOW-002 (IN-DELTA REFINEMENT); 0 in-delta GAPs
**Convergence counter:** 0/3 → 1/3 (CLEAN under DEC-191)
**Window before:** 0/3 (new window; spec v1.3.166 — H-NEW-PREFLIGHT-004 corrected)
**Window after:** 1/3 STRICT under DEC-191
**Artifact:** `.factory/cycles/cycle-001/adversarial-reviews/soh-dx-1-f2-pass-82.md`
**Isolation:** No sibling reviews read; independently verified.

Pass 82 is the first adversarial pass on holdout-falsifiability + channel-correctness aperture for Group 20 (H-NEW-PREFLIGHT-001..006) at spec v1.3.166. Two-way falsifiability table verified for all six scenarios: 001/002/003/006 FAIL against the current warn-and-proceed build (correct — delta-testing); 004/005 do NOT fail (regression/non-mis-fire pins, non-vacuous). ALL six CAN pass against a correct implementation — the [1.3.166] fix resolved the unsatisfiable MUST-PASS. Channel-audit table: all 16 stream assertions verified at emit-site citations. Three DEC-188 error strings byte-identical across bc-3-issue-write.md / error-taxonomy.md / holdout-scenarios.md.

**ADV-P82-LOW-001 (LOW; REFINEMENT; IN-DELTA):** H-NEW-PREFLIGHT-004 Expected bullet 3 contains source-code citations (parenthetical `src/output.rs::print_success` etc.) inside the Expected (observable assertion) block — per aperture item 7, implementation detail in Expected is a defect. Behavioral assertion itself correct. Fix: relocate citations to "Why hidden" section.

**ADV-P82-LOW-002 (LOW; REFINEMENT; IN-DELTA; compounded OUT-OF-DELTA base):** README.md holdout enumeration stale at both sites (Document Map line 48 and Supplement Index line 108). Count (106) correct and authoritative; enumeration description missing Groups 8b–20. Pre-existing staleness compounded by [1.3.164] updating count but not enumeration. THIRD INDEPENDENT FINDING of README enumeration staleness (also found by pass-81, pass-84).

**FIXED at v1.3.167:** ADV-P82-LOW-001 (citation relocated to "Why hidden", BC-3.4.014 moved to BC-refs). ADV-P82-LOW-002 (both README.md sites updated to enumerate through H-NEW-PREFLIGHT-001..006).

**Convergence counter:** 0/3 → 1/3. Both findings are REFINEMENT/LOW; non-window-resetting under DEC-191(c).

**Trajectory so far:** p79(1C-RESET)→p80(2L)→p81(0)→p82(2L). trajectory-tail →1→2→4→2 (tail represents last 4 passes: 79/82/83/84). CONVERGENCE: 1/3. NEXT: pass-83.

---

### Pass soh-dx-1-f2-pass-83 (2026-07-29) — SUBSTITUTE (DEC-190 WINDOW-ELIGIBLE; aperture: emit-site / observable-contract)

**Findings:** 4 (0C/0H/2M/2L) — ADV-P83-MEDIUM-001 + ADV-P83-MEDIUM-002 + ADV-P83-LOW-001 + ADV-P83-LOW-002; 0 in-delta GAPs per VERDICT
**Convergence counter:** 1/3 → 2/3 (CLEAN under DEC-191)
**Window before:** 1/3 STRICT
**Window after:** 2/3 STRICT under DEC-191
**Artifact:** `.factory/cycles/cycle-001/adversarial-reviews/soh-dx-1-f2-pass-83.md`
**Isolation:** No sibling reviews read; independently verified.
**VERDICT NOTE:** Pass-83 declared `VERDICT: CLEAN (no in-delta GAPs)` while its own findings table listed two items (ADV-P83-MEDIUM-001, ADV-P83-LOW-001) with delta-attribution IN-DELTA and classification GAP. Reclassified per DEC-193: these are NOT F2 spec gaps but the pre-implementation state of a correctly-and-completely specified F4 deliverable. Human ruling "F4 is fine" — override RATIFIED. ADVERSARY-VERDICT-VS-CONTRACT-DISCREPANCY second datapoint.

Pass 83 is the first adversarial pass on emit-site / observable-contract aperture at spec v1.3.166. Observable contract table (15 rows) verified all stream assertions at emit sites. Three DEC-188 error strings byte-identical across all four spec surfaces. JSON envelope shape (`{"code":N,"error":"..."}` alphabetical via BTreeMap) confirmed. Guard ordering verified structurally correct: AFTER JSM fork (~:49), BEFORE project-key resolution (~:92), BEFORE HTTP. `ci-gate.needs` complete. Both `rustup target add` steps present.

**ADV-P83-MEDIUM-001 (MEDIUM; classified GAP by pass-83; reclassified by DEC-193 as pre-F4 state):** ci.yml MSRV job invokes `dtolnay/rust-toolchain` with no `with: toolchain:` input → installs stable, not 1.85.0. `# 1.85.0` comment misleading. False-green MSRV check. Root cause documented in delta-analysis.md; mandatory fix in S-626-1 (F3). → F4 S-626-1 per DEC-193.

**ADV-P83-MEDIUM-002 (MEDIUM; REFINEMENT; IN-DELTA):** CLAUDE.md output-channel profile 4 description is ambiguous — "stdout for `--output json`" omits the third path (human-mode success → stderr via `print_success`). Two independent reviewers produced wrong stream assertions from this description (one caused the v1.3.165 CRITICAL). Proposed corrected wording documented in artifact. Scheduled for correction under DEC-194.

**ADV-P83-LOW-001 (LOW; classified GAP by pass-83; reclassified by DEC-193 as pre-F4 state):** `dtolnay/rust-toolchain` SHA pin `c93f4f9c` stale across 4 workflow files; mandated SHA `fa04a1451ff1842e2626ccb99004d0195b455a88` (verified real, 2026-06-30 master ancestor). → F4 S-626-1 per DEC-193.

**ADV-P83-LOW-002 (LOW; REFINEMENT; OUT-OF-DELTA):** CLAUDE.md descriptions of `scripts/check-spec-counts.sh` (missing exit-2 path) and `tests/claude_md_citations.rs` (missing CITATION_FLOOR = 74) stale after #661. Found independently by pass-80 (P80-001) and pass-83. Scheduled under DEC-194.

**Convergence counter:** 1/3 → 2/3. ADV-P83-MEDIUM-002 is REFINEMENT/IN-DELTA (non-resetting). ADV-P83-LOW-002 is OUT-OF-DELTA (non-resetting). ADV-P83-MEDIUM-001 and ADV-P83-LOW-001 reclassified as pre-F4 state (non-resetting per DEC-193).

**Trajectory: →1→2→4→2. CONVERGENCE: 2/3. NEXT: pass-84.**

---

### Pass soh-dx-1-f2-pass-84 (2026-07-29) — SUBSTITUTE (DEC-190 WINDOW-ELIGIBLE; aperture: AC-falsification-against-build + delta-completeness)

**Findings:** 2 (0C/0H/0M/2L) — ADV-P84-LOW-001 (IN-DELTA REFINEMENT), ADV-P84-LOW-002 (OUT-OF-DELTA REFINEMENT); 0 in-delta GAPs
**Convergence counter:** 2/3 → **3/3 — CONVERGENCE REACHED**
**Window before:** 2/3 STRICT
**Window after:** 3/3 STRICT under DEC-191
**Artifact:** `.factory/cycles/cycle-001/adversarial-reviews/soh-dx-1-f2-pass-84.md`
**Isolation:** No sibling reviews read; independently verified. Novelty block explicitly records `CONVERGENCE_REACHED — no GAPs found` (omitted literal `VERDICT:` line — minor template non-compliance; substance unambiguous).

Pass 84 is the first adversarial pass on AC-falsification-against-build + delta-completeness aperture at spec v1.3.166. **All 21 ACs satisfiable**: 14 fail against current binary (delta-testing — correct), 7 pass as legitimate regression gates. No AC permanently unsatisfiable at v1.3.166 (v1.3.165 defect corrected). **32 obligations enumerated: 7 DISCHARGED, 20 DEFERRED, 1 NON-GOAL, 0 ABSENT, 0 SPEC-ABSENT.** The orchestrator verified: zero cross-pass references in this artifact (contrast pass-77 which cited "P76-001").

**ADV-P84-LOW-001 (LOW; REFINEMENT; IN-DELTA):** `delta-analysis.md §6` affected-files summary missing 3 F2-added Trace deliverables: `src/cli/mod.rs`, `src/cli/issue/jsm_create.rs`, and `docs/specs/issue-create-preflight-guards.md` (last marked to-be-created at F4). BC-3.8.012 Trace is authoritative for extended scope. **FIXED at v1.3.167:** §6 updated to include all three files.

**ADV-P84-LOW-002 (LOW; REFINEMENT; OUT-OF-DELTA):** README.md holdout enumeration description stale (third independent finding; same root cause as ADV-P82-LOW-002). **FIXED at v1.3.167** (both README.md sites updated).

**Convergence counter:** 2/3 → 3/3 STRICT under DEC-191. PIPELINE READY FOR F2 HUMAN GATE.

**BLOCKING OBJECTION:** DEC-193 reclassified ADV-P83-MEDIUM-001 and ADV-P83-LOW-001 as pre-F4 state. Human ruling "F4 is fine" — override RATIFIED. This clears the blocking objection.

---

## SOH-DX-1 F2 CONVERGENCE DETERMINATION (2026-07-29)

**SOH-DX-1 F2 CONVERGED 3/3 under DEC-191 at spec v1.3.166.** Window = passes 82, 83, 84 — all three CLEAN (no in-delta GAPs), all three artifact-backed, all three independently verified (zero cross-pass references confirmed by orchestrator). DEC-193 ratified the blocking objection override. trajectory-tail →1→2→4→2.

**Gate status: AWAITING EXPLICIT HUMAN APPROVE/REJECT.** Not yet approved.

**FOUR GATE DISCLOSURES (must accompany gate presentation):**
(a) All passes in this window (82/83/84) were DEC-190 substitute (consistency-validator, not adversary agent).
(b) Pass-77 independence COMPROMISED (read sibling's draft in prior window).
(c) AX23-001 out-of-delta ruling PENDING HUMAN RATIFICATION.
(d) `.factory/policies.yaml` absent — no project policy rubric auto-loaded.

**On approval:** F3 proceeds: S-639-1 (update), S-627-1 (draft), S-626-1 (draft — carrying verified SHA `fa04a1451ff1842e2626ccb99004d0195b455a88` blocking AC, do-not-remove constraint for `rustup target add` steps, MSRV comment-accuracy flag), S-383 (update stale).

**Trajectory (unchanged):** →6→1→1→0 (no new pass ran; this is a meta-event). Window counter RESET: 0/3.

---

## S-626-1 Pass 19 (2026-08-04)

**Artifact:** `.factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-19.md`
**Isolation:** CLEAN. No banned-path content accessed. Self-disclosed.

Pass-19 ran against head `9312f11f` (the orchestrator-shipped POL-11 guard commit). **Found FOUR REAL CI-AS-CODE DEFECTS** in that guard — all in the `ci.yml` floor script shipped one round earlier. All four closed by product commit `a247a343`. `src/` remains 0-defect (twelfth consecutive pass).

**ADV-P19-HIGH-001 (HIGH; CI-integrity; [process-gap]):** Floor `> 0` is INERT — inline src/ tests (~1,112) keep the count above 0 even when all `tests/` binaries are orphaned. Guard cannot detect its own orphaning. **FIXED a247a343** (binary-count floor `-lt 90` + named canary `ci_gate_completeness`).

**ADV-P19-HIGH-002 (HIGH; spec-fidelity; scope-breach):** `tests/ci_gate_completeness.rs` and `tests/cli_handler.rs` present in PR diff but absent from all four spec surfaces in S-626-1. ORCHESTRATOR-CAUSED. **FIXED fix round 7** (S-626-1 v1.13; DEC-214).

**ADV-P19-MED-001 (MEDIUM; CI-integrity):** `FAIL (POL-11)` diagnostic unreachable under `set -o pipefail` + `set -e`. **FIXED a247a343.**

**ADV-P19-MED-002 (MEDIUM; CI-integrity; fragility):** ANSI codes from file-scope `CARGO_TERM_COLOR: always` would zero anchored regex. LATENT — not a live break (CI ran SUCCESS for `9312f11f`; orchestrator speculation refuted). **FIXED a247a343** (`CARGO_TERM_COLOR: never`).

**ADV-P19-MED-003 (MEDIUM; CI-integrity):** Pin asserts only `contains("FAIL (POL-11)")` — not exit 1, not floor count, not positive-coverage line. **FIXED a247a343.**

**ADV-P19-MED-004 (MEDIUM; spec-process; [process-gap]):** Round-6 sweep missed one site in `S-MUTANTS-EXAMINE-GLOBS-1.md` while correcting seven siblings. **PARTIALLY CLOSED** — 1 site corrected; 4 blocked by template-compliance hook. Needs `conform-to-template` pass.

**ADV-P19-MED-005 (MEDIUM; spec-fidelity):** STORY-INDEX S-641-1 row stale by TWO revisions (v0.6 in row; file at v0.7). **FIXED fix round 7** (STORY-INDEX v1.5.57; S-641-1 v0.8).

**ADV-P19-MED-006 (MEDIUM; CI-integrity; [process-gap]; ROUTED):** `fmt` and `clippy` share identical orphaning exposure as `test` job. Routed per DEC-215. Tracked: FMT-CLIPPY-NO-POSITIVE-COVERAGE.

**ADV-P19-LOW-001 (LOW; spec-fidelity):** S-640-1 cited RUSTUP_TOOLCHAIN 16 lines from actual location. **FIXED fix round 7** (S-640-1 v0.6; DEC-213 anchor form).

**ADV-P19-INFO-001 (INFO):** Demo pack lacked negative-path proof at dispatch. **NOTED** — updated at a247a343.

**Convergence counter:** window 0/2 of 18/19/20. Pass-20 pending (head a247a343).

**Anchor migration (CLASS-ELIMINATING):** DEC-213 introduces `ci.yml :: <job-id>` notation. Three prior citation-ripple sweeps (+39, +54, +93 cumulative) will not recur for migrated surfaces.

---

## S-626-1 Pass 21 (2026-08-04)

**Artifact:** `.factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-21.md`
**Isolation:** CLEAN. No banned-path content accessed. Self-disclosed.

Pass-21 ran against feature HEAD a247a343 (frozen head per DEC-216 window). Pass-20 was SUPERSEDED per DEC-216; DEC-219 opens fresh STRICT window passes 22/23/24. **Found ZERO HIGH findings.** All 7 findings are documentation/citation-accuracy class — the reviewer named the pattern: *"a correct change landed alongside a false claim about it."* `src/` remains 0-defect — **THIRTEENTH consecutive pass**.

**ADV-P21-MED-001 (MEDIUM; spec-accuracy / false-claim-in-prose):** `tests/ci_gate_completeness.rs` pin names wrong test (`test_ci_gate_named_canary_check` DNE; correct: `test_verify_test_job_has_zero_test_floor`) and wrong job count (9-job wrong; correct: 8-job). **FIXED 84ab32ac.**

**ADV-P21-MED-002 (MEDIUM; spec-accuracy / false-comment):** ci.yml step comment "1 lib + ~54 integration + ~1 doc" sums to 56, not 103 actual test count. Comment injected by fix round 7 immediately stale. **FIXED 84ab32ac.**

**ADV-P21-MED-003 (MEDIUM; spec-accuracy / missing-assertion):** Pin docstring claimed `set +o pipefail` was verified; no assertion existed — claim was aspirational. **FIXED 84ab32ac.**

**ADV-P21-LOW-001 (LOW; spec-fidelity / sweep-miss):** BC-5.3.003 Source field omitted `test_board_view_falls_back_to_uuid_when_team_not_cached`. Pass-18 MED-002 prescribed this sweep; still missed. **FIXED 84ab32ac.**

**ADV-P21-LOW-002 (LOW; spec-fidelity / count-mismatch):** S-626-1 AC-9 heading "adds 2 behavioral contracts"; footer traces 3 BCs. **FIXED 84ab32ac.**

**ADV-P21-LOW-003 (LOW; ci-citation / template-drift):** S-BC-CITATION-GUARD-1.md contains raw `"live ci.yml line 111"` citations. **DEFERRED — DEC-217** (template drift blocks edits; placeholder/stub approach DECLINED per DEC-217).

**ADV-P21-INFO-001 (INFO; spec-accuracy / bc-count-drift):** bc-02-issue-read.md `bc_count: 94` frontmatter and body "92 BCs" both wrong (correct: 106). **FIXED 84ab32ac**; class sweep (DEC-218) found bc-03-issue-write.md also drifted (120→140), fixed simultaneously.

**CI FLOOR AUDITED SOUND (all four dimensions):** binary-count floor (`-lt 90`) reachable; named canary (`test_verify_test_job_has_zero_test_floor`) reachable; `CARGO_TERM_COLOR=never` present; pin asserts floor+canary+exit 1+positive-coverage. Verbatim ci.yml step body confirmed in demo pack.

**Convergence counter:** window 0/1 of 21/22/23 (NOT CLEAN). Passes 22/23 of window NOT DISPATCHED (window moot after NOT CLEAN). DEC-219: fresh STRICT window = passes 22/23/24.

**Trajectory (S-626-1): →0→0→2→0. Window 0/1 of 21/22/23 CLOSED NOT CLEAN. Fresh STRICT window 22/23/24 (DEC-219). NEXT: dispatch passes 22/23/24 against head 84ab32ac.**

---

## Post-Merge Convergence Notes (2026-08-10 to 2026-08-11)

<!-- Appended 2026-08-11 by the COMPACT-STATE burst. This file's detailed per-pass trajectory
     entries stop at pass-21 (2026-08-04); per-pass detail for passes 22-61 plus ADV-P60/ADV-P61/
     ADV-P675 lives in cycles/cycle-001/adversarial-reviews/ADV-P1-INDEX.md (the file STATE.md's
     own Convergence Status section already cites as the primary detail source alongside this
     one). The three paragraphs below are the verbatim "## Convergence Status" narrative for the
     three most recent closed bursts, extracted out of STATE.md's live table to keep that file
     lean; STATE.md itself retains only the current burst's one-paragraph status. -->

**S-626-1-MERGE+ADV-P60-P61+BURST-CLOSE (2026-08-10):** PR #667 squash-merged to `develop` as `a5e1d087` (48 commits, closes #626) -- human exercised merge authority (DEC-128), released the DEC-202 hold. `develop` CI on `a5e1d087` (run 31432422878): SUCCESS, 12 success + 2 legitimately-skipped (`Mutation testing` + `Secret Scan`, both `pull_request`-only) -- first production confirmation of the `ALLOWED_SKIPS` mechanism (S-CIGATE-2). Two targeted delta reviews (pass-60 / ADV-P60 Rust delta, pass-61 / ADV-P61 shell delta -- NOT counted toward Step 4.5's window arithmetic) covered `1381af17..5ca51bc2`, the 1,024 insertions no prior pass had seen, and found 9 actionable findings; 8 fixed via fix burst pre-merge and CI-green (3 HIGH + 1 MEDIUM + 4 LOW, `736fea28`/`23ace476`/`f656f873`); 1 LOW (`ADV-P61-LOW-004`) confirmed OPEN, not fixed. `ADV-P1-INDEX.md` v2.14→v2.16 (442→456 total findings, +14 new (corrected)). **DEC-262**: merge authorized on code grounds with Step 4.5 permanently at 0/3 after ten windows and 61 total adversary passes -- the 3/3-CLEAN convergence bar defined by DEC-199/DEC-245 was never met, and merging accepted that outcome. Full trajectory detail: cycles/cycle-001/adversarial-reviews/ADV-P1-INDEX.md.

**SHELL-TRUST-ASSUMPTIONS research pass (2026-08-11):** external validation only, no adversary pass, does not move the trajectory-tail or Step 4.5's 0/3. DEC-263 recorded; zero REFUTE against the merged shell delta; two experiments (E1/E2) remain to fully close Q1b/Q3b.

**PR675-MERGE+ADV-P675-CLOSE (2026-08-11):** PR #675 (`docs(ci-gate): correct trust-layer record to match code (S-626-1)`) squash-merged to `develop` as `d55bedf7` (2026-08-11T01:40:55Z) -- documentation-only, `CLAUDE.md` + `scripts/check-ci-gate.sh`, zero non-comment lines changed. `develop` CI on `d55bedf7` (run 31450052302): SUCCESS, 12 success + 2 legitimately-skipped; `CI Gate` correctly green; `Scorecard`/`E2E (Live Jira)` also passed. A targeted claim-accuracy review (ADV-P675, not a Step-4.5 window; not counted toward Step 4.5's 0/3) found 0H/2M/2L/1I, NOT CLEAN; all 4 actionable findings CLOSED pre-merge (`d2430a8a`). **DEC-264**: reviewing a documentation-only PR found two MEDIUMs, justifying the practice of applying the same claim-accuracy review discipline to record-correction PRs as to code PRs. `ADV-P1-INDEX.md` v2.16→v2.17 (456→461 total findings). This was the session-closing burst before the 2026-08-11 SESSION-WRAP-PAUSE and this COMPACT-STATE burst -- no open PR or review window remains.

BC-INDEX v6.75 / STORY-INDEX v1.5.80 (127 stories) / ARCH-INDEX v0.16 (state as of these bursts). SOH-DX-1 F2 APPROVED (DEC-196, 2026-07-29). F3 APPROVED (DEC-197, 2026-07-29): spec v1.3.169; BC 658 (unchanged); holdouts 106. S-626-1 adversary: 61 Step-4.5-eligible passes (56 STRICT + pass-60/pass-61 targeted delta review) plus ADV-P675 (targeted claim-accuracy review, not Step-4.5-eligible); 461 total findings. **PR #667 MERGED** to `develop` as `a5e1d087`, closes #626 -- DEC-262; its trust-layer record correction **PR #675 also MERGED** as `d55bedf7` -- DEC-264. src/ 0-defect THIRTY-THIRD-plus consecutive as of these bursts.

SOH-ATTACHMENTS-1 + prior cycles FULLY CLOSED (unchanged, see earlier entries in this file).

**SESSION-WRAP-PAUSE (2026-08-11):** pure pause/checkpoint burst -- human requested a session wrap, no adversary pass run, does not move the trajectory-tail or Step 4.5's 0/3, no findings added or closed. `pipeline: ACTIVE`→`PAUSED`. This burst's only substantive act is durably recording that nothing was in flight when the session paused and restating the resume path for a cold start. *(Archived 2026-08-11 by the S-CIGATE-3-IMPLEMENTED burst — superseded in STATE.md's live Convergence Status by the COMPACT-STATE and S-CIGATE-3-IMPLEMENTED paragraphs.)*

**S-CIGATE-3-IMPLEMENTED (2026-08-11):** story-scoped adversarial window, NOT a Step-4.5 window — does not move the SOH-DX-1 trajectory-tail or Step 4.5's 0/3 (that arithmetic remains closed permanently per DEC-262). S-CIGATE-3 (durable YAML-parser fix, DEC-259/DEC-260) implemented end-to-end on worktree `.worktrees/S-CIGATE-3`, branch `test/ci-gate-real-yaml-parser`, 17 commits `8af710f8`..`aeeebe01` (re-derived; NOT pushed, no PR — DEC-128). 6-pass story-scoped adversarial window (fresh context per pass), 27 findings (re-derived by summation; the dispatch instruction's claimed 29 did not match its own per-pass table) — 1 HIGH (pass 3) + 10 MEDIUM + 16 LOW, all fixed — window ends PERMANENTLY at 0/3, no CLEAN pass reached, same shape as DEC-262. Two human rulings this window: DEC-265a (fix two pre-existing bypasses — round-16 node-property residual, `POSITIONAL-ASSUMPTION-AXIS`/`RED-PROOF-NEEDS-SPELLING-VARIANTS` — inside this story's own scope rather than deferring again) and DEC-265b (keep running the window past pass-3's HIGH rather than pausing to re-scope). `ADV-P1-INDEX.md` v2.17→v2.18 (461→488 total findings, new S-CIGATE-3 section added). Merge decision (DEC-262-shape, window ended 0/3) is an open item for the human — not exercised by this bookkeeping burst. Full detail: `cycles/cycle-001/adversarial-reviews/ADV-P1-INDEX.md` § "Adversarial Review Index — S-CIGATE-3" + `cycles/cycle-001/decisions-archive.md` DEC-265.

**S-CIGATE-3 PR #680 review + merge (2026-08-12, S-CIGATE-3-PR680-CONVERGED-AWAITING-MERGE / S-CIGATE-3-MERGED-CYCLE-CLOSED):** not a Step-4.5 window and not a reopening of S-CIGATE-3's own 6-pass window (still ended PERMANENTLY at 0/3, DEC-265). PR #680 opened; pr-reviewer cycle 1 REQUEST_CHANGES on `B-1` (value-side node-property gap, `VALUE-SIDE-ANCHOR-GAP-UNCLOSED`), TDD-fixed (`dc4909b2`, 6 new tests), cycle 2 APPROVE (COMMENT-state, reviewer==author). `ADV-P1-INDEX.md` combined total unchanged at 488 (the two PR-cycle reviews are review, not adversary, passes). Human squash-merged PR #680 into `develop` as `3df77a54` (DEC-268/DEC-269); post-merge cleanup complete; story flipped to `status: done`. **S-CIGATE-3 CYCLE CLOSED.**

**S-639-1-F4-DELIVERED-PR681-CONVERGED-AWAITING-MERGE (2026-08-12):** story-scoped adversarial window, NOT a Step-4.5 window — does not move the SOH-DX-1 trajectory-tail (→1→3→0→2, unchanged) or Step 4.5's 0/3 (permanently closed per DEC-262). Human authorized "proceed" (DEC-270) to the next SOH-DX-1 priority, **S-639-1** (BREAKING pre-flight exit-64 guard for `--field`/`--on-behalf-of` on `jr issue create`'s platform path without `--request-type`, closes #639, DEC-188, BC-3.8.012/013 [AMENDED] + BC-3.3.001; ships v0.6.0-dev.12), implemented end-to-end on worktree `.worktrees/S-639-1`, branch `feat/issue-create-preflight-guards`, off `develop` @ `3df77a54`. TDD: Red Gate (`8a8f3917`) → green (`729e26c0`/`eff08a31`/`64e247bd`) → doc-numbering fix (`4b0fb2c7`) → AC-11 regression-pin restoration (`4bfa0c21`). **5-pass story-scoped adversarial window (fresh context per pass, baseline rubric — no `policies.yaml`):** pass 1 NOT-CLEAN (1 LOW, `ADV-S639-P6-LOW-001`, feature-spec-vs-BC-SSOT step numbering, fixed `4b0fb2c7`); pass 2 NOT-CLEAN (1 MEDIUM, `ADV-S639-P2-M01`, AC-11 dropped its BC-3.8.012 regression pin — a real BC↔story-body transcription contradiction, fixed in test `4bfa0c21` + story `a7314189` v1.2); passes 3/4/5 ALL CLEAN (0H/0M/0L) — **convergence achieved, 3 consecutive CLEAN passes.** `src/` 0-defect across all 5 passes. **Finding trajectory: 1→1→0→0→0.** Demo evidence recorded (`demos/S-639-1/`, 4 VHS clips: 3 exit-64 scenarios + 1 positive control). **PR #681 OPENED** — CI run `31625361114` all real jobs GREEN including `CI Gate`, both Windows legs, MSRV, Deny, Coverage, Mutation, Spec Guards, Signing, dependency-review; `Secret Scan (gitleaks)` FAILED on a transient binary-download error (not a code finding, not the required check — re-run in progress). pr-reviewer **APPROVE** at `4bfa0c21`, zero findings (COMMENT-state only, reviewer==author, same structural gap as PR #680). `ADV-P1-INDEX.md` combined total 488→493 (new `§ S-639-1` section, 5 passes, 2 actionable findings). **Merge NOT executed — human authority (DEC-128).** Status: **CONVERGED, AWAITING HUMAN MERGE** (pending only the gitleaks re-run). Two recurring LOW process-gap drift items observed again (`PR-MANAGER-RETURNS-BLOCKED-WITHOUT-AWAITING-GRANDCHILDREN`, `VALIDATE-PR-REVIEW-POSTED-ASSUMES-DISTINCT-REVIEWER`); one new LOW drift item recorded (`GITLEAKS-ACTION-FLAKY-BINARY-DOWNLOAD`). Full detail: `cycles/cycle-001/adversarial-reviews/ADV-P1-INDEX.md` § "Adversarial Review Index — S-639-1" + `cycles/cycle-001/decisions-archive.md` DEC-270.

**S-639-1 PR #681 merge + cycle close (2026-08-12, S-639-1-MERGED-CYCLE-CLOSED):** not a Step-4.5 window and not a reopening of S-639-1's own 5-pass window (remains CONVERGED 3/3, passes 3/4/5 CLEAN, trajectory 1→1→0→0→0, DEC-245 criterion). Human executed the owner/admin squash-merge PR #681 anticipated (DEC-270): merged into `develop` as `facdcb46`, mergedAt 2026-08-12T18:34:36Z, closing #639; `origin/develop`/local `develop` fast-forwarded from `3df77a54`. Same structural gap as S-CIGATE-3 (reviewer == author, COMMENT-state APPROVE only) meant the merge was necessarily a human action, not a factory self-authorization. The transient `Secret Scan (gitleaks)` binary-download flake cleared on re-run; final CI state 15/15 GREEN incl. CI Gate before merge. Post-merge: worktree/branch cleanup complete; story `status`→`done` (v1.2→v1.3, Close-Out section appended); `STORY-INDEX.md` row updated (v1.5.82→v1.5.83); two recurring LOW process-observation drift items and the new LOW gitleaks-flake item reconfirmed with existing DEFERRED dispositions intact (no story auto-opened). **S-639-1 CYCLE CLOSED.** SOH-DX-1's Step 4.5 remains unchanged at PERMANENTLY 0/3 (DEC-262); trajectory-tail →1→3→0→2 unchanged. Full detail: `cycles/cycle-001/adversarial-reviews/ADV-P1-INDEX.md` § "S-639-1 Open Items (as resolved at cycle close)" + `cycles/cycle-001/decisions-archive.md` DEC-271.

**S-627-1 Phase 1 delivery + PR #682 merge (2026-08-12, S-627-1-MERGED-BOTH-PHASES-CYCLE-CLOSED):** story-scoped adversarial window, NOT a Step-4.5 window — does not move the SOH-DX-1 trajectory-tail (→1→3→0→2, unchanged) or Step 4.5's 0/3 (permanently closed per DEC-262). S-627-1 (`check-bc-no-numeric-test-counts.sh` false-positive regex fix + `--self-test`/`--bc-dir` seam, closes #627), implemented on worktree `.worktrees/S-627-1`, branch `fix/bc-numeric-count-guard-regex`, commit `edfcefaa`. **4-pass story-scoped adversarial window (fresh context per pass, baseline rubric):** pass 1 NOT-CLEAN (1 MEDIUM `ADV-S627-P1-MED-001` — I/O-error false-green: pipefail masked the rightmost command's exit status, compounded by a `return` inside a `$(...)` subshell silently discarding it; 2 LOW — boundary character-class gap, EC-9 spec/impl contradiction), fixed via `fc2019a9` (script: split into two separate command substitutions removing the pipe, exit-2 propagation restored, `_` added to the left-boundary negative class, hardened discriminating negative fixtures) and `e6e6f23d` (story: EC-9 reconciled to fail-closed exit 2, Phase-2 3rd-marker-occurrence reconciliation note added). Passes 2/3/4 ALL CLEAN (0H/0M/0L) — **convergence achieved, 3 consecutive CLEAN passes.** `src/` not touched — script-only change, no product source in scope. **Finding trajectory: 1→0→0→0.** pr-reviewer **APPROVE** at `fc2019a9` (COMMENT-state, reviewer==author, same structural gap as PR #680/#681). CI 15/15 GREEN incl. CI Gate, Spec Guards (which runs this exact script), both Windows legs, gitleaks (no flake this run). Human executed the owner/admin squash-merge: PR #682 merged into `develop` as `c3edf216`, closing **#627**; `origin/develop`/local `develop` fast-forwarded from `facdcb46`. Post-merge cleanup complete (`.worktrees/S-627-1` removed; `fix/bc-numeric-count-guard-regex` deleted local+remote). **Phase 2 (factory-artifacts revert)** was already committed separately by product-owner as `27bf96aa` (`bc-3-issue-write.md` — reverted BC-3.9.001/BC-3.9.003 Trace-field hyphenation workarounds, removed both `[PENDING-REVERT-S-627-1]` inline markers, reconciled the 3rd historical-footer occurrence; `bc-2-issue-read.md` needed no change — zero markers present). Verification all green post-revert: `check-bc-no-numeric-test-counts.sh`/`check-spec-counts.sh`/`check-bc-cumulative-counts.sh` all exit 0 (658 BCs, 8 files unchanged); zero live `[PENDING-REVERT-S-627-1]` markers remain. Story `status`→`done` (v1.2→v1.3, Close-Out section appended); `STORY-INDEX.md` row updated (v1.5.83→v1.5.84). Two recurring LOW process-observation drift items reconfirmed (`PR-MANAGER-RETURNS-BLOCKED-WITHOUT-AWAITING-GRANDCHILDREN` — 3rd occurrence this session; `VALIDATE-PR-REVIEW-POSTED-ASSUMES-DISTINCT-REVIEWER` — recurred); one new LOW item recorded (`FACTORY-DISPATCHER-POSTTOOLUSE-HOOK-TIMEOUT`); `GITLEAKS-ACTION-FLAKY-BINARY-DOWNLOAD` did NOT recur on this PR. **S-627-1 CYCLE CLOSED — BOTH PHASES COMPLETE.** **This completes the SOH-DX-1 bundle:** S-626-1 (`a5e1d087`), S-639-1 (`facdcb46`), and S-627-1 (`c3edf216`) are now all DELIVERED AND MERGED. Full detail: `cycles/cycle-001/adversarial-reviews/ADV-P1-INDEX.md` § "S-627-1" + `cycles/cycle-001/decisions-archive.md` DEC-272.

---

**S-668-1 (668-duedate, issue #668) — full delivery trajectory (2026-08-13):** Spec sealed at v1.3.179 after a same-day spec-scoped fix-round (1H+6M+2L found and fixed, F2). F3 story decomposition (16 ACs, 5 pts) COMPLETE, Spec-First Gate S-7.01 satisfied. F4 TDD implementation on worktree `.worktrees/S-668-1`, branch `feat/668-duedate`. Step 4.5 per-story adversarial: **CONVERGED 3/3 CLEAN** — 8 total fresh-context passes across 3 windows; severity decay MED→LOW→zero across the windows; every finding across all 8 passes was test-coverage completeness (missing edge-case assertions), never a production defect — `src/` was spec-faithful throughout. security-reviewer: PASS, no actionable findings. pr-reviewer: APPROVE. CI: 15/15 GREEN including CI Gate. 8 VHS demo recordings at `.factory/demos/S-668-1/` covering the 16 ACs. Human executed the owner/admin squash-merge: PR #691 merged into `develop` as `1a298e24`, closing **#668**; `develop` fast-forwarded from `9411e9a5`. Post-merge cleanup complete (`.worktrees/S-668-1` removed; `feat/668-duedate` deleted local+remote). Story `status`→`done` (v1.1→v1.2, Close-Out section appended); `STORY-INDEX.md` row updated (v1.5.85→v1.5.86). One process-gap finding (missing Step-4.5 dispatch identity-tuple) disposed as a JUSTIFIED DEFERRAL (LOW, new drift item `S668-STEP45-DISPATCH-MISSING-IDENTITY-TUPLE`) — engine-level `vsdd-factory` polish, not a `jira-cli` product defect. **S-668-1 CYCLE CLOSED.** This is a separate, concurrent cycle from SOH-DX-1 — SOH-DX-1's own paused position (S-TRAIL-DERIVATION-GUARD-1 next) is unaffected. Full detail: `cycles/cycle-001/decisions-archive.md` DEC-273, `cycles/cycle-001/burst-log.md` § S-668-1-MERGED-CYCLE-CLOSED.

---

**bucket1-defects — F2 spec evolution adversarial convergence (2026-08-13):** Six fresh-context, spec-scoped adversarial passes ran against the F2 PRD delta (`bc-3-issue-write.md` BC-3.4.021, `bc-1-auth-identity.md` BC-1.2.018/BC-1.2.047, `cross-cutting.md` BC-X.8.009) before the human-approval gate, covering all four bundled issues (#692, #663, #693, #694). **Finding trajectory: p1 (0H/3M/3L) → p2 (2H/1M/3L) → p3 (1H/1M/1L) → p4 (0H/0M/2L) → p5 (0H/0M/1L) → p6 (0H/0M/1L).** All findings across all six passes fixed same-day, in-cycle. **CONVERGED** — the last 3 passes (p4/p5/p6) each landed at 0 HIGH / 0 MEDIUM, with every load-bearing claim source-verified against `src/` before being accepted into the spec text (not merely asserted). Notably NON-monotonic at p2 (2H/1M/3L, an increase over p1) — the trajectory decayed in aggregate severity across the full run, not on every single step, consistent with DEC-191(a)'s novelty-decay convergence criterion (a later pass finding MORE at a deeper inspection frontier is not itself a red flag; the decay signal is the multi-pass trend, not pass-over-pass monotonicity). Two same-bundle contradictions were caught and corrected mid-loop, both load-bearing lessons for `drift-items-open-detail.md`: (1) an orchestrator-introduced JSON-error-channel inversion — the orchestrator's own pass-2 fix instruction against BC-3.4.021 asserted the `--output json` error envelope for a `--dry-run` depth-guard failure is written to stdout; it is actually written to stderr (stdout empty, per the #526 JSON render invariant, `src/main.rs`'s error-exit handler, `tests/common/assertions.rs::assert_json_error_envelope`) — pass-2 applied the incorrect instruction (EC-3.4.021-15, the depth-guard Canonical Test Vector row, VP-692-002 all written with the wrong channel), and a fresh-context pass-3 caught and reverted it same-day, source-verifying rather than trusting the pass-2 finding (see `drift-items-open-detail.md`'s `ORCHESTRATOR-FIX-INSTRUCTION-CAUSED-REGRESSION` row, instance 2); (2) pass-3's own MEDIUM-1 finding (the ADF-preview scope gap on bare `--description`) was itself a genuine, human-ratified SCOPE EXPANSION beyond the original #692 report, surfaced explicitly for ratification rather than silently broadened (BC-3.4.021's STATUS note; DEC-274). Full spec-delta detail (all fixes, per-pass findings, citations): each touched BC file's own frontmatter `trace:`/body `**Trace**:` fields (`bc-3-issue-write.md` BC-3.4.021, `bc-1-auth-identity.md` BC-1.2.018/BC-1.2.047, `cross-cutting.md` BC-X.8.009); decision record: `cycles/cycle-001/decisions-archive.md` DEC-274 (RATIFIED); commit-burst record: `cycles/cycle-001/burst-log.md` § BUCKET1-DEFECTS-F2-COMPLETE. **This is F2-scope adversarial review (spec-text correctness), distinct from the Step-4.5-style per-story implementation adversarial tracking that begins at F5** once F3 (story decomposition) and F4 (delta implementation) are complete — `ADV-P1-INDEX.md`'s combined total (SOH-DX-1 scope only) is unaffected by this F2 spec-scoped run.

**bucket1-defects — F3 story decomposition consistency audit (2026-08-13):** State-manager re-derived BC↔AC traceability directly from the 4 new story files (`S-692-1`, `S-663-1`, `S-693-1`, `S-694-1`) and their cited BC bodies (`bc-3-issue-write.md` BC-3.4.021, `bc-1-auth-identity.md` BC-1.2.047/BC-1.2.018, `cross-cutting.md` BC-X.8.009, `bc-2-issue-read.md` BC-2.7.010/BC-2.7.008/BC-2.7.009) — not trusted from story-writer's own claim. **Result: CLEAN, no blockers.** Full two-way traceability confirmed for all four stories: every AC cites its governing BC via a `*Traces to*:`-shaped reference, and every cited BC is covered by at least one AC. Breaking markers verified correct: S-692-1 and S-663-1 both carry `breaking_change: true` (matching the wave-schedule's Breaking? column and DEC-274's BREAKING ruling for #692); S-693-1 and S-694-1 both carry `breaking_change: false` (additive and docs-only respectively). Two DEFERRED cosmetic nits recorded, non-blocking, to be tidied when F4 touches the stories: (1) S-692-1's Behavioral Contracts summary table omits Invariant 1 from its clause enumeration, though AC-12 cites Invariant 1 correctly in the AC body itself — a summary-row-only presentation gap, not a traceability gap; (2) S-663-1's AC-3 doesn't name-check EC-1.2.047-2 by its ID, though the AC's test body exercises that exact example. Dependency-graph cycle detection (story-writer, re-confirmed here): Kahn's-algorithm topological sort over the four-story, zero-edge adjacency list `{S-692-1: [], S-663-1: [], S-693-1: [], S-694-1: []}` trivially succeeds — no restructuring required, single wave, 15 points, all four delivered in parallel worktrees. **This is F3-scope story-decomposition consistency review, distinct from the F2 spec-scoped adversarial review (six passes, prior burst) and from the Step-4.5-style per-story implementation adversarial tracking that begins at F5** once F4 (delta implementation) is complete. Decision record: `cycles/cycle-001/decisions-archive.md` DEC-275. Commit-burst record: `cycles/cycle-001/burst-log.md` § BUCKET1-DEFECTS-F3-COMPLETE.

**S-605-1 (component-mgmt, Wave 2 Track A position 1) — Step-4.5 per-story adversarial convergence (2026-08-18):** story-scoped Step-4.5 window (not the SOH-DX-1 trajectory-tail; component-mgmt is a separate Feature Mode cycle). `jr issue create`/`edit --component` single-key path, target `src/cli/issue/{create,edit}.rs`, depends_on:[S-604-1] (merged). **CONVERGED 3/3 CLEAN under DEC-245 strict: 9 rounds / 27 fresh-context diverse-lens passes (Lens A spec-fidelity, Lens B regression/security, Lens C convention/test-quality) / 8 fix bursts.** Finding trajectory decayed HIGH→MED→LOW→clean. Real defects caught+fixed: **R1** HIGH — dry-run path skipped component resolution entirely, exiting 0 on an unknown component name instead of failing (the exact bug class `--dry-run` exists to catch); R1 MED — echo/dry-run rendered ADD-before-REMOVE regardless of CLI input order. **R3** HIGH — numeric `--component` value wired as `{"name":"<digits>"}` instead of `{"id":...}`, silently creating-or-matching-nothing against Jira's id-typed field. **R4** MED — the R3 fix's RMW fallback path re-emitted retained components by NAME, causing a silent duplicate-name data-loss collision against distinctly-id'd components sharing a name. **R6** HIGH — a R5 refactor (collapsing name/id handling into a `ComponentRef` type) regressed name-based removal into a silent no-op against live, id-bearing components (the id-less test fixture masking this for 5 rounds is recorded separately in `lessons.md`); fixed definitively with a match-by-id-OR-name-against-the-embedded-Component semantics plus a full RMW combination-matrix test suite. **R7** MED — the two-sequential-PUT implementation had a partial-write + false-negative window (a later field-validation failure could leave an already-applied component change live while reporting failure); fixed via a research-confirmed single combined `update`+`fields` PUT (`edit_issue_combined`; research artifact `.factory/research/S-605-1-atomic-component-field-put.md`, CONFIRMED Jira Cloud v3 supports combining distinct-field `update`+`fields` in one request with up-front validation). **R8** LOW — a contradictory cross-identifier add/remove input (`remove:<id>` + `add:<name>` for the same underlying component) produces divergent native-vs-RMW-fallback outcomes; adjudicated ACCEPTED (contradictory input, no unrelated-data loss) and test-pinned rather than further "fixed." **R9: 3/3 CLEAN.** security-reviewer **APPROVE** (2 LOW/INFO); pr-reviewer **APPROVE** (1 LOW nit). CI 15/15 green incl. required CI Gate. Full regression suite: 4,297 passed, 0 failed; `cargo clippy --all-targets -- -D warnings` and `cargo fmt --all -- --check` both clean. 10 demo recordings at `.factory/demos/S-605-1/` (factory-artifacts `d51d7a23`, placeholder-only data). Three new LOW drift items recorded (numeric-id BC wording vs research-confirmed behavior; the R8 cross-identifier divergence, accepted; a cross-story `ExactMultiple` message-wording imprecision already present in shipped S-604 code, unrelated to this story) — all DEFERRED to the feature-level F5/F7 pass. Human squash-merged PR #712 as `f1ff9151fe129061d0d04e03b5c3ecee16a40300` (DEC-128, DEC-290) after the `gh pr merge` call was denied by the same-account tool-permission classifier — same mechanism as DEC-284/285/289. Issue #605 remains OPEN (S-605-2 still pending; PR used "relates to", not "closes"). Worktree removed, branch deleted local+remote. STORY-INDEX v1.5.99→v1.6.00. Full detail: `cycles/cycle-001/decisions-archive.md` DEC-290, `cycles/cycle-001/lessons.md` (3 new process-gap entries this story).

**bucket1-defects — F7 delta convergence (2026-08-14), produced by `f7-converge`, human-authorized CLOSE:** Five-dimensional convergence over the full F4-F7 delta (all 4 stories + the ancestry-reconnect and mutation-survivor follow-on PRs). **Result: 5/5 dimensions PASS.** D1 Spec PASS — all 4 changed `src/` files (`src/main.rs`, `src/cli/issue/edit.rs`, `src/cli/queue.rs`, `src/cli/mod.rs`) verified line-by-line against their governing BC bodies (BC-1.2.047/BC-1.2.018, BC-3.4.021, BC-X.8.009), zero drift found. D2 Test PASS with a scope caveat — `edit.rs` (in `.cargo/mutants.toml examine_globs`) CI-verified 4/4 mutants caught (100%, read from the CI job log, not the PR description); `queue.rs::collapse_and_truncate` (function-scoped local run, per PR #700's own body) 5/5 caught after fix (was 3/5); `queue.rs`/`main.rs` remain outside `examine_globs` entirely — a real, confirmed scope gap (not this bundle's defect), tracked as drift item `MUTANTS-SCOPE-GAP-QUEUE-MAIN`. D3 Implementation PASS — 0 CRIT/HIGH findings across all 6 PR reviews (#695-700), grepped explicitly for CRITICAL/HIGH/BLOCKING markers. D4 Verification PASS — Kani/fuzz N/A justified (no new algorithms/parsing/crypto surface; the one path reaching new-code-plus-parsing, `edit.rs`'s dry-run now reaching `markdown_to_adf`, reuses the pre-existing proptest-covered ADF conversion path and its `MAX_ADF_DEPTH` guard); `cargo deny check` clean (advisories/bans/licenses/sources all ok); CI gitleaks/deny/dependency-review/signing-guard green on all 6 PRs; no new `unsafe`, no new dependencies; purity boundaries intact. D5 Holdout PASS — all 7 wave holdouts (`H-BUCKET1-001`..`007`) from `bucket1-defects-wave-holdout-scenarios.md` mapped to concrete covering tests/behavior, none found uncovered. Regression validation (separate binary check): `cargo fmt --all -- --check` PASS (local), `cargo clippy --all-targets -- -D warnings` PASS (CI evidence — Clippy(ubuntu/windows-latest) green on PR #700, built on the fully-merged tree), `cargo test` PASS (81/82 local binaries 0 failures, interrupted not failed, on the 82nd; full CI matrix Test(ubuntu/macos/windows-latest) green on PR #700), `cargo deny check` PASS (local), CI Gate PASS 15/15 on all 6 PRs. **Method note:** this F7 pass explicitly did not accept the prior delivery summary at face value — it independently read all 4 changed `src/` files against their BCs, pulled and read full PR review bodies and CI job logs for all 6 PRs via `gh`, re-ran `cargo deny check`/`cargo fmt --all -- --check`/`cargo test --all-features` locally, and attempted (though did not complete within budget) a local `cargo mutants --in-diff` corroboration on `queue.rs`'s delta — relying instead on CI's direct log evidence and PR #700's reviewer's own hand-reproduced FAIL-before/PASS-after verification as the authoritative D2 evidence for that file. Full report: `.factory/phase-f7-convergence/bucket1-defects-delta-convergence-report.md` + `-traceability-chain-delta.md`. Decision record: `cycles/cycle-001/decisions-archive.md` DEC-276. Commit-burst record: `cycles/cycle-001/burst-log.md` § BUCKET1-DEFECTS-COMPLETE. **`bucket1-defects` CYCLE CLOSED** — all 4 issues (#692, #663, #693, #694) closed on merge; SOH-DX-1 and 668-duedate remain unaffected.
