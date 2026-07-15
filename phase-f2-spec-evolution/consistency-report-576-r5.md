---
document_type: consistency-report
level: ops
version: "5.0"
status: CONSISTENT
producer: consistency-validator
timestamp: 2026-07-15T00:00:00
feature: SOH-ATTACHMENTS-1
issues: "#576, #585"
phase: F2
authored: 2026-07-15
reviewer_role: consistency-validator
spec_version: 1.3.44
verdict: CONSISTENT
total_findings: 1
new_findings: 1
critical: 0
high: 0
medium: 0
low: 0
info: 1
r1_findings_reviewed: 7
r1_findings_resolved: 7
r2_findings_reviewed: 5
r2_findings_resolved: 5
r3_findings_reviewed: 2
r3_findings_resolved: 2
r4_findings_reviewed: 3
r4_findings_resolved: 2
r4_findings_expected_open: 1
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
input-hash: "559fb5d"
traces_to: ".factory/phase-f2-spec-evolution/prd-delta-576.md"
---

# Consistency Report: SOH-ATTACHMENTS-1 F2 Spec Package (spec v1.3.44) — Round 5

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) |
| **Generated** | 2026-07-15 |
| **Generator** | consistency-validator (fresh context; findings formed before reading prior rounds) |
| **Artifacts Scanned** | 14 (all surface-set items specified in task brief) |
| **Spec Version** | v1.3.44 (post-security-fix, post-r1/r2/r3/r4-fix state) |
| **Feature** | SOH-ATTACHMENTS-1 (issues #576 + #585) |
| **Gate** | DEC-179 F2 spec bundle — round 5 after r4 GAPS-FOUND corrections |

**Review methodology**: Independent fresh-context read of all 14 surface-set artifacts BEFORE
consulting `consistency-report-576-r1.md` through `consistency-report-576-r4.md`. Independent
findings formed first; prior reports used only to verify closure of all 17 known findings
(CONS-576-001..007, NEW-001..005, NEW-R3-001..002, NEW-R4-001..003; NEW-R4-002 was documented
as EXPECTED-OPEN deferral).

**Verdict: CONSISTENT** — 1 INFO finding (NEW-R5-001). All 17 prior findings fully accounted
for (16 RESOLVED, 1 EXPECTED-OPEN per documented deferral). No CRITICAL, HIGH, MEDIUM, or
LOW findings. No blocking gaps before story decomposition.

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
| — | Prior-finding closure (all 17 prior findings) | PASS (16 RESOLVED, 1 EXPECTED-OPEN) |
| — | Source/Trace citations vs F1 NEW-file layout | PASS |
| — | INCONCLUSIVE-figure leaks | PASS |
| — | Index/count drift (8 guarded surfaces) | PASS |
| — | Footer/history-note completeness | GAPS-FOUND (NEW-R5-001 INFO) |
| — | Stale status markers | PASS |
| — | ADR factual claims vs research | PASS |
| — | BC cross-references (grep-verified) | PASS |
| — | prd-delta-576 frontmatter fields | PASS |
| — | BC body/BC-INDEX row alignment | PASS |

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

### CONS-576-001..007 (R1 findings) — All RESOLVED

| Finding | Severity | Closure Status | Verification Method |
|---------|----------|---------------|---------------------|
| CONS-576-001 — BC-INDEX row BC-2.7.011 stale algorithm | MEDIUM | **RESOLVED** | BC-INDEX row BC-2.7.011 (line 230) shows 5.5-step algorithm, char scrub `/`/`\`/`:` only, 255-byte cap, step 5.5, SEC-576-002 two-step canonicalize containment, SEC-576-001 Windows device-name caller note; Source = `attachments.rs`. Verified by direct read. |
| CONS-576-002 — BC-3.9.x bodies/BC-INDEX cite `interactions.rs` | LOW | **RESOLVED** | grep for `interactions.rs` in bc-3-issue-write.md Section 3.9 scope = 0 hits; all 14 BC-INDEX Section 3.9 rows cite `attachments.rs` or `jsm/attachments.rs`. |
| CONS-576-003 — BC-X.8.010 Source cites `requests.rs` | LOW | **RESOLVED** | BC-X.8.010 Trace (line 749): cites `src/api/jsm/attachments.rs::attach_temporary_file`. |
| CONS-576-004 — BC-INDEX Section 2.7 rows cite `interactions.rs` | LOW | **RESOLVED** | All 12 Section 2.7 BC-INDEX rows cite `src/cli/issue/attachments.rs (pending S1/S2)`. |
| CONS-576-005 — security-review-576.md status stale | LOW | **RESOLVED** | security-review-576.md frontmatter: `status: final`, `verdict: APPROVE`. All 7 findings show `Status: **resolved**`. |
| CONS-576-006 — impact-boundary §R2.2 contradicts §OQ-9 | LOW | **RESOLVED** | `[PHASE-DOC-RETRO-ANNOTATION 2026-07-15 — CONS-576-006: …]` present inline in §R2.2 (line 454); §R2.3 BC-3.9.012 row annotation also present (line 467). BC-3.9.004 OQ-9 silent-no-op correctly implemented. |
| CONS-576-007 — spec-changelog says "ADR-0017 planned" | INFO | **RESOLVED** | spec-changelog [1.3.43] ADR row reads "ADR-0017 Accepted 2026-07-15 (`.factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md`) [CONS-576-007 correction…]". |

### NEW-001..005 (R2 findings) — All RESOLVED

| Finding | Severity | Closure Status | Verification Method |
|---------|----------|---------------|---------------------|
| NEW-001 — BC-3.9.001 hard-coded "10 MB" contradicts INCONCLUSIVE | LOW | **RESOLVED** | BC-3.9.001 body: "instance-configured limit (INCONCLUSIVE — P2-3c research finding; limit not documented in live Jira API; defer to implementer live-capture on S3)". BC-3.9.012 EC-3.9.012-3: "message does NOT state a numeric size limit". ADR-0017 §Context: "instance-configured and site/plan-dependent; the research verdict is inconclusive across sources — do not hard-code a figure; DEC-179 ruling 4". |
| NEW-002 — ADR-0017 §Context wrong endpoint URL | LOW | **RESOLVED** | ADR-0017 §Context cites "`GET /rest/api/3/attachment/content/{id}` content endpoint" — correct. |
| NEW-003 — BC-INDEX Section 3.9 rows cite `interactions.rs` | LOW | **RESOLVED** | All 14 Section 3.9 BC-INDEX rows cite `src/cli/issue/attachments.rs` or `src/api/jsm/attachments.rs`. |
| NEW-004 — CANONICAL-COUNTS.md BC-X.4.009 note stale numbers | INFO | **RESOLVED** | Line 65: `total_bcs: 150`; line 65 note: "651 sum", "NOT add +1 beyond the 650". Retro-annotation present (line 66). |
| NEW-005 — impact-boundary §R2.3 BC-3.9.012 row pre-OQ-9 | INFO | **RESOLVED** | `[PHASE-DOC-RETRO-ANNOTATION 2026-07-15 — NEW-005/CONS-576-006: …]` present in §R2.3 BC-3.9.012 row (line 467). |

### NEW-R3-001..002 (R3 findings) — All RESOLVED

| Finding | Severity | Closure Status | Verification Method |
|---------|----------|---------------|---------------------|
| NEW-R3-001 — prd-delta-576.md frontmatter `spec_version_after: 1.3.43` stale | INFO | **RESOLVED** | prd-delta-576.md frontmatter line 8: `spec_version_after: 1.3.44`. |
| NEW-R3-002 — BC-3.9.007 cross-references `(BC-2.7.005)` instead of `(BC-2.7.007)` | LOW | **RESOLVED** | BC-3.9.007 JSDCLOUD-10841 content-URL ban paragraph (line 3381): "…platform endpoint: `GET /rest/api/3/attachment/content/{id}` (BC-2.7.007)." Confirmed by grep: `(BC-2.7.007)` present; no `(BC-2.7.005)` in bc-3 Section 3.9. |

### NEW-R4-001..003 (R4 findings) — 2 RESOLVED, 1 EXPECTED-OPEN

| Finding | Severity | Closure Status | Verification Method |
|---------|----------|---------------|---------------------|
| NEW-R4-001 — bc-2-issue-read.md footer carries pre-F2 counts "52/94" | INFO | **RESOLVED** | bc-2-issue-read.md footer line 857: `## Total BCs in this file: 64 individually-bodied (cumulative 106 incl. range-collapsed; see BC-INDEX.md)`. Counts correct. |
| NEW-R4-002 — CANONICAL-COUNTS.md §ADRs count says 16; adr-index has 17 rows | INFO | **EXPECTED-OPEN** (documented deferral) | CANONICAL-COUNTS.md §ADRs still reads "**Canonical ADR count: 16**". Per prd-delta-576.md ADR Reference note: "The convention for counting factory-side ADRs in CANONICAL-COUNTS.md is to be settled by the state-manager at burst close — CANONICAL-COUNTS ADR count is not bumped here pending that ruling." This is a formal deferral, not a missed gap. ARCH-INDEX.md and adr-index.md both correctly reflect ADR-0017 (Accepted). |
| NEW-R4-003 — bc-3-issue-write.md footer history note stops at 2026-07-09 | INFO | **RESOLVED** | bc-3-issue-write.md footer line 3573: history note begins with "Last updated 2026-07-15 (SOH-ATTACHMENTS-1 F2, DEC-179, issues #576+#585): +14 BCs (BC-3.9.001..BC-3.9.014)…" and correctly prepends the 2026-07-15 entry. Prior entry correctly relabeled "Previous update 2026-07-09". |

**All 17 prior findings fully accounted for. 16 RESOLVED. 1 EXPECTED-OPEN (NEW-R4-002, documented
deferral to state-manager at burst close). Zero residual.**

---

## Cross-Reference Validation

### ID Consistency

| Check | Status | Notes |
|-------|--------|-------|
| BC IDs unique (2.7.001..012, 3.9.001..014, X.8.010) | PASS | No duplicates in any file |
| BC-INDEX row count vs BC body count (Section 2.7) | PASS | 12 rows = 12 bodies |
| BC-INDEX row count vs BC body count (Section 3.9) | PASS | 14 rows = 14 bodies |
| BC-INDEX row count vs BC body count (Section X.8) | PASS | BC-X.8.010 present in both index and body |
| Per-file frontmatter total_bcs vs CANONICAL-COUNTS per-file table | PASS | All 8 files consistent; sum = 651 |
| Grand total 651 across BC-INDEX frontmatter, BC-INDEX body, CANONICAL-COUNTS | PASS | 651 = 651 = 651 (all three surfaces) |
| Security findings SEC-576-001..007 applied in BC bodies | PASS | All 7 independently verified present |
| BC-3.9.007 JSDCLOUD-10841 cross-reference | PASS | `(BC-2.7.007)` confirmed (line 3381); NEW-R3-002 fix verified |
| bc-2-issue-read.md footer count | PASS | "64 individually-bodied (cumulative 106…)" — NEW-R4-001 fix verified |
| bc-3-issue-write.md footer history note | PASS | 2026-07-15 entry present — NEW-R4-003 fix verified |
| BC-INDEX body note enumeration completeness | GAPS-FOUND | See NEW-R5-001 below |
| CANONICAL-COUNTS.md ADR count | EXPECTED-OPEN | NEW-R4-002 deferred to state-manager |

### Security Fix Verification (SEC-576-001..007)

All 7 security findings independently verified in BC bodies:

- **SEC-576-001**: BC-2.7.011 — Windows device-name caller note present; SHA-1 prefix satisfies requirement; unit test matrix includes `"CON"`, `"NUL"`, `"COM1"`, `"nul.txt"` with `Some(name)` return (caller contract confirmed). ✓
- **SEC-576-002**: BC-2.7.011 — "Do NOT call `canonicalize()` on the joined path" warning present; two-step procedure `canonicalize(out_dir)` then `starts_with(resolved_dir)` specified; non-existent-path ambiguity resolved. ✓
- **SEC-576-003**: BC-2.7.007 — EC-2.7.007-3 present: wiremock two-server test MUST assert `Authorization` absent on redirect-target request. ✓
- **SEC-576-004**: BC-3.9.001 — multipart encoding note + SQ-6 unit test requirement for `;`, `"`, `\r\n` filenames present. ✓
- **SEC-576-005**: BC-3.9.001 — EC-3.9.001-5 present; BC-3.9.003 step-1 parallel note present (both upload endpoints). ✓
- **SEC-576-006**: BC-X.8.010 — stale-ID self-healing clause present (delete + single-retry on 404/403); "retry is a single-attempt guard — it does not loop" explicit. ✓
- **SEC-576-007**: BC-2.7.011 — step 5.5 trailing-whitespace/dot strip present. ✓

### DEC-179 Design Ruling Verification

All DEC-179 rulings correctly reflected in BC bodies:

- Platform-POST default (BC-3.9.001/002): platform POST = internal on JSM by default (P2-4a) ✓
- `--internal` non-JSM = OQ-9 silent no-op (BC-3.9.004 EC-3.9.004-1) ✓
- `--public` non-JSM = exit 64 (BC-3.9.005) ✓
- DEC-174 confirmation gate: `eprint!` (NOT `eprintln!`) + `read_line`, NOT `dialoguer::Confirm` (BC-3.9.014 line 3545) ✓
- DEC-168 delete 404 = exit 64 + surface body (BC-3.9.008/013) ✓
- JSDCLOUD-10841 platform endpoint for downloads (BC-2.7.007, BC-3.9.007) ✓
- JRACLOUD-97046 no `?redirect=false` (BC-2.7.007) ✓
- P2-3c INCONCLUSIVE deferred to S5 (BC-3.9.007/011) ✓
- JRACLOUD-96384 match-by-id invariant (BC-2.7.012/BC-2.7.004) ✓
- GHSA-9857-6MW7-FQ2M reqwest redirect credential-stripping (BC-2.7.007 EC-2.7.007-3) ✓

### BC Counts Across All Authoritative Surfaces

| Surface | Value | Status |
|---------|-------|--------|
| bc-2-issue-read.md frontmatter `total_bcs` | 106 | ✓ |
| bc-2-issue-read.md frontmatter `definitional_count` | 64 | ✓ |
| bc-3-issue-write.md frontmatter `total_bcs` | 134 | ✓ |
| bc-3-issue-write.md frontmatter `definitional_count` | 105 | ✓ |
| cross-cutting.md frontmatter `total_bcs` | 150 | ✓ |
| cross-cutting.md frontmatter `definitional_count` | 84 | ✓ |
| BC-INDEX.md frontmatter `total_bcs` | 651 | ✓ |
| BC-INDEX.md section header (2: Issue Read) | 106 / 64 | ✓ |
| BC-INDEX.md section header (3: Issue Write) | 134 / 105 | ✓ |
| BC-INDEX.md section header (X: Cross-Cutting) | 150 / 84 | ✓ |
| BC-INDEX.md Coverage Statistics table Sum | 651 / 421 | ✓ |
| CANONICAL-COUNTS.md per-file Sum | 651 | ✓ |
| CANONICAL-COUNTS.md grand total text | 651 | ✓ (includes "+27 SOH-ATTACHMENTS-1" at head of enumeration) |
| prd-delta-576.md `bc_count_before` | 624 | ✓ |
| prd-delta-576.md `bc_count_after` | 651 | ✓ (delta = 27 = 12+14+1) |
| prd-delta-576.md `spec_version_after` | 1.3.44 | ✓ |

---

## Findings

### Critical

None.

### Major (HIGH)

None.

### Minor (MEDIUM)

None.

### Minor (LOW)

None.

### INFO

---

**NEW-R5-001 — INFO — BC-INDEX.md Coverage Statistics body-note enumeration ends at BC-X.1.011
(2026-07-09); missing +11 SOH-COMMENT-CRUD-1 and +27 SOH-ATTACHMENTS-1 entries**

**Location**: `BC-INDEX.md`, the `**Note**` paragraph in the Coverage Statistics section
(body, not frontmatter; approximately line 788).

**Finding**: The body-note enumeration in BC-INDEX.md Coverage Statistics ends at
"+1 BC-X.1.011 added 2026-07-09 via S-SOH-589 jr api --method case-insensitivity)."
It does not include:
- "+11 BC-3.5.002..BC-3.5.012 added 2026-07-09 via SOH-COMMENT-CRUD-1 F2 DEC-168 comment
  delete/edit/view issue #577"
- "+27 BC-2.7.001..012 + BC-3.9.001..014 + BC-X.8.010 added 2026-07-15 via
  SOH-ATTACHMENTS-1 F2 DEC-179 issues #576 #585"

The stated grand total (651) in the note IS correct. The BC-INDEX frontmatter
(`total_bcs: 651`) IS correct and does include both additions at the end of its comment
string. CANONICAL-COUNTS.md grand total paragraph IS correct and does include the +27
SOH-ATTACHMENTS-1 addition (appearing first in its reverse-chronological enumeration).

This gap is the "9th surface" explicitly documented in the process-gap note directly below
the enumeration paragraph: "The BC-INDEX Coverage Statistics body table (this section) is a
9th surface with no automated guard. Manual update required whenever BC counts change."

The SOH-COMMENT-CRUD-1 omission pre-dates this bundle; the SOH-ATTACHMENTS-1 omission is
this bundle's audit-trail responsibility.

**Impact**: No implementation decision or story authoring depends on this note. BC counts
are correct on all 8 scripted surfaces. Risk is limited to a future reviewer using the body
note enumeration as an audit trail without checking the frontmatter or CANONICAL-COUNTS.

**Action**: State-manager appends to the body-note enumeration at burst close:
`; +11 BC-3.5.002..BC-3.5.012 added 2026-07-09 via SOH-COMMENT-CRUD-1 F2 DEC-168 comment
delete/edit/view issue #577; +27 BC-2.7.001..012 + BC-3.9.001..014 + BC-X.8.010 added
2026-07-15 via SOH-ATTACHMENTS-1 F2 DEC-179 issues #576 #585).`

**Priority**: Burst-close (same class as NEW-R4-003; cosmetic; no blocking impact).

---

## Spec vs Implementation Drift

| Artifact | Spec Version | Implementation State | Drift Detected | Notes |
|----------|-------------|---------------------|----------------|-------|
| bc-2-issue-read.md §2.7 (BC-2.7.001..012) | 1.3.44 | Not yet implemented (pending S1/S2/S3) | None | All 12 BC bodies sourced to `src/cli/issue/attachments.rs (pending S1/S2)` — files do not yet exist in src/; this is expected at F2 spec phase |
| bc-3-issue-write.md §3.9 (BC-3.9.001..014) | 1.3.44 | Not yet implemented (pending S3/S4/S5) | None | All 14 BC bodies sourced to `src/cli/issue/attachments.rs` / `src/api/jira/attachments.rs` / `src/api/jsm/attachments.rs` — no implementation files exist yet |
| cross-cutting.md BC-X.8.010 | 1.3.44 | Not yet implemented (pending S5) | None | Sourced to `src/cache.rs (pending S5)` — new serviceDeskId cache type; pre-existing cache.rs exists but attachment cache entries not yet added |
| ADR-0017 | Accepted 2026-07-15 | Decision recorded; not yet built against | None | reqwest multipart + stream + tokio-util dep decision; Cargo.toml not yet updated |
| security-review-576.md | Final (APPROVE) | Findings applied to spec; not yet in implementation | None | SEC-576-001..007 reflected in BC bodies; implementation enforcement is a story-phase concern |
| prd-delta-576.md | 1.3.44 | Spec-level artifact; no implementation | None | All frontmatter counts correct |

**Summary**: No spec-vs-implementation drift is detectable at F2 spec phase. No implementation files for the attachment feature yet exist (expected — stories have not been authored). All BC Source citations are forward-referencing `(pending S1..S5)` where the file does not exist yet, consistent with F2 pre-implementation state. Drift tracking will become actionable at F3+ once story implementation begins.

---

## Validation Gate Result

**CONSISTENT** — 1 INFO finding (NEW-R5-001). 17 prior findings accounted for (16 RESOLVED,
1 EXPECTED-OPEN per documented deferral). No finding is blocking.

Story decomposition for SOH-ATTACHMENTS-1 may proceed. The one new INFO finding and the
expected-open NEW-R4-002 are both cosmetic documentation gaps to be resolved by the
state-manager at burst close.

**Recommended resolution at burst close (in priority order):**
1. **NEW-R4-002** — CANONICAL-COUNTS.md §ADRs: bump count 16 → 17; add ADR-0017 bullet;
   clarify factory-side vs product-repo ADR location convention. (Explicitly deferred to
   state-manager; now formally handed off.)
2. **NEW-R5-001** — BC-INDEX.md Coverage Statistics body-note: append the missing +11
   SOH-COMMENT-CRUD-1 and +27 SOH-ATTACHMENTS-1 enumeration entries.

---

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 20 (4 standard N/A; 16 ops-specific) |
| **Passed** | 15 |
| **Failed** | 0 (no blocking failures) |
| **Gaps Found** | 1 (NEW-R5-001 INFO) |
| **Expected Open** | 1 (NEW-R4-002 documented deferral) |
| **Prior Findings Closed** | 16 of 17 (CONS-576-001..007, NEW-001..005, NEW-R3-001..002, NEW-R4-001, NEW-R4-003); NEW-R4-002 EXPECTED-OPEN |
| **Overall Status** | CONSISTENT (1 cosmetic INFO item; no blocking gaps) |

---

## Positive Consistency Confirmations

**Security fixes (SEC-576-001..007) — independently verified all 7 present and correct** ✓

**DEC-179 rulings — all present in BC bodies** ✓

**BC counts on all 8 scripted surfaces — 651 consistent** ✓

**INCONCLUSIVE figures — correctly absent from BC-3.9.001 and ADR-0017; INCONCLUSIVE
language used in both (no hard-coded size cap)** ✓

**ADR-0017 — Accepted status; ARCH-INDEX.md and adr-index.md mutually consistent** ✓

**prd-delta-576.md — spec_version_after: 1.3.44 (NEW-R3-001); bc_count delta 27 = 12+14+1** ✓

**security-review-576.md — status: final, verdict: APPROVE; all 7 findings resolved** ✓

**impact-boundary-576.md — §R2.2 CONS-576-006 + §R2.3 NEW-005 retro-annotations both present** ✓

**spec-changelog [1.3.43] — ADR-0017 "Accepted 2026-07-15" with path (CONS-576-007 fix); count transitions correct (bc-2: 52→64/94→106; bc-3: 91→105/120→134; cross-cutting: 83→84/149→150)** ✓

**BC-3.9.005 canonical message — body (line 3332) and BC-INDEX row (line 377) both show full form; BC-3.9.012 error taxonomy table uses abbreviated form with `(BC-3.9.005)` pointer — intentional table brevity** ✓

**BC-3.9.014 eprint!/eprintln! distinction — body (line 3545) correctly specifies `eprint!` (NOT `eprintln!`); BC-INDEX row matches** ✓

**BC-3.9.007 (BC-2.7.007) cross-reference — NEW-R3-002 fix verified; line 3381 reads "(BC-2.7.007)" (not BC-2.7.005)** ✓

**bc-2 footer — "64 individually-bodied (cumulative 106 incl. range-collapsed…)" — NEW-R4-001 fix verified** ✓

**bc-3 footer history note — "Last updated 2026-07-15 (SOH-ATTACHMENTS-1 F2…)" present — NEW-R4-003 fix verified** ✓

**Source citations — zero stale `interactions.rs` residual in attachment BC scope (both bc-3 body and BC-INDEX Section 3.9 rows)** ✓

---

## Appendix: Validation Methodology

Round 5 used the same methodology as Rounds 1–4: fresh-context read of all surface-set
artifacts with no prior-round context loaded. Independent findings were formed before
consulting consistency-report-576-r1.md through consistency-report-576-r4.md. Prior reports
were used only to verify closure of all known findings.

**Checks performed:**

**(a) Design/research contradictions**: All DEC-179 rulings cross-referenced against BC text.
Research INCONCLUSIVE verdicts verified not hard-coded in BC bodies or ADR-0017.
Impact-boundary PHASE-DOC-RETRO-ANNOTATIONs verified present in §R2.2 and §R2.3. No
contradictions found.

**(b) Index-row vs body fidelity**: BC-INDEX section headers, row counts, Source columns, BC
ID ranges compared against BC bodies. All 27 new BC bodies (12 in §2.7, 14 in §3.9, 1 in
§X.8) confirmed present. BC-INDEX coverage statistics table cross-checked against actual
file counts. Body-note enumeration examined for completeness (→ NEW-R5-001).

**(c) Citation targets (grep-verify cross-references)**: All BC-to-BC cross-references in
attachment scope verified by grep. BC-3.9.007 `(BC-2.7.007)` confirmed correct (NEW-R3-002).
BC-2.7.011 cross-refs to BC-2.7.010 and BC-2.7.008 EC-2.7.008-2 verified. BC-3.9.005
canonical message in body vs BC-3.9.012 table examined (intentional abbreviated form; pointer
present — no finding).

**(d) INCONCLUSIVE-figure leaks**: BC-3.9.001 and ADR-0017 both confirmed INCONCLUSIVE for
size limits. No numeric cap in any BC body or ADR. P2-3c deferred-probe contracts in
BC-3.9.007/011 correctly marked INCONCLUSIVE.

**(e) Dangling IDs**: No finding IDs, BC IDs, or document references that resolve to
non-existent targets found in attachment scope.

**(f) Stale status markers**: security-review-576.md `status: final`, `verdict: APPROVE`
confirmed. All 7 SEC-576-NNN findings show `Status: **resolved**`. impact-boundary retro-
annotations confirmed present. spec-changelog [1.3.43] ADR reference correctly updated.

**(g) ADR factual claims**: ADR-0017 content independently verified against research file
for endpoint URL, size limit language, and redirect credential-stripping behavior. All match.

**(h) Footer / history notes**: bc-2-issue-read.md footer re-verified (correct 64/106 from
NEW-R4-001 fix). bc-3-issue-write.md footer history note re-verified (2026-07-15 entry
present from NEW-R4-003 fix). BC-INDEX body-note enumeration examined (→ NEW-R5-001).

**(i) CANONICAL-COUNTS.md surfaces**: Per-file table, grand total paragraph, BC-X.4.009
counting note, L2/L3 alignment table — all verified. ADR count section noted as
EXPECTED-OPEN (NEW-R4-002 deferral). Cache types section (item 8: serviceDeskId) correctly
reflects SOH-ATTACHMENTS-1 F2 addition.

**(j) prd-delta-576 self-consistency**: frontmatter counts, spec_version_after, BC scope
table (all 27 BCs accounted for: 6+6=12 in S2.7, 4+3+7=14 in S3.9, 1 in X.8), holdout
count (88 unchanged), worklog consistency with body files — all verified.

**(k) Prior-finding closure**: All 17 prior findings re-verified via direct artifact
inspection (not relying solely on worklog claims). Each of the 16 RESOLVED findings was
re-checked against the actual document text. NEW-R4-002 EXPECTED-OPEN status confirmed by
re-reading prd-delta-576.md ADR Reference note deferral language.
