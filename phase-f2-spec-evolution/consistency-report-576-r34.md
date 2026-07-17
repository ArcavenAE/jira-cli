---
document_type: consistency-report
round: 34
spec_version: 1.3.64
date: 2026-07-17
validator: cv-f2-576-r34 (fresh context, no prior round visibility)
verdict: GAPS-FOUND
bc_count: 657
holdout_count: 100
vp_count: 35
priority_checks: P24-001 (BC-3.9.009 download-exclusion narrowing — verbatim new sentence; BC-2.7.002 authority clause ↔ EC-2.7.007-7 ↔ BC-3.9.009 ↔ shape-table coherence; old text in trace/footer confirmed descriptive not normative; normative sweep confirmed); P24-002 (VP-576-004 story-allocation note in bc-2; S1 note correct; S3 note MISSING — appears in S5 instead — GAP-P24-002-001 LOW); BC-INDEX v6.23→v6.24; spec-changelog [1.3.64] (Spec version row present — INFO-NEW-3 r33 RESOLVED); prd-delta spec_version_after 1.3.64 + P24 dispositions section; counts 657/100/35 unchanged; double-insertion sweep; ECHO-BREAKER List A (2 sentences) + List B (empty); K-1 (download-exclusion story) + K-2 (VP-576-004 ↔ VP-576-005 ↔ Scope table S1/S3/S5 boundaries)
level: ops
version: "1.0"
status: gaps-found
producer: cv-f2-576-r34
timestamp: 2026-07-17T00:00:00
phase: 2
inputs:
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/specs/prd/CANONICAL-COUNTS.md"
  - ".factory/spec-changelog.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
input-hash: "2e9abac"
traces_to: ".factory/specs/prd/BC-INDEX.md"
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 34 (post-P24 remediation)

**Spec version**: 1.3.64 | **BCs**: 657 | **Holdouts**: 100 | **VPs**: 35 | **Verdict**: GAPS-FOUND

---

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) — SOH-ATTACHMENTS-1 F2 |
| **Generated** | 2026-07-17T00:00:00 |
| **Generator** | cv-f2-576-r34 (fresh-context consistency validator, round 34) |
| **Artifacts Scanned** | 7 (bc-3-issue-write.md, bc-2-issue-read.md, holdout-scenarios.md, BC-INDEX.md, CANONICAL-COUNTS.md, spec-changelog.md, prd-delta-576.md) |
| **Focus** | Post-P24 adversary-pass remediation verification — spec v1.3.63 → v1.3.64; 2-item round (P24-001 MEDIUM: BC-3.9.009 download-exclusion fix; P24-002 LOW: VP-576-004 story-allocation note); double-insertion sweep; ECHO-BREAKER List A (2 sentences) + List B (empty); K-1..K-2 keystones; INFO-NEW-3 (r33) resolution check |
| **Prior round** | consistency-report-576-r33.md (CONSISTENT; INFO-NEW-3 NEW: [1.3.63] count table missing Spec version row) |

---

## Summary Table

| # | Check | Result |
|---|-------|--------|
| P24-001 | BC-3.9.009 narrowed sentence — new text verbatim present (bc-3 line 3475) | pass |
| P24-001 | Download explicitly excluded, cross-refs BC-2.7.002 authority clause + EC-2.7.007-7 | pass |
| P24-001 | BC-2.7.002 authority clause: "download is excluded — distinct `{"downloaded":[...]}` manifest (BC-2.7.007 EC-2.7.007-7)" | pass |
| P24-001 | EC-2.7.007-7 defines `{"downloaded":[...]}` manifest (bc-2 line 757) | pass |
| P24-001 | JSON Output Shape Contracts `attachment download` row: `{"downloaded":[...]}` (bc-3 line 3219) — coherent | pass |
| P24-001 | Old text in bc-3 frontmatter trace (line 98): quoted as "narrowed from X" — descriptive, not normative | pass |
| P24-001 | Old text in bc-3 footer (line 3900): quoted as historical narrowing record — not normative | pass |
| P24-001 | Normative "download + curated shape" sweep in bc-3: 0 remaining normative occurrences (grep verified) | pass |
| P24-001 | BC-INDEX BC-3.9.009 row: P24-001 download-exclusion note present | pass |
| P24-002 | VP-576-004 body (bc-2 line 615): story allocation note present and correct | pass |
| P24-002 | VP-576-004 note: "list half S1; upload-platform-POST half S3; full cross-path test S3; S3 depends_on S1; R3.13; NOT S1 acceptance matrix as a whole" | pass |
| P24-002 | VP-576-004 ↔ VP-576-005 allocation-note pattern coherent | pass |
| P24-002 | prd-delta S1 scope row: VP-576-004 allocation note present (P24-002) | pass |
| P24-002 | prd-delta S3 scope row: VP-576-004 note ABSENT — note appears in S5 row instead | **GAP** |
| P24-002 | Scope table S1/S3/S5 acceptance-matrix boundaries non-contradictory (VP body + S1 + S5 coherent; S3 row cross-ref missing) | partial |
| BC-INDEX v6.24 | index_version v6.23→v6.24; last_updated P24 note present | pass |
| spec-changelog [1.3.64] | Entry present dated 2026-07-17; Summary + Changed Requirements + Impact Assessment artifact table + count table | pass |
| spec-changelog [1.3.64] count table | BC 657 / Holdout 100 / VP 35 / New BCs 0 / New VPs 0 / New Holdouts 0 | pass |
| spec-changelog [1.3.64] count table | "Spec version \| 1.3.63→1.3.64" row PRESENT (INFO-NEW-3 r33 RESOLVED) | pass (RESOLVED) |
| prd-delta-576.md spec_version_after 1.3.64 | frontmatter updated | pass |
| prd-delta-576.md P24 dispositions section | present (unique); counts BC 657/holdout 100/VP 35/spec v1.3.64/both guards exit 0 | pass |
| Counts 657/100/35 | Consistent across all surfaces; both guards exit 0 | pass |
| Double-insertion sweep | No duplicate BC-3.9.009 narrowed bodies, VP-576-004 allocation bodies, [1.3.64] entries, "Adversary Pass 24" headings | pass |
| ECHO-BREAKER List A (2 sentences) | Both P24 behavioral sentences grounded in licensing sources; no over-claim | pass |
| ECHO-BREAKER List B | Empty — holdout-scenarios.md has 0 P24 references (grep verified: 0 occurrences) | pass |
| INFO-NEW-3 (r33) | [1.3.64] count table has "Spec version \| 1.3.63→1.3.64" row — RESOLVED | resolved |
| Guard: check-spec-counts.sh | OK: all spec counts verified | pass |
| Guard: check-bc-cumulative-counts.sh | OK: all cumulative BC counts verified (657 total across 8 files) | pass |

