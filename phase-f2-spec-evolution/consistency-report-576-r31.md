---
document_type: consistency-report
round: 31
spec_version: 1.3.61
date: 2026-07-16
validator: cv-f2-576-r31 (fresh context, no prior round visibility)
verdict: CONSISTENT
bc_count: 657
holdout_count: 100
vp_count: 35
priority_checks: P21-001 (BC-3.9.010 bulk-404 benign-skip + H-012), P21-002 (VP-576-005 fixture mounts renumbered + assert-d), P21-003 (Group 19 header ..012), P21-004 (BC-3.9.004 branch-(a) BC-X.8.010 expansion), P21-005 (EC-3.9.004-4 + BC-3.9.017 step 4 cross-ref), P21-006 (BC-2.7.012 KEY-404 annotation), BC-INDEX v6.21, spec-changelog [1.3.61], prd-delta-576 P21 section, double-insertion sweep, echo-breaker audit (5 List-A sentences + ALL List-B fixture mounts), K-1..K-5 keystones, bulk-404-exit-64 residue scan, guard output
level: ops
version: "1.0"
status: consistent
producer: cv-f2-576-r31
timestamp: 2026-07-16T00:00:00
phase: 2
inputs:
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/specs/prd/CANONICAL-COUNTS.md"
  - ".factory/spec-changelog.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
input-hash: "1ae4c98"
traces_to: ".factory/specs/prd/BC-INDEX.md"
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 31 (post-P21 remediation)

**Spec version**: 1.3.61 | **BCs**: 657 | **Holdouts**: 100 | **VPs**: 35 | **Verdict**: CONSISTENT

---

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) — SOH-ATTACHMENTS-1 F2 |
| **Generated** | 2026-07-16T00:00:00 |
| **Generator** | cv-f2-576-r31 (fresh-context consistency validator, round 31) |
| **Artifacts Scanned** | 7 (bc-3-issue-write.md, bc-2-issue-read.md, holdout-scenarios.md, BC-INDEX.md, CANONICAL-COUNTS.md, spec-changelog.md, prd-delta-576.md) |
| **Focus** | Post-P21 adversary-pass remediation verification — spec v1.3.60 → v1.3.61; hook-timeout double-insertion risk; ECHO-BREAKER List A (5 of 9) + ALL of List B (fixture mounts/call-counts for VP-576-005 and H-012) |
| **Prior round** | consistency-report-576-r30.md (CONSISTENT; INFO-NEW-1: CANONICAL-COUNTS.md Group 19 range + reconciliation Note stale at 98/P15) |

---

## Summary Table

