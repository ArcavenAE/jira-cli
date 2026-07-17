---
round: r41
spec_version_checked: 1.3.74
prev_spec_version: 1.3.73
adversary_pass: P34
date: 2026-07-17
verdict: CONSISTENT
medium_gaps: 0
low_gaps: 0
info_findings_new: 0
info_findings_resolved: 0
---

# Consistency Validation Report — Round 41 (cv-576-r41)

**Feature:** SOH-ATTACHMENTS-1 (issues #576 + #585)
**Spec version checked:** v1.3.74 (immediately after adversary-pass-34 fix round)
**Prior spec version:** v1.3.73
**Date:** 2026-07-17
**Verdict:** CONSISTENT — 0 gaps

---

## 1. Scope

This round validates the P34 fix round (v1.3.73 → v1.3.74). P34 closed:
- P34-001 (MEDIUM): PHASE-DOC-RETRO-ANNOTATION at impact-boundary SQ-5 (~line 281) and
  R2.5 (~line 538) — 413→exit-64 language superseded by shipped exit-1
  (BC-3.9.001/BC-3.9.012/error-taxonomy row 102)
- P34-002 (MEDIUM): prd-delta Scope table S3+S5 rows — EC-3.9.017-12 (`--yes` bypass)
  non-public arm explicitly scoped to S3 (VP-576-003 pins EC-3.9.017-10/12); combined arm
  remains S5-realized (VP-576-005); EC-3.9.017-11 (combined single-prompt) remains
  S5-realized
- P34-003 (LOW): prd-delta NEW-R4-002 (~line 226) DEFERRED→RESOLVED + P22-004 (~line 420)
  CONFIRMED→SUPERSEDED (27→28 was a miscount; actual ADR count is 17 incl. ADR-0017;
  CANONICAL-COUNTS already correct)
- P34-004 (LOW): EC-2.7.008-1 JSON-mode clause added; EC-2.7.009-4 empty-issue cross-ref
  added to BC-2.7.009; BC-2.7.008 and BC-2.7.009 Traces updated; bc-2 frontmatter v1.3.74;
  BC-INDEX rows BC-2.7.008/BC-2.7.009 synced; BC-INDEX frontmatter v6.31→v6.32
- P34-005 (INFO): CANONICAL-COUNTS grand-total "+27" corrected to "+33 (=+27+6)"

Protocol: CLOSURE VERIFICATION PROTOCOL — verbatim quotes at claim time, row-level
verification, double-insertion sweep. No spec content, STATE.md, or product source modified.

---

## 2. P34 Fix Item Verification

### 2.1 P34-001 (MEDIUM) — PHASE-DOC-RETRO-ANNOTATION at SQ-5 and R2.5

**Claim:** Two PHASE-DOC-RETRO-ANNOTATION markers added to impact-boundary-576.md at
SQ-5 (~line 281) and R2.5 (~line 538), both annotating that 413→exit-64 language is
superseded by shipped exit-1 per BC-3.9.001/BC-3.9.012/error-taxonomy row 102.

**SQ-5 annotation (impact-boundary-576.md, line 281) — verbatim:**

> **[PHASE-DOC-RETRO-ANNOTATION (P34-001): superseded in shipped spec: 413 → exit 1
> per BC-3.9.001/BC-3.9.012/error-taxonomy row 102 — the graceful-handling ruling
> stands, the exit code refined to 1 (server-side error family) in F2; P34-001.]**

SQ-5 annotation present at line 281. **PASS.**

**R2.5 annotation (impact-boundary-576.md, line 538) — verbatim:**

> **[PHASE-DOC-RETRO-ANNOTATION (P34-001): superseded in shipped spec: 413 → exit 1
> per BC-3.9.001/BC-3.9.012/error-taxonomy row 102 — the graceful-handling ruling
> stands, the exit code refined to 1 (server-side error family) in F2; P34-001.]**

R2.5 annotation present at line 538. **PASS.**

**CANONICAL SURFACE VERIFICATION: Do BC-3.9.001, BC-3.9.012, and error-taxonomy row 102
actually say exit 1 for 413?**

BC-3.9.001 (bc-3-issue-write.md, line 3254) — verbatim excerpt:

> `jr` enforces NO client-side file-size cap. … When the server rejects the upload
> due to size, the response is HTTP 413 (Payload Too Large); `jr` exits 1 with the
> message: `"Attachment too large: the file exceeds the server-configured limit."`
> No numeric limit is stated in the error — the limit is instance-specific and not
> published by `jr`.

Exit 1 on 413 confirmed in BC-3.9.001. **PASS.**

BC-3.9.012 (bc-3-issue-write.md, line 3561) — verbatim row:

> | Attachment too large | 413 | 1 | `"Attachment too large: the file exceeds the
> server-configured limit."` |

Exit 1 on 413 confirmed in BC-3.9.012 table. **PASS.**

Error-taxonomy row 102 (error-taxonomy.md, line 102) — verbatim:

> | 413 — `attachment upload` | `ApiError(413, ...)` | 1 | `"Attachment too large:
> the file exceeds the server-configured limit."` (no numeric limit stated; first 413
> surface in the product; BC-3.9.001/BC-3.9.012) |

Exit 1 on 413 confirmed in error-taxonomy row 102. **PASS.**

All three canonical surfaces cited by the annotation confirm exit 1. The F1 planning
documents said exit 64; the shipped spec says exit 1 (server-side error family). The
annotations correctly capture this F1→F2 divergence while preserving the graceful-handling
intent. No contradiction.

**P34-001 OVERALL: PASS.**

---

### 2.2 P34-002 (MEDIUM) — Scope table S3+S5 EC-3.9.017-12 allocation split

**Claim:** prd-delta-576.md Scope table S3 row: EC-3.9.017-12 non-public arm explicitly
scoped to S3 (VP-576-003 pins EC-3.9.017-10/12). S5 row: EC-3.9.017-12 combined arm
verified in S5 (VP-576-005); EC-3.9.017-11 remains S5-realized.

**S3 scope row (prd-delta-576.md, line 33) — verbatim excerpt of P34-002 split note:**

> **BC-3.9.017 split note (P20-005, P34-002)**: non-public `--replace-existing` path
> (EC-3.9.017-1..10) ships with S3; EC-3.9.017-12 (`--yes` universal bypass) non-public
> arm also ships with S3 (VP-576-003 pins EC-3.9.017-10/12); EC-3.9.017-11 (combined
> single-prompt) and the step-4 BC-3.9.003 public-routing are S5-realized (S5
> depends_on S3 for gate mechanics).

S3 split note present; non-public arm of EC-3.9.017-12 explicitly assigned to S3;
VP-576-003 cited as pin. **PASS.**

**S5 scope row (prd-delta-576.md, line 35) — verbatim excerpt of P34-002 split note:**

> **BC-3.9.017 split note (P20-005, P34-002)**: EC-3.9.017-11 (combined single-prompt)
> and the step-4 BC-3.9.003 `--public` routing are S5-realized; EC-3.9.017-12 (`--yes`
> universal bypass) combined arm is verified in S5 (VP-576-005) — non-public arm already
> ships with S3 (VP-576-003; P34-002)

S5 split note present; EC-3.9.017-11 and EC-3.9.017-12 combined arm assigned to S5;
VP-576-005 cited. **PASS.**

**VP-576-003 pin-list coherence (bc-3-issue-write.md, line 3793) — verbatim excerpt:**

> Pins BC-3.9.017 step-3 → step-4 ordering, the invariant paragraph "no destructive
> API call may be issued while any confirmation gate OR eligibility guard remains
> unresolved," and EC-3.9.017-10/12 (gate fires on match; --yes bypasses).

VP-576-003 explicitly pins EC-3.9.017-10/12. The S3 row's claim "VP-576-003 pins
EC-3.9.017-10/12" is verified against the VP body. **PASS.**

**VP-576-005 pin-list coherence (bc-3-issue-write.md, line 3795) — verbatim excerpt:**

> Pins EC-3.9.017-11 (combined `--public` + ≥1 match → ONE prompt, not two),
> EC-3.9.017-12 (`--yes` single-bypass for all gate conditions), the invariant
> "cancel at gate → zero DELETE + zero POST"…

VP-576-005 explicitly pins both EC-3.9.017-11 and EC-3.9.017-12. The S5 row's claim
"EC-3.9.017-12 combined arm is verified in S5 (VP-576-005)" and "EC-3.9.017-11 (combined
single-prompt) ... S5-realized" is verified against the VP body. **PASS.**

