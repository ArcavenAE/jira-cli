## PR Review — cycle 2 (re-review after B1/B2 fixes)

**PR:** #755 — `feat(auth): per-profile API-token keychain storage (S-cycle3-percred-storage, BC-1.4.031)`
**Base:** `develop` · **Head:** `1c32e602bd87863656c00cfbe7f17ce943d34c8d`
**Verdict: APPROVE** — both cycle-1 blocking findings are correctly and completely fixed. Three non-blocking items below (2 suggestions, 1 nit), all of them doc/consistency fallout from the fixes themselves.

---

### B1 — RESOLVED (verified)

`src/api/auth.rs::clear_all_credentials` now pushes `api_token_email_key(profile)` and
`api_token_key(profile)` inside the same per-profile loop that already pushed the OAuth pair:

```rust
for profile in profiles {
    keys.push(oauth_access_key(profile));
    keys.push(oauth_refresh_key(profile));
    keys.push(api_token_email_key(profile));
    keys.push(api_token_key(profile));
}
```

I verified this actually closes the gap, not just plausibly:

- **The keys match the writer.** `api_token_email_key` / `api_token_key` are the *same* two
  functions `store_api_token` writes through (`<profile>:email` / `<profile>:api-token`), so
  the delete set is exactly the write set — no third spelling to drift from.
- **Scope is right, not over-broad.** `refresh.rs` calls
  `clear_all_credentials(&[target.as_str()])` — a single-element slice — so
  `jr auth refresh --profile sandbox` deletes only `sandbox:email` / `sandbox:api-token`, never
  another profile's. The pre-existing `profiles.contains(&"default")` guard on the legacy flat
  OAuth keys is untouched.
- **Absence is not an error.** The shared delete loop treats `Err(keyring::Error::NoEntry)` as
  success, so adding these two keys for a profile that never used API-token auth (e.g. an
  OAuth-only profile listed in `profiles`) is a no-op rather than a spurious aggregated failure.
  This matters because the same loop's failures are surfaced to the user as
  `failed to clear N keychain entries`.
- **The claim `auth refresh` makes is now true.** `refresh.rs`'s `AuthFlow::Token` arm wipes then
  re-prompts; before the fix the wipe missed the only credential that path rotates, so the
  "#207-style wipe-then-relogin" it advertised was not happening. It is now.

The `refresh.rs` comment above the `match flow` block was correspondingly rewritten and is
accurate on every clause I checked: it no longer lists `email`/`api-token` among the shared keys
(they are namespaced now), it names the namespaced keys explicitly, and it correctly states the
flat-key deletes are retained.

### B2 — RESOLVED (verified accurate, not just reworded)

The CHANGELOG entry no longer contradicts itself. It now leads with
`**BREAKING — Action required on upgrade`, states plainly that *every* profile that authenticated
with an API token — explicitly including single-profile `"default"` users — must re-run
`jr auth login` once, and gives the reason (no migration, no legacy-key fallback for any profile).
I checked each factual claim against the code rather than accepting the prose:

- "not migrated or read" — correct: `load_api_token` reads only the two namespaced keys and has
  no `"default"` special case, unlike `load_oauth_tokens`. Pinned by
  `load_api_token_default_profile_has_no_legacy_fallback`.
- "the next command using that profile's API-token auth will fail" — correct:
  `src/api/client.rs`'s `_ => { load_api_token(profile_name)? }` arm is the auth-header path for
  every `api_token` profile, so the failure is at first API call, as described.
- The blast radius now matches the PR body's own Blast Radius section, which was the specific
  contradiction in cycle 1.

### Nothing new broken

- `cargo fmt --all -- --check`: clean. `cargo clippy --all-targets --all-features -- -D warnings`:
  clean.
- `cargo test --lib`: 1242 passed, 0 failed. `--test api_token_percred_wiring`,
  `--test auth_profiles`: 46 passed, 0 failed.
- Gated keyring suite actually exercised, not just skipped:
  `JR_RUN_KEYRING_TESTS=1 cargo test --lib auth:: -- --include-ignored` → 111 passed, 0 failed,
  0 ignored — including `store_and_load_per_profile_api_token_round_trip`,
  `load_api_token_cross_profile_isolation`, `store_api_token_overwrites_unconditionally`, and
  `prop_bc_1_4_031_round_trip_and_cross_profile_isolation`. `with_test_keyring`'s teardown calls
  `clear_all_credentials(&["default", "sandbox"])`, so these ran *through* the changed function
  and did not regress.
