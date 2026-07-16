---
report_id: consistency-report-576-r16
round: 16
spec_version: 1.3.46
bc_count: 657
holdout_count: 96
verdict: GAPS-FOUND
gap_count: 2
gap_severity_breakdown: "MED×1, LOW×1"
prior_round: consistency-report-576-r15.md
date: 2026-07-16
adversary_pass: 6 (post-remediation)
validator: cv-f2-576-r16 (fresh context, no prior round memory)
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 16

**Spec version:** 1.3.46 · **BCs:** 657 · **Holdouts:** 96 · **Verdict:** GAPS-FOUND (2 gaps: MED×1, LOW×1)

---

## 1. Surface Coverage

All surfaces in the mandated surface set were read independently (fresh context):

| Surface | File | Status |
|---------|------|--------|
| BC-2.7 (Attachment Read) | `.factory/specs/prd/bc-2-issue-read.md` | Read |
| BC-3.5 (Comment CRUD — gate ECs) | `.factory/specs/prd/bc-3-issue-write.md` (§3.5) | Read |
| BC-3.9 (Attachment Write) | `.factory/specs/prd/bc-3-issue-write.md` (§3.9) | Read |
| BC-X.8 (Projects & Queues) | `.factory/specs/prd/cross-cutting.md` (§X.8) | Read |
| BC-INDEX | `.factory/specs/prd/BC-INDEX.md` | Read |
| CANONICAL-COUNTS | `.factory/specs/prd/CANONICAL-COUNTS.md` | Read |
| holdout-scenarios | `.factory/specs/prd/holdout-scenarios.md` | Verified via count |
| prd-delta | `.factory/phase-f2-spec-evolution/prd-delta-576.md` | Read |
| prd-delta worklog | `.factory/phase-f2-spec-evolution/prd-delta-576-worklog.md` | Read (P4+P5+R15+P6 sections) |
| spec-changelog | `.factory/spec-changelog.md` | Read |
| R15 report | `.factory/phase-f2-spec-evolution/consistency-report-576-r15.md` | Read |
| impact-boundary (all revisions) | `.factory/phase-f1-delta-analysis/impact-boundary-576.md` | Read (full 788 lines) |

---

## 2. R15 Gap Closure (GAP-R15-001)

### GAP-R15-001 — EC-3.5.003-3 and EC-3.5.008-5 mechanism language: CONFIRMED CLOSED

**Status: CLOSED ✓**

The worklog R15 Micro-Fix (2026-07-16) entry confirms DONE. Direct quote-verification:

**Quote — EC-3.5.003-3 current text (bc-3-issue-write.md ~line 2200):**
> `**EC-3.5.003-3** [GAP-R15-001 terminology sync 2026-07-16 — DEC-174 mechanism; behavior unchanged] (EOF / IO-error on delete prompt → JrError::Interrupted, exit 130): When the comment delete confirmation prompt reads via io::stdin().lock().read_line(), the return value Ok(0) (zero bytes, EOF — Ctrl+D) or any Err(_) (IO error, Ctrl+C interrupt) MUST propagate as JrError::Interrupted; exit 130. These MUST NOT be silently swallowed or mapped to the cancel path (exit 0). Ok(0) (EOF) is distinguishable from empty-Enter (Ok(n), n ≥ 1, buffer "\n") — the distinction is real and load-bearing. This ensures consistent EOF / interrupt behavior across all interactive confirmation prompts in the comment family (mirrors EC-3.5.008-5 for the --public prompt; same three-way branch as EC-3.9.015-5).`

"dialoguer::Error" language REMOVED ✓; DEC-174 `read_line Ok(0)/Err(_)` language PRESENT ✓; [GAP-R15-001 terminology sync] marker PRESENT ✓

