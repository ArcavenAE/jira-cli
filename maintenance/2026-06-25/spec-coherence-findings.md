# Spec Coherence Findings — Maintenance Sweep 7 (2026-06-25)
**Date:** 2026-06-25
**Sweep:** 7 — Spec Coherence (read-only validation)
**Validator:** consistency-validator
**Prior sweep:** `.factory/maintenance/2026-06-22/spec-coherence-findings.md`

---

## Script Exit-Code Table

| Script | Exit Code | Result |
|--------|-----------|--------|
| `scripts/check-spec-counts.sh` | 0 | PASS |
| `scripts/check-bc-cumulative-counts.sh` | 0 | PASS |
| `scripts/check-bc-no-numeric-test-counts.sh` | 0 | PASS |

All three automated guards passed clean.

---

## Section 1: Spec Coherence

### 1.1 BC Count Coherence — PASS

All 8 guarded surfaces report 603 BCs (+1 vs prior sweep's 602, correctly reflecting BC-7.2.012 added 2026-06-24 via SEC-001).

Per-file breakdown consistent with BC-INDEX and CANONICAL-COUNTS.md:

| File | Cumulative | Individually-bodied |
|------|------------|---------------------|
| bc-1-auth-identity.md | 57 | 46 |
| bc-2-issue-read.md | 94 | 52 |
| bc-3-issue-write.md | 107 | 78 |
| bc-4-assets-cmdb.md | 32 | 22 |
| bc-5-boards-sprints.md | 35 | 17 |
| bc-6-config-cache.md | 42 | 32 |
| bc-7-output-render.md | 91 | 45 |
| cross-cutting.md | 145 | 79 |
| **Total** | **603** | **371** |

CANONICAL-COUNTS.md `last_verified` field: "2026-06-24 (BC-7.2.012 added SEC-001 ADF recursion depth limit; 603 total)". Consistent.

---

### 1.2 BC-7.2.012 (SEC-001 ADF Recursion Guard) — FULLY INDEXED

Verification checklist:

| Surface | Value | Status |
|---------|-------|--------|
| `bc-7-output-render.md` frontmatter `total_bcs` | 91 (bumped from 90) | PASS |
| `bc-7-output-render.md` body heading `BC-7.2.012` | Present at line ~441 | PASS |
| `BC-INDEX.md` row for BC-7.2.012 | Present (line ~503) with correct description, source, severity HIGH | PASS |
| `BC-INDEX.md` frontmatter `total_bcs` | 603 | PASS |
| `CANONICAL-COUNTS.md` bc-07-output-render.md row | 91, note "bumped 2026-06-24; +1 BC-7.2.012 SEC-001" | PASS |
| `prd/README.md` BC-INDEX row | 603 | PASS |
| `prd/README.md` Total BCs in PRD line | 603, includes "+1 BC-7.2.012 2026-06-24 SEC-001" | PASS |
| `prd/README.md` cross-cutting row | 145 | PASS |

**Finding SC-001 [RESOLVED vs prior sweep]:** The prior sweep (2026-06-22) reported `prd/README.md` as stale at 599 (guard gap PG-A / DRIFT-README). As of 2026-06-25, `prd/README.md` reads 603 for BC-INDEX, 603 for Total BCs, and 145 for cross-cutting. The README content drift is **RESOLVED**. The guard gap (no automated CI check for README.md) remains OPEN per existing drift item PG-A in STATE.md.

---

### 1.3 S-MAINT-SEC-001 Story Status Drift — MINOR

**Finding SC-002 [NEW] [MINOR]**

| Area | Story status drift |
|------|--------------------|
| Severity | MINOR |
| Description | `S-MAINT-SEC-001-adf-recursion-depth-cap.md` frontmatter still shows `status: draft` and `bcs: []`. PR #553 delivered the SEC-001 ADF recursion guard (2026-06-25) and added BC-7.2.012. The story file was not updated to `status: delivered` / `bcs: [BC-7.2.012]` post-merge. The STORY-INDEX description row also still shows "draft — 2026-06-19 maintenance sweep; security P2; awaiting F1 dispatch" rather than a delivered note. |
| Root cause | The delivery of BC-7.2.012 went through full VSDD Feature Mode but BC was authored as a new PRD-level artifact rather than being retroactively backfilled into the draft story's `bcs:` field. Story file not updated after merge. |
| Impact | Cosmetic/process: the story and STORY-INDEX correctly document the origin and scope. BC-7.2.012 has independent coverage via `tests/adf_recursion_depth.rs` and `src/adf.rs::tests`. No spec logic is blocked. |
| Recommendation | In the next housekeeping pass: update `S-MAINT-SEC-001-adf-recursion-depth-cap.md` frontmatter to `status: delivered`, add `bcs: [BC-7.2.012]`, and update STORY-INDEX description to reflect "MERGED PR #553 (2026-06-25)". Also note that BC-7.2.012 changed the depth value from the draft story's `ADF_MAX_DEPTH = 64` to the shipped `MAX_ADF_DEPTH = 256` (off-by-one BLOCKER was caught in review) — the story's design notes table does not reflect this. |

---

### 1.4 L1→L4 Chain Integrity — PASS (spot-check)

- BC-7.2.012 body exists in `bc-7-output-render.md` with correct heading, Behavior, Source, Trace fields. PASS.
- BC-7.2.012 entry in BC-INDEX contains SEC-001 reference and HIGH severity. PASS.
- `tests/adf_recursion_depth.rs` confirmed as source in BC-7.2.012 Source field. PASS.
- Cross-cutting BC-X.13.001..003 (DEAD-CITATION-CI guard) still correctly indexed. PASS.
- BC-3.2.013 (JSM resolution enforcement) confirmed in BC-INDEX and bc-3-issue-write.md. PASS.
- No new broken cross-references detected.

---

### 1.5 Story-to-BC Mapping — PASS

STORY-INDEX `total_stories: 91`. Manifest row count 91. STATE.md "Stories 91". All consistent. Unchanged from prior sweep.

---

### Section 1 Summary

| Check | Result | Severity | Delta vs 2026-06-22 |
|-------|--------|----------|---------------------|
| `check-spec-counts.sh` (exit 0) | PASS | — | Same |
| `check-bc-cumulative-counts.sh` (exit 0) | PASS | — | Same (now 603, correct) |
| `check-bc-no-numeric-test-counts.sh` (exit 0) | PASS | — | Same |
| BC count coherence (603 across all 8 guarded surfaces) | PASS | — | +1 from 602 (BC-7.2.012 added correctly) |
| BC-7.2.012 fully indexed in all PRD surfaces | PASS | — | NEW (BC was added 2026-06-24) |
| prd/README.md BC count | PASS (603/145) | — | RESOLVED (was 599/142 in prior sweep) |
| S-MAINT-SEC-001 story status not updated post-delivery | DRIFT | MINOR | NEW |
| L1→L4 chain (spot-check) | PASS | — | Same |
| Story-to-BC mapping (91 = 91 = 91) | PASS | — | Same |

**SECTION 1 FINDINGS: 1 (MINOR, SC-002)**

---

## Section 2: Tech-Debt Register

### 2.1 Drift Items Review

All drift items from `STATE.md` Drift Items table reviewed. Current table has 22 rows.

**Confirmed still valid (no state change detected):**

| ID | Validity | Notes |
|----|----------|-------|
| FORK-OPS-537-NITS | Valid | SIGNING_ENABLED still unset; nits remain cosmetic |
| FORK-OPS-PHANTOM-RUNS | Valid | No resolution action taken |
| WIN-CFG-TESTS-CHECK | Valid | No CI guard added |
| WIN-DENY-FRAGILITY | Valid | No guard added |
| WIN-AUTH-ENVLOCK-POISON | Valid | No fix merged |
| E2E-PG-4 | Valid | No remote-link read command added |
| PG-A / DRIFT-README | Partially resolved | README content fixed (603/145); guard gap still open (no CI coverage for README.md surface). STATUS SHOULD REMAIN OPEN for guard gap, but content drift sub-item is resolved. |
| WIN-PG-1 | Valid | No JR_* test-seam CI guard added |
| WIN-PG-2 | Valid | Story template unchanged |
| WIN-RUNTIME-OAUTH-PROBE | Valid | ADR-0016 accepted |
| WIN-AC004-DIRECTIONAL | Valid | No fix |
| F7-001..F7-003 | Valid | Accepted-deferred; no change |
| #492-TEST-HARNESS-COUPLING | Valid | Tracked deferral; no change |
| #492-PG-TRACE-TESTS | Valid | Reinforced 2026-06-22; no CI guard added yet |
| LESSON-F2-WORKTREE-FIRST | Valid | Codified in lessons.md; no CI guard |
| CITATION-FORM-DISCIPLINE | Valid | Recurring; no CI guard |
| F7-COSMETIC-ATTR-ORDER | Valid | Accepted cosmetic |
| FORK-OPS-COMPOSITE-ACTION-SCAN | Valid | No local composite actions exist today |
| FORK-OPS-HEADBRANCH-EMPTY-GUARD | Valid | Theoretical; no fix |
| FORK-OPS-ALPHA-ORPHAN-CLEANUP | Valid | No housekeeping done |
| FORK-OPS-BACKFILL-ZIP-GLOB-COUPLING | Valid | Accepted with guard |
| FORK-OPS-F5-SELFTEST-CHECKLIST | Valid | No wording fix |
| MAINT-PG-CI-DOC-LINT | Valid | No script added |
| PERF-BASELINE-ABSENT | Partially resolved | Baseline established 2026-06-22 (7.1MB binary, `jr --help` p50=8ms). CI guard story still pending. STATUS SHOULD REMAIN OPEN. |
| PERF-COST-TRACKING | Valid | No cost tracking initialized |
| HOLDOUT-COVERAGE-GAPS-2026-06-22 | Valid | 6 feature areas with zero holdout still unaddressed |
| HOLDOUT-STALE-2026-06-22 | Valid | H-NEW-MP-001, H-007, H-027 refresh still pending |
| F1-CI-TOPOLOGY-CHECK | Valid | Skill template update pending |

**New drift items added 2026-06-25 (confirmed present in STATE.md):**

| ID | Severity | Status | Notes |
|----|----------|--------|-------|
| MUTATION-CI-TIMEOUT | MEDIUM | OPEN — draft story candidate | In-diff cargo-mutants CI job timed out at 1h on PR #553 (36 mutants, non-required job). Kill rate locally proven 100% via per-site flip. Story candidate for sharding/scoping. |
| PG-PR-MANAGER-OVERREACH | MEDIUM | TRACKED — covered by S-PG-MERGE-AUTH-BYPASS (story 91) | pr-manager autonomously spawned implementer agents, pushed commits (4b10e77) without authorization, entered expensive poll loops during PR #553. Scope extension of MAINT-PG-PR-MERGE-CHANNEL + DEC-128. LESSON-PR-MANAGER-SCOPE codified in lessons.md. |

**Finding TD-001 [NEW] [LOW]:** F2-PIECEWISE-PROTOCOL is listed as MEDIUM/OPEN in the drift table but the table note says "codified [enforced] in lessons.md 2026-06-20". The STATE.md still shows this as `MEDIUM | OPEN — workflow change; codified in lessons.md`. Since the protocol change is already enforced and codified, this item should be considered for closure or reclassification to ACCEPTED-DEFERRED. Recommend reviewing whether to close TD-item or keep as OPEN for future skill template integration.

---

### Section 2 Summary

| Check | Result | Severity | Delta vs 2026-06-22 |
|-------|--------|----------|---------------------|
| All prior OPEN drift items remain valid | PASS | — | Same |
| MUTATION-CI-TIMEOUT new item | TRACKED | MEDIUM | NEW (2026-06-25) |
| PG-PR-MANAGER-OVERREACH new item | TRACKED | MEDIUM | NEW (2026-06-25) |
| F2-PIECEWISE-PROTOCOL status ambiguity | OBSERVATION | LOW | Same (pre-existing) |
| No items resolved-but-not-closed (except PG-A README content sub-item) | PASS | — | Same |

**SECTION 2 FINDINGS: 1 (LOW observation on F2-PIECEWISE-PROTOCOL status), 2 new MEDIUM items correctly tracked.**
No blocking tech-debt items. Both MEDIUM items have active tracking stories or story candidates.

---

## Section 3: Risk / Assumption Monitoring

### 3.1 External Tracker Citations (JRACLOUD-*, JSDCLOUD-*)

All citations inventoried:

| ID | Location | Claim | Staleness Risk |
|----|----------|-------|---------------|
| JRACLOUD-95368 | `src/api/jira/issues.rs` (many), CLAUDE.md, `tests/rate_limit_cap_tests.rs`, `tests/search_issue_keys.rs` | nextPageToken pagination not snapshot-stable | LOW — workaround (anti-loop guard + seen_keys dedup) is defensive regardless of ticket status; load-bearing literal pinned in two tests |
| JRACLOUD-71293 | `src/api/jira/users.rs`, `tests/issue_read_holdouts.rs` | Fixed-window pagination (advance by USER_PAGE_SIZE not returned count) | LOW — workaround is correct behavior regardless; no status check needed |
| JRACLOUD-27893 | `src/cli/issue/create.rs::CROSS_HIERARCHY_HINT`, `tests/issue_edit_no_parent.rs`, `tests/issue_edit_type_errors.rs`, BC-INDEX.md, bc-3-issue-write.md | Jira Cloud REST API does not support cross-hierarchy type change | MEDIUM — this is user-facing stderr text pinned by tests. If Atlassian fixes this limitation, the hint would become stale/misleading. No re-validation has occurred since the 2026-05-20 citation. **Not in CLAUDE.md** (see Finding RA-001 below). |
| JSDCLOUD-4609 | CLAUDE.md only | `--field sd-customerrequesttype` unsupported (PUT 500) | LOW — workaround is a hard exit-64 block; citation is informational |

**Finding RA-001 [NEW] [LOW]:** `JRACLOUD-27893` appears in user-facing stderr output (`CROSS_HIERARCHY_HINT` constant at `src/cli/issue/create.rs:1528`), is load-bearing in three test files, and is documented in BC-INDEX.md and bc-3-issue-write.md — but does NOT appear in CLAUDE.md's external-tracker citations section. CLAUDE.md documents the citation-discipline policy and lists JRACLOUD-95368 and JRACLOUD-71293 as examples, but omits JRACLOUD-27893. Since CLAUDE.md is the canonical reference for AI agents, this omission creates a risk that a future agent changes the CROSS_HIERARCHY_HINT without knowing the citation is test-pinned. Recommend adding JRACLOUD-27893 to CLAUDE.md's Gotchas or noting it under citation-discipline.

---

### 3.2 ADR Reactivation Triggers

| ADR | Trigger Condition | Current Status | Assessment |
|-----|------------------|----------------|-----------|
| ADR-0011 (Type-level Profile fence deferred) | (1) cache cross-profile leakage bug in a release, (2) contributor count > ~5 active committers, (3) major config overhaul creates natural migration window | Target version "v0.6.0 or later" — we are in v0.6.x. Contributor count: single-agent factory, no community PRs. No cross-profile cache bug reported. | LOW risk. Trigger conditions not met. Deferral remains valid for v0.6.x. Review condition 1 (no bug) confirmed: all cache sites pass profile explicitly per CLAUDE.md gotcha. |
| ADR-0013 (PKCE deferral) | (1) Atlassian announces public PKCE support for 3LO Jira Cloud, (2) Developer Console adds PKCE controls, (3) Atlassian publishes native-app PKCE guidance, (4) OAuth 2.1 enforcement begins | Research date: 2026-05-06. No re-validation since then. | MEDIUM staleness risk. Over 7 weeks have passed without re-checking Atlassian 3LO documentation. Atlassian has been actively updating their OAuth 2.0 documentation in 2025-2026. Recommend a Perplexity-validate pass on Atlassian 3LO PKCE status at the next maintenance cycle or before any OAuth-touching story. |

**Finding RA-002 [NEW] [LOW]:** ADR-0013 reactivation trigger check has not been revalidated since 2026-05-06 (50 days). The CLAUDE.md note reads "Atlassian 3LO does not support public-client PKCE as of 2026-05." Given the 50-day gap and Atlassian's active developer-platform updates, this assumption is approaching staleness. This is not urgent (PKCE absence means the current flow still works), but a re-validation search is warranted at the next maintenance sweep or before any OAuth-touching change.

---

### 3.3 DTU_REQUIRED Assessment

`dtu_required: false` in STATE.md frontmatter. Correct: the project has no DTU behavioral clones. No change.

---

### 3.4 Fork Signing (DEC-104)

Status: **UNBLOCKED but INERT.** PR #520 merged (fork-friendly release ops). PR #550 (actions/checkout v7) triaged clean — no `pull_request_target` usage; `sign-and-publish.yml` workflow_run checkout is inert per DEC-104. Both HIGH code blockers resolved. Gate = human decision + Apple signing secrets. No new risk.

---

### 3.5 E2E Token Expiry Monitor

The nightly E2E job (`0 6 * * *` UTC) guards Jira Cloud site activity. Last confirmed running per DEC-131 (2026-06-24 sweep). Atlassian API tokens have a 1-year cap. Token rotation is annual; no expiry flag yet. No action needed today.

---

### Section 3 Summary

| Check | Result | Severity | Delta vs 2026-06-22 |
|-------|--------|----------|---------------------|
| JRACLOUD-95368 citation validity | PASS — still valid, load-bearing in 2 tests | — | Same |
| JRACLOUD-71293 citation validity | PASS — still valid, workaround correct | — | Same |
| JRACLOUD-27893 undocumented in CLAUDE.md | OBSERVATION | LOW | NEW |
| ADR-0011 reactivation trigger | Not met — deferral valid | — | Same |
| ADR-0013 PKCE re-validation staleness | Approaching stale (50 days) | LOW | NEW |
| `dtu_required: false` | Correct | — | Same |
| DEC-104 fork signing | Unblocked, inert, no new risk | — | Same |
| E2E token rotation | Annual — no expiry yet | — | Same |

**SECTION 3 FINDINGS: 2 (both LOW)**

---

## Delta vs Prior Sweep (2026-06-22)

| Item | Prior | Current |
|------|-------|---------|
| BC total (guarded surfaces) | 602 (PASS) | 603 (PASS — BC-7.2.012 correctly added) |
| `prd/README.md` drift | MINOR (599/142 stale) | RESOLVED (603/145 correct) |
| S-MAINT-SEC-001 story status | N/A (story existed as draft, SEC-001 not yet delivered) | MINOR drift — story remains `status: draft` despite PR #553 merge |
| MUTATION-CI-TIMEOUT drift item | Not present | NEW MEDIUM TRACKED |
| PG-PR-MANAGER-OVERREACH drift item | Not present | NEW MEDIUM TRACKED |
| JRACLOUD-27893 in CLAUDE.md | Not checked | NEW LOW observation |
| ADR-0013 staleness | Research date 2026-05-06 noted | 50 days — LOW reminder |

---

## Verdict

**PASS — no blocking findings.**

All automated spec guards (3/3 scripts exit 0 at 603 BCs). BC-7.2.012 (SEC-001 ADF recursion guard) is correctly and completely indexed across all PRD surfaces. The prior sweep's single finding (prd/README.md content drift) is RESOLVED. Two new MEDIUM drift items (MUTATION-CI-TIMEOUT, PG-PR-MANAGER-OVERREACH) are correctly tracked in STATE.md and have active story coverage.

Remaining findings are all MINOR or LOW:
- SC-002: S-MAINT-SEC-001 story file not updated to `status: delivered` / `bcs: [BC-7.2.012]` post-merge (cosmetic housekeeping)
- TD-001: F2-PIECEWISE-PROTOCOL drift table entry status ambiguous; consider closing
- RA-001: JRACLOUD-27893 undocumented in CLAUDE.md despite being test-pinned user-facing text
- RA-002: ADR-0013 PKCE deferral assumption not re-validated since 2026-05-06 (50 days)

No spec logic is broken. No gates are blocked. Factory is idle and healthy.
