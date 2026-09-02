# PR Review — #755 (S-cycle3-percred-storage, BC-1.4.031)

**Verdict: REQUEST_CHANGES** — 2 blocking, 1 warning, 3 suggestions, 2 nits.
Reviewed at HEAD `fc8acc2da9b097d3cf2741ad00ffbbcb5a06668e` (4 commits, 8 files, +642/-21).

The core mechanism is right. `store_api_token`/`load_api_token` are a faithful mirror of the
OAuth pair, `read_keyring_optional` is reused rather than re-implemented (so a real backend
error propagates via `?` before the generic absent-credential message — the invariant this
story exists to hold), and I could not construct a cross-profile collision or find a
credential value in any log, error, or serialization path in the diff.

What blocks merge is not the new functions — it is the **third** call site that still points
at the old flat keys and now silently does nothing, plus a CHANGELOG line that tells users the
opposite of what will happen to them on upgrade.

---

## BLOCKING

### B1 — `jr auth refresh` (api_token flow) no longer clears the credential it reports clearing

| Field | Value |
|---|---|
| Severity | **blocking** |
| Category | missing / correctness / security-adjacent |
| Location | `src/cli/auth/refresh.rs` (`AuthFlow::Token` arm) + `src/api/auth.rs::clear_all_credentials` — neither touched by this PR |

`refresh.rs` clears credentials before re-login:

```rust
AuthFlow::Token => auth::clear_all_credentials(&[target.as_str()]).context(
    "failed to clear stored credentials before refresh — keychain may still hold stale entries",
)?,
```

`clear_all_credentials` deletes exactly `email`, `api-token`, `oauth_client_id`,
`oauth_client_secret`, the legacy flat OAuth pair (when `"default"` is listed), and
`<profile>:oauth-*-token`. It does **not** delete `<profile>:email` / `<profile>:api-token` —
which, as of this PR, is where the live credential actually lives. Every delete in that call
is now a `NoEntry` no-op that the function reports as success.

Three consequences, in ascending order of seriousness:

1. The load-bearing comment immediately above that arm is now false:
   *"the shared api-token IS the credential being refreshed — so the #207-style
   wipe-then-relogin path is correct here."* It is no longer the credential being refreshed.
2. On the login-failure path the user is told
   `"Credentials were cleared, but the login flow did not complete. Run \`jr auth login\` to
   restore access."` — but the old credential is fully intact and still authenticates. A user
   who aborts an interactive refresh (Ctrl-C at the token prompt) reasonably believes the local
   copy of their API token was removed. It was not.
3. `clear_profile_creds` (used by `auth logout` and `auth remove`) never cleared the API-token
   pair either. So as of this PR **no `jr` command deletes a per-profile API token from the
   keychain.** `refresh` was the only path that ever did, and this change removes it without
   naming it. (Yes, clearing the keychain never revoked the token at Atlassian — the impact is
   local credential hygiene plus a false claim in the UI, not remote revocation.)

The PR's out-of-scope list names `auth remove` and `auth logout`. It does not name
`auth refresh`, and the CLAUDE.md deferral note added in commit 4 doesn't either — so this is
an undeclared gap, not an accepted one.

**Suggestion — smallest correct fix (preferred), in `src/api/auth.rs::clear_all_credentials`:**

```rust
for profile in profiles {
    keys.push(oauth_access_key(profile));
    keys.push(oauth_refresh_key(profile));
    // S-cycle3-percred-storage: the API-token pair moved to namespaced keys,
    // so the flat KEY_EMAIL/KEY_API_TOKEN deletes above no longer reach the
    // credential `auth refresh` is rotating.
    keys.push(api_token_email_key(profile));
    keys.push(api_token_key(profile));
}
```

That is the correct scope for *this* story — this is the story that moved the keys, and it is
four lines inside a function whose whole job is "delete the credentials for these profiles."
It also retires the hand-rolled `cleanup_api_token_profile` helper in the new tests (see N1).

**If the team insists on deferring the behavior to `S-cycle3-remove-logout-semantics`**, then
the minimum that must still land in this PR is: correct the now-false comment in `refresh.rs`,
correct or condition the `"Credentials were cleared"` message so it does not assert something
untrue, and add `auth refresh` to the deferral list in the PR body, CHANGELOG, and CLAUDE.md.
Shipping a message that tells the user their credential was removed when it wasn't is the part
that must not merge as-is.

### B2 — CHANGELOG states the opposite of the actual upgrade experience

| Field | Value |
|---|---|
| Severity | **blocking** |
| Category | description |
| Location | `CHANGELOG.md`, `[Unreleased] > Changed` (commit `fc8acc2d`) |

The entry reads:

> …it lands the new storage/read paths (`store_api_token` / `load_api_token`) **without yet
> changing user-visible behavior**; there is no legacy-key fallback for any profile, including
> `"default"`.

The two halves contradict each other, and the first half is the one users will read. API token
is the default auth method. Every existing API-token user — including every single-profile
`"default"` user — has their credential under the flat keys, gets no fallback, and on the very
next command after upgrading hits
`No stored API token for profile "default" — run "jr auth login --profile default"`. That is a
forced re-login for the majority auth path, delivered by a release note that says user-visible
behavior did not change.

The PR body's own Blast Radius section states this correctly ("would need to re-run `jr auth
login` once"). The CHANGELOG needs to say the same thing, and the entry should carry a breaking
/ action-required marker rather than sitting unqualified under `### Changed`.

**Suggestion:** replace the "without yet changing user-visible behavior" clause with something
like: *"**Action required on upgrade:** profiles that authenticated with an API token before
this release must re-run `jr auth login [--profile <NAME>]` once — existing credentials under
the old flat `email`/`api-token` keys are not migrated or read (no legacy fallback for any
profile, including `default`). The detect-and-instruct guidance for this case lands with
S-cycle3-credential-absence-guard."*

---

## WARNING

### W1 — `auth remove` orphans the removed profile's credentials, and removes the config that could find them later

| Field | Value |
|---|---|
| Severity | suggestion (warning) |
| Category | coherence / security hygiene |
| Location | `src/cli/auth/remove.rs` → `clear_profile_creds` |

Declared out of scope and documented in CLAUDE.md, so I am not blocking on it — but the
ordering matters for the follow-on story and is worth capturing now: `jr auth remove sandbox`
deletes the `[profiles.sandbox]` config entry while `sandbox:email` / `sandbox:api-token`
remain in the keychain. Once the config entry is gone, `S-cycle3-remove-logout-semantics` can
no longer enumerate that profile from config to clean it up — the orphan is unreachable by name
unless the user remembers it. Consider having `remove` clear credentials *before* deleting the
config entry, or have the follow-on story handle recovery for profiles removed in this window.

---

## SUGGESTIONS

### S1 — `auth status` collapses the backend-error/absent distinction this story just built

| Field | Value |
|---|---|
| Severity | suggestion |
| Category | coherence |
| Location | `src/cli/auth/status.rs:144` |

```rust
_ => auth::load_api_token(&target).is_ok(),
```

`.is_ok()` maps a genuine keychain backend failure (locked keyring, permission denied,
EC-1.4.031-2) to `Credentials: not found` — exactly the coercion `read_keyring_optional` exists
to prevent, at the one surface where a user would go to diagnose it. The pattern predates this
PR (the old call was `load_api_token().is_ok()`) and the OAuth arm above has it too, so this is
not a regression — but this story is *about* that distinction, and `auth status` is the natural
place to honor it. Consider `match … { Ok(_) => "stored in keychain", Err(e) if is_absent(e)
=> "not found", Err(e) => "error reading keychain: {e}" }` here or in the follow-on
credential-absence-guard story.

### S2 — partial-write state is reachable and reported as "no credential"

| Field | Value |
|---|---|
| Severity | suggestion |
| Category | coverage |
| Location | `src/api/auth.rs::store_api_token` / `load_api_token` |

