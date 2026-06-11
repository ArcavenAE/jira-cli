---
document_type: f1-delta-analysis
feature: "issue #475 — ADF E2E read-path coverage + listItem normalization live test"
intent: enhancement
feature_type: infrastructure
trivial_scope: false
scope_classification: standard
date: 2026-06-11
develop_head: 18a6441
bc_count: 594
nfr_count: 41
stories_count: 67
prior_partial_delivery: "PR #495 @ bfb723f (5 gated live E2E tests; issue #475 partially addressed)"
---

# F1 Delta Analysis — Issue #475: ADF E2E Read-Path Coverage

## 1. Feature Summary

Issue #475 ("test(e2e): expand ADF coverage — ADF→text read path + broader
markdown→ADF constructs") was closed with two enumerated gaps after PR #495 merged:

**Gap 1 — `adf_to_text` read path never exercised live.**
Every existing live E2E test that touches ADF asserts against the serialized ADF JSON
(via `--output json` + `poll_view`). The `adf_to_text` function — called by
`cli/issue/view.rs::handle_view` (OutputFormat::Table arm, line 87) and
`cli/issue/comments.rs::handle_comments` (OutputFormat::Table arm, lines 33/49) — is
NEVER called through the live path. The test `test_e2e_issue_markdown_description_roundtrip`
is named "roundtrip" but only asserts ADF JSON shape (heading node present); it does NOT
invoke `jr issue view <key>` in human/table mode. This is the AC-013 caveat sites at lines
3477, 3737, 3780, and 8029 of `tests/e2e_live.rs`.

