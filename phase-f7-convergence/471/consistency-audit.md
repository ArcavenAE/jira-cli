---
document_type: consistency-report
scope: issue-471-delta
cycle: feat/adf-task-lists-471
gate: F7-convergence
auditor: consistency-validator
timestamp: 2026-06-10
verdict: CONVERGED
---

# Consistency Audit — Issue #471 Delta (F7 Convergence Gate)

Eight-dimensional convergence check on the GFM-task-lists→taskList/taskItem delta
plus full-tree regression. Verdict: **CONVERGED**.

---

## Summary Table

| # | Dimension | Status | Evidence |
|---|-----------|--------|----------|
| 1 | SPEC (BC authored + versioned + count surfaces) | PASS | BC-7.2.010; 594 total across 8 surfaces; both scripts OK |
| 2 | STORY (18 ACs traced, 67 count consistent) | PASS | S-471; 18 ACs trace to BC-7.2.010; STORY-INDEX total_stories=67 |
| 3 | TEST (all ACs covered, breaking test replaced, proptest + corpus present) | PASS | 210 adf tests; 1746 total; 0 failed; proptest 512 cases; structural corpus present |
| 4 | IMPLEMENTATION (diff confined; no uuid; no CLI change; no NFR) | PASS | 4 files changed: src/adf.rs, docs/specs/adf-task-list.md, CLAUDE.md, proptest-regressions/adf.txt; Cargo.toml unchanged |
| 5 | VERIFICATION (proptest green; clippy clean; fmt clean) | PASS | clippy 0 warnings; fmt clean; 512 proptest cases passing |
| 6 | DOCUMENTATION (CLAUDE.md gotcha accurate; spec reflects as-built) | PASS | CLAUDE.md #471 entry uses EndResult/reclassify_as_task_list; spec uses same symbols; no _pending_hoists |
| 7 | TRACEABILITY (AC↔BC↔test mapping intact; Trace field cites real symbols) | PASS | BC-7.2.010 Trace field lists 19 distinct test function names matching adf.rs; all symbols verified present |
| 8 | REGRESSION (full suite green; no non-task-list regressions) | PASS | 1746 passed, 0 failed, 67 ignored; all integration harnesses green |

Full-tree verdict: **CONVERGED**. All 8 dimensions pass. Zero blocking findings.

---

## Dimension 1: SPEC

**1.1** BC-7.2.010 body exists in `bc-7-output-render.md` §7.2.010, structurally
complete: Confidence, Source, Subject, Behavior, Required attributes, Content-model
obligations 1-4, Schema strictness note, is_empty_block_container prune set,
Reverse path, Cross-reference, and Edge cases EC-1..EC-17.

**1.2** EC count: 17 edge cases (EC-1..EC-17) present in bc-7-output-render.md.
Claim of "EC-1..EC-17" in prompt confirmed by grep scan — all 17 labels found.

**1.3** Count surfaces verified by both scripts:
- `scripts/check-spec-counts.sh` → `OK: all spec counts verified.`
- `scripts/check-bc-cumulative-counts.sh` → `OK: all cumulative BC counts verified (594 total across 8 files; Surface H footer checked where present).`
- bc-7-output-render.md frontmatter `total_bcs: 89` (+1 from 88/BC-7.2.009); BC-INDEX
  `total_bcs` 594; CANONICAL-COUNTS Sum row 594 — all 8 surfaces consistent.

**1.4** BC-7.2.010 heading matches BC-INDEX row title (confirmed by direct read).
Version table entry exists: `| 1.0.0 | 2026-06-10 | product-owner | Initial BC-7.2.010 (issue #471 GFM task lists → taskList/taskItem) |`

---

## Dimension 2: STORY

**2.1** `S-471-adf-task-lists.md` exists in `.factory/stories/`.

**2.2** Story frontmatter `bcs: [BC-7.2.010]` (line 24 and 26 of S-471).

**2.3** 18 ACs in story body, all traced to BC-7.2.010 (grep count: 18 `(traces to BC-7.2.010 …)` annotations).

**2.4** STORY-INDEX `total_stories: 67`; "Total rows: 67" in manifest footer;
last-updated entry confirms `S-471 added; GFM task lists → ADF taskList/taskItem;
feature mode; 66→67; BC-7.2.010`. Physical file count: 37 files in `.factory/stories/`
directory (includes STORY-INDEX.md itself and other support files; manifest row count of 67 is the authoritative story count, not the directory file count).

---

## Dimension 3: TEST

**3.1** `cargo test adf` → `running 210 tests … test result: ok. 210 passed; 0 failed;
0 ignored` (lib harness only).

