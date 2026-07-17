---
document_type: consistency-report
round: 32
spec_version: 1.3.62
date: 2026-07-17
validator: cv-f2-576-r32 (fresh context, no prior round visibility)
verdict: CONSISTENT
bc_count: 657
holdout_count: 100
vp_count: 35
priority_checks: P22-001 (BC-3.9.003 non-interactive bullet + BC-3.9.012 trigger corrected), P22-002 (EC-3.9.016-6 reworded — DELETE wire call + bulk 404 benign-skip), P22-003 (BC-2.7.012 prose batch-only caveat), BC-INDEX v6.22, spec-changelog [1.3.62], prd-delta-576 P22 section, ECHO-BREAKER List A (4 sentences + sentence-1 special scrutiny), List B (empty — no fixtures touched), SPOT-AUDIT (6 KEEP instances), K-1..K-4 keystones, before-any-HTTP residue scan, double-insertion sweep, guard output, INFO ledger re-verification (INFO-NEW-2/3 micro-fix + INFO-12 resolution + INFO-14 resolution)
level: ops
version: "1.0"
status: consistent
producer: cv-f2-576-r32
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
input-hash: "e1b0a27"
traces_to: ".factory/specs/prd/BC-INDEX.md"
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 32 (post-P22 remediation)

**Spec version**: 1.3.62 | **BCs**: 657 | **Holdouts**: 100 | **VPs**: 35 | **Verdict**: CONSISTENT

---

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) — SOH-ATTACHMENTS-1 F2 |
| **Generated** | 2026-07-17T00:00:00 |
| **Generator** | cv-f2-576-r32 (fresh-context consistency validator, round 32) |
| **Artifacts Scanned** | 7 (bc-3-issue-write.md, bc-2-issue-read.md, holdout-scenarios.md, BC-INDEX.md, CANONICAL-COUNTS.md, spec-changelog.md, prd-delta-576.md) |
| **Focus** | Post-P22 adversary-pass remediation verification — spec v1.3.61 → v1.3.62; ECHO-BREAKER List A (4 sentences, sentence-1 special scrutiny) + List B (empty, verified); SPOT-AUDIT of ≥6 KEEP "before any HTTP" sweep instances; K-1..K-4 keystones; before-any-HTTP residue scan; double-insertion sweep including hook-timeout risk; INFO ledger re-verification (INFO-NEW-2/3 micro-fix claims + INFO-12/INFO-14 resolution) |
| **Prior round** | consistency-report-576-r31.md (CONSISTENT; INFO-NEW-2: spec-changelog [1.3.61] missing count rows + BC-2.7.012 Trace missing P21-006; INFO-NEW-3: bc-2 frontmatter trace not updated P20/P21; INFO-12 carry: BC-3.9.003 Trace missing P17-003; INFO-14 re-opened: [1.3.61] count rows pattern) |

---

## Summary Table

| # | Check | Result |
|---|-------|--------|
| P22-001 | BC-3.9.003 non-interactive bullet corrected: "before any HTTP" → "before any servicedeskapi call and before any upload POST (Step-0 issue GET and project-meta resolution have already run — EC-3.9.003-7 evaluates eligibility first)" | pass |
| P22-001 | BC-3.9.012 trigger column corrected: "local" → "local (after Step-0 issue GET + meta fetch)" | pass |
| P22-001 | BC-3.9.003 Trace updated with P22-001 citation | pass |
| P22-001 | BC-INDEX BC-3.9.003 row: non-interactive trigger note "before any servicedeskapi call and upload POST (Step-0 issue GET + meta resolution already ran; P22-001)" added | pass |
| P22-001 | BC-INDEX BC-3.9.012 row: trigger column note "local (after Step-0 issue GET + meta fetch) — P22-001" added | pass |
| P22-001 | Residue scan: no "before any HTTP" remaining in BC-3.9.003 body or BC-3.9.012 non-interactive row | pass |
| P22-001 | Sweep SPOT-AUDIT: ≥6 KEEP instances independently verified as genuinely pre-HTTP | pass |
| P22-001 | ZERO instances remain on paths where a mandated GET precedes the exit (sweep claim) | pass |
| P22-002 | EC-3.9.016-6 reworded: "issue the DELETE wire call of BC-3.9.008 for each AID serially; 404 handling per BC-3.9.013 bulk exception (benign skip); JSON shape per BC-3.9.010" | pass |
| P22-002 | BC-INDEX BC-3.9.016 row updated with EC-3.9.016-6 P22-002 note | pass |
| P22-002 | Residue scan: no "proceed to BC-3.9.008" remaining in EC-3.9.016-6 | pass |
| P22-003 | BC-2.7.012 prose "Unknown issue key" sentence prepended with batch-only caveat | pass |
| P22-003 | BC-INDEX BC-2.7.012 row updated with P22-003 note and citation | pass |
| BC-INDEX v6.22 | index_version v6.21→v6.22; last_updated note includes all 4 P22 rows + spec v1.3.62 | pass |
| spec-changelog [1.3.62] | Entry present; Summary + Changed Requirements + Impact Assessment (artifact table + count table) present | pass |
| prd-delta-576.md spec_version_after 1.3.62 | frontmatter updated; P22 dispositions section present (unique); closing BC 657/holdout 100/VP 35/spec v1.3.62/guards exit 0 | pass |
| Counts 657/100/35 | Consistent across BC-INDEX, spec-changelog, prd-delta, holdout-scenarios, CANONICAL-COUNTS, bc-3 footer, bc-2 footer | pass |
| Double-insertion sweep | No duplicate v1.3.62 entries, EC-3.9.016-6 blocks, "Adversary Pass 22" section headings | pass |
| K-1 | BC-3.9.003 bullet ↔ EC-3.9.003-7 ↔ BC-3.9.005 ↔ H-NEW-ATTACHMENT-008 — one coherent guard-order + wire story | pass |
| K-2 | BC-3.9.012 non-interactive row "(after Step-0 issue GET + meta fetch)" ↔ sibling non-JSM row "(after meta fetch)" — consistent trigger vocabulary | pass |
| K-3 | EC-3.9.016-6 ↔ BC-3.9.013 bulk exception ↔ BC-3.9.010 ↔ H-NEW-ATTACHMENT-012 | pass |
| K-4 | BC-2.7.012 prose ↔ its own table row ↔ BC-2.7.007 | pass |
| ECHO-BREAKER List A (4 sentences) | All 4 P22 behavioral sentences grounded in licensing sources; no over-claim | pass |
| ECHO-BREAKER List A sentence-1 special scrutiny | EC-3.9.003-7 parenthetical accurately describes eligibility ordering before non-interactive branch | pass |
| ECHO-BREAKER List B (empty) | No VP-576-* or H-NEW-ATTACHMENT-* body text references P22; claim verified | pass |
| INFO-NEW-2 (r31) micro-fix | spec-changelog [1.3.61] count rows added; BC-2.7.012 Trace P21-006 citation added | RESOLVED |
| INFO-NEW-3 (r31) micro-fix | bc-2 frontmatter trace P21-006 + P22-003 entries now present | RESOLVED |
| INFO-12 (r27–r31 carry) | BC-3.9.003 Trace now includes P17-003 citation (was missing R27–R31) | RESOLVED |
| INFO-14 (r29–r31 RE-OPENED) | spec-changelog [1.3.61] count rows restored (micro-fix); [1.3.62] count table also present | RESOLVED |
| Guard: check-spec-counts.sh | OK: all spec counts verified | pass |
| Guard: check-bc-cumulative-counts.sh | OK: all cumulative BC counts verified (657 total across 8 files) | pass |

