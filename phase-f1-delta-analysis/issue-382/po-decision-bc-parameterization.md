---
decision_id: po-decision-bc-parameterization
issue: "#382"
date: 2026-05-19
decider: product-owner
adversary_pass: adversary-pass-01
findings_addressed: F-02, F-03
---

# PO Decision: BC-1.6.042 Parameterization Strategy

## Decision

**Option (a): Parameterize substring #3 in BC-1.6.042 in-place.**

The contract heading, ID, and position in BC-INDEX are unchanged. Only the
Behavior line is updated to reflect that the required scope name is
runtime-resolved from `JrError::InsufficientScope { required_scope:
Option<String> }` rather than hardcoded as `write:jira-work`.

## Rationale

1. **Semantic unity.** Both the `write:jira-work` path and the
   `write:servicedesk-request` path describe the same behavior: "display the
   scope that was missing." They are not distinct behaviors; they are
   instantiations of one parameterized behavior. A single BC with a
   parameterized field accurately captures this — two BCs would overstate the
   distinction.

2. **Backward compatibility.** The `None` branch of `Option<String>` falls back
   to the historical literal `write:jira-work`, so existing tests that assert
   the literal string remain green without modification. No test-file churn
   results from this decision.

3. **Minimal index propagation.** BC count is stable (57 cumulative in bc-1),
   BC-INDEX title and row are unchanged, CANONICAL-COUNTS.md is unchanged.
   Adversary finding F-02 (which was contingent on a count change from option
   (b) or (c)) is moot.

4. **Precedent.** The `optional_fields_parameterized` pattern already exists
   elsewhere in this codebase (e.g., `--project` inheriting from config vs
   flag). Parameterizing an error field follows the same established idiom.

## Rejected Alternatives

### Option (b): Split into BC-1.6.042 (platform-write) + BC-1.6.047 (JSM-write)

Rejected. The two "behaviors" are not semantically distinct — both are
"show the missing scope name." Splitting would create two contracts with
identical structure differing only in a string constant, inflating BC count
for no analytical gain. BC-INDEX, CANONICAL-COUNTS.md, and any story body
that references BC-1.6.042 would all require updates. Adversary F-02
(index-count drift) would become load-bearing, requiring additional churn.

### Option (c): Add BC-1.6.047 as supplementary contract

Rejected. A "supplementary BC" for a behavior that is already fully described
by BC-1.6.042 with a parameterized field violates the "one BC per behavior"
principle. The supplementary contract would either duplicate BC-1.6.042's
postconditions (redundant) or describe only the JSM variant (which is
covered by the `None`/`Some` branching in the updated Behavior line).
Adding a new ID also requires BC-INDEX and CANONICAL-COUNTS updates with no
reduction in specification complexity.

## Files Modified

| File | Change |
|------|--------|
| `.factory/specs/prd/bc-1-auth-identity.md` (line ~472) | BC-1.6.042 Behavior line updated; Change note appended |
| `.factory/phase-f1-delta-analysis/issue-382/po-decision-bc-parameterization.md` | This file (created) |

## Files NOT Modified (confirmed in-scope exclusions)

- `BC-INDEX.md` — no BC count or ID change
- `CANONICAL-COUNTS.md` — no count change
- Any story body file — no F3 story exists yet (quick-dev route)
- Any source code or test file — PO scope only
