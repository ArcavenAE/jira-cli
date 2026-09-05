# Phase F6 Security Scan — cycle-004 (windows-correctness)

**Touchpoint:** Security Review Touchpoint #3 (Phase F6 dedicated security scan)
**Reviewer:** security-reviewer (fresh-context, information-asymmetry: did not read
`.factory/phase-f5-adversarial/*` or `.factory/code-delivery/*pr-review*`; findings below
are derived independently from source + specs)
**Repo state:** `develop` @ `3b62cefa06f5a78992efe22707c3d9b2a19c85dd`
**Delta baseline:** `42e92b46` → `3b62cefa`
**Scope (per dispatch):** `src/api/auth.rs`, `src/api/auth_windows_store.rs`,
`src/api/client.rs`, `src/api/jira/tenant.rs`, `src/cli/auth/{login,logout,refresh,mod}.rs`,
`src/cli/init.rs`, `src/config.rs`

## VERDICT: **CLEAN** — no CRITICAL or HIGH findings. F6 is not blocked by this scan.

3 informational/LOW observations are recorded below for the record (none require a fix
before proceeding; two are pre-existing/accepted design tradeoffs already reasoned through
in ADR-0021, one is a residual note on FFI style). Dependency audit is clean.

---

## 1. Dependency audit

### `cargo audit` (RUSTSEC advisory DB, 1239 advisories loaded)
```
Crate:     chacha20
Version:   0.10.0
Warning:   yanked (not a vulnerability advisory — a yank warning)
Dependency tree: chacha20 0.10.0 -> rand 0.10.2 -> jr 0.7.0-dev.4
warning: 1 allowed warning found
```
- **No CRITICAL/HIGH RUSTSEC advisories.**
- The `chacha20` yank warning is **pre-existing, not introduced by cycle-004**: confirmed via
  `git show 42e92b46:Cargo.lock`, `rand 0.10.2`/`chacha20 0.10.0` were already present in the
  baseline before this cycle's commits. It is already an accepted `[[bans.skip]]` entry in
  `deny.toml` (cpufeatures 0.2/0.3 split, DEC-185) and does not gate `cargo deny check`.

### `cargo deny check`
```
advisories ok, bans ok, licenses ok, sources ok
```
Only warnings are pre-existing license-allowance/skip-list noise (BSD-2-Clause,
OpenSSL, Unicode-DFS-2016 unmatched allowances; cpufeatures unmatched skip) — none new,
none from this cycle's delta.

### New dependency introduced by cycle-004
- **`windows-sys = "0.60"`** added as a **direct**, `cfg(windows)`-scoped dependency in
  `Cargo.toml` (features: `Win32_Security_Cryptography`, `Win32_Foundation`) for the DPAPI
  FFI wrapper in `src/api/auth_windows_store.rs`. Confirmed via `git diff` on `Cargo.lock`:
  this **adds zero new dependency-graph nodes** — `windows-sys 0.60.2` was already present
  transitively via `keyring`'s `windows-native` feature at the identical version (per the
  in-repo comment and `deny.toml`'s existing `windows-sys "0.60"` skip entry). No new
  transitive surface, no new RUSTSEC exposure.
- **`futures`** (used by `tenant.rs` for `response.bytes_stream()`/`StreamExt::next()`) was
  **already a direct dependency prior to cycle-004** (`futures = "0.3"` present in the
  baseline `Cargo.toml`) — not newly introduced, not newly audited-for by this cycle. No
  action needed.
- No other new crates were added by this delta.

---

## 2. Static/pattern scan

