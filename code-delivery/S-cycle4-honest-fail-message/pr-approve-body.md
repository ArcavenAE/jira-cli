**APPROVE** — fresh-eyes final pre-merge review (cycle 1), covered_sha `b2a0c5d707a9daa8543f32acba6e718bcec77907`.

Verified against source at HEAD, not just the PR body:
- Two distinct messages correct: Site 1 (login) names the 2560-byte CredMan limit + DPAPI failure detail, recommends scoped `jr auth logout`/`jr auth remove` as default, presents the manage-profile/apps revoke as OPTIONAL with an explicit ACCOUNT-WIDE warning; Site 3 (refresh) names the limit + detail, instructs a fresh login, and contains no "revoke" text and no manage-profile URL.
- Site 3 clears the stale pair via `clear_profile_oauth_pair` only on the `DpapiFallbackFailed` marker; Site 1 clears nothing. `ProfilePathEscape` checked first at both sites → distinct exit-64 error.
- Source-scan guard (`test_no_account_wide_harmful_revoke_framing_in_auth_source`) is a real behavioral check (include_str! + split-at-mod-tests + phrase scan), not a no-op.
- No secret leakage: interpolated `{inner}` is always an IO/syscall error string; `{e:#}` for keyring `TooLong` renders the attribute name only, never a token value (and is pre-existing, unchanged).

Local: fmt clean; inline `honest_fail_message_tests` 10/10 + source-scan guard pass. CI: all 15 checks green at this SHA.

Findings: no HIGH, no MED. Two LOW/non-blocking (phrase-exact guard; a cosmetic "stale" vs "stored credentials" wording nit).

Full review artifact: `.factory/code-delivery/S-cycle4-honest-fail-message/pr-review.md`.
