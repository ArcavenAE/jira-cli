# PR #763 Review — `fix(auth): relogin-then-replace on login mechanism switch`

**Verdict: APPROVE**
**Merge recommendation: MERGE once CI is green** (`mergeStateStatus: BLOCKED` reflects pending required checks / ci-gate, not a review block; `mergeable: MERGEABLE`).

Data-loss finding is closed with no over-delete. No new BLOCKING (CRITICAL/HIGH/MED) findings.

## Scope reviewed

Diff + PR description only (information wall respected — no `.factory/` pipeline artifacts read). Soundness spot-checked against the surrounding source in `src/api/auth.rs` and `src/cli/auth/login.rs` (base branch) to confirm no clear-before-store path exists outside the diff.

## Checklist findings

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence | PASS — all changes relate to the single relogin-then-replace fix |
| 2 | Description accuracy | PASS — CHANGELOG + PR body match the actual reorder + per-kind narrowing |
| 3 | Test coverage | PASS — failing-half + success-half tests added; both switch directions covered (keyring-gated) |
| 4 | Demo evidence | N/A — credential/keychain internals, no user-visible UI surface; TDD RED-proof cited |
| 5 | Commit quality | PASS — conventional format, scoped, clear |
| 6 | Diff size | PASS — 330/-47, focused |
| 7 | Missing changes | PASS — reorder, new symmetric primitive, doc updates, tests all present |
| 8 | Dependency status | PASS — mirrors already-merged sibling I-6/DEC-321 fix (#762 on develop) |

## Verification of the four load-bearing claims

1. **Reorder is correct and complete.** `clear_outgoing_mechanism_on_switch` now runs AFTER the `login_oauth`/`login_token` dispatch. Both login fns propagate via `?`, so a failed login short-circuits before the clear is reached. Confirmed there is no other clear-before-store path in `handle_login` — base branch has exactly one clear call; the diff relocates that single call. `current_auth_method` is still captured before login (outgoing kind read before login mutates on-disk `auth_method`); `switching` remains used in the moved call (no dead binding). The deterministic RED path is real: `resolve_oauth_app_credentials(...)?` errors before any `store_*`, exactly as the failing-half test exploits.

2. **`clear_profile_api_token_pair` correctly scoped.** Deletes only `<profile>:email` and `<profile>:api-token` (namespaced). Does NOT touch shared/legacy flat `KEY_EMAIL`/`KEY_API_TOKEN`, other profiles, or shared OAuth-app keys — i.e. not the F1 `clear_all_credentials` landmine. Structurally symmetric with `clear_profile_oauth_pair`. The one intentional asymmetry (oauth's variant also clears the `"default"` legacy flat pair) correctly does not apply here because only OAuth keys lazy-migrate; leaving flat API-token keys untouched is the documented BC-1.4.032 no-touch invariant. No over-delete.

3. **Successful switch still clears outgoing orphans.** `match outgoing { "oauth" => oauth_pair, "api_token" => api_token_pair, _ => Ok(()) }` dispatches on the OUTGOING method, so the just-stored new-mechanism pair is never touched and the orphaned outgoing pair is removed. Success-half test (`oauth → api_token`) asserts both new creds stored AND no orphaned oauth creds. Failing-half (`api_token → oauth`) covers the other direction. Unknown-`outgoing` arm safely no-ops.

4. **Conventions + CHANGELOG clean.** Accurate `### Fixed` entry cross-referencing sibling I-6/DEC-321. `with_context` message updated `before` → `after switching`. No-op guards (None / same-mechanism) and the `emit_switch_notice` gate preserved.

## Non-blocking notes (not escalated)

- "Call only after `Ok`" is a convention/doc-enforced (not type-enforced) caller fence. Adequately documented; acceptable for scope.
- New tests are keyring-gated (`JR_RUN_KEYRING_TESTS=1` + `#[ignore]`), so outside default CI — consistent with existing sibling tests; description reports them RED-proven and passing under the gate.

## Bottom line

The clear is structurally unreachable until the new credentials are stored; the narrowed per-kind clear prevents deleting the just-stored creds and avoids shared-key / other-profile over-delete. Data-loss closed. Approve; merge on green CI.
