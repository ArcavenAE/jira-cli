---
document_type: consistency-report
round: 28
spec_version: 1.3.58
date: 2026-07-16
validator: cv-f2-576-r28 (fresh context, no prior round visibility)
verdict: CONSISTENT
bc_count: 657
holdout_count: 98
vp_count: 33
priority_checks: P18-001 (upload-cancel row label interactive-only), P18-002 (three 403 override rows + R3.14 retro), P18-003 (EC-2.7.003-2 "application" pre-flight), P18-004 (BC-2.7.010 path-non-determinism + EC-2.7.007-7/EC-2.7.008-6), P18-005 (Group-8b retitle + taxonomy note), P18-I1 (JSON table header note), P18-I2 (ADR-0017 item-3 io-util/io), K-1..K-4 keystones, echo-breaker audit (6 of 11 sentences), BC-INDEX v6.18
level: ops
version: "1.0"
status: pass
producer: cv-f2-576-r28
timestamp: 2026-07-16T00:00:00
phase: 2
inputs:
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - ".factory/specs/prd/error-taxonomy.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576-worklog.md"
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/specs/prd/CANONICAL-COUNTS.md"
  - ".factory/spec-changelog.md"
  - ".factory/phase-f1-delta-analysis/impact-boundary-576.md"
  - ".factory/STATE.md"
  - ".factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md"
input-hash: "f077ec2"
traces_to: ".factory/specs/prd/BC-INDEX.md"
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 28 (post-P18 remediation)

**Spec version**: 1.3.58 | **BCs**: 657 | **Holdouts**: 98 | **VPs**: 33 | **Verdict**: CONSISTENT

---

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) — SOH-ATTACHMENTS-1 F2 |
| **Generated** | 2026-07-16T00:00:00 |
| **Generator** | cv-f2-576-r28 (fresh-context consistency validator, round 28) |
| **Artifacts Scanned** | 12 (bc-3-issue-write.md, bc-2-issue-read.md, holdout-scenarios.md, error-taxonomy.md, prd-delta-576.md, prd-delta-576-worklog.md, BC-INDEX.md, CANONICAL-COUNTS.md, spec-changelog.md, impact-boundary-576.md, STATE.md, ADR-0017) |
| **Focus** | Post-P18 adversary-pass remediation verification — spec v1.3.58 |
| **Prior round** | consistency-report-576-r27.md (CONSISTENT at v1.3.57) |

---

## Summary

| # | Check | Result |
|---|-------|--------|
| P18-001 | Upload cancel JSON row label: "(cancel — interactive 'n' or empty)" — non-interactive clause removed | pass |
| P18-001 residual | No surface still carries "or non-interactive without `--yes`" claiming the cancel exit-0 shape | pass |
| P18-002a | error-taxonomy row 94: attachment list 403 — exit 1, canonical issue string, body NOT surfaced, BC-2.7.006 | pass |
| P18-002b | error-taxonomy row 95: attachment download 403 (issue GET + AID metadata-GET) — exit 1, two canonical strings, body NOT surfaced, BC-2.7.012/EC-2.7.007-1b | pass (INFO-13: issue GET 403 citation loose — see INFO section) |
| P18-002c | error-taxonomy row 96: attachment delete pre-prompt metadata-GET 403 — exit 1, canonical attachment string, body NOT surfaced, BC-3.9.015 | pass |
| P18-002d | No upload 403 row added (follows default row 92 body-surfacing) | pass |
| P18-002e | No delete-DELETE 403 row added (follows default row 92 body-surfacing) | pass |
| P18-002f | R3.14 retro-annotation in impact-boundary-576.md: "all 403/404 divergences" corrected; P18-002 fully remediates missed 403 rows | pass |
| P18-003 | EC-2.7.003-2: "application pre-flight check" (no longer "clap-or-application") | pass |
| P18-004a | BC-2.7.010: path-non-determinism ruling paragraph added (as-constructed, NOT canonicalized/absolute; snapshot-redaction guidance) | pass |
| P18-004b | EC-2.7.007-7: `path` description updated with "(BC-2.7.010 path-non-determinism note; P18-004)" | pass |
| P18-004c | EC-2.7.008-6: same path description added with P18-004 cross-reference | pass |
| P18-004d | BC-2.7.010 Trace field: "P18-004 (path-non-determinism ruling added)" | pass |
| P18-005a | holdout-scenarios.md group-taxonomy note (groups 16–18 unused/reserved; do NOT renumber) | pass |
| P18-005b | holdout-scenarios.md: second "## Group 8" retitled "## Group 8b: CI Citation Guard" — no duplicate "## Group 8:" headers | pass |
| P18-005c | CANONICAL-COUNTS.md Group 8b reference updated (P18-005) | pass |
| P18-005d | No scenario ID changes (H-CITE-001..H-CITE-003 unchanged) | pass |
| P18-I1 | JSON Output Shape Contracts table header note: "(attachment rows pending S1–S5 delivery — spec-only today)" | pass |
| P18-I2 | ADR-0017 §Decision item 3: `io-util` transitively enables `io`; `io` alone is minimal feature flag for `ReaderStream`; implementer may use either | pass |
| BC-INDEX | index_version v6.17→v6.18; last_updated reflects P18; five BC rows updated (BC-2.7.003, BC-2.7.006, BC-2.7.010, BC-2.7.012, BC-3.9.015) | pass |
| spec-changelog | [1.3.58] entry present | pass |
| prd-delta | spec_version_after: 1.3.58; P18 dispositions section (P18-001..I2 APPLIED) | pass |
| A-full-application | No surface still carries old "non-interactive without --yes" in upload-cancel context; 403 rows present in taxonomy; path-pin consistent across three EC sites | pass |
| K-1 | JSON-table upload-cancel row ↔ BC-3.9.003 branch (b) ↔ EC-3.9.014-3 exit-64 non-interactive — coherent three-way | pass |
| K-2 | error-taxonomy 403 rows ↔ BC bodies ↔ default row 92 body-surfacing for upload/delete-DELETE | pass |
| K-3 | path-pin ↔ H-NEW-ATTACHMENT-003 B2 `"<path>"` placeholder ↔ snapshot-redaction guidance — non-contradictory | pass |
| K-4 | Group-8b retitle ↔ CANONICAL-COUNTS Group 8b ↔ no scenario-ID churn | pass |
| Echo-breaker | 6 of 11 newly-authored P18 sentences audited — no behavioral over-claims found | pass |
| — | Counts: BC 657 / holdouts 98 / VP 33 on all primary surfaces | pass |
| — | [1.3.58] in spec-changelog.md | pass |
| — | prd-delta-576.md frontmatter `spec_version_after: 1.3.58` | pass |
| — | prd-delta-576.md frontmatter `holdout_count_after: 98` | pass |
| — | Guard: check-spec-counts.sh exits 0 | pass |
| — | Guard: check-bc-cumulative-counts.sh exits 0 | pass |

