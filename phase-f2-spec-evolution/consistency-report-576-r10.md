---
report: consistency-report-576-r10
feature: SOH-ATTACHMENTS-1
spec_version: v1.3.45
bc_count: 657
holdout_count: 95
round: R10
date: 2026-07-15
validator: vsdd-factory:consistency-validator (fresh context, no prior round memory)
verdict: CONSISTENT
new_finding_count: 1
new_finding_severity_breakdown: "INFO×1 (worklog audit gap; no correctness impact)"
r9_closure: ALL_3_R9_FINDINGS_CONFIRMED_PRESENT
r8_001_state: REFUTED_CONFIRMED
---

# SOH-ATTACHMENTS-1 F2 Consistency Report — Round R10

**Verdict: CONSISTENT** — All three R9 findings verified present in direct artifact text. R8-001 confirmed refuted (prior rounds mis-quoted the Group 19 line). One new INFO finding: R9-003 fix was applied to impact-boundary-576.md but not logged in prd-delta-576-worklog.md R9 fix section.

---

## 1. Scope

Fresh-context round-10 pass over the full SOH-ATTACHMENTS-1 F2 spec package at spec version v1.3.45 (657 BCs, 95 holdouts), post-R9 fix application. Independent findings formed before reading any prior round report. After forming independent conclusions, R9 report read for comparison and R9-closure verification conducted by direct artifact text (not disposition tables).

Surface set covered (full check-class list):
- `.factory/specs/prd/bc-3-issue-write.md` (Section 3.9, JSON Output Shape Contracts table)
- `.factory/specs/prd/bc-2-issue-read.md` (Section 2.7)
- `.factory/specs/prd/holdout-scenarios.md` (Group 19, H-NEW-ATTACHMENT-001..007)
- `.factory/specs/prd/BC-INDEX.md` (v6.14)
- `.factory/specs/prd/CANONICAL-COUNTS.md`
- `.factory/phase-f2-spec-evolution/prd-delta-576.md` + worklog
- `.factory/phase-f2-spec-evolution/security-review-576.md`
- `.factory/phase-f1-delta-analysis/impact-boundary-576.md` (all revisions + R3.8a/b)
- `.factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md`
- `.factory/specs/architecture/ARCH-INDEX.md` and `.factory/architecture/adr-index.md`
- All BC sections (bc-1 through bc-7, cross-cutting.md)

---

## 2. R9 Closure Verification (direct artifact text)

### R9-001: JSON Output Shape Contracts table — 7th attachment row, `upload --replace-existing --dry-run`, BTreeMap order

**PRESENT.** Verified at `bc-3-issue-write.md` line 3212:

```
| `attachment upload --replace-existing --dry-run` | `{"dryRun":true,"wouldDelete":[{"id":"<AID>","filename":"<name>"}],"wouldUpload":[{"filename":"<name>"}]}` | 3 keys alphabetical (dryRun < wouldDelete < wouldUpload); BC-3.9.020 path c; S5 deferred |
```

BTreeMap ordering verification:
- `dryRun` ('d') < `wouldDelete` ('w') < `wouldUpload` ('w'): first-character comparison 'd' < 'w' ✓
- `wouldDelete` vs `wouldUpload`: shared prefix `would`, then 'D' (4) < 'U' (21) ✓

The table now has 7 attachment-specific data rows (rows at lines 3207–3213); `upload --replace-existing --dry-run` is the 6th attachment row by position, with `upload --public` (deferred) as the 7th. The "7th row" designation in the task and worklog refers to the table having 7 total attachment rows after this addition.

The Sources line at line 3215 also includes the correct addendum: `BC-3.9.020 path c (upload --replace-existing --dry-run, S5 deferred)`. ✓

### R9-002: BC-3.9.003 EC-3.9.003-5 gate-suppression + BC-3.9.017 step-4 cross-reference

**PRESENT and BIDIRECTIONAL.** Both halves verified:

