---
document_type: consistency-report
round: 19
spec_version: 1.3.49
date: 2026-07-16
validator: cv-f2-576-r19 (fresh context, no prior round visibility)
verdict: CONSISTENT
bc_count: 657
holdout_count: 96
priority_checks: P9-001 (author fallback chain), P9-002 (BC-3.9.017 step 0), P9-003 (H-002 fixtures + BC-2.7.007 step 1)
level: ops
version: "1.0"
status: pass
producer: cv-f2-576-r19
timestamp: 2026-07-16T00:00:00
phase: 2
inputs:
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576-worklog.md"
  - ".factory/spec-changelog.md"
input-hash: "6e17549"
traces_to: ".factory/specs/prd/BC-INDEX.md"
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 19 (post-P9 remediation)

**Spec version**: 1.3.49 | **BCs**: 657 | **Holdouts**: 96 | **Verdict**: CONSISTENT

---

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) — SOH-ATTACHMENTS-1 F2 |
| **Generated** | 2026-07-16T00:00:00 |
| **Generator** | cv-f2-576-r19 (fresh-context consistency validator, round 19) |
| **Artifacts Scanned** | 5 (bc-2-issue-read.md, bc-3-issue-write.md, holdout-scenarios.md, prd-delta-576-worklog.md, spec-changelog.md) |
| **Focus** | Post-P9 adversary-pass remediation verification — spec v1.3.49 |

---

## Executive Summary

All three P9 remediation items are correctly applied and mutually consistent. No contradictions found between the three priority surfaces or across the full standard check class. Two metadata-only staleness observations are noted (BC-INDEX.md and CANONICAL-COUNTS.md dates not reflecting the P9 2026-07-16 update), but these are not behavioral gaps — both files are updated only on BC count changes, and P9 added 0 new BCs.

---

## Priority Check Closure Table

### P9-001 — Three-tier author fallback chain

| Surface | Quote verified | Status |
|---------|---------------|--------|
| BC-2.7.001 Author column | `"Falls back to \`attachment.author.accountId\` when \`displayName\` is absent or null; falls back to \`"(anonymous)"\` when both are absent or null (full chain: displayName → accountId → "(anonymous)")"` | CLOSED |
| EC-2.7.001-3 trigger (a) | `"the Author column displays \`"(anonymous)"\` when: (a) \`attachment.author\` is absent or null (system-generated or anonymous attachment)"` | CLOSED |
| EC-2.7.001-3 trigger (b) | `"OR (b) \`attachment.author\` is present but both \`displayName\` and \`accountId\` are absent or null (exhausted fallback chain). Full resolution chain: (1) \`attachment.author.displayName\` if present and non-null; (2) else \`attachment.author.accountId\` if present and non-null; (3) else \`"(anonymous)"\`. This covers the H-NEW-ATTACHMENT-001 Call B fixture (author present, \`displayName\` null, no \`accountId\`)."` | CLOSED |
| BC-2.7.002 partial-author JSON note | `"**Partial-author case** (author present but \`displayName\` and \`accountId\` both absent or null): the JSON element emits the \`author\` object as received from the API — no \`"(anonymous)"\` substitution is applied in JSON mode. The resolution chain in EC-2.7.001-3 is a table-rendering convention only; JSON mode is pass-through."` | CLOSED |
| H-NEW-ATTACHMENT-001 Call B fixture | `{"id": "10002", "filename": "photo.png", "size": 51200, "mimeType": "image/png", "created": "2026-07-01T11:00:00.000+0000", "author": {"displayName": null}}` — author present, displayName null, accountId absent | CLOSED |
| H-NEW-ATTACHMENT-001 Call B Expected | `"The row for \`photo.png\` displays \`(anonymous)\` in the Author column (\`displayName\` is null and no \`accountId\` is present — exhausted fallback chain \`displayName → accountId → "(anonymous)"\` per BC-2.7.001 EC-2.7.001-3)."` | CLOSED |
| H-NEW-ATTACHMENT-001 Call B Status | `"Pins BC-2.7.001: (1) zero-attachment issue → exit 0, empty stdout, stderr hint \`"No attachments on <KEY>."\` (EC-2.7.001-1); (2) author present with \`displayName\` null and \`accountId\` absent → exhausted fallback chain → \`"(anonymous)"\` in table (EC-2.7.001-3)."` | CLOSED |
| H-NEW-ATTACHMENT-001 Call B BC refs | `"BC-2.7.001 (primary), BC-2.7.001 EC-2.7.001-3 (author present, displayName null, accountId absent → exhausted fallback chain → "(anonymous)")"` | CLOSED |

