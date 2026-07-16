---
report_id: consistency-report-576-r15
round: 15
spec_version: 1.3.45
bc_count: 657
holdout_count: 96
verdict: GAPS-FOUND
gap_count: 1
gap_severity_breakdown: "LOW×1"
prior_round: consistency-report-576-r14.md
date: 2026-07-15
adversary_pass: 5 (post-remediation)
validator: cv-f2-576-r15 (fresh context, no prior round memory)
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 15

**Spec version:** 1.3.45 · **BCs:** 657 · **Holdouts:** 96 · **Verdict:** GAPS-FOUND (1 gap: LOW×1)

---

## 1. Surface Coverage

All surfaces in the mandated surface set were read:

| Surface | File | Status |
|---------|------|--------|
| BC-2.7 (Attachment Read) | `.factory/specs/prd/bc-2-issue-read.md` | Read |
| BC-3.5 (Comment CRUD — delete/edit gates) | `.factory/specs/prd/bc-3-issue-write.md` (§3.5) | Read |
| BC-3.9 (Attachment Write) | `.factory/specs/prd/bc-3-issue-write.md` (§3.9) | Read |
| BC-INDEX | `.factory/specs/prd/BC-INDEX.md` | Read |
| CANONICAL-COUNTS | `.factory/specs/prd/CANONICAL-COUNTS.md` | Read |
| holdout-scenarios | `.factory/specs/prd/holdout-scenarios.md` | Read |
| prd-delta | `.factory/phase-f2-spec-evolution/prd-delta-576.md` | Read |
| prd-delta worklog | `.factory/phase-f2-spec-evolution/prd-delta-576-worklog.md` | Read |
| security-review | `.factory/phase-f2-spec-evolution/security-review-576.md` | Read (via prd-delta verdict) |
| R14 report | `.factory/phase-f2-spec-evolution/consistency-report-576-r14.md` | Read |
| impact-boundary (all revisions) | `.factory/phase-f1-delta-analysis/impact-boundary-576.md` | Read |
| Research Parts 1-3 | `.factory/research/issue-576-attachments-api-2026-07-15.md` | Read (via prior surfaces) |
| ADR-0017 | `.factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md` | Confirmed present |
| ADR index (factory) | `.factory/architecture/adr-index.md` | Read |
| ADR index (specs) | `.factory/specs/architecture/ARCH-INDEX.md` | Read |

---

## 2. R14 Gap Closure (all 6 confirmed closed)

All six GAP-R14-001..006 are CONFIRMED CLOSED by the R14 micro-pass (worklog entry "R14 Micro-Pass 2026-07-15, 6 single-value edits"). Direct verification:

**GAP-R14-001 — prd-delta-576.md `holdout_count_after` stale:**
> Quote — current frontmatter value: `holdout_count_after: 96`

CLOSED ✓

**GAP-R14-002 — holdout-scenarios.md Group 19 trace prose stale count:**
> Quote — current preamble line 22: `SOH-ATTACHMENTS-1 F2 (2026-07-15, adversary pass-1 human ruling R3): attachment list/download/upload/delete — 8 new scenarios H-NEW-ATTACHMENT-001..008 (BC-2.7.001 zero/N-attach list + null-author, BC-2.7.007 write-to-temp+atomic-rename, ...)`

CLOSED ✓

**GAP-R14-003 — CANONICAL-COUNTS.md range text stale:**
> Quote — current range text (CANONICAL-COUNTS.md line 120): `Groups added since last reconciliation (57 → 96):`

CLOSED ✓

**GAP-R14-004 — BC-INDEX BC-2.7.007 row omits 403→exit-1 EC-2.7.007-1b:**
> Quote — BC-INDEX BC-2.7.007 row (fragment): `..."Attachment <AID> not found or not accessible." canonical not-found string; default filename = bare sanitized basename (no SHA-1 prefix — single-id bare naming per BC-2.7.010)... 403 → exit 1 permission-denied (EC-2.7.007-1b)...`

CLOSED ✓

**GAP-R14-005 — BC-INDEX BC-2.7.012 row taxonomy description omits 403:**
> Quote — BC-INDEX BC-2.7.012 row (fragment): `...full error taxonomy table (404/403/401/5xx/network)...`

CLOSED ✓

**GAP-R14-006 — prd-delta-576.md CONS-576-005 disposition stale:**
> Quote — prd-delta-576.md CONS-576-005 row: `| CONS-576-005 | LOW | (routed to security reviewer) | security-review-576.md verdict annotation | RESOLVED (security-review-576.md verdict: APPROVE, status: final) |`

