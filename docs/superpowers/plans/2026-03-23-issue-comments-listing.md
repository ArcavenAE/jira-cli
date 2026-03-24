# Issue Comments Listing Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `jr issue comments KEY` to list comments on a Jira issue with table and JSON output.

**Architecture:** Add a `Comments` variant to `IssueCommand`, a paginated `list_comments()` API method using `OffsetPage` (with new `comments` key), and a `handle_comments()` handler in `list.rs` that renders Author/Date/Body columns. Existing `Comment` type, `adf_to_text()`, and `print_output()` are reused.

**Tech Stack:** Rust, clap, reqwest, serde, comfy-table, chrono

**Spec:** `docs/superpowers/specs/2026-03-23-issue-comments-listing-design.md`

---

## File Structure

| File | Responsibility | Change |
|------|---------------|--------|
| `src/types/jira/issue.rs:121-127` | `Comment` type | Add `Clone` derive |
| `src/api/pagination.rs:9-28` | `OffsetPage` struct | Add `comments` field |
| `src/api/pagination.rs:30-44` | `OffsetPage::items()` | Add `comments` to priority chain |
| `src/api/pagination.rs:75-133` | `OffsetPage` tests | Add `comments: None` to all struct literals, add new test |
| `src/api/jira/issues.rs` | API methods | Add `list_comments()` with auto-pagination |
| `src/cli/mod.rs:108-266` | `IssueCommand` enum | Add `Comments` variant |
| `src/cli/issue/mod.rs:25-74` | Issue dispatch | Add `Comments` match arm |
| `src/cli/issue/list.rs` | Handlers | Add `handle_comments()` + `format_comment_date()` + tests |

---

### Task 1: Add `Clone` to `Comment` and extend `OffsetPage` with `comments` key

**Files:**
- Modify: `src/types/jira/issue.rs:121`
- Modify: `src/api/pagination.rs:6-7,9-28,30-44,75-133`

- [ ] **Step 1: Write failing test for `OffsetPage::items()` returning from `comments` field**

In `src/api/pagination.rs`, add this test at the end of the `mod tests` block (after line 132, before the closing `}`):

```rust
    #[test]
    fn test_offset_page_items_from_comments() {
        let page: OffsetPage<String> = OffsetPage {
            values: None,
            issues: None,
            worklogs: None,
            comments: None,
            start_at: 0,
            max_results: 50,
            total: 1,
        };
        // With no comments, items() returns empty
        assert!(page.items().is_empty());

        let page_with_comments: OffsetPage<String> = OffsetPage {
            values: None,
            issues: None,
            worklogs: None,
            comments: Some(vec!["comment-1".into()]),
            start_at: 0,
            max_results: 50,
            total: 1,
        };
        assert_eq!(page_with_comments.items(), &["comment-1".to_string()]);
    }
```

- [ ] **Step 2: Run test to verify it fails**

```bash
cargo test --lib pagination
```

Expected: FAIL — `OffsetPage` has no `comments` field.

- [ ] **Step 3: Add `comments` field to `OffsetPage` struct**

In `src/api/pagination.rs`, add the new field after the `worklogs` field (after line 18):

```rust
    /// Items returned under the "comments" key (comment endpoints).
    #[serde(default)]
    pub comments: Option<Vec<T>>,
```

- [ ] **Step 4: Update `OffsetPage::items()` to include `comments` in the priority chain**

In `src/api/pagination.rs`, add before the final `&[]` in `items()` (after the `worklogs` check on line 42):

```rust
        if let Some(ref v) = self.comments {
            return v;
        }
```

Also update the doc comment on `items()` (line 32) from:

```rust
    /// Returns a reference to whichever item list is populated, preferring
    /// `values` > `issues` > `worklogs`. Returns an empty slice if none are set.
```

to:

```rust
    /// Returns a reference to whichever item list is populated, preferring
    /// `values` > `issues` > `worklogs` > `comments`. Returns an empty slice if none are set.
```

And update the struct-level doc comment (line 4-5) from:

```rust
/// Different endpoints return items under different keys (`values`, `issues`, `worklogs`),
/// so all three are optional — callers use `items()` to get whichever is populated.
```

to:

```rust
/// Different endpoints return items under different keys (`values`, `issues`, `worklogs`,
/// `comments`), so all four are optional — callers use `items()` to get whichever is populated.
```