The S1..S5 acceptance-matrix boundaries are fully coherent: no EC arm is scoped to a story
that cannot test it; EC-3.9.017-12 non-public arm lands in S3 (VP-576-003); the combined
arm and EC-3.9.017-11 land in S5 (VP-576-005).

**P34-002 OVERALL: PASS.**

---

### 2.3 P34-003 (LOW) — NEW-R4-002 RESOLVED + P22-004 SUPERSEDED

**Claim:** NEW-R4-002 row (~line 226) status changed DEFERRED→RESOLVED with text
confirming 27→28 was a miscount; P22-004 row (~line 420) status changed
CONFIRMED→SUPERSEDED. CANONICAL-COUNTS ADR section NOT touched.

**NEW-R4-002 row (prd-delta-576.md, line 226) — verbatim:**

> | NEW-R4-002 | INFO | CANONICAL-COUNTS.md | ADR count update (27→28) — RESOLVED:
> 27→28 was a miscount encoding error; actual count 17 incl. ADR-0017; CANONICAL-COUNTS
> verified correct; resolved at pass-22 burst by state-manager (P34-003) | RESOLVED |

Status is RESOLVED. Text correctly explains the resolution (miscount; actual count 17).
**PASS.**

**P22-004 row (prd-delta-576.md, line 420) — verbatim:**

