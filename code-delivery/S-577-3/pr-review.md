# PR #615 — Fresh-eyes review (S-577-3 `jr issue comment delete`)

- **PR:** #615 — feat(cli): implement `jr issue comment delete KEY --id ID` with confirmation gate (S-577-3, #577)
- **Base → Head:** develop → feat/comment-delete-handler (3d9b7db)
- **Reviewer:** pr-reviewer (fresh context, information wall — reviewed diff, PR description, and test evidence only; no `.factory/` internals)
- **Verdict:** NO BLOCKING FINDINGS. 2 nits. Posted to GitHub via `gh pr review 615 --comment` (`--approve` server-blocked: same-account self-review).

## Zero-trust verification

### 1. DEC-174 mechanism — CONFIRMED correct
The interactive path deliberately avoids `dialoguer::interact_on(&Term::stderr())` and instead writes the prompt with `eprint!` to stderr and reads with `io::stdin().lock().read_line()`. Inline rationale is accurate: console's upfront `is_term()` gate returns `NotConnected` on piped stderr. EOF (`Ok(0)`) → `JrError::Interrupted` (exit 130). Default-N semantics correct: only `y`/`yes` (case-insensitive via `to_ascii_lowercase`) confirm. Release-safe because `src/main.rs` auto-sets `no_input=true` on non-TTY stdin, so the direct read is only reached with a real terminal or the debug-only `JR_STDIN_IS_TTY` seam.

### 2. KEY#ID preamble (BC-3.5.004) — CONFIRMED
404/403 branch emits `format!("comment not found or permission denied: {key}#{id}\n{message}")` → exactly `FOO-1#10001`. Re-wrap to `JrError::UserError` → exit 64. `_ => None` arm lets non-404/403 (500) propagate as exit 1. Pinned by `test_bc_3_5_004_delete_404_exits_64_with_body` and `test_bc_3_5_004_delete_500_exits_1_not_64` (the latter kills the `== 403` → `!= 403` mutant).

### 3. `JR_STDIN_IS_TTY` seam — CONFIRMED single gated read site
Exactly one `std::env::var("JR_STDIN_IS_TTY")` read in `src/main.rs`, immediately preceded by `#[cfg(debug_assertions)]` with a `#[cfg(not(debug_assertions))]` → `false` fallback. The `interactions.rs` occurrence is a rustdoc reference, not a read. `tests/jr_stdin_is_tty_release_gate.rs` pins the gate via a 5-line window search.

### 4. `exclude_re` coherence — CONFIRMED (with PR-body nit)
`handle_comment_delete` removed; `exclude_re = ["handle_comment_(edit|view)"]` matches the two real remaining `todo!()` stubs (`handle_comment_edit` → S-577-4/5, `handle_comment_view` → S-577-6). The `.cargo/mutants.toml` comment correctly says "two functions".

### 5. No closing keywords — CONFIRMED
No commit or PR-body text auto-closes #577. `fix(cli): ... (#577)` is a Conventional-Commit type prefix + trailing bare reference; GitHub auto-close requires the keyword to directly precede the reference (`fixes #577`), which never occurs. All references are `(S-577-3, #577)` / `(#577)` form.

## Findings

| # | Severity | Category | Finding | Suggestion |
|---|----------|----------|---------|------------|
| 1 | nit | description | PR body says "the three remaining todo!() stubs (`edit`/`view`/`handle_comment_view_impl_todo`)", but only **two** stubs exist — `handle_comment_view_impl_todo` is not a function in the codebase. Code and `.cargo/mutants.toml` comment are correct ("two functions"); only the PR prose is off. | Edit PR description to say two stubs. No code change. |
| 2 | nit | correctness | Interactive read `Ok(0) \| Err(_)` maps a genuine stdin I/O error to `JrError::Interrupted` (exit 130). EOF→130 is correct; a real read error is arguably exit 1. | Optional: split the arm so `Err(_)` propagates as generic I/O error. Acceptable as-is (documented contract, extremely unlikely). |

## Beyond the checklist
- JSON paths route through `output::render_json` (#526 render invariant): success `{"deleted":true,"id":..,"key":..}`, cancel `{"cancelled":true,"deleted":false}` (id/key absent, exact key-set asserted).
- Confirmation-gate ordering correct for all four flag combinations.
- `validate_comment_id` charset guard runs before any network call; unit tests exercise every `||` arm plus the empty-string guard.
- Comprehensive test coverage: 204 human+JSON, non-interactive exit 64, interactive cancel, 404 KEY#ID, invalid charset, key URL-encoding, EOF→130, confirm-y→DELETE, 500→exit 1, release gate.
- Diff 889 additions but 667 are test files; production surface is small and focused. Size justified.

## Verdict
No blocking issues. Recommend merge after the optional PR-body wording tweak. GitHub review posted as COMMENTED (self-approval server-blocked).
