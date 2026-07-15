---
document_type: consistency-report
level: ops
version: "3.0"
status: GAPS-FOUND
producer: consistency-validator
timestamp: 2026-07-15T00:00:00
feature: SOH-ATTACHMENTS-1
issues: "#576, #585"
phase: F2
authored: 2026-07-15
reviewer_role: consistency-validator
spec_version: 1.3.44
verdict: GAPS-FOUND
total_findings: 2
new_findings: 2
critical: 0
high: 0
medium: 0
low: 1
info: 1
r1_findings_reviewed: 7
r1_findings_resolved: 7
r2_findings_reviewed: 5
r2_findings_resolved: 5
r2_cons_576_002_residual_resolved: true
blocking_gaps: 0
inputs:
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/cross-cutting.md"
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/specs/prd/CANONICAL-COUNTS.md"
  - ".factory/spec-changelog.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
  - ".factory/phase-f2-spec-evolution/security-review-576.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576-worklog.md"
  - ".factory/phase-f1-delta-analysis/impact-boundary-576.md"
  - ".factory/research/issue-576-attachments-api-2026-07-15.md"
  - ".factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md"
  - ".factory/specs/architecture/ARCH-INDEX.md"
  - ".factory/architecture/adr-index.md"
input-hash: "c52e27a"
traces_to: ".factory/phase-f2-spec-evolution/prd-delta-576.md"
---