**1 behavioral GAP found (LOW severity). P24-001 correctly and fully applied. P24-002 PARTIALLY applied: VP-576-004 VP body annotated correctly (bc-2), prd-delta S1 row correct, but prd-delta S3 scope row is missing the VP-576-004 note — the note was placed in S5 instead of S3. Disposition and spec-changelog both falsely claim S3 was updated. Behavioral correctness is intact (VP body is authoritative); the gap is traceability: the S3 scope row does not reflect VP-576-004 as part of S3's acceptance scope. INFO-NEW-3 (r33) RESOLVED: [1.3.64] count table has the "Spec version" row. Counts 657/100/35 consistent. Both guards exit 0. New INFO-NEW-4 (bc-2 frontmatter trace missing v1.3.64 entry — worsening of INFO-NEW-2 r33) and INFO-NEW-5 (BC-3.9.009 Trace field not updated with P24-001 citation).**

---

## Guard Script Output

### check-spec-counts.sh

```
OK: all spec counts verified.
```

### check-bc-cumulative-counts.sh

```
OK: all cumulative BC counts verified (657 total across 8 files; Surface H footer checked where present).
```

Both guards exit 0. No count drift.

---

## P24-001 — BC-3.9.009 Download-Exclusion Fix

### Narrowed Sentence (bc-3 line 3475) — Quote-Verified

**New text** (verbatim, bc-3-issue-write.md line 3475):

> `This curated form is the canonical attachment-object JSON shape for \`jr\` attachment upload and list operations — upload and list JSON outputs use this shape (download is excluded — it uses the distinct \`{"downloaded":[...]}\` manifest per the BC-2.7.002 authority clause and BC-2.7.007 EC-2.7.007-7). See BC-2.7.002 for field-level documentation and the authoritative key-ordering clause.`

The sentence is narrowed: "upload and list operations" (not "all `jr` attachment operations — upload, list, and download"). Download is explicitly excluded with a cross-reference to the BC-2.7.002 authority clause and EC-2.7.007-7. ✓

### Old Text in Frontmatter Trace and Footer — Descriptive Records, Not Normative

**bc-3 frontmatter trace** (line 98):

> `BC-3.9.009 body download-exclusion fix (P24-001): "canonical attachment-object JSON shape across all \`jr\` attachment operations — upload, list, and download JSON outputs all use this shape" narrowed to "...for \`jr\` attachment upload and list operations — upload and list JSON outputs use this shape (download is excluded — it uses the distinct \`{"downloaded":[...]}\` manifest per the BC-2.7.002 authority clause and BC-2.7.007 EC-2.7.007-7)"`

This quotes the old text as the "narrowed from" source — it is a historical trace record, not a normative behavioral claim. ✓

**bc-3 footer** (line 3900):

> `BC-3.9.009 body download-exclusion fix: 'canonical attachment-object JSON shape across all \`jr\` attachment operations — upload, list, and download' narrowed to 'upload and list operations — upload and list JSON outputs use this shape (download is excluded — it uses the distinct \`{"downloaded":[...]}\` manifest per the BC-2.7.002 authority clause and BC-2.7.007 EC-2.7.007-7)' (P24-001)`

Same pattern — describes what was narrowed from/to. Not normative. ✓

**prd-delta-576.md P24-001 disposition** (line 443): also quotes the old text as a "narrowed from X to Y" record. ✓

### BC-2.7.002 Authority Clause (bc-2 line 611) — Quote-Verified

> `**Authority for all attachment-object serializations**: the curated form defined in this BC is the single canonical attachment-object JSON shape for \`jr\` attachment **list** and **upload** (platform POST + bulk echo) responses. **\`download\` is excluded**: the download JSON shape is the distinct \`{"downloaded":[...]}\` manifest defined in BC-2.7.007 (EC-2.7.007-7), not an attachment-object array. [P6-003 correction] BC-3.9.009 (upload JSON output) cross-references this BC as the authority.`

Explicit exclusion of download with cross-reference to BC-2.7.007 EC-2.7.007-7. ✓

### EC-2.7.007-7 Download Manifest (bc-2 line 757) — Quote-Verified

> `**EC-2.7.007-7** (\`--output json\` success shape for \`--id\`): \`{"downloaded":[{"filename":"<name>","id":"<AID>","path":"<written path>","size":N}]}\`; one-element \`downloaded\` array; inner keys in alphabetical order (\`filename\` < \`id\` < \`path\` < \`size\`); stdout only; exit 0.`

The distinct `{"downloaded":[...]}` manifest shape that BC-3.9.009 cross-references. ✓

### JSON Output Shape Contracts Table — Coherence Check (bc-3 line 3219)

> `| \`attachment download --all\` / \`--newest N\` | \`{"downloaded":[{"filename":"<name>","id":"<AID>","path":"<written path>","size":N},…]}\` | N-element \`downloaded\` array; same inner shape; BC-2.7.008/BC-2.7.009 |`

The download entry in the shape table uses the `{"downloaded":[...]}` form. The upload entry at bc-3 line 3220 uses the curated `[{author, contentUrl, ...}]` array. The two shapes are distinct and correctly documented. ✓

### Normative "Download + Curated Shape" Sweep

Grep of bc-3-issue-write.md for residual normative claims sweeping download into the curated shape returned no new occurrences. Remaining occurrences of "download" near "shape/curated" in bc-3:
- Line 3219: `attachment download` table row uses `{"downloaded":[...]}` — CORRECT, not the curated form
- Line 3256: "uses the curated form defined in BC-2.7.002 / BC-3.9.009" — this is the upload body describing the platform POST response (not download)
- Line 3508: "this differs from `attachment download`, which always uses a uniform array shape `{"downloaded":[...]}`" — distinction note in BC-3.9.010, not sweeping download into curated

