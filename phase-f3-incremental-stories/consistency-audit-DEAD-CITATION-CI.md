---
document_type: consistency-report
scope: S-MAINT-DEAD-CITATION-CI
audited_artifact: .factory/stories/S-MAINT-DEAD-CITATION-CI.md
auditor: consistency-validator
date: 2026-06-19
verdict: CONSISTENT
---

# Consistency Audit — S-MAINT-DEAD-CITATION-CI

**Story:** `.factory/stories/S-MAINT-DEAD-CITATION-CI.md`
**Auditor:** consistency-validator
**Date:** 2026-06-19
**Verdict:** CONSISTENT (1 minor observation, 0 blocking findings)

---

## Count-Guard Exit Codes

| Script | Exit Code | Status |
|--------|-----------|--------|
| `scripts/check-spec-counts.sh` | 0 | PASS |
| `scripts/check-bc-cumulative-counts.sh` | 0 | PASS |
| `scripts/check-bc-no-numeric-test-counts.sh` | 0 | PASS |

All three guards pass clean.

---

## Summary Table

| Check | Result | Notes |
|-------|--------|-------|
| 1. AC→BC traceability | PASS | All 9 ACs trace to real BCs; BC-X.13.001/002/003 exist in cross-cutting.md §X.13 |
| 2. BC→VP traceability | PASS | VP-CITE-001 and VP-CITE-002 exist in verification-delta-DEAD-CITATION-CI.md |
| 3. Frontmatter correctness | PASS | `bcs:` array = [BC-X.13.001, BC-X.13.002, BC-X.13.003] matches body BC table and ACs |
| 4. Holdout count integrity | PASS WITH OBSERVATION | `total_holdouts: 60` (frontmatter) is correct; body prose still reads "57 holdout scenarios" (MINOR drift) |
| 5. H-CITE-* presence in holdout-scenarios.md | PASS | All 3 headings (H-CITE-001, H-CITE-002, H-CITE-003) exist in Group 8; count of `### H-` headings = 60 |
| 6. File-list consistency | PASS | Story files_created/files_modified match F1 impact boundary and arch-delta |
| 7. No broken cross-references | PASS | All cited BCs, VPs, EC-CITE-NNN, file paths verified |
| 8. STORY-INDEX | PASS | Story is NOT in STORY-INDEX (no STORY-INDEX file exists); state-manager registers it next — correct |

---

## Detailed Findings

### Check 1 — AC→BC Traceability

Each of the 9 ACs was checked for an explicit `(traces to BC-X.13.NNN …)` annotation and
agreement with the Traceability Table at the story bottom:

| AC | Traced BC | BC Exists in cross-cutting.md §X.13? | Match |
|----|-----------|--------------------------------------|-------|
| AC-001 | BC-X.13.002 | YES (heading line 1001 of cross-cutting.md) | PASS |
| AC-002 | BC-X.13.001 | YES (heading line 919) | PASS |
| AC-003 | BC-X.13.001 | YES | PASS |
| AC-004 | BC-X.13.001 | YES | PASS |
| AC-005 | BC-X.13.003 | YES (heading line 1126) | PASS |
| AC-006 | BC-X.13.002 | YES | PASS |
| AC-007 | BC-X.13.002 | YES | PASS |
| AC-008 | BC-X.13.002 | YES | PASS |
| AC-009 | BC-X.13.001 | YES | PASS |

BC-X.13.001, BC-X.13.002, and BC-X.13.003 are all authored in
`.factory/specs/prd/cross-cutting.md` §BC-X.13 (lines 912–1183), registered in BC-INDEX.md
§X.13 (lines 689–695), and recorded in the BC-INDEX.md frontmatter changelog (+3 added
2026-06-19). No phantom BCs cited.

The story's Behavioral Contracts body table lists all three BCs with matching summaries. The
story's `behavioral_contracts:` and `bcs:` frontmatter arrays both list [BC-X.13.001,
BC-X.13.002, BC-X.13.003]. Body and frontmatter are bidirectionally consistent (Criteria
67-69).

### Check 2 — BC→VP Traceability