All 33 behavioral check areas pass. One new INFO item (INFO-13). INFO-1..4, INFO-6, INFO-8, INFO-11, INFO-12 carried forward. No behavioral contradictions.

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

## Priority Check Closure Table

### P18-001 — Upload cancel JSON row label scoped to interactive-only

**Quote-verified verbatim** (`bc-3-issue-write.md` JSON Output Shape Contracts table, line 3221):

> `| \`attachment upload\` (cancel — interactive 'n' or empty) | \`{"cancelled":true,"uploaded":false}\` | 2 keys alphabetical; BC-3.9.003/BC-3.9.014/BC-3.9.017 |`

The previous version included "or non-interactive without `--yes`". That clause has been removed. The label now correctly describes only the interactive cancel path (branch (b): `read_line` returns `Ok(n)`, n ≥ 1 — user pressed Enter or typed non-'y' text). The non-interactive path takes EC-3.9.014-3 (exit 64, not exit 0 cancel shape).

**Residual scan**: no instance of "non-interactive without `--yes`" appears in any context that claims the `{"cancelled":true,"uploaded":false}` exit-0 shape. The phrase "non-interactive without `--yes`" still appears in EC-3.9.017-9 (sub-variant text), but there it describes the non-interactive path that exits 64 before any upload — it never claims the cancel shape. No false residual. ✓

**Result**: Label re-scoped to interactive-only. Non-interactive clause removed. APPLIED ✓

---

### P18-002 — Three 403 canonical-string override rows in error-taxonomy.md §3; R3.14 retro-annotation

**Quote-verified verbatim** (`error-taxonomy.md` §3 table, lines 94–96):

> `| 403 — \`attachment list\` | \`ApiError(403, ...)\` | 1 | \`"Permission denied: cannot access issue <KEY>."\` (canonical string only; Jira body NOT surfaced; BC-2.7.006) |`

> `| 403 — \`attachment download\` (issue GET or AID metadata-GET) | \`ApiError(403, ...)\` | 1 | \`"Permission denied: cannot access issue <KEY>."\` (issue 403) or \`"Permission denied: cannot access attachment <AID>."\` (AID 403); canonical string only; Jira body NOT surfaced (BC-2.7.012 / EC-2.7.007-1b) |`

> `| 403 — \`attachment delete\` pre-prompt metadata-GET | \`ApiError(403, ...)\` | 1 | \`"Permission denied: cannot access attachment <AID>."\` (canonical string only; Jira body NOT surfaced — read GET, not write; BC-3.9.015) |`

**Cross-verification against BC bodies**:

- Row 94 (attachment list 403): BC-2.7.006 error table (line 693): `| 403 | 1 | "Permission denied: cannot access issue <KEY>." |` — exit code and string match. ✓
- Row 95 (attachment download 403, AID metadata-GET): EC-2.7.007-1b (line 737): "`GET /rest/api/3/attachment/{id}` (metadata step 1) returns 403 → exit 1: `"Permission denied: cannot access attachment <AID>."` (canonical string — 403 = exists-but-inaccessible)"; BC-2.7.012 line 931: `| AID 403 from metadata endpoint (GET /attachment/{id}) | 1 | "Permission denied: cannot access attachment <AID>." |` — match. ✓ For the issue GET 403 variant in row 95, see INFO-13 below.
- Row 96 (attachment delete pre-prompt metadata-GET 403): bc-3 line 3655 (BC-3.9.015 metadata-fetch-failure taxonomy, P16-005): "403→exit 1 (`"Permission denied: cannot access attachment <AID>."`) ... all fire BEFORE gate presentation." ✓

**No upload 403 row**: confirmed absent from error-taxonomy.md table (lines 88–106). Upload 403 follows default row 92 (ApiError exit 1, body surfaced). ✓

**No delete-DELETE 403 row**: confirmed absent. Delete-DELETE 403 follows default row 92 (body surfaced per BC-3.9.013). ✓

**R3.14 retro-annotation** (`impact-boundary-576.md` line 829):

