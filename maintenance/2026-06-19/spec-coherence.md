---
document_type: maintenance-sweep
sweep: "7+8+11 — Spec Coherence, Tech Debt, Risk/Assumption Monitoring"
date: 2026-06-19
develop_head: 71f33c6
produced_by: consistency-validator
prior_run: maintenance/2026-06-17/spec-coherence.md
---

# Maintenance Sweep Report — 2026-06-19

Scope: Sweeps 7 (Spec Coherence), 8 (Tech Debt / Drift Items), 11 (Risk/Assumption Monitoring).
develop @ 71f33c6 (v0.6.0-dev.5). Authoritative counters per STATE.md: BC 599, NFR 42, ADR 16, Stories 83.
Prior run: 2026-06-17 @ 53f6d98.

---

## 1. COUNT GUARD RESULTS

| Script | Exit Code | Raw Output | Result |
|--------|-----------|------------|--------|
| `scripts/check-spec-counts.sh` | 0 | "OK: all spec counts verified." | **PASS** |
| `scripts/check-bc-cumulative-counts.sh` | 0 | "OK: all cumulative BC counts verified (599 total across 8 files; Surface H footer checked where present)." | **PASS** |
| `scripts/check-bc-no-numeric-test-counts.sh` | 0 | "OK: no numeric test counts in BC Trace/Source fields." | **PASS** |

All three count guards: **PASS**. No script-detectable surface disagrees with authoritative counters.

---

## 2. SPEC COHERENCE FINDINGS

### Finding SC-01-2026-06-19 — bc-02 L2 bc_count still 93; L3 total_bcs is 94

**Severity:** MINOR (new since 2026-06-17 run)
**Status:** OPEN — introduced by BC-2.4.043 addition on 2026-06-17

CANONICAL-COUNTS.md notes that bc-02 was "bumped 2026-06-17" to reflect BC-2.4.043 (Bundle C
CR-001 list_comments anti-stall guard). The L3 file frontmatter `total_bcs: 94` is correct.
However, the L2 domain-spec file was NOT updated:

| File | L2 bc_count | L3 total_bcs | Delta | Root Cause |
|------|------------|--------------|-------|------------|
| `specs/domain-spec/bc-02-issue-read.md` | 93 | 94 | -1 | BC-2.4.043 added 2026-06-17 |

All other L2/L3 pairs are aligned (bc-01: 57/57, bc-03: 107/107, bc-04: 32/32, bc-05: 35/35,
bc-06: 42/42, bc-07: 90/90).

**Remediation:** Single-line frontmatter edit: `bc_count: 93` → `bc_count: 94` in
`.factory/specs/domain-spec/bc-02-issue-read.md`. No code change. The CANONICAL-COUNTS.md
L2/L3 alignment table should also be updated (currently says "YES (bumped 2026-06-17;
+1 BC-2.4.043 added 2026-06-17 Bundle C CR-001)" which implies alignment but the file
was not actually updated).

---

### Finding SC-02-2026-06-19 — README.md Document Map still shows 598; canonical is 599

**Severity:** LOW (pre-tracked as PG-A, now one further behind)
**Status:** OPEN — carry-forward from prior runs; missed BC-2.4.043 (+1)

`.factory/specs/prd/README.md` Document Map:
- Line shows `bc-2-issue-read.md` as "(93)" — should be "(94)"
- BC-INDEX.md total shown as "598" — should be "599"
- "Total BCs in PRD" prose shows "598" — should be "599"
- The BC-2.4.043 addition (2026-06-17 Bundle C) is absent from the prose delta list

The README Document Map has never been updated since the PG-A gap was first identified
(prior to 2026-06-17). It is now 1 further BC behind the canonical total.

**Remediation:** Manual edit of `.factory/specs/prd/README.md`. Batch with next README
update pass to fix all stale entries at once (tracked as PG-A).

---

### Prior run findings that remain OPEN (no change since 2026-06-17)

