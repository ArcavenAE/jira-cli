## Fresh-eyes PR review — PR #691 (S-668-1)

**VERDICT: APPROVE** · Covered SHA: `c382f69d`

Independent PR-diff review (a different lens from the prior adversarial passes). All 13 changed files reviewed against the diff and PR description only (no wider codebase access — intentional fresh-eyes posture). **No BLOCKING findings. One LOW nit (non-blocking).**

> Posted to GitHub as a review in **COMMENT** state, not APPROVE — the reviewing identity equals the PR author (`Zious11`), so GitHub rejects a formal `--approve` from the author. The APPROVE verdict above is authoritative.

### Scope
Surfaces Jira `duedate` end-to-end: `IssueFields.duedate: Option<String>` (named field, not serde-flatten), added to `BASE_ISSUE_FIELDS`, an always-on "Due Date" row in `issue view`, and an opt-in `--duedate` column in `issue list`. Read-side additive change; +1176/-18.

### Claim-by-claim verification (all confirmed against the diff)

| Claim | Result |
|---|---|
| Verbatim rendering, no parser | PASS — `render_due_date` returns raw string when non-empty, `"-"` otherwise. No chrono, no reformat. |
| Shared helper, both call sites | PASS — `render_due_date(Option<&str>)` in `format.rs`, called from `view.rs` (row) and `format_issue_row` (column). No duplicated logic. |
| Column order Priority → [Due Date] → [Points] → Assignee | PASS — insertion after Priority in both `issue_table_headers` and `format_issue_row`; pinned by `test_issue_table_headers_full_order_with_all_optional_columns` + `test_format_issue_row_all_optional_columns_present_matches_header_order` (full 10-col order) and CLI-level EC-5. |
| `-` for unset (`None`/`Some("")`) | PASS — list.rs passes `Some("")` (not `None`) so the column stays shown; unit + CLI tests cover empty-string and None. |
| `--duedate` no-op on `--output json` | PASS — AC-9 asserts byte-equality with/without flag and no stderr warning; JSON always carries `fields.duedate` (named field + unconditional in `BASE_ISSUE_FIELDS`). |
| Named `Option<String>`, not flatten | PASS — asserts `!fields.extra.contains_key("duedate")` and serialization at `fields.duedate` (null when unset, present not omitted). |
| Scope = `issue list` only | PASS — board.rs, queue.rs ×2, sprint.rs, `format_issue_rows_public` all pass `None`/`false`; regression guards confirm board/sprint/queue show no Due Date column even with a set value. Signature change → any miss is a compile error. |
| BASE_ISSUE_FIELDS 17-element array | PASS — `test_search_issues_includes_labels_parent_issuelinks` updated (17 elements incl. `duedate`). |
| view.rs row between Updated and Project | PASS — AC-4 asserts `updated < due_date < project` line order. |

### Test quality
Strong and non-vacuous. Tests exercise the actual claims, not proxies: verbatim byte rendering (unit + CLI `table_cells` column-parsing helper with documented comfy-table separator rationale), full column order with every optional column present simultaneously, JSON no-op equality, present-as-null vs verbatim, and three regression guards (board/sprint/queue) each with positive anchors (`PROJ-1`, `Priority`) so the negative `!contains("Due Date")` assertions cannot pass vacuously.

### Findings
- **LOW (non-blocking, posted inline on `src/cli/issue/format.rs:123`):** `due_date_header()` is a single-use one-liner returning a string literal — reads inconsistently next to sibling inline `headers.push("Points")` and duplicates the `"Due Date"` string also inlined in `view.rs`. Suggest inlining or a shared `const`. Cosmetic; not a merge blocker.

No CRITICAL / HIGH / MEDIUM findings. Clean additive read-side change; APPROVE pending CI.
