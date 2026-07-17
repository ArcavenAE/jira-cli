---
round: r40
spec_version_checked: 1.3.71
prev_spec_version: 1.3.70
adversary_pass: P31
date: 2026-07-17
verdict: CONSISTENT
medium_gaps: 0
low_gaps: 0
info_findings_new: 0
info_findings_resolved: 0
---

# Consistency Validation Report — Round 40 (cv-576-r40)

**Feature:** SOH-ATTACHMENTS-1 (issues #576 + #585)
**Spec version checked:** v1.3.71 (immediately after adversary-pass-31 fix round)
**Prior spec version:** v1.3.70
**Date:** 2026-07-17
**Verdict:** CONSISTENT — 0 gaps

---

## 1. Scope

This round validates the P31 fix round (v1.3.70 → v1.3.71). P31 closed:
- P31-001 (LOW): H-NEW-ATTACHMENT-002 error-path exit assertion over-permissive — tightened to
  "Exit code = 1 (EC-2.7.007-4 mid-stream error; BC-2.7.012 5xx row)"
- P31-002 (LOW): manifest `size` = bytes-written uniformly across single and batch paths —
  BC-2.7.008 Batch metadata source scoped; EC-2.7.008-6 `size` semantics sentence added;
  "Shape aligns" → "Shape and field semantics align"
- P31-003 (INFO): BC-3.9.012 step-1 carve-out post-retry 401/5xx/network sentence added to
  eliminate "first occurrence" ambiguity

Protocol: CLOSURE VERIFICATION PROTOCOL — verbatim quotes at claim time, row-level
verification, double-insertion sweep. No spec content, STATE.md, or product source modified.

---

## 2. P31 Fix Item Verification

### 2.1 P31-001 (LOW) — H-NEW-ATTACHMENT-002 exit assertion tightened

**Claim:** H-NEW-ATTACHMENT-002 error-path Expected assertion changed from
"Exit code != 0 (exit 1 or exit 64)" to "Exit code = 1 (EC-2.7.007-4 mid-stream error;
BC-2.7.012 5xx row)"; holdout frontmatter trace entry added.

**Holdout-scenarios.md Expected (error path), line 2138 — verbatim:**

> - Exit code = 1 (EC-2.7.007-4 mid-stream error; BC-2.7.012 5xx row).

Verification: Tightened assertion present. **PASS.**

**Holdout-scenarios.md frontmatter trace (line 26) — verbatim:**

> - SOH-ATTACHMENTS-1 adversary pass-31 (2026-07-17, P31): H-NEW-ATTACHMENT-002
>   error-path Expected exit-code tightened — "Exit code != 0 (exit 1 or exit 64)" →
>   "Exit code = 1 (EC-2.7.007-4 mid-stream error; BC-2.7.012 5xx row)" (P31-001);
>   holdout count unchanged (100)

Trace entry present at line 26. **PASS.**

**CONFORMANCE CHECK: Is "Exit code = 1" derivable from EC-2.7.007-4 and BC-2.7.012 5xx row?**

EC-2.7.007-4 (bc-2-issue-read.md, line 758) — verbatim:

> **EC-2.7.007-4** (error mid-stream): temporary file (`tmp_<random>`) deleted; exit 1;
> `"Download failed: <reason>"` on stderr; final path not written.

EC-2.7.007-4 unambiguously mandates exit 1 on mid-stream error. **PASS.**

BC-2.7.012 5xx row (bc-2-issue-read.md, line 949) — verbatim:

> | KEY or AID 5xx | 1 | `API error (<N>)` (single mode; batch mode: per-file
> fail-soft per BC-2.7.008) |

The H-NEW-ATTACHMENT-002 fixture mounts a metadata-200/content-500 response; content-GET
returns HTTP 500 (5xx), which is an "error mid-stream" under EC-2.7.007-4. The BC-2.7.012
5xx row gives exit 1 for this condition. Exit code 1 is therefore the only conformant code
for this fixture — the prior "exit 1 or exit 64" formulation was over-permissive. The
tightening is fully licensed by both cited clauses. **PASS.**

P31-001 OVERALL: **PASS.**

---

### 2.2 P31-002 (LOW) — manifest `size` = bytes written uniformly

