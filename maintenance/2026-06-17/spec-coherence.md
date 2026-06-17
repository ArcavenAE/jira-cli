---
document_type: maintenance-sweep
sweep: "7+8+11 — Spec Coherence, Tech Debt, Risk/Assumption Monitoring"
date: 2026-06-17
develop_head: 53f6d98
produced_by: consistency-validator
---

# Maintenance Sweep Report — 2026-06-17

Scope: Sweeps 7 (Spec Coherence), 8 (Tech Debt / Drift Items), 11 (Risk/Assumption Monitoring).
develop @ 53f6d98. Authoritative counters per STATE.md: BC 598, NFR 42, ADR 16, Stories 77.

---

## 1. COUNT GUARD RESULTS

| Script | Exit Status | Result |
|--------|-------------|--------|
| `scripts/check-spec-counts.sh` | 0 | **PASS** — "OK: all spec counts verified." |
| `scripts/check-bc-cumulative-counts.sh` | 0 | **PASS** — "OK: all cumulative BC counts verified (598 total across 8 files; Surface H footer checked where present)." |
| `scripts/check-bc-no-numeric-test-counts.sh` | 0 | **PASS** — "OK: no numeric test counts in BC Trace/Source fields." |

All three count guards: **PASS**. No script-detectable surface disagrees with authoritative counters.

---

## 2. SPEC COHERENCE FINDINGS

### Finding SC-01 — L2 bc_count values stale for 4 domain-spec files

**Severity:** MINOR (cosmetic drift; all 4 are documented PENDING in CANONICAL-COUNTS.md)
**Fix:** Manual update to L2 domain-spec frontmatter

Current mismatches (L2 `bc_count` vs L3 `total_bcs`):

