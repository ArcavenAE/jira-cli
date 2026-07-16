---
report_id: consistency-report-576-r14
round: 14
spec_version: 1.3.45
bc_count: 657
holdout_count: 96
verdict: GAPS-FOUND
gap_count: 6
gap_severity_breakdown: "LOW×4, INFO×2"
prior_round: consistency-report-576-r13.md
date: 2026-07-15
adversary_pass: 4 (post-remediation)
validator: cv-f2-576-r14 (fresh context, no prior round memory)
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 14

**Spec version:** 1.3.45 · **BCs:** 657 · **Holdouts:** 96 · **Verdict:** GAPS-FOUND (6 gaps: LOW×4, INFO×2)

---

## 1. Surface Coverage

All surfaces in the mandated surface set were read:

| Surface | File | Status |
|---------|------|--------|
| BC-2.7 (Attachment Read) | `.factory/specs/prd/bc-2-issue-read.md` | Read |
| BC-3.9 (Attachment Write) | `.factory/specs/prd/bc-3-issue-write.md` | Read |
| BC-INDEX | `.factory/specs/prd/BC-INDEX.md` | Read |
| CANONICAL-COUNTS | `.factory/specs/prd/CANONICAL-COUNTS.md` | Read |
| holdout-scenarios | `.factory/specs/prd/holdout-scenarios.md` | Read |
| prd-delta | `.factory/phase-f2-spec-evolution/prd-delta-576.md` | Read |
| prd-delta worklog | `.factory/phase-f2-spec-evolution/prd-delta-576-worklog.md` | Read |
| security-review | `.factory/phase-f2-spec-evolution/security-review-576.md` | Read |
| R13 report | `.factory/phase-f2-spec-evolution/consistency-report-576-r13.md` | Read |
| impact-boundary | `.factory/phase-f1-delta-analysis/impact-boundary-576.md` | Read |
| Research Part 1 | `.factory/research/issue-576-attachments-api-2026-07-15.md` (§Part 1) | Read |
| Research Part 2 | `.factory/research/issue-576-attachments-api-2026-07-15.md` (§Part 2) | Read |
| Research Part 3 | `.factory/research/issue-576-attachments-api-2026-07-15.md` (§Part 3) | Read |
| ADR-0017 | `.factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md` | Read |
| ADR index (factory) | `.factory/architecture/adr-index.md` | Read |
| ADR index (specs) | `.factory/specs/architecture/ARCH-INDEX.md` | Read |

---

## 2. Prior-Round Gap Closure

### GAP-R13-001 (dry-run inner key order `{id,filename}` vs `{filename,id}`)

**Status: CLOSED** (micro-fix applied after R13, before R14).

The BC-3.9.020 body and BC-INDEX row both now read `{filename,id}` (alphabetical order, `f < i`). Confirmed by direct read of BC-3.9.020 body and BC-INDEX row before R14 analysis.

---

## 3. P4 Keystone Fix Closure Table

### P4-001 — BC-2.7.010 Three-Section Naming (single-id bare / batch SHA-1 / degenerate fallback)

**Status: CLOSED**

**Quote — BC-2.7.010 heading (bc-2-issue-read.md):**
> `#### BC-2.7.010 — Output filename (sanitized basename; single-id bare vs batch SHA-1-prefix; degenerate fallback)`

**Quote — single-id bare section (bc-2-issue-read.md, BC-2.7.010):**
> `**Single-id download (--id only, no batch):** the output filename is the **bare sanitized basename** — `sanitize_attachment_filename(server_filename)`. No SHA-1 prefix. No id prefix. Rationale: targeted single-file download should produce a human-readable filename (curl convention, research Part 3 P3-1 peer survey).`

**Quote — batch SHA-1 section (bc-2-issue-read.md, BC-2.7.010):**
> `**Batch download (--all or multiple --id):** the output filename is `<sha1-hex-of-attachment-id>_<sanitized-basename>`. The SHA-1 prefix is computed from the attachment ID (not the filename). Rationale: multiple attachments in a batch may share the same sanitized basename (e.g. two attachments named "screenshot.png"); the SHA-1 prefix guarantees no collision within a batch, while keeping the human-readable portion visible.`