- [ ] **Step 5: Update all existing `OffsetPage` struct literal tests to include `comments: None`**

In `src/api/pagination.rs`, update the three existing tests that construct `OffsetPage` literals. Add `comments: None,` after `worklogs: None,` in each:

**`test_offset_page_has_more` (line 81-88):**
```rust
        let page: OffsetPage<String> = OffsetPage {
            values: Some(vec!["a".into(), "b".into()]),
            issues: None,
            worklogs: None,
            comments: None,
            start_at: 0,
            max_results: 2,
            total: 5,
        };
```

**`test_offset_page_last_page` (line 95-103):**
```rust
        let page: OffsetPage<String> = OffsetPage {
            values: Some(vec!["a".into()]),
            issues: None,
            worklogs: None,
            comments: None,
            start_at: 4,
            max_results: 2,
            total: 5,
        };
```

**`test_offset_page_items_from_issues` (line 108-116):**
```rust
        let page: OffsetPage<String> = OffsetPage {
            values: None,
            issues: Some(vec!["issue-1".into()]),
            worklogs: None,
            comments: None,
            start_at: 0,
            max_results: 50,
            total: 1,
        };
```

- [ ] **Step 6: Add `Clone` derive to `Comment`**

In `src/types/jira/issue.rs`, change line 121 from:

```rust
#[derive(Debug, Deserialize, Serialize)]
```

to:

```rust
#[derive(Debug, Clone, Deserialize, Serialize)]
```

This is required because `list_comments()` uses `page.items().to_vec()` which needs `Clone`.

- [ ] **Step 7: Run tests to verify everything passes**

```bash
cargo test --lib pagination && cargo test --lib issue
```

Expected: All pagination tests pass (including the new `test_offset_page_items_from_comments`). All issue type tests pass.

- [ ] **Step 8: Run clippy and fmt**

```bash
cargo clippy --all --all-features --tests -- -D warnings && cargo fmt --all
```

Expected: Zero warnings, formatting clean.

- [ ] **Step 9: Commit**

```bash
git add src/api/pagination.rs src/types/jira/issue.rs
git commit -m "feat: add comments key to OffsetPage and Clone to Comment

Extend OffsetPage with a comments field for the Jira comments endpoint.
Add Clone derive to Comment for pagination collection.

Part of issue comments listing feature."
```

---

### Task 2: Add `list_comments()` API method

**Files:**
- Modify: `src/api/jira/issues.rs:1-123`

- [ ] **Step 1: Add `list_comments()` method to `JiraClient`**

In `src/api/jira/issues.rs`, add the following method inside the `impl JiraClient` block, after the existing `add_comment` method (after line 122, before the closing `}`):

```rust
    /// List comments on an issue with auto-pagination.
    pub async fn list_comments(
        &self,
        key: &str,
        limit: Option<u32>,
    ) -> Result<Vec<Comment>> {
        let base = format!(
            "/rest/api/3/issue/{}/comment",
            urlencoding::encode(key)
        );
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
            if !has_more {
                break;
            }
            start_at = next;
        }
        Ok(all)
    }
```

Also add the `OffsetPage` import at the top of the file. Change line 2 from:

```rust
use crate::api::pagination::CursorPage;
```

to:

```rust
use crate::api::pagination::{CursorPage, OffsetPage};
```

- [ ] **Step 2: Verify it compiles**

```bash
cargo check
```

Expected: Compiles with no errors.

- [ ] **Step 3: Run clippy and fmt**

```bash
cargo clippy --all --all-features --tests -- -D warnings && cargo fmt --all
```

Expected: Zero warnings, formatting clean.

- [ ] **Step 4: Commit**

```bash
git add src/api/jira/issues.rs
git commit -m "feat: add list_comments API method with auto-pagination

Fetches comments via GET /rest/api/3/issue/{key}/comment with offset-based
pagination. Supports optional limit parameter.

Part of issue comments listing feature."
```

---

### Task 3: Add `Comments` CLI variant and dispatch

**Files:**
- Modify: `src/cli/mod.rs:220-235`
- Modify: `src/cli/issue/mod.rs:63-65`

- [ ] **Step 1: Add `Comments` variant to `IssueCommand` enum**

