---
document_type: adversarial-review-pass
feature: issue-110-pr2
pass: 1
model: claude-opus-4
verdict: SUBSTANTIVE
finding_count: 12
commit_range_reviewed: "7704955..04413a4"
fixes_applied_range: "2924e49..6915cc3"
---

# F5 Adversarial Review — issue-110-pr2 Pass 1

**Date:** 2026-05-10
**Model:** claude-opus-4 (fresh context, no prior pass history)
**Verdict:** SUBSTANTIVE — 12 findings (3 CONCERN + 4 SHOULD + 3 NIT + 2 process-gap)

---

## CONCERN Findings

### ADV-P5-PR2-001 [CONCERN] — Empty JQL not validated before search

**Location:** `src/cli/issue/create.rs` — `handle_edit_with_jql` entry point  
**Claim:** Passing `--jql ""` (empty string) does not trigger a user error; the empty query
is forwarded to the Jira search API, which returns all issues the user has access to. This
could trigger the `--max` cap with a confusing error ("result set exceeds 50 issues") when
the user intended to type a query but left it blank.  
**Severity:** CONCERN — unintuitive behavior, not a security issue.  
**Fix:** Guard with explicit `if jql.trim().is_empty()` before first network call; return
`JrError::UserError` with message "JQL query cannot be empty".  
**Fix commit:** 6915cc3

---

### ADV-P5-PR2-002 [CONCERN] — `issuetype` vs `issueType` casing mismatch

**Location:** `src/types/jira/bulk.rs` — `BulkEditRequest.editedFieldsInput` vs
`BulkActionEditField.selectedActions`  
**Claim:** The `editedFieldsInput` object uses the field key `"issuetype"` (lowercase, the
Jira field ID form), while the `selectedActions` array used `"issueType"` (camelCase). The
Atlassian Bulk API docs suggest `editedFieldsInput` keys should be camelCase field IDs where
applicable, but neither casing is verified by a live API call. The mismatch means at least
one will fail on a real Jira tenant.  
**Severity:** CONCERN — potential silent failure on real tenants.  
**Fix:** Align both to the same casing. Use `"issuetype"` (lowercase) as the consistent form
since that matches the Atlassian field ID in the REST v3 schema.  
**Fix commit:** c9b5bb0

---

### ADV-P5-PR2-003 [CONCERN] (also flagged as SHOULD in P5-P2)

**Location:** `src/cli/issue/create.rs` — `handle_edit_with_jql` pre-validation  
**Claim:** Field-change presence check runs after the JQL search call in the `--dry-run`
path. If a user runs `jr issue edit --jql "project = FOO" --dry-run` with no field flags,
the JQL search fires and uses a network token before the user-error is returned. The guard
should precede the search.  
**Severity:** CONCERN (partially — wasted call, not data mutation).  
**Fix:** Move field-change presence guard before the JQL search call.  
**Fix commit:** a0a24b0

---

## SHOULD Findings

### ADV-P5-PR2-003 [SHOULD] — `--dry-run` with no field changes should error, not silently succeed

**Location:** `src/cli/issue/create.rs` — dry-run path  
**Claim:** Running `jr issue edit --jql "project = FOO" --dry-run` with no field flags
(`--label`, `--summary`, `--priority`, etc.) produces a dry-run table showing 0 planned
changes. This is misleading — the user likely forgot to specify what they want to change.
Should error with `JrError::UserError`.  
**Fix commit:** a0b03af

---

### ADV-P5-PR2-004 [SHOULD] — `--max` overrun message hardcodes default value

**Location:** `src/cli/issue/create.rs` — `--max` cap check error message  
**Claim:** The overrun error message said "result set exceeds 50 issues" (hardcoding the
default value) regardless of what `--max` was set to. If the user passed `--max 100` and got
105 results, the error message was confusing.  
**Fix:** Message should say "result set of N exceeds cap of M" using the actual values.  
**Fix commit:** c552930

---