CLOSED ✓

---

## 3. P5 Keystone Closure Table (Priority a, b, c)

### P5-001 — BC-3.9.015 three-way branch; removed false-divergence note; BC-3.9.014 EOF exception; BC-INDEX alignment

**Status: CLOSED**

**Quote — BC-3.9.015 step-1 three-way branch body (bc-3-issue-write.md, ~line 3615):**
> `**Three-way branch** (DEC-174/EC-3.5.003-3 alignment): (a) "y"/"yes" → proceed; (b) any other non-empty text, or empty-Enter (read_line returns Ok(n), n ≥ 1, buffer "\n") → cancel, exit 0 ("Deletion cancelled."); (c) EOF — read_line returns Ok(0) (zero bytes, Ctrl+D) — or any Err(_) (IO error) → JrError::Interrupted, exit 130 (NOT the cancel path). Ok(0) is distinguishable from empty-Enter (Ok(n), n ≥ 1) — the distinction is real and load-bearing.`

**Quote — EC-3.9.015-5 with divergence note REMOVED (bc-3-issue-write.md):**
> `**EC-3.9.015-5** (EOF / Ctrl+D on prompt read → JrError::Interrupted, exit 130): read_line returns Ok(0) (zero bytes, no newline) on EOF — distinguishable from empty-Enter (Ok(n), n ≥ 1, buffer "\n"). Both Ok(0) (EOF) and any Err(_) (IO error) MUST propagate as JrError::Interrupted; exit 130; NO cancel output on this path (exit 130 is an interruption, not a user cancel). This **mirrors BC-3.5.003/EC-3.5.003-3 and BC-3.5.008/EC-3.5.008-5** — the comment family (using the same eprint!+read_line DEC-174 mechanism) uses the same three-way branch. The prior "deliberate divergence from BC-3.5.003" note is **REMOVED** (P5-001 ruling: the divergence was based on a false premise — the Ok(0) vs Ok(n) distinction makes EOF distinguishable from empty-Enter; the original claim that read_line makes them indistinguishable was incorrect).`

The "deliberate divergence from BC-3.5.003" note is confirmed REMOVED. ✓

**Quote — BC-3.9.014 EOF exception (bc-3-issue-write.md, ~line 3583):**
> `**Exception — EOF and IO error** (DEC-174/EC-3.5.003-3 alignment): read_line returning Ok(0) (zero bytes, Ctrl+D EOF) or Err(_) MUST propagate as JrError::Interrupted, exit 130 — consistent with the comment-family precedent (BC-3.5.003, BC-3.5.008).`

Present ✓

**Quote — BC-INDEX BC-3.9.015 row (BC-INDEX.md line 387):**
> `| BC-3.9.015 | attachment delete <AID> interactive confirmation gate: eprint!+read_line (DEC-174); non-interactive exit 64 + --yes hint; --yes bypasses; cancel {"cancelled":true,"deleted":false} (no id key); metadata-fetch GET before prompt; three-way branch: 'y'/'yes' → delete; empty-Enter → cancel exit 0; EOF (Ok(0)) or IO-error → JrError::Interrupted exit 130; mirrors BC-3.5.003/EC-3.5.003-3 (divergence note removed — P5-001 ruling) | — (SOH-ATTACHMENTS-1 adversary pass-1 R2; P5-001 correction) | src/cli/issue/attachments.rs (pending S4) | HIGH |`

Three-way branch noted ✓; divergence note removed ✓; P5-001 ruling cited ✓

**Quote — BC-3.5.003 EC-3.5.003-3 (read for mirror verification; bc-3-issue-write.md ~line 2199):**
> `**EC-3.5.003-3** (dialoguer Err → JrError::Interrupted exit 130 on delete prompt): When the comment delete confirmation prompt receives a dialoguer::Error (including EOF — Ctrl+D — or Ctrl+C interrupt mid-prompt), the handler MUST propagate it as JrError::Interrupted; exit 130. A dialoguer::Error MUST NOT be silently swallowed or mapped to the cancel path (exit 0).`

The behavioral outcome (exit 130 on EOF/interrupt) is consistent with BC-3.9.015/EC-3.9.015-5. **Mechanism language discrepancy noted — see GAP-R15-001 below.**

---

### P5-002 — `tmp_<random>` scheme in BC-2.7.007

