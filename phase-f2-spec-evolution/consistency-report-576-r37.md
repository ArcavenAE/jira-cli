---
document_type: consistency-report
round: 37
spec_version: 1.3.67
date: 2026-07-17
validator: cv-576-r37 (fresh context, no prior round visibility)
verdict: CONSISTENT
bc_count: 657
holdout_count: 100
vp_count: 35
priority_checks: P27-001 (MEDIUM, filename=RAW ruling: EC-2.7.007-7 clause; EC-2.7.008-6 clause; H-003 B2 manifest "ok.txt" + discriminating assertion + MUST-FAIL bullet + Why-hidden/Status; bc-3 shape table rows 3219-3220; BC-INDEX BC-2.7.007/BC-2.7.008 rows); P27-002 (H-007 overlong-name description corrected 255=214+41; length-cap assertion added ≤214 bytes); P27-003 (collision-skip=NON-ERROR hint, suppressed JSON mode; EC-2.7.008-6 sentence; BC-2.7.008 Trace; BC-INDEX BC-2.7.008 row); BC-INDEX v6.26→v6.27; spec-changelog [1.3.67]; prd-delta spec_version_after 1.3.67 + P27 section; bc-2 frontmatter v1.3.67; holdout frontmatter v1.5.4; counts 657/100/35; double-insertion sweep; ECHO-BREAKER List A (4 items) + List B (H-003 B2 discriminating assertion, H-007 length-cap); K-1..K-4 keystones
level: ops
version: "1.0"
status: consistent
producer: cv-576-r37
timestamp: 2026-07-17T00:00:00
phase: 2
inputs:
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/spec-changelog.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
input-hash: "89ff120"
traces_to: ".factory/specs/prd/BC-INDEX.md"
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 37 (post-P27 remediation)

**Spec version**: 1.3.67 | **BCs**: 657 | **Holdouts**: 100 | **VPs**: 35 | **Verdict**: CONSISTENT

---

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) — SOH-ATTACHMENTS-1 F2 |
| **Generated** | 2026-07-17T00:00:00 |
| **Generator** | cv-576-r37 (fresh-context consistency validator, round 37) |
| **Artifacts Scanned** | 6 (bc-2-issue-read.md, bc-3-issue-write.md, holdout-scenarios.md, BC-INDEX.md, spec-changelog.md, prd-delta-576.md) |
| **Focus** | Post-P27 adversary-pass remediation verification — spec v1.3.66 → v1.3.67; 1 MEDIUM + 2 LOW + 1 INFO (no action) findings; double-insertion sweep; ECHO-BREAKER List A (4 items) + List B (H-003 B2 discriminating assertion, H-007 length-cap); K-1..K-4 keystones |
| **Prior round** | consistency-report-576-r36.md (CONSISTENT; INFO-13 resolved — error-taxonomy row 95 issue-GET sub-variant citation re-pointed to BC-2.7.012) |

---

## Summary Table

| # | Check | Result |
|---|-------|--------|
| P27-001 | EC-2.7.007-7 filename semantics clause present (bc-2 line 761) | pass |
| P27-001 | EC-2.7.007-7: "`downloaded[].filename` is the RAW Jira `attachment.filename` (pre-sanitization)" | pass |
| P27-001 | EC-2.7.007-7: "on-disk basename (post-sanitization per BC-2.7.011) is recoverable from `path`" | pass |
| P27-001 | EC-2.7.007-7: "Deliberate pairing: `filename` = what Jira calls it; `path` = where it landed." | pass |
| P27-001 | EC-2.7.008-6 filename semantics clause present (bc-2 line 798) | pass |
| P27-001 | EC-2.7.008-6: batch adds "post-SHA-1-prefix for batch paths per BC-2.7.010" to semantics clause | pass |
| P27-001 | BC-2.7.007 Trace: P27-001 citation present (bc-2 line 773) | pass |
| P27-001 | BC-2.7.008 Trace: P27-001 citation present (bc-2 line 810) | pass |
| P27-001 | H-003 B2 Expected B2: manifest `"filename":"ok.txt"` (NOT SHA-1-prefixed form) | pass |
| P27-001 | H-003 B2: discriminating filename-vs-path assertion present (P27-001 citation; licensing BC: EC-2.7.008-6) | pass |
| P27-001 | H-003 B2: `jq '.downloaded[0].filename'` = `"ok.txt"` asserted | pass |
| P27-001 | H-003 B2: `basename(jq '.downloaded[0].path')` = `<sha1("20020")>_ok.txt` asserted | pass |
| P27-001 | H-003 B2: MUST-FAIL bullet for SHA-1-prefixed filename present | pass |
| P27-001 | H-003 B2 Why-hidden: P27-001 pairing explanation present | pass |
| P27-001 | H-003 B2 Status: P27-001 pin present ("EC-2.7.008-6 `filename` semantics (P27-001)") | pass |
| P27-001 | bc-3 shape table row 3219 (--id): `filename` = RAW Jira name note with "(P27-001)" citation | pass |
| P27-001 | bc-3 shape table row 3220 (--all/--newest): `filename` = RAW Jira name note with "(P27-001)" citation | pass |
| P27-001 | BC-INDEX BC-2.7.007 row: filename-raw/path-on-disk note present (P27-001) | pass |
| P27-001 | BC-INDEX BC-2.7.008 row: filename-raw note present (P27-001) | pass |
| P27-001 | bc-2 frontmatter trace v1.3.67 entry present (line 21) | pass |
| P27-002 | H-007 fixture 60003 description: "exceeds the 214-byte sanitizer cap — BC-2.7.011 step 5" | pass |
| P27-002 | H-007 fixture 60003: "truncated to 214, then 41-byte SHA-1 prefix = 255-byte on-disk name at NAME_MAX" | pass |
| P27-002 | H-007 Expected: length-cap assertion added (P27-002 citation; licensing BC: BC-2.7.011 step 5) | pass |
| P27-002 | H-007 assertion form: `len(basename(on_disk_path).split('_', 1)[1].encode('utf-8')) <= 214` | pass |
| P27-002 | H-007 Status: P27-002 citation present | pass |
| P27-002 | holdout frontmatter version v1.5.3→v1.5.4 | pass |
| P27-002 | holdout frontmatter trace: P27-001 + P27-002 entry present | pass |
| P27-003 | EC-2.7.008-6: Collision-skip paragraph present (bc-2 line 798; label "Collision-skip warnings (P27-003)") | pass |
| P27-003 | EC-2.7.008-6: "collision-skip warnings are NON-ERROR hints" | pass |
| P27-003 | EC-2.7.008-6: "suppressed in `--output json` mode" | pass |
| P27-003 | EC-2.7.008-6: "manifest's omission of the skipped file IS the machine signal" | pass |
| P27-003 | EC-2.7.008-6: "consistent with EC-2.7.008-10 filtered-to-zero precedent" | pass |
| P27-003 | BC-2.7.008 Trace: P27-003 citation present (bc-2 line 810) | pass |
| P27-003 | BC-INDEX BC-2.7.008 row: P27-003 collision-skip hint classification note present | pass |
| BC-INDEX v6.27 | index_version: v6.27 | pass |
| BC-INDEX v6.27 | last_updated: P27 adversary fix round note present | pass |
| spec-changelog [1.3.67] | Entry `## [1.3.67] - 2026-07-17` present | pass |
| spec-changelog [1.3.67] | Summary present: 1 MEDIUM + 2 LOW + 1 INFO finding descriptions | pass |
| spec-changelog [1.3.67] | Changed Requirements: 5 files listed (bc-2, holdout, bc-3, BC-INDEX, prd-delta) | pass |
| spec-changelog [1.3.67] | Impact Assessment artifact table rows: bc-2, holdout, bc-3, BC-INDEX, prd-delta | pass |
| spec-changelog [1.3.67] | Count table: BC 657 / Holdout 100 / VP 35 / New BCs 0 / New VPs 0 / New Holdouts 0 | pass |
| spec-changelog [1.3.67] | Count table: "Spec version \| 1.3.66→1.3.67" row present | pass |
| prd-delta | `spec_version_after: 1.3.67` (frontmatter line 8) | pass |
| prd-delta | P27 section heading: `## Adversary Pass 27 Fix Round Finding Dispositions` present (line 477) | pass |
| prd-delta | P27 preamble: "1 MEDIUM / 2 LOW / 1 INFO findings. Spec version bump: 1.3.66 → 1.3.67" | pass |
| prd-delta | P27-001 row: MEDIUM \| bc-2, holdout, bc-3, BC-INDEX \| APPLIED | pass |
| prd-delta | P27-002 row: LOW \| holdout \| APPLIED | pass |
| prd-delta | P27-003 row: LOW \| bc-2, BC-INDEX \| APPLIED | pass |
| prd-delta | P27-INFO-1 row: INFO \| — \| NO ACTION | pass |
| prd-delta | P27 closing: "BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.67. Both guards exit 0." | pass |
| Counts 657/100/35 | Consistent across all surfaces; both guards exit 0 | pass |
| Double-insertion sweep | No duplicate findings — all marker counts explained by distinct legitimate locations | pass |
| ECHO-BREAKER List A (4 items) | All 4 P27 behavioral sentences grounded in licensing sources; no over-claim | pass |
| ECHO-BREAKER List B | H-003 B2 discriminating assertion satisfiable; H-007 length-cap assertion satisfiable | pass |
| K-1 (filename semantics) | BC-2.7.002 authority → EC-2.7.007-7/EC-2.7.008-6 → H-003 B2 → bc-3 table → BC-2.7.010 batch naming: ONE coherent story | pass |
| K-2 (hint taxonomy) | Collision-skip classified (P27-003); set mostly closed; one pre-existing unclassified emission (degenerate-name fallback warning, INFO-NEW-7) | info |
| K-3 (H-007 arithmetic) | 251+4=255 bytes → 214-byte cap → 41-byte prefix = 255 on-disk; assertion + VP-576-001 non-double-claiming | pass |
| K-4 (BC-INDEX v6.27 rows ↔ bodies) | BC-2.7.007 and BC-2.7.008 INDEX rows reflect P27-001/P27-003; bodies verified | pass |
| Guard: check-spec-counts.sh | OK: all spec counts verified | pass |
| Guard: check-bc-cumulative-counts.sh | OK: all cumulative BC counts verified (657 total across 8 files) | pass |

