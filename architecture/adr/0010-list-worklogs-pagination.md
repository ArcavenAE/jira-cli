# ADR-0010: list_worklogs Must Use Pagination Loop

## Status
Accepted

## Context

A HIGH-severity data-loss bug was discovered in `list_worklogs` (NFR-R-A, BC-X.5.002, NEW-INV-29). The function fetches a single `OffsetPage<Worklog>` and returns `.items().to_vec()` with no pagination loop. Atlassian's default page size for the worklogs endpoint is 50 (may be configured differently). Any issue with more than `maxResults` worklogs silently truncates to the first page, with no indication to the user that records were omitted.

**Bug anatomy (`src/api/jira/worklogs.rs:25-30`):**

```rust
// Current (broken — single page fetch)
pub async fn list_worklogs(&self, issue_key: &str) -> Result<Vec<Worklog>> {
    let page: OffsetPage<Worklog> = self.get(&format!("issue/{}/worklog", issue_key)).await?;
    Ok(page.items().to_vec())
}
```

**Contrast with `list_comments` (the correct pattern in the same codebase):**

```rust
// Correct — uses paginate_offset loop
pub async fn list_comments(&self, issue_key: &str) -> Result<Vec<Comment>> {
    paginate_offset(|start| async move {
        self.get(&format!("issue/{}/comment?startAt={}", issue_key, start)).await
    }).await
}
```

Both worklogs and comments are on the same issue; both use `OffsetPage<T>`. The comment endpoint was correctly paginated; the worklog endpoint was not.

## Decision

Refactor `list_worklogs` to use the `paginate_offset` helper (same as `list_comments`):

```rust
pub async fn list_worklogs(&self, issue_key: &str) -> Result<Vec<Worklog>> {
    paginate_offset(|start| async move {
        self.get(&format!("issue/{}/worklog?startAt={}", issue_key, start)).await
    }).await
}
```

## Rationale

- `paginate_offset` is the established pattern in `api/jira/` for offset-paginated endpoints. Using it here is consistent with the rest of the codebase.
- The fix is ~10 LOC, including the closure signature change.
- There is no valid reason to want only the first page of worklogs. The current behavior is a bug, not a deliberate design choice.
- Silent data truncation is a HIGH-severity reliability issue (users building reports from `jr worklog list` output would get wrong totals).

## Consequences

- **Fix scope:** ~10 LOC in `src/api/jira/worklogs.rs:25-30`.
- **Regression risk:** LOW. The behavior change is: users now see all worklogs, not just the first page. Any test that asserts a specific worklog count must be aware of this change.
- **Test requirement:** Add a 2-page worklog integration test. Set up a mock that returns two pages of worklogs (e.g., 50 + 3) and verify that `list_worklogs` returns all 53 items.
- **Performance note:** For issues with many hundreds of worklogs, the pagination loop may make multiple HTTP calls. This is correct behavior — users expect complete data, and worklogs are not a hot path.
- **BC anchor:** BC-X.5.002 (MUST-FIX forward-looking spec, traced from NFR-R-A).

## References

- NFR-R-A (nfr-catalog.md)
- BC-X.5.002 (cross-cutting.md in PRD)
- Pass 2 R2/R6 and Pass 3 R4 findings
- risk-register.md §R-H5
- cross-cutting.md §4 (pagination patterns)
