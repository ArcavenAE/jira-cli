---
document_type: consistency-report
round: 35
spec_version: 1.3.65
date: 2026-07-17
validator: cv-576-r35 (fresh context, no prior round visibility)
verdict: CONSISTENT
bc_count: 657
holdout_count: 100
vp_count: 35
priority_checks: P25-001 (EC-2.7.008-6 two-part hint-vs-error clause; EC-2.7.008-7 human-mode summary scope; per-file policy point (3) scoped; BC-2.7.008 Trace; BC-INDEX row; H-NEW-ATTACHMENT-003 Call B2 assertions + Why-hidden/Status/BC-refs); P25-002 (BC-2.7.011 case (c) pure does-not-apply exclusion; Trace; BC-INDEX row; PO temp-file-placement spot-check); P25-I01 (R3.9b PHASE-DOC-RETRO-ANNOTATION ↔ BC-2.7.007 step-1 wording); BC-INDEX v6.24→v6.25; spec-changelog [1.3.65] full count table; prd-delta spec_version_after 1.3.65 + P25 section; bc-2 frontmatter v1.3.65 trace entry; counts 657/100/35; double-insertion sweep; ECHO-BREAKER List A (7 items, audited all 7) + List B (H-003 Call B2 licensing + fixture satisfiability); K-1 (hint-vs-error enumeration across §2.7 — one new INFO); K-2 (--out exclusion story non-contradictory with EC-2.7.007-11); K-3 (R3.9b annotation ↔ BC-2.7.007 step-1 wording coherent); GAP-P24-002-001 (r34) resolved; INFO-4 (r22-r34) resolved; INFO-NEW-4 (r34) resolved
level: ops
version: "1.0"
status: consistent
producer: cv-576-r35
timestamp: 2026-07-17T00:00:00
phase: 2
inputs:
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/specs/prd/CANONICAL-COUNTS.md"
  - ".factory/spec-changelog.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
  - ".factory/phase-f1-delta-analysis/impact-boundary-576.md"
input-hash: "4c0d5b0"
traces_to: ".factory/specs/prd/BC-INDEX.md"
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 35 (post-P25 remediation)

**Spec version**: 1.3.65 | **BCs**: 657 | **Holdouts**: 100 | **VPs**: 35 | **Verdict**: CONSISTENT

---

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) — SOH-ATTACHMENTS-1 F2 |
| **Generated** | 2026-07-17T00:00:00 |
| **Generator** | cv-576-r35 (fresh-context consistency validator, round 35) |
| **Artifacts Scanned** | 7 (bc-2-issue-read.md, holdout-scenarios.md, BC-INDEX.md, CANONICAL-COUNTS.md, spec-changelog.md, prd-delta-576.md, impact-boundary-576.md) |
| **Focus** | Post-P25 adversary-pass remediation verification — spec v1.3.64 → v1.3.65; 2 LOW + 1 INFO findings (first zero-MEDIUM-and-above pass); double-insertion sweep; ECHO-BREAKER List A (7 items) + List B (H-003 Call B2); K-1..K-3 keystones; GAP-P24-002-001 r34 gap-closure resolution check; INFO-4/INFO-NEW-4 closure check |
| **Prior round** | consistency-report-576-r34.md (GAPS-FOUND; GAP-P24-002-001 LOW: prd-delta S3 scope row missing VP-576-004 allocation note; INFO-NEW-4: bc-2 frontmatter trace missing v1.3.63+v1.3.64; INFO-NEW-5: BC-3.9.009 Trace not updated with P24-001) |

---

## Summary Table

| # | Check | Result |
|---|-------|--------|
| P25-001 | EC-2.7.008-6 two-part hint-vs-error clause present (bc-2 line 796) | pass |
| P25-001 | EC-2.7.008-6 ERROR part: per-file warnings ARE emitted in JSON mode (unconditional) | pass |
| P25-001 | EC-2.7.008-6 HINT part: "Downloaded N of M" summary NOT emitted in JSON mode | pass |
| P25-001 | EC-2.7.008-7 human-mode-only summary scope present (bc-2 line 800) | pass |
| P25-001 | EC-2.7.008-7 both-mode per-file warnings clause present | pass |
| P25-001 | Per-file policy paragraph point (3) scoped to "human-mode summary" (bc-2 line 787) | pass |
| P25-001 | BC-2.7.008 Trace: P25-001 citation present (bc-2 line 808) | pass |
| P25-001 | BC-INDEX BC-2.7.008 row: JSON-mode hint-vs-error policy note added | pass |
| P25-001 | H-NEW-ATTACHMENT-003 Call B2: assertion 1 (stderr CONTAINS per-file warning for AID 20021) | pass |
| P25-001 | H-NEW-ATTACHMENT-003 Call B2: assertion 2 (stderr NOT contain "Downloaded") | pass |
| P25-001 | H-NEW-ATTACHMENT-003 Call B2: MUST-FAIL bullet 1 (id:20021 in downloaded MUST FAIL) | pass |
| P25-001 | H-NEW-ATTACHMENT-003 Call B2: MUST-FAIL bullet 2 (per-file warning absent in JSON mode MUST FAIL) | pass |
| P25-001 | H-NEW-ATTACHMENT-003 Call B2: MUST-FAIL bullet 3 (emits "Downloaded" in JSON mode MUST FAIL) | pass |
| P25-001 | H-NEW-ATTACHMENT-003 Call B2: Why-hidden updated with EC-2.7.008-6 JSON-mode policy | pass |
| P25-001 | H-NEW-ATTACHMENT-003 Call B2: Status updated with P25-001 EC-2.7.008-6 pin | pass |
| P25-001 | H-NEW-ATTACHMENT-003 Call B2: BC-refs updated with EC-2.7.008-6 (Call B2, P25-001) | pass |
| P25-001 | bc-2 frontmatter trace: v1.3.65 entry added (bc-2 line 19) | pass |
| P25-002 | BC-2.7.011 step-1 case (c): pure does-not-apply exclusion for --out PATH (bc-2 line 905) | pass |
| P25-002 | BC-2.7.011 case (c): explicitly states neither step 1 (canonicalize) nor step 2 (starts_with) applies | pass |
| P25-002 | BC-2.7.011 Trace: P25-002 citation present (bc-2 line 918) | pass |
| P25-002 | BC-INDEX BC-2.7.011 row: --out does-not-apply note added with P25-002 citation | pass |
| P25-002 PO spot-check | BC-2.7.007 Write-to-temp section (line 741): does NOT reference canonicalize(out_dir) for --out path | pass |
| P25-I01 | R3.9b PHASE-DOC-RETRO-ANNOTATION present (impact-boundary-576.md line 758) | pass |
| P25-I01 | Annotation content accurate against BC-2.7.007 step-1 wording (content URL from id, not metadata field) | pass |
| BC-INDEX v6.25 | index_version v6.24→v6.25; last_updated P25 note present | pass |
| spec-changelog [1.3.65] | Entry present dated 2026-07-17; Summary + Changed Requirements + Impact Assessment artifact table + count table | pass |
| spec-changelog [1.3.65] count table | BC 657 / Holdout 100 / VP 35 / New BCs 0 / New VPs 0 / New Holdouts 0 | pass |
| spec-changelog [1.3.65] count table | "Spec version \| 1.3.64→1.3.65" row present | pass |
| prd-delta spec_version_after 1.3.65 | frontmatter updated (line 8) | pass |
| prd-delta P25 dispositions section | Present (unique heading at line 448); counts BC 657/holdout 100/VP 35/spec v1.3.65/both guards exit 0 | pass |
| Counts 657/100/35 | Consistent across all surfaces; both guards exit 0 | pass |
| Double-insertion sweep | No duplicate EC-2.7.008-6 two-part clause, case (c) exclusion, R3.9b annotation, [1.3.65] entry, "Adversary Pass 25" heading; P25-001/P25-002/P25-I01 counts all explained by distinct legitimate locations | pass |
| ECHO-BREAKER List A (7 items) | All 7 P25 behavioral sentences grounded in licensing sources; no over-claim | pass |
| ECHO-BREAKER List B | H-003 Call B2: assertions licensed by EC-2.7.008-6 (P25-001); fixture fails exactly one AID = 20021; assertions satisfiable | pass |
| GAP-P24-002-001 (r34) | prd-delta S3 scope row VP-576-004 note: present (r34 gap-closure; "P24-002, r34 gap-closure" annotation) | resolved |
| INFO-4 (r22-r34) | H-NEW-ATTACHMENT-003 BC refs footer now lists BC-2.7.008 EC-2.7.008-6 for Call B2 | resolved |
| INFO-NEW-4 (r34) | bc-2 frontmatter trace: v1.3.64 entry at line 18 + v1.3.65 entry at line 19; v1.3.63 confirmed NOT owed | resolved |
| Guard: check-spec-counts.sh | OK: all spec counts verified | pass |
| Guard: check-bc-cumulative-counts.sh | OK: all cumulative BC counts verified (657 total across 8 files) | pass |

