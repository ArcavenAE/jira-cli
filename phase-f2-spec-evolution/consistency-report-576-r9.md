---
report: consistency-report-576-r9
feature: SOH-ATTACHMENTS-1
spec_version: v1.3.45
bc_count: 657
holdout_count: 95
round: R9
date: 2026-07-15
validator: vsdd-factory:consistency-validator (fresh context, no R8 memory)
verdict: GAPS-FOUND
new_finding_count: 3
new_finding_severity_breakdown: "MEDIUM×1, LOW×2"
r8_closure: r8_finding_carry_forward_still_open
---

# SOH-ATTACHMENTS-1 F2 Consistency Report — Round R9

**Verdict: GAPS-FOUND** — 3 new findings (MEDIUM×1, LOW×2). All 19 P2 fixes confirmed present; all 5 HIGH P2 fixes spot-checked individually. FINDING-R8-001 (INFO) carries forward unresolved.

---

## 1. Scope

Fresh-context round-9 pass over the full SOH-ATTACHMENTS-1 F2 spec package at spec version 1.3.45 (657 BCs, 95 holdouts), post-P2 fix round. Independent findings formed before reading R8 report or P2 disposition table. Specific focus areas per the team-lead task:

- (a) Delete-family state machine: BC-3.9.008/010/013/015/016/019/020 — gate rules, 404 semantics, JSON shapes
- (b) BC-3.9.017 4-step sequence vs BC-3.9.014 and BC-3.9.018 — no ordering contradictions
- (c) P2-018 dry-run-on-upload shape vs JSON Output Shape Contracts table
- (d) Impact-boundary R3.8a/b vs the BC text — rulings must match what BCs now say
- (e) Duration-unit consistency (w/d/h/m)
- (f) Count/narrative surfaces
- (g) Stale markers

Surface set covered:
- `.factory/specs/prd/bc-3-issue-write.md` (Section 3.9, JSON Output Shape Contracts table)
- `.factory/specs/prd/bc-2-issue-read.md` (Section 2.7)
- `.factory/specs/prd/holdout-scenarios.md` (Group 19, H-NEW-ATTACHMENT-001..007)
- `.factory/specs/prd/BC-INDEX.md` (v6.14)
- `.factory/specs/prd/CANONICAL-COUNTS.md`
- `.factory/phase-f2-spec-evolution/prd-delta-576.md` + worklog
- `.factory/phase-f2-spec-evolution/security-review-576.md`
- `.factory/phase-f1-delta-analysis/impact-boundary-576.md` (Rev 1–3 + R3.7/R3.8)

---

## 2. P2 Fix Spot-Check Table (5 HIGH fixes)

| P2 ID | Description | Location | Verified Present? |
|-------|-------------|----------|-------------------|
| P2-001 | BC-3.9.016 three-form delete enumeration: (1) single-AID → BC-3.9.015 gate, (2) multi-AID bulk (2+) → `--yes` required, (3) `--issue`/`--older-than` → `--yes` required; EC-3.9.016-6/7/8 added | bc-3-issue-write.md BC-3.9.016 body | YES — opening paragraph enumerates all three forms; EC-3.9.016-6 (multi-AID --yes proceed), EC-3.9.016-7 (multi-AID --dry-run valid), EC-3.9.016-8 (multi-AID no --yes → exit 64) all present |
| P2-002 | EC-3.9.015-5: EOF / Ctrl+D on prompt read = cancellation → exit 0; "Deletion cancelled." to stderr; JSON `{"cancelled":true,"deleted":false}` — NOT exit 130 | bc-3-issue-write.md BC-3.9.015 | YES — EC-3.9.015-5 reads: "`Err` from `read_line` is caught and routed to the cancel path; exit 0; `"Deletion cancelled."` to stderr; JSON: `{"cancelled":true,"deleted":false}`"; mirrors BC-3.9.014 EC-3.9.014-2 and BC-3.5.003 |
| P2-003 | BC-3.9.017: 3-step → 4-step with Gate step (step 2) firing ALL confirmation gates BEFORE step 3 (delete); invariant: no destructive call while any gate is pending; EC-3.9.017-8 added (gate cancelled → no DELETEs) | bc-3-issue-write.md BC-3.9.017 | YES — step 2 is labelled "Gate step (fire ALL pending confirmation gates BEFORE any destructive call)"; explicit note "before any DELETE"; EC-3.9.017-8: "user cancels `--public` confirmation gate; exit 0; 'Upload cancelled.'; no DELETEs issued; no upload" |
| P2-004 | H-NEW-ATTACHMENT-006: hard-coded dates replaced with relative `T_now - 14d / 10d / 1d` timestamps; note: "Using relative offsets ensures the test remains valid on any invocation date without clock drift" | holdout-scenarios.md H-NEW-ATTACHMENT-006 | YES — setup step 1 computes `T_old1 = T_now - 14d`, `T_old2 = T_now - 10d`, `T_new = T_now - 1d` with explicit drift-prevention rationale |
| P2-005 | H-NEW-ATTACHMENT-002: content URL in fixture changed from `https://example.atlassian.net/content/10001` to `<JR_BASE_URL>/rest/api/3/attachment/content/10001`; wiremock mounts `GET /rest/api/3/attachment/content/10001` | holdout-scenarios.md H-NEW-ATTACHMENT-002 | YES — step 2 fixture has `"content":"<JR_BASE_URL>/rest/api/3/attachment/content/10001"` with explicit note "(content URL points at wiremock base URL, NOT an external host)"; step 3 mounts the GET route |

