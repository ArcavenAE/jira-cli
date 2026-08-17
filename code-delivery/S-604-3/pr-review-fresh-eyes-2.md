# PR #706 Fresh-Eyes Review (second, independent) — S-604-3 `jr component delete`

**VERDICT: REQUEST_CHANGES** — 0 CRITICAL, 0 HIGH, 2 MEDIUM, 4 LOW, 2 INFO

- **covered_sha:** `d9141e9fa2fe2488dd94632bf2fe06b5f0c81ed2`
- **base:** `develop`
- **head branch:** `feature/S-604-3-component-delete-safety`
- **Reviewer:** pr-reviewer (fresh-eyes, Opus family), second independent pass
- **Module criticality:** SAFETY-CRITICAL (irreversible delete; no undelete endpoint)

> **Relationship to the existing `pr-review.md` in this directory.** A prior fresh-eyes
> review (APPROVE, 0 MEDIUM, 3 INFO) already exists here. This is a *separate, independent*
> pass written as a sibling file — the prior file was NOT overwritten. The two agree
> completely on the eight load-bearing safety properties; this pass additionally found two
> MEDIUM items the prior pass did not raise (JSON decline output contract; three-way
> resolver duplication) and four LOW items. Two of the prior pass's INFO items
> (bidirectional `conflicts_with`; missing `search.expect(0)` on numeric self-move) are
> independently reproduced here as LOW-3 / noted-harmless. Nothing in this pass contradicts
> the prior pass's findings — the delta is additive.

## Verification performed locally (worktree `.worktrees/S-604-3` @ `d9141e9f`)

- `cargo test` — full suite green, 0 failed suites
- `cargo test --test component_commands` — 104/104
- `cargo clippy --all-targets --all-features -- -D warnings` — clean
- `cargo fmt --all -- --check` — clean
- Demo-evidence assets scanned for real Jira keys / org IDs / instance URLs — clean
  (`demo.atlassian.net` placeholder, `127.0.0.1` mock harness only)

## Load-bearing safety properties — all 8 verified against code, not the story doc