In `src/cli/mod.rs`, add the new variant after the existing `Comment` variant (after line 235, before the `Open` variant):

```rust
    /// List comments on an issue
    Comments {
        /// Issue key (e.g., FOO-123)
        key: String,
        /// Maximum number of comments to return
        #[arg(long)]
        limit: Option<u32>,
    },
```

- [ ] **Step 2: Add dispatch arm in `src/cli/issue/mod.rs`**

In `src/cli/issue/mod.rs`, add the match arm for `Comments` inside the `match command` block. Add it after the existing `Comment` arm (after line 65, before `IssueCommand::Open`):

```rust
        IssueCommand::Comments { key, limit } => {
            list::handle_comments(&key, limit, output_format, client).await
        }
```

- [ ] **Step 3: Verify it compiles (expect error — `handle_comments` doesn't exist yet)**

```bash
cargo check 2>&1 | head -20
```

Expected: Error mentioning `handle_comments` not found in `list`. This confirms the wiring is correct and the next task will satisfy it.

- [ ] **Step 4: Commit (partial — compile will succeed after Task 4)**

Do NOT commit yet — wait until Task 4 adds the handler so the commit compiles.

---

### Task 4: Add `handle_comments()` handler with tests

**Files:**
- Modify: `src/cli/issue/list.rs`

- [ ] **Step 1: Write failing unit tests for `format_comment_date`**

In `src/cli/issue/list.rs`, add the following tests inside the existing `mod tests` block (after the last test, before the closing `}`):

```rust
    #[test]
    fn format_comment_date_rfc3339() {
        assert_eq!(
            format_comment_date("2026-03-20T14:32:00+00:00"),
            "2026-03-20 14:32"
        );
    }

    #[test]
    fn format_comment_date_jira_offset_no_colon() {
        // Jira returns offsets without colon: +0000 not +00:00
        assert_eq!(
            format_comment_date("2026-03-20T14:32:00.000+0000"),
            "2026-03-20 14:32"
        );
    }

    #[test]
    fn format_comment_date_malformed_returns_raw() {
        assert_eq!(format_comment_date("not-a-date"), "not-a-date");
    }
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cargo test --lib list::tests::format_comment_date
```

Expected: FAIL — `format_comment_date` function does not exist.

- [ ] **Step 3: Implement `format_comment_date` helper**

In `src/cli/issue/list.rs`, add this function after `build_fallback_jql` (after line 190, before the `// ── View ──` comment):

```rust
// ── Comments ─────────────────────────────────────────────────────────

fn format_comment_date(iso: &str) -> String {
    chrono::DateTime::parse_from_rfc3339(iso)
        .or_else(|_| chrono::DateTime::parse_from_str(iso, "%Y-%m-%dT%H:%M:%S%.3f%z"))
        .map(|dt| dt.format("%Y-%m-%d %H:%M").to_string())
        .unwrap_or_else(|_| iso.to_string())
}
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
cargo test --lib list::tests::format_comment_date
```

Expected: All 3 tests pass.

- [ ] **Step 5: Write failing unit tests for comment row formatting**

In `src/cli/issue/list.rs`, add these tests inside `mod tests`:

```rust
    #[test]
    fn format_comment_row_missing_author() {
        let row = format_comment_row(None, Some("2026-03-20T14:32:00+00:00"), None);
        assert_eq!(row[0], "(unknown)");
    }

    #[test]
    fn format_comment_row_missing_body() {
        let row = format_comment_row(
            Some("Jane Smith"),
            Some("2026-03-20T14:32:00+00:00"),
            None,
        );
        assert_eq!(row[2], "(no content)");
    }
```

- [ ] **Step 6: Run tests to verify they fail**

```bash
cargo test --lib list::tests::format_comment_row
```

Expected: FAIL — `format_comment_row` does not exist.

- [ ] **Step 7: Implement `format_comment_row` helper and `handle_comments` handler**

In `src/cli/issue/list.rs`, add the following after `format_comment_date` (still before the `// ── View ──` comment):

```rust
fn format_comment_row(
    author_name: Option<&str>,
    created: Option<&str>,
    body_text: Option<&str>,
) -> Vec<String> {
    vec![
        author_name.unwrap_or("(unknown)").to_string(),
        created
            .map(format_comment_date)
            .unwrap_or_else(|| "-".into()),
        body_text.unwrap_or("(no content)").to_string(),
    ]
}

pub(super) async fn handle_comments(
    key: &str,
    limit: Option<u32>,
    output_format: &OutputFormat,
    client: &JiraClient,
) -> Result<()> {
    let comments = client.list_comments(key, limit).await?;

    let rows: Vec<Vec<String>> = comments
        .iter()
        .map(|c| {
            let author = c.author.as_ref().map(|a| a.display_name.as_str());
            let created = c.created.as_deref();
            let body_text = c.body.as_ref().map(adf::adf_to_text);
            format_comment_row(author, created, body_text.as_deref())
        })
        .collect();

    output::print_output(output_format, &["Author", "Date", "Body"], &rows, &comments)?;

    Ok(())
}
```

- [ ] **Step 8: Run all tests**

```bash
cargo test --lib
```

Expected: All tests pass — pagination, date formatting, row formatting, and existing tests.

- [ ] **Step 9: Run clippy and fmt**

```bash
cargo clippy --all --all-features --tests -- -D warnings && cargo fmt --all
```

Expected: Zero warnings, formatting clean.

- [ ] **Step 10: Commit (includes Task 3 CLI wiring + Task 4 handler)**

```bash
git add src/cli/mod.rs src/cli/issue/mod.rs src/cli/issue/list.rs
git commit -m "feat: add jr issue comments command for listing comments

Add Comments variant to IssueCommand, dispatch in issue/mod.rs, and
handle_comments handler in list.rs. Renders Author/Date/Body table
with ADF-to-text conversion. Includes format_comment_date helper
with RFC 3339 and Jira offset format support.

Part of issue comments listing feature."
```

---

### Task 5: Integration tests

**Files:**
- Create: `tests/comments.rs`

- [ ] **Step 1: Check existing integration test patterns**

Read `tests/` directory for existing integration test files to follow patterns (wiremock setup, fixture helpers, etc.):

```bash
ls tests/
```

Read one existing integration test file (e.g., `tests/common/fixtures.rs` and one test file) to understand patterns.

- [ ] **Step 2: Write integration tests**

Create `tests/comments.rs`. Use the same setup pattern as `tests/worklog_commands.rs` — construct `MockServer` and `JiraClient` inline:

```rust
#[allow(dead_code)]
mod common;

use serde_json::json;
use wiremock::matchers::{method, path, query_param};
use wiremock::{Mock, MockServer, ResponseTemplate};

#[tokio::test]
async fn list_comments_returns_all_comments() {
    let server = MockServer::start().await;

    Mock::given(method("GET"))
        .and(path("/rest/api/3/issue/FOO-1/comment"))
        .and(query_param("startAt", "0"))
        .and(query_param("maxResults", "100"))
        .respond_with(ResponseTemplate::new(200).set_body_json(json!({
            "comments": [
                {
                    "id": "10001",
                    "author": { "accountId": "abc", "displayName": "Alice", "emailAddress": "a@test.com", "active": true },
                    "body": { "type": "doc", "version": 1, "content": [{ "type": "paragraph", "content": [{ "type": "text", "text": "First comment" }] }] },
                    "created": "2026-03-20T10:00:00.000+0000"
                },
                {
                    "id": "10002",
                    "author": { "accountId": "def", "displayName": "Bob", "emailAddress": "b@test.com", "active": true },
                    "body": { "type": "doc", "version": 1, "content": [{ "type": "paragraph", "content": [{ "type": "text", "text": "Second comment" }] }] },
                    "created": "2026-03-21T11:00:00.000+0000"
                }
            ],
            "startAt": 0,
            "maxResults": 100,
            "total": 2
        })))
        .mount(&server)
        .await;

    let client = jr::api::client::JiraClient::new_for_test(server.uri(), "Basic dGVzdDp0ZXN0".to_string());
    let comments = client.list_comments("FOO-1", None).await.unwrap();
    assert_eq!(comments.len(), 2);
    assert_eq!(comments[0].id.as_deref(), Some("10001"));
    assert_eq!(comments[1].id.as_deref(), Some("10002"));
}

#[tokio::test]
async fn list_comments_empty() {
    let server = MockServer::start().await;

    Mock::given(method("GET"))
        .and(path("/rest/api/3/issue/FOO-2/comment"))
        .respond_with(ResponseTemplate::new(200).set_body_json(json!({
            "comments": [],
            "startAt": 0,
            "maxResults": 100,
            "total": 0
        })))
        .mount(&server)
        .await;

    let client = jr::api::client::JiraClient::new_for_test(server.uri(), "Basic dGVzdDp0ZXN0".to_string());
    let comments = client.list_comments("FOO-2", None).await.unwrap();
    assert!(comments.is_empty());
}

#[tokio::test]
async fn list_comments_with_limit() {
    let server = MockServer::start().await;

    Mock::given(method("GET"))
        .and(path("/rest/api/3/issue/FOO-3/comment"))
        .and(query_param("startAt", "0"))
        .and(query_param("maxResults", "100"))
        .respond_with(ResponseTemplate::new(200).set_body_json(json!({
            "comments": [
                {
                    "id": "10001",
                    "author": { "accountId": "abc", "displayName": "Alice", "emailAddress": "a@test.com", "active": true },
                    "body": null,
                    "created": "2026-03-20T10:00:00.000+0000"
                },
                {
                    "id": "10002",
                    "author": { "accountId": "def", "displayName": "Bob", "emailAddress": "b@test.com", "active": true },
                    "body": null,
                    "created": "2026-03-21T11:00:00.000+0000"
                }
            ],
            "startAt": 0,
            "maxResults": 100,
            "total": 2
        })))
        .mount(&server)
        .await;

    let client = jr::api::client::JiraClient::new_for_test(server.uri(), "Basic dGVzdDp0ZXN0".to_string());
    let comments = client.list_comments("FOO-3", Some(1)).await.unwrap();
    assert_eq!(comments.len(), 1);
    assert_eq!(comments[0].id.as_deref(), Some("10001"));
}

#[tokio::test]
async fn list_comments_paginated() {
    let server = MockServer::start().await;

    // Page 1
    Mock::given(method("GET"))
        .and(path("/rest/api/3/issue/FOO-4/comment"))
        .and(query_param("startAt", "0"))
        .respond_with(ResponseTemplate::new(200).set_body_json(json!({
            "comments": [
                {
                    "id": "10001",
                    "author": { "accountId": "abc", "displayName": "Alice", "emailAddress": "a@test.com", "active": true },
                    "body": null,
                    "created": "2026-03-20T10:00:00.000+0000"
                }
            ],
            "startAt": 0,
            "maxResults": 1,
            "total": 2
        })))
        .mount(&server)
        .await;

    // Page 2
    Mock::given(method("GET"))
        .and(path("/rest/api/3/issue/FOO-4/comment"))
        .and(query_param("startAt", "1"))
        .respond_with(ResponseTemplate::new(200).set_body_json(json!({
            "comments": [
                {
                    "id": "10002",
                    "author": { "accountId": "def", "displayName": "Bob", "emailAddress": "b@test.com", "active": true },
                    "body": null,
                    "created": "2026-03-21T11:00:00.000+0000"
                }
            ],
            "startAt": 1,
            "maxResults": 1,
            "total": 2
        })))
        .mount(&server)
        .await;

    let client = jr::api::client::JiraClient::new_for_test(server.uri(), "Basic dGVzdDp0ZXN0".to_string());
    let comments = client.list_comments("FOO-4", None).await.unwrap();
    assert_eq!(comments.len(), 2);
    assert_eq!(comments[0].id.as_deref(), Some("10001"));
    assert_eq!(comments[1].id.as_deref(), Some("10002"));
}
```

- [ ] **Step 3: Run integration tests**

```bash
cargo test --test comments
```

Expected: All 4 integration tests pass.

- [ ] **Step 4: Run full test suite**

```bash
cargo test --all-features
```

Expected: All tests pass (unit + integration + proptest).

- [ ] **Step 5: Run clippy and fmt**

```bash
cargo clippy --all --all-features --tests -- -D warnings && cargo fmt --all
```

Expected: Zero warnings, formatting clean.

- [ ] **Step 6: Commit**

```bash
git add tests/comments.rs
git commit -m "test: add integration tests for list_comments API method

Cover paginated response, empty comments, limit, and multi-page
pagination with wiremock.

Part of issue comments listing feature."
```
