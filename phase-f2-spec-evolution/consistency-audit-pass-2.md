---
document_type: consistency-audit
bundle: DEAD-CITATION-CI
phase: F2
iteration: 2
auditor: consistency-validator
created: 2026-06-19
scope: pass-2 — verify pass-1 majors fixed; check new drift from iteration-2 revisions
verdict: INCONSISTENT (3 findings — 0 MAJOR, 3 MINOR)
---

# F2 Consistency Audit — DEAD-CITATION-CI (Pass 2)

**Scope:** Verify that Pass 1's 2 MAJOR findings are resolved in iteration-2
artifacts, and detect any new drift introduced by the re-scope revisions.
Checks: count-guard scripts, failure-message single-source-of-truth,
re-scope language consistency, pipeline-order consistency across all three
F2 documents, BC/VP/taxonomy chain integrity.

---

## Count-Guard Script Results

| Script | Exit Code | Result |
|--------|-----------|--------|
| `scripts/check-spec-counts.sh` | 0 | OK |
| `scripts/check-bc-cumulative-counts.sh` | 0 | OK |
| `scripts/check-bc-no-numeric-test-counts.sh` | 0 | OK |

All three automated guards pass.

---

## Documents Reviewed

| Document | Path |
|----------|------|
| PRD delta (iteration 2) | `.factory/phase-f2-spec-evolution/prd-delta-DEAD-CITATION-CI.md` |
| Architecture delta | `.factory/phase-f2-spec-evolution/arch-delta-DEAD-CITATION-CI.md` |
| Verification delta | `.factory/phase-f2-spec-evolution/verification-delta-DEAD-CITATION-CI.md` |
| BC bodies | `.factory/specs/prd/cross-cutting.md` (§X.13) |
| BC-INDEX | `.factory/specs/prd/BC-INDEX.md` |
| CANONICAL-COUNTS | `.factory/specs/prd/CANONICAL-COUNTS.md` |
| Error taxonomy | `.factory/specs/prd/error-taxonomy.md` |

---

## Summary Table

| # | Area | Severity | Status |
|---|------|----------|--------|
| Pass-1 F1 | CANONICAL-COUNTS definitional table stale (76 / 367) | MAJOR | **FIXED** |
| Pass-1 F2 | CANONICAL-COUNTS Breakdown prose stale (142/599) | MAJOR | **FIXED** |
| Pass-1 F3 | "9 exclusion rules" count inconsistency | MINOR | **FIXED** |
| Pass-1 F4 | VP-CITE-* ID scheme deviation | MINOR | ACCEPTED (documented) |
| **P2-N1** | **Step-letter numbering mismatch between BC-X.13.002 body and arch-delta + verification-delta** | **MINOR** | **FAIL** |
| **P2-N2** | **Two stale step-letter cross-references within cross-cutting.md itself** | **MINOR** | **FAIL** |
| **P2-N3** | **CANONICAL-COUNTS historical note parenthetical says "(599)" when current total is 602** | **MINOR** | **FAIL** |

---

## Pass-1 Major Finding Verification

### Pass-1 F1 (was MAJOR): CANONICAL-COUNTS definitional-count table — FIXED

**Verified:** CANONICAL-COUNTS.md line 29 now reads:

```
| cross-cutting.md | 79 | 79 | YES |
```

and the Total individually-bodied footer row (line 30) now reads:

```
| **Total individually-bodied** | **370** | — | — |
```

`grep -c '^#### BC-' .factory/specs/prd/cross-cutting.md` = 79 (confirmed).
The cross-cutting.md frontmatter also confirms `definitional_count: 79`.
Both surfaces agree. F1 is RESOLVED.

### Pass-1 F2 (was MAJOR): CANONICAL-COUNTS Breakdown prose — FIXED

**Verified:** CANONICAL-COUNTS.md lines 63-65 now read:

```
- BC-X.4.009 (ADV-P1-029) is a `#### BC-` heading in cross-cutting.md; it is
  included in cross-cutting's `total_bcs: 145` and in the **602 sum**.
  It does NOT add +1 beyond the 602.
```

Both figures (`145` and `602`) match the Sum table (line 51) and the active count
surfaces. F2 is RESOLVED.

### Pass-1 F3 (was MINOR): "9 exclusion rules" count claim — FIXED

**Verified:** The "9 exclusion rules" wording has been removed from all surfaces:
- cross-cutting.md VP-CITE-001 one-liner (line 981): now says "all normalization/exclusion rules" (no count)
- cross-cutting.md VP-CITE-001 one-liner in BC-X.13.002 (line 1059): same
- cross-cutting.md line 1013: explicit Cardinality note says "5 normalization/skip rules" and states references to "9 exclusion rules" are SUPERSEDED
- arch-delta: no "9 exclusion rules" wording
- verification-delta: no "9 exclusion rules" wording; section heading uses "all normalization/exclusion rules"

F3 is RESOLVED.

---

## New Findings

### P2-N1 (MINOR): Step-letter numbering mismatch — BC-X.13.002 body vs arch-delta and verification-delta

**Severity:** MINOR

**Location:**
- `cross-cutting.md` §BC-X.13.002 body (lines 1002–1011): authoritative canonical pipeline
- `arch-delta-DEAD-CITATION-CI.md` §2, lines 41–52: 8-step pipeline (a)–(h)
- `verification-delta-DEAD-CITATION-CI.md` §VP-CITE-001, lines 63–78: exclusion table using step labels (c)–(g)

**Observed discrepancy:**

The BC-X.13.002 body enumerates the pipeline with extraction as an UNNUMBERED
prefix description, then steps (a)–(h) cover only the normalization/filter/check
stages:

| Step | Rule |
|------|------|
| (a) | Glob skip |
| (b) | Symbol-form strip |
| (c) | Line-ref strip |
| (d) | Section-ref (passive note) |
| (e) | Trailing-punctuation trim |
| (f) | Dir-prefix filter |
| (g) | Extension filter |
| (h) | Path::exists() check |

The arch-delta §2 treats the two extraction sub-steps as (a) and (b), then
continues normalization from (c):

| Step | Rule |
|------|------|
| (a) | Extract inline single-backtick spans + split on whitespace |
| (b) | Split interior on ASCII whitespace (token candidates) |
| (c) | Glob skip |
| (d) | Symbol-form strip |
| (e) | Line-ref strip |
| (f) | Trailing-punctuation trim |
| (g) | Dir-prefix + extension filter (COMBINED) |
| (h) | Path::exists() check |

The verification-delta exclusion table (§VP-CITE-001, lines 63-78) uses step
letters matching arch-delta's scheme:

```
(c) Glob skip
(d) Symbol-form strip
(e) Line-ref strip
(f) Trailing-punct trim
(g) Dir-prefix filter
```

**Effect:** An F4 implementer comparing the verification-delta's exclusion table
against the BC-X.13.002 body will see "step (f) = Trailing-punct trim" in the
test table but "step (f) = Dir-prefix filter" in the BC body. The step letters
do not correspond to the same rules. Additionally, arch-delta combines dir-prefix
and extension into a single step (g), while the BC body separates them as (f) and
(g).

**Impact assessment:** The behavioral intent is identical across all three
documents — the normalization rules, their order, and their effects are consistent.
The discrepancy is in the labeling scheme only, not in substance. An F4 implementer
following the BC body (the authoritative source per BC-INDEX preamble) will
implement the correct behavior. The test table in verification-delta provides
correct coverage even if the step letters differ. No BC clause goes
uncovered and no rule is implemented twice.

**The BC body is authoritative** per BC-INDEX.md preamble: "When a body file and
this index disagree, the body file wins." The same principle applies to delta
files — the BC body is canonical. The arch-delta and verification-delta are F2
working artifacts consumed by F4; once F4 produces tests, the delta detail is
superseded by the test file itself (per verification-delta §Project Convention Note).

**Remediation options (either acceptable; neither blocks F4):**
1. (Preferred for future clarity) Note in verification-delta §VP-CITE-001 that
   step letters in the table follow arch-delta's (a)–(h) scheme where extraction
   occupies (a)+(b); cross-reference to BC-X.13.002 for the authoritative
   pipeline with extraction as unnumbered prefix.
2. (Minimal) Add a parenthetical to the verification-delta table header: "Step
   letters per arch-delta §2 — BC-X.13.002 body uses (a)–(g) for normalization
   pipeline only; extraction is described separately."

Neither option requires any change to the BC body or to BC-INDEX.

---

### P2-N2 (MINOR): Two stale step-letter cross-references within cross-cutting.md

**Severity:** MINOR

**Location:** `.factory/specs/prd/cross-cutting.md`

**Two internal cross-reference errors were introduced by the iteration-2 revision.
Both use step letters from arch-delta's numbering scheme instead of BC-X.13.002's
own pipeline enumeration:**

#### Error 1: EC-CITE-002 (line 954) — wrong step letter for trailing-punct

**Observed:**
```
- EC-CITE-002: A citation uses `Detail: path1, path2` comma-delimited form → both
  tokens extracted (interior whitespace tokenization); trailing comma stripped by
  trailing-punct rule (BC-X.13.002 step f) → both checked independently
