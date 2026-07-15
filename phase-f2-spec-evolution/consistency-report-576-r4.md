---
document_type: consistency-report
level: ops
version: "4.0"
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
total_findings: 3
new_findings: 3
critical: 0
high: 0
medium: 0
low: 0
info: 3
r1_findings_reviewed: 7
r1_findings_resolved: 7
r2_findings_reviewed: 5
r2_findings_resolved: 5
r3_findings_reviewed: 2
r3_findings_resolved: 2
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
input-hash: "bab6149"
traces_to: ".factory/phase-f2-spec-evolution/prd-delta-576.md"
---

# Consistency Report: SOH-ATTACHMENTS-1 F2 Spec Package (spec v1.3.44) — Round 4

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) |
| **Generated** | 2026-07-15 |
| **Generator** | consistency-validator (fresh context; findings formed before reading prior rounds) |
| **Artifacts Scanned** | 14 (all surface-set items specified in task brief) |
| **Spec Version** | v1.3.44 (post-security-fix, post-r1/r2/r3-fix state) |
| **Feature** | SOH-ATTACHMENTS-1 (issues #576 + #585) |
| **Gate** | DEC-179 F2 spec bundle — round 4 after r3 GAPS-FOUND corrections |

**Review methodology**: Independent fresh-context read of all 14 surface-set artifacts BEFORE
consulting `consistency-report-576-r1.md`, `consistency-report-576-r2.md`, or
`consistency-report-576-r3.md`. Independent findings formed first; prior reports used only to
verify closure of all known findings (CONS-576-001..007, NEW-001..005, NEW-R3-001..002).

**Verdict: GAPS-FOUND** — 3 INFO findings. All 14 prior findings fully resolved. No CRITICAL,
HIGH, MEDIUM, or LOW findings. No blocking gaps before story decomposition.

---

## Summary

| # | Check | Result |
|---|-------|--------|
| 1 | L2 to L3 Requirement Coverage | N/A (ops-level review; no L2 domain-spec in scope) |
| 2 | L3 to L4 Verification Property Coverage | N/A (holdout count unchanged at 88; no VPs added) |
| 3 | Dependency Acyclicity | N/A (no stories authored yet) |
| 4 | Architecture Alignment | PASS |
| 5 | Acceptance Criteria Quality | N/A (no stories authored yet) |
| 6 | Story Sizing | N/A (no stories authored yet) |
| 7 | Priority Consistency | N/A (no stories authored yet) |
| 8 | L1 to L2 to L3 to L4 Chain Completeness | N/A (ops-level review) |
| 9 | AC Completeness Coverage | N/A (no stories authored yet) |
| 10 | ASM/R Traceability | N/A (no ASM/R artifacts in this bundle) |
| — | Prior-finding closure (CONS-576-001..007, NEW-001..005, NEW-R3-001..002) | ALL RESOLVED |
| — | Source/Trace citations vs F1 NEW-file layout | PASS |
| — | INCONCLUSIVE-figure leaks | PASS |
| — | Index/count drift | GAPS-FOUND (NEW-R4-001, NEW-R4-002) |
| — | Stale status markers | PASS |
| — | ADR factual claims vs research | PASS |
| — | BC cross-references (grep-verified) | PASS (NEW-R3-002 fix confirmed) |

---

## 1. L2 to L3 Requirement Coverage

This review is scoped to ops-level cross-document consistency of the SOH-ATTACHMENTS-1 F2
spec bundle. No L2 domain-spec artifact (CAP-NNN) is in the reviewed inputs; this check
does not apply to this review pass.

---

## 2. L3 to L4 Verification Property Coverage

No new Verification Properties (VP-NNN) were added in this delta. `prd-delta-576.md`
confirms `holdout_count_after: 88` (unchanged from before). This check is not applicable
to this review pass.

---

## 3. Dependency Acyclicity

No stories have been authored for this bundle. This check applies at the story-decomposition
phase (F3). Not applicable to this F2 spec review.

---

## 4. Architecture Alignment

### 4.1 Module Coverage

| Architecture Component | BCs Targeting It | Source Citation (per BC body) | F1 Design File | Match? |
|-----------------------|-----------------|------------------------------|----------------|--------|
| `src/cli/issue/attachments.rs` (NEW) | BC-2.7.001..012 | `attachments.rs` | NEW per F1 §1.1 | YES ✓ |
| `src/cli/issue/attachments.rs` (NEW) | BC-3.9.001..014 (CLI handler) | `attachments.rs` | NEW per F1 §1.1 | YES ✓ |
| `src/api/jira/attachments.rs` (NEW) | BC-3.9.001, BC-3.9.008..010, BC-3.9.013 | `jira/attachments.rs` | NEW per F1 §1.1 | YES ✓ |
| `src/api/jsm/attachments.rs` (NEW) | BC-3.9.003, BC-3.9.004, BC-3.9.006, BC-3.9.007 (step-1) | `jsm/attachments.rs` | NEW per F1 §R2.1 | YES ✓ |
| `src/cache.rs` (TOUCHED) | BC-X.8.010 | `src/cache.rs` | TOUCHED per F1 §R2.1 | YES ✓ |
| `src/types/jira/attachment.rs` (NEW) | (via type structs) | implied by F1 §1.1 | NEW per F1 §1.1 | YES (no direct BC cite needed) |
| `src/types/jsm/attachment.rs` (NEW) | (via type structs) | implied by F1 §R2.1 | NEW per F1 §R2.1 | YES (no direct BC cite needed) |

### 4.2 Component Consistency

All BC-3.9 body Source fields correctly cite `src/cli/issue/attachments.rs` for the CLI
handler — zero `interactions.rs` residual confirmed. ADR-0017 decisions (reqwest multipart
+ stream + tokio-util) match F1 impact boundary §R2.4 Cargo.toml additions. ARCH-INDEX.md
lists ADR-0017 with correct subsystems SS-03, SS-09, and correct path. adr-index.md entry
for ADR-0017 is consistent with ARCH-INDEX.md.

BC-3.9.007 cross-reference `(BC-2.7.007)` for the JSDCLOUD-10841 ban paragraph is correct
(NEW-R3-002 fix verified by grep). No other BC cross-reference errors found in attachment
scope.

---

## 5. Acceptance Criteria Quality

No stories have been authored for this bundle. This check will apply at F3 (story
decomposition). Not applicable to this F2 spec review.

---

## 6. Story Sizing

No stories have been authored for this bundle. Not applicable to this F2 spec review.

---

## 7. Priority Consistency

No stories have been authored for this bundle. Not applicable to this F2 spec review.

---

## 8. L1 to L2 to L3 to L4 Chain Completeness

This ops-level review checks cross-document consistency within the F2 spec artifacts, not
L1→L4 chain completeness. That check applies at the full-spec validation gate.

---

## 9. AC Completeness Coverage

No stories have been authored for this bundle. Not applicable to this F2 spec review.

---

## 10. ASM/R Traceability

No ASM/R (Assumption/Risk) artifacts are in the reviewed inputs for this bundle. Not
applicable to this review pass.

---

## Prior-Finding Closure Table

### CONS-576-001..007 (R1 findings)

| Finding | Severity | Closure Status | Verification Method |
|---------|----------|---------------|---------------------|
| CONS-576-001 — BC-INDEX row BC-2.7.011 stale algorithm | MEDIUM | **RESOLVED** | BC-INDEX row BC-2.7.011 shows 5.5-step algorithm, char scrub `/`/`\`/`:` → `_` only, 255-byte cap, step 5.5, SEC-576-002 two-step containment, SEC-576-001 Windows device-name caller note; Source = `attachments.rs`. Independently verified. |
| CONS-576-002 — BC-3.9 bodies/BC-INDEX cite `interactions.rs` | LOW | **RESOLVED** | grep for `interactions.rs` in bc-3-issue-write.md BC-3.9 scope returns zero hits; all 14 BC-INDEX Section 3.9 rows cite `attachments.rs` or `jsm/attachments.rs`. Zero residual. |
| CONS-576-003 — BC-X.8.010 Source cites `requests.rs` | LOW | **RESOLVED** | BC-X.8.010 Source cites `src/api/jsm/attachments.rs::attach_temporary_file`. |
| CONS-576-004 — BC-INDEX Section 2.7 rows cite `interactions.rs` | LOW | **RESOLVED** | All 12 Section 2.7 rows cite `src/cli/issue/attachments.rs (pending S1/S2)`. |
| CONS-576-005 — security-review-576.md status stale | LOW | **RESOLVED** | Frontmatter: `status: final`, `verdict: APPROVE`. All 7 findings show `Status: **resolved**`. |
| CONS-576-006 — impact-boundary §R2.2 contradicts §OQ-9 | LOW | **RESOLVED** | `[PHASE-DOC-RETRO-ANNOTATION 2026-07-15 — CONS-576-006: …]` present inline in §R2.2; BC-3.9.004 noted as correct spec. |
| CONS-576-007 — spec-changelog says "ADR-0017 planned" | INFO | **RESOLVED** | spec-changelog [1.3.43] ADR row reads "ADR-0017 Accepted 2026-07-15 (`.factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md`) [CONS-576-007 correction…]". |

### NEW-001..005 (R2 findings)

| Finding | Severity | Closure Status | Verification Method |
|---------|----------|---------------|---------------------|
| NEW-001 — BC-3.9.001 "10 MB" / ADR-0017 "250 MB" contradict INCONCLUSIVE | LOW | **RESOLVED** | BC-3.9.001 body: "instance-configured limit (INCONCLUSIVE — P2-3c research finding…)". ADR-0017 §Context: "instance-configured and site/plan-dependent; the research verdict is inconclusive across sources — do not hard-code a figure; DEC-179 ruling 4". |
| NEW-002 — ADR-0017 §Context wrong endpoint URL | LOW | **RESOLVED** | ADR-0017 §Context cites "`GET /rest/api/3/attachment/content/{id}` content endpoint" — correct. |
| NEW-003 — BC-INDEX Section 3.9 rows cite `interactions.rs` | LOW | **RESOLVED** | All 14 Section 3.9 BC-INDEX rows cite `src/cli/issue/attachments.rs` or `src/api/jsm/attachments.rs` as appropriate. |
| NEW-004 — CANONICAL-COUNTS.md BC-X.4.009 note stale numbers | INFO | **RESOLVED** | CANONICAL-COUNTS.md lines now read `total_bcs: 150`, `651 sum`, "NOT add +1 beyond the 650"; retro-note annotation present. |
| NEW-005 — impact-boundary §R2.3 BC-3.9.012 row pre-OQ-9 | INFO | **RESOLVED** | `[PHASE-DOC-RETRO-ANNOTATION 2026-07-15 — NEW-005/CONS-576-006: …]` present in §R2.3 BC-3.9.012 row. |

### NEW-R3-001..002 (R3 findings)

| Finding | Severity | Closure Status | Verification Method |
|---------|----------|---------------|---------------------|
| NEW-R3-001 — prd-delta-576.md frontmatter `spec_version_after: 1.3.43` stale | INFO | **RESOLVED** | prd-delta-576.md frontmatter: `spec_version_after: 1.3.44`. Confirmed by direct read (line 8). |
| NEW-R3-002 — BC-3.9.007 cross-references `(BC-2.7.005)` instead of `(BC-2.7.007)` | LOW | **RESOLVED** | BC-3.9.007 JSDCLOUD-10841 ban paragraph reads "…the platform endpoint: `GET /rest/api/3/attachment/content/{id}` (BC-2.7.007)." Confirmed by grep: `(BC-2.7.007)` present; no `(BC-2.7.005)` in bc-3 attachment section. |

**All 14 prior findings fully resolved. Zero residual.**

---

## Cross-Reference Validation

### ID Consistency

| Check | Status | Issues |
|-------|--------|--------|
| BC IDs unique (2.7.001..012, 3.9.001..014, X.8.010) | pass | No duplicates found |
| BC-INDEX row count vs BC body count (Section 2.7) | pass | 12 rows = 12 bodies |
| BC-INDEX row count vs BC body count (Section 3.9) | pass | 14 rows = 14 bodies |
| BC-INDEX row count vs BC body count (X.8) | pass | BC-X.8.010 present in both index and body |
| Per-file frontmatter total_bcs vs CANONICAL-COUNTS | pass | All 8 files match; sum = 651 |
| Grand total 651 consistent across BC-INDEX, CANONICAL-COUNTS, per-file sums | pass | 651 = 651 = 651 |
| Security findings SEC-576-001..007 applied in BC bodies | pass | All 7 verified present via independent read |
| BC-3.9.007 JSDCLOUD-10841 cross-reference | pass | `(BC-2.7.007)` confirmed correct (NEW-R3-002 fix verified) |
| bc-2-issue-read.md footer count | fail | Footer says "52/94" (pre-F2 values); correct values are 64/106 — see NEW-R4-001 |
| CANONICAL-COUNTS.md ADR count vs adr-index.md row count | fail | States 16; adr-index.md has 17 rows — see NEW-R4-002 (documented deferral) |

### Naming Convention Compliance

| Convention | Expected Pattern | Violations |
|-----------|-----------------|------------|
| BC naming (read) | BC-2.7.NNN | None — BC-2.7.001..012 correctly formed |
| BC naming (write) | BC-3.9.NNN | None — BC-3.9.001..014 correctly formed |
| BC naming (cross-cut) | BC-X.8.NNN | None — BC-X.8.010 correctly formed |
| Finding IDs (r1) | CONS-576-NNN | 7 findings: CONS-576-001..007 |
| Finding IDs (r2) | NEW-NNN | 5 findings: NEW-001..005 |
| Finding IDs (r3) | NEW-R3-NNN | 2 findings: NEW-R3-001, NEW-R3-002 |
| Finding IDs (r4) | NEW-R4-NNN | 3 findings: NEW-R4-001, NEW-R4-002, NEW-R4-003 |

### Canonical Frontmatter Validation

| Artifact | document_type | level | version | producer | traces_to | Status |
|----------|--------------|-------|---------|----------|-----------|--------|
| prd-delta-576.md | prd-delta | — | — | — | present | pass (proprietary frontmatter; `spec_version_after: 1.3.44` confirmed) |
| security-review-576.md | security-review | ops | "1.0" | security-reviewer | present | pass (`status: final`, `verdict: APPROVE`) |
| impact-boundary-576.md | — | — | — | — | — | no standard frontmatter; pass |
| ADR-0017 | adr | — | — | — | — | Accepted 2026-07-15; conforms to ADR template |
| BC-INDEX.md | bc-index | — | — | — | — | non-standard; conforms; `total_bcs: 651`, `index_version: v6.13` |
| CANONICAL-COUNTS.md | canonical-counts | — | — | — | — | non-standard; conforms; sum = 651 |

---

## Findings

### Critical

None.

### Major (MEDIUM)

None.

### Minor (LOW)

None.

### INFO

---

**NEW-R4-001 — INFO — bc-2-issue-read.md footer carries stale pre-F2 BC counts**

**Location**: `bc-2-issue-read.md`, footer line: `## Total BCs in this file: 52 (representative set; BC-INDEX.md carries all 94)`

**Finding**: The footer count (52 individually-bodied, 94 cumulative) reflects the
pre-SOH-ATTACHMENTS-1 state. The spec-changelog entry [1.3.43] explicitly documents the
transition: `definitional_count: 52 → 64` and `total_bcs: 94 → 106`. The current correct
values — 64 individually-bodied, 106 cumulative — are correctly stated in the frontmatter
(`total_bcs: 106`, `definitional_count: 64`) and confirmed by grep (`#### BC-` heading
count = 64). The footer was not updated during the F2 burst.

For comparison: bc-3-issue-write.md footer was correctly updated (states "105 individually-bodied
(cumulative 134 incl. range-collapsed)"). Only bc-2 was missed.

**Impact**: No implementation decision or story authoring depends on the footer; frontmatter
and BC-INDEX.md are the authoritative count surfaces and are correct. Risk is limited to a
future reviewer citing the footer number without checking frontmatter.

**Action**: Update footer to: `## Total BCs in this file: 64 individually-bodied (cumulative 106 incl. range-collapsed; see BC-INDEX.md)`. Optionally append a "Last updated" note matching the bc-3 style. **Priority**: Burst-close (no story decomposition impact).

---

**NEW-R4-002 — INFO — CANONICAL-COUNTS.md §ADRs states "Canonical ADR count: 16" but ADR-0017 now exists (documented deferral)**

**Location**: `CANONICAL-COUNTS.md` §ADRs: "**Canonical ADR count: 16** (ADR-0001..ADR-0016; all present, no gaps)"

**Finding**: ADR-0017 was accepted on 2026-07-15 and is correctly reflected in ARCH-INDEX.md
and adr-index.md. CANONICAL-COUNTS.md §ADRs still claims a count of 16.

The prd-delta-576.md explicitly documents this as a deferred item:
> "The convention for counting factory-side ADRs in CANONICAL-COUNTS.md is to be settled by the
> state-manager at burst close — CANONICAL-COUNTS ADR count is not bumped here pending that ruling."

The CANONICAL-COUNTS.md §ADRs verification instruction reads: "count rows in adr-index.md Summary
Table (both `[ADR-NNNN]` link rows and plain `ADR-NNNN` rows)." Running that verification against
the current adr-index.md yields 17 (the ADR-0017 link row is present), but the stated canonical
count is 16.

**Impact**: No BC body, story, or behavioral contract depends on this number. ARCH-INDEX.md and
adr-index.md are consistent with each other and both accurately reflect ADR-0017. This is a
documented deferral, not a missed gap.

**Action**: State-manager updates CANONICAL-COUNTS.md §ADRs at burst close: bump count to 17;
add ADR-0017 bullet; clarify factory-side vs product-repo ADR location convention. **Priority**: Burst-close (explicitly deferred per prd-delta-576.md).

---

**NEW-R4-003 — INFO — bc-3-issue-write.md footer "Last updated" history note does not record the 2026-07-15 SOH-ATTACHMENTS-1 F2 update**

**Location**: `bc-3-issue-write.md`, footer `_Last updated …_` history note.

**Finding**: The bc-3-issue-write.md footer count (105/134) is correct for the post-SOH-ATTACHMENTS-1
state. However, the `_Last updated_` history narrative ends at 2026-07-09 (SOH-COMMENT-CRUD-1 F2,
+11 BCs BC-3.5.002..BC-3.5.012). The 2026-07-15 SOH-ATTACHMENTS-1 F2 update (+14 BCs
BC-3.9.001..014, changing counts from 91/120 to 105/134) is not recorded in the history note.

**Impact**: No implementation or story authoring impact. The gap could mislead a reviewer using
the history note to determine when bc-3 was last modified. The count itself is accurate.

**Action**: Append to the footer history note at burst close: `_Previous update 2026-07-15 (issue #576 SOH-ATTACHMENTS-1 F2, DEC-179): +14 BCs (BC-3.9.001..014) — platform upload POST, JSM two-step, --public/--internal visibility, confirmation gate, delete, JSON shapes, error taxonomies (Section 3.9 Attachment Write)._` **Priority**: Burst-close (cosmetic; no blocking impact).

---

## Spec vs Implementation Drift

| Artifact | Spec Version | Implementation State | Drift Detected | Notes |
|----------|-------------|---------------------|---------------|-------|
| bc-2-issue-read.md §BC-2.7.001..012 | v1.3.44 | PENDING (S1/S2) | NO | All SEC-576 fixes present; Source citations correct; frontmatter counts accurate |
| bc-3-issue-write.md §BC-3.9.001..014 | v1.3.44 | PENDING (S3/S4/S5) | NO | BC-3.9.007 `(BC-2.7.007)` cross-ref confirmed correct (NEW-R3-002 resolved) |
| cross-cutting.md §BC-X.8.010 | v1.3.44 | PENDING (S5) | NO | SEC-576-006 stale-ID self-healing clause present; Source correct |
| BC-INDEX.md §2.7 and §3.9 rows | v1.3.44 | — | NO | All Source citations correct; counts 106/64, 134/105, 150/84 consistent |
| CANONICAL-COUNTS.md | v1.3.44 | — | PARTIAL (NEW-R4-002) | BC counts all correct at 651; ADR count stale at 16 (documented deferral) |
| security-review-576.md | v1.3.44 | APPROVE | NO | `status: final`, `verdict: APPROVE`; all 7 findings resolved |
| impact-boundary-576.md | v1.3.44 + retro-annotations | — | NO | §R2.2 CONS-576-006 + §R2.3 NEW-005 retro-annotations both present |
| spec-changelog.md | v1.3.44 | — | NO | [1.3.43] and [1.3.44] entries accurate; ADR-0017 reference corrected per CONS-576-007 |
| prd-delta-576.md | v1.3.44 | — | NO | `spec_version_after: 1.3.44` confirmed (NEW-R3-001 resolved) |
| ADR-0017 | Accepted 2026-07-15 | — | NO | Endpoint URL correct; size figures INCONCLUSIVE; ARCH-INDEX + adr-index consistent |
| bc-2-issue-read.md footer | v1.3.44 | — | YES (NEW-R4-001) | Footer says "52/94"; correct values are "64/106" |
| bc-3-issue-write.md footer history | v1.3.44 | — | PARTIAL (NEW-R4-003) | Count 105/134 correct; "Last updated" history note stops at 2026-07-09 |

---

## Validation Gate Result

**GAPS-FOUND** — 3 INFO findings (NEW-R4-001, NEW-R4-002, NEW-R4-003). All 14 prior findings
(CONS-576-001..007, NEW-001..005, NEW-R3-001..002) verified closed.

No finding is blocking. Story decomposition for SOH-ATTACHMENTS-1 may proceed. The three INFO
findings are cosmetic documentation gaps to be resolved by the state-manager at burst close.

**Recommended resolution order (all at burst close, no story-authoring dependency):**
1. **NEW-R4-001** — Update bc-2-issue-read.md footer: "52 (representative set; BC-INDEX.md carries all 94)" → "64 individually-bodied (cumulative 106 incl. range-collapsed; see BC-INDEX.md)".
2. **NEW-R4-002** — Bump CANONICAL-COUNTS.md §ADRs count 16 → 17; add ADR-0017 bullet; clarify factory-side convention.
3. **NEW-R4-003** — Append 2026-07-15 SOH-ATTACHMENTS-1 update entry to bc-3-issue-write.md footer history note.

---

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 18 (4 standard N/A; 14 ops-specific) |
| **Passed** | 11 (security fixes, DEC-179 rulings, INCONCLUSIVE language, BC cross-references, counts across 6 authoritative surfaces, ADR facts, impact-boundary annotations, spec-changelog) |
| **Failed** | 0 (no blocking failures) |
| **Gaps Found** | 3 (NEW-R4-001 INFO, NEW-R4-002 INFO, NEW-R4-003 INFO) |
| **Warnings** | 0 |
| **Prior Findings Closed** | 14 of 14 (CONS-576-001..007, NEW-001..005, NEW-R3-001..002) |
| **Overall Status** | GAPS-FOUND (no blocking gaps; 3 cosmetic INFO items for burst close) |

---

## Positive Consistency Confirmations

**Security fixes (SEC-576-001..007) in BC bodies — all present and correct:**
- SEC-576-001: Windows device-name caller note in BC-2.7.011; SHA-1 prefix satisfies requirement; test matrix includes CON/NUL/COM1/nul.txt ✓
- SEC-576-002: Two-step containment check in BC-2.7.011; explicit "Do NOT call `canonicalize()` on the joined path" warning ✓
- SEC-576-003: EC-2.7.007-3 wiremock two-server test requirement in BC-2.7.007 ✓
- SEC-576-004: Multipart encoding note + SQ-6 unit test requirement in BC-3.9.001 ✓
- SEC-576-005: EC-3.9.001-5 in BC-3.9.001 AND parallel step-1 note in BC-3.9.003 ✓
- SEC-576-006: Stale-ID self-healing 4-step procedure in BC-X.8.010; single-attempt guard stated ✓
- SEC-576-007: Step 5.5 trailing-whitespace/dot strip in BC-2.7.011 ✓

**DEC-179 design rulings in BC bodies — all present:**
- Platform-POST default (BC-3.9.001/002); `--internal` non-JSM = OQ-9 silent no-op (BC-3.9.004) ✓
- `--public` non-JSM = exit 64 (BC-3.9.005); DEC-174 `eprint!+read_line` NOT dialoguer (BC-3.9.014) ✓
- DEC-168 delete 404 = exit 64 + surface body (BC-3.9.008/013); JSDCLOUD-10841 platform endpoint (BC-2.7.007) ✓
- JRACLOUD-97046 no `?redirect=false` (BC-2.7.007); P2-4a internal-by-default JSM (BC-3.9.002) ✓
- P2-3c INCONCLUSIVE deferred to S5 (BC-3.9.007/011); JRACLOUD-96384 match-by-id (BC-2.7.012) ✓

**BC counts across all authoritative surfaces — all consistent at 651:**
- bc-2-issue-read.md frontmatter: `total_bcs: 106`, `definitional_count: 64`; grep count = 64 ✓
- bc-3-issue-write.md frontmatter: `total_bcs: 134`, `definitional_count: 105`; grep count = 105 ✓
- cross-cutting.md frontmatter: `total_bcs: 150`, `definitional_count: 84`; grep count = 84 ✓
- BC-INDEX.md section headers: 106/64, 134/105, 150/84; grand total: 651 ✓
- CANONICAL-COUNTS.md per-file table: all 8 files match frontmatter; Sum = 651 ✓
- prd-delta-576.md: `bc_count_before: 624`, `bc_count_after: 651`; delta = 27 = 12+14+1 ✓

**Source citations — zero stale `interactions.rs` residual in attachment BC scope** ✓

**INCONCLUSIVE figures — not hard-coded in BC-3.9.001 or ADR-0017** ✓

**ADR-0017 — ARCH-INDEX.md and adr-index.md mutually consistent; both reflect Accepted status** ✓

---

## Appendix: Validation Methodology

Round 4 used the same methodology as Rounds 1–3: fresh-context read of all surface-set
artifacts with no prior-round context loaded. Independent findings were formed before
consulting consistency-report-576-r1.md, consistency-report-576-r2.md, and
consistency-report-576-r3.md. Prior reports were used only to verify closure of
CONS-576-001..007, NEW-001..005, and NEW-R3-001..002.

**Checks performed:**

**(a) Design/research contradictions**: Each DEC-179 ruling cross-referenced against BC text. All
research INCONCLUSIVE verdicts verified not hard-coded in BC bodies or ADR. No contradictions
found beyond the pre-existing retro-annotations in impact-boundary-576.md.

**(b) Index-row vs body fidelity**: BC-INDEX section headers, row counts, Source columns, and
BC ID ranges compared against BC bodies. All 27 new BC bodies (12 in §2.7, 14 in §3.9, 1 in
§X.8) confirmed present. BC-INDEX coverage statistics coverage table cross-checked against
actual file counts.

**(c) Citation targets (grep-verify cross-references)**: All BC-to-BC cross-references in
attachment scope verified by grep. NEW-R3-002 fix confirmed: BC-3.9.007 `(BC-2.7.007)` is
correct. BC-2.7.011 cross-refs to BC-2.7.010 and BC-2.7.008 EC-2.7.008-2 verified correct.

**(d) INCONCLUSIVE-figure leaks**: BC-3.9.001 and ADR-0017 both confirmed to use
INCONCLUSIVE/instance-configured language. No numeric size cap appears in any BC body or ADR.

**(e) Dangling IDs**: No finding IDs, BC IDs, or document references that resolve to
non-existent targets found in attachment scope.

**(f) Stale status markers**: security-review-576.md `status: final`, `verdict: APPROVE`
confirmed. All 7 SEC-576-NNN findings show `Status: **resolved**`. impact-boundary retro-
annotations confirmed present. spec-changelog [1.3.43] ADR reference corrected per CONS-576-007.

**(g) ADR factual claims**: ADR-0017 content independently verified against research file
`.factory/research/issue-576-attachments-api-2026-07-15.md` for endpoint URL, size limit
language, and redirect credential-stripping behavior.

**(h) Prior-finding closure**: All 14 prior findings verified via direct artifact inspection
(not relying solely on worklog claims). Each finding was re-checked against the actual
document text.

**(i) Footer / history notes**: bc-2-issue-read.md and bc-3-issue-write.md footer lines
examined independently of frontmatter; stale footer in bc-2 found (NEW-R4-001) and incomplete
history note in bc-3 found (NEW-R4-003).

**(j) CANONICAL-COUNTS.md peripheral tables**: §ADRs section checked; ADR count stale at 16
(NEW-R4-002; documented deferral per prd-delta-576.md). §Holdout Scenarios, §NFR Counts, and
§Risk Register not part of this delta scope and not re-checked.