**All P27 items verified fully applied. Two new INFO findings (INFO-NEW-7: degenerate-name fallback warning unclassified for JSON mode; INFO-NEW-8: bc-3 frontmatter trace missing v1.3.67 entry). No new CRITICAL, MAJOR, or behavioral GAP findings. Keystones K-1..K-4 all coherent. Both guards exit 0. Verdict: CONSISTENT.**

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

## P27-001 — `downloaded[].filename` Semantics Clause (MEDIUM)

### EC-2.7.007-7 Filename Semantics Clause (bc-2 line 761) — Quote-Verified

**Clause text** (verbatim, within EC-2.7.007-7 at bc-2-issue-read.md line 761):

> `**\`filename\` semantics (P27-001)**: \`downloaded[].filename\` is the RAW Jira \`attachment.filename\` (pre-sanitization); the on-disk basename (post-sanitization per BC-2.7.011) is recoverable from \`path\` (basename of \`path\` = on-disk name). Deliberate pairing: \`filename\` = what Jira calls it; \`path\` = where it landed.`

Three attributes verified:
- RAW Jira name (pre-sanitization) ✓
- On-disk basename recoverable from `path` (basename of path = on-disk name) ✓
- Deliberate pairing documented ✓
- P27-001 citation inline ✓

### EC-2.7.008-6 Filename Semantics Clause (bc-2 line 798) — Quote-Verified

**Clause text** (verbatim, final sentence of EC-2.7.008-6 at bc-2-issue-read.md line 798):

> `**\`filename\` semantics (P27-001)**: \`downloaded[].filename\` is the RAW Jira \`attachment.filename\` (pre-sanitization); the on-disk basename (post-sanitization per BC-2.7.011, post-SHA-1-prefix for batch paths per BC-2.7.010) is recoverable from \`path\`. Deliberate pairing: \`filename\` = what Jira calls it; \`path\` = where it landed.`

Batch-path additional clause "post-SHA-1-prefix for batch paths per BC-2.7.010" present. ✓ Consistent with the single-id clause but adds batch-specific detail. ✓

### BC-2.7.007 and BC-2.7.008 Traces (bc-2 lines 773 and 810) — Quote-Verified

**BC-2.7.007 Trace** (verbatim excerpt, line 773):

> `P27-001 (EC-2.7.007-7 \`filename\` semantics clause added: RAW Jira name pre-sanitization; on-disk basename recoverable from \`path\`)`

P27-001 citation present with accurate description. ✓

**BC-2.7.008 Trace** (verbatim excerpt, line 810):

> `P27-001 (EC-2.7.008-6 \`filename\` semantics clause added: RAW Jira name pre-sanitization; on-disk basename recoverable from \`path\`); P27-003 (EC-2.7.008-6 collision-skip hint-vs-error classification: collision-skip warnings are NON-ERROR hints, suppressed in JSON mode)`

Both P27-001 and P27-003 citations present on this line. ✓

### H-003 B2 Expected B2 — Quote-Verified

**Manifest line** (holdout-scenarios.md, within H-NEW-ATTACHMENT-003 Call B2 Expected B2):

> `Exit code = 1; stdout \`{"downloaded":[{"filename":"ok.txt","id":"20020","path":"<path>","size":3}]}\`; the \`fail.txt\` entry (\`"id":"20021"\`) is absent from \`downloaded\`; the JSON manifest is emitted despite exit 1 (exit-1 + valid-stdout combination per EC-2.7.008-7). Output routes through \`output::render_json\` (#526).`

The manifest shows `"filename":"ok.txt"` — raw Jira name, NOT the SHA-1-prefixed form. ✓ The `fail.txt` entry (id 20021) is absent from the manifest. ✓

**Discriminating assertion** (verbatim, holdout line 2198):

> `**Discriminating filename-vs-path assertion (P27-001, licensing BC: EC-2.7.008-6)**: \`jq '.downloaded[0].filename'\` = \`"ok.txt"\` (RAW Jira attachment filename, pre-sanitization, pre-SHA-1-prefix per EC-2.7.008-6 \`filename\` semantics); \`basename(jq '.downloaded[0].path')\` = \`<sha1("20020")>_ok.txt\` (on-disk name, post-SHA-1-prefix per BC-2.7.010 batch naming). These two values MUST differ. An implementation that sets \`filename\` to the SHA-1-prefixed form \`<sha1("20020")>_ok.txt\` MUST FAIL this assertion.`

Discriminating assertion present. ✓ `filename` = "ok.txt" asserted. ✓ `basename(path)` = `<sha1("20020")>_ok.txt` asserted. ✓ MUST-FAIL bullet present. ✓ Licensing BC cited (EC-2.7.008-6). ✓

**Why-hidden** (holdout line 2206, relevant excerpt):

> `Call B2 also pins the \`filename\`-vs-\`path\` semantics (P27-001): \`filename\` MUST be the RAW Jira name \`ok.txt\` (pre-sanitization, pre-SHA-1-prefix); \`path\` basename MUST be the SHA-1-prefixed on-disk form — these two values must differ (an implementation that conflates them by writing the on-disk name into \`filename\` would be invisible without this discriminating assertion).`

Why-hidden updated with P27-001 pairing explanation. ✓

**Status** (holdout line 2208, relevant excerpt):

> `and EC-2.7.008-6 \`filename\` semantics (P27-001: \`downloaded[].filename\` is RAW Jira name; on-disk basename in \`path\` carries the SHA-1-prefixed form).`

P27-001 pin present in Status. ✓

### bc-3 JSON Output Shape Contracts Table (rows 3219-3220) — Quote-Verified

**Row 3219** (verbatim, bc-3-issue-write.md):

> `| \`attachment download --id <AID>\` | \`{"downloaded":[{"filename":"<name>","id":"<AID>","path":"<written path>","size":N}]}\` | 1-element \`downloaded\` array; inner keys alphabetical (filename<id<path<size); \`filename\` = RAW Jira name (pre-sanitization); \`path\` = on-disk location (post-sanitization; basename(path) = on-disk name); BC-2.7.007 EC-2.7.007-7 (P27-001) |`

`filename` = RAW Jira name note present. ✓ `path` = on-disk location note present. ✓ P27-001 citation present. ✓

**Row 3220** (verbatim):

> `| \`attachment download --all\` / \`--newest N\` | \`{"downloaded":[{"filename":"<name>","id":"<AID>","path":"<written path>","size":N},…]}\` | N-element \`downloaded\` array; same inner shape; \`filename\` = RAW Jira name (pre-sanitization, pre-SHA-1-prefix); \`path\` basename = SHA-1-prefixed on-disk name (BC-2.7.010); BC-2.7.008/BC-2.7.009 EC-2.7.008-6 (P27-001) |`

Batch note adds "pre-SHA-1-prefix" and cross-references BC-2.7.010. ✓ P27-001 citation. ✓

### BC-INDEX BC-2.7.007 Row (line 226) — Quote-Verified

