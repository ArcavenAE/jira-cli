---
document_type: adversarial-review
phase: phase-2-adv-story-corpus
pass: 3
producer: adversary
timestamp: 2026-05-04T00:00:00Z
fresh_context: true
inputs_reviewed:
  - .factory/stories/STORY-INDEX.md, WAVE-PLAN.md
  - .factory/stories/wave-{0,1,2,3}/*.md
  - .factory/specs/prd/holdout-scenarios.md, cross-cutting.md
finding_count: 5
severity_distribution: "0C/1H/3M/1L"
final_assessment: "SUBSTANTIVE"
---

# Phase 2 Story Adversarial Review — Pass 3

## Final Assessment
SUBSTANTIVE — 5 findings (counter remains 0/3).

## Pass 2 Fix Verification
3/4 cleanly landed. 1/4 sibling-text gap (GAP-H-006 row still BC-X.8.003).

## Findings

### ADV-P2-S3-001: GAP-H-006 row STORY-INDEX:219 still anchors BC-X.8.003 (P2 sibling propagation)
- Severity: MEDIUM
- Lens: 1 (P2 verification)
- Locations: STORY-INDEX.md:219
- Suggested fix: BC column BC-X.8.003 → BC-4.1.002 in GAP-H-006 row
- Routing: story-writer

### ADV-P2-S3-002: WAVE-PLAN.md severely out of sync (HIGH)
- Severity: HIGH
- Lens: 6 (WAVE-PLAN integrity)
- Locations: WAVE-PLAN.md:51-99
- Evidence: Wave 1/2/3 still TBD placeholders. STORY-INDEX is at v1.4.0 with 31 stories; WAVE-PLAN is at v1.0.0 with stale text. Phase 3 implementer reading WAVE-PLAN would be misled.
- Suggested fix: Update WAVE-PLAN to reflect 31-story corpus with concrete Wave 1/2/3 sections + parallel-group guidance. Bump to v1.1.0+.
- Routing: story-writer

### ADV-P2-S3-003: S-2.07 falsely claims S-1.06 covers H-020
- Severity: MEDIUM
- Lens: 7 (Phase 3 readiness)
- Locations: wave-2/S-2.07:226-228
- Evidence: S-2.07 says "S-1.06 covers H-020 from auth-switching perspective." S-1.06 frontmatter does NOT include H-020. STORY-INDEX:112 anchors H-020 only to S-2.07.
- Suggested fix: Replace lines 226-228 with "**H-020 baseline**: Currently no story formally anchors H-020 outside S-2.07. AC-003 establishes the auth-subcommand JSON error baseline as part of this story; no Wave 1 prior coverage exists to extend."
- Routing: story-writer

### ADV-P2-S3-004: S-1.06 Out-of-Scope missing H-008 (LOW)
- Severity: LOW
- Lens: 3 (Out-of-Scope completeness)
- Locations: wave-1/S-1.06:280-286
- Evidence: Body line 65 calls out H-007 + H-008 as out of scope, but Out of Scope section only enumerates H-007.
- Suggested fix: Add H-008 bullet
- Routing: story-writer

### ADV-P2-S3-005: S-2.06 AC-005 path-dependence implementer-blocking
- Severity: MEDIUM
- Lens: 2 (AC precision)
- Locations: wave-2/S-2.06:101-105 + 244-246
- Evidence: AC-005 says "any command that reads CMDB fields" without specifying which. Cache file path also unspecified ("Confirm path in cache.rs before writing").
- Suggested fix: Replace AC-005 with concrete invocation: "Given <XDG_CACHE_HOME>/jr/v1/default/cmdb_fields.json containing ["customfield_10191"] as a Vec<String> and a wiremock returning the canonical CMDB-field list, when `jr issue list --output json` is invoked with `--project PROJ`, then exit code is 0 and the cache file is overwritten with the new (id, name) tuple format."
- Routing: story-writer

## Lens Coverage Summary
- Lens 1 (P2 verification + sibling sweep): 1 finding (P-001)
- Lens 2 (AC precision): 1 finding (P-005)
- Lens 3 (Out-of-Scope completeness): 1 finding (P-004)
- Lens 4 (wave-counts parity): 0 (orchestrator should run ls parity check)
- Lens 5 (bc_anchors plausibility): 0 — sampled BCs all in BC-INDEX
- Lens 6 (WAVE-PLAN integrity): 1 finding HIGH (P-002)
- Lens 7 (Phase 3 readiness): 1 finding (P-003)

## Verdict
SUBSTANTIVE. Counter 0/3 (no advance). Trajectory 14→5→5. Same propagation gap pattern recurs (P-001 echoes P2-001).