> | P22-004 (INFO) | INFO | prd-delta-576.md | SUPERSEDED | NEW-R4-002 status updated to
> RESOLVED at P34 adjudication: 27→28 was a miscount encoding error; actual count 17
> incl. ADR-0017; CANONICAL-COUNTS verified correct; resolved at pass-22 burst by
> state-manager (P34-003). Previously: NEW-R4-002 deferral text verified present in
> prd-delta-576.md (line 226): "ADR count update (27→28) — DEFERRED to state-manager;
> not assigned to spec-steward". Deferral item now RESOLVED. |

Status is SUPERSEDED. **PASS.**

**CANONICAL-COUNTS ADR section verification (CANONICAL-COUNTS.md, line 158):**

> **Canonical ADR count: 17** (ADR-0001..ADR-0017; all present, no gaps)

Count is 17 — matches the P34-003 resolution claim ("actual count 17 incl. ADR-0017").
CANONICAL-COUNTS was NOT touched for the ADR section by P34 (P34-005 touched only the
grand-total prose at line 55); the ADR section is unchanged. **PASS.**

**P34-003 OVERALL: PASS.**

---

### 2.4 P34-004 (LOW) — EC-2.7.008-1 JSON-mode clause; EC-2.7.009-4; BC-INDEX sync

**Claim:** (1) EC-2.7.008-1: JSON-mode clause added (empty issue → `{"downloaded":[]}`;
hint suppressed; EC-2.7.001-1 unification clarified as STRING-only). (2) EC-2.7.009-4
added to BC-2.7.009 (empty issue on `--newest` follows EC-2.7.008-1). (3) BC-2.7.008
and BC-2.7.009 Traces updated. (4) bc-2 frontmatter trace entry v1.3.74 added. (5) BC-INDEX
rows BC-2.7.008/BC-2.7.009 synced. (6) BC-INDEX frontmatter v6.31→v6.32.

**EC-2.7.008-1 JSON-mode clause (bc-2-issue-read.md, line 794) — verbatim:**

> **EC-2.7.008-1** (empty attachment list): issue has no attachments → exit 0; stderr:
> `"No attachments on <KEY>."` (canonical string — unified with EC-2.7.001-1 for the
> canonical STRING only, not the JSON shape; "found" removed for consistency);
> **JSON mode: stdout `{"downloaded":[]}` (empty array, consistent with EC-2.7.008-6
> uniform `downloaded` array shape); the `"No attachments on <KEY>."` message is a HINT
> — suppressed in JSON mode (per EC-2.7.008-6 hint-vs-error taxonomy; same class as
> EC-2.7.001-1 zero-attachment hint on the list path); no download requests issued.
> P34-004.**

JSON-mode clause present with `{"downloaded":[]}` shape, hint-suppression, EC-2.7.001-1
STRING-only unification, and P34-004 citation. **PASS.**

**EC-2.7.009-4 (bc-2-issue-read.md, line 838) — verbatim:**

