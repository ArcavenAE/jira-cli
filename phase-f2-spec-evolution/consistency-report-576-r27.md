---
document_type: consistency-report
round: 27
spec_version: 1.3.57
date: 2026-07-16
validator: cv-f2-576-r27 (fresh context, no prior round visibility)
verdict: CONSISTENT
bc_count: 657
holdout_count: 98
vp_count: 33
priority_checks: P17-001 (BC-3.9.014 Source S5→S3), P17-002 (impact-boundary-576.md four function-name sites), P17-003 (EC-3.9.003-5 Step-0 suppression), P17-004 (EC-3.9.017-9 sub-variants A+B; BC-3.9.014 three non-interactive variants), P17-005 (BC-3.9.007 EC-3.9.007-1 allocation note + prd-delta scope table), P17-006 (upload-cancel JSON row), P17-007 (EC-2.7.009-1 allow_negative_numbers), K-1..K-4 keystones, message-variant symmetry, Step-0 suppression coherence, H-008/H-009 DIRECT-path fixtures, INFO-7/INFO-10 resolution, BC-INDEX v6.17
level: ops
version: "1.0"
status: pass
producer: cv-f2-576-r27
timestamp: 2026-07-16T00:00:00
phase: 2
inputs:
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576-worklog.md"
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/specs/prd/CANONICAL-COUNTS.md"
  - ".factory/spec-changelog.md"
  - ".factory/phase-f1-delta-analysis/impact-boundary-576.md"
  - ".factory/STATE.md"
input-hash: "65275d2"
traces_to: ".factory/specs/prd/BC-INDEX.md"
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 27 (post-P17 remediation)

**Spec version**: 1.3.57 | **BCs**: 657 | **Holdouts**: 98 | **VPs**: 33 | **Verdict**: CONSISTENT

---

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) — SOH-ATTACHMENTS-1 F2 |
| **Generated** | 2026-07-16T00:00:00 |
| **Generator** | cv-f2-576-r27 (fresh-context consistency validator, round 27) |
| **Artifacts Scanned** | 10 (bc-3-issue-write.md, bc-2-issue-read.md, holdout-scenarios.md, prd-delta-576.md, prd-delta-576-worklog.md, BC-INDEX.md, CANONICAL-COUNTS.md, spec-changelog.md, impact-boundary-576.md, STATE.md) |
| **Focus** | Post-P17 adversary-pass remediation verification — spec v1.3.57 |
| **Prior round** | consistency-report-576-r26.md (CONSISTENT at v1.3.56) |

---

## Summary

| # | Check | Result |
|---|-------|--------|
| P17-001 | BC-3.9.014 Source field: "story S3, gate mechanics; consumed by S5 --public/combined per R3.13" | pass |
| P17-002a | impact-boundary-576.md §1.1 table: `upload_attachments` with P17-002 annotation | pass |
| P17-002b | impact-boundary-576.md SQ-3 prose (~267): `upload_attachments` with P17-002 annotation | pass |
| P17-002c | impact-boundary-576.md R2.1 table: `post_request_attachment` with P17-002 annotation | pass |
| P17-002d | impact-boundary-576.md R3.7 list: `upload_attachments` with P17-002 annotation | pass |
| P17-002-residual | No residual `attach_to_request` or singular `upload_attachment` in impact-boundary-576.md | pass |
| P17-002-count | spec-changelog.md and prd-delta-576.md P17-002 row say "three sites" but four were changed (SQ-3 is the fourth) | INFO-11 |
| P17-003 | EC-3.9.003-5 Step-0 suppression clause added (P17-003): when entered from BC-3.9.017 step 4, Step 0 SKIPPED; exactly ONE issue GET per invocation | pass |
| P17-004a | EC-3.9.017-9 sub-variant B added: `"Use --yes to confirm uploading as customer-visible (public) and deleting existing same-filename attachments."` | pass |
| P17-004b | BC-3.9.014 Non-interactive path: three message variants (P17-004) enumerated, symmetric with three interactive prompts | pass |
| P17-005a | BC-3.9.007 EC-3.9.007-1: allocation note added (P17-005) — exercised in S3; S5 owns EC-3.9.007-2 | pass |
| P17-005b | prd-delta-576.md S3 row: BC-3.9.007 EC-3.9.007-1 scope note added (P17-005) | pass |
| P17-005c | prd-delta-576.md S5 row: BC-3.9.007 EC-3.9.007-2 JSM scope note added (P17-005) | pass |
| P17-006 | Upload-cancel JSON row added to JSON Output Shape Contracts table: `{"cancelled":true,"uploaded":false}` | pass |
| P17-007 | EC-2.7.009-1 annotated: `(arg-level \`Arg::allow_negative_numbers\`, clap 4 — verified against docs.rs 4.6.1, P17-007)` | pass |
| BC-INDEX | index_version v6.16→v6.17; last_updated reflects P17; five BC rows updated | pass |
| spec-changelog | [1.3.57] entry present | pass |
| prd-delta | spec_version_after: 1.3.57; P17 dispositions section (P17-001..007 APPLIED) | pass |
| A-residual | No surface still tying BC-3.9.014 to S5; no actionable old function names | pass |
| A-symmetry | Three interactive prompts ↔ three non-interactive messages — 1:1 trigger mapping verified verbatim | pass |
| A-H008 | H-NEW-ATTACHMENT-008: DIRECT BC-3.9.003 path; Step 0 IS executed; no suppression implied | pass |
| A-H009 | H-NEW-ATTACHMENT-009: DIRECT BC-3.9.003 path; Step 0 IS executed; no suppression implied | pass |
| K-1 | BC-3.9.014 Source ↔ Scope table ↔ R3.13 — single coherent S3 ownership story | pass |
| K-2 | EC-3.9.017-9 sub-variants ↔ BC-3.9.014 three variants ↔ EC-3.9.003-7 precedence — no contradiction | pass |
| K-3 | Step-0 suppression ↔ ONE issue GET ↔ BC-3.9.012 404-source — non-contradictory | pass |
| K-4 | BC-INDEX v6.17 rows ↔ bodies for all five touched BCs | pass |
| — | Counts: BC 657 / holdouts 98 / VP 33 on all primary surfaces | pass |
| — | [1.3.57] in spec-changelog.md | pass |
| — | prd-delta-576.md frontmatter `spec_version_after: 1.3.57` | pass |
| — | prd-delta-576.md frontmatter `holdout_count_after: 98` (unchanged) | pass |
| — | Guard: check-spec-counts.sh exits 0 | pass |
| — | Guard: check-bc-cumulative-counts.sh exits 0 | pass |
| INFO-7 | RESOLVED at P16 micro-fix (BC-3.9.020 row in BC-INDEX now covers upload --replace-existing path) | resolved |
| INFO-10 | RESOLVED: all four stale surfaces addressed (P16 micro-fix v6.15→v6.16 + P17 v6.16→v6.17) | resolved |
| INFO-12 | NEW R27: BC-3.9.003 Trace not updated for P17-003 (citation present in EC-3.9.003-5 body but not Trace field) | new INFO |