None are normative claims extending the curated shape to download. The old text that was the issue (line ~3474) has been replaced by the narrowed text at line 3475. ✓

### BC-INDEX BC-3.9.009 Row (BC-INDEX line 381) — Quote-Verified

> `| BC-3.9.009 | \`attachment upload --output json\`: array in curated form (BC-2.7.002: author, contentUrl, created, filename, id, mimeType, size — BTreeMap-alphabetical; \`self\` OMITTED, \`content\`→\`contentUrl\`); \`output::render_json\` required (#526 invariant); platform POST path only. **P24-001**: body text narrowed — download is EXCLUDED from the curated form; download uses \`{"downloaded":[...]}\` manifest (BC-2.7.007 EC-2.7.007-7) | — (SOH-ATTACHMENTS-1 F2; P19-001; P24-001) | src/cli/issue/attachments.rs (pending S3) | HIGH |`

P24-001 note and citation present. ✓

**Result**: P24-001 FULLY APPLIED ✓.

---

## P24-002 — VP-576-004 Story-Allocation Note

### VP-576-004 Body (bc-2 line 615) — Quote-Verified

> `**VP-576-004**: curated attachment-object JSON transformation pin — [...] P20-006. **Story allocation (P24-002)**: list half verified at S1 (BC-2.7.002 home); upload-platform-POST half verified at S3 (BC-3.9.009); the full cross-path test lands at S3 — S3 depends_on S1 for the shared curated-serialization plumbing (earliest consumer S1 ships it, per the R3.13 principle). NOT part of the S1 acceptance matrix as a whole; the S1 matrix includes only the list half.`

Story allocation note present in VP body: "list half S1; upload-platform-POST half S3; full cross-path test S3; S3 depends_on S1; R3.13; NOT S1 acceptance matrix as a whole; S1 matrix includes only the list half." P24-002 citation present. ✓

### VP-576-004 ↔ VP-576-005 Allocation-Note Pattern Coherence

| Feature | VP-576-005 (P23-003, r33) | VP-576-004 (P24-002, r34) |
|---------|---------------------------|---------------------------|
| Verified at | S5 | S3 |
| Depends on | S3 (for `--replace-existing` mechanics) | S1 (for shared curated-serialization plumbing) |
| Textual home | BC-3.9.017 (S3) | BC-2.7.002 (S1) |
| NOT part of... acceptance matrix | S3 acceptance matrix | S1 acceptance matrix as a whole |
| Pattern | `S_N depends_on S_{N-1}` where `S_N` exercises cross-story plumbing first established by `S_{N-1}` | Same |

Both notes follow the R3.13 earliest-consumer principle — the earliest story to deliver shared plumbing owns the VP body; the story that exercises the full path declares depends_on. Pattern is coherent. ✓

### prd-delta S1 Scope Row (line 31) — Quote-Verified

> `| S1 | \`jr issue attachment list\` (list + filter) | BC-2.7.001..006. **VP-576-004 allocation (P24-002)**: VP-576-004's list half is home to S1 (BC-2.7.002); the full cross-path test (list + upload) lands at S3 (R3.13 earliest-consumer principle; S3 depends_on S1 for shared curated-serialization plumbing); NOT part of the S1 acceptance matrix as a whole — the S1 matrix includes only the list half. |`

S1 row updated with VP-576-004 allocation note. Consistent with VP body. ✓

### prd-delta S3 Scope Row (line 33) — Quote-Verified

> `| S3 | \`jr issue attachment upload\` (platform POST + \`--replace-existing\` + \`--dry-run\` path-c) | BC-3.9.001..002, BC-3.9.009, BC-3.9.012, BC-3.9.014, BC-3.9.017, BC-3.9.018, BC-3.9.020 (path-c: \`--replace-existing --dry-run\` + EC-3.9.020-6 clap guard). **BC-3.9.014 gate mechanics ship with S3** [...] **BC-3.9.007 scope note (P17-005)**: [...] **BC-3.9.017 split note (P20-005)**: non-public \`--replace-existing\` path (EC-3.9.017-1..10) ships with S3; combined \`--public\` ECs (EC-3.9.017-11/12) and the step-4 BC-3.9.003 public-routing are S5-realized (S5 depends_on S3 for gate mechanics). |`

**NO VP-576-004 mention.** The S3 row ends with the BC-3.9.017 split note — no VP-576-004 allocation note has been added. ✗

### prd-delta S5 Scope Row (line 35) — Quote-Verified

> `[...] **VP-576-005 allocation (P23-003)**: VP-576-005 (combined-gate single-prompt pin) is verified in S5 (S5 depends_on S3) [...] **VP-576-004 allocation (P24-002)**: VP-576-004 (curated attachment-object JSON transformation pin) full cross-path test (list BC-2.7.002 + upload BC-3.9.009) lands at S3; S3 depends_on S1 for the shared curated-serialization plumbing (R3.13 earliest-consumer principle; list half home BC-2.7.002 S1; upload half home BC-3.9.009 S3). |`

VP-576-004 P24-002 note IS present — but it is in the **S5** row, not the S3 row. The note says "full cross-path test... lands at S3" (contextual information for S5 implementers: VP-576-004 is not their concern; it belongs to S3).

### Gap Assessment

The P24-002 disposition in prd-delta-576.md (line 444) states:

> `prd-delta-576.md S1 scope row: VP-576-004 allocation one-liner added. **S3 scope row: VP-576-004 full cross-path test landing note added.**`

And the spec-changelog [1.3.64] (line 16) states:

> `one-line notes mirrored into prd-delta **S1 and S3 rows** (P24-002)`

Both documents claim the S3 row was updated, but the S3 row has NO VP-576-004 mention. The VP-576-004 note landed in S5 instead of S3 (or in addition to S3).

