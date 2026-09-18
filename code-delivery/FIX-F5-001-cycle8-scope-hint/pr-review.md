# PR #844 — Fresh-Eyes Pre-Merge Review (cycle-008 F5, FIX-F5-001 scope-hint robustness)

**PR:** #844 — https://github.com/Zious11/jira-cli/pull/844
**Head:** `fix/cycle8-f5-001-scope-hint-robustness` @ 4b25eb21 → **Base:** `develop`
**Reviewer:** pr-reviewer (fresh-eyes, independent judgment)
**Verdict:** **APPROVE**

## Scope

Streamlined fix PR (cycle-008 Phase F5 adversarial fix). 5 files, +196/-13
(mostly added test coverage + guard comments). Self-authored transparent fix:
robustness refactor + added tests; zero user-observable behavior/output/exit-code
change claimed. No demo evidence required for this PR class.

- F3 (LOW, latent fragility): make the Agile OAuth granular-scope-hint rewrite
  chain-aware instead of top-level-only.
- F1 (MEDIUM, test-coverage gap): add unit tests pinning the scope-hint mapping,
  including a context-wrapped-chain case.

## Findings

No blocking findings. No suggestions requiring change. Two non-blocking nits.

### F3 — chain-aware downcast — CORRECT & COMPLETE
- New shared helper `is_insufficient_scope_error(&anyhow::Error)` in
  `src/cli/board.rs` uses
  `err.chain().find_map(|c| c.downcast_ref::<JrError>()).is_some_and(matches!(.., InsufficientScope{..}))`.
  This walks the whole anyhow chain, versus the old `downcast`/`downcast_ref`
  which anyhow evaluates against the TOP-LEVEL error object only. That is the
  intended and only behavioral delta.
- All 3 Agile call sites switched to the helper: `rewrite_agile_scope_error`
  (board.rs) + both `issue/list.rs` sites (`handle_list`'s sprint-list ~L479 and
  board-config ~L522). No Agile site missed.
- The `jsm_create.rs` top-level `downcast::<JrError>()` (~L390) is the separate
  JSM `handle_jsm_create` path — correctly OUT of scope for FIX-F5-001 F3 (which
  is specifically the six Agile API functions). Not touched, correctly.
- Behavior byte-identical today: verified all six Agile fns
  (`list_boards`/`get_board_config` in `api/jira/boards.rs`;
  `list_sprints`/`get_sprint_issues`/`add_issues_to_sprint`/`move_issues_to_backlog`
  in `api/jira/sprints.rs`) return `InsufficientScope` raw via `?` with no
  `.context()`, so it always sits at chain-top now. Guard comments added at all
  six + init.rs as claimed.

### `rewrite_agile_scope_error` refactor — BEHAVIOR-PRESERVING
- Old: `match err.downcast::<JrError>() { Ok(InsufficientScope)=>rewrite, Ok(other)=>anyhow!(other), Err(other)=>other }`.
- New: `if is_insufficient_scope_error(&err) { return rewrite } err`.
- The old `Ok(other)=>anyhow!(other)` re-wrapped a non-InsufficientScope JrError
  into a fresh anyhow error; the new code returns `err` unchanged — an
  improvement (preserves original identity/context). JrError value, Display, and
  exit code are identical, so no observable difference. Covered by the existing
  passthrough tests, both of which pass under the new code.

### F1 tests — GENUINE (would fail against old code)
- `test_rewrite_agile_scope_error_fires_through_context_wrapped_chain`: wraps
  `InsufficientScope` in `.context(...)`; under the old top-level-only
  `downcast::<JrError>()` this returns `Err` (top is the anyhow Context wrapper)
  → no rewrite → the test's downcast-to-`NotAuthenticated` fails. New code
  rewrites. Real, load-bearing test — not tautological.
- `test_rewrite_agile_scope_error_fires_for_init_list_boards_scope_string`: pins
  init.rs's scope string through the shared helper. Reasonable given the init
  end-to-end path is only reachable via the keyring-gated `#[ignore]`d test.

### Build / lint — CLEAN
- `cargo test --lib board::tests` → 9 passed, 0 failed.
- `cargo clippy --all-targets` → no warnings.
- `cargo fmt --all -- --check` → clean.
- Test names follow `test_<verb>_<subject>_<outcome>`; no `#[allow]`/`unsafe`;
  #526 JSON invariant and exit codes untouched.

## Non-blocking nits (no change required)
- NIT-1 (latent): `find_map` returns the FIRST JrError in the chain. If a future
  chain ever nested a non-InsufficientScope JrError ABOVE an InsufficientScope
  one, this returns false and misses it. Not realistic (a chain carries at most
  one JrError; context wrappers downcast to None), and it matches intent.
  Awareness note only.
- NIT-2: the documented residual (init.rs `.map_err` wiring only e2e-covered by
  the keyring-gated `#[ignore]`d test, so a deleting-mutant survives CI) is
  accurately described and properly flagged with a guard comment at the call
  site. Correct to defer, not fix here.

## Claims-vs-diff
Every claim in the PR description matches the diff. "Zero user-observable
behavior/output/exit-code change" is accurate.