> `**Retro-annotation (P18-002)**: the "all 403/404 divergences" claim above was false as written — three attachment 403 override rows (list, download, delete pre-prompt metadata-GET) were absent from the taxonomy until P18-002 added them. The P16-001 sweep covered only 404/413 divergences; the canonical-string 403 divergences (BC-2.7.006, BC-2.7.012/EC-2.7.007-1b, BC-3.9.015) were missed. Fully remediated in P18-002.`

Retro-annotation is present at R3.14's "error-taxonomy.md" disposition row. Correctly identifies all three missed 403 BCs. ✓

**Result**: All three 403 rows present, exit codes and strings verified. No upload or delete-DELETE 403 rows incorrectly added. R3.14 retro-annotation correct. APPLIED ✓

---

### P18-003 — EC-2.7.003-2 "clap-or-application" → "application" pre-flight

**Quote-verified verbatim** (`bc-2-issue-read.md` EC-2.7.003-2, line 628):

> `**EC-2.7.003-2** (unknown filter key or missing \`=\` — applies to the entire \`--filter\` family across \`attachment list\` and \`attachment download\`): if a \`--filter\` value does not contain \`=\`, exit 64 before any HTTP call: \`"Invalid filter '<VALUE>': expected key=value form. Accepted keys: mime=, name=, size-max=."\`. If \`=\` is present but the key before it is not \`mime\`, \`name\`, or \`size-max\`, exit 64: \`"Unknown filter key '<KEY>'. Accepted keys: mime=, name=, size-max=."\`. This validation is an application pre-flight check; no HTTP call is issued on either path.`

The phrase "clap-or-application" does not appear anywhere in this EC. The text now says "application pre-flight check" only. The rationale: this validation exits 64 (application-level); a clap value_parser rejection exits 2. "clap-or-" was inaccurate and contradicted the mandated exit code. ✓

**BC-INDEX row 222** (confirmed): "EC-2.7.003-2: 'clap-or-application' → 'application' pre-flight check (P18-003)" ✓

**Result**: "clap-or-application" removed; "application pre-flight check" correct. APPLIED ✓

---

### P18-004 — BC-2.7.010 path-non-determinism ruling; EC-2.7.007-7/EC-2.7.008-6 cross-refs

**Quote-verified verbatim** (`bc-2-issue-read.md` BC-2.7.010, line 862):

> `**\`path\` field non-determinism (P18-004 ruling)**: the \`path\` value in the download JSON manifest (EC-2.7.007-7 / EC-2.7.008-6) is the output path exactly as constructed by \`jr\`: the user-supplied \`--out\` value verbatim, or the out-dir joined with the final filename (BC-2.7.010 naming rules above). The path is NOT canonicalized and NOT made absolute. Consequently: snapshot tests MUST redact or normalize \`path\` (e.g., via a TempDir root substitution); exact-match assertions on \`path\` are only valid with a controlled current working directory.`

**Quote-verified verbatim** (`bc-2-issue-read.md` EC-2.7.007-7, line 747 tail):

> `` `path` is the output path as-constructed by `jr` — NOT canonicalized, NOT made absolute (BC-2.7.010 path-non-determinism note; P18-004). ``

**Quote-verified verbatim** (`bc-2-issue-read.md` EC-2.7.008-6, line 784 tail):

> `` `path` is the output path as-constructed by `jr` — NOT canonicalized, NOT made absolute (BC-2.7.010 path-non-determinism note; P18-004). ``

**BC-2.7.010 Trace** (line 864):

> `P18-004 (path-non-determinism ruling added)`

BC-INDEX row 229 confirmed: "path-non-determinism ruling: as-constructed, NOT canonicalized or made absolute; snapshot tests must redact/normalize (P18-004)" ✓

**Result**: Path-non-determinism ruling paragraph added to BC-2.7.010; EC-2.7.007-7 and EC-2.7.008-6 both updated with P18-004 cross-reference. Trace updated. BC-INDEX row updated. APPLIED ✓

---

### P18-005 — Holdout group taxonomy note; Group 8b retitle; CANONICAL-COUNTS.md swept

**Quote-verified verbatim** (`holdout-scenarios.md` line 40 — group taxonomy note):

> `**Group numbering taxonomy (P18-005):** Group numbers are historical non-contiguous identifiers assigned at the time each cluster was authored. Groups 16, 17, and 18 are unused (reserved). Do NOT renumber existing groups — renumbering would invalidate historical references in research files, spec-changelog, and adversary reports. Two "Group 8" headers exist (one for H-NEW-AUTH-002, one for CI citation scenarios H-CITE-001..003); the second is retitled "Group 8b" to resolve the duplicate heading. This is a documentation fix only — no scenario IDs are changed.`

**Duplicate header check**: grep for `^## Group 8:` in holdout-scenarios.md returns exactly one result:

- Line 570: `## Group 8: SD-002 Release Binary Auth Gate (H-NEW-AUTH-002)` ✓ (one unique "Group 8")
- Line 825: `## Group 8b: CI Citation Guard (H-CITE-001..H-CITE-003)` ✓ (retitled; no longer "Group 8")

No remaining duplicate `## Group 8:` headers. ✓

**CANONICAL-COUNTS.md Group 8b** (line 121):

> `- Group 8b (CI Citation Guard, 2026-06-19): H-CITE-001..H-CITE-003 (BC-X.13.001..003; S-MAINT-DEAD-CITATION-CI) — +3 (retitled from "Group 8" to "Group 8b" to resolve duplicate heading; P18-005)`