**GAP-P24-002-001** (LOW): prd-delta S3 scope row is missing the VP-576-004 allocation note. The disposition and spec-changelog both make a false claim that the S3 row was updated. Behavioral correctness is intact — the VP body in bc-2 is the authoritative source and is correctly annotated; the S1 note is correct; the S5 note communicates "VP-576-004 lands at S3." The omission is a traceability gap: the S3 scope row does not confirm that VP-576-004 is part of S3's acceptance scope, and the disposition/changelog records are inaccurate.

**Result**: P24-002 PARTIALLY APPLIED — VP body correct, S1 note correct, but S3 scope row missing VP-576-004 note. GAP-P24-002-001 raised.

---

## BC-INDEX v6.23→v6.24

**Quote-verified** (BC-INDEX.md frontmatter, lines 5–6):

```yaml
last_updated: 2026-07-17  # P24 adversary fix round: BC-3.9.009 row P24-001 download-exclusion note added; spec v1.3.64; BC count unchanged (657); holdout count 100 (unchanged); VP count 35 (unchanged); BC-INDEX v6.24. Previous: P23 adversary fix round: ...
index_version: v6.24
```

`index_version` v6.23→v6.24. `last_updated` includes P24 row update (BC-3.9.009) + spec v1.3.64 note. Internally consistent. ✓

**Result**: BC-INDEX v6.24 APPLIED ✓.

---

## spec-changelog [1.3.64]

**Quote-verified** (`spec-changelog.md` entry at line 10):

```
## [1.3.64] - 2026-07-17

### Type: PATCH
```

Entry present; dated 2026-07-17. ✓

**Summary** (line 14): Present — describes P24-001 (MEDIUM: BC-3.9.009 narrowed, grep-confirmed isolated to one site), P24-002 (LOW: VP-576-004 allocation note; "one-line notes mirrored into prd-delta S1 and S3 rows" — note: S3 claim is inaccurate per GAP-P24-002-001). ✓

**Changed Requirements** (lines 18–23): Lists 4 modified files (bc-3-issue-write.md, bc-2-issue-read.md, BC-INDEX.md, prd-delta-576.md). bc-2 IS listed (contrast INFO-NEW-2 from r33 where bc-2 was absent from [1.3.63] Changed Requirements). ✓

**Impact Assessment count table** (lines 34–42):

```
| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 100 (unchanged) |
| VP count | 35 (unchanged) |
| New BCs | 0 |
| New VPs | 0 |
| New Holdouts | 0 |
| Spec version | 1.3.63→1.3.64 |
```

7-row table present, including "Spec version | 1.3.63→1.3.64". **INFO-NEW-3 (r33) RESOLVED** — the Spec version row pattern (established at [1.3.60]) is restored in [1.3.64]. ✓

**Result**: spec-changelog [1.3.64] APPLIED ✓. INFO-NEW-3 (r33) RESOLVED.

---

## prd-delta-576.md Frontmatter + P24 Section

**Quote-verified** (`prd-delta-576.md` frontmatter, line 8):

```yaml
spec_version_after: 1.3.64
```

`spec_version_after` updated to 1.3.64. ✓

**P24 section heading** (`prd-delta-576.md` line 437):

> `## Adversary Pass 24 Fix Round Finding Dispositions`

P24 section present (unique — grep confirms 1 occurrence). ✓

**P24 preamble** (line 439):

> `Source: Adversary Pass 24. 1 MEDIUM / 1 LOW findings. Spec version bump: 1.3.63 → 1.3.64. No new BCs. Holdouts: 100 (unchanged). VPs: 35 (unchanged).`

Finding counts and version bump correct. ✓

**P24-001 disposition** (line 443): APPLIED; BC-3.9.009 narrowed; grep-confirmed isolated to one site; BC-INDEX updated. ✓
**P24-002 disposition** (line 444): APPLIED — states "S3 scope row: VP-576-004 full cross-path test landing note added." **However**: S3 row was NOT updated (note appears in S5 instead). The disposition record itself is inaccurate. See GAP-P24-002-001.

**P24 closing statement** (`prd-delta-576.md` line 446):

> `**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.64. Both guards exit 0.**`

Closing correct: BC 657 / holdout 100 / VP 35 / spec v1.3.64 / both guards exit 0. ✓

**Result**: prd-delta-576.md P24 APPLIED ✓ (with GAP-P24-002-001 noted).

---

## Double-Insertion Sweep

| Marker | Count | Locations | Assessment |
|--------|-------|-----------|------------|
| `P24-001` in `bc-3-issue-write.md` | 2 | line 98 (frontmatter trace); line 3900 (footer) | EXPECTED — 2 distinct roles; no body definition contains `P24-001` text (body was modified, not annotated inline); BC-INDEX carries the citation |
| `P24-002` in `bc-2-issue-read.md` | 1 | line 615 (VP-576-004 story allocation note) | EXPECTED — 1 body definition |
| `P24-002` in `prd-delta-576.md` | 3 | line 31 (S1 row), line 35 (S5 row), line 444 (P24 disposition) | EXPECTED — 3 distinct roles |
| `[1.3.64]` in `spec-changelog.md` | 1 | line 10 | No duplicate entry |
| `## Adversary Pass 24 Fix Round` in `prd-delta-576.md` | 1 | line 437 | No duplicate section |
| `VP-576-004` in `bc-2-issue-read.md` | 1 | line 615 (body definition + allocation note) | EXPECTED — 1 body |
| `v1.3.64` in `bc-3-issue-write.md` frontmatter trace | 1 | line 98 | EXPECTED — 1 frontmatter trace entry |
| `spec v1.3.64` in `bc-3-issue-write.md` footer | 1 | line 3900 | EXPECTED — 1 footer summary |

**No double-insertions detected.** All marker counts explained by distinct legitimate locations. ✓

---

## ECHO-BREAKER Audit — List A (2 Sentences)

### Sentence 1: BC-3.9.009 Narrowed Sentence

**New text (verbatim)** (bc-3 line 3475): `"This curated form is the canonical attachment-object JSON shape for \`jr\` attachment upload and list operations — upload and list JSON outputs use this shape (download is excluded — it uses the distinct \`{"downloaded":[...]}\` manifest per the BC-2.7.002 authority clause and BC-2.7.007 EC-2.7.007-7)."`

