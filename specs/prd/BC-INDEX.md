---
context: bc-index
title: "BC Master Index"
total_bcs: 541
last_updated: 2026-05-04
source_pass: 3
sections:
  - bc-1-auth-identity.md (57 BCs)
  - bc-2-issue-read.md (91 BCs)
  - bc-3-issue-write.md (77 BCs)
  - bc-4-assets-cmdb.md (32 BCs)
  - bc-5-boards-sprints.md (35 BCs)
  - bc-6-config-cache.md (38 BCs)
  - bc-7-output-render.md (80 BCs)
  - cross-cutting.md (130 BCs) [X prefix]
  - nfr-catalog.md (44 NFR items, not counted in BC total)
---

# BC Master Index — jira-cli L3 PRD

Master traceability: L3 BC ID → L2 entity → Pass 3 BC ID → Source code → Confidence → Subject

---

## Index Format

```
| L3 BC ID | Summary | Pass 3 BC ID | Source code | Confidence | Subject |
```

Pass 3 BC ID refers to the originating BC number in the semport pass files.
R1/R4/R4 prefix = deepening round that introduced it.

---

## Section 1: Auth & Identity (bc-1-auth-identity.md) — 57 BCs

### 1.1 OAuth Flow & Profile Resolution (18 BCs)

| L3 BC ID | Summary | Pass 3 BC ID | Source code | Confidence | Subject |
|---|---|---|---|---|---|
| BC-1.1.001 | `get_or_create_http_client` caches reqwest client per-profile | BC-001 | src/api/client.rs | HIGH | Auth & Identity |
| BC-1.1.002 | `JiraClient::new_for_test(base_url, auth_header)` constructs test client | BC-002 | src/api/client.rs | HIGH | Auth & Identity |
| BC-1.1.003 | `auth login --api-token --no-input` requires all three: `--url`, `--email`, `--token` | BC-003 | tests/auth_profiles.rs | HIGH | Auth & Identity |
| BC-1.1.004 | `auth login --oauth` launches browser + loopback HTTP listener | BC-004 | src/api/auth.rs | HIGH | Auth & Identity |
| BC-1.1.005 | `JR_AUTH_HEADER` env var overrides keychain auth (test seam) | BC-005 | src/api/client.rs:64-66 | HIGH | Auth & Identity |
| BC-1.1.006 | `auth switch <name>` sets `default_profile`; errors if name unknown | BC-006 | tests/auth_profiles.rs | HIGH | Auth & Identity |
| BC-1.1.007 | Profile resolution precedence: flag > env > config > "default" | BC-007 | src/config.rs::resolve_active_profile_name | HIGH | Auth & Identity |
| BC-1.1.008 | `auth logout` removes keychain tokens for active profile; config preserved | BC-008 | tests/auth_profiles.rs | HIGH | Auth & Identity |
| BC-1.1.009 | Per-profile keychain key namespacing: `<profile>:oauth-access-token` | BC-009 | src/api/auth.rs | MEDIUM | Auth & Identity |
| BC-1.1.010 | email/api-token are shared (flat) keychain keys across profiles | BC-010 | src/api/auth.rs | MEDIUM | Auth & Identity |
| BC-1.1.011 | `JR_PROFILE` env var sets active profile | BC-011 | src/config.rs:307 | HIGH | Auth & Identity |
| BC-1.1.012 | `auth login` does NOT check profile existence (lenient mode) | R1 BC-907-R | src/config.rs:285-289 | HIGH | Auth & Identity |
| BC-1.1.013 | `build_authorize_url` produces correct OAuth2 authorize URL | R4 BC-1148 | src/api/auth.rs | HIGH | Auth & Identity |
| BC-1.1.014 | `exchange_code_for_token` POSTs to `/oauth/token` with code | R4 BC-1150 | src/api/auth.rs:608-616 | HIGH | Auth & Identity |
| BC-1.1.015 | `accessible_resources` uses first result (silent first-wins) | R4 BC-1151 | src/api/auth.rs:666-668 | MEDIUM | Auth & Identity |
| BC-1.1.016 | `refresh_oauth_token` has zero production callers (future integration) | R4 BC-1156 | src/api/auth.rs:704-770 | HIGH | Auth & Identity |
| BC-1.1.017 | `store_oauth_tokens` writes per-profile namespaced keychain keys | R4 BC-1157 | src/api/auth.rs | HIGH | Auth & Identity |
| BC-1.1.018 | `FixedPort(53682).redirect_uri()` = `"http://127.0.0.1:53682/callback"` (IPv4 literal) | R4 BC-1140 | src/api/auth.rs:927-937 | HIGH | Auth & Identity |

