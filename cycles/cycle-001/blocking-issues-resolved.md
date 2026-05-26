---
document_type: blocking-issues-resolved
level: ops
version: "1.0"
status: archive
producer: state-manager
timestamp: 2026-05-26T00:00:00
cycle: "cycle-001"
inputs: [STATE.md]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Resolved Blocking Issues — cycle-001

<!-- Blocking issues that were resolved and archived from STATE.md.
     Open blocking issues remain in STATE.md. -->

## Formerly in Blocking Issues table

*(The Blocking Issues table was empty at compact-state time — no open blockers at 2026-05-26.)*

## Resolved Drift Items (extracted from STATE.md Drift Items table on 2026-05-26 compact-state run)

These rows had Status = RESOLVED / CLOSED in STATE.md and are archived here. The Drift Items table in STATE.md retains only OPEN / DEFERRED / TO_VERIFY / process-gap / TRACKED / FILED entries.

| ID | Area | Description | Severity | Status | Resolved Date |
|----|------|-------------|----------|--------|---------------|
| DRIFT-002 | NFR-S-B holdout gap | SD-002 = Option A; NFR-S-B holdout now definable (S-1.05). | MEDIUM | **RESOLVED** | 2026-05-04 |
| ADV-P2-S12-001 | S-1.08 body line 274 stale dep | body line 274 updated to "No Wave 0 dependencies…" | MEDIUM | **RESOLVED** | 2026-05-07 |
| OBS-13-1 | JiraClient cosmetic typo | global sweep; 0 remaining matches | LOW | **RESOLVED** | 2026-05-07 |
| OBS-13-2 | Story manifest tooling gap | Story Manifest table (31 rows) added to STORY-INDEX v1.4.1 | LOW | **RESOLVED** | 2026-05-07 |
| CV2-001 | STATE.md stale story count | STATE.md line 54 fixed (30→31, W3:8→W3:9) | MEDIUM | **RESOLVED** | 2026-05-07 |
| CV2-002 | STORY-INDEX S-2.04 BC column incomplete | S-2.04 BC column completed (3→7 BCs); v1.4.2 | MEDIUM | **RESOLVED** | 2026-05-07 |
| CV2-003 | SD-003 holdout gap | H-NEW-VERBOSE-001/002 registered; WAVE-PLAN updated (v1.1.1); S-0.06 cross-link added | MEDIUM | **RESOLVED** | 2026-05-07 |
| S-0.05-DEV | SD-002 doc-vs-code drift (gate canonization) | SD-002 canonized to Option B-revised (`#[cfg(debug_assertions)]`) during S-0.05 implementation. 151-subprocess-test compatibility preserved. Threat model mitigation equivalent to Option A original. Doc updates: SD-002.md (Resolution, Options, Decision Log, version 1.0.1) + S-0.05 (Context, BC, ACs, Implementation Notes, Compliance Rules) + S-0.07 (Context, AC-004, holdout spec SD field) + STATE.md (DEC-007, Current Phase Steps). | MEDIUM | **RESOLVED** | 2026-05-07 |
| S-1.05-AC-001 | Repo-level GitHub Secret Scanning | User enabled secret_scanning + push_protection on Zious11/jira-cli via `gh api PATCH security_and_analysis` (2026-05-08). Verified via `gh api repos/Zious11/jira-cli --jq '.security_and_analysis'` showing both enabled. CI gitleaks job + GitHub native scanner now both active for layered defense. | HIGH | **RESOLVED** | 2026-05-08 |
| S-2.02-DEFER | JSON field-name reconciliation: `transitioned` vs `changed` | Verified canonical field name is `changed` per src/cli/issue/json_output.rs:4-10; documented in S-2.07 v2.0.0 AC-005 and DEC-011; holdout-scenarios.md:84 corrected to `"changed": false` in same factory-artifacts commit | LOW | **RESOLVED** | 2026-05-08 |
| S-2.06-DEFER-01 | src/duration.rs parse_duration calculator | H-018 replaced in place (Option 2) per research-agent recommendation; follow-up Option 4 story queued in Wave 3 as S-3.10 to delete the deprecated calculator. See `.factory/research/H-018-holdout-strategy-research.md`. | LOW | **RESOLVED** | 2026-05-08 |
| WV2-ADV-01 | S-2.07 spec + 11 test docstrings BC-7.3.004 semantic mis-anchor | Story spec re-anchored to BC-7.1.001 + BC-7.4.013-016 (Fix-PR A). Develop-side test docstring re-anchoring deferred as WV2-FIX-A-FOLLOWUP-01. | BLOCKING | **RESOLVED** — 2026-05-08 — Fix-PR A (spec portion resolved; test docstrings deferred as FOLLOWUP-01) | 2026-05-08 |
| WV2-ADV-03 | S-2.06 spec + 2 holdout test names BC-6.2.013 mis-anchor | Story spec re-anchored to BC-6.2.006 (Fix-PR A). Develop-side test name rename deferred as WV2-FIX-A-FOLLOWUP-02. | BLOCKING | **RESOLVED** — 2026-05-08 — Fix-PR A (spec portion resolved; test function names deferred as FOLLOWUP-02) | 2026-05-08 |
| WV2-CV-01 | .factory/specs/prd/cross-cutting.md:316 BC-X.5.005 H1 heading deprecated calculator | Updated to reflect post-S-2.06 dual-function situation (validator is production path). | BLOCKING | **RESOLVED** — 2026-05-08 — Fix-PR A | 2026-05-08 |
| WV2-CV-02 | .factory/stories/WAVE-PLAN.md stale status / S-3.10 gap | Wave 2 status was ACTIVE/draft; Wave 3 showed 9 stories without S-3.10; S-2.06→S-3.10 dependency missing. | DRIFT | **RESOLVED** — 2026-05-08 — Fix-PR A | 2026-05-08 |
| WV2-CV-05 | .factory/STATE.md Phase 3 progress count off-by-one | Phase 3 progress count audit: Wave 0 (7) + Wave 1 (8) + Wave 2 (7) = 22. STATE.md previously claimed 23/31 (74%). Corrected to **22/31 (71%)** in Wave 2 gate-close commit. | DRIFT | **RESOLVED** — 2026-05-08 — Wave 2 gate-close commit | 2026-05-08 |
| WV2-CV-07 | .factory/stories/STORY-INDEX.md + STATE.md S-2.02 SHA typo | SHA typo 75289600 → 7528960 in STATE.md. | DRIFT | **RESOLVED** — 2026-05-08 — Fix-PR A | 2026-05-08 |
| WV2-SEC-01 | src/duration.rs::parse_duration_validate CWE-400 uncontrolled resource consumption | Wave 2 integration-gate security finding. parse_duration_validate reflected unbounded user input into error messages. Added MAX_DURATION_INPUT_LEN = 64 byte cap + 2 regression-pin tests. Not exploitable; defense-in-depth. | MEDIUM | **RESOLVED** — 2026-05-08 — develop @ 6cb9994 (PR #310) | 2026-05-08 |
| PG-365-1 | BC Trace field stale-test-count pattern | BC body Trace fields cite test counts that drift as tests are added. First caught at P4 of #365 F1d. Eliminated numeric counts across bc-2, bc-3, bc-5, bc-7 (9 sites); CI guard `scripts/check-bc-no-numeric-test-counts.sh` added; `spec-guard` CI job wired in ci.yml. | LOW | **RESOLVED** — PR #369 @ 6ca9587 (2026-05-15) | 2026-05-15 |
| DRIFT-010 | risk-register.md header says "Total risks: 34" but Summary table says 36 | Resolved 2026-05-18 by #288 F1d pass-07: risk-register.md lines 5-6 updated to 36 risks (1C/7H/11M/17L), matching body Summary table and CANONICAL-COUNTS. | MEDIUM | **CLOSED** | 2026-05-18 |
| S-288-pr2-PG-2c | No cache-write-error policy for best-effort cache operations | DONE inline during S-288-pr2 (CLAUDE.md gotcha added). | LOW | **RESOLVED inline** | 2026-05-19 |
| S-2.06-DEFER-01 (duplicate entry) | src/duration.rs parse_duration calculator | See above — resolved as S-3.10. | LOW | **RESOLVED** | 2026-05-08 |
| S-2.06-DEFER-01 second mention | S-2.06-DEFER-01 resolved by S-3.10 story queuing | See S-3.10 story delivery. | LOW | **RESOLVED** | 2026-05-08 |
| DEFER-383-1 | docs-cleanup — bc-3-issue-write.md subdomain heading depth harmonization | Delivered as #391 (bc-3 subdomain 3.8 heading harmonized; factory-artifacts commit pushed 2026-05-20); issue closed 2026-05-20. | LOW | **RESOLVED** | 2026-05-20 |
| DEFER-383-2 | docs-cleanup — CANONICAL-COUNTS.md change-attribution wording | DROPPED — premise refuted by validation; attribution already present at CANONICAL-COUNTS.md:55/57. Research: `.factory/research/issue-383-deferred-followups-validation.md` | LOW | **DROPPED** | 2026-05-20 |
| DEFER-383-3 | process-gap — `scripts/check-spec-counts.sh` validates only `definitional_count`, not cumulative `total_bcs` | RESOLVED — delivered as S-392 / PR #393 / issue #392 closed 2026-05-20 | LOW | **RESOLVED** | 2026-05-20 |
| DRIFT-BC2-PROSE | docs — `bc-2-issue-read.md` frontmatter `total_bcs: 93` vs body preamble "92 behavioral contracts" | bc-2-issue-read.md body preamble corrected 92→93 (AC-5, factory-artifacts 5852a4a); the new DRIFT-002 guard now prevents recurrence of this drift class. | LOW | **RESOLVED-BY-S-392** | 2026-05-20 |
