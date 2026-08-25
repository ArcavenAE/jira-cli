---
document_type: f7-traceability-chain-delta
cycle: list-read-ergonomics
phase: F7
producer: orchestrator (F7 delta-convergence synthesis)
timestamp: "2026-08-24T18:00:00"
merged_tip: "37850b26eda42934c8d11d99863a7ebabcde5374"
---

# Traceability Chain Delta — `list-read-ergonomics`

Every link below was independently re-derived during F7 review: the story file was read for
its BC/AC/Test mapping, and every cited test function name was grep-confirmed to exist
verbatim in the named source or test file at `develop@37850b26` (the merged tip). Source line
numbers are approximate (`~`) per this repo's citation convention and will drift on refactor;
symbol names are the stable anchor.

---

## S-575-1 — `--fields <CSV>` on `issue list` / `issue view`

**Story:** `.factory/stories/S-575-1-fields-csv-list-view.md` · **PR #724** · squash `9f3f4f0c`
**BCs:** BC-2.2.033, BC-2.3.041, BC-2.6.052 · **VPs:** VP-FIELDS-001, VP-FIELDS-002, VP-FIELDS-003

| BC | AC | Test (verified present) | Code |
|---|---|---|---|
| BC-2.2.033 postcondition 1 (replace semantics, list) | AC-001 | `test_bc_2_2_033_issue_list_fields_replaces_requested_field_set` (`tests/issue_commands.rs:~10716`) | `src/cli/issue/list.rs` `--fields` dispatch → `search_issues_with_fields` (`src/api/jira/issues.rs`) |
| BC-2.3.041 postcondition 1 (replace semantics, view) | AC-002 | `test_bc_2_3_041_issue_view_fields_replaces_requested_field_set` (`tests/issue_commands.rs:~10794`) | `src/cli/issue/view.rs` `--fields` dispatch → `get_issue_with_fields` (`src/api/jira/issues.rs`) |
| BC-2.2.033 postcondition 2 (typed output, null placeholders) | AC-003 | `test_bc_2_2_033_issue_list_fields_unrequested_named_fields_are_null` (`tests/issue_commands.rs:~10843`) | `src/types/jira/issue.rs::IssueFields` (unchanged struct, `#[serde(flatten)]` catch-all) |
| BC-2.2.033/2.3.041 EC (table-mode rejection) | AC-004 | `issue_list_fields_table_mode_exits_64` (`tests/issue_list_errors.rs`), `issue_view_fields_table_mode_exits_64` (`tests/issue_view_errors.rs`) | `src/cli/issue/list.rs:~195` output-format gate |
| BC-2.2.033 EC (empty/malformed CSV) | AC-005 | `issue_list_fields_empty_csv_exits_64_pre_http` (`tests/issue_list_errors.rs`) | `helpers::parse_fields_csv` (`src/cli/issue/helpers.rs`) |
| BC-2.2.033 EC (extra-flag no-op) | AC-006 | `issue_list_fields_points_flag_becomes_silent_noop` (`tests/all_flag_behavior.rs`) | `src/cli/issue/list.rs` |
| BC-2.2.033 postcondition 3 (key always present) | AC-007 | `test_bc_2_2_033_issue_list_fields_key_always_present_regardless_of_csv` (`tests/issue_commands.rs:~10914`) | `helpers::parse_fields_csv` (key injection) |
| BC-2.2.033 EC (whitespace trimming) | AC-008 | `test_bc_2_2_033_issue_list_fields_csv_segments_are_trimmed` (`tests/issue_commands.rs:~11023`) | `helpers::parse_fields_csv` |
| BC-2.6.052 postcondition 1 (additive, zero regression) | AC-009 | `test_bc_2_6_052_field_override_methods_send_verbatim_field_list` (`tests/issue_commands.rs:~11096`) | `src/api/jira/issues.rs` new `*_with_fields` methods (10 pre-existing call sites unchanged) |
| BC-2.6.052 postcondition 2 / EC (thin pass-through) | AC-010 | `test_bc_2_6_052_field_override_methods_empty_slice_is_not_a_client_error` (`tests/issue_commands.rs:~11163`) | `src/api/jira/issues.rs` |
| BC-2.3.041 EC (empty CSV on view) | AC-011 | `issue_view_fields_empty_csv_exits_64_pre_http` (`tests/issue_view_errors.rs`) | `src/cli/issue/view.rs` |
| BC-2.3.041 postcondition 3 (key always present, view) | AC-012 | `test_bc_2_3_041_issue_view_fields_key_always_present` (`tests/issue_commands.rs:~10982`) | `helpers::parse_fields_csv` |