### 1.2 Profile Lifecycle (6 BCs: BC-1.2.013..018)

| L3 BC ID | Summary | Pass 3 BC ID | Source code | Confidence | Subject |
|---|---|---|---|---|---|
| BC-1.2.013 | `auth list --output json` returns array of profile objects | BC-013 | tests/auth_profiles.rs | HIGH | Auth & Identity |
| BC-1.2.014 | `auth list` table shows NAME/URL/AUTH/STATUS columns; active prefix `* ` | R4 BC-1115 | src/cli/snapshots/auth_list_table.snap | HIGH | Auth & Identity |
| BC-1.2.015 | `auth remove <active-profile>` errors with "cannot remove active" | BC-015 | tests/auth_profiles.rs | HIGH | Auth & Identity |
| BC-1.2.016 | `auth remove <non-active>` removes profile + clears cache + clears keychain | BC-016 | tests/auth_profiles.rs | HIGH | Auth & Identity |
| BC-1.2.017 | `auth status` shows all profiles including active indicator | BC-017 | tests/auth_profiles.rs | HIGH | Auth & Identity |
| BC-1.2.018 | `auth status` on empty config → exit 0 + "No profiles configured" | BC-018 | tests/auth_profiles.rs | HIGH | Auth & Identity |

### 1.3 Embedded OAuth App (6 BCs: BC-1.3.019..024)

| L3 BC ID | Summary | Pass 3 BC ID | Source code | Confidence | Subject |
|---|---|---|---|---|---|
| BC-1.3.019 | `EmbeddedOAuthApp::Debug` redacts the secret field | BC-019 | src/api/auth_embedded.rs | HIGH | Auth & Identity |
| BC-1.3.020 | Empty XOR inputs → `embedded_oauth_app() == None` | BC-020 | src/api/auth_embedded.rs | HIGH | Auth & Identity |
| BC-1.3.021 | `embedded_oauth_app_present()` is a no-decode presence check | BC-021 | src/api/auth_embedded.rs | HIGH | Auth & Identity |
| BC-1.3.022 | BYO OAuth (`--client-id` + `--client-secret`) uses dynamic port | R4 BC-1147 | src/api/auth.rs | HIGH | Auth & Identity |
| BC-1.3.023 | Embedded callback port = 53682 (literal const) | R4 BC-1141 | src/api/auth.rs:943-946 | HIGH | Auth & Identity |
| BC-1.3.024 | `DynamicPort(54321).redirect_uri()` = `"http://localhost:54321/callback"` (localhost, not 127.0.0.1) | R4 BC-1140 | src/api/auth.rs:927-937 | HIGH | Auth & Identity |

### 1.4 Token Keychain (6 BCs: BC-1.4.025..030)

