# PR Review — #618 docs(spec): correct stale stub labels for shipped comment subcommands (#577)

**Verdict: COMMENT / approve-worthy** (docs-only; no true blockers; posted as a formal
`gh pr review --comment` because GitHub forbids both `--approve` and `--request-changes`
from the PR author on a self-authored PR)

This is a docs-only PR (3 files, +15/−14) that replaces stale "stub" labels with
accurate "shipped" descriptions after S-577-3/4/6 landed. The three targeted files
are factually accurate against the code. S-577-5 (visibility flags) is correctly
left pending. Two non-blocking findings below.

## Checklist

1. **Diff coherence** — PASS. All changes relate to the stub-label correction; no unrelated edits.
2. **Description accuracy** — PASS. PR body matches the diff (docs-only correction).
3. **Test coverage** — N/A (docs-only); accuracy claims spot-verified against existing tests.
4. **Demo evidence** — N/A for a docs-label correction.
5. **Commit quality** — PASS. Conventional format, story ID (#577) present, clear messages.
6. **Diff size** — PASS. 15 insertions / 14 deletions across 3 files.
7. **Missing changes** — See NON-BLOCKER below (CLAUDE.md occurrence not swept).
8. **Dependency status** — PASS. Upstream feature PRs (#615/#616/#617) already merged.

## Spot-checks — all three CONFIRMED accurate

1. **Delete cancel envelope `{"cancelled": true, "deleted": false}` (no id/key)** — CONFIRMED.
   `tests/comment_delete.rs:279-294` asserts exact key set `{"cancelled","deleted"}` with
   `id`/`key` absent, `cancelled == true`, `deleted == false` (BC-3.5.003). Success path
   `{"deleted": true, "id", "key"}` pinned at lines 143-151. `404/403 → exit 64` confirmed
   at `src/cli/issue/interactions.rs:217-222`.

2. **Edit `changed_fields.body` raw pre-trim echo pin (BC-3.5.005)** — CONFIRMED.
   `tests/comment_edit.rs:183` (`test_bc_3_5_005_edit_changed_fields_body_is_raw_pre_trim`)
   asserts `changed_fields.body == "  hello world  "` (raw preserved) while the PUT wire ADF
   text is trimmed to `"hello world"`. `changed_fields` has exactly one sub-key `"body"`.

3. **View raw passthrough via `output::render_json` + `?expand=properties`** — CONFIRMED.
   `src/cli/issue/interactions.rs:457` fetches into raw `serde_json::Value` (no typed
   round-trip); line 485 renders via `output::render_json` (#526 invariant). The
   `?expand=properties` param is mandatory in `src/api/jira/issues.rs:649-660` (`get_comment`).

## S-577-5 deferral — correct
Verified across all three files: comment-crud.md Status "S-577-5 (visibility flags) pending";
edit heading "body edit shipped, S-577-4; --internal/--public/--yes deferred to S-577-5";
json-output-shapes.md "Visibility fields deferred to S-577-5." No accidental "shipped" marking.

## Findings

| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| NON-BLOCKER (suggestion) | missing | `CLAUDE.md:24` still carries the same stale stub labels this PR sweeps: `interactions.rs # comment CRUD handlers: add, delete (stub), edit (stub), view (stub) (S-577-1+)`. This now contradicts the merged implementation and is within the PR's stated mission. Strongly recommend including it so the sweep is complete. | Update `CLAUDE.md:24` here (e.g. `add, delete (S-577-3), edit (S-577-4, body-only), view (S-577-6)`), matching the other three files, or file an immediate follow-up. |
| NIT | description | `CHANGELOG.md:14-15` (Breaking Changes) says `edit` is "fully implemented" without the "body-only" qualifier used everywhere else (line 19/31 + both spec files). A reader skimming only that line could infer `--internal`/`--public` editing ships now. | Add "(body-only)" to line 14 for consistency. |

## Summary
Diff is coherent, docs-only, accurate against the implementation, and correctly preserves
S-577-5 as pending. No true blockers. Strongly recommend sweeping the final `CLAUDE.md:24`
occurrence (here or a fast follow-up) so the fix fully delivers on its stated mission.

## Posting note
GitHub rejected both `gh pr review --approve` ("Can not approve your own pull request") and
`gh pr review --request-changes` ("Can not request changes on your own pull request") because
the reviewing account is the PR author. `gh pr review --comment` is therefore the only formal
review verdict GitHub permits for a self-authored PR, and that is how this review was posted
(verified `state: COMMENTED`). An `APPROVED`/`CHANGES_REQUESTED` state requires a second
GitHub account.