**Adversarial passes:** per-story Step-4.5 CONVERGED (`done`, STORY-INDEX). **Fix PRs affecting
this story's tests:** FIX-F5-LRE-1 (cross-story integration test added, see below); F7 pre-gate
cleanup corrected AC-004/005/006/011's `**Test:**` citations to their real bare-named test
functions (uncommitted `.factory` diff at report time).

---

## S-579-1 — `--updated-recent <duration>` on `issue list`

**Story:** `.factory/stories/S-579-1-updated-recent-filter.md` · **PR #725** · squash `8291b471`
**BCs:** BC-2.1.023 (new), BC-2.1.006 (amended), BC-2.1.007 (amended) · **VPs:** VP-UPDATED-RECENT-001, VP-UPDATED-RECENT-002 **[NEW 2026-08-24, DEC-306]**

| BC | AC | Test (verified present) | Code |
|---|---|---|---|
| BC-2.1.023 postcondition 1 (clause composition) | AC-001 | `test_bc_2_1_023_issue_list_updated_recent_composes_clause` | `src/cli/issue/list.rs:~1169` `build_filter_clauses` |
| BC-2.1.023 precondition 2 (pre-HTTP validation, shared validator) | AC-002 | `test_bc_2_1_023_issue_list_updated_recent_rejects_combined_units_pre_http` | `src/jql.rs::validate_duration` (reused, unchanged by this story) |
| BC-2.1.023 EC-2.1.023-2 (asymmetric `conflicts_with`) | AC-003 | `test_bc_2_1_023_issue_list_updated_recent_conflicts_with_updated_after_only` | `src/cli/mod.rs:~360` `#[arg(conflicts_with = "updated_recent")]` |
| BC-2.1.023 postcondition 3 / EC-2.1.023-3 (free composition) | AC-004 | `test_bc_2_1_023_issue_list_updated_recent_composes_freely_with_recent` | `src/cli/issue/list.rs::build_filter_clauses` |
| BC-2.1.007 amendment (stable-order position) | AC-005 | `test_bc_2_1_007_issue_list_updated_recent_clause_ordering_after_recent_before_asset` (`tests/issue_commands.rs:~12083`, confirmed present) | `src/cli/issue/list.rs:1167-1170` |
| BC-2.1.006 amendment (14→15 filter sources) | AC-006 | `test_bc_2_1_006_issue_list_no_filters_stderr_enumerates_15_sources` (`tests/issue_commands.rs:~12160`, confirmed present) | `src/cli/mod.rs:66` `NO_FILTERS_SPECIFIED_MSG` |
| BC-2.1.023 postcondition 4 / EC-2.1.023-4 **[REWRITTEN 2026-08-24, DEC-306]** (alone-case mirrors `--recent`) | AC-007 | `test_bc_2_1_023_issue_list_updated_recent_alone_proceeds_like_recent` (`tests/issue_commands.rs:~12208`, confirmed present) | `src/cli/issue/list.rs:238-255` (guard **removed** by FIX-F5-LRE-1) |
| BC-2.1.023 postcondition 1 (field-swap fidelity) | AC-008 | `test_bc_2_1_023_issue_list_updated_recent_uses_updated_field_not_created` | `src/cli/issue/list.rs::build_filter_clauses` |