> **EC-2.7.009-4** (empty attachment list on `--newest`): when the issue has zero
> attachments, `--newest N` behavior follows EC-2.7.008-1 — exit 0; stderr
> `"No attachments on <KEY>."` (HINT, suppressed in JSON mode); JSON mode: stdout
> `{"downloaded":[]}` (empty array); no download requests issued. P34-004.

EC-2.7.009-4 present with correct cross-ref to EC-2.7.008-1 and P34-004 citation.
**PASS.**

**BC-2.7.008 Trace (bc-2-issue-read.md, line 813) — verbatim excerpt of P34-004 entry:**

> P34-004 (EC-2.7.008-1 JSON-mode clause added: `{"downloaded":[]}` in JSON mode;
> "No attachments on <KEY>." is a HINT suppressed in JSON mode; EC-2.7.001-1
> unification clarified as STRING-only)

BC-2.7.008 Trace updated with P34-004 citation. **PASS.**

**BC-2.7.009 Trace (bc-2-issue-read.md, line 840) — verbatim excerpt of P34-004 entry:**

> P34-004 (EC-2.7.009-4 empty-issue cross-ref to EC-2.7.008-1)

BC-2.7.009 Trace updated with P34-004 citation. **PASS.**

**bc-2 frontmatter trace v1.3.74 (bc-2-issue-read.md, line 24) — verbatim:**

> - v1.3.74 — P34 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): EC-2.7.008-1
>   JSON-mode clause added — empty-issue `--all` returns `{"downloaded":[]}` in JSON
>   mode; `"No attachments on <KEY>."` is a HINT suppressed in JSON mode per EC-2.7.008-6
>   taxonomy; EC-2.7.001-1 unification clarified as canonical STRING only, not JSON shape
>   (P34-004); EC-2.7.009-4 empty-issue cross-ref added to BC-2.7.009 — empty issue on
>   `--newest` follows EC-2.7.008-1 (P34-004); BC-2.7.008 and BC-2.7.009 Trace fields
>   updated.

Frontmatter trace v1.3.74 present and correctly summarizes both EC-2.7.008-1 and
EC-2.7.009-4 changes. **PASS.**

**BC-INDEX BC-2.7.008 row (BC-INDEX.md, line 227) — verbatim excerpt of P34-004 addition:**

> **EC-2.7.008-1 JSON-mode clause (P34-004)**: empty issue → `{"downloaded":[]}` in
> JSON mode; `"No attachments on <KEY>."` is a HINT suppressed in JSON mode;
> EC-2.7.001-1 unification is STRING-only | — (SOH-ATTACHMENTS-1 F2; P25-001; P27-001;
> P27-003; P31-002; P34-004) |

EC-2.7.008-1 JSON-mode clause present in BC-2.7.008 row; P34-004 in sources column.
**PASS.**

**BC-INDEX BC-2.7.009 row (BC-INDEX.md, line 228) — verbatim excerpt of P34-004 addition:**

> **EC-2.7.009-4 empty-issue cross-ref (P34-004)**: empty issue on `--newest` follows
> EC-2.7.008-1 (exit 0; `"No attachments on <KEY>."` HINT suppressed in JSON mode;
> `{"downloaded":[]}`) | — (SOH-ATTACHMENTS-1 F2; P34-004) |

EC-2.7.009-4 cross-ref present in BC-2.7.009 row; P34-004 in sources column. **PASS.**

**BC-INDEX frontmatter (BC-INDEX.md, lines 5–6) — verbatim:**

Line 5 `last_updated`: "2026-07-17  # P34 adversary fix round: BC-2.7.008 EC-2.7.008-1
JSON-mode clause added (P34-004); BC-2.7.009 EC-2.7.009-4 empty-issue cross-ref added
(P34-004); spec v1.3.74; BC count unchanged (657); holdout count 100 (unchanged); VP
count 35 (unchanged); BC-INDEX v6.32. Previous: P32 adversary fix round: BC-2.7.007
`--out` pre-flight ordering pinned…"

Line 6 `index_version`: "v6.32"

BC-INDEX frontmatter bumped v6.31→v6.32; both P34-004 row changes recorded. Note: P33
did not touch BC-INDEX (footer-only fix for bc-3); the "Previous" reference correctly
skips P33 to the last BC-INDEX-touching pass (P32). **PASS.**

**P34-004 OVERALL: PASS.**

---

### 2.5 P34-005 (INFO) — CANONICAL-COUNTS grand-total arithmetic correction