**Status: CLOSED**

**Quote — BC-2.7.007 write-to-temp clause (bc-2-issue-read.md, ~line 729):**
> `**Write-to-temp + atomic-rename**: The download MUST write to a temporary file named tmp_<random> in the same directory as the final path (where <random> is a process-unique random string; NO basename is embedded). A deterministic or basename-derived name (e.g., .partial suffix, tmp_<random>_<basename>) MUST NOT be used — a fixed name collides when two processes download to the same directory concurrently, and embedding the basename risks overflowing NAME_MAX when the sanitized basename is near the 214-byte cap (41-byte SHA-1 prefix + random token + basename can exceed 255 bytes on the temp filename even when the final name fits).`

`tmp_<random>` (no basename) confirmed ✓. `tmp_<random>_<basename>` explicitly PROHIBITED ✓.

**Quote — EC-2.7.007-4 (bc-2-issue-read.md):**
> `**EC-2.7.007-4** (error mid-stream): temporary file (tmp_<random>) deleted; exit 1; "Download failed: <reason>" on stderr; final path not written.`

Updated to `tmp_<random>` ✓

**Quote — EC-2.7.007-8 concurrent-downloads clause (bc-2-issue-read.md):**
> `**EC-2.7.007-8** (concurrent downloads, same out-dir): if two jr processes download the same attachment to the same output directory simultaneously, each writes to its own uniquely-named tmp_<random> file. There is no interleaving of temp files.`

Updated to `tmp_<random>` ✓

---

### P5-003 — H-NEW-ATTACHMENT-002 `tmp_*` assertions

**Status: CLOSED**

**Quote — H-NEW-ATTACHMENT-002 success path (holdout-scenarios.md ~line 2119):**
> `No tmp_* temp file remains in WORK_DIR after successful completion (temp renamed away on atomic rename).`

`tmp_*` (not `.partial`) ✓

**Quote — H-NEW-ATTACHMENT-002 error path (holdout-scenarios.md ~line 2131):**
> `No tmp_* file remains in WORK_DIR (temp cleaned up per BC-2.7.007 EC-2.7.007-4).`

`tmp_*` ✓

**Quote — H-NEW-ATTACHMENT-002 status line and Why-hidden (holdout-scenarios.md ~line 2133):**
> `**Why hidden**: The write-to-temp+atomic-rename contract prevents partial files from appearing as complete downloads. A regression that writes directly to the final path would leave corrupt files on error, visible to users but undetectable by a success-only test. The temp-file cleanup assertion is the key signal.`

No `.partial` references remain ✓

---

## 4. Impact-Boundary Verification (Priority c — planned→authored ID-drift)

### R2.3 planned→authored ID-drift annotation

**Status: PRESENT**

**Quote — R2.3 annotation header (impact-boundary-576.md ~line 473):**
> `> **[PLANNED→AUTHORED ID DRIFT retro-annotation 2026-07-15 (PG-F3-1 verify-before-cite class):** The four planned IDs above do NOT match the authored IDs in bc-3-issue-write.md. The PO reorganized the Section 3.9 numbering when authoring — inserting additional BCs earlier in the sequence caused all four R2.3 planned IDs to shift. Full mapping (verified against #### BC-3.9.0NN headings in the authored spec):`

**Quote — mapping table (impact-boundary-576.md ~lines 474-480):**
> `| Planned (this table) | Authored (bc-3-issue-write.md) | Subject |`
> `|----------------------|----------------------------------|---------|`
> `| BC-3.9.011 | **BC-3.9.003** | --public flag → servicedeskapi two-step routing + JSM-only gate |`
> `| BC-3.9.012 | **BC-3.9.004** | --internal flag → servicedeskapi two-step; non-JSM = silent no-op (OQ-9) |`
> `| BC-3.9.013 | **BC-3.9.014** | --public interactive confirmation gate mechanics (DEC-174) |`
> `| BC-3.9.014 | **BC-3.9.011** | --public --output json shape — deferred-probe contract (P2-3c) |`

Present and correct ✓

### Three inline [PLANNED ID] markers

All three are present with correct cross-references:

**Marker 1 (impact-boundary-576.md ~line 504):**
> `BC-3.9.014 **[PLANNED ID — authored as BC-3.9.011; see R2.3 drift annotation]**`

Present ✓

**Marker 2 (impact-boundary-576.md ~line 549):**
> `BC-3.9.013 **[PLANNED ID — authored as BC-3.9.014; see R2.3 drift annotation]**`

