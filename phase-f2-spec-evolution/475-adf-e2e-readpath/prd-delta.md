---
document_type: prd-delta
issue: 475
feature: "issue #475 — ADF E2E read-path coverage"
created: 2026-06-11
status: complete
bc_count_before: 594
bc_count_after: 594
nfr_count_before: 41
nfr_count_after: 41
bc_added: []
bc_modified: []
bc_retired: []
nfr_added: []
nfr_modified: []
count_impact: "none — test-only feature; all spec counts unchanged"
trace_fields_updated:
  - "BC-7.2.003 — added E2E coverage reference (test_e2e_adf_read_path_human_output) and rename note"
  - "BC-7.2.004 — added E2E coverage reference (test_e2e_adf_read_path_human_output, AC-1 + AC-3)"
  - "BC-7.2.006 — added first live E2E coverage reference (test_e2e_adf_read_path_human_output, AC-2)"
test_rename:
  old: "test_e2e_issue_markdown_description_roundtrip"
  new: "test_e2e_markdown_description_produces_heading_node"
  rationale: "old name implied a full round-trip read-back; test only verifies forward markdown→ADF direction (heading node present in ADF write)"
---

# F2 Spec Evolution (PRD Delta) — Issue #475

## Summary

Issue #475 adds **live E2E read-path coverage** for the ADF subsystem
(`src/adf.rs`). This is a test-only feature — no production code changes,
no new behavioral contracts, no new NFRs, no count-surface changes.

The PRD delta records three categories of spec impact:
1. Trace field updates on three existing BCs
2. A test rename that corrects a misnomer
3. The new story `S-475-adf-e2e-readpath` documenting the four acceptance criteria

## No New Behavioral Contracts

BC count is unchanged at **594**. No new `#### BC-` headings were added or
retired. The `scripts/check-bc-cumulative-counts.sh` invariant holds.

## No New NFRs

NFR count is unchanged at **41**. The `scripts/check-spec-counts.sh`
invariant holds.

## Trace Field Updates

Three BC Trace fields in `bc-7-output-render.md` are updated to reference
the new live E2E coverage that issue #475 introduces. The updates are additive
only — no prior Trace text was removed.

### BC-7.2.003

Added reference to `test_e2e_adf_read_path_human_output` (first live E2E
exercise of the ADF read path via `jr issue view` in human/table mode — AC-1)
and updated the renamed test reference: `test_e2e_markdown_description_produces_heading_node`
(formerly `test_e2e_issue_markdown_description_roundtrip`).

### BC-7.2.004

Added reference to `test_e2e_adf_read_path_human_output` as the first live
E2E coverage of `adf_to_text` — exercised via `cli/issue/view.rs` human mode
(AC-1) and `cli/issue/comments.rs` human mode (AC-3).

### BC-7.2.006

Added reference to `test_e2e_adf_read_path_human_output` as the first live
E2E coverage of the `listItem` normalization path — the sub-case in AC-2
exercises `normalize_list_item_content` end-to-end against a real Jira
Cloud instance.

## Test Rename

| Field | Value |
|-------|-------|
| Old name | `test_e2e_issue_markdown_description_roundtrip` |
| New name | `test_e2e_markdown_description_produces_heading_node` |
| Rationale | Old name implied a full ADF round-trip read-back; the test only verifies the forward markdown→ADF direction (asserts a heading node appears in the ADF write). The rename follows the project's `test_<verb>_<subject>_<expected_outcome>` convention per `docs/specs/test-naming-convention.md`. |
| Touch-points | `tests/e2e_live.rs` (function name); `docs/specs/e2e-live-jira-testing.md:~123` (bullet listing the old test name); `bc-7-output-render.md` BC-7.2.003 Trace field (already updated in F2). `tests/e2e_cli_surface_guard.rs` SURFACE table is NOT affected — it is keyed on CLI command paths, not test function names. |

The rename is a **human-overridden decision** from the F1 gate: the human
OVERRODE the annotate-only recommendation and requires a RENAME (not just a
comment). F3 story-writer must action this rename.

## Story Produced

One story: `S-475-adf-e2e-readpath` with four ACs:

- **AC-1** `test_e2e_adf_read_path_human_output` — create issue with rich
  markdown, `jr issue view <key>` in human/table mode, assert stdout contains
  text rendered by `adf_to_text`.
- **AC-2** listItem normalization sub-case (within AC-1 test) — markdown
  containing blockquote-inside-listItem, assert create exits 0 (no Jira 400),
  assert via `poll_view` that `listItem.content` does NOT contain a `blockquote`
  node (validates `normalize_list_item_content` against live Jira).
- **AC-3** Comment human-mode read path — seed comment via
  `jr issue comment <key> <text> --markdown`, then `jr issue comments <key>`
  in human/table mode, assert stdout contains comment text rendered by
  `adf_to_text`.
- **AC-4** Rename `test_e2e_issue_markdown_description_roundtrip` →
  `test_e2e_markdown_description_produces_heading_node` in `tests/e2e_live.rs`
  and `docs/specs/e2e-live-jira-testing.md:~123`. The `bc-7-output-render.md`
  BC-7.2.003 Trace field already references the new name (updated in F2).
  `tests/e2e_cli_surface_guard.rs` SURFACE table requires no change.

## Architecture / Verification Delta

- No architecture changes. No new ADR.
- No new verification properties.
- No changes to `verification-architecture.md`, `VP-INDEX.md`, or
  `verification-coverage-matrix.md`.
- All changes are confined to `tests/e2e_live.rs`,
  `tests/e2e_cli_surface_guard.rs`, and `bc-7-output-render.md` Trace fields.

## Spec Documents Produced

- `.factory/phase-f2-spec-evolution/475-adf-e2e-readpath/e2e-coverage-spec.md`
  — full E2E coverage spec with test design, assertion strategy, and the
  coverage matrix section to be added to `docs/specs/e2e-live-jira-testing.md`
  in F3.
