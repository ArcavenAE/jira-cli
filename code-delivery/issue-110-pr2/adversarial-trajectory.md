# Adversarial Trajectory — issue-110-pr2 (F5)

## Finding Decay Table

| Pass | Model | Findings | Blocking | CONCERN | SHOULD | NIT | Process-gap | Status |
|------|-------|----------|----------|---------|--------|-----|-------------|--------|
| 1 | claude-opus-4 | 12 | 2 | 3 | 4 | 2 | 2 (→#331) | SUBSTANTIVE |
| 2 | claude-sonnet-4-6 | 5 | 0 | 1 | 2 | 2 | 0 | SUBSTANTIVE |
| 3 | claude-opus-4 | 0 | 0 | 0 | 0 | 0 | 0 | CLEAN |
| 4 | claude-sonnet-4-6 | 0 | 0 | 0 | 0 | 0 | 0 | CLEAN (1 doc obs → 1ab056e) |
| 5 | claude-opus-4 | 0 | 0 | 0 | 0 | 0 | 0 | CLEAN |

**Trajectory shorthand:** 12 → 5 → 0 → 0 → 0

**Verdict: F5 CONVERGED** — 3 consecutive clean passes (pass 3, 4, 5) per VSDD convergence requirement.

---

## Pass 1 → Pass 2 Fix Mapping

Findings addressed between pass 1 and pass 2 (6 commits):

| Finding | Fix Commit | SHA |
|---------|-----------|-----|
| ADV-P5-PR2-001 (empty --jql) | fix(bulk): reject empty --jql with friendly error before search | 6915cc3 |
| ADV-P5-PR2-002 (casing mismatch) | fix(bulk): align selected_actions issuetype casing | c9b5bb0 |
| ADV-P5-PR2-003 (--dry-run no fields) | fix(bulk): dry-run errors when no field changes specified | a0b03af |
| ADV-P5-PR2-004 (--max overrun message) | fix(bulk): clarify --max overrun error as "at least N" | c552930 |
| ADV-P5-PR2-005 (selectedActions missing) | test(bulk): assert selectedActions field present in bulk request | d2c0b1e |
| ADV-P5-PR2-007 (StatusCategory fixture) | refactor(types): revert StatusCategory.name optional default | 2924e49 |

---

## Pass 2 → Pass 3 Fix Mapping

Findings addressed between pass 2 and pass 3 (3 commits):

| Finding | Fix Commit | SHA |
|---------|-----------|-----|
| ADV-P5-PR2-P2-001 (field guard ordering) | fix(bulk): check field-change presence before JQL search | a0a24b0 |
| ADV-P5-PR2-P2-002 (single-match comment) | docs(bulk): document single-match JQL routes to PUT | 05a2d2f |
| ADV-P5-PR2-P2-003 (selectedActions PR1 pin) | test(bulk): assert selectedActions in label bulk requests | 9c90231 |
| ADV-P5-PR2-P2-004 (rustfmt) | style(bulk): rustfmt JQL search mock | 7a39849 |

---

## Pass 4 Documentation Observation

Pass 4 was clean (0 findings) but included 1 documentation observation:
- CLAUDE.md `--dry-run` NFR note referenced spec language rather than the actual implementation
  behavior. Fixed at commit 1ab056e between pass 4 and pass 5.

---

## Notable Process-Gap Observations (Not Enumerated as Findings)

**ADV-P5-PR2-010 (Pass 1):** The `body_string_contains` / loose-matcher pattern for
unverified Atlassian API shapes was not documented at usage sites. This was not treated as a
code defect (pattern was already in use from PR1) but was noted as a pattern requiring
codification — the deferred-pending-sandbox convention with linked follow-up issue. Filed as
#331 (schema verification). Codified in lessons.md.

**ADV-P5-PR2-011 (Pass 1, pre-audit):** None of the 5 prior reviewers (code-reviewer,
security-reviewer, 5 adversarial passes) caught the round-5 Copilot DATA-LOSS finding
(`--label add:foo --summary X` silently drops `--summary`). This validated the need for
"silently-dropped flag combinations" as an explicit adversarial review axis.