Present ✓

**Marker 3 (impact-boundary-576.md ~line 561):**
> `BC-3.9.014 **[PLANNED ID — authored as BC-3.9.011; see R2.3 drift annotation]**`

Present ✓

### R3.11 citing BC-3.9.014 (authored ID)

**Quote — R3.11 closing sentence (impact-boundary-576.md ~line 783):**
> `the F2 spec for BC-3.9.015 (delete gate) and BC-3.9.014 (--public gate) MUST reproduce this three-way branch verbatim.`

R3.11 uses BC-3.9.015 and BC-3.9.014 — both are authored IDs (matching bc-3-issue-write.md headings). R3.5 confirms "The R3.5 planned BCs (BC-3.9.015–020) match authored IDs exactly and are NOT affected." ✓

---

## 5. Gate Mechanics Coherence (Priority a — all four gates)

| Gate | BC | Mechanism | Three-way branch | Exit codes (y/n/EOF) |
|------|----|-----------|-----------------|---------------------|
| comment delete | BC-3.5.003 (items 1-3) + EC-3.5.003-3 | DEC-174 read_line (delivery obligation) | Implicit: items 1/2/EC-3.5.003-3 | 0/0/130 |
| comment edit --public | BC-3.5.008 + EC-3.5.008-5 | DEC-174 read_line (delivery obligation) | Implicit: items analogous to BC-3.5.003 | 0/0/130 |
| attachment upload --public | BC-3.9.014 + "Exception" clause | DEC-174 read_line (body) | Implicit: EC-3.9.014-1/2 + Exception | 0/0/130 |
| attachment delete | BC-3.9.015 step-1 + EC-3.9.015-5 | DEC-174 read_line (body) | Explicit three-way branch | 0/0/130 |

Behavioral outcome is **coherent** across all four gates: affirmative → proceed, empty-Enter → cancel exit 0, EOF/IO-error → exit 130.

**Mechanism terminology asymmetry (→ GAP-R15-001):** EC-3.5.003-3 and EC-3.5.008-5 use "dialoguer::Error" while EC-3.9.015-5 uses "read_line Ok(0)/Err(_)". The authoritative mechanism (DEC-174 read_line) is present in the delivery obligations in the same BCs, but the EC clauses themselves were not updated when DEC-174 was applied at v1.3.41. See §6 for full analysis.

---

## 6. New Finding (Round 15)

### GAP-R15-001 — EC-3.5.003-3 and EC-3.5.008-5 mechanism language stale relative to DEC-174 (and relative to EC-3.9.015-5 which claims to mirror them)

**Severity:** LOW
**Files:** `.factory/specs/prd/bc-3-issue-write.md` (EC-3.5.003-3 ~line 2199; EC-3.5.008-5 ~line 2425)

**Finding:**

EC-3.5.003-3 and EC-3.5.008-5 were added at adversary pass-35 using "dialoguer::Error" terminology — at that point the mechanism was still under design discussion. DEC-174 (v1.3.41, 2026-07-13) mandated the `eprint!+read_line` mechanism and explicitly stated "`dialoguer::interact_on` is UNUSABLE" on piped stderr. The DEC-174 correction updated the **delivery obligations** in BC-3.5.003 and BC-3.5.006 (and VP-577-030), but the **EC clause text** in EC-3.5.003-3 and EC-3.5.008-5 was not updated and still uses "dialoguer::Error" language.

P5-001 then wrote BC-3.9.015 step-1 and EC-3.9.015-5 using DEC-174-aligned `read_line Ok(0)/Err(_)` language, and explicitly stated EC-3.9.015-5 "mirrors BC-3.5.003/EC-3.5.003-3 and BC-3.5.008/EC-3.5.008-5". This creates a visible cross-gate terminology inconsistency between EC-3.5.003-3/EC-3.5.008-5 (dialoguer language) and EC-3.9.015-5 (read_line language).

**Quote — EC-3.5.003-3 current text (stale mechanism language):**
> `**EC-3.5.003-3** (dialoguer Err → JrError::Interrupted exit 130 on delete prompt): When the comment delete confirmation prompt receives a dialoguer::Error (including EOF — Ctrl+D — or Ctrl+C interrupt mid-prompt), the handler MUST propagate it as JrError::Interrupted; exit 130. A dialoguer::Error MUST NOT be silently swallowed or mapped to the cancel path (exit 0).`

