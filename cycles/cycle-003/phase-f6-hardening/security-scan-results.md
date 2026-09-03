# F6 Security Scan — cycle-003 `auth-profile-dx`

- **Baseline:** `87f17aff` → **HEAD:** `202414f2`
- **Date (UTC):** 2026-09-02
- **Reviewer:** formal-verifier (F6 targeted hardening)

## 1. Dependency / advisory scan

### `cargo audit` — PASS (exit 0)

- Advisory DB: 1239 advisories loaded; 358 crate dependencies scanned.
- **Vulnerabilities: 0.**
- **1 warning (allowed):** `chacha20 0.10.0` is a **yanked** crate version.
  - Dependency path: `chacha20 0.10.0 → rand 0.10.2 → jr 0.7.0-dev.3`.
  - **Severity: LOW / INFORMATIONAL.** "Yanked" ≠ vulnerable: there is no RUSTSEC advisory
    against this version; it was withdrawn from crates.io by its author. No CVE/CWE applies.
  - **Not introduced by the cycle-003 delta** — transitive via `rand`, unrelated to the auth
    cluster. Pre-existing on the `87f17aff` baseline.
  - Consistent with `cargo audit` exiting 0 (warning, not error). Recommend a routine
    `cargo update -p chacha20` at the next maintenance sweep; **not a BLOCK**.

### `cargo deny check` — PASS (`advisories ok, bans ok, licenses ok, sources ok`)

- All four checks pass. Warnings emitted are non-blocking hygiene notices only:
  - 3× `license-not-encountered` (allow-list entries `BSD-2-Clause`, `OpenSSL`,
    `Unicode-DFS-2016` not matched by any current dependency — stale allow-list entries, benign).
  - 1× `unmatched-skip` (`cpufeatures = ^0.2` skip no longer matched — DEC-185 authorized;
    benign).
  - 1× `yanked` (`chacha20 0.10.0`, same as above).
- **No banned crates, no license violations, no untrusted sources.**

### `gitleaks` (secret scan)

- **CI-gated, not run locally.** `ci.yml` runs gitleaks on `pull_request` events, gated by
  `vars.GITLEAKS_DISABLED != 'true'`. No local run required for F6; noted for completeness.
  No secrets were observed in the delta during the manual review below.

## 2. Manual security lens on the auth/credential delta

| Area | Finding | Assessment |
|------|---------|------------|
| **Keychain namespacing** | `store_api_token`/`load_api_token` (`src/api/auth.rs`) write/read only the namespaced keys `<profile>:email` / `<profile>:api-token` (`api_token_email_key`/`api_token_key` = `format!("{profile}:email")` / `"{profile}:api-token"`). Symmetric with the pre-existing `<profile>:oauth-*` namespacing. | **SECURE.** Per-profile isolation prevents sandbox/prod credential bleed (the exact class VP-AUTHDX-004 cross-profile isolation guards). No flat `email`/`api-token` pair is ever written. |
| **No-copy migration** | `load_api_token`'s both-absent branch performs an EXISTENCE-ONLY check (`legacy_flat_pair_exists()` → `bool`) and returns a byte-identical actionable error whether or not a legacy flat pair exists. The bool is bound to `_legacy_pair_present` and never used as a credential; no `if profile == "default"` branch exists. | **SECURE.** Detect-and-instruct (DEC-326, HUMAN DECISION) — no profile silently inherits another environment's legacy credentials. Matches VP-AUTHDX-005/006 oracles. |
| **Partial-state handling** | The `_ =>` arm (exactly one namespaced key present) returns a distinct "Incomplete credentials" `Err` before any legacy consideration — no silent half-credential `Ok`. | **SECURE.** Prevents a confusing downstream 401 (VP-AUTHDX-008). |
| **No plaintext-secret logging** | `grep` of `eprintln!/println!/tracing::/debug!/info!/warn!/error!` across `src/api/auth.rs` + `src/cli/auth/*.rs` filtered for token/password/secret/email: the only tracing lines log `profile = %profile` (a profile NAME only) — `oauth_token_exchange_start`, `refresh_oauth_token_start`. The `login.rs` `eprintln!` lines print env-var NAMES (`JR_OAUTH_CLIENT_ID`, `--client-secret`) as setup instructions, never values. | **SECURE.** No credential value reaches any log/stderr sink. |
| **Token-leak-on-host-redirect (JR_BASE_URL)** | `src/api/client.rs::from_config` reads `JR_BASE_URL` only under `#[cfg(debug_assertions)]` (release binaries compile out the override, `#[cfg(not(debug_assertions))]` → `None`). Paired with the `JR_AUTH_HEADER` `#[cfg(debug_assertions)]` gate. Comment explicitly cites the `JR_BASE_URL=http://attacker/` bearer-token-leak vector. Regression-pinned by `tests/base_url_release_gate.rs`. | **SECURE.** Delta preserves the release gate at both read sites; no new unguarded read introduced. |
| **`auth_method` runtime default** | `from_config` resolves `auth_method` via `.unwrap_or("api_token")` — byte-identical to pre-cycle-003 (VP-AUTHDX-002). A silent flip here would misroute legacy configs into an unwanted OAuth attempt. | **SECURE.** Literal preserved; regression-pinned. |
| **`refresh` relogin-then-replace (DEC-321)** | `refresh.rs::refresh_credentials` obtains the replacement credential FIRST and persists via unconditional overwrite; clears nothing up front, so a failed refresh leaves existing creds intact (VP-AUTHDX-003 Invariant 2 / BC-1.2.051 I-6). | **SECURE.** No data-loss window; no flag can force an unwanted mechanism. |

## 3. Findings by severity

| Severity | Count | Items |
|----------|-------|-------|
| CRITICAL | 0 | — |
| HIGH | 0 | — |
| MEDIUM | 0 | — |
| LOW / INFORMATIONAL | 1 | `chacha20 0.10.0` yanked (transitive via `rand`; pre-existing; not delta-introduced; no CVE/CWE) |

**No CWE-classifiable findings in the delta.** The manual lens confirms the auth restructuring
upholds credential isolation (no cross-profile bleed), no plaintext-secret exposure (CWE-532
clear), and the token-leak-on-redirect release gate (CWE-522/CWE-200 class) is intact.

## Verdict

**PASS.** 0 CRITICAL / 0 HIGH / 0 MEDIUM. One LOW/informational yanked-crate warning,
pre-existing and unrelated to the delta — **not a BLOCK**. `cargo audit` and `cargo deny check`
both exit 0.
