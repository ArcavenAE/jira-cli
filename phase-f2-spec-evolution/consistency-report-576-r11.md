---
report: consistency-report-576-r11
feature: SOH-ATTACHMENTS-1
spec_version: v1.3.45
bc_count: 657
holdout_count: 95
round: R11
date: 2026-07-15
validator: vsdd-factory:consistency-validator (fresh context, no prior round memory)
verdict: GAPS-FOUND
new_finding_count: 8
new_finding_severity_breakdown: "HIGH×2, MED×3, LOW×1, INFO×2"
p3_closure: ALL_3_P3_HIGH_FIXES_CLOSED
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 11 (Post-P3)

**Spec version**: 1.3.45  
**BC count**: 657 / **Holdout count**: 95  
**Scope**: All prior surfaces — bc-2-issue-read.md (Section 2.7), bc-3-issue-write.md (Section 3.9), cross-cutting.md (BC-X.8.010), holdout-scenarios.md (Group 19), BC-INDEX.md (v6.14), CANONICAL-COUNTS.md, spec-changelog.md, prd-delta-576.md + worklog, security-review-576.md, impact-boundary-576.md (incl. R3.9), research file, ADR-0017, both ADR indices  
**Fresh context**: YES — no prior pass context carried in  
**Verdict**: **GAPS-FOUND**

---

## P3 HIGH-Fix Closure Table (Quote-Based)

### P3-001 — EC-3.9.010-4: 404-skip-continue

**Status**: CLOSED

Verbatim artifact text from `bc-3-issue-write.md` EC-3.9.010-4:

> **EC-3.9.010-4** (partial bulk failure): on multi-AID bulk delete, a 404 response to any individual DELETE is treated as already-deleted (benign race — consistent with BC-3.9.013 multi-delete 404 exception); the 404'd AID is EXCLUDED from the success `count` and `ids` (it was not deleted by this invocation); iteration continues. The first NON-404 failure (403, 401, 5xx, network) stops the batch immediately; error is surfaced (error JSON in JSON mode, stderr in human mode); already-deleted AIDs are not reversed.

All three P3-001 requirements are present and correctly worded: (1) 404 = already-deleted (benign), excluded from `count`/`ids`; (2) iteration continues; (3) first non-404 stops batch.

---

### P3-002 — EC-2.7.001-1 empty stdout + stderr "No attachments on \<KEY\>." AND H-NEW-ATTACHMENT-001 Expected A

**Status**: CLOSED

Verbatim artifact text from `bc-2-issue-read.md` EC-2.7.001-1:

> **EC-2.7.001-1** (zero attachments): `attachment list <KEY>` on a valid issue with no attachments → exit 0, empty stdout (pipe-friendly; no table, no message on stdout); stderr: `"No attachments on <KEY>."` (profile 2 hint — human mode; JSON mode: empty stdout `[]` per BC-2.7.002, no stderr, exit 0).

Verbatim from `bc-2-issue-read.md` BC-2.7.001 body (zero-attach paragraph):

> When the issue has zero attachments, the handler exits 0 with no table, empty stdout (pipe-friendly), and emits `"No attachments on <KEY>."` to stderr (profile 2 hint — same canonical string as EC-2.7.001-1 and EC-2.7.008-1); this is not an error.

Verbatim from `bc-2-issue-read.md` EC-2.7.008-1:

> **EC-2.7.008-1** (empty attachment list): issue has no attachments → exit 0; stderr: `"No attachments on <KEY>."` (canonical string — unified with EC-2.7.001-1; "found" removed for consistency)

Verbatim from `holdout-scenarios.md` H-NEW-ATTACHMENT-001 Expected A:

> **Expected A (MUST-PASS)**:
> - Exit code = 0.
> - stdout is empty (no table, no message — pipe-friendly).
> - stderr contains `"No attachments on FOO-1"` (the zero-attachment canonical hint per EC-2.7.001-1).
> - stdout does NOT contain any attachment data rows.

All four surfaces (BC body, EC-2.7.001-1, EC-2.7.008-1, H-001 Expected A) are mutually consistent: exit 0, empty stdout, stderr `"No attachments on <KEY>."`. The holdout uses `"No attachments on FOO-1"` (without trailing period) as a `contains` assertion — this correctly passes when stderr contains the canonical string ending in `"."`.

---

### P3-003 — BC-3.9.019 parse_age_duration calendar semantics, d=24h pin

**Status**: CLOSED (with residual — see GAP-R11-003)

Verbatim artifact text from `bc-3-issue-write.md` BC-3.9.019 Duration parsing paragraph:

> **Duration parsing (calendar semantics)**: The `<duration>` argument is parsed by a dedicated `parse_age_duration` function (e.g., `src/duration.rs::parse_age_duration` or equivalent) that converts the string to a `chrono::Duration`. Accepted unit suffixes: `m` (minutes = 60 seconds), `h` (hours = 3600 seconds), `d` (days = 24 clock-hours, NOT an 8-hour Jira workday), `w` (weeks = 7 calendar days = 7×24h, NOT a 5-workday week). `m` means minutes, NOT months. Seconds (`s`) are not supported. Example valid values: `30m`, `2h`, `7d`, `2w`, `30d`. `src/duration.rs` is cited as the **syntax-style precedent only** (same `w/d/h/m` suffix convention); `parse_age_duration` performs its own arithmetic and MUST NOT reuse `duration.rs`'s worklog-day conversions (which may use an 8-hour day). Boundary test requirement: a unit test MUST assert that `parse_age_duration("1d") == chrono::Duration::hours(24)` (not 8 hours or 28800 seconds). An unrecognized or malformed duration string → exit 64; stderr: `"invalid duration: '<VALUE>'. Use formats like 30m, 2h, 1d, 7d, 2w."` (no reference to `duration.rs` error message which may differ).

Verbatim from `bc-3-issue-write.md` EC-3.9.019-8:

> **EC-3.9.019-8** (1d=24h boundary pin): `parse_age_duration("1d")` MUST produce `chrono::Duration::hours(24)`. A unit test in `src/` MUST assert this. Worklog-style 1d=8h is WRONG for this function.

Both P3-003 targets are present and correctly worded: dedicated `parse_age_duration` function with its own arithmetic, `d = 24 clock-hours` semantic, EC-3.9.019-8 boundary pin. P3-003 body content is CLOSED.

**Residual (GAP-R11-003)**: EC-3.9.019-3 was NOT updated to match the new canonical error string established by the P3-003 body paragraph. See finding table below.

---

## Priority Analysis Results

### (a) Delete-Family State Machine (BC-3.9.015/016/017/019/020 after P3-001/010/013 changes)

All three forms are present and correctly articulated in BC-3.9.016:

- Form 1 (single-AID `delete <AID>`): governed by BC-3.9.015 confirmation gate; BC-3.9.016 body explicitly identifies this form and defers to BC-3.9.015.
- Form 2 (multi-AID `delete <AID1> <AID2>...`): requires `--yes`; BC-3.9.016 EC-3.9.016-6/7/8 cover multi-AID bulk.
- Form 3 (`delete --issue KEY --older-than`): requires `--yes`; EC-3.9.016-1/2 and EC-3.9.016-9 cover.
- `--dry-run` exemption: EC-3.9.016-3 confirms dry-run is exempt from `--yes` gate.
- EC-3.9.016-9 (`--issue` without `--older-than` → exit 2) and EC-3.9.016-10 (bare `delete`, no args → exit 2): both present per P3-010.
- BC-3.9.013 multi-delete 404 exception is consistent with EC-3.9.010-4 and EC-3.9.019-7.

The BC bodies are internally consistent. Two BC-INDEX row stale issues affect this area (see GAP-R11-002, GAP-R11-004, GAP-R11-005 below).

### (b) Download Family (BC-2.7.007 two-step wire path, H-002 mocks, BC-2.7.010 naming, JSON shapes)

BC-2.7.007 two-step wire path is present and detailed:
- Step 1: `GET /rest/api/3/attachment/{id}` for metadata; Step 2: stream from contentUrl.
- H-NEW-ATTACHMENT-002 mock topology reflects the two-step setup correctly: `GET /rest/api/3/attachment/10001` (metadata) + `GET /rest/api/3/attachment/content/10001` (content), both mounted at `JR_BASE_URL` (P2-005 fix confirmed).
- EC-2.7.007-7 (`--id` JSON shape) and EC-2.7.008-6 (`--all`/`--newest N` JSON shape) are present with correct alphabetical inner keys (`filename < id < path < size`).
- JSON Output Shape Contracts table rows for download added correctly by P3-005: `attachment download --id <AID>` and `attachment download --all` / `--newest N` both present with correct `{"downloaded":[...]}` shape.
- BC-2.7.010 SHA-1-prefix naming is consistent with H-NEW-ATTACHMENT-003.
- `<KEY>` is NOT server-verified on the `--id` path (noted in BC-2.7.007 body per P3-004). ✓

### (c) Canonical String Sweep

Strings verified across all files in Sections 2.7/3.9:

