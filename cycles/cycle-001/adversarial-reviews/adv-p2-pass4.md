---
document_type: adversarial-review
phase: phase-2-adv-story-corpus
pass: 4
producer: adversary
timestamp: 2026-05-04T00:00:00Z
fresh_context: true
inputs_reviewed:
  - .factory/stories/STORY-INDEX.md, WAVE-PLAN.md
  - .factory/stories/wave-{0,1,2,3}/*.md
  - .factory/specs/prd/*.md (referential)
finding_count: 5
severity_distribution: "0C/0H/4M/1L"
final_assessment: "SUBSTANTIVE"
---

# Phase 2 Story Adversarial Review — Pass 4

## Final Assessment
SUBSTANTIVE — 5 findings, all sibling-propagation drift between WAVE-PLAN and STORY-INDEX (recurring [process-gap] pattern).

## Pass 3 Fix Verification (5/5)
- GAP-H-006 BC-4.1.002: VERIFIED at STORY-INDEX:219
- WAVE-PLAN v1.1.0 + concrete tables: VERIFIED at WAVE-PLAN:5
- S-2.07 H-020 false claim removed: VERIFIED at S-2.07:226-228
- S-1.06 Out-of-Scope H-008 added: VERIFIED at S-1.06:285-286
- S-2.06 AC-005 concrete path/command: VERIFIED (orchestrator confirmed)

## Filesystem Parity (Lens 2)
Orchestrator-verified: 7+8+7+9 = 31 ✓ matches STORY-INDEX claim.

## Findings

### ADV-P2-S4-001: S-2.05 NFR list drift (WAVE-PLAN correct; STORY-INDEX omits NFR-O-R)
- Severity: MEDIUM
- Lens: WAVE-PLAN ↔ STORY-INDEX sync
- Locations: WAVE-PLAN.md:78, STORY-INDEX.md:110
- Evidence: WAVE-PLAN lists NFR-O-L/M/O/V/R, NFR-R-F (6 total, correct). STORY-INDEX lists NFR-O-L, M, O, V, NFR-R-F (5 total, missing NFR-O-R). S-2.05 frontmatter nfr_anchors confirms 6 NFRs including NFR-O-R. WAVE-PLAN is authoritative; STORY-INDEX must be updated.
- Suggested fix: Add NFR-O-R to STORY-INDEX S-2.05 row.
- Routing: story-writer

### ADV-P2-S4-002: S-3.04 BC anchor count drift (WAVE-PLAN omits BC-1.1.007 + BC-1.5.031)
- Severity: MEDIUM
- Lens: WAVE-PLAN ↔ STORY-INDEX sync (Pass 1 fix sibling-propagation)
- Locations: WAVE-PLAN.md:94, STORY-INDEX.md:147
- Evidence: WAVE-PLAN: NFR-O-S, BC-1.5.038, H-047. STORY-INDEX: NFR-O-S, BC-1.5.038, BC-1.1.007, BC-1.5.031, H-047.
- Suggested fix: Update WAVE-PLAN to match STORY-INDEX (which has the post-Pass-1 fix).
- Routing: story-writer

### ADV-P2-S4-003: Wave 3 effort estimates drift across 3 stories
- Severity: MEDIUM
- Lens: WAVE-PLAN ↔ STORY-INDEX sync
- Locations:
  - S-3.02: WAVE-PLAN:92 medium / STORY-INDEX:145 small / frontmatter: small → WAVE-PLAN wrong
  - S-3.03: WAVE-PLAN:93 small / STORY-INDEX:146 medium / frontmatter: medium → WAVE-PLAN wrong
  - S-3.07: WAVE-PLAN:97 medium / STORY-INDEX:150 small / frontmatter: small → WAVE-PLAN wrong
- Suggested fix: Update WAVE-PLAN rows for S-3.02 (medium→small), S-3.03 (small→medium), S-3.07 (medium→small) to match story frontmatter truth.
- Routing: story-writer

### ADV-P2-S4-004: S-0.01 AC-001 untestable with current JiraClient::new_for_test
- Severity: MEDIUM
- Lens: Phase 3 readiness (Wave 0 gate)
- Locations: wave-0/S-0.01-fix-handle-open-oauth-instance-url.md:55,84,88-105
- Evidence: AC-001 requires `client.base_url() != client.instance_url()` distinction. Current `JiraClient::new_for_test(base_url, auth_header)` sets both to same value. Test Plan offers two options without selecting one. Implementation Notes:84 clarifies that in test mode `instance_url` = `base_url` = mock server URL, so the distinction cannot be tested via the existing constructor; the test must assert that handle_open calls instance_url() not base_url() via a different strategy.
- Suggested fix: Pre-decide test strategy. Chosen: Option (1) add 3-arg `new_for_test_with_instance_url(base, instance, auth)` constructor; enables test to set distinct base_url (api.atlassian.com) and instance_url (mock). Document chosen option in Test Plan.
- Routing: story-writer

### ADV-P2-S4-005: S-0.02 conditional `OffsetPage` accessor implementation note (LOW)
- Severity: LOW
- Lens: Phase 3 readiness
- Locations: wave-0/S-0.02-paginate-list-worklogs.md:97,121,155
- Evidence: "(maybe)" qualifier in File Structure Requirements + "if absent" / "if missing" in Test Plan + Implementation Notes. Implementer must inspect src/api/pagination.rs before starting. Grep confirms: `total` and `start_at` are public struct fields (lines 25,31 of pagination.rs) — not methods. No accessors needed. The loop code in Implementation Notes calls `page.total()` and `page.start_at()` as methods, but they should be field accesses (`page.total` and `page.start_at`). Conditional language should be replaced with deterministic field-access guidance.
- Suggested fix: Replace "(maybe)" with "no"; replace "if absent" / "if missing" with "fields exist as pub fields — use `page.total` and `page.start_at` (not method calls)". Update loop code to use field access syntax.
- Routing: story-writer

## Lens Coverage Summary
- Lens 1 (P3 fix verification): 5/5 verified
- Lens 2 (filesystem parity): 31 = 31 ✓
- Lens 3 (MUST-FAIL flip mechanics for Wave 0 stories): 0 findings (S-0.01 + S-0.02 verified clean)
- Lens 4 (cross-references): 0 findings (all resolve)
- Lens 5 (status field consistency): 0 findings
- Lens 6 (ADR/SD ref accuracy): 0 findings (sampled refs valid)
- Lens 7 (Wave 0 gate readiness): 1 finding (P-004) + 1 LOW (P-005)
- Bonus (WAVE-PLAN ↔ STORY-INDEX sync): 3 findings (P-001, P-002, P-003)

## Process-gap recurrence
Pattern: STORY-INDEX edits (Pass 1, Pass 2, Pass 3 cycles) consistently fail to propagate to WAVE-PLAN. Process-gap [DRIFT-003] — sibling-sweep step needed for any STORY-INDEX edit.

## Verdict
SUBSTANTIVE. Trajectory 14→5→5→5. Counter 0/3.
