---
document_type: consistency-report
round: 30
spec_version: 1.3.60
date: 2026-07-16
validator: cv-f2-576-r30 (fresh context, no prior round visibility)
verdict: CONSISTENT
bc_count: 657
holdout_count: 99
vp_count: 35
priority_checks: P20-001 (BC-3.9.004 Step 0 + HTTP sequences + H-011), P20-002 (BC-3.9.014 N≤3 template), P20-003 (BC-2.7.007 unconditional step-1), P20-004 (impact-boundary download row), P20-005 (prd-delta S3+S5 split notes), P20-006 (VP-576-004 + VP-576-005, VP 33→35), BC-INDEX v6.20, spec-changelog [1.3.60], prd-delta P20 dispositions, double-insertion sweep, echo-breaker audit (8 sentences), K-1..K-5 keystones, guard output
level: ops
version: "1.0"
status: consistent
producer: cv-f2-576-r30
timestamp: 2026-07-16T00:00:00
phase: 2
inputs:
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/specs/prd/CANONICAL-COUNTS.md"
  - ".factory/spec-changelog.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
  - ".factory/phase-f1-delta-analysis/impact-boundary-576.md"
input-hash: "129064d"
traces_to: ".factory/specs/prd/BC-INDEX.md"
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 30 (post-P20 remediation)

**Spec version**: 1.3.60 | **BCs**: 657 | **Holdouts**: 99 | **VPs**: 35 | **Verdict**: CONSISTENT

---

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) — SOH-ATTACHMENTS-1 F2 |
| **Generated** | 2026-07-16T00:00:00 |
| **Generator** | cv-f2-576-r30 (fresh-context consistency validator, round 30) |
| **Artifacts Scanned** | 8 (bc-2-issue-read.md, bc-3-issue-write.md, holdout-scenarios.md, BC-INDEX.md, CANONICAL-COUNTS.md, spec-changelog.md, prd-delta-576.md, impact-boundary-576.md) |
| **Focus** | Post-P20 adversary-pass remediation verification — spec v1.3.59 → v1.3.60; hook-timeout double-insertion risk |
| **Prior round** | consistency-report-576-r29.md (GAPS-FOUND: GAP-P19-FWD-001 prd-delta version stale) |

---

## Summary Table

| # | Check | Result |
|---|-------|--------|
| P20-001 | BC-3.9.004 Step 0 inheritance clause added + JSM branch HTTP sequence | pass |
| P20-001 | BC-3.9.004 non-JSM OQ-9 HTTP sequence enumerated | pass |
| P20-001 | BC-3.9.004 Trace updated with P20-001 citation | pass |
| P20-001 | H-NEW-ATTACHMENT-011 added to holdout-scenarios.md; mirrors H-008 style | pass |
| P20-001 | Holdout total 98→99 in holdout-scenarios.md frontmatter, preamble, CANONICAL-COUNTS.md | pass |
| P20-001 | BC-INDEX.md BC-3.9.004 row updated | pass |
| P20-002 | BC-3.9.014 N≤3 prompt template uses `<filenameN>` — no `, ...` | pass |
| P20-002 | No other surface carries the old `, ...` template for N≤3 variant | pass |
| P20-003 | BC-2.7.007 unconditional step-1 clause present | pass |
| P20-003 | BC-INDEX.md BC-2.7.007 row updated | pass |
| P20-004 | impact-boundary-576.md §1.1 download row retro-annotated | pass |
| P20-005 | prd-delta-576.md Scope table S3 row BC-3.9.017 split note added | pass |
| P20-005 | prd-delta-576.md Scope table S5 row BC-3.9.017 split note added | pass |
| P20-006 | VP-576-004 added to BC-2.7.002 body | pass |
| P20-006 | VP-576-005 added to BC-3.9.017 body | pass |
| P20-006 | VP count 33→35 in bc-3 footer, BC-INDEX, prd-delta-576.md P20 closing, spec-changelog | pass |
| BC-INDEX v6.20 | index_version v6.19→v6.20; last_updated; VP 33→35, holdout 98→99 noted | pass |
| spec-changelog [1.3.60] | Entry present; BC/holdout/VP count rows in Impact Assessment | pass |
| prd-delta-576.md spec_version_after 1.3.60 | frontmatter updated; holdout_count_after 99; P20 section present | pass |
| Double-insertion sweep | No duplicate v1.3.60 trace, H-011 heading, VP-576-004/005, [1.3.60] entry, P20 section | pass |
| K-1 | BC-3.9.004 wire sequences ↔ BC-3.9.003 Step 0 ↔ BC-3.9.005 detection ↔ BC-X.8.010 ↔ H-011 fixture | pass |
| K-2 | H-011 assertion style ↔ H-008 zero-servicedeskapi pattern | pass |
| K-3 | VP-576-004 ↔ BC-2.7.002 authority clause ↔ BC-3.9.009 | pass |
| K-4 | VP-576-005 ↔ EC-3.9.017-8/11/12 | pass |
| K-5 | Unconditional step-1 ↔ EC-2.7.007-1 404-source uniformity | pass |
| Echo-breaker (8 sentences) | All P20-authored behavioral sentences grounded in licensing sources; no over-claims | pass |
| Counts 657/99/35 | Consistent across BC-INDEX, spec-changelog, prd-delta, holdout-scenarios, CANONICAL-COUNTS, bc-3 footer | pass |
| Guard: check-spec-counts.sh | OK: all spec counts verified | pass |
| Guard: check-bc-cumulative-counts.sh | OK: all cumulative BC counts verified (657 total across 8 files) | pass |
| GAP-P19-FWD-001 resolution | prd-delta-576.md frontmatter 1.3.59→1.3.60 + P19 section appended (confirmed; GAP closed) | pass |
| INFO-NEW-1 | CANONICAL-COUNTS.md Group 19 range + reconciliation Note paragraph stale (99 correct; note says 98) | INFO |

**No behavioral GAPs found. All P20 changes correctly applied. Echo-breaker audit of 8 sentences found no over-claims. Double-insertion sweep found no duplicates. Spec version 1.3.60 consistent. Counts 657/99/35 verified by guards.**

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

## P20-001 — BC-3.9.004 Restructured (Step 0 + HTTP Sequences + H-NEW-ATTACHMENT-011)

### BC-3.9.004 Step 0 Inheritance Clause

**Quote-verified verbatim** (`bc-3-issue-write.md` BC-3.9.004 Step 0, line 3342):

> `**Step 0 — issue existence validation and project type detection (inherits BC-3.9.003 Step 0 + BC-3.9.005 detection mechanism; P20-001)**: \`GET /rest/api/3/issue/{key}\` (existence validation). If the issue does not exist or is inaccessible → 404 → exit 64 per EC-3.9.012-2. On success, \`fields.project.key\` is extracted and passed to \`get_or_fetch_project_meta\` (\`GET /rest/api/3/project/{key}\`, cache-backed; BC-3.9.005 detection mechanism, BC-X.8.010). The \`projectTypeKey\` returned determines which branch executes.`