**Relevant P27-001 note** (verbatim excerpt from BC-INDEX.md line 226):

> `**\`downloaded[].filename\` = RAW Jira name (pre-sanitization); on-disk basename recoverable from \`path\` (P27-001)**`

P27-001 note added. ✓ Citation form accurate. ✓

### BC-INDEX BC-2.7.008 Row (line 227) — Quote-Verified

**Relevant notes** (verbatim excerpt from BC-INDEX.md line 227):

> `**\`downloaded[].filename\` = RAW Jira name (pre-sanitization, pre-SHA-1-prefix); on-disk basename recoverable from \`path\` (P27-001)**; **collision-skip warnings are NON-ERROR hints, suppressed in JSON mode (P27-003)**`

Both P27-001 and P27-003 notes present. ✓

### bc-2 Frontmatter Trace v1.3.67 (line 21) — Quote-Verified

**bc-2 frontmatter trace entry** (verbatim):

> `v1.3.67 — P27 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): EC-2.7.007-7 \`filename\` semantics clause added — \`downloaded[].filename\` is RAW Jira name (pre-sanitization); on-disk basename recoverable from \`path\`; deliberate pairing documented (P27-001); EC-2.7.008-6 same \`filename\` semantics clause added; collision-skip warnings classified as NON-ERROR hints, suppressed in JSON mode (P27-003); BC-2.7.007 and BC-2.7.008 Trace fields updated.`

Entry present; dated 2026-07-17; covers P27-001 and P27-003 bc-2 changes. ✓

**Result**: P27-001 FULLY APPLIED ✓.

---

## P27-002 — H-007 Overlong-Name Fixture Description and Length-Cap Assertion (LOW)

### H-007 Fixture 60003 Description (holdout line 2390) — Quote-Verified

**Corrected description** (verbatim, holdout-scenarios.md line 2390):

> `\`{"id":"60003","filename":"aaa…a.txt"}\` — overlong name: 251 \`a\` characters + \`.txt\` = 255 bytes total (exceeds the 214-byte sanitizer cap — BC-2.7.011 step 5; truncated to 214, then 41-byte SHA-1 prefix = 255-byte on-disk name at NAME_MAX); tests the length-truncation step of the sanitization pipeline.`

Old description "at the length-cap boundary" is **absent**. ✓ Corrected description present: "exceeds the 214-byte sanitizer cap — BC-2.7.011 step 5". ✓ Arithmetic: truncated to 214, then 41-byte SHA-1 prefix = 255-byte on-disk name at NAME_MAX. ✓

### H-007 Expected Length-Cap Assertion (holdout line 2403) — Quote-Verified

**New assertion** (verbatim, holdout-scenarios.md line 2403):

> `**Length-cap assertion (P27-002, licensing BC: BC-2.7.011 step 5)**: For the overlong \`60003\` entry, the on-disk basename after the SHA-1 prefix underscore (i.e., the \`<sanitized-basename>\` portion of \`<sha1("60003")>_<sanitized-basename>\`) is ≤ 214 bytes (pins BC-2.7.011 step 5: the 214-byte cap is applied before the SHA-1 prefix is prepended, ensuring 41 + 214 = 255 bytes total ≤ NAME_MAX). An implementation that truncates to 255 bytes total without reserving 41 bytes for the prefix (leaving only 214 bytes for the sanitized part) would violate BC-2.7.010 batch naming. Assert: \`len(basename(on_disk_path).split('_', 1)[1].encode('utf-8')) <= 214\`.`

Length-cap assertion present. ✓ P27-002 citation inline. ✓ Licensing BC cited (BC-2.7.011 step 5). ✓ Assert expression: `len(basename(on_disk_path).split('_', 1)[1].encode('utf-8')) <= 214`. ✓ Implementation failure mode documented. ✓

### H-007 Status (holdout line 2407) — Quote-Verified

**Status relevant excerpt** (verbatim):

> `P27-002: setup description of 255-byte fixture corrected to explain the 214-byte sanitizer cap + 41-byte SHA-1 prefix = 255-byte NAME_MAX composition; missing length-cap assertion added (on-disk basename after SHA-1 prefix underscore ≤ 214 bytes).`

P27-002 citation with accurate description. ✓

### holdout Frontmatter v1.5.3→v1.5.4 — Quote-Verified

**Frontmatter** (verbatim, holdout-scenarios.md lines 4, 7):

> `total_holdouts: 100`
> `version: "1.5.4"`

`version` is `"1.5.4"` (was `"1.5.3"`). ✓ `total_holdouts: 100` unchanged. ✓

**Trace entry** (holdout frontmatter line 24, verbatim):

> `- SOH-ATTACHMENTS-1 adversary pass-27 (2026-07-17, P27): H-NEW-ATTACHMENT-003 Call B2 \`filename\` corrected to RAW Jira name \`ok.txt\` (pre-sanitization, pre-SHA-1-prefix); discriminating \`filename\`-vs-\`path\` assertion added (P27-001); H-NEW-ATTACHMENT-007 overlong-name fixture description corrected (255 bytes = exceeds 214-byte sanitizer cap + 41-byte SHA-1 prefix; was "at the length-cap boundary"); missing length-cap assertion added (on-disk basename after SHA-1 prefix ≤ 214 bytes; P27-002); holdout count unchanged (100)`

Trace entry present; covers both P27-001 and P27-002. ✓

**Result**: P27-002 FULLY APPLIED ✓.

---

## P27-003 — Collision-Skip Warning JSON-Mode Classification (LOW)

### EC-2.7.008-6 Collision-Skip Paragraph (bc-2 line 798) — Quote-Verified

**New paragraph** (verbatim, within EC-2.7.008-6 at bc-2-issue-read.md line 798):

> `**Collision-skip warnings (P27-003)**: collision-skip warnings (e.g., \`"Skipping <filename>: file already exists. Use --force to overwrite."\`) are NON-ERROR hints — suppressed in \`--output json\` mode (same class as the \`"Downloaded N of M"\` summary and \`--filter\` exclusions which are silent; the manifest's omission of the skipped file IS the machine signal, consistent with EC-2.7.008-10 filtered-to-zero precedent). Human mode unchanged.`

Classification: NON-ERROR hints. ✓ JSON-mode: suppressed. ✓ "manifest's omission of the skipped file IS the machine signal" rationale. ✓ Human mode unchanged. ✓ Precedent: EC-2.7.008-10 filtered-to-zero. ✓ P27-003 citation. ✓

**Ordering within EC-2.7.008-6**: The collision-skip paragraph follows the P25-001 JSON-mode hint-vs-error policy paragraph and precedes the `path` non-determinism note. This placement is appropriate — it extends the existing hint-vs-error taxonomy established by P25-001. ✓

### BC-INDEX BC-2.7.008 Row — P27-003 Note (line 227) — Quote-Verified

From BC-INDEX.md line 227 (relevant P27-003 addition):

> `**collision-skip warnings are NON-ERROR hints, suppressed in JSON mode (P27-003)**`

P27-003 note added. ✓ Citation form accurate. ✓

**Result**: P27-003 FULLY APPLIED ✓.

---

## BC-INDEX v6.26→v6.27

**Quote-verified** (BC-INDEX.md frontmatter, lines 5–6):

```yaml
last_updated: 2026-07-17  # P27 adversary fix round: BC-2.7.007 row P27-001 filename-raw/path-on-disk note added; BC-2.7.008 row P27-001 filename-raw note + P27-003 collision-skip hints suppressed added; spec v1.3.67; BC count unchanged (657); holdout count 100 (unchanged); VP count 35 (unchanged); BC-INDEX v6.27. Previous: P26 adversary fix round: ...
index_version: v6.27
```

`index_version` v6.26→v6.27. ✓ `last_updated` records all three P27 row updates (BC-2.7.007 P27-001; BC-2.7.008 P27-001 + P27-003) plus spec v1.3.67 note. ✓

**Result**: BC-INDEX v6.27 APPLIED ✓.

---

## spec-changelog [1.3.67]

**Quote-verified** (`spec-changelog.md` entry at line 10):

```
## [1.3.67] - 2026-07-17

### Type: PATCH
```

Entry present; dated 2026-07-17. ✓

**Summary** (line 16): Present — describes all four findings: P27-001 (MEDIUM; filename=RAW ruling; EC-2.7.007-7 + EC-2.7.008-6 clauses; H-003 B2 manifest corrected; discriminating assertion; bc-3 table rows; BC-INDEX rows), P27-002 (LOW; H-007 description corrected; 214+41=255; length-cap assertion ≤214 bytes), P27-003 (LOW; collision-skip=NON-ERROR hint; suppressed JSON mode; manifest-omission signal), P27-INFO-1 (INFO; no action; deliberate asymmetry). ✓