**Claim:** Grand-total prose line ~55: "+27" corrected to "+33 (=+27 initial CREATE
2026-07-15 + 6 round-B BC-3.9.015..020)". Lines 66/79 already correct; unchanged.

**CANONICAL-COUNTS grand-total line (CANONICAL-COUNTS.md, line 55) — verbatim excerpt:**

> **Canonical grand total: 657** (+33 (=+27 initial CREATE 2026-07-15 + 6 round-B
> BC-3.9.015..020) BC-2.7.001..012 + BC-3.9.001..014 + BC-X.8.010 added 2026-07-15
> via SOH-ATTACHMENTS-1 F2 DEC-179 issues #576 #585; …)

Corrected "+33 (=+27+6)" present. Arithmetic: 27 + 6 = 33. ✓ **PASS.**

**CANONICAL-COUNTS line 66 (per-file note) — verbatim:**

> _(Note updated 2026-07-15 SOH-ATTACHMENTS-1 adversary pass-1 round B: 657 total after
> +6 BCs BC-3.9.015..020; was 651 before round B; was 149/624/623 before BC-X.8.010 —
> NEW-004 correction)_

Line 66 already explicitly calls out +6 BCs (BC-3.9.015..020) separately — coherent with
"+33 = +27 + 6". Unchanged by P34. **PASS.**

**CANONICAL-COUNTS line 79 (L2 alignment table bc-3 row) — verbatim:**

> | bc-03-issue-write.md | 140 | bc-3-issue-write.md | 140 | YES (bumped 2026-07-15;
> +14 BCs BC-3.9.001..014 added SOH-ATTACHMENTS-1 F2 DEC-179; +6 BCs BC-3.9.015..020
> added adversary pass-1 round B 2026-07-15) |

Line 79 also explicitly calls out the +6 round-B BCs — coherent with "+33 = +27 + 6".
Unchanged by P34. **PASS.**

**CANONICAL-COUNTS Sum row (line 51):** "**Sum** | **657** |" — Sum 657 consistent
with corrected "+33" total narrative. **PASS.**

**P34-005 OVERALL: PASS.**

---

### 2.6 Spec metadata: spec-changelog.md

`[1.3.74]` entry present at line 10, dated 2026-07-17. Summary correctly states
"2 MEDIUM / 2 LOW / 1 INFO findings." Count table (lines 38–42):

| Metric | Before | After | Delta |
|---|---|---|---|
| BC total | 657 | 657 | 0 |
| Holdout total | 100 | 100 | 0 |
| VP total | 35 | 35 | 0 |

Impact Assessment correctly lists: bc-2-issue-read.md (P34-004), BC-INDEX.md (P34-004),
CANONICAL-COUNTS.md (P34-005), impact-boundary-576.md (P34-001), prd-delta-576.md
(P34-002 + P34-003 + spec_version_after 1.3.74 + P34 dispositions). **PASS.**

---

### 2.7 Spec metadata: prd-delta-576.md frontmatter and P34 dispositions

- `spec_version_after: 1.3.74` at line 8 ✓
- P34 dispositions section (lines 617–629) contains all 5 finding dispositions ✓
- P34-001: APPLIED; P34-002: APPLIED; P34-003: APPLIED; P34-004: APPLIED;
  P34-005: APPLIED ✓
- ECHO-BREAKER LIST-A correctly enumerates all five changed artifacts ✓
- ECHO-BREAKER LIST-B: EMPTY (no holdout changes in P34) ✓

**PASS.**

---

## 3. Double-Insertion Sweep

Counts of P34 marker occurrences across all affected documents:

| File | P34-001 | P34-002 | P34-003 | P34-004 | P34-005 |
|------|---------|---------|---------|---------|---------|
| impact-boundary-576.md | 2 (SQ-5 line 281; R2.5 line 538) | 0 | 0 | 0 | 0 |
| prd-delta-576.md | 1 (dispositions) | 4 (S3, S5, dispositions, ECHO-BREAKER) | 4 (NEW-R4-002, P22-004, dispositions, ECHO-BREAKER) | 0 | 0 |
| bc-2-issue-read.md | 0 | 0 | 0 | 5 (frontmatter, EC-2.7.008-1, EC-2.7.009-4, BC-2.7.008 Trace, BC-2.7.009 Trace) | 0 |
| BC-INDEX.md | 0 | 0 | 0 | 3 (frontmatter, BC-2.7.008 row, BC-2.7.009 row) | 0 |
| CANONICAL-COUNTS.md | 0 | 0 | 0 | 0 | 0* |
| spec-changelog.md | 3 (summary, changed-reqs, impact table) | 3 | 3 | 3 | 3 |

*P34-005 correction to CANONICAL-COUNTS is a prose-only arithmetic fix ("+27" → "+33
(=+27+6)"); no inline "(P34-005)" citation is embedded in CANONICAL-COUNTS body. The
spec-changelog entry for P34-005 carries the cite. This is the expected pattern for prose
corrections (same as prior BC-count corrections). EXPECTED; not an anomaly.

**impact-boundary breakdown:** P34-001 at exactly two annotation sites (SQ-5 line 281 +
R2.5 line 538) — both expected. Zero occurrences elsewhere in the file. No unintended
propagation.

**No unexpected duplicates detected. PASS.**

---

## 4. Keystone Verification

### K-1 — 413 story: impact-boundary annotations ↔ BC-3.9.001 ↔ BC-3.9.012 ↔ error-taxonomy row 102

One exit-1 story, F1 divergence properly annotated.

1. **SQ-5 annotation** (line 281): "413 → exit 1 per BC-3.9.001/BC-3.9.012/error-taxonomy
   row 102 — the graceful-handling ruling stands, the exit code refined to 1 (server-side
   error family) in F2." ✓
2. **R2.5 annotation** (line 538): identical text to SQ-5 annotation. ✓
3. **BC-3.9.001** (line 3254): "jr exits 1" on 413. ✓
4. **BC-3.9.012** (line 3561): "| Attachment too large | 413 | 1 |..." ✓
5. **error-taxonomy row 102** (line 102): "| 413 — `attachment upload` | `ApiError(413, ...)`
   | 1 |..." ✓
6. The F1 documents said "exit 64" (SQ-5 original text; R2.5 original text). The
   annotations preserve the F1 history while redirecting the exit code to the correct
   shipped value. No contradiction anywhere in the canonical spec. ✓

**K-1: PASS — one uniform exit-1 story, F1 divergence properly annotated.**

---

### K-2 — EC-3.9.017-11/12 allocation: Scope rows ↔ VP pins ↔ EC bodies

S1..S5 acceptance-matrix boundaries fully coherent, no EC arm scoped to a story that
cannot test it.

1. **EC-3.9.017-12 non-public arm → S3** (VP-576-003, bc-3 line 3793 pins
   EC-3.9.017-10/12): S3 scope row confirmed; VP body confirmed. ✓
2. **EC-3.9.017-11 → S5** (VP-576-005, bc-3 line 3795 pins EC-3.9.017-11): S5 scope
   row confirmed; VP body confirmed. ✓
3. **EC-3.9.017-12 combined arm → S5** (VP-576-005 also pins EC-3.9.017-12): S5 scope
   row says "EC-3.9.017-12 combined arm is verified in S5 (VP-576-005)"; VP body confirms
   "Pins EC-3.9.017-12 (`--yes` single-bypass for all gate conditions)." ✓
4. **P23-003/P24-002 allocation-note precedents** (S5 depends_on S3 for gate mechanics
   from P14-007/P15-002): coherent — S3 carries the gate mechanics; S5 uses them. ✓

No EC arm is split across stories in an untestable way. The non-public arm of EC-3.9.017-12
is a non-JSM path (no servicedesk GETs), fully testable in S3. The combined arm requires
JSM project setup, correctly deferred to S5.

**K-2: PASS — allocation fully coherent across scope rows, VP pins, and EC bodies.**

---

### K-3 — empty-vs-filtered-to-zero symmetry: four zero-result paths all explicit

EC-2.7.008-1 (P34-004 new clause) ↔ EC-2.7.008-10 ↔ EC-2.7.009-3/4 ↔ EC-2.7.001-1

1. **EC-2.7.008-1** (empty issue, `--all`): `{"downloaded":[]}` in JSON; hint suppressed
   per EC-2.7.008-6 taxonomy; STRING-only unification with EC-2.7.001-1. ✓ (line 794)
2. **EC-2.7.008-10** (filtered-to-zero, non-empty issue, `--all`): `{"downloaded":[]}` in
   JSON; filtered-message hint suppressed ("same class as EC-2.7.001-1"). ✓ (line 811)
3. **EC-2.7.009-3** (filtered-to-zero, `--newest`): `{"downloaded":[]}` in JSON; hint
   suppressed ("same class as EC-2.7.008-10"). ✓ (line 836)
4. **EC-2.7.009-4** (empty issue, `--newest`, P34-004 new EC): follows EC-2.7.008-1;
   `{"downloaded":[]}` in JSON; `"No attachments on <KEY>."` HINT suppressed. ✓ (line 838)

All four zero-result paths now have explicit JSON shape (`{"downloaded":[]}`) and hint
classification (suppressed in JSON mode). All four are mutually consistent (same JSON shape,
same hint-suppression taxonomy). The P34-004 addition of EC-2.7.008-1's JSON-mode clause
and EC-2.7.009-4 completes the symmetry set.

**K-3: PASS — all four zero-result paths coherent and complete.**

---

### K-4 — ADR-ledger closure: no surface still claims a pending ADR-count deferral

1. **prd-delta NEW-R4-002** (line 226): Status = RESOLVED. ✓
2. **prd-delta P22-004** (line 420): Status = SUPERSEDED. ✓
3. **CANONICAL-COUNTS ADR section** (line 158): "**Canonical ADR count: 17**" — matches
   P34-003 adjudication ("actual count 17 incl. ADR-0017"). ✓
4. No other file claims a pending "ADR count 27→28" deferral (the miscount never appeared
   in CANONICAL-COUNTS body; it was only in prd-delta NEW-R4-002). ✓

**K-4: PASS — ADR-ledger fully closed; no pending deferral claim anywhere.**

---

## 5. Standard Checks

### 5A. Full application, claimed-location verification, no duplicates

All five P34 items verified at their claimed locations (§2.1–2.5). Double-insertion sweep
(§3) confirms no unexpected duplicates. **PASS.**

### 5B. Counts 657/100/35 everywhere; spec v1.3.74; BC-INDEX v6.32

Confirmed at:

- spec-changelog [1.3.74] count table (lines 39–42): BC 657/657/0; holdout 100/100/0;
  VP 35/35/0 ✓
- BC-INDEX frontmatter (line 5): "BC count unchanged (657); holdout count 100 (unchanged);
  VP count 35 (unchanged); BC-INDEX v6.32" ✓
- prd-delta frontmatter: `spec_version_after: 1.3.74` ✓
- CANONICAL-COUNTS Sum row (line 51): 657 ✓

**PASS.**

### 5C. Both guard scripts

Both guard scripts run against v1.3.74 state and exit 0:

- `scripts/check-spec-counts.sh` — exit 0: "OK: all spec counts verified."
- `scripts/check-bc-cumulative-counts.sh` — exit 0: "OK: all cumulative BC counts
  verified (657 total across 8 files; Surface H footer checked where present)."

**PASS.**

### 5D. Echo-breaker audit

**List A — sample 4 items (verbatim quote + licensing):**

1. **impact-boundary-576.md SQ-5 annotation** (line 281): "PHASE-DOC-RETRO-ANNOTATION
   (P34-001): superseded in shipped spec: 413 → exit 1 per BC-3.9.001/BC-3.9.012/
   error-taxonomy row 102 — the graceful-handling ruling stands, the exit code refined to
   1 (server-side error family) in F2; P34-001." — Licensed by BC-3.9.001 and error-taxonomy
   row 102 (both confirm exit 1); annotation only, no behavioral change. ✓

2. **EC-2.7.008-1 JSON-mode clause** (bc-2 line 794): "JSON mode: stdout `{"downloaded":[]}`
   (empty array, consistent with EC-2.7.008-6 uniform `downloaded` array shape)" — Licensed
   by EC-2.7.008-6 shape invariant; symmetric with EC-2.7.008-10 filtered-to-zero JSON
   path. ✓

3. **BC-2.7.009 Trace P34-004 entry** (bc-2 line 840): "P34-004 (EC-2.7.009-4 empty-issue
   cross-ref to EC-2.7.008-1)" — Trace marker is an internal citation, not a behavioral
   claim. ✓

4. **CANONICAL-COUNTS grand-total** (line 55): "+33 (=+27 initial CREATE 2026-07-15 + 6
   round-B BC-3.9.015..020)" — Arithmetic 27+6=33 confirmed; consistent with lines 66 and
   79 which explicitly enumerate the +6 round-B BCs. ✓

