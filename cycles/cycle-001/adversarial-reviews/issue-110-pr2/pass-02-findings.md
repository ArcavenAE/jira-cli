---
document_type: adversarial-review-pass
feature: issue-110-pr2
pass: 2
model: claude-sonnet-4-6
verdict: SUBSTANTIVE
finding_count: 5
commit_range_reviewed: "2924e49..6915cc3"
fixes_applied_range: "a0a24b0..05a2d2f"
---

# F5 Adversarial Review — issue-110-pr2 Pass 2

**Date:** 2026-05-10
**Model:** claude-sonnet-4-6 (fresh context, no pass 1 history)
**Verdict:** SUBSTANTIVE — 5 findings (1 CONCERN + 2 SHOULD + 2 NIT)
**Pass 1 findings addressed:** 6 of 12 (remaining 4 process-gap/NIT deferred)

---

## CONCERN Findings

### ADV-P5-PR2-P2-001 [CONCERN] — Field guard still slightly mis-ordered in dry-run path

**Location:** `src/cli/issue/create.rs` — dry-run dispatch within `handle_edit_with_jql`  
**Claim:** Pass 1 fix (a0b03af) added the field-change presence guard before JQL search in
the main path, but the dry-run sub-branch still ran the check after the JQL call. A user
running `--dry-run` with no field flags would still incur a Jira search call before receiving
the user error.  
**Severity:** CONCERN — wasted API call in dry-run path specifically.  
**Fix commit:** a0a24b0 (complete fix, both paths now checked pre-search)

---

## SHOULD Findings

### ADV-P5-PR2-P2-002 [SHOULD] — Single-match JQL comment missing (code path looks like a mistake)

**Location:** `src/cli/issue/create.rs` — single-match optimization  
**Claim:** Pass 1 fix (05a2d2f) added a comment documenting the single-match → PUT
optimization, but the comment was in the wrong location (it described the branch after the
branch already ran). Pass 2 noted the comment appeared in the wrong code block.  
**Fix commit:** 05a2d2f (moved comment to correct location)

---

### ADV-P5-PR2-P2-003 [SHOULD] — `selectedActions` assertion missing from PR1 regression-pin

**Location:** `tests/issue_bulk.rs` — label edit tests  
**Claim:** Despite ADV-P5-PR2-009 in pass 1 calling this out, the `selectedActions` assertion
had not been added to the PR1 regression tests (only to the new PR2 tests). The regression
pin should assert the field so future removal would break a test.  
**Fix commit:** 9c90231

---

## NIT Findings

### ADV-P5-PR2-P2-004 [NIT] — rustfmt violation on JQL mock line

**Location:** `tests/issue_bulk_pr2.rs` — JQL search mock registration  
**Claim:** A JQL search mock line exceeded the rustfmt line length limit. CI would catch this
but it's cleaner to pre-empt.  
**Fix commit:** 7a39849

---

### ADV-P5-PR2-P2-005 [NIT] — CLAUDE.md `--dry-run` NFR note references spec language

**Location:** `CLAUDE.md` (develop branch) — `--dry-run` note in gotchas section  
**Claim:** The CLAUDE.md note describing `--dry-run` behavior referenced language from the
original feature spec rather than describing the actual implementation. This causes confusion
for implementers reading the file.  
**Fix commit:** 1ab056e (applied between pass 4 and pass 5 to avoid churn)

---

## Reviewer Notes

Pass 2 found 5 remaining issues — all lower severity than pass 1's CONCERN cluster. The
field guard ordering was a residual miss from the pass 1 fix (the fix addressed the main path
but not the dry-run sub-path). All other findings are documentation/test coverage gaps.

The regression count dropping from 12 to 5 (58% reduction) indicates the pass 1 fixes were
well-targeted. No new BLOCKING findings emerged.
