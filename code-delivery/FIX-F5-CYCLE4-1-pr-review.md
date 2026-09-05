# PR #773 Review — FIX-F5-CYCLE4-1 (cycle-004 F5 scoped adversarial LOW fixes)

**Branch:** `fix/cycle4-f5-low` @ `2644a110` (3 commits on `e5a18fe0`)
**Reviewer:** fresh-context, independent (did not trust implementer self-report)
**Verdict:** ✅ **CLEAN — merge-ready.** No BLOCKING or WARNING findings. Three NITs (non-blocking).

Delta: `CHANGELOG.md`, `src/api/auth.rs`, `src/api/auth_windows_store.rs`, `src/cli/auth/login.rs`, `src/cli/auth/mod.rs`, `src/cli/auth/tests/mod.rs`, `tests/auth_oauth_default_creation.rs`. 684 insertions, no unrelated changes — no scope creep beyond the 3 findings.

---

## LOW-1 — credential-orphan on legacy-`None` mechanism switch (SECURITY-CRITICAL) — CORRECT

Traced control flow in `handle_login` (`src/cli/auth/login.rs`) directly, not test names:

1. `legacy_none_stored_kind` probed **once** via `probe_stored_credential_kind`, only when `current_auth_method.is_none()` (else `None`). No double keychain I/O / no double OS prompt.
2. `has_stored_credentials = legacy_none_stored_kind.is_some()` — **byte-for-byte identical** to the prior `profile_has_stored_credentials(...)` call: `probe_stored_credential_kind` checks in the exact same order (namespaced OAuth → namespaced api-token → default-only legacy flat OAuth) and `profile_has_stored_credentials` is now literally `Ok(probe(...)?.is_some())`. **NEW-1 pre-mark logic is not regressed.**
3. `login_oauth/login_token(...).await?` — a failed login early-returns via `?`; steps 4–5 are unreachable on failure.
4. `clear_outgoing_mechanism_on_switch(...)` — early-returns for `current_auth_method == None` (the legacy case) by design.
5. `reconcile_legacy_none_outgoing_credentials(profile, legacy_none_stored_kind, new_method)` — the new POST-login half.

`reconcile_...` verified:
- **Never clears the wrong / new creds.** It only clears when `outgoing != new_method`. `clear_profile_oauth_pair` clears only OAuth keys (+ legacy-flat for `"default"` + the DPAPI oauth-tokens file); `clear_profile_api_token_pair` clears only the namespaced email/api-token pair. The just-stored new-method creds are of `new_method` kind, which by definition differs from the cleared `outgoing` kind → new creds are never touched. Confirmed against both primitives in `src/api/auth.rs`.
- **Current target profile only** — `profile` is always `Profile::from(target.clone())`; no cross-profile clearing.
- **Fires only after login succeeds** — guaranteed by construction (sits after the login `?` and after `clear_outgoing_...?`), not merely by test naming.
- **No-op** when probed kind is `None` (brand-new) and when `outgoing == new_method` (same-kind re-declaration).
- **Legacy-flat-OAuth edge fully handled:** probe reports `Some("oauth")` off the legacy flat keys for `"default"`, and `clear_profile_oauth_pair` clears the legacy flat pair too — no partial orphan left.
- Literals are consistent end-to-end: probe returns `&'static "oauth"/"api_token"`, `new_method` is `"oauth"/"api_token"`, `clear_stored_credential_kind` matches the same two, unrecognized → `Ok(())` no-op.

`clear_stored_credential_kind` DRY extraction: legitimate, in-scope, shared by both `clear_outgoing_mechanism_on_switch` and `reconcile_...` so the two dispatch tables cannot drift. Behavior of `clear_outgoing_mechanism_on_switch` unchanged.

Visibility: `reconcile_legacy_none_outgoing_credentials` is correctly `pub(crate)` (re-exported under `#[cfg(test)]` in `mod.rs` for inline tests; called from same-crate login.rs).

**Tests exercise the fix (not vacuous):**
- Pure branch tests (`src/cli/auth/tests/mod.rs`, run in CI) cover the two keychain-free branches (`None`, same-kind) — both pass locally.
- Keyring-gated e2e (`tests/auth_oauth_default_creation.rs`, `#[ignore]` + `JR_RUN_KEYRING_TESTS=1`, per repo convention → **not run in CI**): the orphan-clear reproduction seeds OAuth, logs in `--api-token`, and asserts the new api-token pair is stored **and** `load_oauth_tokens` now errs (orphan cleared) — a genuine RED→GREEN. Compiled clean locally; not executed against a live keyring to avoid a macOS keychain prompt.

