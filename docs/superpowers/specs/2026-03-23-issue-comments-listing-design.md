# Issue Comments Listing Design

## Goal

Add `jr issue comments KEY` to list comments on a Jira issue, filling the read-side gap where `jr issue comment KEY` only supports adding comments.

## Command Interface

```
jr issue comments KEY [--limit N]
```

- `KEY` — required positional argument (issue key, e.g. `PROJ-123`)
- `--limit N` — optional cap on number of comments returned (default: all)
- Respects global flags: `--output json|table`, `--no-color`, `--no-input`

### Table Output

```
┌─────────────┬──────────────────┬──────────────────────────────┐
│ Author      │ Date             │ Body                         │
├─────────────┼──────────────────┼──────────────────────────────┤
│ Jane Smith  │ 2026-03-20 14:32 │ Looks good, approved.        │
│ John Doe    │ 2026-03-21 09:15 │ Found an issue with the      │
│             │                  │ login flow — see attached.   │
└─────────────┴──────────────────┴──────────────────────────────┘
```

- Author: `display_name` from the comment's `author` field, or `"(unknown)"` if absent
- Date: ISO 8601 `created` timestamp formatted as `YYYY-MM-DD HH:MM`
- Body: ADF converted to plain text via existing `adf::adf_to_text()`. Column sizing and wrapping handled by comfy-table's `ContentArrangement::Dynamic`
- Empty list (table): prints `"No results found."` (existing `print_output` behavior)
- Empty list (JSON): returns `[]`

### JSON Output

Raw `Vec<Comment>` serialized as a JSON array. Each comment includes `id`, `body` (ADF or `null` if absent), `author`, `created` as returned by the API. Fields use `Option` types so missing values serialize as `null` (no `skip_serializing_if` — consistent with existing `Comment` derive).

## Design Rationale

### Standalone subcommand vs flag on `issue view`

`jr issue comments KEY` is a standalone subcommand rather than a `--comments` flag on `issue view` because:

1. Comments are a separate queryable resource with their own pagination, not a display toggle
2. Matches the existing `worklog list` pattern — list a resource associated with an issue
3. Output is a clean table that pipes naturally to other tools
4. Keeps `issue view` focused on issue metadata

### Naming: `comments` (plural) vs extending `comment` (singular)

The plural `comments` lists the collection; the singular `comment` mutates (adds). This follows `gh` conventions (`gh pr comment` to add, plural noun for collections) and avoids overloading a single command for both read and write operations.

## API

### Endpoint

```
GET /rest/api/3/issue/{issueIdOrKey}/comment?startAt={startAt}&maxResults=100
```

- Offset-based pagination with `startAt`, `maxResults`, `total`
- Response returns items under the `"comments"` JSON key
- Default ordering is chronological (oldest first) — natural reading order for a conversation thread
- The `orderBy` parameter exists but we use the default

### Response Structure

```json
{
  "comments": [
    {
      "id": "10019",
      "self": "https://example.atlassian.net/rest/api/3/issue/10005/comment/10019",
      "author": { "accountId": "...", "displayName": "Jane Smith", ... },
      "body": { "type": "doc", "version": 1, "content": [...] },
      "created": "2026-03-20T14:32:00.000+0000"
    }
  ],
  "startAt": 0,
  "maxResults": 100,
  "total": 25
}
```

## Architecture

### File Changes

| File | Change |
|---|---|
| `src/cli/mod.rs` | Add `Comments { key: String, limit: Option<u32> }` variant to `IssueCommand` enum |
| `src/cli/issue/mod.rs` | Add dispatch arm for `IssueCommand::Comments` → `list::handle_comments` |
| `src/cli/issue/list.rs` | Add `handle_comments(key: &str, limit: Option<u32>, output_format: &OutputFormat, client: &JiraClient)` handler with date formatting helper |
| `src/api/jira/issues.rs` | Add `list_comments(key, limit)` method with auto-pagination loop |
| `src/api/pagination.rs` | Add `comments: Option<Vec<T>>` to `OffsetPage`, update `items()` priority chain. Update all existing struct-literal tests to include `comments: None` (required — Rust requires all fields in struct literals) |

### What Doesn't Change