**All P25 items verified fully applied. Three prior-round items resolved (GAP-P24-002-001, INFO-4, INFO-NEW-4). No new CRITICAL, MAJOR, or behavioral GAP findings. One new INFO item (INFO-NEW-6: EC-2.7.008-10/EC-2.7.009-3 JSON-mode stderr ambiguity — pre-existing, surfaced by K-1 enumeration). Keystones K-1/K-2/K-3 all coherent. Both guards exit 0. Verdict: CONSISTENT.**

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

## P25-001 — EC-2.7.008-6/7 Hint-vs-Error Channel Policy

### EC-2.7.008-6 Two-Part Clause (bc-2 line 796) — Quote-Verified

**New text** (verbatim, bc-2-issue-read.md line 796, JSON-mode stderr policy sub-clause):

> `**JSON-mode stderr policy (hint-vs-error distinction, P25-001)**: per-file failure warnings (\`"warning: failed to download attachment <AID>: <reason>"\`) ARE emitted to stderr in JSON mode — download failures are ERRORS, not hints, and fire unconditionally (consistent with the model-b cache-writer warning convention). The \`"Downloaded N of M"\` summary is NOT emitted in JSON mode — it is a HINT, suppressed in JSON mode by this rule.`

Two-part structure confirmed:
- Part (a): per-file warnings ARE emitted (ERRORS, unconditional) ✓
- Part (b): "Downloaded N of M" summary NOT emitted (HINT, suppressed) ✓
- P25-001 citation present ✓

### EC-2.7.008-7 Human-Mode Scope (bc-2 line 800) — Quote-Verified

**New text** (verbatim, bc-2-issue-read.md line 800, relevant additions):

> `stderr per-file warnings emitted for each failure (in both human and JSON modes — failures are ERRORS, not hints; see EC-2.7.008-6 JSON-mode stderr policy, P25-001); **human mode only**: summary prints actual \`N\` of \`M\` where N < M (the \`Downloaded N of M\` summary is not emitted in JSON mode — it is a HINT per EC-2.7.008-6).`

- Per-file warnings: "in both human and JSON modes" ✓
- Summary: "human mode only" ✓
- P25-001 cross-reference ✓

### Per-File Policy Paragraph Point (3) (bc-2 line 787) — Quote-Verified

**Updated text** (verbatim):

> `(3) the failed attachment is excluded from the \`downloaded\` array in JSON mode and from the N count in the human-mode summary (the \`"Downloaded N of M"\` summary is a HINT — not emitted in JSON mode per EC-2.7.008-6 JSON-mode stderr policy, P25-001).`

"from the N count in the human-mode summary" explicitly scopes the exclusion-from-N-count to human mode; JSON mode behavior described separately via EC-2.7.008-6 cross-reference. ✓

### BC-2.7.008 Trace (bc-2 line 808) — Quote-Verified

> `**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design); P15-007 (EC-2.7.008-10 filtered-to-zero non-empty); P25-001 (EC-2.7.008-6 JSON-mode hint-vs-error policy; EC-2.7.008-7 human-mode summary scoping; Per-file download error policy point (3) scoped)`

P25-001 citation present with description of all three changes. ✓

### BC-INDEX BC-2.7.008 Row — Quote-Verified

From BC-INDEX.md (BC-2.7.008 row):

> `**JSON-mode stderr policy (P25-001)**: per-file failure warnings (\`warning: failed to download attachment <AID>: ...\`) ARE emitted to stderr in JSON mode (ERRORS, not hints); \`Downloaded N of M\` summary NOT emitted in JSON mode (HINT, suppressed — EC-2.7.008-6)`

P25-001 note added to BC-INDEX row. ✓

### H-NEW-ATTACHMENT-003 Call B2 — Quote-Verified

**Three assertions added** (holdout-scenarios.md lines 2197–2201):

> `- stderr CONTAINS a line matching \`"warning: failed to download attachment 20021: ..."\` (per-file failure warning is an ERROR, not a hint — fires unconditionally in JSON mode per EC-2.7.008-6 JSON-mode stderr policy, P25-001; licensing BC: EC-2.7.008-6).`

> `- stderr does NOT contain \`"Downloaded"\` (the \`Downloaded N of M\` summary is a HINT — suppressed in JSON mode per EC-2.7.008-6 JSON-mode stderr policy, P25-001).`

> `- An implementation that includes \`"id":"20021"\` in \`downloaded\` MUST FAIL this assertion.`

> `- An implementation that omits the per-file warning for attachment 20021 from stderr in JSON mode MUST FAIL this assertion.`

> `- An implementation that emits \`"Downloaded"\` to stderr in JSON mode MUST FAIL this assertion.`

Five items total: 2 positive assertions + 3 MUST-FAIL bullets. ✓

**Why-hidden** (line 2203): Updated to describe Call B2 as exercising "the JSON-mode stderr policy (EC-2.7.008-6, P25-001): per-file failure warnings ARE emitted in JSON mode (ERRORS, not hints); the `Downloaded N of M` summary is NOT emitted (HINT, suppressed)." ✓

**Status** (line 2205): Updated to pin "EC-2.7.008-6 JSON-mode stderr policy (P25-001: per-file warning unconditional in JSON mode; `Downloaded` summary absent from stderr in JSON mode)." ✓