**Claim:** (1) EC-2.7.008-6 `size` semantics sentence added; (2) BC-2.7.008 Batch metadata
source sentence scoped to naming/filtering/pre-download; (3) "Shape aligns" →
"Shape and field semantics align"; (4) BC-2.7.008 Trace updated; (5) BC-INDEX row updated.

**EC-2.7.008-6 `size` semantics sentence (bc-2-issue-read.md, line 799) — verbatim excerpt:**

> **`size` semantics (P31-002)**: `downloaded[].size` is the byte count written to disk —
> identical semantics to EC-2.7.007-7 — NOT the `fields.attachment[].size` value from the
> list response. In normal operation the two coincide (the atomic rename fires only on a
> complete stream), but written-bytes is authoritative. Shape and field semantics align with
> EC-2.7.007-7 for a uniform download response type.

Size semantics sentence present; "Shape and field semantics align" phrase present. **PASS.**

**BC-2.7.008 Batch metadata source (bc-2-issue-read.md, line 784) — verbatim excerpt:**

> **Batch metadata source**: filename, size, and `contentUrl` for each attachment are taken
> directly from `fields.attachment[]` in this list response for NAMING, filtering, and
> pre-download purposes; the manifest `size` field is the byte count written to disk per
> EC-2.7.008-6, NOT the list-reported `fields.attachment[].size` (in normal operation the
> two coincide since the atomic rename fires only on a complete stream, but written-bytes
> is authoritative).

Batch metadata source sentence scoped to NAMING/filtering/pre-download; manifest `size`
explicitly distinguished from list-reported `size`. **PASS.**

**BC-2.7.008 Trace (bc-2-issue-read.md, line 811) — verbatim excerpt:**

> P31-002 (EC-2.7.008-6 `size` semantics sentence added: written-bytes authoritative,
> NOT list-reported `fields.attachment[].size`; "Shape aligns" → "Shape and field semantics
> align"; Batch metadata source scoped: list response for naming/filtering/pre-download;
> manifest `size` = written-bytes)

Trace entry present. **PASS.**

**BC-INDEX BC-2.7.008 row (line 227) — verbatim excerpt:**

> **Batch metadata source scoped (P31-002)**: list response for NAMING/filtering/pre-download;
> manifest `size` = bytes written to disk (NOT list-reported `fields.attachment[].size`);
> EC-2.7.008-6 `size` semantics sentence added; "Shape aligns" → "Shape and field semantics
> align" | — (SOH-ATTACHMENTS-1 F2; P25-001; P27-001; P27-003; P31-002)

BC-INDEX row synced with P31-002 content. **PASS.**

**bc-2-issue-read.md frontmatter v1.3.71 trace entry (line 22) — verbatim:**

> - v1.3.71 — P31 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): BC-2.7.008 Batch
>   metadata source scoped — list response for NAMING/filtering/pre-download; manifest
>   `size` = written-bytes per EC-2.7.008-6 (P31-002); EC-2.7.008-6 `size` semantics
>   sentence added — written-bytes authoritative, NOT list-reported
>   `fields.attachment[].size`; "Shape aligns" → "Shape and field semantics align"
>   (P31-002); BC-2.7.008 Trace updated.

Frontmatter trace entry v1.3.71 present. **PASS.**

P31-002 OVERALL: **PASS.**

---

### 2.3 P31-003 (INFO) — BC-3.9.012 carve-out post-retry 401/5xx/network sentence

**Claim:** A sentence added to BC-3.9.012 carve-out covering post-retry 401/5xx/network
responses, aligned with BC-X.8.010 step 4 codes; BC-3.9.012 Trace updated; BC-INDEX row
updated.

**BC-3.9.012 carve-out (bc-3-issue-write.md, line 3568) — verbatim (added sentence):**

> A post-retry 401/5xx/network response maps per BC-X.8.010 step 4 (401 → exit 2;
> 5xx/network → exit 1) — the same universal codes as first-occurrence.

New sentence present appended to the pre-existing carve-out paragraph. **PASS.**

**VERBATIM ALIGNMENT WITH BC-X.8.010 STEP 4:**

BC-X.8.010 step 4 (cross-cutting.md, line 733) — verbatim:

> 4. If the re-resolved ID also fails, apply per-status exit mapping: 404 → exit 64
>    (`"Service desk for <projectKey> not found after refresh."`); 403 → exit 1
>    (permission denied); 401 → exit 2 (not authenticated); 5xx / network → exit 1.