**(a) EC-3.9.003-5** — verified at `bc-3-issue-write.md` line 3308:

> **EC-3.9.003-5** (invoked from BC-3.9.017 `--replace-existing` step 4): the confirmation gate defined in this BC is NOT re-presented. The gate has already been resolved at BC-3.9.017 step 2 (gate step) — if cancelled there, BC-3.9.003 is never reached; if passed there, proceeding to step 4 implies the gate is already satisfied. Only the servicedeskapi wire steps (step 1: `attachTemporaryFile`; step 2: `post_request_attachment`) execute on this call path. Gate state: RESOLVED (do not prompt again). One gate per invocation, ever.

The EC correctly suppresses the gate and specifies what still executes (servicedeskapi wire steps only).

**(b) BC-3.9.017 step 4 cross-reference** — verified at `bc-3-issue-write.md` line 3677:

> 4. **Upload step**: proceed with upload per BC-3.9.001 (platform path) or BC-3.9.003/BC-3.9.004 (JSM path). The `--public` gate (if applicable) has already fired in step 2. **Gate suppression**: when routing to BC-3.9.003 on this step, the confirmation gate defined in BC-3.9.003 MUST NOT be re-presented — it was already resolved in step 2. Only the servicedeskapi wire steps execute (BC-3.9.003 EC-3.9.003-5). One gate per invocation, ever.

Step 4 explicitly names `BC-3.9.003 EC-3.9.003-5` by identifier. The bidirectional reference is complete: EC-3.9.003-5 → BC-3.9.017 step 4 (caller), and step 4 → EC-3.9.003-5 (suppression mechanism). ✓

### R9-003: Impact-boundary R3.8b retro-annotation with list-first→gate→delete→upload settled ordering

**PRESENT.** Verified at `impact-boundary-576.md` lines 713–719, following R3.8b's original gate-first ordering text:

> **[PHASE-DOC-RETRO-ANNOTATION 2026-07-15, R9-003 LOW]** The gate-first ordering above (gate → list → delete → upload) was superseded during BC-3.9.017 finalisation. The settled ordering in BC-3.9.017 is **list-first → gate → delete → upload**:
> 1. If `--replace-existing`: fetch `fields.attachment[]`, identify same-filename entries (GET, read-only)
> 2. Resolve `--public` gate — if present; MAY be skipped when step 1 finds zero matches (no destructive work to confirm); prompt CAN display what will be deleted, drawn from step 1 results
> 3. If `--replace-existing` and gate passed: issue DELETE for each matched attachment
> 4. Upload new file(s) via multipart POST
>
> The safety invariant "no destructive call before a pending confirmation gate" is preserved in both orderings — step 3 (DELETE) still follows step 2 (gate) in the settled form. The list-first change is a UX improvement, not a safety regression: it allows the gate to be a no-op when there are no filename matches, and it allows the confirmation prompt to name what will be deleted.

The annotation includes: the settled 4-step ordering, the UX rationale for list-first, and explicit confirmation that the safety invariant is preserved. ✓

---

## 3. R8-001 Empirical Verification

**R8-001 state: REFUTED.** Verified by direct grep against `CANONICAL-COUNTS.md`.

The actual verbatim Group 19 line at line 128 of CANONICAL-COUNTS.md reads:

```
- Group 19 (Attachment Write, SOH-ATTACHMENTS-1 adversary pass-1 round B, 2026-07-15): H-NEW-ATTACHMENT-001..H-NEW-ATTACHMENT-007 (BC-2.7.001/007/008/010/011 + BC-3.9.001/015..020; issues #576 #585) — +7
```

R9 reported this line had citation `(BC-3.9.015..020)` and was "incomplete vs. Group 15 convention." This was a mis-quote: the actual line contains the full citation `(BC-2.7.001/007/008/010/011 + BC-3.9.001/015..020; issues #576 #585)`, which includes both BC-2.7 and BC-3.9 sections.