Step 0 inheritance clause present with P20-001 citation. ✓

### BC-3.9.004 JSM Branch (a) HTTP Sequence

**Quote-verified** (`bc-3-issue-write.md` line 3344):

> `**(a) JSM branch** (\`projectTypeKey == "service_desk"\`): routes to the servicedeskapi two-step flow identical to BC-3.9.003 but with \`"public": false\` in the second-step body. HTTP sequence: step 0 issue GET → project GET (cache-miss only) → N × POST \`.../attachTemporaryFile\` → 1 × POST \`.../request/{issueKey}/attachment\`.`

All four steps of the JSM HTTP sequence present: issue GET, project GET (cache-miss), N × attachTemporaryFile, 1 × request-attachment. ✓

### BC-3.9.004 Non-JSM OQ-9 Branch (b) HTTP Sequence

**Quote-verified** (`bc-3-issue-write.md` line 3351):

> `**(b) Non-JSM branch — OQ-9 silent no-op** (\`projectTypeKey != "service_desk"\`): \`jr\` falls back silently to the platform POST path (BC-3.9.001). HTTP sequence: step 0 issue GET → project GET (cache-miss only) → platform POST \`/rest/api/3/issue/{key}/attachments\`; zero servicedeskapi calls issued. No error is emitted, no warning is written. Rationale: platform POST is already internal by default (P2-4a); \`--internal\` expresses intent that is already satisfied — silently. This is the OQ-9 design ruling from DEC-179.`

Non-JSM OQ-9 HTTP sequence: issue GET → project GET (cache-miss) → platform POST; zero servicedeskapi calls. ✓

### BC-3.9.004 Trace Updated

**Quote-verified** (`bc-3-issue-write.md` BC-3.9.004 Trace, line 3359):

> `P20-001 (Step 0 inheritance: issue GET + \`get_or_fetch_project_meta\` detection; full HTTP sequence for JSM branch (a) and non-JSM OQ-9 branch (b))`

Trace updated with P20-001 citation. ✓

### H-NEW-ATTACHMENT-011

**Quote-verified** (`holdout-scenarios.md`, line 2498):

> `### H-NEW-ATTACHMENT-011: \`attachment upload <NON-JSM-KEY> <FILE> --internal\` → exit 0, silent platform POST, zero servicedeskapi calls (MUST-PASS)`

Heading unique (one heading occurrence at line 2498; one reference in preamble trace at line 22). ✓

**Setup verified** (lines 2498–2525): Setup mounts `GET /rest/api/3/issue/SOFTWARE-1` → non-JSM issue; `GET /rest/api/3/project/SOFTWARE` → `{"projectTypeKey":"software"}`; `POST /rest/api/3/issue/SOFTWARE-1/attachments` → upload success. Wiremock strict-mode asserts zero servicedeskapi requests. This exactly mirrors the non-JSM OQ-9 HTTP sequence from BC-3.9.004(b). ✓

**H-008 assertion style comparison**: H-008 (line 2404) uses wiremock strict-mode to assert zero servicedeskapi calls on a `--public` non-JSM failure path (exit 64). H-011 uses the same strict-mode pattern on a `--internal` non-JSM success path (exit 0). "Why hidden" section explicitly states: "Mirrors H-NEW-ATTACHMENT-008 assertion style (BC-3.9.005 `--public` non-JSM exit-64 path — symmetric contrast: `--internal` silently succeeds; `--public` exits 64)." ✓

### Holdout Count 98→99

| Surface | Count | Status |
|---------|-------|--------|
| `holdout-scenarios.md` frontmatter `total_holdouts` | 99 | PASS ✓ |
| `holdout-scenarios.md` body preamble | 99 | PASS ✓ |
| `CANONICAL-COUNTS.md` canonical total | 99 | PASS ✓ |
| `CANONICAL-COUNTS.md` enumeration | includes H-NEW-ATTACHMENT-001..H-NEW-ATTACHMENT-011 | PASS ✓ |
| `prd-delta-576.md` frontmatter `holdout_count_after` | 99 | PASS ✓ |
| spec-changelog [1.3.60] Impact Assessment | 98→99 | PASS ✓ |

**Result**: APPLIED ✓. BC-3.9.004 fully restructured with Step 0 + both HTTP sequences. H-NEW-ATTACHMENT-011 added and mirrors H-008. Holdout count 99 consistent everywhere.

---

## P20-002 — BC-3.9.014 N≤3 Prompt Template Fix

**Quote-verified** (`bc-3-issue-write.md` BC-3.9.014 prompt text, line 3609):

> `- \`--public\` only, N ≤ 3 files: \`"Upload <filename1>, <filename2>, <filenameN> to <KEY> as customer-visible (public)? [y/N] "\``

The `<filenameN>` placeholder represents the Nth filename; no `, ...` ellipsis present. ✓

**Quote-verified** (`bc-3-issue-write.md` EC-3.9.014-5, line 3626):

> `**EC-3.9.014-5** (\`--public\` only, N ≤ 3 files): prompt lists individual filenames; N > 3 → "N files" summary.`

EC-3.9.014-5 says "lists individual filenames" — consistent with `<filenameN>` placeholder (no ellipsis). ✓

**No-other-surface sweep**: The only `, ...` near upload/filename/public text in bc-3 is at line 3310 (`{"temporaryAttachmentIds": ["<id1>", ...]}` — JSON array notation in BC-3.9.003 Step 2; unrelated to BC-3.9.014 prompt text). No residual `, ...` in BC-3.9.014 prompt template area. ✓

**Result**: APPLIED ✓. P20-002 correctly removes `, ...`; `<filenameN>` placeholder used. EC-3.9.014-5 consistent.

---

## P20-003 — BC-2.7.007 Unconditional Step-1 Clause

**Quote-verified** (`bc-2-issue-read.md` BC-2.7.007, line 724):

> `**\`--out\` does NOT skip step 1 (UNCONDITIONAL two-step; P20-003)**: When \`--out <PATH>\` is supplied, \`GET /rest/api/3/attachment/{id}\` (step 1, metadata fetch) is issued unconditionally before any download begins. Rationale: uniform wire story + pre-stream existence validation — if the AID does not exist or is inaccessible, \`jr\` exits 64 (EC-2.7.007-1 / EC-2.7.007-1b) before writing any bytes to the specified output path. The accepted cost is one extra GET per download on the \`--out\` path.`

Unconditional step-1 clause present with P20-003 citation. Rationale stated (uniform wire story + pre-stream existence validation). Accepted cost stated (one extra GET). ✓

**BC-INDEX BC-2.7.007 row** (`BC-INDEX.md` line 226):

> `**\`--out\` does NOT skip step 1 (P20-003, UNCONDITIONAL two-step)**: step 1 issued regardless of \`--out\`; rationale: pre-stream existence validation; accepted cost: one extra GET`