**No behavioral GAPs found. All P22 changes correctly applied. ECHO-BREAKER: 4 List-A sentences grounded, no over-claim; sentence-1 EC-3.9.003-7 parenthetical accurate; List-B empty confirmed. SPOT-AUDIT of ≥6 KEEP instances clean. Double-insertion sweep clean. Residue scans clean. Keystones K-1..K-4 coherent. Spec version 1.3.62 consistent. Counts 657/100/35 verified by guards. INFO-NEW-2/3 (r31) RESOLVED; INFO-12/14 RESOLVED. One new INFO item (INFO-NEW-1: BC-2.7.012 Trace missing P22-003 citation).**

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

## P22-001 — BC-3.9.003 Non-Interactive Bullet + BC-3.9.012 Trigger Corrected

### BC-3.9.003 Non-Interactive Bullet

**Quote-verified verbatim** (`bc-3-issue-write.md` BC-3.9.003 non-interactive mode bullet, line 3317):

> `- **Non-interactive mode** (\`--no-input\` OR stdin is not a TTY): exit 64 before any servicedeskapi call and before any upload POST (the Step-0 issue GET and project-meta resolution have already run — EC-3.9.003-7 evaluates eligibility first); stderr: \`"Use --yes to confirm uploading <N> file(s) to <KEY> as customer-visible, or run interactively."\` (substring-matchable wording; \`--yes\` hint is mandatory per BC-3.5.007 pattern).`

Corrected phrasing present: "before any servicedeskapi call and before any upload POST". Parenthetical present: "(the Step-0 issue GET and project-meta resolution have already run — EC-3.9.003-7 evaluates eligibility first)". No residual "before any HTTP" in this bullet. ✓

### BC-3.9.003 Trace Updated

**Quote-verified** (`bc-3-issue-write.md` BC-3.9.003 Trace, line 3332):

> `**Trace**: ... P16-003 (Step 0 added: issue GET for existence validation + project key; projectTypeKey source pinned to get_or_fetch_project_meta NOT issue GET; key-derivation asymmetry vs BC-3.9.017 step 0 extended); P17-003 (EC-3.9.003-5 Step-0 suppression: when entered from BC-3.9.017 step 4, Step 0 SKIPPED — existence validated by step 1's \`?fields=attachment\` GET; ONE issue GET per invocation on combined \`--replace-existing --public\` path); P22-001 (non-interactive bullet corrected: 'exit 64 before any HTTP' → 'exit 64 before any servicedeskapi call and before any upload POST — Step-0 issue GET and project-meta resolution have already run'; BC-3.9.012 trigger column 'local' → 'local (after Step-0 issue GET + meta fetch)')`

P22-001 citation present; P17-003 citation also present (resolves INFO-12 — see INFO ledger). ✓

**RESIDUE HUNT**: Confirming no "before any HTTP" remains in BC-3.9.003 body: line 3317 now reads "before any servicedeskapi call and before any upload POST" — no "before any HTTP" present. Line 3308 (Step 0 narrative), lines 3317-3332 (BC-3.9.003 body): no surviving "before any HTTP" instances in BC-3.9.003 on the non-interactive gate path. ✓

### BC-3.9.012 Trigger Column

**Quote-verified** (`bc-3-issue-write.md` BC-3.9.012 error taxonomy table, line 3552):

> `| Non-interactive without \`--yes\` (\`--public\`) | local (after Step-0 issue GET + meta fetch) | 64 | hint to use \`--yes\` (BC-3.9.014) |`

Trigger corrected from "local" to "local (after Step-0 issue GET + meta fetch)". No "before any HTTP" remaining in this row. ✓

**Sibling row for comparison** (line 3551 — `--public` on non-JSM issue):

> `| \`--public\` on non-JSM issue | local (after meta fetch) | 64 | ...`

Vocabulary consistent: both rows use "local (after ... meta fetch)" for guards that fire post-HTTP-pre-flight. ✓

### BC-INDEX BC-3.9.003 and BC-3.9.012 Rows Updated

**BC-3.9.003 row** (`BC-INDEX.md` line 375):

> `| BC-3.9.003 | ... **non-interactive exit 64 before any servicedeskapi call and upload POST (Step-0 issue GET + meta resolution already ran; P22-001)**; ... | — (SOH-ATTACHMENTS-1 F2; P22-001) | ...`

P22-001 note and citation present. ✓

**BC-3.9.012 row** (`BC-INDEX.md` line 384):

> `| BC-3.9.012 | ... **non-interactive-no-yes trigger: local (after Step-0 issue GET + meta fetch) — P22-001**; ... | — (SOH-ATTACHMENTS-1 F2; P22-001) | ...`

P22-001 note and citation present. ✓

**Result**: P22-001 APPLIED ✓.

---

## P22-001 — SPOT-AUDIT of KEEP "before any HTTP" Instances

The P22 PO sweep confirmed ~25 "before any HTTP" instances across `.factory/specs/prd/` as KEEP (genuinely pre-HTTP on their own path; none have a preceding mandated GET). The corrected instance was line 3317 (the BC-3.9.003 non-interactive bullet). Independent spot-audit of ≥6 KEEP instances:

| # | Location | Text | Guard context | Assessment |
|---|----------|------|---------------|------------|
| 1 | `bc-3-issue-write.md:363` | "clap exits with usage error before any HTTP call" | `--resolution` + `--no-resolution` clap-level mutual exclusion; fires before handler entry | Genuinely pre-HTTP: clap-level conflict ✓ |
| 2 | `bc-3-issue-write.md:1757` | "this combination before any HTTP call" | `--label` + `--field` mutual-exclusion guard in `handle_edit`; no issue GET or JQL on this path | Genuinely pre-HTTP: flag-conflict guard ✓ |
| 3 | `bc-3-issue-write.md:1817` | "exits 64 before any HTTP call" | `--field` with reserved field names (`summary`/`description`/`issuetype`/`priority`); client-side field-name check on known dedicated-flag fields | Genuinely pre-HTTP: field-name validation ✓ |
| 4 | `bc-3-issue-write.md:2276` | "before any HTTP call. Input not matching `^[0-9A-Za-z_-]+$`" | EC-3.5.005-2: `--id` regex validation; pure pattern match on CLI arg | Genuinely pre-HTTP: regex guard ✓ |
| 5 | `bc-2-issue-read.md:636` | "exit 64 before any HTTP call" | EC-2.7.003-2: `--filter` key/format validation; client-side string split on `=` and key-set check | Genuinely pre-HTTP: filter format parse ✓ |
| 6 | `holdout-scenarios.md:1484` | "EC-3.4.017-1: multi-key `--field` → exit 64 before any HTTP, including editmeta GET" | BC-3.4.017 Gate A: multi-key `--field` rejection; count derived from CLI args, no HTTP | Genuinely pre-HTTP: key-count guard ✓ |
| 7 | `holdout-scenarios.md:1516` | "exit 64 before any HTTP; stderr names `--type` and both project keys" | BC-3.4.019 EC-3.4.019-1: cross-project `--type` guard; project prefix extracted from key strings client-side | Genuinely pre-HTTP: string-prefix guard ✓ |
| 8 | `bc-5-boards-sprints.md:99` | "exit 2 before any HTTP" | `--limit` + `--all` clap-level conflict; clap fires before handler | Genuinely pre-HTTP: clap conflict ✓ |

All 8 KEEP instances audited are genuinely pre-HTTP on their own path. Zero instances remain on paths where a mandated GET precedes the exit (the only such instance, bc-3-issue-write.md line 3317, was corrected). SPOT-AUDIT PASS ✓.

---

## P22-002 — EC-3.9.016-6 Reworded

**Quote-verified verbatim** (`bc-3-issue-write.md` EC-3.9.016-6, line 3719):

> `**EC-3.9.016-6** (multi-AID bulk, \`--yes\`): issue the DELETE wire call of BC-3.9.008 for each AID serially; 404 handling per BC-3.9.013 bulk exception (benign skip); JSON shape per BC-3.9.010.`

"issue the DELETE wire call of BC-3.9.008" (not "proceed to BC-3.9.008"); "404 handling per BC-3.9.013 bulk exception (benign skip)" added; "JSON shape per BC-3.9.010" retained. No "proceed to BC-3.9.008" remaining. ✓

**BC-INDEX BC-3.9.016 row** (`BC-INDEX.md` line 388):

> `| BC-3.9.016 | ... **EC-3.9.016-6 multi-AID --yes path: 404 handling per BC-3.9.013 bulk exception (benign skip) — P22-002** | — (SOH-ATTACHMENTS-1 adversary pass-1 R1; P7-001; P22-002) | ...`

P22-002 note and citation present. ✓

**RESIDUE HUNT**: Confirming no "proceed to BC-3.9.008" in EC-3.9.016-6 or any mirror: the only instance of EC-3.9.016-6 is line 3719. No "proceed to BC-3.9.008" phrase in bc-3-issue-write.md at or near this location. ✓

**Result**: P22-002 APPLIED ✓.

---

## P22-003 — BC-2.7.012 Body Prose Prepended

**Quote-verified verbatim** (`bc-2-issue-read.md` BC-2.7.012 body, line 926):

> `**Unknown issue key** (batch paths only — \`--all\`/\`--newest\`; the \`--id\` path does not server-verify KEY per BC-2.7.007): when \`<KEY>\` does not exist or is inaccessible, \`GET /rest/api/3/issue/{key}?fields=attachment\` returns 404. Handler exits 64: \`"Issue <KEY> not found or not accessible."\``

Batch-only caveat prepended: "(batch paths only — `--all`/`--newest`; the `--id` path does not server-verify KEY per BC-2.7.007)". Prose now matches the table row annotation added in P21-006. ✓

**BC-2.7.012 table row** (line 939):

> `| KEY 404 (batch paths only — \`--id\` does not server-verify KEY per BC-2.7.007) | 64 | \`"Issue <KEY> not found or not accessible."\` |`

Prose and table row are now aligned: both note "batch paths only" + "--id does not server-verify KEY per BC-2.7.007". ✓

**BC-INDEX BC-2.7.012 row** (`BC-INDEX.md` line 231):

> `| BC-2.7.012 | ... **body prose "Unknown issue key" sentence prepended with batch-only caveat (P22-003)**; ... | — (SOH-ATTACHMENTS-1 F2; P7-001; P13-001; P18-002; P21-006; P22-003) | ...`

P22-003 note and citation present. P21-006 citation also present (carried). ✓

**BC-2.7.012 Trace field** (line 949):

> `**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design; research §6 JRACLOUD-96384/-78388 VERIFIED); P21-006 (KEY-404 batch-paths-only annotation — \`--id\` does not server-verify KEY per BC-2.7.007)`

P21-006 now present in Trace (resolves r31 INFO-NEW-2 Trace sub-item). P22-003 citation NOT in Trace body field (see INFO-NEW-1 below). ✓ (partial — see INFO)

**Result**: P22-003 APPLIED ✓ (with INFO-NEW-1: Trace body missing P22-003 citation — non-blocking).

---

## BC-INDEX v6.21→v6.22

**Quote-verified** (`BC-INDEX.md` frontmatter, lines 5–6):

```yaml
last_updated: 2026-07-16  # P22 adversary fix round: BC-3.9.003 row non-interactive trigger corrected (P22-001); BC-3.9.012 row trigger column note added (P22-001); BC-3.9.016 row EC-3.9.016-6 404-handling note added (P22-002); BC-2.7.012 row body-prose caveat note added (P22-003); spec v1.3.62; BC count unchanged (657); holdout count 100 (unchanged); VP count 35 (unchanged); BC-INDEX v6.22. Previous: P21 adversary fix round: BC-3.9.010 row bulk-404 benign-skip clarified (P21-001); BC-3.9.004 row servicedesk pagination added (P21-004); BC-2.7.012 row KEY-404 annotated batch-paths-only (P21-006); spec v1.3.61; BC count unchanged (657); holdout count 99→100; VP count 35 (unchanged); BC-INDEX v6.21
index_version: v6.22
```

`index_version` v6.21→v6.22. `last_updated` includes all 4 P22 row updates + spec v1.3.62 note. Consistent internally. ✓

**Result**: BC-INDEX v6.22 APPLIED ✓.

---

## spec-changelog [1.3.62]

**Quote-verified** (`spec-changelog.md` entry at line 10):

```
## [1.3.62] - 2026-07-16

### Type: PATCH
```

Entry present; dated 2026-07-16. ✓