| # | Check | Result |
|---|-------|--------|
| P21-001 | BC-3.9.010 bulk-delete paragraph rewritten — "404 is NOT a failure on the bulk path" | pass |
| P21-001 | EC-3.9.010-4 added (bulk 404 = benign-skip; 404'd AID excluded from count/ids; iteration continues; first NON-404 failure stops) | pass |
| P21-001 | BC-3.9.013 multi-delete 404 exception consistent with EC-3.9.010-4 + BC-3.9.010 body | pass |
| P21-001 | Single-vs-bulk 404 divergence cross-ref (BC-3.9.008 vs BC-3.9.013 "intentionally asymmetric MUST NOT be unified") present | pass |
| P21-001 | H-NEW-ATTACHMENT-012 added (3-AID bulk, middle AID 40002 → 404, count=2, ids=[40001,40003], exit 0, wiremock asserts 3 DELETEs) | pass |
| P21-001 | Holdout total 99→100 in holdout-scenarios.md frontmatter, preamble, CANONICAL-COUNTS.md, prd-delta-576.md, spec-changelog | pass |
| P21-002 | VP-576-005 plain GET /rest/api/3/issue/EJ-1 mount removed | pass |
| P21-002 | VP-576-005 mounts renumbered: (1) project GET + service desk meta, (2) ?fields=attachment GET | pass |
| P21-002 | VP-576-005 assert (d) added: wiremock strict mode verifies ZERO plain GET /rest/api/3/issue/EJ-1 | pass |
| P21-003 | Group 19 header range bumped to (H-NEW-ATTACHMENT-001..012) in holdout-scenarios.md line 2063 | pass |
| P21-004 | BC-3.9.004 branch-(a) HTTP sequence expanded to BC-X.8.010 full resolution (up to 2 cache-miss GETs) | pass |
| P21-004 | BC-3.9.004 branch-(b) non-JSM sequence unchanged (verified) | pass |
| P21-004 | BC-3.9.004 Trace updated with P21-004 citation | pass |
| P21-004 | BC-INDEX BC-3.9.004 row updated with servicedesk pagination expansion | pass |
| P21-005 | EC-3.9.004-4 added (Step-0 suppression on --replace-existing --internal; symmetric with EC-3.9.003-5 P17-003) | pass |
| P21-005 | BC-3.9.017 step 4 cross-ref to BC-3.9.004 EC-3.9.004-4 added | pass |
| P21-005 | BC-3.9.004 Trace updated with P21-005 citation | pass |
| P21-005 | BC-INDEX BC-3.9.004 row updated with EC-3.9.004-4 note | pass |
| P21-006 | BC-2.7.012 KEY-404 row annotated "(batch paths only — `--id` does not server-verify KEY per BC-2.7.007)" | pass |
| P21-006 | BC-INDEX BC-2.7.012 row updated with batch-paths-only annotation and P21-006 citation | pass |
| BC-INDEX v6.21 | index_version v6.20→v6.21; last_updated note includes all three rows + P21 round note | pass |
| spec-changelog [1.3.61] | Entry present; Summary + Changed Requirements + Impact Assessment table present | pass |
| prd-delta-576.md spec_version_after 1.3.61 | frontmatter updated; holdout_count_after 100; P21 dispositions section present | pass |
| Double-insertion sweep | No duplicate v1.3.61 entries, EC-3.9.004-4 blocks, H-012 headings, P21 dispositions sections | pass |
| Bulk-404-exit-64 residue scan | No surviving "404 → exit 64" in any BULK context; single-AID BC-3.9.008/EC-3.9.013-1 correctly retained | pass |
| K-1 | BC-3.9.010 body ↔ EC-3.9.010-4 ↔ BC-3.9.013 ↔ H-012 — coherent bulk-404 benign-skip story | pass |
| K-2 | VP-576-005 mounts ↔ BC-3.9.017 steps 0-4 ↔ EC-3.9.003-5 one-issue-GET ↔ BC-X.8.010 | pass |
| K-3 | EC-3.9.004-4 ↔ EC-3.9.003-5 symmetry ↔ BC-3.9.017 step-4 dual routing (--public→BC-3.9.003, --internal→BC-3.9.004) | pass |
| K-4 | BC-3.9.004 branch-(a) call counts ↔ BC-3.9.003 step 1 ↔ BC-X.8.010 (identical resolution story for --public and --internal JSM) | pass |
| K-5 | Group 19 header ..012 ↔ body scenario set ↔ CANONICAL-COUNTS enumeration | pass |
| Echo-breaker List A (5 sentences) | All 5 audited P21 behavioral sentences grounded in licensing sources | pass |
| Echo-breaker List B (all fixture mounts) | VP-576-005 + H-012 mount/call-count sets verified against wire contracts; no forbidden calls added; no mandated calls omitted | pass |
| Counts 657/100/35 | Consistent across BC-INDEX, spec-changelog, prd-delta, holdout-scenarios, CANONICAL-COUNTS, bc-3 footer, bc-2 footer | pass |
| Guard: check-spec-counts.sh | OK: all spec counts verified | pass |
| Guard: check-bc-cumulative-counts.sh | OK: all cumulative BC counts verified (657 total across 8 files) | pass |
| INFO-NEW-1 from r30 resolution | CANONICAL-COUNTS.md Group 19 range now ..012 (+12); reconciliation Note now references 100 and P21-001 | RESOLVED |

**No behavioral GAPs found. All P21 changes correctly applied. Echo-breaker audit of 5 List-A sentences and all List-B fixture mounts found no over-claims. Double-insertion sweep found no duplicates. Bulk-404-exit-64 residue scan clean. Spec version 1.3.61 consistent. Counts 657/100/35 verified by guards.**

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

## P21-001 — BC-3.9.010 Bulk-404 Body Rewritten + H-NEW-ATTACHMENT-012 + Holdout 99→100

### BC-3.9.010 Bulk-Delete Body

**Quote-verified verbatim** (`bc-3-issue-write.md` BC-3.9.010 body, line 3494):

> `**404 is NOT a failure on the bulk path**: a 404 response to any individual DELETE is treated as already-deleted (benign race) per EC-3.9.010-4 and BC-3.9.013 multi-delete 404 exception; the 404'd AID is excluded from `count` and `ids`, and iteration continues. The first NON-404 failure (403, 401, 5xx, network) stops the batch immediately and surfaces the error. ... **Single-vs-bulk 404 divergence (cross-ref BC-3.9.008 / BC-3.9.013)**: 404 on a single-AID targeted delete exits 64 per BC-3.9.008 (DEC-168: targeted delete of a specific ID is a user error); 404 on any AID in a multi-AID bulk delete is a benign skip per BC-3.9.013 — these behaviors are intentionally asymmetric and MUST NOT be unified. [P21-001]`

"404 is NOT a failure on the bulk path" present; single-vs-bulk divergence cross-ref present; "intentionally asymmetric MUST NOT be unified" present. ✓

**EC-3.9.010-4 (line 3503)**:

> `**EC-3.9.010-4** (partial bulk failure): on multi-AID bulk delete, a 404 response to any individual DELETE is treated as already-deleted (benign race — consistent with BC-3.9.013 multi-delete 404 exception); the 404'd AID is EXCLUDED from the success `count` and `ids` (it was not deleted by this invocation); iteration continues. The first NON-404 failure (403, 401, 5xx, network) stops the batch immediately; error is surfaced (error JSON in JSON mode, stderr in human mode); already-deleted AIDs are not reversed. **All-404 edge case**: if ALL supplied AIDs return 404 (all were already deleted), count = 0 → JSON shape is `{"count":0,"deleted":false,"ids":[]}` (zero-count semantics above); exit 0 (all skipped as benign races; no genuine error).`

EC-3.9.010-4 present and complete. ✓

**BC-3.9.013 multi-delete 404 exception (line 3587)**:

> `**Multi-delete 404 exception (bulk and --replace-existing paths)**: on multi-attachment delete paths (`--older-than`, multi-AID bulk per BC-3.9.016, `--replace-existing` delete phase per BC-3.9.017), a 404 response to an individual `DELETE` is treated as already-deleted (benign race condition) and is silently skipped; iteration continues. Exit 64 on 404 applies only to single-AID targeted deletes (BC-3.9.008). Non-404 errors (403, 5xx, network) on any delete attempt abort the sequence and surface the error.`

BC-3.9.013 exception consistent with EC-3.9.010-4 and BC-3.9.010 body. ✓

### H-NEW-ATTACHMENT-012

**Quote-verified** (`holdout-scenarios.md` heading, line 2528):

> `### H-NEW-ATTACHMENT-012: `attachment delete <AID1> <AID2> <AID3>` with mid-batch 404 → benign-skip-continue; count=2; 404'd AID excluded from ids; exit 0; all three DELETEs issued (MUST-PASS)`

H-012 heading unique (one heading occurrence at line 2528; one reference in preamble trace at line 22). ✓

**Setup** (lines 2536–2540):
1. Wiremock at JR_BASE_URL. Config with valid profile at JR_CONFIG_DIR. Three AIDs: 40001, 40002 (404), 40003.
2. DELETE /rest/api/3/attachment/40001 → HTTP 204.
3. DELETE /rest/api/3/attachment/40002 → HTTP 404 with Jira error body.
4. DELETE /rest/api/3/attachment/40003 → HTTP 204.
5. Wiremock strict-mode.

**Expected** (lines 2544–2548): Exit 0; JSON stdout `{"count":2,"deleted":true,"ids":["40001","40003"]}`; wiremock asserts exactly 3 DELETE calls; no error to stderr. ✓

### Holdout Count 99→100 Surface Verification

| Surface | Count | Status |
|---------|-------|--------|
| `holdout-scenarios.md` frontmatter `total_holdouts` | 100 | PASS ✓ |
| `holdout-scenarios.md` body preamble line 28 | "100 holdout scenarios" | PASS ✓ |
| `CANONICAL-COUNTS.md` canonical total line 111 | "**Canonical holdout total: 100**" | PASS ✓ |
| `CANONICAL-COUNTS.md` enumeration line 118 | H-NEW-ATTACHMENT-001..H-NEW-ATTACHMENT-012 | PASS ✓ |
| `prd-delta-576.md` frontmatter `holdout_count_after` | 100 | PASS ✓ |
| `prd-delta-576.md` P21 closing | "Holdout count: 100 (+1 H-NEW-ATTACHMENT-012)" | PASS ✓ |
| `spec-changelog.md` [1.3.61] artifact table | "holdout-scenarios.md: H-NEW-ATTACHMENT-012 added; Group 19 header; total 99→100" | PASS ✓ |
| `spec-changelog.md` [1.3.61] CANONICAL-COUNTS row | "Holdout total 99→100" | PASS ✓ |

**Result**: APPLIED ✓. BC-3.9.010 bulk-delete body correctly rewritten. EC-3.9.010-4 present and complete. BC-3.9.013 multi-delete exception consistent. H-NEW-ATTACHMENT-012 added. Holdout count 100 consistent everywhere.

---

## P21-002 — VP-576-005 Fixture Corrected

**Quote-verified** (`bc-3-issue-write.md` VP-576-005, line 3784):

> `**VP-576-005**: combined-gate single-prompt pin — `jr issue attachment upload EJ-1 file.txt --replace-existing --public` via wiremock against a JSM project with ≥1 same-filename match: (1) mount `GET /rest/api/3/project/EJ` returning `{"projectTypeKey":"service_desk"}` + service desk meta (BC-3.9.017 step 0 calls `get_or_fetch_project_meta("EJ")` via string-prefix derivation `EJ-1`→`EJ` — NO plain issue GET is issued at this step per BC-3.9.017 step 0); (2) mount `GET /rest/api/3/issue/EJ-1?fields=attachment` returning `[{"id":"20001","filename":"file.txt","created":"2026-01-01T00:00:00.000+0000"}]` (1 same-filename match; this GET also validates existence — plain issue GET is suppressed per EC-3.9.003-5 P17-003 Step-0 suppression: exactly ONE issue GET per invocation on the combined `--replace-existing --public` path); (3) set `JR_STDIN_IS_TTY=1`, pipe `"y\n"` to stdin; (4) mount `DELETE /rest/api/3/attachment/20001` returning 204; (5) mount `POST /rest/servicedeskapi/servicedesk/{sdId}/attachTemporaryFile` and `POST /rest/servicedeskapi/request/EJ-1/attachment`. Assert: (a) EXACTLY ONE prompt written to stderr ... — no second prompt; (b) `--yes` variant ...; (c) cancel variant ...; (d) wiremock strict mode verifies ZERO plain `GET /rest/api/3/issue/EJ-1` requests without query parameters — the project key is derived from the string prefix at step 0 (no issue GET), and existence is validated by the `?fields=attachment` GET at step 1 (BC-3.9.017 step 0; EC-3.9.003-5 P17-003). Pins EC-3.9.017-11 (combined `--public` + ≥1 match → ONE prompt, not two), EC-3.9.017-12 (`--yes` single-bypass for all gate conditions), the invariant "cancel at gate → zero DELETE + zero POST", BC-3.9.017 step 0 (string-prefix project key derivation, no plain issue GET), and EC-3.9.003-5 P17-003 (ONE issue GET per invocation on combined `--replace-existing --public` path). P20-006; P21-002; cross-ref BC-3.9.017, EC-3.9.017-11/12.`

Plain GET /rest/api/3/issue/EJ-1 removed from mounts. Mounts renumbered: (1) project GET + service desk meta, (2) ?fields=attachment GET. Assert (d) added. P20-006 + P21-002 citations present. ✓

**Result**: APPLIED ✓.

---

## P21-003 — Group 19 Header Range ..012

**Quote-verified** (`holdout-scenarios.md` Group 19 header, line 2063):

> `## Group 19: Attachment CRUD — list / download / upload / delete (H-NEW-ATTACHMENT-001..012)`

Range bumped from "..010" (stale per r30 INFO-NEW-1 — H-011 already present but header not updated) to "..012." ✓

**CANONICAL-COUNTS.md Group 19 line** (line 128):

> `- Group 19 (Attachment Write, SOH-ATTACHMENTS-1 adversary pass-1 round B + P4-014 + P14-001 + P15-002 + P20-001 + P21-001, 2026-07-15/2026-07-16): H-NEW-ATTACHMENT-001..H-NEW-ATTACHMENT-012 ... — +12`

Enumeration matches header. ✓

**Result**: APPLIED ✓. INFO-NEW-1 from r30 (stale Group 19 range + reconciliation Note) is RESOLVED — both updated to reflect H-NEW-ATTACHMENT-012 and count 100.

---

## P21-004 — BC-3.9.004 Branch-(a) HTTP Sequence Expanded

**Quote-verified** (`bc-3-issue-write.md` BC-3.9.004 branch-(a), line 3345):

> `**(a) JSM branch** (`projectTypeKey == "service_desk"`): routes to the servicedeskapi two-step flow identical to BC-3.9.003 but with `"public": false` in the second-step body. HTTP sequence: step 0 issue GET → project-meta resolution per BC-X.8.010 (up to 2 cache-miss GETs: `GET /rest/api/3/project/{key}` + `GET /rest/servicedeskapi/servicedesk` pagination for `serviceDeskId`) → N × POST `.../attachTemporaryFile` → 1 × POST `.../request/{issueKey}/attachment`. [P21-004]`

"project-meta resolution per BC-X.8.010 (up to 2 cache-miss GETs: GET /rest/api/3/project/{key} + GET /rest/servicedeskapi/servicedesk pagination for serviceDeskId)" replaces the prior "project GET (cache-miss only)." P21-004 citation present. ✓

**Branch-(b) verified unchanged** (`bc-3-issue-write.md` line 3352):

> `**(b) Non-JSM branch — OQ-9 silent no-op** (`projectTypeKey != "service_desk"`): `jr` falls back silently to the platform POST path (BC-3.9.001). HTTP sequence: step 0 issue GET → project GET (cache-miss only) → platform POST `/rest/api/3/issue/{key}/attachments`; zero servicedeskapi calls issued.`

Branch-(b) sequence unchanged (no servicedesk pagination — correct for non-JSM). ✓

**BC-3.9.004 Trace** (line 3361):

> `P21-004 (branch (a) HTTP sequence: 'project GET (cache-miss only)' expanded to BC-X.8.010 full resolution — up to 2 cache-miss GETs: `GET /rest/api/3/project/{key}` + `GET /rest/servicedeskapi/servicedesk` pagination for `serviceDeskId`); P21-005 (EC-3.9.004-4: Step-0 suppression when entered from BC-3.9.017 step 4 on `--replace-existing --internal` path; symmetric with EC-3.9.003-5 P17-003)`

P21-004 citation present in Trace. ✓

**BC-INDEX BC-3.9.004 row** (line 376):

> `... **(a) JSM branch** (`projectTypeKey == "service_desk"`): servicedeskapi two-step public:false; no confirmation gate; HTTP: issue GET → **project-meta resolution per BC-X.8.010 (up to 2 cache-miss GETs: GET /rest/api/3/project/{key} + GET /rest/servicedeskapi/servicedesk pagination for serviceDeskId)** → N × attachTemporaryFile → request-attachment (P21-004). ...`

BC-INDEX row updated with P21-004. ✓

**Result**: APPLIED ✓.

---

## P21-005 — EC-3.9.004-4 Added + BC-3.9.017 Step 4 Cross-Ref

### EC-3.9.004-4 Added

**Quote-verified** (`bc-3-issue-write.md` EC-3.9.004-4, line 3359):

> `**EC-3.9.004-4** (Step-0 suppression when entered from BC-3.9.017 step 4, `--replace-existing --internal` path, P21-005): when BC-3.9.004 is invoked from BC-3.9.017 step 4, Step 0 (issue GET) is SKIPPED — existence was already validated by BC-3.9.017 step 1's `?fields=attachment` GET and the project key was already resolved at BC-3.9.017 step 0 (string-prefix derivation); exactly ONE issue GET per invocation on the combined `--replace-existing --internal` path. Only the servicedeskapi wire steps (or platform POST for non-JSM) execute. Symmetric with EC-3.9.003-5 P17-003 (same suppression for `--replace-existing --public` path).`

EC-3.9.004-4 present with P21-005 citation and symmetry note. ✓

### BC-3.9.017 Step 4 Cross-Ref

**Quote-verified** (`bc-3-issue-write.md` step 4, line 3753):

> `4. **Upload step**: proceed with upload per BC-3.9.001 (platform path) or BC-3.9.003/BC-3.9.004 (JSM path). The `--public` gate (if applicable) has already fired in step 2. **Gate suppression**: when routing to BC-3.9.003 on this step, the confirmation gate defined in BC-3.9.003 MUST NOT be re-presented — it was already resolved in step 2. Only the servicedeskapi wire steps execute (BC-3.9.003 EC-3.9.003-5). One gate per invocation, ever. **Step-0 suppression on `--internal` path (BC-3.9.004 EC-3.9.004-4, P21-005)**: when routing to BC-3.9.004 on this step, Step 0 (issue GET) of BC-3.9.004 is SKIPPED — existence was already validated by step 1's `?fields=attachment` GET; exactly ONE issue GET per invocation on the combined `--replace-existing --internal` path.`

BC-3.9.017 step 4 cross-ref to "BC-3.9.004 EC-3.9.004-4, P21-005" present. ✓

**BC-INDEX BC-3.9.004 row** (line 376):

> `... **EC-3.9.004-4 (P21-005)**: Step 0 SKIPPED when entered from BC-3.9.017 step 4 (`--replace-existing --internal`); existence validated by step 1 `?fields=attachment` GET; ONE issue GET per invocation ...`

BC-INDEX row updated with EC-3.9.004-4. ✓

**Result**: APPLIED ✓.

---

## P21-006 — BC-2.7.012 KEY-404 Annotation

**Quote-verified** (`bc-2-issue-read.md` BC-2.7.012 error taxonomy table, line 936):

> `| KEY 404 (batch paths only — `--id` does not server-verify KEY per BC-2.7.007) | 64 | `"Issue <KEY> not found or not accessible."` |`

Annotation "(batch paths only — `--id` does not server-verify KEY per BC-2.7.007)" present. ✓

**BC-INDEX BC-2.7.012 row** (line 231):

> `| BC-2.7.012 | Unknown KEY or AID → exit 64; **KEY-404 fires on batch paths only** (`--all`/`--newest`; `--id` does NOT server-verify KEY per BC-2.7.007 — P21-006); ...  | — (SOH-ATTACHMENTS-1 F2; P7-001; P13-001; P18-002; P21-006) |`

BC-INDEX row updated with batch-paths-only annotation and P21-006 citation. ✓

**Note — BC-2.7.012 Trace not updated with P21-006 citation**: The Trace for BC-2.7.012 in bc-2-issue-read.md (line 946) still reads "F2 spec evolution (SOH-ATTACHMENTS-1 2026-07-15; DEC-179 ratified design; research §6 JRACLOUD-96384/-78388 VERIFIED)" — no P21-006 citation added. The BC-INDEX row correctly cites P21-006; the bc-2 body Trace does not. Non-blocking (see INFO-NEW-2). Also, bc-2 frontmatter trace has no P21 (or P20) entries — see INFO-NEW-3.

**Result**: APPLIED ✓ (with INFO-NEW-2 noting Trace gap).

---

## BC-INDEX v6.20→v6.21

**Quote-verified** (`BC-INDEX.md` frontmatter, lines 5–6):

```yaml
last_updated: 2026-07-16  # P21 adversary fix round: BC-3.9.010 row bulk-404 benign-skip clarified (P21-001); BC-3.9.004 row servicedesk pagination added (P21-004); BC-2.7.012 row KEY-404 annotated batch-paths-only (P21-006); spec v1.3.61; BC count unchanged (657); holdout count 99→100; VP count 35 (unchanged); BC-INDEX v6.21. Previous: P20 adversary fix round: ...
index_version: v6.21
```

`last_updated` updated to P21 note with all three row changes; `index_version` v6.20→v6.21. ✓

**Three rows updated:**
- BC-3.9.010 row (line 382): "bulk 404 = benign-skip per EC-3.9.010-4/BC-3.9.013 (P21-001: 404'd AID excluded from count/ids; iteration continues; NOT exit 64); first NON-404 failure → error JSON; single-vs-bulk 404 divergence: single-AID 404 exits 64 (BC-3.9.008); bulk 404 benign-skip (BC-3.9.013) — intentionally asymmetric" ✓
- BC-3.9.004 row (line 376): branch-(a) expanded to BC-X.8.010 servicedesk pagination (P21-004); EC-3.9.004-4 Step-0 suppression (P21-005) ✓
- BC-2.7.012 row (line 231): KEY-404 batch-paths-only annotation + P21-006 citation ✓

**Result**: BC-INDEX APPLIED ✓.

---

## spec-changelog [1.3.61]

**Quote-verified** (`spec-changelog.md`, entry at line 10):

```
## [1.3.61] - 2026-07-16

### Type: PATCH
```

Entry present; dated 2026-07-16. ✓

**Summary** (line 16): "Adversary pass 21 (P21) fix round — HIGH: BC-3.9.010 bulk-delete body ... P21-001; MEDIUM: VP-576-005 fixture ... P21-002; LOW: holdout-scenarios.md Group 19 header range bumped to ..012 (P21-003); BC-3.9.004 branch-(a) HTTP sequence expanded ... (P21-004); EC-3.9.004-4 added ... (P21-005); INFO: BC-2.7.012 KEY-404 row annotated ... (P21-006)."

All 6 P21 items described in Summary. ✓

**Changed Requirements** (lines 20–25): lists all 5 modified files with P21 item descriptions. ✓

**Impact Assessment table** (lines 29–35): artifact-level table present with 5 rows (bc-3, bc-2, holdout-scenarios, CANONICAL-COUNTS, BC-INDEX). ✓

**NOTE (INFO-NEW-2)**: [1.3.61] Impact Assessment does NOT include explicit BC count / holdout count / VP count / Spec version rows. [1.3.60] established this pattern (see r30 INFO-14 resolution: "pattern corrected going forward"); [1.3.61] reverts to the artifact-only table format. Non-blocking — counts are inferable from the artifact rows and from prd-delta-576.md P21 closing — but the pattern established at [1.3.60] is not continued.

**Result**: APPLIED ✓ (with INFO-NEW-2 noting missing explicit count rows).

---

## prd-delta-576.md Frontmatter + P21 Section

**Quote-verified** (`prd-delta-576.md` frontmatter, lines 8 and 12):

```yaml
spec_version_after: 1.3.61
holdout_count_after: 100
```

`spec_version_after` updated to 1.3.61. `holdout_count_after` updated to 100. ✓

**Quote-verified** (`prd-delta-576.md` P21 section heading, line 394):

> `## Adversary Pass 21 Fix Round Finding Dispositions`

P21 dispositions section present (one heading — no duplicate). ✓

**P21 closing statement** (`prd-delta-576.md`, line 407):

> `**BC count at this round: 657 (unchanged). Holdout count: 100 (+1 H-NEW-ATTACHMENT-012). VP count: 35 (unchanged). Spec version: 1.3.61. Both guards exit 0.**`

Closing statement correct: BC 657 / holdout 100 / VP 35 / spec v1.3.61. ✓

All 6 P21 items have APPLIED disposition rows (P21-001..P21-006). ✓

**Result**: APPLIED ✓.

---

## Double-Insertion Sweep (Hook-Timeout Risk)

| Marker | Count | Lines | Assessment |
|--------|-------|-------|------------|
| `v1.3.61` in `bc-3-issue-write.md` | 2 | 95 (frontmatter trace), 3896 (footer) | EXPECTED — two distinct locations; no duplicate |
| `EC-3.9.004-4` in `bc-3-issue-write.md` | 5 | 95 (frontmatter trace), 3359 (definition body), 3361 (Trace), 3753 (BC-3.9.017 step 4 cross-ref), 3896 (footer) | EXPECTED — all 5 are distinct legitimate locations |
| `### H-NEW-ATTACHMENT-012` heading | 1 | 2528 | No duplicate heading |
| `H-NEW-ATTACHMENT-012` in `holdout-scenarios.md` | 2 | 22 (preamble trace), 2528 (heading) | EXPECTED — one reference + one heading |
| `[1.3.61]` in `spec-changelog.md` | 1 | 10 | No duplicate |
| P21 dispositions section (`## Adversary Pass 21 Fix Round Finding Dispositions`) | 1 | 394 | No duplicate section heading |

**No double-insertions detected.** All marker counts are explainable by distinct legitimate locations. EC-3.9.004-4 appears 5 times (frontmatter trace + body definition + Trace + step 4 cross-ref + footer) — all five are different roles, not duplicates. ✓

---

## Bulk-404-Exit-64 Residue Scan

**Target**: any surviving "404 → exit 64" text in a BULK-delete context (single-AID BC-3.9.008 context is correct and must remain).

**Scan result**: All "404 → exit 64" / "exit 64" + "404" occurrences in bc-3-issue-write.md analyzed:
- BC-3.5.004 comment delete 404 → exit 64 — single comment delete, not bulk attachment. ✓ (correct)
- BC-3.9.003 Step 0 "404 → exit 64 per EC-3.9.012-2" — issue existence check, not bulk delete. ✓ (correct)
- BC-3.9.004 Step 0 same — issue existence check. ✓ (correct)
- BC-3.9.008 "HTTP 404 (attachment not found): exit 64" — single-AID targeted delete per DEC-168. ✓ (must remain)
- EC-3.9.012-2 "issue key 404: exit 64" — upload error on issue not found. ✓ (correct)
- BC-3.9.013 title "AID 404 exit 64 + surface body" — single-AID context (EC-3.9.013-1); the multi-delete 404 exception is documented separately. ✓ (correct)
- EC-3.9.013-1 "AID 404: exit 64" — single-AID targeted delete. ✓ (correct; multi-delete exception in table note above)
- BC-3.9.015 pre-prompt metadata-GET "404: exit 64" — pre-gate metadata fetch (read GET), not delete execution. ✓ (correct)

**BC-3.9.010 bulk enumeration**: zero "exit 64" references — correctly replaced with "benign-skip; iteration continues." ✓

**No residual "404 → exit 64" in any bulk context found.** Clean. ✓

---

## Echo-Breaker Audit — List A (5 of 9 sentences) + ALL of List B

### List A Audit

#### Sentence 1: BC-3.9.010 "404 is NOT a failure on the bulk path" (bc-3 line 3494)

**New text**: `"404 is NOT a failure on the bulk path: a 404 response to any individual DELETE is treated as already-deleted (benign race) per EC-3.9.010-4 and BC-3.9.013 multi-delete 404 exception; the 404'd AID is excluded from count and ids, and iteration continues."`

**Licensing basis**: BC-3.9.013 multi-delete 404 exception (line 3587) states: "on multi-attachment delete paths, a 404 response to an individual DELETE is treated as already-deleted (benign race condition) and is silently skipped; iteration continues." EC-3.9.010-4 formalizes this for the JSON-output context. The sentence is a behavioral restatement of the pre-existing BC-3.9.013 exception.

**Assessment**: Licensed by BC-3.9.013 multi-delete exception + EC-3.9.010-4. No over-claim. ✓

#### Sentence 2: BC-3.9.010 "The first NON-404 failure stops the batch" (bc-3 line 3494)

**New text**: `"The first NON-404 failure (403, 401, 5xx, network) stops the batch immediately and surfaces the error."`

**Licensing basis**: BC-3.9.013 multi-delete exception tail: "Non-404 errors (403, 5xx, network) on any delete attempt abort the sequence and surface the error." The "401" addition is consistent with the error taxonomy (401 = not-authenticated, exit 2) and is not excluded from the "non-404 errors abort" rule.

**Assessment**: Licensed by BC-3.9.013 non-404-abort rule. "401" consistent with taxonomy. No over-claim. ✓

#### Sentence 3: BC-3.9.010 "intentionally asymmetric MUST NOT be unified" (bc-3 line 3494)

**New text**: `"404 on a single-AID targeted delete exits 64 per BC-3.9.008 (DEC-168: targeted delete of a specific ID is a user error); 404 on any AID in a multi-AID bulk delete is a benign skip per BC-3.9.013 — these behaviors are intentionally asymmetric and MUST NOT be unified."`

**Licensing basis**: BC-3.9.008 (single-AID delete 404 = exit 64, DEC-168 precedent); BC-3.9.013 multi-delete exception (bulk 404 = benign-skip). The "intentionally asymmetric MUST NOT be unified" phrasing is a design constraint that makes the split explicit and prevents future unification that would be a behavioral regression.

**Assessment**: Licensed by BC-3.9.008 (DEC-168) + BC-3.9.013 (multi-delete exception). No over-claim. ✓

#### Sentence 4 (SPECIAL SCRUTINY): BC-3.9.004 branch-(a) "up to 2 cache-miss GETs" (bc-3 line 3345)

**New text**: `"HTTP sequence: step 0 issue GET → project-meta resolution per BC-X.8.010 (up to 2 cache-miss GETs: GET /rest/api/3/project/{key} + GET /rest/servicedeskapi/servicedesk pagination for serviceDeskId) → N × POST .../attachTemporaryFile → 1 × POST .../request/{issueKey}/attachment."`

**Licensing basis** (each element traced):
- **Step 0 issue GET**: BC-3.9.004 Step 0 (line 3343): "`GET /rest/api/3/issue/{key}` (existence validation)" ✓
- **GET /rest/api/3/project/{key}**: BC-X.8.010 (from BC-INDEX row and BC-3.9.003 Trace "BC-X.8.010 serviceDeskId cache"): the first cache-miss GET for projectTypeKey ✓
- **GET /rest/servicedeskapi/servicedesk pagination for serviceDeskId**: BC-X.8.010 "serviceDeskId cache" — on cache miss, the serviceDeskId is resolved via servicedesk pagination call; BC-3.8.002 "handle_jsm_create calls require_service_desk(client, project_key) to resolve the numeric serviceDeskId string" (same pattern) ✓
- **"up to 2 cache-miss GETs"**: "up to" correctly qualifies that both calls only fire on cache miss; a cache hit requires zero HTTP calls for project-meta resolution ✓
- **N × POST .../attachTemporaryFile**: BC-3.9.003 Step 1 "For each FILE, POST .../attachTemporaryFile" ✓
- **1 × POST .../request/{issueKey}/attachment**: BC-3.9.004 Step 2 (line 3348) ✓

**Assessment**: All five HTTP sequence elements are grounded in pre-existing BC-3.9.003/BC-3.9.004/BC-X.8.010 text. No behavioral over-claim. ✓

#### Sentence 5: EC-3.9.004-4 "exactly ONE issue GET per invocation" (bc-3 line 3359)

**New text**: `"exactly ONE issue GET per invocation on the combined `--replace-existing --internal` path"`

**Licensing basis**: EC-3.9.003-5 P17-003 (symmetric contract for `--replace-existing --public` path): "exactly ONE issue GET per invocation on the combined `--replace-existing --public` path." BC-3.9.017 step 1's `?fields=attachment` GET provides the issue GET. BC-3.9.004 Step 0 (issue GET) is suppressed when entered via BC-3.9.017 step 4 because step 1 already ran it. The ONE-issue-GET invariant is a design symmetry with EC-3.9.003-5 P17-003.

**Assessment**: Licensed by EC-3.9.003-5 P17-003 (symmetric design) + BC-3.9.017 step 1. No over-claim. ✓

---

### List B Audit — ALL Fixture Mounts/Call-Counts

#### H-NEW-ATTACHMENT-012 Fixture Audit

**Wire contract basis**: EC-3.9.010-4 (3-AID bulk delete, middle 404 → benign-skip; iteration continues; count=2; ids=["40001","40003"]; exit 0); BC-3.9.013 multi-delete 404 exception.

| Fixture element | H-012 claim | Wire contract basis | Assessment |
|-----------------|-------------|---------------------|------------|
| DELETE /rest/api/3/attachment/40001 → 204 | mount (2) | BC-3.9.010: AID 40001 → success | ✓ licensed |
| DELETE /rest/api/3/attachment/40002 → 404 | mount (3) | EC-3.9.010-4: 404 = benign skip | ✓ licensed |
| DELETE /rest/api/3/attachment/40003 → 204 | mount (4) | BC-3.9.010: iteration continues past 404; AID 40003 → success | ✓ licensed |
| Wiremock strict mode | setup (5) | No other HTTP calls mandated for multi-AID bulk delete (no issue GET; AID validation is client-side per BC-3.9.013) | ✓ correctly restricts |
| Exit code = 0 | expected | EC-3.9.010-4: 404 is benign, not an error; NOT exit 64 | ✓ licensed |
| JSON stdout `{"count":2,"deleted":true,"ids":["40001","40003"]}` | expected | EC-3.9.010-4: 404'd AID excluded from count/ids; count=2; deleted:true because count>0 per BC-3.9.010 Zero-count semantics | ✓ licensed |
| Wiremock asserts exactly 3 DELETE calls | expected | EC-3.9.010-4: iteration did NOT stop at the 404; 40003 still attempted | ✓ licensed |
| No error to stderr | expected | EC-3.9.010-4: 404 silently skipped; no user-facing error for benign race | ✓ licensed |
| `--yes` flag on command | action | Multi-AID bulk delete invokes confirmation gate per BC-3.9.016; --yes bypasses | ✓ consistent |

**No call the wire contract forbids is added.** No call the contract mandates is omitted. The fixture design (404 in the MIDDLE position — not at start or end) is load-bearing: it proves iteration continued past the 404 to issue the third DELETE (40003). ✓

**H-012 fixture audit**: CLEAN ✓

#### VP-576-005 Fixture Audit (Post-P21-002)

**Wire contract basis**: BC-3.9.017 steps 0-4 + EC-3.9.003-5 P17-003 (Step-0 suppression, ONE issue GET) + BC-X.8.010 (up-to-2-cache-miss-GETs for project + servicedesk) + EC-3.9.017-11 (combined gate ONE prompt) + EC-3.9.017-12 (--yes bypass).

| Fixture element | VP-576-005 claim | Wire contract basis | Assessment |
|-----------------|------------------|---------------------|------------|
| (1) project GET /rest/api/3/project/EJ + service desk meta | mount (1) | BC-3.9.017 step 0: get_or_fetch_project_meta("EJ") via string-prefix derivation EJ-1→EJ; BC-X.8.010: up to 2 cache-miss GETs | ✓ licensed |
| NO plain issue GET at step 0 | note in mount (1) | BC-3.9.017 step 0: project key derived from string prefix — NO issue GET | ✓ licensed by BC-3.9.017 step 0 |
| (2) GET /rest/api/3/issue/EJ-1?fields=attachment → [1 same-filename match] | mount (2) | BC-3.9.017 step 1: ?fields=attachment GET for existence validation + attachment list | ✓ licensed |
| ONE issue GET per invocation = the ?fields=attachment GET | note in mount (2) | EC-3.9.003-5 P17-003: Step-0 suppression on combined --replace-existing --public path; existence validated by step 1 | ✓ licensed |
| (3) JR_STDIN_IS_TTY=1 + pipe "y\n" | setup (3) | BC-3.9.017 step 2: combined gate (--public + ≥1 match → ONE prompt); gate mechanics per BC-3.9.014 eprint!+read_line; user confirms | ✓ licensed |
| (4) DELETE /rest/api/3/attachment/20001 → 204 | mount (4) | BC-3.9.017 step 3: delete matching attachment | ✓ licensed |
| (5) POST attachTemporaryFile + POST request/EJ-1/attachment | mount (5) | BC-3.9.017 step 4 → BC-3.9.003 EC-3.9.003-5 (gate suppressed; servicedeskapi wire steps execute) | ✓ licensed |
| Assert (a): EXACTLY ONE prompt | assert | EC-3.9.017-11: combined --public + ≥1 match → ONE combined prompt, not two | ✓ licensed |
| Assert (b): --yes → ZERO prompts, same DELETE+upload | assert | EC-3.9.017-12: --yes bypasses all gate conditions | ✓ licensed |
| Assert (c): cancel → ZERO DELETE + ZERO servicedeskapi POST | assert | EC-3.9.017-8/11: cancel at gate → no destructive calls | ✓ licensed |
| Assert (d): ZERO plain GET /rest/api/3/issue/EJ-1 | assert | EC-3.9.003-5 P17-003: ONE issue GET per invocation (the ?fields=attachment GET); plain issue GET suppressed; BC-3.9.017 step 0: NO issue GET at step 0 | ✓ licensed |

**Cache-miss assumptions for mount (1)**: The VP assumes a cache miss for project meta (both project GET and servicedesk GET fire). In test context with per-test TempDir (JR_CACHE_DIR isolation), cache is always cold → cache-miss assumption is valid. No unspecified calls added.

**No call the wire contract forbids is added.** No call the contract mandates is omitted (mount (1) covers both project GET and servicedesk pagination — the two BC-X.8.010 cache-miss GETs). Assert (d) strict-mode enforces the absence of the previously incorrect plain issue GET mount. ✓

**VP-576-005 fixture audit**: CLEAN ✓

---

## Keystone Coherence Checks

### K-1: BC-3.9.010 body ↔ EC-3.9.010-4 ↔ BC-3.9.013 ↔ error-taxonomy delete rows ↔ H-012

| Element | Claim | Source |
|---------|-------|--------|
| BC-3.9.010 body | 404 = benign-skip per EC-3.9.010-4/BC-3.9.013; 404'd AID excluded from count/ids; iteration continues | bc-3 line 3494 |
| EC-3.9.010-4 | multi-AID bulk 404 = already-deleted (benign race); 404'd AID EXCLUDED; iteration continues; first NON-404 failure stops | bc-3 line 3503 |
| BC-3.9.013 multi-delete exception | multi-path 404 = already-deleted (benign race); silently skipped; iteration continues; exit 64 only for single-AID | bc-3 line 3587 |
| BC-3.9.013 EC-3.9.013-1 | single-AID targeted delete 404: exit 64 | bc-3 line 3589 (single-AID only) |
| H-012 | 3-AID delete, middle 404 → exit 0; count=2; ids=[40001,40003]; 3 DELETE calls asserted | holdout-scenarios.md lines 2544-2547 |

All elements tell a coherent single story: bulk 404 = benign skip; single-AID 404 = exit 64; the asymmetry is intentional and explicit. H-012 enforces it with a concrete three-call fixture. ✓

**K-1 COHERENT ✓**

---

### K-2: VP-576-005 mounts ↔ BC-3.9.017 steps 0-4 ↔ EC-3.9.003-5 one-issue-GET ↔ BC-X.8.010

| Element | Claim | Source |
|---------|-------|--------|
| BC-3.9.017 step 0 | project key from string prefix (EJ-1→EJ); NO issue GET; get_or_fetch_project_meta("EJ") | bc-3 line ~3729 |
| BC-X.8.010 | get_or_fetch_project_meta: cache-backed; up to 2 GETs on miss (project GET + servicedesk pagination) | BC-INDEX row |
| VP-576-005 mount (1) | project GET + service desk meta — covers both GETs; no plain issue GET at this step | bc-3 line 3784 |
| BC-3.9.017 step 1 | GET ?fields=attachment — existence validation + attachment list | bc-3 line ~3731 |
| VP-576-005 mount (2) | GET /rest/api/3/issue/EJ-1?fields=attachment → 1 same-filename match | bc-3 line 3784 |
| EC-3.9.003-5 P17-003 | ONE issue GET per invocation on --replace-existing --public path; Step 0 SKIPPED when entered via BC-3.9.017 step 4 | bc-3 line ~3329 |
| VP-576-005 assert (d) | ZERO plain GET /rest/api/3/issue/EJ-1 | bc-3 line 3784 |
| BC-3.9.017 steps 3-4 | DELETE + upload via BC-3.9.003 EC-3.9.003-5 (gate suppressed) | bc-3 lines 3752-3753 |
| VP-576-005 mounts (4)-(5) | DELETE + POST pair | bc-3 line 3784 |

All five VP-576-005 mount steps directly map to BC-3.9.017 steps 0-4. Assert (d) enforces EC-3.9.003-5 P17-003 ONE-issue-GET invariant. BC-X.8.010 up-to-2-GETs covered by mount (1). ✓

**K-2 COHERENT ✓**

---

### K-3: EC-3.9.004-4 ↔ EC-3.9.003-5 symmetry ↔ BC-3.9.017 step-4 dual routing

| Element | Claim | Source |
|---------|-------|--------|
| EC-3.9.003-5 P17-003 | Step 0 SKIPPED on --replace-existing --public path; ONE issue GET per invocation | bc-3 line ~3329 |
| EC-3.9.004-4 P21-005 | Step 0 SKIPPED on --replace-existing --internal path; ONE issue GET per invocation; SYMMETRIC with EC-3.9.003-5 P17-003 | bc-3 line 3359 |
| BC-3.9.017 step 4 | --public → BC-3.9.003 (EC-3.9.003-5 gate suppression); --internal → BC-3.9.004 (EC-3.9.004-4 Step-0 suppression) | bc-3 line 3753 |

Dual routing at BC-3.9.017 step 4: both branches suppress their respective Step 0 for the identical reason (existence already validated by step 1). Symmetry between EC-3.9.004-4 (--internal) and EC-3.9.003-5 (--public) is explicitly declared and verified. ✓

**K-3 COHERENT ✓**

---

### K-4: BC-3.9.004 branch-(a) call counts ↔ BC-3.9.003 step 1 ↔ BC-X.8.010 (identical resolution story for both JSM branches)

| Element | Claim | Source |
|---------|-------|--------|
| BC-3.9.004 branch-(a) HTTP sequence (P21-004) | issue GET → BC-X.8.010 resolution (up to 2 GETs) → N × attachTemporaryFile → 1 × request-attachment | bc-3 line 3345 |
| BC-3.9.003 HTTP sequence | issue GET → BC-X.8.010 resolution → N × attachTemporaryFile → 1 × request-attachment | bc-3 line ~3308 (Trace: "BC-X.8.010 serviceDeskId cache") |
| BC-X.8.010 | get_or_fetch_project_meta: project GET (projectTypeKey) + servicedesk GET (serviceDeskId) on cache miss | BC-INDEX |
| BC-3.9.004 branch-(b) | no servicedesk pagination; project GET (cache-miss only) → platform POST | bc-3 line 3352 (correctly unchanged) |

Branch-(a) (JSM) and BC-3.9.003 (JSM --public) both use BC-X.8.010 full resolution. Branch-(b) (non-JSM) correctly omits servicedesk pagination. The asymmetry between (a) JSM and (b) non-JSM within BC-3.9.004 is consistent and correct. ✓

**K-4 COHERENT ✓**

---

### K-5: Group 19 header ..012 ↔ body scenario set ↔ CANONICAL-COUNTS enumeration

| Element | Claim | Source |
|---------|-------|--------|
| holdout-scenarios.md Group 19 header | (H-NEW-ATTACHMENT-001..012) | line 2063 |
| holdout-scenarios.md scenarios | H-NEW-ATTACHMENT-001 through H-NEW-ATTACHMENT-012 all present (011 at line 2498; 012 at line 2528) | lines 2498, 2528 |
| CANONICAL-COUNTS.md canonical total | 100 | line 111 |
| CANONICAL-COUNTS.md enumeration | H-NEW-ATTACHMENT-001..H-NEW-ATTACHMENT-012 | line 118 |
| CANONICAL-COUNTS.md Group 19 line | H-NEW-ATTACHMENT-001..H-NEW-ATTACHMENT-012 — +12 (P21-001 adds H-012 note) | line 128 |

Group 19 header, body scenarios, and CANONICAL-COUNTS enumeration all agree on range ..012 with +12 count. ✓

**K-5 COHERENT ✓**

---

## Cross-Reference Validation

### BC Counts

| Source | bc-2 definitional | bc-2 total_bcs | bc-3 definitional | bc-3 total_bcs | Grand Total |
|--------|-------------------|-----------------|-------------------|-----------------|-------------|
| Frontmatter | 64 | 106 | 111 | 140 | 657 |
| CANONICAL-COUNTS.md | 64 | 106 | 111 | 140 | 657 |
| Guard output | verified | — | verified | — | 657 |

P21 added 0 new BCs. PASS ✓

### Holdout Counts

| Source | Count | Status |
|--------|-------|--------|
| `holdout-scenarios.md` frontmatter `total_holdouts` | 100 | PASS ✓ |
| `holdout-scenarios.md` body preamble line 28 | "100 holdout scenarios" | PASS ✓ |
| `CANONICAL-COUNTS.md` canonical total | 100 | PASS ✓ |
| `CANONICAL-COUNTS.md` enumeration | H-NEW-ATTACHMENT-001..H-NEW-ATTACHMENT-012 | PASS ✓ |
| `prd-delta-576.md` frontmatter `holdout_count_after` | 100 | PASS ✓ |
| `prd-delta-576.md` P21 closing | "Holdout count: 100 (+1 H-NEW-ATTACHMENT-012)" | PASS ✓ |
| `spec-changelog.md` [1.3.61] artifact table | "CANONICAL-COUNTS.md: Holdout total 99→100" | PASS ✓ |

### VP Counts

| Source | VP count reference | Status |
|--------|-------------------|--------|
| `prd-delta-576.md` P21 closing | "VP count: 35 (unchanged)" | PASS ✓ |
| `bc-3-issue-write.md` footer | "VP count 35 (unchanged)" | PASS ✓ |
| `BC-INDEX.md` last_updated | "VP count 35 (unchanged)" | PASS ✓ |
| `spec-changelog.md` [1.3.61] | VP count not as explicit row (see INFO-NEW-2) | INFO |

---

## Spec Version Surface Verification

| Artifact | Spec version shown | Status |
|----------|--------------------|--------|
| `spec-changelog.md` | `[1.3.61] - 2026-07-16` entry present | PASS ✓ |
| `bc-3-issue-write.md` frontmatter trace | v1.3.61 entry at line 95 | PASS ✓ |
| `bc-3-issue-write.md` footer | "spec v1.3.61" | PASS ✓ |
| `BC-INDEX.md` `last_updated` | "spec v1.3.61" in P21 note | PASS ✓ |
| `prd-delta-576.md` frontmatter `spec_version_after` | `1.3.61` | PASS ✓ |
| `bc-2-issue-read.md` frontmatter trace | no v1.3.61 / v1.3.60 entry (see INFO-NEW-3) | INFO |
| `STATE.md` `current_step` | stale at v1.3.56 (carries INFO-8) | STALE (INFO-8 carries forward) |

---

## INFO Ledger Status

### INFO-1 (carry-forward R21–R31) — CARRY-FORWARD

Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7 in bc-2. Not introduced or worsened by P21. Non-blocking.

**Status**: CARRY-FORWARD

---

### INFO-2 (carry-forward R21–R31) — CARRY-FORWARD

EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained. Not introduced or worsened by P21. Non-blocking.

**Status**: CARRY-FORWARD

---

### INFO-3 (carry-forward R21–R31) — CARRY-FORWARD

BC-2.7.012 "KEY or AID 5xx" combined-scope row. Not introduced or worsened by P21. Non-blocking.

**Status**: CARRY-FORWARD

---

### INFO-4 (carry-forward R22–R31) — CARRY-FORWARD

H-NEW-ATTACHMENT-003 BC refs footer does not list `BC-2.7.008 EC-2.7.008-6` for Call B2. Not introduced or worsened by P21. Non-blocking.

**Status**: CARRY-FORWARD

---

### INFO-6 (carry-forward R23–R31) — CARRY-FORWARD

No holdout for the collision-skip exit-0 path. Not introduced or worsened by P21. Non-blocking.

**Status**: CARRY-FORWARD

---

### INFO-8 (carry-forward R25–R31)

`STATE.md` spec version stale at v1.3.56 (should be v1.3.61 after P21). BC 657 / holdouts 100 / VP 35 correct in STATE.md. Non-blocking.

**Status**: CARRY-FORWARD (spec version stale; should be v1.3.61 after P21)

---

### INFO-11 (carry-forward R27–R31) — CARRY-FORWARD

`spec-changelog.md` [1.3.57] and `prd-delta-576.md` P17-002 disposition say "three sites" but four sites in `impact-boundary-576.md` were actually modified. Not introduced or worsened by P21.

**Status**: CARRY-FORWARD

---

### INFO-12 (carry-forward R27–R31) — CARRY-FORWARD

`bc-3-issue-write.md` BC-3.9.003 Trace not updated for P17-003. P17-003 citation IS present in EC-3.9.003-5 body text. Not introduced or worsened by P21.

**Status**: CARRY-FORWARD

---

### INFO-13 (carry-forward R28–R31) — CARRY-FORWARD

`error-taxonomy.md` row 95 issue-GET 403 sub-variant lacks BC-2.7.006 citation. Not introduced or worsened by P21.

**Status**: CARRY-FORWARD

---

### INFO-14 (carry-forward R29–R31, RE-OPENED)

`spec-changelog.md` explicit count rows pattern: [1.3.60] established the pattern of including explicit BC count / Holdout count / VP count / Spec version rows in the Impact Assessment. [1.3.61] does NOT follow this pattern — only has the artifact-level table. [1.3.59] was historically incomplete; [1.3.60] was described as "pattern corrected going forward"; [1.3.61] reverts to the artifact-only format.

**Status**: RE-OPENED for [1.3.61] (non-blocking; counts inferable from prd-delta P21 closing; [1.3.60] correct historically)

---

### INFO-15 (carry-forward R29–R31) — CARRY-FORWARD

`impact-boundary-576.md` BC-3.9.004 row has INCONCLUSIVE annotation. BC-3.9.004 is now fully defined (P20-001 + P21-004). The impact-boundary row was not updated to reflect the fully-defined state. Non-blocking (INCONCLUSIVE annotation is conservative and correct given the row predates P20/P21 definitions).

**Status**: CARRY-FORWARD

---

### INFO-NEW-1 (was NEW R30) — RESOLVED

`CANONICAL-COUNTS.md` Group 19 range and reconciliation Note stale. **NOW RESOLVED** by P21-003 (Group 19 header bumped to ..012) and P21-001 (holdout count 99→100, reconciliation Note updated to reference 100 and P21-001).

**Status**: RESOLVED ✓

---

### INFO-NEW-2 (NEW R31)

`spec-changelog.md` [1.3.61] Impact Assessment table lacks explicit BC count (657 unchanged), VP count (35 unchanged), and Spec version (1.3.60→1.3.61) rows. Only the holdout count change is inferable from the CANONICAL-COUNTS.md artifact row. The pattern established at [1.3.60] (per INFO-14's resolution) is not continued in [1.3.61].

Additionally: BC-2.7.012 Trace in bc-2-issue-read.md body (line 946) does not cite P21-006. The BC-INDEX row for BC-2.7.012 correctly cites P21-006; only the body Trace is missing the citation.

**Severity**: INFO. Non-blocking — counts are verifiable from prd-delta-576.md P21 closing ("BC count at this round: 657 (unchanged). Holdout count: 100 (+1 H-NEW-ATTACHMENT-012). VP count: 35 (unchanged). Spec version: 1.3.61. Both guards exit 0.") and from the guard outputs.

---

### INFO-NEW-3 (NEW R31)

`bc-2-issue-read.md` frontmatter trace (lines 8–14) last entry is "SOH-ATTACHMENTS-1 adversary pass-19 (2026-07-16)... spec v1.3.59." Neither P20 nor P21 pass entries are present in the bc-2 frontmatter trace, even though P20-003 (BC-2.7.007 --out clause), P20-006 (VP-576-004), and P21-006 (BC-2.7.012 annotation) all modified bc-2-issue-read.md.

**Severity**: INFO. The bc-3 frontmatter trace is updated per-pass (entries for v1.3.43 through v1.3.61); bc-2 frontmatter trace stopped at v1.3.59. The content changes themselves are present and correct; only the frontmatter trace is incomplete. Non-blocking.

---

## Findings

### Critical

None.

### Major

None.

### GAPs

None.

### Resolved

**INFO-NEW-1 (was NEW R30)**: CANONICAL-COUNTS.md Group 19 range "..010" and reconciliation Note referencing 98/P15 — now updated to "..012" (+12) and Note references 100/P21-001. RESOLVED.

### Minor (INFO)

- **INFO-1** (carry-forward R21–R31): Triple blank lines between EC-2.7.008-6 and EC-2.7.008-7.
- **INFO-2** (carry-forward R21–R31): EC-2.7.008-5 supersedes EC-2.7.008-2 but both retained.
- **INFO-3** (carry-forward R21–R31): BC-2.7.012 "KEY or AID 5xx" combined-scope row.
- **INFO-4** (carry-forward R22–R31): H-NEW-ATTACHMENT-003 BC refs footer missing EC-2.7.008-6 for Call B2.
- **INFO-6** (carry-forward R23–R31): No holdout for collision-skip exit-0 path.
- **INFO-8** (carry-forward R25–R31): STATE.md spec version stale (should be v1.3.61).
- **INFO-11** (carry-forward R27–R31): P17-002 "three sites" undercount in spec-changelog/prd-delta.
- **INFO-12** (carry-forward R27–R31): BC-3.9.003 Trace not updated for P17-003; citation in EC body.
- **INFO-13** (carry-forward R28–R31): error-taxonomy row 95 issue-GET 403 lacks BC-2.7.006 citation.
- **INFO-14** (carry-forward R29–R31, RE-OPENED): [1.3.61] lacks explicit count rows in Impact Assessment; [1.3.60] correct.
- **INFO-15** (carry-forward R29–R31): impact-boundary BC-3.9.004 INCONCLUSIVE annotation; BC-3.9.004 now fully defined.
- **INFO-NEW-2** (NEW R31): spec-changelog [1.3.61] missing explicit BC/VP/spec-version count rows; BC-2.7.012 Trace in bc-2 body missing P21-006 citation.
- **INFO-NEW-3** (NEW R31): bc-2-issue-read.md frontmatter trace not updated for P20/P21 passes (last entry: P19, spec v1.3.59).

---

## Validation Gate Result

**CONSISTENT**

All 6 P21 fix-round items (P21-001..P21-006) correctly applied. No behavioral GAPs. Echo-breaker audit of 5 List-A sentences and ALL List-B fixture mounts found no over-claims, including special scrutiny of the BC-3.9.004 branch-(a) "up to 2 cache-miss GETs" claim (traced to BC-X.8.010 servicedesk resolution) and the VP-576-005 fixture (all mounts match BC-3.9.017 steps 0-4 + EC-3.9.003-5 + BC-X.8.010). Double-insertion sweep found no duplicates. Bulk-404-exit-64 residue scan clean — no surviving "404 → exit 64" in any bulk context. Keystones K-1 through K-5 coherent. Spec version 1.3.61 consistent across all spec surfaces. BC count 657 / holdout count 100 / VP count 35 confirmed by both guards (exit 0). INFO-NEW-1 from r30 RESOLVED (CANONICAL-COUNTS.md Group 19 range and reconciliation Note now correct at 100). Two new INFO items (INFO-NEW-2: spec-changelog [1.3.61] missing explicit count rows + BC-2.7.012 Trace gap; INFO-NEW-3: bc-2 frontmatter trace not updated for P20/P21).

---

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 38 |
| **Passed** | 37 |
| **Resolved** | 7 (INFO-5 P14; INFO-7 P16 micro-fix; INFO-9 R26; INFO-10 P16+P17; GAP-P19-FWD-001 R30; INFO-14 partially R30; INFO-NEW-1 resolved this round) |
| **Failed (GAPs)** | 0 |
| **Warnings (INFO)** | 14 active (INFO-1..4 carry; INFO-6 carry; INFO-8 carry; INFO-11..13 carry; INFO-14 re-opened; INFO-15 carry; INFO-NEW-2 new; INFO-NEW-3 new) |
| **Overall Status** | consistent |

Round 31 is a PATCH-level validation confirming 6 P21 adversary-pass fixes: (1) BC-3.9.010 bulk-delete paragraph correctly rewritten — "404 is NOT a failure on the bulk path"; EC-3.9.010-4 present; BC-3.9.013 multi-delete exception consistent; single-vs-bulk 404 divergence cross-ref (BC-3.9.008 vs BC-3.9.013) with "intentionally asymmetric MUST NOT be unified" clause; H-NEW-ATTACHMENT-012 added (3-AID bulk, middle 404 → count=2, ids=[40001,40003], exit 0, 3 DELETE calls asserted); holdout count 99→100 (P21-001 HIGH); (2) VP-576-005 fixture corrected: plain GET /rest/api/3/issue/EJ-1 removed (one-issue-GET invariant violation); mounts renumbered (1) project GET + service desk meta, (2) ?fields=attachment GET; assert (d) added (zero plain issue GETs in strict mode) (P21-002 MEDIUM); (3) Group 19 header bumped to (H-NEW-ATTACHMENT-001..012); resolves r30 INFO-NEW-1 (P21-003 LOW); (4) BC-3.9.004 branch-(a) HTTP sequence expanded to "project-meta resolution per BC-X.8.010 (up to 2 cache-miss GETs: GET /rest/api/3/project/{key} + GET /rest/servicedeskapi/servicedesk pagination for serviceDeskId)"; branch-(b) unchanged; BC-INDEX row updated (P21-004 LOW); (5) EC-3.9.004-4 added (Step-0 suppression on --replace-existing --internal path; symmetric with EC-3.9.003-5 P17-003); BC-3.9.017 step 4 cross-ref "BC-3.9.004 EC-3.9.004-4, P21-005" added; BC-3.9.004 Trace updated; BC-INDEX row updated (P21-005 LOW); (6) BC-2.7.012 KEY-404 row annotated "(batch paths only — `--id` does not server-verify KEY per BC-2.7.007)"; BC-INDEX BC-2.7.012 row updated with P21-006 citation; BC-2.7.012 Trace in bc-2 body not updated (INFO-NEW-2) (P21-006 INFO). BC-INDEX v6.20→v6.21. spec-changelog [1.3.61] present (artifact table only; missing explicit count rows — INFO-14 re-opened, INFO-NEW-2). prd-delta-576.md frontmatter spec_version_after 1.3.61 + holdout_count_after 100 + P21 dispositions section present. No double-insertions despite hook-timeout risk. Spec version advances to 1.3.61. BC count unchanged at 657; holdout count 100 (+1); VP count 35 (unchanged). INFO-NEW-1 from r30 RESOLVED.

---

## Appendix: Validation Methodology

This report was produced by a fresh-context consistency validator (cv-f2-576-r31) with no visibility into prior round reports except the r30 report (provided as structural reference).

1. **Independent artifact read**: All 7 input artifacts read fresh. Findings formed independently.
2. **Quote-based closure**: Every P21 priority check verified by verbatim quotation from the authoritative artifact.
3. **Double-insertion sweep**: Exact marker occurrence counts verified. EC-3.9.004-4 appears 5 times (frontmatter trace + definition body + Trace + step-4 cross-ref + footer) — all five are distinct legitimate roles.
4. **Bulk-404-exit-64 residue scan**: All "404 → exit 64" occurrences in bc-3 analyzed. None found in bulk context. Single-AID contexts (BC-3.9.008, EC-3.9.013-1, pre-gate metadata fetch) correctly retained.
5. **Echo-breaker List A (5 sentences)**: Special scrutiny on BC-3.9.004 branch-(a) "up to 2 cache-miss GETs" (Sentence 4 — all five HTTP sequence elements traced to BC-X.8.010/BC-3.9.003/BC-3.9.004). No over-claims found.
6. **Echo-breaker List B (ALL fixture mounts)**: VP-576-005 and H-012 mount/call-count sets fully audited against wire contracts. No forbidden calls added; no mandated calls omitted. Cache-miss assumptions in VP-576-005 mount (1) are valid in test context (JR_CACHE_DIR isolation → cold cache).
7. **Keystone checks**: K-1 through K-5 verified: bulk-404 story coherent across BC-3.9.010/EC-3.9.010-4/BC-3.9.013/H-012; VP-576-005 mounts match BC-3.9.017 steps 0-4 + EC-3.9.003-5 + BC-X.8.010; EC-3.9.004-4 symmetric with EC-3.9.003-5 + step-4 dual routing; BC-3.9.004(a) and BC-3.9.003 share identical BC-X.8.010 resolution story; Group 19 header/scenarios/CANONICAL-COUNTS all agree on range ..012.
8. **Guard scripts**: Both `check-spec-counts.sh` and `check-bc-cumulative-counts.sh` executed and verified "OK".
9. **Count sweep**: BC (657), holdout (100), VP (35) verified across BC-INDEX frontmatter, bc-2/bc-3 frontmatter, prd-delta-576.md P21 closing, spec-changelog [1.3.61] (partial — no explicit count rows), and holdout-scenarios.md frontmatter.
10. **INFO-NEW-1 closure**: CANONICAL-COUNTS.md Group 19 range now "..012" (+12) and reconciliation Note references 100/P21-001. INFO-NEW-1 from r30 RESOLVED.
11. **New INFO items**: INFO-NEW-2 (spec-changelog [1.3.61] missing explicit count rows; BC-2.7.012 Trace in bc-2 body missing P21-006). INFO-NEW-3 (bc-2 frontmatter trace not updated for P20/P21). Both non-blocking.