| Finding | Status | Change since 2026-06-17 |
|---------|--------|--------------------------|
| SC-03 (ADR-0015 in docs/adr/, not .factory/adr/) | OPEN | No change. `docs/adr/0015-proactive-resolution-enforcement.md` still in docs/adr/ only; no .factory copy. |
| SC-04 (ADR-0016 divergence — CI-Gate note missing) | VERIFY NEEDED | diff not run in this sweep; prior run confirmed 3-line divergence. |
| SC-05 (4 code-delivery story.md files not in STORY-INDEX) | OPEN LOW | No change; historical known gap. |
| SC-06 (S-3.07 + R-NEW-S307-1 cite stale JRACLOUD tickets) | PARTIALLY RESOLVED | Risk register now cites JRACLOUD-95368 (corrected per CLAUDE.md); S-3.07 story body not checked in this sweep. |
| SC-07 (risk register FIX-IN-PHASE-3 RESOLVED annotation staleness) | PARTIALLY RESOLVED | Major risks R-C1, R-H1..R-H6, R-L12, R-L13, R-NEW-AR-1..5, R-NEW-S307-1 now have RESOLVED annotations. R-H288-1 still says "FIX-BEFORE-MERGE" with no RESOLVED annotation despite PR #381 merging 2026-05-19. R-M288-1 still says "FIX-IN-PHASE-4". See Section 4 for full risk register assessment. |

---

### New findings compared to prior run

**Resolved since 2026-06-17:**
- SC-01 (L2 bc_count stale for bc-03, bc-06, bc-07) — RESOLVED per CANONICAL-COUNTS.md note and confirmed bc_count values: bc-03=107, bc-06=42, bc-07=90 all match L3.
- FORK-OPS-GITLEAKS-DOC — RESOLVED: `GITLEAKS_DISABLED` documented in CLAUDE.md per PR #538 / f85647b.
- FORK-OPS-SIGN-INJECTION (HIGH) — RESOLVED: CWE-77 fixed in PR #535 / 1a2a79b.
- FORK-OPS-ALPHA-RACE (HIGH) — RESOLVED: atomic alpha-tag fixed in PR #535 / 1a2a79b.

**New since 2026-06-17:**
- SC-01-2026-06-19: bc-02 L2 bc_count=93 vs L3=94 (BC-2.4.043 not propagated to L2 domain-spec).
- SC-02-2026-06-19: README.md total count one further behind at 598 vs canonical 599.
- LOC drift: CANONICAL-COUNTS.md claims auth.rs=1,397 LOC; actual `wc -l src/api/auth.rs` = 1,875. An increase of 478 LOC (+34%) since last measurement. CLAUDE.md does not document auth.rs LOC. list.rs is claimed as 1,083 in CANONICAL-COUNTS.md but CLAUDE.md correctly states 1,256 (post-split count). CANONICAL-COUNTS.md list.rs entry is stale.

---

## 3. TECH DEBT / DRIFT ITEMS REVIEW

The current STATE.md Drift Items table (as of 71f33c6) contains 25 open items. All items from
the 2026-06-17 run that were HIGH severity have been resolved. The table now contains only LOW items.

### 3.1 Items resolved since 2026-06-17 (should note for next STATE.md compact)

| ID | Resolution | Date |
|----|-----------|------|
| FORK-OPS-SIGN-INJECTION (HIGH) | PR #535 / 1a2a79b — CWE-77 env-binding rewrite; 23 injection sites cleaned | 2026-06-18 |
| FORK-OPS-ALPHA-RACE (HIGH) | PR #535 / 1a2a79b — atomic alpha-tag via gh api git/refs | 2026-06-18 |
| FORK-OPS-GITLEAKS-DOC (MED) | PR #542 / f85647b — GITLEAKS_DISABLED documented in CLAUDE.md | 2026-06-19 |

### 3.2 Per-item disposition table (all 25 current items)

