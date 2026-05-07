---
document_type: adversarial-review
phase: phase-2-adv-story-corpus
pass: 2
producer: adversary
timestamp: 2026-05-04T00:00:00Z
fresh_context: true
inputs_reviewed:
  - .factory/stories/STORY-INDEX.md
  - .factory/stories/wave-0..3/*.md (31 stories)
  - .factory/specs/prd/holdout-scenarios.md
  - .factory/specs/prd/cross-cutting.md
  - src/{cli/auth.rs, jql.rs, duration.rs, cli/issue/list.rs} (LOC verification)
finding_count: 5
severity_distribution: "0C/0H/3M/1L"
final_assessment: "SUBSTANTIVE"
---

# Phase 2 Story Adversarial Review — Pass 2

## Final Assessment
SUBSTANTIVE — 5 findings (down from Pass 1's 14). Counter 0/3.

## Pass 1 Fix Verification

7/10 RESOLVED, 1/10 PARTIALLY (S-2.02 body residue), 2/10 NOT VERIFIED in tool-restricted context.

## Findings

### ADV-P2-S2-001: S-2.02 body cites H-021 as "covered in S-1.06" — Pass 1 propagation gap
- Severity: MEDIUM
- Lens: 1 (P1 fix sweep)
- Locations: wave-2/S-2.02-bc-3-issue-write-holdout-suite.md:95-96
- Evidence: AC-003 contains "(...; H-021 is covered in S-1.06.)". Pass 1 anchored H-021 to S-2.01, but S-2.02 body wasn't updated. Also: false claim that H-008 and H-021 pin same BC — H-008 pins BC-2.1.013, H-021 pins BC-2.1.007 (per holdout-scenarios.md).
- Suggested fix: Update line 95-96 to: "(Pins H-008. Note: H-008 (BC-2.1.013) and H-021 (BC-2.1.007) are related but distinct holdouts — H-021 is covered in S-2.01 AC-007.)"
- Tag: [content-defect]
- Routing: story-writer

### ADV-P2-S2-002: Pre-existing Test Coverage appendix mis-anchors H-018 to BC-X.9.001 (JQL escape, not duration)
- Severity: MEDIUM
- Lens: 7 (appendix accuracy)
- Locations: STORY-INDEX.md:200
- Evidence: Row says "H-018 | BC-X.9.001 (parse_duration combined units: 1h30m) | src/duration.rs | 92". But BC-X.9.001 = JQL escape_value proptest (cross-cutting.md:502). H-018 holdout-scenarios.md:188-193 cites BC-X.9.002, BC-X.9.003. Actual parse_duration BC = BC-X.5.005 (cross-cutting.md:316).
- Suggested fix: Change to "H-018 | BC-X.5.005 / BC-X.9.002 (parse_duration combined units vs validate_duration) | src/duration.rs::tests::test_complex | (verify line) | S-2.06"
- Tag: [content-defect]
- Routing: story-writer

### ADV-P2-S2-003: STORY-INDEX:111 anchors S-2.06 to BC-X.9.001 (JQL escape) — semantically unrelated to worklog duration
- Severity: MEDIUM
- Lens: 7 (index accuracy)
- Locations: STORY-INDEX.md:111
- Evidence: S-2.06 row "Worklog duration config + CMDB cache tuple | NFR-R-C, BC-X.9.001, BC-6.2.013". BC-X.9.001 is JQL escape proptest, unrelated. Correct anchor: BC-X.5.009 (parse_duration hardcoded 8h/5d at cli/worklog.rs:32 — direct NFR-R-C site per nfr-catalog.md:47).
- Suggested fix: Replace BC-X.9.001 with BC-X.5.009. Verify S-2.06 frontmatter bc_anchors matches.
- Tag: [content-defect]
- Routing: story-writer

### ADV-P2-S2-004: H-017 row in Pre-existing Test Coverage anchors BC-X.8.003 (project-meta cache) — wrong domain
- Severity: LOW
- Lens: 7 (appendix accuracy)
- Locations: STORY-INDEX.md:199
- Evidence: H-017 row "BC-X.8.003 | src/jql.rs | 278-308". BC-X.8.003 is get_or_fetch_project_meta cache (cross-cutting.md:475). H-017 actual BC ref per holdout-scenarios.md:183 = BC-4.1.002 (AQL clause uses field NAME + capital Key).
- Suggested fix: Change BC column from BC-X.8.003 to BC-4.1.002.
- Tag: [content-defect]
- Routing: story-writer

## Lens Coverage Summary
- Lens 1 (P1 verification + sweep): 1 finding (P-001)
- Lens 2 (cross-story dependency graph): 0 findings (sparse, acyclic)
- Lens 3 (test file path plausibility): 0 findings
- Lens 4 (TDD mode discrimination): 0 findings
- Lens 5 (estimated effort calibration): 0 findings
- Lens 6 (holdout assertion fidelity): 0 findings
- Lens 7 (Pre-existing Test Coverage appendix accuracy): 3 findings (P-002, P-003, P-004)
- Lens 8 (Gap Register accuracy): 0 findings (10/10 entries coherent)

## Verdict
SUBSTANTIVE (5 findings, 0C/0H/3M/1L). Trajectory 14→5. Pass 1 fixes mostly landed; sibling-text propagation gap recurred (S-7.01 axis). Counter 0/3.
