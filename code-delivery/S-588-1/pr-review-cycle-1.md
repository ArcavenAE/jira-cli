# PR Review — S-588-1 (`--sort <field>:asc|desc`), Cycle 1

APPROVE: Additive, read-only-command change that faithfully implements BC-2.1.024 (syntax parse/validate) and BC-2.1.025 (uniform `order_by` override across all 4 composition branches). No blocking findings.

## Verified

- **Spec fidelity — BC-2.1.024:** `parse_sort` splits on the FIRST `:` (`split_once`), matches direction case-insensitively (`eq_ignore_ascii_case`), preserves field verbatim (no trimming), and rejects every malformed shape (no `:`, empty field, empty direction, bad direction, second `:` in direction) with the exact pinned stderr literal and `JrError::UserError` (exit 64). Validation runs before any HTTP call — parsed once at the top of `handle_list` (`list.rs:196`), reused later.
- **Spec fidelity — BC-2.1.025:** override applied strictly AFTER the 4-branch match/if block (`list.rs:557-560`) by shadowing `order_by`; `None` arm leaves the branch value byte-for-byte unchanged, protecting BC-2.1.002/003/004/005's pinned literals (AC-007). `compose_order_by_with_sort` appends `, key ASC` except when the field matches `key` case-insensitively, and preserves the field's own casing (AC-010). No local field-name allowlist — pass-through to Jira (AC-008). Not added to the no-filters enumeration (AC-009).
- **Test coverage:** all 10 ACs covered. Unit tests for pure `parse_sort`/`compose_order_by_with_sort`; integration tests exercise all 4 branches (default-project, `--jql`, kanban, scrum-active-sprint), filter composition, key-omission casing, filter-guard exclusion, and Jira-400 pass-through with a `.expect(0)` pre-HTTP proof for malformed input. Exact-string JQL equality, not substring containment.
- **Quality gates (run locally in worktree):** 10 new unit tests + 12 new integration tests all pass; `cargo clippy --all-targets` clean (zero warnings); CLI help text on `--sort` accurately describes override + secondary-sort + pass-through behavior.
- Security review already PASS_WITH_NOTES (0 blocking).

## Non-blocking observations

- The two integration tests in `tests/issue_list_errors.rs` (`issue_list_sort_malformed_input_exits_64_pre_http`, `issue_list_sort_unknown_field_propagates_jira_400`) omit the `test_` prefix from the repo's `test_<verb>_<subject>_<outcome>` convention — but they correctly match the surrounding file's established local convention (`issue_list_fields_empty_csv_exits_64_pre_http` etc.), so this is consistent, not a defect.
- Verbatim field preservation means values like `--sort " key ":asc` are passed through with whitespace intact — this is spec-mandated ("no trimming beyond the split"), noted only for completeness.
