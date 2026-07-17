---
document_type: consistency-report
round: 38
spec_version: 1.3.68
date: 2026-07-17
validator: cv-576-r38 (fresh context, no prior round visibility)
verdict: CONSISTENT
bc_count: 657
holdout_count: 100
vp_count: 35
priority_checks: P28-001 (MEDIUM, EC-3.9.020-8 corrected wire enumeration: project-meta fetch only; no issue GET on --replace-existing step-0 path; no servicedeskapi pagination for non-JSM; BC-3.9.020 Trace + BC-INDEX row); P28-002 (MEDIUM, H-NEW-ATTACHMENT-009 Expected bullet 4 narrowed to POST-only assertion; GET /rest/servicedeskapi/servicedesk acknowledged as expected; licensing BCs added; Status updated; holdout frontmatter v1.5.4→v1.5.5); Spot audit (5 items: H-008, H-010, H-011, VP-576-003, VP-576-005 mount-vs-assertion sweep); BC-INDEX v6.27→v6.28; spec-changelog [1.3.68]; prd-delta spec_version_after 1.3.68 + P28 section; counts 657/100/35; double-insertion sweep; ECHO-BREAKER (2 items); K-1..K-3 keystones
level: ops
version: "1.0"
status: consistent
producer: cv-576-r38
timestamp: 2026-07-17T00:00:00
phase: 2
inputs:
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/specs/prd/cross-cutting.md"
  - ".factory/spec-changelog.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
input-hash: "ac5f46a"
traces_to: ".factory/specs/prd/BC-INDEX.md"
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 38 (post-P28 remediation)

**Spec version**: 1.3.68 | **BCs**: 657 | **Holdouts**: 100 | **VPs**: 35 | **Verdict**: CONSISTENT

---

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) — SOH-ATTACHMENTS-1 F2 |
| **Generated** | 2026-07-17T00:00:00 |
| **Generator** | cv-576-r38 (fresh-context consistency validator, round 38) |
| **Artifacts Scanned** | 6 (bc-3-issue-write.md, holdout-scenarios.md, BC-INDEX.md, cross-cutting.md, spec-changelog.md, prd-delta-576.md) |
| **Focus** | Post-P28 adversary-pass remediation verification — spec v1.3.67 → v1.3.68; 2 MEDIUM findings; mount-vs-assertion sweep (12 Group-19 holdouts + VP-576-002/003/005); double-insertion sweep; ECHO-BREAKER (2 items); K-1..K-3 keystones |
| **Prior round** | consistency-report-576-r37.md (CONSISTENT; INFO-NEW-7 (degenerate-name fallback warning unclassified for JSON mode) and INFO-NEW-8 (bc-3 frontmatter trace missing v1.3.67 entry) introduced) |

---

## Summary Table

| # | Check | Result |
|---|-------|--------|
| P28-001 | EC-3.9.020-8 corrected terminal sentence present (bc-3 line 3895) | pass |
| P28-001 | EC-3.9.020-8: "no HTTP calls beyond the project-meta fetch (`GET /rest/api/3/project/{key}` — cache-miss; no `GET /rest/servicedeskapi/servicedesk` pagination since the project is NOT `service_desk`)" | pass |
| P28-001 | EC-3.9.020-8: "no issue GET occurs on the `--replace-existing` step-0 path (project key derived from the issue-key string prefix per BC-3.9.017 step 0)" | pass |
| P28-001 | EC-3.9.020-8: P28-001 citation present | pass |
| P28-001 | EC-3.9.020-8: cross-refs to BC-3.9.005, BC-3.9.017 step 0, EC-3.9.005-3 present | pass |
| P28-001 | BC-3.9.020 Trace: P28-001 citation present (bc-3 line 3897) | pass |
| P28-001 | BC-INDEX BC-3.9.020 row: P28-001 wire-enumeration corrected note present | pass |
| P28-001 | BC-INDEX frontmatter: index_version v6.27→v6.28 | pass |
| P28-001 | BC-INDEX frontmatter: last_updated P28 note present | pass |
| P28-002 | H-NEW-ATTACHMENT-009 Expected bullet 4: POST-only assertion (holdout line 2462) | pass |
| P28-002 | H-NEW-ATTACHMENT-009 bullet 4: "Zero requests to the upload POSTs — `POST .../attachTemporaryFile` and `POST .../request/{key}/attachment`" | pass |
| P28-002 | H-NEW-ATTACHMENT-009 bullet 4: GET acknowledged in parenthetical ("The `GET /rest/servicedeskapi/servicedesk` meta-resolution call DOES fire before the gate during JSM detection — it is mounted in setup step 3") | pass |
| P28-002 | H-NEW-ATTACHMENT-009 bullet 4: licensing BCs cited (BC-3.9.003 step 1 / BC-X.8.010 for GET; BC-3.9.014 gate for POST absence) | pass |
| P28-002 | H-NEW-ATTACHMENT-009 Status: P28-002 citation present (holdout line 2466) | pass |
| P28-002 | holdout frontmatter: version v1.5.4→v1.5.5 (line 7) | pass |
| P28-002 | holdout frontmatter: total_holdouts 100 unchanged (line 4) | pass |
| P28-002 | holdout frontmatter trace: P28 entry present (line 25) | pass |
| Spot audit: H-008 | Zero servicedeskapi assertion ↔ mounts: non-JSM → guard fires after project-meta GET, before any servicedeskapi call; no servicedeskapi mount needed; CONSISTENT | pass |
| Spot audit: H-010 | Zero DELETE/POST assertions ↔ mounts: no `--public` → step 0 no-op; `?fields=attachment` GET was issued; gate fires (≥1 match + non-interactive + no `--yes`) before DELETE/POST; no project-meta or servicedeskapi mounts needed; CONSISTENT | pass |
| Spot audit: H-011 | Zero servicedeskapi assertion ↔ mounts: non-JSM OQ-9 path → issue GET + project-meta GET + platform POST; no servicedeskapi calls; strict-mode assertion consistent with zero servicedeskapi mounts; CONSISTENT | pass |
| Spot audit: VP-576-003 | Zero servicedeskapi assertion ↔ mounts: no `--public`, non-JSM issue (FOO) → step 0 no-op; `?fields=attachment` + DELETE + platform POST; no servicedeskapi calls; CONSISTENT | pass |
| Spot audit: VP-576-005 | Zero plain issue GET assertion ↔ mounts: step 0 derives project key from string prefix (no plain issue GET); `?fields=attachment` GET (mount 3) provides existence validation; servicedesk GET (mount 2) fires pre-gate during `get_or_fetch_project_meta`; EC-3.9.003-5 P17-003 suppression confirmed; CONSISTENT | pass |
| BC-INDEX v6.28 | index_version: v6.28 | pass |
| BC-INDEX v6.28 | last_updated: P28 adversary fix round note present | pass |
| spec-changelog [1.3.68] | Entry `## [1.3.68] - 2026-07-17` present | pass |
| spec-changelog [1.3.68] | Summary present: 2 MEDIUM findings (P28-001 EC-3.9.020-8 wire enumeration; P28-002 H-NEW-ATTACHMENT-009 bullet 4) | pass |
| spec-changelog [1.3.68] | Changed Requirements: 4 files listed (bc-3, holdout, BC-INDEX, prd-delta) | pass |
| spec-changelog [1.3.68] | Impact Assessment artifact table rows: bc-3, holdout, BC-INDEX, prd-delta | pass |
| spec-changelog [1.3.68] | Count table: BC 657 (unchanged) / Holdout 100 (unchanged) / VP 35 (unchanged) / New BCs 0 / New VPs 0 / New Holdouts 0 | pass |
| spec-changelog [1.3.68] | Count table: "Spec version \| 1.3.67→1.3.68" row present | pass |
| prd-delta | `spec_version_after: 1.3.68` (frontmatter line 8) | pass |
| prd-delta | P28 section heading: `## Adversary Pass 28 Fix Round Finding Dispositions` present | pass |
| prd-delta | P28 preamble: "2 MEDIUM findings. Spec version bump: 1.3.67 → 1.3.68. No new BCs. Holdouts: 100 (unchanged). VPs: 35 (unchanged)." | pass |
| prd-delta | P28-001 row: MEDIUM \| bc-3, BC-INDEX \| APPLIED | pass |
| prd-delta | P28-002 row: MEDIUM \| holdout \| APPLIED | pass |
| prd-delta | Mount-vs-assertion sweep table: 12 Group-19 holdouts + VP-576-002/003/005 enumerated; 0 additional contradictions | pass |
| prd-delta | P28 closing: "BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.68. Both guards exit 0." | pass |
| Counts 657/100/35 | Consistent across all surfaces; both guards exit 0 | pass |
| Double-insertion sweep | No duplicate findings — all marker counts explained by distinct legitimate locations | pass |
| ECHO-BREAKER: EC-3.9.020-8 corrected sentence | Grounded in BC-3.9.017 step 0 (string-prefix, no issue GET) + BC-X.8.010 step (2) conditional (non-service_desk skips servicedesk pagination); no over-claim | pass |
| ECHO-BREAKER: H-009 bullet 4 GET parenthetical | Grounded in H-009 setup step 3 (GET mounted) + BC-3.9.003 step 1 / BC-X.8.010 (GET fires during sdId resolution before gate); satisfiable (POST-only assertion consistent with gate interrupting POSTs but not GET) | pass |
| K-1 (EC-3.9.020-8 ↔ BC-3.9.017 step 0 ↔ BC-X.8.010 ↔ EC-3.9.005-3) | ONE coherent no-issue-GET story on --replace-existing pre-flight | pass |
| K-2 (H-009 bullet ↔ setup mounts ↔ VP-576-005 assertion style ↔ BC-3.9.003 step 1) | Internal fixture coherence: servicedesk GET fires pre-gate (mounted); POST-only assertion style mirrors VP-576-005 cancel-variant | pass |
| K-3 (exactly-one-issue-GET accounting across ALL paths) | Four paths enumerated; no surface contradicts another; ONE story per path | pass |
| Guard: check-spec-counts.sh | OK: all spec counts verified | pass |
| Guard: check-bc-cumulative-counts.sh | OK: all cumulative BC counts verified (657 total across 8 files) | pass |

