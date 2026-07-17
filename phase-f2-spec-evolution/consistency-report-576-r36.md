---
document_type: consistency-report
round: 36
spec_version: 1.3.66
date: 2026-07-17
validator: cv-576-r36 (fresh context, no prior round visibility)
verdict: CONSISTENT
bc_count: 657
holdout_count: 100
vp_count: 35
priority_checks: P26-001 (BC-2.7.012 KEY-403 batch-paths-only row; exit 1; canonical Permission-denied string; error-taxonomy row 95 issue-GET sub-variant citation re-pointed BC-2.7.006 → BC-2.7.012; row 94 keeps BC-2.7.006; BC-2.7.012 Trace; BC-INDEX row); P26-002 (H-NEW-ATTACHMENT-003 Expected A bullet 2 bare examples struck; SHA-1-prefixed form only); P26-003 (BC-2.7.007 step-1 partial-struct absent-tolerance clause; impact-boundary §1.1 PHASE-DOC-RETRO-ANNOTATION; H-002 fixture satisfiability; BC-2.7.007 Trace; BC-INDEX row); P26-004 (BC-3.9.019 Source softened; no hard src/duration.rs::parse_age_duration path remains; BC-3.9.019 Trace; BC-INDEX row); BC-INDEX v6.25→v6.26; spec-changelog [1.3.66]; prd-delta spec_version_after 1.3.66 + P26 section; bc-2 + bc-3 frontmatter v1.3.66 entries; counts 657/100/35; double-insertion sweep; ECHO-BREAKER List A (4 items) + List B (H-003 bullet 2); K-1..K-4 keystones; INFO-13 resolution check
level: ops
version: "1.0"
status: consistent
producer: cv-576-r36
timestamp: 2026-07-17T00:00:00
phase: 2
inputs:
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/specs/prd/error-taxonomy.md"
  - ".factory/spec-changelog.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
  - ".factory/phase-f1-delta-analysis/impact-boundary-576.md"
input-hash: "77e288e"
traces_to: ".factory/specs/prd/BC-INDEX.md"
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 36 (post-P26 remediation)

**Spec version**: 1.3.66 | **BCs**: 657 | **Holdouts**: 100 | **VPs**: 35 | **Verdict**: CONSISTENT

---

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) — SOH-ATTACHMENTS-1 F2 |
| **Generated** | 2026-07-17T00:00:00 |
| **Generator** | cv-576-r36 (fresh-context consistency validator, round 36) |
| **Artifacts Scanned** | 8 (bc-2-issue-read.md, bc-3-issue-write.md, holdout-scenarios.md, BC-INDEX.md, error-taxonomy.md, spec-changelog.md, prd-delta-576.md, impact-boundary-576.md) |
| **Focus** | Post-P26 adversary-pass remediation verification — spec v1.3.65 → v1.3.66; 3 LOW + 1 INFO findings (second consecutive zero-MEDIUM-and-above pass); double-insertion sweep; ECHO-BREAKER List A (4 items) + List B (H-003 bullet 2); K-1..K-4 keystones; INFO-13 resolution check |
| **Prior round** | consistency-report-576-r35.md (CONSISTENT; INFO-NEW-6 new — EC-2.7.008-10/EC-2.7.009-3 JSON-mode stderr ambiguity) |

---

## Summary Table

| # | Check | Result |
|---|-------|--------|
| P26-001 | BC-2.7.012 error table: KEY-403 batch-paths-only row added (bc-2 line 943) | pass |
| P26-001 | KEY-403 row exit code = 1 | pass |
| P26-001 | KEY-403 row canonical string: `"Permission denied: cannot access issue <KEY>."` | pass |
| P26-001 | KEY-403 row scope: "batch paths only — `--all`/`--newest`" | pass |
| P26-001 | KEY-403 row mirrors BC-2.7.006 P15-005 row (exit code + string + batch-only scope) | pass |
| P26-001 | error-taxonomy row 95 issue-GET sub-variant citation: BC-2.7.012 batch paths only (NOT BC-2.7.006) | pass |
| P26-001 | error-taxonomy row 94 (attachment list 403): keeps BC-2.7.006 citation (unchanged) | pass |
| P26-001 | BC-2.7.012 Trace: P26-001 citation present (bc-2 line 953) | pass |
| P26-001 | BC-INDEX BC-2.7.012 row: KEY-403 note added (P26-001) | pass |
| P26-002 | H-NEW-ATTACHMENT-003 Expected A bullet 2: bare examples struck; SHA-1-prefixed form only (line 2168) | pass |
| P26-002 | H-003 bullet 2: no bare `evil.txt` or `__.evil.txt` forms remain | pass |
| P26-002 | H-003 bullet 2: `<sha1("20003")>_evil.txt` (basename sanitized to `evil.txt`, then batch SHA-1 prefix applied) | pass |
| P26-002 | H-003 bullets 1 and 2 now non-contradictory (both require SHA-1-prefix unconditionally) | pass |
| P26-003 | BC-2.7.007 step-1 partial-struct absent-tolerance clause added (bc-2 line 727) | pass |
| P26-003 | Clause: only `filename` required; all other fields absent-tolerant | pass |
| P26-003 | Fields listed as absent-tolerant: `created`, `author`, `mimeType`, `size`, `content` | pass |
| P26-003 | BC-2.7.007 Trace: P26-003 citation present (bc-2 line 772) | pass |
| P26-003 | impact-boundary §1.1 PHASE-DOC-RETRO-ANNOTATION added (line 36) | pass |
| P26-003 | Annotation: `created` and `author` are `Option` in shared struct | pass |
| P26-003 | Annotation: partial struct and shared struct share same Rust type via `Option` typing | pass |
| P26-003 | H-002 fixture satisfiable under ruling (filename present; created/author absent → accepted) | pass |
| P26-003 | No OTHER surface types `created` as non-Option or implies full-struct step-1 deserialization (K-2 sweep) | pass |
| P26-003 | BC-INDEX BC-2.7.007 row: partial-struct note added (P26-003) | pass |
| P26-004 | BC-3.9.019 Source: no hard `src/duration.rs::parse_age_duration` path (bc-3 line 3822) | pass |
| P26-004 | BC-3.9.019 Source: TBD form — `src/cli/issue/attachments.rs` private helper or `src/duration.rs` pub(crate) sibling | pass |
| P26-004 | BC-3.9.019 Trace: P26-004 citation present (bc-3 line 3854) | pass |
| P26-004 | BC-INDEX BC-3.9.019 row: location-TBD note added with R3.9a reference (P26-004) | pass |
| BC-INDEX v6.26 | index_version v6.25→v6.26; last_updated P26 note present | pass |
| spec-changelog [1.3.66] | Entry present dated 2026-07-17; Summary + Changed Requirements + Impact Assessment artifact table + count table | pass |
| spec-changelog [1.3.66] count table | BC 657 / Holdout 100 / VP 35 / New BCs 0 / New VPs 0 / New Holdouts 0 | pass |
| spec-changelog [1.3.66] count table | "Spec version \| 1.3.65→1.3.66" row present | pass |
| prd-delta spec_version_after 1.3.66 | frontmatter updated (line 8) | pass |
| prd-delta P26 dispositions section | Present (unique heading at line 462); counts BC 657/holdout 100/VP 35/spec v1.3.66/both guards exit 0 | pass |
| bc-2 frontmatter trace v1.3.66 | Entry added (line 20) describing P26-001 + P26-003 changes | pass |
| bc-3 frontmatter trace v1.3.66 | Entry added (line 99) describing P26-004 change | pass |
| Counts 657/100/35 | Consistent across all surfaces; both guards exit 0 | pass |
| Double-insertion sweep | No duplicate KEY-403 rows, partial-struct clauses, PHASE-DOC-RETRO-ANNOTATIONs, [1.3.66] entries, "Adversary Pass 26" headings; P26-001/P26-002/P26-003/P26-004 counts all explained by distinct legitimate locations | pass |
| ECHO-BREAKER List A (4 items) | All 4 P26 behavioral sentences grounded in licensing sources; no over-claim | pass |
| ECHO-BREAKER List B | H-003 bullet 2 (corrected): `<sha1("20003")>_evil.txt` licensed by BC-2.7.010 batch naming; fixture-satisfiable | pass |
| INFO-13 (r28–r35) | Row 95 issue-GET sub-variant citation re-pointed to BC-2.7.012 (P26-001) — RESOLVED | resolved |
| Guard: check-spec-counts.sh | OK: all spec counts verified | pass |
| Guard: check-bc-cumulative-counts.sh | OK: all cumulative BC counts verified (657 total across 8 files) | pass |