**Quote — EC-3.5.008-5 current text (bc-3-issue-write.md ~line 2426):**
> `**EC-3.5.008-5** [GAP-R15-001 terminology sync 2026-07-16 — DEC-174 mechanism; behavior unchanged] (EOF / IO-error on --public prompt → JrError::Interrupted, exit 130): When the comment edit --public confirmation prompt reads via io::stdin().lock().read_line(), the return value Ok(0) (zero bytes, EOF — Ctrl+D) or any Err(_) (IO error, Ctrl+C interrupt) MUST propagate as JrError::Interrupted; exit 130. These MUST NOT be silently swallowed or mapped to the cancel path (exit 0). Ok(0) (EOF) is distinguishable from empty-Enter (Ok(n), n ≥ 1, buffer "\n") — the distinction is real and load-bearing. This mirrors EC-3.5.003-3 (delete prompt), ensuring consistent EOF / interrupt handling across all interactive confirmation prompts in the comment family.`

"dialoguer::Error" language REMOVED ✓; DEC-174 `read_line Ok(0)/Err(_)` language PRESENT ✓; [GAP-R15-001 terminology sync] marker PRESENT ✓

**Four-gate mechanism coherence (post-R15 fix):** All four EC clauses (EC-3.5.003-3, EC-3.5.008-5, EC-3.9.014 "Exception" clause, EC-3.9.015-5) now use DEC-174 `io::stdin().lock().read_line()` mechanism language. The cross-gate terminology asymmetry that GAP-R15-001 identified is fully resolved. ✓

---

## 3. P6 Keystone Closure Table

### P6-001 — BC-3.9.003 step-1 resolution chain: `get_or_fetch_project_meta` with `projectId` match (NOT `projectKey`)

**Status: CLOSED ✓**

**Quote — BC-3.9.003 step-1 body (bc-3-issue-write.md ~line 3297):**
> `The sdId is resolved by calling get_or_fetch_project_meta (src/api/jsm/servicedesks.rs) — the EXISTING cache-backed implementation shared with jr queue, jr requesttype, and other JSM commands — passing project_key extracted from fields.project.key in the issue GET response. This function internally: fetches GET /rest/api/3/project/{project_key} to obtain project.id; paginates GET /rest/servicedeskapi/servicedesk matching on serviceDesk.projectId == project.id (NOT projectKey — verified: src/types/jsm/servicedesk.rs::ServiceDesk has project_id from #[serde(rename = "projectId")], no projectKey field; P6-001 correction); returns ProjectMeta.service_desk_id. The result is cached in the existing project_meta.json per (profile, projectKey) with a 7-day TTL (BC-X.8.010).`

`get_or_fetch_project_meta` PRESENT ✓; match is `projectId` (NOT `projectKey`) PRESENT ✓; P6-001 correction cited ✓

**Quote — BC-INDEX BC-3.9.003 row (BC-INDEX.md ~line 375):**
> `| BC-3.9.003 | --public → servicedeskapi two-step (attachTemporaryFile + request/{key}/attachment public:true); serviceDeskId resolved via existing get_or_fetch_project_meta / ProjectMeta cache (BC-X.8.010); match serviceDesk.projectId == project.id (NOT projectKey — P6-001 correction); DEC-174 confirmation gate (eprint!+read_line, NOT dialoguer); --yes bypass; non-interactive exit 64 with --yes hint; cancel → {"cancelled":true,"uploaded":false} | — (SOH-ATTACHMENTS-1 F2) | src/cli/issue/attachments.rs (pending S5) | HIGH |`

BC-INDEX row: `projectId` match and NOT-projectKey note PRESENT ✓; P6-001 correction cited ✓

### P6-004 — BC-X.8.010 rewritten as reuse-contract; no new cache family; CANONICAL-COUNTS Cache Types at 7

**Status: CLOSED IN SPECS — see GAP-R16-001 for impact-boundary residue**

**Quote — BC-X.8.010 title (cross-cutting.md line 716):**
> `#### BC-X.8.010: JSM attachment upload resolves serviceDeskId via existing ProjectMeta cache (project_meta.json, (profile, projectKey)-scoped, 7-day TTL); serviceDesk.projectId == project.id match; no new cache file [P6-001/P6-004 correction]`

Title states "existing ProjectMeta cache" ✓; "no new cache file" ✓; P6-001/P6-004 correction cited ✓