**Adversarial passes:** per-story Step-4.5 CONVERGED (`done`, STORY-INDEX). **DEC-306
amendment:** spec `bc-2-issue-read.md` amended (commit `2b0acfb0` on `factory-artifacts`); code
fix delivered via **FIX-F5-LRE-1** (PR #733, squash `28596274`) — removed the dedicated
`--updated-recent`-alone exit-64 guard, retained the terminal `all_parts.is_empty()` BC-2.1.006
backstop, flipped AC-007's test from exit-64 to proceed-and-compose, added a new
exactly-one-search-call assertion (VP-UPDATED-RECENT-002) and a new cross-story
`test_issue_list_fields_and_sort_compose_end_to_end` integration test. Independently
APPROVE-reviewed (`.factory/code-delivery/FIX-F5-LRE-1/pr-review.md`).

---

## S-588-1 — `--sort <field>:asc|desc` shorthand on `issue list`

**Story:** `.factory/stories/S-588-1-sort-shorthand.md` · **PR #726** · squash `190d8cfa`
**BCs:** BC-2.1.024, BC-2.1.025 · **VPs:** VP-SORT-001, VP-SORT-002 (VP-SORT-002 added to
frontmatter/STORY-INDEX during F7 pre-gate cleanup, per gap found in the F3-time consistency
audit's sibling finding)

| BC | AC | Test (verified present) | Code |
|---|---|---|---|
| BC-2.1.025 EC-2.1.025-1 (override + secondary sort) | AC-001 | `test_bc_2_1_025_issue_list_sort_composes_secondary_key_asc` (`tests/issue_commands.rs:~12754`) | `src/cli/issue/list.rs::compose_order_by_with_sort` |
| BC-2.1.025 postcondition 2 / EC-2.1.025-2 (key field omission) | AC-002 | `test_bc_2_1_025_issue_list_sort_key_field_omits_secondary_clause` (`tests/issue_commands.rs:~12793`) | `compose_order_by_with_sort` |
| BC-2.1.024 postcondition 1 (case-insensitive direction) | AC-003 | `test_bc_2_1_024_issue_list_sort_direction_case_insensitive` (`tests/issue_commands.rs:~12832`) | `src/cli/issue/list.rs::parse_sort:~92` |
| BC-2.1.024 EC-2.1.024-3..7 (malformed input rejection) | AC-004 | Unit: `test_bc_2_1_024_parse_sort_malformed_input_exits_64_pre_http` (`src/cli/issue/list.rs:1262`); Integration: `issue_list_sort_malformed_input_exits_64_pre_http` (`tests/issue_list_errors.rs`) | `parse_sort` |
| BC-2.1.025 postcondition 3 (overrides `--jql` branch default) | AC-005 | `test_bc_2_1_025_issue_list_sort_overrides_jql_branch_default` (`tests/issue_commands.rs:~12874`) | `src/cli/issue/list.rs:~445-525` order_by override hook |
| BC-2.1.025 postcondition 4 / EC-2.1.025-4 (overrides board rank) | AC-006 | `test_bc_2_1_025_issue_list_sort_overrides_kanban_board_rank_default` (`tests/issue_commands.rs:~12916`) | same order_by override hook, board/kanban branch |
| BC-2.1.025 Behavior (absent-flag byte-for-byte unchanged) | AC-007 | Existing `build_jql_parts_*`/`all_flag_behavior` regression suite (unmodified — regression guard, not a new test) | `src/cli/issue/list.rs` (4 composition branches, BC-2.1.002/003/004/005 pinned literals) |
| BC-2.1.025 EC-2.1.025-5 (pass-through, no allowlist) | AC-008 | `issue_list_sort_unknown_field_propagates_jira_400` (`tests/issue_list_errors.rs`) | `parse_sort` (no field-name validation; server-side 400) |
| BC-2.1.025 postcondition 5 / BC-2.1.006 Note (not a filter source) | AC-009 | `test_bc_2_1_006_issue_list_sort_alone_does_not_satisfy_filter_requirement` | `src/cli/issue/list.rs` — `--sort` does not push into `build_filter_clauses` |
| BC-2.1.025 EC-2.1.025-3 (key-omission case-insensitive, casing preserved) | AC-010 | `test_bc_2_1_025_issue_list_sort_key_omission_case_insensitive_field_casing_preserved` (`tests/issue_commands.rs:~13107`) | `compose_order_by_with_sort` |

**Adversarial passes:** per-story Step-4.5 CONVERGED (`done`, STORY-INDEX); `security-review.md`
present and PASS. **Extra scrum-active-sprint coverage** (beyond the 10 ACs, verified present):
`test_bc_2_1_025_issue_list_sort_overrides_scrum_active_sprint_rank_default`
(`tests/issue_commands.rs:~12967`) and `test_bc_2_1_025_issue_list_sort_composes_with_filters`
(`tests/issue_commands.rs:~13026`). F7 pre-gate cleanup corrected AC-004/008's `**Test:**`
citations to their real bare-named/split test functions.

---

## S-584-1 — Preserve raw ADF for `--fields comment` (confirmatory)

**Story:** `.factory/stories/S-584-1-raw-adf-comment-fields.md` · **PR #732** · squash `748247e3`
**BCs:** BC-2.2.034, BC-2.3.042 · **VPs:** VP-FIELDS-004, VP-FIELDS-005 · **depends_on:** S-575-1

| BC | AC | Test (verified present) | Code |
|---|---|---|---|
| BC-2.2.034 postcondition 1 (raw ADF, list) | AC-001 | `test_bc_2_2_034_issue_list_fields_comment_returns_raw_adf` (`tests/issue_commands.rs:~11431`) | `src/types/jira/issue.rs::IssueFields.extra` (pre-existing `#[serde(flatten)]`, unchanged) |
| BC-2.3.042 postcondition 1 (raw ADF, view) | AC-002 | `test_bc_2_3_042_issue_view_fields_comment_returns_raw_adf` (`tests/issue_commands.rs:~11504`) | same `extra` catch-all, view path |
| BC-2.2.034 postcondition 2 (`issue comments` unaffected) | AC-003 | `test_bc_2_2_034_issue_comments_command_unaffected_by_fields_comment_path` (`tests/issue_commands.rs:~11579`) | `src/cli/issue/comments.rs` (untouched, `adf_to_text` path) |
| BC-2.3.042 EC-2.3.042-2 (view table mode unaffected) | AC-004 | `test_bc_2_3_042_view_table_mode_description_render_unaffected` (`tests/issue_commands.rs:~11646`) | `src/cli/issue/view.rs` (untouched, `adf_to_text` path) |
| BC-2.2.034 EC-2.2.034-3 (defensive comment obligation) | AC-005 | Structural/code-review check (comment presence at wiring site) | `src/cli/issue/list.rs` (+12 comment lines), `src/cli/issue/view.rs` (+13 comment lines) — confirmed comment-only by PR review |

**Adversarial passes:** per-story Step-4.5 CONVERGED 6 passes/3 clean (P4/P5/P6), all findings
LOW content defects, no process-gaps — S-7.02 satisfied at story level. `security-reviewer`
PASS, `pr-reviewer` APPROVE (1 non-blocking NIT — mock symmetry, tracked as
`S-584-1-AC001-LIST-MOCK-FIELDS-MATCHER-SYMMETRY` in the Keep-Deferred Disposition, see
`delta-convergence-report.md` §4).

---

## Cross-story cross-references

- `STORY-INDEX.md`: S-575-1 `blocks:[S-584-1]`; S-584-1 `depends_on:[S-575-1]` — confirmed
  consistent both directions in the story frontmatter.
- `test_issue_list_fields_and_sort_compose_end_to_end` (added by FIX-F5-LRE-1, `tests/issue_commands.rs`)
  is the one cross-story integration test spanning S-575-1 (`--fields`) and S-588-1 (`--sort`)
  together, confirmed present per FIX-F5-LRE-1's `pr-review.md`.
- BC-2.1.006 (bare `jr issue list` no-filters guard) is amended by S-579-1 (14→15 sources) and
  independently referenced (not modified) by S-588-1 AC-009 ("`--sort` is not a filter source")
  — both stories cite the same BC without conflict; S-588-1's citation is a Note, not an
  amendment.
- BC-2.1.007 (stable filter-clause order) is amended by S-579-1 only; S-575-1/S-588-1/S-584-1
  do not touch clause ordering (`--fields`/`--sort`/raw-ADF are all orthogonal to
  `build_filter_clauses`'s emission order — `--sort` explicitly does not participate in it at
  all, per BC-2.1.007's own Note).

## Fix-PR chain (adversarial/hardening convergence)

```
ADV-LRE-F5-A-MED-001 (F5 Round 1 finding, cycle-level)
  -> DEC-306 (human ruling)
  -> FIX-F5-LRE-1 (PR #733, squash 28596274)
       amends: BC-2.1.023 (postcondition 4 + EC-2.1.023-4 rewritten), spec bc-2-issue-read.md
       code:   src/cli/issue/list.rs (guard removed)
       tests:  tests/issue_commands.rs (2 tests flipped, 9 strengthened, 1 new combined test)
  -> F5 Round 2 (3 fresh diverse-lens passes over 28596274) — 3/3 CLEAN, MED verified resolved

ADV-F6-VALIDATE-DURATION-PANIC (F6 targeted hardening finding, parser-robustness pass)
  -> FIX-F6-LRE-1 (PR #734, squash 37850b26)
       code:   src/jql.rs::validate_duration (char-safe extraction)
       tests:  validate_duration_multibyte_unit_returns_err_not_panic (unit),
               validate_duration_never_panics (proptest, src/jql.rs:416-424)
  -> independently APPROVE-reviewed (.factory/code-delivery/FIX-F6-LRE-1/pr-review.md)
```

## Traceability guard cross-checks (self-run at F7)

| Guard | Result |
|---|---|
| `scripts/check-spec-counts.sh` | exit 0 — "Check passed: 8 bc files validated" |
| `scripts/check-bc-cumulative-counts.sh` | exit 0 — "OK: all cumulative BC counts verified (707 total across 9 files)" |
| Every `**Test:**`-cited function name across all 4 stories | grep-confirmed present verbatim in the named `src/`/`tests/` file at `develop@37850b26` |

## Appendix — CANONICAL-COUNTS / cumulative BC drift

This delta added 10 new/amended BC entries to `bc-2-issue-read.md`
(BC-2.1.023/024/025/2.2.033/2.2.034/2.3.041/2.3.042/2.6.052 new, BC-2.1.006/007 amended in
place — amendments do not increment the definitional count). STORY-INDEX.md's running total
tracks each story's contribution explicitly in its per-row changelog annotation (e.g. S-575-1
"150→151", S-584-1 "151→152", S-579-1 "152→153", S-588-1 "153→154"), and
`check-bc-cumulative-counts.sh`'s exit-0 result above confirms no drift between the per-file
frontmatter, BC-INDEX.md, and CANONICAL-COUNTS.md surfaces post-cycle.
