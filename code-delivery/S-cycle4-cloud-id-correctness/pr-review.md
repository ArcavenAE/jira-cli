## Fresh-eyes PR review — PR #769

**Verdict: APPROVE.** No blocking findings. Eight non-blocking items below (7 suggestions, 1 nit).

I reviewed all 13 changed files in the diff and independently re-ran the verification locally against the branch: `cargo clippy --all-targets -- -D warnings` clean, `cargo fmt --all -- --check` clean, `cargo test --lib` green (1336 passed, 3× consecutive runs), and the two new integration binaries green (`cloud_id_tenant_info`: 10 passed / 3 ignored; `jr_tenant_info_url_release_gate`: 2 passed).

### What I verified (no rubber-stamp)

**Fallback chain (`src/cli/auth/login.rs::resolve_and_apply_cloud_id`, L206–300)** — read line by line, all three properties hold structurally, not just by test:

- *Override precedence*: L213–223 early-returns before any fetch. The unit tests strengthen this correctly by pointing `url` at `"not-a-real-url"`, so a green test genuinely proves the fetch was skipped rather than that it happened to succeed.
- *Soft-fail-never-aborts*: the function's return type is `Option<String>`, not `Result`, and its body contains no `?` operator on any fallible expression — a fetch failure is structurally incapable of propagating into `login_token`. `login_token` (L136) discards the return value. This is a stronger guarantee than "there is a test for it."
- *Preserve-vs-clear*: `p.cloud_id` is assigned in exactly two places (L222 override, L268 fetch-success). The `Err` arm (L272–288) computes a diagnostic string only and never touches the profile. A bare-clear is therefore not reachable, which is the right way to satisfy BC-1.2.053 Postcondition 2.
- *Mechanism switch*: correctly implemented as an emergent property of "success overwrites unconditionally" with zero switch-detection code. I confirmed `clear_outgoing_mechanism_on_switch` does not touch `cloud_id` (keychain only, no config write), and that `handle_login` performs no config save after `login_token` returns — so the write at L136 is not clobbered downstream.

**Human-mode-only gating** — correct and, more importantly, correct *by construction*. The MED-B single-tail-gate refactor (L292–300) is the right call: `diag` is computed independently of `output`, one gate decides, and `eprintln!` fires iff `Some` is returned. There is exactly one `eprintln!` in the function, pinned by `test_adv_low1_resolve_cloud_id_source_has_no_stdout_macro_or_write`, which also correctly rejects `write!(stdout)`/`writeln!(stdout)`/`.write_all` shapes that a `println!`-only scan would miss. No leak into JSON paths: `handle_login`'s JSON branch routes through `output::render_json` (JSON render invariant respected), and all three `login_token` call sites thread `output` correctly — `handle_login` (`args.output`), `refresh_credentials` (`*args.output`), `init.rs` (hardcoded `Table`, appropriate since `init::handle()` takes no output param at all).

**Conventions** — no let-chains introduced (MSRV 1.85 safe); `JR_TENANT_INFO_URL` documented in CLAUDE.md's `JR_*` list *and* release-gate-pinned in the same commit (`cd601a4a`), matching the codified doc-fallout convention exactly; `#[cfg(debug_assertions)]` gate present at the single read site and correctly treated as SECURITY-CRITICAL rather than a convenience seam. `fetch_cloud_id`'s security posture (https-only precondition with zero network requests on failure, no `Authorization` header, no query string, `redirect::Policy::none()`, bounded timeout) is each individually pinned by a test, and the no-redirect test correctly asserts *one* request received, not merely that the result is `Err`.

**Absent demo evidence is not a defect here** — `docs/demo-evidence/` was deliberately purged from this repo and gitignored in #708 (relocated to factory-artifacts), so its absence matches current repo convention.

---

### Findings

| # | Severity | Category | Location |
|---|----------|----------|----------|
| 1 | suggestion | correctness | `src/cli/auth/login.rs:213-223` |
| 2 | suggestion | test-isolation | `src/api/client.rs:2675,2690-2694` |
| 3 | suggestion | test-isolation | `src/api/client.rs:2717-2721` |
| 4 | suggestion | code quality | `src/api/jira/tenant.rs:42,63,65` |
| 5 | suggestion | coverage | `tests/cloud_id_tenant_info.rs`, `tests/auth_chosen_flow_reconcile.rs` |
| 6 | suggestion | description/docs | `src/cli/mod.rs:251-256` |
| 7 | suggestion | description/docs | `CHANGELOG.md`, `src/cli/auth/refresh.rs:177-190` |
| 8 | nit | docs | repo-wide ADR citation |

---

#### 1. [SUGGESTION] `--cloud-id` on the API-token path is persisted with zero validation — unlike the OAuth path

`src/cli/auth/login.rs:213-223` writes the override verbatim into `p.cloud_id`. Contrast the OAuth branch: `src/api/auth.rs:132` (`resolve_cloud_id`) validates the override against the `accessible-resources` response and errors when no resource matches.