**Quote — BC-X.8.010 cache paragraph (cross-cutting.md ~line 726):**
> `The existing project_meta.json (CANONICAL-COUNTS Cache Types item 2 — NOT a new separate file), keyed by (profile, project_key), read via cache::read_project_meta and written via cache::write_project_meta. The 7-day TTL is enforced per ProjectMeta.fetched_at. No new cache family, no new reader/writer functions. The model-b discussion from the original draft is MOOT — the existing write_project_meta writer already handles disk-write errors; no additional model-b function is needed. No independent-expiry drift: the shared ProjectMeta cache serves all JSM commands.`

"No new cache family, no new reader/writer functions" ✓; "MOOT" for model-b discussion ✓; references existing `project_meta.json` item 2 ✓

**Quote — BC-X.8.010 historical note (cross-cutting.md line 743):**
> `[P6-001/P6-004 correction 2026-07-16 SOH-ATTACHMENTS-1]: rewritten from a bespoke service_desk_id_<projectKey>.json cache design (original F2 draft) to REUSE the existing ProjectMeta cache via get_or_fetch_project_meta. Pre-code-audit original incorrectly described a new cache family and incorrectly stated "match projectKey" — the Jira ServiceDesk API response field is projectId, not projectKey (source-verified: src/types/jsm/servicedesk.rs). Delivery obligation revised: story S5 implementer reuses existing read_project_meta / write_project_meta; no new read/write_service_desk_id_cache functions to be added.`

Historical correction note PRESENT ✓; "no new read/write_service_desk_id_cache" explicit ✓

**Quote — CANONICAL-COUNTS Cache Types section (~line 185):**
> `**7 distinct cache files** (per cache.rs) [P6-004 correction: serviceDeskId reuses existing project_meta.json via get_or_fetch_project_meta — no new cache file family added; count reverted 8→7]:`
> `1. team list`
> `2. project meta (project_meta.json — also carries service_desk_id for JSM attachment upload via get_or_fetch_project_meta; added SOH-ATTACHMENTS-1 role noted; no new file)`

Cache Types count at **7** ✓; item 2 annotated with SOH-ATTACHMENTS-1 role ✓; P6-004 correction cited ✓

**Quote — BC-INDEX.md X.8 section header (~line 701):**
> `### X.8 Projects & Queues (10 BCs: BC-X.8.001..010) [BC-X.8.006..007 added 2026-05-19 issue #384 F2; BC-X.8.008..009 added 2026-06-08 S-QUEUE-BC-1; BC-X.8.010 added 2026-07-15 SOH-ATTACHMENTS-1 F2]`

X.8 = 10 BCs ✓; BC-X.8.010 present ✓

### P6-002 — BC-3.9.005 JSM detection mechanism: `projectTypeKey == "service_desk"`; zero servicedeskapi calls

**Status: CLOSED ✓**

**Quote — BC-3.9.005 detection mechanism paragraph (bc-3-issue-write.md ~line 3356):**
> `The JSM detection mechanism is projectTypeKey == "service_desk" (from ProjectMeta.project_type, populated by get_or_fetch_project_meta via GET /rest/api/3/project/{projectKey}). When projectTypeKey != "service_desk", the service desk list call inside get_or_fetch_project_meta is bypassed entirely — only a platform project GET (or cache hit) is needed; **zero servicedeskapi calls** are issued during this check. The check is performed after extracting fields.project.key from the issue GET response, but before any attachment API calls. [P6-002: detection mechanism stated explicitly; H-NEW-ATTACHMENT-008 compatible — --yes bypasses the confirmation gate only, not this exit-64 guard.]`

`projectTypeKey == "service_desk"` PRESENT ✓; "zero servicedeskapi calls" PRESENT ✓; P6-002 cited ✓; H-NEW-ATTACHMENT-008 compatibility noted ✓

**Quote — BC-INDEX BC-3.9.005 row (~line 377):**
> `| BC-3.9.005 | --public on non-JSM issue → exit 64; canonical message "–-public is only supported on Jira Service Management (JSM) issues."; JSM detection via projectTypeKey == "service_desk" (ProjectMeta path — P6-002); zero servicedeskapi calls; asymmetric from --internal (silent no-op on non-JSM) | — (SOH-ATTACHMENTS-1 F2) | src/cli/issue/attachments.rs (pending S5) | HIGH |`