BC-INDEX.md BC-2.7.007 row updated with `--out` unconditional note and P20-003 citation. ✓

**Result**: APPLIED ✓.

---

## P20-004 — impact-boundary-576.md Download Row Retro-Annotation

**Quote-verified** (`impact-boundary-576.md` §1.1 download row, line 56):

> `| \`handle_attachment_download\` | \`jr issue attachment download <KEY>\` | Mixed (profile 3): no stdout data *(superseded: delivered spec adds --output json manifest to stdout, EC-2.7.007-7; human mode remains no-stdout-data)*; progress/path hints to stderr; errors to stderr |`

Retro-annotation present per PHASE-DOC-RETRO-ANNOTATION pattern: "superseded: delivered spec adds --output json manifest to stdout, EC-2.7.007-7; human mode remains no-stdout-data". ✓

**Result**: APPLIED ✓.

---

## P20-005 — prd-delta-576.md S3+S5 BC-3.9.017 Split Notes

**Quote-verified** (`prd-delta-576.md` Scope table S3 row, line 33 extract):

> `**BC-3.9.017 split note (P20-005)**: non-public \`--replace-existing\` path (EC-3.9.017-1..10) ships with S3; combined \`--public\` ECs (EC-3.9.017-11/12) and the step-4 BC-3.9.003 public-routing are S5-realized (S5 depends_on S3 for gate mechanics).`

S3 BC-3.9.017 split note added with P20-005 citation. ✓

**Quote-verified** (`prd-delta-576.md` Scope table S5 row, line 35 extract):

> `**BC-3.9.017 split note (P20-005)**: combined \`--public\` ECs (EC-3.9.017-11/12: combined single-prompt, \`--yes\` bypass) and the step-4 BC-3.9.003 \`--public\` routing are S5-realized; S5 depends_on S3 for the underlying \`--replace-existing\` delete-and-upload mechanics.`

S5 BC-3.9.017 split note added with P20-005 citation. ✓

**Result**: APPLIED ✓.

---

## P20-006 — VP-576-004 + VP-576-005 Added; VP Count 33→35

### VP-576-004 (BC-2.7.002)

**Quote-verified** (`bc-2-issue-read.md` VP-576-004 body, line 612):

> `**VP-576-004**: curated attachment-object JSON transformation pin — \`jr issue attachment list <KEY> --output json\` and \`jr issue attachment upload <KEY> <FILE> --output json\` via wiremock: inspect every JSON object in the returned array and assert: (1) NO element contains a \`"self"\` key — the Jira API \`"self"\` field MUST be omitted from \`jr\` output; (2) every element contains a \`"contentUrl"\` key and NO element contains a \`"content"\` key — the Jira API \`"content"\` field MUST be renamed to \`"contentUrl"\`. These two invariants hold for ALL serialization paths — list (BC-2.7.002) and upload platform POST (BC-3.9.009). A regression that passes \`"self"\` through or emits \`"content"\` instead of \`"contentUrl"\` MUST fail these assertions. Pins BC-2.7.002 authority clause ("the \`'self'\` field MUST be omitted and \`'content'\` MUST be renamed to \`'contentUrl'\` across every code path that serializes a Jira attachment object"); cross-references BC-3.9.009 (upload JSON output authority). P20-006.`

VP-576-004 body present, anchored to BC-2.7.002, cross-referencing BC-3.9.009. ✓

### VP-576-005 (BC-3.9.017)

**Quote-verified** (`bc-3-issue-write.md` VP-576-005 body, line 3782):

> `**VP-576-005**: combined-gate single-prompt pin — \`jr issue attachment upload EJ-1 file.txt --replace-existing --public\` via wiremock against a JSM project with ≥1 same-filename match: (1) mount \`GET /rest/api/3/issue/EJ-1\`...; (4) set \`JR_STDIN_IS_TTY=1\`, pipe \`"y\n"\` to stdin;... Assert: (a) EXACTLY ONE prompt written to stderr — the combined variant... — no second prompt; (b) \`--yes\` variant...; (c) cancel variant: pipe \`"\n"\` (empty-Enter)... assert ZERO DELETE requests and ZERO servicedeskapi POST requests. Pins EC-3.9.017-11 (combined \`--public\` + ≥1 match → ONE prompt, not two), EC-3.9.017-12 (\`--yes\` single-bypass for all gate conditions), and the invariant "cancel at gate → zero DELETE + zero POST". P20-006; cross-ref BC-3.9.017, EC-3.9.017-11/12.`

VP-576-005 body present, with P20-006 citation and cross-references to EC-3.9.017-11/12. ✓

### VP Count 33→35 Surface Verification

| Surface | VP Count | Status |
|---------|----------|--------|
| `bc-3-issue-write.md` footer | "VP count 33→35; spec v1.3.60" | PASS ✓ |
| `BC-INDEX.md` last_updated | "VP count 33→35 (VP-576-004 + VP-576-005, P20-006)" | PASS ✓ |
| `prd-delta-576.md` P20 closing | "VP count: 35 (+2: VP-576-004, VP-576-005)" | PASS ✓ |
| `spec-changelog.md` [1.3.60] Impact Assessment | "VP count: 33→35 (+2: VP-576-004, VP-576-005)" | PASS ✓ |

**Result**: APPLIED ✓.

---

## BC-INDEX v6.19→v6.20

**Quote-verified** (`BC-INDEX.md` frontmatter, line 5–6):

```yaml
last_updated: 2026-07-16  # P20 adversary fix round: BC-3.9.004 row wire sequence + Step 0 inheritance (P20-001); BC-2.7.007 row --out unconditional step-1 clause (P20-003); VP count 33→35 (VP-576-004 + VP-576-005, P20-006); spec v1.3.60; BC count unchanged (657); holdout count 98→99; BC-INDEX v6.20. Previous: P19 ...
index_version: v6.20
```

`last_updated` updated to P20 note; `index_version` v6.19→v6.20. ✓

**BC-3.9.004 row** (`BC-INDEX.md` line 376):

> `| BC-3.9.004 | **Step 0 (P20-001, inherits BC-3.9.003 Step 0 + BC-3.9.005 detection)**: \`GET /rest/api/3/issue/{key}\` existence validation; \`get_or_fetch_project_meta\` → \`projectTypeKey\`. **(a) JSM branch** (\`projectTypeKey == "service_desk"\`): servicedeskapi two-step public:false; no confirmation gate; HTTP: issue GET → project GET (cache-miss) → N × attachTemporaryFile → request-attachment. **(b) Non-JSM OQ-9 silent no-op** (\`projectTypeKey != "service_desk"\`): platform POST \`/rest/api/3/issue/{key}/attachments\`; zero servicedeskapi calls; HTTP: issue GET → project GET (cache-miss) → platform POST. --internal + --public → clap exit 2 | — (SOH-ATTACHMENTS-1 F2; P20-001) |`

