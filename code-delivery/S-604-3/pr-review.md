# PR #706 Review Gate — S-604-3 `jr component delete` (consolidated)

**CONSOLIDATED VERDICT: REQUEST_CHANGES** — 0 CRITICAL, 0 HIGH, 2 MEDIUM, 4 LOW, 2 INFO

- **covered_sha:** `d9141e9fa2fe2488dd94632bf2fe06b5f0c81ed2`
- **base:** `develop` · **head:** `feature/S-604-3-component-delete-safety`
- **Module criticality:** SAFETY-CRITICAL (irreversible delete; no undelete endpoint)
- **Posted to GitHub:** https://github.com/Zious11/jira-cli/pull/706#pullrequestreview-4953334831
  (formal review via `gh pr review`, state `COMMENTED` — see "GitHub posting constraint" below)

> ## Provenance — read this first
>
> **Two independent fresh-eyes reviews exist for this PR and they reached different verdicts.**
> This file is the consolidated gate record. Neither source file was destroyed; both are on disk:
>
> | File | Reviewer | Verdict | Notes |
> |---|---|---|---|
> | `pr-review-fresh-eyes-1.md` | first pr-reviewer pass | **APPROVE** (0 BLOCKING/HIGH/MEDIUM, 3 INFO) | Byte-identical preserved copy of the original `pr-review.md` (sha1 `98edc0a8…`). |
> | `pr-review-fresh-eyes-2.md` | second pr-reviewer pass (Opus, independent) | **REQUEST_CHANGES** (2 MEDIUM, 4 LOW, 2 INFO) | Full finding detail with file:line citations. |
>
> The prior file's content was **not** overwritten or edited — it was copied to
> `pr-review-fresh-eyes-1.md` before this consolidated file was written, matching the S-604-2
> precedent for multiple review passes.
>
> **The two passes do not contradict each other.** They agree completely on all eight
> load-bearing safety properties. The delta is purely additive: pass 2 raised two MEDIUM items
> pass 1 did not, plus four LOW items. Two of pass 1's INFO items (bidirectional
> `conflicts_with`; missing `search.expect(0)` on numeric self-move) were independently
> reproduced by pass 2. The consolidated verdict takes the stricter of the two.
>
> **Human owns the merge decision (DEC-128).** This gate does not authorize merge; CI Gate must
> be green independently.

## Independent verification (worktree `.worktrees/S-604-3` @ `d9141e9f`)

- `cargo test` — full suite green, 0 failed suites
- `cargo test --test component_commands` — 104/104
- `cargo clippy --all-targets --all-features -- -D warnings` — clean
- `cargo fmt --all -- --check` — clean
- Demo evidence scanned for real Jira keys / org IDs / instance URLs — clean

## Load-bearing safety properties — all 8 PASS (both passes concur)