All 5 HIGH P2 fixes are genuinely present in artifact text.

---

## 3. Priority Area Results

### (a) Delete-family state machine — BC-3.9.008/010/013/015/016/019/020

**COHERENT** with no machine-level contradictions. State machine summary verified:

- **Three forms** (BC-3.9.016): single-AID → BC-3.9.015 interactive gate; multi-AID (2+) → explicit `--yes` required, no interactive prompt; `--issue`/`--older-than` → explicit `--yes` required, no interactive prompt. `--dry-run` is exempt from `--yes` gate on ALL bulk paths. ✓
- **404 semantics**: single-AID 404 → exit 64 + surface body (BC-3.9.008; BC-3.9.013). Multi-path 404 → already-deleted, skip silently, continue (BC-3.9.013 multi-delete exception clause; EC-3.9.019-7). Consistent asymmetry — intentional and correct. ✓
- **JSON shapes** (BC-3.9.010): single success `{"deleted":true,"id":"<AID>"}` (d<i); bulk success `{"count":N,"deleted":true,"ids":[...]}` (c<d<i); cancel `{"cancelled":true,"deleted":false}` (c<d); dry-run `{"attachments":[...],"dryRun":true,"ids":[...]}` (a<d<i). All BTreeMap-ordered. ✓
- **EC-3.9.016-1 vs EC-3.9.016-8 error messages**: EC-3.9.016-1 (--older-than bulk missing --yes): "`'--older-than requires --yes to confirm bulk deletion.'`"; EC-3.9.016-8 (multi-AID bulk missing --yes): "`'--yes is required to delete multiple attachments without a confirmation prompt.'`". Distinct messages for distinct forms — intentional asymmetry, not a contradiction. ✓
- **BC-3.9.015 pre-prompt GET**: metadata fetch for confirmation display, 404 → exit 64 before any DELETE (guard consistent with BC-3.9.008/013). ✓

### (b) BC-3.9.017 4-step sequence vs BC-3.9.014 and BC-3.9.018

**MOSTLY CONSISTENT** — one underspecification gap found (FINDING-R9-002, LOW).

- Gate step (step 2) fires BC-3.9.014 mechanics; BC-3.9.014 is the canonical source; BC-3.9.003 also delegates to BC-3.9.014. ✓
- BC-3.9.017 step 2 explicitly fires before step 3 (DELETE): "before any DELETE"; EC-3.9.017-8 (gate-cancel exits before any DELETEs). ✓
- BC-3.9.018 (zero-match): routed from BC-3.9.017 EC-3.9.017-3; states "delete phase is skipped entirely; upload proceeds identically to a plain upload." ✓
- **GAP (FINDING-R9-002)**: BC-3.9.017 step 4 says "The `--public` gate (if applicable) has already fired in step 2" when invoking BC-3.9.003, but BC-3.9.003 independently states "Before step 1, jr presents a confirmation prompt" — no explicit mechanism is described to suppress BC-3.9.003's gate in the `--replace-existing` flow. See FINDING-R9-002.