**BC-refs** (line 2207): Updated to include "BC-2.7.008 EC-2.7.008-6 (JSON-mode stderr policy, Call B2, P25-001)". ✓ **This resolves INFO-4 (r22–r34).**

**Fixture satisfiability**: Call B2 mounts issue `FOO-5` with id `20020` → 200 + `AAA` (success) and id `20021` → 500 (fail). Exactly one AID = 20021 fails. The assertion "stderr CONTAINS per-file warning for AID 20021" is satisfiable because 20021 fails. The assertion "stderr NOT contain `Downloaded`" is satisfiable because the summary is suppressed in JSON mode by EC-2.7.008-6. The MUST-FAIL bullets are logically satisfiable as compliance checks. ✓

**Result**: P25-001 FULLY APPLIED ✓.

---

## P25-002 — BC-2.7.011 Step-1 Case (c) Reword

### BC-2.7.011 Defense-in-Depth Containment Check — Case (c) (bc-2 line 905) — Quote-Verified

**New text** (verbatim, bc-2-issue-read.md line 905, item (c) within step 1):

> `(c) **\`--out <PATH>\` is excluded from this containment check entirely** — the user-supplied path is trusted operator input (BC-2.7.007/BC-2.7.010); neither step 1 (\`canonicalize(out_dir)\`) nor step 2 (\`starts_with\`) of this check applies to \`--out\`-supplied paths).`

This is a pure does-not-apply exclusion: the user-supplied path is trusted operator input; neither the canonicalize step nor the `starts_with` assertion applies. The old wording (which implied the containment check ran on the `--out` path) has been replaced. ✓

### BC-2.7.011 Trace (bc-2 line 918) — Quote-Verified

> `P25-002 (containment step-1 case (c) reworded — pure does-not-apply exclusion for \`--out <PATH>\`: trusted operator input; neither step 1 nor step 2 applies to \`--out\`-supplied paths)`

P25-002 citation present in Trace field. ✓

### BC-INDEX BC-2.7.011 Row — Quote-Verified

From BC-INDEX.md (BC-2.7.011 row):

> `**\`--out <PATH>\` is excluded from containment check entirely** — trusted operator input (BC-2.7.007/BC-2.7.010); neither step 1 nor step 2 applies to \`--out\`-supplied paths (P25-002 reword)`

P25-002 note added to BC-INDEX row. ✓

### PO Temp-File-Placement Spot-Check — Write-to-Temp Section (bc-2 line 741) — VERIFIED

**PO claim**: "the temp-file-placement section (Write-to-temp + atomic-rename in BC-2.7.007) does NOT reference `canonicalize(out_dir)` for the `--out` path."

**Verified text** (bc-2 line 741):

> `**Write-to-temp + atomic-rename**: The download MUST write to a temporary file named \`tmp_<random>\` in the same directory as the final path (where \`<random>\` is a process-unique random string; NO basename is embedded).`

The Write-to-temp section specifies only the naming convention (`tmp_<random>`) and the placement rule ("same directory as the final path"). For `--out <PATH>`, the "same directory" is the parent directory of the user-specified path. There is **no reference to `canonicalize(out_dir)`** in this section for the `--out` case. The section describes temp file naming, not path sanitization. PO verification is accurate. The simplification to a pure does-not-apply exclusion is warranted. ✓

**Result**: P25-002 FULLY APPLIED ✓.

---

## P25-I01 — R3.9b Phase-Doc Retro-Annotation

### R3.9b Annotation (impact-boundary-576.md line 758) — Quote-Verified

**New text** (verbatim):

> `> **[PHASE-DOC-RETRO-ANNOTATION (P25-I01, 2026-07-17)]** The claim "retrieve \`filename\`, \`mimeType\`, \`size\`, and \`content\` URL" is **superseded in the shipped spec**: BC-2.7.007 step 1 constructs the content URL from the attachment id directly and does NOT read the metadata \`content\` field; metadata is used solely to obtain the canonical \`filename\` for BC-2.7.010 naming. The \`content\`-URL-from-metadata path described here was superseded by the id-direct-construction rule during F2 spec finalisation. Do not implement content-URL extraction from the step-1 metadata response; use the id-constructed URL per BC-2.7.007 step 2.`

P25-I01 annotation present with correct date. Existing R3.9b text preserved for audit trail. ✓

### K-3: R3.9b Annotation ↔ BC-2.7.007 Step-1 Wording — COHERENT

**BC-2.7.007 step 1** (bc-2 line 726, authoritative source):

> `The download flow does NOT read this field from the step-1 response — it constructs the content URL from the attachment id directly (see step 2). The metadata response is used solely to obtain the canonical \`filename\` for BC-2.7.010 naming.`

The R3.9b annotation accurately describes what BC-2.7.007 says: content URL from id (not `content` field), metadata only for `filename`. The annotation correctly supersedes R3.9b's original claim. **K-3 COHERENT ✓**

**Result**: P25-I01 FULLY APPLIED ✓.

---

## BC-INDEX v6.24→v6.25

**Quote-verified** (BC-INDEX.md frontmatter, lines 5–6):

```yaml
last_updated: 2026-07-17  # P25 adversary fix round: BC-2.7.008 row JSON-mode hint-vs-error policy note added (P25-001); BC-2.7.011 row containment-check `--out` does-not-apply note added (P25-002); spec v1.3.65; BC count unchanged (657); holdout count 100 (unchanged); VP count 35 (unchanged); BC-INDEX v6.25. Previous: P24 adversary fix round: BC-3.9.009 row P24-001 download-exclusion note added; spec v1.3.64; BC-INDEX v6.24
index_version: v6.25
```

`index_version` v6.24→v6.25. `last_updated` includes P25 row updates (BC-2.7.008 + BC-2.7.011) + spec v1.3.65 note. Internally consistent. ✓

**Result**: BC-INDEX v6.25 APPLIED ✓.

---

## spec-changelog [1.3.65]

**Quote-verified** (`spec-changelog.md` entry at line 10):

```
## [1.3.65] - 2026-07-17

### Type: PATCH
```

Entry present; dated 2026-07-17. ✓

**Summary** (line 16): Present — describes P25-001 (hint-vs-error; EC-2.7.008-6 two-part clause; EC-2.7.008-7 human-mode scope; per-file policy point (3); H-003 Call B2 extensions), P25-002 (BC-2.7.011 case (c) does-not-apply reword; PO temp-file verification), P25-I01 (R3.9b retro-annotation). ✓

**Changed Requirements** (lines 20–24): Lists 5 modified files:
- bc-2-issue-read.md (P25-001 + P25-002)
- holdout-scenarios.md (P25-001 H-003 Call B2)
- BC-INDEX.md (P25-001 BC-2.7.008 row; P25-002 BC-2.7.011 row; index_version v6.25)
- prd-delta-576.md (spec_version_after 1.3.65; P25 dispositions section)
- impact-boundary-576.md (P25-I01 R3.9b annotation)

All 5 files modified. ✓

**Impact Assessment count table** (lines 36–44):

```
| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 100 (unchanged) |
| VP count | 35 (unchanged) |
| New BCs | 0 |
| New VPs | 0 |
| New Holdouts | 0 |
| Spec version | 1.3.64→1.3.65 |
```