## LOW-2 — `normalize_for_phrase_scan` strips `///`, `//!`, `//` — CORRECT

- Longest-match ordering verified: `["///", "//!", "//"].iter().find_map(strip_prefix)` returns the FIRST `Some`, so `///` is tried before `//!` before bare `//` — a genuine `///` line is never mis-stripped to a bare `/`.
- RED→GREEN confirmed by logic and by running: pre-fix keeps the un-stripped `//!`/`//` marker sitting between the phrase halves after line-join (`"...has no //! other consumer..."`), so `.contains("no other consumer")` misses; post-fix strips it and matches. Both new self-tests pass locally; the older `///` and backslash-continuation tests still pass.
- The real production guard `test_no_account_wide_harmful_revoke_framing_in_auth_source` still passes locally — broadening the stripper only strengthens detection, no false positive introduced.

## LOW-3 — `fsync_parent_dir_best_effort` after rename — CORRECT

- **Best-effort / model-b:** returns `()`, swallows all errors (`if let Ok(dir_handle) = File::open(dir) { let _ = dir_handle.sync_all(); }`). Never fails `atomic_write`. Matches the `src/cache.rs` cache-write convention it cites.
- **No broken build:** `fsync_parent_dir_best_effort`, `atomic_write`, and `cleanup_stale_tmp_siblings` all share the identical `#[cfg(any(windows, test))]` gate, so the unconditional call site inside `atomic_write` is always compiled alongside the callee. Verified the cfg attributes directly (lines 376 / 418).
- **Honest doc:** the softened `atomic_write` rustdoc now states durability is best-effort (not a proven cross-platform guarantee), a documented silent no-op on Windows (`File::open` on a directory fails there), with `jr auth login` as the recovery path.
- **Corruption/envelope guards intact:** `load_pair` and the deserialize-failure-as-missing handling are untouched; the added step runs only after `rename` has already completed and cannot corrupt already-written bytes.
- Round-trip + best-effort tests pass locally.

---

## NITs (non-blocking)

- **NIT-1:** `probe_stored_credential_kind` is declared `pub` but has only same-crate callers (`auth.rs` internal + `login.rs`); `pub(crate)` would be tighter. Defensible as consistent with `auth.rs`'s pervasive `pub` convention (the module exposes its surface for `tests/` integration crates), so this is style, not a leak.
- **NIT-2:** `profile_has_stored_credentials` now has **zero live call sites** (only its own body + doc references) — the PR moved login.rs to `probe_stored_credential_kind`. Retained as a thin `Ok(probe(...)?.is_some())` wrapper. Not flagged by clippy (pub items are exempt from dead-code lint). Kept presumably for API stability / to document the relationship; consider removing in a later cleanup if no external consumer needs it.
- **NIT-3:** The LOW-1 failed-login guard test seeds an **OAuth** pair and attempts a failing **OAuth** login (same kind) — so its OAuth-preservation assertion would also hold even if `reconcile_...` had run (same-kind → no-op). It is a valid regression pin (and additionally asserts `auth_method` was not written), but does not *uniquely* isolate "reconcile never runs on a failed DIFFERENT-mechanism login." That safety is nonetheless guaranteed by construction (the login `?` early-return). Could be strengthened by seeding api-token + attempting a failing OAuth login.

## Compliance
- No let-chains, no `#[allow]`, no MSRV-risky constructs in the delta.
- CHANGELOG accurate and complete for all three findings, placed under `[Unreleased]`.

## CI status (headRefOid `2644a110`)
- `mergeable: MERGEABLE`, `mergeStateStatus: BLOCKED`.
- All checks **pass** except **Test (windows-latest)** still **pending** at review time: Clippy (ubuntu+windows), Coverage, Deny, Format, MSRV, Mutation testing, Secret Scan, Signing Workflow Injection Guard, Spec Guards, Test (macos + ubuntu), dependency-review — all pass. BLOCKED is attributable to the pending Windows Test job (and/or required review approval).