**Changed Requirements** (lines 20–24): Lists 5 modified files:
- bc-2-issue-read.md (P27-001 + P27-003; frontmatter trace v1.3.67 added)
- holdout-scenarios.md (P27-001 + P27-002; frontmatter v1.5.3→v1.5.4)
- bc-3-issue-write.md (P27-001 table rows)
- BC-INDEX.md (P27-001 + P27-003 + index_version v6.27)
- prd-delta-576.md (spec_version_after 1.3.67; P27 dispositions)

All 5 files listed. ✓

**Impact Assessment count table** (lines 44–50):

```
| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 100 (unchanged) |
| VP count | 35 (unchanged) |
| New BCs | 0 |
| New VPs | 0 |
| New Holdouts | 0 |
| Spec version | 1.3.66→1.3.67 |
```

7-row count table present with "Spec version \| 1.3.66→1.3.67" row. ✓

**Result**: spec-changelog [1.3.67] APPLIED ✓.

---

## prd-delta-576.md Frontmatter + P27 Section

**Frontmatter** (line 8):

```yaml
spec_version_after: 1.3.67
```

`spec_version_after` updated to 1.3.67. ✓

**P27 section heading** (prd-delta-576.md line 477):

> `## Adversary Pass 27 Fix Round Finding Dispositions`

P27 section present. ✓ Count of "Adversary Pass 27" occurrences = 2 (line 477 heading + line 479 "Source: Adversary Pass 27...") — EXPECTED, 2 distinct roles. ✓

**P27 preamble** (line 479, verbatim):

> `Source: Adversary Pass 27. 1 MEDIUM / 2 LOW / 1 INFO findings. Spec version bump: 1.3.66 → 1.3.67. No new BCs. Holdouts: 100 (unchanged). VPs: 35 (unchanged).`

Counts and version bump correct. ✓

**Finding rows** (lines 483–486):
- P27-001: MEDIUM | bc-2, holdout, bc-3, BC-INDEX | APPLIED | ORCHESTRATOR RULING option (b) | full change enumeration present ✓
- P27-002: LOW | holdout | APPLIED | description corrected + assertion added ✓
- P27-003: LOW | bc-2, BC-INDEX | APPLIED | ORCHESTRATOR RULING collision-skip=hint ✓
- P27-INFO-1: INFO | — | NO ACTION | deliberate asymmetry ✓

**P27 closing statement** (line 488, verbatim):

> `**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.67. Both guards exit 0.**`

Closing correct: BC 657 / holdout 100 / VP 35 / spec v1.3.67 / both guards exit 0. ✓

**Result**: prd-delta-576.md P27 APPLIED ✓.

---

## Double-Insertion Sweep

| Marker | Count | Locations | Assessment |
|--------|-------|-----------|------------|
| `## Adversary Pass 27 Fix Round` in `prd-delta-576.md` | 2 | line 477 (heading) + line 479 ("Source: Adversary Pass 27") | EXPECTED — 2 distinct roles ✓ |
| `[1.3.67]` in `spec-changelog.md` | 1 | line 10 | No duplicate entry ✓ |
| `P27-001` in `bc-2-issue-read.md` | 5 lines | line 21 (frontmatter trace), line 761 (EC-2.7.007-7 clause), line 773 (BC-2.7.007 Trace), line 798 (EC-2.7.008-6 clause + P27-001), line 810 (BC-2.7.008 Trace) | EXPECTED — 5 distinct locations ✓ |
| `P27-003` in `bc-2-issue-read.md` | 2 lines | line 798 (EC-2.7.008-6 collision-skip paragraph), line 810 (BC-2.7.008 Trace) | EXPECTED — 2 distinct locations ✓ |
| `P27-001` in `holdout-scenarios.md` | 3 lines | line 2198 (discriminating assertion), line 2206 (Why-hidden), line 2208 (Status) | EXPECTED — 3 distinct locations ✓ |
| `P27-002` in `holdout-scenarios.md` | 3 lines | line 2403 (length-cap assertion), line 2407 (Status), line 2409 (BC refs footer) | EXPECTED — 3 distinct locations ✓ |
| `P27-001` in `bc-3-issue-write.md` | 2 lines | line 3219 (--id row), line 3220 (--all/--newest row) | EXPECTED — 2 distinct table rows ✓ |
| `v1.3.67` in `bc-2-issue-read.md` frontmatter | 1 | line 21 | EXPECTED — 1 trace entry ✓ |
| Discriminating assertion in H-003 B2 | 1 | holdout line 2198 | No duplicate assertion ✓ |
| Length-cap assertion in H-007 Expected | 1 | holdout line 2403 | No duplicate assertion ✓ |

**No double-insertions detected.** All marker counts explained by distinct legitimate locations. ✓

---

## ECHO-BREAKER Audit — List A (4 Items)

### Item 1: EC-2.7.007-7 — "`downloaded[].filename` is the RAW Jira `attachment.filename` (pre-sanitization)"

**Text** (bc-2 line 761): `downloaded[].filename` is the RAW Jira `attachment.filename` (pre-sanitization); on-disk basename recoverable from `path`. Deliberate pairing documented.

**Licensing basis**:
- BC-2.7.002 authority clause (bc-2 line 615): "the curated form defined in this BC is the single canonical attachment-object JSON shape for `jr` attachment **list** and **upload**... **`download` is excluded**: the download JSON shape is the distinct `{"downloaded":[...]}` manifest defined in BC-2.7.007 (EC-2.7.007-7)." — BC-2.7.007/EC-2.7.007-7 is the sole authority for download manifest shape, not BC-2.7.002. ✓
- EC-2.7.007-7 is the download manifest authority; it can define `filename` semantics independently of the list/upload convention. ✓
- Practical rationale: programmatic consumers need the Jira-canonical filename for correlation with the Jira API; the on-disk name (post-sanitization) is recoverable from `path`. The deliberate pairing is an explicit design choice, not an over-claim. ✓
- No conflict with BC-2.7.011 (which governs the sanitization pipeline, not the JSON manifest shape). ✓

### Item 2: EC-2.7.008-6 — Batch Clause Adds "post-SHA-1-prefix for batch paths per BC-2.7.010"

**Text** (bc-2 line 798): RAW Jira name; on-disk basename "post-sanitization per BC-2.7.011, post-SHA-1-prefix for batch paths per BC-2.7.010" recoverable from `path`.

**Licensing basis**:
- BC-2.7.010 batch naming (bc-2 line 838): "Batch: `<sha1-of-id>_<sanitized-basename>`" — unconditional; every batch-path file gets the SHA-1 prefix. ✓
- The clause accurately distinguishes single-id (no SHA-1 prefix, post-sanitization only) from batch (post-sanitization + post-SHA-1-prefix). ✓
- No over-claim: "recoverable from `path`" is accurate because `path` contains the SHA-1-prefixed on-disk name. ✓

### Item 3: H-003 B2 Discriminating Assertion — `"filename":"ok.txt"` ≠ `basename(path)=<sha1("20020")>_ok.txt`

**Text** (holdout line 2198): `jq '.downloaded[0].filename'` = `"ok.txt"` AND `basename(path)` = `<sha1("20020")>_ok.txt`; these two values MUST differ.

**Licensing basis**:
- Fixture: id=20020, Jira filename="ok.txt", content → 200 + "AAA". ✓
- EC-2.7.008-6 RAW semantics clause (P27-001): `downloaded[].filename` = RAW Jira `attachment.filename` = "ok.txt". ✓
- BC-2.7.010 batch naming: on-disk name = `<sha1("20020")>_ok.txt`. ✓
- BC-2.7.011 sanitization: "ok.txt" is a valid basename (not a path-traversal, not a device name, not overlong); sanitized form = "ok.txt" (unchanged); no degenerate fallback triggered. ✓
- Internal consistency: `"ok.txt"` ≠ `<sha1("20020")>_ok.txt` — the 40-hex + underscore prefix guarantees they differ for any non-empty raw name. ✓
- No over-claim: the assertion is satisfiable against the fixture (id 20020, raw name "ok.txt", SHA-1 prefix deterministically computable). ✓

### Item 4 (P27-003): Collision-Skip = NON-ERROR Hint, Suppressed in JSON Mode

**Text** (bc-2 line 798): "collision-skip warnings are NON-ERROR hints — suppressed in `--output json` mode (same class as the `Downloaded N of M` summary and `--filter` exclusions which are silent; the manifest's omission of the skipped file IS the machine signal, consistent with EC-2.7.008-10 filtered-to-zero precedent)."

