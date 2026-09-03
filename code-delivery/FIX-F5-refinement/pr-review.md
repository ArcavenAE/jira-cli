# PR #764 — Fresh-Eyes Review (FIX-F5-refinement)

**Title:** fix(auth): F5 refinement — surface locked-keychain refresh errors + logout/cache/doc fixes
**Verdict:** APPROVE-WITH-NITS — safe to merge
**Scope reviewed:** PR diff + description only (information-asymmetry wall; no `.factory/` access)

> NOTE: The caller requested a read-only review and explicitly said not to post to
> the PR. This file is the required review artifact; no `gh pr review` verdict was
> posted to GitHub per that instruction. Posting is deferred to the caller.

## Summary

All four approved fixes are sound. FIX-1 fails safe, classifies absent-vs-error
correctly, and leaks no credential values; FIX-2 is strictly non-destructive and
correct; FIX-4 is a strict improvement over the prior no-guard state; FIX-3 is
doc/text-only. No new CRITICAL/HIGH/MED findings. Four non-blocking findings.

## Soundness confirmation of approved fixes

- **FIX-1 (both call sites):** Asymmetric classification is intentional and
  correct — site 1 uses positive marker `downcast_ref::<NoAppCredentialsAvailable>`
  (→ fall back; else propagate); site 2 uses `is_backend_keyring_error` chain-walk
  (keyring error → propagate; else fall back). Fails safe both directions: never
  substitutes weak/wrong creds; preserves mock-env/no-creds behavior. Propagated
  errors carry no secret values (`keyring::Error` variants embed service/account,
  not the secret; added `.context()` is generic). Always-run suite green (1249/0)
  confirms the no-creds path resolves to `NoAppCredentialsAvailable`, not a
  keyring error.
- **FIX-2:** `.is_some_and(|p| auth_method != Some("oauth"))` routes unset/unknown
  methods to the non-destructive informational notice; reserves OAuth-clear for
  explicit `"oauth"`. Absent-profile behavior unchanged from prior `==` form.
  Strictly safer; new integration test pins it.
- **FIX-3 / FIX-4:** doc-only and a one-line defensive guard; both benign.

## New findings (all non-blocking)

| # | Severity | Category | Finding | Suggestion |
|---|----------|----------|---------|------------|
| 1 | suggestion (LOW) | coverage | FIX-4 guard covers only `is_empty()`. `Profile::from("..")` is equally constructible (ADR-0011, no validation) and MORE destructive: `cache_dir` → `<cache_root>/v1/..` → `remove_dir_all(<cache_root>)` wipes the entire cache root. `/`,`\`, bare `.` in same class. LOW: path unreachable (callers validate first); strict improvement over prior no-guard state. | Broaden guard to reject empty + `.`/`..` + any path-separator/traversal component, consistent with its landmine rationale. |
| 2 | suggestion (LOW) | coverage | FIX-1 site-2 classification silently coupled to `load_oauth_tokens` preserving the typed `keyring::Error` in its chain. A future refactor stringifying keyring errors would reclassify backend errors as "absent" and re-introduce the swallow. New test (`test_f2_01_…`, `#[ignore]`/keyring-gated) exercises the resolve path and returns before site 2, so site-2 propagation appears unexercised. | Add explicit regression test for the refresh-token-read (site 2) backend-error propagation. |
| 3 | nit | description | FIX-3 refresh.rs comment now asserts per-profile namespaced `<profile>:email`/`<profile>:api-token` (BC-1.4.031), replacing prior "SHARED api-token". A comment-accuracy fix must itself be accurate. | Confirm BC-1.4.031 landed and api-token is genuinely per-profile before merge. Low confidence from diff alone. |
| 4 | nit | coverage | New locked-keychain test is `#[ignore]` + `JR_RUN_KEYRING_TESTS`-gated and asserts `msg.contains("keychain")`, depending on platform-specific `keyring::Error` Display + `.context()` wording. Provides no CI protection. | Acceptable; note the RED-proof is environment-specific, not CI-enforced. |

## Merge recommendation

Merge. All findings non-blocking; none regress behavior. Consider addressing #1
(broaden guard) and #2 (site-2 regression test) in a small follow-up, since both
harden exactly the failure classes this bundle targets.
