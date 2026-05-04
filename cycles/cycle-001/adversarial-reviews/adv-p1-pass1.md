# Adversarial Review — Phase 1d Pass 1

**Reviewer**: adversary (fresh-context)
**Date**: 2026-05-04
**Scope**: full Phase 1 spec package (L2 + L3 PRD + Architecture + supporting)
**Information asymmetry**: adversary did NOT see prior reviews or brownfield deepening rounds

## §1: Findings

### CRITICAL

**ADV-P1-001 — BC-INDEX numbering is fundamentally desynchronized from BC body files** [content-defect]
- Category: CONTRADICTION
- Severity: CRITICAL
- Description: BC-INDEX.md enumerates Section 1 BCs as BC-1.1.001..018 with one summary per row, but bc-1-auth-identity.md uses the SAME IDs (BC-1.1.001..012, BC-1.2.013..018, BC-1.3.019..024…) for COMPLETELY DIFFERENT contracts. Implementer reading BC-INDEX BC-1.1.001 ("get_or_create_http_client caches reqwest client per-profile") will look up bc-1-auth-identity.md BC-1.1.001 and find "auth list against fresh-install returns empty JSON array" instead. Same drift at BC-1.1.002, BC-1.6.046, and across nearly every entry in §1.
- Evidence: BC-INDEX.md:42-58 vs bc-1-auth-identity.md:26-156
- Recommended action: Route to product-owner. Either rewrite BC-INDEX rows to match canonical body IDs, or re-anchor body file headings.
- Confidence: HIGH

**ADV-P1-002 — extract_error_message precedence chain contradicts itself between docs** [content-defect]
- Category: CONTRADICTION
- Severity: CRITICAL
- Description: architecture/cross-cutting.md §1 (lines 36-43) defines the chain as: 1=errorMessages, 2=errors, 3=message, 4=errorMessage, 5=empty body, 6=raw body. PRD error-taxonomy.md §2 defines it as: 1=empty body (HIGHEST), 2=errorMessages, 3=errors, 4=errors.field.messages, 5=message, 6=errorDescription, 7=raw body. Two authoritative docs disagree.
- Evidence: architecture/cross-cutting.md:36-43 vs specs/prd/error-taxonomy.md:60-72; H-030 in holdout-scenarios.md:300-305
- Recommended action: Route to architect. Update architecture/cross-cutting.md §1 to match the PRD's 7-level chain.
- Confidence: HIGH

**ADV-P1-003 — DTU assessment falsely claims PKCE flow exists** [content-defect]
- Category: CONTRADICTION
- Severity: CRITICAL
- Description: dtu-assessment.md §1 Service 7 row labels auth.atlassian.com/authorize as "browser-based PKCE flow initiation". §2 Services 6-7 says "PKCE flow exercised in unit tests for the math." But BC-1.5.036 explicitly states "OAuth flow has NO PKCE" and NFR-S-A is the open MEDIUM finding for missing PKCE.
- Evidence: dtu-assessment.md:23, 101 vs bc-1-auth-identity.md:399-404 (BC-1.5.036), nfr-catalog.md:71 (NFR-S-A)
- Recommended action: Route to architect. Strike PKCE language from DTU §1 row 7 and §2 Services 6-7.
- Confidence: HIGH

**ADV-P1-004 — ADR-0007 prescribes a fallback that BC-6.3.001 says is impossible** [content-defect]
- Category: CONTRADICTION
- Severity: CRITICAL
- Description: ADR-0007 §Consequences: "Config::field_id() must fall back to global.fields.* when profile's field IDs are empty". BC-6.3.001 §Spec contract: [fields] block is dropped from disk on Config::save_global() due to #[serde(default, skip_serializing)] — so post-save the fallback target physically does not exist.
- Evidence: architecture/adr/0007-multi-profile-fields-fix.md:40 vs specs/prd/bc-6-config-cache.md:284-306
- Recommended action: Route to architect + product-owner. Reconcile.
- Confidence: HIGH

### HIGH (11 findings — ADV-P1-005 through ADV-P1-014)

ADV-P1-005: BC-3.7.004 description self-contradicts on scheme allowlist (says "only http and ftp rejected" but allowlist is http+https) — product-owner
ADV-P1-006: H-006 traces to wrong BC (BC-3.3.001 is create, not move) — should be BC-3.2.001 — product-owner
ADV-P1-007: H-031/H-032 trace to wrong cross-cutting subdomain (X.8 is Projects/Queues, not Users) — product-owner
ADV-P1-008: SM-1/SM-2 BC anchors don't match actual BC content (SM-1 cites BC-1.1.001 which is auth list, not OAuth login) — architect
ADV-P1-009: BC-2.2.021 pins the buggy stderr text instead of the fixed text (per BC-6.3.001 mandate) — product-owner
ADV-P1-010: NFR catalog totals don't reconcile (44 vs 39 vs 38 vs severity-sum=43) — product-owner
ADV-P1-011: Risk register R1-NEW numbering has gap (R1-NEW-10 missing) — architect
ADV-P1-012: cicd-setup §7 misnames NFR-S-C (deny.toml vs --verbose PII are different) — architect
ADV-P1-013: No ADR addendum or decision artifact for PKCE/ADR-0006 tension despite Phase 0 flagging — architect [process-gap]
ADV-P1-014: CICD GAP-1 (CRITICAL action SHA pinning) lacks Phase 3 BC anchor — product-owner + architect