So after this PR, `jr auth login --cloud-id <typo>` on an API-token profile exits 0, prints nothing unusual, and silently poisons every later Assets/CMDB call — each one hitting `https://api.atlassian.com/ex/jira/<typo>/jsm/assets` and 404ing. `--cloud-id ""` is also accepted, producing a double-slash gateway URL.

The asymmetry is defensible (the api-token path has no resource list to validate against, and adding an HTTP round-trip would defeat the "override = zero HTTP" contract). But the empty/whitespace-only case is free to close and has no legitimate use:

```rust
if let Some(override_value) = cloud_id_override {
    let trimmed = override_value.trim();
    if trimmed.is_empty() {
        return Err(JrError::UserError(
            "--cloud-id must not be empty. Omit the flag to discover it automatically.".into()
        ).into());
    }
    // ...
```

(That does require changing the return type, so an alternative is a clap-level `value_parser` rejecting empty strings on the flag itself — which also fixes the OAuth branch.)

#### 2. [SUGGESTION] The new `client.rs` proptest introduces a *second* `ENV_MUTEX` guarding the same process-global env vars as `config.rs`'s

`src/api/client.rs:2675` declares a module-private `static ENV_MUTEX`; L2693-2694 do `remove_var("JR_BASE_URL")` + `set_var("JR_AUTH_HEADER", ...)` under it.

`src/config.rs:766-771` (`test_base_url_env_override`) sets and then removes `JR_BASE_URL` under a **different** `ENV_MUTEX` — in the **same** `--lib` test binary, on a parallel thread. Two independent locks over one shared mutable resource provide no mutual exclusion at all.

The concrete failure mode is not hypothetical: config's test can set `JR_BASE_URL` in the window between the client proptest's `remove_var` (L2693) and its `from_config` call (L2717). `from_config` then short-circuits into test-override mode and computes `assets_base_url` from the override URL — which is precisely what this proptest's own doc comment says must not happen ("deliberately NOT setting `JR_BASE_URL`, so `from_config` consults the REAL profile's `url`/`auth_method`/`cloud_id`") — flipping the `prop_assert_eq!`. The reverse direction breaks `test_base_url_env_override`.

Separately, the `// SAFETY: ENV_MUTEX held for this whole property test body` comment at L2691 doesn't actually establish what Rust 2024's `set_var` contract requires. That contract is about the *process* ("no other thread concurrently accesses the environment"), and holding a lock that another env-mutating thread does not take does not provide it.

I stress-ran the filtered set 40× and could not reproduce a failure — the window is a couple of instructions wide — so this is a latent flake and a documented-UB pattern, not an observed CI red. But it is the same class of issue this story already fixed once as ADV MED-1 (the `JR_TENANT_INFO_URL` seam race in `tests/cloud_id_tenant_info.rs`), so consistency argues for closing it here or in an immediate follow-up.

Suggested fix: hoist a single crate-wide test env lock (e.g. `#[cfg(test)] pub(crate) static ENV_MUTEX` in `src/config.rs`, or a small `src/test_env.rs`) and have `config.rs`, `client.rs`, and `login.rs`'s `env_mutex()` all acquire that one. Note `login.rs`'s `env_mutex()` is a *third* independent lock; it only guards `JR_TENANT_INFO_URL` so it has no value conflict today, but it shares the same contract concern and should join the same lock.

#### 3. [SUGGESTION] `JR_AUTH_HEADER` leaks on the panic path in the new proptest

`src/api/client.rs:2717` — the `.expect("from_config must succeed: ...")` runs *before* `remove_var("JR_AUTH_HEADER")` at L2721. If `from_config` ever returns `Err`, the env var stays set for the remainder of the test binary, and every subsequent `from_config` in that process silently takes the header-override branch instead of the keychain branch. `JR_BASE_URL` is also removed but never restored.

`tests/cloud_id_tenant_info.rs` gets this right everywhere (`remove_var` before every assertion) — worth matching. A tiny RAII scope guard, or simply reordering so the `remove_var` block precedes the assertion, closes it.

#### 4. [SUGGESTION] `fetch_cloud_id` validates a trimmed `site_url` but builds the request URL from the untrimmed one

`src/api/jira/tenant.rs:42` checks `site_url.trim().to_ascii_lowercase().starts_with("https://")`, but L63/L65 build `base` from `site_url.trim_end_matches('/')` — no leading `.trim()`.

This is **not** exploitable: the check trims first, so `" http://evil.example"` is still correctly rejected; and leading whitespace can only make the resulting URL fail to parse (or be stripped by WHATWG URL parsing), never redirect the request. But having the validated expression and the used expression differ is exactly the shape that invites a future reader to misjudge which one is authoritative. Suggest normalizing once:

```rust
let site = site_url.trim();
if !site.to_ascii_lowercase().starts_with("https://") { ... }
// ...
let base = site.trim_end_matches('/').to_string();
```