**Quote — EC-3.5.008-5 current text (stale mechanism language):**
> `**EC-3.5.008-5** (dialoguer Err → JrError::Interrupted exit 130 on --public prompt): When the --public confirmation prompt receives a dialoguer::Error (including EOF — Ctrl+D — or Ctrl+C interrupt mid-prompt), the handler MUST propagate it as JrError::Interrupted; exit 130. This mirrors EC-3.5.003-3 (delete prompt), ensuring consistent Ctrl+C / EOF handling across all interactive confirmation prompts in the comment family. A dialoguer::Error MUST NOT be silently swallowed or mapped to the cancel path (exit 0).`

**Quote — EC-3.9.015-5 (current, DEC-174 mechanism language):**
> `EC-3.9.015-5 ... read_line returns Ok(0) (zero bytes, no newline) on EOF — distinguishable from empty-Enter (Ok(n), n ≥ 1, buffer "\n"). Both Ok(0) (EOF) and any Err(_) (IO error) MUST propagate as JrError::Interrupted; exit 130 ... This mirrors BC-3.5.003/EC-3.5.003-3 and BC-3.5.008/EC-3.5.008-5`

**Behavioral impact:** NONE. The behavioral outcome (exit 130 on EOF/interrupt) is identical across all four gates. The authoritative mechanism language in the delivery obligations of BC-3.5.003 and BC-3.5.006 correctly mandates `eprint!+read_line`. An implementer reading the full BC body will implement correctly.

**Implementer confusion risk:** LOW. A reader examining only EC-3.5.003-3 in isolation could believe dialoguer is the mechanism; the delivery obligation in the same BC corrects this. A reader comparing EC-3.5.003-3 with EC-3.9.015-5 sees a mechanism terminology mismatch despite the "mirrors" claim.

**Fix scope:** Update EC-3.5.003-3 and EC-3.5.008-5 to use DEC-174 `read_line` terminology. Rename the EC headings from "dialoguer Err" to "EOF / IO error" (matching the EC-3.9.015-5 pattern). Behavioral semantics UNCHANGED — no new behavior; purely a terminology correction. No BC counts change.

---

## 7. Temp-Scheme Coherence (Priority b — full surface scan)

No stale `.partial` or `tmp_<random>_<basename>` references found anywhere in the spec package after P5-002/P5-003 remediation.

| Surface | Expected | Present |
|---------|----------|---------|
| BC-2.7.007 write-to-temp clause | `tmp_<random>` (no basename) | ✓ |
| BC-2.7.007 prohibition clause | `.partial` MUST NOT; `tmp_<random>_<basename>` MUST NOT | ✓ |
| EC-2.7.007-4 (error mid-stream) | `tmp_<random>` | ✓ |
| EC-2.7.007-5 (Ctrl+C mid-stream) | `tmp_<random>` | ✓ |
| EC-2.7.007-8 (concurrent downloads) | `tmp_<random>` | ✓ |
| H-NEW-ATTACHMENT-002 success path | `tmp_*` (wildcard) | ✓ |
| H-NEW-ATTACHMENT-002 error path | `tmp_*` (wildcard) | ✓ |

---

## 8. Planned-vs-Authored ID Citations (Priority c)

Scanned all spec and prd-delta files for citations of the R2.3 planned IDs (BC-3.9.011, BC-3.9.012, BC-3.9.013, BC-3.9.014 as "the --public gate"):

**In impact-boundary-576.md:** Three [PLANNED ID] markers at R2.4 (~line 504), R2.5 SQ-7 (~line 549), and R2.6 (~line 561). All three carry the retro-annotation "[PLANNED ID — authored as BC-3.9.0NN; see R2.3 drift annotation]". No un-annotated planned-ID citations found.

**In prd-delta-576.md:** All BC citations use authored IDs:
- Story table (line 35): S5 cites "BC-3.9.003..007, BC-3.9.011, BC-3.9.014, BC-X.8.010" (authored IDs) ✓
- BC tracking table: BC-3.9.011 row, BC-3.9.014 row, BC-3.9.012/013 rows — all authored IDs ✓

**In holdout-scenarios.md:** H-NEW-ATTACHMENT-008 BC refs use "BC-3.9.005" (authored ID for `--public` non-JSM guard) ✓

No un-annotated stale planned-ID citations anywhere in the package. R3.11 uses authored IDs BC-3.9.015 and BC-3.9.014 correctly.

---

