---
report: consistency-report-576-r7
feature: SOH-ATTACHMENTS-1
spec_version: v1.3.45
bc_count: 657
holdout_count: 95
round: R7
date: 2026-07-15
validator: vsdd-factory:consistency-validator (fresh context, no prior round memory)
verdict: GAPS-FOUND
new_finding_count: 4
new_finding_severity_breakdown: "LOW×2, INFO×2"
r6_closure: all_5_resolved
cons_576_001_spot_check: REMAINS_RESOLVED
---

# SOH-ATTACHMENTS-1 F2 Consistency Report — Round R7

**Verdict: GAPS-FOUND** — 2 LOW + 2 INFO new findings. No CRITICAL, HIGH, or MEDIUM findings. All R6 items confirmed resolved. CONS-576-001 (BC-2.7.011 algorithm fidelity, the R1 MEDIUM) remains resolved.

---

## 1. Scope

Fresh-context round-7 pass over the full SOH-ATTACHMENTS-1 F2 spec package at spec version 1.3.45 (657 BCs, 95 holdouts), post R6-polish. The validator formed independent findings before reading the R6 report. After forming independent findings, the R6 report was read solely to (a) confirm closure of NEW-R6-001..005, and (b) spot-check no regression of the R1 MEDIUM (CONS-576-001).

### Surface set checked

| # | Surface | Freshly read? |
|---|---------|---------------|
| S1 | `.factory/specs/prd/bc-2-issue-read.md` (Section 2.7) | YES |
| S2 | `.factory/specs/prd/bc-3-issue-write.md` (Section 3.9) | YES |
| S3 | `.factory/specs/prd/cross-cutting.md` (Section X.8) | YES |
| S4 | `.factory/specs/prd/BC-INDEX.md` | YES |
| S5 | `.factory/specs/prd/CANONICAL-COUNTS.md` | YES |
| S6 | `.factory/specs/prd/holdout-scenarios.md` (Group 19) | YES |
| S7 | `.factory/spec-changelog.md` (v1.3.44..1.3.45) | YES |
| S8 | `.factory/phase-f2-spec-evolution/prd-delta-576.md` | YES |
| S9 | `.factory/phase-f2-spec-evolution/prd-delta-576-worklog.md` | YES |
| S10 | `.factory/phase-f2-spec-evolution/security-review-576.md` | YES |
| S11 | `.factory/phase-f1-delta-analysis/impact-boundary-576.md` (§1.1) | YES |
| S12 | `.factory/specs/architecture/decisions/ADR-0017-*.md` | YES |
| S13 | `.factory/specs/architecture/ARCH-INDEX.md` | YES |
| S14 | `.factory/architecture/adr-index.md` | YES |
| S15 | `.factory/phase-f2-spec-evolution/consistency-report-576-r6.md` | YES (post-independent-findings) |

---

## 2. New Findings (R7)

### FINDING-R7-001 — LOW
**File:** `.factory/specs/prd/CANONICAL-COUNTS.md`
**Location:** Line 30 (per-file individually-bodied table, Total row)
**Description:** The "Total individually-bodied" table row says **421**. The actual sum of the per-file `#### BC-` counts in the same table is 46+64+111+22+18+33+49+84 = **427**. The per-file rows are all correct (bc-3-issue-write.md row correctly shows 111). The table total was not updated when Round B (adversary pass-1, 2026-07-15) added BC-3.9.015..020 to bc-3-issue-write.md, raising the definitional count from 105→111.

**Cross-check:** The inconsistency is internal to CANONICAL-COUNTS.md:
- Line 30 (table total): **421** ← STALE
- Line 61 (breakdown text): "427 of 657 are individually-bodied" ← CORRECT
- BC-INDEX.md Coverage Statistics (line 792): `| **Total** | **657** | **427** |` ← CORRECT

**Root cause:** The worklog Round C entry lists what was updated in CANONICAL-COUNTS.md: "bc-3 definitional 105→111, total 134→140; Sum 651→657; grand total 651→657; L2 alignment row; last_verified". The "Total individually-bodied" table row (line 30) is not in this list — it was missed in the update pass.

