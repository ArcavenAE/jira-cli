---
document_type: adversarial-review
phase: phase-1-spec-adversarial
pass: 18
producer: adversary
timestamp: 2026-05-04T00:00:00Z
fresh_context: true
inputs_reviewed:
  - .factory/specs/domain-spec/*.md
  - .factory/specs/prd/*.md
  - .factory/architecture/**/*.md
finding_count: 3
severity_distribution: "0C/0H/2M/1L"
final_assessment: "SUBSTANTIVE"
---

# Phase 1 Spec Adversarial Review — Pass 18

## Final Assessment
SUBSTANTIVE

Counter regress: 1/3 → 0/3 (5th reset across 18 passes).

## Findings

### ADV-P18-001: Architecture README BC-to-Module map omits `cli/assets.rs` from BC-4 mapping
- Severity: MEDIUM
- Confidence: HIGH
- Lens: 1 (cross-doc severity reconciliation) + 5 (ADR/architecture cross-ref integrity)
- Locations:
  - `.factory/architecture/README.md:88` — BC-4.* row lists 6 source files, omitting `cli/assets.rs`
  - `.factory/specs/domain-spec/README.md:96` — L2 traceability lists both `cli/assets.rs` AND `cli/issue/assets.rs` for bc-04
  - `.factory/specs/prd/nfr-catalog.md:92` — NFR-O-D explicitly cites `cli/assets.rs` (1,055 LOC) as a violator of the ~1000 LOC shard rule
- Evidence: Architecture README §Bounded Context to Module Map line 88 omits the 1,055-LOC `cli/assets.rs` standalone-command handler. L2 domain-spec README correctly includes it.
- Expected: BC-to-Module map should include `cli/assets.rs` as the largest single CLI handler in BC-4.
- Suggested fix: Add `cli/assets.rs` to BC-4.* row at architecture/README.md:88.
- Tag: [content-defect]
- Routing: architect

### ADV-P18-002: BC-INDEX MUST-FIX register row drops line 440 from BC-4.3.001 site citation
- Severity: MEDIUM
- Confidence: HIGH
- Lens: 6 (CANONICAL-COUNTS source of truth) + 1 (cross-doc consistency)
- Locations:
  - `.factory/specs/prd/BC-INDEX.md:630` — MUST-FIX register row says `src/cli/issue/list.rs:446,449,456` (3 line numbers)
  - `.factory/specs/prd/BC-INDEX.md:332` — same BC-4.3.001 in section 4.3 cites `src/cli/issue/list.rs:440,446,449,456` (4 line numbers)
  - `.factory/specs/prd/bc-4-assets-cmdb.md:182` — body cites 4 lines
  - `.factory/architecture/adr/0008-asset-enrichment-key-correctness.md:32` — ADR cites 4 lines
  - `.factory/specs/prd/nfr-catalog.md:41` — NFR-R-E site cites 4 lines
  - `.factory/architecture/state-machines.md:167` — SM-3 fix scope cites 4 lines
  - `.factory/specs/domain-spec/README.md:113` — L2 MUST-FIX register cites 4 lines
- Evidence: 7 authoritative locations cite all four line numbers `440,446,449,456`. Line 440 is the dedup map declaration site and is part of the fix scope per ADR-0008. BC-INDEX MUST-FIX register row drops line 440.
- Expected: Match canonical 4-line citation `440,446,449,456`.
- Suggested fix: Update BC-INDEX.md:630 from `src/cli/issue/list.rs:446,449,456` to `src/cli/issue/list.rs:440,446,449,456`.
- Tag: [content-defect]
- Routing: product-owner

### ADV-P18-003: H-046 holdout omits OAuth-mode `JiraClient` fixture mechanism
- Severity: LOW
- Confidence: MEDIUM
- Lens: 3 (holdout setup feasibility)
- Locations:
  - `.factory/specs/prd/holdout-scenarios.md:451-456` — H-046 setup
- Evidence: H-046 setup describes desired-state (OAuth profile with cloudId, base_url, instance_url) but doesn't specify how the evaluator constructs the OAuth-mode JiraClient fixture. Compare H-NEW-MP-001 which explicitly names wiremock and round-trip-test mechanism.
- Expected: Either explicit setup verb specifying fixture builder OR cross-reference to OAuth fixture pattern.
- Suggested fix: Add a Setup line specifying the test-harness fixture mechanism (e.g., `JiraClient::new_for_test_oauth(base, instance, cloud_id)`) OR cross-reference H-029 (BYO/embedded OAuth login).
- Tag: [content-defect]
- Routing: product-owner

## Lens Coverage Summary
- Lens 1 (cross-doc severity reconciliation): 1 finding (ADV-P18-001 partial)
- Lens 2 (EC-* anchor verification): 0 findings — all sampled BC anchors resolve in BC-INDEX
- Lens 3 (holdout setup feasibility): 1 finding (ADV-P18-003)
- Lens 4 (glossary/terminology consistency): 0 findings — "active profile" used consistently
- Lens 5 (ADR cross-ref integrity): 1 finding (ADV-P18-001 partial); ADRs 0001-0012 all exist
- Lens 6 (CANONICAL-COUNTS source of truth): 1 finding (ADV-P18-002)
- Lens 7 (BC-INDEX completeness): 0 findings — per-subdomain headcounts reconcile

## Verdict — SUBSTANTIVE (3 findings)

Counter regress 1/3 → 0/3 (5th reset across 18 passes). Pass 17 fixes verified landed. Pass 18's findings are not retreading: architecture BC-to-Module map gap and BC-INDEX MUST-FIX line-number drift are new lenses; H-046 setup gap not flagged before.