- `Comment` type in `src/types/jira/issue.rs` — already has `id`, `body` (ADF Value), `author` (User), `created` (String)
- `src/adf.rs` — reuse `adf_to_text()` for body rendering
- `src/output.rs` — reuse `print_output()` for table/JSON dispatch
- `src/cli/issue/workflow.rs` — existing `handle_comment()` (add comment) is untouched

### Data Flow

1. CLI parses `jr issue comments KEY [--limit N]`
2. `handle_comments()` calls `client.list_comments(&key, limit)`
3. API method pages through `GET /rest/api/3/issue/{key}/comment?startAt=X&maxResults=100`
4. Each page deserialized as `OffsetPage<Comment>` (using `comments` key)
5. All comments collected into `Vec<Comment>`, capped at `--limit` if provided
6. Table path: each comment mapped to `[author_name, formatted_date, adf_to_text(body)]`
7. JSON path: `Vec<Comment>` serialized directly

### Pagination

Auto-pagination loop matching the pattern in `list_boards()` and `list_sprints()`:

```rust
pub async fn list_comments(&self, key: &str, limit: Option<u32>) -> Result<Vec<Comment>> {
    let base = format!("/rest/api/3/issue/{}/comment", urlencoding::encode(key));
    let mut all = Vec::new();
    let mut start_at = 0u32;
    let page_size = 100;

    loop {
        let path = format!("{}?startAt={}&maxResults={}", base, start_at, page_size);
        let page: OffsetPage<Comment> = self.get(&path).await?;
        let has_more = page.has_more();
        let next = page.next_start();
        all.extend(page.items().to_vec());

        if let Some(cap) = limit {
            if all.len() >= cap as usize {
                all.truncate(cap as usize);
                break;
            }
        }
        if !has_more { break; }
        start_at = next;
    }
    Ok(all)
}
```

### OffsetPage Update

Add `comments` to the existing priority chain in `items()`:

```rust
pub struct OffsetPage<T> {
    pub values: Option<Vec<T>>,
    pub issues: Option<Vec<T>>,
    pub worklogs: Option<Vec<T>>,
    pub comments: Option<Vec<T>>,  // NEW
    // ...pagination fields...
}

impl<T> OffsetPage<T> {
    pub fn items(&self) -> &[T] {
        if let Some(ref v) = self.values { return v; }
        if let Some(ref v) = self.issues { return v; }
        if let Some(ref v) = self.worklogs { return v; }
        if let Some(ref v) = self.comments { return v; }  // NEW
        &[]
    }
}
```

### Date Formatting

A helper function in `list.rs` to format ISO 8601 timestamps:

```rust
fn format_comment_date(iso: &str) -> String {
    chrono::DateTime::parse_from_rfc3339(iso)
        .or_else(|_| chrono::DateTime::parse_from_str(iso, "%Y-%m-%dT%H:%M:%S%.3f%z"))
        .map(|dt| dt.format("%Y-%m-%d %H:%M").to_string())
        .unwrap_or_else(|_| iso.to_string())
}
```

Falls back to the raw string if parsing fails — never errors on bad date input.

## Error Handling

- **Issue not found** → Jira returns 404, `JiraClient` propagates the error
- **No comments (table)** → "No results found." message (existing `print_output` behavior)
- **No comments (JSON)** → `[]`
- **Auth failure** → Existing 401/403 handling in `JiraClient`
- **Rate limiting** → Existing retry logic in `JiraClient`

## Testing

### Unit Tests (`src/cli/issue/list.rs`)

- `format_comment_date` — valid RFC 3339 input (`2026-03-20T14:32:00+00:00`) produces `2026-03-20 14:32`
- `format_comment_date` — Jira-style offset without colon (`2026-03-20T14:32:00.000+0000`) produces `2026-03-20 14:32`
- `format_comment_date` — malformed input returns the raw string (no panic)
- Row formatting with missing author → `"(unknown)"`
- Row formatting with missing body → `"(no content)"`

### Unit Tests (`src/api/pagination.rs`)

- `OffsetPage::items()` returns from `comments` field when populated (parallel to existing `test_offset_page_items_from_issues`)
- Update all existing `OffsetPage` struct literal tests to include `comments: None`

### Integration Tests (wiremock)

- `list_comments` — paginated response (2 pages) returns all comments in order
- `list_comments` — empty `comments` array returns empty vec
- `list_comments` with `--limit 1` — stops after first page when limit reached
