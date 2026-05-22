---
document_type: adversarial-pass-report
issue: "#396"
pass: 7
date: "2026-05-22"
verdict: CLEAN (substantively) — 2 LOW + 1 cosmetic swept
findings_count: 2
severities: "0 CRITICAL, 0 HIGH, 0 MEDIUM, 2 LOW"
observations_actioned: 1
clean_pass_count: 1
---

# Adversarial Pass 7 Report — Issue #396: `issue edit --field NAME=VALUE`

**Date**: 2026-05-22  
**Verdict**: Substantively CLEAN (0 CRITICAL/HIGH/MEDIUM). 2 LOW findings + 1 cosmetic swept.  
**Clean pass count**: 1 of 3 required.

---

## Findings

### LOW-001: `BC-INDEX.md:5` `last_updated` stale (2026-05-21 → 2026-05-22)

**Finding**: `BC-INDEX.md` frontmatter line 5 — `last_updated: 2026-05-21` — was not
advanced when the #396 delta modified BC-INDEX.md (total_bcs 583, Section 3/3.4 headers,
three new BC-3.4.015..017 rows, Coverage Statistics). Sibling `bc-3-issue-write.md`
correctly had `2026-05-22`.

**Resolution**: Bumped `BC-INDEX.md:5` to `last_updated: 2026-05-22`.

**Files changed**:
- `.factory/specs/prd/BC-INDEX.md` — `last_updated` frontmatter field

---

### LOW-002 [process-gap]: `prd-delta-396.md §11` missing `BC-INDEX.md last_updated` row

**Finding**: The count-surfaces table in §11 tracked `CANONICAL-COUNTS.md frontmatter
last_verified` but had no parallel row for `BC-INDEX.md last_updated` — which is why
LOW-001 slipped through. The omission left this surface invisible to future delta authors.

**Resolution**: Added a `BC-INDEX.md last_updated` row to the §11 count-surfaces table:

| BC-INDEX.md `last_updated` frontmatter | `2026-05-21` | `2026-05-22` [LOW-001, pass 7] |

**Files changed**:
- `.factory/phase-f2-spec-evolution/prd-delta-396.md` — §11 table new row

---

### O-1 (cosmetic): Duplicated blockquote in prd-delta §11

**Finding**: Lines ~425–441 in prd-delta §11 had the "Note on script coverage
(P3-MED-002)" blockquote appearing twice — the second copy was a partial repeat of the
first, truncated mid-sentence ("...fall into two categories."). This arose from the
pass-6 edit that added a new blockquote for the `_Last updated_` prose gap without
removing the original P3-MED-002 note it preceded.

**Resolution**: Deduplicated to a single consolidated blockquote that covers all three
unguarded surfaces (BC-INDEX Coverage Statistics, `BC-INDEX.md last_updated`, and
`_Last updated_` prose), referencing process-gap O-5 from pass 6.

**Files changed**:
- `.factory/phase-f2-spec-evolution/prd-delta-396.md` — §11 blockquote deduplicated

---

## Resolution Summary

| Finding | Severity | Resolution |
|---------|----------|------------|
| LOW-001 | LOW | `BC-INDEX.md` `last_updated` bumped from `2026-05-21` to `2026-05-22`. |
| LOW-002 | LOW | `BC-INDEX.md last_updated` row added to prd-delta §11 count-surfaces table. |
| O-1 | Cosmetic | Duplicated §11 blockquote deduplicated to single consolidated note. |

**VP count**: 12 (VP-396-001 through VP-396-012) — unchanged.  
**Total BCs**: 583 — unchanged.

**Guard scripts**:
- `check-spec-counts.sh`: exit 0
- `check-bc-cumulative-counts.sh`: exit 0 (583 total across 8 files; Surface H verified)