**List B — empty-claim verification:**

Grep of "P34" in holdout-scenarios.md: **zero results.** No holdout assertions changed in
P34. ECHO-BREAKER LIST-B empty claim confirmed. **PASS.**

### 5E. INFO ledger

**Re-verified carry-forward items:**

| ID | Description | Fresh-quote status |
|----|-------------|-------------------|
| INFO-1 | Triple blank lines in bc-2 between EC-2.7.008-6 and EC-2.7.008-7 | CONFIRMED — bc-2 lines 802–804 (three blank lines between EC-2.7.008-6 ending at line 801 and EC-2.7.008-7 starting at line 805). |
| INFO-2 | EC-2.7.008-5 supersedes EC-2.7.008-2 but EC-2.7.008-2 body has no explicit supersession marker | CONFIRMED — bc-2 line 796: "**EC-2.7.008-2** (directory does not exist): …" — no "(superseded by EC-2.7.008-5)" note on the body. Line 800 EC-2.7.008-5 says "supersedes EC-2.7.008-2 wording clarification" but the reverse pointer on EC-2.7.008-2 is absent. |
| INFO-3 | BC-2.7.012 combined-scope (download+upload) BC-INDEX row — no explicit "download-only scope" comment | CONFIRMED — BC-2.7.012 BC-INDEX row and body cover attachment-download error taxonomy; P34 did not touch BC-2.7.012; no explicit "download-only" scope comment added. |
| INFO-6 | No holdout scenario for collision-skip exit-0 path | CONFIRMED — LIST-B is empty (no holdout changes in P34); collision-skip exit-0 path (BC-2.7.008 `--force` absent) still has no dedicated holdout scenario. |
| INFO-8 | STATE.md spec version stale | CONFIRMED — STATE.md `current_step` and phase rows reference "spec v1.3.73" and "PASS-33 REMEDIATED"; v1.3.74 not yet recorded. |
| INFO-15 | impact-boundary-576.md BC-3.9.004 INCONCLUSIVE annotation | CONFIRMED — impact-boundary-576.md line 159 still reads "(key order shown is illustrative; shape INCONCLUSIVE pending S5 live capture — if curated per BC-2.7.002, BTreeMap-alphabetical applies, P19-001)"; P34-001 annotations did not touch BC-3.9.004 row. |
| INFO-NEW-5 | BC-3.9.009 Trace field not updated with P24-001 citation | CONFIRMED — bc-3-issue-write.md BC-3.9.009 Trace (around line 3489) reads "F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); JSON render invariant #526 (`output::render_json` required for all `--output json` paths)" — no P24-001 citation. P34 did not touch bc-3; carry-forward unchanged. |