| L3 BC ID | Summary | Pass 3 BC ID | Source code | Confidence | Subject |
|---|---|---|---|---|---|
| BC-1.4.025 | "default" profile lazy-migrates legacy flat OAuth keys on first read | BC-023 | src/api/auth.rs | MEDIUM | Auth & Identity |
| BC-1.4.026 | Non-default profiles do NOT inherit legacy flat OAuth keys | BC-024 | src/api/auth.rs | MEDIUM | Auth & Identity |
| BC-1.4.027 | `oauth-access-token` namespaced as `<profile>:oauth-access-token` | R1 BC-009 | src/api/auth.rs | HIGH | Auth & Identity |
| BC-1.4.028 | `email` and `api-token` are shared (flat) keys — not profile-namespaced | R1 BC-010 | src/api/auth.rs | HIGH | Auth & Identity |
| BC-1.4.029 | `extract_query_param("...?code=abc123&state=xyz...", "code")` → `Some("abc123")` | R4 BC-1142 | src/api/auth.rs:948-959 | HIGH | Auth & Identity |
| BC-1.4.030 | `extract_query_param` returns `None` when param absent or no query string | R4 BC-1143,1144 | src/api/auth.rs:961-965 | HIGH | Auth & Identity |

### 1.5 OAuth State Machine (11 BCs: BC-1.5.031..041)

| L3 BC ID | Summary | Pass 3 BC ID | Source code | Confidence | Subject |
|---|---|---|---|---|---|
| BC-1.5.031..041 | OAuth PKCE, state, CSRF, token exchange, refresh state machine | R4 BC-1148..1178 | src/api/auth.rs | HIGH | Auth & Identity |

### 1.6 Auth Error Handling (5 BCs: BC-1.6.042..046)

| L3 BC ID | Summary | Pass 3 BC ID | Source code | Confidence | Subject |
|---|---|---|---|---|---|
| BC-1.6.042 | `auth status` on empty config → exit 0 + "No profiles configured" (not error) | BC-018 | tests/auth_profiles.rs | HIGH | Auth & Identity |
| BC-1.6.043 | 401 + `scope does not match` (case-insensitive) → InsufficientScope (exit 2) | BC-015 (R1) | tests/api_client.rs:99-255 | HIGH | Auth & Identity |
| BC-1.6.044 | InsufficientScope stderr contains `write:jira-work`, `OAuth 2.0`, github issue link | R1 BC-1214-R | tests/api_client.rs:140-143 | HIGH | Auth & Identity |
| BC-1.6.045 | 403 with `scope does not match` in body → ApiError 403 (NOT InsufficientScope) | R1 BC-15(d) | tests/api_client.rs | HIGH | Auth & Identity |
| BC-1.6.046 | `auth refresh --no-input` unconfigured profile → exit 64 + "no URL configured" | BC-004 (R1) | tests/auth_refresh.rs | HIGH | Auth & Identity |

---

## Section 2: Issue Read (bc-2-issue-read.md) — 91 BCs

_(Representative sample; full detail in bc-2-issue-read.md)_

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-2.1.001..017 | JQL composition pipeline (base parts, filters, date validation, asset resolution) | BC-101..117 (R1 BC-125..147) | src/cli/issue/list.rs | HIGH |
| BC-2.2.001..015 | Cursor pagination, truncation hint, `--all` semantics | BC-118..124 + R1 BC-148..150 | src/api/pagination.rs | HIGH |
| BC-2.3.001..008 | Issue list render, story points display, type icons | BC-101..108 | src/cli/issue/format.rs | HIGH |
| BC-2.4.001..012 | Issue view detail, ADF rendering, comment list, attachment links | BC-108..112 | src/cli/issue/list.rs | HIGH |
| BC-2.5.001..010 | User assignment disambiguation, duplicate display name error | BC-113 + R1 duplicate-user | tests/duplicate_user_disambiguation.rs | HIGH |
| BC-2.6.001..010 | Changelog JSON output shape, author null handling | R4 BC-1118 + R4 BC-1119..1125 | tests/snapshots/issue_changelog | HIGH |

---