**Licensing basis**:
- Parallel classification: `Downloaded N of M` summary is already classified as HINT suppressed in JSON mode (P25-001, EC-2.7.008-6). ✓
- `--filter` exclusions are silently absent from the manifest (EC-2.7.008-6: "files skipped due to collision or `--filter` are NOT in the array"). ✓
- EC-2.7.008-10 filtered-to-zero precedent (bc-2 line 808): "the `'No attachments matched the filter'` message is a HINT — suppressed in JSON mode (same class as EC-2.7.001-1 zero-attachment hint; the empty `downloaded` array is self-describing)". ✓
- The "manifest's omission IS the machine signal" reasoning is licensed by the same principle: a skipped file absent from `downloaded[]` unambiguously signals the skip. ✓
- No over-claim: "Human mode unchanged" — the warning still fires in human mode, consistent with BC-2.7.008 existing prose ("the colliding file is skipped with a per-file stderr warning"). ✓

**Assessment**: All 4 List-A items grounded in licensing sources. No over-claim on any item. ✓

---

## ECHO-BREAKER Audit — List B

### Item 1: H-003 B2 Discriminating Assertion — Fixture Satisfiability

**Assertion** (holdout line 2198): `"filename":"ok.txt"` AND `basename(path)=<sha1("20020")>_ok.txt`; these two values MUST differ.

**Fixture topology**: id=20020, Jira filename="ok.txt" → content GET 200 + "AAA". File written successfully to `OUT_DIR_B2`.

**Satisfiability check**:
- `downloaded[0].filename` = `"ok.txt"` per P27-001 RAW-name semantics. ✓
- On-disk name = `<sha1("20020")>_ok.txt` per BC-2.7.010 batch naming (unconditional SHA-1 prefix). ✓
- `basename(path)` = `<sha1("20020")>_ok.txt`. ✓
- `"ok.txt"` ≠ `<sha1("20020")>_ok.txt` — the SHA-1 prefix (40 hex + underscore = 41 bytes) ensures they differ for any valid basename. ✓
- Discriminating assertion SATISFIABLE. ✓

**Internal consistency check** (K-1 sub-check): the H-003 B2 fixture uses id=20020, Jira filename="ok.txt". The prd-delta P27-001 disposition confirms: "Sweep confirmed: no other Group-19 manifest assertions carry sha1-prefixed `filename` values; H-007 and other scenarios reference sha1 forms only in filesystem paths (on-disk names), not in JSON manifest `filename` fields." This sweep claim is consistent with what I observe: H-003 B2 `"filename":"ok.txt"` (raw name in manifest), not `<sha1("20020")>_ok.txt`. ✓

### Item 2: H-007 Length-Cap Assertion — Satisfiability

**Assertion** (holdout line 2403): on-disk basename after SHA-1 prefix underscore ≤ 214 bytes; `len(basename(on_disk_path).split('_', 1)[1].encode('utf-8')) <= 214`.

**Fixture**: id=60003, Jira filename = 251 `a` + `.txt` = 255 bytes input.

**Satisfiability check**:
- BC-2.7.011 step 5 applies 214-byte cap → truncated to 214 bytes (removes 41 bytes of input). Resulting sanitized basename: 210 `a` + `.txt` = 214 bytes. ✓
- BC-2.7.010 batch naming: on-disk = `<sha1("60003")>_` + `aaa...a.txt` (214 bytes) = 41 + 214 = 255 bytes total. ✓
- `basename(on_disk_path)` = `<sha1("60003")>_aaa...a.txt` (255 bytes). ✓
- `split('_', 1)[1]` = `aaa...a.txt` (214 bytes). ✓
- `len(214-byte-string.encode('utf-8'))` = 214 (pure ASCII) ≤ 214. ✓
- Assertion SATISFIABLE. ✓

**Non-double-claiming check (K-3 sub-check)**: VP-576-001 (bc-2 line 918) pins `sanitize_attachment_filename` unit contract: "(2) `Some(name)` length in bytes is ≤ 214". H-007 assertion pins the end-to-end on-disk behavior: "basename after SHA-1 prefix underscore ≤ 214 bytes". VP-576-001 verifies the function itself (unit); H-007 verifies the full path from Jira fixture → sanitize → SHA-1-prefix → on-disk (integration). These are complementary, not contradictory. Neither double-claims the other's scope. ✓

**List B VERIFIED**: Both assertions satisfiable and internally consistent. ✓

---

## Keystone Coherence Checks

### K-1: Filename Semantics — ONE Coherent Story

The P27-001 filename semantics ruling creates a 5-surface story. All surfaces must tell the same story: `filename` = RAW Jira name; on-disk name = post-sanitization (single-id) or post-sanitization + post-SHA-1-prefix (batch); recoverable from `path`.

| Element | Claim | Source | Status |
|---------|-------|--------|--------|
| BC-2.7.002 authority clause | "download is excluded; download uses the distinct `{"downloaded":[...]}` manifest per BC-2.7.007 EC-2.7.007-7" — BC-2.7.007 is the authority for download manifest shape | bc-2 line 615 | COHERENT ✓ |
| EC-2.7.007-7 (single-id) | "`downloaded[].filename` is the RAW Jira `attachment.filename` (pre-sanitization); on-disk basename (post-sanitization per BC-2.7.011) is recoverable from `path`" | bc-2 line 761 (P27-001) | COHERENT ✓ |
| EC-2.7.008-6 (batch) | Same as EC-2.7.007-7 with addition: "post-SHA-1-prefix for batch paths per BC-2.7.010" | bc-2 line 798 (P27-001) | COHERENT ✓ |
| H-003 B2 manifest | `"filename":"ok.txt"` (id=20020) + discriminating assertion `filename` ≠ `basename(path)` | holdout line 2198 (P27-001) | COHERENT ✓ |
| bc-3 shape table row 3219 | "filename = RAW Jira name (pre-sanitization); path = on-disk location" | bc-3 line 3219 (P27-001) | COHERENT ✓ |
| bc-3 shape table row 3220 | "filename = RAW Jira name (pre-sanitization, pre-SHA-1-prefix); path basename = SHA-1-prefixed on-disk name (BC-2.7.010)" | bc-3 line 3220 (P27-001) | COHERENT ✓ |
| BC-2.7.010 batch naming | "Batch: `<sha1-of-id>_<sanitized-basename>`" — the on-disk name for batch paths | bc-2 line 838 | COHERENT ✓ |

**K-1 COHERENT ✓** — one consistent story across all 7 surfaces: `filename` = what Jira calls it (RAW); `path` = where it landed (post-sanitization / post-SHA-1-prefix); these two intentionally differ in batch mode.

### K-2: Hint-vs-Error Taxonomy — Completeness After P27-003

Re-enumeration of all §2.7 stderr/channel emissions and their JSON-mode classifications:

| Emission | Channel class | JSON-mode behavior | Authority |
|----------|---------------|-------------------|-----------|
| Per-file failure warnings (`"warning: failed to download attachment <AID>: <reason>"`) | ERROR | Emitted unconditionally (errors are not hints) | EC-2.7.008-6 P25-001 |
| `"Downloaded N of M attachments to <dir>."` summary | HINT | Suppressed | EC-2.7.008-6 P25-001 |
| `"No attachments on <KEY>."` (zero-attachment) | HINT | Suppressed (empty array is self-describing) | EC-2.7.008-1, EC-2.7.001-1 |
| `"No attachments matched the filter on <KEY>."` (filtered-to-zero) | HINT | Suppressed (empty `downloaded` array is self-describing) | EC-2.7.008-10, EC-2.7.009-3 |
| `"Skipping <filename>: file already exists..."` (collision-skip) | NON-ERROR HINT | Suppressed (manifest omission IS the machine signal) | EC-2.7.008-6 P27-003 |
| `"Showing N of M attachments."` (filter-count, attachment list) | HINT | NOT suppressed (filtered array has no indication of total; deliberate asymmetry) | EC-2.7.001-2 P19-002 |
| Single-id completion hint: `"Downloaded: <path> (<size_human>)."` | HINT (profile 3) | Suppressed ("No stderr output in JSON mode" per EC-2.7.007-7) | EC-2.7.007-7 "No stderr output in JSON mode" |
| Degenerate-name fallback: `"warning: using id as filename for attachment <AID>..."` | "informational note" | **UNCLASSIFIED** for JSON mode | BC-2.7.011 caller contract / BC-2.7.010 R3.10 |