7-row table present, including "Spec version | 1.3.64→1.3.65" (consistent with r33 INFO-NEW-3 resolved pattern). ✓

**Result**: spec-changelog [1.3.65] APPLIED ✓.

---

## prd-delta-576.md Frontmatter + P25 Section

**Quote-verified** (`prd-delta-576.md` frontmatter, line 8):

```yaml
spec_version_after: 1.3.65
```

`spec_version_after` updated to 1.3.65. ✓

**P25 section heading** (`prd-delta-576.md` line 448):

> `## Adversary Pass 25 Fix Round Finding Dispositions`

P25 section present. Unique — 1 heading at line 448; line 450 is body text referencing "Adversary Pass 25" in the preamble (expected, not a duplicate heading). ✓

**P25 preamble** (line 450):

> `Source: Adversary Pass 25. 2 LOW + 1 INFO findings (first zero-MEDIUM-and-above pass). Spec version bump: 1.3.64 → 1.3.65. No new BCs. Holdouts: 100 (unchanged). VPs: 35 (unchanged).`

Finding counts and version bump correct. ✓

**P25-001 disposition** (line 454): APPLIED — describes full EC-2.7.008-6 two-part clause, EC-2.7.008-7 mode-scoping, per-file policy point (3) scoping, H-003 Call B2 additions, BC-INDEX row update. Claim includes ECHO-BREAKER LIST-B: licensing BC is EC-2.7.008-6 (P25-001). ✓

**P25-002 disposition** (line 455): APPLIED — BC-2.7.011 case (c) pure does-not-apply exclusion. States PO verified temp-file-placement section does NOT reference `canonicalize(out_dir)` for --out path. BC-INDEX row update. ✓

**P25-I01 disposition** (line 456): APPLIED — R3.9b PHASE-DOC-RETRO-ANNOTATION added. ✓

**P25 closing statement** (`prd-delta-576.md` line 458):

> `**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.65. Both guards exit 0.**`

Closing correct: BC 657 / holdout 100 / VP 35 / spec v1.3.65 / both guards exit 0. ✓

**Result**: prd-delta-576.md P25 APPLIED ✓.

---

## GAP-P24-002-001 (r34) — Resolution Verification

**r34 gap**: prd-delta S3 scope row was missing the VP-576-004 allocation note (note had mis-landed in S5 row during P24 round).

**S3 scope row** (`prd-delta-576.md` line 33, relevant addition — quote-verified):

> `**VP-576-004 allocation (P24-002, r34 gap-closure)**: VP-576-004 (curated attachment-object JSON transformation pin) full cross-path test (list BC-2.7.002 + upload BC-3.9.009) lands at S3; S3 depends_on S1 for the shared curated-serialization plumbing (R3.13 earliest-consumer principle; list half home BC-2.7.002 S1; upload half home BC-3.9.009 S3).`

VP-576-004 allocation note now present in S3 scope row with "(P24-002, r34 gap-closure)" annotation. ✓

The spec-changelog [1.3.64] Changed Requirements (line 61 of spec-changelog output) confirms: "`prd-delta-576.md` (MODIFIED): ... S3 scope row VP-576-004 note added (r34 gap-closure: note had mis-landed in S5 row during P24 round; S5 row note retained as accurate context)." ✓

**GAP-P24-002-001 RESOLVED ✓.**

---

## Double-Insertion Sweep

| Marker | Count | Locations | Assessment |
|--------|-------|-----------|------------|
| `## Adversary Pass 25 Fix Round` in `prd-delta-576.md` | 1 | line 448 (heading) | No duplicate section ✓ |
| `1.3.65` in `prd-delta-576.md` | 3 | line 8 (frontmatter), line 450 (P25 preamble), line 458 (P25 closing) | EXPECTED — 3 distinct roles ✓ |
| `[1.3.65]` in `spec-changelog.md` | 1 | line 10 | No duplicate entry ✓ |
| `P25-001` in `bc-2-issue-read.md` | 5 lines | line 19 (frontmatter trace), line 787 (per-file policy), line 796 (EC-2.7.008-6), line 800 (EC-2.7.008-7), line 808 (Trace) | EXPECTED — 5 distinct locations ✓ |
| `P25-002` in `bc-2-issue-read.md` | 2 lines | line 19 (frontmatter trace, shared with P25-001), line 918 (BC-2.7.011 Trace) | EXPECTED — 2 distinct locations ✓ |
| `P25-001` in `holdout-scenarios.md` | 5 lines | lines 2197, 2198, 2203, 2205, 2207 | EXPECTED — 5 distinct roles (2 assertions, Why-hidden, Status, BC-refs) ✓ |
| `P25-I01` in `impact-boundary-576.md` | 1 | line 758 (R3.9b annotation body) | No duplicate annotation ✓ |
| `PHASE-DOC-RETRO-ANNOTATION` in `impact-boundary-576.md` | 8 | lines 161, 177, 189, 454, 467, 726, 758, 789 | 7 are prior-round annotations (P14-004, P14-004, P14-008, R2.2, BC-3.9.012, R9-003, P14-001); 1 is P25-I01 at line 758 — all distinct ✓ |
| `v1.3.65` in `bc-2-issue-read.md` frontmatter | 1 | line 19 | EXPECTED — 1 trace entry ✓ |

**No double-insertions detected.** All marker counts explained by distinct legitimate locations. ✓

---

## ECHO-BREAKER Audit — List A (7 Items)

### Item 1: EC-2.7.008-6 ERROR Clause — "per-file failure warnings ARE emitted in JSON mode"

**Text** (bc-2 line 796): `"per-file failure warnings (\`"warning: failed to download attachment <AID>: <reason>"\`) ARE emitted to stderr in JSON mode — download failures are ERRORS, not hints, and fire unconditionally (consistent with the model-b cache-writer warning convention)"`

**Licensing basis**:
- Model-b cache-writer warning convention: CLAUDE.md documents `write_cmdb_fields_cache` and `write_object_type_attr_cache` as "model-b writers — swallows disk-write errors with `eprintln!`(...)". Download failures (HTTP 403/404/5xx/network errors) are errors in the same class — they must not be suppressed in any output mode. ✓
- No over-claim: "fire unconditionally" is correctly scoped to "failures" not "all stderr." ✓

### Item 2: EC-2.7.008-6 HINT Clause — "Downloaded N of M summary NOT emitted in JSON mode"

**Text** (bc-2 line 796): `"The \`Downloaded N of M\` summary is NOT emitted in JSON mode — it is a HINT, suppressed in JSON mode by this rule."`

**Licensing basis**:
- EC-2.7.001-1 precedent (bc-2 line 562): "No attachments on <KEY>." hint explicitly stated as JSON-suppressed ("JSON mode: ... no stderr, exit 0"). The "Downloaded N of M" summary is the same hint class — a user-facing informational message about batch outcome count, not an error or machine-readable signal. ✓
- The `{"downloaded":[...]}` manifest on stdout fully encodes the N-of-M information for machine consumers; the human-readable summary adds nothing for JSON mode. ✓
- No over-claim: only the summary is suppressed, not per-file warnings. ✓

