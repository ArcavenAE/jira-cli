---
document_type: consistency-report
round: 33
spec_version: 1.3.63
date: 2026-07-17
validator: cv-f2-576-r33 (fresh context, no prior round visibility)
verdict: CONSISTENT
bc_count: 657
holdout_count: 100
vp_count: 35
priority_checks: P23-001 (VP-576-005 fully replaced — 7 mounts/6 HTTP calls; explicit mount (2) GET /rest/servicedeskapi/servicedesk; mount (1) id="10050"; mount (2) projectId==project.id; mount (4) JR_STDIN_IS_TTY test-env; completeness enum (i)-(vi)), P23-002 (EC-3.9.020-7 GATES vs ELIGIBILITY GUARDS; EC-3.9.020-8 new; EC-3.9.005-3 dry-run cross-ref; BC-3.9.005/BC-3.9.020 Traces updated), P23-003 (VP-576-005 S5 allocation note; prd-delta S5 scope row mirrored), P23-004 (JSON shape table --replace-existing --dry-run row --public annotation), BC-INDEX v6.23, spec-changelog [1.3.63], prd-delta-576 P23 section + spec_version_after 1.3.63, FIXTURE-COMPLETENESS RECOMPUTATION (deepest check), keystones K-1..K-4, double-insertion sweep, ECHO-BREAKER List A (7 sentences) + List B (empty), INFO-NEW-1 (r32) RESOLUTION check
level: ops
version: "1.0"
status: consistent
producer: cv-f2-576-r33
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
input-hash: "27c2dae"
traces_to: ".factory/specs/prd/BC-INDEX.md"
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 33 (post-P23 remediation)

**Spec version**: 1.3.63 | **BCs**: 657 | **Holdouts**: 100 | **VPs**: 35 | **Verdict**: CONSISTENT

