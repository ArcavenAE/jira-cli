# PR #715 — Fresh-eyes Pre-Merge Review

**Verdict: APPROVE**

One-line rationale: All three fixes are correct, tightly scoped, and byte-for-byte behavior-preserving where claimed; the exit-code change is placed correctly (pre-fork, live + dry-run agree), fully tested with exact assertions, and CI is green (Clippy both platforms, fmt, MSRV, Spec Guards).

## What I verified

### FIX-1 — numeric-id predicate consolidation (behavior-preserving)
- All **5 sites** now route through `helpers::is_numeric_component_id`, and each replaced expression was byte-identical to the helper body `!s.is_empty() && s.chars().all(|c| c.is_ascii_digit())`:
  - `helpers.rs::resolve_component`
  - `format.rs::ComponentRefKind::for_input`
  - `component.rs::is_numeric_id` (kept as a thin local wrapper — appropriate; called throughout that file)
  - `edit.rs::resolve_bulk_component_ids_with_list`
  - `list.rs::resolve_one_component_id`
- No site silently changed semantics (no trim, no `is_empty` flip, no call-order change). The `!s.is_empty()` vacuous-truth guard is preserved and documented.
- Remaining `is_ascii_digit` occurrences in `src/cli/` (attachments AID, changelog, `field_resolve` customfield IDs, `jsm_create` request-type, `queue`, `requesttype`) are different-domain predicates — correctly out of scope, not missed sites.
- Visibility plumbing correct: `pub(crate)` fn + `pub(crate) use helpers::is_numeric_component_id` re-export in `mod.rs`; used, no dead-import warning.
- No stale "keep in sync / mirrors byte-for-byte" comments left behind (the two remaining `byte-for-byte` comments in `edit.rs` refer to wire-request snapshots, unrelated).

### FIX-2 — `rename --all-projects` zero-match → exit 64
- Guard placed after `discover_rename_targets` but **before the `dry_run` fork**, so live and `--dry-run` agree (BC-8.3.004 Invariant 1).
- Fires only when `targets.is_empty() && ambiguous.is_empty()` — ambiguous-only path still proceeds to the exit-1 fan-out, so exit-64 "not found" is reserved for genuine zero-match. Semantically correct.
- Message `Component '<OLD>' not found in any accessible project.` uses raw quoted `old`, is `JrError::UserError` (exit 64), consistent in kind with the single-project form.
- Now-unreachable dry-run inner `is_empty && is_empty` branch removed and replaced with unconditional loops (dead code cleaned up, commented).
- Tests: 4 (live/dry-run × json/table) flipped RED→GREEN with exact assertions — `status.code() == Some(64)`, verbatim message constant, empty stdout, and structured `"code":64` envelope for JSON.

### FIX-3 — docs
- `component.rs` is actually 1796 LOC on the PR branch; `~1,800` figure + added `rename` mention are accurate. Spec Guards CI passes with the new figure.

### Conventions
- No new `#[allow]`, `unsafe`, or let-chains. `--output json` paths unchanged. Commit split (refactor / fix / docs) is clean and conventional.

## Non-blocking notes
- **nit:** `is_numeric_component_id` docstring says "SINGLE source of truth" while `component.rs::is_numeric_id` remains a same-named wrapper — mildly in tension but self-consistent (wrapper doc labels it a thin delegator).
- **LOW (pre-existing, out of scope):** ambiguous-only `--all-projects` exits 1 whereas single-project ambiguous would exit 64 — an exit-code asymmetry predating this PR; defensible for a fan-out command.
- At review time Windows `Test` and `Mutation testing` CI jobs were still pending — worth confirming green before merge, though neither is expected to be affected.

Files reviewed: `src/cli/component.rs`, `src/cli/issue/helpers.rs`, `src/cli/issue/mod.rs`, `src/cli/issue/format.rs`, `src/cli/issue/list.rs`, `src/cli/issue/edit.rs`, `tests/component_commands.rs`, `CLAUDE.md`.