| # | Property | Verdict | Evidence |
|---|---|---|---|
| 1 | Disposition guard | PASS | `component.rs:676-687` application-level `UserError` (exit 64), not `ArgGroup`; both-flags via `conflicts_with` → exit 2. Caveat: LOW-4(c). |
| 2 | Ordering asymmetry (name vs numeric) | PASS | Name: resolve `:764-820`, guard `:822-824`. Numeric: guard `:829-831` **before** the confirming GET. Asymmetry correct and deliberate. |
| 3 | `--move-to` same-project only + numeric confirming GET + self-move | PASS | `:903-960` target scoped to `project_key` (source-derived, never `--project` for a numeric source); `:895-901` `eq_ignore_ascii_case`, `unwrap_or_default()` → `""` → **fail-closed**. Self-move `:962-973` is **ID**-equality, before snapshot and DELETE. |
| 4 | Numeric-source project confirmation under BOTH dispositions | PASS | `:834-891`. GET unconditional once a disposition exists; empty `project` field returns `Err` in both the `--project`-supplied and absent branches — correctly replicates PR #704 Finding-C's fail-closed fix. |
| 5 | `--orphan` confirmation gate | PASS | `:986-1030`. Real snapshot-derived count; `no_input && !yes` → exit 64 with count; decline → exit 0, zero DELETE; `--move-to` never enters the block. |
| 6 | Pre-delete snapshot, fully paginated, fail-closed | PASS | `:980-984`. JQL `component = <resolvedNumericId> ORDER BY key ASC` (never a name). `search_issue_keys(jql, **None**)` — with `limit: None`, `has_more=true` is **unambiguously** the JRACLOUD-95368 anti-loop abort (confirmed `api/jira/issues.rs:362-405`), so the `SnapshotIncomplete` mapping is sound. 5xx propagates via `?`. Both abort before DELETE. |
| 7 | `--output json` success shape | PASS | `:1042-1051` via `output::render_json` (#526 invariant). `movedIssuesTo: Option<String>` → `null` under `--orphan`. |
| 8 | Idempotency taxonomy | PASS | Resolver 404 → `UserError` (64); DELETE-call 404 → `ApiError` → `_ => 1`. Not collapsed. |

**Test quality** is genuinely high, not stderr string-matching theatre: fail-closed paths use
wiremock `.expect(0)` on DELETE plus `server.verify()`; AC-005 pins snapshot-before-DELETE via
`received_requests()` positional comparison; AC-018 proves multi-page accumulation (3 keys / 2
pages, `.up_to_n_times(1)` + `body_partial_json` cursor matching); AC-019 drives the **real**
anti-loop guard with a repeated `nextPageToken` rather than faking `has_more`.

## Findings

### MEDIUM-1 — `--output json` decline emits nothing, diverging from the precedent the code cites
`src/cli/component.rs:1004-1024`

The comment at `:1004` says the block "mirrors `handle_comment_delete`'s DEC-174 rationale". It
mirrors the *stdin-read mechanism* but not the *output contract*: `handle_comment_delete`
(`src/cli/issue/interactions.rs:181-192`) emits `{"cancelled": true, "deleted": false}` on stdout
in JSON mode when declined; `handle_delete` does a bare `return Ok(())` with zero output in either
mode.

Consequence: `jr component delete X --orphan --output json` on a TTY, declined → **empty stdout,
exit 0**. `jq` errors on empty input and a consumer cannot distinguish decline from success.
Reachability is low (JSON callers are usually non-TTY → the exit-64 branch), but it contradicts
both the in-repo precedent and CLAUDE.md's "`--output json` returns structured JSON for both
success and errors".

**Fix:** in the `answer != "y"` arm, `match output_format { Json => println!("{}",
output::render_json(&json!({"cancelled": true, "deleted": false}))?), Table => {} }` before
`return Ok(())`; add an assertion to the AC-012 decline case.

### MEDIUM-2 — resolver block now exists in three near-verbatim copies
`src/cli/component.rs:497-556` (`handle_edit`) vs `:764-820` (delete, source-by-name) vs
`:903-960` (delete, `--move-to` target-by-name); numeric block `:419-486` vs `:834-891`.

This is the exact shape that produced PR #704's Finding C: a fail-closed correction applied to one
copy. `handle_delete` re-implements that fix by hand rather than sharing it, and the new
`is_404_error` helper (`:680`) was **not** applied back to `handle_edit`, which still carries the
inline `downcast_ref` at `:425-428`. Three copies of a safety-relevant resolver on an irreversible
command is a durable regression risk.

**Fix (non-blocking, but before the trio is considered done):** extract
`resolve_component_in_project(client, &pk, input) -> Result<Component>` and
`resolve_numeric_component(client, config, id, project) -> Result<(Component, String)>`; call from
all three sites; route `handle_edit`'s 404 check through `is_404_error`.

### LOW-1 — redundant second `GET /rest/api/3/project/{key}/components`
`src/cli/component.rs:907`

For the most common `--move-to` shape (name source + name target) the project component list is
fetched twice, because the source block consumes its `Vec` via `into_iter()` at `:812`. Not a
correctness bug, but it doubles requests and the two fetches can disagree. Bind the source list
before `into_iter()` (or clone the matched component) and reuse it when `project_key` is
unchanged. Note AC-005 mounts that GET with no `.expect()`, so neither count is currently pinned.

### LOW-2 — test name asserts a guarantee its body does not check
`tests/component_commands.rs:3701` —
`test_bc_8_2_001_component_delete_neither_flag_exits_64_zero_http` deliberately expects one
components GET (`.expect(1)`, documented in its own doc comment). CLAUDE.md is explicit that this
is a defect, not style: "a name asserting a guarantee its body doesn't check is a defect". Rename
to `..._exits_64_zero_delete_zero_snapshot`.

### LOW-3 — AC-009 does not explicitly pin "self-move guard fires before the snapshot"
`tests/component_commands.rs:4416-4527`. The code comment at `component.rs:962` claims the guard
precedes the snapshot, but neither case mounts `/rest/api/3/search/jql` with `.expect(0)`. It is
*implicitly* covered (an unmatched wiremock request 404s → exit 1 ≠ the asserted 64), but every
other fail-closed test in this suite states the claim explicitly. Add `.expect(0)` search mocks to
both cases. (Independently matches the prior review's third INFO item.)

### LOW-4 — PR description does not match the diff in four places
1. Architecture mermaid node `5: orphan confirm → dialoguer::Confirm (BC-8.2.006)` is **wrong** —
   the implementation deliberately does *not* use dialoguer (direct `stdin().lock().read_line()`
   per DEC-174), and `component.rs:1004` says so explicitly.
2. "78 new/modified test functions" — 78 is the file's **total** test count; ~27 are S-604-3 tests.
3. BC table, BC-8.2.005 row: "`--move-to <SELF>` → exit 64 pre-flight, **zero HTTP**" — not zero
   HTTP. Source resolution fires, and for a numeric target AC-009 Case B itself mounts the target
   GET with `.expect(1)`. It is zero *DELETE* and zero *snapshot*.
4. `tests/common/fixtures.rs` row lists two fixture families; one function
   (`component_delete_snapshot_page`) was added — drift is simulated by the test's mock, not a
   separate fixture.

### INFO-1 — the affected-issue count is permission-scoped
The JQL snapshot enumerates only issues visible to the authenticated user; the DELETE strips the
component from *all* issues. The prompt's "removes the component from N issue(s)" and
`affectedIssueCount` can therefore under-report the real blast radius. Not fixable client-side
without cross-checking `GET /component/{id}/relatedIssueCounts` (already wrapped by S-604-1). A
one-line rustdoc note on `handle_delete` would stop the next reader assuming completeness.

### INFO-2 — snapshot page size is 50
`search_issue_keys` uses `limit.unwrap_or(50)`, so a 10k-issue component costs ~200 POSTs before
the DELETE. Correct — a cap would break the completeness guarantee — noted for cost awareness only.

## Conclusion

The safety core is correct and the tests actually prove it: I could not construct a path where the
DELETE fires before a completed snapshot, with a cross-project `moveIssuesTo` target, or with a
bare-name JQL. No CRITICAL or HIGH defect exists at this SHA.

MEDIUM-1 is the only finding I would want landed before merge (~10 lines plus one assertion).
MEDIUM-2 and all four LOWs are legitimately follow-up-able if the branch should not be churned
further. Human owns the merge decision (DEC-128); CI Gate must be green independently.
