---
document_type: consistency-report
level: ops
version: "6.0"
status: GAPS-FOUND
producer: consistency-validator
timestamp: 2026-07-15T00:00:00
feature: SOH-ATTACHMENTS-1
issues: "#576, #585"
phase: F2
authored: 2026-07-15
reviewer_role: consistency-validator
spec_version: 1.3.45
verdict: GAPS-FOUND
total_findings: 5
new_findings: 5
critical: 0
high: 0
medium: 0
low: 3
info: 2
r1_findings_reviewed: 7
r1_findings_resolved: 7
r2_findings_reviewed: 5
r2_findings_resolved: 5
r3_findings_reviewed: 2
r3_findings_resolved: 2
r4_findings_reviewed: 3
r4_findings_resolved: 3
r5_findings_reviewed: 1
r5_findings_resolved: 1
blocking_gaps: 0
inputs:
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/cross-cutting.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/specs/prd/CANONICAL-COUNTS.md"
  - ".factory/spec-changelog.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576-worklog.md"
  - ".factory/phase-f2-spec-evolution/security-review-576.md"
  - ".factory/phase-f1-delta-analysis/impact-boundary-576.md"
  - ".factory/research/issue-576-attachments-api-2026-07-15.md"
  - ".factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md"
  - ".factory/specs/architecture/ARCH-INDEX.md"
  - ".factory/architecture/adr-index.md"
traces_to: ".factory/phase-f2-spec-evolution/prd-delta-576.md"
---

