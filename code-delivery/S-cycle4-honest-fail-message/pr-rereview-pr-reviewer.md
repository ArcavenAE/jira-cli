# PR #771 Fresh-Context Re-Review — Fix Delta

- **Story:** S-cycle4-honest-fail-message (cycle-004, auth/credential module)
- **Branch:** feat/cycle4-honest-fail-message
- **Delta reviewed:** `b2a0c5d7..17dcccb7` (origin == local worktree head, confirmed)
- **Method:** independent verification — read source, traced call sites, ran targeted tests + clippy. Implementer self-report NOT trusted.
- **Verdict:** findings-remaining — 0 BLOCKING, 1 WARNING (non-blocking). All four prior findings (B-1, B-2, NB-1, NB-2) are genuinely resolved.

---

## Prior findings — verification

### B-1 (correctness) — RESOLVED
The new-profile-only guard genuinely holds. `should_mark_auth_method_before_attempt(current) == current.is_none()`; the call site in `handle_login` (login.rs) guards the pre-mark + `save_global()` with it, and `mark_auth_method_if_new` internally re-checks the same predicate.

- **Switch path not regressed:** for a switch, `current_auth_method = Some(_)` → guard returns `false` → no pre-mark; `auth_method` on disk stays the prior mechanism. On success, `login_oauth`/`login_token` reload config and overwrite `auth_method` (login.rs:124/406). On failure they `?`-return before that write, so the prior mechanism's label AND creds are untouched → FIX-F5-login-switch "relogin-then-replace" preserved. Verified in source, not just the doc comment.
- **Test is not a tautology:** the new tests chain the actual production predicates (`mark_auth_method_if_new` → `auth_method_is_api_token` → `handle_remove_in_memory`) in exactly the order `handle_login` uses them. `b1_brand_new_oauth_profile_login_failure_logout_routes_to_oauth_branch` proves logout routes to the OAuth-clear branch and `jr auth remove` is still refused (active==target). Genuine routing coverage.
- **`jr auth remove` advice accurate:** `handle_remove_in_memory` (remove.rs) refuses when `target == active` OR `target == default_profile`. A brand-new `jr auth login --oauth` profile is both, so the reworded "if {profile} is not your active profile, `jr auth remove` deletes it entirely" is materially accurate for the targeted scenario (switching away clears both active and default simultaneously). Minor imprecision only: the message names the active gate, not the separate default_profile gate — not a defect.

### B-2 (docs) — RESOLVED
CHANGELOG now explicitly records that the scoped-cleanup / optional-account-wide-revoke correction ALSO rewrote the generic "Unlock your keychain" arm, and that this arm is reachable on EVERY platform (not DPAPI-only). Verified against source: `site1_login_store_failure_message`'s third arm is the un-gated `anyhow!` fallback for any non-`ProfilePathEscape`/non-`DpapiFallbackFailed` keychain failure — reachable on macOS/Linux. The old CHANGELOG sentence "macOS/Linux behavior is unaffected" is removed and correctly re-scoped to "the DPAPI-fallback failure MODE" only.

### NB-1 (source-scan guard defeated by line-wrapping) — RESOLVED
`normalize_for_phrase_scan` strips a leading `///` (+ one space), strips a trailing `\` string-literal continuation per physical line, then collapses all whitespace (including newlines) to single spaces. `test_no_account_wide_harmful_revoke_framing_in_auth_source` now normalizes production code (split at `mod tests`) before scanning `FORBIDDEN_PHRASES`. Two self-tests prove the mechanism on synthetic fixtures: a rustdoc-wrapped phrase and a `\`-continued string literal both re-join to `"no other consumer"`. Traced logic by hand + ran the tests (green). The gap is closed for both wrap classes present in this file.

### NB-2 (Site-3 proactive-clear exception undocumented) — RESOLVED
CLAUDE.md's "Per-profile vs shared keychain keys" entry now carries the "Narrow, documented exception" paragraph describing the Site-3 `DpapiFallbackFailed` proactive `clear_profile_oauth_pair`. Matches actual code at auth.rs (`refresh_oauth_token_with_url`, ~L1856-1867): on a `DpapiFallbackFailed` store failure it clears the pair before returning the honest-fail error, and the code comment agrees it is Site-3-only (Site 1 clears nothing). Rationale (single-use refresh token already consumed → old pair already stale) is accurate.

---

## New findings introduced by the delta

### NEW-1 — WARNING (non-blocking): `auth_method.is_none()` is an unsafe proxy for "brand-new profile with no working credentials"
`should_mark_auth_method_before_attempt` treats `auth_method == None` as "brand-new profile, nothing to protect." But `None` is ambiguous:
- A profile migrated from the legacy `[instance]` shape copies `instance.auth_method` verbatim (`config.rs` ~L193), which can be `None`, while the profile still holds WORKING api-token credentials in the keychain.
- The client gates credential loading strictly on `auth_method` with NO fallback (`client.rs` `load_auth_from_keychain`: `"oauth"` → `load_oauth_tokens`; the `None`→`"api_token"` default only applies while the label is unset).

Consequence: for such a legacy `None`-labelled profile with valid api-token creds, `jr auth login --oauth` (an intended switch) that FAILS partway now persists `auth_method = "oauth"` with no OAuth creds. The next ordinary command calls `load_oauth_tokens`, finds nothing, and fails — whereas BEFORE this change it kept working via the still-present api-token creds (`None` → api_token default). This contradicts the guard's own doc-comment claim ("no working credentials exist under any label yet") and is a narrow deviation from the FIX-F5-login-switch principle the fix claims to preserve.

- **Severity: LOW.** Narrow population (only profiles predating `auth_method` tracking / migrated with `auth_method=None` that still have working creds AND attempt a failing OAuth switch). No data loss — the api-token creds are untouched in the keychain (`clear_outgoing_mechanism_on_switch` still no-ops because `switching=false` for a `None` prior). Recovery is a re-login (`jr auth login --api-token`) or a config edit.
- **Note:** the pre-existing `switching` computation shares the same `None`-ambiguity blind spot, so the ambiguity itself is not introduced here — but the specific *mislabel-then-break* failure mode (vs. the prior *keep-working*) IS newly introduced by the eager pre-mark.
- **Recommendation:** either probe for stored credentials before pre-marking (only pre-mark when no creds exist under any label), or narrow the doc comment's "nothing to protect" claim and explicitly acknowledge this legacy edge case. Team's call — does not block merge.

---

## Checks run
- `cargo test --lib auth` → 236 passed, 0 failed.
- Targeted: all 15 B-1/NB-1 finding tests pass (1 keyring-gated ignored as expected).
- `cargo clippy --lib --tests` → clean, zero warnings (merge-gate policy satisfied).

## Bottom line
All four prior findings are genuinely fixed, not reworded. The delta is essentially merge-ready; the single remaining item (NEW-1) is a LOW, recoverable, narrow edge-case regression worth a team decision but not a merge blocker.