**All P26 items verified fully applied. INFO-13 (carried r28–r35) resolved by P26-001. No new CRITICAL, MAJOR, or behavioral GAP findings. Keystones K-1..K-4 all coherent. Both guards exit 0. Verdict: CONSISTENT.**

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

## P26-001 — BC-2.7.012 KEY-403 Batch-Paths-Only Row

### New KEY-403 Row in BC-2.7.012 Error Table (bc-2 line 943) — Quote-Verified

**New row** (verbatim, bc-2-issue-read.md line 943, within the error path taxonomy table):

> `| KEY 403 (batch paths only — \`--all\`/\`--newest\`) | 1 | \`"Permission denied: cannot access issue <KEY>."\` |`

Three attributes verified:
- Exit code = 1 ✓
- Canonical string = `"Permission denied: cannot access issue <KEY>."` ✓
- Scope = batch paths only (`--all`/`--newest`) ✓

### Comparison with BC-2.7.006 P15-005 Row (bc-2 line 704) — MIRRORS VERIFIED

**BC-2.7.006 P15-005 row** (verbatim, bc-2-issue-read.md line 704):

> `| 403 | 1 | \`"Permission denied: cannot access issue <KEY>."\` |`

BC-2.7.012 KEY-403 row matches BC-2.7.006 in both exit code (1) and canonical string (`"Permission denied: cannot access issue <KEY>."`). The BC-2.7.012 row adds the explicit batch-only scope annotation — the scope is narrower than BC-2.7.006 because BC-2.7.012 maps the `--id` path (which does not server-verify KEY per BC-2.7.007) while batch paths do issue the issue-GET.

**Mirrors claim verified ✓**

### error-taxonomy Row 95 — Issue-GET Sub-Variant Citation Re-Pointed (VERIFIED)

**Row 95 after P26-001** (verbatim, error-taxonomy.md line 95):

> `| 403 — \`attachment download\` (issue GET or AID metadata-GET) | \`ApiError(403, ...)\` | 1 | \`"Permission denied: cannot access issue <KEY>."\` (issue 403) or \`"Permission denied: cannot access attachment <AID>."\` (AID 403); canonical string only; Jira body NOT surfaced (issue-GET sub-variant: BC-2.7.012 batch paths only; AID metadata-GET sub-variant: BC-2.7.012 / EC-2.7.007-1b) |`

Issue-GET sub-variant: **BC-2.7.012 batch paths only** ✓ (re-pointed from BC-2.7.006)
AID metadata-GET sub-variant: **BC-2.7.012 / EC-2.7.007-1b** ✓

### error-taxonomy Row 94 — Keeps BC-2.7.006 (VERIFIED)

**Row 94** (verbatim, error-taxonomy.md line 94):

> `| 403 — \`attachment list\` | \`ApiError(403, ...)\` | 1 | \`"Permission denied: cannot access issue <KEY>."\` (canonical string only; Jira body NOT surfaced; BC-2.7.006) |`

Row 94 still cites BC-2.7.006. ✓ No cross-contamination from P26-001.

### BC-2.7.012 Trace (bc-2 line 953) — Quote-Verified

> `P26-001 (KEY-403 batch-paths-only row added to error table — mirrors BC-2.7.006 P15-005 row; error-taxonomy row 95 issue-GET sub-variant citation re-pointed to BC-2.7.012)`

P26-001 citation present with description of both changes. ✓

### BC-INDEX BC-2.7.012 Row — Quote-Verified

From BC-INDEX.md (BC-2.7.012 row, relevant P26-001 addition):

> `**KEY-403 batch-paths-only row added to error table (P26-001): exit 1 \`"Permission denied: cannot access issue <KEY>."\` mirrors BC-2.7.006 P15-005 row**`

P26-001 note added. ✓

**Result**: P26-001 FULLY APPLIED ✓.

---

## P26-002 — H-NEW-ATTACHMENT-003 Expected A Bullet 2 Correction

### H-003 Expected A Bullet 2 (holdout-scenarios.md line 2168) — Quote-Verified

**Current text** (verbatim):

> `- The \`../../evil.txt\` filename is sanitized: the file lands inside \`OUT_DIR\` with a safe SHA-1-prefixed name (\`<sha1("20003")>_evil.txt\` (basename sanitized to \`evil.txt\`, then batch SHA-1 prefix applied)); it does NOT appear at any path above \`OUT_DIR\`.`

Bare examples (`evil.txt`, `__.evil.txt`) are **absent** from bullet 2. The only name form present is `<sha1("20003")>_evil.txt` — the SHA-1-prefixed form. ✓

### Non-Contradiction with Bullet 1 (holdout-scenarios.md line 2167) — VERIFIED

**Bullet 1** (verbatim, relevant excerpt):

> `ALL three files in \`OUT_DIR\` MUST carry SHA-1 prefix forms (40 hex characters + \`_\` + basename). Batch mode SHA-1-prefixes EVERY file unconditionally — including non-colliding files. [...] An implementation that only SHA-1-prefixes on collision (leaving non-colliding files bare) MUST FAIL this assertion.`

Bullet 1 mandates unconditional SHA-1 prefix for ALL batch files. Bullet 2 (corrected) now shows `<sha1("20003")>_evil.txt` — consistent with the unconditional SHA-1 mandate. No contradiction remains. ✓

### ECHO-BREAKER List B — H-003 Bullet 2 Licensing

**Corrected assertion** (line 2168): `<sha1("20003")>_evil.txt (basename sanitized to evil.txt, then batch SHA-1 prefix applied)`