# Consistency Report: SOH-ATTACHMENTS-1 F2 Spec Package (spec v1.3.45) — Round 6

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) |
| **Generated** | 2026-07-15 |
| **Generator** | consistency-validator (fresh context; findings formed before reading prior rounds) |
| **Artifacts Scanned** | 15 (all surface-set items specified in task brief, plus holdout-scenarios.md) |
| **Spec Version** | v1.3.45 (post-adversary-pass-1 rounds A+B state: +20 corrections + 6 new BCs + 7 new holdouts) |
| **Feature** | SOH-ATTACHMENTS-1 (issues #576 + #585) |
| **Gate** | DEC-179 F2 spec bundle — round 6 after r5 CONSISTENT verdict |

**Review methodology**: Independent fresh-context read of all surface-set artifacts BEFORE
consulting consistency-report-576-r1.md through r5.md. Independent findings formed first.
Prior reports consulted only for the two required spot-checks: CONS-576-001 (algorithm
fidelity, MEDIUM in r1) and NEW-R4-002 (ADR count 16→17, EXPECTED-OPEN in r4).

**Verdict: GAPS-FOUND** — 3 LOW findings and 2 INFO findings. No CRITICAL, HIGH, or MEDIUM
findings. All findings are cosmetic/documentation issues; none block story decomposition.

---

## Summary

| # | Check | Result |
|---|-------|--------|
| 1 | BC-3.9.015..020 vs impact-boundary Revision 3 | PASS (with INFO: §5.1) |
| 2 | Delete-family BC cross-BC coherence (3.9.008/010/013/015/016/019/020) | PASS (with LOW: Finding 3) |
| 3 | Round-A corrections vs round-B additions contradiction check | PASS |
| 4 | Holdout scenarios reference only specified BC behaviors | PASS |
| 5 | Count surfaces — all 8 scripted + headers | GAPS-FOUND (Finding 1: Section 3.9 header) |
| 6 | JSON Output Shape Contracts table completeness for round-B shapes | GAPS-FOUND (Finding 2) |
| 7 | Stale status markers | PASS |
| — | Prior-finding closure (r5 spot-checks: CONS-576-001, NEW-R4-002) | PASS — BOTH RESOLVED |
| — | ADR count (CANONICAL-COUNTS §ADRs) | PASS — 17 confirmed |
| — | BC-INDEX body-note enumeration (NEW-R5-001) | PASS — RESOLVED in round B |

---

## 1. BC-3.9.015..020 vs Impact-Boundary Revision 3

### 1.1 R3.2 Bulk `--yes` mandate

BC-3.9.016 (bulk `--older-than` always requires `--yes`): R3 requires "bulk operations
should require explicit `--yes`; missing `--yes` → exit 64." BC-3.9.016 body specifies:
"exit 64 immediately; no API calls; stderr: `"--older-than requires --yes to confirm bulk
deletion."` (load-bearing canonical string)". R3 matched. ✓

### 1.2 R3.3 Dry-run `--yes` exemption

BC-3.9.016 EC-3.9.016-3: "dry-run permitted without `--yes`; no mutations; BC-3.9.020
output shape." R3 says "`--dry-run` previews without mutating." Matched. ✓

### 1.3 R3.4 Mutual-exclusion between positional-AID and `--issue`/`--older-than`

BC-3.9.016 specifies the "clap mutual-exclusion between positional-AID form and
`--issue`/`--older-than`" and EC-3.9.016-4 maps "positional AID + `--issue` or
`--older-than`" → clap exit 2. R3.4 says "clap should enforce mutual exclusion." Matched. ✓

### 1.4 R3.5 Non-atomicity language in BC-3.9.017

R3 requires: "The spec MUST document the race and must NOT assert atomicity." BC-3.9.017
has EC-3.9.017-7: "non-atomic race — concurrent upload between delete and upload: accepted
documented limitation; no retry; no error emitted." Non-atomicity explicitly documented. ✓

### 1.5 R3.5 duration.rs tie in BC-3.9.019

R3: "uses the existing `src/duration.rs` parser conventions (e.g., `7d`, `2w`, `1M`) —
same family as `worklog add --duration`." BC-3.9.019 body uses exactly this language and
cites `src/duration.rs`. Matched. ✓

### 1.6 R3.3 Metadata-fetch-GET pre-prompt in BC-3.9.015

R3 specifies the interactive delete prompt shows `"Delete attachment <filename> (<id>)?
[y/N]"`. BC-3.9.015 specifies the metadata fetch via `GET /rest/api/3/attachment/{id}`
before the prompt. See INFO finding NEW-R6-005: this endpoint is not in the F1 impact-
boundary function table, but the BC body is internally correct.

---

## 2. Delete-Family Cross-BC Coherence (BC-3.9.008/010/013/015/016/019/020)

### 2.1 State machine for single-ID delete

| Step | BC | Behavior |
|------|-----|---------|
| Pre-prompt metadata GET | BC-3.9.015 | `GET /rest/api/3/attachment/{id}` → filename for prompt |
| Interactive gate | BC-3.9.015 | `eprint!+read_line` (DEC-174); `--yes` bypasses; non-TTY exit 64 |
| Cancel path | BC-3.9.015 | exit 0; JSON `{"cancelled":true,"deleted":false}` |
| Wire DELETE | BC-3.9.008 | `DELETE /rest/api/3/attachment/{id}`; 204 = exit 0 |
| 404 on DELETE | BC-3.9.008 | exit 64 + surface Jira body (DEC-168; NOT exit 0) |
| JSON success | BC-3.9.010 | `{"deleted":true,"id":"<AID>"}` (BTreeMap-ordered) |
| Error taxonomy | BC-3.9.013 | 401/403/5xx per standard exits |

This forms a consistent state machine. ✓

### 2.2 State machine for bulk `--older-than` delete

| Step | BC | Behavior |
|------|-----|---------|
| `--yes` gate | BC-3.9.016 | missing `--yes` → exit 64 (unless `--dry-run`) |
| `--dry-run` exemption | BC-3.9.016, BC-3.9.020 | read-only; no mutations; `--yes` not required |
| Duration parse | BC-3.9.019 | `src/duration.rs`; invalid → exit 64 |
| `created` comparison | BC-3.9.019 | client-side via `chrono`; malformed → skip+warn |
| Wire DELETEs | BC-3.9.008 (per call) | serial; partial failure → stop + error JSON |
| JSON bulk success | BC-3.9.010 / BC-3.9.019 | **INCONSISTENCY: see NEW-R6-003 below** |
| JSON dry-run | BC-3.9.020 | **MISSING from Contracts table: see NEW-R6-002 below** |

Cross-BC coherence is sound at the behavioral level. There is a documentation inconsistency
in JSON key ordering (Finding 3) and a missing Contracts table entry (Finding 2).

### 2.3 Mutual-exclusion guards

| Pair | Guard | BC |
|------|-------|-----|
| positional-AID + `--issue` | clap exit 2 | BC-3.9.016 EC-3.9.016-4 |
| positional-AID + `--older-than` | clap exit 2 | BC-3.9.016 EC-3.9.016-4 |
| `--older-than` without `--issue` | exit 64 (see INFO below) | BC-3.9.016 EC-3.9.016-5 |
| `--dry-run` + single-ID | stderr hint + exit 0 (no-op) | BC-3.9.020 EC-3.9.020-3 |
| `--dry-run` + `--yes` | `--dry-run` governs; no mutations | BC-3.9.020 EC-3.9.020-5 |

All guards present. ✓ (Exit-code ambiguity between BC-3.9.016 and BC-3.9.019 noted as
NEW-R6-004 INFO below.)

---

## 3. Round-A Corrections vs Round-B Additions

### 3.1 ADV-012 (selector-required) vs round-B new flags

ADV-012 corrected BC-2.7.007 to specify that `jr issue attachment download <KEY>` without
any selector (`--id`, `--all`, `--newest`) is rejected by clap. Round-B flags (`--dry-run`,
`--yes`) apply to the DELETE subcommand, not the download subcommand. Zero interaction. ✓

### 3.2 ADV-021 (error-string normalization) vs BC-3.9.019 partial-failure

ADV-021 normalized error strings in existing BCs. BC-3.9.019 EC-3.9.019-7 (partial DELETE
failure mid-sequence) delegates to "JrError error shape" and references BC-3.9.010 EC-
3.9.010-4 for the stop-on-first-failure behavior. No new canonical error string introduced
in BC-3.9.019 that conflicts with ADV-021 normalization. ✓

### 3.3 ADV-009/010 (214-byte UTF-8 truncation) vs round-B

Round-A corrections to BC-2.7.011 (214-byte UTF-8-safe truncation; `floor_char_boundary`
semantics) are limited to the download and sanitization scope. Round B adds delete/upload
BCs only. Zero interaction. ✓

### 3.4 ADV-002 (delete signature) vs BC-3.9.015/016

ADV-002 confirmed `attachment delete <AID>` as a bare positional (no `--issue KEY` required
for single delete; per OQ-7/R3.4). BC-3.9.015 operates on the `<AID>` positional form.
BC-3.9.016 specifies `--issue <KEY>` is required for the `--older-than` form. These are
consistent with the ADV-002 ruling. ✓

---

## 4. Holdout Scenarios — BC Reference Validity

### 4.1 Group 19 BC references

| Scenario | Primary BC refs | All BCs present? |
|----------|----------------|-----------------|
| H-NEW-ATTACHMENT-001 | BC-2.7.001 (list table) | YES ✓ |
| H-NEW-ATTACHMENT-002 | BC-2.7.007 (write-to-temp + atomic rename) | YES ✓ |
| H-NEW-ATTACHMENT-003 | BC-2.7.008, BC-2.7.010, BC-2.7.011 | YES ✓ |
| H-NEW-ATTACHMENT-004 | BC-3.9.001, BC-3.9.017, BC-3.9.018 | YES ✓ |
| H-NEW-ATTACHMENT-005 | BC-3.9.015 | YES ✓ |
| H-NEW-ATTACHMENT-006 | BC-3.9.016, BC-3.9.019, BC-3.9.020 | YES ✓ |
| H-NEW-ATTACHMENT-007 | BC-2.7.011, BC-2.7.008, BC-2.7.010 | YES ✓ |

No holdout scenario references a non-existent BC. ✓

### 4.2 Asymmetry check (BCs must NOT reference holdouts)

A spot-check of BC bodies in Section 2.7 and Section 3.9 found no back-references to
holdout scenario IDs (H-NEW-ATTACHMENT-NNN or H-NNN). Asymmetry invariant maintained. ✓

### 4.3 Holdout count surface

`holdout-scenarios.md` frontmatter and prd-delta-576.md agree: `holdout_count_after: 95`
(was 88 before round B; +7 H-NEW-ATTACHMENT-001..007). CANONICAL-COUNTS.md Group count
enumeration includes Group 19. ✓

---

## 5. Count Surfaces

### 5.1 Scripted surfaces (8 guarded by `scripts/check-bc-cumulative-counts.sh`)

| Surface | Expected | Observed | Status |
|---------|---------|---------|--------|
| `bc-2-issue-read.md` frontmatter `total_bcs` | 106 | 106 | ✓ |
| `bc-2-issue-read.md` frontmatter `definitional_count` | 64 | 64 | ✓ |
| `bc-3-issue-write.md` frontmatter `total_bcs` | 140 | 140 | ✓ |
| `bc-3-issue-write.md` frontmatter `definitional_count` | 111 | 111 | ✓ |
| `cross-cutting.md` frontmatter `total_bcs` | 150 | 150 | ✓ |
| `cross-cutting.md` frontmatter `definitional_count` | 84 | 84 | ✓ |
| `BC-INDEX.md` frontmatter `total_bcs` | 657 | 657 | ✓ |
| `CANONICAL-COUNTS.md` per-file Sum | 657 | 657 | ✓ |

### 5.2 Section headers and body footers (9th unguarded surface)

| Location | Expected | Observed | Status |
|----------|---------|---------|--------|
| `BC-INDEX.md` Section 2.7 header | "(12 BCs: BC-2.7.001..012)" | "(12 BCs: BC-2.7.001..012)" | ✓ |
| `BC-INDEX.md` Section 3.9 header | "(20 BCs: BC-3.9.001..020)" | "(20 BCs: BC-3.9.001..020)" | ✓ |
| `BC-INDEX.md` Section X.8 header | "(10 BCs: BC-X.8.001..010)" | "(10 BCs: BC-X.8.001..010)" | ✓ |
| `bc-3-issue-write.md` Section 3.9 header | "(20 BCs: BC-3.9.001..020)" | "(14 BCs: BC-3.9.001..BC-3.9.014)" | **GAP** → NEW-R6-001 |
| `bc-3-issue-write.md` footer | "111 individually-bodied (cumulative 140…)" | "111 individually-bodied (cumulative 140…)" | ✓ |
| `bc-2-issue-read.md` footer | "64 individually-bodied (cumulative 106…)" | "64 individually-bodied (cumulative 106…)" | ✓ |
| `BC-INDEX.md` Coverage Statistics body-note | Includes "+6 BC-3.9.015..020" | Includes "+6 BC-3.9.015..020" | ✓ (NEW-R5-001 RESOLVED) |

### 5.3 prd-delta-576.md frontmatter

| Field | Expected | Observed | Status |
|-------|---------|---------|--------|
| `spec_version_after` | 1.3.45 | 1.3.45 | ✓ |
| `bc_count_after` | 657 | 657 | ✓ |
| `holdout_count_after` | 95 | 95 | ✓ |

### 5.4 ADR count (NEW-R4-002 closure verification)

`CANONICAL-COUNTS.md` §ADRs: "**Canonical ADR count: 17** (ADR-0001..ADR-0017; all present,
no gaps)" — with ADR-0017 explicitly listed. NEW-R4-002 RESOLVED. ✓

