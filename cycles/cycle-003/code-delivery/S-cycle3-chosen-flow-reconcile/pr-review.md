# PR #762 — Final Fresh-Eyes AI Review

**Story:** S-cycle3-chosen-flow-reconcile (DEC-321 refresh mechanism-override removal + I-6 relogin-then-replace)
**PR:** https://github.com/Zious11/jira-cli/pull/762 (head `4d9fb9a5`)
**Verdict:** APPROVE-WITH-NITS
**Merge recommendation:** MERGE once the three pending CI legs (Test ubuntu, Test windows, Coverage) go green. No blocking findings.

> NOTE: This review was requested as **read-only** by the launching agent ("report to me; no need to post to the PR"). Per that explicit instruction, NO `gh pr review` verdict was posted to GitHub. This file is the durable record; the verdict was reported directly to the requesting agent.

## Verification summary

All load-bearing claims were verified directly against the PR head source, not only the description/diff comments.

### I-6 relogin-then-replace — CONFIRMED SAFE

- **(a) Failed relogin preserves existing creds — YES.** `login_token` (`src/cli/auth/login.rs`) is strictly obtain-then-store: `resolve_credential(email)` → `resolve_credential(token)` → then `store_api_token` (the sole keychain write). A no-input failure errors at `resolve_credential` before any store; the existing pair is never touched. `login_oauth` writes the OAuth token pair only inside `oauth_login(...).await?` on a successful exchange; a cancelled/failed round-trip never reaches it. No clear/delete step exists anywhere in the refresh path — the old `match flow { clear_profile_oauth_pair / clear_all_credentials }` block is fully removed. AC-007 (gated, ran live vs macOS keychain) seeds `old@example.com/old-token`, forces a no-input failure, and asserts the pair is intact and the error never says "cleared".
- **(b) Successful relogin overwrites fully — YES.** `store_api_token`/`store_oauth_tokens` are unconditional two-key `set_password` overwrites. AC-006 (gated) proves replace-on-success.
- **(c) No stale-secret retention — YES.** Overwrite is unconditional on success; failure path writes nothing. The OAuth path is now strictly safer — it no longer pre-deletes the token pair.

### F1 (BYO-OAuth-cred over-delete) — CONFIRMED RESOLVED

On the PR head, `clear_all_credentials(` has exactly three occurrences in `src/`: the definition plus two `#[cfg(test)]` callers (auth.rs:1644, 1945). Zero production call sites. `refresh.rs` references it only in a comment. Marked TEST-ONLY with a landmine doc warning against reintroduction.

### DEC-321 — CONFIRMED

`chosen_flow_for_profile(profile)` is single-arg, resolving solely from `profile.auth_method` (`Some("oauth")`→OAuth, else Token). The `oauth_override` parameter is removed (compile-enforced). `args.oauth`/`args.api_token` are still read for the BC-1.1.016 non-interactive guard and BC-1.2.049/050 notices, but never reach flow selection. Dead `#[cfg(test)] chosen_flow` wrapper removed.

### Tests, doc-drift, conventions

- Removed unit test `chosen_flow_oauth_override_wins_over_config` is legitimately dropped — its premise no longer compiles; coverage moved to integration (AC-002/003/004/006/007/008 + VP-AUTHDX-003 2×3 property test).
- Doc-drift fixes accurate: `field_resolve.rs` param genuinely is `profile: &crate::profile::Profile` (verified at line 378); `profile.rs` "sweep complete / #758" reconciliation consistent; CLAUDE.md keychain paragraph and `chosen_flow_for_profile` rustdoc match new behavior.
- No new `unsafe` in production (all hits are pre-existing `#[cfg(test)]` env patterns); no lint suppression; no let-chains.
- CI: Clippy (both OSes), Format, Deny, MSRV, Mutation, Secret Scan, Signing Guard, Spec Guards, Test (macos) PASS; Test (ubuntu/windows) + Coverage pending; nothing red.

## Findings

| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| NIT | style | Failure message uses `{target:?}` (Debug), rendering the profile with quotes: `...credentials for "sandbox" were left unchanged`. | Optional: `{target}` (Display) reads cleaner. Non-blocking; AC-007 only asserts absence of "cleared". |
| INFO | scope | `login_oauth` BYO `store_oauth_app_credentials` pre-write and `load_oauth_tokens` legacy-flat linger — both pre-existing, out of scope; correctly not re-escalated. | None. |

No new CRITICAL/HIGH/MEDIUM. Diff coherent, within size, description matches changes, previously-tracked non-blocking items correctly left alone.