**Table vs JSON mode asymmetry**: Not a contradiction. BC-2.7.002 explicitly states "The resolution chain in EC-2.7.001-3 is a table-rendering convention only; JSON mode is pass-through." The holdout H-NEW-ATTACHMENT-001 Call B tests only table mode — there is no JSON mode call in this holdout, which is consistent with the asymmetry being a table-only contract. This follows the same intentional asymmetry pattern documented in CLAUDE.md for `issue edit` description echoing (BC-3.4.012/013).

**Exactly one specified outcome per fixture**: Call B has one fixture condition (author present, displayName null, accountId absent) and one specified table output ("(anonymous)"). No ambiguity. ✓

---

### P9-002 — BC-3.9.017 step 0 corrected citation + key-derivation equivalence

| Surface | Quote verified | Status |
|---------|---------------|--------|
| BC-3.9.017 step 0 function citation (2-arg) | `"calls \`get_or_fetch_project_meta(client, "FOO")\` (2-arg live signature: profile resolved internally via \`client.profile_name()\`; \`src/api/jsm/servicedesks.rs:41\`; cached — no extra HTTP on subsequent calls)"` | CLOSED |
| Live code verification | `src/api/jsm/servicedesks.rs:41`: `pub async fn get_or_fetch_project_meta(client: &JiraClient, project_key: &str) -> Result<ProjectMeta> { let profile = client.profile_name(); …` — exactly 2 parameters; profile resolved internally | CLOSED |
| Key-derivation equivalence (canonical statement) | `"**Key-derivation equivalence (canonical statement)**: the string-prefix derivation used here (\`FOO-1\` → \`FOO\`) is the only available approach at this pre-flight step — no issue GET has run yet. Later paths in this same command (BC-3.9.003/BC-3.9.005 plain-upload flow) use \`fields.project.key\` from the issue GET response instead; Jira guarantees these are identical (an issue's project key equals its key prefix). The two derivations are deliberately equivalent; this step-0 note is the single canonical statement of that equivalence."` | CLOSED |

**Single canonical note**: The equivalence is stated only once (in BC-3.9.017 step 0). BC-3.9.003 step 1 and BC-3.9.005 plain-upload path both use `fields.project.key` or `projectKey` without asserting equivalence — they simply reference `get_or_fetch_project_meta` as the mechanism. No other location in bc-3 independently claims key-derivation equivalence. ✓

---

### P9-003 — H-NEW-ATTACHMENT-002 fixtures mock raw "content" + BC-2.7.007 step 1 raw-vs-curated separation

| Surface | Quote verified | Status |
|---------|---------------|--------|
| H-NEW-ATTACHMENT-002 step 2 fixture (metadata) | `{"id":"10001","filename":"notes.txt","size":12,"mimeType":"text/plain","content":"<JR_BASE_URL>/rest/api/3/attachment/content/10001"}` — field name is raw `"content"`, not `"contentUrl"` | CLOSED |
| H-NEW-ATTACHMENT-002 step 4 fixture (metadata) | `{"id":"10002","filename":"broken.bin","size":100,"mimeType":"application/octet-stream","content":"<JR_BASE_URL>/rest/api/3/attachment/content/10002"}` — field name is raw `"content"` | CLOSED |
| BC-2.7.007 step 1 raw-vs-curated separation | `"The Jira API response includes a \`"content"\` field (the stable content URL); \`jr\` renames this to \`"contentUrl"\` in its curated output (BC-2.7.002 convention). The download flow does NOT read this field from the step-1 response — it constructs the content URL from the attachment id directly (see step 2). The metadata response is used solely to obtain the canonical \`filename\` for BC-2.7.010 naming."` | CLOSED |

**Convention consistency**: The raw `"content"` → curated `"contentUrl"` rename is applied consistently across the spec:
- BC-3.9.001: `"The Jira API response includes fields such as … \`"content"\` (the download URL) — these are the raw API wire fields … **jr's output serialization** … \`"content"\` is RENAMED to \`"contentUrl"\`"` ✓
- BC-3.9.009: `"the raw Jira \`"self"\` field is OMITTED; the raw \`"content"\` field is renamed to \`"contentUrl"\`"` ✓
- BC-2.7.002: `"\`contentUrl\` is the stable authenticated Jira content endpoint … \`jr\` exposes this as \`contentUrl\` (not the raw Jira API field name \`content\`) for clarity"` ✓