### Item 3: EC-2.7.008-7 "human mode only" Summary Scope

**Text** (bc-2 line 800): `"**human mode only**: summary prints actual \`N\` of \`M\` where N < M (the \`Downloaded N of M\` summary is not emitted in JSON mode — it is a HINT per EC-2.7.008-6)"`

**Licensing basis**: Same as Item 2 — licensed by EC-2.7.008-6 (just added in P25-001). No circular argument: EC-2.7.008-7 correctly cross-references EC-2.7.008-6 as the authority; EC-2.7.008-6 carries the independent justification. ✓

### Item 4: EC-2.7.008-7 "in both human and JSON modes" Per-File Warnings

**Text** (bc-2 line 800): `"stderr per-file warnings emitted for each failure (in both human and JSON modes — failures are ERRORS, not hints; see EC-2.7.008-6 JSON-mode stderr policy, P25-001)"`

**Licensing basis**: Same as Item 1 — model-b error convention. Cross-reference to EC-2.7.008-6 is accurate. ✓

### Item 5: Per-File Policy Point (3) — "human-mode summary" Scoping

**Text** (bc-2 line 787): `"from the N count in the human-mode summary (the \`Downloaded N of M\` summary is a HINT — not emitted in JSON mode per EC-2.7.008-6 JSON-mode stderr policy, P25-001)"`

**Licensing basis**: Licensed by EC-2.7.008-6 (Item 2). "Excluded from the N count in the human-mode summary" accurately describes what happens in JSON mode: the failed attachment is excluded from the `downloaded` array (JSON channel), and there is no "N count" in JSON mode because the summary is suppressed. ✓

### Item 6: BC-2.7.011 Case (c) Pure Does-Not-Apply Exclusion

**Text** (bc-2 line 905): `"**\`--out <PATH>\` is excluded from this containment check entirely** — the user-supplied path is trusted operator input (BC-2.7.007/BC-2.7.010); neither step 1 (\`canonicalize(out_dir)\`) nor step 2 (\`starts_with\`) of this check applies to \`--out\`-supplied paths"`

**Licensing basis**:
- BC-2.7.007 line 735: "the user-supplied path is NOT sanitized against CWE-22 (trusted input from the operator)." ✓
- BC-2.7.010 bypass: `--out` supplies the complete path; the naming pipeline (BC-2.7.010) does not apply to `--out`-supplied paths. ✓
- The two-step containment check (SEC-576-002) exists to verify that the sanitized filename (from an untrusted Jira API response) does not escape the target directory; `--out` is an operator-supplied path that bypasses the untrusted-filename pipeline entirely. The exclusion is logically correct. ✓
- "Pure does-not-apply": the old wording implied the check ran on `--out` paths; the new wording correctly excludes it. No over-claim — the exclusion is strictly scoped to the two-step CWE-22 containment check, not to pre-flight validity checks (EC-2.7.007-11 remains active; see K-2). ✓

### Item 7: R3.9b Retro-Annotation Content

**Text** (impact-boundary-576.md line 758): `"BC-2.7.007 step 1 constructs the content URL from the attachment id directly and does NOT read the metadata \`content\` field; metadata is used solely to obtain the canonical \`filename\` for BC-2.7.010 naming."`

**Licensing basis**: BC-2.7.007 step 1 (bc-2 line 726): "The download flow does NOT read this field from the step-1 response — it constructs the content URL from the attachment id directly (see step 2). The metadata response is used solely to obtain the canonical `filename` for BC-2.7.010 naming." Annotation is word-for-word accurate against the authoritative source. ✓

**Assessment**: All 7 List-A items grounded in licensing sources. No over-claim on any item. ✓

---

## ECHO-BREAKER Audit — List B (H-003 Call B2 Assertions)

**Assertion 1** (line 2197): "stderr CONTAINS a line matching `warning: failed to download attachment 20021: ...`"
- **Licensing BC**: EC-2.7.008-6 (P25-001) — "per-file failure warnings ARE emitted to stderr in JSON mode — download failures are ERRORS, not hints, and fire unconditionally"
- **Fixture satisfiability**: Call B2 fixture mounts AID 20021 → 500 response → content-GET failure → per-file warning emitted. Fixture provides exactly one failing AID (20021). Assertion is satisfiable. ✓

**Assertion 2** (line 2198): "stderr does NOT contain `Downloaded`"
- **Licensing BC**: EC-2.7.008-6 (P25-001) — "The `Downloaded N of M` summary is NOT emitted in JSON mode — it is a HINT, suppressed in JSON mode by this rule"
- **Fixture satisfiability**: Call B2 runs in JSON mode (`--output json`). The "Downloaded N of M" summary is a human-mode-only hint. No implementation-correct path emits it in JSON mode. Assertion is satisfiable. ✓

**MUST-FAIL bullets**: The three MUST-FAIL bullets (lines 2199–2201) are logical complements of the two positive assertions. They correctly identify implementation defects (wrong inclusion of failed entry; per-file warning suppressed in JSON mode; summary emitted in JSON mode) that would falsify the assertions. Satisfiable as compliance checks. ✓

**Fixture topology** (lines 2176, 2191): Issue `FOO-5`; two attachments: id `20020` → 200 + `AAA` (success); id `20021` → 500 (fail). Exactly **one** AID fails (20021). The fresh `OUT_DIR_B2` isolates from Call B's already-written file to prevent the overwrite-refuse guard from firing on `<sha1-20020>_ok.txt`. Isolation rationale is correct. ✓

**List B VERIFIED**: All Call B2 assertions licensed by EC-2.7.008-6 (P25-001). Fixture fails exactly one AID = 20021. Assertions are satisfiable against fixture mounts. ✓

---

## Keystone Coherence Checks

### K-1: Hint-vs-Error Channel Story — Complete §2.7 Enumeration

Complete classification of every stderr-emitting clause in §2.7:

| Clause | Message | Classification | JSON mode | Note |
|--------|---------|----------------|-----------|------|
| EC-2.7.001-1 | "No attachments on <KEY>." | HINT | SUPPRESSED | Explicit: "JSON mode: ... no stderr, exit 0" (bc-2 line 562) |
| EC-2.7.001-2 | "Showing N of M attachments." | HINT | NOT-SUPPRESSED | Explicit: fires in JSON mode via eprintln! unconditionally (bc-2 line 564); deliberate asymmetry from P19 |
| EC-2.7.008-1 | "No attachments on <KEY>." | HINT | SUPPRESSED | Unified with EC-2.7.001-1 ("same canonical string — unified with EC-2.7.001-1"); inherits JSON-suppressed behavior |
| "Downloaded N of M" summary (line 785) | "Downloaded N of M attachments to <dir>." | HINT | SUPPRESSED | Explicit: EC-2.7.008-6 (P25-001) |
| Per-file failure warnings | "warning: failed to download attachment <AID>: <reason>" | ERROR | NOT-SUPPRESSED | Explicit: EC-2.7.008-6 + EC-2.7.008-7 (P25-001) |
| EC-2.7.008-10 | "No attachments matched the filter on <KEY>." | HINT | AMBIGUOUS | JSON stdout specified (`{"downloaded":[]}`); JSON-mode stderr behavior NOT explicitly stated (see INFO-NEW-6) |
| EC-2.7.009-3 | "No attachments matched the filter on <KEY>." | HINT | AMBIGUOUS | Same as EC-2.7.008-10 (parallel clause, same canonical string); same ambiguity |
| EC-2.7.007-11 and all exit 64/1 error messages | Various error strings | ERROR | NOT-SUPPRESSED | Error paths always emit to stderr regardless of output mode |
| "Downloaded: <path> (<size_human>)." single-id completion hint (line 739) | Completion hint | HINT | SUPPRESSED | EC-2.7.007-7 states "No stderr output in JSON mode" (explicit) |