**Summary** (line 16): Present — describes P22-001 (MEDIUM: BC-3.9.003 bullet + BC-3.9.012 trigger + sweep + H-008/010 coherence), P22-002 (LOW: EC-3.9.016-6 "proceed to" removal + bulk-404-benign-skip), P22-003 (LOW: BC-2.7.012 prose batch-only caveat), P22-004 (INFO: NEW-R4-002 deferral confirmed). All 4 P22 items described. ✓

**Changed Requirements** (lines 18–23): Lists 4 modified files (bc-3, bc-2, BC-INDEX, prd-delta) with per-item descriptions. ✓

**Impact Assessment artifact table** (lines 27–32): 4 rows (bc-3-issue-write.md, bc-2-issue-read.md, BC-INDEX.md, prd-delta-576.md). ✓

**Impact Assessment count table** (lines 34–39):

```
| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 100 (unchanged) |
| VP count | 35 (unchanged) |
| Spec version | 1.3.61→1.3.62 |
```

Explicit count rows present. ✓ (Pattern established at [1.3.60] correctly followed at [1.3.62].)

**Result**: spec-changelog [1.3.62] APPLIED ✓.

---

## prd-delta-576.md Frontmatter + P22 Section

**Quote-verified** (`prd-delta-576.md` frontmatter, line 8):

```yaml
spec_version_after: 1.3.62
```

`spec_version_after` updated to 1.3.62. ✓

**P22 section heading** (`prd-delta-576.md` line 411):

> `## Adversary Pass 22 Fix Round Finding Dispositions`

P22 section present (unique — one heading occurrence). ✓

**P22 preamble** (line 413):

> `Source: Adversary Pass 22. 1 MEDIUM / 2 LOW / 1 INFO findings. Spec version bump: 1.3.61 → 1.3.62. No new BCs. Holdouts: 100 (unchanged). VPs: 35 (unchanged).`

Finding counts and version bump correct. ✓

**P22-001 disposition** (line 417, verified): APPLIED; BC-3.9.003 corrected + BC-3.9.012 trigger + sweep (P22-001(c)) + H-008/010 coherence (P22-001(d)). ✓
**P22-002 disposition** (line 418, verified): APPLIED; EC-3.9.016-6 reworded. ✓
**P22-003 disposition** (line 419, verified): APPLIED; BC-2.7.012 prose prepended. ✓
**P22-004 disposition** (line 420, verified): CONFIRMED (no action); NEW-R4-002 deferral present at prd-delta line 226. ✓

**P22 closing statement** (`prd-delta-576.md` line 422):

> `**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.62. Both guards exit 0.**`

Closing correct: BC 657 / holdout 100 / VP 35 / spec v1.3.62 / both guards exit 0. ✓

**Result**: prd-delta-576.md P22 APPLIED ✓.

---

## Double-Insertion Sweep (Hook-Timeout Risk)

| Marker | Count | Locations | Assessment |
|--------|-------|-----------|------------|
| `v1.3.62` in `bc-3-issue-write.md` frontmatter trace | 1 | line 96 | EXPECTED — frontmatter trace entry |
| `spec v1.3.62` in `bc-3-issue-write.md` footer | 1 | line 3897 | EXPECTED — footer summary |
| `[1.3.62]` in `spec-changelog.md` | 1 | line 10 | No duplicate entry |
| `## Adversary Pass 22 Fix Round Finding Dispositions` in `prd-delta-576.md` | 1 | line 411 | No duplicate section |
| EC-3.9.016-6 in `bc-3-issue-write.md` | 1 (body definition) | line 3719 | No duplicate block |
| P22-001 in `bc-3-issue-write.md` | 3 | frontmatter trace (96), BC-3.9.003 Trace (3332), footer (3897) | EXPECTED — three distinct roles |
| P22-002 in `bc-3-issue-write.md` | 2 | footer (3897), EC-3.9.016-6 area | EXPECTED — footer + BC-3.9.016 area |
| `v1.3.62` in `bc-2-issue-read.md` frontmatter trace | 1 | line 17 | EXPECTED — frontmatter trace entry |

**No double-insertions detected.** All marker counts are explained by distinct legitimate locations. ✓

---

## ECHO-BREAKER Audit — List A (4 sentences)

### Sentence 1 (SPECIAL SCRUTINY): BC-3.9.003 Non-Interactive Bullet (bc-3 line 3317)

**New text (verbatim)**: `"exit 64 before any servicedeskapi call and before any upload POST (the Step-0 issue GET and project-meta resolution have already run — EC-3.9.003-7 evaluates eligibility first)"`

**Licensing basis (each element traced)**:

- **"exit 64 before any servicedeskapi call and before any upload POST"**: The servicedeskapi calls in BC-3.9.003 are Step 1 (POST attachTemporaryFile) and Step 2 (POST request/{key}/attachment). Both are post-gate wire steps. BC-3.9.003 Step 0 (line 3308) runs first (issue GET + meta), then the gate fires. The servicedeskapi calls fire only after the gate passes. ✓
- **"the Step-0 issue GET and project-meta resolution have already run"**: BC-3.9.003 Step 0 (line 3308): "`GET /rest/api/3/issue/{key}` (no `?fields` restriction needed; the existence check is the goal)" + `get_or_fetch_project_meta` called on success. Step 0 is unconditional on this path. ✓
- **"EC-3.9.003-7 evaluates eligibility first"**: EC-3.9.003-7 (line 3330): "Guard evaluation order: (1) JSM eligibility check (BC-3.9.005) → if non-JSM, exit 64; (2) interactive vs. non-interactive branch; (3) `--yes` bypass or prompt. P14-002 finding." The eligibility check (item 1) fires BEFORE the non-interactive branch (item 2). The eligibility check uses `get_or_fetch_project_meta` output, which is part of Step 0. Therefore by EC-3.9.003-7 ordering: Step 0 (issue GET + meta) → eligibility check → non-interactive branch. The parenthetical "EC-3.9.003-7 evaluates eligibility first" correctly references EC-3.9.003-7 as the guard-ordering anchor that guarantees Step 0 has run before the non-interactive exit fires. ✓

**Special scrutiny — does the parenthetical accurately describe EC-3.9.003-7's ordering?**

EC-3.9.003-7 defines: item (1) eligibility check THEN item (2) non-interactive/--yes branch. The eligibility check requires `get_or_fetch_project_meta` output (meta fetch from Step 0). Therefore: Step 0 runs → eligibility check (EC-3.9.003-7 item 1) passes → non-interactive exit fires (EC-3.9.003-7 item 2). The parenthetical claim that "EC-3.9.003-7 evaluates eligibility first" is accurate: it is the eligibility check ordering (item 1 before item 2) that guarantees Step 0 already ran when the non-interactive branch is reached. No over-claim. ✓