**Licensing basis**:
- "upload and list operations" restricted scope: BC-2.7.002 authority clause (bc-2 line 611): "the curated form defined in this BC is the single canonical attachment-object JSON shape for `jr` attachment **list** and **upload** (platform POST + bulk echo) responses." ✓
- "download is excluded": BC-2.7.002 authority clause explicitly states "`download` is excluded: the download JSON shape is the distinct `{"downloaded":[...]}` manifest defined in BC-2.7.007 (EC-2.7.007-7), not an attachment-object array." ✓
- `{"downloaded":[...]}` manifest: EC-2.7.007-7 (bc-2 line 757) defines this shape verbatim. ✓
- "per the BC-2.7.002 authority clause and BC-2.7.007 EC-2.7.007-7": both cited sources exist and contain the referenced content. ✓

**Assessment**: Narrowing is licensed directly by BC-2.7.002's existing authority clause which already excluded download (P6-003 correction). The cross-references are accurate. No over-claim — the narrowed sentence correctly scopes the curated form to upload and list, which is what BC-2.7.002 has always defined. ✓

---

### Sentence 2: VP-576-004 Story Allocation Note

**New text (verbatim)** (bc-2 line 615, Story allocation segment): `"**Story allocation (P24-002)**: list half verified at S1 (BC-2.7.002 home); upload-platform-POST half verified at S3 (BC-3.9.009); the full cross-path test lands at S3 — S3 depends_on S1 for the shared curated-serialization plumbing (earliest consumer S1 ships it, per the R3.13 principle). NOT part of the S1 acceptance matrix as a whole; the S1 matrix includes only the list half."`

**Licensing basis**:
- "list half verified at S1 (BC-2.7.002 home)": BC-2.7.002 is in bc-2-issue-read.md (SOH-ATTACHMENTS-1 Story 1 / S1 territory); VP-576-004 covers `attachment list ... --output json` which is BC-2.7.002. ✓
- "upload-platform-POST half verified at S3 (BC-3.9.009)": BC-3.9.009 is in bc-3-issue-write.md Section 3.9 (SOH-ATTACHMENTS-1 Story 3 / S3 territory); VP-576-004 covers `attachment upload ... --output json` which is BC-3.9.009. ✓
- "S3 depends_on S1 for the shared curated-serialization plumbing": BC-3.9.009 explicitly cross-references BC-2.7.002 as its authority ("See BC-2.7.002 for field-level documentation and the authoritative key-ordering clause" — bc-3 line 3475). The serialization plumbing (omit `self`, rename `content`→`contentUrl`) is first realized at S1; S3 reuses it. ✓
- "earliest consumer S1 ships it, per the R3.13 principle": R3.13 earliest-consumer principle: the first story to ship shared plumbing owns the VP; S1 ships BC-2.7.002 (attachment list) first. ✓
- "NOT part of the S1 acceptance matrix as a whole; the S1 matrix includes only the list half": mirrors the VP-576-005 allocation note pattern ("NOT part of the S3 acceptance matrix"); the S1 acceptance matrix covers only S1-scoped behavior; the full cross-path test requires both list (S1) and upload (S3) simultaneously, requiring an S3 fixture. ✓

**Assessment**: Licensed by BC-2.7.002, BC-3.9.009, their cross-reference relationship, and the R3.13 earliest-consumer principle (precedent VP-576-005). No over-claim. ✓

---

### List B Verification

P24 touches bc-3-issue-write.md, bc-2-issue-read.md, BC-INDEX.md, and prd-delta-576.md. No holdout-scenarios.md or VP fixture text in holdout-scenarios.md modified.

Verification: grep for "P24" in holdout-scenarios.md — **0 occurrences**. No P24 references in any holdout body text.

**List B EMPTY confirmed** ✓.

---

## Keystone Coherence Checks

### K-1: Download-Exclusion Story — BC-2.7.002 ↔ BC-3.9.009 ↔ EC-2.7.007-7 ↔ Shape-Table ↔ VP-576-004 Scope

| Element | Claim | Source |
|---------|-------|--------|
| BC-2.7.002 authority clause | Curated shape is for list + upload; `download` is excluded; download uses `{"downloaded":[...]}` manifest (BC-2.7.007 EC-2.7.007-7) | bc-2 line 611 |
| BC-3.9.009 narrowed sentence | Curated form canonical for upload and list; download excluded; uses `{"downloaded":[...]}` manifest per BC-2.7.002 authority + EC-2.7.007-7 | bc-3 line 3475 |
| EC-2.7.007-7 | Defines `{"downloaded":[...]}` download manifest shape (distinct from curated attachment-object array) | bc-2 line 757 |
| JSON Shape Contracts table | `attachment download` row: `{"downloaded":[...]}` (not curated array); `attachment upload` row: `[{author, contentUrl, ...}]` (curated) | bc-3 lines 3219–3220 |
| VP-576-004 scope | Covers `attachment list --output json` (BC-2.7.002) + `attachment upload --output json` (BC-3.9.009); download NOT in scope | bc-2 line 615 |

All five surfaces tell a coherent story: curated shape = list + upload only; download = distinct `{"downloaded":[...]}` manifest. No surface contradicts another. **K-1 COHERENT ✓**

---

### K-2: VP-576-004 Allocation ↔ VP-576-005 Allocation ↔ Scope Table — S1/S3/S5 Acceptance-Matrix Boundaries

| Element | Claim | Source | Status |
|---------|-------|--------|--------|
| VP-576-004 body | "list half S1; upload-platform-POST half S3; full cross-path test S3; S3 depends_on S1; NOT S1 acceptance matrix as a whole" | bc-2 line 615 | COHERENT ✓ |
| VP-576-005 body | "verified in S5 (S5 depends_on S3); textual home BC-3.9.017; NOT part of the S3 acceptance matrix" | bc-3 line 3786 | COHERENT ✓ |
| prd-delta S1 row | "VP-576-004's list half home S1; full cross-path test lands at S3; NOT part of S1 acceptance matrix as a whole" | prd-delta line 31 | COHERENT ✓ |
| prd-delta S3 row | VP-576-004 note ABSENT | prd-delta line 33 | GAP — S3 scope table lacks VP-576-004 cross-reference |
| prd-delta S5 row | VP-576-005 in S5 ✓; VP-576-004 "lands at S3" contextual note | prd-delta line 35 | COHERENT for VP-576-005; informative for VP-576-004 |