**Ambiguous clauses**: EC-2.7.008-10 and EC-2.7.009-3 — their JSON-mode stderr behavior is not explicitly stated. Both are hint-class messages (filtered-to-zero informational) parallel to EC-2.7.001-1. The correct behavior (by analogy) is JSON-suppressed, but the clauses do not say so explicitly. This is a pre-existing condition not introduced by P25. Flagged as INFO-NEW-6.

**P25-001 coherence**: P25-001 added explicit hint-vs-error taxonomy for the download batch path (EC-2.7.008-6/7). No contradiction found between any clause's classification after P25. EC-2.7.001-1 (JSON-suppressed) ↔ EC-2.7.001-2 (JSON-not-suppressed) asymmetry from P19 is preserved and internally consistent. **K-1 COHERENT (with INFO-NEW-6 flagged for pre-existing EC-2.7.008-10/EC-2.7.009-3 ambiguity).**

---

### K-2: --out Exclusion Story — BC-2.7.011 Case (c) ↔ EC-2.7.007-11 Non-Contradiction

| Element | Claim | Source | Status |
|---------|-------|--------|--------|
| BC-2.7.011 case (c) | "neither step 1 (canonicalize) nor step 2 (starts_with) of this check applies to `--out`-supplied paths" — "this check" refers specifically to the Defense-in-depth containment check (SEC-576-002 CWE-22) | bc-2 line 905 | COHERENT ✓ |
| BC-2.7.007 trusted-input | "the user-supplied path is NOT sanitized against CWE-22 (trusted input from the operator)" | bc-2 line 735 | COHERENT ✓ |
| BC-2.7.010 bypass | "--out <PATH> override: uses trusted operator-supplied paths and is NOT subject to [device-name note]" (Windows device-name caller note for sanitized filenames, not for trusted paths) | bc-2 line 901 | COHERENT ✓ |
| EC-2.7.007-11 | "--out <PATH> names an existing directory → exit 64; pre-download pre-flight validity check; NOT in the CWE-22 sanitization family" | bc-2 line 765 | COHERENT — NOT EXCLUDED ✓ |

**Confirmation**: BC-2.7.011 case (c) says "neither step 1 (canonicalize(out_dir)) nor step 2 (starts_with) of **this check** applies." The antecedent "this check" is the Defense-in-depth containment check (SEC-576-002) — a CWE-22 sanitization check applied to API-supplied untrusted filenames. EC-2.7.007-11 is a pre-flight validity check (directory-vs-file type check on the user-supplied `--out` path), not a CWE-22 sanitization check. The two families are distinct. No wording in case (c) implies EC-2.7.007-11 is excluded or suppressed. **K-2 COHERENT ✓.**

---

### K-3: R3.9b Annotation ↔ BC-2.7.007 Step-1 Wording

(Verified above in P25-I01 section.)

| Element | Claim | Source |
|---------|-------|--------|
| R3.9b annotation | "step 1 constructs content URL from id directly; metadata `content` field NOT read; metadata used solely for `filename`" | impact-boundary-576.md line 758 |
| BC-2.7.007 step 1 | "The download flow does NOT read this field from the step-1 response — it constructs the content URL from the attachment id directly. The metadata response is used solely to obtain the canonical `filename` for BC-2.7.010 naming." | bc-2 line 726 |

The annotation faithfully reflects the authoritative spec text. **K-3 COHERENT ✓.**

---

## Cross-Reference Validation

### BC Counts

| Source | bc-2 definitional | bc-2 total_bcs | bc-3 definitional | bc-3 total_bcs | Grand Total |
|--------|-------------------|-----------------|-------------------|-----------------|-------------|
| Frontmatter | 64 | 106 | 111 | 140 | 657 |
| CANONICAL-COUNTS.md | 64 | 106 | 111 | 140 | 657 |
| Guard output | verified | — | verified | — | 657 |

P25 added 0 new BCs. PASS ✓

### Holdout Counts

| Source | Count | Status |
|--------|-------|--------|
| `holdout-scenarios.md` frontmatter `total_holdouts` | 100 | PASS ✓ |
| `CANONICAL-COUNTS.md` canonical total | 100 | PASS ✓ |
| `prd-delta-576.md` P25 closing | "Holdout count: 100 (unchanged)" | PASS ✓ |
| `spec-changelog.md` [1.3.65] count table | "Holdout count: 100 (unchanged)" | PASS ✓ |

### VP Counts

| Source | VP count reference | Status |
|--------|-------------------|--------|
| `prd-delta-576.md` P25 closing | "VP count: 35 (unchanged)" | PASS ✓ |
| `BC-INDEX.md` last_updated | "VP count 35 (unchanged)" | PASS ✓ |
| `spec-changelog.md` [1.3.65] count table | "VP count: 35 (unchanged)" | PASS ✓ |

---

## Spec Version Surface Verification

| Artifact | Spec version shown | Status |
|----------|--------------------|--------|
| `spec-changelog.md` | `[1.3.65] - 2026-07-17` entry present | PASS ✓ |
| `bc-2-issue-read.md` frontmatter trace | v1.3.64 entry (line 18) + v1.3.65 entry (line 19) | PASS ✓ (INFO-NEW-4 RESOLVED) |
| `BC-INDEX.md` `last_updated` | "spec v1.3.65" in P25 note | PASS ✓ |
| `prd-delta-576.md` frontmatter `spec_version_after` | `1.3.65` | PASS ✓ |
| `bc-3-issue-write.md` frontmatter trace | Last entry v1.3.64 (P24-001) — P25 did not touch bc-3 | NOTE (INFO-NEW-5 carry-forward; bc-3 not modified by P25) |
| `STATE.md` `current_step` | Stale (carries INFO-8; now stale at v1.3.65) | STALE (INFO-8 worsened) |

---

## INFO Ledger Status

### INFO-1 (carry-forward R21–R35) — CARRY-FORWARD

Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7 in bc-2 (lines 797-799). Not introduced or worsened by P25 (the P25 change added content to EC-2.7.008-6 and EC-2.7.008-7 but did not remove the triple blank lines).

**Status**: CARRY-FORWARD

---

### INFO-2 (carry-forward R21–R35) — CARRY-FORWARD

EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained. Not introduced or worsened by P25.

**Status**: CARRY-FORWARD

---

### INFO-3 (carry-forward R21–R35) — CARRY-FORWARD

BC-2.7.012 "KEY or AID 5xx" combined-scope row. Not introduced or worsened by P25.