BC-3.9.004 row updated with Step 0 + both HTTP sequences. ✓

**BC-2.7.007 row** (`BC-INDEX.md` line 226):

> `... **\`--out\` does NOT skip step 1 (P20-003, UNCONDITIONAL two-step)**: step 1 issued regardless of \`--out\`; rationale: pre-stream existence validation; accepted cost: one extra GET ...`

BC-2.7.007 row updated. ✓

**Result**: BC-INDEX APPLIED ✓.

---

## spec-changelog [1.3.60]

**Quote-verified** (`spec-changelog.md`, entry at line 10):

```
## [1.3.60] - 2026-07-16

### Type: PATCH
```

Entry present; dated 2026-07-16. ✓

**Impact Assessment table** (`spec-changelog.md`, lines 38–45):

```
| BC count | 657 (unchanged) |
| Holdout count | 98→99 (+1 H-NEW-ATTACHMENT-011) |
| VP count | 33→35 (+2: VP-576-004, VP-576-005) |
| Spec version | 1.3.59→1.3.60 |
```

Explicit BC/holdout/VP count rows present. ✓ (This resolves INFO-14 pattern going forward: [1.3.60] includes explicit count rows that [1.3.59] lacked.)

**Changed Requirements list** (`spec-changelog.md`, lines 20–26): All 7 modified files listed: bc-3-issue-write.md, bc-2-issue-read.md, holdout-scenarios.md, CANONICAL-COUNTS.md, BC-INDEX.md, prd-delta-576.md, impact-boundary-576.md. ✓

**Result**: APPLIED ✓.

---

## prd-delta-576.md Frontmatter + P20 Section

**Quote-verified** (`prd-delta-576.md` frontmatter, lines 1–11):

```yaml
spec_version_after: 1.3.60
bc_count_after: 657
holdout_count_after: 99
```

`spec_version_after` updated to 1.3.60. `holdout_count_after` updated to 99. ✓

**Quote-verified** (`prd-delta-576.md` P20 section heading, line 378):

> `## Adversary Pass 20 Fix Round Finding Dispositions`

P20 dispositions section present (one heading — no duplicate). ✓

**P20 closing statement** (`prd-delta-576.md`, line 392):

> `**BC count at this round: 657 (unchanged). Holdout count: 99 (+1 H-NEW-ATTACHMENT-011). VP count: 35 (+2: VP-576-004, VP-576-005). Spec version: 1.3.60. Both guards exit 0.**`

Closing statement correct: BC 657 / holdout 99 / VP 35 / spec v1.3.60. ✓

**GAP-P19-FWD-001 resolved**: `prd-delta-576.md` `spec_version_after` is now 1.3.60 (was 1.3.58 at r29). P19 dispositions section was appended (the P19 disposition is present at lines ~362–374 based on reading during the session). GAP-P19-FWD-001 from r29 is CLOSED. ✓

**Result**: APPLIED ✓.

---

## Double-Insertion Sweep (Hook-Timeout Risk)

Given the P20 fix-round experienced hook timeouts on every edit (PO verified writes persisted), a targeted sweep for partial/double applications:

| Marker | Count | Lines | Assessment |
|--------|-------|-------|------------|
| `v1.3.60` in `bc-3-issue-write.md` | 2 | 94 (frontmatter trace), 3894 (footer) | EXPECTED — two distinct locations; no duplicate |
| `### H-NEW-ATTACHMENT-011` heading | 1 | 2498 | No duplicate heading |
| `H-NEW-ATTACHMENT-011` in holdout-scenarios | 2 | 22 (preamble trace), 2498 (heading) | EXPECTED — one reference + one heading |
| `VP-576-004` in `bc-2-issue-read.md` | 1 | 612 | No duplicate |
| `VP-576-005` in `bc-3-issue-write.md` | 3 | 94 (frontmatter trace), 3782 (VP body), 3894 (footer) | EXPECTED — three distinct locations; only one VP definition |
| `[1.3.60]` in `spec-changelog.md` | 1 | 10 | No duplicate |
| P20 dispositions section (`## Adversary Pass 20 Fix Round Finding Dispositions`) | 1 | 378 | No duplicate section heading |

**No double-insertions detected**. All marker counts are explainable by distinct legitimate locations. VP-576-005 appears 3 times (frontmatter trace, VP definition body, footer update note) — all three are different roles, not duplicates. The P20 dispositions heading appears once. ✓

---

## Echo-Breaker Audit

Eight newly-authored behavioral sentences from P20 are audited below. Special scrutiny on (a) BC-3.9.004 JSM-branch HTTP sequence and (b) EC-3.9.014-5 "no ellipsis" claim.

### Sentence 1: BC-3.9.004 Step 0 Inheritance (bc-3 line 3342)

**New text**: `"inherits BC-3.9.003 Step 0 + BC-3.9.005 detection mechanism; P20-001"`

**Licensing basis**: BC-3.9.003 Step 0 (line 3306) explicitly governs `GET /rest/api/3/issue/{key}` existence validation and `get_or_fetch_project_meta` → `projectTypeKey`. BC-3.9.005 is titled "`--public` on non-JSM issue → exit 64" and its body governs the detection mechanism (`get_or_fetch_project_meta` returning `projectTypeKey != "service_desk"` → exit 64). BC-3.9.004 Step 0 follows the exact same pattern. "Inherits" is accurate: identical GET sequence, identical `get_or_fetch_project_meta` call, identical 404-handling clause.

**Assessment**: Claim correctly describes the inheritance. No over-claim. ✓

### Sentence 2 (SPECIAL SCRUTINY): BC-3.9.004 JSM Branch HTTP Sequence (bc-3 line 3344)

**New text**: `"HTTP sequence: step 0 issue GET → project GET (cache-miss only) → N × POST \`.../attachTemporaryFile\` → 1 × POST \`.../request/{issueKey}/attachment\`"`

**Licensing basis** (each element traced to prior text):
- **Step 0 issue GET**: BC-3.9.003 Step 0 (existence validation) + BC-3.9.004 Step 0 inheritance. Both explicitly specify `GET /rest/api/3/issue/{key}`.
- **Project GET (cache-miss only)**: BC-3.9.003 Step 0 specifies `get_or_fetch_project_meta` as `GET /rest/api/3/project/{key}`, cache-backed per BC-X.8.010. "Cache-miss only" correctly qualifies that the GET fires only on cache miss; on cache hit the GET is skipped.
- **N × POST .../attachTemporaryFile**: BC-3.9.003 Step 1 (line 3308) explicitly states "For each `<FILE>`, POST `.../attachTemporaryFile`" — one per file, so N files = N POSTs. BC-3.9.004 Step 1 says "POST `.../attachTemporaryFile` per file (same as BC-3.9.003)."
- **1 × POST .../request/{issueKey}/attachment**: BC-3.9.003 Step 2 specifies "POST `.../request/{issueKey}/attachment`"; BC-3.9.004 Step 2 specifies the same endpoint with `"public": false`. One POST per invocation (not per file).