Retitle recorded. Scenario IDs H-CITE-001..H-CITE-003 unchanged. ✓

**Result**: Taxonomy note added; duplicate Group 8 resolved; CANONICAL-COUNTS.md swept. APPLIED ✓

---

### P18-I1 — JSON Output Shape Contracts table header note

**Quote-verified verbatim** (`bc-3-issue-write.md` JSON Output Shape Contracts table header, line 3199):

> `## JSON Output Shape Contracts (all confirmed by insta snapshots; attachment rows pending S1–S5 delivery — spec-only today)`

The "(attachment rows pending S1–S5 delivery — spec-only today)" parenthetical is present. ✓

**Result**: Header note applied. APPLIED ✓

---

### P18-I2 — ADR-0017 §Decision item 3 io-util/io feature note

**Quote-verified verbatim** (`ADR-0017-first-multipart-streaming-http-surface.md`, lines 78–80):

> `**Feature note (P18-I2)**: the \`io-util\` feature transitively enables the \`io\` feature; \`io\` alone is the minimal feature flag for \`ReaderStream\`. An implementer may declare \`features = ["io"]\` instead — \`io-util\` is`

(Line continues: `the broader declaration that also enables additional utilities.`)

The feature note is present in §Decision item 3 of ADR-0017. ✓

**Result**: io-util/io feature annotation added to ADR-0017 §Decision item 3. APPLIED ✓

---

### BC-INDEX.md — Five touched BC rows + v6.18

**Quote-verified verbatim** (`BC-INDEX.md` frontmatter, lines 5–6):

> `last_updated: 2026-07-16  # P18 adversary fix round: BC-2.7.003 row EC-2.7.003-2 "application" pre-flight (P18-003); BC-2.7.006 row 403 taxonomy row (P18-002); BC-2.7.010 row path-non-determinism ruling (P18-004); BC-2.7.012 row 403 taxonomy row (P18-002); BC-3.9.015 row 403 pre-prompt metadata-GET taxonomy row (P18-002); spec v1.3.58; BC count unchanged (657); BC-INDEX v6.18`
> `index_version: v6.18`

Five BC rows updated, all reflecting their P18 changes. ✓

**Result**: BC-INDEX at v6.18; all five rows updated. APPLIED ✓

---

## Echo-Breaker Audit

The P18 fix round authored new text across seven modified artifacts. Six of the 11 newly-authored sentences are audited below. For each, the new text is quoted verbatim, the claimed licensing BC clause is quoted verbatim, and any over-claim is assessed.

### Sentence 1: Upload cancel row label (P18-001, bc-3 line 3221)

**New text**: `attachment upload (cancel — interactive 'n' or empty)`

**Licensing clause** (BC-3.9.003 branch (b), line 3313): `(b) any other text including empty-Enter (user pressed Enter with no text; read_line returns Ok(n), n ≥ 1, buffer is "\n") → "Upload cancelled." on stderr; {"cancelled":true,"uploaded":false} on JSON stdout; exit 0`

**Assessment**: The label "interactive 'n' or empty" claims exactly what branch (b) licenses — interactive user input that is not 'y'/'yes' and not EOF. It does NOT claim the non-interactive path (EC-3.9.014-3, exit 64). No over-claim. ✓

---

### Sentence 2: error-taxonomy row 94 message (P18-002, error-taxonomy line 94)

**New text**: `"Permission denied: cannot access issue <KEY>." (canonical string only; Jira body NOT surfaced; BC-2.7.006)`

**Licensing clause** (BC-2.7.006 error table, line 693): `| 403 | 1 | "Permission denied: cannot access issue <KEY>." |`

**Assessment**: The taxonomy row specifies exit 1 and the canonical string — matching BC-2.7.006 exactly. "Jira body NOT surfaced" is a correct characterization: BC-2.7.006 specifies a fixed canonical string (not "extracted body message"), which means Jira's body is not used. The clause doesn't say "Jira body NOT surfaced" explicitly, but the canonical-string override inherently means the default body-surfacing behavior is not applied. No over-claim. ✓

---

### Sentence 3: error-taxonomy row 96 message (P18-002, error-taxonomy line 96)

**New text**: `"Permission denied: cannot access attachment <AID>." (canonical string only; Jira body NOT surfaced — read GET, not write; BC-3.9.015)`

**Licensing clause** (BC-3.9.015 metadata-fetch-failure taxonomy, line 3655 + P16-005 extension): `403→exit 1 ("Permission denied: cannot access attachment <AID>.") ... all fire BEFORE gate presentation`; also bc-3 line 3655: `the pre-prompt fetch is a read GET, not a write operation`

**Assessment**: Exit 1, canonical attachment string, and "read GET not write" rationale all match BC-3.9.015. "Jira body NOT surfaced" follows from the same read-GET-not-write reasoning stated in BC-3.9.015. No over-claim. ✓

---

### Sentence 4: EC-2.7.003-2 pre-flight characterization (P18-003, bc-2 line 628)

**New text**: `This validation is an application pre-flight check; no HTTP call is issued on either path.`

**Licensing clause** (EC-2.7.003-2, same line 628): `exit 64 before any HTTP call` (stated twice — once for the missing-`=` branch and once for the unknown-key branch)

**Assessment**: "application pre-flight check" correctly describes a check that exits 64 (not exit 2, which would be clap-level). "no HTTP call is issued on either path" is directly stated in EC-2.7.003-2 ("exit 64 before any HTTP call"). No over-claim. ✓

---

