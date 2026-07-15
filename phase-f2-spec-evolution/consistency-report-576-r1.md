---
document_type: consistency-report
level: ops
version: "1.0"
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
total_findings: 7
critical: 0
medium: 1
low: 5
info: 1
inputs:
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/cross-cutting.md"
  - ".factory/phase-f2-spec-evolution/security-review-576.md"
  - ".factory/phase-f1-delta-analysis/impact-boundary-576.md"
  - ".factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md"
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/specs/prd/CANONICAL-COUNTS.md"
  - ".factory/spec-changelog.md"
input-hash: "5a386ec"
traces_to: ".factory/phase-f2-spec-evolution/prd-delta-576.md"
---

# Consistency Report: SOH-ATTACHMENTS-1 F2 Spec Package (spec v1.3.44)

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) |
| **Generated** | 2026-07-15T00:00:00 |
| **Generator** | consistency-validator |
| **Artifacts Scanned** | 10 |
| **Spec Version** | v1.3.44 (post-security-fix state) |
| **Feature** | SOH-ATTACHMENTS-1 (issues #576 + #585) |
| **Gate** | DEC-179 F2 spec bundle |

**Review scope**: Fresh-context cross-document consistency check across the post-security-fix
spec bundle for SOH-ATTACHMENTS-1. Inputs reviewed: BC-2.7.001..012, BC-3.9.001..014,
BC-X.8.010 (bodies), prd-delta-576.md, security-review-576.md, impact-boundary-576.md
Revision 2, ADR-0017, BC-INDEX.md, CANONICAL-COUNTS.md, spec-changelog.md.

**Verdict: GAPS-FOUND** — 1 MEDIUM (implementer-visible algorithmic mismatch), 5 LOW
(source citation drift and stale-status documents), 1 INFO (cosmetic). No CRITICAL or HIGH
findings. The BC bodies themselves are internally consistent and correctly reflect all 7
security fixes. All DEC-179 design rulings are correctly implemented in BC text.

## Summary

| # | Check | Result |
|---|-------|--------|
| 1 | L2 to L3 Requirement Coverage | N/A (ops-level review; no L2 domain-spec in scope) |
| 2 | L3 to L4 Verification Property Coverage | N/A (no new VPs in this delta) |
| 3 | Dependency Acyclicity | N/A (no stories authored yet) |
| 4 | Architecture Alignment | GAPS-FOUND (CONS-576-002/003 — Source citations contradict F1 design) |
| 5 | Acceptance Criteria Quality | N/A (no stories authored yet) |
| 6 | Story Sizing (all <= 13 points) | N/A (no stories authored yet) |
| 7 | Priority Consistency | N/A (no stories authored yet) |
| 8 | L1 to L2 to L3 to L4 Chain Completeness | N/A (ops-level review) |
| 9 | AC Completeness Coverage | N/A (no stories authored yet) |
| 10 | ASM/R Traceability | N/A (no ASM/R artifacts in this bundle) |
| — | Security-fix drift (BC bodies vs security review) | GAPS-FOUND (CONS-576-001/005) |
| — | Index / count drift (BC-INDEX vs BC bodies) | GAPS-FOUND (CONS-576-001/004) |
| — | Ratified-design contradiction (within impact boundary) | GAPS-FOUND (CONS-576-006) |
| — | Twin-artifact drift (sec review status, changelog) | GAPS-FOUND (CONS-576-007) |

## 1. L2 to L3 Requirement Coverage

[TODO: populate this section per template]

This review is scoped to ops-level cross-document consistency of the SOH-ATTACHMENTS-1 F2
spec bundle. No L2 domain-spec artifact (CAP-NNN) is in the reviewed inputs; this check
does not apply to this review pass.

## 2. L3 to L4 Verification Property Coverage

[TODO: populate this section per template]

No new Verification Properties (VP-NNN) were added in this delta (prd-delta-576.md confirms
`VP count: 30 (unchanged)`). This check is not applicable to this review pass.

## 3. Dependency Acyclicity

[TODO: populate this section per template]

No stories have been authored for this bundle. This check applies at the story-decomposition
phase (F3). Not applicable to this F2 spec review.

## 4. Architecture Alignment

### 4.1 Module Coverage

| Architecture Component | BCs Targeting It | Source Citation (per BC) | F1 Design File | Match? |
|-----------------------|-----------------|------------------------|----------------|--------|
| `src/cli/issue/attachments.rs` (NEW) | BC-2.7.001..012 | `attachments.rs` (correct in 2.7 bodies) | NEW per F1 §1.1 | YES (2.7 bodies) |
| `src/cli/issue/attachments.rs` (NEW) | BC-3.9.001..014 | `interactions.rs` (WRONG in 3.9 bodies) | NEW per F1 §1.1 | NO — CONS-576-002 |
| `src/api/jira/attachments.rs` (NEW) | BC-3.9.001 | `issues.rs` (WRONG) | NEW per F1 §1.1 | NO — CONS-576-002 |
| `src/api/jsm/attachments.rs` (NEW) | BC-X.8.010 | `requests.rs` (WRONG) | NEW per F1 §R2.1 | NO — CONS-576-003 |
| `src/cache.rs` (TOUCHED) | BC-X.8.010 | `src/cache.rs` | TOUCHED per F1 §R2.1 | YES |

### 4.2 Component Consistency

BC-3.9.001/.002 Source fields cite `src/cli/issue/interactions.rs` and
`src/api/jira/issues.rs`. Both are existing files with different responsibilities:
`interactions.rs` handles comment CRUD (S-577-1..6); `issues.rs` handles issue
search/get/create/edit/comments. The F1 impact boundary (the authoritative design document)
classifies attachment CLI handlers and API functions as NEW files named `attachments.rs`.
Section 2.7 BCs correctly cite the new files; Section 3.9 BCs do not. See CONS-576-002/003.

## 5. Acceptance Criteria Quality

[TODO: populate this section per template]

No stories authored yet. This check will apply at F3 (story decomposition). Not applicable
to this F2 spec review.

## 6. Story Sizing

[TODO: populate this section per template]

No stories authored yet. Not applicable to this F2 spec review.

## 7. Priority Consistency

[TODO: populate this section per template]

No stories authored yet. Not applicable to this F2 spec review.

## 8. L1 to L2 to L3 to L4 Chain Completeness

[TODO: populate this section per template]

This ops-level review checks cross-document consistency within the F2 spec artifacts, not
L1→L4 chain completeness. That check applies at the full-spec validation gate.

## 9. AC Completeness Coverage

[TODO: populate this section per template]

No stories authored yet. Not applicable to this F2 spec review.

## 10. ASM/R Traceability

[TODO: populate this section per template]

No ASM/R (Assumption/Risk) artifacts are in the reviewed inputs for this bundle. Not
applicable to this review pass.

## Cross-Reference Validation

### ID Consistency

| Check | Status | Issues |
|-------|--------|--------|
| BC IDs unique (2.7.001..012, 3.9.001..014, X.8.010) | pass | No duplicates found |
| BC-INDEX row count vs BC body count (Section 2.7) | pass | 12 rows = 12 bodies |
| BC-INDEX row count vs BC body count (Section 3.9) | pass | 14 rows = 14 bodies |
| BC-INDEX row count vs BC body count (X.8) | pass | BC-X.8.010 present |
| Per-file frontmatter total_bcs vs CANONICAL-COUNTS | pass | All 8 files match |
| Grand total 651 consistent across BC-INDEX, CANONICAL-COUNTS, per-file sums | pass | 651 = 651 = 651 |
| Security findings SEC-576-001..007 applied in BC bodies | pass | All 7 verified present |

### Naming Convention Compliance

| Convention | Expected Pattern | Violations |
|-----------|-----------------|------------|
| BC naming (read) | BC-2.7.NNN | None — BC-2.7.001..012 all correctly formed |
| BC naming (write) | BC-3.9.NNN | None — BC-3.9.001..014 all correctly formed |
| BC naming (cross-cut) | BC-X.8.NNN | None — BC-X.8.010 correctly formed |
| Finding IDs | CONS-576-NNN | 7 findings: CONS-576-001..007 |

### Canonical Frontmatter Validation

| Artifact | document_type | level | version | producer | traces_to | Status |
|----------|--------------|-------|---------|----------|-----------|--------|
| prd-delta-576.md | prd-delta | — | — | — | — | Proprietary frontmatter; pass |
| security-review-576.md | security-review | ops | "1.0" | security-reviewer | present | pass (but status: draft not updated — CONS-576-005) |
| impact-boundary-576.md | — | — | — | — | — | No standard frontmatter; pass |
| ADR-0017 | adr | — | — | — | — | Accepted; conforms to ADR template |
| BC-INDEX.md | — | — | — | — | — | Non-standard (bc-index); conforms |

## Spec vs Implementation Drift

| Artifact | Spec Version | Implementation State | Drift Detected | Notes |
|----------|-------------|---------------------|---------------|-------|
| bc-2-issue-read.md §BC-2.7.011 body | v1.3.44 | PENDING (S2) | NO (body is correct) | All SEC-576 fixes present |
| BC-INDEX.md row for BC-2.7.011 | v1.3.43 state (not updated) | — | YES (CONS-576-001) | Char scrub, length cap, containment check all stale |
| bc-3-issue-write.md §BC-3.9.001 Source | v1.3.43 | PENDING (S3) | YES (CONS-576-002) | Source cites interactions.rs / issues.rs; should be attachments.rs |
| cross-cutting.md §BC-X.8.010 Source | v1.3.43 | PENDING (S5) | YES (CONS-576-003) | Source cites requests.rs; should be jsm/attachments.rs |
| BC-INDEX.md Source column §2.7 rows | v1.3.43 | — | YES (CONS-576-004) | All rows cite interactions.rs; BC bodies cite attachments.rs |
| security-review-576.md status | v1.3.43 state | SPEC-CHANGES applied in v1.3.44 | YES (CONS-576-005) | status: draft; verdict: SPEC-CHANGES-REQUIRED not updated post-fix |
| impact-boundary-576.md §R2.2 | R2 | Superseded by OQ-9 in same doc | YES (CONS-576-006) | R2.2 says --internal non-JSM = exit 64; OQ-9 says silent no-op |
| spec-changelog.md §[1.3.43] | v1.3.43 | ADR-0017 exists as Accepted | YES (CONS-576-007) | Says "ADR-0017 planned"; ADR already exists and Accepted |

## Findings

### Critical

None.

### Major (MEDIUM)

**CONS-576-001** — BC-INDEX row for BC-2.7.011 not updated post-v1.3.44 security fixes.

The BC-INDEX row description contains the wrong sanitization algorithm (`[^a-zA-Z0-9._-]`→`_`
vs the actual step-4 scrub of only `/`, `\`, `:`), the wrong length cap (200 chars vs 255 bytes),
and the pre-fix containment check description (generic canonicalize vs the SEC-576-002 two-step
procedure). An implementer reading BC-INDEX instead of the BC body will implement a materially
different security control. See **Detailed Finding Descriptions** below.

### Minor (LOW / INFO)

**CONS-576-002** — Section 3.9 BC bodies cite `interactions.rs` / `issues.rs`; F1 design
specifies `attachments.rs` for both CLI handler and API module. Sections 2.7 and 3.9 are
mutually inconsistent on source file citations.

**CONS-576-003** — BC-X.8.010 Source cites `src/api/jsm/requests.rs::attach_temporary_file`;
F1 impact boundary R2.1 places this function in `src/api/jsm/attachments.rs` (NEW file).

**CONS-576-004** — BC-INDEX Source column for all Section 2.7 rows says `interactions.rs`;
BC-2.7.x bodies say `attachments.rs`. BC-INDEX was not updated to match the bodies.

**CONS-576-005** — security-review-576.md retains `status: draft`, `verdict: SPEC-CHANGES-REQUIRED`,
and all 7 findings marked "open" after prd-delta-576.md records all 7 as APPLIED.

**CONS-576-006** — impact-boundary-576.md §R2.2 says `--internal` on non-JSM = exit 64;
§OQ-9 (later in same doc) says silent no-op. BCs correctly implement OQ-9; R2.2 was not
annotated as superseded.

**CONS-576-007** (INFO) — spec-changelog [1.3.43] says "ADR-0017 planned" but ADR-0017
exists as Accepted on the same date.

---

## Detailed Finding Descriptions

### CONS-576-001 — MEDIUM — BC-INDEX row for BC-2.7.011 not updated post-v1.3.44

**Artifacts**: `BC-INDEX.md` row for BC-2.7.011 (line ~230) vs `bc-2-issue-read.md` §BC-2.7.011 body.

The BC-INDEX row description reads:

> "5-step algorithm (basename extraction, pseudo-name `.`/`..` reject, NUL byte reject, char scrub `[^a-zA-Z0-9._-]`→`_`, length cap **200 chars**); containment check (**resolved path must be under out-dir**); naive blacklist INSUFFICIENT — **only `..` traversal matters**"

The BC-2.7.011 body (as of v1.3.44) says:

1. **Char scrub (step 4)**: "replace any remaining `/`, `\`, or `:` in the string with `_`" — only three specific characters, not a broad `[^a-zA-Z0-9._-]` replacement.
2. **Length cap (step 5)**: "truncate to a maximum of **255 bytes**" — not 200.
3. **Step 5.5 (SEC-576-007)**: trailing whitespace/dot strip — absent from BC-INDEX row.
4. **Containment check (SEC-576-002)**: the body now mandates the two-step procedure (`canonicalize(out_dir)` then `starts_with`) and explicitly warns against calling `canonicalize()` on the joined path. The BC-INDEX still says the old "resolved path must be under out-dir" text which is the pre-fix description.
5. **"only `..` traversal matters"**: the body says "Naive blacklist approaches are INSUFFICIENT: do NOT rely on string-stripping `../` patterns alone — such blacklists are bypassable." The BC-INDEX mischaracterizes this as "only `..` traversal matters."

The BC-INDEX row was updated at v1.3.43 (BC creation) but was not touched during the v1.3.44 security-fix pass. The BC body is authoritative; the BC-INDEX summary is misleading on all five points above. The char-scrub and length-cap discrepancies are the most load-bearing: an implementer reading BC-INDEX will implement a broader scrub and a shorter cap than the BC specifies.

**Also**: the BC-INDEX Source column for BC-2.7.011 says `src/cli/issue/interactions.rs (pending S2)`. The BC body says `src/cli/issue/attachments.rs::sanitize_attachment_filename`. This overlaps with CONS-576-004.

---

### CONS-576-002 — LOW — Section 3.9 BC bodies cite wrong CLI handler and API module files

**Artifacts**: `bc-3-issue-write.md` BC-3.9.001 (and BC-3.9.002) Source fields vs `impact-boundary-576.md` §1.1 classification table.

BC-3.9.001 Source:
```
src/cli/issue/interactions.rs::handle_attachment_upload (implementation pending — story S3)
src/api/jira/issues.rs::upload_attachments (implementation pending — story S3)
```

F1 impact boundary §1.1 classification:
- `src/cli/issue/attachments.rs` — **NEW** (handler functions for all attachment operations)
- `src/api/jira/attachments.rs` — **NEW** (four HTTP call implementations)

`interactions.rs` is the comment CRUD handler (`handle_comment_add`, `handle_comment_delete`, `handle_comment_edit`, `handle_comment_view` — S-577-1..6). Placing attachment handlers there contradicts both the F1 design and CLAUDE.md's description of `interactions.rs`.

`issues.rs` exists but is the search/get/create/edit/list-comments module. The F1 design creates a dedicated `attachments.rs` API module. BC-3.9.001's `issues.rs::upload_attachments` citation does not match any planned function per the F1 design.

Section 2.7 BCs correctly cite `attachments.rs`. The discrepancy between Section 2.7 and Section 3.9 source citations makes Section 3.9 the odd-one-out.

Note: ADR-0017 §Consequences mentions "set at the call site in `src/api/jira/issues.rs` (or a new `attachments.rs`)" — the ADR reflected uncertainty at time of writing. The F1 impact boundary classification table (authoritative) resolves this to `attachments.rs`.

---

### CONS-576-003 — LOW — BC-X.8.010 Source cites `requests.rs` for `attach_temporary_file`

**Artifacts**: `cross-cutting.md` BC-X.8.010 Source field vs `impact-boundary-576.md` §R2.1.

BC-X.8.010 Source:
```
src/api/jsm/requests.rs::attach_temporary_file (implementation pending — story S5)
```

F1 impact boundary R2.1 creates `src/api/jsm/attachments.rs` (NEW) to house `attach_temporary_file` and `attach_to_request`. `src/api/jsm/requests.rs` exists but handles JSM request creation (`handle_jsm_create` path per ADR-0014/CLAUDE.md). Citing `attach_temporary_file` under `requests.rs` contradicts the F1 classification and CLAUDE.md's description of the existing module.

---

### CONS-576-004 — LOW — BC-INDEX Source column for all Section 2.7 rows says `interactions.rs`

**Artifacts**: `BC-INDEX.md` Section 2.7 rows vs `bc-2-issue-read.md` BC-2.7.x bodies.

All twelve Section 2.7 rows in BC-INDEX (BC-2.7.001 through BC-2.7.012) show
`src/cli/issue/interactions.rs (pending S1)` or `(pending S2)` in the Source column.

The BC-2.7.x bodies consistently cite `src/cli/issue/attachments.rs::handle_attachment_list`,
`src/cli/issue/attachments.rs::handle_attachment_download`, and
`src/cli/issue/attachments.rs::sanitize_attachment_filename`. The BC-INDEX was not updated
to match the BC bodies (or the BC-INDEX was generated with the wrong template before the
bodies were finalized).

---

### CONS-576-005 — LOW — security-review-576.md status not updated post-v1.3.44 fix application

**Artifacts**: `security-review-576.md` status/verdict/finding status vs `prd-delta-576.md` §Security Review Finding Dispositions.

The security review document retains its original draft state:
- `status: draft`
- `verdict: SPEC-CHANGES-REQUIRED`
- All 7 findings show `"open — spec change required before S2/S3/S5"`

After the v1.3.44 fix round, prd-delta-576.md records all 7 as `APPLIED`. The actual BC text changes are present and correct (verified during this review). The gap is that security-review-576.md was never updated to reflect `status: closed`, `verdict: APPLIED`, and per-finding status changes. Any future reviewer opening the security review document sees a misleading "open" status on all items.

---

### CONS-576-006 — LOW — impact-boundary-576.md §R2.2 contradicts §OQ-9 in same document

**Artifacts**: `impact-boundary-576.md` §R2.2 (line ~454) vs §OQ-9 (line ~591); `bc-3-issue-write.md` BC-3.9.004.

§R2.2 (the design model section) states:
> "`--public` or `--internal` on a non-JSM issue → exit 64 with clear message: `--public/--internal` requires a Jira Service Management project"

§OQ-9 (the ratified open-questions section, labelled "RATIFIED 2026-07-15") states:
> "**RATIFIED 2026-07-15** — silent no-op; rationale: a non-JSM issue has no customer portal, so the attachment is already internal by nature."

OQ-9 supersedes R2.2 for `--internal` on non-JSM. BC-3.9.004 correctly implements OQ-9 ("Non-JSM silent no-op"). The BCs are correct. The issue is that §R2.2 in the impact boundary was not struck through or annotated to note the supersession by OQ-9, leaving an apparent contradiction within the same document. Anyone reading R2.2 without reaching OQ-9 will believe `--internal` on non-JSM should exit 64.

---

### CONS-576-007 — INFO — spec-changelog [1.3.43] says "ADR-0017 planned" but ADR-0017 is Accepted

**Artifacts**: `spec-changelog.md` §[1.3.43] Impact Assessment vs `.factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md`.

The [1.3.43] entry Impact Assessment table says:
> `ADR reference | DEC-179 (F1 gate approval); ADR-0017 planned (attachment feature design decisions)`

ADR-0017 exists on disk with `status: Accepted` and `date: 2026-07-15` — created in the same burst as the BC additions. The word "planned" is inaccurate; the ADR was created and accepted in the same burst. No functional consequence; cosmetic only.

---

## Positive Consistency Confirmations

The following were checked and found consistent:

- **All 7 security fixes applied correctly in BC bodies**: SEC-576-001 caller note present in BC-2.7.011; SEC-576-002 two-step procedure present in BC-2.7.011; SEC-576-003 EC-2.7.007-3 present in BC-2.7.007; SEC-576-004 multipart encoding note present in BC-3.9.001; SEC-576-005 EC-3.9.001-5 present in BC-3.9.001 AND parallel note present in BC-3.9.003 Step 1; SEC-576-006 stale-ID self-healing clause (4-step procedure) present in BC-X.8.010; SEC-576-007 step 5.5 trailing-whitespace/dot strip present in BC-2.7.011.

- **DEC-179 design rulings vs BC bodies**: All ratified rulings are correctly reflected. Platform-POST default (BC-3.9.001/BC-3.9.002). `--internal` non-JSM = silent no-op / OQ-9 (BC-3.9.004 EC-3.9.004-1). `--public` non-JSM = exit 64 (BC-3.9.005). DEC-174 eprint!+read_line confirmation gate, NOT dialoguer (BC-3.9.014). DEC-168 delete 404 = exit 64 (BC-3.9.008). JSDCLOUD-10841 platform endpoint for downloads (BC-2.7.007). JRACLOUD-97046 no `?redirect=false` (BC-2.7.007). P2-4a internal-by-default (BC-3.9.002). JRACLOUD-96384 match-by-id (BC-2.7.012).

- **BC counts consistent**: CANONICAL-COUNTS.md sum (651) matches BC-INDEX.md `total_bcs` (651) matches sum of per-file frontmatter values (106+134+150+57+32+36+43+93 = 651). Per-file definitional_count values match CANONICAL-COUNTS table. Section 2.7 (12 BCs), Section 3.9 (14 BCs), BC-X.8.010 (1 BC) = 27 new individually-bodied BCs. 624 + 27 = 651.

- **spec-changelog entries vs actual BC changes**: Both [1.3.43] and [1.3.44] entries accurately describe the BC bodies modified and the changes made in each version.

- **Research facts cited by BCs match research document verdicts**: P2-4a (platform POST internal by default) = VERIFIED HIGH in research. JRACLOUD-97046 (no redirect=false) = VERIFIED. JSDCLOUD-10841 (broken links.content) = VERIFIED. GHSA-9857-6MW7-FQ2M (reqwest strips auth on redirect) = VERIFIED. P2-3c (servicedeskapi response schema) = INCONCLUSIVE — correctly marked deferred in BC-3.9.007/BC-3.9.011. P2-8 (cargo deny clean) = VERIFIED.

- **BC-X.8.010 model-b writer pattern**: Correctly follows precedent — swallow disk-write errors with `eprintln!("warning: …")`, return `Ok(())`. Consistent with `write_cmdb_fields_cache` and `write_object_type_attr_cache` patterns per CLAUDE.md.

- **BC-INDEX Section and subsection headers**: Section 2.7 header "(12 BCs: BC-2.7.001..012)" matches 12 bodies. Section 3.9 header "(14 BCs: BC-3.9.001..BC-3.9.014)" matches 14 bodies. BC-X.8.010 in X.8 header "(10 BCs: BC-X.8.001..010)". All consistent.

- **OQ-9 / BC-3.9.004 consistency**: BC-3.9.004 correctly implements OQ-9 (silent no-op for `--internal` on non-JSM). EC-3.9.004-1 explicitly states no servicedeskapi calls on non-JSM.

- **Holdout count**: prd-delta `holdout_count_after: 88` = CANONICAL-COUNTS holdout total 88. Unchanged by F2 additions, consistent.

- **ADR-0017 content vs F1 design**: ADR-0017 decisions (reqwest multipart + stream + tokio-util direct dep) are consistent with F1 impact boundary §R2.4 Cargo.toml additions. ADR-0017 correctly defers Cargo.toml edits to Story 3.

## Validation Gate Result

**GAPS-FOUND** — 1 MEDIUM finding requires PO attention before story authoring (CONS-576-001:
BC-INDEX row for BC-2.7.011 describes the wrong sanitization algorithm; the story writer will
read BC-INDEX and implement a different char scrub and length cap than the BC body specifies).

Blocking before story decomposition: CONS-576-001.

Non-blocking tracked items: CONS-576-002, CONS-576-003, CONS-576-004 (source citation drift —
correct before S1 story authoring to avoid story file list errors). CONS-576-005, CONS-576-006,
CONS-576-007 are documentation hygiene items.

No fixes applied in this report. All corrections delegated to the spec author (PO).

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 14 (4 standard N/A; 10 ops-specific) |
| **Passed** | 7 (security fixes, counts, DEC-179 rulings, research facts) |
| **Failed** | 0 |
| **Gaps Found** | 7 |
| **Warnings** | 0 |
| **Overall Status** | GAPS-FOUND |

7 gaps found across the 10 reviewed artifacts. The BC bodies are the authoritative specification
and are correctly formed. Gaps are in summary/index documents (BC-INDEX) and stale status
fields in process artifacts (security-review, impact boundary). The BC bodies themselves are
spec-complete and correctly implement all DEC-179 rulings and SEC-576-001..007 security fixes.

Recommended resolution order: (1) CONS-576-001 (BC-INDEX row for BC-2.7.011) before story
decomposition; (2) CONS-576-002/003/004 (source citations) before story file-list authoring;
(3) CONS-576-005/006/007 (document housekeeping) at burst close.

## Appendix: Validation Methodology

This consistency report was produced by a fresh-context cross-document consistency validation
pass with no prior context on the SOH-ATTACHMENTS-1 bundle. The validator read all 10 input
artifacts in full and checked the following classes:

- **(a) Contradiction between BC bodies and the ratified design**: each DEC-179 ruling was
  cross-referenced against the relevant BC body text.
- **(b) Security-fix drift**: each SEC-576-001..007 finding in security-review-576.md was
  verified as APPLIED by confirming the specific text change is present in the relevant BC body.
- **(c) Cross-BC contradictions**: inter-BC references and interplay (e.g., BC-2.7.010 naming
  vs BC-2.7.011 sanitization; BC-3.9.004 no-op vs BC-3.9.002 platform-default) were checked.
- **(d) Index/count drift**: BC-INDEX section headers, row descriptions, Source citations, and
  counts were compared against CANONICAL-COUNTS.md and per-file frontmatter.
- **(e) Dangling references**: Source field file citations were cross-checked against the F1
  impact boundary classification table (the authoritative file-design document).
- **(f) Twin-artifact drift**: prd-delta finding disposition table was compared against
  security-review verdict/finding status; spec-changelog ADR claims were compared against
  the ADR file on disk.

Research wire facts (P2-4a, JSDCLOUD-10841, JRACLOUD-97046, GHSA-9857-6MW7-FQ2M, P2-3c,
P2-8) were verified against `issue-576-attachments-api-2026-07-15.md` research verdicts.

BC counts were verified by cross-referencing per-file frontmatter, BC-INDEX header claims,
and CANONICAL-COUNTS.md sum row.

No implementation code was reviewed — this is a spec-level consistency pass only. All
findings are spec/documentation gaps; no implementation defects are reported here.
