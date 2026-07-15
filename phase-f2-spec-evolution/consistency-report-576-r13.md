---
report: consistency-report-576-r13
feature: SOH-ATTACHMENTS-1
spec_version: v1.3.45
bc_count: 657
holdout_count: 95
round: R13
date: 2026-07-15
validator: vsdd-factory:consistency-validator (fresh context, no prior round memory)
verdict: CONSISTENT
new_finding_count: 1
new_finding_severity_breakdown: "LOW×1"
r11_closure: ALL_8_R11_GAPS_CLOSED
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 13 (Post-R12)

**Spec version**: 1.3.45  
**BC count**: 657 / **Holdout count**: 95  
**Scope**: All prior surfaces — bc-2-issue-read.md (Section 2.7), bc-3-issue-write.md (Section 3.9), BC-INDEX.md (v6.14), CANONICAL-COUNTS.md, holdout-scenarios.md (Group 19), prd-delta-576.md, impact-boundary-576.md  
**Fresh context**: YES — no prior pass context carried in  
**Verdict**: **CONSISTENT** (R11 all-closed; one new LOW finding)

---

## R11 Gap Closure Table (Quote-Based)

Each entry: (a) the R11 claim of what was wrong, (b) verbatim text from the current spec proving closure.

---

### GAP-R11-001 (HIGH) — BC-3.9.001 / BC-3.9.007 "directly" vs curated form contradiction

**R11 claim**: BC-3.9.001 listed `"self"` as a response element; BC-3.9.007 said `jr` "uses this response array **directly**" — contradicting BC-3.9.009's curated mandate.

**Closure evidence — BC-3.9.001 body (bc-3-issue-write.md line 3244)**:

> A successful upload returns HTTP 200 with a JSON array of attachment objects. The Jira API response includes fields such as `"id"`, `"filename"`, `"self"` (URL string), `"size"`, `"mimeType"`, `"created"`, and `"content"` (the download URL) — these are the raw API wire fields and are documented here as facts. **jr's output serialization** uses the curated form defined in BC-2.7.002 / BC-3.9.009: `"self"` is OMITTED; `"content"` is RENAMED to `"contentUrl"`. Human (table) output: one row per attachment, columns Filename / Size / ID / Created. JSON output: the curated array, pretty-printed via `output::render_json` (#526 invariant).

**Closure evidence — BC-3.9.007 body (bc-3-issue-write.md line 3398)**:

> **Platform POST path** (BC-3.9.001, BC-3.9.002): The `POST /rest/api/3/issue/{key}/attachments` response body IS the created attachment array. `jr` derives its success echo from this response array, serialized in the curated form (BC-2.7.002 authority: `"self"` omitted, `"content"` renamed to `"contentUrl"`). The raw API wire fields are documented in BC-3.9.001 as facts; the output is the curated form. No second fetch is required.

**Status**: CLOSED ✓ — both BCs now document raw wire facts separately from curated output; "directly" language removed; authority chain unambiguous.

---

### GAP-R11-002 (HIGH) — BC-INDEX.md BC-3.9.015 row: "EOF → exit 130" and "mirrors BC-3.5.003"

**R11 claim**: BC-INDEX BC-3.9.015 row contained (a) "EOF → exit 130" (wrong — body says exit 0) and (b) "mirrors BC-3.5.003" (explicitly repudiated by EC-3.9.015-5).

**Closure evidence — BC-INDEX.md line 387**:

> `attachment delete <AID>` interactive confirmation gate: `eprint!+read_line` (DEC-174); non-interactive exit 64 + --yes hint; --yes bypasses; cancel `{"cancelled":true,"deleted":false}` (no id key); metadata-fetch GET before prompt; EOF (`read_line` Ok(0)) → cancel, exit 0; **deliberate divergence from BC-3.5.003** (BC-3.5.003 uses dialoguer → exit 130 on EOF; this BC uses read_line → exit 0 on EOF)

**Status**: CLOSED ✓ — "EOF → exit 0" now correct; "deliberate divergence from BC-3.5.003" replaces the stale "mirrors" claim.

Cross-verify vs BC-3.9.015 body EC-3.9.015-5 (bc-3-issue-write.md line 3626):

> Both `Ok(0)` (EOF) and any `Err` (IO error) are routed to the cancel path; exit 0; `"Deletion cancelled."` to stderr; JSON: `{"cancelled":true,"deleted":false}`. **DIVERGENCE from BC-3.5.003 (comment delete, `dialoguer::Confirm`)**: BC-3.5.003 uses `dialoguer` which signals EOF → exit 130; BC-3.9.015 uses `read_line` which returns `Ok(0)` on EOF, treated as empty input (default-N = cancel = exit 0). This divergence is deliberate... The 'mirrors BC-3.5.003' claim is INCORRECT and REMOVED.