## 9. Standard Check-Class Summary (Priority d)

| Check class | Result | Notes |
|-------------|--------|-------|
| BC count 657 across all surfaces | PASS | BC-INDEX frontmatter `total_bcs: 657`; bc-2 `total_bcs: 106`; bc-3 `total_bcs: 140`; CANONICAL-COUNTS sum 657; prd-delta after-count 657 |
| Holdout count 96 across all surfaces | PASS | All surfaces correctly read 96; R14-001/002/003 closed |
| ADR-0017 in both ADR indices | PASS | factory `adr-index.md` line 53; specs `ARCH-INDEX.md` line 34 |
| Security review verdict APPROVE | PASS | prd-delta CONS-576-005 "RESOLVED (security-review-576.md verdict: APPROVE, status: final)"; R14-006 closed |
| P5-001 keystone (three-way branch) | PASS | BC-3.9.015 step-1 explicit; EC-3.9.015-5 complete; BC-INDEX row correct |
| P5-001 — divergence note removed | PASS | "prior 'deliberate divergence from BC-3.5.003' note is **REMOVED**" confirmed present |
| P5-001 — BC-3.9.014 EOF exception | PASS | "Exception — EOF and IO error (DEC-174/EC-3.5.003-3 alignment)" confirmed present |
| P5-002 — tmp_<random> in BC-2.7.007 | PASS | `tmp_<random>` with NO basename; explicit prohibition of `tmp_<random>_<basename>` |
| P5-003 — H-NEW-ATTACHMENT-002 tmp_* | PASS | `tmp_*` (success + error paths); no `.partial` references |
| Four-gate behavioral coherence | PASS | All gates: affirmative → proceed; empty-Enter → cancel exit 0; EOF/IO → exit 130 |
| Four-gate mechanism terminology | PARTIAL (GAP-R15-001) | EC-3.5.003-3/EC-3.5.008-5 stale "dialoguer::Error" vs EC-3.9.015-5 "read_line Ok(0)/Err(_)" |
| Temp-scheme coherence (all surfaces) | PASS | No stale `.partial` or `tmp_<random>_<basename>` found |
| Impact-boundary R2.3 annotation | PASS | Drift annotation present with full mapping table |
| Impact-boundary [PLANNED ID] markers | PASS | All 3 markers at correct locations with retro-annotation |
| Impact-boundary R3.11 citing BC-3.9.014 | PASS | Authored ID BC-3.9.014 (`--public` gate) + BC-3.9.015 (delete gate) ✓ |
| Planned-vs-authored ID drift scan | PASS | No un-annotated stale planned-ID citations in any surface |
| R14 gaps all closed | PASS | All 6 confirmed DONE in worklog |
| P5 full pass (P5-001..010) | PASS | All 10 P5 findings confirmed DONE in worklog |
| Research Parts 1-3 present | PASS | Confirmed via prd-delta and holdout references |
| CANONICAL-COUNTS +6 round B attribution | PASS | last_verified line 5, per-file table line 79, note line 66 all record "+6 BC-3.9.015..020 adversary pass-1 round B" |

---

## 10. Summary

**Verdict: GAPS-FOUND — 1 gap (LOW×1); spec is implementation-ready.**

All P5 keystone remediations (P5-001 through P5-010) are verifiably present. All R14 gaps are confirmed closed. The impact-boundary R2.3 drift annotation, three [PLANNED ID] markers, and R3.11 are all present and correct. The temp-file naming scheme (`tmp_<random>`, no basename) is coherent across BC-2.7.007 and H-NEW-ATTACHMENT-002. All four confirmation gates cohere behaviorally (same three-way branch, same exit codes).

The one new finding (GAP-R15-001) is a terminology inconsistency: EC-3.5.003-3 and EC-3.5.008-5 (comment family, §3.5) still use "dialoguer::Error" terminology that predates DEC-174, while EC-3.9.015-5 (attachment delete, §3.9) — which claims to "mirror" them — uses the correct DEC-174 `read_line Ok(0)/Err(_)` language. Behavioral semantics are identical. The fix is purely terminological (update the two EC clause headings and bodies to DEC-174 language; no behavioral change, no BC count change).

Recommendation: address GAP-R15-001 in a pre-S1 sweep alongside the remaining cosmetic fixes from prior rounds. This is the only gap blocking a clean CONSISTENT verdict.

---

*Report generated: 2026-07-15 | Validator: cv-f2-576-r15 | No fixes applied — report only.*