**Licensing basis**:
- BC-2.7.010 batch naming (bc-2 line 838): "Batch: `<sha1-of-id>_<sanitized-basename>`" — unconditional for all batch-path downloads, not limited to collision cases. ✓
- BC-2.7.011 sanitization pipeline: `../../evil.txt` → path components stripped → basename `evil.txt` retained (valid basename, no further fallback needed). ✓
- The assertion `<sha1("20003")>_evil.txt` combines both contracts correctly: sanitize basename first, then apply SHA-1 prefix. ✓
- Fixture satisfiability: the content GET for id `20003` returns `CCC` → file is written to `OUT_DIR/<sha1("20003")>_evil.txt`. ✓

**List B VERIFIED**: H-003 bullet 2 licensed by BC-2.7.010 batch naming + BC-2.7.011 sanitization pipeline. Consistent with H-007 (which independently mandates unconditional SHA-1 prefix for all batch files). ✓

**Result**: P26-002 FULLY APPLIED ✓.

---

## P26-003 — BC-2.7.007 Step-1 Partial-Struct Absent-Tolerance Ruling

### BC-2.7.007 Step-1 Partial-Struct Clause (bc-2 line 727) — Quote-Verified

**New text** (verbatim, bc-2-issue-read.md line 727, bolded clause added within existing step-1 prose):

> `**The metadata deserialization uses a PARTIAL struct requiring only \`filename\` (id implied by the request); all other fields (\`created\`, \`author\`, \`mimeType\`, \`size\`, \`content\`) are absent-tolerant — the step's sole purpose is canonical-filename retrieval, and fixtures/servers may omit metadata fields. (P26-003)**`

Required field: `filename` only (id is implicit from the request URL). ✓
Absent-tolerant fields: `created`, `author`, `mimeType`, `size`, `content` — all five other expected fields. ✓
Rationale: step-1 sole purpose is canonical-filename retrieval. ✓
P26-003 citation present inline. ✓

### BC-2.7.007 Trace (bc-2 line 772) — Quote-Verified

> `P26-003 (step 1 partial-struct clause added — metadata deserialization is absent-tolerant on all fields except \`filename\`; partial form distinguished from shared LIST-path struct)`

P26-003 citation present with accurate description. ✓

### impact-boundary §1.1 PHASE-DOC-RETRO-ANNOTATION (line 36) — Quote-Verified

**New annotation** (verbatim):

> `> **[PHASE-DOC-RETRO-ANNOTATION (P26-003, 2026-07-17)]** The typing above describes the shared LIST-path struct. In the shipped design: \`created\` and \`author\` are \`Option\` in the shared struct — deserialization MUST tolerate null/absent \`author\` (see BC-2.7.002 null-author clause) and absent \`created\`. The shared LIST-path struct may still require what BC-2.7.002's curated output needs, but deserialization is absent-tolerant on these fields. Additionally, the per-attachment step-1 \`GET /rest/api/3/attachment/{id}\` metadata fetch (BC-2.7.007 single-\`--id\` path) uses a PARTIAL form of this struct requiring only \`filename\` (id implied by the request); all other fields (\`created\`, \`author\`, \`mimeType\`, \`size\`, \`content\`) are absent-tolerant on that step — the step's sole purpose is canonical-filename retrieval (BC-2.7.007 step 1, P26-003). The LIST-path full struct and the download metadata partial struct share the same Rust type via \`Option\` typing.`

P26-003 annotation present with correct date (2026-07-17). ✓
Content covers: (a) shared LIST-path struct uses Option for created/author; (b) step-1 partial form requires only filename; (c) shared Rust type via Option typing. ✓

### H-002 Fixture Satisfiability Under Ruling — VERIFIED

**H-002 fixture** (holdout-scenarios.md line 2117):

> `\{"id":"10001","filename":"notes.txt","size":12,"mimeType":"text/plain","content":"<JR_BASE_URL>/rest/api/3/attachment/content/10001"\}`

The fixture includes `filename` (required), `size`, `mimeType`, `content` (absent-tolerant), but does NOT include `created` or `author`. Under P26-003:
- `filename` present ✓ (required field met)
- `created` absent → absent-tolerance applies ✓
- `author` absent → absent-tolerance applies ✓
- `size`, `mimeType`, `content` present → accepted via Option typing (ignored in step 1 per BC-2.7.007 "constructs content URL from id directly, not from content field") ✓

H-002 fixture is satisfiable under the ruling. The prd-delta "H-002 fixtures left AS-IS (confirmed correct under ruling)" claim is accurate. ✓

### K-2 Sweep: No OTHER Surface Types `created` as Non-Option (VERIFIED)

**impact-boundary §1.1 original struct description** (lines 30-34, pre-annotation):
> `created is String (ISO 8601, not parsed)`

This original typing (`created` as `String`, not `Option<String>`) is superseded by the PHASE-DOC-RETRO-ANNOTATION at line 36, which is authoritative per the established annotation pattern. The original text is preserved for audit trail only. ✓

**BC-2.7.007 step-1 clause** (bc-2 line 727): explicitly states `created` is absent-tolerant. No contradiction. ✓

**BC-2.7.002** (list path): describes the curated JSON output shape, not step-1 metadata deserialization. No conflict with partial-struct ruling. ✓

**BC-2.7.008 batch path** (bc-2 line 782): "The per-attachment step-1 `GET /rest/api/3/attachment/{id}` metadata fetch used by single-`--id` download (BC-2.7.007) is SKIPPED on batch paths." Batch path does not use the partial struct at all. No conflict. ✓

**BC-INDEX BC-2.7.007 row** — Quote-Verified:
> `**step-1 deserialization uses PARTIAL struct requiring only \`filename\`; all other fields absent-tolerant (P26-003)**`

P26-003 note added. ✓

No OTHER surface types `created` as non-Option or implies full-struct step-1 deserialization. **K-2 sweep clean ✓**.

**Result**: P26-003 FULLY APPLIED ✓.

---

## P26-004 — BC-3.9.019 Source Softened

### BC-3.9.019 Source Field (bc-3 line 3822) — Quote-Verified

**Softened text** (verbatim):

> `**Source**: \`src/cli/issue/attachments.rs::handle_attachment_delete\` (implementation pending — story S4); \`parse_age_duration\` (S4 location TBD — \`src/cli/issue/attachments.rs\` private helper or \`src/duration.rs\` pub(crate) sibling, per impact-boundary R3.9a)`

No hard `src/duration.rs::parse_age_duration` path present. ✓
TBD form correctly defers to impact-boundary R3.9a. ✓

### BC-3.9.019 Body Text — Citation Guard Implication (bc-3 line 3829)

The BC body text still reads: `"The <duration> argument is parsed by a dedicated parse_age_duration function (e.g., src/duration.rs::parse_age_duration or equivalent) that converts the string to a chrono::Duration."` This uses `e.g.,` — an example, not an assertion. The citation guard (`scripts/check-bc-citation-symbols.sh`) only validates **`**Trace**:`** and **`**Source**:`** fields; the body `e.g.` form is not checked and is intentionally non-assertive. No hard path claim remains in the Source or Trace fields. ✓