| # | ID | Area | Disposition | Rationale |
|---|----|----- |-------------|-----------|
| 1 | MAINT-2026-06-17-SC-03 | ADR location | KEEP-OPEN | `docs/adr/0015-proactive-resolution-enforcement.md` still exists only in docs/adr/. Discrepancy from factory-adr convention is cosmetic but persistent. Deferred per last maintenance. |
| 2 | MAINT-HOLDOUT-H007-DRIFT | Holdout H-007 | KEEP-OPEN / candidate for PROMOTE-TO-STORY | H-007 tests reactive behavior (400 from POST). ADR-0015 implemented proactive pre-flight (BC-3.2.013). H-007 + H-027 + H-044 should be updated/augmented with a proactive-path holdout. Minor but spec-to-test drift. |
| 3 | FORK-OPS-PHANTOM-RUNS | Phantom workflow runs | KEEP-OPEN | sign-and-publish.yml triggers on `push: branches: [develop]` AND `workflow_run: workflows: ["Release"]`. Develop pushes fire both paths. ~7 phantom runs/day is real and ongoing. Cosmetic but consumes GitHub Actions minutes. Decision to suppress or accept is human's. |
| 4 | WIN-CFG-TESTS-CHECK | Cross-compile | KEEP-OPEN | `cargo check --all-features` (not `--tests`) in CI confirms the gap. `#[cfg(test)]`-gated code in `src/` may not be type-checked for Windows cross-compile target. Low risk today (test code is test-only), but worth addressing. |
| 5 | SEC-JR-SERVICE-NAME-GATE | JR_SERVICE_NAME | KEEP-OPEN | Confirmed: `src/api/auth.rs` reads `JR_SERVICE_NAME` with no `#[cfg(debug_assertions)]` gate. Unlike `JR_BASE_URL`/`JR_AUTH_HEADER`, this env var works in release builds. Security impact is low (service name, not credentials), but it violates the established gate-all-seams pattern. |
| 6 | WIN-DENY-FRAGILITY | deny.toml | KEEP-OPEN | No CI guard verifies `deny.toml` skipped versions match current Cargo.lock. Fragility class: manually skipped multiple-versions drift silently. |
| 7 | WIN-AUTH-ENVLOCK-POISON | ENV_LOCK poison | KEEP-OPEN | `.lock().unwrap()` in auth tests can panic on poison. `unwrap_or_else(|p| p.into_inner())` is the safe idiom. Low actual risk (tests are isolated), but a poisoned lock would produce a confusing panic rather than a test failure. |
| 8 | E2E-PG-4 | E2E coverage gap | KEEP-OPEN | No `jr remote-link read` command exists; remote-link round-back uncoverable. Pre-existing gap. |
| 9 | DRIFT-331-PAGINATION | get_issue_types_for_project | KEEP-OPEN | Inline offset-pagination reimplementation in `src/api/jira/issues.rs`. Target: reuse `OffsetPage<T>`. Cleanup-class. |
| 10 | PG-A / DRIFT-README | Count guards | KEEP-OPEN | README.md Document Map stale (598 vs 599; bc-2 shows 93 vs 94). `check-bc-cumulative-counts.sh` does not check README. Now one further behind after BC-2.4.043 (SC-02-2026-06-19). |
| 11 | SEC-001 | CWE-674 recursion | KEEP-OPEN | Uncontrolled recursion in `adf.rs`: `normalize_panel_content`, `assign_local_ids`, `render_node`. No depth cap. Exploitable only via malicious ADF from Jira API (attacker-controlled Jira instance). Risk is LOW given trust model but class is real. |
| 12 | WIN-PG-1 | No BC-count CI guard | KEEP-OPEN | No automated check for inline-prose BC count references. 3rd recurrence of JR_*-doc-fallout pattern. |
| 13 | WIN-PG-2 | Story template | KEEP-OPEN | Story template missing presence-only-test disclosure field. Next story-writer pass should add it. |
| 14 | WIN-RUNTIME-OAUTH-PROBE | Windows OAuth probe | KEEP-OPEN (accepted) | Release OAuth verification is constants-file check only; no runtime `jr auth status`. Accepted per ADR-0016. |
| 15 | WIN-AC004-DIRECTIONAL | XDG→JR seam-migration | KEEP-OPEN | Enforcement test has directional blind spot for cross-platform seam migration. Low risk today. |
| 16 | F7-001..F7-003 | Minor precision gaps | KEEP-OPEN (ACCEPTED-DEFERRED) | CLAUDE.md symmetric label; F2-record archival note; BC-7.2.011 "13 tests" — all cosmetic. No action needed unless reopened by new work. |
| 17 | #492-TEST-HARNESS-COUPLING | process-gap | KEEP-OPEN (TRACKED DEFERRAL) | Handler-level block-HTML tests couple to `push_text` shape. Low fragility risk given test stability. |
| 18 | #492-PG-TRACE-TESTS | process-gap | KEEP-OPEN (TRACKED DEFERRAL) | No CI check that BC Source/Trace-cited test symbols resolve to real `#[test]` fns. |
| 19 | LESSON-F2-WORKTREE-FIRST | process-gap | KEEP-OPEN (DEFERRED) | Codified in lessons.md. Recurrence risk is behavioral, not structural. |
| 20 | KEYRING-GUARD-IDIOM-DRIFT | process-gap | KEEP-OPEN (DEFERRED) | Three co-existing keyring-gate guard idioms. No meta-test enforces canonical form. |
| 21 | CITATION-FORM-DISCIPLINE | process-gap | KEEP-OPEN (DEFERRED) | Bare file:NN citations recur vs #408 symbol-form convention. No CI guard. |
| 22 | F7-COSMETIC-ATTR-ORDER | cosmetic | KEEP-OPEN (ACCEPTED-COSMETIC) | Attribute ordering cosmetic; accepted. |
| 23 | #532-COVERAGE-FOLLOW-UP | coverage-gap | KEEP-OPEN | Issue #532 still OPEN. Login/Refresh/Logout global-`--profile` fallback ungated. |
| 24 | FORK-OPS-COMPOSITE-ACTION-SCAN | sign-and-publish.yml | KEEP-OPEN (justified deferral) | No local composite actions today; no false negatives. |
| 25 | FORK-OPS-HEADBRANCH-EMPTY-GUARD | sign-and-publish.yml | KEEP-OPEN | Theoretical CWE-74 on empty `head_branch`. Future story when signing enabled. |
| 26 | FORK-OPS-ALPHA-ORPHAN-CLEANUP | sign-and-publish.yml | KEEP-OPEN | Orphaned alpha tags from failed signing runs. Future housekeeping. |
| 27 | FORK-OPS-BACKFILL-ZIP-GLOB-COUPLING | backfill-release.yml | KEEP-OPEN (accepted) | Confirmed: `jr-*.zip` glob still in workflow (lines 174, 219, 229). Accepted; guarded by needs:build + matrix-parity test. |
| 28 | FORK-OPS-F5-SELFTEST-CHECKLIST | process-gap | KEEP-OPEN | F5 checklist wording ambiguity. |
| 29 | FORK-OPS-BACKFILL-TIMEOUT-PARITY | backfill-release.yml | KEEP-OPEN | Confirmed: `backfill-release.yml` has no `timeout-minutes` entries. `release.yml` uses 60-minute timeout on build jobs. Gap is real and minor. |