Comparison with Group 15 (line 127) for convention reference:
- Group 15: `H-NEW-COMMENT-001..H-NEW-COMMENT-005 (BC-3.5.005/008/004/010/003; issue #577) — +5`
- Group 19: `H-NEW-ATTACHMENT-001..H-NEW-ATTACHMENT-007 (BC-2.7.001/007/008/010/011 + BC-3.9.001/015..020; issues #576 #585) — +7`

Group 19 covers two BC sections (2.7 and 3.9) from two features (#576 and #585), which justifies the `+` separator form. The `BC-3.9.001/015..020` notation uses a mixed `/` and `..` form (BC-3.9.001 as an individual entry, BC-3.9.015..020 as a range). Compared to Group 15's pure slash-separated individual-number form (`005/008/004/010/003`), this is a minor stylistic difference, not an incompleteness. The BC-3.9.002..014 BCs are correctly absent from Group 19 because they belong to the initial F2 addition (adversary pass-0), not round B — Group 19 is specifically for the round B holdouts.

R8-001 is CLOSED (REFUTED). The prior rounds were mis-reading a partial excerpt of the line. The Group 19 citation has been complete throughout.

---

## 4. Count Surface Verification (independent pass)

| File | Actual `grep -c '^#### BC-'` | Frontmatter `definitional_count` | Match? |
|------|------------------------------|----------------------------------|--------|
| bc-1-auth-identity.md | 46 | 46 | YES |
| bc-2-issue-read.md | 64 | 64 | YES |
| bc-3-issue-write.md | 111 | 111 | YES |
| bc-4-assets-cmdb.md | 22 | 22 | YES |
| bc-5-boards-sprints.md | 18 | 18 | YES |
| bc-6-config-cache.md | 33 | 33 | YES |
| bc-7-output-render.md | 49 | 49 | YES |
| cross-cutting.md | 84 | 84 | YES |

- Individually-bodied sum: 46+64+111+22+18+33+49+84 = **427** ✓
- BC-3.9 individually-bodied headings: grep confirms exactly 20 (BC-3.9.001..020) ✓
- `grep -c '^### H-' holdout-scenarios.md` = **95** ✓
- BC-INDEX.md frontmatter `total_bcs: 657`, `index_version: v6.14` ✓
- CANONICAL-COUNTS.md Sum row: 657; "Total individually-bodied": 427 ✓
- holdout-scenarios.md frontmatter `total_holdouts: 95` ✓

---

## 5. New Finding

### FINDING-R10-001 — INFO

**File:** `prd-delta-576-worklog.md`
**Location:** Consistency Review Round 9 (R9) Fix Round section
**Description:** The R9 fix round section of the worklog records entries for R9-001 (APPLIED), R9-002 (APPLIED), and R8-001 (REFUTED), but contains no entry for R9-003. Yet R9-003 WAS applied: `impact-boundary-576.md` carries the PHASE-DOC-RETRO-ANNOTATION labeled `[PHASE-DOC-RETRO-ANNOTATION 2026-07-15, R9-003 LOW]` at lines 713–719. The fix was applied to the artifact but not recorded in the worklog.

**Impact:** INFO. The worklog is a documentation audit trail; the missing entry creates an incomplete record but does not affect any behavioral contract, count, or spec correctness. The annotation is present in impact-boundary-576.md and verifiable at any time.

**Suggested fix (optional):** Add a worklog entry in the R9 fix round section:
```
| R9-003 | LOW | APPLIED | PHASE-DOC-RETRO-ANNOTATION added to impact-boundary-576.md R3.8b: settled ordering is list-first → gate → delete → upload (BC-3.9.017 steps 1–4); gate-first ordering from original R3.8b superseded at F2; safety invariant preserved. File: impact-boundary-576.md |
```

---

## 6. Full Check-Class Results

| Check class | Result |
|-------------|--------|
| R9-001 (JSON shape table row) | CONFIRMED PRESENT. `upload --replace-existing --dry-run` row at bc-3-issue-write.md line 3212. BTreeMap order verified: dryRun < wouldDelete < wouldUpload. Sources line updated. |
| R9-002 (EC-3.9.003-5 + step-4 cross-ref) | CONFIRMED PRESENT. EC-3.9.003-5 at line 3308. BC-3.9.017 step 4 at line 3677 explicitly cites BC-3.9.003 EC-3.9.003-5. Bidirectional. |
| R9-003 (R3.8b retro-annotation) | CONFIRMED PRESENT. Lines 713–719 of impact-boundary-576.md. List-first→gate→delete→upload (steps 1–4) and safety-invariant statement present. Tag: R9-003 LOW. |
| R8-001 empirical re-verification | REFUTED. Verbatim Group 19 line quoted above. Prior rounds misquoted partial excerpt. R8-001 is CLOSED. |
| Delete-family state machine | COHERENT (unchanged from R9). Three forms correctly encoded in BC-3.9.016. Gate rules consistent: single interactive, multi-AID explicit, --older-than explicit. `--dry-run` exempt. JSON shapes BTreeMap-ordered. |
| BC-3.9.017 4-step gate-before-delete | PRESENT AND CORRECT. Steps: list (1) → gate (2) → delete (3) → upload (4). Gate-suppression mechanism fully specified via EC-3.9.003-5. EC-3.9.017-8 (gate-cancel → no DELETEs) present. |
| JSON Output Shape Contracts table completeness | COMPLETE. All 7 attachment rows present and BTreeMap-ordered. Upload --replace-existing --dry-run row confirmed (R9-001 fix). |
| Impact-boundary R3.8a/b vs BC text | MATCH. R3.8a encodes multi-positional bulk via BC-3.9.016 ✓. R3.8b retro-annotated with correct settled ordering (R9-003 fix) ✓. |
| Duration-unit consistency | CLEAN. All `--older-than` examples use w/d/h/m only. |
| Count/narrative surfaces | CLEAN. All 8 BC files match frontmatter per-file. Sum 427/657. Holdouts 95. |
| Stale markers | CLEAN. All (implementation pending — story S3/S4/S5) and deferred markers are legitimate forward-looking. |
| ADR-0017 citation integrity | CLEAN. File exists at `.factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md`. ARCH-INDEX.md lists it at SS-03/SS-09. adr-index.md entry consistent. BC-3.9.001 cites "Detail: ADR-0017" without path — consistent with other ADR citations in the spec. |
| Both ADR indices | CONSISTENT. ARCH-INDEX.md and `.factory/architecture/adr-index.md` both register ADR-0017 (accepted). |
| Worklog audit trail | INCOMPLETE (FINDING-R10-001 INFO). R9-003 fix applied but not logged. No correctness impact. |
| Delete-family coherence | COHERENT. BC-3.9.008/010/013/015/016/019/020 — gate rules, 404 semantics, JSON shapes all consistent. BC-3.9.017 step 4 + EC-3.9.003-5 prevent double-prompt on --replace-existing --public path. |

---

## 7. Summary

**Verdict: CONSISTENT** — the post-R9 fix spec package at v1.3.45 has no behavioral contradictions, no missing table entries, and no unresolved cross-reference gaps. All three R9 findings are confirmed applied and present in direct artifact text.

R8-001 is definitively REFUTED: the verbatim Group 19 line in CANONICAL-COUNTS.md has always contained `(BC-2.7.001/007/008/010/011 + BC-3.9.001/015..020; issues #576 #585)` — prior rounds misquoted a partial fragment as the complete text.

The single new R10 finding is an audit-trail gap: R9-003 was applied to `impact-boundary-576.md` but not logged in the prd-delta-576-worklog.md R9 fix section. This is INFO severity and does not affect any behavioral contract.

| Severity | Count | Description |
|----------|-------|-------------|
| CRITICAL | 0 | — |
| HIGH | 0 | — |
| MEDIUM | 0 | — |
| LOW | 0 | — |
| INFO | 1 | R9-003 fix applied but not logged in worklog R9 section |