| String | Appearances | Status |
|--------|-------------|--------|
| `"No attachments on <KEY>."` | BC-2.7.001 body, EC-2.7.001-1, EC-2.7.008-1, H-NEW-ATTACHMENT-001 Expected A | CONSISTENT ✓ |
| `"Attachment <AID> not found or not accessible."` | EC-2.7.007-1, BC-2.7.012 body+table, EC-3.9.008-2, EC-3.9.015-6 | CONSISTENT ✓ |
| `"--public is only supported on Jira Service Management (JSM) issues."` | BC-3.9.005 body, BC-3.9.012 table row | CONSISTENT ✓ |
| `"Deleted attachment <AID>."` | EC-3.9.008-1, BC-3.9.008 body, BC-3.9.015 confirm path | CONSISTENT ✓ |
| `"Deletion cancelled."` | EC-3.9.015-2, EC-3.9.015-5 | CONSISTENT ✓ |
| `"invalid duration: '<VALUE>'. Use formats like 30m, 2h, 1d, 7d, 2w."` | BC-3.9.019 body paragraph only | NOT IN EC-3.9.019-3 (stale — see GAP-R11-003) |
| `"Issue <KEY> not found or not accessible."` | BC-2.7.006 table, BC-2.7.012 table, BC-3.9.012 table | CONSISTENT ✓ |

### (d) JSON Output Shape Contracts Table Completeness

The table at the end of bc-3-issue-write.md now contains these attachment rows:

| Command | Shape | Status |
|---------|-------|--------|
| `attachment download --id <AID>` | `{"downloaded":[{filename,id,path,size}]}` | Present ✓ |
| `attachment download --all` / `--newest N` | `{"downloaded":[{...},…]}` | Present ✓ |
| `attachment upload` (platform POST) | `[{id,filename,mimeType,self,...}]` | Present but INCONSISTENT (GAP-R11-001/006) |
| `attachment delete` (single AID) | `{"deleted":true,"id":"<AID>"}` | Present ✓ |
| `attachment delete` (bulk AIDs) | `{"count":N,"deleted":true,"ids":[...]}` | Present ✓ |
| `attachment delete` (cancel/--no) | `{"cancelled":true,"deleted":false}` | Present ✓ |
| `attachment delete --dry-run` (preview) | `{"attachments":[...],"dryRun":true,"ids":[...]}` | Present ✓ |
| `attachment upload --replace-existing --dry-run` | `{"dryRun":true,"wouldDelete":[...],"wouldUpload":[...]}` | Present ✓ |
| `attachment upload --public` | TBD (P2-3c deferred) | Present as deferred row ✓ |

All nine expected rows are present. The upload row has an inconsistency with BC-3.9.009 (see GAP-R11-001/006).

### (e) P3-011 Curated-Serialization Authority vs BC-3.9.009

BC-2.7.002 now contains the authority note (verbatim from `bc-2-issue-read.md`):

> **Authority for all attachment-object serializations**: the curated form defined in this BC is the single canonical attachment-object JSON shape for ALL `jr` attachment operations — list, download, upload, and bulk responses all use this shape. BC-3.9.009 (upload JSON output) cross-references this BC as the authority. The `"self"` field MUST be omitted and `"content"` MUST be renamed to `"contentUrl"` across every code path that serializes a Jira attachment object.

BC-3.9.009 cross-references BC-2.7.002 as authority and reiterates: `"self"` OMITTED, `"content"` → `"contentUrl"`. P3-011 text is correctly placed in both BCs. **However**, BC-3.9.001 and BC-3.9.007 were not updated and still contradict the curated form (GAP-R11-001 below).

### (f) Impact-Boundary R3.9 vs BC Text

`impact-boundary-576.md` R3.9 documents two function inventory additions from P3:
- **R3.9a** (`parse_age_duration`): signature `parse_age_duration(s: &str) -> Result<chrono::Duration, JrError>`, d=24h, w=7×24h, no months, syntax-style precedent from duration.rs. Consistent with BC-3.9.019 body ✓
- **R3.9b** (single `--id` download metadata-GET-first): `get_attachment_metadata` → path construction → `get_attachment_content`. Consistent with BC-2.7.007 two-step wire path ✓

No drift between impact-boundary R3.9 and BC text.

### (g) Counts/Narratives/Stale Markers

All 8 guarded surfaces verified by inspection:

| Surface | Value | Status |
|---------|-------|--------|
| `bc-3-issue-write.md` frontmatter `total_bcs` | 140 | ✓ |
| `bc-3-issue-write.md` frontmatter `definitional_count` | 111 | ✓ |
| `bc-2-issue-read.md` frontmatter `total_bcs` | 106 | ✓ |
| `bc-2-issue-read.md` frontmatter `definitional_count` | 64 | ✓ |
| BC-INDEX.md frontmatter `total_bcs` | 657 | ✓ |
| BC-INDEX.md frontmatter `index_version` | v6.14 | ✓ |
| BC-INDEX.md Coverage Statistics total | 657 / 427 individually-bodied | ✓ |
| CANONICAL-COUNTS.md Sum | 657 | ✓ |
| CANONICAL-COUNTS.md bc-3 rows | 140/111 | ✓ |
| CANONICAL-COUNTS.md holdouts | 95 | ✓ |
| `holdout-scenarios.md` frontmatter `total_holdouts` | 95 | ✓ |
| `prd-delta-576.md` frontmatter | `spec_version_after: 1.3.45`, `bc_count_after: 657`, `holdout_count_after: 95` | ✓ |
| `spec-changelog.md` version | [1.3.45] present as MINOR | ✓ (v1.3.45 captures adversary pass-1 rounds A+B; P2/R6/R7/R9/P3 had no version bump by design — counts unchanged) |
| Actual `#### BC-` headings | bc-2: 64, bc-3: 111, cross-cutting: 84 | ✓ MATCH frontmatter |

One INFO stale: `CANONICAL-COUNTS.md` historical note (L68) references `Sum row above (624)` — this parenthetical inside a historical archive note references the old count, not the current 657. Low-impact (within an explicit historical note) but may confuse readers. Flagged INFO.

---

## Findings Table