BC-INDEX row: detection mechanism and zero-servicedeskapi-calls PRESENT ✓; P6-002 cited ✓

---

## 4. Critical Convergence Check — WITHDRAWN Residue and Count Residue

### Grep results: impact-boundary-576.md

| Search term | Occurrences | Assessment |
|-------------|-------------|------------|
| `WITHDRAWN` | **1** (line 408) | **GAP** — see GAP-R16-001 below |
| `650` | 0 | CLEAN ✓ |
| `656` | 0 | CLEAN ✓ |
| `~26` | 0 | CLEAN ✓ |

### Grep results: prd/ spec documents

| Search term | File | Occurrences | Assessment |
|-------------|------|-------------|------------|
| `WITHDRAWN` | all prd/*.md | 0 | CLEAN ✓ |
| `service_desk_id_.*projectKey.json` | cross-cutting.md (line 743) | 1 (historical note only) | CLEAN — in `[P6 correction 2026-07-16]` historical note; not a current design claim ✓ |
| `write_service_desk_id_cache` | cross-cutting.md (line 743) | 1 (historical note only) | CLEAN — same historical note; explicitly says "no new read/write_service_desk_id_cache" ✓ |
| `read_service_desk_id_cache` | cross-cutting.md (line 743) | 1 (historical note only) | CLEAN ✓ |

### Grep results: prd-delta-576.md

| Search term | Occurrences | Assessment |
|-------------|-------------|------------|
| `WITHDRAWN` | 0 | CLEAN ✓ |
| `650` (in count context) | 1 (R2 changelog entry: "'623' → '650'") | CLEAN — historical record of correction applied; not a current count claim ✓ |

---

## 5. New Findings (Round 16)

### GAP-R16-001 — WITHDRAWN residue in impact-boundary-576.md line 408 (MED)

**Severity:** MEDIUM
**File:** `.factory/phase-f1-delta-analysis/impact-boundary-576.md`
**Location:** R2.1 section, inline P6 retro-annotation (~line 408)

**Finding:**

The R2.1 section of impact-boundary-576.md contains the following P6-001/P6-004 inline annotation:

**Quote (impact-boundary-576.md line 408 — stale WITHDRAWN claim):**
> `**[P6-001/P6-004 retro-correction 2026-07-15: (1) the internal match is by projectId (numeric), NOT projectKey string — get_or_fetch_project_meta calls GET /rest/api/3/project/{key} to extract the numeric project_id, then matches service desks by d.project_id == project_id; the project_key is only the cache-lookup key for project_meta.json. (2) No new cache is needed — the existing ProjectMeta.service_desk_id field is ALREADY stored in the project_meta.json cache by get_or_fetch_project_meta; BC-X.8.010 as originally planned (new dedicated cache family) is WITHDRAWN — P6-004 simplification. require_service_desk already avoids the repeated paginated scan via the existing ProjectMeta cache.]**`

This annotation states "BC-X.8.010 as originally planned (new dedicated cache family) is WITHDRAWN — P6-004 simplification." It is the ORIGINAL P6-004 intermediate-state annotation.

This is **INCONSISTENT** with the later P6-001/P6-004 retro-correction at lines 490-492:

**Quote (impact-boundary-576.md lines 490-492 — authoritative P6 ruling):**
> `**[P6-001/P6-004 retro-correction 2026-07-15: BC-X.8.010 IS REWRITTEN TO REUSE (not withdrawn). (1) The resolution chain matches by projectId (numeric), not projectKey string — get_or_fetch_project_meta fetches GET /rest/api/3/project/{key} to get the numeric id, then matches d.project_id == project_id; project_key is only the outer HashMap cache key. (2) No new cache FILE or writer — the existing ProjectMeta.service_desk_id already covers this via write_project_meta/read_project_meta in project_meta.json. BC-X.8.010 SURVIVES as the contract for: (a) serviceDeskId resolution reading through the existing get_or_fetch_project_meta cache-backed path, and (b) SEC-576-006 stale-ID self-heal semantics (invalidate project-meta entry → re-resolve once → per-status mapping). BC-X.8.010 must still be authored in cross-cutting.md; counts unchanged: 657 BCs / 96 holdouts; ### X.8 = 10 BCs.]**`

**The two annotations within the same document tell conflicting stories:**
- Line 408: "is WITHDRAWN — P6-004 simplification"
- Lines 490-492: "IS REWRITTEN TO REUSE (not withdrawn)"

The authoritative ruling (confirmed by cross-cutting.md BC-X.8.010 body, worklog P6-004 DONE, CANONICAL-COUNTS Cache Types at 7, BC-INDEX X.8 = 10 BCs) is "REWRITTEN TO REUSE." The WITHDRAWN claim at line 408 is a stale intermediate annotation from the first iteration of the P6 correction that was subsequently revised but not reconciled.

**Impact:** The impact-boundary is a F1 working analysis document (not a normative spec); the normative BCs in cross-cutting.md are unambiguously correct. However, the WITHDRAWN residue creates a misleading audit trail that a future reader (or F3/F4 implementer reading the impact-boundary) could misinterpret as the BC having been removed. Since the impact-boundary is cited in story decomposition as a design reference, the conflicting annotation is a correctness risk.

**Fix:** The line 408 annotation at R2.1 should add a second inline note following the WITHDRAWN sentence: "**[SUBSEQUENTLY REVISED — see R2.3/lines 490-492: BC-X.8.010 IS REWRITTEN TO REUSE, not withdrawn; BC survives as reuse-contract; counts 657/96 unchanged]**". The WITHDRAWN sentence itself should not be deleted (it is the audit record of the first P6 judgment), but the correction inline annotation must follow immediately.

---

### GAP-R16-002 — spec-changelog.md missing [1.3.46] entry (LOW)

**Severity:** LOW
**File:** `.factory/spec-changelog.md`

**Finding:**

The bc-3-issue-write.md trace section (line 88) contains:
> `v1.3.46 — GAP-R15-001 terminology sync in EC-3.5.003-3 + EC-3.5.008-5 (dialoguer→read_line Ok(0)/Err language; DEC-174 mechanism); no behavioral change (2026-07-16, spec v1.3.46)`

This confirms bc-3-issue-write.md was bumped to v1.3.46 by the R15 Micro-Fix. The bc-3 `last_updated` frontmatter reads `2026-07-16`.

However, spec-changelog.md's latest entry is:
> `## [1.3.45] - 2026-07-15`

There is **no [1.3.46] entry in spec-changelog.md**. Prior version bumps for this feature (v1.3.43, v1.3.44, v1.3.45) each received a corresponding spec-changelog entry with Summary, Changes, and Impact Assessment sections. The v1.3.46 bump (GAP-R15-001 body-text terminology correction) is not recorded there.

Additionally, prd-delta-576.md frontmatter shows:
> `spec_version_after: 1.3.45`

This should reflect the final spec version after all fixes (including R15), which is v1.3.46.

**Impact:** LOW. The behavioral spec is correct at v1.3.46 in bc-3-issue-write.md. The spec-changelog and prd-delta frontmatter are metadata tracking documents; the missing entry does not affect any BC semantics. However, spec-changelog.md is the authoritative version history, and its highest entry (v1.3.45) does not match the bc-3 trace (v1.3.46). Any tooling that reads spec-changelog.md to determine current spec version will report v1.3.45, not v1.3.46.

**Fix:** Add a `## [1.3.46] - 2026-07-16` entry to spec-changelog.md (Type: PATCH; Summary: GAP-R15-001 DEC-174 terminology correction in EC-3.5.003-3 and EC-3.5.008-5; no behavioral change, no BC count change). Update prd-delta-576.md frontmatter `spec_version_after: 1.3.45` → `1.3.46`.

---

## 6. Impact-Boundary Inherited Checks

All checks carried forward from R15 that remain applicable:

| Check | Status | Notes |
|-------|--------|-------|
| R2.3 drift annotation present | PASS ✓ | Four-row mapping table at ~line 473 present and correct |
| Three [PLANNED ID] markers present | PASS ✓ | Lines ~504, ~549, ~561; all carry retro-annotation |
| R3.11 citing authored IDs (BC-3.9.014 + BC-3.9.015) | PASS ✓ | Line ~783 confirmed |
| P6 R2.1 annotation — `projectId` correction (part 1) | PASS ✓ | Line 408 correctly states "match is by projectId (numeric), NOT projectKey string" |
| P6 R2.3 annotation — BC-X.8.010 reuse ruling | PASS ✓ | Lines 490-492: "IS REWRITTEN TO REUSE (not withdrawn); counts unchanged: 657 BCs / 96 holdouts; X.8 = 10 BCs" |
| P6 R2.7 annotation — cross-cutting.md still touched | PASS ✓ | Line 573: "BC-X.8.010 REWRITTEN TO REUSE — BC retained; authored with reuse of get_or_fetch_project_meta+ProjectMeta.service_desk_id" |
| P6 R2.7 annotation — BC-INDEX still updated | PASS ✓ | Line 574: "BC retained; BC-INDEX.md ### X.8 entry still added as planned" |
| P6 R2.7 annotation — CANONICAL-COUNTS grand total | PASS ✓ | Line 575: "grand total 624 → ~651 unchanged (657 BCs / 96 holdouts)" |
| R2.4 src/cache.rs corrected to NOT AFFECTED | PASS ✓ | Line 437: "NOT TOUCHED — no new cache functions needed" |
| R2.4 src/cache.rs classification | PASS ✓ | Line 437: classification shown as NOT AFFECTED |
| WITHDRAWN residue in R2.1 (line 408) | **FAIL** | GAP-R16-001 — stale WITHDRAWN contradicts lines 490-492 |

---

## 7. Standard Check-Class Summary

| Check class | Result | Notes |
|-------------|--------|-------|
| BC count 657 across all surfaces | PASS ✓ | BC-INDEX `total_bcs: 657`; bc-3 `total_bcs: 140 / definitional_count 111`; bc-2 `total_bcs: 106 / definitional_count 64`; cross-cutting `total_bcs: 150 / definitional_count 84`; CANONICAL-COUNTS Sum 657; prd-delta `bc_count_after: 657` |
| Holdout count 96 across all surfaces | PASS ✓ | prd-delta `holdout_count_after: 96`; CANONICAL-COUNTS 96; bc-3 trace not checked (holdout-scenarios.md is the authority) |
| Cache Types count at 7 (P6-004) | PASS ✓ | CANONICAL-COUNTS explicitly states 7; item 2 annotated with SOH-ATTACHMENTS-1 role |
| BC-3.9.003 step-1: projectId match (NOT projectKey) | PASS ✓ | bc-3 body and BC-INDEX row both confirmed |
| BC-3.9.003 step-1: get_or_fetch_project_meta reuse | PASS ✓ | "EXISTING cache-backed implementation shared with jr queue, jr requesttype" |
| BC-X.8.010: reuse-contract (no new cache family) | PASS ✓ | cross-cutting.md body: "No new cache family, no new reader/writer functions" |
| BC-X.8.010: self-heal step invalidates project_meta entry | PASS ✓ | cross-cutting.md line ~730: "Invalidate the project_meta.json cache entry for (profile, project_key)" |
| BC-3.9.005: projectTypeKey detection mechanism | PASS ✓ | Explicit "projectTypeKey == service_desk" with zero-servicedeskapi-calls stated |
| WITHDRAWN residue in impact-boundary | **FAIL** | GAP-R16-001 — line 408 vs lines 490-492 contradiction |
| 650 / 656 / ~26 count residue in impact-boundary | PASS ✓ | None found |
| service_desk_id_<projectKey>.json in prd specs | PASS ✓ | cross-cutting.md line 743: historical note only; explicitly superseded |
| write/read_service_desk_id_cache in prd specs | PASS ✓ | cross-cutting.md line 743: historical note; "no new read/write_service_desk_id_cache" |
| BC-INDEX X.8 section count = 10 BCs | PASS ✓ | BC-INDEX line ~701: "10 BCs: BC-X.8.001..010" |
| GAP-R15-001 closed (EC-3.5.003-3 + EC-3.5.008-5 terminology) | PASS ✓ | Both ECs confirmed updated with DEC-174 mechanism language; [GAP-R15-001] markers present |
| Four-gate behavioral coherence | PASS ✓ | Inherited from R15; all four gates: 0/0/130 exit codes |
| Four-gate mechanism coherence | PASS ✓ | All four EC clauses now use DEC-174 `read_line Ok(0)/Err(_)` language (post-GAP-R15-001) |
| BC heading counts match CANONICAL-COUNTS | PASS ✓ | cross-cutting: 84; bc-2: 64; bc-3: 111 — all match |
| Temp-scheme coherence (tmp_<random>) | PASS ✓ | Inherited from R15 PASS; no regression signals in P6 or R15 Micro-Fix scope |
| Impact-boundary planned→authored ID drift annotation | PASS ✓ | R2.3 mapping table present and correct |
| Impact-boundary [PLANNED ID] markers | PASS ✓ | All 3 markers present at correct locations |
| spec-changelog.md has [1.3.46] entry | **FAIL** | GAP-R16-002 — spec-changelog.md highest entry is [1.3.45]; missing [1.3.46] |
| prd-delta-576.md spec_version_after | **FAIL** | GAP-R16-002 — reads 1.3.45; should be 1.3.46 |
| ADR-0017 in both ADR indices | PASS ✓ | Inherited from R15 PASS; no evidence of regression |
| Security review verdict APPROVE | PASS ✓ | prd-delta CONS-576-005 "RESOLVED (security-review-576.md verdict: APPROVE, status: final)" |
| No projectKey in servicedesk-RESOLUTION context | PASS ✓ | Only legitimate uses: (1) URL parameter in GET /rest/api/3/project/{projectKey}; (2) outer HashMap cache key. No claim of matching serviceDeskApi by projectKey field |

---

## 8. Summary

**Verdict: GAPS-FOUND — 2 gaps (MED×1, LOW×1); spec is implementation-ready.**

All P6 keystone remediations are verifiably present in the normative spec documents:
- BC-3.9.003 step-1 correctly uses `get_or_fetch_project_meta` with `serviceDesk.projectId == project.id` matching (NOT projectKey)
- BC-X.8.010 is correctly authored as a reuse-contract (existing `project_meta.json`, no new cache family, no new reader/writer functions)
- CANONICAL-COUNTS Cache Types is back at 7 with item 2 annotated for SOH-ATTACHMENTS-1 role
- BC-3.9.005 explicitly states `projectTypeKey == "service_desk"` detection and zero servicedeskapi calls on non-JSM

GAP-R15-001 (EC-3.5.003-3/EC-3.5.008-5 terminology) is fully closed.

Two new gaps found:

**GAP-R16-001 (MED):** The impact-boundary R2.1 inline annotation at line 408 contains a stale WITHDRAWN claim ("BC-X.8.010 as originally planned (new dedicated cache family) is WITHDRAWN") that directly contradicts the authoritative lines 490-492 ("IS REWRITTEN TO REUSE, not withdrawn"). This is an internal document inconsistency — the WITHDRAWN annotation was the first iteration of P6-004 and was subsequently superseded, but the original text was not reconciled with the corrective annotation. Fix: add inline correction immediately following the WITHDRAWN sentence in the R2.1 annotation.

**GAP-R16-002 (LOW):** spec-changelog.md is missing a [1.3.46] entry for the R15 Micro-Fix (GAP-R15-001 — EC-3.5.003-3/EC-3.5.008-5 terminology sync, 2026-07-16). The bc-3-issue-write.md trace records the v1.3.46 bump but spec-changelog.md's highest entry is [1.3.45]. Additionally, prd-delta-576.md `spec_version_after` reads 1.3.45 rather than 1.3.46. Fix: add a PATCH-type [1.3.46] entry to spec-changelog.md; update prd-delta-576.md `spec_version_after` to 1.3.46.

Both gaps are documentation/metadata issues with no effect on BC behavioral semantics.

---

*Report generated: 2026-07-16 | Validator: cv-f2-576-r16 (fresh context) | No fixes applied — report only.*