All 30 behavioral check areas pass. Two new INFO items. INFO-7 and INFO-10 resolved. No behavioral contradictions.

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

### P17-001 — BC-3.9.014 Source field corrected S5→S3

**Quote-verified verbatim** (`bc-3-issue-write.md` BC-3.9.014 Source, line 3593):

> `**Source**: \`src/cli/issue/attachments.rs\` (implementation pending — story S3, gate mechanics; consumed by S5 --public/combined per R3.13)`

Previously said "implementation pending — story S5". Now correctly identifies story S3 with the R3.13 reallocation note and S5 consumer relationship. Aligns with BC-INDEX.md BC-3.9.014 row which was already corrected at P16.

**Result**: Source field corrected to S3. R3.13 dependency relationship stated. APPLIED ✓

---

### P17-002 — Function-name alignment (FOUR sites in impact-boundary-576.md)

**Quote-verified verbatim** — all four sites:

**Site 1: §1.1 table** (`impact-boundary-576.md` line 44):
> `| \`upload_attachments(client, key, paths)\` | \`POST /rest/api/3/issue/{key}/attachments\` | POST multipart; requires \`X-Atlassian-Token: no-check\` | <!-- name aligned to BC body, P17-002 -->`

**Site 2: SQ-3 prose** (`impact-boundary-576.md` line 267):
> `it must be added explicitly in \`upload_attachments\` and tested with a wiremock integration test that asserts the header is present. <!-- name aligned to BC body, P17-002 -->`

**Site 3: R2.1 table** (`impact-boundary-576.md` line 406):
> `| \`post_request_attachment(client, issue_key, temp_ids, public)\` | \`POST /rest/servicedeskapi/request/{issueKey}/attachment\` | JSON body; \`additionalComment\` omitted (optional per P2-3b) | <!-- name aligned to BC body, P17-002 -->`

**Site 4: R3.7 list** (`impact-boundary-576.md` line 696):
> `The full revised function list for \`src/api/jira/attachments.rs\` (5 functions): \`list_attachments\`, \`get_attachment_content\`, \`get_attachment_metadata\`, \`upload_attachments\`, \`delete_attachment\`. S4 story plan must allocate implementation scope for this function alongside the delete handler. <!-- upload_attachments plural — name aligned to BC body, P17-002 -->`

Grep for residual `attach_to_request` or singular `upload_attachment(` in impact-boundary-576.md: zero results. ✓

**COUNT DISCREPANCY (INFO-11)**: The spec-changelog.md [1.3.57] Changes list (line 20) and the prd-delta-576.md P17-002 disposition row (line 331) both state "All **three** sites annotated". However, four sites were actually updated (SQ-3 prose at line 267 is the fourth). All four sites are correctly updated with P17-002 annotations; the discrepancy is in the tracking records only (changelog and delta). Non-behavioral, non-blocking. See INFO-11.

**Result**: All four function-name sites updated with P17-002 annotations. No old function names remain. Tracking records undercount by one (INFO-11). APPLIED ✓

---

### P17-003 — EC-3.9.003-5 Step-0 suppression clause

**Quote-verified verbatim** (`bc-3-issue-write.md` EC-3.9.003-5, line 3325 — Step-0 suppression tail):

> `**Step-0 suppression (P17-003)**: when BC-3.9.003 is entered from BC-3.9.017 step 4, Step 0 (issue GET) is SKIPPED — existence was already validated by BC-3.9.017 step 1's \`?fields=attachment\` GET and project meta was already resolved at its step 0; exactly ONE issue GET occurs per invocation on the combined \`--replace-existing --public\` path.`