**All P28 items verified fully applied. Spot audit (5 of 15 sweep items independently re-checked) confirms zero mount-vs-assertion contradictions. INFO-NEW-8 (carry R37) RESOLVED (v1.3.67 trace entry now present in bc-3 frontmatter at line 100). One new INFO finding: INFO-NEW-9 (bc-3 frontmatter missing v1.3.68 entry; same gap pattern as INFO-NEW-8 was before remediation). No new CRITICAL, MAJOR, or behavioral GAP findings. Keystones K-1..K-3 all coherent. Both guards exit 0. Verdict: CONSISTENT.**

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

## P28-001 — EC-3.9.020-8 Wire Enumeration Correction (MEDIUM)

### EC-3.9.020-8 Corrected Terminal Sentence (bc-3 line 3895) — Quote-Verified

**Full EC-3.9.020-8 terminal clause** (verbatim, bc-3-issue-write.md line 3895):

> `Exit 64; no preview emitted; no HTTP calls beyond the project-meta fetch (\`GET /rest/api/3/project/{key}\` — cache-miss; no \`GET /rest/servicedeskapi/servicedesk\` pagination since the project is NOT \`service_desk\`); no issue GET occurs on the \`--replace-existing\` step-0 path (project key derived from the issue-key string prefix per BC-3.9.017 step 0). P23-002; P28-001; BC-3.9.005; BC-3.9.017 step 0; EC-3.9.005-3.`

Three key claims verified:
- "no HTTP calls beyond the project-meta fetch (`GET /rest/api/3/project/{key}` — cache-miss)" ✓
- "no `GET /rest/servicedeskapi/servicedesk` pagination since the project is NOT `service_desk`" ✓
- "no issue GET occurs on the `--replace-existing` step-0 path (project key derived from the issue-key string prefix per BC-3.9.017 step 0)" ✓
- P28-001 citation inline ✓
- Cross-refs: BC-3.9.005, BC-3.9.017 step 0, EC-3.9.005-3 ✓

### BC-3.9.020 Trace (bc-3 line 3897) — Quote-Verified

**Trace P28-001 clause** (verbatim excerpt, bc-3-issue-write.md line 3897):

> `P28-001 (EC-3.9.020-8 wire enumeration corrected: "step-0 issue GET" replaced with accurate description — only project-meta GET fires; no issue GET on --replace-existing step-0 path; no servicedeskapi pagination for non-JSM project)`

P28-001 citation with accurate description ✓

### BC-INDEX BC-3.9.020 Row (line 392) — Quote-Verified

**Relevant P28-001 note** (verbatim excerpt from BC-INDEX.md line 392):

> `**EC-3.9.020-8 (P23-002; P28-001 wire-enumeration corrected)**: \`--replace-existing --dry-run --public\` on non-JSM exits 64 before any list GET — no preview emitted; only project-meta fetch fires (\`GET /rest/api/3/project/{key}\`); no issue GET on \`--replace-existing\` step-0 path; no servicedeskapi pagination for non-JSM project`

P28-001 note with accurate wire enumeration ✓

### BC-INDEX Frontmatter (lines 5–6) — Quote-Verified

**BC-INDEX frontmatter** (verbatim):

> `last_updated: 2026-07-17  # P28 adversary fix round: BC-3.9.020 row P28-001 EC-3.9.020-8 wire-enumeration corrected (step-0 issue GET → project-meta fetch only; no issue GET on --replace-existing step-0 path); spec v1.3.68; BC count unchanged (657); holdout count 100 (unchanged); VP count 35 (unchanged); BC-INDEX v6.28. Previous: P27 adversary fix round: ...`
> `index_version: v6.28`

`index_version` v6.27→v6.28 ✓ `last_updated` records P28 row update + spec v1.3.68 ✓

**Result**: P28-001 FULLY APPLIED ✓.

---

## P28-002 — H-NEW-ATTACHMENT-009 Expected Bullet 4 Narrowed (MEDIUM)

### H-NEW-ATTACHMENT-009 Expected Bullet 4 (holdout line 2462) — Quote-Verified

**Corrected bullet 4** (verbatim, holdout-scenarios.md line 2462):

> `- Zero requests to the upload POSTs — \`POST .../attachTemporaryFile\` and \`POST .../request/{key}/attachment\` — before or after the gate. (The \`GET /rest/servicedeskapi/servicedesk\` meta-resolution call DOES fire before the gate during JSM detection — it is mounted in setup step 3; assert only that the upload POSTs are absent.) Licensing BC: BC-3.9.003 step 1 / BC-X.8.010 (the GET); BC-3.9.014 gate (the POST absence).`

Narrowed to upload-POSTs-only assertion ✓  
GET acknowledged in parenthetical as expected and mounted ✓  
Licensing BCs: BC-3.9.003 step 1 / BC-X.8.010 (GET); BC-3.9.014 gate (POST absence) ✓

### H-NEW-ATTACHMENT-009 Status (holdout line 2466) — Quote-Verified

**Status excerpt** (verbatim):