**Items recommending action (beyond KEEP-OPEN as-is):**

| Priority | ID | Action |
|----------|----|--------|
| Next maintenance doc-pass | PG-A / DRIFT-README + SC-01-2026-06-19 | Update README.md bc-2 count from 93→94, total from 598→599; update bc-02 domain-spec bc_count from 93→94. Two-file edit. |
| Next maintenance doc-pass | MAINT-HOLDOUT-H007-DRIFT | Augment H-007 to test proactive pre-flight path (exit 64 BEFORE POST) matching BC-3.2.013/ADR-0015. Update BC refs from BC-3.2.009 to include BC-3.2.013. |
| Next maintenance doc-pass | LOC drift new (not in table) | CANONICAL-COUNTS.md: update list.rs from 1,083 to 1,256; update auth.rs from 1,397 to 1,875. Two-entry table edit. |
| Next feature cycle | FORK-OPS-BACKFILL-TIMEOUT-PARITY | Add `timeout-minutes: 60` to backfill-release.yml build job. One-line CI fix. |
| Future security story | SEC-JR-SERVICE-NAME-GATE | Add `#[cfg(debug_assertions)]` gate to `service_name()` in `src/api/auth.rs`. |
| Future security story | SEC-001 (CWE-674) | Add depth counters to `normalize_panel_content`, `assign_local_ids`, `render_node` in `adf.rs`. |