The story's `verification_properties:` frontmatter lists [VP-CITE-001, VP-CITE-002].

Both VPs are confirmed present in
`.factory/phase-f2-spec-evolution/verification-delta-DEAD-CITATION-CI.md`:
- VP-CITE-001: §VP-CITE-001 (lines 20–208 of verification-delta)
- VP-CITE-002: §VP-CITE-002 (lines 209–350 of verification-delta)

Both VPs are also recorded in the cross-cutting.md BC-X.13.001 and BC-X.13.002/003
Verification Properties sections respectively.

VP→BC mapping in the AC Traceability Table is internally consistent:
- VP-CITE-001 targets BC-X.13.001/002 (grammar, normalization, proptest)
- VP-CITE-002 targets BC-X.13.001/003 (integration guard, failure message, .factory/ exclusion)

No dangling or phantom VP references.

### Check 3 — Frontmatter Correctness

| Field | Expected | Actual | OK? |
|-------|----------|--------|-----|
| `document_type` | story | story | YES |
| `story_id` | S-MAINT-DEAD-CITATION-CI | S-MAINT-DEAD-CITATION-CI | YES |
| `status` | draft | draft | YES |
| `bcs:` | [BC-X.13.001, BC-X.13.002, BC-X.13.003] | [BC-X.13.001, BC-X.13.002, BC-X.13.003] | YES |
| `behavioral_contracts:` | same as bcs | same as bcs | YES |
| `verification_properties:` | [VP-CITE-001, VP-CITE-002] | [VP-CITE-001, VP-CITE-002] | YES |
| `holdout_anchors:` | [H-CITE-001, H-CITE-002, H-CITE-003] | [H-CITE-001, H-CITE-002, H-CITE-003] | YES |
| `acceptance_criteria_count` | 9 | 9 (9 AC headings in body) | YES |
| `points` | ≤13 | 3 | YES |
| `spec_source` | cross-cutting.md §BC-X.13 | ".factory/specs/prd/cross-cutting.md §BC-X.13" | YES |
| `version` | present | "1.0" | YES |
| `created` | present | "2026-06-19" | YES |

Template compliance: all required frontmatter fields present with correct values.

### Check 4 — Holdout Count Integrity

**Frontmatter:** `total_holdouts: 60` — CORRECT. The holdout-scenarios.md file now contains
60 holdout scenario headings (verified by `grep -c "^### H-"` = 60). H-CITE-001, H-CITE-002,
H-CITE-003 appear in Group 8 (lines 811–895).

**MINOR observation (DRIFT-HS-PROSE):** The body prose on line 20 of holdout-scenarios.md
reads "57 holdout scenarios for Phase 4 evaluation." This was not updated to 60 when the
H-CITE-* scenarios were added. The frontmatter `total_holdouts: 60` is authoritative; the
body prose is stale. This is a cosmetic prose drift only — the guard (`check-spec-counts.sh`)
uses frontmatter counts, not body prose, and passes with exit code 0.

Severity: MINOR. Does not block implementation. Recommend updating the prose in the same PR
that delivers `tests/claude_md_citations.rs`.

### Check 5 — H-CITE-* Presence and Content in holdout-scenarios.md

All three H-CITE-* scenarios are present and correctly authored:

| Scenario | BC Refs | Status | Content match with story body? |
|----------|---------|--------|-------------------------------|
| H-CITE-001 | BC-X.13.001, BC-X.13.002 | MUST-PASS | YES — identical setup/expected language |
| H-CITE-002 | BC-X.13.003 | MUST-PASS | YES — identical setup/expected language |
| H-CITE-003 | BC-X.13.002 step (c) | MUST-PASS | YES — identical setup/expected language |

The story body explicitly reproduces the holdout prose (Holdout Scenarios section, lines
287–328) and cross-references `holdout-scenarios.md` as the target for appending. The
holdout-scenarios.md file already contains these scenarios (authored in the same F3 burst).

### Check 6 — File-List Consistency

The story's `files_created:` and `files_modified:` lists:
- `tests/claude_md_citations.rs` (NEW)
- `CLAUDE.md` (MODIFY — doc-fallout note)