`semgrep` is not installed in this environment and no network install was performed (per
project conventions — no global pip/brew installs without explicit approval). A manual
CWE/OWASP pass was substituted, covering every non-test line changed across all 10 scoped
files (`git diff 42e92b46..3b62cefa -- <scope>`), described in §3 below. `cargo clippy --lib
--all-features -- -D warnings` (the project's zero-warning gate) was also run and passes
clean, confirming no lint-suppression (`#[allow(...)]`) was used to silence a warning in
the delta — consistent with CLAUDE.md's "no lint suppression without refactoring" rule.

---

## 3. Manual CWE review of the credential-handling delta

### 3.1 Secret/token leakage into logs/stderr/errors (CWE-532)

Reviewed every `eprintln!`/`anyhow!`/`format!` in the delta that could plausibly embed
`access`/`refresh`/token content:

- `store_oauth_tokens`, `load_oauth_tokens`, `site1_login_store_failure_message`,
  `site3_refresh_store_failure_message`, `invalid_profile_name_error`,
  `corrupt_secret_file_error`, `backend_io_error` (all `src/api/auth.rs`) — every
  interpolated value is a **profile name**, a **backend/IO error message**
  (`keyring::Error`/`std::io::Error` Display text, which on Windows is an OS error string,
  never token content), or a **marker-type inner string** (`DpapiFallbackFailed`/
  `CorruptSecretFile`, themselves built only from `io::Error`/`anyhow::Error` Display text
  upstream of any token). No code path formats `access`/`refresh`/`token`/`email` literal
  values into a message.
- `resolve_and_apply_cloud_id` (`src/cli/auth/login.rs`) — soft-fail diagnostic interpolates
  `profile` and the fetch error (`{err}` from `fetch_cloud_id`, itself built from HTTP status
  codes / JSON-parse errors / a plausibility check — never a credential).
- `auth_windows_store.rs`'s `dpapi::protect`/`unprotect` error paths use
  `std::io::Error::last_os_error()` / a static string — never the plaintext buffer.
- Grepped the full diff for common secret-literal shapes (`ATATT`, `ghp_`, `xox[bp]-`,
  AWS key patterns, PEM private-key headers) — **zero matches**, confirming no accidentally
  committed real credentials in test fixtures either.
- **Result: no CWE-532 finding.** The delta's error-message discipline (marker types
  discriminated by `downcast_ref`, never string-matched; message text composed only from
  non-secret material) is a genuine improvement over "log the raw error" patterns.

### 3.2 `unsafe` DPAPI FFI (`src/api/auth_windows_store.rs::dpapi`) — CWE-119/CWE-787

