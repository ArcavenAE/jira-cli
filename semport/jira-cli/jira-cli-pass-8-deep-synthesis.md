# Pass 8 — Final Deep Synthesis: jira-cli (jr)

Snapshot SHA: `dea166471e22eff55974d7675593469b37048c5f` (v0.5.0-dev.7)
Source root: `/Users/zious/Documents/GITHUB/jira-cli/.reference/jira-cli/`
Target == reference (SELF-INGEST)
Synthesis date: 2026-05-04
Supersedes: `jira-cli-pass-6-synthesis.md` (Phase A broad-sweep synthesis)
Inputs: Phase A (7 broad files), Phase B (17+ deepening rounds across passes 0-5), Phase B.5 coverage audit (PASS), Phase B.6 extraction validation (PASS — 96.7% behavioral accuracy, 0 hallucinations), `CLAUDE.md`.

> This is the **definitive deliverable** for downstream Phase 1 (spec crystallization) skills (`/create-brief`, `/create-domain-spec`, `/create-prd`, `/decompose-stories`, `/create-architecture`). It supersedes the Pass 6 broad synthesis. Every claim is grounded in `<file>:<line>` or `BC-<id>` from the converged record.

---

## §1. Executive summary

`jr` (package `jr`, binary `jr`) is a Rust 2024 / MSRV-1.85 single-crate CLI for automating Atlassian Jira Cloud workflows. It is a **thin client** (ADR-0001) wrapping Jira Core REST v3, Agile REST, JSM REST, the Atlassian Teams API, GraphQL `tenantContexts`, and the Assets/CMDB API directly via `reqwest 0.13` (rustls-tls, no native-tls; ADR-0003). The architecture is a clean five-layer stack with cross-cutting utilities (cache, config, error, output, adf, jql, duration, partial_match, observability), persists state to `~/.config/jr/config.toml` + `~/.cache/jr/v1/<profile>/` + the OS keychain (`jr-jira-cli` service), and ships as a single static binary.

**Three numbered consequential findings:**

1. **Four MUST-FIX correctness bugs are spec-frozen with byte-verified citations.** NFR-R-D (CRITICAL — multi-profile fields silent regression; 12+ read sites of `config.global.fields.*` ignore per-profile `ProfileConfig.{story_points,team}_field_id`), NFR-R-A (HIGH — `list_worklogs` non-paginated at `src/api/jira/worklogs.rs:25-30`), NFR-R-B (HIGH — `handle_open` uses `client.base_url()` not `instance_url()` at `src/cli/issue/workflow.rs:636`, broken for OAuth profiles), NFR-R-E (HIGH — multi-workspace asset HashMap mis-attribution at `src/cli/issue/list.rs:440,446,449,456`). All four have BC anchors in the 540-BC catalog and were re-verified at byte-level by Pass 4 R4 + Phase B.6 extraction validation.

2. **Multi-profile correctness is encoded in signatures, not types.** Three soft-fence boundaries enforce per-profile isolation: every cache reader/writer takes `profile: &str` first (universal across `cache.rs`, 100% conformance per Pass 5 R1); keychain has shared-vs-namespaced key namespaces with `default`-only legacy migration (BC-1153..1158); profile resolution has a deterministic flag > env > config > "default" precedence threaded as a parameter, never via env-var seam (BC-007 verified by `tests/auth_profiles.rs`). Combined with the ADR-0006 build-time XOR-obfuscated embedded OAuth app (per-build random key, fixed callback port 53682, TOCTOU-closed listener binding via `RedirectUriStrategyRequest::bind() → ResolvedRedirect`), the project encodes more correctness in signatures than in compile-time fences. The remaining gap is type-level: a `Profile(String)` newtype or `Cache<P>` phantom-type would compile-time-enforce what is currently signature discipline.

3. **Pre-VSDD documentation strata coexist with current code at predictable drift positions.** `docs/adr/` (6 files, all authoritative), `docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md` (v1 design — implemented), `docs/superpowers/plans/` (75 files, ~56,572 LOC of v1 TDD checklists — delivered), and `docs/specs/` (22 post-v1 feature specs, partial drift). CLAUDE.md is itself stale by 12 deviations (per Pass 1 R1 D1-D12), the most consequential being missing modules (`view.rs`, `comments.rs`, `changelog.rs`, `json_output.rs`, `api/assets/schemas.rs`, `observability.rs`) and the implicit "shard at ~1000 LOC" rule that `cli/auth.rs` (1,998 LOC), `cli/assets.rs` (1,055 LOC), and `cli/issue/list.rs` (1,083 LOC, post-split) violate.

**Convergence summary** (rounds × pass; Pass 6 being broad synthesis, Pass 8 being this final synthesis):

| Pass | Subject | Broad | Deepening rounds | Final novelty |
|---|---|---|---|---|
| 0 | Inventory | done | R1 (SUBSTANTIVE), R2 (NITPICK) | NITPICK at R2 |
| 1 | Architecture | done | R1 (SUBSTANTIVE), R2 (NITPICK) | NITPICK at R2 |
| 2 | Domain Model | done | R1, R2, R3, R4, R5 (all SUBSTANTIVE), R6 (SUBSTANTIVE), R7 (NITPICK) | NITPICK at R7 |
| 3 | Behavioral Contracts | done | R1, R2, R3 (SUBSTANTIVE), R4 (NITPICK) | NITPICK at R4 |
| 4 | NFR Catalog | done | R1, R2, R3 (SUBSTANTIVE), R4 (NITPICK) | NITPICK at R4 |
| 5 | Conventions | done | R1 (SUBSTANTIVE), R2 (NITPICK) | NITPICK at R2 |

Total deepening rounds executed: 17 (2+2+7+4+4+2 minus broad). Total CONV-ABS retractions across rounds: 12+ (CONV-ABS-1..12 plus pass-specific). Cross-round contradiction resolved most consequentially: NFR-R-E was correctly framed at HIGH in Pass 4 R1, erroneously demoted by R2's "wrong file" framing (`api/assets/linked.rs::enrich_assets` is the correct concurrent implementation), then re-promoted at the correct site (`src/cli/issue/list.rs:440,446,449,456`) by Pass 4 R3, byte-verified by Pass 4 R4, and confirmed by Phase B.6.

---

## §2. System anatomy (definitive)

### §2.1 Tech stack

- **Language/edition/MSRV:** Rust 2024 edition; MSRV 1.85 (`rust-toolchain.toml`); single crate (lib + bin); 23,334 src/ LOC + 16,958 tests/ LOC + 137 build.rs LOC = 40,429 total Rust LOC.
- **Crate composition:** `jr` library + `jr` binary; binary entrypoint at `src/main.rs`; library re-exports at `src/lib.rs:1-12` (11 `pub mod` + 1 `pub(crate) mod observability`).
- **Build profile (release):** `panic = "abort"`, `lto = "fat"`, `strip = true`, `codegen-units = 1` (Cargo.toml).
- **Direct runtime deps (23, corrected from broad-pass 24 by Pass 0 R1 CONV-ABS-12):** `tokio` (full features), `clap` (derive + cargo + env + wrap_help), `clap_complete`, `serde`, `serde_json`, `toml`, `figment`, `directories`, `keyring`, `reqwest` (rustls-tls), `rustls`, `urlencoding`, `chrono`, `comfy-table`, `colored`, `inquire`, `anyhow`, `thiserror`, `open`, `webbrowser`, `tracing`, `tracing-subscriber`, `futures`. Confirmed by `awk '/^\[dependencies\]/{f=1; next} /^\[/{f=0} f && /^[a-zA-Z]/' Cargo.toml | wc -l` → 23.
- **Transitive deps (Cargo.lock):** 332 packages.
- **Dev deps (6):** `wiremock`, `assert_cmd`, `predicates`, `tempfile`, `proptest`, `insta`.
- **Build deps (0):** explicit; build.rs uses `std::env`/`std::fs`/`std::io` only.
- **Test framework:** `cargo test` + `tokio::test` (async) + `proptest` (4 blocks across `jql.rs`, `partial_match.rs`, `duration.rs`) + `insta` (17 `.snap` files) + `wiremock` (mock HTTP).
- **Integration test infrastructure:** `JiraClient::new_for_test(base_url, auth_header)` + `JR_BASE_URL` env override + `tests/common/fixtures.rs` (446 LOC).
- **Lint policy:** clippy zero-warnings policy enforced in CI; `cargo fmt --all --check`; `cargo deny check` (deny.toml — multiple-versions = "warn", licenses curated).
- **CI matrix:** `.github/workflows/ci.yml` (78 LOC), `.github/workflows/release.yml` (230 LOC) — release injects `JR_BUILD_OAUTH_CLIENT_ID`/`_SECRET` via `build.rs` to embed XOR-obfuscated OAuth app per ADR-0006.

### §2.2 Bounded contexts (14 — definitive)

Refined from Pass 6 §4 with Pass 2/4 deepening findings. Risk = composite of LOC, BC count, NFR concerns.

