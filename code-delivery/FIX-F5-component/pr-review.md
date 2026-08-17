# PR #709 Review — F5 component-mgmt hardening (`fix/f5-component-mgmt-hardening`)

**Reviewer:** pr-reviewer (T2, fresh-eyes)
**PR:** https://github.com/Zious11/jira-cli/pull/709
**Base:** develop @ b1610d55 · **Head:** fix/f5-component-mgmt-hardening (merge-base == develop HEAD; no rebase needed)
**Scope reviewed:** PR diff (8 files, +524/-31, 6 commits), description, tests. Cross-checked against the checked-out worktree.

## VERDICT: APPROVE

No BLOCKING / HIGH / MEDIUM findings. One optional LOW nit (non-blocking). Closes 6 Phase-F5 findings; all re-reviewed clean.

Merge authority remains the human's per DEC-128 — this verdict does NOT authorize merge.

---

## Local verification (worktree)

- `cargo test --test component_commands` → 108 passed (incl. `test_bc_8_1_005_component_create_honors_global_project_flag`, `test_bc_8_1_005_component_create_no_project_exits_64_not_clap_exit_2`, `test_bc_8_1_001_component_list_honors_global_project_flag`).
- `cargo test --test issue_commands` → 118 passed (incl. all 4 ExactMultiple union tests).
- `cargo clippy --all-targets -- -D warnings` → clean (no warnings).
- `cargo fmt --all -- --check` → clean.

## 8-item checklist

1. **Diff coherence** — PASS. All changes trace to a named F5 finding; src touches scoped to `list.rs`, `mod.rs`, `component.rs`, `api/jira/components.rs`; docs to `cache.rs` rustdoc + `CLAUDE.md`; tests to the two command test files.
2. **Description accuracy** — PASS. Every claimed behavior (union, global `--project`, encoding, doc-only cache/CLAUDE changes, comment sweep) verified in the diff and by tests.
3. **Test coverage** — PASS. 4 union tests assert exact JQL via observed outbound `/search/jql` body **with negative assertions** (no first-pick regression); 3 create-project tests pin global-flag honored, local flag still works, and exit-64 (not clap-2) with no `.jr.toml` fallback.
4. **Demo evidence** — PASS (ADAPTED-TO-TEST-EVIDENCE). Behavior-change manifests only on a live case-only-duplicate component set (impractical to provision); arg-parsing fix is not visually demonstrable. Covered by exact-JQL/exit-code tests — convention-consistent with S-604/S-606 precedent.
5. **Commit quality** — PASS. Conventional Commits, finding IDs present across all 6 commits.
6. **Diff size** — PASS. Small, focused.
7. **Missing changes** — None. Encoding applied to every interpolated component URL segment; create's static POST path correctly needs none.
8. **Dependency status** — Consumes merged S-604-1 resolver + S-606-1 `--component` filter. OK.

---

## Crux items verified

1. **ExactMultiple read-union (`src/cli/issue/list.rs`)** — `resolve_one_component_id` now returns `Vec<String>`. `Exact`/numeric-bypass → 1-element vec; `ExactMultiple` re-scans the already-fetched `components` for every case-insensitive name match (zero extra HTTP), ascending-numeric sorted. Compose paths correct: bare/`not:` → `component in (…)` / `(component not in (…) OR component is EMPTY)`; `all:` → parenthesized OR-of-equalities term inside the AND-chain; mixed `all:` verified. `ExactMultiple` arises only from case-only duplicates (`partial_match`), and the numeric bypass short-circuits to `Exact` upstream, so "matched is always a name" holds. **Injection-safe:** only numeric API-sourced ids (or ascii-digit-validated bypass) are interpolated unquoted — identical to the pre-existing `Exact` path; no new surface. SEC-707-1 injection pin retained. Single/no-match/Ambiguous/None paths unchanged. **READ-PATH-ONLY** divergence from the mutating commands' fail-closed `ExactMultiple` behavior — correctly not propagated to create/edit/delete.

2. **`component create` global `--project` (`src/cli/mod.rs` + `src/cli/component.rs`)** — Local field relaxed from `required=true String` to `Option<String>`; `handle()` merges `project.or_else(|| project_flag.map(str::to_string))`; `handle_create` enforces presence with an app-level exit-64 `JrError::UserError` naming `--project`, BEFORE any HTTP. No `.jr.toml` fallback (create ignores `config.project_key`), pinned by the exit-64-not-clap-2 test (writes `.jr.toml project=FOO`, still exits 64). Consistent with the already-working list/edit/delete global-flag support. Correctly NOT implemented via `#[arg(requires)]` (would yield clap exit 2).

3. **URL encoding (`src/api/jira/components.rs`, F5-B-LOW-1)** — `urlencoding::encode` now applied at `list_components`, `get_related_issue_counts`, `edit_component`, `get_component`, consistent with the pre-existing `delete_component` (id + `moveIssuesTo`). `create_component` POSTs a static `/rest/api/3/component` (project in body) — correctly nothing to encode, not a miss. No double-encoding (each site encodes once).

4. **`cache.rs` rustdoc + `CLAUDE.md`** — Purely additive documentation; no runtime code touched. "Unwired foundation" framing accurate: only `invalidate_components_cache` has production call sites, effective no-ops until a future writer exists (S-608-1).

5. **`tests/component_commands.rs` RED-gate sweep** — Pure comment cleanup: every removed line is a `///` doc comment; zero test-logic change (verified — no non-comment removed lines). The 4 union tests are additions in `issue_commands.rs`.

---

## Findings

| Severity | File | Finding | Suggestion |
|----------|------|---------|------------|
| LOW (optional) | `src/cli/issue/list.rs` (`resolve_component_clauses`) | Repeated case-variant values (e.g. `--component Backend --component backend`, or `all:Backend,backend`) produce redundant duplicate ids / OR-groups in the emitted JQL. Harmless — JQL semantics unaffected. | Optional: de-dup ids before joining for cosmetically tidier queries. Not required. |

---

## Posting note

This is a same-account review (reviewer GitHub account `Zious11` == PR author account). GitHub's same-account classifier rejects a self-`gh pr review --approve` ("Can not approve your own pull request"), so the formal APPROVE could not be recorded as a GitHub approval event. The APPROVE verdict is recorded in this file (the authoritative factory artifact) and was also surfaced on the PR's review timeline via a `gh pr review --comment` (a review event, NOT `gh pr comment`). Merge authority remains the human's per DEC-128 — this verdict does not merge or authorize merge. Same constraint and handling as the S-606-1 precedent.