VP body + S1 row + S5 row together communicate a coherent S1/S3/S5 allocation story for VP-576-004. However, the S3 row is missing the VP-576-004 cross-reference, creating a one-sided gap: S3 implementers reading only the S3 scope row would not discover that VP-576-004 is their responsibility. **K-2 PARTIALLY COHERENT — gap in S3 scope row cross-reference** (GAP-P24-002-001).

---

## Cross-Reference Validation

### BC Counts

| Source | bc-2 definitional | bc-2 total_bcs | bc-3 definitional | bc-3 total_bcs | Grand Total |
|--------|-------------------|-----------------|-------------------|-----------------|-------------|
| Frontmatter | 64 | 106 | 111 | 140 | 657 |
| CANONICAL-COUNTS.md | 64 | 106 | 111 | 140 | 657 |
| Guard output | verified | — | verified | — | 657 |

P24 added 0 new BCs. PASS ✓

### Holdout Counts

| Source | Count | Status |
|--------|-------|--------|
| `holdout-scenarios.md` frontmatter `total_holdouts` | 100 | PASS ✓ |
| `CANONICAL-COUNTS.md` canonical total | 100 | PASS ✓ |
| `prd-delta-576.md` P24 closing | "Holdout count: 100 (unchanged)" | PASS ✓ |
| `spec-changelog.md` [1.3.64] count table | "Holdout count: 100 (unchanged)" | PASS ✓ |

### VP Counts

| Source | VP count reference | Status |
|--------|-------------------|--------|
| `prd-delta-576.md` P24 closing | "VP count: 35 (unchanged)" | PASS ✓ |
| `bc-3-issue-write.md` footer | "VP count 35 (unchanged)" | PASS ✓ |
| `BC-INDEX.md` last_updated | "VP count 35 (unchanged)" | PASS ✓ |
| `spec-changelog.md` [1.3.64] count table | "VP count: 35 (unchanged)" | PASS ✓ |

---

## Spec Version Surface Verification

| Artifact | Spec version shown | Status |
|----------|--------------------|--------|
| `spec-changelog.md` | `[1.3.64] - 2026-07-17` entry present | PASS ✓ |
| `bc-3-issue-write.md` frontmatter trace | v1.3.64 entry at line 98 | PASS ✓ |
| `bc-3-issue-write.md` footer | "spec v1.3.64" at line 3900 | PASS ✓ |
| `BC-INDEX.md` `last_updated` | "spec v1.3.64" in P24 note | PASS ✓ |
| `prd-delta-576.md` frontmatter `spec_version_after` | `1.3.64` | PASS ✓ |
| `bc-2-issue-read.md` frontmatter trace | No v1.3.64 entry (last entry is adversary pass-22, spec v1.3.62) | NOTE (INFO-NEW-4; worsening of INFO-NEW-2 r33) |
| `STATE.md` `current_step` | Stale (carries INFO-8) | STALE (INFO-8 carries forward) |

---

## INFO Ledger Status

### INFO-1 (carry-forward R21–R34) — CARRY-FORWARD

Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7 in bc-2. Not introduced or worsened by P24.

**Status**: CARRY-FORWARD

---

### INFO-2 (carry-forward R21–R34) — CARRY-FORWARD

EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained. Not introduced or worsened by P24.

**Status**: CARRY-FORWARD

---

### INFO-3 (carry-forward R21–R34) — CARRY-FORWARD

BC-2.7.012 "KEY or AID 5xx" combined-scope row. Not introduced or worsened by P24.

**Status**: CARRY-FORWARD

---

### INFO-4 (carry-forward R22–R34) — CARRY-FORWARD

H-NEW-ATTACHMENT-003 BC refs footer does not list `BC-2.7.008 EC-2.7.008-6` for Call B2. Not introduced or worsened by P24.

**Status**: CARRY-FORWARD

---

### INFO-6 (carry-forward R23–R34) — CARRY-FORWARD

No holdout for the collision-skip exit-0 path. Not introduced or worsened by P24.

**Status**: CARRY-FORWARD

---

### INFO-8 (carry-forward R25–R34) — CARRY-FORWARD

`STATE.md` spec version stale. Now stale at v1.3.64 (was stale at v1.3.63 after r33).

**Status**: CARRY-FORWARD

---

### INFO-11 (carry-forward R27–R34) — CARRY-FORWARD

`spec-changelog.md` [1.3.57] and `prd-delta-576.md` P17-002 disposition say "three sites" but four sites were actually modified. Not introduced or worsened by P24.

**Status**: CARRY-FORWARD

---

### INFO-13 (carry-forward R28–R34) — CARRY-FORWARD

`error-taxonomy.md` row 95 issue-GET 403 sub-variant lacks BC-2.7.006 citation. Not introduced or worsened by P24.

**Status**: CARRY-FORWARD

---

### INFO-15 (carry-forward R29–R34) — CARRY-FORWARD

`impact-boundary-576.md` BC-3.9.004 row has INCONCLUSIVE annotation; BC-3.9.004 is now fully defined. Not introduced or worsened by P24.

**Status**: CARRY-FORWARD

---

### INFO-NEW-2 (NEW R33) — WORSENED

`bc-2-issue-read.md` BC-2.7.012 body Trace P22-003 citation was added (resolving INFO-NEW-1) but not listed in `spec-changelog.md` [1.3.63] Changed Requirements, and bc-2 frontmatter trace had no v1.3.63 entry.

**R34 update**: P24-002 modified bc-2-issue-read.md (VP-576-004 allocation note). The spec-changelog [1.3.64] Changed Requirements DOES list bc-2-issue-read.md (MODIFIED) — resolving the documentation gap for the P24 change. However, bc-2 frontmatter trace STILL has no v1.3.63 entry (the P23 application that corrected BC-2.7.012 Trace remains undocumented in bc-2's own frontmatter), and now also has no v1.3.64 entry (the P24-002 VP-576-004 annotation is also not reflected in bc-2's frontmatter trace).