> `MUST-PASS. Pins EC-3.9.003-6 (EOF → \`JrError::Interrupted\`, exit 130; NOT exit 0) and BC-3.9.014 three-way branch (c). The EOF-vs-empty-Enter distinction is load-bearing. P14-001; P28-002 (Expected bullet 4 narrowed to POST-only servicedeskapi assertion; GET /rest/servicedeskapi/servicedesk IS expected to fire per setup step 3).`

P28-002 citation with accurate description ✓

### holdout Frontmatter v1.5.4→v1.5.5 — Quote-Verified

**Frontmatter** (verbatim, holdout-scenarios.md lines 4, 7):

> `total_holdouts: 100`  
> `version: "1.5.5"`

`version` is `"1.5.5"` (was `"1.5.4"`) ✓ `total_holdouts: 100` unchanged ✓

**Trace entry** (holdout frontmatter line 25, verbatim):

> `- SOH-ATTACHMENTS-1 adversary pass-28 (2026-07-17, P28): H-NEW-ATTACHMENT-009 Expected bullet 4 narrowed — "zero requests to any /rest/servicedeskapi/..." replaced with POST-only assertion: zero requests to POST .../attachTemporaryFile and POST .../request/{key}/attachment; GET /rest/servicedeskapi/servicedesk meta-resolution IS expected to fire (mounted in setup step 3; asserted absent only are the upload POSTs); licensing BC added (BC-3.9.003 step 1 / BC-X.8.010 for the GET; BC-3.9.014 gate for the POST absence); Status updated with P28-002 citation; holdout count unchanged (100)`

Trace entry present; covers P28-002 accurately ✓

**Result**: P28-002 FULLY APPLIED ✓.

---

## BC-INDEX v6.27→v6.28

BC-INDEX.md frontmatter verified above. `index_version: v6.28` ✓ `last_updated` records all P28 changes + spec v1.3.68 note ✓

**Result**: BC-INDEX v6.28 APPLIED ✓.

---

## spec-changelog [1.3.68]

**Entry present** (spec-changelog.md line 10):

```
## [1.3.68] - 2026-07-17

### Type: PATCH
```

Entry present; dated 2026-07-17 ✓

**Summary** (line 16): Present — describes both P28-001 (EC-3.9.020-8 wire enumeration; "step-0 issue GET" erroneous; corrected to project-meta fetch only; no issue GET; no servicedeskapi pagination; sweep finding in r33 historical snapshot) and P28-002 (H-NEW-ATTACHMENT-009 bullet 4 over-broad assertion; narrowed to POST-only; GET acknowledged; mount-vs-assertion sweep of 12 holdouts + 3 VPs found no additional contradictions). ✓

**Changed Requirements** (lines 20–23): Lists 4 modified files:
- bc-3-issue-write.md (P28-001 — EC-3.9.020-8 wire enumeration + Trace)
- holdout-scenarios.md (P28-002 — H-NEW-ATTACHMENT-009 bullet 4 + frontmatter)
- BC-INDEX.md (P28-001 — BC-3.9.020 row + index_version v6.28)
- prd-delta-576.md (spec_version_after 1.3.68; P28 dispositions section)

All 4 files listed ✓

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
| Spec version | 1.3.67→1.3.68 |
```

7-row count table present with "Spec version \| 1.3.67→1.3.68" row ✓

**Result**: spec-changelog [1.3.68] APPLIED ✓.

---

## prd-delta-576.md Frontmatter + P28 Section

**Frontmatter** (line 8):

```yaml
spec_version_after: 1.3.68
```

`spec_version_after` updated to 1.3.68 ✓

**P28 section heading** (prd-delta-576.md):

> `## Adversary Pass 28 Fix Round Finding Dispositions`

P28 section present ✓

**P28 preamble** (verbatim):

> `Source: Adversary Pass 28. 2 MEDIUM findings. Spec version bump: 1.3.67 → 1.3.68. No new BCs. Holdouts: 100 (unchanged). VPs: 35 (unchanged).`

Counts and version bump correct ✓

**Finding rows**:
- P28-001: MEDIUM | bc-3, BC-INDEX | APPLIED | full EC-3.9.020-8 corrected wording enumerated; sweep note (r33 historical snapshot left as-is) ✓
- P28-002: MEDIUM | holdout | APPLIED | POST-only assertion; mirrors VP-576-005 cancel-variant style; trace + frontmatter updated ✓

**Mount-vs-assertion sweep table**: 15 rows (12 Group-19 holdouts + VP-576-002/003/005); all OK except H-009 (FIXED by P28-002); 0 additional contradictions ✓

**P28 closing statement** (verbatim):

> `**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.68. Both guards exit 0.**`

Closing correct: BC 657 / holdout 100 / VP 35 / spec v1.3.68 / both guards exit 0 ✓

**Result**: prd-delta-576.md P28 APPLIED ✓.

---

## Double-Insertion Sweep

| Marker | Count | Locations | Assessment |
|--------|-------|-----------|------------|
| `## Adversary Pass 28 Fix Round` in `prd-delta-576.md` | 2 | section heading + preamble "Source: Adversary Pass 28" | EXPECTED — 2 distinct roles ✓ |
| `[1.3.68]` in `spec-changelog.md` | 1 | line 10 | No duplicate entry ✓ |
| `P28-001` in `bc-3-issue-write.md` | 2 lines | line 3895 (EC-3.9.020-8 body inline citation) + line 3897 (BC-3.9.020 Trace) | EXPECTED — 2 distinct roles ✓ |
| `P28-001` in `BC-INDEX.md` | 1 line | line 392 (BC-3.9.020 row note) | EXPECTED — 1 distinct location ✓ |
| `P28-002` in `holdout-scenarios.md` | 2 lines | line 2462 (Expected bullet 4 licensing clause) + line 2466 (Status) | EXPECTED — 2 distinct locations ✓ |
| `P28` in `holdout-scenarios.md` frontmatter | 1 | line 25 trace entry | EXPECTED — 1 trace entry ✓ |
| `v6.28` in `BC-INDEX.md` | 1 | `index_version: v6.28` | EXPECTED ✓ |
| `spec_version_after: 1.3.68` in `prd-delta-576.md` | 1 | frontmatter line 8 | EXPECTED ✓ |
| H-009 bullet 4 POST-only assertion | 1 | holdout line 2462 | No duplicate assertion ✓ |
| `version: "1.5.5"` in `holdout-scenarios.md` frontmatter | 1 | line 7 | EXPECTED ✓ |

**No double-insertions detected.** All marker counts explained by distinct legitimate locations. ✓

---

## ECHO-BREAKER Audit

### Item 1: EC-3.9.020-8 Corrected Sentence — "no issue GET; project-meta only; no servicedeskapi pagination for non-JSM"

**Text** (bc-3 line 3895): "no HTTP calls beyond the project-meta fetch (`GET /rest/api/3/project/{key}` — cache-miss; no `GET /rest/servicedeskapi/servicedesk` pagination since the project is NOT `service_desk`); no issue GET occurs on the `--replace-existing` step-0 path (project key derived from the issue-key string prefix per BC-3.9.017 step 0)"

**Licensing basis**:

1. **BC-3.9.017 step 0** (bc-3 line 3743): "the string-prefix derivation used here (`FOO-1` → `FOO`) is the only available approach at this pre-flight step — **no issue GET has run yet**." This is the canonical source for the claim that no issue GET fires on the `--replace-existing` step-0 path. ✓

