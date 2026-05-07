---
document_type: adversarial-review
phase: phase-2-adv-story-corpus
pass: 7
producer: adversary
timestamp: 2026-05-04T00:00:00Z
fresh_context: true
finding_count: 4
severity_distribution: "0C/1H/2M/1L"
final_assessment: "SUBSTANTIVE"
---

# Phase 2 Story Adversarial Review — Pass 7

## Final Assessment
SUBSTANTIVE — 4 findings. Trajectory 14→5→5→5→4→5→4. Counter 0/3.

## Pass 6 Fix Verification — 5/5 CLEAN
- BC-6.4.* eradicated from corpus (verified at 7 sites)
- BC-2.1.001 removed from S-3.07
- STORY-INDEX:151 BC list synced
- S-3.04:237 cites AC-002+AC-006
- STORY-INDEX:62 reflects S-1.06 dep

## DRIFT-004 Deep Sweep — CLEAN
Every BC ID cited across stories/STORY-INDEX/holdout-scenarios/risk-register resolves to canonical BC-INDEX.md.

## Findings

### ADV-P2-S7-001 (HIGH): S-3.04 risk_anchors cites R-M5 instead of R-M2
- Severity: HIGH (semantic mis-anchor on frontmatter; orphans R-M2)
- Locations: wave-3/S-3.04-multi-cloudid-disambiguation.md:16-17, risk-register.md:39 (R-M2), :41 (R-M5)
- Evidence: R-M5 = "cli/issue/list.rs LOC threshold" (NFR-O-D). R-M2 = "accessible_resources first-result-wins" — exactly what S-3.04 fixes via --cloud-id flag.
- Suggested fix: S-3.04 frontmatter `risk_anchors: - R-M5` → `- R-M2`
- Routing: story-writer

### ADV-P2-S7-002 (MED): STORY-INDEX:108 missing BC-2.1.013 from S-2.02 BC anchors column
- Severity: MEDIUM (frontmatter↔index drift, DRIFT-003 recurrence)
- Locations: STORY-INDEX.md:108, S-2.02 frontmatter line 13
- Evidence: Frontmatter has BC-3.2.001, BC-3.2.009, BC-2.1.013, BC-X.7.004 (4 BCs). STORY-INDEX shows 3 (omits BC-2.1.013).
- Suggested fix: Add BC-2.1.013 to STORY-INDEX:108
- Routing: story-writer

### ADV-P2-S7-003 (MED): S-2.05 BC-6.1.001 anchor is fabricated semantic
- Severity: MEDIUM (semantic mis-anchor; doc-only story has no real BC)
- Locations: S-2.05 frontmatter line 10-11, body line 56-58
- Evidence: BC-6.1.001 = "Legacy [instance]/[fields] migrate to [profiles.default]" (per BC-INDEX:393). S-2.05 reframes as "CLAUDE.md consistency" — fabricated paraphrase.
- Suggested fix: Remove `bc_anchors:` from S-2.05 frontmatter (or empty array). Update ACs to trace NFR IDs only (NFR-O-L/M/O/V/R, NFR-R-F). Remove BC-6.1.001 paragraph from body Behavioral Contracts.
- Routing: story-writer

### ADV-P2-S7-004 (LOW): S-1.06 forward-references ADR-0013 (pending intent)
- Severity: LOW
- Locations: S-1.06 frontmatter line 24-25, line 288
- Evidence: ADR-0013 authored in S-3.09 (Wave 3). S-1.06 (Wave 1) ships before S-3.09.
- Suggested fix: Annotate inline as forward-ref OR add depends_on to S-3.09. Recommended: keep ADR-0013 in adr_refs with annotation, since the ADR document already exists at .factory/architecture/adr/0013-pkce-deferral.md (created at gate transition); only the formal Decision Log entry waits for S-3.09. So this is verifiable now.
- Routing: story-writer (annotation only)

## Observations
- OBS-1 [process-gap from P6]: S-3.07 single test_files for 4 unrelated parts. Carry forward.
- OBS-2 [process-gap]: H-NEW-AUTH-002 not in holdout-scenarios.md until S-0.07 implementation. Tag as Phase 3 entry condition.

## Lens Coverage Summary
- Lens 1 (P6 verification + DRIFT-004 sweep): 0 findings (all clean)
- Lens 2 (BC anchor semantic correctness): 1 MEDIUM (S7-003 fabricated)
- Lens 3 (frontmatter↔index sync): 1 MEDIUM (S7-002 recurrence)
- Lens 4 (risk_anchors semantic): 1 HIGH (S7-001)
- Lens 5 (adr_refs forward-ref): 1 LOW (S7-004)

## Verdict
SUBSTANTIVE. Trajectory 14→5→5→5→4→5→4. Counter 0/3.
