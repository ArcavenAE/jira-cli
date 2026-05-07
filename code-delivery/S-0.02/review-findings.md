# Review Findings — S-0.02

**PR:** #290 — fix: paginate list_worklogs (S-0.02)
**Branch:** fix/paginate-list-worklogs
**Story:** S-0.02 — Paginate list_worklogs to prevent silent truncation

## Convergence Table

| Cycle | Findings | Blocking | Fixed | Remaining |
|-------|----------|----------|-------|-----------|
| 1     | 1        | 0        | 0     | 1 (SHOULD-FIX) |

## Cycle 1 Findings

### F-001 — Inconsistent pagination pattern (SHOULD-FIX)

**Severity:** SHOULD-FIX (not blocking)
**Category:** coherence
**Route:** implementer

**Finding:**

`list_worklogs` re-implements the termination condition inline:

```rust
let fetched_up_to = start_at + count;
if (page.total as usize) <= fetched_up_to || count == 0 {
    break;
}
start_at = fetched_up_to;
```

Every other paginating endpoint in `api/jira/` uses `page.has_more()` and `page.next_start()` — both already defined on `OffsetPage<T>` in `pagination.rs`. The reference pattern (from `boards.rs`, `sprints.rs`, `projects.rs`, `issues.rs`) is:

```rust
let has_more = page.has_more();
let next = page.next_start();
// extend items
if !has_more {
    break;
}
start_at = next;
```

The inline formula duplicates what `has_more()` already computes (`start_at + max_results < total`). The inline `count == 0` guard is a defensive addition not present in other implementations — while not harmful, it diverges from the established pattern.

**Impact:** Low. The behavior is correct for the normal Jira API contract. The `count == 0` guard provides extra safety but adds a second termination branch not tested by the existing AC tests (a server that returns `total > fetched_up_to` AND `count == 0` simultaneously — which is a malformed Jira response). This untested branch could mask infinite loops if the Jira API behaves unexpectedly.

**Suggested fix:** Replace the inline condition with `page.has_more()` / `page.next_start()`:

```rust
pub async fn list_worklogs(&self, key: &str) -> Result<Vec<Worklog>> {
    let base_path = format!("/rest/api/3/issue/{}/worklog", urlencoding::encode(key));
    let mut all_items: Vec<Worklog> = Vec::new();
    let mut start_at: u32 = 0;

    loop {
        let path = format!("{}?startAt={}", base_path, start_at);
        let page: OffsetPage<Worklog> = self.get(&path).await?;
        let has_more = page.has_more();
        let next = page.next_start();
        all_items.extend_from_slice(page.items());

        if !has_more {
            break;
        }
        start_at = next;
    }

    Ok(all_items)
}
```

Note: `start_at` type changes from `usize` to `u32` to match `next_start()` return type and the `OffsetPage` field types.

**Decision for this PR:** SHOULD-FIX. The current implementation is correct and all 4 ACs pass. However, adopting the shared helpers maintains codebase consistency and reduces the risk of future divergence. This is a small, safe refactor — recommend fixing before merge.

---

## Verdict

**Cycle 1: REQUEST_CHANGES (SHOULD-FIX only — no blocking findings)**

The implementation is functionally correct and all acceptance criteria pass. One SHOULD-FIX finding (F-001) recommends using the existing `page.has_more()` / `page.next_start()` helpers for consistency with the rest of the codebase. No blocking issues.

## Routing Table

| Finding | Severity | Category | Route | Action |
|---------|----------|----------|-------|--------|
| F-001 | SHOULD-FIX | coherence | implementer | Replace inline termination condition with `page.has_more()` / `page.next_start()` |