**Status**: CARRY-FORWARD

---

### INFO-4 (carry-forward R22–R34) — RESOLVED

H-NEW-ATTACHMENT-003 BC refs footer did not list `BC-2.7.008 EC-2.7.008-6` for Call B2.

**R35 update**: P25-001 updated H-NEW-ATTACHMENT-003 Call B2 BC-refs to include "BC-2.7.008 EC-2.7.008-6 (JSON-mode stderr policy, Call B2, P25-001)" at holdout-scenarios.md line 2207. INFO-4 RESOLVED.

**Status**: RESOLVED ✓

---

### INFO-6 (carry-forward R23–R35) — CARRY-FORWARD

No holdout for collision-skip exit-0 path. Not introduced or worsened by P25.

**Status**: CARRY-FORWARD

---

### INFO-8 (carry-forward R25–R35) — CARRY-FORWARD

`STATE.md` spec version stale. Now stale at v1.3.65 (was stale at v1.3.64 after r34).

**Status**: CARRY-FORWARD

---

### INFO-11 (carry-forward R27–R35) — CARRY-FORWARD

`spec-changelog.md` [1.3.57] and `prd-delta-576.md` P17-002 disposition say "three sites" but four sites were actually modified. Not introduced or worsened by P25.

**Status**: CARRY-FORWARD

---

### INFO-13 (carry-forward R28–R35) — CARRY-FORWARD

`error-taxonomy.md` row 95 issue-GET 403 sub-variant lacks BC-2.7.006 citation. Not introduced or worsened by P25.

**Status**: CARRY-FORWARD

---

### INFO-15 (carry-forward R29–R35) — CARRY-FORWARD

`impact-boundary-576.md` BC-3.9.004 row has INCONCLUSIVE annotation. Not introduced or worsened by P25.

**Status**: CARRY-FORWARD

---

### INFO-NEW-4 (NEW R34) — RESOLVED

`bc-2-issue-read.md` frontmatter trace was missing v1.3.63 and v1.3.64 entries.

**R35 update**: The r34 gap-closure added v1.3.64 entry (line 18: "v1.3.64 — P24 adversary fix round..."); P25 added v1.3.65 entry (line 19: "v1.3.65 — P25 adversary fix round..."). The v1.3.63 entry is confirmed NOT owed (per spec-changelog [1.3.64] explicit note: "v1.3.63 entry is NOT owed — P23 did not touch bc-2-issue-read.md"). bc-2 frontmatter trace is now current.

**Status**: RESOLVED ✓

---

### INFO-NEW-5 (NEW R34) — CARRY-FORWARD

BC-3.9.009 Trace field (bc-3) not updated with P24-001 citation. Consistent with P19-001 non-citation precedent; BC-INDEX carries the authoritative amendment record. P25 did not touch bc-3-issue-write.md.

**Status**: CARRY-FORWARD

---

### INFO-NEW-6 (NEW R35)

**EC-2.7.008-10 and EC-2.7.009-3 JSON-mode stderr behavior not explicitly stated.**

EC-2.7.008-10 (bc-2 line 806): "exit 0; stderr: `'No attachments matched the filter on <KEY>.'`; JSON mode: stdout `{"downloaded":[]}` (empty array)." The JSON-mode stdout is specified but JSON-mode stderr behavior is not explicitly stated. By analogy with EC-2.7.001-1 (which explicitly states "JSON mode: ... no stderr, exit 0"), this message should be JSON-suppressed — it is a hint-class pre-flight informational message, not an error. However, the clause does not say this.

EC-2.7.009-3 (bc-2 line 831): same canonical string, same ambiguity.

**Context**: This is a pre-existing condition not introduced by P25. P25-001 clarified the "Downloaded N of M" summary and per-file failure warnings but did not address the EC-2.7.008-10/EC-2.7.009-3 "No attachments matched the filter" message. Surfaced by the K-1 full-§2.7 hint-vs-error enumeration.

**Severity**: INFO. Non-blocking. The most likely correct interpretation (JSON-suppressed, hint-class) is unambiguous from context; the risk is implementer confusion, not behavioral contradiction.

**Status**: NEW INFO-NEW-6

---

## Findings

### Critical

None.

### Major

None.

### GAPs

None.

### Resolved This Round

- **GAP-P24-002-001** (r34 LOW): prd-delta S3 scope row VP-576-004 allocation note missing — RESOLVED. S3 row now reads "**VP-576-004 allocation (P24-002, r34 gap-closure)**: VP-576-004 (curated attachment-object JSON transformation pin) full cross-path test (list BC-2.7.002 + upload BC-3.9.009) lands at S3; S3 depends_on S1 for the shared curated-serialization plumbing (R3.13 earliest-consumer principle)." prd-delta P24-002 disposition updated to reflect the r34 gap-closure. spec-changelog [1.3.64] Changed Requirements updated to include the S3 row fix.
- **INFO-4** (NEW R22, carry R22–R34): H-NEW-ATTACHMENT-003 BC refs missing EC-2.7.008-6 for Call B2 — RESOLVED. BC-refs now includes "BC-2.7.008 EC-2.7.008-6 (JSON-mode stderr policy, Call B2, P25-001)."
- **INFO-NEW-4** (NEW R34): bc-2 frontmatter trace missing v1.3.63+v1.3.64 — RESOLVED. v1.3.64 entry added (r34 gap-closure); v1.3.65 entry added (P25); v1.3.63 confirmed NOT owed.

### Minor (INFO)

- **INFO-1** (carry R21–R35): Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7.
- **INFO-2** (carry R21–R35): EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained.
- **INFO-3** (carry R21–R35): BC-2.7.012 "KEY or AID 5xx" combined-scope row.
- **INFO-6** (carry R23–R35): No holdout for collision-skip exit-0 path.
- **INFO-8** (carry R25–R35): STATE.md spec version stale (should be v1.3.65).
- **INFO-11** (carry R27–R35): P17-002 "three sites" undercount in spec-changelog/prd-delta.
- **INFO-13** (carry R28–R35): error-taxonomy row 95 issue-GET 403 lacks BC-2.7.006 citation.
- **INFO-15** (carry R29–R35): impact-boundary BC-3.9.004 INCONCLUSIVE annotation.
- **INFO-NEW-5** (NEW R34): BC-3.9.009 Trace field not updated with P24-001 citation (consistent with P19-001 non-citation precedent; BC-INDEX is the authoritative amendment record).
- **INFO-NEW-6** (NEW R35): EC-2.7.008-10 and EC-2.7.009-3 "No attachments matched the filter on <KEY>." — JSON-mode stderr behavior not explicitly stated (pre-existing; hint-class; parallel to EC-2.7.001-1 which explicitly says "no stderr" in JSON mode; surfaced by K-1 full enumeration).

---

## Validation Gate Result

**CONSISTENT**

