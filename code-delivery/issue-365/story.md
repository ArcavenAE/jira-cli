---
document_type: story
story_id: issue-365
title: "In-function dedupe on all exit paths (search_issue_keys and search_issues)"
cycle: 3-feature-search-issue-keys-dedupe-365
wave: feature-followup
status: ready-for-implementation
priority: medium
estimated_effort: small
tdd_mode: strict
version: "1.0.0"
date: 2026-05-15
traces_to: [BC-2.6.050, BC-2.6.051]
feature_spec: docs/specs/2026-05-14-search-issue-keys-dedupe.md
bc_anchors:
  - BC-2.6.050
  - BC-2.6.051
holdout_anchors: []
nfr_anchors: []
adr_refs:
  - ADR-0004
sd_refs: []
files_modified:
  - src/api/jira/issues.rs
  - tests/search_issue_keys.rs
  - tests/rate_limit_cap_tests.rs
  - .factory/specs/prd/bc-2-issue-read.md
  - .factory/specs/prd/BC-INDEX.md
  - docs/specs/2026-05-13-search-issue-keys.md
breaking_change: false
producer: story-writer
depends_on: []
blocks: []
issue: 365
public_spec: docs/specs/2026-05-14-search-issue-keys-dedupe.md
research_report: .factory/research/issue-365-design-validation.md
---

# issue-365: In-function dedupe on all exit paths (`search_issue_keys` and `search_issues`)

## Context

`search_issue_keys` and `search_issues` both have a repeated-cursor anti-loop
guard (JRACLOUD-95368 mitigation). Under live-data drift, earlier pages can
accumulate duplicate keys/issues before the guard fires OR before the
limit-truncation check fires. This causes two user-visible bugs:

1. **Spurious truncation error on `jr issue edit --jql ... --max N`:** The
   `+1` over-fetch sentinel at `handle_edit::effective_keys` checks
   `matched_keys.len() > effective_max`. Drift-induced duplicates inflate
   `matched_keys.len()` by 1, spuriously triggering the "JQL matched at least N
   issues, which exceeds --max M" error when the true unique-key count is exactly
   at the limit.

2. **Redundant bulk-edit calls:** `search_issue_keys` without dedupe can return
   the same key twice, causing the same field edit to be applied twice to the
   same issue (idempotent at the Jira API for most fields, but unexpected).

The parent spec (`docs/specs/2026-05-13-search-issue-keys.md`) deferred this as
a follow-up issue after PR #362 shipped. Issue #365 closes that deferral.

The fix is a per-iteration `HashSet` retain applied after each page's
`extend(...)` call and before any break-decision check in BOTH
`search_issue_keys` and `search_issues`. `Vec::dedup()` is explicitly wrong:
JRACLOUD-95368 drift can emit the same key non-consecutively across pages.
No new public API fields are added; no caller code changes are required.

Full design rationale, algorithm comparison table (HashSet retain vs
IndexSet vs itertools::unique), and rejection of DP-3/DP-4/DP-6/DP-7 live
in `docs/specs/2026-05-14-search-issue-keys-dedupe.md`. Research validation
(including the Perplexity-vs-docs.rs itertools::unique() discrepancy) lives
at `.factory/research/issue-365-design-validation.md`.

## Behavioral Contracts

**BC-2.6.050** (existing — updated in this PR).
Append to BC-2.6.050 Behavior: "On every page-fetch iteration, after extending
`all_keys` and before any break-decision check, `search_issue_keys` deduplicates
`all_keys` in-place using order-preserving, first-occurrence-wins deduplication
(HashSet retain, keyed on the key string). All exit paths (guard-abort,
limit-truncation, cursor-exhaustion) therefore return a duplicate-free `keys`
vec. Introduced in #365." Also: replace BOTH occurrences of `JRACLOUD-94632`
on line 496 with `JRACLOUD-95368`.

**BC-2.6.051** (new — created in this PR).
`client.search_issues(jql, limit, fields)` deduplicates results in-place on
all exit paths (JRACLOUD-95368 mitigation). Per-iteration order-preserving
deduplication keyed on `issue.key` (HashSet<String> of cloned keys, because
`Issue` does not impl `Hash`). All exit paths return a duplicate-free `issues`
vec. `SearchResult.has_more` semantics unchanged. `SearchResult` rustdoc "may
contain duplicate issues" warning dropped and replaced with "duplicates
eliminated client-side on all exit paths." Symmetric to BC-2.6.050.