The clause correctly identifies: (a) suppression applies only when entering from BC-3.9.017 step 4 (not on direct `--public` paths), (b) BC-3.9.017 step 1's `?fields=attachment` GET provides the existence validation, (c) exactly ONE issue GET per invocation on the combined path.

**BC-3.9.003 Trace not updated (INFO-12)**: The Trace field at line 3329 ends at P16-003 and does not cite P17-003. The P17-003 citation IS present in the EC-3.9.003-5 body text. Minor cosmetic gap; non-blocking. See INFO-12.

**Result**: Step-0 suppression clause present and coherent. APPLIED ✓

---

### P17-004 — EC-3.9.017-9 sub-variants A+B; BC-3.9.014 three non-interactive variants

**Quote-verified verbatim** (`bc-3-issue-write.md` EC-3.9.017-9, line 3767):

> `**EC-3.9.017-9** (non-interactive, ≥1 match, no \`--yes\` — P15-002/R3.12): ... **Two sub-variants (P17-004)**: (A) \`--replace-existing\` only (no \`--public\`): \`"Use --yes to confirm deletion of existing same-filename attachments."\` (B) Combined \`--public\` + ≥1 match: \`"Use --yes to confirm uploading as customer-visible (public) and deleting existing same-filename attachments."\``

**Quote-verified verbatim** (`bc-3-issue-write.md` BC-3.9.014 Non-interactive path, line 3611):

> `**Three message variants (P17-004)** — symmetric with the three interactive prompt variants above: (1) \`--public\` only (consumer 1): \`"Use --yes to confirm uploading <N> file(s) to <KEY> as customer-visible, or run interactively."\` (2) \`--replace-existing\` with ≥1 same-filename match, no \`--public\` (consumer 2): \`"Use --yes to confirm deletion of existing same-filename attachments."\` (3) Combined \`--public\` + ≥1 match (consumer 3): \`"Use --yes to confirm uploading as customer-visible (public) and deleting existing same-filename attachments."\``

**Symmetry verification** — all six messages, 1:1 interactive↔non-interactive mapping:

| Consumer | Interactive prompt (BC-3.9.014) | Non-interactive message (BC-3.9.014 variant / EC-3.9.017-9) |
|---|---|---|
| 1: `--public` only (direct BC-3.9.003) | `"Upload <filename1>, ... to <KEY> as customer-visible (public)? [y/N] "` (≤3 files) | `"Use --yes to confirm uploading <N> file(s) to <KEY> as customer-visible, or run interactively."` |
| 2: `--replace-existing` ≥1 match, no `--public` | `"Replace existing attachment(s) on <KEY>:\n  <filename1> (id: <AID1>)\n  ...\nContinue? [y/N] "` | `"Use --yes to confirm deletion of existing same-filename attachments."` (EC-3.9.017-9 sub-A) |
| 3: Combined `--public` + ≥1 match | `"Upload to <KEY> as customer-visible (public) and replace existing attachment(s):\n  <filename1> (id: <AID1>)\n  ...\nContinue? [y/N] "` | `"Use --yes to confirm uploading as customer-visible (public) and deleting existing same-filename attachments."` (EC-3.9.017-9 sub-B = BC-3.9.014 variant 3) |

1:1 trigger mapping confirmed. EC-3.9.017-9 sub-A = BC-3.9.014 variant 2 (verbatim). EC-3.9.017-9 sub-B = BC-3.9.014 variant 3 (verbatim). Consumer 1 fires from BC-3.9.003 non-interactive path; consumers 2+3 fire from BC-3.9.017 step-2 non-interactive path. No contradiction on which message fires when.

BC-INDEX.md BC-3.9.017 row (line 389) reflects sub-variant B: "two sub-variants (P17-004): (A) no --public: ...; (B) combined --public + ≥1 match: ..." ✓

**Result**: EC-3.9.017-9 sub-variants and BC-3.9.014 three-variant section both applied; symmetry verified. APPLIED ✓

---

### P17-005 — BC-3.9.007 EC-3.9.007-1 allocation note

**Quote-verified verbatim** (`bc-3-issue-write.md` EC-3.9.007-1, line 3424):

> `**EC-3.9.007-1** (platform upload echo): Response array from POST is used directly; no secondary GET to the issue's attachment list. **Allocation note (P17-005)**: EC-3.9.007-1 platform-echo clause is exercised in S3 (covered by BC-3.9.001 + BC-3.9.009; R3.13 earliest-consumer principle); S5 owns JSM echo clauses (EC-3.9.007-2).`

**Quote-verified verbatim** (`prd-delta-576.md` S3 row, line 33 — P17-005 note):

> `**BC-3.9.007 scope note (P17-005)**: BC-3.9.007 EC-3.9.007-1 platform-echo clause is exercised in S3 (BC-3.9.001 + BC-3.9.009 ship with S3; earliest-consumer principle per R3.13).`

**Quote-verified verbatim** (`prd-delta-576.md` S5 row, line 35 — P17-005 note):

> `**BC-3.9.007 scope note (P17-005)**: S5 owns JSM echo clauses (EC-3.9.007-2, P2-3c deferred); platform-echo clause (EC-3.9.007-1) ships with S3.`

BC-INDEX.md BC-3.9.007 row (line 379) reflects the allocation: "**EC-3.9.007-1 platform-echo clause exercised in S3** (BC-3.9.001 + BC-3.9.009; R3.13 earliest-consumer principle); S5 owns JSM echo clauses (EC-3.9.007-2); P17-005" ✓