| ID | Severity | File | Description | Root Cause |
|----|----------|------|-------------|------------|
| GAP-R11-001 | HIGH | bc-3-issue-write.md | BC-3.9.001 (line 3244) includes `"self"` as a response element and BC-3.9.007 says `jr` "uses this response array **directly**" — but BC-3.9.009 (after P3-011) explicitly says `"self"` is **OMITTED** and `"content"` is **renamed** to `"contentUrl"`. An implementer following BC-3.9.001/007 will emit `"self"` and skip curation; one following BC-3.9.009 will omit `"self"` and apply curation. Three BCs now directly contradict each other. | P3-011 added the authority/curation note to BC-3.9.009 and BC-2.7.002 but did not reconcile the upstream "directly" language in BC-3.9.001 (body description of the raw API response, L3244) and BC-3.9.007 (wire semantics) |
| GAP-R11-002 | HIGH | BC-INDEX.md | BC-3.9.015 index row contains two stale claims: (a) `"EOF → exit 130"` — the BC body (EC-3.9.015-5 after P2-002 and P3-009) says EOF returns `Ok(0)` → cancel path → **exit 0**, not exit 130; (b) `"mirrors BC-3.5.003"` — EC-3.9.015-5 body (P3-009) explicitly states: "The 'mirrors BC-3.5.003' claim is INCORRECT and REMOVED." Both errors in the index give an implementer wrong contracts for the EOF case. | BC-INDEX rows for adversary-pass-1 BCs were written at round B creation and were not updated during P2-002, P3-009 fix rounds |
| GAP-R11-003 | MED | bc-3-issue-write.md | EC-3.9.019-3 reads: "exit 64; duration.rs error message." — but BC-3.9.019 body paragraph (updated by P3-003) specifies the **exact canonical error string**: `"invalid duration: '<VALUE>'. Use formats like 30m, 2h, 1d, 7d, 2w."` and explicitly adds "(no reference to `duration.rs` error message which may differ)." The EC and body paragraph now contradict each other on what error string the implementation should emit. | P3-003 updated the body Duration parsing paragraph but did not update EC-3.9.019-3 |
| GAP-R11-004 | MED | BC-INDEX.md | BC-3.9.019 index row contains two stale claims: (a) `"duration via src/duration.rs (same family as worklog)"` — after P3-003, `src/duration.rs` is the **syntax-style precedent only**; a dedicated `parse_age_duration` function owns the arithmetic; (b) JSON shape `{"deleted":true,"count":N,"ids":[...]}` — wrong BTreeMap key order; R6 corrected the body to `{"count":N,"deleted":true,"ids":[...]}` (c<d<i alphabetical) but the BC-INDEX row was not updated. | BC-INDEX row not updated after P3-003 (semantics change) or R6 (key order fix) |
| GAP-R11-005 | MED | BC-INDEX.md | BC-3.9.020 index row JSON shape `{"dryRun":true,"ids":[...],"attachments":[{id,filename}]}` — wrong BTreeMap key order (d<i<a); R6 corrected the body to `{"attachments":[...],"dryRun":true,"ids":[...]}` (a<d<i alphabetical). BC-INDEX row not updated. | BC-INDEX row not updated after R6 key order correction |
| GAP-R11-006 | LOW | bc-3-issue-write.md | JSON Output Shape Contracts table upload row shows: `[{"id":"10042","filename":"foo.pdf","mimeType":"application/pdf","self":"...","size":43008,"created":"2026-07-15T..."}]` — includes `"self"` (which BC-3.9.009 says MUST be omitted from the curated form) and is missing `"author"` and `"contentUrl"` (which are required by the curated form in BC-2.7.002/BC-3.9.009). The table example contradicts BC-3.9.009. This is a secondary manifestation of GAP-R11-001 (if BC-3.9.001/007 "directly" interpretation is authoritative, the table is consistent with them but inconsistent with BC-3.9.009). | Pre-P3-011 table row reflects raw server response fields; P3-011 added curation mandate to BC-3.9.009 but did not update this table row |
| GAP-R11-007 | INFO | bc-3-issue-write.md | BC-3.9.019 section heading says `src/duration.rs parser` and the `**Source**` field says `src/duration.rs` (existing duration parser, same family as worklog add --duration)`. After P3-003, `src/duration.rs` is only the syntax-style reference; the actual parser is the new `parse_age_duration` function. The heading and Source field overstate `duration.rs`'s role. | BC-3.9.019 heading and Source line were not updated by P3-003 (only the body Duration parsing paragraph was updated) |
| GAP-R11-008 | INFO | CANONICAL-COUNTS.md | L68 historical archive note references `"Sum row above (624)"` — the parenthetical cites the old count (624) while the actual Sum row now shows 657. This is inside an explicitly archived historical note and has no operational impact, but the self-reference to "above (624)" is stale. | The historical note was written when the count was 624 and has not been updated as counts grew |

---

## Priority Recommendations for Fix Round R12

Listed by severity and fix-complexity order:

1. **GAP-R11-001** (HIGH) — Reconcile BC-3.9.001/BC-3.9.007 with BC-3.9.009 curated form. Either: (a) Update BC-3.9.001 L3244 to say "after curation (see BC-3.9.009)" and drop `"self"` from the example; and update BC-3.9.007 "uses this response array **directly**" to "uses this response array after applying the curated form defined in BC-3.9.009"; OR (b) if the intent is truly "directly", revert the BC-3.9.009 curated authority claim and restrict the curated form to list/download only. Resolution requires a design ruling.

2. **GAP-R11-002** (HIGH) — Update BC-INDEX.md BC-3.9.015 row: replace "EOF → exit 130" with "EOF → exit 0 (cancel)" and remove "mirrors BC-3.5.003".

3. **GAP-R11-003** (MED) — Update EC-3.9.019-3 to read: `exit 64; stderr: \`"invalid duration: '<VALUE>'. Use formats like 30m, 2h, 1d, 7d, 2w."\`` (not "duration.rs error message").

4. **GAP-R11-004** (MED) — Update BC-INDEX.md BC-3.9.019 row: (a) replace "duration via `src/duration.rs` (same family as worklog)" with "dedicated `parse_age_duration` fn; `src/duration.rs` syntax-style precedent only"; (b) fix JSON key order to `{"count":N,"deleted":true,"ids":[...]}`.

5. **GAP-R11-005** (MED) — Update BC-INDEX.md BC-3.9.020 row JSON key order to `{"attachments":[...],"dryRun":true,"ids":[...]}`.

6. **GAP-R11-006** (LOW) — Update JSON Output Shape Contracts table upload row to use the curated form: `[{"author":{...},"contentUrl":"...","created":"...","filename":"foo.pdf","id":"10042","mimeType":"application/pdf","size":43008}]` (BTreeMap alphabetical: author<contentUrl<created<filename<id<mimeType<size; no "self"). Contingent on GAP-R11-001 resolution.

7. **GAP-R11-007** (INFO) — Update BC-3.9.019 heading ("`src/duration.rs` parser" → "`parse_age_duration` function; `src/duration.rs` syntax-style precedent") and Source line.

8. **GAP-R11-008** (INFO) — Update CANONICAL-COUNTS.md L68 historical note parenthetical from "(624)" to "(657)".

---

## Counts Invariant

**657 BCs / 95 holdouts / spec v1.3.45 / BC-INDEX v6.14** — confirmed unchanged. All 8 automated guard surfaces verified by inspection against reported counts. Do NOT change any counts in the fix round.