The bc-2 frontmatter trace is now two versions behind: last entry is adversary pass-22 / spec v1.3.62; both v1.3.63 and v1.3.64 modifications are undocumented in bc-2's frontmatter trace.

**Severity**: INFO. Worsened (from missing v1.3.63 to missing v1.3.63+v1.3.64). Non-blocking — spec-changelog covers it. Renamed to **INFO-NEW-4** for tracking.

---

### INFO-NEW-3 (NEW R33) — RESOLVED

`spec-changelog.md` [1.3.63] count table was missing the "Spec version | 1.3.62→1.3.63" row.

**R34 update**: `spec-changelog.md` [1.3.64] count table has "Spec version | 1.3.63→1.3.64" at row 7. The pattern has been restored. Note: [1.3.63] still lacks the row (not retroactively fixed), but the pattern is no longer drifting.

**Status**: RESOLVED ✓ (pattern restored in [1.3.64])

---

### INFO-NEW-4 (NEW R34 — replaces INFO-NEW-2)

`bc-2-issue-read.md` frontmatter trace is missing entries for both v1.3.63 and v1.3.64. The last entry is adversary pass-22 / spec v1.3.62:
- v1.3.63: bc-2 was implicitly modified (BC-2.7.012 Trace P22-003 citation — micro-fix alongside P23; not in [1.3.63] changelog and not in bc-2 frontmatter)
- v1.3.64: bc-2 was explicitly modified (VP-576-004 story allocation annotation P24-002; IS in [1.3.64] changelog Changed Requirements) but bc-2's own frontmatter trace was not updated with a v1.3.64 entry

Both bc-3-issue-write.md (line 98: v1.3.64 frontmatter entry present) and the spec-changelog [1.3.64] (lists bc-2 as MODIFIED) serve as the amendment record. The gap is only in bc-2's self-contained frontmatter trace.

**Severity**: INFO. Non-blocking.

---

### INFO-NEW-5 (NEW R34)

BC-3.9.009 Trace field (bc-3 line 3484) was NOT updated with a P24-001 citation:

> `**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); JSON render invariant #526 (\`output::render_json\` required for all \`--output json\` paths)`

No P24-001 citation, no P19-001 citation. The BC-INDEX row for BC-3.9.009 carries both citations ("— (SOH-ATTACHMENTS-1 F2; P19-001; P24-001)"). This is consistent with the precedent for P19-001: the BC-3.9.009 Trace body was not updated when P19-001 added BTreeMap-alphabetical ordering (only BC-INDEX carries P19-001). The Trace field documents originating context; BC-INDEX serves as the aggregated amendment record for correction/narrowing fix rounds (contrast behavioral additions such as P23-002 which DID update BC-3.9.005/BC-3.9.020 Traces). The pattern is internally consistent but not explicitly documented.

**Severity**: INFO. Non-blocking.

---

## Findings

### Critical

None.

### Major

None.

### GAPs

**GAP-P24-002-001** (LOW): prd-delta S3 scope row missing VP-576-004 allocation note.

- **Location**: `.factory/phase-f2-spec-evolution/prd-delta-576.md`, S3 scope row (line 33)
- **Description**: The P24-002 disposition (prd-delta line 444) claims "S3 scope row: VP-576-004 full cross-path test landing note added." The spec-changelog [1.3.64] (line 16) claims "one-line notes mirrored into prd-delta S1 and S3 rows." Both claims are inaccurate: the S3 row has no VP-576-004 mention. The VP-576-004 allocation note (P24-002) was placed in the S5 scope row instead of (or in addition to) the S3 scope row.
- **Impact**: Behavioral correctness intact. The VP body in bc-2 (line 615) is the authoritative source and is correctly annotated. The S1 scope row note is correct. The S5 scope row contextually notes "full cross-path test lands at S3." However, the S3 scope row — which should document VP-576-004 as part of S3's acceptance scope — is missing the cross-reference. An S3 implementer reading the S3 scope row would not find VP-576-004 and might not realize they are responsible for verifying this VP. Additionally, the disposition and spec-changelog contain false claims.
- **Remediation**: Add VP-576-004 allocation one-liner to the S3 scope row in prd-delta-576.md. Consider optionally correcting the S5 note's location (or retaining it as contextual clarification for S5 implementers). Update or annotate the P24-002 disposition record if the S5 placement was intentional.
- **Severity**: LOW.

### Resolved This Round

- **INFO-NEW-3** (NEW R33): spec-changelog [1.3.63] count table missing "Spec version | 1.3.62→1.3.63" row — RESOLVED (pattern restored in [1.3.64]; "Spec version | 1.3.63→1.3.64" row present at count table row 7).

### Minor (INFO)

- **INFO-1** (carry R21–R34): Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7.
- **INFO-2** (carry R21–R34): EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained.
- **INFO-3** (carry R21–R34): BC-2.7.012 "KEY or AID 5xx" combined-scope row.
- **INFO-4** (carry R22–R34): H-NEW-ATTACHMENT-003 BC refs footer missing EC-2.7.008-6 for Call B2.
- **INFO-6** (carry R23–R34): No holdout for collision-skip exit-0 path.
- **INFO-8** (carry R25–R34): STATE.md spec version stale (should be v1.3.64).
- **INFO-11** (carry R27–R34): P17-002 "three sites" undercount in spec-changelog/prd-delta.
- **INFO-13** (carry R28–R34): error-taxonomy row 95 issue-GET 403 lacks BC-2.7.006 citation.
- **INFO-15** (carry R29–R34): impact-boundary BC-3.9.004 INCONCLUSIVE annotation; BC-3.9.004 now fully defined.
- **INFO-NEW-4** (NEW R34): bc-2 frontmatter trace missing v1.3.63 AND v1.3.64 entries (worsening of INFO-NEW-2 r33; spec-changelog [1.3.64] correctly lists bc-2 as MODIFIED, so the amendment is documented externally).
- **INFO-NEW-5** (NEW R34): BC-3.9.009 Trace field not updated with P24-001 citation (consistent with P19-001 non-citation precedent; BC-INDEX carries both citations; Trace documents originating context, not correction amendments).

---

## Validation Gate Result

**GAPS-FOUND**