```

**Problem:** In BC-X.13.002's own body (lines 1002–1011), trailing-punctuation
trim is step **(e)**, not (f). Step (f) is the dir-prefix filter. "BC-X.13.002
step f" refers to dir-prefix, which is not what EC-CITE-002 describes.

**Correct reference:** "BC-X.13.002 step e" (trailing-punctuation trim).

**Source of error:** arch-delta uses (f) = Trailing-punct trim. The EC-CITE-002
text was written referencing arch-delta's scheme, not the BC body's scheme.

#### Error 2: BC-X.13.002 step d body text (line 1007) — wrong step for dir-prefix reference

**Observed (inside BC-X.13.002 step d):**
```
d. **Section-ref**: `§9`-style tokens lack a known directory prefix and are excluded
   by the dir-prefix filter at step (g); whitespace tokenization has already separated
   them from the preceding path.
```

**Problem:** Within BC-X.13.002's own pipeline, the dir-prefix filter is step
**(f)**, not (g). Step (g) is the extension filter. The text cross-references an
incorrect step letter within the SAME BC body.

**Correct reference:** "...excluded by the dir-prefix filter at step (f)."

**Source of error:** arch-delta uses (g) = Dir-prefix + extension filter (combined).
The step-d description was written referencing arch-delta's step (g) instead of the
BC body's own step (f).

**Impact:** An F4 implementer reading BC-X.13.002 finds contradictions within the
same BC: step d says dir-prefix is at "(g)" but step (g) is defined as the extension
filter on line 1010. This is confusing but not behavior-altering — the canonical
step ordering in lines 1004-1011 is correct and unambiguous; only the cross-reference
labels in specific sentences are wrong.

**Remediation (both fixes in cross-cutting.md):**
1. Line 954: change "(BC-X.13.002 step f)" to "(BC-X.13.002 step e)"
2. Line 1007 (BC-X.13.002 step d body): change "at step (g)" to "at step (f)"

These are two-character fixes; no behavioral change.

---

### P2-N3 (MINOR): CANONICAL-COUNTS historical note parenthetical says "(599)"

**Severity:** MINOR

**Location:** `.factory/specs/prd/CANONICAL-COUNTS.md`, line 67

**Observed:**
```
_Historical note (archived; historical total was 566; current canonical: see Sum row
above (599)): Passes 10-13 involved a 541/542 count confusion around BC-X.4.009...
```

**Problem:** The parenthetical "(599)" was the grand total as of several bundles
ago. The Sum row above now shows **602**. The text says "current canonical: see Sum
row above (599)" — the redirect is correct (it says "see Sum row above") but the
parenthetical (599) contradicts the Sum row it points to.

**Classification reasoning:** This is inside the archived historical note block
(italicized, explicitly labeled "archived"), so its impact on functional
consistency is low. A reader following "see Sum row above" will find 602, not 599.
However, the phrase "current canonical" used in an archived block that gives a
stale number is misleading if read in isolation. MINOR (not MAJOR) because it is
(a) inside a clearly labeled archive block, (b) the redirect points correctly to
the updated Sum row, and (c) it does not affect any automated count guard.

**Remediation:** Update line 67 to replace "(599)" with "(602)":
```
_Historical note (archived; historical total was 566; current canonical: see Sum row
above (602)): Passes 10-13 involved...
```

Alternatively, remove the parenthetical entirely since "see Sum row above" is
sufficient: "current canonical: see Sum row above."

---

## Validation: Failure-Message Single-Source-of-Truth (Audit Item 2)

**Result: CONSISTENT across all sources.**

The canonical failure message (CI-CITE-001) is defined in error-taxonomy.md §Section 8
as a four-line structure:

```
CLAUDE.md cites file paths that do not exist on disk:
  <path> (line N)
