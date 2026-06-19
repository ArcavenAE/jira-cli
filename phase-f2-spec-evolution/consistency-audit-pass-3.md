---
document_type: consistency-audit
bundle: DEAD-CITATION-CI
phase: F2
iteration: 3
auditor: consistency-validator
created: 2026-06-19
scope: pass-3 — verify pass-2 MINORs fixed; check for new drift from iteration-3 revisions
verdict: CONSISTENT (0 MAJOR, 0 MINOR findings)
---

# F2 Consistency Audit — DEAD-CITATION-CI (Pass 3)

**Scope:** Verify that all three Pass-2 MINOR findings (P2-N1 step-letter scheme
divergence; P2-N2 two stale step-letter cross-refs in cross-cutting.md; P2-N3
CANONICAL-COUNTS historical note "(599)") are resolved in iteration-3 artifacts.
Detect any new drift introduced by iteration-3 revisions.
Checks: count-guard scripts (all 3), failure-message SSOT, re-scope language,
BC/VP/taxonomy chain, pipeline step-letter consistency.

---

## Count-Guard Script Results

| Script | Exit Code | Result |
|--------|-----------|--------|
| `scripts/check-spec-counts.sh` | 0 | OK |
| `scripts/check-bc-cumulative-counts.sh` | 0 | OK — all 8 surfaces agree at 602 total |
| `scripts/check-bc-no-numeric-test-counts.sh` | 0 | OK |

All three automated guards pass at exit 0.

---

## Documents Reviewed

| Document | Path |
|----------|------|
| PRD delta (iteration 2) | `.factory/phase-f2-spec-evolution/prd-delta-DEAD-CITATION-CI.md` |
| Architecture delta | `.factory/phase-f2-spec-evolution/arch-delta-DEAD-CITATION-CI.md` |
| Verification delta | `.factory/phase-f2-spec-evolution/verification-delta-DEAD-CITATION-CI.md` |
| BC bodies | `.factory/specs/prd/cross-cutting.md` (§X.13, lines ~920–1130) |
| BC-INDEX | `.factory/specs/prd/BC-INDEX.md` |
| CANONICAL-COUNTS | `.factory/specs/prd/CANONICAL-COUNTS.md` |
| Error taxonomy | `.factory/specs/prd/error-taxonomy.md` |

---

## Summary Table

| # | Finding | Severity | Status |
|---|---------|----------|--------|
| Pass-1 F1 | CANONICAL-COUNTS definitional table stale (76/367) | MAJOR | FIXED (verified pass 2) |
| Pass-1 F2 | CANONICAL-COUNTS Breakdown prose stale (142/599) | MAJOR | FIXED (verified pass 2) |
| Pass-1 F3 | "9 exclusion rules" count inconsistency | MINOR | FIXED (verified pass 2) |
| Pass-1 F4 | VP-CITE-* ID scheme deviation | MINOR | ACCEPTED deviation (documented) |
| **P2-N1** | **Step-letter scheme divergence: BC-X.13.002 body vs arch-delta** | **MINOR** | **FIXED** |
| **P2-N2** | **Two stale cross-references within cross-cutting.md** | **MINOR** | **FIXED** |
| **P2-N3** | **CANONICAL-COUNTS historical note "(599)" stale** | **MINOR** | **FIXED** |
| No new findings | — | — | PASS |

---

## Pass-2 MINOR Finding Verification

### P2-N1 (was MINOR): Step-letter scheme divergence — FIXED

**What Pass 2 found:** arch-delta used a different (a)–(h) scheme from BC body,
where extraction occupied (a)+(b) and normalization started at (c).

**Current state of arch-delta (lines 42–64):** The arch-delta now uses extraction as
an unnumbered "Two-step extraction (pre-pipeline, unnumbered — SR-001)" prefix — the
SAME structure as BC-X.13.002 body. The normalization/skip pipeline in arch-delta is:

```
(a) Glob skip
(b) Symbol-form strip
(c) Line-ref strip
(d) Section-ref
(e) Punctuation trim
(f) Dir-prefix filter
(g) Extension filter
(h) Path::exists() check
```

This matches BC-X.13.002 body (lines 1005–1014) letter-for-letter. The extraction
sub-steps are described separately before the labeled pipeline in both documents.

**Verification-delta table:** The verification-delta exclusion table (VP-CITE-001,
lines 63–79) also uses the updated scheme:
- (f) Dir-prefix filter — section ref: `§9` excluded by dir-prefix filter
- (g) Extension filter: extensionless token not in output

Both (f) = dir-prefix and (g) = extension — matching BC body.

**P2-N1 is RESOLVED.** The arch-delta and verification-delta now share the same
(a)–(h) step-letter assignment as the authoritative BC-X.13.002 body.