Index and body are now fully consistent. ✓

---

### GAP-R11-003 (MED) — EC-3.9.019-3 "duration.rs error message" stale vs body canonical string

**R11 claim**: EC-3.9.019-3 read "exit 64; duration.rs error message." while the body paragraph specified the exact canonical string `"invalid duration: '<VALUE>'. Use formats like 30m, 2h, 1d, 7d, 2w."`.

**Closure evidence — EC-3.9.019-3 (bc-3-issue-write.md line 3760)**:

> **EC-3.9.019-3** (invalid/malformed duration): exit 64; stderr: `"invalid duration: '<VALUE>'. Use formats like 30m, 2h, 1d, 7d, 2w."` (canonical error string from `parse_age_duration`; no reference to `duration.rs` error message, which may differ).

**Status**: CLOSED ✓ — EC-3.9.019-3 now carries the exact canonical error string and explicitly disclaims `duration.rs`'s error message. Body and EC are in agreement.

---

### GAP-R11-004 (MED) — BC-INDEX BC-3.9.019 row: stale duration.rs claim + wrong JSON key order

**R11 claim**: BC-INDEX BC-3.9.019 row said (a) "duration via `src/duration.rs` (same family as worklog)" and (b) wrong JSON key order `{"deleted":true,"count":N,"ids":[...]}`.

**Closure evidence — BC-INDEX.md line 391**:

> `attachment delete --older-than <duration>`: --issue KEY required; dedicated `parse_age_duration` (d=24h clock-hours, w=7×24h calendar — NOT worklog semantics); `src/duration.rs` = syntax-style precedent only; `created` ISO 8601 compared client-side via `chrono`; invalid duration exit 64; bulk-delete JSON `{"count":N,"deleted":true,"ids":[...]}` (BTreeMap alphabetical: count < deleted < ids) via `output::render_json`

**Status**: CLOSED ✓ — (a) now says "dedicated `parse_age_duration`" + "`src/duration.rs` = syntax-style precedent only"; (b) key order corrected to `{"count":N,"deleted":true,"ids":[...]}` (c < d < i alphabetical).

---

### GAP-R11-005 (MED) — BC-INDEX BC-3.9.020 row: wrong JSON key order

**R11 claim**: BC-INDEX BC-3.9.020 row showed `{"dryRun":true,"ids":[...],"attachments":[{id,filename}]}` — wrong BTreeMap order.

**Closure evidence — BC-INDEX.md line 392**:

> `attachment delete --dry-run`: multi-attachment paths list affected IDs without mutation; JSON `{"attachments":[{id,filename}],"dryRun":true,"ids":[...]}` (BTreeMap alphabetical: attachments < dryRun < ids) via `output::render_json`; single-ID --dry-run = human stderr hint + JSON `{"attachments":[{"id":"<AID>"}],"dryRun":true,"ids":["<AID>"]}` exit 0 (no gate); --yes with --dry-run = DEC-169 silent no-op

**Status**: CLOSED ✓ — outer key order now `{"attachments",[...], "dryRun":true, "ids":[...]}` (a < d < i alphabetical), with explicit BTreeMap annotation.

---

### GAP-R11-006 (LOW) — JSON Output Shape Contracts table upload row had `"self"` / missing curated form

**R11 claim**: Upload row in JSON Output Shape Contracts table included `"self"` and lacked `"contentUrl"` / `"author"`, contradicting BC-3.9.009's curated mandate.

**Closure evidence — bc-3-issue-write.md line 3209**:

> | `attachment upload` (platform POST path) | `[{"author":{...},"contentUrl":"https://…/rest/api/3/attachment/content/10042","created":"2026-07-15T...","filename":"foo.pdf","id":"10042","mimeType":"application/pdf","size":43008}]` | curated form (BC-2.7.002): `"self"` omitted, `"content"`→`"contentUrl"`; keys alphabetical; one element per file; BC-3.9.009 |

**Status**: CLOSED ✓ — table row now shows curated form: `"self"` absent, `"contentUrl"` present, `"author"` present, keys alphabetical (author < contentUrl < created < filename < id < mimeType < size).

---

### GAP-R11-007 (INFO) — BC-3.9.019 heading and Source field overstating `src/duration.rs` role

**R11 claim**: Heading said "`src/duration.rs` parser" and Source said "existing duration parser, same family as worklog add --duration" — overstating `duration.rs`'s role after P3-003.

**Closure evidence — BC-3.9.019 heading (bc-3-issue-write.md line 3732)**:

> #### BC-3.9.019: `attachment delete --issue <KEY> --older-than <duration>` — dedicated `parse_age_duration` (d=24h clock-hours, w=7×24h calendar; `src/duration.rs` syntax-style precedent only); ISO 8601 `created` compared client-side via `chrono`; invalid duration → exit 64; `--output json` bulk-delete shape