2. **BC-X.8.010 resolution chain step (2)** (cross-cutting.md line 724): "(2) if `projectTypeKey == 'service_desk'`: paginates `GET /rest/servicedeskapi/servicedesk` → finds entry where `serviceDesk.projectId == project.id`". The conditional `if` means: on a non-service-desk project (`projectTypeKey != "service_desk"`), the servicedeskapi GET is never reached. This licenses the claim "no `GET /rest/servicedeskapi/servicedesk` pagination since the project is NOT `service_desk`". ✓

3. **EC-3.9.005-3** (bc-3 line 3388): "pre-flight fires at BC-3.9.017 step 0; exit 64; canonical message; zero DELETEs issued; zero upload POST." Confirms exit-64 at step 0 before any list GET. ✓

4. **No over-claim**: the corrected sentence describes only what fires on the non-JSM `--replace-existing --dry-run --public` path (BC-3.9.017 step 0 only: one project-meta GET then exit 64). It does NOT claim that no servicedeskapi GETs fire on JSM paths (where they do fire). The scope is narrowly specified. ✓

### Item 2: H-009 Bullet 4 GET Parenthetical — "The `GET /rest/servicedeskapi/servicedesk` meta-resolution call DOES fire before the gate"

**Text** (holdout line 2462): "(The `GET /rest/servicedeskapi/servicedesk` meta-resolution call DOES fire before the gate during JSM detection — it is mounted in setup step 3; assert only that the upload POSTs are absent.) Licensing BC: BC-3.9.003 step 1 / BC-X.8.010 (the GET); BC-3.9.014 gate (the POST absence)."

**Licensing basis**:

1. **H-009 setup step 3** (holdout line 2452): "Wiremock mounts `GET /rest/api/3/project/EJ` returning `{"id":"10050","projectTypeKey":"service_desk","simplified":false}` ... + `GET /rest/servicedeskapi/servicedesk` returning a valid service desk with `serviceDeskId = "1"`." The GET IS mounted in step 3. ✓

2. **BC-X.8.010 resolution chain** (cross-cutting.md line 724): On a JSM project, the resolution chain calls both `GET /rest/api/3/project/{key}` AND `GET /rest/servicedeskapi/servicedesk` (the pagination call to resolve `serviceDeskId`). This resolves as part of `get_or_fetch_project_meta` BEFORE the gate is presented. ✓