**Quote — degenerate fallback section (bc-2-issue-read.md, BC-2.7.010):**
> `**Degenerate-name fallback:** if `sanitize_attachment_filename` returns `None` or an empty string for a given attachment (extreme input: filename is all-reserved characters), the bare output filename is the attachment id string (numeric decimal; always a safe filesystem name). A `--verbose` info note is emitted to stderr: `"warning: using id as filename for attachment <AID> (sanitization yielded empty name)"`.`

**Quote — BC-2.7.007 alignment (single-id output path sentence, bc-2-issue-read.md):**
> `If `--output-dir` is not set, the download lands in the current working directory. The output filename is the **bare sanitized basename** (no SHA-1 prefix — single-id bare naming per BC-2.7.010).`

**Quote — BC-INDEX BC-2.7.007 row (alignment with bare-naming ruling):**
> `...`"Attachment <AID> not found or not accessible."` canonical not-found string; default filename = bare sanitized basename (no SHA-1 prefix — single-id bare naming per BC-2.7.010)...`

**Quote — BC-INDEX BC-2.7.010 row (three-section coverage):**
> `...Output filename rules: single-id download → bare sanitized basename (no SHA-1 prefix, human-readable, curl convention); batch download (--all or multi --id) → SHA-1(id)_sanitized-basename (collision-free within batch); degenerate fallback (sanitization yields empty/None) → attachment-id string as filename (stderr warning emitted)...`

**Quote — H-NEW-ATTACHMENT-002 bare notes.txt (holdout-scenarios.md):**
> The holdout scenario sets `"filename":"notes.txt"` and expects `WORK_DIR/notes.txt` (bare, no SHA-1 prefix) and verifies "No `.partial` temp file remains".

---

### P4-003 — 403→exit 1 unified including new EC-2.7.007-1b

**Status: CLOSED**

**Quote — EC-2.7.007-1b body (bc-2-issue-read.md, BC-2.7.007 edge cases):**
> `**EC-2.7.007-1b** (AID permission denied — 403): `GET /rest/api/3/attachment/{id}` (metadata step 1) returns 403 → exit 1: `"Permission denied: cannot access attachment <AID>."` (NOT the canonical not-found string, which is reserved for 404 / missing-attachment conditions). Rationale: 403 means the attachment exists but the caller lacks scope; returning "not found" would mislead the user. EC-2.7.007-1a (401) exits 78 (auth); EC-2.7.007-1b (403) exits 1 (permission); EC-2.7.007-1 (404) exits 64 (not found).`

**Quote — BC-2.7.012 taxonomy table 403 row (bc-2-issue-read.md):**
> The taxonomy table contains a row for `403 Forbidden` → exit code 1 → `"Permission denied: cannot access attachment <AID>."` added by P4-003.

---

### P4-007 — Unique temp name mandated, .partial removed

**Status: CLOSED**

**Quote — BC-2.7.007 write-to-temp clause (bc-2-issue-read.md):**
> `The download MUST write to a temporary file named `tmp_<random>_<basename>` in the same directory as the final path, where `<random>` is a cryptographically random 8-hex-character string and `<basename>` is the sanitized output filename. The deterministic `.partial` suffix MUST NOT be used: it would create a predictable temp-file path that a concurrent invocation could collide with or an adversary could observe.`

---

### P4-008 — Zero-count deleted:false authority

**Status: CLOSED**

**Quote — BC-3.9.010 zero-count semantics (bc-3-issue-write.md):**
> `**Zero-count semantics:** if count = 0, the JSON response is `{"count":0,"deleted":false,"ids":[]}`. `deleted:false` when count = 0 is intentional: no deletion occurred in this invocation. Callers testing for "did any deletion occur?" MUST check `deleted`, not `count > 0`.`