**Result**: EC-3.9.007-1 allocation note applied in BC body, prd-delta Scope table (S3 + S5), and BC-INDEX. APPLIED ✓

---

### P17-006 — Upload-cancel JSON row

**Quote-verified verbatim** (`bc-3-issue-write.md` JSON Output Shape Contracts table, line 3221):

> `| \`attachment upload\` (cancel — interactive 'n' or empty, or non-interactive without \`--yes\`) | \`{"cancelled":true,"uploaded":false}\` | 2 keys alphabetical; BC-3.9.003/BC-3.9.014/BC-3.9.017 |`

Row is placed between the `--replace-existing --dry-run` row (line 3220) and the `--public` shape TBD row (line 3222). Placement is correct per P17-006 disposition.

Cross-reference to BC-3.9.003 body (line 3313, 3324) and BC-3.9.014 EC-3.9.014-2 (line 3620): both say `{"cancelled":true,"uploaded":false}`. JSON Output Shape Contracts table value matches. ✓

**Result**: Upload-cancel row added. Shape matches BC body. APPLIED ✓

---

### P17-007 — EC-2.7.009-1 `Arg::allow_negative_numbers` annotation

**Quote-verified verbatim** (`bc-2-issue-read.md` EC-2.7.009-1, line 816):

> `**EC-2.7.009-1** (N ≤ 0 — clap parses \`--newest\` as a signed integer i64; app validates N ≥ 1): \`--newest\` MUST be declared with \`allow_negative_numbers = true\` so that negative values (e.g. \`-5\`) reach the handler as a valid i64 rather than being intercepted by clap as an unknown flag (clap exit 2). The handler validates N ≥ 1; if it finds N ≤ 0, exit 64 before any HTTP call: \`"--newest requires a positive integer."\` N = 0 is rejected (zero-download is ambiguous, not silently accepted). (arg-level \`Arg::allow_negative_numbers\`, clap 4 — verified against docs.rs 4.6.1, P17-007)`

BC-INDEX.md BC-2.7.009 row (line 228) reflects the annotation: "declared with arg-level `Arg::allow_negative_numbers` (clap 4 — verified docs.rs 4.6.1; P17-007)" ✓

**Result**: EC-2.7.009-1 annotated with clap 4.6.1 verification note. APPLIED ✓

---

### BC-INDEX.md — Five touched BC rows + v6.17

**Quote-verified verbatim** (`BC-INDEX.md` frontmatter, lines 5-6):

> `last_updated: 2026-07-16  # P17 adversary fix round: BC-2.7.009 row allow_negative_numbers clap 4 annotation (P17-007); BC-3.9.003 row Step-0 suppression on combined path (P17-003); BC-3.9.007 row EC-3.9.007-1 S3/S5 allocation note (P17-005); BC-3.9.014 row three non-interactive message variants + Source corrected (P17-001/P17-004); BC-3.9.017 row combined non-interactive sub-variant B (P17-004); spec v1.3.57; BC count unchanged (657); BC-INDEX v6.17`
> `index_version: v6.17`

All five BC rows verified updated (see P17-001..007 sections above for individual row quotes at lines 228, 375, 379, 386, 389).

**Result**: BC-INDEX at v6.17; all five rows updated. APPLIED ✓

---

## Keystone Coherence Checks

### K-1: BC-3.9.014 Source ↔ Scope table ↔ R3.13 — single coherent S3 ownership story

BC-3.9.014 Source (bc-3-issue-write.md line 3593): "story S3, gate mechanics; consumed by S5 --public/combined per R3.13" ✓

prd-delta-576.md S3 row (line 33): "BC-3.9.014 gate mechanics ship with S3 ... [P16-002 ORCHESTRATOR RULING: BC-3.9.014 reallocated S5→S3]" ✓

prd-delta-576.md S5 row (line 35): "BC-3.9.014 gate mechanics consumed here ... gate mechanics ship with S3 (above); S5 depends_on S3 for this. [P16-002 ORCHESTRATOR RULING]" ✓

impact-boundary-576.md R3.13: "BC-3.9.014 ... is reallocated from S5 to **S3** — the earliest gate consumer in wave order ships the shared mechanics; S5 (--public/--internal) consumes them." ✓

No surface ties BC-3.9.014 to S5 as the owning story. S3 ownership is coherent across BC body Source, Scope table, and R3.13 ruling.

**K-1 COHERENT ✓**

---

### K-2: EC-3.9.017-9 sub-variants ↔ BC-3.9.014 three non-interactive variants ↔ EC-3.9.003-7 precedence

Sub-variant message matching:
- EC-3.9.017-9 sub-A = BC-3.9.014 variant 2 = `"Use --yes to confirm deletion of existing same-filename attachments."` (verbatim identical) ✓
- EC-3.9.017-9 sub-B = BC-3.9.014 variant 3 = `"Use --yes to confirm uploading as customer-visible (public) and deleting existing same-filename attachments."` (verbatim identical) ✓
- BC-3.9.003 non-interactive path = BC-3.9.014 variant 1 = `"Use --yes to confirm uploading <N> file(s) to <KEY> as customer-visible, or run interactively."` ✓