**Closure evidence — BC-3.9.019 Source field (bc-3-issue-write.md line 3735)**:

> `src/cli/issue/attachments.rs::handle_attachment_delete` (implementation pending — story S4); `src/duration.rs::parse_age_duration` (implementation pending — dedicated calendar-semantics parser; `src/duration.rs` cited as syntax-style precedent only; must NOT reuse worklog-day conversions)

**Status**: CLOSED ✓ — heading now says "dedicated `parse_age_duration` ... `src/duration.rs` syntax-style precedent only"; Source field now correctly scopes `src/duration.rs` as syntax-style precedent and emphasizes the dedicated parser.

---

### GAP-R11-008 (INFO) — CANONICAL-COUNTS.md L68 stale "(624)" reference

**R11 claim**: Historical note said "see Sum row above (624)" while Sum row shows 657.

**Closure evidence — CANONICAL-COUNTS.md line 68**:

> _Historical note (archived; historical total was 566; current canonical: see Sum row above (624 — historical, now 657 — see per-file table above for current totals)): Passes 10-13 involved a 541/542 count confusion around BC-X.4.009. All 542 claims were corrected to 541 at Pass 13. Subsequent additions (BC-7.4.013-016, BC-2.6.050-051, BC-3.4.009, BC-3.8.001-010, BC-X.12.001-008) brought the total to 566. See git history for the full audit trail._

**Status**: CLOSED ✓ — parenthetical now reads "(624 — historical, now 657 — see per-file table above for current totals)"; self-reference no longer misleading.

---

## Priority Analysis Results

### (a) BC-INDEX ↔ Body Fidelity — 8 Spot-Check Rows

All 20 BC-3.9.xxx index rows verified for attachment section. Eight sampled for deep cross-check:

| BC | Index claim | Body match | Status |
|----|-------------|------------|--------|
| BC-3.9.001 | multipart; X-Atlassian-Token: no-check mandatory; streaming; no client-side cap; 413/400; profile 4 | BC body line 3224-3257: all claims confirmed | CONSISTENT ✓ |
| BC-3.9.007 | curated form (BC-2.7.002: self omitted, content→contentUrl; no secondary fetch); JSDCLOUD-10841 | BC body line 3396-3408: confirmed | CONSISTENT ✓ |
| BC-3.9.009 | curated form array; self OMITTED; content→contentUrl; render_json required; platform POST path only | BC body line 3441-3452: confirmed | CONSISTENT ✓ |
| BC-3.9.010 | single `{"deleted":true,"id":"<AID>"}` or bulk `{"count":N,"deleted":true,"ids":[...]}` (BTreeMap-ordered) | BC body line 3464-3467: confirmed; d<i and c<d<i | CONSISTENT ✓ |
| BC-3.9.015 | EOF (Ok(0)) → cancel, exit 0; deliberate divergence from BC-3.5.003 | EC-3.9.015-5 body line 3626: confirmed | CONSISTENT ✓ |
| BC-3.9.017 | same-filename lookup (case-sensitive); delete ALL matching entries serially (OQ-6 last-write-wins) | BC body line 3682-3706: confirmed | CONSISTENT ✓ |
| BC-3.9.019 | dedicated parse_age_duration; d=24h; w=7×24h; src/duration.rs syntax-style precedent only; c<d<i JSON | BC body line 3742-3765: confirmed | CONSISTENT ✓ |
| BC-3.9.020 | `{"attachments",[...],"dryRun":true,"ids":[...]}` (a<d<i); single-ID: stderr hint + JSON; DEC-169 | BC body line 3783-3804: confirmed | CONSISTENT ✓ |

Post-sweep BC-INDEX fidelity for Section 3.9 is airtight across all 8 sampled rows.

### (b) Curated-Serialization Authority Chain

Complete end-to-end trace verified:

**BC-2.7.002** (bc-2-issue-read.md line 603, authority anchor):
> The curated form defined in this BC is the single canonical attachment-object JSON shape for ALL `jr` attachment operations — list, download, upload, and bulk responses all use this shape. BC-3.9.009 (upload JSON output) cross-references this BC as the authority. The `"self"` field MUST be omitted and `"content"` MUST be renamed to `"contentUrl"` across every code path that serializes a Jira attachment object.

**BC-3.9.001** references BC-2.7.002 ✓ (line 3244 — cites "BC-2.7.002 / BC-3.9.009"; documents wire facts + curated output)  
**BC-3.9.007** references BC-2.7.002 ✓ (line 3398 — "curated form (BC-2.7.002 authority)")  
**BC-3.9.009** references BC-2.7.002 ✓ (line 3443 — "the curated form defined in BC-2.7.002")  
**JSON Output Shape Contracts table** upload row references BC-3.9.009 ✓ (line 3209 — "curated form (BC-2.7.002); BC-3.9.009")

