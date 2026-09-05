---
review_type: security
scope: PR #771 fix-delta re-review (fresh context)
component: auth/credential module (src/api/auth.rs, src/cli/auth/{login,logout,mod}.rs)
baseline_commit: b2a0c5d7
head_commit: 17dcccb7
diff_command: git diff b2a0c5d7..origin/feat/cycle4-honest-fail-message
total_findings: 0
critical: 0
high: 0
medium: 0
low: 0
verdict: MERGE-CLEAR
---

# PR #771 Fix-Delta Security Re-Review (fresh context, independent)

## Scope

Reviewed `git diff b2a0c5d7..origin/feat/cycle4-honest-fail-message` (4 commits:
`3761b38c`, `f8ca6ac9`, `7630eb4d`, `17dcccb7`) touching:

- `src/api/auth.rs` — `site1_login_store_failure_message` / `site3_refresh_store_failure_message`
  wording corrections; new `normalize_for_phrase_scan` test helper + 2 tests hardening the
  DEC-334 source-scan regression guard.
- `src/cli/auth/login.rs` — new `should_mark_auth_method_before_attempt` /
  `mark_auth_method_if_new`, wired into `handle_login` to persist `auth_method` before the
  credential flow for brand-new profiles.
- `src/cli/auth/logout.rs` — `auth_method_is_api_token` extracted as a standalone pure
  predicate (no behavior change).
- `src/cli/auth/mod.rs` — re-exports for the above under `#[cfg(test)]`.
- `src/cli/auth/tests/mod.rs` — 8 new tests exercising the routing decisions end-to-end.
- `CHANGELOG.md` / `CLAUDE.md` — documentation of the above.

Did **not** re-trust the implementer's self-report. Independently read the full diff, the
surrounding non-diffed code each new line depends on (`prepare_login_target`,
`handle_remove_in_memory`, `JiraClient::from_config`/`load_auth_from_keychain`,
`DpapiFallbackFailed`'s construction sites, the pre-existing Site-3 `clear_profile_oauth_pair`
call site), and independently ran the relevant test scope in the actual PR worktree
(`.worktrees/S-cycle4-honest-fail-message`, HEAD `17dcccb7`) rather than reading test names only:

```
cargo test --lib auth::                        # 145 passed, 0 failed
cargo test --lib -- b1_brand_new mark_auth_method_if_new \
    auth_method_is_api_token honest_fail normalize_for_phrase_scan   # 18 passed, 0 failed
```

## Verdict: MERGE-CLEAR

No CRITICAL, HIGH, MEDIUM, or LOW security findings identified in this delta. One
non-security correctness/UX observation is recorded below for completeness (not a CWE-
classified finding, not blocking).

## Analysis by review question

### 1. Can pre-persisting `auth_method` before the flow leave a profile marked with a
mechanism but no valid credentials, in a way that's exploitable / causes credential
confusion / misroutes `logout`/`remove`/`refresh`?

Confirmed via code + tests that the write is:

- **Scoped to the no-prior-method case only.** `should_mark_auth_method_before_attempt`
  returns `true` iff `current_auth_method.is_none()`. A profile with an established,
  different (`switching == true`) or same mechanism is never touched here — verified by
  `mark_auth_method_if_new_leaves_switching_profile_untouched` and
  `should_mark_auth_method_before_attempt_false_when_switching_from_established_method`,
  and independently re-derived from the `switching` computation at
  `login.rs:handle_login` (unchanged by this delta).
- **Confined to the single target profile.** `mark_auth_method_if_new` mutates only
  `global.profiles.entry(target)`, keyed off the already-`validate_profile_name`'d
  `target` computed earlier by `prepare_login_target`. No cross-profile write path exists.
- **Fails safe when credential-less.** Traced both downstream consumers of a profile
  left with `auth_method: Some("oauth")` and zero stored tokens:
  - `JiraClient::from_config` → `load_auth_from_keychain("oauth", profile)` →
    `crate::api::auth::load_oauth_tokens` — this errors cleanly (NotFound) when no OAuth
    pair exists; it does not silently fall back to some other credential, and it does not
    read or expose any other profile's material.
  - `jr auth logout` → `auth_method_is_api_token(Some("oauth")) == false` → routes to the
    OAuth-clear branch, which calls `clear_profile_oauth_pair` — a delete of an
    already-absent (or partially-absent) keychain/DPAPI entry, tolerant of `NotFound`
    (pre-existing behavior, unchanged by this delta). It does not touch any other
    profile's credentials.
  - **Before** this fix, the same credential-less profile had `auth_method: None`, which
    `client.rs`'s `.unwrap_or("api_token")` and `logout.rs`'s `auth_method_is_api_token`
    both treat as an api-token profile — `load_api_token` then fails cleanly (NotFound)
    the same way. In both the pre-fix and post-fix state, an ordinary command against
    this broken profile fails with a clean "not authenticated" style error; the fix
    changes *which* clean error/routing path fires, not whether the failure is safe.
  - Net: no credential-over-deletion, no cross-profile leakage, no privilege escalation.
    Worst case is the SAME "recommended cleanup command still needs a second step" UX gap
    the PR is explicitly patching (see observation below), not a new exploitable state.