**Action required:** Update CANONICAL-COUNTS.md line 30 to `| **Total individually-bodied** | **427** | — | — |`.

---

### FINDING-R7-002 — LOW
**File:** `.factory/specs/prd/CANONICAL-COUNTS.md`
**Location:** Lines 111 and 129 (Holdout Scenarios section)
**Description:** The holdout section header says "**Canonical holdout total: 88**" and the reconciliation footnote says "frontmatter `total_holdouts: 88`" and "Last reconciled: 2026-07-10 (adversary pass-18 F6; +H-NEW-COMMENT-005 delete confirmation gate)." The actual holdout-scenarios.md frontmatter shows `total_holdouts: 95` and the spec-changelog entry [1.3.45] confirms "+7 holdouts H-NEW-ATTACHMENT-001..007 added (88→95)". Group 19 is fully present in holdout-scenarios.md but CANONICAL-COUNTS.md holdout section was never updated to reflect it.

**Note on prior round:** The R6 report §4.3 stated "CANONICAL-COUNTS.md Group count enumeration includes Group 19. ✓" — this claim is a false positive. Reading CANONICAL-COUNTS.md lines 111-129 directly confirms the section still says 88 and lists groups only through Group 15 (Comment CRUD, +5), with no mention of Group 19 or H-NEW-ATTACHMENT-001..007.

**Action required:**
1. Update line 111: `**Canonical holdout total: 95**`
2. Add Group 19 entry to the group enumeration (H-NEW-ATTACHMENT-001..007, +7, SOH-ATTACHMENTS-1 adversary pass-1 round A+B, 2026-07-15)
3. Update the reconciliation footnote to reflect last_reconciled: 2026-07-15 and `total_holdouts: 95`

---

### FINDING-R7-003 — INFO
**File:** `.factory/specs/prd/CANONICAL-COUNTS.md`
**Location:** Lines 64–65 (BC-X.4.009 counting note)
**Description:** The BC-X.4.009 note body says:
- Line 64: "included in cross-cutting's `total_bcs: 150` and in the **651 sum**."
- Line 65: "It does NOT add +1 beyond the **650**."

These reference 651 and 650, which were the correct values before Round B (+6 BCs, 651→657). The parenthetical on line 66 acknowledges the transition ("was 651 before round B; 657 total after +6 BCs BC-3.9.015..020") but the main text lines 64–65 were not updated. A reader hitting lines 64–65 before the parenthetical sees a number (651) that disagrees with the Sum row (657).

**Action required:** Update lines 64–65 to reference 657 and 656 respectively, or fold the parenthetical into the main text so the note is internally consistent.

---

### FINDING-R7-004 — INFO
**File:** `.factory/specs/prd/BC-INDEX.md`
**Location:** Line 794 (Coverage Statistics body-note, SOH-COMMENT-CRUD-1 entry)
**Description:** The body-note says "+11 SOH-COMMENT-CRUD-1 added **2026-07-11..14** via DEC-168 comment delete/edit/view issue #577". This date contradicts two authoritative sources:
- BC-INDEX.md frontmatter (line 4): "+11 added **2026-07-09** (BC-3.5.002..BC-3.5.012, SOH-COMMENT-CRUD-1 F2 DEC-168 comment delete/edit/view issue #577)"
- CANONICAL-COUNTS.md Grand total note: "+11 BC-3.5.002..BC-3.5.012 added **2026-07-09** via SOH-COMMENT-CRUD-1 F2 DEC-168 comment delete/edit/view + CLI subcommand group issue #577"

The body-note entry was added in Round R5 (closing NEW-R5-001: missing SOH-COMMENT-CRUD-1 row in the body table) with the wrong date "2026-07-11..14" instead of the canonical "2026-07-09".

**Action required:** Update BC-INDEX.md line 794 body-note to say "added **2026-07-09**" for the SOH-COMMENT-CRUD-1 entry.