**Items that are quick doc-fixes (no code change):** PG-A, SC-01-2026-06-19, H-007 BC refs update, CANONICAL-COUNTS.md LOC entries.

**Items requiring code change:** SEC-JR-SERVICE-NAME-GATE, SEC-001, FORK-OPS-BACKFILL-TIMEOUT-PARITY, WIN-CFG-TESTS-CHECK, WIN-AUTH-ENVLOCK-POISON, #532-COVERAGE-FOLLOW-UP.

---

## 4. RISK / ASSUMPTION MONITORING

### 4.1 HIGH risks — current status

| Risk ID | Description | Severity | Phase 4 Action (in register) | Current Status |
|---------|-------------|----------|------------------------------|----------------|
| R-H288-1 | Developer Console scope coordination for `write:servicedesk-request` | HIGH | "FIX-BEFORE-MERGE: Register… validate with `jr auth login --oauth`" | STALE ANNOTATION — PR #381 merged 2026-05-19. No `invalid_scope` regressions observed. E2E JSM tests pass. Risk mitigated in practice. Register annotation lacks RESOLVED marker. |

All other HIGH risks (R-H1..R-H6) are confirmed RESOLVED in the register. No new HIGH risks observed.

### 4.2 MEDIUM risks — validity check

| Risk ID | Description | Valid? | Notes |
|---------|-------------|--------|-------|
| R-M0 | `--verbose` body PII | RESOLVED | `--verbose` is now header-only (SD-003 breaking change per CLAUDE.md); body requires `--verbose-bodies`. Register may not reflect this resolution. |
| R-M1 | No PKCE in OAuth | STILL VALID (accepted) | ADR-0013 defers PKCE. No change. |
| R-M2 | first-result-wins `accessible_resources` | STILL VALID | `src/api/auth.rs` still uses first-result-wins. Issue #429 open but deferred (DEC-029). |
| R-M4 | worklog 8h/day hardcode | RESOLVED in register | R-M4 resolved via S-2.06/PR #308. Confirmed in register. |
| R-M5 | list.rs LOC past shard threshold | STILL VALID | list.rs = 1,256 LOC (CLAUDE.md documented). ADR-0012 shard rule applies to future additions. |
| R-M6 | auth.rs LOC — largest file | STILL VALID but drift | auth.rs = 1,875 LOC (register claims 1,998; CANONICAL-COUNTS.md claims 1,397; CLAUDE.md omits). Actual LOC has grown vs register figure. |
| R-M7 | ADF round-trip lossy for mention/emoji | STILL VALID | `adf_to_text` still has `_` fallthrough for unsupported node types. |
| R-M8 | `--internal` flag no-ops on non-JSM | STILL VALID (accepted) | DOCUMENT-AS-IS per register. |
| R-M288-1 | `--request-type` dispatch fork regression | STALE ANNOTATION | Action says "FIX-IN-PHASE-4" but issue #288 PRs are all merged. Risk was monitored and mitigated. Register annotation is stale. |