## Section 3: Issue Write (bc-3-issue-write.md) — 77 BCs

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-3.1.001..012 | Issue create field building, ADF conversion, required fields | BC-201..210 | src/cli/issue/create.rs | HIGH |
| BC-3.2.001..010 | Issue edit, transition field building, partial update | BC-211..218 | src/cli/issue/create.rs | HIGH |
| BC-3.3.001..008 | `issue move` idempotency, transition matching, resolution hint | BC-207..209 | src/cli/issue/workflow.rs | HIGH |
| **BC-3.4.001** | **MUST-FIX: `handle_open` must use `client.instance_url()` not `client.base_url()`** | **R4 NFR-R-B** | **src/cli/issue/workflow.rs:636** | **HIGH** |
| BC-3.5.001..010 | assign/unassign idempotency, accountId lookup, display name disambiguation | BC-215..220 | src/cli/issue/workflow.rs | HIGH |
| BC-3.6.001..010 | issue links: create link, delete link, link types list | BC-221..225 | tests/issue_commands.rs | HIGH |
| BC-3.7.001..012 | remote-link create, URL normalization, scheme allowlist, error handling | R4 BC-1126..1132 | tests/issue_remote_link.rs | HIGH |

---

## Section 4: Assets & CMDB (bc-4-assets-cmdb.md) — 32 BCs

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-4.1.001..007 | AQL / CMDB field resolution | BC-301..309 | src/jql.rs, tests/cmdb_fields.rs | HIGH |
| BC-4.2.001..009 | Asset search & view, workspace discovery, pagination | BC-310..321 (R1) | tests/assets.rs | HIGH |
| **BC-4.3.001** | **MUST-FIX: `resolved` HashMap must use `(workspace_id, oid)` key** | **R4 NFR-R-E** | **src/cli/issue/list.rs:446** | **HIGH** |
| BC-4.3.002..003 | Asset enrichment: skip resolved, id-fallback display hint | BC-304..305 | tests/cmdb_fields.rs:148-189 | HIGH |
| BC-4.4.001..003 | Asset error handling: 5xx, 401, network drop | BC-311..313 | tests/assets_errors.rs | HIGH |

---

## Section 5: Boards & Sprints (bc-5-boards-sprints.md) — 35 BCs

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-5.1.001..004 | Board commands: list boards, auto-resolve, board view limit | BC-401,408..410 | tests/board_commands.rs | HIGH |
| BC-5.2.001..008 | Sprint commands: kanban error, mutual exclusion, MAX=50, truncation | BC-402..407 + R4 BC-1113,1114 | tests/sprint_commands.rs | HIGH |
| BC-5.3.001..004 | Team column parity (conjunctive gate, stale cache, JSON raw UUID) | R4 BC-1138a..f | tests/team_column_parity.rs | HIGH |
| BC-5.4.001 | `IssueFields::team_id` accepts string-UUID + object `{id}` form | BC-606 | src/types/jira/issue.rs:101-131 | HIGH |

---