### MEDIUM (12 findings — ADV-P1-015 through ADV-P1-026)

ADV-P1-015: H-013 references BC-X.2.004 but should be BC-X.1.005 — product-owner
ADV-P1-016: EC-CFG-002 references wrong BC for cache TTL (cites BC-6.2.002 which is corruption, should be 6.2.003) — product-owner
ADV-P1-017: H-NEW-MP-001 setup contradicts BC-6.3.001 read sites (uses create.rs not enumerated in 11-row table) — product-owner
ADV-P1-018: Multi-profile fields error message taxonomy fragmented across BCs — product-owner
ADV-P1-019: Per-profile fence (NEW-INV-08) deferral undocumented at spec level — product-owner
ADV-P1-020: ADR-0009 example uses non-existent command form ("issue view --open" doesn't exist) — architect
ADV-P1-021: H-027 pins known-broken contract as MUST-FAIL but lacks deferral routing [process-gap] — product-owner
ADV-P1-022: BC count headers (definitional vs cumulative) confuse consumers [process-gap] — product-owner
ADV-P1-023: Holdout H-028 duplicates H-019 — product-owner
ADV-P1-024: H-001 and BC-1.6.042 inconsistency vs body file — product-owner (after BC-INDEX rebuild)
ADV-P1-025: DEFAULT_OAUTH_SCOPES in BC-1.3.023 contradicts ADR-0006/CLAUDE.md drift risk — architect
ADV-P1-026: JSON error shape pinning has stream-separation ambiguity — product-owner

### LOW (3 findings)

ADV-P1-027: H-014 BC anchor BC-2.5.003 doesn't appear in body — product-owner (after BC-INDEX rebuild)
ADV-P1-028: find_project_config() symlink loops not addressed — product-owner
ADV-P1-029: User pagination 1500 cap × Retry-After 86400s interaction not specified — product-owner
ADV-P1-030: No .factory/policies.yaml for governance enforcement [process-gap] — orchestrator

## §2: Strengths Noted

1. MUST-FIX BCs are well-specified (BC-6.3.001, BC-X.5.002, BC-3.4.001, BC-4.3.001 each have explicit Spec contract sections)
2. Six new ADRs (0007-0012) are well-scoped with Status/Context/Decision/Rationale/Consequences
3. Holdout suite design is rigorous (48 holdouts cover MUST-FIX as MUST-FAIL pins)
4. State machine SM-3 Mermaid diagram with bug-highlighting is exemplary
5. DTU assessment correctly concludes DTU_REQUIRED: false (despite PKCE factual error)

## §3: Routing Summary

| Agent | Findings count |
|-------|---------------:|
| product-owner | 17 (BC sync, holdout anchors, error message text, NFR catalog) |
| architect | 10 (state machines, ADR contradictions, cross-cutting chain, DTU PKCE, decision artifacts) |
| orchestrator | 2 (process gaps: BC-aggregation policy, .factory/policies.yaml) |

Severity-by-target:
- product-owner: 1 CRITICAL (ADV-P1-001) + 7 HIGH + 9 MEDIUM
- architect: 3 CRITICAL (ADV-P1-002, 003, 004) + 3 HIGH + 4 MEDIUM
- orchestrator: 1 MEDIUM + 1 LOW

## §4: Verdict

**FINDINGS** — 30 findings: 4 CRITICAL / 11 HIGH / 12 MEDIUM / 3 LOW

Convergence NOT achieved on Pass 1. 9 findings are mis-anchoring (CRITICAL ADV-P1-001 + chain at 006, 007, 008, 014, 015, 016, 024, 027) — automatic block per protocol.

**Novelty: HIGH** — first-pass discoveries grounded in spec/source pinning.

## §5: Suggested Follow-ups for Pass 2

1. Verify BC-INDEX rebuild propagates to all holdout BC refs (expect more anchor errors once canonicalized)
2. Audit cross-cutting BCs for body completeness (BC-1.5.031..041 collapsed to one body)
3. Verify ADR-0007 fallback semantics — once reconciled, check 11 read sites + 3 create.rs sites have identical handling
4. Trace every NFR-* that routes to DEFER or SECURITY-DECIDE to a tracked decision register
5. Re-run NFR catalog arithmetic after canonical row count is fixed
6. Spot-check ADF BCs (54 in §7.2) — Pass 1 didn't sample
7. Verify state machine SM-2 and SM-4 BC anchors against canonical body files

Phase 1d adversary Pass 1 complete.