**Quote — EC-3.9.010-4 all-404 edge case (bc-3-issue-write.md):**
> `**EC-3.9.010-4** (All-404 edge case): if ALL supplied AIDs return 404 (none existed or were accessible), count = 0 → JSON shape is `{"count":0,"deleted":false,"ids":[]}` (zero-count semantics above); exit 0.`

---

### P4-014 — H-NEW-ATTACHMENT-008 present and integrated at 96 everywhere

**Status: CLOSED** (with two residual LOW/INFO gaps in surfaces not updated by the worklog — see §4)

**Quote — holdout-scenarios.md frontmatter:**
> `total_holdouts: 96`

**Quote — holdout-scenarios.md preamble:**
> `96 holdout scenarios for Phase 4 evaluation.`

**Quote — holdout-scenarios.md Group 19 header:**
> `## Group 19: Attachment CRUD — list / download / upload / delete (H-NEW-ATTACHMENT-001..008)`

**Quote — H-NEW-ATTACHMENT-008 scenario body (holdout-scenarios.md):**
> Scenario entry sets command `attachment upload <NON-JSM-KEY> <FILE> --public --yes`, expects exit code 64, canonical message `"--public is only supported on JSM issues."`, wiremock strict-mode assertion that zero servicedeskapi calls and zero platform POST occur, BC refs BC-3.9.005/BC-3.9.012/BC-3.9.014.

**Quote — CANONICAL-COUNTS.md holdout total:**
> `**Canonical holdout total: 96**`

**Quote — CANONICAL-COUNTS.md expected list (Group 19 tail):**
> `H-NEW-ATTACHMENT-001..H-NEW-ATTACHMENT-008` listed in the expected holdout list.

**Quote — CANONICAL-COUNTS.md Group 19 entry:**
> `+8, cite BC-3.9.005`

**Quote — prd-delta-576.md BC-3.9.005 row annotation:**
> `*Holdout: H-NEW-ATTACHMENT-008 (P4-014)*`

---

## 4. New Findings (Round 14)

### GAP-R14-001 — prd-delta-576.md frontmatter `holdout_count_after` stale

**Severity:** LOW  
**File:** `.factory/phase-f2-spec-evolution/prd-delta-576.md` (frontmatter)  
**Finding:** The frontmatter field `holdout_count_after: 95` was not updated when P4-014 incremented the holdout count from 95 to 96. The worklog (P4-001+P4-014 joint resolution entry) lists `prd-delta-576.md` under "Files edited" only for the BC-3.9.005 row annotation, not for the frontmatter field.

**Quote — current frontmatter value:**
> `holdout_count_after: 95`

**Expected:** `holdout_count_after: 96`

**Fix scope:** Single-line frontmatter update in `prd-delta-576.md`.

---

### GAP-R14-002 — holdout-scenarios.md Group 19 trace line stale count

**Severity:** LOW  
**File:** `.factory/specs/prd/holdout-scenarios.md` (preamble / Group 19 introduction trace line)  
**Finding:** A narrative trace line in the preamble section states "7 new scenarios H-NEW-ATTACHMENT-001..007" (reflecting the original pass-1 authoring of 7 scenarios). After P4-014 added H-NEW-ATTACHMENT-008, the Group 19 header was correctly updated to `..008` but this prose trace line was not updated.

**Quote — current prose (approximate, from Group 19 introduction trace comment):**
> `SOH-ATTACHMENTS-1 F2 (2026-07-15, adversary pass-1 human ruling R3): attachment list/download/upload/delete — **7 new scenarios H-NEW-ATTACHMENT-001..007**`

**Expected:** `8 new scenarios H-NEW-ATTACHMENT-001..008`

**Fix scope:** Single prose-string update in `holdout-scenarios.md`.

---

### GAP-R14-003 — CANONICAL-COUNTS.md range text stale

**Severity:** INFO  
**File:** `.factory/specs/prd/CANONICAL-COUNTS.md`  
**Finding:** The reconciliation narrative contains a range expression showing the holdout count journey as "(57 → 95)" which was correct before P4-014 but was not updated when the count moved to 96. The `Canonical holdout total`, `expected list`, `Group 19 entry`, and `reconciliation note` were all correctly updated; only this parenthetical range string was missed.