**INFO-11 retirement:**

INFO-11 (spec-changelog [1.3.57] and prd-delta P17-002 "three sites" vs four) was carried
from prior rounds with "may be stale" notation. Fresh search in this round confirms
spec-changelog line 512 and prd-delta P17-002 both say "All four sites"; the discrepancy
text is not locatable in any current document. **INFO-11 is hereby retired as stale.** The
r40 report's fresh-quote confirmed this but left it as carry-forward pending explicit
resolution; this round provides that explicit resolution. INFO carry-forward count goes
from 8 (r40) to 7 (r41).

**New INFO findings from P34:** Zero. The five P34 items were 2 MEDIUM + 2 LOW + 1 INFO
(P34-005, APPLIED); no new tracking INFOs opened.

---

## 6. Summary

| Category | Count |
|----------|-------|
| P34 fix items verified PASS | 5 / 5 |
| MEDIUM gaps | 0 |
| LOW gaps | 0 |
| INFO findings (new) | 0 |
| INFO findings (resolved/retired) | 1 (INFO-11 retired as stale) |
| INFO carry-forward | 7 (INFO-1..3, INFO-6, INFO-8, INFO-15, INFO-NEW-5) |
| Echo-breaker violations | 0 |
| Double-insertion anomalies | 0 |
| Guard script failures | 0 |

**Verdict: CONSISTENT.**

All five P34 fix items verified present at the claimed locations with correct content.
Keystones K-1 through K-4 are all coherent. Counts 657/100/35 confirmed unchanged by
both guard scripts. BC-INDEX v6.32 confirmed. INFO-11 retired as stale (discrepancy text
not locatable in either cited source). No new gaps found in this round.