**Assessment**: All four HTTP sequence steps are licensed by pre-existing BC-3.9.003/BC-3.9.004 text. No behavioral over-claim. ✓

### Sentence 3 (SPECIAL SCRUTINY): BC-3.9.004 Non-JSM OQ-9 HTTP Sequence (bc-3 line 3351)

**New text**: `"HTTP sequence: step 0 issue GET → project GET (cache-miss only) → platform POST \`/rest/api/3/issue/{key}/attachments\`; zero servicedeskapi calls issued"`

**Licensing basis**:
- Issue GET and project GET: BC-3.9.004 Step 0 (inherited).
- Platform POST: BC-3.9.001 governs the platform POST path; OQ-9 ruling from DEC-179 routes `--internal` on non-JSM to this path.
- Zero servicedeskapi calls: OQ-9 ruling explicitly states no servicedeskapi calls on non-JSM; BC-3.9.004 body confirms "zero servicedeskapi calls issued."

**Assessment**: All elements licensed. No over-claim. ✓

### Sentence 4 (SPECIAL SCRUTINY): EC-3.9.014-5 "No Stated Ellipsis" Claim (bc-3 line 3609)

**Adversary-pass P20 claim**: "EC-3.9.014-5 claim that the ≤3 variant has 'no stated ellipsis in the body'"

**Current text** (bc-3 line 3609): `` `"Upload <filename1>, <filename2>, <filenameN> to <KEY> as customer-visible (public)? [y/N] "` ``

**Current EC-3.9.014-5 text** (bc-3 line ~3626): `**EC-3.9.014-5** (`--public` only, N ≤ 3 files): prompt lists individual filenames; N > 3 → "N files" summary.`

**Verification**: The ≤3 prompt template uses `<filenameN>` (representing the last filename), not `, ...`. EC-3.9.014-5 says "lists individual filenames" — no ellipsis terminology. The ONLY `, ...` occurrence near upload/filename content in bc-3 is at line 3310 (`{"temporaryAttachmentIds": ["<id1>", ...]}` — JSON array literal notation in BC-3.9.003, not BC-3.9.014). This is a completely separate context. The N≤3 prompt template area contains no `, ...`.

**Assessment**: The claim is correct: the ≤3 prompt template has no stated ellipsis. ✓

### Sentence 5: BC-2.7.007 Unconditional Step-1 Rationale (bc-2 line 724)

**New text**: `"Rationale: uniform wire story + pre-stream existence validation — if the AID does not exist or is inaccessible, \`jr\` exits 64 ... before writing any bytes to the specified output path."`

**Licensing basis**: EC-2.7.007-1 (line ~731) governs the not-found 404 on step 1 (`"Attachment <AID> not found or not accessible."`). The claim that `jr` exits 64 before writing bytes when AID is inaccessible is a product design decision that makes the existing step-1 behavior apply uniformly regardless of `--out`. No external verification required — this is a forward-looking design rationale, not a claim about current empirical behavior.

**Assessment**: Rationale is internally consistent with the BC framework. No over-claim. ✓

### Sentence 6: VP-576-004 Transformation Pin (bc-2 line 612)

**New text**: `"(1) NO element contains a \`"self"\` key ... (2) every element contains a \`"contentUrl"\` key and NO element contains a \`"content"\` key"`

**Licensing basis**: BC-2.7.002 authority clause (line ~608): "The `'self'` field MUST be omitted and `'content'` MUST be renamed to `'contentUrl'` across every code path that serializes a Jira attachment object." VP-576-004 directly translates this existing MUST into testable assertions. The two assertions (no `"self"`, no `"content"`, `"contentUrl"` present) are a mechanical translation of the authority clause, not new behavioral claims.

**Assessment**: VP-576-004 correctly pins BC-2.7.002 authority clause. No over-claim. ✓

### Sentence 7: VP-576-005 Single-Prompt Pin — Cancel Path (bc-3 line 3782)

**New text**: `"(c) cancel variant: pipe \`"\n"\` (empty-Enter) instead of \`"y\n"\` — assert ZERO DELETE requests and ZERO servicedeskapi POST requests."`

**Licensing basis**: EC-3.9.017-11 (line 3776) states: "single cancel path exits 0. `--yes` bypasses both in one bypass." BC-3.9.017 invariant (no destructive call → no gate fires). The "cancel → zero DELETE + zero POST" is directly pinned by EC-3.9.017-11's "NO DELETEs issued; NO upload POST issued" on cancel and the BC-3.9.017 destruction invariant.

**Assessment**: VP-576-005 cancel assertion is licensed by EC-3.9.017-11. No over-claim. ✓

### Sentence 8: VP-576-005 Single-Prompt Pin — Combined Gate (bc-3 line 3782)

**New text**: `"(a) EXACTLY ONE prompt written to stderr — the combined variant ... — no second prompt"`

**Licensing basis**: EC-3.9.017-11 (line 3776) states: "when `--public` AND ≥1 same-filename match are BOTH present, the gate in step 2 fires as ONE combined prompt (not two separate gates)." This is the pre-existing behavioral contract. VP-576-005 converts this "one combined prompt" statement into a testable assertion: EXACTLY ONE prompt, no second prompt.

**Assessment**: VP-576-005 prompt-count assertion is a direct translation of EC-3.9.017-11. No over-claim. ✓

---

**Echo-breaker audit result**: All 8 audited sentences are grounded in their licensing sources. The BC-3.9.004 JSM-branch HTTP sequence (Sentence 2 — SPECIAL SCRUTINY) traces all four steps to pre-existing BC-3.9.003 text. The EC-3.9.014-5 "no ellipsis" claim (Sentence 4 — SPECIAL SCRUTINY) is verified by direct read of the prompt template at bc-3 line 3609. No behavioral over-claims found.

---

## Keystone Coherence Checks

### K-1: BC-3.9.004 Wire Sequences ↔ BC-3.9.003 Step 0 ↔ BC-3.9.005 Detection ↔ BC-X.8.010 ProjectMeta ↔ H-NEW-ATTACHMENT-011 Fixture — ONE Coherent Wire Story

| Element | Claim | Source |
|---------|-------|--------|
| BC-3.9.003 Step 0 | `GET /rest/api/3/issue/{key}` + `get_or_fetch_project_meta` + `GET /rest/api/3/project/{key}` | bc-3 line 3306 |
| BC-3.9.004 Step 0 | Inherits BC-3.9.003 Step 0 + BC-3.9.005 detection mechanism | bc-3 line 3342 |
| BC-3.9.005 | `get_or_fetch_project_meta` determines projectTypeKey; non-service-desk → exit 64 (`--public` path) | bc-3 line ~3363 |
| BC-X.8.010 | `get_or_fetch_project_meta` cache-backed, 7-day TTL, per-(profile, projectKey) | BC-INDEX.md row BC-X.8.010 |
| BC-3.9.004(a) HTTP sequence | issue GET → project GET (cache-miss) → N × attachTemporaryFile → request-attachment | bc-3 line 3344 |
| BC-3.9.004(b) HTTP sequence | issue GET → project GET (cache-miss) → platform POST; 0 servicedeskapi | bc-3 line 3351 |
| H-NEW-ATTACHMENT-011 fixture | Mounts issue GET + project GET (returns software) + platform POST; strict-mode: 0 servicedeskapi | holdout-scenarios.md lines 2504–2516 |
| Call counts in H-011 | 1 issue GET, 1 project GET, 1 platform POST, 0 servicedeskapi | holdout-scenarios.md |

