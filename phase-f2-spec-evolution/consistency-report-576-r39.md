---
round: r39
spec_version_checked: 1.3.70
prev_spec_version: 1.3.69
adversary_pass: P30
date: 2026-07-17
verdict: GAPS-FOUND
medium_gaps: 1
low_gaps: 0
info_findings_new: 0
info_findings_resolved: 1
---

# Consistency Validation Report — Round 39 (cv-576-r39)

**Feature:** SOH-ATTACHMENTS-1 (issues #576 + #585)
**Spec version checked:** v1.3.70 (immediately after adversary-pass-30 fix round)
**Prior spec version:** v1.3.69
**Date:** 2026-07-17
**Verdict:** GAPS-FOUND — 1 MEDIUM gap

---

## 1. Scope

This round validates the P30 fix round (v1.3.69 → v1.3.70). P30 closed:
- P30-001 (MEDIUM): BC-3.9.003 + BC-3.9.012 missing step-1 self-heal contract (SEC-576-006, BC-X.8.010)
- P30-002 (LOW): BC-3.9.019 pre-deletion summary not classified in STDERR ENUMERATION
- P30-003 (LOW): ADR-0017 stale call-site (`src/api/jira/issues.rs` → `src/api/jira/attachments.rs`)
- P30-I01 (INFO): BC-3.9.016 CLI flags not annotated for STDERR ENUMERATION TABLE

Protocol: CLOSURE VERIFICATION PROTOCOL — verbatim quotes at claim time, row-level
verification, double-insertion sweep. No spec content, STATE.md, or product source
modified.

---

## 2. P30 Fix Item Verification

### 2.1 P30-001 (MEDIUM) — Step-1 self-heal contract

**Claim:** Self-heal paragraph added to BC-3.9.003 Step 1; 403/404 carve-out added to
BC-3.9.012; both BCs' Trace fields updated; BC-INDEX rows for BC-3.9.003 and BC-3.9.012
updated.

**BC-3.9.003 Step 1 body (bc-3-issue-write.md, line 3316) — verbatim:**

> **Step-1 self-heal (SEC-576-006, BC-X.8.010, P30-001)**: A 404 or 403 response to this
> step-1 POST FIRST triggers the BC-X.8.010 SEC-576-006 self-heal before falling through to
> the BC-3.9.012 error mapping: the `project_meta.json` cache entry for `(profile, projectKey)`
> is invalidated, `get_or_fetch_project_meta` is re-called once (cache-miss path, re-resolves
> via `GET /rest/api/3/project/{key}` + paginated `GET /rest/servicedeskapi/servicedesk`), and
> step 1 is re-attempted with the re-resolved `sdId`. Only the post-retry response falls through
> to BC-3.9.012: post-retry 404 → exit 64 (`"Service desk for <projectKey> not found after
> refresh."`); post-retry 403 → exit 1 (permission denied). The retry is single-attempt — it
> does not loop. All other codes (401, 5xx, network) map to BC-3.9.012 on first occurrence
> without a self-heal retry.

Verification: Paragraph present at line 3316, inside BC-3.9.003 Step 1 prose. **PASS.**

**BC-3.9.003 Trace (line 3338) — verbatim (relevant excerpt):**

> P30-001 (step-1 self-heal sentence added to Step 1: SEC-576-006/BC-X.8.010
> invalidate+retry-once on step-1 404/403 BEFORE BC-3.9.012 mapping; post-retry exit codes
> per BC-X.8.010 step 4)

Verification: Trace entry present at line 3338. **PASS.**

**BC-3.9.012 carve-out (bc-3-issue-write.md, line 3567) — verbatim:**

> **Step-1 `attachTemporaryFile` 403/404 carve-out (SEC-576-006, P30-001)**: A 403 or 404
> from the JSM step-1 `POST .../attachTemporaryFile` does NOT immediately map to the table
> above. It first triggers the BC-X.8.010 SEC-576-006 self-heal (invalidate `project_meta.json`
> cache for `(profile, projectKey)` → re-resolve `serviceDeskId` via
> `get_or_fetch_project_meta` once → re-attempt step 1). Only the post-retry response falls
> through to this table: post-retry 404 → exit 64 (`"Service desk for <projectKey> not found
> after refresh."`); post-retry 403 → exit 1 (permission denied; per BC-X.8.010 step 4
> verbatim). All other codes (401, 5xx, network) map to the table on first occurrence without
> a self-heal retry.

Verification: Carve-out present at line 3567, before EC-3.9.012-1 at line 3569. **PASS.**

**BC-3.9.012 Trace (line 3573) — verbatim (relevant excerpt):**

> P30-001 (step-1 attachTemporaryFile 403/404 carve-out: BC-X.8.010 self-heal first;
> post-retry exit codes per BC-X.8.010 step 4)

Verification: Trace entry present at line 3573. **PASS.**

**BC-INDEX BC-3.9.003 row (line 375) — verbatim (relevant excerpt):**

> **step-1 self-heal (SEC-576-006, P30-001)**: step-1 404/403 triggers BC-X.8.010
> invalidate+retry-once BEFORE BC-3.9.012 mapping; post-retry 404→exit 64, 403→exit 1

Verification: Present at line 375. **PASS.**

**BC-INDEX BC-3.9.012 row (line 384) — verbatim (relevant excerpt):**

> step-1 attachTemporaryFile 403/404 carve-out (P30-001)

Verification: Present at line 384. **PASS.**

**ECHO-BREAKER: P30-001 exit codes are grounded in BC-X.8.010 step 4.**

BC-X.8.010 step 4 (cross-cutting.md, line 733) verbatim:

> 4. If the re-resolved ID also fails, apply per-status exit mapping: 404 → exit 64
> (`"Service desk for <projectKey> not found after refresh."`); 403 → exit 1 (permission
> denied); 401 → exit 2 (not authenticated); 5xx / network → exit 1.

The BC-3.9.003 self-heal paragraph states "post-retry 404 → exit 64" with the identical
error string and "post-retry 403 → exit 1 (permission denied)." The BC-3.9.012 carve-out
states "post-retry 404 → exit 64 … post-retry 403 → exit 1 (permission denied; per
BC-X.8.010 step 4 verbatim)." Both are fully licensed by BC-X.8.010 step 4. **No
echo-breaker violation. PASS.**

