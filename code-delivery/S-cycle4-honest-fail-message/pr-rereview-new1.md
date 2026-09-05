# PR #771 — Focused Re-Review of Finding NEW-1 Fix

**Story:** S-cycle4-honest-fail-message (cycle-004, auth/credential module)
**Delta reviewed:** `git diff 17dcccb7..origin/feat/cycle4-honest-fail-message` (new head `29912390`)
**Scope:** Single fix closing the LOW WARNING (NEW-1) from the prior re-review. Fresh-context, self-report not trusted.

## Verdict: CLEAN (merge-ready)

No blocking, warning, or nit findings. The fix is correct, minimal, well-documented, independently test-proven, and introduces no regression or new defect.

---

## What the delta changes

1. New existence-only probe `auth::profile_has_stored_credentials(&Profile) -> Result<bool>` (`src/api/auth.rs`) — checks, in order: namespaced OAuth pair, namespaced api-token pair, and (for `"default"` only) the legacy flat OAuth pair.
2. `should_mark_auth_method_before_attempt` and `mark_auth_method_if_new` (`src/cli/auth/login.rs`) gain a `has_stored_credentials: bool` param; predicate is now `current_auth_method.is_none() && !has_stored_credentials`.
3. `handle_login` computes the probe **only when `current_auth_method.is_none()`**, else passes `false`.
4. Tests updated for the new arity + two new regression tests.

---

## Verification against the four required points

### 1. NEW-1 genuinely resolved (and the regression test is not a tautology) — CONFIRMED

- New predicate `current.is_none() && !has_stored_credentials`:
  - Legacy `auth_method=None` profile still holding WORKING creds → probe returns `true` → `None.is_none() && !true = false` → **not** pre-marked. On a failing OAuth switch the profile keeps its `auth_method: None` label and continues working on its existing credentials. NEW-1 closed.
  - Genuinely credential-less brand-new profile → probe returns `false` → `true && !false = true` → **still** pre-marked. B-1 stays fixed.
- Regression test `mark_auth_method_if_new_leaves_legacy_none_labelled_profile_with_stored_credentials_untouched` calls `mark_auth_method_if_new(global, "legacy", None, "oauth", true)` and asserts `auth_method` stays `None`. Against the **old** single-arg predicate (`current.is_none()` → `true` for `None`) the old code would have set it to `"oauth"` — so the test genuinely distinguishes old vs new behavior. Not a tautology.
- Unit test `should_mark_auth_method_before_attempt_false_when_none_labelled_profile_has_stored_credentials` pins `!should_mark_auth_method_before_attempt(None, true)`.

### 2. No B-1 regression — CONFIRMED

- `b1_brand_new_oauth_profile_login_failure_logout_routes_to_oauth_branch` now passes `has_stored_credentials = false`; the profile is marked `"oauth"`, `!auth_method_is_api_token("oauth")` holds, and `jr auth logout` still routes to the OAuth clear branch. B-1 behavior intact.
- `should_mark_auth_method_before_attempt_false_when_switching_from_established_method` extended to assert `Some(_)` short-circuits regardless of `has_stored_credentials` (both `false` and `true` variants).

### 3. Security lens on the new keychain probe — CONFIRMED CLEAN

- **Existence-only / CWE-532:** probe returns only a `bool` via `.is_some()`; the secret string returned by `read_keyring_optional` is dropped immediately, never logged, printed, or persisted. Reading the value into memory is inherent to the `keyring` API's `get_password()`; there is no incremental leak versus every other read site in the module.
- **Error handling:** uses `read_keyring_optional` (matches `NoEntry` as absent, propagates every other backend error via `?`). A genuine backend error is **not** coerced into "no stored credentials" — matching the module's established convention and the doc claim. `handle_login` propagates it via `?`.
- **No partial/split credential state:** the probe is read-only; it creates nothing and mutates nothing.
- **Correct profile:** probe is called with `Profile::from(target.clone())` — the login target, not another profile. Namespaced keys are correctly composed (`<profile>:oauth-access-token` etc.).
- **`"default"`-only legacy branch correctly scoped:** guarded by `profile.as_ref() == "default"` and requires BOTH legacy flat OAuth keys present — mirroring `load_oauth_tokens`'s own default-only migration fallback, which would load and migrate that pair on the next command. Legacy flat api-token pair is deliberately NOT probed (BC-1.4.032 made it permanently unusable; probing it would resurrect the "trust a credential that can't be loaded" bug). This is documented and correct.
- **No new keychain-prompt UX regression:** the probe runs **only** when `current_auth_method.is_none()`. On the `Some(_)` switch path it is skipped entirely (`else false`), so a mechanism switch performs no extra keychain round-trip / OS prompt. `should_mark_auth_method_before_attempt` short-circuits on `Some(_)` before `has_stored_credentials` is consulted, so the gating is functionally sound and the skip is a pure optimization, not a correctness dependency.

### 4. No other new defects — CONFIRMED

- All call sites of the two changed signatures are updated consistently; the sole non-test production caller is `handle_login` (`login.rs:627`). No orphaned/mismatched-arity callers.
- Documented residual (honest, not silently claimed closed): the probe deliberately does **not** check the Windows DPAPI-encrypted-file OAuth fallback. Rationale in the rustdoc: DPAPI writes only occur inside `store_oauth_tokens`, reached only via a successful login that also records `auth_method`, so a profile cannot simultaneously carry `auth_method: None` and DPAPI-only credentials. This is a plausible invariant, correctly scoped, and disclosed as an accepted narrower-than-total residual rather than hidden. Acceptable.
- Partial-namespaced-OAuth handling is consistent with `load_oauth_tokens`: probe's OAuth branch requires BOTH halves (`&&`), so a partial pair falls through — matching that a partial pair is unloadable on non-default profiles (and, for `"default"`, the legacy branch still catches an intact legacy pair, mirroring `load_oauth_tokens`'s partial-recovery path).
- Doc comments are accurate and thorough; they correctly describe the new predicate, the probe's scope, and the NEW-1 rationale.

---

## Empirical confirmation

Checked out `29912390` and ran `cargo test --lib auth`:

```
test result: ok. 238 passed; 0 failed; 46 ignored; 0 measured; 1121 filtered out
[exited with code 0]
```

All auth unit tests pass, including the new NEW-1 regression tests and the B-1 test.

---

## Finding table

| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| — | — | None. NEW-1 resolved; B-1 preserved; probe is existence-only, correctly scoped, and error-propagating; no UX/keychain-prompt regression on the switch path; all call sites consistent; residual (DPAPI) honestly documented. | Merge. |