**H-NEW-ATTACHMENT-002 fixture design note**: The `"content"` field in the mock metadata response reflects the real Jira API wire format. BC-2.7.007 step 2 (the streaming download) constructs the content URL as `/rest/api/3/attachment/content/{id}` — it does NOT read the `"content"` field from the step-1 response. The wiremock mount for step 3 (`GET /rest/api/3/attachment/content/10001`) is consistent with this construction. The fixture value of `"content"` is thus irrelevant to the test outcome, but correct as a Jira API fidelity concern. ✓

---

## Standard Check Class

### Check 1: Version stamp propagation

| File | Expected stamp | Found | Status |
|------|---------------|-------|--------|
| spec-changelog.md | [1.3.49] as most recent entry | `## [1.3.49] - 2026-07-16` ✓ | PASS |
| bc-3-issue-write.md frontmatter | v1.3.49 trace line | `v1.3.49 — P9 adversary fix round (2026-07-16, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.017 step 0 function citation corrected to 2-arg live signature \`get_or_fetch_project_meta(client, project_key)\` (\`src/api/jsm/servicedesks.rs:41\`); key-derivation equivalence note added (P9-002); BC count unchanged (140/30)` ✓ | PASS |
| bc-3-issue-write.md footer | `_Last updated` with v1.3.49 | `_Last updated 2026-07-16 (SOH-ATTACHMENTS-1 adversary pass-9 fix round, P9-002): 0 new BCs — BC-3.9.017 step 0 function citation corrected…; spec v1.3.49.` ✓ | PASS |
| prd-delta-576.md | spec_version_after: 1.3.49 | Confirmed ✓ | PASS |
| bc-2-issue-read.md | Date-based tracking (no inline version stamp) | `last_updated: 2026-07-16` ✓ — date-based convention; P9-001 and P9-003 changes are in this file | PASS (convention-appropriate) |
| holdout-scenarios.md | Own version track (1.5.x), date-based | `version: "1.5.2"`, `last_updated: 2026-07-16` ✓ | PASS |
| BC-INDEX.md | NOT updated for 0-BC changes | `last_updated: 2026-07-15`, `index_version: v6.14` — P9 added 0 new BCs; convention is to update BC-INDEX only on count changes | OBSERVATION (see below) |
| CANONICAL-COUNTS.md | NOT updated for 0-BC changes | `last_verified: "2026-07-15"` — same convention as BC-INDEX | OBSERVATION (see below) |

### Check 2: BC count arithmetic

Sum of per-file `total_bcs` values: 57 (bc-1) + 106 (bc-2) + 140 (bc-3) + 32 (bc-4) + 36 (bc-5) + 43 (bc-6) + 93 (bc-7) + 150 (cross-cutting) = **657** ✓

BC-INDEX.md `total_bcs: 657` ✓

### Check 3: Holdout count

`grep -c "^### H-" holdout-scenarios.md` → **96** ✓

holdout-scenarios.md frontmatter `total_holdouts: 96` ✓

### Check 4: EC-2.7.001-3 mutual citation

- BC body (bc-2-issue-read.md line ~560): "This covers the H-NEW-ATTACHMENT-001 Call B fixture" → references holdout ✓
- Holdout body (holdout-scenarios.md line 2095): "per BC-2.7.001 EC-2.7.001-3" → references BC ✓
- Holdout Status (line 2100): "Pins BC-2.7.001 … EC-2.7.001-3" ✓
- Mutual citation is consistent. ✓

### Check 5: Function signature accuracy (P9-002)

`get_or_fetch_project_meta` at `src/api/jsm/servicedesks.rs:41` confirmed live:
```
pub async fn get_or_fetch_project_meta(
    client: &JiraClient,
    project_key: &str,
) -> Result<ProjectMeta> {
    let profile = client.profile_name();  // profile resolved internally
```
Matches spec claim exactly. ✓

### Check 6: Cross-cutting author convention

No author-fallback convention appears in cross-cutting.md (the three-tier chain is specific to BC-2.7 attachment list rendering). No cross-contamination with comment or changelog author rendering (those use different sources: `comment.author.displayName`, `entry.author.displayName`). Attachment-specific convention is isolated to BC-2.7.001/EC-2.7.001-3. ✓

### Check 7: "content" vs "contentUrl" sweep across upload and download BCs

All references consistently distinguish:
- Raw API wire field: `"content"` (what Jira returns)
- jr curated field: `"contentUrl"` (what jr exposes in JSON output)

No site found that uses `"contentUrl"` in a wiremock fixture describing a Jira API response (which would be the wrong form). No site found that uses `"content"` in a jr JSON output description (which would also be wrong). The P9-003 correction was the only such fixture error, and it is confirmed fixed. ✓

