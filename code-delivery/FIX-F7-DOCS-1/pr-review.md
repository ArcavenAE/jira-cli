# PR #766 — Fresh-Eyes AI Review

**PR:** #766 — `docs(auth): reconcile multi-profile-auth spec to shipped per-profile model (cycle-003 F7 HIGH-3)`
**Branch:** `docs/cycle3-auth-profile-reconcile` → `develop`
**Type:** Documentation-only reconciliation (cycle-003 F7 HIGH-3 / LOW-2 / LOW-3). No behavior change intended.
**Reviewer bar:** ACCURACY of every rewritten claim against SHIPPED code (not code quality).

## Verdict: MERGE-WITH-NITS

The core reconciliation is accurate and well-executed. Nearly every rewritten claim matches shipped code. Two overstatements were found — both confined to the `auth login` subsection of `docs/specs/multi-profile-auth.md`, where the new prose gets ahead of the code. Neither blocks merge (docs-only, no runtime impact, credential model correct), but both reintroduce the exact doc/code drift class this PR exists to remove, so they are worth tightening in this PR or a quick follow-up. One NIT (pre-existing convention).

## Scope confirmation

- Diff is 3 files, docs-only (per `gh pr view`: CLAUDE.md +1/−1, multi-profile-auth.md +82/−48, logout.rs +4/−3).
- `src/cli/auth/logout.rs` change verified **genuinely comment-only** — the diff touches only the `///` doc comment (lines 18–23). All logic (`handle_logout`, lines 50–119) and the `AMENDED-by` doc block (25–49) are unchanged.

## Findings triage table

| ID | File / Section | Inaccuracy / Suboptimality | Severity | One-line fix |
|----|----------------|-----------------------------|----------|--------------|
| W1 | `docs/specs/multi-profile-auth.md` → CLI Surface, `jr auth login` block | Claims "a brand-new profile with neither --oauth nor --api-token passed is created as an oauth-method profile." Wrong for non-interactive: under `--no-input`/non-TTY, neither-flag creation defaults to **api_token** (`src/cli/auth/login.rs:368–379`). OAuth is only the *interactive* picker default (`prompt_auth_method_picker`, login.rs:540, `.default(0)`), where the user can still pick API Token. | WARNING (suggestion) | Scope the claim to the interactive picker default; note `--no-input` with neither flag creates an api_token profile. |
| W2 | `docs/specs/multi-profile-auth.md` → CLI Surface, `jr auth login` block | Claims login "never re-prompts for the API token if one is already stored for THAT profile." Not implemented — `login_token` always resolves flag → env → interactive prompt (`login.rs:54–79` via `resolve_credential(..., None)`, `keychain.rs:38–75`); no login path loads the stored `<profile>:api-token` (only `status.rs:146` and `client.rs:137` call `load_api_token`). Appears carried over from the pre-cycle-003 "reuses shared API-token credential" wording. | WARNING (suggestion) | Delete the "never re-prompts…" clause; keep the correct surrounding "each profile stores its own pair / does not reuse another profile's token." |
| N1 | `docs/specs/multi-profile-auth.md` → `### Public API (src/api/auth.rs)` code sketch | Sketch writes `store_api_token(profile: &str, …)` / `load_api_token(profile: &str)`; shipped signatures take `profile: &Profile` (newtype, ADR-0011 / commit b7e513f9). Pre-existing convention — the OAuth signatures in the same block already used `&str`, so it is internally consistent. | NIT | Optionally change `&str` → `&Profile` across all four signatures, or leave as intentional simplification. |

## Per-file / per-claim accuracy cross-check (verified accurate — no findings)

### docs/specs/multi-profile-auth.md — Keyring Layout
- Per-profile `<profile>:email` / `<profile>:api-token`; only `oauth_client_id` / `oauth_client_secret` flat/shared. Matches `store_api_token`/`load_api_token` namespacing (`src/api/auth.rs:359`, `:435`) and `store_oauth_app_credentials`/`load_oauth_app_credentials` (`:498`, `:508`). ✓
- Public API clear helpers:
  - `clear_profile_oauth_pair(profile)` — OAuth-only (auth.rs:589–597); used by `auth logout` on oauth-method profiles (`logout.rs:105`). ✓
  - `clear_profile_creds(profile)` — clears BOTH the OAuth pair AND the `<profile>:email`/`<profile>:api-token` pair (auth.rs:672–685); used by `auth remove` (`remove.rs:139`). ✓