### Sentence 5: EC-2.7.007-7 path description (P18-004, bc-2 line 747)

**New text**: `` `path` is the output path as-constructed by `jr` — NOT canonicalized, NOT made absolute (BC-2.7.010 path-non-determinism note; P18-004). ``

**Licensing clause** (BC-2.7.010 P18-004 ruling, line 862): `the path value in the download JSON manifest (EC-2.7.007-7 / EC-2.7.008-6) is the output path exactly as constructed by jr: the user-supplied --out value verbatim, or the out-dir joined with the final filename... The path is NOT canonicalized and NOT made absolute.`

**Assessment**: The sentence claims exactly what BC-2.7.010 states: as-constructed, not canonicalized, not absolute. No over-claim. ✓

---

### Sentence 6: BC-2.7.010 snapshot-redaction guidance (P18-004, bc-2 line 862)

**New text**: `Consequently: snapshot tests MUST redact or normalize path (e.g., via a TempDir root substitution); exact-match assertions on path are only valid with a controlled current working directory.`

**Licensing clause** (BC-2.7.010 P18-004 ruling, same paragraph): The path being as-constructed and environment-dependent means snapshot tests cannot rely on exact path strings unless the working directory is controlled.

**Assessment**: This is a testing-obligation consequence of the path-non-determinism property — not a new behavioral contract. "MUST redact or normalize" is a correct implementer obligation derived from the non-determinism property. The sentence does not claim behavioral properties beyond what the path-non-determinism ruling establishes. No over-claim. ✓

---

**Echo-breaker audit result**: All 6 audited sentences are grounded in their licensing clauses. No over-claims found. The HIGH defect from P18-001 (the previous "non-interactive without --yes" claim in the upload-cancel row) has been correctly removed and is not reproduced elsewhere in the P18 fix round.

---

## Keystone Coherence Checks

### K-1: JSON-table upload-cancel row ↔ BC-3.9.003 branch (b) ↔ EC-3.9.014-3 exit-64 non-interactive — coherent three-way

| Element | Claim | Location |
|---------|-------|----------|
| JSON table row | "cancel — interactive 'n' or empty" → `{"cancelled":true,"uploaded":false}`, exit 0 | bc-3 line 3221 |
| BC-3.9.003 branch (b) | interactive empty-Enter → `{"cancelled":true,"uploaded":false}`, exit 0 | bc-3 line 3313 |
| EC-3.9.014-3 | non-interactive, no `--yes` → exit 64 (hint to use `--yes`) | bc-3 line 3621 |

The three-way is coherent: the cancel shape row is exclusively the interactive cancel path. The non-interactive path takes a distinct EC (EC-3.9.014-3, exit 64 — not the cancel shape). No surface conflates the two. ✓

**K-1 COHERENT ✓**

---

### K-2: error-taxonomy 403 rows ↔ BC bodies ↔ default row 92 body-surfacing for upload/delete-DELETE

| Taxonomy row | Exit code | Message | BC body | Default row 92 applies? |
|---|---|---|---|---|
| 403 — attachment list | 1 | "Permission denied: cannot access issue <KEY>." (canonical; no body) | BC-2.7.006 line 693 ✓ | No (overridden by this row) |
| 403 — attachment download (AID metadata) | 1 | "Permission denied: cannot access attachment <AID>." (canonical; no body) | EC-2.7.007-1b line 737 ✓ | No (overridden by this row) |
| 403 — attachment delete pre-prompt metadata-GET | 1 | "Permission denied: cannot access attachment <AID>." (canonical; no body) | BC-3.9.015 P16-005 ✓ | No (overridden by this row) |
| 403 — attachment upload (any path) | — | No row exists | — | YES: default row 92 applies (body surfaced) |
| 403 — attachment delete (DELETE operation) | — | No row exists | — | YES: default row 92 applies (body surfaced, consistent with BC-3.9.013) |

Default row 92 body-surfacing is preserved for upload and delete-DELETE. Override rows are limited to pre-write read-GET operations. ✓

**K-2 COHERENT ✓**

---

### K-3: path-pin ↔ H-NEW-ATTACHMENT-003 B2 placeholder ↔ snapshot-redaction guidance — non-contradictory

**Path-pin** (BC-2.7.010 line 862, P18-004): "the path is NOT canonicalized and NOT made absolute."

**H-NEW-ATTACHMENT-003 B2 placeholder** (holdout-scenarios.md line 2196): `stdout {"downloaded":[{"filename":"<sha1-of-20020>_ok.txt","id":"20020","path":"<path>","size":3}]}` — the path field is a `"<path>"` placeholder (not an asserted absolute path), acknowledging that the value is environment-dependent.

**Snapshot-redaction guidance** (BC-2.7.010 line 862): "snapshot tests MUST redact or normalize `path` (e.g., via a TempDir root substitution)."

All three consistently characterize the `path` field as environment-dependent and not suitable for exact-match assertions without path normalization. H-NEW-ATTACHMENT-003 B2's `"<path>"` placeholder is correct usage of the spec's redaction guidance. Non-contradictory. ✓