### BC-3.9.019 Trace (bc-3 line 3854) — Quote-Verified

> `P26-004 (Source field softened — \`parse_age_duration\` location TBD; \`src/cli/issue/attachments.rs\` private helper or \`src/duration.rs\` pub(crate) sibling per impact-boundary R3.9a)`

P26-004 citation present with accurate description. ✓

### BC-INDEX BC-3.9.019 Row — Quote-Verified

From BC-INDEX.md (BC-3.9.019 row, P26-004 addition):

> `**\`parse_age_duration\` location TBD — private helper in attachments.rs or pub(crate) sibling in duration.rs (P26-004; impact-boundary R3.9a)**`

P26-004 + R3.9a reference present. ✓

### K-4: BC-3.9.019 Softened Source ↔ R3.9a ↔ BC-INDEX Row — COHERENT

| Element | Claim | Source |
|---------|-------|--------|
| BC-3.9.019 Source | "parse_age_duration (S4 location TBD — `src/cli/issue/attachments.rs` private helper or `src/duration.rs` pub(crate) sibling, per impact-boundary R3.9a)" | bc-3 line 3822 |
| R3.9a (impact-boundary line 750) | "S4 story plan note: allocate scope for `parse_age_duration` alongside the `--older-than` handler path. If placed in `src/duration.rs`, add `'src/duration.rs'` to `.cargo/mutants.toml` `examine_globs`" | impact-boundary-576.md line 750 |
| BC-INDEX BC-3.9.019 | "parse_age_duration location TBD — private helper in attachments.rs or pub(crate) sibling in duration.rs (P26-004; impact-boundary R3.9a)" | BC-INDEX line 391 |

R3.9a explicitly provides two options (attachments.rs or duration.rs); the Source field and BC-INDEX row both carry this TBD language. **K-4 COHERENT ✓**.

**Result**: P26-004 FULLY APPLIED ✓.

---

## BC-INDEX v6.25→v6.26

**Quote-verified** (BC-INDEX.md frontmatter, lines 5–6):

```yaml
last_updated: 2026-07-17  # P26 adversary fix round: BC-2.7.007 row P26-003 partial-struct note added; BC-2.7.012 row P26-001 KEY-403 batch-paths-only note added; BC-3.9.019 row P26-004 parse_age_duration location-TBD note added; spec v1.3.66; BC count unchanged (657); holdout count 100 (unchanged); VP count 35 (unchanged); BC-INDEX v6.26. Previous: P25 adversary fix round: ...
index_version: v6.26
```

`index_version` v6.25→v6.26. `last_updated` includes all three P26 row updates (BC-2.7.007, BC-2.7.012, BC-3.9.019) + spec v1.3.66 note. Internally consistent. ✓

**Result**: BC-INDEX v6.26 APPLIED ✓.

---

## spec-changelog [1.3.66]

**Quote-verified** (`spec-changelog.md` entry at line 10):

```
## [1.3.66] - 2026-07-17

### Type: PATCH
```

Entry present; dated 2026-07-17. ✓

**Summary** (line 16): Present — describes all four changes: P26-001 (KEY-403 batch row; mirrors BC-2.7.006 P15-005; error-taxonomy row 95 re-pointed), P26-002 (H-003 bullet 2 bare examples struck; SHA-1-prefixed form retained), P26-003 (BC-2.7.007 partial-struct clause; impact-boundary §1.1 annotation; Option typing; H-002 AS-IS), P26-004 (BC-3.9.019 Source softened; TBD form). ✓

**Changed Requirements** (lines 20–26): Lists 7 modified files:
- bc-2-issue-read.md (P26-001 + P26-003)
- error-taxonomy.md (P26-001)
- holdout-scenarios.md (P26-002)
- bc-3-issue-write.md (P26-004)
- BC-INDEX.md (P26-001 + P26-003 + P26-004 + index_version v6.26)
- prd-delta-576.md (spec_version_after 1.3.66; P26 dispositions)
- impact-boundary-576.md (P26-003 §1.1 annotation)

All 7 files listed. ✓

**Impact Assessment count table** (lines 40–48):

```
| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 100 (unchanged) |
| VP count | 35 (unchanged) |
| New BCs | 0 |
| New VPs | 0 |
| New Holdouts | 0 |
| Spec version | 1.3.65→1.3.66 |
```

7-row table present, including "Spec version | 1.3.65→1.3.66". ✓

**Result**: spec-changelog [1.3.66] APPLIED ✓.

---

## prd-delta-576.md Frontmatter + P26 Section

**Quote-verified** (`prd-delta-576.md` frontmatter, line 8):

```yaml
spec_version_after: 1.3.66
```

`spec_version_after` updated to 1.3.66. ✓

**P26 section heading** (`prd-delta-576.md` line 462):

> `## Adversary Pass 26 Fix Round Finding Dispositions`

P26 section present. Unique — 1 heading at line 462. ✓

**P26 preamble** (line 464):

> `Source: Adversary Pass 26 (second consecutive zero-MEDIUM pass). 3 LOW + 1 INFO findings. Spec version bump: 1.3.65 → 1.3.66. No new BCs. Holdouts: 100 (unchanged). VPs: 35 (unchanged).`

Finding counts and version bump correct. ✓

**P26-001 disposition** (line 468): APPLIED — BC-2.7.012 error table KEY-403 row; exit 1; canonical string; batch-only scope; mirrors BC-2.7.006 P15-005 row; error-taxonomy row 95 citation changed; BC-2.7.006 kept for row 94. BC-INDEX row updated. ✓

**P26-002 disposition** (line 469): APPLIED — H-003 Expected A bullet 2: bare examples struck; SHA-1-prefixed form only; bullets 1 and 2 now consistent with BC-2.7.010 batch naming. ✓

**P26-003 disposition** (line 470): APPLIED — RULING: option (b), partial struct + Option typing. (1) BC-2.7.007 step 1 partial-struct clause added; Trace updated. (2) impact-boundary §1.1 annotation added; Option typing; shared Rust type. (3) H-002 fixtures AS-IS (confirmed correct). BC-INDEX row updated. ✓

**P26-004 disposition** (line 471): APPLIED — BC-3.9.019 Source softened; TBD form; Trace updated; BC-INDEX row updated. ✓

**P26 closing statement** (`prd-delta-576.md` line 473):

> `**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.66. Both guards exit 0.**`

Closing correct: BC 657 / holdout 100 / VP 35 / spec v1.3.66 / both guards exit 0. ✓

**Result**: prd-delta-576.md P26 APPLIED ✓.

---

## INFO-13 (r28–r35) — Resolution Verification

**r28–r35 INFO**: error-taxonomy.md row 95 issue-GET 403 sub-variant — the citation did not correctly attribute the home BC for the issue-GET sub-variant of the attachment-download 403 path.

**After P26-001** (row 95, issue-GET sub-variant — re-read at claim time):