### (c) P2-018 dry-run-on-upload shape

**GAP CONFIRMED** (FINDING-R9-001, MEDIUM).

BC-3.9.020 body correctly defines the `upload --replace-existing --dry-run` shape:
`{"dryRun":true,"wouldDelete":[{"id":"<AID>","filename":"<name>"}],"wouldUpload":[{"filename":"<name>"}]}`

The JSON Output Shape Contracts table (bc-3-issue-write.md, lines ~3207-3212) has six rows covering upload success, delete single/bulk/cancel, delete dry-run, and upload --public (deferred). The `upload --replace-existing --dry-run` shape is **absent** from this table. P2-018 added the shape to BC-3.9.020 body but did not add a corresponding row to the table.

Key ordering check: keys `dryRun`, `wouldDelete`, `wouldUpload` — alphabetical order: 'd' < 'w' < 'w'; within the two 'w' keys, `wouldDelete` < `wouldUpload` (same prefix, 'D' < 'U'). The shape in BC-3.9.020 is correctly BTreeMap-ordered. The gap is the missing table entry, not key ordering.

### (d) Impact-boundary R3.8a/b vs BC text

**R3.8a**: MATCHES BC TEXT. The multi-positional delete → bulk `--yes` required ruling is correctly encoded in BC-3.9.016's three-form enumeration (P2-001). ✓

**R3.8b**: STEP-ORDER DIVERGENCE — unannotated (FINDING-R9-003, LOW). R3.8b specifies gate → list → delete → upload; BC-3.9.017 (P2-003) implements list → gate → delete → upload. The core safety invariant (DELETE only after gate) is preserved in both. However, unlike the OQ-9 divergence (R2.2) and BC-3.9.012 correction (R2.3) which received PHASE-DOC-RETRO-ANNOTATIONs, R3.8b has no annotation noting the step-order adjustment made at F2. See FINDING-R9-003.

### (e) Duration-unit consistency (w/d/h/m)

**CONSISTENT**. P2-008 corrected BC-3.9.019 to `w`, `d`, `h`, `m` (minutes) — no `s` (seconds), no `M` (months). All `--older-than` examples throughout BC-3.9.016, BC-3.9.019, and H-NEW-ATTACHMENT-006 use only `7d` — no disallowed unit appears anywhere in the attachment spec. Impact-boundary R3.2 retro-correction of `1M` example is consistent. ✓

### (f) Count/narrative surfaces

**ALL CONSISTENT** — verified by actual `grep -c '^#### BC-'` across all 8 files:

| File | Actual `#### BC-` count | Frontmatter `definitional_count` | Match? |
|------|------------------------|----------------------------------|--------|
| bc-1-auth-identity.md | 46 | 46 | YES |
| bc-2-issue-read.md | 64 | 64 | YES |
| bc-3-issue-write.md | 111 | 111 | YES |
| bc-4-assets-cmdb.md | 22 | 22 | YES |
| bc-5-boards-sprints.md | 18 | 18 | YES |
| bc-6-config-cache.md | 33 | 33 | YES |
| bc-7-output-render.md | 49 | 49 | YES |
| cross-cutting.md | 84 | 84 | YES |

- `grep -c '^### H-' holdout-scenarios.md` = 95 ✓
- BC-INDEX.md frontmatter `total_bcs: 657`, `index_version: v6.14` ✓
- CANONICAL-COUNTS.md Sum row: 657; "Total individually-bodied": 427 ✓
- CANONICAL-COUNTS.md Grand total: 657 ✓
- holdout-scenarios.md frontmatter `total_holdouts: 95` ✓

### (g) Stale markers

**CLEAN** with one carry-forward from R8. Checked:

- `(implementation pending — story S3/S4/S5)` markers in BC-3.9 Source fields: correct forward-looking markers for unimplemented features, not stale. ✓
- `(P2-3c deferred S5)` markers in BC-3.9.007, BC-3.9.011: legitimate deferred obligations. ✓
- JSON Output Shape Contracts table `(P2-3c deferred — update after S5 live-capture)` for `--public` row: legitimate. ✓
- Round B "DELIVERED" annotation in prd-delta-576.md Scope Note: correct. ✓
- No orphaned "TODO", "FIXME", or draft-state markers detected. ✓

---

## 4. New Findings

### FINDING-R9-001 — MEDIUM

**File:** `bc-3-issue-write.md`
**Location:** JSON Output Shape Contracts table (~lines 3207-3212)
**Description:** The JSON Output Shape Contracts table does not include a row for the `attachment upload --replace-existing --dry-run` JSON shape. BC-3.9.020 body (path (c)) defines this shape as:

```json
{"dryRun":true,"wouldDelete":[{"id":"<AID>","filename":"<name>"}],"wouldUpload":[{"filename":"<name>"}]}
```

P2-018 added this shape to BC-3.9.020 body text (correctly, BTreeMap-ordered: dryRun < wouldDelete < wouldUpload), but did not add a corresponding row to the JSON Output Shape Contracts table. The table is the single-source-of-truth for JSON shapes per the R5/R6 convention (rows for cancel shape and delete dry-run were added in round R6 via NEW-R6-002). The upload --replace-existing --dry-run shape is an unregistered shape.

**Key-ordering check (BC-3.9.020 body):** `dryRun` < `wouldDelete` < `wouldUpload` — 'd' < 'w' < 'w'; tie broken by `wouldDelete` (D) < `wouldUpload` (U). ✓ The shape is correctly BTreeMap-ordered in the BC body; the gap is solely the missing table row.

**Sources line** (line ~3214) also needs updating to include BC-3.9.020's upload path.

**Impact:** MEDIUM. The table is the canonical JSON-shape reference for implementers; a missing row means this shape has lower discoverability than the other shapes. No correctness impact on BC-3.9.020 itself.

**Suggested fix:** Add a row to the JSON Output Shape Contracts table:

```
| `attachment upload --replace-existing --dry-run` | `{"dryRun":true,"wouldDelete":[{"id":"<AID>","filename":"<name>"}...],"wouldUpload":[{"filename":"<name>"}...]}` | 3 keys alphabetical; BC-3.9.020 path (c) |
```

Update Sources line to include BC-3.9.020 upload path reference.

---

### FINDING-R9-002 — LOW

**File:** `bc-3-issue-write.md`
**Location:** BC-3.9.017 step 4 / BC-3.9.003 gate
**Description:** BC-3.9.017 step 4 says "proceed with upload per BC-3.9.001 (platform path) or BC-3.9.003/BC-3.9.004 (JSM path). The `--public` gate (if applicable) has already fired in step 2." However, BC-3.9.003 independently states "Before step 1, jr presents a confirmation prompt" with no conditional clause for the case where the gate has already fired via BC-3.9.017 step 2.

The spec does not specify the mechanism by which BC-3.9.003's gate is suppressed when invoked from BC-3.9.017's step 4. An implementer reading BC-3.9.003 in isolation would apply the gate again, creating a double-prompt for `--replace-existing --public` without `--yes`. The note in BC-3.9.017 step 4 ("gate has already fired in step 2") signals the intent but does not name an implementation mechanism (e.g., "pass `gate_fired: true` to the upload subroutine" or "only execute BC-3.9.003 steps 1-2, not the gate").

**Impact:** LOW. The intended behavior (no double-prompt) is inferable from BC-3.9.017's explicit statement. This is an implementation-guidance underspecification, not a behavioral contradiction between BCs.

**Suggested fix:** Add an EC to BC-3.9.003 (e.g., EC-3.9.003-5) or a note in BC-3.9.017 step 4: "When invoked from BC-3.9.017's step 4, only the servicedeskapi wire protocol (steps 1-2 of this BC) executes — the confirmation gate is suppressed because it has already resolved in BC-3.9.017 step 2."

