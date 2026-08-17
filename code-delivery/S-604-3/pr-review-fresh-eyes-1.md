# PR Review — S-604-3 `jr component delete` (PR #706)

**Reviewer:** pr-reviewer (fresh-eyes, final pre-merge gate, different model family)
**Scope reviewed:** PR #706 diff only — `src/cli/component.rs` (`handle_delete` + helpers), `src/api/jira/components.rs` (`delete_component`), `src/cli/mod.rs` (`ComponentSubcommand::Delete`), `src/error.rs` (`JrError::SnapshotIncomplete`), `src/main.rs`, `tests/component_commands.rs` (27 delete tests), `tests/common/fixtures.rs`, and demo evidence under `docs/demo-evidence/S-604-3/`.
**Module criticality:** SAFETY-CRITICAL (irreversible delete; no undelete endpoint).

## Verdict

**APPROVE** — 0 BLOCKING, 0 HIGH, 0 MEDIUM. 3 INFO.

## Verification of load-bearing safety mechanics

### DELETE ordering (snapshot-before-DELETE) — CORRECT
Order in `handle_delete`: source resolve → target resolve (`--move-to`) → self-move guard (ID-equality, `component.rs:964`) → JQL snapshot (`:982`) → orphan confirmation gate (`:994`) → `delete_component` (`:1034`). Snapshot uses `?` propagation plus an explicit `has_more` → `SnapshotIncomplete` abort, both strictly before any DELETE. AC-019 pins this: the JRACLOUD-95368 drift fixture (repeated `nextPageToken` → anti-loop `has_more=true`) and a genuine 5xx both assert `DELETE.expect(0)`, exit 1, and verbatim `"could not reliably enumerate affected issues — aborting delete"`.

### Wrong-target impossibility — CORRECT
Snapshot JQL (`:981`) and DELETE (`:1035`) both key off `component_id` (source); `target_id` only ever populates `moveIssuesTo`. AC-017 asserts EXACT `component = 10001 ORDER BY key ASC` against a two-project same-name fixture (resolved numeric id, never the shared name). Numeric `--move-to` targets are project-validated against the source's project (`:902`); cross-project/404 target → `move_to_not_found_in_project` (zero DELETE, AC-007).

### Disposition guard (DEC-188) — CORRECT
Neither flag → application-level `JrError::UserError` exit 64 naming both `--move-to` and `--orphan`, no count (`disposition_guard_error`, `:690`). Both flags → clap `conflicts_with` exit 2. Correct DEC-188 split (not `ArgGroup::required`). Invariant-1 ordering: NAME source resolves before the guard (`:816` — not-found wins, AC-003); numeric source hits the guard first (`:824` — no HTTP reachable pre-disposition, AC-004).

### Exit-code taxonomy — CORRECT
`SnapshotIncomplete` → `exit_code()` `_ => 1`. Resolver 404 → `UserError` (64). DELETE-race 404 propagates via `client.delete → send_inner` as `JrError::ApiError{status:404}` → 1 (`client.rs:1051`). AC-021 pins the 64-vs-1 divergence in one test; AC-022 pins the `moveIssuesTo`-target race → 1.

### `--orphan` gate & real count (Invariant 2) — CORRECT
Snapshot precedes both the prompt and the `--yes`-absent exit-64 (`:994`), so `<N>` is always the real count. AC-013 asserts the verbatim non-interactive message with literal `7`; AC-012 asserts the verbatim interactive prompt with count `2` and `DELETE.expect(0)` on decline. `--move-to` never prompts (AC-014, EOF-would-exit-130 proof).

### CLI contract — CORRECT
Global `--project` propagation verified empirically by `test_bc_8_2_002_component_delete_honors_global_project_flag` (`--project FOO` before the subcommand, no per-subcommand flag → exit 0). The documented false positive does not apply. `--output json` shape asserted with exact BTreeSet key-set equality for both move-to (`movedIssuesTo`=id) and orphan (`movedIssuesTo`=null) (AC-020). Full pagination reflected in `affectedIssues`/`affectedIssueCount` (AC-018).

### Invented strings — no BC contradiction
`disposition_guard_error` correctly omits any count (snapshot never fires there). The table success line intentionally carries the count (BC-8.2.008 mandates naming disposition + count). `move_to_not_found_in_project` and the "no project field" fail-closed messages are non-BC-pinned but consistent with fail-closed intent.

### Test rigor
Assertions are exact-value (serde `Value` equality on JQL, BTreeSet key sets, verbatim messages, literal counts) with `.expect(N)` route counts and per-path `verify()`. These fail against the obvious mutants (id↔name swap, count placeholder, guard/snapshot reorder, disposition→exit-2). Demo evidence present as `.gif`/`.webm`/`.tape` + `evidence-report.md` (not `.txt`).

## Findings

| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| INFO | coherence | The two "no project field" fail-closed branches (`component.rs:857`/`:864`) defend against a scenario a real component GET does not produce (component GET always returns `project`). | Keep as-is; exit-64 fail-closed is the safe choice for a destructive command. |
| INFO | coherence | `move_to`/`orphan` declare `conflicts_with` bidirectionally — redundant. | Harmless; no change required. |
| INFO | coverage | Numeric self-move (case B) has no `search.expect(0)`; but name self-move ordering IS pinned via AC-016 case (c) with `search.expect(0)` on the same code path. | Adequate coverage; optionally add a `search.expect(0)` to case B for symmetry. |

## Conclusion
Safety-critical ordering guarantees, exit-code taxonomy, disposition/self-move guards, and snapshot fail-closed behavior are all correctly implemented and mutation-resistantly tested. Approved for merge.