P24-001 (MEDIUM) correctly and fully applied: BC-3.9.009 narrowed sentence precisely excludes download, cross-references BC-2.7.002 authority clause and EC-2.7.007-7; old text in frontmatter trace and footer confirmed as descriptive historical records (not normative); normative sweep found 0 remaining claims sweeping download into the curated shape; BC-INDEX BC-3.9.009 row updated with P24-001 citation; BC-INDEX index_version v6.23→v6.24. P24-002 (LOW) PARTIALLY applied: VP-576-004 VP body in bc-2 correctly annotated (list half S1; upload-platform-POST half S3; full cross-path test S3; S3 depends_on S1; R3.13; NOT S1 acceptance matrix; S1 matrix includes only list half); prd-delta S1 scope row correctly updated; HOWEVER prd-delta S3 scope row NOT updated — note appears in S5 row instead — and both the prd-delta P24-002 disposition and spec-changelog [1.3.64] falsely claim the S3 row was updated (GAP-P24-002-001, LOW).

ECHO-BREAKER: 2 List-A sentences grounded — (1) BC-3.9.009 narrowed sentence licensed by BC-2.7.002 authority clause + EC-2.7.007-7; (2) VP-576-004 allocation note licensed by BC-2.7.002 (S1 territory), BC-3.9.009 (S3 territory), their cross-reference relationship, and R3.13 earliest-consumer precedent. No over-claim on either sentence. List-B verified empty (0 P24 references in holdout-scenarios.md by grep). Double-insertion sweep clean: no duplicate body definitions for BC-3.9.009 narrowed sentence or VP-576-004 allocation note. K-1 (download-exclusion story across BC-2.7.002/BC-3.9.009/EC-2.7.007-7/shape-table/VP-576-004 scope): COHERENT. K-2 (VP-576-004 allocation ↔ VP-576-005 allocation ↔ Scope table): PARTIALLY COHERENT — VP bodies and S1/S5 rows are consistent; S3 row cross-reference missing (GAP-P24-002-001). Counts 657/100/35 verified by both guards (exit 0). INFO-NEW-3 (r33) RESOLVED: [1.3.64] count table has "Spec version | 1.3.63→1.3.64" row. Two new INFO items: INFO-NEW-4 (bc-2 frontmatter trace two versions behind — v1.3.63 and v1.3.64 entries absent) and INFO-NEW-5 (BC-3.9.009 Trace not updated with P24-001, consistent with P19-001 non-citation precedent). Spec version 1.3.64 consistent across all primary surfaces. Spec version row in [1.3.64] count table present (INFO-NEW-3 r33 resolved).

---

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 28 |
| **Passed** | 26 |
| **Resolved** | 1 (INFO-NEW-3 r33) |
| **Failed (GAPs)** | 1 (GAP-P24-002-001 LOW) |
| **Warnings (INFO)** | 9 carry-forward + 2 new (INFO-1..4 carry; INFO-6 carry; INFO-8 carry; INFO-11, INFO-13, INFO-15 carry; INFO-NEW-4 new; INFO-NEW-5 new) |
| **Overall Status** | gaps-found |

Round 34 is a PATCH-level validation confirming the 2-item P24 adversary-pass fix round: (1) P24-001 (MEDIUM) — BC-3.9.009 body sentence narrowed from "all `jr` attachment operations including download" to "upload and list operations (download excluded)" with explicit cross-reference to BC-2.7.002 authority clause + EC-2.7.007-7; BC-INDEX BC-3.9.009 row updated; old text in frontmatter/footer confirmed as descriptive historical records; normative sweep clean; FULLY APPLIED. (2) P24-002 (LOW) — VP-576-004 body correctly annotated with story allocation (list half S1; upload-platform-POST half S3; full cross-path S3; S3 depends_on S1; NOT S1 acceptance matrix; S1 matrix includes only list half); prd-delta S1 scope row correct; prd-delta S3 scope row NOT updated (note placed in S5 instead — GAP-P24-002-001 LOW); VP body + S1 note + S5 note together communicate correct allocation but S3 scope table is missing the direct cross-reference and disposition/changelog contain false claims; PARTIALLY APPLIED. Counts 657/100/35 unchanged. Spec version advances to 1.3.64.

---

## Appendix: Validation Methodology

This report was produced by a fresh-context consistency validator (cv-f2-576-r34) with structural reference to r33 report only.

1. **Independent artifact read**: All 7 input artifacts read fresh. Findings formed independently from artifact text.
2. **Quote-based closure**: Every P24 priority check verified by verbatim quotation from the authoritative artifact (RE-READ at claim time — not carried from memory).
3. **NORMATIVE SWEEP**: bc-3-issue-write.md scanned for residual normative claims extending the curated shape to download. Three candidate lines examined; all confirmed non-normative (download table row correctly uses `{"downloaded":[...]}`, not curated array; upload body describes upload serialization; BC-3.9.010 contrast note distinguishes delete shape from download shape).
4. **ECHO-BREAKER List A (2 sentences)**: Each of the 2 new P24 behavioral sentences traced to licensing sources; no over-claim identified.
5. **ECHO-BREAKER List B**: Verified empty by grep of holdout-scenarios.md for "P24" — 0 occurrences.
6. **Keystone checks**: K-1 and K-2 verified against quoted text from each referenced source.
7. **Double-insertion sweep**: Marker occurrence counts verified for P24-001/P24-002 citations, [1.3.64] entry, "Adversary Pass 24" section. All counts explained by distinct legitimate locations.
8. **INFO ledger re-verification**: INFO-NEW-3 (r33) verified RESOLVED by fresh inspection of [1.3.64] count table (row 7: "Spec version | 1.3.63→1.3.64"). INFO-NEW-2 (r33) worsened: bc-2 now missing both v1.3.63 and v1.3.64 frontmatter entries; renamed INFO-NEW-4.
9. **Guard scripts**: Both `check-spec-counts.sh` and `check-bc-cumulative-counts.sh` executed and verified "OK".
10. **Count sweep**: BC (657), holdout (100), VP (35) verified across BC-INDEX frontmatter, bc-2/bc-3 frontmatter, prd-delta-576.md P24 closing, spec-changelog [1.3.64] count table, and holdout-scenarios.md frontmatter.
