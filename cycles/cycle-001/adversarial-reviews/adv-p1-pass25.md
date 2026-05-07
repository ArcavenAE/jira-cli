---
document_type: adversarial-review
phase: phase-1-spec-adversarial
pass: 25
producer: adversary
timestamp: 2026-05-04T00:00:00Z
fresh_context: true
inputs_reviewed:
  - .factory/specs/prd/*.md
  - .factory/specs/domain-spec/*.md
  - .factory/architecture/*.md
  - src/cli/issue/list.rs (citation verification)
finding_count: 2
severity_distribution: "0C/0H/1M/1L"
final_assessment: "SUBSTANTIVE"
---

# Phase 1 Spec Adversarial Review — Pass 25

## Final Assessment
SUBSTANTIVE (only 2 findings — convergence inflection). 1 MEDIUM (BC-INDEX P24 propagation gap to sibling), 1 LOW (pending intent verification). Predicted CLEAN-PASS in Pass 26.

Counter regress: 0/3 → 0/3.

## Pass 24 Fix Verification
- ADV-P24-001 (bc-2-issue-read.md:75 "13 filter sources"): VERIFIED
- ADV-P24-001 sibling (BC-INDEX.md:141): NOT FIXED — still "12 filter sources" (NEW finding ADV-P25-001)
- ADV-P24-002 (nfr line 15 = 41 with merge note): VERIFIED
- ADV-P24-003 (state-machines.md:11 "Five canonical (plus SM-06 bonus)"): VERIFIED
- ADV-P24-003 sibling (domain-spec/README.md:35): NOT FIXED — still "5 state machines" (LOW ADV-P25-002, pending intent)
- ADV-P24-004 (SM-3 source 395-463): VERIFIED
- ADV-P24-005 (JiraClient typo): VERIFIED

Downstream sweep: clean for residual "= 42 total", "390-487" SM-3, "JiaClient", "12 filter sources" (only BC-INDEX:141 caught).

## Findings

### ADV-P25-001: BC-INDEX.md:141 still says "12 filter sources" — P24 propagation sibling gap (MEDIUM)
- Severity: MEDIUM
- Lens: 1 (P24 sibling propagation sweep) + S-7.01 partial-fix regression
- Locations:
  - BC-INDEX.md:141 — Summary column for BC-2.1.006: "all 12 filter sources"
  - bc-2-issue-read.md:75 — heading "13 filter sources" (P24 fix)
  - src/cli/issue/list.rs:347 — actual error literal lists 13 flags
- Evidence: P24 fixed BC body but missed BC-INDEX which carries same fact in its summary column.
- Suggested fix: BC-INDEX.md:141 "all 12 filter sources" → "all 13 filter sources"
- Tag: [content-defect]
- Routing: product-owner

### ADV-P25-002: domain-spec/README.md:35 still labels "5 state machines" without bonus qualifier (LOW)
- Severity: LOW (pending intent)
- Lens: 1 (P24 sibling propagation)
- Locations:
  - domain-spec/README.md:35 — table row "5 state machines"
  - domain-spec/state-machines.md:11 — "Five canonical (plus SM-06 ... bonus context)"
- Evidence: README count is canonically-5 (excludes bonus). May be intentional.
- Suggested fix (if drift): "5 state machines" → "5 canonical + 1 bonus"
- Tag: [content-defect] (pending intent verification)
- Routing: business-analyst

## Observations
- OBS-001: BC body section completeness sample (12 BCs): no structural gaps
- OBS-002: Code line citation accuracy — 7/7 verified against src/cli/issue/list.rs
- OBS-003: ADR Decision sections coherent (ADR-0002 superseded, no Decision line by convention)
- OBS-004: Heading numbering sequential; 48 holdouts confirmed
- OBS-005: Glossary terms (MUST-FIX, MUST-FAIL, individually-bodied, range-collapsed) consistent
- OBS-006: Typo sweep clean (8 files sampled)
- OBS-007: nfr-catalog.md:15 narrative math coherent (23→+18→reconcile→merge = 41)
- OBS-008 [process-gap]: P24 verification declared "fixed" without sibling sweep. Codify: numerical-claim fixes must trigger grep across BC-INDEX, README, CANONICAL-COUNTS before declaring fixed.

## Lens Coverage Summary
- Lens 1 (P24 verification + sibling sweep): 1 MED + 1 LOW
- Lens 2 (BC body completeness): 0
- Lens 3 (code line citation): 0
- Lens 4 (ADR Decision coherence): 0
- Lens 5 (heading numbering): 0
- Lens 6 (glossary consistency): 0
- Lens 7 (typo sweep): 0

## Novelty Assessment
LOW. Both findings are partial-fix regression patterns. Spec at natural floor.

## Verdict
SUBSTANTIVE (2 findings — convergence inflection). Trajectory ...→5→5→5→2. Predicted CLEAN-PASS Pass 26.
