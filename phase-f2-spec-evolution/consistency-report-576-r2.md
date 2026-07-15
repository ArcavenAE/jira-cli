---
document_type: consistency-report
level: ops
version: "2.0"
status: GAPS-FOUND
producer: consistency-validator
timestamp: 2026-07-15T00:00:00
feature: SOH-ATTACHMENTS-1
issues: "#576, #585"
phase: F2
authored: 2026-07-15
reviewer_role: consistency-validator
spec_version: 1.3.44
verdict: GAPS-FOUND
total_findings: 5
new_findings: 5
critical: 0
high: 0
medium: 0
low: 3
info: 2
r1_findings_reviewed: 7
r1_findings_resolved: 6
r1_findings_partially_resolved: 1
r1_findings_open: 0
inputs:
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/cross-cutting.md"
  - ".factory/phase-f2-spec-evolution/security-review-576.md"
  - ".factory/phase-f1-delta-analysis/impact-boundary-576.md"
  - ".factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md"
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/specs/prd/CANONICAL-COUNTS.md"
  - ".factory/spec-changelog.md"
  - ".factory/research/issue-576-attachments-api-2026-07-15.md"
traces_to: ".factory/phase-f2-spec-evolution/prd-delta-576.md"
---

# Consistency Report: SOH-ATTACHMENTS-1 F2 Spec Package (spec v1.3.44) — Round 2

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) |
| **Generated** | 2026-07-15 |
| **Generator** | consistency-validator (fresh context, no r1 read before independent pass) |
| **Artifacts Scanned** | 11 (10 from r1 scope + research file) |
| **Spec Version** | v1.3.44 (post-security-fix state) |
| **Feature** | SOH-ATTACHMENTS-1 (issues #576 + #585) |
| **Gate** | DEC-179 F2 spec bundle — round 2 after r1 GAPS-FOUND corrections |

**Review methodology**: Fresh-context read of all 11 artifacts BEFORE consulting
`consistency-report-576-r1.md`. Independent findings formed first, then r1 used only to
verify closure of CONS-576-001..007. This report contains: (a) new findings not present in
r1, and (b) an r1 closure table.

**Verdict: GAPS-FOUND** — 3 LOW and 2 INFO findings identified. One r1 finding
(CONS-576-002) is only partially resolved. No CRITICAL or HIGH findings. The BC bodies
are semantically correct and implement all DEC-179 rulings and SEC-576-001..007 security
fixes. Issues are citation drift, two factual errors in ADR-0017 context, and residual
stale numbers in process/historical artifacts.

---

## Executive Summary

Six of seven r1 findings are fully resolved. CONS-576-002 is partially resolved: the API
module citations in BC-3.9 bodies were corrected (from `issues.rs` to `attachments.rs` and
from `requests.rs` to `jsm/attachments.rs`), but all fourteen BC-3.9 body Source fields
still cite `src/cli/issue/interactions.rs` for the CLI handler. Additionally, the BC-INDEX
Source column for all Section 3.9 rows still says `interactions.rs`. This is the most
actionable finding — implementers reading BC-3.9 bodies or BC-INDEX will be directed to
the wrong file.

Three new LOW findings were identified: (1) BC-3.9.001 and ADR-0017 cite different specific
attachment size figures ("10 MB" and "250 MB" respectively) that contradict each other and
both contradict the research file's explicit INCONCLUSIVE verdict; (2) ADR-0017 cites a
non-existent endpoint URL in its context rationale; (3) the BC-INDEX Source column for all
14 Section 3.9 rows still says `interactions.rs`. Two new INFO findings cover a stale
counting note in CANONICAL-COUNTS.md and an unannotated section of the impact boundary that
still describes pre-OQ-9 behavior.

---

## R1 Closure Table

| Finding | Severity | Status in v1.3.44 | Evidence |
|---------|----------|-------------------|----------|
| CONS-576-001 — BC-INDEX row for BC-2.7.011 stale algorithm | MEDIUM | **RESOLVED** | BC-INDEX row now shows "5.5-step algorithm", "char scrub `/`/`\`/`:` → `_` only", "255-byte cap", step 5.5, SEC-576-002 two-step containment, SEC-576-001 caller note; Source changed to `attachments.rs` |
| CONS-576-002 — BC-3.9 bodies cite `interactions.rs` / `issues.rs` | LOW | **PARTIALLY RESOLVED** | API module fixed (`issues.rs` → `attachments.rs`; `requests.rs` → `jsm/attachments.rs`); CLI handler still says `interactions.rs` in ALL 14 BC-3.9 bodies (see NEW-003 below for BC-INDEX residual) |
| CONS-576-003 — BC-X.8.010 Source cites `requests.rs` | LOW | **RESOLVED** | BC-X.8.010 Source now correctly cites `src/api/jsm/attachments.rs::attach_temporary_file` |
| CONS-576-004 — BC-INDEX Section 2.7 rows cite `interactions.rs` | LOW | **RESOLVED** | All 12 Section 2.7 rows in BC-INDEX now cite `src/cli/issue/attachments.rs (pending S1/S2)` |
| CONS-576-005 — security-review-576.md status stale | LOW | **RESOLVED** | Frontmatter now `status: final`, `verdict: APPROVE`; all 7 findings show `Status: **resolved**` |
| CONS-576-006 — impact-boundary §R2.2 contradicts §OQ-9 | LOW | **RESOLVED** | Retro-annotation "[PHASE-DOC-RETRO-ANNOTATION 2026-07-15 — CONS-576-006: ...]" present in §R2.2 body |
| CONS-576-007 — spec-changelog says "ADR-0017 planned" | INFO | **RESOLVED** | spec-changelog [1.3.43] ADR reference row now reads "ADR-0017 Accepted 2026-07-15 … [CONS-576-007 correction: was 'planned', ADR exists Accepted on same date]" |

**6 of 7 fully resolved. 1 partially resolved (CONS-576-002 CLI-handler residual).**

---

## New Findings

### NEW-001 — LOW — BC-3.9.001 body and ADR-0017 cite conflicting attachment size figures, both contradicting the research INCONCLUSIVE verdict

**Artifacts**: `bc-3-issue-write.md` §BC-3.9.001 body; `ADR-0017-first-multipart-streaming-http-surface.md` §Context; `issue-576-attachments-api-2026-07-15.md` §3a.

BC-3.9.001 body (line ~3226) says:

> "The server determines the maximum attachment size (Jira Cloud default is 10 MB per file, but administrators may change it)."

ADR-0017 §Context says:

> "Jira Cloud's default attachment limit is 250 MB; some configurations allow multiple GB."

The research file §3a explicitly states:

> "Sources conflict on the cap and I could not reconcile them from docs alone: [...] Verdict: INCONCLUSIVE on the exact live cap — likely site-plan/date dependent; the intake team should not hard-code a client-side size assumption."

These three documents disagree on three different figures ("10 MB", "250 MB", INCONCLUSIVE). Impact boundary R2.5 (SQ-5 revised) explicitly withdrew the "10 MB" default: "Original Rev 1 recommendation (compiled-in 10 MB default) is withdrawn. Research confirmed the cap is site-configurable and sources conflict on the number." prd-delta-576.md §Ratified Design Rulings lists no hard-coded cap. So BC-3.9.001 inherited the withdrawn Rev 1 "10 MB" figure.

**Behavioral consequence**: low. The error message in BC-3.9.001 correctly says "No numeric limit is stated in the error" and the implementation enforces no pre-check, which is correct. The "10 MB" figure is in a context-only note, not in any assertion about what `jr` does. However the note is misleading to any reader of the BC body.

**Action**: Replace "Jira Cloud default is 10 MB per file, but administrators may change it" with "The limit is instance-specific and not knowable from the client side (sources conflict; see research §3a — INCONCLUSIVE)." Update ADR-0017 §Context to remove the "250 MB" figure or replace it with "up to several gigabytes on current Cloud plans; exact default is site-configurable" per the research.

---

### NEW-002 — LOW — ADR-0017 §Context cites a non-existent endpoint for the redirect source

**Artifact**: `ADR-0017-first-multipart-streaming-http-surface.md` §Context (paragraph on "reqwest 0.13's default redirect policy").

ADR-0017 §Context says:

> "This is directly relevant to the attachment download path because Jira issues a redirect from the `rest/api/3/issue/{key}/attachments/{id}` metadata endpoint to a pre-signed media URL on a different host (`media.atlassian.com` or equivalent)."

The correct endpoint that issues the redirect is `GET /rest/api/3/attachment/content/{id}`. The form `rest/api/3/issue/{key}/attachments/{id}` does not correspond to any endpoint in the Jira Cloud REST v3 API. The research file §1b confirms: "`GET /rest/api/3/attachment/content/{id}` does **not** stream bytes directly; on Jira Cloud it returns a **302/303 redirect**." BC-2.7.007 and BC-2.7.008 correctly specify `GET /rest/api/3/attachment/content/{id}`.

The ADR §Consequences correctly describes the behavior; only the endpoint citation in the §Context rationale paragraph is wrong.

**Action**: In ADR-0017 §Context, replace `rest/api/3/issue/{key}/attachments/{id}` with `rest/api/3/attachment/content/{id}`. This is in the descriptive rationale only; no decision changes.

---

### NEW-003 — LOW — BC-INDEX Source column for all 14 Section 3.9 rows still says `interactions.rs`

**Artifact**: `BC-INDEX.md` §Section 3.9 rows (BC-3.9.001 through BC-3.9.014).

All 14 Section 3.9 rows in BC-INDEX show `src/cli/issue/interactions.rs (pending S3/S4/S5)` in the Source column. This was not corrected as part of the r1 CONS-576-002 fix. The r1 CONS-576-002 fix corrected the API module citations in the BC bodies (`issues.rs` → `attachments.rs`) but did not touch BC-INDEX. CONS-576-004 (which fixed BC-INDEX Section 2.7 rows from `interactions.rs` to `attachments.rs`) was not extended to Section 3.9.

The F1 impact boundary §1.1 classification designates `src/cli/issue/attachments.rs` as NEW — the handler for all four attachment operations. Story authors reading BC-INDEX to determine which files to create and implement will be directed to `interactions.rs` (the existing comment CRUD file) rather than `attachments.rs` (the planned new file).

This is more impactful than NEW-001 and NEW-002 because story authors routinely consult BC-INDEX to identify implementation targets.

**Scope**: All 14 rows, BC-3.9.001 through BC-3.9.014.

**Action**: Update all 14 Section 3.9 BC-INDEX rows to cite `src/cli/issue/attachments.rs (pending S3/S4/S5)` to match the F1 design. Additionally, the 14 BC-3.9 bodies themselves still cite `src/cli/issue/interactions.rs::handle_attachment_upload` in their Source fields — these also need correction to `::handle_attachment_upload` in `attachments.rs` (the CONS-576-002 partial-resolution residual).

---

### NEW-004 — INFO — CANONICAL-COUNTS.md lines 63–65 contain stale pre-SOH-ATTACHMENTS-1 totals in BC-X.4.009 counting note

**Artifact**: `CANONICAL-COUNTS.md` lines 63–65.

The BC-X.4.009 counting note reads:

> "BC-X.4.009 (ADV-P1-029) is a `#### BC-` heading in cross-cutting.md; it is
> included in cross-cutting's `total_bcs: 149` and in the **624 sum**.
> It does NOT add +1 beyond the 623."

Cross-cutting's current `total_bcs` is 150 (was 149 before SOH-ATTACHMENTS-1 added BC-X.8.010). The grand total is 651 (was 624). The arithmetic note "does NOT add +1 beyond the 623" is also stale (the pre-SOH arithmetic context was 623 + BC-X.4.009 = 624).

The note is a historical clarification that BC-X.4.009 is counted, not double-counted, in the cross-cutting total. The counting logic itself is still correct. The stale numbers (149, 624, 623) reference the state of the spec before SOH-ATTACHMENTS-1 and were not updated when BC-X.8.010 bumped cross-cutting from 149 to 150 and the grand total from 624 to 651.

**Behavioral consequence**: none. No implementer decision depends on this note.

**Action**: Update the three stale numbers in lines 63–65 to read: "included in cross-cutting's `total_bcs: 150` and in the **651 sum**. It does NOT add +1 beyond the 650."

---

### NEW-005 — INFO — Impact boundary R2.3 BC-3.9.012 description still says "same JSM-only gate as `--public`" (pre-OQ-9 behavior), no retro-annotation

**Artifact**: `impact-boundary-576.md` §R2.3, BC-3.9.012 row.

R2.3 says:

> "BC-3.9.012 | `attachment upload --internal <KEY>` routes through servicedeskapi two-step with `public: false`; same JSM-only gate as `--public`"

"Same JSM-only gate as `--public`" implies exit 64 for `--internal` on a non-JSM issue. OQ-9 ratified the opposite: `--internal` on non-JSM = silent no-op. The CONS-576-006 retro-annotation was applied to §R2.2 but not to §R2.3.

BC-3.9.004 correctly implements OQ-9 ("Non-JSM silent no-op (OQ-9 ruling)" explicit in body and EC-3.9.004-1). R2.3 is a pre-OQ-9 artifact that was superseded before any story was authored. An implementer reading R2.3 without reaching R2.2's retro-annotation or the OQ-9 open-questions table would be misled about the non-JSM behavior for `--internal`.

**Action**: Add a retro-annotation inline in R2.3 on the BC-3.9.012 row: "[SUPERSEDED BY OQ-9: `--internal` on non-JSM = silent no-op, NOT exit 64. See R2.2 CONS-576-006 annotation and §OQ-9 RATIFIED row. BC-3.9.004 is the correct current spec for `--internal`.]"

---

## Positive Consistency Confirmations

The following were independently verified as consistent in r2 (fresh read):

- **All 7 SEC-576 security fixes present in BC bodies**: SEC-576-001 Windows device-name caller note in BC-2.7.011 ✓; SEC-576-002 two-step canonicalize procedure in BC-2.7.011 ✓; SEC-576-003 EC-2.7.007-3 wiremock test requirement in BC-2.7.007 ✓; SEC-576-004 multipart encoding note in BC-3.9.001 ✓; SEC-576-005 EC-3.9.001-5 in BC-3.9.001 AND parallel step-1 note in BC-3.9.003 ✓; SEC-576-006 stale-ID self-healing 4-step procedure in BC-X.8.010 ✓; SEC-576-007 step 5.5 trailing-strip in BC-2.7.011 ✓.

- **All DEC-179 design rulings correctly reflected in BC bodies**: Platform-POST default BC-3.9.001/002 ✓; `--internal` non-JSM = silent no-op OQ-9 in BC-3.9.004 ✓; `--public` non-JSM = exit 64 in BC-3.9.005 ✓; DEC-174 eprint!+read_line in BC-3.9.014 ✓; DEC-168 delete 404 = exit 64 in BC-3.9.008 ✓; JSDCLOUD-10841 platform endpoint in BC-2.7.007 ✓; JRACLOUD-97046 no `?redirect=false` in BC-2.7.007 ✓; P2-4a internal-by-default JSM in BC-3.9.002 ✓; JRACLOUD-96384 match-by-id in BC-2.7.012 ✓.

- **BC counts consistent across all 8 surfaces**: CANONICAL-COUNTS.md sum 651 = BC-INDEX.md `total_bcs` 651 = sum of per-file frontmatter (106 + 134 + 150 + 57 + 32 + 36 + 43 + 93 = 651) ✓; Section 2.7 12 bodies, Section 3.9 14 bodies, BC-X.8.010 1 body = 27 new ✓; 624 + 27 = 651 ✓.

- **BC-2.7.011 algorithm fully specified post-security-fix**: 5.5-step algorithm, correct char scrub (`/`/`\`/`:` only, not broad `[^a-zA-Z0-9._-]`), 255-byte cap, step 5.5 trailing strip, two-step containment check (`canonicalize(out_dir)` + `starts_with`), Windows device-name caller contract, unit test matrix including CON/NUL/COM1/nul.txt. BC-INDEX row matches. ✓

- **BC-X.8.010 stale-ID self-healing clause correctly specified**: 4-step procedure (delete cache → re-resolve → retry step-1 → surface second failure); single-attempt guard (no loop); SEC-576-006 cited; model-b writer (`eprintln!` + `Ok(())`) correctly mirrors `write_cmdb_fields_cache` and `write_object_type_attr_cache` precedents ✓.

- **security-review-576.md verdict upgraded**: `status: final`, `verdict: APPROVE` in frontmatter; all 7 findings verified as resolved in the review body ✓.

- **prd-delta-576.md counting metadata**: `spec_version_after: 1.3.43` (1.3.44 bump recorded in prd-delta as security-fix round); `bc_count_after: 651` matches CANONICAL-COUNTS ✓; deferred probe obligations (BC-3.9.007/011 P2-3c) correctly documented ✓.

- **spec-changelog [1.3.43] and [1.3.44] entries accurate**: [1.3.43] describes 27 new BCs with correct counts per section; [1.3.44] describes 5 BC modifications (BC-2.7.007, BC-2.7.011, BC-3.9.001, BC-3.9.003, BC-X.8.010) matching actual BC text changes; ADR-0017 reference corrected from "planned" to "Accepted" ✓.

- **Cross-BC interaction correctness**: BC-2.7.010 SHA-1 prefix design addresses BC-2.7.011 Windows device-name caller note ✓; BC-3.9.003 step-1 note cites SEC-576-005 + BC-X.8.010 serviceDeskId cache ✓; BC-3.9.008 DEC-168 delete 404 = exit 64 is correctly asymmetric with single-key move idempotency (BC-3.2.001) ✓; BC-3.9.014 confirmation gate mechanics mirror BC-3.5.007/BC-3.5.008 pattern ✓.

- **Research facts correctly cited in BCs**: P2-1b `TempAttachmentResponse` shape in BC-3.9.003 ✓; P2-3c INCONCLUSIVE service-desk-api schema correctly deferred in BC-3.9.007/BC-3.9.011 ✓; P2-8 `tokio-util` already transitive noted in ADR-0017 ✓; GHSA-9857-6MW7-FQ2M cited by BC-2.7.007 EC-2.7.007-3 via ADR-0017 ✓.

---

## Findings Summary

| ID | Severity | Artifact | Finding |
|----|----------|----------|---------|
| NEW-001 | LOW | BC-3.9.001 body; ADR-0017 | "10 MB" in BC-3.9.001 and "250 MB" in ADR-0017 contradict each other and both contradict research INCONCLUSIVE verdict; R2.5 explicitly withdrew the "10 MB" default recommendation |
| NEW-002 | LOW | ADR-0017 §Context | Wrong endpoint URL cited: `rest/api/3/issue/{key}/attachments/{id}` (non-existent) instead of `rest/api/3/attachment/content/{id}` |
| NEW-003 | LOW | BC-INDEX.md §Section 3.9 (all 14 rows); BC-3.9.001..014 Source fields | Source column still says `interactions.rs` for all 14 Section 3.9 rows in BC-INDEX; BC-3.9 body Source fields still cite `interactions.rs` for the CLI handler. F1 design specifies new `attachments.rs` file. Residual from CONS-576-002 partial fix + BC-INDEX not updated for Section 3.9 (cf. CONS-576-004 only fixed Section 2.7) |
| NEW-004 | INFO | CANONICAL-COUNTS.md lines 63–65 | BC-X.4.009 counting note references pre-SOH-ATTACHMENTS-1 totals: `total_bcs: 149` (now 150) and `624 sum` (now 651); "NOT add +1 beyond the 623" (now 650) |
| NEW-005 | INFO | impact-boundary-576.md §R2.3 | BC-3.9.012 row describes `--internal` as having "same JSM-only gate as `--public`" (pre-OQ-9); retro-annotation applied to §R2.2 but not to §R2.3 |

**Blocking before story decomposition**: NEW-003 (same priority class as original CONS-576-002). Story authors reading BC-INDEX or BC-3.9 bodies to determine which files to create and implement will be directed to `interactions.rs`.

**Correct before story authoring**: NEW-001, NEW-002 (ADR-0017 factual errors — low behavioral consequence but misleading to future readers).

**Documentation hygiene / burst-close**: NEW-004, NEW-005.

---

## Verdict: GAPS-FOUND

5 new findings. 6 of 7 r1 findings fully resolved; 1 partially resolved (CONS-576-002 CLI
handler residual). No CRITICAL or HIGH findings. BC bodies are semantically correct and
implement all DEC-179 rulings and SEC-576-001..007 security fixes. The most actionable
finding before story decomposition is NEW-003: story authors must know to implement
attachment CLI handlers in `src/cli/issue/attachments.rs`, not `interactions.rs`.

Recommended resolution order:
1. **NEW-003** (and CONS-576-002 residual): correct CLI handler Source in all 14 BC-3.9 bodies + all 14 BC-INDEX Section 3.9 rows from `interactions.rs` to `attachments.rs` — before story decomposition.
2. **NEW-001**: update BC-3.9.001 context note and ADR-0017 §Context to remove specific unverified size figures — before story decomposition (implementer-visible).
3. **NEW-002**: update ADR-0017 §Context endpoint URL — before story decomposition.
4. **NEW-004**: update CANONICAL-COUNTS.md lines 63–65 stale numbers — at burst close.
5. **NEW-005**: add retro-annotation to impact-boundary §R2.3 — at burst close.