---

## 6. JSON Output Shape Contracts Table

The JSON Output Shape Contracts table in `bc-3-issue-write.md` (approximately line 3207)
contains these entries as of the r5 state (v1.3.44):

| Shape | Source BC | In table? |
|-------|-----------|-----------|
| `attachment upload` (platform POST path) | BC-3.9.009 | YES ✓ |
| `attachment delete` (single AID) | BC-3.9.010 | YES ✓ |
| `attachment delete` (bulk AIDs) | BC-3.9.010 | YES ✓ |
| `attachment upload --public` (deferred P2-3c) | BC-3.9.011 | YES ✓ (marked TBD) |

Round B (v1.3.45) introduced these new output shapes that are NOT in the table:

| Shape | Source BC | In table? |
|-------|-----------|-----------|
| `attachment delete` cancel `{"cancelled":true,"deleted":false}` | BC-3.9.015 | **NO** → NEW-R6-002 |
| `attachment delete --dry-run` `{"dryRun":true,"ids":[...],"attachments":[...]}` | BC-3.9.020 | **NO** → NEW-R6-002 |

The dry-run shape is a first-class output mode (not an error, not a cancel) and belongs in
the Contracts table. The cancel-delete shape (`{"cancelled":true,"deleted":false}`) is
parallel to the cancel-upload shape (`{"cancelled":true,"uploaded":false}`) from BC-3.9.014
— the upload cancel was not added to the table at v1.3.43 either, which was not flagged
in prior rounds (upload cancel was considered analogous to `comment edit --public` cancel
which also lacks a Contracts table entry). The dry-run shape is a stronger case for table
inclusion since it is a non-cancellation, non-error output mode with distinct keys not
covered by any existing row.