**Assessment**: Licensed by BC-3.9.003 Step 0 (unconditional issue GET + meta) + EC-3.9.003-7 (eligibility before non-interactive) + BC-3.9.003 Steps 1–2 (servicedeskapi calls are post-gate). Parenthetical accurate. No over-claim. ✓

---

### Sentence 2: BC-3.9.012 Trigger Corrected (bc-3 line 3552)

**New text (verbatim)**: `"local (after Step-0 issue GET + meta fetch)"`

**Licensing basis**: BC-3.9.003 Step 0 (line 3308) — issue GET + `get_or_fetch_project_meta` unconditionally run on this path. EC-3.9.003-7 (line 3330) — eligibility check (which uses meta) runs before the non-interactive branch. The trigger "local (after Step-0 issue GET + meta fetch)" correctly describes that this exit is locally triggered (no HTTP issued at the exit itself) but only after those HTTP calls have already completed.

**Assessment**: Licensed by BC-3.9.003 Step 0 + EC-3.9.003-7 ordering. No over-claim. ✓

---

### Sentence 3: EC-3.9.016-6 Reword (bc-3 line 3719)

**New text (verbatim)**: `"issue the DELETE wire call of BC-3.9.008 for each AID serially; 404 handling per BC-3.9.013 bulk exception (benign skip); JSON shape per BC-3.9.010."`

**Licensing basis (each element traced)**:

- **"issue the DELETE wire call of BC-3.9.008"**: BC-3.9.008 defines `DELETE /rest/api/3/attachment/{id}`. The phrase "wire call" correctly scopes to the HTTP call contract only, explicitly NOT importing BC-3.9.008's single-AID 404→exit-64 semantics. ✓
- **"404 handling per BC-3.9.013 bulk exception (benign skip)"**: BC-3.9.013 multi-delete exception (line 3588): "on multi-attachment delete paths (`--older-than`, multi-AID bulk per BC-3.9.016, `--replace-existing` delete phase per BC-3.9.017), a 404 response to an individual `DELETE` is treated as already-deleted (benign race condition) and is silently skipped; iteration continues." Exact match for "bulk exception (benign skip)". ✓
- **"JSON shape per BC-3.9.010"**: BC-3.9.010 defines the JSON output for bulk delete (count, deleted, ids). Carried from the prior EC-3.9.016-6 text. ✓

**Assessment**: All three elements licensed. The "wire call" scoping correctly prevents import of single-AID 404 semantics into the bulk path (the precise gap P22-002 corrected). No over-claim. ✓

---

### Sentence 4: BC-2.7.012 Prose Prepended (bc-2 line 926)

**New text (verbatim)**: `"(batch paths only — \`--all\`/\`--newest\`; the \`--id\` path does not server-verify KEY per BC-2.7.007)"`

**Licensing basis**:

- **"batch paths only — `--all`/`--newest`"**: BC-2.7.012 table row (line 939) already had "(batch paths only — `--id` does not server-verify KEY per BC-2.7.007)" from P21-006. The `--all`/`--newest` enumeration comes from BC-2.7.007 (batch download paths use issue GET). ✓
- **"the `--id` path does not server-verify KEY per BC-2.7.007"**: BC-2.7.007 (line 745 area): the `--id` path uses `GET /rest/api/3/attachment/{id}` (a direct attachment GET) — no issue GET is issued on the `--id` path, so KEY existence is not server-verified. ✓

**Assessment**: Licensed by BC-2.7.007 (`--id` path contract) + BC-2.7.012 table row (P21-006 annotation). Aligns prose with existing table annotation. No over-claim. ✓

---

### List B Verification (No Fixtures Touched)

The P22 fix round touched bc-3-issue-write.md (BC-3.9.003 body, BC-3.9.012 table, EC-3.9.016-6 body, Trace, footer), bc-2-issue-read.md (BC-2.7.012 body prose, frontmatter trace), BC-INDEX.md (4 rows, metadata), and prd-delta-576.md (frontmatter, P22 section). **No holdout-scenarios.md or VP bodies were modified**.

Verification: grep for "P22" in holdout-scenarios.md body text and VP-576-* body text — **no P22 references found in any VP or H-NEW-ATTACHMENT-* body text**. H-NEW-ATTACHMENT-008 body (lines 2404–2430) contains no P22 references; H-NEW-ATTACHMENT-010 body (lines 2463–2494) contains no P22 references. The P22 prd-delta disposition confirmed: "H-NEW-ATTACHMENT-008 Setup step 2 and H-NEW-ATTACHMENT-010 Expected line 5 both already assert the pre-gate GETs fire — coherent with corrected phrasing; no changes needed (P22-001(d))."

**List B EMPTY confirmed** ✓.

---

## Keystone Coherence Checks

### K-1: Corrected BC-3.9.003 bullet ↔ EC-3.9.003-7 ↔ BC-3.9.005 ↔ H-NEW-ATTACHMENT-008

| Element | Claim | Source |
|---------|-------|--------|
| BC-3.9.003 Step 0 | Issue GET + `get_or_fetch_project_meta` run unconditionally; 404 → exit 64 | bc-3 line 3308 |
| EC-3.9.003-7 | Guard order: (1) eligibility check [BC-3.9.005 via meta]; (2) non-interactive branch; (3) --yes/prompt | bc-3 line 3330 |
| BC-3.9.003 non-interactive bullet | "exit 64 before any servicedeskapi call and before any upload POST (Step-0 issue GET + meta resolution have already run — EC-3.9.003-7 evaluates eligibility first)" | bc-3 line 3317 |
| BC-3.9.005 | `--public` on non-JSM → exit 64 (eligibility gate; uses meta from Step 0) | bc-3 line 3378 |
| H-NEW-ATTACHMENT-008 Setup step 2 | Mounts issue GET (SOFTWARE-1) + project meta GET (SOFTWARE); no servicedeskapi mount; strict-mode | holdout-scenarios.md line 2412–2414 |
| H-NEW-ATTACHMENT-008 Expected | Exit 64; zero servicedeskapi calls; zero platform POST | holdout-scenarios.md line 2418–2423 |

Story: Step 0 (issue GET + meta) always runs → EC-3.9.003-7 eligibility check (non-JSM exit 64 per BC-3.9.005, or pass for JSM) → if JSM, non-interactive branch → exit 64 before servicedeskapi calls. H-NEW-ATTACHMENT-008 mounts both pre-gate GETs and asserts zero servicedeskapi calls. Guard order and wire story coherent. ✓

**K-1 COHERENT ✓**

---

### K-2: BC-3.9.012 Non-Interactive Row Trigger ↔ Sibling Non-JSM Row — Consistent Vocabulary