---

### P2-N2 (was MINOR): Two stale cross-references within cross-cutting.md — FIXED

**What Pass 2 found:**
1. EC-CITE-002 (line 954): said "BC-X.13.002 step f" for trailing-punct — wrong step letter
2. BC-X.13.002 step d (line 1007): said "at step (g)" for dir-prefix filter — wrong step letter

**Current state of cross-cutting.md:**

**Error 1 (EC-CITE-002, line 954):**
```
- EC-CITE-002: A citation uses `Detail: path1, path2` comma-delimited form → both
  tokens extracted (interior whitespace tokenization); trailing comma stripped by
  trailing-punct rule (BC-X.13.002 step (e)) → both checked independently
```
Now correctly says "step (e)" — trailing-punct trim is step (e) in the BC body's own
pipeline. **FIXED.**

**Error 2 (BC-X.13.002 step d body, line 1008):**
```
d. **Section-ref**: `§9`-style tokens lack a known directory prefix and are excluded by the
   dir-prefix filter at step (f); whitespace tokenization has already separated them from the
   preceding path.
```
Now correctly says "step (f)" — dir-prefix filter is step (f) in the BC body's own
pipeline. **FIXED.**

Both two-character fixes are confirmed in place. The cross-references within
BC-X.13.002 body now reference the correct steps from its own pipeline.

---

### P2-N3 (was MINOR): CANONICAL-COUNTS historical note "(599)" stale — FIXED

**What Pass 2 found:** CANONICAL-COUNTS.md line 67 said "current canonical: see Sum
row above (599)" but Sum row shows 602.

**Current state of CANONICAL-COUNTS.md (line 67):**
```
_Historical note (archived; historical total was 566; current canonical: see Sum row
above (602)): Passes 10-13 involved a 541/542 count confusion around BC-X.4.009...
```

The parenthetical now reads **(602)**, consistent with the Sum row on line 51 and
the grand-total prose on line 55. **FIXED.**

---

## Audit Item Checks

### 1. Pipeline step-letter consistency: BC-X.13.002 body == arch-delta §2 == verification-delta table

**CONSISTENT.** All three documents now use the same scheme:
- Extraction: unnumbered two-step prefix
- (a) Glob skip / (b) Symbol-form strip / (c) Line-ref strip / (d) Section-ref
- (e) Trailing/leading punctuation trim
- (f) Dir-prefix filter (`.factory/` excluded here)
- (g) Extension filter
- (h) Path::exists() check

The arch-delta step d body (line 52) says "excluded by the dir-prefix filter at
step (f)" — consistent with BC body step d (line 1008) which now also says "step (f)".
The verification-delta exclusion table rows labeled (f) describe dir-prefix exclusions;
the row labeled (g) describes the extension filter — both match the BC body.

No letter-for-letter divergence remains across any of the three documents.

### 2. Count integrity: 602 / definitional 370 / range-collapsed 232

**CONSISTENT across all surfaces.**

| Surface | Value | Match? |
|---------|-------|--------|
| `scripts/check-bc-cumulative-counts.sh` exit code | 0 | YES |
| `scripts/check-spec-counts.sh` exit code | 0 | YES |
| CANONICAL-COUNTS.md Sum row | 602 | YES |
| CANONICAL-COUNTS.md Total individually-bodied | 370 | YES |
| CANONICAL-COUNTS.md historical note parenthetical | 602 | YES (was 599, now fixed) |
| BC-INDEX.md frontmatter `total_bcs` | 602 | YES |
| BC-INDEX.md Section X header | 145 BCs; 79 individually-bodied | YES |
| BC-INDEX.md Coverage Statistics Total row | 602 \| 370 | YES |
| cross-cutting.md frontmatter `total_bcs` | 145 | YES |
| cross-cutting.md frontmatter `definitional_count` | 79 | YES |
| cross-cutting.md `#### BC-` heading count | 79 | YES |
| prd-delta "602" sum claim | 602 | YES |

Definitional (370) + range-collapsed (232) = 602. Confirmed.

### 3. Failure message single-source-of-truth: CI-CITE-001 == BC-X.13.001 == arch-delta == verification-delta == prd-delta

**CONSISTENT.** The canonical four-line failure message is:
```
CLAUDE.md cites file paths that do not exist on disk:
  <path> (line N)
Fix the citation or restore the file.
Note: .factory/, glob, and symbol-form tokens are auto-excluded.
```