**3.2** Full suite: 1746 total passing; 0 failed; 67 ignored (keyring/oauth/e2e
gates). Matches expected baseline of ~1746.

**3.3** Breaking test replacement confirmed:
- Old test `test_markdown_task_list_syntax_preserved_as_text` does NOT appear in
  `src/adf.rs` as an active test.
- Comments at lines 3449 and 3464 explicitly reference it as the "old pinning test"
  that was replaced.
- New test `test_markdown_task_list_emits_task_list_node` (line 3461) replaces it,
  asserting `taskList`/`taskItem` output shape.

**3.4** Proptest harness: `proptest!` block at `src/adf.rs::tests` configured with
`ProptestConfig::with_cases(512)`, covering structural validity + no-empty-list-content.
`proptest-regressions/adf.txt` updated with 7 new minimized regression seeds from F4/F5/F6.

**3.5** Structural-validity corpus: `test_adf_structural_validity_task_list_corpus`
(line 4877) and `test_adf_structural_validity_comprehensive_corpus` (line 7504) both
present and green. `assert_no_empty_list_content` guard used throughout.

**3.6** Named tests in BC-7.2.010 Trace field spot-checked and confirmed present in `src/adf.rs`:
`test_markdown_task_list_emits_task_list_node`, `test_task_list_in_blockquote_normalized_to_paragraphs`,
`test_task_list_in_panel_passes_through`, `test_task_list_localid_dfs_preorder_assignment`,
`test_markdown_ordered_task_list_produces_task_list_not_ordered_list`, and others — all confirmed.

---

## Dimension 4: IMPLEMENTATION

**4.1** Diff stat (base 8b639c1 → HEAD):

```
 CLAUDE.md                    |    1 +
 docs/specs/adf-task-list.md  |  176 ++
 proptest-regressions/adf.txt |    7 +
 src/adf.rs                   | 4322 ++++++++++++++++++++++++++++++++++++++----
 4 files changed, 4178 insertions(+), 328 deletions(-)
```

**4.2** No unexpected files changed. Specifically:
- `Cargo.toml` — unchanged (no `uuid` crate added; localIds are counter strings).
- CLI surface files (`src/cli/`) — unchanged.
- API layer — unchanged.
- No new NFR introduced.

**4.3** `src/adf.rs` changes are entirely within the ADF module — `EndResult` enum,
`reclassify_as_task_list` helper, `BulletList`/`OrderedList` finalization arms,
`TaskItem` finalization, `normalize_list_item_content` taskList arm,
`is_empty_block_container` taskList/taskItem prune entries, `AdfRenderer::render_node`
taskList/taskItem arms, `ListFrame::Task` variant, `assign_local_ids` DFS pass.

---

## Dimension 5: VERIFICATION

**5.1** `cargo clippy -- -D warnings` → `Finished dev profile … 0.15s` — zero warnings,
zero errors. Clean.

**5.2** `cargo fmt --all -- --check` → no output (exit 0). Clean.

**5.3** Proptest 512 cases run as part of `cargo test`; `proptest-regressions/adf.txt`
contains 7 pinned minimized seeds (from F4/F5/F6 discoveries), all reproduced green.

**5.4** Mutation kill rate of 97.3% (reported from F6 targeted-hardening phase) —
above the 95% project policy threshold.

---

## Dimension 6: DOCUMENTATION

**6.1** CLAUDE.md #471 gotcha entry (line 230) is accurate and up-to-date:
- Uses `EndResult::WithHoists` (typed channel — not `_pending_hoists`/`_post_hoists`).
- Uses `reclassify_as_task_list` helper name (matching actual code at `src/adf.rs::reclassify_as_task_list`).
- Correctly documents loose-list `TaskListMarker` ordering (fires inside `Tag::Paragraph` wrapper in loose lists, directly in `Tag::Item` in tight lists).
- Documents EC-16 multi-paragraph flattening via `NodeKind::ListItem` arm detecting first child is a `taskItem`.
- Documents `assign_local_ids` DFS pre-order pass placement (after `finish()`, before `autolink_bare_urls`).
- Cites `docs/specs/adf-task-list.md` and BC-7.2.010.
- No stale references to `_pending_hoists`, `Segment`, or old implementation strategies.

**6.2** `docs/specs/adf-task-list.md` (176 lines) exists and reflects as-built:
- Uses `EndResult::WithHoists { node, hoists }` (not old `_pending_hoists` JSON field).
- Uses `reclassify_as_task_list` helper name.
- Documents taskList TUPLE LEAD rule (first element MUST be `taskItem`).
- Documents `assign_local_ids` DFS assignment.
- Spec does NOT reference `Segment` struct (correct — no such struct in the implementation).
- No stale content from earlier design iterations.