(L67's second `.trim_end_matches('/')` on `base` is then also redundant on the non-seam path, though it is still needed for the `JR_TENANT_INFO_URL` value.)

#### 5. [SUGGESTION] The `login_token` / `auth refresh` *wiring* has no CI-executing test

All four end-to-end tests — the three in `tests/cloud_id_tenant_info.rs` and `test_ac_007_mechanism_switch_preserves_stale_cloud_id_e2e_real_keychain` in `tests/auth_chosen_flow_reconcile.rs` — are `#[ignore]` + `JR_RUN_KEYRING_TESTS=1`. I confirmed locally that a default `cargo test` reports `3 ignored` for that binary and executes none of them.

What CI actually executes is `resolve_and_apply_cloud_id` in isolation and `fetch_cloud_id` in isolation. The wiring between them — the call at `login.rs:136`, `refresh.rs:177-190` threading `None`/`*args.output`, `init.rs` threading `Table` — is compile-checked only. Deleting the `resolve_and_apply_cloud_id(...)` line from `login_token` would leave the entire default suite green, and BC-1.2.054 (`auth refresh`) in particular has no executing coverage at all.

This is a structural consequence of `login_token`'s real-keychain write and is consistent with the repo's existing gated-tier convention, so it's not a blocker. But a cheap non-gated pin is available using a technique this PR already employs well (`test_adv_low1_resolve_cloud_id_source_has_no_stdout_macro_or_write`): a source-level structural guard asserting `login_token`'s body contains exactly one `resolve_and_apply_cloud_id(` call, and that `refresh.rs` and `init.rs` each contain exactly one `login_token(` call. That closes the "call site silently deleted" hole for the cost of one test.

#### 6. [SUGGESTION] The `--cloud-id` clap help text still describes OAuth-only semantics

`src/cli/mod.rs:251-256`:

> Cloud ID to use when multiple Atlassian orgs are accessible (disambiguates which site to target). Use this in scripts to select the correct org. Run `jr auth login --oauth` interactively first to see available org IDs and names.

`LoginArgs::cloud_id`'s rustdoc was correctly updated in this PR (it no longer claims "Only meaningful when `oauth` is true"), but the user-visible `--help` string was not. After this change the flag is honored on the API-token branch too, where "run `--oauth` first to see org IDs" is misleading advice — an API-token user has no OAuth flow to run. Worth one sentence, e.g. "On API-token profiles this overrides the automatic `tenant_info` lookup."

#### 7. [SUGGESTION] `jr auth refresh` silently overwrites a deliberately-set `cloud_id` — undocumented in the CHANGELOG

`refresh.rs:177-190` hardcodes `cloud_id_override: None` (correct — `RefreshArgs` genuinely has no such flag), and on fetch success `resolve_and_apply_cloud_id` overwrites unconditionally on a path that is silent by design.

Net effect: a `cloud_id` a user set via `jr auth login --cloud-id X` (or by hand in `config.toml`) is replaced by the `tenant_info` value on the next `jr auth refresh`, with no diagnostic and no way to opt out. For API-token profiles the fetched value is almost certainly the correct one — the site URL *is* the site — which is presumably the rationale, and I'm not asking for the behavior to change.

But this is the one way the change can *lose* user-supplied configuration, and neither the CHANGELOG entry nor the rustdoc says the override is non-sticky. The CHANGELOG currently says only "refreshes (rather than leaves stale) a previously-acquired `cloud_id` on fetch success" — worth adding that this also applies to an explicitly-supplied `--cloud-id`, which is not "acquired" in the same sense.

#### 8. [NIT] ADR-0022 is cited throughout but does not exist in the tree

`ADR-0022` is referenced ~40 times across `src/api/jira/tenant.rs`, `src/cli/auth/login.rs`, `src/cli/auth/refresh.rs`, `src/config.rs`, `src/api/client.rs`, the new test files, `CHANGELOG.md`, `CLAUDE.md`, and the PR description ("ADR-0022 documents the design"). `docs/adr/` contains only `0001`–`0016`, and no file matching `0022` exists anywhere in the repository.

ADR-0017, ADR-0018, and ADR-0021 are in the same state (cited in CLAUDE.md/CHANGELOG, absent from `docs/adr/`), so this is repo-wide drift that this PR follows rather than introduces — and nothing is actually unreviewable, because the design and security rationale it points at are fully restated in `tenant.rs`'s module/function rustdoc and in CLAUDE.md's `JR_TENANT_INFO_URL` entry. Flagging only because CLAUDE.md's own "Citation form in spec/CLAUDE.md" convention exists to prevent exactly this, and the PR description asserts a document a reviewer cannot open. If ADRs 0017+ now live outside `docs/adr/`, a one-line pointer in `docs/adr/` (or in CLAUDE.md's "Key Decisions" list, which still stops at ADR-0016) would resolve the whole family.

---

### Diff size note

2121 additions is above the usual 500-line review threshold, but the production delta is roughly 130 lines (`tenant.rs` 78, `resolve_and_apply_cloud_id` ~95, three call-site updates). The remainder is tests (~1400) and doc comments. Not flagged.