3. **BC-3.9.003 step 1** (bc-3 line 3314): `POST .../attachTemporaryFile` is the upload POST (the assertion's target for zero-claim). The gate (BC-3.9.014, eprint!+read_line) fires before step 1's POST. EOF at the gate → step 1 POST never fires. ✓

4. **Satisfiability**: The servicedesk GET fires during `get_or_fetch_project_meta` (before gate; mounted in step 3). EOF at the gate fires AFTER the servicedesk GET but BEFORE step 1 POST. Zero-POST assertion is satisfiable: gate terminates the sequence before any POST. ✓

5. **Mirror to VP-576-005 cancel-variant style** (bc-3 line 3789): The cancel-variant asserts "ZERO servicedeskapi POST requests" (not zero servicedeskapi GETs) — same POST-only scoping. The H-009 correction deliberately mirrors this established style. ✓

**ECHO-BREAKER: Both items grounded in licensing sources; both assertions satisfiable. No over-claim. ✓**

---

## Spot Audit — Mount-vs-Assertion Re-check (5 Items)

The PO's sweep declared all 15 items OK/FIXED. This spot audit independently re-checks 5 of the servicedeskapi-adjacent items (H-008, H-010, H-011, VP-576-003, VP-576-005) against the wire contract.

### H-008: `attachment upload SOFTWARE-1 upload.txt --public --yes` → exit 64

**Zero/no-request assertion** (holdout line 2431): "Zero requests to any `/rest/servicedeskapi/...` path (Wiremock strict-mode assertion via 0 unmatched servicedeskapi requests)"; "Zero requests to `POST /rest/api/3/issue/SOFTWARE-1/attachments`"

**Mounts in setup**:
- `GET /rest/api/3/issue/SOFTWARE-1` → valid non-JSM issue body (Step 0 issue GET; BC-3.9.003)
- `GET /rest/api/3/project/SOFTWARE` → `projectTypeKey = "software"` (project-meta GET; authoritative non-service-desk detection via `get_or_fetch_project_meta`; BC-X.8.010 cache-miss step (1) only)
- Strict-mode: ZERO servicedeskapi requests

**Wire contract check**: H-008 exercises the plain `--public` path (BC-3.9.003), not `--replace-existing`. Step 0: issue GET fires (existence validation + project key). `get_or_fetch_project_meta` is called: step (1) `GET /rest/api/3/project/SOFTWARE` → `projectTypeKey = "software"` (non-service-desk). BC-X.8.010 step (2) conditional: "if `projectTypeKey == 'service_desk'`" is FALSE → servicedesk pagination NEVER fires. BC-3.9.005 exits 64 immediately. No servicedeskapi calls at all.

**Contradiction verdict**: CONSISTENT ✓ — zero servicedeskapi assertion is correct; both mounts (issue GET + project-meta GET) are needed and expected; no servicedeskapi mount needed.

### H-010: `attachment upload FOO-1 upload.txt --replace-existing --no-input` → exit 64

**Zero/no-request assertions** (holdout lines 2492-2494): "zero requests to `DELETE /rest/api/3/attachment/50001`"; "zero requests to `POST /rest/api/3/issue/FOO-1/attachments`"; "The pre-flight `GET ?fields=attachment` WAS issued"

**Mounts in setup**:
- `GET /rest/api/3/issue/FOO-1?fields=attachment` → 1 same-filename match (id=50001, filename=upload.txt)
- Zero DELETE mounts (negative assertion)
- Zero POST mounts (negative assertion)
- No project-meta mount, no servicedeskapi mount

**Wire contract check**: H-010 exercises `--replace-existing` without `--public` (BC-3.9.017). Step 0: "This step is a no-op when `--public` is absent" — no project-meta GET, no servicedeskapi calls. Step 1: `GET /rest/api/3/issue/FOO-1?fields=attachment` → 1 match. Gate at step 2: ≥1 match + non-interactive + no `--yes` → exit 64 per EC-3.9.017-9. No DELETE (step 3 never reached), no upload POST (step 4 never reached).

**Contradiction verdict**: CONSISTENT ✓ — no project-meta or servicedeskapi mounts needed (step 0 no-op); `?fields=attachment` GET assertion is correct; DELETE and POST zero assertions are correct (gate fires before step 3/4).

### H-011: `attachment upload SOFTWARE-1 upload.txt --internal` → exit 0

**Zero/no-request assertion** (holdout line 2527): "Wiremock strict-mode: zero requests to any `/rest/servicedeskapi/...` path"

**Mounts in setup**:
- `GET /rest/api/3/issue/SOFTWARE-1` → non-JSM issue body (Step 0 issue GET; BC-3.9.004)
- `GET /rest/api/3/project/SOFTWARE` → `projectTypeKey = "software"` (project-meta GET; BC-X.8.010 cache-miss step (1); non-service-desk → OQ-9 silent no-op)
- `POST /rest/api/3/issue/SOFTWARE-1/attachments` → upload success
- Strict-mode: ZERO servicedeskapi requests

**Wire contract check**: H-011 exercises `--internal` on non-JSM (BC-3.9.004 EC-3.9.004-1 OQ-9). Step 0: issue GET + project-meta GET. `projectTypeKey = "software"` → non-JSM → BC-X.8.010 step (2) conditional FALSE → no servicedesk pagination. Silently routes to platform POST (BC-3.9.001). Zero servicedeskapi calls.

**Contradiction verdict**: CONSISTENT ✓ — all three mounts correct; zero servicedeskapi assertion consistent with non-JSM OQ-9 path; no servicedeskapi mount needed.

### VP-576-003: `attachment upload FOO-1 file.txt --replace-existing --yes` → DELETE before POST

**Zero/no-request assertion** (bc-3 line 3787): "(b) zero requests were issued to any `/rest/servicedeskapi/...` path (BC-3.9.005 eligibility guard on non-JSM issue would fire first — but since `--public` is absent here, no JSM calls)"

**Mounts in setup** (bc-3 line 3787):
- `GET /rest/api/3/issue/FOO-1?fields=attachment` → 1 match (filename=file.txt, id=10001)
- `DELETE /rest/api/3/attachment/10001` → 204
- `POST /rest/api/3/issue/FOO-1/attachments` → upload success
- No project-meta mount, no servicedeskapi mount

**Wire contract check**: VP-576-003 exercises `--replace-existing --yes` WITHOUT `--public` on a non-JSM issue. Step 0: no-op (`--public` absent). Step 1: `?fields=attachment` GET → 1 match. Gate at step 2: ≥1 match + `--yes` → bypassed per EC-3.9.017-12. Step 3: DELETE. Step 4: platform POST (non-JSM, no `--public`). No project-meta GET (step 0 no-op), no servicedeskapi calls.

**Contradiction verdict**: CONSISTENT ✓ — zero servicedeskapi assertion correct; no project-meta or servicedeskapi mounts needed; DELETE-before-POST sequential ordering assertion is the primary invariant; all mounts licensed by BC-3.9.017 steps 1/3/4.

### VP-576-005: `attachment upload EJ-1 file.txt --replace-existing --public` on JSM ≥1 match

**Zero/no-request assertion** (bc-3 line 3789): "(d) wiremock strict mode verifies ZERO plain `GET /rest/api/3/issue/EJ-1` requests without query parameters"

**Mounts in setup** (bc-3 line 3789, 7 steps):
1. `GET /rest/api/3/project/EJ` → `projectTypeKey = "service_desk"` (BC-3.9.017 step 0; BC-X.8.010 cache-miss GET-1)
2. `GET /rest/servicedeskapi/servicedesk` → serviceDeskId (BC-X.8.010 cache-miss GET-2; fires at step 0 during `get_or_fetch_project_meta`)
3. `GET /rest/api/3/issue/EJ-1?fields=attachment` → 1 match (BC-3.9.017 step 1)
4. `JR_STDIN_IS_TTY=1`, pipe `"y\n"` to stdin
5. `DELETE /rest/api/3/attachment/20001` (BC-3.9.017 step 3)
6. `POST .../attachTemporaryFile` (BC-3.9.003 step 1)
7. `POST .../request/EJ-1/attachment` (BC-3.9.003 step 2)

**Wire contract check**: VP-576-005 exercises `--replace-existing --public` on a JSM issue (EJ-1). Step 0 (BC-3.9.017): derives project key from string prefix `EJ-1`→`EJ`; calls `get_or_fetch_project_meta("EJ")` → fires mounts (1) and (2); confirms JSM; does NOT issue a plain issue GET (no issue GET has run yet at step 0). Step 1: `GET /rest/api/3/issue/EJ-1?fields=attachment` → mount (3) → 1 match. Gate: combined gate (≥1 match + `--public`) → one prompt → `"y\n"` confirm. Step 3: DELETE → mount (5). Step 4 → BC-3.9.003 step 0 suppressed per EC-3.9.003-5 P17-003 (existence validated by step 1 `?fields=attachment` GET). BC-3.9.003 step 1: mount (6) POST. BC-3.9.003 step 2: mount (7) POST.

Zero plain issue GET assertion: step 0 uses string-prefix derivation (no issue GET); step 1 uses `?fields=attachment` GET (with query parameter); BC-3.9.003 Step 0 suppressed (no additional plain issue GET). ZERO plain `GET /rest/api/3/issue/EJ-1` requests (without query parameters). ✓

**Contradiction verdict**: CONSISTENT ✓ — zero plain issue GET assertion is licensed by BC-3.9.017 step 0 ("no issue GET has run yet") + EC-3.9.003-5 P17-003 (Step-0 suppression on combined `--replace-existing --public` path). Mount (2) `GET /rest/servicedeskapi/servicedesk` correctly fires pre-gate during step 0's `get_or_fetch_project_meta` call — H-009 P28-002 correction specifically addressed this same class of GET; VP-576-005's cancel-variant asserts only ZERO servicedesk POST requests (not zero GETs), consistent with the service desk GET being expected. All 6 HTTP mounts have distinct BC licensing. ✓

**Spot audit result**: All 5 items INDEPENDENTLY CONFIRMED CONSISTENT. PO sweep verdict for these 5 items upheld.

---

## Keystone Coherence Checks

### K-1: EC-3.9.020-8 Corrected Enumeration ↔ BC-3.9.017 Step 0 ↔ BC-X.8.010 ↔ EC-3.9.005-3 — One Coherent No-Issue-GET Story

The P28-001 correction asserts that on the `--replace-existing --dry-run --public` non-JSM path: only the project-meta GET fires at step 0; no issue GET; no servicedeskapi pagination. Each of the four surfaces must tell the same story.

| Surface | Relevant Claim | Source | Status |
|---------|---------------|--------|--------|
| EC-3.9.020-8 (corrected) | "no issue GET occurs on the `--replace-existing` step-0 path (project key derived from the issue-key string prefix per BC-3.9.017 step 0)"; "no `GET /rest/servicedeskapi/servicedesk` pagination since the project is NOT `service_desk`"; "no HTTP calls beyond the project-meta fetch" | bc-3 line 3895 | COHERENT ✓ |
| BC-3.9.017 step 0 | "the string-prefix derivation used here (`FOO-1` → `FOO`) is the only available approach at this pre-flight step — **no issue GET has run yet at that pre-flight point**" | bc-3 line 3743 | COHERENT ✓ |
| BC-X.8.010 resolution chain | Step (2): "**if** `projectTypeKey == 'service_desk'`: paginates `GET /rest/servicedeskapi/servicedesk`" — conditional: non-service-desk project skips this step | cross-cutting.md line 724 | COHERENT ✓ |
| EC-3.9.005-3 | "pre-flight fires at BC-3.9.017 step 0; exit 64; canonical message; **zero DELETEs issued; zero upload POST**. The list GET (BC-3.9.017 step 1) is never reached." | bc-3 line 3388 | COHERENT ✓ |

Three-way quote confirmation:
- BC-3.9.017 step 0 states: "no issue GET has run yet at that pre-flight point" → licenses EC-3.9.020-8's "no issue GET occurs on the `--replace-existing` step-0 path"
- BC-X.8.010 step (2) conditional confirms: non-service-desk → servicedesk pagination NOT triggered → licenses "no `GET /rest/servicedeskapi/servicedesk` pagination since the project is NOT `service_desk`"
- EC-3.9.005-3 confirms: guard fires at step 0, exit 64, list GET never reached → corroborates "before any list GET is issued and before any dry-run preview is emitted"

**K-1 COHERENT ✓** — all four surfaces tell one consistent story.

### K-2: H-009 Corrected Bullet ↔ Setup Mounts ↔ VP-576-005 Assertion Style ↔ BC-3.9.003 Step 1 Wire

The P28-002 correction narrows H-009 bullet 4 to POST-only assertion, acknowledging that the servicedesk GET fires pre-gate. Internal fixture coherence must hold.

| Element | Claim | Source | Status |
|---------|-------|--------|--------|
| H-009 bullet 4 (corrected) | "Zero requests to the upload POSTs — `POST .../attachTemporaryFile` and `POST .../request/{key}/attachment`"; GET acknowledged in parenthetical as mounted in setup step 3 | holdout line 2462 | COHERENT ✓ |
| H-009 setup step 3 | Mounts BOTH `GET /rest/api/3/project/EJ` AND `GET /rest/servicedeskapi/servicedesk`; servicedesk GET is present and expected to fire | holdout line 2452 | COHERENT ✓ |
| VP-576-005 cancel-variant style | "cancel variant: pipe `"\n"` ... assert ZERO DELETE requests and ZERO servicedeskapi POST requests" (POST-only assertion; mount (2) GET is still expected to fire pre-gate) | bc-3 line 3789 | COHERENT ✓ |
| BC-3.9.003 step 1 wire | "POST `/rest/servicedeskapi/servicedesk/{sdId}/attachTemporaryFile` with the file as a multipart body. Obtains one `temporaryAttachmentId` per file." — the upload POST; gate fires BEFORE step 1; sdId already resolved via `get_or_fetch_project_meta` (which includes the servicedesk GET) BEFORE the gate | bc-3 line 3314 | COHERENT ✓ |

Timing sequence (verified against BC-3.9.003 architecture):
1. `get_or_fetch_project_meta("EJ")` → fires project-meta GET + servicedesk GET (BC-X.8.010; before gate presentation)
2. Gate presented: `eprint!` prompt → EOF on stdin → `JrError::Interrupted` (exit 130)
3. Step 1 POST (`attachTemporaryFile`) NEVER fires (gate terminated sequence)
4. Step 2 POST (`request/{key}/attachment`) NEVER fires

The corrected H-009 bullet 4 is internally coherent: GET (mounted in step 3) fires at timing-point 1; POST zero-assertion is correct at timing-points 3-4. ✓

**K-2 COHERENT ✓** — H-009 fixture is internally consistent after P28-002 narrowing.

### K-3: Exactly-One-Issue-GET Accounting Across ALL Paths

The keystone requires enumerating issue GET counts per path and confirming no surface contradicts another.

| Path | Issue GET Count | Authority | Status |
|------|----------------|-----------|--------|
| Plain `--public` (BC-3.9.003) | 1 — Step 0: `GET /rest/api/3/issue/{key}` (existence validation + project key) | BC-3.9.003 Step 0 (bc-3 line 3312) | STATED ONCE ✓ |
| `--replace-existing` without `--public` (BC-3.9.017) | 0 plain GETs; 1 `?fields=attachment` GET (Step 1: existence + attachment list) | BC-3.9.017 Step 0 no-op when `--public` absent (bc-3 line 3743) + Step 1 | STATED ONCE ✓ |
| Combined `--replace-existing --public` (BC-3.9.017 → BC-3.9.003) | 1 `?fields=attachment` GET (Step 1); 0 plain issue GETs; BC-3.9.003 Step 0 SUPPRESSED | EC-3.9.003-5 P17-003: "exactly ONE issue GET per invocation on the combined `--replace-existing --public` path" (bc-3 line 3332) | STATED ONCE ✓ |
| `--replace-existing --dry-run --public` non-JSM (EC-3.9.020-8) | 0 — project-meta GET fires at Step 0; exit 64 before list GET; no issue GET at all | EC-3.9.020-8 corrected (bc-3 line 3895): "no issue GET occurs on the `--replace-existing` step-0 path" | STATED ONCE ✓ |

Cross-check (no contradiction):
- BC-3.9.003 Step 0 note (bc-3 line 3312): "Key-derivation asymmetry vs BC-3.9.017 step 0: the `--replace-existing` path derives the project key from the issue key string prefix (`FOO-1` → `FOO`) because **no issue GET has run yet** at that pre-flight point" — consistent with path 3 and path 4 above ✓
- EC-3.9.003-5 P17-003 (bc-3 line 3332): "exactly ONE issue GET per invocation on the combined `--replace-existing --public` path" — consistent with path 3 above (the `?fields=attachment` GET) ✓
- EC-3.9.020-8 corrected: path 4 correctly states 0 plain issue GETs, no `?fields=attachment` GET either (exit 64 at step 0, before step 1 list GET) ✓

**K-3 COHERENT ✓** — four paths, four distinct issue-GET counts, no surface contradicts another.

---

## 1. L2 to L3 Requirement Coverage

> **N/A for this document type.** This is a PATCH-level spec-evolution consistency validation (spec v1.3.67→v1.3.68), not a full pipeline L2→L3 coverage check.

## 2. L3 to L4 Verification Property Coverage

> **N/A for this document type.** P28 added 0 new BCs and 0 new VPs; VP count 35 unchanged.

## 3–10. (Standard VSDD sections)

> **N/A for this document type.** No new stories, ACs, types, priorities, assumptions, or risks introduced in this PATCH round.

---

## Cross-Reference Validation

### BC Counts

| Source | bc-2 definitional | bc-2 total_bcs | bc-3 definitional | bc-3 total_bcs | Grand Total |
|--------|-------------------|-----------------|-------------------|-----------------|-------------|
| Frontmatter | 64 | 106 | 111 | 140 | 657 |
| CANONICAL-COUNTS.md | 64 | 106 | 111 | 140 | 657 |
| Guard output | verified | — | verified | — | 657 |

P28 added 0 new BCs. PASS ✓

### Holdout Counts

| Source | Count | Status |
|--------|-------|--------|
| `holdout-scenarios.md` frontmatter `total_holdouts` | 100 | PASS ✓ |
| `prd-delta-576.md` P28 closing | "Holdout count: 100 (unchanged)" | PASS ✓ |
| `spec-changelog.md` [1.3.68] count table | "Holdout count: 100 (unchanged)" | PASS ✓ |

### VP Counts

| Source | VP count reference | Status |
|--------|-------------------|--------|
| `prd-delta-576.md` P28 closing | "VP count: 35 (unchanged)" | PASS ✓ |
| `BC-INDEX.md` `last_updated` | "VP count 35 (unchanged)" | PASS ✓ |
| `spec-changelog.md` [1.3.68] count table | "VP count: 35 (unchanged)" | PASS ✓ |

---

## Spec Version Surface Verification

| Artifact | Spec version shown | Status |
|----------|--------------------|--------|
| `spec-changelog.md` | `[1.3.68] - 2026-07-17` entry present | PASS ✓ |
| `bc-3-issue-write.md` frontmatter trace | v1.3.67 entry (line 100) present; no v1.3.68 entry | INFO-NEW-9 (see below) |
| `BC-INDEX.md` `last_updated` | "spec v1.3.68" in P28 note | PASS ✓ |
| `holdout-scenarios.md` frontmatter | v1.5.5 | PASS ✓ |
| `prd-delta-576.md` frontmatter `spec_version_after` | `1.3.68` | PASS ✓ |
| `STATE.md` `current_step` | Stale (carries INFO-8; now stale at v1.3.68) | STALE (INFO-8 worsened) |

**Note on bc-3 frontmatter trace**: The v1.3.67 entry is now present at bc-3 line 100. This resolves INFO-NEW-8 from r37 — the v1.3.67 trace was added (likely as a cleanup backfill during the P28 round, as the spec-changelog [1.3.67] for bc-3 reads "JSON Output Shape Contracts download-row Notes updated" matching the P27-001 bc-3 body change). The v1.3.68 trace entry is absent; P28-001 modified bc-3 body but did not add a v1.3.68 frontmatter trace entry. See INFO-NEW-9 below.

---

## Spec vs Implementation Drift

| Artifact | Spec Version | Drift | Notes |
|----------|-------------|-------|-------|
| `bc-3-issue-write.md` frontmatter | v1.3.67 last trace (line 100) | partial — body updated at v1.3.68 but no trace | INFO-NEW-9 (body correctly updated; trace absent for v1.3.68) |
| `BC-INDEX.md` `index_version` | v6.28 | none | P28 update recorded in `last_updated` |
| `holdout-scenarios.md` frontmatter | v1.5.5 | none | Bumped from v1.5.4 by P28-002 |
| `spec-changelog.md` | [1.3.68] entry present | none | Entry dated 2026-07-17 |
| `prd-delta-576.md` `spec_version_after` | 1.3.68 | none | P28 dispositions section present |
| `STATE.md` | stale | yes | INFO-8 (carry-forward R25–R38); pre-existing condition |

---

## INFO Ledger Status

### INFO-1 (carry-forward R21–R38) — CARRY-FORWARD

Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7 in bc-2. Not introduced or worsened by P28.

**Status**: CARRY-FORWARD

---

### INFO-2 (carry-forward R21–R38) — CARRY-FORWARD

EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained. Not introduced or worsened by P28.

**Status**: CARRY-FORWARD

---

### INFO-3 (carry-forward R21–R38) — CARRY-FORWARD

BC-2.7.012 "KEY or AID 5xx" combined-scope row. Not introduced or worsened by P28.

**Status**: CARRY-FORWARD

---

### INFO-6 (carry-forward R23–R38) — CARRY-FORWARD

No holdout for collision-skip exit-0 path. Not introduced or worsened by P28.

**Status**: CARRY-FORWARD

---

### INFO-8 (carry-forward R25–R38) — CARRY-FORWARD

`STATE.md` spec version stale. Now stale at v1.3.68 (was stale at v1.3.67 after r37).

**Status**: CARRY-FORWARD

---

### INFO-11 (carry-forward R27–R38) — CARRY-FORWARD

`spec-changelog.md` [1.3.57] and `prd-delta-576.md` P17-002 disposition say "three sites" but four sites were actually modified. Not introduced or worsened by P28.

**Status**: CARRY-FORWARD

---

### INFO-15 (carry-forward R29–R38) — CARRY-FORWARD

`impact-boundary-576.md` BC-3.9.004 row has INCONCLUSIVE annotation. Not introduced or worsened by P28.

**Status**: CARRY-FORWARD

---

### INFO-NEW-5 (carry-forward R34–R38) — CARRY-FORWARD

BC-3.9.009 Trace field not updated with P24-001 citation (consistent with P19-001 non-citation precedent; BC-INDEX carries the authoritative amendment record). Not introduced or worsened by P28.

**Status**: CARRY-FORWARD

---

### INFO-NEW-6 (carry-forward R35–R38) — CARRY-FORWARD

EC-2.7.008-10 and EC-2.7.009-3 JSON-mode suppression — explicit in EC bodies. Not introduced or worsened by P28.

**Status**: CARRY-FORWARD

---

### INFO-NEW-7 (carry-forward R37–R38) — CARRY-FORWARD

Degenerate-name fallback warning ("warning: using id as filename for attachment `<AID>` — original name `'<raw>'` could not be sanitized.") JSON-mode behavior classification gap. Not introduced or worsened by P28.

**Status**: CARRY-FORWARD

---

### INFO-NEW-8 (RESOLVED R38)

**Previous finding** (R37): bc-3-issue-write.md frontmatter trace missing v1.3.67 entry; P27-001 changed bc-3 body (rows 3219-3220) but no v1.3.67 trace entry was added.

**Resolution**: bc-3-issue-write.md frontmatter now contains a v1.3.67 trace entry at line 100:

> `v1.3.67 — P27 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): 0 new BCs — JSON Output Shape Contracts download-row Notes updated: \`filename\` = RAW Jira name (pre-sanitization); \`path\` basename = on-disk name (post-sanitization; post-SHA-1-prefix for batch); single-id row references EC-2.7.007-7 (P27-001); batch row references EC-2.7.008-6 (P27-001); BC count unchanged (140/35)`

The entry accurately describes the P27-001 bc-3 changes. The spec-changelog [1.3.67] for bc-3 states "JSON Output Shape Contracts download-row Notes updated" — matching this trace. INFO-NEW-8 is RESOLVED.

**Status**: RESOLVED R38

---

### INFO-NEW-9 (NEW R38)

**Finding**: `bc-3-issue-write.md` frontmatter trace does not contain a v1.3.68 entry, despite P28-001 modifying bc-3's EC-3.9.020-8 body and BC-3.9.020 Trace field. The spec-changelog [1.3.68] lists bc-3 as MODIFIED. The bc-3 frontmatter's last trace entry is v1.3.67 (P27, line 100). By the pattern established since P21 (each round that modifies bc-3 body adds a trace entry to bc-3 frontmatter): P28 should have added a v1.3.68 trace entry. The spec-changelog [1.3.68] Changed Requirements description for bc-3 does NOT include "frontmatter trace v1.3.68 entry added" (unlike [1.3.67] which confirmed the bc-2 frontmatter trace was added).

**Scope**: Same gap class as INFO-NEW-8 was before it was resolved. Behavioral spec correctly updated (EC-3.9.020-8 body + BC-3.9.020 Trace); trace record absent from bc-3 frontmatter only. The spec-changelog [1.3.68] records the change at the changelog level.

**Severity**: INFO (behavioral specification is internally consistent; trace record gap only; pre-existing pattern of bc-3 frontmatter trace being one step behind when PO doesn't explicitly include a trace-update step).

**Status**: NEW R38

---

## Findings

### Critical

None.

### Major

None.

### GAPs

None.

### Minor (INFO)

- **INFO-1** (carry R21–R38): Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7.
- **INFO-2** (carry R21–R38): EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained.
- **INFO-3** (carry R21–R38): BC-2.7.012 "KEY or AID 5xx" combined-scope row.
- **INFO-6** (carry R23–R38): No holdout for collision-skip exit-0 path.
- **INFO-8** (carry R25–R38): STATE.md spec version stale (should be v1.3.68).
- **INFO-11** (carry R27–R38): P17-002 "three sites" undercount in spec-changelog/prd-delta.
- **INFO-15** (carry R29–R38): impact-boundary BC-3.9.004 INCONCLUSIVE annotation.
- **INFO-NEW-5** (carry R34–R38): BC-3.9.009 Trace field not updated with P24-001 citation.
- **INFO-NEW-6** (carry R35–R38): EC-2.7.008-10 / EC-2.7.009-3 JSON-mode suppression explicit in EC bodies; INFO carried pending formal resolution.
- **INFO-NEW-7** (carry R37–R38): Degenerate-name fallback warning ("warning: using id as filename...") unclassified for JSON-mode behavior in §2.7 taxonomy.
- **INFO-NEW-8**: RESOLVED R38 — v1.3.67 trace entry now present in bc-3 frontmatter at line 100.
- **INFO-NEW-9** (NEW R38): bc-3-issue-write.md frontmatter trace missing v1.3.68 entry; P28-001 modified bc-3 body (EC-3.9.020-8 wire enumeration + BC-3.9.020 Trace) but no v1.3.68 trace added (same gap class as INFO-NEW-8 before remediation).

---

## Validation Gate Result

**CONSISTENT**

P28-001 (MEDIUM) correctly and fully applied: EC-3.9.020-8 terminal sentence corrected from the erroneous "no HTTP calls beyond step-0 issue GET and meta fetch" to accurate enumeration — "no HTTP calls beyond the project-meta fetch (`GET /rest/api/3/project/{key}` — cache-miss; no `GET /rest/servicedeskapi/servicedesk` pagination since the project is NOT `service_desk`); no issue GET occurs on the `--replace-existing` step-0 path (project key derived from the issue-key string prefix per BC-3.9.017 step 0)"; P28-001 citation inline; cross-refs to BC-3.9.005, BC-3.9.017 step 0, EC-3.9.005-3. BC-3.9.020 Trace updated with P28-001 citation. BC-INDEX BC-3.9.020 row updated with P28-001 wire-enumeration corrected note. BC-INDEX index_version v6.27→v6.28.

P28-002 (MEDIUM) correctly and fully applied: H-NEW-ATTACHMENT-009 Expected bullet 4 narrowed from over-broad "Zero requests to any `/rest/servicedeskapi/...` path" to POST-only assertion — "Zero requests to the upload POSTs — `POST .../attachTemporaryFile` and `POST .../request/{key}/attachment`" with parenthetical acknowledging the `GET /rest/servicedeskapi/servicedesk` meta-resolution call DOES fire before the gate (mounted in setup step 3); licensing BCs added (BC-3.9.003 step 1 / BC-X.8.010 for GET; BC-3.9.014 gate for POST absence); mirrors VP-576-005 cancel-variant style. H-NEW-ATTACHMENT-009 Status updated with P28-002 citation. holdout frontmatter v1.5.4→v1.5.5; trace entry added.

Spot audit (H-008, H-010, H-011, VP-576-003, VP-576-005): All 5 independently confirmed CONSISTENT against wire contracts. H-008: non-JSM → BC-X.8.010 step (2) conditional FALSE → zero servicedeskapi calls; H-010: `--replace-existing` without `--public` → BC-3.9.017 step 0 no-op; gate fires at step 2 before DELETE/POST; H-011: non-JSM OQ-9 path → platform POST only; zero servicedeskapi; VP-576-003: non-JSM, no `--public` → step 0 no-op; DELETE-before-POST ordering; VP-576-005: JSM `--replace-existing --public` → step 0 project-meta + servicedesk GET (pre-gate); `?fields=attachment` GET (step 1, existence via P17-003); zero plain issue GET assertion consistent with string-prefix derivation and EC-3.9.003-5 suppression.

ECHO-BREAKER: (1) EC-3.9.020-8 corrected sentence licensed by BC-3.9.017 step 0 ("no issue GET has run yet") + BC-X.8.010 step (2) conditional (non-service-desk skips servicedesk pagination); no over-claim. (2) H-009 bullet 4 GET parenthetical licensed by H-009 setup step 3 (servicedesk GET mounted) + BC-X.8.010 resolution chain + BC-3.9.003 step 1 (POST after gate); POST-only zero assertion satisfiable. K-1 (EC-3.9.020-8 ↔ BC-3.9.017 step 0 ↔ BC-X.8.010 ↔ EC-3.9.005-3): COHERENT — all four surfaces consistently say no-issue-GET + project-meta-only + non-JSM skips servicedesk pagination. K-2 (H-009 bullet ↔ setup mounts ↔ VP-576-005 style ↔ BC-3.9.003 step 1): COHERENT — servicedesk GET fires pre-gate (mounted, expected); POST-only assertion mirrors VP-576-005 cancel-variant; internal fixture coherent. K-3 (issue-GET accounting across all paths): COHERENT — four paths, four distinct counts, no surface contradicts another; EC-3.9.020-8 corrected path (0 issue GETs) is consistent with BC-3.9.017 step 0 no-issue-GET canonical statement. Double-insertion sweep clean. Counts 657/100/35 verified by both guards (exit 0). Spec version 1.3.68 consistent across all primary surfaces. INFO-NEW-8 (bc-3 frontmatter missing v1.3.67 trace) RESOLVED — v1.3.67 entry now present at bc-3 line 100. One new INFO: INFO-NEW-9 (bc-3 frontmatter missing v1.3.68 trace; same gap class; body correctly updated). No behavioral gaps found.

---

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 50 |
| **Passed** | 49 |
| **Info** | 1 new (INFO-NEW-9), 1 resolved (INFO-NEW-8) |
| **Failed (GAPs)** | 0 |
| **Warnings (INFO)** | 10 total (9 carry-forward: INFO-1..3, INFO-6, INFO-8, INFO-11, INFO-15, INFO-NEW-5, INFO-NEW-6, INFO-NEW-7; 1 new: INFO-NEW-9) |
| **Overall Status** | consistent |

Round 38 is a PATCH-level validation confirming 2 MEDIUM P28 adversary-pass fix items: (1) P28-001 — EC-3.9.020-8 wire-enumeration corrected (project-meta fetch only, no issue GET, no servicedeskapi pagination on non-JSM `--replace-existing` step-0 path); FULLY APPLIED. (2) P28-002 — H-NEW-ATTACHMENT-009 Expected bullet 4 narrowed (POST-only servicedeskapi assertion; GET acknowledged as expected and mounted); FULLY APPLIED. Spot audit of 5 mount-vs-assertion items (H-008, H-010, H-011, VP-576-003, VP-576-005) confirms PO sweep verdicts. K-1..K-3 keystones all coherent. INFO-NEW-8 resolved (v1.3.67 bc-3 frontmatter trace now present). INFO-NEW-9 new (v1.3.68 bc-3 frontmatter trace absent).

---

## Appendix: Validation Methodology

This report was produced by a fresh-context consistency validator (cv-576-r38) with structural reference to r37 report only.

1. **Independent artifact read**: All 6 input artifacts read fresh. Findings formed independently from artifact text.
2. **Quote-based closure**: Every P28 priority check verified by verbatim quotation from the authoritative artifact (RE-READ at claim time — not carried from memory).
3. **K-1 sweep**: EC-3.9.020-8 corrected text, BC-3.9.017 step 0 canonical statement, BC-X.8.010 step (2) conditional, EC-3.9.005-3 pre-flight description — all read and verified mutually consistent.
4. **K-2 sweep**: H-009 setup step 3 (servicedesk GET mount), bullet 4 corrected text, VP-576-005 cancel-variant style assertion, BC-3.9.003 step 1 wire — read and verified fixture-coherent.
5. **K-3 check**: Four paths (plain `--public`; `--replace-existing` no-`--public`; combined `--replace-existing --public`; `--replace-existing --dry-run --public` non-JSM) enumerated; issue-GET counts per path verified against BC-3.9.003 Step 0 / BC-3.9.017 step 0 / EC-3.9.003-5 P17-003 / EC-3.9.020-8 corrected.
6. **Spot audit (5 items)**: H-008, H-010, H-011, VP-576-003, VP-576-005 — independently re-checked zero/no-request assertions against setup mounts and wire contracts; all CONSISTENT.
7. **ECHO-BREAKER (2 items)**: EC-3.9.020-8 corrected sentence and H-009 bullet 4 GET parenthetical — both traced to licensing sources; both satisfiable.
8. **Double-insertion sweep**: Marker occurrence counts for P28-001/P28-002 citations, [1.3.68] entry, v6.28 index, holdout v1.5.5. All counts explained by distinct legitimate locations.
9. **INFO-NEW-8 re-verification**: bc-3 frontmatter line 100 re-read — v1.3.67 trace entry confirmed present; INFO-NEW-8 marked RESOLVED.
10. **INFO-NEW-9 identification**: bc-3 frontmatter last entry = v1.3.67 (line 100), no v1.3.68 entry present despite P28-001 bc-3 body modification; new INFO raised.
11. **Guard scripts**: Both `check-spec-counts.sh` and `check-bc-cumulative-counts.sh` executed and verified "OK".
12. **Count sweep**: BC (657), holdout (100), VP (35) verified across BC-INDEX frontmatter, bc-2/bc-3 frontmatter, prd-delta-576.md P28 closing, spec-changelog [1.3.68] count table, and holdout-scenarios.md frontmatter.
