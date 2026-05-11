---
document_type: copilot-convergence-record
pr: 354
branch: docs/labels-shape-divergence-342
head_sha: 0644b1d
closes_issues: ["#342"]
rounds: 3
final_trajectory: "1→1→0"
converged: true
convergence_round: 3
review_round_1_id: 4265225515
review_round_1_submitted: 2026-05-11T15:58:50Z
review_round_2_id: 4265308298
review_round_2_submitted: 2026-05-11T16:05:45Z
review_round_3_id: 4265361087
review_round_3_submitted: 2026-05-11T16:12:31Z
pr_state: OPEN
mergeable: true
merge_state_status: CLEAN
ci_status: "8/8 green"
ci_settled: 2026-05-11T16:10:18Z
threads_total: 2
threads_resolved: 2
---

# PR #354 Copilot Convergence Record

**PR:** https://github.com/Zious11/jira-cli/pull/354
**Branch:** docs/labels-shape-divergence-342
**Final tip SHA:** 0644b1d
**Closes:** #342 on merge
**Final trajectory:** 1→1→0 (3 rounds)

## Summary

PR #354 documented the `plannedChanges.labels` shape divergence between the dry-run preview
JSON and the live POST body (issue #342). The PR also documents the analogous divergences for
`priority` and `issueType`, which the R2 Copilot finding correctly identified as missing from
the R1 scope.

The 3-round convergence trajectory illustrates the iterate-until-clean discipline: R1 addressed
a self-contradiction in wording ("canonical" used in a context where the shape is
"still-unverified"), and R2 caught that the R1 fix documented only 1 of 3 isomorphic divergences,
creating false completeness. R3 returned 0 inline comments — Phase 8 stop condition met.

All 2 inline threads were created by Copilot and resolved after each fix commit was pushed.
No threads are unresolved at convergence.

## Round 1 (2026-05-11T15:58:50Z)

**Review id:** 4265225515
**Inline comments:** 1
**Location:** src/cli/issue/create.rs line 808 (handle_edit_bulk_labels docstring)

### Finding

The docstring used the word "canonical" in the NOTE heading, but the parenthetical body said
the shape is "still-unverified, pending #331." This was a self-contradiction: calling the shape
"canonical" while admitting it is unverified.

### Validation strategy

Local file verification. This is a subjective copy-edit judgment about wording consistency in
code I authored. Perplexity is not applicable for wording decisions about internal doc comments.

### Fix

Reworded to remove the word "canonical" from current-state phrasing. The fix reads:
"current best-guess Atlassian shape (still unverified, pending #331). Once #331 confirms
the canonical wire shape and #345 extracts a pure builder, the two paths can converge."
The word "canonical" is now used only in future-state phrasing, eliminating the contradiction.

**Fix commit:** b835438
**Thread:** resolved after b835438 push

## Round 2 (2026-05-11T16:05:45Z)

**Review id:** 4265308298
**Inline comments:** 1
**Location:** src/cli/issue/create.rs line 495

### Finding

The NOTE added in R1 covered only the `labels` divergence. However, the same dry-run-vs-POST
shape divergence pattern applies to two other fields in the same builder:

- `priority` (lines 482-483): dry-run emits a bare string `"P2"`; POST body wraps it as
  `{"name": "P2"}` inside `{"priority": ...}`
- `issueType` (lines 500-502): dry-run emits a bare string `"Bug"`; POST body wraps it as
  `{"issuetype": {"name": "Bug"}}`

Documenting only `labels` implied that the other fields do NOT have this divergence, which
is false. This is a scope-narrowness that creates false completeness in the documentation.

### Validation strategy

Local file verification of all three field paths. Confirmed via `src/api/jira/bulk.rs`
`BulkEditRequest` SCHEMA NOTES that priority and issueType wrappings are themselves
best-guesses pending #331, exactly parallel to the labels situation. The Copilot finding
was factually correct.

Triage decision: **Fix now** — per the review triage pattern "Comment/doc accuracy in changed
code → Fix now," since the NOTE I had just authored in R1 implied false completeness about
code I explicitly changed in this PR.

### Fix

Two-part fix:

(a) Expanded the dry-run NOTE in `handle_edit` (single-issue and multi-key path) to cover all
three fields uniformly, with their specific divergences and the same #331 rationale:
- labels: dry-run `[{action, name}]` vs POST `{labelsAction, labels: [{name}]}`
- priority: dry-run bare string vs POST `{"name": ...}`
- issueType: dry-run bare string vs POST `{"issuetype": {"name": ...}}`

(b) Added a parallel cross-reference note on `handle_edit_bulk_fields` (the non-labels bulk
path) mirroring the existing NOTE on `handle_edit_bulk_labels`, so the divergence is
discoverable from both bulk builder entry points.

**Fix commit:** 0644b1d (+30 -17 lines)
**Thread:** resolved after 0644b1d push
**Copilot value-add:** This finding was a genuine value-add. Without R2, the PR would have
shipped with documentation covering only 1 of 3 isomorphic divergences, creating a
misleading false-completeness impression for future readers.

## Round 3 (2026-05-11T16:12:31Z)

**Review id:** 4265361087
**Inline comments:** 0
**Verbatim:** "Copilot reviewed 1 out of 1 changed files in this pull request and generated
no new comments."

### Phase 8 stop condition

Stop condition met at Round 3. The spec states: "The overview comment alone (no file-level
findings) is not a reason to continue." Round 3 produced 0 inline findings. Convergence
declared. No Round 4 dispatched.