---

## 3. R6 Closure Table

| Finding | Severity | R6 Description | Closure Status | Verification method |
|---------|----------|----------------|----------------|---------------------|
| NEW-R6-001 | LOW | Section 3.9 header said "(14 BCs: BC-3.9.001..BC-3.9.014)"; needed updating to "(20 BCs: BC-3.9.001..BC-3.9.020)" | **RESOLVED** | bc-3-issue-write.md: `### 3.9 Attachment Write (20 BCs: BC-3.9.001..BC-3.9.020)` confirmed ✓ |
| NEW-R6-002 | LOW | JSON Output Shape Contracts table missing cancel-delete and dry-run rows | **RESOLVED** | bc-3-issue-write.md Contracts table now includes `attachment delete (cancel / --no)` → `{"cancelled":true,"deleted":false}` and `attachment delete --dry-run (preview)` → `{"attachments":[...],"dryRun":true,"ids":[...]}` ✓ |
| NEW-R6-003 | LOW | BC-3.9.019/020 JSON output shapes not in BTreeMap alphabetical order | **RESOLVED** | BC-3.9.019 body: `{"count": N, "deleted": true, "ids": [...]}` (c<d<i ✓); BC-3.9.020 body: `{"attachments": [...], "dryRun": true, "ids": [...]}` (a<d<i ✓); all EC-3.9.019/020 example shapes likewise alphabetical ✓ |
| NEW-R6-004 | LOW | Exit-code ambiguity for `--older-than` without `--issue`: some ECs said 64, needed clarification as exit 2 (clap `requires`) | **RESOLVED** | BC-3.9.016 body + EC-3.9.016-5: "exit 2 (clap `requires` constraint)"; BC-3.9.019 body + EC-3.9.019-4: "exit 2 (clap `requires` constraint); mirrors EC-3.9.016-5" ✓ |
| NEW-R6-005 | INFO | impact-boundary-576.md §1.1 function table missing `get_attachment_metadata` | **DEFERRED — INFO/non-blocking** | Explicitly deferred as a story S4 authoring note; read-only artifact; no spec change made. §1.1 still shows 4 functions for `src/api/jira/attachments.rs`. Expected-open state for INFO. |

---

## 4. CONS-576-001 Spot-Check (BC-2.7.011 Algorithm Fidelity — R1 MEDIUM)

**Result: REMAINS RESOLVED**

BC-2.7.011 (CWE-22 path-traversal sanitization) independently verified to contain the full 5.5-step algorithm with all load-bearing details:

| Step | Detail | Status |
|------|--------|--------|
| Step 1 | Replace `\`, `/`, `:`, `*`, `?`, `"`, `<`, `>`, \| with `_` (Windows-forbidden + path-separator) | Present ✓ |
| Step 2 | Replace NUL and ASCII control chars (0x00–0x1F, 0x7F) with `_` | Present ✓ |
| Step 3 | Replace leading/trailing `.` or space with `_` | Present ✓ |
| Step 4 | UTF-8-safe truncation at 214 bytes (= 255 − 1 path-separator − 40 SHA-1 hex digits) | Present ✓ |
| Step 5 | Windows reserved device-name prefix guard (CON, PRN, AUX, NUL, COM1–COM9, LPT1–LPT9; case-insensitive; strip suffix at dot) | Present ✓ |
| Step 5.5 | Strip trailing whitespace and trailing dots (NTFS behaviour; Windows-only silent truncation) | Present ✓ |
| Step 6 | Two-step canonicalize containment: (a) expand symlinks on the proposed `--out-dir/<safe-name>` path, (b) verify the result still has `--out-dir` (after symlink expansion) as a strict prefix | Present ✓ |

---

## 5. Count Surface Verification (full pass)