Fix the citation or restore the file.
Note: .factory/, glob, and symbol-form tokens are auto-excluded.
```

Verified across all F2 artifacts:

| Source | Message | Match? |
|--------|---------|--------|
| `error-taxonomy.md` §CI-CITE-001 Message format field | Full four-line structure, verbatim | AUTHORITATIVE |
| `cross-cutting.md` BC-X.13.001 Postconditions (failure) lines 936–941 | Identical four-line structure in code block | YES |
| `arch-delta-DEAD-CITATION-CI.md` §2 code block lines 72–75 | Identical four-line structure | YES |
| `verification-delta-DEAD-CITATION-CI.md` line 199 (Rust string) | `"CLAUDE.md cites file paths that do not exist on disk:\n  {}\nFix the citation or restore the file.\nNote: .factory/, glob, and symbol-form tokens are auto-excluded."` — identical content | YES |
| `prd-delta-DEAD-CITATION-CI.md` §Canonical Failure Message lines 35–41 | Same four-line block | YES |

No third divergent variant found. The old "add to allowlist" hint sentence has been
removed from all locations. The note "No allowlist — `.factory/` paths are always
excluded by the dir-prefix filter" in error-taxonomy.md CI-CITE-001 Actionability
field is consistent with BC-X.13.003.

---

## Validation: Re-scope Consistency (Audit Item 3)

**Result: CONSISTENT. No surviving contradiction between "all .factory/ excluded"
and any older "research is checked / specs allowlisted" wording in the BC bodies
or F2 artifacts.**

Scanned all occurrences of "allowlist", "off-branch", "research is checked",
"allowlisted", "is_off_working_branch" in:
- `.factory/specs/prd/cross-cutting.md`
- `.factory/specs/prd/error-taxonomy.md`
- All three F2 delta files

Every occurrence of these terms is in one of the following negative contexts:
1. Explicitly labeled as "SUPERSEDED" (e.g., "the old 'off-branch allowlist' design is SUPERSEDED")
2. Explicitly prohibiting the function (e.g., "There is NO `is_off_working_branch_allowlisted` function")
3. Historical narrative explaining the old design was wrong
4. In DO-NOT-IMPLEMENT instructions (e.g., arch-delta "Do not implement or reference an allowlist function")

No occurrence endorses or positively describes the old allowlist behavior.
BC-X.13.003 body (lines 1073-1099) states the all-exclude rule comprehensively
and explicitly supersedes any partition between `.factory/research/` and
`.factory/specs/`. EC-CITE-017, EC-CITE-018, EC-CITE-019, EC-CITE-020,
EC-CITE-021 all illustrate `.factory/` sub-paths that are excluded — no carve-out.

---

## Validation: Pipeline-Order Consistency (Audit Item 4)

**Result: FUNCTIONALLY CONSISTENT, but step-letter labeling diverges across docs
(see P2-N1 and P2-N2 above).**

The behavioral sequence of operations is identical across all three F2 documents:
extraction → glob skip → symbol-form strip → line-ref strip → trailing-punct trim
→ dir-prefix filter → extension filter → path exists check.

The discrepancy is purely in how the steps are numbered (step letters). The BC-X.13.002
body is canonical; the arch-delta and verification-delta use a different numbering
scheme where extraction occupies the first two step slots. The behavior at each step
is described identically; no step is missing, reordered, or defined differently
between documents.

The two internal cross-reference errors within cross-cutting.md (P2-N2) also follow
from the step-letter mismatch and are the only place where a behavioral confusion
could arise for a reader of the BC body alone.

**Specific step comparison (behavioral, not labeled):**

| Behavior | BC-X.13.002 body step | arch-delta step | verification-delta table |
|----------|----------------------|-----------------|--------------------------|
| Extraction (backtick spans + whitespace split) | unnumbered prefix | (a)+(b) | not in table |
| Glob skip (`*`,`{`,`}`) | (a) | (c) | (c) |
| Symbol-form strip (`::`) | (b) | (d) | (d) |
| Line-ref strip (`:~NN`/`:NN`) | (c) | (e) | (e) |
| Section-ref (excluded by dir-prefix) | (d) — passive note | implicit in (g) | implicit in (g) |
| Trailing-punct trim | (e) | (f) | (f) |
| Dir-prefix filter | (f) | (g) combined | (g) |
| Extension filter | (g) | (g) combined | (g) |
| Path::exists() check | (h) | (h) | not in table |

The behavioral sequence is consistent. Step-labeling is not.

---

## Validation: BC/VP/Taxonomy Chain (Audit Item 5)

**Result: INTACT — all cited IDs resolve and chain correctly.**

| Chain | Status |
|-------|--------|
| BC-X.13.001 → VP-CITE-001, VP-CITE-002 (Verification Properties) | VALID — both VPs exist in verification-delta with full test strategies |
| BC-X.13.002 → VP-CITE-001 (Verification Properties) | VALID — VP-CITE-001 covers BC-X.13.001 and BC-X.13.002 |
| BC-X.13.003 → VP-CITE-002 (Verification Properties) | VALID — VP-CITE-002 covers BC-X.13.001 and BC-X.13.003 |
| CI-CITE-001 (error-taxonomy.md §8) Tracing BCs → BC-X.13.001, BC-X.13.002, BC-X.13.003 | VALID — all three BC IDs exist in cross-cutting.md |
| arch-delta traces_to → prd-delta + F1 delta analysis | VALID — both files exist |
| verification-delta related_bcs → BC-X.13.001..003 | VALID — all three exist |
| VP-CITE-001, VP-CITE-002 → VP-to-BC Mapping Summary table | VALID — table consistent with VP bodies and BC bodies |

No VP-INDEX or verification-architecture.md exists in this repository (VPs embedded
in BC bodies per project convention). The verification-delta explicitly documents
this. No propagation gap.

---

## Additional Observations

### OBS-1: BC-INDEX.md `last_updated` date is stale

BC-INDEX.md frontmatter shows `last_updated: 2026-06-17`. The DEAD-CITATION-CI
bundle was added 2026-06-19. The `last_updated` field was not bumped when the
Section X.13 rows were added. This is a documentation metadata inconsistency, not
a behavioral one. Non-blocking; note for any future BC-INDEX update.

### OBS-2: Pass-1 "research on develop" assertion superseded by re-scope

Pass 1 §Validation F1 Scope (line 296) stated `.factory/research/` IS on develop,
citing BC-X.13.003 Preconditions from Iteration 1. Iteration 2's re-scope
invalidated this: the current BC-X.13.003 body (line 1075) explicitly states that
`.factory/research/` is ALSO absent from the CI checkout. The Pass-1 observation
about that Iteration-1 Precondition is now superseded. No current artifact says
`.factory/research/` is on develop. RESOLVED by re-scope.

---

## Count Integrity Verification

| Surface | Expected | Actual | Match? |
|---------|----------|--------|--------|
| cross-cutting.md `#### BC-` heading count | 79 | 79 | YES |
| cross-cutting.md frontmatter `definitional_count` | 79 | 79 | YES |
| cross-cutting.md frontmatter `total_bcs` | 145 | 145 | YES |
| CANONICAL-COUNTS per-file row: cross-cutting `76\|76` → `79\|79` | 79\|79 | 79\|79 | YES |
| CANONICAL-COUNTS Total individually-bodied | 370 | 370 | YES |
| CANONICAL-COUNTS per-file `total_bcs` row for cross-cutting | 145 | 145 | YES |
| CANONICAL-COUNTS Sum row | 602 | 602 | YES |
| CANONICAL-COUNTS grand-total prose | 602 | 602 | YES |
| CANONICAL-COUNTS Breakdown prose `total_bcs` reference | 145 | 145 | YES |
| CANONICAL-COUNTS Breakdown prose sum reference | 602 | 602 | YES |
| BC-INDEX.md frontmatter `total_bcs` | 602 | 602 | YES |
| BC-INDEX.md `sections:` line for cross-cutting | 145 BCs; 79 individually-bodied | 145; 79 | YES |
| BC-INDEX.md Section X header | 145 BCs cumulative; 79 individually-bodied | 145; 79 | YES |
| BC-INDEX.md Coverage Statistics table (Section X row) | 145 \| 79 | 145 \| 79 | YES |
| BC-INDEX.md Coverage Statistics Total row | 602 \| 370 | 602 \| 370 | YES |
| CANONICAL-COUNTS historical note parenthetical | 602 | 599 (STALE) | **NO** (P2-N3) |