---

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) — SOH-ATTACHMENTS-1 F2 |
| **Generated** | 2026-07-17T00:00:00 |
| **Generator** | cv-f2-576-r33 (fresh-context consistency validator, round 33) |
| **Artifacts Scanned** | 7 (bc-3-issue-write.md, bc-2-issue-read.md, holdout-scenarios.md, BC-INDEX.md, CANONICAL-COUNTS.md, spec-changelog.md, prd-delta-576.md) |
| **Focus** | Post-P23 adversary-pass remediation verification — spec v1.3.62 → v1.3.63; FIXTURE-COMPLETENESS RECOMPUTATION (deepest check: VP-576-005 independently derived call set vs fixture's 6 enumerated calls); ECHO-BREAKER List A (7 P23 sentences) + List B (empty holdout verification); double-insertion sweep; K-1..K-4 keystones; INFO-NEW-1 (r32) resolution check |
| **Prior round** | consistency-report-576-r32.md (CONSISTENT; INFO-NEW-1 NEW: BC-2.7.012 body Trace missing P22-003 citation) |

---

## Summary Table

| # | Check | Result |
|---|-------|--------|
| P23-001 | VP-576-005: 7 mounts / 6 HTTP calls (explicit mount (2) GET /rest/servicedeskapi/servicedesk added) | pass |
| P23-001 | mount (1) carries "id":"10050" | pass |
| P23-001 | mount (2) asserts projectId==project.id match, NOT projectKey | pass |
| P23-001 | mount (4) is JR_STDIN_IS_TTY test-env step (non-HTTP) | pass |
| P23-001 | wire-completeness ECHO-BREAKER LIST-B enumeration (i)-(vi) embedded | pass |
| P23-001 | BC-INDEX BC-3.9.017 row: servicedesk-list mount fix note + S5 allocation note added | pass |
| P23-002 | EC-3.9.020-7: GATES vs ELIGIBILITY GUARDS distinction sentence present | pass |
| P23-002 | EC-3.9.020-8: new EC added — `--replace-existing --dry-run --public` on non-JSM → eligibility guard fires, exit 64, no preview | pass |
| P23-002 | EC-3.9.005-3: extended with dry-run non-suppression cross-ref to EC-3.9.020-8 | pass |
| P23-002 | BC-3.9.005 Trace: P23-002 citation present | pass |
| P23-002 | BC-3.9.020 Trace: P23-002 citation present | pass |
| P23-002 | BC-INDEX BC-3.9.005 row: EC-3.9.005-3 dry-run cross-ref note added | pass |
| P23-002 | BC-INDEX BC-3.9.020 row: EC-3.9.020-8 + GATES vs ELIGIBILITY GUARDS note added | pass |
| P23-003 | VP-576-005 story allocation annotation: "verified in S5 (S5 depends_on S3)... NOT part of S3 acceptance matrix (contrast VP-576-003)" | pass |
| P23-003 | prd-delta-576.md S5 scope row: VP-576-005 allocation note mirrored | pass |
| P23-004 | JSON shape table `--replace-existing --dry-run` row: `--public` `"visibility":"public"` wouldUpload note appended | pass |
| BC-INDEX v6.23 | index_version v6.22→v6.23; last_updated P23 note present | pass |
| spec-changelog [1.3.63] | Entry present dated 2026-07-17; Summary + Changed Requirements + Impact Assessment artifact table + count table | pass |
| spec-changelog [1.3.63] count table | BC 657 / Holdout 100 / VP 35 / New BCs 0 / New VPs 0 / New Holdouts 0 | pass |
| spec-changelog [1.3.63] Spec version row | MISSING from count table (see INFO-NEW-3) | INFO |
| prd-delta-576.md spec_version_after 1.3.63 | frontmatter updated | pass |
| prd-delta-576.md P23 dispositions section | present (unique); counts BC 657/holdout 100/VP 35/spec v1.3.63/both guards exit 0 | pass |
| Counts 657/100/35 | Consistent across all surfaces; both guards exit 0 | pass |
| Double-insertion sweep | No duplicate EC-3.9.020-8 bodies, VP-576-005 bodies, [1.3.63] entries, "Adversary Pass 23" section headings | pass |
| FIXTURE-COMPLETENESS RECOMPUTATION | Independently derived 6 HTTP calls = fixture's 6 enumerated calls; no missing mandated calls; no forbidden mounts | pass |
| FIXTURE: cancel variant zero-DELETE/POST satisfiable | Cancel fires at gate (step 2); DELETE (step 3) and POST (step 4) unreachable — assertion satisfiable | pass |
| FIXTURE: confirm-y vs --yes same mounts | Both variants exercise the same 6 HTTP mounts | pass |
| FIXTURE: mount (2) projectId "10050" == mount (1) id "10050" | Consistent | pass |
| K-1 | VP-576-005 fixture ↔ derived call set ↔ H-NEW-ATTACHMENT-009 wording parity | pass |
| K-2 | EC-3.9.020-8 ↔ EC-3.9.020-7 distinction ↔ EC-3.9.005-3 ↔ BC-3.9.017 step 0 — coherent guards-vs-gates story | pass |
| K-3 | S5-allocation note ↔ prd-delta Scope table ↔ EC-3.9.017-11/12 S5-realized notes ↔ VP-576-003 S3 contrast | pass |
| K-4 | JSON shape-table note ↔ EC-3.9.020-7 visibility sub-shape | pass |
| ECHO-BREAKER List A (7 sentences) | All 7 P23 behavioral sentences grounded in licensing sources; no over-claim | pass |
| ECHO-BREAKER List B | Empty — holdout-scenarios.md has 0 P23 references (verified by grep: 0 occurrences) | pass |
| INFO-NEW-1 (r32) | BC-2.7.012 body Trace P22-003 citation: NOW PRESENT at bc-2 line 949 — RESOLVED | pass |
| Guard: check-spec-counts.sh | OK: all spec counts verified | pass |
| Guard: check-bc-cumulative-counts.sh | OK: all cumulative BC counts verified (657 total across 8 files) | pass |

**No behavioral GAPs found. All P23 changes correctly applied. FIXTURE-COMPLETENESS RECOMPUTATION clean: independently derived 6 HTTP calls match fixture exactly; projectId consistency verified; cancel variant satisfiable; confirm-y/--yes work against same mounts. ECHO-BREAKER: 7 List-A sentences grounded, no over-claim; List-B empty confirmed. Double-insertion sweep clean. Keystones K-1..K-4 coherent. Spec version 1.3.63 consistent. Counts 657/100/35 verified by guards. INFO-NEW-1 (r32) RESOLVED. Two new INFO items (INFO-NEW-2: bc-2 micro-fix undocumented in P23 changelog; INFO-NEW-3: [1.3.63] count table missing Spec version row).**

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

## P23-001 — VP-576-005 Fully Replaced (7 Mounts / 6 HTTP Calls)

### Fixture Body — Quote-Verified

**VP-576-005** (bc-3-issue-write.md line 3786, opening):

> `**VP-576-005**: combined-gate single-prompt pin — \`jr issue attachment upload EJ-1 file.txt --replace-existing --public\` via wiremock against a JSM project with ≥1 same-filename match. **Wire setup (7 numbered steps; 6 wiremock mounts + 1 test-env step; BC-X.8.010 cache-miss assumed on both meta calls)**:`

Seven numbered steps present. "6 wiremock mounts + 1 test-env step" stated. ✓

**Mount (1)** (bc-3 line 3786):

> `(1) mount \`GET /rest/api/3/project/EJ\` returning \`{"id":"10050","projectTypeKey":"service_desk"}\` (first call of \`get_or_fetch_project_meta("EJ")\` per BC-X.8.010 cache-miss; project key derived from string prefix \`EJ-1\`→\`EJ\` per BC-3.9.017 step 0 — NO plain issue GET is issued at this step)`

Mount (1): GET /rest/api/3/project/EJ returning {"id":"10050",...}. `id: "10050"` explicit. No plain issue GET. ✓

**Mount (2)** (bc-3 line 3786):

> `(2) mount \`GET /rest/servicedeskapi/servicedesk\` returning a valid service desk with \`projectId == "10050"\` matching the \`id\` from mount (1) (second call of \`get_or_fetch_project_meta\` per BC-X.8.010 cache-miss — pagination call to resolve \`serviceDeskId\`; per H-NEW-ATTACHMENT-009 wording; match is \`serviceDesk.projectId == project.id\`, NOT \`projectKey\` — BC-3.9.003 step 1 sdId resolution; P23-001)`

Explicit mount (2) for GET /rest/servicedeskapi/servicedesk present. projectId == "10050" (matches mount (1) id "10050"). Match is `serviceDesk.projectId == project.id`, NOT `projectKey`. P23-001 citation present. ✓

**Mount (4)** (bc-3 line 3786):

> `(4) set \`JR_STDIN_IS_TTY=1\`, pipe \`"y\n"\` to stdin`

Mount (4) is the JR_STDIN_IS_TTY env step (non-HTTP). ✓

**Wire completeness (ECHO-BREAKER LIST-B)** (bc-3 line 3786):

> `**Wire completeness (P23-001, ECHO-BREAKER LIST-B)**: full expected call set from BC-3.9.017 steps 0–4 + BC-3.9.003/004 routing + BC-X.8.010 cache-miss: (i) GET /rest/api/3/project/EJ → mount (1) [BC-3.9.017 step 0; BC-X.8.010 cache-miss GET-1]; (ii) GET /rest/servicedeskapi/servicedesk → mount (2) [BC-X.8.010 cache-miss GET-2 — serviceDeskId resolution; BC-3.9.003 step 1]; (iii) GET /rest/api/3/issue/EJ-1?fields=attachment → mount (3) [BC-3.9.017 step 1; EC-3.9.003-5 P17-003]; (iv) DELETE /rest/api/3/attachment/20001 → mount (5) [BC-3.9.017 step 3; EC-3.9.017-1]; (v) POST .../attachTemporaryFile → mount (6) [BC-3.9.003 step 1]; (vi) POST .../request/EJ-1/attachment → mount (7) [BC-3.9.003 step 2]. All 6 HTTP calls mounted; each mount licensed by a specific BC clause. Step (4) is test-env setup (not an HTTP call).`

Completeness enumeration (i)-(vi) present, each with licensing BC clause. 6 HTTP calls. ✓

**BC-INDEX BC-3.9.017 row** (BC-INDEX.md line 389):

> `| BC-3.9.017 | ... **VP-576-005 wire fix (P23-001)**: explicit servicedesk-list mount (2) (GET /rest/servicedeskapi/servicedesk) split from project GET mount (1); mounts renumbered 1→7; wire-completeness ECHO-BREAKER LIST-B added; **VP-576-005 story allocation (P23-003)**: verified in S5 (S5 depends_on S3), textual home BC-3.9.017, NOT S3 acceptance matrix | — (SOH-ATTACHMENTS-1 adversary pass-1 R1; P15-002; P23-001; P23-003) | ...`

P23-001 and P23-003 citations both present. ✓

**Result**: P23-001 APPLIED ✓.

---

## FIXTURE-COMPLETENESS RECOMPUTATION (Deepest Check — VP-576-005)

### Independent Derivation from First Principles

**Path**: `jr issue attachment upload EJ-1 file.txt --replace-existing --public` on a JSM project with ≥1 same-filename match (cache-miss guaranteed).

**Step 0** (BC-3.9.017 step 0): `get_or_fetch_project_meta(client, "EJ")` — project key derived from `EJ-1` string prefix; BC-X.8.010 cache-miss mandates:
- HTTP call A: `GET /rest/api/3/project/EJ` [BC-X.8.010 cache-miss GET-1]
- HTTP call B: `GET /rest/servicedeskapi/servicedesk` [BC-X.8.010 cache-miss GET-2 — serviceDeskId pagination]

Result: projectTypeKey = "service_desk" (JSM), serviceDeskId resolved. Step 0 also evaluates BC-3.9.005 eligibility check (non-JSM → exit 64; JSM → continue).

**Step 1** (BC-3.9.017 step 1): `GET /rest/api/3/issue/EJ-1?fields=attachment` — list attachments; also validates existence per EC-3.9.003-5 P17-003 (Step-0 suppression: plain issue GET is suppressed on combined `--replace-existing --public` path; exactly ONE issue GET per invocation):
- HTTP call C: `GET /rest/api/3/issue/EJ-1?fields=attachment`

Result: 1 same-filename match ("file.txt", id="20001").

**Step 2** (BC-3.9.017 step 2): ≥1 match + `--public` → BC-3.9.014 consumer 3 (combined gate); `--dry-run` absent → gate fires; interactive (JR_STDIN_IS_TTY=1) → combined prompt presented. No HTTP call.

**Step 3** (BC-3.9.017 step 3): DELETE same-filename attachments serially:
- HTTP call D: `DELETE /rest/api/3/attachment/20001` [EC-3.9.017-1]

**Step 4** (BC-3.9.017 step 4): Route to BC-3.9.003 for `--public` upload. BC-3.9.003 Step 0 SKIPPED per EC-3.9.003-5 (entered from BC-3.9.017 step 4; existence validated by step 1 GET — ONE issue GET per invocation):
- HTTP call E: `POST /rest/servicedeskapi/servicedesk/{sdId}/attachTemporaryFile` [BC-3.9.003 step 1]
- HTTP call F: `POST /rest/servicedeskapi/request/EJ-1/attachment` [BC-3.9.003 step 2]

**Derived total: 6 HTTP calls.**

### Comparison Against Fixture Enumeration

| Derived call | Fixture mount | Match? |
|---|---|---|
| (A) GET /rest/api/3/project/EJ [BC-X.8.010 GET-1] | mount (1) — GET /rest/api/3/project/EJ [BC-3.9.017 step 0; BC-X.8.010 cache-miss GET-1] | ✓ |
| (B) GET /rest/servicedeskapi/servicedesk [BC-X.8.010 GET-2] | mount (2) — GET /rest/servicedeskapi/servicedesk [BC-X.8.010 cache-miss GET-2; serviceDeskId resolution] | ✓ |
| (C) GET /rest/api/3/issue/EJ-1?fields=attachment [BC-3.9.017 step 1] | mount (3) — GET EJ-1?fields=attachment [BC-3.9.017 step 1; EC-3.9.003-5 P17-003] | ✓ |
| (D) DELETE /rest/api/3/attachment/20001 [BC-3.9.017 step 3; EC-3.9.017-1] | mount (5) — DELETE /rest/api/3/attachment/20001 [BC-3.9.017 step 3; EC-3.9.017-1] | ✓ |
| (E) POST .../attachTemporaryFile [BC-3.9.003 step 1] | mount (6) — POST .../attachTemporaryFile [BC-3.9.003 step 1] | ✓ |
| (F) POST .../request/EJ-1/attachment [BC-3.9.003 step 2] | mount (7) — POST .../request/EJ-1/attachment [BC-3.9.003 step 2] | ✓ |

**Result: Derived set = fixture set. 6/6 calls match. No missing mandated calls. No forbidden mounts.**

**BC-3.9.003 Step 0 suppression**: per EC-3.9.003-5 P17-003, the plain issue GET (`GET /rest/api/3/issue/EJ-1`) is SUPPRESSED on the combined `--replace-existing --public` path entered from BC-3.9.017 step 4. Assert (d) in fixture correctly mandates ZERO plain GET /rest/api/3/issue/EJ-1 (strict mode). ✓

**mount (2) projectId consistency**: mount (1) returns `{"id":"10050",...}`; mount (2) returns service desk with `projectId == "10050"`. "10050" == "10050". Match criterion is `serviceDesk.projectId == project.id` (not `projectKey`). ✓

**confirm-y vs --yes variants use same mounts**: both exercise all 6 HTTP mounts; confirm-y pipes `"y\n"` to stdin; `--yes` asserts ZERO prompts and same DELETE+upload sequence. Both satisfiable against the same 6 mounts. ✓

**cancel variant (assert (c)) satisfiable**: cancel fires at step 2 (confirmation gate) when user pipes `"\n"` (empty-Enter). Steps 3+ (DELETE, POST) are never reached. In a cancel-variant test the DELETE and POST mounts would not be set up (or wiremock strict mode verifies they were never called). Assert "ZERO DELETE requests and ZERO servicedeskapi POST requests" is satisfiable. ✓

**FIXTURE-COMPLETENESS RECOMPUTATION: PASS ✓**

---

## P23-002 — Guards-vs-Gates Ruling Encoded

### EC-3.9.020-7 GATES vs ELIGIBILITY GUARDS Distinction

**Quote-verified** (bc-3-issue-write.md EC-3.9.020-7, line 3891):

> `**GATES vs ELIGIBILITY GUARDS (P23-002)**: dry-run suppression in this EC applies exclusively to BC-3.9.014 confirmation gates; eligibility guards (BC-3.9.005 non-JSM exit-64 check and BC-3.9.017 step 0 validity checks) are NOT dry-run-suppressed — they fire unconditionally before any list GET, even on dry-run; see EC-3.9.020-8. Exit 0. P14-009; P15-002/R3.12 (extended to cover replace-existing match gate); P23-002.`

GATES vs ELIGIBILITY GUARDS sentence present before "Exit 0." P23-002 citation appended to citation line. No surface remaining implying eligibility guards are dry-run-suppressed within EC-3.9.020-7. ✓

### EC-3.9.020-8 (New EC)

**Quote-verified** (bc-3-issue-write.md EC-3.9.020-8, line 3892):

> `**EC-3.9.020-8** (\`--replace-existing --dry-run --public\`, non-JSM — eligibility guard fires): \`--dry-run\` does NOT suppress the BC-3.9.005 eligibility guard. On a non-JSM issue key, \`jr issue attachment upload <KEY> <FILE> --replace-existing --dry-run --public\` exits 64 with the canonical BC-3.9.005 message before any list GET is issued and before any dry-run preview is emitted; \`--dry-run\` is irrelevant because the guard fires at BC-3.9.017 step 0, which is before the list-fetch step that \`--dry-run\` would preview. This mirrors EC-3.9.005-3 (which documents the same guard on the non-dry-run path). The GATES vs ELIGIBILITY GUARDS distinction: gates (BC-3.9.014) protect destructive calls and are suppressed on dry-run because no destruction occurs; eligibility guards protect against invalid flag combinations and are never suppressed. Exit 64; no preview emitted; no HTTP calls beyond step-0 issue GET and meta fetch. P23-002; BC-3.9.005; BC-3.9.017 step 0; EC-3.9.005-3.`

EC-3.9.020-8 present as distinct numbered EC definition. `--dry-run` non-suppression of eligibility guard specified. GATES vs ELIGIBILITY GUARDS distinction stated. "Exit 64; no preview emitted" present. Cross-references to BC-3.9.005, BC-3.9.017 step 0, EC-3.9.005-3 present. P23-002 citation. ✓

**DOUBLE-INSERTION CHECK**: EC-3.9.020-8 appears 7 times in bc-3:
- Line 97 (frontmatter trace v1.3.63 description): EXPECTED — 1 reference in history note
- Line 3385 (EC-3.9.005-3 body cross-ref): EXPECTED — 1 reference
- Line 3387 (EC-3.9.005-3 Trace): EXPECTED — 1 reference
- Line 3891 (EC-3.9.020-7 body cross-ref): EXPECTED — 1 reference
- Line 3892 (EC-3.9.020-8 definition): EXPECTED — 1 definition
- Line 3894 (BC-3.9.020 Trace): EXPECTED — 1 reference
- Line 3899 (bc-3 footer): EXPECTED — 1 reference

All 7 occurrences at distinct legitimate locations. No double-insertion of EC-3.9.020-8 body definition. ✓

### EC-3.9.005-3 Extension

**Quote-verified** (bc-3-issue-write.md EC-3.9.005-3, line 3385):

> `**EC-3.9.005-3** (\`--public --replace-existing\`, non-JSM, P8-002): pre-flight fires at BC-3.9.017 step 0; exit 64; canonical message; **zero DELETEs issued; zero upload POST**. The list GET (BC-3.9.017 step 1) is never reached. This guard fires even when \`--dry-run\` is supplied — eligibility guards are NOT dry-run-suppressed (contrast BC-3.9.014 gates which ARE suppressed per EC-3.9.020-7; see EC-3.9.020-8; P23-002). No preview is emitted.`

Dry-run non-suppression cross-ref added: "This guard fires even when `--dry-run` is supplied — eligibility guards are NOT dry-run-suppressed (contrast BC-3.9.014 gates which ARE suppressed per EC-3.9.020-7; see EC-3.9.020-8; P23-002). No preview is emitted." ✓

**BC-3.9.005 Trace** (bc-3 line 3387):

> `**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); OQ-9 ruling (--internal non-JSM = silent no-op; --public non-JSM = exit 64 — asymmetric by design); P23-002 (EC-3.9.005-3 extended: dry-run does not suppress this eligibility guard; cross-ref EC-3.9.020-8)`

P23-002 citation present in BC-3.9.005 Trace. ✓

**BC-3.9.020 Trace** (bc-3 line 3894):

> `**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); impact-boundary-576.md R3.2 (--dry-run scope + output shape); BC-3.4.021 (\`issue edit --dry-run\` output precedent); adversary pass-1 human ruling R1 (2026-07-15); #526 JSON render invariant; P14-009 (--replace-existing --dry-run --public gate suppression + EC-3.9.020-7); P14-010 (BC-3.9.020 retitle to cover upload path c); P23-002 (EC-3.9.020-7 GATES vs ELIGIBILITY GUARDS distinction; EC-3.9.020-8 --dry-run non-suppression of eligibility guard)`

P23-002 citation present in BC-3.9.020 Trace. ✓

**BC-INDEX BC-3.9.005 row** (BC-INDEX.md line 377):

> `| BC-3.9.005 | ... **EC-3.9.005-3 (P23-002)**: this eligibility guard fires even when \`--dry-run\` is supplied — eligibility guards are NOT dry-run-suppressed (contrast BC-3.9.014 gates; cross-ref EC-3.9.020-8) | — (SOH-ATTACHMENTS-1 F2; P23-002) | ...`

EC-3.9.005-3 dry-run non-suppression note and P23-002 citation present. ✓

**BC-INDEX BC-3.9.020 row** (BC-INDEX.md line 392):

> `| BC-3.9.020 | ... **GATES vs ELIGIBILITY GUARDS (P23-002)**: dry-run suppresses ONLY BC-3.9.014 confirmation gates; eligibility guards (BC-3.9.005, BC-3.9.017 step 0) fire unconditionally even on \`--dry-run\`; **EC-3.9.020-8 (P23-002)**: \`--replace-existing --dry-run --public\` on non-JSM exits 64 before any list GET — no preview emitted (EC-3.9.005-3 non-suppression on dry-run) | — (SOH-ATTACHMENTS-1 adversary pass-1 R1; P7-001; P23-002) | ...`

EC-3.9.020-8 and GATES vs ELIGIBILITY GUARDS note with P23-002 citation present. ✓

**Result**: P23-002 APPLIED ✓.

---

## P23-003 — VP-576-005 S5-Allocation Note

### VP-576-005 Story Allocation Annotation

**Quote-verified** (bc-3-issue-write.md VP-576-005 story allocation, line 3786):

> `**Story allocation (P23-003)**: verified in S5 (S5 depends_on S3) — exercises the combined \`--public\` JSM two-step; textual home BC-3.9.017 (S3) per the EC-3.9.017-11/12 S5-realized pattern; NOT part of the S3 acceptance matrix (contrast VP-576-003, genuinely S3). Pins EC-3.9.017-11 (combined \`--public\` + ≥1 match → ONE prompt, not two), EC-3.9.017-12 (\`--yes\` single-bypass for all gate conditions), the invariant "cancel at gate → zero DELETE + zero POST", BC-3.9.017 step 0 (string-prefix project key derivation, no plain issue GET), and EC-3.9.003-5 P17-003 (ONE issue GET per invocation on combined \`--replace-existing --public\` path). P20-006; P21-002; P23-001; P23-003; cross-ref BC-3.9.017, EC-3.9.017-11/12.`

"verified in S5 (S5 depends_on S3)" present. "NOT part of the S3 acceptance matrix" present. "contrast VP-576-003, genuinely S3" present. P23-003 citation present. ✓

### prd-delta-576.md S5 Scope Row

**Quote-verified** (prd-delta-576.md S5 row, line 35):

> `**VP-576-005 allocation (P23-003)**: VP-576-005 (combined-gate single-prompt pin) is verified in S5 (S5 depends_on S3) — exercises the combined \`--public\` JSM two-step (EC-3.9.017-11/12); textual home BC-3.9.017; NOT part of the S3 acceptance matrix (contrast VP-576-003, genuinely S3 — non-public \`--replace-existing\`).`

S5 scope row updated with VP-576-005 allocation note and P23-003 citation. Consistent with VP body text: both say "verified in S5 (S5 depends_on S3)", "NOT part of the S3 acceptance matrix", "contrast VP-576-003, genuinely S3". Minor wording difference: prd-delta adds "— non-public `--replace-existing`" qualifier absent from VP body; not a contradiction. ✓

**Result**: P23-003 APPLIED ✓.

---

## P23-004 — JSON Shape Table Note

**Quote-verified** (bc-3-issue-write.md JSON Output Shape Contracts table, line 3224):

> `| \`attachment upload --replace-existing --dry-run\` | \`{"dryRun":true,"wouldDelete":[{"filename":"<name>","id":"<AID>"}],"wouldUpload":[{"filename":"<name>"}]}\` | 3 keys alphabetical at all depths (dryRun < wouldDelete < wouldUpload; filename < id within elements); BC-3.9.020 path c; ships with S3; with \`--public\`: wouldUpload entries include \`"visibility":"public"\` — EC-3.9.020-7; P23-004 |`

Note appended: `with \`--public\`: wouldUpload entries include \`"visibility":"public"\` — EC-3.9.020-7; P23-004`. EC-3.9.020-7 cited as licensing source. ✓

**Result**: P23-004 APPLIED ✓.

---

## BC-INDEX v6.22→v6.23

**Quote-verified** (BC-INDEX.md frontmatter, lines 5–6):

```yaml
last_updated: 2026-07-17  # P23 adversary fix round: BC-3.9.005 row dry-run non-suppression cross-ref EC-3.9.020-8 added (P23-002); BC-3.9.017 row VP-576-005 servicedesk-list explicit mount-2 note + S5 allocation note added (P23-001; P23-003); BC-3.9.020 row EC-3.9.020-8 + GATES vs ELIGIBILITY GUARDS distinction note added (P23-002); spec v1.3.63; BC count unchanged (657); holdout count 100 (unchanged); VP count 35 (unchanged); BC-INDEX v6.23. Previous: P22 adversary fix round: ...
index_version: v6.23
```

`index_version` v6.22→v6.23. `last_updated` includes all 3 P23 row updates (BC-3.9.005, BC-3.9.017, BC-3.9.020) + spec v1.3.63 note. Internally consistent. ✓

**Result**: BC-INDEX v6.23 APPLIED ✓.

---

## spec-changelog [1.3.63]

**Quote-verified** (`spec-changelog.md` entry at line 10):

```
## [1.3.63] - 2026-07-17

### Type: PATCH
```

Entry present; dated 2026-07-17. ✓

**Summary** (line 16): Present — describes P23-001 (MEDIUM: VP-576-005 explicit mount 2; projectId match; mounts renumbered; LIST-B), P23-002 (LOW: ORCHESTRATOR RULING; EC-3.9.020-7 distinction; EC-3.9.020-8; EC-3.9.005-3 extended; Traces updated), P23-003 (LOW: story allocation annotation), P23-004 (INFO: JSON table row note). All 4 P23 items described. ✓

**Changed Requirements** (lines 18–22): Lists 3 modified files (bc-3-issue-write.md, BC-INDEX.md, prd-delta-576.md) with per-item descriptions. Note: bc-2-issue-read.md NOT listed (see INFO-NEW-2 below). ✓

**Impact Assessment artifact table** (lines 26–30): 3 rows (bc-3-issue-write.md, BC-INDEX.md, prd-delta-576.md). ✓

**Impact Assessment count table** (lines 32–39):

```
| Dimension | Value |
|---|---|
| BC count | 657 (unchanged) |
| Holdout count | 100 (unchanged) |
| VP count | 35 (unchanged) |
| New BCs | 0 |
| New VPs | 0 |
| New Holdouts | 0 |
```

6-row table present. All BC/holdout/VP counts correct. **Note: "Spec version | 1.3.62→1.3.63" row is ABSENT** — the pattern established at [1.3.60] and maintained through [1.3.62] is not followed here (see INFO-NEW-3). Non-blocking: version is in the section heading `## [1.3.63] - 2026-07-17` and in prd-delta frontmatter. ✓ (with INFO-NEW-3)

**Result**: spec-changelog [1.3.63] APPLIED ✓ (with INFO-NEW-3: missing Spec version row).

---

## prd-delta-576.md Frontmatter + P23 Section

**Quote-verified** (`prd-delta-576.md` frontmatter, line 8):

```yaml
spec_version_after: 1.3.63
```

`spec_version_after` updated to 1.3.63. ✓

**P23 section heading** (`prd-delta-576.md` line 424):

> `## Adversary Pass 23 Fix Round Finding Dispositions`

P23 section present (unique — grep count: 1). ✓

**P23 preamble** (line 426):

> `Source: Adversary Pass 23. 1 MEDIUM / 2 LOW / 1 INFO findings. Spec version bump: 1.3.62 → 1.3.63. No new BCs. Holdouts: 100 (unchanged). VPs: 35 (unchanged).`

Finding counts and version bump correct. ✓

**P23-001 disposition** (line 430): APPLIED; VP-576-005 explicit servicedesk-list mount (2) added; match is projectId == project.id per H-NEW-ATTACHMENT-009 wording; mounts renumbered 1→7; LIST-B enumeration added; BC-INDEX updated. ✓
**P23-002 disposition** (line 431): APPLIED; ORCHESTRATOR RULING encoded; EC-3.9.020-7 GATES vs ELIGIBILITY GUARDS; EC-3.9.020-8 added; EC-3.9.005-3 extended; BC-3.9.005/BC-3.9.020 Traces; BC-INDEX updated. ✓
**P23-003 disposition** (line 432): APPLIED; VP-576-005 story allocation annotated; prd-delta S5 scope row updated. ✓
**P23-004 disposition** (line 433): APPLIED; JSON table row note appended per EC-3.9.020-7. ✓

**P23 closing statement** (`prd-delta-576.md` line 435):

> `**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.63. Both guards exit 0.**`

Closing correct: BC 657 / holdout 100 / VP 35 / spec v1.3.63 / both guards exit 0. ✓

**Result**: prd-delta-576.md P23 APPLIED ✓.

---

## Double-Insertion Sweep

| Marker | Count | Locations | Assessment |
|--------|-------|-----------|------------|
| `EC-3.9.020-8` in `bc-3-issue-write.md` | 7 | lines 97 (frontmatter trace), 3385 (EC-3.9.005-3 body), 3387 (EC-3.9.005-3 Trace), 3891 (EC-3.9.020-7 body), 3892 (EC-3.9.020-8 definition), 3894 (BC-3.9.020 Trace), 3899 (footer) | EXPECTED — 7 distinct roles; exactly 1 body definition |
| `[1.3.63]` in `spec-changelog.md` | 1 | line 10 | No duplicate entry |
| `## Adversary Pass 23 Fix Round` in `prd-delta-576.md` | 1 | line 424 | No duplicate section |
| `VP-576-005` in `bc-3-issue-write.md` | 5 | lines 94, 95, 97 (frontmatter trace history), 3786 (body definition), 3899 (footer) | EXPECTED — all distinct legitimate locations; 1 body definition |
| `GATES vs ELIGIBILITY GUARDS` in `bc-3-issue-write.md` | 5 | lines 97 (frontmatter trace), 3891 (EC-3.9.020-7 body), 3892 (EC-3.9.020-8 body), 3894 (BC-3.9.020 Trace), 3899 (footer) | EXPECTED — 5 distinct roles |
| `v1.3.63` in `bc-3-issue-write.md` frontmatter trace | 1 | line 97 | EXPECTED — frontmatter trace entry |
| `spec v1.3.63` in `bc-3-issue-write.md` footer | 1 | line 3899 | EXPECTED — footer summary |

**No double-insertions detected.** All marker counts explained by distinct legitimate locations. ✓

---

## ECHO-BREAKER Audit — List A (7 Sentences)

### Sentence 1: VP-576-005 Mount (2) Claim

**New text (verbatim)** (bc-3 line 3786, mount (2) segment): `"(2) mount \`GET /rest/servicedeskapi/servicedesk\` returning a valid service desk with \`projectId == "10050"\` matching the \`id\` from mount (1) (second call of \`get_or_fetch_project_meta\` per BC-X.8.010 cache-miss — pagination call to resolve \`serviceDeskId\`; per H-NEW-ATTACHMENT-009 wording; match is \`serviceDesk.projectId == project.id\`, NOT \`projectKey\` — BC-3.9.003 step 1 sdId resolution; P23-001)"`

**Licensing basis**:
- `GET /rest/servicedeskapi/servicedesk` as the BC-X.8.010 cache-miss GET-2: BC-3.9.004 row (BC-INDEX line 376): "branch-(a) HTTP sequence: ... project-meta resolution per BC-X.8.010 (up to 2 cache-miss GETs: GET /rest/api/3/project/{key} + GET /rest/servicedeskapi/servicedesk pagination for serviceDeskId)" ✓
- `serviceDesk.projectId == project.id` NOT projectKey: holdout-scenarios.md line 1696 Note: "matches by `d.project_id == project_id` (the project `id` string, NOT by project key)"; line 1700: "`projectId` MUST equal the `id` from step 1 for the match to succeed. No `projectKey` field (not in `ServiceDesk` struct)." ✓
- H-NEW-ATTACHMENT-009 wording: step 3 establishes the same GET /rest/servicedeskapi/servicedesk mount returning a service desk with serviceDeskId resolved ✓

**Assessment**: All three elements licensed. No over-claim. ✓

---

### Sentence 2: Wire Completeness (ECHO-BREAKER LIST-B) Enumeration

**New text (verbatim)** (bc-3 line 3786, completeness segment): `"Wire completeness (P23-001, ECHO-BREAKER LIST-B): full expected call set from BC-3.9.017 steps 0–4 + BC-3.9.003/004 routing + BC-X.8.010 cache-miss: (i)...(vi). All 6 HTTP calls mounted; each mount licensed by a specific BC clause. Step (4) is test-env setup (not an HTTP call)."`

**Licensing basis**: As verified in the FIXTURE-COMPLETENESS RECOMPUTATION above — the 6-call enumeration is derived directly from BC-3.9.017 steps 0–4, BC-3.9.003 steps 1–2, BC-X.8.010 two-call cache-miss, and EC-3.9.003-5 P17-003 Step-0 suppression. Each of the 6 calls is licensed by a named BC clause and cross-checked against derived expectations.

**Assessment**: All 6 calls licensed. "6 HTTP calls mounted" is accurate (mount (4) is confirmed to be the test-env step, not an HTTP call). No over-claim. ✓

---

### Sentence 3: EC-3.9.020-7 GATES vs ELIGIBILITY GUARDS Distinction

**New text (verbatim)** (bc-3 line 3891): `"**GATES vs ELIGIBILITY GUARDS (P23-002)**: dry-run suppression in this EC applies exclusively to BC-3.9.014 confirmation gates; eligibility guards (BC-3.9.005 non-JSM exit-64 check and BC-3.9.017 step 0 validity checks) are NOT dry-run-suppressed — they fire unconditionally before any list GET, even on dry-run; see EC-3.9.020-8."`

**Licensing basis**:
- "BC-3.9.014 confirmation gates" suppressed on dry-run: EC-3.9.020-7 main body (existing text) — "Dry-run is read-only — no DELETE and no upload POST is issued — so per BC-3.9.017's invariant (no destructive call → no gate fires), no gate fires." ✓
- "eligibility guards (BC-3.9.005 non-JSM exit-64 check and BC-3.9.017 step 0 validity checks) are NOT dry-run-suppressed": BC-3.9.005 (non-JSM exit 64 fires at step 0 of BC-3.9.017 — before the list GET); BC-3.9.017 step 0 validity checks fire before step 1; `--dry-run` only previews the step 1+ behavior ✓
- "they fire unconditionally before any list GET": BC-3.9.017 step 0 fires first; step 1 (list GET) comes after; `--dry-run` suppresses the destructive calls after step 1, not step 0 itself ✓

**Assessment**: The distinction is licensed by the logical structure: gates protect destructive calls (suppressed when no destruction); eligibility guards protect against invalid flag combinations (applicable regardless of dry-run). No over-claim. ✓

---

### Sentence 4: EC-3.9.020-8 Core Claim

**New text (verbatim)** (bc-3 line 3892, opening): `"\`--dry-run\` does NOT suppress the BC-3.9.005 eligibility guard. On a non-JSM issue key, \`jr issue attachment upload <KEY> <FILE> --replace-existing --dry-run --public\` exits 64 with the canonical BC-3.9.005 message before any list GET is issued and before any dry-run preview is emitted; \`--dry-run\` is irrelevant because the guard fires at BC-3.9.017 step 0, which is before the list-fetch step that \`--dry-run\` would preview."`

**Licensing basis**:
- BC-3.9.005 guard fires at BC-3.9.017 step 0: EC-3.9.005-3 (P8-002): "pre-flight fires at BC-3.9.017 step 0; exit 64; canonical message" ✓
- BC-3.9.017 step 0 is before the list-fetch step: BC-3.9.017 step ordering: step 0 (meta resolution) → step 1 (list GET) ✓
- "before any list GET" and "before any dry-run preview": both are after step 1 (the list GET), which comes after step 0 ✓
- "exits 64 with the canonical BC-3.9.005 message": BC-3.9.005 defines canonical message ✓

**Assessment**: Licensed by BC-3.9.005 + BC-3.9.017 step ordering + EC-3.9.005-3. No over-claim. ✓

---

### Sentence 5: EC-3.9.005-3 Dry-Run Non-Suppression Extension

**New text (verbatim)** (bc-3 line 3385, extension): `"This guard fires even when \`--dry-run\` is supplied — eligibility guards are NOT dry-run-suppressed (contrast BC-3.9.014 gates which ARE suppressed per EC-3.9.020-7; see EC-3.9.020-8; P23-002). No preview is emitted."`

**Licensing basis**:
- "This guard fires even when `--dry-run` is supplied": BC-3.9.017 step 0 fires unconditionally; the guard is at step 0 before any list GET ✓
- "contrast BC-3.9.014 gates which ARE suppressed per EC-3.9.020-7": EC-3.9.020-7 explicitly suppresses BC-3.9.014 gates on `--dry-run` ✓
- "No preview is emitted": on exit 64 before step 1 (list GET), there are no matches to preview ✓

**Assessment**: Licensed. Contrast with EC-3.9.020-7 correctly stated. No over-claim. ✓

---

### Sentence 6: VP-576-005 Story Allocation Claim

**New text (verbatim)** (bc-3 line 3786, Story allocation): `"**Story allocation (P23-003)**: verified in S5 (S5 depends_on S3) — exercises the combined \`--public\` JSM two-step; textual home BC-3.9.017 (S3) per the EC-3.9.017-11/12 S5-realized pattern; NOT part of the S3 acceptance matrix (contrast VP-576-003, genuinely S3)."`

**Licensing basis**:
- "verified in S5 (S5 depends_on S3)": prd-delta S5 scope row: "combined `--public` ECs (EC-3.9.017-11/12: combined single-prompt, `--yes` bypass) and the step-4 BC-3.9.003 `--public` routing are S5-realized; S5 depends_on S3 for the underlying `--replace-existing` delete-and-upload mechanics" ✓
- "textual home BC-3.9.017 (S3) per the EC-3.9.017-11/12 S5-realized pattern": prd-delta-576.md S3 scope row BC-3.9.017 split note: "non-public `--replace-existing` path (EC-3.9.017-1..10) ships with S3" ✓
- "NOT part of the S3 acceptance matrix (contrast VP-576-003, genuinely S3)": VP-576-003 is described as the non-public `--replace-existing` pin at BC-3.9.017 (prd-delta P14-007 via BC-3.9.017 VP-576-003 footnote) — S3 deliverable ✓

**Assessment**: Licensed by prd-delta scope table and split notes. No over-claim. ✓

---

### Sentence 7: JSON Shape Table `--public` wouldUpload Note

**New text (verbatim)** (bc-3 line 3224, Notes column): `"with \`--public\`: wouldUpload entries include \`"visibility":"public"\` — EC-3.9.020-7; P23-004"`

**Licensing basis**:
- EC-3.9.020-7 (bc-3 line 3891, existing text before P23-002 addition): "When `--public` is supplied on dry-run, JSON output still includes `"visibility":"public"` in `wouldUpload` entries; human output includes a `[public]` annotation." ✓

**Assessment**: Table note is a direct cross-reference to existing EC-3.9.020-7 text — no new behavioral claim is introduced; only a missing cross-reference is added. No over-claim. ✓

---

### List B Verification

P23 touches bc-3-issue-write.md, BC-INDEX.md, and prd-delta-576.md. **No holdout-scenarios.md or VP body text in holdout-scenarios.md modified**.

Verification: grep for "P23" in holdout-scenarios.md — **0 occurrences**. No P23 references in any holdout body text.

**List B EMPTY confirmed** ✓.

---

## Keystone Coherence Checks

### K-1: VP-576-005 fixture ↔ derived call set ↔ H-NEW-ATTACHMENT-009 wording parity

| Element | Claim | Source |
|---------|-------|--------|
| VP-576-005 fixture | 6 HTTP calls: GET project, GET servicedesk, GET ?fields=attachment, DELETE, POST attachTemporaryFile, POST request/attachment | bc-3 line 3786 wire completeness (i)-(vi) |
| Independently derived set | Same 6 calls from BC-3.9.017 steps 0–4 + BC-3.9.003 steps 1–2 + BC-X.8.010 + EC-3.9.003-5 | FIXTURE-COMPLETENESS RECOMPUTATION above |
| H-NEW-ATTACHMENT-009 wording | "GET /rest/servicedeskapi/servicedesk returning a valid service desk with serviceDeskId" + Note (line 1696): "matches by d.project_id == project_id (the project `id` string, NOT by project key)"; "projectId MUST equal the `id` from step 1 for the match to succeed" | holdout-scenarios.md lines 2443, 1696, 1700 |
| VP-576-005 mount (2) | "projectId == '10050'" matches mount (1) "id":"10050"; "match is serviceDesk.projectId == project.id, NOT projectKey" | bc-3 line 3786 mount (2) |

H-NEW-ATTACHMENT-009 wording establishes `projectId == project.id` (not `projectKey`) as the match criterion — VP-576-005 mount (2) reflects this exactly. Fixture, derived set, and H-009 are in parity. **K-1 COHERENT ✓**

---

### K-2: EC-3.9.020-8 ↔ EC-3.9.020-7 distinction ↔ EC-3.9.005-3 ↔ BC-3.9.017 step 0 — one coherent guards-vs-gates story

| Element | Claim | Source |
|---------|-------|--------|
| EC-3.9.020-7 | "dry-run suppression applies exclusively to BC-3.9.014 confirmation gates; eligibility guards NOT dry-run-suppressed — fire unconditionally before any list GET, even on dry-run" | bc-3 line 3891 |
| EC-3.9.020-8 | "`--dry-run` does NOT suppress BC-3.9.005 eligibility guard; guard fires at BC-3.9.017 step 0, before the list-fetch step that `--dry-run` would preview; exit 64; no preview emitted" | bc-3 line 3892 |
| EC-3.9.005-3 | "This guard fires even when `--dry-run` is supplied — eligibility guards NOT dry-run-suppressed" | bc-3 line 3385 |
| BC-3.9.017 step 0 | Fires unconditionally before step 1 (list GET); includes JSM eligibility check | bc-3 BC-3.9.017 body |

No surface remaining implies eligibility guards are dry-run-suppressed. Gates vs guards distinction is consistent across all four surfaces. No residual gap. **K-2 COHERENT ✓**

---

### K-3: S5-allocation note ↔ prd-delta Scope table ↔ EC-3.9.017-11/12 S5-realized notes ↔ VP-576-003 S3 contrast

| Element | Claim | Source |
|---------|-------|--------|
| VP-576-005 Story allocation | "verified in S5 (S5 depends_on S3)... NOT part of S3 acceptance matrix (contrast VP-576-003, genuinely S3)" | bc-3 line 3786 |
| prd-delta S5 scope row | "VP-576-005 (combined-gate single-prompt pin) is verified in S5 (S5 depends_on S3)... NOT part of the S3 acceptance matrix (contrast VP-576-003, genuinely S3 — non-public `--replace-existing`)" | prd-delta-576.md line 35 |
| prd-delta S3 scope row BC-3.9.017 split note | "non-public `--replace-existing` path (EC-3.9.017-1..10) ships with S3; combined `--public` ECs (EC-3.9.017-11/12) and step-4 BC-3.9.003 routing are S5-realized" | prd-delta-576.md line 33 |
| EC-3.9.017-11/12 S5-realized | Combined-public single-prompt (11) and --yes bypass (12) are S5-realized per prd-delta | prd-delta-576.md lines 33, 35 |

All four surfaces agree: VP-576-005 is S5, not S3. VP-576-003 is S3 (non-public --replace-existing). No contradiction. **K-3 COHERENT ✓**

---

### K-4: JSON shape-table note ↔ EC-3.9.020-7 visibility sub-shape

| Element | Claim | Source |
|---------|-------|--------|
| JSON table `--replace-existing --dry-run` row, Notes | "with `--public`: wouldUpload entries include `"visibility":"public"` — EC-3.9.020-7; P23-004" | bc-3 line 3224 |
| EC-3.9.020-7 (existing text, pre-P23-002 sentence) | "When `--public` is supplied on dry-run, JSON output still includes `"visibility":"public"` in `wouldUpload` entries" | bc-3 line 3891 |

Table note is a correct cross-reference to EC-3.9.020-7. No new behavioral claim. **K-4 COHERENT ✓**

---

## Cross-Reference Validation

### BC Counts

| Source | bc-2 definitional | bc-2 total_bcs | bc-3 definitional | bc-3 total_bcs | Grand Total |
|--------|-------------------|-----------------|-------------------|-----------------|-------------|
| Frontmatter | 64 | 106 | 111 | 140 | 657 |
| CANONICAL-COUNTS.md | 64 | 106 | 111 | 140 | 657 |
| Guard output | verified | — | verified | — | 657 |

P23 added 0 new BCs. PASS ✓

### Holdout Counts

| Source | Count | Status |
|--------|-------|--------|
| `holdout-scenarios.md` frontmatter `total_holdouts` | 100 | PASS ✓ |
| `CANONICAL-COUNTS.md` canonical total | 100 | PASS ✓ |
| `prd-delta-576.md` P23 closing | "Holdout count: 100 (unchanged)" | PASS ✓ |
| `spec-changelog.md` [1.3.63] count table | "Holdout count: 100 (unchanged)" | PASS ✓ |

### VP Counts

| Source | VP count reference | Status |
|--------|-------------------|--------|
| `prd-delta-576.md` P23 closing | "VP count: 35 (unchanged)" | PASS ✓ |
| `bc-3-issue-write.md` footer | "VP count 35 (unchanged)" | PASS ✓ |
| `BC-INDEX.md` last_updated | "VP count 35 (unchanged)" | PASS ✓ |
| `spec-changelog.md` [1.3.63] count table | "VP count: 35 (unchanged)" | PASS ✓ |

---

## Spec Version Surface Verification

| Artifact | Spec version shown | Status |
|----------|--------------------|--------|
| `spec-changelog.md` | `[1.3.63] - 2026-07-17` entry present | PASS ✓ |
| `bc-3-issue-write.md` frontmatter trace | v1.3.63 entry at line 97 | PASS ✓ |
| `bc-3-issue-write.md` footer | "spec v1.3.63" at line 3899 | PASS ✓ |
| `BC-INDEX.md` `last_updated` | "spec v1.3.63" in P23 note | PASS ✓ |
| `prd-delta-576.md` frontmatter `spec_version_after` | `1.3.63` | PASS ✓ |
| `bc-2-issue-read.md` frontmatter trace | No v1.3.63 entry (P23 did not touch bc-2 per changelog) | NOTE (see INFO-NEW-2) |
| `STATE.md` `current_step` | Stale (carries INFO-8) | STALE (INFO-8 carries forward) |

---

## INFO Ledger Status

### INFO-1 (carry-forward R21–R33) — CARRY-FORWARD

Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7 in bc-2. Not introduced or worsened by P23.

**Status**: CARRY-FORWARD

---

### INFO-2 (carry-forward R21–R33) — CARRY-FORWARD

EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained. Not introduced or worsened by P23.

**Status**: CARRY-FORWARD

---

### INFO-3 (carry-forward R21–R33) — CARRY-FORWARD

BC-2.7.012 "KEY or AID 5xx" combined-scope row. Not introduced or worsened by P23.

**Status**: CARRY-FORWARD

---

### INFO-4 (carry-forward R22–R33) — CARRY-FORWARD

H-NEW-ATTACHMENT-003 BC refs footer does not list `BC-2.7.008 EC-2.7.008-6` for Call B2. Not introduced or worsened by P23.

**Status**: CARRY-FORWARD

---

### INFO-6 (carry-forward R23–R33) — CARRY-FORWARD

No holdout for the collision-skip exit-0 path. Not introduced or worsened by P23.

**Status**: CARRY-FORWARD

---

### INFO-8 (carry-forward R25–R33) — CARRY-FORWARD

`STATE.md` spec version stale. Now stale at v1.3.63 (was stale at v1.3.62 after r32).

**Status**: CARRY-FORWARD

---

### INFO-11 (carry-forward R27–R33) — CARRY-FORWARD

`spec-changelog.md` [1.3.57] and `prd-delta-576.md` P17-002 disposition say "three sites" but four sites were actually modified. Not introduced or worsened by P23.

**Status**: CARRY-FORWARD

---

### INFO-13 (carry-forward R28–R33) — CARRY-FORWARD

`error-taxonomy.md` row 95 issue-GET 403 sub-variant lacks BC-2.7.006 citation. Not introduced or worsened by P23.

**Status**: CARRY-FORWARD

---

### INFO-15 (carry-forward R29–R33) — CARRY-FORWARD

`impact-boundary-576.md` BC-3.9.004 row has INCONCLUSIVE annotation; BC-3.9.004 is now fully defined. Not introduced or worsened by P23.

**Status**: CARRY-FORWARD

---

### INFO-NEW-1 (NEW R32) — RESOLVED

`bc-2-issue-read.md` BC-2.7.012 body Trace field was missing P22-003 citation (r32 found: "Current Trace ends with P21-006"). **NOW RESOLVED**: BC-2.7.012 Trace at bc-2 line 949 **quote-verified** to contain:

> `**Trace**: F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design; research §6 JRACLOUD-96384/-78388 VERIFIED); P21-006 (KEY-404 batch-paths-only annotation — \`--id\` does not server-verify KEY per BC-2.7.007); P22-003 (body prose "Unknown issue key" sentence prepended with batch-only caveat: batch paths only — \`--all\`/\`--newest\`; \`--id\` does not server-verify KEY per BC-2.7.007)`

P22-003 citation now present in body Trace. The fix was applied as a micro-fix alongside P23 work (bc-2 not listed in spec-changelog [1.3.63] Changed Requirements — see INFO-NEW-2).

**Status**: RESOLVED ✓

---

### INFO-NEW-2 (NEW R33)

`bc-2-issue-read.md` BC-2.7.012 body Trace was updated (P22-003 citation added — resolving INFO-NEW-1) but this modification is NOT documented in `spec-changelog.md` [1.3.63] Changed Requirements (bc-2-issue-read.md absent from the Changed Requirements list). Additionally, `bc-2-issue-read.md` frontmatter trace has no v1.3.63 entry (last entry is adversary pass-22, spec v1.3.62). The change is non-behavioral and content-correct; the documentation gap is minor.

**Severity**: INFO. Non-blocking.

---

### INFO-NEW-3 (NEW R33)

`spec-changelog.md` [1.3.63] count table is missing the "Spec version | 1.3.62→1.3.63" row. The pattern established at [1.3.60] (per r32 investigation) and maintained through [1.3.61] and [1.3.62] is not followed at [1.3.63]. The [1.3.63] table has 6 rows (BC count, Holdout count, VP count, New BCs, New VPs, New Holdouts) but lacks "Spec version". Non-blocking: the spec version is stated in the section heading `## [1.3.63] - 2026-07-17` and in prd-delta frontmatter `spec_version_after: 1.3.63`.

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

- **INFO-NEW-1** (NEW R32): BC-2.7.012 body Trace P22-003 citation — RESOLVED (now present at bc-2 line 949; quote-verified).

### Minor (INFO)

- **INFO-1** (carry R21–R33): Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7.
- **INFO-2** (carry R21–R33): EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained.
- **INFO-3** (carry R21–R33): BC-2.7.012 "KEY or AID 5xx" combined-scope row.
- **INFO-4** (carry R22–R33): H-NEW-ATTACHMENT-003 BC refs footer missing EC-2.7.008-6 for Call B2.
- **INFO-6** (carry R23–R33): No holdout for collision-skip exit-0 path.
- **INFO-8** (carry R25–R33): STATE.md spec version stale (should be v1.3.63).
- **INFO-11** (carry R27–R33): P17-002 "three sites" undercount in spec-changelog/prd-delta.
- **INFO-13** (carry R28–R33): error-taxonomy row 95 issue-GET 403 lacks BC-2.7.006 citation.
- **INFO-15** (carry R29–R33): impact-boundary BC-3.9.004 INCONCLUSIVE annotation; BC-3.9.004 now fully defined.
- **INFO-NEW-2** (NEW R33): bc-2-issue-read.md modified (BC-2.7.012 Trace P22-003 citation added — resolving INFO-NEW-1) but not listed in spec-changelog [1.3.63] Changed Requirements; no bc-2 frontmatter v1.3.63 entry.
- **INFO-NEW-3** (NEW R33): spec-changelog [1.3.63] count table missing "Spec version | 1.3.62→1.3.63" row (pattern drift from [1.3.60]–[1.3.62]).

---

## Validation Gate Result

**CONSISTENT**

All 4 P23 fix-round items (P23-001..P23-004) correctly applied. No behavioral GAPs. FIXTURE-COMPLETENESS RECOMPUTATION (deepest check): independently derived 6 HTTP calls from BC-3.9.017 steps 0–4 + BC-3.9.003 steps 1–2 + BC-X.8.010 cache-miss + EC-3.9.003-5 P17-003 Step-0 suppression = fixture's 6 enumerated calls exactly; no mandated call missing, no forbidden mount present; projectId "10050" in mount (2) consistent with id "10050" in mount (1); confirm-y and --yes variants both cover the same 6 mounts; cancel variant's zero-DELETE/zero-POST assertion is satisfiable (cancel fires before step 3). ECHO-BREAKER List A: 7 sentences grounded — (1) mount (2) explicit servicedesk-list GET licensed by BC-X.8.010 + H-009 wording; (2) LIST-B 6-call enumeration licensed by BC derivation; (3) EC-3.9.020-7 GATES vs ELIGIBILITY GUARDS licensed by logical structure of gate-protection vs flag-invalidity; (4) EC-3.9.020-8 --dry-run non-suppression licensed by BC-3.9.017 step ordering; (5) EC-3.9.005-3 extension licensed by step-0 guard timing; (6) VP-576-005 S5 allocation licensed by prd-delta split notes; (7) JSON table note is direct EC-3.9.020-7 cross-reference, no new behavioral claim. No over-claim on any sentence. List-B verified empty (holdout-scenarios.md has 0 P23 references by grep). Double-insertion sweep clean. Keystones K-1..K-4 coherent. Spec version 1.3.63 consistent across all spec surfaces. BC count 657 / holdout count 100 / VP count 35 confirmed by both guards (exit 0). INFO-NEW-1 (r32) RESOLVED (P22-003 citation in BC-2.7.012 Trace). Two new INFO items: INFO-NEW-2 (bc-2 micro-fix undocumented in P23 changelog — non-blocking, content correct) and INFO-NEW-3 (spec-changelog [1.3.63] count table missing Spec version row — pattern drift, non-blocking). 10 carry-forward INFO items unchanged.

---

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 37 |
| **Passed** | 37 |
| **Resolved** | 1 (INFO-NEW-1 r32) |
| **Failed (GAPs)** | 0 |
| **Warnings (INFO)** | 9 carry-forward + 2 new (INFO-1..4 carry; INFO-6 carry; INFO-8 carry; INFO-11, INFO-13, INFO-15 carry; INFO-NEW-2 new; INFO-NEW-3 new) |
| **Overall Status** | consistent |

Round 33 is a PATCH-level validation confirming 4 P23 adversary-pass fixes: (1) VP-576-005 fully replaced — 7 mounts / 6 HTTP calls; explicit mount (2) for GET /rest/servicedeskapi/servicedesk (BC-X.8.010 cache-miss GET-2); mount (1) id="10050"; mount (2) projectId==project.id NOT projectKey per H-NEW-ATTACHMENT-009 wording; mount (4) is JR_STDIN_IS_TTY test-env step; wire-completeness ECHO-BREAKER LIST-B enumeration (i)-(vi) embedded (P23-001 MEDIUM); (2) ORCHESTRATOR RULING encoded — EC-3.9.020-7 GATES vs ELIGIBILITY GUARDS distinction added; EC-3.9.020-8 added (--replace-existing --dry-run --public on non-JSM → eligibility guard fires at BC-3.9.017 step 0, exit 64, no preview); EC-3.9.005-3 extended with dry-run non-suppression cross-ref; BC-3.9.005/BC-3.9.020 Traces updated; BC-INDEX BC-3.9.005/BC-3.9.020 rows updated (P23-002 LOW); (3) VP-576-005 annotated "verified in S5 (S5 depends_on S3)... NOT part of S3 acceptance matrix (contrast VP-576-003)"; prd-delta S5 scope row mirrored (P23-003 LOW); (4) JSON shape table --replace-existing --dry-run row: --public wouldUpload "visibility":"public" note appended per EC-3.9.020-7 (P23-004 INFO). BC-INDEX v6.22→v6.23. spec-changelog [1.3.63] present. prd-delta-576.md spec_version_after 1.3.63 + P23 dispositions section. No double-insertions. Spec version advances to 1.3.63. BC count 657 / holdout count 100 / VP count 35 (all unchanged). INFO-NEW-1 (r32) RESOLVED (P22-003 citation in BC-2.7.012 Trace).

---

## Appendix: Validation Methodology

This report was produced by a fresh-context consistency validator (cv-f2-576-r33) with structural reference to r32 report only.

1. **Independent artifact read**: All 7 input artifacts read fresh. Findings formed independently from artifact text.
2. **Quote-based closure**: Every P23 priority check verified by verbatim quotation from the authoritative artifact (RE-READ at claim time — not carried from memory; r28/r32 stale-carry warning heeded).
3. **FIXTURE-COMPLETENESS RECOMPUTATION**: VP-576-005 expected HTTP call set independently derived from BC-3.9.017 steps 0–4, BC-3.9.003 steps 1–2, BC-X.8.010 two-call cache-miss, EC-3.9.003-5 P17-003 Step-0 suppression, EC-3.9.017-1 delete semantics. Result compared against fixture's 6 enumerated calls: identical. Forbidden mount (plain issue GET) confirmed absent via assert (d). Variant satisfiability verified.
4. **Double-insertion sweep**: Exact marker occurrence counts verified for EC-3.9.020-8 (7 distinct locations), [1.3.63] (1), "Adversary Pass 23" (1), VP-576-005 (5), "GATES vs ELIGIBILITY GUARDS" (5). All counts explained by distinct legitimate locations.
5. **ECHO-BREAKER List A (7 sentences)**: Each of the 7 new P23 behavioral/structural sentences traced to licensing sources; no over-claim identified.
6. **ECHO-BREAKER List B**: Verified empty by grep of holdout-scenarios.md for "P23" — 0 occurrences.
7. **Keystone checks**: K-1 through K-4 verified against quoted text from each referenced source.
8. **INFO ledger re-verification**: INFO-NEW-1 (r32) verified RESOLVED by fresh quote from bc-2 line 949 (P22-003 citation now present). 10 carry-forward INFOs unaffected by P23. 2 new INFO items identified.
9. **Guard scripts**: Both `check-spec-counts.sh` and `check-bc-cumulative-counts.sh` executed and verified "OK".
10. **Count sweep**: BC (657), holdout (100), VP (35) verified across BC-INDEX frontmatter, bc-2/bc-3 frontmatter, prd-delta-576.md P23 closing, spec-changelog [1.3.63] count table, and holdout-scenarios.md frontmatter.