| Source | Contains canonical message? |
|--------|----------------------------|
| `error-taxonomy.md` §CI-CITE-001 Message format | YES — authoritative |
| `cross-cutting.md` BC-X.13.001 Postconditions (failure) | YES — verbatim code block |
| `arch-delta-DEAD-CITATION-CI.md` §2 code block | YES — verbatim code block |
| `verification-delta-DEAD-CITATION-CI.md` VP-CITE-002 test code | YES — as Rust string literal with `\n` escapes |
| `prd-delta-DEAD-CITATION-CI.md` §Canonical Failure Message | YES — verbatim code block |

No divergent variant exists. No "add to allowlist" hint sentence anywhere.

### 4. Re-scope: no surviving allowlist/"research checked" language

**CONSISTENT.** Scanned cross-cutting.md, error-taxonomy.md, all three F2 delta files.

Every occurrence of "allowlist", "off-branch", "off_working_branch", "is_off_working_branch_allowlisted",
"research is checked" is in ONE of:
- Explicitly SUPERSEDED context ("the old 'off-branch allowlist' design is SUPERSEDED")
- Prohibition context ("There is NO `is_off_working_branch_allowlisted` function")
- Historical narrative explaining the old design was incorrect
- "Do not implement" instructions in arch-delta §2

No occurrence positively endorses the old allowlist behavior. BC-X.13.003 body
comprehensively states the all-exclude rule. EC-CITE-017 through EC-CITE-021 all
illustrate `.factory/` sub-paths that are excluded with no carve-outs.

### 5. BC/VP/taxonomy chain: all cited IDs/paths resolve; prd-delta no longer references non-existent VP-INDEX

**INTACT.**

| Chain | Status |
|-------|--------|
| BC-X.13.001 → VP-CITE-001, VP-CITE-002 | VALID — both VPs in verification-delta |
| BC-X.13.002 → VP-CITE-001 | VALID |
| BC-X.13.003 → VP-CITE-002 | VALID |
| CI-CITE-001 (error-taxonomy §8) → BC-X.13.001, BC-X.13.002, BC-X.13.003 | VALID — all three exist |
| arch-delta `traces_to` → prd-delta + F1 delta analysis | VALID — both files exist |
| verification-delta `related_bcs` → BC-X.13.001..003 | VALID |
| VP-CITE-001, VP-CITE-002 → VP-to-BC Mapping Summary table | VALID |
| prd-delta VP citation section | VALID — correctly states "this repository does NOT have a VP-INDEX or verification-architecture.md" (no stale reference to non-existent VP-INDEX) |

No VP-INDEX or verification-architecture.md exists in this repository; VPs are
embedded in BC bodies per project convention. The verification-delta's Project
Convention Note explicitly documents this. No propagation gap.

---

## Additional Observations (Carry-Forward)

### OBS-1 (carry-forward from pass 2): BC-INDEX.md `last_updated` is 2026-06-17

BC-INDEX.md frontmatter `last_updated: 2026-06-17` has not been updated to
2026-06-19 (the date BC-X.13.001..003 were added). This is a documentation
metadata inconsistency only — the functional content (rows, counts, totals) in
BC-INDEX.md is correct. Non-blocking; note for any future BC-INDEX update.
Not assigned a severity finding per prior pass precedent.

---

## Verdict

**CONSISTENT — 0 MAJOR findings, 0 MINOR findings.**

### Pass-2 MINOR Status

All three Pass-2 MINOR findings are CONFIRMED FIXED in iteration-3 artifacts:

- **P2-N1 RESOLVED:** arch-delta §2 pipeline now uses extraction as an unnumbered
  prefix and steps (a)–(h) matching BC-X.13.002 body letter-for-letter. The
  verification-delta exclusion table uses the same scheme. No step-letter divergence
  remains across any of the three F2 documents.

- **P2-N2 RESOLVED:** Both stale cross-references in cross-cutting.md are corrected:
  (1) EC-CITE-002 line 954 now says "BC-X.13.002 step (e)" for trailing-punct.
  (2) BC-X.13.002 step d body (line 1008) now says "at step (f)" for dir-prefix filter.

- **P2-N3 RESOLVED:** CANONICAL-COUNTS.md historical note line 67 now says "(602)"
  consistent with the Sum row. No stale "(599)" parenthetical remains.

### Count Guards

All three count guard scripts exit 0. The 602/370/232 split is consistent across
all 8 canonical surfaces.

### Blocking Assessment

No MAJOR or MINOR findings. No blocking issues from any prior pass remain open.
The canonical count surfaces agree at 602 / definitional 370 / range-collapsed 232.
The failure message is single-source-of-truth across all five surfaces. The re-scope
is clean with no allowlist language. The BC/VP/taxonomy chain is intact. The pipeline
step-letter scheme is now consistent across BC body, arch-delta, and verification-delta.

**F2 Gate Recommendation: PASS. No blocking findings. All pass-2 MINORs resolved.**