H-011 fixture wire call counts exactly match BC-3.9.004(b) non-JSM HTTP sequence. The fixture's project type mock (`"projectTypeKey":"software"`) triggers the non-JSM branch. Coherent single wire story throughout. ✓

**K-1 COHERENT ✓**

---

### K-2: H-011 Assertion Style ↔ H-008 Zero-Servicedeskapi Assertion Pattern

| Holdout | Path | Outcome | Wiremock Strict-Mode Assertion |
|---------|------|---------|-------------------------------|
| H-008 | `--public --yes` on non-JSM | exit 64 | Zero servicedeskapi calls; zero platform POST |
| H-011 | `--internal` on non-JSM | exit 0 | Zero servicedeskapi calls; platform POST issued once |

Both holdouts use wiremock strict-mode as the decisive signal for zero-servicedeskapi-call invariant. H-011 "Why hidden" explicitly states "Mirrors H-NEW-ATTACHMENT-008 assertion style." The symmetric contrast (`--internal` silently succeeds; `--public` exits 64) is documented. ✓

**K-2 COHERENT ✓**

---

### K-3: VP-576-004 ↔ BC-2.7.002 Ordering Clause + Curated-Field List ↔ BC-3.9.009

| Element | Claim | Source |
|---------|-------|--------|
| BC-2.7.002 authority clause | `"self"` OMITTED + `"content"` RENAMED to `"contentUrl"` across ALL jr attachment serializations | bc-2 line ~608 |
| VP-576-004 assertion 1 | NO element contains a `"self"` key | bc-2 line 612 |
| VP-576-004 assertion 2 | NO `"content"` key; `"contentUrl"` present | bc-2 line 612 |
| BC-3.9.009 cross-ref | "curated form (BC-2.7.002): `{author, contentUrl, created, filename, id, mimeType, size}`" | bc-3 line ~3465 |
| VP-576-004 cross-ref | "cross-references BC-3.9.009 (upload JSON output authority)" | bc-2 line 612 |

VP-576-004 → BC-2.7.002 → BC-3.9.009 chain consistent. No contradiction. ✓

**K-3 COHERENT ✓**

---

### K-4: VP-576-005 ↔ EC-3.9.017-8/11/12

| Element | Claim | Source |
|---------|-------|--------|
| EC-3.9.017-11 | `--public` + ≥1 match → ONE combined prompt (not two) | bc-3 line 3776 |
| EC-3.9.017-12 | `--yes` single-bypass for ALL gate conditions | bc-3 line 3778 |
| EC-3.9.017-8 | All cancel paths: exit 0 + no destructive calls | bc-3 line ~3771 |
| VP-576-005 assert (a) | EXACTLY ONE prompt; no second prompt (pins EC-3.9.017-11) | bc-3 line 3782 |
| VP-576-005 assert (b) | `--yes`: ZERO prompts (pins EC-3.9.017-12) | bc-3 line 3782 |
| VP-576-005 assert (c) | Cancel: ZERO DELETE + ZERO servicedeskapi POST (pins EC-3.9.017-8/11) | bc-3 line 3782 |

VP-576-005 directly pins three EC behaviors from EC-3.9.017-8/11/12. No contradiction. ✓

**K-4 COHERENT ✓**

---

### K-5: Unconditional Step-1 ↔ EC-2.7.007-1 404-Source Uniformity

| Element | Claim | Source |
|---------|-------|--------|
| BC-2.7.007 P20-003 clause | `--out` does NOT skip step 1; step 1 issued unconditionally | bc-2 line 724 |
| Rationale | Pre-stream existence validation; exits 64 before writing bytes if AID inaccessible | bc-2 line 724 |
| EC-2.7.007-1 | AID not found → `"Attachment <AID> not found or not accessible."` + exit 64 | bc-2 line ~731 |
| EC-2.7.007-1b | AID metadata GET 403 → exit 1 permission-denied | bc-2 line ~733 |
| Uniformity claim | All `--id` downloads (with or without `--out`) go through step 1 → uniform 404/403 detection before any output file writes | bc-2 line 724 |

With `--out` now unconditional at step 1, EC-2.7.007-1 (404) and EC-2.7.007-1b (403) fire consistently regardless of whether `--out` is present. The 404-source uniformity (step 1 always fires first) is maintained. ✓

**K-5 COHERENT ✓**

---

## Cross-Reference Validation

### BC Counts

| Source | bc-2 definitional | bc-2 total_bcs | bc-3 definitional | bc-3 total_bcs | Grand Total |
|--------|-------------------|-----------------|-------------------|-----------------|-------------|
| Frontmatter | 64 | 106 | 111 | 140 | 657 |
| CANONICAL-COUNTS.md | 64 | 106 | 111 | 140 | 657 |
| Guard output | verified | — | verified | — | 657 |

P20 added 0 new BCs. PASS ✓

### Holdout Counts

| Source | Count | Status |
|--------|-------|--------|
| `holdout-scenarios.md` frontmatter `total_holdouts` | 99 | PASS ✓ |
| `holdout-scenarios.md` body preamble | 99 | PASS ✓ |
| `CANONICAL-COUNTS.md` canonical total | 99 | PASS ✓ |
| `CANONICAL-COUNTS.md` enumeration | H-NEW-ATTACHMENT-001..H-NEW-ATTACHMENT-011 | PASS ✓ |
| `prd-delta-576.md` frontmatter `holdout_count_after` | 99 | PASS ✓ |
| `prd-delta-576.md` P20 closing | 99 | PASS ✓ |
| spec-changelog [1.3.60] Impact Assessment | 98→99 | PASS ✓ |

### VP Counts

| Source | VP count reference | Status |
|--------|-------------------|--------|
| `prd-delta-576.md` P20 closing | "VP count: 35 (+2: VP-576-004, VP-576-005)" | PASS ✓ |
| `spec-changelog.md` [1.3.60] Impact Assessment | "33→35 (+2: VP-576-004, VP-576-005)" | PASS ✓ |
| `bc-3-issue-write.md` footer | "VP count 33→35; spec v1.3.60" | PASS ✓ |
| `BC-INDEX.md` last_updated | "VP count 33→35 (VP-576-004 + VP-576-005, P20-006)" | PASS ✓ |

---

## Spec Version Surface Verification