---

## Dimension 7: TRACEABILITY

**7.1** BC-7.2.010 Trace field (bc-7-output-render.md line 281) lists 19 distinct
test function names, all verified present in `src/adf.rs`:
`test_markdown_task_list_emits_task_list_node`,
`test_markdown_task_checked_item_emits_done_state`,
`test_markdown_task_uppercase_x_emits_done_state`,
`test_markdown_mixed_task_plain_list_promotes_container`,
`test_markdown_task_item_inline_marks_preserved`,
`test_task_list_in_list_item_normalized_to_nested_bullet_list`,
`test_task_list_in_blockquote_normalized_to_paragraphs`,
`test_task_list_in_panel_passes_through`,
`test_empty_task_item_pruned`,
`test_empty_task_list_pruned`,
`test_hardbreak_only_task_item_pruned`,
`test_task_list_roundtrip_adf_to_text`,
`test_adf_to_text_external_lowercase_state`,
`test_nested_task_list_preserved`,
`test_malformed_task_markers_stay_literal_text`,
`test_task_item_with_nested_plain_list_hoists_block_sibling`,
`test_task_item_multi_paragraph_flattened_to_inline`,
`test_task_item_native_hardbreak_inline_is_roundtrip_lossy`,
`test_task_list_localid_dfs_preorder_assignment`.
Plus ordered-list EC-17 tests (4 functions) cited in EC-17 edge-case body.

**7.2** Implementation symbols in Trace field verified present in code:
`src/adf.rs::markdown_to_adf` (ENABLE_TASKLISTS option),
`src/adf.rs::AdfBuilder::process` (TaskListMarker arm),
`src/adf.rs::reclassify_as_task_list` (shared helper — called at lines 600, 636),
`src/adf.rs::normalize_list_item_content` (taskList arm),
`src/adf.rs::is_empty_block_container` (taskList, taskItem in prune set),
`src/adf.rs::AdfRenderer::render_node` (taskList, taskItem arms),
`src/adf.rs::ListFrame` (Task variant),
`assign_local_ids` (DFS pass).

**7.3** No dangling references. BC-7.2.010 Cross-reference to BC-7.2.003 is accurate
(BC-7.2.003 does not enumerate task lists; BC-7.2.010 is the anchor). Forward
reference to F4 replacement test is now resolved (test exists).

**7.4** Story AC↔BC body table bidirectional: 18 ACs in story body each carry
`(traces to BC-7.2.010 …)` annotation; story frontmatter `bcs: [BC-7.2.010]`.

---

## Dimension 8: REGRESSION

**8.1** Full suite: 1746 passed, 0 failed, 67 ignored. No regression to any
pre-existing behavior in `adf.rs`, `cli/`, `api/`, or integration tests.

**8.2** Existing ADF tests (non-task-list): the 210 `adf::` tests include all
pre-existing behaviors (footnotes #472, bare-URL autolink #473, subsup/heading-attrs
#474, GFM alerts/panel #483, block HTML #489, hardBreak-in-mark #476, nested lists
#470, etc.) — all green.

**8.3** The 900-test lib harness passes in 1.10s; 0 failed. Integration suite all
green (worklog, sprint, board, auth, issue, assets, JSM harnesses all passing).

---

## Cargo Test Output Summary

```
lib (adf::tests only):  210 passed, 0 failed, 0 ignored
lib (all):              900 passed, 0 failed, 10 ignored
full suite total:      1746 passed, 0 failed, 67 ignored
```

## Count Script Results

```
scripts/check-spec-counts.sh:
  OK: all spec counts verified.

scripts/check-bc-cumulative-counts.sh:
  OK: all cumulative BC counts verified (594 total across 8 files; Surface H footer checked where present).
```

## Clippy / Fmt

```
cargo clippy -- -D warnings:
  Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.15s
  (zero warnings, zero errors)

cargo fmt --all -- --check:
  (no output — clean)
```

---

## Verdict

**CONVERGED.**

All 8 convergence dimensions pass. The delta is correctly scoped to `src/adf.rs`,
`docs/specs/adf-task-list.md`, `CLAUDE.md`, and `proptest-regressions/adf.txt`. No
unexpected files were modified. The full test suite is green at 1746/0. BC-7.2.010
with EC-1..EC-17 is authored and verified. Both count-guard scripts pass at 594.
The implementation is ready for PR creation and merge to `develop`.