One consistent story end to end. No node in the chain has a contradiction.

### (c) Canonical String Sweep

All canonical strings verified across bc-2-issue-read.md + bc-3-issue-write.md:

| String | Appearances | Status |
|--------|-------------|--------|
| `"No attachments on <KEY>."` | BC-2.7.001 body, EC-2.7.001-1, EC-2.7.008-1, H-NEW-ATTACHMENT-001 Expected A | CONSISTENT ✓ |
| `"Attachment <AID> not found or not accessible."` | EC-2.7.007-1, BC-2.7.012 body+table, EC-3.9.008-2, EC-3.9.015-6 | CONSISTENT ✓ |
| `"--public is only supported on Jira Service Management (JSM) issues."` | BC-3.9.005 body, BC-3.9.012 table row | CONSISTENT ✓ |
| `"Deleted attachment <AID>."` | EC-3.9.008-1, BC-3.9.008 body, BC-3.9.015 confirm path | CONSISTENT ✓ |
| `"Deletion cancelled."` | EC-3.9.015-2, EC-3.9.015-5 | CONSISTENT ✓ |
| `"invalid duration: '<VALUE>'. Use formats like 30m, 2h, 1d, 7d, 2w."` | BC-3.9.019 body paragraph + EC-3.9.019-3 | CONSISTENT ✓ (GAP-R11-003 CLOSED) |
| `"Issue <KEY> not found or not accessible."` | BC-2.7.006 table, BC-2.7.012 table, BC-3.9.012 table | CONSISTENT ✓ |
| `"Temporary attachment IDs may have expired. Try the upload again."` | BC-3.9.006 body | Single appearance; no contradiction |

### (d) Counts/Narratives/Stale Markers

All 8 guarded surfaces re-verified:

| Surface | Value | Status |
|---------|-------|--------|
| `bc-3-issue-write.md` frontmatter `total_bcs` | 140 | ✓ |
| `bc-3-issue-write.md` frontmatter `definitional_count` | 111 | ✓ |
| `bc-2-issue-read.md` frontmatter `total_bcs` | 106 | ✓ |
| BC-INDEX.md frontmatter `total_bcs` | 657 | ✓ |
| BC-INDEX.md frontmatter `index_version` | v6.14 | ✓ |
| CANONICAL-COUNTS.md Sum row | 657 | ✓ |
| `holdout-scenarios.md` frontmatter `total_holdouts` | 95 | ✓ |
| `prd-delta-576.md` frontmatter `spec_version_after` | 1.3.45 | ✓ |

No stale markers detected in the active spec body. CANONICAL-COUNTS.md historical note now reads "(624 — historical, now 657)" — correctly archived. No misleading self-references remain.

---

## Findings Table

| ID | Severity | File | Description | Root Cause |
|----|----------|------|-------------|------------|
| GAP-R13-001 | LOW | bc-3-issue-write.md + BC-INDEX.md | `attachment delete --dry-run` inner object key order inconsistency. Both the BC-3.9.020 body (line 3787: `{"id": "<AID>", "filename": "<name>"}`) and the BC-INDEX row (line 392: `{id,filename}`) and the JSON Output Shape Contracts table (line 3213-3214) specify the `attachments` array inner objects and `wouldDelete` array inner objects as `{"id":"<AID>","filename":"<name>"}` — id before filename. This is non-alphabetical. The `attachment download` inner shape (line 3207) explicitly notes "inner keys alphabetical (filename<id<path<size)" and places filename before id. An implementer following the BTreeMap convention from download would emit `{filename, id}` but the dry-run shape prescribes `{id, filename}`. Body, BC-INDEX, and table all agree with each other — so this is internally consistent — but deviates from the alphabetical-inner-key precedent in BC-2.7.007. | The dry-run inner object spec was written with struct-field declaration order (id first) rather than alphabetical; the BTreeMap annotation in BC-3.9.020 only explicitly covers the outer 3 keys (attachments < dryRun < ids), not the inner element keys. The download inner shape note was written with an explicit alphabetical qualifier that dry-run lacks. |

---

## Summary

**Verdict: CONSISTENT**

All 8 R11 gaps are closed (2 HIGH, 3 MED, 1 LOW, 2 INFO). One new LOW finding (GAP-R13-001) identified: inner key ordering in `--dry-run` preview shapes (`{id,filename}`) is non-alphabetical relative to the download precedent (`{filename,id}`) — body, BC-INDEX, and table agree with each other but diverge from the BTreeMap-alphabetical convention. No new HIGH or MED gaps. No count changes; 657 BCs / 95 holdouts / v1.3.45 / BC-INDEX v6.14 confirmed.

---

## Counts Invariant

**657 BCs / 95 holdouts / spec v1.3.45 / BC-INDEX v6.14** — confirmed unchanged. Do NOT change any counts in any fix round.