**Assessment**: The 6-class taxonomy (per-file failures = errors; summary + zero-attachment + filtered-to-zero + collision-skip + single-id completion = hints suppressed; filter-count = hint not suppressed) is now correct and the primary emissions form a closed set. However, the degenerate-name fallback warning (BC-2.7.011 caller contract / BC-2.7.010 R3.10) is described as an "informational note" but its JSON-mode behavior is not classified in any EC. This is a pre-existing condition not introduced by P27. The claim of ZERO remaining unclassified emissions cannot be confirmed in full. See **INFO-NEW-7** below.

**K-2 MOSTLY-CLOSED ✓ with INFO-NEW-7**.

### K-3: H-007 Corrected Description ↔ BC-2.7.011 Step 5 ↔ Length-Cap Assertion ↔ VP-576-001

| Element | Claim | Source | Status |
|---------|-------|--------|--------|
| H-007 fixture 60003 description | "251 `a` characters + `.txt` = 255 bytes total (exceeds the 214-byte sanitizer cap — BC-2.7.011 step 5; truncated to 214, then 41-byte SHA-1 prefix = 255-byte on-disk name at NAME_MAX)" | holdout line 2390 (P27-002) | COHERENT ✓ |
| BC-2.7.011 step 5 length cap | "truncate to at most 214 bytes on a valid UTF-8 character boundary... Rationale for 214 bytes: batch paths prepend a 41-byte SHA-1 prefix (`<40 hex chars>_`); 214 + 41 = 255 = POSIX/Windows NTFS filename component limit" | bc-2 line 896 | COHERENT ✓ |
| H-007 length-cap assertion | "on-disk basename after SHA-1 prefix underscore ≤ 214 bytes; assert `len(basename(...).split('_', 1)[1].encode('utf-8')) <= 214`" | holdout line 2403 (P27-002) | COHERENT ✓ |
| VP-576-001 unit pin | "`Some(name)` length in bytes is ≤ 214" (sanitize_attachment_filename property test) | bc-2 line 918 | COHERENT (non-double-claiming: unit scope vs integration scope) ✓ |

Arithmetic consistency: 251 + 4 (`".txt"`) = 255 bytes input → 214-byte cap applied (removes 41 bytes) → 41-byte SHA-1 prefix prepended → 255-byte on-disk name = NAME_MAX. ✓

Old description "at the length-cap boundary" was imprecise: 255 bytes is the on-disk NAME_MAX boundary (final form including SHA-1 prefix), but the sanitizer cap is 214 bytes (the pre-prefix truncation point). The corrected description accurately characterizes the two distinct limits (214-byte sanitizer cap + 41-byte prefix = 255-byte NAME_MAX). ✓

**K-3 COHERENT ✓**.

### K-4: BC-INDEX v6.27 Rows ↔ Bodies

| BC-INDEX Row | P27 Note | Body Location | Status |
|-------------|----------|---------------|--------|
| BC-2.7.007 (line 226) | "`downloaded[].filename` = RAW Jira name (pre-sanitization); on-disk basename recoverable from `path` (P27-001)" | EC-2.7.007-7 clause (bc-2 line 761) | COHERENT ✓ |
| BC-2.7.008 (line 227) | "`downloaded[].filename` = RAW Jira name (pre-sanitization, pre-SHA-1-prefix); on-disk basename recoverable from `path` (P27-001)"; "collision-skip warnings are NON-ERROR hints, suppressed in JSON mode (P27-003)" | EC-2.7.008-6 filename clause + collision-skip paragraph (bc-2 line 798) | COHERENT ✓ |

**K-4 COHERENT ✓**.

---

## 1. L2 to L3 Requirement Coverage

> **N/A for this document type.** This is a PATCH-level spec-evolution consistency validation (spec v1.3.66→v1.3.67), not a full pipeline L2→L3 coverage check. L2 CAP→BC traceability was established in the original SOH-ATTACHMENTS-1 F2 pipeline pass and is not re-audited per-patch. Covered by the governing BC-INDEX and bc-2/bc-3 bodies verified in this report.

## 2. L3 to L4 Verification Property Coverage

> **N/A for this document type.** PATCH validation does not re-audit the BC→VP coverage established in the original pipeline pass. P27 findings added 0 new BCs and 0 new VPs; VP count 35 unchanged (verified by both guards and prd-delta closing statement).

## 3. Dependency Acyclicity

> **N/A for this document type.** No new stories were introduced in this PATCH round. Dependency topology is unchanged since the original pipeline pass.

## 4. Architecture Alignment

> **N/A for this document type.** This validation confirms spec-artifact behavioral consistency, not architecture→story module mapping. No new implementation artifacts were introduced; architecture components are unchanged.

## 5. Acceptance Criteria Quality

> **N/A for this document type.** No new stories or ACs were added in this PATCH round. P27-001/P27-002/P27-003 findings modified existing EC clauses and holdout scenario assertions only.

## 6. Story Sizing

> **N/A for this document type.** No story points were estimated in this PATCH round. Not applicable to spec-evolution artifact validation.

## 7. Priority Consistency

> **N/A for this document type.** P27 findings are classified MEDIUM/LOW/INFO per the adversary taxonomy, not story priority. No priority-order dependency changes.

## 8. L1 to L2 to L3 to L4 Chain Completeness

> **N/A for this document type.** Full L1→L4 chain completeness was validated in the original SOH-ATTACHMENTS-1 pipeline pass. This PATCH round modifies three existing L3 EC clauses and two holdout scenario bodies; it does not introduce new chain links or break existing ones. All P27-modified clauses (EC-2.7.007-7, EC-2.7.008-6, H-003 B2, H-007) trace back to their governing BCs (BC-2.7.007, BC-2.7.008, BC-2.7.010, BC-2.7.011).

## 9. AC Completeness Coverage

> **N/A for this document type.** AC completeness was established in the original pipeline pass. This PATCH round adds two new test-pinning discriminating assertions (H-003 B2 filename-vs-path; H-007 length-cap) that strengthen coverage, not reduce it. Net effect: coverage unchanged or improved.

## 10. ASM/R Traceability

> **N/A for this document type.** No new assumptions or risks were introduced or closed in this PATCH round. ASM/R register is unchanged.

---

## Cross-Reference Validation

### BC Counts

| Source | bc-2 definitional | bc-2 total_bcs | bc-3 definitional | bc-3 total_bcs | Grand Total |
|--------|-------------------|-----------------|-------------------|-----------------|-------------|
| Frontmatter | 64 | 106 | 111 | 140 | 657 |
| CANONICAL-COUNTS.md | 64 | 106 | 111 | 140 | 657 |
| Guard output | verified | — | verified | — | 657 |

P27 added 0 new BCs. PASS ✓

### Holdout Counts

| Source | Count | Status |
|--------|-------|--------|
| `holdout-scenarios.md` frontmatter `total_holdouts` | 100 | PASS ✓ |
| `prd-delta-576.md` P27 closing | "Holdout count: 100 (unchanged)" | PASS ✓ |
| `spec-changelog.md` [1.3.67] count table | "Holdout count: 100 (unchanged)" | PASS ✓ |

### VP Counts

| Source | VP count reference | Status |
|--------|-------------------|--------|
| `prd-delta-576.md` P27 closing | "VP count: 35 (unchanged)" | PASS ✓ |
| `BC-INDEX.md` last_updated | "VP count 35 (unchanged)" | PASS ✓ |
| `spec-changelog.md` [1.3.67] count table | "VP count: 35 (unchanged)" | PASS ✓ |

---

## Spec Version Surface Verification

| Artifact | Spec version shown | Status |
|----------|--------------------|--------|
| `spec-changelog.md` | `[1.3.67] - 2026-07-17` entry present | PASS ✓ |
| `bc-2-issue-read.md` frontmatter trace | v1.3.66 entry (line 20) + v1.3.67 entry (line 21) | PASS ✓ |
| `bc-3-issue-write.md` frontmatter trace | v1.3.66 entry (line 99) — no v1.3.67 entry | INFO-NEW-8 (see below) |
| `BC-INDEX.md` `last_updated` | "spec v1.3.67" in P27 note | PASS ✓ |
| `prd-delta-576.md` frontmatter `spec_version_after` | `1.3.67` | PASS ✓ |
| `STATE.md` `current_step` | Stale (carries INFO-8; now stale at v1.3.67) | STALE (INFO-8 worsened) |

---

## Spec vs Implementation Drift

This section covers drift between the spec version recorded in each artifact and the expected current spec version (1.3.67 after P27 remediation).