### 4.3 LOW risks — spot-check

| Risk ID | Status | Notes |
|---------|--------|-------|
| R-L1 | STILL VALID (accepted) | Per-profile cache is convention-only; ADR-0011 defers the `Profile(String)` newtype. |
| R-L2 | STILL VALID | `get_changelog` has anti-loop guard; `search_issues` cursor loop has an anti-loop guard added via S-3.07. R-L2 describes a pre-S-3.07 state — register annotation should note partial resolution. |
| R-L9 | STILL VALID | `parse_duration` `checked_mul` not added; silent wrap on pathological input remains. |
| R-NEW-S307-1 | RESOLVED in register | Citation corrected to JRACLOUD-95368 (confirmed in register text). |

### 4.4 R-M0 staleness — notable gap

R-M0 (`--verbose` body PII) was originally mitigation SECURITY-DECIDE, planning a
`redact_body()` helper. The actual resolution was SD-003 (header-only `--verbose`, body
requires `--verbose-bodies` with PII warning). The risk register Phase 4 Action still reads
"SECURITY-DECIDE: Add `redact_body()` helper; or default verbose to header-only with
`--verbose-bodies` opt-in" with no RESOLVED annotation despite the implementation being
shipped. The register does not have a RESOLVED line for R-M0.

**Recommended annotation:** "RESOLVED — SD-003 MERGED: `--verbose` is now header-only;
body inspection requires `--verbose-bodies` with explicit PII warning. Breaking change
documented in CLAUDE.md."

### 4.5 No formal ASM records

As in prior runs, no formal ASM (Assumption) register exists in `.factory/specs/`. Assumptions
are embedded in story ACs and research notes. Consistent with BROWNFIELD mode; no action needed.

### 4.6 New risks to consider (not yet in register)

| Candidate | Description | Severity Estimate | Recommendation |
|-----------|-------------|-------------------|----------------|
| LOC drift — auth.rs | auth.rs at 1,875 LOC is 478 LOC (+34%) more than CANONICAL-COUNTS.md claims (1,397). R-M6 in register cites 1,998 LOC (pre-shard figure). True LOC unknown without re-verification. | LOW | Update CANONICAL-COUNTS.md; verify R-M6 description is still accurate. |
| JR_SERVICE_NAME ungated | `service_name()` reads `JR_SERVICE_NAME` in release builds; violates gate-all-seams policy. SEC-JR-SERVICE-NAME-GATE drift item. | LOW | Add debug gate or accept and document (DOCUMENT-AS-IS). |

---

## 5. SUMMARY

### 5.1 Count guard results

| Check | Result |
|-------|--------|
| `scripts/check-spec-counts.sh` | **PASS** (exit 0) |
| `scripts/check-bc-cumulative-counts.sh` | **PASS** (exit 0; 599 total) |
| `scripts/check-bc-no-numeric-test-counts.sh` | **PASS** (exit 0) |
| STATE.md authoritative counters (BC 599 / NFR 42 / ADR 16 / Stories 83) | **VERIFIED** — BC-INDEX total_bcs=599, nfr-catalog count=42, unique ADR count=16, STORY-INDEX total_stories=83 |

All count guards pass. No blocking count discrepancies.

### 5.2 Coherence findings summary

| ID | Description | Severity | Fix Type |
|----|-------------|----------|----------|
| SC-01-2026-06-19 | bc-02 L2 bc_count=93; L3=94 (BC-2.4.043 not propagated) | MINOR | Docs-only, 1 line |
| SC-02-2026-06-19 | README.md total=598, bc-2 entry=93; canonical=599/94 | LOW | Docs-only, 3 lines |
| SC-03 (carry) | ADR-0015 only in docs/adr/, not .factory/adr/ | LOW | Decision needed |
| SC-04 (carry) | ADR-0016 may still have CI-Gate note divergence | MINOR | 3-line addition |
| SC-05 (carry) | 4 code-delivery story.md files not in STORY-INDEX | LOW | Optional backfill |
| LOC drift (new) | CANONICAL-COUNTS.md list.rs=1,083 (actual 1,256); auth.rs=1,397 (actual 1,875) | LOW | Docs-only, 2 rows |