| Element | Trigger text | Source |
|---------|-------------|--------|
| Non-interactive without `--yes` (`--public`) row | `local (after Step-0 issue GET + meta fetch)` | bc-3 line 3552 |
| `--public` on non-JSM issue row | `local (after meta fetch)` | bc-3 line 3551 |

Both rows use "local (after ... meta fetch)" — indicating a locally-evaluated guard that fires after HTTP pre-flight calls (meta fetch, with the non-interactive row additionally noting the issue GET). The vocabulary is consistent and complementary. ✓

**K-2 COHERENT ✓**

---

### K-3: EC-3.9.016-6 ↔ BC-3.9.013 ↔ BC-3.9.010 ↔ H-NEW-ATTACHMENT-012

| Element | Claim | Source |
|---------|-------|--------|
| EC-3.9.016-6 | "issue the DELETE wire call of BC-3.9.008 for each AID serially; 404 handling per BC-3.9.013 bulk exception (benign skip)" | bc-3 line 3719 |
| BC-3.9.013 multi-delete exception | "on multi-attachment delete paths (`--older-than`, multi-AID bulk per BC-3.9.016, ...): 404 = already-deleted (benign race), silently skipped; iteration continues" | bc-3 line 3588 |
| BC-3.9.010 | JSON output shape for bulk delete: count, deleted, ids | bc-3 line ~3494 |
| H-NEW-ATTACHMENT-012 | 3-AID delete, middle AID 404 → exit 0; count=2; ids=[40001,40003]; wiremock asserts 3 DELETE calls | holdout-scenarios.md line ~2544 |

EC-3.9.016-6 explicitly references BC-3.9.013 for 404 handling and BC-3.9.010 for JSON shape. BC-3.9.013 multi-delete exception covers the BC-3.9.016 path by enumeration. H-NEW-ATTACHMENT-012 exercises the exact EC-3.9.016-6 behavior: middle-AID 404 is benign-skipped, iteration continues to AID 40003. ✓

**K-3 COHERENT ✓**

---

### K-4: BC-2.7.012 Prose ↔ Its Own Table Row ↔ BC-2.7.007

| Element | Claim | Source |
|---------|-------|--------|
| BC-2.7.012 body prose | "Unknown issue key (batch paths only — `--all`/`--newest`; the `--id` path does not server-verify KEY per BC-2.7.007)" | bc-2 line 926 |
| BC-2.7.012 table row | "KEY 404 (batch paths only — `--id` does not server-verify KEY per BC-2.7.007)" | bc-2 line 939 |
| BC-2.7.007 | `--id` path issues `GET /rest/api/3/attachment/{id}` (direct attachment GET); no issue GET, no KEY verification | bc-2 line ~745 |

Prose and table row now agree: both say "batch paths only" and "–-id does not server-verify KEY per BC-2.7.007". BC-2.7.007 licenses the `--id` path characterization. ✓

**K-4 COHERENT ✓**

---

## Cross-Reference Validation

### BC Counts

| Source | bc-2 definitional | bc-2 total_bcs | bc-3 definitional | bc-3 total_bcs | Grand Total |
|--------|-------------------|-----------------|-------------------|-----------------|-------------|
| Frontmatter | 64 | 106 | 111 | 140 | 657 |
| CANONICAL-COUNTS.md | 64 | 106 | 111 | 140 | 657 |
| Guard output | verified | — | verified | — | 657 |

P22 added 0 new BCs. PASS ✓

### Holdout Counts

| Source | Count | Status |
|--------|-------|--------|
| `holdout-scenarios.md` frontmatter `total_holdouts` | 100 | PASS ✓ |
| `CANONICAL-COUNTS.md` canonical total | 100 | PASS ✓ |
| `prd-delta-576.md` frontmatter `holdout_count_after` | 100 | PASS ✓ (unchanged from P21) |
| `prd-delta-576.md` P22 closing | "Holdout count: 100 (unchanged)" | PASS ✓ |
| `spec-changelog.md` [1.3.62] count table | "Holdout count: 100 (unchanged)" | PASS ✓ |

### VP Counts

| Source | VP count reference | Status |
|--------|-------------------|--------|
| `prd-delta-576.md` P22 closing | "VP count: 35 (unchanged)" | PASS ✓ |
| `bc-3-issue-write.md` footer | "VP count 35 (unchanged)" | PASS ✓ |
| `BC-INDEX.md` last_updated | "VP count 35 (unchanged)" | PASS ✓ |
| `spec-changelog.md` [1.3.62] count table | "VP count: 35 (unchanged)" | PASS ✓ |

---

## Spec Version Surface Verification

| Artifact | Spec version shown | Status |
|----------|--------------------|--------|
| `spec-changelog.md` | `[1.3.62] - 2026-07-16` entry present | PASS ✓ |
| `bc-3-issue-write.md` frontmatter trace | v1.3.62 entry at line 96 | PASS ✓ |
| `bc-3-issue-write.md` footer | "spec v1.3.62" | PASS ✓ |
| `BC-INDEX.md` `last_updated` | "spec v1.3.62" in P22 note | PASS ✓ |
| `prd-delta-576.md` frontmatter `spec_version_after` | `1.3.62` | PASS ✓ |
| `bc-2-issue-read.md` frontmatter trace | v1.3.62 entry at line 17 (P22-003 entry) | PASS ✓ |
| `STATE.md` `current_step` | stale (carries INFO-8) | STALE (INFO-8 carries forward) |

---

## INFO Ledger Status

### INFO-1 (carry-forward R21–R32) — CARRY-FORWARD

Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7 in bc-2. Not introduced or worsened by P22. Non-blocking.

**Status**: CARRY-FORWARD

---

### INFO-2 (carry-forward R21–R32) — CARRY-FORWARD

EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained. Not introduced or worsened by P22. Non-blocking.

**Status**: CARRY-FORWARD

---

### INFO-3 (carry-forward R21–R32) — CARRY-FORWARD

BC-2.7.012 "KEY or AID 5xx" combined-scope row. Not introduced or worsened by P22. Non-blocking.

**Status**: CARRY-FORWARD

---

### INFO-4 (carry-forward R22–R32) — CARRY-FORWARD

H-NEW-ATTACHMENT-003 BC refs footer does not list `BC-2.7.008 EC-2.7.008-6` for Call B2. Not introduced or worsened by P22. Non-blocking.

**Status**: CARRY-FORWARD

---

### INFO-6 (carry-forward R23–R32) — CARRY-FORWARD

No holdout for the collision-skip exit-0 path. Not introduced or worsened by P22. Non-blocking.

**Status**: CARRY-FORWARD

---

### INFO-8 (carry-forward R25–R32)

`STATE.md` spec version stale. Non-blocking.