---

## 7. Stale Status Markers

| Artifact | Check | Result |
|----------|-------|--------|
| `security-review-576.md` frontmatter | `status: final`, `verdict: APPROVE` | ✓ (per r5 spot-check; no changes in round B scope) |
| `impact-boundary-576.md` §R2.2 retro-annotation (CONS-576-006) | PHASE-DOC-RETRO-ANNOTATION present | ✓ |
| `impact-boundary-576.md` §R2.3 retro-annotation (NEW-005) | PHASE-DOC-RETRO-ANNOTATION present | ✓ |
| `spec-changelog.md` [1.3.43] ADR reference | "ADR-0017 Accepted 2026-07-15" | ✓ |
| `prd-delta-576.md` Scope Note | Marked DELIVERED round B | ✓ |
| `bc-3-issue-write.md` Section 3.9 header | Should show 20 BCs | **STALE** → NEW-R6-001 |
| `CANONICAL-COUNTS.md` §ADRs | 17 (was EXPECTED-OPEN "16" in r4) | ✓ RESOLVED |

---

## Prior-Finding Closure Table

### CONS-576-001..007 (R1) — All RESOLVED (unchanged from r5)

All 7 RESOLVED per r5 verification. ✓ No round-A or round-B change touches BC-2.7.011 body
in a way that would revert any of these. Spot-check of CONS-576-001 (algorithm fidelity)
performed independently — see §10 below.

### NEW-001..005 (R2) — All RESOLVED (unchanged from r5)

✓ No changes in round B scope affect any of these findings.

### NEW-R3-001..002 (R3) — All RESOLVED (unchanged from r5)

✓ Unchanged.

### NEW-R4-001..003 (R4)

| Finding | r5 Status | r6 Status |
|---------|----------|----------|
| NEW-R4-001 — bc-2 footer pre-F2 counts | RESOLVED | RESOLVED ✓ |
| NEW-R4-002 — CANONICAL-COUNTS ADR count 16 vs 17 | EXPECTED-OPEN | **RESOLVED** — CANONICAL-COUNTS.md §ADRs now reads "Canonical ADR count: 17" with ADR-0017 listed. |
| NEW-R4-003 — bc-3 footer history note stale | RESOLVED | RESOLVED ✓ |