**No CRITICAL or MAJOR coherence violations. No L1→L4 chain breaks. All count guards pass.**

### 5.3 Drift items — action summary

| Category | Count | Notes |
|----------|-------|-------|
| HIGH items RESOLVED since last run | 2 | FORK-OPS-SIGN-INJECTION, FORK-OPS-ALPHA-RACE |
| MED items RESOLVED since last run | 1 | FORK-OPS-GITLEAKS-DOC |
| Current table total | 25 (per STATE.md) + 4 additional noted in SC-findings | All LOW |
| Recommend KEEP-OPEN as-is | 18 | No near-term action |
| Recommend doc-fix (next maintenance) | 5 | PG-A/README, SC-01, H-007 BC refs, LOC drift entries, FORK-OPS-BACKFILL-TIMEOUT-PARITY |
| Recommend code story (future cycle) | 3 | SEC-JR-SERVICE-NAME-GATE, SEC-001, #532-COVERAGE-FOLLOW-UP |
| No items recommend RESOLVE (close without action) | 0 | — |

### 5.4 Risk/assumption staleness summary

| Category | Count | Notes |
|----------|-------|-------|
| Risks with stale RESOLVED annotation (gap) | 3 | R-M0 (--verbose→SD-003), R-H288-1 (JSM scope), R-M288-1 (dispatch fork) |
| Risks still valid and correctly tracked | 9 | R-M1, R-M2, R-M5, R-M6, R-M7, R-M8, R-L1, R-L9, R-L11 |
| Risks confirmed RESOLVED in register | 14 | R-C1, R-H1..H6, R-L12, R-L13, R-NEW-AR-1..5, R-NEW-S307-1, R-M4 |
| New risk candidates identified | 2 | LOC drift / auth.rs, JR_SERVICE_NAME gate |
| ASM records | 0 | None in brownfield corpus; expected |

### 5.5 Top items to address (priority order)

1. **SC-01-2026-06-19 + PG-A/README** (combined): bc-02 domain-spec bc_count and README.md counts. Four-file, six-line docs-only fix. Low effort, high precision value.
2. **H-007 BC refs update**: Add BC-3.2.013 to holdout H-007 (and consider augmenting to test proactive path, not just reactive). One file, spec-only.
3. **CANONICAL-COUNTS.md LOC entries**: Update list.rs from 1,083→1,256 and auth.rs from 1,397→1,875. Two-row table edit.
4. **Risk register annotations**: Add RESOLVED to R-M0, R-H288-1, R-M288-1. Three-row annotation additions.
5. **FORK-OPS-BACKFILL-TIMEOUT-PARITY**: Add `timeout-minutes: 60` to backfill-release.yml build job. One-line CI edit; eligible for next ci/chore PR.

---

## 6. OVERALL COHERENCE VERDICT

**PASS — Factory may proceed to next cycle.**

All automated count guards pass. No CRITICAL or MAJOR violations in spec chain, cross-artifact
consistency, or L1→L4 traceability. The two HIGH security drift items from the 2026-06-17 run
have been resolved (PR #535). Zero HIGH or CRITICAL items remain open. The 25 open drift items
are all LOW severity. The three risk register annotation gaps (R-M0, R-H288-1, R-M288-1) are
cosmetic staleness, not active risks.

Recommended next maintenance window: address SC-01-2026-06-19, README counts, H-007 BC refs,
CANONICAL-COUNTS.md LOC entries, and risk register RESOLVED annotations as a single small
docs-only patch (no code change required).