**Status**: CARRY-FORWARD (spec version stale; should be v1.3.62 after P22; was stale at v1.3.56 per r31 — now even more stale)

---

### INFO-11 (carry-forward R27–R32) — CARRY-FORWARD

`spec-changelog.md` [1.3.57] and `prd-delta-576.md` P17-002 disposition say "three sites" but four sites were actually modified. Not introduced or worsened by P22. Non-blocking.

**Status**: CARRY-FORWARD

---

### INFO-12 (carry-forward R27–R31) — RESOLVED

`bc-3-issue-write.md` BC-3.9.003 Trace was missing P17-003 citation (R27 through R31). **NOW RESOLVED**: BC-3.9.003 Trace (line 3332) now includes: `"P17-003 (EC-3.9.003-5 Step-0 suppression: when entered from BC-3.9.017 step 4, Step 0 SKIPPED — existence validated by step 1's \`?fields=attachment\` GET; ONE issue GET per invocation on combined \`--replace-existing --public\` path)"`. The P22-001 Trace update included the retroactive P17-003 citation.

**Status**: RESOLVED ✓

---

### INFO-13 (carry-forward R28–R32) — CARRY-FORWARD

`error-taxonomy.md` row 95 issue-GET 403 sub-variant lacks BC-2.7.006 citation. Not introduced or worsened by P22. Non-blocking.

**Status**: CARRY-FORWARD

---

### INFO-14 (carry-forward R29–R31, RE-OPENED in R31) — RESOLVED

`spec-changelog.md` explicit count rows pattern: [1.3.61] was reported in r31 as missing BC count / VP count / Spec version rows. **NOW RESOLVED**: [1.3.61] entry was micro-fixed and now contains:

```
| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 99→100 (+1 H-NEW-ATTACHMENT-012) |
| VP count | 35 (unchanged) |
| Spec version | 1.3.60→1.3.61 |
```

(spec-changelog.md lines 68–73). The pattern established at [1.3.60] is now consistently followed in [1.3.61] and [1.3.62].

**Status**: RESOLVED ✓

---

### INFO-15 (carry-forward R29–R32) — CARRY-FORWARD

`impact-boundary-576.md` BC-3.9.004 row has INCONCLUSIVE annotation. BC-3.9.004 is now fully defined (P20-001 + P21-004). Impact-boundary row not updated. Non-blocking (conservative annotation; impact-boundary is not part of the primary spec chain).

**Status**: CARRY-FORWARD

---

### INFO-NEW-2 (NEW R31) — RESOLVED

Sub-item 1: `spec-changelog.md` [1.3.61] missing explicit count rows — **RESOLVED** (count rows micro-added; see INFO-14 above).

Sub-item 2: BC-2.7.012 Trace in `bc-2-issue-read.md` body missing P21-006 citation — **RESOLVED**: Trace (line 949) now reads `"P21-006 (KEY-404 batch-paths-only annotation — \`--id\` does not server-verify KEY per BC-2.7.007)"`. P21-006 citation present.

**Status**: RESOLVED ✓

---

### INFO-NEW-3 (NEW R31) — RESOLVED

`bc-2-issue-read.md` frontmatter trace was not updated for P20 or P21 passes (last entry was P19, spec v1.3.59). **NOW RESOLVED**: frontmatter trace now includes:

- Line 16: `"  - SOH-ATTACHMENTS-1 adversary pass-21 (2026-07-16): BC-2.7.012 KEY-404 batch-paths-only annotation — \`--id\` does not server-verify KEY per BC-2.7.007 (P21-006); spec v1.3.61"`
- Line 17: `"  - SOH-ATTACHMENTS-1 adversary pass-22 (2026-07-16): BC-2.7.012 body prose \"Unknown issue key\" sentence prepended with batch-only caveat (P22-003); spec v1.3.62"`

Note: P20 passes that modified bc-2 (P20-003 BC-2.7.007 `--out` clause; P20-004 impact-boundary retro-annotation; P20-006 VP-576-004) are still absent from the frontmatter trace. Non-blocking: the content changes are present and correct; P21-006 and P22-003 are now captured.

**Status**: PARTIALLY RESOLVED ✓ (P21-006 and P22-003 now present; P20 passes still absent — non-blocking carry)

---

### INFO-NEW-1 (NEW R32)

`bc-2-issue-read.md` BC-2.7.012 body Trace field (line 949) does not cite P22-003. Current Trace ends with `"P21-006 (KEY-404 batch-paths-only annotation — \`--id\` does not server-verify KEY per BC-2.7.007)"`. The P22-003 change (prose batch-only caveat) is documented in the bc-2 frontmatter trace (line 17) and in BC-INDEX.md BC-2.7.012 row (P22-003 citation), but not in the BC-2.7.012 body Trace field. Non-blocking: the bc-2 frontmatter trace and BC-INDEX both correctly cite P22-003. The pattern is analogous to r31's INFO-NEW-2 sub-item 2 (P21-006 missing from Trace body — now resolved).

**Severity**: INFO. Non-blocking.

---

## Findings

### Critical

None.

### Major

None.

### GAPs

None.

### Resolved This Round

- **INFO-12** (R27–R31): BC-3.9.003 Trace now includes P17-003 citation. RESOLVED.
- **INFO-14** (R29–R31, RE-OPENED R31): spec-changelog [1.3.61] count rows micro-added. RESOLVED.
- **INFO-NEW-2** (R31): [1.3.61] count rows added (sub-1); BC-2.7.012 Trace P21-006 added (sub-2). RESOLVED.
- **INFO-NEW-3** (R31): bc-2 frontmatter trace now has P21-006 + P22-003 entries. PARTIALLY RESOLVED (P20 passes still absent, non-blocking).

### Minor (INFO)

- **INFO-1** (carry R21–R32): Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7.
- **INFO-2** (carry R21–R32): EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained.
- **INFO-3** (carry R21–R32): BC-2.7.012 "KEY or AID 5xx" combined-scope row.
- **INFO-4** (carry R22–R32): H-NEW-ATTACHMENT-003 BC refs footer missing EC-2.7.008-6 for Call B2.
- **INFO-6** (carry R23–R32): No holdout for collision-skip exit-0 path.
- **INFO-8** (carry R25–R32): STATE.md spec version stale (should be v1.3.62).
- **INFO-11** (carry R27–R32): P17-002 "three sites" undercount in spec-changelog/prd-delta.
- **INFO-13** (carry R28–R32): error-taxonomy row 95 issue-GET 403 lacks BC-2.7.006 citation.
- **INFO-15** (carry R29–R32): impact-boundary BC-3.9.004 INCONCLUSIVE annotation; BC-3.9.004 now fully defined.
- **INFO-NEW-1** (NEW R32): BC-2.7.012 body Trace missing P22-003 citation (non-blocking; bc-2 frontmatter trace + BC-INDEX correctly cite P22-003).