# Consistency Report: SOH-ATTACHMENTS-1 F2 Spec Package (spec v1.3.44) — Round 3

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) |
| **Generated** | 2026-07-15 |
| **Generator** | consistency-validator (fresh context, no prior-round reports read before independent pass) |
| **Artifacts Scanned** | 14 (all surface-set items specified in task brief) |
| **Spec Version** | v1.3.44 (post-security-fix, post-r1-fixes, post-r2-fixes state) |
| **Feature** | SOH-ATTACHMENTS-1 (issues #576 + #585) |
| **Gate** | DEC-179 F2 spec bundle — round 3 after r2 GAPS-FOUND corrections |

**Review methodology**: Fresh-context read of all 14 surface-set artifacts BEFORE consulting
`consistency-report-576-r1.md` and `consistency-report-576-r2.md`. Independent findings formed
first, then prior reports used only to verify closure of CONS-576-001..007, NEW-001..005,
and the CONS-576-002 residual.

**Verdict: GAPS-FOUND** — 1 LOW and 1 INFO finding. All 12 prior findings fully resolved
(CONS-576-001..007, NEW-001..005 including the CONS-576-002 residual). No CRITICAL, HIGH,
or MEDIUM findings. No blocking gaps before story decomposition.

---

## Summary

| # | Check | Result |
|---|-------|--------|
| 1 | L2 to L3 Requirement Coverage | N/A (ops-level review; no L2 domain-spec in scope) |
| 2 | L3 to L4 Verification Property Coverage | N/A (no new VPs in this delta) |
| 3 | Dependency Acyclicity | N/A (no stories authored yet) |
| 4 | Architecture Alignment | GAPS-FOUND (NEW-R3-002 — BC-3.9.007 wrong cross-reference) |
| 5 | Acceptance Criteria Quality | N/A (no stories authored yet) |
| 6 | Story Sizing (all <= 13 points) | N/A (no stories authored yet) |
| 7 | Priority Consistency | N/A (no stories authored yet) |
| 8 | L1 to L2 to L3 to L4 Chain Completeness | N/A (ops-level review) |
| 9 | AC Completeness Coverage | N/A (no stories authored yet) |
| 10 | ASM/R Traceability | N/A (no ASM/R artifacts in this bundle) |
| — | Prior-finding closure (CONS-576-001..007, NEW-001..005) | ALL RESOLVED |
| — | Source/Trace citations vs F1 NEW-file layout | PASS |
| — | Hard-coded INCONCLUSIVE figures | PASS |
| — | Index/count drift | PASS |
| — | Stale status markers | PASS |
| — | ADR-0017 factual claims vs research | PASS |

---

## 1. L2 to L3 Requirement Coverage

[TODO: populate this section per template]

This review is scoped to ops-level cross-document consistency of the SOH-ATTACHMENTS-1 F2
spec bundle. No L2 domain-spec artifact (CAP-NNN) is in the reviewed inputs; this check
does not apply to this review pass.

---

## 2. L3 to L4 Verification Property Coverage

[TODO: populate this section per template]

No new Verification Properties (VP-NNN) were added in this delta (prd-delta-576.md confirms
`holdout_count_after: 88`, VP count unchanged at 30). This check is not applicable to this
review pass.

---

## 3. Dependency Acyclicity

[TODO: populate this section per template]

No stories have been authored for this bundle. This check applies at the story-decomposition
phase (F3). Not applicable to this F2 spec review.

---

## 4. Architecture Alignment

### 4.1 Module Coverage

| Architecture Component | BCs Targeting It | Source Citation (per BC body) | F1 Design File | Match? |
|-----------------------|-----------------|------------------------------|----------------|--------|
| `src/cli/issue/attachments.rs` (NEW) | BC-2.7.001..012 | `attachments.rs` | NEW per F1 §1.1 | YES ✓ |
| `src/cli/issue/attachments.rs` (NEW) | BC-3.9.001..014 (CLI handler) | `attachments.rs` | NEW per F1 §1.1 | YES ✓ (all 14 corrected) |
| `src/api/jira/attachments.rs` (NEW) | BC-3.9.001, BC-3.9.008, BC-3.9.009, BC-3.9.010, BC-3.9.013 | `jira/attachments.rs` | NEW per F1 §1.1 | YES ✓ |
| `src/api/jsm/attachments.rs` (NEW) | BC-3.9.003, BC-3.9.004, BC-3.9.006, BC-3.9.007 (step-1) | `jsm/attachments.rs` | NEW per F1 §R2.1 | YES ✓ |
| `src/cache.rs` (TOUCHED) | BC-X.8.010 | `src/cache.rs` | TOUCHED per F1 §R2.1 | YES ✓ |
| `src/types/jira/attachment.rs` (NEW) | (via type structs) | implied by F1 §1.1 | NEW per F1 §1.1 | YES (no direct BC cite needed) |
| `src/types/jsm/attachment.rs` (NEW) | (via type structs) | implied by F1 §R2.1 | NEW per F1 §R2.1 | YES (no direct BC cite needed) |

### 4.2 Component Consistency

All BC-3.9 body Source fields now correctly cite `src/cli/issue/attachments.rs` for the CLI
handler (zero `interactions.rs` residual confirmed by grep). ADR-0017 decisions (reqwest
multipart + stream + tokio-util) match F1 impact boundary §R2.4 Cargo.toml additions.
ARCH-INDEX.md lists ADR-0017 with correct subsystems SS-03, SS-09, and correct path.
adr-index.md entry for ADR-0017 is consistent with ARCH-INDEX.md.

One cross-reference gap found: BC-3.9.007 body cites `(BC-2.7.005)` for the download
endpoint but BC-2.7.005 covers `--filter size-max`; the correct reference is BC-2.7.007.
See NEW-R3-002 below.

---

## 5. Acceptance Criteria Quality

[TODO: populate this section per template]

No stories authored yet. This check will apply at F3 (story decomposition). Not applicable
to this F2 spec review.

---

## 6. Story Sizing

[TODO: populate this section per template]

No stories authored yet. Not applicable to this F2 spec review.

---

## 7. Priority Consistency

[TODO: populate this section per template]

No stories authored yet. Not applicable to this F2 spec review.

---

## 8. L1 to L2 to L3 to L4 Chain Completeness

[TODO: populate this section per template]

This ops-level review checks cross-document consistency within the F2 spec artifacts, not
L1→L4 chain completeness. That check applies at the full-spec validation gate.

---

## 9. AC Completeness Coverage

[TODO: populate this section per template]

No stories authored yet. Not applicable to this F2 spec review.

---

## 10. ASM/R Traceability

[TODO: populate this section per template]

No ASM/R (Assumption/Risk) artifacts are in the reviewed inputs for this bundle. Not
applicable to this review pass.

---

## Prior-Finding Closure Table

### CONS-576-001..007 (R1 findings)

| Finding | Severity | Closure Status | Evidence |
|---------|----------|---------------|----------|
| CONS-576-001 — BC-INDEX row BC-2.7.011 stale algorithm | MEDIUM | **RESOLVED** | BC-INDEX row shows 5.5-step, `/`/`\`/`:` scrub only, 255-byte cap, SEC-576-002 two-step containment, SEC-576-001 caller note, Source → `attachments.rs` |
| CONS-576-002 — BC-3.9 bodies/BC-INDEX cite `interactions.rs` | LOW | **RESOLVED (including r2 residual)** | grep confirms zero `interactions.rs` occurrences in any Section 3.9 attachment BC body; all 14 BC-INDEX Section 3.9 rows cite `attachments.rs` or `jsm/attachments.rs`; no residual |
| CONS-576-003 — BC-X.8.010 Source cites `requests.rs` | LOW | **RESOLVED** | BC-X.8.010 Source now correctly cites `src/api/jsm/attachments.rs::attach_temporary_file` |
| CONS-576-004 — BC-INDEX Section 2.7 rows cite `interactions.rs` | LOW | **RESOLVED** | All 12 Section 2.7 rows cite `src/cli/issue/attachments.rs (pending S1/S2)` |
| CONS-576-005 — security-review-576.md status stale | LOW | **RESOLVED** | Frontmatter `status: final`, `verdict: APPROVE`; all 7 findings show `Status: **resolved**` |
| CONS-576-006 — impact-boundary §R2.2 contradicts §OQ-9 | LOW | **RESOLVED** | `[PHASE-DOC-RETRO-ANNOTATION 2026-07-15 — CONS-576-006: …]` present inline in §R2.2 |
| CONS-576-007 — spec-changelog says "ADR-0017 planned" | INFO | **RESOLVED** | spec-changelog [1.3.43] now reads "ADR-0017 Accepted 2026-07-15 (`.factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md`)" |

### NEW-001..005 (R2 findings)

| Finding | Severity | Closure Status | Evidence |
|---------|----------|---------------|----------|
| NEW-001 — BC-3.9.001 "10 MB" / ADR-0017 "250 MB" contradict INCONCLUSIVE | LOW | **RESOLVED** | BC-3.9.001 body now reads "The limit is instance-configured and not knowable from the client side (sources conflict on the default figure; research §3a verdict: INCONCLUSIVE…)"; ADR-0017 §Context now reads "instance-configured and site/plan-dependent; the research verdict is inconclusive across sources — do not hard-code a figure; DEC-179 ruling 4" |
| NEW-002 — ADR-0017 §Context non-existent endpoint URL | LOW | **RESOLVED** | ADR-0017 §Context now correctly cites "`GET /rest/api/3/attachment/content/{id}` content endpoint" |
| NEW-003 — BC-INDEX Section 3.9 rows cite `interactions.rs` | LOW | **RESOLVED** | All 14 Section 3.9 BC-INDEX rows now cite `src/cli/issue/attachments.rs` or `src/api/jsm/attachments.rs` as appropriate |
| NEW-004 — CANONICAL-COUNTS.md BC-X.4.009 note stale numbers | INFO | **RESOLVED** | Lines 63–65 now read "cross-cutting's `total_bcs: 150` and in the **651 sum**. It does NOT add +1 beyond the 650." |
| NEW-005 — impact-boundary §R2.3 pre-OQ-9 no retro-annotation | INFO | **RESOLVED** | `[PHASE-DOC-RETRO-ANNOTATION 2026-07-15 — NEW-005/CONS-576-006: …]` present in §R2.3 BC-3.9.012 row |

**All 12 prior findings fully resolved. CONS-576-002 residual: zero remaining `interactions.rs`
occurrences in attachment BC scope confirmed by direct grep.**

---

## Cross-Reference Validation

### ID Consistency

| Check | Status | Issues |
|-------|--------|--------|
| BC IDs unique (2.7.001..012, 3.9.001..014, X.8.010) | pass | No duplicates found |
| BC-INDEX row count vs BC body count (Section 2.7) | pass | 12 rows = 12 bodies |
| BC-INDEX row count vs BC body count (Section 3.9) | pass | 14 rows = 14 bodies |
| BC-INDEX row count vs BC body count (X.8) | pass | BC-X.8.010 present |
| Per-file frontmatter total_bcs vs CANONICAL-COUNTS | pass | All 8 files match; sum = 651 |
| Grand total 651 consistent across BC-INDEX, CANONICAL-COUNTS, per-file sums | pass | 651 = 651 = 651 |
| Security findings SEC-576-001..007 applied in BC bodies | pass | All 7 verified present |
| BC-3.9.007 cross-reference `(BC-2.7.005)` | fail | Should be `(BC-2.7.007)` — see NEW-R3-002 |

### Naming Convention Compliance

| Convention | Expected Pattern | Violations |
|-----------|-----------------|------------|
| BC naming (read) | BC-2.7.NNN | None — BC-2.7.001..012 correctly formed |
| BC naming (write) | BC-3.9.NNN | None — BC-3.9.001..014 correctly formed |
| BC naming (cross-cut) | BC-X.8.NNN | None — BC-X.8.010 correctly formed |
| Finding IDs (r1) | CONS-576-NNN | 7 findings: CONS-576-001..007 |
| Finding IDs (r2) | NEW-NNN | 5 findings: NEW-001..005 |
| Finding IDs (r3) | NEW-R3-NNN | 2 findings: NEW-R3-001, NEW-R3-002 |

### Canonical Frontmatter Validation

| Artifact | document_type | level | version | producer | traces_to | Status |
|----------|--------------|-------|---------|----------|-----------|--------|
| prd-delta-576.md | prd-delta | — | — | — | present | pass (proprietary frontmatter) |
| security-review-576.md | security-review | ops | "1.0" | security-reviewer | present | pass |
| impact-boundary-576.md | — | — | — | — | — | no standard frontmatter; pass |
| ADR-0017 | adr | — | — | — | — | Accepted 2026-07-15; conforms to ADR template |
| BC-INDEX.md | — | — | — | — | — | non-standard (bc-index); conforms |
| CANONICAL-COUNTS.md | — | — | — | — | — | non-standard (canonical-counts); conforms |

---

## Spec vs Implementation Drift

| Artifact | Spec Version | Implementation State | Drift Detected | Notes |
|----------|-------------|---------------------|---------------|-------|
| bc-2-issue-read.md §BC-2.7.001..012 | v1.3.44 | PENDING (S1/S2) | NO | All SEC-576 fixes present; Source citations correct |
| bc-3-issue-write.md §BC-3.9.001..014 | v1.3.44 | PENDING (S3/S4/S5) | YES (NEW-R3-002) | BC-3.9.007 `(BC-2.7.005)` cross-ref wrong; behavioral text correct |
| cross-cutting.md §BC-X.8.010 | v1.3.44 | PENDING (S5) | NO | SEC-576-006 stale-ID clause present; Source correct |
| BC-INDEX.md §2.7 and §3.9 rows | v1.3.44 | — | NO | All Source citations corrected from prior rounds |
| CANONICAL-COUNTS.md | v1.3.44 | — | NO | BC-X.4.009 note updated; all counts correct |
| security-review-576.md | v1.3.44 | APPROVE | NO | `status: final`, `verdict: APPROVE`; all 7 findings resolved |
| impact-boundary-576.md | v1.3.44 + retro-annotations | — | NO | §R2.2 + §R2.3 retro-annotations present |
| spec-changelog.md | v1.3.44 | — | NO | [1.3.43] and [1.3.44] entries accurate |
| prd-delta-576.md (frontmatter) | v1.3.43 (stale) | — | YES (NEW-R3-001) | frontmatter `spec_version_after: 1.3.43`; body says 1.3.44 |
| ADR-0017 | Accepted 2026-07-15 | — | NO | Endpoint URL corrected; size figures corrected; ARCH-INDEX + adr-index consistent |

---

## Findings

### Critical

None.

### Major (MEDIUM)

None.

### Minor (LOW / INFO)

**NEW-R3-001 — INFO — prd-delta-576.md frontmatter `spec_version_after: 1.3.43` is stale**

The prd-delta frontmatter contains `spec_version_after: 1.3.43`. The document body's own
§Security Review Finding Dispositions records "Spec version bumped to 1.3.44 by this fix
round." The spec-changelog has a [1.3.44] entry on 2026-07-15. No implementer decision
depends on the prd-delta frontmatter version field; spec-changelog is the authoritative
version record.

**Action**: Update `spec_version_after: 1.3.43` → `spec_version_after: 1.3.44` in
prd-delta-576.md frontmatter. Burst-close priority.

---

**NEW-R3-002 — LOW — BC-3.9.007 body cross-references `(BC-2.7.005)` instead of `(BC-2.7.007)`**

The JSDCLOUD-10841 ban paragraph in BC-3.9.007 reads: "The authoritative download endpoint
is the platform endpoint: `GET /rest/api/3/attachment/content/{id}` (BC-2.7.005)."

BC-2.7.005 specifies `--filter size-max=<bytes>` client-side filtering — no relationship
to the download endpoint. The correct reference is BC-2.7.007, which specifies
`attachment download` via `GET /rest/api/3/attachment/content/{id}` including EC-2.7.007-2
confirming JSDCLOUD-10841 JSM uniform behavior. The URL itself is stated correctly in the
same sentence, so no implementation is affected, but a story author following the cross-reference
will land on the wrong BC.

**Action**: In BC-3.9.007 body, replace `(BC-2.7.005)` with `(BC-2.7.007)` in the
JSDCLOUD-10841 ban paragraph. Correct before S3 story authoring.

---

## Validation Gate Result

**GAPS-FOUND** — 2 minor findings (1 LOW cross-reference error in BC-3.9.007; 1 INFO stale
frontmatter in prd-delta-576.md). No finding blocks story decomposition. The BC bodies are
the authoritative specification and are correctly formed with all DEC-179 rulings and
SEC-576-001..007 security fixes properly applied.

Recommended resolution order:
1. **NEW-R3-002** (LOW): Fix BC-3.9.007 `(BC-2.7.005)` → `(BC-2.7.007)` — before S3 story authoring.
2. **NEW-R3-001** (INFO): Update prd-delta-576.md frontmatter `spec_version_after` — at burst close.

---

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 16 (4 standard N/A; 12 ops-specific) |
| **Passed** | 10 (security fixes, counts, DEC-179 rulings, research facts, citations, status markers, ADR) |
| **Failed** | 0 |
| **Gaps Found** | 2 (NEW-R3-001 INFO, NEW-R3-002 LOW) |
| **Warnings** | 0 |
| **Prior Findings Closed** | 12 of 12 (CONS-576-001..007, NEW-001..005, CONS-576-002 residual) |
| **Overall Status** | GAPS-FOUND (no blocking gaps) |

---

## Positive Consistency Confirmations

**Security fixes (SEC-576-001..007) in BC bodies:**
- SEC-576-001: Windows device-name caller note in BC-2.7.011; SHA-1 prefix satisfies requirement; test matrix includes CON/NUL/COM1/nul.txt ✓
- SEC-576-002: Two-step containment check in BC-2.7.011; explicit "do NOT call `canonicalize()` on joined path" warning ✓
- SEC-576-003: EC-2.7.007-3 wiremock two-server test requirement in BC-2.7.007 ✓
- SEC-576-004: Multipart encoding note + SQ-6 unit test requirement in BC-3.9.001 ✓
- SEC-576-005: EC-3.9.001-5 in BC-3.9.001 AND parallel step-1 note in BC-3.9.003 ✓
- SEC-576-006: Stale-ID self-healing 4-step procedure in BC-X.8.010; single-attempt guard stated ✓
- SEC-576-007: Step 5.5 trailing-whitespace/dot strip in BC-2.7.011 ✓

**DEC-179 design rulings in BC bodies:**
- Platform-POST default (BC-3.9.001/002) ✓; `--internal` non-JSM = OQ-9 silent no-op (BC-3.9.004 EC-3.9.004-1) ✓
- `--public` non-JSM = exit 64 (BC-3.9.005) ✓; DEC-174 eprint!+read_line NOT dialoguer (BC-3.9.014) ✓
- DEC-168 delete 404 = exit 64 + surface body (BC-3.9.008/013) ✓; JSDCLOUD-10841 platform endpoint (BC-2.7.007) ✓
- JRACLOUD-97046 no `?redirect=false` (BC-2.7.007) ✓; P2-4a internal-by-default JSM (BC-3.9.002) ✓
- P2-3c INCONCLUSIVE deferred to S5 (BC-3.9.007/011) ✓; JRACLOUD-96384 match-by-id (BC-2.7.012) ✓

**BC counts (all 8 surfaces):** 651 = 651 = 651 across BC-INDEX, CANONICAL-COUNTS, per-file frontmatter sums ✓

**Source citations:** zero `interactions.rs` or `issues.rs` references in attachment BC bodies or BC-INDEX attachment rows ✓

**Hard-coded size figures:** BC-3.9.001 and ADR-0017 both use INCONCLUSIVE/instance-configured language ✓

**ADR-0017 / ARCH-INDEX / adr-index consistency:** ADR-0017 accepted; correct endpoint URL; correct size language; ARCH-INDEX and adr-index entries consistent ✓

---

## Appendix: Validation Methodology

Round 3 used the same methodology as Rounds 1 and 2: fresh-context read of all surface-set
artifacts with no prior-round context. Independent findings were formed before consulting
consistency-report-576-r1.md and consistency-report-576-r2.md. Prior reports were used only
to verify closure of CONS-576-001..007 and NEW-001..005.

Checks performed:
- **(a) BC-body vs ratified-design/research contradictions**: each DEC-179 ruling cross-referenced against BC text; all research INCONCLUSIVE verdicts verified not hard-coded in BC bodies or ADR.
- **(b) Index-row vs body fidelity**: BC-INDEX section headers, row counts, and Source columns compared against BC bodies; all corrections from prior rounds confirmed.
- **(c) Source/Trace citations vs F1 NEW-file layout**: direct grep for `interactions.rs` in attachment BC scope confirmed zero residual; all citations verified against impact-boundary §1.1 and §R2.1 classification tables.
- **(d) Hard-coded figures marked INCONCLUSIVE**: BC-3.9.001 and ADR-0017 verified to use INCONCLUSIVE/instance-configured language.
- **(e) Dangling ID references**: BC-3.9.007 cross-reference `(BC-2.7.005)` identified as wrong (should be `BC-2.7.007`); all other BC cross-references checked.
- **(f) Stale status markers**: security-review, impact-boundary, and spec-changelog verified for residual stale markers; all prior findings confirmed resolved.
- **(g) ADR-0017 factual claims vs research file**: redirect endpoint URL, size limit language, and reqwest auth-stripping behavior all verified against research verdicts.
- **(h) Prior-finding closure**: all 12 prior findings verified via direct artifact inspection.