| Surface | Checked value | Status |
|---------|--------------|--------|
| bc-2-issue-read.md frontmatter `total_bcs` | 106 | ✓ |
| bc-2-issue-read.md frontmatter `definitional_count` | 64 | ✓ |
| bc-3-issue-write.md frontmatter `total_bcs` | 140 | ✓ |
| bc-3-issue-write.md frontmatter `definitional_count` | 111 | ✓ |
| BC-INDEX.md frontmatter `total_bcs` | 657 | ✓ |
| BC-INDEX.md Section 2.7 header count | "(12 BCs: BC-2.7.001..012)" | ✓ |
| BC-INDEX.md Section 3.9 header count | "(20 BCs: BC-3.9.001..020)" | ✓ |
| BC-INDEX.md Section X.8 header count | "(10 BCs: BC-X.8.001..010)" | ✓ |
| BC-INDEX.md Coverage Statistics Total row | 657 / 427 | ✓ |
| BC-INDEX.md Coverage Statistics body-note date (SOH-COMMENT-CRUD-1) | "2026-07-11..14" | GAP (FINDING-R7-004 — INFO) |
| CANONICAL-COUNTS.md per-file total_bcs Sum | 657 | ✓ |
| CANONICAL-COUNTS.md Grand total | 657 | ✓ |
| CANONICAL-COUNTS.md breakdown "427 of 657" | 427 | ✓ |
| CANONICAL-COUNTS.md "Total individually-bodied" table row | **421** | GAP (FINDING-R7-001 — LOW) |
| CANONICAL-COUNTS.md holdout section total | **88** | GAP (FINDING-R7-002 — LOW) |
| CANONICAL-COUNTS.md BC-X.4.009 note inline values | **651, 650** | GAP (FINDING-R7-003 — INFO) |
| holdout-scenarios.md frontmatter `total_holdouts` | 95 | ✓ |
| holdout-scenarios.md Group 19 (H-NEW-ATTACHMENT-001..007) | 7 scenarios present | ✓ |
| prd-delta-576.md frontmatter bc_count_after / holdout_count_after | 657 / 95 | ✓ |
| spec-changelog.md [1.3.45] bc/holdout deltas | 651→657 / 88→95 | ✓ |
| ADR-0017 status | Accepted 2026-07-15 | ✓ |
| ARCH-INDEX.md ADR-0017 entry | Present ✓ | ✓ |
| adr-index.md ADR-0017 entry | Present (Accepted 2026-07-15; gate DEC-179 item 7) | ✓ |

---

## 6. Prior-Round Regression Check

All 18 prior-round findings (R1 MEDIUM CONS-576-001, NEW-R2-001..003, NEW-R3-001..004, NEW-R4-001..004, NEW-R5-001..003, plus R1/R2/R3 original items) were confirmed RESOLVED in R6 and show no regression signs in R7 reading. No regressions detected.

---

## 7. Summary

**Verdict: GAPS-FOUND** (2 LOW, 2 INFO). No CRITICAL, HIGH, or MEDIUM findings.

All 4 new findings are localized to CANONICAL-COUNTS.md (three findings) and BC-INDEX.md (one finding). None affect the behavioral contracts in bc-2-issue-read.md, bc-3-issue-write.md, cross-cutting.md, holdout-scenarios.md, or any of the security/architecture artifacts. The spec package is implementation-ready at spec v1.3.45; the gaps are metadata/housekeeping inconsistencies that should be fixed before the next formal spec version bump.

| Severity | Count | Blocking implementation? |
|----------|-------|--------------------------|
| CRITICAL | 0 | N/A |
| HIGH | 0 | N/A |
| MEDIUM | 0 | N/A |
| LOW | 2 | No (metadata only) |
| INFO | 2 | No (cosmetic/date annotation) |

**Recommended action:** Apply a R7-polish pass (worklog sub-burst "Round R7 Polish") to close FINDING-R7-001 and FINDING-R7-002 (both LOW); update FINDING-R7-003 and FINDING-R7-004 in the same pass. No spec version bump required for these housekeeping fixes unless the project convention requires it. Run `scripts/check-bc-cumulative-counts.sh` after to confirm the 8 guarded surfaces pass.