BC-X.8.010 step 4 specifies "401 → exit 2 (not authenticated); 5xx / network → exit 1."
The P31-003 sentence states "(401 → exit 2; 5xx/network → exit 1)." The codes are
verbatim-aligned: 401 → exit 2 and 5xx/network → exit 1. The phrase "maps per
BC-X.8.010 step 4" defers to the canonical source for full step-4 coverage. **PASS.**

**BC-3.9.012 Trace (bc-3-issue-write.md, line 3574) — verbatim excerpt:**

> P31-003 (step-1 carve-out extended: post-retry 401/5xx/network → BC-X.8.010 step 4;
> 401 → exit 2; 5xx/network → exit 1 — same universal codes as first-occurrence)

Trace entry present. **PASS.**

**BC-INDEX BC-3.9.012 row (line 384) — verbatim excerpt:**

> **post-retry 401/5xx/network → BC-X.8.010 step 4 (same universal codes as
> first-occurrence; P31-003)** | — (SOH-ATTACHMENTS-1 F2; P22-001; P30-001; P31-003)

BC-INDEX row synced. **PASS.**

**bc-3-issue-write.md frontmatter v1.3.71 trace entry (line 103) — verbatim:**

> - v1.3.71 — P31 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): 0 new BCs —
>   BC-3.9.012 step-1 carve-out extended: post-retry 401/5xx/network sentence added
>   (a post-retry 401/5xx/network response maps per BC-X.8.010 step 4: 401 → exit 2;
>   5xx/network → exit 1 — same universal codes as first-occurrence; eliminates
>   "first occurrence" ambiguity; P31-003); BC-3.9.012 Trace updated; BC count
>   unchanged (140/35)

Frontmatter trace entry v1.3.71 present. **PASS.**

P31-003 OVERALL: **PASS.**

---

### 2.4 Spec metadata: BC-INDEX frontmatter

**BC-INDEX.md frontmatter (lines 5–6) — verbatim:**

Line 5 `last_updated`: "2026-07-17  # P31 adversary fix round: BC-2.7.008 Batch metadata
source scoped (list response for NAMING/filtering/pre-download; manifest `size` =
written-bytes per EC-2.7.008-6; P31-002); EC-2.7.008-6 `size` semantics sentence added +
"Shape and field semantics align" (P31-002); BC-3.9.012 step-1 carve-out extended:
post-retry 401/5xx/network → BC-X.8.010 step 4 sentence added (P31-003); spec v1.3.71;
BC count unchanged (657); holdout count 100 (unchanged); VP count 35 (unchanged);
BC-INDEX v6.30. Previous: P30 adversary fix round: ..."

Line 6 `index_version`: "v6.30"

BC-INDEX frontmatter bumped from v6.29 → v6.30; both P31-002 and P31-003 row changes
are recorded. **PASS.** (Closing GAP-M-001 from r39.)

---

### 2.5 Spec metadata: spec-changelog.md

`[1.3.71]` entry present at line 10, dated 2026-07-17. Summary correctly states
"2 LOW + 1 INFO." Count table (lines 39–43):

| Metric | Before | After | Delta |
|---|---|---|---|
| BC total | 657 | 657 | 0 |
| Holdout total | 100 | 100 | 0 |
| VP total | 35 | 35 | 0 |

Impact Assessment lists holdout-scenarios.md (P31-001 List-B), bc-2-issue-read.md
(P31-002), bc-3-issue-write.md (P31-003), BC-INDEX.md, prd-delta-576.md. **PASS.**

---

### 2.6 Spec metadata: prd-delta-576.md

- `spec_version_after: 1.3.71` at line 8 ✓
- P31 dispositions section (lines 581–587) contains all 3 finding dispositions ✓
- P31-001: APPLIED; P31-002: APPLIED; P31-003: APPLIED ✓

**PASS.**

---

## 3. Double-Insertion Sweep

Counts of P31 marker occurrences across all affected documents:

| File | P31-001 | P31-002 | P31-003 |
|------|---------|---------|---------|
| holdout-scenarios.md | 1 (frontmatter trace) | 0 | 0 |
| bc-2-issue-read.md | 0 | 3 (frontmatter, EC-2.7.008-6 body, Trace) | 0 |
| bc-3-issue-write.md | 0 | 0 | 2 (frontmatter, BC-3.9.012 Trace) |
| BC-INDEX.md | 0 | 2 (frontmatter + BC-2.7.008 row) | 2 (frontmatter + BC-3.9.012 row) |
| prd-delta-576.md | 1 | 1 | 1 |
| spec-changelog.md | 3 (summary, Changed Req, Impact table) | 4 | 4 |

**bc-2 breakdown:** P31-002 at lines 22 (frontmatter), 799 (EC-2.7.008-6 clause),
811 (BC-2.7.008 Trace). **bc-3 breakdown:** P31-003 at lines 103 (frontmatter), 3574
(BC-3.9.012 Trace). Note: P31-003 new sentence at line 3568 does NOT contain "P31-003"
in the body text; the marker appears only in the Trace field — correct.

**No unexpected duplicates detected. PASS.**

---

## 4. Keystone Verification

### K-1 — Manifest-size story: uniform written-bytes semantics

All four List-A sub-claims verified as a coherent chain:

1. **EC-2.7.007-7 (pre-P31, bc-2 line 762):** "`size` is the byte count written" — single-ID
   path has always used written-bytes. Present and unchanged. **PASS.**

2. **EC-2.7.008-6 `size` semantics sentence (P31-002, bc-2 line 799):** "`downloaded[].size`
   is the byte count written to disk — identical semantics to EC-2.7.007-7 — NOT the
   `fields.attachment[].size` value from the list response." Newly added by P31-002.
   **PASS.**

3. **BC-2.7.008 Batch metadata source scoped (P31-002, bc-2 line 784):** list response
   supplies filename/size/contentUrl for NAMING, filtering, and pre-download purposes; the
   manifest `size` field is explicitly bytes-written NOT list-reported. **PASS.**

4. **"Shape and field semantics align" phrase (P31-002, bc-2 line 799):** "Shape and field
   semantics align with EC-2.7.007-7 for a uniform download response type." The prior text
   "Shape aligns" only confirmed structural shape; P31-002 now correctly asserts both shape
   AND field-semantics alignment. **PASS.**

**H-003 fixture coherence check:** H-NEW-ATTACHMENT-003 B2 (holdout-scenarios.md line 2199)
asserts `"size":3` for attachment id 20020. The list response for this fixture (line 2178)
also says `"size":3`, and the content GET returns 3 bytes ("AAA"). In normal operation the
list-reported size and written-bytes coincide (atomic rename fires only on a complete
stream); `size=3` is consistent with written-bytes semantics. **No contradiction. PASS.**

**P26-003 coherence:** P26-003 established that the single-ID path (BC-2.7.007) uses a
partial struct for step 1 — the metadata GET may return only `filename` (all other fields
absent-tolerant). Therefore, on the single-ID path, `size` in the manifest CANNOT come from
the list API (no list call is issued). P31-002's written-bytes semantics is the only viable
source on single-ID paths, confirming coherence with P26-003. **PASS.**

**K-1: PASS — one uniform written-bytes semantics, no contradiction.**

---

### K-2 — H-002 tightened exit ↔ licensing clauses

H-NEW-ATTACHMENT-002 error-path assertion (holdout-scenarios.md line 2138): "Exit code = 1
(EC-2.7.007-4 mid-stream error; BC-2.7.012 5xx row)."

The fixture mounts:
- metadata GET for id 10002 → HTTP 200 (setup step 4, metadata succeeds)
- content GET for id 10002 → HTTP 500 mid-stream (setup step 5, triggers error path)

EC-2.7.007-4 licenses exit 1 for error mid-stream (content-GET 500 is mid-stream). BC-2.7.012
5xx row gives exit 1. Only ONE conformant exit code exists for this fixture configuration:
exit 1. The prior "exit 1 or exit 64" formulation admitted exit 64 (reserved for user-input
errors, not mid-stream HTTP failures). The tightening is satisfiable and non-contradictory
against the fixture. **K-2: PASS.**

---

### K-3 — Self-heal post-retry enumeration completeness

BC-3.9.012 carve-out (bc-3 line 3568) now enumerates all post-retry response codes:

- post-retry 404 → exit 64 (from P30-001)
- post-retry 403 → exit 1 (from P30-001)
- post-retry 401/5xx/network → BC-X.8.010 step 4 (NEW P31-003)

BC-X.8.010 step 4 covers: 404 → exit 64, 403 → exit 1, 401 → exit 2, 5xx/network → exit 1.
The P30-001 codes (404/403) and P31-003 codes (401/5xx/network) together cover all HTTP
response classes. No gap remains. The combined carve-out is complete and BC-X.8.010 step
4 is cited as the authoritative source for all second-failure exit codes.

**K-3: PASS — carve-out now complete and verbatim-aligned with BC-X.8.010 step 4.**

---

## 5. Guard Scripts

Both guard scripts run against spec v1.3.71 state and exit 0.

- `scripts/check-spec-counts.sh` — exit 0 (no count drift in frontmatter vs body)
- `scripts/check-bc-cumulative-counts.sh` — exit 0 (all 8 surfaces agree: BC 657,
  holdout 100, VP 35)

**PASS.**

---

## 6. INFO Ledger

### 6.1 Resolved this round

None.

### 6.2 Carry-forward

| ID | Description | Fresh-quote status |
|----|-------------|-------------------|
| INFO-1 | Triple blank lines in bc-2 between EC-2.7.008-6 and EC-2.7.008-7 | CONFIRMED — lines 800–802 of bc-2 still have three blank lines between EC-2.7.008-6 (line 799) and EC-2.7.008-7 (line 803). |
| INFO-2 | EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained without explicit supersession note | CONFIRMED — bc-2 line 798 reads "supersedes EC-2.7.008-2 wording clarification" while EC-2.7.008-2 still exists at line 794; both coexist. |
| INFO-3 | BC-2.7.012 combined-scope (download+upload) row — intent verifiable but no explicit scope comment | CONFIRMED — BC-2.7.012 BC-INDEX row (line 231) and body (line 925) cover attachment-download error taxonomy; no explicit "download-only scope" comment present. |
| INFO-6 | No holdout scenario for collision-skip exit-0 path | CONFIRMED — collision-skip exit-0 path (BC-2.7.008 overwrite behavior with `--force` absent) has no dedicated holdout; carry-forward. |
| INFO-8 | STATE.md spec version stale | CONFIRMED — STATE.md still reflects spec v1.3.70 (P30-remediated state); v1.3.71 not yet recorded. |
| INFO-11 | spec-changelog [1.3.57] and prd-delta P17-002 "three sites" vs four | NOTE: Fresh search finds no "three sites" discrepancy in current documents — spec-changelog [1.3.57] Changed Requirements (line 512) and prd-delta P17-002 (line 331) both say "All four sites." The discrepancy text is not locatable; this entry may be stale. Carry-forward pending explicit resolution or INFO closure. |
| INFO-15 | impact-boundary-576.md BC-3.9.004 INCONCLUSIVE annotation | CONFIRMED — spec-changelog line 455 confirms annotation still present ("BC-3.9.004 row annotated: key order is illustrative; shape INCONCLUSIVE pending S5 live capture"). |
| INFO-NEW-5 | BC-3.9.009 Trace field not updated with P24-001 citation | CONFIRMED — BC-3.9.009 Trace (bc-3 line 3489) reads "F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); JSON render invariant #526" — no P24-001 citation present. The P24-001 body fix (download-exclusion narrowing) was not reflected in the Trace field. |

---

## 7. Summary

| Category | Count |
|----------|-------|
| P31 fix items verified PASS | 3 / 3 |
| MEDIUM gaps | 0 |
| LOW gaps | 0 |
| INFO findings (new) | 0 |
| INFO findings (resolved) | 0 |
| INFO carry-forward | 8 |
| Echo-breaker violations | 0 |
| Double-insertion anomalies | 0 |
| Guard script failures | 0 |

**Verdict: CONSISTENT.**

All three P31 fix items (P31-001 holdout tightening, P31-002 uniform size semantics,
P31-003 post-retry enumeration) verified present at the claimed locations with correct
content. Keystones K-1 through K-3 are coherent. Counts 657/100/35 confirmed unchanged by
both guard scripts. BC-INDEX bumped to v6.30 (closing r39 GAP-M-001). No gaps found in
this round.