- CI on `1c32e602`: Clippy (ubuntu + windows), Format, MSRV 1.85.0, Deny, Spec Guards, Mutation
  testing, gitleaks, signing-injection guard, dependency-review all pass; the three `Test` legs and
  `Coverage` were still queued at review time — `ci-gate` is the required check and will gate them.
- No behavioral surface outside the two fixes changed: `1c32e602` touches CHANGELOG.md only, and
  `e560d598` touches `src/api/auth.rs` (+8/-1) and `src/cli/auth/refresh.rs` (comment only, plus
  no logic).

---

## Findings (all non-blocking)

### S4 — stale comment now asserts a property the code no longer has

| Field | Value |
|---|---|
| Severity | suggestion |
| Category | coherence |
| Location | `src/api/auth.rs::cleanup_api_token_profile` (doc comment) |

The helper's doc comment still says:

> `clear_all_credentials` (used by `with_test_keyring`'s own cleanup) **does not yet clear these
> namespaced keys** — flagged for the implementer/follow-on story — so api-token round-trip tests
> clean up after themselves explicitly…

As of `e560d598` that is false: `clear_all_credentials` *does* clear them, which is precisely
B1's fix. This is worse than ordinary comment rot — it is a comment telling the next reader that a
gap exists, pointing them at a follow-on story to close it, when the gap is closed. In a repo whose
CLAUDE.md treats "a name asserting a guarantee its body doesn't check is a defect, not a style
deviation" as policy, this deserves the same treatment.

**Suggestion:** delete `cleanup_api_token_profile` and its call sites (its work is now subsumed by
`with_test_keyring`'s teardown, and keeping it is harmless-but-redundant), or, if you prefer
belt-and-braces cleanup independent of `clear_all_credentials`, keep the helper and rewrite the
comment to say so — e.g. "redundant with `with_test_keyring`'s `clear_all_credentials` teardown as
of S-cycle3-percred-storage; retained as a local guarantee so these tests do not depend on that
function's key list." Either is fine; the current text is the one thing that isn't.

### S5 — `clear_all_credentials` rustdoc no longer describes what the function deletes

| Field | Value |
|---|---|
| Severity | suggestion |
| Category | coherence |
| Location | `src/api/auth.rs::clear_all_credentials` (doc comment) |

The rustdoc summary still enumerates the old key taxonomy:

> Always clears the shared / single-tenant keys (`email`, `api-token`, `oauth_client_id`,
> `oauth_client_secret`) plus the legacy flat OAuth keys. **Per-profile OAuth tokens
> (`<profile>:oauth-*-token`) are cleared only for the profiles in `profiles`** …

Two things are now off: `email`/`api-token` are no longer "shared / single-tenant" in this
codebase (they are the *legacy flat* pair — the doc's own terminology for the OAuth equivalent),
and the per-profile sentence lists only the OAuth pair when the loop now also deletes
`<profile>:email` / `<profile>:api-token`. The new inline comment inside the loop is accurate, but
a caller reading only the signature and rustdoc — the normal way this function is consumed — gets
an incomplete picture of a destructive operation.

**Suggestion:**

```rust
/// Always clears the account-level shared keys (`oauth_client_id`,
/// `oauth_client_secret`) and the legacy flat `email` / `api-token` pair,
/// plus the legacy flat OAuth keys when `profiles` contains `"default"`.
/// Per-profile credentials — `<profile>:oauth-access-token`,
/// `<profile>:oauth-refresh-token`, `<profile>:email`, `<profile>:api-token`
/// — are cleared only for the profiles in `profiles`.
```

### S6 — B1's fix has no regression test

| Field | Value |
|---|---|
| Severity | suggestion |
| Category | coverage |
| Location | `src/api/auth.rs` (gated keyring tests) |

`e560d598` adds four lines of deletion behavior and no test. The existing gated tests exercise the
changed function only incidentally, as teardown, where a missed delete is invisible (the per-test
unique `JR_SERVICE_NAME` namespace means orphaned entries never fail anything). So the specific
regression cycle 1 caught — the api-token keys silently dropping out of the delete set — would
still not be caught by the suite today; removing those four lines leaves every test green.

**Suggestion:** one gated test alongside the existing round-trip pair, e.g.

```rust
#[test]
#[ignore = "requires keyring backend; set JR_RUN_KEYRING_TESTS=1 to run"]
fn clear_all_credentials_clears_namespaced_api_token_keys() {
    with_test_keyring(|| {
        store_api_token("sandbox", "s@example.com", "tok").unwrap();
        assert!(load_api_token("sandbox").is_ok());
        clear_all_credentials(&["sandbox"]).unwrap();
        assert!(load_api_token("sandbox").is_err(), "…must clear <profile>:email/<profile>:api-token");
    });
}
```

Worth pairing with a cross-profile negative (`clear_all_credentials(&["sandbox"])` leaves
`default:api-token` intact) since that scope property is the part a future refactor is most likely
to break quietly.

### N3 — the S3 fix makes the command hint unpasteable in the common case (my cycle-1 nit was wrong)

| Field | Value |
|---|---|
| Severity | nit |
| Category | coherence |
| Location | `src/api/auth.rs::load_api_token` |

This one is on me — the fix implements exactly what I suggested in cycle 1, and the suggestion was
the wrong call. The hint is now:

```rust
"No stored API token for profile {profile:?} — \
 run \"jr auth login --profile {profile:?}\""
```

which for the overwhelmingly common profile renders as:

```
No stored API token for profile "default" — run "jr auth login --profile "default""
```

Three signals that the bare form was right in the command half:

1. **The sibling message 40 lines up does it the other way**, and deliberately: `load_oauth_tokens`'
   partial-state error uses `{profile:?}` in the prose and bare `{profile}` in both
   `jr auth logout --profile {profile}` / `jr auth login --profile {profile}` hints. The house
   pattern is *quote the prose reference, leave the command runnable* — this PR is now the only
   place that deviates.
2. **This PR's own CHANGELOG disagrees with this PR's own code.** Line 22 quotes the error as
   `run "jr auth login --profile <name>"` — unquoted. `1c32e602` (CHANGELOG) landed *after*
   `e560d598` (the string change), so the user-facing changelog now advertises a message the binary
   does not emit.
3. The nested quotes read as broken output to a user, and buy nothing: a profile name with a space
   is already impossible — `config::validate_profile_name` rejects it before this code path is
   reachable — so the case I was guarding against cannot occur.

**Suggestion:** revert the hint half to bare `{profile}`, keeping `{profile:?}` in the prose clause,
which restores parity with `load_oauth_tokens` and makes the CHANGELOG accurate as written:

```rust
"No stored API token for profile {profile:?} — \
 run \"jr auth login --profile {profile}\""
```

---

## Carried forward from cycle 1

- **W1 (auth remove/logout orphans namespaced credentials)** — still deferred, and I agree it
  should be. Worth noting the deferral is now *documented in the tree*, which is the right place
  for it: the new CLAUDE.md bullet states plainly that `auth logout`/`auth remove`
  (`clear_profile_creds`) do not yet clear the per-profile `email`/`api-token` keys and names
  S-cycle3-remove-logout-semantics (Wave 3) as the owner. I re-read `clear_profile_creds` and
  confirmed that note is accurate. One observation for that story rather than this one: after B1,
  `auth refresh` and `auth logout` are now *asymmetric* on the same credential — refresh clears the
  namespaced pair, logout does not. That asymmetry is a fine intermediate state given it is
  written down, but it is the kind of thing that reads as a bug to whoever finds it without the
  note, so closing it in Wave 3 rather than later has some value.
- **S1, S2, N1, N2** — not addressed; correctly classified as non-blocking in cycle 1 and not
  re-raised. Note N1 (hand-rolled gated-test cleanup) has effectively become S4 above, since B1's
  fix turned the redundancy into an incorrect comment.

---

## Summary

| ID | Severity | Category | Finding |
|---|---|---|---|
| B1 | — | — | RESOLVED — namespaced api-token keys now in `clear_all_credentials`' per-profile loop; scope, key spelling, and `NoEntry` handling all verified correct. |
| B2 | — | — | RESOLVED — CHANGELOG now BREAKING/action-required, internally consistent, and every factual claim checked against the code. |
| S4 | suggestion | coherence | `cleanup_api_token_profile` comment still claims `clear_all_credentials` doesn't clear these keys — now false. |
| S5 | suggestion | coherence | `clear_all_credentials` rustdoc doesn't list the per-profile api-token keys it now deletes. |
| S6 | suggestion | coverage | No regression test for B1's fix; deleting the four new lines leaves the suite green. |
| N3 | nit | coherence | `{profile:?}` in the command hint yields nested quotes; diverges from `load_oauth_tokens` and from this PR's own CHANGELOG. My cycle-1 suggestion was wrong. |

APPROVE. No blocking findings. S4/S5/S6/N3 are all doc-and-test fallout from the fixes and can land
in this PR or a follow-up; none of them affects the shipped behavior BC-1.4.031 specifies.

**READY** · `covered_sha: 1c32e602bd87863656c00cfbe7f17ce943d34c8d`