P30-001 OVERALL: **PASS.**

---

### 2.2 P30-002 (LOW) — BC-3.9.019 pre-deletion summary as HINT

**Claim:** BC-3.9.019 pre-deletion stderr summary classified as HINT (suppressed in
`--output json` mode); Trace updated; BC-INDEX BC-3.9.019 row updated.

**BC-3.9.019 HINT annotation (bc-3-issue-write.md, line 3840) — verbatim:**

> **HINT — suppressed in `--output json` mode** (the count is carried in the JSON result
> envelope's `"count"` field; per EC-2.7.008-6 hint-vs-error principle). Human mode only.

Verification: Annotation present at line 3840. **PASS.**

**BC-3.9.019 Trace (line 3859) — verbatim (relevant excerpt):**

Trace field contains "P30-002" citation. Verified at line 3859. **PASS.**

**BC-INDEX BC-3.9.019 row (line 391) — verbatim (relevant excerpt):**

> pre-deletion stderr summary = HINT (P30-002)

Verification: Present at line 391. **PASS.**

**STDERR ENUMERATION cross-check:** BC-3.9.019 now appears in the STDERR TABLE with
HINT classification. The entry was absent before P30-002 (the gap P30-002 fixed). **PASS.**

P30-002 OVERALL: **PASS.**

---

### 2.3 P30-003 (LOW) — ADR-0017 call-site correction

**Claim:** ADR-0017 line 114 corrected from stale `src/api/jira/issues.rs` to the new
attachment-module path `src/api/jira/attachments.rs`.

**ADR-0017 line 114 — verbatim:**

> `src/api/jira/attachments.rs` during Story 3 delivery (call-site corrected per
> CONS-576-002, P30-003).

Verification: Corrected text present at ADR-0017 line 114. **PASS.**

**Coherence with impact-boundary-576.md:** The impact boundary §1.1 registers
`src/api/jira/attachments.rs` as the NEW file for attachment logic (line 38, 104). The
corrected ADR-0017 call-site is consistent. **PASS.**

P30-003 OVERALL: **PASS.**

---

### 2.4 P30-I01 (INFO) — BC-3.9.016 CLI flags annotation

**Claim:** BC-3.9.016 annotated with CLI flags for STDERR ENUMERATION TABLE clarity;
Trace updated; BC-INDEX BC-3.9.016 row updated.

**BC-3.9.016 CLI flags annotation (bc-3-issue-write.md, line 3733) — verbatim:**

> `<AID>...` (positional, 1+ when used — optional under the required selector group; bare
> `delete` → exit 2 per the clap section; mutually exclusive with `--issue`/`--older-than`
> form)

Verification: Annotation present at line 3733. **PASS.**

**BC-3.9.016 Trace (line 3735) — verbatim (relevant excerpt):**

Trace field contains "P30-I01" citation. Verified at line 3735. **PASS.**

**BC-INDEX BC-3.9.016 row (line 388) — verbatim (relevant excerpt):**

> CLI flags annotated (P30-I01)

Verification: Present at line 388. **PASS.**

P30-I01 OVERALL: **PASS.**

---

### 2.5 Spec metadata: bc-3 frontmatter

**bc-3-issue-write.md frontmatter (lines 1-103):**
- `last_updated: 2026-07-17` — correct ✓
- v1.3.68 trace entry present at line 101 — RESOLVES INFO-NEW-9 from r38 ✓
- v1.3.70 trace entry present at line 102 — correct ✓

**PASS.**

---

### 2.6 Spec metadata: spec-changelog.md

`[1.3.70]` entry present at line 10, dated 2026-07-17. Count table:
BC 657 unchanged, Holdout 100 unchanged, VP 35 unchanged, Spec version 1.3.69→1.3.70.
Impact Assessment lists bc-3-issue-write.md, BC-INDEX.md, ADR-0017, prd-delta-576.md.
**PASS.**

---

### 2.7 Spec metadata: prd-delta-576.md

- `spec_version_after: 1.3.70` at line 8 ✓
- P30 section (lines 537–577) contains all 4 finding dispositions ✓
- STDERR ENUMERATION TABLE present with 24 rows ✓

**Note:** The task description stated "23 entries" in the enumeration table. The actual
count is 24 rows. This discrepancy is in the task description only; the prd-delta itself
does not claim a specific count. Not a spec gap.

**PASS.**

---

## 3. Double-Insertion Sweep

Counts of P30 marker occurrences across all affected documents:

| File | P30-001 | P30-002 | P30-003 | P30-I01 | Total | Expected |
|------|---------|---------|---------|---------|-------|----------|
| bc-3-issue-write.md | 4 | 2 | 0 | 2 | 8 | 8 |
| BC-INDEX.md | 2 | 1 | 0 | 1 | 4 | 4 |
| ADR-0017 | 0 | 0 | 1 | 0 | 1 | 1 |
| prd-delta-576.md | — | — | — | — | 7 | table+dispositions |
| spec-changelog.md | — | — | — | — | 6 | changelog entry |

**bc-3 breakdown:** P30-001 appears at lines 3316, 3338, 3567, 3573 (two BC bodies + two
Trace fields). P30-002 at lines 3840, 3859 (BC-3.9.019 annotation + Trace). P30-I01 at
lines 3733, 3735 (BC-3.9.016 annotation + Trace). P30-003 is ADR-only (not in bc-3).

**No unexpected duplicates detected. PASS.**

---

## 4. Keystone Verification

### K-1 — Self-heal story coherence

SEC-576-006 stale-ID self-healing is stated in BC-3.9.003 Step 1 (entry point), BC-3.9.012
(error taxonomy carve-out), and BC-X.8.010 (canonical steps 1–4). All three are internally
consistent on: single-attempt retry, projectKey-scoped cache invalidation, and post-retry
exit codes (404 → exit 64, 403 → exit 1). BC-3.9.006 contains the coherent scoping note
("step 2 endpoint keys off `issueKey`, not `serviceDeskId`, so a stale-sdId cache is not
a root cause here") which is non-contradictory with the step-1 self-heal.

**K-1: PASS.**

### K-2 — §3.9 enumeration ↔ BC bodies

STDERR ENUMERATION TABLE (prd-delta-576.md, 24 rows) was spot-audited against 6 entries:

| Entry | Classification | BC body verdict |
|-------|----------------|-----------------|
| BC-3.9.005 error | ERROR | No JSON-mode suppression; non-negotiable flag error; correct — the emission precedes any API call. PASS. |
| BC-3.9.010 bulk-404 skip | SILENT SKIP (absent from table) | BC-3.9.010 correctly specifies silent per-key skip; no emission. Absent from table is correct. PASS. |
| BC-3.9.011 deferred-probe | absent from table | BC-3.9.011 specifies no live emissions at probe stage. Absence correct. PASS. |
| BC-3.9.015 cancel hint | HINT | BC-3.9.015 at lines 3663–3664 explicitly states JSON suppression for cancel confirmation output. PASS. |
| BC-3.9.016 progress hint | HINT | P30-I01 annotation confirms CLI flag context. HINT classification correct. PASS. |
| BC-3.9.020 dry-run hint | HINT | BC-3.9.020 at line 3887 states "NO stderr hint in JSON mode" verbatim. PASS. |

**K-2: PASS.**

### K-3 — ADR-0017 call-site

ADR-0017 line 114: "`src/api/jira/attachments.rs` during Story 3 delivery (call-site
corrected per CONS-576-002, P30-003)." The corrected call-site is `src/api/jira/attachments.rs`,
which matches impact-boundary-576.md §1.1 designation of that file as NEW for S3 delivery.

**K-3: PASS.**

---

## 5. Gaps Found

### GAP-M-001 (MEDIUM) — BC-INDEX frontmatter not bumped for P30

**Location:** `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/BC-INDEX.md`,
lines 5–6.

**Observed (verbatim):**
- Line 5: `last_updated: 2026-07-17  # P28 adversary fix round: BC-3.9.020 row P28-001 ...`
- Line 6: `index_version: v6.28`

**Expected:** `index_version: v6.29`; `last_updated` comment updated to record P30 changes
(BC-3.9.003/012/016/019 rows modified for P30-001/P30-002/P30-I01).

**Impact:** An auditor reading BC-INDEX.md frontmatter sees no record that P30 modified
four rows. The version tracking stalls at P28. The rows themselves are correctly updated
(confirmed: BC-3.9.003 line 375, BC-3.9.012 line 384, BC-3.9.016 line 388, BC-3.9.019
line 391 all contain correct P30 citations). Only the frontmatter audit trail is missing.

**Pattern:** P27 bumped to v6.27; P28 bumped to v6.28; P30 should bump to v6.29.
(P29 was an INFO-only adversary pass with no BC-INDEX row changes — no bump expected for
P29, which is consistent with the v6.28 → v6.28 non-change for P29. The first bump
required after P28 row changes is for P30.)

**spec-changelog.md coherence:** The [1.3.70] Impact Assessment lists BC-INDEX.md as
"Modified: BC-3.9.003/012/016/019 row sync" — this correctly documents row changes.
It does NOT claim the frontmatter was bumped; the omission in spec-changelog mirrors
the actual omission in the file. The spec-changelog entry is not incorrect, but it does
not substitute for the BC-INDEX frontmatter bump.

**Fix:** In BC-INDEX.md frontmatter, set `index_version: v6.29` and append to the
`last_updated` comment: `# P30 adversary fix round: BC-3.9.003 step-1 self-heal row
(P30-001); BC-3.9.012 carve-out row (P30-001); BC-3.9.016 CLI flags row (P30-I01);
BC-3.9.019 HINT row (P30-002); spec v1.3.70; BC-INDEX v6.29`.

---

## 6. INFO Ledger

### 6.1 Resolved this round

| ID | Description | Resolution |
|----|-------------|------------|
| INFO-NEW-9 (r38) | bc-3 frontmatter missing v1.3.68 trace entry | RESOLVED — v1.3.68 trace entry present at bc-3 line 101 ✓ |

### 6.2 Carry-forward

| ID | Description | Status |
|----|-------------|--------|
| INFO-1 | Triple blank lines in bc-2 between EC-2.7.008-6 and EC-2.7.008-7 | Carry-forward |
| INFO-2 | EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained without explicit supersession note | Carry-forward |
| INFO-3 | BC-2.7.012 combined-scope (download+upload) row — intent verifiable but no explicit scope comment | Carry-forward |
| INFO-6 | No holdout scenario for collision-skip exit-0 path | Carry-forward |
| INFO-8 | STATE.md spec version stale — now stale at v1.3.70 | Carry-forward |
| INFO-11 | spec-changelog [1.3.57] and prd-delta P17-002 "three sites" vs four | Carry-forward |
| INFO-15 | impact-boundary-576.md BC-3.9.004 INCONCLUSIVE annotation | Carry-forward |
| INFO-NEW-5 | BC-3.9.009 Trace field not updated with P24-001 citation | Carry-forward |

---

## 7. Guard Scripts

Both guard scripts run against spec v1.3.70 state and exit 0.

- `scripts/check-spec-counts.sh` — exit 0 (no count drift in frontmatter vs body)
- `scripts/check-bc-cumulative-counts.sh` — exit 0 (all 8 surfaces agree: BC 657,
  holdout 100, VP 35)

---

## 8. Summary

| Category | Count |
|----------|-------|
| P30 fix items verified PASS | 4 / 4 |
| MEDIUM gaps | 1 |
| LOW gaps | 0 |
| INFO findings (new) | 0 |
| INFO findings (resolved) | 1 (INFO-NEW-9 from r38) |
| INFO carry-forward | 8 |
| Echo-breaker violations | 0 |
| Double-insertion anomalies | 0 |
| Guard script failures | 0 |

**Verdict: GAPS-FOUND.**

The single gap (GAP-M-001) is a traceability issue only — BC-INDEX rows are correctly
updated and all behavioral contracts are consistent. The gap has a clear, mechanical fix:
bump `index_version` to v6.29 and append the P30 entry to the `last_updated` comment in
BC-INDEX.md frontmatter.
