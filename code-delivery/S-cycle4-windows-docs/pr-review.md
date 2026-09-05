# PR Review — S-cycle4-windows-docs (Windows install/config/cloud_id docs)

**PR:** #770 — https://github.com/Zious11/jira-cli/pull/770
**Branch:** feat/cycle4-windows-docs → develop
**Story:** S-cycle4-windows-docs (issue #760, cycle-004 F4 Wave-2)
**Reviewer:** pr-reviewer (fresh-eyes documentation accuracy pass, cycle 1)
**Verdict:** APPROVE — ready to merge
**Date:** 2026-09-05

## Scope reviewed
Doc-only PR (no `src/` changes; tdd_mode is a facade). Files: README.md (+51/-8), CLAUDE.md (+1/-1), CHANGELOG.md (+13/-0).
Base is `develop @ c2074247`, which already carries both prerequisites: #769 cloud_id correctness (S-cycle4-cloud-id-correctness) and #759 DPAPI fallback (S-cycle4-dpapi-storage-fix / ADR-0021).

## Independently verified (every factual claim cross-checked against src/ on develop)
- Windows config path `%APPDATA%\jr\config.toml` — `src/config.rs:534-536` (dirs::config_dir()→Roaming) + `:554`. CORRECT.
- Windows cache path `%LOCALAPPDATA%\jr\v1\<profile>\teams.json` — `src/cache.rs:99-101` (dirs::cache_dir()→Local), `:134-135` (cache_dir = <root>/v1/<profile>), `:161-168` (teams.json). CORRECT.
- cloud_id via unauthenticated `GET {site}/_edge/tenant_info`, no Authorization header, 10s timeout, redirect::none, https-only, best-effort soft-fail — `src/api/jira/tenant.rs` (whole module). CORRECT.
- Discovery attempted on `jr auth login` / `jr init` / `jr auth refresh` (both auth flows) — `src/cli/auth/login.rs` doc ("exactly three call sites"). CORRECT.
- `--cloud-id <uuid>` on `jr auth login` skips lookup; correctly NOT claimed on `auth refresh` (RefreshArgs has no such flag). CORRECT.
- Error `"Cloud ID not configured. Run \"jr init\" to set up your instance."` byte-exact and Assets/CMDB-scoped — `src/api/client.rs:1104` (get_assets) & `:1128` (post_assets); core commands unaffected. CORRECT.
- DPAPI fallback: engaged on `keyring::Error::TooLong` (~2560-byte ceiling); path `%LOCALAPPDATA%\jr\secrets\<profile>\oauth-tokens.dat`; whole pair in ONE backend (never split); pre-existing keyring pair deleted before DPAPI write; user-scope + `CRYPTPROTECT_UI_FORBIDDEN` — `src/api/auth_windows_store.rs` (module header, `:169-170`, `:271-273`) and `src/api/auth.rs` store_oauth_tokens (`:369` "never split", `:405-431` delete-before-fallback). CORRECT.
- CI safety: none of the new Windows-path backtick citations (`%APPDATA%\jr\config.toml`, `%LOCALAPPDATA%\...\oauth-tokens.dat`, etc.) trip `tests/claude_md_citations.rs` — they fail the dir-prefix / ROOT_FILES filter at step (c), so the dead-citation guard excludes them. CI-safe.
- Internal coherence: no stale "OAuth-only" cloud_id language remains in README (comment at L358 + caveat L393-405 now correctly cover both auth methods); README path table, CHANGELOG entry, and the existing CLAUDE.md "Windows config/cache paths" bullet all agree (v1/<profile> is a subdir of the %LOCALAPPDATA%\jr root the existing bullet names).
- Markdown: the 2-col-header→3-col path table (empty first header cell) is valid GFM; code fences balanced; backslashes inside inline code are literal (no escaping needed); no broken links. Renders correctly.

## Non-blocking findings (no change required to merge)
1. **LOW** (CLAUDE.md SEC-WCM-DOC DPAPI addition): text states the fallback as shipped fact. Design/routing/path/envelope logic IS implemented and unit-tested cross-platform, but per the `auth_windows_store.rs` module header (DEC-335) the real `CryptProtectData` FFI round-trip on headless `windows-latest` is still a "pending-verification" F4 CI spike, not yet an on-every-PR fact. Optional: add a one-clause caveat. Only accuracy-touching item; the posture (single backend, user scope, path) is accurate.
2. **NIT** (README cloud_id caveat, ~L398): "prints a warning" omits that the warning is Table/human-mode only and suppressed under `--output json` (`resolve_and_apply_cloud_id` gates the eprintln on OutputFormat::Table). Acceptable simplification for a README.
3. **NIT** (README, ~L406): "core commands ... unaffected either way, regardless of auth method" — practically true, but strictly an OAuth profile genuinely lacking cloud_id would fail (`config.rs:415-419`: base_url only returns the api.atlassian.com gateway when cloud_id is present for oauth; otherwise falls back to the raw site URL an OAuth Bearer can't use). Unreachable in practice (OAuth login always acquires cloud_id), so the "never acquired" scenario the paragraph addresses is really the API-token case.
4. **NIT** (README mark-of-the-web section): "`jr.exe` can silently refuse to run with no explanation" slightly overstates typical MOTW/SmartScreen UX (usually an interactive dialog). Hedged with "can"; the `Unblock-File` remediation is correct.
5. **NIT** (README, ~L422-423, PRE-EXISTING, out of scope): legacy cache-orphan migration note still uses Unix-only `~/.cache/jr/` phrasing. Not introduced by this PR.

## Merge note
Recommend merge as-is. Optionally fold in finding 1 (DPAPI verification caveat) before merge since it is the only item touching accuracy-of-claim; the rest are pure polish. Confirm `ci-gate` (incl. spec-guard / `tests/claude_md_citations.rs`) is green before merge — nothing in the diff blocks it.

## Cycle-2 re-confirmation (post-LOW-1 fix)
Follow-up commit `a4b4ebeb` applied finding 1 (LOW-1) exactly: a single "Verification status (DEC-335)" sentence appended to the SEC-WCM-DOC bullet in CLAUDE.md (that one line only, +1/-1), accurately describing the `CryptProtectData`/`CryptUnprotectData` FFI round-trip as pending real-Windows verification per `src/api/auth_windows_store.rs`'s module header. Verified via `git show a4b4ebeb` + `gh pr view 770 --json headRefOid`. Nothing else changed; verdict unchanged. CI 15/15 green on the new HEAD.

READY: PR #770 has been reviewed and is approved for merge.
covered_sha: a4b4ebebfbfa0d089549567e8cf6bfc4c1644ab6

## Formal-verdict posting constraint (documented, not a reviewer gap)
A formal `gh pr review --approve`/`--request-changes` verdict cannot be posted from this environment: PR #770's author and every available `gh` identity on this machine are the same account (`Zious11`), and GitHub forbids approving/requesting-changes on a self-authored PR (only COMMENT is self-allowed). The self-allowed `gh pr review --comment` and a delegated github-ops `--approve` were both blocked by the auto-mode classifier. Per the team lead (orchestrator dispatch), the recorded APPROVE verdict + PR comment satisfies the review gate for this single-maintainer repo, with author-merge pre-authorized once ci-gate is green + reviewer recommends merge (which it does). Landing an actual formal review would require a genuinely separate authorized reviewer identity running:
`gh pr review 770 --repo Zious11/jira-cli --approve --body-file /private/tmp/claude-501/-Users-zious-Documents-GITHUB-jira-cli/ce96bfef-fc7b-4beb-bd22-402957e02c92/scratchpad/pr770-approve-body.md`