---

### FINDING-R9-003 — LOW

**File:** `.factory/phase-f1-delta-analysis/impact-boundary-576.md`
**Location:** Section R3.8b (§R3.8 Orchestrator pattern-extension rulings)
**Description:** R3.8b specifies an implementation step order of: (1) resolve `--public` gate, (2) fetch attachment list, (3) issue DELETE for each matched attachment, (4) upload. BC-3.9.017 (the settled F2 spec, via P2-003) implements a different order: (1) list step, (2) gate step, (3) delete step, (4) upload step. The core safety invariant — no DELETE before any pending gate — is preserved in both orderings. However, R3.8b has no annotation noting that the step order was adjusted at F2.

The pattern for superseded impact-boundary rulings is PHASE-DOC-RETRO-ANNOTATION (applied in R2.2 for OQ-9 silent no-op and in R2.3 for --internal non-JSM correction). R3.8b, which was explicitly marked "FLAG FOR HUMAN REVIEW AT F2," was effectively settled at F2 with a modified step order, but no annotation was added. A reader of R3.8b would see gate-first ordering that conflicts with BC-3.9.017's list-first ordering.

**Impact:** LOW. The actual BC-3.9.017 text is authoritative and correctly implements the safety invariant. This is a documentation gap in the impact boundary that does not affect implementation correctness.

**Suggested fix:** Add a PHASE-DOC-RETRO-ANNOTATION to R3.8b: "SETTLED AT F2 (2026-07-15, BC-3.9.017 P2-003): Step order adjusted to list-before-gate for informative confirmation messaging; core invariant 'no DELETE before gate' preserved. Final ordering: (1) list step, (2) gate step, (3) delete step, (4) upload step. See BC-3.9.017."

---

## 5. R8 Carry-Forward

| Finding | Severity | Status in R9 |
|---------|----------|-------------|
| FINDING-R8-001 | INFO | STILL OPEN. CANONICAL-COUNTS.md Group 19 BC citation "(BC-3.9.015..020)" remains incomplete vs. Group 15 convention. Verified still present on line 128 of CANONICAL-COUNTS.md. Non-blocking cosmetic gap; no correctness impact. |

---

## 6. Count Surface Verification

| Surface | Checked value | Status |
|---------|--------------|--------|
| bc-2-issue-read.md `definitional_count` | 64 | ✓ |
| bc-2-issue-read.md `total_bcs` | 106 | ✓ |
| bc-3-issue-write.md `definitional_count` | 111 | ✓ |
| bc-3-issue-write.md `total_bcs` | 140 | ✓ |
| bc-3-issue-write.md Section 3.9 header | "20 BCs: BC-3.9.001..BC-3.9.020" | ✓ |
| bc-3-issue-write.md footer (definitional) | "111 individually-bodied (cumulative 140 incl. range-collapsed)" | ✓ |
| cross-cutting.md `total_bcs` | 150 | ✓ |
| BC-INDEX.md frontmatter `total_bcs` | 657 | ✓ |
| BC-INDEX.md `index_version` | v6.14 | ✓ |
| BC-INDEX.md Section 2.7 header | "12 BCs: BC-2.7.001..012" | ✓ |
| BC-INDEX.md Section 3.9 header | "20 BCs: BC-3.9.001..020" | ✓ |
| BC-INDEX.md Coverage Statistics Total | 657 / 427 | ✓ |
| CANONICAL-COUNTS.md "Total individually-bodied" | 427 | ✓ |
| CANONICAL-COUNTS.md Sum row | 657 | ✓ |
| CANONICAL-COUNTS.md Grand total | 657 | ✓ |
| CANONICAL-COUNTS.md holdout section total | 95 | ✓ |
| CANONICAL-COUNTS.md Group 19 BC citation | "(BC-3.9.015..020)" | CARRY-FORWARD (FINDING-R8-001 INFO) |
| holdout-scenarios.md `total_holdouts` | 95 | ✓ |
| holdout-scenarios.md Group 19 | 7 scenarios (H-NEW-ATTACHMENT-001..007) | ✓ |
| Actual `grep -c '^#### BC-'` (all 8 files) | matches frontmatter per-file | ✓ |
| Actual `grep -c '^### H-'` | 95 | ✓ |