| Artifact | Spec version shown | Status |
|----------|--------------------|--------|
| `spec-changelog.md` | `[1.3.60] - 2026-07-16` entry present | PASS ✓ |
| `bc-3-issue-write.md` frontmatter trace | `v1.3.60` entry at line 94 | PASS ✓ |
| `bc-3-issue-write.md` footer | "spec v1.3.60" | PASS ✓ |
| `BC-INDEX.md` `last_updated` | "spec v1.3.60" in P20 note | PASS ✓ |
| `prd-delta-576.md` frontmatter `spec_version_after` | `1.3.60` | PASS ✓ |
| `STATE.md` `current_step` | "spec v1.3.56" (still at P16) | STALE (INFO-8 carries forward) |

---

## INFO Ledger Status

### INFO-1 (carry-forward R21–R30) — CARRY-FORWARD

Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7 in bc-2. Not introduced or worsened by P20. Non-blocking.

**Status**: CARRY-FORWARD (not re-quoted; not touched by P20)

---

### INFO-2 (carry-forward R21–R30) — CARRY-FORWARD

EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained. Not introduced or worsened by P20. Non-blocking.

**Status**: CARRY-FORWARD (not re-quoted; not touched by P20)

---

### INFO-3 (carry-forward R21–R30) — CARRY-FORWARD

BC-2.7.012 "KEY or AID 5xx" combined-scope row. Not introduced or worsened by P20. Non-blocking.

**Status**: CARRY-FORWARD (not re-quoted; not touched by P20)

---

### INFO-4 (carry-forward R22–R30) — CARRY-FORWARD

H-NEW-ATTACHMENT-003 BC refs footer does not list `BC-2.7.008 EC-2.7.008-6` for Call B2. Not introduced or worsened by P20. Non-blocking.

**Status**: CARRY-FORWARD (not re-quoted; not touched by P20)

---

### INFO-6 (carry-forward R23–R30) — CARRY-FORWARD

No holdout for the collision-skip exit-0 path. Not introduced or worsened by P20. Non-blocking.

**Status**: CARRY-FORWARD (absence verified)

---

### INFO-8 (carry-forward R25–R30)

`STATE.md` spec version stale at v1.3.56 (should be v1.3.60 after P20). BC 657 / holdouts 99 / VP 35 correct in STATE.md; spec version and pass count trail. Task directive: do not edit STATE.md. Non-blocking.

**Status**: CARRY-FORWARD (spec version stale; should be v1.3.60 after P20)

---

### INFO-11 (carry-forward R27–R30) — CARRY-FORWARD

`spec-changelog.md` [1.3.57] and `prd-delta-576.md` P17-002 disposition say "three sites" but four sites in `impact-boundary-576.md` were actually modified. Not introduced or worsened by P20.

**Status**: CARRY-FORWARD

---

### INFO-12 (carry-forward R27–R30) — CARRY-FORWARD

`bc-3-issue-write.md` BC-3.9.003 Trace not updated for P17-003. P17-003 citation IS present in EC-3.9.003-5 body text. Not introduced or worsened by P20.

**Status**: CARRY-FORWARD

---

### INFO-13 (carry-forward R28–R30) — CARRY-FORWARD

`error-taxonomy.md` row 95 issue-GET 403 sub-variant lacks BC-2.7.006 citation. Not introduced or worsened by P20.

**Status**: CARRY-FORWARD

---

### INFO-14 (carry-forward R29–R30, PARTIALLY RESOLVED)

`spec-changelog.md` [1.3.59] Impact Assessment lacked explicit BC/holdout/VP count rows. **[1.3.60] NOW has these rows** — pattern corrected going forward. [1.3.59] remains without them historically (it is now a prior entry that will not be re-edited).

**Status**: PARTIALLY RESOLVED — [1.3.60] correct; [1.3.59] historically incomplete (non-blocking)

---

### INFO-15 (carry-forward R29–R30)

`impact-boundary-576.md` BC-3.9.004 row was annotated with INCONCLUSIVE in P19. The P20 fix restructured BC-3.9.004 substantially (Step 0 + HTTP sequences); the impact-boundary BC-3.9.004 row was NOT updated to reflect the P20 restructuring. However, the existing INCONCLUSIVE annotation (added by P19) already marks the row as non-authoritative pending S5 live capture. The authoritative source is BC-3.9.004 itself (now fully defined). Non-blocking.

**Status**: CARRY-FORWARD (INCONCLUSIVE annotation still applies; BC-3.9.004 is now fully defined in bc-3)

---

### INFO-NEW-1 (NEW R30)

`CANONICAL-COUNTS.md` holdout section contains two stale secondary tracking elements:

1. **Group 19 range** (line ~126): States "H-NEW-ATTACHMENT-001..H-NEW-ATTACHMENT-010 ... — +10" — should end at ..011 and say +11 to reflect P20-001 adding H-NEW-ATTACHMENT-011.
2. **Reconciliation Note paragraph** (line 130): States "holdout-scenarios.md frontmatter `total_holdouts: 98` counts all holdout entries; the grep count of `^### H-` headings also returns 98. The frontmatter count (98) is authoritative. Last reconciled: 2026-07-16 (SOH-ATTACHMENTS-1 P15-002/R3.12; +H-NEW-ATTACHMENT-010...)" — should reference 99 and "P20-001 +H-NEW-ATTACHMENT-011".

**What is correct**: The `**Canonical holdout total: 99**` line (111) is correct. The enumeration (line 118) correctly includes "H-NEW-ATTACHMENT-001..H-NEW-ATTACHMENT-011". The `check-spec-counts.sh` guard passes (it checks the canonical total, not the Note paragraph). Behavioral impact: none.

**Severity**: INFO. Tracking prose inconsistency in a secondary section of CANONICAL-COUNTS.md. The authoritative canonical total and enumeration are correct; the guards confirm. Non-blocking.

---

## Findings

### Critical

None.

### Major

None.

### GAPs

None.

### Resolved

**GAP-P19-FWD-001 (was MEDIUM)**: `prd-delta-576.md` frontmatter `spec_version_after` now 1.3.60 (was stale at 1.3.58 when r29 was written; P19 section appended simultaneously). CLOSED.

### Minor (INFO)

