# Security Review — S-588-1 (`jr issue list --sort <field>:asc|desc`)

**PR:** https://github.com/Zious11/jira-cli/pull/726 (feat/issue-sort-shorthand → develop)
**Reviewer:** security-reviewer (manual review, no automated scanner)
**Scope:** `src/cli/mod.rs`, `src/cli/issue/list.rs` diff vs `origin/develop`, plus the downstream sink (`src/api/jira/issues.rs`) and existing escaping helper (`src/jql.rs`) read for context.

## Verdict: PASS_WITH_NOTES

No blocking findings. One informational/Low note (test-coverage suggestion only).

## Findings

| # | Severity | CWE | Location | Description | Status |
|---|----------|-----|----------|--------------|--------|
| 1 | Informational (not a defect) | CWE-89-analog (JQL injection) — assessed and refuted | `src/cli/issue/list.rs::compose_order_by_with_sort`, `handle_list` (~line 592: `format!("{where_clause} ORDER BY {order_by}")`) | `--sort`'s field string is concatenated unescaped into the JQL `ORDER BY` clause with no local allowlist. Confirmed NOT exploitable: (a) content is appended strictly after the already-finalized WHERE clause (`all_parts.join(" AND ")`) — `--sort` cannot reach or mutate `all_parts`, and JQL has no statement-stacking, so ORDER BY content can't be reinterpreted as an additional/preceding WHERE predicate; (b) ORDER BY is an unquoted identifier-list grammar position, not a string-literal context, so `src/jql.rs::escape_value` (used elsewhere for `project = "value"`) correctly does not apply here — its absence is by design, not an oversight; (c) the full JQL string is transmitted via `serde_json::json!({"jql": jql, ...})` (`src/api/jira/issues.rs:242,346,465,545`), i.e. proper JSON serialization, not raw string/HTTP-header concatenation, so no secondary JSON/HTTP injection surface. Worst case for a crafted field is a Jira-side 400 syntax error (already covered by the diff's own test `issue_list_sort_unknown_field_propagates_jira_400`). Enforcement of visibility/scope remains server-side (Jira ACLs) — identical trust posture to the pre-existing `--jql` flag, which already lets the same operator submit arbitrary JQL. `--sort` grants no new capability. | Resolved / non-issue — by design per BC-2.1.024 Precondition 1 |
| 2 | Low (informational) | — | `tests/issue_commands.rs`, `tests/issue_list_errors.rs` | No test in this diff feeds `--sort` an adversarial-shaped field (containing a quote, whitespace, or a JQL keyword like `AND`/`OR`) to explicitly pin "propagates as a literal value in the JSON body / surfaces as Jira 400, never escapes WHERE scope." Existing tests cover well-formed identifiers and one unknown-field 400 case (`customfield_10099`) but not deliberately malformed/injection-shaped strings. | Suggested, non-blocking |

## Other checks performed (all clean)

- **Pre-HTTP validation ordering**: `parse_sort` runs before project resolution, component pre-flight validation, and any network call (`list.rs` ~line 193) — malformed `--sort` costs zero HTTP requests, consistent with sibling flags (`--fields`, `--component`) in this file.
- **Direction validation**: `asc`/`desc` matched case-insensitively via a strict two-armed allowlist (`eq_ignore_ascii_case`) — no injection surface.
- **`allow_hyphen_values`**: not applied to `--sort`, and not needed — no issue.
- **State mutation**: `issue list` remains read-only; no new HTTP write path introduced.
- **Type safety**: the `order_by: &str` → `order_by: String` shadow (`list.rs` ~line 592) is intentional and correctly scoped, not a bug.
- **JSON serialization**: confirmed all four `search`/`approximate_count` call sites in `src/api/jira/issues.rs` build the request body via `serde_json::json!`, never manual string concatenation into a JSON payload.

## Recommendation

Merge as-is. Optionally add one regression test (per Finding #2) asserting an adversarial `--sort` field value (e.g. `foo" OR labels is EMPTY`) passes through byte-for-byte into the JSON `jql` body and does not alter `all_parts`/WHERE scope — this guards against a future well-intentioned but incorrect "fix" that tries to quote/escape the ORDER BY identifier (which isn't valid JQL syntax there and would break legitimate custom-field names containing spaces).