### ADV-P5-PR2-005 [SHOULD] — `selectedActions` field missing from bulk request body

**Location:** `src/types/jira/bulk.rs` — `BulkEditRequest`  
**Claim:** The Atlassian Bulk Edit API spec marks `selectedActions` as a required field in
the request body. The PR1 implementation omitted it. The `labelsAction` add/remove approach
may require `selectedActions` to enumerate which fields are being edited.  
**Fix:** Add `selectedActions: Vec<String>` to `BulkEditRequest` and populate it with the
field names being edited.  
**Fix commit:** d2c0b1e  
**Note:** The exact semantics of `selectedActions` vs `editedFieldsInput` are unverified
against a live API. This is best-guess per the Atlassian schema.

---

### ADV-P5-PR2-006 [SHOULD] — Field-change presence check after JQL search (see CONCERN-003)

*Already described under CONCERN-003. Same fix applies.*

---

## NIT Findings

### ADV-P5-PR2-007 [NIT] — `StatusCategory.name` optional default in fixture

**Location:** `tests/issue_bulk_pr2.rs` test fixture  
**Claim:** `StatusCategory.name` was made optional with `#[serde(default)]` to allow test
fixtures to omit it. The correct fix is to provide the value in the fixture, not relax the
production type.  
**Fix:** Remove `#[serde(default)]` from `StatusCategory.name`; fix the fixture to include
the field.  
**Fix commit:** 2924e49

---

### ADV-P5-PR2-008 [NIT] — Single-match JQL path (routes to PUT) undocumented

**Location:** `src/cli/issue/create.rs` — JQL → single-key dispatch  
**Claim:** When a JQL query returns exactly 1 issue, the code routes to the single-key PUT
path rather than the bulk API. This is correct behavior (avoids unnecessary bulk overhead for
single issues) but is not documented in a comment, making the branch look like a mistake.  
**Fix:** Add a comment explaining the single-match optimization.  
**Fix commit:** 05a2d2f

---

### ADV-P5-PR2-009 [NIT] — `selectedActions` assertion missing from PR1 regression-pin tests

**Location:** `tests/issue_bulk.rs`  
**Claim:** PR1 regression-pin tests don't assert `selectedActions` is present in the bulk
request body. Now that the field is added, the regression tests should assert it to prevent
accidental removal.  
**Fix commit:** 9c90231

---

## Process-Gap Observations

### ADV-P5-PR2-010 [PROCESS-GAP] — Loose matchers without deferred-pending-sandbox documentation

**Claim:** Several test assertions use `body_string_contains("ADD")` style loose substring
matchers rather than structural `body_partial_json` matchers. The rationale is that the
Atlassian Bulk API schema is unverified (best-guess from docs/community sources). This is
acceptable when the pattern is documented, but the usage sites lack:
1. A `SCHEMA NOTES` comment explaining the uncertainty
2. A reference to the follow-up issue for empirical verification
3. Mention in the PR description

**Resolution:** Pattern is acceptable with documentation. Filed as #331. The deferred-pending-
sandbox convention should be codified in lessons.md.

---

### ADV-P5-PR2-011 [PROCESS-GAP] — `failureReason` not surfaced in audit C-2 tests

**Claim:** The C-2 audit fix (returning `Err` for FAILED/CANCELLED/DEAD tasks) didn't include
a test asserting the `failureReason` string is present in the error message. The commit
`04413a4` added `failureReason` surfacing but without a corresponding assertion.  
**Resolution:** Already fixed in the pre-F5 audit phase. Noted for completeness.

---

## Reviewer Notes

The 12 findings cluster into two groups:
1. **Pre-emit guards** (F1, F3, F6): user-error conditions that fired too late in the
   dispatch chain, after network calls had already been made.
2. **Schema shape accuracy** (F2, F5): best-guess Atlassian API shapes that have minor
   inconsistencies and lack live verification.

The process-gap findings are not code defects but point to missing documentation patterns.
Both are addressed in lessons.md.