---

## Verdict

**INCONSISTENT — 0 MAJOR findings, 3 MINOR findings.**

### Pass-1 Status

Both Pass-1 MAJOR findings (F1: definitional counts table stale; F2: Breakdown
prose 142/599) are CONFIRMED FIXED. Pass-1 F3 (9 exclusion rules) is CONFIRMED
FIXED. Pass-1 F4 (VP-CITE-* scheme) is an accepted deviation — no change required.

### New Findings

- **P2-N1 (MINOR):** Pipeline step-letter numbering diverges between BC-X.13.002
  body (a=Glob, f=Dir-prefix, g=Extension) and arch-delta/verification-delta
  (c=Glob, f=Trailing-punct, g=Dir+Extension combined). Behavioral intent is
  identical. BC body is authoritative. Does not block F4 implementation.

- **P2-N2 (MINOR):** Two stale cross-references within cross-cutting.md use
  arch-delta step letters instead of BC body step letters:
  (1) EC-CITE-002 line 954: "step f" should be "step e" for trailing-punct.
  (2) BC-X.13.002 step d line 1007: "step (g)" should be "step (f)" for dir-prefix.
  These are 2-character fixes. Does not block F4 implementation.

- **P2-N3 (MINOR):** CANONICAL-COUNTS historical note line 67 says "current
  canonical... (599)" but current total is 602. Inside archived block; redirect
  to Sum row is correct. Does not affect any automated guard.

### Blocking Assessment

None of the three MINOR findings block the F2 gate or F3/F4 implementation.
The canonical count surfaces all agree at 602 / 370 / 232. The failure message
is single-source-of-truth. The re-scope is clean. The BC/VP/taxonomy chain is
intact. The behavioral pipeline specification in BC-X.13.002 body is correct
and unambiguous.

**F2 Gate Recommendation: PASS with 3 MINOR findings noted above. No blocking
findings remain from Pass 1 or Pass 2.**