| Artifact | Spec Version | Implementation State | Drift Detected | Notes |
|----------|-------------|---------------------|---------------|-------|
| `bc-2-issue-read.md` frontmatter | v1.3.67 trace entry (line 21) | current | no | P27 trace entry present |
| `bc-3-issue-write.md` frontmatter | v1.3.66 last trace entry (line 99) | outdated | yes | Body updated by P27-001 (rows 3219-3220); trace entry missing — INFO-NEW-8 |
| `BC-INDEX.md` `index_version` | v6.27 | current | no | P27 update recorded in `last_updated` |
| `holdout-scenarios.md` frontmatter | v1.5.4 | current | no | Bumped from v1.5.3 by P27-002 |
| `spec-changelog.md` | [1.3.67] entry present | current | no | Entry dated 2026-07-17 |
| `prd-delta-576.md` `spec_version_after` | 1.3.67 | current | no | P27 dispositions section present |
| `STATE.md` | stale — does not reflect v1.3.67 | outdated | yes | INFO-8 (carry-forward R25–R37); pre-existing condition |

**Summary**: 2 drift items detected — bc-3 frontmatter trace missing v1.3.67 entry (INFO-NEW-8; behavioral spec correctly updated) and STATE.md stale spec version (INFO-8; pre-existing). Neither is a behavioral gap.

---

## INFO Ledger Status

### INFO-1 (carry-forward R21–R37) — CARRY-FORWARD

Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7 in bc-2. Not introduced or worsened by P27.

**Status**: CARRY-FORWARD

---

### INFO-2 (carry-forward R21–R37) — CARRY-FORWARD

EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained. Not introduced or worsened by P27.

**Status**: CARRY-FORWARD

---

### INFO-3 (carry-forward R21–R37) — CARRY-FORWARD

BC-2.7.012 "KEY or AID 5xx" combined-scope row. Not introduced or worsened by P27.

**Status**: CARRY-FORWARD

---

### INFO-6 (carry-forward R23–R37) — CARRY-FORWARD

No holdout for collision-skip exit-0 path. P27-003 classified the warning as a hint but did not add a holdout scenario for the collision-skip path itself. Pre-existing condition not worsened.

**Status**: CARRY-FORWARD

---

### INFO-8 (carry-forward R25–R37) — CARRY-FORWARD

`STATE.md` spec version stale. Now stale at v1.3.67 (was stale at v1.3.66 after r36).

**Status**: CARRY-FORWARD

---

### INFO-11 (carry-forward R27–R37) — CARRY-FORWARD

`spec-changelog.md` [1.3.57] and `prd-delta-576.md` P17-002 disposition say "three sites" but four sites were actually modified. Not introduced or worsened by P27.

**Status**: CARRY-FORWARD

---

### INFO-15 (carry-forward R29–R37) — CARRY-FORWARD

`impact-boundary-576.md` BC-3.9.004 row has INCONCLUSIVE annotation. Not introduced or worsened by P27.

**Status**: CARRY-FORWARD

---

### INFO-NEW-5 (carry-forward R34–R37) — CARRY-FORWARD

BC-3.9.009 Trace field not updated with P24-001 citation (consistent with P19-001 non-citation precedent; BC-INDEX carries the authoritative amendment record). Not introduced or worsened by P27.

**Status**: CARRY-FORWARD

---

### INFO-NEW-6 (carry-forward R35–R37) — CARRY-FORWARD

EC-2.7.008-10 and EC-2.7.009-3 "No attachments matched the filter on `<KEY>`." — JSON-mode stderr behavior. These clauses now explicitly state "JSON-mode stderr: the `'No attachments matched the filter'` message is a HINT — suppressed in JSON mode" within their respective EC bodies. However INFO-NEW-6 was raised because the explicit suppression language was added mid-round and the INFO was about the pre-P25 ambiguity period. P27 did not change these clauses. The suppression is now unambiguous per BC-2.7.008-10 and EC-2.7.009-3 bodies.

**Status**: CARRY-FORWARD (suppression is now explicit in EC bodies; INFO-NEW-6 carried pending formal resolution)

---

### INFO-NEW-7 (NEW R37) — NEW

**Finding**: The degenerate-name fallback warning ("warning: using id as filename for attachment `<AID>` — original name `'<raw>'` could not be sanitized.") described in BC-2.7.011 caller contract / BC-2.7.010 R3.10 is not classified for JSON-mode behavior anywhere in the §2.7 channel taxonomy. The K-2 closed-set claim ("failures=errors-emitted; summary/zero-attachment/filtered-to-zero/collision-skip=hints-suppressed; filter-count=hint-NOT-suppressed") does not include this emission. Its JSON-mode behavior (hint-suppressed vs error-emitted) is unspecified.

**Scope**: Pre-existing condition not introduced by P27. The degenerate-name fallback fires only when `sanitize_attachment_filename` returns `None` (an edge case requiring all path components to be empty/invalid AND every fallback rule to be exhausted). The omission was not raised by adversary passes 1–27.

**Severity**: INFO (behavioral specification is internally consistent; this is a taxonomy completeness gap for an extreme edge case; K-2 cannot confirm a fully closed set but the primary emissions are correctly classified).

**Status**: NEW R37

---

### INFO-NEW-8 (NEW R37) — NEW

**Finding**: `bc-3-issue-write.md` frontmatter trace does not contain a v1.3.67 entry, despite P27-001 modifying bc-3's JSON Output Shape Contracts table (lines 3219–3220). The spec-changelog [1.3.67] lists bc-3 as MODIFIED, and the body content is correctly updated. The bc-3 frontmatter's last trace entry is v1.3.66 (P26-004, line 99). By the established convention — P24 added a v1.3.64 trace to bc-3 for its body change; P26 added a v1.3.66 trace to bc-3 for its body change — P27 should have added a v1.3.67 trace entry to bc-3.

