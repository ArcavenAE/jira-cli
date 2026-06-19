---
document_type: consistency-audit
bundle: DEAD-CITATION-CI
phase: F2
auditor: consistency-validator
created: 2026-06-19
scope: perimeter-audit (count integrity, BC/VP/error-taxonomy chain, ID-scheme,
  cross-reference validity, scope/wording contradictions vs F1 analysis)
verdict: INCONSISTENT (4 findings — 2 MAJOR, 2 MINOR)
---

# F2 Consistency Audit — DEAD-CITATION-CI (Pass 1)

**Scope:** Cross-document perimeter consistency for the DEAD-CITATION-CI spec-delta
package. This audit checks whether the perimeter of the F2 artifacts is internally
consistent with each other and with the surrounding spec corpus. It does NOT
re-examine adversarial correctness of the BC bodies themselves.

**Verdict: INCONSISTENT (4 findings)**

---

## Count-Guard Script Results

| Script | Exit Code |
|--------|-----------|
| `scripts/check-spec-counts.sh` | 0 (OK) |
| `scripts/check-bc-cumulative-counts.sh` | 0 (OK) |
| `scripts/check-bc-no-numeric-test-counts.sh` | 0 (OK) |

All three automated guards pass. The inconsistencies below are in surfaces NOT
covered by the automated scripts.

---

## Documents Reviewed

| Document | Path |
|----------|------|
| PRD delta | `.factory/phase-f2-spec-evolution/prd-delta-DEAD-CITATION-CI.md` |
| Architecture delta | `.factory/phase-f2-spec-evolution/arch-delta-DEAD-CITATION-CI.md` |
| Verification delta | `.factory/phase-f2-spec-evolution/verification-delta-DEAD-CITATION-CI.md` |
| F1 delta analysis | `.factory/phase-f1-delta-analysis/DEAD-CITATION-CI-delta-analysis.md` |
| BC bodies | `.factory/specs/prd/cross-cutting.md` (§X.13 added) |
| BC-INDEX | `.factory/specs/prd/BC-INDEX.md` |
| CANONICAL-COUNTS | `.factory/specs/prd/CANONICAL-COUNTS.md` |
| Error taxonomy | `.factory/specs/prd/error-taxonomy.md` |

---

## Summary Table

| # | Area | Severity | Status |
|---|------|----------|--------|
| F1 | CANONICAL-COUNTS definitional-count table not updated: cross-cutting shows 76 (stale) not 79 (actual) | MAJOR | FAIL |
| F2 | CANONICAL-COUNTS.md Breakdown prose (line 64) references stale `total_bcs: 142` and `599 sum` outside the historical note block | MAJOR | FAIL |
| F3 | "9 exclusion rules" claim in VP-CITE-001 and arch-delta conflicts with the 5 explicitly numbered rules in BC-X.13.002 body; rules 6-9 are only implied by the dir-prefix filter in BC-X.13.001 | MINOR | FAIL |
| F4 | VP-CITE-* ID scheme deviates from the established per-issue VP-NNN-NNN convention used by all other bundles in this repo | MINOR | PASS (design decision documented) |

---

## Findings

### F1 (MAJOR): CANONICAL-COUNTS.md per-file definitional counts table not updated

**Location:** `.factory/specs/prd/CANONICAL-COUNTS.md`, lines 29-30

**Observed:**
```
| cross-cutting.md | 76 | 76 | YES |
| **Total individually-bodied** | **367** | — | — |
```

**Expected:**
```
| cross-cutting.md | 79 | 79 | YES |
| **Total individually-bodied** | **370** | — | — |
```

**Evidence:** Running `grep -c '^#### BC-' .factory/specs/prd/cross-cutting.md` returns
79. The frontmatter `definitional_count: 79` and the BC-INDEX Coverage Statistics table
(line 721: `| X: Cross-Cutting | 145 | 79 |`) both show 79. The automated
`check-spec-counts.sh` compares the actual `#### BC-` heading count against the
frontmatter `definitional_count`, NOT against the CANONICAL-COUNTS table — so this
drift is invisible to the script and is confirmed real.