From error-taxonomy.md line 95: `(issue-GET sub-variant: BC-2.7.012 batch paths only; AID metadata-GET sub-variant: BC-2.7.012 / EC-2.7.007-1b)`

The issue-GET sub-variant now explicitly cites **BC-2.7.012 batch paths only** — the correct BC home for the attachment download error taxonomy (not BC-2.7.006, which is the attachment list BC). Row 94 retains BC-2.7.006 for attachment list. The sub-variant attributions are now distinct, accurate, and non-overlapping. **INFO-13 RESOLVED ✓.**

---

## Double-Insertion Sweep

| Marker | Count | Locations | Assessment |
|--------|-------|-----------|------------|
| `## Adversary Pass 26 Fix Round` in `prd-delta-576.md` | 1 | line 462 (heading) | No duplicate section ✓ |
| `1.3.66` in `prd-delta-576.md` | 3 | line 8 (frontmatter), line 464 (P26 preamble), line 473 (P26 closing) | EXPECTED — 3 distinct roles ✓ |
| `[1.3.66]` in `spec-changelog.md` | 1 | line 10 | No duplicate entry ✓ |
| `P26-001` in `bc-2-issue-read.md` | 2 | line 20 (frontmatter trace), line 953 (BC-2.7.012 Trace) | EXPECTED — 2 distinct locations ✓ |
| `P26-003` in `bc-2-issue-read.md` | 3 | line 20 (frontmatter trace), line 727 (step-1 clause inline), line 772 (BC-2.7.007 Trace) | EXPECTED — 3 distinct locations ✓ |
| `P26-004` in `bc-3-issue-write.md` | 2 | line 99 (frontmatter trace), line 3854 (BC-3.9.019 Trace) | EXPECTED — 2 distinct locations ✓ |
| KEY-403 row in BC-2.7.012 table | 1 | line 943 | No duplicate row ✓ |
| `P26-003` in `impact-boundary-576.md` | 1 | line 36 (PHASE-DOC-RETRO-ANNOTATION) | No duplicate annotation ✓ |
| `PHASE-DOC-RETRO-ANNOTATION` in `impact-boundary-576.md` | 9 | lines 36 (P26-003), 163, 177 (P14-004 ×2), 189, 456, 467, 726, 758 (P25-I01), 789 | 8 prior-round annotations + 1 new P26-003 at line 36 — all distinct ✓ |
| `v1.3.66` in `bc-2-issue-read.md` frontmatter | 1 | line 20 | EXPECTED — 1 trace entry ✓ |
| `v1.3.66` in `bc-3-issue-write.md` frontmatter | 1 | line 99 | EXPECTED — 1 trace entry ✓ |

**No double-insertions detected.** All marker counts explained by distinct legitimate locations. ✓

---

## ECHO-BREAKER Audit — List A (4 Items)

### Item 1: KEY-403 Row — "Permission denied: cannot access issue <KEY>." Exit 1, Batch Only

**Text** (bc-2 line 943): `| KEY 403 (batch paths only — --all/--newest) | 1 | "Permission denied: cannot access issue <KEY>." |`

**Licensing basis**:
- BC-2.7.006 row 403 (bc-2 line 704): `| 403 | 1 | "Permission denied: cannot access issue <KEY>." |` — establishes exit 1 and canonical string for issue-level 403 on attachment operations. P26-001 mirrors this in BC-2.7.012 for the batch download path. ✓
- Batch-only scope: BC-2.7.007 step-1 note confirms `--id` path does not server-verify KEY ("The `<KEY>` argument is NOT server-verified on the `--id` path"). Therefore KEY-403 can only arise on batch paths (`--all`/`--newest`) that issue `GET /rest/api/3/issue/{key}?fields=attachment`. ✓
- No over-claim: the row does not assert 403 on the `--id` path. ✓

### Item 2: H-003 Bullet 2 — `<sha1("20003")>_evil.txt` Form Only

**Text** (holdout-scenarios.md line 2168): `the file lands inside OUT_DIR with a safe SHA-1-prefixed name (<sha1("20003")>_evil.txt (basename sanitized to evil.txt, then batch SHA-1 prefix applied))`

**Licensing basis**:
- BC-2.7.010 batch naming (bc-2 line 838): "Batch: `<sha1-of-id>_<sanitized-basename>`" — unconditional, not collision-only. ✓
- BC-2.7.011 step 1 (basename extraction): `../../evil.txt` → extract basename `evil.txt` (path components stripped by algorithm step 1). ✓
- The degenerate fallback (BC-2.7.010 R3.10) does NOT apply here: `evil.txt` is a valid basename after sanitization, so the fallback `<sha1>_20003` form would be incorrect. The assertion `<sha1("20003")>_evil.txt` is correct for this fixture. ✓
- No over-claim: the assertion says `<sha1("20003")>_evil.txt` or the fallback `<sha1("20003")>_20003 if sanitization returns None` (from the surrounding bullet 1 prose at line 2167). ✓

### Item 3: BC-2.7.007 Step-1 Partial-Struct — "all other fields absent-tolerant"

**Text** (bc-2 line 727): `all other fields (created, author, mimeType, size, content) are absent-tolerant — the step's sole purpose is canonical-filename retrieval, and fixtures/servers may omit metadata fields. (P26-003)`

**Licensing basis**:
- BC-2.7.002 null-author clause (bc-2 line 610): "when `attachment.author` is absent or null, the JSON element emits `"author": null`" — establishes that author can be absent/null, grounding the `Option` typing. ✓
- BC-2.7.007 step 1 purpose: "The metadata response is used solely to obtain the canonical `filename` for BC-2.7.010 naming." — step-1 solely needs `filename`; all other fields are irrelevant to this step. ✓
- impact-boundary §1.1 annotation: confirms `created` and `author` are `Option` in the shipped design. ✓
- No over-claim: "absent-tolerant" does not mean these fields are ignored when present — it means they're not required. The struct accepts them via Option typing when present. ✓

### Item 4: impact-boundary Annotation — "shared Rust type via Option typing"

**Text** (impact-boundary-576.md line 36): `The LIST-path full struct and the download metadata partial struct share the same Rust type via \`Option\` typing.`

**Licensing basis**:
- BC-2.7.002 null-author clause establishes that author must be `Option` in the shared struct. If `author` is `Option`, then a partial struct for step-1 (which needs only `filename`) is trivially satisfiable using the same type — all other fields are already `Option` and simply deserialize as `None` when absent. ✓
- BC-2.7.007 step-1 clause (P26-003): "The LIST-path full struct and the download metadata partial struct share the same Rust type via `Option` typing." — this is the authoritative ruling from the PO. ✓
- No over-claim: "share the same Rust type" means the same serde struct is usable for both contexts, not that both contexts decode identical JSON. ✓

**Assessment**: All 4 List-A items grounded in licensing sources. No over-claim on any item. ✓

---

## Keystone Coherence Checks

### K-1: 403 Story Across the Read Surface

Complete attribution of 403 sub-variants in the error taxonomy and authoritative BCs:

| Error-taxonomy row | Sub-variant | BC attribution | Exit | String | Assessment |
|--------------------|------------|----------------|------|--------|------------|
| Row 94 | attachment list 403 | BC-2.7.006 | 1 | `"Permission denied: cannot access issue <KEY>."` | CORRECT — list BC ✓ |
| Row 95 (issue-GET sub-variant) | attachment download, batch paths only | BC-2.7.012 batch paths only | 1 | `"Permission denied: cannot access issue <KEY>."` | CORRECT — download BC (P26-001 re-pointed) ✓ |
| Row 95 (AID metadata-GET sub-variant) | attachment download, single-id step 1 | BC-2.7.012 / EC-2.7.007-1b | 1 | `"Permission denied: cannot access attachment <AID>."` | CORRECT — download BC / specific clause ✓ |
| Row 96 | attachment delete pre-prompt metadata-GET | BC-3.9.015 | 1 | `"Permission denied: cannot access attachment <AID>."` | CORRECT — delete BC ✓ |

**BC-3.9.015 metadata-GET 403** (bc-3 line 3667): `"403: exit 1; "Permission denied: cannot access attachment <AID>." — aligned with BC-2.7.012 (403 on a read GET = runtime error, not a UserError; permission denied is not a user input mistake)."` ✓ — consistent with BC-2.7.012's 403 = exit 1 policy.

Every 403 sub-variant has exactly one BC home and one taxonomy row citation. No orphans, no double-attribution. **K-1 COHERENT ✓**.

### K-2: Partial-Struct Ruling — One Coherent Typing Story

| Element | Claim | Source | Status |
|---------|-------|--------|--------|
| BC-2.7.007 step-1 partial-struct clause | "only `filename` required; all other fields (`created`, `author`, `mimeType`, `size`, `content`) absent-tolerant; sole purpose: canonical-filename retrieval" | bc-2 line 727 (P26-003) | COHERENT ✓ |
| impact-boundary §1.1 annotation | "`created` and `author` are `Option` in shared struct; step-1 uses partial form; shared Rust type via `Option` typing" | impact-boundary-576.md line 36 (P26-003) | COHERENT ✓ |
| BC-2.7.002 null-author clause | "when `attachment.author` is absent or null, the JSON element emits `"author": null`" — establishes author as Option | bc-2 line 610 | COHERENT ✓ |
| H-002 fixtures | `{"id":"10001","filename":"notes.txt","size":12,"mimeType":"text/plain","content":"..."}` — `created` and `author` absent; `filename` present | holdout-scenarios.md line 2117 | SATISFIABLE ✓ |
| impact-boundary §1.1 original struct description | "`created is String (ISO 8601, not parsed)`" — pre-annotation description | impact-boundary-576.md line 34 | SUPERSEDED by P26-003 annotation; preserved for audit trail ✓ |

No surface contradicts the ruling. **K-2 COHERENT ✓**.

### K-3: H-003 Bullet Coherence ↔ H-007 ↔ BC-2.7.010

| Element | Claim | Source |
|---------|-------|--------|
| H-003 Expected A bullet 1 | "ALL three files MUST carry SHA-1 prefix forms; batch mode SHA-1-prefixes EVERY file unconditionally" | holdout-scenarios.md line 2167 |
| H-003 Expected A bullet 2 (corrected) | "`<sha1("20003")>_evil.txt` (basename sanitized to `evil.txt`, then batch SHA-1 prefix applied)" | holdout-scenarios.md line 2168 |
| H-007 Expected | "ALL files in `OUT_DIR` MUST carry SHA-1 prefix forms (40 hex characters + `_` + sanitized basename), since batch mode SHA-1-prefixes EVERY file unconditionally — not only colliding files" | holdout-scenarios.md line 2398 |
| BC-2.7.010 batch naming | "Batch: `<sha1-of-id>_<sanitized-basename>`" (unconditional) | bc-2 line 838 |

H-003 bullet 2 (corrected) shows `<sha1("20003")>_evil.txt` ↔ H-007 mandates unconditional SHA-1 prefix for all batch files ↔ BC-2.7.010 defines batch naming as `<sha1-of-id>_<sanitized-basename>`. All three are mutually consistent. **K-3 COHERENT ✓**.

### K-4: BC-3.9.019 Softened Source ↔ R3.9a ↔ BC-INDEX Row

(Verified in P26-004 section above.)

| Element | Claim | Source |
|---------|-------|--------|
| BC-3.9.019 Source | "parse_age_duration (S4 location TBD — `src/cli/issue/attachments.rs` private helper or `src/duration.rs` pub(crate) sibling, per impact-boundary R3.9a)" — no hard `src/duration.rs::parse_age_duration` path | bc-3 line 3822 |
| R3.9a (impact-boundary) | "S4 story plan note: allocate scope for `parse_age_duration` alongside the `--older-than` handler path. If placed in `src/duration.rs`, add `'src/duration.rs'` to `.cargo/mutants.toml` `examine_globs`" | impact-boundary-576.md line 750 |
| BC-INDEX BC-3.9.019 row | "parse_age_duration location TBD — private helper in attachments.rs or pub(crate) sibling in duration.rs (P26-004; impact-boundary R3.9a)" | BC-INDEX line 391 |

R3.9a explicitly provides the TBD decision record; Source field and BC-INDEX row both cite R3.9a. **K-4 COHERENT ✓**.

---

## Cross-Reference Validation

### BC Counts

| Source | bc-2 definitional | bc-2 total_bcs | bc-3 definitional | bc-3 total_bcs | Grand Total |
|--------|-------------------|-----------------|-------------------|-----------------|-------------|
| Frontmatter | 64 | 106 | 111 | 140 | 657 |
| CANONICAL-COUNTS.md | 64 | 106 | 111 | 140 | 657 |
| Guard output | verified | — | verified | — | 657 |

P26 added 0 new BCs. PASS ✓

### Holdout Counts

| Source | Count | Status |
|--------|-------|--------|
| `holdout-scenarios.md` frontmatter `total_holdouts` | 100 | PASS ✓ |
| `CANONICAL-COUNTS.md` canonical total | 100 | PASS ✓ |
| `prd-delta-576.md` P26 closing | "Holdout count: 100 (unchanged)" | PASS ✓ |
| `spec-changelog.md` [1.3.66] count table | "Holdout count: 100 (unchanged)" | PASS ✓ |

### VP Counts

| Source | VP count reference | Status |
|--------|-------------------|--------|
| `prd-delta-576.md` P26 closing | "VP count: 35 (unchanged)" | PASS ✓ |
| `BC-INDEX.md` last_updated | "VP count 35 (unchanged)" | PASS ✓ |
| `spec-changelog.md` [1.3.66] count table | "VP count: 35 (unchanged)" | PASS ✓ |

---

## Spec Version Surface Verification