### NEW-R5-001 (R5) — RESOLVED

BC-INDEX.md Coverage Statistics body-note (line 794) now includes all three entries that
were missing at r5:
- "+11 BC-3.5.002..BC-3.5.012 added 2026-07-11..14 via DEC-168 comment delete/edit/view"
- "+27 SOH-ATTACHMENTS-1 F2 added 2026-07-15 via DEC-179 issues #576 #585"
- "+6 BC-3.9.015..020 added 2026-07-15 via SOH-ATTACHMENTS-1 adversary pass-1 round B
  scope expansion ruling R1/R2"

NEW-R5-001 RESOLVED. ✓

**All 18 prior findings fully accounted for. 18 RESOLVED. 0 EXPECTED-OPEN (NEW-R4-002
resolved in round B). Zero residual from prior rounds.**

---

## Findings

### Critical

None.

### Major (HIGH)

None.

### Minor (MEDIUM)

None.

### Minor (LOW)

---

**NEW-R6-001 — LOW — `bc-3-issue-write.md` Section 3.9 header is stale at "(14 BCs)" after
round B added 6 new BCs**

**Location**: `bc-3-issue-write.md`, line 3215.

**Finding**: The section header reads:
```
### 3.9 Attachment Write (14 BCs: BC-3.9.001..BC-3.9.014)
```
After round B added BC-3.9.015..020, this header should read:
```
### 3.9 Attachment Write (20 BCs: BC-3.9.001..BC-3.9.020)
```

The BC-INDEX.md Section 3.9 header (line 369) correctly reads "(20 BCs: BC-3.9.001..020)".
The bc-3-issue-write.md footer (line 3768) correctly says "Section 3.9 now 20 contracts."
The prd-delta-576-worklog.md (line 289) records "Section 3.9 header 14→20" as a round-B
change. The section header itself was not updated.

**Evidence of worklog intent**: prd-delta-576-worklog.md §Round B: "`bc-3-issue-write.md`
| frontmatter total_bcs 134→140 ... Section 3.9 header 14→20 ..."

**Impact**: A reader who looks at the Section 3.9 header to count BCs in scope will see 14,
not 20, and may miss the 6 new round-B BCs. Automated guards (`check-bc-cumulative-counts.sh`)
operate on frontmatter, not section headers, so this gap is undetected by CI.

**Action**: Update line 3215 of `bc-3-issue-write.md`:
- FROM: `### 3.9 Attachment Write (14 BCs: BC-3.9.001..BC-3.9.014)`
- TO: `### 3.9 Attachment Write (20 BCs: BC-3.9.001..BC-3.9.020)`

**Priority**: Pre-story-decomposition fix (burst close).

---

**NEW-R6-002 — LOW — JSON Output Shape Contracts table missing round-B output shapes
(dry-run, cancel-delete)**

**Location**: `bc-3-issue-write.md`, JSON Output Shape Contracts table (~line 3207).

**Finding**: Round B introduced two new JSON output shapes that are not in the Contracts
table:

1. **Delete cancel shape** (BC-3.9.015 EC-3.9.015-2):
   `{"cancelled":true,"deleted":false}` — emitted when user cancels at the interactive gate.
   Key ordering: BTreeMap alphabetical `cancelled`(c) < `deleted`(d) → correct as shown.

2. **Dry-run preview shape** (BC-3.9.020 EC-3.9.020-2):
   `{"dryRun":true,"ids":[],"attachments":[]}` (zero-match) /
   `{"dryRun":true,"ids":[...],"attachments":[{id,filename}]}` (N > 0)
   This is a first-class output mode — not an error, not a cancel — and should be
   catalogued in the Contracts table alongside the existing delete shapes.
   (Note: key ordering inconsistency in this shape is separately flagged in NEW-R6-003.)

The upload-cancel shape (`{"cancelled":true,"uploaded":false}` from BC-3.9.014) was also
not added to the table at v1.3.43, but this was not flagged in prior rounds (consistent
omission of cancel shapes from the Contracts table). The dry-run shape is a stronger case
for inclusion because it is a unique non-cancel, non-error output mode.

**Impact**: Story authors and test writers cannot use the Contracts table as a complete
reference for all `--output json` shapes from attachment commands. They must read individual
BC bodies. The risk is that snapshot tests for dry-run are omitted or written incorrectly.

**Suggested table additions:**
| `attachment delete` (cancel path) | `{"cancelled":true,"deleted":false}` | 2 keys alphabetical; BC-3.9.015 |
| `attachment delete --dry-run` (N > 0) | `{"attachments":[{id,filename}],"dryRun":true,"ids":[...]}` | 3 keys BTreeMap order; BC-3.9.020 |

**Priority**: Pre-story-decomposition fix (burst close).

---