EC-3.9.003-7 (guard-precedence: non-JSM check fires BEFORE non-interactive gate, line 3327): unaffected by P17. JSM eligibility check still fires first (pre-gate), then non-interactive check. No contradiction with the three-variant non-interactive messages — all three are gated behind the JSM eligibility check for the `--public` consumers.

Trigger routing is coherent: consumers 1 (BC-3.9.003) and 2+3 (BC-3.9.017 step 2) each have their own non-interactive exit-64 path; the messages are distinct and non-overlapping.

**K-2 COHERENT ✓**

---

### K-3: Step-0 suppression ↔ "exactly ONE issue GET" ↔ BC-3.9.012 404-source wording

EC-3.9.003-5 Step-0 suppression clause (line 3325): "when BC-3.9.003 is entered from BC-3.9.017 step 4, Step 0 (issue GET) is SKIPPED — existence was already validated by BC-3.9.017 step 1's `?fields=attachment` GET and project meta was already resolved at its step 0; exactly ONE issue GET occurs per invocation on the combined `--replace-existing --public` path." ✓

BC-3.9.017 step 1 (line 3732): "`GET /rest/api/3/issue/{key}?fields=attachment` to retrieve `fields.attachment[]`" — this IS an issue GET; it serves as the existence validation on the combined `--replace-existing --public` path when Step 0 is suppressed. ✓

BC-3.9.012 row (line 3542): "Issue key not found | 404 from the upload POST (platform path) or from the issue GET (`--public` / `--replace-existing` paths) | 64 | `"Issue <KEY> not found or not accessible."`"

The `--replace-existing` clause covers BC-3.9.017 step 1's `?fields=attachment` GET (which IS an issue GET). On the combined `--replace-existing --public` path, a 404 from step 1 would be handled via EC-3.9.012-2 (exit 64 before attachment POST). The row wording is non-contradictory with the Step-0 suppression. BC-3.9.017 step 4 note (line 3746) says "Only the servicedeskapi wire steps execute (BC-3.9.003 EC-3.9.003-5)" — compatible with Step-0 suppression (suppression is stated in EC-3.9.003-5, not in step 4's prose, but cross-referenced via EC-3.9.003-5).

H-008 (line 2411): DIRECT BC-3.9.003 path (non-JSM `--public --yes` without `--replace-existing`). Mounts `GET /rest/api/3/issue/SOFTWARE-1` — Step 0 IS executed here. No suppression. The fixture says "per BC-3.9.003 Step 0, this GET validates existence only". ✓

H-009 (line 2440): DIRECT BC-3.9.003 path (JSM `--public` without `--replace-existing`). Mounts `GET /rest/api/3/issue/EJ-1` — Step 0 IS executed here. No suppression. The fixture says "per BC-3.9.003 Step 0, this GET validates existence only". ✓

Neither H-008 nor H-009 exercises the `--replace-existing --public` combined path where suppression applies. No fixture implies suppression incorrectly.

**K-3 COHERENT ✓**

---

### K-4: BC-INDEX v6.17 rows ↔ bodies for all five touched BCs

| BC | BC-INDEX.md row (line) | Body (line) | Match |
|----|----------------------|-------------|-------|
| BC-2.7.009 | 228: "declared with arg-level `Arg::allow_negative_numbers` (clap 4 — verified docs.rs 4.6.1; P17-007)" | 816: "(arg-level `Arg::allow_negative_numbers`, clap 4 — verified against docs.rs 4.6.1, P17-007)" | ✓ |
| BC-3.9.003 | 375: "Step-0 suppression on combined path (P17-003): when entered from BC-3.9.017 step 4, Step 0 SKIPPED — existence validated by BC-3.9.017 step 1's `?fields=attachment` GET; ONE issue GET per invocation" | 3325: "**Step-0 suppression (P17-003)**: when BC-3.9.003 is entered from BC-3.9.017 step 4, Step 0 (issue GET) is SKIPPED... exactly ONE issue GET occurs per invocation on the combined path." | ✓ |
| BC-3.9.007 | 379: "**EC-3.9.007-1 platform-echo clause exercised in S3** (BC-3.9.001 + BC-3.9.009; R3.13 earliest-consumer principle); S5 owns JSM echo clauses (EC-3.9.007-2); P17-005" | 3424: "**Allocation note (P17-005)**: EC-3.9.007-1 platform-echo clause is exercised in S3 (covered by BC-3.9.001 + BC-3.9.009; R3.13 earliest-consumer principle); S5 owns JSM echo clauses (EC-3.9.007-2)." | ✓ |
| BC-3.9.014 | 386: "three non-interactive exit-64 message variants (P17-004): (1) --public only; (2) --replace-existing ≥1-match; (3) combined; Source corrected S5→S3 body (P17-001)" | 3593: "story S3, gate mechanics; consumed by S5 --public/combined per R3.13" (Source); 3611: "**Three message variants (P17-004)** — ... (1)...(2)...(3)..." | ✓ |
| BC-3.9.017 | 389: "two sub-variants (P17-004): (A) no --public: `"Use --yes to confirm deletion of existing same-filename attachments."` (B) combined --public + ≥1 match: `"Use --yes to confirm uploading as customer-visible (public) and deleting existing same-filename attachments."`" | 3767: "**Two sub-variants (P17-004)**: (A)... (B)..." | ✓ |

All five BC rows in BC-INDEX v6.17 accurately reflect their bodies.

**K-4 COHERENT ✓**

---