## Acceptance Criteria

**AC-001** (traces to BC-2.6.050 — `search_issue_keys` guard-abort path).
`search_issue_keys` deduplicates on the guard-abort exit path. Pinned by:
- `tests/search_issue_keys.rs::test_search_issue_keys_repeated_cursor_abort_dedupes`
  (renamed and assertion-flipped from the old no-dedupe pin):
  page 1 returns `["X-1"]`, page 2 returns `["X-1", "X-2"]`, both with
  `nextPageToken: "loop"`; guard fires; asserts `result.keys == ["X-1", "X-2"]`
  and `result.has_more == true`.
- `tests/search_issue_keys.rs::test_search_issue_keys_dedupes_non_consecutive_across_pages`
  (Vec::dedup-is-wrong correctness pin): page 1 returns `["X-1"]`, page 2
  returns `["X-2", "X-1"]` (non-consecutive duplicate); asserts `result.keys
  == ["X-1", "X-2"]` and `result.has_more == true`. `Vec::dedup()` would
  silently leave three entries.

**AC-002** (traces to BC-2.6.050 — `search_issue_keys` limit-truncation path).
`search_issue_keys` deduplicates on the limit-truncation exit path. Pinned by:
- `tests/search_issue_keys.rs::test_search_issue_keys_limit_truncation_dedupes_under_drift`:
  `effective_max = 10`, `limit = 11`. Page 1 returns 11 keys with `"A-1"`
  duplicated (`["A-1","A-1","B-1","C-1","D-1","E-1","F-1","G-1","H-1","I-1","J-1"]`),
  no `nextPageToken`. After per-iteration dedupe: `all_keys.len() = 10 < 11` →
  truncation does NOT fire; cursor exhaustion exits loop. Asserts
  `result.keys.len() == 10`, no `"A-1"` duplicate, `result.has_more == false`.
- `tests/search_issue_keys.rs::test_search_issue_keys_apr2025_overshoot_silenced_by_drift_dedupe`
  **(NEGATIVE-PIN)**: `limit = 10`. Page 1 returns `["X-1","X-1","A-2",...,"A-10"]`
  (11 keys, X-1 duplicated, no `nextPageToken`). After dedupe: 10 unique keys.
  Truncation check: `10 >= 10` → DOES fire; `more_available = (10 > 10) || false
  = false`. Asserts `result.keys.len() == 10` and `result.has_more == false`.
  Doc-comment in test MUST state this is the documented Risk #5 regression — a
  future PR fixing Risk #5 must update this assertion to `has_more == true`.

**AC-003** (traces to BC-2.6.051 — `search_issues` guard-abort path).
`search_issues` deduplicates on the guard-abort exit path. Pinned by:
- `tests/rate_limit_cap_tests.rs::test_search_issues_repeated_cursor_abort_dedupes`:
  page 1 returns `[TEST-1]`, page 2 returns `[TEST-1, TEST-2]`, both with
  `nextPageToken: "loop"`; guard fires. Asserts `result.issues` contains
  exactly `["TEST-1", "TEST-2"]` (len == 2, not 3) and `result.has_more == true`.
  Mock Issue field shapes must mirror the `stuck_response` in the existing
  `test_search_issues_repeated_cursor_abort_sets_has_more_true` (lines 349–374).
- `tests/rate_limit_cap_tests.rs::test_search_issues_dedupes_non_consecutive_across_pages`:
  page 1 returns `[TEST-1]`, page 2 returns `[TEST-2, TEST-1]` (non-consecutive
  duplicate); asserts `issues.len() == 2` and keys == `["TEST-1", "TEST-2"]`.

**AC-004** (traces to BC-2.6.051 — `search_issues` limit-truncation path).
`search_issues` deduplicates on the limit-truncation exit path. Pinned by:
- `tests/rate_limit_cap_tests.rs::test_search_issues_limit_truncation_dedupes_under_drift`:
  `limit = 11`. Page 1 returns 11 issues with TEST-1 duplicated, no
  `nextPageToken`. After per-iteration dedupe: `all_issues.len() = 10 < 11`
  → truncation does NOT fire; cursor exhaustion exits. Asserts
  `result.issues.len() == 10`, `result.issues[0].key == "TEST-1"` (first
  occurrence preserved), `result.has_more == false`.