### Check 8: prd-delta-576-worklog.md P9 round tracking

Round P9 entry present at `phase-f2-spec-evolution/prd-delta-576-worklog.md` lines 734–744:
```
### Round P9 — 2026-07-16
| P9-001 | MED | APPLIED | … |
| P9-002 | LOW | APPLIED | … |
| P9-003 | LOW | APPLIED | … |
```
All three findings marked APPLIED. ✓

Changelog-sync confirmation: `"v1.3.49 MINOR entry inserted in \`spec-changelog.md\`; \`prd-delta-576.md\` \`spec_version_after\` → 1.3.49; bc-3-issue-write.md frontmatter: v1.3.49 trace appended + \`_Last updated\` prepended."` ✓

---

## Observations (non-blocking)

### OBS-R19-001: BC-INDEX.md and CANONICAL-COUNTS.md dates not updated for P9

**Files**: BC-INDEX.md (`last_updated: 2026-07-15`, `index_version: v6.14`); CANONICAL-COUNTS.md (`last_verified: "2026-07-15"`)

**Nature**: Metadata staleness only. P9 added 0 new BCs; both files' count claims (657 total) remain accurate. The established convention is to update these files only when BC counts change. Prior passes P7 and P8 (both 0 new BCs) similarly did not trigger BC-INDEX.md or CANONICAL-COUNTS.md updates.

**Assessment**: Not a behavioral gap; no action required. Consistent with convention.

---

## Conclusion

**VERDICT: CONSISTENT**

Spec v1.3.49 (657 BCs / 96 holdouts) is consistent post-P9 remediation. The three priority check areas are each fully closed with verbatim quote verification:

1. **P9-001** — The author fallback chain `displayName → accountId → "(anonymous)"` is stated identically in BC-2.7.001's table footnote, EC-2.7.001-3's full chain enumeration, and H-NEW-ATTACHMENT-001 Call B's Expected/Status/BC-refs. BC-2.7.002's partial-author JSON note correctly states pass-through (no "(anonymous)" substitution) and explicitly labels EC-2.7.001-3 as a table-rendering convention only. The table/JSON asymmetry is intentional and clearly documented — no contradiction.

2. **P9-002** — BC-3.9.017 step 0 cites `get_or_fetch_project_meta(client, project_key)` with 2-arg live signature verified against `src/api/jsm/servicedesks.rs:41`. The key-derivation equivalence note is present as a single canonical statement in step 0, not duplicated elsewhere.

3. **P9-003** — H-NEW-ATTACHMENT-002 steps 2 and 4 use the raw Jira API field name `"content"` (not `"contentUrl"`). BC-2.7.007 step 1 clearly separates raw `"content"` from curated `"contentUrl"` and documents that the download flow ignores the step-1 field entirely. Convention is consistent across BC-3.9.001, BC-3.9.009, and BC-2.7.002.

---

## 1. L2 to L3 Requirement Coverage

[TODO: N/A for spec-consistency round — this section covers standard VSDD L2 capability-to-BC traceability which is maintained in BC-INDEX.md and bc-*.md files, not re-validated in a per-round consistency check. See BC-INDEX.md Section headers for coverage.]

## 2. L3 to L4 Verification Property Coverage

[TODO: N/A for spec-consistency round — VP coverage is tracked in the verification-properties directory. Per-round consistency checks focus on spec-internal consistency, not VP coverage.]

## 3. Dependency Acyclicity

[TODO: N/A for spec-consistency round — story dependency acyclicity is tracked at story decomposition time, not in spec consistency rounds.]

## 4. Architecture Alignment

[TODO: N/A for spec-consistency round — architecture alignment is validated during Phase 2 story decomposition. This round validates spec-internal consistency only.]

## 5. Acceptance Criteria Quality

[TODO: N/A for spec-consistency round — AC quality validation applies to story-level ACs. This round validates behavioral contract text consistency.]

## 6. Story Sizing

[TODO: N/A for spec-consistency round — story sizing is a story-decomposition concern, not a spec consistency concern.]

## 7. Priority Consistency

[TODO: N/A for spec-consistency round — priority consistency applies to story prioritization, not spec BC ordering.]

## 8. L1 to L2 to L3 to L4 Chain Completeness

[TODO: N/A for spec-consistency round — chain completeness is validated at Phase 2 gate. This round is a targeted post-adversary-pass spec consistency check at the BC/holdout level only.]

## 9. AC Completeness Coverage