| L2 File | L2 bc_count | L3 total_bcs | Delta | Root Cause |
|---------|------------|--------------|-------|------------|
| `specs/domain-spec/bc-02-issue-read.md` | 92 | 93 | -1 | BC-2.6.051 added 2026-05-14 (#365 F2) |
| `specs/domain-spec/bc-03-issue-write.md` | 77 | 107 | -30 | 30 BCs added across multiple feature cycles (BC-3.4.009/010-011/012-014/015-017/018-019, BC-3.2.013/014, BC-3.8.001-017) |
| `specs/domain-spec/bc-06-config-cache.md` | 39 | 42 | -3 | BC-6.1.014 + BC-6.2.016..017 added 2026-06-12 (windows-build F2) |
| `specs/domain-spec/bc-07-output-render.md` | 85 | 90 | -5 | BC-7.2.007..008 (#474), BC-7.2.009 (#483), BC-7.2.010 (#471), BC-7.2.011 (#492) added 2026-06-08..15 |

All four are pre-documented as PENDING in CANONICAL-COUNTS.md (`last_verified: 2026-06-17`). No scripts check L2 bc_count alignment. The bc-03 gap (-30) is the largest and most stale — rooted in the brownfield Feature Mode expansion of the Issue Write bounded context over the entire Phase 3 cycle.

**Remediation:** Manual edit of frontmatter `bc_count` in each L2 file to match L3 `total_bcs`. No code change; docs-only.

---

### Finding SC-02 — README.md Document Map has stale BC counts (tracked as PG-A)

**Severity:** LOW (pre-existing; already tracked as drift item PG-A in STATE.md)
**Fix:** Manual update to `specs/prd/README.md`

The README.md Document Map in `.factory/specs/prd/README.md` carries counts frozen at approximately Pass 3 + early feature additions. Current stale values:

| Entry | README value | Canonical value | Drift |
|-------|-------------|-----------------|-------|
| bc-3-issue-write.md BC count | 93 | 107 | -14 |
| bc-6-config-cache.md BC count | 39 | 42 | -3 |
| bc-7-output-render.md BC count | 84 | 90 | -6 |
| cross-cutting.md BC count | 140 | 142 | -2 |
| BC-INDEX.md total | 573 | 598 | -25 |
| nfr-catalog.md NFR count | 41 | 42 | -1 |
| Total BCs in PRD (prose) | 573 | 598 | -25 |

This is the specific discrepancy CANONICAL-COUNTS.md noted: "Document Map grand total 573 vs canonical 587" (now 598). No automated guard checks README.md counts (gap: `check-bc-cumulative-counts.sh` misses README.md, tracked in PG-A).

**Remediation:** Manual edit of `.factory/specs/prd/README.md` Document Map table and prose total.

---

### Finding SC-03 — ADR-0015 placement inconsistency

**Severity:** MINOR
**Fix:** Documentation clarification or file relocation

ADR-0015 (`0015-proactive-resolution-enforcement.md`) lives in `docs/adr/` (same directory as the original brownfield ADRs 0001-0006). All other factory-created ADRs 0007-0014 and 0016 are in `.factory/architecture/adr/`. The adr-index.md link path for ADR-0015 is `../../../docs/adr/0015-proactive-resolution-enforcement.md` — not the pattern used by 0007-0014 and 0016.

CANONICAL-COUNTS.md lists "ADR-0007..0013: in `.factory/architecture/adr/`" but does not explicitly state where 0014-0016 reside, so no script detects the inconsistency.

**Remediation:** Either move `docs/adr/0015-proactive-resolution-enforcement.md` to `.factory/architecture/adr/` (updating the adr-index link), or add an explicit note in CANONICAL-COUNTS.md that 0015 lives in `docs/adr/` by convention.

---

### Finding SC-04 — ADR-0016 exists in two locations with divergent content

**Severity:** MINOR
**Fix:** Manual merge; delete one copy

`ADR-0016` exists in both:
- `docs/adr/0016-windows-build-target.md` (newer — contains a CI-Gate `S-CIGATE-1` paragraph added after the windows-build cycle)
- `.factory/architecture/adr/0016-windows-build-target.md` (older — missing the CI-gate note)

The `diff` shows a 3-line trailing section absent from the `.factory` copy:

```
CI gate (S-CIGATE-1): `ci-gate` (job name "CI Gate") is the single required
branch-protection status check for `develop` and `main`; add new mandatory CI
jobs to `ci-gate.needs`, not to branch protection directly.
```

The `adr-index.md` links to the `.factory/architecture/adr/` copy (`adr/0016-windows-build-target.md`), so the index-linked canonical copy is the stale one.

**Remediation:** Apply the CI-Gate note to `.factory/architecture/adr/0016-windows-build-target.md`, then decide whether `docs/adr/0016-windows-build-target.md` should be removed (duplicate) or kept as a reader-friendly mirror. If removed, update any external links.

---

### Finding SC-05 — STORY-INDEX file count vs total_stories

**Severity:** LOW (structural; already self-documented in STORY-INDEX)
**Fix:** Awareness only; no action needed

`STORY-INDEX.md` declares `total_stories: 77` and the Story Manifest lists 77 rows. However, `find .factory/stories -name "*.md" ! -name "STORY-INDEX.md" ! -name "WAVE-PLAN.md"` returns **73 files**. The remaining 4 story files live in `.factory/code-delivery/`:

- `code-delivery/issue-288-pr1-api/story.md`
- `code-delivery/issue-288-pr2-cli/story.md`
- `code-delivery/issue-288-pr4-dispatch/story.md`
- `code-delivery/issue-340/story.md` (plus issue-345, 346, 331, 333, 350, 365 — 10 total)

Wait: code-delivery has 10 story.md files but only 6 are in the 77-count manifest (S-340/345/346 + 3 issue-288-pr*). The remaining 4 (issue-331/333/350/365) are additional story.md files in code-delivery that are **not** referenced in the STORY-INDEX manifest.

Actual file distribution:
- `.factory/stories/` directory: 73 story .md files (excl. index/plan)
- `.factory/code-delivery/` story.md files in index: 6 (S-340, S-345, S-346, issue-288-pr1/pr2/pr4)
- `.factory/code-delivery/` story.md files NOT in index: 4 (issue-331, issue-333, issue-350, issue-365)

The 4 non-indexed code-delivery story.md files represent story artifacts created during feature cycles that predate the STORY-INDEX convention of adding all stories to the manifest. This is a known historical pattern, not an active corruption.

**Remediation:** No urgent action. If desired, add the 4 code-delivery entries to the STORY-INDEX Story Manifest as retroactive entries (wave: feature-followup, status: completed/merged) to make the file count fully auditable.

---

### Finding SC-06 — S-3.07 story cites stale JRACLOUD tickets (pre-corrected by #361/PR #364)

**Severity:** LOW
**Fix:** Documentation update to S-3.07 story file

The S-3.07 story file (`.factory/stories/wave-3/S-3.07-low-nfr-code-fixes-and-search-jql-anti-loop.md`) and the risk register entry R-NEW-S307-1 both cite `JRACLOUD-94632, JRACLOUD-92049, JRACLOUD-85546` as the confirmed bug tickets for the `/rest/api/3/search/jql` repeated-nextPageToken issue.

CLAUDE.md explicitly states (load-bearing gotcha): "repeated-`nextPageToken` = **JRACLOUD-95368** (live-data drift between page fetches), NOT -94632/-92049/-85546 — those three are misattributed (verified, issue #361/PR #364)." The `JRACLOUD-95368` literal is pinned by two test files.

The code was corrected in PR #364, but the spec artifact (S-3.07 story title, body text) and risk register entry R-NEW-S307-1 still reference the superseded ticket IDs. This creates a misleading citation in the spec corpus.

**Files needing update:**
- `.factory/stories/wave-3/S-3.07-low-nfr-code-fixes-and-search-jql-anti-loop.md` — title and body cite JRACLOUD-94632/-92049/-85546
- `.factory/architecture/risk-register.md` — R-NEW-S307-1 body cites JRACLOUD-94632/-92049/-85546

**Remediation:** Replace the three stale ticket IDs with JRACLOUD-95368 in both files. Add "corrected from -94632/-92049/-85546 per issue #361/PR #364" note. No code change required.

---

### Finding SC-07 — Risk register lacks "RESOLVED" annotations for all Phase 3 FIX-IN-PHASE-3 items

**Severity:** LOW (informational; see detail under Risk/Assumption section)

See Section 4 (Risk/Assumption Monitoring) for the full breakdown.

---

## 3. TECH DEBT / DRIFT ITEMS REVIEW

### 3.1 HIGH severity items (gate-blocking)

| ID | Description | Age (approx) | Status |
|----|-------------|--------------|--------|
| FORK-OPS-SIGN-INJECTION | Shell injection in sign-and-publish.yml (CWE-77) | ~2 days (added 2026-06-15) | OPEN — gates signing |
| FORK-OPS-ALPHA-RACE | Non-atomic alpha-tag creation | ~2 days (added 2026-06-15) | OPEN — gates signing |

Both HIGH items were introduced with PR #520 (ci: opt-in release ops, 2026-06-15). Neither is >30 days old. Both correctly block signing enablement. No evidence of resolution; the signing workflow remains inert by default (controlled by `SIGNING_ENABLED` repo variable, unset in canonical repo).

**Status: OPEN, correctly tracked, not stale.**

---

### 3.2 Open drift items >30 days old (before 2026-05-18)

Based on content and context clues from STATE.md and burst-log:

| ID | Area | Age Estimate | Severity | Notes |
|----|------|--------------|----------|-------|
| OQ-5 | CLAUDE.md NFR-O-N stale (`auth status --output json` undocumented gap) | Since Wave 3 / ~2026-05-09 (S-3.08 PR #317) | LOW | Predates 2026-05-18; ~39 days old. Still valid gap. |
| E2E-PG-4 | E2E coverage gap (remote-link round-back) | Since ~2026-05-29 (E2E cycle) | LOW | ~19 days; borderline. No `jr remote-link read` command exists. |
| DRIFT-331-PAGINATION | `get_issue_types_for_project` inline pagination reimplementation | Since S-331 F2 (2026-06-01) | LOW | ~16 days |
| PG-A / DRIFT-README | README.md stale counts + check-bc-cumulative-counts.sh misses README.md | Since mid-Phase 3 | LOW | Likely >30 days; no explicit date. First noted in CANONICAL-COUNTS.md |
| SEC-001 | CWE-674 deep-nesting recursion in adf.rs | Since ~adf.rs introduction; earliest noting circa 2026-05-09 | LOW | Likely >30 days. Uncontrolled recursion in normalize/assign_local_ids/render_node. |
| WIN-PG-1 | No CI guard for inline-PROSE BC counts (3rd recurrence of JR_* doc-fallout) | Since windows-build F4 (2026-06-12) | LOW | ~5 days; not >30 days |
| WIN-PG-2 | Story-template lacks presence-only-test disclosure field | Since windows-build F4 | LOW | ~5 days; not >30 days |

**Items genuinely >30 days old:** OQ-5 (confirmed), PG-A (likely), SEC-001 (likely).

### 3.3 Drift items verified OPEN (no false resolutions)

Cross-checking all OPEN drift items against current code and PR history: no OPEN drift items have been silently resolved without being marked closed. All items marked OPEN remain genuinely unresolved:

- FORK-OPS-* items: sign-and-publish.yml workflows exist unchanged; signing is inert
- FORK-OPS-GITLEAKS-DOC: `GITLEAKS_DISABLED` variable not documented in CLAUDE.md (confirmed by grep — not present)
- OQ-5: `auth status --output json` multi-profile gap not implemented (confirmed)
- E2E-PG-4: No `jr remote-link read` command in src/ (confirmed)
- SEC-001: adf.rs recursion in `normalize_panel_content`, `assign_local_ids`, `render_node` is unchanged and uncapped

**No false-positive OPEN items found.**

### 3.4 Items potentially CLOSEABLE but still marked OPEN

None identified. The WIN-CI-GATE-AGGREGATOR item is correctly marked CLOSED (DEC-103).

---

## 4. RISK / ASSUMPTION MONITORING

### 4.1 Risk register staleness — Phase 3 actions marked FIX-IN-PHASE-3 but all resolved

**Severity:** LOW (cosmetic; all implementations confirmed shipped)

The risk register (`architecture/risk-register.md`) uses "FIX-IN-PHASE-3" as the Phase 3 Action for the following CRITICAL/HIGH risks, but all corresponding stories are now MERGED to develop:

| Risk | "Phase 3 Action" | Resolving Story | Status in STORY-INDEX |
|------|-----------------|-----------------|----------------------|
| R-C1 (multi-profile fields) | FIX-IN-PHASE-3: Config::field_id() accessor | S-0.04 | merged PR #292 |
| R-H1 (asset HashMap key) | FIX-IN-PHASE-3: change key to (String, String) | S-0.03 | merged PR #291 |
| R-H2 (JR_AUTH_HEADER gate) | SECURITY-DECIDE: #[cfg(debug_assertions)] gate | S-0.05 | merged PR #293 |
| R-H3 (handle_open URL) | FIX-IN-PHASE-3: base_url() → instance_url() | S-0.01 | merged PR #289 |
| R-H4 (list_worklogs pagination) | FIX-IN-PHASE-3: paginate_offset loop | S-0.02 | merged PR #290 |
| R-H5 (supply-chain deny) | FIX-IN-PHASE-3: enforce multiple-versions=deny | S-1.02 | merged PR #296 |
| R-H6 (GitHub Actions SHA pinning) | FIX-IN-PHASE-3: pin to commit SHAs | S-1.01 | merged PR #295 |
| R-L12 (CI job timeouts) | FIX-IN-PHASE-3: add timeout-minutes | S-1.04 | merged PR #298 |
| R-L13 (secrets scanning) | FIX-IN-PHASE-3: enable gitleaks CI | S-1.05 | merged PR #299 |
| R-M4 (worklog 8h/day hardcode) | FIX-IN-PHASE-3 | S-2.06 | merged PR #308 — R-M4 has inline RESOLVED note |
| R-NEW-AR-1..5 (auto-refresh risks) | FIX-IN-PHASE-3 (S-3.03 AC-009-011) | S-3.03 | merged in Wave 3 |
| R-NEW-S307-1 (search/jql anti-loop) | FIX-IN-PHASE-3 (S-3.07 AC-008) | S-3.07 | merged in Wave 3 |

R-M4 is the only risk with an inline RESOLVED annotation. All others retain "FIX-IN-PHASE-3" text with no completion marker.

**The risk register is a static spec artifact** (not auto-updated from story merge events), so this is expected drift in a brownfield VSDD project. It does not affect correctness — all implementations are in `develop` at HEAD. However, this creates confusion when reviewing the register for active concerns.

**Remediation:** Add "RESOLVED — <story-id> MERGED <PR#>" annotations to each completed row's Phase 3 Action column. Manual doc update; no code change.

---

### 4.2 R-H288-1 (Developer Console scope coordination) — validity check

**Severity:** LOW (confirmed handled before merge)

R-H288-1 (HIGH) requires that `write:servicedesk-request` be registered in the Atlassian Developer Console before PR #381 merges. Issue-288-pr4-dispatch story shows "completed (PR #381 / 95232555; merged 2026-05-19)". The story manifest does not show explicit evidence of the console registration checklist item being verified, but the PR merged without reported user-facing `invalid_scope` regressions and the E2E JSM tests pass.

The risk register still shows Phase 4 Action "FIX-BEFORE-MERGE" without a RESOLVED annotation. Per the pattern in SC-07/4.1 above, this is consistent cosmetic staleness.

**Status: Risk mitigated in practice; register annotation is stale.**

---

### 4.3 R-NEW-S307-1 — stale ticket citation (cross-reference to SC-06)

See Finding SC-06. The risk register entry for R-NEW-S307-1 cites JRACLOUD-94632/-92049/-85546, which are misattributed per CLAUDE.md gotcha (issue #361). The correct ticket is JRACLOUD-95368.

**Status: STALE CITATION — LOW severity.**

---

### 4.4 Active MEDIUM risks R-M2, R-M5, R-M6, R-M7, R-M8 — validity check

| Risk | Description | Validity as of 2026-06-17 |
|------|-------------|--------------------------|
| R-M2 (first-result-wins accessible_resources) | No --cloud-id flag, silent wrong-site auth | Still valid. `api/auth.rs` still uses first-result-wins. Feature backlogged (#429 related). |
| R-M5 (list.rs 1,083 LOC) | Past shard threshold | Still valid. CLAUDE.md "Known Size Deviations" documents this. No new shard spec. |
| R-M6 (auth.rs 1,997 LOC) | Largest single file | Still valid. No shard work done on auth.rs. |
| R-M7 (ADF round-trip lossy for mention/emoji) | Silently dropped nodes | Still valid. adf_to_text still has `_` fall-through for those nodes. |
| R-M8 (--internal flag no-ops on non-JSM) | Silent surprise | Accepted as DOCUMENT-AS-IS; still valid. |

All MEDIUM DEFERs remain genuinely open and match current architecture.

---

### 4.5 No ASM records found

The `.factory/` corpus does not contain a formal ASM (Assumption) register file. Assumptions are embedded inline within story acceptance criteria and research notes. No ASM-to-BC traceability matrix exists to audit. This is consistent with the BROWNFIELD mode where formal ASM records are not mandated.

---

## 5. SUMMARY

### Count guards: ALL PASS

| Check | Result |
|-------|--------|
| check-spec-counts.sh | PASS |
| check-bc-cumulative-counts.sh | PASS |
| check-bc-no-numeric-test-counts.sh | PASS |
| Authoritative counters (STATE.md) vs scripts | AGREE — BC 598, NFR 42, ADR 16, Stories 77 |

### Coherence findings: 7 total

| ID | Category | Severity | Automated Fix? | File(s) |
|----|----------|----------|---------------|---------|
| SC-01 | L2 bc_count stale (4 files) | MINOR | No — manual frontmatter edits | `specs/domain-spec/bc-02/03/06/07-*.md` |
| SC-02 | README.md Document Map stale counts | LOW (pre-tracked PG-A) | No — manual | `.factory/specs/prd/README.md` |
| SC-03 | ADR-0015 placement inconsistency | MINOR | No — decision needed | `docs/adr/` vs `.factory/architecture/adr/` |
| SC-04 | ADR-0016 duplicated + divergent (CI-Gate note missing from .factory copy) | MINOR | No — manual merge | `docs/adr/0016-windows-build-target.md` vs `.factory/architecture/adr/0016-windows-build-target.md` |
| SC-05 | 4 code-delivery story.md files not in STORY-INDEX manifest | LOW (historical) | No — retroactive entries optional | `.factory/code-delivery/issue-331/333/350/365/story.md` |
| SC-06 | S-3.07 + risk-register R-NEW-S307-1 cite stale JRACLOUD tickets | LOW | No — manual spec edit | `stories/wave-3/S-3.07-*.md`, `architecture/risk-register.md` |
| SC-07 / 4.1 | Risk register lacks RESOLVED annotations for all completed FIX-IN-PHASE-3 items | LOW | No — manual | `architecture/risk-register.md` |

**No CRITICAL or MAJOR coherence violations. No L1→L4 chain breaks. No BC orphans detectable from index-level scan. All count guards pass. Factory can proceed to next cycle.**

### Top items to address (priority order)

1. **SC-04** (ADR-0016 divergence): The `.factory`-canonical copy is missing the CI-Gate note that documents a standing architectural constraint. Fix is a 3-line addition. Low effort, high precision value.
2. **SC-06** (stale JRACLOUD citations): Misleads future contributors about a load-bearing spec detail. CLAUDE.md explicitly flags this as a citation-discipline concern. Fix is 2-file search-and-replace.
3. **SC-01** (L2 bc_count): The bc-03 gap (-30 BCs) is the most stale but is cosmetic only. A single sweep across 4 frontmatter fields.
4. **SC-02** (README.md counts): Pre-tracked as PG-A. Continue to defer until a dedicated doc-update pass.
5. **SC-07** (risk register RESOLVED annotations): Cosmetic completeness improvement. Batch update opportunity alongside next risk-register touch.