---

## 7. Full Check-Class Results

| Check class | Result |
|-------------|--------|
| Delete-family state machine | COHERENT. Three forms correctly enumerated in BC-3.9.016. Gate rules consistent (single interactive, bulk explicit). 404 semantics correctly asymmetric (single exit 64, multi skip). JSON shapes BTreeMap-ordered. |
| BC-3.9.017 4-step gate-before-delete | PRESENT with implementation-guidance gap (FINDING-R9-002, LOW). Gate fires before DELETE in step 2; EC-3.9.017-8 (gate-cancel) present. Suppression mechanism for BC-3.9.003's gate in step 4 context underspecified. |
| JSON Output Shape Contracts table completeness | GAP (FINDING-R9-001, MEDIUM). Upload --replace-existing --dry-run shape absent from table. All other registered shapes verified BTreeMap-ordered. |
| Impact-boundary R3.8a/b vs BC text | R3.8a: MATCH. R3.8b: STEP-ORDER DIVERGENCE unannotated (FINDING-R9-003, LOW). Core safety invariant preserved; PHASE-DOC-RETRO-ANNOTATION missing. |
| Duration-unit consistency | CLEAN. All --older-than examples use w/d/h/m only; no seconds, no months. |
| Count/narrative surfaces | CLEAN (carry-forward INFO). All 8 numerical surfaces at 657; holdouts at 95; all per-file definitional counts match grep. |
| Stale markers | CLEAN. No orphaned TODO/FIXME/draft markers. All deferred items (P2-3c, S5 obligations) are legitimate forward-looking. |
| BTreeMap key ordering | CLEAN on registered shapes. New upload --replace-existing --dry-run shape (in BC-3.9.020 body) is correctly ordered but unregistered in table (FINDING-R9-001). |
| P2-003 gate-before-delete invariant | PRESENT. BC-3.9.017 step 2 labelled "Gate step (fire ALL pending confirmation gates BEFORE any destructive call)"; EC-3.9.017-8 added. |
| EC-3.9.015-5 EOF=cancel | PRESENT (P2-002). Exit 0, not exit 130. |
| Three-form delete (BC-3.9.016) | PRESENT (P2-001). EC-3.9.016-6/7/8 verified. |
| Relative timestamps in H-NEW-ATTACHMENT-006 | PRESENT (P2-004). T_now - 14d/10d/1d with drift-prevention note. |
| Wiremock-local content endpoint in H-NEW-ATTACHMENT-002 | PRESENT (P2-005). <JR_BASE_URL>/rest/api/3/attachment/content/10001. |

---

## 8. Summary

**Verdict: GAPS-FOUND** — 3 new findings (MEDIUM×1, LOW×2) + FINDING-R8-001 (INFO) carry-forward.

All 5 HIGH P2 fixes are genuinely present in artifact text. All count surfaces are clean. The delete-family state machine is coherent with no ordering contradictions among BC-3.9.008/010/013/015/016/019/020. The P2-003 gate-before-delete invariant is correctly present in BC-3.9.017.

The MEDIUM finding (R9-001) is the most actionable: the JSON Output Shape Contracts table is missing the `upload --replace-existing --dry-run` shape that P2-018 added to BC-3.9.020's body. This is a table-completeness gap. The two LOW findings are documentation/implementation-guidance issues: an underspecified gate-suppression mechanism in BC-3.9.017 step 4 (R9-002) and an unannotated step-order divergence in impact-boundary R3.8b (R9-003).

| Severity | Count | Description |
|----------|-------|-------------|
| CRITICAL | 0 | — |
| HIGH | 0 | — |
| MEDIUM | 1 | JSON Output Shape Contracts table missing upload --replace-existing --dry-run shape |
| LOW | 2 | BC-3.9.017/003 double-gate underspecification; impact-boundary R3.8b unannotated step-order change |
| INFO | 1 | R8-001 carry-forward (CANONICAL-COUNTS.md Group 19 BC citation incomplete) |