## Trajectory Analysis

**Pattern:** 1→1→0 (matches PR #348 Round 4→5 pattern where a round-N fix introduced an
unintended side-issue surfaced in round N+1)

In PR #348, Round 5 found a data-loss bug that the round-1 to round-4 VSDD reviewers
had all missed. In PR #354, Round 2 found that the Round 1 fix introduced false completeness
by documenting only one of three isomorphic divergences.

Both cases reinforce: Copilot's iterate-until-clean discipline is not merely ceremonial.
A "fix" can introduce a new finding (false completeness, scope narrowness, wording drift).
The discipline of re-requesting after every fix commit is what surfaces these cases.

## Notable Observations

1. The R2 finding was a genuine Copilot value-add — not a continuation for ceremony. The
   R1 fix narrowed scope without broadening coverage, creating a documentation inconsistency
   that R2 correctly identified.

2. The R2→R3 fix (+30 -17 lines) fully resolved the scope concern with the same
   diff-only-touches-doc-comments invariant. No behavioral change in either R1 or R2 fixes.

3. The 1→1→0 trajectory is the second instance (after PR #348 round 4→5→clean) where a
   round-N fix in a documentation PR introduced a scope issue surfaced by round N+1.

4. Validation for both rounds used local file verification (not Perplexity), which is
   correct: the Copilot claims were about scope and wording consistency within code I authored,
   not about external library semantics or API behavior. Perplexity-validation applies to
   external fact claims; local verification applies to internal consistency claims.

## CI Status

**Head SHA:** 0644b1d
**CI settled:** 2026-05-11T16:10:18Z
**Result:** 8/8 green

| Job | Result |
|-----|--------|
| Format | green |
| Clippy | green |
| Test (ubuntu) | green |
| Test (macos) | green |
| MSRV 1.85.0 | green |
| Deny | green |
| Coverage | green |
| Secret Scan | green |

## Final PR State

| Field | Value |
|-------|-------|
| **State** | OPEN |
| **Mergeable** | true |
| **Merge state status** | CLEAN |
| **CI** | 8/8 green on 0644b1d |
| **Threads** | 2 created (R1 + R2); 2/2 resolved |
| **Convergence** | CONVERGED at Round 3 |
| **Validation method** | Local file verification (both rounds) |
| **Awaiting** | Human merge |