**Gap 2 — listItem normalization (#470) live E2E status.**
The comment block at `tests/e2e_live.rs:8898–8900` ("LISTITEM NORMALIZATION (#470):
normalization-correctness assertions are a lower live-value class and are deferred as a
follow-up"). No live E2E test exists for BC-7.2.006. The 5 tests in PR #495 batch cover
task lists, subsup, GFM alerts, block HTML, and ordered task lists — none explicitly
create a `blockquote`-in-listItem or `table`-in-listItem markdown string and assert the
normalization survives a live Jira POST.

## 2. Intent Classification

**Intent:** `enhancement` — purely additive test coverage, no production behavior change.
**Feature type:** `infrastructure` (test-only; no `src/` change).
**Scope:** `standard` (two distinct test scenarios with real design decisions; not trivial
because the read-path test requires asserting non-JSON stdout content from a live command
invocation — a new assertion pattern not used by any existing E2E test).

## 3. Impact Boundary

### Affected Components

| Component | Change Type | Rationale |
|-----------|-------------|-----------|
| `tests/e2e_live.rs` | MODIFIED | New test function(s) added |
| `tests/e2e_cli_surface_guard.rs` | MODIFIED | The `issue view` row currently only has `--output`. If the new test invokes `jr issue view <key>` WITHOUT `--output json` (human mode), no flag addition is needed — zero flags in human mode. SURFACE row does NOT need changes if no new flags are used. |
| `src/cli/issue/view.rs` | DEPENDENT | Called by the new live test (human mode path). No code change; regression baseline. |
| `src/cli/issue/comments.rs` | DEPENDENT | May be called in human mode by a comments read-path sub-test. No code change; regression baseline. |
| `src/adf.rs::adf_to_text` | DEPENDENT | Exercised for the first time on a live response. No code change; the live test validates it. |

### Components NOT Changed (Regression Baseline)

All of `src/` is unchanged. The regression risk zone is entirely within
`tests/e2e_live.rs`. Hermetic integration tests (`tests/*.rs` except `e2e_live.rs` and
`e2e_cli_surface_guard.rs`) are untouched.

## 4. BC Anchors Touched

No new BCs are introduced. No existing BCs are modified. The new tests serve as live
exercisers for existing behavioral contracts:

| BC | Role |
|----|------|
| BC-7.2.003 | "ADF markdown round-trip covers: headings, lists, code blocks, blockquotes, tables, links" — the new read-path test exercises this live for the first time in human output mode. |
| BC-7.2.004 | "ADF→text rendering: table render, code, headings preserved" — directly targeted by Gap 1 test. |
| BC-7.2.006 | "markdown_to_adf produces only permitted child node types inside any listItem" — Gap 2 test. |
| BC-7.2.007 | Subsup reverse path — already partially exercised by PR #495 (ADF JSON shape), not via human mode; the new read-path test can cover the reverse output. |
| BC-7.2.009 | GFM alert → panel reverse path — same note as BC-7.2.007. |
| BC-7.2.010 | Task list reverse path — same note as BC-7.2.007. |

The AC-013 caveat comment in `test_e2e_write_flow_create_edit_comment_worklog_close` (line
3477) and `test_e2e_issue_list_bad_jql_exits_nonzero` (line 8029) both cite AC-013 as a
shorthand for "we are asserting on serialized ADF JSON, not flat text." The new read-path
test closes this caveat for the description read path.

## 5. Existing Tests in Regression Risk Zone

All tests in the risk zone are already gated behind `JR_RUN_E2E=1` and are not in `ci.yml`.
The new tests are additive-only — no existing test body is modified.

| Test | Risk |
|------|------|
| `test_e2e_issue_markdown_description_roundtrip` | NONE (unchanged; the new test is complementary, not a replacement) |
| `test_e2e_issue_view_returns_key_field` | NONE (JSON mode only; unchanged) |
| All 5 PR #495 ADF tests (`test_e2e_markdown_task_list_*`, `test_e2e_markdown_subsup_*`, `test_e2e_markdown_gfm_alert_*`, `test_e2e_markdown_block_html_*`) | NONE (JSON mode assertions; unchanged) |

## 6. Regression Risk Assessment

| Module | Risk Level | Rationale |
|--------|-----------|-----------|
| `tests/e2e_live.rs` | LOW | Additive-only; no existing test body touched. New test failures are non-blocking (E2E is nightly, not `ci.yml`). |
| `src/adf.rs` | LOW | No code change. If the live test reveals a regression, it surfaces a pre-existing bug — not introduced by this change. |
| `src/cli/issue/view.rs` | LOW | No code change. Dependency only. |
| `src/cli/issue/comments.rs` | LOW | No code change. Dependency only. |
| `tests/e2e_cli_surface_guard.rs` | LOW | Only needs change if a new flag is used. Human-mode `issue view` uses no new flags (flag-less invocation already tested implicitly). |

**Overall regression risk: LOW.**

## 7. Gap 1 — Read-Path Test Design (Recommended)

**Test name proposal:** `test_e2e_adf_read_path_human_output`

**Why "roundtrip" is a misnomer for the existing test:** `test_e2e_issue_markdown_description_roundtrip`
asserts that `markdown_to_adf` produced an ADF `heading` node (create-side assertion on
the `--output json` response). It does NOT call `jr issue view <key>` in table mode and
does NOT assert the text rendered by `adf_to_text`. The existing test name implies a
full read-path round-trip, but the read-path half is absent. This should be flagged in
the story for either (a) renaming the test or (b) adding a `// NOTE: read path not
exercised — see test_e2e_adf_read_path_human_output` comment.

**New test design:**
1. `jr issue create --markdown --description <rich_md> --output json` — create issue with
   multi-construct markdown (heading + bold + bullet list + code block + link).
2. `poll_view` (JSON mode) — wait for GET-consistency.
3. `jr issue view <key>` WITHOUT `--output json` — human/table mode. stdout is the
   rendered table. stderr may have hints (truncation etc.).
4. Assert stdout contains the heading text (proves `adf_to_text` rendered the heading).
5. Assert stdout contains the bold text (proves `apply_marks` strong arm fired).
6. Assert stdout contains the bullet item text (proves bulletList/listItem arm fired).
7. Assert stdout contains the code snippet text (proves codeBlock arm fired).
8. `jr issue comments <key>` WITHOUT `--output json` — human/table mode comment read.
   (A prior `jr issue comment <key> <text> --markdown` step can seed a comment.)
9. Assert stdout contains the comment text (proves comments.rs human path calls `adf_to_text`).
10. `best_effort_close`.

**Assertion strategy:** stdout contains substrings from the original markdown source that
are NOT ADF node names (i.e., "heading text", not "heading"). This is robust to
`adf_to_text` output variations while still being a meaningful live exercise.

**The test exercises `adf_to_text` on live Jira-stored ADF** — this is the key value: Jira
may rewrite the ADF slightly on storage (add `localId`, normalize marks, etc.), so unit
tests of `adf_to_text` on hand-crafted ADF cannot substitute.

## 8. Gap 2 — listItem Normalization Live Test Assessment

**Status of existing scaffold:** The comment block at `tests/e2e_live.rs:8898–8900`
explicitly says the normalization assertions are "deferred as a follow-up — worth adding
if a regression surfaces." There is NO live E2E test for BC-7.2.006.

**Value assessment:** The existing hermetic unit tests (e.g., `test_list_item_normalization_*`
in `src/adf.rs::tests`) cover the normalize path thoroughly. The live value is lower than
Gap 1 because:
- The user-observable behavior change from listItem normalization (no Jira 400 error) is
  already protected by the hermetic tests.
- Jira itself does not reject a `blockquote`-inside-`listItem` node silently — it would 400,
  and any such 400 from a CREATE command would surface as an error (non-zero exit) in the
  existing write-flow test. This is the "reactive BC-7.2.006 backstop" equivalent.
- A `table`-inside-`listItem` or `heading`-inside-`listItem` normalization live test would
  be the first and only test specifically exercising these paths with a live POST.

**Recommendation:** Include a minimal listItem normalization live test as a sub-case of the
Gap 1 test rather than a separate test. Use a markdown description that contains a heading or
blockquote inside a list item: `- list item\n\n  > blockquote inside item`. Assert the created
issue does NOT return a 400 (i.e., create exits 0). Additionally assert via `poll_view` that
the ADF does NOT contain a `blockquote` node directly inside a `listItem` content array
(proving normalization ran). This assertion requires a helper function (similar to
`adf_has_task_item`) that checks `listItem.content` for forbidden node types.

## 9. Story Split Recommendation

**ONE story, not two.** Rationale:

- Both gaps live entirely in `tests/e2e_live.rs` and `tests/e2e_cli_surface_guard.rs`.
- The implementation dependency is: write helper functions (e.g., `adf_has_node_type_in_list_item`),
  then write the two tests (Gap 1 read-path test, Gap 2 normalization assertion).
- Splitting into two stories would create artificial sequencing overhead with no benefit.
- Both test scenarios can be authored, reviewed, and merged in a single PR with minimal diff.
- The story is non-blocking (no production code change), making adversarial review and
  formal hardening fast.

**Story scope:** One new `S-475-adf-e2e-readpath.md` story covering:
- AC-1: `test_e2e_adf_read_path_human_output` — create with rich markdown, view in
  human/table mode, assert stdout text from `adf_to_text`.
- AC-2: listItem normalization sub-case (can be a sub-step in AC-1, NOT a separate test,
  since it shares the same create + poll_view + close lifecycle).
- AC-3: Comment human-mode read path (comment → `jr issue comments` in table mode → assert text).
- AC-4: Rename/clarify `test_e2e_issue_markdown_description_roundtrip` — either add a
  `// NOTE: read path not exercised live — see test_e2e_adf_read_path_human_output` comment
  or rename it to `test_e2e_markdown_description_produces_heading_node`. Decision: add comment
  is safer (renaming requires updating SURFACE guard, STORY-INDEX, and any BC Trace references).

## 10. Rename Flag for `test_e2e_issue_markdown_description_roundtrip`

As noted in the issue: this test name is a misnomer. It tests only the write-side (create →
ADF heading node in JSON response). The "roundtrip" label implies a create→view→text cycle
which does not happen. Recommended action (see AC-4 above): add a rustdoc comment clarifying
the scope, defer renaming to avoid SURFACE guard / BC Trace churn unless the team prefers
a clean rename. If renamed, the surface guard entry for `("issue", "view")` is unchanged
(the new test would use `"issue", "view"` without `--output`, which already appears in the
SURFACE table without triggering a new flag requirement).

## 11. Impact Summary Table

| Artifact Category | Status |
|-------------------|--------|
| PRD (BCs) | UNCHANGED — no new BCs; existing BCs exercised by new tests |
| Architecture | UNCHANGED — no module structure change |
| UX | N/A — test-only |
| Stories | +1 new story (S-475-adf-e2e-readpath.md) |
| Tests | +1–2 new `#[ignore]` tests in `tests/e2e_live.rs`; possibly +0 changes to `tests/e2e_cli_surface_guard.rs` |
| Verification Properties | UNCHANGED |
| `module-criticality.md` | UNCHANGED |

## 12. Files Expected to Change

| File | Change | Notes |
|------|--------|-------|
| `tests/e2e_live.rs` | MODIFIED | Add 1 new test function; add 0–1 helper functions; add comment/note to existing `test_e2e_issue_markdown_description_roundtrip` |
| `tests/e2e_cli_surface_guard.rs` | UNCHANGED (likely) | `issue view` row already present with `--output`; human-mode invocation adds no new flags |

## 13. Files NOT Changed (Regression Baseline)

- All `src/` files
- All `tests/` files except `e2e_live.rs` (and possibly `e2e_cli_surface_guard.rs`)
- All `.factory/specs/prd/` BC files
- All `.factory/stories/` files (except the new S-475 story spec)
- `docs/specs/e2e-live-jira-testing.md` (may be updated with AC reference)

## 14. Recommended Scope for Subsequent Phases

- **F2 (Spec Evolution):** Minimal. Add AC-013 live closure note to BC-7.2.004 Trace
  field (or to BC-7.2.003). Optionally update `docs/specs/e2e-live-jira-testing.md`
  §4 "ADF markdown round-trip" section to document the new read-path test. No new BCs.
  No BC count change. This F2 pass is a single targeted annotation, not a restructuring.
- **F3 (Story Decomposition):** Single story: S-475-adf-e2e-readpath.md with 4 ACs.
- **F4 (Implementation):** Author the test in a worktree branch. Standard TDD applies
  (write the test body, run it locally with `JR_RUN_E2E=1 JR_BASE_URL=... JR_AUTH_HEADER=...`,
  verify it passes). No `src/` TDD applicable — tests are the deliverable.
- **F5 (Adversarial):** Lightweight — assertions are straightforward substring checks.
  Main adversarial concern: assertion fragility (Jira may reformat the table output
  differently). Pre-empt by using content substrings from the original markdown, not
  formatting tokens.
- **F6 (Hardening):** N/A for new tests (no mutation, no proofs). Run the suite
  (`cargo test --lib` + `cargo test --test '*'`) to confirm the hermetic suite still
  passes (it should — no src/ change). Clippy/fmt/deny check.
- **F7 (Convergence):** Confirm SURFACE guard still passes, BC count unchanged (594),
  NFR count unchanged (41), story count +1 (68).

## 15. Human Approval Gate

This F1 analysis is presented for human review. Questions for the human:

1. Is one story correct, or should Gap 1 (read-path) and Gap 2 (listItem normalization)
   be tracked as separate stories for independent merge?
2. Should `test_e2e_issue_markdown_description_roundtrip` be renamed as part of this
   cycle, or annotated-only?
3. Should AC-3 (comment human-mode read path) be included in this cycle or deferred?
   It adds scope but shares the same lifecycle (create → comment → view comments in table mode).
4. Confirm: no new BCs, no src/ changes — story count goes to 68, BC/NFR counts unchanged.