| # | Bounded context | Module path(s) | LOC | BCs | NFR concerns | Risk |
|---|---|---|---:|---:|---|---|
| 1 | **Auth & Identity** | `cli/auth.rs` (1,998), `api/auth.rs` (1,397), `api/auth_embedded.rs` (250) | 3,645 | ~57 (BC-001..024 + BC-1140..1178) | NFR-S-A (PKCE), NFR-S-B (JR_AUTH_HEADER), NFR-O-B (status/refresh inconsistency), NFR-R-NEW-3 (deferred 401 auto-refresh) | **HIGH** |
| 2 | **Issue read** (list/view/comments/changelog) | `cli/issue/list.rs` (1,083), `cli/issue/view.rs` (286), `cli/issue/comments.rs` (61), `cli/issue/changelog.rs` (847), `cli/issue/format.rs` (225) | ~2,500 | ~84 (BC-101..124 + BC-919..1063) | N+1 risk closed (Pass 4 R2 — actually concurrent via `join_all`), NFR-R-E multi-workspace HashMap | **HIGH** |
| 3 | **Issue write** (create/edit/move/assign/comment/link/open/remote-link) | `cli/issue/create.rs` (375), `cli/issue/workflow.rs` (788), `cli/issue/links.rs` (293), `cli/issue/helpers.rs` (813), `cli/issue/json_output.rs` (149), `cli/issue/assets.rs` (65) | ~2,500 | ~71 (BC-201..225 + BC-1055..1081) | NFR-R-B (handle_open OAuth bug), JSON field naming inconsistency (P5R1-AP-05) | **HIGH** |
| 4 | **Issue assets / CMDB** | `cli/issue/assets.rs` (65), `api/assets/linked.rs` (557), `api/assets/objects.rs` (237), `api/assets/workspace.rs` (58), `api/assets/schemas.rs` (44), `api/assets/tickets.rs` (19) | ~1,000 | ~29 (BC-301..315 + BC-1137) | NFR-R-E mis-attribution, AQL escaping (verified safe via property test), workspace 404 → "JSM Premium required" mapping | **HIGH** |
| 5 | **Assets standalone** (`jr assets *`) | `cli/assets.rs` (1,055) | 1,055 | ~12 | Shard rule violation (>1000 LOC), client-side `colorName != "green"` filter dichotomy (vs JQL `statusCategory != Done`) | **MEDIUM-HIGH** |
| 6 | **Boards & Sprints** | `cli/board.rs` (334), `cli/sprint.rs` (438), `api/jira/boards.rs` (50), `api/jira/sprints.rs` (109) | ~931 | ~32 (BC-401..410 + BC-1138 team-column-parity) | `MAX_SPRINT_ISSUES = 50` cap, scrum-only check, hard-error vs silent-degrade UX asymmetry (Pass 1 R1 §4d) | **MEDIUM** |
| 7 | **Worklogs** | `cli/worklog.rs` (79), `api/jira/worklogs.rs` (31), `duration.rs` (159) | ~270 | ~15 (BC-501..508 + BC-1099..1102) | NFR-R-A (non-paginated), NFR-R-C (hardcoded 8h/day, 5d/week), parse_duration u64-overflow LOW | **MEDIUM** |
| 8 | **Teams** | `cli/team.rs` (120), `api/jira/teams.rs` (55) | ~175 | ~11 | GraphQL `tenantContexts` (ADR-0005), corrupt cache tolerance (BC-1135d) | **LOW-MEDIUM** |
| 9 | **Users** | `cli/user.rs` (165), `api/jira/users.rs` (290), `partial_match.rs` (200) | ~655 | ~30 (BC-701..709 + BC-1119..1132) | `--all` advances by REQUESTED maxResults (deliberate JRACLOUD-71293 workaround), `USER_PAGINATION_SAFETY_CAP = 1500` (15 pages × 100), duplicate disambiguation under `--no-input` | **MEDIUM** |
| 10 | **Projects & Queues** | `cli/project.rs` (133), `cli/queue.rs` (323), `api/jira/projects.rs` (121), `api/jsm/servicedesks.rs` (127), `api/jsm/queues.rs` (85) | ~789 | ~32 (BC-801..808 + BC-1133, BC-1134) | service-desk discovery via `require_service_desk` cache-only gate, `--internal` silent no-op on non-JSM (NEW-INV-257) | **LOW-MEDIUM** |
| 11 | **Configuration** | `config.rs` (1,223), profile threading at every CLI handler signature | 1,223 | ~15 (BC-901..911 + BC-1139) | figment layering, profile resolution precedence, NFR-R-D fields-bug, validate_profile_name 64-char | **HIGH** |
| 12 | **Cache** | `cache.rs` (899) | 899 | ~17 (BC-1001..1010 + BC-1135d) | per-profile signature soft fence, TTL=7d hardcoded, non-atomic writes (LOW), corruption recovery via `Ok(None)` | **MEDIUM-HIGH** |
| 13 | **Output / Rendering** | `output.rs` (76), `adf.rs` (1,826), `cli/issue/format.rs` (225), `cli/issue/json_output.rs` (149) | ~2,300 | ~80 (BC-1101..1118 + BC-940..1018 ADF) | JSON field naming inconsistency (4 distinct booleans), ADF lossy nodes (mention/emoji/inlineCard/media), stdout/stderr discipline (uncodified — P5R2-AP-01) | **MEDIUM** |
| 14 | **Error handling & Runtime** | `error.rs` (137), `main.rs` (268), `api/client.rs` (490), `api/rate_limit.rs` (56), `api/pagination.rs` (374), `observability.rs` (39), `jql.rs` (395) | ~1,800 | ~32 (BC-1201..1214 + BC-1082..1092 + BC-1401..1411) | 11 JrError variants × exit codes (78/64/2/1/130/0), 6-precedence `extract_error_message`, MAX_RETRIES=3, Retry-After integer-only (no HTTP-date) | **HIGH** |

**Total LOC across contexts:** ~21,742 (sum); residual is `lib.rs` (12), small `mod.rs` shells, and re-exports.

### §2.3 Layer architecture (5-layer + L3 bifurcation)

Per Pass 1 broad §1a + R1 refinement:

```
L0  main.rs (268 LOC)
      ├── tokio runtime construction
      ├── Ctrl+C handler (process::exit(130))
      └── error chain walker → JrError::exit_code() → process::exit
            ↓
L1  cli (clap derive)
      ├── cli/mod.rs (772 LOC) — top-level Command enum (14 commands)
      └── per-subcommand sub-enums (IssueCommand 17 variants, etc.)
            ↓
L2  cli handlers
      ├── cli/issue/{list,view,comments,changelog,create,edit,workflow,links,assets,format,helpers,json_output}.rs
      ├── cli/{auth,assets,board,sprint,worklog,team,user,queue,project,init,api}.rs
            ↓
L3  api (HTTP plumbing)
      ├── api/client.rs (490 LOC) — JiraClient + 11 public HTTP methods
      │     │
      │     ├── send → parse_error → typed JrError (validated path; 9 methods)
      │     │      [used by all api/jira, api/jsm, api/assets impls]
      │     │
      │     └── send_raw → reqwest::Response (raw passthrough; 2 methods)
      │            [used only by cli/api.rs handle_api]
      │
      ├── api/auth.rs (1,397 LOC) — OAuth + keychain + per-profile namespacing
      ├── api/auth_embedded.rs (250 LOC) — XOR-obfuscation runtime + embedded credentials
      ├── api/pagination.rs (374 LOC) — 4 pagination shapes (OffsetPage, CursorPage, ServiceDeskPage, AssetsPage)
      └── api/rate_limit.rs (56 LOC) — Retry-After integer parser; MAX_RETRIES=3, DEFAULT_RETRY_SECS=1
            ↓
L4  api resource impls (impl JiraClient blocks at 17 sites)
      ├── api/jira/{issues,boards,sprints,fields,statuses,links,teams,worklogs,projects,users,resolutions}.rs
      ├── api/jsm/{queues,servicedesks}.rs
      └── api/assets/{linked,objects,workspace,schemas,tickets}.rs
            ↓
L5  types (Serde structs)
      ├── types/jira/{issue,board,sprint,user,worklog,team,changelog,project}.rs
      ├── types/jsm/{queue,servicedesk}.rs
      └── types/assets/{linked,object,schema,ticket}.rs

Cross-cutting (L6):
      cache.rs, config.rs, error.rs, output.rs, adf.rs, jql.rs, duration.rs, partial_match.rs, observability.rs
```

**The L3 HTTP-path bifurcation** (Pass 1 R1 §6d) is architecturally significant: `JiraClient` exposes BOTH (a) "give me a deserialized T or a typed JrError" (validated; 9 methods) AND (b) "give me the raw response, I'll handle status myself" (passthrough; 2 methods used by `jr api`). Most of the codebase uses (a); only `cli/api.rs::handle_api` uses (b). They share the retry loop and auth header but diverge on what they expect callers to do with non-2xx responses.

### §2.4 Configuration topology (figment + profile + project + env + flag)

Per Pass 2 R1 + R2 + R3:

**Resolution precedence** (left wins): `--profile` flag > `JR_PROFILE` env > `default_profile` config field > literal `"default"`. Threaded through `Config::load_with(cli_profile)` as a parameter; **not** an env-var seam (Pass 0 R1 + Pass 2 R3).

**Config layering** (figment Provider order, lowest-to-highest priority):
1. Default values (figment default).
2. `~/.config/jr/config.toml` (`Toml::file`).
3. `./.jr.toml` per-project (`Toml::file`).
4. `JR_*` env (`Env::prefixed("JR_")`).

**Profile sections:** `[profiles.<name>]` blocks carry `url, email, auth_method, cloud_id, oauth_client_id, oauth_scopes, story_points_field_id, team_field_id, default_project, default_board_id`. Plus top-level `default_profile = "<name>"`.

**Legacy migration** (BC-006, BC-1139): on first load, an old `[instance]` + `[fields]` shape is mapped to `[profiles.default]` + `[default_profile = "default"]`. **The migration write-back uses a file-only baseline** (Pass 2 R3 INV-21) — env-var values do NOT bleed into the migrated file.