## Section 6: Config & Cache (bc-6-config-cache.md) — 38 BCs

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-6.1.001..008 | Config figment layering, profile validation, migration | BC-901..909 (R1) | src/config.rs | HIGH |
| BC-6.2.001..008 | Cache TTL, corruption recovery, merge writes, cross-profile isolation | BC-1001..1016 (R1) | src/cache.rs | HIGH |
| **BC-6.3.001** | **MUST-FIX CRITICAL: multi-profile fields bug — round-trip invariant** | **R1 NFR-R-D** | **12+ sites in src/** | **HIGH** |

---

## Section 7: Output Rendering (bc-7-output-render.md) — 80 BCs

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-7.1.001..010 | Table formatting, color support, `--no-color` | BC-1201..1210 | src/output.rs | HIGH |
| BC-7.2.001..054 | ADF rendering: text, markdown→ADF, ADF→text (54 BCs) | BC-1301..1354 | src/adf.rs + snapshots | HIGH |
| BC-7.3.001..008 | `extract_error_message` 6-level chain (empty body FIRST), `errors{}` sort | R1 BC-1201-R..1201d | src/api/client.rs:440-490 | HIGH |
| BC-7.4.001..012 | JSON output shapes from insta snapshots | R4 BC-1104..1118 | src/cli/issue/snapshots/ | HIGH |
| BC-7.5.001..006 | `--output json` error shape, stream separation | BC-1208 | tests/api_client.rs | HIGH |

---

## Section X: Cross-Cutting Utilities (cross-cutting.md) — 130 BCs

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-X.1.001..010 | HTTP client: bifurcation, auth injection, Ctrl+C, verbose logging | BC-1401..1412 (R1) | src/api/client.rs | HIGH |
| BC-X.2.001..006 | Pagination: 4 shapes (Offset/Cursor/ServiceDesk/Assets), is_last variants | BC-1406..1410 | src/api/pagination.rs | HIGH |
| BC-X.3.001..005 | Error handling: network drop, parse_error chain, actionable messages, 401/429 branching | BC-1401-R..1405-R (R1) | src/api/client.rs | HIGH |
| BC-X.4.001..008 | Rate limiting: MAX_RETRIES=3, Retry-After int-only, `send` vs `send_raw` divergence | BC-701..708 | src/api/rate_limit.rs | HIGH |
| **BC-X.5.001** | `worklog add` duration parsing (8h/day, 5d/week literal constants) | BC-501 | src/cli/worklog.rs:32 | HIGH |
| **BC-X.5.002** | **MUST-FIX: `list_worklogs` must paginate until all worklogs fetched** | **R4 NFR-R-A** | **src/api/jira/worklogs.rs:25-30** | **HIGH** |
| BC-X.5.003..008 | Worklog add/list API: duration format, time_spent_seconds, author | BC-502..506 | tests/worklog_commands.rs | HIGH |
| BC-X.6.001..010 | Teams: GraphQL org discovery, team list with cache, lazy fetch | R4 BC-1119..1125 + BC-1132 | src/cli/team.rs | HIGH |
| BC-X.7.001..010 | Users: pagination JRACLOUD-71293 workaround, safety cap, search | BC-801..810 + R4 BC-1133 | tests/user_pagination.rs | HIGH |
| BC-X.8.001..010 | Projects & Queues: project list/status, JSM queue list/view | R4 BC-1132a..n | tests/project_commands.rs | HIGH |
| BC-X.9.001..006 | JQL utilities: escape_value proptest, validate_duration, validate_date | BC-901..906 (proptest) | src/jql.rs | HIGH |
| BC-X.10.001..006 | `partial_match` 4-state enum, single-substring = Ambiguous, proptest | BC-105 (R1) | src/partial_match.rs | HIGH |
| BC-X.11.001..004 | Build-time: XOR obfuscation, `build.rs` env vars, include! + lazy decode | BC-021..022 | src/api/auth_embedded.rs | HIGH |

---

## MUST-FIX Register (4 items)

| L3 BC ID | NFR Source | Severity | Site | Phase 3 Routing |
|---|---|---|---|---|
| **BC-6.3.001** | NFR-R-D | CRITICAL | 12+ sites `config.global.fields.*` | FIX-IN-PHASE-3 |
| **BC-X.5.002** | NFR-R-A | HIGH | `src/api/jira/worklogs.rs:25-30` | FIX-IN-PHASE-3 |
| **BC-3.4.001** | NFR-R-B | HIGH | `src/cli/issue/workflow.rs:636` | FIX-IN-PHASE-3 |
| **BC-4.3.001** | NFR-R-E | HIGH | `src/cli/issue/list.rs:446,449,456` | FIX-IN-PHASE-3 |

---

## Pass 3 BC ID Mapping Table (key entries)

| Pass 3 BC ID | L3 BC ID | Notes |
|---|---|---|
| BC-001..010 | BC-1.1.001..012 | Auth core |
| BC-013..018 | BC-1.2.013..018 | Profile lifecycle |
| BC-019..024 | BC-1.3.019..022 | Embedded OAuth app |
| BC-101..124 | BC-2.1.001..BC-2.6.010 | Issue read |
| BC-201..225 | BC-3.1.001..BC-3.7.012 | Issue write |
| BC-301..315 | BC-4.1.001..BC-4.4.003 | Assets broad |
| BC-316..324 | BC-4.2.001..BC-4.4.003 | Assets R1 |
| BC-401..410 | BC-5.1.001..BC-5.2.008 | Boards/sprints broad |
| BC-501..506 | BC-X.5.001..008 | Worklogs |
| BC-606 | BC-5.4.001 | Team ID deserialization |
| BC-701..710 | BC-X.4.001..010 | Teams |
| BC-801..810 | BC-X.7.001..010 | Projects/queues |
| BC-901..909 | BC-6.1.001..008 | Config |
| BC-1001..1016 | BC-6.2.001..008 | Cache |
| R1 BC-1201-R..d | BC-7.3.001..008 | extract_error_message |
| R4 BC-1104..1118 | BC-7.4.001..012 | JSON output shapes |
| R4 BC-1119..1125 | BC-X.6.001..010 | User pagination |
| R4 BC-1126..1135 | BC-3.7.001..012, BC-X.7 | Remote links, issue view errors |
| R4 BC-1136..1139 | BC-4.4.001..003, BC-6.1 | Assets errors, config errors |
| R4 BC-1140..1178 | BC-1.3..1.5 | Auth OAuth state machine |
| R4 BC-1138a..f | BC-5.3.001..004 | Team column parity |
| R4 NFR-R-D | BC-6.3.001 | MUST-FIX CRITICAL |
| R4 NFR-R-A | BC-X.5.002 | MUST-FIX HIGH |
| R4 NFR-R-B | BC-3.4.001 | MUST-FIX HIGH |
| R4 NFR-R-E | BC-4.3.001 | MUST-FIX HIGH |

---

## Traceability Gaps

The following Pass 3 BC IDs have no direct L3 mapping (traced to existing broader BC or absorbed into a parent):

| Pass 3 BC ID | Disposition |
|---|---|
| BC-105 (partial_match single-substring) | Absorbed into BC-X.10.001 |
| BC-314 (--open assets color filter) | Absorbed into BC-4.2.008 |
| BC-505 (parse_duration combined units) | Absorbed into BC-X.5.003 |
| BC-1099..1103 (duration proptests) | Absorbed into BC-X.9.004..006 |
| BC-1103 (proptest regression seed) | Absorbed into BC-X.9.001 |
| BC-152..154 (config validation points) | Absorbed into BC-6.1.004..006 |
| BC-1201-R variants (4 sub-BCs) | Absorbed into BC-7.3.001..004 |
| R4 BC-1402a,1402b (try_clone semantics) | Absorbed into BC-X.1.006,007 |

**Unresolved gaps**: 0 — all Pass 3 BCs are either directly mapped or absorbed into a parent L3 contract. The 541-BC total includes the 4 MUST-FIX forward-looking contracts which are NEW (no direct Pass 3 BC antecedent; sourced from NFR deepening passes).

---

## Coverage Statistics

| Section | BC Count | HIGH | MEDIUM | LOW |
|---|---|---|---|---|
| 1: Auth & Identity | 57 | 48 | 9 | 0 |
| 2: Issue Read | 91 | 76 | 15 | 0 |
| 3: Issue Write | 77 | 70 | 7 | 0 |
| 4: Assets & CMDB | 32 | 30 | 2 | 0 |
| 5: Boards & Sprints | 35 | 30 | 5 | 0 |
| 6: Config & Cache | 38 | 33 | 5 | 0 |
| 7: Output Rendering | 80 | 66 | 14 | 0 |
| X: Cross-Cutting | 130 | 115 | 15 | 0 |
| **Total** | **540** | **468** | **72** | **0** |

Plus 1 NEW BC (BC-6.3.001 / NFR-R-D) = **541 total**.

Note: 3 other MUST-FIX BCs (BC-3.4.001, BC-4.3.001, BC-X.5.002) are included in their section counts above.