- Dropping `clear_all_credentials` from the listing is acceptable — it is now TEST-ONLY (zero production callers; grep confirms only `#[cfg(test)]` uses + one comment ref). Its old "shared keys + every listed profile's OAuth keys" description would now be inaccurate anyway (it also clears the namespaced api-token pair). ✓
- `load_api_token` "no legacy-flat-key fallback for any profile including default" cross-ref to Migration (4) — matches auth.rs and test `load_api_token_default_profile_has_no_legacy_fallback` (auth.rs:2590). ✓

### docs/specs/multi-profile-auth.md — CLI Surface (`jr auth` subcommands)
- `auth login [--oauth] [--api-token]` — flags present, mutually exclusive (`src/cli/mod.rs:230–236`); `--oauth` deprecated-but-accepted with stderr deprecation notice (`login.rs:286`). ✓ (except W1, W2 above)
- `auth switch <NAME>` positional-only, `--profile` rejected (exit 64) — consistent with S-663-1 / CLAUDE.md gotcha. ✓
- `auth list` — 5-column `NAME|URL|ENV|AUTH|STATUS` (`list.rs:46`); ENV renders `-` when unset (`list.rs:14`); JSON keys `name/url/env/auth_method/status/active` (`list.rs:60–65`, status = `configured`/`unset`). `config.rs` `ProfileConfig.env: Option<String>` exists (config.rs:35). ✓ (DEC-324)
- `auth status` human text only, no `--output json` — consistent with NFR-O-N / status.rs. ✓
- `auth logout` — non-destructive session-clear; DEC-322 api-token stderr notice + exit 0, api-token pair untouched, JSON shape unchanged, oauth profile clears only OAuth pair. Matches `logout.rs:80–117`. ✓
- `auth remove` — deletes BOTH pairs for the profile + config entry + cache dir; only shared oauth_client_id/secret never touched. Matches `remove.rs` + `clear_profile_creds`. ✓
- `auth refresh [--oauth] [--api-token]` — flags INERT on flow selection; flow always from target profile's `auth_method` (`chosen_flow_for_profile`); passing a flag only emits stderr human-mode-only notice (deprecation for `--oauth`, inert-on-refresh for `--api-token`); relogin-then-replace ordering (obtain-then-overwrite, no up-front clear); per-profile isolation. Matches `refresh.rs:95–212`, clap `mod.rs:281–289`. ✓ (DEC-321)

### docs/specs/multi-profile-auth.md — Migration / Config Schema
- Not touched by the diff (hunks are Keyring Layout + CLI Surface only). Cross-references from the rewritten text resolve: Migration "(2)" OAuth lazy migration (line 320) and "(4) Keyring API-token credentials — no auto-migration, detect-and-instruct / DEC-326" (line 350) both exist. Config Schema (line 40) intact. ✓ — not regressed.

### src/cli/auth/logout.rs (LOW-2)
- Comment-only change; corrects stale pre-DEC-315 wording ("shared API-token credential… keyed by host") to per-profile-namespaced (BC-1.4.031). Logic unchanged. ✓

### CLAUDE.md (LOW-3)
- Added DEC-322 sentence documenting the `auth logout` api-token stderr notice. Quoted string is byte-accurate against `logout.rs:93–96` — only difference is `<profile>` (doc placeholder) ↔ runtime `{target}`; em-dash `—`, semicolon, and backticks around `jr auth remove` all match. ✓
- Stderr-only / never-on-stdout / JSON-shape-unchanged claims match `logout.rs:108–117`. ✓
- No NEW backtick file-path citation introduced (only commands like `jr auth remove <profile>` and the already-present `refresh.rs::refresh_credentials` symbol-form) — CLAUDE.md dead-citation CI guard (`tests/claude_md_citations.rs`) safe. ✓

## Recommendation

**MERGE-WITH-NITS.** The reconciliation achieves its goal accurately. Suggest tightening W1 and W2 (two sentences in the `auth login` block) in this PR or a fast follow-up, since they reintroduce doc/code drift of the same kind the PR removes elsewhere. N1 is optional. No merge-blockers.

---
_Reviewed as fresh-eyes AI review; findings reported to coordinator. No `gh pr review` posted, no PR code/docs modified, per standing instruction._