**Quote — current range text:**
> `Groups added since last reconciliation (57 → 95):`

**Expected:** `(57 → 96)`

**Fix scope:** Single range-string update in `CANONICAL-COUNTS.md`. Cosmetic — the authoritative count line immediately above correctly reads 96.

---

### GAP-R14-004 — BC-INDEX BC-2.7.007 row omits 403→exit-1 EC-2.7.007-1b

**Severity:** LOW  
**File:** `.factory/specs/prd/BC-INDEX.md` (BC-2.7.007 row)  
**Finding:** The BC-INDEX summary row for BC-2.7.007 references the canonical 404-not-found string and the single-id bare-naming ruling (added by P4-001) but does not reference EC-2.7.007-1b (403→exit 1, added by P4-003). The BC body itself contains the full EC-2.7.007-1b clause; only the index row is silent on it.

**Quote — current BC-INDEX BC-2.7.007 row (relevant fragment):**
> `...`"Attachment <AID> not found or not accessible."` canonical not-found string; default filename = bare sanitized basename (no SHA-1 prefix — single-id bare naming per BC-2.7.010)...`

**Missing:** A note such as "403 → exit 1: `"Permission denied: cannot access attachment <AID>."` (EC-2.7.007-1b)"

**Fix scope:** Append the 403/exit-1/EC-2.7.007-1b note to the BC-INDEX BC-2.7.007 row. BC body is authoritative; the index row is a summary aid.

---

### GAP-R14-005 — BC-INDEX BC-2.7.012 row taxonomy description omits 403

**Severity:** LOW  
**File:** `.factory/specs/prd/BC-INDEX.md` (BC-2.7.012 row)  
**Finding:** The BC-INDEX row for BC-2.7.012 describes it as containing "full error taxonomy table (404/401/5xx/network)" without listing 403. After P4-003 added a 403→exit-1 row to the taxonomy table in the BC body, the BC-INDEX row description was not updated to include "403" in the parenthetical.

**Quote — current BC-INDEX BC-2.7.012 row (relevant fragment):**
> `...full error taxonomy table (404/401/5xx/network)...`

**Expected:** `...full error taxonomy table (403/404/401/5xx/network)...` (or equivalent that includes 403).

**Fix scope:** Single-word addition in BC-INDEX BC-2.7.012 row description.

---

### GAP-R14-006 — prd-delta-576.md CONS-576-005 row disposition stale

**Severity:** INFO  
**File:** `.factory/phase-f2-spec-evolution/prd-delta-576.md` (CONS-576-005 row)  
**Finding:** The prd-delta consistency tracking table for CONS-576-005 (security-review verdict annotation) still shows "DEFERRED" but `security-review-576.md` frontmatter now reads `verdict: APPROVE` with all 7 findings SEC-576-001..007 confirmed applied. The security reviewer upgraded the verdict to APPROVE after the final re-verification pass, but the prd-delta disposition column was not updated.

**Quote — prd-delta-576.md CONS-576-005 row (disposition cell):**
> `DEFERRED`

**Quote — security-review-576.md frontmatter:**
> `verdict: APPROVE`

**Expected prd-delta disposition:** `RESOLVED (APPROVE)` or equivalent.

**Fix scope:** Single disposition-cell update in `prd-delta-576.md` CONS-576-005 row.

---

## 5. Naming Ruling End-to-End Coherence (Priority a)

All five required surfaces cohere on the P4-001 naming ruling:

| Surface | Expected clause | Present? |
|---------|----------------|----------|
| BC-2.7.007 body | "bare sanitized basename (no SHA-1 prefix — single-id bare naming per BC-2.7.010)" | YES |
| BC-2.7.010 body | Three-section: single-id bare / batch SHA-1 / degenerate fallback | YES |
| BC-2.7.011 body | Step-5 cap rationale updated (214 bytes = shared uniform cap; batch 41+214=255; single-id 214 ≤ 255) | YES |
| SEC-576-001 caller note | Split: batch path (SHA-1 prefix satisfies device-name req) vs single-id bare path (call site MUST apply `_`-prefix escape) | YES |
| H-NEW-ATTACHMENT-002 | Expects bare `notes.txt`, no SHA-1 prefix, no `.partial` temp file | YES |
| H-NEW-ATTACHMENT-003 / H-007 | Batch paths — expects SHA-1-prefix format | YES |
| BC-INDEX BC-2.7.007 row | "bare sanitized basename (no SHA-1 prefix — single-id bare naming per BC-2.7.010)" | YES |
| BC-INDEX BC-2.7.010 row | Describes all three naming modes | YES |
| impact-boundary R3.10 | "The default output filename for a single `--id` download is the **bare sanitized basename** — no SHA-1 prefix." | YES |

Conclusion: naming end-to-end is **coherent** across all surfaces. No gap.

---

## 6. 403/404 Exit-Code and Canonical-String Coherence (Priority b)

Post-P4-003 split:

| Error | Exit code | Canonical string | BC body | BC-INDEX row | BC-2.7.012 taxonomy |
|-------|-----------|-----------------|---------|-------------|---------------------|
| 404 (not found) | 64 | `"Attachment <AID> not found or not accessible."` | YES | YES | YES |
| 403 (permission denied) | 1 | `"Permission denied: cannot access attachment <AID>."` | YES (EC-2.7.007-1b) | GAP (GAP-R14-004) | GAP (GAP-R14-005) |
| 401 (auth) | 78 | standard auth string | YES | — | YES |

The 403 split is fully defined in the BC body (EC-2.7.007-1b) and in the BC-2.7.012 taxonomy table. The two BC-INDEX row descriptions are the surfaces that lag — see GAP-R14-004 and GAP-R14-005.

---

## 7. Holdout Count 96 Across All Surfaces (Priority c)

| Surface | Count / text | Status |
|---------|-------------|--------|
| holdout-scenarios.md frontmatter `total_holdouts` | 96 | CORRECT |
| holdout-scenarios.md preamble count | 96 | CORRECT |
| holdout-scenarios.md Group 19 header `..008` | 008 = 8 scenarios | CORRECT |
| holdout-scenarios.md Group 19 trace prose "7 new scenarios..007" | STALE (→ GAP-R14-002) | GAP |
| CANONICAL-COUNTS.md `Canonical holdout total` | 96 | CORRECT |
| CANONICAL-COUNTS.md expected list | H-NEW-ATTACHMENT-001..008 | CORRECT |
| CANONICAL-COUNTS.md range text `(57 → 95)` | STALE (→ GAP-R14-003) | GAP |
| prd-delta-576.md frontmatter `holdout_count_after` | 95 (STALE → GAP-R14-001) | GAP |
| prd-delta-576.md BC-3.9.005 annotation | "*Holdout: H-NEW-ATTACHMENT-008 (P4-014)*" | CORRECT |
| BC-INDEX frontmatter (no holdout count) | n/a | n/a |

Three surfaces lag on the 96 count (all classified and tracked as GAP-R14-001, -002, -003). The authoritative count line in CANONICAL-COUNTS.md is correct.

---

## 8. CLI Flag Pin Mutual Consistency (Priority d)

The pinned CLI-flag lines for both download (BC-2.7.007) and upload/delete (BC-3.9) were verified:

**BC-2.7.007 download flags:**
> `` `--id <AID>`; `--all`; `--output-dir <DIR>`; `--force`; `--dry-run`; `--output json`; `--no-input`; `--profile <NAME>`; `--no-color`. ``

**BC-3.9 upload flags (bc-3-issue-write.md, line ~3261):**
> `` `<KEY>` (positional, required); `<FILE>...` (positional, repeatable, 1+); `--public`; `--internal`; `--yes`; `--replace-existing`; `--dry-run`; `--output json`; `--no-input`; `--profile <NAME>`; `--no-color`. ``

