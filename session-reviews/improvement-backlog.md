---
document_type: improvement-backlog
producer: state-manager
timestamp: 2026-07-08T23:30:00Z
status: active
last_updated: 2026-07-15
---

# Improvement Backlog

Proposals deferred from completed session reviews accumulate here after their 72h human review window closes.

## IP-571 Cycle (ADF-CODE-MARK-EXCLUSIVITY — completed 2026-07-08)

**Status:** CLOSED. All 13 proposals adjudicated engine-side by human review on 2026-07-08 — 72h window closed early. All 13 routed to drbothen/vsdd-factory (9 new issues #576-#584, 3 comments on #507/#428/#298). No items deferred.

| ID | Source Cycle | Source Proposal | Description | Priority | Target Cycle | Status | Date Deferred |
|----|-------------|-----------------|-------------|----------|-------------|--------|---------------|
| (none) | | | All 13 proposals ROUTED-UPSTREAM | — | — | CLOSED | 2026-07-08 |

---

## IP-577 Cycle (SOH-COMMENT-CRUD-1 — review 2026-07-15)

**Status:** PENDING ADJUDICATION. 72h window opens 2026-07-15; closes 2026-07-18. 11 proposals.

All proposals target engine-side improvements (drbothen/vsdd-factory prompt templates, skill checklists, agent configs). None require product source changes. See `improvement-proposals-issue-577.md` for full detail + deduplication routing hints.

| ID | Source Cycle | Source Proposal | Description | Priority | Target Cycle | Status | Date Deferred |
|----|-------------|-----------------|-------------|----------|-------------|--------|---------------|
| IP-577-01 | SOH-COMMENT-CRUD-1 | Mandatory final-wave repo-wide label grep in delivery checklist | TWIN-ARTIFACT-SWEEP +1; RESOLVED-BY-SHIPPING 6 sweeps | HIGH | Next bundle | PENDING | — |
| IP-577-02 | SOH-COMMENT-CRUD-1 | Adversary empirical mutation run mandate | PG-F4-10; CI caught 86% kill after unverified claim | HIGH | Next bundle | PENDING | — |
| IP-577-03 | SOH-COMMENT-CRUD-1 | Implementer pre-substitution deviation report (name "substitute approach" as STOP trigger) | PG-F4-11 2nd instance; 3rd across project | HIGH | Next bundle | PENDING | — |
| IP-577-04 | SOH-COMMENT-CRUD-1 | Story-writer enumerates per-variant test-fn names in AC bodies | PG-F4-7 recurrence 3 (F3-p25, wave-C ×2) | HIGH | Next bundle | PENDING | — |
| IP-577-05 | SOH-COMMENT-CRUD-1 | State-manager PostToolUse hook timeout increase or fail-open | STATE-MANAGER-MONOLITHIC-WRITE-STALL MEDIUM; 4–5 stalls; Bash-python workaround load-bearing | HIGH | Next bundle | PENDING | — |
| IP-577-06 | SOH-COMMENT-CRUD-1 | Bundle-scoped mutation timeout calibration (--timeout 480 or --jobs 2) | MUTANTS-BUNDLE-TIMEOUT-CALIBRATION; 20/60 mutants timed out; full adjudication required | MEDIUM | Next bundle | PENDING | — |
| IP-577-07 | SOH-COMMENT-CRUD-1 | Resume prompt worktree identity guard | PG-F4-8; stray commits in wrong worktree | MEDIUM | Next bundle | PENDING | — |
| IP-577-08 | SOH-COMMENT-CRUD-1 | pr-manager fallback-to-comment as standard for unverifiable reviews | PG-F4-9; review declared without evidence | MEDIUM | Next bundle | PENDING | — |
| IP-577-09 | SOH-COMMENT-CRUD-1 | Wave integration review union-audit of cross-story doc artifacts | PG-F4-4; contradiction invisible to per-story loops | MEDIUM | Next bundle | PENDING | — |
| IP-577-10 | SOH-COMMENT-CRUD-1 | Relocation stories must include BC Source citation sweep task | PG-F4-2; relocation broke 10 BC Source citations | LOW | Future bundle | PENDING | — |
| IP-577-11 | SOH-COMMENT-CRUD-1 | Story-writer must clippy lint-check pinned function signatures | PG-F4-3; ≥8-param signatures tripped clippy | LOW | Future bundle | PENDING | — |