Additionally, CANONICAL-COUNTS.md line 61 (`- 370 of 602 are individually-bodied`)
was updated correctly, creating an internal self-contradiction within the same file:
the breakdown prose says 370 while the definitional counts table says 367.

The prd-delta claims "All 8 count surfaces updated (A-G + Coverage Statistics
table)." The per-file definitional counts table in CANONICAL-COUNTS.md is a 10th
surface not covered by A-G (the script only checks `total_bcs` values, not
definitional counts) and was explicitly claimed updated — but was not.

**Remediation:** In `.factory/specs/prd/CANONICAL-COUNTS.md`:
- Row for `cross-cutting.md`: change `76 | 76` to `79 | 79`
- Footer row: change `**367**` to `**370**`
- The breakdown prose on line 61 (`370 of 602`) is already correct; no change needed there

---

### F2 (MAJOR): CANONICAL-COUNTS.md Breakdown prose references stale pre-F2 figures outside the historical block

**Location:** `.factory/specs/prd/CANONICAL-COUNTS.md`, lines 63-65

**Observed (active prose, NOT inside the historical note block):**
```
- BC-X.4.009 (ADV-P1-029) is a `#### BC-` heading in cross-cutting.md; it is
  included in cross-cutting's `total_bcs: 142` and in the **599 sum**.
  It does NOT add +1 beyond the 599.
```

**Problem:** `total_bcs: 142` is the pre-F2 value for cross-cutting (which was
142 before F2 added BC-X.13.001..003, making it 145). The `599 sum` is the
pre-DEAD-CITATION-CI grand total (the total before this bundle; current total is 602).
This prose sits in the active "Breakdown" section, not inside the archived
`_Historical note (archived;...)_` block on lines 67-68.

A reader encountering lines 63-65 sees a claim that cross-cutting's `total_bcs`
is 142 and the sum is 599, directly contradicting the Sum table on line 51
(which correctly says 602) and the cross-cutting row on line 50 (which correctly
says 145). This is a stale internal reference that the automated scripts do not
check.

**Remediation:** Update lines 63-65 to reflect current values:
```
- BC-X.4.009 (ADV-P1-029) is a `#### BC-` heading in cross-cutting.md; it is
  included in cross-cutting's `total_bcs: 145` and in the **602 sum**.
  It does NOT add +1 beyond the 602.