| # | Property | Evidence |
|---|---|---|
| 1 | Disposition guard | `component.rs:676-687` application-level `UserError` (exit 64), not `ArgGroup`; both-flags via clap `conflicts_with` → exit 2 (correct DEC-188 split). |
| 2 | Name-vs-numeric ordering asymmetry | Name: resolve `:764-820` → guard `:822-824`. Numeric: guard `:829-831` **before** the confirming GET. Deliberate and correct. |
| 3 | `--move-to` same-project only, numeric confirming GET, self-move | `:903-960` target scoped to source-derived `project_key`; `:895-901` `eq_ignore_ascii_case` with `unwrap_or_default()` → `""` → **fail-closed**. Self-move `:962-973` is **ID**-equality, before snapshot and DELETE. |
| 4 | Numeric-source project confirmation, BOTH dispositions | `:834-891`. Empty `project` field returns `Err` in both the `--project`-supplied and absent branches — correctly replicates PR #704 Finding-C's fail-closed fix. |
| 5 | `--orphan` confirmation gate | `:986-1030`. Real snapshot-derived count; `no_input && !yes` → exit 64 with count; decline → exit 0, zero DELETE; `--move-to` never enters the block. |
| 6 | Pre-delete snapshot, paginated, fail-closed | `:980-984`. JQL `component = <resolvedNumericId> ORDER BY key ASC` (never a name). `search_issue_keys(jql, **None**)` — with `limit: None`, `has_more=true` is unambiguously the JRACLOUD-95368 anti-loop abort (`api/jira/issues.rs:362-405`), so `SnapshotIncomplete` is sound. 5xx propagates via `?`. Both abort before DELETE. |
| 7 | `--output json` success shape | `:1042-1051` via `output::render_json` (#526 invariant); `movedIssuesTo` → `null` under `--orphan`. |
| 8 | Idempotency taxonomy | Resolver 404 → `UserError` (64); DELETE-call 404 → `ApiError` → `_ => 1`. Not collapsed. |

No path exists where the DELETE fires before a completed snapshot, with a cross-project
`moveIssuesTo` target, or with a bare-name JQL.

## Consolidated findings

Full detail, with file:line citations and suggested fixes, is in `pr-review-fresh-eyes-2.md`.

| ID | Severity | Location | Finding |
|---|---|---|---|
| MEDIUM-1 | MEDIUM | `src/cli/component.rs:1004-1024` | `--output json` + interactive decline emits **nothing** (empty stdout, exit 0). The code comment cites `handle_comment_delete`'s DEC-174 rationale, but that handler emits `{"cancelled": true, "deleted": false}` (`src/cli/issue/interactions.rs:181-192`). Contradicts the cited precedent and CLAUDE.md's JSON contract. **Only finding recommended as pre-merge.** |
| MEDIUM-2 | MEDIUM | `component.rs:497-556` / `:764-820` / `:903-960` | Resolver block now exists in three near-verbatim copies (plus numeric block `:419-486` / `:834-891`) — the exact shape that produced PR #704's Finding C. `is_404_error` (`:680`) was not applied back to `handle_edit` (`:425-428`). |
| LOW-1 | LOW | `component.rs:907` | Redundant second `GET /project/{key}/components` for name-source + name-target (source `Vec` consumed by `into_iter()` at `:812`). Neither call count is pinned. |
| LOW-2 | LOW | `tests/component_commands.rs:3701` | Test name says `zero_http`; body expects one components GET (`.expect(1)`). CLAUDE.md: a name asserting a guarantee its body doesn't check is a defect. |
| LOW-3 | LOW | `tests/component_commands.rs:4416-4527` | AC-009 does not explicitly pin "self-move guard fires before the snapshot" (no `search.expect(0)`); implicitly covered only. Matches pass 1 INFO-3. |
| LOW-4 | LOW | PR description | Four diff mismatches: dialoguer node in the mermaid (code deliberately uses direct stdin read); "78 new tests" (78 is the file total, ~27 are new); BC-8.2.005 "zero HTTP" (it is zero DELETE/snapshot); fixtures row overstates. |
| INFO-1 | INFO | `handle_delete` | Affected-issue count is permission-scoped — the JQL snapshot sees only issues visible to the caller, while the DELETE strips the component from all issues. Suggest a rustdoc note. |
| INFO-2 | INFO | snapshot | `search_issue_keys` pages at 50, so a 10k-issue component costs ~200 POSTs pre-DELETE. Correct; cost note only. |

Pass 1's remaining INFO items (the two "no project field" fail-closed branches defending an
unreachable shape; bidirectional `conflicts_with` redundancy) are recorded in
`pr-review-fresh-eyes-1.md` and require no change.

## GitHub posting constraint (not a process deviation)

`gh pr review 706 --request-changes --body-file …` was attempted first and rejected by GitHub:

```
failed to create review: GraphQL: Review Can not request changes on your own pull request (addPullRequestReview)
```

PR #706 was opened by the same account that is authenticated, so GitHub structurally forbids
`--approve` and `--request-changes`. This is documented precedent in this repo
(`.factory/code-delivery/S-604-2/pr-review.md`). Fallback was `gh pr review --comment
--body-file` — still a **formal review** on the `pulls/706/reviews` endpoint, not an issue
comment. Verified: `pulls/706/reviews` contains review id `4953334831` (10,067-byte body);
`issues/706/comments` is **empty**, confirming `gh pr comment` was never used.

The REQUEST_CHANGES verdict therefore lives in this file and in the review body, not in a
GitHub review *state*. It was not downgraded to APPROVE to satisfy tooling.

## Recommendation

Land MEDIUM-1 (~10 lines plus one assertion) before merge. MEDIUM-2 and the four LOWs are
legitimately follow-up-able if the branch should not be churned further. Reconcile the pass-1
APPROVE against this consolidated REQUEST_CHANGES before merging.
