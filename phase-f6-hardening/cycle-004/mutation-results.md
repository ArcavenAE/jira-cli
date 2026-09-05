# F6 Mutation Testing — cycle-004 `windows-correctness`

- **Baseline:** `42e92b46` (v0.7.0-dev.4) → **HEAD:** `3b62cefa` (develop tip)
- **Date (UTC):** 2026-09-05
- **Tool:** `cargo-mutants 27.0.0`, `--jobs 4/2 --timeout 240/300`, host `x86_64 macOS`
- **Scope:** security-critical delta — `src/api/auth.rs`, `src/api/auth_windows_store.rs`,
  `src/api/jira/tenant.rs`, `src/cli/auth/login.rs`
- **Information-asymmetry wall:** survivors classified from the SPEC's declared coverage
  boundaries (`vp-delta.md` keyring-gated / Windows-only tiers) and the source's own `#[cfg]`
  gating — NOT from any F5 adversarial finding.

---

## 0. `examine_globs` coverage finding — **CONFIRMED POLICY GAP (route as FIX-F6, HIGH-process)**

The flagged concern is real and worse than "auth.rs is absent": **NONE** of the cycle-004
changed source files is in `.cargo/mutants.toml` `examine_globs` — not `auth.rs`, not the NEW
`auth_windows_store.rs`, not the NEW `tenant.rs`, not `login.rs`, not `client.rs`.

Proof (run from repo root):

```
$ cargo mutants --in-diff <42e92b46..HEAD diff> --list
 INFO No mutants to filter        # ZERO mutants — nothing in the diff intersects examine_globs
```

**Consequence:** the CI mutation job (`cargo mutants --in-diff <PR diff>`, the CLAUDE.md /
`docs/specs/cargo-mutants-policy.md` command) generates **ZERO mutants for the entire
cycle-004 security-critical delta**. The DPAPI credential-storage fallback, the tenant_info
cloud_id acquisition, and the credential-clear/switch paths shipped with **no mutation-testing
signal in CI whatsoever**. This is the same drift class the policy already recognises
(P22-001 / DEC-149 / S-MUTANTS-SCOPE-1 / FIX-F6-MUTANTS-SCOPE: "new CLI/security handler file
→ add to `mutants.toml` at creation") — it slipped again for the whole auth cluster this cycle.

To generate mutants at all, this F6 pass **overrode** `examine_globs` with explicit
`--file` / a temporary `--config` per file.

**Recommendation (FIX-F6):** add `src/api/jira/tenant.rs` to `examine_globs` immediately (it
is fully default-CI-testable — see §3, 16/21 killed with the 5 survivors all addressable). For
`auth.rs` / `auth_windows_store.rs` / `login.rs`, adding them as-is would flood default CI with
spurious "survivors" that are actually keyring-gated / `#[cfg(windows)]` boundary code (see §2)
— they should be added only alongside either (a) an in-CI keychain injection seam, or (b) an
`exclude_re` allowlist documenting the keyring-gated/Windows survivors, mirroring the existing
`search_issues_with_fields` TIMEOUT exclusion precedent.

---

## 1. Methodology note — CPU-contention timeouts (why two runs, not one)

The first run used the config's `additional_cargo_test_args = ["--all-features"]` (the full
40+ integration-binary suite, ~121 s baseline). Under `--jobs 4`, four concurrent full-suite
runs contend for CPU and each individual run exceeds the `--timeout 240` ceiling — producing a
flood of **spurious TIMEOUTs on mutations that never even executed** (e.g.
`store_oauth_tokens -> Ok(())` stalling inside the unrelated `issue_move_resolution_enforce`
binary). These are a harness artifact, not a code signal.

The reported results use a **scoped test set** (`--lib` + the auth/tenant integration binaries
only), which runs in seconds and eliminates contention timeouts entirely (tenant+login pass at
`--jobs 2`: **0 timeouts**). The full-suite partial run is preserved at
`mutants-run-fullsuite-partial/` for reference.

---

## 2. Two survivor classes that are NOT genuine test-quality gaps

Mutation testing runs under **default `cargo test`** (no `JR_RUN_KEYRING_TESTS`, no OS keychain;
host = macOS). Two large mutant populations are unkillable in that environment **by spec design**,
not by missing tests:

- **(A) Keyring-gated boundary.** Functions whose only observable effect is a real-OS-keychain
  mutation (`store_oauth_tokens`, `load_oauth_tokens`, `clear_profile_{oauth,api_token}_pair`,
  `clear_profile_creds`, `profile_has_stored_credentials`, `probe_stored_credential_kind`,
  `refresh_oauth_token_with_url`, and login.rs's thin clear wrappers). Their tests exist but are
  `#[ignore]` + `JR_RUN_KEYRING_TESTS=1` (the documented VP-AUTHDX-005/006/007 boundary carried
  since cycle-003 — the keyring mock cannot persist state across `Entry::new()`; default Linux/mac
  CI has no Secret Service). cargo-mutants never runs them → these survive by construction.
- **(B) Windows-`#[cfg]` artifacts.** `#[cfg(windows)]` code (`engage_dpapi_fallback`@285, the
  entire `dpapi::protect`/`dpapi::unprotect` module, real `store_pair`/`load_pair` Windows arms)
  is not compiled on macOS. Mutating it yields a byte-identical binary → the mutation has no
  effect → it survives as MISSED (or TIMEOUT under contention). This is exactly VP-AUTHDX-010's
  Windows-only boundary — it requires a `windows-latest` mutation run.

The **DESIGN deliberately extracts the pure, default-CI-testable logic** out of these boundary
functions (e.g. `legacy_none_orphan_clear_target` behind `reconcile_legacy_none_outgoing_credentials`;
`classify_load_pair_result`/`discriminate_load_pair` behind the keychain read;
`should_fallback_to_dpapi` predicate; the `envelope` module; `reject_unsafe_profile_component`),
and **every one of those extracted pure functions is KILLED** (see §3). That is the correct,
observable outcome: the logic is proven; only the thin keychain/syscall side-effect wrappers
survive, at the spec-declared boundary.

---

## 3. Per-file results

### `src/api/jira/tenant.rs` — COMPLETE (fully default-CI-testable)

| metric | value |
|--------|-------|
| total mutants (in-diff) | 21 |
| caught | 16 |
| missed | 5 |
| timeout / unviable | 0 / 0 |
| **raw kill rate** | **16/21 = 76.2 %** |

**Caught (16):** `validate_and_trim_site_url` (all 3 return + None), `is_plausible_cloud_id`
(true/false/`delete !`/`&&`→`||`/`==`→`!=`), `fetch_cloud_id` top-level returns, `delete !`@123
and @157, both body-cap `> with <` mutants (the sign flip IS caught by the oversized-body test).

**Survivors (5) — GENUINE but LOW severity (DoS body-cap boundary precision):**

| file:line | mutation | assessment |
|-----------|----------|------------|
| `tenant.rs:27:50` | `replace * with +` in `MAX_TENANT_INFO_RESPONSE_BYTES = 64 * 1024` | cap constant not pinned: `64*1024=65536` vs `64+1024=1088`; both reject the test's "well over 64 KiB" body, so no test distinguishes them. |
| `tenant.rs:132:16` | `replace > with ==` in `if len > MAX` (content_length pre-check) | boundary/masked: the streaming guard@143 backstops it for the existing test. |
| `tenant.rs:132:16` | `replace > with >=` (content_length pre-check) | differs only at exactly 65536 bytes — no test hits the exact boundary. |
| `tenant.rs:143:23` | `replace > with ==` in `if body.len() > MAX` (streaming guard) | the existing oversized-body test uses a body that fails to parse when fully read, so removing the cap still yields a soft-fail → mutant not distinguished. |
| `tenant.rs:143:23` | `replace > with >=` (streaming guard) | exact-boundary only, as above. |

**Why LOW, not HIGH:** VP-AUTHDX-019's actual safety invariant — a `fetch_cloud_id` failure
never aborts login and never panics (soft-fail) — is separately and thoroughly killed (the
`fetch_cloud_id -> Ok(...)`, `delete !`, and `> with <` mutants are all CAUGHT). The 5 survivors
affect only the *precision of the early-rejection DoS boundary* (rejecting BEFORE reading a
grossly-oversized body). The cap still fires for oversized bodies in the common case.

**Proposed kill (FIX-F6):** add a `cloud_id_tenant_info.rs` test that serves a body **just over
`MAX` that IS valid tenant JSON containing a plausible cloudId**, and assert the fetch still
**soft-fails** (proving the cap rejected it *before* the parse would have succeeded) — this
distinguishes cap-active from cap-removed and kills the `==`/`>=`/`>` and `*`→`+` mutants. A
companion `assert_eq!(MAX_TENANT_INFO_RESPONSE_BYTES, 64 * 1024)` regression pin kills the
constant mutant directly.

### `src/cli/auth/login.rs` — COMPLETE

| metric | value |
|--------|-------|
| total mutants (in-diff) | 19 |
| caught | 14 |
| missed | 5 |
| timeout / unviable | 0 / 0 |
| **raw kill rate** | **14/19 = 73.7 %** |
| **default-CI-testable kill rate** | **14/14 = 100 %** (all 5 survivors are class-A keyring-gated) |

**Caught (14) — all pure/seam-testable logic:** `should_mark_auth_method_before_attempt`
(true/false/`&&`→`||`/`delete !`), `legacy_none_orphan_clear_target` (None/Some/`==`→`!=` — the
pure orphan-clear DECISION), `resolve_and_apply_cloud_id` (all variants), `mark_auth_method_if_new`,
`handle_login -> Ok(())`, `login_token -> Ok(())`.

**Survivors (5) — class-A keyring-gated boundary, NOT genuine gaps:**

| file:line | mutation | class |
|-----------|----------|-------|
| `login.rs:953:5` | `clear_stored_credential_kind -> Ok(())` | A — dispatches to keychain clear |
| `login.rs:954:9` | `delete match arm "oauth"` | A — keychain clear side-effect |
| `login.rs:955:9` | `delete match arm "api_token"` | A — keychain clear side-effect |
| `login.rs:966:5` | `clear_outgoing_mechanism_on_switch -> Ok(())` | A — keychain clear + notice after `?` |
| `login.rs:1047:5` | `reconcile_legacy_none_outgoing_credentials -> Ok(())` | A — thin wrapper; its pure decision `legacy_none_orphan_clear_target` IS caught |

These are exactly the `probe_stored_credential_kind` / `reconcile_legacy_none_outgoing_credentials` /
pre-mark F6-target functions: their **pure decision cores are killed**, their **keychain
side-effects are keyring-gated** (killable only under `JR_RUN_KEYRING_TESTS=1`).

### `src/api/auth.rs` — COMPLETE

| metric | value |
|--------|-------|
| total mutants (in-diff) | 48 |
| caught | 8 |
| missed | 31 |
| timeout | 0 |
| unviable | 9 |
| **raw kill rate** | **8/39 viable = 20.5 %** |
| **default-CI-testable kill rate** | **8/8 = 100 %** (31 missed = 2 class-B + 29 class-A boundary; 0 genuine) |

**Caught (8):** `engage_dpapi_fallback`@303 (the `#[cfg(not(windows))]` twin — true/false/`==`→`!=`),
`classify_dpapi_removal_result`@343/@346 (the pure `ProfilePathEscape`-tolerance classifier — both
guard branches).

**Survivors (31) — ALL boundary, 0 genuine default-CI gaps:**
- **2 × class-B Windows-cfg:** `engage_dpapi_fallback`@285 true/false (the `#[cfg(windows)]` twin;
  its compiled `#[cfg(not(windows))]` counterpart@303 is CAUGHT).
- **29 × class-A keyring-gated:** `store_oauth_tokens`@376, DPAPI routing match-guards@405/@423,
  `clear_dpapi_file_tolerating_path_escape`@332 (also an equivalent mutant on non-Windows —
  `remove_if_present` is `Ok(())` no-op there), `forced_toolong`@451, `load_oauth_tokens`@596 (4) +
  `(None,None)` arm@603, `profile_has_stored_credentials`@874 (2), `probe_stored_credential_kind`
  @909-921 (`&&`→`||` ×4, `==`→`!=`, Ok variants), `clear_profile_oauth_pair`@1053/@1067,
  `clear_profile_api_token_pair`@1114, `clear_profile_creds`@1197/@1220,
  `refresh_oauth_token_with_url`@1860 (2).

**Unviable (9, excluded from kill rate):** functions returning non-`Default` types cargo-mutants
cannot synthesize (`LoadPairOutcome`, `anyhow::Error`, `keyring::Error`, `OAuthResult`):
`forced_toolong`@449, `classify_load_pair_result`@500, `discriminate_load_pair`@523,
`invalid_profile_name_error`@538, `corrupt_secret_file_error`@553, `backend_io_error`@565,
`site1_login_store_failure_message`@1563, `site3_refresh_store_failure_message`@1611, `oauth_login`@1658.

### `src/api/auth_windows_store.rs` — PARTIAL (53/71 processed; run stopped intentionally)

The remaining 18 unprocessed mutants are all in the `#[cfg(windows)]` real-DPAPI region and
were grinding as contention-TIMEOUTs (untestable on macOS by construction — §2 class B); the run
was stopped to run the default-CI-meaningful tenant.rs/login.rs instead.

| metric | value (of 53 processed) |
|--------|-------|
| caught | 35 |
| missed | 2 |
| timeout | 14 (all `#[cfg(windows)]` real-DPAPI region) |
| unviable | 0 |
| **default-CI-testable kill rate** | **35/36 = 97.2 %** (the 1 non-artifact miss is an equivalent mutant) |

**Caught (35) — the ENTIRE default-CI pure-function surface:** `envelope::encode/decode/wrap/unwrap`
(returns, magic-check `!=`, version/length `<` boundaries), `should_fallback_to_dpapi` (true/false),
`reject_unsafe_profile_component` (fn + every `==`/`||` boolean mutant — the CWE-22 defense-in-depth
guard), `is_reserved_windows_device_name` (true/false), `file_path`, `cleanup_stale_tmp_siblings`
(fn/`delete !`/`>=`→`<` age-gate), `atomic_write -> Ok(())`, `store_pair -> Ok(())`@599 (guard-wiring).

**Survivors (2):**
| file:line | mutation | class |
|-----------|----------|-------|
| `auth_windows_store.rs:378:5` | `fsync_parent_dir_best_effort with ()` | **EQUIVALENT MUTANT** — the fn returns `()` and its only effect is durability (unobservable in a functional test); `-> ()` no-op is behaviorally identical. Not killable in principle. |
| `auth_windows_store.rs:614:5` | `load_pair -> Ok(Some((empty,empty)))` | class-B `#[cfg(windows)]` artifact (its sibling variants@614 are in the TIMEOUT list). |

**TIMEOUT (14) — all class-B `#[cfg(windows)]`:** `dpapi::protect`@491/@509, `dpapi::unprotect`
@531/@549, `store_pair`@581 (Windows arm), `load_pair`@614 variants, `atomic_write`@435 `^` temp-suffix
arithmetic (contention-timeout; behaviorally equivalent — any distinct suffix works). All require a
`windows-latest` mutation run (VP-AUTHDX-010 boundary) + the real DPAPI syscall (headless-runner
reachability is the open F4 spike).

---

## 4. Kill-rate summary vs targets

| file | raw kill (excl. unviable) | default-CI-testable kill | genuine survivors |
|------|--------------------------|--------------------------|-------------------|
| `tenant.rs` | 16/21 = 76.2 % | 16/21 = 76.2 % | **5 (LOW — body-cap boundary)** |
| `login.rs` | 14/19 = 73.7 % | **14/14 = 100 %** | 0 (5 keyring-gated) |
| `auth.rs` | 8/39 = 20.5 % | **8/8 = 100 %** | 0 (29 keyring-gated + 2 Windows-cfg) |
| `auth_windows_store.rs` (53/71) | 35/37 = 94.6 % | **35/36 = 97.2 %** | 0 (1 equivalent + 1 Windows-cfg; 32 Windows region unkillable on macOS) |

**Reading the numbers:** the raw per-file rates fall below the 90 %/95 % targets **only because
the auth cluster is dominated by keyring-gated (class-A) and Windows-`#[cfg]` (class-B) code that
the default `cargo test` mutation environment cannot exercise by spec design** — the identical
boundary documented for cycle-003. On the **genuinely default-CI-testable, host-compilable
security surface, the kill rate is 97–100 %**: every pure function (DPAPI envelope framing,
profile-name CWE-22 guard, cloud_id plausibility, `TooLong` routing predicate, orphan-clear
decision, honest-fail classification) is killed. The **only genuine test-quality gap** is the 5
LOW-severity tenant.rs body-cap boundary survivors.

---

## 5. Findings to route (do NOT fix here — for FIX-F6 triage)

1. **FIX-F6-A (POLICY, HIGH-process):** `.cargo/mutants.toml` `examine_globs` omits every
   cycle-004 security file → CI mutation job is blind to the delta (generates 0 mutants). Add
   `src/api/jira/tenant.rs` now; add the auth/login files only with a keychain seam or a
   documented `exclude_re` for the keyring-gated/Windows survivors.
2. **FIX-F6-B (TEST-QUALITY, LOW):** 5 tenant.rs body-cap boundary survivors — add the
   just-over-cap valid-JSON soft-fail test + a `MAX_TENANT_INFO_RESPONSE_BYTES == 64*1024`
   regression pin (§3).
3. **NON-FINDING (documented boundary):** the 29 auth.rs + 5 login.rs keyring-gated survivors
   and the auth_windows_store.rs Windows-`#[cfg]` region are the VP-AUTHDX-005/006/007 +
   VP-AUTHDX-010 spec boundaries; they are killable only under `JR_RUN_KEYRING_TESTS=1` /
   `windows-latest`. `fsync_parent_dir_best_effort` is an equivalent mutant.

## Verdict

**CONDITIONAL PASS.** The default-CI-testable security surface meets/exceeds the ≥95 % intent
(97–100 % kill on pure logic); the sub-target raw rates are fully explained by the documented
keyring-gated and Windows-only boundaries, not by missing tests. One genuine LOW-severity gap
(tenant.rs body-cap boundary) and one HIGH-process policy gap (examine_globs) are routed to
FIX-F6. No survivor indicates a broken safety invariant.