`store_api_token` does two independent `set_password` calls; a failure between them leaves
`<profile>:email` written and `<profile>:api-token` absent. `load_api_token`'s `_ =>` arm then
reports `No stored API token for profile "X"`, which is misleading for a half-written state
(the user's next `auth login` does repair it, so this is cosmetic). The rustdoc already
reasons about this and calls the unconditional overwrite the recovery mechanism — that's a
defensible choice. Worth either distinguishing the partial case in the message, or stating in
the rustdoc that partial state is deliberately reported as absent.

### S3 — error hint is not shell-safe for unusual profile names

| Field | Value |
|---|---|
| Severity | nit |
| Category | coherence |
| Location | `src/api/auth.rs::load_api_token` |

`run "jr auth login --profile {profile}"` — the profile is `{:?}`-quoted in the first half of
the message but bare in the hint, so a profile name containing a space yields a hint that
cannot be pasted. Low impact; `{profile:?}` in the hint too would be consistent with the
message's own first clause.

---

## NITS

### N1 — gated tests hand-roll cleanup that belongs in the shared harness

`with_test_keyring`'s trailing `clear_all_credentials(&["default", "sandbox"])` does not reach
the new namespaced keys, so each new gated test calls `cleanup_api_token_profile` as its last
statement. A test that panics on an assertion before reaching that line leaves entries behind
(under a throwaway service name, so impact is limited to keychain clutter on the developer's
machine); the proptest's generated `p1` is likewise only cleaned on the success path. The
test comment honestly flags this and points at the implementer/follow-on story — and B1's fix
to `clear_all_credentials` makes the whole helper unnecessary, which is a nice tell that B1's
fix is in the right place.

### N2 — diff size and demo evidence

663 lines changed, over the 500-line review threshold — but 514 of that is the test suite
(`src/api/auth.rs` tests + the new `tests/api_token_percred_wiring.rs`), and the production
delta is ~40 lines. Reasonable.

On demo evidence: `docs/demo-evidence/` does not exist anywhere in this repository, so the
absence here is consistent with repo convention rather than a lapse by this story, and the
change has no new user-facing command surface to record. The gated-keychain test transcript
against the real macOS Keychain backend is the appropriate evidence for a keychain-storage
change. Noted, not blocking.

---

## What I verified (no issues found)

- **The rename broke nothing.** Grepped `src/` and `tests/` for all four function names: the
  only remaining references to `load_legacy_flat_api_token` / `store_legacy_flat_api_token`
  are inside the new `tests/api_token_percred_wiring.rs` (deliberately, to prove the negative).
  No production code still reads a flat key that nothing writes. All three real call sites
  (`client.rs::load_auth_from_keychain`, `login.rs::login_token`, `status.rs::status`) were
  switched. CI's compile of a signature-changing rename independently confirms no call site
  was missed. **The one thing the rename did miss is B1 — a call site that references the
  *keys*, not the functions, so the compiler could not catch it.**
- **Backend-error vs. absent-key.** `load_api_token` routes both reads through
  `read_keyring_optional`, which maps only `keyring::Error::NoEntry` to `Ok(None)` and returns
  everything else as `Err`. Both `?`s fire before the generic message is constructed, and
  `entry()` construction errors propagate too. `load_api_token_propagates_backend_error_not_absent_message`
  exercises this deterministically via an empty `JR_SERVICE_NAME` rather than OS fault
  injection — a portable choice, and the assertion is on the absence of the absent-message
  rather than on a brittle exact string.
- **Write/read namespace symmetry.** `handle_login` targets
  `args.profile.unwrap_or(&config.active_profile_name)`; `from_config` reads
  `config.active_profile_name`. Same key on both sides under `--profile`, `JR_PROFILE`,
  `default_profile`, and the `"default"` fallback — no path where login writes one namespace
  and the client reads another.
- **Cross-profile isolation / collision.** The suffix set is closed
  (`email`, `api-token`, `oauth-access-token`, `oauth-refresh-token`) and profile-first, so no
  profile name — including one containing a colon, e.g. `a:b` → `a:b:email` — can produce a key
  that collides with another profile's key or with a flat key (flat keys contain no colon).
  Covered directly by `test_bc_1_4_031_api_token_keys_distinct_across_profiles` and by
  VP-AUTHDX-004's isolation property.
- **No credential leakage.** No `email`/`token` value appears in any `println!`, `eprintln!`,
  error string, or serialization in the diff; the new error echoes only the profile name.
  Test fixtures use obvious placeholders.
- **AC-004 holds.** `store_oauth_app_credentials` / `load_oauth_app_credentials` and the
  `oauth_client_id` / `oauth_client_secret` keys are untouched.
- **CI at review time:** 12 checks green (Format, both Clippy legs, MSRV 1.85.0, Deny, Coverage,
  Mutation testing, Spec Guards, gitleaks, dependency-review, Test ubuntu); Test macOS and Test
  windows still pending. `ci-gate` had not reported yet.

---

## Summary

| # | Severity | Category | Finding |
|---|---|---|---|
| B1 | blocking | missing / security-adjacent | `auth refresh` (token flow) clears flat keys that are no longer used; claims "Credentials were cleared" while the live credential survives. No `jr` command now deletes a per-profile API token. Undeclared scope gap. |
| B2 | blocking | description | CHANGELOG says "without yet changing user-visible behavior" — every existing API-token user is forced to re-login on upgrade. |
| W1 | suggestion | coherence | `auth remove` orphans namespaced credentials and deletes the config entry that could later locate them. |
| S1 | suggestion | coherence | `auth status`'s `.is_ok()` collapses EC-1.4.031-2 backend errors into "not found". |
| S2 | suggestion | coverage | Partial-write state reported as absent; document or distinguish. |
| S3 | nit | coherence | `--profile {profile}` hint unquoted for names with spaces. |
| N1 | nit | coverage | Gated-test cleanup hand-rolled; subsumed by B1's fix. |
| N2 | nit | size | 663 lines (514 tests); no demo evidence, consistent with repo convention. |

B1 and B2 are both small, contained fixes. Re-request review once they land.
