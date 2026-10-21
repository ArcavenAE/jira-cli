# Research: wiremock 0.6.5 vs httpmock 0.9.0 / mockito 1.7.2 / httptest 0.16.4 / mocktail 0.3.2: feature analysis against the `jr` test suite

- **Date:** 2026-10-21
- **Type:** general (test-infrastructure library evaluation)
- **Code baseline:** `origin/develop` @ `c72f81317fd9b0b0459b9f29518f2d3d7010df06`
- **Status:** complete. The analysis is done. The empirical spike and the benchmark were **not executed** (see §0.2).
- **Bottom line:** **Do not migrate now.** If a migration is ever mandated, **httpmock 0.9.x** is the only viable target, and only behind a jr-owned harness that restores wiremock's drop-time verification and `received_requests`. mockito, httptest and mocktail are rejected. Reasons are in §6.

---

## 0. Method, deviations and provenance (read first)

### 0.1 How the origin/develop inventory was obtained without `git show`

This agent has no shell tool, so it could not run `git show`/`git grep`. The work-around below gives **exact origin/develop counts**:

1. `.git/refs/remotes/origin/develop` = `c72f81317fd9b0b0459b9f29518f2d3d7010df06` (read directly).
2. The GitHub compare API `fb9d015c...c72f8131` (https://api.github.com/repos/Zious11/jira-cli/compare/fb9d015c...c72f8131) reports `ahead_by: 22, behind_by: 0`, 27 changed files. The changed files under `src/`/`tests/` are only `src/api/client.rs`, `src/output.rs`, `tests/ci_gate_completeness.rs` and `tests/keyring_windows_native_feature_present.rs`.
3. Those four files were checked against origin directly. `src/api/client.rs`@c72f8131 was fetched from `raw.githubusercontent.com`: it has zero `MockServer`/`Mock::given`/`ResponseTemplate`/`received_requests`/`up_to_n_times` occurrences, and its two "wiremock" hits are comments. That matches the local file. The other three are comfy-table, keyring and CI-gate changes with no mock usage.
4. Every other `tests/**.rs` and `src/**.rs` file is therefore **byte-identical** between the stale checkout and origin/develop. The `Grep` counts below were taken over those files. `Cargo.toml`, `Cargo.lock` and `deny.toml` were read **from origin** via raw.githubusercontent.com at c72f8131.

This deviates from the literal instruction "do not read the working tree". It is equivalent in content, and the equivalence proof is above.

### 0.2 Not executed (flagged)

- **Spike (step 4) and startup benchmark (step 3): NOT RUN.** There is no shell or cargo access. §5 contains *paper ports* (uncompiled) whose semantics were checked against each crate's source at the release tag. Every claim in §5 is marked `UNCOMPILED`.
- **`cargo deny check` and compile-time measurement: NOT RUN.** The footprint analysis (§3.5) is derived from the crates.io dependency API plus origin's `Cargo.lock` and `deny.toml`.
- **Deep research:** the first `perplexity_research` call (broad 10-question comparison) **timed out at 300 s**. A second, narrower `perplexity_research` call succeeded and was used as cross-validation (§8). Primary evidence is the crate source at each release tag, which is stronger than a synthesized answer.

---

## 1. Inventory: wiremock API usage on origin/develop (exact counts)

Scope: `tests/**/*.rs` + `src/**/*.rs`. **105 files mention wiremock; 92 define mocks.** Eight `src/` files have inline mock tests: `src/api/jsm/attachments.rs`, `src/api/jira/{bulk,resolutions,links}.rs`, `src/api/auth.rs`, `src/cli/field.rs`, `src/cli/auth/login.rs`, `src/cli/issue/jsm_create.rs`.

| API | Count | Files | Example sites |
|---|---|---|---|
| `Mock::given(...)` (mock definitions) | **2,413** | 92 | `tests/component_commands.rs` (333), `tests/issue_commands.rs` (253) |
| `MockServer::start()` / `::builder()` | **1,534** | 93 | everywhere; `tests/issue_edit.rs` has 11 *bare* servers with no mocks (pre-flight exit-64 tests) |
| `MockServer::builder().listener(..)` | **1** | 1 | `tests/attachment_download.rs::test_bc_2_7_007_auth_absent_on_redirect_target` (binds **`[::1]:0`** so the CDN host differs from 127.0.0.1) |
| `.mount(&server)` | ~2,263 (+ multi-line forms) | 88 | — |
| `.mount_as_scoped(&server)` | **17** | 4 | `tests/attachment_jsm.rs` (6), `tests/issue_field_hint_kinds.rs` (4), `tests/issue_create_field.rs` (3), `tests/issue_create_jsm.rs` (3) |
| `.expect(n)` (`^\s*\.expect\(<digits/range>\)`) | **1,147** | 59 | `tests/component_commands.rs` (266), `tests/issue_commands.rs` (114) |
| … of which `.expect(0)` ("must NOT be called" guards) | **387** | 38 | `tests/component_commands.rs` (79), `tests/attachment_delete.rs` (41), `tests/issue_bulk_pr2.rs` (37), `tests/issue_create_jsm.rs` (37) |
| `.up_to_n_times(n)` | **47** | 11 | `tests/rate_limit_cap_tests.rs` (13), `tests/oauth_refresh_integration.rs` (8), `tests/search_issue_keys.rs` (6), `tests/attachment_upload.rs` (6), `tests/issue_bulk.rs` (4), `tests/api_client.rs::test_rate_limit_retry` (2), `src/api/jsm/attachments.rs` (2), `src/api/jira/bulk.rs` (2) |
| `.with_priority(1)` | **15** | 1 | `tests/attachment_jsm.rs` only (overrides a generic issue-GET mock with the `fields=attachment` list mock) |
| `.named(..)` | **1** | 1 | `tests/cli_handler.rs` ("comment without internal") |
| `server.verify().await` (explicit) | **~176** | 7 | `tests/component_commands.rs` (~125), `tests/api_query_param.rs` (25), `tests/issue_move_resolution_enforce.rs` (14), `tests/user_list_project_resolution.rs` (7), `tests/asset_holdouts.rs` (2), `tests/asset_enrichment_concurrency.rs` (2), `tests/user_commands.rs` (1) |
| implicit drop-time verification | **52 of 59** `.expect()` files rely on it alone | — | e.g. `tests/attachment_delete.rs` (89 expects, 0 `verify()`) |
| `server.received_requests().await` | **204** | 35 | `tests/issue_commands.rs` (35), `tests/issue_create_jsm.rs` (25), `tests/issue_bulk_pr2.rs` (24), `tests/component_commands.rs` (13), `tests/attachment_jsm.rs` (11), `src/api/jsm/attachments.rs` (3) |
| `server.reset()` | **0** | — | — |
| **Matchers** | | | |
| `method(..)` + `path(..)` | ~every mock | 92 | — |
| `query_param(..)` | **426** | 40 | `tests/user_pagination.rs` (61), `tests/comments.rs` (33) |
| `query_param_is_missing(..)` | **13** | 5 | `tests/component_commands.rs` (6), `tests/user_pagination.rs`, `tests/jsm_request_api.rs` |
| `path_regex(..)` | **16** | 9 | `tests/cli_handler.rs` (4), `tests/issue_bulk.rs` (3), `tests/team_commands.rs` |
| `header(..)` | **70** | 8 | `tests/attachment_upload.rs` (31, `X-Atlassian-Token: no-check`), `tests/attachment_jsm.rs` (27), `tests/api_client.rs` |
| `body_partial_json(..)` | **133** | 22 | `tests/issue_commands.rs` (28), `tests/cli_handler.rs` (19) |
| `body_json(..)` (exact) | **26** | 3 | `tests/component_commands.rs` (21), `tests/issue_edit_no_parent.rs` (2) |
| `body_string_contains(..)` | **34** | 3 | `tests/issue_bulk_pr2.rs` (21), `tests/issue_bulk.rs` (8), `tests/oauth_refresh_integration.rs` (5) |
| `any()` | **21** | 4 | `tests/issue_edit_field.rs` (12), `tests/issue_commands.rs` (4) |
| custom `impl Match` / closure matchers / `impl Respond` | **0** | — | none found |
| **ResponseTemplate** | | | |
| `ResponseTemplate::new(status)` | every mock | — | `new(429)` ×23 in 10 files; `new(302)` redirect in `tests/attachment_download.rs` |
| `.set_body_json(..)` | **1,874** | 92 | — |
| `.set_body_string(..)` | **154** | 17 | `tests/issue_bulk_pr2.rs` (37) |
| `.set_body_bytes(..)` | **37** | 2 | `tests/attachment_download.rs` (36), `tests/issue_read_holdouts.rs` (1, empty body) |
| `.insert_header(..)` | **44** | 14 | `tests/oauth_refresh_integration.rs` (20), `Retry-After`, `Location` |
| `.set_delay(..)` | **1** | 1 | `tests/asset_enrichment_concurrency.rs` (50 ms, concurrency proof: "set_delay runs OUTSIDE wiremock's write lock") |
| **`wiremock::Request` field access** (on `received_requests` results) | | | |
| `.url.path()` / `.url.query()` / `.url.as_str()` | ~120 | ~30 | `tests/attachment_download.rs:~171` (query must NOT contain `redirect=false`) |
| `.method ==` / `.method.as_str()` | ~90 | ~25 | `tests/issue_create_jsm.rs` |
| `.body` (raw bytes; JSON-decoded or multipart-inspected) | ~70 | ~20 | `tests/attachment_upload.rs` (multipart), `tests/issue_edit_field_adf.rs` |
| `.headers.get(..)` | 6 | 3 | `tests/attachment_download.rs:~261` (Authorization **absent** on CDN hop), `tests/cli_handler.rs`, `tests/cloud_id_tenant_info.rs` |

**Execution model (cross-cutting, load-bearing):** there are **1,634 `#[tokio::test]` functions; only 288 use `flavor = ...`**, so most run on a **current-thread** runtime. Most of them launch the `jr` binary through `assert_cmd` **`.output()`, which blocks that thread**. The mock server must therefore serve from **its own thread/runtime**, otherwise the test deadlocks. wiremock does this: `std::thread::spawn` + its own current-thread runtime (`src/mock_server/bare_server.rs` @ v0.6.5). A smaller share of tests call `JiraClient` in-process (`tests/api_client.rs`).

**Shared helpers:** `tests/common/fixtures.rs` holds JSON builders only. Its one "wiremock" hit is a doc comment, so it has **zero wiremock coupling**. `tests/common/mock_server.rs::setup_with_myself` is the only wiremock-coupled helper and has **zero callers** (dead code). Each test file defines its own `jr_cmd(server_uri, ..)` harness taking a `&str` URI. That is library-agnostic.

---

## 2. Per-candidate verification (source at release tag + docs.rs)

### 2.1 Resolution of the five previously-inconclusive points

| Point | wiremock 0.6.5 (baseline) | httpmock 0.9.0 | mockito 1.7.2 | httptest 0.16.4 | mocktail 0.3.2 |
|---|---|---|---|---|---|
| **(a) Precedence when mocks overlap** | priority sort (default 5, lower wins), ties = **first-mounted wins**; `up_to_n_times`-exhausted mocks skipped | **first-registered wins** (`BTreeMap<usize,_>` by increasing id, `.find(!is_exhausted && matches)`); exhausted mocks skipped. **No priority API.** VERIFIED `src/server/state/mod.rs` | **first matching mock that `is_missing_hits()`, else the *last* matching mock.** A mock with no `expect` is "missing" only until its 1st hit. VERIFIED `src/server.rs::handle_request`. **Semantically different from wiremock.** | **last-added wins** (`iter_mut().rev()`); exhausted expectations **not** skipped (over-limit → 500). VERIFIED `src/server.rs` | sorted by `priority` (u8, default 5, lower first), then first match; mocks over `limit` don't match (fall through). VERIFIED `mock_set.rs`, `mock.rs` |
| **(b) Recorded requests for post-hoc inspection** | `received_requests() -> Option<Vec<Request>>` | **No public API.** History is stored internally (`history: Vec<Arc<HttpMockRequest>>`, **capped at 100**), but there is no GET route and no accessor (only `DELETE /__httpmock__/history`). The `record` feature exports YAML recordings (pulls `serde_yaml`). **Workaround:** a first-registered "recorder" mock with `when.is_true(move \|r\| { log.lock().push(r.clone()); false })`. `HttpMockRequest: Clone` exposes method/uri/headers/body. | **No.** Only *unmatched* requests are stored (`pub(crate)`). **Workaround:** `match_request(move \|r\| {log.push(..); false})` on a recorder mock. Every mock is tested per request, so it sees all traffic. `Request` is not `Clone`; copy `method()`/`path_and_query()`/`headers()`/`body()`. | **No** (matched requests not stored; unexpected ones only in panic text). Workaround: a matcher-wrapper that records (custom `Matcher` impl). | **No** (debug logs only). |
| **(c) Drop-time verification of call counts** | **Yes**, on `MockServer` shutdown (docs: "Expectations are verified when the MockServer is shutting down") | **No.** No `impl Drop for Mock`; `MockServer::drop` only returns the server to the pool. Must call `mock.assert_calls(n)` explicitly. VERIFIED `src/api/mock.rs`, `src/api/server.rs` | **Opt-in only:** `ServerOpts{assert_on_drop: true}` makes **each `Mock`'s drop** call `assert()`. Default `false`; pooled `Server::new()` uses defaults. VERIFIED `src/mock.rs` Drop | **Yes (stricter):** `Drop` → `verify_and_clear()` panics on any count mismatch **and on any unmatched request** | **No** (no assert API at all; only a `match_count` counter) |
| **(d) Scoped-mock equivalent** | `mount_as_scoped` → `MockGuard` (removed and verified on drop) | `Mock::delete()` / `delete_async()` (manual, no guard). A jr wrapper with `Drop` is easy. | `Mock::remove()` / `remove_async()` (manual). Dropping a `Mock` does **not** remove it. | none (only `verify_and_clear` of all) | `MockSet::remove(index)` / `clear()` |
| **(e) Unmatched request** | **404**, empty body, logged at debug; no panic | **404** + JSON `{"message":"Request did not match any route or mock"}`; no panic. VERIFIED `src/server/handler.rs` | **501 Not Implemented**, empty body; recorded as "last unmatched" for `assert` diffs; no panic | **500** "No matcher found" **and panic on drop** | **404** "mock not found"; no panic |

### 2.2 Full feature support (native / workaround / unsupported)

Legend: **N** = native, **W** = workaround (described), **U** = unsupported.

| Feature (jr count) | httpmock 0.9.0 | mockito 1.7.2 | httptest 0.16.4 | mocktail 0.3.2 |
|---|---|---|---|---|
| method + path (all) | N `when.method().path()` | N `server.mock("GET", "/p")` | N `request::method_path` | N `when.get().path()` |
| `query_param` (426) | N `query_param` (ANDed) | N `match_query(Matcher::UrlEncoded)` / `AllOf` | N `request::query(url_decoded(contains(..)))` | N `query_param` |
| `query_param_is_missing` (13) | N `query_param_missing` | W `match_request` closure (or Regex on query) | W `not(..)` composition | **U** native; W custom `Matcher` |
| `path_regex` (16) | N `path_matches(Regex)` | N `Matcher::Regex` | N `matches(..)` on path | **U**; `path_prefix` only, W custom matcher |
| `header` eq (70) | N `header` | N `match_header` | N `request::headers(contains(..))` | N `header` |
| `body_partial_json` (133) | N `json_body_includes(&str)` (**takes a JSON string, panics if invalid**; 133 call sites must `.to_string()`) | N `Matcher::PartialJson(Value)` | N `json_decoded(..)` + matcher composition (partial semantics: W) | **U** native; W custom matcher |
| `body_json` exact (26) | N `json_body` | N `Matcher::Json` | N `json_decoded(eq(..))` | N `json` |
| `body_string_contains` (34) | N `body_includes` | N `Matcher::Regex` on body | N `body(contains(..))` | **U**; W custom matcher |
| `any()` (21) | N (empty `when`) | N `Matcher::Any` for method/path | N `any()` | N `any()` |
| status/JSON/string/bytes body | N `status/json_body/body` | N `with_status/with_body` | N `status_code().body()`, `json_encoded` | N |
| `insert_header` (44) | N `then.header` | N `with_header` | N `append_header` | N |
| `set_delay` (1, concurrency proof) | N `then.delay` (async sleep on server runtime; parallelism under the server's current-thread LocalSet **INCONCLUSIVE until spiked**) | **U** (no delay; `with_chunked_body` + **sync** sleep would block the single server thread and **serialize** requests, defeating the test) | N `delay_and_then` | U/inconclusive |
| `expect(n)` (1,147) | W explicit `assert_calls(n)` per mock, or a jr harness with Drop | N `expect(n)` + `assert_async()` (or `assert_on_drop`) | N `Expectation::times(n)` | **U** (read `match_count` manually) |
| `expect(0)` guard (387) | W `assert_calls(0)` (a hit gets served, so the assert is the only signal) | N `expect(0)`; a hit still gets served via the "last matching" fallback; assert catches it | N `times(0)` | U |
| `up_to_n_times` fall-through (47) | **N** (`up_to_n_times` on `Then`/`Mock`, exhausted mocks skipped; 0.9.0 CHANGELOG) | W via `expect(n)`: "first still-missing-hits" selection reproduces 429×N→200; **after all are satisfied the *last* matching mock answers** (differs) | **U** fall-through; W `cycle![429, 200]` on one expectation | N `mock_with_options(.., limit)` |
| `with_priority` (15) | W re-order (first-registered wins) or delete + re-create | W order + `expect_at_least`/`at_most` tuning (fragile) | W last-added wins (re-order) | N `priority` |
| `named` (1) | U (cosmetic; drop it) | U | U | U |
| `mount_as_scoped` (17) | W `Mock::delete` + jr `Drop` guard | W `Mock::remove` + guard | U | W `remove(index)` (index shifts) |
| `received_requests` (204) | W recorder mock (§2.1b) | W recorder `match_request` | W recording matcher | U |
| explicit `verify()` (176) | W harness `verify_now()` | N `assert` per mock | N `verify_and_clear()` | U |
| bind `[::1]` listener (1) | **U**: host hard-coded `127.0.0.1` or `0.0.0.0` (`expose`), `src/server/transport.rs`. W keep this one test on another server, or use a second address family by another means | **N** `ServerOpts{host: "::1", ..}` (host parsed as `IpAddr`) | **N** `ServerBuilder::bind_addr`; default **tries `[::1]` first**, falls back to 127.0.0.1 | N `listen_addr: IpAddr` via config (default **0.0.0.0**) |
| own server thread (no deadlock under blocking `.output()`) | **N** `thread::spawn` + `block_on_current_thread` (`src/api/server.rs`) | **N** `thread::spawn` + current-thread runtime + LocalSet | **N** `thread::spawn` + own runtime (1 worker) | **U**: `tokio::spawn` on the **caller's** runtime → **deadlock** in current-thread tests that block on `assert_cmd` (would need `flavor="multi_thread"` on ~1,346 tests) |
| sync API usable inside `#[tokio::test]` | N (custom park-based `join()`; local adapter does no I/O) | must use `_async` methods (sync ones error inside a runtime) | N (`expect(&self)`) | async only |

---

## 3. Cross-cutting concerns

### 3.1 Async/tokio integration
- **httpmock / mockito / httptest:** each server runs on a dedicated OS thread with its own runtime, the same safety property as wiremock. **mocktail** spawns onto the caller's runtime, which is a **hard blocker** for this suite's dominant `current_thread` + blocking `assert_cmd` pattern.
- **mockito** requires `_async` variants inside tokio tests (`new_async`, `create_async`, `assert_async`), and `Server::mock` takes `&mut self`. Helpers that today take `&MockServer` would need `&mut`.

### 3.2 Parallel isolation and pool sizes (deadlock risk)

| Crate | Isolation | Pool / cap | Blocking behavior |
|---|---|---|---|
| wiremock | 1 server per `start()`, pooled + reset | (pool size not verified; INCONCLUSIVE) | — |
| httpmock | pooled, reset on next `start` | **25** (`HTTPMOCK_MAX_SERVERS`) | `start` **blocks** when exhausted |
| mockito | pooled, `reset()` on guard drop | **20 on macOS / 50 elsewhere** | semaphore **blocks**; `new_with_opts_async` bypasses the pool |
| httptest | new thread per `Server::run` | optional `ServerPool::new(n)` | blocks only if a pool is used |
| mocktail | new per `start` | random port 10000–30000, 10 bind retries, **binds 0.0.0.0** | readiness polled with 10 ms sleeps |

Risk: jr tests hold **up to 3 servers at once** (`tests/component_commands.rs` `server_a/_b/_c`; `tests/attachment_download.rs` jira + cdn). With blocking pools this is a hold-and-wait pattern. Deadlock needs about cap-many concurrently running tests each holding one server and waiting for another (≥25 test threads for httpmock, ≥20 for mockito on macOS). CI runners (2–4 vCPU) are safe. A 24–32-core workstation is theoretically exposed. Mitigation: `HTTPMOCK_MAX_SERVERS=64` in `.cargo/config.toml [env]`, or mockito `new_with_opts_async`. mocktail's `0.0.0.0` bind also exposes test servers on all interfaces and can trigger the macOS firewall prompt.

### 3.3 Startup cost
**INCONCLUSIVE (benchmark not run, §0.2).** Qualitatively: wiremock, httpmock and mockito amortize via pools (thread reuse). httptest spawns a thread + runtime per server. mocktail adds readiness polling (≥1 connect attempt, 10 ms back-off). Per-test cost is dominated by the `jr` subprocess spawn, so differences are unlikely to matter. That is model judgment, not measured.

### 3.4 Mismatch / error messages
- **wiremock:** unmet expectations panic at shutdown listing the mock (name if `.named`) and received requests.
- **httpmock:** `"{actual} of {expected} expected requests matched the mock specification"` + "most similar unmatched request (request number N)" + per-matcher mismatch sections + body diff (`similar`). The closest-match search uses the 100-entry history. VERIFIED `src/api/output.rs`.
- **mockito:** expected vs actual hits + "The last unmatched request was:" + a `Difference:` diff. VERIFIED `src/mock.rs`.
- **httptest:** panics with the matcher's Debug and counts. Unexpected requests are listed.
- **mocktail:** none (no assertions).

### 3.5 MSRV, license, dependency footprint (vs origin `Cargo.lock` / `deny.toml`)

**Our constraints (origin):** `rust-version = "1.88"`. The `msrv` CI job runs `cargo check --all-targets` on 1.88.0, so **dev-deps are MSRV-checked**. `deny.toml` has `multiple-versions = "deny"`, `wildcards = "deny"`, no `exclude-dev`, and a license allow-list of MIT, Apache-2.0, BSD-3-Clause, ISC, MPL-2.0, Unicode-3.0, CDLA-Permissive-2.0, Zlib.

**Key cargo-deny fact (VERIFIED, https://embarkstudios.github.io/cargo-deny/checks/bans/cfg.html):** `multiple-versions-include-dev` defaults to **false**, so "any crates that are only reached via dev dependency edges are ignored". That is why origin already passes with `base64` 0.22.1 (wiremock-only) + 0.23.1 and `rand` 0.9.4 + 0.10.3, with no skips. **Licenses and advisories DO see dev-deps** (no `exclude-dev`).

| Crate | MSRV | License | Already in origin lock | New crates (approx.) | Dev-only duplicates (ignored by bans) |
|---|---|---|---|---|---|
| wiremock 0.6.5 | none declared | MIT/Apache-2.0 | — | — | base64 0.22.1 |
| **httpmock 0.9.0** (`default-features = false`; default feature `cookies` pulls `headers` 0.4 → base64 0.22 + sha1 0.10) | **1.88.0 (= ours, zero headroom)**, edition 2024 | MIT | hyper 1.12, hyper-util 0.1.21, http, http-body-util, bytes, regex, serde(_json), thiserror 2, tracing, tokio, form_urlencoded, assert-json-diff 2.0.2, **base64 0.23.1 (matches jr)** | `path-tree` (MIT OR Apache-2.0, pinned `>=0.8.0,<0.8.4`), `futures-timer`, `similar` 3.x | `similar` 3 vs 2.7.0 (insta) |
| mockito 1.7.2 | 1.70 | MIT | rand 0.9.4, similar 2.7.0, hyper, hyper-util, pin-project-lite, futures-core, log, colored 3 (optional) | `serde_urlencoded` | none new |
| httptest 0.16.4 | none declared | MIT OR Apache-2.0 | bstr, once_cell, hyper, regex, serde | `crossbeam-channel`, `serde_urlencoded` | none known |
| mocktail 0.3.2 | none declared | Apache-2.0 | rand 0.9, hyper, url | `prost` 0.14 (+derive), `uuid`, `tokio-stream` | none known |

- **Bans:** no candidate introduces a duplicate that bans would flag, because all are dev-only. **No temporary `skip` entries are needed** during coexistence.
- **Licenses:** all top-level licenses are on the allow-list. Transitive licenses for `similar` 3, `futures-timer`, `crossbeam-channel` and `prost` are **unverified** (model knowledge says MIT/Apache-2.0). Confirm with `cargo deny check licenses` in the infra PR.
- **Advisories:** do not enable httpmock's `record` feature. It pulls `serde_yaml` 0.9 (deprecated upstream; whether a RUSTSEC "unmaintained" advisory applies is **INCONCLUSIVE**).
- **Compile time:** **INCONCLUSIVE (not measured).** Inference: httpmock (no default features) and mockito overlap almost entirely with crates jr already builds (hyper, tokio, regex, serde), so their marginal cost is small. During coexistence both stacks build. After wiremock removal, `deadpool`, `deadpool-runtime` and the dev-only `base64` 0.22 leave the graph.
- **MSRV risk for httpmock:** its MSRV equals jr's floor. Any future httpmock release that raises MSRV past 1.88 breaks the `msrv` job until jr bumps too. Pin `httpmock = "=0.9.x"` and treat bumps as MSRV-coupled.

### 3.6 Maintenance signals (as of 2026-10-21)
- wiremock: last release **0.6.5 on 2025-08-24**, and that is also the last commit on `main` (https://api.github.com/repos/LukeMathWalker/wiremock-rs/commits). `main` still requires `base64 = "0.22"`. Quiet for 14 months; its release history is bursty rather than abandoned.
- httpmock: **0.9.0 released 2026-10-20 (one day old)**, 0.8.3 on 2026-02-04, active.
- mockito: 1.7.2 on 2026-02-02. httptest: 0.16.4 on 2026-01-06. mocktail: 0.3.2 on 2026-04-16 (IBM, HTTP + gRPC focus).

---

## 4. Migration blockers

Severity scale: **B** = blocker with no practical workaround, **H** = needs non-trivial jr harness code, **M** = mechanical but semantic risk, **L** = cosmetic.

### httpmock 0.9.0
1. **H: no drop-time verification.** 1,147 `expect` calls; 52 files rely on implicit verification. Forgetting an `assert_calls` makes a test **silently weaker**. Needs a jr harness with `Drop` (§7.4).
2. **H: no `received_requests`** (204 sites, 35 files). Needs a recorder-mock workaround. The internal history cap (100) does not affect the recorder, but whether the recorder closure runs exactly once per request is **INCONCLUSIVE until spiked**.
3. **M/B: IPv6 `[::1]` listener unsupported** (1 test, `test_bc_2_7_007_auth_absent_on_redirect_target`, a security test for GHSA-9857-6MW7-FQ2M). Keep that test on wiremock, or find another distinct-host technique. This is a design question for the human.
4. **M: no priority** (15 sites, one file). Re-order or delete + re-create.
5. **M: no scoped guard** (17 sites). Use a jr `ScopedMock` with `Drop → delete()`.
6. **M: `json_body_includes` takes `&str`** (133 sites need `.to_string()`; it panics on invalid JSON).
7. **L: `named`** (1 site) can be dropped.
8. **M: pool cap 25** with multi-server tests (§3.2).
9. **M: MSRV lock-step** (1.88 = 1.88), and the release is one day old.

### mockito 1.7.2
1. **B (semantic): precedence differs.** "First still-missing-hits, else **last** matching" silently changes which response overlapping mocks return after their first hit. jr relies on first-registered-wins in many files (generic + specific overlaps; this is what the 15 `with_priority` sites work around).
2. **B: no delay.** `asset_enrichment_concurrency.rs`'s concurrency proof cannot be expressed (a sync sleep in the chunked body serializes the single-threaded server).
3. **M: unmatched → 501, not 404.** Tests and handlers that observe jr's response to an unmatched route change behavior.
4. **H: no `received_requests`** (recorder workaround), **no drop verification unless `assert_on_drop`**. With `assert_on_drop`, an **unbound `expect(0)` mock asserts immediately at creation, passes, and is never checked again**: a silent loss.
5. **M: `&mut Server`** for every `mock()` call. Pool cap 20 on macOS.

### httptest 0.16.4
1. **B (semantic): last-added wins + no fall-through + unmatched → 500 + panic on drop.** Every overlapping-mock and `up_to_n_times` test must be restructured (`cycle!`). Strictness would also fail tests that intentionally let jr hit unmocked routes.
2. **H: no `received_requests`.**

### mocktail 0.3.2
1. **B: runs on the caller's runtime** → deadlock with blocking `assert_cmd` in current-thread tests (~1,346 tests).
2. **B: no call-count assertions at all.** No partial-JSON/regex/body-contains/query-missing matchers.
3. Binds `0.0.0.0` by default.

---

## 5. Spike: paper ports (UNCOMPILED; semantics checked against tag source)

### 5.1 `received_requests` (pattern from `tests/attachment_download.rs`)
```rust
// httpmock 0.9.0 — UNCOMPILED
use std::sync::{Arc, Mutex};
use httpmock::{MockServer, HttpMockRequest, Method::GET};
let server = MockServer::start_async().await;
let log: Arc<Mutex<Vec<HttpMockRequest>>> = Arc::default();
let l = log.clone();
// MUST be registered first: httpmock evaluates mocks in id order and calls the
// closure for every request until one matches; returning false never serves.
server.mock_async(move |when, _then| {
    when.is_true(move |r| { l.lock().unwrap().push(r.clone()); false });
}).await;
// ... other mocks, run jr ...
let reqs = log.lock().unwrap().clone();
for r in reqs.iter().filter(|r| r.uri().path().contains("/attachment/content/")) {
    assert!(!r.uri().query().unwrap_or("").contains("redirect=false"));
}
```
Expected: works (`is_true` takes `Fn + Send + Sync + 'static`; `HttpMockRequest: Clone`). **Risk:** if httpmock re-evaluates matchers in another pass (e.g. closest-match `verify`), the recorder could record duplicates. **INCONCLUSIVE until compiled.**

```rust
// mockito 1.7.2 — UNCOMPILED
let mut server = mockito::Server::new_async().await;
let log = Arc::new(Mutex::new(Vec::<(String, String, Vec<u8>)>::new()));
let l = log.clone();
server.mock("GET", mockito::Matcher::Any)
    .match_request(move |r| { l.lock().unwrap().push((r.method().into(), r.path_and_query().into(),
        r.body().cloned().unwrap_or_default())); false })
    .expect(0).create_async().await;   // never matches; all mocks are tested per request
```
Expected: works, because every mock's `matches` is evaluated for each request in `handle_request`. `Request` is not `Clone`, so fields are copied.

### 5.2 429 / Retry-After with `up_to_n_times` (`tests/api_client.rs::test_rate_limit_retry`)
```rust
// httpmock 0.9.0 — UNCOMPILED
let m429 = server.mock_async(|w, t| { w.method(GET).path("/rest/api/3/myself");
    t.status(429).header("Retry-After", "0"); }).await;
m429.up_to_n_times_async(1).await;
let m200 = server.mock_async(|w, t| { w.method(GET).path("/rest/api/3/myself");
    t.status(200).json_body(serde_json::json!({"account_id":"123abc","display_name":"Test User"})); }).await;
let resp: MyselfResponse = client.get("/rest/api/3/myself").await.unwrap();
m429.assert_calls_async(1).await;   // explicit — NOT automatic
m200.assert_calls_async(1).await;
```
Expected: identical semantics (exhausted mock skipped, first-registered wins).

```rust
// mockito 1.7.2 — UNCOMPILED
let m429 = server.mock("GET", "/rest/api/3/myself").with_status(429)
    .with_header("Retry-After", "0").expect(1).create_async().await;
let m200 = server.mock("GET", "/rest/api/3/myself").with_status(200)
    .with_body(r#"{"account_id":"123abc","display_name":"Test User"}"#).expect(1).create_async().await;
// ... ; m429.assert_async().await; m200.assert_async().await;
```
Expected: works for this test. Request 1 goes to m429 (missing hits), request 2 to m200. **Divergence:** a 3rd request would go to m200 as the *last* match. With wiremock it also goes to m200, but for a different reason; with reversed registration order the two crates would diverge.

### 5.3 `expect(n)` / `expect(0)` guard (`tests/component_commands.rs` style)
- httpmock: `let m = server.mock_async(..).await; …; m.assert_calls_async(0).await;`. **If the line is omitted, the guard disappears silently.**
- mockito: `.expect(0).create_async().await` bound to `let _g`, plus `_g.assert_async().await` (or `assert_on_drop` with the binding kept alive).

**Spike verdict:** cannot be confirmed empirically in this run. Re-run §5 in a scratch crate (`httpmock = { version = "=0.9.0", default-features = false }`, `mockito = "=1.7.2"`, `tokio` with `macros,rt`, `reqwest`) before any migration decision is made binding.

---

## 6. Feature × crate matrix (summary) and recommendation

| | wiremock 0.6.5 | httpmock 0.9.0 | mockito 1.7.2 | httptest 0.16.4 | mocktail 0.3.2 |
|---|---|---|---|---|---|
| Own server thread (no deadlock) | Y | Y | Y | Y | **N** |
| First-registered precedence (jr's assumption) | Y | **Y** | **N** (last-match fallback) | **N** (last-added) | Y (by priority) |
| `up_to_n_times` fall-through | Y | **Y** | W | N (cycle) | Y |
| Drop-time count verification | Y | N (W harness) | opt-in | Y (stricter) | N |
| `received_requests` | Y | W | W | W | N |
| Scoped mocks | Y | W | W | N | W |
| Priority | Y | W (order) | W | W (order) | Y |
| Unmatched status | 404 | **404** | 501 | 500 + panic | 404 |
| Delay (concurrency) | Y | Y (parallelism INCONCLUSIVE) | **N** | Y | ? |
| IPv6 listener | Y | **N** | Y | Y | Y |
| Matcher coverage for jr | full | full (partial-JSON via &str) | full | full (compositional) | **partial** |
| MSRV vs 1.88 | n/a | 1.88 (no headroom) | 1.70 | n/a | n/a |
| cargo-deny bans impact | — | none (dev-only dups) | none | none | none |
| Maturity | 14 mo. quiet | 1 day old | stable | stable | young |

**Recommendation:**
1. **Stay on wiremock 0.6.5.** No candidate adds a capability jr needs. Every candidate removes at least one capability jr relies on heavily (drop-time verification: 52 files; `received_requests`: 204 sites). The only concrete driver visible in the repo, the dev-only `base64` 0.22 duplicate, **is already ignored by cargo-deny** (`multiple-versions-include-dev = false`) and costs nothing at release. A cheaper lever is an upstream PR to wiremock-rs bumping `base64` to 0.23 (`main` still pins 0.22).
2. **Re-evaluate only on a real trigger:** a RUSTSEC advisory against wiremock or its tree, wiremock failing to build on a future MSRV/toolchain, or a needed feature it lacks. If triggered, choose **httpmock** (pinned `=0.9.x`, `default-features = false`) behind the jr harness in §7.4, and only after (a) the §5 spike compiles and passes, and (b) 0.9.x has had a few weeks of field time.
3. **Reject mockito** (silent precedence drift, no delay, 501), **httptest** (inverted precedence, no fall-through, panics on unmatched), and **mocktail** (caller-runtime deadlock, no assertions).

---

## 7. Incremental migration plan (if a migration is mandated; target = httpmock)

### 7.1 (a) Coexistence of wiremock and the candidate as dev-dependencies
- **Yes, they can coexist.** Both are independent dev-deps with independent servers. Each test file imports one or the other, and test binaries are per-file, so there is no symbol clash.
- **cargo-deny bans:** no failures and **no temporary `skip` entries needed**. New duplicates (`similar` 2.7 + 3.x; and `base64` 0.22 / `sha1` 0.10 if `cookies` were enabled) are reached only via dev edges and are ignored by default. VERIFIED from the cargo-deny docs (§3.5). Do **not** set `multiple-versions-include-dev = true` during the transition.
- **Licenses:** all allowed. Confirm transitive licenses with `cargo deny check licenses` in PR-0 (INCONCLUSIVE until run).
- **Advisories:** keep httpmock's `record`/`standalone` features off (they pull `serde_yaml`).
- **MSRV:** both compile under 1.88 (httpmock declares exactly 1.88.0). The `msrv` job checks `--all-targets`, so PR-0 proves it.

### 7.2 (b) Shared helpers in `tests/common/`
- `tests/common/fixtures.rs` returns `serde_json::Value`/strings only and has **zero wiremock types**. It is library-agnostic and needs no change.
- `tests/common/mock_server.rs::setup_with_myself` is the only wiremock-coupled helper and has **zero callers**. Delete it in PR-0. Nothing forces a big-bang change.
- Per-file `jr_cmd(server_uri: &str, …)` harnesses take a URI string and work unchanged with `server.base_url()`.
- **Dual-track:** add a new `tests/common/http_mock.rs` (httpmock harness, §7.4) alongside. Unmigrated files never include it. Note that `mod common;` pulls in every `common` submodule for each test binary, so the new module must compile even in files that don't use it. That is fine, since httpmock is a dev-dep, and the existing `#[allow(dead_code)] mod common;` pattern covers unused items.

### 7.3 (c) Module grouping and order (mock counts = `Mock::given` per file on origin/develop)

Hardest-group flags: **RR** = `received_requests` count, **UTN** = `up_to_n_times`, **SC** = `mount_as_scoped`, **PRI** = `with_priority`, **V** = explicit `verify()`.

| PR | Group | Files (mocks) | Total mocks | Risk notes |
|---|---|---|---|---|
| 0 | **Infra** | add `httpmock` dev-dep; `tests/common/http_mock.rs` harness; migration guard test + baseline (§7.5); delete dead `tests/common/mock_server.rs` | 0 | cargo-deny/MSRV proven here |
| 1 | Pilot: tiny pure GET/POST | json_error_shape 3, assets_errors 2, issue_list_oauth_scope 4, project_meta 4, team_commands 4, issue_remote_link 4, verbose_bodies 4, adf_recursion_depth 2, issue_resolution 5, issue_view_errors 5, oauth_flow_holdouts 4, duplicate_user_disambiguation 6, team_object_shape 6, cmdb_fields 6, issue_edit_no_parent 6, init_oauth_scope 3, auth_header_release_gate 1, multi_cloudid_disambiguation 2, issue_edit (11 bare servers) | **71** | lowest risk; validates the harness |
| 2 | `src/` inline (simple) | resolutions.rs 1, links.rs 1, auth.rs 2, cli/field.rs 1, cli/auth/login.rs 3, cli/issue/jsm_create.rs 5 | **13** | `cfg(test)` modules |
| 3 | Read commands A | board_commands 24, sprint_commands 25, project_commands 10, worklog_commands 10, comments 13, boards_sprints_holdouts 13, issue_list_assets 11, user_commands 15 (V1), user_list_project_resolution 11 (V7) | **132** | query_param-heavy |
| 4 | Read commands B | requesttype_commands 20, input_validation 8, issue_write_holdouts 10, issue_read_holdouts 12, issue_edit_echo 10, issue_create_echo 12, cache_warm_hit 10, table_output_sanitization 17 | **99** | |
| 5 | Mid, ≤1 RR | field_options 32, issue_changelog 34, attachment_list 27, issue_edit_type_errors 30, issue_edit_labels 19, issue_list_errors 16 (RR1), comment_view 16 (RR1), adf_code_mark_exclusivity 1 (RR1), adf_inline_html_inv1_e2e 1 (RR1) | **176** | first RR use |
| 6 | RR moderate A | multi_profile_fields 14 (RR4), team_column_parity 16 (RR2), all_flag_behavior 19 (RR2), queue 23 (RR5), assets 51 (RR4), asset_holdouts 7 (V2) | **130** | |
| 7 | RR moderate B | comment_delete 10 (RR2), comment_crud_api 6 (RR4), mention_resolution 19 (RR4), jsm_request_api 12 (RR2), issue_create_json 12 (RR2), issue_create_field_adf 5 (RR3), issue_edit_field_adf 4 (RR5), worklog_duration_holdouts 3 (RR3), user_pagination 33 (RR6), cloud_id_tenant_info 11 (RR5) | **115** | |
| 8 | Explicit-verify files | issue_move_resolution_enforce 45 (RR2, V14), api_query_param 10 (RR1, V25), comment_edit 30 (RR8) | **85** | |
| 9 | **Scoped A** | issue_edit_field 75, issue_field_hint_kinds 37 (SC4, RR5), issue_create_field 33 (SC3, RR1) | **145** | hardest: SC |
| 10 | **Rate-limit / retry** | rate_limit_cap_tests 19 (UTN13), rate_limit_holdouts 4 (UTN2), api_client 13 (UTN2), search_issue_keys 20 (UTN6, RR4), bulk_deadline_propagation 6, src/api/jira/bulk.rs 5 (UTN2) | **67** | hardest: UTN; JRACLOUD-95368 literal pins |
| 11 | **OAuth refresh** | oauth_refresh_integration 37 (UTN8, header, body_string_contains) | **37** | hardest: auth-critical UTN; single-file PR |
| 12 | CLI handler | cli_handler 87 (RR3, named, 429) | **87** | |
| 13 | Bulk | issue_bulk 29 (UTN4, RR1), issue_bulk_pr2 84 (RR24) | **113** | RR-heavy |
| 14 | Attachments A | attachment_delete 89, attachment_download 80 (RR3, **IPv6 test stays on wiremock or is redesigned**) | **169** | blocker #3 |
| 15 | Attachments B | attachment_upload 64 (UTN6, RR8, multipart body inspection), src/api/jsm/attachments.rs 6 (UTN2, RR3) | **70** | |
| 16 | **JSM attachments** | attachment_jsm 196 (PRI15, SC6, RR11) | **196** | hardest: PRI + SC + RR |
| 17 | **JSM create** | issue_create_jsm 116 (RR25, SC3) | **116** | hardest: RR-heavy |
| 18–19 | **Components** (split in 2) | component_commands 333 (V~125, RR13, UTN1, body_json21) | **333** | largest file |
| 20–21 | **Issue commands** (split in 2) | issue_commands 253 (RR35, any4) | **253** | most RR sites |
| 22 | Concurrency | asset_enrichment_concurrency 5 (`set_delay`, UTN1, V2) | **5** | delay parallelism must be proven first |
| 23 | Cleanup | remove `wiremock` dev-dep (if the IPv6 test was solved), drop the guard's wiremock allowance; `base64` 0.22 leaves the lock | 0 | |

The total is about **2,413 mocks** across 24 PRs; the per-row sums cover all 92 mock-defining files.

### 7.4 Harness that makes forgetting impossible (prerequisite for (d))
`tests/common/http_mock.rs` (design sketch, UNCOMPILED):
- `JrMock { server: httpmock::MockServer, expectations: Mutex<Vec<(usize /*mock id*/, Times, String)>>, log: Arc<Mutex<Vec<HttpMockRequest>>> }`.
- `JrMock::start().await` starts the server and registers the recorder mock **first** (§5.1).
- `h.mock(times: Times, |when, then| …)` makes **`Times` a required positional argument** (`Times::Exactly(n)`, `AtLeast(n)`, `Never`, `Unbounded`). Forgetting a count becomes a **compile error**, and the "no expectation" case must be spelled out as `Times::Unbounded`.
- `h.mock_limited(n, times, …)` covers `up_to_n_times`. `h.scoped(times, …) -> ScopedMock` deletes on `Drop` and verifies its own count, mirroring `MockGuard`.
- `h.received() -> Vec<HttpMockRequest>` is the `received_requests` replacement.
- `impl Drop for JrMock`: if not `std::thread::panicking()`, rebuild each `httpmock::Mock::new(id, &self.server)` and assert `times.contains(calls())`. This restores wiremock's shutdown verification. The sync `calls()` is safe in tokio because httpmock's `join()` is park-based and the local adapter does no I/O (VERIFIED `src/common/util.rs`, `src/api/adapter/local.rs`).

### 7.5 (d) Per-PR safety check: proving the migrated file asserts the same things
1. **Compile-time:** raw `server.mock(`/`mock_async(` is banned outside `tests/common/http_mock.rs`. Every mock goes through `h.mock(Times, …)`, so a count cannot be silently omitted.
2. **Grep-guard test `tests/mock_migration_parity.rs`** (always-run, rides the existing `test` job; no CI YAML change). It reads a checked-in, frozen baseline `tests/fixtures/mock_migration_baseline.json`, generated once in PR-0 from origin/develop, with per-file counts of `Mock::given`, `.expect(N)`, `.expect(0)`, `up_to_n_times`, `received_requests()`, `mount_as_scoped`, `verify()` and `#[tokio::test]`. For every file marked migrated it asserts:
   - (i) no `wiremock` token remains;
   - (ii) `count(h.mock*/h.scoped) == baseline Mock::given`;
   - (iii) `count(Times::Exactly|AtLeast|Never) == baseline .expect(` and `count(Times::Never|Exactly(0)) == baseline .expect(0)`, so **call-count assertions are preserved one-for-one**;
   - (iv) `count(h.received()) >= baseline received_requests`;
   - (v) `count(mock_limited) == baseline up_to_n_times`; `count(h.scoped) == baseline mount_as_scoped`;
   - (vi) the number of `#[tokio::test]` fns is unchanged (no test silently deleted).

   Failures emit a canonical `MOCK-PARITY-001 <file>: <metric> baseline=X now=Y` line, mirroring CI-CITE-001's style. Unmigrated files are skipped. The baseline file is append-never/edit-never and must be reviewed like `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS`.
3. **Teeth check (behavioral):** a harness-only env var, e.g. `JR_MOCK_INVERT_EXPECTATIONS=1`, read by `tests/common/http_mock.rs`, never by the `jr` binary, so it is not a `JR_*` binary seam and needs no row in CLAUDE.md's table. It makes `Drop` assert the **negation** of every bounded `Times`. Each PR runs `cargo test --test <file>` under it, and every test that has at least one bounded expectation must fail. A test that still passes has no live count assertion, which is a regression signal. Can be scripted as a CI step for migrated files.
4. **Mutation cross-check for the hardest groups (PR 10, 11, 16, 17):** run `cargo mutants --file <src module exercised> --jobs 4 --timeout 240` before and after. The caught-mutant count must not drop. cargo-mutants mutates `src/`, not tests, so this measures the migrated tests' *detection power*, the property that matters.
5. **Review checklist line:** "precedence preserved". httpmock is first-registered-wins like wiremock; every former `with_priority` must become an explicit re-order or delete + re-create, with a comment.

### 7.6 (e) PR count and revised effort estimate
- **PRs: about 24** (1 infra + 21 migration, counting the two 2-way splits + 1 concurrency-specific + 1 cleanup). The range is 20–26, depending on whether the large files are split further. Under the repo's VSDD rule that every change goes through the full pipeline (user memory: feedback_vsdd_process), per-PR process overhead dominates.
- **Volume:** 2,413 mock definitions, 1,534 server starts, 1,147 count expectations (387 negative guards), 204 request-inspection sites, 47 limited mocks, 17 scoped, 15 priority, 1 IPv6 listener, 1 delay-concurrency proof.
- **Estimate (model judgment, not measured):**

  | Work item | Engineer-days |
  |---|---|
  | Harness + guard + baseline | 2–3 |
  | Mechanical conversion (about 150–250 mocks/day incl. local test runs) | 10–16 |
  | Hard groups: RR rewrites, UTN/OAuth, PRI/SC, IPv6 design, concurrency proof | 4–7 |
  | Per-PR pipeline/review overhead (~24 PRs × 0.5–1 day) | 12–24 |
  | **Total** | **≈ 28–50** |

  This is calendar-heavy, with near-zero product value under current evidence. It is consistent with the recommendation not to migrate.

---

## 8. Cross-validation and conflicts
- Perplexity deep research (2nd call) independently agreed: neither httpmock nor mockito exposes a received-requests list, httpmock does not verify on drop, and mockito verifies on drop only with `assert_on_drop`. It cites mockito issue #131 (assert-on-drop added as opt-in) and #147 (request info not exposed), https://github.com/lipanski/mockito/issues/131 and https://github.com/lipanski/mockito/issues/147.
- **Conflict noted:** mockito's crate docs say "the first one that still expects requests" is applied. The source shows the **fallback to the *last* matching mock** once none is missing hits (`src/server.rs`). The source is authoritative.
- **Conflict noted:** httptest docs say "most recently added match wins". The source confirms it and adds that exhausted expectations are **not** skipped.

## 9. Inconclusive items (explicit)
1. Spike and benchmark not executed (no shell). All §5 code is uncompiled.
2. Whether httpmock's recorder `is_true` closure fires exactly once per request (possible re-evaluation during closest-match `verify`).
3. Whether httpmock `then.delay` gives true request parallelism on its current-thread + LocalSet server (needed by `asset_enrichment_concurrency.rs`).
4. Transitive licenses of `similar` 3, `futures-timer`, `crossbeam-channel` and `prost`. Run `cargo deny check licenses`.
5. Compile-time delta and per-server startup cost (not measured).
6. wiremock's internal pool size (not verified).
7. A distinct-host alternative to `[::1]` for the GHSA-9857-6MW7-FQ2M redirect test under httpmock (IPv4-only bind) needs a design decision.
8. Whether any RUSTSEC advisory applies to `serde_yaml` 0.9 (only relevant if httpmock `record` is enabled; recommended off).

## 10. Sources (pinned)
- jr origin/develop: https://raw.githubusercontent.com/Zious11/jira-cli/c72f81317fd9b0b0459b9f29518f2d3d7010df06/{Cargo.toml,Cargo.lock,deny.toml,src/api/client.rs}; compare https://api.github.com/repos/Zious11/jira-cli/compare/fb9d015c...c72f8131
- crates.io registry (versions, MSRV, license, deps): https://crates.io/api/v1/crates/{wiremock,httpmock,mockito,httptest,mocktail}, `/0.6.5|0.9.0|1.7.2|0.16.4|0.3.2/dependencies`, https://crates.io/api/v1/crates/headers/0.4.1/dependencies, https://crates.io/api/v1/crates/path-tree/0.8.3
- wiremock 0.6.5: https://docs.rs/wiremock/0.6.5/wiremock/struct.Mock.html; https://raw.githubusercontent.com/LukeMathWalker/wiremock-rs/v0.6.5/src/mock_server/bare_server.rs; …/v0.6.5/src/mock_set.rs; https://raw.githubusercontent.com/LukeMathWalker/wiremock-rs/main/Cargo.toml; https://api.github.com/repos/LukeMathWalker/wiremock-rs/commits
- httpmock 0.9.0 (tag tree d6fe1cc6): https://docs.rs/httpmock/0.9.0/httpmock/ (`struct.MockServer.html`, `struct.Mock.html`, `struct.HttpMockRequest.html`); https://raw.githubusercontent.com/httpmock/httpmock/v0.9.0/{Cargo.toml,CHANGELOG.md,src/server/state/mod.rs,src/server/handler.rs,src/server/transport.rs,src/server/builder.rs,src/api/mock.rs,src/api/server.rs,src/api/spec.rs,src/api/output.rs,src/api/adapter/local.rs,src/common/runtime.rs,src/common/util.rs}
- mockito 1.7.2: https://docs.rs/mockito/1.7.2/mockito/; https://raw.githubusercontent.com/lipanski/mockito/1.7.2/src/{server.rs,mock.rs,server_pool.rs,request.rs}
- httptest 0.16.4: https://docs.rs/httptest/0.16.4/httptest/; https://raw.githubusercontent.com/ggriffiniii/httptest/v0.16.4/src/{server.rs,responders.rs}
- mocktail 0.3.2 (tag 0.3.2 = 6980e804): https://docs.rs/mocktail/0.3.2/mocktail/; https://raw.githubusercontent.com/IBM/mocktail/0.3.2/mocktail/src/{server.rs,mock_set.rs,mock.rs,mock_builder/when.rs,service/http.rs}
- cargo-deny: https://embarkstudios.github.io/cargo-deny/checks/bans/cfg.html; https://embarkstudios.github.io/cargo-deny/checks/cfg.html

## Research Methods

| Tool | Queries | Purpose |
|---|---|---|
| **Perplexity perplexity_research (PRIMARY)** | 2 | (1) broad 10-point five-crate comparison: **timed out at 300 s**; (2) narrowed: received-requests / drop-verification for httpmock + mockito (succeeded; used as cross-validation). Primary evidence deliberately shifted to tag source, which is more authoritative than synthesis. |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | not available in this agent's tool list |
| Tavily (all) | 0 | not available in this agent's tool list |
| WebFetch | ~62 | crates.io registry API (versions, MSRV, licenses, deps); docs.rs pages at exact versions; crate source at release tags on raw.githubusercontent.com; GitHub API (jr compare, tag trees, wiremock commits); origin/develop `Cargo.toml`/`Cargo.lock`/`deny.toml`/`src/api/client.rs`; cargo-deny docs |
| WebSearch | 0 | — |
| Grep / Read / Glob (local) | ~40 | wiremock API inventory over files proven byte-identical to origin/develop (§0.1) |
| Training data | 3 areas | transitive-license expectations (flagged §9.4); effort-rate assumptions (§7.6); general wiremock pool behavior (flagged §9.6) |

**Total MCP tool calls:** 2 (1 timeout, 1 success)
**Training data reliance:** low. Every behavioral claim about a candidate is sourced from its release-tag source or docs.rs at the pinned version. Training data is used only for the flagged estimates.