| Artifact | Spec version shown | Status |
|----------|--------------------|--------|
| `spec-changelog.md` | `[1.3.66] - 2026-07-17` entry present | PASS ✓ |
| `bc-2-issue-read.md` frontmatter trace | v1.3.65 entry (line 19) + v1.3.66 entry (line 20) | PASS ✓ |
| `bc-3-issue-write.md` frontmatter trace | v1.3.65 entry + v1.3.66 entry (line 99) | PASS ✓ |
| `BC-INDEX.md` `last_updated` | "spec v1.3.66" in P26 note | PASS ✓ |
| `prd-delta-576.md` frontmatter `spec_version_after` | `1.3.66` | PASS ✓ |
| `STATE.md` `current_step` | Stale (carries INFO-8; now stale at v1.3.66) | STALE (INFO-8 worsened) |

---

## INFO Ledger Status

### INFO-1 (carry-forward R21–R36) — CARRY-FORWARD

Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7 in bc-2. Not introduced or worsened by P26.

**Status**: CARRY-FORWARD

---

### INFO-2 (carry-forward R21–R36) — CARRY-FORWARD

EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained. Not introduced or worsened by P26.

**Status**: CARRY-FORWARD

---

### INFO-3 (carry-forward R21–R36) — CARRY-FORWARD

BC-2.7.012 "KEY or AID 5xx" combined-scope row. Not introduced or worsened by P26.

**Status**: CARRY-FORWARD

---

### INFO-6 (carry-forward R23–R36) — CARRY-FORWARD

No holdout for collision-skip exit-0 path. Not introduced or worsened by P26.

**Status**: CARRY-FORWARD

---

### INFO-8 (carry-forward R25–R36) — CARRY-FORWARD

`STATE.md` spec version stale. Now stale at v1.3.66 (was stale at v1.3.65 after r35).

**Status**: CARRY-FORWARD

---

### INFO-11 (carry-forward R27–R36) — CARRY-FORWARD

`spec-changelog.md` [1.3.57] and `prd-delta-576.md` P17-002 disposition say "three sites" but four sites were actually modified. Not introduced or worsened by P26.

**Status**: CARRY-FORWARD

---

### INFO-13 (carry-forward R28–R35) — RESOLVED

`error-taxonomy.md` row 95 issue-GET 403 sub-variant citation problem.

**R36 update**: P26-001 re-pointed the issue-GET sub-variant from the incorrect BC-2.7.006 (the attachment list BC) to the correct BC-2.7.012 batch paths only (the attachment download BC). Row 95 issue-GET sub-variant now reads "(issue-GET sub-variant: BC-2.7.012 batch paths only)" which is accurate and distinct from row 94 (attachment list, BC-2.7.006). INFO-13 RESOLVED.

**Status**: RESOLVED ✓

---

### INFO-15 (carry-forward R29–R36) — CARRY-FORWARD

`impact-boundary-576.md` BC-3.9.004 row has INCONCLUSIVE annotation. Not introduced or worsened by P26.

**Status**: CARRY-FORWARD

---

### INFO-NEW-5 (NEW R34) — CARRY-FORWARD

BC-3.9.009 Trace field (bc-3) not updated with P24-001 citation. Consistent with P19-001 non-citation precedent; BC-INDEX carries the authoritative amendment record. P26 did not touch bc-3 BC-3.9.009.

**Status**: CARRY-FORWARD

---

### INFO-NEW-6 (NEW R35) — CARRY-FORWARD

EC-2.7.008-10 and EC-2.7.009-3 "No attachments matched the filter on `<KEY>`." — JSON-mode stderr behavior not explicitly stated. Pre-existing condition not introduced or worsened by P26.

**Status**: CARRY-FORWARD

---

## Findings

### Critical

None.

### Major

None.

### GAPs

None.

### Resolved This Round

- **INFO-13** (carry R28–R35): error-taxonomy row 95 issue-GET 403 sub-variant citation — RESOLVED. Citation re-pointed from BC-2.7.006 (attachment list BC, incorrect for download) to BC-2.7.012 batch paths only (correct BC home for attachment download operations) by P26-001. Row 94 (attachment list) keeps BC-2.7.006 unchanged.

### Minor (INFO)

- **INFO-1** (carry R21–R36): Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7.
- **INFO-2** (carry R21–R36): EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained.
- **INFO-3** (carry R21–R36): BC-2.7.012 "KEY or AID 5xx" combined-scope row.
- **INFO-6** (carry R23–R36): No holdout for collision-skip exit-0 path.
- **INFO-8** (carry R25–R36): STATE.md spec version stale (should be v1.3.66).
- **INFO-11** (carry R27–R36): P17-002 "three sites" undercount in spec-changelog/prd-delta.
- **INFO-15** (carry R29–R36): impact-boundary BC-3.9.004 INCONCLUSIVE annotation.
- **INFO-NEW-5** (NEW R34): BC-3.9.009 Trace field not updated with P24-001 citation (consistent with P19-001 non-citation precedent; BC-INDEX is the authoritative amendment record).
- **INFO-NEW-6** (NEW R35): EC-2.7.008-10 and EC-2.7.009-3 "No attachments matched the filter on `<KEY>`." — JSON-mode stderr behavior not explicitly stated (pre-existing; hint-class; parallel to EC-2.7.001-1 which explicitly says "no stderr" in JSON mode).

---

## Validation Gate Result

**CONSISTENT**

P26-001 (LOW) correctly and fully applied: BC-2.7.012 error table gained the KEY-403 batch-paths-only row (exit 1, `"Permission denied: cannot access issue <KEY>."`, `--all`/`--newest` scope) — mirrors BC-2.7.006 P15-005 row in exit code and canonical string; error-taxonomy row 95 issue-GET sub-variant citation re-pointed from BC-2.7.006 (list BC) to BC-2.7.012 batch paths only (download BC — correct attribution); row 94 (attachment list) keeps BC-2.7.006 unchanged; BC-2.7.012 Trace updated; BC-INDEX BC-2.7.012 row updated.

P26-002 (LOW) correctly and fully applied: H-NEW-ATTACHMENT-003 Expected A bullet 2 bare examples (`evil.txt`, `__.evil.txt`) struck; replaced with SHA-1-prefixed form only (`<sha1("20003")>_evil.txt`, basename sanitized to `evil.txt`, then batch SHA-1 prefix applied); bullets 1 and 2 now mutually consistent — both require unconditional SHA-1 prefix for all batch-path downloads, consistent with BC-2.7.010 and H-007.

P26-003 (LOW) correctly and fully applied: RULING option (b), partial struct + Option typing — (1) BC-2.7.007 step 1 partial-struct absent-tolerance clause added (metadata deserialization uses a PARTIAL struct requiring only `filename`; all other fields `created`, `author`, `mimeType`, `size`, `content` absent-tolerant; step sole purpose is canonical-filename retrieval; P26-003); (2) BC-2.7.007 Trace updated (P26-003); (3) impact-boundary §1.1 PHASE-DOC-RETRO-ANNOTATION added (`created` and `author` are `Option` in shared struct; LIST-path full struct and download metadata partial struct share same Rust type via `Option` typing; P26-003, 2026-07-17); (4) H-002 fixtures left AS-IS (confirmed correct — `filename` present, `created`/`author` absent → accepted under ruling); (5) BC-INDEX BC-2.7.007 row updated.