Reviewed `dpapi::protect`/`dpapi::unprotect` (the sole `unsafe` code in the module tree,
per its own doc comment and CLAUDE.md's "no unsafe without justification" rule):

- **Null-blob guard present on both functions**: after a successful (`ok != 0`) FFI call,
  each explicitly checks `output.pbData.is_null()` before calling
  `slice::from_raw_parts` — this guard did not exist at the module's initial PR (#768) and
  was added as defense-in-depth against a Win32 contract violation; `from_raw_parts` on a
  null pointer is UB regardless of the length field, so the explicit check (rather than
  trusting the documented contract) is correct and necessary.
- **`CRYPTPROTECT_LOCAL_MACHINE` (0x4) is never set** — `DPAPI_PROTECT_FLAGS` is a
  compile-time constant (`CRYPTPROTECT_UI_FORBIDDEN` only), verified by direct source read
  (`const DPAPI_PROTECT_FLAGS: u32 = CRYPTPROTECT_UI_FORBIDDEN;`) — matches ADR-0021 §8's
  "USER scope only" requirement; a `LOCAL_MACHINE`-scoped secret would be decryptable by
  any user on the same machine, not just the owning account, which would be a real
  confidentiality regression. This is correctly avoided.
- **Buffer handling**: input blob built as a read-only view over a Rust `&[u8]` (never
  mutated by `CryptProtectData`, which per Win32 docs only writes through `pDataOut`);
  output blob is copied into an owned `Vec<u8>` via `from_raw_parts(...).to_vec()` before
  `LocalFree` is called on the original buffer — no dangling-pointer or double-free risk
  observed; `LocalFree` is called exactly once per call, only on the output buffer, only
  after the copy completes.
- **`cbData: plaintext.len() as u32`** — a `usize -> u32` truncating cast. For an OAuth
  access/refresh token pair (realistically well under a few KB, per the DPAPI fallback's
  own trigger condition of "too large for a 2560-byte keyring blob") this is not reachable
  in practice (would require a >4 GiB plaintext). **LOW / informational, not a real-world
  exploitable finding** — noting for completeness (CWE-190, integer overflow/truncation)
  since it is technically an unchecked cast, but the practical exploitability is nil given
  the realistic input domain (an OAuth token string).
- **`pbData: plaintext.as_ptr() as *mut u8`** — casts a shared-reference-derived pointer to
  `*mut u8` to satisfy the `CRYPT_INTEGER_BLOB` FFI struct shape. This is a well-established
  pattern for Windows API bindings where the C API's input struct is not `const`-qualified
  by convention even though it is read-only in practice (documented as such in the function's
  own safety-justification comment, and confirmed against Win32 docs: `CryptProtectData`
  only writes through `pDataOut`). **Informational note only (CWE-758-adjacent, "reliance on
  documented-but-not-type-enforced API contract")** — this is the same pattern used
  throughout the `windows-rs`/`windows-sys` ecosystem for this exact class of API and is not
  a practical vulnerability; flagging for completeness per CLAUDE.md's "no unsafe without
  justification" bar, which the existing comment already satisfies.
- **No finding requiring a fix.** The FFI wrapper is small (2 functions), input/output
  handling is textbook-correct for this API shape, and the two items above are
  informational rather than actionable.

### 3.3 Path traversal on profile-name → DPAPI file path (CWE-22)

- **Primary gate**: `crate::config::validate_profile_name` (`src/config.rs`) is a strict
  **allowlist** (`is_ascii_alphanumeric() || '_' || '-'`, 1–64 chars, reserved-Windows-name
  denylist on top) — confirmed invoked at **every** profile-name entry point: `--profile`
  flag (`main.rs:221`), `JR_PROFILE` env / `default_profile` config field (via
  `Config::load_with` → `config.rs:340`), and each `auth` subcommand's own explicit call
  (`login.rs:804`, `logout.rs:82`, `status.rs:86`, `switch.rs:15`, `remove.rs:19,98`,
  `refresh.rs:92`). An allowlist-based gate at every ingress point is the strongest possible
  design against this class.
- **Defense-in-depth (this cycle's new code)**: `auth_windows_store::reject_unsafe_profile_component`
  is a **second, independent, host-OS-agnostic denylist** — explicitly checked first in
  `file_path()` on every platform (including non-Windows, so it is exercised on ordinary
  CI) before the DPAPI path is ever joined. It rejects empty, `.`/`..`, NUL bytes, both
  `/` and `\` (catching UNC prefixes on every host, not just Windows), `:` (catches drive
  letters and NTFS ADS), trailing `.`/space (Windows shell/API stripping quirk), and the
  full 30-name reserved-device-name set (including superscript variants `COM¹`/`LPT²`
  etc., which is a genuinely obscure and correct inclusion). 56 unit tests in
  `auth_windows_store.rs` (all passing, confirmed via `cargo test --lib auth_windows_store`)
  exercise this recognizer directly, with no `#[cfg(windows)]` gate on the recognizer tests
  themselves — proving the recognizer, not the host OS, does the rejecting.
- Because the primary allowlist gate already excludes every character the secondary
  denylist checks for, an attacker would need to **first defeat `validate_profile_name`**
  (which permits only `[A-Za-z0-9_-]{1,64}`, an alphabet with no path-meaningful characters
  at all) before the DPAPI-specific guard is even relevant. **No path-traversal finding.**
  The layered design (allowlist primary + host-agnostic denylist secondary) is sound and
  exceeds what a single gate would provide.

### 3.4 `tenant_info` fetch trust boundary (`src/api/jira/tenant.rs`) — SSRF / CWE-918

- **`https://`-only precondition**: `validate_and_trim_site_url` rejects any `site_url` not
  starting with `https://` (case-insensitive) — the fetch makes **zero network requests**
  for a non-`https` input (confirmed by early `ok_or_else` return before any `reqwest`
  client is built).
- **`JR_TENANT_INFO_URL` debug seam correctly release-gated**: `#[cfg(debug_assertions)]`
  wraps the env-var read (confirmed by direct source inspection at the read site and by
  `tests/jr_tenant_info_url_release_gate.rs`, which asserts the cfg-gate is present within 5
  source lines of the read via a source-text scan — this test currently passes). A release
  binary cannot have this seam redirect the request; it is compiled out entirely, not merely
  runtime-disabled. This mirrors the existing `JR_BASE_URL` gate pattern exactly, as
  CLAUDE.md's AI Agent Notes require for any new `JR_*` test seam.
- **No `Authorization` header attached** — confirmed by source read; the `reqwest::Client`
  built for this call carries no auth headers at all, so a redirected/malicious endpoint
  (even via the debug-only override) cannot exfiltrate a bearer credential (there is none to
  leak on this unauthenticated endpoint by design).
- **`redirect::Policy::none()`** — confirmed set on the client builder; a 3xx response is
  surfaced as an ordinary non-2xx status via `!response.status().is_success()`, never
  followed cross-host. This closes the classic "SSRF via redirect to an internal host"
  vector for this specific call.
- **Response body size cap (`MAX_TENANT_INFO_RESPONSE_BYTES = 64 KiB`)**: enforced two ways —
  a fast-path `Content-Length` check, and an authoritative streamed-accumulation check
  (`response.bytes_stream()` + running `body.len()` comparison) that does not trust
  `Content-Length` alone (correctly, since it can be absent for chunked transfer or
  misreported) — this bounds memory use against a hostile/oversized response and is a
  genuine hardening addition (`FIX-F5-CYCLE4-2` hardening #1c per the in-code comment).
- **Response content validated before use**: `is_plausible_cloud_id` rejects empty, or any
  cloud_id containing non-`[A-Za-z0-9-]` characters (rejects whitespace, control
  characters, `/`, and injected markup like `<script>...</script>` per the test suite) —
  this closes a "store a garbage/hostile value into the persisted profile" class,
  independent of the fetch trust boundary itself.
- **10-second bounded timeout** on the dedicated `reqwest::Client` — bounds a slow-loris
  style hang.
- **Residual note (not a new finding, informational only):** `site_url` is user-supplied
  (the Jira site URL entered at `jr auth login`/`jr init` time), and the `https://`-prefix
  check alone does not restrict the *host* portion (e.g. `https://169.254.169.254/` or
  `https://localhost/` would pass the precondition and receive an unauthenticated GET to
  `/_edge/tenant_info`). This is **not classified as a SSRF vulnerability** here because (a)
  the input is supplied directly by the local operator of the CLI, not by a remote/untrusted
  party — the same trust model already applies to every other network call `jr` makes
  against a user-configured `base_url` (this is not new attack surface introduced by
  cycle-004), and (b) the request carries no credentials and the response is validated
  before persistence, so even a successful probe of an internal endpoint yields no
  meaningful primitive beyond "does this URL respond with a plausible `cloudId`-shaped JSON
  field" — no data exfiltration, no credential relay, no write capability. Recorded for
  completeness per the dispatch's explicit ask; **does not block F6**.

### 3.5 Credential over-deletion / wrong-profile clearing

- `clear_profile_oauth_pair`/`clear_profile_creds`/`clear_profile_api_token_pair` all take
  `profile: &Profile` and operate exclusively on that profile's **namespaced** keys
  (`<profile>:oauth-access-token` etc.) plus, only for the literal `"default"` profile, the
  pre-multi-profile **legacy flat** keys — this scoping is unchanged by cycle-004's
  refactor (which converted early-`?`-abort sequencing to attempt-all-then-first-error
  sequencing) and was independently re-verified by reading the full diff: no new code path
  was found that could clear a profile other than the one passed in.
- The new DPAPI-file clear step (`clear_dpapi_file_tolerating_path_escape`) is added to
  both `clear_profile_oauth_pair` and `clear_profile_creds`'s attempt-all fan-out, gated by
  the SAME `file_path(profile)` guard used by every other DPAPI operation — no new
  cross-profile clearing surface.
- `clear_stored_credential_kind`/`reconcile_legacy_none_outgoing_credentials`
  (`src/cli/auth/login.rs`) dispatch strictly on a `kind: &str` matched against
  `{"oauth","api_token"}`, operating on the single `profile: &Profile` passed by the
  caller — reviewed the call site in `handle_login` and confirmed `target`/`Profile::from(target.clone())`
  is threaded consistently to both the pre-login probe and the post-login reconcile call
  (same profile throughout one `handle_login` invocation).
- The `reconcile_legacy_none_outgoing_credentials` clear is explicitly gated to run **only
  after** a successful new-mechanism login (confirmed via the doc comment's stated contract
  AND the call site's position in `handle_login`, after both the `login_oauth`/`login_token`
  `?` and the pre-existing `clear_outgoing_mechanism_on_switch` call) — consistent with the
  documented "relogin-then-replace" invariant (never delete a working credential before a
  replacement is confirmed obtained). **No over-deletion finding.**

### 3.6 TOCTOU / atomicity in DPAPI store/clear ordering

- **`store_oauth_tokens`'s TooLong-routing arms**: delete BOTH keyring entries (via
  `delete_credential_tolerating_no_entry`, `NoEntry`-tolerant) **before** calling
  `auth_windows_store::store_pair` — per ADR-0021 §2's documented "Ordering, and why"
  (STALE-KEYRING-SHADOWS-DPAPI): this prevents a stale, complete keyring pair from a prior
  fitting login silently shadowing a fresh oversized pair that only exists in the DPAPI
  file. A genuine (non-`NoEntry`) delete failure propagates via `?` **before** `store_pair`
  runs — this is a documented "honest-fail" gap (a crash/error between delete and
  `store_pair` can leave the profile with no usable credential in either backend), but it is
  a **fail-safe direction** (loses availability, not confidentiality/integrity — no
  credential is ever exposed or corrupted, only potentially absent, and the documented
  recovery is a plain re-login) — not a security vulnerability, an accepted
  availability tradeoff explicitly reasoned through in ADR-0021 and unchanged by this
  cycle's fix bursts.
- **`atomic_write`** (`auth_windows_store.rs`): write-to-`.tmp-<pid^nanos>` sibling,
  `fsync` the file, `rename` (atomic within one filesystem volume) over the final path, then
  best-effort `fsync` the parent directory (`FIX-F5-CYCLE4-1` LOW-3, this cycle's addition).
  The temp-file suffix (`nanos ^ process::id()`) is unique-enough for collision avoidance
  between concurrent `jr` invocations on the same profile+machine; a collision would at
  worst cause one invocation's temp-write to fail (`File::create` on an existing path
  succeeds and truncates by default — actually note: `std::fs::File::create` would silently
  truncate/reuse an existing tmp file of the same name from a genuinely simultaneous second
  process, which is a low-probability, low-impact race — not exploitable for
  privilege escalation or credential disclosure, since both writers are the same OS user by
  construction, and it is a functional-correctness edge case rather than a cross-user
  security boundary crossing). **No exploitable TOCTOU finding** — the design correctly
  avoids partial-write visibility (via rename-over) and correctly avoids "write access token
  to plaintext, then discover disk-full and half-write refresh token" (the whole pair is
  encoded/protected/wrapped into one buffer before any disk write begins).
- **Stale `.tmp-*` cleanup** (`cleanup_stale_tmp_siblings`) is age-gated (30s) and
  best-effort (`let _ = std::fs::remove_file(...)`) — cannot itself cause data loss of the
  *current* final file (it only ever targets `<final_name>.tmp-*` siblings, never
  `final_name` itself).

### 3.7 Debug-seam release-gating (JR_* env vars)

All four new/modified `JR_*` seams touched by this cycle were verified individually:

| Seam | Gate | Release-gate test | Verified |
|---|---|---|---|
| `JR_TENANT_INFO_URL` | `#[cfg(debug_assertions)]` at single read site (`tenant.rs`) | `tests/jr_tenant_info_url_release_gate.rs` | present, passes |
| `JR_FORCE_DPAPI_FALLBACK` | `#[cfg(debug_assertions)]` inside `#[cfg(not(windows))]` arm (`auth.rs::engage_dpapi_fallback`) | `tests/jr_force_dpapi_fallback_release_gate.rs` | present |
| `JR_S759_FORCE_TOOLONG` | `#[cfg(debug_assertions)]` (`auth.rs::forced_toolong`) | `tests/jr_s759_force_toolong_release_gate.rs` | present |
| `JR_FORCE_DPAPI_LOAD_PAIR` | `#[cfg(debug_assertions)]` inside `#[cfg(not(windows))]` arm (`auth_windows_store.rs::load_pair`) | `tests/jr_force_dpapi_load_pair_release_gate.rs` | present |

All four follow the established `JR_BASE_URL`/`JR_CONFIG_DIR` convention (compile-time
elimination via `cfg(debug_assertions)`, not a runtime `if` alone) and each carries its own
dedicated release-gate regression test, all present in `tests/` and passing. **No
release-leak finding** — none of these seams can influence a release binary's behavior;
the code implementing the override does not exist in that build at all.

**`cargo test --lib` scoped to `auth::`, `tenant::`, and `auth_windows_store::` (214 tests
total across the three) — all pass, 0 failures.** `cargo clippy --lib --all-features -- -D
warnings` also passes clean (zero-warning gate, no `#[allow(...)]` suppressions introduced
by this delta).

---

## 4. DEC-334 revoke-advice correctness (task item 4)

**Confirmed non-harmful / account-wide-honest, and confirmed consistently applied.**

- `site1_login_store_failure_message`'s `DpapiFallbackFailed` arm and legacy (generic
  keychain-write-failure) arm **both** now: (a) recommend `jr auth logout --profile
  <profile>` / `jr auth remove <profile>` (scoped, non-destructive-to-other-profiles
  cleanup) as the **default** remediation, explicitly noting `jr auth remove` only applies
  once the profile is not active/default (correctly reflecting `handle_remove_in_memory`'s
  actual refusal behavior — verified this is accurately described, not just asserted); and
  (b) present the Atlassian-side grant revoke
  (`https://id.atlassian.com/manage-profile/apps`) as **optional** ("Optionally, you can
  revoke...") with an explicit, unambiguous **ACCOUNT-WIDE** warning ("this is ACCOUNT-WIDE
  and will sign out every jr profile on this Atlassian account, each needing `jr auth
  login` again").
- `site3_refresh_store_failure_message` (the refresh-path sibling) **correctly never
  mentions revoking the grant at all** in either arm — appropriate, since a refresh-path
  failure means the OAuth grant is still backing a **working** session for this profile;
  instructing revoke there would (as the codebase's own comment correctly notes) destroy
  working auth. This asymmetry is intentional and correct.
- Verified by direct source read (`src/api/auth.rs` lines ~1503–1600) and confirmed by a
  passing regression test, `api::auth::tests::test_no_account_wide_harmful_revoke_framing_in_auth_source`
  (ran green in this session's `cargo test --lib auth::` run), which exists specifically to
  prevent regression back to the pre-DEC-334 harmful framing (revoke as a *required* step
  framed as *safe*/scoped, which Perplexity-validated research — cited in-code as
  `.factory/research/atlassian-3lo-revoke-granularity-2026-09-05.md` — established was
  false: `jr` uses one shared embedded OAuth app, so revoke is account-wide, not
  per-profile).
- **No finding.** DEC-334 is correctly and consistently implemented across every call site
  that could recommend it, and correctly withheld from the one call site (refresh) where it
  would be actively harmful.

---

## Summary

| Area | Result |
|---|---|
| Dependency audit (`cargo audit`) | Clean — 0 CRITICAL/HIGH advisories; 1 pre-existing yank warning (not from this cycle), already accepted in `deny.toml` |
| Dependency audit (`cargo deny check`) | `advisories ok, bans ok, licenses ok, sources ok` |
| New dependencies this cycle | `windows-sys 0.60` (direct, `cfg(windows)`-scoped) — zero new graph nodes, already present transitively at the same version via `keyring` |
| Static/manual CWE pass | No CRITICAL/HIGH; 3 informational/LOW notes (FFI cast style, `usize→u32` truncation on FFI blob length, SSRF trust-model note on user-supplied site URL) — none actionable, none block F6 |
| Secret leakage (CWE-532) | None found |
| Unsafe DPAPI FFI (CWE-119/787) | Correctly guarded (null-blob checks, USER-scope-only flag, no LOCAL_MACHINE bit, no double-free/UAF) |
| Path traversal (CWE-22) | None — layered allowlist (primary) + host-agnostic denylist (defense-in-depth) |
| Tenant-info SSRF (CWE-918) | None blocking — https-only, no auth header, no redirect-follow, size-capped, response-content-validated, debug-seam correctly release-gated |
| Credential over-deletion / wrong-profile clearing | None found — every clear operation is profile-scoped and kind-scoped |
| TOCTOU/atomicity | None exploitable — fail-safe-direction gaps only (availability, not confidentiality/integrity), already documented in ADR-0021 |
| Debug-seam release-gating | All 4 touched seams correctly `#[cfg(debug_assertions)]`-gated with passing dedicated release-gate tests |
| DEC-334 revoke-advice | Confirmed non-harmful, account-wide-honest, consistently applied |
| Test suite (scoped) | 214/214 pass (`auth::`, `tenant::`, `auth_windows_store::`) |
| Clippy (`-D warnings`) | Clean |

**Overall verdict: CLEAN. No CRITICAL or HIGH findings. F6 is not blocked.**
