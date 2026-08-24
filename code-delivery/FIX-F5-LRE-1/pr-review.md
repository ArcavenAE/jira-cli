# PR Review — FIX-F5-LRE-1

**Verdict: APPROVE**

Finding ADV-LRE-F5-A-MED-001 (list-read-ergonomics F5 reconciliation, human ruling DEC-306).
Base `develop` `748247e3` → branch `fix/updated-recent-mirror-recent`.
Reviewed diff: `git diff 748247e3..HEAD` — `src/cli/issue/list.rs`, `tests/issue_commands.rs`.

One-line rationale: the guard removal is correct and narrowly scoped, the true bare-list
exit-64 backstop is preserved and test-verified, and the reframed tests assert against real
captured request bodies rather than tautologies — all affected tests pass locally.

## Checklist (8-item)

1. **Diff coherence** — PASS. Both changed files relate solely to the `--updated-recent`-alone
   guard removal. No unrelated changes.
2. **Description accuracy** — PASS. Diff matches the stated scope: two dedicated guards removed,
   terminal guard retained, doc comments corrected, 2 exit-64-alone tests flipped, 9 compose
   tests strengthened, 1 new combined-flag test, exactly-one-call assertion, narrative comments
   fixed.
3. **Test coverage** — PASS. Changed lines fully covered; assertions inspect the actual
   `POST /rest/api/3/search/jql` body via `s606_1_composed_jql`. Local runs green (see below).
4. **Demo evidence** — N/A for a CLI guard-logic reconciliation; behavior proven by
   wiremock request-body assertions.
5. **Commit quality** — PASS. Conventional Commits, story id + finding id present on all 4
   commits (`fix:`, `test:`, `docs:`).
6. **Diff size** — PASS. Well under 500 changed src lines; test churn is mostly rename +
   assertion reshaping.
7. **Missing changes** — PASS. Terminal `all_parts.is_empty()` backstop retained (list.rs:542);
   `NO_FILTERS_SPECIFIED_MSG` 15-source enumeration intact.
8. **Dependency status** — N/A (no upstream PR deps).

## What was verified

**Guard removal (src/cli/issue/list.rs)**
- Removed: early pre-HTTP `EC-2.1.023-4` guard and the `base_parts.is_empty()` backstop — the
  only 1 of 15 filter sources that refused when used alone.
- Retained: terminal `all_parts.is_empty()` guard (line 542) — single BC-2.1.006 backstop.
- `build_filter_clauses` still emits `updated >= -{d}` (line 1170), so `--updated-recent`
  alone yields non-empty `all_parts` and proceeds like `--recent`.
- True bare `jr issue list` still exits 64 with zero HTTP
  (`test_bc_2_1_006_..._enumerates_15_sources`, retained & passing).

**Test quality (tests/issue_commands.rs)**
- Non-tautological: assertions read the real outgoing `jql` body — check `updated >= -60d`
  present / `project =`, `sprint =` absent.
- Both exit-64-alone tests correctly flipped to proceed-and-compose; board-scrum-no-active-sprint
  test's zero-search `.expect(0)` mock correctly swapped for `s606_1_mock_search_empty`.
- The 9 `pr1_assert_guard_not_tripped` helpers reframed to `pr1_assert_composes_successfully`
  (proves the paired clause reaches the wire, not merely that a removed guard didn't fire).
- Added: exactly-one-search-call assertion (VP-UPDATED-RECENT-002) and a new cross-story
  `--fields`+`--sort` end-to-end integration test.

**Conventions (CLAUDE.md)**
- Test renames justified, not style-only: old names asserted now-false guarantees
  (`_still_requires_project_scope`, `_exits_64`, `_does_not_trip_no_filters_guard`) — exactly
  the correction the test-naming rule permits.

## Findings

| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| NIT | coherence | New combined test `test_issue_list_fields_and_sort_compose_end_to_end` omits the `test_bc_*` id prefix used by its neighbors. | Optional: add a BC id prefix for consistency; non-gating. |
| (observation) | — | The change deliberately enables an unbounded, cross-project query for `--updated-recent` alone. | Not a defect — explicit human ruling DEC-306, documented in-code. Flagged for visibility only. |

No BLOCKING or WARNING findings.

## Local verification (all green)

- `cargo test --test issue_commands updated_recent` → 18 passed
- `cargo test --test issue_commands no_filters` → 1 passed (bare-list exit-64 backstop)
- `cargo test --test issue_commands fields_and_sort_compose` → 1 passed (new combined test)

## GitHub posting status

No open PR exists for `fix/updated-recent-mirror-recent` at review time
(`gh pr list --head fix/updated-recent-mirror-recent` returned empty). There is no PR to
attach a formal `gh pr review --approve` to. This verdict is recorded here per the review
contract. When the PR is opened, this APPROVE stands; if the reviewer account equals the PR
author (formal `--approve` blocked by GitHub), attach this body as the review comment via
`gh pr review --body-file` rather than `gh pr comment`.