---

## Validation Gate Result

**CONSISTENT**

All 3 P22 fix-round items and 1 INFO disposition (P22-001..P22-004) correctly applied. No behavioral GAPs. ECHO-BREAKER audit of 4 List-A sentences found no over-claims — including sentence 1 special scrutiny (EC-3.9.003-7 parenthetical accurately describes eligibility ordering: Step 0 runs → EC-3.9.003-7 eligibility check → non-interactive branch; "EC-3.9.003-7 evaluates eligibility first" is accurate and licensed). List-B verified empty (no VP or holdout body text modified by P22). SPOT-AUDIT of 8 KEEP "before any HTTP" instances confirmed all 8 are genuinely pre-HTTP on their own path. Residue scans: "before any HTTP" absent from BC-3.9.003 non-interactive bullet and BC-3.9.012 trigger row; "proceed to BC-3.9.008" absent from EC-3.9.016-6. Double-insertion sweep clean. Keystones K-1..K-4 coherent: guard-order + wire story consistent across BC-3.9.003 bullet/EC-3.9.003-7/BC-3.9.005/H-008 (K-1); BC-3.9.012 trigger vocabulary consistent with sibling non-JSM row (K-2); EC-3.9.016-6/BC-3.9.013/BC-3.9.010/H-012 coherent (K-3); BC-2.7.012 prose/table/BC-2.7.007 aligned (K-4). Spec version 1.3.62 consistent across all spec surfaces. BC count 657 / holdout count 100 / VP count 35 confirmed by both guards (exit 0). INFO ledger: INFO-12 RESOLVED (P17-003 now in BC-3.9.003 Trace); INFO-14 RESOLVED ([1.3.61] count rows added); INFO-NEW-2 RESOLVED (both sub-items); INFO-NEW-3 PARTIALLY RESOLVED (P21/P22 entries added; P20 still absent, non-blocking). 10 carry-forward INFOs, 1 new INFO (INFO-NEW-1: BC-2.7.012 body Trace missing P22-003 citation).

---

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 35 |
| **Passed** | 35 |
| **Resolved** | 4 (INFO-12; INFO-14; INFO-NEW-2 both sub-items; INFO-NEW-3 partial) |
| **Failed (GAPs)** | 0 |
| **Warnings (INFO)** | 10 carry-forward + 1 new (INFO-1..4 carry; INFO-6 carry; INFO-8 carry; INFO-11, INFO-13, INFO-15 carry; INFO-NEW-1 new) |
| **Overall Status** | consistent |

Round 32 is a PATCH-level validation confirming 3 P22 adversary-pass fixes + 1 P22 INFO disposition: (1) BC-3.9.003 non-interactive bullet corrected from "exit 64 before any HTTP" to "exit 64 before any servicedeskapi call and before any upload POST (the Step-0 issue GET and project-meta resolution have already run — EC-3.9.003-7 evaluates eligibility first)"; BC-3.9.012 trigger column corrected from "local" to "local (after Step-0 issue GET + meta fetch)"; mechanical sweep of ~25 "before any HTTP" instances confirmed all remaining are genuinely pre-HTTP; H-008/H-010 coherent (no changes needed) (P22-001 MEDIUM); (2) EC-3.9.016-6 "proceed to BC-3.9.008 for each AID serially" replaced with "issue the DELETE wire call of BC-3.9.008 for each AID serially; 404 handling per BC-3.9.013 bulk exception (benign skip); JSON shape per BC-3.9.010" — removes ambiguous "proceed to" that imported single-AID exit-64 semantics into bulk path (P22-002 LOW); (3) BC-2.7.012 body prose "Unknown issue key" sentence prepended with "(batch paths only — --all/--newest; the --id path does not server-verify KEY per BC-2.7.007)" — aligns prose with P21-006 table annotation (P22-003 LOW); (4) NEW-R4-002 deferral text confirmed present, no action (P22-004 INFO). BC-INDEX v6.21→v6.22. spec-changelog [1.3.62] present with both artifact + count tables. prd-delta-576.md spec_version_after 1.3.62 + P22 dispositions section. No double-insertions despite hook-timeout risk. Spec version advances to 1.3.62. BC count 657 / holdout count 100 / VP count 35 (all unchanged). INFO-12 RESOLVED (P17-003 in BC-3.9.003 Trace). INFO-14 RESOLVED ([1.3.61] count rows added). INFO-NEW-2/3 RESOLVED (per micro-fix claims verified by quote).

---

## Appendix: Validation Methodology

This report was produced by a fresh-context consistency validator (cv-f2-576-r32) with structural reference to r31 report only.

1. **Independent artifact read**: All 7 input artifacts read fresh. Findings formed independently from artifact text.
2. **Quote-based closure**: Every P22 priority check verified by verbatim quotation from the authoritative artifact.
3. **Double-insertion sweep**: Exact marker occurrence counts verified for v1.3.62, P22-001/002/003, EC-3.9.016-6, "Adversary Pass 22" section heading. All counts explained by distinct legitimate locations.
4. **"before any HTTP" residue scan**: grep of `.factory/specs/prd/` for "before any HTTP" confirmed: zero instances remaining on BC-3.9.003 non-interactive path or BC-3.9.012 non-interactive row. All other instances reviewed and ≥8 KEEP instances independently verified as genuinely pre-HTTP.
5. **ECHO-BREAKER List A (4 sentences)**: Sentence 1 given special scrutiny — EC-3.9.003-7 parenthetical traced to ordering guarantee (Step 0 → eligibility check → non-interactive branch). All 4 sentences traced to licensing sources with no over-claim.
6. **ECHO-BREAKER List B**: Verified empty by confirming no P22 references in VP-576-* or H-NEW-ATTACHMENT-* body text.
7. **Keystone checks**: K-1 through K-4 verified against quoted text from each referenced source. Guard-order story, trigger vocabulary, bulk-delete wire story, and BC-2.7.012 prose/table alignment all coherent.
8. **Guard scripts**: Both `check-spec-counts.sh` and `check-bc-cumulative-counts.sh` executed and verified "OK".
9. **Count sweep**: BC (657), holdout (100), VP (35) verified across BC-INDEX frontmatter, bc-2/bc-3 frontmatter, prd-delta-576.md P22 closing, spec-changelog [1.3.62] count table, and holdout-scenarios.md frontmatter.
10. **INFO ledger re-verification**: r31 INFO-NEW-2/3 micro-fix claims verified by quoting the restored/added text. INFO-12 (P17-003 in BC-3.9.003 Trace) and INFO-14 ([1.3.61] count rows) verified as resolved. 4 INFOs resolved this round.