```

---

### F3 (MINOR): "9 exclusion rules" claim inconsistent with numbered rules in BC body

**Location:** Multiple:
- VP-CITE-001 in `.factory/specs/prd/cross-cutting.md` (lines 969, 1024)
- `.factory/phase-f2-spec-evolution/arch-delta-DEAD-CITATION-CI.md` line 85
- `.factory/phase-f2-spec-evolution/verification-delta-DEAD-CITATION-CI.md` §VP-CITE-001 table

**Observed:** The VP-CITE-001 body in cross-cutting.md says:
> "unit + proptest coverage of in-scope detection and all 9 exclusion rules"

The arch-delta §2 (purity boundary note) says:
> "proptest can exercise all 9 exclusion rules"

The verification-delta VP-CITE-001 table has 11 rows numbered 1-9 (rules 2 and 3
each have two sub-cases), clearly defining 9 distinct exclusion/filtering behaviors.

**But BC-X.13.002** (the authoritative BC body) explicitly enumerates only 5 rules
in its Behavior section (Glob skip, Symbol-form strip, Line-ref strip, Section-ref,
Extension filter). Rules 6-9 from the VP table (No-dir-prefix URLs, No-dir-prefix
home paths, No-slash tokens, Type names without dir prefix) are NOT enumerated in
BC-X.13.002 — they fall out implicitly from the BC-X.13.001 dir-prefix filter.

**Impact:** A test-writer implementing VP-CITE-001 sees "9 exclusion rules" in
the VP but only 5 numbered rules in the BC body — potentially causing confusion
about test scope. The VP table supplies the 9-rule enumeration, so the test-writer
has sufficient guidance, but the claimed count is misleading when read against the BC.

**Assessment:** This is a presentational inconsistency (the behavior is fully
specified; the rules 6-9 exist implicitly in BC-X.13.001). Not a semantic gap —
no behavior is missing. The VP-CITE-001 detailed table in verification-delta covers
all 9 cases. F3 implementer can resolve without spec change.

**Remediation (two acceptable options):**
1. (Preferred) Update the VP-CITE-001 one-liners in cross-cutting.md from "all 9
   exclusion rules" to "all 5 explicitly numbered exclusion rules plus 4 implicit
   dir-prefix exclusions" to match the BC structure, OR
2. Add a note to BC-X.13.002 stating "rules 6-9 (URL/home-path/no-slash/type-name
   exclusions) are handled by the dir-prefix filter in BC-X.13.001 and are not
   separately numbered here but are covered in VP-CITE-001 test vectors."

---

### F4 (MINOR): VP-CITE-* ID scheme is novel vs established per-issue VP-NNN-NNN convention

**Location:** All F2 DEAD-CITATION-CI artifacts; cross-cutting.md §BC-X.13

**Observed:** VP-CITE-001, VP-CITE-002 use a semantic suffix (`CITE`) instead of
the numeric-per-issue pattern used by ALL other VPs in this codebase:
- VP-396-001 through VP-396-012 (issue #396)
- VP-398-001 through VP-398-006 (issue #398)
- All prior VP-NNN-NNN naming consistently uses a numeric issue reference

**Assessment:** The verification-delta explicitly notes this choice and provides
justification (F2 2026-06-19): VP-CITE-001 and VP-CITE-002 have no associated
GitHub issue number at the time of writing (this is a maintenance-mode feature,
not a numbered issue). The name `CITE` is semantically descriptive and unique
within the VP namespace. No collision with existing VP IDs exists.

This deviates from convention but is documented in the verification-delta. The
`vp_index_is_vp_catalog_source_of_truth` policy references a VP-INDEX file that
does not exist in this repo — VPs in this codebase are embedded directly in BC
bodies and delta files. No separate VP-INDEX exists, so no registry update is
missed. The deviation is an informed design decision.

**Verdict on F4:** PASS with noted deviation. No action required, but the F3
story should note that VP-CITE-001/002 use a semantic naming scheme distinct from
the VP-NNN-NNN convention, for future auditors.

---

## Validation: BC/VP/Error-Taxonomy Chain (Section 2 of audit task)

### BC-X.13.001 → VP-CITE-001, VP-CITE-002: VALID
BC-X.13.001 Verification Properties cites VP-CITE-001 and VP-CITE-002. Both
VPs exist in verification-delta with full test strategies. The links are
forward-only (BC cites VP; VP cites BC); no dangling references.

### BC-X.13.002 → VP-CITE-001: VALID
BC-X.13.002 Verification Properties cites VP-CITE-001. VP-CITE-001 covers
BC-X.13.001 and BC-X.13.002 per the VP-to-BC Mapping Summary. Consistent.

### BC-X.13.003 → VP-CITE-002: VALID
BC-X.13.003 Verification Properties cites VP-CITE-002. VP-CITE-002 covers
BC-X.13.001 and BC-X.13.003 per the VP-to-BC Mapping Summary. Consistent.

### CI-CITE-001 (error-taxonomy.md §Section 8) → BC-X.13.001/002/003: VALID
The Tracing BCs field in CI-CITE-001 references BC-X.13.001, BC-X.13.002, and
BC-X.13.003. All three BC IDs exist in cross-cutting.md. No dangling references.

### VP-INDEX / verification-architecture.md: NOT APPLICABLE
The `vp_index_is_vp_catalog_source_of_truth` policy note in the verification-delta
references VP-INDEX and verification-architecture.md. Neither file exists in this
repository. VPs are embedded in BC bodies per project convention. The
verification-delta explicitly documents this: "No separate index propagation is
required." This is consistent with how all other VP-NNN-NNN items in this codebase
are handled. No gap.

---

## Validation: ID-Scheme Consistency (Section 3 of audit task)

### BC-X.13.* numbering: CONSISTENT
Subsystem X.13 follows the established pattern (X.8, X.9, X.10, X.11, X.12 precede
it in sequence). The new subsystem is correctly appended as X.13. The three BCs are
numbered 001, 002, 003 in order of ascending specificity (existence check, exclusion
grammar, allowlist). No skips, no reuse, no conflict with existing IDs.

### BC-CITE-NNN (provisional, F1) vs BC-X.13.NNN (final, F2): CONSISTENT
The F1 delta analysis explicitly flagged BC-CITE-NNN as provisional numbering
("The BC numbering (BC-CITE-NNN) is provisional; the product-owner will assign
final BC-S.SS.NNN"). F2 assigned BC-X.13.001..003 as final. No F2 artifact
carries the provisional IDs, and the F1 artifact does not claim BC-X.13.NNN IDs.
Clean handoff.

### VP-CITE-* ID scheme: SEE F4 ABOVE (MINOR deviation, documented)

---

## Validation: Cross-Reference Validity (Section 4 of audit task)

All file path citations in the F2 DEAD-CITATION-CI artifacts that are verifiable
at F2 time (i.e., files that SHOULD exist now, not F3/F4 future files) were
individually checked:

| Cited Path | Status |
|-----------|--------|
| `.factory/phase-f1-delta-analysis/DEAD-CITATION-CI-delta-analysis.md` | EXISTS |
| `.factory/phase-f2-spec-evolution/prd-delta-DEAD-CITATION-CI.md` | EXISTS |
| `.factory/phase-f2-spec-evolution/arch-delta-DEAD-CITATION-CI.md` | EXISTS |
| `.factory/phase-f2-spec-evolution/verification-delta-DEAD-CITATION-CI.md` | EXISTS |
| `.factory/research/maint-pg-dead-citation-ci-approach.md` | EXISTS |
| `.factory/research/issue-288-pr4-deferred-validation.md` | EXISTS (cited in BC-X.8.006 context) |
| `.factory/research/S-3.03-wave3-verification.md` | EXISTS (cited in EC-CITE-013 example) |
| `docs/specs/e2e-live-jira-testing.md` | EXISTS (cited in EC-CITE-009 example) |
| `tests/claude_md_citations.rs` | DOES NOT EXIST YET — correctly labelled (new) in F2 |

`tests/claude_md_citations.rs` is the F3/F4 deliverable — all citations to it in
cross-cutting.md BC bodies correctly annotate it as "new function" or "new". No
false claim of current existence.

All ADR citations (ADR-0016 etc.) are present in `.factory/architecture/adr/`.
No dangling cross-references found in the F2 artifact set.

**Special note on the guard's own citation integrity:** The F2 artifacts cite
`.factory/research/S-3.03-wave3-verification.md` and
`.factory/research/issue-331-issuetype-bulk-schema.md` in EC-CITE examples.
Both files exist on `develop`. This is consistent with BC-X.13.003's specification
that `.factory/research/` IS checked (not allowlisted). The feature is eating its
own cooking correctly.

---

## Validation: F1 Scope vs F2 Wording Consistency (Section 5 of audit task)

### Off-branch allowlist set: CONSISTENT
F1 analysis §5c establishes the allowlist as `.factory/specs/`, `.factory/holdout-scenarios/`,
`.factory/cycles/`. Explicitly excludes `.factory/research/`. BC-X.13.003 body
codifies exactly this set. The prd-delta BC table and the BC title both cite the
same three prefixes. No drift.

### Research files on develop: CONSISTENT
F1 §5c says `.factory/research/` files ARE on `develop`. BC-X.13.003 Preconditions
confirm: "`.factory/research/` IS present in the working tree." EC-CITE-013 and
EC-CITE-014 demonstrate the expected behavior. Consistent.

### Extension filter (BC-X.13.001 vs arch-delta §2): MINOR DISCREPANCY
BC-X.13.001 Behavior lists six recognized extensions: `.md, .rs, .sh, .toml,
.yml, .yaml`. The arch-delta §2 Pure Function description also lists the same six.
Consistent.

### Section-ref handling attribution: CONSISTENT
F1 §5b labels `docs/specs/foo.md §9` as "naturally excluded by whitespace
tokenization". BC-X.13.002 rule 4 says the same. The verification-delta VP-CITE-001
table rule 4 is labeled "Section-ref — whitespace". All three agree.

---

## Count Integrity Summary

| Surface | Pre-F2 | Claimed Post-F2 | Actual Post-F2 | Match? |
|---------|--------|-----------------|----------------|--------|
| cross-cutting.md frontmatter `total_bcs` | 142 | 145 | 145 | YES |
| cross-cutting.md frontmatter `definitional_count` | 76 | 79 | 79 | YES |
| BC-INDEX.md frontmatter `total_bcs` (Surface E) | 599 | 602 | 602 | YES |
| BC-INDEX.md Section X header cumulative (Surface B) | 142 | 145 | 145 | YES |
| BC-INDEX.md Section X individually-bodied (Surface B) | 76 | 79 | 79 | YES |
| BC-INDEX.md `sections:` line for cross-cutting (Surface C) | 142 | 145 | 145 | YES |
| CANONICAL-COUNTS.md per-file `total_bcs` row (Surface D) | 142 | 145 | 145 | YES |
| CANONICAL-COUNTS.md **Sum** row (Surface F) | 599 | 602 | 602 | YES |
| CANONICAL-COUNTS.md grand-total prose (Surface G) | 599 | 602 | 602 | YES |
| BC-INDEX Coverage Statistics table (manually guarded) | 142/76 | 145/79 | 145/79 | YES |
| CANONICAL-COUNTS definitional counts table (NOT in A-G) | 76 | 79 | **76 (STALE)** | **NO** |
| CANONICAL-COUNTS Breakdown prose (stale ref to old values) | 142/599 | 145/602 | **142/599 (STALE)** | **NO** |

---

## Verdict

INCONSISTENT — 2 MAJOR findings, 2 MINOR findings.

- **F1 (MAJOR):** CANONICAL-COUNTS.md per-file definitional counts table shows
  cross-cutting.md as 76 / total 367 (pre-F2 stale). Actual values: 79 / 370.
  This is the only surface where the F2 update was missed.

- **F2 (MAJOR):** CANONICAL-COUNTS.md Breakdown prose (active section, not the
  archived historical note) still references `total_bcs: 142` and `599 sum` — stale
  pre-F2 figures. Should read `145` and `602`.

- **F3 (MINOR):** "9 exclusion rules" claim in VP-CITE-001 and arch-delta is
  misleading: BC-X.13.002 body explicitly enumerates only 5 rules; rules 6-9 are
  implicit from the dir-prefix filter in BC-X.13.001. Behavioral coverage is complete;
  the count claim creates reader confusion.

- **F4 (MINOR):** VP-CITE-* ID scheme deviates from established VP-NNN-NNN
  convention. Justified (no issue number; maintenance-mode feature) and documented.
  PASS with noted deviation.

**Blocking for gate?** F1 and F2 are MAJOR findings in a count-integrity document
that is itself the source of truth for spec counts. They should be corrected before
the F2 gate passes. F3 and F4 do not block implementation (F3 is a clarification;
F4 is an accepted deviation). Both MAJOR findings are in CANONICAL-COUNTS.md only
and require no changes to the BC bodies, BC-INDEX, or any F2 artifacts.
