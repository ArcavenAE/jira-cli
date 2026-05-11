---
document_type: convergence-verdict
feature: issue-110-pr2
phase: F5-adversarial
verdict: CONVERGED
date: 2026-05-10
---

# F5 Convergence Verdict — issue-110-pr2

## Result: CONVERGED

**3 consecutive clean passes achieved at pass 5.** Per VSDD convergence requirement, F5 is
complete.

## Trajectory

| Pass | Findings | Cumulative Fixes | Status |
|------|----------|------------------|--------|
| 1 | 12 | 6 | SUBSTANTIVE |
| 2 | 5 | 9 | SUBSTANTIVE |
| 3 | 0 | 0 (counter 1/3) | CLEAN |
| 4 | 0 | 1 doc fix (1ab056e) | CLEAN |
| 5 | 0 | 0 (counter 3/3) | CLEAN |

**Total finding decay:** 12 → 5 → 0 → 0 → 0
**Total fix commits:** 9 commits (passes 1-2) + 1 doc-only (between 4-5)

## Models Used

| Pass | Model |
|------|-------|
| 1 | claude-opus-4 |
| 2 | claude-sonnet-4-6 |
| 3 | claude-opus-4 |
| 4 | claude-sonnet-4-6 |
| 5 | claude-opus-4 |

Alternating opus/sonnet provides complementary lens axes across passes.

## Notable Finding Types

| Category | Pass 1 Count | Pass 2 Count |
|----------|-------------|-------------|
| Pre-emit guard placement | 2 | 1 |
| Schema shape accuracy | 2 | 0 |
| Documentation | 2 | 2 |
| Test coverage | 2 | 1 |
| Process-gap | 2 | 0 |

Pre-emit guard placement issues (user errors firing after network calls) were the dominant
finding class. The pattern of checking inputs late in the dispatch chain recurred across 3
separate guards. This is codified in lessons.md.

## Proceeding to F6

F5 CONVERGED. Adversarial phase complete. Proceed to F6 targeted hardening (formal-verifier
+ security-reviewer on PR2 delta).