P26-004 (INFO) correctly applied: BC-3.9.019 Source field softened — hard `src/duration.rs::parse_age_duration` citation replaced with TBD form (`src/cli/issue/attachments.rs` private helper or `src/duration.rs` pub(crate) sibling, per impact-boundary R3.9a); body text `e.g.,` form remains but is non-assertive and not checked by the citation guard (Trace/Source fields only); BC-3.9.019 Trace updated (P26-004); BC-INDEX BC-3.9.019 row updated with location-TBD note.

ECHO-BREAKER: All 4 List-A items grounded in licensing sources — (1) KEY-403 row licensed by BC-2.7.006 P15-005 mirror + batch-scope reasoning from BC-2.7.007 KEY-not-verified-on-id-path; (2) H-003 bullet 2 SHA-1 form licensed by BC-2.7.010 unconditional batch naming + BC-2.7.011 path-component sanitization; (3) partial-struct absent-tolerance licensed by BC-2.7.002 null-author (Option typing) + BC-2.7.007 step-1 sole-purpose; (4) shared Rust type via Option typing licensed by BC-2.7.002 null-author + PO ruling. No over-claim on any item. List-B: H-003 bullet 2 `<sha1("20003")>_evil.txt` licensed by BC-2.7.010 batch naming; fixture topology (id `20003`, `../../evil.txt` → sanitized to `evil.txt` → SHA-1-prefixed) satisfiable and consistent with H-007 unconditional-SHA-1 mandate. Double-insertion sweep clean. K-1 (403 story): COHERENT — 4 rows (94/95 issue-GET/95 AID-metadata-GET/96) each with one BC home, no orphans, no double-attribution. K-2 (partial-struct ruling): COHERENT — one coherent typing story across BC-2.7.007 step 1, impact-boundary §1.1 annotation, BC-2.7.002 null-author, H-002 fixtures; no surface contradicts Option typing. K-3 (H-003 bullet coherence): COHERENT — H-003 bullet 2 (corrected) uses only SHA-1-prefixed form; H-007 independently mandates unconditional SHA-1 prefix; BC-2.7.010 defines batch naming. K-4 (BC-3.9.019 softened Source): COHERENT — no hard path in Source; TBD correctly defers to R3.9a; BC-INDEX row matches. Counts 657/100/35 verified by both guards (exit 0). Spec version 1.3.66 consistent across all primary surfaces. INFO-13 resolved (r28–r35): row 95 issue-GET 403 sub-variant now correctly attributed to BC-2.7.012 batch paths only.

---

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 41 |
| **Passed** | 41 |
| **Resolved** | 1 (INFO-13 r28–r35) |
| **Failed (GAPs)** | 0 |
| **Warnings (INFO)** | 9 carry-forward (INFO-1..3, INFO-6, INFO-8, INFO-11, INFO-15, INFO-NEW-5, INFO-NEW-6) |
| **Overall Status** | consistent |

Round 36 is a PATCH-level validation confirming the 3 LOW + 1 INFO P26 adversary-pass fix round (second consecutive zero-MEDIUM-and-above pass in the SOH-ATTACHMENTS-1 F2 cycle): (1) P26-001 (LOW) — BC-2.7.012 KEY-403 batch-paths-only row added; error-taxonomy row 95 issue-GET sub-variant re-pointed to BC-2.7.012; FULLY APPLIED; INFO-13 RESOLVED. (2) P26-002 (LOW) — H-003 Expected A bullet 2 corrected: bare examples struck, SHA-1-prefixed form only retained; consistent with H-007 and BC-2.7.010; FULLY APPLIED. (3) P26-003 (LOW) — BC-2.7.007 step-1 partial-struct absent-tolerance clause added; impact-boundary §1.1 PHASE-DOC-RETRO-ANNOTATION added (Option typing); H-002 fixtures satisfiable; K-2 sweep clean; FULLY APPLIED. (4) P26-004 (INFO) — BC-3.9.019 Source field softened to TBD form; no hard citation remains in Source/Trace/BC-INDEX; FULLY APPLIED. Counts 657/100/35 unchanged. Spec version advances to 1.3.66. One prior-round item resolved (INFO-13). No new INFO items.

---

## Appendix: Validation Methodology

This report was produced by a fresh-context consistency validator (cv-576-r36) with structural reference to r35 report only.

1. **Independent artifact read**: All 8 input artifacts read fresh. Findings formed independently from artifact text.
2. **Quote-based closure**: Every P26 priority check verified by verbatim quotation from the authoritative artifact (RE-READ at claim time — not carried from memory).
3. **K-1 sweep**: All four 403 rows (94/95 issue-GET/95 AID-metadata-GET/96) read and verified against their cited BCs. No orphans, no double-attribution.
4. **K-2 sweep**: impact-boundary §1.1 original struct description + annotation + BC-2.7.002 + H-002 fixture all read. No surface contradicts Option typing.
5. **K-3 check**: H-003 bullet 2 (corrected), H-007 Expected, BC-2.7.010 batch naming all read and verified mutually consistent.
6. **K-4 check**: BC-3.9.019 Source + Trace + BC-INDEX row + impact-boundary R3.9a all read. No hard path remains; TBD deference correct.
7. **H-002 fixture satisfiability**: holdout-scenarios.md line 2117 read; `filename` present, `created`/`author` absent → satisfiable under P26-003 ruling.
8. **Citation guard implication (P26-004)**: bc-3 line 3829 body text `e.g.,` form verified as non-assertive; guard only checks Trace/Source fields (CLAUDE.md policy); no hard path in Source (line 3822) verified.
9. **ECHO-BREAKER List A (4 items)**: All 4 P26 behavioral sentences traced to licensing sources; no over-claim identified.
10. **ECHO-BREAKER List B**: H-003 bullet 2 `<sha1("20003")>_evil.txt` verified — licensing BC BC-2.7.010 unconditional batch naming correct; `../../evil.txt` → `evil.txt` sanitization step (BC-2.7.011 step 1 basename extraction) produces a valid name (no fallback); satisfiable.
11. **Double-insertion sweep**: Marker occurrence counts verified for P26-001/P26-002/P26-003/P26-004 citations, [1.3.66] entry, "Adversary Pass 26" section, PHASE-DOC-RETRO-ANNOTATION occurrences (9 total: 8 prior-pass + 1 new P26-003). All counts explained by distinct legitimate locations.
12. **INFO ledger re-verification**: INFO-13 verified RESOLVED by fresh read of error-taxonomy row 95 (issue-GET sub-variant now reads "BC-2.7.012 batch paths only"). INFO-NEW-6 verified CARRY-FORWARD (EC-2.7.008-10/EC-2.7.009-3 ambiguity unchanged). All other INFO items verified not introduced or worsened by P26.
13. **Guard scripts**: Both `check-spec-counts.sh` and `check-bc-cumulative-counts.sh` executed and verified "OK".
14. **Count sweep**: BC (657), holdout (100), VP (35) verified across BC-INDEX frontmatter, bc-2/bc-3 frontmatter, prd-delta-576.md P26 closing, spec-changelog [1.3.66] count table, and holdout-scenarios.md frontmatter.