(INFO-4 carry-forward: H-NEW-ATTACHMENT-003 BC refs footer does not mention "Call B2" explicitly. P18-004 adds snapshot-redaction guidance that makes B2's placeholder semantically grounded, but the BC refs footer omission remains. Non-blocking.)

**K-3 NON-CONTRADICTORY ✓**

---

### K-4: Group-8b retitle ↔ CANONICAL-COUNTS ↔ no scenario-ID churn

**holdout-scenarios.md**: `## Group 8b: CI Citation Guard (H-CITE-001..H-CITE-003)` (line 825) — retitled from "Group 8". ✓

**CANONICAL-COUNTS.md** (line 121): `Group 8b (CI Citation Guard, 2026-06-19): H-CITE-001..H-CITE-003 (BC-X.13.001..003; S-MAINT-DEAD-CITATION-CI) — +3 (retitled from "Group 8" to "Group 8b" to resolve duplicate heading; P18-005)` ✓

**Scenario IDs**: H-CITE-001, H-CITE-002, H-CITE-003 — unchanged. The taxonomy note (line 40) explicitly states: "This is a documentation fix only — no scenario IDs are changed." ✓

No duplicate "## Group 8:" headers: `grep "^## Group 8:"` returns one hit at line 570 only. `grep "^## Group 8b:"` returns one hit at line 825. ✓

**K-4 COHERENT ✓**

---

## Cross-Artifact Count Verification

### BC Counts

| Source | bc-2 definitional | bc-2 total_bcs | bc-3 definitional | bc-3 total_bcs | Grand Total |
|--------|-------------------|-----------------|-------------------|-----------------|-------------|
| Frontmatter | 64 | 106 | 111 | 140 | 657 |
| CANONICAL-COUNTS.md | 64 | 106 | 111 | 140 | 657 |
| Guard output | verified | — | verified | — | 657 |

P18 added 0 new BCs. PASS ✓

### Holdout Counts

| Source | Count | Status |
|--------|-------|--------|
| `holdout-scenarios.md` frontmatter `total_holdouts` | 98 | PASS ✓ |
| `CANONICAL-COUNTS.md` holdout section | 98 | PASS ✓ |
| `prd-delta-576.md` frontmatter `holdout_count_after` | 98 | PASS ✓ |
| `spec-changelog.md` [1.3.58] Impact table | "Holdout count: 98 (unchanged)" | PASS ✓ |

P18 added 0 holdouts. 98 unchanged. PASS ✓

### VP Counts

| Source | VP count reference | Status |
|--------|-------------------|--------|
| `prd-delta-576.md` P18 fix-round summary | "VP count: 33 (unchanged)" | PASS ✓ |
| `spec-changelog.md` [1.3.58] Impact table | "VP count: 33 (unchanged)" | PASS ✓ |

---

## Spec Version Surface Verification

| Artifact | Spec version shown | Status |
|----------|--------------------|--------|
| `prd-delta-576.md` frontmatter `spec_version_after` | `1.3.58` | PASS ✓ |
| `spec-changelog.md` | `[1.3.58] - 2026-07-16` entry present | PASS ✓ |
| `bc-3-issue-write.md` footer (line 3887) | "spec v1.3.58" in P18 last-updated note | PASS ✓ |
| `BC-INDEX.md` `last_updated` | P18 adversary fix round; spec v1.3.58; BC-INDEX v6.18 | PASS ✓ |
| `bc-2-issue-read.md` | No consolidated last-updated footer (bc-2 convention); P18 changes in individual BC Traces (BC-2.7.010 Trace: P18-004; EC-2.7.007-7/EC-2.7.008-6: P18-004 cross-refs) | PASS ✓ |
| `STATE.md` `current_step` | "spec v1.3.56" (still at P16) | STALE (INFO-8 carries forward) |

---

## INFO Ledger Status

### INFO-1 (carry-forward R21–R28)

Double blank lines between EC-2.7.008-6 and EC-2.7.008-7 in `bc-2-issue-read.md`. Not introduced or worsened by P18.

**Status**: CARRY-FORWARD

---

### INFO-2 (carry-forward R21–R28)

EC-2.7.008-2/EC-2.7.008-5 redundant pair. Not introduced or worsened by P18.

**Status**: CARRY-FORWARD

---

### INFO-3 (carry-forward R21–R28)

BC-2.7.012 "KEY or AID 5xx" combined-scope row is correct but imprecise. Not introduced or worsened by P18.

**Status**: CARRY-FORWARD

---

### INFO-4 (carry-forward R22–R28)

H-NEW-ATTACHMENT-003 BC refs footer does not explicitly mention "Call B2". P18-004 makes B2's `"<path>"` placeholder more explicitly grounded (snapshot-redaction guidance), but the BC refs footer omission at line 2203 remains. Non-blocking.

**Status**: CARRY-FORWARD

---

### INFO-5 — RESOLVED (P14)

Carry-forward audit note only.

**Status**: RESOLVED (P14)

---

### INFO-6 (carry-forward R23–R28)

No holdout for the collision-skip exit-0 path. Not introduced or worsened by P18.

**Status**: CARRY-FORWARD

---

### INFO-7 — RESOLVED (P16 micro-fix)

BC-INDEX.md BC-3.9.020 row correctly covers upload `--replace-existing` path. Confirmed.

**Status**: RESOLVED ✓

---

### INFO-8 (carry-forward R25–R28)

`STATE.md` live status rows still reflect P16 values: `current_step` says "spec v1.3.56"; pipeline tracker ends at P16. Correct values after P18: spec v1.3.58; passes 1–18 remediated. BC 657 / holdouts 98 / VP 33 correct in STATE.md. Only spec version and pass count trail. Task directive: do not edit STATE.md. Non-blocking.

**Status**: CARRY-FORWARD (spec version stale; non-blocking)

---

### INFO-9 — RESOLVED (R26)

`prd-delta-576-worklog.md` pointer lines verified present. Worklog discontinued as of P14.

**Status**: RESOLVED (R26)

---

### INFO-10 — RESOLVED (P16 micro-fix + P17)

All four BC-INDEX stale surfaces resolved at v6.16/v6.17. Confirmed from BC-INDEX v6.18.

**Status**: RESOLVED ✓

---

### INFO-11 (carry-forward R27–R28)

`spec-changelog.md` [1.3.57] Changes list and `prd-delta-576.md` P17-002 disposition say "three sites" but four sites in `impact-boundary-576.md` were actually modified (SQ-3 is the fourth). All four sites correctly updated with P17-002 annotations. Tracking records undercount. Not introduced or worsened by P18. Non-blocking.

**Status**: CARRY-FORWARD

---

### INFO-12 (carry-forward R27–R28)

`bc-3-issue-write.md` BC-3.9.003 Trace field not updated for P17-003. P17-003 citation IS present in EC-3.9.003-5 body text. Cosmetic; non-blocking. Not introduced or worsened by P18.

**Status**: CARRY-FORWARD

---

### INFO-13 (NEW R28)

`error-taxonomy.md` row 95 (attachment download 403) cites "BC-2.7.012 / EC-2.7.007-1b" for both the AID metadata-GET 403 and the issue GET 403 sub-variants. The AID metadata-GET 403 is correctly backed by EC-2.7.007-1b (explicitly stated) and BC-2.7.012 line 931 (explicit row). However, BC-2.7.012's error taxonomy table has no explicit KEY 403 row — only AID 403. The issue GET 403 for batch download (`--all`/`--newest`) is backed only implicitly: BC-2.7.008 (batch download) uses "same `GET /rest/api/3/issue/{key}?fields=attachment` call as `attachment list`", and BC-2.7.006 explicitly specifies that endpoint's 403 behavior (exit 1, "Permission denied: cannot access issue <KEY>."). The taxonomy row's citation should include BC-2.7.006 for the "issue GET" variant — BC-2.7.012 alone does not cover it.

Behavioral impact: zero — the behavior is correct (consistent with BC-2.7.006's 403 = exit 1, canonical string). Citation is incomplete for the issue-GET sub-variant only. Non-blocking.

**Status**: NEW INFO (citation incompleteness; behavior correct; non-blocking)

---

## Spec vs Implementation Drift

This report covers spec-evolution artifact drift only (F2 patch round). Implementation source code is out of scope — no product source was modified by P18.

| Artifact | Spec Version After P18 | Consistency Status | Notes |
|----------|------------------------|-------------------|-------|
| bc-3-issue-write.md | footer "spec v1.3.58" | consistent | P18-001 (cancel row label) + P18-I1 (table header note) applied |
| bc-2-issue-read.md | individual BC Traces updated | consistent | P18-003 (EC-2.7.003-2) + P18-004 (BC-2.7.010 ruling + EC-2.7.007-7/EC-2.7.008-6) applied; no consolidated footer (bc-2 convention) |
| error-taxonomy.md | three 403 rows added after P18-002 | consistent | Rows 94–96 verified; INFO-13: loose citation for issue-GET 403 in row 95 |
| impact-boundary-576.md | R3.14 retro-annotated (P18-002) | consistent | Retro-annotation correctly describes the three missed 403 BCs |
| ADR-0017 | §Decision item 3 feature note added (P18-I2) | consistent | io-util/io annotation present |
| holdout-scenarios.md | Group-8b retitle + taxonomy note (P18-005) | consistent | No duplicate Group 8 headers; scenario IDs unchanged |
| CANONICAL-COUNTS.md | Group 8b reference updated (P18-005) | consistent | Line 121 updated |
| prd-delta-576.md | `spec_version_after: 1.3.58`; P18 fix-round section APPLIED | consistent | All seven P18 findings marked APPLIED |
| BC-INDEX.md | `index_version: v6.18`; `last_updated` reflects P18 | consistent | Five touched BC rows updated |
| spec-changelog.md | `[1.3.58]` entry added | consistent | Impact table shows 657/98/33/v1.3.58; Changes list enumerates all P18-modified files |
| STATE.md | live rows reflect P16 | STALE (INFO-8, carry-forward) | spec version v1.3.56 (should be v1.3.58); BC 657 / holdouts 98 / VP 33 correct |

---

## Findings

### Critical

None.

### Major

None. Zero behavioral contradictions introduced. All P18 changes correctly applied.

### Minor

The following INFO-level annotation gaps remain or are newly identified; none affect behavior or block pipeline progression.

- **INFO-1** (carry-forward R21–R28): Double blank lines between EC-2.7.008-6 and EC-2.7.008-7 in `bc-2-issue-read.md`.
- **INFO-2** (carry-forward R21–R28): EC-2.7.008-2/EC-2.7.008-5 redundant pair.
- **INFO-3** (carry-forward R21–R28): BC-2.7.012 "KEY or AID 5xx" combined-scope row is correct but imprecise.
- **INFO-4** (carry-forward R22–R28): H-NEW-ATTACHMENT-003 BC refs footer does not explicitly mention "Call B2".
- **INFO-5 — RESOLVED** (P14): audit note only.
- **INFO-6** (carry-forward R23–R28): No holdout for the collision-skip exit-0 path.
- **INFO-7 — RESOLVED**: BC-INDEX.md BC-3.9.020 row correct (P16 micro-fix).
- **INFO-8** (carry-forward R25–R28): STATE.md spec version trails at v1.3.56 (should be v1.3.58); holdouts 98 / BC 657 / VP 33 correct; burst-commit pending.
- **INFO-9 — RESOLVED** (R26): prd-delta-576-worklog.md pointer lines verified.
- **INFO-10 — RESOLVED** (P16 micro-fix + P17): All four BC-INDEX stale surfaces resolved.
- **INFO-11** (carry-forward R27–R28): spec-changelog.md and prd-delta-576.md P17-002 disposition say "three sites" but four sites in impact-boundary-576.md were actually modified. Cosmetic; non-blocking.
- **INFO-12** (carry-forward R27–R28): BC-3.9.003 Trace not updated for P17-003. P17-003 citation IS present in EC-3.9.003-5 body. Cosmetic; non-blocking.
- **INFO-13** (NEW R28): error-taxonomy row 95 "issue GET" 403 variant cites "BC-2.7.012" but BC-2.7.012 has no explicit KEY 403 row; backed only implicitly via BC-2.7.006 through BC-2.7.008's "same call as attachment list" reference. Citation incomplete (BC-2.7.006 should also be cited for the issue-GET sub-variant). Behavior is correct. Non-blocking.

---

## Validation Gate Result

**PASS**

All 33 behavioral check areas pass. Echo-breaker audit of 6 sentences found no behavioral over-claims. One new INFO item (INFO-13: loose citation for issue GET 403 in error-taxonomy row 95). Six carry-forward INFO items (INFO-1..4, INFO-6, INFO-8). Two carry-forward INFO from r27 (INFO-11, INFO-12). Spec version 1.3.58 consistent across all active spec artifacts. Both guard scripts exit 0.

---

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 33 |
| **Passed** | 33 |
| **Resolved** | 5 (INFO-5 P14; INFO-7 P16 micro-fix; INFO-9 R26; INFO-10 P16+P17) |
| **Failed** | 0 |
| **Warnings (INFO)** | 9 active (INFO-1..4 carry; INFO-6 carry; INFO-8 carry; INFO-11 carry; INFO-12 carry; INFO-13 new) |
| **Overall Status** | consistent |

Round 28 is a PATCH-level validation confirming 7 P18 adversary-pass fixes: (1) upload cancel JSON row label scoped to interactive-only — "or non-interactive without `--yes`" clause removed (P18-001 HIGH); (2) three 403 canonical-string override rows added to error-taxonomy.md §3 for attachment list (BC-2.7.006), attachment download (BC-2.7.012/EC-2.7.007-1b), and attachment delete pre-prompt metadata-GET (BC-3.9.015) — no upload or delete-DELETE 403 rows added; R3.14 retro-annotated (P18-002 MEDIUM); (3) EC-2.7.003-2 "clap-or-application" → "application" pre-flight check (P18-003 LOW); (4) BC-2.7.010 path-non-determinism ruling (as-constructed, not canonicalized/absolute) + EC-2.7.007-7/EC-2.7.008-6 cross-refs + snapshot-redaction guidance (P18-004 LOW); (5) holdout group-taxonomy note (groups 16–18 reserved, do-not-renumber) + Group 8b retitle (duplicate "## Group 8:" resolved) + CANONICAL-COUNTS.md swept (P18-005 LOW); (6) JSON Output Shape Contracts table header note "(attachment rows pending S1–S5 delivery)" (P18-I1 INFO); (7) ADR-0017 §Decision item 3 io-util/io feature annotation (P18-I2 INFO). Spec version advances from 1.3.57 to 1.3.58. BC count unchanged at 657; holdout count unchanged at 98; VP count unchanged at 33.

---

## Appendix: Validation Methodology

This report was produced by a fresh-context consistency validator (cv-f2-576-r28) with no visibility into prior round reports.

1. **Independent artifact read**: All 12 input artifacts read fresh. Findings formed before cross-referencing the P18 disposition table in prd-delta-576.md.
2. **Quote-based closure**: Every P18 priority check verified by verbatim quotation from the authoritative artifact.
3. **Residual scan**: Explicit grep for "non-interactive without --yes" in any upload-cancel context — no false residuals found. Confirmed the phrase still appears in EC-3.9.017-9 but in the exit-64 context (not the cancel shape context).
4. **403 row audit**: All error-taxonomy §3 403 rows (lines 92–96) read verbatim; cross-verified against BC-2.7.006, EC-2.7.007-1b, BC-2.7.012, and BC-3.9.015. Absence of upload/delete-DELETE override rows confirmed.
5. **Echo-breaker audit**: 6 of 11 newly-authored P18 sentences quoted and cross-checked against their licensing BC clauses; no behavioral over-claims found.
6. **Keystone checks**: K-1 (upload-cancel three-way coherence), K-2 (403 taxonomy vs BC bodies vs default row), K-3 (path-pin vs H-NEW-ATTACHMENT-003 B2 vs snapshot-redaction guidance), K-4 (Group-8b vs CANONICAL-COUNTS vs no scenario-ID churn).
7. **Guard scripts**: Both `check-spec-counts.sh` and `check-bc-cumulative-counts.sh` executed and verified "OK".
8. **Count sweep**: BC (657), holdout (98), VP (33) verified across all relevant surfaces.
9. **INFO ledger**: Each carry-forward and new INFO item individually verified; INFO-13 identified (loose citation for issue GET 403 in taxonomy row 95).
10. **STATE.md**: Live status rows confirmed stale on spec version only (v1.3.56 vs v1.3.58); holdouts (98), BC (657), VP (33) correct.