## Cross-Artifact Count Verification

### BC Counts

| Source | bc-2 definitional | bc-2 total_bcs | bc-3 definitional | bc-3 total_bcs | Grand Total |
|--------|-------------------|-----------------|-------------------|-----------------|-------------|
| Frontmatter | 64 | 106 | 111 | 140 | 657 |
| CANONICAL-COUNTS.md | 64 | 106 | 111 | 140 | 657 |
| Guard output | verified | — | verified | — | 657 |

P17 added 0 new BCs. PASS ✓

### Holdout Counts

| Source | Count | Status |
|--------|-------|--------|
| `holdout-scenarios.md` frontmatter `total_holdouts` | 98 | PASS ✓ |
| `CANONICAL-COUNTS.md` holdout section | 98 | PASS ✓ |
| `CANONICAL-COUNTS.md` Group 19 entry | H-NEW-ATTACHMENT-001..010 | PASS ✓ |
| `prd-delta-576.md` frontmatter `holdout_count_after` | 98 | PASS ✓ |
| `spec-changelog.md` [1.3.57] Impact table | "Holdout count: 98 (unchanged)" | PASS ✓ |

P17 added 0 holdouts. 98 unchanged. PASS ✓

### VP Counts

| Source | VP count reference | Status |
|--------|-------------------|--------|
| `spec-changelog.md` [1.3.57] Impact table | "VP count: 33 (unchanged)" | PASS ✓ |
| `prd-delta-576.md` P17 fix-round summary (line 338) | "VP count: 33 (unchanged). Spec version: 1.3.57." | PASS ✓ |

---

## Spec Version Surface Verification

| Artifact | Spec version shown | Status |
|----------|--------------------|--------|
| `prd-delta-576.md` frontmatter `spec_version_after` | `1.3.57` | PASS ✓ |
| `spec-changelog.md` | `[1.3.57] - 2026-07-16` entry present | PASS ✓ |
| `bc-3-issue-write.md` footer (line 3887) | "spec v1.3.57" in P17 last-updated note | PASS ✓ |
| `BC-INDEX.md` `last_updated` | P17 adversary fix round; spec v1.3.57; BC-INDEX v6.17 | PASS ✓ |
| `STATE.md` `current_step` | "spec v1.3.56" (still at P16) | STALE (INFO-8 carries forward) |

---

## INFO Ledger Status

### INFO-1 (carry-forward R21–R26)

Double blank lines between EC-2.7.008-6 and EC-2.7.008-7 in `bc-2-issue-read.md`. Not introduced or worsened by P17.

**Status**: CARRY-FORWARD

---

### INFO-2 (carry-forward R21–R26)

EC-2.7.008-2/EC-2.7.008-5 redundant pair. Not introduced or worsened by P17.

**Status**: CARRY-FORWARD

---

### INFO-3 (carry-forward R21–R26)

BC-2.7.012 "KEY or AID 5xx" combined-scope row is correct but imprecise. Not introduced or worsened by P17.

**Status**: CARRY-FORWARD

---

### INFO-4 (carry-forward R22–R26)

H-NEW-ATTACHMENT-003 BC refs footer does not explicitly mention "Call B2". Not introduced or worsened by P17.

**Status**: CARRY-FORWARD

---

### INFO-5 — RESOLVED (P14)

Carry-forward audit note only.

**Status**: RESOLVED (P14)

---

### INFO-6 (carry-forward R23–R26)

No holdout for the collision-skip exit-0 path. Not introduced or worsened by P17.

**Status**: CARRY-FORWARD

---

### INFO-7 — RESOLVED at P16 micro-fix

BC-INDEX.md BC-3.9.020 row (line 392) now correctly reads "`attachment --dry-run` (delete multi-path + upload `--replace-existing`):" — both the delete multi-path and the upload `--replace-existing` path (added at P14-010) are represented. The P16 micro-fix (v6.15→v6.16) folded this correction. Confirmed at current BC-INDEX v6.17.

NOTE: R26 marked INFO-7 as carry-forward, but the P16 micro-fix (documented in STATE.md line 57: "BC-INDEX micro-fix v6.15→v6.16 (4 stale index rows + INFO-7 BC-3.9.020 retitle folded)") resolved it. The actual BC-INDEX content confirms resolution.

**Status**: RESOLVED ✓

---

### INFO-8 (carry-forward R25→R27)

`STATE.md` live status rows still reflect P16 values:

- `current_step` (line 15): "PASS-16 REMEDIATED ... spec v1.3.56"
- `Current Phase` row (line 43): "Spec v1.3.56. BC **657**. Holdouts **98**. VP **33**."
- Pipeline tracker ends at P16 entry (line 57); no P17 entry.
- Comment block (line 266): "spec v1.3.56; ... Passes 1-16 all remediated"

Correct values after P17: spec v1.3.57; passes 1-17 remediated. BC 657 / holdouts 98 / VP 33 are all correct. Only spec version and pass count trail.

The task directive says "do not edit STATE.md." Non-blocking; state-manager updates at each fix round; P17 burst-commit pending.

**Status**: CARRY-FORWARD (spec version only stale; non-blocking)

---

### INFO-9 — RESOLVED (R26)

`prd-delta-576-worklog.md` pointer lines verified present. Worklog discontinued as of P14.

**Status**: RESOLVED (R26)

---

### INFO-10 — RESOLVED at P16 micro-fix + P17

