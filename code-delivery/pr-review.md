# PR Review — #806 (Review Cycle 2)

- **PR:** #806 — feat(auth): derive AuthState from pure helper; wire auth list to probe-based 3-state status (BC-1.6.048/049)
- **Branch:** `feat/cycle7-auth-state-derivation`
- **Covered HEAD SHA:** `d42d288e5bdff17336cf1b32a4edf711f2b452fb`
- **Base:** `develop`
- **Verdict:** APPROVE (0 blocking findings; 1 non-blocking documentation-accuracy note)

## Delta since 0c034cb7 (re-review of new HEAD d42d288e)
Single-file CHANGELOG.md addition: a macOS keychain ACL consent note stating that `jr auth list` now probes the keychain per URL-configured profile and that macOS users may see a one-time Keychain Access consent dialog after upgrading (does not appear on Linux/Windows). Accurate against the `collect_probe_results` behavior and consistent with the keyring/Windows Credential Manager posture in CLAUDE.md. Documentation-only; addresses NB-2/NB-4. No code/spec change; all prior findings carry forward.

## Delta 5ced48ca → 0c034cb7
Only `tests/auth_profiles.rs` changed: two integration tests (`precedence_flag_overrides_env_overrides_config`, `test_bc_1_2_018_auth_list_remove_profile_flag_still_honored_not_rejected`) now set a unique `JR_SERVICE_NAME` to isolate the keychain service, so `collect_probe_results` (wired into `handle_list` by BC-1.6.049) no longer triggers a macOS ACL consent dialog. Both tests exercise `auth list` against URL-bearing profiles, so probing the real keychain was a genuine side-effect. Correct, well-scoped fix; service names are unique per test. No production/spec/doc changes — the prior review carries forward unchanged, including the non-blocking note below (nothing in `.cargo/mutants.toml` or the docs changed).

## Cycle-1 fixes verified
- **B-1** — `docs/specs/multi-profile-auth.md`: `STATUS ∈ {configured, no-credentials, unset}` with the 3-state derivation note. Correct.
- **B-2** — `docs/specs/cargo-mutants-policy.md`: two-regex `probe_matching_kind_credential` exclusion documented with rationale. Correct.
- **NB-1** — `test_bc_1_6_049_list_probes_at_most_once_per_url_profile` now asserts profile-specific map values (`with-url-1 → Some(&true)`, `with-url-2 → Some(&false)`, `no-url` absent, `len()==2`), killing the `results.insert(name, true)` clamp mutation. Fixed.

## Correctness (all 3 states)
- `derive_auth_state`: `None → Unset` regardless of `matching_kind_present`; `Some + false → NoCredentials`; `Some + true → Configured`. Matches documented truth table. Total, deterministic, pure. Exhaustive 4-class test + proptest.
- `collect_probe_results`: faithfully stores probe return value, gates on `url.is_some()`, never probes `url: None`, injectable seam.
- `probe_matching_kind_credential`: correct `auth_method == "oauth"` dispatch to `load_oauth_tokens` / else `load_api_token`.
- Renderers: both pure (source-scan-enforced), route STATUS through `derive_auth_state(...).as_str()` / the enum; safe `unwrap_or(false)` fallback.
- `handle_list`: single probe pass before output match; table + JSON share `probe_results`.
- Serialization: `AuthState` serde kebab-case + `as_str()` agreement locked by test; JSON key-set unchanged (6 keys); snapshot regenerated honestly.

## Non-blocking finding (NB)
The `.cargo/mutants.toml` comment on the `src/cli/auth/list.rs` glob (and the mirroring text in `docs/specs/cargo-mutants-policy.md`) attributes `derive_auth_state` to that glob, but `derive_auth_state`/`AuthState` are defined in `src/api/auth.rs:2217/2259`, which is not in `examine_globs`. No correctness or gate-integrity risk — those symbols have strong direct unit tests (exhaustive truth table + proptest + serde-agreement). Suggest a one-line comment fix in a follow-up.

## CI at review time
Format / Clippy (both OS) / MSRV / Spec Guards / Deny / gitleaks green; Test + Coverage + mutation shards still running.