**NEW-R6-003 — LOW — BC-3.9.019 and BC-3.9.020 JSON shapes show keys in non-BTreeMap
order, inconsistent with BC-3.9.010's established ordering convention**

**Location**: `bc-3-issue-write.md` BC-3.9.019 body, BC-3.9.020 body (EC-3.9.020-2), and
BC-INDEX rows for both BCs.

**Finding**: BC-3.9.010 defines bulk-delete JSON as `{"count":N,"deleted":true,"ids":[...]}`
with an explicit "BTreeMap-ordered keys" annotation (alphabetical: count < deleted < ids).

BC-3.9.019 shows: `{"deleted":true,"count":N,"ids":[...]}` — `deleted` before `count`.
This is the SAME shape as BC-3.9.010 but with a different display order. BTreeMap
alphabetical would place `count`(c) before `deleted`(d). BC-3.9.019 inverts this.

BC-3.9.020 shows: `{"dryRun":true,"ids":[],"attachments":[]}` — `dryRun` before
`attachments`. BTreeMap alphabetical: `attachments`(a) < `dryRun`(d) < `ids`(i) →
correct BTreeMap shape is `{"attachments":[...],"dryRun":true,"ids":[...]}`.

The inconsistency is documentation-only: `output::render_json` uses BTreeMap serialization
and will produce alphabetical key order at runtime regardless of how the BC body describes
the shape. However, a test author who writes a snapshot assertion based on the BC-3.9.019
or BC-3.9.020 body text directly will write a failing test.

**Impact**: Test authors reading BC-3.9.019/020 in isolation, without awareness of the
BTreeMap convention, may write incorrect snapshot assertions. This does not block
story decomposition but should be corrected before story authors begin writing test cases.

**Required corrections:**

BC-3.9.019 (wherever the bulk shape is stated): change from
`{"deleted":true,"count":N,"ids":[...]}` to `{"count":N,"deleted":true,"ids":[...]}` —
matching BC-3.9.010's BTreeMap-ordered canonical form.

BC-3.9.020 EC-3.9.020-1, EC-3.9.020-2 (and wherever the dry-run shape is stated):
change from `{"dryRun":true,"ids":[...],"attachments":[...]}` to
`{"attachments":[...],"dryRun":true,"ids":[...]}` — BTreeMap alphabetical order.

**Priority**: Pre-story-decomposition fix (burst close).

---

### INFO

---

**NEW-R6-004 — INFO — Exit-code ambiguity for `--older-than` without `--issue`: BC-3.9.016
says exit 64, BC-3.9.019 says "exit 64 (or clap exit 2)"**

**Location**: `bc-3-issue-write.md` BC-3.9.016 EC-3.9.016-5 and BC-3.9.019 EC-3.9.019-4.

**Finding**:
- BC-3.9.016 EC-3.9.016-5: "`--older-than` without `--issue`): exit 64; stderr
  `"--older-than requires --issue <KEY>"`"
- BC-3.9.019 EC-3.9.019-4: "`--older-than` without `--issue`): exit 64 (or clap exit 2);
  `"--older-than requires --issue <KEY>"`"

BC-3.9.016 is definitive (exit 64 only). BC-3.9.019 hedges with a parenthetical "or clap
exit 2", acknowledging implementation uncertainty about whether this validation is done by
clap (which would produce exit 2 with a usage hint) or the handler (exit 64 with the
specified message). The two BCs describe the same failure mode but with different exit-code
specificity.

**Impact**: Low — the canonical string `"--older-than requires --issue <KEY>"` is present
in both, and the behavioral outcome (no API calls, error message on stderr) is the same.
Exit-code difference is only observable by callers scripting on exact exit codes.

**Action**: At story S4 authoring time, choose one: either clap enforces the dependency
(exit 2, no message customization) or the handler enforces it (exit 64, canonical message).
Then update BC-3.9.016 and BC-3.9.019 to agree. Either choice is valid; the spec should
not leave this ambiguous for the implementer.

**Priority**: Burst close or story authoring (non-blocking).

---

**NEW-R6-005 — INFO — Impact-boundary §1.1 function table does not include
`get_attachment_metadata(client, aid)` required by BC-3.9.015**

**Location**: `impact-boundary-576.md` §1.1, `src/api/jira/attachments.rs` function table.

**Finding**: BC-3.9.015 requires a pre-prompt metadata fetch to display the filename in
the confirmation prompt: "Metadata-fetch failure: if the pre-prompt
`GET /rest/api/3/attachment/{id}` returns 404, exit 64 immediately."

The impact-boundary §1.1 `src/api/jira/attachments.rs` function table lists four functions:
- `list_attachments` — GET /rest/api/3/issue/{key}?fields=attachment
- `get_attachment_content` — GET /rest/api/3/attachment/content/{id}
- `upload_attachment` — POST /rest/api/3/issue/{key}/attachments
- `delete_attachment` — DELETE /rest/api/3/attachment/{id}