The four stale surfaces identified at R26:

1. `last_updated` comment in BC-INDEX.md: now reflects P17 adversary fix round (line 5). ✓ RESOLVED
2. BC-3.9.003 row missing Step 0: now includes Step-0 suppression on combined path (P17-003; line 375). ✓ RESOLVED
3. BC-3.9.015 row missing 403/401/5xx taxonomy: already updated by P16 micro-fix (v6.15→v6.16) with "metadata-fetch failure taxonomy (P16-005)" at line 387. ✓ RESOLVED
4. BC-3.9.014 row "pending S5": updated in P16 micro-fix (allocation moved S5→S3) and in P17 (Source corrected + three message variants; line 386). ✓ RESOLVED

All four sub-items resolved. BC-INDEX is now at v6.17.

**Status**: RESOLVED ✓

---

### INFO-11 (NEW R27)

`spec-changelog.md` [1.3.57] Changes list (line 20) says: "`impact-boundary-576.md`... All **three** sites annotated `(name aligned to BC body, P17-002)`."

`prd-delta-576.md` P17-002 disposition row (line 331) says: "All **three** sites annotated `(name aligned to BC body, P17-002)`."

However, FOUR sites were actually updated:
1. §1.1 table (line 44) — `upload_attachments` ✓
2. SQ-3 prose (line 267) — `upload_attachments` ✓
3. R2.1 table (line 406) — `post_request_attachment` ✓
4. R3.7 list (line 696) — `upload_attachments` ✓

All four sites are correctly updated with P17-002 annotations in impact-boundary-576.md. The discrepancy exists only in the tracking records (changelog + delta disposition). The behavioral content is correct; this is cosmetic undercount in documentation. Non-blocking.

**Status**: NEW INFO (cosmetic; non-blocking)

---

### INFO-12 (NEW R27)

`bc-3-issue-write.md` BC-3.9.003 Trace field (line 3329) was not updated for P17-003. The Trace ends with "P16-003 (Step 0 added: issue GET for existence validation + project key; projectTypeKey source pinned to get_or_fetch_project_meta NOT issue GET; key-derivation asymmetry vs BC-3.9.017 step 0 extended)" — no P17-003 citation.

The P17-003 Step-0 suppression IS cited in EC-3.9.003-5's body text: "**Step-0 suppression (P17-003)**". So the reference exists within the EC body. The Trace field is a convenience summary and was not updated for this extension.

This follows the same pattern as INFO-8 (STATE.md trailing) — minor cosmetic gap; authoritative content is present. Non-blocking.

**Status**: NEW INFO (cosmetic; non-blocking)

---

## Spec vs Implementation Drift

This report covers spec-evolution artifact drift only (F2 patch round). Implementation source code is out of scope for this validation round — no product source was modified by P17.

| Artifact | Spec Version After P17 | Consistency Status | Notes |
|----------|------------------------|-------------------|-------|
| bc-3-issue-write.md | footer "spec v1.3.57" | consistent | P17-001..006 changes applied; BC-3.9.003 Trace not updated for P17-003 (INFO-12, cosmetic) |
| bc-2-issue-read.md | unchanged (EC-2.7.009-1 annotation only) | consistent | P17-007 annotation applied |
| impact-boundary-576.md | four sites updated (P17-002) | consistent | All four function-name sites correct; changelog/delta track only three (INFO-11, cosmetic) |
| prd-delta-576.md | `spec_version_after: 1.3.57`; P17 fix-round section complete | consistent | Scope table S3/S5 BC-3.9.007 notes applied; all seven P17 findings APPLIED |
| BC-INDEX.md | `index_version: v6.17`; `last_updated` reflects P17 | consistent | All five touched BC rows updated; INFO-7 and INFO-10 both resolved |
| spec-changelog.md | `[1.3.57]` entry added | consistent | Impact table shows 657/98/33/v1.3.57; Changes list enumerates all P17-modified files |
| holdout-scenarios.md | version unchanged (1.5.3) | consistent | H-008/H-009 DIRECT-path fixtures correct; no fixture implies suppression; no count change |
| CANONICAL-COUNTS.md | `last_verified` cosmetically stale | cosmetically stale | Counts correct (657/98); non-blocking |
| STATE.md | live rows reflect P16 | STALE (INFO-8, carry-forward) | spec version v1.3.56 (should be v1.3.57); BC 657 / holdouts 98 / VP 33 correct |
| prd-delta-576-worklog.md | worklog discontinued as of P14 | consistent | Pointer lines verified (R26); P17 dispositions in prd-delta-576.md exclusively |

---

## Findings

### Critical

None.

### Major

None. Zero behavioral contradictions introduced. All P17 changes correctly applied.

### Minor

The following INFO-level annotation gaps remain or are newly identified; none affect behavior or block pipeline progression.