P25-001 (LOW) correctly and fully applied: EC-2.7.008-6 extended with the two-part hint-vs-error clause — (a) per-file failure warnings ARE emitted to stderr in JSON mode (ERRORS, unconditional, model-b convention) and (b) "Downloaded N of M" summary is NOT emitted in JSON mode (HINT, suppressed); EC-2.7.008-7 mode-scoped with "human mode only" qualifier for the summary; per-file policy paragraph point (3) scoped to "human-mode summary"; BC-2.7.008 Trace updated with P25-001 citation; BC-INDEX BC-2.7.008 row updated; H-NEW-ATTACHMENT-003 Call B2 extended with 2 positive assertions + 3 MUST-FAIL bullets, Why-hidden/Status/BC-refs all updated; bc-2 frontmatter trace v1.3.65 entry added.

P25-002 (LOW) correctly and fully applied: BC-2.7.011 step-1 case (c) reworded to pure does-not-apply exclusion for `--out <PATH>` — neither step 1 (canonicalize) nor step 2 (starts_with) of the SEC-576-002 containment check applies to user-supplied paths (trusted operator input per BC-2.7.007/BC-2.7.010); BC-2.7.011 Trace updated with P25-002 citation; BC-INDEX BC-2.7.011 row updated; PO temp-file-placement spot-check VERIFIED — Write-to-temp section (bc-2 line 741) does not reference canonicalize(out_dir) for --out paths.

P25-I01 (INFO) correctly applied: R3.9b in impact-boundary-576.md annotated with [PHASE-DOC-RETRO-ANNOTATION (P25-I01, 2026-07-17)] — content URL constructed from attachment id directly, metadata `content` field not read, metadata used solely for `filename` (BC-2.7.010 naming); annotation accurately reflects BC-2.7.007 step-1 wording (bc-2 line 726 verbatim corroboration).

ECHO-BREAKER: All 7 List-A items grounded in licensing sources — (1) ERROR clause licensed by model-b cache-writer convention; (2) HINT clause licensed by EC-2.7.001-1 JSON-suppressed precedent; (3-4) EC-2.7.008-7 additions licensed by EC-2.7.008-6; (5) per-file policy point (3) scoping licensed by same; (6) BC-2.7.011 case (c) licensed by BC-2.7.007 trusted-input + BC-2.7.010 bypass; (7) R3.9b annotation licensed by BC-2.7.007 step-1 verbatim. No over-claim on any item. List-B: H-003 Call B2 assertions licensed by EC-2.7.008-6; fixture fails exactly one AID = 20021; all assertions satisfiable. Double-insertion sweep clean. K-1 (hint-vs-error enumeration): coherent; one new INFO for pre-existing EC-2.7.008-10/EC-2.7.009-3 ambiguity. K-2 (--out exclusion): BC-2.7.011 case (c) does not exclude EC-2.7.007-11 (directory pre-flight check is not in the CWE-22 sanitization family); COHERENT. K-3 (R3.9b ↔ BC-2.7.007 step-1): COHERENT. Counts 657/100/35 verified by both guards (exit 0). Spec version 1.3.65 consistent across all primary surfaces. Three prior-round items resolved: GAP-P24-002-001 (r34), INFO-4 (r22-r34), INFO-NEW-4 (r34).

---

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 37 |
| **Passed** | 37 |
| **Resolved** | 3 (GAP-P24-002-001 r34; INFO-4 r22-r34; INFO-NEW-4 r34) |
| **Failed (GAPs)** | 0 |
| **Warnings (INFO)** | 8 carry-forward + 1 new (INFO-1..3 carry; INFO-6 carry; INFO-8 carry; INFO-11, INFO-13, INFO-15 carry; INFO-NEW-5 carry; INFO-NEW-6 new) |
| **Overall Status** | consistent |

Round 35 is a PATCH-level validation confirming the 2 LOW + 1 INFO P25 adversary-pass fix round (first zero-MEDIUM pass in the SOH-ATTACHMENTS-1 F2 cycle): (1) P25-001 (LOW) — EC-2.7.008-6 extended with two-part hint-vs-error taxonomy for batch-download JSON mode; EC-2.7.008-7 and per-file policy point (3) mode-scoped; H-003 Call B2 extended with 3 new assertions; FULLY APPLIED. (2) P25-002 (LOW) — BC-2.7.011 case (c) reworded to pure does-not-apply exclusion for `--out` paths; PO temp-file-placement spot-check confirmed; FULLY APPLIED. (3) P25-I01 (INFO) — R3.9b retro-annotated; FULLY APPLIED. Counts 657/100/35 unchanged. Spec version advances to 1.3.65. Three prior-round items resolved (GAP-P24-002-001, INFO-4, INFO-NEW-4). One new INFO (INFO-NEW-6: EC-2.7.008-10/EC-2.7.009-3 JSON-mode stderr ambiguity, pre-existing).

---

## Appendix: Validation Methodology

This report was produced by a fresh-context consistency validator (cv-576-r35) with structural reference to r34 report only.

1. **Independent artifact read**: All 7 input artifacts read fresh. Findings formed independently from artifact text.
2. **Quote-based closure**: Every P25 priority check verified by verbatim quotation from the authoritative artifact (RE-READ at claim time — not carried from memory).
3. **PO SPOT-CHECK**: BC-2.7.007 Write-to-temp section (bc-2 line 741) read to verify PO's claim that `canonicalize(out_dir)` is not referenced for `--out` paths. Confirmed: section describes only `tmp_<random>` naming and "same directory as the final path" placement with no canonicalize call for `--out`.
4. **ECHO-BREAKER List A (7 items)**: All 7 new P25 behavioral sentences traced to licensing sources; no over-claim identified.
5. **ECHO-BREAKER List B**: H-003 Call B2 assertions verified — licensing BC (EC-2.7.008-6, P25-001) correct; fixture topology confirms exactly one AID = 20021 fails; assertions satisfiable.
6. **Keystone checks**: K-1 (full §2.7 hint-vs-error enumeration), K-2 (--out exclusion non-contradiction with EC-2.7.007-11), K-3 (R3.9b ↔ BC-2.7.007 step-1 wording) all verified against quoted text.
7. **Double-insertion sweep**: Marker occurrence counts verified for P25-001/P25-002/P25-I01 citations, [1.3.65] entry, "Adversary Pass 25" section, PHASE-DOC-RETRO-ANNOTATION occurrences. All counts explained by distinct legitimate locations; 8 PHASE-DOC-RETRO-ANNOTATION lines in impact-boundary confirmed as 7 prior-pass + 1 new P25-I01.
8. **INFO ledger re-verification**: GAP-P24-002-001 (r34) verified RESOLVED by fresh read of prd-delta S3 row (line 33: "VP-576-004 allocation (P24-002, r34 gap-closure)" present). INFO-4 verified RESOLVED by fresh read of holdout BC-refs (line 2207: EC-2.7.008-6 entry present). INFO-NEW-4 verified RESOLVED by fresh read of bc-2 frontmatter (lines 18-19: v1.3.64 + v1.3.65 entries present; v1.3.63 confirmed NOT owed).
9. **Guard scripts**: Both `check-spec-counts.sh` and `check-bc-cumulative-counts.sh` executed and verified "OK".
10. **Count sweep**: BC (657), holdout (100), VP (35) verified across BC-INDEX frontmatter, bc-2/bc-3 frontmatter, prd-delta-576.md P25 closing, spec-changelog [1.3.65] count table, and holdout-scenarios.md frontmatter.