There is no `get_attachment_metadata(client, aid) → GET /rest/api/3/attachment/{id}` entry.
This endpoint is required by BC-3.9.015's pre-prompt metadata fetch.

**Context**: The Jira REST API v3 `GET /rest/api/3/attachment/{id}` returns attachment
metadata without content (an AttachmentMeta object). It is distinct from the content
endpoint. This requirement was introduced by R3.3's confirmation-gate ruling, after the F1
impact-boundary was written. Because `--issue KEY` is not required for single-ID delete
(per OQ-7/R3.4), the filename for the prompt can only be obtained via this dedicated
metadata endpoint. The F1 impact-boundary is a read-only analysis artifact — its function
table cannot be updated at this stage.

**Impact**: S4 implementer must add `get_attachment_metadata(client, aid)` to
`src/api/jira/attachments.rs`. This is not a blocker (the function is a simple GET) but
it is engineering scope not captured in the F1 boundary.

**Action**: Story S4 plan should explicitly add `get_attachment_metadata` to the new-files
scope for `src/api/jira/attachments.rs`.

**Priority**: Story S4 authoring (non-blocking).

---

## Spot-Check Verification (Required by Task Brief)

### CONS-576-001 (MEDIUM in r1) — Algorithm fidelity of BC-2.7.011 sanitization

**Status: REMAINS RESOLVED** at v1.3.45.

Independent verification of BC-2.7.011 body:
- Step 5 (length cap): "truncate to at most **214 bytes** on a valid UTF-8 character boundary
  (Rust `floor_char_boundary` semantics — never split a multi-byte codepoint)" ✓
- Step 5.5 (trailing-whitespace/dot strip): present (SEC-576-007) ✓
- SEC-576-002 two-step containment procedure: "`canonicalize(out_dir)` then
  `Path::starts_with(&resolved_dir)`" — NOT `canonicalize()` on the joined path ✓
- SEC-576-001 Windows device-name caller note: present ✓
- Combined length arithmetic (41 + 214 = 255): present ✓

Round A corrections to bc-3-issue-write.md (ADV-009/010: "214-byte UTF-8 truncation")
corrected only downstream BCs (BC-3.9.001 or related upload/download bodies that cite
BC-2.7.011's algorithm). BC-2.7.011 body itself was already corrected in v1.3.44 (round A
of the security fix pass, SEC-576-002). No round-A or round-B change reverted any of these.
CONS-576-001 **REMAINS RESOLVED**. ✓

### NEW-R4-002 (EXPECTED-OPEN in r4/r5) — CANONICAL-COUNTS ADR count

**Status: NOW RESOLVED** at v1.3.45.

CANONICAL-COUNTS.md §ADRs (line 157): "**Canonical ADR count: 17** (ADR-0001..ADR-0017;
all present, no gaps)" — ADR-0017 explicitly listed as "First multipart/streaming HTTP
surface — reqwest multipart+stream features + tokio-util direct dependency (SOH-ATTACHMENTS-1
F2 DEC-179, 2026-07-15)". ARCH-INDEX.md and adr-index.md both reflect ADR-0017 Accepted.
NEW-R4-002 **RESOLVED**. ✓

---

## BC Counts Across All Authoritative Surfaces

| Surface | Value | Status |
|---------|-------|--------|
| `bc-2-issue-read.md` frontmatter `total_bcs` | 106 | ✓ |
| `bc-2-issue-read.md` frontmatter `definitional_count` | 64 | ✓ |
| `bc-3-issue-write.md` frontmatter `total_bcs` | 140 | ✓ |
| `bc-3-issue-write.md` frontmatter `definitional_count` | 111 | ✓ |
| `bc-3-issue-write.md` Section 3.9 header | 20 | **14 (stale) → NEW-R6-001** |
| `cross-cutting.md` frontmatter `total_bcs` | 150 | ✓ |
| `cross-cutting.md` frontmatter `definitional_count` | 84 | ✓ |
| `BC-INDEX.md` frontmatter `total_bcs` | 657 | ✓ |
| `BC-INDEX.md` Section 3.9 header | 20 | ✓ |
| `BC-INDEX.md` Coverage Statistics body-note | includes "+6 round B" | ✓ (NEW-R5-001 RESOLVED) |
| `CANONICAL-COUNTS.md` per-file Sum | 657 | ✓ |
| `CANONICAL-COUNTS.md` grand total | 657 | ✓ (round B +6 noted at line 66) |
| `prd-delta-576.md` `spec_version_after` | 1.3.45 | ✓ |
| `prd-delta-576.md` `bc_count_after` | 657 | ✓ |
| `prd-delta-576.md` `holdout_count_after` | 95 | ✓ |
| `CANONICAL-COUNTS.md` §ADRs | 17 | ✓ (NEW-R4-002 RESOLVED) |

---

## Spec vs Implementation Drift