[TODO: N/A for spec-consistency round — AC completeness applies to story acceptance criteria. The equivalent concept here (holdout coverage of BCs) is validated in Check 3 and the Priority Check Closure Table above.]

## 10. ASM/R Traceability

[TODO: N/A for spec-consistency round — assumption/risk traceability is a Phase 2 artifact. No new ASMs or risks were introduced in P9.]

## Cross-Reference Validation

### ID Consistency

| Check | Status | Issues |
|-------|--------|--------|
| BC-2.7 IDs unique | pass | None |
| BC-3.9 IDs unique | pass | None |
| EC-2.7.001-3 traces to valid holdout | pass | H-NEW-ATTACHMENT-001 Call B — confirmed |
| H-NEW-ATTACHMENT-001 traces to valid BC | pass | BC-2.7.001 — confirmed |
| H-NEW-ATTACHMENT-002 traces to valid BC | pass | BC-2.7.007 — confirmed |
| servicedesks.rs:41 citation live-verified | pass | `get_or_fetch_project_meta` at line 41 — confirmed |

### Naming Convention Compliance

| Convention | Expected Pattern | Violations |
|-----------|-----------------|------------|
| BC naming | BC-S.SS.NNN | None found in P9-modified BCs |
| EC naming | EC-S.SS.NNN-N | None found |
| Holdout naming | H-NEW-{FEATURE}-NNN | None found |

### Canonical Frontmatter Validation

| Artifact | document_type | last_updated | Status |
|----------|--------------|--------------|--------|
| bc-2-issue-read.md | context: bc-2 | 2026-07-16 | pass |
| bc-3-issue-write.md | context: bc-3 | 2026-07-16 | pass |
| holdout-scenarios.md | context: holdout-scenarios | 2026-07-16 | pass |

## Spec vs Implementation Drift

| Artifact | Spec Version | Implementation State | Drift Detected | Notes |
|----------|-------------|---------------------|---------------|-------|
| bc-2-issue-read.md | last_updated: 2026-07-16 | No implementation exists yet (SOH-ATTACHMENTS-1 pending story delivery) | no | spec-only round; no code to drift against |
| bc-3-issue-write.md | v1.3.49 | No implementation exists yet | no | spec-only round |
| `src/api/jsm/servicedesks.rs:41` | — | `get_or_fetch_project_meta(client, project_key)` live | no drift | spec citation confirmed against live code |

## Findings

### Critical

None.

### Major

None.

### Minor

- OBS-R19-001: BC-INDEX.md `last_updated` and CANONICAL-COUNTS.md `last_verified` are 2026-07-15, one day behind P9 changes. Non-behavioral; count claims accurate. No action required.

## Validation Gate Result

**PASS** — No blocking findings. All three P9 remediation items verified consistent. Spec v1.3.49 is internally consistent across all checked surfaces.

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 11 (8 standard + 3 priority) |
| **Passed** | 11 |
| **Failed** | 0 |
| **Warnings** | 0 |
| **Observations (non-blocking)** | 1 (OBS-R19-001) |
| **Overall Status** | consistent |

Round 19 is the first fresh-context validation following the P9 adversary-pass remediation (spec v1.3.48 → v1.3.49). All three P9-targeted areas are confirmed correct. The spec is ready for Phase F3 story decomposition and F4 implementation.

## Appendix: Validation Methodology

**Approach**: Fresh-context consistency validation — no prior round context loaded. All findings derived independently from direct spec file reads.

**Files read**:
- `.factory/specs/prd/bc-2-issue-read.md` — BC-2.7.001, EC-2.7.001-1/3, BC-2.7.002, BC-2.7.007
- `.factory/specs/prd/bc-3-issue-write.md` — BC-3.9.017 step 0, version stamp, last-updated footer
- `.factory/specs/prd/holdout-scenarios.md` — H-NEW-ATTACHMENT-001 Call B, H-NEW-ATTACHMENT-002 steps 2 and 4
- `.factory/spec-changelog.md` — [1.3.49] entry
- `.factory/phase-f2-spec-evolution/prd-delta-576-worklog.md` — Round P9 table, changelog-sync note
- `src/api/jsm/servicedesks.rs` — live code verification of `get_or_fetch_project_meta` signature at line 41

**Quote verification**: All closure-table quotes are verbatim from the spec files as read during this round. Line number references approximate (files subject to ongoing edits).

**Version verification**: `spec-changelog.md [1.3.49]` confirmed as most recent entry. BC count 657 arithmetic verified (57+106+140+32+36+43+93+150=657). Holdout count 96 verified via `grep -c "^### H-"`.