- **INFO-1** (carry-forward R21–R26): Double blank lines between EC-2.7.008-6 and EC-2.7.008-7 in `bc-2-issue-read.md`.
- **INFO-2** (carry-forward R21–R26): EC-2.7.008-2/EC-2.7.008-5 redundant pair.
- **INFO-3** (carry-forward R21–R26): BC-2.7.012 "KEY or AID 5xx" combined-scope row is correct but imprecise.
- **INFO-4** (carry-forward R22–R26): H-NEW-ATTACHMENT-003 BC refs footer does not explicitly mention "Call B2".
- **INFO-5 — RESOLVED** (P14): audit note only.
- **INFO-6** (carry-forward R23–R26): No holdout for the collision-skip exit-0 path.
- **INFO-7 — RESOLVED**: BC-INDEX.md BC-3.9.020 row correctly covers upload `--replace-existing` path (P16 micro-fix v6.15→v6.16). Confirmed from BC-INDEX.md line 392. NOTE: R26 showed as carry-forward; this report marks it resolved based on the actual BC-INDEX content.
- **INFO-8** (carry-forward R25→R27): STATE.md spec version trails at v1.3.56 (should be v1.3.57); holdouts 98 / BC 657 / VP 33 correct; burst-commit pending.
- **INFO-9 — RESOLVED** (R26): prd-delta-576-worklog.md pointer lines verified present.
- **INFO-10 — RESOLVED** (P16 micro-fix + P17): All four BC-INDEX stale surfaces resolved.
- **INFO-11** (NEW R27): spec-changelog.md and prd-delta-576.md P17-002 disposition say "three sites" but four sites in impact-boundary-576.md were actually modified (SQ-3 is the fourth). All four sites are correctly updated; tracking records undercount. Cosmetic; non-blocking.
- **INFO-12** (NEW R27): BC-3.9.003 Trace not updated for P17-003. P17-003 citation IS present in EC-3.9.003-5 body. Cosmetic; non-blocking.

---

## Validation Gate Result

**PASS**

All 30 behavioral check areas pass. Two new INFO items (INFO-11: spec-changelog/prd-delta P17-002 "three sites" undercount; INFO-12: BC-3.9.003 Trace not updated for P17-003). INFO-7 and INFO-10 resolved. Six carry-forward INFO items (INFO-1..4, INFO-6, INFO-8). Spec version 1.3.57 consistent across all active spec artifacts. Both guard scripts exit 0.

---

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 30 |
| **Passed** | 30 |
| **Resolved** | 4 (INFO-5 from R23/P14; INFO-7 from P16 micro-fix; INFO-9 from R26; INFO-10 from P16 micro-fix + P17) |
| **Failed** | 0 |
| **Warnings (INFO)** | 8 (INFO-1..4 carry-forward; INFO-6 carry-forward; INFO-8 carry-forward; INFO-11 new; INFO-12 new) |
| **Overall Status** | consistent |

Round 27 is a PATCH-level validation confirming 7 P17 adversary-pass fixes: (1) BC-3.9.014 Source corrected S5→S3 (P17-001); (2) four function-name sites aligned in impact-boundary-576.md — `upload_attachments` at §1.1/SQ-3/R3.7 and `post_request_attachment` at R2.1 (P17-002); (3) EC-3.9.003-5 Step-0 suppression on combined `--replace-existing --public` path — exactly ONE issue GET per invocation (P17-003); (4) EC-3.9.017-9 sub-variant B + BC-3.9.014 three non-interactive variants (P17-004); (5) BC-3.9.007 EC-3.9.007-1 S3/S5 allocation note + prd-delta Scope table S3/S5 notes (P17-005); (6) upload-cancel JSON row added to JSON Output Shape Contracts table (P17-006); (7) EC-2.7.009-1 annotated with `Arg::allow_negative_numbers` clap 4.6.1 verification (P17-007). Spec version advances from 1.3.56 to 1.3.57. BC count unchanged at 657; holdout count unchanged at 98; VP count unchanged at 33.

---

## Appendix: Validation Methodology

This report was produced by a fresh-context consistency validator (cv-f2-576-r27) with no visibility into prior round reports.

1. **Independent artifact read**: All ten input artifacts read fresh. Findings formed before cross-referencing the P17 disposition table in prd-delta-576.md.
2. **Quote-based closure**: Every P17 priority check verified by verbatim quotation from the authoritative artifact.
3. **Residual-name scan**: Explicit grep for `attach_to_request` and singular `upload_attachment(` in impact-boundary-576.md — zero results. Four P17-002 sites confirmed with annotations.
4. **Message-variant symmetry**: All six messages (three interactive, three non-interactive) quoted verbatim; 1:1 trigger mapping verified.
5. **Step-0 suppression audit**: EC-3.9.003-5 suppression clause verified; BC-3.9.017 step 4 gate-suppression wording checked; H-008/H-009 fixtures verified as DIRECT BC-3.9.003 paths where Step 0 IS executed (no suppression implied); BC-3.9.012 404 row coherence verified.
6. **Keystone checks**: K-1 (BC-3.9.014 S3 ownership coherence), K-2 (variant symmetry + EC-3.9.003-7 precedence), K-3 (Step-0 suppression + ONE issue GET + BC-3.9.012 compatibility), K-4 (BC-INDEX v6.17 rows vs five BC bodies).
7. **Guard scripts**: Both `check-spec-counts.sh` and `check-bc-cumulative-counts.sh` executed and verified "OK".
8. **Count sweep**: BC (657), holdout (98), VP (33) verified across all relevant surfaces.
9. **INFO ledger**: Each carry-forward and new INFO item individually verified; INFO-7 resolved (actual BC-INDEX content correct despite R26 carry-forward notation); INFO-10 resolved.
10. **STATE.md**: Live status rows confirmed stale on spec version only (v1.3.56 vs v1.3.57); holdouts (98), BC (657), VP (33) correct.