- **`jr auth remove`** is unaffected by `auth_method` at all — `handle_remove_in_memory`
  gates purely on `target == active` / `target == default_profile`, never on
  `auth_method`. This delta cannot cause `remove` to delete the wrong profile.
- **Site 3 (`refresh_oauth_token_with_url`)'s proactive `clear_profile_oauth_pair` call**
  on `DpapiFallbackFailed` is **pre-existing code, unchanged by this diff** (confirmed:
  identical in `b2a0c5d7`'s `src/api/auth.rs` at the same call site) — this PR only adds
  the CLAUDE.md prose documenting it (the "relogin-then-replace" exception paragraph in
  the diff, `17dcccb7`). It clears the profile identified by the `profile: &str` the
  refresh call itself already operates on (sourced from `self.profile_name` /
  `config.active_profile_name` at the one real call site in `client.rs`, not from any
  network response or attacker input), so there is no cross-profile or attacker-directed
  clear introduced or re-touched here.

**Conclusion: no exploitable state, no credential confusion, no misrouted deletion.**

### 2. Does persisting `auth_method` before the flow ever write attacker-influenced or
unvalidated data to config?

No. `new_method` is one of two hardcoded string literals (`"oauth"` / `"api_token"`)
selected by local CLI-flag/prompt logic (`args.oauth` / `args.api_token` / the
interactive picker) — never derived from network response, file content, or any
externally-supplied string. `target` (the profile name) is validated by
`crate::config::validate_profile_name` inside `prepare_login_target`, which runs and
returns successfully *before* the new pre-mark block is reached — so the pre-mark logic
never receives an unvalidated profile name. No new write path to `config.toml` bypasses
existing validation.

### 3. Do the corrected honest-fail messages leak secret/token material into
stderr/stdout/logs? (CWE-532)

No. Re-read both `site1_login_store_failure_message` and
`site3_refresh_store_failure_message` in full. The only interpolated dynamic values are:

- `{profile}` — the profile name (not a secret).
- `{inner}` — `DpapiFallbackFailed`'s wrapped string, traced to its two construction
  sites in `auth_windows_store.rs`: `format!("DPAPI protect failed: {e}")` and
  `format!("failed to write secret file: {e}")`, both wrapping OS/Windows-API error
  values (e.g., `std::io::Error`), never token/refresh-token/access-token content.
- `{e:#}` — the generic keychain-store error chain (`keyring::Error` etc.), same
  category — OS/backend error text, not the value that failed to store.

The wording changes in this delta only add/reword the cleanup-command guidance
(`jr auth logout`, the "if {profile} is not your active profile, jr auth remove..."
caveat) and correct the revoke-scope warning; they do not add any new interpolated
field. `DEC-334`'s revoke-URL / ACCOUNT-WIDE warning text is unchanged in substance
(still a link + a warning, no credential material). No new logging call sites were
added — `info!` in `refresh_oauth_token_with_url` (pre-existing, unchanged) explicitly
documents "refresh_token value is intentionally NOT logged — only the profile."
CWE-532 does not apply to this delta.

### 4. Does the Site-3 proactive-clear-on-`DpapiFallbackFailed` path (now documented in
CLAUDE.md) risk clearing the wrong profile or leaving a partial/split credential state?