- `tests/rate_limit_cap_tests.rs::test_search_issues_apr2025_overshoot_silenced_by_drift_dedupe`
  **(NEGATIVE-PIN)**: `limit = 10`. Page 1 returns 11 issues with TEST-1
  duplicated, no `nextPageToken`. After dedupe: 10 unique issues. Truncation
  check: `10 >= 10` → DOES fire; `more_available = false`. Asserts
  `result.issues.len() == 10` and `result.has_more == false`. Doc-comment must
  state Risk #5 regression; future PR fixing it must update to `has_more == true`.

**AC-005** (traces to BC-2.6.050 — rustdoc update, `KeySearchResult`).
`KeySearchResult` rustdoc at lines 65–115 of `src/api/jira/issues.rs` updated:
- Case 2 no longer says "may contain duplicate keys"; says "duplicates
  eliminated client-side on this path via per-iteration order-preserving
  deduplication" and "Callers should still prefer `key ASC` in the ORDER BY."
- Paragraph starting mid-line-95 through line 106 ("Today's sole caller…
  to surface 'incomplete-and-possibly-duplicated' via the type system") is
  removed (describes pre-dedupe behavior of `handle_edit::effective_keys`).
- Both disambiguation sentences at lines 92–95 ("When `limit` is set…") are
  retained verbatim.
- New note added: "as of issue #365, `has_more = true` on the guard-abort
  path no longer implies that `keys` contains duplicates."

**AC-006** (traces to BC-2.6.051 — rustdoc update, `SearchResult` and `search_issues`).
- `SearchResult` rustdoc at lines 31–63 (case 2): "may contain duplicate
  issues" warning dropped; replaced with "duplicates are eliminated
  client-side on this path: `search_issues` applies a per-iteration
  order-preserving deduplication keyed on `issue.key`."
- `SearchResult` note added: "as of issue #365, `has_more = true` on the
  guard-abort path no longer implies that `issues` contains duplicates."
- `search_issues` function-level rustdoc: no change required beyond the
  inline guard comment update below (the function delegates to `SearchResult`
  for the full contract).

**AC-007** (traces to BC-2.6.050 and BC-2.6.051 — inline guard comments).
Inline comments inside both repeated-cursor guard blocks updated:
- `search_issue_keys` guard block (lines 366–373): replace "this function
  does NOT dedupe. Callers needing strict uniqueness should re-issue with
  `key ASC`... or dedupe locally." with "Guard-aborted: signal incomplete
  results via has_more=true. As of #365, all_keys is already deduplicated
  by the per-iteration dedupe applied above (HashSet retain, order-preserving).
  No additional dedupe call is needed here."
- `search_issues` guard block (lines 243–253): replace "Note: under
  JRACLOUD-95368 (live-data drift, the typical cause), earlier pages MAY
  contain issues that the server would emit again after the cursor repeats —
  `search_issues` does not dedupe." with "As of #365, all_issues is already
  deduplicated (keyed on issue.key) by the per-iteration dedupe applied above
  (HashSet retain, order-preserving). No additional dedupe call is needed here."

**AC-008** (traces to BC-2.6.050 and BC-2.6.051 — BC file updates).
`.factory/specs/prd/bc-2-issue-read.md` updated in the same PR:
- BC-2.6.050 **Behavior** field: dedupe paragraph appended (per spec Update 1).
- Line 496 (BC-2.6.050): BOTH occurrences of `JRACLOUD-94632` replaced with
  `JRACLOUD-95368` (per spec Update 2 — a single-match substitution is wrong;
  both must be updated).
- BC-2.6.051 added immediately after BC-2.6.050 (per spec Update 3, including
  full Confidence / Source / Subject / Behavior / Trace fields).

**AC-009** (traces to BC-2.6.051 — BC catalog count propagation).
All of the following counts are updated in the same PR, then
`scripts/check-spec-counts.sh` exits 0 before push:
- `bc-2-issue-read.md` frontmatter: `total_bcs: 92 → 93`,
  `definitional_count: 50 → 51`.
- `bc-2-issue-read.md` footer: "Total BCs in this file: 50 … carries all 92"
  → "51 … carries all 93".
- `BC-INDEX.md` frontmatter: `total_bcs: 546 → 547`; append
  `; +1 added 2026-05-14 (BC-2.6.051, issue #365)`.
- `BC-INDEX.md` `sections:` entry: `(92 BCs cumulative; 50 individually-bodied)`
  → `(93 BCs cumulative; 51 individually-bodied)`.
- `BC-INDEX.md` Section 2 header: `92 BCs cumulative; 50 individually-bodied`
  → `93/51`.
- `BC-INDEX.md` subsection 2.6 header: `(4 BCs: BC-2.6.047..050)` →
  `(5 BCs: BC-2.6.047..051)`.
- `BC-INDEX.md` subsection 2.6 table: new row added after BC-2.6.050 for
  BC-2.6.051.
- `BC-INDEX.md` Totals table `2: Issue Read` row: `92 | 50` → `93 | 51`.
- `BC-INDEX.md` Totals table `**Total**` row: `**546** | **314**` →
  `**547** | **315**`.
- `BC-INDEX.md` canonical total note: `546` → `547`; append
  `+1 BC-2.6.051 added 2026-05-14 via issue #365`.
- `BC-INDEX.md` cumulative ≠ individually-bodied sentence:
  `546 ≠ 314` → `547 ≠ 315`.

**AC-010** (traces to BC-2.6.050 — parent spec close-out).
`docs/specs/2026-05-13-search-issue-keys.md` updated with ALL SIX of the
following changes in the same PR:

**(a)** Deferred follow-up bullet (line 276): strikethrough + "CLOSED by #365
(2026-05-14)" with back-reference to `docs/specs/2026-05-14-search-issue-keys-dedupe.md`.

**(b)** Test inventory entry #13 (line 243): rename from
`test_search_issue_keys_repeated_cursor_abort_does_not_dedupe` to
`test_search_issue_keys_repeated_cursor_abort_dedupes`; update description to
reflect flipped assertion (`keys == ["X-1", "X-2"]`) and add "Renamed and
assertion flipped in #365."

**(c)** Risks bullet "Possible duplicate keys on guard-abort under live-data drift"
(line 258): entire bullet struck through and replaced with "RESOLVED by #365
(2026-05-14)" paragraph per spec §(c).

**(d)** Backwards Compatibility paragraph (line 271): sentence about "under guard
abort, `effective_keys` may include duplicates that spuriously trip the `--max`
truncation error or generate redundant bulk-edit calls (both safe-but-user-visible;
tracked in #365)" struck through; replaced with "RESOLVED by #365 (2026-05-14)."

**(e)** `search_issues` Out-of-Scope bullet (line 28): append "**Follow-up (v0.1.9,
issue #365):** `search_issues` dedupe was added symmetrically by PR #365. The
'no-dedupe by design' stance is superseded."

**(f)** Backwards Compatibility caller list (line 266): replace "Three CLI readers
(`cli/issue/list.rs`, `cli/board.rs`, `cli/sprint.rs`)" with "Three CLI readers
(`cli/issue/list.rs`, `cli/board.rs`, `cli/queue.rs`)" — `sprint.rs` calls
`get_sprint_issues` (Agile API), not `search_issues`; `queue.rs` is the correct
third reader.

**AC-011** (release-gate). `cargo test`, `cargo clippy -- -D warnings`,
`cargo fmt --check`, and `scripts/check-spec-counts.sh` all pass before push.
No new clippy allows. No unsafe code added.

**AC-012** (regression baseline). All existing tests in `tests/` continue to
pass unchanged, specifically:
- `tests/rate_limit_cap_tests.rs::test_search_issues_repeated_cursor_abort_sets_has_more_true`
  — asserts `has_more == true` and `!result.issues.is_empty()`; both
  assertions remain correct after dedupe (single-issue stuck mock; one issue
  survives dedupe, `has_more` still true).
- `tests/rate_limit_cap_tests.rs::ac_008_and_ac_new_d_search_jql_cursor_loop_terminates_with_jracloud_warning`
  — subprocess test; JRACLOUD-95368 warning text is unchanged by dedupe.
- `tests/search_issue_keys.rs` tests 1–12 (all except the renamed test 13)
  — unaffected; they exercise clean-exhaustion, limit-truncation, error
  propagation, and request-shape paths, none of which touch the guard-abort
  dedupe logic. `test_search_issue_keys_stderr_emits_jracloud_95368_literal`
  is unchanged (warning text is identical).

## TDD Test Plan (Red → Green sequence)

Tests are written FIRST (red gate) before any implementation lands.

### Step 1 — Red: rewrite test 13 in `tests/search_issue_keys.rs`

**Rename:** `test_search_issue_keys_repeated_cursor_abort_does_not_dedupe`
→ `test_search_issue_keys_repeated_cursor_abort_dedupes`

**Location:** block starting at line 307 of `tests/search_issue_keys.rs`.

Mock setup is unchanged (page 1 returns `["X-1"]` with `nextPageToken: "loop"`,
page 2 returns `["X-1", "X-2"]` with the same token). Only the assertion
changes:

```rust
// Before:
assert_eq!(result.keys, vec!["X-1", "X-1", "X-2"]);

// After:
assert_eq!(
    result.keys,
    vec!["X-1".to_string(), "X-2".to_string()],
    "search_issue_keys MUST dedupe on repeated-cursor abort while preserving \
     first-occurrence order."
);
assert!(result.has_more, "repeated-cursor abort must set has_more=true");
```

Update the leading block comment to remove "no-dedupe contract pin" framing.

This test will now FAIL (red) because the implementation still returns three keys.

### Step 2 — Red: add `test_search_issue_keys_dedupes_non_consecutive_across_pages`

`tests/search_issue_keys.rs`, new test after step 1's renamed test.

Page 1 returns `["X-1"]` with `nextPageToken: "loop"`. Page 2 returns
`["X-2", "X-1"]` (non-consecutive duplicate) with the same token. Guard fires.

```rust
assert_eq!(result.keys, vec!["X-1".to_string(), "X-2".to_string()]);
assert!(result.has_more);
// Vec::dedup() would incorrectly return ["X-1", "X-2", "X-1"] unchanged.
```

### Step 3 — Red: add `test_search_issue_keys_limit_truncation_dedupes_under_drift`

`tests/search_issue_keys.rs`, new test.

`limit = Some(11)`. Single-page mock: 11 keys with `"A-1"` duplicated,
no `nextPageToken`.

```rust
// After dedupe: 10 unique keys; truncation check 10 < 11 does not fire.
assert_eq!(
    result.keys,
    ["A-1","B-1","C-1","D-1","E-1","F-1","G-1","H-1","I-1","J-1"]
        .iter().map(|s| s.to_string()).collect::<Vec<_>>()
);
assert!(!result.has_more);
```

### Step 4 — Red: add `test_search_issue_keys_apr2025_overshoot_silenced_by_drift_dedupe` (NEGATIVE-PIN)

`tests/search_issue_keys.rs`, new test.

`limit = Some(10)`. Single-page mock: 11 keys, `"X-1"` duplicated,
`next_page_token: None`.

```rust
// NEGATIVE-PIN: documents Risk #5 regression.
// After dedupe: 10 unique keys. Truncation check: 10 >= 10 fires.
// more_available = (10 > 10) || false = false.
assert_eq!(result.keys.len(), 10);
assert_eq!(result.keys[0], "X-1");
assert!(!result.has_more,
    "REGRESSION-PIN: has_more is false because dedupe collapsed the \
     Apr 2025 overshoot duplicate. This is Risk #5 — not desired behavior. \
     Update if Risk #5 is fixed.");
```

### Step 5 — Red: add `test_search_issues_repeated_cursor_abort_dedupes`

`tests/rate_limit_cap_tests.rs`, new companion test.

Page 1 returns `[TEST-1]`, page 2 returns `[TEST-1, TEST-2]`, both
`nextPageToken: "loop"`. Guard fires. Issue fields shapes mirror
`stuck_response` in the existing
`test_search_issues_repeated_cursor_abort_sets_has_more_true`.

```rust
assert_eq!(
    result.issues.iter().map(|i| i.key.as_str()).collect::<Vec<_>>(),
    vec!["TEST-1", "TEST-2"],
);
assert!(result.has_more);
```

### Step 6 — Red: add `test_search_issues_dedupes_non_consecutive_across_pages`

`tests/rate_limit_cap_tests.rs`, new test.

Page 1 returns `[TEST-1]`, page 2 returns `[TEST-2, TEST-1]`, same token.

```rust
assert_eq!(
    result.issues.iter().map(|i| i.key.as_str()).collect::<Vec<_>>(),
    vec!["TEST-1", "TEST-2"]
);
assert!(result.has_more);
```

### Step 7 — Red: add `test_search_issues_limit_truncation_dedupes_under_drift`

`tests/rate_limit_cap_tests.rs`, new test.

`limit = Some(11)`. Single-page mock: 11 issues with TEST-1 duplicated,
no `nextPageToken`.

```rust
assert_eq!(result.issues.len(), 10);
assert_eq!(result.issues[0].key, "TEST-1");
assert!(!result.has_more);
```

### Step 8 — Red: add `test_search_issues_apr2025_overshoot_silenced_by_drift_dedupe` (NEGATIVE-PIN)

`tests/rate_limit_cap_tests.rs`, new test.

`limit = Some(10)`. Single-page mock: 11 issues, TEST-1 duplicated,
no `nextPageToken`.

```rust
// NEGATIVE-PIN: Risk #5 regression, parallel to the keys-only variant.
assert_eq!(result.issues.len(), 10);
assert!(!result.has_more,
    "REGRESSION-PIN: see test_search_issue_keys_apr2025_overshoot_silenced_by_drift_dedupe");
```

### Step 9 — Green: implement per-iteration dedupe in `search_issue_keys`

In `src/api/jira/issues.rs`, inside the `search_issue_keys` loop body,
insert after `all_keys.extend(...)` and before the limit-truncation check:

```rust
// Per-iteration order-preserving dedupe: JRACLOUD-95368 drift can emit the
// same key on multiple pages (or within a single page under extreme drift).
// Vec::dedup() is wrong here (consecutive-only); HashSet retain is correct.
// Per-iteration cost: O(all_keys.len()) growing across iterations; total
// O(N²/page_size); negligible at N≤1001. Required for correctness: must run
// before the limit-truncation check so `all_keys.len()` reflects unique-key
// count when the truncation sentinel fires. See #365.
// search_issues applies the same dedupe pattern keyed on issue.key.
{
    let mut seen: HashSet<String> = HashSet::with_capacity(all_keys.len());
    all_keys.retain(|k| seen.insert(k.clone()));
}
```

Add `use std::collections::HashSet;` to top-of-file imports if not already present.

Tests from steps 1–4 now pass green. Tests 5–8 still red (search_issues not yet changed).

### Step 10 — Green: implement per-iteration dedupe in `search_issues`

In `src/api/jira/issues.rs`, inside the `search_issues` loop body,
insert after `all_issues.extend(page.issues)` (line 214) and before the
limit-truncation block (line 216):

```rust
// Per-iteration order-preserving dedupe: JRACLOUD-95368 drift can emit the
// same issue on multiple pages. Issue does not impl Hash, so we key on
// issue.key (String). See #365.
{
    let mut seen: HashSet<String> = HashSet::with_capacity(all_issues.len());
    all_issues.retain(|i| seen.insert(i.key.clone()));
}
```

Tests from steps 5–8 now pass green. All 8 new/updated tests pass.

### Step 11 — Green/docs: rustdoc and inline comment updates

Update rustdoc blocks and guard-block comments per AC-005, AC-006, AC-007.

### Step 12 — Green/docs: BC file updates

Apply all changes to `.factory/specs/prd/bc-2-issue-read.md` (Updates 1, 2, 3)
and `.factory/specs/prd/BC-INDEX.md` (Update 4) per AC-008 and AC-009.
Run `scripts/check-spec-counts.sh` — must exit 0.

### Step 13 — Green/docs: parent spec close-out

Apply all six changes to `docs/specs/2026-05-13-search-issue-keys.md`
per AC-010 items (a) through (f).

### Step 14 — Regress: full suite + gates

```
cargo test
cargo clippy -- -D warnings
cargo fmt --check
scripts/check-spec-counts.sh
```

All must pass. AC-011, AC-012.

## Implementation Outline

Reference: `docs/specs/2026-05-14-search-issue-keys-dedupe.md` §Implementation
Outline and §Placement within the loop. The spec contains the exact insertion
points (line numbers confirmed via Read), the annotated loop body structure
for both `search_issue_keys` and `search_issues`, the `HashSet<String>` vs
`HashSet<&str>` borrow-checker explanation, and the O(N²/page_size) cost
analysis. Do not duplicate here.

Key invariants from the spec:
- Dedupe runs EVERY iteration (after extend, before any break check).
- `Vec::dedup()` is explicitly wrong — non-consecutive duplicates are the
  load-bearing failure case.
- Per-iteration is required for correctness (a single post-loop dedupe cannot
  fix the spurious-truncation bug).
- No call-site changes needed in `handle_edit::effective_keys`.
- `HashSet` is stdlib; no new dependencies added.

## Files Modified

| File | Change |
|------|--------|
| `src/api/jira/issues.rs` | Add per-iteration HashSet retain in `search_issue_keys` loop (after extend, before truncation check). Add same pattern in `search_issues` loop keyed on `i.key`. Add `use std::collections::HashSet;` if absent. Update rustdoc blocks per AC-005/AC-006 and guard-block comments per AC-007. |
| `tests/search_issue_keys.rs` | Rename + flip test 13 (step 1). Add 3 new tests (steps 2, 3, 4). |
| `tests/rate_limit_cap_tests.rs` | Add 4 new tests (steps 5, 6, 7, 8). |
| `.factory/specs/prd/bc-2-issue-read.md` | Append dedupe para to BC-2.6.050 Behavior. Replace both `JRACLOUD-94632` → `JRACLOUD-95368` on line 496. Add BC-2.6.051 body. Update `total_bcs`, `definitional_count`, footer. |
| `.factory/specs/prd/BC-INDEX.md` | All count propagation per AC-009 (10 individual edit locations). |
| `docs/specs/2026-05-13-search-issue-keys.md` | Six close-out edits per AC-010 items (a)–(f). |

## Files NOT Modified (Regression Baseline)

- `src/cli/issue/create.rs` — no caller migration needed. `handle_edit::effective_keys`
  already checks `matched_keys.len() > effective_max`; dedupe makes this check
  correct without touching it.
- `src/api/jira/issues.rs` — `KeySearchResult` and `SearchResult` struct definitions
  are unchanged (no new fields).
- `CLAUDE.md` — the gotcha entry for JRACLOUD-95368 describes guard-abort behavior
  at the architectural level; dedupe is an implementation detail. No update required.
- All other CLI subcommands, modules, and tests — zero touch.
- `CursorPage`, `src/api/pagination.rs` — reused unchanged.

## Architecture Compliance Rules

- **No unsafe code.** The `HashSet::retain` pattern is safe, stdlib-only.
- **No new dependencies.** `std::collections::HashSet` is stdlib. No crate additions.
- **No clippy allows.** If clippy warns, refactor — do not suppress.
- **No new public API fields** on `KeySearchResult` or `SearchResult` (DP-3 rejected).
- **JRACLOUD-95368 stderr warning text is unchanged.** Pinned by existing subprocess
  test; do not alter the warning string.
- **`search_issue_keys` and `search_issues` are the only changed functions.** All
  other public methods on `JiraClient` are unmodified.

## Library and Framework Requirements

No new library dependencies. Existing test infrastructure (wiremock 0.6.5,
tokio, insta, proptest) unchanged. All test versions already in `Cargo.toml`.

## Token Budget Estimate

| Context item | Estimated tokens |
|---|---|
| Feature spec (`docs/specs/2026-05-14-search-issue-keys-dedupe.md`) | ~6,500 |
| `src/api/jira/issues.rs` (full file — loop body context required) | ~3,500 |
| `tests/search_issue_keys.rs` (existing 12 tests) | ~2,500 |
| `tests/rate_limit_cap_tests.rs` (existing search_issues tests) | ~1,500 |
| `.factory/specs/prd/bc-2-issue-read.md` (lines 488–512) | ~300 |
| `.factory/specs/prd/BC-INDEX.md` (section 2.6 + totals) | ~400 |
| `docs/specs/2026-05-13-search-issue-keys.md` (lines 24–280) | ~2,500 |
| This story | ~600 |
| Research report (skim for algorithm decision) | ~500 |
| **Total** | **~18,300** |

Well within the 20–30% agent context window limit. No split required.

## Previous Story Intelligence

The predecessor story for this feature is `issue-350` (`search_issue_keys`
lightweight API). Key lessons that carry forward:

1. **Length-strict field assertions**: Use `MockServer::received_requests()`
   + `assert_eq!` on `serde_json::Value` rather than `wiremock::body_partial_json`
   matchers — wiremock's matcher uses subset semantics for arrays (lesson from
   AC-001 of issue-350, Copilot R3 retraction §Q3).
2. **Subprocess vs library tests for stderr**: `eprintln!` cannot be captured
   inside library-level tokio tests. The JRACLOUD-95368 literal is already
   pinned by a subprocess test in `tests/search_issue_keys.rs`. Do not
   duplicate it — it is unchanged by this PR.
3. **`JRACLOUD-94632` vs `JRACLOUD-95368`**: the canonical ticket number for
   live-data-drift-induced cursor repetition is JRACLOUD-95368. JRACLOUD-94632
   is the server-bug variant (already addressed). AC-008 requires replacing
   BOTH occurrences on line 496 of `bc-2-issue-read.md`.
4. **`has_more` guard-abort arm**: PR #362 Copilot R1 fixed the guard-abort
   path to set `has_more = true` (not leave it false). That semantic is
   unchanged by dedupe — `has_more` remains `true` on guard-abort.
5. **NEGATIVE-PIN tests**: Label them with `// NEGATIVE-PIN:` in the doc-comment
   and state that a future PR fixing the described regression MUST update the
   assertion in lockstep. This is the pattern established for Risk #5.

## File Structure Requirements

```
tests/search_issue_keys.rs
  Line ~307: rename test_search_issue_keys_repeated_cursor_abort_does_not_dedupe
             → test_search_issue_keys_repeated_cursor_abort_dedupes (flip assertion)
  After renamed test: test_search_issue_keys_dedupes_non_consecutive_across_pages (new)
  After that: test_search_issue_keys_limit_truncation_dedupes_under_drift (new)
  After that: test_search_issue_keys_apr2025_overshoot_silenced_by_drift_dedupe (new, NEGATIVE-PIN)

tests/rate_limit_cap_tests.rs
  After existing search_issues tests:
    test_search_issues_repeated_cursor_abort_dedupes (new)
    test_search_issues_dedupes_non_consecutive_across_pages (new)
    test_search_issues_limit_truncation_dedupes_under_drift (new)
    test_search_issues_apr2025_overshoot_silenced_by_drift_dedupe (new, NEGATIVE-PIN)

src/api/jira/issues.rs
  search_issue_keys loop: dedupe block inserted after extend, before truncation check
  search_issues loop: dedupe block inserted after extend (line 214), before truncation (line 216)
  Rustdoc: KeySearchResult (lines 65–115), SearchResult (lines 31–63), guard blocks

.factory/specs/prd/bc-2-issue-read.md
  BC-2.6.050 Behavior: append dedupe paragraph
  Line 496: both JRACLOUD-94632 → JRACLOUD-95368
  After BC-2.6.050: add full BC-2.6.051 body
  Frontmatter + footer: counts updated

.factory/specs/prd/BC-INDEX.md
  10 individual edit locations (see AC-009)

docs/specs/2026-05-13-search-issue-keys.md
  6 edits at lines 28, 243, 258, 266, 271, 276 (see AC-010 items a–f)
```

## References

- **Feature spec (approved v0.1.12):**
  `docs/specs/2026-05-14-search-issue-keys-dedupe.md`
- **Research validation:**
  `.factory/research/issue-365-design-validation.md`
- **BC-2.6.050 (existing):**
  `.factory/specs/prd/bc-2-issue-read.md` lines 491–497
- **BC-2.6.051 (new — created by this PR):**
  Body text in feature spec §Update 3
- **Parent spec (to be updated):**
  `docs/specs/2026-05-13-search-issue-keys.md`
- **Predecessor story:**
  `.factory/code-delivery/issue-350/story.md`
- **Related issues:**
  #350 (search_issue_keys implementation), #361 (JRACLOUD-95368 rebind),
  #362 (guard-abort has_more fix), #365 (this feature)

## Risk / Notes

- **Non-consecutive duplicate is the load-bearing case.** `Vec::dedup()` would
  pass a consecutive-only test but silently fail the JRACLOUD-95368 scenario
  (page 2 emits `["X-2", "X-1"]`). The `test_search_issue_keys_dedupes_non_consecutive_across_pages`
  and `test_search_issues_dedupes_non_consecutive_across_pages` tests exist
  specifically to prevent this regression.
- **NEGATIVE-PIN tests must not be "fixed" during implementation.** The
  Risk #5 regression (`has_more = false` silenced by dedupe in the
  triple-collision corner) is documented intentional behavior for this PR.
  Any future PR fixing Risk #5 will update those assertions then.
- **Both JRACLOUD-94632 occurrences on line 496 of `bc-2-issue-read.md` must
  be updated.** A single-match substitution silently leaves the second
  occurrence stale. Verify with a search after editing.
- **`scripts/check-spec-counts.sh` is a hard pre-push gate.** Run it after
  all BC edits and before any push. It exits 1 with specific mismatch details
  if any count drifts.
- **`search_issue_keys` guard-abort block currently says "this function does
  NOT dedupe."** This comment is the most visible signal of the old contract;
  updating it (AC-007) is load-bearing for future maintainers.
