# PR #761 — Fresh-Eyes Review (pr-reviewer)

**Story:** S-cycle3-oauth-default-creation (OAuth-default at profile creation + non-interactive guard)
**Verdict:** APPROVE (with nits — no blocking findings)
**Merge recommendation:** MERGE once the in-progress required checks go green.

Reviewed as a human reviewer would: PR diff, description, commit list, and CI rollup only.
Base branch `develop` (correct). Additions 1466 / deletions 33 — ~1054 additions are the new
test file and ~47 are CHANGELOG; the actual `src/` change is small and cohesive (~200 lines).

## Confirmation: browser/prompt genuinely unreachable non-interactively

- **Interactive prompt (picker):** `prompt_auth_method_picker()` performs its own
  `stdin_is_interactive_tty()` check that honors `JR_STDIN_IS_TTY` (debug-only) but
  deliberately NOT `JR_OAUTH_CODE`. When stdin is not a real terminal it returns `Ok(false)`
  (token-first) and never calls `Select::interact()`. Even the `JR_OAUTH_CODE`-set + non-TTY
  edge cannot reach a blocking prompt. MED-1 fix is sound.
- **Browser (login):** `check_noninteractive_oauth_guard(args.no_input, args.oauth)` is the
  literal first statement of `handle_login` — before `Config::load`, prompt, network, browser.
  Under `no_input == true`, `oauth_selected` can only become true via `args.oauth`, which the
  guard already rejected (exit 64). `login_oauth` is provably unreachable with `no_input == true`.
- **Browser (refresh):** guard uses `flow == AuthFlow::OAuth`, folding explicit `--oauth` and
  the implicit stored-`auth_method==oauth` case; `--api-token` never reaches
  `chosen_flow_for_profile`, so it cannot bypass. Guard runs before URL check, credential
  clear, and dispatch.

Single residual: the `JR_OAUTH_CODE` release-build seam (tracked, accepted follow-up to
debug-gate it). Not re-escalated.

## Pre-PR MED fixes verified sound

1. Non-interactive guard + independent, `no_input`-blind and `JR_OAUTH_CODE`-blind TTY check.
2. VP-AUTHDX-001 present and meaningful: proptest driving `oauth:false, api_token:false,
   no_input:true`, asserting the failure is `resolve_credential`'s email/token message, is NOT
   the guard message, and never contains "OAuth" — a real proof tier-2 resolves to `login_token`,
   never `login_oauth`. Ungated (runs in normal `cargo test`).

## Other requested items — all pass

- **DEC-327 precedence:** explicit flag > non-interactive token-first > interactive picker;
  env vars do not suppress the picker interactively. Correct.
- **BC-1.1.015:** `src/api/client.rs` untouched; `unwrap_or("api_token")` preserved (pinned by
  VP-AUTHDX-002 proptest + gated end-to-end test).
- **`--oauth`/`--api-token` conflict:** `conflicts_with` both directions on login and refresh;
  exit-2 tests present.
- **Notices:** both notice fns gate on `OutputFormat::Table` (stderr, silent under json).
  Deprecation fires after the guard; refresh emits at most one (mutually exclusive).
- **Mechanism-switch clearing does NOT over-delete:** `clear_outgoing_mechanism_on_switch`
  no-ops on `None` (first-time) and same-mechanism; on a real switch it reuses
  `clear_profile_creds`, which clears only namespaced per-profile keys (`<profile>:oauth-*`,
  `<profile>:email`, `<profile>:api-token`) plus legacy flat OAuth keys for `"default"` only,
  and never the shared flat `KEY_EMAIL`/`KEY_API_TOKEN` (BC-1.4.032). No cross-profile clobber.
- **Conventions:** no `#[allow]` in `src/`; no let-chains; no `unsafe` in `src/` (test-only env
  `unsafe` blocks carry SAFETY comments). Conventional commits with story ID; clean TDD flow.

## Findings

| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| nit | size | Diff >500 lines, but ~72% is the new test file + CHANGELOG; src delta is small. | Informational only. |
| nit | coherence | Guard is first statement in `handle_login` but runs after config load + `chosen_flow_for_profile` in `refresh_credentials`. | Acceptable/documented — refresh must resolve flow first; config read is not network/browser/prompt. No action. |
| observation | (tracked) | `JR_OAUTH_CODE` ungated by `#[cfg(debug_assertions)]` — the one residual non-interactive browser vector in release builds. | Tracked non-blocking follow-up. |
| observation | (known) | Interactive picker item-text review-verified, not pty-tested. | Same posture as `jr init`. Accepted. |

No blocking findings. No new CRITICAL/HIGH/MEDIUM.

## CI at review time
SUCCESS: Format, Clippy (ubuntu+windows), MSRV, Deny, Spec Guards, Secret Scan, Signing Guard,
Dependency Review. IN_PROGRESS: Test (ubuntu/macos/windows), Coverage, Mutation testing.
`mergeStateStatus: BLOCKED` pending those checks + approval. Merge after the in-progress checks
go green; nothing in the diff suggests they will fail.