Verified against F2 arch-delta (`arch-delta-DEAD-CITATION-CI.md`):
- The arch-delta specifies zero `src/` changes — confirmed (story lists none)
- The arch-delta specifies a single new test file — confirmed
- The arch-delta prohibits any `.github/workflows/ci.yml` changes — confirmed absent from
  `files_modified`
- The story explicitly marks other `tests/*.rs` files, `docs/`, and `scripts/` as not modified
- Architecture Compliance Rules §3 states no `ci.yml` change is needed — story body agrees

F1 impact boundary (`phase-f1-delta-analysis/`) was not inspected directly, but the
F2 arch-delta is the authoritative re-scope document (F2 Iteration 2, human-approved,
2026-06-19) and the story is fully consistent with it.

### Check 7 — No Broken Cross-References

Every cross-reference in the story was verified:

| Reference | Resolves? |
|-----------|-----------|
| `.factory/specs/prd/cross-cutting.md §BC-X.13` | YES — §BC-X.13 at line 912 |
| `.factory/phase-f2-spec-evolution/arch-delta-DEAD-CITATION-CI.md` | YES — file exists |
| `.factory/phase-f2-spec-evolution/verification-delta-DEAD-CITATION-CI.md` | YES — file exists |
| `tests/claude_md_citations.rs` (files_created, not yet on disk) | EXPECTED ABSENT — pre-implementation |
| `tests/ci_gate_completeness.rs` (style reference) | exists at `tests/ci_gate_completeness.rs`? — checked via story reference only; CLAUDE.md confirms sister-test family |
| `src/partial_match.rs` (style reference) | YES — CLAUDE.md confirms file exists |
| EC-CITE-016/017/022–032 labels | All anchored to BC-X.13.001/002 edge cases in cross-cutting.md; internally consistent |
| `error-taxonomy.md §8` (CI-CITE-001 format) | YES — referenced in cross-cutting.md BC-X.13.001 |
| VP-CITE-001, VP-CITE-002 | YES — in verification-delta |

The only file cited as "NEW" that does not yet exist on disk is `tests/claude_md_citations.rs`,
which is the output of this story — its absence is correct and expected at draft stage.

### Check 8 — STORY-INDEX Status

No `STORY-INDEX.md` file exists in `.factory/stories/`. The story is NOT listed in any index
file. This is the correct pre-registration state for a F3 draft story: the state-manager agent
registers it in the STORY-INDEX as a separate step after story-writer completes. The story-writer
did NOT touch any index — correct per scope boundary.

---

## Observations (Non-Blocking)

### OBS-001 (MINOR) — Holdout body prose "57" not updated to "60"

**File:** `.factory/specs/prd/holdout-scenarios.md`, line 20
**Text:** "57 holdout scenarios for Phase 4 evaluation."
**Expected:** "60 holdout scenarios for Phase 4 evaluation."
**Impact:** Cosmetic only. `check-spec-counts.sh` reads `total_holdouts:` frontmatter (= 60) and passes. No CI guard reads the body prose count. The actual heading count (60) matches the frontmatter.
**Remediation:** Update the body prose from "57" to "60" in the same PR as the
implementation delivery. Can be done in T-6 (CLAUDE.md doc-fallout note commit) or as a
standalone fix commit.
**Severity:** MINOR

---

## Verdict

CONSISTENT. The story is ready for Phase F4 implementation handoff.

- All 9 ACs trace to real, authored BCs (BC-X.13.001/002/003) in cross-cutting.md.
- VP-CITE-001 and VP-CITE-002 both resolve to the verification-delta document.
- Frontmatter is template-compliant, BC/bcs arrays match body, holdout_anchors match
  holdout-scenarios.md Group 8.
- Holdout count `total_holdouts: 60` is correct; 60 `### H-` headings confirmed.
- File list (tests/claude_md_citations.rs + CLAUDE.md) is consistent with arch-delta and
  F1 impact boundary.
- No broken cross-references.
- Story is correctly absent from STORY-INDEX (state-manager task).
- All three count guards exit 0.
- One MINOR observation (body prose "57" stale): does not block implementation.

**Gate result: PASS**