**Scope**: The P27 fix-round claims in spec-changelog [1.3.67] state for bc-3: "JSON Output Shape Contracts table download rows filename/path notes added" — this change was applied (verified at lines 3219-3220). The claim does NOT explicitly state "frontmatter trace v1.3.67 entry added" (contrast with bc-2's spec-changelog entry which explicitly says "frontmatter trace v1.3.67 entry added"). The omission is therefore either an intentional discretionary decision (minor table-row change not warranting a trace entry) or a gap.

**Severity**: INFO (behavioral spec correctly updated; trace record absent from bc-3 frontmatter only; spec-changelog records the change at the changelog level).

**Status**: NEW R37

---

## Findings

### Critical

None.

### Major

None.

### GAPs

None.

### Minor (INFO)

- **INFO-1** (carry R21–R37): Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7.
- **INFO-2** (carry R21–R37): EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained.
- **INFO-3** (carry R21–R37): BC-2.7.012 "KEY or AID 5xx" combined-scope row.
- **INFO-6** (carry R23–R37): No holdout for collision-skip exit-0 path (P27-003 classified warning but no new holdout).
- **INFO-8** (carry R25–R37): STATE.md spec version stale (should be v1.3.67).
- **INFO-11** (carry R27–R37): P17-002 "three sites" undercount in spec-changelog/prd-delta.
- **INFO-15** (carry R29–R37): impact-boundary BC-3.9.004 INCONCLUSIVE annotation.
- **INFO-NEW-5** (carry R34–R37): BC-3.9.009 Trace field not updated with P24-001 citation.
- **INFO-NEW-6** (carry R35–R37): EC-2.7.008-10 / EC-2.7.009-3 JSON-mode suppression now explicit in EC bodies; INFO carried pending formal resolution.
- **INFO-NEW-7** (NEW R37): Degenerate-name fallback warning ("warning: using id as filename...") unclassified for JSON-mode behavior in §2.7 taxonomy; K-2 cannot confirm ZERO remaining unclassified emissions.
- **INFO-NEW-8** (NEW R37): bc-3-issue-write.md frontmatter trace missing v1.3.67 entry; P27-001 changed bc-3 body (lines 3219-3220) but no trace entry added (pre-existing pattern precedent: P24 and P26 both added trace entries to bc-3; P27 did not).

---

## Validation Gate Result

**CONSISTENT**

P27-001 (MEDIUM) correctly and fully applied: EC-2.7.007-7 gained an explicit `filename` semantics clause (RAW Jira `attachment.filename`, pre-sanitization; on-disk basename recoverable from `path`; deliberate pairing `filename`=what Jira calls it, `path`=where it landed); EC-2.7.008-6 gained the same clause with the batch-mode addition (post-SHA-1-prefix per BC-2.7.010 also in `path`); BC-2.7.007 and BC-2.7.008 Traces updated with P27-001 citations; H-003 B2 Expected B2 manifest corrected from implied SHA-1-prefixed form to explicit `"filename":"ok.txt"` (RAW Jira name, id=20020); discriminating filename-vs-path assertion added (jq filename = "ok.txt"; basename(path) = SHA-1-prefixed form; MUST differ; MUST-FAIL bullet present); Why-hidden and Status updated; bc-3 JSON Output Shape Contracts table rows 3219-3220 updated with filename=RAW/path=on-disk notes + P27-001 citations; BC-INDEX BC-2.7.007 and BC-2.7.008 rows updated; bc-2 frontmatter v1.3.67 trace entry added.

P27-002 (LOW) correctly and fully applied: H-007 fixture 60003 description corrected from "at the length-cap boundary" to "exceeds the 214-byte sanitizer cap — BC-2.7.011 step 5; truncated to 214, then 41-byte SHA-1 prefix = 255-byte on-disk name at NAME_MAX"; length-cap assertion added to Expected section (on-disk basename after SHA-1 prefix underscore ≤ 214 bytes; `len(...split('_', 1)[1].encode('utf-8')) <= 214`; P27-002 citation; licensing BC-2.7.011 step 5); H-007 Status updated with P27-002 citation; holdout frontmatter v1.5.3→v1.5.4.

P27-003 (LOW) correctly and fully applied: EC-2.7.008-6 gained an explicit "Collision-skip warnings (P27-003)" paragraph classifying collision-skip warnings as NON-ERROR hints suppressed in `--output json` mode (same class as `Downloaded N of M` summary and `--filter` exclusions; manifest omission IS machine signal; consistent with EC-2.7.008-10 filtered-to-zero precedent; human mode unchanged); BC-2.7.008 Trace updated (P27-003); BC-INDEX BC-2.7.008 row updated with P27-003 collision-skip hint classification note.

ECHO-BREAKER: All 4 List-A items grounded — (1) EC-2.7.007-7 RAW semantics licensed by BC-2.7.002 authority (download excluded → EC-2.7.007-7 is download authority) + deliberate pairing is explicit design choice; (2) EC-2.7.008-6 batch clause adds BC-2.7.010 batch naming reference — on-disk=SHA-1-prefixed-form accurately described; (3) H-003 B2 discriminating assertion satisfiable (id=20020, "ok.txt" valid basename → sanitized unchanged → SHA-1-prefixed on-disk form differs); (4) P27-003 collision-skip=hint licensed by P25-001 hint-class precedent + EC-2.7.008-10 filtered-to-zero parallel + manifest-omission-as-machine-signal rationale. List B: H-003 B2 discriminating assertion satisfiable (arithmetic verified); H-007 length-cap assertion satisfiable (251+4=255 bytes → 214-byte cap → 41-byte prefix = 255 on-disk; split assertion ≤ 214 holds). Double-insertion sweep clean. K-1 (filename semantics story): COHERENT — BC-2.7.002 authority excludes download; EC-2.7.007-7/EC-2.7.008-6 clauses define RAW semantics; H-003 B2 manifest "ok.txt" (id=20020) with discriminating assertion internally consistent; bc-3 table rows match; BC-2.7.010 defines batch on-disk form. K-2 (hint taxonomy): MOSTLY-CLOSED — collision-skip classified (P27-003); primary 6-class taxonomy correct; one pre-existing unclassified emission (degenerate-name fallback warning, INFO-NEW-7) prevents clean "ZERO remaining" claim. K-3 (H-007 arithmetic): COHERENT — 255-byte input; 214-byte sanitizer cap (BC-2.7.011 step 5); 41-byte SHA-1 prefix; 255-byte NAME_MAX on-disk; assertion satisfiable; VP-576-001 non-double-claiming (unit scope vs integration scope). K-4 (BC-INDEX v6.27 rows ↔ bodies): COHERENT — BC-2.7.007/BC-2.7.008 INDEX rows reflect P27-001/P27-003; bodies verified. Counts 657/100/35 verified by both guards (exit 0). Spec version 1.3.67 consistent across all primary surfaces. Two new INFO items: INFO-NEW-7 (degenerate-name fallback warning unclassified for JSON mode — pre-existing; K-2 mostly-closed); INFO-NEW-8 (bc-3 frontmatter trace missing v1.3.67 entry — body content correctly updated; trace record absent).

---

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 58 |
| **Passed** | 56 |
| **Info** | 2 new (INFO-NEW-7, INFO-NEW-8) |
| **Failed (GAPs)** | 0 |
| **Warnings (INFO)** | 11 total (9 carry-forward: INFO-1..3, INFO-6, INFO-8, INFO-11, INFO-15, INFO-NEW-5, INFO-NEW-6; 2 new: INFO-NEW-7, INFO-NEW-8) |
| **Overall Status** | consistent |

Round 37 is a PATCH-level validation confirming the 1 MEDIUM + 2 LOW + 1 INFO (no action) P27 adversary-pass fix round: (1) P27-001 (MEDIUM) — `downloaded[].filename` semantics ruling; EC-2.7.007-7 + EC-2.7.008-6 filename clauses; H-003 B2 manifest corrected + discriminating assertion + MUST-FAIL bullet; bc-3 table rows; BC-INDEX rows; FULLY APPLIED. (2) P27-002 (LOW) — H-007 overlong-name description corrected (214-byte cap + 41-byte prefix = 255 NAME_MAX); length-cap assertion added; FULLY APPLIED. (3) P27-003 (LOW) — collision-skip=NON-ERROR hint, suppressed JSON mode; EC-2.7.008-6 sentence + BC-2.7.008 Trace + BC-INDEX BC-2.7.008 row; FULLY APPLIED. (4) P27-INFO-1 (INFO) — no action taken. Counts 657/100/35 unchanged. Spec version advances to 1.3.67. Two new INFO items: INFO-NEW-7 (degenerate-name fallback warning JSON-mode classification gap; pre-existing; K-2 mostly-closed) and INFO-NEW-8 (bc-3 frontmatter trace missing v1.3.67; body content correctly updated). No behavioral gaps found.

---

## Appendix: Validation Methodology

This report was produced by a fresh-context consistency validator (cv-576-r37) with structural reference to r36 report only.

1. **Independent artifact read**: All 6 input artifacts read fresh. Findings formed independently from artifact text.
2. **Quote-based closure**: Every P27 priority check verified by verbatim quotation from the authoritative artifact (RE-READ at claim time — not carried from memory).
3. **K-1 sweep**: BC-2.7.002 authority clause, EC-2.7.007-7 clause, EC-2.7.008-6 clause, H-003 B2 manifest + discriminating assertion, bc-3 table rows 3219-3220, BC-2.7.010 batch naming — all read and verified mutually consistent.
4. **K-2 sweep**: Full enumeration of §2.7 stderr/channel emissions; classification status verified for each; pre-existing unclassified degenerate-name fallback warning found (INFO-NEW-7).
5. **K-3 check**: H-007 fixture arithmetic (251+4=255 input, 214-byte cap, 41-byte prefix = 255 NAME_MAX on-disk), assertion form, BC-2.7.011 step 5 rationale, VP-576-001 non-double-claiming all verified.
6. **K-4 check**: BC-INDEX v6.27 row notes for BC-2.7.007 and BC-2.7.008 verified against body EC clauses and Trace fields.
7. **H-003 B2 discriminating assertion satisfiability**: Fixture topology (id=20020, "ok.txt" → SHA-1-prefix → differs from raw name) verified satisfiable.
8. **H-007 length-cap assertion satisfiability**: Arithmetic verified (251+4=255 → 214-byte cap → 41-byte prefix = 255; split assertion ≤ 214).
9. **ECHO-BREAKER List A (4 items)**: All 4 P27 behavioral sentences traced to licensing sources; no over-claim identified.
10. **ECHO-BREAKER List B**: H-003 B2 and H-007 assertions both satisfiable.
11. **Double-insertion sweep**: Marker occurrence counts for P27-001/P27-002/P27-003 citations, [1.3.67] entry, "Adversary Pass 27" section (2 distinct roles), holdout frontmatter version. All counts explained by distinct legitimate locations.
12. **INFO ledger re-verification**: INFO-NEW-6 verified CARRY-FORWARD (EC-2.7.008-10/EC-2.7.009-3 suppression now explicit in EC bodies). All other carry-forward INFOs verified not introduced or worsened by P27. Two new INFO items identified (INFO-NEW-7: degenerate-name fallback; INFO-NEW-8: bc-3 frontmatter trace).
13. **Guard scripts**: Both `check-spec-counts.sh` and `check-bc-cumulative-counts.sh` executed and verified "OK".
14. **Count sweep**: BC (657), holdout (100), VP (35) verified across BC-INDEX frontmatter, bc-2/bc-3 frontmatter, prd-delta-576.md P27 closing, spec-changelog [1.3.67] count table, and holdout-scenarios.md frontmatter.