All attachment BCs (BC-2.7.001..012, BC-3.9.001..020, BC-X.8.010) cite `(pending S1..S5)`
source files that do not yet exist in `src/`. No implementation exists at this stage.
This is expected at F2 pre-implementation phase. No spec-vs-implementation drift.

---

## Validation Gate Result

**GAPS-FOUND** — 3 LOW findings and 2 INFO findings:
- **NEW-R6-001** (LOW): Section 3.9 header stale at "14 BCs" — fix: update to "20 BCs".
- **NEW-R6-002** (LOW): JSON Output Shape Contracts table missing dry-run and cancel-delete shapes.
- **NEW-R6-003** (LOW): BC-3.9.019 and BC-3.9.020 JSON shapes in non-BTreeMap key order.
- **NEW-R6-004** (INFO): exit-code ambiguity for `--older-than` without `--issue` between two BCs.
- **NEW-R6-005** (INFO): impact-boundary §1.1 missing `get_attachment_metadata` function.

None of these findings block story decomposition. All 3 LOW findings are documentation
corrections that should be applied at burst close before story authors begin writing
snapshot tests.

**Recommended resolution at burst close (in priority order):**
1. **NEW-R6-001** — `bc-3-issue-write.md` Section 3.9 header: `14 BCs` → `20 BCs`.
2. **NEW-R6-003** — Correct JSON key ordering in BC-3.9.019 (bulk shape) and BC-3.9.020
   (dry-run shape) to BTreeMap alphabetical order, matching BC-3.9.010's convention.
3. **NEW-R6-002** — Add dry-run shape row to JSON Output Shape Contracts table; optionally
   add cancel-delete shape row.
4. **NEW-R6-004** — Settle exit-code (64 vs 2) for `--older-than` without `--issue` before
   S4 story authoring; update both BC-3.9.016 and BC-3.9.019 to agree.
5. **NEW-R6-005** — S4 story plan: add `get_attachment_metadata(client, aid)` to the
   `src/api/jira/attachments.rs` engineering scope.

---

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 20 (standard pipeline + ops-specific round-B priority checks) |
| **Passed** | 15 |
| **Failed (blocking)** | 0 |
| **Gaps Found** | 5 (3 LOW, 2 INFO) |
| **Expected Open** | 0 |
| **Prior Findings Closed** | 18 of 18 (all CONS-576-001..007, NEW-001..005, NEW-R3-001..002, NEW-R4-001..003, NEW-R5-001 RESOLVED) |
| **Overall Status** | GAPS-FOUND (3 cosmetic LOW items + 2 INFO items; no blocking gaps) |

---

## Positive Consistency Confirmations

**New BCs 3.9.015..020 vs impact-boundary R3** — All 6 round-B BCs correctly implement
the R3.2 bulk-`--yes` mandate, R3.3 dry-run exemption, R3.3 mutual-exclusion, R3.4 delete
signature, R3.5 non-atomicity language, R3.5 duration.rs tie, and R3.3 metadata-fetch-GET
prompt. ✓

**Delete-family state machine coherence** — BC-3.9.008/010/013/015/016/019/020 form a
consistent state machine. Single-ID confirmation gate (BC-3.9.015) → wire (BC-3.9.008) →
JSON (BC-3.9.010). Bulk gate (BC-3.9.016) → duration filter (BC-3.9.019) → same wire
(BC-3.9.008) → bulk JSON (BC-3.9.010 shared shape). Dry-run path (BC-3.9.020) → no
mutation → preview JSON. All error taxonomy references consistent. ✓

**Round-A vs round-B no contradictions** — ADV-012 (selector-required on download) does
not interact with round-B delete flags. ADV-021 (error-string normalization) does not
conflict with BC-3.9.019 partial-failure delegation to BC-3.9.010. ADV-002 (delete
signature = ID-only positional) is reinforced by BC-3.9.016's mutual-exclusion design. ✓

**Holdout scenarios (Group 19) — all 7 scenarios reference only existing BCs** ✓

**BC-INDEX body-note completeness (NEW-R5-001) — RESOLVED** — All three missing additions
(+11 SOH-COMMENT-CRUD-1, +27 SOH-ATTACHMENTS-1 F2, +6 round B) now present in the note. ✓

**CANONICAL-COUNTS §ADRs (NEW-R4-002) — RESOLVED** — ADR count = 17. ✓

**CONS-576-001 algorithm fidelity — REMAINS RESOLVED** — BC-2.7.011 body has the correct
5.5-step sanitization algorithm with 214-byte UTF-8-safe cap, step 5.5 trailing-whitespace/
dot strip, and SEC-576-002 two-step canonicalize containment procedure. ✓

**All 18 prior findings (CONS-576-001..007, NEW-001..005, NEW-R3-001..002, NEW-R4-001..003,
NEW-R5-001) RESOLVED at v1.3.45. Zero expected-open items.** ✓