**Fail-loud safety** (BC-1139, fix for issue #258): malformed TOML → `Config::load()?` propagates → `JrError::ConfigError` → exit 78. The file is NOT overwritten via `unwrap_or_default()`.

**Per-profile validation** (BC-019, NEW-INV-008): `validate_profile_name` runs at three boundaries with rules: empty rejected; >64 chars rejected; charset must be `[A-Za-z0-9_-]`; reserved Windows names (`CON`, `NUL`, …) rejected case-insensitively.

### §2.5 State machines (5 from Pass 1 R1 §4)

The five state machines that materially drive the system are:

1. **OAuth login state machine** (Pass 1 R1 §4a) — Resolve credentials (Flag > Env > Keychain > Embedded > Prompt) → choose strategy (Embedded → FixedPort 53682; others → DynamicPort) → bind listener (TOCTOU-closed via `ResolvedRedirect`; EADDRINUSE friendly error) → validate scopes → persist app → generate state (32 bytes from OsRng → 64 hex chars; BC-1146) → build authorize URL (no PKCE; NEW-INV-178 + BC-1148, BC-1149) → open browser → accept callback → validate state (CSRF) → exchange code (POST /oauth/token; no `code_verifier`) → discover cloud_id (`accessible_resources.first()` — silent first-wins NEW-INV-179, BC-1176) → store tokens namespaced as `<profile>:oauth-{access,refresh}-token` (BC-1151) → reload config → write profile → success.

2. **OAuth refresh state machine** (Pass 1 R1 §4b) — Production path (`cli/auth.rs::refresh_credentials`): clear-and-relogin (delete keychain pair, then re-invoke handle_login). Alternative path (`api/auth.rs:704 refresh_oauth_token`): `pub` function with NO production callers, kept for future 401 auto-refresh integration. The two precedence chains differ: login resolver has all 6 sources; refresh resolver has 2 (Keychain → Embedded only) per `RefreshAppSource` enum.

3. **Asset enrichment 3-pass topology** (Pass 1 R1 §4c, NEW-INV-228/229) — Pass 1 (extract): `to_enrich: HashMap<(wid,oid),()>` workspace-qualified dedup key + `enrich_indices: Vec<(i,j)>` not-deduplicated positions. Pass 2 (resolve concurrently): `futures::future::join_all` over `to_enrich.keys()` issuing M parallel `client.get_asset(wid, oid)` calls; **bug at `resolved: HashMap<oid,_>` — workspace qualifier dropped (NFR-R-E)**. Pass 3 (redistribute): O(|enrich_indices|) walk; for each position, `resolved.get(oid)`. Performance contract: N×K asset pairs collapse to M unique tuples; total HTTP cost = M (concurrent), not N×K serial.

4. **Sprint-aware list dispatch state machine** (Pass 1 R1 §4d, NEW-INV-219..222) — `jr issue list` branches: `--jql` provided → use as base; else check `board_id`. No board → `project = X`. Board fetch 404 → UserError. Board "scrum" → list_sprints active → SprintFound (`sprint = N` + ORDER BY rank ASC) OR NoActiveSprint (silently degrades to project + ORDER BY updated DESC, NO eprintln warning) OR Err. Board "kanban" → `project = X AND statusCategory != Done ORDER BY rank ASC`. **Cross-module asymmetry:** `cli/sprint.rs` hard-errors on kanban ("Sprints are not available on kanban boards", NEW-INV-285), but `cli/issue/list.rs` silently degrades.

5. **Cache state machine** (Pass 1 R1 §4e) — `read_X_cache(profile, ...)` → file not found → `Ok(None)` (cache miss) | `fs::read_to_string Ok` → serde_json::from_str Err → `eprintln warn "unreadable; will refetch"` → `Ok(None)` | Ok payload → check TTL (now - fetched_at >= 7 days → `Ok(None)`) | fresh → `Ok(Some(payload))`. Cross-call corruption is treated as cache-miss; corrupted file remains on disk until next write. 7 distinct cache types (5 generic via `Expiring` trait + 2 keyed: `project_meta` per-key TTL; `object_type_attrs` file-level TTL).

---

## §3. Behavioral contract index (definitive)

**Total BCs (final after Pass 3 R4 convergence): 540** (475 HIGH / 59 MEDIUM / 6 LOW).

### §3.1 Distribution by subject area (per Pass 3 R4 §3.6)

| # | Subject area | HIGH | MEDIUM | LOW | Total |
|---|---|---:|---:|---:|---:|
| 1 | Auth & Identity | 53 | 4 | 0 | 57 |
| 2 | Issue read | 84 | 6 | 1 | 91 |
| 3 | Issue write | 71 | 5 | 1 | 77 |
| 4 | Issue assets / CMDB | 29 | 3 | 0 | 32 |
| 5 | Boards & Sprints | 32 | 3 | 0 | 35 |
| 6 | Worklogs & duration | 15 | 1 | 0 | 16 |
| 7 | Teams | 11 | 2 | 0 | 13 |
| 8 | Users | 30 | 1 | 0 | 31 |
| 9 | Projects & Queues | 32 | 2 | 0 | 34 |
| 10 | Configuration | 15 | 2 | 1 | 18 |
| 11 | Cache | 17 | 2 | 1 | 20 |
| 12 | Output formatting | 27 | 4 | 1 | 32 |
| 13 | Error handling | 32 | 3 | 0 | 35 |
| 14 | Build-time | 7 | 1 | 1 | 9 |
| 15 | Runtime concerns | 21 | 2 | 0 | 23 |
| 16 | ADF rendering | 53 | 1 | 0 | 54 |
| 17 | `jr api` raw passthrough | 9 | 0 | 0 | 9 |
| 18 | Source unit-test contracts | 41 | 0 | 0 | 41 |
| 19 | CLI smoke / input validation | 7 | 0 | 0 | 7 |
| 20 | Browse URL bug | 2 | 0 | 0 | 2 |
| 21 | OAuth state machine | 9 | 1 | 0 | 10 |
| **Totals** | | **475** | **59** | **6** | **540** |

### §3.2 Top 30 most consequential BCs (security, idempotency, error handling, multi-profile correctness)

In rank order of "would silently break a user-facing contract if regressed":

| Rank | BC ID | Contract | Source pin | Why consequential |
|---:|---|---|---|---|
| 1 | **BC-1085** | 401 + body containing `"scope does not match"` (case-insensitive) → `JrError::InsufficientScope` Display contains all 5 substrings: "Insufficient token scope", raw msg, "write:jira-work", "OAuth 2.0", `github.com/Zious11/jira-cli/issues/185` link | `tests/api_client.rs:99-144` | Single most actionable error; loss of any substring leaves users unable to recover |
| 2 | **BC-1149** | `build_authorize_url` percent-encodes hostile `client_id` containing `&redirect_uri=evil.example#frag` — output contains `client_id=real_id%26redirect_uri%3Devil.example%23frag` and MUST NOT contain `&redirect_uri=evil.example` | `src/api/auth.rs:1043-1060` | Security; XSS-style injection prevention |
| 3 | **BC-1168** | `EmbeddedOAuthApp::Debug` redacts `client_secret`: `format!("{app:?}")` MUST NOT contain literal secret, MUST contain `<redacted>` | `src/api/auth_embedded.rs:34, 220-239` | Defense-in-depth secret-leak guard |
| 4 | **BC-007** | Profile precedence flag > env > config > "default"; threaded as parameter, never via env-var seam | `tests/auth_profiles.rs` (multiple) | Multi-profile correctness boundary |
| 5 | **BC-019** / **NEW-INV-008** | `validate_profile_name` runs at three boundaries; charset `[A-Za-z0-9_-]`; `<= 64` chars; reserved Windows names rejected | `src/config.rs:113-140` | Path-traversal prevention; keychain-key safety |
| 6 | **BC-1153** | Lazy migration for `default` profile only — pre-existing flat keys read by `load_oauth_tokens("default")` and migrated to namespaced; legacy flat key REMOVED post-migration | `src/api/auth.rs:1153-1178` | Multi-profile correctness; "read once, move forever" |
| 7 | **BC-1158** | `load_oauth_tokens("sandbox")` does NOT inherit legacy flat keys; lazy migration is `default`-profile-only | `src/api/auth.rs:1323-1341` | Asymmetric-by-design; pin against silent leakage |
| 8 | **BC-1156** | `load_oauth_tokens` errors on PARTIAL state — access-token without refresh-token (or vice versa) returns Err | `src/api/auth.rs:1249-1269` | Prevents silent half-credential use |
| 9 | **BC-1159** | `resolve_refresh_app_credentials` prefers KEYCHAIN over EMBEDDED — returning BYO user does not silently flip onto embedded mid-session | `src/api/auth.rs:1347-1357` | Mid-session stability pin |
| 10 | **BC-1140/1141** | `RedirectUriStrategy::FixedPort(53682).redirect_uri() == "http://127.0.0.1:53682/callback"` (literal IPv4); `EMBEDDED_CALLBACK_PORT == 53682` | `src/api/auth.rs:927-937, 943-946, 384` | Atlassian validates redirect_uri by EXACT string match; IPv4 vs IPv6 (::1) bug avoidance |
| 11 | **BC-1161** | `Fixed(port).bind()` against pre-bound port — error message contains `"port {port}"`, `"in use"`, `"--client-id"` | `src/api/auth.rs:438-442, 1377-1396` | The actionable hint IS the entire payoff of fixed-port design |
| 12 | **BC-207** | `issue move FOO-1 "In Progress"` is idempotent when current==target — exit 0; stderr `"already in status"`; ZERO POST mock fires | `tests/issue_commands.rs:1500-1604` (BC-1074, BC-1075) | CLAUDE.md-codified idempotency rule |
| 13 | **BC-1010** | `handle_open` URL composition uses `client.base_url()` not `instance_url()` — broken for OAuth profiles | `src/cli/issue/workflow.rs:636` | NFR-R-B (HIGH bug); BC-1076 explicitly verifies opposite path uses `instance_url()` |
| 14 | **BC-1012/1013/1019/1020** | `list_worklogs` non-paginated — fetches one `OffsetPage<Worklog>` and returns `.items().to_vec()`; `total`/`start_at` silently discarded | `src/api/jira/worklogs.rs:25-30` | NFR-R-A (HIGH bug); silent data loss past page 1 |
| 15 | **BC-1014** / **NEW-INV-81** | `worklog add` hardcodes 8h/day, 5d/week — `parse_duration(dur, 8, 5)` literals at `cli/worklog.rs:32`; ignores Jira instance time-tracking | `src/cli/worklog.rs:32` | NFR-R-C (MEDIUM); silent semantic incorrectness for non-default-configured instances |
| 16 | **BC-103/104** | `--all` vs `--limit` cap; truncation hint emitted on stderr | `tests/all_flag_behavior.rs` | Pagination UX contract |
| 17 | **BC-1124/1125** | `--all` against unbounded responder hits 1500-user safety cap; emits stderr `"hit pagination safety cap"`; exit 0 | `tests/user_pagination.rs:459-487, 494-520` | Truncation IS observable |
| 18 | **BC-1118** | `tests/snapshots/issue_changelog__changelog_json_output_snapshot.snap` pins full `jr issue changelog --output json` shape including null-string distinction (`fromString`/`toString` nullable separate from missing field) | `tests/snapshots/issue_changelog__*.snap` | Canonical shape pin |
| 19 | **BC-1063** | `search_issues` default fields list = 16 fields in EXACT order: `summary, status, issuetype, priority, assignee, reporter, project, description, created, updated, resolution, components, fixVersions, labels, parent, issuelinks` | `tests/issue_commands.rs:967-1022` | Default-field-set contract; order matters via `body_partial_json` |
| 20 | **BC-1051** | `search_users` accepts FOUR distinct response shapes: bare array, `{values: [...]}` paginated, empty array, error → Err; via serde-untagged enum | `tests/issue_commands.rs:388-490` | 4-shape robustness contract |
| 21 | **BC-1083/1091** | `client.get` 429-then-200 retries automatically; `send_raw` retries 429 same as `get` | `tests/api_client.rs:42-70, 394-422` | Auto-retry contract |
| 22 | **BC-1092** | `send_raw` 4 consecutive 429s: MAX_RETRIES=3 (initial + 3 retries); FINAL response IS 429 (NOT Err); `expect(4)` | `tests/api_client.rs:424-444` | MAX_RETRIES=3 pin |
| 23 | **BC-1086** | 401 NOT containing `"scope does not match"` falls through to `"Not authenticated"`; MUST NOT contain `"Insufficient token scope"` | `tests/api_client.rs:146-181` | Dispatch boundary pin |
| 24 | **BC-1087** | 401 scope-mismatch dispatch is CASE-INSENSITIVE — body `"Unauthorized; Scope Does Not Match"` STILL dispatches | `tests/api_client.rs:183-216` | Lowercase comparison pin |
| 25 | **BC-1088** | scope-mismatch dispatch is GATED on status==401 — a 403 with "scope does not match" substring does NOT dispatch to InsufficientScope | `tests/api_client.rs:218-255` | Status-gate pin against future broadening |
| 26 | **BC-1135d** | Corrupt `~/.cache/jr/teams.json` (`{"teams": [`) — `jr issue view PROJ-1` STILL succeeds (exit 0); UUID + `"name not cached"` + `"jr team list --refresh"` | `tests/issue_view_errors.rs:1-206` | Cache robustness; serde-from-str failure → Ok(None) mapping |
| 27 | **BC-1139** | Malformed TOML config — exit 78; stderr `"toml"` OR `"parse"`; **file UNCHANGED** (byte-for-byte) | `tests/auth_login_config_errors.rs:18-97` | Destructive-recovery safety; pin against unwrap_or_default regression |
| 28 | **BC-1137a** | `find_cmdb_fields` extracts ONLY fields whose `schema.custom == "com.atlassian.jira.plugins.cmdb:cmdb-object-cftype"` | `tests/cmdb_fields.rs` | Schema-not-name-based heuristic |
| 29 | **BC-308/309** | AQL `aqlFunction()` uses field NAME (not `cf[ID]` or `customfield_NNNNN`); attribute key for object key is capital `Key` (NOT `objectKey`) | `src/jql.rs build_asset_clause` | Confirms two CLAUDE.md gotchas; load-bearing AQL contract |
| 30 | **BC-1094** | `escape_value` proptest: for any `s in "\\PC{0,100}"`, output has NO unescaped quote (regression-pinned via `proptest-regressions/jql.txt`) | `src/jql.rs:383-394` | JQL injection prevention; fuzz-safety pin |

---

## §4. Holdout candidate index

**Total holdout candidates after Pass 3 R4: 47** (H-001..H-047). Holdouts are evaluator-friendly behavioral pins that should be witheld from training/exposed only at evaluation time.

### §4.1 Top 15 evaluator-friendly candidates (clear setup, deterministic expectation, exit-code or stderr observable)

| # | ID | Pin | Setup | Expected | Source |
|---:|---|---|---|---|---|
| 1 | H-001 | `auth status` first-run gives helpful guidance, not error | empty XDG_CONFIG_HOME | exit 0; stderr `"No profiles configured"` | Pass 3 broad |
| 2 | H-005 | Malformed config TOML errors with exit 78 AND does NOT overwrite the file | seeded malformed TOML | exit 78; bytewise file unchanged | BC-1139 |
| 3 | H-006 | `issue move FOO-1 "In Progress"` idempotent when current==target | get_transitions + get_issue mocks | wiremock POST `/transitions` `expect(0)`; exit 0 | BC-1074/1075 |
| 4 | H-008 | Single-substring `--status` rejected when `--no-input` set, without firing JQL search | `jr --no-input issue move FOO-1 prog` | exit 64; wiremock POST `/transitions` `expect(0)` | BC-1079 |
| 5 | H-013 | `send_raw` returns 429 to caller after MAX_RETRIES=3 | 4× 429 mock | response.status()==429; mock `expect(4)` | BC-1092 |
| 6 | H-017 | AQL clause uses field NAME + capital `Key` | unit test on `build_asset_clause` | output contains `aqlFunction("Linked Assets", "Key = OBJ-1")` | BC-308/309 |
| 7 | H-019 | Profile name `foo:bar` rejected at three boundaries | `--profile foo:bar` | exit 64; security-boundary gate | BC-019 |
| 8 | H-038 | `--verbose` Authorization header NOT logged but request body IS | `--verbose jr issue create` | stderr contains body, NOT auth header | NEW-INV-323 |
| 9 | H-042 | EADDRINUSE friendly error includes 5 substrings: `port 53682`, `the jr OAuth callback`, `--client-id`, `JR_OAUTH_CLIENT_ID`, `dynamic port` | bind 53682 then `jr auth login --oauth` | exit non-zero; stderr contains all 5 | BC-1161 |
| 10 | H-043 | `refresh_oauth_token` exists `pub` with no production callers (deferred 401 auto-refresh) | source-grep | function exists; zero call sites in cli/* | NEW-INV-319 |
| 11 | H-044 | 401-auto-refresh wireframe — initial 401 → POST /oauth/token → retry 200 | 3-mock chain | exit 0; total HTTP=3 (currently exit 2) | Pass 3 R4 |
| 12 | H-045 | Zero accessible-resources branch | `accessible_resources` returns `[]` | exit non-zero; stderr `"no Atlassian sites accessible"`; keychain NOT partially written | Pass 3 R4 |
| 13 | H-046 | Multiple accessible-resources + `--no-input` | 3 resources returned | exit non-zero; stderr `"multiple Atlassian sites"`; keychain NOT partially written | Pass 3 R4 |
| 14 | H-047 | OAuth state-mismatch detection at callback | manually craft mismatched state | exit non-zero; stderr `"state mismatch"`; keychain not touched | Pass 3 R4 |
| 15 | H-026 | `jr api` raw passthrough: 404 status preserved through `send_raw`, NOT converted to Err | mock 404 | response status == 404; body intact | BC-1090 |

The full set H-001..H-047 covers OAuth flow gaps, cache-miss recoveries, multi-profile boundary leakage, AQL/JQL escaping, idempotency contracts, error envelope precedence, and pagination safety caps. They form the basis of the eval suite for any port.

---

## §5. NFR catalog (definitive)

**Total NFR concerns after Pass 4 R4: 43** (1 CRITICAL + 4 HIGH + 16 MEDIUM + 22 LOW).

### §5.1 Per-dimension breakdown

| Dimension | CRITICAL | HIGH | MEDIUM | LOW | Total | Notable items |
|---|---:|---:|---:|---:|---:|---|
| **Reliability** | 1 (NFR-R-D) | 3 (NFR-R-A, NFR-R-B, NFR-R-E) | 1 (NFR-R-C) | 4 (NFR-R-F, NFR-R-G, NFR-R-NEW-1, NFR-R-NEW-2) | 9 | All 4 MUST-FIX live here |
| **Security** | 0 | 1 (NFR-S-B) | 2 (NFR-S-A, NFR-S-C) | 1 (NFR-S-D) | 4 | PKCE + JR_AUTH_HEADER + verbose body PII |
| **Observability / UX** | 0 | 0 | 12 | 11 | 23 | Largest dimension; documentation/UX gaps |
| **Performance** | 0 | 0 | 1 (NFR-P-NEW-1) | 4 | 5 | Asset enrichment unbounded `join_all` (429-storm risk); reqwest redirect default; rustls non-FIPS |
| **Scalability** | 0 | 0 | 0 | 2 | 2 | No worker pools; single-binary CLI by design |
| **Total** | **1** | **4** | **16** | **22** | **43** | |

### §5.2 Four MUST-FIX correctness bugs (Pass 4 R4 §3.1)

| # | NFR ID | Severity | Site | Pass 3 BC anchors | Evidence |
|---|---|---|---|---|---|
| 1 | **NFR-R-D — Multi-profile fields silent regression** | CRITICAL | 12+ read sites of `config.global.fields.*` (hot path on every list/view/create/edit; verified: `src/cli/issue/list.rs:147-148`, `sprint.rs:232-233`, `board.rs:192-193`, `create.rs:128/277/283`) | NEW-INV-12, NEW-INV-143 (no direct BC; pre-pinning needed) | `ProfileConfig` at `config.rs:17-25` does carry per-profile `team_field_id`/`story_points_field_id`, but CLI never reads them. Sandbox vs prod custom-field IDs differ → silently writes to wrong field or 400 |
| 2 | **NFR-R-A — `list_worklogs` non-paginated** | HIGH | `src/api/jira/worklogs.rs:25-30` | BC-1012, BC-1013, BC-1019, BC-1020 | `OffsetPage<Worklog>` fetched but only `.items().to_vec()` returned; `total`, `start_at`, `max_results` discarded. Issues with >50 worklogs silently truncate |
| 3 | **NFR-R-B — `handle_open` OAuth URL** | HIGH | `src/cli/issue/workflow.rs:636` | BC-1010, BC-1011 | `format!("{}/browse/{}", client.base_url(), key)` — `base_url()` returns `api.atlassian.com/ex/jira/<cloudId>` for OAuth profiles. `client.instance_url()` exists at `client.rs:355-358`. Fix is one line |
| 4 | **NFR-R-E — Multi-workspace asset HashMap mis-attribution** | HIGH | `src/cli/issue/list.rs:440, 446, 449, 456` (NOT `api/assets/linked.rs` — that file's `enrich_assets` is correct) | NEW-INV-229 (no direct BC) | Pass 1 dedups by `(wid, oid)` correctly, but Pass 2 collapses results into `HashMap<String, _>` keyed by `oid` alone (line 446). Multi-workspace tenant: two assets sharing oid across workspaces → second overwrites first. Single-workspace unaffected |

### §5.3 Notable HIGH/MEDIUM NFRs beyond MUST-FIX

- **NFR-S-B (HIGH)**: `JR_AUTH_HEADER` env-var honored in production binary at `api/client.rs:64-66` — no `#[cfg(test)]` gate. Privilege escalation surface. Recommendation: gate behind `#[cfg(test)]`, or require simultaneous `JR_BASE_URL`, or feature flag.
- **NFR-S-A (MEDIUM)**: No PKCE in OAuth flow at `api/auth.rs:608-616` (no `code_challenge`/`code_verifier`) — defense-in-depth gap per RFC 8252.
- **NFR-S-C (MEDIUM)**: `--verbose` body-logging at `api/client.rs:200-203, 274-278` dumps full request bodies via `String::from_utf8_lossy` — Authorization header redacted but body NOT redacted. Account IDs, comments, summaries flow through.
- **NFR-O-A (MEDIUM)**: ADF mention/emoji/inlineCard/media nodes silently lossy in text mode (`adf.rs` `_` fall-through arm at line 531-540 silently drops; documented in source comment as "per #202 spec").
- **NFR-P-NEW-1 (MEDIUM)**: Asset enrichment `join_all` unbounded — concurrent fan-out has no semaphore/buffer-size cap. For a list with K unique assets, K simultaneous HTTP calls — 429-storm risk.
- **NFR-R-NEW-1 (LOW)**: `Retry-After` parser supports only `parse::<u64>` — RFC 7231 §7.1.3 also permits HTTP-date format (`"Sun, 06 Nov 1994 08:49:37 GMT"`). HTTP-date silently falls through to `DEFAULT_RETRY_SECS = 1`.
- **NFR-R-NEW-2 (LOW)**: `parse_duration` u64-overflow at `duration.rs:29-32` — pathological input like `99999999999999w` wraps silently in release mode (`panic = "abort"` disables overflow check). Fix: `checked_mul`. ~5 LOC.
- **NFR-R-NEW-3** (HIGH if integration; MEDIUM if deferral codified): `refresh_oauth_token` exists `pub` at `api/auth.rs:704-770` with NO production callers. Users hit 401 → must manually `jr auth refresh`. Three holdouts (H-043, H-044) characterize the deferred integration.

---

## §6. Convention catalog (definitive)

### §6.1 7 design patterns (broad + Pass 5 R1 deltas)

1. **Thin client (ADR-0001)**: `JiraClient` is a single struct with 11 public HTTP methods + 70 `impl JiraClient` resource-method blocks at 17 sites. No generated client; no intermediate abstraction layer. Free `pub fn` outside `impl JiraClient` are pure utilities OR cache-aside orchestrators (13 free functions: `enrich_assets`, `resolve_object_key`, `get_or_fetch_workspace_id`, `get_or_fetch_cmdb_fields`, `require_service_desk`, etc.). Pattern holds 100% (Pass 5 R2-T3).
2. **Per-profile signature soft-fence**: every cache reader/writer takes `profile: &str` first. Verifiable: 28 `with_temp_cache` test sites + universal first-arg conformance in `cache.rs`. Soft because it is not type-fenced; a future free-function reader without `profile: &str` would compile.
3. **Two-pass error handling**: validated path (`send → parse_error → JrError`) vs raw passthrough (`request → send_raw → reqwest::Response`). The 6-precedence `extract_error_message` chain (broad pass §3a) consumes any of: `errorMessages`, `errors{field: msg}`, `errors.field.messages[]`, top-level `message`, `errorDescription`, raw text fallback.
4. **Per-build XOR obfuscation (ADR-0006)**: `build.rs` emits `EMBEDDED_ID`, `EMBEDDED_SECRET_XOR`, `EMBEDDED_SECRET_KEY` (32 bytes from OS entropy per build) into `$OUT_DIR/embedded_oauth.rs`. Single `include!` consumer at `src/api/auth_embedded.rs:17`. The runtime decodes lazily; `embedded_oauth_app_present()` is a no-decode presence check (BC-1169).
5. **Smart-constructor pattern**: `EmbeddedOAuthApp` (custom Debug redacts secret), `AuthorNeedle::classify` (heuristic dispatch in `cli/issue/changelog.rs`: `:` or 12+ chars with digit → AccountId; else NameSubstring), `MatchResult` (4-state enum: Exact/ExactMultiple/Ambiguous/None — single substring match returns Ambiguous, not Exact).
6. **3-pass dedup-and-concurrent enrichment**: extract → workspace-qualified dedup → concurrent fan-out via `join_all` → redistribute. Topology pinned by NEW-INV-228/229; bug at result-map workspace-qualifier drop.
7. **Test-isolation via `JR_BASE_URL` + `JiraClient::new_for_test`**: 28 of 36 integration files use library-level construction with wiremock; 8 use process-spawn via `assert_cmd`. Sync `#[test]` (59) for sync surfaces (config/keychain/process); `#[tokio::test]` (265) for any async HTTP. Zero deviation across 324 tests (Pass 5 R2-T4).

### §6.2 7 anti-patterns (broad + Pass 5 R1/R2 deltas)

1. **Module-size shard rule violated**: `cli/auth.rs` (1,998), `cli/assets.rs` (1,055), `cli/issue/list.rs` (1,083 — post-`docs/specs/list-rs-split.md`), `adf.rs` (1,826 cohesive but oversize), `api/auth.rs` (1,397), `config.rs` (1,223), `cli/issue/changelog.rs` (847), `cli/issue/helpers.rs` (813), `cli/issue/workflow.rs` (788). Implicit "shard at ~1000 LOC" rule has regressed.
2. **JSON field naming inconsistency (P5R1-AP-05)**: write-op JSON shapes use 4 distinct booleans: `changed` (move/assign/unassign), `updated` (edit), `linked` (link), `unlinked` (unlink). No single canonical field name.
3. **Hardcoded business constants without configurability**: `worklog add` literal `8/5` (`cli/worklog.rs:32`), `MAX_SPRINT_ISSUES = 50`, `USER_PAGE_SIZE = 100`, `USER_PAGINATION_SAFETY_CAP = 1500`, `CACHE_TTL_DAYS = 7`, `DEFAULT_LIMIT = 30`, `MAX_RETRIES = 3`. All universal-but-not-configurable.
4. **Soft-fence per-profile cache isolation (no compile-time enforcement)**: convention is universal but a future free-function `read_some_cache()` without `profile: &str` parameter would compile and silently leak across profiles.
5. **Handler-level eprintln/println discipline implicit (P5R2-AP-01)**: 47 `eprintln!` + 103 `println!` across 24 CLI handler files with no codified rule. Five categorical profiles (Pure/Read-only/Mixed/Symmetric/no-log-facade) emerge by code-review rather than typed channel.
6. **`refresh_oauth_token` orphan**: `pub` function with zero production callers — limbo state.
7. **Non-atomic cache writes**: `cache.rs:36-43` uses direct `std::fs::write` — no temp-file + atomic rename. Crash leaves indeterminate state. Self-healing via deserialization-failure → cache-miss path, but window exists.

### §6.3 5 GAP categories requiring Phase 1 decisions

| # | Category | Specifics |
|---:|---|---|
| 1 | **Shard rule enforcement** | Add `docs/specs/auth-rs-split.md` and `docs/specs/assets-rs-split.md` — OR codify the exception. The "shard at ~1000 LOC" rule must be either enforced or explicitly waived. |
| 2 | **Type-level fencing for per-profile cache** | Introduce `Profile(String)` newtype or `Cache<P>` phantom-type to compile-time-enforce the per-profile signature. Soft fence has 100% conformance today but is brittle to future contributors. |
| 3 | **JSON field naming consistency** | Adopt a single canonical bool field for write-ops (e.g., `success` or `changed`) — OR document the 4-distinct-name vocabulary as deliberate (action verb-aligned). 5 auth subcommands (login/switch/logout/remove/refresh) lack JSON paths entirely (Pass 5 R2-T2). |
| 4 | **Documentation debt** | (a) 4 undocumented orphan modules: `cli/issue/view.rs` (286), `cli/issue/comments.rs` (61), `observability.rs` (39), `api/assets/schemas.rs` (44) not in CLAUDE.md. (b) CLAUDE.md staleness in 12 deviations (D1-D12 from Pass 1 R1 §3d). (c) `JR_RUN_OAUTH_INTEGRATION` env-var (CONV-ABS-16) gates 1 ignored test but not in CLAUDE.md. |
| 5 | **Test interface convention** | Mixed prefix styles: 108 `test_<verb>_<subject>` + 212 `<subject>_<verb>_<expected>` no-prefix. Newer files use no-prefix; older use prefix. Codify a single style for new tests. |

---

## §7. Convergence report

### §7.1 Per-pass round count and final novelty

| Pass | Subject | Rounds | Final novelty | Time-to-convergence (rounds) |
|---|---|---:|---|---:|
| 0 | Inventory | 2 | NITPICK at R2 | 2 |
| 1 | Architecture | 2 | NITPICK at R2 | 2 |
| 2 | Domain Model | 7 | NITPICK at R7 | 7 (longest — domain model produces SUBSTANTIVE through R6) |
| 3 | Behavioral Contracts | 4 | NITPICK at R4 | 4 |
| 4 | NFR Catalog | 4 | NITPICK at R4 | 4 (R3 resolved cross-round contradiction at NFR-R-E) |
| 5 | Conventions | 2 | NITPICK at R2 | 2 |

Pass 2 took the longest because the domain model has the densest subsystem-by-subsystem deepening targets (auth, list, asset enrichment, configuration, cache). Pass 4 took 4 rounds because of the NFR-R-E wrong-site framing (R2 demoted to DEFERRED at wrong file; R3 re-promoted at correct site).

### §7.2 Total CONV-ABS retractions across rounds

12+ logged corrections across the deepening rounds:

- **CONV-ABS-1..8**: Pass 2 R3-R6 (file attribution corrections, count corrections; e.g., CONV-ABS-4 `cli/issue/list.rs` description in CLAUDE.md is stale because `view.rs`/`comments.rs` are siblings).
- **CONV-ABS-9**: Pass 3 R3 — R2 said "~12 extract_error_message tests" — actual is 11.
- **CONV-ABS-10**: Pass 3 R3 — R1 BC-035 file attribution (DEFAULT_OAUTH_SCOPES test is at `cli/auth.rs:1523-1564`, not `api/auth.rs:34-63`).
- **CONV-ABS-11**: Pass 3 R4 — `tests/auth_login_config_errors.rs` is per-test (single test), not "survey-level".
- **CONV-ABS-12**: Pass 3 R4 — `user_pagination.rs` 7 remaining tests enumerated (R3 had read 4 of 11).
- **CONV-ABS-15**: Pass 0 R1 — direct dep count corrected from 24 to 23.
- **CONV-ABS-16**: Pass 0 R2 — `JR_RUN_OAUTH_INTEGRATION` env-var not in CLAUDE.md.
- **JrError variant count**: corrected from 10 (Pass 1 broad) to 11 (Pass 2 R1 / Pass 5 broad). All `#[from]` variants enumerated: `NotAuthenticated, InsufficientScope, NetworkError, ApiError, ConfigError, UserError, Internal, Interrupted, Http(#[from]), Io(#[from]), Json(#[from])`.
- **Pagination shapes**: corrected from "three" (broad pass §3f prose) to four (`OffsetPage`, `CursorPage`, `ServiceDeskPage`, `AssetsPage`).
- **HTTP method count**: corrected from "two send paths" (Pass 1 broad) to 11 public methods + bifurcated send/send_raw (Pass 1 R1 + Pass 2 R6).

### §7.3 Cross-round contradiction resolution

The single load-bearing contradiction across rounds was **NFR-R-E** (multi-workspace asset HashMap mis-attribution):

- **Pass 2 R5 (correct)**: identified bug at `cli/issue/list.rs:440,446,449,456`. NEW-INV-229.
- **Pass 4 R1 (correct)**: incorporated as HIGH severity NFR-R-E at the correct file.
- **Pass 4 R2 (incorrect)**: erroneously demoted to DEFERRED with a "wrong file" framing — R2 looked at `api/assets/linked.rs::enrich_assets` and found correct workspace-qualified handling there. R2 missed that the bug is in a SECOND, separate enrichment block in `cli/issue/list.rs`.
- **Pass 4 R3 (corrective)**: re-promoted to HIGH at the correct site. Re-verified line numbers: 398, 406, 407, 429, 437, 440, 445, 446, 449, 456.
- **Pass 4 R4 (verification)**: byte-level read of `cli/issue/list.rs:390-463` — all five line numbers cited by R3 match source byte-for-byte.
- **Phase B.6 (validation)**: confirmed line citations exact at all 5 sites.

Final state: NFR-R-E is HIGH severity, MUST-FIX, site is `cli/issue/list.rs:440,446,449,456`. The `api/assets/linked.rs::enrich_assets` is a separate (correct) implementation.

---

## §8. Lessons for jira-cli

This is the mandatory section. SELF-INGEST: target == reference. The lessons are framed as gaps between the live state and an idealized VSDD-rigorous state.

### P0 — Correctness gaps that must fix before next release

#### P0-1: NFR-R-D — Multi-profile fields silent regression (CRITICAL)

- **(a) What the project does today:** All field reads use the legacy `config.global.fields.story_points_field_id` / `team_field_id` path. Verified read sites (≥12): `src/cli/issue/list.rs:147-148`, `src/cli/sprint.rs:232-233`, `src/cli/board.rs:192-193`, `src/cli/issue/create.rs:128, 277, 283`, plus migration plumbing. `ProfileConfig` at `src/config.rs:17-25` does carry per-profile `team_field_id` and `story_points_field_id`, but the CLI handlers never read them.
- **(b) What an idealized version would do:** All field reads go through a profile-aware accessor: `config.field_id(FieldKind::StoryPoints, profile)` that returns the per-profile value when present and falls back to the global (or errors if the profile lacks a configured field).
- **(c) The gap:** Cross-profile correctness bug (CRITICAL). Sandbox vs prod custom-field IDs differ. Sending prod's `customfield_10005` (the configured story-points field for prod) to a sandbox API silently writes to the wrong field or fails 400. CLAUDE.md flags exactly this class as "correctness, not UX."
- **(d) Action items:**
  - Add `Config::field_id(FieldKind, profile: &str) -> Option<String>` accessor in `src/config.rs`.
  - Replace the 12+ `config.global.fields.*` reads (search via Grep tool for `.global.fields.story_points` and `.global.fields.team`) with the new accessor.
  - Add an integration test in `tests/auth_profiles.rs` that: writes profile A with `story_points_field_id = "customfield_A"`, profile B with `customfield_B`, runs `jr issue create --story-points 5 --profile B`, asserts the request body uses `customfield_B`.
  - Add a migration note: existing `[fields]` section maps to `[profiles.<active>.fields]` if not already present per-profile.

#### P0-2: NFR-R-B — handle_open broken for OAuth profiles (HIGH)

- **(a) What the project does today:** `src/cli/issue/workflow.rs:636` constructs the URL via `format!("{}/browse/{}", client.base_url(), key)`. For OAuth profiles, `base_url()` returns `https://api.atlassian.com/ex/jira/<cloud_id>` (the API gateway), so the browser opens a 404/JSON page.
- **(b) What an idealized version would do:** Use `client.instance_url()` (which exists at `src/api/client.rs:355-358` and returns the `*.atlassian.net` user-facing URL even for OAuth profiles). Confirmed correct usage in `tests/issue_commands.rs:1606-1644` (BC-1076) — that test uses `instance_url()`.
- **(c) The gap:** Functional regression for any OAuth profile invoking `jr issue open KEY`.
- **(d) Action items:**
  - One-line fix: change `client.base_url()` → `client.instance_url()` at `src/cli/issue/workflow.rs:636`.
  - Add an integration test under `tests/issue_commands.rs` that uses an OAuth profile fixture (cloud_id-set) and asserts the printed URL contains `*.atlassian.net`, NOT `api.atlassian.com/ex/jira/`.

#### P0-3: NFR-R-A — list_worklogs non-paginated truncation (HIGH)

- **(a) What the project does today:** `src/api/jira/worklogs.rs:25-30` fetches `OffsetPage<Worklog>` and returns `.items().to_vec()` — no loop. `total`, `start_at`, `max_results` silently discarded. Issues with >50 worklogs (Atlassian's default page) silently truncate.
- **(b) What an idealized version would do:** Wrap in a `paginate_offset` loop (same pattern as `list_comments` in `src/api/jira/issues.rs`). Alternatively, emit `eprintln!` warning when `page.total > page.items().len()` so truncation is observable.
- **(c) The gap:** Silent data loss past page 1 for heavily-time-tracked issues.
- **(d) Action items:**
  - Refactor `list_worklogs` in `src/api/jira/worklogs.rs` to use `paginate_offset` (or write a loop iterating until `page.total == cumulative_count`).
  - Add integration test in `tests/worklog_commands.rs`: mock 2-page worklog response (50 + 30), assert all 80 are returned.

#### P0-4: NFR-R-E — Multi-workspace asset HashMap mis-attribution (HIGH)

- **(a) What the project does today:** `src/cli/issue/list.rs:398` builds `to_enrich: HashMap<(wid, oid), ()>` (workspace-qualified). Line 446 builds `resolved: HashMap<String, (String, String, String)>` keyed by `oid` ALONE. Line 440 drops `wid` when futures resolve. Line 449 `resolved.insert(oid, ...)` last-write-wins on oid. Line 456 `resolved.get(oid)` lookup loses workspace context.
- **(b) What an idealized version would do:** `resolved: HashMap<(String, String), _>` keyed by `(workspace_id, object_id)` throughout. Pass 3 redistribution does `resolved.get(&(wid, oid))`.
- **(c) The gap:** Multi-workspace tenants (assets/CMDB users with two or more connected workspaces) silently see misattributed asset enrichment when two assets share an `oid` across workspaces. Single-workspace tenants (oid is unique within a workspace) unaffected.
- **(d) Action items:**
  - Change `resolved` key to `(String, String)` at `src/cli/issue/list.rs:446`.
  - Update `resolved.insert(...)` at line 449 to use `(wid.clone(), oid)`.
  - Update `resolved.get(...)` at line 456 to use `&(wid, oid)`.
  - The `api/assets/linked.rs::enrich_assets` implementation at line 216 already uses workspace-qualified handling — model after that.
  - Add integration test: mock multi-workspace fixture with two assets sharing oid; assert correct fields propagated to each issue.

### P1 — High-ROI improvements to adopt

#### P1-1: PKCE adoption for OAuth (security defense-in-depth)

- **(a) What the project does today:** `src/api/auth.rs:608-616` POSTs to `/oauth/token` with `client_id, client_secret, code, redirect_uri` — no `code_verifier`. `build_authorize_url` includes `client_id, scope, redirect_uri, state, response_type, prompt=consent` — no `code_challenge`/`code_challenge_method` (verified via `grep -rn "pkce\|code_verifier\|code_challenge" src/` returning zero results, NEW-INV-178).
- **(b) What an idealized version would do:** Implement RFC 7636 PKCE: generate `code_verifier` (43-128 chars CSPRNG), `code_challenge = SHA256(code_verifier)` base64url-encoded, send `code_challenge` + `code_challenge_method=S256` in authorize URL, send `code_verifier` in token-exchange POST.
- **(c) The gap:** RFC 8252 recommends PKCE for native apps regardless of confidential-client status. Defense-in-depth against authorization-code interception on the loopback redirect.
- **(d) Action items:**
  - Add ~30 LOC to `src/api/auth.rs`: PKCE generation + S256 challenge + verifier exchange.
  - Update `build_authorize_url` test (BC-1148) to include `code_challenge` + `code_challenge_method=S256`.
  - Update `exchange_code_for_token` test to include `code_verifier`.
  - Cross-reference ADR-0006 to note PKCE complement to embedded-secret model.

#### P1-2: `JR_AUTH_HEADER` test-only gating (security)

- **(a) What the project does today:** `src/api/client.rs:64-66` reads `JR_AUTH_HEADER` env unconditionally; production binary respects it. Any process inheriting that env-var bypasses keychain auth (NEW-INV-310, NFR-S-B).
- **(b) What an idealized version would do:** (a) `#[cfg(test)]` gate the read; OR (b) require simultaneous `JR_BASE_URL` to be set (de-facto pairing — tests already pair them); OR (c) a `feature = "test-seam"` compile-time flag.
- **(c) The gap:** Privilege escalation via env. Especially concerning for CI/CD environments where `JR_AUTH_HEADER` could leak from one job to another.
- **(d) Action items:**
  - Pick option (b) — lowest-risk migration. Modify `src/api/client.rs:64-66` to require `JR_BASE_URL.is_some()` AND `JR_AUTH_HEADER.is_some()` together.
  - Document in CLAUDE.md "AI Agent Notes" that the pair is the test seam.
  - Add a unit test: setting only `JR_AUTH_HEADER` (without `JR_BASE_URL`) is ignored.

#### P1-3: `--verbose` body PII redaction (security)

- **(a) What the project does today:** `src/api/client.rs:200-203` and `:274-278` log full request body via `String::from_utf8_lossy`. Account IDs, ADF-encoded comment text, summaries, descriptions all flow through. Authorization header IS NOT logged (only path).
- **(b) What an idealized version would do:** Redact known PII fields before logging. JSON body → walk fields → replace `assignee.accountId`, `accountId`, `description`, `comment.body`, `summary` with `<redacted>`. Or default `--verbose` to header-only and add `--verbose-bodies` opt-in.
- **(c) The gap:** PII leakage to AI-agent transcripts and incident logs. Atlassian account IDs are PII under GDPR.
- **(d) Action items:**
  - Add `redact_body(json: &Value) -> Value` helper in `src/observability.rs`.
  - Wire into `client.rs:200-203` and `:274-278`.
  - Add tests: assert redacted body contains `<redacted>` substring at known field paths.
  - Document in CLAUDE.md "AI Agent Notes": `--verbose` is safe to share.

#### P1-4: `accessible_resources` disambiguation for multi-site OAuth users

- **(a) What the project does today:** `src/api/auth.rs:666-668` uses `resources.first().ok_or_else(...)` — silent first-result-wins (NEW-INV-179). User with multiple cloud sites is silently authenticated to whichever Atlassian returns first.
- **(b) What an idealized version would do:** When `resources.len() > 1`: under interactive mode, prompt user via `inquire::Select` to choose; under `--no-input`, error with hint to add `--cloud-id <id>` flag. Add `--cloud-id` flag to `auth login` clap definition.
- **(c) The gap:** Multi-site UX surprise. Holdouts H-045 and H-046 characterize the gap.
- **(d) Action items:**
  - Add `--cloud-id <ID>` flag to `LoginArgs` in `src/cli/auth.rs`.
  - Wire branch in `oauth_login` flow: zero resources → error; 1 → use; >1 with cloud_id → match (or error if not in list); >1 without cloud_id + interactive → prompt; >1 without cloud_id + `--no-input` → error.
  - Add integration tests for H-045 + H-046 wireframes.

#### P1-5: 401 auto-refresh wiring (UX)

- **(a) What the project does today:** `refresh_oauth_token` exists at `src/api/auth.rs:704-770` `pub` with NO production callers. `JiraClient::send` does NOT auto-refresh on 401; surfaces as `JrError::NotAuthenticated`. User must manually run `jr auth refresh`. (Per CLAUDE.md: "Currently has no production callers — it exists for a future 401 auto-refresh integration.")
- **(b) What an idealized version would do:** When `send` receives 401 with `expired_token` body for an OAuth profile, attempt one refresh-token grant via `refresh_oauth_token`. On success, retry the original request once with the new token. On failure, surface the original 401.
- **(c) The gap:** Stale token UX — user must context-switch to recover. Holdout H-044 has the full wireframe.
- **(d) Action items:**
  - Wire `refresh_oauth_token` into `send` at `src/api/client.rs` (around line 195 where auth header is injected).
  - Implement single-attempt retry (no infinite loop — guard against repeated 401s).
  - Add integration test per H-044 wireframe (3-mock chain).
  - On success, write new tokens to keychain via `store_oauth_tokens`.

#### P1-6: Shard `cli/auth.rs` and `cli/assets.rs` (maintainability)

- **(a) What the project does today:** `src/cli/auth.rs` is 1,998 LOC (44 inline unit tests + login/switch/list/status/refresh/logout/remove handlers). `src/cli/assets.rs` is 1,055 LOC (21 inline unit tests + search/view/tickets/schemas/types/schema handlers). Both violate the implicit ~1000 LOC shard rule.
- **(b) What an idealized version would do:** Split via the same approach as `cli/issue/`: create `src/cli/auth/{mod.rs, login.rs, switch.rs, list.rs, status.rs, refresh.rs, logout.rs, remove.rs, helpers.rs}` and `src/cli/assets/{mod.rs, search.rs, view.rs, tickets.rs, schemas.rs, types.rs, schema.rs, helpers.rs}`. Mirror the `cli/issue/` layout.
- **(c) The gap:** Maintainability. Largest single CLI handler files in the codebase.
- **(d) Action items:**
  - Add `docs/specs/auth-rs-split.md` (analogous to `docs/specs/list-rs-split.md`).
  - Add `docs/specs/assets-rs-split.md`.
  - Refactor incrementally; preserve 44+21 inline unit tests at the new module locations.

#### P1-7: Type-level fence for per-profile cache (correctness boundary)

- **(a) What the project does today:** Convention is "every cache function takes `profile: &str` first" (universal — 100% conformance per Pass 5 R2-T3). But it is **soft fence** — a future free-function cache reader without `profile: &str` would compile.
- **(b) What an idealized version would do:** Introduce `pub struct Profile(String);` newtype. Cache function signatures change from `read_team_cache(profile: &str)` to `read_team_cache(profile: &Profile)`. The newtype is the only way to construct a profile-scoped cache key. Compiler-enforced.
- **(c) The gap:** Future contributor could add a profile-unaware cache function. Cross-profile leakage is a correctness bug, not UX.
- **(d) Action items:**
  - Add `Profile` newtype to `src/config.rs` alongside `Config::active_profile_name`.
  - Update all cache function signatures in `src/cache.rs` to take `&Profile`.
  - Update CLI handler call sites to convert `&config.active_profile_name` to `&Profile`.
  - Update `JiraClient::new_for_test` to default `profile: Profile("default".into())`.

#### P1-8: Document the 4 undocumented orphan modules in CLAUDE.md

- **(a) What the project does today:** CLAUDE.md does not mention `cli/issue/view.rs` (286 LOC), `cli/issue/comments.rs` (61), `observability.rs` (39), or `api/assets/schemas.rs` (44). These exist as code, but are missing from the documented architecture.
- **(b) What an idealized version would do:** CLAUDE.md `cli/issue/` block lists all 12 files (mod, format, list, view, comments, changelog, create, workflow, links, helpers, json_output, assets). `api/assets/` block lists all 5 files. `lib.rs` block calls out `pub(crate) observability` exception.
- **(c) The gap:** Documentation drift; new contributors discover these by reading code instead of CLAUDE.md.
- **(d) Action items:**
  - Update `/Users/zious/Documents/GITHUB/jira-cli/CLAUDE.md` to include the 12 deviations from Pass 1 R1 §3d (D1-D12).
  - Reconcile module-path tree to match current state.
  - Add `JR_RUN_OAUTH_INTEGRATION` to "AI Agent Notes" alongside `JR_RUN_KEYRING_TESTS`.

### P2 — Worth considering

#### P2-1: JSON field naming canonicalization

- **(a) What the project does today:** Write-op JSON shapes use 4 distinct booleans: `changed` (move/assign/unassign), `updated` (edit), `linked` (link), `unlinked` (unlink). 5 auth subcommands lack JSON paths entirely.
- **(b) What an idealized version would do:** Single canonical bool — e.g., `success: true|false` plus an `action: "moved"|"edited"|"linked"|"unlinked"` field. Add JSON shapes for the 5 auth subcommands (login → `{"profile": "X", "ok": true}`; logout → similar).
- **(c) The gap:** Non-uniform consumer parsing for `--output json`. Snapshot-pinned, so any change is high-friction.
- **(d) Action items:**
  - Phase 1 decision: keep distinct verb-aligned booleans (action-verb-style) OR canonicalize to `success`. If canonicalizing, deprecate old fields with one-release overlap.
  - Add JSON shapes for 5 auth gaps in `src/cli/auth.rs`.

#### P2-2: Asset enrichment concurrency bounding (429-storm risk)

- **(a) What the project does today:** `src/cli/issue/list.rs:445` and `src/api/assets/linked.rs:216` use `futures::future::join_all` with no concurrency cap. For a list with K unique assets, K simultaneous HTTP calls fire (NFR-P-NEW-1).
- **(b) What an idealized version would do:** Use `futures::stream::iter(...).buffer_unordered(N)` with a small N (e.g., 5-10) to bound concurrent HTTP load.
- **(c) The gap:** 429-storm risk for large issue lists with many CMDB-linked assets. Today `MAX_RETRIES=3` mitigates.
- **(d) Action items:**
  - Replace `join_all` with `buffer_unordered(8)` at `cli/issue/list.rs:445` and `api/assets/linked.rs:216`.
  - Add tuning constant `MAX_CONCURRENT_ASSET_FETCHES = 8` in same file.

#### P2-3: Retry-After RFC 7231 HTTP-date support

- **(a) What the project does today:** `src/api/rate_limit.rs:14-19` only `parse::<u64>` — HTTP-date silently falls through to `DEFAULT_RETRY_SECS = 1`.
- **(b) What an idealized version would do:** Try integer parse, then fall back to HTTP-date parse via `chrono::DateTime::parse_from_rfc2822` (or similar) computing seconds-from-now.
- **(c) The gap:** Defensive — Atlassian sends seconds in practice, no observed bug.
- **(d) Action items:**
  - Add HTTP-date fallback in `parse_retry_after`.
  - Property test: arbitrary integers parse correctly; arbitrary HTTP-dates parse correctly; invalid input falls through to `DEFAULT_RETRY_SECS`.

#### P2-4: Worklog hours_per_day/days_per_week from Jira instance settings

- **(a) What the project does today:** `src/cli/worklog.rs:32` passes literal `8, 5` to `parse_duration`. Atlassian instances configure these via `/rest/api/3/configuration/timetracking`. Silent wrong answer for 7.5h or 4-day setups (NFR-R-C).
- **(b) What an idealized version would do:** Fetch + cache time-tracking config (7-day TTL alongside other caches). Fall back to 8/5 only on cache miss.
- **(c) The gap:** Most users keep defaults but a long tail does not.
- **(d) Action items:**
  - Add `get_timetracking_config(&self) -> Result<TimeTrackingConfig>` on `JiraClient`.
  - Add cache integration in `cache.rs` (new entry: `time_tracking.json`).
  - Wire into `cli/worklog.rs:32`.

#### P2-5: ADF lossy node handling (mention/emoji/inlineCard/media)

- **(a) What the project does today:** `src/adf.rs` `_` fall-through arm at lines 531-540 silently drops mention/emoji/inlineCard/media nodes in text mode. Documented in source comment as "per #202 spec, this avoids debug strings like '[unsupported: type]' reaching user output." `--output json` preserves them.
- **(b) What an idealized version would do:** Render `@<displayName>` for mentions (when `displayName` field is present); `:emoji:` for emojis; `[<title>](url)` for inlineCard. Fall through to silent drop only for media (which is binary content not appropriate for text).
- **(c) The gap:** Comments containing @mentions render with the mention dropped.
- **(d) Action items:**
  - Extend `render_node` match in `src/adf.rs:531-540` with explicit arms for mention/emoji/inlineCard.
  - Update `tests/snapshots/jr__adf__tests__adf_to_text_complex.snap` if needed.

#### P2-6: Tracing crate adoption (replace inline eprintln + observability.rs)

- **(a) What the project does today:** `src/observability.rs` is 39 LOC with a single `log_parse_failure_once` function used at 3 sites (`types/jira/issue.rs:103`, `cli/issue/format.rs:119`, `cli/issue/changelog.rs:269`). 47 `eprintln!` + 103 `println!` across 24 CLI handler files; no `log` or `tracing` crate adoption.
- **(b) What an idealized version would do:** Use `tracing` crate (already a dep at line 35) with structured spans. Replace `eprintln!("[verbose] ...")` with `tracing::debug!`. Configure `tracing-subscriber` (also a dep) at `main.rs` based on `--verbose` flag.
- **(c) The gap:** AI-agent integration would benefit from structured tracing. Hand-built `eprintln!` strings are not parseable.
- **(d) Action items:**
  - Initialize `tracing-subscriber` in `src/main.rs` per `--verbose` flag.
  - Replace `eprintln!("[verbose] ...")` calls with `tracing::debug!`.
  - Keep human-facing messages (`print_success`, etc.) on direct stderr.

### P3 — Known divergences to document

#### P3-1: `--open` filter has two mechanisms (by API shape, not preference)

- **(a) What the project does today:** For Jira issues: JQL clause `statusCategory != Done` (server-side filter at `cli/issue/list.rs:303, 308, 625`). For connected tickets: client-side filter `status.color_name != "green"` (`cli/assets.rs:303-321`). The `Issue::status` from `/search/jql` carries `StatusCategory.key`; the `/connectedTickets` JSM endpoint returns `TicketStatus { name, colorName }` — different shape.
- **(b) What an idealized version would do:** Document this as ONE semantic ("filter to non-Done") with TWO implementations. The mechanism is forced by the API shape, not by design preference.
- **(c) The gap:** Documentation, not behavior.
- **(d) Action items:**
  - Add to CLAUDE.md "Gotchas" or `docs/specs/`: explicit pairing of the two mechanisms.

#### P3-2: User pagination advances by USER_PAGE_SIZE not returned-count (deliberate per JRACLOUD-71293)

- **(a) What the project does today:** `src/api/jira/users.rs` user-search loop advances `start_at += USER_PAGE_SIZE` (NOT by returned count). Pinned by `tests/user_pagination.rs:202-247` (`search_users_all_continues_past_short_non_empty_page`). NEW-INV-19.
- **(b) What an idealized version would do:** Same — this is a deliberate workaround for Atlassian bug JRACLOUD-71293 ("Atlassian returns short pages mid-stream then resumes"). Advancing by returned-count would re-scan rows 35..100 producing duplicates.
- **(c) The gap:** Non-obvious behavior; a future contributor "fixing" the pagination loop would regress the workaround.
- **(d) Action items:**
  - Document in source comment at `src/api/jira/users.rs` next to the increment site.
  - Document in CLAUDE.md "Gotchas" alongside the existing `aqlFunction` and status-color gotchas.

#### P3-3: get_changelog anti-loop guard (defensive programming)

- **(a) What the project does today:** `src/api/jira/issues.rs:222-230` has a defensive break if `nextPage` URL equals current URL (prevents infinite loop). NEW-INV-18, NFR-R-F (LOW).
- **(b) What an idealized version would do:** Same. Already correct. `search_issues` (cursor-based) does NOT have an analogous guard despite cursor=cursor regression possibility (NEW-INV-263).
- **(c) The gap:** Document the pattern, optionally extend to `search_issues`.
- **(d) Action items:**
  - Document the pattern in `docs/specs/` or as a source comment.
  - Optional: add similar guard to `search_issues` cursor loop.

#### P3-4: Asset enrichment 3-pass topology (extract → dedup → concurrent enrich → redistribute)

- **(a) What the project does today:** `cli/issue/list.rs:390-463` implements 3-pass topology: Pass 1 extract with `(wid, oid)` dedup → Pass 2 concurrent `join_all` resolution → Pass 3 redistribute via `enrich_indices`. Topology is non-obvious; broad pass 4 initially mischaracterized as "serial N+1."
- **(b) What an idealized version would do:** Same topology, with type-level encoding of the 3-pass shape (e.g., distinct types `EnrichmentTargets`, `ResolvedAssets`, `EnrichedIssues`).
- **(c) The gap:** Architecture pattern not documented; future maintainers may "optimize" by collapsing to 1-pass and reintroduce N+1 OR break dedup correctness.
- **(d) Action items:**
  - Add Mermaid diagram to `docs/specs/asset-enrichment-3-pass.md` (mirror Pass 1 R1 §4c).
  - Add unit test that asserts `to_enrich.len() == unique_(wid,oid)_count` (dedup invariant).

#### P3-5: Embedded XOR obfuscation (per ADR-0006 — protects against casual scraping, not adversaries)

- **(a) What the project does today:** Per-build random 32-byte XOR key in `build.rs:21-29`; `client_secret` XOR-encoded into binary; runtime decodes. ADR-0006 explicitly notes "protects against casual scraping by people running `strings` over the binary, not against adversaries with disassembly tools." NFR-S-D (LOW).
- **(b) What an idealized version would do:** Same. The threat model is documented and accepted.
- **(c) The gap:** Documentation only. ADR-0006 is current; no action needed. But if a future Phase 1 contributor argues for stronger protection, ADR-0006's threat-model framing is the right reference.
- **(d) Action items:**
  - None directly. Cross-reference ADR-0006 in any "OAuth security" Phase 1 document.

---

## §9. Recommendations for downstream skills

### `/create-brief`

- **What to import:** Executive summary (§1); the 14 bounded contexts table (§2.2); the layer architecture (§2.3); the 5 state machines (§2.5).
- **What to derive:** A 1-2 page "what jr does" brief should derive the user-facing surface from §2.2 + §3.1 (BC distribution by subject area) — e.g., "jr supports 14 top-level commands across 5 risk-tier-HIGH bounded contexts."
- **Specific imports:** ADR-0001 (thin client), ADR-0006 (embedded OAuth) as load-bearing decisions to surface in the brief.
- **Count:** 1 brief document.

### `/create-domain-spec`

- **What to import:** The full entity model is **READY**. 265 entities (51 broad + 33 R1 + 67 R2 + 31 R3 + 25 R4 + 31 R5 + 27 R6 + 0 R7), 411 invariants (NEW-INV-1..411 monotonic range), 7 bounded contexts at top-level + 7 sub-contexts at command-family level (per §2.2).
- **Sources:** `jira-cli-pass-2-domain-model.md` + `jira-cli-pass-2-deep-r1.md` through `r6.md`.
- **What to derive:** A formal domain glossary mapping the entities to ubiquitous-language terms; entity relationship diagrams (Mermaid).
- **Count:** 1 domain spec covering 7 contexts + glossary.

### `/create-prd`

- **What to import:** BC catalog is **READY** (540 BCs, 96.7% behaviorally validated). Top 30 consequential BCs in §3.2 are PRD-grade contracts.
- **Specific NFR decisions needed:** PKCE (NFR-S-A), `JR_AUTH_HEADER` gating (NFR-S-B), verbose body redaction (NFR-S-C), retry-after upper bound (NFR-R-NEW-1), HTTP-date support (NFR-R-NEW-1), parse_duration overflow (NFR-R-NEW-2). Decisions: KEEP / FIX / DOCUMENT.
- **MUST-FIX requirements:** The 4 P0 bugs are PRD-mandatory acceptance criteria.
- **Count:** 1 PRD with explicit accept/reject decisions on the 43 NFR concerns.

### `/decompose-stories`

- **Wave 1 (MUST-FIX):** 4 stories — one per P0 bug. Each gets clear acceptance criteria from §8 P0 action items + integration test specifications.
- **Wave 2 (P1 improvements):** 8 stories — PKCE, JR_AUTH_HEADER gating, verbose redaction, accessible_resources disambiguation, 401 auto-refresh wiring, cli/auth.rs split, cli/assets.rs split, Profile newtype.
- **Wave 3 (P2/P3 documentation):** ~10 stories — ADF lossy nodes, time-tracking config, asset concurrency bound, JSON canonicalization, tracing adoption, plus 5 documentation-only stories from P3.
- **Cross-cutting epic:** "Documentation harmonization" — update CLAUDE.md (12 deviations), add `docs/specs/auth-rs-split.md`, `docs/specs/assets-rs-split.md`, `docs/specs/asset-enrichment-3-pass.md`.
- **Count:** ~22 stories across 3 waves + 1 cross-cutting epic.

### `/create-architecture`

- **Adopt:** The 5 state machines from Pass 1 R1 §4 (OAuth login, OAuth refresh, asset enrichment 3-pass, sprint-aware list dispatch, cache state) as architecture-level diagrams.
- **Add:** HTTP-path bifurcation diagram (Pass 1 R1 §6d / §8) — the L3 split between validated `send → parse_error → JrError` (9 methods, 99% of callers) and raw `send_raw → reqwest::Response` (2 methods, only `cli/api.rs` uses).
- **Cross-reference:** ADRs 1, 3, 4, 5, 6 (all current); reference ADR-0002 as Superseded.
- **Open architecture decisions:** P0+P1 items (especially PKCE, type-level Profile fence, shard rule enforcement).
- **Count:** 1 architecture document with 6 Mermaid diagrams.

---

## §10. Pre-VSDD docs treatment recommendation

**Treatment: HARMONIZE.** Restated and refined from Pass 6 §7.5 with new findings.

| Stratum | Files | LOC | Treatment | Justification |
|---|---:|---:|---|---|
| **`docs/adr/`** | 6 | 169 | **KEEP — all authoritative** | ADR-0001 (thin client), ADR-0003 (reqwest+rustls-tls), ADR-0004 (per-feature specs), ADR-0005 (GraphQL hostNames for org discovery), ADR-0006 (embedded OAuth + XOR). ADR-0002 retained as Superseded historical record. |
| **`docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md`** | 1 | 668 | **IMPORT AS HISTORICAL CONTEXT** | This was the v1 design; the codebase has grown beyond it. Mark its status field as "Implemented in v1; see Phase 1 VSDD for current state." Do not regenerate; do not treat as authoritative. |
| **`docs/superpowers/plans/`** | 75 | ~56,572 | **SUPERSEDE** | Pre-VSDD TDD-style red/green/refactor checklists for v1 features. The features are delivered. Do not import as input to Phase 2 stories. Add a directory README marking "Pre-VSDD plans, retained for archaeological reference." |
| **`docs/specs/`** (post-v1 feature specs) | 22 | ~3,778 | **TREAT AS PHASE 2 STORY CANDIDATES** | ADR-0004 codifies this directory's role. Each spec checked for: (a) describes delivered behavior → becomes BC catalog validation input; (b) describes planned-but-not-delivered → becomes Phase 2 story candidate. The `list-rs-split.md` is a good test case: delivered, but the underlying "shard at ~1000 LOC" rule has regressed (so the spec has dual value as both delivered-pin and architectural-rule-source). |

**Decision criteria for the user**:
- **HARMONIZE** (recommended): preserve ADRs and post-v1 specs as inputs; supersede v1 plans; document v1 design as historical.
- **REFERENCE-ONLY**: treat all four directories as historical, fully supersede with Phase 1 VSDD docs.
- **SUPERSEDE**: delete pre-VSDD; rebuild from scratch.

The HARMONIZE recommendation is strongest because the ADRs and post-v1 specs encode real domain knowledge that would otherwise need to be rederived — and ADR-0006 (embedded OAuth threat model) in particular is impossible to reconstruct without the original threat-model debate.

---

## §11. State checkpoint

```yaml
pass: 8
phase: C
status: complete
synthesis_type: final_definitive
supersedes: jira-cli-pass-6-synthesis.md
inputs_consumed:
  broad_pass_files: 7        # passes 0-6
  deepening_round_files: 17  # 0-r1/r2, 1-r1/r2, 2-r1..r7, 3-r1..r4, 4-r1..r4, 5-r1/r2
  validation_files: 2        # coverage-audit, extraction-validation
  project_docs: 1            # CLAUDE.md
  total: 27
bounded_contexts: 14
state_machines: 5
total_bcs: 540
bcs_high: 475
bcs_medium: 59
bcs_low: 6
holdouts: 47
nfr_concerns: 43
nfr_critical: 1
nfr_high: 4
nfr_medium: 16
nfr_low: 22
must_fix_bugs: 4
must_fix_ids:
  - NFR-R-D    # CRITICAL — multi-profile fields
  - NFR-R-A    # HIGH     — list_worklogs non-paginated
  - NFR-R-B    # HIGH     — handle_open OAuth URL
  - NFR-R-E    # HIGH     — multi-workspace asset HashMap
design_patterns: 7
anti_patterns: 7
gap_categories: 5
lessons_p0: 4
lessons_p1: 8
lessons_p2: 6
lessons_p3: 5
lessons_total: 23
downstream_recommendations:
  create_brief: 1                  # 1 brief document
  create_domain_spec: 1            # 1 spec, 7 contexts + glossary
  create_prd: 1                    # 1 PRD with 43 NFR decisions
  decompose_stories: 22            # ~22 stories across 3 waves + 1 epic
  create_architecture: 1           # 1 doc with 6 Mermaid diagrams
pre_vsdd_treatment: HARMONIZE
extraction_validation_verdict: PASS
extraction_validation_behavioral_accuracy: 96.7  # 29/30 confirmed; 1 self-corrected stale claim
extraction_validation_metric_accuracy: 92.3      # 24/26 within threshold; 2 annotation-level deltas
extraction_validation_hallucinations: 0
coverage_audit_verdict: PASS
coverage_audit_blind_spots: 0                    # all source files >=100 LOC have substantive content-level coverage
convergence_pass_0_rounds: 2     # NITPICK at R2
convergence_pass_1_rounds: 2     # NITPICK at R2
convergence_pass_2_rounds: 7     # NITPICK at R7 (longest)
convergence_pass_3_rounds: 4     # NITPICK at R4
convergence_pass_4_rounds: 4     # NITPICK at R4 (R3 resolved cross-round contradiction at NFR-R-E)
convergence_pass_5_rounds: 2     # NITPICK at R2
total_conv_abs_retractions: 16   # CONV-ABS-1..16 across rounds
load_bearing_contradictions_resolved: 1  # NFR-R-E framing across Pass 4 R1->R2->R3
timestamp: 2026-05-04T19:30:00Z
phase_d_ready: true
ready_for_phase_1: true
human_approval_gate: pending
```

---

## End of Pass 8 — final synthesis

This document is the definitive deliverable for Phase 0 → Phase 1 transition. All downstream skills (`/create-brief`, `/create-domain-spec`, `/create-prd`, `/decompose-stories`, `/create-architecture`) should treat this as the primary reference and supersede `jira-cli-pass-6-synthesis.md`.

**Phase C final synthesis complete; ready for Phase 0 → Phase 1 human approval gate.**