**BC-3.9 delete flags (bc-3-issue-write.md, line ~3678):**
> `` `<AID>...` (positional, 1+; mutually exclusive with `--issue`/`--older-than` form); `--issue <KEY>`; `--older-than <DURATION>`; `--yes`; `--dry-run`; `--output json`; `--no-input`; `--profile <NAME>`; `--no-color`. ``

Style and content are mutually consistent. No gap.

---

## 9. Observability Clause vs CLAUDE.md SD-003 (Priority e)

Both BC files contain verbatim-aligned observability clauses:

**BC-2.7.007 (bc-2-issue-read.md):**
> `` `--verbose` logs method + URL only (unchanged CLAUDE.md rule SD-003). `--verbose-bodies` MUST NOT attempt to materialize the streaming response body (it is a byte-stream with no meaningful text representation; materializing it would buffer potentially gigabyte-sized files in memory). ``

**BC-3.9.001 (bc-3-issue-write.md):**
> `` `--verbose` logs method + URL only (unchanged SD-003 rule). `--verbose-bodies` MUST NOT attempt to buffer the streaming multipart upload body (potentially gigabyte-sized files; out of scope for body inspection). ``

CLAUDE.md SD-003 states: "As of v0.6, `--verbose` shows method + URL only. It does NOT print request/response bodies. To inspect bodies (e.g., for debugging API calls), use `--verbose-bodies`."

Both BC clauses correctly constrain streaming paths to prevent gigabyte-buffering while respecting the SD-003 header-only default. Coherent. No gap.

---

## 10. Standard Check-Class Summary (Priority f)

| Check class | Result | Notes |
|-------------|--------|-------|
| BC count consistency (657 across all surfaces) | PASS | BC-INDEX frontmatter 657; prd-delta 657; CANONICAL-COUNTS agrees |
| Holdout count consistency (96 across all surfaces) | PARTIAL (3 surfaces stale) | GAP-R14-001, -002, -003 |
| ADR-0017 in both ADR indices | PASS | Both factory adr-index.md and ARCH-INDEX.md list ADR-0017 |
| security-review verdict APPROVE | PASS | frontmatter `verdict: APPROVE` |
| security-review disposition in prd-delta | STALE (INFO) | GAP-R14-006 |
| P4 keystone fixes all present | PASS | All 5 confirmed with verbatim quotes |
| Observability clauses vs SD-003 | PASS | Both BC files aligned |
| CLI flag pins mutually consistent | PASS | Upload/delete/download all verified |
| CWE-22 sanitize_attachment_filename caller split | PASS | SEC-576-001 two-path note present |
| BC-INDEX row accuracy | PARTIAL | GAP-R14-004, -005 (403 row missing from two summaries) |
| impact-boundary P4-006 retro-annotation | PASS | Confirmed present at line 47 |
| impact-boundary R3.10 ruling | PASS | Bare-basename ruling confirmed |
| Research Parts 1-3 present | PASS | All three parts in research file |
| GAP-R13-001 (dry-run key order) | CLOSED | Micro-fix confirmed applied |

---

## 11. Summary

**Verdict: GAPS-FOUND — 6 gaps (LOW×4, INFO×2); none structural.**

All P4 keystone fixes (P4-001, P4-003, P4-007, P4-008, P4-014) are verifiably present in the canonical spec bodies and in the primary authority files. The spec is implementation-ready. The 6 new findings are index/metadata staleness — the BC bodies, holdout scenarios, CANONICAL-COUNTS authority line, security-review verdict, and ADR registration are all correct. The gaps are confined to:

- Two prd-delta-576.md fields (frontmatter `holdout_count_after` + CONS-576-005 disposition) — LOW, INFO
- One holdout-scenarios.md trace prose string — LOW
- One CANONICAL-COUNTS.md range expression — INFO
- Two BC-INDEX row descriptions that don't mention the 403 error path added by P4-003 — LOW×2

None of the gaps affect implementer correctness. A pre-S1 sweep to patch these 6 points is recommended before the holdout-evaluator gate, to prevent the evaluator from encountering a count mismatch in the index surfaces.

---

*Report generated: 2026-07-15 | Validator: cv-f2-576-r14 | No fixes applied — report only.*