The clear call itself is pre-existing and unchanged (see #1 above) — this PR only adds
documentation. Independently re-verified it operates on the correct, already-resolved
profile (no wrong-profile risk) and is `NotFound`-tolerant (`let _ = clear_profile_oauth_pair(...)`),
so it cannot itself produce a partial/split state worse than what `store_oauth_tokens`'s
own delete-first ordering (BC-1.4.035, also pre-existing) already guarantees: the pair is
always stored/cleared atomically as a unit, never split across keyring and DPAPI-file.
The CLAUDE.md addition in this delta (the "Narrow, documented exception" paragraph under
the S-cycle3-percred-storage bullet) accurately describes existing code — it does not
introduce new behavior to audit.

### 5. Any new path-traversal, injection, or credential-over-deletion in the delta?

None found. `mark_auth_method_if_new` performs a plain in-memory map mutation on an
already-validated key; no filesystem path is constructed from any new input in this
diff. `auth_method_is_api_token` is a pure `Option<&str>` comparison extracted verbatim
from existing inline logic (`p.auth_method.as_deref() != Some("oauth")` →
`auth_method_is_api_token(p.auth_method.as_deref())`) — behaviorally identical, confirmed
by reading both the old inline expression (still visible via `git show b2a0c5d7`) and the
new function body side by side. `handle_remove_in_memory` (the only deletion-gating logic
touched by this review's scope) is untouched by this diff.

### DEC-334 revoke-advice truthfulness

Re-confirmed the corrected wording present in both `site1_login_store_failure_message`
arms (`DpapiFallbackFailed` and legacy) states, verbatim: "this is ACCOUNT-WIDE and will
sign out every jr profile on this Atlassian account, each needing \"jr auth login\"
again" — consistent with `jr`'s single shared embedded OAuth app design (ADR-0006) and
non-harmful: it presents the revoke as an *optional* extra step, not a required
remediation, and correctly warns of the blast radius before the user acts. Site 3's
message correctly omits any revoke instruction entirely (a refresh-token failure does not
imply the grant is bad). The DEC-334 regression guard
(`test_no_account_wide_harmful_revoke_framing_in_auth_source`) was independently run and
passes, and the new `normalize_for_phrase_scan` line-wrap/continuation hardening
(`test_normalize_for_phrase_scan_catches_wrapped_forbidden_phrase`,
`test_normalize_for_phrase_scan_catches_backslash_continued_phrase`) is a genuine
strengthening of that guard, not cosmetic — verified by reading the normalization logic
itself (strips `///` prefixes and `\`-continuation markers, then collapses whitespace)
and confirming it would in fact have caught the DEC-334-era wrapped phrasing bug this
same file's rustdoc cites as its own motivating example.

## Non-security observation (not a CWE finding, not blocking)

**Message completeness gap in the "not your active profile" caveat.** The corrected
Site-1 messages say: *"if {profile} is not your active profile, `jr auth remove
{profile}` deletes it entirely."* But `handle_remove_in_memory` actually refuses removal
when `target == active` **OR** `target == default_profile` — two independent gates, not
one. `prepare_login_target` promotes a brand-new profile to `default_profile` whenever
`global.default_profile` was previously `None`, independent of whether that profile is
also the *active* one for this invocation. Concrete case where the message is
misleading: a genuinely fresh install (no `config.toml` yet) run as
`jr auth login --profile alpha --oauth`. Here `active_profile_name` resolves to the
literal fallback `"default"` (not `"alpha"`, since `--profile` here is the subcommand
flag, and no config existed to name an active profile), so `alpha != active` — the
message's stated condition holds — yet `alpha` *is* promoted to `default_profile` in the
same call (since none existed), so `jr auth remove alpha` is still refused by the
`target == default_profile` gate, contradicting what the message told the user to
expect. This does **not** rise to a security finding: `jr auth remove` fails safe (it
refuses and deletes nothing) rather than deleting the wrong profile, so there is no
credential-over-deletion, no exposure, and no crash — the user simply sees a second,
different error and must run `jr auth switch` first, as the refusal message itself
explains. Recommend a follow-up doc/wording fix (e.g., "if {profile} is not your active
profile **and not your default profile**") but this should not block merge on security
grounds.

## Independent verification performed

- Read full diff (`b2a0c5d7..origin/feat/cycle4-honest-fail-message`), 575 lines.
- Read non-diffed dependencies: `prepare_login_target`, `handle_remove_in_memory`,
  `JiraClient::from_config`/`load_auth_from_keychain`, `DpapiFallbackFailed`'s two
  construction sites in `auth_windows_store.rs`, the Site-3 `clear_profile_oauth_pair`
  call site and its callers in `client.rs`.
- Diffed `b2a0c5d7`'s `logout.rs`/`site1_login_store_failure_message` against the new
  versions line-by-line to confirm behavioral equivalence of refactors.
- Ran `cargo test --lib auth::` (145 passed) and a targeted subset covering every new
  function/test named in the diff (18 passed) in the PR's own worktree at HEAD
  `17dcccb7` — did not merely trust the implementer's stated test names.

## Verdict

**MERGE-CLEAR.** No CRITICAL/HIGH/MEDIUM/LOW security findings. One non-blocking,
non-security message-completeness observation recorded for optional follow-up.