- **INFO-1** (carry-forward R21–R30): Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7.
- **INFO-2** (carry-forward R21–R30): EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained.
- **INFO-3** (carry-forward R21–R30): BC-2.7.012 "KEY or AID 5xx" combined-scope row.
- **INFO-4** (carry-forward R22–R30): H-NEW-ATTACHMENT-003 BC refs footer missing EC-2.7.008-6 for Call B2.
- **INFO-6** (carry-forward R23–R30): No holdout for collision-skip exit-0 path.
- **INFO-8** (carry-forward R25–R30): STATE.md spec version stale (should be v1.3.60).
- **INFO-11** (carry-forward R27–R30): P17-002 "three sites" undercount in spec-changelog/prd-delta.
- **INFO-12** (carry-forward R27–R30): BC-3.9.003 Trace not updated for P17-003; citation in EC body.
- **INFO-13** (carry-forward R28–R30): error-taxonomy row 95 issue-GET 403 lacks BC-2.7.006 citation.
- **INFO-14** (carry-forward R29–R30, PARTIALLY RESOLVED): [1.3.59] lacks explicit count rows; [1.3.60] corrects this.
- **INFO-15** (carry-forward R29–R30): impact-boundary BC-3.9.004 INCONCLUSIVE annotation; BC-3.9.004 now defined in P20.
- **INFO-NEW-1** (NEW R30): CANONICAL-COUNTS.md Group 19 range and reconciliation Note paragraph stale (98 vs 99; P15 vs P20); canonical total 99 and enumeration correct; guard passes.

---

## Validation Gate Result

**CONSISTENT**

All 7 P20 fix-round items (P20-001..007) correctly applied. No behavioral GAPs. Echo-breaker audit of 8 sentences found no over-claims, including special scrutiny of the BC-3.9.004 JSM-branch HTTP sequence (all four steps licensed by BC-3.9.003) and EC-3.9.014-5 "no ellipsis" claim (verified by direct read of line 3609). Double-insertion sweep found no duplicate markers — hook-timeout risk not actualized. Keystones K-1 through K-5 coherent. Spec version 1.3.60 consistent across all spec surfaces. BC count 657 / holdout count 99 / VP count 35 confirmed by both guards (exit 0). GAP-P19-FWD-001 from r29 resolved. One new INFO item (INFO-NEW-1: CANONICAL-COUNTS.md stale Group-19/Note paragraph; non-blocking).

---

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 31 |
| **Passed** | 30 |
| **Resolved** | 6 (INFO-5 P14; INFO-7 P16 micro-fix; INFO-9 R26; INFO-10 P16+P17; GAP-P19-FWD-001 resolved this round; INFO-14 partially resolved) |
| **Failed (GAPs)** | 0 |
| **Warnings (INFO)** | 12 active (INFO-1..4 carry; INFO-6 carry; INFO-8 carry; INFO-11..13 carry; INFO-14 partial-resolved carry; INFO-15 carry; INFO-NEW-1 new) |
| **Overall Status** | consistent |

Round 30 is a PATCH-level validation confirming 7 P20 adversary-pass fixes: (1) BC-3.9.004 Step 0 inheritance clause + JSM branch (issue GET → project GET → N × attachTemporaryFile → request-attachment) and non-JSM OQ-9 branch (issue GET → project GET → platform POST; 0 servicedeskapi) HTTP sequences + H-NEW-ATTACHMENT-011 holdout (mirrors H-008 strict-mode zero-servicedeskapi assertion style; offline-testable); holdout count 98→99 (P20-001 MEDIUM); (2) BC-3.9.014 N≤3 prompt template `, ...` removed, `<filenameN>` placeholder used — no trailing ellipsis (P20-002 LOW); (3) BC-2.7.007 `--out` unconditional step-1 clause added — step 1 issued regardless of `--out`; pre-stream existence validation rationale + accepted cost; BC-INDEX row updated (P20-003 LOW); (4) impact-boundary-576.md §1.1 download row retro-annotated per PHASE-DOC-RETRO-ANNOTATION pattern — EC-2.7.007-7 stdout manifest noted (P20-004 LOW); (5) prd-delta-576.md Scope table S3+S5 BC-3.9.017 split notes added — non-public path S3-realized; combined `--public` ECs S5-realized; S5 depends_on S3 (P20-005 LOW); (6) VP-576-004 (BC-2.7.002 anchor: "self" OMITTED + "content"→"contentUrl" across all jr serializations) and VP-576-005 (BC-3.9.017 anchor: combined gate ONE prompt; `--yes` bypasses both; cancel → zero DELETE + zero POST) added; VP count 33→35; BC-INDEX VP count updated (P20-006 LOW); (7) P20-007 BC-NUMBER-043-DUPLICATE recorded, no action (INFO). BC-INDEX v6.19→v6.20. spec-changelog [1.3.60] complete with BC/holdout/VP count rows (corrects [1.3.59] format from INFO-14). prd-delta-576.md frontmatter spec_version_after 1.3.60 + holdout_count_after 99 + P20 dispositions section present (closes GAP-P19-FWD-001 from r29). No double-insertions despite hook-timeout risk. Spec version advances to 1.3.60. BC count unchanged at 657; holdout count 99 (+1); VP count 35 (+2).

---

## Appendix: Validation Methodology

This report was produced by a fresh-context consistency validator (cv-f2-576-r30) with no visibility into prior round reports.

1. **Independent artifact read**: All 8 input artifacts read fresh. Findings formed before cross-referencing the P20 disposition claims.
2. **Quote-based closure**: Every P20 priority check verified by verbatim quotation from the authoritative artifact.
3. **Double-insertion sweep**: For each edited artifact, exact marker occurrence counts verified (grep -c). VP-576-005 triple count explained as three distinct legitimate roles (frontmatter trace + VP body + footer update).
4. **Echo-breaker audit**: 8 sentences audited; 2 under special scrutiny (BC-3.9.004 JSM HTTP sequence — all four steps traced to BC-3.9.003; EC-3.9.014-5 no-ellipsis claim — verified by direct read at bc-3 line 3609). No over-claims found.
5. **Keystone checks**: K-1 through K-5 verified: BC-3.9.004 wire sequences coherent with BC-3.9.003/BC-3.9.005/BC-X.8.010/H-011; H-011 mirrors H-008; VP-576-004 chains to BC-2.7.002→BC-3.9.009; VP-576-005 chains to EC-3.9.017-8/11/12; unconditional step-1 supports EC-2.7.007-1 uniformity.
6. **Guard scripts**: Both `check-spec-counts.sh` and `check-bc-cumulative-counts.sh` executed and verified "OK".
7. **Count sweep**: BC (657), holdout (99), VP (35) verified across BC-INDEX frontmatter, bc-2/bc-3 frontmatter, prd-delta-576.md, spec-changelog [1.3.60], and holdout-scenarios.md frontmatter.
8. **GAP-P19-FWD-001 closure**: prd-delta-576.md frontmatter `spec_version_after: 1.3.60` (was stale at 1.3.58 in r29) and P20 dispositions section confirmed present.
9. **INFO-NEW-1 identification**: CANONICAL-COUNTS.md Group 19 range ends at ..010 (should be ..011); reconciliation Note paragraph references 98 and P15 (should be 99 and P20). Canonical total (99) and enumeration correct; guard passes; non-blocking.
10. **INFO ledger**: INFO-1..4 and INFO-6 carried without re-quote (not touched by P20). INFO-8, INFO-11..13 carried without re-quote. INFO-14 partially resolved (1.3.60 now has count rows; 1.3.59 historical). INFO-15 carried.
